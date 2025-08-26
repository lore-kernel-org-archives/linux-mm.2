Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51366CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 05:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DACD8E009F; Tue, 26 Aug 2025 01:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C1E8E0090; Tue, 26 Aug 2025 01:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A12B8E009F; Tue, 26 Aug 2025 01:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66E378E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:38:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC13EC0631
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:38:56 +0000 (UTC)
X-FDA: 83817804672.30.B6412A5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 205BF180009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:38:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lTLEZ1Ho;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aha310510@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756186735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axk4UMbWJGlYVE8LjjJYFMnLZB/ZM8rZIyTcTh59eoY=;
	b=ANX8tfErLudpZ2vIguGaOxcIF8m2TTDaIbbN35UlLUpilaAtrh9tMOgjRUvyjMjFHKbTrT
	ZAQXPzswCFpefQU+kTc6PwOk9ptFaslQiLdqDFZiFlX8H44rAHBJrCJxfIp44d6jVZaBT3
	+3kBbi5cTIWdN+J5qDXENu7tJpE3IRc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lTLEZ1Ho;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aha310510@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756186735; a=rsa-sha256;
	cv=none;
	b=cPm9zIaSAUoXwV4afmMFLuogVBClK/GF8oUwZM1HIw1rlLGHdYw7+rkImKqo9+BXSPmeNZ
	VN4qKfDRzqW3Uv8Mh8d8iDJWFz4jmZZxdBgmTuBTEcNomWHsb6z8IokiFS4SZLKTWbEK9Y
	sRJnxSiGzEDVxUi4TcT7MP2IN3FX0w0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24646202152so38065905ad.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756186734; x=1756791534; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Axk4UMbWJGlYVE8LjjJYFMnLZB/ZM8rZIyTcTh59eoY=;
        b=lTLEZ1Hob6CFiB5S02xIjh+mN1TcVvdVYWJXQrSMlUyWYswt+C/PtOxNKc4+SaQbEP
         WfUkvvY5uLba/+Tr9c04RPmVvkDv8Lm/J78FOCpzjBZ0T8wTBdABYAf7CZFz1eqBDymH
         Z8DimWWxaq7TRj2TkS7mcUttqiXlNt96O/AQeMIK1YOfVNG17B4Sc//4M6d5GBs64f/t
         0bQGHoeyXYmwqzQ3WCTaHpRqJVpQAwpUG4o4Y1ClSXb4AyHzF1m0oGx6RuVRWUzGnEgx
         CZPke8YUs4IwuB5MGsrrF+PlTjkHKNFLqQKhOMq6RRWIh9CCBDwfmxNOhKnoafOb4RhU
         DNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756186734; x=1756791534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Axk4UMbWJGlYVE8LjjJYFMnLZB/ZM8rZIyTcTh59eoY=;
        b=TiiVADudCJ8xcX8nH0eFYlfe0J/Hbub0li4FZ59Ni0TUHsu+GkprlFAgPYCth9popM
         gJwDGARijgFlaJWjB1RHZttDK6+qAg6laYqzJ2+5/+hYpl6FcPB9dKDumnNdHDOKZ68q
         6MmKKYdma4oc8THVorXr2baWIRSnm3Y/x2CgyrMzIVBA98yWyDTdo2qkkbkDWBBMSjNw
         UlAmr930OV3Oi3JhTc+fBCxJxgN4fIhuzHIRqvvhhHQUWnPjkmdIlKxDjmzYKEudNqkK
         jXqMNsxTxvyuahDcn/yXzBkKRnHsVUWPz43TMrsKwqQhEXKv2MAE/GHMGvfBizJBh4Fl
         DTuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ0V2ImC2ZgvHAjX8Lg6uGkjMHb68eQdVogd+17igjX4ECcrvdLkwGlnuCIVTrWXoTcRbOD8wBvQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4wTpQSUlqMyvQPBc15NHOsfKsQI/KIZy2BWr6P0aME9L31iII
	9Mc/uCxQ6gKxW+9Gt94HYvrVt8VU+OtUbhxPyOTTH0bYvze0q2PXqTYgRGurqQLxIqO5y9+Wf0/
	/SnwpYsS0cXw5arrA6zOCUJvG8Z3IUIU=
