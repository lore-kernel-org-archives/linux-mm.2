Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE551CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C918E000D; Wed, 15 Oct 2025 05:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DAD8E0002; Wed, 15 Oct 2025 05:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8E48E000D; Wed, 15 Oct 2025 05:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D39A08E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:36:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 784CE47B10
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:36:23 +0000 (UTC)
X-FDA: 83999843046.27.7213EF0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 224EC120009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:36:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M1JiCGtq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NV6mw7MY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M1JiCGtq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NV6mw7MY;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760520981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=80A1Lbr2NHiPkBntBorRErvGsi3gTVaNEMpxg0hKVq0=;
	b=bgmaw7JOx7Al1zOyycTezhB3zrnagF4ntI804vr18O3PzSpxu603WXGt5pNrTo3n1JsoFM
	l429Bm0uGadrisvBJNEzYD5Pry3Vo31laWNjpdi7s0j5SmAmvFxbsdx8qJPqXZcYUv61/n
	StScvJsBkDAREDot48CG1G1bpemJyxY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M1JiCGtq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NV6mw7MY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M1JiCGtq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NV6mw7MY;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760520981; a=rsa-sha256;
	cv=none;
	b=nnDgUSNKraatg/0l/gT82+OivMnQgScQF4YQE0oMrLGhmLLpiTlIS/lp94pDv3FSSbY46m
	9IVCIP4u3doI6xsIP1ebkXx2fQI5dJR3pCBsfBfwBVU+OLHlPNOM6rDchWCRBeA7L2np5N
	aKzfaBvIabTSLI6l+0+idnCZ+tkF4Ns=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D732336FE;
	Wed, 15 Oct 2025 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760520979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80A1Lbr2NHiPkBntBorRErvGsi3gTVaNEMpxg0hKVq0=;
	b=M1JiCGtqfDItkObOopZ1LVrM+PJsLp+qZJd71MfmL3JBqRgiRQOXikWN4FNdd0QIzfqpwf
	klwqyT+TLihCDCIWK3Vkd986wrSkRCKO3m1JhN21unmqN+4b32MwllRSVtzeSYgJCMCqQx
	NambhUg67OahjLimB8B8ZqsmaU0WkCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760520979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80A1Lbr2NHiPkBntBorRErvGsi3gTVaNEMpxg0hKVq0=;
	b=NV6mw7MYsffpkCKgPqSIhvbF+2OwrI7NzkOA4G6YHMtL9P2yaYhpKgbI2vuU670iNXjgdY
	Sfzfq5JgfOGC/jAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760520979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80A1Lbr2NHiPkBntBorRErvGsi3gTVaNEMpxg0hKVq0=;
	b=M1JiCGtqfDItkObOopZ1LVrM+PJsLp+qZJd71MfmL3JBqRgiRQOXikWN4FNdd0QIzfqpwf
	klwqyT+TLihCDCIWK3Vkd986wrSkRCKO3m1JhN21unmqN+4b32MwllRSVtzeSYgJCMCqQx
	NambhUg67OahjLimB8B8ZqsmaU0WkCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760520979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80A1Lbr2NHiPkBntBorRErvGsi3gTVaNEMpxg0hKVq0=;
	b=NV6mw7MYsffpkCKgPqSIhvbF+2OwrI7NzkOA4G6YHMtL9P2yaYhpKgbI2vuU670iNXjgdY
	Sfzfq5JgfOGC/jAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B96113A42;
	Wed, 15 Oct 2025 09:36:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KsUhEhNr72hLXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 09:36:19 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 15 Oct 2025 11:36:09 +0200
Subject: [PATCH] mm/page_alloc: simplify and cleanup pcp locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-b4-pcp-lock-cleanup-v1-1-878e0e7dcfb2@suse.cz>
X-B4-Tracking: v=1; b=H4sIAAhr72gC/x3MQQqAIBBA0avErBtQUaSuEi3UphoKE6UIorsnL
 d/i/wcKZaYCffNAposLH7FCtg2E1cWFkKdqUEIZKaRBrzGFhPsRNgw7uXgm7LwVXkvrlCCoZco
 08/1fh/F9PwSWo1VlAAAA
