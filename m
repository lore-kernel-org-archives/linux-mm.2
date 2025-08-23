Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5448CA0EED
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 15:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DD46B00AE; Sat, 23 Aug 2025 11:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7446B00AF; Sat, 23 Aug 2025 11:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E5F6B00B2; Sat, 23 Aug 2025 11:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70E426B00AE
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 11:07:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DB84118520
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 15:07:16 +0000 (UTC)
X-FDA: 83808350472.17.A847B1E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 593A8180010
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 15:07:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F60BITqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755961634; a=rsa-sha256;
	cv=none;
	b=wGgDcoYKAdR76WNHgJMf7dZdKpRE/J0f/IjdpYY1ds6E5fAT1dtTZJ+pa/oPpsiR8yGCyk
	DtvtP3PcrhsbMdZTHdPPCgXhQUa135FL8vsm/BfEg9r4+1UpJyrldg08nOg6SGsccaA6pY
	pahiXGOMv5gCk9LloOsrg/J9QzkVRmY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F60BITqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755961634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7pLQJXLP+/wh5RGo7QUOMgrfB1lGW/zUnYaj6G/Tnk=;
	b=J7dzbK4XN/EDySE8Np2iXlQSwC/TUvJC/70o4A6SVeIJNLkixkprSya0SBVSKGsZvlBTUe
	//Grf1KGa3tq5jszogOMEtjc/oFfWDZVx7UK4o/K8ilixfXAasVI+Te/Q28gbF/a7+iwUJ
	2Cnuohrbr135pBDD1j4DzcyjM9YXSGk=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3254e80ba08so981100a91.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755961633; x=1756566433; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I7pLQJXLP+/wh5RGo7QUOMgrfB1lGW/zUnYaj6G/Tnk=;
        b=F60BITqBU6++KCN81kOt5lHloT9oITzYGJ920jJaV0LOO6T48D9SPoxZYAhsBlZRBy
         go7WkDXMURCJDFavizKfM23WuTyDTtpZU7f1rdsJl9kkaXlnYFvW9Mj3reo8PRHz0rSq
         a8F6EPfDGkFiTzkB541hP0OEu9NI02kYrWiSEgzHeWl6dDi4qzjTf+1de/hwl0c92cBz
         1nx19jJXOXRKdmPGRPzr5vAMiRjs+t1HiUWztGMvLB8YUrztEkmh4/QG7ORYaU35eEm8
         Ky5LUQIPs4fbL/e884J3cJS+jlgVdMiEeg1djEZj+xLpKwDlS7U5bjj6mZNQMjt2O1L5
         im4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755961633; x=1756566433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I7pLQJXLP+/wh5RGo7QUOMgrfB1lGW/zUnYaj6G/Tnk=;
        b=RQOZGCR+I67lLwjw0f1b5bF8x93eFvVwpxlgzAtBG8TZ8WtLpHBrM/46iqk58uZUO1
         ke+LCW8iMM4JbEXxMn1MD0NP7aIlksXXfyeMfnsK6oq/YmYDAHhRrt4NBSXn17jwXzWW
         4Mtv5lBCj7QBTJjMMz4RQg9jd8JgquTMuTgCcsN81WQ+8c+7RpKF0y1B3BKJxY5fny4Y
         R9oWuDDMpdAyk+y4aj77FCVlmK+ShS9uHPYBucFi1k3aNRjeZDNU7DN45BE0gNmNvb6+
         wPESHN+Xc9whCC5nwiFr9ZoEMSqrFTiTVqFzRYfSBsu6kOJYPRL8o0zAp6coXtVLpTEh
         BsAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX40+nmQWErpr/GD47lQKzR7/pQLTWcsGkEu1RlCiwnN2oIqfWa85CfDvb03iZAw2BtRQo6j6dnYQ==@kvack.org
X-Gm-Message-State: AOJu0YxlsBsCgesFg9KZ97Q3rFLRSB3SwjeczKjS6O8PBaobu241R2vg
	GE12ekDQKsiqNNyw1EV/Y5zza4cPKETJ+LUY66m+vwtGCsttb7Png0DSaAv7G7SGX1idRTRS8Ga
	3AyalJ1Z3Hmd5rkBd9ycQaJFljWf/Odw=
