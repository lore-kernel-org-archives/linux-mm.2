Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67ACCCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88776B008A; Wed, 29 Apr 2026 10:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38DA6B0092; Wed, 29 Apr 2026 10:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9514B6B0093; Wed, 29 Apr 2026 10:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8311C6B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:05:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A48D8AE61
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:05:04 +0000 (UTC)
X-FDA: 84711764928.11.0B31BD2
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 46D9014001C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:05:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qu5+42Hw;
	spf=pass (imf23.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777471502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fVS/+V2p/mPzOF3wQlnGAteK5jgMJ6nJm2r/tQzjG/w=;
	b=i0JHSaTDxUUJ6+Wdj9oWmHw+3dVVY04NVrpmyf2VeMkjP2asq0ramPFfMT9rU5OAZycLw1
	M1yaT6uZ7d+Zmn3aydhnoxzOPWYwA7ASwBSCEP4ohr9R90a/bBTWJm5iUXM8AebcACCt/j
	+5E0/O0L//4ee803eo+A2NcCpg3Pxvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777471502; a=rsa-sha256;
	cv=none;
	b=c6o73EHrQuiZlAXZwCKoibbDMZxXf+ukvfK5iDHyPgzE/pUrtcSGQJTUzKyHwxipLfeGhX
	W2UWLrAZq6lUK3veNFURwk3UMUZGgU68V+BGas1A3tHB2uyrvP9CQ1omtni5PACZnNsQUc
	Xls9ouNdCsBKsesoj3Qgy846iyJb4E4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qu5+42Hw;
	spf=pass (imf23.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82f68b3aaf7so4799039b3a.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777471501; x=1778076301; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fVS/+V2p/mPzOF3wQlnGAteK5jgMJ6nJm2r/tQzjG/w=;
        b=qu5+42HwnEzeugk2j9ImW8P50O4aC81LHdeecD8XOTAVLf/sKYj1gOmPY1mskAyIie
         RCzOQoosgW7HbaQ5C7DayG6os7BaRObAxEIoo7dru2iPFKh8GYr+oMj0ez4J+FSiiHpU
         fk8e807au2z4ikpqSFAXflEXK22DwRHKz2ODAjJG0VpZ1PhpxA45iVWLc2bDLmgCsxbu
         1G3JNM2fvjkHJg0KBH1LGrEZzZdWZpyxwz+quoTILxg/VhVYnpmZ3U+MY6nYqe1A65jD
         VG0I8BV2jGvwSKQMJZXV79AkcD6JnvROBeLEFElr90jljOd+d5G1SKJwYVrC9+bv+zhz
         9a9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777471501; x=1778076301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVS/+V2p/mPzOF3wQlnGAteK5jgMJ6nJm2r/tQzjG/w=;
        b=MAqG/n9Kiu6wP8wL7mQZVtAllwVO9CQa527N5Q8oGnCyPAooKSxbjtDi2g5hyo2+i2
         vJWM1xXAr7XmpEsgiToscn+eTJNx0M5XDJ3LyQaRD2XEbhPyhPPE2YE7ScjYGG4BcPZN
         fP1JBPF7bppLT/VNzNEc3uxMMeq3mOXE+K6YB0HPNNVDOqcip1Ge/OkoIE8xRIgRptbW
         DuuS/iRsvWT9BGJWm8uOUFGBy1PRKid0pXmntFXZ2KYRaBa39RJd/LKf47i82zv5F4xd
         MEoyaeFuKxuqR871PYnS/R6HQtsEh/dwwBureGMHRX/cP37IfkVtEeTZPZ9B53onHScL
         dT5g==
X-Gm-Message-State: AOJu0YxR7mGYf7Sld7jBBu70sf0Tu6u+xEfWFZfg0DBXofFYJz0DVaMm
	rqfSkjnd7wtKKa8shvHNcf5NbbN1jGcgjp4mmq0CTKZPAsvT2K4HKm3Peo8AZKEtrPlULA==
X-Gm-Gg: AeBDievCZXgsbCEGbqlAayhCqscmG5E+hO392OBVgq6pcZJSDUfBLGj2hhD7eQX+xEU
	FcdnYOftpEF6lA5tErUsLqaX3ZET7DLYZgH8cCoIdjYiJihbJrfVA4h2eEXpskdcsBAO2FRGtLy
	P9V7kJbB4tOMOsL7C8RYmD68gP8Mka7xtNO2cbgt+NGmcDiI797JvAZC6ckqn4lqMPvbyvsQTh+
	GROiKa3IoxTE3bUPlZjjifmHvm3R0c/Faf4UpLnO2176OhDfcSE8/KJn+1S0DBeWWBJzJd+n++6
	PrQWHQOjKdMkiB0Dtzfi1KjFSbOcepNfE/wLw1NIhUH1rwdT1D8Ll1fMoIcv4tzRcIxHse+mcEL
	k5oME4njxY/M6Nw9WjhYYHADCPPMUedgPPQd2X50vLrk5bJJS2dm9uZ+IE8SpPwrHtoMUdQTIrI
	+4xHJJL6SkIhEE+wxSnynVdMXPXWMfttvFPJ8EHdzv
X-Received: by 2002:a05:6a00:2191:b0:82c:212a:906a with SMTP id d2e1a72fcca58-834ddbd1f0cmr7553957b3a.36.1777471500890;
        Wed, 29 Apr 2026 07:05:00 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:3097:5ced:f23a:32ed:4b52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed6de621sm2803027b3a.29.2026.04.29.07.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:05:00 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE in MADV_COLLAPSE
Date: Wed, 29 Apr 2026 19:34:34 +0530
Message-ID: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 46D9014001C
X-Stat-Signature: kneodut331fa31n5mhud1ux9jr6ka59o
X-Rspam-User: 
X-HE-Tag: 1777471502-333323
X-HE-Meta: U2FsdGVkX19nqaZIu1gOiWGWGecdf1aqyY/W8+znXkKQ5lRToWuiZgFtNLpJqa6HePnW2MPd4Hce79mSXUls8xGlR/AF2oggpj2i7mympWHoHBZ1KefRwMhb9PGmrVK/OHiJOJGSBUiLj09EABwUtT5Hcmuj4ytFZa3nOb5B3NcPWa45zyaepq8hC/Z2sveJvvsuChjmlS46bPcfz/KDNYimkKyezKnh4iyt1trDmPfTC9ODb3GmkhsrGu0SezteYy9gB/rJf9miygTwjBjzR/gnTwZ13gRaT/eFMi9uCsLVvoO/Ef+pB4Vew0T2Xlm0f/rthrnKgNYVvApS8Kre3RhEg93jy9L3yxJ09eiiOJurJ1mSwUGoN5W64enuHA6lqy2ybxMAkoc4cx7SsHQU1IEl33B8EWJYL3DvmYrw7ZAEmQxZH7WawiaWiu2A+owg6EtSPUZamuBY/uctkATrrpaBCbFEN+Kktuchoa75TcgPUgxMwXFomR+UN0HdkqEnaKro58boLd+moab/IaAp5BTG81LjhzHwKMPNAXE3ahpLrdBvacny0dsWDW3eLr0XFvMsxF4t/uc244+nOCHWrTYPcRBJklgYrL2g21/p74dHw2yyI13+ZgCsZIaJzNM6odkOtuAgjj00GkaHBcDjm2InJFSCPyKXj33gbwBNY5CE6n3hJQneZYYUvfxuxI88/HNTPplNtd+/9giI0BMC0hT+Rhx4y6p6BZGMDBr6LyPrC8aBpsbZf0kzOFhsKy4VBf6vzRkGJjVIbgktB7oACL8FRopank/PRC0TzdK3vm3mf+1CxD4HHqjAWPbG2DxJGuHwn5JSlJiOquN/L4fP5uTmeYDvFQ+64ml9Gqk+XKTNVxS4mQ//MaPzPRVxag29uva/N7o3OJctLE/M55caN75fGBiPBwzDL5W/wDhGC9eAd3dVM8zNcfTucHYTile9R9Qy7lVd157idnPOs2M
 SESkHXE4
 3qP5Ftn9H9mHwXSuk9xqBh/XQIclTdHP7E/E/2YYKxAoF1cmNrY1ZWvYjwZWWg6qh6oXwzd1A0SZ6FNlZcQnZo2rg6XD9kwflUNBXEd9cyshd8F9ZVL8iLWt4KQrZ2SgHKkw3VImNU1st9Y5x+uGH1deVF6Z7E0999ocWq7DWepZzeFFfNSSYsRnUkf0T/lGwU1IuhH9yoSH7O3OQ4Fe7+u++roeJzqdXwIcqYqDKrSIaSI7AT/UmH5hBR0nwYUFo/RVjdEagoinoc9AGCgUcF2mxZA1axhKRaXUtc6WsAOAKIPbvtQFx8wEankrBpRvUB4eeY4lFErzpkrl3vtyeByxhVIn+vj1oq7pVXv7ebzpLb1ABak2VoPxxtX0CqIbX3pInEudFbuEaeBQ9BVkfuWT4pcr+9oIYHmOlohRW+ymtdnzQfFL5o38Ly6kkHymaWQVXs4+iMyoTtyd1ZXhqPFMUhIZD19R4DUI5crTAmJvEyiTh3KhvadNj9FHlsBMIi1l9JDKewu6O+LdWz9VHewLLCk9oWERoWoLfXcoBenlmoKL88QgctdiQABnT6Pq/TdhO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLLAPSE uses errno values to provide actionable feedback to
userspace. Temporary resource constraints are mapped to -EAGAIN so the
caller may retry, while intrinsic failures of the specified range are
mapped to -EINVAL.

collapse_file() returns SCAN_PAGE_HAS_PRIVATE when
filemap_release_folio() fails while isolating file-backed folios for
collapse. This currently falls through the default case in
madvise_collapse_errno() and is reported to userspace as -EINVAL.

However, filemap_release_folio() failure commonly reflects temporary
folio state rather than a permanently uncollapsible range.

For example, ext4 returns false when a folio still has dirty
journalled data, btrfs returns false for dirty or writeback folios
before extent state release, and NFS may return false while reclaiming
filesystem-private folio state.

In such cases, retrying MADV_COLLAPSE after writeback, reclaim or
journal progress may succeed. This matches the existing -EAGAIN
handling for SCAN_PAGE_DIRTY_OR_WRITEBACK and other transient collapse
failures more closely than -EINVAL.

Therefore, map SCAN_PAGE_HAS_PRIVATE to -EAGAIN so userspace receives
retryable feedback for this temporary failure path.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 mm/khugepaged.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..58f55115d7d8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2808,6 +2808,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
 	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
-- 
2.54.0


