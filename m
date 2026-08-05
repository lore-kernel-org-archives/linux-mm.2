Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE26C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5956B007B; Wed,  5 Aug 2026 09:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA52D6B0088; Wed,  5 Aug 2026 09:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAEB6B0092; Wed,  5 Aug 2026 09:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7C76B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:01:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DFBF120485
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:01:06 +0000 (UTC)
X-FDA: 85067226132.23.6D0DADA
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3923C40017
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:01:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785934864;
	b=qlkU9ctjGp/TVGWiboceUCY4+Pcimpa0IK2rEJtP1fsBg220Ze9Y8opZ/YSYHAtUn8PYXu
	o7GYtZOgkze2hzjGd3summsoSZHRWGGlSNTW0gnVfdtdpTkbox2XnGIk+NpeKxHEJHAYaB
	VKcwabnkSnjKjEaRfRLV0a+pP6r1P6U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785934864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VapmpTf0OtCtuHRFxN7OrBpIO5TwqnlrSIz4892HLBI=;
	b=1r9pHlUJIKal7NudsUv33i2PFvUZ65NcHsFKnx0RxP3quTMKuV3CADvg8OD276Idw+K1FF
	IiiraDwHIKonBqv/U/6dcfYbFpx0Is2lr+vMXE5wNJU9rETtVp/bugSqpDAu4BkCDJgIwM
	x7mxJYs1bys2TMtkRk+QCbbZOvaVgds=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hFVrw6DhNz52SGg;
	Wed, 05 Aug 2026 21:00:48 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 675D0hrM029962;
	Wed, 5 Aug 2026 21:00:43 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 5 Aug 2026 21:00:45 +0800 (CST)
X-Zmail-TransId: 2af96a7333fd94f-8e0ab
X-Mailer: Zmail v1.0
Message-ID: <20260805210045739XrZB2Gyax_ujkhlLwsFAN@zte.com.cn>
In-Reply-To: <20260805105927.41987-1-hongfu.li@linux.dev>
References: 20260805105927.41987-1-hongfu.li@linux.dev
Date: Wed, 5 Aug 2026 21:00:45 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <hongfu.li@linux.dev>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
        <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
        <mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
        <alexs@kernel.org>, <si.yanteng@linux.dev>, <dzm91@hust.edu.cn>,
        <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hongfu.li@linux.dev>,
        <lihongfu@kylinos.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0ga3NtOiB1cGRhdGUgY29tbWVudHMgYW5kIGRvY3MgdG8gcmVmZXJlbmNlIGZvbGlvLT5tYXBwaW5n?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 675D0hrM029962
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 05 Aug 2026 21:00:48 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A733400.000/4hFVrw6DhNz52SGg
X-Rspamd-Queue-Id: 3923C40017
X-Stat-Signature: h9r4rcx7b8m88ndaaqa9ykpsehw8wy83
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785934863-854179
X-HE-Meta: U2FsdGVkX1/7c+rRISY9ptUMilewxvPxcRp7xKXPCnSylOdqYkErxk2VlMp/bcV8mUdHAw7Dz781izgjOsk+gTEuhYVTIbVZMT9liNmWtu1KKQTCPvAQhAjJLQWko+iX/2hUdDkDSJiQXsqTcOi+aE9zmr/OiosG9VRjaxkyWjUkFLr28iZiZmssxmSwbX58/MdxhvovQw6mvNotd6m+90IcfQfsKKXQWxeAtGXXE4jNqEdCe0JCO2g8h9/i1l3T8u4wYfaXG9Y1gyTWz0b0kd9j4/VaV4afKpoE55jY6jRaE348MpaOx5+H4tSVkE7Uj9cBpiDDJ4SDv9Y7DxBtMembfC3Fj9Nkl+n1H1/LrE14K07aDUW3Jtjl6atB15Ayr91kSOjjytV9Nd9Lmnl3VrlOzP43rwixWM5Bs0aaH5AI2rT9+4Mh1tkDzoXfVo1cqDAmZrlVIA/jAvH75YlBIWJ2RPwcdJLgJohFbOJFcxbha3tpum5mp77s0jf/HnZIVHBegbd9/jz3ecXs3vj8JfaW3OqXcaJCQPsAFvcx0ePmVnUpdqcvmMmrBqaAp5ZEPm++ihRaGhzDU2tXO17ZkJOvxUclYV0EZhGs+xuUCXb4KhwpFWG2KVxi268BHO/IE7Fux6t2KY1q3f5U7QR/+jiJOk/Us0GuvFF8U0ZxQ5MCcEO/rgTY6f8HzlpiYkwNY4Sf+UhGJ0Lxs+/bLz/kS7Qb0513YARcDHrskiWXan7ugKI2yFGSTZ/bupJsKv9jLzXyZaSfH1IqW4ETQW49X7K0kTYvS501wm3u5FSnhb2ur2VUWYsyIZrEqDNsvlogqkkq7P6d6HKRxtcQMN9RM++o/TvcnzrCUO52Fsiup+6NkVCPzIo6uleoUOYcwMUl1vEZc6LWrjcL58COFT51W0x6XR3GySvANrrhbnuqVwUqQqvble2czJ3xhIB4RRvECcJc8E2YtryHS/vJFAc
 IdAE4ZIg
 zn1kGzU5LIOZeikcf4ytNb6BMPz6bBymaCHGakWx14fKI2fibIl3RCA0RvyARIEQfcbtOVefLQxOJ6CoPPhSRsMQLIwOr7R1ITb1IAa2qqvznxrA/k1JBh6MCWsnYhEZq2/zNRXleqy1XBEFdI9r5ywYwdNsofckwAn1U1NnyEQBLXLz7buW5rG0dawYGO1DgcaVxOG/Ui2HpltXfWfhWQiGPkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The KSM code already stores and checks the stable node key via
> folio->mapping, but the comment in ksm_get_folio() and the reverse
> mapping documentation in ksm.rst still refer to page->mapping.
>
> This is a pure wording update to match the folio-based implementation.
> No functional change is intended.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> Documentation/mm/ksm.rst                    | 4 ++--
> Documentation/translations/zh_CN/mm/ksm.rst | 4 ++--
> mm/ksm.c                                    | 7 +++----
> 3 files changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

