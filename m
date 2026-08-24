Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5199C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4936B009B; Mon, 24 Aug 2026 05:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D256B009F; Mon, 24 Aug 2026 05:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7346B00A0; Mon, 24 Aug 2026 05:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18EAF6B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:30:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 902B9140440
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:14 +0000 (UTC)
X-FDA: 85135641948.01.0354C2D
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id BFD6D2000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGUn0raj;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNTnRdSFN4Auzxi1H+B0QKsOJrKfL6HrsAGQ1BLbnH4=;
	b=VgaVDSW/ndgUFgYdvX8Ats6avhhNuR5iFlqsyMfdanQU/GPTNPtAfA6ptB5v1NQdkw0GSB
	3SzZG4dPnLGaQwN6O95A+t2QzDmALCcgYDrnEws8XpWpEKGTUSTWGgckyEbrEuaXL9BPGS
	8CUD/POr8IUwmZKADwEa7ODBUyqf52s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563812;
	b=5R2YIm8ulfF/sSvuugaA8Cg49UFwf6Go/aliaqyXd8DlEdjD3SLQHpeWtcPyI7VpTss4r3
	J70DSvbExrAsvbSVsF+8VkgkaBZOX8RjW8Nxye8BA8wqKSyYw6NcC/WFJgYC/Ta4X9BuSI
	4Xs5/JGxFnGw814l64G/VBqOlpC+J8Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGUn0raj;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1469c1b83so4279778a12.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787563812; x=1788168612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nNTnRdSFN4Auzxi1H+B0QKsOJrKfL6HrsAGQ1BLbnH4=;
        b=VGUn0rajbQNQuhcnqqZaSe9f1EiXFU90pLfiaOgOdZ3lnI/3mYgM3qZzBFEj11DBuS
         I8Opx+3w9WpfTUilfcVjrvhSnLNeBIO5TmbCNh66TsPGfTycN/cLPgDQQq6yOvjNHrBv
         QGEBKzpvsrC1VXK87w+gtyt98PhTLwJu8lS1l2ZCzC/sQ/TzaczSWWpNnYdO8sXsaGOn
         tNNpU+cfH66gZlMCPlHriPakjQoKEqcrqv6vSmQ1G6pog0NOG3hoxSLTtcbF4k7sTRhg
         lvjtZtrkxsAZ5qeR1o6T6AUheqVedmeOw5Cp/7P5D/QHHX5RvNkfEJRrey+mq0qi2WxD
         Ejdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563812; x=1788168612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nNTnRdSFN4Auzxi1H+B0QKsOJrKfL6HrsAGQ1BLbnH4=;
        b=if63XdR2LCp6pqIJpwKxKU3QBPJ+0Gz/tkNyttF0Ky/kC2G0Po02YpjsRzEEZHe9hF
         pesPqB5bdcnd9+hTTuAH5MAcpq5Iz8E22osofUPv8/YJYD23CmNn8n4G4yFRTe5Haa5Z
         tbg0EZsTF/x3kQeYC3dmnmrXoIqVHYsRiIbIwhUc8Gbn4X9U840P1+1FeCG1x291KU2w
         k4JGyVe11/2Bvu9ZdHtarEWNTPy7CgGDBA54AdH7XarHydifvCLDWdnm6eK9nxK+g3ev
         sp1uDokOoFoKPh6hu0sGg3j1MNQjfI5ZJB0F0MCX7wENvwK3ew8oxKV05XBZeO7WQaNc
         KgHw==
X-Forwarded-Encrypted: i=1; AHgh+Rrg8uuEuPEmTDT7RZ9Az2fqXZn/DJM+6Z925XzAbyz120X3Vr1WC7W7aVmI5L8lVNBD4PH6fMeN9w==@kvack.org
X-Gm-Message-State: AFuF++nuPuneUv2cFYYwTjyoo0uexlphg+xq5WBq5n6sKb6H57ydJP2r
	XIZfcbA0ISMMEoP8iOAGbXN1a27Jvbgmm0h4CNsLAE80M5+rEJy+T3Et
X-Gm-Gg: AR+sD12WrcjvsZm6ncpk9HgpXP2Beu2nvN1e5MHB2okawP5cqefL+hIlq+SBdCjmP/E
	QP6LkmgTdw0bZJlHP05ueoDfQM5e70bjL2s2zGUgbPRhRQKR01ALQcpm8g24phZFHVNVEy6SK+X
	SiPi6/Hzuw0LiS3NEFXDVBGr4kAkd6REYLQxaxWRKsyxeaX8JceTvke5jvy6iJEAJvYwyz/ULho
	cMyn2FgWnPoqpcCOUS9Y8tUM2uyfWeEj9uVP9Hu0Dr/3iq22s5CL9L4Bhs/paFj1axxKQusG9OB
	gTGAeRs7bu4hfM+Wy2ftBIyWeHfe7vmEbXzG8RuVAOlRq1lhKS+eSXKscbNv4QkYil/1sOSvjJc
	0a2DGCz8I2SZwmxUWFbBI+vGvDARmrw5AxyUFUekyC8bDhejnsks8bfsd5uRC/MBhmizd/Q5q9v
	t1zSKzgdpB0GLsubwiT61vFv+j1GHR3hCbjZzyn8uLFl8TE83oMGGS35pQG98XuxMSVSqY3NcEB
	A0=
