Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5664AC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC716B009D; Tue, 22 Jul 2025 14:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE076B009E; Tue, 22 Jul 2025 14:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D3C6B009F; Tue, 22 Jul 2025 14:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B467B6B009D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:23:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9353A1A04D3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:23:22 +0000 (UTC)
X-FDA: 83692723044.30.98D4CE2
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id B062340007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:23:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmL9DzuX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208600; a=rsa-sha256;
	cv=none;
	b=20Zg3K/Lq257Wa56OTFj9/+/0zCuihoebWV0/Hzq8CyM8z/eC512Wfq15rpDann57GT9vX
	eRHDjt3a61qwA7WKByUBYqvRgjNiQrb8jUarZnWFz8qLpgnxPWGhv+ufK0TMIG8hLWrLxD
	HGMufc2ZrAV3vFE4Bu/kL4pGWqDbvVs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmL9DzuX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1Of4Qn6DHAz41QCxOo9ql3PDaWu1x47H9yNoUFcjZFY=;
	b=iKolhz9S068g2B571NWgmD91NKNgPK8ZOs+2+yHj+/pM4Sp0QP9r2o1W6Hf/LwsWaYLRIY
	rZx+PDHzdm/y4PwPp7Ag0Dp3MDZ7Cj8QCHBrx+xMTYrPrq1hmbOy07eX4fb+sNAKit9tLq
	aGuTG2IeshhiwxVe9xDRQdmYdTEMKHQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-236470b2dceso47955085ad.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753208599; x=1753813399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Of4Qn6DHAz41QCxOo9ql3PDaWu1x47H9yNoUFcjZFY=;
        b=mmL9DzuXtPjnNVnLly1INx+RlRxXNg0xJHf9+0odk1SKoVsyRowF+7RLQeRUHSVH9F
         NhHZsi/3giEVA3Hm+ZkEpM8XAKPQMjDKhIWtgTaIsS4eJ1qYP5Bn8W7Gs3OGmE3uS5vq
         9OgqZ+Nqws9DM+eKILT9EK6SlhHrDZ8Mj7sWj+pvSkR1kNe2S6bhdtKV4AgNFM6lfv9I
         JjGgg7H0BZMGT8NWNOZy6L+NLDX+Gza16m2/hJujpcyO9kbi2RZp+z2OFMEpH7uaqRYm
         Ml+jmxKPihpIHrpwHj1y+XOJ/3TBabnqCa18EJVAGlkOqIHohhC+sDworw2BctojMBNY
         m+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208599; x=1753813399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Of4Qn6DHAz41QCxOo9ql3PDaWu1x47H9yNoUFcjZFY=;
        b=VV5I0rxDOUGddk3Aj/asfhFwndIrLQjLy0MMgw/fOkAhBtxCzR9/g5imSzOPFOKYSC
         7RPoeNES1boWATpsuP8JzFKoWYRDT6/34KL/lPbIc6Gyp9E4V1DJ2tGBT/5qN7loILYJ
         Yrs1Sf5kbSPp9XebuofOfnmHc+kMroX1bDi7MAUmtKAgHNI1bHEAy+YCv4Tn5OcFicKt
         5FfqwAUTMLFl0cYvtlnG+JqCyeONULzpyaQKFh91smYQpQshClZMtHWjKsn5shsUtL+s
         zjxJMAmKw2qDmHKKNaW3n3w3i6TumVA/8YoUJs+ovaIdPwQY3QVp+SjzSOA5ePyum++f
         esNw==
X-Gm-Message-State: AOJu0YxwG2OudCklKoIxPwXY+HNfDnnVg/hCYKN0IwH+/izoes4Ug852
	B/tEjGSJACleqHp6zZbrTR3VMhvLoGbAxwaPu4fLJhtPL07IFbMKSPJKqsrHYA==
X-Gm-Gg: ASbGncvzepeaH1E90uLSpKqyRN5ISTaSRtkvemo8KNqu7cFJIF3NpqKvpHRsLMmBDwc
	ure8bI59mWmqfhL9TpUe4334XC4ssP5X5dnHhVYTHpBCOkdPjY/cwgJl6Te2yMjXAs5KwAhbs6+
	SUVZEEdp7dNPqBCUSCMQYiC9hbei+6FFFFav/HTLnynZNmDZPziy4aT78mvqxAU0EKKwNL2xsYm
	zPJrdFeY1ZPcCNwpNM8KXbcRKSWKDFD/YV56DV88k3XFBMQdxw+LOgwGr/MXHl+xZ5EHzpISUuB
	zlwffmdYXNa2d5DMBGC5DuV0zvEfzCARkd8/3+Vqxlqe3BLoG5BYnF38j6ZQHttTiUXn/nornoO
	G8gxGV1xwMjLyIfrW
