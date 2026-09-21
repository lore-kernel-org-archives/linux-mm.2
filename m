Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4C5C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDC16B00C9; Mon, 21 Sep 2026 10:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5E76B00CB; Mon, 21 Sep 2026 10:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC096B00CC; Mon, 21 Sep 2026 10:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 247026B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:29:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADFF8A018D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:29:25 +0000 (UTC)
X-FDA: 85238002290.14.B48FAC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8FE64180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:29:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYVxQyd1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790000963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtrGPJYqrgm8GjMEcC9ZPfIvGFNMVcDzHftdMMzdcwQ=;
	b=tsiGRcfCdiPcvkQDrxlI4OE5zXXJVi8dtz0SSq3lSjF3OIFxD6YgOSUbeV+Wf9Yi+iLZGH
	E29qOz7Bi0xDEu+UxjxiPOIDGAEp1v+VSGKNzM5T2U+VAipLlVmObRzTKc7uT3fbfDDFPq
	414Ern6iANxFt+i2kigcFTD223GcLFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790000963;
	b=GmNEUMMDVCi7XCBVlE8oRUWvMxsizHzkfHqZaQ+TX4dUojZ00E7+qX0m0B/mc2FhLMk16E
	71edbPCKt7K5++5xWeKLrQIfDDrRpO8PvE1/NgE2mTNLqYHRyrXbXPyIDOj2ksjUZVdi/k
	3F9N9FD1m4YdSsO5jZFu9TZEF3H57oY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYVxQyd1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XtrGPJYqrgm8GjMEcC9ZPfIvGFNMVcDzHftdMMzdcwQ=;
	b=YYVxQyd1g/uj79qGLpY61jasyvqX+OwOS6yTZ5rL5MD3/r4+61Wdsjp3Mo8KP4yF64ZSU1
	yE5VsOum31igaVCgurAeWw972/mFDFN4XqVUUYk/uVvc3rixAH9JRmtA86cwIX2nEBizqw
	UU0uZ/ccs1zCkCzQwPdmht/S8uzc3i8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-5rPfoTMHPbmai33uCsAHrQ-1; Mon,
 21 Sep 2026 10:29:14 -0400
X-MC-Unique: 5rPfoTMHPbmai33uCsAHrQ-1
X-Mimecast-MFC-AGG-ID: 5rPfoTMHPbmai33uCsAHrQ_1790000950
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43C62185126D;
	Mon, 21 Sep 2026 14:29:10 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 37FF61800446;
	Mon, 21 Sep 2026 14:29:06 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 16:29:09 +0200 (CEST)
Date: Mon, 21 Sep 2026 16:29:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 15/17] fork: use SIG_KERNEL_ONLY_MASK for the user
 worker signal mask
Message-ID: <arE_MRAFmuvWsM82@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-15-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-15-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: zNJzFkYZOp92AsxwktSv315fYTREkXRro2e4rX70fWg_1790000950
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8FE64180002
X-Stat-Signature: 9uxkktpz771guzuyqmos5zoph9dngq1m
X-HE-Tag: 1790000963-407930
X-HE-Meta: U2FsdGVkX18V3qg0DsN63s/N+/3TqBTKf7XxKcnNjs0NX3gAiTMd+tanITKV6frL5FL9enXKoBSdXh5ZbeHRM7E9WxhN7Ck/PX2OLQIwWzqVSaXDvNaJUYVUywB6Tvpg1Uu5FciQeSJe9Qf1G4l34pI1hG58c8oGm7oY5EFVC7sn6oiWulVCkjqNImQO8eWsIlZB42Xtg/LGr9UESfWCACg4GrUsC6YtvRSQVC6LA2x/kYNSClMN3ydAiPv9t67hPHzxeswOQxKpaOrr4o28BHpE0T2991y8J8accqXo39R/jILR2syG0Xs12lDlMbLvZcKiATwczLlLJP/o28ahR3Dx3Xj6/YHk1lJuWh8FlwY1GECjN4lVbOrRSPGGER3W9dKRLTU5hexYFCGwtexrzDK7PG7IlM6xpnCWKOtWMHbYvQyIKiZzcLjvxKY8R+gM7ndzJdTrbubAHEtqKsU10PW0giIaI2zT1Dhl7GvXR49/hk0VM+T8Lp8VMV1vEQLInMvqI2DcJ1RbtHaOGT6yx5W/Qzkvbgj6n3VPnDopDpZuROiX5bDrSR5jqz/n1t3L6mEERklvCM+Uriigx2ZstuXKewYJSUX8Vqq3sXahCyq3KRoS7fRn3OJRYRz5J02A7NO2NdKv2FLzl/g4JL+LIYpcvp+I32C97YYvEL4i6XzA5rcjWYiS94Og4L7HZOEygCDRWi7GCr8AXwTsDzFr+Ac3s/zLeRh4P99UFeieB+BuQZ8yYaDP19ZKMyzXp4OAKdmua0gAv8c0/d+sLgsulW3n74+X+9/kqUw5Wc5uJJvaD0ReGevn9b5M98AvbIIsHqkINMaDPVdzaU4XN01LoNfLxJGWIEGYXPJ/PL4hVP4bX9nlP3DXtdFMYxGSFSZNXlKxfzZ/0l+5hyC2/ixj0pHbyBZ6WPkbaIvliu+7pb9os43fKi2L2xcJpu9FTuxiGxR2cJNk/33agGUE6fK
 qPB+Q/4t
 odx4+PwVX5qNomku+h+cjzWk3W6tbzSVu2mokoxv7/6QmYaLbLELfxYJWlagsKQoqIdLWAMrfeYW8FoTq+nrWu30q0MjdRYcebvHlzcl6eMgOTniWIAuBcYtRY6WpqSxW/K7+VjhqsVkM1IRNduVmyfvnReX1trq0j4c7HtgGm131XB9j18kwQ06I4mXd+dyhO3nZgOv3MHUceJFF9I9iLn+Qs/813iDOID8iGeAu/4dgR0WUrlifpQdqzUrxIvuUUHiXr0tHD8t2IA3yymTHO7vnrAHdiEajaKOlLHS+zjfcmEpjkMuR3QRwOqZYt0P7kN4AyGJmNtZtQhce0EpgQpElotFnr7aRefR0B5OhhthhpebPMOdPOpZwUgiaxpi00Y4TEyXkgR8/+mw+j8YRoM7FG7AUEbStS+AvKv6GfvV9irI97PDuBgXeSFRtBg25T14j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2146,12 +2146,9 @@ __latent_entropy struct task_struct *copy_process(
>  	if (args->kthread)
>  		p->flags |= PF_KTHREAD;
>  	if (args->user_worker) {
> -		/*
> -		 * Mark us a user worker, and block any signal that isn't
> -		 * fatal or STOP
> -		 */
> +		/* A user worker takes only the signals nobody can block. */
>  		p->flags |= PF_USER_WORKER;
> -		siginitsetinv(&p->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
> +		siginitsetinv(&p->blocked, SIG_KERNEL_ONLY_MASK);

Acked-by: Oleg Nesterov <oleg@redhat.com>


