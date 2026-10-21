Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FE6606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zj/Rld9E
Received: by kanga.kvack.org (Postfix)
	id 4AF356B06F2; Wed, 21 Oct 2026 07:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F976B06F4; Wed, 21 Oct 2026 07:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D696B06F5; Wed, 21 Oct 2026 07:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 198496B06F2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:49:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23447A050B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:49:15 +0000 (UTC)
X-FDA: 85346462670.20.A4A4E03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 71A1CC0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:49:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zj/Rld9E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583353;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjU3V+rd8zjjpGJql233pQuD6ax8MAtzDfiydIJHxGw=;
	b=WfovFUAUQ/ple+r+9kvGdkQz+gWuXdgluWTrVylVAsOwA+D6nq8b601SfDkyqPOsOazO+d
	AsXYySFIPvTZezg2bbzfG52zV/L76t6uRryDrZNpFUV1ASHIM4h170eXK6yqvQfQZFzedI
	RpgSl5HDYtFEEFojJdg68VMOXdLmbtg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zj/Rld9E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583353;
	b=rb6rgjIPCiIqEUbFARpFbn0yeETOPH6vYCyNMD1EOW1khTHIM01dA8xRZn7eIRZeePR56P
	ZD98YkYDMW/nFDAozDcRTDNGyEXYl+q8HsJ5gCryGY/8oAvUZkcW/giPoGt1wAjcLZmcoe
	KI3Ha2nRqCRzqh2hx1fftCmNU2+V/8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0D27419C1;
	Wed, 21 Oct 2026 11:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658EA1F000C7;
	Wed, 21 Oct 2026 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583352;
	bh=FjU3V+rd8zjjpGJql233pQuD6ax8MAtzDfiydIJHxGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zj/Rld9EDCqOTfy6Op98uGK996/oHg6AFPiUzQHvATS2lJJxkpBk0JAzqY8edadT6
	 Sck6dbYuRaJ6se2+9dfM/UEuk22X1W/oCRcT0BUJVOujn2oWDJ9ENER/1eJgCM3aPF
	 YxOSkF4Otq9wd6oXioXyJcPdgESuHiyLQy47dU/oxYHZ1J1EdjHj7/nc2r7yDwUR4G
	 LKqI/+jGgoM9tfVLEHFHxEcKkKogF+K/F8yaVntTaSTzsLTwuuJwesqSA+/ey2R/bT
	 xFzqvFIyigsd611/OjtZCpduUe1GFASmJGTmvBcqzAdpLnuUkDI40upmy0ppGV9M/p
	 W4Elgji0ic5jA==
Message-ID: <sashiko-outbox-180182@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/7] mm/page_owner: add
 bpf_page_owner_get_memcg_info() kfunc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhen Ni" <zhen.ni@easystack.cn>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021112437.1799213-7-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <20261021112437.1799213-7-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 11:49:10 +0000
