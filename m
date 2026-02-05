Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA67EA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2FE6B0098; Wed,  4 Feb 2026 20:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470606B0099; Wed,  4 Feb 2026 20:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3290A6B009B; Wed,  4 Feb 2026 20:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF7D6B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:35:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D214B13A9DF
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:55 +0000 (UTC)
X-FDA: 84408686670.13.4F3CDC3
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11AFEA0006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7YeZDap;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770255354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFN9WQ43/aevrauLhpt7dEPveYAFUArl8cBKZr8FsjM=;
	b=BBq0N+UOI6QEhzEpNfEcGF//A79PBmB3lfe5g2J9UQJINQGHfIzmFeWipamx4nQfstNaLz
	BAWb/pMmZvfgCw1iZFtJJIDm1Ff9XUxlVmA5OMhEjuhmK8vxCSXmL8YY8xuBgGJidOoIFI
	c1GWv0iocZPv/B/SC5r9cfw2QeiOTws=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7YeZDap;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770255354; a=rsa-sha256;
	cv=none;
	b=8Sb6VZjpQ4G00IYKF792TJM67kWFlTQgrZxGQSQg+fHqAKOtHNsDYbor4NXpLWz4AbyZEs
	LM+sgWkNKRVwYzV0FruxcCTRbb4BJOQuMdfHOwyzCLxHOgb+M9iLc4Dv65tpjARGb84yBz
	+SsupgyT9UGhvk9p53ue8Kie3ayiwuo=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b834e17c3fso374934eec.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 17:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770255353; x=1770860153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UFN9WQ43/aevrauLhpt7dEPveYAFUArl8cBKZr8FsjM=;
        b=l7YeZDapRCmFXc7kkoF1qO4rnu0UUKUm+mTy7p2Q01H4+ObNvWam+tt/KsMt6D5BF0
         GNxcHFFjpbL3JzxLVs3I7z9xrYMTe6soYOh/A+LCncACRkdTczOkCmmU32oMzbCpDHPy
         b+pI6pWF38qvMzAspOLdCtQMwiLhW6r26CURWgMy0TpZ98v8sMfeCEaEf/Fll3ydooyK
         tGcacAyVcioKW1ik/EycpTxnb3kkotdD5dKIznmJ8OpUTwxnOoZ+kHS+ubhq9fuCaTLI
         NZ3t7HWv6az3yVBHC0DY5rH6xiEtqaUWgTI6wzGinBS2Y7GmDf2wMxm03lmRizbZV4KK
         /tXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770255353; x=1770860153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UFN9WQ43/aevrauLhpt7dEPveYAFUArl8cBKZr8FsjM=;
        b=LlUtbtkV158iL0UvwaQTL/+UZNTgBm7DtBWjO2NyKbmCBsw2AntotOMB8BZwmkj3kC
         L85VJPRv91f4bKgLH4EhOrI+q8KaUSfunei2S4narJ5jSpcseFlpFyvhndM08dAmw4Dt
         OTEh5ADHE28UkbVtdAwDW9JqvrYlpToP7Rj/OMKKibg7k+0amCRi0KIhmwrDPk/NgAWK
         wNsdpwNRhvKzZuwTkkdGrG/Eo1xqfMvQXDZBP/pzAj1Rl17Dg/LlJ2AHnn+68xJD3Ruk
         ZnNsfBMVDbFwVGL9OBD8zsLG9Uz7zLcoIKbdWdonE0zp6CTH6H6jHd1IBF7svCQVkiBN
         FfwA==
X-Forwarded-Encrypted: i=1; AJvYcCVq8fk+AKQlSV3qGrjyfPN670o0QyBqobau9M8aIO5Fr5uvY80/DlRg2AZsk3T91DoVxlFLUmG2Ow==@kvack.org
X-Gm-Message-State: AOJu0YyS7UgGcew+nq8WPLYaf/6/toEAxglCHw1dKnG00RPonJvs+xx3
	0wKMTbZBinpPLahg3ogdTczRg8Uyubqdc66pT4/v/jrTlW7t+ClFWJkr
X-Gm-Gg: AZuq6aII2JA9v/1UgKYQw67skoguHLIKP2U9sbqSHXCResPrYjaftGkZLMmXyg2cRZI
	WkDVEIPRvuOmirma87V49GAC0hMKTpocGnxTC+igK9bNkdZJSWPTVNfNgwbglE5XbG3kV3Esuxc
	y8wlr4OxoUJYfjMRhX2YWo7xPPgHgBjs/HhknCsqnNMNmpG4Dh/id06UKMQizyJsqM12isOq/e/
	+Ypaup4TpxHckTaJLKkqOMbCxiBz81SqdYOdmlJghzJqNA001xipPJ9nfyrnjde1A6iiI3u7Yf2
	MltmGmJXbX4FeD/WkB+Ov6X1kB2VMi2FZUvmjfXHM8FVTDujoxRit72jivx9c6VucNisUmd+F2J
	oykn/1hL+QwBe/eeLu4Z3gGKpRb/Net/Y3zwUGnxdIF5DoR+dSQjo9z37hIqZgJd7/bPec9E1ZE
	FUBLv4IqAlYaGKHz0/3wJrwLbTsK23O3S42aFYUqYSnbVFVW5X9jdpWQ==
