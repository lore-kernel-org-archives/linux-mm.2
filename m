Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDDF6606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmZOMLDU
Received: by kanga.kvack.org (Postfix)
	id 090666B06F1; Wed, 21 Oct 2026 07:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041786B06F2; Wed, 21 Oct 2026 07:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0436B06F3; Wed, 21 Oct 2026 07:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4C196B06F1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:49:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EDF51A0464
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:49:08 +0000 (UTC)
X-FDA: 85346462376.16.2854742
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B03CF80007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:49:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmZOMLDU;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583346;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FervRqDx8i9jzj8UVggEaA9nHNLpP+QF2H9C8Xb5FdU=;
	b=YohynuDa6MyctcMhsSTXQ0CJVBAaZ82LlMgw4eoiUeHXpExHnoD+p0BRmxaaZK1T+7dUWG
	FvLNvM5EZ7rQ4u9pUY85FEPL2gI8mmB6bf5kocMkJhuHWw06WP2Aaf2Ufo8sS/I5ocDZvX
	55WysFpV6XNMNifFU+fc+PlB7AEIdis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583346;
	b=tTPA3tmFZy1e8utxKKf4esmHVeuDAW4saoCKewiKlAD8qspXm3yHhChTc6/DKARsAhNqo7
	8vi+4Xk+ranzu84pslyzb4oREgWH5rZ+AMuDem6b8Ha1gZ8JQPnyz8iF3IddcVS2zfVpIE
	5gqirwIihDVNEkJX1NOxyicr1wYvvMo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmZOMLDU;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC6A043907;
	Wed, 21 Oct 2026 11:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C721F000C5;
	Wed, 21 Oct 2026 11:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583345;
	bh=FervRqDx8i9jzj8UVggEaA9nHNLpP+QF2H9C8Xb5FdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmZOMLDUUQi0UwuwJGYhc9GR1OTOG2SutD/x/jgPrcaIL46oWA5tCp2xIyhyNlwva
	 +Rsq+OgnE7TjUoFVs4kYE+5B3ThhbO0lUX5GC4T2ZL3DoA105twL/Y4IWqAMG1Z6f2
	 LESWTrO/APG+sllWvl8QqlqKLe9sASl5Fmi8yFjWPReZC0T1z2T5+iHLsxD8I48j1D
	 Gycm1PPJxlRckBfdAcl5z/ehkoo51hHBfQThehypbdBv6pRe/N80Mr0WHPqq499orI
	 7v59VjjYx8SfwqS+bkT8Ug/7e8+mFvUHZJhq+n5H2H/Wci0HaieYHkwQLx3meB7fNA
	 BkRIe/7NPcSiA==
Message-ID: <sashiko-outbox-180181@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/7] mm/page_owner: add open-coded page_owner
 iterator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhen Ni" <zhen.ni@easystack.cn>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021112437.1799213-5-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <20261021112437.1799213-5-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 11:49:04 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B03CF80007
