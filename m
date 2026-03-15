Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9FCF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 22:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F5E6B00A2; Sun, 15 Mar 2026 18:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E110D6B00E6; Sun, 15 Mar 2026 18:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4AD6B00E7; Sun, 15 Mar 2026 18:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B811E6B00A2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:57:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39A1C1B8A1E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:57:09 +0000 (UTC)
X-FDA: 84549809778.05.23743D3
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40FD9180006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:57:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FSivXUMv;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773615427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
	b=OiMf8X+Xh3OHjZWcZGcM47XjD+ih5ducLOw+SUAi/gXIqMbb5Pmc3TXYynfB5toLC2mKzm
	1ZSbytAyqS+UgtSgS2g5NfsezLyPHDSBNLhEwvvGXaT+2wg02Q0nDziMxVgWDypwetrezd
	7YtY7QEKCGaj4RXpI0D9eDgaHvq6Y8I=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FSivXUMv;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773615427; a=rsa-sha256;
	cv=pass;
	b=pOjB0rk5wKUHD8zwN6Ws3YDGGnL29mYg48QZRx4qX11PfixUAa8wBc1997ns1Zxq+nzgCq
	4/sVyxf7OKnW13SYbHz/sYh04Q+EVNriSduJu6oaum4ZK03FgTQF9fUoFDll+ZEOujOEj1
	ohh62ySH9z2K4oegW6m3jgd9C1GDfyg=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5091ed02c54so705311cf.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773615426; cv=none;
        d=google.com; s=arc-20240605;
        b=ce92N+zXCRWSO+zgc38DozUQMhuHDgFx5qOevQ5p2M+MC5ZnX2OPC+nwx5luhh8pZl
         4Qg5NyGuhJy0nfFDsXZNPrf9Pr1062arl5q/YfxvmvsjYP+tUlYG4TqZQk3FfVx95r9s
         eYOkQI6DmcrCJZf2IJ1SoRGXQkEYTnOMVxvlv1ofPjvLW6zMA06sEI7MYgoxhqK2kJZy
         OInwIRAf2dqiPb0KGqUcAItIFY9RorojkmOGRJoleeR24pg4rEjRrUR7L+4jl8CGVoF6
         AE6qc6CHKNlVCUc+fAig5eOSvkIxbXdxwtJHH58ZwMmFXHEQh3gJ5JuhRQ/VaiHI/+/L
         L/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        fh=QtQB4D1KStZSgAw5u84jQkgHOYuWu58akAlPE5c1xew=;
        b=L4RCZ26Jkcgw//vezFnLCGxTDFzcimf4iEUFXelkmmnDbnaTc0Rmi6cNl6qEkZo2Ao
         fqVQ6RGdQB/et8ICXSEtA8zO1Uv+iJS+wmDGn8LsuuqiqUvq9XpUfIvt0auO8ZA6iPF8
         r4KUntEKBanJcR9xuZY8NdUnLsbeBdk3Wg8MAq4Q4aO7fHhLRMHzrjo8B42OMv/TRkVE
         L2JE91w0Os4bJ0G7qbYEN1mynIf5m/cmDaydX/DFw8GVeMv7fkPLcfl7NxmrrkGsjeY8
         S1wP83mCdnH3Fd/T5dHqwfYww5W4IhdOQPqr9+sRXd2GMbWtMfVn1QFHtPBXNqEwedF5
         dcPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773615426; x=1774220226; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        b=FSivXUMvA2cxvnfPmNGQ3l1Dhi40tDyYpGyrXSMjITtug/BRp37RjoC2iGnUB8XGIN
         W2OtGqGEyyqypRJSKDBZ3ewFpeaIcPK7jCUqy9S+6p7ji7i1KIXN8yGO1cqC3FBSL1T1
         f+lNLDTCzNOCxsKP5iB+ZL1Ekitbtd+b8Vp0Qc0xUSnAdaR3ztfoB9Gr3sBhkQ/kjX9W
         7jc/PKbabhyThnpTf+Z57nY4uX9kLSuNm8w69tyAyhj9l2Nujn/o50iH4gwcIcBMX84E
         ClnKbrHw7RCcRCIu4OrIKuLDGgS5OpK25R+AE8MsoxbnGRZGtHpX8ghmqBfsmH9ORk63
         fBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773615426; x=1774220226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        b=aYAxaHCPcMkad0jLhWfm3kZcIyPzcDDygoa/lx0MWwGRjzIPhQE7B0tUAxtnA502PS
         Zx03c2AXsxmc66MDEJ6tfr87v7QBORd2qIOBhejE+6bv0MZ1Qpo9ot0OrRcAXKraqWRL
         O2Pj9qxej9WAX/KC+cwGAYoaO9fll+W+0bPfffEjXMi8EIKHfc2HlIyRrh/xDVgvO0PB
         yuuNphzZxd4nr1YnxQvIQ5k5egW8eawNaW43PxFUlWKuXvf3SgCksHzTjVeB0MyHMNBh
         bXz2HOUbR1OSVWtWSnHApBpxnPXr6k95YD/0sjwfEOP3hQwza4e5RdRyW+MzSeAltc78
         j65A==
