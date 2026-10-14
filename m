Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A74CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7DC6B00A0; Wed, 14 Oct 2026 14:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779426B00A1; Wed, 14 Oct 2026 14:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6676C6B00A2; Wed, 14 Oct 2026 14:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3059F6B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDE5814074B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:39 +0000 (UTC)
X-FDA: 85322072598.18.AC167CE
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC76BC0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jqU/AeZD";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002637;
	b=siYqYWB4AGSCu28mKGatsqb9CumZpp+ftyR+Hby7iPr8BLef5IiKfKqKF2XrmY9qmI7f3Q
	HVel9fh5VlBQ7xG9z0clTQv/BzC4Q92ddn341I1xFCtKBmntWxQXCDEs2SLy+QUIsZ/4z+
	M+yrg4VFFoxqd5zHky5p0bdKSRkEcIY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jqU/AeZD";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ePueSrtTjxyoQqFiqutrxbbN437intRkGhhEYPkovE=;
	b=ztecmLwelsFGw0SveDJRZA0KSEepo/Gui3iRMDpSGArQ1KCL+cmcq8Bx7SUioRLDvPH7j6
	MYKBxnzwYxBzrjgSTRn4SKGm7xXmxEnxTGt0raHCtzC4QHqz7RpL/88fSVzRmv91fGi98b
	iDezOOPlhtTN0/91BZhcB6ir/mBcPyo=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-917c04630c2so56526576d6.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002637; x=1792607437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ePueSrtTjxyoQqFiqutrxbbN437intRkGhhEYPkovE=;
        b=jqU/AeZDNbyqNkEW8K/0JaDysE5LxGKy0AWo4QlZkjQPezxWGiqiHPJyDc1WJny9EL
         cOFWhaJ2dY90qtZbOP3p9eC3jGE+e0aVDw6KyscJJQus9T3c/zfW3s+kpvS5rtJ7XhHZ
         GbDXNqx7e3JiyXxkh/F7Vxgbc8jDvz5GGEJmDSpjlmH5vzdzR5k+TgcWcc6DpIfz3EuP
         JdbJQSAUDNYYD61UMJ5VFdwn3TULQ/sHtPiv8FlhPyCF35bCp/hsoyHu0ebVfvRFdiII
         ZMoPLk6jtN0jv0rQgu8KrPEqN17WiZMNA0QwGraJVN3PvoDepoWv8D7t0SW1YQO8N/CM
         My/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002637; x=1792607437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ePueSrtTjxyoQqFiqutrxbbN437intRkGhhEYPkovE=;
        b=vtEPp+hsPraJ9a2cBKRYylAvKx6vcXwH5EYQmKZ4Abcmt85xdkE6I7/57+72ojgxDQ
         tXSEQtZJhGrqh40E/7Ma3lQwCuDK4WtBaLPPfkT9ydbY0fLbgqH4glbynoROzBhyAGUW
         OwqdLQ9CZ47Vc0IZx1AFb09uTwSoAfxiy5I3tl/ZwcpTVSbyw0qAlaC4ro9f8+YG2j9l
         p1dheG7NXhveLopBQkeDilo92QNbkta1jymKyKcqkctjKvXhN9TvTuin3zdB3HUi2J8W
         eieId/Kxp73xIMWTGAjFqyUSpKbDNQIMyEDK63ecqMilsrE4kOmtXsRz4cifOlw5J3d1
         0c1w==
X-Gm-Message-State: AFq9FYLmrcnaGSUbleSEwZdxlZzovxvUBNntJfoSIoMWbdXirfOS+2Ns
	K/VM35WLayfSegQXmRh9DHCfJUHKtPdIV8H73npK9qUji2I/JXtbjcfXcptCwKkp7hltNwSK/Ib
	fyL9u4fA=
X-Gm-Gg: AYBFou1rruAa8unL/fT/D3GqEM91tIdbYg5Y8HgD4DvSlv8WkjYQpQTCmms45teUien
	sqsUVYemUC3doPCBSuM1YWpv5ThQL/mhG+ErnTXfLI1XjSKf/Bxi6bNb3Bu+0XqzK/xGIXwG5N9
	mkW9kmpoFNKd9BWBgN80cF6+bd82bsdNki0ewKTHNgY0pjBESegrYyirRMGy6OocSLmZkVPQstd
	3os/+GDKZByGkjN79VqCPJT174mHsZ2jodS5MNcXQxfiybwo/yjrpZSwxjuCe6pvCXNoy+aGoMF
	gYTi1mrzZs6eu9HAKVql2htLprK6CFOoHcEQHPU/auZIRGYpGYuhXOhjjQhd4rfU+FIv/D++2Z/
	yN+Jxk0wEkEg32Uimf9WaxYx1BHSxK5q8EmRVCfbCwhxOKcfAOUA7t2JQJo/WyM55VYK3OUU4ch
	35/pvuk/4swFSCY32FBvXUrVof6D3sFwePdiRCIDzlDuU89lCt5I1pYS/IHc4EJdeAw31QHzNBJ
	rxdbH77AwejWhrBwJgMjrCYGhSXh3ZKk0Dh0b2i7PNpsE3OGujwv9KswxeP
X-Received: by 2002:a05:620a:46a1:b0:93e:95ce:53b5 with SMTP id af79cd13be357-93ebd28b9b7mr2938174385a.52.1792002636690;
        Wed, 14 Oct 2026 11:30:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:36 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 05/10] mm/madvise: factor huge-PMD folio processing
