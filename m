Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0A2CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E526B03F7; Tue,  2 Jun 2026 04:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20A86B03F8; Tue,  2 Jun 2026 04:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36CC6B03FF; Tue,  2 Jun 2026 04:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29506B03F7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:02:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AB2B4084C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:02:41 +0000 (UTC)
X-FDA: 84834230922.09.06B483B
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C21E10000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:02:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJDZPV+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of error27@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780387359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KUrgOE3nDpMwzxJeLvIATjFofJgM7BnQB5Th6q1X6ss=;
	b=Alh8E8APvC9RiJ+xoEU3l98qNU3UeZvxCTzEFPqLwXDfcyzBxQCXG/an3whrgGRW6IDDdO
	XCJVOZyo6jyZ+AawesQyDsLoRMauPlhtiA0DUzIdz0z4lWPM37QzwWc2gbkQ2i7sDP5kEa
	0WaMH0WXQaT/VxlsAPT4Tb3jcp7T65c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJDZPV+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of error27@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780387359;
	b=TCduvsFkOX6vT41sdSesfuMskqRLOlWKR3Yu0J8CKCQJ7fnBzWu2vS3kf6NBx07Of/k35M
	lszWv5IqX8nBt8ez+S/ybk+zf7MawmbExbkeZnf2mojRY0FeHNWj0S5tm69QunWHT4dgmU
	rUoTaZe+uwDmyHdREjkEWFZHp3Z/C5g=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bef8b97655eso45714466b.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780387358; x=1780992158; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KUrgOE3nDpMwzxJeLvIATjFofJgM7BnQB5Th6q1X6ss=;
        b=sJDZPV+iF7FAYc+AoZpxqa8+4PUlnYLj2Klzi+naxuVeueeoSX9KSUAqfORxQWWUdT
         DVAeCfL5JfQTGNjsUgbv5pSE/bHCzV7kwPXIoLjDVayuXZc/zbZmWHBnFsbAk2b5ZgS4
         sMgQ2/6nG3ix4BO4ZqhZ1g0Gp6FPGn8hJ+2+GbE7a2fP8Lw0Q89BtiI2X3XAXdJK1qWl
         iBuKtIQBhdDInSfqifVjRPSVL3FQ6MKyob/X8AZQTlPV8vKgABDLRIM0eA8SyJev+dKR
         2YX5A0l8QIB8NsBuybR4X5u8v63qzeVmMrpzYDlEO3b3Rw2PlAmBn5zttzCKBWlngGd2
         Lrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780387358; x=1780992158;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUrgOE3nDpMwzxJeLvIATjFofJgM7BnQB5Th6q1X6ss=;
        b=o2okXDkZ4uMQrVQJy4z/DUSpk7oxk/SRMGGLxXSnnlRR+o98PIIyZBLxyd86b9+b+X
         HPs9OZ4CTcAxqtU6uR6U5f2eXhnachkV16Jo6ZPrp2XI3J5itdDP5s6A8+SgnUyH2zAI
         wcOLr+bgTGMkepG01WTmkswpzyVL1EZxL4rCXvs4F3Voiiov4TVOtKTPupQ+74VYsdy4
         IUKJU3Dn+D8HS5DPq05PzmvDWLWNS0EDFtOHvgJJObBl/MTf+RjVzf5ensQb5XReFiOD
         R6n30yp0n9GAeqDS4qMc0P5ilbSl5f5zCJq5fbzAxZQIB60UvaQroDfBMplDMOO2FoFl
         yHZw==
X-Gm-Message-State: AOJu0Yy7bm09azY5yzzcL42UcnjdAhlbUicxKRzRKV452+WBcDt3eVOJ
	3Ie1Jl7UKJi3jTTznCkvAUMsyt73RLFu7v5sI5S6aY8sccCjzP8uFEj4
X-Gm-Gg: Acq92OE6JqFXQKGup7vkk/n1ifeH/aEFpg+aja+q7+lxvbHHbsAdZm9VVD5fjC8P/0c
	eG9asqShToK0zX2ljtHn8AHSZUHEiBChEyx+AbSG5ZlFeBri/rBecTOylbe9su7g5JZuV1+Fg5Z
	eehiWLOwSdzgIOKeHb6laJs7lLh6RCcCFdcu9a3wwi0gTEeXWuLvM58J76GglXTynI5f2OWebH5
	7lrkb7e++3QLgRKP0XD5QoFDPboqXJxZCYP1q41UK9iS1Yndbuw3hAZBcrE0zJp/xmhPUVDkI4U
	36nYjlgS/Pk5T9ygT+3aRdI3KDN7dhMtqFRGIBVz8ZarLD3pYhO1/GzFGMeoDsae6ExkvPSVcrg
	qWFff/600UYwZCPpi61KnSbjQm5mfQHkSfRRTQ9LLgqxUN7ItdOGmqw2R7bgyBAtkn4Eu+2Wus2
	tRzh4AkI11JL9DFKASRgbf6TaksPJ00A==
X-Received: by 2002:a17:907:7241:b0:bed:f8a3:23a0 with SMTP id a640c23a62f3a-beefd0b8309mr146883266b.25.1780387357655;
        Tue, 02 Jun 2026 01:02:37 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-befa96052d6sm31744666b.33.2026.06.02.01.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:02:37 -0700 (PDT)
Date: Tue, 2 Jun 2026 11:02:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org
Subject: [bug report] mm, swap: add support for stable large allocation in
 swap cache directly
