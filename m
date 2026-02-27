Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74358FD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395A36B00B1; Fri, 27 Feb 2026 14:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7BD6B00B2; Fri, 27 Feb 2026 14:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFA46B00B3; Fri, 27 Feb 2026 14:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAE976B00B1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:31:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB64713BCA6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:00 +0000 (UTC)
X-FDA: 84491229480.03.ADA696B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BCFB240002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rSFKLZSO;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=na/s6YTvx3ACmWYUOvZzc1E1/1rh7evlZu1iZranVi0=;
	b=MbWMArKLBKbpaNMQA5WBqmMSZdzXOiq49eczpchCt/wP3sMfwCcTaP09F6xqwKN2pdBY7h
	KNH3GTwC+d+bnMO/bmoP+J0NS8typyFVnIukzCKQrGfQu8hHPqBjrfpq8DA1mk72zUAa/S
	nj92FMM2Z+sqBmRWOZEMvQbDXUc4OBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220658; a=rsa-sha256;
	cv=none;
	b=7Q5nOJQsQddv+WKo9Eb7yA9kc1GXODpQ0+nrz33phS7TqP2avg3yvXRFPis2FDT6daH+pu
	op8ADn3PyzOEqqNTe8nFK9MxHbyi5xI5ZzaYd6fZR+gZJYaHWeemXbP4E5QgSfeTJTnyW8
	NxDFz1fpTETJrRS3XuAot/xnByHwSE0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rSFKLZSO;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D43B6132F;
	Fri, 27 Feb 2026 19:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51033C2BCB5;
	Fri, 27 Feb 2026 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220658;
	bh=A/jdrFN99nKynIb0vG8N4R+NM5G2b3V4kufeAPBCD60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSFKLZSO4lWNGXCNUh+P71xmPX0QUJ+Ec50/tflmgMmdHcKLvW2ZyHl+titnnokPL
	 R5QYlS+hePIWpXIzDfqwOxBMyvNlG1Olce0X6+lHrQ8eAdbxdE0ABbuN06hqnRUPXp
	 ctljm94E8HvfrdYcmrwFah9Ywbvz79Hcmun44//EQ1cr7L4dvjF5icijxfinbp6Tad
	 /Lw3sYyx9ekAMhrW04pHrapa1WWbv1wSNldgTE7prF2jzerqRtZ0Fnk6JFnI134KVA
	 ojiJzARawguIiPiRdxhKqqTCNg4vjGbve5HoXesL+ywpS4hk/oVhtpmG1COcy0uRDV
	 EPAUylQWgHb/A==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5E497F40068;
	Fri, 27 Feb 2026 14:30:56 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 14:30:56 -0500
X-ME-Sender: <xms:8PChaZaOML7DnqKk9wbJroYEMmXmn5bei91FYjAeKIqX6cB_6tuy5Q>
    <xme:8PChaQhaF48LZ5ibdipJC37JIn0b5sg6VosCYHjt3k4BRnDVohluzT0jNRWpKfXds
    K1HiEk0NY5OlkZPZOA4wxj5iZ2bnaEfQC5xmyb4uQ3YIlZCTu3vpAs>
X-ME-Received: <xmr:8PChaZzjCtLpNPvWxbmuYifA5a6CZAsY6EaxQbWkmZxF0VeqWsz8dwtDK9d1AQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:8PChab5Q5ubHxTjE4eMFCo9fIbZBg3kNGVtJ3_Ocg8whekJc015keQ>
    <xmx:8PChaS3D3Mnr1zs4ezyU8L2zUhjZiIqVZ7vUQr3iq8ZMfNIXN0W-sQ>
    <xmx:8PChac17W-1axM76apyfLKDmhBJNGe-628AZscCMmIS2hgpwpIcnUw>
    <xmx:8PChaZcKnAvvs-jgxqV4_TPGAB6wMVN4f1yt7rPQFEj6RZuKTIJM-Q>
    <xmx:8PChaeItu9EjeEMwTwJ9y9rdQ--Tb0afpuaTlWmMoof32ZbOipmQRjWk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:55 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 15/18] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Fri, 27 Feb 2026 19:30:16 +0000
