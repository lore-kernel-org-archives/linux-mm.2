Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5EEC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720A26B0369; Sun, 16 Aug 2026 18:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7D56B036B; Sun, 16 Aug 2026 18:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7396B036D; Sun, 16 Aug 2026 18:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 041F06B0369
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 632671605D8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:24 +0000 (UTC)
X-FDA: 85108617888.27.297DB68
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D06840005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N hg7kGb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OTOxpCzs;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHyFDjIBobrd0qUaPZVYZ0a7uxaNjqw7aneS2s20bwA=;
	b=6jvKVSZO1Juku7af4BKYNWXrpF41d0LYb34JlGUmrRkcvbFXkiuEmZMKV3UhI1k/SneWHv
	Pj+bHcPK9R9q0A4xrxCK2Fp6mWf4k8rUYQ95NAC2DfvmsI31F5+z2MQLdxGuH47fzEpRSD
	BH2J4gfVpdBfS06phUcRaItO/Q8dFR8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N hg7kGb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OTOxpCzs;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920382;
	b=U3PcSV2nB/gk8UzNfT3uv1UbwUxUe0y3Ekt8JWJ6L8o166wABHbeAZH3tqpMKIJw/0bD/a
	BwcjUY+OOQa1l58oHPTFNwmrGK82wmJFuvSHIWD4XHTEoZ7/RTTW+5WIdizq3Y91grfgjk
	UD4DwMBljeiSV67AEow4hhZVSe3VmQA=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0C34D14000EB;
	Sun, 16 Aug 2026 18:46:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 16 Aug 2026 18:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920382; x=
	1787006782; bh=BHyFDjIBobrd0qUaPZVYZ0a7uxaNjqw7aneS2s20bwA=; b=N
	hg7kGbZbS1oZ/HPIqYWFxcYj6+ij+hMYs5k9zdJjhEJjcU/ixl6HguJDYdWdoQ3+
	Nt6jnTOJvRz8DUgxKyfoMIHlryxvXrOb4j9v0P1kkEcpWRdYXg3j9gQwJ2KP1iKC
	Sq2iH4w6qvEVoCK/QJaUO2Z0Art2GmZgbABBJGytDptwdY5HZB6GQsiRajt5p/TK
	g/ffFmTeNYdP4t6TMiJLn70tdLsUSDTVFgGiPjsNuE88L0Y2dAmSkVLNVskBgqwx
	cAw/smsPGiDR7mk/8TaOH2griIwparA2ex60KTO71BK1glk9RokcEbb37RxkNc33
	yRRl7VpXXc5qin+OzG0dQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920382; x=1787006782; bh=B
	HyFDjIBobrd0qUaPZVYZ0a7uxaNjqw7aneS2s20bwA=; b=OTOxpCzsBncl6WlW4
	ealynY9yom3qEKh/pQa57Bk/qtxumvlHUJ14ThdDJn3Z8RgwBIIQjvx3c3fH8Gi1
	IuKRnf9LeXs/f76M0OT7egu5SahMgoSxSuwtuCw691gjKkdLRViihx6Axp0vd0yr
	TOBmXqmYErCZ5dZVALBuPpDJmnxtfRqLPtycNTDm25KUgEf/DcWIujfGddUF/wXQ
	CRL4Za9072eZQBpzNgLo8MeFQ1+i2deso6Xh181A/vsI4+9OwSfbmBzUYkheDXAS
	CmTtriT9i8WZ4lAfp3Ug8fT39TuRVQzhDJ+uMo45oUM9C+CLqkr1U76wKlFFpNbD
	ewAlA==
X-ME-Sender: <xms:vT2CakN1SZOWRPnh1uZCVAxoSIvYw78A0Dluf85XGkUGRsVCzHNV6w>
    <xme:vT2CagRV2LOvRWYxl_HFtWuJ03Mm8PtJDtVRLK20UPMlhdytwZ7n1lS_y2Alch7Kt
    kiUsw9oKfvRl0YjL5M5BIKheC-R5InANciMFDLMUdUXrbhDphCX8yQ0>
