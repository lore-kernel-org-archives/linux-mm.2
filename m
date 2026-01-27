Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00939D2F024
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C045E6B0088; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8236B0089; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C426B008C; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 928666B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:29:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD01C010B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:50 +0000 (UTC)
X-FDA: 84377826540.08.842BBCD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5B6B160005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:29:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IOPQMS2Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XcYQOodV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IOPQMS2Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XcYQOodV;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X+zHkj6yM3JIgfMB0TlN78WMb207/ngpieFyQqSY2RA=;
	b=rHOKcuJQ8v4PpcHi78LK6SmsP28c4+NAa903pJ6ImDIgIDIWw+N0a2sXAkqe00BWlxOvW2
	StKnAsT4YvqN3urVMEnDvSegSDj2TbAZEC2C1lURuz1KwmfQ5NheXZcHCU6h/0NaLYzgz7
	Vrk+Rjef28FMZNu2T0+KWBoDTSmt2oU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520589; a=rsa-sha256;
	cv=none;
	b=SdAJr4C7EAWalsmaK8NXSiDLqMW06NnQcQaDbXt5TrlCp4VhXk93ubEUHHTcImapu19J+C
	1/ZLRz9huTsYZs5nPVuKpYLQXT7C5mmVeerqPn1dp0adSNWB4M2agjQNTrQJBmyYh/cH/c
	V6Bo75DWKe3x0w0oXzLtGlvPWGky2Pg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IOPQMS2Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XcYQOodV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IOPQMS2Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XcYQOodV;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C7BE5BCC8;
	Tue, 27 Jan 2026 13:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769520587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=X+zHkj6yM3JIgfMB0TlN78WMb207/ngpieFyQqSY2RA=;
	b=IOPQMS2YH2yJ7NHobWKtb6f83vkOWAZQXICwiK+oiKxrlNXUFcbwi8gHgZ2mnfMYAPFaf1
	Fo/M0HZApdDZOSe4HkwCkLcY2eDc+HTYtT9wGfcO3oOobWKzS1um8ZWmNKEuUnnJvLHgc3
	KucRCrsqm6Fg7IUOpzkRntgHuM1GhP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769520587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=X+zHkj6yM3JIgfMB0TlN78WMb207/ngpieFyQqSY2RA=;
	b=XcYQOodVtbP1jMYJHp1lfEgNBEQsxrb7SwLRc81H8wkfY1YVVpjrbJgLUhIM6maDPiHHM/
	Zjod4t+ClZ2SYiAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769520587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=X+zHkj6yM3JIgfMB0TlN78WMb207/ngpieFyQqSY2RA=;
	b=IOPQMS2YH2yJ7NHobWKtb6f83vkOWAZQXICwiK+oiKxrlNXUFcbwi8gHgZ2mnfMYAPFaf1
	Fo/M0HZApdDZOSe4HkwCkLcY2eDc+HTYtT9wGfcO3oOobWKzS1um8ZWmNKEuUnnJvLHgc3
	KucRCrsqm6Fg7IUOpzkRntgHuM1GhP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769520587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=X+zHkj6yM3JIgfMB0TlN78WMb207/ngpieFyQqSY2RA=;
	b=XcYQOodVtbP1jMYJHp1lfEgNBEQsxrb7SwLRc81H8wkfY1YVVpjrbJgLUhIM6maDPiHHM/
	Zjod4t+ClZ2SYiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D5053EA61;
	Tue, 27 Jan 2026 13:29:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /n3fAcq9eGmeDAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 27 Jan 2026 13:29:46 +0000
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
Subject: [PATCH 0/3] drm/gem-shmem: Track page accessed/dirty status
Date: Tue, 27 Jan 2026 14:16:35 +0100
Message-ID: <20260127132938.429288-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5B6B160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 16ku4rp7gu4nwn5fugqax3wjot6bwmpk
X-HE-Tag: 1769520588-382535
X-HE-Meta: U2FsdGVkX19D36Nwj7/mnl1MoxIRFyu/NAq4lXpKXVXi0cLyjzFwrJty+9lXTKE5s4n/LKJD7j7F2FfR03JE5NQPq6DcW649TpavPKnF+hclLuTrzoSSCd3h5PNy1H2l18s5Ea2nIJcyqiz519cieC5gZ6C5jQZMiXAAuqSyBWmU4qi0nWfDbPw5wn0luLecOEvVq6Kv64Vuehbe2g0GWt/QsTmxf1Hzo9Wtixhv4n6A53vqAa29mqXTljWm/RkJ9De2I9aj42QZhIin0DUh3Ho2dm5M12TySw46bMvyW2cTc/Ul4UlMzbovWIZByywY5tsHmu+/2bSasjSxzKf7Z25s6kvhbgA8PmpWdcJjSXOq79GzIyWLaj5ON6NO+RlkExrKskyGzLCWhRDbiWGBxbiQo/KoLsVBdADvIma6rGieXcMKjUeR3vu7Uw5gsuVKJqnhU9/b8W3kZIHj4mepfGwdWYXGfj/8ts56DXmQy7SyfSnzMoM2EDbQuPx56nUkTbj6yxclL0MLdDeJ8Yg974r+JmAQQQ2RciVrxoXa0FfHkOOYi+vqs7IwW42CdA0TL7b/uXB0Tg8o1R9IyiL0fzBze0O/GMtqUkYZGKEcCBD4QY3id2vHalwNdvrOONn0M/UQhnDBJNuwUW+GTYiE2WT+kQQ1DGK7lOXmNYEY3R/RRfc6uakpXmYkzMUbpSqwS8kG3LQ9aIPX93EXD4BvNjs2ZlGShe3lbjiFD6fTorTPLCiBmr1ieE5E7tR4/L8QWlS89kiBRtVf9l6uWO2qtUpKpkcalgcJPCnBPmWIloF17G03ELhcls+RHZYQu2VfIYMA0wgTzr9kNi0q64uRM7L4sL2lN6e8G8rPAyEs44VZ93Z+RvbaO5MM0TWdAp1T34erynhzFWTB9ggV0C5dGi53XpPZYbmvljBsTp1lSCwN2JJxTgYUM0qHPSQnE5Dh4L+tPk0VmtZSGh8ck39
 /gr6KMxH
 n1TNwvrnNNZb2uQcirn7Ugbv9CFB2pcTa6gTNsfyHnvD36xxDDj0OxL+5Z3qC7Zm3ZsA98lWz+g/VvC0T1K9YB/Mld5Oeh2PsC7bc7mivWP4OCyoiCHUt4ja6DQsrcCpcrjEI9QKn+hxa6cw3QHwc7Rwc+8N+CHVl2evy3Z1zWMZYydHcx2RQB4yBO3OKlD5e7U19NP+NFOFaWOjUdiTKNjACe1+b+Ybg1B65M+8kwQQ9tF9XLSBJwO/Iyg5xWWTT769pCtClNvEPFJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track page access/dirty status in gem-shmem for better integration with
