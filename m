Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DD9F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C80A6B00A2; Thu, 23 Apr 2026 22:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379226B00A4; Thu, 23 Apr 2026 22:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267BD6B00A7; Thu, 23 Apr 2026 22:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 113BD6B00A2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C58F3140A1A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:09 +0000 (UTC)
X-FDA: 84691935258.21.E52232B
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC5614000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a4CxxyR1;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
	b=P/ggI86vF8XhbP+X+WIs5Utxp7iCFTTTHXic8gcNhWDpT70uouL47g7LcscGiAbl6OPfac
	ar02xr2BWB8c0kjVYIQysqKz2c1mUtYFP3TjmCKjR5X79vLsq663ARWnzXE+kO2iO/J2Yk
	zSKEJWc5N3ggv+EnTKVB7beDSxAnCuo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=a4CxxyR1;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999368; a=rsa-sha256;
	cv=none;
	b=IwIwWsdp+iOPbKfnKyxFmD3iFuQHY8t/AGh0tccyNOO//G1AEVW6k53v5W28B0dtIFPvud
	bXB+Ptx/zgIIZxuLrFb9cM7R1tqJTdvQoMF3+o9z5ygDXvJYQLcE2qHGYszzdzG4smhWpa
	dEukzV+eGtpwvlJdgEmKdomJa0V0MLU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad9516a653so37176515ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999367; x=1777604167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
        b=a4CxxyR1+UDH2qIk6HY1pv4LzQgxIAjrXDl4oVgeKOt7KoerWTHP3R9+GFHcmgbCp7
         4mG/kHv0FOVZXPbeV32ONsNqN8Ja1l6c5lm6ElxQF0MOqOUumdjoytMuvyWt+1UBIfTy
         M2gayYuaMvsV3kajwncgVVt5Sn7cOgIu6TylV/NZAN5dVEin3tqSnw8x03Mwk+4sW8KB
         SiBMb8rDnC7U6PPmgT5ei50O9IVs+LoNogzBosG6Tb3e0IyEzt7GqFdamvKSkpAzvHm7
         Z6Z9ySD067N0b0jy9ueRDo03yigoljBgqM7ohU9974yJ0J3kgZfCag0VBDc6C3N2RCYG
         uyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999367; x=1777604167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
        b=ZmX8K02+2M/5Dobp87Td3OnorHmz9MAiajjWnECYZi2TOa0ytnv7k2j7p+IXSWh6Bo
         5rjdwnet9gYcyUtJeK68YXdVEaydB1OACYYXSDkSMl/U6iFSbVtPraYh0bYndro63SYJ
         RTOqz+EStRhzf04qZfS6UQe35bfhl6JQpvaeS36m0gG/8LsvkX1AjfkgP6xqX7mhDZen
         i3IsEFnHSfF/F2bRmmIyQ/iTNHoBNiolrxImKLCrmcm2jqMT9PFH1k28o1Wv2DFSfuWI
         ScdqfOpMqNO4KSv/I/zmHoq6yWxugbTYMnWU2YRQbuk6qGLl8C7/ATb6avI25/OiugU1
         JtqA==
X-Forwarded-Encrypted: i=1; AFNElJ/vg+CS56688219qBqNTSMnbsbhTMYghsl6Fu+sKMF4+OzU4btm5v4VE9UK62TaQC+um74TJYFKTg==@kvack.org
X-Gm-Message-State: AOJu0YxOBH9ncmgpKcgcf17EOO28jzNsZ26s747VqxdeWKxDQ8dasoV8
	7nEWR6qKAj/ljB3GyYufa01rn0erDv/8XmcS0RcKpRUOEH59+iqu2UFvO+nFaoDfQ5c=
X-Gm-Gg: AeBDievcKdKC2x8ZjWQTlV99ax2wIMejWWMPVypWAi4zogap6D5Kc8IsDxDBu9gJygq
	zp15QExDPZKRwl0XaWu12OoBa6L4lDj7B5kQW3bLZ73fqb998UceEXgSjGcVNam5W4eyf8lN5is
	A8QvzwHzXDySj8z3rzlE0RMx1dve+baLzuLVEDiGtUiXsS8bA9xRrBYBkI4myRIet1IAVqPJgiH
	zvu+iBUbLTvh7VUKASxdPyYEGtE5DvkdFCaByRL1DdTYDZMfaJbuha5skusmPd1DJWzNbtEwmHG
	2s7TOUovwwiI0Ttcc/vaPcAyY6OID+RSZZKQkUuW6lrB4uJx0zZLuq/nm6OhJn23N/bWg9CUMP6
	tGs5xZc0eF9qsqhevOunrFyIqdTBQnHhK5jrItzWu39EGu1rV8Tf9TxNMfWRSZu3Uyky9xDC9Zz
	HWa6RRCsX6IuFc3imFcrtVXWUCC2mqDZt3/5rkdeKllUEVCt6VMwHCtjE=
