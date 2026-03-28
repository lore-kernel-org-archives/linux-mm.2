Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB9210F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BB96B008C; Sat, 28 Mar 2026 14:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573AE6B0095; Sat, 28 Mar 2026 14:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488416B0096; Sat, 28 Mar 2026 14:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 363986B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:54:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD247C0BE6
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:54:29 +0000 (UTC)
X-FDA: 84596372658.06.1A3C948
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8A614000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:54:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sQc7O3Zx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774724067; a=rsa-sha256;
	cv=pass;
	b=Uc0lCHUnlR0mJdODahtZnhEiNtvnLyNzg7jozTNgNFYl0OaCelh7GZdCngeQ/hvIngZv2d
	++CPSB1ykVi8JDFk4rXsgxPsVaTwYZxYpb6sFDo1Tsc9BABn5wuSP6HGzlhbNsRL+0SI0j
	CSvmd2xMbS13gDBa3QrWinX3E3Wszg0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774724067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGId4vZC1Dy7Gb3F58XBcdmehVxPl1Wp8MGmSElnCno=;
	b=XEMTvzwjmIbU+Ghxcs7ADZ/586GtcTbnFB4WkCejusSmfOIWJdLi2k6nLYRknbb2dHh9wQ
	LERP71G/RqSjmJn/Y2hCAYytZ0abqgylawS6uGx1ZuAAN0E6kCGDtIx2ta3c4o1UhGGjxZ
	yAatfKhOO0t0fCLDtyfbsr3EikqkFmU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sQc7O3Zx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso430031cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:54:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774724067; cv=none;
        d=google.com; s=arc-20240605;
        b=d0Q/ZfH3cMZRlJRwn2MlS2yAooYgn+2MPPW+NZa06LbDyiIATVQnkGbFgBn3Zdb3on
         9Ouy5P2YuLWPsQzh+jUjwF7TcjP4vOa4uKXbL5qYOfIvKgGLvgCaGsINhELnhEyfgqEU
         fPy3v5bAsOKrBWumASsydOAg7FrvWCEdt33MxcWe4Gr/ACqvcXU9aSsNt8sJ12IUUsy/
         HHLSq2XigjdvyX+PHheF+4FNWxdn4t+s+O51HSRLVMAVpWf2qBP5qaD1cS1Td7gMiqah
         mdasxQa6+jaeiGWCMSyY5zUURFtDz+kHQ288z/HNvxv8ejxxxm12vvxYYpMxS5Y1hqGh
         UIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vGId4vZC1Dy7Gb3F58XBcdmehVxPl1Wp8MGmSElnCno=;
        fh=e27RiHJT7KKBwdW6Cs4oVqBmd40i5zLqrwHMWATQfqk=;
        b=Avltu0zn49IUTRCOy3UM7QCD/XXCrYrxvsJk31fiJb/TODeyjqHXhRz1M26ANA8h+1
         ikEwbOY6bXEL6vn6hzdp5mYyl1+abA2zw6rxwMOGT154GCRisOSC5XTYSFhUdZ2fez+W
         +J755sQqE7GS6nkRQPCokwfYL5TUxo6razHiHAtcRSW0WfFx2rhvBkEAWpCL5xYeIucJ
         dzXURXq9hzOzYiF76daEg7BA30q8WxPt+5FlWsTZ7DOXgjLSJzRLgGJYk1Qvq2etfErF
         l2ILQZs12/RcXskEe2t8LY5PNSGQwMb3ZWWEc5eLdm9Po35YF+Eq+kfyxkOrOJUjFIVv
         W1JA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774724067; x=1775328867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGId4vZC1Dy7Gb3F58XBcdmehVxPl1Wp8MGmSElnCno=;
        b=sQc7O3Zxixgb+M1UG/+GLO+Dj1ImVqvUBvzxcCktZ7xA8HTlZJOqjomCuW/ELlYYgz
         FmI2xGuNHCj9nGfBMUAljtprndbn7nWXInbnMfXqifAPHH1rOPhFEMRHyTt3QRn86sAJ
         qM1WwsS1kDE6tadFElFHtebqlEvu6TCaqv4mFthUy0+p1R/oGVzzlNRT7nfOhvkg+cd2
         x/GD3uRg+sIGJG7hpWYpUxPe+tPI2TKpR2J5uQ1Hy5KvPyUhwAGwsrXnPBzKxX/Gjz49
         vEBQx+DzKqV3uFzrh88RHoVxdg3GfU8CGeh5YJGgkkWW1YaNMV+xAgfFd+Xxxdjyo9gT
         zKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774724067; x=1775328867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vGId4vZC1Dy7Gb3F58XBcdmehVxPl1Wp8MGmSElnCno=;
        b=RVJFkLynpWvR1tbB6VIEI8tpas8bdTHdfxAd4JofqPjn+h9lDbx+9Cj9QMTbJa6W49
         qMe0HNa3hZlx64/i4Fd7XaU0SlRY5jB0eA9dutzz42M4f6KY/vztVk/N2HTNN9uMDclF
         uMnoIAJJR7xXXyMsvfv+gu8wtEe2/PEB8/LmauaIoio2O5EdY7kiwtvG9jfj+9y3WKvL
         Ch3iXjU7YWGxpUMNrLGBT8Ny4FHKwwBGDN1chUS4Hr72ZkClDKxVsts8jWCR62QfC64J
         BV//GGtQAsIp1gicPdginU+oJcMGHBmqKbbXKqXBFy/xmWN98w3q1oE9YHDkzR8qd9v+
         /vrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSt8W6xrd1CaZnMvymH5lW0/bfTLCjzDo9m7EDvIF2RGRwrKTSjFYcEx2gz9QD8JpfsmFTAx0/Jg==@kvack.org