X-Forwarded-Encrypted: i=1; AJvYcCWfpbKtIeDjg9b3R9Cmqm5P5MSuOAF1vkyScyuznLMLjXjRproSSbaESD8pH7iai/IxJ0e/tCkegQ==@kvack.org
X-Gm-Message-State: AOJu0YyDPGXp5E4zl9MhIFv2yFbEMgmIfaGs5xloC3wvSfczowCsnntA
	3Yn9xxfJgPtui++eU09ADmSLDQpFt1YvmZGNTllUjpeA4LZmBxvB/g9vHKsElXr5LwvaTqej8Gi
	6vSmnxdwPC2noRJYa3breifnlzbURoxSFR+oWSEqQ
X-Gm-Gg: ATEYQzwLJnGNoObPxWo0XSNdVEMWf0HhsARzYcMNpSaqjqc4FJJtfDYnCxmlEdWhcBN
	zt4DAvJ72cB1rrmmVf6jqD9oIx+kesCDT3r3vZ6BNW9Meb7kTyY1e6EnoWFNaCDbuoFgvndbWgS
	cj5lC8Jir0qSHEdNUxXvxQmbVBb32LKOOZ0Cotq8ykZFid/Amrft57XoQAU/Kuk2XlGuHq+SuHD
	f6MQ3lj6K3N1rng9ZbcPVEuU0N3/9ezsMfoKPc+mxkzznxagUv42N14tiePxqLO5j+3fJFqs2el
	5/Bak3OrisTPuFWw
X-Received: by 2002:a05:622a:1648:b0:509:72a:ae59 with SMTP id
 d75a77b69052e-509694c63a6mr20842221cf.10.1773615425456; Sun, 15 Mar 2026
 15:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
