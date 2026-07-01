Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80CE7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BA46B00BC; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E800B6B00BD; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D474A6B00BE; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC9C36B00BC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CD9A1C5F4E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:29 +0000 (UTC)
X-FDA: 84940488738.05.DA9CD57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A13E020002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cp8rKNoV;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917307;
	b=7t64UbMiEPdj7KaTfInh4htwqXwpQsGBD0DIYKNlSc6Hb1Co5yENKFP40R1EU0/BgvnHdi
	Uh9vuIdGdwIr3M0ANmXGn6593CFAVo6nFlIu0LKCGCdyxNlYmjWLWpD+ujKtL72vX8oh9X
	VQqTgRiTdZGOvbcBliDog26d/NSnTkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	b=q+2foAnOjVwEas7pzbRI9tWK8gey1T+3FCVTRkFBJvlz1HiaWYxUUDEs2UOkwBqR0h2A4/
	d8cbd1Z2oxpL++6C6Kxjv7hWDsEZVDUzcv3rQi4MfOwdL6XMvcAmNLtwj8wlRqNbQwgGUq
	5R9OOTsC6OGwR8ZEzRUGxAHYnWp82cQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cp8rKNoV;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E017143C28;
	Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC331F000E9;
	Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917306;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cp8rKNoVLgzjt340u4lmpATVkCwZN2UhzASudaj52K9utOO2nv5jHMrqs8uZTVllq
	 IeR9klHMHZKB2wBBS4P+l59hUYEvVjrX0gcOQ4REol0ZdRVr0GC+BVoiJQpCkaLN+P
	 ZvDoBqZdwzX+b4+EB0IxpE0EeqG4HgKzbGEaxE4APquvNZ3rcad/CJkjFeV7kQvjj9
	 22O5aA2CV/QyIV5psd8e7Go+71SKwGdzgvkKvL0zU+OfTlkckZsExap3wJ/aAFwosk
	 2z2Wtj07HZMRZmW/PVIR2LaPaVyylHBpglxIV6wWCJ4u9Y+K6F0sA1gB9ygE76qG5+
	 gZCxdmC8/avlw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/8] mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check
Date: Wed,  1 Jul 2026 07:48:07 -0700
Message-ID: <20260701144815.113325-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A13E020002
X-Stat-Signature: 3rmpkhtqzqk1a5grp8x3p5aqkq8nwrk3
X-HE-Tag: 1782917307-919893
X-HE-Meta: U2FsdGVkX1/8/8KvBHLVdeOn3VSXWt2n/RSX3b+TqDaOM/Ryrgo7xtr/DU/dHhjy+39touL1io67xMCUjtPRBh5MzT+vkLspxM93DmdGDRkdDlzyp2wxbHlLkzV9kJgPhw4/CWJH38hfbA/tNsRjAwg7I3A839eEsrnX3iwb4VuYOu5WM5ZZgdIegZcfxAi9JhLCMNOUkVnMSyahlJ5b38JETkuO+0b6MiDB5A2vjaMY53M4+6rLoB8W5h8AzqZFLxyLx0QV6eJc+b89+Kk7DIPHZqyTe4JZX4V+bYCeFvTeDkU3vLUTbgC4kdjVGPYT367VDjm68Wu27TuWmgcIKuF1okuR8jNLwWFZHpUYyuwdWAbtdnEvuwBLP/6ivBZZXpFPcdFPMLsoMo/abOvJQKpmrcysoeUtpjrG0i37vpiAWqi8DrtWER6RKJW1OQ4klxKm2vwyGapGAtgI6q5CZYt2PXRKcyuQ+mU0uQeKTLVRRMgubHDdrcPb1qDdURd0PuFBuGTnOuMJpI5gGXtlLWpZtBZpksIrcL9/ZHMy2zxZLlcXfI2SDZYAdUE4GpC5bjUSLlrWZP2ITuAYzMrci4wVnYSAnYVD9JKeoN18ReBgD7VzkeLNoU833Q2YEUcseWjVzvd6PagKd1/IZ30ySuMyhNqKVxACkSMvPA/lv9dAMY3d6uuEGoRFYoo1PC3KoVq8aGTGzK6ZnIm1C+2rYcld0ayOM6V8QFu3aQPiJGZNh7Si7WV/xyadLIPotFdMMwEiLNXy0dSzdBCmpyeXlDmBH/QnLPE9HgXbwIVPWOSJUHHn0+aci/+/uKS5mrlc4r1iAR5OWIth/7qi6YqUimD9lnWEpYZyWiOFCxsZi0KetIUKX1Rf1sAmbOMAdmOL4uE7f1fhU7+ExBXDU0SOJ7U6IDthIjvQou7Fv3Ro36TC9pFU+Nc6qFZIbEnosPJAHG58R5zIxHgriXs4OpK
 1YQWRZIp
 urr0Q6z0OdZq+5/lcLNnq/1tvrLRLYgDuBhKXXduiNxWEEDxyApgrprWZZWYZSls28tEZUObK3WV3Bv9jL8C8GEUYKHHMIwvyrr25DrDvb1By8b9tni2pqd/kCjF/epI+6/OqokLTLfNMbp61uPl/x1MgVe1xsDWxNUyAqjIca9d96vJ/4bUR+h0gUUrmcC9OlR6mMlud+WcyZvojKKPbSiVTeR5VxNSGAmwBZ1YaFafBlDEWWR+Zkso1PLvfe9FJke+08iCu1VkcNXScjq+k8zRYQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the unnecessary duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 32f41491b726b..2dd0cd0d26273 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -284,11 +284,6 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

