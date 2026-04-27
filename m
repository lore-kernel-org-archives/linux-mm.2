Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B35FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDDA6B008A; Mon, 27 Apr 2026 04:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95466B008C; Mon, 27 Apr 2026 04:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2BB6B0092; Mon, 27 Apr 2026 04:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE286B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:00:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34FFF407AD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:00:35 +0000 (UTC)
X-FDA: 84703588830.13.E139CA6
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3299680008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:00:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k+BR8hWJ;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777276833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1agXD7b5W0N2QWieFR5z79SW86Ra7sItI1ww9VJ+fA=;
	b=188a3DYMjOjySCJW6tQRTSaglCrl+4YjDoBXBEUwOClIGzsRcLw3idLc9UQjlnE42ZbeWu
	hDKhwTRUazXV5cbCG068i9MkEgyiSQ3sNRcx5OhVZijscax+TJ8YDHQ0stSbpcj1rRCWvl
	lYtDJx1S8Z4dwFZyBBtzuZYRLJIuQIQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k+BR8hWJ;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777276833; a=rsa-sha256;
	cv=none;
	b=3pjrC+TFIO0pMp1Y7Is9qzecwdxWeCRb8GqtrXAzQi5Hnsbh7L53PuUkg47QguNixGCScX
	Ea/aYU6ZF7lgGJhO+FhlFIrYQLjn3shKF/KrA8uxnbLr2ym7arAaBPUOUZAJpFJFvRrq8q
	Wl+yge4vL4V3QfYvJnl3nj/lr2aBC7w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777276829; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=E1agXD7b5W0N2QWieFR5z79SW86Ra7sItI1ww9VJ+fA=;
	b=k+BR8hWJGHL2xIBr78q74aBhmZYgFHu7s8tIZELFTNPXpZzhxioyUCYpwi1uwnu5oFtb4v7fjzs+p4eQ8ylHgWhmfN4Ky99PSGQrjjD7VNdYybXJgFww5lw+jIp9KrdCL8Ybp1jupNESBfy/+VneDjYcQDmSZVebcx5RwlYnzII=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X1l4eLU_1777276826;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1l4eLU_1777276826 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Apr 2026 16:00:27 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
In-Reply-To: <20260427063729.17294-1-nueralspacetech@gmail.com> (Sunny Patel's
	message of "Mon, 27 Apr 2026 12:07:22 +0530")
References: <20260427063729.17294-1-nueralspacetech@gmail.com>
Date: Mon, 27 Apr 2026 16:00:25 +0800
Message-ID: <87bjf4x27a.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3299680008
X-Stat-Signature: kiob5j345te9ysta3neuj76injkthw44
X-HE-Tag: 1777276831-439064
X-HE-Meta: U2FsdGVkX19kEiSVDuYlj/VOnRKa7ya7P9wXzcoWXCu5+LVgSj03GGBQGcJ1uOAmJK8a737n6+epq3JGQoBqnXAKpwcqO2bd8/GlKreVgsArDQy+tlRvyjZbGGitwERZ+PoiE143QBBR1Nr1qlsnQfMYppati8/w05xz1NVucOQ1+Zm2L8j1eX2p9XS4NEX/P7uA1Y6KjAh1fiGnxDgv106qb1h48rmCLSQPyrtmPETKr26YlUEs/VZf7+3fyHcJwDxg1TVrF6w9CZodreEgjCHPyAy+UmXiOGUzrr+L9PwhfXoL0aIfoJSqzAmnNhHo9Xmx9jPJTNoMeSQU5jrNgh/6T3tjuW5W8lKHRpFTX6oWD18CQE73TN3FCLhva+AADrlRPLf56/oxUXuRS+XYYuyGJX3+q9JcWWdST5wJ/W3gVRPhGcj/qzd0l2Lb5W8ZSzZES4ToRKzL2NdoVSwKprayqLPFqIHzLl6F3Qwj1Dg4DkozhYzbPSKJmNGoJvWX5ZaaFW7LD8BD8C5k3W4ACTI9onY9JLNtL0Jk/wODKmuZ1n4e/kT7bGcM9QsLnXiCZnakD0gspPddy2U1K7ZjMBF31zlz/CYPc+c8P7S0yJE4aMecWNoycRjjMrBeTMJ/xKVZaZ1DsDD8zg6u5yflI209mQ5QLoOacfed1hWhsSYEcUAcloI+7s3qMvFChhMORIePxrOMY72UfYaifOpxPTTofX9UZdlfKvMqmorVeWXwXwUoGNxH7/x9rczXo+RXPXAm5VcnkiNVjEw3TZbZu1VYfc6cSTS9VN4r/sYAOFZYTpUaN1yPpA45RyMkediDwgUORj1yGO2+OnTiBB8jAUr/wV4PkpNgYENt9mcXu8qFaDGqMUa1NVNGNs/9vg7ciRQBFoLVmuCKED/+ZWbByIgYIvL5yYSYwTUt/PSe5GvJxRwfkgQTuWc7QE2fiIIkJrh5PS1etPbNeKlyVYH
 eIYjIzva
 D7XiQvl819fEUunyCIPYCzITkKMUkTujZ24BlbmKYfGgOJoVpcf3WdfgKeH/vLE/8bgVJrKN+X7AW7YxIuDA6NscNcx9LZ6NiUNWh+V7BbRkF2UWLdGW1UnCqg4tWnuidGVK/dBR8uskLikZmjcY189JG6pJuWn2sXsw/mUMYugpXb8jJnAxxml1ZVpf1zZDRc5g6LPLA5wELFNo093cuBuDhnImhdNPuBRxT0Aka5DJV0/lqcprtJZdodvRIcY/io46e8I95uBXmVCHk2dHyN4FSt+fYfzLxlMXpHK+218qczIWaVm4rjadqSaeuHk+2xhTnwc4VdtFW41QoJWv8mrp/v4XLZMdBRj/FXVxvKKA+hb4Y6jNCs5Xz6+Xr3xYK0K51K/bTGqkATd3ycH24AjHGO9jGi+n6QWxB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sunny Patel <nueralspacetech@gmail.com> writes:

> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
>
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.Also included before goto abort in the
> folio check path.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>
> Changes in v2:
>   - Added pte_free() before goto abort in the folio_is_zone_device()
>     check path. The lock is not taken at this point so goto unlock_abort would be incorrect here.
>   - v1 only fixed the unlock_abort path, this version fixes both
>     leak locations.
>
>  mm/migrate_device.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index fbfe5715f635..7e132196856b 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -840,6 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	} else {
>  		if (folio_is_zone_device(folio) &&
>  		    !folio_is_device_coherent(folio)) {
> +			pte_free(vma->vm_mm, pgtable);
>  			goto abort;

goto free_abort?

>  		}
>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
> @@ -893,6 +894,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>  unlock_abort:
>  	spin_unlock(ptl);

free_abort:

> +	pte_free(vma->vm_mm, pgtable);
>  abort:
>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>  		src[i] &= ~MIGRATE_PFN_MIGRATE;

Although I prefer guard based memory freeing, if we stick with the
original error handling, I suggest following existing style more
closely.

---
Best Regards,
Huang, Ying

