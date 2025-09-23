Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D869CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276EE8E0013; Tue, 23 Sep 2025 07:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE418E0001; Tue, 23 Sep 2025 07:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B2F8E0013; Tue, 23 Sep 2025 07:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBD728E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FEDD1A0321
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:23 +0000 (UTC)
X-FDA: 83920228686.20.13B38DD
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf26.hostedemail.com (Postfix) with ESMTP id A24E2140011
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X 94OxRc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=eBykFhZL;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=;
	b=IFrTFGjsoI+91wXG0inJz1cjQWnrGSi18rx5SwtGwM0ZZFwTIvoIEhj+ybC6wESpPoWiw0
	ST/tVFE+R8wegD8iLXhh0qhU80Pdy9Du8bGJf67zr4/gPkKo+ECEtDUmWvvASOq7EpMh9t
	RkZf5W8hwjx1bWnED6sBmDJF46ztQkg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X 94OxRc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=eBykFhZL;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625401; a=rsa-sha256;
	cv=none;
	b=RrU3Bghcy96rPCTAVXA4tf3A3t7o5pneqR6tYZaz5FZP6Dk986jOAwKokfw1x37p6znTO6
	f0jZTiXzdAuCd761vq2aMQdy08uPFl+VhMxVCATZJAvy8/EGqESUCRH3CwT6HQTk+E9mEe
	ceXirPZ/Z7mZM7AlRIv6mDiWsZGJxVI=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 13793140007F;
	Tue, 23 Sep 2025 07:03:21 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 23 Sep 2025 07:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625401; x=
	1758711801; bh=BDBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=; b=X
	94OxRck9RS3KXkLR2kgprjzcjR2TMNPXUrpCff15/MeG3qjwC5e622rJ3fpKHdhs
	9+asmgb0zhY7IX7Ck0dG4w5SnIfuh2/G+v+NqNl5c+s5Jpz32JVn7Rws+F1fszDg
	oVPUtP/0taH+vQs5dI+7uWH2Osh2RRHdM9Y190RPr4AhCB2FGJEhgPTej2+RF1A8
	Aj3pdGm6lzGIBc/crz1NsHHkcUOhYs8jkv6KxWVRfZipfpP3vHMlrQN0zlxxE9u5
	H5nXk+GsiciJ5LFP6dRl+oGdJy1MEH49sXBBPyD5o8y19D2V96nyaKPk2xtThu89
	Rg65mVi+JhShKcqtUb/yQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625401; x=1758711801; bh=B
	DBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=; b=eBykFhZL/pnhgwzO6
	a0BLPrLSjos+DE2PcwOb9kjK8H0CQ57EunTyPSfwI3Ad2MsNxprbjJUfWzDR00hx
	HP2OnZVn1FXOjZ2DRhmqA2Tft2UZ6ZowqItiSBUe6nAOvaWzBAnfEZDKQfpJsKoR
	KAxydWbQfKGUdq7qp9OhmkjZakt/K2TZhETisaqg7D4RxL1I3Cgo8sbJqnfP9Y9M
	+/5xDPT8m99Kl/AbzHYwIaT6DXye7uiRk1cLL+cb8AXhAL1ocpFrZOPIiED0VoFC
	6EbfEX5AFNvt9j0HPFRyEK92PFqVbB0193DO1URMQgakrEoW5Lc7Zx6jgGQGgOKH
	jdQ0g==
X-ME-Sender: <xms:eH7SaEEnBouU8viGPz3Xt_tAS6xuib4V6q6OGVKV8nliqpNU7iBHIQ>
    <xme:eH7SaJTbE5CPLWPozq3wuGgfIkGwJJtHMYLW7PJ4RIKpKWSZ3YUYsBWnQl_MS9ZQC
    U--FM9mNPPzuxpfNwDbQ9KlH6IpVx4H5pgXKcpFIJzJJxTVmaQ-yAE>
