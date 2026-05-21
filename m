Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDADCD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBC46B0088; Thu, 21 May 2026 08:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3C86B008A; Thu, 21 May 2026 08:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFDC6B008C; Thu, 21 May 2026 08:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F52F6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:40:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E57541C04CA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:40:35 +0000 (UTC)
X-FDA: 84791385630.23.AE98A75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 643DA180010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:40:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScCUhpbr;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779367234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RlAOM2lZrtJhhmPATuaev+PMTZ0nLmMQGqFD18Zj8Ds=;
	b=ULW6eez17hwyi62m2mm4f7AkyrYBMPogSlOJd9QPWgmyYOCqH/Xdw65xuS5e/ustZbg5to
	8f7GHRExDHHPgYPzZ9XWAul4yTis3vSYElDq4gpmbYE4PkZ0serWfg/Vn0XU9nCW0PvVrB
	ABRmVUNrachyn3GlfqjyNMioEue0L5Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScCUhpbr;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779367234; a=rsa-sha256;
	cv=none;
	b=MY0ff8Ra/UwnxIc4JcEszEEZlfc0KXjr5s8pY0dXQ4yyqsUzt4ra+8PYGNGCyR+LGBMaip
	v1QhidzUkMW91NoagT+gT8p/AF9uHrZeWJmslkbQf72AkcCYhMxsOivV5ghsW5PFUJNR2Y
	VdaxZx1RtgUjGqTiZ7JfOlP512ylIeQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C52F1601F3;
	Thu, 21 May 2026 12:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799B61F00A3B;
	Thu, 21 May 2026 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779367233;
	bh=RlAOM2lZrtJhhmPATuaev+PMTZ0nLmMQGqFD18Zj8Ds=;
	h=From:To:Cc:Subject:Date;
	b=ScCUhpbrSDupPtmSqPFnD2k7W1tWR9KtDOK5Y3502t0qCdePjhyX8i6FD+cUrBnvk
	 jOGqEBPGtfJK8orGqwNjFAaEd8DODy6YdBziASiWTyG6ggnwyOWf+78tLE3hm34VCO
	 /1zI0ITJk7wbl5qEiodt4YWfeZPdlHv8pKg0hGpw/1un+H5PIsHy6HjmqzhAr93Jeu
	 yl11Ag+TH+h5q6wsvQGUiywv8YrfCk+p4D5XE7YMz3RE7maDOLULM4n/ROGNtzwROX
	 fowwmTXqfqxaFS0ovfspUzfjVwhP+2m69rok4NKkmqaArlBTZ+Yrfoh30+RtoWeFpD
	 MVkHsuBTWlaxg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] mm/util: Use kmalloc buckets for kmemdup_nul()
