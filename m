Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49B4CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FC58E000A; Mon, 20 Oct 2025 20:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0CC8E0002; Mon, 20 Oct 2025 20:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7768E000A; Mon, 20 Oct 2025 20:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 795008E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:09:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34F1F1DCD94
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:09:05 +0000 (UTC)
X-FDA: 84020186250.09.C96176A
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6687A40002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:09:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PhGV7qnT;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761005343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wh0gNpXNnj8TcdXtVkip0MO+OiSr/N3ozqVkyEmZbiA=;
	b=CxI4q9iRiCxLvmSOynArNWYih4b2lJa6bC0dwKjmiajOpkxFw6zYRc91kKy4YmbcUcgYkv
	/IS+CghLdSWFGG8iYDY/PBAe/hfbUxIiXgm1M/ygf83grsUUOVciU1HDdy8Enl7iXlb8pz
	PxsMxm7mLBYxDzzwS2vTjfiCwqoAYBw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PhGV7qnT;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761005343; a=rsa-sha256;
	cv=none;
	b=7fuI/yhq+R5lfSEmJoKIyegvtnQyPLztolTr1KcAh+yyIwCeu7uiN1DRk1oZzcwXyQODET
	u7SYL/UlE9QP1f+xQhb8iEzmYUy609eioYfV2Rk2Rgr0hE/gt2j+2alBYdRW7uOVuVxGjg
	Fty2e5/tek/knnV0xsZhsfFt8lfSRSc=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5a0d17db499so4618219137.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761005342; x=1761610142; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wh0gNpXNnj8TcdXtVkip0MO+OiSr/N3ozqVkyEmZbiA=;
        b=PhGV7qnT2PlaTBgXQBniOBsqWsNqua1Qm7YxUk+T0A/Egp5z0NJQHztPYh3sLnOLJe
         mqktIDvpevtU4tFKk/eQ0guEcY3JVvU/T6smWe189v8RA6dePO1M6FvE6BldVSkSma6C
         VB3KeUu9JcnttLyStgyCvsS1LaNAyY2betqXB2ovhZ+7/ybYUdt3h5+xE/S65k6mXFf/
         RrRAErRHi0veNrFArBW8wgkybw1ognofAXTjCMjUqaJaG5hqg0aWXY4fFvOBgUXOWDke
         LOrw9j6C8DVFXCf6pr6TcU2zWX2m08mjyWepyZd9oYGav+gDxOqFM/GMH+szMmrboPE6
         TR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005342; x=1761610142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wh0gNpXNnj8TcdXtVkip0MO+OiSr/N3ozqVkyEmZbiA=;
        b=H+Yjbq+EaElaL0ULOM1kkxH57SczoQPJEt8ioIsLZj5gegIAW44aL8SaHU/l4oiV/q
         j+4xX3jaM9PWyWqLjc9SGwbo9uBM3WcWi42qy90sN+t8CH71/PoaKXUYpXyiS5VAmvvP
         +S06fNrupaZiTWk7AfP/mMIE6DipMAkxjUGakhrcnsoWCIrQKNnNnukjrMZA7tnibxAr
         2Fxb7c01orpKvMy5f7y+OrmGcpUTk6mQgyabTmrDPAzz69rHFalBA55akr20xjGn1Srb
         8ZJ3Vqx2Whi98oZ5GIBhognrEsA+ZlTPI0S/mFietY1VnsfYK2btVlh5w7oJPOzQeYyX
         sxAA==
X-Forwarded-Encrypted: i=1; AJvYcCVPIg2eeJmHD39gZwR/3yHAVfW3mkFAD9Xkb6mslD9i6ljC1BbmSSmah+DdchMk4XtuegKYTpP9CA==@kvack.org
X-Gm-Message-State: AOJu0YxIJZT5JhI5bT/02t/U7mSCAA8AaahckDAAqK3PPK6xfXwYdGXZ
	j6j6wbKAVO3ed866DzvAp2n/Qzzm7tlz9JkIi/v4wLHg7hpv92D+q0wCVCQrK2AYjJM=
X-Gm-Gg: ASbGncvbVBRYthrFrOqMo2mk3svv9fSmWPC0fj5i1LA7JHQXns+eJOQhdNb2Pao5GGT
	G9A2dITO3bNUNwM0PsfoecGVT9LcsFnn0EMlPkmPVse/XWTvgbIdZSmUe69dSwtshKbq+v0mZ0u
	kTz3wsXBVJw7oakK+DQtv2EAeuUmcvRCZiFXXQ46KMclrB16sUVnOO3b4rhW9y+6Wwzaadk0o9f
	yxQew3yYq+4cO2nG6g//iBEkrj14SfTyUEZe8NBzThmA3D2jZ7JP59Y2S3V1CnC83lV0VlYthSG
	Qr/+7pHj/PFia64h5ERzm9OHTNyRl9flD5cHfo2UaUZ7E2kXvi0khc55QTqTlR0R2JTZasqFPYM
	B0F2R0AW11PBPAVOjA8Y5VfdMBZrUaYxHn90JcWSWOdSwrX6yn9NCzIHfwhnOnOUCA1EZmf5MCq
	UHq2dpfo2brMIpGKVYBT0pYEx1MO+LOA29ZLnwltAmG30TbS4ikmJh6o8f9p/p6CP4gQSrrp1nj
	JJEJcX2WJLzeF5nLfgoTQ==
