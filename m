Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062D3CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5086B017E; Mon, 19 Oct 2026 05:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6206B0180; Mon, 19 Oct 2026 05:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095536B0181; Mon, 19 Oct 2026 05:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC3A46B017E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:08:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62112120631
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:50 +0000 (UTC)
X-FDA: 85338800820.21.B9ADDB1
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id D541FC0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=frGZjK7g;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400928;
	b=77nSE+Rh+Tw7o+wC994Gzip3Ha03Z77JDjAOMaxs2/RYDLJfkjG+X/XujlZyAnmJyJhdXj
	BEw854sJi39vmJUwt1WMUPHQq/Tbq4kwTAwB1b/sWMXmI5lWVSa7Ycj+k5iNlf/EisVZ+7
	6aVur9TM1IuukrZRfzMzFMDB4NGbyJE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=frGZjK7g;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKvHy7y34UnvBEvhC3G16rSuhlzefUt6PxJ3Dpiy+6U=;
	b=vu0tGW+9zWi9qk1zs61huKlpqtAg3GOXmZHnbLhyIcgsBZ0weh02Tif5P0dp0J1/3kmQe/
	9EIZGG93tDnwq6Zy5+3FF1dE7yjkh7QG/ELo9/WZl64Xa+vUSFKfUcidwaX3o8jM98sIPs
	th3DbNe9Hu0ChrLG59TmWBDO6ZD+taU=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ea0efd636dso870775ad.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792400926; x=1793005726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wKvHy7y34UnvBEvhC3G16rSuhlzefUt6PxJ3Dpiy+6U=;
        b=frGZjK7gM9rRt9tzXstrxwHEHZ6U933+TGXuP11wb7Jl5IgCRcLQvmer/mg6TGYxxR
         ys4q8hMDdQGVCDWcE6cTxGj02vF3Sdm30sYwDk8dNzlpxQzfEwQc4XoicKJhWKU7JAyb
         3qAZ/PEiWxxPk9vk6XTrRj2X08Xh0o4zSxHguE9YMDJ43L+setHXu7W/UGqTj/GQAhSu
         xL0KaQeNDkOGcSLuQbdd8LR2x5DpPehtqR6F/t6g1lnXpfonJKteYjjunogTWbI5fRNp
         DNQCgLyIs9emNmpccfOW7uUxWJL1T9bIGKGf/Jcp4++Ld4fKj9hXc1L7W5Sb/C0KqO80
         JXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400926; x=1793005726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wKvHy7y34UnvBEvhC3G16rSuhlzefUt6PxJ3Dpiy+6U=;
        b=r+ImIc51UbAy2pEldTcLoiIXPLdpR5ewYT7jj3rpZYTz29qmmfvJr6qlv0t+KWCOOm
         fJz1b8X6hanDHTJYthgG0v277uue/eNSHTGZU9hDtjHaHzx99gFVzxkhQbR1GKQVe//D
         FnGZNl+OQu1DRzMehG3CbEpKnYUr+ufvk4Zw0G8MTn0kFIP596LXkVvW/Mfmtwp35m1p
         7am4SveWIkiY+pWiOqteK4uALViydWsSFRiko7ZEgZrFTxmaPqlHGCjA2tjJdrQGpHqN
         SNegkPyfkVI3Nf2gVgM2HkxuGI/ZWDkdR27oVbO9/442sqjw8k7QESJlQUbdpXio9AFk
         OHzg==
X-Forwarded-Encrypted: i=1; AKwUvByV/PBfdG8SUAs3WKDf5VJ03h8ya9i0z5Af60JDS4nsvUuwL6dRgKlE+9BXFc8yWmjHRmqGRqdwtg==@kvack.org
X-Gm-Message-State: AFq9FYJMhjEKrnmaZ19UcJtsUMAJScXK8tRVPhpkHvCn3XcQV3i+QV+h
	wGe607I7q/VT9NvHwn8GtYoPQIXHuNacRWTAMArNfz58eOv7VfL7F5Bjau/knXcjUUU=
X-Gm-Gg: AYBFou0rJsOrjIZz5/z7SNfzxZZrO7vxZIoJH5LernjlBV2yd1+4iXY2weszNpdzGWD
	C7yWFQTlQy/m8mJIF27Dao3FuofZIOeUD3Oit25LWps3oKqy2PSVa/bMBNs4zoWjnM1DcUozI6z
	8+ypg9h2lT6djPw9RGL+PqCse2KUB+X8zxNet/CPfoWnv9eADQXjGQdV7bl6c0rCkCgduTEuVAy
	fIfy5fM6TzHBtIsv8ph13cd9zP3Bqs4YIiJLAqfY5a1Q5qXUW0p3VhXJLzHX3+P/l7K2agM4VOl
	OgeYXzvtpIktD+uh4Ng+gNSCniOZC210wyOkoT3j3zZYzUYboyCmSJ7UCT3irsxsz17ZVDx1FdH
	i4BiQ3a6AWjTH3uZWnl5jqyYNsSJczx9hXWrMNSuw4jrztOTlIkTnggBAQ8CExyb9/t8/QCR7L5
	QQeLFFVDXoIYJqdvto/Z9B7PwApW+wPDXNzcrepqdmqEmfHwigrg6bpQemey05IQ/abgtONeLC+
	OSbf7TTyR+3lnWeHGI=