X-Gm-Gg: ASbGnctG13pVZQsykU9Fgk3Ju5OYgFGNWhtsmu3ywLRCO19FW2lKmQZTKN8jPgsn/Io
	YXTJ9VkIa7IyyoW+CmwZisgRE3895Y5+DrTH07VDRtE30b/xpJCQj/kg4AvhxKcmKxWZRwVf0jn
	Lm6DQy4/YZBRUkXZpRtY/NtA5Sdf0Xt4q8xwVWzIL2hUIDQ9C9MGYINUYB3UxoNi9ACnnjIvexC
	/AMdSo5tg==
X-Google-Smtp-Source: AGHT+IF4WuKBgonA7wU0ychyL9+0BwzHp/2OyDxJKY+LcRtfGkh/0Hes5UCWFkbHCHBvEeIsWBm5YuUo9FxCtDtnwqo=
X-Received: by 2002:a17:902:d54a:b0:246:eac1:50cf with SMTP id
 d9443c01a7336-246eac1548cmr69886865ad.12.1756186733913; Mon, 25 Aug 2025
 22:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250823182115.1193563-1-aha310510@gmail.com>
In-Reply-To: <20250823182115.1193563-1-aha310510@gmail.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Tue, 26 Aug 2025 14:38:46 +0900
X-Gm-Features: Ac12FXzfcd38LF-GMC-8K74D550K73mNo7BnkYALEHmVGNLD52tzBppBnZCL1DI
Message-ID: <CAO9qdTF1OZRX0mbcG9hQy8m32RvrZaEBa0EWpDREBjfBSqrrYg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
To: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	akpm@linux-foundation.org
Cc: leitao@debian.org, sidhartha.kumar@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 205BF180009
X-Stat-Signature: ejbyw8n6soiud1wrfqtuhxbknxit93k1
X-Rspam-User: 
X-HE-Tag: 1756186734-19119
X-HE-Meta: U2FsdGVkX1+6GxFwP2wbZ/D3HUtyxUA1KISW60AEnCWLbalj8zes/tpX0FM4zn8h6+BsVj7wAqzp7CT2BDDPtEoeGvO3rv6n5llw+a1OjJPOyQHnhTiZdxu/QAHWTnJVPichQFSL5t0rpmysanpDl3jObd8c//AIztsB5pNl78BZ6os0Q1NubiGYf18+IApr/9VqXCj98jByviAaUT2Q0M1Qi8OUmMr9QBeRwkgevucvUrgy4sa4kqK9ig9AUMqHvryaOnHR6p2wAQwDcJFtCsIb/hyBUg25DcvUk/O7tNZnqPfDDDGPuSUWiScyLpxBm/N9bNMuz744sxAQL3tl3BzU2m70c9H/wtB8F3SXf3tRdU6veWYDEVBRi/sgXN/7pH9EMx+yJ/nxtBK1e1WWjsWiyB5uKcXMdL0Rc1iqASmZbX5wUHgAF+Z/UYPenunvgZp0MiASYZLoensbbg/pbZS8dTt2gZWF3x0ws7UIV1txhQ8PgkN5IeRhoSNCrHGb54zvHcrgbZ4aKyL+UEDnPHGZXgY9MqPJjsCxM7l6I6OAMQgRcVG7y2VJNrGs8/1O7k+h1WevE7kJ0pAN7OvCGRj5LBoA6ans/KgsGNrqQtSMddAaT+qzpBfnet5jndh8LiVrsDojelSk9fmCS2FfvejOXuFLlX9fwx4QJ7HurwcqKrEK5CgUAHRCbvx6wsTSujFMGPgYtom+P9B3nHuiMt7pdz1J9/WFdZaYp5xDPDJ8QB3RsMTjuvev6L7P4N6DJbdqWVbaJCJ6D+GU7JMibjVLsMr0QFgk0nJTa4rpPwl5QhokttYwGZZAef1sxCV1h4e0KOWr0W9BU32vwx7C4cbGVm4R9Npe4lXGOmzsA13PwJOewCn3/gPKRcRQNQvI+pGjrKqmr+S9uNtfmgw99AJNH5pGx27KXQehNPUXfmlpG3b/HX3oj5AQCFn0XlGs7kOOq0ga3fqzwWH2XvD
 sQWWmkoc
 0vnqD35rXb/4oz11/8c26gYynUWt3GeP9+zM3GNlt5GUiFzimx0pkNrt3GjBGeY68WZsY6+vA9PQTNAWFySREo1q50i4aOCRixoED9OxZvCLoMY+GLtJZqAMRhBV2wcBafBtFLO6zgVEE3VIB4E5yP691PEx3HMOxtur4bwJTt5Zokj/gXjiZZSypPHcFDQeb74+J0mzbM5sNpPJqoygxp3KGzX+i3UBemj9x02gzjv9uw0brRS9GbQtAlUMoZ5OQ7x1L/PgmTgRAc5xW3Y4LB3566Tm2eUGtxUznbd58kvn2Hc9FSaDWL0O2Ck/FNbSKeeNH/KF7c1v+0V9QhSHxpfhVesFNCb80AK6cgNJMjs/3Jzspqdb1mNyXAssgx3+XfdWH/TSNY7BPWJDZx6dC3hdwKnXs78PFamh+ufGDIvlMv0Vc+gOFil1Sh6h2pA2l/kIk8PfZfPCRmNQ68opg6ZR5gdcmUwe++U2lw+ciKvvEsYpz6q8NzmqTvohBWd/we4uPA7cCYyYnIpO5YYOA1sMoFsWcCaMm+sHpn3XlY2Jw//rniBYJo1hOD3P2iuTkEjaheagp5BOZMgTaVx8Xt7llItzTfb4Fz2jEvltsfTdSuAQG7lzAvB1ySK6B5HdFCp3TOMJb0ueJi6wLfKjlBbUxo42gmox64pfYkdXwqAsZsRhFwxpMPVTGpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeongjun Park <aha310510@gmail.com> wrote:
