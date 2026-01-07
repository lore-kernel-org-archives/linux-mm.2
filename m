Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9877CCF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 06:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03E36B0092; Wed,  7 Jan 2026 01:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1A66B0093; Wed,  7 Jan 2026 01:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDF36B0095; Wed,  7 Jan 2026 01:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEF96B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:38:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F760160184
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:38:54 +0000 (UTC)
X-FDA: 84304214988.21.3E3DCF0
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F4178180008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:38:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K0pHuY/7";
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767767932; a=rsa-sha256;
	cv=none;
	b=yAWZLhYVR2iCqV7VCvOv346Q/eAE5bl/uDqqhZPrBYi7555m4uT19spim5QJbsgtjtZ7PF
	4HhHWBpWb1HIxPPpW/IDmQaJKpX1bIyjNdqcS46XlGwLQCTBB1/gkV1GU4WKhSac1RcL1Z
	IlCpGnwSHassnw10IDKup82gbOPYSyg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K0pHuY/7";
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767767932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EA020s+TyrZf5BYAV9kvOI4txuXnqmEU9j3WXW+IK+Y=;
	b=tMk85aydpeD/Utjo6psN2dyaUyu36u+M1dy9gS+06VhlRLO/SjJCuE8v2gTcksnyUkl15a
	4obtXA2Iw43o4C6olqP0WWkb+8crkbLTF6lUJ8Wt7iuibYHyBM11y/WAiraATAHKOhUiBt
	Zs4ZcfqipjnzU9Ru4jmIBeGRtTh2Ddc=
Message-ID: <9b1cb571-99df-44f8-8c0e-8e9bc3f6e8d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767767929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA020s+TyrZf5BYAV9kvOI4txuXnqmEU9j3WXW+IK+Y=;
	b=K0pHuY/7s97Rx9tak8QLBoX638w7XDCKFSp9xuWVAvz5+Fh14t/8N2g/7oKJm3yTS/iO4u
	3tdKbvDoqtmNBiX3y2JFOoBqvZmphPPvOQhP0wYl0LnkYdOx5bCULp9XdkWk644cha+uIp
	7BijGoqiAZG6oaFlioTRdoq2i14/eRw=
Date: Wed, 7 Jan 2026 14:37:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
 <7472056a-3919-429a-845d-c2076496d537@linux.dev>
In-Reply-To: <7472056a-3919-429a-845d-c2076496d537@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F4178180008
X-Rspamd-Server: rspam04
X-Stat-Signature: j444ez8hc8fawax9qmitjg18s77a7pb4
X-HE-Tag: 1767767931-996156
X-HE-Meta: U2FsdGVkX18n4ZMAXrMaf5vDS64vmqkwM6eTgUyRzhf6Av23JoFP/PqU+eOWVHqaMmgMnAyqqbjNYNqUMITVdDDV+SUj1kMLXUogtHQ6uieRXUUXK4Sc/XMYUqFav8mrqvba4SEatbVLz9oQF5xTDafaMdo25RqHi8kQF4vymJKa2kt3HVIISx+YOr4YDEXSFK4dqR1Dk3lUaueNckOU1qolJLBqSGz7aQ029pwOz+/JrEYgQBeOxGZ6y2HCFJ6OQq77nQjjAHk1PM8zZxBsWKEZTQjQI64w+aALTM1XFZsRjXDLheOIqyi3//Oyh3EfFICJAlBhDFvBuLCoUAYIToPAwRWO3+LLflFtzF1PUDFBmm+zfv50XympbfmNDadWInmnqB65EJYDB2ufHeVPKVQLyo1zMXhOcDL0EACL9rTfTle1y2sCsI6pXOJgyMUgaNrtcyhiuPj8eDccVBcW2iFch/3niclv0STN2tfjaSVT2vPBTD+39A/upnfEU3brE8mFj7p2nQmdS1AamM2RDwpcyUaAgSW6RNtE7zEb1iXRJypaRnQMhzN+Y+FMu6ZOkM5cTCCVOAO2/f/vaatpbr194qfYJbp7RpABqiED8GpDCvwMt1VYH2XP8hB9Jy909mRJMEFNUssayfZCmm5z8UHwywwYsaX78fZK1+P6fC4T1uuFkllF2kLK+oXP/sppolrT219dUlJmvmoivzptYhjwBmYhmNUG48soDZSOcY5iahVjTTnS80AzNWMu1l2Yf9qUy8/e4t/d8nk6tx6/Zj9jA//S/KBfuOzZe8mm2aXdu8AOjW6KJyQOhSvfvvBPjyuVo7g3gb2Bf7U+WeZckjYyt0vAJ8GajCfVFu5kmsI/SIvTpAY6r2Kg4TozVCNHXiqGZneHGKxYZ9ooH6LHIeYMqeQF8HgZny12we7DVvY7KiSW0fmRm4l3cFgwjD7GXjvgtysJKOlLjs+Sjmy
 RMSoQ2k2
 NHMwcrbauiuz0ctiQiUCpp+1m3dVMWwmFy27tuJ5/k5EepRTunXj3KqtwXSWom2Z2JGsUEIl7uUpkLrKmDDl4SiEH+l9b+RratO8sbuYQX1gvxUrmwFeVQHqGg14CfUApB4SZ7GzATIAFvymOWXv1aqzCV+ar18gzD/cbLYtGuKI+Alx+wKx/wKNyN1foekIENeFbgCrI9HQCtnXeCtJ0leZBxqST0tF8Dzrx1ZNr6A1Wruxhh3CVZYuTWPczP3mFXPKc7Qa6npf2IVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 2026/1/7 00:10, Lance Yang wrote:
