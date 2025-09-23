Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70B9CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120018E001C; Tue, 23 Sep 2025 07:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D15C8E0001; Tue, 23 Sep 2025 07:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CD18E001C; Tue, 23 Sep 2025 07:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDE4B8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AB4D58773
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:21 +0000 (UTC)
X-FDA: 83920238682.20.509FF07
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE4EBC000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="S chjqWK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f9y5kwR3;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wor6PRx1QN3N2Jn0DTyxYTrVkZQE63Z4seZ89Q90skw=;
	b=HKYfEQ3iSCdY9RRcg0RTuG0sdy2MtdfWdPkVpNHjzaH9pAvVsY4DGpbfeeQNjlMkrkPee8
	P0oYaPyEw3sjC6IyE8osgNEyXKozhkd5ArM0KOFwzdCBM96V4aG8l3KCyKVExRY//sZWx7
	h8kKiyCMLOUNA8IDj8orSId4rfD5zGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="S chjqWK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f9y5kwR3;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625640; a=rsa-sha256;
	cv=none;
	b=0zKDJ2l6Yb7BqPLKpN6ZPSTAJpjd/2torKfvZgVPfOmdoXegdZRgFSE0MCJX52vJHuwb2y
	xNtj1WUIXvbof8yaT8TnXRZGUSYUKLpFtidL7JlwzRn5OBAgn6AINjRKweynnUrMUuzhhr
	CqFiPbwm1NQfE3ur+NeSsDvd2ZUehMs=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 5B2D9EC00A5;
	Tue, 23 Sep 2025 07:07:19 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 23 Sep 2025 07:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625639; x=
	1758712039; bh=Wor6PRx1QN3N2Jn0DTyxYTrVkZQE63Z4seZ89Q90skw=; b=S
	chjqWK+1KSkK9UwLFDRfV4UbDhPO9X3BD2D5KPkGafBjqAFI3/xKJz/aTk4Pydj0
	NA8tel/EghrYm5dSgvT4O8VYL98C2aVZP4nSPIKfEX+udHzUml4EDIbCgLTnWRfG
	kgd3z3zU5SkOvC4xsCtaFh5J7CxQU0j6DWPuT6pU9S2xyysxzJrqVDtS6T1hqJqW
	Q/Z5fDWiT9O8kt0GiCbpqkcCihNVedORTQgSkXi0W9RaYhBCH+IPpmC24thrUnL0
	H7BwERL31sHxzsSeiDYI+JCtvW4o07Tvm/V6kNoseh9adNXhBDtt3ys5ymlacEG0
	GaSlwg9frLJ0SI3u2yS+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625639; x=1758712039; bh=W
	or6PRx1QN3N2Jn0DTyxYTrVkZQE63Z4seZ89Q90skw=; b=f9y5kwR3kWPrmyRjd
	d4xfoymuXHvtf2tqUXImyPDrXKjSEkuYb5HAaBwpT4NKDTD/ludYfoHrkkFYQ/wt
	xeRacKpLSeUonOfZNe5F9Eb47xu3DfrldItqemNchQr5CEGRlM6GZ6vfwhDkykOb
	SJgLfWPz1u3Ilz+Q5jCcrecOHYZvQNKuBLvgSl6/IlYkO7jmMh0CyHDk4a01U6rj
	5KzLRh78MAEcRFBsycWQBdyTZDY1qGKOioTBSexhg0Yw8M/E/GrCDWEljjRnCoEY
	9Uw1BxPcYFrq+fPHb/ojeKyFxHsxGKMSoSrL5AfUzTj/ObUF5XO1XRed/XZAX19J
	MtKmA==
X-ME-Sender: <xms:Z3_SaOlKdvzVL4X0EDxaF8Q0Lpon_jwpNPheSjkeLUcgLBwsSRU7FQ>
    <xme:Z3_SaBz6uytnZ8UWVs0VYfCZN9dM1wmy0lEEZxDmuN55CH5tlzz_gVbgyi9hEQlRQ
    tPeDbZxKUHvOHKCIWdzV-jWp6zlmYxnqusHG_pWZ5G83mkRSjvTKQ>
