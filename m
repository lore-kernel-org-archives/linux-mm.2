Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D14DC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F836B009B; Wed, 14 Oct 2026 13:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8471D6B009D; Wed, 14 Oct 2026 13:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DB56B009E; Wed, 14 Oct 2026 13:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 578126B009B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD72680672
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:02 +0000 (UTC)
X-FDA: 85321874484.08.A835ED7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CE5251C0008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1vzxzvk;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997920;
	b=qfHaqQOBKxKQBMgto5yCCWZTJHKu5ez9jLwQ5nD/H35KhT2PqtmJ2+C+PFDNj/msrVvPd7
	JdV4k03UfXe9jafBswJP37GjDJLv7mZ0d1TsHE0GBAQwggAXWFPL/zEqb4osubBqfPZi7K
	kzy6lPXxxwN7/nhq9wtqdJjHWLK2LOc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1vzxzvk;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnM5tXKHqKAzAPDgBm0il7teipuFZt5qvwJKQnZtJVE=;
	b=7cwC8chAbkyNK1aM9tkuoZ4LjpHKPUYfHbE4xvoA6SISxuoBFvpNbJ9OrhtqBxgRPiry2F
	mEzCyz3DJV8QRiekZvhI6EkhSa+D4tENoGlbhEgTcxgtnptAv6MCwwymloDY/UmxbF1DbN
	saMP/PvkmtcemKPDaOjT/4P002V/lBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27DB541FB0;
	Wed, 14 Oct 2026 17:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310461F000C5;
	Wed, 14 Oct 2026 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997920;
	bh=xnM5tXKHqKAzAPDgBm0il7teipuFZt5qvwJKQnZtJVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1vzxzvkb0t1vP2/vb2ehMLQsvyDHASDNzzIic3Xhv/GaTMfdyazdqU3i5IYepz1V
	 R9gHNr6ZbQCWV3XWw5Kb/Gk3m12eELbGAYcvdkhZlHbfislRFcGNH6JUhatUXdYDii
	 TmibMNXV3cR58zghDoiNNcwSUoHvTioJbHiYm25snx86saT0biSIAsMc//kCE//xas
	 dibOz2eZ6I2mpuIo+7eEA5pIAXMM1OAieXGBTPRflk87WcYkK/ljMWL4YuOXvx01nl
	 XWToQfURSAr8IMdeXXK/NV+3pr5QR7A58aBSkYmrqVFbsL1GNBz8x0bJgr4pBfE9xR
	 LRU0P1/0HQIVA==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6E7E5198003A;
	Wed, 14 Oct 2026 13:11:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 14 Oct 2026 13:11:57 -0400
X-ME-Sender: <xms:27fPajARk9a3Pyym9tbhOZqMyKfVJ358QZuATTmOrjvbsjehbsj4xw>
    <xme:27fPalcwlD_oT1cFhlZ4XR5PcIm7MswjaCeqPVEXROI6CEltvXFylexFAq8dzbN8H
    EZdX4DCwDb6FoVuXYXCoQBccIHdfiAaYcJU9QHfZK1YBPB3UVSygdSl>
X-ME-Received: <xmr:27fPaktbnPqhkOUvvb0me5XWIuhKwZUdv1ALnUt_-qPLbLvMvrvEZ4pPoiY>
X-ME-Proxy-Cause: dmFkZTFAhxxCN9RZF7RgZjl+zblwyI5MNEPViosmoopuImm91zea8n//qrkhNFSUiWcXrp
    MH3eAot5Fj3DZ6VPT64I9vPg0QCUCtDiiTqiv8NQX359J2cSSSZjsC/tyd/Imi5LGIf6hL
    s8CbCEIaBNMBcUHGn/aH82L6PPlafquguz3Z2sEDXsDmuHj2yqTheZQ+fxDOXfR22hlOrP
    qRQ5NbmvpkXKG3iXKhgkLsRulP4SRlPxiR6IgNv5RFr6apIBiGIzyDvrozd15QkLVz/8fH
    sBuTJDigvLKTgofLjjaL63tWUe5PXp+yZe8Mz9HWr0e1U2Y281/CsnjjHOQDfmMGadQRi5
    trOfJroYnG+Q2vdNbLtQJUsjPv4CT3NLxUPxQCQ/DX3FxZsOSGet1UpNslLooeixNqWsmS
    +CuoSbYtktoqBV2an0SVyzxO932XwM/TUdnl8MZkybitfE7bX3k5R6sDqMKeFDRu8BMo1L
    oI9DcAdK8YivMXIbDj0LVpLeULm/R7mccs2NidtSgQy9/0wKhyAesYi60aZR3rYsd5gtFT
    FfqEEJKyZlFYLzY78Cf65kWJ5pbASO5ZHTq2vTqvssFQkaf/P0K5xX8BemeRqsE0rKaBS4
    xJQW67i/aaWzX5au2k5XJ12SoVB+qBuEEo+YoTJohjZwRFm9rJ7I0GvYjKNg
