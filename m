Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B563BC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BA26B00A0; Mon, 24 Aug 2026 05:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6596B00A1; Mon, 24 Aug 2026 05:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C856B00A2; Mon, 24 Aug 2026 05:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 687246B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:30:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0A13A04B9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:18 +0000 (UTC)
X-FDA: 85135642116.11.25BD5A5
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E8C84000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OH5aWhBs;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563817;
	b=e9uQwDK81qwPzIOQ9sEENmkrH6Gg2Jid9gtWi+1DsZYCouW6ZA7ZEPlJlXFX3nSFW34rtD
	K7p+xge06qLwNNv76CW45TJ+ry8OuicK2uELj21b9dCyHseggAnx4RNIUqLtt9TQvwETDr
	BkZ6gYdoSpPhNBP7R/fSQRTItEEz6wY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OH5aWhBs;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yr3XBcdQ3LShy8RFIN2zpBH4EW/xdxEP6silOD6LRY=;
	b=TqYqFa5xTy06p5ZOiMI4PpVeEz9P8L/LU1j7YKgh5IKvrVSCSgCzJj5vT4sCG7ZXKEXtiO
	1DLSZ/3du457rW5qzsFvcsyV5DHuySaFi9OAZ35jn/5Qip9IZrzAHIYO20dVGOSYx2WHtf
	bSwO8QzFPUPH6vS9UJYtcYZK7xjDbaE=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84a652535dcso1771545b3a.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787563816; x=1788168616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2yr3XBcdQ3LShy8RFIN2zpBH4EW/xdxEP6silOD6LRY=;
        b=OH5aWhBsKzOQKMG/tZfGuSfZi5bdEUDOgVte6aO1zxFQyw/PLRQAqv0r/0XRFnxAzK
         ZsRAyC+CiHOsCH3VqNPMxOQnqrxiEF8Bjd+8y+EiTygAkwr4wny7Xv6g/MKa6V9MijYI
         DGL5yJDBXQb5C5B/7UVIlJKw1RvnhUQM7pmJ8lXGNLzz70NIyCsZr7YidDLcqAS/fGP9
         vRhVQr9D9dvC/kxw2cmktGHMtIqoZ3oU/m6ygDt2ulLaq+U8rmDC+NX3XqmJxpvVVxQW
         Jmf2IjxKRqiVmDKSDyExFAXzt5Hy3VgCUuvjlZCPu6tNmfGOBrOOeQ/uJctcLyb4fFhf
         oS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563816; x=1788168616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2yr3XBcdQ3LShy8RFIN2zpBH4EW/xdxEP6silOD6LRY=;
        b=koMEcn8YP/6wX13Qm9obe86a+/1h4UMKvSTuc0jNBuKQNehcFQvQk/AwqXBh66vO1j
         xROJLmWou3Sd1T9tOMry27CG/oDj4RjFZgmmXFMUt2GO173fH4YH7Ee9cXzLL7zlecgl
         yQycEGl3FYLoeLgG4WTyMpEvk36cGutR/Z0DgPz3C8QIqu83PBz79OelRkJiU6dvbFbb
         Sw9dIcBuG6Tgow4JX2fL/PcYQRljp5M09qPzYzjTS2AaIkCY49UPjSAr5ycWj2H36Lbi
         SrPdVTbYZooSUNcq08PFLqcO/6ZNZiSUxvMH4N68G/jqGkmCG1BXsWpspS/S6JkdOWOz
         WkYw==
X-Forwarded-Encrypted: i=1; AHgh+RovdxSZLF7BRPbu34nkQ8UpI4W2euN//9Y3x2xGHCp7Lrhe3Pe4eXxcm4DdduA8bGV9bsSKBvRSWw==@kvack.org
X-Gm-Message-State: AFuF++nqNt675kKk8CbCyiqMbQxNm2Je4O9TN2mrtgcWjYQuDVfG5rQg
	BZswu4T/ASNsuW6bpyuKkRjQXKJL/a9NLkRx4h+5i6J+XN01FDoJbn3Z
X-Gm-Gg: AR+sD13rBOpsEW15XZ4zlc3c6gCVJG+3BVJzZVoHbKXJVtXW8toUkQJppkStWiQbz56
	G1RBRp1EaYQt0rKulvk2FlSrGNtAqf2zpj5ATr4cDQLUdWD2YEyYradB1iwvAxKLx9LxcT4E67/
	LUCmclTzT7v7jEqXCLOIjyLObAuEuU2nLxEqEk62zVL2nPo+cCvzvSPjD0ckWfxh9XB8Qi+KT0A
	QQGT3ks3XbI2t7Yi+nB8KtndIn+quQEG3ucx9GZHvQ9H/OpO3HfIHJl7q+/7YAuCfmxgkYvC3U8
	HOoG4z7nB8qHswWbdzhj5SWho6jT5dBCSUU4FLsia+DFkZG+WochU9YthsiIk35TS8hCoF6aAB+
	ynVL/SAVHLOKyXfS+foZWIDl7a5IgzKmd6QVhfeCchW8Nybf/VNG0s0ZhWAKiWUGIyYciglgH9h
	vVQNX63GW0Us0Wox7/KTvOGMLubnlFDBY/ucSb0mmRaC2GeFUkra+VBm72G+c6StCso4HshAMOi
	ux0lWtyLRoxz7IcKverF+cvuQ==
