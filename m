Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A130CECD6DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4218C6B008A; Wed, 11 Feb 2026 14:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352F06B008C; Wed, 11 Feb 2026 14:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A99F6B0092; Wed, 11 Feb 2026 14:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 067946B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:52:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 382A91605AF
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:51 +0000 (UTC)
X-FDA: 84433223742.13.17B46A5
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C77C1C0012
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSqwt4V7;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4U9AcPwf6eZnSFLQLBgOYPeBTOa/PXxHfyOcSPxP5zo=;
	b=Vf72zYOX4r1rJ8/chrVpXDA1pfZZt0nT7OsfkrqPYWS7yb1NAw5f+tIY4ogX2Ei3w65I9G
	PhyudVwIlESJ5DeZcosRHoqFqOLmdjXGiPkvHgtwEfu7jh0fLig2DHEzjVmpx+luw2Q0J2
	83BJc3B0GlBkkd+uGQKep1v20TBkFtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839569; a=rsa-sha256;
	cv=none;
	b=DDSXV+1UzMIrAcdX/IJTHEIddtrfsLKYhm0ospICLx+3LhJQorbpSXAhMPxI5tWvXFNP2U
	9KVqculuRrkWygA/HfJ+GTP9KaI5hfRtpsaLgoQqgHD/XU+k6OpoI/x3LVrspyYBPFkH1O
	VL89RWI0iMmnuPsCupoR4pfYG24Rdxc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSqwt4V7;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2baab3137bcso72238eec.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770839568; x=1771444368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4U9AcPwf6eZnSFLQLBgOYPeBTOa/PXxHfyOcSPxP5zo=;
        b=TSqwt4V7F/3pMf0/5yrC5kWL97JLr7rOzb+Rc4v8cKj69WrHhnSfLmRjTWs82bdrrr
         AJO1Z+FkDnLIJYyH4uU8PihR1IP/CeYnQMLc4URCnqlItsFZzl/aL+wtlzkjVGL7Gtci
         ZylHQ9yWCkvdXs7a8f0O/QPPTs8MuX88tpdoSGaeBpbbuV/VCDz5C5rMxhLPJ9p0C4sn
         xkNbzbu36SHk2GkekMJOHA4YN8RsF3Be6xD5RlR065H41nnOWAOtjkkpyiJsEVTDpVN7
         DnzY4FhvPybVe+Z2GZFX05e7ijyOP8SPAXw+i5OOzWYCfXxXTTj1/1jVMxNNxA4Rdxl7
         khDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770839568; x=1771444368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4U9AcPwf6eZnSFLQLBgOYPeBTOa/PXxHfyOcSPxP5zo=;
        b=UYNuvxqA0pZ17vN2kiBNNjGCcgT842MAREgcYRo9FfyjsU4aFZ8I0u0HSLmVlIaFiW
         R1GOVMFK/Xp5Tkqq3f3IXOHx1020uyqDdgqUzo+tOUlGv41i1cZUCCy8L+DO7WZwPlz3
         4cbhUB41QC9gXiQY+ivPOGT8p+o8QuL0gyKnOGth/SxWyL11arEoxsLYuu3WanzEkZ2m
         XnRj4F8Q4mS6qRauYoV93nNp6WvZTfDpL4m4Qz2YFqd2gky6aeF7RnqkRmAUsAgSns7z
         k6YbtxA+/Vrs1MPKt9WMcrddRsXW+/ZNkAqZHYWAotvyTyYzhdy2jcnRusDxsl5MLc7Z
         G6Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUl5GzLqkyX5pz9conG9dba1+H+Q92w+lXUPES5aX9xKrfA9hFwVjKjGG0iUkw3k30TGSaEVofEFQ==@kvack.org
X-Gm-Message-State: AOJu0YxNnIkevcVIhvc2kXV+AjYt1T0IPHxuxf3HLKYA0GCUzxq9YeWG
	C5LAYHQj6Uz/gJ6kGbpVWKmFHtksWiAGLUb5Hq9cLjcY7XZ7cnlJ8DX4
X-Gm-Gg: AZuq6aLq9JndaCc0TWnThEkgYoztnYGb2+eUMVdinHQZbXJ8pkgW4PipDFaYDAAecYT
	X0BBxS2ANaehhwq1T1KjfT+30HSmJxNZV/BpSkJjni7RW7T/xGU0iEdf20vii+kwMdGpVU3ruUp
	ErIopWxP31EadtfUAsbctDgtrSKgn5Je6tD/MMjsGS1tBCsXQ22t72eaJiQA9XdNkH2GFaOCkzM
	vUFUqIUDe7y+1aP0C+NnqhOCAm3mR4j4wVZws1ooynaw4f9lP+Gffor4xtDbx7XLqdt6hb9BESN
	nWrQmxGHxriTzBXWFOkqQmTrR8JXU5J9VOlAH7zxneFgslduoj4LYVPBCosEzRB2eQc1t83G1RF
	61u2ZA3i6Dfs/Vfa6SanU7Gl88aMeBe9ZG4+h91fF0vbJvWk3OdaqRQLmAXsk9wv3pejbDzIgPs
	Tz8DKt/mxa/54G/dY7vkgiTOjkk7SpY/4XIkNhxZs2YZasi0b0qqK3nSY=
X-Received: by 2002:a05:7300:cc12:b0:2b8:711:ae6e with SMTP id 5a478bee46e88-2baa7fae41emr212685eec.1.1770839568020;
        Wed, 11 Feb 2026 11:52:48 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2426463eec.29.2026.02.11.11.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:52:47 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 2/4] x86/mm/pat: Convert pte code to use ptdescs