X-ME-Proxy: <xmx:27fPasIZYoRFpDOg8ubPGvh3AW6bN6WtOuTvNeqjvmaBBtYOh030-w>
    <xmx:27fPamb2gIjFcphxLoz-N3Za8Cq5bGMMD9X2vsEkhfzSgqp9r539Og>
    <xmx:27fPaiIpeTOqHd4Zi5_MbwyihFmiSdRbg3uULOs18FbBiv_FXbq0EA>
    <xmx:27fPavougncc5ainOHXYtXPnDWvXiqH_lqoI4UOrEfNc53kuJ03-8g>
    <xmx:27fParAzNVVaeeZBIJXTQr70ClC2k4hAmat-_WPBLJ10Yc4Hbb4HKt7N>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:11:55 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 2/9] mm/khugepaged: count collapses where khugepaged makes them
Date: Wed, 14 Oct 2026 18:11:35 +0100
Message-ID: <20261014171145.3292736-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fcnosbwm861qwpfd6ugezi5xicq5carx
X-Rspamd-Queue-Id: CE5251C0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791997920-829864
X-HE-Meta: U2FsdGVkX18kkPXZazYldS19t1FmeNsaRRAx1fvciJmP1nXBymAaCorDn9dHEok6SV9ZtTec7mq9l+ZIMczGcVDcGGKQ8K0Fi1/+/2UQPPlZrgE67EHs2jqGf5hemn5LR26racc2HjzpuXbhm4ZlU4IE3ioVykDH+DepTVjDoO0zYMW1rnCEHOc/Y0XBuEevCsT7wKulJkn4DIPTTnJudf0oXpsUlwgz3TfRtiMTJ7JpCgvOQF6s+AvzbeGvrIgjY5Ih2hHEWUAmlEkGEbskBYi/GZzQPnk3wUxwOKcNwGm+RbXsO0sjIxF0nzUdyNqHumNShb26IDNwH0qkNDqkN1J2WogsXr4Iun64UAHRQ4D2d/E1hBf5DmAnjoiLnqM3ifdFkjMJf6qZfQ10ubHtM2YSxjuxEI5WPQXic6aS5SHXSWYjEwAGOMRn8PX2MPjTrTJuMFVEGSC1VeCCVoeY0sMzW9dzDQtKn1pojiJ7tdydB7hYO/BX9Y9zJ5dmQO9DmX84mLfv3DpfBnRzBe0/tEEjeToCzmLxU1ilrhH4WyTO0MZFCjYde8a62qFkJk8yHfaKG6bXiBB73nTjbDoOVWBIowLB8wZInUG+ZMpBtiGmifWlF2qFoTW1RN1/eeR3gi5PvFK3Vnp3gEdYEtHAlYnp4R+9p3sRnhgdDcBix9RoR+oCIYa67lEpYBQD78lEUFd2abwsGTipLLQ3oG6v08RjjY1746on0kpQpwkiXqcFBAoCJcWhiAL2oks4d1k7LFPgDjCOk6R4k/t+4G3Hx0a22sFUCUpHAXewgNrJoZCRwxDkPb3Ht1llP+wUzY7QspGgS20zUa5Q1T1gwDVjpHcPmS6BDGfrTrlFhIS5RoRSev80paxXCjsJAUw0B9g+Mp47HnN1GqMc5cl+RnBCJggZ5y1lbS8Wea4+1YnfcU+vI7726yqWpeHFEVPPvWH0woYVBco8vXLT/5PSBZe
 cFIPUrc6
 PtlKmEOR4byd5x1uCC3ypFFS0g8oEKoIcTxrgIudTqSyCT6CiG5AcV/qB8UeBcqP8dDOzf2Z5DaUAMHrjw9RnwdGsqYoRB+jxAm725L4n6V+SOTXf6qTJDtddqyogw/jRvJSfU3760MzZr9iIbHw5nl4OcFA5HN8669bHsie/lFlQAub4f1t7n2c3rzeWG2n0r1VF2bx3xOelCHto+j2XePrapotmCWLSYMAwZSSfvldXbQUnxvRi6tKrVU9QAyCpmde62t8UbKDM9k3l/n+hWrNIdTyKURmH+ZSQkKcE7UMUwGCneX+llh9SUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75c876acf527..4979a93e3648 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2815,10 +2815,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2854,9 +2852,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2933,6 +2928,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
-- 
2.54.0


