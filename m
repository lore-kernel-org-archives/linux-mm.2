Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EC9FF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE83D6B008C; Tue, 31 Mar 2026 03:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98F06B0095; Tue, 31 Mar 2026 03:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987976B0096; Tue, 31 Mar 2026 03:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88C4C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:07:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51034140BA7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:07:44 +0000 (UTC)
X-FDA: 84605478048.07.3F2780B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DA891C0012
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:07:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HKCiRwbn;
	spf=pass (imf18.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774940862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tsUJVn3ygh2X89/8L4QVHn+2OjoHvM8S7xE4MbPVods=;
	b=CP/8sTi2aeg7qODkG58W0xBQuHazSeRVOcxNVWaqccjsWtohZd86YSY2oVuSc8/iAqvgev
	XHKHvgjkampnTyiteySaypOmQlzjppmGS++ZygmUOaNBN28YW4P6WS4xiBiaVLhaUlys6I
	EAHhaOd5hCR9TwIFbhJ0fVbftv26HJU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HKCiRwbn;
	spf=pass (imf18.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774940862; a=rsa-sha256;
	cv=none;
	b=TtEK1NWuuM86q0NQGifUQeqO7WLdkw9QC7RLQBGi2gwxG5wuqw8AnI4samAnjHh0w72uJ+
	FtDEb/d1xIwJsn37q4vxJej2eAmncGSAgzFCynwUJAyTILB1qqWV/ID/HDuxYrj0v0HR0h
	WhssrYzMurPSwUsYt5H25FcKIo+s/k0=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cf3ee0fc1so1623293f8f.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774940861; x=1775545661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=tsUJVn3ygh2X89/8L4QVHn+2OjoHvM8S7xE4MbPVods=;
        b=HKCiRwbn/lzYAQ4CQKUCtajmAN7d2G0s8Ex7/w/UJPyJINK2Tunv7O8VUWTY2wYGG8
         ZJsgf7v5KBcNmP50Zj7bupzc1Q7ekAl+nbgKS1m/iCDw4OoSFadQ2HWiRlM0lnwyWgXs
         2LnkijjjBqbvl/7xwUu1cvbaY9qUO+T694Cwv95coXGrVcc7RGX6P1L8u6cPgCly+X3G
         6AMJfL0Do6wx7smp5Nh8u6JRn6Nb54DKvyvs4BfGHq+xcKVJXZRO2YxngTblUq6UR21D
         8ZsXPgfx3lC4D1HVo221G51dabPHTm0jA3FMysUa3RirzLcL+IuisZLLGbPNUzcWNslD
         P/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774940861; x=1775545661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsUJVn3ygh2X89/8L4QVHn+2OjoHvM8S7xE4MbPVods=;
        b=FnY4qNolaT2zNTURBwWz3nZ17D++sMCJomlngyqK4yy7CLc1/7XGMlmJorB8JOFX4D
         wKwMz2+nOs0J/wxZBKmkWgM3AYPChTwaAmG8AvtVVfYsuRlhL3GgCYRrnnSwSrHwJdEW
         hysEuujpI5gw1bnKOtDhX76gHvGkeI7v6p1Wd4ZCJBld7vUULIt7Jir1BfeJo0D5y2f5
         DOF+1j80tUlv1o/xr0YseWH91l8l+tTUVmshhs/W0jiEu8tNnUDpazOjVarvt40J4vUE
         yMWfU+s9UcbQDyQ9A0CQ2p+dETLsslTfzdRNR1fC2pfM0Uctb8exCmPluRrUdIwFmXyF
         mEnw==
X-Forwarded-Encrypted: i=1; AJvYcCXmex+Ye9B5P8E5rza2ooFgfglJHX3v4w+B+a69G2CAeLirV6oWbn8hsEHWEgyb/PhnmyNFaBYMqw==@kvack.org
X-Gm-Message-State: AOJu0YwBNpKDXVTwD8aLaT4bbSzO+qp7R/AxhXrw6MQTz3t7QpWxO24u
	zQ2jeLTTOieIvfNmzQJ3TbL1JD4EKqBvDz57fmwvrfUFZNjvrDFifXzX4CnTrpgeHrY=
X-Gm-Gg: ATEYQzxToO9vBEb9IL+PYKg4aMRhf6V0FmySIIfGv96iLixRRPNaZERwmBIYI8nTxmy
	z2Jp2SUwlvqMVrUYDgNSgSowfpjEk9TmkSgcpVF6Zs1V7DZqUJT2DEBhm4aFnAQ9dVwewC9hGYR
	QZzB2uSGahb8+ayVTtE0pxqHIJYFufuRESmpYK1YbKXbH4pYt35f/lPdjEF0UpnWDvKBifkDJJM
	HrTQqFbgssY2E0UrkAtLVCPa8jUmpIa4kH8wejifw7jThn9XXkqGtBrFe3IAl191HoFYh4FTVe1
	xj4bkHoDXR7TGiKcGp1c0WlsxhG7dNHW52tCqSbsDW1M4OE+eXxBjos7mA2FROrbED2LAZv2hsR
	zTCzYxsv69nl8HVjM+agC3CFsCsv1ppkflUL+D6l0wHJeqNKxs7ytMxQXe3tcsPcr9izPx4P4+W
	nRAPKzIJlN53qxUT5b/nTPWJbtECo/kA==
X-Received: by 2002:adf:fccf:0:b0:43b:9f7e:c912 with SMTP id ffacd0b85a97d-43d0818f375mr3130844f8f.1.1774940860709;
        Tue, 31 Mar 2026 00:07:40 -0700 (PDT)
Received: from nixos-office ([2001:8a0:e95c:5e00:f8c1:fa51:743d:7994])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf21e265fsm25801409f8f.1.2026.03.31.00.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:07:40 -0700 (PDT)
From: Julian Braha <julianbraha@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	hannes@cmpxchg.org
Cc: mhocko@suse.com,
	surenb@google.com,
	rppt@kernel.org,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Julian Braha <julianbraha@gmail.com>
Subject: [PATCH] mm/thp: dead code cleanup in Kconfig
Date: Tue, 31 Mar 2026 08:07:30 +0100
Message-ID: <20260331070730.33915-1-julianbraha@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DA891C0012
X-Stat-Signature: nbxo7esfbfe9a4kme7jss97myw347yzt
X-Rspamd-Server: rspam06
X-HE-Tag: 1774940862-458322
X-HE-Meta: U2FsdGVkX1/5Nc54euTHv2Ob/M50uVxS24gOcfxXNdENK+RPhHra7CjE5GTNbTWLmCYlooR4xwVWDlCM42rqooTRnbFKYPwqbXisGKv6qiBNg3vYLWpdQ2t9HZ9SgUa2aRbQObgbr9v+v0Pjzz3JyfVrGdrY3RiiO46La1y7fYVqoGR58ehycfJONN2U3kkpbGEvUJ0ZnM6GWEPUHoUZqukkE17iHU5aqZ+AAP8rm2yE1BzHfEsxOUzIi56PMefUBVjgEvLa6x18VTWjqhMFxxOhb4EYxthWfyEu+RREKE4T3/9txbnW+BXBaT8gkfuCDEHC011OlXdfj14yuEwVUvLU42BQJB/d9Qf5iGIf8+3Yzfp+W7Io5ao9W8Homj/qmqbFOAegB5eDCV4eaOCNnMxqCseX+rlBXc36L0C2c1LSqRyWcIu+OglyPi5LWX1+6G+NwNtUFqB8O/iIZbqva/hEzVHIjopry9T7pL53Q/4h+AohhwwWI0cMILZ2gG+0MQOVmW/SHISS8cr9ZvbT23fg2RQdKO+3vy29p+9TI/ojyRrI1RHpDkTEI7zg4Qi/iNx7qVUWxq6BbMVC2zglCiq9dCP3cVGMoYkv4Rg5IQFjM6xgaSFs29JIcwrvy6Zph0pJshq/u6xvrYaAs7NIkXGPMViR7sJl4I5Ey/ddFBTAG0BM9Sx2ZRGn+Odg1tCw6OaNMGEKJ0FQ+MUMSxd1JncT2oAyMFQ+BWRYkbJAjrbulMpVa2wz5x1Z33Q0kzTd323iZ13DWDxQT4RA1gzi/pW0loYgGmJIfOgCYZiDNIK1hcJ6/Kx+y9Y7+W1hCxEI1A8U/wcuw1RzAF2ziSoC398mDKjUb3ACvhzg8O/VRlKLCT8J5w1Od+Oo1icMqbbijLIEvXpJJcLYpTVa1PLg+lNJV2vVZ1e/gj2bcKzbnbSvfHHBLdMTeosyKdwCSlIXt7cHYnlH9Lyt48b546T
 V0Zdxadl
 GFzysLa/in0TGItOhX9RJ6ssJ24bE0rcq7I6SeNPhmqTW03QsR1HfL1zNIUS6TyEzeH3ftKmMbTWraiIGWNRqHzi6yJ9KCKQ5rH2LrGHtJgOHFgn7FXogVh/20B96gVf5+F9hMHnt/5cRy3A1D2gAIummE7M4bx8bGon+eQM4L213wGJvbs51R+k5iRMK/pjqQNpyd8qQglamEumaAG/FV1rZJG6mAMU5vsZoXWAo7MBQCNSUl/QEr2c1TBsWVn11FNV/NpGlPUj0z1Se2esnaNoF9aiDGbXYF0/Qc0kTAWpeH3E2Iu2/PkZGJQy3TyXlc5jIedHKBN57swcD3aYNgA1cMcegb3su9FYQkM/kmPtrS0TeDjfqYeEqH+KaOhtfUjUtVl7wJ2QnTgyDiSWpwyTTkkH/TDOheTaHyIfWhGHLCnpd8lAO3hWo9RAGxqZaNd+Wylkho+BE30RPB1pVlXjmbgTsyLErp41O4yU4tuYE/Ya0d0cEXVT2ZF8gBnx3utf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
config options e.g. 'READ_ONLY_THP_FOR_FS', making
the 'depends on' statement for each of these a duplicate dependency
(dead code).

I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
option.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
---
 mm/Kconfig | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..29d2de0d5c06 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -810,7 +810,6 @@ if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "Transparent Hugepage Support sysfs defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_ALWAYS
 	help
 	  Selects the sysfs defaults for Transparent Hugepage Support.
@@ -840,7 +839,6 @@ endchoice
 
 choice
 	prompt "Shmem hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -886,7 +884,6 @@ endchoice
 
 choice
 	prompt "Tmpfs hugepage allocation defaults"
-	depends on TRANSPARENT_HUGEPAGE
 	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
 	help
 	  Selects the hugepage allocation policy defaults for
@@ -931,7 +928,7 @@ endchoice
 
 config THP_SWAP
 	def_bool y
-	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
+	depends on ARCH_WANTS_THP_SWAP && SWAP && 64BIT
 	help
 	  Swap transparent huge pages in one piece, without splitting.
 	  XXX: For now, swap cluster backing transparent huge page
@@ -941,7 +938,6 @@ config THP_SWAP
 
 config READ_ONLY_THP_FOR_FS
 	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
 
 	help
 	  Allow khugepaged to put read-only file-backed pages in THP.
-- 
2.51.2


