Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64872CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 07:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5ECF8E0022; Sat, 11 Oct 2025 03:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35248E000E; Sat, 11 Oct 2025 03:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71D58E0022; Sat, 11 Oct 2025 03:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 932418E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:57:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 208A7463C9
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:57:28 +0000 (UTC)
X-FDA: 83985078576.29.0B70589
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4201F14000D
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:57:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L3hpBzN4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760169446; a=rsa-sha256;
	cv=none;
	b=Igoi42MonaVAyP9SCPeVBVv2PQOiCmXcHQ0zT8TXc4DA1CBl/WfJwHJxqZBC5g3b792tuz
	TNLaxNOSVBiXhzHY9/RUudLkoqli4bckr+/jm1efuPB/vrjhooxF5QzIce5MN2MdN+nsGr
	CJ4n3v1qSZ+HHwWI6blrDa0iZWcKlZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L3hpBzN4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760169446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjl9wv0Cjt6vOeGjbZmdk0zIfEn5wfSJabLYFk4eoRo=;
	b=Be+NwONHlqyMJti9VwpXpkTYckV2N4b+HQV5K6GMRrw8DpB7jm5Zv/O/EV6iSRqP/0A4Jz
	+QDzQrQ6lcF5CWiIXUwSVOmbIK04LWlHab2N5tjdMMHzRC69DXJXxN1hqBmb/hv4WHlL40
	Be5un80CBcZgiTQV1nMhPUyL/EEMLqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760169445; x=1791705445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VZeBBNGnMP2xHvygAST1ORNwMzxG9wGMo9aWFTR0gjQ=;
  b=L3hpBzN4vWGrr0O4x6isBsjU7GrdQZj+YQyWR17KsFc72xTno9rSUqJZ
   KZSgG/ZhGThaE++rDrvEagttP80zfYjZ2UTz7eRdA3GYV4+xk7XbIkjFZ
   39h+OZPW83pW6GTfb1+irBKbHaBWdekloDhiiZ/bKDaPrnjhXLyk+32cc
   e9KIqoWQ6eGrkuGy8WnWiCTpHuOkyShfJ04W0cvIZ1emFxrhU72iUjerw
   qTNT+Z6NBJLtf9FmpTUuEFINqd9JGeFIWF5+zm3fw4NEP4oXWbsFVFhB1
   AArve8ZVekCeCStJ9sX/61ewpUUNRPhTTINC/K9o42l6IDh6hxQXjCJtq
   w==;
X-CSE-ConnectionGUID: ks58r/5YRk6JVc1v/IPFYQ==
X-CSE-MsgGUID: CCUZHWKKTESJfvVEevKdZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="73720053"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="73720053"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 00:57:23 -0700
X-CSE-ConnectionGUID: f4aFtuF4Q7Oimd3Bl0Dp7Q==
X-CSE-MsgGUID: yRxpbkLMQm+ToIR+7324Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="180742084"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.109])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 00:57:19 -0700
From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linmiaohe@huawei.com,
	tony.luck@intel.com
Cc: qiuxu.zhuo@intel.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	nao.horiguchi@gmail.com,
	farrah.chen@intel.com,
	jiaqiyan@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] mm: prevent poison consumption when splitting THP