X-Gm-Gg: ASbGncsiZeBZJR+FDOYEwOZTautVgSw5URDT7qpZ+RrLtbtTTiPbRnQ74IA5YwJTXjm
	1cLEszbUuIwc34F8ZGE3a2DvYKiNibpSxc6pOG3+cudBdUlOZkErWHx4Crtn4mm5Ll4x3SzDwDl
	S0R+g/HoCFbGyiiZK9dHhNIaDUCmfP0zI3OumHWTtFIkv/JnlC1wvTqwsajaC/jPeh1C54wLglS
	CvbZWKdAQ==
X-Google-Smtp-Source: AGHT+IEr9vKR7FtQhlrnd808SbbiUl6CKFWHZDUAlAzh/z9Y1MpYHYnvQ/j96L1se05nXwg7jYHjT7CC9iMKdtLAKvo=
X-Received: by 2002:a17:90b:2ccd:b0:312:e731:5a66 with SMTP id
 98e67ed59e1d1-32515ee159bmr8372285a91.3.1755961633212; Sat, 23 Aug 2025
 08:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250822055857.1142454-1-aha310510@gmail.com> <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org>
In-Reply-To: <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org>
From: Jeongjun Park <aha310510@gmail.com>
Date: Sun, 24 Aug 2025 00:07:02 +0900
X-Gm-Features: Ac12FXzg9ES-N0zhJUF3GMAtH8ORLxjO5-PYPz_EOpxp6i0X4nmTNebz-VH131k
Message-ID: <CAO9qdTGKPQ=L2fMJ=oNz-7OG-9p+4VQz3+8-g7TRXJsqBC-6OA@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	leitao@debian.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 593A8180010
X-Stat-Signature: 43c4usq5ifnpz77idqpao4scwe89bfi8
X-HE-Tag: 1755961634-707693
X-HE-Meta: U2FsdGVkX1/dL6GOlsmqZlFHlb+HqbKGZ4sBEaHMNHUG4U5iuxzv6wa4cYX+BOFk7cHU6VBBWkMMrdGpILMkFyZTzYY4B4RSNo86uGGWqu0jhrCSNocbkbtblA4cKZgEACXREY1cqEriBQ56kOUwcN2tdpv5mNM2Wk9ExEumj8vLJO1YlqAcIvlrQfrnN1ZyLk1bE+SrkcajoduPL+VD3h4laZYEcgvBrAzH3F7HEhRMoG6Kqrw9T5Zos0ZQfNcklrNOv6vfoxl1Z4cZY/hEHNrbx3Bw7aE0dnuDSBSnpsVHW+gGVJV6JnnnbrGAp7svqQfnRJkxnf/0cLRUGo4UhplMZFrfzp8d5uHDM+kcRwcdw0fHAEx6LYubcsza/43F5+wGh6Au4P1TT50Zf74fde9GfoW53On1Jf7g5VI5NJ/yOgXxBdW6/ISvoCaoNuXj26F8NXim6lyYmwNtoclV8QW6xT6waLTCYlRJlfTToFE9vvzNjrFvnDgEhgNBKDZjhMzdfkA+j7vN5OrXmQicgutWcCyGx8tXTT3nbKl31HTwmo73dRUK2vmLGjVq4Ia7ZzdyYrxiv47cLjVDJItzug5jThs18OWPd7BC7V8ftoaVMQq7p9LiMGNkwboVIVmJzVJl+lI0nBDmDCUywDCrYMll83kkm1VKzNwALAVqRKlKW3S6G9XlyIVAeIbx2mBAsFra9eRpFDHEbKHfBAAxOLccvu4w4ENImUYhgmGzfzAsDtBsle5VyL6SAKSPYO2aYFqkIg/Uxed2NCa4uXCvz+YKqwwvnf6d4cYW7ppJTPSlik/NUwpnCtA99Dn4HExs+TKiwz0P72hIPe8sl8LppgyVmrzep0+k2StI788sOSHfV4l/7XSU5eG/4++0Va8M5ro+8X5bKhAYXBplSemUEi87qvKajTIaGrQc0EBjvH9wRd/t+ln8hIAzAnByCAVnxZMFlKW/UkTesY/JGCI
 A6Ap/hZc
 iM76/LzHcLD1v276X87HenqQlS5vG/NgK7I9QH6ihJUzUKlWVu8TsSg0ux9eenFfWd41z4Wn7z4YVTu9cI8ed9iuaT8wwkFTdSLPc+ywG7bktS49uCY/n2BACcVz1EFz2SxG0wWv7Z7EPhTvZ/r2Xqc8qPOf1h66G2I3P8XJ5CmP+LQdAOMlW/7kYYpUieALipzqNZP9/u+bj7kzbn6LdHSfT58GnObYDGs5ubTAgKVJ2yxOTOPuLAZ+Yletow9rr3Ip6J6hBkyshJu3MEUmGnfxAo4htQopl8pqbwedrzG1o/mwWG78InhWJuYvf4C+gH/wULAUBMYpTZipUXb2WH8gIb2XFn1K5GCt73GEod1dFj3MbdzKP3y90Z1ZOtoCRO0InxoYs2OzyA7DyjnlZUlu/u6ltCJ0doifeOk0CWWNnebuVsy2e8SbW3IAYLZXtV4Z/mIJtZMSwVuRR/WkAlbkzNKmZa2C8YKcUJv/Sh+l5SwlGd8lJtHqvo92CHdwFCOs8fOfnGuNAX63Pv/VmVOmutHj+JtO/XmdS1AA31NxRIKP5+MYsATBda2k0Q3ilfUcYv6/uUGrHf50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 22 Aug 2025 14:58:57 +0900 Jeongjun Park <aha310510@gmail.com> wrote:
