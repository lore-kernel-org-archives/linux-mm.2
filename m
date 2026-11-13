Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E481606A8AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=b4SoVV3s
Received: by kanga.kvack.org (Postfix)
	id 8A7F86B0672; Thu, 12 Nov 2026 22:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843C46B0674; Thu, 12 Nov 2026 22:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABD66B0675; Thu, 12 Nov 2026 22:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF236B0672
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEBDEC05FB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:06 +0000 (UTC)
X-FDA: 85428682332.30.DAF2114
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 15EDB180004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b4SoVV3s;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5KmM3hC9Uv4xFkTrmo3e4C5L84QRkHLCHW26evJoKs=;
	b=7e6upPgOYj7ve5vccwxPhP5Mkry2bbCOAzV/xSj8lKsBY2c5C8F2XgG1o30M2jnW5AsQqG
	mBHvGkmm747xEVS/6Ala5Xi9uaX4VrrknRMJSFnLZecBpWbELd6ha5il9Wm66oOuB9BCOq
	mAsP1BF2D7snCLK6WmMd4ZylHuNjm7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540965;
	b=l7z29BPVhD5wiIAivR/JRjWqBmnH5u4vMk9szOVAaRq77qz6zEvHvktciZ5potmoT84AWE
	2/eBb3kyd42J6dKNZNW6z1BXkXTZpVP9CP7R4SW88iLhcR+NNvnZQjlC3YLii3FyJIkwGA
	QIToJqGcm9gx2XslWnBF90To+9wsTC4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b4SoVV3s;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36dbde64409so855423eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540964; x=1795145764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r5KmM3hC9Uv4xFkTrmo3e4C5L84QRkHLCHW26evJoKs=;
        b=b4SoVV3s4xEZHStaE+vz7gNL2t3OavA5xWi60ZuHlWJbdv6dZl+sjZ//ELk9ck0kTY
         GNLutrhq+zR1vIuyTwQVoN5sY8lYgtX7NF+4a5m94wnkFV8WS8NDbuV9gtzhvY3g2ZzF
         vcie+k3NdZaSoIvbfZcqdnxkJvc2vPAvwQE3Lp3Wsuid9rgtbyEfaUj/KHTwlAA+N8pu
         P6vDLIijBqNZ9lQlEIuIdkBdPAbLqbBrPgbxY2kO8Q2sgZAE2qubeho36msZMlzP0bLR
         7mE27Fe+ZTGGxRdRcj3CNxe4KkYnVK2fWjDQe4Ti8yIk7u/pDQLmigHdfyx6DE32CA7h
         U4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540964; x=1795145764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r5KmM3hC9Uv4xFkTrmo3e4C5L84QRkHLCHW26evJoKs=;
        b=RoBEVKWbiTmwrTLMFdbU0Cl0fava8BPPXLuO23MaQjbvZCsr5R7ijQYWQsbMuWy8kq
         od4jm31yEngDvSt1OMu3BDo8DnNX0Sp0ZbDEgZXZYy9s5h4qRgZHoL6hty1pL8z7BYSv
         AHMeO2ewieYFdszjI5DaIQcPejeFqFZVesyOb46MQCLK7Z2o9lbEdf+BJDs64QGbZW+K
         eQ5gfTtsl0wWZravVPBXnGzlYFFAm+wvCCrRffqL0TO7UApf7rI7m2zm2L5IYeChtCrT
         fPFQ7lDqezOMeTxKZ2LsHNYIiqHqhYZVEakCoIr1MHubJhWIHibNqfAII23wt61Nj0fb
         ZBug==
X-Forwarded-Encrypted: i=1; AL+hErFWJIvonYgeDunM+hMtYMcqruBEvBYnf7RG6BmmjXql237uYNuEQaOPuEGNc7F5jhf6nnrw+8IZqg==@kvack.org
X-Gm-Message-State: APuU4Z+N66DUZm2nyMGd1C2dfM8n/V6Ux629HAYn2/uOFvuLndtcfEJw
	c6MjHmgtID3QDXZ8ZXNSyR3MqEwRi5ONDdfl0CbPBbXihlX375kGvKAxbYeuvdfukWhKWLX9/x8
	TuJ/C
X-Gm-Gg: AYBFou3Nc4vKTDyr+HOJlqyyv3exQXT26EuZ5JbiU2UUY2jxAPpQ89cUSUFEepd3A7b
	w8QqdRvFaweVmHQTuw/Br3UlCyl4ihqP9/13LJZpEU4GYeV56/YjxrU04Ga9VHn78RTcMaVtCif
	zpu/o9R6aKXXKhupUK9dSZJ7ykJP3k0NcI6ZbC5LDJL9Ddofjzzqhd/1eYIuWnGXWpyrhv46QmB
	6pUlO1woCM6BJ9pn6KRGpYReqWOCTVj35J8NezuzEDsQsOYD1TRHXQgqIFDqDh2OVN2hT9FgNkn
	cNBUTX2sO2SZ9S18LuIMajKOW7soFmq/QCBowGaFadbxgk4TDvXK7kg7A0XQ6FpeZAGE2AqeZIo
	wwbSo7aCpICcjUT+IFKRMKtjPG6eFlcie072wDwtEO2SRL0FpvQDi9plDtzrSv6BwqJlrcVHR99
	K/LhvAuDPqkVnSSIYRH6NFWfwXVBK8ZHyfsoycG0xiD16bCipKE1HmdSoUvmA+oiIPDondhDUAe
	lJvEx+13VLHpD2cozDrKaazkiWJvYNP3j2tZQn5A8rhvl78LcuOm9heM7qUCOsstSRnH/chqG+x
	Y0Ki30tx1aDSd0grdZHO5Rh6fA8fF9L6Uo2r/26pKiuxTvbf7ZtGrCqGdWw5XA==
