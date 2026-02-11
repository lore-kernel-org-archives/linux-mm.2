Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C8AEB5954
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461116B0005; Wed, 11 Feb 2026 04:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439666B0089; Wed, 11 Feb 2026 04:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DA46B008A; Wed, 11 Feb 2026 04:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2004D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:42:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB7A513A3E6
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:42:44 +0000 (UTC)
X-FDA: 84431686248.04.3AFDDC7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1AE08C0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:42:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SVoaGoCC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZetMEFKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SVoaGoCC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZetMEFKj;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770802962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K5Un/BwBCJb/Lo7qf21XKs3tKGaJwngf0MHuo+OeL0A=;
	b=ybJFIXoVBzuG4X9VpguazwMjH2enLOsZXY5D0mshgOHUXhEbv8JYGHTL5dEzLTXhqtKFLQ
	X7/Vk5SirUOKpHHF8K5Dg/2pYPAMLJwSBJfUWRBXTXwy1cEMGUx9v2CH3DDYFHq6V7R7oM
	zbPoXlmDXkgxpugnVL7EsxAwtC5EvCI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SVoaGoCC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZetMEFKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SVoaGoCC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZetMEFKj;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770802962; a=rsa-sha256;
	cv=none;
	b=M+RJ57KfK7T7OF1QzejvT/QxBAzR8KQ8wZIZ/GDwZFW84eY7klw8spnxB5+gXdZEo/BsmU
	8Dacr8Wlg/RfhctzJzBHuLtaUZ8JH4ciadjJ9BrUNWgtUX2NzhAajg4y6m4DXLuUImUHlI
	jri4RFJXGQbYe/K4zrWN/w+uQJ3W1rc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 170A25BCC6;
	Wed, 11 Feb 2026 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770802960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K5Un/BwBCJb/Lo7qf21XKs3tKGaJwngf0MHuo+OeL0A=;
	b=SVoaGoCC5gDmQFRyWjA3PCKyu+t/Ois681D4Z9KrsVvsO92E7/NlXIvOlJVWQwApirMC7D
	m52UpX/ubppqr2vha2Y/gt++mHlKdVcSRxzatYjIPhRPvhuknUF4N47l1oFe7qi5PJCQLR
	UpBiD1z3cb7idw4z3FpmQYGx6iDR9sU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770802960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K5Un/BwBCJb/Lo7qf21XKs3tKGaJwngf0MHuo+OeL0A=;
	b=ZetMEFKjbfbgF/T7ZZvZ/oJ3QQ45vUMJ1CCDkAy7QJxlMCjmN03nOwXXPnsFDJMxyVO29l
	4XT+7EaMHBoqVOBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770802960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K5Un/BwBCJb/Lo7qf21XKs3tKGaJwngf0MHuo+OeL0A=;
	b=SVoaGoCC5gDmQFRyWjA3PCKyu+t/Ois681D4Z9KrsVvsO92E7/NlXIvOlJVWQwApirMC7D
	m52UpX/ubppqr2vha2Y/gt++mHlKdVcSRxzatYjIPhRPvhuknUF4N47l1oFe7qi5PJCQLR
	UpBiD1z3cb7idw4z3FpmQYGx6iDR9sU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770802960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K5Un/BwBCJb/Lo7qf21XKs3tKGaJwngf0MHuo+OeL0A=;
	b=ZetMEFKjbfbgF/T7ZZvZ/oJ3QQ45vUMJ1CCDkAy7QJxlMCjmN03nOwXXPnsFDJMxyVO29l
	4XT+7EaMHBoqVOBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC6BF3EA62;
	Wed, 11 Feb 2026 09:42:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9OdiOQ9PjGn+GwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 11 Feb 2026 09:42:39 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 11 Feb 2026 10:42:30 +0100
Subject: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
X-B4-Tracking: v=1; b=H4sIAAVPjGkC/x3MQQqAIBBA0avErBtQiciuEi3UxhyICocikO6et
 HyL/wsIZSaBsSmQ6WbhY6/QbQMhuX0l5KUajDK9Mlqj71ASuYhxuyShIW+ts2Hw0UONzkyRn38
 4ze/7AXBfFEtgAAAA
X-Change-ID: 20260211-b4-sheaf-flush-2eb99a9c8bfb
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2971; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=HnOPKhUbGfasn9ycdnsjV/XKeYiQWLOzg9jjMCIDkOA=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpjE8LmXCShpS1gNp1Z+8ihRo1+pG2xXlG70nQ1
 7Gc/jjIj+uJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaYxPCxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJoKYQf+LtgmATGmvJam7nTWPDf+z2jFqbzAmby
 /5qT5f7+Qv9OiURW1/5Lcrq8If5GpouLNDdgwGLnbzG9wRJJRKNbQOSGrOWdD8ie4sajKWo7cKZ
 6jOYSwY47GS3QS7a0QOqcsmfE6mI51gBa/p2v7a7f7vGpBy+2QDHtyruBMvnRfEZYJVxTOi0+NV
 +mYaZUSlpLlxBKsX96GKD+0HG3FEKL47c8iBRXcIvxponMjTA7dHHT5w2dxh7F5Od1fybSdwBx+
 ZD/OwCbt5ViI01MDd2ZJ0DsMlX0WiS1SWP2Ta20pOpprXkzucLd2sAtCV8VPMIQdZNv8vUKLVB3
 +EvnyUnk1RQ==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1AE08C0008