X-ME-Received: <xmr:eH7SaEQSDbdmbPYgKJOVjnz5DTXy-idgGla58KT7c6dHaAMTSyoKuYV-CemOWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:eH7SaMe3T6BWg8MY6sGH2CCqC4iHOBXQPXR089cvix5oJFJeR3ssaQ>
    <xmx:eH7SaIe8QevXnGJyqPQtgBBDKAw3HFXrnzw6BwcAXYdGqJVj0LkGiQ>
    <xmx:eH7SaC8r-7WkGxo-RTNrrc0lV3LFD1IYW92nGuQZHyjX0zEvydtjEQ>
    <xmx:eH7SaIO8sAC4bkh_nT7UPOFSlXhHvnKCtpHQuH2lr4Zarh6wngMWDA>
    <xmx:eX7SaGKy2F_9OJ82Xz3AodbFgkFVEbFqEZE10d0UKLiYX-M_Kidkzy7B>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:19 -0400 (EDT)
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
Subject: [PATCHv3 2/5] mm/rmap: mlock large folios in try_to_unmap_one()
Date: Tue, 23 Sep 2025 12:03:07 +0100
Message-ID: <20250923110310.689126-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A24E2140011
X-Rspamd-Server: rspam05
X-Stat-Signature: 69gfgy5q5f1sabjszjhtxqhuz6jafsxh
X-Rspam-User: 
X-HE-Tag: 1758625401-895595
X-HE-Meta: U2FsdGVkX19hYzMro9DH+DNl9d/i93OHGaN1ygEbPXnvessgn2xjNOm/hDVwi2DSyH/r2eJtEgNKRIKpYA2g2a6bm58ELt32i98YUyqoQEaCnc/XeX3XpX8/kA4SsT0Jerv3eQmS6kF2PCnhaK5vI9NeY6T2ZVT0VxvMakHQ1UEDlKHULa0ikP+9HIzk9WyDmYNuETHrh8EenHSfN2ve75JLlMsikkIcea5aiQGXI0VDmIhqjWewK7O7Mj/S1MBJq+zZDkd7Er2C0MUFT/c4BPRtN5rlS0nvEj40rJZTr2nZGXJ2lZh932+PoA0egkhJnXnJtZ+E+4odwZ4nrl2jy6+M9xVJ0zubusZ0ho5PSHrNYN8XNKwcLgh1mWSl1979w4f67yweiCI0/vrLQk/wCLcqPlAS8keQKwAiZJozk0hrgCzPWSc1ymgTJG3Sn7JPqc2PGcZCn9fnDxD5q73jJEtExGwsKu9CEhRZcIOwpIuBnlvHql5TlqjHsOuD1to95btPH5EyEkcMuewcrK5i58bTLv4k2EIzPqS9CFNataBDjGMf1NSZgTNKLAbRk1rXAq+6Vpy0MNPn8zUgWzPA57SI3It/bMLMLSy8fw0Qarcttn+n5YuxJaBSKa1+oym6g/dhZE8grS95oueoCCcW5we2fvyudlvqGU0YFAu8szNdNDlNWU5RoKMj3vWmOv2myvAgqQ2xZYhs/gTz1tXFj+d6YgvDhbGq61AZBvfJs75TYJCron2PknYGpQyJPifvlsyWEoGIWL97PPbdcOUq8xWEBAQm78gzwT28yRY88agJz5kBVtULaPTuoRW4rkAEaeEUgyWUSy/yWN87QrCrKTSG8AAFzN6IzNYRiQanqbNlC1DvZZi4+Qn/u9iNhQopTQsPY6z0q6aL6VfQ8RIQjWDRHhV+NSNqLmOcyBAbP2UJ/v6tF7TxT56NTxKWj+/SA9N1zOCvVRT3GGm5qU+
 waprton4
 OBbotM6TFZiK5rv+EBZvKRZZaSBj1ieEAZMBHV9CDEMDtKXlMZD0xcI46b3pXKmGXcRzOJDJg9iIGKp5jqnlHu/v64qD6dTLFzFj87GnWkJA9+2E31cxX6XEnilyPRBvaSJC8wE/tVEBLnxUk2XoizOZpPHnpLmmW8Kn0lgiPder6Kg96yUmFKRMut9cuDC4K6Wgo+h0JeL9OQbLXmELqUvDcDt7U7XtYtyesX0hjeo2//XvURtiYkQgpDP4YaQo0DIJXW8NQaEBMC4PFwjz1jeahDJarOVy2fXX8G0Egwt1URnXVJvgkzgETPi414ARp2xUBUIFaNqifQelOc5QaWfr3Np0Oje6tIEwAvNvtiVN3MEo//mXALbCul8GGpXMFu4RebnlN8At927ktpBtOV4I2eqs46Y2n2C6jT/w4S2e/fx8Qgv50vxG9NSXiDInRjozLrbeTTu6p/Ao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios:
only do this for fully mapped folios and under page table lock that
protects all page table entries.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/rmap.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 3d0235f332de..a55c3bf41287 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,34 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+
+			/*
+			 * Set 'ret' to indicate the page cannot be unmapped.
+			 *
+			 * Do not jump to walk_abort immediately as additional
+			 * iteration might be required to detect fully mapped
+			 * folio an mlock it.
+			 */
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
-- 
2.50.1


