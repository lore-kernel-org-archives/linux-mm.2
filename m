Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88035606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=od4mp1lj
Received: by kanga.kvack.org (Postfix)
	id A5F3C6B05B6; Sun, 22 Nov 2026 11:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A371E6B05B7; Sun, 22 Nov 2026 11:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978416B05B9; Sun, 22 Nov 2026 11:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79CD36B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:04:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06F7F1606C4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:04:09 +0000 (UTC)
X-FDA: 85463226618.13.CF76327
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55EEC180010
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:04:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=od4mp1lj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363447;
	b=GmfayLC1zyYA+3C44us29vxj0NCacWN5OMvAzS/IT8pH8yDLagNj8DmJZfbKCvH96Zwe2w
	M4SFRw0JalRjgcoivrPFLHw2oGHxlax6sSJKpmF6CNfPxdPF4Htnogdq0w92VcaJSHNK5I
	zr4eeIFMuYQrNcHqGlYL8uApxK9SZ5Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363447;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u5y5zGE2Pf7qEYb5K9ZeD/3c+cJ1a9rZgL59c6k4rs=;
	b=WEX91AdCxdjlm3ilZIKEV0yeLF3DG9Cj8Iz92tx7NVBP8tK+TFAtHYl3GtItqsdTUwsdZM
	XJZC6v0dSrfgjV3rXzMdL8eQddU1VQBEWz7209DLYbDFsP2rDWvlUgkv7QnuDCQoHFINs9
	HUfa0qfGjVVmEqubAFiqodF8mywXoFA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=od4mp1lj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87AA243F4D;
	Sun, 22 Nov 2026 16:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F131F000C6;
	Sun, 22 Nov 2026 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363446;
	bh=7u5y5zGE2Pf7qEYb5K9ZeD/3c+cJ1a9rZgL59c6k4rs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=od4mp1ljvGcVj0ltN6nuQcczVy5x7E9Ygo2gNUzw87mPqrpqxa7/rQyKHtfj5NUXJ
	 hRGOwMO0UVjL/rS1fOkxvApHcPWxG6HpuoEB4nWXDc8ibM1E/JV7e6kRpNJ5zTFwtM
	 3CwrdEnbhKAZWQkyH5F2lrkgLTPSqUy0W4unOqCUMJYHYSe+KeGtMOeiEWM+k8NahC
	 foZgud5H2kpqKlmpTl4OFblaNm9RElfcVhbfgF5+JIBIu71S/OMd4eZyO7rSr//qp2
	 D1O2TyZsi9yS6yfSepCI5lK/k0bU1BT8kOacrW/XdhgJfXi13q1BgcPm/lt7BasZgm
	 kMTRmMssDkmxg==
Message-ID: <sashiko-outbox-228074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] mm/vma: fix uncharge after failed stack relocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Pedro
 Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Jann
 Horn" <jannh@google.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Kees
 Cook" <kees@kernel.org>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ollie
 Wild" <aaw@google.com>, "Adrian Bunk" <bunk@stusta.de>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Hugh Dickins" <hughd@google.com>, "Joey Gouly" <joey.gouly@arm.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, "Chris Mason" <mason@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 16:04:04 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55EEC180010
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: bfx9yazhcbriyy5h94hd9cm8sok5d91c
X-HE-Tag: 1795363447-804213
X-HE-Meta: U2FsdGVkX1/T1urEhSCzgRFRNtQd7OeKlGTXdoEbJkq0zVRESAGDRw37r9zgpzE5QyqlhxQqePlHWdLqEtX4bF8A5ba0j6B4COEMS2m9APDtirXYkQD33bXUTfKDAGFNwjlbfocsh9HlQDHYtHhAtbIQ1DR/61InTr46Y96s+dc7n0s9XIaa5OtXRxNj1mY7zZ8sam15S3jAjptxriiIW5L8KCdXRUaFIBsF4D/Na2aDwjCDj60bCY7ZCRtX7gPGONv4a2xdltBsB8Q6ld32eerAIZ6d7fZN97Tp0GJ0IZd+5njlN+Z7zufl2MKRzD5TER6QcR93+5sEOpVNaApkFoEywZwVWYa0+oK/bf4lC0jueCuB68BG7GNGofFXf09i2v6kxmR51GF0aJhNTF+t3dDbdHddoQHsjNLcgXhkrEHDmlcTQTChUNAsaNHGV8m4L1+57SM29660nNlYvxELSzjqaRV+3wy+zgBX7Y8dMQt7pdkHYZJYRtEawqYl18yZrUDCxnoCkMK35Wjyf9OZ/XNCD1zFZ0YRtqAuFJ8GxexOxs7Qoed0tXZZqrSfczGIBs0XPw0A2jufVrhxN7f85tdI/n+oWm6Avlod6Fexu5mpzQTyu6cxxlkzF1OoGRNTAXh13PKy06e1KnJGonINCi23gnbd7QMBAAp9k0w6lzE4h7LIWog46HWdMxw5hcIsgfgUagz5yH9OYnDbrO9obmB4mr5Pii0ye6slN/+o7dioI5tvTHULFE+M+SXIoNbEJCCadQF4a8zsr/sgCCSjByu6MLY1jm3bUxBgPCU4Hw7ts1LPwlVJQAR6ODcOTO7Oi9hPDoTf8Dx7WVOnpq/9gud2fp30QXBGpS3/TnQghP49eqtUQNcka3Wjm90zrG+B2yhlbgtDk3p6mW+tHgqkml2p9DBeO9QNSBVOlgQsZemCZjda15+nWtwi68gt5hgVF29iXxISIJzKW5KrkKF
 DqsuE18Y
 xUofLnBgJE6/lbBZPVU9z4L3tnVDFVOpck/wlBqMcXoj0pUx3uAbDnjMo8WzLD+t/RZQU+pCXi5GdwVg1NKEEGNQobLPiARiW5MkBe+Y3USnrU2KYe+9i4WR9QIBx5JR6Nfzau5wHVXLk4YkP+ItMBLTu9o51sEsGCuNnjFc2IPawP1gigFuhuTxnfgBRO+U7mP0nBr4CVsokkBBqqIubXBaIc3msLZR1fphXMNRn6t3HoZKFSswCus1ygP940HZInXiXG7Y/x7BS2GD+yQintFSFRKVZdbiF0vezHbWnetrDQBpxnaMd/K2HfE+w1y5Jsk9rIVF2FsJ/0PWpZmQoYGoOGpexNDmKD7IACHjDb4u5QMM5tKOMsWa/ITmzdsyld8zr+U0W9l2NxN4My8vri+UcebGxMv6OUETa++QvPSGXLWm4dCGLF6KUjLmwYVePiOAyvNO+9h9nqtePEKnaC+EoWiGaVvtv9P49GI+ln3DB01GoWbnB+C6bym2IOC+tRO0vycIrV+tTIYYmxradX3/Q+zOU0wLI4YdNKf2GQaVn6QOC9vvptDyzw1Oc8w0sKmXLsOQBfQloJRz6ULS+qlkHb3qG9VW8QLjkNHMUoK2QK6J0OGidYu5g6f2OnRART0sCvReo99tIczMAM1oNDEsH8HebXxIpV95uJq6u/ovJ1NewO/APug8OfBZpYXa8kMpEwGdICy7yd6sRZRUqAPtpAKTt/rUJ7CslSQRSrBeCSdsiPJXgMXGO5UvvAX+TKMN6OBDP+1IonMWLm5HxkQgUoR4nSYdkXDj4CakhVX8amCI79syZIIDUeo/kQ25uwKaRfXc+ZY5OqiTSIGjyEhgXACloWXNplBlL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/vma: unaccounted writable VMA left mapped after
  relocate_vma_down() fails
