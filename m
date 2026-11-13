Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9AE606A893
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FO2diBwj
Received: by kanga.kvack.org (Postfix)
	id 46E076B05C8; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44EE56B05CA; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297C86B05C9; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D91656B05C8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64309A7039
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:41 +0000 (UTC)
X-FDA: 85431380202.21.419F2A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 57E04A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FO2diBwj;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605199;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DiCXAhwU5zMrLZsoH9A3i98+K1TnqCojamIQPcq9Kg=;
	b=vKZ7hnLUaP/Y2F2F6FwCPNuzxKWreNAUNtm/9Zm006faEr23oYwcsL+s/2fU8OhK6CN/yU
	Qfq5TIUy8Tcqers/uKYfVD2MjGwPAA+Qmr9wfZHeH8nlVlHOMGZ6FFBHHq1vEIPpkv2ZEf
	nEeY8arZ73qqnpGpohua4d+ajWVmF9A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605199;
	b=J2OKXiAK7fVqrzR5SI5xrZd88rZUbHhkYEDUHww8YbvMuTDDXtIo4YjCnbIZ9r9vjAiSGk
	ZPPz59nl36UYB9dV3eEkFr8tjCDM4zycuwadeI9uEaR7hi6JucNjFQeBLDAM8zC68DQvYx
	DmKGl6D3RNYAlodCZ3iud7Ju9PR7RoY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FO2diBwj;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBFEF63477;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605198;
	b=JHRAqnajon92xEtJlNkhs1K/+f8vO4BGd7tJ9bS+OY/4fD1VeuOfy963xgDSWtK0Uvss
	 y7lHplSpDdYZVAf6wFMLjnKSAnxVIErTd2J32XgRnLS6rojSGavmAZiE5WOP4KBFrSAEg
	 XBIg5rB6yXm863Naab3TIe+3O7f5TkX/PfXYqVjUwtMM3ltCFfYeM8qA40B6Ys920WwCu
	 ceMHmRj6GurH0UnpwCjRbSpp+FCrw2GQz+ZQsgdeVRUZG25OpD2f6mYnJEzSYJR77PaKP
	 0DhCz8TFqcL80He5OsQ2wmL+yI8tmdzdEsYOuM2FBq/VuOv7MtkmgcZCQXPSTt518rQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605198;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9DiCXAhwU5zMrLZsoH9A3i98+K1TnqCojamIQPcq9Kg=;
	b=Cb78srZ0QcKtL3+c0+/CxkKnIs57tZNnbEZuGMPRioI2njfo+Hf5cLyR6BpWksftTLnw
	 m/MewjzONKy2pclLTEccMWPjMOI1coEXTGnJljvLIL9cc+BnsBkpYZ9+mwp5mM1SBppFt
	 RVtmkDrR0tPm8063lqc+kg8HIKwXHptE6dNQBhUYB3sBgetdrOT9NCoZnkEypcnYQ6BOi
	 t5X98dZsgl2hKUYgptRgzTyFkXEsbVjOd278C2tUrNiLr9V5XDLy6Rlu0kqLjg2pjP/e+
	 jV02IEMdkh4DLg/To/QyPx4gQzruiWQWJgg5kzlybTPMWlv2ItURi6CxuI9CJJNQnRw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0A7F61F00926;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605198;
	bh=9DiCXAhwU5zMrLZsoH9A3i98+K1TnqCojamIQPcq9Kg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FO2diBwjSFziwF7xHlpHVCMOhf0t1B9cbBpp8kQAtNnxCC86/ZDOczGhbWdnuOTHl
	 lW52jsVBcWDs+bIJ1WOZZfeyNuIuLBqbpa+taPyNQvPzU6rTmTlksxA6puoaAabTFl
	 J+fqXECyBom+Gcpei9i1wZQ4x/K1gzCbWld7Y7L1I+7le4Edyp8ZuCz8vKgIHM8hpN
	 4n77GtE6UpSulY8viPMrPv5SyFdRUzFO5hpXMD9CadhsbThg9c63fMKy9mpjGYmoO8
	 ZMHrNsNjdS3WncAN1oXe7++kGXEYh9eLm6/Ef4M9l7ozZ8IU0Xh0yWwYN15ltDeOM6
	 TMT5WpvRhxurA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8D42B49B2E;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:24 +0800
Subject: [PATCH RFC 8/8] mm/huge_memory: walk the folios reversely for the
 release loop
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-8-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=1841;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dZXSI3LM1sOQiwV6KeB6SU17Z87R/eSYehou1jdR5o4=;
 b=IzWZ890bKlfCzLTPrilcnJxROgDWfSBsVhqWNDPvxfGm52kTpVgfbT0g1oAWYBw9TmLkGlYET
 sEISPvezQAnDtnWjHKzRTfNJFLFL1pk8WFV+NU3RVhV8SiCnyBW6syP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: udjbgzi8dsqj9sm3brf4gtp4prsp3izp
