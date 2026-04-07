Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AC7105D986
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7496B008A; Tue,  7 Apr 2026 17:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77666B008C; Tue,  7 Apr 2026 17:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EB66B0092; Tue,  7 Apr 2026 17:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A736B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:22:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 425BD14068C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:22:17 +0000 (UTC)
X-FDA: 84633033114.18.2202DC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A9CA40003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:22:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWKwdp+E;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775596935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08oaNpMk0ZvV0Wt0jg05aCMOjVRxzil+ZF5ABphc55M=;
	b=vyIeOHtaulDDo4d6IdWRUUjRiu2AumK6DyPKtqpwCz9zuG8bTgvN0+uYBZ2/GUbelpsqj+
	1LDbF9fnXZed4ninuXiksXZtcww+wG5akWm6uDNnH9ZiaZJBW0EY3FVceOwPMURdY4CJDJ
	1eEW+Vv8uy8w5zQ6xcIXsBYofikLTmE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWKwdp+E;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775596935; a=rsa-sha256;
	cv=none;
	b=Nd3O0hWZcU2tXoVc/Icy43g4JUDkDHwxyahL+FtSRmaTXXN2s0nEZ6YdPPo4VnjIi3l6Ht
	Awlit8SE3hcmowU4jhwEOgf7h97fRUbA108LjtuHBP+pC8HcoDqnsOuwak112bNAt6xgwP
	5YUDPGE4e64YFNW+OkUzkUy3KzLfbkI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775596934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=08oaNpMk0ZvV0Wt0jg05aCMOjVRxzil+ZF5ABphc55M=;
	b=gWKwdp+EGtgx2xwbn8QHqmq2SG1ghuggMHDXTzgehm5+taxaqPL/QJ7yRDoCUDc5yACH0k
	ESp0gxNxS7NfttSLg+XK9axHs349d6FPqs/4y/EGYVtbTZTLwMLaxPFt9VTooQPlBIOqfn
	r4tUBv88o/SkRGWFmlBz7uHsci7NIOA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-mQHGT6mpN9GXzYVFdNKmBw-1; Tue,
 07 Apr 2026 17:22:13 -0400
X-MC-Unique: mQHGT6mpN9GXzYVFdNKmBw-1
X-Mimecast-MFC-AGG-ID: mQHGT6mpN9GXzYVFdNKmBw_1775596931
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 534FF19560A2;
	Tue,  7 Apr 2026 21:22:10 +0000 (UTC)
Received: from fedora (unknown [10.44.32.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5EEA4300019F;
	Tue,  7 Apr 2026 21:22:05 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Apr 2026 23:22:09 +0200 (CEST)
Date: Tue, 7 Apr 2026 23:22:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <adV1fCyvANv4h2dH@redhat.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
 <202604080450.mkKRp9Mk-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202604080450.mkKRp9Mk-lkp@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: xbbU3UYelGdIuCOMoCKKhIVh6F--HDJPfHbkGE8uZhs_1775596931
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A9CA40003
X-Stat-Signature: sox36zhak1n155a197e5sgyfnsmrxdq9
X-Rspam-User: 
X-HE-Tag: 1775596934-827931
X-HE-Meta: U2FsdGVkX18jhvLuvafV/2rALMm2Fn06wzGJZ2zzyseUtradxepHS0Lj9amWvzEeKkB0isHXfG6e20wHYquMzPwYlh88bMpuc+VTLhNFDs9gm/daXfSYepsSB78CBEHRgkaYUg8IQicPIE7o/MPOZhD8kluuv6fnmQDw9da52Iwm18grFd2aqOiEyrMwVOb0y9dKR6xTxXJ7KNcQ6pnFS2EQwUxkbK2rewbe56exUmfTdnb6qAfzd6kmHabJAZgkhC4mCQkeR+IuzRxj9A+AKdIOiLQ8VysnSkuuA1FVEGHwLlouVw4I7dHZ8bL4CX5stb9jh5l2xZ3lovndEm8LtBLxF2WdbW8FGMsBFVFUvVKczw5XtM97Th6uHG6e2pRn8cls96IuH14hWFzinPPTjD46oz57C0vfIV6tGmOgNv+iMoAOiN2FNpSQDuc104LNwvKqLcsLBDfPrAegsR4vx83ArJkw388YsOLYLT+CLn+6C1J7cS7t5y6UUpFbMR3b58noha/upxYmKk2BMWEehQoowruu3EzCsVK021D+y0kvYxoicFqwVMRbUppXraV9CTHUbfKyajDggJzyMak7w7RIiiamD4cKMG+hAxNu3PNDM+xaL16a8KRcI/t4JE7CLXpwxAKb6GgD6Ww+ytVvnlNGicRCHp9Blz/qiYXXYDpm1I4GR4kFGzf91aSciw++d6qi2GWrLhDLhgyPhbpPg4sakMTy07HKK6stBZW8U28lq+/5P7o58drWR5MoJVz3Bub/mFqwuvOhYs2BxO2KA4NXeeBeEQ19dGPnD8/3reZLQjiDrlMwTOl5LVxEdNYbWMMJgA3xdXm0xc3LLGW6VRfjoV6q8+QdlJ5vvU0uTs7Cv0k8NbSjSKLoxay+1jxBt64XogjyRWg5HjNfae3tR1YKbxGVwC++sELN+YaMBYCCjEm6fpjAIP7WQhSqvasTFXo7Eqc1r2ZHWJSMmd3
 D3fk+s3d
 IsNAo7Jl2fx3P5Rw4LQqpCNAbr0Is4FEXr7HJc/sGz98TokvPdYtpT0iTzW4F3U16xX1GEDyl5o+dnCKwKQ7qa1IES7UaMTV6rDaOJz275B3KKdoMDvWxQGFbEN4tduSmV8axDcsePU6oO+ihlrdxuj+iktJBIqcnTNJ0wuGTlP6ObohHpjXRt7geTg5NaftL6SoffAkVnsIZru7kDFfBWbrQ3MGEBL2FChIFU7geas7OhvlKmeWD3zdHgAEmY/jCCDBFUIEXR0hSpQN+cm6QsVQ1ve1RLrDw3CN3g1JYzOG7cDrkrXEbDeI/J6e6C0AHan85oJBZzIy+O2KzkBVa5d+ZgkAo0GdZig8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08, kernel test robot wrote:
>
> kernel test robot noticed the following build warnings:

...

> sparse warnings: (new ones prefixed by >>)
> >> fs/signalfd.c:53:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct k_sigaction *k @@     got struct k_sigaction [noderef] __rcu * @@

...

> vim +53 fs/signalfd.c
>
>     50	
>     51	static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
>     52	{
>   > 53		struct k_sigaction *k = current->sighand->action;

I am going to ignore this new warning...

Yes, task_struct->sighand is __rcu. Not sure this annotation makes a lot of sense.

In any case. current->sighand is always stable. Plus task->sighand is stable under siglock.

We have a lot of (correct) non-rcu deferences of ->sighand.

I think that only lock_task_sighand() needs rcu_dereference(tsk->sighand).

Say, __exit_signal() does

	sighand = rcu_dereference_check(tsk->sighand,
					lockdep_tasklist_lock_is_held());

To me this just adds the unnecessary noise. I do not want to add another precedent.

Oleg.


