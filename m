Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8645FD7F9C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553276B0088; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4946B6B0089; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9EB6B008A; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 270BE6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:45:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D47A38C053
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:21 +0000 (UTC)
X-FDA: 84490056042.30.706A359
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id ADAAE14000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xQLKD1nK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kASjKmx5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xQLKD1nK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kASjKmx5;
	spf=pass (imf23.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQgi0mAQvK89FMPv4awd74cL08jT16i82SijXBsUUSY=;
	b=J/0g2Mon37NW+uJsWGA+5EwdJVJkXDMZFakRFL1STgPxRGGN4kbsC2VCzbUimJvz1l148V
	Hv2NFQpE0IOIZmhq+EtYyRSbEVuiQc7WRs0Ijv7LgXo8QIMSKsLAcL50QT3Ab261CzF6zq
	HQjuDZWIlecLFcwfA+oedA25ri8+YRk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xQLKD1nK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kASjKmx5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xQLKD1nK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kASjKmx5;
	spf=pass (imf23.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192720; a=rsa-sha256;
	cv=none;
	b=tYSwy9AhlLkiqSRpjo4+UZRHWVOecT3YOur5zRTsu3VSSm7UZudsHB5R4CJy8jIgWi7GuJ
	bdFvQCuANWPW2xMZDlaewMfv5/rIMOimca939l9te+OJbGxZBJplvd4tDE0vxyPHCpoZoZ
	IqwZAI3rmRcKF+DesUb5gMfZCSA+wLQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13DCD3F9E8;
	Fri, 27 Feb 2026 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQgi0mAQvK89FMPv4awd74cL08jT16i82SijXBsUUSY=;
	b=xQLKD1nKq4mLWqWZuhSS2N24p2CDqKypGitrdKJjeD74xnQua10Kqn29ox2lGUA/MPyqUq
	SXkebGBF1RbNuYLmOajjJdtzI/3TkfY37ZmhuFFb0aSTSmOpUWQUynfHtCmHJnZRUqDIh0
	fxWodQb27o4obnBLAey8qCIQ/ncx+1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQgi0mAQvK89FMPv4awd74cL08jT16i82SijXBsUUSY=;
	b=kASjKmx5I38cajM3Vezm4OyY/kn1sqJGuHEIzPQNngkQSzdcjPziyKsBNdlwYstS+bh6AA
	eIITTrO3Ji1DuuDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772192718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQgi0mAQvK89FMPv4awd74cL08jT16i82SijXBsUUSY=;
	b=xQLKD1nKq4mLWqWZuhSS2N24p2CDqKypGitrdKJjeD74xnQua10Kqn29ox2lGUA/MPyqUq
	SXkebGBF1RbNuYLmOajjJdtzI/3TkfY37ZmhuFFb0aSTSmOpUWQUynfHtCmHJnZRUqDIh0
	fxWodQb27o4obnBLAey8qCIQ/ncx+1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772192718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQgi0mAQvK89FMPv4awd74cL08jT16i82SijXBsUUSY=;
	b=kASjKmx5I38cajM3Vezm4OyY/kn1sqJGuHEIzPQNngkQSzdcjPziyKsBNdlwYstS+bh6AA
	eIITTrO3Ji1DuuDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B33083EA6A;
	Fri, 27 Feb 2026 11:45:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MICOKs2DoWkvOwAAD6G6ig
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
Subject: [PATCH v4 1/6] drm/gem-shmem: Use obj directly where appropriate in fault handler
Date: Fri, 27 Feb 2026 12:42:06 +0100
Message-ID: <20260227114509.165572-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260227114509.165572-1-tzimmermann@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADAAE14000D
X-Stat-Signature: it6ksfuh1e977atgtay4ebuyghwaz8wq
X-HE-Tag: 1772192719-84967
X-HE-Meta: U2FsdGVkX195oVCPs9iU1yX7dTbzN+m+zZxXtkOFO8mhPUqPFKGgzYEvoIoaolkiSkeUuzQB/P4ZGob7EekvA1ZYEOQSxxpBk4tB11eFn7fodoIIe1h4tuOsfprcT7kyVQMLWVAGFzaWF2Zksw0gJq8NcIBA8MobIIMvqgih7mEorwaC/XCQ9RwpiflU5GCxuqzpRWQyppjlIKjPjahDRbx3WgcGVvJk8yT4fJKydSRmFEDk9y/c9gS+3Nke9wnSyBmYvQHO0LXzfn4TRKWjagfQNJ1fh1FCyJuTD5ohVzvQ9N7Nc9TaVfcYcMStil3pvkRUQei0Oz4kXfFmo5tFH+g/HHB/yTO6uRwFgRUnX7Eznv4bfwkZmB70NCaCfZj4xXxWmaIW8N8rkXzxD4ChoJDj1GLEp6tOBKeuuRraHNSu01NrvPLanzMbErE/rrqJIfhYTU9xKoTDSex5SQ480JxIv6ysfa4DTQ3YBcr2AUrvbjVhHqiPI8rxGskUp9guPEJZuRipeEYIbrcmIwB3vyJsBzVtLhM4UUW+QJ7Jxn5uGTnTnJp/bATafjWpR+V1F9NzdgQ/U/ohUxw3G0DNtb0Y9Lyk3X72pqYC/dXIJ7cWiYrdKFpjk/ZCFcb+Rl/zIHIUFcmXXqTYzvkmYpmUihlARMN1mceuWCSS5ejPpJQjzUG6Wj93ihJ/oxADk+rJHqCG2fWdhdGj632hVFez0OFXpA6KF7wipBE1MnpAOieAJ3u22P22BkEHnHUrkF4zLBG2PLq4zVqf4tvrM6RUJLYIrayT0KJqJdydoXIWYd4dGd6keboj+4E7RdS8yMIIsYOR2DjDgUraDK0SBrbrno17EJCja9bnUtw1n/yig2XMe1lcZlvq7h8wgpLTx5uI6DpylBL20yeFANK6JiU961S8rhUwgxwIvwozAIoiq5Mh2s05lUR5EtBjj4q0Mh1A+wXs/+JLhDpRZnTomDt
 dorRWmEL
 h/8g2sHONcSBaOckGF7bVc1ejRDe4G4T4hm3BZihFEdXtumOJ8rarnFfA5z2aGcZ8zqAkxGA4FFhUqSJrDxPmjTXIefhPo0n/+kkOvzOdWVYy/Zi4ghRYLJV7fXNZwGDM4fAwRe+VE0dLHahipOfHiues5Lpq8nSnafoDTyuaZEve4WOzv3Km5RTeMMRyBk7lTkp7o3gIOEE31xGtDwtf15kemxELEntLDnmAhouftiR1x0zDGlzD7vhgJ9V5yZrkahS/SPcuwfutL8P0KQM6sIXDsOzqZlaZTa+Iw+ElWX3R5GAV3qrFor+TYwmpIDPqPnHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace shmem->base with obj in several places. It is the same value,
but the latter is easier to read.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 7b5a49935ae4..1e3bfbf0cb97 100644
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


