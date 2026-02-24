Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FC9EFB800
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8A96B0099; Tue, 24 Feb 2026 00:37:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0D46B009B; Tue, 24 Feb 2026 00:37:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD766B009D; Tue, 24 Feb 2026 00:37:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8516B0099
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:37:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8360CB855C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:37:45 +0000 (UTC)
X-FDA: 84478243290.21.D918233
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C601C0003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:37:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GadiJVsg;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771911463;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNr8d1nrqZZDfnro4iFgBQlAdVfxjJDLWxz4pVReYn8=;
	b=T2Eq8PtBZuxeE2hEz61uSjlCpncvc/9G6HbTzx6ziPm3B65eePIawBcw8uIyNGq9JkWqai
	SfpNqqI5mHgL1O8m7L7T+7ZD7kQspQSVi0CLbz40o7P/q/rRiBo9rLR+PBSJD2T44hVeCb
	dnngggjlZm5fEGQxjEgb3riePR+R/e0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771911463; a=rsa-sha256;
	cv=none;
	b=4Mj2NHdifPRcmC0hAdyKn3HguZxp+hu1fP191P3q4aslqkydA9DfDu7IGv/rkoxS0xwAth
	Xnhf44L4VEq6/b+5SzEFHK/TCxSjV3iDKmxErkmaOrxHPFtXKtgVVEtWptzi0zYrnffPO4
	iWOL/B5Re7o84as6Ra+sCEeD05rZJP0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GadiJVsg;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b884ad1026cso792777066b.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771911462; x=1772516262; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNr8d1nrqZZDfnro4iFgBQlAdVfxjJDLWxz4pVReYn8=;
        b=GadiJVsgvisI5277IggdWeWWzBI2GnbmXb3mIClsrRyzuw1JAZK3r+jDM9pve5RLSn
         f5HT13TBxzaWS53suDK0giCyYSOCXRXWOhm0M8OeLfUfbUjerJE1YkWIaeab43sHcAha
         DrtNJDFOnyKGDglPq7s3CFpZZah8btVf4hcMCwd609JkP/2SUdcnULsy51gOK27FqOdw
         bpoBkzAYXdkGGkk3sa2DvtambypBAhaCksYj/M5fTC8fw//dF0sO59mK8CLC0VGsjnzl
         R8VpRzZ41vHdXwSXcgMhHo5DFgCu8Trx21Nq7n4dPPRydhlEA1IIywhfFLZrWlcIDFLH
         9qUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771911462; x=1772516262;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qNr8d1nrqZZDfnro4iFgBQlAdVfxjJDLWxz4pVReYn8=;
        b=sz/WqZnuMhLlxGGMBPt7QHZ7Qr4uQ8uf//6MsHQHuJdzhtU/f7z7mbjKt/4iOyTjA0
         jlJB9jQljYWWBI86LUXUmxNJjHEXid7wTk6S2y0yeuitrgQaTuk5mpHxNBWPC/lB8KVx
         RMrDbmBOQKwIRwfIEcEfZdILCBnSi+wtXnOv3xdbv8uWrjwn5FJtO+danG/+OudM0X4T
         ChrX/lXe+qVNvyUSIAbdcMleYgaFs///bsV41AItbT46GRkuowNhK6L/fsvIk5rvbMjo
         wcYykJxL7hGoWCCyD+L7QkemS9Hn+skq7DxOmAvWuvKxUB/vwXnxSbSF6kekRclUAJji
         aETA==
X-Forwarded-Encrypted: i=1; AJvYcCXuZhW+B5PdMeJY04omYhILRXa9U46Xt5haKM9NVLCVVpk3h6aHWuOcQPjs8ggauCFVgpy9q+dPJA==@kvack.org
X-Gm-Message-State: AOJu0Yxt/0JlLew/qRCKz4PaHIWhw7MGZ5LEXfUYkEtaS4J0yfKIQfOn
	tHx/5fe5kpaSEGJPv5bl9hdJOZamyZYxhQqcZDhAvhDd8pSIkzrcW2UXbRfUXQ==
