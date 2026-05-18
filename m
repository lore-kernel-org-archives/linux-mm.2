Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D54CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A046B0092; Mon, 18 May 2026 05:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01D26B0093; Mon, 18 May 2026 05:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17FA6B0096; Mon, 18 May 2026 05:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDE056B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FCB8C2C44
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:52 +0000 (UTC)
X-FDA: 84780071544.15.9A071BB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5304B180007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wKsVCevx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uKOICqlO;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcGx4Sx4V/HTVgnHJ5ps/As51n3oT0tfi46eFvRYM2c=;
	b=gmbS7p+B9BC+QT9qYNcVcUxMnfynKtJIwuYTabGEwR2VEesMWxC2yiq8wLS4b8VVMdo4TP
	gJuEphypgVdysLlfaLl1WBGmsG3e+TCzLXnE0aPq21eKJnzd9DsTdKEAED3lfguv+a+4/h
	fZLvfNtTLI/EQQv3sPZu98+XFYwfqKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wKsVCevx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uKOICqlO;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097850; a=rsa-sha256;
	cv=none;
	b=ydYCn8/vqaUu/pxn8yQwgW/7lh7Q3Pj6rQNf+pMLDKe7SSQtFY0WgReALWHyAEvjbSnmPV
	CtDD8obsU5nRWo6jJh0bkXE+OaUGVFPBys+bHdEUb2QActa0kLcAT6RVzyA6d8jGhgMgRa
	1kRp80Zc+BeuBswQlZAtEJ0T5WXSCr0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcGx4Sx4V/HTVgnHJ5ps/As51n3oT0tfi46eFvRYM2c=;
	b=wKsVCevx7VOo8ic7J5Y6GnIpUnQn0L9Znxg17pzdISsl0boYrPmHO+mvsyZ8aRVdu+USj8
	c/8oNg6qsyzZQGDd89oI4g8BxIDDuylLfkoQauFbtl0ziWrsoEKFuLjZRxTBA0C6HHUm48
	UrL4qu2tXlKNOcGPRq93IAq/TAUMbY/68f5j058AytSuaCGqTwqQxucK4zX9cElNuTVdeV
	B9tkTwrXfgNmx0VTUGK0N97gVY97OBWSkdjRXsq3YFQPsJDZcOhBnplnLBHSDa4mE7tthn
	cXXjryGWJ0D6Pz2g/yNIXsVeciDmbmXYNaCEQ6p9OP9GBNZlHoha8vg29mGusg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcGx4Sx4V/HTVgnHJ5ps/As51n3oT0tfi46eFvRYM2c=;
	b=uKOICqlOG44cpRnKaRSj8UfTZ1u6UQ/JiaK44737DKmpMKeAlomrsHzRNlZqICHaMLMI8L
	0J+QOC5KlkpTxNAQ==
