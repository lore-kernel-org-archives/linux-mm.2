Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E54E67A6B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 05:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04DB6B0005; Tue,  3 Mar 2026 00:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2426B0088; Tue,  3 Mar 2026 00:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4536B0089; Tue,  3 Mar 2026 00:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABFCC6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 00:25:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 54E2C1C866
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:25:43 +0000 (UTC)
X-FDA: 84503614566.13.5F09ABA
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8642F180009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:25:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ttx+WDT;
	spf=pass (imf06.hostedemail.com: domain of 303CmaQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=303CmaQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772515541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6P9Cvc5u0BaqZ0ifWcq/2P9uYbL+PXFQEz5HrmvWPE=;
	b=JHDRQI7SHUiOTbq3PhCEea7NbxX23Y1lSIvO8LTJVTPoq6vpQkqYTpAotjHMXNhFp1Q+Mv
	ZvAiC8QhMgTUoZN4S2478XuaRJupfHFp0CH53Ep8cSE30T1o5TgphAYp2GMahdfdNrxfkT
	os/ft5Z8kJs4cR4/61cGgSyE2hZ6NT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772515541; a=rsa-sha256;
	cv=none;
	b=UP+eBcGEX8u7gkqdDrCUQtkpMz6nZ4wD3DH+eTDOylZ+Ic/n8SwTCKHuI17ugHC9Dl7jLj
	VTgkRudBfWcrXcV17usaMC43npqg0FaVFaUDHTLwbnmslKWX+JShfULHps60iPGuTn8pC4
	TbYHQG42KNX5jbtuW3YIlUS60KT7eFk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ttx+WDT;
	spf=pass (imf06.hostedemail.com: domain of 303CmaQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=303CmaQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1276e71652fso9378853c88.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 21:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772515540; x=1773120340; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k6P9Cvc5u0BaqZ0ifWcq/2P9uYbL+PXFQEz5HrmvWPE=;
        b=2ttx+WDTuel5JAOv+j1le8+maSJnPlncqWWGlPBgGosX0Hr8NBP6d269qcrNEOLldP
         5497RShqBZwgvTI8kBjzzBJofVVSFwswVX8okX45KblclyWs9Hy9Lf2WUfvqUEnCnQJF
         6KuZu1C9+AMr2heBp0HnmHihW5otRF/blgGGOvMapy2Tkto5c3/jsDztIXhazEzPnL+r
         MjPernTnxqdTuRU2HmojoCQcVBoQ/GLWQtMwyZWIf2jPpQU5YUqc4tv1FFKMEaZoz6rL
         9EJkEf2iB2yq60KFBTYSL25sgFbsM7n5ZgMr3zURQUjoTE+rmtGOx+8Xlh7Dm9tcO89w
         sqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772515540; x=1773120340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6P9Cvc5u0BaqZ0ifWcq/2P9uYbL+PXFQEz5HrmvWPE=;
        b=P9Zw06raMSQRyqMB8HOw3Q53WWEkzzwFvg7GlefV9VfD6fMq9fNRRZ+AJ4o5PfEuBn
         V5IjuOhmPzu19xjxP5tEj4BGrM/BtUMS9UAVjGQaLQvCT+bFF/w3G3wKr9rYGNM4aJph
         wohDMm3hVYVhGbA5NKHh9KHQMNH2/G+ZUvu/NqJ8s+lBRPXGhVCl2RisypSOfTg/FZif
         SRzAUD1BQ65Oy6+XWtuALILcxCHB4K8+fY9dazOOT22dFO1hzs8bIEgRXw7AZyWhDmy1
         V2uktMQzT3O4n4YDkTIVJPcGxVZswquzztxTIycV/mo3uCy5ZamVVViG/eTeUrqdhCsU
         mqlg==
X-Forwarded-Encrypted: i=1; AJvYcCXE3BDrqzOI2jDWYMzgft+UO5+bqSj04CoLoj8Qkkz6BTRzGFsNtgO5qBAcSpvScqc5EQcDJlcbxQ==@kvack.org
X-Gm-Message-State: AOJu0YyIbj+nerBf0vaeHumsqhhZWBujGrSSfmudLjb/44puS+z2eaiF
	3uBYCxLf+Yu2jriZQyxKrJQvk9KeaDIm57ZBJkJOsxzUHg2gMBTL9tAlyHLnoTsa9g030DMO2/J
	sd1hY6/9svLL8Mg==
X-Received: from dlbpd8.prod.google.com ([2002:a05:7022:1408:b0:127:8d0d:ba17])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:248a:b0:124:b11f:67ec with SMTP id a92af1059eb24-1278fc6f217mr5778394c88.39.1772515539799;
 Mon, 02 Mar 2026 21:25:39 -0800 (PST)
Date: Tue,  3 Mar 2026 05:25:17 +0000
In-Reply-To: <20260302070351.3465439-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260302070351.3465439-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303052519.109244-1-bingjiao@google.com>
Subject: [PATCH v2] mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@kernel.org, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8642F180009
X-Stat-Signature: w7zyhkqajxg3fa87pib3tpq1t5nmp8pw
X-Rspam-User: 
X-HE-Tag: 1772515541-911438
X-HE-Meta: U2FsdGVkX1/m3ds1jN0HWRA0CwnWEF1yr6N5oOO0EmfDK85D/xc5JfCt0nWlNyVBtqDwv/4Phx3Qh0EG7NviDII3isjm4oCQqAn8YK9nt3/eUh8uwiz/tIxASm9XlAdEQOx1rN9TObTeot5VfbhdmdaARBuM8wH1Q24sZmzRDTR9lU4Uad9ydJlPMYk1p9SqzmvCa0TRUL7qaAfnWEoiIjuraLQexFKapmHr18O8yexE4fE5FndKJUZtgUk3Tk3py2gDnlDtrpR1gQvWrHKoPV/aWdHyNsFMY8bA88ew25ACbwxCAxLnKVV5qGB9D9YuPwH6uaAudv8oYcAzaoZjgFDptBLvCo8p+s7p+wIItnykn8YnPemb+70P4acoTI8eqrcH9z52huFFdC3OmTsqJX25EAJ3yQsJaGvrQzVS97VnACgznc7Ed/GNNDt3eWQzIYsulQA91isaRKmfdzvO61MBOO8W6+zTyqUw7X0thfM4Moui0/QSteGaq4YAJwfBOmGoh/uWLrBly35N8LIL14qhjA7/SK3LooaKeBgz5toNwxHb46pC+TbViCiAT7KagklqZVhcHJMXlx23bF03Vtz9C9y59cMpGN2BUMZvvhFvzp/xlpPDltDpUaLAfk2cBdgaXULxJB1nBszBRXX2mPICw39dGqILqtruRLWc0l4QX7u566tojJ3sjjBQlB1RcKzV7+oy6sontWLU7NuhPgS+squhgQrbiKIU5IEUEYarZOLNIme9F+cSI1gNUMhVvvi7gPhY465a9HvntH78l2bm+7rc/cf+sKUySYYU7zIaSUkRd1/Qr8gunGMonZQIqgR7pruSuqE6D0ofVD+gyLmi421b/SS3ywQBmyVLrVthC4RPtksDvHtrUMaWuvt8uHabHN1zvXosz/jWbiNzVpjAsdftzZped1TUJJPU6oDi7+M4IzgTSoSdsjtweEZTUG1tdulYybHyRwulTs0
 hBFrTyWQ
 st0WPYsBdXaM5ndgU1mqb0H+JfLMemoqVEb417cPQPn5lW6py5AgH9SFXKXj32Xt7JuAjtEvQm81igxx5J04u18r6rkQ++XAYqCaCk4G3g9/7tK1Xqzqk89fmw4fIvu2rfLsah34mu6ltBUW/nlGkcIIfM1nEKFXplVFOkQQTd6/bDxM6pUNLgAvdBpIP5Q48hhDtOY2QEPIOPCeprHtyRum2w9OhMM5L25QbUHDgXHJeVlVHK5LVHI08NEXkBajx2TTEpeAsET4sBIjTSmzy+Nd1sQg2Uz/jcYWvptucAgHenhh+Yj++kFh22iafySKwjyb0w5kvzeJe3sHqxzEEQ1eocDjgSf7Ml+yXbnA4z+LXyMUkyfOjy5CWoXQMvPO6vNiw3RpipJWiHVjiDh/7zk/2TEJXHS9M7nvmE3/QcdkffscPZRelCN4WiqrCrW4gn+65zc7fjhuTI4AxkCHpFDlQDshK9TZnPHlcUhU3hNzSaLUqmLMWRgm3QbCop2JWjYTqHTrZkS2ed3wIUsV7TPxzGApCVhV50RUQjqgXdjetDbwnQnS1vuesFo10A6smMGjzBH/A4tmwO3zV4wXm9TZFLVrrhNVqoLuJsm7iSgDIKw5/0QvyHrOc8ZstWr2kuUPT7vsglaGufVKnBVGTkLu4zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_demote_folio(), mtc->nmask is set to NULL for the first
allocation. If that succeeds, it returns without restoring mtc->nmask
to allowed_mask. For subsequent allocations from the migrate_pages()
batch, mtc->nmask will be NULL. If the target node then becomes full,
the fallback allocation will use nmask = NULL, allocating from any
node allowed by the task cpuset, which for kswapd is all nodes.

To address this issue, use a local copy of the mtc structure with
nmask = NULL for the first allocation attempt specifically, ensuring
the original mtc remains unmodified.

Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cbffc0a27824..c4e0ce737e03 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -966,13 +966,11 @@ static void folio_check_dirty_writeback(struct folio *folio,
 static struct folio *alloc_demote_folio(struct folio *src,
 		unsigned long private)
 {
+	struct migration_target_control *mtc, target_nid_mtc;
 	struct folio *dst;
-	nodemask_t *allowed_mask;
-	struct migration_target_control *mtc;

 	mtc = (struct migration_target_control *)private;

-	allowed_mask = mtc->nmask;
 	/*
 	 * make sure we allocate from the target node first also trying to
 	 * demote or reclaim pages from the target node via kswapd if we are
@@ -982,15 +980,13 @@ static struct folio *alloc_demote_folio(struct folio *src,
 	 * a demotion of cold pages from the target memtier. This can result
 	 * in the kernel placing hot pages in slower(lower) memory tiers.
 	 */
-	mtc->nmask = NULL;
-	mtc->gfp_mask |= __GFP_THISNODE;
-	dst = alloc_migration_target(src, (unsigned long)mtc);
+	target_nid_mtc = *mtc;
+	target_nid_mtc.nmask = NULL;
+	target_nid_mtc.gfp_mask |= __GFP_THISNODE;
+	dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
 	if (dst)
 		return dst;

-	mtc->gfp_mask &= ~__GFP_THISNODE;
-	mtc->nmask = allowed_mask;
-
 	return alloc_migration_target(src, (unsigned long)mtc);
 }

--
2.53.0.473.g4a7958ca14-goog


