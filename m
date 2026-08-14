Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E79C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CA76B032B; Fri, 14 Aug 2026 19:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15356B032C; Fri, 14 Aug 2026 19:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A556B032D; Fri, 14 Aug 2026 19:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7437C6B032B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:37:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BB1DA0287
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:37:05 +0000 (UTC)
X-FDA: 85101488010.14.ADF13BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EEBE100009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:37:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6JZBt8V;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786750623;
	b=zo7yg6Z9wam1dFp1ihfcCxFXNdTHwAeZd9xD4QM5jzV29sKMU8UT0hWlXPXpQPJOoCtlaM
	UbD3F9WbcfFUC55dvuO8BOaFZ5+RImuHyB/3IUce/zgsvR89uiKjIWz6DuXiadOixaDtEg
	xQ9h9eUSdI5+vopMTlDUhJYOxKMc9Jw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6JZBt8V;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786750623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvbZtELhzDK1WfzEMAqobLP+yTEElm+FVF4XGfAW4Uc=;
	b=mPuDPd4Zu0gv0ERDcmQ+pF5EO0ISCAJ7qkWAqc8QKXWHvwWMLYgJWnZsbwLI+C5pDBZA9g
	r4JLV+/+8K3q7dIzQyJcwfrAD7YWsSnAzMcUxZ0BP5nGaMrv7khqK/kjbLQMCzlF6k8oiK
	kJTwrVMmkW7C/uEyx6Jbz90rnqhAjSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAF94600E2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601051F00A3F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786750622;
	bh=IvbZtELhzDK1WfzEMAqobLP+yTEElm+FVF4XGfAW4Uc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e6JZBt8Vpl5iRmjsWB2Zq5fu0la+ujO+B3ijGzlWsc9gQs+sK7fpoN7AB55Fv9x8F
	 52xnpEXqlCZcM1NC0M+0l4Y0U4ozBY/zHKxR++7foJIs2tn2Bbmi+ooCt/xhwUrLHM
	 6Z5FUUPvQQGVD8cjY0MOhBF4UxRYzFopkIy7NE9N+L8jkJLMKdfAkUnbfs2zP7JvVO
	 LpnTwnvseYw47nCWsm/DBBnBynDxvnVqB9XkwTIXrNjhoVdHEMvZ5zBStv+E9IjKVq
	 arMlKcwXYr43btIyyPeTe6jrOzAbQkFd6SAOJ32/+3XO046sxkSa4DrdAaifUOIwjP
	 iK451pWU/qyig==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9349ad9c857so167018685a.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:37:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YywvMZCfh0gMuTQw7eiAdNK5rX+nVHnWt7geFHCjL0MaJzk6cY2
	eA0RIVQUWfSqkvsLJRSqWdYi4ie1Xp397eAEl6t36KF87coq41/bDAjBbzsQXt2f0oluAop6BUK
	+5ruoFSbf19RLfN5yr4DNm2mgyE27BKU=
X-Received: by 2002:a05:620a:a805:b0:936:8c1e:b531 with SMTP id
 af79cd13be357-936d1fe3cefmr990381585a.10.1786750621764; Fri, 14 Aug 2026
 16:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260806103003.3924438-1-baoquan.he@linux.dev> <20260806103003.3924438-5-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-5-baoquan.he@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 07:36:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xrJhFrmG+Gr7ukPUS0NeKTgYT9VViN_niq8tHejp36cg@mail.gmail.com>
