Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD7CC43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7C66B016A; Thu,  2 Jul 2026 22:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867B96B016C; Thu,  2 Jul 2026 22:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7570F6B0170; Thu,  2 Jul 2026 22:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0126B016A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:08:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 629E5A036B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:42 +0000 (UTC)
X-FDA: 84945831684.15.4DB5680
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id B359740009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T2qKXCae;
	spf=pass (imf07.hostedemail.com: domain of 3pxlHagUKCFA79ss5y66y3w.u64305CF-442Dsu2.69y@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pxlHagUKCFA79ss5y66y3w.u64305CF-442Dsu2.69y@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044520;
	b=7FwEFGtYcEmls2pw4mYEYSvcWveGD1+MpGVwIRpwsxRXMpcAZkQFMJRDlm7VM7rSHMhdhd
	IyaZD3Mg+9e+Gwbah2Miujt6Qx4HFA/1LVKiA2xXyGPlBJObQRnCkR0287h201fXCJR3My
	TWM3nDFjE2Rx+PBXHUZ2xjSk+VcXsUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHbIAhxt5ZWMRxF4xCIzHhL4IjTclNl9UE6kteWsf7g=;
	b=nJw6Ywo4sR1hBrV8xEJwEJ5ilERbqAl2FhbE8M38kBnBBkhImIWlwCTof+l9liLl9KGvw2
	s4gBs5R6oi4e99buABBetd/METRdpb3590Eno9ndpjSrgwOi2F8HyizbZ6JpMEgp7M9jkM
	C3+GTBmWWxzcdOaG5H1X50yGgZuKzEM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T2qKXCae;
	spf=pass (imf07.hostedemail.com: domain of 3pxlHagUKCFA79ss5y66y3w.u64305CF-442Dsu2.69y@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pxlHagUKCFA79ss5y66y3w.u64305CF-442Dsu2.69y@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-847ad67cc51so81381b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783044520; x=1783649320; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHbIAhxt5ZWMRxF4xCIzHhL4IjTclNl9UE6kteWsf7g=;
        b=T2qKXCaeWfQDvt/yLIGHP49L8pu50b1hySKhfRH9Fie405cvlSeOljesoUnAjCm3aV
         srKX+N4vjm97UOlB9Wo4TUWQo71yzvW2CVD4hBifP4sm8YK42SPiPG7u+B7/AuLpQSYF
         ndYq2VkBrRUw1Oj1fplUlEWSwUoK4HiOyg4H/sPrm7I3eZVRdNiEqUiB1aAtcUPiFUwB
         g+mfZ2R8S1kWyzyIDFwAM7jMQy5vdJcO5UxSgOCWRjgo7Tbn2nMyagTuGNaWL7xoYJRS
         GcfTgRdpo3b5h/KBx45n/coLINt1na9kfeTJBjWKIm6N1Fz96KgI5H1HF/XyObKtyQTM
         te8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044520; x=1783649320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHbIAhxt5ZWMRxF4xCIzHhL4IjTclNl9UE6kteWsf7g=;
        b=R7SwxXAm56CL+EmNEnQYEDMTKwpr5dlDTI3anhg3vaCj/VOqpbD9BVXkvOSOfaW9hs
         o0i2R0kzu5cNEG7tOsfToLNL2ddKr7DPwaSQ8baL5eCD8pnxK5JL6PViRcdonDr0Z7M4
         6GfDz9yKrr3Ka4YH+F6jHT+Axo4+ZC1aMMryLvbS2a5tQ0X9ghvkRy9MYpHIObRy5p2E
         gddJlddJvXQhPY4594zbNyMWeM4jqaDpHXIAKppUEWQTSpo77YJVCRhGDhaYXH5tlL/n
         tdu/erd0FaR8qpC6ALqpdjs62XxXf6YEO230MmvI1cTLPzjJQz713vnDeF3gjYxqDETl
         WCHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZkfX71bx+frCzGtrGevLDyB+PJzYWOfYscxrka1NzaHIDxoI0MQGqmVMT6we0ngckhdYtE2LivA==@kvack.org
X-Gm-Message-State: AOJu0Yxfixuxmntw1+M1TYtoysrxFsRYRd39hABOpAU6ZY123b8uld1r
	Ph/9QELgSwR5fRTq23Q3RnkBJBEi77X2WhEW8o6S3vX1sUUJ/P4LHe3zt4uZQsXFcdz1gtgKD38
	csw==
X-Received: from pgbr31.prod.google.com ([2002:a63:5d1f:0:b0:c9a:37aa:b17d])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a1b:b0:3b2:924c:566e
 with SMTP id adf61e73a8af0-3bfed3dfce5mr9656083637.36.1783044519485; Thu, 02
 Jul 2026 19:08:39 -0700 (PDT)
Date: Fri,  3 Jul 2026 02:08:30 +0000
In-Reply-To: <20260703020832.1731864-1-praan@google.com>
Mime-Version: 1.0
References: <20260703020832.1731864-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260703020832.1731864-3-praan@google.com>
Subject: [RFC PATCH 2/4] kho: Detect preserved page types
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B359740009
X-Stat-Signature: nxcpuq3oyobrwyr6dbau6q88xgkxdrdn
X-Rspam-User: 
X-HE-Tag: 1783044520-116463
X-HE-Meta: U2FsdGVkX19cKnK3BLuafQp8x+fiAfGagHcKxJHx4sNy7+esHFbKabMx+qLYoQCRjfMjH8GP92GAxG1xV6aZVJJ+aeZfNxQdkyTSKTMTQUqycxPRCwu78IzK813jOf+7s26Q8Kn4DL71OJKx40xQC60/sCu9yaA0xyVRmy3RqfkgEPTVSZwFFVLrVb+iUV/dp+A8/JgzgIGF0B7eyW4SyVrO+sE65frtSy7xpvZ+GFKStCwKtW6W5/P30f2ZBI/4b7BwAdhT2pbWvQXoDAoOVQZ368czv/oJdz5a8qjdOA0wMv2orYVqI6jKlYWQeoUtKVDF3AQcjxChr4Rb2DQ9LoO5MEw3o9/UKeVk7p62JubRVJURdoof9fQCJGDYTKrSDp7VNT3OQtnbbN9SnTjq5vz7fhMmUi6GO6/cI79he1ASQSkNsWcBspVOEHFv/PIiY9eelUWGmQ1aHOEoQ1yUaxx67sXnmBpL6eSus/S18tKccjZvZ1i4WEEYqJStupCL65E0hH2cvWgZpcU/o3jZFdTICoUEYIvWj4NAsB0Oc5YqU2i0nkVY+GmXbng73TkJwLkXUk0yPN5DcPVxTyGeXBIqEXwU4XJX86ZtXNHH9ahXFC9PGOj//I/e3cByVbod4LIZ0BsTSKI8CkWymDAYfBQlYm+P4qFaUrioPog3emDcoSKYJx+VIsUeqXt3tiBCCVfQKdi+GF9njIAZHd+si0ApklYI6U/j7nILKr6SKcD2E1fn1RaOhjtA8cShOphZjGtVNhQl9uJ7S6q33QVQ3O6KSY/qFzTDaebiqbZIaDdhPC2pGkXIzsXi0Da+2WY61HJJlAPG10pToNQjs+jAPIbwvwHZ/PNO7XfJTfM1kd/JaKkTchMPwDCSyMDiauMil257H5/cBzGYJ19qmLDsGpxUCKpL91dLCL2Fx11Cw/f0+vBCzTexy+LYDt/GpDdOdbdhf40n1HrOTYP29he
 8mBzIYa6
 US/N6Qgqsh+DpnvDj/rvCga++y9HUI+mE9hQT69kkQYoDs4juNSpYX08utXRmw90sV1h/8Bm9g0E5czLNeVuzkmIfo7S1lymoCyAJLZkufpjXqhlpfv08+U5ehGQylO8jEZsi9HiTBbgUcPoEAguP1LMuf/UVSFjfiBgjuLNugnW0ktz+0YBR9E9QwVQ6W2Xyo4JTBpOlEqVFhX0G0BMFVTU3VRMu11PJE9Cp1mOEMDQFrYtKEW0Dxm/36szr4/+ACorn+mVh+mrq0iT31+IWQw380LvGWXSMsnHAMT6k5j9UC+6DnM5iTbd3hUz9loZakBNz0/OxrR0oP3CFHxx8LMbtZ3aDb/FWsDmhvCFsh1xDRIKkjyrzMcK6v2eHn9TOSp4qIzbUXMjTmn4s3DrzCJOIAKN4ISCqlcRCz9gDsd/2aI6QXElqGD1TDphpqaZIidVE6RQQxkhOG3//QT2Gj9+FqGzdsfKOmEMKwKhTQjU7P/QMGe1bw5AnAg4d5ZfDbgljGK7rQe+a8o3vzRdcV26Jxw0lnBQKkYuh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detect page types in kho_preserve_pages() by peeking into the refcount
of the second page in each block of order > 0. If the second page has
a non-zero reference count, it indicates that the block has been split.
Otherwise, treated it as a contiguous, unsplit block.

Since the page type is now part of the radix tree key, update the
unpreserve path to use the same detection logic to ensure it can
correctly locate and delete existing entries.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f829ffdd00f4..d6e81f72fe5d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -918,15 +918,29 @@ static unsigned int __kho_preserve_pages_order(unsigned long start_pfn,
 	return order;
 }
 
+static bool kho_is_page_split(unsigned long pfn, unsigned int order)
+{
+	/*
+	 * If the refcount of the second page is non-zero, this block
+	 * has been split.
+	 */
+	if (order > 0 && page_ref_count(pfn_to_page(pfn + 1)) != 0)
+		return true;
+
+	return false;
+}
+
 static void __kho_unpreserve(struct kho_radix_tree *tree,
 			     unsigned long pfn, unsigned long end_pfn)
 {
-	unsigned int order;
-
 	while (pfn < end_pfn) {
-		order = __kho_preserve_pages_order(pfn, end_pfn);
+		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
+		enum kho_page_type type;
 
-		kho_radix_del_page(tree, pfn, order, KHO_PAGE_CONTIG);
+		type = kho_is_page_split(pfn, order) ? KHO_PAGE_SPLIT :
+						       KHO_PAGE_CONTIG;
+
+		kho_radix_del_page(tree, pfn, order, type);
 
 		pfn += 1 << order;
 	}
@@ -958,8 +972,12 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 
 	while (pfn < end_pfn) {
 		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
+		enum kho_page_type type;
+
+		type = kho_is_page_split(pfn, order) ? KHO_PAGE_SPLIT :
+						       KHO_PAGE_CONTIG;
 
-		err = kho_radix_add_page(tree, pfn, order, KHO_PAGE_CONTIG);
+		err = kho_radix_add_page(tree, pfn, order, type);
 		if (err) {
 			failed_pfn = pfn;
 			break;
-- 
2.55.0.rc0.799.gd6f94ed593-goog


