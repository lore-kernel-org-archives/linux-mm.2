Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012D1CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576A36B0088; Tue, 19 May 2026 01:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527946B008C; Tue, 19 May 2026 01:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D526B0092; Tue, 19 May 2026 01:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3398B6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:47:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3A511201C3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:47:41 +0000 (UTC)
X-FDA: 84783087522.30.6389E94
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 03B05160007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NYeuuiOh;
	spf=pass (imf08.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779169660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V42qolmFcvj0j5BaiA/mhI5RoSSrJ+Rd9ekJZIwmJwA=;
	b=d7LnOV3MhSv2nDGMhRq3JeUsURlzR7VoiSzUPwNB6eSmyGnMpMvVLcg5CxlT5cgKgjSyrW
	i95iktLBiG0fTgOafsYA/c+SeJgmez4wGRDLVRHKdOp5T8jPvsxG4UbDbaNqjTjI/A9POH
	DRuRNbjG15kFihbjv6kpvGSw1Ii/hj0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NYeuuiOh;
	spf=pass (imf08.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779169660; a=rsa-sha256;
	cv=none;
	b=BL09feQ/8UfRpfG/6D9VG4PE8DGKRIYIvxp9/JXfFuXqxJzzc8NkQ4ddjTGkRhdWx6yQt3
	99yJ+ufpdY43OSXiNT7LeBNS1SOZZkq0xQHjnO4lyVnUKkvqJxlUF9BptLfTHYZBj6QSnv
	MMh2szfFC7ic+2BR0i9b3vyHKZmTE3w=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c8016d642b2so1651259a12.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 22:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779169659; x=1779774459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V42qolmFcvj0j5BaiA/mhI5RoSSrJ+Rd9ekJZIwmJwA=;
        b=NYeuuiOh5SaZ40NfaeIOuhv7crDMOglKb21KT/nwwh5jXRYB6dc0jrcJN628Dx7iPn
         LKW+Ygaqehz2TIGS4lFjmyKHii4RWfm9tKO7j1qq82JivcqkSZ7bmaQq54LmBM96lQOg
         JvMdXkFYdXPQ0Cy5+Gq2djWTfjw1rKmYjrHCz3HZ8G3wDPcgdu9yps39XKXH+s7jUvfo
         5bq1u0UvAlKkgjomLs9LA6LbhOSaKzIofvuXy9GBg2064ZvFPjyZ70AsNDoGdgPH9BsU
         c7THAn4+21E40RsE0wZxUyH8D8zi6yRIaNZXkRFoVLFkDWlh/79TIxe1d/xN35lXJR3b
         fgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779169659; x=1779774459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V42qolmFcvj0j5BaiA/mhI5RoSSrJ+Rd9ekJZIwmJwA=;
        b=banDpAKXbJP35uNyCSh5D3IVnVaEVwezj+Wch2qqsaVJObhhcyZqOchIoKvLBMr22k
         Z/215/4Bv1CSe9CSlPXxSpBqohPOSGrxCMIJ/WaGIlnvTZ2VHCAfkiLZfX571/NviDo2
         ta9QqYSxyGlQYNNblSf9/Zi1+jAOFhfiiqmwoort0FRx5UxjSaco9KKnzbH+uazy0zUl
         rsInQ038wkPlSHUmcZRCnhB0HHG5peN+okSqAT8KfOuv7lgPNVHI+8N4c64IFwgkaD6L
         /s10d05LY6/c6EK6plCuX0YFlAwCfLsgs1YcNb7tHpK86Lc2yJnVsLgpIriFrpZ2jyeR
         MIsA==
X-Forwarded-Encrypted: i=1; AFNElJ/gi5L2ySwrfs9RnY+0KFVmKb6BMff12BGPxH3f6rg5LYuF8oQdbpNb2eVI+hpxCOflkvsEw//afA==@kvack.org
X-Gm-Message-State: AOJu0Yzf13SLRmGVMQB/9UYANg5dqq8L6DO7GyQlt+l9Z7fCqnFlx7l7
	oFZJvlbOd/QYDqQUUvV5FGrRtK4RqgxyYm788xVgEKevvQ4miQ6BrKuu
X-Gm-Gg: Acq92OHjX6ouhImiKitDKxbLPVYVO/OyvgR7bk8lFXBNZ5pl1hnyXSAAnbjiAN6bzNv
	VXPkzu/XKNceVq8WZ8qhnzORaUt2PY0VPuDKfISUEcNnAUZ9E8t1FLGQEczWgpWox1p2pKIt23f
	kcJsxLG+IuVwOrcASfJ1OrbZmEsFwPSZQVDndHaH0M2ThimYeQk4mA3burjgF22qWdKwmqn4vT6
	fbmOebwBZT4yA7b7e04TcbnnPAR8HpDXpxFl2EKZJkczwPytkOq6qzX+Wmb6KMt5v4J4R1oAakI
	z++0Gw5ZZAhKoR13cmfyLL/QRIxSps2QuDfg6sCJI40H691jXeOEBqKwKDopWy+61lQkpO7kdew
	YoiTBSfnUAb543hW0gG94nG4LQb1Nd+lEqLcT3mEjRu4oHQ/ch/dV7Fa/OKJ6En2jSZgD1yEWqy
	RNR89jaHxRFfhA
X-Received: by 2002:a17:903:78e:b0:2b0:4f16:22f7 with SMTP id d9443c01a7336-2bd5277b510mr122546635ad.16.1779169658794;
        Mon, 18 May 2026 22:47:38 -0700 (PDT)
Received: from lgs.. ([152.32.188.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d23a41fsm170819015ad.83.2026.05.18.22.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 22:47:38 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pekka Enberg <penberg@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] mm/slub: Fix reference count leak in sysfs_slab_add
Date: Tue, 19 May 2026 13:47:20 +0800
Message-ID: <20260519054720.1032616-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84jndh5ppmzdi1u4nppmjt399enwftq4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03B05160007
X-Rspam-User: 
X-HE-Tag: 1779169659-614595
X-HE-Meta: U2FsdGVkX18iNoyMYBoTtxJjIZwoDXTT3TgmWtODs89/u8og16aw4G6HDh+UCIJTWdIfJjJC0RflTqZ5+BSOqH4FBMXmzUgEd8epqnAlDetgHEm/thmq9x3sgkzMN1U5Wa2o+V57txmjy4Eb908JGlTVu6oYOL3ko20cOJvyZ36A+np1PeCcB6934subxnfKeSK5Efhasp8L0BAA7YPoaC9RnYZwwiTlssVyND/erH4VsfPG7qSwZte2w/JQ0UDkC49kPZmypADxQrGA5c753UA2vKXpvJn5ElacoMufFwzVtZjW/z1Py8Pl0Tdo8mPp77f6/unlZDwfyH0hntoeOECdkV/4RWk4QevXqT6yE5UNHDf7d7YFxUzd10TTGh12jFMmMkLoB32TX4TWsNMj9ziiNUkp69HgzwvhZhZ0S1ocNR1BjbdF9RcChGvFQ+SFHrAtt/WZ6DktqRsiVcQuc/RbOj1eN8xCA710PQoa7OBsf0M0+QAFRCPbL/uic73hptclb7OX2djWnBTE4PGeyvXN5Oj0Y7Ib91xuF/FtnNTjK+YYtA5rEnb6OLCdVgRLNtcItWfbGJuR1ZoEfGBE5uyIIWom9EWsVidqKJhHRTCPEvq1G5zlVJLJPIsbTLSZg3ofj4F2XwqEf8SWasV8+7V20BXfMdXWbjEAgsQi9XoKVOwcPenCiml1NDnIKMSN8k+yfQuLy3IRGD3rtThtn1tNmbDnqzJAMFuRiThlER87xRRe+04fwLZ75A28ROIAANzGRUe2e2GYw6yy0jbAsq1Uog6HiU4cyhpWztkEHMAc0nF9sSwQP0AS4YkEBQMWyh4d6Q7aEei+8QWF+NDTQ49faKpULrbWTGYERZZF+u0HQOVe4F9zxIyIdtUNBLhZFufAUnLmCf6TWSyULzm8ERfQavHmWqPpmVq1h5FQPijST+14j41/8jkuCvOdTR5OHgxrP/rmNVrU8fvcRip
 NTWlrFUU
 oxPnlvjpe2tGFZCLx+UuFHZ3FsG1LlLuD0YqO1V0E4YFexZcA9KWMZ4LJNuuRx/eyQJx1ye08WGTOypm2gE15NQf1tiJEesTjLPzGt4nbExjIKd23nHvEt47Z+2HUFbXnmADaB9IHLTmsasfX2z/qBaT9e/dkb4YBG33y2s/GOZDMLtMYZC7apydzFV3zhkcp2rmkCZBZQkGCDQxOdw0E/NKdZ5RQJY0H2YumCe5oqm+jeWqU7dnS2x208rYduIGJdwFEJt8gic6UFtih9tLcTkexEU2bPDCHNDJ3TR5hSgLKp78D4AtgU1C3KuZv3OGxvcvkfVw90Ief9a+2eNwMcmrssqdHiUDpgp+L7TAj6metQOxLP3tZ+SLFZS8xsC7pWuqsMXSEkpMUfyF36kF1VO39N8o2PY+E2gik8MylRoucYv+BNSRCOOZZ/kDh/VQUC0KbrwkU/KKWR35BKcOjmAzXFQ3Jr4u7ud36k+IhNswrHHEmH6TurksyJTvildZsReBA3dflM/dnagpq8JNlRF5LCa+SdrCQEHNqyH1FqpGuXjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kobject_init_and_add() takes reference even when it fails. If this
function returns an error in sysfs_slab_add(), kobject_put() should be
called to properly clean up the memory associated with the object.

This issue was found by a static analysis tool I am developing.

Fixes: 26e4f2057516 ("slub: Fix possible format string bug.")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 mm/slub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..9f0f03460b4d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9492,7 +9492,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err)
-		goto out;
+		goto out_put_kobj;
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
@@ -9506,6 +9506,9 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	if (!unmergeable)
 		kfree(name);
 	return err;
+out_put_kobj:
+	kobject_put(&s->kobj);
+	goto out;
 out_del_kobj:
 	kobject_del(&s->kobj);
 	goto out;
-- 
2.43.0


