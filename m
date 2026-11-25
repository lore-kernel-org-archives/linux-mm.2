Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D804606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkL8C3T8
Received: by kanga.kvack.org (Postfix)
	id 0DF336B09DD; Wed, 25 Nov 2026 07:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068736B09E1; Wed, 25 Nov 2026 07:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDDE6B09E2; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15A56B09DD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 416001C498B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:09 +0000 (UTC)
X-FDA: 85473498138.08.CCE88CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 84E5F40010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkL8C3T8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795608007;
	b=x4HF/XQnLTqicZ5y2na7NfeLBuOK03R0I/0FkrSHstlCCMlmZlgiL7ApoAPDwL5ldkoU1+
	GVkdJ5LAJwwMhnCDC6jzpAZQTya2bjtQxJMXrAF/8uptitm4wvunMPeLBUrUXcapgln85G
	IMUWFKjysukLKSmIoss9jrsJ0D/4tsE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795608007;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8a9e/Syys2RS7fmtSVEsufGSUaoooDAGnuf8vGZTyM=;
	b=sXIs8zq3Ho2LY6jSHhAVqoJ8rfwg5zoTVG6ak7zAG7R2Nbj5fl+WFhZaz7SUBjexwIFbLH
	Y4mScX9IUG2iuEa+WIlPwJA5+EqCeS0JN5FI+tPFyhAKbqh7LaBo1h4tLIhdAJN3noWR+b
	enxSx9KX9aHxzVqc71uzRt/9zZn9yx0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkL8C3T8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C46DD43DA3;
	Wed, 25 Nov 2026 12:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B5D1F000C6;
	Wed, 25 Nov 2026 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795608006;
	bh=a8a9e/Syys2RS7fmtSVEsufGSUaoooDAGnuf8vGZTyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WkL8C3T8TTboiiJULDWFUF+r3CksIBb0HKKt6dlTJjt++PCvjf4nn+hfxcFpC+p/Y
	 NPHqrlk/kEb7IyMPGOG/RyBwEy3r03lCg42AIPSoA+QanyYLvkXOtdUZbJuawwttXP
	 t0+WEp0t+TIwvFvolau9wTCZJpBx2mj8LxTNWlhkFeWvUEi538QlKLzXxJWLLfJ8yj
	 wPus5HLBrfL0n+XdK4hXDpGAi36yvO7clSb3RPTH2j4mUaM9k4OP5HKUkjZgwBlLY5
	 7OjbPYDfP/JhGAgk9ZU3gmYcuKCOGJotxxfKTQ2iyzGc/dz4+/2fmIJoKB9EGvhx5/
	 ia1vHwEehZcsQ==
Message-ID: <sashiko-outbox-233315@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] fs: Add throttling to deferred inode reclaim
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org, "Mikhail
 Rudenko" <xyzzy@yandex-team.ru>, "Andreas Gruenbacher" <agruenba@redhat.com>
