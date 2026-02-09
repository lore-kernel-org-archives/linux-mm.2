Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50ABEE81BB1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37086B0088; Mon,  9 Feb 2026 08:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E146B0089; Mon,  9 Feb 2026 08:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DD06B0092; Mon,  9 Feb 2026 08:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 852366B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:32:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3510DB623D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:56 +0000 (UTC)
X-FDA: 84425008752.02.68E220E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBFC2C000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:32:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=scVEs+EQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6jnma8a;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=scVEs+EQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6jnma8a;
	spf=pass (imf10.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ffSXQJlFwYDdG2RQGzEhBMQ1sIFLJ/JD8jWSjBJRIY=;
	b=kRSDQbikTOoCqP6IdrgLZd2+6JLrc62IRVljs3gckPjfOhjF3vRe6UQryzs0BiKLXR9XYV
	u9LMEKXZQgwF/7FjrioXIesrbTHDXSe4TBhDKi+1zSa0DxfteeUMM1jr94vUAKHa5/ClDB
	gkBWjwId9dYPKxmK7i42dkrB8mtpYWI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=scVEs+EQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6jnma8a;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=scVEs+EQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6jnma8a;
	spf=pass (imf10.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770643974; a=rsa-sha256;
	cv=none;
	b=NJvZq6YJaJUVN7Hw5XU7jDf5xzpDE3BQZ6WP+vFfe7CfHvkVP1VV1n3o8IX5LRemQGLXfu
	sBggGtHOroJPcjrJCexoj3D77xf63Zxvmy57eN6B72IHrSvmc5ccD5dWs+ckr+FyDbu5L7
	6SYRCRwBgKXhMbK6VRPRMcHOW0OjAik=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EE325BD2D;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ffSXQJlFwYDdG2RQGzEhBMQ1sIFLJ/JD8jWSjBJRIY=;
	b=scVEs+EQ6euAoziM71pug6l47w6O2dsYvJPvd1olIoHiX+t2HH1DyZsWWg26FkhfTJpc61
	L9FmiA3XU9h0Hik3xfGgDsWriDeJrdEFS6NIKKPTq1FMB4C3thYPA5YAGquLkgOncnuxjY
	d7NpIDGkI7F2/scmMCOKLIK+ZQLYMv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ffSXQJlFwYDdG2RQGzEhBMQ1sIFLJ/JD8jWSjBJRIY=;
	b=o6jnma8aul3PMIzpwxMHmCWW09ILKd/48nniXBrB2VMA1BZxMxpQk915JBCU8YEc3TclI4
	LfC/UfdgdUABtnBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770643966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ffSXQJlFwYDdG2RQGzEhBMQ1sIFLJ/JD8jWSjBJRIY=;
	b=scVEs+EQ6euAoziM71pug6l47w6O2dsYvJPvd1olIoHiX+t2HH1DyZsWWg26FkhfTJpc61
	L9FmiA3XU9h0Hik3xfGgDsWriDeJrdEFS6NIKKPTq1FMB4C3thYPA5YAGquLkgOncnuxjY
	d7NpIDGkI7F2/scmMCOKLIK+ZQLYMv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770643966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ffSXQJlFwYDdG2RQGzEhBMQ1sIFLJ/JD8jWSjBJRIY=;
	b=o6jnma8aul3PMIzpwxMHmCWW09ILKd/48nniXBrB2VMA1BZxMxpQk915JBCU8YEc3TclI4
	LfC/UfdgdUABtnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 163B33EA64;
	Mon,  9 Feb 2026 13:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oHMBBP7hiWmTIgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 13:32:46 +0000
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
Subject: [PATCH v3 1/6] drm/gem-shmem: Use obj directly where appropriate in fault handler
Date: Mon,  9 Feb 2026 14:27:10 +0100
Message-ID: <20260209133241.238813-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209133241.238813-1-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EBFC2C000F
X-Stat-Signature: r1hip7d6tkp4gbtokzztjemcw8tz4eyp
X-Rspam-User: 
X-HE-Tag: 1770643973-848590
X-HE-Meta: U2FsdGVkX18K0QOadBhx1lhzROqDzDZ6AjlyueCLJ2Yh0B2J01WG4U7mmi+gS1Pojen35yK6KMEb1cQRb8tuSYnF6j1YW4aJB7wzRQZFClhvA4YlQE1wOopiYmycdFZPp4qNZ1O1qEIL9Z+1za75yYmuTSfoUmQQ8GkzaHwIrwsVyhlc7zsz1n4t04EMSXGxG1lhvZpuBx6kV0GSKDXg9uw41xYLPw2/qeyZKcoFJuca9jOQ3Ihe7bwlM/Gk1kOXkF1OLmlpJYxV9yOClNcau54+Oqxl9pA1aDKAkmHyCrRDmzbtuZFEeJvcyyCv67E5b0b2U2685O0Y0auJ1pb0hY35O/bwtg2cED0x7pHNRb8uixNF52HP34MpUXP+n8FGGaNTPYZuzs6YlSSRAxpFqvNcBIxAF6JPMDrryaSLhsxUJjVZ0adET48dePgeT91VhSUr0BKgh6q6XIPfQn9cNofezmsq5WVpWmz7rjAOvhuYtrH9K4FAgiQ14EggxIRWWj1le5aAl7TT8p3baX6+AYkKa0g1Hzpq6UIeDjnoWrGbKAygHQZh7nIzG9G02uBO93Wi4EmrAoGcEQN+E6a1fZan4kysH4sLACf7tK0dTcBZhKu5jGXnh46DkZlJFQDM2gNHMzUhnVncfEFssjif9DvbsDKczxFYtzndtySPttdgmAPtaba9hA7GPRuAx7ULGFg+BJX6XkDWpnXus+vUOSqawywBzR6iuJQNRSRfSwfK2GrqMg20RzE4AL516DRgj/LGChysOme8wydtaDhDMfTUV4nQcTJwjplb+0I1YxLA5jANAY+b7HL6Aj0PKoEn8YGTn5URo4ox1Pmc1k20SJznfpLa+OUWqA4hhX19tIc09tB4b0fbV9wDerLTzUJ9gntwy9e+O2E9IQNwC8i4E4HuyOEU6OgGaQ6CZOZRXjp9yDgXupab01jL/70wnm10fMQEMOtv6B5tsudwPWT
 nQyH62kr
 MScOJNOJY3TLHN1lrYp1zkM+XgBbhzEwDQL8o769cefrn6eKZH9JEER6kI9BWgfXd9u+ED+jfrGeIr5Z5UCfM7op6epV2wozgQMkX2udCotEha10U7YJ9EeswE2Awl17/62fvpYQLdqfky8XtEdx3fq8pKrtiFTIEzqWTtTDwm8M77OmgT+iE7lkI5YlmWMVBEEmALA9tcXQjh1/W6ZhZHrIHk1A7d/19+KkxUM6eET9gi4Bxk8OssEiqp/KhyQnAZszIMUy35YiHVnU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace shmem->base with obj in several places. It is the same value,
but the latter is easier to read.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3871a6d92f77..5bced7db0f1f 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -584,7 +584,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	/* Offset to faulty address in the VMA. */
 	page_offset = vmf->pgoff - vma->vm_pgoff;
 
-	dma_resv_lock(shmem->base.resv, NULL);
+	dma_resv_lock(obj->resv, NULL);
 
 	if (page_offset >= num_pages ||
 	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
@@ -602,7 +602,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	ret = vmf_insert_pfn(vma, vmf->address, pfn);
 
  out:
-	dma_resv_unlock(shmem->base.resv);
+	dma_resv_unlock(obj->resv);
 
 	return ret;
 }
-- 
2.52.0