Message-ID: <ah6OGR1QjV_0_mO0@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C21E10000F
X-Stat-Signature: hxenuubm1ewsmazy8junzk6cho1uw4hy
X-HE-Tag: 1780387359-51146
X-HE-Meta: U2FsdGVkX1+fFAJcvvb4qeyd/KU48QhfantYeHIsM1ev99x6bKS4ueKG4M+t5X1QqGgKQWjqkS/nFba4xyLf1TwJ2sTb9RxVMa7qwQJBNprNiZaJrbZBolq+KDbHC78n7HB9n6y2poq3SiVnWxrCCs5CujkcDKErF8D+ivxmWTocNGhnhvV7rX4N+bGb7DYTB37c6KHQxG35G4KPfbnE/xG8hMHL++Mgg0ysTeWHu6rwHzMLvBYtka8nGgXVUsQtY9PjtL1A8Be79h1dH0WJepoXXC29hNPCm59/tRN1lS4sUunQjIywo8dYHaE0fJqJGig6FwaEcBI32BnB17HpjgIOSJUlDXnOjO7Ut4QNPa+2VPzL0ecYuC1rsqYmSqs9fp10egLai+4XBc0yLejdbW22ICLR+pCswlu4oxHmvBxE7XoWrldI68aB3V8UNL90diR9d9YjYs1SafhNXdmqUm41OP/TJRejEk+ESuuamyQ080Fl5g4rn6t+rXpbxY4BYIlByXjvpeW41ts+GjJ+DawlEJYbfohVc+OdOIhkNWAPT+CjfSIqKcCXV3+L7HovSMHADogA3p3wSiK2tc3Mgy+KEJpBFtHFWI98bFpgVDqtmE/VTrvTAxiHkxFAsmm1s+GjS+E4LK2o3JPNeQUpe7joFjHDjjnEfKkeHH27ifNmt4pFGAwTbGXxKDdiFC+cf05UnyMME/3Z2WBPgIlW3KCXxgN6Cpt8DxA7ykDAVgiJT/k7kQ29/wkitBH21ycfV4T6gZfphhax7Tp2FDRv/YOMdiC9nEY99PbqeGvX/nLKXZhSfiNzfwGlmvWgKJX3TkX/sNm+MB150D/Lg3veQAf9mBEpjQCOjl3L9aEUR6buRPWFJMjeKaFuB3iDV4rm1mcw5ubgyN+MfhgEanRkoZu34hG0Ax+bcRI3U/e/MT5LXjew+sqHSALIE6zwcTkD+3StuOymQ2+7qoG+mY9
 XBz/eIRp
 VJhRzwfuatWVU3WViyNOtAQUPNpQEF2kNXqAd1OV/kNlq4Z4NQ/rA8QVlggi2u5P7+b9T8EDTmPIVZlM+jBqx/DJ+rdC16+cmfGZ/BLpGH+hSz3doIla4OA1/KxapYAJDLUsKJtEVfcA3+EFrfSeyrUg1BJBDBarafM3tKhGucVuudNVaVS0lYngV9+s37NlBPM0ypYsHC94pVHb9dbYUxjF8WM9Ez0IJ51ZV4X3ML4GTiDE87lNBBTlN4HfC64J58ob7H3DLmETLX7d8d+OJA+bnG0MEoqTH3tC4tCXWCWYbLi+6FzxzoeIsRsIrRpF9PzVP58AJ0OIvc5vgkWSyUrBivEICYF8nZXBQK3/81MFygajftyCh4NJkc3PAqiE3yXAPMQvVwQDdW8VH2xQtLfHjDYNaBGMjX3/fT7UjM8QK+/XGsDKDhTD45dHEK5W9aVjkpbkHndoUwB9MI/kXHcKO5x88jQir+GmV1uVGzQEevaYZi/dHplfblA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kairui Song,

Commit 128460ca95cf ("mm, swap: add support for stable large
allocation in swap cache directly") from May 17, 2026 (linux-next),
leads to the following Smatch static checker warning:

	mm/swap_state.c:434 __swap_cache_alloc()
	error: we previously assumed 'mpol' could be null (see line 433)

mm/swap_state.c
    403 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
    404                                         swp_entry_t targ_entry, gfp_t gfp,
    405                                         unsigned int order, struct vm_fault *vmf,
    406                                         struct mempolicy *mpol, pgoff_t ilx)
    407 {
    408         int err;
    409         swp_entry_t entry;
    410         struct folio *folio;
    411         void *shadow = NULL;
    412         unsigned short memcg_id;
    413         unsigned long address, nr_pages = 1UL << order;
    414         struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
    415 
    416         VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
    417         entry.val = round_down(targ_entry.val, nr_pages);
    418 
    419         /* Check if the slot and range are available, skip allocation if not */
    420         spin_lock(&ci->lock);
    421         err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
    422         spin_unlock(&ci->lock);
    423         if (unlikely(err))
    424                 return ERR_PTR(err);
    425 
    426         /*
    427          * Limit THP gfp. The limitation is a no-op for typical
    428          * GFP_HIGHUSER_MOVABLE but matters for shmem.
    429          */
    430         if (order)
    431                 gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
    432 
    433         if (mpol || !vmf) {
                            ^^^^
imagine mpol is mpol is NULL and so is vmf.

--> 434                 folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
                                                             ^^^^
We can't pass a NULL mpol to folio_alloc_mpol() or it will crash.  Unless
mpol can't be NULL when CONFIG_NUMA is disabled?  I think mpol can be NULL
from do_swap_page() so this looks pretty suspect.

    435         } else {
    436                 address = round_down(vmf->address, PAGE_SIZE << order);
    437                 folio = vma_alloc_folio(gfp, order, vmf->vma, address);
    438         }
    439         if (unlikely(!folio))

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

