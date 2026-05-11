Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E903ACD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1016B00CE; Mon, 11 May 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598E76B00D0; Mon, 11 May 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D57C6B00D1; Mon, 11 May 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFE86B00CE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:06:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFA9314015D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:10 +0000 (UTC)
X-FDA: 84755313300.19.3E75AA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EFC3C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FkHD5Qko;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mKTc398hqCNIyVV1mxRFzypz9k5PW9K0UCO/3rhqKk=;
	b=SdzVrutfNwOrGBaNTstXiLKljlM8hHlymFiE2eK/UWu3MLtKk6MP8Yxy+UDEjIyVfk2Nr/
	nA2Euxi7alaGtHBCkD1ox6BWN8AGXuDcWf/Ri92yCa6+/+8eOaahmf4JbNy5OS9S6BFxZ8
	ZC8nv5+i+anFiWxaaMP15Z9rhmFK1fQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FkHD5Qko;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508369; a=rsa-sha256;
	cv=none;
	b=0ykhiCtdlULXNHyhs9kjv3i/Cx10xzuwsp+6y7qeXqAYtf9AtMzbMiD/T6YJmgFoXk32Rx
	aDQMVMXZeDv5bjmZ27N0acyUCCO1hJltAdiIb9wqDOEY55gUn8hhhgIxyL/ASP+wFUJxQe
	ZwDVwHPZMZ9GKdUg16r3cQfQcIX72gk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9971560138;
	Mon, 11 May 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3134C2BCB0;
	Mon, 11 May 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508368;
	bh=Df7YQtlt1u58ew8l6Y3LcE6eBp8Ob9c95zjKPT1feMY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FkHD5QkoYoiTQo6rsfptPtJyyjVmT203uCGrdm3RY3TRoKsGoRzuEBRzTLOM/MoDg
	 MayWcxnF91mKM6xXDqXD9sGLU9DDrFF/Wd0FcMZBhsbYliBwps+T+lJ6mRl4OaaReO
	 AlharA0hbNn+y6DBkFP+QQAyvIrUPUFzFmpPv9Aeut02HsJDMZ8DCG5+AYe4QiH1Jo
	 8RHEPoYqRTLWsqkE6/OR/o79ST9ZtLIw1kKnllAjVgvLKKr3BbYRA+dtRv8sj5b0ws
	 pNwKalE2Qqrlt/eCvy2KefMfl81e24Y17AgpykKyxL2jc/Kn4MflcxXJ6feg6RoApD
	 oitkf0c1mdkoQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:34 +0200
Subject: [PATCH 6/8] mm/bootmem_info: stop marking mem_section_usage as
 MIX_SECTION_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: sne97jciziw33nd943g8edazz89c957g
X-Rspamd-Queue-Id: 2EFC3C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778508368-918315
X-HE-Meta: U2FsdGVkX1+CiGiUsOMQdrUT3XnZJ0aZLaqMXv/4npycjPyI2rMKKg4pYPiKu/jYnK1GIxhbeNLMwySTjUC/pYA4MQgqJyiCvBG5LyjUjnSTS1f1ywPMrCgySSrvs6hwmqhNHhBVxEOY7gZhWYs1zIFbPicp6LrLL0KrmxtrQ6Soxg9oNSHC+U16Qt+g1tcxjHUPVC6IqhvqujWBrcJDGM0C5EwNf2Q43NASY8HArFIihAadl+PKbU0e8GaBo/JZm3vNlc/FAopz7omHjmZAvEj3ezvGzXrXuKIH4ETK2GteBPf24Is/AG/oGlUaCSmcdXxusafuMXCbJc1A3yZn4aBS1/Y6+TV9HtJ0OCPs26SVlYlXX0b7bxBRbdV+jRvsSA+nQgxvxeUAdUV1V2jXRTBT8Pig6SmWNGpbyJZt1ZHFH7aWIgwUf2YtBRZhI8jIXbu261/osrbUemhkMTJOsmsgYdP+0IPJ8ZtzosNs2QS0SWw/n1IxWrBpsnUJ/mofUZ9QNVQMc2o3/JfbKNMCzrau8zAzbW8A1KGBGms9CWXfFKwhU6BtExFOiY1WuMH9AVNh7gEjdyZI3/SU4TlcDdnqT4HzI/rTe6F25y62scZj+JoZopnk3UAiynZQAAQOmsmTIb+fdbISEF6HpYsnLUU88Hk0xzkT4vHqmnKF/kGtzKtRXhwNgYfsiH4fkKT1v37/GiP9DgiPKQA63Xc8JK5Uc8tnh7MPe6RKy89auyI4503Yx2gWUxvmWpyKPiRT1WUxOcg4YxCkhJP0NjHOLJ1+k6P8x4HPJ8d68b9gzqpFR3I91ka13bhIl8dZO+PfReG3GaDdBzuLB2KBSND7Y73ERu9/HE/d1eq8ET68wC6jfPvnXUCMoHMK5odPpbJ+ud+GhdSgrbM0cc1Z6IbSaXyurNvEzSwcjEhgrsJ8oYZ3jXElegY5/KBJIS9ckAPZGwoZWxQUsK/IrVrvE5Z
 0xNq7rn6
 9X2RbCLwrSRgX/515pgU/8BO7raFdDOqmhfRbSQ1ecJPjRIJ2itEozfSSz2ZRrbcYT/qlMaQOGKYEHCcTRtwzM/wMshbed9wyTyceyacRptqh235Wgls+/AKKjNmBiKr/X/3CHHcVjSCrihjK9QHZ5HW/cW7Bv3Z+HntRduhntFlgkFcLfsGaduKcMZOzK0VfoEBDzJBfL6aiFdpRM9JuLLB0C1/e6CYVoM7LiKcTukITSdp9tpUNm4fb2MPqSOWLh4L40mhY+JQCt9OPyFb/ohoYSuKCMljVIN2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We never free the ms->usage data for boot memory sections (see
section_deactivate()). And to identify whether ms->usage was allocated
from memblock, we simply identify it by looking at PG_reserved.

Consequently, there is no need to mark ms->usage as MIX_SECTION_INFO.
Let's just stop doing that.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index cce1d560f094..0fa78db7fbc0 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -38,10 +38,8 @@ void put_page_bootmem(struct page *page)
 
 static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
-	unsigned long mapsize, section_nr, i;
+	unsigned long section_nr;
 	struct mem_section *ms;
-	struct mem_section_usage *usage;
-	struct page *page;
 
 	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
 	section_nr = pfn_to_section_nr(start_pfn);
@@ -50,14 +48,6 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 	if (!preinited_vmemmap_section(ms))
 		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
 					     PAGES_PER_SECTION);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)

-- 
2.43.0


