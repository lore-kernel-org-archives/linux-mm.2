Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E817CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5A86B0088; Thu, 25 Jun 2026 01:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86A56B008A; Thu, 25 Jun 2026 01:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CE86B0092; Thu, 25 Jun 2026 01:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B146B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:40:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D3F61405AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:40:37 +0000 (UTC)
X-FDA: 84917335314.27.0D8815F
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD784C0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:40:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4w4yPjo;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366035;
	b=7NR3k5OCYjmCHA/NxGtPdZiJR+NKWH8sa5PnafBuKNi3w7BLZw7IFtZAoCZ+8fNQt4uGgo
	UxXTIxgwedf9fc91kHf02mfp9cn8giMp1l63CbpF2qWF8hABzWbwm+ppQy8MrcGnzNFnvw
	PM41zn8zTG1lm13EwYj1rXrcxrxDC5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NkjLU/0Y0qQUoUyC3qszvMPUKNHSpAOvXGQbghzmUII=;
	b=bu+pzs6uN6Lq5WZy30Il7Uk0cYZSnYbzWJuIhOf4Jvs+F8ljtJD39nQUeDLx6BY2iZZnws
	TWpvwRa86aZWuh3zIrIMtsdQb7BG/7yl+kitISiMLVoLMS5X5n5gJR4UX9jcEcwmg4FLMQ
	Vw0LCAuArLZuA1UFzNOcOOTNb8CkGYU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4w4yPjo;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782366030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NkjLU/0Y0qQUoUyC3qszvMPUKNHSpAOvXGQbghzmUII=;
	b=r4w4yPjoXtja9+iHejy8uZx7iZPZEbTrog6OMqItNVZiuU4ijvWWg/M8jGyqbC56pHNAZd
	s/6So9b1bqjGyc+bdrMg09BjoDXGGG+GoWJx2oR7Ldv4wlPJbyW3iFuuTsmqGCwozOVMcN
	42RBO01L3OC/ZF+ycXkaZPmpyBkhrug=
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
Subject: [PATCH v4] mm: assert exclusive nid/zonenum bits at the page/folio access sites
Date: Thu, 25 Jun 2026 13:39:58 +0800
Message-ID: <20260625053958.918738-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5bq1w643apyjt6nwdb6asoy3khm44prx
X-Rspam-User: 
X-Rspamd-Queue-Id: BD784C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782366033-121921
X-HE-Meta: U2FsdGVkX1/pnKnN4EUWvzCldRtqX6ZuE0BfLkTjPivmbWl7qsp9fMFt8BDdfX0oa3p8wBDz5QrWMjXzlGHKvCPGJDwNQed0mQYngzMPtaKzur3CtXIcWTHgZ9OSISW8JZha5SqVnGSKRp16YXVrWpXhnI16iCYsAmaqQIItypIeCPgXIWDYCQd7xSp9q8aTv7VmtE2vcBxj5YgcDs+CW3LJaDw5wvv6wik60GRbMt9dpcnbfLPz/dRQxI4yHHurO2MGFnHi1x7FrYtGGWOHRZ1enF8OEfu8VVjgrS85QQ0bQAGg7F7nmO1iL4xRGNNxtjPoV6VdLiO8I42LhARuWYLx0+9va6ImwAeCK7z9jSHZxC7MgXSmm45T9iO/0G9aGnS5oOL+0mEuZYpOOZqI2SJnfwyevdJmYWKRDLmVB98DUYersGYSwTY9dCn8I0r8sVbPSmHYDrw+bp/gjsKq3qOjgJID1LN1JhrhsZqJ54xSdm7lC7ODyBhv2j4UdlO6uxsfQGtYYYpzdesp8bMB9x3zfrpkwCHn0QMmRmnROINa7ByNsy2pzVVSIqGIKSdYU+nhySCJ+d9agDofBwL8OFfraABnVsTmD0rT14co4YCZD5HdXtfYOFtb7h5y9/zTA54/MOi63MCwobxuh14YVBi4EgIwO4Ra81NEwMBZDDRYvIREsqiY6FK0pqmWyS35PyKaLUX6dDc+3TVMdO6+XmU2fEfiUXhzJpzgqEQ9Rkzr6KyfjJJQfHBPmEzkZ3lIcw6bL/sSsr8nSHGyIxmviVX/9IZD8QUpZTFDgtQe/mWWlcLlz6JQ+aO//YnHUyS5OQp4O+TovuhQ4GtZ2AIoXn+PgwkOH96CjqvJTES65L2veMYPWfwCjsPkY8+Mel/UBNiZ2sqrKK8OOe03270Kx5VfVjg9V+701Ru5Goo0c00jn0AAdztVIui3POMrTQy4hRLszlUKHzetTDNFZ3M
 GOhLX7vR
 gbY2bSkilaUUKo9GgMnqvGZaVev+bIRLjeX7wwOTVDnFufzb14KUDZE6AfvNWbg2skUgtjJ5Eizj7tRegivUmHUfxUnrNI1kBfUORrS0WBKSwq0Ro2nqzinvVzD5uhkl11JDwRySCcnPguuPK+fxXVDz4vVmqP1xjgj/H/+eEhw9CTMfrWSOJLT/mThWsNT7OKP7pJiPGd+cssPbAv2R4VGRquQOqS24wPhiE/CTZW6SlAdt3WE6AyqZ1UQ==
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

On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
folded to a constant, so page->flags/folio->flags was never actually
read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
folded away, so doing it unconditionally would add a pointless read
of page->flags/folio->flags and a check that can never fire. Keep
page_to_nid()/folio_nid() as plain "return 0" static inline stubs
under CONFIG_NUMA=n instead.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v4:
According to the comments of Andrew and Sashiko, set
page_to_nid()/folio_nid() as static inline stubs returning 0
under CONFIG_NUMA=n.
v3:
According to the comments of Andrew and Sashiko, move
ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
into the page/folio call sites.
v2:
According to the comments of David, remove useless comments and use
ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
page_to_nid().

 include/linux/mm.h     | 9 +++++++++
 include/linux/mmzone.h | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..56b39194605a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2294,15 +2294,24 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
 }
 #endif
 
+#ifdef CONFIG_NUMA
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
+#else
+#define page_to_nid(page) (0)
+#define folio_nid(folio) (0)
+#endif
 
 #ifdef CONFIG_NUMA_BALANCING
 /* page access time bits needs to hold at least 4 seconds */
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


