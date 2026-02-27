Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7728FD7F9C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3085A6B0089; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0336B008C; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5BD6B0092; Fri, 27 Feb 2026 06:45:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3C686B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90FE2596E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:27 +0000 (UTC)
X-FDA: 84490056294.14.6BBAFFD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5E3C914000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iZD6bhY9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7oltfWQe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wzH2Ju6e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="zZ5I/X7d";
	spf=pass (imf26.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQ4MJxAiFBMTT2WRhpvYhkkq8GMFlqB1g+OQwQf5gnw=;
	b=FrcNhklYPT3AR7o6w+JhlM6tu0wuEOJkIplFp4ehPL9E9IjMpiG1gw5Vvbd6XGTUdGPjZg
	sM0dEjtQfrEZstIohQKb5Wiwve6lg5ODzdxR4MoNqzUhxMlGI1nHpMdLXj79wz3qQvpkis
	u1DEuNNjyUzwOUDrl3kqLFy9N2KNFGg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iZD6bhY9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7oltfWQe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wzH2Ju6e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="zZ5I/X7d";
	spf=pass (imf26.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192725; a=rsa-sha256;
	cv=none;
	b=joawEPfixFlF04VFD6D+JTilKZj50pXM4zrt0+5XirnLAiIeFfbB1BDVBdt/FWRBPy3bBV
	cqgqUAG3nVvA7NEsoeEdnG1pVl0Z21v/tmUJCSiSxc//fMqNrUXIrRghtcgswLy16W/Vfm
	x2MXhFJIjdFqRlCmhtIsK2V3yxXHYBY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CAF223FA0D;
	Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQ4MJxAiFBMTT2WRhpvYhkkq8GMFlqB1g+OQwQf5gnw=;
	b=iZD6bhY9Ndpg1j4aBvaNgqzsAN51t7V7Qs6F0tMnFl8ov1CDC3nBs9hUS+4yoPzez0X39O
	OlELi29fntQR4rQBx+Toyut4OfS+SQnSJB0/3LeMkZQQpjSowziuBrVa0lEzg2/Ma7Pa+j
	rcJ2Zlfm/KbyahB/6QxRxfLx04IZtD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192721;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQ4MJxAiFBMTT2WRhpvYhkkq8GMFlqB1g+OQwQf5gnw=;
	b=7oltfWQebgmBoScDrPL+L1bysSEJGsntKyTjXcSRhPhN2/+6FGblHL7UJmoLZ1EaUAsnoG
	RGPpbPHPBA1+o6Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQ4MJxAiFBMTT2WRhpvYhkkq8GMFlqB1g+OQwQf5gnw=;
	b=wzH2Ju6eMv+yw+7G0m0xqJGuGTFNEXDH4TDux/t8kkLoueyJ4oUlNeYLlG+5oyQHbzDhrb
	oo7q3766HV7sY/hykHugP6xtitRdrHxR6PzmmXSK77tS4xhtRCp8TUi43Q4/IGexfsCetm
	McGeXJHSqLqwy5ATIyRKp8gGEVuYkDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQ4MJxAiFBMTT2WRhpvYhkkq8GMFlqB1g+OQwQf5gnw=;
	b=zZ5I/X7d2+kFUnf4Vv9m+YfYKWS9Tl3Lzvfbx0hHtLrx82QnsSpMFYKHEUfXGBGU3TntXX
	n/KvjmuazasfIKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E7393EA69;
	Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCaxHc+DoWkvOwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 27 Feb 2026 11:45:19 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: boris.brezillon@collabora.com,
	loic.molinari@collabora.com,
	willy@infradead.org,
	frank.binns@imgtec.com,
	matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v4 6/6] drm/gem-shmem: Track folio accessed/dirty status in vmap
Date: Fri, 27 Feb 2026 12:42:11 +0100
Message-ID: <20260227114509.165572-7-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E3C914000E
X-Stat-Signature: okix5i8cuqcw5b63ue5j7m1ggefuju1n
X-HE-Tag: 1772192725-467699
X-HE-Meta: U2FsdGVkX18SBxUcb9dUncxFGTgDBPgGpHN6RAp3jLzEUnXIIMhEDKMO2BE2e2h8/+AyV4fMkSMZv0dKWbSkyt6UIuwWvpWwdmUxTAy9qoqVmZQ6QSC9nKxFElrKzvw75pOOZtIE0LheMqbTxyphetj5MQaT56USC2+yIXlxWvd86Pvjesr3bOUp5+QOmRcm+s6bhAN7kC/i7RXFUu+FqvYmxbuWlGaERG4thDvogs3ufVqKDXc4/XrOIu65z+j4y1mogfJDc26nX/bDLsYgWHvWtbNv3UgYBWxAk43NQO9ogFOZ9ZJ8C51/zPMkiJZgVgb5OjYs+d14bSGiKyJhkItK84voJgPu3weee+JcI70ZhkRIe23K5CNJVRglxTTDNb7uLHcaIGwIbVFq1KKucs1yBkE8/i8IttA34yW0z0VSJIw3zxyOAiFrxYjlVg3fs0OK++xzLqmn9lZYpcqoJn8GSM9lvkEbcLfALgh9oLdhnSvelGPy5ftOVIH53cry/W3Gc7OVzk4aIZfDfzl+XuXZ9/fcYgWEXt7tYVF6DRpmDIxdgNIP9ThU7fbU4hPbzP7bR+we1G/WloGzfWe4R8iy/WPYJPXJkSXz8uYtZUZD/S8sMqJ0/RTbV3ytgMVQuNmnTd0yk8X5qov6rMguMlc4AO3MEYn+tXJjOuifNswhiIXuhttJ6G7TizUu2AZA5DP2/zN5dsJuJLqw42rWYjUfd5RoVXi5r2cjraF1FJUP9uVNKm0qn+Qv/583KTU4GveJQx06Y/s5vQpmDr++y81aedlW9ePpWrvyrCyr+hdQYZg0BJ9s5t3NA+pXFn5gdnqcO9tty1iRmU0qaB0u90y6DL0i6j+ew6c3Tm9yZljk9Sscnltwu9aSCQOwWdEaVW+TzOeoCTWNeXIZ27hfnPhMTQpVYbynOlauljVDDVqy4Krq/Dg04at6LWhbUmz/2toouPCUZzaGsz9UQ2V
 y45Twnb/
 jMO9CkJhob/KsiepjKWhwaVQyXSti8ewUtM6sSzSCl0gperKPjlOZQ7RGB8AhrwXAZ4XMgQSxSwYVrK+CCtB1JMMwJ4RuK3Y5Q+j5BvrD8SZqaJaps4zhwzUpOXoaFQvyUKZ5prwOrIjUv45omiBioi9xXZwNhq9sttFyEKAN2VqDgQcneoMcMbxRDmU+V2ZFAULE1Pv1A/EV/8MGM7tfxqcwbTSw9GIomxRjPf4vACqxsls6dvMuwZERrimAZMzHilGk4jVtVlW58XsX2cWbOXmTChmSbsFHsBJ+V0MLaT6PFCJGq9op7RFZGwvVhHpSUOaKC1v8a3v3WNawn5gE7i3ud/sDExQ9jzA3rEOz/vjLafXOo7RSYaR9DB6ELLE36MJp
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
Acked-by: Frank Binns <frank.binns@imgtec.com> # imagination
Tested-by: Frank Binns <frank.binns@imgtec.com> # imagination
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++++
 drivers/gpu/drm/imagination/pvr_gem.c  | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 1ab2bbd3860c..4500deef4127 100644
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
index 686a3fe22986..d8660d6a8e01 100644
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