Date: Wed, 11 Feb 2026 11:52:31 -0800
Message-ID: <20260211195233.368497-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260211195233.368497-1-vishal.moola@gmail.com>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C77C1C0012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6dryuomb6poxf68uufzw154p5dw1nse8
X-HE-Tag: 1770839569-93389
X-HE-Meta: U2FsdGVkX19LzNLWHtPgF7BfoMM2U2taQwsEENUdz80DBiXBTZVQuCiK2kphhMiUOrGa1XkGB9PQJTVWkiIyelsK3QnbA7b+tAxdl6w2D2JlpHlW+S4Ogbi5rk98WVLmou1C6+m4cHQiKBexkMqOzwSaWulQ426JB0UZALKtJ4lN+BPlz/XOi59vgXJBmOZQT/OetUHNKTyqboO5zSbk6bie4Oy+4iR8BieOO8vDNwNm4mRnVoVflWjFuhUXuD+1lP6U17MeQKt/BUJX607gDaKjC8VdrBzKN6T0BZEVkkd+4/qOLVsFVSNEypp0zqMBllo8gk9K5a0OXHnLrPQvNUjZMpy4bSr/TqT/lM6eGvptgLBXQRDD3GqBM0pOD4SWqUcfTdiFQO0S1ZkgFdP7/dSz694klrsZcnK0F9OuNhBIwQ2uqgxEHdl8PZJzMUI5hKDvsUNC0mNVezuUNZ0HYVeaU+5L9w7GITMrTHVgshiLq4eGzVXtplyU1qMiHGnh9QFz4/vWqVJgCEJkePD0LEvgHsFwyqNalVOjvVTb8D7OKcstbtSbVjONEwlmVZ/qI3lspeQOkVrX14em1J//FjPdu1cNiEiGtZih8aIEjIw/Bg1UM3T4n+5dbAAfSWJegj02Xma/qEROQZ/WanBT0JUfObA9Bmm+QLyQtDRX1EW9bHsvYCB4915Ddmo/E5TfQTVlLBYpA8YqYYKiDRWzyeA6Ngdtqw6KtfdxSyiaAyO/hLmvKLpkKK5HoIseMEte2WIyy4E6atC4B90MOCSS8WZTgG8jD8KKLCR0n5SlcjzsQocUZVtw5+I7r/AP37rzfuLKVWwtolzOjZ95OglXGfH8ngpAsR7EOO286EcBELDjqWXfW6wL5X/T/bjR1dPRpflYMSCyqYUXPNKmWsmktBbUMSJth4ny1cwnfD7oHHpnNpdaWMoMKcyNsDFGUWrQzePUVbl4N2hA66ZleV/
 09h8XsU3
 goiuBNCwHGqRXw8VLaJRYVs7hI+Lx5nBExeQCT9dw/u4t2g1QHMsi4zvEa/4bwuvaZJ/ic+UWxTJjUOyWnRqDW/5WRJF2kgfhkkmLxe1Hcd7zz7B3rZkrCsneL2KbWaVx4za3uT0rWakAEvwQ/TrRI7MyOdF/GBDyVOGMKCNioYVFSKJL32/5OQTFEn7Qaub+7XXufSIxqTNaYzPttSyuWbUKFQ1GY/nlhrDDrVegOcUmwvX8pgi/pn6OSdEqd4KjbAAPjHFCBjEWQzQkkyaN8Riz60cQz2STCGUXfOugBFk1pzjB1l5KmVeDpl/m3z7QoX0yAILUG9kpL/7N0DL0zklyLsHYXNzXeRXD+X48Eor/47o9GzbKmo+4Zlo75QFD4bsv7HPnEuN+5UM7xbuUa5Y2RD5NzBPInKqrj85v1nQHTMQDxFuLLvaAjMZExoewAk+PKEwVC5PKk0KDuQsPRt4aYtVuJLnsNZ+7NYMgjyUm4sDyBzqCJ7ZXacPUOkyymaDvViZA8mowNNYmB3tfwlx/U8xAFeWOFF38ePr9+Q7SETWNIR+PBxRlz0t8+IMhDpo1aZ/VeiVprlCbOZ+CpkgHZCf4mGlntfwr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert these pte
allocation/free sites to use ptdescs.

Also, rename *_pte_page() functions to *_pte(). Rename them now to avoid
any confusion later. Eventually these allocations will be backed by a
ptdesc not a page, but that's not important to callers either.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..04eae65aedfc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1400,7 +1400,7 @@ static int collapse_large_pages(unsigned long addr, struct list_head *pgtables)
 	return collapsed;
 }
 
-static bool try_to_free_pte_page(pte_t *pte)
+static bool try_to_free_pte(pte_t *pte)
 {
 	int i;
 
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pgtable_free_addr(pte);
 	return true;
 }
 
@@ -1435,7 +1435,7 @@ static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 		pte++;
 	}
 
-	if (try_to_free_pte_page((pte_t *)pmd_page_vaddr(*pmd))) {
+	if (try_to_free_pte((pte_t *)pmd_page_vaddr(*pmd))) {
 		pmd_clear(pmd);
 		return true;
 	}
@@ -1537,9 +1537,9 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 	 */
 }
 
-static int alloc_pte_page(pmd_t *pmd)
+static int alloc_pte(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = pgtable_alloc_addr(GFP_KERNEL, 0);
 	if (!pte)
 		return -1;
 
@@ -1600,7 +1600,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 */
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte(pmd))
 				return -1;
 
 		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
@@ -1641,7 +1641,7 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (start < end) {
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte(pmd))
 				return -1;
 
 		populate_pte(cpa, start, end, num_pages - cur_pages,
-- 
2.52.0


