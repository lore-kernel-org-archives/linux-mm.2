Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784E6CC6B29
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561F86B0098; Wed, 14 Oct 2026 11:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A0D6B009B; Wed, 14 Oct 2026 11:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428AF6B009E; Wed, 14 Oct 2026 11:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 258816B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:46:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32AA5C0606
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:46:37 +0000 (UTC)
X-FDA: 85321659234.12.4225FF0
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F5EC2000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:46:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=K2pQMiSk;
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMv5U2kupUmtXz66ccHe/Yh8rCYgenznf122ZvfNPM8=;
	b=wlyhvb/QNrZWRvqwTf9TS2i56l/ohs//G6cSgJjCQHm1IKjjfbSpe2ifx6pkgXrEEtEZpe
	eIPKAqSLzzjj1xS80EQ5CxvMe5V4eNXk8wta/z9s6NOoTPi04Dx96iZFSAvf0r0lqNAbSH
	n1BidcrrOsVtad82CvKObMgRVeU9/No=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=K2pQMiSk;
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992795;
	b=YSfKCmj9w5+d0WL8B5bJis5Kw5md//axtKwa+BgRG0SGb9RwTxSEW3rm1Cicf526NFYTvy
	Yjudd6UaPDmggObbRq9fCIOMjfjChe+U1JaSgU82/Zi9c62Uqk8PkFNJJaVbG/C3IP3OlO
	7eqLQwk7LnWAT1UYrIXA0GM1tZcKb3o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=EMv5U2kupUmtXz66ccHe/Yh8rCYgenznf122ZvfNPM8=; b=K2pQMiSkEIH7P8hKJB0
	JM5g1DAstr85+VMmMKQREcTVvYlyH9242d4WCiMnme2l7EZ6683ckBx09NtVAR74N+DEFqEy45Ygg
	+kwBM9Ou//dMuU+vxgY5UXvhFDRs17fY0Q3evizQ1hMoE5ZKxA4L3UuuWYr1WG7uO7etcWLy4P/W6
	8+PfOCQTiimVpblvv9c7E8go5YzRPbawZ2B4Q0OwapXulYWXR3U4Ht3+LpaWtBYO/wTe34MeN+qSk
	0Ht8mvNRpg/Iam3+FYjqACDq/79P17/6Jw6Hm/pQkbUTD2ANqeAQy1Meq/f1bMBKVvZ1wZ6m//Yhc
	5c51Kl06sqhD+2w==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH17q-006OFq-2O;
	Wed, 14 Oct 2026 17:46:14 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 17:46:09 +0200
Subject: [PATCH v3 1/2] mm/huge_memory: recheck a special PMD under the
 lock in copy_huge_pmd()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-1-85eaec8417f6@virtuozzo.com>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2667;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=sIdp45qCVAMC/oMNtppMSs+1CULAOMEcEyoP7Ygja0s=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqz6PFIbb8Nor8wTYNoHR7PZeR1qeybbFlD6+wd
 +0+taKoZdGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas+jxQAKCRBRlgpH+WFc
 Kl0vD/968/kYsYobbUx0cPTui7Rt1ZMQVmfgrr3DIbKM8eppM2P1ghpu6ZGDI2pNa1Xw6oQl1G5
 LwlXCJFNinaWulXdC/NYm9KA0u8882jh5YO79/fpfVoCvJcMJn4R9iykn+AxafzpQrhpIj2CzNo
 KZUw7w7OhcnKqKV5guGMyWBPpColCAFKWi3xzCqKHTuotXSjqph4iObqAZjUjdcqkOPkyAf3oAw
 1COP5gZaDqln/mQkQoboYGoBlwveqHXOPKQuCHr4LFvgYZKIAemX2NSYpGf83agvdzKEJa+u8Wd
 oHQsUgGCuHJmkRGn4ivi/yYG1eNvCp8GRJB4yl5jGl/cS09Wl6xfyG/EILJR5uDGBWKWiV/ccSv
 ryq2Ibk/Wd/GMNzYlqybjO1dGRMecxUlUFBd6Wzuq8yNKZlHESbLDCOFaNqn5jWkGNOv82VVB+a
 2R2jssBIGSYbHxJK7/XonDJSrYWZmSXRkfNhmpVjIKWu41f29wWFT/zA8E6MslgeIqMAJkb/g3M
 Sx8/W1ZSXtfo3qKdQaP/s8qsl3tAk6eJwplqByUemL4DdO6X/Eq2c2J/4SxMzGjSgjirsRQsZkV
 RA/QV3G4QilnpwHuHKC9PRyrDbOTk82x1iTT34bBNKEL/3+5l9G8la0Q/IQf9TFMTQ84AaaED6q
 YiB+61jTMlIjbMQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F5EC2000E
