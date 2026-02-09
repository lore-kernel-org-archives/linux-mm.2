Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A52E81BB1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7F86B0005; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7724F6B0088; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654626B0089; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5297A6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:32:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 022EF160183
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:49 +0000 (UTC)
X-FDA: 84425008500.01.9A77517
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id CBBD840016
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bcOt/W9z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YAk6Ylx6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bcOt/W9z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YAk6Ylx6;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TvEFGTp96ydlVlsv0yU/yvEpwTdFsrcKq6W5DxA6k2M=;
	b=4znSv4KDlO0N6vwcXrkU87bY4ucRTszjGEurycZyfP2axaWcpjgsCYCaO+9vA+x1Z30FaP
	i2F6AkpH0PKPhiO2FVxVK+PnEZhsf10qwlvejFbKUD3EmXfX1UoJdLpoxBhhicBCAp3Zog
	iiupdRPRuCOEBPrZ6swV+xP8KKdG6M8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bcOt/W9z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YAk6Ylx6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bcOt/W9z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YAk6Ylx6;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643968; a=rsa-sha256;
	cv=none;
	b=GO1eSV+paoaa8qWu1IPfcDleEah+bdZJOCuJ7/NSc3E/SPbofY3PqWhRqJ+4KhxNzOcdxt
	yL0xtSzhSzOlZJxsQshYsIK/k7IGhqnBF/xRWcL4Rp0iaehWO0wz/h83kwBgg3uGaM4Ed/
	ye9cOWbvjCPNcZbHdnUuFLt/NaHWa+4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 19EFC5BD2B;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TvEFGTp96ydlVlsv0yU/yvEpwTdFsrcKq6W5DxA6k2M=;
	b=bcOt/W9zrYkQADuDIfzbXYzl7zq1CdxN6czvOtBQ0VGdT4folRQaQQN+IeCKHLoeU+pqzB
	kHcquuf0LFPVgzxom2JgZKZZFCq6vCsQWTlOW4vEL8txsFwgSnkPpwMGGQE0GDthrBuFLV
	loKdPcylWaPrXUP6W3u/xdcX9b952y0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TvEFGTp96ydlVlsv0yU/yvEpwTdFsrcKq6W5DxA6k2M=;
	b=YAk6Ylx6KnhX8FQ1CGUpi1HY0RpKSG6wpBbouy2iZUo6wymKPt71aKo6HlDSDb6YY+eUXu
	IzqYSwUyheJ97mCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TvEFGTp96ydlVlsv0yU/yvEpwTdFsrcKq6W5DxA6k2M=;
	b=bcOt/W9zrYkQADuDIfzbXYzl7zq1CdxN6czvOtBQ0VGdT4folRQaQQN+IeCKHLoeU+pqzB
	kHcquuf0LFPVgzxom2JgZKZZFCq6vCsQWTlOW4vEL8txsFwgSnkPpwMGGQE0GDthrBuFLV
	loKdPcylWaPrXUP6W3u/xdcX9b952y0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TvEFGTp96ydlVlsv0yU/yvEpwTdFsrcKq6W5DxA6k2M=;
	b=YAk6Ylx6KnhX8FQ1CGUpi1HY0RpKSG6wpBbouy2iZUo6wymKPt71aKo6HlDSDb6YY+eUXu
	IzqYSwUyheJ97mCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B688E3EA63;
	Mon,  9 Feb 2026 13:32:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1vdaK/3hiWmTIgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 13:32:45 +0000
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
Subject: [PATCH v3 0/6] drm/gem-shmem: Track page accessed/dirty status
Date: Mon,  9 Feb 2026 14:27:09 +0100
Message-ID: <20260209133241.238813-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5cuyffjmak4qx864k8wr13nqjfisitwc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBBD840016
X-HE-Tag: 1770643967-60361
X-HE-Meta: U2FsdGVkX1/1eFo+K+2N7Gk2NnhEp42zr0xGzUivz0c5m+dVvrr1aetktcW/wqVYH2Wi67+q/TaVJoz+wmTJLgEe8IKB7/UeE89JGpYs3NvuNw2IoUXR12kUT5xu4a3gQJlMBXXukFvUV02+p3YbJq7484mvepaEr/VJNXsCVCMNhjgz0iQ1q6SBvrCajVqRsrcQhHC4cBm8j27iCR6TVqtiVs0AYwvAchLIjp8STsVoyXokk/oovp1ESGN3RGIcT1bnU/XQ5zsH8e+o6HYosD/22BbTx80hMcEBR3GwchuDg8n2g+suJyVYZI/y8wzfvfYql7VqOFbCXGvqoQqWjHDZMIFXNxvfVhdGd9U38QUovgXJote6hbrNhKND5xM8kxf3QuxzlegC6Yz3zF8sDKu04QfLIgQBCOOZmjspeguCTmMXukgnEoUvEpFZWYJPoZ3Ho0VKNNvh53O6w1avXmncxM02p9QFvfHREzcixQPNnkDezyruoipao7GIttyZFGF4J9c7t4ROUzlt65Ad/NVSm3SofTRPc/kLZ8RKUKhOix9c6l6VsBvNtAd9L4ktGSn8nbprV0/teI4vpUP+fFPi4HPq++PNU6DdyESrVTMEMLeIv3dhdMAbPn1eZK7FfwHMt+z6HLcI/uBsrzvDgTQN7Sua9t3PVRQFIjBQQHgnSkpeqT8A4ZcFPHciB4Zj5sN36Of+jvdEhyBJ45mMrw7zwP8sxX6q73PCLVinKplro/0fGIDJJ9KElmcRdT3iy0QzM7VqjoqKXrQDapttzIUiTkXaSqq0zfKJ68nvpojZk3JNEYX1Df2oXhvBS+5Bt6C82hAdxiXKwy/RzGgPFS1nAPtZ6u8Ai4F6VhbB8P5uLxZrnTI8RIP+jiBNRLa7o64wal/IPpC+et9Hz3JGQiLW2zNhWyDQJ/ispytx7l+CswXvpVAFzu9dVBX1JkmLj4D/ipAFVJUMsU+kGaz
 vPIrf9Em
 u8r1Wu38LFZ+J0UCGGbD4CKCAQ4/8QVdvoZ4io5c7aKLrBIp87Dbmtm4MrNVkIU0TZqIVxRrLvBIA5Kyc/nz2hyRQqTvSLZLr0WvAw/Mj/m1YkLwWCpRgd80TtYztE6d2/BfKSdsqYKy4rQZuBtBUYgUNQ7psChaoq0FQKP0iIyu6azbtR1KLrbGKi5NrVvkbJo+ktT7fj0/kx8hCsLtOn8zKfy7gQZGMtbVVRuInHnU2YDlObSjD3NvdKViLSybgBAlkZLviBcL8ZG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track page access/dirty status in gem-shmem for better integration with
