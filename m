Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DD4FC72D4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 18:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB35D6B0088; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63E76B0089; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0886B008A; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0296B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:47:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57ACEC2BD0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:11 +0000 (UTC)
X-FDA: 84574581462.29.1D07729
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0079B4000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=l8pYAPpZ;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774205229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05a6CfwNgkeRFd6GC3+9/VEwzrQUx3NsZy711o2AxTU=;
	b=RnCbjlz7th2nr2Iulnl+iG1QY1xV6Wa/Ec/Iu/tvuSyS79R9LuoY74tcqa0NLx0qk1hJRS
	3eNH4A658ftTLxhzW/jlo+j+Yu7yU/FA/Aq4pl3BTHlU/8aVGpzuVURnPFxoIGbjePAP+I
	HsWSOQjS2TdVD8QJqk17KmqNaYWQRdk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=l8pYAPpZ;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774205229; a=rsa-sha256;
	cv=pass;
	b=reeSlM2BKGY9iiYQzdAMXY0YQndC8uNy9kDyyCYdJUqM0CHDadq0l6Tmhed6FMNUpk0c6E
	m+5ChxsOvx0oB/vkmf6Zcz6VFDz97MlsyKunRLwldEnLIPpsxxwo6xO9nS2d4ZkBFrSVUN
	KOeDN2/hgFA9ph0uDG6FYWA9kve6fwc=
ARC-Seal: i=1; a=rsa-sha256; t=1774205206; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Zzg2qELQVF3tfbkI0jcLJC3JWMCMtcernSKxBrdjto4K7Yg4WRfokio6Ac69aoKIlRxZOBeEGHVTs8CUZz/XOlLCHBGKk71+G4LOqgWgSi86LS8VGEg+puyCjO2kAIVledLxM97n4kUiIw9ByYpB3XJKdPGPjOt6QLQI5Edl3nw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774205206; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=05a6CfwNgkeRFd6GC3+9/VEwzrQUx3NsZy711o2AxTU=; 
	b=FmwsXgy/tGA1atYBBow9L+u7K+btTqA6f6EOL0MovVJTnoXuTAy1727/useKcsWtDbSFQArKfmt6IaBS1Zu8pypOTnMjAssJeMho8vSJ+w7YDvJmnqmEzvQZe1K67yT0Y+iMtS3FZweCZLCJlxKr1kfKQAIdvB7jDPywNamm6u8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774205206;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=05a6CfwNgkeRFd6GC3+9/VEwzrQUx3NsZy711o2AxTU=;
	b=l8pYAPpZo2Kcy+acCpggJdzpcEbMTQCfAJKyF+uCcZ7XdONfJUSGyNon2hJpk7zi
	bpw+ckxFeu4fIHtH1mXn/7ip6ZeJKjHODk/n/LN9FRP9p4xL6TVDWrdgJnr1kkEW0j5
	PzPQBQUUAP7e25C0MvLAU74AV9552/N9XCzjGUu4=
Received: by mx.zoho.eu with SMTPS id 1774205204010549.1240841832505;
	Sun, 22 Mar 2026 19:46:44 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Sun, 22 Mar 2026 18:46:41 +0000
Message-Id: <20260322184641.251966-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322184641.251966-1-objecting@objecting.org>
References: <20260322184641.251966-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: 86pk7qtozggdma9a79m1gouf6rpkx1nx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0079B4000A
X-HE-Tag: 1774205228-638288
X-HE-Meta: U2FsdGVkX1+2pbkfH3qiFjg6Zvr8/RceQeJIlw3iNyVRGeBJCHK4DnbsBmhaLLYjcGVYBDH/USK2JqGuNnzIeFyxW86sIRySMmnyQuv5DrDd2nv7EwYeJHWjU0YntqN9B8FXXsSCAG2MA6CS+4x4k7LV1rRZagbmrCptUhR1e9Slq5ew9kuePImWhqTJbE2IS6/Cc+rmZ2m+DMJenVKu7mBa+/arlWuMoNjxLbP0YrcTClJpErK/HUfReKz7aXuUFDt7h1Z0RE88bE8XooxteV9HQKI/vfZg309FYwnEn21mCzDmRZzJyqr7IZ7sgyZWYmV0jh197VZWaMZXgVuzeLSlcGfYUDBQ61v8Hmms0LsVC+zP6i1LQeRbUJxNCQsU4hGZiV4hXKei8irfE/J96VaY2Ri0M+bSvd5PJXUMEW+J1PrfD1nsa14tSj5nciPtEzO1x8IEqvV7rZzBjjUWO45xT622fAFibEhIKFvE5m2tm+jAwnFePbzxQ/czYtwkQJZEIQM94sbt97p6OE4zog9gWhIxc3cNmDzDBkfPs7iWkyBlfLMGPQs8roL38VtAns1g4ai4j1qRYouib0oep36Q69rTnWB0xeuEv+0V5jpI+/rISU7SlwojHEAToMCUC+XFCA/ayOa3nDfn7aHA0b5fyRWEb5hK6cTiRXw1xllVo7w9Km6s+Vy4t/bYBpvp3c3yJfv+vBSGB3Xa9J5igoYAeQgaQs7fk1EJ0r3HqSqDgCrMHYPdfHjWIwcRQ7XA1KmuLbxmp34CWzVKPrNWPZW4WwLE7HVHVM8lW8nNRtIC70y3eC/auk5bgIfIkAXapsn7FJ0GLeb6eCrCB4Yyvw5DoGpFB6IjbDrL95tB6QQt2E0SRLponQjdxijdjDrFCNZ1MO9miXOhDMjJyqE3iU3MFt+hd/wHVdMMazhRolYLno27WyThwQHOVEwvrqJRu5e8/IVeLmCo0cbtaPR
 tGS/X+YA
 VaEojPCWjgNf5DFujMkmr0EtGP+w4nIXBvRX6BOJ+0OAS0H1Tfd7F03a6j3uyhbJKc44FONZEHFSzSvQkkCNCDIjSl9GwxfMJXSZIwzbrNothDGvS1hEegM7enzLl1zSlABKct+7twhCZRYnle9WAgdNvjdfkQ2ZCi8wfGNGvcJYG1gET4mXui7aBdpNgmGeZ8LPTPiBXlpc8Z+51LJHpsJ6Dh6+PcubvBLGU13UgmkBRVS2lPl7pnF+V2WgVsFJjA9Uua2LcyQDKCyRs8BmqGtmx7/S7Gm1lBfZ2teyl/ebb0m/WKFOGQKUdaRoY3abgIP8JiVdIK3QrMkCkEdZYJLOAfWfmshHNiIlkKe+/oKavGAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware integer division is slow. The function damon_max_nr_accesses(),
which is called very frequently (e.g., once per region per sample
interval inside damon_update_region_access_rate), performs an integer
division: attrs->aggr_interval / attrs->sample_interval.

However, the struct damon_attrs already caches this exact ratio in the
internal field aggr_samples (since earlier commits). We can eliminate
the hardware division in the hot path by simply returning aggr_samples.

This significantly reduces the CPU cycle overhead of updating the access
rates for thousands of regions.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 include/linux/damon.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6bd71546f7b2..fffdb08326a2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
 	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
-			(unsigned long)UINT_MAX);
+	return min(attrs->aggr_samples, (unsigned long)UINT_MAX);
 }
 
 
-- 
2.34.1


