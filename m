Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9440DC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 22:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705AE6B0093; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCF46B0098; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7FE6B0095; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6C26B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B976C028D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:22 +0000 (UTC)
X-FDA: 85213817724.08.A0E9FBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93E3C140003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYHbVuIv;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789425140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GXZPrWtCIjbM7MzBizS35UrFZBS63lQ6m5ygI5gZN4=;
	b=EyTGNAXT6Shywg+YVgXsX0t9zb0lVIFp6Afyr1g9uhmxc+9J/kBXZPuwZ+9AvIDsqeADsz
	SegA3g55+QbLHEjPUj7k5rwhnCdKA5OzQ4i7hCE7qFIaWHR6qqBjDlz+O61lTL5ybRqXff
	JjHR22YwwQHx6+Rajm+o3RR4a7kxvk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789425140;
	b=hQ1Adu2lIn+c1Gl6F0L2PHYXGNGHNksS8E3p8tXpBADqExBzEbgeeaimsw11WJYYyLIKdy
	JfJ8NANcWN84YDSOwK9QsUZkt2pWPYrWagUPCjYkTuN3yCLxtyE0PRgW+z0+7tWuCmtBBn
	DcE+/xQQBpbFTC1IcRLj5F9XbLVIbH8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYHbVuIv;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE9143A4D;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5021F00893;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789425139;
	bh=3GXZPrWtCIjbM7MzBizS35UrFZBS63lQ6m5ygI5gZN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYHbVuIvpBANoOBSPEKv4Z894y1qDNv39u2mQR4BwX1FRY0/TRyT0RimsmUh4RbPd
	 Lti5s6H+YXVHDVyCidrK4YidWwvUinzMRMRkHg0VIF1uudcW6lght2qsSviRUZn8Zm
	 zBGm8Gosu3tkEeBiYS5+FDJmlrz5JJrz5GUfGq/3bCJdn7QIN4RtOgRCyYM9aTsNW2
	 vdoSnTfRDNBzf/gpS34uNYDDaqtatllMo5EHQPp4Ne6RADmK+BkwDc37RbFJVJU0c/
	 lexiv0GSYMeH0ZT0ABvZl4F1NFN+EAKg0VHiDxu70BqHxJsmB7gwKVz/AqzV94BqKx
	 zhlJEa4SOnnng==
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-hardening@vger.kernel.org
Subject: [PATCH 1/2] mm: Move default_gfp() into gfp_types.h
Date: Mon, 14 Sep 2026 15:32:16 -0700
Message-Id: <20260914223219.901347-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260914223212.i.829-kees@kernel.org>
References: <20260914223212.i.829-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1894; i=kees@kernel.org; h=from:subject; bh=cc1KgfUAzVgKTtRm7QSgi2oe8h4u5bnXQnDl9nlpys0=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkrSj9Gy66X3ffw3tOPNgwW0a1HC59oy1+taxXUiX//0 ehkgrN2RykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwERUWhj+xzFGvQyQjN0Y6PAr 8NFkz6PnRFirGGs0/O9OP379teIqNoZ/uj8Pqwp96cn9rV39JO8oY5H9tkDlnKJu9iWZMqem16a zAQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: geejm5x6zufqb3xjdhmguu8p6r6o7q99
X-Rspam-User: 
X-Rspamd-Queue-Id: 93E3C140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789425140-895804
X-HE-Meta: U2FsdGVkX1/Xoe4Q35a570lm68kQkOI5KPWHzbJrG5r4QWfkxza0qMR3ZUhgUHafTx/sqE5dEiDlNDHf3Xxv4cYLd+Ac2goH6pWEKLRLAzxkrFbbzCHxAgVnPP49rt9LWTqn80JYxzmZOo/p8VTClDgPD7iHtl03XBbXQfwr3Fw/+cSgy3Ug0kncx8QT/1R6YAGAIHHNlTw11mtstuOr4BWuzJaZxk5PbzQvd6FxhSJ80kzqt/Dr1VFnMhAVWNIe3SwSAwbmfmfXCBkdeRHX2kK7HO3vW8CY1FEbL5J35XDXWD317nFIZAjssemSOH4L9CDPl7vCI8QDaVp2igIgeKHtjPHGtsfwdSAELFGnf+hfzia2LmM/SnuiAml/8TmmUe+OmCctKNFzbta2A/xxkznYN7BbJI5FTT5YJ/668JbVbl1CfuMscaHR9EfCpwAt7eu2kQOFi/zCPO+XP+g8B6LhDtAyk34pqHPgp19w1VZsgRQNk09ycHm7+mofnsL+ONxy/kxtmmNow24EfQbdyUCatbWJex87J+Iz/Mxsj/GkxfK1d3GSYUi4r2M8T23/tQqBZC5WWtqg5SlebOcea/lCPp/DELaNQYLs80s9Kh6JyzTyS4ISOzQxa9o0vzNFR1TUokiid5UTcGM4bnk1D61RfCJddk8WAcI/DaGkREdPpKe1fBcOQMxaNdxRL0/l4DHmCghKx7vpT4acQYLoMZvnOU+qleTmcopq4O26+4xAI8ZtdwxiSR4KwcsMUxkDvdHdEqQ3G3tE34Ok1A43r0aTeUp0It8RwXaOXS1KnlNANwG1aTXmUBIHc2os7b1O3pQFRuLEMWqeBAEwSgRJMbB+yXG+9x3bSuOGmza/DNwogM+P3t8Dj9+YDc21xh1Z8XO/Zl40rmg/I+UwiymqdHSBNSqL5rchvafLukURdHZy1qN6NHksOMtCLXCya9BqmozY/wz2UAGvRFSRy8n
 Fn3V4fNW
 MeUj/6tZyO3HFcG7+ip5VZp3wzC0ap5t+M9ne+TxgjaKc6d/qFHpydJx3+SHHXXo6fgjwsp+4tJJWypYHaS5eVXf5kFo2jYKcuqLzYkJLoFzFUzWoihD5Lr5kEubGh/fktDbDcizmVUi3uJTU0dUj0/OYQb9KYXf2LRi68+UGTwOhGnmGgRDtpkIXzmtRyVGxXAbEFaGdxcV3oO2irCoDa0EWqHecjfbQ6mvdVVJmchgTaA7yKoeMn1b/d5r3f1YcN77UPXYnUXeqbkAY4h74f0Wy/HzRMql843BX6l1JjAxJHK9xIkg9zqczcaIV+z8vVWEVlH57cjYsHZmFaNjB3exmNoZ4PxZEmWKH4zyHR+O0Eq91ZQA1qdNbobN6KqzF3XmgoeGAV+0102UvPlu3SlCRv1zlu7TkEA61UE5frsEniFnr60S8E2YC6ca3RE+Ly2mQCH2YKx4fdu4oOGCv6E/dq1m0PDUoAX6//XdpSSubKN0fXW7Ay8lVo9s3iv2vXnn3ys+G0PilltHlWU5L8ktj1QuzaIqKC536gE2iMkLwX2NLG7jQnn8njh1JkwSfAoGu2NjF0fu4Wb6eA/CiDIvCOqtV9RUqCVV3Jya8z3ZE5vptqvLPvddmGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using default_gfp() only depends on the GFP_KERNEL value. Move
default_gfp() into gfp_types.h so that future use in devres.h doesn't
require pulling in all of gfp.h.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>
---
 include/linux/gfp.h       | 4 ----
 include/linux/gfp_types.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec..b62e2fd53cb4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -13,10 +13,6 @@
 struct vm_area_struct;
 struct mempolicy;
 
-/* Helper macro to avoid gfp flags if they are the default one */
-#define __default_gfp(a,b,...) b
-#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
-
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 190191411009..b1cd143f3c42 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -382,4 +382,8 @@ enum {
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
 
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,b,...) b
+#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
+
 #endif /* __LINUX_GFP_TYPES_H */
-- 
2.34.1