X-Change-ID: 20251015-b4-pcp-lock-cleanup-9b70b417a20e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9526; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=NasT/wB870yeYgGUl/tJbYabJAVTbSRwqBkAwkRzyIo=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBo72sPbcVCy/SfheCgWSGhnX5BYcdD+C5EsuNJp
 gUAy1xaVa+JAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaO9rDxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJrsvggApkI/Ljfg2Qx1tdo/EzBJgEuL76suJ08
 xi60fKPYENSkzcfknl2ehq5PiuwjW0oxMk838N627tv7vP8j+0vNqBW8OYkIgNFi/lXzf8Vjz6F
 ixBRyOsvikoLIK3VIxuMT+lQfZ8K+lHrfiPJcE93h2XoJcJzuDsHYLsZGkMW1+hiU0ltNMMZ6HH
 PEhjhMyAdxtRBUNj8TMXp8T3fRAl74QjBjU/gQzLb+gnETDovGn5vA0UhRE1+iPzJXttknnHCLU
 NnL+7A4ADwAcMfHZ11nVnpY+vhnL5hzVu9EmKiWHrYEmM6S3DXOWfuq2+mCtJ3yN5EjsaVPRlCQ
 qScvh7Z/eHg==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: eb7ahbkrncpj63jc3mb818me6zrphkwq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 224EC120009
X-HE-Tag: 1760520980-469227
X-HE-Meta: U2FsdGVkX1/vr/HJfHoMLLYuO91Xhl67xkiEX1TLC2F8hUcssG+0d6a5d3Kly3rrrqJDO41yEEHl6jYji3JpiRPRA+N2w5Re4JE3MbqNT1qcUw27ejwRWoNmAf8sFbKJ+pdlYJplWL7lLp6bf4Wp1sw83oQd5e9QX00HHN72sf/vB/euphWiybIkC8aRD+rUNbNw7ZSrQutElPigbplW+CuDyvWFxk1J6QPgT73o/1sAH52dpYvUtkaqf6NUxIsJVRJxSjMuoecLvX87MwZltyJVCFklWsAC76lmHFLzM5Mj7CRHVOFsIvfxtRU1lDWg0evLQHIzZ53WGgMVhclDGCt6qBH8vG7/U4YmjrxCeuHnCpMmvkZjn6urgB5bmpXa1x75jvDlrDKW3v59Tg9EeVIkBqphI64mHv0PFI81DNd1dG56XIT8Wnc9GHqog3EImKntK3r/XhedVt3Kx8GSzodgbHwU2s92GFbOom/GZid8GAjoceBujL9s5wBfl8zY2fX3WyRjpIGvlkLOomSlh/0P/eYb7AWsQyCH7sUJwTZGcJCfNPX+xc6KeU/2lnCoIWe2cEBsTC6q+zgcmDzJeJ6w6W4qR3hNzUcHFU3opgR8thx4kduf+AOa5zSVDizoMgnp6liEBZKwwSRwyi53veaVyYZsHRHYFlpLIRV+Vt+UtO/v1RKdSztrL9qiU2+bK1Hep8jtCEYZPfcFkkHzoqzoV8OEcWbr/k82+9nPu4AkCVBJJhS+HM0jutNmOx0X/rQuKDSdoMayBSmsy6CvSZCkDz5roGiCwl43PaNkY8yJTda4RW3V7ohGcZyVNlXamjuIl9u1MFDldRm7ofCs8ZTW/c/19eixmkDMrakJOC43fPIuG5t6h6a84+pNYhEZrSonUO3nYL8dIl3+myrRZsihNv1rk5ML/1W1EABS9X2MMIEGgiR5iVND8i7PuC5P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pcp locking relies on pcp_spin_trylock() which has to be used
together with pcp_trylock_prepare()/pcp_trylock_finish() to work
properly on !SMP !RT configs. This is tedious and error-prone.

We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because we
don't use it. Afterwards pcpu_spin_unlock() is only used together with
pcp_spin_trylock(). Therefore we can add the UP_flags parameter to them
and handle pcp_trylock_prepare()/finish() within them.

Additionally for the configs where pcp_trylock_prepare() is a no-op (SMP
|| RT) make it pass &UP_flags to a no-op inline function. This ensures
typechecking and makes the local variable "used" so we can remove the
__maybe_unused attributes.

In my compile testing, bloat-o-meter reported no change on SMP config,
so the compiler is capable of optimizing away the no-ops same as before,
and we have simplified the code using pcp_spin_trylock().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
based on mm-new
---
 mm/page_alloc.c | 99 +++++++++++++++++++++++----------------------------------
 1 file changed, 40 insertions(+), 59 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0155a66d7367..2bf707f92d83 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 /*
  * On SMP, spin_trylock is sufficient protection.
  * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
+ * Pass flags to a no-op inline function to typecheck and silence the unused
+ * variable warning.
  */
