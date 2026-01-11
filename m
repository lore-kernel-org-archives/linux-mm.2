Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB88D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47256B009B; Sun, 11 Jan 2026 07:20:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28346B009D; Sun, 11 Jan 2026 07:20:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34E76B009E; Sun, 11 Jan 2026 07:20:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B39ED6B009B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:20:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80D30BA386
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:20:08 +0000 (UTC)
X-FDA: 84319590096.18.16ECC28
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id C6827C0004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:20:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rcpdi53e;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768134006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0G/uIiDDNOHZeA/w76cf8T95IZ/86Sc506HuzqiPhO4=;
	b=AkgkIdsE7S7nSONApEAhbUOkZHwYjg/MKXvLoh0JWOX8Up9mCRX5XGG7smUBBOjMZ3/eWh
	y/0heaKqCqyvRADGFoO4f6jeswd45JmLkl9bILclogFsxlxTy8EvgaHo1r4Epl7RgsQ9gc
	8MmLWHv0A7kGaKJYd3T9yj0+wELr9+o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rcpdi53e;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768134006; a=rsa-sha256;
	cv=none;
	b=KLNp1AlohqSeXOdNaVHEmFSQOku6HdXuifn0S4bncNQRuV8MmUjlo1QY2Cg6Nf6cQhUHRg
	P5JnXAcu4hHvFpiqjLxTwdaOAaqoBcPfp++DRzheLbMI6nBGAEFHU+atoVfnbjX18nwdwI
	ZhIHP307AL/Tp5DqvjbMNM4HMrmCroo=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34f63ad6f51so2105184a91.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768134006; x=1768738806; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0G/uIiDDNOHZeA/w76cf8T95IZ/86Sc506HuzqiPhO4=;
        b=Rcpdi53eTnLPnXpisuKvo44Sc2fMO4kPmfR5Vnz7jELsrStsGr06Ji1SxU1CXZlZEH
         9WucAAvWuYggvhrBmYOOfKLsru5us1g6wIg8/dRg36x5YYEc+kmDtnmvaaMxuBvo7PXu
         8Ug38ccOrtd6kIpSGKt5gjM8JNNjZHwu72IUIKvTqo/3S2yechD8+XexVu2m/6pXWeK0
         bhd7Mj587a/tPyP0iWudesCUsMpbbpdek6Q5WlqNrOXbAEhHQLqHZuSOjJ8EwyyMz6/z
         Ja879qIku6VNbngDROMjzeC1CHWfrdCe9dwFwwA3WBXPO95oQJAvS5+BWX8HQ0llXHs8
         b0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768134006; x=1768738806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0G/uIiDDNOHZeA/w76cf8T95IZ/86Sc506HuzqiPhO4=;
        b=Nnsj8EmHehYMRBRHnG4uxuILmBf3Jh/XJ7VEfHu3PV9XumgbsAxyaIhSZNxkUjKvlg
         bZfuVGqf/W6L39iRQ/1RxKCJ+MqeJ8PN5nMOxMrA/xryVCvuaNZfSgLXhHqyUMi44Q9x
         lpYPGQp4jNMvcpZfqv8X2RI0T+n4fXmtAr/PgUGk7BFj9F2QD3eXEBkyzJzFAf7Gtdtc
         w5Vexjm+4PjazLOGbuLReTZZbTWG5QF3awTOMfvEMlgKXrX97kWzwhLzwL/7RSUenFjQ
         E1x57/hggp4vlBnvDGIc1s6uR/P8jvQdgjKhulBw1U8Y4ZSsVVb0hRIFGj7+pUAYgXsc
         Xpdw==
X-Forwarded-Encrypted: i=1; AJvYcCXAzLKWiNPBfXIR9hoIL4oWF05C1D2y39eUkfq1S5urjShYp7ShMi4l4bHgJR4w0C2cxWozpgp4hw==@kvack.org
X-Gm-Message-State: AOJu0YweS3RBpI9LTLajNhc0kQmdmStY48tBsPDsQufrLUwPIi/PSgDk
	h7IRNrsUheEtV4KBnhrhxDyS8vvxcn8MIVBtejxHo9h02VqqmX16LNgTCA+RLBeBfQM=
X-Gm-Gg: AY/fxX55iCgATcoN0crejyKC9F+vHS6PRQMNxy0OdWVqsWzNRV90FCbdQANOhhUKI/f
	alqAnqwM0CpVnYDsELFTui07mgqhvX7jfJ+CycvW0OyPunHwhe/ZS9GfU/K8pOfSI43YxEhQwp/
	7c0dUzQs1j8FZfINIHO/EZu0pVDNVo+pBrk0p86xtaRI9hBC7ZifWBhkewrwjUWPfcZEz6SoQut
	2gaVzI4QWt/P/1eMJsmMI7JUF2je8I6lhX2uM78JptQacjfDq7gZBgY9c0yf37duK+nTz7l5UnL
	cvizdCFN+xtzEWG6P5HjVKPkFB0IuEsGDnVaFG7Uhmft/U6mDijerVRAHL4CshTcEnXfHh1xMrm
	14XlYd2T7ZowwaEYr5+v5I1bRzYOZtT718t44Mev6hT9kd7uCyAs45SagHuVd1xaI73Bt6o6ZT9
	RWKHu9R2yzfJLoR1YBPrv+UEm706/2Gw==
