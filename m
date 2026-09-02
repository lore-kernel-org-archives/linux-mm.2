Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1B6C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE7E6B008A; Tue,  1 Sep 2026 22:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB7D6B0095; Tue,  1 Sep 2026 22:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6B86B0092; Tue,  1 Sep 2026 22:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 755736B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:57:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F1431606BF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:07 +0000 (UTC)
X-FDA: 85167310494.09.BD6E5B7
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81F5AC0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=eNYTL9YB;
	spf=pass (imf28.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.171 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788317825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+aB6s1JzdbmAf+ykqnt3gF+KENR2kL9PYAKepasbfI=;
	b=vEg8nVVSLKluCHqFVjbfAiWYIDivBp8LFbqd8RPpyWbOBW2buGHmz7iX9qtf0l99gphxz4
	j1C/WjuSFHcb2FbuDqfREwP2jibUB6tfTGtEUQsqNRyvpP5CINUYfkBFY9CNBFCPPvluPI
	qZryAcyD7gD5UVYnxMPoqxH34wyH6aY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788317825;
	b=kM8wbCQnuqcHOC2B/I6RrSQdD6rC6Cy8nl3TH7/dXs+Wo/Hs4P8doj1A66ChrLIO3tnXfh
	yxLrYP8bUsXHlCcY/KcjfWxQcM1pq/elXVqphblqS30mV2sTMCbJlSamELsuSWztv4a7Nw
	4DZQpV80rwtd1slNfxeliGbRQoQ1Bbo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=eNYTL9YB;
	spf=pass (imf28.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.171 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d6e954afbdso3095325ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 19:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788317824; x=1788922624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L+aB6s1JzdbmAf+ykqnt3gF+KENR2kL9PYAKepasbfI=;
        b=eNYTL9YBjuG3Y7gI9gNNMvMo+JpfbKzRQUeApLDhmfuh9XOb7+An1bSGlt6RHtl0A0
         hlzofsquzE08r0IIFRt+D1CxoUI3/Wzp+eA/uUJ6lM1F2C9Nfcg2wlRf7QqXVparOy7z
         jXMXjFuyfri+h9dDEWO3SHhgPCH2xWWGN7gAS1ErUMFWBncwC9DmfD4dfJUOikTXZEVx
         tyhV4piDgA6aDMg+TlYaOYnxoFJ6ysJvx1bcEMn7TqT8KizWsVvF+y4uC91jZts53jx7
         rj/+4JhVjS/9AQXWJItHgxX/kWVc+l/VUzHBvhl/TWN2wLyH1IRo/CRuAyfd9aRJAMZx
         ipsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788317824; x=1788922624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L+aB6s1JzdbmAf+ykqnt3gF+KENR2kL9PYAKepasbfI=;
        b=KF585d7qnZaqOI5yZtV5EP+RI7hzJD5q/FXWRF3o3hshn4Wl5+TOs882Azf5mIl8OK
         Jsits4gMbaDoNBHks2k+4+rJKVXp2U4twmT5fJJJ+a+mvGpcsVftFDRlG/ecUQ2qPk4X
         h4Xjt5EfRTuQCcA8GU8gdJ0o1hIbnsIPhl2fW+i9WlW0S8Sya04ZxNsrG3JUDoIHjvvg
         39LgdxcrMmrZrt/dJg+5BsGAs+L/2067pF2Fo0+hTzmwm70Uyi1ecnbRJaMCrhARdlfR
         XcbMZEi3BYArr1WwpYyVUEHh3omf7Bt2QlkXsR1/7F/U0QR1afjiKHSL6Z2uWGjqiV+4
         OH+g==
X-Forwarded-Encrypted: i=1; AKwUvBzlGTmvDXrM1TJk3fjZoZpKNBhfFPu/FG56dPQCPHTP/TngUQBQW44jo3z4NtTzbz8UKPEP5JkF/g==@kvack.org
X-Gm-Message-State: AFuF++mDNQ4XIODZo80aARSpoh8CsVQ/nh8nIn8na0nvhrqpb2P/1IJh
	hMuQn8EeFDyLC9wyle4ZI6Mkt1xIR544TkbB7Xio+RkI8CHmyAyXZFN8y0h4xnNhJZA=
X-Gm-Gg: AYBFou1wt9FqD2H0g5t5dVAvGzqMcGAIFFYJ7Pf5dvqr0wNAlDbDEMCJPtslHb3U7x0
	F5zGJ3AsYKQVkioSc0GwLdjlA7ICE6klVJMQW/Z8oG02YO0xUJPUoT/Mvr7flt4Wgonq6Dk1hM7
	+3+3fvFARFLPQYahLr2ktj2LAoG3iUaQzqc8Ly6bUlDWjGxl3h3d+7AtVjCIpIBfYDkiIeIxvCr
	nRAP8UmvYSRKhtRXmiEyRcuR636Cq1Pp8ajm+Uo6nk5ykRwwbs9JpLyuJ0lFqoGABX7YRJzn+lr
	xvDh2itF8cRgi+P3jc0khQDamMapjpISXls4URXX/+i+rsmX5w+QNwRgcnHboT6gYLb7Wfp9mUs
	N1nMgTMDMSMPxMwm7ygg3LwjUdpn2kpgIawYK7DjB36MJ2xcEcZT6e6eAW6nSj1ttBoXOC2JC9t
	j4VsifqT5j3Gl9pCGLPkTpJr2qiJ3x1xNYtlqvsuOOOxUPnyREMAWLWrOtv8LLIUlnZi0JPaPJ2
	0kWsZOSLvrYsLGcCDeU8FyGJDShpiZbTW0QFg==
X-Received: by 2002:a17:902:e809:b0:2d7:4b42:9352 with SMTP id d9443c01a7336-2daec60af43mr22931655ad.3.1788317824344;
        Tue, 01 Sep 2026 19:57:04 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:a1c2:77c:7ab7:f9a0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07bde5bfsm2066469eec.27.2026.09.01.19.57.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 19:57:04 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
Date: Tue,  1 Sep 2026 19:56:58 -0700
Message-ID: <20260902025700.17975-2-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902025700.17975-1-kiyer@crusoe.ai>
References: <20260902025700.17975-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81F5AC0007
X-Stat-Signature: mdoa9na78tek1apdyat1bgcqpxeknt4z
X-HE-Tag: 1788317825-912408
X-HE-Meta: U2FsdGVkX1/EsilCm3A32rolRkAEycVvm7oCL0ej/h2ifCM1UIgkdWFj+WeQfSCqX6rF5H3nn8RO0RuwzFCTLOIkSc58W1rD1tR4oNLPvUDRkytP1jO1aE0/LBxm4S9r1Op08TIoSq6+UwkxBtdtySw8M9LwcOgTWL/mf31yDvRoiMDDjN6MgDNBsrGTvofj2h4y7OqTzWlc/5iry4r4j3mPLOPRu0SIQJuC0PPhUjGHPO8UxTlSfXdqxeiBLV1uOFR30grG3eIMo8r/RtFI/IDLF0tkQSndaxzi2H4iwJlPY3Knt0A3uvYXSyjb0ixQgU06Ee/pwm88qADILpvmkovIuc0XuwaMCmac18G/CUo9BUaLJOQOJ+4sbEeQIFUtj8Tj2Gj+oSeOHGl9jPZ9BfYfIvdDswUwsdZ4GqJpuaZOgxjjtOUbMWxTtUwISA7D4Bw/msBI4nUmFPn+qKfPbvNDA6H6x63ekOhovM6LrLJiPoP3HO4tWxxofI8eQo62qaf8tVjbspKqwYD8R5lwFyRRLGwFWyvsmb5bP5zRhjuuCsWIwsZNdy4DvxkEnIV3BeGlPvSdWRFZlxhEmZC+i+xo/98DI8GJJDLufi1Eg9piDcSZlR/Sdtb46et9OLBN/ixv4UkL0OM+2gZUWWOExVkSnEnu9lB607TNowV32O2BF09ieLQBZuKTmEksjUpN9UGOINF4n2UKyh8/eDxvWcAdna0TEfgkNKX1+eJcpo/Bw9A0x9aiQQbC5SNK4N1oDESlH+GWqMhuTxBba7K2lwhpyN6xDgHRkYgY16YkO0aV+mGR6u1nmIHv1lSZkFTaMhOyiya248Ox+WZ/D7Tplt0oEj9zpepE8RglA66L2QtDAEzdon+6kcCXJUiXmQo5h/TawFI3o56CIiOhDLXJDEuxW4JoGfQWdZMR+lQHDERdBxkzD9OyHkAEtc0jn1svduxtkCaSsXnp4/PpL54
 1wcA3jrN
 nEmC14eXRXMKVRunTi6DZ06NN4aYt8jWlCy/jD7v/qm6GrhhUyD70eAIWVvXFDlwnx/yuGbFG1dYFTffY5MoMfMAZeCui3V8xMshG3lxTp3+AlrztYIhb57NF8C3ZOmRZEgGrg3M/lpFoKWl4zE7ifTI7qD0SWfRNyAKfk6sEoaUSjdP2IhWBz4fTsb0AKs3ZJ4gMXBKd6PyGqek8DTJK1tyMQ2cpP3dYfJkluJ2zV4iOjKHwgVcxhtssWC858mUIWQ2JiNYIneInVqZ3tptG52KTbWRTEDR1ZEfisY51doF5PV6V8+dMGWls3F4YHEhEEKuHZ2lWLpKxwkyuTcxlVD8RavAk+9CCREr1j5yWjzek5zIvPbA9OliPags5/+g09tvO7npgSy4tA6g+HVG8k63wzN4jqTYgYXo5idjkd7xmVfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_hugetlb_mkold() clears the accessed bit of a hugetlb-mapping huge
PTE and propagates the aging to secondary MMUs via
mmu_notifier_clear_young(), spanning the whole huge page size.  It
currently lives in vaddr.c, and is thus usable only by the virtual
address space monitoring operations set.

The physical address space monitoring operations set will need the same
logic, to support access monitoring of hugetlb-backed memory.  Move the
function to ops-common as-is, with no behavioral change.  A follow-up
change will use it from the folio-granular rmap walkers.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 30 ++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |  9 +++++++++
 mm/damon/vaddr.c      | 27 ---------------------------
 3 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index fbda70d8ea4d..f5fe92b825bb 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -3,6 +3,7 @@
  * Common Code for Data Access Monitoring
  */
 
+#include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -98,6 +99,35 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	bool referenced = false;
+	pte_t entry = huge_ptep_get(mm, addr, pte);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
+	unsigned long psize = huge_page_size(hstate_vma(vma));
+
+	folio_get(folio);
+
+	if (pte_young(entry)) {
+		referenced = true;
+		entry = pte_mkold(entry);
+		set_huge_pte_at(mm, addr, pte, entry, psize);
+	}
+
+	if (mmu_notifier_clear_young(mm, addr,
+				     addr + huge_page_size(hstate_vma(vma))))
+		referenced = true;
+
+	if (referenced)
+		folio_set_young(folio);
+
+	folio_set_idle(folio);
+	folio_put(folio);
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
 #define DAMON_MAX_SUBSCORE	(100)
 #define DAMON_MAX_AGE_IN_LOG	(32)
 
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 38d295488fa1..f7811c9c7a02 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -9,6 +9,15 @@ struct folio *damon_get_folio(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
+#ifdef CONFIG_HUGETLB_PAGE
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr);
+#else
+static inline void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
 void damon_folio_mkold(struct folio *folio);
 bool damon_folio_young(struct folio *folio);
 
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65..15379d984689 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -293,33 +293,6 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
-				struct vm_area_struct *vma, unsigned long addr)
-{
-	bool referenced = false;
-	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
-	unsigned long psize = huge_page_size(hstate_vma(vma));
-
-	folio_get(folio);
-
-	if (pte_young(entry)) {
-		referenced = true;
-		entry = pte_mkold(entry);
-		set_huge_pte_at(mm, addr, pte, entry, psize);
-	}
-
-	if (mmu_notifier_clear_young(mm, addr,
-				     addr + huge_page_size(hstate_vma(vma))))
-		referenced = true;
-
-	if (referenced)
-		folio_set_young(folio);
-
-	folio_set_idle(folio);
-	folio_put(folio);
-}
-
 static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				     unsigned long addr, unsigned long end,
 				     struct mm_walk *walk)
-- 
2.54.0


