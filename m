Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47E3CAC587
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5B26B0008; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6238E0011; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3AE86B000D; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9E576B0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 791BEBB3F6
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:49 +0000 (UTC)
X-FDA: 83871669378.16.C6646F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE3FA4000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0T0Zk4s;
	spf=pass (imf17.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXhSfIzvShdSFWCJaURCqgLBTSs4L9glxC1ZyRrzTGI=;
	b=wOzcQvcHauuSy7HVQO40E3gbAVEgwg38FN6R7+7RU9uG3MB0nVINled89BkwccCQnQrOfX
	JZBG7uZk7+wuUnxu13ZwWBOpVy4spg9TD1f239nrk3Uz/bupvfWbby/pkDmqJPkNmOne/v
	6FKfjLl3QYNIklFBEdC+qzy/ElK+j98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469227; a=rsa-sha256;
	cv=none;
	b=P8N4IsXuz1tp6qOdilcgDtqeq+FU378xylULmlVimf4PVu0f4gBuctpJfjQ6Jc72Jqdi2i
	T+X/FkpCqpj4l98Va02HG6QwMlloZTOdhsz9o9rl2B9qbTuk/dswjPtgxtafBXJ/LThXcD
	PACATWdvGxZLjYlNzKMSpT7byAek6Es=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0T0Zk4s;
	spf=pass (imf17.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA1806023B;
	Wed, 10 Sep 2025 01:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C798C4CEF8;
	Wed, 10 Sep 2025 01:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757469226;
	bh=nKahzqIz83XaT+uPapT7Ju252SMX0ytFHAmEB6DhmoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0T0Zk4sz/7O/k41dYETUNlJtNEETk2nMUh/GJ2GgQMA3Z8B1EgGqXmBcF57A5T3T
	 klxvDQN91r2YMa/9kLm5XwfDsUwPWY4GNSnsRpqGKtomKiwp3PTDaoOvfU8sD/ofN2
	 uyYLlMKPC/AlZAtqy4wtw2x7YImjSZBK+BigGrH2HuqUCBAMshAm0awiuaslQ22TN5
	 4QNdzEQPr39ytgKYtmVWjsRADkatNnfQmsYw35h6Dkj7FgU4J691PlSWfHGrpoeVGe
	 Qpxb2rXSESIP5Qg5rpInEnlngMGov77/288utJddyk/Qf1ICCXlqctTGYQmlE31qSy
	 24CC9whlbNL5w==
From: Trond Myklebust <trondmy@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Anna Schumaker <anna@kernel.org>
Subject: [PATCH v5 1/3] filemap: Add a helper for filesystems implementing dropbehind
Date: Tue,  9 Sep 2025 21:53:42 -0400
Message-ID: <ea24b487cd83da3f69f6f358d2d7a167a1dd7687.1757177140.git.trond.myklebust@hammerspace.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757177140.git.trond.myklebust@hammerspace.com>
References: <cover.1755612705.git.trond.myklebust@hammerspace.com> <cover.1757177140.git.trond.myklebust@hammerspace.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE3FA4000D
X-Stat-Signature: pcpig1g64akf6a3rrh78fk1tj8hiiqjb
X-Rspam-User: 
X-HE-Tag: 1757469227-182959
X-HE-Meta: U2FsdGVkX1/4RvCrj5LzMcRDmpFsiSJX3kif4n5oDRgZNAx+8wLRgCHJtZPWcixmSXhU4ojVoqWIfkWnJi10S0iH/67j96ybfcep7EUbddNYMz67EIiSD/gVO19pNuFphRvR5/lNS4GYKsQbdtHYU+LYezQL7DeYs/jhxIFU9WN1Wyok5jhSqrcmes6aL3KrnqqjGItn+J2Xw/Fo99TUnklwiZG44x+32K+HMf4p4/LJzDwvJXJ9Q595H/vl6bRNaOqkcpN3zcvttu5+b4roFNKqLGEOdZPSox2LSBC8CO+pq4caC1cd29EhfooTwpSRueGwLZrmPyWEJyvf0+5gzPPn3m6ebOZFTHHju0sjnEfc1BQYhb/MKWhajA41aO/W9bzMCJz6n7879fELez2L2q0DzXpyyHc7uD8ZJ6EDRrjIEucLzPjZMkcpKpILQZvLsc81kQl6XSKVZlWTzfMvx2k0QbHxH+Gt0rVouvjx8xl5tan6i+x9ggXJaCK0rGB5APLV4zLVOtYSbGBdEx/jnES7GqYgmUXhnpNxhJypn/rGHRkVYr+GURrsNcRBpDEZtPfXrRmkwQha37HsnLsu5QomFATe/+Q9sTU1EVM2XtZpa7eUX8QULX+lJfopi5e6lDNQizma7s6ITY4J0E88YU8XzgnWtETMS0DLjFP6TtEWNJimGw7M14GnQHWaPwYScB+idZwa5XxuYC4tWH2mCcEDpO9Y+xbknpmWc6yOZ6eG0WzGwugvIQ79nho9W/CoSAflBzZIVPM6wIQbW1tMNnaXTI/5+gBUsr8IPhHJYzs782w373qpRieE+fd23BMAa/SV/azRFlQ4+FcvEHem9+TXbmZ2j+fPkf5rHH73MC4ZDuXKXCKcHjiI4feVCBD2gmYWQBaHRAdcb9NO5XshQvsSdYICdhwdcwJZBNGz7tG5vitDZ1K6L8yaKP4jLqxyOs8q9uaUHj9a4r8Hrwu
 AtLAPvCb
 Xz05tlOpvXS4AkLbU6aA1paU8+QHX5XgzBwrCDXvcVFjWq9nVX4Amikk3dwXN1cSvIYzWACl4ofJU96uVKVuBwIYqnzQR+oaXK2b62sGxzdAwdalJPBQmCRIuk9FYPCO7yi/7yq2zcnoawU5XZYASeuzfqerzEXIr8RJ9yTmTAuiV9wVdqaVWGyM9OIp7nuxZZPQi76sHavcJNQTEX/iAxrVNCW0c3R+iAS7Ju4JMOHST7BUrb1+zenYTTopI6B/gKMxKciuDSO2rXBtuWKzko1So3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

Add a helper to allow filesystems to attempt to free the 'dropbehind'
folio.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/all/5588a06f6d5a2cf6746828e2d36e7ada668b1739.1745381692.git.trond.myklebust@hammerspace.com/
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h | 1 +
 mm/filemap.c            | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 12a12dae727d..201b7c6f6441 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1221,6 +1221,7 @@ void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
+void folio_end_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..66cec689bec4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1608,7 +1608,7 @@ static void filemap_end_dropbehind(struct folio *folio)
  * completes. Do that now. If we fail, it's likely because of a big folio -
  * just reset dropbehind for that case and latter completions should invalidate.
  */
-static void filemap_end_dropbehind_write(struct folio *folio)
+void folio_end_dropbehind(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
 		return;
@@ -1625,6 +1625,7 @@ static void filemap_end_dropbehind_write(struct folio *folio)
 		folio_unlock(folio);
 	}
 }
+EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
 /**
  * folio_end_writeback - End writeback against a folio.
@@ -1660,7 +1661,7 @@ void folio_end_writeback(struct folio *folio)
 	if (__folio_end_writeback(folio))
 		folio_wake_bit(folio, PG_writeback);
 
-	filemap_end_dropbehind_write(folio);
+	folio_end_dropbehind(folio);
 	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
-- 
2.51.0


