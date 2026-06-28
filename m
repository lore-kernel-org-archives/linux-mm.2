Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387D3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE69E6B008A; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE896B0093; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85B66B0095; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0AD56B008A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008851C4A42
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:20 +0000 (UTC)
X-FDA: 84927391920.26.42EF650
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36478180009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FeNwYjIg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3pWZAagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3pWZAagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782605479;
	b=icwjHMULMRypwmNvoxHK4LT3YOjWxuCNdx+ohHNR0Gsx2Uc1mwS2L68IW4zAE+rEE7YVX/
	7SNUYMaX/Mjaz4bKlIUQChxMtRcttXi+L1ekUoY4rzSFFAzs3YaZDrhKJx28YKdGFSyvHY
	I7HHRjTiIKH/K7sGXif0+bRAVz0gNQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782605479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wo+YX/Ag7ncd7bf256KRZ5DnnahmErnNNobKR7tPZM=;
	b=1QbCf28wuK1kWmVnlxO/nWISW4mqNZ2Bmz5UU4CsxrRw79d/ke1HckPBICgiSdbQNthfQA
	wZGR1oOpdQoi3iyOkedKkl0ZiA45FF8CyTMKmQD1EikbDXld08ccPmSk0jEbm5FiyZOlCN
	ca8zxHXrZLjjq+/r7DbB0+FU3ktJY2s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FeNwYjIg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3pWZAagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3pWZAagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6984688a545so536729a12.2
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782605478; x=1783210278; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9wo+YX/Ag7ncd7bf256KRZ5DnnahmErnNNobKR7tPZM=;
        b=FeNwYjIgQFB/AyOvab675/mwsehqZ1MnTL52glUEbxbrNxBZMOsgKnBmMgbWFQxi3o
         rJ7cvVSRb6LlfLmObMoDG7ZaypOK2EsmQdv/CcHFgJr6NcpzMMnKAsxgT66vERzAzEAB
         eKlDIKWGB9XlA5vbCxarYvaIx1FmWLpcAwKk2qhxqb6tMUA4p41zRFlFFoRmd3+f3scs
         AeISlUd6jfJ12V4Cak8NUgE+vJ/IlYwJi/UT2G0vW9aBLEKDeh9s0RDiPYvFLRyFNZB0
         47Y/h3IzqNY/PEtAS3VKG/Znzj4Vcz0cggq8Pj9FTa/Q44sSarDmivH8yTdLYgvFCIcl
         D/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782605478; x=1783210278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wo+YX/Ag7ncd7bf256KRZ5DnnahmErnNNobKR7tPZM=;
        b=fOdBRGmKQ46f+juxI0ul4XhDWUE4UKwkA7mH8hx6OSsgdbxNXbE+mOWJsAMEBQpbs/
         B+QEgAjlHu59rITGH26hUet+hXFmRZWxUkbuNfDeEZgBeDdImYZ7lSyfDrzqOY+8qjLO
         ewtoaO6k1iNgQKvuzfsR3TxVii4tDmD2YxWSQm13mTp6GcoocFRdjzGXQEwuT4A4hPQa
         +um4PgM2l1fLObBLUHygBmgA1WLv8O3/t3cF3Wijckpzv4jNHqQkzjsRI5gsSgGslxF3
         Un02FtMDq/CBtA5/D0SnO0873QGMzyHEoovkNDpi94oTSjj9gMD1bc5i7fAGlrljyDl0
         FEOw==
X-Forwarded-Encrypted: i=1; AHgh+Rp5bxq7aORHuX82DOg47W1DYupZc7bBkFN1nmh6BzoSBjcYNqPnI7Vcx1GkKjrlcp1PcHWx57g0GQ==@kvack.org
X-Gm-Message-State: AOJu0YzoEEDgk5YP5ks30btNd3lIvSZJzJHJMnPEgm/dmGD2tyuPSKQL
	1dcUfh6Jo6WlmiVfpTNHwQuZuNWxfCc54BtghrF73mdSykts/TCRsC4kTODbxqz9YG0SXV0GaMo
	4LK9gK9xRiGqcG6sB9w==