In-Reply-To: <20261124115850.3512-14-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-14-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:00:05 +0000
X-Rspamd-Queue-Id: 84E5F40010
X-Stat-Signature: 13ka9yjzt47r9fa1pxowmae9ua1zmzga
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795608007-853616
X-HE-Meta: U2FsdGVkX18ikmelziXM8pBBs7luwlsB5C6kUn+CbpQm2RO4kMofiWJi+9XFNo1IabeE/dxKzSECR2+vp/QjC7Lcmg5wfPZdyFI3mOqWyZqBJl19PbkaVNMce4mawEu0G7soGdhi32Ak1Wf/ziR2yO8De8Oij2NY/qpAZkirDwuHVTl8OhP6d4/Ooxm06LtFy0XAQpAJeEh91rntas56xCty2iAzE6OfttggVcNQ/C4KOGLS0KNd4g96XLeSZdktvHizTGeCLztCRZ321XBRHEwGU8Oa+PNY386FJ5WeKabMTWvMu6PvFNpldR5fqhTAcbOvgM1oUToonqrPnCHc4hMFlE4Q7ZbhNH3Y9X684RPwkOhnrTbGzmfjG/vVqp6J3jBS47gESTA1ZL0qxHcYHcYqlrGRKrQGGjo6MmuM3T74gHhbEKoT3VUtbWXBrAQvvyRZQ2NIDFVh1t7LlcmosaSJEWxK0V784lag5QLTWKw+5rdrlKujG501xwvWNbyL5NbUccWdieQpLpgK78F6i7u8cd/f422UTuOQ9XdVJoVIo/Iv8GMlnmozcqmbXnt4NYqhcGXmyJ1Vq/bcl9v0XnwfwMnxcxe7TZG8eiE5WO8kh2bv1l7kQx6xH2xEBNW/dt+tc405Wrl9/lKc6ZBiISEb5zmbFCf7329aBICa6DvRfngaELn8tQWufRh0ff/WhXPwGJXD4Lz2aNUQC4HY4RWguMWKh1b1FqxwYja8iMeHDaflxW+DJ6pl7PVjFaogl9Q/ZArrQ/4kdlxF5Iy1fVr95P1Jm5foQ+jK5NxAf3W1sTJZcKYkCdgFw2Ddklr/dZfV9ua7dAvDVuFHgIYLaiBvDHdynLMsKdqsmKZsWqstTVwcdm5B1zZaNy40+dvp2MQutBTqEMlc7NsLHPc6WD1VlXuuN8NKLoRC0Y6zxpkf5CG0PTYR8cKR/ZRjsasi8/SE0OWrwQkb+Va44C9
 PhDH15lD
 vtfKaumfE7zsnOx3cWG2gajGW6fjxlE3v3rWvCUCrPtlAELPp95TdtazCNKjLbLZ5ly6JUQiPxyoOhdMNVJvD5OJhxGmc5rcWwE+HMUiolITj82I5ehxhh0q6LvA0EQmufXTEvUk3P2icQrMEFcAGTu/otluBqnaZ6UXhCiIgCd8JRoIzWWb7M7rJNsroUWOmFx7OQZKbAUDil1abUMBCiQ1BvMNKOX6o48+vyBCfe0m7qbiND/MwfPImkvMvArJf/OFTatcZHSZg4LJZmkHALC8MJbo35UGQyMu6Sf7g9Bs+N2YnERD9dFwcZZ44MdLDfr6Lej1HE8l4UXvpgA1TszEVfFWvE5qst4b4PDXRx8c8aQpK/SSEVN2FkiWiN/hzqix2bgp6/Vp7nOZWqk84qucHdk5Li3pxdub7iO3EXSj5tkc2CpsQ8GQW8Dg0HOxCr37gVwofZbrAxBtxSyg+XVldkMeARu03KBGXXiyaXaj3v3+49+uhMPO9ImUVK7JjrSGbmhW3RUpBc0VM7x/ZAipcNKmo6moD7g7n5khYUxOvWaWmMvGQrL3SSpYGKcBww2/yElFiL7Q/+LIbA24IyvQT8VMGL9NvMc2d8tBhlsFfqVCrW2PHOSVERn6o8ILQ8FS/9ZEm88X/hIGcLW+iAwSxSwZdn6zkRyMNxnd/fX3p237ANej/BQ0cPMyi9d+aorPpXDjiooZwE0nWFNvdgPb5CvLwSx7FvFp2b6r9SZphVnTdvj/6reyWrYrXpNx1gTNXKjQb/UuYEptosklPtx1Cm1oyUyKGif8y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] fs: sub-jiffy delay truncation to 1-jiffy sleep in
  deferred_delay_work()
- [Low] trace: writeback: non-standard
  mark_inode_reclaim_deferred_throttle name
- [Low] fs: missing __GFP_NOWARN and direct GFP_NOFS in
  throttle_inode_deferred_reclaim()
--

commit 1ea5687985f2e4f8753b554cdf12dd2d8a420e3c
Author: Jan Kara <jack@suse.cz>

fs: Add throttling to deferred inode reclaim

This commit adds a throttling mechanism that delays tasks on return to
userspace when the per-superblock deferred inode reclaim list exceeds
INODE_DEFERRED_RECLAIM_LIMIT, proportional to the moving-average per-inode
eviction duration.

