Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B50EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA03A6B0092; Wed,  4 Feb 2026 14:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D7C6B0093; Wed,  4 Feb 2026 14:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59F76B0096; Wed,  4 Feb 2026 14:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9310D6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:58:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53194139E51
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:58:00 +0000 (UTC)
X-FDA: 84407835120.03.7744EF2
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89B7480005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:57:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KtkSnjUd;
	spf=pass (imf02.hostedemail.com: domain of osama.abdelkader@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=osama.abdelkader@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770235078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T3SdKNKQtGHVYu6fTQL1LvKPxizWalb7x6xSf7Uyyd0=;
	b=zlTexwJMiwM8YZFteJjc34bnQpBsCNJb/SyTjwlbC4TjbDcp++/3Xpgg4UJekIfJp/F1qC
	h1dL90goX0omGJXfIt/vD8DEsHcY0Yq4A1BhDzprBKRXMFYMTc5r+AhP1xkPyfYW4M5VX1
	RMgsyza0ECdx43OJdN+7GGVwoasvgOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770235078; a=rsa-sha256;
	cv=none;
	b=ymgHLdwPtI/n+lB6vSmlJqE998sZ7nDWtBm9LghM/JShnNvJREpnlLEza18f/DmM/Tnj45
	WwN+vA3vGstxn1gqRzofTgP6JV+1xohU+AFQIRbNjmbo5401jM668p6g7zJMzc8SHI7rqe
	pwW09gKC6rN7UNHvOXUlK0jj3KlG0po=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KtkSnjUd;
	spf=pass (imf02.hostedemail.com: domain of osama.abdelkader@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=osama.abdelkader@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so2188255e9.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 11:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770235077; x=1770839877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T3SdKNKQtGHVYu6fTQL1LvKPxizWalb7x6xSf7Uyyd0=;
        b=KtkSnjUdKfzx/CY2V0qMvpgc2aBMk15pEcP7GjxvGL2h3gx9RmSDkpkVpdtHqK019O
         NRCSumfIKITlx5lToqcuWih7kFaurAF+FLY7pZxQiUK8ZASdpE3ACRO61ryZv/eMdntP
         O4KJok1xUWrwAqXtv0gVyKEyjJ9VwMJ3qtaXrShe09Z+ModQUEXQ4/6JIBWE5wwh7WpH
         GRP369wkN1WL3tWp4gWjVmsQFj1xbd9Wm2XW4SbCaIYaXjGkcqNjE3C+6dkYvNTnkw2z
         OCh1Vo3UmULGlDDdm75gnnfRplO5EmjIlq44iSfRGt61jN/odCaM5Rie9GBaHzaJ0d8m
         VMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770235077; x=1770839877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3SdKNKQtGHVYu6fTQL1LvKPxizWalb7x6xSf7Uyyd0=;
        b=QwWviz8p8ZrBuMEPlX2Cx64yRCUw3t8t2Z06yrhkb/hxRIZX7dV+waFTfHoO4PBlrI
         0Gr0Hg97e2Ry/+lkMoTV2zelvGeYcnsOGywkXIxz+UDoLD+Bsvp4e3KMSUCRA18xys9M
         BPq9W/N1BCJbZQe1e/AieMHI1oCN/u0N/Ac0vT7mdIuOy4zWbvp0r4IfKo9FCMvq6qyn
         4GneGdkhTK876GmmzMKOjkj+zDRVacxta+rQWMzOajW3CToAXLUD9+e82ZcIHanwq/vj
         3jItXmq3ApuhoXH2ZqXNeCNie5IB51T+xndMLAw1+swdQaNWY8vR3imSVgCH+4pqhkQF
         amqA==
X-Forwarded-Encrypted: i=1; AJvYcCUkYKx45UDiB20VK9eNun3XdhoroDMbTRQCUhlPHognICbNE8tuaoN3ah+OvOoeYywBmKyjRqJxcw==@kvack.org
X-Gm-Message-State: AOJu0YyyYFFymOu/PhbfdmF0+3dCvL7jFM+eB7pN1kIzaHHAHJASXGIb
	AQC2jEnkFinwGHJMEPHhx+zU2LP/fpeaZO3kZrUralKwhWoWyB5kXX/5
X-Gm-Gg: AZuq6aJt9xEvCKzdOBAFnBoUv+lskoVLj95tCZj7oVuHT82Y1CLHIJu1gWk/JLeKSQ5
	0+FxJRyFlfw4mkQSDbbbKZZc4CtMkuh9zDxQKn1o619OgQ+/xPmwLu6nmLehW+Fz/72OKChUMHQ
	dSvGPV7Kdjk/AHz4upw84G6dcIHfghz2Q6ZaqtuIAr1UtMDLsaSa1YMECxxjIMAIBw7JGcEnf6W
	PJ5KZu9rjtUF5Vk7x0vadcw07d9/vtfhmW4eAvhYB0MPlOMBR4k/eXe0WdEtDXb8nn4O1hONqv4
	i2SAVIFn+UtiNEVqYHSgViCmRGSinzgOaTdKuelCZ68IO6Z0r+cWM+3CZ0PSP8hPejjLB5tCJZ9
	jYnUrrfO/5f62jhDCydyd7Dw0P3Eux2dmXuRk4PTwG6/KbIkkgzuyqAlxU6QZCRG8ZrpPoFHuoH
	gagnTTZCAgSrR4x9x5lJDYtnlxB8P9DiD58eCpBYjreU8=
X-Received: by 2002:a05:600c:21cc:b0:477:3fcf:368c with SMTP id 5b1f17b1804b1-48317917835mr4537895e9.9.1770235076762;
        Wed, 04 Feb 2026 11:57:56 -0800 (PST)
Received: from osama.. ([102.42.253.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830ec57bcdsm48704285e9.2.2026.02.04.11.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 11:57:56 -0800 (PST)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>,
	syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com
Subject: [PATCH] mm/slub: zero-initialize slab object extensions to fix KMSAN
Date: Wed,  4 Feb 2026 20:57:51 +0100
Message-ID: <20260204195751.188219-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89B7480005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fzqn8x9fq64f3rmt7cjfswihroskga46
X-HE-Tag: 1770235078-68960
X-HE-Meta: U2FsdGVkX1/LG44Qn+zje1L00WfobU5R3iua+5rWNRZwJBWGF21Q62Qrmn8422WHAF7gw62FLgsk/ojjeR27ZUtPCzYMn1x1yjY3MhvwE1EgWP3oLyb2wTo81fLV2WuiNUUsSiU1QmDLFytsIWuX52GMjjccCH8BRkoOVOVh0FJh43KIV4hAqzWLthX+p6cXIrhjoVP4OMYijeG93G7MDUgbxbXH4Ba2C4PRet5cdZB1V4WdRgBtVx1E3KyQS6j9jzo7trCE62nKo2Jk1caFTTFniv8DCl3kJ8zn5W9BAUme+49XRXmrZX/waujCMkzD/Ti1DKFNqBsSjwAB0Z7TAfITAG+MegOdRsoGfSLtTOzrLSFuOwqvhPJY20ZpQu9sZgxInGOBTxwvSUvK471TViSWqQvlarF8aLMMA2IFm+wW/nZocXVcIwqJ+tfZIHlyxstTWi0tv7gP7sjlBcXWT6fRJhAWsTn4V92LMSkPV5iNpdRHWW8zEZQoJ7wi+e6CHAjg6SmhfeAoMPoUJjPqO4achg2EhhKdFdzkaktIUXJ5m5uRbIxJhPFjlHrDp7cY+iVH4JotYQtf/bFeaox6AYktSy9OxtVUay/1s31Po2vGH171jKYyhEIMx+Mq6QY9j5SBBgSvytsPHmhQjDVcyIsihCncPtwnu6i7UOoOtqj1KOgqhR4WV/Mq3S6gKTIode2i6J7oMFErUHyDbs6Ysemgo3veWA41l+tohJw0/IdzUiQj7XBpMkhfoypGicB3+1MzbYCrVLfkbxg+ysz0uuRawyPm+5bAFTy0q/ulSzCnV6zpq273+mMcZ8zd1b0NvMYYs0RNywFG0Q+3dVQRB+ef7PCFCRWIbquKF5ojdAmabaVQvLkEGrXHlnSQWs8gxyZTLwVxYH1jTQl2X/HtJxfGKN496ceiyhCS4YdXQNokFRxdDX50J34EbjKkoCDXzPyaAdpyATIOtzVPCBT
 UanluGes
 deDKiTUOqBiOEazZB8REKZa2vqqVHZUvwg4YKgAY8Xlk10Tq5cwyuw4ky05OKP9gGd6s3UqEjk7juNr2JtLsigsG8C4YE21qhK7rEx7R10Ks6eoZ7f90UZr33xpQ1HYoAfTmcpgeYNEKu2kIHmvt+F04trNxmYap6ZQmXKIvM5sO6qblBUuIinK2GDsMxaLxQkv3m9VLgqocUIHz7TTf/base/oyBM8mZP0lszuwQy3AvjPIIDPO8iQ4z/NMRcR83DclgjTHTH30lCXAVLmu5IfIl+j3Xn4QZhSyeMovfpJa42yuohnQUsfOcJGy/9el/1EacRfIIZ8/JunUtShUMGn3fOKBC2sxIuadFGrhxfLOTBSXi3T6ey69rRpvF1nTfQ9yPbpxqjTWvSZ3x4bZVxSf+iZ8r3yW5fmSLpP95/HgWR6xzYTWtH4j1MXgU6KUyNvuJTcZETbNGVVRFTnYO0uO0zOxeH1Mv4WpYcyaptfNnbUQUMXRFjWYJaoKQEuP9j38bYB1FShi+iNs5fTSEmRqGVBeFkW/+QUhWVs3BVCNYk8mjFlxmKdko2y+khbx/dNCvChx8xRfcQ+5D7w3SKmSrkbTYmWHgDxW2uW2IVrQdLuk+T/QXVJnS/cX8rjqwrqf68VPL9z8O4HOpiekami+M+Fs4CAbLIW8y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KMSAN reports uninitialized reads in __memcg_slab_free_hook
when freeing sigqueue objects. Although kmalloc_nolock(__GFP_ZERO)
and kcalloc_node normally zero memory, some allocation paths
(fallbacks, early boot, reused slabs, or races) may leave objcg undefined.

Explicitly memset the obj_exts array after allocation to guarantee no
uninitialized reads in __memcg_slab_free_hook and preserve correct memcg
accounting.

Reported-by: syzbot+6e04171f00f33c0d62fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6e04171f00f33c0d62fb
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 mm/slub.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index f77b7407c51b..e66d17ee7fa8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2123,7 +2123,17 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 				   slab_nid(slab));
 	}
-	if (!vec) {
+	/*
+	 * Explicitly zero the obj_exts array to ensure KMSAN recognizes it
+	 * as initialized. Although kmalloc_nolock and kcalloc_node normally
+	 * zero memory, KMSAN may not track this initialization in all cases,
+	 * especially during early boot or with certain allocation paths.
+	 * This explicit memset ensures KMSAN sees the initialization and
+	 * prevents uninitialized value warnings when accessing objcg fields.
+	 */
+	if (vec)
+		memset(vec, 0, objects * sizeof(*vec));
+	else {
 		/*
 		 * Try to mark vectors which failed to allocate.
 		 * If this operation fails, there may be a racing process
-- 
2.43.0


