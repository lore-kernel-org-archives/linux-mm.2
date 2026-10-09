Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E5ECA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17706B0088; Fri,  9 Oct 2026 12:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8246B008A; Fri,  9 Oct 2026 12:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE086B008C; Fri,  9 Oct 2026 12:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 992546B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:52:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 356CCA7FB7
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:52:26 +0000 (UTC)
X-FDA: 85303681092.02.181040C
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76A018000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:52:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=dre6hgMV;
	spf=pass (imf02.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791564744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wxK6siBxaUgXXbS1nQNHxY8dGyGEnMxba3O+XHHDkK4=;
	b=PIWBV+sban3sJADv8xpr6TEQ/ZpNVijTwGSXshlBxQP8HFRVyTmdUy78dkrYNFLUrrQa6K
	zBYT/W9gtmMa+Hw0pgkav/YCf0wVtPcdwAf/mor70X12OR4+0iOTW96l9AmWbs9eEOaSNH
	CYBDIHfBFUSAqdCzDh6rdK/3jAh6F3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791564744;
	b=DphtX9HMWWL8MxIAqHlKU0aDWbYeV0VbO52f2qegGCL13uFWD8L0lwtqKo1Gw1MCqMJbGQ
	hlwHxxqMxNAt+6noFUfnQBtaSbTUF+6ameis61F6aot6IKAm0s2pIUhmYvTq96qm6UwD+X
	iifYKiKGXY49DjJ2W2gKVZPpgd/Ch1w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=dre6hgMV;
	spf=pass (imf02.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-825572e6701so1521a34.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 09:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791564743; x=1792169543; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wxK6siBxaUgXXbS1nQNHxY8dGyGEnMxba3O+XHHDkK4=;
        b=dre6hgMV5H8sQKkmAQVBpEXpXHCjk9lQ0F59pCyoj7X5gkHSoWcdJy77ymy/+wB3Tx
         cMD/6X2810rmBrlrr0AdfHzoAAionsQbMRqALMqGDZqSKQlf+ABusxlH7HdRkDVm1D3D
         BNlAkO/sl8Vq1bXvMfZThF/GnoB06jX/IFUes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564743; x=1792169543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wxK6siBxaUgXXbS1nQNHxY8dGyGEnMxba3O+XHHDkK4=;
        b=WY/OFs65yL674kEUQbWqVntAMC5Bm141Y8Mu/40mrNDIc6vi3HMSsZxXDuahSPUslD
         9nWeYPe673tlj8dSoQYxYoWxPfE8IGx5YLZOqRhE5h55JQai6AnprKDMoKhQLC6nhOfp
         ry/ifUiFbCXWTxPHxkERZJsUA4sJFsQATFFPm/Z6YSx3UthDyYNZp3NqbVu7A6soYcxx
         CMe1T9afcj2BEhhgiGIjzFEBpW47PGo2sykeMMUkHPOAZigBwBW6xiXHi3x4KM0d45eT
         ECTA16UViVNou/kBRvmguQELEXuxp+xZ2lLnkNYPrItdk+q+mQoxsLIpi/k9x0o2t5wG
         B+6Q==
X-Gm-Message-State: AFuF++nGLsQZ4FlYbzqmsNgRGZFPP1EbyX30Q7hLHHa+MiQtXz5xRS46
	xiujSnI0Uf8jGqc5ielsOewzPozkhFpFndF5VPuC3Ev/WpcLbM2zQULqUuYiqAAHnzTXbAJSsb6
	H9+trSrI=
X-Gm-Gg: AYBFou2Pp1+UYAjWa/54X7x20r5JYhFkcngKf/1kJRjTz2EWRL8QeZNHpMgE1cCG/ek
	MtHUg7EtEXtYZ1j4gshbO5MPaJrSXRm7Dtj/2GUuf/0sZI1z51CLLlCZjvra+NxVBdJwgSRFRec
	lL1tu/R7qJqWVQ/qreJl33wtevIv/N+NYQ71c0gDd90W1K/MaN5bjP6rEUFv7Iw7sFnngMgxoqx
	NEy4ssQJ/3yrt4TsSQXy1uqUzNPfDdigLwhVsjeJarm3ZnadvCY/wgs2W8vKHr/4bnceSJE3in0
	DzumtJ0kaB9YYkVkBEY0RHUKMCH+0DdR6KAS+KOGE8lKGZQj+UFKBUwOOYrUXuwnJw2QUdk1T1c
	G//I7Q9f+8BWJD0MtNbMVB8h67x7FBjBdHNNekyBmNT2gFSZDF4IponjgSpRvENmbZf8JL3QBPJ
	cVI3rhnWvsD52cS8DD1POfQR3u4U/9MdEqyh1KA8chtyUS0qysa1WN+usF5ZUl9Ewf+S+zyouCM
	+yfd+tdsW1v5+yZix/0eH5H7Lr1xNcKVcDFtRZqV0blI7+35rBw/qAnXfyBCHsiX5Fz6pUyRoQ=
X-Received: by 2002:a05:6830:6d29:b0:805:9b38:6f7c with SMTP id 46e09a7af769-8309797cc66mr1926179a34.29.1791564743382;
        Fri, 09 Oct 2026 09:52:23 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83039a3e016sm2174263a34.17.2026.10.09.09.52.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 09:52:23 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: avoid transient none PMDs during lazyfree reclaim
Date: Fri,  9 Oct 2026 09:52:15 -0700
Message-ID: <20261009165214.40212-2-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76A018000F
X-Stat-Signature: ctu6d3fwq7yr55cf46ax6o9c9f9wefom
X-HE-Tag: 1791564744-827631
X-HE-Meta: U2FsdGVkX18WNYfSzbJFpYYcgomwt3CDSWAcSo+sObp78kOfnf7yA+N7MbTx947O3Ng8I4iFMkU1sMWHtqHGaHg4Z/8hK+yuajNX9h5vXugzvveucr/98V+dbK8xRUZ18ekDi0fLb63WaAbuwMEpg+47KPj0eM2aDB7WrKycUY5kgFrqRX/Vwr32vnupQvTUNw5gqp2Jo6C3FserjObWQlvwtyhB4/10TvTwUcPWT32WoA1I2b2JbapuY8tT2fzr46EMYcIyt383Nj+gjmxHjNryu39gYQs/mgdYTFObF/76RITBTyo9m3ElotlqO6KrFgc/7JMpCvqMoIoirnvVrzYdwqTEUAo7hTZ7jlFjbNzIUsdaLEBcPuMi3t+2WU/QZwLSWcLQZaCV+lEC+OdlFByiHbk74qK6inDUom/WdL+w53GqjwhKCkAIg9EUXsEEprom1XT6PqpF2WXhERdYMBEQdkidP13kqMXdcmGrhYxJQcvBdFLCOO4d8/vSbN6pE4epWYLaCNwMcJ/Hxgy4vn3TWcuAJsEnFb3vEq42KJrv24s53VMIdEF7WE2agSISFze3zXtEumaT0a7bhcZ6URIYNdGbtFj0eYxOlsI+Gii83VP2jHhRd43MdFXlOqT5R0yYibjUiPtoWfjemyWanagn7yEGTgUCpwu+yCMk9tOkZhmK2vpZP1EUXLdvyDeLLFhAWUwEW5VodjOGihYdiQl8WPKfGzPVyeqJNoXl+Jln3uHT0SWddSOWaIgDRVuOtNVG/VYmxipBdJFgTEJ8iPkHt0vje9yDEB112e7biz0uvMBcCYekom0tAhiWDjAN3bAtTEt4o+RaAW/DpNTFh/HJTx1ylPK2N9g2Lxp4aSYNthnyEFmxPwzhjfDm9j5xHANTwzK0AIMPJVBulZ+CjOdWjUj+2Lz7SJ9gU+F9Hrala78/Mwx3qOCJsZKtw/+nmBa/b++kjfVMbTsdblI
 Dqkp6d8K
 Z4rgDdQ5QapzPhge1YKRH89IO/VrSdD+DFDJFdU1CTkv0apQdJkOwNYeMnhPXoPYRA+fP92stVU1pFny1szyQVTMX6QkmRQkcVKp0vmrS+FHDZVyNE8cYvTsM9gvN/YcaHhYJSKPtHqPO4pk92flS3sqoaqXZVXkWpFtKGasIIX/BWTu0CmoA0Adrac5t4SOW1sMMYmKhTWwGWeHz/EocXyC2EOdd5j6Q/BF4Pso29ZXpK5J62BL5PvkbO1tw2EEsdOE3tbvljxiJDqaVXsl/EZoznG3GtvgmuIbIcEp0a5CnBEADP4Kao0Ew/bcVTs1Z9WcXQdzCEQZa+u/PR3tLOXMvDqT2FGBmr8r08x/ohg1v/ZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__discard_anon_folio_pmd_locked() clears and flushes a huge PMD before
checking whether the folio can be discarded. If the folio was redirtied
or has unexpected references, it restores the original PMD. Reclaim holds
the PMD lock and the anon_vma read lock, but not the owning mmap_lock.

Both zap_pmd_range() and mremap's get_old_pmd() can skip a none PMD
without taking its lock. A concurrent munmap() or whole-VMA
MREMAP_DONTUNMAP can therefore miss the PMD and later unlink the source
VMA from its anon_vma, leaving a restored mapping behind. The anon_vma
write lock taken by unlink_anon_vmas() waits for reclaim to finish, but
does not repeat the skipped page-table walk. Once the remaining VMA
links are removed, the folio's positive mapcount no longer guarantees a
live anon_vma. Racing lazyfree reclaim against MREMAP_DONTUNMAP as an
unprivileged user reproduces a KASAN use-after-free in
folio_lock_anon_vma_read().

Use pmdp_invalidate() to keep a recognizable, non-none huge PMD while
the discard can still fail. Concurrent unmap and move operations then
have to synchronize on the PMD lock instead of skipping the mapping.
Clear the invalidated PMD only after the dirty and reference checks have
succeeded, before removing the rmap and withdrawing the deposited page
table. The full invalidation retains the TLB flush required for the
dirty and GUP-fast checks.

Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 mm/huge_memory.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a..20262195385a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3569,11 +3569,17 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 		return false;
 	}
 
-	orig_pmd = pmdp_huge_clear_flush(vma, addr, pmdp);
+	/*
+	 * The discard may fail, so keep the PMD non-none until we're
+	 * committed to discarding it. Otherwise, concurrent munmap() or
+	 * mremap() can skip the PMD without taking the PTL and later unlink
+	 * the VMA from its anon_vma despite a restored mapping.
+	 */
+	orig_pmd = pmdp_invalidate(vma, addr, pmdp);
 
 	/*
 	 * Syncing against concurrent GUP-fast:
-	 * - clear PMD; barrier; read refcount
+	 * - invalidate PMD; barrier; read refcount
 	 * - inc refcount; barrier; read PMD
 	 */
 	smp_mb();
@@ -3607,6 +3613,7 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 		return false;
 	}
 
+	pmdp_huge_get_and_clear(mm, addr, pmdp);
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);