In-Reply-To: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 15:56:54 -0700
X-Gm-Features: AaiRm51Rev4ufazINlivV2AzV3ufvB013bFH7aap69X4pIxh6gJw0EUx7qrVlHk
Message-ID: <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 40FD9180006
X-Stat-Signature: k8oaoqxywuuznu94mccb1iekw5mjx96h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773615427-712472
X-HE-Meta: U2FsdGVkX18XbHdk5WjSMVZVSByaBZ8BKwlwceqF4GhZMUU0iwvd8Y2oBpAQMnWPfjKkx6pYcFnGJST8KJN+xYgeLYr/OQPBTZoWjYNdpcjQzZ7ef7hOSe/gKvx6Gii1j2U9Kxsq9uf87UaTIEJHzrMdmpQGsILP13Gn8bHk7kLjzK7y2n1XSNBp5Jmzf4/fNmBXIkXITK/ogYgL0Lqq/JeqnyNNCscPhWLImo5FW2bl6BqE5W3cwAqWAWMtoafwsCNsIV2tZWVLadyMnd7pkz/KBXPRf1dluVCwInQsdUz62599HPoBm8sUf2IM3/8qhSk+UvYL/2yXokj18JiMCjuI/KnW4xkRlPQm/3LTePfmdnLo88Rtc/9p9h6mm/AyeoXldggb920wcKuGGMz0ETCGsQ6fLK0BquvgtX/JzcJji3SVtcoY9afRrgkywC83Ai9IuyoQoKqolKehNsPmhMGonz8iPp/4PIJUr7mBA5Nm5hBfb+rFdHhiRJDxlIwmsXcZ8numPiFgQARDrCysn3IJMikqNoYLqfmSH5R1ejTB4m7Q/llzQoAj5z+pn4Kgnv5Yva1YocTEkUa3wI5kCsSj5cuq2x9e6smhkbQg6ujMwREoETiHAD8hv/aqDAt8e/xlyFV2oxaQdQb13XOe847mmcyNbTZbjM4Ml3DhC+4DUs79+o/sETHwa1iQv/2Co057NopZcTzrwrNFVom/zdO/dih97LzgxFlPIODwF4oZyVBeKe5GJwOt1fuM8qGnLMzbfp4eDxUo/kh5s5GXIMRynJ2uzeloTwocCjJLR7e8DHZen0EGLJimT7xKW8W/cXfZaVdWu+WIltK350rCZ6x1jhUWNXJ6f+lC13I8wv1ncssNP9yFjmT+IQQEunwvOLFo7cNiXUcvzzpLkfW6f7Ahb8BV8iaHqcFbYLtvvtG+OuY4rgnuuHGouiLvYr4fXtR/YOvRQwnxcscxsXu
 2d1D+1Yk
 XqVYOBayxXycWAyjCFqPr2fC5vvMu/C0gIq0N1dfrw5TuEnn7npTdOqY9bJpRAWnfm8XMDloaaYLXYQBpRDAmkwHvh2cnxPUeVjAfA+ltU4BW/0NOTr4MVI5aWXkzIibN7moJ83F5b9LNSeOjoh6NjLsgkpvlpoZgvZPTFEesHVN9LGMh8pGYFVp4UGlJdH+nxSNY0ySt8RPMIzfVcsPlwierdu/aqihpq08Rmpb5szLT9G/9qCxVvRXRSh8yfHINcS74rocUGT9DpOyZzFinYbX9Xh16H3GxTRbhVwhunpJcEO7UzY9Ynka8Yt/XKnbZyFFdDTCa1ptEOBjaAkCMJIYRKrTbQMd6z/953kAtKzwV6dQKLLg6vpo35x159ybf2FUA4Rq0tZDC1QasMFctL80ZwSzBzi8gV5Rm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Rather than passing arbitrary fields, pass an mmap_action field directly =
to
> mmap prepare and complete helpers to put all the action-specific logic in
> the function actually doing the work.
>
> Additionally, allow mmap prepare functions to return an error so we can
> error out as soon as possible if there is something logically incorrect i=
n
> the input.
>
> Update remap_pfn_range_prepare() to properly check the input range for th=
e
> CoW case.

By "properly check" do you mean the replacement of desc->start and
desc->end with action->remap.start and action->remap.start +
action->remap.size when calling get_remap_pgoff() from
remap_pfn_range_prepare()?

>
> While we're here, make remap_pfn_range_prepare_vma() a little neater, and
> pass mmap_action directly to call_action_complete().
>
> Then, update compat_vma_mmap() to perform its logic directly, as
> __compat_vma_map() is not used by anything so we don't need to export it.

Not directly related to this patch but while reviewing, I was also
checking vma locking rules in this mmap_prepare() + mmap() sequence
and I noticed that the new VMA flag modification functions like
vma_set_flags_mask() do assert vma_assert_locked(vma). It would be
useful to add these but as a separate change. I will add it to my todo
list.

