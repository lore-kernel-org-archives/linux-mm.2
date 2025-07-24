Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D18FC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B024D8E0081; Thu, 24 Jul 2025 09:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3D28E007C; Thu, 24 Jul 2025 09:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A8C8E0081; Thu, 24 Jul 2025 09:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 837CA8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 518E71DA296
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:46 +0000 (UTC)
X-FDA: 83699308812.07.E34C239
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5A2DB40002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=sHgJcnBk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5mN880WCISqsqqypOE0OCrYzPzbEuiPZ0HVDAJk/kA=;
	b=oQzQ+D0LJN4yvIRhM7q1QHuj90vsJbB1U3zrPNkfXmmbiMxYZAXney6bIoTCMR175MQcrZ
	NyGQ10UxiKPCPKq5JpjuDN6oSYBCNlIJshP4zqyGo/G2HtEHCkG1NgzR7n7nhxi/Z5j1MO
	ZKeTwRifCuQM59zqNXwtAF2VOgLvSL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365404; a=rsa-sha256;
	cv=none;
	b=MLDQhXxXemn7c2UyFBQ2WemtHpAOCsRvy5qF+DoFo1cSADDmWFR5YIJIs4o+v9ghqeHMhw
	mwo7hlf/xOqk0THKVodK4II8cRnDfSr7o6tPWDoILPGYa6T7u5WY72ibtC2iZOae3Hn57n
	XOEoXbT+GZLD6+HvU4Vg5+SircXyzGg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=sHgJcnBk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455b00339c8so6847095e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365403; x=1753970203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5mN880WCISqsqqypOE0OCrYzPzbEuiPZ0HVDAJk/kA=;
        b=sHgJcnBkcClNGXhkJFrSWh106Yh77TE+KspixRzn7pwNJABhj6pFoThKdc72B044xb
         D9Q/TANRoUbaslUsOuvJRlTgiaSLhijhsJqALY777Zg0yxadnz/J8drJXmuX8EFmQnlw
         yCHH+nYyh+KMumyhzLS7ufGWHbqThHFXz0WAz45KQ5lk2iFPb4/XmTmdDSwnLwZVHZ8c
         YRww9HBjPc4AI++f8FVVK9flxT/90qv6u07JHRAMkX7d+b+ChN9kSwNRtRcBVgKG181D
         52KFsC0sjPbL6w/3QGbQBryeDVLWlaGQtR/nMgTxPUOxCgxYeisFnNYGx+Vy9XWzX2j+
         /3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365403; x=1753970203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5mN880WCISqsqqypOE0OCrYzPzbEuiPZ0HVDAJk/kA=;
        b=bf48Pf4V71NaloRh+oumM8HGBo1Y/GR+8jsUIqW6/oGZ9gwxg9Vrwp4tzB0rlk7jJ/
         RUz3J2r6tk3f15dpW/AB2X3P02fHaVUsyuxgv2RTkNEY3LmznpihK8B093A4Z/o5iybo
         VSG+G5T254Q4sEzBf9YuliClavRmHoOS2UVIJaFmpYOCPkEaYJuL4tXLtoeBQzNbRUKb
         xtsjcaqyjt+m+qNJ61kOJUmgjhku1grFzIUYXNzZyFK7yaGiAou1I0h4+5uRbI8oj+lq
         BUY+gUalM0kmEJYE8zWuGqWNc0302PLKxOhZcoOH3wDXWgddQLNTkcdYN2A5+C2Gu0Qp
         JWpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJujBYTh7khS7oNRM3e+qzrGy6aoebv200hzjO7O/5t/RVDw6EjxaGdeLyAzLhbsYtFXnetrlQTQ==@kvack.org
X-Gm-Message-State: AOJu0YxiGmZjsDGL5h6eHVgfYyWKnRjx6yAQSqKTPbLZ9BL09xuKXbgi
	8uvdqciVTjowLhLdLip6iOnOZVqwftyeFDTJrCSZJZeAEiBHiJK05Yc4QDmF61gT1ug=
X-Gm-Gg: ASbGncuLFFhF7FPvUhFL4xMAx/lL9V4YBKeb62oOYhUaNNKHEicWxiR40olwgp80Uo/
	mo5q93DtK4QJ9lnk11Rlwj/meZEQGz6JSoSYhzZTjpjMXJOzN9AOJmiKWcBSZ0FSjiMXJAvTJMU
	uXIWKAcxx2K96CYjce6vXVhLGaj81OxOuaWHsLoJfLjXdn/BoSxNhRRzJeGYY2fpks9Wan7+KB9
	mOPP/Gh8cBjli3wI31NkLxHN4RE5jYgZBABpI9+dbejgBTnW6ziWE+0+NRRYqp8fH4MRatckdh5
	lNFOx9eYQ/Uh8Kn/ZIYyUvzuzn5BYgfAnD1HGhCbhoYYAfsgHreysk7rbFW2rNG7/b/BfO0XkmG
	c0Fw3RUcPRhgL38c6QrnnwhIf/rpVCL7tRG0WGq5nlxNle4r8r6VkQz3HBzo/yepWX/0QvaDJ+3
	rqetlCp58vGgC2se5cSx7/uBQ=
X-Google-Smtp-Source: AGHT+IF4egT06XIAWuc0TJnVdNpe1wQ7sn3xvEGeH8Rc0pzDJnMJjBpN4GYnZW+sz3u5f7Eq0JGLQw==
X-Received: by 2002:a05:6000:3103:b0:3b5:dc05:79b with SMTP id ffacd0b85a97d-3b768cb0f15mr6041122f8f.14.1753365402888;
        Thu, 24 Jul 2025 06:56:42 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:42 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 23/29] mm/sparse: Register information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:06 +0300
