Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0335BCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5DF6B010B; Wed, 13 May 2026 09:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D276B010D; Wed, 13 May 2026 09:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593286B010E; Wed, 13 May 2026 09:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 463256B010B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1375B1C0058
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:23 +0000 (UTC)
X-FDA: 84762460566.22.C66AE8F
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44CC740011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LIi85t9o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiUCqo7mN96xuEU3BEXI0sREbdNGZzXWZJQTkejfapo=;
	b=c5y1eZOKwd2HwDDj/9VbSoC9UhZNbxrZ6U9CFqmsGTnk99FDFOgr8Y/102savp2zhdkONL
	iuMQ1cAwDEdKDgm3GdNGfjQY9wNfkyFFxlTaujsZ1+vZW41lPbjNvyJ764B4ID0DHWJkr3
	NzKkaeGGyJ9A03jiIgBrLYGwrBaef+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678541; a=rsa-sha256;
	cv=none;
	b=wWPSbYicqaDf8UWNTEY7yOfIM6MTS7Es4MK4I+fZp2f23Q+notDihO+KPYzUHdjoa8D2Mp
	Vvl9EQM1nvcF/KgBz9SrTq4JwsOV6KDCEiRqUpvss1/LNZSi1zLYd/KA1GrYA56CpVLQsK
	JSHHSNVEk4T5rZva6ed4lSxoxkVWiE4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LIi85t9o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-367cbac9c37so3156300a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678540; x=1779283340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CiUCqo7mN96xuEU3BEXI0sREbdNGZzXWZJQTkejfapo=;
        b=LIi85t9o8/ZgUrCMjfgfdbsCR+3rBLANUpNzNN7C5t6DBZ3VzyewcN8236MDEUy9fU
         IeUnpXIbGCbi8JQIR91WZslQYbs+d3wDXMJP/ffknqIOuu7KfSlnBtVgGzl1lbjeq7R3
         Vxdh4+DxEC3GxIODthk9tZzxh2+QWWIQl20Nz5C3byc7qsgNnx6qgOtBETpSDpJBDgc4
         1bygMjAeNiJr8knusquAi6pXCF9bRK0tTPr9shGENt7cUfuaUyxP8Rxwaq7I9ejo4yV4
         f0wpIkx7dx0RAL8sOqA4lShANqNk02ZVVHJZK9bM2vogJxVfWxe/dZy8jail3W760wss
         N5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678540; x=1779283340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CiUCqo7mN96xuEU3BEXI0sREbdNGZzXWZJQTkejfapo=;
        b=AAJIy2bkL42m2RFRE6Oi0ViifOauXS9B9v+oZBixRNq2RXcthI9pMh8ZbnaPFxB/5m
         gZmrtxfy/sETSO/oo/xXMzBv8hUfCthQLBLWasJudChUbsok7MYaQQIOMtERkwBalyea
         WdyvPJu3IUSnfxtyitlocwzt4I+SzKt1kNvJGaDUh6K1HmQStFK/xGZCBS9Zb66YbsJw
         fHDTdMhfJxdPXNi+jo1FJq7WSfkROMFiXE4bpnXI2qHMUm6gcM1AFlIetsu2XaitVuGX
         AjeDpMDQzuYm5C9O10+j1ktnsLU/1Ruzwqy42IyXeWHMvhigUsqEKimi7zY4ZCzGeTJy
         Ziiw==
X-Forwarded-Encrypted: i=1; AFNElJ/ivbcokSLA6PpFtPMR8WUdCTk4+rm6QP+wVYjMCE8NtVd6EpNzGIL74udfI4jPDAKXXXMZyOuy7Q==@kvack.org
X-Gm-Message-State: AOJu0YzyYzCGRz2XJtFWVd5cX4mojTUmdmeEJizThjuJhcYnqmDf9EJa
	YMTkFw7A7FRbr8yYqZfguevej3stxA92EzYDCuN4dKZbbx0Aw/e9H/BOt+4+7eLt/eA=
X-Gm-Gg: Acq92OGcrGZDa5JHDFNkyaO20H6qLJkfo8Q/8skeSXsJyw/2e1ysZN84VgxnGwbHX3O
	N+X7C+wZYLDVAFyTvGxmfD+rb3Ab7YHPKhmTEjFRL6kExvXHJh0x/NrABjFQHLjv6FGH4/F14Y4
	sf6wK/WCmOfuLdw3vPUT7ofk07GCnNl09xDyiHOhvlC9l6b4L6z/vOMXx/KyxIx2B7i+2OkXYUK
	07gfM3qYjsgGUqvhebTUt6jsa5wq7TYZNYS59tXShhKlCdD1hV6AEBUp0fNykLyfSJDHHrz91ub
	CMxz57UVd3iXPDSVJHmgOyDQ6QVXJA3FNiABpxwyCrQg0yfpCJLE0+A9HQ2XdcDoCwilvl1K/bD
	GK59ojbRVb8TZrv7rlhvEpdAS0ulP9/0NSyF4mcuPkCVaLQiIXnOuIlaI4U13Ql5WSbGOQx88eP
	pYzRRBbACRl0KPuA8q9fqTdFsDKyfEQW222f7oWJE3gdHjSUVFodHOP2ug3yfw
