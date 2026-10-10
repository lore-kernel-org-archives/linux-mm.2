Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F10CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 20:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139016B008C; Sat, 10 Oct 2026 16:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111806B0092; Sat, 10 Oct 2026 16:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F8F6B0095; Sat, 10 Oct 2026 16:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54886B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:42:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 606141402DC
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:42:26 +0000 (UTC)
X-FDA: 85307889492.11.719373F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99745C0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:42:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RmLqUv8s;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791664944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaeVwRqfGMljaxW8Ah6Cx9zT6uiRBSSC1dP0zE7Q/ko=;
	b=yW4Lmaze5YgGbMWjZnqX/GaCea4hKcfvLM9l3imlkY2Pqr1BxDqZpjYH1gSwiJd83Ys77Y
	Xsx6hOfWDFq2JNGd2nnTTDVCt/XiPHpvTgZPtyFK7Qj7JEEpdimXI7BlZYYAVrBmbCKv6Z
	BhqnveYTnvh3/YsMAK7bMtx/AxVvFYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791664944;
	b=qSxeNdOv/RoF/OYU9lLADFfl3wD/A6EOsg8Z0XNBXLxqqLVslOlHxl0Ee8YxW2YqJsSlvD
	9Ufadlgx2IwnmWf/zLYk5caTU0NGtz2jKxX1TKltYZnELPeu0QFFlUw87y6TKFdxTWwxdi
	o2Co5jIpSuSUpInWO7cgUGyfGMzJfcI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RmLqUv8s;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5CDB602CC;
	Sat, 10 Oct 2026 20:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A691F000FF;
	Sat, 10 Oct 2026 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664943;
	bh=KaeVwRqfGMljaxW8Ah6Cx9zT6uiRBSSC1dP0zE7Q/ko=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RmLqUv8syW5KCaLrBRHaqB+hdxZmebnLFbyFQcAzsE8K8GyM/v72kmzM2p52+uyUk
	 JY4X3rsdpU0z8m/Mytez5hAFfN73+lJQkTAJ2ZdwOIQwtDH7dUz67d2wNhBrUxR1xC
	 zb3jPxE5vNJ3UNmy+gKrU8kH2wFXF/E3KA17J4EE=
Date: Sat, 10 Oct 2026 13:42:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport
 <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy
 <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, Shrikanth
 Hegde <sshegde@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, Lance Yang
 <lance.yang@linux.dev>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
