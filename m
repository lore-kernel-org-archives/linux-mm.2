Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD6FD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E5D6B039A; Tue, 20 Jan 2026 04:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11D66B039C; Tue, 20 Jan 2026 04:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E143D6B039D; Tue, 20 Jan 2026 04:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFAE26B039A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:35:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FE491A049A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:35:49 +0000 (UTC)
X-FDA: 84351835218.11.A0B9417
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 093631C000D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:35:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekg534oN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2+eYGi3U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekg534oN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2+eYGi3U;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768901747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ox3I2VUjUiyUeykdR5HqhsLvp9X5YEECxdvDNPMt1f4=;
	b=5ph9y8jV+L54BxDLT/o1YZJRPx0mwirMM9/bFPLGZZbvaS7NPyNOaKompUwEG3JjysqhGT
	Co/GHDWJeFZr6Vc6OwMoAkWmK5hBbo4z2mfmCmds4tbGyNSLzz4FPtrfsAd3NYY426MNCY
	SkuyqeOgf6nNJb+awLUpN96Sm2uGw9U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekg534oN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2+eYGi3U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ekg534oN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2+eYGi3U;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768901747; a=rsa-sha256;
	cv=none;
	b=ANeYs5Z4FMga9gvAQAqvl/gp/j9r1ISaHZf46KlX5GzqXuxNFc/HeS0sCPbDc3leA5OxNR
	W16TcsBxCAgdWzyd9KTVANw1pkwRckfG1OqN8tbueyrRL6Qfu5FIAuKvRZ7Mg6ptvEO5Cf
	GbN2mPqZrbztZsc5+y3pHpv/QPbH83I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C0E05BCCA;
	Tue, 20 Jan 2026 09:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768901745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ox3I2VUjUiyUeykdR5HqhsLvp9X5YEECxdvDNPMt1f4=;
	b=ekg534oNRQ/Er6cRg9OJdDRjzI9L7kXH5IPT9cgllfl7KMrcz1tY0urI/bNGy2j1ezMzVe
	3lcwDKzxk2GHECJUtiiThgktfRajlCtcqA0JmUiTl2xUgbpgNwLziHA6F0GKNQjQ0E4nQJ
	f9BEhPwY6FIB99YyHk9vYxmhbfXFOEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768901745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ox3I2VUjUiyUeykdR5HqhsLvp9X5YEECxdvDNPMt1f4=;
	b=2+eYGi3UPu+RtUafkfoYazRmwm3QkI1+JkL+pLo7cONt6upJY0tYFfvyrBNKDbXE4GnaAD
	vgzYqSVDvKXu4RCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768901745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ox3I2VUjUiyUeykdR5HqhsLvp9X5YEECxdvDNPMt1f4=;
	b=ekg534oNRQ/Er6cRg9OJdDRjzI9L7kXH5IPT9cgllfl7KMrcz1tY0urI/bNGy2j1ezMzVe
	3lcwDKzxk2GHECJUtiiThgktfRajlCtcqA0JmUiTl2xUgbpgNwLziHA6F0GKNQjQ0E4nQJ
	f9BEhPwY6FIB99YyHk9vYxmhbfXFOEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768901745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ox3I2VUjUiyUeykdR5HqhsLvp9X5YEECxdvDNPMt1f4=;
	b=2+eYGi3UPu+RtUafkfoYazRmwm3QkI1+JkL+pLo7cONt6upJY0tYFfvyrBNKDbXE4GnaAD
	vgzYqSVDvKXu4RCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3803E3EA63;
	Tue, 20 Jan 2026 09:35:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BDFXDXFMb2lUOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 09:35:45 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 20 Jan 2026 10:35:42 +0100
Subject: [PATCH] slab: replace cache_from_obj() with inline checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
X-B4-Tracking: v=1; b=H4sIAG1Mb2kC/x3MQQqAIBBA0avErBNUorKrRIjZWBOYMUIE0d2Tl
 m/x/wMZmTDDUD3AeFGmdBSougK/uWNFQUsxaKlbqbQUcyMYY7rQeuc3tIFTtGnehTIyeBdU2/U
 GSn4yBrr/9Ti97wd3v4SiagAAAA==
