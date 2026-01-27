Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47435D2F02E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194B66B008C; Tue, 27 Jan 2026 08:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163036B0092; Tue, 27 Jan 2026 08:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DF66B0093; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFCA56B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:29:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AD0B140150
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:57 +0000 (UTC)
X-FDA: 84377826834.02.CEED668
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id B7083A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6ADI5cSTw63S5SUyPpyowxc092hITvzS1Z5yC6HAu4=;
	b=VMkzPVWkfaJUm4Lj+8ECzG3Z496ohnJmxVIRaP2pF7NOjZwy28olQ/ewaZCknFK+l+BV24
	TyYiRLM/BH5solHnLUMBR+wvupw4aOw77Su/vXtKbQh0LTcYNkwtar++ngCK0z1MEvP9AJ
	JYsZB4+PKj6D1XOIazPSy+FNHJIwzXs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf15.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520596; a=rsa-sha256;
	cv=none;
	b=8GDwUtOi2tlz4mtyChdhtwTOfGVS/QAwZji48Ura1U44k/wGLlpN0cSxCdGk6h5b3CCUes
	oLBheh3N8KkP0HktTAy77AWsuiABuD8INkbdoj3ovIFF4Pz0qziWMhv0He96kqBifThKP0
	so/FQaBNDTxL4Gf3sns8QLKFdNQL6U4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B4458337B6;
	Tue, 27 Jan 2026 13:29:48 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D4963EA61;
	Tue, 27 Jan 2026 13:29:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MGVVFcy9eGmeDAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 27 Jan 2026 13:29:48 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com
Cc: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 3/3] drm/gem-shmem: Track folio accessed/dirty status in vmap
Date: Tue, 27 Jan 2026 14:16:38 +0100
Message-ID: <20260127132938.429288-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260127132938.429288-1-tzimmermann@suse.de>
References: <20260127132938.429288-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: d89j67oh5z81x8rjqx9nd6qhxwpjnshh
X-Rspam-User: 
X-Rspamd-Queue-Id: B7083A0003
X-HE-Tag: 1769520595-152099
X-HE-Meta: U2FsdGVkX18RuZ3IgBt7H8LifVEK2qoKpgm+slLAtel3o2bgluwHYr14mvAGHWaQnSJLD1YbGw/gnd+D2YcCGGn+qaU4vShcrkh3Lab+aSD9/qafOnxNSuKPfWnFV0K1i8b+FNdMwqhAxAP+3mBn0IABSqtHDBzIh8wtPVn9NNA4P1JPXrX2RZjizrPvlWdu9n8zyDcz30L1AjfnLga/YbEBgsYk+x5g5zFaE/RqPrIW1fkEGaCDJSnN2JLIJoPO6JnRL1bge1PF7Xfw6XCTYtG9yxgJyJ0IfmbrZP6uf7EISDT5aPnIHGcBaqZE3lJ+cIJSOsgfKAx5vTV+6u8dX6VMZSxoI6+W/q6PTDjA+VzJez1HSCQBkxGvSmfFsZ5pbiiQWmhS1fKfflWMANtdnz4QR6NlCOw3gwMe+tY033FUOn1TlHBeJ0UYvLUb7LtxcUqRnNhY+fTKNVd+r19Lwdv1jE0P1v0I5ZCMcf8Q0CubTOHzZd4qK/vVkB3vp1zHLyN+SDMQYT6NAyEKf3a3md3aqhrP86Zuk2RCp2zmuzxNtQSA7EryezuyHmmkV2kmogkbF6AiVQknzsp+aCnafofq4cHaTzJE7glV1X2iskU4PpNlsjDaXLgyuyc1ZAUd3r9tXOcWOftmZ7YKY0Vrc4ljLzPB0P2qtTzbONJae0EkUb5sQPkQDpFptx9MyEW1zA/G7RWSehxpoIcejcwv+nBhJzb2mbqeiYKTCJt/h1zlBGc6EWDeUZEmDqUmvhGo+kszx58Ly7rtpCpnJs4VuGdasZ6rdqEHZlWwsyK9LICLL+TaLEgemnoWFfFhR0Eyipj+y3nSort8RKvu3aq9Rk5Qvb6CLhyF
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
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++++
 drivers/gpu/drm/imagination/pvr_gem.c  | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 30cd34d3a111..8c07a8f81322 100644
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


