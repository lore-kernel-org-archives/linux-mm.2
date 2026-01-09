Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A3BD232C8
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADE16B0088; Fri,  9 Jan 2026 01:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B826B0089; Fri,  9 Jan 2026 01:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8671A6B008A; Fri,  9 Jan 2026 01:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 761846B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:37:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 199231B590
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:37:39 +0000 (UTC)
X-FDA: 84311469438.27.7EF027D
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47189C0010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:37:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eTaQH24g;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767940657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5g+AYkU4WS8Q3yfVSitZSnUSiX3Qp5+cKaw82EFjEr0=;
	b=3uBhWSYLs0eOIJBLr5U4iIvwJbNugBsPP1vQ2zl+rYh78V2sb3dr52buwTG4iACT1GHjcu
	L3MVWltHKTvFrMP+vTaZdBAr1tVr7X6ycZgSUz1cM+2vJImKvTlEqMwPym+UuTTpk7aoky
	wd3j0ulSPefWmOc1S9IvaRYvgjfk3xA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eTaQH24g;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767940657; a=rsa-sha256;
	cv=none;
	b=6BRbIhc9Gt/jyQNLL2OqvqNy+2B1szV7IFXHSu6fST/EU2FO34MKRYUsMnPKoPixcp9D7s
	/O0lodLtal37fCyQDI+nKoZ66J+hyxLSptnpZUvROkxTXAW78/8krEaSft4TDChAKdy9Kh
	vSUEO+jiMeL9g6ZgnA/LgbBNLzQYxuE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767940653; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=5g+AYkU4WS8Q3yfVSitZSnUSiX3Qp5+cKaw82EFjEr0=;
	b=eTaQH24gjKjDENPWsyDdhSWXgcFEPL5n9Kdxn+qBdsHD9jGEcd+x7RB+s3TVkRriSpk5LgvI2rOZx4WFajxHXL1V58YqrWwAXMcRG2fPctPgU7hre3VtS8qyyd6UFHsgZslgi6j7X1hY2merHvk9L9qNBg+/s9OqEAjP8budeOI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WwfI-4q_1767940650 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Jan 2026 14:37:31 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,  Zi
 Yan <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Joshua
 Hahn <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul
 Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair
 Popple <apopple@nvidia.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,
  syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
