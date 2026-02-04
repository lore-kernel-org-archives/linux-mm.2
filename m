Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BB0E9538C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E066B0092; Wed,  4 Feb 2026 06:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDBE6B0096; Wed,  4 Feb 2026 06:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33856B0092; Wed,  4 Feb 2026 06:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98F466B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:43:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2711B8634C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:52 +0000 (UTC)
X-FDA: 84406589904.08.71B47CF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF429180009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1FZYbxw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DbpxugkZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1FZYbxw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DbpxugkZ;
	spf=pass (imf06.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHiTHOmnBIMYigxYzITrSBVUeu3uMvU8+dLOOB+NK2s=;
	b=vQJtufHOBfWclHhDZs0n+gttQVfqtAHu0x8h2zqy/bfJJKBSV8vi+upUrz+Jfavv5c8rTE
	yrieiw3DDyYR4/HsnP/g8035+DhKJ76do4g9FEZroZqSRvvjXWITGFf7lBdGocG/53Wg/g
	jLnPyabZlkLdsVIL+NYdjt/NqOIabGg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1FZYbxw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DbpxugkZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1FZYbxw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DbpxugkZ;
	spf=pass (imf06.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205430; a=rsa-sha256;
	cv=none;
	b=sZ/1bdmI4Q71NlI0a/Tjuh4/NitPUty3RIT0T/Nnm1Exq/8yRpl1Eiibm2lJu8u5fCKGAS
	bUDbMf+DOKmJ25DDOl2nZeSyXuD3Nlx/OXF2tdoSW97V1ySCT0+Ze2oH+SmzKKYtwLIkzX
	HCCZTeuid5gqYrmrqwAdDM/Xq7v3wxQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6437C5BCC5;
	Wed,  4 Feb 2026 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHiTHOmnBIMYigxYzITrSBVUeu3uMvU8+dLOOB+NK2s=;
	b=k1FZYbxweggw2i4ZGC75gVeeqPcu66h9ioOUQ0r8E7LCyYfno4QtWImpA8NcR35vE73VMJ
	nNZApoENylo6ns/7Ldb2bwyMDAp1r7oX8ZA8b5e0D4FSmM/SDKG8iimBpZuxqvmm3MRBLx
	GBGQPr+Be4/ox77B0uqmPV0Oa5EkQMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHiTHOmnBIMYigxYzITrSBVUeu3uMvU8+dLOOB+NK2s=;
	b=DbpxugkZDluoI2RSWdS9RAfFy2fzMhpSm8UKG+ep0L6ez5hlM1gLsoyKRTb5y8QkxoLjjX
	xSmJVQxpBNAvJgAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHiTHOmnBIMYigxYzITrSBVUeu3uMvU8+dLOOB+NK2s=;
	b=k1FZYbxweggw2i4ZGC75gVeeqPcu66h9ioOUQ0r8E7LCyYfno4QtWImpA8NcR35vE73VMJ
	nNZApoENylo6ns/7Ldb2bwyMDAp1r7oX8ZA8b5e0D4FSmM/SDKG8iimBpZuxqvmm3MRBLx
	GBGQPr+Be4/ox77B0uqmPV0Oa5EkQMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHiTHOmnBIMYigxYzITrSBVUeu3uMvU8+dLOOB+NK2s=;
	b=DbpxugkZDluoI2RSWdS9RAfFy2fzMhpSm8UKG+ep0L6ez5hlM1gLsoyKRTb5y8QkxoLjjX
	xSmJVQxpBNAvJgAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0552B3EA63;
	Wed,  4 Feb 2026 11:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mMR7O/Mwg2ldawAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 04 Feb 2026 11:43:47 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch
Cc: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 4/4] drm/gem-shmem: Track folio accessed/dirty status in vmap
Date: Wed,  4 Feb 2026 12:39:32 +0100
Message-ID: <20260204114341.195143-5-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204114341.195143-1-tzimmermann@suse.de>
References: <20260204114341.195143-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4bnc8j3xdu65hyhzjcjige4w1hfm76m
X-Rspamd-Queue-Id: EF429180009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770205429-529251
X-HE-Meta: U2FsdGVkX184IHtQ/euA8ZOZxWaecVsHNxWpyyY0c5lFZdYxUFs9uRehyJFtj9uEc4Uhw3DysdaCf5RotRI62RWlRF4ccqGkWe6YQic7TYY6lfhdOF/HrhIRnyz0+9XRgSYsB6f7VMEF4fDuBLt75k9p6fqE3ODlcpthEGRuAIQOHwM+OQ2dgH7A1OWFDBj14Nod9xq3wiABgKK1dAV/F952ua7MTvYstrvF2hDh7z6aRwGuMBiXxmHwySOXHThMljSZHrHbz1SvsxFzjcF6xcSDM2+gnglVn2L1cJdg5u0M4qmc26sDyAr55LWcIgb88fZ2JIOxd2FQ/QU0hPF8s4OO9l/EJmx2jFXh97TMyjWCG7nEjihZZ32JQZCbcMoOiiualFQOFNvYSRh67KY90FtC9DcRwWTvKZPFQeqLPzSuVWOr264hA0odaBRZfMMppJ97VXXeQmaQaFOu6xOHtCS5gJJGr/6ijMySbkWVZtlzzpTyICTvWx0xSj6BUxFeVE7MxTwBM2yCOiN7DteTAm+wOijXx0p75o/bJkE6qeNyWu5Xbqfg7V7b9KYLzohfLJvoQxuI9l51ZInLWgdHSJkhABt50DNhFsN/Kp04M7mXH7gn3FTJ85r+sO+Bt5BrMX4udHA9HOemSg8LzuiYGR4dEa5DfsIb9+kdXEg8acp7h6covFZ1EuM3GiFZhvJFV68HHnYECOH8zWw5i417sj2meSHq8Ro+kchwMoyq7TA1LyqYCM52NWAHKNpLYUkvQGlTxMaqEQvKn7cAgDcyts9l1wAkBLfRGzOrTkrMFsZ90vhW5gHyAAdXWkvREXr5iitcoj1+LfczyvSBrs2jr8mCyfuMepOdFYpJwxktsjEDy5qpqYgWNjhcw9agKvGNPbnUpXeBIWH7m1fS/Qgof+LFAZ54MoRfo319/CU/eK3IMle8asB22/LFUVhmsqQlDbVOPZy6qFvtsYhYy1M
 1B2sko/n
 UNgtAmnPZuGmPGb6/TtwxaSGDcMiDsM1pLCiWp8D5u78vgylN4VFM+KGQeNHqpHg+VnIlHGtgn0odFZIj7uycU/TBK1GnzHNs+w1PaTf8aMarhi6YuTGb5phUaXxOko0F4MTLJFCLuC8hnkScCUey2dGdjqOwCW5zIyEPQM7vuGKzxC6cfwyEPFWHZeusGTIvZR9iy2JNg3rKozlLjYlKJpEfVY5rAsOeZxIFaruKrq/rFoTCjBYdIVtYgkvD5n1jkLeo9bdYJ71nb83WKMLteOmmpjdmwJbhlwwS4UkkGOk9Wcl9KTRn8zE0YlLdXJmFw5/L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On successful vmap, set the page_mark_accessed_on_put and _dirty_on_put
flags in the gem-shmem object. Signals that the contained pages require
LRU and dirty tracking when they are being released back to SHMEM. Clear
these flags on put, so that buffer remains quiet until the next call to
vmap. There's no means of handling dirty status in vmap as there's no
write-only mapping available.

Both flags, _accessed_on_put and _dirty_on_put, have always been part of
the gem-shmem object, but never used much. So most drivers did not track
the page status correctly.

Only the v3d and imagination drivers make limited use of _dirty_on_put. In
the case of imagination, move the flag setting from init to cleanup. This
ensures writeback of modified pages but does not interfere with the
internal vmap/vunmap calls. V3d already implements this behaviour.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com> # gem-shmem
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++++
 drivers/gpu/drm/imagination/pvr_gem.c  | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c2ee30967c41..a0b0912c1d42 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -265,6 +265,8 @@ void drm_gem_shmem_put_pages_locked(struct drm_gem_shmem_object *shmem)
 				  shmem->pages_mark_dirty_on_put,
 				  shmem->pages_mark_accessed_on_put);
 		shmem->pages = NULL;