X-Rspam-User: 
X-Stat-Signature: f5o35tjeskgnmipmnp77abkpsmrxrccy
X-HE-Tag: 1791992795-605527
X-HE-Meta: U2FsdGVkX1+rMeVwHpRt304C7qwcy/gB8U68LTKfoFyr1bJMgfBUJyRRnurjR+y2O4uBW4NVkho+QGVmoxSjw08edMzaRqBRK40aWuhaAKB8LDu/FM/WuOrjnAMn+MvUmkz0MC/qlsb3DEJlVPU3+NRMAMAw+hi9Xfe3X4+keDj6Da4VDD5+Z4rxQLwle8mhwPUkSi489dz12a3Yc30ukZpMIJQ0bZfwD7+pGoyBhsxMNF3No3dJkqXclOKeWpBLfxNsWOQfQLBc21CKO5fWOE7RXJepUG2Pyt6T7WBO2QK6JgWPapbaxqf2xEx45l5uPZW54cQMutnKm8bvPxkwkf45Cjo70N8MJjYxfQKhD/QqBHL4KgnvfUAQlPgUkdIrf49RJLrDgPCOG3STK/50hwUKPY8xtMTFwEqDK6BqVNd42H3m4t+kPIdjEyOwe2cMTeIFz/6sDluiybjAClvq8KMZUHf88UPWDfgohW3myMdg5DZwSQi5+usaVr9pi7EfamFdJivUAskOEtdcJW1TSOyOO47qRjTvv4+KjOUWWh6cvNhj8KtNKsa/C1NYIbvclRn9ETf0NuMDFYlLbExPEYZB49osvYAWaC0r8NwSrSK3K2tOIDPrtqb0QGGsxJ/uhR3Ux3qA+gZ4kqN4RuWigvdbqoCf3K+LDdSEKkqeesnM5NhCawdx2IXHXtjHCYtx/cEAbQQOZl/q4HfTE9Vydf8KZCVUfhihBKK6ggFCA9oRQN3rfD9TpgiiJC3yxeJs6e521xdWCJ1IWHbX4DrOf7/wsddvoTNTDojtEx5uwCi3J4tbNjttanrOfIzAQ4jog73o+H+aZ2h6UurB7eZAI9tWTwEk8drM+mpBswqhy65+kukrf3HKFpfws/GhjidzJOpu92IniteVKl/ykGU4pIzioZbO0l+9iyyAYrAS+n9BJ+5twHutLRRfkRQWA2m1DsG0xZmjqRDLxKFiUeB
 MK5+TOPx
 o6lawKkf7/7Scuv4qtIxO1E8wMPq62HjBXrlKZTK3+T0cGBBPy7UdzdvmWmvXkON0BoXqLIU/246IuTyFB9xDnTpQBpVttHwGRk2DwOjwn91aVfk5BWRiotovMxftHKDu3UvgC1zjVP3qRr/GMoWpu/ehOhcjuNoxAbEPbb1TSjHuNjM6aH7gy1+Bxbiu9tKhrxNbWmf5QA6+dviE8LjU3vl+W7yTMX5jT/dWttPcnjg6pQT3vb5kKEpSXBVr1a1u9qTOf5w/Xg/JzoO7Z/xvekbZ0xUfFPpVxn+d2DV9YBnOOgcrYZlX2h7ZFVnHdjKHaD7oIr2qUCtwzKlZIXOv7OLOrxycXSmnJNwn3AdNaKHWe8T2LYqyWtB+R7sBWVCttZcW/42P+Rsc1qK38ufvStoI5tmitUWFpDPu8NAXm96msTcJQYhDeJNhtKy7liKkZtgShPhmzi98D/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_huge_pmd() reads a special PMD without the page table lock and
copies that value to the child. The mmap write lock held by fork does
not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
lock.

The zap visits the parent VMA before the child's, as dup_mmap() links
the child right after the parent in i_mmap. If it clears the parent PMD
after fork has read it, and passes the child before fork copies it, the
child keeps a mapping the driver has revoked:

- vfio-pci: the child reaches the BAR after the device memory was
  disabled or the device was reset, instead of getting SIGBUS;
- panthor: the child maps the pages of an evicted buffer object after
  they are freed.

Read the PMD again under the source PMD lock, which the zap takes to
clear it. Either the zap got there first, and the PMD is none, or the
copy is in place before the zap reaches the child. Faults are locked
out, so only a zap can change the PMD, and pmd_none() is the test.

Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a5..bf788bb231691 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1965,13 +1965,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
+		 * The mmap and VMA write locks of the source keep faults
+		 * out, but unmap_mapping_range() does not take the mmap
+		 * lock and may have cleared the pmd since the lockless
+		 * read. Let copy_pmd_range() skip it then.
+		 */
+		pmd = pmdp_get(src_pmd);
+		if (unlikely(pmd_none(pmd))) {
+			spin_unlock(src_ptl);
+			spin_unlock(dst_ptl);
+			return -EAGAIN;
+		}
+		/*
+		 * Make sure it's not a CoW VMA with writable mapping,
+		 * otherwise it means either the anon page wrongly applied
+		 * special bit, or we made the PRIVATE mapping be able to
+		 * wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
 		goto set_pmd;

-- 
2.43.0