X-Received: by 2002:a17:90b:4f92:b0:368:f179:ba07 with SMTP id 98e67ed59e1d1-368f3aa9f3cmr3656850a91.9.1778678540011;
        Wed, 13 May 2026 06:22:20 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:19 -0700 (PDT)
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
Subject: [PATCH v2 60/69] mm/mm_init: Check zone consistency on optimized vmemmap sections
Date: Wed, 13 May 2026 21:20:25 +0800
Message-ID: <20260513132044.41690-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44CC740011
X-Stat-Signature: ab9g7wa6binwib9xrfjm9mwftxhtjuzy
X-Rspam-User: 
X-HE-Tag: 1778678541-732800
X-HE-Meta: U2FsdGVkX1/x6wwne4XjvcsIrwSWiIWw+69FSZzepc3hGX84Ei5Krg2/kLnhr3cDtrNy7JYO3w1w2mUlIXKALcd7oRPDqeGQ6KAty7RJv03z/gDo0T1NvJSD07H+t8XOnic7GnPDZkddRqG/o7AUvvFZsnbnZPI9zhYdfO6BVuT8P0mcMy6+4h/azTLf2kSDIqMMCpnLPClh21tclpXixmp2tZr+kS8maROZ6AM/1eLbXPWSycpEPWui5KP90WIxnJXJqZiPNKT1qVzRojesr3js+Ou9H7OovGggYn1C+BLiEaOqbSQULVmg5OTjJAOOxeXD9f3hWhKRvb1H+NwdXD0uhnqEU/I4hfS0njRpC2PuMgg2TNJf8929uXdMKAhvd1u9qyJU+WqtSCWPc+t49oOOV10pRgMel8cLpw0IK/PEL3/FONfHSPSCKgERRa4yF3K53RSHOEMyw9yrzoBglLMBGful4OIozXM3s1Epc6Uv59vtbQA8F3S+gKMzCmHRFSSD/t6vZuMhlRFuuiBmMCHwsWCQNhjw8kt2tYysBTqyvuU6RN6ZJaagjrj9w5yxy5Q1dPa/xjaZsKkvmIPXCt6n3iynrNwoWQHo2qqOH9Q/t8X+mlI9IqH9JaO9g0FuNSnnXUqmmyB/HZU+3rbEsYSQaUl0hjVaxpz1Tutiak9smApZMeuwyuE1ObOqfSnu+5CND8sC7wiS3RcGquDRGiG/1uHB1pAoW8BBUuKmcsuda4XxD0+oxXMp8JDM1L3uHX2bFk68PcSzSl3763W66NyCMTxy+aeiTww0kKbhKWctxshMkNgITHmWWTyzCDmmg4kRRALuaSuLZAvOXx0xukJdjl7ICa2XYMkcaVtrIiVrdJ06qLquWQQWFww7F4XeZ6+UWTTVPaiSAwugYpI/Xmh2plpv0SaosvjP3/Z0XJg1/roH0RhcPxIGEykUAzY8c7VP49b7rln8Kz1yVf5
 gdxVWwyT
 Xa+/M5Kj7XPkeq1lsukRujwHRGZCijk+0jEjTz/62HN68U2f/zOq2zjT9kEkH5R9pUnld6il46oBtXNbtnJRTyETmi4IOTl2YjLb8mpw9+Bbp4VSs4iu/YCJSn4DCSYgMFjXfFnuukOmlGhCad43vniMemiE7Jm34YNThXKqj6fsQTSotMarDMUbGyfF1/2dPejg51WzXdHTb2fZ/KuKR2Fwk0tWigEBN02lRPDl7LstPgVynR5yY92f6oAIN3d+dMPHp8J1wVWYm6zKSscZxRsONvSxUjBFoP3JGE6E7rHwD3dWsbNvke1eWDiD57RXz6Bcd1Yc1r6KOvNzjinPxuQYJ9MhppSJgn6kUS5eAULE/Kms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmemmap-optimized sections, the shared tail struct pages are reused
across compound pages and should already carry the expected zone and
node.

Warn in __init_single_page() if such a shared tail page is seen with a
different zone or node, which would indicate inconsistent initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4ea39392993b..95422e92ede8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -605,6 +605,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	VM_WARN_ON_ONCE(order_vmemmap_optimizable(pfn_to_section_order(pfn)) &&
+			page_zone_id(page + OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
 }
 
 #ifdef CONFIG_NUMA
-- 
2.54.0


