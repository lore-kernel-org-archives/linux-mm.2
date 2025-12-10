Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBACD3C520
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 02:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660346B0005; Tue,  9 Dec 2025 21:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611646B0007; Tue,  9 Dec 2025 21:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8BD6B0008; Tue,  9 Dec 2025 21:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39FE56B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:20:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F7EE12F10
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:20:40 +0000 (UTC)
X-FDA: 84201957840.11.666E2B9
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40A791C0013
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:20:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OA04sE1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765333238; a=rsa-sha256;
	cv=none;
	b=h9sU8y2SJGj4QLDBgZxSFysUqm1eJKOntgcLctMZMhUQCsmp+UNyjKIg/NmIQ3bXPqMt3j
	jV92Ni+FF5EWd9tl3cJFcRlLgz66q0pp8BH7OHTrmkIEWNXYSwSVDGLRjAN0rvn+us0gcL
	pF1RIJ8g3t7QKT4UVnuTh33ZCpzQgDc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OA04sE1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765333238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1hgwXyIhsOlBx2ai+QKi5I8i7EJWnRRhSoZKHEZC4ZM=;
	b=2J5Xp9JoWXzP/JFe5LY09eQ9c7rHVX3yp/x/NzPEPuFHG6Z+U5+Yly2x8q5duv2s8W92Ve
	csoZyEK/7J/WxaubI+FFnpbHKK/SaK9uw09EGevE4+orz9WTMD8X1Cp/lVKv3CFjE51MWu
	XW19ABFDqXqqYvj8qyb11bc6ccbB6wI=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-343684a06b2so6622615a91.1
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 18:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765333237; x=1765938037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1hgwXyIhsOlBx2ai+QKi5I8i7EJWnRRhSoZKHEZC4ZM=;
        b=OA04sE1WQtt2ZDwdshtj3Od5lfgwjcAZRjK0vhB7Akjz5kRnyB8XgV7fxZ7/kx25+K
         1ghbY/G5oJcC6WR6YYPshmodJqew90kE1rgSfovSDsjZ+UvcKw14y7ov/k+j2A6F2XC/
         FJIN27I79jUo6A1Z+4KtU3ydD4R8vf+OCLUIjKhzf4ZgwuAjXAkkQtHobaDoMPTrbCcq
         Q3aIUSST4YBMTdd054DfmhB+0iuQL5LZWIjxB7OGbW5YoJwLoF1L4q/dKpEROmc4G2aU
         aFz6/t2GJ5qUWSi+pVv+vrlL44NPTSFd/1/c3oZXLCXN9QVJmwE56A9drWLulS68um9s
         RtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765333237; x=1765938037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hgwXyIhsOlBx2ai+QKi5I8i7EJWnRRhSoZKHEZC4ZM=;
        b=vAqMiZgBW0AYu7+wmAfYdyoVhNjXogwpm/PRByqkw6SVDmb5gFtm+o7QNFZFx/6BL6
         RjgamGCBBddmStVhQFzo8f8BQksYoP9LpYEYEpH7JHPba3jm+tH/V0O1HKqJGPzmw0UN
         NvHYqh1iH5lkyfOepb3brbcEWjApjE3FkS8Bn15x+my1WGDoZIcCTpkYJ2kbk8G7y+/D
         wWlcEu3bdmhr8MO4mEkBO01F4ubERUb7CiSFUzQdwexFYwyAvtSxbUVUlHqIb4c8R+Vo
         lbdhC/X+NSudC5sIyTFcCmGVaSkG7crIZI3w4YGWLQbF1TMXpMZb0J7PJH1XGzmOPk4X
         gwrg==
X-Gm-Message-State: AOJu0YzsKiCUdXja79/wkWFUomwwLr+kn/PcCK8FUKDLWbfL3KCJVCQd
	30Oxd6VpgK3x5TEdsaraWEhK+Wvkf1L4jGm0dojpmZYbWfgYjdfxJNcf