X-Received: by 2002:a05:6a20:94c9:b0:3cc:8344:1213 with SMTP id adf61e73a8af0-3cd2fe7a37cmr43381415637.8.1787563811608;
        Mon, 24 Aug 2026 02:30:11 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc199e60035sm845226a12.22.2026.08.24.02.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:30:11 -0700 (PDT)
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
Subject: [PATCH v3 2/3] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Mon, 24 Aug 2026 17:29:34 +0800
Message-ID: <20260824092935.73892-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824092935.73892-1-vernon2gm@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5oz8edawzcifdiimwraeihn9frwqwn9k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFD6D2000B
X-HE-Tag: 1787563812-473645
X-HE-Meta: U2FsdGVkX18qmLif/JXuGVONoO3wguKHpQOz1oppI/EVA5RrbPLNSlwJmsAGSGEhvzKnreUuA+H5cES5o975X61dh42X6jKQ3pEp9t8GgBcgq4cV58kLpjvScJyRL/ewjhOE7Tli9fLVamxu34WJZj0mkOJVVliC1Lzcq14Fez5Fs3QA3LxVh3PaSz0MqgjJcfiF5c3DMWeqawVfzDTDuCkNRJsxIBLuyfW2DajFKJLuhzPR71mSWyPWXhEvzSEfkwbQ5UfsARC1oVQCLwC/jT5EF7QL4ogzhUES3jeR8elfYT8KX8pcHfl/X9r/TNDWEi9VbouliW26mpK+c7VZXNpX6YOUagGDrxEaKfDLgBDToMyaZM3kFAOAIqFIEi1Iujh590h89nL3/Yp4V8DH8H3F2kHJFzC9rHHk0P8NiEkWWhshkzbCpByp+zUlCFaHYa9bTYoPFasiqsEy+WIDhkLPSLIo5XaElt/GaLtI+Q78Z2bJRIsblj8lkUTtYQdkoJVfK205JJE1qE6c9Ku7VowZtCC4dcv1klWNH3Bp8bxwBwEijJ+C5AQHSrBacoHXnTcBr7T7fbyXCC11zLU/0+IhNVLZVBAa9FNsnvtBf4i8eL1npQez2otgDntWFgv0xupWPfKNnhDzv4ZQWxfl2tLsgVNz+bPujOvKV2tsyWWgoyADlWYwIOdY2O9S3tPuH0i3VS0xHmN/Bb/ePn9wpLTA8xCilKlHm+p9aVTsOdGSzap9pXjdXr8RKwjgld1KT1QDD8p1EwAWBZSfMMWyZV0Ih+LsjVlXnhLufOKKyOnqshdNrQRVgVgiH6m8Y80KeX/fn28OQhLuB/w6eexRnatLEgDbx7Xg79ukeZHcfkWejgAElwEjpc+p6THQvts0EDpy3rBpkuF6R3XD2Yz7JlH6msOhVIhkRWGXYLjAoPy2iA4w9rs1goXCsEP8hecVAP5hJdBK3MYekEYBUF9
 wiCE4cfx
 /skr4wr7nwEFP9ErGUYbB0ui1hTofQgbilTYiqxkrnR2C52c9Q9Cv9Xd+enUqHdZI+25b63NhJvf360krowjtLfqbeCZjlqIPpGoc7309Af6jzYtvMZAzRwyJDeLfIOWmJyVdmOEnUeMLIGvyzPv9RtSwGRRI8Smyj0s1RSTGFdCKpoawWSSvJvuFEGeSOQ7dUedZgoXQgMA06GkrGLk/CPoIf6/16VtLQqYJdQ+8Ev7RJvAyIDigwPCbiyD9BAJWMcG2Y4EKCVunuhROW7H0yV4deGPewAw4nqcrRpagkqfxWWOxxXH9OlMJekQ4ic+LFx8kUaSF1fM7dNMEN1B/0YJjN2zh2HFWBR1rs6lDqKX86woI0L80IsI1Wwr82fOrcN9l9fpo7qK0u7Y9b28DTz6dIh63ZFa/Z840UCY3KXW2/qjSodwpgD+bwnjva7t2Cg2a4WAsXLvmohpu2zeOk7cNWOno4F4lKGae/9uU4vjSNGg51xXEvyyeyUC945HnK3Tp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

After the page table lock has dropped, the folio can be freed
concurrently. The trace_mm_khugepaged_scan_pmd() is left with
a dangling folio pointer.

So using the folio_pfn() before dropping the page table lock,
closing use-after-free window.

Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 7b526528f85b..fa828967e1fb 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 00337405c0e0..4e0fca5942dd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1618,6 +1618,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long pfn = -1;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
@@ -1780,6 +1781,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		result = SCAN_SUCCEED;
 	}
 out_unmap:
+	if (folio)
+		pfn = folio_pfn(folio);
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page() expects the lock to be dropped before calling */
@@ -1790,7 +1793,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		*lock_dropped = true;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.53.0


