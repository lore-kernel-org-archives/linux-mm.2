Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DFCCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B4B6B0088; Thu, 28 May 2026 23:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC256B008A; Thu, 28 May 2026 23:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D19A6B008C; Thu, 28 May 2026 23:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9876B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:14:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB8B640B32
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:14:19 +0000 (UTC)
X-FDA: 84818989038.26.503A567
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id E487040005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:14:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=hSygT6wp;
	spf=pass (imf27.hostedemail.com: domain of niecheng1@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024456; a=rsa-sha256;
	cv=none;
	b=2QPDFVUdZjqQLevCRrH9kMwLbOYDmOw3ESMK/rv1RWyzQS+ZvqKNccdAPjUkx3Qdhy9Xis
	XjUw3KOc4mg6P01Oi0ER14CrmrNPXxuQ9/jPZ2dTgfbsSd0C51FVDSAgQ2C2Nn2sJeE2v1
	qlsisfaW3OtHQGnNM3e3VQAf2dLpB8Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=hSygT6wp;
	spf=pass (imf27.hostedemail.com: domain of niecheng1@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CU69WStLtGAWmV5p5leKWoSrd8qZoQFw5WIljhNTZh0=;
	b=hBdy4+3pw5XVXWGdNdmGai9AiRC8aUU/d76P2VIk2HeMBBLdlwgZAe4aDPuNqFF4Vbqfxo
	NrESZvLQ7SZiWLTOQoxXx/BASiIzIxNZvQTx0NcE8Lvq+a43/AMKf1VsOvfVw7MS6d6tan
	+iKNthmSeK+EAeyv347K0eW5a7xLT+c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780024439;
	bh=CU69WStLtGAWmV5p5leKWoSrd8qZoQFw5WIljhNTZh0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=hSygT6wphI3wHyqn2S439qQWo8bidGk5lgSBf81Q+ScAh8Aki8SQDpY49m7swqhEY
	 CPP2ODlBkppIECSuWgON5aDMWCDN65Tzhcbe1sYxm3otYaWxg1YYHw9jPYYsSJ3lXt
	 rMvEfbe4IdiNcEhDHmF+u69nzvbV+fpa7H9Lf1rE=
X-QQ-mid: zesmtpsz4t1780024428t02c7e8c4
X-QQ-Originating-IP: QkKCqQClWI3qa0TeV9Rf59jWGZpwIZjpbR9H8YeNnRY=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 11:13:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15054842607548688614
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com,
	shuah@kernel.org
Subject: Re: [PATCH 1/2] selftests/damon: fix DamosFilter memcg_path assignment
Date: Fri, 29 May 2026 11:13:45 +0800
Message-ID: <26BC7B013363FF9E+20260529031345.1560812-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528141718.153376-1-sj@kernel.org>
References: <20260528141718.153376-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OTaQrRjuGKLtqc26YYXlCWeHHJsRFoYs/0zz9UziTbwRPwFDTnbN423Y
	qw2PULOGw04SIdsw0ouoK1RbQqYKPhq1GuHkUL2VyDzBKcCEexP5AVxgb5WTiRyL9jAkdEm
	Z/ZxnOdUvGXFS6UqA2SYv8j5UmHyXScHkMgAHZTkJNeIv1LxdUnVPI8Ynm+k50CIq9RKoB6
	8n7y2HA6xwW+BJ+CfVudFcPaFiB8n9HSogy0LIJF0aohuZCD+LH7Oa1BYv41AJx4l77geoh
	08DgCG/D7ICXnyWgZMQ7YasGQDKPxiDLZgfH/VrsaJOXjISiaz613fYSeYLmBecQe/DLoA+
	y4ixdjGh4ykf5zQofyOQQc8wiKakOoO3kMS3qRBWRoiOHbvhVbnoaErkxOPIYpEzKdaAVtR
	QnrHJF888+GIhVC5Y9KqbJD0fDTIzQ1C6dDeaO0UxFV2AleH6hkoYCQRYjT5DhcZ4zQDN3p
	jzzq3QobW/nnB3ZPb9scHrUzja5c7mkMBXnFWSQd6dWLKuqmAvvii+yvt9OqNc57oSD30Si
	PeNdHAP+E5zS+43d4uaHnSJd3uHbWX3URnSJcN4IgL5fhIu4vi6SZQZDLQjM6j59OcE5i37
	5VvK3DJFDxPuiIGoAUTztBsfFQd5u+fo7KQ5hXDdtBdvEcqyP3aaXeAwExV33blpqD11aPf
	a01Wm4oFCP0fiWleJikmzMkCvvcaw1nlV11cG3Sf/9NaUmvrELDeL8gSvfdz9mRi19w1iyj
	XU+DKDFY09VXJEXmvbj1re2iuLIA+4pClTpPV7FipJkE1y2KkiCiPLBDnZtOx6nJ6vpZBua
	ootFcF20rM2ZOT+oapxZQkmAO5QoNAtWVtNcNnqCk4l/89EWfvVlBT3lJKyx9hZEp/Hn5qi
	OMke4sPimc4/IbAL/0sm3keu2PbM2xfGyqzRWRCoN2CHbDOc+fN9ryjyJbXFh64TFmcq70x
	8guY0DoDUBMsHQEYYm+0zNBfRUz3ssnNpyyWVIMvdEd1qb4uZ0jlmPnBpVPKrt/WE033rTi
	IkUZnSr7vx5pxsrLop2b2yZoVtajM=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E487040005
X-Stat-Signature: y6tx8t1598s6xibe6whmbkjwa9bymfuf
X-HE-Tag: 1780024454-835406
X-HE-Meta: U2FsdGVkX1/r5iPHzdHjH3Cdm4P55aRWl9cH1qhTyzRf5nLDN7Pq28l9ugZacv8+S+ODjsvKaddIxZRaPJaTavdm28uyTksBmhisXTXLfhuxtzb9/vZqVDBhbavHF7WcvwodMZE2F29K2gTUNi27eVwTVNOatfKEr646ObWtzc/7Nm2UFZuR6PYFoWDNNJnutJbvHjkHxvct1995PCxBWHDoyAvjO2imV8VenMm7dFo5fFeBNAvCMBH2tV9NFDcGpBVvTGx4C/Z6S2CxnqqJrzvUt196LMlIkq0vTjtbuwff/8r5jzK72DUhzngsJC1NS0WxGq2QV7yAUYzq00ia/pi4h9Jli05nVHVFKAUKmbaUClZIU3bqKE+iJxuq4ryKxsaMPyPdlFK2/tdibEHIMFG0sPAj6rlF2BPf3hu79DQMVuzwVlGHmI2dmyQRONvXXwi3NAJDMCgVVuUfF/H2h07okbiNZoclYfnWq4IpnL11OaIAOx2aTDjQ7Ii1/J41BUCQVQmnF5bac1S8UgR134VwRKNZa41iO8K27ZKXjDiye7RfZkGpckB2IZ16JS1tLj51SU3Bi8fks8bMjezpTjHti0G4CXVlkRmu5nPMU80EYe1ev7I7z0FbqRGr7fHyC3L/Ua2rWHbX9Und+SQG/ooyUtC4Wf7NBh6bB/5RUXm+UvyAD7q+mJHw5KfHDsqPs8PmlJ7LXKXhRqihHHtv+Hf+aDUASUy+fGENsrwUS+FWKBVlihSDXbMskIzrlMiC/4wo/iTF2Yr1INJ6DqlVDXV1hnASEP+O/LUMsc5Psfw3+cTBrpnMkar8exm9sA358YycNRHahj5/Rr55oc2FDszPIyw37NPmhhAoo2/4IoIHDBQO0w8xzlkID4YQGthxc++Y27uHgKXRUDgE0pQ/0V737EZxVqwKvxu2j12alczrnLrgclULH55rW30FGEQkJCvQ6Zh6pPLJ8ktTUY3
 I1lpsV6f
 58K0kg/6faAsv1EGQnYPtK4oxHqxHrsVL6vm9IPZnEhRnJ8vQIknUpbzKFjO8tNoJhFxr+T/b8RC/eAc3owiqHzHl0r3YnhdbC7GtnBhpggdxOvVMTqvK0i9mRxfQFr1cSWGMlybs/MjEeAKBluYke09k3ppfozZzlbpbHQzDqRrB/LalpFlWgvfHhCBmz6dhfoHGDE8iV33A4trx/nVx+hmV6lxg8ecLwwGIVwfI0GLxNkXHJCFTLxL8OshQx9Q9NC12uNdx0DssMIxrhOuY/PD9CsCeoIZUDakwCra7R8TEJUfupz3GXtvwS5DDH6koARmakcVeWpGnhl0v0lAXHt0Ssyh4mRaWossx6NWIGRTjPa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 07:17:17 -0700 SeongJae Park wrote:

> Could you please update the subject to 'selftets/ddamon/_damon_sysfs.py'?

Will do in v2.

> From the git log, I found it seems you also use 'Cheng Nie' as your name.
> Are you intentionally use 'niecheng' as your identity?  We disallow
> anonymous but allow using known identity, so I'm just checking if this
> is an unintended mistake.  Some of us (mm community) prefer real name,
> though.

Sorry for the confusion.  In China we usually write names with the family
name first (Nie Cheng), while the Western order is Cheng Nie.  I had
also used "niecheng" as a compact form from my email username, which
was not ideal for upstream.  I will use Cheng Nie consistently from
v2 onward.

> The change looks good!

Thank you!

Thanks,
Cheng Nie

