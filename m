Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1368DC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E036B0092; Sat,  1 Aug 2026 08:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE0C6B0093; Sat,  1 Aug 2026 08:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5EF6B0095; Sat,  1 Aug 2026 08:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA95B6B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:25:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33051A02C7
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:48 +0000 (UTC)
X-FDA: 85052621976.15.E1A7A23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A027C0005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RzOwbCuD;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCy5bIVtYQxaWyXI8Dl7cmjAZ6Z+ut7Uf+oQ6OT3GMU=;
	b=q+t8xLtcSgH5TlkBCNin+Y83CWGHuSYJjxcxTY05uHLZOCioP6LS01s2ACW3gmHM0SRDHW
	7QXqhrMhN/FaUWKztfBX8HbbQf1lOsUXRrbV0kcW8ynBPb1eYFI7n6myEs0kRodJP1YdRi
	MIyUHDYQt+WmpTE97tLAIEfCrZwmhO0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587146;
	b=5FX6Tiy4RYTwzopGiIQUscOg2+DLzkw04Oo1+sGdQ+a5u4wdZXIO3+lZDHXCw8cQ8UiV6S
	mW53sGF1omhV86dTcaLbXt0Rd6GYJBMtaK+UxC9wwEaQ4504VS3R7a/gyskqsI4JldaScP
	VCBSw4JdEc6MGZEUNJstuW61JQIsSTc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RzOwbCuD;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B25EE4330B;
	Sat,  1 Aug 2026 12:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD8B1F00AC4;
	Sat,  1 Aug 2026 12:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785587145;
	bh=oCy5bIVtYQxaWyXI8Dl7cmjAZ6Z+ut7Uf+oQ6OT3GMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzOwbCuDSnCP913cQqRNIX5YpQ1FBuMuir92WwGtgL2MMHMBN03zq19hltowL6rTo
	 2coSPOwO4F21Ey6kPAMSl6fmWglrpAk+lgK0JbL59Um9Y4lVwHAV1Lc0AF1gNrAWyX
	 J9EWAoZ/I3YVkXendqI1gGoXLn5b2u3dziNG6zH/b+FgVJkrzT8RITz9xRHDJp3wWH
	 0Oas6siKzXp7RMUbZiwu1AoAk9VMC6cnIaYi8PB86UtY30gb3Ketia+sWgcx2GriiU
	 v5m86ov0+kx8KxnICb8rXPxAjsq9ehQ0MkzTm1dlcU8++KvszyjJSlDkGsF1kpl4W4
	 bLHkmhAwfOnLw==
From: Harry Yoo <harry@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [7.1.y 2/3] lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
Date: Sat,  1 Aug 2026 12:25:32 +0000
Message-ID: <20260801122533.319272-3-harry@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801122533.319272-1-harry@kernel.org>
References: <20260801122533.319272-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A027C0005
X-Stat-Signature: 9i4w3n6ei5cmtaq3b4ty6swf3j7mg1ju
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785587146-414290
X-HE-Meta: U2FsdGVkX1/HwcZO0XMwAxyftQuDstgnREc+fCmA0G98bERkzWDiFfaDNay0dpWkJBRGTC9LBRMa8wWncvBspPRIYgcAUSdJE7nhQGiz7KdSyJoFC6HaG2YxkXC8cU+8bU7SEurlQE3NU35YyhVj+nJnUtqTWp8F61TD9vGquwXqZ0ce1+WqY01+iy6rWGDIegNuDmvyaVqwbdssP4+aJ/9l+/9aIC0TOPGV+IA8L39CEWh5p/wTHbxZ0pRCRtlnlr80c1v0sLOR10CBz0DkPLIg9ueH3pB/T6xyhdDbI0vMDtEcoD3RkJeVfPiXBGO5QtvO+h8vH343anAmOIBEmSSQhpLd5W912tFE2jp7AaIpZ5MjzQUxvYCmOJCFbP5WBYfTa4EZJQj+duhPJfF2n96eLmE62tE9BWdw5HAND5GKsoSwuHeXiXqJHFssxHfXT+dIZuwZQ2IWoFz4Cpuzv6p37pkeG0WqBzT5cQ1oui6kbolAk34lYKA3+YigOSnt0O+Rt1zAwjGIjr8G7cqgxOr1FZU9RAVjv++SvciasPW+Ji5Y7cvZNQuba9Q88y4+xRhnnRdoNLtoeyp9dm1jmMnYoX30f6PqOsFi7qee+dmibgwRpjjczO3I8PG6ch8DSKjPE6+U5e47GxqprEXha4lmUr4E1pC2MWQZDxjVI0Pi3LtoQjFN8TlpHCu/Q0gOSVw8P2Z72RrtAxHKWdpFJtZzRbuaIfrh9Zv+cjSXgzAyVYJRkrWWrK0LG9at1aLc2Si2wrgnVkvkf8z3AhIqXfb/7mvhZ1bVMPtLo04U/zy7HA8YcqEqgxQKjf3mnNBe3suIuBGxm/gllTrExesyOaQhz+u/VgNGxEneKlhAojjlXmjZCr41d0HjjU1fHInmb4eZEReOCLsLqnndCUgw4yh1qCvspsdgGCmCfZ7mOYAEytgUXyD4a9mdF5B/hXo2QnjnRV2E2InT00q2Xrq
 FNl4GGPM
 BxBiPRCHMbC5p1nzEkfDdckIsxDqGO/Br1Bhpj+/NvWx+KO1MHn5Tpr/KhWW75iwMlqlC9bH3KZUePKfNFynjhiM0bn7NalMTfNMcciXl9htbkCVFHD4cAMz3YzHXYmc9AfZ7Kzxm0du569/CoDQNs5pNgNEP2Q1an7UAzsLyV6b7EASqwSqiULqkgwDzdXdq55TObVCCvziiNQIClE/Vj/Qt3GcP8JkHRyiBcQTdVm63FSx+zOmO7m0KogXPD1rUAcVx92KVNRQ2RCrCjFZg7ImzXhvBfE8O69Slb0DGlAvb8Arq9xNgUTGPhnWl0r4yluSl4P01NOmzQP97eKU7F+mgeSoi66xn6x8o67bS4mCdb79oh4u9cQGHWorIhu4PVswN+BOfdVV7BI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Harry Yoo (Oracle)" <harry@kernel.org>

commit a37b0066a10aabf3c968b4566706fb866eaf9a85 upstream.

mem_alloc_profiling_enabled() tells whether memalloc profiling is
currently enabled. However, even when this function returns false,
it can be enabled later.

However, this is not enough. Some optimizations can be applied only when
memalloc profiling is permanently disabled. For example, to skip the
creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
be set to "never", "0" w/ debugging on, or have been shutdown so that
it can no longer be enabled.

Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..7e7cdc7612be 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index a9ab88f416b9..e3a923594604 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -26,6 +26,15 @@ static bool mem_profiling_support = true;
 static bool mem_profiling_support;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static struct codetag_type *alloc_tag_cttype;
 
 #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
-- 
2.53.0


