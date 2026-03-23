Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F1AEC01CB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220466B0005; Mon, 23 Mar 2026 07:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7AB6B0088; Mon, 23 Mar 2026 07:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134F06B0089; Mon, 23 Mar 2026 07:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 028816B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:24:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96A571D804
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:24:11 +0000 (UTC)
X-FDA: 84577093902.09.C5139B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB02740006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:24:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPe8iWNG;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774265050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBixKzV5WaBGamiPlT2b4OtsAM393O44Ty+KXOMXXBU=;
	b=QPYpmHTkvTn7jUTkamux926Snc6iy/oX4yACsEc5tPbylAtBISxRMYGjd+QNM4yQsSXBHY
	eEPc/H+5Bph2fmJDSJ6qr+HgSpPJfZEVzk8DgugrZYyEL6x8MWwZ+5Vm/J5CcuszDFjV2D
	WIPjIgvEild3fhkiEl1L4hbyH0iGtmU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPe8iWNG;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774265050; a=rsa-sha256;
	cv=none;
	b=zffMLgNXcc8Q2+1DnkSwu87vhQDKuVQQxjjKfa8GMgPj9wvEF4RAZeyBlApeafQARvlW5G
	4wMhX6iMoHvPb38pKRNLW3Ad2hbThw6jbenrc/mONe2ADvdprZgA9ZMvUjIDZATnRNCBSW
	dk598YtvKJ2BMDzoNMsRzaSSR/CBjhQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE40E40133;
	Mon, 23 Mar 2026 11:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663ABC4CEF7;
	Mon, 23 Mar 2026 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774265048;
	bh=Nai2XuBPZkKTg2eRph7CkHliTUZiCNaTCa4l8yl04Kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PPe8iWNG/AKKXZ6RO/5HsTqEAknNTM+MS3JhSz5vt7/Wp64eqYrLf1R87tYrTT1wZ
	 J8vCc+fvEwXN+QOy6ozE1Q5DLQIRPiXrGqVuV1jSQUreaSeW9VOCF+BpWpsB+IZGdp
	 e9E77Bh0OFDHM47zqondJC/VDCBaTNmY6cbvWZxC5Tku7rCb/btMBjExLRKt51pVLP
	 Oj7QagjSE7fDA3W81KMsyaq6qjHXzrbIrpgLnZE/kzzDEZgjdVJNj2kVume2rP44hA
	 tmPvOgS467QU3Qs10DKeCCEMBAjCGJQr1zibcU7Y2vRW/pMIncNVG2yhVZsLyiCey1
	 YUCJSsfd3VipA==
Date: Mon, 23 Mar 2026 11:24:07 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/13] mm/huge_memory: add and use
 normal_or_softleaf_folio_pmd()
Message-ID: <d0cc6161-77a4-42ba-a411-96c23c78df1b@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
X-Rspamd-Queue-Id: EB02740006
X-Rspamd-Server: rspam07
X-Stat-Signature: ypeynkho9no4esh6k44dn38w14xtk3oo
X-Rspam-User: 
X-HE-Tag: 1774265049-215840
X-HE-Meta: U2FsdGVkX1/Quce4qlx+JKTQXtnQet6Dalph/N3c7G1Ieu/mVTGUABBvU0PVufs9rP5UWbgY5URv9xueNru8LPeNl1uca9tWi/wUgHB7L8bHTfZ+gXSvHiy/+p09d7ce9yzHzxto9K8iE9XOLq0mBbcRkuyF2kORYLRhqj60vl3QU6Opwc+5oztkAQF+vpMRpB2gU52XY6egNvl9QhprQ6VirFonc1Q679vwv6VEoHZAYyLCyD9dYC2DCQpIvhd9zi2f/zQyCmdcUNibImrPUAUigCGKE8yDbkSdGeWrsKRMdUEdaXMU1Io3cd12XODSxnUiV3GjlwojZv5wY/XA4yTSBfgXWUhjf8hjPDPuFuiphP4ZQQztO0OgJUQ7lhpP5RE4ttpdDBY4B+nFd9snfka5rGGOp6SYKiJANMZjX23nzECBtWgJlnU5x+DrnIjRu6n0EjA1uOSaFp3f/q3Q7Wqq95/z5s3dzwdMXGCqxALDFIVWa8YbXVUASMJmAcPWESqqQvcbSfrFBjSytZ9pd0ggvaj773RpXvoHcvAIZj+/V2ADnMUwTTK9n4HpKZ0NsfSfSR9nH/M68zPr097erypuO25/rJ/jo2xaW6MQ34F2ZkdYF9OPs+EqujDjySySqMvricy7pEuEOoN36UEKi9jHYyvi4cpozt/FGCyQ3YrBO4lc+q1Y5f+02zscpwAekj0rTDVsIZvpkKX+Pn6GgGdMOvyX+ylVXbqUFNnUM2/YBaRUcWF0yME4Fyb6z2fRfD+wg4MukaSN4PEXdlPdL/IiIlRuyv8Dh1AZzRQ1Ht/L1uHOLcu3X5toFp7mVTMauZ4UYzfF2ETfClVmFN/dXQfD8hSsaK4sZtys4hqNQTN6i20bMP1+W5ZrRNAdlROwHkigRU1SwOzrg2GK/ALcfNYZ5AMWpUqMXLG7SmDeqgzC37PqKQQ0ChjR6BoWQoSahOWRbRS7dYQjgsfda7Z
 36sEFhYh
 vrYNJSVfUpeQpTvtVYWa+K7Vck4/+eElvTayk+Al+PITnlinR0YaVZ3HwEzRzeo0MN0WTO4LN939n93rfJ0jEhvjV3lm0V0QQ0Jwm9a2l8z5/sF4SiOETUK3xXf4sbZDbvO5o/Rh08TGzTgQU+QnCpNNTkd6IzzS1BBpW+fzwYuKua6Aqo7Dhcn4Z/VWCXF7TkKIiCtN3XczulOrpdU7I2NYbUTosI3F3ULAatkQ2IMKMt9EsN5C4WVEDfWpU5DYiFDRlJevvJd0oyzUCUI+Ad06arm/EfQZXsM9jufpGChgauP/xWvsepmtxrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Just a quick fix-patch for 12/13 to avoid a bisection hazard, as per
Sashiko. The next patch eliminates this case in any case.

Thanks, Lorenzo

----8<----
From 7c5c0a66517efba0e675e707f931cf8a3f1a4d87 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Mon, 23 Mar 2026 11:22:32 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5831966391bd..5d5d9ddca6ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2404,7 +2404,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
 				  &has_deposit);
 	else if (is_huge_zero_pmd(orig_pmd))
-		has_deposit = !vma_is_dax(vma);
+		has_deposit = has_deposit || !vma_is_dax(vma);

 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
--
2.53.0

