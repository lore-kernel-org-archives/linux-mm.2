Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D9C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OvJHETHD
Received: by kanga.kvack.org (Postfix)
	id 2831D6B05B0; Thu, 26 Nov 2026 10:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233FE6B05B1; Thu, 26 Nov 2026 10:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BF16B05B4; Thu, 26 Nov 2026 10:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1D646B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:56:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0645C1C3FB5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:56:24 +0000 (UTC)
X-FDA: 85477722288.10.ACFBB49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71537100020
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:56:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 534374005C;
	Thu, 26 Nov 2026 15:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0E51F000CA;
	Thu, 26 Nov 2026 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795708573;
	bh=WPgi0UO9OMJkDQmrQEq7cc93hq76+nhsfMPo0kS8irI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OvJHETHDnG4CEYU93Oq6oKqgT6G9EH9EyM2xHehfi35ooIURf/g55MbSrlMOg/b6A
	 N4n3ii5oiK/4+i4cifgmHEOAGc1XvB/vv7DMWAUZ8v7Zi4o+lVYs/6UbiZ1eGJuju5
	 1HFdX3yKZBJf455rsVr78x/hoEmmSr4xwBuxanfwdrZsmH8pVKZkVaSBfXV0A7OnGu
	 VIIDCTBEDl3OMGWjAFuAVstLJ4U7EFBLpVOVXKIb7DNYUBx0S3j97lFEnXTHMLFqmT
	 w1gZ+rE5PJSVzAX2EhcbF2ZipPfh9RpH2HRCv9t/IA60Zo5dI1kJzgwrgAjW+Ck+DR
	 WUZzt3LiazsXg==
Message-ID: <sashiko-outbox-235862@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] percpu_ref: make percpu_ref_switch_lock per percpu_ref
Reply-To: sashiko-reviews@lists.linux.dev
To: "Egor Shalashnov" <shalasheg@gmail.com>, linux-mm@kvack.org
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, akpm@linux-foundation.org, zhengqi.arch@bytedance.com
In-Reply-To: <6c943754-05b5-4017-9145-0d145766909a@gmail.com>
References: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
 <6c943754-05b5-4017-9145-0d145766909a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 15:56:12 +0000
X-Stat-Signature: egrupogs3gwu5xp473d5tt6jh3co3rgy
X-Rspamd-Queue-Id: 71537100020
X-Rspamd-Server: rspam06
X-Rspam-User: nil
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795708574-146811
X-HE-Meta: U2FsdGVkX1++WD0Yibt+MwJQtqrmSFSHTr4lwSrcQYC86R4yU0oHs5mXjiDNpvlWl4b1QFsCzGUl4KzPH1vvLMaUDbsw/TqpXLslvGwXgY8edW9oHtYgaq0zpY437jLbiyt5LlSbaOvIAFkh+MqQzOSQlGGSP5iU1bcYx8DEXtB9tGtLnDT+UIKMmrThO1GgrvKDEp4ZLy0fgI1wTrFKkBrXXou5KM2bFXitQFP3qAWVUDdaFuIboL3ILbQZGHmd2fcdRbDRnmSQKSj17MwcV6if8Tqizz1Cy6GKkwOiU043W21il6XqJrm29VpPKFvXijV6fMc4PKuOExk03Un1y5nPFFRuJ+cNqT2v2Rq26OfdH58Fij9GXq8r/7FPa+R0KeaCBoHMaKEDBYXuRYtL7jibWccWE60pRCCLqrD1huPmOw4qmdHVJ2ykmMglCOVwTmtdnZabm0+T17Q4bm15CNYdAVMvEuRs69ebtzZ+5Qo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] percpu_ref: global percpu_ref_switch_waitq still serializes
  mode switches
- [Medium] percpu_ref: switch lock in struct percpu_ref bloats hot
  embedding cachelines
--

commit d37012ad38aa40d26d6d73947c79cfb449eb07ba
Author: Qi Zheng <qi.zheng@linux.dev>

percpu_ref: make percpu_ref_switch_lock per percpu_ref

This commit replaces the global percpu_ref_switch_lock with a per-instance
spinlock inside struct percpu_ref to avoid lock contention across
concurrent mode switches.

> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refco=
unt.h
> index 1e3212e2c8271..4582e798de8a6 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
[ ... ]
> @@ -109,6 +110,8 @@ struct percpu_ref {
>  	 */
>  	unsigned long		percpu_count_ptr;
> =20
> +	spinlock_t percpu_ref_switch_lock;
> +
>  	/*
>  	 * 'percpu_ref' is often embedded into user structure, and only
>  	 * 'percpu_count_ptr' is required in fast path, move other fields

[Severity: Medium]
Should percpu_ref_switch_lock be placed in struct percpu_ref_data instead
of struct percpu_ref?

As noted in the comment right below, commit 2b0d3d3e4fcf ("percpu_ref:
reduce memory footprint of percpu_ref in fast path") moved slow-path fields
into struct percpu_ref_data to keep struct percpu_ref at 16 bytes for
structures that embed it in hot cachelines.

Adding percpu_ref_switch_lock here grows struct percpu_ref to 24 bytes on
64-bit SMP (and up to 88 bytes with lock debugging or PREEMPT_RT).  In
struct io_ring_ctx, for example, the first ____cacheline_aligned_in_smp
read-mostly block is packed to 64 bytes, so expanding refs pushes
notify_method and sq_thread_idle into a second cacheline.

> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index f8d90689af9f5..5d466026e5251 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -36,7 +36,6 @@
> =20
>  #define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
> =20
> -static DEFINE_SPINLOCK(percpu_ref_switch_lock);
>  static DECLARE_WAIT_QUEUE_HEAD(percpu_ref_switch_waitq);
[ ... ]
> @@ -267,7 +267,7 @@ static void __percpu_ref_switch_mode(struct percpu_re=
f *ref,
>  {
>  	struct percpu_ref_data *data =3D ref->data;
> =20
> -	lockdep_assert_held(&percpu_ref_switch_lock);
> +	lockdep_assert_held(&ref->percpu_ref_switch_lock);
> =20
>  	/*
>  	 * If the previous ATOMIC switching hasn't finished yet, wait for
> @@ -275,7 +275,7 @@ static void __percpu_ref_switch_mode(struct percpu_re=
f *ref,
>  	 * isn't in progress, this function can be called from any context.
>  	 */
>  	wait_event_lock_irq(percpu_ref_switch_waitq, !data->confirm_switch,
> -			    percpu_ref_switch_lock);
> +			    ref->percpu_ref_switch_lock);

[Severity: Medium]
Does leaving percpu_ref_switch_waitq global keep the mode-switch path
serialized on a shared spinlock?

Every percpu-to-atomic transition completes in
percpu_ref_call_confirm_rcu(), which unconditionally calls
wake_up_all(&percpu_ref_switch_waitq).  That acquires the global
percpu_ref_switch_waitq.lock even when no task is waiting, and wakes
waiters across all unrelated percpu_ref instances when tasks do wait.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6c943754-05b5-4017-=
9145-0d145766909a@gmail.com?part=3D1

