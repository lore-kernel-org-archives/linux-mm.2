Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A76CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8451C6B008A; Tue, 12 May 2026 15:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CD76B008C; Tue, 12 May 2026 15:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759296B0092; Tue, 12 May 2026 15:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63ABE6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:51:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0EFC116068C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:40 +0000 (UTC)
X-FDA: 84759812760.01.D885D64
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4573618000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FVIfkajg;
	spf=pass (imf06.hostedemail.com: domain of 3yIQDaggKCDcldaTpTcTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--skhawaja.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yIQDaggKCDcldaTpTcTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778615498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ljg+98L2Wc2yizBAt6Gvu0fP3XnfuPS9FfSkO2m0vXM=;
	b=voyWyNUI7S7PTXtrgrjFxdaLg0HwJJauTa/JaebHujepVs6X4lg3UKP1lcSdTuJ6HFvwYo
	yXV+1yGDuBsbW627/U7tT4R8bWC2yhTZSDxKljZy54Z3Z839h1K8kWG6j18gPrU4xwTZni
	2UbvjxhV9ah7BMjdLVVR+NhKZY5mCm0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FVIfkajg;
	spf=pass (imf06.hostedemail.com: domain of 3yIQDaggKCDcldaTpTcTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--skhawaja.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yIQDaggKCDcldaTpTcTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778615498; a=rsa-sha256;
	cv=none;
	b=zzxAr4u50XgaHg6imXacAUhottezeNCJcK8l1wfjcMtjkWcmDJp88gRr9YX7EYHp5SFXF5
	IUqDMVJmP6igxuXpHi01QR+4QZumiq+c9B2Iu20VFFwSi/lqZx0/8JgCqCBLp/FBjvwIdu
	flF0Le1+wrwWzBK1PfH/04dhrwWFfV4=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bc977e6aedso34273955ad.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778615497; x=1779220297; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ljg+98L2Wc2yizBAt6Gvu0fP3XnfuPS9FfSkO2m0vXM=;
        b=FVIfkajgiIwqbEQGoCTPCLn/bmQZe18pJg33eOa8aAE3Tu1ykL86LTSNHj/8mzVsyA
         N6thPu+hNlXxjiT/bcjvdJWSV9kbv9mFZZ7whaKLgpDlJErrgJAHEm2B4fR3KcT38Nbi
         bK31qZ92ch0acPoqUyBLJ4TKzPF/fKhzldj+U4tXbi+hOkxDR5UXtFBF9icxVckxa04Y
         nmR/F2D1B0usiY23FOxALGBBRmcf4CurtISUCCZgEu0qMw2QskCH0ks6/y0DAZFwy+c/
         V+MEP5hbFGDPPeZLUWHLkW6TVkvSL69M/VhEbwBnMda1jay/+kO2WZp2IXDZNvPMFmvD
         Q/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778615497; x=1779220297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ljg+98L2Wc2yizBAt6Gvu0fP3XnfuPS9FfSkO2m0vXM=;
        b=qKHgAhXa8JHwNmF0i0SMEH7ycsva6pVPYayqWvCHje7e97QeTstlyijClk/KvpxuEL
         EXD4q4PliqHPaijXoc2vRiL5baQ4AeW1pcbGUrdowoV37sl5biR3pkl5Db014UMgNXYn
         N2Ixg5h79yZ1Dfb0AtogXF6wURLBWAuykDrHXQo4ol6wAKJeVWIrMdTP3iKDuMyD08zw
         KzXXgCNoHufoU1AzZhHnRtvi2ga4R8D6hf3x3W+la/I1Tvw8wzDInxWimc/xyvvTp9VL
         mTJDbinDJDxNEDrEEd0nPXzB40c53hC0igG27BrRUBiSk+XotA1R12b2M62HgASHot2H
         8GvA==
X-Forwarded-Encrypted: i=1; AFNElJ8FpKtPaEZqlEcOnkR2WU3A0CAhRpRRT/vrF3cpg9gEuIzW5vRJmroTBY5Nl+H+rB1OnQBxhhOMlw==@kvack.org
X-Gm-Message-State: AOJu0YyolZVdj8gAkOJ+uDuY0/sCvDGB7MBUFbaO8OgVMv3xaz9TbSH3
	CBuNND8NntFLF7wlde/DA+sXQtiaJt60klaz+0DKq6zjzadR5/K8FYL/Jt62Myp7Tfx6v7KPJ2M
	zkuLPpkb9vK2Neg==
X-Received: from play21.prod.google.com ([2002:a17:902:e195:b0:2bd:15bf:f9c7])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b45:b0:2b0:a957:304 with SMTP id d9443c01a7336-2bd270fb799mr4241965ad.6.1778615496629;
 Tue, 12 May 2026 12:51:36 -0700 (PDT)
Date: Tue, 12 May 2026 19:51:33 +0000
In-Reply-To: <20260512195135.804833-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260512195135.804833-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512195135.804833-2-skhawaja@google.com>
Subject: [PATCH 1/3] kho: Add kunit static stubs
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4573618000C
X-Rspam-User: 
X-Stat-Signature: zwpjuyumrkonqjwf7sqd5hccisu1ehf8
X-HE-Tag: 1778615498-194822
X-HE-Meta: U2FsdGVkX18aWL1jKXHOPy6Pb6c221Jt9f5Dly+Bc1P3i+mugcFTw5nxMNIElgEPOVnJvytsZmR5MI+jBpKiMGrUF7eFbxREjO46snnGfL4aB0L6B8DzDWEu8udth8GNk4BWR5tYRaqy/Gxob3LsVNQvp/qyBIvb3VIjMSxJacTlkM8OFvK1/Vw4qwgIMbC5v/6AKTnckkkdbLseUl+6FfNeavJU8deqyTZIx9Gy6a25p7DGdcADtKiLgotJfDFuhUI0vagM5WpBiZgsyKH6Cktv7GkT82sInazXWvWZfCIQDYXwF3BRQjC2ZwUaPLIZ1YS7xW55QpxKGq2S+H/CGx5TDpSrHqG7BozFrkL+f88xtLNUov4Myli2DC3X/2C7wFxLIv5z2Bo1vrXEuDo7q/IGMmt22BpN3JymY1M8JyBEnPsm/eJ2+ylMjcq/VmhCRTvXr9hAVHXt1c/mMSHMC51VkCr3lkv3wZBk4UuYG9pAz6u2cOmJncErHbGbsZKGekxAq8kljlX+xW5h6pLm4J7j975KfTQJoiOFwyXz9J37hBCaVaXSO6cOz1+yfqx9lA33JKiJERdt1DPAiGdAvf3brL+cHSrvgi2SzH9XevyclBdwWVUVBUxw/JdWRT3GVrPIDAgzuOdSDIBxdTTWqeO/9GLU1dphmfgU10BwCKxVyH5b0Sx31u8CJUC/5D2CwQSZRFdFtz4nyKVead6HbLQhN1PB5ejuCV6epiOW+MD2WJZdjuUx1uyvBuxZIZ3PGFagkdiAOwgKdE8FyF9extX9k0/33Frc5vC2lkPDJ8ClLttzqinM/EAF/y50OMkjvOgmfoKKW1PNoGp18/zIOFWfYFVEhGgxBHzuysxwf2w+M8uhvr965uE9GsaHF1sZ3G4TiknAdYuuJ5tlGBLIZ2REPL979gvmEbZb2U/MB2WPpcCQQnFvr8+VeoXeQPJ4Yvyt1y08br/ddM8c+2i
 H4XfKMfr
 7yC+kIJh85aEy/bN52eQCRevyfEz1oldk2rLlYq81xnKHIhgCdr8E9U3u4HjiX4Lu/4wpGgM+XW+KGE2x6JW0Jan4cyTkq0q/8yX9zbfpLWZcD8JRQO6LI9woZoVveK4+m9AcUiQziEUyXAkxTd+lvqm5uvTTSNNxwMIaDjFqVgdsmOSQLu2Kq9xCd/nln4YS78wpCw71pukbRhU5H5wAi4++KyCJlkxdbtfVk8LYiDsjuZ37hCtWn9VRzQBi73B9VZxN4ufXqKTIM3DkIODqQxKtY9OhYF0gADilSjPMcJki6oUs7xVq2pwNY8exnZo0TxpxB1tt5KTo53dbwzmLGmsx7HRBF/Z5tc7a/wEhkZAJPpP1hElMFGsVrCvOjCiyU8+5K8DhGIJebK4O26y17AQmFff9jGspmcfaz+vvDfNSFIQg0C/vEPh84hfVaOUTSGY3SXo4XLibUxnIbTYGJPH63DhTJ2a8C9HE5C3SqAVt50FtsAG0tVwIRfrFOFGuOcgA03YSBsyKpCNyMOYhxY5IVfTeieDug2dbVBillCZq7+HvgnJJheD3d20ZgmsSyMHF3RGkmrWHyq3flLgvGsPOE4j2zW1LUQglXaWb8FPZLx+J0hIofR/WMmhudrfS4+bcmuwuDJeaPos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit stubs in kho_restore_folio() and kho_restore_pages() so the
users can mock these functions in kunit tests.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/liveupdate/kexec_handover.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d5718bef6d4d..1375291d9b07 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "KHO: " fmt
 
 #include <linux/cleanup.h>
+#include <kunit/static_stub.h>
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
@@ -437,7 +438,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys, true);
+	struct page *page;
+
+	KUNIT_STATIC_STUB_REDIRECT(kho_restore_folio, phys);
+
+	page = kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -459,6 +464,8 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn = start_pfn;
 
+	KUNIT_STATIC_STUB_REDIRECT(kho_restore_pages, phys, nr_pages);
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-- 
2.54.0.563.g4f69b47b94-goog


