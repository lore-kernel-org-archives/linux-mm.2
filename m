Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F8EE748E6
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CAB6B0089; Tue, 23 Dec 2025 16:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6506B008A; Tue, 23 Dec 2025 16:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF6B6B008C; Tue, 23 Dec 2025 16:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0DB6B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:40:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA12B8B462
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:40:54 +0000 (UTC)
X-FDA: 84252056028.10.9CD9A73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 514611A000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:40:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQZLwkdd;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766526053; a=rsa-sha256;
	cv=none;
	b=y7avw0nGLm4MN6K/kXlT/3Ltlp8fboABuVbKY75Q8YZY02eEp3/AQeeNkjC2n9P4skn5Yc
	vme/8qOMLO1i8MGDNUQzqGKYL+rcBOullUbC3sw11Ck1oWtDiz2+JL4zXgxwczyNB9CdY4
	nUkLoKkKM90s3m4BCALG57ZfIEFiuSM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQZLwkdd;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766526053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwoAt6gWbQFsNQlXgeyIOO8phmGngb+/vSttqgtcvGQ=;
	b=1Dd1l1cJWvrHAzw93bBcmnaEyQjbvM+tBvk0j4wUCx03Xi4UWqjCsmBKysPe3JcHLvemty
	yxfQxgcoKrKyZI9Rirb9w5XkjQwB17+dBCgsaNJf3lxJS1slvaEqh1QFR9TB/YT97gtL+n
	8tqB+DJRysrgk1IUwCUvSaRU3a7AxlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C0336014A;
	Tue, 23 Dec 2025 21:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D290DC113D0;
	Tue, 23 Dec 2025 21:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766526052;
	bh=Dw8ngcXvfO/801VaaTPwfZV46DR1ilbRLvNzIebB3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQZLwkddwu0TOjpJpvCT0+kwHRe1R21Fr+XRRme80mPpGUGpf6rsiE3wvIfWbZ6TX
	 0rsdzKQezUzqVDnWgKOBvw7U3+SE6xtzwbbApJeG5zOHsx+DlLD9CaakccvKgBXJ0W
	 CMnSk9ClrJ2BXjzXkXNF7K7vIOzH48I72+GVSrmisNSsTgUVVPXWZgA29xWDmOiHYr
	 N1Z7W5LrcykEPz9XYsxfV3LHn8HPu41mdYzS2z80+7G8oSS+SRiqIliTPpXqxOl5Aq
	 TEeqAZVmbciioOkYUoms7NkENBK1kv6eu+4zpOgl8R5QU48034Lj965/z35jmejK9B
	 NiaFeAvfHdzaQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH RESEND v3 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Tue, 23 Dec 2025 22:40:34 +0100
Message-ID: <20251223214037.580860-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223214037.580860-1-david@kernel.org>
References: <20251223214037.580860-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 514611A000B
X-Rspamd-Server: rspam04
X-Stat-Signature: izzcb4fb6yz96uxx31or8yj9iwrffst1
X-HE-Tag: 1766526053-282522
X-HE-Meta: U2FsdGVkX19akfsVXO2Gp9SPV+b1KnZ6cqUuzmj6IQg4MZmjw/V+c4vTak8rxipirJ7D77d/HrZ/dKeTdP/0VBv5/8TM0YApwy+ZR+Ri6cEMU1d5Ck95vBuoPk/pBlpO/scyILM+a8BeWBUWEf+gTzfS1sHX3CaO3ltHDrkk9JcS28SNou0LRzarLXmq+wjMcqT/gfr65y8gbHY3bRgaDP+xMfzXFLn1blddubPRCDkMa5MZ357uoqoXLnXZOVQ6+JxP0eE6XoCTPWEk8gnxl3o6DFiWVRLgawipkTiI59/eLENzXOTvcVmo7ij9jOSsDAmJ1xTPeWjm2jZ4+5IbnnY7vB2FUCt64OfwckZNec+QvHQhQjfme44UbLJsM9x1wrs0bYEwDaQH527jPuhckTD5/wRs4Ztu5zYWBl4EkUl7eEXpggydEy0TL5bPHeH8ymHWaPINV5MD30xVZqCBlNWbyRUZMMIrmNs6wtOmzk87NKnP5ZEIhxDXAazB01zvvCMOlFk0FOgBRtRcfN2/2ML5Uk/QkxePrsr9i5a0+BGxxb9349j5Mo7c1UYJ/b1LFNm03hMaUM7dnXlvLP9vvmHj4g2GjV2KbsusnD+l7yiEfe4uc9UqzYvbN6J+KrkRuMvy8Io0I8LAdyOeH9p3gl3eC+ZoloUl7umVF2wN6yi7p75x0B85T+sW/oUE4C66yfh3Sm0xBTJ266JChe/ThSlZX62NKL1E9Jg9MR8SmkxsNJIXI41JJ0P5HXoS49s7IHdeD6dlw0ZLYsHJMpZq2RyiJ4biPkpSrN/EQ0H5hsivcEqYKWqnAGS05stss3ls4gB08cvHAylx+seEORrZe/tBVXQwm3XLC4wWmgWx1EUmmtsEmGFgeAW+do2MEhXCGHgc9EUPc5j6oxtCNbqJzXTEobYGywpH7wlgwAi5k5H+CtK4sAprnHZ8M6yPTQlI9KQXnBtqw2OH++KJ73U
 4ETiMTGy
 if6EY9rKXUz7rMKWKQA9i1WVu/zfGmZqtDlS8AjaK+HcbRjECLnG8Z1d01IZttqqiq2TwllmyFcDqIfgofLrDfjOYvt9QxJpwZY57k+0up44WkF53fg4xyrEP9eVrLGDCps6V3MsDawADkWVpcPVa5UiUlhL7vB98WnHm6zZEy4VrW/bDd5q7W8JwFI3urfr/nSVfbSjA3870vHrWeco8LLi4NVX7ahIb5cWel4nU7bnCulenGOHf8b8MhZmgwEKNLSw4zqm8Jm2sng88hTIj8rdSBK/1ddJpPHWuntlucV2Lr7m67pROrJhmZq/+axXF9iZYkJTweYjpOpdKD3mBPMG4fQGhRLeyPFPW5G55QcEUJttBArwD4caLZ4tjAd3C/ZQxO72YLtLWgUOaus6bYNr1cjL/3Gzb3fmDy+B6/ZbZo3X6mzZc2DCwfL7mAXjb9tNGqg0kdj9p7EbL2c7fvUm/OA+EmxR1nULO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We switched from (wrongly) using the page count to an independent
shared count. Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to
identify sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are
not exclusive. In smaps we would account them as "private" although they
are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4e..03c8725efa289 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1326,7 +1326,7 @@ static inline __init void hugetlb_cma_reserve(int order)
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.52.0


