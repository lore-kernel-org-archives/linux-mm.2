Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF13CCE7AA5
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 10:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3EA8E0011; Fri, 14 Nov 2025 05:03:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155CC8E0002; Fri, 14 Nov 2025 05:03:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042A58E0011; Fri, 14 Nov 2025 05:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E24738E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:03:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68EB4140351
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:08 +0000 (UTC)
X-FDA: 84108774456.18.B5CAE63
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23FCE1C000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RhJWoQcw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CtnITG5K;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lb7ZddqK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s7s0V9rW;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763114586; a=rsa-sha256;
	cv=none;
	b=Yg+v1/E3p2WvgRIXcu9QFQGheqR5RQTL2+9OW9O0mOGIobsWKXldhSHIZNjRso72SVlz4o
	D4w1r5mJWzr7c8pyLlmhrkXqUFrU+PgsO5xcOc0hTRyFTXFm1e8rb+EG6AozB+Xy4PIHOp
	dKuVMIMbw+eIriRSDSHWeMlB7v9Sbto=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RhJWoQcw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CtnITG5K;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lb7ZddqK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s7s0V9rW;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763114586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t5l+Z4OUA4ifKPHX9expiwKnae/6J3vb2pppSaJ+aMU=;
	b=L9ZOhGDSfxnn6IGZab7uLFzCCa7Ohpo1/9mdqJGAOHtDSl5H5RGunLG/piXZxgZOktdTef
	GtEM/aAB5FF+Uj5NxE/Kn0rT3HJPU/WPsZL5lUjmIA/x+ufQCmdRunujpp/mSphpDZQFYQ
	8scMcWlzIWdtOFhzsNr+4dz74JLEIus=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A6B61F825;
	Fri, 14 Nov 2025 10:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763114584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t5l+Z4OUA4ifKPHX9expiwKnae/6J3vb2pppSaJ+aMU=;
	b=RhJWoQcwKmg8/lCxpgWTh7JY2lrS49LMNluiat6BCytvZlNKcOgZBZfMl9X2nsXZPmnudW
	oOWjlUPH9Ci5wp/yurOCmg1HSf8pSje5T2PcHLtsRNu6Q6XreWWHxVnJD4y6600nRqpl60
	Xy7/Rb83sMazVipRwa7LqEk3JMdgqY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763114584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t5l+Z4OUA4ifKPHX9expiwKnae/6J3vb2pppSaJ+aMU=;
	b=CtnITG5KCEtOgDhnMu/NNQ945nOFmxzZOcS7wOCPmF9r6ohzer/CSijfrMDz3bT3kenDxt
	TTKyTr5ZXHW8fGBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763114583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t5l+Z4OUA4ifKPHX9expiwKnae/6J3vb2pppSaJ+aMU=;
	b=Lb7ZddqKCmztqesegCwYEwbsQA9saZuCJ5QIUwMopp2lhiIZ0H/DNu//izmsy8pqgAukFB
	9LtfghZQ5boK4hs0C06j2oq7K/zY33PnCZl5El148A4i/nesZqUzmxYMyaHgKjqjCPmNJg
	h76LwnrUPNrX52WVmzdpTVZomqtqJLk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763114583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t5l+Z4OUA4ifKPHX9expiwKnae/6J3vb2pppSaJ+aMU=;
	b=s7s0V9rWU4yRh46uFr/eiNcUw6uxVGFaS++ZwXAGpkGH8NkZamvEcjZGr3Do6DH4sXT6cH
	c2jqyniKkDuQEsAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2471B3EA61;
	Fri, 14 Nov 2025 10:03:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F9rhBlf+FmkIcwAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Fri, 14 Nov 2025 10:03:03 +0000
Date: Fri, 14 Nov 2025 11:03:01 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Hildenbrand
 <david@redhat.com>, Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH] mm/cma: Inline cma_sysfs counter hooks
