Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95311099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3D86B00EA; Fri, 20 Mar 2026 18:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BAF06B00EB; Fri, 20 Mar 2026 18:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F84E6B00EC; Fri, 20 Mar 2026 18:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4306B00EA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5776C1403CF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:20 +0000 (UTC)
X-FDA: 84567845880.25.8AA9915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99606C000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H0/W1BGD";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvRNwt9aHZDtv278PUzi9b8IVYAkfSTgFqC5DRh7i5w=;
	b=yKebqgAYDQzzF5fGrtpxSzncfUMle/q69R3pqsINKw4MaAQ1BFeHhnPO2T5N4U3Be7S0Vw
	1ZI75tCEC7LOiNPh/qGMiaUBhg4O3BS+Rb4Tq5JwL0vkMll4Zbd6bAeYydPch92xktdwxy
	juGn8bDOAzGmKekveg0qoyh7eqhZdes=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H0/W1BGD";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044858; a=rsa-sha256;
	cv=none;
	b=gOrp05zbIIo6sMzepsPnOGcSA5akDae+kmZOpVP0WIIoxt+Nd4gYAhEWllsvMn/LtxNHzs
	0HrGzXRQwQZvQpsYXj9p6sUixIyqRKPIz935lAsUMQgSW+0ztJo6cgwxUMadxm7OVKk34+
	FCBFv4gQBRf8/GzR3YmnwJtq1KpvQyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE2E840896;
	Fri, 20 Mar 2026 22:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CEAC2BC9E;
	Fri, 20 Mar 2026 22:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044857;
	bh=0oSe+G0ox51l+rDc5XWCPrdWsQFUFWnEkGK5VjFVki8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=H0/W1BGD21v37hv/vshpWeZPJIUG7Z+PAKpQpegkE2rMSL3nV8vmemwLkEqmGAqKE
	 aIJLxod5bPaIFhk0JEsIr2N4weldzrcc3Zw0DZ3mmlFMdtwYshMcQDTU2fV+pEaEhl
	 ZxWCkhqP3o9gcshisQvElHE8kAh8IjNxbkSoQ9R9CtK3DOCzidXm/vTlDvzpBAi59j
	 6vFWDdibKp6aLhEqrtJX9ezac64PXtpbT0N87txVKuXyOR009EjU+zhfmYKViMllk5
	 vce7g6QiPvGzq04BJqmkHud3AcOGsiQQsI7+czklwG/3ApFXHs15UsEjogrRFAzOBr
	 KTMrQCRHHzHxQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:40 +0100
Subject: [PATCH v2 08/15] mm/bootmem_info: avoid using
 sparse_decode_mem_map()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-8-096addc8800d@kernel.org>
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
X-Rspamd-Queue-Id: 99606C000D
X-Stat-Signature: 9ufe3j1era3nbj3c6ff93nz5n8fqqu5k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774044858-383726
X-HE-Meta: U2FsdGVkX188qM5bP3D9uZeAlsehmy3wirmFozCzv6r+u/IPsJ2BqMPlZ263tmsKFufNNcRZnPxcwNu3fUihyLeB2P5UvaYtzbQ/wCtM08XGGiBJGlFgXTCf1gzeribJRvobIxbFa23Lb/lAeF9qGEvQ/QH7Zt1wGhnLkFDBRF4mfRgJlDg0zLvbrAp7q0MGiDevEKof7ZaVhavSv2aeX5Wh5rxqFo3bzxHmchcTIuhBu6Vv4KUuNJK6tjbQJkRYxpXR6YPQ/rVDMOLL23atNlzqnaJPlkPvlrQdI3a/4vtytzVyuJYDKhcMb1bpN+cK8qC5syVmjVQZHa+kuyNDJFdsA5KdM+bCD4fdHeQyPrmZjj4SdYCg6h9NJJXPCwBS6gTmFIuo+pf1CpGoMf4CehpPxvxZgygHIwqS3sDOewRWy+45R0WbRrfTC/ycveyJbv50hc1fXZA7cfRoHncRxL7NFhq7VrcNM9jKWRRzvozUuC0gJKHSqRGaRlFeZlvfhoYjpi3Z9PL4+wCOd+rLEHRdMiMKSxF/ZZD/JPr4srhvUd52gIOtExlqm1wGv7laUlD2oNL+U5Z3FSTFP12NCvEDwideg1Dp0JDYfcSh5plrUr2bgV7BS6C2nAv6cisTha0AarpQ18X42TV8sdIpvcRcqzCJdQRKNBubD+d2ToAl8tsv8t2FpFE4gsFDhATcGkkvIX+eidT+eaAwihuYuWLJtPtfjzrKftFRnY7VVkg2su7C/fGFVl9LmkAhLLRWHruN61etB9nOKkIS/UWp+32pXT9N9aV4TC1zmMNoCgjAnbvG/PwCIVsmeFfyqPda26lHemYyTho2a473uyjYU95WVRPGIAnchgyNZgO99ITfQIE8XaTs3KWq44vWwof+7xeU77X04XFCAgMaWUbBhFVB5t69TVQpS9fwJuidB/WxIE5D7H6yl5VUZCEgkEZESYRJzJuF/MBS2mP8HgJ
 kCX4Sy/Y
 C6wipVkgWoaXwTk3aVb5NbBfmr8iIhEeAzQsO2vxBqsEkjcMykm4WTIezaswrxjE8h74/LypYSaF8oj1S6YOpGskKrI9mGbwyO5bUXBUmB++69dC/miJ4tekkDn9BTXl/GOLXRtkUCbxafcbrl1C6w1sLjx+SVyudmcWR3DT8TqwSStIwpdZmnKppDGdl7Z9Jm5sbEBEsowAujGgolmE3mdWnDEmAoFvxxkILc5RV56R1U7HDR2EtkPAxkCfl7w2/ekhmLeCpfpupflU5+ksGYeMhmOaFDeCWLZTx/cb6DoCci6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With SPARSEMEM_VMEMMAP, we can just do a pfn_to_page(). It is not super
clear whether the start_pfn is properly aligned ... so let's just make
sure it is properly aligned to the start of the section.

We will soon might try to remove the bootmem info completely, for now,
just keep it working as is.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index e61e08e24924..3d7675a3ae04 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -44,17 +44,16 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
-	struct page *page, *memmap;
 	struct mem_section_usage *usage;
+	struct page *page;
 
+	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
 	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, memmap,
-				PAGES_PER_SECTION);
+		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
+					     PAGES_PER_SECTION);
 
 	usage = ms->usage;
 	page = virt_to_page(usage);

-- 
2.43.0


