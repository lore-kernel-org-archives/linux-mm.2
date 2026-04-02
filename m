Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAF0111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1996B0088; Wed,  1 Apr 2026 21:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79006B0089; Wed,  1 Apr 2026 21:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E5A6B008A; Wed,  1 Apr 2026 21:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89D966B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:17:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E176140272
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:17:21 +0000 (UTC)
X-FDA: 84611852682.21.6133006
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3682A0013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:17:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CNqm4JIv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775092639; a=rsa-sha256;
	cv=none;
	b=u4rBLxCiqnbM27jarsjkaJZHgxfr/7dXB3ggvrez2uT5rMF4faFuJkPK0wi1Qxj5hovKq2
	JbFwqt/Rezhvgihwo0XE1+vUnwcUNkxnviNvobpRhl9/ZG7yM0HqSrZnVBPvbSR5yevq6p
	hUn4Xeh2KELswLsdUqRbuKUvhYJ3QmI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CNqm4JIv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775092639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESlYIolGBSFH6AWVL5HUwn+hc6w8VfR5MT+DXBPeS+0=;
	b=gOI4qXEjYqrKpMUNdW+Yuj+vfncupU2bhXnin3jWCutFRSd4A+ftj0E1OmWpJvcsvq16Tp
	04ncGgL9r27StFGg5Wi347akruYHc1+ti0mcsYreOm0KvM+SdDfUdP8q97m7lqZE9VGIiD
	k9zvSUUAkosU6x096xW8AGYY8cyBnQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775092638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESlYIolGBSFH6AWVL5HUwn+hc6w8VfR5MT+DXBPeS+0=;
	b=CNqm4JIvhdhzLgSz9i5ArIgsdfIMvrWYjXOuba/z0/uZ0gTlBh7qRPSrypEWsryYa5mUEp
	FG/Al1a+RbRnX0SSi4afTEx/6MCkAabYalS/T67aC30MimXDvj93TGX1NlkHtcmS+wtpS4
	M19V0+hZojSzd11oQnkEoEnnvGAGXks=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-1QYFvXvBMOGBxgNU06fP0A-1; Wed,
 01 Apr 2026 21:17:16 -0400
X-MC-Unique: 1QYFvXvBMOGBxgNU06fP0A-1
X-Mimecast-MFC-AGG-ID: 1QYFvXvBMOGBxgNU06fP0A_1775092633
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BE9E1800281;
	Thu,  2 Apr 2026 01:17:12 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.80])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43EC430001A2;
	Thu,  2 Apr 2026 01:17:00 +0000 (UTC)
Date: Thu, 2 Apr 2026 09:16:54 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Mark Brown <broonie@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <ac3DhrTIcxvAki3X@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
 <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
 <c6976e34-54b7-42a8-968e-9ae967c52968@t-8ch.de>
