Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D079606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=IozANp4K
Received: by kanga.kvack.org (Postfix)
	id 9D6616B0317; Mon, 19 Oct 2026 13:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9879E6B0319; Mon, 19 Oct 2026 13:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F8E6B0318; Mon, 19 Oct 2026 13:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0FC6B0316
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:24:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA987406AF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:24:00 +0000 (UTC)
X-FDA: 85340048640.05.E3982C4
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1602B10000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IozANp4K;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430639;
	b=g5dqZ2R/X71EKGDc22kcj220ZpnPSOyrGAXvNWnIoHRpkCPvk4NZJgvbPwLNXY1mYHtIxV
	JvcRstdLEf6TWqz6NUSmqzZ2MgLO7XWoe51Wwn572sfSGuAPCmme3dJvTYT0C2WwQOfTbZ
	1Nu6houJISWLjOgobX+7MR/3K7ymrnE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IozANp4K;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cayAcl4iw+jItAg5iPx/bsdxEdOf5W6Rz7FTZGlHvQ4=;
	b=M5AFdiERq5RD+v4mLzUoroLMltSbKyrH578qRtZBhExbOSKjwGw/K52kdYp3pfODOM09vZ
	WVHQIIxXytFXDLf50irJP1pdTsY534ofvtJHedqgyumY++pJmxuXHlqQmqIyJmmAa/+pW7
	TOEZqlWmtJwgghtL/GBbRnw5pgSwWLs=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535179e995bso25464711cf.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430638; x=1793035438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cayAcl4iw+jItAg5iPx/bsdxEdOf5W6Rz7FTZGlHvQ4=;
        b=IozANp4KywBbFzLTkwhe4ltHefizEK6QMw9CJv7EnPKcn4kNeoyeTUbt3SD8BrrvlG
         XYwJOf4fvVkkrS508dbksWEoHULGPgozndG1OZ3urJA4egxvsBs/pSWJzz0m4pXD/XoK
         o4IYPTWfEnAVHu3Z8fRB9q9OwWHpFNpCH768oXbUoBQfcGcZPPbe5rJ1Qaus6rG1SQL8
         r0hWD//GL0RuyN2yBuo9h5xg8CIlqIDAZL6hOS4ARIhABz4CX4DIVn7IwX/vvWAvGjCA
         zREAWn9nZ2Vt3SU4z4xTauLbv5e6uQsmSp4h+8mJ149NHoUjs69ofOXdN6jLop2J8lJZ
         v0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430638; x=1793035438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cayAcl4iw+jItAg5iPx/bsdxEdOf5W6Rz7FTZGlHvQ4=;
        b=16bWdStlO8UgVcjLOqOZaUsqU4GBATsU5ltNbNq4H4MISjHohFSMFjtueo77kRs5G7
         ZWRk0a4G3oNM1GUrDACl9Xg3XZo34QfuuLQ0ckDDaQSInNmBFsm/wK9eL6KEwly3UfmN
         lBUOJy2+ID7jv6Wd2LMTNmSbDv+vD0jrflkF+KEzgLrmDiR7qCPIvsf6196gL9dJaf1V
         ThnhKmuOqg4GNDKuQ+VXIcFAdbZq/sDOhzd8Cf6875db4OZlsSNF02VJ7WkKIjBDyvsA
         Ke5cxnijvT61LUhZJph7MLz+wV7QMxYY64axM7DC4nu8RNUyHIAZMIFy6AvRCn6jidoq
         JsdA==
X-Gm-Message-State: AFq9FYIp97Y/ReFk0YvCYPhWfEclqr3y560XbBd3YrJ9TadO0mDh0VGm
	nqjk6zJX1YJXsn/76bPlQjWFaqN8wqOYWc5vVmiSvN/FfKIfpvLnoAnrzZrXl0uIx8nEMA9F75j
	5Rh+EIDQ=
X-Gm-Gg: AYBFou0JDWhSwDH2xd6FbP4ZzHYPo/QjSAQtxTsMaIOBuZKZP1whGIHV4Yq2RC+TKQj
	jHH0pZgZSHsYfa7nmycoho8aTM9WGCx5Xy9F++ChCgw6W531cqz9VwJi8tgl9U+Kg0E7+GDgQ4G
	pRPa/imujcvDihs7gwpWH+uoj+M/0DqveduJPfLa4SjgG24rYD8aP7Ncqxn3/t0pXZVabaVNbOb
	jKR/UCsMGr6H8pKOOJBKVRnNJV8C/FOE8+0HCo7GOq0XQrlZHb3LJBz9rf/D+XDvc0ShovLtaGv
	4x0Ze5i9/+3jPgUn0+jeMu6wWpmC7rMgK7I1ihdcTWUNrNvqtWVxhaBnwoKaHHawvLChwlxtUKf
	5kxIsNA+tcvX14qbWkz7PXcijK1FFtAOHUnaL4+/maSezttgbZa+OmMJYR1cTRFUEGgNuyCmptB
	ost9UhmDVnkIxYEzbI1rF0rbyVOhQLF4t01eZQ7rTwM73MJl7/VsteDevH8eY4xMFJCjJ8mc2nj
	WZfgyltllaNP3IWLZ4V2VhiITwPtaF/Z6MkOYBfiS5APjp3RHamvLKUz8ml
X-Received: by 2002:a05:620a:3710:b0:93f:43a4:a479 with SMTP id af79cd13be357-93f43a4a615mr343361385a.66.1792430638159;
        Mon, 19 Oct 2026 10:23:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:57 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2 5/5] mm/mmzone: read each zoneref slot once when filtering by nodemask
