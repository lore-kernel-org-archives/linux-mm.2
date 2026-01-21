Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3B2D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E096B0005; Wed, 21 Jan 2026 01:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3929F6B0088; Wed, 21 Jan 2026 01:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273446B0089; Wed, 21 Jan 2026 01:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12E386B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:57:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAA771A07EF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:57:24 +0000 (UTC)
X-FDA: 84355064808.21.2B605A1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E6FA80007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:57:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cUI9pn3n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LtaYqiOp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cUI9pn3n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LtaYqiOp;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768978642; a=rsa-sha256;
	cv=none;
	b=YJnNotHayxuvSO58eu592HVqrHF5+RuMg7b90NTIC76p+NqAWWZ2XWmzq/xffmf/Y+Yqay
	yBRIBO8aCvarv99Jej9divqjKGp9wbXtgF96ockaEexGpHKsiE7UkAHKlJXd5DQSIJByKj
	fDu2wigeRlUTGqwTcKP/GU35X6fxMRY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cUI9pn3n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LtaYqiOp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cUI9pn3n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LtaYqiOp;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768978642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F2hV8Ptre9CxhtsWmxv63EQlnGTxB6W6LapKB5FH07U=;
	b=qVNv0YlDGyz9W0EiMzzhSaSsNVEeD+VTCwGONfMUsZkow4IjZcaZBvFC2Vp8oFaKrowIQW
	05lPyLHUgR2bX5pod7qR3cgNuvRj+PLO1UohVRuKnJl30VbT4mFVwWOxZo0xME/PL2Yott
	XLlmOX6tP1sngQeBXUVhRx/giedsSh0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3960E5BCCA;
	Wed, 21 Jan 2026 06:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768978640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F2hV8Ptre9CxhtsWmxv63EQlnGTxB6W6LapKB5FH07U=;
	b=cUI9pn3nKjJKaX/2oqP2ioLEjYaq0DnhuStUmV5y9AYoIxb7U4roSXqtM8sP+sB5DndRhk
	JwtLuNGladv3JLqWStebq3cMdLHx+DdQ59gEUACaz9DZBqniQdMo5A3U9uILilAbVbRuJ9
	JpqC1uxCE7ZgCtEydhARfWs9PZ8W4sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768978640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F2hV8Ptre9CxhtsWmxv63EQlnGTxB6W6LapKB5FH07U=;
	b=LtaYqiOpfp6zAANu2TdOQF5I7kziKq8HsDaJLp3WH/jvzXFUeBI8dS5l587mfPdMwwvx1P
	/UwfJrftpuryolDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768978640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F2hV8Ptre9CxhtsWmxv63EQlnGTxB6W6LapKB5FH07U=;
	b=cUI9pn3nKjJKaX/2oqP2ioLEjYaq0DnhuStUmV5y9AYoIxb7U4roSXqtM8sP+sB5DndRhk
	JwtLuNGladv3JLqWStebq3cMdLHx+DdQ59gEUACaz9DZBqniQdMo5A3U9uILilAbVbRuJ9
	JpqC1uxCE7ZgCtEydhARfWs9PZ8W4sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768978640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F2hV8Ptre9CxhtsWmxv63EQlnGTxB6W6LapKB5FH07U=;
	b=LtaYqiOpfp6zAANu2TdOQF5I7kziKq8HsDaJLp3WH/jvzXFUeBI8dS5l587mfPdMwwvx1P
	/UwfJrftpuryolDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2779F3EA63;
	Wed, 21 Jan 2026 06:57:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wiJhCdB4cGl6JQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 06:57:20 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 21 Jan 2026 07:57:10 +0100
Subject: [PATCH v2] slab: replace cache_from_obj() with inline checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-b4-remove_cache_from_obj-v2-1-7213d36b89d5@suse.cz>
X-B4-Tracking: v=1; b=H4sIAMV4cGkC/42NQQ7CIBBFr9LMWgyDTbWuvIdpCB0HwaTFgBK14
 e5iT+DyveS/v0Di6DnBsVkgcvbJh7mC2jRAzsxXFv5SGZRUnUQlxdiKyFPIrMmQY21jmHQYbwJ
 7aclY7PaHHur8Htn615o+D5WdT48Q3+tTxp/9I5pRoDDEO0ktMpM9pWfiLX1gKKV8AXZlhH++A
 AAA