X-Received: by 2002:a17:903:2c47:b0:2d9:383a:30f1 with SMTP id d9443c01a7336-2e9a6842eb5mr63237055ad.4.1792400926399;
        Mon, 19 Oct 2026 02:08:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm36707595ad.0.2026.10.19.02.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:08:45 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/4] mm/sparse-vmemmap: map shared vmemmap tail pages as read-only
Date: Mon, 19 Oct 2026 17:08:27 +0800
Message-ID: <20261019090830.1917657-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D541FC0007
X-Stat-Signature: kifxgbg48ak18rb9kxfjdiyqkez16rug
X-Rspam-User: 
X-HE-Tag: 1792400927-785855
X-HE-Meta: U2FsdGVkX1/IvhXeIH89YcqgSdDBy87PxhWvZSbIxYCmFowp3Yovw1OCZ9xNYqYKhAfxjXZf3234YtUINidjb2NroS5IGU8csDG7+FYlBWeV7MRVEwOd0Q2HUHXWiS5tDRcG2A0Vyjjq7oyrrbVKRsAzE5vSI2881iyeuzOFnAzzUwkk1Rf5nuk5ZUPFhBgD9e2vMfjqLTTbqM/mYEXKcYQDb1ExoBZgkfJM5xOmoQeCEZ0u58cU6b+w6VUvPRpGxJ8lwqt38+7hvZ+aMfpNlgDWv86iP9n4yNDZ5JqjA4PR24ZIYLW+HH1uivfrEHDYw2T5J9qGYF000Zy3SJgaqQt45mhrYfp1BoWZE0NnSwWqLnx8OrDv5SD4+NIRRMN99dDEf0FuDXv7rC8V0xIXFUJRB8LkBg4yZi6EtkSAc+NU2/zT8WLdOWN1EbCBLfH0Rhdjy6nyWbtgtKs0pN4gIKMyZ9MVw72jGouGZvhYPVLAh6csXTC2m8ja5fwcsL3GxQzHLDL4UWTMHBbSiSZKifW3VSV5JvJWL3hH4x9v/97kGEO9xztI3fd9RJi9K5AwWCrinehqOfi+P9Ziy/o2zB4/mzMsQsBDlEb6olJx2vWLnQLQjnoSDNMv7q7N6khfMSNAgYLJcualmCuIaynvXv1U8h6vsmuvEq5ZHMJ4VX8FXDYxdGNd4qn/moW3/F0+bQX2ITeYG+nJe/JP14KFCL+40WeiTNpPXpcqItPEhHBhtr+vwBaN5FOw0o8VyBFQpaRQkaM0RQUtJR+AGX1pFdRfz8yUph6Xy1G1eSQC5fyJxxLU710hlXxODgooUXJxA+5aHSkLu8nPVsFKrRj9UFjs+5B4oaOS8oBb/6WK/Z9mGowlPC5+4Q1M0ZuPin0H+Lwy/oriZINwNd2oPiEWQ8DtVMsYBTfXkMMLjd1rRlrGACGqyZDl+zHZqmk8/gAAIwzFoXjkW0iFHoojvF1
 xnvQiizm
 z5aTx6l5r4OabTTn89K3G/yaWm207yzbkjv+kz0XmWku0T7tw6FxSGo/YRr1Rg8OZFxfafZznxBB3pVnIAFay+3GK6HGR8w5QFqhmkp3EMRakW/yqW/1W+kV6Sn4xQEXF/hcRS2ewZ3dvrhUfk2+/97GNAX1i1xatlJmhkLJ/Nu8YUUh8jTJrM4gdsKgnH1f7h0Qofc6+khnH0U20y+axleAE75l5gjNmKVUIp+orO3ary5dq3PIA4QWEE6MEAqcBg2GJmiLnD1ZdGDzcJrvvKW+l9UUxSV55PnklfNh7ct+BLTDIa+HopS6Bqljnjy4DsLYvN/4cViOqZ0NlqkU0zBZB/qxT5fBaTWgouO+izg235S0KH+WuRpRTX9OdAMJyG871
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both early HugeTLB HVO and device DAX use the common vmemmap population
path for shared tail mappings. Map these pages read-only so that illegal
writes fault instead of corrupting metadata shared by multiple tail
pages.

For early HugeTLB, this moves existing write protection into initial
population without changing the final mapping. Device DAX gains the same
protection.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/mm/vmemmap_dedup.rst | 3 +--
 mm/sparse-vmemmap.c                | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 8c287ae3f86c..76f903975a40 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -193,5 +193,4 @@ There's no remapping of vmemmap given that device-dax memory is not part of
 System RAM ranges initialized at boot. Thus the tail page deduplication
 happens at a later stage when we populate the sections.
 
-Deduplicated tail pages are not mapped read-only. The mapping layout is the same
-as HugeTLB.
+The mapping layout is the same as HugeTLB.
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 40eba70c0048..ba0496daf4de 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -295,6 +295,9 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			return NULL;
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
+		/* Map the shared tail page as read-only to catch illegal writes. */
+		if (vmemmap_optimizable_pfn(pfn))
+			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
-- 
2.54.0


