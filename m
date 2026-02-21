Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A2CC61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410CB6B008A; Sat, 21 Feb 2026 04:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1A76B008C; Sat, 21 Feb 2026 04:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268946B0092; Sat, 21 Feb 2026 04:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 139E66B008A
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:40:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD7551C2D2
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:40:05 +0000 (UTC)
X-FDA: 84467967570.03.BFB1D60
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C156A000B
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:40:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IxvqDYGG;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771666804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lr0amJtGkckOgt1zwhQW2YcmsdAALF/BjkLZrgfyvsQ=;
	b=4FmTBahWsgwJ8VGwNPOnjSc4M2GDaEi7cNrbv1ZdV9ly9WHHrGosKIGfY1QB4hvGGi/5sA
	IrCz73Wv4d70eSvTF3hcdgzWWpEbPclfE7WFH4dV1rhEln4wTe2U64l6f3VhgL+ZOeBEHh
	Y9VqOPDO7ox1EjxL/76P94LdzgRRork=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771666804; a=rsa-sha256;
	cv=none;
	b=CNzbQO5J9Cv6V7i/MkhVB30SyVhqIFunue87IeQ9eFKGKYEA1k8NvBnfC+ESrCG64s7t8b
	8yo7deDdyNXDVK3/vm1ibUNM+eBwaD1qCdiNnLvpAyuieSNQc+2gdvvif1KQ70VC3ILrB2
	IKAmi3KlXNylxUSMhKWfcfZSkr0+1xA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IxvqDYGG;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-823081bb15fso1679074b3a.3
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771666803; x=1772271603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lr0amJtGkckOgt1zwhQW2YcmsdAALF/BjkLZrgfyvsQ=;
        b=IxvqDYGGGneHwooU/Gnj/+cYR0A/WtZZZf0404MpvyKhqY6eeF8zPwXkJU7JYkxyZ5
         cRsnfY7Cj5kveo1ql9squDlp6MPiaJV+XU22HpvxtYTHqFlRDL7OC6XYkVVPPiDhsaJ0
         RWFD08sMYywMzXV6NVXICL8QnoMSZkvtGO1s0k+UWfOa3zqbCdzCZBdLh9OtI+Ng6wFm
         yo0LyYL2aoxOPTgg2im7fPm/MOHwmDmfSbqT4PXpHvI++QKUo8m67GmWI7bBiA1lttzp
         LJzNz89A0kHezl6EF+sREU4nAb7npEFH4eyN1zEjXXNa+aKY8kXYA8PtDw2hBh2FD4cJ
         R0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771666803; x=1772271603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lr0amJtGkckOgt1zwhQW2YcmsdAALF/BjkLZrgfyvsQ=;
        b=svyCm+jkJtnQn/CFdfV6029ZK4f2RFFQ1JxYuwBphyjptCIV1b9HCgtRGGltZefm6m
         UjuraM8uOOsrnBUX57N/bsbgZbyimtMSuKXVKqM8Xknf2+/vVb3LKBe94f2f26x6UqRo
         w4qKybR7YFFHrgz/kEZQyKpdtayLr3bFSFxfNBO2qZJrmtdq7JNyWlb4yjLRGF4PSXNK
         g8TXaWpSBXxOKjCMjEJNvksU/EIhfHwZzE+jLYnbD7HhENSwcJMJFUI2jeq+E1WX6mln
         c5jFMFqQR9OwF83P+xY3GTTG1EtBI18YqqlUYKCyKb/giCpHLavpQhPBON3Htpv3hTL7
         93uw==
X-Forwarded-Encrypted: i=1; AJvYcCWqosI3MVCpDgGRgKWJjFy0TykHSSG2gkZkGIUzplXllVqvm30eLxBdjvitqmfFcZt7/2OGu3pS7w==@kvack.org
X-Gm-Message-State: AOJu0YzSSF0e7ospjW0TxdiuXEaiU324AO/D+b3BVrj+h582Uu5xni3K
	ZcLavcG4YZK1hstuD9OocigyEMbOo9EEjMEoxKSrvQkQ7macZcqYH/8n
