Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D3DCF65E2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0D26B008C; Mon, 26 Jan 2026 19:52:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EFD6B0092; Mon, 26 Jan 2026 19:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6757F6B0093; Mon, 26 Jan 2026 19:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 236FB6B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:52:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E19801A0980
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:59 +0000 (UTC)
X-FDA: 84375916758.12.30CF765
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 12C4B40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DRGMBFBi;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fGoqbwT4SjXoU4Ig+gNnQbra2LAJdAisEyMpKQBMxg=;
	b=0UPBBWFkJ9o8wUr+rqwZ1rNE9WRcJZdl5TVySG515xKefO0+gVj4P+Y8xQnBkXCznZPAo+
	HrtGE7SO0a0+HkMedykWU7VeeShno6PYOEawY+m4auKf7wR3P/VG9xM7cwslHQY9har2P5
	CnlAmbpMxkvnJe3ewgsDnrTWmf3ctk4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DRGMBFBi;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475118; a=rsa-sha256;
	cv=none;
	b=3+rsRllFvM//9bSysTv5D6XEA5gSkXOZxZcfyaaCsPCpqlRYlRFw+ZhcGoQyPOQvUpwz7H
	1qW3rYncH30UY4sRR/VM4iQZ+R/SiPo4YCpY6l/srB1ourgMTb93cswe7z7xbYk+i3lhIG
	3XigedGUAaP5OsLCVmPpbF33+kg1vh0=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12460a7caa2so7295656c88.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769475117; x=1770079917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fGoqbwT4SjXoU4Ig+gNnQbra2LAJdAisEyMpKQBMxg=;
        b=DRGMBFBiJjoX431PzASyVTPC4MEJUa1Za1slWp22OYxUfupDUb3pUJXNifH4Y8TYEx
         vDjn+ZjxSTqbZ18GCJ5FEHXEkoJMLedlTdcAylIaOZJGdqb7ljUHsGcuby8bA8SELra7
         3+SqjQsHpkJ2ASL3i/pWLEInpWS+QHqM/FnOqLOUJ1vKaSGCvKt3R7uxVFFJTVhUQ/vz
         G2+Vf9zO7tlj7MNbLTY1Lczmpb3k8ailYijf7/GgujXhudj6YcN9kMzg4ILA51N673BP
         XbSsGScB/dJ0AnYI4cOZUilZQervBhpBuxMnb5pgc+hPQFEfAts1ANA1cUPghePYVrKh
         /hlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475117; x=1770079917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6fGoqbwT4SjXoU4Ig+gNnQbra2LAJdAisEyMpKQBMxg=;
        b=egn2kj0DkIDkIIu+mnuT3W5Wek9ZB/DmWcVDYpHr7v+vwsXGat3F/TebBeTIwqCdUl
         tidjEHhXSQYmfUjutSiVH35SrfmIfkkRUlwPvgGrJoWnYDSZ0hKBWrpBqghRXQpLxD3y
         HbRZeh4txIJJencOsPfXb8Eadt4m1+aATtl1QPi4Ib5puBDm6pxm/fq1Ap6OQkKHfGnd
         3CY/9IdWXtro95lXzvrN6v9WIyRQQS35aIt2ZQQDr+q0+6WN3H2iilwwL2Qe+4TvvXqD
         ZKjcNodGE1QBAfebqVcC/VcLKSqwDO1eeITAIHceA0O9PkdUpt038SteNBMJXmnQeMyb
         v55A==
X-Forwarded-Encrypted: i=1; AJvYcCVBj01dVarbinSbxXbSpJ2769QYoVaw8BRgWL1l54pmH+4Z0o3FluSkyjpAyAUUUJBJNMLDUrQkMQ==@kvack.org
X-Gm-Message-State: AOJu0YxTY46CKeFyvWeaXmO5BjR+zpcvjNR9ZswG4UDZmXjoxSeTK/pc
	iO3epouK6WyGnHj3x9NYBq0EYzwQxuOYCTgD3aOMO2oSm9Moe1sMHQt6
X-Gm-Gg: AZuq6aJqxF+5s7NDDP+u9HHATpNP+BY6bb9+0N11d3d/JhbbcEsvZubpVpfxWzZ1TOO
	RoAz/e4FdwbEJn9CygQwjhfQf8wqPVXFbqD45bG91ja2hfh0+omU1X9ttVL5Gaa1CufOxiw3kaX
	YDAmdOX05uaMy8l264YuPzOJdgXxxf4lWir25YDnVIsG3hiAvj6p+R47hdT1s6wETrtWbZM2tJL
	NU+frRcZ4LZYU959i5pTJaDOMRM03IMtnbua2gg4xlTdvjCPBEwK4qwcDpKcf2JjmVte+9bXQlk
	Q8wJUBgHcEh82eKShVimC/sJQnXYqKGqwInosqttDUq8ck/QJ27uT15unO99hJQDzfwXr/oxa06
	XGRq3V/NUsNJKRPi5MH+bxcNq8TdsdAyV5GgHwsL7QNdKgMMT1kBMdQS8p7nngd3iwgqiY7uE3Y
	1U4gI3klt/V9YgxMNdDfsT+AjWqagMGPeWBapc6vBn1KQ=