X-Stat-Signature: diupnhgt78za6o4pyac9omf3nkigadqh
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792583346-292497
X-HE-Meta: U2FsdGVkX1+a2rz7P/yXqLfRkz0bXaNJvTTy2k2aEL8JcM6fIFvq4/IjbZ5ZVI+qizGDI8yBgFpCCQvTBXylJYcTc6Skk+SYUxUbmv7iMJMTPXzYsdzrV886TD201bwtSn2d6qIcK0VfL7c5PDVRZSJqbT3C5qFt7hBPe977H6CH7teZJSmT7VhdcJiG1WPgxA2FQVCDMxOo9rTr1dBNRWSAMd/2vr6HsxhUH3aTST5UtiGi5iNVfxTCzOzTReszup7NKIG1MrXZZi1VPMwtcJSc6Sd1vmr08JdxeGX/3RP5hj7nWhmaVFGDBZfn7G58K8PLKxTkIamPeF7ZwhqC8U4/FkiuFagPnqmC8LBYeT4EC6puWIlej7u+GmI1VWjsckgR/A9T+8zhN0UocHeLS062JPllZSDXuckknt8m2pTpzLkZo+z5pG1QaQzsxOOJ9LbbkvGiDUHQzljrFN2T0VOxq79YIoRp7VCTciK6GNL/BlgbvFWWgsdLKD+vmSbikNMXB5WWIoqWNBHTY3l+YY0MBZNCFnOz9ilrbr4fARE0hxTjRVyX4k03zomo9oFJjDXaxk16Ou61hhaGAiB9PKDTGjyjDEpG9aRhWhx2nKGU4hRddLzC1HNnk786eWX9g2T1qRWVvP+3icMBrIx/IviwMMvu7GJdyb42oEETj/LFgCC71MsdClD8VZSiF47jgtHZvqJyi85VLsvOts3fvy+Yi6XeXE7CZ+xNomnrUcmRe2uKc0cJxhM0jcChgwgQAVRGo7DvnPNL8j921wLWbFHJtZFJoHDntpRZ8XZ63PvQDitT8W4i4nw10/xgw/f6EzMTpbHLUKKItLi5RO78aEfsrUnN9g8qWvv3LU4jWcAMomenhEGPfn/no82+SpUnNukd1JCQ4LcDGzy7AVP7M/GGs7PxB4BxTofcO9jzXPEt8nUU0cGXXyUEm8kWGiBLL59hefCepSCSkyyeXob
 URUkiuma
 N23KVNne9i/z7NHSP7E9H91OrCzVmXK8X7xFObtJo2Bl03MGL9m50ELtWQcVorWYJiQasW3NqifWjWNT0C3uRxd1C5/LS9fiVgzGfokaUjIGmpnzjNDhLbdz/xxFN4WjKtzYuMuiQRUcoZDMS3kn4hfxXTofW8QG8vd9FZkNskEAq4DdR0Fa/XTMZWLczfFKOK55fGcxQ2jnLcY+AvZjlEkW64NcQN3l+SFzM1eSjMyk4cXdKL6ogeASf/N9XbuLGo0flpJAEHnuCeKWvUn4wOO81BlskzUryX3yjlOrGI7O9EXi1DIl6SQbE/mbmE0ek2EUnHyQvQ/9UBqMmzo1k3g/p3IHTqCViNRn0Q5215CkyHWZ4Vs96OaZtLotKq8iboLnNXOCnjnMXculGM6+BMFR8xgoHJ0rOLOU1ieuDlfSeEMMrIJHlYpphL4xjEtnsPQmsBBqQ2h5tg7w7S9D36DijEFkgIr82QOC4i9NkeXBOJfhj8JW5cSC5Kidwy5tn8lvyltWWqMdWA97CMeUErJDiVk5XFWyxTIRNei0EtGGQKFvc89TD8OqiYqIpnOxHGsk1E94WpSeEMHj4L+cTM/V13MWwL+YHi8NCTmoEuPpZxGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] mm/page_owner: forged handle and stack UAF in bpf_page_owner_s=
tack_snprint()
- [High] mm/page_owner: bpf_iter_page_owner_next() violates sticky-NULL con=
tract
- [High] mm/page_owner: buf__uninit in bpf_page_owner_stack_snprint() poiso=
ns stack
--

commit c92f39f3d2ecdefdc5191d503168d482f4fadf55
Author: Zhen Ni <zhen.ni@easystack.cn>

mm/page_owner: add open-coded page_owner iterator

This commit introduces an open-coded BPF iterator for page_owner using
bpf_iter_page_owner_new(), bpf_iter_page_owner_next(), and
bpf_iter_page_owner_destroy(), along with the bpf_page_owner_stack_snprint()
kfunc to format the current page's allocation stack trace into a buffer.

> diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
> index 529b2c4a589a9..4b9741a2de53c 100644
> --- a/mm/page_owner_iter.c
> +++ b/mm/page_owner_iter.c
[ ... ]
> @@ -116,3 +117,66 @@ int page_owner_iter_register(void)
[ ... ]
> +__bpf_kfunc struct page_owner_scan *
> +bpf_iter_page_owner_next(struct bpf_iter_page_owner *it)
> +{
> +	struct bpf_iter_page_owner_kern *kit =3D (void *)it;
> +
> +	if (!static_branch_unlikely(&page_owner_inited))
> +		return NULL;
> +
> +	cond_resched();
> +
> +	kit->scan.pfn++;
> +	if (!page_owner_next_eligible(&kit->scan))
> +		return NULL;

[Severity: High]
In kernel/bpf/verifier.c:process_iter_next_call(), once a KF_ITER_NEXT kfunc
returns NULL and transitions the iterator to BPF_ITER_STATE_DRAINED, the
verifier assumes any subsequent call on the same iterator also returns NULL
and marks BPF_REG_0 as constant scalar 0:

	cur_iter->iter.state =3D BPF_ITER_STATE_DRAINED;
	__mark_reg_const_zero(env, &cur_fr->regs[BPF_REG_0]);

However, mm/page_owner.c:page_owner_next_eligible() iterates using a local
pfn variable and only updates scan->pfn when an allocated page is reached:

	unsigned long pfn =3D scan->pfn;
	...
	for (; pfn < max_pfn; pfn++) {
		...
		scan->pfn =3D pfn;
		scan->po_snap =3D *page_owner;

When the loop reaches max_pfn without finding an eligible page, it returns
false while leaving kit->scan.pfn at the previously matched PFN plus one (or
min_low_pfn if no page matched).

If a BPF program calls bpf_iter_page_owner_next() again after it has return=
ed
NULL, kit->scan.pfn++ advances from that earlier PFN and rescans up to
max_pfn. Because the scan is lockless and calls cond_resched(), a concurrent
allocation in that tail PFN range (or max_pfn increasing via memory hotplug)
can cause bpf_iter_page_owner_next() to return a non-NULL &kit->scan pointer
at runtime when the verifier tracks R0 as scalar 0.

Should bpf_iter_page_owner_next() latch the drained state (or set
kit->scan.pfn to max_pfn on exhaustion and check it before incrementing) so
that subsequent calls cannot rescan or return non-NULL?

> +
> +	return &kit->scan;
> +}
> +
> +__bpf_kfunc void bpf_iter_page_owner_destroy(struct bpf_iter_page_owner =
*it)
> +{
> +}
> +
> +__bpf_kfunc int bpf_page_owner_stack_snprint(struct page_owner_scan *sca=
n,
> +					     char *buf__uninit, u32 buf__sz)

[Severity: High]
In mm/page_owner_iter.c:bpf_page_owner_stack_snprint(), the buffer argument
is annotated as buf__uninit paired with buf__sz.

In kernel/bpf/verifier.c:check_kfunc_args(), the __uninit suffix is only
handled for KF_ARG_PTR_TO_DYNPTR, whereas a KF_ARG_PTR_TO_MEM and
KF_ARG_MEM_SIZE pair is validated with BPF_READ | BPF_WRITE and raw_mode set
to false:

	ret =3D check_mem_size_reg(env, buff_reg, size_reg, buff_argno, argno,
				 BPF_READ | BPF_WRITE, true, meta, &failure);

At the same time, the static stack liveness pass in
record_arg_access() -> bpf_kfunc_stack_access_bytes() checks
is_kfunc_arg_uninit() and returns -size for buf__uninit:

	if (is_kfunc_arg_uninit(btf, &args[arg]))
		return -size;

In kernel/bpf/liveness.c:record_stack_access_off(), a negative access_bytes
marks all covered stack slots as must_write (dead prior to the call), even
though bpf_page_owner_stack_snprint() only writes up to len + 1 bytes. At a=
ny
state-pruning checkpoint before the call (such as inside a
bpf_iter_page_owner_next() loop), __clean_func_state() marks those dead sta=
ck
slots with STACK_POISON, causing check_mem_size_reg() ->
check_stack_range_initialized() to reject the BPF program with -EACCES.

Could buf__uninit be renamed to buf (or changed to an interface where the
verifier and stack liveness pass agree on initialization semantics) so that
passing a stack buffer in an iterator loop is not rejected?

> +{
> +	int len =3D 0;
> +
> +	if (!buf__uninit || !buf__sz)
> +		return 0;
> +
> +	if (static_branch_unlikely(&page_owner_inited))
> +		len =3D stack_depot_snprint(scan->po_snap.handle, buf__uninit,
> +					  buf__sz, 0);

[Severity: Critical]
In mm/page_owner_iter.c:bpf_page_owner_stack_snprint(), scan->po_snap.handle
is passed directly to stack_depot_snprint() -> stack_depot_fetch() ->
depot_fetch_stack(). In lib/stackdepot.c:depot_fetch_stack(), the handle is
assumed to be a valid stackdepot handle:

	if (pool_index >=3D pools_num_cached) {
		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
		     pool_index, pools_num_cached, handle);
		return NULL;
	}
	...
	stack =3D pool + offset;
	if (WARN_ON(!refcount_read(&stack->count)))
		return NULL;

An arbitrary handle value can trigger WARN() on an out-of-range pool_index =
or
zero refcount, or point stack at an arbitrary offset inside
stack_pools[pool_index] where a forged stack->size causes
stack_trace_snprint() to read out of bounds past the end of the pool.

There are two ways a BPF program can supply an arbitrary scan->po_snap.hand=
le
and corrupt or retain stack memory:

1. Because struct page_owner_scan and struct page_owner in mm/page_owner.h
contain only scalar fields and char comm[TASK_COMM_LEN],
__btf_type_is_scalar_struct() returns true. In
kernel/bpf/verifier.c:check_kfunc_args(), when a non-BTF pointer such as
PTR_TO_STACK or PTR_TO_MAP_VALUE is passed as struct page_owner_scan *scan,
the verifier falls back to fixed-size memory and accepts arbitrary
BPF-controlled bytes:

	if (!__btf_type_is_scalar_struct(env, meta->btf, ref_t, 0)) {
		...
		return -EINVAL;
	}
	kf_arg_type =3D KF_ARG_PTR_TO_MEM | MEM_FIXED_SIZE;
	fallthrough;

2. In mm/page_owner_iter.c:bpf_iter_page_owner_next(), the returned
&kit->scan pointer aliases the on-stack struct bpf_iter_page_owner slots as
PTR_TO_BTF_ID | PTR_TRUSTED. In kernel/bpf/verifier.c:check_kfunc_call(),
regs[BPF_REG_0].parent_id =3D meta.ref_obj.id is only set in the
!__btf_type_is_struct(ptr_type) branch, not in the PTR_TO_BTF_ID branch:

		if (meta.ref_obj.id) {
			err =3D validate_ref_obj(env, &meta.ref_obj);
			if (err)
				return err;
			regs[BPF_REG_0].parent_id =3D meta.ref_obj.id;
		}

		if (is_kfunc_rcu_protected(&meta))
			regs[BPF_REG_0].type |=3D MEM_RCU;
	} else {
		enum bpf_reg_type type =3D PTR_TO_BTF_ID;

Because parent_id remains 0 on the returned scan pointer, calling
bpf_iter_page_owner_destroy() marks the iterator stack slots STACK_INVALID
without invalidating registers holding scan. A BPF program can then reuse
those stack slots (spilling pointers or writing arbitrary scalars) and read
them back through scan or pass the overwritten scan->po_snap.handle to
bpf_page_owner_stack_snprint().

Can this be avoided by keeping the stackdepot handle internal to the opaque
struct bpf_iter_page_owner state (having bpf_page_owner_stack_snprint() take
struct bpf_iter_page_owner *it) and tying the lifetime of the pointer
returned by bpf_iter_page_owner_next() to the iterator's ref_obj_id?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021112437.1799=
213-1-zhen.ni@easystack.cn?part=3D4

