Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDFECC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 05:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF946B0088; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6E76B008C; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE276B0092; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E31BF6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:23:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DF6D80429
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:47 +0000 (UTC)
X-FDA: 85320089694.30.DD98238
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 925E81C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWUy0I8g;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791955425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxBlHiyxQnkomrHKRTne2QV8xmS9hT0nspY3XRMEVWo=;
	b=Ab+g0z5+uMxx83vJA7h71Rmeps/MqRkfwKAjWpUS0wsLxkFAT2k/N0iKFis7JDr+i6GpQs
	ERqYfmr7nFTriGSQYd8Em6sIVrYbGwyHoSDAynfpxA/4morBtFFmVU+1uq5WeeT+yWZo1o
	skHq0+aRtiOqKMq4Kpbxg2VUj30img8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791955425;
	b=zYYGE27u5myh4XTJdKdbgs2r+p3LzLl4t54bK1O2m2Fgoo23dCLGkn5klBNrx86A/MHLcx
	M+yCUKg0vQ6lpb1ADiz96dO/5NU6vJVOvceLR8unano5RQ3WslhyVjbSTxPjI5VDfRXJJr
	X7cP2EjHj/lQdziqujkGQI2UTQ3zIS4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWUy0I8g;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C63D941B48;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DF21F00893;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791955424;
	bh=DxBlHiyxQnkomrHKRTne2QV8xmS9hT0nspY3XRMEVWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWUy0I8gBwJ01lFC5f8D/cYm1bdbW2yI/FzyXuxB+3pzt9oM66mFIJ5e6UiSXZeMo
	 4Sb4jUgOj2T2AgOJ6Qih6viuw5ZTYFE/5y5uEzZhbOoEWUF9QgGtdXwX4soNLWfLa3
	 HeyfX77CbeMA23wlnNkuL/aDuSggp6vaHISVA5GOyCF8OPstcbz0aktvCAQz2G07r7
	 /F8V4al0bUpfEwcIxKjWWDRSjzJqh4FVAf6oayzDqGF8NjJhPaL8F0bL4IynXd+iLD
	 Nwj1adxN5pJ9ugR+F/NH+dG0GQx7ZZGGbjxkaITQMHHgSP5EKWu2g7qpzf7gTIVP/M
	 zyjfvjqLBodgA==
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/2] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Tue, 13 Oct 2026 22:23:42 -0700
Message-ID: <20261014052344.384723-1-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014052338.nothing.279-kees@kernel.org>
References: <20261014052338.nothing.279-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804; i=kees@kernel.org; h=from:subject; bh=KqfbVCq/uttC9NZZEzuvqGaEBpfsS3q5IX9Y3dwx7Uw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFnnBe9Z/lrYtMzAcEuVwirV1MU7PM45LuhYaqqjGPf+z +TklpkiHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABMRnMjwv2yFzfbQ1Wc+iPPp vMq97b1ky60wp8T0LUdn+sqr+q5yvc7IcI59S6PgHfHZf/UbFq/vVWe4W33s6xSR9qnFTxoPlPx S5gIA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 925E81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wa4c9w1tgnpdhpjgaycep74f5t7c5bfk
X-HE-Tag: 1791955425-318226
X-HE-Meta: U2FsdGVkX18YdoHjGrEw1ECRdIUj1z/ZtvoyGWHeqHRPNBdJQ/hLa88lAXSvqDvtk05ir3Eao52EiNNefltrRgS53h8etmaWn/FUqaXBNsdzMp05qqJ+IKDZqojRbsNjjIIS15tNjgINcKVpyrqiEjlIb/fQDTkeotICdbf4lWBRZCnF62wCeq7S1BvgWLwwoANg5bC/+VstPggQCvwkGheMABADF4SM/tCp5m+YP37JUMzvkj0FXPbIKVP5w0U79O1HiVXuHdto6rRbwK2OtkKABjlyuQAmzz7gEi36Iwl3LKitVq0w48zzkrrkPOTGCk2uGAYwGcb9o3AwPzsxXmtqUvQSeiWykbZUgGyl0yl8kD0zhqMuYIRqiphd22P62QhlYQYkFUCHoGcusOdeO0a8UVFUFQoxTFx3mQHr9ayeQnnN4avIxQRJzkXd+afQp7DSRYFFqUEaOW1jsv8v/OcKw29ZLkon+0zYnCGow4vYaFSZpGpcXuQFo0QTiWNSCSSWRbmjJIIb6sFCp1RzuGjpAJhVNO7NDn/Scd2l97vJGfCY5NwNj+WvShd9dgb4pXTEZAUVituxr3LB9da8TPKpxfHjco51UzGAnVLV7d3sFZ7lx2HdERfYwuCZP242PPbM6MBuKlA1W/efl1aH7/0otY4HlOWxnhBCVL7QSJsLsBxP0Rqc4YbyEPNuCM9Bpx+aFYat73XNHlqCaMiosw38oPi5wYhEsJdNWPwwS9CZf/53PyuZf/X1KQnC8uuBwsV/KUGSmxIeB/tEIY13IIGRixZgxIba8tlXkAVyBzv/KFVdrsTlwKtm3tH6AeR+VSRupaUG2sKvwyx85lYxb1kWU8gvxl7qrD/R79jB4k0NcIyOk3q+DOjA4qHE/7vODsnistPhlRG/TaoN0UdWNGe3zvEYXmsqWwHHvjzU5I1GExCkBx0xhi7XqWhm/FUbnq8fjcP78cwkZ82Y8PR
 TI97HrB9
 9Z129KtHbtbOaPoGry+RVwvidDogHfx/IKh1A5kvrkbwmSWrrmC7hcjQNvUm/zp44YUVdV53t+GXnsuQ/xcmefAVWiVFjZ2Q3dW7jPSMmsQF0ggh0kPdf772hJW3nQkeY+WHd6M84n8pmP5m9fIMNLqDJNHiQ8sWOAr7OCsCcXLqGtKCm9NRmq5imnKalTTnKBGCHJSTm5IsiIP7xcZxjXBps0066jbVCeX7Ai9RiCjAgdWYBkOqMdewws/9oXItmSKcp7p0N+MA/QaNDEZs8EnysqIjIl8mwUFWrqX8IzuW1VcWvPwq8bMUDfR2MB/ZsbGYgydncCkuSeAto2L0i4sAALJ1/R82zGL2DxgPl+wg41QGb5NThZMA3h4teMgck/S2208VMPiA5ME7aQbkZSJSkVXIKgnteV5jpOIadTMAYLpieAIY6AckwKA==
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
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
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
2.55.0