Date: Mon, 18 May 2026 11:49:39 +0200
Subject: [PATCH v3 1/6] vdso/datastore: Rename data pages variable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-1-bf4f2af2b41f@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
In-Reply-To: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=2337;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=J/r1cK+ZTBjrDnGBN/Iaqap5r5bJkvBE95UTLELIr3M=;
 b=S++2zrPBvIfatfiepUfR0/BfRTBAr9fI8HrG2QJV/fPAPaZrWeCfUJ3fTs3yUXhrRG7S33T7C
 Zhi6yhcMn9JD4qWkiG4X6U6zI8049PFb2aQrcNiV+ZfVTW/3CjdU3wa
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5304B180007
X-Rspam-User: 
X-Stat-Signature: wc6ee9xbeim1dna389qspxcphtnfaoef
X-HE-Tag: 1779097850-341623
X-HE-Meta: U2FsdGVkX190sj1tqRYddfpkeH/U7Yar2VvCo4foOlzEdKRFJxxntn3ecXBEIXmVk750lGaJIyTYFNx1GRnZu3QtJbY5I+dmATQNmbOLG0N4qI1XXJCnzP6hQuYmH3s7TMArL887ESsINQtsoBVlZhLnt1XCZ40h4vhavUVJ5tOEMrh8YH6P9z60v/lCupRef9s4n2PJRA2HsmBxhZ5Rl3UwxX5jA+5UJS4fxWvI6AwrC48q2byGBrkz6I7uQAEMx5cMYmT5hSsUPGhPTa9yoHLZVirsot5Gpl2yyWrsci/yEsTQ4+JIkiwoE26w/nUwZ3kEZUN4OwZ2tvjnNEQ2pd8iP0C39E5aa8KgoZXZvTXDWrPPUhYuM3zt9N0xwFrM+4qqHiXbUeG6YRh8exiY6uiGB2nlaNGlVsVSyPfO3nxvYK9t6aro2Iv+X0ACKqT8zgdfr6C7X040k15DpzwUaJaz/rMYEbmE3mlm9uAhOuChxHldj5ZTYgNBaa5dQPwdyqFruFxVeFtdnxPH3fnen8hW7beHQjV0LZxz+YasMWMLErXYQROvQrNGa8EaUkKRlyfsusMu/qmPM/qgUVIOumLLZeEDKB1j8w5zTHEIhlTqkL1+u+ZBWWjfnXshCdtH+Zrl/lgR6/W19+tiyu04rhQ3HSncTEgnnb25dEdHyuqweG8aulGhJ54PT1fRD4HHBVM39y2dtI+vhxOu368DwBOLD/E1fcOac2lE93SZEeSHJrz7e8KK+6p4QjtMAI/WOgKYlMbbWD6zOjkR/WHULt63RmS1v2HMPhsZxlgix2mzjpw7KFQCdW7q0OE4q7+GkkJUtk+544agCPcQsCvBhjhjCOI/CYthML6VYtsUtigfcJkYPauxNPBMfc0hM3NgVSFVnPupYXIfDnUVDjusZsPH7JQgyytgkBN1UwxiSZop2XvTIn5TfsGNrvsChPzrkqVdmwfxbL95B0vuRf7
 3x0LAywd
 Jmj3d66clwTpgMfKg4oFcxjyqy830fRtqOCKgZE7SP6myQuooUDwTlSESELuuuJH0iA+nS0h2bBxaku9KCLneq17ZEy75BSs1EYH3J4wmLNAn1dIOEhbg+0lEeKf2vu+vxzNuPyaK6i7gHdoEURZvDnEaUepR1Cg8VKjLd8anKrGukA/Hqr4sSE71hDVKfKYub40aQ4J4UgET+l4aklL+j3qgWLoqdyrkAfO8sTj2qSYn/C8UV27g/gzjhFe2zqm1S9bioOgRxMbg7Xy2h6YsdOaa4SS4RovEV7o2g30eEGLwhFPhrgHHYaotYH1mO8x6+Za3318qZ3aNIdv9b8j7oDcczAqyw6NFVdFzr7sdVvZK49wYuSf1mZBdJgIkhDTaVLW+N2A8gXjr6oq/1kg1uCTswSenIDxspNwpSfZUutyELXai+xKJu911mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An upcoming change will make this a file-scoped variable, for which it
should have a clearer name.

Rename the variable to prepare for that.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index cf5d784a4a5a..9d66ac2fdb8d 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -32,7 +32,7 @@ struct vdso_arch_data *vdso_k_arch_data __refdata =
 void __init vdso_setup_data_pages(void)
 {
 	unsigned int order = get_order(VDSO_NR_PAGES * PAGE_SIZE);
-	struct page *pages;
+	struct page *vdso_data_pages;
 
 	/*
 	 * Allocate the data pages dynamically. SPARC does not support mapping
@@ -42,24 +42,24 @@ void __init vdso_setup_data_pages(void)
 	 * Do not use folios. In time namespaces the pages are mapped in a different order
 	 * to userspace, which is not handled by the folio optimizations in finish_fault().
 	 */
-	pages = alloc_pages(GFP_KERNEL, order);
-	if (!pages)
+	vdso_data_pages = alloc_pages(GFP_KERNEL, order);
+	if (!vdso_data_pages)
 		panic("Unable to allocate VDSO storage pages");
 
 	/* The pages are mapped one-by-one into userspace and each one needs to be refcounted. */
-	split_page(pages, order);
+	split_page(vdso_data_pages, order);
 
 	/* Move the data already written by other subsystems to the new pages */
-	memcpy(page_address(pages), vdso_initdata, VDSO_NR_PAGES * PAGE_SIZE);
+	memcpy(page_address(vdso_data_pages), vdso_initdata, VDSO_NR_PAGES * PAGE_SIZE);
 
 	if (IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
-		vdso_k_time_data = page_address(pages + VDSO_TIME_PAGE_OFFSET);
+		vdso_k_time_data = page_address(vdso_data_pages + VDSO_TIME_PAGE_OFFSET);
 
 	if (IS_ENABLED(CONFIG_VDSO_GETRANDOM))
-		vdso_k_rng_data = page_address(pages + VDSO_RNG_PAGE_OFFSET);
+		vdso_k_rng_data = page_address(vdso_data_pages + VDSO_RNG_PAGE_OFFSET);
 
 	if (IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
-		vdso_k_arch_data = page_address(pages + VDSO_ARCH_PAGES_START);
+		vdso_k_arch_data = page_address(vdso_data_pages + VDSO_ARCH_PAGES_START);
 }
 
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,

-- 
2.53.0


