Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFFE1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B686B008C; Fri, 20 Mar 2026 18:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2D36B00DB; Fri, 20 Mar 2026 18:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FEF6B00DE; Fri, 20 Mar 2026 18:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 206E56B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A71AC896E5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:59 +0000 (UTC)
X-FDA: 84567844998.24.E7928F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E4F3C40009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ax+3vlpI;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCxYZNygV3g2W+jvrqpfEQVYbTHiKlLNdddtWlp2sYQ=;
	b=zIPer0BMN/iT9quyEMN0+9TRUWLICl8xmnB5giCwUIuo5eQzNNE5/iwa+s6yzGJ7eS6pS/
	iVEOiTEP9gvONj2aGZzgNXS9OG0pawRfynydxy8Dhk+ddx9VI8CO3I9Vhm7BA8IumkSS3Y
	92qq1V2Ij2KdiGo5mwkVXLgIr/5/E1E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ax+3vlpI;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044838; a=rsa-sha256;
	cv=none;
	b=O2hYMVLKvN2o6iw+lag0TVfhwdlEXI8+UlHjYSxUCjbVtaxJ9hLb4NpuHWt6viqXCQcB4+
	qGcSXlgD8g0eIe/my0BO6YZnEn40C3lxCMeIxBHb4so+9O1Rvvdzt0SAXADtq0r9JHmj3M
	sdo5EfKDdnR351hCIdEYmXwBFetUFFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0DC0441BF;
	Fri, 20 Mar 2026 22:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E915EC2BC87;
	Fri, 20 Mar 2026 22:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044836;
	bh=qGQ4S0Dk5OWFFlnh6q01L6aeYnQdqeH7CkkASIBS58U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ax+3vlpIZDyDFxIGzU4ohpjnZ07lb6mXpCmB5SmtxOCikYKHnwhZR+rhhZ3Ots9Bn
	 vHSVkAjBM3wfALykYjhp/MkzWzNvKTEd9sUM3Tw4byVmrY6/sDQ9Ob/KzLPVV38hHy
	 ivcccHnThBm+RNKbO79irp0quB1fH4ydlStXcOe0Wg8BDnojiIJshFcUy5lL2kBMkJ
	 ItQMpEA4sP1pRzpMZBjhJ9DCJmiw+MmjRupYS7CRNoQxTOeMI+PVLfKqkHhVNAvBZe
	 WYFhpaCfdn1jTQT6GaVjgORf7rnYt4myxTj3ldG0Zr25VPkt2/Jzbu6xvGk8fc9FDq
	 WP0dgVm9VXsdA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:35 +0100
Subject: [PATCH v2 03/15] mm/sparse: remove WARN_ONs from
 (online|offline)_mem_sections()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-3-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: E4F3C40009
X-Rspamd-Server: rspam08
X-Stat-Signature: rbzzd4o7xsf6opbhptar4sxzgkjqien8
X-HE-Tag: 1774044837-756160
X-HE-Meta: U2FsdGVkX19JZZtRNIUfEB/tfk5KsdHUUE3zlsa0vdFKFOSctkttnIFGRR8hiY/lvdrvx/VB/M0aq/MHVtHOVGrvi97wiSSqiC/uT/ZXhLpeVP1mPFGQ7Gb7yoCYQ4GM8iHMe25/jdrdX6vEmgfSa91+IvRan2fCmw19GfbHcYK0iscdP96O2c+CQpGX/D0rtMIZrFCPzvFXucN6A3cCBLOYHkQDAKSujFVZrwmUIiZKQYHLeXf54c0J8bKzsxlZCZ99SelZ3sZw0J7xxYORtVmmZMwHbFloXlyQcOHOlnP7/YW5bF2j0s7AhN1mItMNKVUk2q0Z6qfFBttKfsb5kU09D+Q0z25qFU7DRVpVAVm56VJBQWCDrZq8A1o8+ZDWumA3OkAqqkboTKBQTqIIMf416/hv8ID1FC8Mvc+UU5OGe+k1uW42YVJ7MVT9KU0gVXFmH9J1JEyG57CLis0e3kmQmrUzxJit1WjmR7FxvXSXfXvya+T5YHLznKzzRcs7qkgR+dzoKqhpI64ilnLtrfuhmmVS5makoqJ+BO1h0fwXDjj0MBNitDkz9ZvFTXPZMAYNFEaUO4U/aC4+yf+UMABQJNtjzyXS3vqVvVDcbHUoqEcmdrl1PrSyiPmHAhglz54W20ttVdTNqzJIleOK8SzD9UTzZfvNiTlmg/t2Uiw4Mc9IHCj4s03fqxNmfcRqlyvJ8F0izut8pix5n1fjM89mpitLqO4NHTH4rpAjdfn/st0iROlJwdnJVYybeFEXX2kGdeBrTmm3qNucmYvOxQ+j+NvirSZF5n/rNEsrS76Rhr76sKmb/TlW7y6Ld29QGwmJBta2BuEuZaONmM9mFLGkNMdtqdvOvoTe/Vnt6tF17103EgQT2MBnHy8i3f3nRZivSFEFg/MAw+/SOnEaLtabdkcQni1ZJkkPcjKQfebf2/wyAgzg3iUNfVqUc4dzEFQB0xJQU2aC6hpKtNV
 77eeva8w
 kFPapLO3ebg9Lrh962yURAq+kCOZ6uIoscJQJolpr6G7QYLfpXZ0uD/AXxcAhrO+A4i77cBFeACz6XVBESP/XYeh1M6K+22uCPOVNCeuwNoxeJrFedXMGQgceP786+fqvttkzVz2deyNQKkjP4aUVVuL0TfDuMPy1q0aRoQBGinU2R9d3GgfvMReDdCfxbx70Ryh/mr2wENDSsdMJmpPcYjwNxpCXG0DE6I37bZSXhdAlLVHwhMkaE6iOhk/Wl3t4NnL6HZCNQTWfyVr+vmg+LEg/cmU7coV2NZRF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We do not allow offlining of memory with memory holes, and always
hotplug memory without holes.

Consequently, we cannot end up onlining or offlining memory sections that
have holes (including invalid sections). That's also why these
WARN_ONs never fired.

Let's remove the WARN_ONs along with the TODO regarding double-checking.
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index dfabe554adf8..93252112860e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -638,13 +638,8 @@ void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
-
-		/* onlining code should never touch invalid ranges */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map |= SECTION_IS_ONLINE;
 	}
 }
@@ -656,16 +651,8 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		/*
-		 * TODO this needs some double checking. Offlining code makes
-		 * sure to check pfn_valid but those checks might be just bogus
-		 */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
-
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map &= ~SECTION_IS_ONLINE;
 	}
 }

-- 
2.43.0


