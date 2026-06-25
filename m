Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B765CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 02:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15126B0092; Wed, 24 Jun 2026 22:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECEE6B0093; Wed, 24 Jun 2026 22:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BEC6B0095; Wed, 24 Jun 2026 22:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73CD66B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:40:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA1061A0534
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:40:41 +0000 (UTC)
X-FDA: 84916881882.26.A620EF5
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 441F7A0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:40:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qw4J2wef;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782355240;
	b=0xTCv/k5gMXj8eDm0KRvvqZYh/lJS9WkC/4Gm4tdP42DOLw8a3GYY6OqWUsdfEiwsuKYqx
	N7vQ96ZJEmVgiNbkvCvD4U+iZlbEPdPjrL9xoqQ9oNLiMCynX7A18zDsDIrJ2rArrqE5me
	/aM3qu8WFpKwneE6ZZwaWtas9zSRHxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782355240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TFbcmBSmgNQkGD89iSSlaWPAe0b7053UYUJCgVQXiLk=;
	b=FNLhPzB7COWidqq9RkhUzQMk2QYxXrxJlex30BhvRlaEHHaE8VCJ4yiYNuwTh2cmR+lox9
	stupgOli5Aht9PEhkO8cgkTA6O1GSil9N75NSOT2UMHdAJTRuXCRg0QDe7MyEUS3BIF3+f
	qaaJgBCCBCeioh+ljQ2PfhGcGO9pAxw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qw4J2wef;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782355234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TFbcmBSmgNQkGD89iSSlaWPAe0b7053UYUJCgVQXiLk=;
	b=Qw4J2wefkNJOAExdPFGyxaTMgtXgBzTr722Flb8xhkSDGUJm7UvAmHafV2GjCODdKFuKFy
	0cJILD3wBDJktkBnc5QJezEOZoulpRHoQ4MPI4xe6gSxhjK57+SlZ/Y2xEJOqtE9D5O7K/
	Gw0MMj1jAUVTODaLDTMR1DPg0VYyre4=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3] mm: assert exclusive nid/zonenum bits at the page/folio access sites
Date: Thu, 25 Jun 2026 10:40:19 +0800
Message-ID: <20260625024019.838786-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 441F7A0002
X-Rspam-User: 
X-Stat-Signature: 9kyqfe6z1ma4habwirmfr3chxczo5an7
X-HE-Tag: 1782355238-823399
X-HE-Meta: U2FsdGVkX19S3JJ5U66WN5rYa5BBKLX7/JoEUeOBXZi1WPjlkqOpFo+g/N94lWtqOoBe8PGMcLh5x0gBTfp0xIo85gdFHuIbPgqXOsKPcYvHzSgIz6+4xBQxCmQwYzP46iLNHAr5zbiXcROU2XBZ7qm/RFIwOSDecdiXalkqf1XB7O0wypIYtpF03/iL+YakB64cB/tHWHma2w0DHaXRsB2cfpMOwXmCqSADGThQPp8OYZHpYCwGNcxZjuRwv1BxZhv/OTkBYMu6t0lrrL9zw+K1dUuXoqgj+b+/1WoRZcpev/ux1irxdaeXUg2LdKHUQ0Gjc0xpEqoB5UltbgZMuMl1V19igsPnOQEruqJw0lw2gGgoMgfa96j5pCvuO1E6Z/6ntXRYEEiK7vOWXMjUjWmCxX6ZybEEFnopLvH6T++jZcDNoybLHZfyApTxqHapBX3c4KDgGqlaD7cXVGUZBFGPHZowIfu2XNUiJJrkWy3CQCJa6zrJ0R+FSlSkg/1TUDWAXchKsw0HO8yhgGb5hSy/zCFhcQ2TASQC/NXAwsG8EUqIDpkj7pW9h55dLWkFo8iz0LYS08ccrFbiqalh9iRM0a2osIfLuVG7mQbgmJWFuk1YcD98/TXcUzj6EsyQhDXZeI9gx6aIRJX3XQ8aBvGf1innCtzm5xfFrwcMak4tgBcS3W41oXRTD2qsHrMf6brtWhmSX4AwyKYW3urKqSSb4T11MQEnrHXiPjkKMr/byrA+ShteLiDgu7MUuGWIgylWVRKGP7A+TLwCRDxOKjpUyPzVEdfSGuuuHgESO5teVfklmBfNeP4EHznUFHvv1e+KumPUzaF5hdC/d9HgqiZaT9p5+566CQXPgcFVMOT+SrRiC7Lz/JZNZZYzreBb2LeStpCoyhlYXkK/uoz9CMoF6OgNh/MDztnOcha4ZNcQ9skVjPopMzTnQfUZSZRzJDRimkon+AfEL0Kquf4
 CYD4OU65
 lWlDLrLw/MTaZrRx9ufD6iZF6GFRua2vz7/FYog3KhFbNa08qZsWlISGizU5Z4wntd8BSsIPRCCkjgdtekK7oBYD8vNL6a421JGN7et4+kEgAteI1Ssj3BtirJUUahSxuvuhX+e4ZvF5UsBhP8sUkoq8SvatvuFetdDU9uZW43yln7YfnI8PtBPYh79Q/7QA5drSUMh8MfNLHnDhn1QziY07zf9C1B9dog7Cba0FuMaX9DAZ+Z0VQKzp6VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id and zone id occupy fixed bit-ranges of page->flags that
are set once at page init and never modified afterwards, so they can
never overlap with the low PG_locked/PG_waiters bits touched by the
folio lock path.

ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
checks a by-value copy of the flags word, not the actual shared
page->flags/folio->flags being modified concurrently, so it doesn't
reliably assert anything about the real race. Move the assertion to
page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
flags is dereferenced directly from the page/folio.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v3:
According to the comments of Andrew and Sashiko, move
ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
into the page/folio call sites.
v2:
According to the comments of David, remove useless comments and use
ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
page_to_nid().

 include/linux/mm.h     | 4 ++++
 include/linux/mmzone.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..734e9de8f4ce 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2296,11 +2296,15 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
 
 static inline int page_to_nid(const struct page *page)
 {
+	ASSERT_EXCLUSIVE_BITS(PF_POISONED_CHECK(page)->flags,
+			      NODES_MASK << NODES_PGSHIFT);
 	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
+	ASSERT_EXCLUSIVE_BITS(folio->flags,
+			      NODES_MASK << NODES_PGSHIFT);
 	return memdesc_nid(folio->flags);
 }
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..56dffa966343 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1274,17 +1274,18 @@ static inline bool zone_is_empty(const struct zone *zone)
 
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 {
-	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
 	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
 	return memdesc_zonenum(page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
+	ASSERT_EXCLUSIVE_BITS(folio->flags, ZONES_MASK << ZONES_PGSHIFT);
 	return memdesc_zonenum(folio->flags);
 }
 
-- 
2.43.0