>
> Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than calli=
ng
> the mmap_prepare op directly.
>
> Finally, update the VMA userland tests to reflect the changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/linux/fs.h                |   2 -
>  include/linux/mm.h                |   8 +--
>  mm/internal.h                     |  28 +++++---
>  mm/memory.c                       |  45 +++++++-----
>  mm/util.c                         | 112 +++++++++++++-----------------
>  mm/vma.c                          |  21 +++---
>  tools/testing/vma/include/dup.h   |   9 ++-
>  tools/testing/vma/include/stubs.h |   9 +--
>  8 files changed, 123 insertions(+), 111 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..a2628a12bd2b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2058,8 +2058,6 @@ static inline bool can_mmap_file(struct file *file)
>         return true;
>  }
>
> -int __compat_vma_mmap(const struct file_operations *f_op,
> -               struct file *file, struct vm_area_struct *vma);
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
>
>  static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma=
)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4c4fd55fc823..cc5960a84382 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4116,10 +4116,10 @@ static inline void mmap_action_ioremap_full(struc=
t vm_area_desc *desc,
>         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(d=
esc));
>  }
>
> -void mmap_action_prepare(struct mmap_action *action,
> -                        struct vm_area_desc *desc);
> -int mmap_action_complete(struct mmap_action *action,
> -                        struct vm_area_struct *vma);
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action);
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action);
>
>  /* Look up the first VMA which exactly match the interval vm_start ... v=
m_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm=
,
> diff --git a/mm/internal.h b/mm/internal.h
> index 95b583e7e4f7..7bfa85b5e78b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1775,26 +1775,32 @@ int walk_page_range_debug(struct mm_struct *mm, u=
nsigned long start,
>  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
>  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
>
> -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pf=
n);
> -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long a=
ddr,
> -               unsigned long pfn, unsigned long size, pgprot_t pgprot);
> +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                           struct mmap_action *action);
> +int remap_pfn_range_complete(struct vm_area_struct *vma,
> +                            struct mmap_action *action);
>
> -static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> -               unsigned long orig_pfn, unsigned long size)
> +static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                                            struct mmap_action *action)
>  {
> +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> +       const unsigned long size =3D action->remap.size;
>         const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, size=
);
>
> -       return remap_pfn_range_prepare(desc, pfn);
> +       action->remap.start_pfn =3D pfn;
> +       return remap_pfn_range_prepare(desc, action);
>  }
>
>  static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma=
,
> -               unsigned long addr, unsigned long orig_pfn, unsigned long=
 size,
> -               pgprot_t orig_prot)
> +                                             struct mmap_action *action)
>  {
> -       const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, size=
);
> -       const pgprot_t prot =3D pgprot_decrypted(orig_prot);
> +       const unsigned long size =3D action->remap.size;
> +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> +       const pgprot_t orig_prot =3D vma->vm_page_prot;
>
> -       return remap_pfn_range_complete(vma, addr, pfn, size, prot);
> +       action->remap.pgprot =3D pgprot_decrypted(orig_prot);
> +       action->remap.start_pfn  =3D io_remap_pfn_range_pfn(orig_pfn, siz=
e);
> +       return remap_pfn_range_complete(vma, action);
>  }
>
>  #ifdef CONFIG_MMU_NOTIFIER
> diff --git a/mm/memory.c b/mm/memory.c
> index 6aa0ea4af1fc..364fa8a45360 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3099,26 +3099,34 @@ static int do_remap_pfn_range(struct vm_area_stru=
ct *vma, unsigned long addr,
>  }
>  #endif
>
> -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pf=
n)
> +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                           struct mmap_action *action)
>  {
> -       /*
> -        * We set addr=3DVMA start, end=3DVMA end here, so this won't fai=
l, but we
> -        * check it again on complete and will fail there if specified ad=
dr is
> -        * invalid.
> -        */
> -       get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, desc-=
>end,
> -                       desc->start, desc->end, pfn, &desc->pgoff);
> +       const unsigned long start =3D action->remap.start;
> +       const unsigned long end =3D start + action->remap.size;
> +       const unsigned long pfn =3D action->remap.start_pfn;
> +       const bool is_cow =3D vma_desc_is_cow_mapping(desc);

I was trying to figure out who sets action->remap.start and
action->remap.size and if they somehow guaranteed to be always equal
to desc->start and (desc->end - desc->start). My understanding is that
action->remap.start and action->remap.size are set by
f_op->mmap_prepare() but I'm not sure if they are always the same as
desc->start and (desc->end - desc->start) and if so, how do we enforce
that.

