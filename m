Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2594FCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444A88E0008; Fri,  3 Oct 2025 16:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7078E000A; Fri,  3 Oct 2025 16:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9588E0008; Fri,  3 Oct 2025 16:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9C6C8E0008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:38:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B283EBC1DA
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:57 +0000 (UTC)
X-FDA: 83957967114.16.2C78469
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19DFF1C0014
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dVv4/lhP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759523936; a=rsa-sha256;
	cv=none;
	b=YdSg6VaYXONMXaANOU1o4IT4IM9A8DUWSyDi12F4z+eoHy5x3ZTpbI4mgRLial7/l4zdG3
	nHoHdlMisUF3qvbYV9Q+5ge77RsREsDdK4fi6cQxu8CydViUBsBBdRdmz4amoaUuIL32t7
	p92Wdl2F/UJD8cJSCyOo7PjI8SeGohM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dVv4/lhP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759523936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+TO4ULQ7qpToHys1UF8QNqqLylEbH8PsOkTv27WZFc=;
	b=X5WD1SiWt9v9PR3T5zTDg794Y7eFH93uZvz7pypEuH+AwfUsReFJ34PdT+ghqQVLcGzECi
	qh6a3/o1tTlUW7U8WFOvPjK4H588QM1bSlU0RfGog3/zJ7KI6L8Mv9QTOzAgOsQwJYtAmM
	i387wAt1w/ZvvLaUrzGrWsF+9kYxpDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EF4F624CA;
	Fri,  3 Oct 2025 20:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD7FC4CEFA;
	Fri,  3 Oct 2025 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523935;
	bh=QYf5NoN4iCNnsX/4rgyF4h8KGvpOZHNtyc2i/D4d3Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVv4/lhP7CXRVGS6gZXty6SM2CuqqWMtV94l7WDc//YwsLdWRvA9OSEMFefrhAIc8
	 eD+0MkFrUaBHnOFc9MuMxvL1iv/8mtrG8Ant8Og95++U6GIAgmNKogDidifzS0tHlJ
	 Qq3b3jfvhfLTtBfMV94YLQ6Y3hwNn1ZBNk9jjHiFhOwXOWUYPudbac5AyJaX6QC+4g
	 tY9+XyBWcrd7FuttcbI76cyHxqzDkf1l8ZwzoyXp/dM0VPZutwFpp0yKW33ddZzQhP
	 EH/lKPXUi64pNrLFlO9IYbWvxwLUsAkbVfTSleDoDk04Cwd7/XjIobzm7g7poJJcIa
	 DEmVG9WD9KLeA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/zswap: remove unnecessary dlen writes for incompressible pages
Date: Fri,  3 Oct 2025 13:38:48 -0700
Message-Id: <20251003203851.43128-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003203851.43128-1-sj@kernel.org>
References: <20251003203851.43128-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19DFF1C0014
X-Stat-Signature: famsaaup548gfshksmcoq78ze6krhf31
X-Rspam-User: 
X-HE-Tag: 1759523935-11822
X-HE-Meta: U2FsdGVkX19ehje6bhCOGu9Tncq+paamxf8hgM5edkmsW2hm4zxKiz/JANEai6IJ3hYnxng/6yy8pPa5atTrB88V2jM9ieWzqSVjyOzeHHf9LY6NwmzEvBJvvkIkX7ZJccOta5QzIxZ7sEIPXEtpT4jywg5e2PYs1La8YIXAtxJmQ6ccVRmtDwXH9yeCD84i3/YMPAV2NidcT9jk7C1sYDp9KLytanjrvcALRYDKeB3kQ3v87mCkQGbhVfUxzCPLzWmIyKCxrPO3tE7ZF9qmbWjYukRMmv+b7SdHQKHsTBzGtbcNBWof2fHSOhkmGzE1jHtZFi7aMvTf8DWF+MLcixu2IM2W82Jzqzj11E5S4iZgPSLzR+D3WMWm6eagwnfv6EV0dY/1AH1FDA/Lw3I4Fh4UTgkyIsYmuexfjIicz08RUXS25R9u163e9TPR+OrkGNvFwsVYfkKKBE5HhlCGpYwzZXWw5r+MbW45runMZkt5wiW8DvON04959ixhp5hCNyerlZ0ImYMIg5YJvj7VaKCYHlL11dgBEfG69TfQroCEY4GoYgaSS98ge0FXI6+XYLUCyJ7dYtXuGySX35nUgJSXV/X2oGRbZ0N25QPLNQe2yV/PHPNtLmDuXgXcJ7VPVlzm8jqzWrL3Xv67OnGxcGrvzGCyxmwScunViYuk8sHKQzeRvU1Wz46obNXXEmXMujASYjf8tGSZX9qv8IYYTha3Y8QXDm+HqVN9wsfWKiGCd8KfJR45I9GFtuufQd1ZJct/KYgdet0uzqCyI2tu2CU9B7XFtCVdDlIsU5bLeHAPRHYIkVIcPpSkpysznLnGYPg5+xRmjwVLNkerGVQFqgp+1dcxlRKDJbw2+SawkPDCeytBPRpr/suIEOryDfGQ8wPk00Zfet3e4c+4Ca8Mt9mPsOm4fntDz6Q4YZ+nsI5CnAYUNQvG0yOE9dCurR6XX+fDPWBzezSeOflbqkV
 b6RFKEpN
 BwQe9mm0xfYRXchmCznWgs6qtH1lnkWC667IXajhUWo0FD/9sV1XuS4h6UasKROoNd6lcgJdNC4/rBj4E25g9JQpKjWFAQkQcAC4zFTCIr1qD7fdhYIv/qaOdrhvD6+ZL+kztFDLNpQBPq8YgBG+rfxn6kbXNvsFQI2O5U5/9l40Jy/5TD7uYVqgmnkn1hZIRtUAyHq881148kn9T8Ic2w4RAPqfdyuM3JOEFTdlUqkROTEPh29jLLjdashVevrsKyNkvALghcZ5kZfw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Incompressible pages handling logic in zswap_compress() is setting
'dlen' as PAGE_SIZE twice.  Once before deciding whether to save the
content as is, and once again after it is decided to save it as is.
But the value of 'dlen' is used only if it is decided to save the
content as is, so the first write is unnecessary.  It is not causing
real user issues, but making code confusing to read.  Remove the
unnecessary write operation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/zswap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..80619c8589a7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -894,7 +894,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		dlen = PAGE_SIZE;
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
-- 
2.39.5