Subject: Re: [PATCH v4 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
Message-Id: <20261010134222.b6fdcb20d8fec5aaceab66ec@linux-foundation.org>
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99745C0004
X-Rspam-User: 
X-Stat-Signature: 8wx81rfzxg7qameeoepjbrmhrc3k9umr
X-HE-Tag: 1791664944-609422
X-HE-Meta: U2FsdGVkX1/VBkRI0a6XRzuE3v71chEFbgBUM8oVN3N7ieGmxpCIpo6JUObAmynAD9msMhtUbXoXUDro7TD+SrjQUI4rRLeOHDa6XCGoavBPcKcW0NXZECxqpPj+twjQ6Jn2GU8d8i2hehTN2o38v9PuW8C0gespcv0sXedvFNioHCR6tCGbS+nyf8ZDC3kTPk+h3xdnMi/BFY8GTT5/wJzrRwsDOippE4qywB74tWscAvKX54LalUXxEetQKKrx2h0en1/IiMEA1v2BhHMkXOj0mmiMTBJ3yLChMwyyOdrc3npinHKR/M6BZ3uq21MR42vWNGG6rWeLRD6XswVScJLveO3IDYrdbYoVEtmvcnfFlJt0BZZCjQN00rZAxEewNR0br3c3vBzj5IZs/l0aNchfuqJ2J8CukVfZCoQIcHlxasNJcCsANVyWToxVFIKqHNcr6h4v4fF9ycRH5oWaBqZLMn4wI570YYuI9G2aOkqLulpMDna4SpAKoqzox5r552JkV0k/Hu+yDv6Zo4qyVhzdiMubaGcg/zoWtUpsbGJ9LD/kgpIogZ1CSk4dny50+oQE0y4NJDXvTpq+FWfEpOH9N3HgGBbIiJTC6m2K3c5J6L1BHST/Ba9NurCk2ORCvZw7lgnJzxUOFtmYLrxZz2XmcF1+sYRlSejpSya6ToLNnL89g2/zQ8mIM8wOFhcC9fZmzXzWPJRqKt9vSVvJBQKpRB3FH1iVkwS8UvnrFMrW9ILAgYdYCDzNvts/aKTnTrIZ9N4qIBnrdogonB/55961xT18aQXAwTbcsk0G4dJwYQvdrnkvNzUTcxeTNgrQ+f/DY1Q1GYge4785R48DC38CtJEqXjNHE99g+uHzL9IanMcVFN4grtBNaZ6glELNuw73q07NGNdkaaAvfD94VYdsA1Z+5L68bjIaMfjkG6TJxtZq8S/8Hr1bIi8cQ/Zts5OxvG/ALww6l6ihJ6c
 KYg88DU2
 PAAty/3WnTcucAvZeepvXfNIF594E1ZYfn9IHgnkXKgHky6/yro63YaWqlwdCwD8Q5njF6Ih+lcQzbeqQnls82gO5pdXB8pmnvFVtf9b6cqs9BqwZecmQxSwCDtoixYvGOixxehVrY7g2Nm7m8pLF/YVCWnYSMOmYPHKrHHHWJY9ReWwEr1drU+tQa+jU47Nypo8R5Ed66hb5MAkhCeq1F6bVUYthgSwVHxGaMcmQD4UmtwGP/DkxxSmttQTSqUODMyI6Gu1dZNl8WN/04gjbr4/qI1jnNZ8WiLF8cmsJyJVn5suDebL2JHjO6+7KihEEYcLxbLptDZzKo5ieZUQ5EH3OtoGlbRW9lDtx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 15:57:49 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This v4 is based on mm-new commit d5207c6d152c, which contains v6 of
> "mm: Switch device DAX to section-based vmemmap optimization" [1].
> 
> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [2]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: unifying their vmemmap population paths.
> 
> After the preceding Device DAX conversion, both HugeTLB and Device DAX
> describe optimized vmemmap mappings through memory-section metadata and
> use per-zone shared tail vmemmap pages. The generic code, however, still
> carries a Device DAX-specific population flag and compound-page population
> path, along with arguments and helpers needed only by that path.
> 
> This series first removes VMEMMAP_POPULATE_DAX and moves selection and
> reference handling for the shared tail page into the common vmemmap
> population path. It then removes the generic Device DAX-specific
> compound-page population path and routes section vmemmap population
> through vmemmap_populate(). The powerpc radix path continues to use its
> architecture-specific compound-page population implementation for
> optimizable sections.
> 
> The remaining patches remove the unused ptpfn argument, open-code
> vmemmap_populate_address() now that no caller needs its returned PTE, and
> add a warning for inconsistent zone initialization of shared tail vmemmap
> pages.
> 
> This is the fourth smaller step toward the broader HVO generalization.
> After this series, HugeTLB and Device DAX use the same population model
> instead of parallel generic paths, while powerpc keeps its
> architecture-specific implementation.

Thanks, I've updated mm-unstable to this version, including the -fix.

> v4:
> - Rebase onto mm-new commit d5207c6d152c, which contains v6 of the Device
>   DAX section-based vmemmap series.
> - Factor the zone mismatch check into a local helper as suggested by Mike
>   Rapoport.
> - Collect Reviewed-by tags from Lance Yang.

Here's how v4 altered mm.git:


 mm/mm_init.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~b
+++ a/mm/mm_init.c
@@ -593,6 +593,15 @@ out:
 	node_states[N_MEMORY] = saved_node_state;
 }
 
+static inline void vmemmap_optimization_verify_zone(struct page *page)
+{
+	const unsigned int order = pfn_to_section_compound_order(page_to_pfn(page));
+
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(order) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
+}
+
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
@@ -609,9 +618,11 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
-	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
-			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
-			page_zone_id(page));
+	/*
+	 * Shared tail struct pages are initialized during vmemmap population,
+	 * before retained struct pages reach here.
+	 */
+	vmemmap_optimization_verify_zone(page);
 }
 
 #ifdef CONFIG_NUMA
_


