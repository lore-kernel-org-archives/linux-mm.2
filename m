Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D20C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803F06B0487; Thu, 13 Aug 2026 06:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4E76B0488; Thu, 13 Aug 2026 06:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F36C6B0489; Thu, 13 Aug 2026 06:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53B906B0487
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0ADA12052B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:16 +0000 (UTC)
X-FDA: 85095924312.16.ECD94EA
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07FDD140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/e4h/3rvCBbmscUgcSn52QJPcRR7b7iCPsseh39tcc=;
	b=2l9IO/LfcMEyEVVZtN+bhWLGC615dqDA5VeivcaA/X3ck49aw1t9ji9VGITkc6XQ2OIbVk
	u4VyMb3LwSaTikZUs+/mL1vQ0+2DJ9KGYqCFK89KfnawEemSbTuCHd4foxe3vOhq/omlyY
	wyABPPVnne/6+SkkXhlIoFAY2Ww3N38=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618155;
	b=N3+hrYnka/vVONJA3Yx36OkXG82svwKAjTWOVALHdoIoKrTV/L/gADt7G3XSP4P+cdLGKZ
	iar52KeZ45gZJP21SzA4NvcfGZHNx5sMIW1SJNlRX3tN29Fw1Gz3elofmh7xLLUsl38VjZ
	jLeA+X7Hrmsv6zuBmFQmEvro+VMoY9Y=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 1bc26142f10f45c3;
	Thu, 13 Aug 2026 10:49:13 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 01/15] mm: zswap: return -ENOENT when the swap device is gone
Date: Thu, 13 Aug 2026 18:48:40 +0800
Message-ID: <20260813104857.3450386-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07FDD140003
X-Stat-Signature: 9xg1i1dksr6yzb5x3m7jko98f7j51kgq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786618154-703180
X-HE-Meta: U2FsdGVkX187z1ZAuryC6Clek+8+wcs0acnpkHpwTj16Xx2S39vEHrTLIBppEl/uO3pE2n+7C6PDVekZtOsv9GXGYP/N4VtKOYUtfhYFTe4kAv+qtQ3iOEdYQXtc0iRlaQH7jw1UKx6HTxAXr5IdBxg5/C4EQ0jdeeF9iCob+I7/FrDyL8zfh2QkyFzsq2foHs91o6m1SFUhGJZt4rpFGOPQK2GnzBMMzF8Sq6/8/ijQ3fkUDFwtK4BfG+lGTzHWgbctE6S0eV/HJjmgnOkubykPGLpUHB1D+0a9vRbL5Go4ZF+m3B07vXhYnFG79pGIqY5bwFQRbDH5jk+9lBu9FIhP7qErY5FyoLeoqzDq0xNIzsauYs0Qs8F22u1NZ7IWxQbwtBM3bQ7uuCRhwXa3jqZ/f6okBqpZjKZ5rOIurw3rcXexk3enjMFmbBc7r5ZmaRpkImvr8Dij52DW1Ugxo2Vr8V0MGTpwpnOSHioqW8sXSMIvw8tcw6np5LOHhOmI83q/K4vJmUGhfiDy6QVEi6Mu18xiI9GMU40M6DtI/8RpbWZQnMD7Q9V6/gi12bDS0/QSQWT+WHzgwNTlQT8l+lJmpVKbWg7wP11y/6YjscxHsiTqMnI+xQfzUgF7lLfqqiZqza+lDlu7RPS88BY3ctqSm6f/csmXfv/Ffh7izImvJtEnKaKLkiDVmL/4Ry+L/JucIFDTllu1DRY07pEhXFoOdiGuCmiCqseoxOyoByasBuXMIcqML58UYrRRFGKQWqU9G6sQAfZ1KNfrTqVp57KNz6WhdeNR5bFX9Kivz7eMtSYEo7omDAQygRMXGPpfMblPwIL+aLRXmKiBvt5/nK6TgPeBQ0TxUI2DiXg1hYMXjraNJ7T0EorgslHoWvfhhoVVu0JCbkA9cp9VsKYn5i2vOlQfnqdJaFiqifaR6v5eHwLCPwFGtEWqKva3FlyM2fHApTHkorb0eU7NBTF
 XcC/LFj5
 XDIkWn+my2xQs0sbAxwgkMsmuOKN1S4fOdIsBcxCBBY4dYoLJmcuoSD1vTA+DXViOIh/hXi9MpbnF8xkVZB3NmzkK3EQfm6qLdX8fliNtzl8HygSjA30wh+ftGa391K53j3boe/BKCRozE9XvBBvV+g6QLqWGVmIS04J91tFyuroRXuJBpOBpehvK4dwwRbC4+6dnCW1yH/b0QrZoPH6hljw5O5nNyj07H597im/Iy3tmblhtbZjpP7kFJaY69JyaUjEcczCvSSyf/j1bT+ubsECNWgZeLpUhRsdV+/9iVXZgEdgTKEXtN2RkAHtZMhSzmbD8rcFQcIk8lZCFnVlmMRvA6Tp93QFm8IGaC/uAKk3RWZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
Independent of xswap; affects all swap devices.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9f777a48b106..0407a448dd98 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -998,7 +998,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-- 
2.54.0


