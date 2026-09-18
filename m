Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E0EC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064D96B0093; Fri, 18 Sep 2026 06:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016C26B0098; Fri, 18 Sep 2026 06:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6ED96B009B; Fri, 18 Sep 2026 06:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C489C6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:40:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B2F98064A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:40:58 +0000 (UTC)
X-FDA: 85226540196.21.365422C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E09EC0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:40:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WxJphUkX;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789728056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpWpYd7ykBa+pqh/CyPARHr2i0q4gvAGEWlcw4oSuPo=;
	b=m2eSkuYktrJFd+/S1Aj8azQKSQi08UI73JOT6smXr/YKqN7zk5kluA71B8K3js4O6jShva
	ABXKKj/rpmFKaCuY2fMvnwgTzJ2FAaX/ioCyDev8d8iK/ziGeb51UeWP3dJxW5BBSMllPs
	64F1nScOXpk7ssaF9WbvT2W0AZehd7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789728056;
	b=IX8hGZ0p7zzQCTATeYnkf6HOzLzYTqamLRJmvAsAQROb6GBza13ShzlUWBxxcAeQqrmM6V
	LKN30z9mgYLwTC9CZ8APuHAkED3wIsMoBAVw9s4axoDG18I9f1XRTZKkljEqH1YMY+CTpc
	EoH1jHHm2rYk9pwMq7KP72QqRfY/p9g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WxJphUkX;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789728055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HpWpYd7ykBa+pqh/CyPARHr2i0q4gvAGEWlcw4oSuPo=;
	b=WxJphUkXOvf7RVQI9wBXbIr2+Kiy6Vja9P2WlbErLIGBYl2e24ozLTeX/rUiaYX9fKdKbJ
	2YvvuTzZDRnv5GcLgpNJzRAFqIkjPVhNmvnHwu64KHl5JsViwpTalHHtVhSNNhNvtgcBdU
	zFHZyic0A/rzY7cOfVKHISsCm/2ledA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-ZK5aK-O7OAKAcpsQdMVDLw-1; Fri,
 18 Sep 2026 06:40:54 -0400
X-MC-Unique: ZK5aK-O7OAKAcpsQdMVDLw-1
X-Mimecast-MFC-AGG-ID: ZK5aK-O7OAKAcpsQdMVDLw_1789728052
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7B9D196F76F;
	Fri, 18 Sep 2026 10:40:51 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 185AC195604D;
	Fri, 18 Sep 2026 10:40:46 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 18 Sep 2026 12:40:51 +0200 (CEST)
