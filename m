Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1587DC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0436B0098; Tue, 15 Sep 2026 11:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89386B0099; Tue, 15 Sep 2026 11:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DAD6B009B; Tue, 15 Sep 2026 11:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71BF66B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:02:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A518B120488
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:56 +0000 (UTC)
X-FDA: 85216313952.30.5EF3BEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7036810000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AcsaRlJ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484574;
	b=7aZmp0n679JPn/du6yY50fus0e/a5N5WGJzSvg8yfjJ6JRwXSkQ6ze96oqCGFP+WAPMivG
	Y1McSgIJBJ50w09jpMQ9lm3GErsk2ovsIwaxBKjjtyOd0eL7wD4gX/8ujc9/yFL1eFKnS2
	wNTAYAvLhneY3q9DHKuQnW2ta8B+ceI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AcsaRlJ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHyk6+IrqQOJoNBANVy6H3eTJp4wkRbqnNOpZl37PNY=;
	b=OBMxnGScPCwAa59fwdNdEVP8UoqsWgEqfvwpOfSB8jrCvQ5x8jW1fkntfWnBQKn79JS4ZZ
	cIjiy5np92U8GwAkfoBqsowvOQZtwOfz6TsAZvreR+PoEj4OZmm60zJyu0LuVsNaFCZJDC
	W9p3Sam4iOlZQac5eimGHu8+5ApSgRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789484573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YHyk6+IrqQOJoNBANVy6H3eTJp4wkRbqnNOpZl37PNY=;
	b=AcsaRlJ1z83bzR4cV4sWiuf1mgpEtg/94ldmtyDc248dIwBuf39Aaj4PUzQkeE7VGwl4yo
	EgAc5U8VoPZYP26cbvKapE7OJ9ASdMVF9T02xsp8B8k7rvW1vDyq4wdsowOnk2F11Qxfzq
	2roaLtPnWLtx7sRnGYLiAzmhasTp7uc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-t8xWsI1wOhS3uKw5owlbRQ-1; Tue,
 15 Sep 2026 11:02:51 -0400
X-MC-Unique: t8xWsI1wOhS3uKw5owlbRQ-1
X-Mimecast-MFC-AGG-ID: t8xWsI1wOhS3uKw5owlbRQ_1789484569
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52A711955E91;
	Tue, 15 Sep 2026 15:02:48 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D9361195604C;
	Tue, 15 Sep 2026 15:02:44 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 15 Sep 2026 17:02:48 +0200 (CEST)
Date: Tue, 15 Sep 2026 17:02:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/6] fork: refuse new threads while a coredump is in
 progress
Message-ID: <aqleExxTBcHsonQe@redhat.com>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
 <20260915-work-coredump-fixes-v1-2-f354ca41780c@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260915-work-coredump-fixes-v1-2-f354ca41780c@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: sBTmLsyiMZ2l7YozWtwQHoVdYX7u5WT4qsiKV_VQBIc_1789484569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7036810000D
X-Stat-Signature: pntgqbnsmheo5h8n3kjemgnmukxp7jjw
X-HE-Tag: 1789484574-560782
X-HE-Meta: U2FsdGVkX18x81EmI9RbfhWfsO77bjw9QTsu0JKDC11Pp4PMRL37nnwODBQIamWPZ1gji1sO4R954bwmkH7kI11AX5zF3RlNzVF/YTr9iTGau1SYnmlZxa2dGtlJfqzg5zsXPjKZfxKSXXcPbUxmfsxd1E85zQFsBk6iOvSWtoRRU28xKvVOMTCzp3onxsB/je1xUeuz2UzAuEAnAuWaJAW6UjFy9Qk1ZBGKLdHHQdD7LvSisuTbwN2m5Pk2Cvup53Xn8QZ2E7pcjiP1StIs1kkALsoKrrL7mpi37NyY56DToyCpn6+dupvYWipTss1oX1UzlPIO+ZAbiQ8U1dCyTPAZmQPoKx1oQEmGYYhQ61CnWXTxXOs/jwk93ptRC0ikl9+GoNI0/sUzwDIwgjb4TeLGbcGTyGFZ1y/M4ArDc8LA8m4y4ZcQdVRxLE1QrK1gOQbIZ9LDIsUF0XFPCt4YQbykGl2fp5cGwVUCKw2h/or4WitXe25hXwk5QikEwvP96f4uzVimXThrby3Z4ikmi4CXIoRjGnUy/vrxBdNZj1pGHAzykInP1XeUksYSc158VJ6zLdNx0VjJHt/ntdkGI1cRuq7vLCdVcf/Dq+IiR9GYamgtwc33BCumYMn6BGmZWcbxTz+/i+4qj48M2wwX5F565cHY998l9PXPaqMLabA9T6K1HKvxy7+xyQ/ZZDQOv+YhvyEbNuhsNS9Mc20+iPBpYFdhsIQrBmm5K+pSWzuBE3mHl7qRIfOKW8JoFN8HGZnm+ioWHtGw5Wiw6aGZG9/rw2IeeIJ/nLtAYk1mAHaA87Q/VxtABgFihtD4bGTircY4LMLkK3IcwEOSonaTSRn/euEx6a9FFe8qkOcIILx4e7xvdASY/7DCfodw8+nOD4hQnYQ+/QYZszZt/Os4M41aU8nEAvG5BAFN2TqpYo3BaItSGhLzZifuVwjmPp9x4Xkr6/QHAAbx8+tO+oc
 GT17YvmG
 ViEJmHcfVVxAbB72Bz6FpXR+qsz/EUHet+Yer4S2pjoKq4IoC4kpOKcxr97DYU9o3Fk+qCxNV+8GMRCZ0tNoA8sOXcMp70VyAUNvkPGvpk2gEpImgzTlG0HRfErtwQMHxotlzkhMRzZeLjqF8L1D/qGMW95Dm5tST06uIf0gvg2s6HI4+OnWRB7sM81mGfGLBrCqjkkf4K6qkBfEVgPP5yTmANA6qBGtGpwPNp9qZyzgP0wAWW5Wxnqydf4aRhyHNIONja/6RB0tc+h+nY59k3MDfsd7OC3ZpwdqpdknStCvbDRviIuLgN4gN0vEzuP8zeH1sJfRL0R14HxJcKkWNo97H8b9e7KzNrbNj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15, Christian Brauner wrote:
>
> Say a SQPOLL thread is a member of a thread-group that coredumps.
> The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
> thread uses io_sqd_handle_event() and calls get_signal(). It removes
> SIGKILL from the pending set and returns. The SQPOLL thread breaks out
> of the loop and drains its own task work.
>
> Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
> worker when no other worker is free. So it ends up calling
> create_io_thread() from a thread whose fatal signal is gone. That means
> copy_process() allows the creation.

Hmm, thats bad ;)

But then ...

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2491,8 +2491,8 @@ __latent_entropy struct task_struct *copy_process(
>  		goto bad_fork_core_free;
>  	}
>
> -	/* Let kill terminate clone/fork in the middle */
> -	if (fatal_signal_pending(current)) {
> +	/* Let kill or a coredump in progress terminate clone/fork */
> +	if (fatal_signal_pending(current) || current->signal->core_state) {
>  		retval = -EINTR;
>  		goto bad_fork_core_free;

this change is not enough? Don't we have a similar race with exec?

de_thread() kills all other threads and counts them too. Shouldn't it
also check signal->group_exec_task ?

Oleg.