Date: Wed, 14 Oct 2026 14:30:19 -0400
Message-ID: <20261014183024.2075709-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nobkdw7u7yt8qjincuumox987r1rgsbr
X-Rspamd-Queue-Id: EC76BC0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792002637-222118
X-HE-Meta: U2FsdGVkX1//q8xlZPklPvRdIk+NOqwZzF/bGsmagjeWimywDNKCuAgKmNccJ2LtBBZ7Dr8LztuVUcLq8AD3ZrBf5GgN8+Yz4fLvKRWTcKJKmwhyvPa73ihxINkkh+nmmiuyg2F9VtXrP0EO64OmbuvprIjBMoimznVbNMnhMX6dsIviR28dSERmANZbiMJeOJqpmglqSO1o87idIOeMfUG0qCQlPfs8NXqr7TKjQsLlZuKPcGNOwdU1WUs9/zd42ZElU7H4mK4QRKEY1ktNmGLBVs8Ffq7gZWxCIXbmDQYkZs//Un1bWwNzY7rB+iKdhdURfDIt2NsQZi5MRsf8aS/Kaw1K+XsERIXC8c1KWZjbyp/wGs5fL7H6TJsDB8C+N1UXH8+eMEGhLzyQ1S2UMbzrMqo1vbkn6cMmQRBSnv5k2dTwmK9VYFC/YCOLlhs+NFpZWqw8uUEnoP51tOFJJD+pByVcgihvbzZeZGi0R9UK/uWIqGsArmATPTC1zDIkQeimXbmXwNNlbOKfOYOaEKYeAyrrWMeMh3oY0tst8qapD1fHurd86DvPCz+AX33xkFmx4GVZPHEQ5cQSnwTHwTB/QV/ROgblXjoN0Wv4ZmwjmHEn/UUFE1p2oU2dQ088+YOMoX6wWWzcK6A9OXJfEpiLrqUaWpXHIKuaPYh2BBtqOJZlHnaGFKEruzib3Glwgl+ubJjtR+CYTOXFTrxRs1dD20TclxVvhSnJ9eEp/wq03/MpVA+ck6uoiTYwe5h2xl8YkEv5L3Tf5GIGYv0LtRK14l/KZQyrJGFIMh3auwlfVkkyfH7vTE4WZ6MWCvEJEhjY1qFmYtVzNLZcaP32cu/EjvHncPT+8dBsa/NyKrR8XOrC0fbhyy1+ruEX7rfw2wtKEEnCIKxgapib041W5ltdsjK5Uyk3BbGHmFuxReH7oxpIGSn7FqO848MMyCDkgrfXbjTXia89L4BSRmF
 tK1EeYT+
 5r/c187V0UuwdPzbVI+faAPoiJMkJ+N+Us9fJyOwmc5i7sLJEqE2RjUWMs0d8FD2k/PYH8yov8vJwVa57abKHHVxP6FQDInWUI0+WCOAKWbdg2qh4LeED2INY36ad/7GZ3GnJ1a25bTDZMQD9LfnemOyX0kEwqr7cmro483ML2B+qVIsqCj3sS0SH4VW9EoXNXBW/BpQAKZrRUFF7GI5dvHZzpsiwRi/KQOp7bzkjO+JzbfN7ZALJPEXLekOYO4HmZyHY4hdX/w/VPuikbCod2RD33OME8KydoVxPsDwCE2D0of01jD4nLfGlEGzQMWTUIG5gvZwLyiuTGfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge-PMD branch of madvise_lru_pmd_entry() decides inline whether
the PMD maps a folio worth advising: it checks that the PMD is present,
looks up the folio and applies the shared filters, all between taking
the PMD lock and splitting or advising the folio.

Move those checks into madvise_lru_huge_pmd_folio(), which returns NULL
when there is nothing to do, and move the MADV_COLD young-bit clearing
into madvise_cold_pmd().

The split stays in the caller, which owns the PMD lock that must be
dropped before splitting.

No functional change intended.

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 55 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 1bb4f9f0e73a..f847dddada8a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -407,6 +407,37 @@ static int madvise_lru_split_folio(struct folio *folio)
 	return err;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void madvise_cold_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pmd_t *pmd, unsigned long addr, pmd_t orig_pmd)
+{
+	if (!pmd_young(orig_pmd))
+		return;
+
+	pmdp_test_and_clear_young(vma, addr, pmd);
+	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+}
+
+/* Return the folio mapped by a huge PMD if it should be advised. */
+static struct folio *madvise_lru_huge_pmd_folio(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t orig_pmd, bool pageout_anon_only)
+{
+	struct folio *folio;
+
+	if (unlikely(!pmd_present(orig_pmd))) {
+		VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
+		return NULL;
+	}
+
+	folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+	if (!folio || folio_is_zone_device(folio))
+		return NULL;
+	if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
+		return NULL;
+	return folio;
+}
+#endif
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -432,6 +463,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
+		const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;
 
 		tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 		ptl = pmd_trans_huge_lock(pmd, vma);
@@ -439,22 +471,12 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			return 0;
 
 		orig_pmd = *pmd;
-		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
-			goto huge_unlock;
-		}
-
-		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		folio = madvise_lru_huge_pmd_folio(vma, addr, orig_pmd,
+				pageout_anon_only);
 		if (!folio)
 			goto huge_unlock;
 
-		if (folio_is_zone_device(folio))
-			goto huge_unlock;
-
-		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
-			goto huge_unlock;
-
-		if (next - addr != HPAGE_PMD_SIZE) {
+		if (!spans_pmd) {
 			if (!folio_trylock(folio))
 				goto huge_unlock;
 			folio_get(folio);
@@ -464,11 +486,8 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			return 0;
 		}
 
-		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_test_and_clear_young(vma, addr, pmd);
-			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-		}
-
+		if (!pageout)
+			madvise_cold_pmd(tlb, vma, pmd, addr, orig_pmd);
 		madvise_lru_folio(folio, pageout, &folio_list);
 huge_unlock:
 		spin_unlock(ptl);
-- 
2.56.0


