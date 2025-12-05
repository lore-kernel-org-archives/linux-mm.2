Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41231D374A8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964256B00E7; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914FA6B02EE; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B876B02F5; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54A5B6B02EE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 206B81A0280
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:15 +0000 (UTC)
X-FDA: 84186725910.09.42CB085
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6197010000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQScRciw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970573; a=rsa-sha256;
	cv=none;
	b=ELTLbd3NyOQ5355I6qT8rOeoj5pSIaWce/10DBHzWi+SCB+yrm69ZMTBLpk+PCaKgoy/6B
	6Swi843ny2RWTBkCC6R+pq2jhKYapO0MnVnYgDOZeIVzd6S0eql7lijgITtH4bjx29GUKE
	1EltF7Y3U+qGxhFYn0Dgh9OdKdZkZ7k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQScRciw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUEh2IP/z55sIDgHlZ2+F+aGI4FPtzh1lBk3A0If0sI=;
	b=IyIOr7gF9W7RuxjhXjDcfmh9ZwzjNReljXtM6Oi9slHr4TYjgZfCSogPdrsmYkLPlGkRGJ
	/IMg3hYrcuTN42xuTCNgCGN4p6FI2p5kIcxY/EEj3fyDER8DhF9Wcw86IRwspH41Qalf7h
	Q1UnQ8r9LokQIXtRLmHLA6AEmaiR4wY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87E174187D;
	Fri,  5 Dec 2025 21:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0B6C116B1;
	Fri,  5 Dec 2025 21:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970572;
	bh=8+3PE0lZoghyFccjBGOORkbaZfzCOnFQSwGHJ0dG7Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQScRciweFV75igopSCBmTYjX821Laicmf3q6LqdAmvGFsMgieDUeLyMJKTNyrRYe
	 14C+OFiYJOluVspijOX35hj+jk8gyjZ59Ucz+6I4aQOZatMBrZQKLb+dZyy37FM+S/
	 YQTpa+5Kzde0Anbrnzy++QjCyc3np0ZFFzQId6uUmAEctUdV3ytc4Wh9Wb4zdtwEjx
	 sYRJpo0fxMhOISmPIQ36l4iU5dNKgMl8rWuJEPCumdeuzFoCfChdaJf1O0usLZNWZ8
	 QbSSqVSFC7cYd0iLNCZBRVhF6exH3C7y65890AB0OCZX4t68AhGw904+jMXiEQBY36
	 FSZreQdP747uw==
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
	stable@vger.kernel.org,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Fri,  5 Dec 2025 22:35:55 +0100
Message-ID: <20251205213558.2980480-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251205213558.2980480-1-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6197010000E
X-Rspamd-Server: rspam10
X-Stat-Signature: 7kqw73he6prywna9a5grcqaj98psb9gs
X-HE-Tag: 1764970573-403008
X-HE-Meta: U2FsdGVkX1/AKvVI/rMM6IQdcQC4uxpOLB63yGfntYgvS/1lmfwqYsUUZX6rMweTsFNAFuoTL6OZlNXaxGJb0GdTtWreNMpWiFhCP4uzam6+EriMgab8KudS5CIIMKXQPAMtmYk7ltv7+TPEiW4nqTdj7bN1h+DPc+2SBRHj1+uoNq+kOCY36mIV8sH4tpwISSVvwJn5PhBivnyJnV4ZTmqJpuIgp58CsIdA2OwJLiMDa6e2JGflv5ALqn0M2/U98MOuuWqaiVCOnn/4BOwJjw9q9P1p2K/LhQI9ovGwpUnUI2EFT8jlTF7SxTuKUjWts7w3aeRfinhNvWFVP0QbYXwOAFu+AZHd/ZcXWm5oVFU39j7C1XdYMmO59ZJTCLsbD6wwuGB8MaJsf3Y3hW3E5QfiARwE9Spr1S3YhlZUEEjckHbCGHLUrT8olgNIGcl/MHGYNdxmBuw4BHJdVNnw1WsRRGNwouW8w3SvgB/upGG5fEUB6rlEanYhjAKnU1g7Cue69wqVfJg5+6zVIbfrbD0Oo/nfwYTLJM2PYzkzGRUDo38kJ/e2o3AqAe7jQzvS3Q8I388G5gZsXEljCAJaFgQnAHO523zNp2GIOonaRdNnDrRDA2oQQyTZHaVFGOZs0RmHAqEwdYbweKg9Bfw6d1IAMO23X98gYvFFzsPuNv7d6LkRdy+aFwmacOWUkScK1d81+rd3sUzIwMFubRLZJNyho0AMLbIrZpv2LzUj1arcxzStbVISTsP7EsfB/5S9m6ec8S13fQN60c59tATveCqNN++AKOi8KE5tuODr1vrzElBh1SmtFfOleKH8IXFCPMSOMKjvvSIs5RCaCgU7ETmhlOewK7KB09ovfv75zvYm3M11hEn0LQmfraP3BK7XHj1Xy43Cywu6t1EY7BoJ5C3mxaO8ZXBeG9dFzSVkA7HG8j/AlVtzPU6G0wRIIJ0W0P/DavI5vgwRafEqqKu
 yF7cNfni
 YKaSK0VDU/x65tKlstz8XS08PazwdHEqq8taggr+7k3eoeeGcHI6uS/lffgkNVHPR30xXTSrpfyBPMNaA8S04SlAP4PIbYm2RboLw4C6iPem26rkciiJ0CfIsB1iJ3J4lBhZUUHEthylvuGkUHCrhdhHYgeIlWytNjd0mPPIpVK5/V7XBffQLnzsi2gUAzhyQni5u9DvkqmYUO9vLNdkGkpnGcs2d3eR9W34Hdt53qrIALiUQalW18Rjfau8QGCQYYF647irWqtdhqiHfOgvTvzIe+E7w3o8/v2NWPNKTPtaL+7UfsA/+kO2bM28PkyzSa/Bj9ldqT3Jr5m/vhf8C0lmGCA==
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


