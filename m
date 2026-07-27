Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECA2C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0BC6B0095; Mon, 27 Jul 2026 14:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A836B0098; Mon, 27 Jul 2026 14:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B6E6B0095; Mon, 27 Jul 2026 14:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 073766B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:51:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7817F160173
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:51:54 +0000 (UTC)
X-FDA: 85035450948.04.55395C0
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AA58100010
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:51:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CnfmLVau;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785178312;
	b=Wli3v97Y8be7+f24E4XFapJMJ0XLcG7h1sy07RFnOVOs4ZCnz/bTmvxQLuOjRQCFQ9+oqa
	eQuijbGJtDDd5xyFvMFZrIQnvPqltCBg44ZpKZOI4Nr3tmIKuHK5mbfFSMSLFo/tgE+/o/
	WD9THq5oIbEZEfeYv83yoSqHOgAx0PU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CnfmLVau;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785178312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TMQNsENWfT5dYJzPLTUhH7M21CQpD4PeHJ0TgPsyfQ=;
	b=lK3UmY1BWo340lmr2fq56tN1N9co+VWW6qgissn14Z9f1mm9tOHl+ueJinVeGPGVbJ0V+X
	lQe4U+VbZQh+rKmeNhP0N3ox5BDLgUKRANsWD6K7c9tFH0pguYloiNzxptVcjV13z1n14f
	YN7SDVv8bddJmLYB9mUP7fDdUIdlOa4=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c15a5b265so58231cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785178312; cv=none;
        d=google.com; s=arc-20260327;
        b=Eg648y+vIa77M1MSrVq+oy6Qe8SUdD5jMKXdXp5ySaxYB7kCutlGslUK6ecaTKusp/
         3e5RFxtUzONnm1c24Z+sUs8ZdZgx+g8ixdiTmZU/U5d2oLDPxYtgVLPbFuM2oOB9JqOY
         umn/i/msgfaTsZxbPhvLSO5VxiWwtGXI/mYvgaQTM/uuhNbeR0kT4mjySKL/rJHgf/6D
         b9CYuOmfu9C303fQp8e0o5C6IolTLLitVnAAF234OOI/moQWitPVgULROPl8z0bxtOJU
         Rrvkw4Rb2/dkpK4gcz4MfGWfR48jqQFPj1zAYHQYUyQT1/51zpgj8x8oPZnQBe7Y/2J9
         50lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2TMQNsENWfT5dYJzPLTUhH7M21CQpD4PeHJ0TgPsyfQ=;
        fh=1uypmeIxH1JPkhPp3VibS/nNFw8lvO9HY1CBfdpiBEQ=;
        b=WrNXBsJhGgy9JZ0ZvLOhgMW/lNvS1t23sJ86ugg8xQ9JcI4lTm6xwQmV4Zjynj03tN
         S4YZrZdGuifO3rASXYJ0gaGzq2pVfHw9HntMHUu0FSt0utNkldVSXdHf8D9YRkdfd9Eh
         J6TZpA3aTJXYBb2rf1S/tP3t++V2r23PcS85sogywcznJJ9UkZDtWWdQ8b3nraey+Haa
         cn0Iz4tq1xjOH4XFLb1Re/Yixge/1u7dKYMPkpcGMpRmFgXvg3A3c1wILVNRGDApEYnv
         vnq4ldDPlKuD7d8mELsm5HxMA+yEpcqjXYW8OhaDwHuh2Gb4UVV3NZ5X4DXfiOVKiP+n
         Oj2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785178312; x=1785783112; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2TMQNsENWfT5dYJzPLTUhH7M21CQpD4PeHJ0TgPsyfQ=;
        b=CnfmLVauDAlb38MUlI/M6ZHsKnqzXydmVpt8bwpptAChYoCon4OwxEyGwW0FkbEdZO
         NcdmYN9GSX6/kE4lX2rzdVPeAmxYwtkDuFmFus2yYLGQ7cMO6PG0Rgq85iweTAgmaeF+
         U2XDLDf062mpxGcW4L7BFrJoHPuGUX3Y1W/XYySvs/0KhuLbkgsKmQ8EuQqf5hDir8vF
         0Qahw5GMk6pKEyo6u70IN0KiDU2nIIJ09jLBiXCdrLd0DqB/t2a2eNNyEjNyy7+Fy9cw
         4FF9aUZfapvPaMWJzMRu4JXoSYYWGeAFHwpjyCp8Iz2A7VnRHBEp5ebny25ltDhyHdEg
         kLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785178312; x=1785783112;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2TMQNsENWfT5dYJzPLTUhH7M21CQpD4PeHJ0TgPsyfQ=;
        b=JvBIbEsa0J9c49sIQpq7BPCDFf3C4F3TSWQcxr1YmFv+3rruCMupMaLkZ2atNH6zkp
         jALduJ7BRm3nc0W72nlKXk403lD8AMEg/o018rxQP/PyML3lcsB6Clm0+6dmE3LZES98
         ITyRvIOlZpoySO743nNsduxk6hV24dHvEwA5ZlPJcqk3ZAy0GND71W+/TpkymaR3xwH1
         7yVt42iTjRuq1Lm2y4FHA7/s95LoBzhs1tdD73ZG7QjIAju14NJFFZO/DsgOhuizo8fn
         6d5t+N5aHsZJyoijrHLny4egXcmVPY0296ivgElPc6U8oGc5zdCkymzeEBQ0cBSKIPjM
         KsMg==
