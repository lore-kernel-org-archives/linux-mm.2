Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46811EF48F3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DD46B0005; Fri, 13 Feb 2026 03:59:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B6B6B0089; Fri, 13 Feb 2026 03:59:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865856B008A; Fri, 13 Feb 2026 03:59:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 792BC6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:59:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E6941C2F6
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:59:28 +0000 (UTC)
X-FDA: 84438834816.30.C554A64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C859280007
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:59:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9Sz6PR1;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770973166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S4B6XVJgrVzwO5DjJck58Vc1kxScEkMaUxP3BOD6O/Q=;
	b=eusqO3sq3cTASD5KmSy+rOcVWpKHtNghpwwQocTJbatV2mN9dpj8JB8JJO8pddXjb75qTE
	BHjYyeJsuRS/pBU6uQ5dPykhlStJe9noLF9PH1enf3chhF2c7rfIl/T8NmAQVoOokpzwrQ
	/tm/qEMV53KoqjCTclmypTkzk/dWP6Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9Sz6PR1;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770973166; a=rsa-sha256;
	cv=none;
	b=tnHrmkgfvbRZNKv3J99uaO4yqH/4fQSdBjGMa2MN3HOCeB1VmlxW3i99EcmpLoDRx7E34j
	ePKd+XHkceisn7kMl/FqIZVCMgUQ5ZbUZaSdBoRwTVwEfUkv0xKkaHV2yWVc7WvsKxMMJ8
	OPaAMrDJQW1p0iAsq4foDBIzxbE/i4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 186376132B;
	Fri, 13 Feb 2026 08:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F5C116C6;
	Fri, 13 Feb 2026 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770973165;
	bh=uixbDt7OlKbJ5MtQyLaeFtlWYMi840nDFBt1QnEFSsc=;
	h=From:To:Cc:Subject:Date:From;
	b=r9Sz6PR1rjD1VMrg9L/5/Ux78jvnREicHVYwULG0PiEJ4UwXVrVv/7uwmQpvHNhVM
	 2kyITMiYnmhPCd9qvMdqUpAQ0+nvhhU1fWC0mXa4V8McB7UOAMvUkJsSeKze3g8xpC
	 XBdvShAEp5sQBw35nMh0CpIKij/oHmN8//EVYE//lLCNG35Xr5evy6w8aPtN3cYGBB
	 Kx+z1qNt7jz+Xgz4RSvwc96iu0rOIYEJYZ64FDLAKDf7riR7y3En8nhQ8ekOmJZ8zf
	 XDSwaCWHGJKNV34mi0yptyGLH7Q4NKPZFReqTj2bR/XAypiWt9nZ1Of63p2H70ymIS
	 oFewsJTbK+uug==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] kho: move alloc tag init to kho_init_{folio,pages}()