Date: Mon, 19 Oct 2026 13:23:45 -0400
Message-ID: <20261019172346.3344005-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019172346.3344005-1-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1602B10000A
X-Stat-Signature: s1xsa94tfnrzxi61njjfrr6y15shaze8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792430638-92542
X-HE-Meta: U2FsdGVkX18ShIWvhMc3Jc6SswelkIhZpBZZowikEFAAnQlg61uyOwCUml/4Bc0RQf1BnntsYk8fJp4oduIQceV4HxIiBgfGR7+Ec2jFzPJha0LIKSrXsgkuc3sy395o5zvoPc4Qm65OoC8Cn/uiFy20tLHmKcZikfWxXyRlSmjTaSU2Luw9o7/j+9P/kYk6xoFtNhGkxDCJkMyVYzNoWDU8n9TX3aRcG36462W/gje1bJka3PWKVRv5x8Wyxsa/UUSZ6JvlZl7dZvfM+bQv9DtTgrivbvO7wTeZP4ff4Wc82Qu19rkBPpXq2lWFQEAjhfx0QdcFL5wPM5EZZbXmpfYOJ6jVE927KBRKyY8t2qEb1pZp6P4RYw6l0R6WyQK2Wwp20z4uInxFCAtE2Fs1lrZaPs22MAwT+up1kFo/pFQfVxRwr4/ycKUWujl0IrFy6j8hz7beO5lVNC3vFitpo2zcpVVivF/GPnB6z9WrbwRgT/pjcFAaA97zDy9oA0gz8Zta5AeTxRrrcZ1BCCeo/CDSBeOovUQXcsL9k2cs5sXsQHPMgBSlscUN8+sq2Vks1boz0KUR4bsmryUF+hAVYrxYUaFcFw9SkMxOtX9nAx4u4uCY351iq3vUscuN9HhD3dPRKY5xP/dv5QiV/K5Ce8pH4isnRVnc4HcYqeZfIQ6Cax+3kkq6egmHrMizH4rQCntl8G6XW8GrH1tBkeW8hObz+ssvh2j6ij/wKU4hjlD6Le/Hux7GIvhh0dkBKDZnQlw61guUByF5aUFPOv5be/fGlmQ5gaPrCVtN1SUImA3sQnz6OFbEBVlRiqwKBPHR8r3x82Q4+kFfrwyi07GV0F8G82LbUAF92O16PvbKj52ZlJW4a30/7TbP8A1rQRvu4zay+ios9i3VgusHhsHK0juqIoNrT8IiJ86zZpS/o7rxE2XQgNE7Me96x/WdRLQkK0OEmCzWQntLSR6bYLG
 Aq2pjAmC
 YfCDfIRdC3EGKzyWJpd3DPPzjocTalWlL419UlepuczctYqJbCHEPT3qPyYDPcv/3uV18TnDzj+2aKVKBVvamzom7glxpEiQjJIusrFBFU85V20Lyg3dr3fuoNc8qbAmwNAjoxAllcoyaupGwGyWScX+6YEAMHQIbEjO0VAq11cQG3nxBer1xYVmNzhV3a36mG4oXoBzaRBQg4dsOvgNxvPgT//Z6mHz9r7e0cdvg9u7UUlhJEPk83ppT2wyjdOzNgGYF5UfAOQVwvXncESjMjTSD3ueCyCFkQocQR4gGnJEzga4p96/RrKGlJF0PSQ4C2JeSBt/kaDiOCgR/CyMrjG6tj8tzbB2e7eOpZ21EH2YqQhfNXJvJqnFDTvqkJoGnMAbZAsuTrDMRUSkgjFUEoZ4gVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__next_zones_zonelist() tests a slot's zone for NULL, then reads the slot
again to look up the zone's node. Offlining a zone's last block rebuilds
the zonelists in place, so the second read can return the terminator:

  CPU 0                             CPU 1
  __next_zones_zonelist(nodemask)
    zonelist_zone(slot 1) = NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    zref_in_nodemask(slot 1)
      zone_to_nid(NULL)

Current GCC and clang merge the two reads, but nothing requires it. With
mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a nodemask
allocation between the reads while the node's last movable block goes
offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   zref_in_nodemask+0x9/0x20
   __next_zones_zonelist+0x23/0x70
   prepare_alloc_pages.constprop.0+0x16c/0x190
   __alloc_frozen_pages_noprof+0xaf/0x330

Read the slot once and test that zone. A NULL zone still ends the walk.

Fixes: 11cd8638c37f6 ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mmzone.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mmzone.c b/mm/mmzone.c
index 9cc9ef588580d..009f1dd75dde8 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,13 +43,14 @@ struct zone *next_zone(struct zone *zone)
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref,
-				   const nodemask_t *nodes)
+/* A NULL zone terminates the zonelist, so it ends the search. */
+static inline bool zone_in_nodemask(const struct zone *zone,
+				    const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
-	return node_isset(zonelist_node_idx(zref), *nodes);
+	return !zone || node_isset(zone_to_nid(zone), *nodes);
 #else
-	return 1;
+	return true;
 #endif /* CONFIG_NUMA */
 }
 
@@ -67,7 +68,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
 			z++;
 	else
 		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
+		       !zone_in_nodemask(READ_ONCE(z->zone), nodes))
 			z++;
 
 	return z;
-- 
2.53.0-Meta