Date: Fri, 18 Sep 2026 12:40:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <aq0VLTyxNatFmLOK@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: OwaJmWktBXj0snGU-GNbpxPuGNuTfM5_V6bL248ta-E_1789728052
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: awqd3h8dzoqda15umacmzczfncc93y68
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E09EC0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789728055-25204
X-HE-Meta: U2FsdGVkX1+Onii3yMkWx6xtjx+r4mxzw1QXf98/rKAVdwi670C2gRTIbB/KqaKnoMjhPFN1VdB5shrNiU5C1ZOLk6y5uoi7XJmDVew3FOXqU63DJWKZKqAnqxu/a9LWl8BI65S7jZm3LHBwtyBMs9aMyo/jqcgJ0a6siBcJbSUT72FDzl1TTAa93y7+ohw2C3Qe5VQqSnjKWew6c6iKRzhdhb2cV+COtzcjKgTkVr3/sEB+KvP5FkQrxj/I7CTv9YuMJ1cCvFZGOQDAbi8avaI/wIBSAcrbsr8o428UBMLdtZleyDJgq/xYR9dbS2H3Mw78cHrwhjn+KHMcMLDXOFbA/HC0/HfFjpJFfpntNXa2x8A5tberVbZmb13mlnbhji8VQmWZcb9b1+7m0D7qEV1r4G4DZS4sSBAOsRUWkgKeHGOTiCVd6ARBC8PqtUQ885bIh9JnuK9Mpl+VnTyOd89CIL2VcPwj7e1x74ja9qMUtGTRSNIfP7xNE7NnD5QJw5/z++Bj8NWFWSeVyReF+1xxuCQcXVx9U/4kTF/9+pkyKBK8cwToVS/Jz7nZacEuVxO5j0T8/hQsw9ztln3SB/Emj/ZsLmtVZnHvEfOhqpSkRV+cpVfWJZU8Vn4jCeKZBZ9+T7Tv3tBUtUWf9Oh3uKV4LE6GYDepyHvm5S91sNCS4alBp9ae0ILokhJ/7OSFspurAweAMg+tZRd6B/nBRU1kyR/5RM46ciTeaYzT8DeUKPjoUpSR9wkYW++Brg6FRa2qYVYllgJx42a4aTV5ikjnfMRu5/z88UkalueS7jLOfWUffNB2hHzVBWfcr9KOM40crp1etOJNufnYndrvLt0ABo9z5XT80uO52JbB2f2278YEQshAR3oHPxlAgz+Kcg0itP+2vRVKqXEzSSGKJPiFCYgORhs5gSe7s+lHZx3OwVfxLO5MKBWLxBiyAyimcB1V9wcBMyL7HkfoFyS
 dEPUrcT/
 /jupj8RxNaZXPToUFFMYDnEjukVZjXqhoSIOVGykpV3sNCnyZyaMq8NNh4T0sEoI/FZmgqgsMwh+JOD4xmjhGwTP+MhWXYs6L4eK+FEnvaZTvh78kDcnui5i7C1KmGNRMLvr2QOHEKEE2lbfaWwkE46hvnxUjzIuo74+omTVp6sqgbHvBy4zwqTpu4rr43kY2ymy8cy8RubCBjI5wKhmkdITGv/vbjmELr7oZxwGkujXZkBKR4DopSaWzxrMEm+mUucdsWi8pGAl60u+oR4aB0hbZx5mMoPFvlGRONkrYd9eJs/rEWuNYtsLrAI0scj/VPPPS+uxd1+gvLD8vb8m69kTJ+oC4D8kf7Ndi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/17, Christian Brauner wrote:
>
> Say a SQPOLL thread is a member of a thread-group that coredumps.
> The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
> thread uses io_sqd_handle_event() and calls get_signal(). It removes
> SIGKILL from the pending set and returns. The SQPOLL thread breaks out
> of the loop and drains its own task work.
>
> Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
> worker when no other worker is free. So it ends up calling
> create_io_thread() from a thread whose fatal signal is gone.

Oh.. Can we fix this in the io_uring/ code somehow? The very fact that
copy_process() can be called after get_signal() returns SIGKILL looks
very wrong to me. See below.

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2491,8 +2491,10 @@ __latent_entropy struct task_struct *copy_process(
>  		goto bad_fork_core_free;
>  	}
>
> -	/* Let kill terminate clone/fork in the middle */
> -	if (fatal_signal_pending(current)) {
> +	/* Let kill or a group exit, exec or coredump abort clone/fork */
> +	if (fatal_signal_pending(current) ||
> +	    (current->signal->flags & SIGNAL_GROUP_EXIT) ||
> +	    current->signal->group_exec_task || current->in_execve) {

Well, the comment doesn't explain why should we care about exec or coredump,
if we forget about the problem above fatal_signal_pending() must be true.

At least, can we move these additional checks into create_io_thread() ?
To not uglify copy_process()...

Hmm... get_signal() sets PF_SIGNALED before it checks PF_USER_WORKER, so
perhaps something like below can work?

And perhaps io_should_retry_thread() should check PF_SIGNALED too?

Oleg.

--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -2700,6 +2700,9 @@ struct task_struct *create_io_thread(int
 		.user_worker	= 1,
 	};
 
+	if (current->flags && PF_SIGNALED)
+		return -EINTR;
+
 	return copy_process(NULL, 0, node, &args);
 }
 