X-Received: by 2002:a05:7022:43a4:b0:119:e569:f615 with SMTP id a92af1059eb24-124a006f022mr4482c88.14.1769475116704;
        Mon, 26 Jan 2026 16:51:56 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1247d91b9e1sm22185065c88.5.2026.01.26.16.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 16:51:56 -0800 (PST)
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
Subject: [PATCH 3/3] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Mon, 26 Jan 2026 16:51:40 -0800
Message-ID: <20260127005140.197847-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260127005140.197847-1-vishal.moola@gmail.com>
References: <20260127005140.197847-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12C4B40006
X-Stat-Signature: dp5djbnpyd6fsaqn9z5i89jeoo5yzmes
X-Rspam-User: 
X-HE-Tag: 1769475117-324522
X-HE-Meta: U2FsdGVkX19anKBJPKyoIRWxFG64qiP+RB1ey2BG/i9zMKIkZGKjJ9R0zMTVxrOMA8Iac919ViBcAWwTquCi2kx1l4AszQqKE2LF5LvjX8REUNPcxCUEkg2YyGd+eRXNxBLXB+zwS9H1gZOpWPpf/veUjpsbgME6CCx9itJpihM8PwfUBxCA/n0mvu8WxkqJCfaqI67baw+SU1xlUIXfVyp8ig/sHaEaaB1w839RlxvlPV+RhH2ruPXxsnd0F2+Ai7MTWQGdypdAHN3ULmfxextC+eQfQXkAEX3nIjKuFokKBufOHDXUpwTREiazDRs8dSqxKfPXHC7dCAHI85nNtga8ESbAvUFm5kEFbe7oY7GsA+Z86u/nMVz1Cm4lNL7myCEKRCyjBuYPRWgp19Ihsbi8Z4mWBXQsJQh1jKktdFwJl4tFQl2XwRFj1GlMb/lJczOKtjez5jhzUsiCOz+W112QZKhK0WlUPxfMCYRk51sgB6EPcGY5fsENS07XtBF4ad5IPjUUpzalsfjCdsQJgwnwAMj2V3sKUa1cO0ztdMI/2twW6vJKtVu8GcdxnlBU+DjxZOjHaGV4c9eJCwB9/QbqCrEdV+BBW02edq3MkvwfHyX54X/0rrBZISY20M0t+1aAJ8yLbmXLQxNpuHTUUUnbYFcx33s/R1HgHzYem8zLeSZAUosz2ls8YoJuF2MgKx+NxrBBP1nA92xxFHGlTQ+fG3TJ7ZH5L+TsewkOk+5WdBsdUbKYw0wTTtMs4M+iLdCGbHQiBZfCaYw29JBSIbXxJFMl0ILKDEx3cz0KqUGsc+hmGe4yUFQEsnlErtGMqp/vBimliUnazlwPdHdnSh0HNKoBWA1/3+i0t9ITanjg322iEYPiOMvAUzQ/uYGBj22MWaDMOly2RuhwCVEU3dW73Lcsrz0J+viW6NPxEbzSzDVCLTpLz4u5DHmZXYeNNAacLqF8Txl021wFG/S
 uZZonAEU
 9386qnS/OLbiLLgg2vFwj35V7x56GLcvSTPfomnxNiwZnR9BJf/jkwZzZwPcl+73pV1CTiu9DCg+6M6/88PS4llJ/ICDvXDiZ5eFrlXuIb3HltZhQttf+Ioez9Q+vw/0GtqoM83dPiau/SWozbRexBYAjQALo4hCu2S0FqjCdKLSgvlHu8dJskqEd9dGggau12TxggOgurVBNBKlluTgnUwe9gC2KzEjyIS2CfWH4QgkYkwIDMa7QUcQalAtdPSnynpyH0pqHO3hIszlEo3iDkOYKNY8kg5eT7F7O4uNEQT2nlcVMLXGEahn43Qrv/8c6kJaW3zkGdbWYBoh+IZpbFCmi3EhM5KRZz0oZ1dvrRZGlsH0fd7nmYR9x52wTJefOIzijBcZfwGpM+lsnwXfHkh0rziIQI1FhWmr5OhzpY2MNmlqvWV0EJuhurzOnW5Yr6T9OCx9iH2+v9GVjWsL7iO8Vw4Edqzf9pcwuCb8PUMqOwl6z6ZbSYFIXLFqP6es7rK8zl5rgFaZ7KTNLFz8xOacHn92ejHGSWc6huqS2wmW15wEx8CvIkyft7Q==
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
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ded1ba11c68f..246b9cd3d13d 100644
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


