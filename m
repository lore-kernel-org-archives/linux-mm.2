Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5898FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFB66B0096; Tue, 17 Mar 2026 12:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F4E6B0098; Tue, 17 Mar 2026 12:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247216B0099; Tue, 17 Mar 2026 12:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 126076B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1DCE13A5C6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:32 +0000 (UTC)
X-FDA: 84556161144.05.8DF2560
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 043BC16000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2Vujhz2;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRnU9DXIyIlv2/sLrz8QnCaCihsHeTxtFUsDVJ2Hrew=;
	b=RFAVu0Gpq1mqUU/k10RrxShVbUTp1xdZywu0XPIyBoC7JZK958QrzMpbkoYl7Xbi9a5Bx1
	vXlZRvBlntwYcz38B1PlvrkX/ERwMIoyE9EhdsMsM95X8psAG/6VRhrExHeol2m3G/Q/Qi
	mEQKdtOIaem2jlJgO9qC8zq/oYglYe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766651; a=rsa-sha256;
	cv=none;
	b=BBiNod12GjJvXRXKD9HwYx5gK7/jZshB+ojEFu6kYD2xj9ABPstbVre6IHvAVOnHdSvNMk
	m6dGALbMOZXkVs5mscuWhgGCTcXDQdzPR1lT/z9kWEMNaaqIS7SghwuQ21hif150gWQRwl
	RLNSB/qWGNbH8Lj7C2lOdQQoxsxlnQ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2Vujhz2;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55A3860103;
	Tue, 17 Mar 2026 16:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A0CC2BCB1;
	Tue, 17 Mar 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766650;
	bh=zAVH1p8bTgDOcqmWvthlvGourqrwWep27NazNV4QaoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2Vujhz2LgkspV0Vdwe1zUr0moAccQujcKxybghmQZ6XXT5iXSrfQPoxTPir/ka6o
	 Ro5dnqMDCEFwJa2GKmu+8ThHTiTINRru4qBFl7I2dRo2z5eAX5yxdiClX8uIk1HBYI
	 9TEZDo12vMIKg1hRdsEc6SD2MbIuMAjmXDrLKGFBV3lXZfVZEysQZsWFnQFl+80jbO
	 9U6FAGd5plj1NWSHwynZCMLun5fFMWHYreRqzZ0jaJnHqPvgPCI1Ly3LxJKsZpVWEb
	 qNF7flFZvow1mgTGZN1MwGBMW7oDmUz6b4r9JT3ABYsXaoAwS4HMVMmUUCbS9S4tvc
	 u/wNBLoRqyJhA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 07/14] mm/bootmem_info: avoid using sparse_decode_mem_map()
Date: Tue, 17 Mar 2026 17:56:45 +0100
Message-ID: <20260317165652.99114-8-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cxijk5n8zr8qscfz3fw6fusfe9yt4zw4
X-Rspamd-Queue-Id: 043BC16000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773766650-555329
X-HE-Meta: U2FsdGVkX19lGtHlml3DOL5Kf/EPwKrzz2q59DSmsBnNMfumElPmV43S1xP5Un4T+jDQCWnOqbFUqUkZ3OLoDrtZ6z026tMKMbRQMDR9z36aq3NypwrXD4+mZO1Gk9aaONi+x17QeNXgy5WqcLCj6fbn8jFL6QsAMckeLhhtQ3QEzITeDKmHxXhnJUbhT0Wm07j1ILb0FkqGow//oM5h9pDzcGUH+gl7lDDKSW3znw+6wre06asxhnrP/MEUezVU4oJ9eAFsDIC4AmK3eXNK6PUnrAupGZUOZxK5jjnaPpXvwuSCCy4i5R10+/idKy+8tPzWN5nH87IvSVZcctOSMh2GVhvDvzZuDZBT09YlrR9rwvSb0FNbgpXj+WqPtPX7dQlB/xu5EW294VhcdTdC3Saat5nzowVEOIaHvwILdFcin12hYFOlDK8RevEJlFo7VN3YDDd7k294DpF/Rqana0wSuz9jRhAtpWJi5N0q/qJ9ThKeBQIE2gCtgBbZcmHF/WHouTV9H28iOpjdN8bC4kuvk6xMKBiAn+U9+9Kij4Qsmb7PoGRp6d97T6/EtP+o9X1Qprv5ScwHU4awtC7JzdnKYjC8aJYDJQ4bfajytNXktNk60ru/Gsv1tSkK9W82+tGVoxJiUa0iv1Duu7gERJPueOex7Zd4nOH382xWP7K32udeub2xkT1js19pAqrdy3rU+gZqYLHqxhr805k1DotmnUpjDGpySHGw70296J2fu8Iz6ePfkq/mRzBc7IGTq+m7D6waciFpFp7yBCx/VmzZLjSLRq+6yGQNTqvdKgBeQZfZhrsQMqFNuJgBwdhTek7ic9iUnHJKoyGZNFdY5t4x9Bt+mfoOfMYRYOM+5TPNvyC9CQgtKEIuM9RlIyxJoIt1QYtmwWpPugykCNNsiiQetPAvF8LoO9QjZxpyOrCBHFkt21hkhazDz2KatC1SXiRLdvH4TVcu9Wt1ExY
 F9H39TJe
 WqqIuZXScV6ABVhzXgTUvmnTjhGME2owYLQFISt6cHMB3EAozn2BBBEBo/k+5bynXAVPRF23rLAN53vSlXNUpvGxfNCGmT5+54bznVYsNvi1QeoGg5Coj5U5QXk/zIzCWMfBnHMZGKaxiBbfy9uN4i39G+dgeaNK/m4abhGQ4UChYaU1/S3xsL8+uVAqWsqV9OfknJ2mR2DACAqvvOWAPSYmbxl5jD7qxLaRLeiMwXo9I0lZXq1C5W++rrHMutD1EcYmFG18u8+yu/DR2UITT7K7APA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With SPARSEMEM_VMEMMAP, we can just do a pfn_to_page(). It is not super
clear whether the start_pfn is properly aligned ... so let's just make
sure it is.

We will soon might try to remove the bootmem info completely, for now,
just keep it working as is.

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