X-Received: by 2002:a05:7300:7fa2:b0:2b6:a622:25f5 with SMTP id 5a478bee46e88-2b8328950b0mr2058646eec.11.1770255352786;
        Wed, 04 Feb 2026 17:35:52 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-126f4e0f98asm3424982c88.5.2026.02.04.17.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:35:52 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 4/4] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Wed,  4 Feb 2026 17:35:27 -0800
Message-ID: <20260205013527.322157-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205013527.322157-1-vishal.moola@gmail.com>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11AFEA0006
X-Stat-Signature: x7bg3iuegpajjmunb5ihp1jsptxrogjn
X-Rspam-User: 
X-HE-Tag: 1770255353-41944
X-HE-Meta: U2FsdGVkX1+y9nADS+7RWChydCNYCM8OxkH0t6GHKrIFgNbPhgWEGIhm/2DS9yOkXmBJewwGywP0FFmjgXFdP0xvcK12+GOjH9CgloQtV0ikDTwBgmetOOBGML0db+J33chBX+sCkevZUviaJ5mxiDCstw2QZAwwvTcVMcQSb553ZtHd9xOqkuOyaCPIPcRgPwt1ZIvr8sslpZuGoGQuBYQ6GEPlTit8rFSnYF78qqP2PGhM5MWJ8jecnb1sNg3RlNnoIL9ShfyXkc0Hg/kofQE+VFTOCCP2mMvmurzeodi46SjfMN9kbljECdDrAqEVBulx+ad7tHJ46/MwGf8scsPLTR2baAN0tO0sUGOY52I8BRv//vyU0VvxykT+lKW17wJ7J18cmVFaUL1jsKseYERzQ3q//2SQK+gJlSY1pPG8Rab4OA4Z9jlCjZRXgLHTXlLuhz5H0pSoFXVzg+ToxelI5sqa7C9M2+CWOp+0u7uRKc6Qwi8K3qWTk1diEWMe37R/nE3GV2JPg/okay3Wl9bZWTwE4dMIpyWjmwnKRx1paIkf4x5H08LJLi49GQEz8+A2eT9oPYPn2e14Attj6Idc9s7Ab7IJ88W8+a4tdAleYODYIhrwTDQQD30DTec7GA1+ySYAGN41TCQrZdGBJYEm7iJk7D57ZHAcA++OL8dnSmOj55AEDMMPRR/8SM8Xytv0eRWA7x4iUEBvI7g4m+F2J0cqiCl4uan6Rxre3IIAq9+57solypIfi0JTTaO/x8U3451dcOPEinwGpsaP/Mw5YF9sGt56I+AjoF5ur3hKIM0JZIb7g3Psg3VtROhVliK8l89wNPYb5MQGB1PtbwwrKvLpJqtlwU0bjRm3FXaJOTMRlTO2sbyIgpMhzaLbUr42lW0PCM98BG+eVhdKmRlDc5MNa41Sk5tdC0AAvwk8ARrXnfDlL7pMH7Ympu44ybtIMhohlmHLkCUPdUK
 WbRjOBhM
 YUPzHsBxZSvgxJRPyk7qAj0RA9HuBV9hMXMx87RU4zceWns10WTbjeIksZPvu6zsxXNoufRI+k0GUCHVPQA2cYltvNP996a550Tn/U4ScW4M+eXV+v7eeHhW+ZghQEK2QDUpso0tKGYfMn7o6ccIfEq+9BwHld4tHDeJnT6hSkizgGfkQ86abUR8Ruh2T0Nicxi9ucrjJSWK8OcJn+YF36+2llN1A5THSon/mc98yXFKfkrSUajCi9IkgY50MqHzX7l1B3r0LMP2JkyuVQXfWxutqQUmbIe3dLaZd986gfBB2gMXatzVY6o/r+NyTcI4WcIKV3X7xwGMFpNh9uLVZzwzC9vIUFz+W8e2OT6i9GqRuUMsy+uPnR5drqd9UjvqGfCSbJaIDWmcEB4GtIk16n6ZGirVLRanqeziHnVLk6No2mQ3MsbHfVbf/BHtwi99Tm3kWxMDNnyXtE0fx8b7Hv2UUmTKFKbrB6FGksa2868ubI1dUIRDKhFNFfM4mG3+EYqL5MBO0jAjBg5NSaQGq5T/2Akg58C3qP/4xtTZIzy99NfNAknMHyJfOS3nv3I4XT+1fTk81qqTqjEbx6gocjXgZXr1ueQPx8hozxyOAgIe9WcIRBFr4tVkxvnfCLgRk36xUKlC9Xlycxqpppl9pt+GDfX3fPC/ls6+sx0Ecm5dOIdOf3ojMJF5nyTKg1hoeLNg7Yd31l41rhas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions.

split_large_page() allocates a page to be used as a page table. This
should be allocating a ptdesc, so convert it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index dfe05cdf460c..dd17034a3c58 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.52.0