X-Received: by 2002:a17:903:2412:b0:2b2:42f8:1a4b with SMTP id d9443c01a7336-2b5f9f3a987mr327922445ad.27.1776999366531;
        Thu, 23 Apr 2026 19:56:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 2/7] mm/memory_hotplug: Fix incorrect altmap passing in error path
Date: Fri, 24 Apr 2026 10:55:42 +0800
Message-Id: <20260424025547.3806072-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC5614000E
X-Stat-Signature: yrq5ghpt75higp7afc7mm5xxn5frje76
X-Rspam-User: 
X-HE-Tag: 1776999367-999719
X-HE-Meta: U2FsdGVkX1/deqFsJ9D18YgPv3TwzdzYNLgZbxBnEtrmdXzuK//Cez2ehQP000wIaeM6ajUQlNNyTSmT95cjSsQDvlwMA36oPK4Buv39IMVSiDRCJ3xEjrY5PmvZ1MVNrfqPaONXtf+eYVcpMocGRGf16+DoCyw52SyGXYMCyXWNU4wnFU9uEnZLosHyktVCkeQactQy33nXwT48hZA6Lul8+AaDKt6MdFD81fQkh2LVkMxxjrpLAQYei7NixHQ1ZYdL1W6Ty04fpn2cBJQ+xK1Fkq3Zd5kcL+RnNSRd+UUhIL5maIzBhluNu6BJUj7itT96m9UgrO4chjj0AZMutTAfn7OkclAqWoJneCvYlqkcqtd1RdkuM6dMZrVS/zCZ3DfaJWYQ8Oh8ZxAAug6QltM6qVq9a2p7oAnHHX4xTJxq/+SIDXRRKWg6Lljx7Mh1IkzQ4P1ALwtcjn8GGZ1fSCj1habKiXLT9vS3hVlAGmRcC7Y22DOrHW/P/ZhvX3zZQ3Lecxyuz5wFgcuL9StsrBI2b8r/DktkSnL5aPqxf93lGrYIXVX76p5ILdwPplNktGV6S+XQwEU3BU7/WP5G5y9Yfir2KLpJmK6fX8DBIFkMi0f5MiTZ1X+c5YVUsRQh8pY65wtkcpgP3n6yyjqw8RHrYJPDcpKMTc1wZ9DvjtKVfPEIBj/bFiQRmzUXJ8U9g+FETsklnMeyNrS4cl07ejFqQjtQa/N6D1dbahlx1aH/zXuspRz1pvRmxIcZmRp4Z/9WicMK/Y8OMCtE5jzTEfv7SPtcwHU2Y1CYzgGKirUCPr0iXpHAoFoJYuE924wGI3AlpPxUPugowgxg4JXdteX2p9pE+0jCdo1CF93R8o3F3FnVP40K8znKKPyfPV0bWByNyTsMZDreSUVzGerAB+JNlZGBTT+qO+JOjs47ji3af9giLg8vzh682RWMyz573HF7IYohvMl+BpnUORx
 jmI08415
 HRn8wNbVEHuDBNxJYzPzAqeH94oZIQJLR74zpCrWMAjZoaeIEGfhez/0higEdDDN7gNfvS+S0unx8o1uAnjWdPrndWy5D2WBGkIeBhsmx3gMSr2Fn9K/IoQt6KtNi+cnchVN/iPbRnz8fH4pOKvXbt5plSi0Vo+7AwMlklAnCqW9pLUf6Y3XsluJii1aNHOVHp7WGGZFg31qD660gOHEOAbVgTfzDDiJoup0Gcsia3py0493QmaptuoISepIG/9l0JL6oVlZSsbyw2edF+pgI35h2lcdg4LVH/M4DKaFLhbIJq0n4VcOhhnrUur2YXv51wIZi4M71iSBO7My3d4TZbBfm/m8x+4xkqs8toUBomKbyTqZOgCvBl5u8MYGc/3joYJDh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap. If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption. Since altmap is
NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
system buddy allocator via free_pages() instead of the altmap.
arch_remove_memory() then immediately destroys the physical linear
mapping for this memory. This injects unowned pages into the buddy
allocator, causing machine checks or memory corruption if the system
later attempts to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..0bad2aed2bde 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
-- 
2.20.1


