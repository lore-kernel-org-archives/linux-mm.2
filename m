Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70AE7C61DC6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E3A6B008C; Fri, 28 Aug 2026 04:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8166B0092; Fri, 28 Aug 2026 04:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DCA6B0095; Fri, 28 Aug 2026 04:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1806B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:47:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 865F61402AC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:47:35 +0000 (UTC)
X-FDA: 85150049670.24.8269DEB
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id D4EA840007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:47:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAdPJTSQ;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787906853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RXLz3Xl6C6oGFGDAhFniglml06HtyDSEVADuwjc8Bss=;
	b=q86owS6UhnfjFhtKtMTizFQ6/ZlyK9mirelOa/HVf+xp+/7hFekCfnSZ9IenpzUmt8n1aU
	GjRC7bwA7gEKRbO47IsHMACKI9HljWIACFIf6LgjylIrGCHCfTZSo4BYkvR2469DfqlTLT
	KOJUBcRTtxKyJVJHhdQhJUQpxO8A3GI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kAdPJTSQ;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787906853;
	b=5N2VmZab/SX3Eb3rBr9tJ4xiV+XePVOsPUTXe95C09o7dAxvUcgwT6M1byiodmw9I/Wh1m
	Ph5Xy7Oqc0wv5j4rKr13oK0EOi3X5U9MMh2ul8+269CRMilWCstuvSCcXoQhH0EAWdTMtJ
	jFsjwVGsljfXAKaw7bnrvpdu9NZigAU=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1519288a12.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787906852; x=1788511652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXLz3Xl6C6oGFGDAhFniglml06HtyDSEVADuwjc8Bss=;
        b=kAdPJTSQGxNOX299yNOsHxMuCZFSPV8ZwTYli66znYElYjrgXQV4Oa2SI+cR7dg5j9
         4isLcT+kO1e5vXuqfXUYQbEgz27DxHlICupN1JgFpZzeDxBlNbn+XKeRI9kA02FRUMX5
         XcHETV36H2illee70acSmyvWwTtsmp5ipzaXwNYvLedf85P3sZThKSj5Wv5QPr2vXx93
         KCy9+NSawo56ArCNlHQ6SNsGV+UaHpNFruoJb+5v7/dwYmQonwBfSDqghjr73OODlafI
         Kdv20p+ad7eh0t9mvb3rcOHvQjLGg42QdvxQGYl84e9kUYkcy8Wv8aqlSxTA4vk5XMtn
         vf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787906852; x=1788511652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXLz3Xl6C6oGFGDAhFniglml06HtyDSEVADuwjc8Bss=;
        b=NmOh2S5FzpIv6M9GkISAD9BjtVtQRwY9iMMYi7nBwcKBtlHF/jGU/aKgmVR+Nk3oZ8
         Wal72SYtU7ybQLX4TJN/3wCDg8BCe/JAZ5J5lKPQaTKoYEPKlqyhlQxfqvH0pEk2rmpe
         fAE7oGziUf/1qp7DhgdHIAurQjBqv8gpW/6B60VEAQZkjzytkrju0x1XiqUNG3CdJk2+
         zst+aYUWpP8X9qiNWDKWonZnx8WlHyTHKJwfA1K5oGwuPmMGEvrahNQdxdxeKMI1RdSj
         m3NdlDrtiGoA6HDSoL9SAEhBGb+oFrBW08uQprWywP0D+d7hOZw1SxtOAzrgQY5EFYmI
         be/g==
X-Forwarded-Encrypted: i=1; AHgh+RqjTWoLko0/YhMSuJnXwelxN/RmzFmnDnMOuh18fNRQC7YxjzKpemReFWmGWjWRwGbE5I7DNMI6jQ==@kvack.org
X-Gm-Message-State: AFuF++lcwCSKmsiVPThlwCJN4TKOg3CohwwDOEr1PCAz10LLABezdK0h
	0kA8SruIb7/v2bpzXUz4ZdkHy6/Tlf//Yc1KhQ40T6wWsQGF2Jsa7cu5
X-Gm-Gg: AR+sD11zn3CrSVt591mvf0yRJYevDip7U+DUw2J+ioNtTGOmydSGIF9a8fHjQfpz5aa
	sj9SyIBGV2sBCxuoR9mJUcq5shCQU3BKw0f8sWgR9FmsH2tah5UJH2/n9GZtcAUD84F2i8ohChp
	6snQkoEBtm+Vs+xYETi05lMAIecbSAKkh34xMTJhyUAUqnmO6U8rf17rCga/+5hLkek7ObtkG0X
	FBAV0fCUDhOwCqOvnCaIP8USfKZWVJ9vO7m8zssYls+lopviGXI+fxaBa7Ihy5/IZ3mpinGVm8O
	RMk7TRw4+ZdXSA3QgQ+vfGPLvdkoIIOhz2Jd0+xqE0p+TemoxMO2rev66FkySLNODdzVtS3gQxC
	6kvWmCNqFeOCTUl+X3+rGigxz9sDDJIZRzL35ouB+dVMwNFeCgYoGBTwdznsmplgqFr+CREEocM
	sU7JRifjEuMgPGRakFJOIkuYZ0soLlhYePdM/6Kz7CG5XuHxbhAFOrfeR7UT+1fvgAJw==