X-Forwarded-Encrypted: i=1; AHgh+RpL/TwMFxUk7L4waSwyO+ETJqDohLe2DzKOL1FyVppHR4MAq6jMQTDVhdF27QqgBoumhtkBnEPchA==@kvack.org
X-Gm-Message-State: AOJu0Yy8j9lMgnTfqgP3yyuImxuo6rD6h9epsZoqfUM/5kdDhMqwq+c5
	znSJ9TKBar8tpUhItk0uXSQzZHjcsMiWXWOMr7h/XHz0foR36vdja/ZI0X8HlTrYuCWuxtirX+L
	F6mvZ8Szj2Vr1Il29Dm9LknG3DkyY64YHkr23DH8r
X-Gm-Gg: AR+sD11BAwwu+9G57lSYUbtF+rL4dX1gUA0AW3KOcjvA28PApjhMqirjgFe+sstyT4/
	plZpHPUlnIfrhtYzRcHYVjrFATM2wtbmc4IJLDMDOJYoKPfou+NvzhQcY2Bz/b64qeiXEfV0fem
	ow5VplP4Yn6tUvQEao6hccKdjyfMuLZa9ym8vOgw1OASL6CjahNSFNwotvm3PPxMzS2RA202gZD
	DzRCbqfO6A0ACXhAIWJmdgWXUFKmsPxnV6ZOeU3KDA3Llhf7SZF9cBi2AEeuQlx515FrHQ=
X-Received: by 2002:a05:622a:5905:b0:519:b655:235 with SMTP id
 d75a77b69052e-529a766d13amr42933021cf.3.1785178310811; Mon, 27 Jul 2026
 11:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-7-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-7-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 11:51:39 -0700
