Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A569C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E3E6B0092; Thu, 17 Sep 2026 22:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01986B0093; Thu, 17 Sep 2026 22:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16FD6B0095; Thu, 17 Sep 2026 22:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE3A46B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:52:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F2E1A5DB0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:52:31 +0000 (UTC)
X-FDA: 85225359702.11.2A0ADC9
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 639A1A0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:52:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n4xknpOB;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789699949;
	b=xdyDqWp+AV2qbVzdFPJAxROUXSOEYm8DzOMe8L+IKBfhGRC7NyXF8t4rfZacZRlokK66m7
	CU5LpVV/n5bYhZ1FGUpmwfZpzX+j/ref7CnKzL63PARedAxneECBdLGzyc0Pj92mKv4XDC
	uYizlDskcOzuK04O8fiFJ8tMpUrBKrw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n4xknpOB;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789699949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etLIN0TiB+gPC1ustRQHs66Sp9/28m/d8sKfnKSX7d8=;
	b=tRjnzaI9VVBJjncJ2kx78DyLnQ5WnGTPx89JlS8AfwCg8QE1UqMNDkYlNT4UlV+cq0Zxxm
	FMDJLG0Vk/qkqii+kP7SRiyb2tm0fA9okR7EVFYrxfXsTSkgG8bfUCLtiT40Tt1hq+5rme
	T9y9ipciuxKNmq4jmavLEcgK/0HqfpY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LskNNPuSB8QoudevYzVr17nYyrlTqFaZBhdrhrFkhzE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789699948; v=1; x=1790304748;
 b=n4xknpOBPPEXMDCffjNgIvAWGb62BDrs4DleaYuZxUEDkNfBWXRIwzKw+466pivTS4bSZQYT
 vsmvnqXeXyFLdAYvHtbZ7YH7rSctHvc+yO6w4qF+8W8tYc18nBIHsyGenWHDptP9JPoA12bbKGg
 9BY86SGdjL87zt5oDYkamfW4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b61aff39c1dfddae;
	Fri, 18 Sep 2026 02:52:28 +0000
X-Mizu-Trace-ID: b61aff39c1dfddae
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org,
	david@kernel.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge zero page
Date: Fri, 18 Sep 2026 10:52:14 +0800
Message-ID: <20260918025214.89109-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aqwPHfWhKGty-Q_4@thinkstation>
References: <aqwPHfWhKGty-Q_4@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 639A1A0004
X-Stat-Signature: kg1ctw346sutwha9f5dnwd5seag39p93
X-Rspam-User: 
X-HE-Tag: 1789699949-452260
X-HE-Meta: U2FsdGVkX18zf08c1jAxD9Q8lGpkmud7Qh7FPk2i45TZSyG9cO8DxnUzwS/EhzVKJ+C5ssc1xQ20Hk+vMQ3I0zYkb82wvKzKYcFyaGCCYCERa254JOiY4uEtKr0Rryux2s3q2JOQ0g/cvE3lHPTI5L7gJC4+5fIkwcgNPhzmYCiSAM+D5pAF2QW5WFF6BtV/ObQqxkfqjUbkfqpgRaQUmv8wUzRWb5/dkRQSIpekBnNGqHc9IotYqt16c3xjvbqtU0Z9jZpQkFPy7mseH6OEaYWZVCTdMZ4ij1UWQfCQh05/T4t0Hn+X7oTlq2liqZZiAcIdBvAFMNV7lpBNuDOOmmA8dlMBKmTbRVkWc93NyYbqvH7qlQd7L4JM1MHLO42XJzC9RZDJSvlTmSEysPSAWo0VTC+3qAYcfZtZEJneKphkAAu7a7/LHi7UXzYKq502rgp9EuroTGEGjea0YYErzDrboF5xJ1uCZ+ODpXo8Q7BqujsbxUC4YmxTUA08zI0/GDEicLMIfiTZMc0ty5kZBmQ8G9vr8vySuTfAy1WHTGRW9ojW6wIqzq1UrbcBXRWrKXbR0X0wB50lxeF1354Paq/Cgmtvi9lIDGBzVdGgnymLb3GH1CVZH4M/+aUlX14msVPVeDytvsSTPQvyNiaRN7Z9+eJI1vpWG2N7+1JC/6YI4VL+/ovxwJXpPFGnLRIuMBIFVqhmgOxKdjtc+8Bbnx91hs9FX6HWEU6Pgy2PSA/DOWlYdOu70NRjBW/FHXXXhMjepSBefC6ip0gy2rpWpnb0Po0dgwjlO283ksohTQ7X5EvOHsbyMRzJpQ70evrDni2XuePmYXJ9m/T9I4OjXnk85mbTb/r6QbxYxiFBJNdJPJiDojY6JkrdNJboLpv/5WDfDA2eAyGfCx0M4OQt0zQ8L/uiHeFYD3e7NRpYmnd04kbr6abMwJ2VrQk0dqPbGN09tNddsfqAHs4iiHE
 3blf9qKA
 jT0xYUu1PvMk4AqJbaDqRh3wakSLCzaP/nsi0yInGL7Hu0Kdn+igNTVoPjmnxa2caHQdQawZ/vEaCo2BGn35OxhwX+5Pj767pVva40BTxre9NmJA8XFHwd4jJfCOPcEXSzxP5NmsFV6c0dN50yTJr9fXI+oQpVwPr7oYG1atQ//48eSKbkuboxMSXovzqpt6iS7U+SW1naVTiL77r0t73tZAT6F2zpX79fMqjpinmGX3QKoWVFOz0Go3Fnh5hHHx8Sk0zojM91bNifjWAAb7fNQc04N+zlJQPnYfm1WfXaBUWxXEO2QHfdRgXPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 05:03:09PM +0100, Kiryl Shutsemau wrote:
>On Thu, Sep 17, 2026 at 05:29:48PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/17/26 16:32, Kiryl Shutsemau wrote:
>> > On Thu, Sep 17, 2026 at 08:10:10PM +0800, Lance Yang wrote:
>> >> vm_mixed_zeropage_allowed() validates zeropage insertion into
>> >> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
>> >> through vmf_insert_pfn_pmd().
>> >>
>> >> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
>> >>
>> >> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
>> >> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>> >> Suggested-by: David Hildenbrand <david@kernel.org>
>> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> > 
>> > The patch looks fine, but don't we want to cover the same for non-huge
>> > zero page in vmf_insert_pfn_prot()?
>> 
>> Why would the zeropage be a problem in PFNMAP mapping?
>
>Nothing enforces that it is read-only.

No in-tree user inserts the zeropage through vmf_insert_pfn_prot(), so
rejecting it there should be fine.

Something like:

---8<---
The huge zeropage is reclaimable, but a raw PFN mapping does not pin it.
A PMD mapping of huge_zero_pfn can therefore outlive the folio.

No in-tree user needs either mapping, so reject both with VM_FAULT_SIGBUS
rather than risk making either shared zero page writable.

Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---

 mm/huge_memory.c | 3 +++
 mm/memory.c      | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b49bffe36d22..de34d64aa763 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1723,6 +1723,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));

+	if (unlikely(is_huge_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);

 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
diff --git a/mm/memory.c b/mm/memory.c
index 9e4a70421a6b..5d2d73c69fed 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2956,6 +2956,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));

+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;

--

That would keep both zeropages out of writable raw-PFN fault mappings ...
wdyt?

Cheers, Lance

