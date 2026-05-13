Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B3CCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04EFE6B00A3; Wed, 13 May 2026 09:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41AF6B00A5; Wed, 13 May 2026 09:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E309A6B00A6; Wed, 13 May 2026 09:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0F4A6B00A3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0596A082A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:25 +0000 (UTC)
X-FDA: 84762425370.30.A82FB19
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id A39D4C000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hPVk44Gx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agVhcKOFJ9pAjcqZLpJ0s/37gKQkV6Sy+5Xwv4eBZ3I=;
	b=KCO8+kMSKTpwEvuDr/HuIZvOLWTuVCxdXrfmogR1RxXJtDtn0BklIZwUeL0UhTRo6AmzPE
	weYyrlOQ9G63EhvwqztIpvsshP+gTul81Wyr/rpel6xlnL+lWtHpI0nqACWwB+TkXcw4D4
	oUfx5rf5Z6sMR+yEJcmLP8D7mLrQ9/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677703; a=rsa-sha256;
	cv=none;
	b=fj8YarNOtzOYATBrTICjkHxFU45OeWgd1oHG6yWF+kLDfbqM8pXpvCuDS1p8khXjUnSIF9
	E0Q7UNcDMsLessHahYrxeOmWrk9aNWEq/yi6dOMScCDADP7VfGqc7CBTC8kB5DYiQmsrl4
	642bEwpJvXwN/Vnw46tSf8+DQbQb6R0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hPVk44Gx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ba1e9d3687so44363505ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677702; x=1779282502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agVhcKOFJ9pAjcqZLpJ0s/37gKQkV6Sy+5Xwv4eBZ3I=;
        b=hPVk44GxFSaIZGnOLNE1TXFtQQR7PoBEriA9XEa9ixjcmXLjgsT5FKU5fwDSZD+ikV
         sZ6fFBZBMw3JKf7CyHlVYQSN2jV5A97KMMy+zhBwtNTcS2IZTyVQ/YgjM4M9dxOR85s6
         rVlQOjfBLoHDX0ZJmIv1r94XjrO8tfBP9UQKqHxCJJCaenw+J4w8Nmke7MdIZUw67RGC
         6/EufcX3fh9KHQjQyhC16FccGdrPZ62YvFdoDTk6TwYWnQIOSmMx0lonOK4aRk1YNJbE
         vKxwVghlJrRdltoMPqbkapIdeF0s6iL98ISzqoWJ5rl9vECz1CCePBw+VeOKZweTAYyK
         kBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677702; x=1779282502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agVhcKOFJ9pAjcqZLpJ0s/37gKQkV6Sy+5Xwv4eBZ3I=;
        b=eZYYQiCgeQ3HCjNwRVU10L4AGUnTOaI5jd+52pidM7Wb0BR9S9QRWEJbBoSElId0Aq
         noOamz8UPM7pjGBguwqgIxpacO/YORpWckYflV+LBdz8SXWtCkLMHhA7LR68pKubPeH7
         2NKXde1JDVr6PKuXHyvpSwpuOamFfXUyHsefPo4WxB+GV8rYwF/AyS1NTDhElOseFgpg
         cH8c2a1Yw1tS7Xit54kA2MywYlWmzKVXvE/i8VXEga2sSs+Ismwtkuv4D1ZPS03TGi+w
         zaEP2n6MJc0VIeJjYdT2tJk6S/1/FXMo2jH3BHUnQqLdZQJS/yOvFaX4wcoEfgG60Usb
         85Dw==
X-Forwarded-Encrypted: i=1; AFNElJ8dzbxSZHGNhzL2pV1vKruSj43r8n8qOOu2ptCPxVPHeGBxNCZg/Iv0EG6l7uYNK3c8zWE6A8gS1A==@kvack.org
X-Gm-Message-State: AOJu0YzwITz9pJaR8XrrHOj/K7CCArivEsyV1BIfKz1yEk1nEzyIS7qi
	Tys+fY+gjN9Y0lwI4V+tHKj7/L3TT8JyVI7VXXe49gHi76U52iAc1oH9xnAyI6pAmpM=
X-Gm-Gg: Acq92OFWAIWdB0rWTOfBPthbGqzpAYbXdmDT8u4kiplSU0UiEjZidLJw8td7sVmjx7M
	kYcxx0DbKblU/5p3MKGLxDr6yvB41eh+whWD6Bdj+R7ahrTw5LUAl9aVLQ6eOQPGQTGlUjre3K+
	BZ+G3sl14Fd0eHBvp9h4H0iyFuXP+Mi86XmaT1X2spw6L6OwZGrXsNAxOP9bJzaBRlfkwwIhLaB
	fXXPYXQRmU0dbHcKMwU7CGFfLtM1mqDyujNgoh3k9MV7R0viLPoQmPedaC+ee0VjiRChpSsMpzp
	nBsnZk0xYnpZp03I1tXipchsCQQ+WJfH5gnZO2e79Dt2VixtnVopuRFSrB8xvuJ4OpN8MGv+AkP
	dtHGmzAWhUVvzPHv23Uy5z8BtSIgHZZw4r1QQOz7dWOvL5chIqJPprOlnrMjmSfAXbdi7kdaYFV
	k0R8LEQ+is9PG+m8j4pOl4P0CNJfnd6Zlswqh77AF2ZOVW8+UNSAt70qF8Xdk=
