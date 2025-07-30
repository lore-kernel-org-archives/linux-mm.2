Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A751C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DA06B007B; Wed, 30 Jul 2025 13:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C5D6B0088; Wed, 30 Jul 2025 13:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8359B6B0089; Wed, 30 Jul 2025 13:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7716B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:07:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CCCA80732
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:07:40 +0000 (UTC)
X-FDA: 83721562680.25.3E61449
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15BEC20011
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:07:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ldvCEMFp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3WFGKaAYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3WFGKaAYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753895258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iwvX/+FCFrBIkeHTGaFzh+izLhsSIPbGbCbxZr6W88I=;
	b=C+FVo1Sqz65w6WqpcgILhcYqGAYCBZf0H8bQjRAVSimKK1kyK+XGgrWWuEzw9JbHrxoiKw
	trAXoHIzZjqi3KizJz7l3+m5Klk75H+/FPoeYDUp1XN0rMsr9njl1FuzOwbHk2KPUalpq+
	isUvtKXXzyK93VHnU73sZWaB66bFKZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753895258; a=rsa-sha256;
	cv=none;
	b=u1rFhFgsdV4B6n2yMTyy3uN90zB7kyKCEZA95fx4w7T4iigpddLLDiYYxgv/7TSkfmmmHX
	2gqD304XSfu35fKsHwNSSUmsH4newQnysmHqKOAUmww9bo5aXQteXT8M4xnzW9dTLUO14W
	SJDFF4rBNn+1iTSTZ0oIowSmvl3nwto=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ldvCEMFp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3WFGKaAYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3WFGKaAYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b34fa832869so952850a12.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753895257; x=1754500057; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iwvX/+FCFrBIkeHTGaFzh+izLhsSIPbGbCbxZr6W88I=;
        b=ldvCEMFpAS7lK7BQIwKmcKA2AQOn2kIBRF5Y8TbRhUBE7cLRNSMFHBTexU39JLEvDR
         Uwth5cc/Brp41WaP92u+cZm2Kn6b+oVaMByn69vgPae7iE44rSgNmp/iO1PXPNHZtvxB
         KFdgEOAptcN1S47YfLgz/Ny1zDiuVQgBocXTXZ0lDZ/EnzxF16pFZdJNWnjPz9dKthR/
         mPngnbaHhyg++lwOUNVGvZnuTLVG6xY2R/qmI6kP4gn1W3mryDYxlGwZerbjy5ZGV5GV
         oRsOx1cfdF43h9fZOO5mH6MlC1/S65Mcx9cgV5KIHZWu3hfxZS7tbkZXpImA0vPcFXPU
         pvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753895257; x=1754500057;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iwvX/+FCFrBIkeHTGaFzh+izLhsSIPbGbCbxZr6W88I=;
        b=NqWRq2u5yTir6aMNKl4020ihJ8hlskLx/7imAEm2+RZQLmGzkUsIlHRCSoEXJKw0hI
         rY+0IJNot1hEuD/EkOCrZLN3lytQPeyMwzKnd6Pko+2xRzrY9HzZY0pBw4mnTyNZjgcf
         3w5wwvtGKaNZbmrzRO0PmfsZh5ePsK70tSIpUdgTpbmfm7SCFs6fncMfBVtPRP486o3z
         EJN//Ks7hoVYKHJsDahW6IZV1KovKzZ1pPNV76wmSF7FA15fiTfplNYBXaDSS00QLVp8
         UNtulL7wlgr/kZ4QnjHU6pJ5zMj3C5ed9OrbmHrwmOxc/ufWGLCAW+DKvzvG6qg/yZ0x
         /qiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzlSkqXgQQPa9h40JTse1w4FbGtNj8Xb4xm16VXcOLLLL3aEjHNfc2N7J0HTvPnHMB+OO1k08oWg==@kvack.org
X-Gm-Message-State: AOJu0Yzr3lvCh/5wS3f3zQUKwUqJYe6Zb+6Zoe29akXfkEps7Qe7uy5R
	wubCS23Yn8QMyeypNnq/B9TxEGLcI5f4eP3RoJy4g74UcgaJNbWl1tqwSsCyKZDdg7bO5M4nWQs
	KaYngxQ==
X-Google-Smtp-Source: AGHT+IFRpqzleLfhY584F3gS5nWpI1NhhfzwuIDnKy5qdpfvKqCIZN9aFroMt2PQhlQ+ZIOuvhwlGyX2lGc=
X-Received: from pjee12.prod.google.com ([2002:a17:90b:578c:b0:313:246f:8d54])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54c:b0:240:b884:2fa0
 with SMTP id d9443c01a7336-240b8843050mr21999235ad.26.1753895256448; Wed, 30
 Jul 2025 10:07:36 -0700 (PDT)
