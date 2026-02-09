Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE58E81BB1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DA26B0095; Mon,  9 Feb 2026 08:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D080D6B0096; Mon,  9 Feb 2026 08:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B086B0098; Mon,  9 Feb 2026 08:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B28216B0095
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:33:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EF7A883D0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:33:08 +0000 (UTC)
X-FDA: 84425009256.26.80D44FD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45962140011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:33:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AB/CB+R5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QdC+LQMt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AB/CB+R5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QdC+LQMt;
	spf=pass (imf23.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YB6wcdxYC1S0cRTRGH7xoYsaaN7Iec7M/6rkPvaj4sE=;
	b=8ONvVzNBjA3Bhontl86n8b/fzrds8TcIgKdo4KG1vDJwvN0GzXCfCBQ0TUSELmBmyjbu7r
	ED/bEC9fmk3u5B3G9hDDK8hYaREfuTivWaz2/059EkV5VAqUJZXtPjVh2Se32rMSLwZB74
	gFY9oYmAVd+kQjfAPlhIg0VF5UR2zP8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AB/CB+R5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QdC+LQMt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AB/CB+R5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QdC+LQMt;
	spf=pass (imf23.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643986; a=rsa-sha256;
	cv=none;
	b=0eOrRW9Ho9IOrCR3QO0rOnAyx+sNdkBtJPmgtxpwiZPHI6z7GW9E2Cp5TzwkfYJ2k+0R/C
	QIA+U/i/k0OghSj2PA/OajRmexq5NnqDNaGGKP0XmVRYYXdIAkRIX0Q59Y4ceBOmHeOS8n
	8DdEWMcHlt7B2VdHgJnACUJkQiD7r1A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3251A3E71F;
	Mon,  9 Feb 2026 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YB6wcdxYC1S0cRTRGH7xoYsaaN7Iec7M/6rkPvaj4sE=;
	b=AB/CB+R5TCGlQu/7coyp/weZFxcglHN0o+y9d8pZ1zFTgVSfK6nfDrGnlfUWsAoFqdLruq
	pw7HU8Yq01CL4f86HaEPi4JWdmWWMCTnacu6FIwM9pPYxMKajHp7rdG50nqox+B0nKEGZr
	6cYPBZc0ktINqzXhp7GJ8bD9w43AXIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YB6wcdxYC1S0cRTRGH7xoYsaaN7Iec7M/6rkPvaj4sE=;
	b=QdC+LQMtgs3AP9XNAAA/GEoENdaiP+UKOYvSSXFpv2aZTn8KnMKOMHBtJzCwzFdom4XOFY
	ukSJ4oadWW8/rJAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YB6wcdxYC1S0cRTRGH7xoYsaaN7Iec7M/6rkPvaj4sE=;
	b=AB/CB+R5TCGlQu/7coyp/weZFxcglHN0o+y9d8pZ1zFTgVSfK6nfDrGnlfUWsAoFqdLruq
	pw7HU8Yq01CL4f86HaEPi4JWdmWWMCTnacu6FIwM9pPYxMKajHp7rdG50nqox+B0nKEGZr
	6cYPBZc0ktINqzXhp7GJ8bD9w43AXIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YB6wcdxYC1S0cRTRGH7xoYsaaN7Iec7M/6rkPvaj4sE=;
	b=QdC+LQMtgs3AP9XNAAA/GEoENdaiP+UKOYvSSXFpv2aZTn8KnMKOMHBtJzCwzFdom4XOFY
	ukSJ4oadWW8/rJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC0403EA63;
	Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qO2TMP/hiWmTIgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 13:32:47 +0000
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
Subject: [PATCH v3 6/6] drm/gem-shmem: Track folio accessed/dirty status in vmap
Date: Mon,  9 Feb 2026 14:27:15 +0100
Message-ID: <20260209133241.238813-7-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209133241.238813-1-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uygzjwtegqgzcg48n17jdxh76fhp6x86
X-Rspamd-Queue-Id: 45962140011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770643986-83122
X-HE-Meta: U2FsdGVkX1/p+cMVXLAYXNAEud0GHIlY83+o7S53KhPlLJfoO4qaIVMezEyJlBH8yTkA5jmBwxGKqeKdpfhZryiMp9qKv8GyPXq6EPz9GCDqBSkUsxF5l96Eab5qtZRwthspeM/ok8FKGy5VR/e9144xJ0+tEwpouZm1NLGlYr0+G5r5eRmnu2K33Zuv4KkQeKxGjjvTdCI4P8vETEbn/IL3y2Zy7QTAkq6rP3uoqvPYPtzTDdVfibd16R0rDn/DQ/GbiyA8xis56gSC+/a4HXv3HDk7MWeadv7X6p05t/5Hshpwre5+zbM9X72YR/Wx4T7kDZhRBApOwMbUZebEsGuz9x9h2n6ChCuLKDHdZaXxUEVFI8onPlGaBAnl/fjKxPvP7DwMHvKCKeSYZL4MYHoG3qyHVWl5rGg/NAppepMC7eWUOP0PlJ+R32aHUPEV4bzsyFQAYWNPEXw2dQ6RGr/oYknBWTHZp37ezd66GgLGD8hcfyPhGDQtnCopb4Sq5j8eG64zYL08P1CHIH5FL6F0Hokoz+lsf9FKZomkZG9VDz04t2PWQuAY0QQb7yp2id3vwLjAvpIGsmLdWJdj6tFH+hd3PquLD0olsyvol06bpDRfcwzBpgSeL0/AjRc7FVi3ZnneW/105m5ZGwApzE9UvDL342c5fLzq35T7sTw9/MK8liL3LLWlmIBg1Yo5iUHf/w5u7TltQtNV82oRceNUudKhHmDtnqVQ6ZDlmDESN85CP+CTErkfQp+7n9U0ajUnH+0P6Mx1eqs/FCYbRVJ726KJJYjN7LxtFR8xV4z/jXzJeC+DtdaKsvAZBXojY1/1pq/dFn3YVLiV8D2BkADyrvkABwq0rvpdETRscyAH1jkyUaD4BG8oDeAB2iocTnvSSVTAKLsZi46v4d50OIppP8URJ0bov46p1DIJT+gCPXIZpd64Qz6l5YwI+rHFVldYGjZyF5tnG9ll0EU
 vMI+V0g3
 ptFxDh200iiHrlaBv2n/oo6UdW0ujIDFIoud5mFDh26E3qsBlqneyWOMjWn/lc5wznXbefot+6M5DZr/h1Pb2HYJbCVBf95HhcfEP15X3orCQtMp0XJeULQfY/UbF8iHBqRgutVIkaewnksbnfnELj4iMsab2sutxMmDBvh/vmJNZPwqT7Ec/URmAd7qkqJ6rBCl16X/jDTtAoxtcQVb3WtRXHeXtRSJXmtE2uY4w/JxsU4LMxcNNOTHDQLO2n6xvhgWFFda6p3yNSFkzgkHeGgZUvhlsI6mkrm544M0Qm1oDFk6LaJoGOB8NZ9iE69bh/Qi8
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
these flags on put, so that the buffer remains quiet until the next call
to vmap. There's no means of handling dirty status in vmap as there's no
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
index 0c86ad40a049..dda9af9bf5b3 100644
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