> +       int err;
> +
> +       err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->en=
d, pfn,
> +                             &desc->pgoff);
> +       if (err)
> +               return err;
> +
>         vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
> +       return 0;
>  }
>
> -static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, unsig=
ned long addr,
> -               unsigned long pfn, unsigned long size)
> +static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
> +                                      unsigned long addr, unsigned long =
pfn,
> +                                      unsigned long size)
>  {
> -       unsigned long end =3D addr + PAGE_ALIGN(size);
> +       const unsigned long end =3D addr + PAGE_ALIGN(size);
> +       const bool is_cow =3D is_cow_mapping(vma->vm_flags);
>         int err;
>
> -       err =3D get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, end,
> -                             vma->vm_start, vma->vm_end, pfn, &vma->vm_p=
goff);
> +       err =3D get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->vm=
_end,
> +                             pfn, &vma->vm_pgoff);
>         if (err)
>                 return err;
>
> @@ -3151,10 +3159,15 @@ int remap_pfn_range(struct vm_area_struct *vma, u=
nsigned long addr,
>  }
>  EXPORT_SYMBOL(remap_pfn_range);
>
> -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long a=
ddr,
> -               unsigned long pfn, unsigned long size, pgprot_t prot)
> +int remap_pfn_range_complete(struct vm_area_struct *vma,
> +                            struct mmap_action *action)
>  {
> -       return do_remap_pfn_range(vma, addr, pfn, size, prot);
> +       const unsigned long start =3D action->remap.start;
> +       const unsigned long pfn =3D action->remap.start_pfn;
> +       const unsigned long size =3D action->remap.size;
> +       const pgprot_t prot =3D action->remap.pgprot;
> +
> +       return do_remap_pfn_range(vma, start, pfn, size, prot);
>  }
>
>  /**
> diff --git a/mm/util.c b/mm/util.c
> index ce7ae80047cf..dba1191725b6 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1163,43 +1163,6 @@ void flush_dcache_folio(struct folio *folio)
>  EXPORT_SYMBOL(flush_dcache_folio);
>  #endif
>
> -/**
> - * __compat_vma_mmap() - See description for compat_vma_mmap()
> - * for details. This is the same operation, only with a specific file op=
erations
> - * struct which may or may not be the same as vma->vm_file->f_op.
> - * @f_op: The file operations whose .mmap_prepare() hook is specified.
> - * @file: The file which backs or will back the mapping.
> - * @vma: The VMA to apply the .mmap_prepare() hook to.
> - * Returns: 0 on success or error.
> - */
> -int __compat_vma_mmap(const struct file_operations *f_op,
> -               struct file *file, struct vm_area_struct *vma)
> -{
> -       struct vm_area_desc desc =3D {
> -               .mm =3D vma->vm_mm,
> -               .file =3D file,
> -               .start =3D vma->vm_start,
> -               .end =3D vma->vm_end,
> -
> -               .pgoff =3D vma->vm_pgoff,
> -               .vm_file =3D vma->vm_file,
> -               .vma_flags =3D vma->flags,
> -               .page_prot =3D vma->vm_page_prot,
> -
> -               .action.type =3D MMAP_NOTHING, /* Default */
> -       };
> -       int err;
> -
> -       err =3D f_op->mmap_prepare(&desc);
> -       if (err)
> -               return err;
> -
> -       mmap_action_prepare(&desc.action, &desc);
> -       set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(&desc.action, vma);
> -}
> -EXPORT_SYMBOL(__compat_vma_mmap);
> -
>  /**
>   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
>   * existing VMA and execute any requested actions.
> @@ -1228,7 +1191,31 @@ EXPORT_SYMBOL(__compat_vma_mmap);
>   */
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -       return __compat_vma_mmap(file->f_op, file, vma);
> +       struct vm_area_desc desc =3D {
> +               .mm =3D vma->vm_mm,
> +               .file =3D file,
> +               .start =3D vma->vm_start,
> +               .end =3D vma->vm_end,
> +
> +               .pgoff =3D vma->vm_pgoff,
> +               .vm_file =3D vma->vm_file,
> +               .vma_flags =3D vma->flags,
> +               .page_prot =3D vma->vm_page_prot,
> +
> +               .action.type =3D MMAP_NOTHING, /* Default */
> +       };
> +       int err;
> +
> +       err =3D vfs_mmap_prepare(file, &desc);
> +       if (err)
> +               return err;
> +
> +       err =3D mmap_action_prepare(&desc, &desc.action);
> +       if (err)
> +               return err;
> +
> +       set_vma_from_desc(vma, &desc);
> +       return mmap_action_complete(vma, &desc.action);
>  }
>  EXPORT_SYMBOL(compat_vma_mmap);
>
> @@ -1320,8 +1307,8 @@ void snapshot_page(struct page_snapshot *ps, const =
struct page *page)
>         }
>  }
>
> -static int mmap_action_finish(struct mmap_action *action,
> -               const struct vm_area_struct *vma, int err)
> +static int mmap_action_finish(struct vm_area_struct *vma,
> +                             struct mmap_action *action, int err)
>  {
>         /*
>          * If an error occurs, unmap the VMA altogether and return an err=
or. We
> @@ -1355,35 +1342,36 @@ static int mmap_action_finish(struct mmap_action =
*action,
>   * action which need to be performed.
>   * @desc: The VMA descriptor to prepare for @action.
>   * @action: The action to perform.
> + *
> + * Returns: 0 on success, otherwise error.
>   */
> -void mmap_action_prepare(struct mmap_action *action,
> -                        struct vm_area_desc *desc)
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action)