X-Stat-Signature: iq5b4awpc8n9htrc11k1hzzifwnwaoqy
X-Rspam-User: 
X-HE-Tag: 1770802961-871238
X-HE-Meta: U2FsdGVkX18sfleOl77ptr+wUCQtIC9arOarkPxgYsnSgLyusdeG9DkwB8WQ/ljVfGOsP1lpEYIMg3RwJgk7xiofTVeVIAOSZGdHZrshTC+YQrV7B2LMTB6ajzT+Vo73gVzLw8cK+fKM+OQMidc2FBFXrtE2164rrtOCwGd6/lV1TMktdjThQGnznDVjgyt1/yuZE810Fde4JARcIQplqPe8ZJHrsW9b0cWGSG1WAcRsKycHwziJqtvmHHzvxCKWHzSBq5T1OJWgKQyAKtbACeNmt7CqofqRZd27e+A4UOn2nGRP43j7sqO+uNyF2JZe2WukW5eUnLZ7U+vnH2R38PbNv7XzG+Mx4+WDWfsBII6i9XrGdmEB73qc4T8j3EJHTIPQXvBITGiOJcS+yiS+O7OzWkRyqQ0g37umYP4wfQUREBs6tcm3YWFeX+xAz6XYelNIZWz0J0CoDqZwAABvcDc46jJSMOet6kn9BLJN+tkldxatf+/DeKKFapSC92Pu6DGqIaS8w1z2RxpYOqRbt6LZSOXQSTIwRKc0rZZnNgWO1BFkAkZCFrOFZpkYMdvBmbzkLqhaV46hSOyuwrMEVoeT25Ix8VS2aZbjadAxwPAPruyyQVKird7baxjqlAnz/wW7i6z9j4y/2wG12EnmcmhIZt2buvIWb5evBATbfItGftnsRhBZg5j2tQZ8X2BGh10cyraeHugtq/JJW040vlDXXg+MOjGudr66chr1XblDgt4IaFIILGURvRF76V2ZNJ53fNEv1Kv1PeqdTjujTfZN3WNGKNt0K2KQic4NZCJEi2dw+KXO9OROjm0DTJejW+ckGmeFBsri37JyKJ7HIL4FFxSWnikf24QakKbhfh/2nCD59rePDKBZnePwivI5EW7PKxbKQMpUThgngU3eaAG/+zWf7F2NN5hbtbo81QXsB9qNhgxQjCeMBZzNxQuw3MGbapNADWQz5lIDj1M
 JCnty1Bn
 An+DiarbOm5+Vo669tQiWK5jT+D+SuUqJvV3x+iW4u2PwMszifzBf0UwhAJf5qFM3/8YZRWk9FfKk4xRu/lTddcXOm0/6vUt15BXo/Tcy30fU1OkEjALeyE5WQ5yZMwJw/556ZRSjxEqzJGA9rDeU6p4MGzexcaX3+OPi7fO7Ayma5bI+LkM4XyWbUufEri4yi7O3YitSmOv8PNrUpfgcKuqGTZAeFhnSXorLopKZUj72h4Vu2dSK/URI+yXYrR6ycRoQMVYNaqgV88jsw4uJQjcG0eOCWNsJpT00bxIgt6fMIhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sheaf_flush_main() can be called from __pcs_replace_full_main() where
the trylock can in theory fail, and pcs_flush_all() where it's not
expected to and it would be actually a problem if it failed and left the
main sheaf not flushed.

To make this explicit, split the function into sheaf_flush_main() (using
local_lock()) and sheaf_try_flush_main() (using local_trylock()) where
both call __sheaf_flush_main_batch() to flush a single batch of objects.
This will allow lockdep to verify our assumptions.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 18c30872d196..12912b29f5bb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2844,19 +2844,19 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
  * object pointers are moved to a on-stack array under the lock. To bound the
  * stack usage, limit each batch to PCS_BATCH_MAX.
  *
- * returns true if at least partially flushed
+ * Must be called with s->cpu_sheaves->lock locked, returns with the lock
+ * unlocked.
+ *
+ * Returns how many objects are remaining to be flushed
  */
-static bool sheaf_flush_main(struct kmem_cache *s)
+static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
 	unsigned int batch, remaining;
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
-	bool ret = false;
 
-next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
-		return ret;
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	sheaf = pcs->main;
@@ -2874,10 +2874,37 @@ static bool sheaf_flush_main(struct kmem_cache *s)
 
 	stat_add(s, SHEAF_FLUSH, batch);
 
-	ret = true;
+	return remaining;
+}
 
-	if (remaining)
-		goto next_batch;
+static void sheaf_flush_main(struct kmem_cache *s)
+{
+	unsigned int remaining;
+
+	do {
+		local_lock(&s->cpu_sheaves->lock);
+
+		remaining = __sheaf_flush_main_batch(s);
+
+	} while (remaining);
+}
+
+/*
+ * Returns true if the main sheaf was at least partially flushed.
+ */
+static bool sheaf_try_flush_main(struct kmem_cache *s)
+{
+	unsigned int remaining;
+	bool ret = false;
+
+	do {
+		if (!local_trylock(&s->cpu_sheaves->lock))
+			return ret;
+
+		ret = true;
+		remaining = __sheaf_flush_main_batch(s);
+
+	} while (remaining);
 
 	return ret;
 }
@@ -5685,7 +5712,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (put_fail)
 		 stat(s, BARN_PUT_FAIL);
 
-	if (!sheaf_flush_main(s))
+	if (!sheaf_try_flush_main(s))
 		return NULL;
 
 	if (!local_trylock(&s->cpu_sheaves->lock))

---
base-commit: 27125df9a5d3b4cfd03bce3a8ec405a368cc9aae
change-id: 20260211-b4-sheaf-flush-2eb99a9c8bfb

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