X-ME-Received: <xmr:vT2CanXC-yNiQgz2ib1-HNCf0Qbv34stBlnSwSLHT2yOR5DTZ5Gv7-oVVvU>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtOm
    978x7RbxHsQpwvbWpMsc0V7jUKZyBIK4Ghgn899w66TrjufmyMrNztYeOV/7aH+D06vSn2
    fkYq1Xxl4Ay6MsKxqBmUPt0ZykwUxbvAwpCsewJwqFzXlAMjJq9UinsYw26tdhBhGHRVMP
    24ruPq5aepnUmarI0NLCHTFHzAVmtYZHpuoq960eg6QHGBrLQRGlCZFJ4ACdQaf9TQA7JF
    IvIGuBlht/53MNG0pdSU/Y1d4iP+TKdJ1NQMcdleTlUuM1ajYvmJK4vnPYEhwTvaAqWOw0
    gXGr0c98E7XTShO9e4Oi1oOA5heJo91XV4uKcA/woltUTTyD97DvZIT80mYA
X-ME-Proxy: <xmx:vT2CapTMTxrKa_YEhVcDWQiEcCMIFXc5bXQ1S-fgQAbH-wnZFmxZvA>
    <xmx:vT2CaitUmNWg6gy3xKHmpCKG4ehUT7ylWivthpabTFHRiVsln7HE7g>
    <xmx:vT2CaqaWH7_XZQGI6cfXpe6SbrPiC5Z6fPWOHMYfGial11Ggry0RsA>
    <xmx:vT2Cal-dnPPFIujLidgJaUf1xLRVqWKD21IdN1QU_xIGXfWCZGsQ_g>
    <xmx:vj2CauDSOcAxiWOr16lpkn40GSHCGlUi-_Bj82DFTCBzPFIgh-X4AIgE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:21 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 02/57] mm: add pte_none_or_zero()
Date: Sun, 16 Aug 2026 23:45:14 +0100
Message-ID: <20260816224609.308019-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D06840005
X-Rspamd-Server: rspam07
X-Stat-Signature: 4yy8fxejyn54g3t8d9phxjcqnpgkdniz
X-HE-Tag: 1786920382-650000
X-HE-Meta: U2FsdGVkX18Rb3nSwV3prA/XmVmpR33gsgERXtqjGx1kZ52QyFpCF1HD1Sg7fsXAxo2k3Ahq/JALgdFPaOdiXb6tGELD0wwDjfY23e1gaD1AjvR/sSknVtEcex92n5/kVOXWa099IUQxuGm7Jpk6eZQx0vDJ9N6UJ3N4sOOvHY5UtfldA2XsOUdrBPyfrWkNScXGddq1qjQnHPZF+Ek5951pNTMGV7bybMqrtNFzmXhiTDsqVAtPjAPb2S1coKh0atOvdWb0qs2T7+FZpoxCsvkS7zHGAFT6GCFeF3s98q62tzPmvMdI8gQnpcrTochuHu12fR50/CkkKnu4wvRXtPKApOX1fFPawiR9Klz/m1cH3P26m0S0iOeQBYAzsSKEKUHJVrMTlIwTUoUy1KNZPGMIQpDv6BDvD1kv8kZvoku5qVDQHlUmJFmS8wDzNNoPV/HF3iQwjx7hX8gpPpp/+t65/WwBYFH0rAgh3/Tl0H3zLXsQqASRVtIdAU3IZ8IKSi6FqFCSSA2CSbeupE+RwsUGMkEd6oPHQ9yrZa0qVkHeC/MDc4otUINtXESyZFHdS5wD6Vhle9VvOGnTgUhAJ+y2ArYeq1h5t1MkoesGUg5XTKwokbM8liAhtGYTBBmr8HpJDxFwlF16B125O7OQdqY/7iG+z1Otrk4UvirFOelImBtHS8pqhjWnW7kI08czsTTsc9wCN4RiQv0thofRECtWf5lYmqCTlBayTOcMCS+Y5QYXe2ooZnfFxCC9pGMquunrYr2X7k3YD8sNKdLkQHed2L0VVspwoYLTW/BnCBMMqx+2pUE7qH5ZIAmMh9Vmm1C5KuTvkGvstOQVUB59P6GJEKDircdYElj+xrQz4PokRRDySDOBpXeqzsT9Dm3pRYepEoAgEY9FX7KhIfqzUQfPevDDjaqOoypFWft/Z5YpDa/YiTBcFHKYo4DxSj6d8auE2Aq0CMdaj/uEZRr
 g9Vu2UYr
 taHujG+iWE46dJ6Gvr+C4SEi8IHi+AI5szhdYebMRXBHC/jpAijvMgC9mZB9F959UGH+rMLoQ+utOn25U9THzXxFYbKEeYVpsaoO/x5TppgA0tq6NMYe1X1xjShuQoANKaE6WVjUyDLKXDTmTg0HTcwSSUqHQ5a4HXsUcE6fFcwkXSIjv29RlNTwRmYetWmqulQvg4uNlcov05Ov7aTGTJxHK5geMAgrSXtgSD8koDSpIRE7jn7yBhOBZVh53wipiDLG3zbXykgX3V62YP1npcds0lWasOQGG/HJcNHcEMqh+kmw0+4FfVhb8I1T4W5sG2MAG/nXxCtPCuol6kopIGP8Aj1TODHtZztVYcAGzG1nd5AZdjPeGM2KKDp9JYkrzcHSH0zUxUaf0utiAcfqPs9Di/x7RbZgyzVyt35rVQ8fawOy1oH6yij3rolY9tBdCyc5PjYDH8rNeTrE/c7TrXhVqwr/l2NPsT0MlIg0xrx5EfaJOftAiFR3lWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A PTE that is none and one that maps the shared zeropage both stand for