X-Gm-Message-State: AOJu0Yy9XikL8pgZvXjQLlFNC9vCtusqokDxDbqIUctC6xqGWE1Ufumc
	hm8UacqH5VUZ14ll/nvXOyG+RCnyWI21c//T9aSMSUFltbFnxWhMY9cmRhtpn0zIFXPlfdD8+Ti
	JFsFFLMLWvFsp17cKeYbLmLF3N+nOr0NuUFSxQvcs
X-Gm-Gg: ATEYQzxCT2W3XYCIDJUGr9br2T/sqaUqVKqTgy0Kt0EkyDLW6t675JlOPSX3hwbZVUv
	Ef0Oc6CViEAsONqLXyUF/ZUxEcJ0kUu1+5sUmDb+BqCKJT7IGdfnOO8R1qqVr2yJImoDRFJ2HNO
	4YInzTyKBKopGSDx2hUuU6+3CMxNx1WGsrr19YzBdG0wrzqB1i4Y4/QoYaYJYEWnUB0naxXDtvt
	rYJKASFs8lP7dvVKClVBHfyhfaqlwb5glm6tPawTecRDw8rvlNyRtH8w9xfbaWVa43lY2TWjriY
	GLo3EA==
X-Received: by 2002:a05:622a:2285:b0:509:15b6:f69f with SMTP id
 d75a77b69052e-50bb263780fmr13309891cf.2.1774724066350; Sat, 28 Mar 2026
 11:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <132274566cd49d2960a2294c36dd2450593dfc55.1774029655.git.ljs@kernel.org>
In-Reply-To: <132274566cd49d2960a2294c36dd2450593dfc55.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 11:54:15 -0700
X-Gm-Features: AQROBzD8uLWFuyUaXQfbTtpPtu6w8edN3ZI49JzjOQuYMsY2PifccEN6ikuW5UI
Message-ID: <CAJuCfpFNoRz7kKCpfbCd4R_verR5c9og8dWVSJFO7viqDjSiCg@mail.gmail.com>
Subject: Re: [PATCH v3 03/13] mm/huge_memory: have zap_huge_pmd return a
 boolean, add kdoc
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8A614000A
X-Stat-Signature: hrtibm8y7aqjueqk6hzg4jrj6eyenabk
X-HE-Tag: 1774724067-601267
X-HE-Meta: U2FsdGVkX19LOzPFiTuFeTYnmP796YIgctxyVi+8vRe736wN74hXrzVT+S+JBydGDel+VVpLXWo35kBwsHVDBAoaE3eoZKjl7aBzhqU117N0T4Ukh+LjQ1XYHjZukbL1UC/xWiIzGU+kQ04aVa6Q9qG6agUwQbexliBxGdnW4G7JZawTqnwkBrP3Ea/Cd16X3C659XEkirG1bttSImHBBZl7rv9n2bOZDAUI+Yb4tSFvXzYlNLVWiRfSl+N8rMfE/6KqwwpiL+JyNeAU4HMB+re1So9RH+X9Jea20/reFHsNBt32WPlFUMl8+GVVv7faBTpiWI2SSxZMyu40UQYiU9mQQFGfXCZ/EPnnudsZaDtYH+YoCFkpQG9Picp2sn/S3BbXYTmCMLWmbZmoWjWMCCWcUcPV4dNtamAXN/pNic7dBgi86Oe9eE/0sei07sr1c9Y0qZtDxeIezWfodFqPjWiF1BOaazC9eHTXxt1qfsCVWUgoQmRnQ8QZRolVMbElJwPJMEOeS0cnRZEXHqKCjrzQpXD55+g1qlyrW1gP/3ymxqqtfo2fVWDVQF3gVlWqQEg7CIihUQzALsz6WsY3sL93b/5ezK6vonFkrQ7kOhscKfydnHxdA4lGAadtBZQQzNvKAAkZsd5ANlmvHnqXkjXfooZImdXj+9H7yg6GmR2aldK2rG1ousdNsO6rP3SxGI4SbtXExsiJNfe69zgJKag6rWqqF6rEHfHOFZYsjtukTCw96X11qKJwe/qM7zHrjZ+syoeHX9zunL4Xst0XLI4mmKrKzPCEWLxJ+Z/XhWIJZS+j/3A4JUYy+8r+uwVgSoYMLZofTWG/0VlosvZM67BFWpFoeVv0XhXRvV6S+ri+tjw1hsDzSwNVUMPDuiGhXrJ9O8W3uxR2PemvyITSu2jbVjz3aSIp8w1wCCXea80mXEvCJfBDD9QXnrTv4ho0R3QZtUhdu8KvZsfHUNj
 MGEyyqwd
 6htjtrRh51L+lzLzxHlrhfevQQbzfq1Vv/ucg+IdaRj3uLPR2DPBb7+tFn+X1OPUn1TD/VUgjj6rcB7w0XwZ/ZgaTZTGaES7ZicbeAmEgogaL9OoeYzWYLzGxe/ftYc1t4lYok82nJFRNUi1lmXT1DNLrEcuExi8rwltPjhI8ipOsOGIYrTHo3Nqd3lOwjEamWVvgNu47TF2tUZnkcwwum8EbJwzxEt5gIZXKOItgyPDtjqSOy32TNeO+yyl5vtTRf3APpFKu2cSpcRXvKs3jnThtm3+1uldNiDAScbVvt+PNX3H6dadIdrCaUb4E5ovIH8oWO6SY0sCizedhX6xW494cMkDB/tzDe/jvpS0wAvBPBriHkEF3/saI1zaCqmai6RPcqclZwtkO6qWZomgpUBFwSjGX7hSLKOLXgOubjF4RX/IDGM0n00jeooqY/3upxf37HxzbpSGccrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> There's no need to use the ancient approach of returning an integer here,