>
> > When restoring a reservation for an anonymous page, we need to check to
> > freeing a surplus. However, __unmap_hugepage_range() causes data race
> > because it reads h->surplus_huge_pages without the protection of
> > hugetlb_lock.
> >
> > Therefore, we need to add missing hugetlb_lock.
> >
> > ...
> >
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5951,6 +5951,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >                * If there we are freeing a surplus, do not set the restore
> >                * reservation bit.
> >                */
> > +             spin_lock_irq(&hugetlb_lock);
> > +
> >               if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> >                   folio_test_anon(folio)) {
> >                       folio_set_hugetlb_restore_reserve(folio);
> > @@ -5958,6 +5960,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >                       adjust_reservation = true;
> >               }
> >
> > +             spin_unlock_irq(&hugetlb_lock);
> >               spin_unlock(ptl);
> >
>
> Does hugetlb_lock nest inside page_table_lock?
>
> It's a bit sad to be taking a global lock just to defend against some
> alleged data race which probably never happens.  Doing it once per
> hugepage probably won't matter but still, is there something more
> proportionate that we can do here?

I think it would be better to move the page_table_lock unlock call after
the hugetlb_remove_rmap() call.

```
        pte = huge_ptep_get_and_clear(mm, address, ptep, sz);
        tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
        if (huge_pte_dirty(pte))
            folio_mark_dirty(folio);
        /* Leave a uffd-wp pte marker if needed */
        if (huge_pte_uffd_wp(pte) &&
            !(zap_flags & ZAP_FLAG_DROP_MARKER))
            set_huge_pte_at(mm, address, ptep,
                    make_pte_marker(PTE_MARKER_UFFD_WP),
                    sz);
        hugetlb_count_sub(pages_per_huge_page(h), mm);
        hugetlb_remove_rmap(folio);
```

In __unmap_hugepage_range(), after all of the above code has been
executed, the PTE/TLB/rmap are all properly cleaned up. Therefore,
there's no need to continue protecting
folio_set_hugetlb_restore_reserve(), which only sets bits of
folio->private, with a page_table_lock.

Regards,
Jeongjun Park

