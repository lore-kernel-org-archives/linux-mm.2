Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170E8CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 18:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199A16B0096; Sat, 23 Aug 2025 14:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A1D6B0098; Sat, 23 Aug 2025 14:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038D26B0099; Sat, 23 Aug 2025 14:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3B686B0096
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:27:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6670884139
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 18:27:39 +0000 (UTC)
X-FDA: 83808855438.17.A8FC4BC
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 99E0380005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 18:27:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mg7PGTBs;
	spf=pass (imf02.hostedemail.com: domain of aha310510@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755973657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gXnziTBw7UP0Qc7D/AAchtEa0GCcVLQfrOFVsu3rHR4=;
	b=ZbpUN9V/OJD3i/YOXSFs8n9pEfM7FNSvrMSgYgxE+/vLjFpX+QiAHea3mHuaZMgEoFQRw2
	ruEmdQzIYlL+iId8cizRtJz+1GkAxBpSadiDIkV9UPJl4huPythTKehqSFTjOhrK7shPKF
	FGpbiUDBS2d+UP3AAdsrLsdbswMJ0mE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mg7PGTBs;
	spf=pass (imf02.hostedemail.com: domain of aha310510@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aha310510@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755973657; a=rsa-sha256;
	cv=none;
	b=yIzKHNTgyhzwAlnL2kjUzqOVCH4cHqZOEy+CpJ5uC6g06xv4AikMP90LfhmI8xl91pE8Wc
	Ghu7QFMk/fV+N9tkRCLkbPWveffMOQ/qlUX56Ldry9uetx+jsPNAnexLZBmoWSKa3DST7C
	2/tMGkqdVpk1z8Ac8C0KqkEL8HLUpAE=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b47174aec0eso2030310a12.2
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 11:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755973656; x=1756578456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXnziTBw7UP0Qc7D/AAchtEa0GCcVLQfrOFVsu3rHR4=;
        b=mg7PGTBsZzDbtO/wyp0Vmtw5M9jXZ+hrLpUIYJ6UdW85I9mFN3yF9fxe088gQBd/LP
         ZVpB0/NBwyvzPuzTpUkbizFNdW+rjA8BwBiKJ0Wbg1OqILPMWJfs6K4GtdX5knfj5n14
         J46bCudaJsR1lJM8zIl2DlaX8hgca2jQgZYXpNg+V0+MGi3kdmgw8NOkO6cso4fUHL2y
         Ej/CAmfh6dSWIngw1Z46P1zt/r67T4D7ou3xNm63xAa2ePT/lLt7sIqM4p66RqqPmypj
         3kAY4NwBWjl+G69C2X38s+/zR4LwxBJ8BnTDCf7EFT7dIvQ9EGCq0gqsxa0nIs/5lCTO
         JBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755973656; x=1756578456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXnziTBw7UP0Qc7D/AAchtEa0GCcVLQfrOFVsu3rHR4=;
        b=riPsmkUaCyvXyeQMDT9xd9T3r0ZQK77YV+50HMQlBzGYAXIEfWxi/RVA2LODMP2drF
         1f9/CJCDxWANhNQUdrJXOUJajSO4TdbBO27PCsDMropz3limQS1ihJrpEC81If1+sqYI
         aAsV4U+ZF+5yNW55SqaBnG0ieNKY4CwYeWt4hvmL5lNep8qwFgMK7EctDdJ91+9xm9IM
         XA3PWJVUZbsjCFRHMbYklcWshqIyDpN81U9Oi0fEyJq/MeCiaBdGktZhwYeFIh4hhx2o
         EiHhYdFHE+JpVNZeFioHIqDOx3PKVA1ZIe3SARdv8x6P0bhkjgiaR/qnq4vCcmYaNyIh
         4P4w==
X-Forwarded-Encrypted: i=1; AJvYcCV1xSyB0vYBfu3ev44L/EYggTzRu7ZzE84YAkrCJUwfld+blOLY3g/A9eLw6QuNv6IrDScfnIyjqA==@kvack.org
X-Gm-Message-State: AOJu0YzJWfy0M0mt7VDE59+RBQX5/ceZeDWi9dByRJNV5beX3ehJ1Tlw
	Kr1XjcyGIdvjnKxm69peV+5CUAQNQgWuKMBZRhcNZ29VjH24kmwyt+zA
X-Gm-Gg: ASbGncv/AepUwGlsMqnFTzyvmjJaiXBX/8W5+Y7LFZx9TtQ/w3h63VNLuWHl2Lt+o4i
	j2twf2ROBeZimZhG6dxp4jkv3ufK2wHs5fjs1qN26JE36JOaab4yz37XWw1Rq0puGaI+JOrojyH
	Hk7dbw0h4TZysSb7qMKxhr0JZQF0Zhq5/bg0To5U776EpG2ucEvF+19FyvGQMvH9TOr4Hdrkyk0
	0N0VeyWrJP8lJJWYAEXorFyWEwsbA8dgMlmUX84PGtcYvAcNwEhlcC74OEjRuwDUiBCNBmoJxWE
	wNkmFEdfnLm0c6xD1JDcV1VQtILJc1kRJQyf2XMLdK6MLuvpBCuAqM4ozrEZrq/16IXzDjH5w3k
	r1e/cLcDsdT1rf509u/HuB1BM4cdWSD109d0lQncepMuORHWHEQ==
X-Google-Smtp-Source: AGHT+IHHsu26uhRGS2VEMcQXkzG9XqnSv5HsmmjeJckuRco0jP/Cr3o6xLlULPJm4kWDO22cl069sg==
X-Received: by 2002:a17:903:41c6:b0:246:a90e:9179 with SMTP id d9443c01a7336-246a90eaf13mr3374155ad.28.1755973656315;
        Sat, 23 Aug 2025 11:27:36 -0700 (PDT)
Received: from name2965-Precision-7820-Tower.. ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7ae2dsm2779012a12.28.2025.08.23.11.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 11:27:36 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v2] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
Date: Sun, 24 Aug 2025 03:21:15 +0900
Message-Id: <20250823182115.1193563-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dfhbj8oshjn64m1xe4cnzd1edifiqate
X-Rspam-User: 
X-Rspamd-Queue-Id: 99E0380005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755973657-639114
X-HE-Meta: U2FsdGVkX1+IYXMwu+Dqs+lytTUPKuB/FNelj2diTQWZU2vw4/U+GO7yyhb6nrBt9gCb10AN0nKjuHlMYbPyjnU6BqLjTmK3uehy8sqpwlOYpjMYQhwVsKsmU6L7eGAXm84fQwrh1Da4jmf817s5y+Ar9HLHTfM43D0tdR0e2cYJ5y6VIiy5KVWKdg436zEqCdMkLpLLM4M5bmUG3WR1FM539Xq2f7USnzbS93nEfmt5hF8rAfVG73GhoZmOinovWnHjbk0aBV3AqQWjXhRoye/uiCQuTb0DKBIZIrBCsNFA6VTPYGEaerD32g0SoeDNtcxEHDiv0qm1jMRRRTcqfSYIkqZsukF1FD4WtlODep6teumC2B1LAzXigKi6VyBZbsuPay/s9gc+66/yYdjnwxBNiRkd3wspcQn4CnSRHX4+Qv/3qahlELyvzIcrQg1vvA8cz0eBDRWljF1QJHdOWPBtJwwWj0LEPc6UgMoS+y+1vwu8G+90ChZ4OMmr84+hnuOsitr24xTZNwBaxJL3muKMBKBLjB+qt9O8AFSARPqTh61Ca67w74YaHKFmBfWQ5XcoaVHngtZSNbEB7ePkiVwUjhsSKJ50R6zXg/Wr6bqSPpX+pAxPiIVU1bPmzqY4XTlsSC30n38PCpHBKiHxG5NnfDDKOLgpg/pfxuBFxyOonajqAgwaZy0yuszMQbGykebBQOTD732XRR32/kKGAsnFe2ePmyTDlb6MDffgFjX8VRyfllb02qc3ulKXEHJgK8vv6QWwmO6Wv+C09wOmUz9S27KX4/kkgfcXv70hb0YRn+kkLFts3sr9Y79fsYWuRSePegldXLRFxbcAkV+SBJvhfVUbhO4piNBIp/DdL/EcIpIwmcPdmoQVFaf2EUNM59oPyeZaLhVpI4Nh6qVX9ecxXsR0XTml7LQTG+RDtw7EceL9SXTWDiYNDUgJfdHeX+UN1ZbS4a4tpNZUMo3
 8xP6yP9U
 fFZpjxthNZzRHfHf6t8SNDGOn6pcNeAum+ileFJvIGmI3WoBreiHrUe8w9/k63tGWBa0gVp2446zQLnnBVYWR2FswaBp75vDmxRrVKKuPRVi2h/v4qeYGm6dKJqrL0dfpENNI3uD2quFGmcJw2oHVfROvf7uQB+YVdyDO/Wlw/ZxZLxbLPfgGXiCTBr0TJsAhqGdttMdL6MK5DQbLn/2KLvGMztKNK27+Q5s2O6Zt6kfN6L3t89YtCwEesHZhq3WpffYAvXPh1gOkJwQ3PCOmTfCZQjNQbykXgOZg0b/y/cdBVwccwWz4D9LD06V+00rkpbi42kgV2cllr44B7GERkB/TgQIVSdRT+xeiLLN/Ges8DkwttfDyDAr0uhWquded5wH+x/hXcNL47PKWlOpWs0QvtU+MHRdGrRWTNXqp+kL6PQ8FsyDiHGZOQvcou5SPYImZgzglljH8G06ARBWeUlaRdARKOaIZWeEGMH1NiXjVO/zylr3zX5EEFhAgD26LJwgJORc3gx1iDDggAQaGK2ZEH3NHZeH9xE1CPwHYL80WLTwFunzJlxcf40TGJrF/ZX5sNTZe5l7gNhucMHIvnU5xKU8A/9z33ymGl39y44C0KFP1W4V/uUTiq1BFAXSAZa/8ROqj8AFMDmptXfbVKCIvHuHznkM3H9trK3pZ9ut8hT88kU1/3bZWXwVxjzH93teN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring a reservation for an anonymous page, we need to check to
freeing a surplus. However, __unmap_hugepage_range() causes data race
because it reads h->surplus_huge_pages without the protection of
hugetlb_lock.

And adjust_reservation is a boolean variable that indicates whether
reservations for anonymous pages in each folio should be restored.
Therefore, it should be initialized to false for each round of the loop.
However, this variable is not initialized to false except when defining
the current adjust_reservation variable.

This means that once adjust_reservation is set to true even once within
the loop, reservations for anonymous pages will be restored
unconditionally in all subsequent rounds, regardless of the folio's state.

To fix this, we need to add the missing hugetlb_lock, unlock the
page_table_lock earlier so that we don't lock the hugetlb_lock inside the
page_table_lock lock, and initialize adjust_reservation to false on each
round within the loop.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=417aeb05fd190f3a6da9
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
v2: Fix issues with changing the page_table_lock unlock location and initializing adjust_reservation
- Link to v1: https://lore.kernel.org/all/20250822055857.1142454-1-aha310510@gmail.com/
---
 mm/hugetlb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..eed59cfb5d21 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5851,7 +5851,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	bool adjust_reservation = false;
+	bool adjust_reservation;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5944,6 +5944,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		hugetlb_remove_rmap(folio);
+		spin_unlock(ptl);
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
@@ -5951,14 +5952,16 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
+		adjust_reservation = false;
+
+		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
 		    folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
 		}
-
-		spin_unlock(ptl);
+		spin_unlock_irq(&hugetlb_lock);
 
 		/*
 		 * Adjust the reservation for the region that will have the
--