Message-ID: <20251114110301.39316246@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23FCE1C000A
X-Stat-Signature: r85suw7sr9jzppr1bxqjf9d44s63c1ro
X-HE-Tag: 1763114585-708649
X-HE-Meta: U2FsdGVkX1//CTavurX92c5vXZsiQziASds/nV73Ws56PWf+NUpvvPkqw1QiDILVm7X8uw4wuCHvqdkcwog0ngVdj0Odg10MXz9eLP68WIVLRBLupvsyeaJ+CRpJSwpVjVSUW7dRgAG9evEpKL9FZ2W4s7AbLPrpfFq+83eBd5X2hM2vsuRUy2Lc/26pbBUThpgLLDbYTulfuMphx9N9xpuYbXu0nZrBmBvgFK6C84PLh30mdgSsXUXp5E75jMR50hfdnpzfyuyAQC9NDMMIMu3OIyFzVXp6YJqirHmD5I3v/l7YnevjsO5d5u127WGMIhlvXDQ/Px3jyDGYZyk0lZ9XOCDNL0DlCHH7vgEBjcKsmeBCjHLP4Z+ZGaO/1ESCwNSArxRlI3usfBP21zOxLXgT2qlS23UP0MpCBEc+KOAGb2MR25/f8wr2cOU8nLFqCtElT2vyUM3AUEMcsD4PDXsNG261Yz1is0chrY9YVhOrXvNnG21huErdqa56vI/LQOFzIOwiWHNRPqjJH+BSPLKqIKV+bJhdnUlpxCqxXFEYbIiTd7UgkEW5yQqvlxm/s2710Qyr7mgkFV8z6Vvl/celf31xJjuRo1fg+rL3g9i4q1Ed2YHjinJX4BXcXrmP8d9gskg2U6G+w3hGAhD3j6mn3jCsZoLgjWKoJE1MfkIEaH1b1U3a55y5pgaiEwQL+JaTk4M20q/SegdZ5lsilrFHMOGqm0V8ALTK+Cy3nuMsBskknJmm0MYwO1zH+WJ93VhDF6h0PP0j61eUhLVaaSb+RsTstsiO8PVejZ5PqyTQpfwUmJPmAA6rWyIVbofe4BW1LPXiorCN+xZEy14ChqxaXmwOB0bz2KQlPJf+DwPgp1k31ZChTyyQn8yBkBmsymf0IuYwAJbLCd/2O04IIaI9O74bQxDKEEfWdsullmlkRSUyAFRn7oxNjq81AxSfEKwBbGg9dRKJVBPpsVL
 B0FndoK3
 4tBIRuLCuWt0pIqimEV13jZAGXfiD9niX9sABQOWlimQWd8Jf9C+4uLh/ML5kPPsV5xdEDvyEdmYpuiX5XKeZmtfV2kVettnvjElOBs8xCOZoFzQ41vpa7QBpaG17FLTPJyBySs2mW0P1fHBLlPJgZwgLxDn7+OwQIQ7sDw6eFR0YqKonOnYy6yt8FrZfD+KFByGJxqKp9taszsLh+9bavCE8atv4kATAS3MKE2EIML6ZK6K+JiUAfbTYvVnQwd1u6k6urvrx7+dBk1JVc7GQV8aSoDbFTVHG0cDHxAZF9wR5dLmcpkT2tglOQWuH4xMMlK92mq+2uXwuETFmtFrsj15wPBa0BbTBNAT86EOZBoh5yRQ6GFGEV2kPxXOO2EdgV8j7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move cma_sysfs counter hooks from cma_sysfs.c to inline functions in
cma.h. These one-liner functions are only used once each, but the
compiler currently can't inline them because they are defined in one
object and used in another. Letting the compiler inline these
functions lowers the footprint and runtime cost of the sysfs interface
to CMA stats even more.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
Applies on top of my previous patch due to a context change, but
otherwise independent thereof.

On second thought, we might as well move these functions to cma.c as
this is the only place where they are called, so it's hard to justify
why they should be in a header file. Opinions?

 mm/cma.h       |   20 +++++++++++++++++---
 mm/cma_sysfs.c |   15 ---------------
 2 files changed, 17 insertions(+), 18 deletions(-)

--- linux-6.17.orig/mm/cma.h
+++ linux-6.17/mm/cma.h
@@ -81,9 +81,23 @@ static inline unsigned long cma_bitmap_m
 }
 
 #ifdef CONFIG_SYSFS
-void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
-void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
-void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
+static inline void cma_sysfs_account_success_pages(struct cma *cma,
+						   unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_succeeded);
+}
+
+static inline void cma_sysfs_account_fail_pages(struct cma *cma,
+						unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_failed);
+}
+
+static inline void cma_sysfs_account_release_pages(struct cma *cma,
+						   unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_released);
+}
 #else
 static inline void cma_sysfs_account_success_pages(struct cma *cma,
 						   unsigned long nr_pages) {};
--- linux-6.17.orig/mm/cma_sysfs.c
+++ linux-6.17/mm/cma_sysfs.c
@@ -14,21 +14,6 @@
 #define CMA_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
-void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages)
-{
-	atomic64_add(nr_pages, &cma->nr_pages_succeeded);
-}
-
-void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages)
-{
-	atomic64_add(nr_pages, &cma->nr_pages_failed);
-}
-
-void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages)
-{
-	atomic64_add(nr_pages, &cma->nr_pages_released);
-}
-
 static inline struct cma *cma_from_kobj(struct kobject *kobj)
 {
 	return container_of(kobj, struct cma_kobject, kobj)->cma;


-- 
Jean Delvare
SUSE L3 Support

