Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE54D606B433
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Chb/9YSK
Received: by kanga.kvack.org (Postfix)
	id 47BB56B05BA; Sat, 14 Nov 2026 02:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405BC6B05BB; Sat, 14 Nov 2026 02:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6BF6B05BC; Sat, 14 Nov 2026 02:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34EB6B05BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8401EA7CF3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:21 +0000 (UTC)
X-FDA: 85432851042.28.DF14754
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id C97CB140002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Chb/9YSK";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKsqfMs+Khz2jHdLUAmVstaMz+t2qjUPbSjoMCe8lqE=;
	b=lqEkOia19Zng3SixstkBmjmZqt9jjMQKvOriMZ+NL1RMkX/scctc0wmC6PWFHS49Yj1Inb
	zLLjqqac7jo5xNfloS6viNbH6/0NltpqifeVop22pXEz9Cvnr9x8JOzmtW5br7DA+ZyREm
	4+07t8xwZKlbXT2MLywTLuHEAK7D5AA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Chb/9YSK";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640219;
	b=UZA4KItoh+XBVDkqw8n5Iu/emTXvBokZ/uc+moX9w4rc8Rw2093vwN9UPRaw8LzXuG9+mT
	B/+iYWpuvTO085miWWlAfWFP/iK++LBsw3L4MHqRh55KPyGr11hWtLOtiqxrLa/j90394A
	2q4dtgEzd3+sW81iko9m1SwZn0OSNVg=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91eb53957cbso45071396d6.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640219; x=1795245019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KKsqfMs+Khz2jHdLUAmVstaMz+t2qjUPbSjoMCe8lqE=;
        b=Chb/9YSKaRxfa/2Bg9ivZbrybFKwoSdI5XE/dVG8BLowWmMwAioeGvYaf8fqLriG6q
         p0B7lu0jf10vjB0IRqU+g6rNzdL7mMgMCldALSr/3onEtSJvXRWKbthgj2CpANT8XYE7
         YQ6vKwqZIdSyPi2bUTALrxQz/sT/7UckiBi8T6fM0H3PbZPpJNEeSJpO6ilKtOZ9tdJl
         OX1XSUqSKutV0ri6zealtJWncCI9BIgiqXx+1DVmA6NWF1MsXKwZsVJNGgTn5Xles6+/
         Hy473DeGMlfRRmZ7rTachPqWw+V1cL2sNxZeBrhK7dEB9LlUWzeZ/msfKItRMxFVMfMK
         jeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640219; x=1795245019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KKsqfMs+Khz2jHdLUAmVstaMz+t2qjUPbSjoMCe8lqE=;
        b=wHD1I4ITmV7u7ngK7ytX11+ssCyBULdXerjRQShxSO9L2NMuGsR8YAVBOsTzT39Mo+
         SKNGXh5noyO4NmNPyH23Lu4tXCSnmMXQAQZMhvcdO9aIl9wg9dzmCOEve/kAlYAPhu0b
         rC7UBxBwiBXWqb/KQqG9exh1UQTM2gkF8k74H+go+cD+t80qEg4bGboy+cyHNVZyvAc5
         l9FfpeZmdvt5LFpJmA4dr45c0lzcHT9wDwqM4eR2LwRkbILAKXGCtKKbQOLPhzpp49lH
         yCmOGGQSBww8qlniveXJfD+gXd519P0QPAxZ/xXyNalhtU88X9dvaUxYgy4/5YwL18pl
         gzaw==
X-Gm-Message-State: APuU4Z8T3taynwgIhzkorD5PDw+l7ie5S2RpByMQva42iUkKrgkI3IHL
	VbjSWJ82a+nUqyzsczVXuM0GsPxKdmZNPLm8jz1BUKbyQTqNgxdfqP0E/mLWrrVea3IWkYrlArd
	IH7h3
X-Gm-Gg: AYBFou0kQ0oBRMSjoAJOSesZGrHzPYOsOD745XHeS7EoOl3/fXJadElO+IstBp4f7fc
	e+ZaEXOLFghDLcuR1qCIO5aZhz13ShN5VV1cgA25/+FZGRIi7mTNgrwvbmN0UE868wiuyXnHyfF
	7u43v9roD+UginYSMNU+afwVeuRlcFR1qKLmQsQqHdEXiFyxXZwZ8nANbQWWGM0X03Z6NDxCf0F
	2cZ19p9cJbJmNWPDydZMG4VvYwuwAJB+RPjd19E6exlbSiwGjBcA2grmuJSRIJyWieYPkhOOsiB
	lw3EwoSqUH2NjIDQVJLdUw1wIfD7jYHzntSUYBu0GBKuQUKmTfHSP64iaCxDAiMt1OzpmqsQvLM
	py6zX8dBDbE0GiGnHSeB2TqeQaEmZQy6JGlYJP6kjdiOLbbIfM4zmAGzzHo9a7lVZ4sPQkCsvzB
	Pv6STp/+NrgtJTfQf3C29kmM18NPi03eg/PRZPAOJc/JaZK9Nmx/HZ8gZo/1y9V90IdbfNuQ4ld
	4hCr8zfoFxBuVC6N3HDknPV/DeSGfxAHkqb/3sEZZ6MOfa1x9QvTlFqrc/7/USL2OLj5bQLXvDm
	mOjqBcOm3TOWEvsrkEANTSN7s/V4f+1HnyTjTVAcVkDqYMF9Ty1WEy06YdMTGU7zukF3/JWzI55
	7KM87jBEq0Qs65y8=