-#define pcp_trylock_prepare(flags)	do { } while (0)
-#define pcp_trylock_finish(flag)	do { } while (0)
+static inline void __pcp_trylock_prepare(unsigned long *flags) { }
+#define pcp_trylock_prepare(flags) __pcp_trylock_prepare(&(flags))
+#define pcp_trylock_finish(flags)	do { } while (0)
 #else
 
 /* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
@@ -129,15 +132,6 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
  * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
  * Return value should be used with equivalent unlock helper.
  */
-#define pcpu_spin_lock(type, member, ptr)				\
-({									\
-	type *_ret;							\
-	pcpu_task_pin();						\
-	_ret = this_cpu_ptr(ptr);					\
-	spin_lock(&_ret->member);					\
-	_ret;								\
-})
-
 #define pcpu_spin_trylock(type, member, ptr)				\
 ({									\
 	type *_ret;							\
@@ -157,14 +151,21 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 })
 
 /* struct per_cpu_pages specific helpers. */
-#define pcp_spin_lock(ptr)						\
-	pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
-
-#define pcp_spin_trylock(ptr)						\
-	pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
+#define pcp_spin_trylock(ptr, UP_flags)					\
+({									\
+	struct per_cpu_pages *__ret;					\
+	pcp_trylock_prepare(UP_flags);					\
+	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
+	if (!__ret)							\
+		pcp_trylock_finish(UP_flags);				\
+	__ret;								\
+})
 
-#define pcp_spin_unlock(ptr)						\
-	pcpu_spin_unlock(lock, ptr)
+#define pcp_spin_unlock(ptr, UP_flags)					\
+({									\
+	pcpu_spin_unlock(lock, ptr);					\
+	pcp_trylock_finish(UP_flags);					\
+})
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2887,13 +2888,10 @@ static bool free_frozen_page_commit(struct zone *zone,
 		if (to_free == 0 || pcp->count == 0)
 			break;
 
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(*UP_flags);
+		pcp_spin_unlock(pcp, *UP_flags);
 
-		pcp_trylock_prepare(*UP_flags);
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
 		if (!pcp) {
-			pcp_trylock_finish(*UP_flags);
 			ret = false;
 			break;
 		}
@@ -2904,8 +2902,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * returned in an unlocked state.
 		 */
 		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp);
-			pcp_trylock_finish(*UP_flags);
+			pcp_spin_unlock(pcp, *UP_flags);
 			ret = false;
 			break;
 		}
@@ -2937,7 +2934,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
@@ -2973,17 +2970,15 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
 						order, fpi_flags, &UP_flags))
 			return;
-		pcp_spin_unlock(pcp);
+		pcp_spin_unlock(pcp, UP_flags);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
-	pcp_trylock_finish(UP_flags);
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -2996,7 +2991,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
  */
 void free_unref_folios(struct folio_batch *folios)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int i, j;
@@ -3039,8 +3034,7 @@ void free_unref_folios(struct folio_batch *folios)
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
-				pcp_spin_unlock(pcp);
-				pcp_trylock_finish(UP_flags);
+				pcp_spin_unlock(pcp, UP_flags);
 				locked_zone = NULL;
 				pcp = NULL;
 			}
@@ -3059,10 +3053,8 @@ void free_unref_folios(struct folio_batch *folios)
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
-			pcp_trylock_prepare(UP_flags);
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 			if (unlikely(!pcp)) {
-				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
@@ -3085,10 +3077,8 @@ void free_unref_folios(struct folio_batch *folios)
 		}
 	}
 
-	if (pcp) {
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(UP_flags);
-	}
+	if (pcp)
+		pcp_spin_unlock(pcp, UP_flags);
 	folio_batch_reinit(folios);
 }
 
@@ -3339,15 +3329,12 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-	if (!pcp) {
-		pcp_trylock_finish(UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	if (!pcp)
 		return NULL;
-	}
 
 	/*
 	 * On allocation, reduce the number of pages that are batch freed.
@@ -3357,8 +3344,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5045,7 +5031,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5139,10 +5125,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (!pcp)
-		goto failed_irq;
+		goto failed;
 
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
@@ -5159,8 +5144,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock(pcp);
-				goto failed_irq;
+				pcp_spin_unlock(pcp, UP_flags);
+				goto failed;
 			}
 			break;
 		}
@@ -5171,8 +5156,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		page_array[nr_populated++] = page;
 	}
 
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
@@ -5180,9 +5164,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 out:
 	return nr_populated;
 
-failed_irq:
-	pcp_trylock_finish(UP_flags);
-
 failed:
 	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
 	if (page)

---
base-commit: 550b531346a7e4e7ad31813d0d1d6a6d8c10a06f
change-id: 20251015-b4-pcp-lock-cleanup-9b70b417a20e

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


