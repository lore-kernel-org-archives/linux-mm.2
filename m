Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754E9CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F968E0003; Mon, 17 Nov 2025 05:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF04A8E0002; Mon, 17 Nov 2025 05:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDED38E0003; Mon, 17 Nov 2025 05:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A96A28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:56:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4778BC0C7F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:56:08 +0000 (UTC)
X-FDA: 84119794416.23.8FED1DA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 23ACF4000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:56:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nfWeXZZF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q89CvPjJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HhVSJVVP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7yYEu2g0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376966; a=rsa-sha256;
	cv=none;
	b=NsJBlfUPf3jhV83ImsZgBnKg0A+7naAvfd5Lu/QcU9JSKS5ZesSTpdfZnt8Z3VqGjrgJOS
	6jHo/dlAfxNeMg3uyJ634GFv3yCm9AtqCgEyrWW2pcy0Ii4fpg1rAddvnWwxbvUJUzAhY6
	7pBL6n0QuvDJr+zrXCoI3o3FvYna8zc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nfWeXZZF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q89CvPjJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HhVSJVVP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7yYEu2g0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qoJVWWDzKhrx7TTsS5LL+fRrXYWx8GLDiy9e21W9Xn0=;
	b=wb06aNPIu59tBQZBWiS1JMc+DvzfA/+xWIq+e9ya6iztzOk1KnYw2QW/pKSTPDvQXzqkly
	rrzAj/ss+4Wq5CEZjJDAAu9tuhWjiRt6/0bclSqUktGhvMRkZEi0QimUz7AKT9JpMx9N0F
	K0cF6iOnhUCXdBFCFxfOmhPCrgvAjSo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E34121F44F;
	Mon, 17 Nov 2025 10:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763376964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qoJVWWDzKhrx7TTsS5LL+fRrXYWx8GLDiy9e21W9Xn0=;
	b=nfWeXZZFnOEkUHI2BJv2ej/Y36+xRxHXvWnWXvW1y6lPMIuU9UnTAU5Q4kW9OqRQo4x5ZX
	S6A5BKU3vN7I399LajHk5LVWW+Zu/qxemOE2dxVUdHSW/FG8PHDlRT+D2DGUw0Q9owQ6GS
	nr4i4rPwHwBbu66zNtTqQY5cBToFmsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763376964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qoJVWWDzKhrx7TTsS5LL+fRrXYWx8GLDiy9e21W9Xn0=;
	b=Q89CvPjJVbz3F/soo+gsrOp+YCCPGH+bvBFuc5WKW4ZQ3s1FHMH4DdWVYkR/NGTszV3dZL
	vZ4AInL3e2XfExDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763376963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qoJVWWDzKhrx7TTsS5LL+fRrXYWx8GLDiy9e21W9Xn0=;
	b=HhVSJVVPhXD1lCvjkApnnR2Qjq/PCaZ6Vjt5QK7UhMbwfa+3fY0bZ0G9d/EjFRf7QhPR0h
	OaMxkTNmolu29I0JG2RKcyaye8LtJJoIJ7nvHEMG5UrokM0ahsOg7uqDS30Zq8oN0Jrwmo
	rPXSuhCXx6cUt+GwsEiOQxIjXwPyo/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763376963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qoJVWWDzKhrx7TTsS5LL+fRrXYWx8GLDiy9e21W9Xn0=;
	b=7yYEu2g0+lXtG0ZVjDmMqYUgRsdWc4Ky2WKHBiMushxRc3Q0RA2Doy5qinMT55SfbP9kIs
	bdKQvOnt4W0N72Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A63AB3EA61;
	Mon, 17 Nov 2025 10:56:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7CWqJkP/Gmm5YQAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Mon, 17 Nov 2025 10:56:03 +0000
Date: Mon, 17 Nov 2025 11:56:02 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Hildenbrand
 <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, SeongJae Park
 <sj@kernel.org>