the overall memory management. Gem-shmem has long had two flag bits in
struct drm_gem_shmem_object, named pages_mark_accessed_on_put and
pages_mark_dirty_on_put, but never used them much; except for some odd
cases in drivers. Therefore pages in gem-shmem where never marked
correctly. (Other DRM memory managers do some course-grain tracking at
least).

Patches 1 to 4 prepare the mmap page-fault handler for tracking page
status easily. The pages are already available; only the mmap handling
needs to be adapted. The way the shmem code interacts with huge-page
support is also not optimal, hence refactor it slightly.

Patch 5 adds tracking access and dirty status in mmap. With the earlier
patches, this change simply falls into place.

Patch 6 adds tracking access and dirty status in vmap. Because there's
no fault handling here, we refer to the existing status bits in struct
drm_gem_shmem_object. Each page's status will be updated by the page
release in drm_gem_put_pages(). The imagination driver requires a small
fix to make it work correctly.

Tested with CONFIG_VM=y by running animations on DRM's bochs driver for
several hours. This uses gem-shmem's mmap and vmap extensively.

v3:
- rewrite for VM_PFNMAP
- do more preparational patches
v2:
- fix possible OOB access into page array (Matthew)
- simplify fault-handler error handling (Boris)
- simplify internal interfaces (Matthew)

Thomas Zimmermann (6):
  drm/gem-shmem: Use obj directly where appropriate in fault handler
  drm/gem-shmem: Test for existence of page in mmap fault handler
  drm/gem-shmem: Return vm_fault_t from drm_gem_shmem_try_map_pmd()
  drm/gem-shmem: Refactor drm_gem_shmem_try_map_pmd()
  drm/gem-shmem: Track folio accessed/dirty status in mmap
  drm/gem-shmem: Track folio accessed/dirty status in vmap

 drivers/gpu/drm/drm_gem_shmem_helper.c | 77 ++++++++++++++++----------
 drivers/gpu/drm/imagination/pvr_gem.c  |  6 +-
 2 files changed, 53 insertions(+), 30 deletions(-)


base-commit: 0082025812a31eda451fb14f13f52683ed375c49
-- 
2.52.0


