Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA27606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RYEs/81m
Received: by kanga.kvack.org (Postfix)
	id DAAEF6B05BB; Thu,  5 Nov 2026 03:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CCC6B05BC; Thu,  5 Nov 2026 03:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99CB6B05BD; Thu,  5 Nov 2026 03:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD0D66B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F2F01A09BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:27 +0000 (UTC)
X-FDA: 85400428974.29.C216E3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABAF9C0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYEs/81m";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YmAcXiBaWqfOLhWA2nJToqTdh1nYnyc3oVXmYHbXeE=;
	b=r+4F3eeenShV7WKp+hp8ScaiG6gDPo4UPIH8myuu9+Xpy/mgMIW9zWNUxPOHyLP33sNfLI
	B4rpUX0PbdomYEruyXvpbQNDQLVI6bDm91ob/qCQcykZMjBc9rd7pJ5Vr0Kq/P7Yk7ypya
	9Jlq9QEnQiJ8WAvEDFRIpR+tx1qaI/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868265;
	b=1NJugubALJq6KaEf6ADbDdJkJa1qF+EnOq/HO5AevwayzBKIJA/0RVG6i1oEAj1j5mSpz0
	1/nyssVFFG/Yhwp+mAkP7bekbIas6PtRyv0XwnHmvbgEhujhsPIgDT71x08iPeo8RNaXZn
	uTOAHmDzLrn+wBwfn0xuV7NH2cRqIWk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYEs/81m";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52A6460F1F;
	Thu,  5 Nov 2026 08:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C835B1F00919;
	Thu,  5 Nov 2026 08:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868265;
	bh=4YmAcXiBaWqfOLhWA2nJToqTdh1nYnyc3oVXmYHbXeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RYEs/81mjOtYfXOQwKdLU8fXEGVFlTyyN4Yj+wE+uBaZjCFPQJqP/oYcD+eykzGqv
	 8TG5eFmmmdPF2bd7oJwlf1GcpGfNCmr+J08rWZAYRUkWErJXYFXGQ1EAhVTJmC2S1P
	 v9ASoluWh0GOBa1203l0ubd2XG5zljgQlyJXolhkqpAVVfxeauvhxJcOgg4BDMDyEI
	 /z5ybPmTUUq+w2Xy7Sjvq7QLNU35XPRBH3L5q78m0DozntnRDs1N2UnsYPu8Ho6ku4
	 LOYmHgNc1+jo5zYc3GFtlS2StzzsnzoqFgCoj/4GbOutTKWueCQWHnEPujguCep2/8
	 G0knYIAfQzgjw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:57 +0100
Subject: [PATCH v3 08/10] mm, slab: remove remaining compile-time checks
 for CONFIG_SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-8-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: r94bdb6tmz3cchm97gh6j5dmahhga8dx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ABAF9C0002
X-Rspam-User: 
X-HE-Tag: 1793868265-266404
X-HE-Meta: U2FsdGVkX18Ge3eHn11MLvCBkED2koNYno7HAyMo54QC993R6TVx/0wE0b56FrPkR5Cnlz7+ModsHaU11IzNFvu+SKduiSsso5a8LUsuaBNy0t3aJHLP3kV4N4BEV4xKWinohPOLaVRXSYZOzkzFT4WthrHBu/aKB8sVd3RAt5UudqtFXYTHrZOFScX+aQn8OY9Tuo0WSs5uepxaX0NeLUZwscjq5dH02Z4SYXj4PEFzg7LxEAXGaGq46F++4XHvRPi/NNY9KIbstzGL9/5Zss2Uu9uiB46WA9BCxUO9TXGXfZ69rUgLegcC6HNu8hSnCmb736356n5ZmuxhxUiFDexmb7eDi9orQs93ZntFAK5OeVLU1wOzGxYYE+JpPy5sKCmViSuIbV6pH26pqsf89uITReKagZomGn3Kh0I9qnr9JWzLIzuDQ6483tOUwLJoATYht4xWUyM4lVf4YI3zJocL1pb5yA9T3XNRDtBcZek4yTGPYO1iNgyMRmGG6/qj9z9JzXn1kkcpKK6TFXk6E+3XjjLWZ2AHl52r+T6OxJhYA+AUP0R3MZ/VK8jJy0dMrwN1caw8c3tciJN+e/P3sVNQ+TAMN2YqTSBVl5UpXhDWtEgxrUW3ahDEuJFgNjSksziRVJZG6F0lLmox4QV0HL377TCykx7LXVXz8aHKBdAmuGfnwQWkPIomh6Nx4hLkoFV5e9WsVjz3sK1iR+jh20sORgYAmj5DAxeicmO+TlnW5WS5XEHhWed2MWuO2KkV2/+08QKt48yCsFohUwKD2FRebcVePEtdEXp4w7JUiTXtuHxd6QnotKgCiY/UsHGW1f9rTtDagapydpl2Hq7WBE5qNA3kOvpUJGm4O5bD/0O8/KvEmGgcmpe+e3y4XoCpEOcUWUsxjCw8PSKVTK0bEQBYoR/eY5J1nfT5DjBEdDmTqvB8zN1fwf+xVs5abvZ/q0qRoXmG9Plo/4/mVLg
 OoN+Jg5u
 +ILB6JwN17wb9IAyI9Oj+3loOp2W6l76gQpLbNzyRp3T9aiFNhX5BwsEK5/IYog3HuCqXa1lo+H+VPmxnB+BuPZRHMot/CZf4CudQTPkIRF9qn7J9ctwNwcCVwA3j+DJyIbV+Z/Ylds1abe0cm1o1BlpJsfLcZK9fiKgLq3hPLExgmpNXikvdtSdSXQgNcPVr/R5uW4JWc48JdDVMqnzm5o7/dY1W1ea952pol6mXdQ5Aj6dAXe6hiacugTmOwtPrzivcxYLE2MyC4OjWqepry3teo1mzw6c4+Erect2NqJhlL+YvWJjqyrAM/34X6t0foUj0EOwOpLZyYqYYWNq4oq+Cd9PZ5m/8qMadPvy6uL7zFOGX6UlqZVXR9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove several minor aspect of CONFIG_SLUB_TINY to allow it to be fully