X-Gm-Features: AUfX_myjODUfxP0pzztKbWEl8T0EpKg7ocUkCC18XxFYiP6lyJSzdpP0vxjtVO4
Message-ID: <CAJuCfpE_b9Up_yZCK5H35GTjV2s1D3HibU9iNud14f0rmvfPqg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 06/12] mm: use per-VMA lock in __access_remote_vm()
 for single-VMA accesses
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4zhgfcmm8h7ywq77r4y33myqo946igdg
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AA58100010
X-Rspam-User: 
X-HE-Tag: 1785178312-551913
X-HE-Meta: U2FsdGVkX19AOO4XE9q3a6YPE6YWdiuij2BM1QJEsd16Yj4rSQBai3kAoZHTvhQncWZehU+/t0mESbNRkgCnBn54ohNjYzmgOvOL0V5I9hMfsRyKH3f0CHnWtDT0leIftfMAYG5eZG7VaRexLxCQMX98ynQYRvZL3pjLcYqQqlOFmlSkd+VHKq0e1swPKYWSFS9cY5dAOF9IxGt0CH0q2GbdHlx0krWOVNKySumLqjbYbyj2uCNLEeg0qNnl7FdRmHT6Jxb44T8Qyz68/RNIKP5nVsVyRHltm4cqz3Q4CS62/SW5vM3BgQnNRFS6+jyoBEjErWrsopmvdzlLfwKzx4RuFZonTnlxRoGAXooOZvMPdep9pSVeI2dKiz682POPHu5UmTOM5+gaU24f34kF1g+yw5r88sLjDIF4uyyrQumXyVQfaIOh1H3v7CQnxzlElQQhYdKh0SmRT8PSM0eYarcyAlyt82+MHG3XPP2qpZnbBf0tc+iVLloeN2d/08ygCnOkJ36y8VSDruPTPBztfZWEgZ5di82SZLNqGVyt8PPEQW2jjoQPzmXEYIo4AbYgmU58RR0htmnb82N8NNcVh99CoRTlfLVAQemcZP8UoUy51FElApUe0d6Rm3VnbrlFZj70yp3fMdslCghaVOfjiMZTKS4frBrLC03tMaC6W6P9YyTm/nCFr5ZHn5Dn3Y2b355lAxwB+IB/VbzSLxlVyMJK/lbZa0YZutq+UgUJUJ1DpGN5XgtHF2jGxpWdibGvX9f0voz2AiEhRcuAMjxjL+g8KdjGEFuNtLQAIQdtmsAdpDJFL7DMPYu5WnaxcTy3A0o6G7FDhQWXmaIau3+1Vo4Df0kW062epb7AxPWj9s6uJbvaQkyuLq127bG81vJk74f4zScrtnZZ75ByRozgLEUvw8gWWxUvNvAaSRmhejJ6MEqGRUv5c5/bM2eZ+2+aSwusmGSd2/98zKcjkp7
 k4PwsEtA
 5gmWUDOzY2+/c8cMAgVTpkhmKlqeJrMHKFHqf8E7/AjERZ3/dGRqjRMa7l8DPx82phwVnkrKxobpS0gCMArllKEBTXN1abaZLjx33mHC3ZTRB4mgAu3h+Q+C+lzmPUtzzF5HM5qSoA2YkZbrubtoNhkXrJy4N8Gm+TJZufX1onlHX9Zn1KUxBWvnE/E2JR04v2QcwalFUl+RGYiBUl/wyP27DhMTE0qoHIiwIIvDhEBSopkl3FhjVFgFUEKY+Ch8rVkpnK3gbNJGF/2WjN7wXggce9egPlpId1v/QJFpWR8kmfESpfjBrX2lOf3RXh+i3fUBmZixf+RGj4k0kfGsRvHdeJVr7VQgAkFco1m9pkb6GnbgqXF/9YAp23Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:30=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> __access_remote_vm() holds mmap_read_lock() for the whole transfer. On