Date: Sat, 11 Oct 2025 15:55:19 +0800
Message-ID: <20251011075520.320862-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4201F14000D
X-Stat-Signature: kcrsfapntz3bspqi6rskc7ndcfu7u8cg
X-HE-Tag: 1760169445-576099
X-HE-Meta: U2FsdGVkX18i6qn5kQRB3ip9re8MVmHtbAtchdkmB4QW3+H83FZIvbAzSTDVHAt1EhM3btw9oMbPtkAI1RlBhGAIkTaX+axIB1cwQ+L8GgPfbdpg4AK4gVGKZHUCpNJ7qc1x34pfhIlHqqGOquRP9LUIdoqkaeWpkicrZSOOuSkclm4t/9QORiailyN9011fLbtnZc6hwPpYbLOvgCjEJOVZ9GbxpH6zI7tGbIQ3XtSgwCREB6jOZ0rJ/sZVbvzz4Hz1vc4d2E/d5AOxFuyZ8XUVE6TZyGYNCKnRrF90y+HQk2bVzPiXfNyhCMrlYMXteenagdPYuei9HU+ENBqXyADERvRiHbqO5q8VzxEtrhWOUTY9lXbtPM9QgVOwvncVQ36+CT6mPqcZ/qlc3hFe0z6J3iHH0SqJ+BbNJVIq/xcI9ddyt+hy2ILdL4it3VypRd01qaV0Hukobk0RvlDmvd/esY7vrMZctASxVnqGvT0lzVR1rDqLLqeTD6y0Pa6GC0NB0Io6hAmt212jkfZHHxwtVrWlxTjoTq81bPF6EZnVYX7bcoxW1jKMa3jE2fdi4xohjSgv8agRYV3iliuupQzmZGWPaXVM9or0LToTiaKFfFsfoUU2TBEOihk2vH7lP3cNDUyvvOyNM3ScLN29HnpL4oNnm2qxxaUasJfgjf8Ry45Pd386pAfGZa2d1erMd3C81yUATO4Lh5854E3RrLH2ccTAsjIxHK98AL7EH1awIcSzBj7MFFQl53EKIr/L22SZnBZlak4a7z15rZT0H8a4Ruu0i06QGSz/LQDPnUV55/gpjgV6mC6RHvMvlCD8pesy0TGdF1K0tQHbf7bUQj/wmnHhurkPmdYr3gItii/knopc8jgJndRJRmN1wJp2AInBfipoHr1tL17NSmbxuQZ/24KsPUPsSSMUFyOuJvqYxPRgY6ZblVQIsiKN2WukOzU6/6sAGS+s3lni7Tm
 qPfXHmam
 0mCmei4JapFJr/AVMwlRzjyUKPigVRw5eCmyr2sbmiOMIrDRboRHOwAHy1wrQYbSuN6VW19t+iysf0NR4AeeHRIHIDqS8oadHF/tvgIAMTZZQ2hNHuNZvVqHmqaJKY8ZyMwh/JtXoW6BfrB3ihatGfuW0qSN2nj6ZeFY7V4MlVSw637RH65blyG57p5aG+zCv/qyOBj32pdiWUicOJlInUU92M4P4kso4IM2DiwijWy9jB8Y1la6kz6hhfo9Ta5XxghLeWJCvPooCviktd9C+ZfkaGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing memory error injection on a THP (Transparent Huge Page)
mapped to userspace on an x86 server, the kernel panics with the following
trace. The expected behavior is to terminate the affected process instead
of panicking the kernel, as the x86 Machine Check code can recover from an
in-userspace #MC.

  mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
  mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
  mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
  mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The root cause of this panic is that handling a memory failure triggered by
an in-userspace #MC necessitates splitting the THP. The splitting process
employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
reads the sub-pages of the THP to identify zero-filled pages. However,
reading the sub-pages results in a second in-kernel #MC, occurring before
the initial memory_failure() completes, ultimately leading to a kernel
panic. See the kernel panic call trace on the two #MCs.

  First Machine Check occurs // [1]
    memory_failure()         // [2]
      try_to_split_thp_page()
        split_huge_page()
          split_huge_page_to_list_to_order()
            __folio_split()  // [3]
              remap_page()
                remove_migration_ptes()
                  remove_migration_pte()
                    try_to_map_unused_to_zeropage()  // [4]
                      memchr_inv()                   // [5]
                        Second Machine Check occurs  // [6]
                          Kernel panic

[1] Triggered by accessing a hardware-poisoned THP in userspace, which is
    typically recoverable by terminating the affected process.

[2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().

[3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().

[4] Try to map the unused THP to zeropage.

[5] Re-access sub-pages of the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
THP by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned sub-page of the THP during zeropage identification, while
continuing to scan unaffected sub-pages of the THP for possible zeropage
mapping. This prevents a second in-kernel #MC that would cause kernel
panic in Step[4].

[ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
  original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
  to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
  avoiding access to the entire THP for zero-page identification. ]

Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---
v1 -> v2:
  - Apply David Hildenbrand's fix suggestion.

  - Update the commit message to reflect the new fix.

  - Add David Hildenbrand's "Suggested-by:" tag.

  - Remove Andrew Zaborowski's SoB but add credits to him in the commit message.
    [ I cannot reach him to get his SoB for the completely rewritten commit
      message and new fix approach. ]

 mm/huge_memory.c | 3 +++
 mm/migrate.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..2bf5178cca96 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
+	if (folio_contain_hwpoisoned_page(folio))
+		return false;
+
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
 		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 9e5ef39ce73a..393fc2ffc96e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	pte_t newpte;
 	void *addr;
 
-	if (PageCompound(page))
+	if (PageCompound(page) || PageHWPoison(page))
 		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);

base-commit: e5f0a698b34ed76002dc5cff3804a61c80233a7a
-- 
2.43.0


