Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718A8C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618F16B00C7; Mon, 21 Sep 2026 12:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9AF6B00C8; Mon, 21 Sep 2026 12:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506B46B00C9; Mon, 21 Sep 2026 12:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6816B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:16:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4BC2A524A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:16:37 +0000 (UTC)
X-FDA: 85238272434.07.390AE32
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A61A4000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:16:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BHnp5ICA;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7FXFbQgnyVFHazdwMvEWtM/nOP8qDBJcZZSaid5hmo=;
	b=X2ovLmd7LkdXRQsbHu8mw3wXDF5bhYte48XnCqkhAv52Un2iNqiVQ5SwVxw2J+5bO/pBh3
	mdXGy47MbPveRHSwW6hzUnydajranVsCuFKmf2AYnZeat72Vz3RptKgu24KVUtlVFyOiPn
	QTsSV1KCTIP/4/VJ4Yf/i4/326o/Rys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790007395;
	b=xlG5seGwfk0XyVpvQSnZJH6/iQ8OuY3eolE2iZ+Tyc46V9JsdkElrfJTv3fXfPHFZZbWRl
	jRlsYjc2/jZSYKMtGslrZofYqAlBfnPJP6jVXOcWYzEoSv2qPkp3KkFCnmSdMTNkv7G+j8
	BrlhOHXTdz2zgOsGzv+q3oBFE4E3xh4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BHnp5ICA;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790007394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a7FXFbQgnyVFHazdwMvEWtM/nOP8qDBJcZZSaid5hmo=;
	b=BHnp5ICACcqyfon4hFJgCDINf/L7nAAv33idgkXWMvSsCscHe6ButuSmfeOBvTak8xNtcQ
	elYKsyjut7n9jJKxsptpfMUGmxqZ9GiYzm5JZBJgZ69tt6q0Qnu3PKzBmKpO70XcLqQ+vq
	6D5wnrpiVSr4ytlWw4O69KwgC8K0k0M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-dsFLz2KPPiuUUHBpXd39VQ-1; Mon,
 21 Sep 2026 12:16:32 -0400
X-MC-Unique: dsFLz2KPPiuUUHBpXd39VQ-1
X-Mimecast-MFC-AGG-ID: dsFLz2KPPiuUUHBpXd39VQ_1790007390
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4736197702B;
	Mon, 21 Sep 2026 16:16:29 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3C3211956041;
	Mon, 21 Sep 2026 16:16:25 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 18:16:29 +0200 (CEST)
Date: Mon, 21 Sep 2026 18:16:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 16/17] signal: enforce the user worker signal mask in
 __set_task_blocked()