X-Gm-Features: AUfX_myx7hqVi3ex4DPqIMnJ4c3WF7mxdZVcMjdV1Salb4RvW4FWhGgeyZZ5Y2Q
Message-ID: <CAGsJ_4xrJhFrmG+Gr7ukPUS0NeKTgYT9VViN_niq8tHejp36cg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/6] mm/mglru: report hot PUDs from the rmap feedback path
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3EEBE100009
X-Stat-Signature: ep5efh6hzxx5pht7asgmjsz3azh3ykde
X-HE-Tag: 1786750623-83401
X-HE-Meta: U2FsdGVkX1/DhSaIhoBAnJgUK7dtbAKFqQYKNTs+0m1mqDD8HzFIFGZcqbrJyGigVbcSB9yM73+zkhm/kv8U0TyNwLOeOohT0cWNlpHD1gaQuNpjFE/Y3h03cezNK2tCaOjepus/HMRx6Df65kVa7HeMWkwNV9nwI9oVAjdxgvYX8Uhx3WQPBT2Y8SigcMQ9B5dfNcib9+TLoZemjGrix9GmDXUkjZq9bhgd2XOgiQ8/VxFxy5ubypX8CCbqdiQ2GRfraeHtfBRDd+UlV18LFhsowNBb3ul3/L/UzGOe9fPgMxbJIwsaMyMhEUWFdvg3vdZMEZR8H93UgHRARdRhHYJorsvP89KfFvPBmoSCWfCtB1+Htb9fLeAecco0tZLzvip594dVYGHtwHlurQaqWSPY3GJWWJfOyF2ehnQBwpAHJpaTmRDALgN9eMEd3DWEzB5YOP9YadmiyZSTPPnt2XB6Y2v5F5in9Ny6KL2Cuku+i1QKFekWNNqucS99yTO5EQSJKSvSoWJCCDlhZkeh8QdQxAjQBaUJ982SrMOx4nM+Gq+B4A22j+3pOH6JwnfR7YJddngj+gUjGf6nMmMV6BpXrg6ASZut8TWrCmxJiSqGQtN9RkClL1DN6O295YFqR/LJ4bukse0CfDK9N9qmmjf7eUVBd3XKOmO50V2OYX88vAMEBHJGVnx1M7AFPtiBChBRqjhB29BBws8HLilulAhC7Oxufommq/i2pYqG0twYjAXYMxnN0SKFfp0Ilx+5O+l/r4ZjzwMSIhPyRccEDeoiH+xIqeeTecn2e0ZB0Y+BmlIJCJ7k8fR+LpnAAv3qnQ5YxGWhM/J+WSKFHkjgOTp364R1cNQA5ttz5OEKsZFbeqQQF76dcC9BWE7Pp5XfQLbU0HUDz98M7Zr+XgDovldInGXSZmAoCSVH2wrb/G+mnimE6k/IaxxZcgdIajES29393Hggz3XDTSRhyqQ
 GpVZZvoz
 J/C4bLAojFVMKFAYwllh+EUyt7RtpOo5Sgih+MCi843byS2E5dSP3G0+cZByIAsNMfRQoupgd5o+woOccclnUaZT2WIUDNrRLLoabGZPgkyAWVENlP9oaGp0MrzorMxtHI/eo+Hs9Atp4NPHcdUatDzu5WzDLOpYFzFKwOGSCoVWymCM5EmJp+2vwGqB5pd+pzay+oguUW3KqcynqsEtY5c7SX+ViDcDiUtH+K51aVApV4onmEqRFJev8Md1EAUWoScXXUIxZRU/lgVKxcHENAecQRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 6:30=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> lru_gen_look_around() marks the PMD of a young PTE found during the
> eviction rmap walk, feeding hot regions back to the aging walker.
> With the PUD-level filter in place, that PMD marking alone is not
> enough: the next aging walk would test the containing PUD first and
> skip the whole 1GB subtree if the PUD is unmarked, never reaching the
> PMD. Mark the covering PUD as well, so regions whose hotness is only
> observed by eviction keep getting re-scanned by aging.
>
> The PUD entry is re-derived from the mm page tables via pgd_offset()/
> p4d_offset()/pud_offset(); it is only hashed, never dereferenced, and
> the mmap lock held by the rmap walk keeps the table chain valid.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/vmscan.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 74edfe2a747d..ca0f06641adc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4416,8 +4416,14 @@ bool lru_gen_look_around(struct page_vma_mapped_wa=
lk *pvmw, unsigned int nr)
>         lazy_mmu_mode_disable();
>
>         /* feedback from rmap walkers to page table walkers */
> -       if (mm_state && suitable_to_scan(i, young))
> +       if (mm_state && suitable_to_scan(i, young)) {
> +               /* the PUD entry covering the young PTEs scanned above */
> +               pud_t *pud_p =3D pud_offset(p4d_offset(pgd_offset(vma->vm=
_mm, pvmw->address),
> +                                                    pvmw->address), pvmw=
->address);
> +
>                 update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +               update_pud_bloom_filter(mm_state, max_seq, pud_p);

Is there a case where all PMDs return suitable_to_scan() =3D=3D false,
but the PUD is still worth updating? Or, if only one PMD returns
suitable_to_scan() =3D=3D true while the other 511 return false, is the
PUD still worth updating?
It seems we can keep it simple. I was just thinking through some
extreme cases =E2=80=94 maybe I'm overthinking it.

> +       }
>
>         mem_cgroup_put(memcg);
>

Best Regards
Barry