X-Change-ID: 20260120-b4-remove_cache_from_obj-190fcaf16789
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Eric Dumazet <edumazet@google.com>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5211; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=15RYzhWLTEfcvtbEHKriVBTM8eBckeJmwTj2wXFUVKw=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQWVJzJ12rmbxVfrLxpwbkNSV5Kl8ODYouceTp+LJ983
 2JltUdBJ6M/CwMjB4OlmCJL9e4TjqIzlT2mefh+hBnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DA11gEwGLk4BmOoaZQ6GGWUv1ix4ETE/s+/Ci2fnf7xqma98kefc77dP30o8fHLiSc59i0MN/u9
 nvUg79UX7+LG0931syuctf2j87phzZoqUQvP8jYl35u0+wlTVtFyr9S3DLb3Tr2smKRfk2pfHKk
 W+OOduOZdD66Nd6691hwXaHr83LWSKXjuN7fObqIsfewu/mn4J02a7qLF41pGu1O23pI3uuuioh
 p9a9J3x3EGDSZ5C/VxTzwSF5+TpWD3i2jpZXuOntVR5QMa9rGkpKTyTLnMe7o8o7V/zqf4Sk+e1
 lWzlqj2M8720s9vNbyo+EVhgGrU6jfuVabKtzkapF1suC2qWPV4h4CI1wVBz73S5TpMFByqaCnz
 2idkJAAA=
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E6FA80007
X-Stat-Signature: e485m81m939b61kzi817y9of37j6uc6w
X-Rspam-User: 
X-HE-Tag: 1768978641-142591
X-HE-Meta: U2FsdGVkX1/LP9B5tLrJmkiLe78YIX76ooImoXQphQPmNkxWIkdETzKN2FPUs55C8OVA7V2ldHigcFWsQxqYr2k1F9OIbdv7LLQ3hsNRTQQTouogkcWbu90XIUFSBxnByRT3k6lYh/x7c1BlS3QrDbJwEZeHe9YJtisoK3Zh7K0hEN9us2DE9QueUsYmGEL/bG463GCjTO3D5uEGLRpSwH+DKOn6kccdiTbV0NoPja3hQF26cYUhYEiR2rDlqJUB3vHWE3AcMqMuW75di2lUp0GubvTs+yYluypJ2d8R7jPsoqlaPgLUCKh6nJEu/TrImuBs2WaxCgYVU2XyjP91mwBBAV/EVZH7PNFowe6Qm4mLcHEPYmCrhEzBeUoHoDT7rvXU7DEFKPSj7Llyu79ZTIUlB1uhZMoTyIP3pob7bc4edSPw2es+QCQyhEVLAHSmPHHNH85FXb+QGanQKW4otwT4/f1S4wWvHykYX15DeuHTyER7nUX7xEQgAdCoZprI940jWJiv9C1OxrZ5wxFuq0Uswo4dpvAYxIOLe3avYiYd7g/l3/48VHP3GV4d8Ovl0/fItUB/bPK3lR+8uznwgsOvsamO5AKD0HXtugqHINzYSYzgIVTRb8Xjoa0tzRnWG2dD8Aaa+atv0/mjYfOIOkPapgL1IAjgnIkaRimjrmWbKP0APXWoKNShFyk7SOGiAU7von3Ff1gRYW2z72V1JwMVxyDF9ymUmkrv92CM2oQ67bgMWw4X588KM3ycXxPsXMKwPsRzQadg+/q0yBjvf7hb2zh3SlPKpO1M+FY37R0N5gdu2wtOnhkEQEzyxVgdikGguZxojX/I/we0juCx3gCvSrPr5Q+m6fZOpkyfVuJHMU70doQjaKLQsP1+nVdLwC/SJYVzmhHMxeUsWdcuhvz+c501fxwqGvP4R4IgNTnbHvfkBs7ZMfQ2X47lDAjG/H042zZU/RD21SqMeYb
 GwmYkgc6
 3vjLE4/xF1ttcxMMfWqFlVU2mRQQekJEmOQCfNK+Nq/gz+pyA0uyba6+XBdVAAd49Cpp2firhGrXvzR0Cp22el4oc4oXo86sgxd5+c9dK4DfgoI/o16tYTCnVT6LkgzzT7+BlD2ckz2hMskSj0qy1WDyjBTgHLYR4FxJTrbUDRDjMw2qYaOSWWOg5aTfusA7p+NYhMD8Wwo8iqzMiQkh1KTGj/Uep5AbkjThSFT5+DxkQOj7+6OkY/z3RpG4oDcrS195zF98K4k8jo91FnUBkD11DoEKmOq6eI7ngtBC3Qzcrr8dEkwuSCQxinccLo5Q2bfic1Ucr7yLdF9CIm9PLIqRV9Z60OtxbK/kPGB0Z3HQMhClx1kZcmQNI+vTMDbZa0/BxVJOR/djE/oXimcoLduZCKByfCFvhGkvW
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
performs the warnings outside of the fastpath, and leak the object.

As an intentional change, leak the object when slab->slab_cache differs
from the cache given to kmem_cache_free(). Previously we would only leak
when the object is not in a valid slab page or the slab->slab_cache
pointer is NULL, and otherwise trust the slab->slab_cache over the
kmem_cache_free() argument. But if those differ, it means something went
wrong enough that it's best not to continue freeing.

As a result the fastpath should be inlined in all configs and the
warnings are moved away.

Reported-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@google.com/
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
I'll put this to slab/for-next. Thanks for the reviews!

Changes in v2:
- Add a comment and mention in the commit log that we are leaking the
  freed object also in cases where s != slab->slab_cache (Hao Li)
- Link to v1: https://patch.msgid.link/20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz
---
 mm/slub.c | 56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..fd915ea95121 100644
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
@@ -6774,11 +6770,25 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
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
+		/*
+		 * Intentionally leak the object in these cases, because it
+		 * would be too dangerous to continue.
+		 */
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
 
@@ -7305,7 +7315,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
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