X-Received: by 2002:a17:90b:1a92:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-396d0d35e02mr5577342a91.1.1787906852389;
        Fri, 28 Aug 2026 01:47:32 -0700 (PDT)
Received: from celestia ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992e05sm6292591a91.15.2026.08.28.01.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:47:31 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon: fix unconditionally skip last region
Date: Fri, 28 Aug 2026 16:47:37 +0800
Message-ID: <20260828084737.290024-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: utpp9ndac44hhj9d39bdgj974jm38rwg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4EA840007
X-Rspam-User: 
X-HE-Tag: 1787906853-194648
X-HE-Meta: U2FsdGVkX1+8j6COc7RFQoHvsAMPOViolvvFKCVh5dus+1H1jajdMv0UvIcQzrEsafINtLW4DHSkDm1ducbSVo6klaZUCgxm4pl0yKpGrNaWtq6xwGZ8MHqlc5jj1/Vt+31udAWJxnDXrCHOYG5X7KzoZjaLNl+pU+HfKiwOkXqTKrUTV64TtoQ5tK39+mXNpUSnmKS4db98lI0DBjdQnn0230pdo1Cmjyx9cRfusviYZV13e05a8bt6YZgv1deOC6eTBTJ4CXK+6N0C3O9y2qSMi7ghyPw7uT2XzcwoI9Ufg6H58CStXGRa38T+/usCqVzcDtpm7AlgoV88q5DtnmgNN3gchc0UZSOZWrKztL/QDeQaXXkflUOtRn1dvaVebIUtS1ga2YWX2/aTjM1F5hg/b4th7nA3cyBNr8C5Vs2Vn0ULNrJTNfVlqJTOy4bvFyXwHceVdf4jRxIi/8sbM/mf9hrDNNjgChw2JuFh7KewXoDZRjKbWm0UZpBWx2Rm1N1aFDqpQKESmBrm6buWKvBJbEymDqYN/XBYOiidH8d9qygALguSsrIOoyZMHByD8MCeXzKh0/yLrzmNQCLHdaqBhZIOq3fN3lZg6NFRMcUmj1gIVm+eaH4g38YczRFEWOhMCUTr7/rxIqRJNKS0mGuJ73pWoIzeuNeWobrPf1R5PkU5bX1of1M5DJIqYDjCto6TV/+c7CnzvtYG8mvvG2I0Y10V6/Ko12y7jTutpsEAfE0+OelTD86qFHaC9EJ6WLGEN0jqyJgk9l5T8HGRx+291hays8/nlDaQ/1smLj0JJurFSVsEMIb8UmZeoSuj8uw+XQZMFPs6yU6+FZo8SR6aKE4WrD8SQXcKiLy4ySk7QrYot5a4lB5dU/g32EiMMAN0ujpiZ+HtcIbT8p4oFfeNwbwxL5Bm13Z6oeji6RitsOsGwP9+lfyfpqSe1WqdxCB52AMYx/ZzLMqbVzd
 DPOksFCM
 2QStYwY5Kp9k6UY1s+WyPNlmxV0jhY2y+h5lwOi7vIDCtVbFW2Aey+czE0Omixop+ruRDf16q1iOTyAMWHgK8vbjXkGxit/TFXLCx0MWLw+EuH1NGMrwZmlLtX4ftAJTL9zyeOsSvJYxJCLh1PW+LivpALdjxBBXFZOL+RRZXJ01aeBwlONE050YTxrBU1dyqvW0WIROLWhOYc870XKfB1SdBkDqUNDKSjeIAOuChNGr/sWVIDf6triXMWtVVmcZxzYp4erh15Id5zvPy/OE2j766cUhZPHZd7VoO5McQYNHPKeUa/7pMvez20sMoejPQXfdxtvQAaUbgsXh+6PuZZ+iOsmsJdLrLfZW01xlNglBN/IVQ4+0+30wqdUaH7UgxIRLQIw0vgQw5fWdk6zXBkkfBqcNgxlqdVGl+z01GfNgKIKUiDbqE/EuV/JIfOwS3z4vugfO42mc2ib+JYCwHayP2NrzP1CF4WleYsYlXNFkWtYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can
be skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 50 bytes per window.
    3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved
       at (Target, 50).
    4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is
       full. Cursor is saved at (Target, 100), which is exactly the
       start of R2.
    5. Window 3: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the cursor.

    Result: R2 is permanently skipped even though it has never been
    processed.

Fix this by only skipping the last region after it has been applied.

Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Cc: <stable@vger.kernel.org> # v5.16.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from RFC v1:
- Minimal fix, only fixes the issue where the last-region is skipped.
- Add an example to the commit message to demonstrate that this error
  occurs very rarely.
- RFC v1: https://lore.kernel.org/damon/20260825124616.5129-1-aethernet65535@gmail.com

---
 mm/damon/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..21dc6b086c42 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2347,14 +2347,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
+				r->ar.end <= quota->charge_addr_from) {
+			if (r->ar.end == quota->charge_addr_from ||
+					damon_is_last_region(r, t)) {
+				quota->charge_target_from = NULL;
+				quota->charge_addr_from = 0;
+			}
 			return true;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
-- 
2.55.0


