Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0522C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638806B00A0; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610366B00A3; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552DA6B00A0; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2916F6B00A0
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2B461404B9
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
X-FDA: 84930693456.28.3A9AFE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 07DDE140003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7snI7ds;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684087;
	b=xM2vZRM8p8hzhtINJq2QUi3ANIxevZE2FlcsPV4WH/1G6WEMk4QR3fTeb899DQT6B8Evtn
	mzeT02vrn6CtfGZrK/LKB4TFYLuXi3RfipOJQIZdOcItPl6R1QmVemoOhjNUkdpEEuUkDz
	lSk/Z4ywzBhUR/Yu4NygaTXi7S2PgUY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXkhSNQJNDKDyNoOpZwIsSL2pL1PP1RKf/KNfR1efPU=;
	b=xcTdqEe5AEzecYptR0dlOrWZkV1Rhj0mRw+Gff35quIKFQuZX/GLH81uXmB4BtV4JT2Z9f
	KNJab7bGGSzlQj1csLwSIBQGCn+S6FkuIvtYVeMF3W1FKwIJVMNAQc0j6NQvZzjoOeZ8rf
	NsLgNy7hP98ElNEDbNsT+tN+L/09c38=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7snI7ds;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95C916001D;
	Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9C31F00A3E;
	Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684086;
	bh=NXkhSNQJNDKDyNoOpZwIsSL2pL1PP1RKf/KNfR1efPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7snI7dsYQUBKz+sEXAwEJ0jGoB9h7VmSZbnukrtFhNlKgg15CBOgF4ez3l7Yz1zZ
	 UhN6WecoYgfpASxnzeLpWiE0xxUi2Xtzu+qd8iNdgnbe4o0GvWz23YEU4USNP+uyb4
	 dLdMpwRVQUFQhu8qVbN4Zwp4Lo2nkfOo8DQikfnNwcZAH/U+cfiQq+Zw4V3g1QZfkj
	 QvDnc6khpqr0OygI0Pjlr/sOB9zPGiwuhXI/honAzHMywIJyoofAafC1Ud+qf1PiVA
	 tBf/BzCaWvCTsTDlNQ9wQyt5zMyczTsXLhkjl5bLV4B7RLUK+ZStT5ohRolTSRJYSn
	 cBz4JzhrUw6IQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/11] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Sun, 28 Jun 2026 15:01:12 -0700
Message-ID: <20260628220121.97360-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07DDE140003
X-Rspam-User: 
X-Stat-Signature: 86rurszob3e4s4k1btz813ksrx38iw89
X-HE-Tag: 1782684086-389474
X-HE-Meta: U2FsdGVkX1+W35E31gKhjH6rG1VQP5zRCs1dxynOk4SBNdNFvEWSuLqqsfWBHdr1oDyEM5MjQUlBkYtq+8SIwBqiRXl/1Tienvo541oybLL5K+mZe0HbfcM9wstqRhzKiT+J3LScB6u9SjnbQrDsT6sRC+7DaP8AOf1MNmmP3h4vaHnKDD9lRczJDoWdpoSrbk8BkYvrmBZZbow+/RPyiJ6ybwYl29tfjxhzCU4u6o34xUubxNg3mRRnsv7w3r3RZgQowh8gJWrUadqMxMIBDXE3ld7qVnghL6+6QY+ZBZMeKtE9g3L3FrN8aQxjI0THEEHPWpMZcCTPORbCngHXeA20ETf0rn4VY/v4r/o3P/cdw9jbcgjzkSZ+bUoaBKS81mdec+PD6CA8RyBFkrtqzT6JJRT/Hd7/Ol3FCzpnWmoPVXJ4FLDvDaTiqcDgfinEm2YSr7upwaAfnTbUxjEOEYFLwx7laaw6/5e0fdrSqmrVDIjhz11knVwegGL3/biPmOUFRGw+ZzsYnU7Rtxiq7PULA3JOccXLR/YQh/cMvcqZwKMN3fmEspGkpBO/jjcUMEEUIPeVHLtdQkxmiKHj9qoyWOByg5jYcTxCdWTTTJXikNqY+K/PHfiFEKJKwkOZBNwDW3lrDlUMlRwHqn2zpz/TzGe7KkZlWukoyAXt5gaYW0ju/tcA6i378l3yQsHO0w+YeShu+XtRjRrnJCHFp1bSSTvRFds/HSr74OKqDi3sEKOsVTiDllwasJI9okWC5sN9NWQuUe7CttL8Se7/8BaW8cBdLeexnpOhSRC3sPCYc6kd8ZzasUZKlbK35CFdQE5l1KxGq3z56f6Z9GeWxhJ/foQoGZ4Ee7RKOZaP4oymA6VJSsW/aLSpnM8c+yfJGEO4v82WrXQ18D8rvclBiP8OOzUI0LGNiynjYOfaxxHVYeaQbbVn60sKehqnfX9ohkMJhcocYISiM4kzWPn
 6HIpIJNm
 hQzqhntSF6GGuPEiG6T/Df9HNDMVJVnWf3ARWj93CZaPFMaaRZiNIgtvPQf9ZrAPhFRFUs+mUs7Ex39eLJsDOUBG+latqoMnFWKcqKX784ScYanUc7Mc7wBmK+OLJYwa/RgoYRvjMd1jHi2k1pYNGJch1EQb5EoACtoFrUgrN0t+Dn2ghXmVr/juYrvqCtgnibQVdRC6YOxJoqhxQNFic4JlPls2WobNR7cuVqaiu8xWcdtc9EFg/Jq82k4XoDCBGTK973uY21e2ooMHkSsObXz0h3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme directories by adding kobject_del() calls.

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3cbeccd436e40..db496d2e493a4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2681,6 +2681,7 @@ void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes)
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -2722,13 +2723,15 @@ static int damon_sysfs_schemes_add_dirs(struct damon_sysfs_schemes *schemes,
 			goto out;
 		err = damon_sysfs_scheme_add_dirs(scheme);
 		if (err)
-			goto out;
+			goto del_out;
 
 		schemes_arr[i] = scheme;
 		schemes->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&scheme->kobj);
 out:
 	damon_sysfs_schemes_rm_dirs(schemes);
 	kobject_put(&scheme->kobj);
-- 
2.47.3