Subject: [PATCH v2 1/2] mm/cma: Inline cma_sysfs counter hooks
Message-ID: <20251117115602.7b9c7ccd@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 23ACF4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 8wmnbenwzipts41fewhzc8n1stbbhemd
X-Rspam-User: 
X-HE-Tag: 1763376965-392773
X-HE-Meta: U2FsdGVkX18TtNBqTP7bGVqM+aKGMs1ehR8T9GRT+rYmf3OoVxg1sBYpRj82Xe2c/SF8YqGa8q+mo1D28W0eb7RJPkRx8xf4412qhsgMqKUC+z7YOOTSKvSGgalrUh+EXcSA0ZrzWTk1xCsg0hE8kOM50cZ12hKaqztM50BhxvYkGxEGt84wjU7QfvtsH2174+4+HV11ajEWGH8yT3cF2stAXEKQmxXGeWGCe2jFUftGbSiEERgAX14WqdaamFsfUvgDS7H5oAEsWEuzXC4awg+ifUuYP9SFmhoAHuzXePibfTnWjUm7usbrNm4IAzhdODSv1bV2PbcN+n+JoL6wR8oSvji/nbdpmUvhL9ui9sRr7vWulzpvLLSBo5pcV/ahoTlEm/ZoowDCDMvYtdP6G27etTlFmW8wjZH83LKMnnhTF5puCQeNAtsMC/3xobSJToWrQignGlEHZqomqDDiIGZ5a8P0ZUxhcygcxCf1+AU+kjVYc1woKCexym2siAUO20sXl472MGUek/dumXvVmnpTbKNjyHHNwPCESKrMIcJXb/HBkHLKfl+cIvanyfyjXgs7/8y1E3K8dIPRDrzmBd0QGCYTsO4cwtZDl8JJkyJTkipMOqNg2dPIgKX/bUvLxby9eESAhLOensG6XhXM2C5XvfEVQMeDfLl44y0hA5GhWj9z9MJGp+yuYSunzblg3DSht3CaqmPtXmIag5I3x8+wCs+Zcak6/6UbtghSnSE7p3frfiJ4uxaChdRkliUrhAMYQzH/ZHKluGFX9bggI5HCNEm5eHmZb5TMVX+yhtrh03k8BS8t3mcT9tcVdiwtOVIryjDYwFZJZ2kElM5F8DSRIXEu6kocFPridkTnvuXTJjgc9rEh4zk4NNT8Ksjr9Q50d5hU2NjxIi8VQN7llQs1EzGZ09uCWYxgXqEhRU8yg6nZNCeHlvvHszbrZPR95JFAUV1x0EDmJgagsP2
 L2XBpTlb
 ZQwDA4ZGAWR+AaD1alg5OXhh6d7To15+IwDWDD06dCHp3RIhkaKiWeSmG0azCc99KvGQHfdTLAomzdUKLxkwU4j/XXv29bDMZXprarXHPxyl0HcqJ+/xHMH53Lcqf+1ST1m1sDZeLO/c8zuXRT+lughcfQXojiW2h6fmKkDXH/SkgCHpCQR0P7H3BwwBUFvybpB4JgxHWqj1Sede7dUtVlBYQrcOCpKkOdsaosaqKAt8A7lEtdw1A0X9MdQ5S27ifZzpEGJ7OW9oRoWP6qosfjXeI0sT+Q3FfV4nI2+ZJI5GCivN2t8UI0ioJKPfF3P7wq5+K/I3bSHXQEiiVqbPdb8beGdmKCiZuiMEvaF01kruYNxrngVd51UvpQ/PB5vcebPWe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move cma_sysfs counter hooks from cma_sysfs.c to cma.c. These
one-liner functions are only used once each, but the compiler
currently can't inline them because they are defined in one object and
used in another. Letting the compiler inline these functions lowers
the footprint and runtime cost of the sysfs interface to CMA stats
even more.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
Changes in v2:
* Move the functions to cma.c as this is the only place where they
  are used.

 mm/cma.c       |   27 +++++++++++++++++++++++++++
 mm/cma.h       |   12 ------------
 mm/cma_sysfs.c |   15 ---------------
 3 files changed, 27 insertions(+), 27 deletions(-)

--- linux-6.17.orig/mm/cma.h
+++ linux-6.17/mm/cma.h
@@ -80,16 +80,4 @@ static inline unsigned long cma_bitmap_m
 	return cmr->count >> cma->order_per_bit;
 }
 
-#ifdef CONFIG_SYSFS
-void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
-void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
-void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
-#else
-static inline void cma_sysfs_account_success_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
-static inline void cma_sysfs_account_fail_pages(struct cma *cma,
-						unsigned long nr_pages) {};
-static inline void cma_sysfs_account_release_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
-#endif
 #endif
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
--- linux-6.17.orig/mm/cma.c
+++ linux-6.17/mm/cma.c
@@ -36,6 +36,33 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
+#ifdef CONFIG_SYSFS
+static void cma_sysfs_account_success_pages(struct cma *cma,
+					    unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_succeeded);
+}
+
+static void cma_sysfs_account_fail_pages(struct cma *cma,
+					 unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_failed);
+}
+
+static void cma_sysfs_account_release_pages(struct cma *cma,
+					    unsigned long nr_pages)
+{
+	atomic64_add(nr_pages, &cma->nr_pages_released);
+}
+#else
+static void cma_sysfs_account_success_pages(struct cma *cma,
+					    unsigned long nr_pages) {};
+static void cma_sysfs_account_fail_pages(struct cma *cma,
+					 unsigned long nr_pages) {};
+static void cma_sysfs_account_release_pages(struct cma *cma,
+					    unsigned long nr_pages) {};
+#endif
+
 phys_addr_t cma_get_base(const struct cma *cma)
 {
 	WARN_ON_ONCE(cma->nranges != 1);

-- 
Jean Delvare
SUSE L3 Support