In-Reply-To: <20260109034723.1342798-1-wangjinchao600@gmail.com> (Jinchao
	Wang's message of "Fri, 9 Jan 2026 11:47:16 +0800")
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
Date: Fri, 09 Jan 2026 14:37:28 +0800
Message-ID: <87secfqok7.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: 11umtzsnmfcrkga6fxm85zfw4x6s9k6f
X-Rspam-User: 
X-Rspamd-Queue-Id: 47189C0010
X-Rspamd-Server: rspam08
X-HE-Tag: 1767940655-809308
X-HE-Meta: U2FsdGVkX1+LYwFkbOkV6YqBS/BduDGiW3v7FpDSgHazlsNvm0iGiL0AjTaI1rviSKvR4EuwJ+1aV+J9YQkX8KgnveTcLbtbTyxIpkuLxxJpIOwLvXLtCz+lP47YToqD57zLlwOb1q93b9bpuTP3zcbJCHaidFjC2E/jEw2y6sbcW/5ok1hEKyBpARW6ZmBoCcnyHbULUaIoL75mzHff8qaD+q4Tpzti3UoY2tmuP+5YUAqS7YbvmX7cHmjJiGFPkRa+H+yFNoFvP3dNj29av29wxI59r8QXnkI0sVwduzNnjChlVRXZVFvtq5SjdCmQ616CYxy1mluTtnkbkjaJB8Gc7sCdK/2O9D29PbpaMcEYBMt5mhUVgShKWMTlrdjWy0PtrkGTxhIJJaaaPLBNkF2yF4bakifai7B83gcVehLDuOa6963YetiEIoYLKoBQO6ap6m3W0nvM8O0GmKakEMewNhS4FMGYVU+sJ/G8rqGgCF/9xcbf/mwXmGwCy0m/t5/mmHleq7JWBLRNfx4Rrl7ChH6ALvKX/kG3QjcxZeTc/HbO06sXQATrovZGlD4esEfU9/2NnatLgUSzH6LgWlZYeoFFYYhsHftBULS2Lw9fzR0gj8IJsi52UkJ2NLeOcp0D+tmVH01pYALW7Xaf+B0q1iWmLiTMc8DjFeqnKKi/hHV0Iu/cN2HqBzgBqxxVkTvU85YCTrLD30Piyp9dGI9DQ/AYlan1p5nWuNY7sKCI+a9NtWaR4Zx1clvYBzSgyQs4d19GgmXypyHsiANs+aZX9YEarPV0EZ1YDPYKvyKAmrN5vsbTEc4LS0ZRCsbS4R+VyfU5xGKt2aJmoD9oG+cjIUqPuH2Zh2OHU3i/HwpCBAj8GbX6iSYeqH3Mphq3FHBdd56jbh+AJ4rKNv0vxcChV2DZ7ZrBdJ25xl5nwQVKC/YWqyHj73A91mxq791BINSsFMkWmY2nnYSlhZv
 VZzvNY15
 vPhytqShj0EyIaaM5zs38fdaafv4wldSWiojxKmIenzjdJXYSzm5GC/MzdBjH5lnjtgTBVA8G08I2Zc9rMWvti9IPlokCC2yb+RoRfWjp1CKXXl/5LJZFkwB79J1AASpRbQF5XV95EDliJKl8JRR1tpCKO1IZ+EpECv2kvHFd2XLA4lAMdKVUSzB742DnBv8Ma8FshQbb7bnCwZpH2SCvJPxxqxRvOmNu9Rc2gQ4T2soiT2Rs+hXDJRsWwgXA+ThhiY8AxQivsip8+JFJ28o0T1FVGf3QD1+Hsnr88vQDam53rNQbxVSQg+91l7rtc5hZ6pNGqaWrgJYigR7jnwBWVfld1CbolSD0e26Ioc/rq6yZDwaC5nMCsc8SPTEw/OQt9ro0BakroCQIU33+BuVKNdbkuyqZ2rNQQB4turz05j1FeCH32ruQyilwztZ47JX1zBxEBZh7wuKgvd/kk32pA7e+7T/qe+V8zz8nNa6uzMTj81/VrTtOASoOBEDKfL3hyJja1UDLX/0bhjMYv6M34ORjJfSvDVR31osbpeapzgh4x9HBJy7FZ0DbXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jinchao Wang <wangjinchao600@gmail.com> writes:

> Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
>
> The deadlock occurs because migration violates the lock ordering defined
> in mm/rmap.c for hugetlbfs:
>
>   * hugetlbfs PageHuge() take locks in this order:
>   * hugetlb_fault_mutex
>   * vma_lock
>   * mapping->i_mmap_rwsem
>   * folio_lock
>
> The following trace illustrates the inversion:
>
> Task A (punch_hole):             Task B (migration):
> --------------------             -------------------
> 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
>    (blocks waiting for B)           (blocks waiting for A)
>
> Task A is blocked in the punch-hole path:
>   hugetlbfs_fallocate
>     hugetlbfs_punch_hole
>       hugetlbfs_zero_partial_page
>         folio_lock
>
> Task B is blocked in the migration path:
>   migrate_pages
>     unmap_and_move_huge_page
>       remove_migration_ptes
>         __rmap_walk_file
>           i_mmap_lock_read
>
> To fix this, adjust unmap_and_move_huge_page() to respect the established
> hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
> until remove_migration_ptes() completes.
>
> This utilizes the existing retry logic, which unlocks the folio and
> returns -EAGAIN if hugetlb_folio_mapping_lock_write() fails.
>
> Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com/
> Link: https://lore.kernel.org/all/20260108123957.1123502-2-wangjinchao600@gmail.com
> Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>

Can you provide a "Fixes:" tag?  That is helpful for backporting the bug
fix.

---
Best Regards,
Huang, Ying