[..]
>> What could work is tracking "tlb_table_flush_sent_ipi" really when we 
>> are flushing the TLB for removed/unshared tables, and maybe resetting 
>> it ... I don't know when from the top of my head.
>

Seems like we could fix the issue that the flag lifetime was broken
if the MMU gather gets reused by splitting the flush and reset. This
ensures the flag stays valid between flush and sync.

Now tlb_flush_unshared_tables() does:
   1) __tlb_flush_mmu_tlbonly() - flush only, keeps flags alive
   2) tlb_gather_remove_table_sync_one() - can check the flag
   3) __tlb_reset_range() - reset everything after sync

Something like this:

---8<---
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 3975f7d11553..a95b054dfcca 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -415,6 +415,7 @@ static inline void __tlb_reset_range(struct 
mmu_gather *tlb)
  	tlb->cleared_puds = 0;
  	tlb->cleared_p4ds = 0;
  	tlb->unshared_tables = 0;
+	tlb->tlb_flush_sent_ipi = 0;
  	/*
  	 * Do not reset mmu_gather::vma_* fields here, we do not
  	 * call into tlb_start_vma() again to set them if there is an
@@ -492,7 +493,7 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct 
vm_area_struct *vma)
  	tlb->vma_pfn |= !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
  }

-static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
+static inline void __tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
  {
  	/*
  	 * Anything calling __tlb_adjust_range() also sets at least one of
@@ -503,6 +504,11 @@ static inline void tlb_flush_mmu_tlbonly(struct 
mmu_gather *tlb)
  		return;

  	tlb_flush(tlb);
+}
+
+static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
+{
+	__tlb_flush_mmu_tlbonly(tlb);
  	__tlb_reset_range(tlb);
  }

@@ -824,7 +830,7 @@ static inline void tlb_flush_unshared_tables(struct 
mmu_gather *tlb)
  	 * flush the TLB for the unsharer now.
  	 */
  	if (tlb->unshared_tables)
-		tlb_flush_mmu_tlbonly(tlb);
+		__tlb_flush_mmu_tlbonly(tlb);

  	/*
  	 * Similarly, we must make sure that concurrent GUP-fast will not
@@ -834,14 +840,16 @@ static inline void 
tlb_flush_unshared_tables(struct mmu_gather *tlb)
  	 * We only perform this when we are the last sharer of a page table,
  	 * as the IPI will reach all CPUs: any GUP-fast.
  	 *
-	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
-	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
-	 * required IPIs already for us.
+	 * Use tlb_gather_remove_table_sync_one() instead of
+	 * tlb_remove_table_sync_one() to skip the redundant IPI if the
+	 * TLB flush above already sent one.
  	 */
  	if (tlb->fully_unshared_tables) {
-		tlb_remove_table_sync_one();
+		tlb_gather_remove_table_sync_one(tlb);
  		tlb->fully_unshared_tables = false;
  	}
+
+	__tlb_reset_range(tlb);
  }
  #endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
---

For khugepaged, it should be fine - it uses a local mmu_gather that
doesn't get reused. The lifetime is simply:

   tlb_gather_mmu() → flush → sync → tlb_finish_mmu()

Let me know if this addresses your concern :)

[...]

