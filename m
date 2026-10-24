Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125E7606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5+j7Xj2
Received: by kanga.kvack.org (Postfix)
	id 98A056B05B7; Sat, 24 Oct 2026 15:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961986B05B8; Sat, 24 Oct 2026 15:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EA46B05B9; Sat, 24 Oct 2026 15:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61FE06B05B7
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01D9F1C3C33
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:53 +0000 (UTC)
X-FDA: 85358454468.19.E7479F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41ED1140004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5+j7Xj2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YmAcXiBaWqfOLhWA2nJToqTdh1nYnyc3oVXmYHbXeE=;
	b=YjO99E4tbY4vwg9l3tw3X3QWJIXI0Xdp6KJRpPEOYzIpS9TMXQ8BpM0iJXybEW7mVoNFZW
	cPBEWIeGc9ThvUNc67gqBB17Y4g7tdT3AmJkj0HT20Jl2vyRvgojOKMH1w8OF0NpZUM16w
	qFAd1m9M7ISLpj8t+qWUBIms+nomVX8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5+j7Xj2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868872;
	b=xiSFho4hgtBLVwuuzTP6PtD+4uvz7KB479d5DrwZq6EV8CGHiRMjSA0IffN8dwx08e85kA
	WiMawbxIbAn2w+irmLg9GQyUsQXXFDBVtaWmMaBJ4tHIhFOGDvuaPDh0Xctb8wYu2Jf5j/
	QXWfBlSpO9cm2FdTiJ58djcM1JFE3eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9962843A39;
	Sat, 24 Oct 2026 19:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFEE1F01825;
	Sat, 24 Oct 2026 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868871;
	bh=4YmAcXiBaWqfOLhWA2nJToqTdh1nYnyc3oVXmYHbXeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K5+j7Xj25HIXGzg7/iQguAnUBMMOcuHPdhdf+nNSJOyXNAYlBSHVibaRGI5iiNx/f
	 gMTwCF3z0EnWcC3ETbdEF3NJBDDJlF/viK7AHXpvXT9vkyXXT5mBoH2+i/y+Y0O0W7
	 inh4I5HLcV2U+9nE4+UFdAvMstCxCbGBG2qVzASyydkKg7jzEyjqUNfgAORorHdq2B
	 3mR34mx+1Slngsfam6myq0OEBXRiO3UNdEDpJTq+hWLjDJuiLMU2HFTXVRR1gjzPTF
	 NYR6oDSKzA98Pv+pxwrapdXVRTa3LPe4FTm8INTEMVf8RrVTonmeokEQzShFxX6GK0
	 IeAkRO8ll/FLg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:28 +0200
Subject: [PATCH RFC v2 6/8] mm, slab: remove remaining compile-time checks
 for CONFIG_SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-6-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 41ED1140004
X-Stat-Signature: aotk9rosqio1fx3jindg5iysuf74a7bx
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792868872-959723
X-HE-Meta: U2FsdGVkX1/+VP/EHoAxrZ0GJue+wJJPMWFD3H9g/wpdoCMpHt+StATPeeVSLOBOItp/GUUI6SuTM6OVq++ozm77DZgPrjegno8VLjjzYqix2dRkCkx67a4D/q9O59etUURmBcDcOstptbJeBL45xXxy9pmg5LLBI1r1R27tvMQL1w0SZiSwB+RyZWbHemyJIBByR/4lMhvRGatUdJotltRRXSj30hgL06BFkl1dgqA5tqoZUIrKygSX24VHDkOEZWZRjWseUg4gS5OI35w07mem7E8vAZA2YmQyXbh3VPM0WL1GabQmej0CJG1oeyLu2SJU1dKDje3hTye2xWWKKsyJ2y434RU+QFyxTMxMXDCoxWPTrUSXHtoMdK4wOZoaWGQ0DftbWsU10AdCNTZqn824y6Ex6M43JuiO4peKaNYTjoSLAcmhx0rTd+gG3U7em0Hx6Iq6/2Bs2HFDprah9XuNbZqgbBWODVFpEoCnVfWOf93MBo047VYHhOPmJm9d+iG1pldHhugibzUCv7GteqkQKgprKgqRcATGTYjRSo8VORo854j1+RQJCCvYyNmpK262Nc6JtAUy6xaUovmh7xFp9whPRhbBHWsCtlun2inseQA81w+jx+KivXe9RLyawy+hfc+XJBTvCivGzJ+BjTDPM/WIjvjdCO3w1Wz1cC+o5HenX0tiYZLnPkpwJs7ZjTLjegiwrwCY1nwF+zUFuSubRhZET6SjF27Bj7IagM8LAW48Q6z2cWRg16Wxt5hXTflt2D8bI+Z+/VfYbJjXnwu8FXrCj71R/x62wdrJf37w9KVG0SOWYRAU48W0ZV0YlHszA0f461OBVc/eirmJt4LD32JVX48QdJDlGc++8WRNH98vsQCHyIqgXeGyksg2zuNYnLdEjtZunJfK0GsSjfYdWrw1A5S5+TVHkw72/ZojpJN/dneH89AyYlG+0Oq/UZ3j9ykxsYYs3Js2rpO
 BD/pGrbF
 O2S0Np2v61lkpB0Sr6R9ySeaRrEtWmM0ZDSopqXD5KMujECEtqCQJxtRdmM7h2J84U6gkF8z/YansStgU1XAHMuvKzYhaR9yIOwREuzz+BuF9q5BeBcvtoR+gDsvTGspundU+j35i03lo29GEqbkt/B7saaw6uB7vOgsGa9OUPh5cv3xJNw+m1jcq2x1g6gOyLk2po61TZ9h6XIwxok10MKBpgH6NExsfwP7VuJACWCuZXwny4zxtGGQutNGPpRYFAmFGMnloCy/RIazEJ4jncNlhJcIoAEgRDaOP
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


