Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7557606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RA3H1pvn
Received: by kanga.kvack.org (Postfix)
	id ADF346B05CA; Tue, 27 Oct 2026 06:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90066B068B; Tue, 27 Oct 2026 06:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDAD6B068D; Tue, 27 Oct 2026 06:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 708526B05CA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:25:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF6E4C0979
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:25:26 +0000 (UTC)
X-FDA: 85368024252.06.935E457
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6071940007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:25:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA3H1pvn;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793096725;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP5emJnNWlbkNX0rznKL2zBQnkgG6d/ZNGrVgRHTsUc=;
	b=2LUGhAKLaJ8vuJuhpkZle08kNNsVF5lqydj2HNQ31yOBUe7wienvXz0utHZ1gcZrJx/Ohv
	f5R2btLL5G5eSoIsBiT8ZqytEOihl90aX4o1D7xyQs6LQe8vIfa6gGrpXH8LWT0uZsve23
	OS7nj6LBWuUu2WFUWGRZwUmVBbUk1ZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793096725;
	b=Ul6hsceMOV9qhDfRr0yGu4VriC2ObjI7ZC1yDWBkZrLnCFCBh+Q0smkA/wFGhSPgEyyi74
	iewFy1GG4vPcaYxtcHGlQsmDR7SN38p2ztf33o4UJUJhGubAJUVknt4qJ1M0EIMw7o7APB
	q5ZoHqWXc+Vuaf0QXhVlTf5IAC/U+gY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA3H1pvn;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94E0560052;
	Tue, 27 Oct 2026 10:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9211F01825;
	Tue, 27 Oct 2026 10:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793096724;
	bh=EP5emJnNWlbkNX0rznKL2zBQnkgG6d/ZNGrVgRHTsUc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RA3H1pvnkJBTAF2X6sti1HRuklC170Q5i2VecrXpAKYMHtWxp5mGrsgCEq4kRvzfw
	 Xs9bOqc24YOdnx5CqoIqXLN51ArZHlUg0ypCQtJMZ4pyvGyGAJivblrGknS3nL0qpd
	 J9xGICysXezb7lRn8JQ+c0JYhBnklapMO1keP+q1b7eLROChhuFeB8ihLtCofiaGik
	 wCryGhxzIGsgAX3tTQ4za6bc5gAv7JHCR0tzQ3khq3Fn+3paZTNnU0Kqbtn0reYKTC
	 7JVARoQrRTjrLCby8YWgKvNtZD54i6ziKLcM3UEZa803mhehXW9KNkq+4R9uN84sgQ
	 y1g2BogXYO53g==