X-ME-Received: <xmr:Z3_SaCxCcB6BoV4a0n-PqYb_houS5o1C8a_noTg5P5Is-piHGLAfKl2aN2-boQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Z3_SaI-NdRy-dfd4AMhKZRHPS6KsrOgSVcUR1sqwxHukRVRqNjYAag>
    <xmx:Z3_SaK9yz0kwLuyU1j2O-sPY6F3iZV4NWRtJj7p_wDu5xE5vwLqrGQ>
    <xmx:Z3_SaDeq2eaijQrcGMH1zgOATx-69piBg-o1LIxi3CyJfX5Xri4ehw>
    <xmx:Z3_SaOsC7sDcM_9Ew1lSyyhiBJJdu1kJ15xm0wfxviAM3xcXYyAozw>
    <xmx:Z3_SaG560wPYGfp947wcmhwyj1NyQojdEWhdpMlIGqxx_SL4ak993rSb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 1/6] mm/page_vma_mapped: Track if the page is mapped across page table boundary
Date: Tue, 23 Sep 2025 12:07:06 +0100
Message-ID: <20250923110711.690639-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE4EBC000C
X-Stat-Signature: f9nmwy3xydsd9f5hafftjutshuwgfoae
X-HE-Tag: 1758625639-470999
X-HE-Meta: U2FsdGVkX18O+zrXCiOuHPkj3sSrzagGkkiDTFE6lpefpWOquVcscGW7z6Z4nKPM5M49WqU/V3J2yBnvQ+0pHKSH2/8m/3zliVeSz8eWbAi+Mh8YiIAOyW1QV90YpFmbaTfuMHru38FpB7vAEdUUXqk67l8/rOXE1nBDfTzvZEqoA98ZRxMfGGcqoQlsEhcTMNmLf/myMBSNHWAGOWv8Vfcelhte4nbQS22ely5NoEv3OwKlZDW75xUS0+rkZxVEFXhhtIO3qk2m/ahqZweN5HCXs/X2KrKuLIUpq4eTsvsEw0h5T1SLcg1AJAS+2LmLrADGmu3XZV0y424z+OZTqs1gE1HSkQLev6n4Yn1aWeZ17n3ZCFMQ02BMVoeZfWQfUw/m77xp5P2jltlZJU9PIi+EsZuUXSSnOq0SIrsu0R4/h41Fxr9duweilNzhSTtaaPECc/No/ckMhwQnt4wt1lZmDziAZXbScsfDcBa80L3uzhYXv5Oj5+FM7t+ioq/JlRwLvoYnK/AErTvo+lXwrf8pFSxrOPVqSwYj5n9ZLVI+MosWBMgl8nNhr2RNMR8pEh2ha2ZcgBXybHWYnX0mvUZWXuOL734/qOVlZBcndL/BK8dt6XwG7jbjKppFXWIelfHY47wHlnlcTIV8iXxzJsrmoMGlpmM8GbHW2ih5f4ulue76BAqhdHFnM3JKQuI4yFu/o6R79WvEl8Vur1SXkQ9CZ9frwXJMYwwkKQm3LUKCvAXkTJDouQOjfeCNmkr/0H5CI+JrjHVbLZqDWIFcdr3Yiqhn1cqRvn1owcd5VeIsl1YU4Yu787kX6OtxkjOFb2aWpSgsUB9JLzRahQt1oVG16+JOunyWDTGz0hQ4UHQ59P6IHz3ozpm338IAV2esbEXJCoyBbYLvK8el0mu9wZy98kJ7WW2e0YowUsVXbyagE8WnV/m+vZkTYjx2c5gn3UAAGA3mTQEaR8ylTOD
 HhHOODaV
 Xfl2pF6Ifg7iLFqY2kdntJiMFTwMgGLXR+0PxAwIML3jpfn2vuFG6QtGuDA8863+q0gkCSbfav4u6PwWrTTrRdEBY7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Add a PVMW_PGTABLE_CROSSSED flag that page_vma_mapped_walk() will set if
the page is mapped across page table boundary. Unlike other PVMW_*
flags, this one is result of page_vma_mapped_walk() and not set by the
caller.

folio_referenced_one() will use it to detect if it safe to mlock the
folio.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/rmap.h | 5 +++++
 mm/page_vma_mapped.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6cd020eea37a..4f4659c0fc93 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -928,6 +928,11 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
 
+/* Result flags */
+
+/* The page is mapped across page table boundary */
+#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d2..a184b88743c3 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -309,6 +309,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
+				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
 				goto restart;
 			}
 			pvmw->pte++;
-- 
2.50.1


