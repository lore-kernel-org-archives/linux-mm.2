Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66E2EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230046B00C0; Sun,  5 Apr 2026 08:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200F56B00C2; Sun,  5 Apr 2026 08:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E196B00C3; Sun,  5 Apr 2026 08:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06A9D6B00C0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C39F11B8F3E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:03 +0000 (UTC)
X-FDA: 84624499806.05.BEF6489
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id E3B6540014
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AYgnkRAv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mltk+8iYdxXiKYafIwHZmXXZQXNazh8dOc5/PN4fBuo=;
	b=icAmc+YDgyw/ICfeO/1vOlTMhqoywd964grQMP+Bke7mUKBJpPXepngtDVF3feykfutbO7
	UClKo4msuRPkVAcEJ0c5Z2V5cZF+wcIenXwdDlHly1jSoCczqx+Ay6RlBdCRWkb59exg9v
	pcdcPaUKpEvwywE8ZKJhm+Fz9MVx1oU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393762; a=rsa-sha256;
	cv=none;
	b=pYk5OgpGulvounP/HBl/UMbeHZxA5J3wii50oCw36QAQJrvgtLL/087hRmVHkYuzvoYJFK
	EwxFBVbJeMSML3cioMH7igzapzi/QZQJiZmJXbu4UKoLy5pZmOE3+w64VhNQVxGERdfMxB
	aTZ3Urs90gB4m/7iGIsO3ACL7RmVR4U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AYgnkRAv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35d932cc948so1713440a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393761; x=1775998561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mltk+8iYdxXiKYafIwHZmXXZQXNazh8dOc5/PN4fBuo=;
        b=AYgnkRAvQUuA8AxOXzJqwkkTaaIoCKF5LpIXewPxvgUuY7sw96DXZRjEapMxgc5otQ
         9tbElWdy6LyRr81lAnuivfzmSrMtBwe7GX5gdeAU2WMIUO+cIOZe99lhsnklt7BBimRE
         yA+NEx2q5ESwRpyTIWfKHredENYVLGCPjxPUD8utIYjt2222Vz6SlykPaq+ScH8LNlRU
         OlNstzSLqgymWh1fHwHIqPNN+xmmZXlC2At3Xei40vXpciSxKS4tB28VAdQBHK9tI8lt
         y9aW40sIaqvJercfFNacCwLixeX4y4A44kGGaN6elUKtIDEOx7iQXsM+r+Onh/X23/oO
         3Euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393761; x=1775998561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mltk+8iYdxXiKYafIwHZmXXZQXNazh8dOc5/PN4fBuo=;
        b=pisZ/iqOFMOF4tLLihiyRNHwL7j1AR8WzLegff4c6xwuvx/odghVM3vZE47gcGjxdh
         hy5oAK2HIGTc8MdzqvF2FIu7u0IPpALyiW8DJvHtUk4t7nPzGSONMbQ9wROezDzKFDRs
         9VpTFRzfziGg8y+28XZ/afDK/iM5Y4vkVAaXHqItx5p8cWo9P9KgKcyhEvB421rVmKu+
         c9bfpGma3ioezC5a1Ldk4HpA4Y3vZbjrE8AvfQHxOLIeA0MDetSkNKeNI7yKfsXM/Gs0
         kT9GhnLKHltLjORCLxq95weqj3hUk5suNzS2nM7hsx6SZu2IHgm4a81wEUWLLGwD+dPB
         j++Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAzRzc10lDkmwFiFL0XxNTwYaTOJhbFK9Ey4yFP35HVC6GgjfQ+ZaelBc890AschvOZZ9OE7NX0Q==@kvack.org
X-Gm-Message-State: AOJu0Yyjhh1HVeWe4iCIFkuuNZhLMrXiaHYADJa8ABoq87OLGaodtGpO
	CeGcom3RvZctLiVbj1hcGqa/Jo1hxFC55OqU14CIhaNhjET8dRCb2gjTuSNtNkg8Kz0=
X-Gm-Gg: AeBDiesdOp+TzPLfBItMNpT9t6YhoIIPBphY+q+ZeolStnCCZeWItUbdxTW7aZnieKZ
	fqPz0ffwdeNLCl9yEh0zzVIGo+rACiVSuNr0tA78Xykl5I/uEz6BxJigaq21rC0/OtZVhI9UTQM
	wId1R0x34lHKAyKbKMfnz75nO3KR3cTA7erqxlx22tUYgbLXA2mCtq02mJGXVQBPVTSp71XoIOj
	0R1NPGVRgwEqQCvDI7/E9Kx6TOUUqURMBLS8DpT0TiCBu2Tdmk2aybwu0+xVBAHAGitmb/Xym/0
	H5bRxy7nfzyN6ECFDkaN+khbrxi1+2XvZLxOgmOy3Du/Z1iAVHR6s+tG4Qv7cvl0kzIV8HlbVG7
	gVtOKcN4S044hT3+wfAu/tJRa511R6f/0u2WsUUEGSMWyjDbgh9B5AN2kFSziPm3QilCXmBxybH
	lUL86nU8nBs/YXEC2o5KGF9NWI4dku4P8cVRG6yNg2CNNBLU4uk8qX3g==