+		shmem->pages_mark_accessed_on_put = false;
+		shmem->pages_mark_dirty_on_put = false;
 	}
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_put_pages_locked);
@@ -397,6 +399,8 @@ int drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem,
 		} else {
 			iosys_map_set_vaddr(map, shmem->vaddr);
 			refcount_set(&shmem->vmap_use_count, 1);
+			shmem->pages_mark_accessed_on_put = true;
+			shmem->pages_mark_dirty_on_put = true;
 		}
 	}
 
diff --git a/drivers/gpu/drm/imagination/pvr_gem.c b/drivers/gpu/drm/imagination/pvr_gem.c
index c07c9a915190..307b02c916d4 100644
--- a/drivers/gpu/drm/imagination/pvr_gem.c
+++ b/drivers/gpu/drm/imagination/pvr_gem.c
@@ -25,7 +25,10 @@
 
 static void pvr_gem_object_free(struct drm_gem_object *obj)
 {
-	drm_gem_shmem_object_free(obj);
+	struct drm_gem_shmem_object *shmem_obj = to_drm_gem_shmem_obj(obj);
+
+	shmem_obj->pages_mark_dirty_on_put = true;
+	drm_gem_shmem_free(shmem_obj);
 }
 
 static struct dma_buf *pvr_gem_export(struct drm_gem_object *obj, int flags)
@@ -363,7 +366,6 @@ pvr_gem_object_create(struct pvr_device *pvr_dev, size_t size, u64 flags)
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 
-	shmem_obj->pages_mark_dirty_on_put = true;
 	shmem_obj->map_wc = !(flags & PVR_BO_CPU_CACHED);
 	pvr_obj = shmem_gem_to_pvr_gem(shmem_obj);
 	pvr_obj->flags = flags;
-- 
2.52.0