Message-ID: <20250724135512.518487-24-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jhod3i3tagbgay88phezock6g1ftwad9
X-Rspamd-Queue-Id: 5A2DB40002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753365404-862286
X-HE-Meta: U2FsdGVkX189pjwRyqBrr1353iGm1HSzL0bIRf+uZsd4G2SvIEiZTnxbsdnpGmMXqtz2Uy+R97u+D8RviTIjIGLjPtMiYi4gX/aW9JewRyg7fMeUF3IRYx/3zM4dsrsy7SCSpslq3QY+Gj5TkJ0uQjzfDBfnw3K79S73qUawt+16JX6sc/WYuhGt9uLB95iXd36sq3yVgon/RhPu6hMa+k6ZZoIzkvzkIf2cKKTIIfdCNQM50FeC/rZHlRbS5HA23lr/QMsHXbyD6G3UR0oN8Jh7YEKrvDCicQatNt0oyVVSJnHALFg/IeHO8EfG0UqQPkVxgGUfWlZhp80NVOAzCXniBv9RmrZOA3djoe6DZthqU99hhf2fvjrkEddAhmN6JhLdbq/CevTSGDDWbl5qz9dkJdEyvLJ/RIiHve6QOixEWy9PvJPpsY+UdwjtVnxeeJkXxzP2PfpOgcmylL28n615ibj+31ap/Faunl59DyyzYdR7dowVMtxDM9YgwJ85q+sB91CW+ngpV3YpxOEaqolguQ7Bdh6OjStajAP8R/WoPtezYS+cSqO7DJ4bbyqkspai+Dr4KUiqbMkBthFpuxSEu4rUWONMuyuh7sG8z01TZkQIUDoUa9wJ1jlZ0DtoJcCAEEIRqmhem8m3qXreJUipppDlti+tNKzZ9yTRW5YjkLirURklIkIqDuG9Lv1c3xbA7Y8jALgzkmjUcbeMGiv7+CvwTRH0KoQT+wZaQjcchwpl0LjdNu+2DTUi2Q4nA4r47uIjZ1iOsImSVgegnm0QSp75G04i2Aq8pTNLl5Qgt7OP/EUOqGYD3OQkdS6BOWnmXZmy/Kp6rTpx0rMFfJkRnPrpZnuzVdSjRKmnCqnikQRJEc8yTaJB72QJY8Uz1gd27vDF0dEj0m1vQUywtUCQ65NTOvT1wb0OrqN7HbdDxgdO5P5CFHCeEPL2CtyqCA8G+Z4oGDvOwatLRNt
 f9GZoUNb
 kacGhCr5fFr/VRhoGVl5V3z1LByMQvOF5I0eF1gCMgq+YWvwy4fw3/B328ws/Pp6tWQlLQlAXkRhTIal4laDPKIk3cgw7b+eVWQN+inw3AfdkpkpAql3sc5P9nzAGjN2QJU/XhxlblwIQp0cTQqVMSb7QslQXgd7CWilOvB2DX4WQyfyKMiOLrrU7cx+BJjR9k8GfSDMVUhHDKYG+dh4XktsMEZnswiYfX2xtgPOiS/uYiXTGTNPyqih3AVtySLFI4B5QWPKk1Wu3lm5TiHVLrJAHaayVX/QDZR3WmzyEHKzZ8dImuHxX74di2UDRA9/5BE12PLn5m+pc7s8isG/oRabTyHBkYJGLSMSkqlNwpDF0Kw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - mem_section

Information on these variables is stored into dedicated kmemdump section.

Register dynamic information into kmemdump:
 - section
 - mem_section_usage

This information is being allocated for each node, so call
kmemdump_alloc_size that will allocate an unique kmemdump uid, and
register the address.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/sparse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 3c012cf83cc2..04b1b679a2ad 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
+#include <linux/kmemdump.h>
 #include "internal.h"
 #include <asm/dma.h>
 
@@ -30,6 +31,7 @@ struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
 	____cacheline_internodealigned_in_smp;
 #endif
 EXPORT_SYMBOL(mem_section);
+KMEMDUMP_VAR_CORE(mem_section, sizeof(mem_section));
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 /*
@@ -67,10 +69,11 @@ static noinline struct mem_section __ref *sparse_index_alloc(int nid)
 				   sizeof(struct mem_section);
 
 	if (slab_is_available()) {
-		section = kzalloc_node(array_size, GFP_KERNEL, nid);
+		section = kmemdump_alloc_size(array_size, kzalloc_node,
+					      array_size, GFP_KERNEL, nid);
 	} else {
-		section = memblock_alloc_node(array_size, SMP_CACHE_BYTES,
-					      nid);
+		section = kmemdump_alloc_size(array_size, memblock_alloc_node,
+					      array_size, SMP_CACHE_BYTES, nid);
 		if (!section)
 			panic("%s: Failed to allocate %lu bytes nid=%d\n",
 			      __func__, array_size, nid);
@@ -252,7 +255,9 @@ static void __init memblocks_present(void)
 
 		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc_or_panic(size, align);
+		mem_section = kmemdump_alloc_id_size(KMEMDUMP_ID_COREIMAGE_MEMSECT,
+						     size, memblock_alloc_or_panic,
+						     size, align);
 	}
 #endif
 
@@ -338,7 +343,8 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 	limit = goal + (1UL << PA_SECTION_SHIFT);
 	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
 again:
-	usage = memblock_alloc_try_nid(size, SMP_CACHE_BYTES, goal, limit, nid);
+	usage = kmemdump_alloc_size(size, memblock_alloc_try_nid, size,
+				    SMP_CACHE_BYTES, goal, limit, nid);
 	if (!usage && limit) {
 		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
 		goto again;
-- 
2.43.0


