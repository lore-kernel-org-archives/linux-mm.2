Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE74606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ouaut5bC
Received: by kanga.kvack.org (Postfix)
	id 9E1A76B0116; Mon, 19 Oct 2026 23:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992BE6B0125; Mon, 19 Oct 2026 23:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881726B0128; Mon, 19 Oct 2026 23:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63F6A6B0116
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:31:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB5F3A08F5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:31:39 +0000 (UTC)
X-FDA: 85341579918.26.F4EDB41
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78E4B100008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:31:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ouaut5bC;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792467098;
	b=daERH/Qjqe9Fqlc9BA0D3/WABNkmaT5/ImntnRZL4Bkapsh27OlBlmw8KnrAMIBK1z3L9m
	8eRy30hxPZKZ/RtT54LXzNRe9Z8ZTZ4hGbbkwKf7Xa1j0lbCiY6nD7AvmZumg0Fe9UphF8
	zf+s8yLw69G4mDOpbv+zAoEWKBAkLL8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ouaut5bC;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792467098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yv6JJB6tZhhZV1nSU3fcdt/mKNMeJa2jTIPXvKYZGgc=;
	b=tBP3P7tnbfe6/1YUK74pe/7ygmzwlpHexE3RbP1IJ0hIDcm0T11ZhG6UY8DHlbveaoE6Oz
	WiG1kH9Z9bG8EYGGqTqvfrv6S7D/KsHAqIfB8ghXjgGk2tI+Wu24wfgagdSPuBRZlppoyy
	j7Ben81lgJ3gr9ugfoA7MwaCrz6vQ6Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Yv6JJB6tZhhZV1nSU3fcdt/mKNMeJa2jTIPXvKYZGgc=; b=ouaut5bCYulu7dkPMg285SPBnU
	fyebWZUA93QjEHKGvABxSHeZsHnp22jhD9Xso+RnBtzuTkQRtJ/JYXWzLKvSoUzuj1M9/1QoMLx1v
	T+bFqiBUJ2mNgRJZ2CO+9y9NRzcW61ZDZGlrrJUMICWjT3VD1mN9zb8jAuX+LY+wy8IEZfkEZ0fMO
	zZA8Zho4ez58fHNACfzkELlnyVl229/Xn6tkRvcRo02ifb3SVA5R5UzoF8oB+4u3ANU3JkwNgxfOJ
	4PMz97VWeFw2oqcsJywSPGqW7jYo+LpLNS2zoyAIb3O9xjRYHyRY2BeMjnuy4jPS5UHTcLa5hu2Ju
	LK4Hd+OA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xJ0Zb-00000008nPT-3Dm1;
	Tue, 20 Oct 2026 03:31:35 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH] tools/testing/shared: catch a failed posix_memalign()
Date: Mon, 19 Oct 2026 23:31:28 -0400
Message-ID: <20261020033128.1934349-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 78E4B100008
X-Stat-Signature: neuu5dcwye7zryguxgyztqdzqyhx3eg8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792467097-905459
X-HE-Meta: U2FsdGVkX1+7KWsmsPJX2TEvyLsmHXecHgeGG4gQK5SJt7SnWbNl+52hASkd+voQ6UiOEXiHOT6VcHksdEpvTFxU38agedIjbJnTnLbvLj4MeEBkGc7DwV/18UB2t0m02vsJ6YabJfS42S5oZYzlOzFssXgZilLtE1mYxVknWDRmZw08NmdCcFN0JurtQujVUxE3bpwCebb43qBqaM0Jtwvpf2TKex473srwMz/xCIoPod8SwzTdn7gKIYug0s0ZzrjuSmaZHh3e6kzsnCAwrutMZJ6lxI86EkqEFwDx5imWsq5k3Rg/HOyQOwxPq8xMbmPO418RDdHh1dBkmWG1Djstam6ZIb9MGey9zypNCsRkIJ4FMHO5zavmPXvA/yMmnuJLAfwiSPxMVJ10oW/GmpDy02RgDyzM60jjaQnkB17Ib5GBje74Jr/xkDTB06g++9GaqrWgfNJzKm/Z4c978kMC+j5DhJ3w86oCd/Vgey5V8ADS6F+4hZW7Vcg2yQ8/EgqAvrOTVrKFGJIOd0/lGXoHnVPIShaDr9QwQ8UrUz0krUSuVp8E3B3ry4MadeG4eRzRXUIfxdcN+3VOejFluSWT5a3rdY/TI88+VhDJofkJ9KBFdu3Nsmn07gsdYEt0RHVAou/mCAQz9mglAu3Z/f2ZQJwa2RDeKm9McdVhW1NAGsU4ZuJ6d6AIB816aT4hhwCJuKlXwlF986z/rZj+QVZVVcmgkBjswM+efongxQ+qJ2zU5C6hC4p/II246rcP2fEmvDYy+F+L2W952uHt0Ug31TiokYjySgh3MY12jrGUgbToLzBoE5my+9+xrwKZYING6zJ62VmlJSFaHwYzTCuLMXExiUkn7YSgwOaNNPou1w0dh+AnPDPcL+0pWl9THauzaCbHvJ4wV+c6IPBL+VwOkLcggUC/AgdbNOEEIlYcEjAawyPN0pk+yPpkZpmbVMo4AaIh+ClIt9k/ACX
 uUY/etUK
 LN0E68HqwIevQ6A++8/ozJvmTQ3Q2StNkNdQw8GriGGM+xI5SGBEYWsqFAnWleEhC0G4kuWM5AsPGC3QyjglSQUePu7rW9+/FJ4ZQi1qMOyGjSrzBQC0fxITG3Q/4ArXzNf72TlSBxdrf5KwWf2phys2Q6goRLT/SXmOLi7lFoLpdkbDM1OLHZq9Y72elwJ3xyh+CnxZ6jb6oTbyzcxhMvIkAhAO0BQA8w8WOV3wEi9nNTRnc6JFX5T7AJUuZttYH19G53iNk2NrOl+FNKcrEO7fs8lUqmHT563oPbw6Kfoiytrh42UcrBPvGif482E0EKtjMaq+iMDnuXZuEg76SIHoZjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

posix_memalign() returns zero or a positive error number and never sets
errno, so the checks for a negative return in kmem_cache_alloc_lru() and
kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
carries on with the pointer unset, into the constructor or the memset().

Test for any non-zero return.

Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 tools/testing/shared/linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index e0a0693df08f5..a37d2f86d3254 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		if (cachep->align) {
-			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
+			if (posix_memalign(&p, cachep->align, cachep->size))
 				return NULL;
 		} else {
 			p = malloc(cachep->size);
@@ -191,7 +191,7 @@ bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 
 			if (cachep->align) {
 				if (posix_memalign(&p[i], cachep->align,
-					       cachep->size) < 0)
+					       cachep->size))
 					break;
 			} else {
 				p[i] = malloc(cachep->size);
-- 
2.47.3