X-Rspamd-Queue-Id: 57E04A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605199-118569
X-HE-Meta: U2FsdGVkX1+dCUy2KHncGOx6R/73PjyQ7+wX9Ba5lbpaSsGlDEdSz+jqnY/HD7tbkoo8J5HpmnoWJ6YjX8vFJJ5ezD/7U96t34NlvIVHNFzk0XzfO+qr6M9PIFBl6cSZ96nHo4Je6Rma303O8TnINOcFg4rxZSnkiHqzHeeJNLY0dHC5WN7okIffcVyfUupyvtlaAnjpZw8VvMDh9g/os2KBZbmrd+gzlIUKI4B+5tSp/HBc98Uw5Fp/D0vCYpLUarNibeBdC9eFwnf0GPx1UCh2CXsl6pf/rAgHlLHstdXBptRHbzt2WZigeelbALzqBjl4kN6i5QqxyiBScCbZh6q+hBusJwiaoj/AS6xeIkrtotXN19dwEcCqjdOhtXQ6O5IoUqvD00iZHTCJBUddiFl85yl6h3UvHuIj8ZBpnBdKVvpki2lWHAv5udPzq8H3Xlt5yIdCxDEdaC1fmejwQ/KL67uOdojr/uUFHfqJ0E0GjNYySogQY5uH9zS9fpAJpgHk7WhP/7KZNxzn0ycvWvrmKiGJZ3pNBDvg6C46Mo7W8hJENTZabfnQbjehoTNShajVuWdLXAktZT5lILDQCnqNY03mtOklspDGR3QgGObT7x/7zcxXkWmlE3g9cYPa3kkkLBTmoYBeSjdu+jvjJ0qsKaf2zqnUpsDiPU18J6P5Lq1A+DdAvw2jTU7bRb9M/E1uoYbOx/y324TbETMik02xKuCQLeFtuwGmLuPmJB75BQP/CIB0oMP2od0AxGkCz0UNum4utehE3AGuLZKw4jH+3aFAzrzf1N2YQ3/EYjLvUrUwegePx93NEkHsPbmpPf/rS8smohz8CS1UZzwLirivAOxUnLVw7Eo4vH8zAPNEzgpG9J2Jofsm40i9Oen8joAN/BJph44ZThw4e9LdWn928pbZUL6HL0r21dUwOjZ547Kj/oToLHog14WtawYFFp7puBWcysm26//zXhN
 Wb42c5DY
 5CL3CeQlgMCB96c9+sLfj/dHqDJa0trOcqYuVcqrS5ZcIp7mObu6XHWdwGHXlBi+CuIv7I/OWA2bJgW+ibLa+cW4YdUoa62cUH2xTftKt+ODeEW3gtedYnDCeN6nAJ38Fle8EAk9w0djjXswVoEIOYaKuxzWVNpOjc8YUM1JwOpXn0UaVEq8YdcNogYygp4OMdOMHIDWTlRfrbSFUUYgvwikc6ywBxNv/5dONoaN20aY7g1qovgAPX1R49ajyuVww7P9+N+fkczU9avcvUM7AJCAKInwetOdRQhpzuv32ntUIkrEWcxb4iK/kr66t7JEvMXs6h/96ZOLkQr78JemQRncShHshSer8gcs6g5zJ63lT+ijdeXHHGkBrezNWo3cOzUPazvoFS95GbHBr6yFcjcXKYgc4OpfZnBOr1sazWqqboFMlZIN+7svBWrR2/NLbbDBHTnBVVlRfmnEsFFol5wLxL5Uljx896OpzKTxUcHKJa5Zx6moYG6PqCdz4TxmVNdEgmqUxyjNWIx0kf3AFaTUcYMp6hZnQ3gzqXUIDie7iKCkEU8HUD0fsCTzswhslQA9j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The release loop unlocks and puts every after-split folio except the one
holding @lock_at.  Walk it backwards with folio_prev() instead of
forwards with folio_next().

This also helps avoid a for loop pitfall mentioned by Zi Yan [1]:
folio_next() needs the folio it is given to stay alive until the
increment, folio_prev() does not.  So the cached next pointer can go, and
the folio that was just put is never read again.

Same folios visited, same work on each, only the direction changes.

Link: https://lore.kernel.org/r/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2ff201a5e5f3..bb09465a3948 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4366,7 +4366,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	const bool is_anon = folio_test_anon(folio);
 	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
-	struct folio *new_folio, *next;
+	struct folio *new_folio, *lock_folio;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4399,9 +4399,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.
 	 */
-	for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-		next = folio_next(new_folio);
-		if (new_folio == page_folio(lock_at))
+	lock_folio = page_folio(lock_at);
+	for (new_folio = folio_prev(end_folio); new_folio != folio;
+	     new_folio = folio_prev(new_folio)) {
+		if (new_folio == lock_folio)
 			continue;
 
 		/*

-- 
2.56.1