> large machines running big multi-threaded applications, that lock is
> contended between readers and writers: an mmap() or munmap() stalls reade=
rs
> like /proc/PID/cmdline, /proc/PID/environ, or /proc/PID/mem, even though =
the
> memory they read is almost always resident.
>
> Use the per-VMA lock to access a remote process's memory when the access
> fits in one VMA. Fall back to the mmap_lock if the access crosses VMA
> boundaries, or when get_user_page_vma() cannot finish the access under th=
e
> per-VMA lock.
>
> Factor the walk into remote_vm_walk(): it selects the lock, faults in eac=
h
> page with get_user_page_vma(), and hands the page to a per-page action.
> __access_remote_vm() passes access_vm_page(), which copies it; a later
> patch shares the walk for the remote string reader.
>
> remote_access_lock() and remote_access_unlock() keep the lock selection o=
ut
> of the walk. remote_access_lock() takes the per-VMA lock when the range
> fits one VMA whose flags permit the access, and the mmap lock otherwise,
> returning an ERR_PTR() when the mmap lock cannot be taken.
>
> Looking up the VMA first untags the remote address with
> untagged_addr_remote_unlocked(), added earlier in this series, so the unt=
ag
> needs no mmap lock.
>
> Walking the page tables under only the per-VMA lock is safe against both
> page table freeing and THP collapse.
>
> munmap() frees a VMA's page tables through free_pgtables(), which uses
> neither the page table lock nor RCU. But it runs only after the VMA is
> detached under the VMA write lock, which our per-VMA read lock excludes, =
so
> no page table of this VMA is torn down under the walk.
>
> THP collapse instead needs neither lock: file-backed collapse retracts a
> page table under i_mmap_lock and the page table lock alone. It frees the
> retracted PTE page by RCU, and pte_offset_map() holds the RCU read lock, =
so
> the page stays valid for the walk.
>
> follow_page_pte() takes that same page table lock through
> pte_offset_map_lock() and rechecks the pmd, so it either walks an intact
> table or sees the collapsed pmd and faults the THP in.
>
> get_user_page_vma() returns -EFAULT for memory with no struct page: the r=
aw
> PFNs of a VM_IO/VM_PFNMAP VMA, ioremapped device memory reached through
> ptrace and /proc/PID/mem.
>
> access_vm_page() reaches that memory under the mmap lock through
> vma->vm_ops->access(), via a new access_remote_vma_ops() helper, as
> get_user_pages_remote() and the old ->access() fallback did before.
>
> A COWed page in such a VMA now reads normally through get_user_page_vma()=
;
> previously it was routed to ->access(), whose generic_access_phys() rejec=
ts
> the ioremap of a RAM page.
>
> A single-threaded microbenchmark reading a remote process's memory throug=
h
> /proc/PID/mem shows the per-VMA path costs less than the old
> mmap_read_lock() plus get_user_pages_remote() route. The gain grows with
> the read size as the per-page VMA re-lookup drops away. Median of three
> pinned repetitions in a VM:
>
>         read size   baseline    per-VMA     throughput
>         8 B          201.7 ns    170.6 ns    ~15% faster
>         4 KB         495 ns      442 ns      +12% (8266 -> 9265 MB/s)
>         64 KB       4115 ns     3355 ns      +23% (15927 -> 19536 MB/s)
>         1 MB       75902 ns    63641 ns      +19% (13815 -> 16477 MB/s)
>
> This does not measure the multi-threaded reader-versus-writer contention
> that motivates the per-VMA lock; that case remains to be quantified.
>
> Assisted-by: Claude:claude-opus-4.8
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Some nits below but otherwise looks very nice!