X-Received: by 2002:ad4:5d68:0:b0:91e:a6e7:b445 with SMTP id 6a1803df08f44-91f241e127bmr84458226d6.9.1794640218986;
        Fri, 13 Nov 2026 23:10:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:18 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 07/22] mm/memory_hotplug: migrate offlined pages to common memory
Date: Sat, 14 Nov 2026 02:09:44 -0500
Message-ID: <20261114070959.3490008-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3x83drpp49wusn8aqpr3w4sk5aap8uya
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C97CB140002
X-HE-Tag: 1794640219-310232
X-HE-Meta: U2FsdGVkX1+qdvccDbKNjhNHQ+hMHY8Xj1i8iWKCv9RS6icUwxiyH4qRNdKRaplHl+XX5LDfQHb4p0l1nvcdOUOVMrsHM+DwkiqiYTT3FsPq5EA0yXF44e14EV6YYP6RqkJ2Xk3eqcXI1G3+YCSx6AEeEccyOcIAmr6abMLCppFT5fy/Snq8NtvZg09kTEAZ0HKBpKLwtrztM7JrZtFoJjPtBGlmwFXmsod5Ro/FNowGZqPKiZuc2UxPOTadwBPgxbarTWnKtqcZV7VpS15cFG5e8oWGtrZG0p+7ItSPVi5fk4zfFl9zVd2G2Yh8wtBueEJ7r6E5SRLCpDpquJ6ZzwgRd+HBLsoOggIN4EbW8BxXdfX9q5JO3oQHYAK4sGzw8NZE5FysRpR16bQAfRYQEWEcjIt3iyqMiNXcHHfu0JO1ewNML3VpClFNZDlJubKtiDJEQ5thGBk0vqjNoySLRu+2QBOSKLWiADV6MD0/lIxc4bVh39CZ/JboJkIZit6eLpzSaEIO5kL1o8AfogYvXAiSgJ8dtlTeHjL02Ocn2JQlpjKj9dM8Wjfmzuxs+AJHbvJ22MLjyIYGghGNBcyc9q/dhMqUbpVjw3nf2F02z5Q3bHwsGFum8G8nFPNZCNsaO8zz1ZlTTjQdsnNVy+tGSO5cVLbg/qWq2UFbOFwnHfO82FN8fAhwNo56ITWACvQ7hgFRfjvrc5Mj50hL03zLYXckmD5iK+9ZkHed07LlBbvJK2iKCZBVsxwR6dMZBIvL5HArU9XKVtEXL3Hp7YUoudqGbkuMLHZXVCiyQq90Agf66tEFUhnJrBjs2Jzb7vkdhOt+IS6KjbhseWNQ31eHn0matY63zHc3fin4Pc3RQHa1PJaCXZ/3f3WggLDfHrlhqc9mkoDIE9eE90DBGs6d5Tvqpn2xAlejdPYe+wxAhBm8ZBRHmQvZiDf1yXb2haLX2RWUMhr7mAykiXUKSUR
 fd/j1T+a
 zUCvMHmXkpOHuqWwbI+aofYmX3KC7zMgDyLZx0a5NkmarwXU61KT5x5PaqMb/5yqKvXUJ8Mr/9HCAwKK4Jp/mkA77e6HFAUpUqe7LPd+Jmq2w25Rvm7i6wHF5sCJhLubIOEr+Tc3iazZNuSBW1QecaXl41UulVJvxg7vTVUEkgnmpNlSPl++sl86rJnJQW7pOVRlUmrm87yeyuOquqriNVlpO3jfAs7mzhPZW8I/BjbBcmW4yQRlpybbNHd+26X4MDmljcR4fxDNB14hTi8R7xVTx4oERM0YzmBNzOyCtNiJAx5zxQrq+vPOAAbEdxgQfMKB4sGWmS6EZ9ZcPTZFjfqtRpAF1pwrnterpbS/UQcIRwMFsHrc6/fUh7PTffedSPZ7F+hgCeW9SQDcAw8f6nIzkcvhW+qcgZi3EiXP3V8Ie+/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_migrate_range() / alloc_migration_target() is only capable of
allocating memory on N_MEMORY_COMMON nodes. The destination nodemask
presently starts with N_MEMORY and removes the source-node.

In the current code, if the destination mask becomes empty, the source
node is restored to allow migration during partial offlining.

Consider this configuration:
  Node0 = N_MEMORY_COMMON
  Node1 = N_MEMORY, not N_MEMORY_COMMON

Node 1 keeps the destination mask non-empty, despite being unreachable.
This leaves migration with no usable destination because the source
node is not an eligible allocation target.

Restrict the hot-unplug migration target-list to N_MEMORY_COMMON so it
reflects the nodes the allocator can reach.

All memory is common at this point - behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 490f400498f14..29ff2c46499b3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1904,7 +1904,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
-		nodemask_t nmask = node_states[N_MEMORY];
+		nodemask_t nmask = node_states[N_MEMORY_COMMON];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
 			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
@@ -1919,9 +1919,9 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
-		 * try to allocate from a different node but reuse this node
-		 * if there are no other online nodes to be used (e.g. we are
-		 * offlining a part of the only existing node)
+		 * try to allocate from a different common node but reuse this
+		 * node if there are no other common nodes to be used (e.g. we
+		 * are offlining a part of the only common node)
 		 */
 		node_clear(mtc.nid, nmask);
 		if (nodes_empty(nmask))
-- 
2.53.1-Meta


