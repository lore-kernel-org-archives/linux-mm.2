Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99BA7F3094F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114526B0092; Thu,  5 Mar 2026 06:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DED66B0093; Thu,  5 Mar 2026 06:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F196F6B0095; Thu,  5 Mar 2026 06:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1D896B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:54:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98B31C27D0
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:26 +0000 (UTC)
X-FDA: 84511851732.20.82AF832
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC82E140018
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=igXWvWa2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DH3ne046D93m9UmkRfI664mjum+ALgiIemSaapH9p/k=;
	b=Gi6KW+8ezvFFUzEsshw+VQSqUjOhOKM7xwrsi3CXQrk5oJMOhuANMpmzA6mpiyo1+n7pvc
	aCh8vfLOB2aRTbKDNuLQBxwrFB4lewGKPTbKMdR18c79x2TdLrH2AABNtde9DUbnpV/rA/
	BkZdBaA2dNdai/XBnUcnmS9JT6sbTjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711665; a=rsa-sha256;
	cv=none;
	b=CCsZibJrCUVDvHOfuM5laZRY86iIfU/i3UwAPSxwfPsz46FR+ixdk5XwB414ZTFNPCJ9RN
	NFDV7/wepWOMGjMqzQXWE1CtopHBqvNEUCEDmGU0RoQ2J4q/b2XlB0Fzcp7r6ZCvy9tS8Z
	UIRMkA/krYEMXEbqI1moITnXVUKDsYM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=igXWvWa2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DH3ne046D93m9UmkRfI664mjum+ALgiIemSaapH9p/k=;
	b=igXWvWa2LejEgfiijOe0mqvJlDfl8MXK2pM3TUlHRBJw3DvKeE/vv3mPPPyqek07NhZImL
	ZdDmJo/LRii7ka7WGoYFjnxLYzyHmtwDz5T9r1Yc6M2rTq0fiKOyx29t5ximLc6DqFYOVE
	qQtgG4fOmPkoxrm5SIsaUumvw4C4V3w=
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
	yosry.ahmed@linux.dev,
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 02/33] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Thu,  5 Mar 2026 19:52:20 +0800
Message-ID: <11bd2fbbf082f4f7972a1113ca42a61fbe2876a9.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC82E140018
X-Stat-Signature: ykri1zfaptpwejzg766pxe31cioacd81
X-Rspam-User: 
X-HE-Tag: 1772711664-206739
X-HE-Meta: U2FsdGVkX18qHj7ziDEulWfuIETHxcE9Whb4JmOktDlcQUTVwFQQTHeoUi2XHruPqrAmKlTAv6spyJ7oOGzjXUzbRf+DRzSOLLVsrRL8AZ3reA26y44930i3dr81VhjKdRggqfoPHZJupcU9KVdwzMAjS78LEp1rdwQs/pXBGnvtHgDDDWksYAZzlA6BdM4xXxf7G42bSf8n5FvuJqFo4QMpiq3IRV7qx36hyTwBexgzkKR4M0IZiH82TtlZG4o5E+DDOe8ZMz6BsTsE5s9sCJQMFw86lo29giayZZ9RsQQl/jO80qEKOxmHNoVlfg/3W3LQ9X/NzLiayXQKkFujyhBFyShLtVEuvRQI839+hIMCN58iBIn8eA0jkyk5dpTGcEWGOokTRO+SE7hwx9NdcS+7DLyZqvU8a51Im7txy4beW9tEDPQLx/vOwpkppkycXv+874nWGAI72BilyKEgenmcpn0Jr+7yqbqsN620RfHku7kqPribkvQLKJJ9bnwrdBJxecEOZBHASHjjGDZRA7JVL+2Af4EjCua1sxtRYwc9/cBqSRhkVB4iPJHqg7u350nj8DvZxSrIuTB0y0YhogUU5EYIHN4zLVC66/TspOHRzbJv0GWWZGJxNu/dDNI0MxmBSaXAY2VOWL0yGMSH8vHzP7PTgUNCWKNeySoZn9wSFUgwXWt8UCRJ4EqqTZFLKnLLEgwWL5vlsZ1Artl35/6Ol3BuMRVMlHhMXC7s7LqSCllf+AemrEIU5gPn8FJWBZryMoiKO/bbim3pW3AMPG+P7VP7o3CwO/PCPesE/z6c2khhOfxKHJDYWnXGLWNU9v3ntpEQ7Le6rxoov5b2T7ebA52SpA2dXj0+TUiMYCws9UXciOSUxm1ft7veCCarL8Yt68aHaK9/zXFvcrwkft2NKGuZ7/djXSM7fWsI8Y+9A5shBoG19sFmqGCRveUDYNDLo3rx01XaJ6n7PPV
 UyBmjoMe
 FOuSfjllE7IqL3yG4o1LkHBBY2vopgRMw+7EQel9b0FAifixTXwT1nRYGHE+1dGOWZ5aBhnh0x2xCpuNWPZ2tErQ3KbTaGonqa4rJABJIuTSDQ9/zDe+3WT9mrcuzl1Sm1315JNwme/Rhsi6etDIYGphaVUDsNhmd8JCzXz4mWqp90kzufGHiEq/jBzU1M3JsttzWzgywmMCnTwy94x7PxsdIYmO4Nwz7WWauG0QB1mmB+2oRSebrydNSZ2HyHqGhdLroTYztbUn2bSFnGo5KjavHhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Use folio_lruvec() to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 37a94979900f1..5e8b6e62a6175 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -541,8 +541,6 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
-	struct pglist_data *pgdat;
-	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -564,10 +562,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	memcg = folio_memcg(folio);
-	pgdat = folio_pgdat(folio);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
+	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-- 
2.20.1