Date: Fri, 13 Feb 2026 09:59:12 +0100
Message-ID: <20260213085914.2778107-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C859280007
X-Stat-Signature: xz4iqns446wbzbn1mtmm17fhx8f35k6h
X-Rspam-User: 
X-HE-Tag: 1770973166-982930
X-HE-Meta: U2FsdGVkX1/RvX526ACotFQxzGp2+caNd1xTMctA6WLt4RynqxDA5A1KbGCP/o++1zKK66V5o5EbYIu+dxwtywAp7W53bvl0mrRK3PnAB46eCzJXxT4uO2yRomAqLElCQkLnvO41zg4H6TO2IQae0P/O+r0QuskRNvmCJ6ONAzsaK30XZYbGxf/NoMZyKsCcllddbANRLrMJYoeqA8wZ1/p9khWSv1nwccBbpE5gQeOORiKMBFuOwKfA6fkJ2FnOAwjkNb+ubkERReQPOKRLxMPlZmbSem/CwkBrh1eSbsVEf8L8zSa/jaTF6eSOhKa7ne/9b8jUaVNxZM97178glDXWFoT+Km8/NuQAWU/KsQVaPsANjh8WU+RzLrt8Hz7nIK6UV5ceifq+a+3hYLyz9gdQFXrloRITwVRavmW4ZWvdxxRNMPT0mJfd2mng8dWtIvyvq46YeNhn4uLMWfbb4i1xSKekzapRJWyMM/dOS8oH3LE+0RzPC6wBjCBUOTw0nNIvpEywFNN4rdrGyM84/CTC1PHHnfTNs4o+H8s9FgosB4UON56oj9byhcVFDAt0lO6B8+MAJlLdF6M5rKnzpLyakUrEiKFTX+wSv4aFBDh0sthixrzDoBwijQj0jmTtkR3xpE8fQNxdRb06R13l/JJC9LEjgYAS+gQhf69AtoGDQlaNong+PkoKZTUiXHNrEyg7OI/jq5m3Op/Mer7uqZUdnyE++YGVOHPuWlr0yTzFhlA0e8AEB/RBEgC/Lt8wr5gDxQV4i/tGkRQ1SaRa55jwD+YmpeSoyDqtdg67Sby+zaxo6RXkRdbc4LHWMNUA4rlJgRJrC/p7ulmTGHvExfV0ZuqnLaqXHUATuXhPDM3FXGLXP6PTQrCMmuT0RAtOtQslE6qZpUAGoODokbikUIKTnonMi2+sZ2mqBaDsSLnOYcOSj8rTLEHEILWIJuPlrsf2JnFJcGIFGW3ozae
 ego4S979
 +ek+wBs0kb2s75iEPSVQCM+t5HeSOx70hOkHm/3lGFoIZHzPWl+a3NJOeHYmlMfcLdo/+k0fx7QP4Bw+b3iDDk/6KYg1jK/YCtQVkJRX7dFt4gZSs4lHpkrqx6nHcgH7OpJ32NWA03t77awngjEb3V18dkSI5gIttFj2TcPwB1Wklek1m6/Sbh5GvIpK806f9umVkgFVSBsnAIyRXt0l6Dj7Odd4ul3ktwnOYASTgPjUESZn4+My2v/jbZ9Q3Xxu9C+rMjywvXrzXgxL7oUrI3idxZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Commit 8f1081892d62 ("kho: simplify page initialization in
kho_restore_page()") cleaned up the page initialization logic by
moving the folio and 0-order-page paths into separate functions. It
missed moving the alloc tag initialization.

Do it now to keep the two paths cleanly separated. While at it, touch up
the comments to be a tiny bit shorter (mainly so it doesn't end up
splitting into a multiline comment). This is purely a cosmetic change
and there should be no change in behaviour.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    The patch for e86436ad0ad2 ("kho: init alloc tags when restoring pages
    from reserved memory") was posted after the patch for
    8f1081892d62 ("kho: simplify page initialization in
    kho_restore_page()"), but landed in mainline before it because it went
    through the hotfixes path. This led to the simplification patch missing
    the code tag bits. I don't think any of this is worth explaining in the
    commit message, so I just left it at "missed moving the alloc tags..."
    
    Tested on a qemu VM with CONFIG_MEM_ALLOC_PROFILING_DEBUG enabled.

    Not adding a Fixes tag here since this isn't a bug fix, only a cosmetic
    fix.

 kernel/liveupdate/kexec_handover.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 95601623b4d6..7e5d805fa1fe 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -219,8 +219,11 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
-	for (unsigned long i = 0; i < nr_pages; i++)
+	for (unsigned long i = 0; i < nr_pages; i++) {
 		set_page_count(page + i, 1);
+		/* Clear each page's codetag to avoid accounting mismatch. */
+		clear_page_tag_ref(page + i);
+	}
 }
 
 static void kho_init_folio(struct page *page, unsigned int order)
@@ -229,6 +232,8 @@ static void kho_init_folio(struct page *page, unsigned int order)
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
+	/* Clear head page's codetag to avoid accounting mismatch. */
+	clear_page_tag_ref(page);
 
 	/* For higher order folios, tail pages get a page count of zero. */
 	for (unsigned long i = 1; i < nr_pages; i++)
@@ -265,14 +270,6 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	else
 		kho_init_pages(page, nr_pages);
 
-	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
-	clear_page_tag_ref(page);
-	if (!is_folio) {
-		/* Also do that for the non-compound tail pages */
-		for (unsigned int i = 1; i < nr_pages; i++)
-			clear_page_tag_ref(page + i);
-	}
-
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }

base-commit: 6c8dd4f02805de481c200636e567a871f25399a2
-- 
2.53.0.335.g19a08e0c02-goog


