Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F80E9538F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3F86B008A; Wed,  4 Feb 2026 06:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4276B6B0092; Wed,  4 Feb 2026 06:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326086B0093; Wed,  4 Feb 2026 06:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5226B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:43:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB4551BC7E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:50 +0000 (UTC)
X-FDA: 84406589820.05.8864D4D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9844540005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TkoTBGhw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2XnaBmnn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TkoTBGhw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2XnaBmnn;
	spf=pass (imf04.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H0YQz7yGZa2dBh0t63INAhBCyN0lT+6KqiL7HbEcoXg=;
	b=IeMhfwfB+BgVjomiMJr1lkNRsbTaFfF8kq7VTSaxNvnBNPxkV59jkG7E0FF2ipnSrV97bK
	xOrpwuTz1M9SZHYEbptv4G1nzrm4KzZGDFudXJnjNbbxQ+RThgc7IcfuFzcG74RPWvoWBk
	XpyeDwo+C9SndtvUNN56r5c/9k7lZDM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TkoTBGhw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2XnaBmnn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TkoTBGhw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2XnaBmnn;
	spf=pass (imf04.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205429; a=rsa-sha256;
	cv=none;
	b=uM84gs10H7FWRmJ8N6jzPdEQXug4J40+xRX+Eo/2mbn2NYAUfwKvKINN6NbfYX39r4aZuB
	ngq8UFHDxvO+R2ip8ypuWkaO86UbysJWCwLl9dxPz1lBWxZ3iblMpsPBfO9njMdjmLwVBn
	9VhWIP5ePUfcpZvI3Rcpr2LL/p+xwi0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D5D753E705;
	Wed,  4 Feb 2026 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H0YQz7yGZa2dBh0t63INAhBCyN0lT+6KqiL7HbEcoXg=;
	b=TkoTBGhw8Qis5HsikfP9U4fDYPFCnUs4Tq55SWgbUavWAGj9aUXxd61DppUEv2WiHJOTov
	2o8seSo22Zw4Ws04oJVvlumtoHNEJyXk8lwxyHLQanSS0aHvyvGYuZ7s/pOE5UlyiDnSdh
	iAw5/lZUBT4Yhh85I1tf0Ke3zinnApk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H0YQz7yGZa2dBh0t63INAhBCyN0lT+6KqiL7HbEcoXg=;
	b=2XnaBmnndTUur05lZy1sq+rH57iAdqgRpwHohjBnHGADIn41v/YGiUyXxXEebC4FtTQ1wC
	FarPBZr1/EWI7nCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770205426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H0YQz7yGZa2dBh0t63INAhBCyN0lT+6KqiL7HbEcoXg=;
	b=TkoTBGhw8Qis5HsikfP9U4fDYPFCnUs4Tq55SWgbUavWAGj9aUXxd61DppUEv2WiHJOTov
	2o8seSo22Zw4Ws04oJVvlumtoHNEJyXk8lwxyHLQanSS0aHvyvGYuZ7s/pOE5UlyiDnSdh
	iAw5/lZUBT4Yhh85I1tf0Ke3zinnApk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770205426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H0YQz7yGZa2dBh0t63INAhBCyN0lT+6KqiL7HbEcoXg=;
	b=2XnaBmnndTUur05lZy1sq+rH57iAdqgRpwHohjBnHGADIn41v/YGiUyXxXEebC4FtTQ1wC
	FarPBZr1/EWI7nCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70FF03EA63;
	Wed,  4 Feb 2026 11:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xGtZGvIwg2ldawAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 04 Feb 2026 11:43:46 +0000
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
Subject: [PATCH v2 0/4] drm/gem-shmem: Track page accessed/dirty status
Date: Wed,  4 Feb 2026 12:39:28 +0100
Message-ID: <20260204114341.195143-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9844540005
X-Stat-Signature: n4esoc56gmfy6kk16w6i9bgc9joiegwf
X-Rspam-User: 
X-HE-Tag: 1770205428-624525
X-HE-Meta: U2FsdGVkX19uOOfZIkylCx8wUSEzH3wpdOkl/iH9/3tPxgg0aFRjdIDTrtvb42N6qUYBU644Vu+cc9/a3UZfdtLtTjD2btGlDH1MSOa4GUl37ioZ6PZVc5MhiYrEs0dBoEDdh0l0xq/U8OcAblC7UZFXvJotkqWlQKhdZlfwEzLv+KI1DvcUGEHi8iqYN2VOuuHZTSJMMQcrxC1lJUzJlIQ5LeNvXmngqaLNNqhXuTd4y/ee/SSveINIJn+gSI1OkbamET8y9wY0v1/iJOKdGRK9tdjvmh7RPPmjk/3rF5qeE+dyrU6bvnAdslZ5Pb3q/gx/6vYqqFjeDfp/fMFoBQ9soTft2zTVr3cwc30h+FByVdzougAwMzNYBud1Fbwn4sd7yDcHaBq7P2DSN0koF6SQ52FR3tqlzwr+otRMaHIICakksQ6oM0AYvIhspJtK0Qq2lDN033nDmesT9gPqVn6Toext4n8Ukv7OzLA+z6+OYh4yHaUG970fKclQu6sOs33guio9IHzAIHNYGefecDGLbkCyBWi+2L6m8491121XDiEU/GlKXYCbvdzqoMJ2BfPC2Gi/zuqfPuMyQ+iTQ27b81R85+FTHD5TsCK8yRt/fXVxxA/4SOUL8b9aUDyP9zhwuL4uTFb6qATzdma8xFYB18Du0CmQWTLdLnJuYEQkd5uhSMAvBaqEE+Uc1LmykIuHLEeaWjW7WFjWKhCzJjF71sDiqKSzPZCLs3QTJw/HYabLZvM6Yr6klE5qWFJRsXkr2S6nXSOKjFzwd9k2WigIgdRqu6oHlyHfRYp1zMS0ca3vvr24VGymmk0N/6VSkpzvACY1Bh3+cORd6af/nm8q5I45oxGypnF6FKhrIFHVLrujkD11q0Bj1XwUqKmJQXTkwfDjH3XmyFUOWyAcen8uqY4+3OvK4CGl+Z/43QROkDvh+JEOZVKHMbpTS+JQTnYNyitJmZ2FaTxHojr
 Z6ovcqp7
 X5e/QuUkPOjgE5L1JG4c/dfTfUiPRCYjvHUcxY1dldiSGpo9FikMsoiDfd4TCn7MUZBWkSilpxA0y593RqkbtNaNzGLBnPwYn3rUHncoR+aPr9n4l/7A+3Jlt0fuxdI+OL/6HMzq/7HwUIKDfpX8caIHcMxteif/B9nZflWWubCVKEEbqgQX5+UBhQMfjHMhl6Sf5Zx82rn5FqP2eCEoIvkiTd+CUE1ZPJu7zBAQa5OL6eEVtIbBv0XKwPNSAJQZ3v4ZJYtTrb0r5umg=
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

Patches 1 and 2 switch from PFN-based mapping to page mapping. The pages
are already available; only the mmap handling needs to be adapted.

Patch 3 adds tracking access and dirty status in mmap.

Patch 4 adds tracking access and dirty status in vmap. Becasue there's
no fault handling here, we refer to the existing status bits in struct
drm_gem_shmem_object. Each page's status will be updated by the page
release in drm_gem_put_pages(). The imagination driver requires a small
fix to make it work correctly.

Tested with CONFIG_VM=y by running animations on DRM's bochs driver for
several hours. This uses gem-shmem's mmap and vmap extensively.

v2:
- fix possible OOB access into page array (Matthew)
- simplify fault-handler error handling (Boris)
- simplify internal interfaces (Matthew)

Thomas Zimmermann (4):
  drm/gem-shmem: Return vm_fault_t from drm_gem_shmem_try_map_pmd()
  drm/gem-shmem: Map pages in mmap fault handler
  drm/gem-shmem: Track folio accessed/dirty status in mmap
  drm/gem-shmem: Track folio accessed/dirty status in vmap

 drivers/gpu/drm/drm_gem_shmem_helper.c | 77 ++++++++++++++++++--------
 drivers/gpu/drm/imagination/pvr_gem.c  |  6 +-
 2 files changed, 57 insertions(+), 26 deletions(-)


base-commit: 6e53f6296065672f8a0c7f98b4b6c409dac382b4
-- 
2.52.0