a page of zeroes the mapping does not own.  Code that cares only about
the contents can treat the two alike.

Move khugepaged's local helper for that test to pgtable.h, below the
is_zero_pfn() it is built on.

migrate_vma_insert_page() open-codes the same test on the slot it is
about to fill.  Convert it.  It still tells none from the zeropage, but
only to decide whether there is an old mapping to flush.

No functional change intended.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/pgtable.h | 17 +++++++++++++++++
 mm/khugepaged.c         |  7 -------
 mm/migrate_device.c     |  9 ++-------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..bbee6d31f015 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2064,6 +2064,23 @@ static inline struct page *_zero_page(unsigned long addr)
 
 #ifdef CONFIG_MMU
 
+/**
+ * pte_none_or_zero - Does this PTE map nothing, or the shared zeropage?
+ * @pte: The page table entry to test.
+ *
+ * A PTE that is none and one that maps the shared zeropage both stand for a
+ * page of zeroes the mapping does not own, so code that only cares about the
+ * contents can treat them alike.
+ *
+ * Return: %true if @pte is none or maps the shared zeropage.
+ */
+static inline bool pte_none_or_zero(pte_t pte)
+{
+	if (pte_none(pte))
+		return true;
+	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
+}
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5a06e3942e88..5f7126cf42f5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -348,13 +348,6 @@ struct attribute_group khugepaged_attr_group = {
 };
 #endif /* CONFIG_SYSFS */
 
-static bool pte_none_or_zero(pte_t pte)
-{
-	if (pte_none(pte))
-		return true;
-	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
-}
-
 /**
  * collapse_max_ptes_none - Calculate maximum allowed empty PTEs or PTEs mapping
  * the shared zeropage for the given collapse operation.
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9a346162c688..60afa556b994 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1067,14 +1067,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	if (check_stable_address_space(mm))
 		goto unlock_abort;
 
-	if (pte_present(orig_pte)) {
-		unsigned long pfn = pte_pfn(orig_pte);
-
-		if (!is_zero_pfn(pfn))
-			goto unlock_abort;
-		flush = true;
-	} else if (!pte_none(orig_pte))
+	if (!pte_none_or_zero(orig_pte))
 		goto unlock_abort;
+	flush = pte_present(orig_pte);
 
 	/*
 	 * Check for userfaultfd but do not deliver the fault. Instead,
-- 
2.54.0