X-Change-ID: 20260120-b4-remove_cache_from_obj-190fcaf16789
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Eric Dumazet <edumazet@google.com>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4245; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=wC/hB+7f/T66i5Uj1i2nnMj4/Bruw5mYiaCtk5rSOJI=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWTm++StNF00T2zTpZrrwQ+PXJm4sUTkSuZaZt1PezUm/
 5JrD2By6WT0Z2Fg5GCwFFNkqd59wlF0prLHNA/fjzCDWJlApkiLNDAAAQsDX25iXqmRjpGeqbah
 nqGhDpDJwMUpAFP9K4L9r8i0qbFTxVkczp9sumGweK+6h9pipgOSnBUXo9lND59cUdLfJZy87sL
 r5hPrptYnT26cYehc3nMkO2+hSu1xSf40TZXaJ08y7wlN952/xEPmwrdMq9LsSwb7k+dbq3fNd+
 /i+OGe2e30Zcnz1fPl7R8sfqf6OfnLSrnfR4SncSo33VEx//DdiklYytiidoZS19QXD1/xxbHcy
 Xhpp/u//+AWiYYVaqVKGlM/uUyyfv+5xmx7vEj8tLyiD9a10SXeQax9Zkz8x+b9UZjF/7lFQf0v
 7wIPJYPYeY9z2qM3bA+sVpU/tpk3WI//mCLLfvl3G95uNqneZ1ry1n7DrKoU+8I3Mz/kzrQNazr
 uNXkNAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 093631C000D
X-Stat-Signature: ups4s3eane4ntcwtnndpe9zsfezfninu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768901746-211222
X-HE-Meta: U2FsdGVkX1/EsFvABOrKgTcE5REQ5THFW8Jm7uDgOYUnrxMrJb5+WPClD1NKvS1BTu744u6T9Wl1rz6Q7VdfnRf0qw/F0HMDeeiP1dgAzIs+kEqYxNbq2pTYpXkBHlaL/5RNHA6bAUcggX3cay2ttj+TS+UpbOr2COMMYuC8JTqfVyN+F8yuOCGRVoovl8uXXFRr8YWCTLcl9QXClZ8wK0pHsOVOL+7m5pYVw2VFW3qQ1h+iQTEeDtVigXr4Er09cQ9mZy8HdvDC9MygWc8xUJgLx+jsXpZxkCWEF28HRtK+lw13EEZzlykMKJ3OkpH8pae2PS5gWHlrsIvAVX5RDKUVpwXYWLLbw/EgyAB4MLYLlJkrmRSdr3VmGSZcXnC/5jd4atJewc3DN1lXtuYYvEnruU1bcjIXtxwp1XfzKRq1t+a7eZ6zrw7z5yXJqRYiBozoF0kRBO0wEQujYJvUJIM+nhIcB08StUb1UJW6ht+7D0Lqp+PD8Rgbrf2y6mO0T2KaB50PW8Bw0EF5z0VAQLwZ0Yv8/Ku815yiz+n3hr/IQdO3GwJ4lUIc+OAamOIstG8lTxVOR4xYgBLrc4fgAinRBsXM58ig9BAEVd1yPlpsilbNktPeHcPpQpkIGBhkYGIrQoNJUiYc0S3ZJHv8bfmfl+AAQ1C7anx/YfuiXuhpypWWNY3SoyHTfRNQJ8KEfedwngP4MWp2P0nEuhL3vcq+mUlteGU4eAafvWHkGAeknv6IG3ZQVDDodqx3W+W1leMCb68cuzZez0Tu2GB7W6PEQJ4mvgK6wo1AyUDm12E4zyJCZ0q8vglN6aVtSz4kSIYDklS1/XYYloGCfEB8YiNi6JznEEko7E3xe8NAPsi3g2f6sRahB7EVhFUd0dU/BfgRdDRoavWSqpz0bh+lej2lqT+ChfoKxuWaLzhK6VOtfLgSsFibvDZb4OUxYOviHCYZEusCFBjB0n5WyJ3
 ua0PVc1n
 iO00XEz5X5doSt9QSwayTq87UoIaa9MKznSxsG+nEuumNIVN7MMkLp6Ki4Xkbd5/AJYfdkd48y1GfWMVCUjuNs2AJHLIGUjgpri9Zv+uW+4kfzQR+LMB9tXiu1lzaJ8Md4amkRCVNdqnSzBgERZn52K61O7uLAIvzta+Eydi+Vn8u+TVLWZNgPIigw29gmuUtrDhFl4YD1VeOtEZqJoNbUmMwd/wEAoXTCW6GQL0BW1t2lzNbTPgQ9XTfDKIyRiMq0lyBeLDbth6mzPQyjTZFkREHHoqiH5n8iBA+AMnG0yRLeNCScSex3XbI6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eric Dumazet has noticed cache_from_obj() is not inlined with clang and