X-Received: by 2002:a05:7301:182a:b0:377:d6e5:e64a with SMTP id 5a478bee46e88-37965f9bfdamr1034369eec.7.1794540963741;
        Thu, 12 Nov 2026 19:36:03 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:36:03 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 10/14] mm/mm_init: make __init_single_page() static
Date: Fri, 13 Nov 2026 11:34:38 +0800
Message-ID: <20261113033442.62970-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 75gwg41ek6phdhfo4yc5tzx7admsxp75
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15EDB180004
X-HE-Tag: 1794540964-846617
X-HE-Meta: U2FsdGVkX196gANFD6PatKKhpCmQ+XqCPBaIRRJsvwispcJr+kVMNZgg2opGu8cbHRFKvDhH4vY55ncWikHi5YSXGnfUvJkbhhFLp5Ry+Q7JQpcaDYDepnkUarml33J+TGlUHpoMju4viB9f+eo+epqPnGX4GubDliAlrgWLPg0QtMwrTj/RcqveenSILrEFgJZlC54MfgDB6o7FLkrLuZdLMI6TB286ZUwkFe4RovDbhpt5MgZYjQVbRV8nllaO0CR8/ArIGcoJHK274erdu7MEoTLlih5f3tvd8dpeH23zL/6TPEh1uh/EKxpcyXfRkjQ72E0Sj81dSPQDT65DA9cDhysberV2zcCuKBVEMTjnIaaZop100FrW3xA95EqxN8a5OFRwUjXo+g9TATFWhoYBgBbPuDLXnIgO5X1m0z3J1DGIHVSfU1equCvZH33ywwIOG/+qNQXgW5OAEcLQ+BeYqo76+zn5TFydcDt+z4m6pzhBYXOmB1DPFxkZcpspLkrFtMdfNhlprTjs/iGgouXDEcpOoOyslK59KYyUO/go4Rv7ZgUtAZEIjtPGI0+ZbHwmJqWB1wCEGi3lZmopSYx+L5YBck+8Stj6HRzUsSPVckCdk/ziwtj5+P2+4kwseqi/fvVmV0Z3p2+oZ+exY6sLOXDNf+MlsVQHqnACyzDFsiLxA7AshY98RAoKfaDEcCOzQ5LZubaw1pqKNi+DHF/nbEOOyb92MzU5BQUng5rEi1TvNdJsRmND1qjlBnjUsu/easT+JBBBJKMa1UW+Xe/Hm5ML4LaWLjf9pDoYp2raVrbEwlTGdbWgfRe0Hn8JfIoLgFCBcmHv+i7p9a4cqn5Vm4sVmfN4PSMyOyXJscAkRiKMJ8olkTTCgQlAPMuxQeCZy6w+BtKPX2Jff8ZJz0WwyumzdJtjSV53oYe0z03z33FZl7ci4WH7z15s1oLJWyjjtmeTlRgOzDs5FrN
 8MzlVeul
 +FK0DBsM7vMTvtAbd92bmHV/Ub0LH4+yqs/yrJk43C2ECGc76YNu/1CJtHZHmSnkeQdMbhm6sNnMhI+9PKvn+c4nJzTXxV9rF/zVtG5f8RxLTIh/82PrAGv/CB4KN63Q2UckRnlc3JsKXiebcUep6Gv1IF7TWX0b0vq6pwcNx36ernkCRg6C9qr3Imd5OMYIiz0PzugqM3qg3RBWMPXuM9ACytg30P2EjZXuivJ5PGoGX57vA0oNCKE7cOatxc1WZjQNQe/SH2O4jSbtdc2tzmHwVXoO1w7cmCssrKHMHwMAXGDF00QWTjbGUgtMa/jWfnILkuicaJxJ2p9bCIN4HVRGQz87gbC4PflLZm7jbsZpt7BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__init_single_page() is only used within mm/mm_init.c, so make it
static.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 +-
 mm/mm_init.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index ea9ff690d4e0..84de0870f78a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -618,7 +618,7 @@ void memmap_init_page_common(struct page *page, enum zone_type zone, int nid)
 #endif
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+static __meminit void __init_single_page(struct page *page, unsigned long pfn,
 		unsigned long zone, int nid)
 {
 	memmap_init_page_common(page, zone, nid);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 721221d2e4c0..c821aee774d3 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -110,8 +110,6 @@ bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
 void memmap_init_page_common(struct page *page, enum zone_type zone, int nid);
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
 void __meminit memmap_init_page_from_template(struct page *page,
 		unsigned long pfn, const struct zone *zone, struct page *template);
 void __meminit memmap_init_compound_page_frozen(struct page *head,
-- 
2.54.0