X-Gm-Gg: AZuq6aLpKaJsvmIcgfOS6y+gq1FmqakqFVpwgN22Qne7UKZdBxQERFNhCFGP+aMKAVk
	z2yESko6s/PoyQwfVFl9VbrrMyOF7rLir5I7QF+B9ByaFtIiF8uhmrko0BnNjf0/FTvaYRD6cyG
	gQTZbWAJrVan4ldVOcACiqn1iNuzMzV3W97iHWIG6yv6w08H2UM0U+57JOpphDHQSzHI7RvkA8h
	YtRGAQzL792+rA07rd5pmQsU/rCI010MFE+gTp9Tx5FatC2aIxoEUx06DzSq6fAuKeuU3DMKUJQ
	/UDS/VTbgNzJhG4rspiut6yHVwa4cqV+W29VsLbJsUOssjg80zi6n1rPPQQdjDq3ivXb9rMliVa
	4lSfpfAJ4opQvYxO3pYnzqR+UbLjwQxe7p7C11GbK2RoWO+8wZrdtxHVoVxFqvMIMUOvBI6eNax
	VpZq84U9U0IDVsBUwO6Sigww==
X-Received: by 2002:a05:6402:274c:b0:65c:972:7073 with SMTP id 4fb4d7f45d1cf-65ea4f16218mr6808405a12.28.1771905169453;
        Mon, 23 Feb 2026 19:52:49 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eab9a077asm3269354a12.4.2026.02.23.19.52.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Feb 2026 19:52:48 -0800 (PST)
Date: Tue, 24 Feb 2026 03:52:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <20260224035247.r6mxsfcpiev4wnce@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221093918.1456187-3-vernon2gm@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 5C601C0003
X-Stat-Signature: d1n884mtbays35dnrsy4qebamo865zsf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771911463-118866
X-HE-Meta: U2FsdGVkX1/Y++ysXmLh2DlkeCFf4ganugU8LKdC6Uw3/TrDMqrvErOaal3vHaUOqhGhs+mItiknOyZbH54OgVjD8HRiTKbnAwFsEviEsf7jAHIfyTJVfPE+8oVWWbI9o/W6OYWGoZTbmPjTT3So28mTY4WFBI5aXfS4QOlniSpbptM6jurjEU6wjiwxYVU3kcs+tZpoF6t3BGvbRqSy4mCfNzjAo5IUxYCItyrEnoL6c6U7VTnLerYMF4ic+UD16z8xLqyS+wDJcqdUJ3GJFIJpyzZxlWm2Xmr/Odxyap9ix/H+ny9FmdnjfHlbyEZors0cBpfYD/JdfQKLNY3dVhfQkdavzp0f+bv1yioUwfoNmqVS/VU4TIXPH3Ye99F9CBil6QJjmbuHq7bkhKlMHkQZgcFiYB7FgGrsMgd0uCbB3BfeXW2GQqrtf2Jsko3Se+74eNU7wgbFjYlG1ctejvNZRmj5V7R/6VzyrbSMVa/HCq/GdY5WXd7DV/xLJ7AJydOeKA+BYOh3aDK5Lhc/YIIK7XEOPatKnfOUDKrqdplGRRFWvE0xUkDs6xu2h9kkSCzAlhumgfg/cOpcrJxSB9g/+VNHkKUd0Ice754d6DgKKidaOHWPgUbZXWKPvkSG0kp9oD1dsOOd1aIg82wpYJCkEkImzf8kWYn6GFfnlB48umVzQzIBTKs6ENrb6TQlDaZiYv81SHwodmv/crC5SDp2Rqsrxl8lZPyGdJTUE6FeCTHVZQ+MCYJMG8nwcRzS6MS5TuSAeukxvhXc8z0gFFRd0NWb4DB1ebdO7RZ0OEQcfrO5aiFLfKiXfe/4tqD6ksnI+Wn0ldCN/QBaVcU89BJpSMlsHe+nrzudCi7YudxaZzDQ0ePEfgjKHSQMSfXzg2b7clbdf87QebVJfoWkelppMHZLfzj8tcYnkiX4X8ooH9s6WNOkXkwfoPT41wiOYXmWUdLm4OQeLckwAdX
 OBhuO+cq
 V+6N5WbloCzVX0h0AbXQDKOukA4M1xmu4SpvjxZQoDcsYP/wOymXI1/m2qYKLE+aOp/uM5t3wL/kV6RDWeF1Urfc4d5p6AKnK5TZbJrT6uZQm2zEe1nepsQQE+qUNFuaSw9nb5uUgmIjnE07NyzAX9+34rnS+F8dJdEA4cKJsNjVIo/FjYkYqRSBlfi/aZQVnYhFxBTO6zkTH3Vzl2U2uhU5k/hI5py4nrUbX+f5Eb45dDm6a8savLDTZgoOvgECBiEQwxAyRIz5dymkSn67wXUlB2riqV3sypj4+tL2L0sgB8OQjd0grXL4USr+U2Wuj0pBJtrTACC4eR6ltZ6gEkbavVXa7MP+62gJ7D/pwAxoSwVTacU5QZFvRgGh0ELWGxZbrYzlaQXjIIStjysy5angjy5GmX6+LZa63i4+SaKWst06gaq65Yqlfca6Vwr7JdwobqmBkjDHz0MVWH+Tm6z6Y7Dx6Ls5hlLT3ZZg8EICeP8Nre/6SUK9pO487Pln8uu8CKzUKr/AziMclT2MqzkTR9Ho8jRZzahDQBRfmSSvnU3kEZLRuPs/ivQKB/p08kbVDZiG0ul0DQMw0ASOM0p2Rg84sLiJaotzqAJpHvg43ziwiq0BYdrLjumDaB7J6B+mrYUB/3sjUpXOs7TmEBB4BAzl+foMDLeGViT6iAuY/EG2D/+oKaBrONCwROtKFEzZcWowz7RLv7cintblrdgKm7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 05:39:16PM +0800, Vernon Yang wrote:
>From: Vernon Yang <yanglincheng@kylinos.cn>
>
>Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>even if only scanning a single PTE/PMD entry.
>
>- When only scanning a sigle PTE entry, let me provide a detailed
>  example:
>
>static int hpage_collapse_scan_pmd()
>{
>	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>	     _pte++, addr += PAGE_SIZE) {
>		pte_t pteval = ptep_get(_pte);
>		...
>		if (pte_uffd_wp(pteval)) { <-- first scan hit
>			result = SCAN_PTE_UFFD_WP;
>			goto out_unmap;
>		}
>	}
>}
>
>During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>directly. In practice, only one PTE is scanned before termination.
>Here, "progress += 1" reflects the actual number of PTEs scanned, but
>previously "progress += HPAGE_PMD_NR" always.
>
>- When the memory has been collapsed to PMD, let me provide a detailed
>  example:
>
>The following data is traced by bpftrace on a desktop system. After
>the system has been left idle for 10 minutes upon booting, a lot of
>SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>by khugepaged.
>
>>From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
>following statuses were observed, with frequency mentioned next to them:
>
>SCAN_SUCCEED          : 1
>SCAN_EXCEED_SHARED_PTE: 2
>SCAN_PMD_MAPPED       : 142
>SCAN_NO_PTE_TABLE     : 178
>total progress size   : 674 MB
>Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
>
>The khugepaged_scan list save all task that support collapse into hugepage,
>as long as the task is not destroyed, khugepaged will not remove it from
>the khugepaged_scan list. This exist a phenomenon where task has already
>collapsed all memory regions into hugepage, but khugepaged continues to
>scan it, which wastes CPU time and invalid, and due to
>khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>scanning a large number of invalid task, so scanning really valid task
>is later.
>
>After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>SCAN_NO_PTE_TABLE, just skip it, as follow:
>
>SCAN_EXCEED_SHARED_PTE: 2
>SCAN_PMD_MAPPED       : 147
>SCAN_NO_PTE_TABLE     : 173
>total progress size   : 45 MB
>Total time            : 20 seconds
>
>SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
>https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq
>
>Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>---
> mm/khugepaged.c | 42 ++++++++++++++++++++++++++++++++----------
> 1 file changed, 32 insertions(+), 10 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index e2f6b68a0011..61e25cf5424b 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -68,7 +68,10 @@ enum scan_result {
> static struct task_struct *khugepaged_thread __read_mostly;
> static DEFINE_MUTEX(khugepaged_mutex);
> 
>-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>+/*
>+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>+ * every 10 second.
>+ */
> static unsigned int khugepaged_pages_to_scan __read_mostly;
> static unsigned int khugepaged_pages_collapsed;
> static unsigned int khugepaged_full_scans;
>@@ -1231,7 +1234,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> }
> 
> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>+		struct vm_area_struct *vma, unsigned long start_addr,
>+		bool *mmap_locked, unsigned int *cur_progress,
> 		struct collapse_control *cc)
> {
> 	pmd_t *pmd;
>@@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> 
> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>-	if (result != SCAN_SUCCEED)
>+	if (result != SCAN_SUCCEED) {
>+		if (cur_progress)
>+			*cur_progress = 1;
> 		goto out;
>+	}

How about put cur_progress in struct collapse_control?

Then we don't need to check cur_progress every time before modification.

-- 
Wei Yang
Help you, Help me