X-Google-Smtp-Source: AGHT+IGwXRFG3UfYZv6MRp/SYxZZZJsT2jaTq8F71KRcn4AwxXNmFDjvhJHky3nkRh8GPyLOu8hB6w==
X-Received: by 2002:a17:902:ec8b:b0:235:f3df:bc1f with SMTP id d9443c01a7336-23e257451fdmr338082915ad.36.1753208599194;
        Tue, 22 Jul 2025 11:23:19 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4a04sm80830135ad.91.2025.07.22.11.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 11:23:18 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	willy@infradead.org
Subject: [PATCH]  mm/page-flags: remove folio_start_writeback_keepwrite()
Date: Tue, 22 Jul 2025 11:22:30 -0700
Message-ID: <20250722182230.2114587-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B062340007
X-Stat-Signature: kn87g3oraij38gy4x14qcem84naz1f7o
X-HE-Tag: 1753208600-79679
X-HE-Meta: U2FsdGVkX1/8v91UL4sLnbmm4aBvbmTHhIHrX6gpVjlHWVeRBBO+U0Eaor1SPmOgtS9lUFoLziaa6QUi1c+PFC7UQh4EbEABrm63W2LCglbrmfbb2LGAZj0UxIdsh9xvnxknxGQSBJd4QRXjOnVhJYG/dEI9b/eKmTNHuXnciMk+22fVWWu3IRPZjD+r02J5NOCx5fDetoGxGZTPVJFPIwgWZw2VoFI/hJn8rMX4t55zX1eRc33ih+KhxK+mOAWc6utUOP6dArA7bZAv/etHJzf5/5q2QTHUSMGxuXDiMeDGh6WhLYfgaewymHfpTcUKy6E5LhupGphfEFHjfGHPc8xbmPcbACG5pC2MVUU0hvh9X0Qn5JfxRuk2fi19UC/abYfolJmy6flcX8GCMCHF+YJ1ZTNJvH7GDb5piLdyuG9uuNffr9tVQExxOthbfxSNupmlZVRKoXymxSOClIPHstTYkcAe4H33aulKGrh/WJvSd3k9YtTbjanG9rEvYXLqTsyBdVhoqWB8Ttxzug4s6QwXiYK9I1yo/CQfwmJijodDuYfWwJVudP1BLWpVHv4e9AyXB5myxDp89H8VP3fByZ3+6RIXoHy9o0K4vNkKEXKz9eTy2Uud3ktWTG5DqsdY3ALmabqOAPsktGZlPdQhiTcsf6izF9sawiH56MfeT69ssEArl6MqzADOD+F/31SeWIzN5oeIvICZ5djTs/zQnCcbfdvthmw235ctPRwc6YWc2PMDZ8aVf8tsiVy4dn6NnRMfZoA2GZxgxrPOM2X0Lf1eifiLwZIE3lwXPGNbw1bVLbRV6isNbhDSfbhLdZ5v8kCblVhAMPtJWxKkb36hdbaOViZ4EeunDNvVhKkeGBgPCK9lMG2n1DGAg0ePYQ+/4e6LNRooSfaoj+ncEzfUu2K6fXXcBhCjgjgEA7WEuC8u6JeS/6iwSVSdeJvSCLBi7H6dcgZOtAF0HSeCorK
 O7l9G5/S
 04cEy9E8Rps/+vvwF194iJZID6yP0KtOGKU5VfeSxgbx7ec+FLa4Ntn5+vP5Zp8JfJb5He+bUiVGcrXd0LY6MIzodohxYSDSjcCCHYwjX7D8pVh63vIfzr7BwZVVntM0VSeqLLLjgGGrWYy9eRlajlR0GODq3x5lCrK3Ut8Fkohvim1ayJGviD1ry9wUazAP2MrbJqm66TiFGWL4vAzJsiT97w8Nn9Bv6XwK2TxJpuvt1Wg/BwhhWCppeSPDpqfWUWv4xQTPWsj1qcGWMaVS44hNSUqQiqLs5T/KP/vRvMWwjOspJGAm0XDI1Pi9QddWX3g7kGdEEcXRpsMAvtqmqXSR404pFX3EmMl3UgK79tzfykx8DEnJgJheM2yTw1UO1GttfGQ4FsoSq/dVS7t1vRAqKNa6repfruqBIRs9RIryZotfNyJ4djooxkm6ed5e8A3tVxbraDC/hzwfMFIWzrHry52ZJXfvcRvIrwhskfjtdKemYPz8np7jJO/M5aHqrEoQlBPNzq4NY/OExgYsNNxAXN1mNcCyKwQ28N/M9hkKMNtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit cd57b77197a4 ("ext4: Convert ext4_bio_write_page() to use a
folio) removed set_page_writeback_keepwrite() which was the last/only
caller of folio_start_writeback_keepwrite().

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/page-flags.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8e4d6eda8a8d..8d3fa3a91ce4 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -837,8 +837,6 @@ void set_page_writeback(struct page *page);
 
 #define folio_start_writeback(folio)			\
 	__folio_start_writeback(folio, false)
-#define folio_start_writeback_keepwrite(folio)	\
-	__folio_start_writeback(folio, true)
 
 static __always_inline bool folio_test_head(const struct folio *folio)
 {
-- 
2.47.1