--

commit 9c6f7e9f77d24dc1b72d41f3c440f1ede99ab822
Author: Chris Mason <mason@kernel.org>

mm/vma: fix uncharge after failed stack relocation

This commit uncharges the initial stack length and clears VMA_ACCOUNT_BIT
when relocate_vma_down() fails after expanding the stack VMA, avoiding a
vm_committed_as underflow in exit_mmap().

> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 586c521559424..84b98f1a201d7 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -45,6 +45,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsig=
ned long shift)
>  	struct vm_area_struct *next;
>  	struct mmu_gather tlb;
>  	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> +	int err;
> =20
>  	BUG_ON(new_start > new_end);
> =20
> @@ -68,8 +69,10 @@ int relocate_vma_down(struct vm_area_struct *vma, unsi=
gned long shift)
>  	 * process cleanup to remove whatever mess we made.
>  	 */
>  	pmc.for_stack =3D true;
> -	if (length !=3D move_page_tables(&pmc))
> -		return -ENOMEM;
> +	if (length !=3D move_page_tables(&pmc)) {
> +		err =3D -ENOMEM;
> +		goto err_unacct;
> +	}
> =20
>  	tlb_gather_mmu(&tlb, mm);
>  	next =3D vma_next(&vmi);
> @@ -93,7 +96,20 @@ int relocate_vma_down(struct vm_area_struct *vma, unsi=
gned long shift)
> =20
>  	vma_prev(&vmi);
>  	/* Shrink the vma to just the new range */
> -	return vma_shrink(&vmi, vma, new_end);
> +	err =3D vma_shrink(&vmi, vma, new_end);
> +	if (err)
> +		goto err_unacct;
> +
> +	return 0;
> +
> +err_unacct:
> +	/*
> +	 * The vma now spans more than was charged, so exit_mmap() must not
> +	 * derive the uncharge from its size.
> +	 */
> +	vm_unacct_memory(length >> PAGE_SHIFT);
> +	vma_clear_flags(vma, VMA_ACCOUNT_BIT);
> +	return err;
>  }

[Severity: High]
Does clearing VMA_ACCOUNT_BIT here leave the expanded [new_start, old_end)
stack VMA writable and unaccounted if the task does not immediately exit?

When execve() fails after bprm->point_of_no_return, bprm_execve() sends
SIGSEGV via force_fatal_sig(SIGSEGV) rather than force_exit_sig(SIGSEGV),
so SA_IMMUTABLE is not set.  If the task is ptraced (for example via
PTRACE_TRACEME) when a memory cgroup limit causes move_page_tables() or
vma_shrink() to fail with -ENOMEM, get_signal() intercepts the SIGSEGV in
ptrace_signal() and the tracer can suppress it by resuming with signal 0.

The task then survives in userspace with an unaccounted writable VMA of
size length + shift (up to 16 GiB for 64-bit tasks or 128 TiB for 32-bit
tasks on x86-64), allowing anonymous pages to be faulted in without
charging vm_committed_as (bypassing vm.overcommit_memory=3D2) and
underflowing mm->total_vm and mm->stack_vm (which remain at
length >> PAGE_SHIFT) if the VMA is later unmapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121-some-more-=
ai-fixes-v1-0-236e925d9b64@kernel.org?part=3D4