Message-ID: <sashiko-outbox-186354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VWxhZHppc2xhdSBSZXpraSAoU29ueSk=?= <urezki@gmail.com>, linux-mm@kvack.org, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Baoquan He" <baoquan.he@linux.dev>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>
In-Reply-To: <20261026102503.30860-1-urezki@gmail.com>
References: <20261026102503.30860-1-urezki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 10:25:23 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6071940007
X-Stat-Signature: bwseoe7x95ux4idzkoz61xejmkfb1g3x
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793096725-781671
X-HE-Meta: U2FsdGVkX1/8vh4ul8JnFwBOBnrLW+p4/PApifdf39wyKHkdXXmRkigIItUcimoqBc983Uu8ywsO0DJ72EHMLttMgROxFNSeP8GpMDb2vz9ZtDfZ9jlqZoYdZqvGGImbRDooK2WqbrDkZuh2fhCQdqIjNSmbTjGfcq9jffWTQandQ04enKm7E7QdO3SSFbdeIenVRb7PekiKuF+Hy3sYoht68KgpbAjfVxyQi+zR1/8tdOEWTlQ1rWEXr4/TDyNjKcXdQr4hAWu4wHdJnEKNY18F6A4FloVDIzfzLfZKHoXOOYE6nUi+kvGUG098a1W+IYm8Wzm5sFT3Nmk5/ssQMnhV4sWKGx3cVc6EtH2kKR+FikYiPVtO1V82qDVdnHPT+L+mOHeExAh+XFInfIL3TOHwINRIHzdHdDcT3CKu1BCzUm7BTsEVpeXG7TUBTTGLJ+aCPjbkexz0YytSaz+gOjSgQZr8m1FGBuansZZ/X5/JcD9KnXRpW4JAC636I1IqTAHpLZtalZuX/3/TmfCuTu62r+U4349nlWIgJvBD7GEKpL/NZy+AuysNVPu/YiPLGQyqQsUz3Bmgum5eRxV9ItoIWnW7PxmBoc+zUKrFGu5Syw0Xs1Fs9X8OU5Qmk8PvLc1bYjmGjexfG3XbFiq6OVClYVJ0MDnGJZu2um1FGIZMSrAbMzLhMYibv7UimVm+zxlNnptMzusKBglnWFhRHGgZTVKrsgktBCAhwuJJ+HVJMtPzHpXfbNFrh6ski9WZp9jNpgG5ASX5S42FtiiRVY8OO7lk0RVUqEz00yNMVq4PO2kNRimxk/ThSZN5wROZrSn47wpll2iwBF5vZ2Tp5NhPSuLHIF1ZLXY51zp26+Ie2mAEPX9OAuSrQE/zdZIArkhn+00z9XtMrShXXUbTZME7xadxscujym/rNEX6KITtMqcljSCv9XnetrFB+9TNegpRol5Y3XakqC6nKGk
 9mPd5v97
 XFHd6evv6CpZmsSgKNAK/iNrIPb6ZbhMMafspok4KWe0/5uZ3K+YR3ZQKuBGAkXRWuL5+MCvqczfoOGHn5zcswjd3EiV0LVRBb5vvQgttY/MImgZqSKDPd40V3GNvASMDfVs3q6LGvyP4RSpNBWgmwlcBKWYLwwkdSv9DXpv2qtMNVBs5mHYkMu5wHSapXg9Gaho+hpce56b1u3YlQ2g2KaltVKzyTEZffc41JFWQ2O0o8iPHQD6n52iD/k3Tn5oEdMS/xq9ZGOXkmuEG+VHyU1pWV7qEEl/6BcRIMFt136Z0V8/TMuyS0wXAapZ/EtPPwId8lhjZWziv528LvqaL7KGMhXqJLPALK/N3GvFsQZ+fi2vkfwgntVRUdU0TeY4bnwCQHKqEEf8Qq1GrAy/dV6a9jy6EwMHbg8YoUXekYG02N2LtH9V8E6XFvazc63BfXIFc/qKUhhiziMItGXHJYKkaxOdedQdAU3zivhV7uMx+3EjXJXAH4c6ysAJMhxV8mfQf4aijNlvLnvFdi9UAzBENg7/7n8moccrU9aiGzFYFjyBnidAoosGsoQNR2lz0aKdvg6uodwQax874NNLJzS9cgsuOgRHIYfcB27pUmuoxKR8ijonqnuT4jpiaCJ03sZS2HD8ZyM32tzNGyuoZj5sSSUECkTl4jNRN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/vmalloc: ABBA deadlock when calling vmalloc() with BH or IRQs d=
isabled
- [Medium] mm/vmalloc: __get_vm_area_node() irq bailout triggers warnings a=
nd retry
--

commit 9fea18279139941aa247a1a577dd5e101116871a
Author: Uladzislau Rezki (Sony) <urezki@gmail.com>

mm/vmalloc: Bail out if in softirq context