X-Gm-Gg: AZuq6aJK8dRNYN3d5BbyP25UPpvj83720w3dUm9jmH6ShOmZnvgHeiOxTRcqz05VUoZ
	X49hZsSJSjoFslpRIwGYHpVz5ZQDbObOEmBsPN50mMvLQDf8XeF1u4/uK5SwbHB+kF/XN1WVvsV
	WqBizOfXL2qU1g5VgG9+/MOra9veHb/EvrTnfOL+T93LhVOUVQ2dNJxdSlSHjMzCyQ8qAapei74
	eiBbkK5RTN1BC8KIUdPTworUsYobXEO1xqy5QeNPKszsDFTXYl0W41jggH0xoNuqnIR7YILYWfZ
	zVS3aSAzI6l+HMknynVQ2FGU2T4HNYRtU/9RsiA3f9IN1WPJp5Bg/RVnz6koiLFkRm00F1OPr/A
	U44aK9LOtkUcf7Wqo5VECx0Zy3A1A+IVETJWpnopfN/w0CyHux4AA1cxZ+tUFwKkoqSjTJ1b8Q+
	A/7bzyubAYgwQYwCtaUlzn3UWMNfum9hTkTw==
X-Received: by 2002:aa7:88c9:0:b0:81e:f623:ba04 with SMTP id d2e1a72fcca58-826da8e2f04mr2478100b3a.13.1771666802917;
        Sat, 21 Feb 2026 01:40:02 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm1761708b3a.50.2026.02.21.01.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 01:40:02 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v8 3/4] mm: add folio_test_lazyfree helper
Date: Sat, 21 Feb 2026 17:39:17 +0800
Message-ID: <20260221093918.1456187-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260221093918.1456187-1-vernon2gm@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C156A000B
X-Stat-Signature: j1premn5uog7dzjz9ci47ri594zwa73h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771666803-804953
X-HE-Meta: U2FsdGVkX1/QNJv+UMWgeZ4PsKCPp3ohFcG2v2T/MTTc7sqNNT6/QKzaU0VxQCD6j3J95Gh6VxoYVbcoWif6Mev3q3SCsc001jMp5wCpX9zkek0jBuoX8AB6ONKb35rE53jAk/00+p3tIUF89NYtgpg1Dqkg45zV5yDPxFZnf/VXa9JcffEcPk4wgXqbLv//dD1QXzdoI0rvdLKEdECZnPZwsBaxa6lmTz6u5Ho1bszMHigb6Oc+2jOKvtJRM4M6h0HvnIGJvudd6gC4zxcatP244ViRD0OKYhMpgLSeoo2qdKSsTONrbBSCSaQB3vjyRWa0gjG9GThgqU6PekGRbDCf5Tjvu56142/gjM3GCbHFezONVLfjjJOSS71YcuUT60acRJdfTJOHxTN2Qfx1fJLsaPEwba6WZ0buXsZvMtBwAVw+HS3jz8pcsFpz/ixqKZMndW5W2hylaXPqVgXGnUTc+PnG99IvV9dIgK5myU/I81NlGt1N2WYsGDaO//T+YZO0j+Vz6IERPxpOIeGLFFL/KBv8JeLG6bfAL+h4pZJDYoQthQEIF+BiGJ/LT3+a6JJ5KvyO9TlYvJEmNM86SIpKIIbvyhT0spIHKgWqpbxEFyF6hsyxEUBW642mG8i3UFBslUbmqd7CPSlObbwSCRbI8AwhMScrZijiRmcLKy3K4fQy+5L6wLQR5B8O3Y9nQoRQOv3ivoqQKybGrEX183+shd0Xe1NA6wY5QcbE3D32XgxyZtmX0qMIWiTgXIzTGR+z2mVnUJ9mIcbsZZQT6aBfSmgn2ZuW/kK1SNLFKllMOfj4G69nLngP0TElECT59Z4Pb11Kz7BPikRNxU8xfCkGR7nvdOy1Hg/ogaJZ/S41JbTs0uPNcCzmxEn59MgsZFOvZXq/PCkk9ITY+9nLGc6QCAslPssHEHCeGboWhNg2uA0ugyA0P9JL6F670hc4+lOB1nNgFNF5JipJJ0W
 p5PH1KtM
 PQ1SZrlIRq1TONTBkxxi1KQzFL0tHm1GTx5EasNk4R+c0VsiqTYcq0l/pZR0/Sd4wJ8fqV157CavPA655x3zch3zmy/2hDjzWZ/2MUgWpIeZhePzLGaZW+62X6newEJob8iMAeV2kar4I8r5WL4MVy1M3tneTPlgVPQ99h7Jglbn5WZXh82WAs4g/ke2VwT5kkznW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/page-flags.h | 5 +++++
 mm/rmap.c                  | 2 +-
 mm/vmscan.c                | 5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index fb6a83fe88b0..0426cac91c0b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_anon(const struct folio *folio)
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
diff --git a/mm/rmap.c b/mm/rmap.c
index 0f00570d1b9e..bff8f222004e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2046,7 +2046,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a87ac7be43c..9ce3f54f43b8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


