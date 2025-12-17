Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF993D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FDC6B009E; Wed, 17 Dec 2025 02:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0E26B009F; Wed, 17 Dec 2025 02:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224156B00A0; Wed, 17 Dec 2025 02:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFAF6B009E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:30:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBBA15B893
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:38 +0000 (UTC)
X-FDA: 84228140556.30.1852DC4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12CBEA000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKBDmMTT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956637; a=rsa-sha256;
	cv=none;
	b=n3lZCjjaI0feyIz46FfQdkuF5Oa8qE71FmajC0rFLH3vHya3/cw6yrrLOey+bYEzv7HR/D
	VA1Jm0W0zjo2CEsy4gkMMqSXoN6ezGDh914JlI5VhXzsnoA4IF8n1tLNeApWVsdEvzYrB5
	YUtH1E2QVuZzjKmu6qHy3LVGMBHR3x0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKBDmMTT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRju/G2AicNAtYXExappHAHtEmzxl9wl3ybhh14XiuA=;
	b=ZVPR32eyK8h1tmvuIuPSZznPi3JoDnPicMIDF0RxSBBit9lL1a4+9LFy/XoItqtOxgHnea
	QTqO0YbCJrPBUMda/5zQZVJapvGjRuETwi85b7grb1Sft7QBUUTEzovwi6A42w42addV52
	8622vBZBsYtnp5aErNFzc0OYu9sddvs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRju/G2AicNAtYXExappHAHtEmzxl9wl3ybhh14XiuA=;
	b=BKBDmMTTYzW8+KMzw0Cb3xu5yMNfhSfyczOl2Mv78ulFxvyEK/rvQ2MT6DdrmHYG8sBJ4f
	0ubQx0rUizrQc/VOotOqMHlErCaCFTLP7UWSLt0s/+GV3xQMxDZwaPZ74xKb/hK4pj6g8l
	moKY4bPgdI/MUiDypKfWktPBmaozvTU=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 09/28] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Wed, 17 Dec 2025 15:27:33 +0800
Message-ID: <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 12CBEA000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 6h7s8umn6ocshkb6t5ih6pb43zbagb1q
X-Rspam-User: 
X-HE-Tag: 1765956636-37669
X-HE-Meta: U2FsdGVkX19UoYjQYXa6eEDhlBZMfEeFlj5surFqEGSAvEW6Oh82sMMrBhlU/Q5RakaQlQTxT0vGWejdMs7jtt7XKj7C15yaPfO0HRYGb0I9zc8XDVZVygaMly5AIzLQfbbbCityjHyeE4Y5DTT1Is1aW4iOZgdcIUcVd2Ox268INcE96um2eFgjcLNhjxHKZJCuOIAhzCUNKun4stihffBO6Mkd5VW6mvu1PZo6txJD6+M+UKFUDgGs1+8vSez+mCAuMPQ4BECNYgPCcYn5mwzk1+7WzMzPJFNYsrYpuC+M8+PIqPFVoxUfLkxk0DdpQqkfrPEOTk3is3i0iV+B9g7lasR9iCKZ5pqI4fcuY1hjGR81V3Op4OVKnUlKzM/a7Hk/3Cw/2O/KbsRwNvm4VZYFn1OEPlAEOMo26HMmYwTVwR3NU+rrf8oeOuojByamR5fGAbtYSvfzjqdHQQb8wxajep9SceNCm+J3t/8Ori0pkxMD/VH7T8lsbN/AVSqDGKEBYzGmWWIRefYTzBRjwr19dZPcYYXYkFgNKjXoGM6lX5Ec7sCB1A1e4GFTgxewqOT4DM0j1y3jvaiqfUzIZw3x9KkzOpkg2ReUE76VtImkBYrSu5vHDyxEEoAza3uO80GaTMlIgL22P7zmJEvwZ0/thwE27mO+b0PtRND5bvTZ4HzK19QMO2vTnlmfcz83mOBMd2pjUwhTu448Bibz6/q+LU3Rtr9D+R8bD9J9zCrkIEMYpx9o1oAzWrCowxpBT1CZhVWOF8GE5SbAbiX2TFRKGUvtJUrhrhEZp9UoU+F9jkaxeTK12Zf+D4jbbHikbg4K/iBs5DZKCQAIfCmhOlemA2nk66cFK+E/xjuV3m8JPUF3PXCafyvvxNqDgNJyaEg4iK6+8ElyePbfcozYwu2vw3XfazXiboaGR+PZ3BbbwjkyO7beOzVfEQEvNxaCN06rW5aV8P4nLb1HBKl
 U86icHlG
 nPc5NhLDnI0MsxU4ncIgf4bFU2AI76/cDvMGF64EwIQAEenf2Ow1WEM+Vb7XLwnnxnfnMVzpZugrX3Less8P7OF+pUa9Jkmzm2An7po1FEbWeVRJ8T3am73zVrKG9MRcWMhdoQypQdC/F6EWmGTjDX9VBa0Uaw1404n2i/OefCAdx5ORwpgQ6jMio2/RV92jsg3wyY5daWPkWV53Rqc3ka8MVtSKxDszc5iSF8a+qoVDs+S1iYgF4GbUi18IPDmfaj5ww
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index fd53b806ab7eb..4552d9cab0dbd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -925,8 +925,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -947,6 +946,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