> ---
>  mm/memory.c | 268 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 213 insertions(+), 55 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 3b86eeaf084f..273dfe12bc6d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7015,86 +7015,244 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
>  #endif
>
>  /*
> - * Access another process' address space as given in mm.
> + * VM_IO / VM_PFNMAP memory, such as an ioremapped device mapping, maps
> + * PFNs that have no struct page, so get_user_page_vma() cannot fetch it
> + * even though the page tables are populated. It can still be reached
> + * through vma->vm_ops->access().
> + *
> + * Returns the number of bytes transferred, or <=3D 0 if @vma cannot be
> + * accessed this way.
>   */
> -static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
> -                             void *buf, int len, unsigned int gup_flags)
> +static int access_remote_vma_ops(struct vm_area_struct *vma, unsigned lo=
ng addr,
> +                                void *buf, int len, int write)
> +{
> +#ifdef CONFIG_HAVE_IOREMAP_PROT
> +       if (vma->vm_ops && vma->vm_ops->access)
> +               return vma->vm_ops->access(vma, addr, buf, len, write);
> +#endif
> +       return 0;
> +}
> +
> +/*
> + * Lock @mm to reach the remote range [@addr, @addr + @len).
> + *
> + * Take the per-VMA lock when the whole range fits in a single VMA whose
> + * flags permit the access. The RCU freed page tables then keep page tab=
le
> + * memory from being reused with unexpected contents while the lock is h=
eld.
> + * Otherwise fall back to the mmap lock, which also covers multi-VMA ran=
ges,
> + * stack expansion, and ->access() memory.
> + *
> + * Return whether the mmap lock is held. The per-VMA locked VMA, when on=
e is
> + * taken, is stored in *@vmap; it is NULL on the mmap lock path. *@vmap =
is
> + * set to an ERR_PTR() when the mmap lock could not be taken, so callers=
 must
> + * check IS_ERR(*@vmap) before using either result.

This is an unusual way of returning an error. Why not return an int
with 0 for success, errno for any error and use *vmap to indicate
whether we took per-VMA lock (*vmap!=3DNULL) or mmap_lock (*vmap=3D=3DNULL)=
?
That seems to me less confusing.

> + */
> +static bool remote_access_lock(struct mm_struct *mm, unsigned long addr,
> +                              int len, unsigned int gup_flags,
> +                              struct vm_area_struct **vmap)
> +{
> +       struct vm_area_struct *vma =3D NULL;
> +
> +#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_=
FREE)
> +       vma =3D lock_vma_under_rcu(mm, addr);
> +       if (vma) {
> +               /* addr + len must not wrap, and must fit within the one =
VMA. */
> +               if (addr + len < addr || addr + len > vma->vm_end ||
> +                   check_vma_flags(vma, gup_flags, 0)) {
> +                       vma_end_read(vma);
> +                       vma =3D NULL;
> +               }

nit: This function can be simplified if we set vmap=3DNULL at the
beginning and then if the vma we found is fine then set *vmap=3Dvma and
return early.


> +       }
> +#endif
> +
> +       if (!vma) {
> +               if (mmap_read_lock_killable(mm)) {
> +                       *vmap =3D ERR_PTR(-EINTR);
> +                       return false;
> +               }
> +               *vmap =3D NULL;
> +               return true;
> +       }
> +
> +       *vmap =3D vma;
> +       return false;
> +}
> +
> +/* Release the lock taken by remote_access_lock(). */
> +static void remote_access_unlock(struct mm_struct *mm,
> +                                struct vm_area_struct *vma, bool have_mm=
ap_lock)
> +{
> +       if (have_mmap_lock)
> +               mmap_read_unlock(mm);
> +       else if (vma)
> +               vma_end_read(vma);
> +}
> +
> +/*
> + * Per-page action for a remote VM walk. Handle up to @len bytes at @add=
r on
> + * @page, advancing *@buf past the bytes read from or written to it. @pa=
ge is
> + * NULL for struct-page-less memory (VM_IO / VM_PFNMAP) reached under th=
e mmap
> + * lock.
> + *
> + * Return the number of source bytes handled at @addr, 0 to end the walk=
 (a
> + * string reached its NUL, or ->access() memory could not be reached), o=
r a
> + * negative errno to abort.
> + */
> +typedef int (*remote_vm_action)(struct vm_area_struct *vma, struct page =
*page,

Maybe we should use folio instead of page from the get go? I think you
can convert page to folio right after you get it from
get_user_page_vma().

> +                               unsigned long addr, void **buf, int len,
> +                               int write);
> +
> +/*
> + * Walk the remote range [@addr, @addr + @len) of @mm, handing each page=
 to
> + * @action. Use the per-VMA lock when the range fits one VMA, and fall b=
ack to
> + * the mmap lock for multi-VMA ranges, stack expansion (when @can_expand=
_stack
> + * is set), or when the per-VMA lock cannot finish a fault.
> + *
> + * Each page is faulted in with get_user_page_vma() under whichever lock=
 is
> + * held. Return the number of bytes @action consumed; *@err is a negativ=
e
> + * errno when the walk aborted, else 0.
> + */
> +static int remote_vm_walk(struct mm_struct *mm, unsigned long addr, void=
 *buf,
> +                         int len, unsigned int gup_flags, bool can_expan=
d_stack,
> +                         remote_vm_action action, int *err)
>  {
>         void *old_buf =3D buf;
>         int write =3D gup_flags & FOLL_WRITE;
> +       bool have_mmap_lock;

nit: I always associate have_xxx with features supported by a given
architecture. Maybe it's just me but I would prefer "mmap_locked" or
"mmap_lock_held".

> +       struct vm_area_struct *vma;
>
> -       if (mmap_read_lock_killable(mm))
> -               return 0;
> +       *err =3D 0;
>
> -       /* Untag the address before looking up the VMA */
> -       addr =3D untagged_addr_remote(mm, addr);
> +       /*
> +        * Set FOLL_REMOTE so check_vma_flags() applies the same protecti=
on key
> +        * rules as get_user_pages_remote() did: the current PKRU is not =
checked
> +        * against a VMA reached on @mm's behalf.
> +        */
> +       gup_flags |=3D FOLL_REMOTE;
>
> -       /* Avoid triggering the temporary warning in __get_user_pages */
> -       if (!vma_lookup(mm, addr) && !expand_stack(mm, addr))
> +       addr =3D untagged_addr_remote_unlocked(mm, addr);
> +
> +       have_mmap_lock =3D remote_access_lock(mm, addr, len, gup_flags, &=
vma);
> +       if (IS_ERR(vma)) {
> +               *err =3D -EFAULT;
>                 return 0;
> +       }
>
> -       /* ignore errors, just check how much was successfully transferre=
d */
>         while (len) {
> -               int bytes, offset;
> -               void *maddr;
> -               struct folio *folio;
> -               struct vm_area_struct *vma =3D NULL;
> -               struct page *page =3D get_user_page_lookup_vma(mm, addr,
> -                                                            gup_flags, &=
vma);
> +               unsigned int foll_flags =3D gup_flags;
> +               struct page *page;
> +               int ret;
>
> -               if (IS_ERR(page)) {
> -                       /* We might need to expand the stack to access it=
 */
> +               if (!vma || addr >=3D vma->vm_end) {
> +                       /* Any lookup here holds the mmap lock. */
> +                       VM_BUG_ON(!have_mmap_lock);
>                         vma =3D vma_lookup(mm, addr);
> -                       if (!vma) {
> +                       if (!vma && can_expand_stack) {
> +                               /* expand_stack() drops the mmap lock if =
it fails */
>                                 vma =3D expand_stack(mm, addr);
> -
> -                               /* mmap_lock was dropped on failure */
>                                 if (!vma)
> -                                       return buf - old_buf;
> -
> -                               /* Try again if stack expansion worked */
> -                               continue;
> +                                       have_mmap_lock =3D false;
>                         }
> +                       if (!vma) {
> +                               *err =3D -EFAULT;
> +                               break;
> +                       }
> +               }
>
> +               /*
> +                * FOLL_UNLOCKABLE lets the per-VMA fault retry, dropping=
 the
> +                * lock, so the walk can fall back to the mmap lock.
> +                */
> +               if (!have_mmap_lock)
> +                       foll_flags |=3D FOLL_VMA_LOCK | FOLL_UNLOCKABLE;
> +
> +               page =3D get_user_page_vma(vma, addr, foll_flags);
> +               if (IS_ERR(page)) {
>                         /*
> -                        * Check if this is a VM_IO | VM_PFNMAP VMA, whic=
h
> -                        * we can access using slightly different code.
> +                        * get_user_page_vma() returns -EAGAIN, with the =
per-VMA
> +                        * lock released, for anything it could not finis=
h under
> +                        * it; retake the mmap lock and retry. A differen=
t error
> +                        * therefore only arrives under the mmap lock, wh=
ere
> +                        * struct-page-less memory can be reached via ->a=
ccess().
>                          */
> -                       bytes =3D 0;
> -#ifdef CONFIG_HAVE_IOREMAP_PROT
> -                       if (vma->vm_ops && vma->vm_ops->access)
> -                               bytes =3D vma->vm_ops->access(vma, addr, =
buf,
> -                                                           len, write);
> -#endif
> -                       if (bytes <=3D 0)
> -                               break;
> -               } else {
> -                       folio =3D page_folio(page);
> -                       bytes =3D len;
> -                       offset =3D addr & (PAGE_SIZE-1);
> -                       if (bytes > PAGE_SIZE-offset)
> -                               bytes =3D PAGE_SIZE-offset;
> -
> -                       maddr =3D kmap_local_folio(folio, folio_page_idx(=
folio, page) * PAGE_SIZE);
> -                       if (write) {
> -                               copy_to_user_page(vma, page, addr,
> -                                                 maddr + offset, buf, by=
tes);
> -                               folio_mark_dirty_lock(folio);
> -                       } else {
> -                               copy_from_user_page(vma, page, addr,
> -                                                   buf, maddr + offset, =
bytes);
> +                       if (PTR_ERR(page) =3D=3D -EAGAIN) {
> +                               vma =3D NULL;
> +                               if (mmap_read_lock_killable(mm)) {
> +                                       *err =3D -EFAULT;
> +                                       break;
> +                               }
> +                               have_mmap_lock =3D true;
> +                               continue;
>                         }
> -                       folio_release_kmap(folio, maddr);
> +                       if (WARN_ON_ONCE(!have_mmap_lock))
> +                               break;
> +                       page =3D NULL;
>                 }
> -               len -=3D bytes;
> -               buf +=3D bytes;
> -               addr +=3D bytes;
> +
> +               ret =3D action(vma, page, addr, &buf, len, write);
> +               if (ret <=3D 0) {
> +                       if (ret < 0)
> +                               *err =3D ret;
> +                       break;
> +               }
> +               addr +=3D ret;
> +               len -=3D ret;
>         }
> -       mmap_read_unlock(mm);
> +
> +       remote_access_unlock(mm, vma, have_mmap_lock);
>
>         return buf - old_buf;
>  }
>
> +/*
> + * Copy one page's worth of [@addr, @addr + @len) to or from *@buf. Reac=
hes
> + * struct-page-less VM_IO / VM_PFNMAP memory through vma->vm_ops->access=
().
> + */
> +static int access_vm_page(struct vm_area_struct *vma, struct page *page,
> +                         unsigned long addr, void **buf, int len, int wr=
ite)
> +{
> +       struct folio *folio;
> +       int bytes, offset;
> +       void *maddr;
> +
> +       if (!page) {
> +               bytes =3D access_remote_vma_ops(vma, addr, *buf, len, wri=
te);
> +               if (bytes > 0)
> +                       *buf +=3D bytes;
> +               return bytes;
> +       }
> +
> +       bytes =3D len;
> +       offset =3D addr & (PAGE_SIZE - 1);
> +       if (bytes > PAGE_SIZE - offset)
> +               bytes =3D PAGE_SIZE - offset;
> +
> +       folio =3D page_folio(page);
> +       maddr =3D kmap_local_folio(folio, folio_page_idx(folio, page) * P=
AGE_SIZE);
> +       if (write) {
> +               copy_to_user_page(vma, page, addr, maddr + offset, *buf, =
bytes);
> +               folio_mark_dirty_lock(folio);
> +       } else {
> +               copy_from_user_page(vma, page, addr, *buf, maddr + offset=
, bytes);
> +       }
> +       folio_release_kmap(folio, maddr);
> +
> +       *buf +=3D bytes;
> +       return bytes;
> +}
> +
> +/*
> + * Access another process' address space as given in mm.
> + */
> +static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
> +                             void *buf, int len, unsigned int gup_flags)
> +{
> +       int err;
> +
> +       return remote_vm_walk(mm, addr, buf, len, gup_flags, true,
> +                             access_vm_page, &err);
> +}
> +
>  /**
>   * access_remote_vm - access another process' address space
>   * @mm:                the mm_struct of the target address space
> --
> 2.53.0-Meta
>
>