> just return a boolean.
>
> Also update flush_needed to be a boolean, similarly.
>
> Also add a kdoc comment describing the function.
>
> No functional change intended.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/huge_mm.h |  4 ++--
>  mm/huge_memory.c        | 23 ++++++++++++++++-------
>  2 files changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index af726f0aa30d..1258fa37e85b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -27,8 +27,8 @@ static inline void huge_pud_set_accessed(struct vm_faul=
t *vmf, pud_t orig_pud)
>  vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
>  bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct=
 *vma,
>                            pmd_t *pmd, unsigned long addr, unsigned long =
next);
> -int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd=
_t *pmd,
> -                unsigned long addr);
> +bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pm=
d_t *pmd,
> +                 unsigned long addr);
>  int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud=
_t *pud,
>                  unsigned long addr);
>  bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4e8df3a35cab..3c9e2ebaacfa 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2325,11 +2325,20 @@ static inline void zap_deposited_table(struct mm_=
struct *mm, pmd_t *pmd)
>         mm_dec_nr_ptes(mm);
>  }
>
> -int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> +/**
> + * zap_huge_pmd - Zap a huge THP which is of PMD size.
> + * @tlb: The MMU gather TLB state associated with the operation.
> + * @vma: The VMA containing the range to zap.
> + * @pmd: A pointer to the leaf PMD entry.
> + * @addr: The virtual address for the range to zap.
> + *
> + * Returns: %true on success, %false otherwise.
> + */
> +bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                  pmd_t *pmd, unsigned long addr)
>  {
>         struct folio *folio =3D NULL;
> -       int flush_needed =3D 1;
> +       bool flush_needed =3D true;
>         spinlock_t *ptl;
>         pmd_t orig_pmd;
>
> @@ -2337,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_=
area_struct *vma,
>
>         ptl =3D __pmd_trans_huge_lock(pmd, vma);
>         if (!ptl)
> -               return 0;
> +               return false;
>         /*
>          * For architectures like ppc64 we look at deposited pgtable
>          * when calling pmdp_huge_get_and_clear. So do the
> @@ -2352,13 +2361,13 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct v=
m_area_struct *vma,
>                 if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
>                 spin_unlock(ptl);
> -               return 1;
> +               return true;
>         }
>         if (is_huge_zero_pmd(orig_pmd)) {
>                 if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
>                 spin_unlock(ptl);
> -               return 1;
> +               return true;
>         }
>
>         if (pmd_present(orig_pmd)) {
> @@ -2372,7 +2381,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_=
area_struct *vma,
>                 const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
>
>                 folio =3D softleaf_to_folio(entry);
> -               flush_needed =3D 0;
> +               flush_needed =3D false;
>
>                 if (!thp_migration_supported())
>                         WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
> @@ -2406,7 +2415,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_=
area_struct *vma,
>         if (flush_needed)
>                 tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
>
> -       return 1;
> +       return true;
>  }
>
>  #ifndef pmd_move_must_withdraw
> --
> 2.53.0
>