Any reason you are swapping the arguments?
It also looks like we always call mmap_action_prepare() with action =3D=3D
desc->action, like this: mmap_action_prepare(&desc.action, &desc). Why
don't we eliminate the action parameter altogether and use desc.action
from inside the function?

> +

extra new line.

>  {
>         switch (action->type) {
>         case MMAP_NOTHING:
> -               break;
> +               return 0;
>         case MMAP_REMAP_PFN:
> -               remap_pfn_range_prepare(desc, action->remap.start_pfn);
> -               break;
> +               return remap_pfn_range_prepare(desc, action);
>         case MMAP_IO_REMAP_PFN:
> -               io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
> -                                          action->remap.size);
> -               break;
> +               return io_remap_pfn_range_prepare(desc, action);
>         }
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);
>
>  /**
>   * mmap_action_complete - Execute VMA descriptor action.
> - * @action: The action to perform.
>   * @vma: The VMA to perform the action upon.
> + * @action: The action to perform.
>   *
>   * Similar to mmap_action_prepare().
>   *
>   * Return: 0 on success, or error, at which point the VMA will be unmapp=
ed.
>   */
> -int mmap_action_complete(struct mmap_action *action,
> -                        struct vm_area_struct *vma)
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action)
> +
>  {
>         int err =3D 0;
>
> @@ -1391,23 +1379,19 @@ int mmap_action_complete(struct mmap_action *acti=
on,
>         case MMAP_NOTHING:
>                 break;
>         case MMAP_REMAP_PFN:
> -               err =3D remap_pfn_range_complete(vma, action->remap.start=
,
> -                               action->remap.start_pfn, action->remap.si=
ze,
> -                               action->remap.pgprot);
> +               err =3D remap_pfn_range_complete(vma, action);
>                 break;
>         case MMAP_IO_REMAP_PFN:
> -               err =3D io_remap_pfn_range_complete(vma, action->remap.st=
art,
> -                               action->remap.start_pfn, action->remap.si=
ze,
> -                               action->remap.pgprot);
> +               err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
>         }
>
> -       return mmap_action_finish(action, vma, err);
> +       return mmap_action_finish(vma, action, err);
>  }
>  EXPORT_SYMBOL(mmap_action_complete);
>  #else
> -void mmap_action_prepare(struct mmap_action *action,
> -                       struct vm_area_desc *desc)
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action)
>  {
>         switch (action->type) {
>         case MMAP_NOTHING:
> @@ -1417,11 +1401,13 @@ void mmap_action_prepare(struct mmap_action *acti=
on,
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);
>
> -int mmap_action_complete(struct mmap_action *action,
> -                       struct vm_area_struct *vma)
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action)
>  {
>         int err =3D 0;
>
> @@ -1436,7 +1422,7 @@ int mmap_action_complete(struct mmap_action *action=
,
>                 break;
>         }
>
> -       return mmap_action_finish(action, vma, err);
> +       return mmap_action_finish(vma, action, err);
>  }
>  EXPORT_SYMBOL(mmap_action_complete);
>  #endif
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..054cf1d262fb 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2613,15 +2613,19 @@ static void __mmap_complete(struct mmap_state *ma=
p, struct vm_area_struct *vma)
>         vma_set_page_prot(vma);
>  }
>
> -static void call_action_prepare(struct mmap_state *map,
> -                               struct vm_area_desc *desc)
> +static int call_action_prepare(struct mmap_state *map,
> +                              struct vm_area_desc *desc)
>  {
>         struct mmap_action *action =3D &desc->action;
> +       int err;
>
> -       mmap_action_prepare(action, desc);
> +       err =3D mmap_action_prepare(desc, action);
> +       if (err)
> +               return err;
>
>         if (action->hide_from_rmap_until_complete)
>                 map->hold_file_rmap_lock =3D true;
> +       return 0;
>  }
>
>  /*
> @@ -2645,7 +2649,9 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>         if (err)
>                 return err;
>
> -       call_action_prepare(map, desc);
> +       err =3D call_action_prepare(map, desc);
> +       if (err)
> +               return err;
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> @@ -2700,13 +2706,12 @@ static bool can_set_ksm_flags_early(struct mmap_s=
tate *map)
>  }
>
>  static int call_action_complete(struct mmap_state *map,
> -                               struct vm_area_desc *desc,
> +                               struct mmap_action *action,
>                                 struct vm_area_struct *vma)
>  {
> -       struct mmap_action *action =3D &desc->action;
>         int ret;
>
> -       ret =3D mmap_action_complete(action, vma);
> +       ret =3D mmap_action_complete(vma, action);
>
>         /* If we held the file rmap we need to release it. */
>         if (map->hold_file_rmap_lock) {
> @@ -2768,7 +2773,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>         __mmap_complete(&map, vma);
>
>         if (have_mmap_prepare && allocated_new) {
> -               error =3D call_action_complete(&map, &desc, vma);
> +               error =3D call_action_complete(&map, &desc.action, vma);
>
>                 if (error)
>                         return error;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 5eb313beb43d..908beb263307 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1106,7 +1106,7 @@ static inline int __compat_vma_mmap(const struct fi=
le_operations *f_op,
>
>                 .pgoff =3D vma->vm_pgoff,
>                 .vm_file =3D vma->vm_file,
> -               .vm_flags =3D vma->vm_flags,
> +               .vma_flags =3D vma->flags,
>                 .page_prot =3D vma->vm_page_prot,
>
>                 .action.type =3D MMAP_NOTHING, /* Default */
> @@ -1117,9 +1117,12 @@ static inline int __compat_vma_mmap(const struct f=
ile_operations *f_op,
>         if (err)
>                 return err;
>
> -       mmap_action_prepare(&desc.action, &desc);
> +       err =3D mmap_action_prepare(&desc, &desc.action);
> +       if (err)
> +               return err;
> +
>         set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(&desc.action, vma);
> +       return mmap_action_complete(vma, &desc.action);
>  }
>
>  static inline int compat_vma_mmap(struct file *file,
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/includ=
e/stubs.h
> index 947a3a0c2566..76c4b668bc62 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -81,13 +81,14 @@ static inline void free_anon_vma_name(struct vm_area_=
struct *vma)
>  {
>  }
>
> -static inline void mmap_action_prepare(struct mmap_action *action,
> -                                          struct vm_area_desc *desc)
> +static inline int mmap_action_prepare(struct vm_area_desc *desc,
> +                                     struct mmap_action *action)
>  {
> +       return 0;
>  }
>
> -static inline int mmap_action_complete(struct mmap_action *action,
> -                                          struct vm_area_struct *vma)
> +static inline int mmap_action_complete(struct vm_area_struct *vma,
> +                                      struct mmap_action *action)
>  {
>         return 0;
>  }
> --
> 2.53.0
>