X-Google-Smtp-Source: AGHT+IFS7T+REkqaxeUsDPamccnMWWVG2Bbbk1hI/lGfgiUMKIziKTqaxzze5hdv2cumkVYboUFq3g==
X-Received: by 2002:a17:90b:4b88:b0:340:6f07:fefa with SMTP id 98e67ed59e1d1-34f68c03251mr14942182a91.20.1768134005658;
        Sun, 11 Jan 2026 04:20:05 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:20:04 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
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
Subject: [PATCH mm-new v4 5/6] mm: khugepaged: skip lazy-free folios at scanning
Date: Sun, 11 Jan 2026 20:19:08 +0800
Message-ID: <20260111121909.8410-6-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6827C0004
X-Stat-Signature: qou9p4sb1nt3p9aap73msc9haakrb8jq
X-HE-Tag: 1768134006-531151
X-HE-Meta: U2FsdGVkX1/vLqiR4UsckPjmQC0OgJAHpkxKamvWxn+hGad2oXzNEDywMH+lRiVS9jxGhccw98uJLMHIX4SB6eli8t/XyZ3mlX1z13mwNJDMqky6dtHXt8tPNxa4GMCr2YRTOu7svU503YDBs9tDK9v1JzxZxxAkkhF3JsFYquG4y7RcRlvf4KNvmMCsrmtUdp/rsV3K8WAIvhPc4Pv5zXq3g2k7maybb5wr0BzcaoqjxMlSuuplpRvbCfqzXoD2UqmYYwgm/hrCdq/CFEWwY1ex4ZA7NehqtfxHpCEK+JAi3PXIeVpOhGOQi0vCE2CE91GZjMCh5TEWaVCprllqLjAbWQn+Whmluy8KGcWGLdpTBGZSmQ4qT5QnvrYV995iPIaVg2MHb7naau6rOSs7Hfxh7il/Xj2CjyZ6AO9i1cJWgR80fDaN6q2lwR50nh2LSV111g4MZbb99KRKFBeCb8yz3sljiPtBv7xhF7aE05DuMWmxdjKsLTsuaxLPqm5V7rgkDJhs2z6t8ZEulU5/qATb066y23O/IFTuvfiC6DlsUckflQLm+C0bOMtB2pw84a7hlZ0POWIgWwIHp4cNTAeGc+P+tB+gi+1n3eiUQ/oyADn0JoqqLqoL2QRI0wNjrAFifipCyCztGK5VRZZUjfNOJaAKoM1kex/EAVFYEeAo6rRN8FM0ahEUsoF8DreohLOMB3RYJw02ERqgJyuGmkFcnNUke20NvrDTSg2rAACjjNRa4ct3ObpQcPM9q5S2Df1KM+hMNBgW5i/Fd/zqdnZVkq5oE4akfvkINj4/OIbmNDsk6Xill6k6HYTn5wCu+q2zqj8c4BY/1jFnbrNpKi65mOPw1a31SuwRPXMlRgcc6qU8hcqsWW6X/WPVqrHWlPMizdHXBEvF/SaYaTxOxRHBv7nWzeru3T66eY2L695mZyzfK3lO7a/cP5SdAI9nJ0y2X+Hq5cxLbRNc6l5
 wKhtx/Gc
 b7INRHvQt22E3ClhLZfpeVznT/czfqIMQMJvwDS8SRUPOrCA1uigHMJOTNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, it is appropriate for khugepaged to skip it only, thereby
avoiding unnecessary scan and collapse operations to reducing CPU
wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  1 +
 mm/khugepaged.c                    | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 3d1069c3f0c5..e3856f8ab9eb 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6df2857d94c6..8a7008760566 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -1258,6 +1259,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
+	int lazyfree = 0;
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
@@ -1343,6 +1345,21 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+		    folio_is_lazyfree(folio)) {
+			++lazyfree;
+
+			/*
+			 * The lazyfree folios are reclaimed and become pte_none.
+			 * Ensure they do not continue to be collapsed when
+			 * skipped ahead.
+			 */
+			if ((lazyfree + none_or_zero) > khugepaged_max_ptes_none) {
+				result = SCAN_PAGE_LAZYFREE;
+				goto out_unmap;
+			}
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