a boot-time decision:

- remove check in cache_has_sheaves(), with no change to functionality
  but only on code elimination

- remove SLAB_SUPPORTS_SYSFS dependency on !CONFIG_SLUB_TINY, thus
  /sys/kernel/slab will exist as long as CONFIG_SYSFS is enabled
  (for now leave SLAB_SUPPORTS_SYSFS around, can be cleaned up later)

- remove the control of __fastpath_inline so it's just a wrapper of
  __always_inline. Leave it also around for documenting the intent, can
  be revisited later.

- remove a comment for SLAB_NO_MERGE as we don't want new checks for
  CONFIG_SLUB_TINY

This leaves the only usage of CONFIG_SLUB_TINY in slab code to set the
value of slab_tiny_enabled around.

net/core/skbuff.c keeps using it to control SLAB_NO_MERGE but that can
be dealt with independently after the config is deprecated.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 2 +-
 mm/slab.h            | 7 +++----
 mm/slub.c            | 4 ----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 930dd64b9ad6..ad645967a3ee 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -188,7 +188,7 @@ enum _slab_flag_bits {
  * - general caches created and used by a subsystem, only when a
  *   (subsystem-specific) debug option is enabled
  * - performance critical caches, should be very rare and consulted with slab
- *   maintainers, and not used together with CONFIG_SLUB_TINY
+ *   maintainers
  */
 #define SLAB_NO_MERGE		__SLAB_FLAG_BIT(_SLAB_NO_MERGE)
 
diff --git a/mm/slab.h b/mm/slab.h
index 7ea057fda751..d39ea67d44f4 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -282,16 +282,15 @@ struct kmem_cache {
 /*
  * Every cache has !NULL s->cpu_sheaves but they may point to the
  * bootstrap_sheaf temporarily during init, or permanently for the boot caches
- * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
+ * and caches with debugging enabled (or all caches with slab_tiny). This
  * helper distinguishes whether cache has real non-bootstrap sheaves.
  */
 static inline bool cache_has_sheaves(struct kmem_cache *s)
 {
-	/* Test CONFIG_SLUB_TINY for code elimination purposes */
-	return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
+	return s->sheaf_capacity;
 }
 
-#if defined(CONFIG_SYSFS) && !defined(CONFIG_SLUB_TINY)
+#ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS 1
 void sysfs_slab_unlink(struct kmem_cache *s);
 void sysfs_slab_release(struct kmem_cache *s);
diff --git a/mm/slub.c b/mm/slub.c
index 1b7626645068..3b1491de5be7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -196,11 +196,7 @@ enum slab_flags {
 	SL_pfmemalloc = PG_active,	/* Historical reasons for this bit */
 };
 
-#ifndef CONFIG_SLUB_TINY
 #define __fastpath_inline __always_inline
-#else
-#define __fastpath_inline
-#endif
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
 

-- 
2.56.0