Message-ID: <20260227193030.272078-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCFB240002
X-Stat-Signature: ct7f11wkjabcqaewe4t955k35bhteq7w
X-HE-Tag: 1772220658-78171
X-HE-Meta: U2FsdGVkX180tjJpgdVlHiyU/o7WoIsD4FdCQfdgzi/2ZElmIRYCeRB1/hWqw9mKYOJdt3LDHhAaLUWbprNqUjfqcsbSOBE/NOsO1xg0IIGafnwjlHQlkCfp+5MRbd9v8XbM6wohqxTw5Ct7MF/+cnQahex0g5qkBD87+xq2UhZUbao5Ci1BLmTolvxSNu0nOPc7rNR/4B6SrDft0DpTgcmOtOUVOeWz1ns8GgMIcUX0OVOwwEjaOBEHy8RzrQ7fQ1y18WnH1iQxUwvqv1ztecEA5rfwz6bK4bRuJVrMYHsSs4VrIJ7BuEtETSTkjKxNn3/grw2HkECPncVn5GNd4bnp343wlHOGJ9z45Og7ZtAlRbKaR0t/3fihSJXVzSEbV2VQBADz5RhaR5zYe+YPLDfiQabYQhgHlxprRIyrkldSK8abLeaKEaMDdBIUBcuZ50DjfBXghduagvt7dQtbcsdSWYicyZPnk2lNcO6KSrF4okY/amp1S4FOnlb+t/kdXKfjNS6HPH5SImzGdp/M5d7xVUcQGs/gCCCkHPt25zHduTCW6JKeHRCogm8wOU0E8BcbOwx50NUcUSUgUXoUZbkJ0jlzftEt02qBSG7Yj6O0IutNHH0x5/e/Zs2Ecj3CQkifhTohQmmY1oCcqx25pWdyAhacCxl+oq9ZkqwjsGtUIw1sUMc0l2SYfiUBqS0aYBIj2rtpRv+pZJyERz6Kr5kMBaYSp7fbnK5R//H26UOXudb+tjmMPkdIQzO0YYkCRjB1sko7h1xl95LlQsuKKCbnCFQLEt90kFuZfDZM63PLFZT9rBW8BZXKVO0jLXdRXq00vyJkwi5k7uY9Twa/4/XvReX3jlFdITGflcVjeAr99Alilyz6G5bOLWo8hAbAJ7IvQXIpdxPodzsUeEMv+SvOhMH03QE7Cwe70CohJt/AD4yVGbtnLzjfEa5IRAh/CWprS9JzGXTC125EiPn
 Lu5bq3fX
 twJ+bwfYjufXDOuzIO7nt3z3szzvHg3M3Y7TwsO5jNeYt1BJkX0NvOeTvOk/DreQLKqB82FfCtnDTHAbQ2+epDHQqViCbvHCvjVOcW6sWDQ6ypKZvtSPq6jqdS38zu49nY8Ghg3oRDrUkTAbA/XBNfufdyjDqIFpl/WlavjTuFUnUMHdzqkoedjo+Dmya26isWrzAtmBeB93DXxGShXvHs6damPESVTkmqwmR1owQ4c9MF1Q5X1txCx5BdPY1NloB/TzBOMgPECJsi4eUmYOdV45DEes0m4tU6atijiB842ifhghU90Z2LCV7Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The hugetlb_optimize_vmemmap_key static key was used to guard fake head
detection in compound_head() and related functions. It allowed skipping
the fake head checks entirely when HVO was not in use.

With fake heads eliminated and the detection code removed, the static
key serves no purpose. Remove its definition and all increment/decrement
calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9f22e4f4ef9f..8716a27ef347 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,8 +221,6 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fd1d5d5d12b4..4a077d231d3a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -385,9 +385,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -419,10 +416,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -544,8 +539,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -581,10 +574,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -650,7 +641,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