X-Rspamd-Queue-Id: 71A1CC0007
X-Stat-Signature: z93gyqznz4bpepfsy6fojz8gdtphseg5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583353-127703
X-HE-Meta: U2FsdGVkX1/uHIkuFSS5S4ipy7NO3xKzbh+Lmgu3A4WnUXV/7McSX8HjkwtiXgYSksPDSnCYL3n7cBsmA02IfV/mzlQ1bd7Aon1TFieVBZYdVeSw4yUD3WRU4WaTupJsXlf7RXvfFTBXeU9yJIROO3tlwcDWV1K8kaJmcRqB8le1l36Air3p9iagtpIt9wMLN0dY+oi86ye8yH9SGvPOHWIz01hd+3HawGYkSxaYc1mMsECzMdJqcfs47TNqYhBbxRxYaw/0PbCnYWQCz7gJhaxpfC5RX6HIka4XC6nrCJDZnZ0FTBoEzCsTN3wqXctjD/yRd7OM6vRqw1FRQfedYoJqtMURluNLBfwjOlZO+g++x3CCZx+ZLTtxzCHoQcKJP+2sxL6ulS+swWCX+aJZjAi81DDEgoerOsnTv94j4m9Bm/xUaPM72n5LR7iwfTfuZU9GeZ9iBvyLj9m/rc2zPlGSmCYq/gvgL3T+NPCXoAV74EROxnaNKF1AqBH5J4n3I+oJIZMd5qQX9r1iPTZT7OViQQzNJuls3OdBsDyCtXwUjYapWi7g57RIs3fJcYluGUq9d+OaY6BeUSncYVRsN9NrpFtsYNYYUqWP8BEEoWyXMDfACSxTD8/FOCpRBKpqDXweffregSn1JyCFx7NieRYU3zoTlzBx2UT0y+vozvUFHqDzmCDqjO7qgw6Dy/xi/62AsVGLSJqfzSfOMRiPKvUZ3EOv0yGuh+eu+HU8c015hmyVds2BPNATxDO5TP2jGfGcJQcJ5xCz3QY/YRdqCLgN6YepxBpgS92YZ7UrdSuIdNLASiF1tKhhTBwXRM7eDCuo1Tj4uCtl1KnlOwHANFqfnqv7a0BDLS6Xa/fEtnkdrjuVT2Kc1Oowp4C9y6SuhHVLZgHkIAeAkTTidG4u1IhaDviykgCtYG9vaNCEoYUn5fxjxSDGixwho4CcOV6qzyx2AX4zBnH+aT2EThu
 R+1kEOiX
 7svLhx0iLH6SxSqqtUEAh51xQ4RnDnVnNPPBwfCslT9l2qEvZye/ZrMfNQ+Hp5T1CYVJiHMT5AZHyIfR/yVlqWmSyG41tx/WI397M/6E/wmPDssdOueJyEOCYQg6G7ecrtYxPXomN0dJUbkRnt2rnaWfrbJpgA7LmiXVOGpoxMKGc3PkNwL5ds3XrawQeRcoRxdeY7zvyXTr9/Cb5lprpI66Rz5J27xDt11P9vzoJOo9Ew6ixaRV+fWhlGfsjrnzy/cYC6sKVvi4kBXQuzN+02OcfPkNJk/BXa/cI+yLW63pdebA75PzIJ84mjxMn1WAHc1DQkfK1yccjk0qI3yQuaJ9jQbLXqGV3Vt2MYMAPl0XeSrFrdU21u9Y6n7RQGHz+8UWdyClqyQiNURiY+D86SwhQCDntAWPU4BFNLCu0Sq2Dy6L8CImzHcg+2xc9mPdgN8lk+OQiz4V4YfXVfsm0cCxC02EML1/e0BoBy2dJQ0tjTzcdM8MWZHN/+9GEKS7TshgDBKmnq7mP6ikxfBYy5lJ/nw2aol9CpPppWY4kcA8uyeutPvlbdN0Nz7X1djmmrM0c0DOL/0xtSq+U1XdL+SjkYeGTp59e4MjbaErpJM08wKQ=
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
- [High] mm/page_owner: tail page _nr_pages dereferenced as objcg in get_pa=
ge_memcg_info()
- [Medium] mm/page_owner: __uninit in bpf_page_owner_get_memcg_info() poiso=
ns stack
- [Medium] mm/page_owner: missing __nullable on buf in bpf_page_owner_get_m=
emcg_info()
--

commit 6c73498afe7c643ebd28b236a8d852daad168a14
Author: Zhen Ni <zhen.ni@easystack.cn>

mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc

This commit factors per-page memcg lookup out of print_page_owner_memcg()
into get_page_memcg_info() and adds the bpf_page_owner_get_memcg_info()
kfunc so BPF page_owner iterators can retrieve memcg metadata and the full
cgroup path.

[ ... ]

> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8bc15bcdc24e9..7470b5d002be4 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -538,16 +538,22 @@ void pagetypeinfo_showmixedcount_print(struct seq_f=
ile *m,
> =20
>  #ifdef CONFIG_MEMCG
>  /*
> - * Looking for memcg information and print it out
> + * Collect memcg information of @page into @info; when @buf and a
> + * nonzero @size are given, also copy the full cgroup path of the
> + * charged memcg into @buf.
> + *
> + * Return: 0 if @page is charged to an attributable memcg; -ENODATA
> + * otherwise.
>   */
> -static inline int print_page_owner_memcg(char *kbuf, size_t count, int r=
et,
> -					 struct page *page)
> +int get_page_memcg_info(struct page *page, struct memcg_info *info,
> +			char *buf, int size)
>  {
>  	unsigned long memcg_data;
>  	struct obj_cgroup *objcg;
>  	struct mem_cgroup *memcg;
> -	bool online;
> -	char name[80];
> +	int ret =3D -ENODATA;
> +
> +	*info =3D (struct memcg_info){};
> =20
>  	rcu_read_lock();
>  	memcg_data =3D READ_ONCE(page->memcg_data);
> @@ -555,31 +561,68 @@ static inline int print_page_owner_memcg(char *kbuf=
, size_t count, int ret,
>  		goto out_unlock;
> =20
>  	if (memcg_data & MEMCG_DATA_OBJEXTS) {
> -		ret +=3D scnprintf(kbuf + ret, count - ret,
> -				"Slab cache page\n");
> +		info->is_slab =3D true;
>  		goto out_unlock;
>  	}
> =20
>  	objcg =3D (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
> -	memcg =3D objcg ? obj_cgroup_memcg(objcg) : NULL;
> +	if (!objcg)
> +		goto out_unlock;
> +
> +	memcg =3D obj_cgroup_memcg(objcg);

[Severity: High]
Can get_page_memcg_info() in mm/page_owner.c dereference folio->_nr_pages as
a struct obj_cgroup pointer when inspecting tail page 1 of a compound folio?

In struct folio (include/linux/mm_types.h), the first tail page (__page_1)
places _nr_pages at the same offset as struct page::memcg_data:

include/linux/mm_types.h:struct folio {
    ...
			atomic_t _mapcount_1;
			atomic_t _refcount_1;
#ifdef NR_PAGES_IN_LARGE_FOLIO
			unsigned int _nr_pages;
#endif
		};
		struct page __page_1;
    ...
}

For a compound folio with order >=3D 3, _nr_pages is 1U << order (for examp=
le,
0x8 or 0x200), so its low bits matching OBJEXTS_FLAGS_MASK are zero.

Because bpf_page_owner_get_memcg_info() in mm/page_owner_iter.c calls
get_page_memcg_info() on scan->pfn without stabilizing the page reference or
folio state (and struct page_owner_scan is a scalar-only struct that a BPF
program can also populate on the stack or in a map), page can refer to tail
page 1 of a compound folio.

In get_page_memcg_info(), page->memcg_data is read before checking
PageTail(page):

	memcg_data =3D READ_ONCE(page->memcg_data);
	if (!memcg_data || PageTail(page))
		goto out_unlock;

If tail page 1 is concurrently freed via __free_pages_prepare() ->
free_tail_page_prepare() -> clear_compound_head() after READ_ONCE() reads
_nr_pages into memcg_data, or if the folio is concurrently split to order 0
in mm/huge_memory.c:__split_folio_to_order() where clear_compound_head()
clears PageTail(new_head) before new_folio->memcg_data overwrites _nr_pages:

mm/huge_memory.c:__split_folio_to_order() {
    ...
		clear_compound_head(new_head);
		if (new_order) {
			prep_compound_page(new_head, new_order);
			folio_set_large_rmappable(new_folio);
		}
    ...
#ifdef CONFIG_MEMCG
		new_folio->memcg_data =3D folio->memcg_data;
#endif
}

wouldn't PageTail(page) evaluate to false while memcg_data holds 1UL << ord=
er,
causing obj_cgroup_memcg(objcg) to dereference that page count as a pointer?

[ ... ]

> diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
> index b7e0ce1dfa80a..a649e1207e246 100644
> --- a/mm/page_owner_iter.c
> +++ b/mm/page_owner_iter.c
> @@ -181,4 +181,52 @@ __bpf_kfunc int bpf_page_owner_stack_snprint(struct =
page_owner_scan *scan,
>  	return len;
>  }
> =20
> +/**
> + * bpf_page_owner_get_memcg_info - Report the memcg charged for the curr=
ent page
> + * @scan: page_owner scan handle.
> + * @info__uninit: output buffer for the memcg_info.
> + * @buf__uninit: optional output buffer for the full cgroup path.
> + * @buf__sz: size of @buf__uninit.
> + *
> + * Fills @info__uninit with the memcg charged for the page backing
> + * @scan->pfn.  If @buf__uninit and @buf__sz are provided, the full
> + * cgroup path is also copied out, so a BPF program can attribute a
> + * page_owner allocation to a specific cgroup.
> + *
> + * @scan->pfn is resolved to a struct page under get_online_mems(),
> + * so the page cannot be accessed after its memory section is offlined
> + * or removed.
> + *
> + * Returns:
> + * * 0 on success
> + * * -ENODATA if the page is not online or not charged to a memcg
> + * * -EOPNOTSUPP if built without CONFIG_MEMCG
> + */
> +__bpf_kfunc int bpf_page_owner_get_memcg_info(struct page_owner_scan *sc=
an,
> +					      struct memcg_info *info__uninit,
> +					      char *buf__uninit, u32 buf__sz)

[Severity: Medium]
Will the __uninit suffix on info__uninit and buf__uninit in
bpf_page_owner_get_memcg_info() (mm/page_owner_iter.c) cause the BPF verifi=
er
to reject valid programs that pass stack buffers across a pruning checkpoin=
t?

In kernel/bpf/verifier.c:bpf_kfunc_stack_access_bytes(), any kfunc argument
matching is_kfunc_arg_uninit() returns a negative size:

	if (is_kfunc_arg_uninit(btf, &args[arg]))
		return -size;
	return size;

That negative size tells record_stack_access_off() in kernel/bpf/liveness.c
that the kfunc call overwrites the stack slots without reading them, so sta=
tic
stack liveness analysis marks those slots dead prior to the call. When
clean_verifier_state() -> __clean_func_state() in kernel/bpf/states.c runs =
at
an earlier pruning checkpoint (such as the second iteration of
bpf_iter_page_owner_next(), or a branch/call after stack allocation), it
poisons those dead stack slots with STACK_POISON:

	for (j =3D start; j < end; j++)
		st->stack[i].slot_type[j] =3D STACK_POISON;

However, check_kfunc_args() in kernel/bpf/verifier.c only honors
is_kfunc_arg_uninit() for KF_ARG_PTR_TO_DYNPTR. For KF_ARG_PTR_TO_MEM
(info__uninit) and KF_ARG_MEM_SIZE (buf__uninit), check_kfunc_args() valida=
tes
the buffers with BPF_READ | BPF_WRITE:

	ret =3D check_mem_reg(env, reg, argno, type_size, BPF_READ | BPF_WRITE,
			    meta, &known_memory);
    ...
	ret =3D check_mem_size_reg(env, buff_reg, size_reg, buff_argno, argno,
				 BPF_READ | BPF_WRITE, true, meta, &failure);

When check_stack_range_initialized() in kernel/bpf/verifier.c performs the
BPF_READ check with allow_poison =3D=3D false, it hits *stype =3D=3D STACK_=
POISON and
fails verification with -EACCES ("slot poisoned by dead code elimination").

> +{
> +	struct page *page;
> +	int ret =3D -ENODATA;
> +
> +	if (!static_branch_unlikely(&page_owner_inited))
> +		goto nodata;
> +
> +	get_online_mems();
> +	page =3D pfn_to_online_page(scan->pfn);
> +	if (!page) {
> +		put_online_mems();
> +		goto nodata;
> +	}
> +	ret =3D get_page_memcg_info(page, info__uninit, buf__uninit, buf__sz);
> +	put_online_mems();
> +	return ret;
> +
> +nodata:
> +	*info__uninit =3D (struct memcg_info){};
> +	if (buf__uninit && buf__sz)
> +		buf__uninit[0] =3D '\0';

[Severity: Medium]
Should the optional cgroup path buffer parameter in
bpf_page_owner_get_memcg_info() (mm/page_owner_iter.c) use a __nullable
suffix so BPF programs can pass NULL when they only need struct memcg_info?

Both bpf_page_owner_get_memcg_info() and get_page_memcg_info() check whether
buf is NULL, and the kernel-doc describes buf__uninit as an optional output
buffer. However, in kernel/bpf/verifier.c:get_kfunc_arg_type(), PTR_MAYBE_N=
ULL
is only added when is_kfunc_arg_nullable() matches the "__nullable" (or
"__arena") suffix:

static bool is_kfunc_arg_nullable(const struct btf *btf, const struct btf_p=
aram *arg)
{
	return btf_param_match_suffix(btf, arg, "__nullable") ||
	       btf_param_match_suffix(btf, arg, "__arena");
}

Without a __nullable suffix on the buffer argument, check_kfunc_args() in
kernel/bpf/verifier.c rejects a BPF program that passes NULL (or a
PTR_MAYBE_NULL register) for arg#3 with -EACCES ("Possibly NULL pointer pas=
sed
to trusted arg#3").

> +	return ret;
> +}
> +
>  __bpf_kfunc_end_defs();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021112437.1799=
213-1-zhen.ni@easystack.cn?part=3D6

