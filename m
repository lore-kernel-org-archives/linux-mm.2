Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31B2C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC906B00AB; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383866B00D9; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2999F6B00DD; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 082BF6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 422C71205E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
X-FDA: 85237016886.29.06AB047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8265320005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouHcHhEn;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXEMn8PYoauzMFPqYoyRVQk4fKHRKQ7Pm/+2eUzLBwM=;
	b=Emh0Vk+f0gC7FJ6hLnQnjQ6E1LU/+LRrP671/mmTboo0iqLww0h5WR2jkOhVFSzoKA4Abv
	0haHN4+sziP5ngC2SG+J5kPFHc/WOtYN39caiN7ijuO4n1yhcciVmHxfgRTdv7XDVgdrXv
	xVcpAl2yV2d564GJmApMG7bV8kqbElU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouHcHhEn;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977501;
	b=d3Ignd82tC3co48gXPSocVO+fFW/OOoq1M1ipiin7Q3/9HQuexuXkan9D4c+2H+wxIFEdr
	Dr9HIFWgrycy64FYMgvJFCHk3PYX2o2qE4Fy5FEwQv/EaotV8GYm6KBruryKq2pNbOr3H/
	3ZGtW8FnwBhb3DREbOel9yxeVQYWy/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC97343F85;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CCD1F00899;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=pXEMn8PYoauzMFPqYoyRVQk4fKHRKQ7Pm/+2eUzLBwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouHcHhEn3pF1QVHo3Sbazx3hPddkjUOD89SP/L9S0cHcaBKN2+A2Rc4sof5g++TcQ
	 xtgz9khnxu5eYU8LtTPSz1IosPFoOjs+erMVMkRaMkgks9irTWcn9stk6CP7gumuCk
	 DJMrd6hgPkrecnH+TQc4md2wYTvbjgzAjf/msUVgslIx30KHvAaMgb0nL1T3yxYO+9
	 rhYDqZVAMMXUB6bvKscdjGIkzXR4ua6fInw4hqN+PihF+6ynX/64IwcuwerJAFXS8W
	 3B8xV+zqDVo9H+bPTMTAp1EoUJe21NyRn8mrY5coc0C6iWF7Bnn/8P941Pr9nTLZpF
	 isN880f4ZFbIQ==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v4 1/7] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Mon, 21 Sep 2026 00:58:12 -0700
Message-Id: <20260921075820.1718334-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2066; i=kees@kernel.org; h=from:subject; bh=yoNf68AxG5w4U/BVM+cYoBMu5dGzeo9HzcEeFRFwN4A=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs+w2O1WFJVu0y0uMin1v8cLsWNM4fPnBuyPdni3Q 2Jp/+v1HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABNJ0GX4H3HjgaPAG2lOySjz D/KnFzll2SyvEQpcP3l65wyFVUsSJBgZ7mxoXb/3/x2WcLHVPIdkHWcafppsOI3vgHNYcW38MU5 /FgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: irgh8qfkp93wyym4q5endfx6cbtahdnt
X-Rspamd-Queue-Id: 8265320005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789977501-830512
X-HE-Meta: U2FsdGVkX194THwHki+akuptqtKn0KqM8XBhEhCoiJRZ+VN8M6zAWjjJcM5k2m8erZDXDfa/KY+LlmyFGBdPf6xaKyTt1Guc/OmXrLB+Le2lYcVrOoBiF/q7QW2UuNmO51MjvZVoi287/g6UHU+HzCV4p5TcbLKlwfLLjnxgS5E3f1JNy2XclowBIKyz2juP/prJLSAjuIDfKsAAF/1wtbVGzszP44woenAP/e+lvwv3Dbi7Dt+tLakTcJuDi1fDOnrScpDtxAepG/yMTzSq+nMuuklRAv1yMZakc/ZijWzGk/GvTDx4h5+nmdX/IhYMqQ+yrt6SelhtQxSAEVA8L2eyWHzyN3YzTUQu9RiwRQ5Sz0IXgPHtoOGkcPDQBZKX0JpbKxiS08s9saMAzfU6y/YndvpB5Uf4K9+EyRqTcE1UG3xNCm5bhXi6vRL9aZ6V5usQizUzs1fI/FDDJXkPOZOHMzeCUNpE0JxzKfyhPnhHmF2yvpfoSX7he4VDDeorDDDgWsajVUBButesllu2ZgHjnR5mPSDdsj62Vv0kuwslxA3iEZ2cyyvPaprUpMhgNupbT+I8YruRmtmrAM8OvpnQKe5ccAkjLnd6PyIncmhWi7GEcIxn3yaqt5X8+aw5V3GtPDmHjJ2INxE6/La8L5WiGhDW/4o3E36PUYK5P+Hq5bx8Po76sw/lOYy9x/b99hkCIEPPMEFT/HDe7B49q7tHgljzj3h5sa9a5n/0Qm7e4fG3ZC/jsEve5mJws9HC5jtcMvP5y5nar+oqTNr+7PWvQNHavZY218LbBWXFfAXcFAT68OyNn8JJqpGg3DUF5papVSh6pO58PKMZ6OdOO7GA6nVB42oNCHdRutbTZ+/Jw++FToCBvoi1M00M5SuXAC5dvCNjDGn5YNb4qpUPaWbvR4gE6aPR1KBhcN3CUsjAOJv7cRWRVsNfqkbCBrZkpbIR49icul/jqgbXjAa
 XofUU7d2
 YitVqVvXk6TtcV+I6lVTmT4aYOOw3xBDEjdThdUJNPnAUjBZba/LzBYadoWl+LSjKiiC/0kVGa/j3lRlx0E1PLfy2EAKNAgv22pSfD0FSbAOTYEHgeX2TlnfpG9mQoncXCSK1SHQJcNkHDFNEeffu2aAx8AApuwwqHuA0uJQZCSDVyzXDveiKmIsW+w/h+jrze8UbMB8wufIlLIKy8O56Gxau86MTmADQUDUjYuBqoXJEBesPF69dl2+jRJaybbnLYm+9cvHSQ0hl7wMymiuYei3zkq8tGbrZtMY5I1rOWrbETT0aBRJ7g17nsmofRApc3K5AIIREvN5o4SarCZfh5KkoGU25UH8AncUiHMGgTtycrgRS064jcALhaTs40ZbcQnbKI/fIECLF7m2yLlMUQGf1zn2f3ds874dGbXBsXhAYchZlgjW6fvxl+OzHFz021D0IZHGImmrBmF3cm6ZtNfncpHPMsyGBEttLO2/NAv2Yrds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <linux-mm@kvack.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: <linux-hardening@vger.kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..270408ce5a9d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.34.1