MIME-Version: 1.0
In-Reply-To: <c6976e34-54b7-42a8-968e-9ae967c52968@t-8ch.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Lh8NmVM65wwPpiujxPHQVK3HYB_0CZ7hm3E0h2s3260_1775092633
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D3682A0013
X-Stat-Signature: zqpfsperks5jn65u6swjzitz1r3q8yxr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775092638-50449
X-HE-Meta: U2FsdGVkX18/Px7J98PNQLyMS9SN2hBypRBn0qBaaZPRClKfGTqjLnUsxN98MUX0KiDUcOg8gogGnZOJs+agrUA3itApz5Brijqupo6rLIaEW7Sd1ORx9YzUB9PJ1ni+gdnkTA7ncb69572SfYeb7aetFFBARl1DsDiE9/tfOMAxX5J4ow7fWxJXmiZgJPU3ZI1kIH5S4PjnJudWjHGmc0Rs2LLn9XvjsvBND1DShL/qn9l4chDIk1HqTn3pUnc228SMKIcR0NIL7EZFKBeBXZ3lhwMbgWVpcMQPimX1rqznxotBKecHvmJKQzZf1SmW857ODIRmKl7pep070ym6a54dxGEULXVjrJg0j5KAaOLosKg6BUegtFlX6A7SL6iKY2R31i1MXw1qCR1k4xzgIrjnJ359yzyoSVfka4GYuu6MbO/lUHF+haFzZFx4VUrPPB56BOS/ufjik62KVd4gea+V04hvrAiYUhBsb3wuMpuaDYMgYs9AM7cRXa2GFYayAf6+yL8S+TGYRn1Kk3Bc5ROq4o8H1SFwlBK/QGLQ3GLNY4IDuuREhxw6OAEn/e4V33C0TcXDg4L7olXb4iPeJoCwPPHVCM5TNoIRewo0nzlEeVV2egfKFiA55qmemmS6Cqcvsoe/+YLpNnLbVQQ1D19rz1GQDWACgTJwuzm1ku3ynm6dH0K6nEv1a41n6sChcZvkgSQfgmUbIQxa32ZEfhjRHkScVrKx7vCpTrYSUyqP2W4aNlThL9PS4ECJarwd4fYwbbKj+7YRxfAwcYgIbKyeqB1hEYIT5AxPIXyknpAICX9vh/L/GRlImrtbJUwbIJB0MIUzVbG12el1T8fl6UI84UutPIhM8Vy2NnSAWd2UzqOAJSwRJjZaHbfuyG8QpEem/3dWS1VmSEQHS9B3LGCO6Lm1qgSuqQ022y6Bjc5gHziGbrWfpOuiaAkFnN2wjQPDPnkjzV/JK2+yY/K
 DWeYnqza
 iuyzF2BcXbaaNqa/z3sI9jj/m7MmuVmOZtJRif5e14a9IWOwLOoG3WZPqAkqn9P0y1UY6nsLPgG0oK3sJbaEpBbcZlBL4kbMDdc3bIXvLwjsr2dUMNPOnk8ViMXxvqYtJZYoWqW9x3b6oRelnPTy+33bpgZdT2ZudISCmlAjhzb0VTyOgjhS7XyQueowXsWQeSDIsy09YJiNSOasvpbwOofkOr+16u7vBmkma5Mtlpj40JlN2x1SBAcY8TiTZH90eibin7b+0powvHJ957ZgjzKoSKhfpJ1Af7b4/UWbSvsROXBeLGp0Yu2aPqstGHkTJvdpipWwy8fRJWhs2zDtyYAVP+ni3DJUL5P0l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 02:08:53PM +0200, Thomas Weißschuh wrote:
> On 2026-04-01 12:03:09+0100, Mark Brown wrote:
> > On Mon, Mar 30, 2026 at 11:15:00PM +0800, Chunyu Hu wrote:
> > 
> > > The ksft_exit_fail_perror function previously only accepted a single string
> > > argument, which limited its flexibility for providing specific context to
> > > failure messages.
> > 
> > > This change updates ksft_exit_fail_perror to support variable arguments,
> > > similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
> > > compile-time checking for format string correctness.
> > 
> > This is causing build regressions on the arm64 selftests:
> > 
> > /arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> > In file included from za-fork.c:12:
> > ../../kselftest.h: In function ‘ksft_exit_fail_perror’:
> > ../../kselftest.h:427:13: error: implicit declaration of function ‘vasprintf’; d
> > id you mean ‘vsprintf’? [-Wimplicit-function-declaration]
> >   427 |         if (vasprintf(&buf, msg, args) == -1) {
> >       |             ^~~~~~~~~
> >       |             vsprintf
> > 
> > This is because za-fork uses nolibc which does not implement
> > vasprintf().
> 
> We can add vasprintf() to nolibc, I'll send a patch later today.
> But it will be fairly inefficient, as our malloc() implementation
> is *very* simple. Not that it would matter here.
Thanks! 
> 
> That said, I am not a fan of the new ksft_exit_fail_perror().
> What about this:
> 
> #define ksft_exit_fail_perror(msg, ...)	\
> 	ksft_exit_fail_msg(msg ": %s (%d)\n" __VA_OPT__(,) __VA_ARGS__, strerror(errno), errno);
> 
> A similar treatment might be done to ksft_exit_fail_msg().

Thanks for the suggestion! I would use ksft_exit_fail_msg directly for
now, and we don't bother to make it that complex just for saving two
parameters.

> 
> > I need to look at why this managed to pass the build testing I do in
> > -next...
> 
> 
> Thomas
> 


