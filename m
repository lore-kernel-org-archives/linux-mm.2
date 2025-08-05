Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98C2C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802F56B0098; Wed,  6 Aug 2025 08:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B37F6B0099; Wed,  6 Aug 2025 08:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A20B6B00A2; Wed,  6 Aug 2025 08:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58AC06B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:53:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06C951A05B1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:53:39 +0000 (UTC)
X-FDA: 83746324158.14.4366DF7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2B68816000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:53:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K9xjg2YQ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=DHoawbluzhy1M1muHyr8wCRCGWznSllh7Oobr+Lt/as=;
	b=053to9HCXxjHvXVZ7Zyhae4aPaX1iIxgy5pyZ/DN61+64ZGbgdxuC1YmBIfKYDdTq/gstY
	zRosd3kLi94Htuh8y3ZB2o1OmJ4+zImnUfa0cOrMgtGJkOrLVkELaW9p8NJWqrD2AnFsbn
	wjqwkDHAm5BxsOjyK1JtWY68z18wakM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484817; a=rsa-sha256;
	cv=none;
	b=EdX1N7edK3TjEJ+XBhqIAlo4IZZPlMpe2oxZjFlBD7DVj/BysphqNoKWwlxdoEMZNZkHC3
	zBqcl80LF9cG28/yWz42fD5UE3NRZjPCMDDZAi6T+saATbB+lFDd7DrvZD7kNUV9YmFQxd
	Qae0tn70mC/fGI6eGF4AWjG2hYVacKM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K9xjg2YQ;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Resent-To:
	Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description;
	bh=DHoawbluzhy1M1muHyr8wCRCGWznSllh7Oobr+Lt/as=; b=K9xjg2YQsy1eoVJKjbJTDOXHvC
	q9EMEUv3b7/w/d/QxCIQAIPXqgH+yktxqy4uW+M2gWKYaipdTC0+10Q/11mEakP/JRep2QcH21/QB
	WxNbnhcC7jQqMDildGYVg/UixXkqGxRBsr6lQ9fEzaXBEA0dyiwM5KYGA8ddU9ZW3m8TmVGt2lUpN
	N9PqJR+zJ0U9CaA1tRf9Kt514ETzqivU5etsM3JBmFJ+KzrhzdX43JbEfEZQsaA27TiITK8atYTlB
	dsDwuWSm06tCdGolNQ7u1X+PkR6nSrQY/8cXLbsifr740SgcOR0qSzn4xDHWOTAIIXgqYnj1m4oow
	Bg9YuFXw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujdeB-00000004Ijx-3J4F
	for linux-mm@kvack.org;
	Wed, 06 Aug 2025 12:53:35 +0000
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T5D-0Ag4;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 05/11] slab: Use memdesc_flags_t
Date: Tue,  5 Aug 2025 18:22:55 +0100
Message-ID: <20250805172307.1302730-6-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B68816000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: i3j98tw1w9jyts4i67y8jhowsicsph5x
X-HE-Tag: 1754484816-183774
X-HE-Meta: U2FsdGVkX1/9zTZ0rk3lxh3TtpNjDN1dCmmOn8rRegh70pL8MPBIBrMrMoUoIQ+8nR9UbLJYrBJgnaqUplG6Bu2bRie8UJAP8abT63BCKO4BlGHdsrBNEIiTpOqWQyhhNsHhKwN7BkIzt2584uF7V+X/sOYRFzcOzxR6VzpJQ4CMOxaAcbQqPflPYRfNfgWIRGeGPvjhFEX3Pt9udNzVu6gW+q4oMNDubgC+Cvldu5WOLxp5Mh4cWC+TAjlV8dHf9xUF6Om8lF6h1oWV/tIVoj9q0Br7Lve8vQTF9q3rjUdzgutwVHHACjg/AKAjNnEJBH+hATTnvYyl1LsrfiIUO6kryMWdkpqzbbN/krQXD8XMeGi1KTcaXnwxzFgWAoe5ybyuFItWt4hIO7QtN0E2zy2EHDWEPii6LIRwtAkFqxHt7J8OzWjI1tB+Eau2oqOFMKoAjhHy5IJvittkIjEmKvumNL4ehy5uh5916o/XGVLAGsQ0uJDjSO+NXReR4ushK1WVbwjPeVi8mPdLIToBH5YpNkaB+PyZm9tS7g2x2aGHhkW2mDkwb/ZMoF8i1ovOhf1HuCfbF8kkr0CsH7RiGRSTRe73M7wtAILPKpLrH34ZOfZ0zsNF9TAQOn3oMXbiCpugT5vzMu4rGYV3gZpdBj/lgz4CaKlCeYUCOeEREkDL4kadmL50xIQiQTSKsQ0zRn6HATbjv0rytNU4KuUWTbyqi5ZmkmFfXdVnif2xyCp0rsq5BHuLcq5Uobg3G3mRCOKvjYEH6rCL92URdhSj+FsW6bv79YJv3fK+XP3rgELp+0QUiJuNa58iTjTXPrJMMtimbYf+CZmJJEk/rcJwq10B9/cIDdCaPDbkVgmOYFX1YtdZtE9MYdZtBIjBT3XoR3HVCseuXKOzJ3QzZRAvrirlqww4mMKJTa3UWc+hR1+Ehf8AaJSnRQ9aJ/9vFfBa0ZAKW4A/a2PtyXn06LS
 rcnbGOif
 LAwG8iKaWwl4VlsDKb+oa8Sjz2yCJ6ZmRW4xCo8cdB/4M5HwHJXGYDvkyl0Zi5o5MGUhwA1F5HlKY9F6IjvOOd35kAwgiWPEGTXKFQlVmjOXQZmWvGxCekUqZQEZ2ycHf7xZ1LKlsJI6zQCT4YPWR3xBNwDXMmjjYoVuB+ARPAh/1TcxXvAZamGJb++MHDypp6cBSYmn+K4xnmtafInOgVdZMUel4X+UNStTY6H7SLKUtMLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slab flags are memdesc flags and contain the same information in the