X-Google-Smtp-Source: AGHT+IG0ndYvX9zTAvm2KWn2q1XKGRimjxxOoCLwpUa9MT4euTBOB019JcZ829K5pfY69/fTaACVlg==
X-Received: by 2002:a05:6102:3e85:b0:59c:5e29:dd8d with SMTP id ada2fe7eead31-5d7dd6a3fe6mr5404303137.28.1761005342511;
        Mon, 20 Oct 2025 17:09:02 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55661f6e351sm2822882e0c.4.2025.10.20.17.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 17:09:01 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v3 3/3] liveupdate: kho: allocate metadata directly from the buddy allocator
Date: Mon, 20 Oct 2025 20:08:52 -0400
Message-ID: <20251021000852.2924827-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
In-Reply-To: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6687A40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cwjiexdptdbkk1ejjq3ghks59u8sczhc
X-HE-Tag: 1761005343-813989
X-HE-Meta: U2FsdGVkX1/e0/8AaR/59ckVfqulQ5zf5h2kpSiZXFlrmAWKdWQrGL8w5H+x08SBjhDocnbP6vB7a9yTimtAgnQeo3Vb6Ug0AFwlqxADTYmT8TV7XGrpGBPyWigNOYSZvZp7MlgwHrGpp9OoAcfiI9kJ0JnKTi9pmzqkxZLVXSHoxCq4kBiX1Chgef/16y0zQqgtoC7iIs/maTXedoRdZJkce6aQ99aR4OqLLsiA6eoOlgXDZClmCIpKk8Re9PFX3FC3Mr0N2YwfINlg5fnmn15xU7X0T8qXNpjJYeJrmeZnpNaakWK5OOWXiARJsESIYAX/XnEvGr58Ci0NXHQezhNE73pY6pMf0y0qCYDsAzf5DRxqCk8f2KGJ3Z8K0ePy2ydQlfBkdhm0rpfn459kHTKLxB0TbBgdb7KLVCo94RfuLL1F0CFwmHolfhFJIfG1daIU05xNLgXb7eDZYrEcCBzlxkCIzfec8c4WABWN7mCfoZn6+/6E62mrPXURc4b3WZo3jPyzUm5JGGV3r7tUpYujtSTJaoT9fW1mQ/FCmSr5/vgY4mMeaT3BMOajrvK9l5HK0iwOduT3XlMvNP/RF3d5hXtkTnSfgBuH2nl4SwDt6rw0jotH7DEveCDfCcu7Dh9CEpxRhKKmBXNG7RyV/CHeQbn+diVpCSti9BB5Jhwo7+QPvNhJKfX1OjQujx2oWdAoap87CMnzdBaaLGnbYVVWEhpSEVN7d99g9Cz5jGxe0cw04gw2/DOF8mcMK/t7XW3Zm4SWRpYWoXtAoKTsUYwyqpYaEXSOLGwzYRcCnwsbVcPMILkM3VhL7Ogk455WgI5/Y7lRTOgoUXe5os3HWFQAzHYvBYJVNtoaQOaG4LJDkz9MQ4R1UaqU7TY073t/p6WHvJrDx9TpISiz/zVYzP2lGSabccUPyEURNh8ptC7vApgXRQwCUB5oQaiZ0MP9HHFRRUhXXv0q1CS5zns
 0y4avYtY
 SVFo24PYf22c6Qk/oc4r/y1GgejybM5OylDMArU80fT16+qx+JB4SbgXU+dLjNU3ysJMoD6aEyGV0/XYESrBEPt9/5K0DDIm4uByhqECjT55top8zd4WMw8fZmIcN0RkbNbFWEtduNlQZpfJtsVjZf7BM86fb8OaaUnun0yTXNzFXzpQ0m4LCirFCOvlYWWnEMqKH2ZdECpdotgDpyyoMClPBifLLpsaiuHeM64oHIn37UPk5/GYwTyYHnBaAcB1fA2u3Uwg6yhZPyENcKZyPU8md9e4BAox2ti1bhs/GK+VYQ4w0ZXhdPwGntq+ZHlJ47D9WVPp14Nk965o9KPTi5quwdGi+k/nQnDfVEwDZSStyRtiYSG9vIRoQ2gM/JdW3/KhK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allocates metadata for its preserved memory map using the slab
allocator via kzalloc(). This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled. kzalloc() calls can be
randomly intercepted by kfence_alloc(), which services the allocation
from a dedicated KFENCE memory pool. This pool is allocated early in
boot via memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it. This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec. If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is
loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of slab.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/gfp.h     | 3 +++
 kernel/kexec_handover.c | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..623bee335383 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/topology.h>
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 
 struct vm_area_struct;
@@ -463,4 +464,6 @@ static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
 /* This should be paired with folio_put() rather than free_contig_range(). */
 #define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
 
+DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
+
 #endif /* __LINUX_GFP_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e5b91761fbfe..de4466b47455 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -142,7 +142,7 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
@@ -348,9 +348,9 @@ static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
+	struct khoser_mem_chunk *chunk __free(free_page) = NULL;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0.869.ge66316f041-goog