suggested splitting it into two functions, where the smaller inlined one
assumes the fastpath is !CONFIG_SLAB_FREELIST_HARDENED. However most
distros enable it these days and so this would likely add a function
call to the object free fastpaths.

Instead take a step back and consider that cache_from_obj() is a relict
from when memcgs created their separate kmem_cache copies, as the
outdated comment in build_detached_freelist() reminds us.

Meanwhile hardening/debugging had reused cache_from_obj() to validate
that the freed object really belongs to a slab from the cache we think
we are freeing from.

In build_detached_freelist() simply remove this, because it did not
handle the NULL result from cache_from_obj() failure properly, nor
validate objects (for the NULL slab->slab_cache pointer) when called via
kfree_bulk(). If anyone is motivated to implement it properly, it should
be possible in a similar way to kmem_cache_free().

In kmem_cache_free(), do the hardening/debugging checks directly so they
are inlined by definition and virt_to_slab(obj) is performed just once.
In case they failed, call a newly introduced warn_free_bad_obj() that
performs the warnings outside of the fastpath.

As a result the fastpath should be inlined in all configs and the
warnings are moved away.

Reported-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@google.com/
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 52 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..1bdb4f73d61b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6738,30 +6738,26 @@ void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
 }
 #endif
 
-static inline struct kmem_cache *virt_to_cache(const void *obj)
+static noinline void warn_free_bad_obj(struct kmem_cache *s, void *obj)
 {
+	struct kmem_cache *cachep;
 	struct slab *slab;
 
 	slab = virt_to_slab(obj);
-	if (WARN_ONCE(!slab, "%s: Object is not a Slab page!\n", __func__))
-		return NULL;
-	return slab->slab_cache;
-}
-
-static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
-{
-	struct kmem_cache *cachep;
+	if (WARN_ONCE(!slab,
+			"kmem_cache_free(%s, %p): object is not in a slab page\n",
+			s->name, obj))
+		return;
 
-	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
-		return s;
+	cachep = slab->slab_cache;
 
-	cachep = virt_to_cache(x);
-	if (WARN(cachep && cachep != s,
-		 "%s: Wrong slab cache. %s but object is from %s\n",
-		 __func__, s->name, cachep->name))
-		print_tracking(cachep, x);
-	return cachep;
+	if (WARN_ONCE(cachep != s,
+			"kmem_cache_free(%s, %p): object belongs to different cache %s\n",
+			s->name, obj, cachep ? cachep->name : "(NULL)")) {
+		if (cachep)
+			print_tracking(cachep, obj);
+		return;
+	}
 }
 
 /**
@@ -6774,11 +6770,21 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
  */
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
-	s = cache_from_obj(s, x);
-	if (!s)
-		return;
+	struct slab *slab;
+
+	slab = virt_to_slab(x);
+
+	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
+	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
+
+		if (unlikely(!slab || (slab->slab_cache != s))) {
+			warn_free_bad_obj(s, x);
+			return;
+		}
+	}
+
 	trace_kmem_cache_free(_RET_IP_, x, s);
-	slab_free(s, virt_to_slab(x), x, _RET_IP_);
+	slab_free(s, slab, x, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -7305,7 +7311,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 		df->s = slab->slab_cache;
 	} else {
 		df->slab = slab;
-		df->s = cache_from_obj(s, object); /* Support for memcg */
+		df->s = s;
 	}
 
 	/* Start new detached freelist */

---
base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
change-id: 20260120-b4-remove_cache_from_obj-190fcaf16789

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