X-Received: by 2002:a05:6a21:a93:b0:3c3:a140:9392 with SMTP id adf61e73a8af0-3cd4b6850aemr34704553637.0.1787563815848;
        Mon, 24 Aug 2026 02:30:15 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc199e60035sm845226a12.22.2026.08.24.02.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:30:15 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 3/3] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Mon, 24 Aug 2026 17:29:35 +0800
Message-ID: <20260824092935.73892-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824092935.73892-1-vernon2gm@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E8C84000B
X-Stat-Signature: fzc78s6rg7na1b18rddt1za9ihjry8ga
X-HE-Tag: 1787563816-362277
X-HE-Meta: U2FsdGVkX1+GfkhGa0AQNkYskHIv8jiqh/xWvUaMP2C43rbFHaKSLPio8CXsQTaBtcGFKPlbFD2l/994KFuvjinvRm6Gr4RbRJjTDrukeRXOypuwRiqjHGqEK5m0/lzn6FCXEKpnYGrefk5S8QA3a1ON8pEkrHuDdXpMo8NFMoSXysAcayvDWum+tBeVduNFNN35BxgcuQTFGX5uY7BwIhrX0ApGi0ziyseJr4MB7oAiinPPT3i/0noDhzc/1jcR0v1u092sIisQrD2Z9VmfN8IFv5QCAhGUVH1XZ/L05OH+jwy9HbyqecSpYruwR0vMPewD8G8DMD2oSd0mynxslwAsy2ApDOCzgUPE1RDGKaZGw6B2mKUpty1Hvx0o21LXtVEvb271cSOp/hz1KTafrT98vW7SdoSw9fAbRZ1O9Nhmg4LkMZpUZECVO9/tckpF1vBy8lvJ+4cfHPBNEY+hk2jG5MtsauEBvTui4qkrT8waJ3mrD+cMhOfvcvIICUclXRaySpOWEBqvdtCkkQZJuGo0yTqsYeg5QeR+MLBOAbC0bqUSFeGSVKTQ1IvqMJWGIjIapLEeLKohmb7D4jl4jxW6bfivZ74vzq8aMcvhtVGhGcw/BeSCE7EHPbOPhMLDXPIOqH3vFJ6+NGbTMOCp8YOfetFKD6tZs7aL46LCXpMsWCDJhlPE3kFkvsbChnEADzcdi16t3u++D2/Bnlo4DgLM0zxf7uskVJh0awoz08nh1DYYK6DrMHXCVKh6DJqvkf8seKiFuxZay30pPrqdrqnLRPBh/DMPoOe59gHbpku3M2l+f4oCUv7i4tTviTBCCEWIy3NVzrOLZL0IXXLSpZkgxaSFdX7DKzg0zE5tNBUsfgS8btCyEqU08cwR03Daaxgohtl0LhHQL4P2SkNzHRUX30+h0FxIcsJKVCgsfzs7G9Ln99Znqr/QDByGoFMEdLIrF5npTqrKkXByxt1
 p9cy2sQ2
 0kW4MGyTw90TUVOQWdWLHtSGCyXIcIVfngZQB9xvDjh/iLR3A+hulfqrNd9f74VsEdHz7FOiC4WU2lGPVukxENLKqQJMIxlpcklig/98ECw73+Lw01mEAyB0KUWUoDkHH/3/0I8YAA3MvZyjKRDkHZ0ZR/IJ7jtsQiNSsUk+wU7ZEc2IKr/VbcBXxwJRI79aPJa8RGsUJwntHMpl8Xhy8JAzNDKrtsVUxCo7zsJBm1RYuL9Qqqu3isOG5ApbruFlF2MDzXk06U0Ww247l1B5cKCm2UNI6iaBkBiQo9xjrtY4GaMn81z91sDh3u4Zo7O2Walf7QmACJqPlHN54RvFMlJXh7lORxsh8n13rxiscRFdzbSvfghKiPvVWmvJ210yFOzXDW35L47RzxLwsDai7cMTd48VfvoeWQggWiIia35OrGO4lMCAPbM7Q8SW2uvlMaPnv43ucOkWxEdiYAXDtclpPvcKWS7k3YmhOBJMo/TAsnDch/NL4aqbpHnFPjrXvNNrK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

On the rollback path, folio_put() has already dropped the last reference
of new_folio. On the success path, new_folio is already unlocked and can
be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index fa828967e1fb..5fb4d92cfd84 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4e0fca5942dd..24347f1a94ae 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2254,6 +2254,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2633,6 +2634,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	new_pfn = folio_pfn(new_folio);
 	folio_unlock(new_folio);
 
 	/*
@@ -2671,12 +2673,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 
 	new_folio->mapping = NULL;
+	new_pfn = folio_pfn(new_folio);
 
 	folio_unlock(new_folio);
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
-- 
2.53.0