X-Received: by 2002:a17:903:120f:b0:2b2:eaec:c810 with SMTP id d9443c01a7336-2bd2f4f76c1mr29145735ad.8.1778677702439;
        Wed, 13 May 2026 06:08:22 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:22 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 09/69] mm/mm_init: Defer hugetlb reservation until after zone initialization
Date: Wed, 13 May 2026 21:04:37 +0800
Message-ID: <20260513130542.35604-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A39D4C000F
X-Stat-Signature: 145wg76mbwg3jfddgguhqnqdsiyn6hrj
X-Rspam-User: 
X-HE-Tag: 1778677703-409238
X-HE-Meta: U2FsdGVkX1/9fhQshICylqYwtEk2ATJhr2t3+YQg0P1OnkjtshKNDxb7Z6XIkC/UOJsbENpbcdljua6bQ+VEAyLiLwVMBzXEM3iIka8Nw/ldGAJGehEsQaZwVfM/DY938YZNyTsGtKgFzRjfxD7VerQkMIW772/fovKKmLUi/gLtM6OmySizzu0k0epv0Urr9n4jIwWy5LFv2YYtuZoxnC2z70BI+ZV3havmqOwge8Oj7t2QT5hH08gg1SsFOyBKYNAG5Ald/Vf8p8P8FvKdjbpmwEwluzBZXqQjGVaxhXIabaYuykBmNnP34ABZrVgcxkYExPXsrvU9W0U8EFQXVOPzFIRpcttYTlefRcIqrr851NS0M3Hq6sV9CnrUYJS+z8qVOL60o5goPm1nYhDbkbI2eLG3kBuXLhtQcmzUm4T1gIQBAFQ1vNnPPQSKY2BYeJ2QhhzWMxiiQxXXrtz3sdEhHLhC38PckYT0LeP38KO9/dqsJIuvuSUzcw1miYvSwwR3xbMBcg+q5RGoXOsdLOYJttNZcsyaCGEhGUzaWLQTEN0O73awxm0QU8V/i6s4oNYRYlYIGieTXITVrFm/En2l0/lQo0UduJXGETUiZ1A6qN8jQUDscXwsoXKCbbs3U/a3z2IeQq7FOIfVpVlxwxoaCZxuRKoWh49THth4CkfDfQqjPI1I5j6vkPz1bgjTqbmsSm6V+V6nnEIZqF6kRB/pj+/iLb9cFWxkGkhcTuTzTsYTpS4FfFZ3NiiyNpxr1b/95NHGQGM8iaCk58qKnOdPgAZ11pZFZpiENYjBBGlOSTTPv/gg21/ikCuHeD7ja9m3LX38+bgcR6bu6aO5OJYl8uxppUemyfZZUqUc9UPz/stI96Go/in99JmGUWHSF/2HEGEYPa83M9XBaLJvhEqrvbRQO6b53dSAEDF/3n1s/BDsFw4SYPuGM0fb1jYmO8xmUvJxTWrNXOQdTYb
 B3DAo5or
 xFxhxpIfxvFjyneuN1KPML59gWH65RoFaZle2LvwlFKtiuiSTEflPvk2SkG3JkI9wBrENekhqdCBe/W+dv+JAWb9b2kazF5FAJRwRdGobEhg5U+b4nT/XoUtWSJyIdnFT/pRgbGmvX2EKQSu9m3wUo32sMMOuyDkJHCq75NXtYDRyu0yoWsr/nUiAW0F7PP09r4FffpUZnIbo4/eM0naoRJ1ckokSSyAhvyiRTP3VhaaMtPbfrfo4qN1U3wxGgGfcsAXKO7IIvI3UWFmSJBx70uHZEK4Ea12cAZfeDJfTD8PvPjzcdYKExJK6nJzrbrL0IHHwdjQFjSBh+XaFgEZ19Avfj3ymqQ6TdG0tkR1sPcucT9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
free_area_init(), so HugeTLB reservation happens before zone state is
initialized.

Move the reservation step after free_area_init() so the relevant zone
information is available before HugeTLB reserves memory. This is needed
for later hugetlb changes that validate boot-time HugeTLB reservations
against zone boundaries.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index c14491c2dad3..75f98abfed97 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2688,11 +2688,11 @@ void __init mm_core_init_early(void)
 {
 	int nid;
 
+	free_area_init();
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-	free_area_init();
-
 	sparse_init();
 	for_each_node_state(nid, N_MEMORY)
 		sparse_vmemmap_init_nid_late(nid);
-- 
2.54.0