the overall memory management. Gem-shmem has long had two flags bits in
struct drm_gem_shmem_object, named pages_mark_accessed_on_put and
pages_mark_dirty_on_put, but never used them much; except for some odd
cases in drivers. Therefore pages in gem-shmem where never marked
correctly. (Other DRM memory managers do some course-grain tracking at
least).

Patch 1 switches from PFN-based mapping to page mapping. The pages are
already available; only the mmap handling needs to be adapted.

Patch 2 adds tracking access and dirty status in mmap.

Patch 3 adds tracking access and dirty status in vmap. Becasue there's
no fault handling here, we refer to the existing status bits in struct
drm_gem_shmem_object. Each page's status will be updated by the page
release in drm_gem_put_pages(). The imagiantion driver requires a small
fix to make it work correctly.

Tested with CONFIG_VM=y by running animations on DRM's bochs driver for
several hours. This uses gem-shmem's mmap and vmap extensively.

Thomas Zimmermann (3):
  drm/gem-shmem: Map pages in mmap fault handler
  drm/gem-shmem: Track folio accessed/dirty status in mmap
  drm/gem-shmem: Track folio accessed/dirty status in vmap

 drivers/gpu/drm/drm_gem_shmem_helper.c | 78 ++++++++++++++++++--------
 drivers/gpu/drm/imagination/pvr_gem.c  |  6 +-
 2 files changed, 59 insertions(+), 25 deletions(-)

-- 
2.52.0