Date: Thu, 21 May 2026 05:40:31 -0700
Message-Id: <20260521124026.work.036-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2565; i=kees@kernel.org; h=from:subject:message-id; bh=9Y0y7pZycGbEOeO9/OyccNveQ4PnpxVbx1Oaw+ivBqg=; b=owGbwMvMwCVmps19z/KJym7G02pJDFl8f+32OLZtm9+yYp/5+n/7u5sdGhyWrzBdbSjiFbGH1 /jDPT/FjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgInsPcLwP2FP3cldJ4++OZrD X3XtsFzmfenFry5KfeBe2N7J6x3y8j/Df+eeuVaqsVErn/Q4FESk1jbetZKVtnjPIvhd+/HDTeK 3GAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xgyba4goprjasdj7jij9ri6km1ysnqp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 643DA180010
X-HE-Tag: 1779367234-535322
X-HE-Meta: U2FsdGVkX19qYsiQL5aFDIIEJUxotGHpm0AfslSIYS3Iu8fap0ztJlMem14Dal5/neoO5LFF8jy0XvxM3uSBGnGRzQK6eSO1qtLBjroTCAyPVZO2EdNERKS44Zp4cSlfCxLCOn9ql4UfXFi+9DnR0cyKwIlRGUfEBCzxdnptU5WfUeZFZYgB1Oeeztg5IOEDldLCq8SvN8tFKCQTQfV2ki6RHwNP/MTI/C5QWZk5vbAqVLocs+5YCRyk6PDFUGqRB6cseC+8PaJ+UhzfoSd/T3XJCpAy/TM72P0bBMv3scRRm3oSUOwWLtjWYP2omaEg2GS02LMs18zUpVknWupfBm+6aZxiXY01lU55RVl5RwtJfxMUef29J/WDxRoQ7nUzQKbYjEE4ICYFBiZRsRUgHi4ziWIbvymxHl6XOsw7AQeHR2H9tVXZy/7GgxBmhO2Jkiao5FnB0WweJJOfjrnU/ctimy0uXbJKsgBaUabhSz78KC/kUJHm05gVTPko8lUKX78ph2sXVh5lWWkVWUS/xGqoOTVJ12ckcGwSgkWhsa11xXFCWUV1AuAUhvVOwn98TDVjq3iNPplf8YlbfPYDFjeRLUhXYLLZj1BttT5i30sHO2PZq7pKnW9LcLV8VQyr3MEpk/3WF95KUvawDSNWSEoiV6OSTzNch4GafRLdwVTEEVIgvEA2jV97F9ODhHYuSHvimoyNIALh7xcYh1xVtHKAUJ0RPI1YT5+MoFpEvDAeZpNp0loqcr5R3EESKzc0tLEfwOOOv4SI8VET7uLzNg/8QFela1wy6A2z23CdTa9Qgv17TY0i95FySbSof/KI7ywn7DoD+uh2leC6gSmLmJ7DeZACcjw9NLDqg20gdqPTrwhqh7Mw7hfgIjIsXqCuAUuIYVqhQTSEh5wnYZT2dQaPxVDaKqOA0vK+hsYZ51zPBEY6hhf+xbAHtkouFrZ8DL3I76oioZUc38Y/dhi
 D+dZf3VX
 d6eEe6g2vSKCU2VCdH4OmGt3zg34Y+911y+587fmUs0QxmXAVQ4O4slyCKD0XnsNcJhY6F9nsQQqKtAxM0DsaMtTLJqBT78Um/5AJWN2XBxOS3k28jQ5pQE4EjxumK2gbO4LAgsZ0k1CgQmk5qca/WvP8A+EuWkkroCmOpLe5aOS4OMj4UssP3vwilVtjDcG+y5Y8ykXE/oQ4FbXtrY6/zkYP+2aPg8l03VhkC+xkTYRARNkn5NGAcZUjKiK7Ox5vbcOtWly4qk0iKo4FjrqP1g+Tj70vcMcO6mRTTAt01Mk0+hAomIkVd5SEywJBy6gtW1uDDGWkEQPLNF7pO+Fn3dMa9tVq1QXTCiSexRI3tVJGl4VX2vhe8V9kaE09X4PCdd9F7o9cJGfPz42/1kM2LsgLEGEbXbSsNp1yA5wIkV/BtKAzLrgZwGj/kiqrz/huBFYTc7/ZeDqA8Xnpj8o9uGya5K25M9X4UkF+ZM38rF2sjCFocGbZbWkX6OvwIi97XqXqXqgsr7iCy491W3nYFAXSG3FHrQlZ97du
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The use of the kmemdup_nul()-family of allocations are explicitly for
allocating NUL terminated strings, so these would be best separated from
typed allocations, as they are their own set of arbitrarily sized
allocations. They are not as risky as userspace controlled allocations,
but these would be good to separate as well.

  # grep memdup_nul /proc/slabinfo | cut -c-25
  memdup_nul-8k          0
  memdup_nul-4k          0
  memdup_nul-2k          0
  memdup_nul-1k          0
  memdup_nul-512        28
  memdup_nul-256         0
  memdup_nul-192        60
  memdup_nul-128        60
  memdup_nul-96         60
  memdup_nul-64        180
  memdup_nul-32        960
  memdup_nul-16       1860
  memdup_nul-8        1980

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <linux-mm@kvack.org>
---
 mm/util.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..419269bb53da 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -34,6 +34,9 @@
 #include "internal.h"
 #include "swap.h"
 
+static kmem_buckets *user_buckets __ro_after_init;
+static kmem_buckets *nul_buckets __ro_after_init;
+
 /**
  * kfree_const - conditionally free memory
  * @x: pointer to the memory
@@ -61,7 +64,7 @@ static __always_inline char *__kmemdup_nul(const char *s, size_t len, gfp_t gfp)
 	char *buf;
 
 	/* '+1' for the NUL terminator */
-	buf = kmalloc_track_caller(len + 1, gfp);
+	buf = kmem_buckets_alloc_track_caller(nul_buckets, len + 1, gfp);
 	if (!buf)
 		return NULL;
 
@@ -195,15 +198,14 @@ char *kmemdup_nul(const char *s, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL(kmemdup_nul);
 
-static kmem_buckets *user_buckets __ro_after_init;
-
-static int __init init_user_buckets(void)
+static int __init init_buckets(void)
 {
 	user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
+	nul_buckets = kmem_buckets_create("memdup_nul", 0, 0, INT_MAX, NULL);
 
 	return 0;
 }
-subsys_initcall(init_user_buckets);
+subsys_initcall(init_buckets);
 
 /**
  * memdup_user - duplicate memory region from user space
-- 
2.34.1