upper bits as the other memdescs (like node ID).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab.h |  2 +-
 mm/slub.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 248b34c839b7..7757331e7c80 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -50,7 +50,7 @@ typedef union {
 
 /* Reuses the bits in struct page */
 struct slab {
-	unsigned long flags;
+	memdesc_flags_t flags;
 
 	struct kmem_cache *slab_cache;
 	union {
diff --git a/mm/slub.c b/mm/slub.c
index cf7c6032d5fd..0160af3b3943 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -657,17 +657,17 @@ static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
  */
 static inline bool slab_test_pfmemalloc(const struct slab *slab)
 {
-	return test_bit(SL_pfmemalloc, &slab->flags);
+	return test_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 static inline void slab_set_pfmemalloc(struct slab *slab)
 {
-	set_bit(SL_pfmemalloc, &slab->flags);
+	set_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 static inline void __slab_clear_pfmemalloc(struct slab *slab)
 {
-	__clear_bit(SL_pfmemalloc, &slab->flags);
+	__clear_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 /*
@@ -675,12 +675,12 @@ static inline void __slab_clear_pfmemalloc(struct slab *slab)
  */
 static __always_inline void slab_lock(struct slab *slab)
 {
-	bit_spin_lock(SL_locked, &slab->flags);
+	bit_spin_lock(SL_locked, &slab->flags.f);
 }
 
 static __always_inline void slab_unlock(struct slab *slab)
 {
-	bit_spin_unlock(SL_locked, &slab->flags);
+	bit_spin_unlock(SL_locked, &slab->flags.f);
 }
 
 static inline bool
@@ -1046,7 +1046,7 @@ static void print_slab_info(const struct slab *slab)
 {
 	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%pGp\n",
 	       slab, slab->objects, slab->inuse, slab->freelist,
-	       &slab->flags);
+	       &slab->flags.f);
 }
 
 void skip_orig_size_check(struct kmem_cache *s, const void *object)
@@ -2755,17 +2755,17 @@ static void discard_slab(struct kmem_cache *s, struct slab *slab)
 
 static inline bool slab_test_node_partial(const struct slab *slab)
 {
-	return test_bit(SL_partial, &slab->flags);
+	return test_bit(SL_partial, &slab->flags.f);
 }
 
 static inline void slab_set_node_partial(struct slab *slab)
 {
-	set_bit(SL_partial, &slab->flags);
+	set_bit(SL_partial, &slab->flags.f);
 }
 
 static inline void slab_clear_node_partial(struct slab *slab)
 {
-	clear_bit(SL_partial, &slab->flags);
+	clear_bit(SL_partial, &slab->flags.f);
 }
 
 /*
-- 
2.47.2


