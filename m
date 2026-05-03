Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFE0FF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 06:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598046B008A; Sun,  3 May 2026 02:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F766B0092; Sun,  3 May 2026 02:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4853A6B0093; Sun,  3 May 2026 02:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37FBF6B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 02:02:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 077C7408FA
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:02:58 +0000 (UTC)
X-FDA: 84725065236.01.C896F06
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 05B071A000D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:02:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOPnwYMu;
	spf=pass (imf19.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777788176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDQOn1JNMa2LNQKCV+MjyGaeQIvkz+XSOsnEqnhjmOQ=;
	b=Xx15nONW+9h1QDLxD2sU+zQyhBcJ4r2Rxd5k4CYMiRc9yBt6nTeFzowRnuf2AtB3KAGddx
	/I+rSbsRW9HoZBX7An6jpz9unqd2k910X3GxA9kVSIP7VtXSMMTPmjKexb69cBSVUMcSte
	rBGBp7F2VhSxC+KgpEDRv4+J2dHRZOc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOPnwYMu;
	spf=pass (imf19.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777788176; a=rsa-sha256;
	cv=none;
	b=T7+eCAFRVM74e/Qcrk06Kx8M3rYFuolxvNGNq8ZYb2/z/dlzSKPxjB9y1Fp+zJC2vo96gK
	GVW2tszE9z24F14qjea8TNoRvKazmkWFYzQ1VRZ/hREFAmIglVemprKNhNXbqlEBsqf8EB
	oerP4cFD2QtsdQ9CihiJ2987JeRDmAQ=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-834f1075805so2174992b3a.2
        for <linux-mm@kvack.org>; Sat, 02 May 2026 23:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777788175; x=1778392975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDQOn1JNMa2LNQKCV+MjyGaeQIvkz+XSOsnEqnhjmOQ=;
        b=kOPnwYMuAfI94wOE3P++iv5XsxhUH9q9WmBiRkD1NIM0ebmLwrQbH9ysz1ymofJiwM
         iqx5lvRThTqtNq8rz8BVZj/9NWOs4ZSez8aT7/mrf5Ww/6JEkmoaoyVxoPyu48tdL0gZ
         qJw/qXnMnbtLc+POJBd59NpTH4xTOoKCIDHd2Z9UMrIipl1gZyQPhUWUt6JX9ivVYRXG
         vuVS3aLoDw+/n5muCR0qeYxYWnBn2Yw7Rb0t9uZ7LKfZMUPjDs6krLz1kTkyQ2ZFkB2g
         yb3ZF3JrO9z4Y0rFiHBdyJkP0K1E7WttmtbXbNr3KEUnA7LssbbFp+XgrS/L+pZLngwC
         we8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777788175; x=1778392975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TDQOn1JNMa2LNQKCV+MjyGaeQIvkz+XSOsnEqnhjmOQ=;
        b=QOWEk9E0IylAoMdeJujRQvsyBswyIQ7fgBGfSiBH/nth0QNIuiDH0P6+ygO9cSgmGu
         Et32MUsrkrxz072BD0Oa8QmaHubLG88zXDBnG7wP2xhb7/ZTdyyuPdNOn9FBzC02Aa7Y
         JWrh9mHZ9Oqdfwo7m4mfOQxggkC1RjHX4/o2rrZEnXuKVVLy+xLGuGCPRkzVBs9PAkKo
         SKBccVKzqpZG/RbiXlgIlsq3S6QVdFlPPgOdr4SE6k8FDCqopILwRK6VgJO2YAiv1e0p
         2jbgE6aDrKWrKila/ox4sHQvwzcZczfDemGs+bgny98Ef4j6NqHIbDu6pWX/ItihN+iV
         UTug==
X-Forwarded-Encrypted: i=1; AFNElJ8OusQPP4R2kwkElIDEMFNNpVdp6iFEzJ4XFvK0vYyXFmY+6P5sQt3MRVRDqpfJgvPg6qopyearOA==@kvack.org
X-Gm-Message-State: AOJu0YxAEN1whcJX1oqH+G9Srd4RAMxNO4cVxVgZT0oy3ca9VrWOgMeO
	h5x9HUkdSMswqRPobcHrq6FB8Dp5zGTDjJ8mG46PnbrcNeysBQOJACuP
X-Gm-Gg: AeBDietdQbfSqasoclmJDcuHgSZUWlLgGmLMOAmXpN7xmJ9QUAQwDIYymAgddYooAOt
	xv3VWSOzgX+CbUb87jqPDjAoNtLb4Xmn/CGqEYemp1uOOVIg33AgtaY4hhOF7Bs4wfIpE2vvnpV
	O9h+HHTENhk/r9iNg7TYmtcF3M+LdXyE3nymRaCBa0xIx1Va+mH8wK3NP2ry47rxy6C6OG+BhWB
	AhstepqlCpnCxUsgFF++9pAzUzG8fy3190eYwjIQnBzNMMhhX7G/yzCPGVPwjy2Vlx8cWk29sAh
	0UUIJ/SZ7Dor3l7VJ4sTmvWVk5FF9pcR5A5miIqbWX3EQy6aoCPo543ucwSc0CZNWlOhT6UNZAy
	eSuvGisteTyymtNxmqKisxWvxc1Ij0lW1kQg6OFBuB6NIocS8X1jU+LmaIKI/NOIA+o+TOoXbuf
	xLoMUNJUTVIVpO5J0NDXtxMXM/nHz4G9SB/jT5kh0=
X-Received: by 2002:a05:6a00:1a8c:b0:82c:20be:57e6 with SMTP id d2e1a72fcca58-8352d15b7a0mr4860851b3a.11.1777788174683;
        Sat, 02 May 2026 23:02:54 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:edbd:7155:edb6:dac:107e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-835293f022asm4700468b3a.45.2026.05.02.23.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 23:02:54 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: shuah@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v2] selftests/mm: ksm-functional-tests: fix partial write handling
Date: Sun,  3 May 2026 11:30:30 +0530
Message-ID: <20260503060234.644650-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260502005702.593878-1-agarwal.vineet2006@gmail.com>
References: <20260502005702.593878-1-agarwal.vineet2006@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4nkt6xwcy14sx7pwf6csfjdf3rehnxps
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05B071A000D
X-Rspam-User: 
X-HE-Tag: 1777788175-568266
X-HE-Meta: U2FsdGVkX1/ppNX9PZxFBvME4Qi0qn4t/DQAYYmQeOgHgNPRHTQ8OoOdblztuJqbBPCBNFfylXZ/mn6a80SxgE10e9sWQO5aqrpzVqU3udjHLyDQP1G9v9rKvBX4s2MR1JVDKhUeUQNyNoujCYSErYrc/8GTVgLJgjSSYxd+JtyV86+xemVhQhhYmilYnzKks+YcdYfkH07gKi9F7FW854Z6lLODlNWQSFIsKv9rG/hvwpmX3YsamDNpgmOhUPuR8NbcU7i9CKOsxzVOLreNYy0pysf2UcZsgjS3+So5a1l7xw6/Xya1JnOJqnYBphShA+vbZnB/ivJf+HLhckGzaaGfHccgHdTe22TRb9ptYVeTGlHjO1iwojBgwcG6bKBd04KsqUxgx9l0gcXG2DYY0zp7NuTtnAMBlBzYYxYjsX4ihRSPDNxHltpY5m0pt5ArhX6sANUQokfnL2ibTAtkyoslnH+SEJjSDFEz9BDnsN0QdqZoJS1UOBF3CjWBlBJqFr3E1LB/LzUZgw2mX1teLmak6xnmNu2PnDl4CDUdY2aOQEk1WNzB58w8Xt1Vf2g9jHTbs7+OO5DVTigXHcDUHVQYAAjFeuJY/bJqT7X+ZTNRfkHmdSiN0uqLo5cpi0Y1rI8F/0PCCtIYFy4Wsf2Uy2HFPiI5AH6ZOP/B8YdSGObREMBLG7CvvwUkZ6NShD/UScBU+3iHZlnspmONPCfqBeFotNEzw7NZ5XhaEXD2Koe1Vl9RNn6PdZQ8jAJw85shq4VHQSHJ8Be+Thwy4mzPuzerkce8QV0eTzbMKkognZZajfbxJJVaXuP4P0M4P0Fbej8gqX6DjkmVRPjncEwdJvVIpeeK9WpcKA2zXBwwTAanooO61ocAY/lUxlWiP/gqbacvXXkkSx+fwfhpOhDhdyiVDbj3hQrnhAQPo3cK7L+z+OxXIdgpouL7ikaPnZElhPtk9S/BYbzlcCMnpD0
 TUmFSWwW
 pMxL//tgXwdHnqED1pvdpC3BCg84mMf+VQV4WiYJQziuWgJEfBxtDEUtEhn11TEyepu1yWVFWZ4go+9CGqaxbXb6Exv5MBPneprQAzAv3pWgs5iHG3WTSC+ziGov6hBcET0PLebwv3td01c+LhyBuw6P/ewd+xhTuEBxj/tEGVEEQOoMZxCtj9D48dO1+m+q156O+esV4ya7PjkHDbKg0fammwmeriVmGrMKo2K39tyVPfFVg1ThR/8tArnSxkd9rzPNO6N0dCe2ND8KCDfWETQNQw/Yt8rHTcnJ5EMYFREW7jVKe98HLNIwe2fj1TE+tGW1Qjs/5RxVfyT9MEP2YJL2dTgNYJ4EnFKdgMRmylp9jG7npch/h1WBuOgMAqLvcDd8Id5lN8YTY0mr2lVXASS1XToZjWrgbXgFthgXWMGKggGziefetVaa5zC8gYG2RyXMvaEmVBBXzNHuBDAM6J8PcE24Li98y/+eBBPjVbEa3uKAHMn4sRYaviWBmLskCCRswvkfBW7h1TVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update write() checks to properly detect and handle partial writes.

Previously, partial writes (ret > 0 && ret != len) would return
-errno, but write() does not set errno in this case. This could
result in returning 0 and incorrectly signaling success.

Fix this by:
  - returning -errno only on actual failures (ret < 0)
  - returning -EIO when a partial write is detected

This ensures partial writes are treated as errors and prevents
false success reporting in tests.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Changes in v2:
- Fix incorrect use of -errno on partial writes
- Return -EIO when write() completes partially
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 9a8c852acd68..c80254cda926 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -507,9 +507,13 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	ret = write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan));
-	if (ret < 0 || ret != strlen(pages_to_scan))
+	ssize_t len = strlen(pages_to_scan);
+
+	ret = write(pages_to_scan_fd, pages_to_scan, len);
+	if (ret < 0)
 		return -errno;
+	if (ret != len)
+		return -EIO;
 
 	ret = write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms));
 	if (ret < 0 || ret != strlen(sleep_ms))
@@ -531,8 +535,10 @@ static int stop_ksmd_and_restore_frequency(void)
 		return -errno;
 
 	ret = write(pages_to_scan_fd, "100", 3);
-	if (ret < 0 || ret != 3)
+	if (ret < 0)
 		return -errno;
+	if (ret != 3)
+		return -EIO;
 
 	ret = write(sleep_millisecs_fd, "20", 2);
 	if (ret < 0 || ret != 2)
-- 
2.54.0


