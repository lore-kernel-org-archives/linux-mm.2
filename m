Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9695FED9EE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506E16B0088; Tue, 17 Mar 2026 12:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B73C6B008A; Tue, 17 Mar 2026 12:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A73B6B008C; Tue, 17 Mar 2026 12:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABC66B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9ADB140284
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:07 +0000 (UTC)
X-FDA: 84556160094.03.79F3AA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3250D40009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LO80KQZL;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RtejmdJ3DTKLvAcmORh/JRYMXYZiDrWckhESr3GSYI=;
	b=I71WSmbxHz5VJMbJVDhqIDeCMo6QO/6Idhd6B5pAD5zSJxyfkEu9bckFPWGuaCvGsX7leo
	I3resFAkvuQEdidbsZ5ogiCd054tauU51OQZE/Lua/HbQVn2+/Y0gQSawgvQZHHT/Hg2O7
	3fmEIlV6I6zAlLEKCdROTvg7nYTmEXQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LO80KQZL;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766626; a=rsa-sha256;
	cv=none;
	b=LHAuFgfC82kxJL9/OgL+r35KM8Kmzcech49byPsc94i/kwN/3lv0BLyv+fUpmCSzeqcP+e
	471d6wBnSIwC8tlQxk6ollNz3RnXhF6DXd2cPJhbDXhbNokorluIrY4hYqYjTGmZa2+EJ5
	JgeWz+E47VpGt6W3eQtvjOkvEOiS04c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60A9A4097D;
	Tue, 17 Mar 2026 16:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB83C4CEF7;
	Tue, 17 Mar 2026 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766625;
	bh=enaf/WHlxY0+rUz/sR0jg/TQSIcygwkranNM2RjUkME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LO80KQZLO7/y5oXQFwtwUJ0/a9RhLfjeBQuSn8qocvIykFu/p0BLR7KGJKb2A5JqP
	 PPoruzqnYUL8+CG8tw0kc6SqV14FbtFCEBTdKN1cuyY2OkyZfa8sXIAtPRxszTOJdX
	 cFa/uDAO+FzUH/CSM3+jM2HdbYBNvbFkmuw6iozaq8GeqCFVitPnVz18N35lN7/188
	 6MlhgdwanmY0jnhsl+jgHYJNmaVnUqb1Oggk6TLSnA6tgghgwlH/1bRQcUKaJJdkU5
	 IjedjUKfm3/olQK+OP4IaqHxQetBGgX59nK99evDpDoCe5igVI6ojJkVhNSNB+0mjh
	 JvE7X95S26utA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 01/14] mm/memory_hotplug: remove for_each_valid_pfn() usage
Date: Tue, 17 Mar 2026 17:56:39 +0100
Message-ID: <20260317165652.99114-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3250D40009
X-Rspamd-Server: rspam07
X-Stat-Signature: i43ux79ceu1epkfbmpfrcx5zrqsg5rek
X-Rspam-User: 
X-HE-Tag: 1773766626-193872
X-HE-Meta: U2FsdGVkX1//KoRqXMxrV9i9H4Z9Y7acl4lB6fDhGrk0zrKUeu1F39oocbu1nj1dUoibgEpZ2w7W0wwsgLGQw7qtSGG9NH1aJuX6ZKFRcrrUyRe9gHXKGUiVcjmy8xIfe8I3qK/chp8TJj/YAaTpTRf/ZClahiUZ5EWCFgiuFRpQx+xzO78RTxY01s6UARzp2cUGT0WDva1mXBvg1CLU3bO1NIYc5VvOUe3RBtfhv/FmfhmNgeWppcplyNEru8qg0zcUFgSUYggXTXDs1rt/JkKsoeEaTZx67pRjhTh6u/DBxUYbMGWRn0ifTzzAS/3QObKWMhgvaD+h/5Eux4Hl+yw74evdu9NPmn8rlDUZTZYyc2+nwpMceGeddYJO6IZQuj3wJ6LHHjnnPcUtsyYAvcsZkqB4gg9/3OdJ0CmLhDvxY8XAmN1MHqMujBYP+ZfT+NCTvzTPDl9GuvdPGTMZd4JzunI02Valnggbm9go/TRmNN4My/n4H9vS0TT0qMRn0cpGS8tRInKnyNfe7+Y4pjDAgrW4V/h2eT2m0yRONliIFSvhVgpWWpkMfFxCwqpt6FLXYZHUKtXj9fzrrU9y25MbjjhflRUutw+9P/loioygx23sxnR3P5jThKR4gisVry8bDpBf0XXDNDuMTUD5yxYveNIeQWTwKDQspZEzJyskUIzBeeT2TGBJ6WlTUEfznIrGn9XM/+iBvrnaVHn8sQzTLcesMXR/SGr2tdSPisGPhpazQm+I4jxAUtKdVU79kzmYLLP7JL7v2nPwp1mmgG4Pmmb0js/zDjJTzWtcfNNH+Mew0PttUDVOZGhbF3LAJ0cUgS9VXFGe2YYBOOSrQnKSRhcx75UPDOOmaFTrDrpXzJzdsx9vpNU2TcWzE+l7Rcrmm/V9VyYsi05BHWyFMXj25Vbl/B7iR//0vyiOPw2KEDEygm1DaCFjBD9WuyuFK3FJiTDfBeTUVqL7Dso
 kCZ2Egie
 qH6iAbfDtxfcRb4s7A+rpuXFvPcvM2mRx8l2R13IekdkeafA5uImoVtnWYhcuK8QjaVF4ZRe4npm7bzp4K1kx+mzxwQxpiDx5gbzY+Vd1MkWuc+GoS3/dVo3+wkKM0bU0ahW/CoMB9iNv96kpS7aMR0fIXfFKMY02JFOhrRLPqi56uTWh5SCMqkC01wa38yFK9M00CKfdYZNtRxPoLRGDUNsBTtlVP16tgSfYwEWxX69cCR5xrX3rz6EclDGnRNM38lehJsPAmXqTFgq76/2/covaLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When offlining memory, we know that the memory range has no holes.
Checking for valid pfns is not required.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 86d3faf50453..3495d94587e7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1746,7 +1746,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 {
 	unsigned long pfn;
 
-	for_each_valid_pfn(pfn, start, end) {
+	for (pfn = start; pfn < end; pfn++) {
 		struct page *page;
 		struct folio *folio;
 
@@ -1791,7 +1791,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page;
 
 		page = pfn_to_page(pfn);
-- 
2.43.0


