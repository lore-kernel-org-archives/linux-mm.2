Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7078FD7F9B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130F56B0005; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB616B0088; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16486B0089; Fri, 27 Feb 2026 06:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D984E6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8978F596E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:21 +0000 (UTC)
X-FDA: 84490056042.29.5412319
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 65EA640005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H4PI4KFH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YH4nUxPM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H4PI4KFH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YH4nUxPM;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WqPTmeNq7sON/3a+VjuemHeLHXm7tf0SOCLHD2wJBGM=;
	b=7t/zBxVA2Xh3eYgsnqlsqqO4rmsVFRx5E2/1Puv+D4h4870X/o/0U5tpOZtMPHEcEz7JPk
	EnusrqwoFPxFDIpMFwUYXFOGLarjJp7vy3FF9cvYU4hK8jZ8F3zE1DNvkVPFFnLPgNKnJO
	NM1RuKrlEHRTSpJ59aPtCJ/QRjXAWmM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H4PI4KFH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YH4nUxPM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H4PI4KFH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YH4nUxPM;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192719; a=rsa-sha256;
	cv=none;
	b=vbOSzMEeowLsrMfTgf/gLphphmc8noUEQVFYDHbD6oy9ruiqoDj7I4qQLdHmNdluoENjDj
	BWq+EmrAj9MbmMpk7TLBm2GkCtLCEomxfppmU6DeTsrr71B34nCLb/cTcbHM/hc62mKarO
	kpymqrznc7I2gwYKByeoJC6v0O63wXc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AC5C75BDF8;
	Fri, 27 Feb 2026 11:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WqPTmeNq7sON/3a+VjuemHeLHXm7tf0SOCLHD2wJBGM=;
	b=H4PI4KFH+Mu/VOTpCb9uvedit0dx+64UHTmcrI/NStLNE/2iT6aRAurs0cdRnthGg0H/Ym
	UxbJC0Ya00ynnS+rvXJQiXn07YGryVtHrtqR63pzccWf2dqH0TjRkLyP3B+TjqlKY3p80h
	9JmLdQrJK+6LS9as1EFNHuy8Yi6hCS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WqPTmeNq7sON/3a+VjuemHeLHXm7tf0SOCLHD2wJBGM=;
	b=YH4nUxPMkyAM6TP7Jfv2Aj275ftoXr1B4/6i5b49AKI/qdZb1q6/01ULRMSV9rBNLc3qNu
	XFoIUeqxr0aiFwBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WqPTmeNq7sON/3a+VjuemHeLHXm7tf0SOCLHD2wJBGM=;
	b=H4PI4KFH+Mu/VOTpCb9uvedit0dx+64UHTmcrI/NStLNE/2iT6aRAurs0cdRnthGg0H/Ym
	UxbJC0Ya00ynnS+rvXJQiXn07YGryVtHrtqR63pzccWf2dqH0TjRkLyP3B+TjqlKY3p80h
	9JmLdQrJK+6LS9as1EFNHuy8Yi6hCS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WqPTmeNq7sON/3a+VjuemHeLHXm7tf0SOCLHD2wJBGM=;
	b=YH4nUxPMkyAM6TP7Jfv2Aj275ftoXr1B4/6i5b49AKI/qdZb1q6/01ULRMSV9rBNLc3qNu
	XFoIUeqxr0aiFwBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 573463EA69;
	Fri, 27 Feb 2026 11:45:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rdLqE82DoWkvOwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 27 Feb 2026 11:45:17 +0000
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
Subject: [PATCH v4 0/6] drm/gem-shmem: Track page accessed/dirty status
Date: Fri, 27 Feb 2026 12:42:05 +0100
Message-ID: <20260227114509.165572-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65EA640005
X-Stat-Signature: m6b9wubi4rb5rq4wzy1s9cfz8s8jk1m5
X-Rspam-User: 
X-HE-Tag: 1772192719-514396
X-HE-Meta: U2FsdGVkX18xKHcRFDyX6KnvVvauTW2KldVSfYahKz35nZnwdxM9eFcZzww/jVJXlWXeoZ4wW8rlmhyFIu4M9+Z339q0WVSodEmIDniQNJxbna14oY5HaZA5/vuJnOA1frXNFpp8bk3qymbRv6lhSK5ZBr/H60r+Ry8oxDGNvUQ5SLA0NyQfmnU48GOlMZ1f+oMZtwlrqA3e6+Xet3xVxqQybmNpmLDZ90dufxqXFXMKvZdLBwnVrjA+3PI+SZBvkftDlxS6x+b7iU0ae6LROJbEYF5PikSgGXJpA5DdZgXJ1f4ljCDjGZn8demgYZSDCEp+hJgURwsJHSxSPjPeQLwHOY8XMEyzStdJHEUVfC+1MEtq1bTjc18kTqD8R1tdUNM8ru00BGoMZsLjbfZqhYd9dVD+u3K91x42MRFXc95b7/D1t9Px4lTbL3zaP80kmgreIRO1BkqyLBGZFU8VJlCYPEp5NLCFazH2EiQK97Gf3oosQLgV5PLlPaerz59I+O0UWG98A999ihseSc00lM0XrMjMcQsrUySZV5i60zkcQ8jRv4ek/rT2u+lzlwoDg3h9e+NzSNIZM2NQHHlu50YZn3fdcibltoqSLbbYhaML6EaP0bYvp4gJWP3dezSwO9iNT53DgBbi3Mu6laJIFVICZgU10PiwsPIFRnHbfxxAZyJqozi9ODTjyx7hAnOcCqZya3n4VLQuJ6DP3HF4kTcK10zwM9tFtxxZKqbcRnwhNIdYUWXjiTC/gpA8z54vCp+xA+ju4ikCc1NDffxSSoIQEkc/bqY2RHBjb+WfuRMYkVJxaktyHUzqE/QR2ZR7bVohBkflZEIz3VARjd3m7d1+EvFkmyljfk5l2iFOjWLmu17vDvP3VkkgbGxyoj4IAdb4thPL6ThbdxdqdMD3GM0XM/RIeF8sIZhjuxj/0vScj/aOiYTz+03BVoogXfVs1E+Bxk5VJBS50Z45u5m
 x9VrCxJi
 Ehl4FVBWBscsJgU8skVtBJxEjkubT9snnIiRkFoY91FvmcIsv77IDnu9csoYar88IG+RaqHG1+cZu2QJcIQlXd2pd0rNGZWvCY0in33zQ/nue1xJb8zQzQaEyc08UToTXa8dbFHZpasinIjglbP/AofI6Iw7a2lAbA3B2UNdlJpp3z13YRhX0Vi98WZkVqBEIB1cwCjdtXgbou0y3UjxPjQNmp9ScOYgNt00J/2DyUXnYldhXy2MoHuDCRMAIQLkPObF97VQfkoFV6Ak=
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

v4:
- mark folio as accessed on VM_FAULT_NOPAGE (Boris)
- validate state in mkwrite (Boris)
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

 drivers/gpu/drm/drm_gem_shmem_helper.c | 79 +++++++++++++++++---------
 drivers/gpu/drm/imagination/pvr_gem.c  |  6 +-
 2 files changed, 55 insertions(+), 30 deletions(-)


base-commit: 1c44015babd759b8e5234084dffcc08a0b784333
-- 
2.52.0