>
> When restoring a reservation for an anonymous page, we need to check to
> freeing a surplus. However, __unmap_hugepage_range() causes data race
> because it reads h->surplus_huge_pages without the protection of
> hugetlb_lock.
>
> And adjust_reservation is a boolean variable that indicates whether
> reservations for anonymous pages in each folio should be restored.
> Therefore, it should be initialized to false for each round of the loop.
> However, this variable is not initialized to false except when defining
> the current adjust_reservation variable.
>
> This means that once adjust_reservation is set to true even once within
> the loop, reservations for anonymous pages will be restored
> unconditionally in all subsequent rounds, regardless of the folio's state.
>
> To fix this, we need to add the missing hugetlb_lock, unlock the
> page_table_lock earlier so that we don't lock the hugetlb_lock inside the
> page_table_lock lock, and initialize adjust_reservation to false on each
> round within the loop.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=417aeb05fd190f3a6da9
> Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

Sorry, I forgot to add the reviewed-by tag.

> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
> v2: Fix issues with changing the page_table_lock unlock location and initializing adjust_reservation
> - Link to v1: https://lore.kernel.org/all/20250822055857.1142454-1-aha310510@gmail.com/
> ---
>  mm/hugetlb.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..eed59cfb5d21 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5851,7 +5851,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>         spinlock_t *ptl;
>         struct hstate *h = hstate_vma(vma);
>         unsigned long sz = huge_page_size(h);
> -       bool adjust_reservation = false;
> +       bool adjust_reservation;
>         unsigned long last_addr_mask;
>         bool force_flush = false;
>
> @@ -5944,6 +5944,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                                         sz);
>                 hugetlb_count_sub(pages_per_huge_page(h), mm);
>                 hugetlb_remove_rmap(folio);
> +               spin_unlock(ptl);
>
>                 /*
>                  * Restore the reservation for anonymous page, otherwise the
> @@ -5951,14 +5952,16 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                  * If there we are freeing a surplus, do not set the restore
>                  * reservation bit.
>                  */
> +               adjust_reservation = false;
> +
> +               spin_lock_irq(&hugetlb_lock);
>                 if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
>                     folio_test_anon(folio)) {
>                         folio_set_hugetlb_restore_reserve(folio);
>                         /* Reservation to be adjusted after the spin lock */
>                         adjust_reservation = true;
>                 }
> -
> -               spin_unlock(ptl);
> +               spin_unlock_irq(&hugetlb_lock);
>
>                 /*
>                  * Adjust the reservation for the region that will have the
> --