Date: Wed, 30 Jul 2025 10:07:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730170733.3829267-1-surenb@google.com>
Subject: [PATCH 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a THP hole
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: peterx@redhat.com, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pa4a89io19kehdw3tdkwwomun9884yqg
X-Rspamd-Queue-Id: 15BEC20011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753895257-485891
X-HE-Meta: U2FsdGVkX1+f+LgIT6KjvwBg3SYXCmBZp1ZmtOiE0YyRnIKKu7nflltHIDY5ciAAYgpFoYrLpQXVbD5UqtVvPwYq4IoulWm2dgGqHPqpyhtmVD+4W3BiXDmTtp5XgfIWE1fXj1yGNrX64KK5lT4XpncFpmu+un47iiuU2BT6Bz2vmM8f61PHsmuc5Wl6cBQPRZcENIinWCFhrdsBvB1PH4UnYbEH47/4NhkwkHOhE+PdDHrcAzhsHr0Uwa+SD/FIBKMKG6vN4Imoxbl6IkPffNLHPEg6/oa2b0AmQKtnjI07dL8F8/ShQ6nkw0Fipp+BRTON6WxPRM4xjqDohgjd46s7O/xemUjwf4n502AD7+N9CfTFHQI3JvmWKYx634l2BisaFsW66bcUFoV++rBaKQdCK6Iq2ZBWRgNiTBkknVyYqHzhQhvXCIqR9xsBM8C0pBvsWK4erUz+rPpV/v9iNvPhvZUA+sTsWf65qdQITVqjW0w2oXdESNAJbF4WWPEbrxH9QjncK36+eeiTb2GcBPhCMPSCxD6a1ARVI7GZ/Im5e1rGQdQtnC8AGTLK1rh4/3Ew4BQ1fNFvxIHzF+3clmmMVhiOYg9WWzcSk3LKLZgZaFJj7ECgg8qDIUYVtulNbNlOmSOSv/9cXwnNeMQJ9H1rdbQZ5t9Sc9ruc6MnOZ9pcqc2kzCeIq51cA4DUvVZUef2kbUEn6O13jZSVj1Adzelizy6V4NkIVmyJ+bHzn89nQzCPUmqrYSHHnxlSCs+fmgjeIdys7XntnLIkQ8jupKjW23qN0YOhJ4OCD004uZgCPRDK8EJDZRA0REp0nQTxQLXbeuhS7RG0QeVjb4EeK+ZmiEaXWwXC4WnQ91QlV4Ei9/Oy2BPc0RS4jSRuvTl0EgeEDaU2FrUNiSnQIW36xDeoz1rDrWvKPwQxDxeKBYYiiQwO9dFXFqGv9YgyYtYR7xX/cF/lEtnGVBtai2
 fzOV3uVz
 T/hztJetfDLACUfrEj9FzIDndnKgvi3d9IMJDd+reMXtkaolgPpzlOP7GX+wuZHn9LQvUvTudTJmYrmRj4/pXOAv/ti5LGHSfy0r0ehRQCAifxJsdlkleGImBtc7OEWFNV4zxcjJXnR1FEVgD6UfJViiCJ0IOQ3eAFoSGsMJmLADWv+7oLZwGOlBAU1CyffahBCy0b9MxzQfRJXU9XU5dKaoofNZox1jmRv1WI2F3GwBYY62ldm/2Yt5MHTmKn9Srz/31GoAs08pivCqUcMJAC5sHrsej5TZMWNK58MbaXipNbjD+QLyAOoVIBplb9HTAP2767jq/rMNuYRxtkrP+lQPiz8lEg0KyhgG0fyxNm4sq1AfhbLALrR8pH1WvCKvs/qivadSPlY9YMV11MJpbpLwPIIcvG4T35ddEYgnEE313pXJ693hxm6XrFtfZQIESVuMO8uGDWjaYhgFZlFzM8Vl2GvFIq84z3mNTSB1b9VBCT2CpiDbhGQsEpmXhwte3vehCB47tOhdT28GE5NKg9UrzzdD1Kfof978M/RUIfaeUcvw6VkSxHiDGCmkRPwNcMVzVV21Dfnpzgm2ssNRifNq1yBojQt1Gkn4jTtSytrvycbApR5HmpLDTXFU1bC0qEEquWvOq+1L5MqOzFT4LQ59eFJmQg6nbULGiKarMUO8SGDitQMFeg+85ydGmO4703fOHd9cFsi12Tdh25f6ymAPy0ovNQcbMhkGI9P6LDNOwuAjMb8hGpajPTshniTe1fCtj8kGpta+4d5EL9izMdRiYgdnwYJgBKGr0Q4wW90y88Ys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
encounters a non-present THP, it fails to properly recognize an unmapped
hole and tries to access a non-existent folio, resulting in
a crash. Add a check to skip non-present THPs.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
 mm/userfaultfd.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..60be8080ddd0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1818,27 +1818,35 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 
 		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
 		if (ptl) {
-			/* Check if we can move the pmd without splitting it. */
-			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
-			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+			if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
+				/* Check if we can move the pmd without splitting it. */
+				if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
+				    !pmd_none(dst_pmdval)) {
+					if (pmd_present(*src_pmd)) {
+						struct folio *folio = pmd_folio(*src_pmd);
+
+						if (!folio || (!is_huge_zero_folio(folio) &&
+							       !PageAnonExclusive(&folio->page))) {
+							spin_unlock(ptl);
+							err = -EBUSY;
+							break;
+						}
+					}
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					split_huge_pmd(src_vma, src_pmd, src_addr);
+					/* The folio will be split by move_pages_pte() */
+					continue;
 				}
 
+				err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
+							  dst_pmdval, dst_vma, src_vma,
+							  dst_addr, src_addr);
+			} else {
+				/* nothing to do to move a hole */
 				spin_unlock(ptl);
-				split_huge_pmd(src_vma, src_pmd, src_addr);
-				/* The folio will be split by move_pages_pte() */
-				continue;
+				err = 0;
 			}
-
-			err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
-						  dst_pmdval, dst_vma, src_vma,
-						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
 			if (pmd_none(*src_pmd)) {

base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.552.g942d659e1b-goog