X-Received: from edxb10.prod.google.com ([2002:a05:6402:2ca:b0:698:3b14:4ab9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:510a:b0:697:de29:c802 with SMTP id 4fb4d7f45d1cf-69810ab88f9mr4353570a12.18.1782605477536;
 Sat, 27 Jun 2026 17:11:17 -0700 (PDT)
Date: Sun, 28 Jun 2026 00:11:12 +0000
In-Reply-To: <20260628001114.1869564-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260628001114.1869564-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260628001114.1869564-2-tarunsahu@google.com>
Subject: [PATCH v6 1/3] mm/memfd_luo: validate serialized_data before conversion
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36478180009
X-Stat-Signature: 7ctj6noazixpfoye7a8ioudf6pd9aiee
X-HE-Tag: 1782605479-886079
X-HE-Meta: U2FsdGVkX1842Pm9j08xqdyn9ThzDYxJA+0fCk9hRP85c5injp0JVR29TjFmiZ1+vB6QIupj8ZBKTXj9sPRm4YITibCVPgbiKwrV8w7zeZSL1PdHgKVPrlzUnUzTkcwGtwGuJjQJfmwKDAV79dalFG4At2B4i6/OVqfUGHSE3tCjRJGsF+Zb+xHNGHN1SGUA3+m1vEZxno0CbVsK/J/FT4i0r2cRTLHl9gJ7d43EQqOrQqigAvAe/35XokdkjGiCrqBLQvcxWi23fDkV/jbipaQXT32aZpu+Gx5LyyPQf3mAb/Byuwn0bXPTPa07JyrisnjIrsEpVGr84aNJLASZUqIXsdxL3ybKRz2poQTxF1tpv1sZEaZ1l9vUZbhIPuVOzTIqILj+IeCEFkX4QecKd60FsF4McmK/cdJ3JywPmZU7iaR5IcJm1+19I0btWyzTTvCTYRvrSQWB3PQoM1vg8qbgkWNtThAFUIyz7MTBLj0lSq4/bw4ZsYHR7KPggoQV8Q5H8RPG4AY/ULKCJA1XCgIjYWZ5LSIUqVImkoe+YmiZqgT3mA1t5LTf/c08MsVoA+hN7JxTv0I6zHv33OQuODhxEea+Z6K9CIUeH8h+kR2P7CUlwq1v5xyinZOCccp2AsSotx1/WMFlN1aEYDaPPgRP42Wwmh5TyPbIu+W4i4xN7K2kcW9a4HeNM/0oSVkHK/tRxevDtxF+kzsmqH40k92vzp9pU/LdPH3zNjR9iNiVIVZCrMyr7/TFc8IWJc9kweeWdYQhnkEGFBrzUvQOBEl8SHzoPM9y9KwlD/OKxhUMJg/4+Axj1Sw86qIttcGp4BZlyZcmxuZJeAuPQgFup5P5ypyJ4ct2Y3uSJQuVOrnaU1NXtKQ0d7e/XK1T00j0XMDBNY8LYuJgeGcCzd1ucMapu0kInLa7QcnI5yhHBDcFmuwjr3vZSkOIL704FcGwSWztdTQ0MDgdxDPWGUB
 JHO1PtNm
 VRh63b7QLxAvx367yzMocAfdW5HDMkq8aAGSGgSuscoO8nQ3odK0Q9cXTrBLX4+j1TS3sOLPEFJwf7JPP1aH9PGoklPnoasj8FtzchQTTwJhkR0IV5jM91LVTvm1Fe1b/fh0aSN3rEoudgDyU6QJA7dSSKxB+goY/JNoV+Z58FTcfKJcS5gxONFkIn8BasLQgkMRDrPwUBIHkpZB0QbvtqBUIDHQrGCJkt+E3/F3fu7DGsEXbpnuUUH9tniye6PXRiOQfnm8iAjyaA6zdsonYnZ69Bx/ES8nYHpl2tO35L3xwrwZCZreGWaxn3j/X2EPRunMwYQlZ7h9pGrcjgUragDEXCg5sOA1e/ocvHNw8d4mFUHszP18VVTpEgLs1LgmR6g/Tj4hmlMWNdz10Bu2MT6IRGzhmBCxxxDpEsMm+B7Z6YXzMX3mk/+owuyAxPinCJREiHB1VSsmIuSRQhgeVqKTXSV8b+/uctStGvpU5Gjc/g2uu5oXeurE9Y3kVnmzkru3FzVoStJmIm0gT7sDKBV7XhlXlpLPcxgMlaP/nlJT684mQqVKAv0PbN7akmoWin8ENKUl5C+t34znRtYHDXxuNFJ3tf2iFp7X6eZwQi42LLBPE67TyzhcUaTvdYKOZslGMrfSd+bTt66tYDcsILOHybRvzlUytQyNFHPiOJZmmbvp7qV7tMC4lKYjRVzXHCDh8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
on args->serialized_data before checking if the physical address is valid.
Since physical address 0 does not map to virtual NULL (due to direct
mapping offsets), the subsequent check 'if (!ser)' was ineffective at
catching a missing serialized_data, leading to unsafe dereferences later.

Validate that args->serialized_data is non-zero before calling
phys_to_virt().

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/memfd_luo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..10f3983b0060 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
@@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return -EINVAL;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-- 
2.55.0.rc0.799.gd6f94ed593-goog