X-Gm-Gg: AY/fxX5FTCsWW/l6pXoXqt1AcVxX3SfPs6ylvWEMoRBM2GFV3dxetQnY/MF24oY6MFO
	srgFzhoO82iU/Q3lBIPyXJHNk7smyo3doDD2ZMlxR4ZTRcnHwQDk3RCQxx5QpQEO7kzFlNdljeB
	maVvOXfm5i2WoXBdq2vpFU5KxmHCv2auvaowQdiLoUhHKKdZiQz/8PJPlFooeHC9v+j5BIEPIXU
	qZZnFVHfne/LG+sS8wcdG4S8paRzeIGRAq/60WFnqZadlPy9tXjLwACiKJQPHsy3qSjV56tFwhN
	VFI+cT2NtiYhqvhFbWGYrbTjQnmZ2d1JjJrbPLrMQFrVNzgyrzUeGDa3j6ad5pqhtprJLVTtps6
	sQheylyBvIo2v+lG0AgSloNph0mgweXtG553e5t2LjfYfLaZf5KzEejX3zMgDBTZUCyjKf9bmOo
	cDSuZSqAeKNqoPM5zFkjMVc+sq88cp6Lr3XtdkqN3YXL2urv9ZpYzggQup7/xvGNLqCY0=
X-Google-Smtp-Source: AGHT+IHLHIerDr0gMLPqPgbC6hqm3lmPtR0PfhJNDNVbOYo+TZwEbADxoItQ3BZxmIDDJ8VAClmYsQ==
X-Received: by 2002:a17:90b:1c12:b0:340:ec6f:5ac5 with SMTP id 98e67ed59e1d1-34a72809b45mr697475a91.2.1765333236955;
        Tue, 09 Dec 2025 18:20:36 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:c197:3b05:5401:dca3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a47bdc221sm1601937a91.1.2025.12.09.18.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 18:20:35 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	ast@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Subject: [PATCH] mm/slub: reset KASAN tag in defer_free() before accessing freed memory