Message-ID: <arFYWLJ8yzpS325k@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-16-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-16-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: KVeMoxACiVoyCPL7YTTIt9_LbOx0sCC4TVzjRShtmrI_1790007390
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: q7xzhh6shqyaywd34o1yn56mg8tb7ice
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A61A4000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1790007395-356431
X-HE-Meta: U2FsdGVkX18hV1Y5WHuibgDYfJTXIooitWE1E6CVH+B5cGf9unSUnMlLf2kDw5+UtrWqx5+0XhRRJtxQxKA0rKpgESh3fvY/I1VPTkeunKilQVltnFqCJoH/g1nshboaOkODryWihx0yQUrD6qYV6SVPm1YUULR9gTS5EohH9pTMZwRZgUx5rO9Ks2A5DRHIoPSMvZ6bcZ52FJZrnhuhCVT/8so3pAa1Y0iqmpgxAQdYg6rXyYnUVXcr3FCp7/hJY2LrMJU561Q8L2xRt9dl3RBCk8EWbJHNbsZnoTMePydWpvek7aAN8GRpiU+3KrlIX/PwhL2QKRaevZRiSzJUoZvBrn5LzGogN9nVaJ5MDEo+65NaiQ5XMbGYwv0t5zRzDL1zJ2E5NGRL0cvdlmi25t9GV5aML+gg59wr0KfZhJ03hDd/Zq8R7NOCICHOEfje3gHHjo7DczRbngkMvfXALO5AH+ilwGYJFxNKLTq7DWXeS5p36vfeeeroje2at7MBTZICX967bnais1ZV1GvWp7Ixz+1B/vdvrtEZmFDbmkTS9uaOUDVZ09yUNTb9Kjn166tJNkIQGaNb/tIW2tdbCMn1Ie7VANjM6GaaJmbV2NULEqoBFWpV1+ZpcxylLUqpuNu8ZOknLY6hFc5wHCKaz2isLBBSrE3kCqcxJWex8vhrlcEOZpaRKY03Q1hynOQ6s1KlxZupFADfWInHCrayhdSVFKRRIYqlDden9/ZM9LXc87AFhDti+ldaFfqsWoNHr+0PRcgNsy19va0alojlNc56cS5mmmVPFhxM0aQeqO4AZC/I+HuXe6bktT93ySzzzi7PMU4Vyi/jJy3sqBm7SCeyQmoN9ay6g1kaoK6itimbDYsqe3mG6pRgjAdajWHOOJ+OS0wRs+NhnuQ6ABD1Zbn3PA0CDwclSj/S0wSdhiI0gz5yUYNipG/COZZ7rYRaPEzQFfIOcsKii4lskSe
 Q0G3KrQu
 LRn25wpu44Mdfr7WIzKLhooPnvScm/B2z39bsHLAb1AeoWfBM2nLL+BWwiFS/bMGlmSZUA8iEj3WErWTakeOIO5YkTA/9MCthJyZM3+DBVRIfTyBNzatSs0YPBF5n3JVa3Sg07tSFUKec9w7uIiUpjkbJdusJbkzwBrBUhGYuw+EGn9ADlJSAOdDasKOI6sDCGP3l9H7yehDRySQW9LWDSxVmA69GZ3MJBuCD6zwFPKzpDQnrRnm3obFV+cMwVB2IwOKLtQYN1QbXerCAPSAmDfgo76PYxBMjM3JpVZ8HbU9aL7qwMVUgQPCTZSGiSN5kZcw2K2IKo5JNEAy65EANclS5PAvueqfZXj0fDfJL1POuH4N8/TlZf4x+uXROr0hH/7CCaOrd2Ez85qt9T+LGGQBVceF7deF1HZFZNe/zEiG9kH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> The in-kernel sigprocmask() users block more signals for a critical
> section and restore the saved mask afterwards. cifs used to do that in
> __smb_send_rqst() and ocfs2 in ocfs2_block_signals(). Both were
> reachable from an io-wq worker. Both only add SIGKILL and SIGSTOP to the
> user workers's and then put the fork-time mask back.

Ooh, this reminds me... see below.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3212,6 +3212,16 @@ long do_no_restart_syscall(struct restart_block *param)
>
>  static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
>  {
> +	sigset_t floor, floored;
> +
> +	/* A user worker never unblocks anything but SIGKILL and SIGSTOP. */
> +	if (unlikely(tsk->flags & PF_USER_WORKER)) {
> +		siginitsetinv(&floor, SIG_KERNEL_ONLY_MASK);
> +		sigorsets(&floored, newset, &floor);
> +		WARN_ON_ONCE(!sigequalsets(&floored, newset));
> +		newset = &floored;
> +	}

OK, Acked-by: Oleg Nesterov <oleg@redhat.com>

although to me something like a more simple version

	/* A user worker never unblocks anything but SIGKILL and SIGSTOP. */
	if (unlikely(tsk->flags & PF_USER_WORKER)) {
		sigset_t xxx;
		siginitsetinv(&xxx, SIG_KERNEL_ONLY_MASK);
		if (WARN_ON_ONCE(has_pending_signals(&xxx, newset)))
			return;
	}

makes more sense. But this is minor.

In fact I think that __set_task_blocked() should simply do

	if (WARN_ON_ONCE(tsk->flags & PF_USER_WORKER))
		return;

but yes, we can't do this right now, we have in-kernel abusers of sigprocmask().

IMO, they should be changed to not rely on sigprocmask(). Lets look at
ocfs2_delete_inode() for example,

	/* We want to block signals in delete_inode as the lock and
	 * messaging paths may return us -ERESTARTSYS. Which would
	 * cause us to exit early, resulting in inodes being orphaned
	 * forever. */
	ocfs2_block_signals(&oldset);

ocfs2_block_signals() blocks everything including SIGKILL and SIGSTOP.
I guess to protect against signal_wake_up / TIF_SIGPENDING ?

But this can only help in the single-threaded case. And PF_USER_WORKER's
are never single-threaded.

Blocking SIGSTOP can't protect from SIGSTOP if another thread dequeues
SIGSTOP or another sig_kernel_stop() signal. This another thread will do
do_signal_stop() -> signal_wake_up().

Same for SIGKILL...

In short, I agree with this patch, but mostly because of WARN_ON_ONCE()
it adds.

Oleg.