> diff --git a/fs/inode.c b/fs/inode.c
> index dfba54288cbfd..fdab88f875454 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
[ ... ]
> @@ -1216,6 +1256,80 @@ static void __init deferred_reclaim_init(void)
>  	}
>  }
> =20
> +struct deferred_reclaim_delay {
> +	struct callback_head task_work;
> +	u64 delay;
> +};
> +
> +static void deferred_delay_work(struct callback_head *work)
> +{
> +	struct deferred_reclaim_delay *dd =3D
> +		container_of(work, struct deferred_reclaim_delay, task_work);
> +
> +	schedule_timeout_killable(nsecs_to_jiffies(dd->delay));
> +	kfree(dd);
> +}
> +
> +/*
> + * Size of deferred reclaim list from which we start throttling tasks cr=
eating
> + * inodes marked for deferred reclaim.
> + */
> +#define INODE_DEFERRED_RECLAIM_LIMIT 8192
> +
> +static void throttle_inode_deferred_reclaim(struct inode *inode)
> +{
[ ... ]
> +	len =3D atomic_read(&sb->s_deferred_reclaim_count);
> +	if (len > INODE_DEFERRED_RECLAIM_LIMIT) {
> +		u64 delay =3D READ_ONCE(sb->s_deferred_reclaim_delay);
> +		struct deferred_reclaim_delay *dd;
> +
> +		if (!delay)
> +			return;
> +
> +		dd =3D kmalloc_obj(*dd, GFP_NOFS | __GFP_NORETRY);
> +		/*
> +		 * If the allocation failed, don't bother. Throttling is
> +		 * approximate anyway and next time we'll throttle more.
> +		 */
> +		if (!dd)
> +			return;

[Severity: Low]
Since allocation failure is intentionally ignored here, should this include
__GFP_NOWARN so a failed slab expansion under memory pressure does not trig=
ger
warn_alloc() and slab_out_of_memory() splats in dmesg?  Also, MM guidelines
prefer scoped memalloc_nofs_save()/memalloc_nofs_restore() (or
GFP_NOWAIT | __GFP_NOWARN) over passing GFP_NOFS directly.

> +
> +		/*
> +		 * Scale the delay based on how much we exceed the limit. Wait
> +		 * at most 4x as long as estimated time to reclaim the inode.
> +		 */
> +		len =3D min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
> +		delay =3D div_u64(delay * (len - INODE_DEFERRED_RECLAIM_LIMIT),
> +				INODE_DEFERRED_RECLAIM_LIMIT);

[Severity: Medium]
Does passing nsecs_to_jiffies(dd->delay) to schedule_timeout_killable() sta=
ll
tasks for a full jiffy whenever the scaled nanosecond delay is sub-jiffy or=
 0?

throttle_inode_deferred_reclaim() checks !delay and allocates dd before
scaling delay down by (len - 8192) / 8192, so a small s_deferred_reclaim_de=
lay
near the limit scales to 0 ns and still queues deferred_delay_work().
Even when the scaled delay is non-zero, any sub-jiffy value is truncated to
0 jiffies by nsecs_to_jiffies(), and schedule_timeout(0) does not return
immediately: it arms a timer for jiffies + 1 and sleeps until the next timer
tick (1 to 10 ms depending on HZ), defeating the proportional ramp-up.

Scaling delay before checking !delay and allocating dd, and sleeping with
schedule_hrtimeout() in deferred_delay_work(), would avoid queuing 0-ns wai=
ts
and preserve sub-jiffy delays.

[ ... ]
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writ=
eback.h
> index c2a5b492a71a5..d371d1112843f 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
[ ... ]
> +TRACE_EVENT(mark_inode_reclaim_deferred_throttle,
> +	TP_PROTO(struct inode *inode, unsigned int len, u64 delay),
> +	TP_ARGS(inode, len, delay),

[Severity: Low]
This isn't a bug, but tracepoint names normally follow the subsystem_event
convention (such as inode_reclaim_throttle, matching inode_reclaim_update_s=
tat
above) rather than starting with the verb mark_.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124115850.3512=
-9-jack@suse.cz?part=3D6