Date: Wed, 10 Dec 2025 07:50:24 +0530
Message-ID: <20251210022024.3255826-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40A791C0013
X-Stat-Signature: e1hbxbzb5a65y5c96ouj7nafwexbxgzt
X-Rspam-User: 
X-HE-Tag: 1765333238-655602
X-HE-Meta: U2FsdGVkX1+aGH4IYn+KLNhle/7zmBViOKl5wSe9OqXlVsrEAvf86feOe6igy/m5CCtBzzc3ddYv1tZYoF9vG5qBoSrKDqxJprJAZKMeW+C3ulSnfu8J8D1V+EUdN7EVieGvLyi/MpSBuAN2+fjj9J2qHGqM4IaWtw2wvkAadPg6Jd+HY5oz4MguAboELvmcMHAxNz1VFt7cjbhgmVoriMu3klBmpmVxmglVPTnhUPsLaDqb60PKIl6SUisSPLBLBXJW2jcknDS3VeX8/2inWkCgHfPw8Ad4IYXJFAF/VAMIg3hivayNecmrZbrIfOmEiYgI3J7sfPaT24T+47/nA1IHJc9IBytoeBie1ISXNsEMMi7INSdIy4fBWX46UpQ6/ew7etdinXnREoZzayKhCvX8uYnfvAuAYUbPRcFXM71eCEGHUNLV2BdlWBcIyg69E3AufsuvFQ9SpKpd0JSPl9bAuyV58a0aXwXFojq6Xu0ejGMsEec1iZcQoNcd7iAOG2qd5vsXL6LcReiKVENA615Cxtm7/z/dcKgZc3GKAoPP3crK3RYnK2oowxTYNeiV7dffX+4E+4PzpiCDCuKMjqkVuWsACD6f8J7e0gsEpfjWr1rm65kSxTG5aFKVLqNkT6yBWSVqQBrr5eIi15IjO3cpDH/o+fdiikMDq1DnXRAiEy83uwQs74+wU3PcFjaSqWN3O3QcAwAQrQGmPT8YU3aLF+jtWgflJKRKklbLfKuXhBWUs6YMb7PxT1KOGmGxlf8ZZcwJmmqYmAouAz4diqPaIOsUiRlwmihWIp1DpHMvf9CDLMk6aNk1nqqJoKEucJXdWoMxmlDkcNbilU+apK2TCYx4pO7Sqsag206l+U37/YzElZ2fBwfKuij4OvS8iI99MacA9HTEZJkneJHT+5PhSu/IeQtHRZYEE10TyoVtyfzHA8dZbQ9lMtW60ARyz71cUjTwxYn+EHEyGuw
 +z4Vr8s4
 BP6pa2pY+sR6YMkKWxOjPWqxD+hMC5+9PLka8FKPKI4TyTDEBN8RuKWzlKv65Z3NvbHC2oByeq9qoa7YSpKoI/KvZ/p5O03h198S5ytyyB7Igb9m+mekWuuuiOpGWS311Pz3dwSj1NJN568H4cv1gB14xGV7KHRbetqYNuwnRjYfODiHln2FcNg4kn4frEau+0QcTI/s9oBdqCxKpKO765DRpWkXq9+AZSm9/p8pTeBD3EJFwJvVi1+/B52FUxuGzRzpXQcv7Hb4VDQ6YCJLSD1H8EUF3HdUOCQyD+PRQxletiKzFVMU7IcAUOi9u4oBHYj/nUgxE473eHe1+1f+7HeDBQvpIXvfSV6H4C+hDtHrXWMHGBUcbciroM5pPVENckTpXW6/I9ReGvqcPL8c5vAACgZlMVJHegogQM48fWXuVNMC5VYMLMjNFiEOHkKinSCQA6No1XbwlvfLkIAtmPGjoWn0N+gnghrgNj99yLllOjQ385QuFBabAzaXgg4xIqJ+YeD248RDU/cdO7cq/WtsBwOyatNteUcZwQAUPtf47Y67B5u84LZPFpSFYA7mzqdy865mGyFP//NAWL4yskQnwu33l3mjTSHkF8DcfOVZ+TPwSlZwBskd8RRatvfIKoH5qRvQ7Lpns5Jzjmxf7ckH0Y2KetWC/b2GBWT5uxRpxQTisNnV0Tic7YVGsOTR8mt5yY3dfYujQLfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_SLUB_TINY is enabled, kfree_nolock() calls kasan_slab_free()
before defer_free(). On ARM64 with MTE (Memory Tagging Extension),
kasan_slab_free() poisons the memory and changes the tag from the
original (e.g., 0xf3) to a poison tag (0xfe).

When defer_free() then tries to write to the freed object to build the
deferred free list via llist_add(), the pointer still has the old tag,
causing a tag mismatch and triggering a KASAN use-after-free report:

  BUG: KASAN: slab-use-after-free in defer_free+0x3c/0xbc mm/slub.c:6537
  Write at addr f3f000000854f020 by task kworker/u8:6/983
  Pointer tag: [f3], memory tag: [fe]

Fix this by calling kasan_reset_tag() before accessing the freed memory.
This is safe because defer_free() is part of the allocator itself and is
expected to manipulate freed memory for bookkeeping purposes.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reported-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7a25305a76d872abcfa1
Tested-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index e6a330e24145..46959c6da2cf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6534,6 +6534,8 @@ static void defer_free(struct kmem_cache *s, void *head)
 
 	guard(preempt)();
 
+	head = kasan_reset_tag(head);
+
 	df = this_cpu_ptr(&defer_free_objects);
 	if (llist_add(head + s->offset, &df->objects))
 		irq_work_queue(&df->work);
-- 
2.43.0