This commit restores a softirq check in __get_vm_area_node() using
in_serving_softirq() so that vmalloc() bails out when invoked from softirq
context while still permitting callers with disabled bottom halves. It also
replaces BUG_ON(in_nmi() || in_hardirq()) with a WARN_ON_ONCE() check that
returns NULL.

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 44e0eb32708f1..5a949525b9db8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3271,7 +3271,13 @@ struct vm_struct *__get_vm_area_node(unsigned long=
 size,
>  	struct vm_struct *area;
>  	unsigned long requested_size =3D size;
> =20
> -	BUG_ON(in_nmi() || in_hardirq());
> +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> +	if (in_serving_softirq())
> +		return NULL;
> +
> +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> +		return NULL;

[Severity: High]
Can allowing vmalloc() in task context with bottom halves or interrupts
disabled still cause a multi-CPU ABBA deadlock on vmalloc's internal locks?

In mm/vmalloc.c, alloc_vmap_area() acquires vn->pool_lock,
free_vmap_area_lock, and vn->busy.lock (and __pte_alloc_kernel() in
mm/memory.c acquires init_mm.page_table_lock) with plain spin_lock(), leavi=
ng
bottom halves and hardware interrupts enabled:

mm/vmalloc.c:alloc_vmap_area() {
    ...
	spin_lock(&vn->busy.lock);
	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
	spin_unlock(&vn->busy.lock);
    ...
}

Because __get_vm_area_node() only checks in_serving_softirq(), in_nmi(), and
in_hardirq(), a task-context caller holding a lock via spin_lock_bh() (which
sets SOFTIRQ_DISABLE_OFFSET rather than SOFTIRQ_OFFSET) or
spin_lock_irqsave() (where irqs_disabled() is true while in_hardirq() is
false) will proceed into alloc_vmap_area().

Using the bridge FDB path referenced by commit 04aa71da5f35 ("mm/vmalloc: do
not trigger BUG() on BH disabled context"):

net/bridge/br_fdb.c:br_fdb_add_local() {
    ...
	spin_lock_bh(&br->hash_lock);
	ret =3D fdb_add_local(br, source, addr, vid);
	spin_unlock_bh(&br->hash_lock);
    ...
}

net/bridge/br_fdb.c:br_fdb_update() {
    ...
	} else {
		spin_lock(&br->hash_lock);
		fdb =3D fdb_create(br, source, addr, vid, flags);
    ...
}

If CPU 0 is in task context inside alloc_vmap_area() holding
spin_lock(&vn->busy.lock) or spin_lock(&free_vmap_area_lock), and CPU 1 is =
in
task context inside br_fdb_add_local() holding spin_lock_bh(&br->hash_lock):

1. A hardware interrupt arrives on CPU 0, and on irq_exit() NET_RX_SOFTIRQ
   runs br_fdb_update(), which spins on spin_lock(&br->hash_lock) before ev=
er
   reaching fdb_create() or __get_vm_area_node().
2. CPU 1 proceeds through
   fdb_add_local() -> fdb_create() -> rhashtable_lookup_insert_fast() ->
   rhashtable_insert_rehash() -> bucket_table_alloc(GFP_ATOMIC | __GFP_NOWA=
RN)
   -> kvmalloc() -> vmalloc() -> __get_vm_area_node().
3. Because in_serving_softirq() is false on CPU 1, it enters
   alloc_vmap_area() and spins on free_vmap_area_lock or vn->busy.lock held
   by CPU 0.

Similarly, a task-context caller holding a lock with spin_lock_irqsave() can
enter alloc_vmap_area() with irqs_disabled() and invert lock ordering again=
st
any hardirq handler acquiring that same lock (and sleep with interrupts
disabled on CONFIG_PREEMPT_RT).

Should __get_vm_area_node() also bail out when in_softirq() or
irqs_disabled() is true?

[Severity: Medium]
When __get_vm_area_node() returns NULL due to in_serving_softirq(), in_nmi(=
),
or in_hardirq(), how does __vmalloc_node_range_noprof() handle the NULL
return?

Looking at __vmalloc_node_range_noprof() in mm/vmalloc.c:

mm/vmalloc.c:__vmalloc_node_range_noprof() {
    ...
	area =3D __get_vm_area_node(real_size, align, shift, VM_ALLOC |
				  VM_UNINITIALIZED | vm_flags, start, end, node,
				  gfp_mask, caller);
	if (!area) {
		bool nofail =3D gfp_mask & __GFP_NOFAIL;
		warn_alloc(gfp_mask, NULL,
			"vmalloc error: size %lu, align 0x%lx, vm_struct allocation failed%s",
			size, align, (nofail) ? ". Retrying." : "");
		if (nofail) {
			schedule_timeout_uninterruptible(1);
			goto again;
		}
		goto fail;
	}
    ...
}

Since commit c6307674ed82 ("mm: kvmalloc: add non-blocking support for
vmalloc"), __kvmalloc_node_noprof() in mm/slub.c falls back to
__vmalloc_node_range_noprof() for non-blocking allocations (such as
GFP_ATOMIC or GFP_NOWAIT) when size > PAGE_SIZE and __do_kmalloc_node()
fails, while kmalloc_gfp_adjust() only adds __GFP_NOWARN to the kmalloc
attempt:

mm/slub.c:__kvmalloc_node_noprof() {
    ...
	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
			node, __builtin_return_address(0));
}

Doesn't bailing out in __get_vm_area_node() lead to a few issues in callers:

1. In softirq, hardirq, or NMI context, when !area is reached in
   __vmalloc_node_range_noprof(), it unconditionally calls warn_alloc()
   whenever __GFP_NOWARN was not passed by the caller (and if shift >
   PAGE_SHIFT, goto fail resets shift =3D PAGE_SHIFT and jumps to goto agai=
n,
   repeating the call and warning a second time).
2. If a caller in hardirq or NMI context invokes
   kvmalloc(size, GFP_ATOMIC | __GFP_NOWARN) (for example,
   rhashtable_insert_rehash() -> bucket_table_alloc() in lib/rhashtable.c,
   reachable from irq-safe rhashtable users and BPF_MAP_TYPE_RHASHTABLE
   updates in rhtab_map_update_elem() in kernel/bpf/hashtab.c) and the
   kmalloc attempt fails for size > PAGE_SIZE, __kvmalloc_node_noprof() fal=
ls
   back to __vmalloc_node_range_noprof() -> __get_vm_area_node() and trigge=
rs
   WARN_ON_ONCE(in_nmi() || in_hardirq()) even though the caller passed
   GFP_ATOMIC | __GFP_NOWARN and handles NULL.
3. In __vmalloc_node_range_noprof(), nofail is not cleared when
   !gfpflags_allow_blocking(gfp_mask) (unlike in __vmalloc_area_node()), so
   if __GFP_NOFAIL is set when __get_vm_area_node() returns NULL in
   interrupt context, it will call schedule_timeout_uninterruptible(1) in
   atomic context and loop indefinitely at goto again.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026102503.3086=
0-1-urezki@gmail.com?part=3D1