X-Received: by 2002:a17:90b:4986:b0:359:855f:ff96 with SMTP id 98e67ed59e1d1-35de6942cf7mr8878256a91.17.1775393760754;
        Sun, 05 Apr 2026 05:56:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:00 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 24/49] mm/sparse-vmemmap: initialize shared tail vmemmap page upon allocation
Date: Sun,  5 Apr 2026 20:52:15 +0800
Message-Id: <20260405125240.2558577-25-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3B6540014
X-Stat-Signature: 7jcsdeub83is8m7pbtq35cyscxgtcz93
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775393761-339297
X-HE-Meta: U2FsdGVkX19RTVrQOxbGYhTmK5W50FhepipdNINvWwKKfGPd1coIW87QIhHTkXiKi9SCZIAiu0y2S34pldCiCuX+wBo6Id3xe0bMc59gATvYP6cbUpfPqLkz7F0Bkvd2lLwruJ+d8szOxhUg9LRLGvYiv0xl1OobDNxkYeUYefzDfACDHhmPzxNfZzqkhSseAyIzEvK7W/D8fKUp7SIIUVY26bT9p6W1HMsXajYpP/5vjEgAec9vlsPDnOwNpzl6Lopz+V3fGl/EWQ11MTsjrRI5zmBz7JtvcUz3DEh8QfumT6M1Em4NosNQm6nwH+vVblufIDieDKdNp8KHtO/hZ1TDulq9mAwVdkQpXLwUdWD6lc/XDyIBGkGNVleZFGgaGPX1Ox1v6Szdr+EgTSVkxIaHtFXvXKVRbocSZcEbbz6v2/WsA98vnfa99SPEaAFl8IZ/L4Z9QfV5zIQgH2gADZA3YjyqJxyM7EABj0WV6wZwqzMcpyp7BcoTDuJJF1mJVc5kohxPzttQjBc/IhSGtZidggnVKtonELUvgPfaJ0GCmsnrhDonDN2No0ycdaGF6ueEnmJpaUrES7S7J4qsmiy6tQG3JoQfZh7EIy54oWKudtG0GSMGSrGn6EDbXzGMcTaMMQ79OPic6g+vg4oNeqN3ZU/6DbenynH9KORStwL+GM8ehDYLlXZkuvmMypDy2bqu+VsBDAlk4It7d8oMuu70GeL63s+ClWIWrnZJgH+0AWUlPP6H44Z4roxO8UMvB1WdhI4bJWwQdQ7oI3o4cd0O7m6hXxv3NFRawKWyR61w+rgkLDNFyvQ6kee1aFs44IPQY1RqKXjcw4uIL3KNGfwHaJsIXb2s6UgOCG6A1nj1WkV2AoTW+sMAZeTF7InRt3YZP3+izyL27TDQrMS8g8ebP34GlUl0s49EtMYsTcSjP97RWum56ah8AV1MupgIR8b6lIIk5oi0iFDba+F
 jOewWKQ+
 pFBlsad1PDcktFLFxj8PCm+IhYIHeMHx/mHs0s4ktLHFTzL0RYus71Fs+JAqJWv8sB5dNwgQfkDcxET67pesLiffmPPGyNytusTInEQyTA3nqihBnKPW7d7Y4C9T4OzGDAMre4Q+l6BcI4ag3PnqqSVEikx1GSRmCzgweMkLuAZqBZryUwN6my3xRas7R6xN+DRZE+e9HTtyNPgWjcJiSjnUI2rgZWma8Zx+wq2NiowspoWT2wwXkqeZTsRmjYpmVedDxtqBQrbG+ThctnOxo/we26fOHedaj/wddttnY1H5b5Gh+s11TI6ircOvmm6juDDx7fQdQFpdkyPNYHqxs2/eoHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, the shared vmemmap tail page allocated in vmemmap_get_tail()
was intentionally left uninitialized. This was because the subsequent
memmap_init_range() would unconditionally overwrite any initialization done
here, forcing subsystems (like HugeTLB) to compensate and perform the
initialization later in their own specific routines (e.g., hugetlb_vmemmap_init()).

Thanks to the previous patch, memmap_init_range() is now aware of the
section's compound page order and safely skips the redundant initialization
for these optimizable compound vmemmap pages.

Because the overwrite issue is resolved, we can now fully initialize the
shared tail pages (via init_compound_tail()) immediately upon allocation
in vmemmap_get_tail(). This simplifies the initialization flow and removes
the need to defer this work to specific subsystems.

Note that the initialization logic in hugetlb_vmemmap_init() is not removed
yet. It will be completely removed once HugeTLB switches to the new memory
section compound page order mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9f70559df4e8..2a6c3c82f9f5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -340,18 +340,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	if (tail)
 		return tail;
 
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
-	 * memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.20.1


