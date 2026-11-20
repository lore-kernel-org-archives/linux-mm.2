Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D10460732C5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+/SdY5x
Received: by kanga.kvack.org (Postfix)
	id BD12D6B05C5; Fri, 20 Nov 2026 13:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FD46B05C6; Fri, 20 Nov 2026 13:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3736B05C7; Fri, 20 Nov 2026 13:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628E66B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA1FA1C1197
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:09 +0000 (UTC)
X-FDA: 85456286538.16.1BE8A6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A995D10000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g+/SdY5x";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198207;
	b=w1gNBje9m3maxrIeNhFASe8Y/y5eFbc7KSIiab9RDyGT+S7BkFrk50OSd3EoPS41hRLPYb
	l7m33iW6BOT7hIChmIiWKjCPtnjPRg6GSL13ohSLyVD70oI13phUWW+lr/7WwWHtfqQ00f
	cGqFCra/HMx4xFc/4Ytl2vsRzllPzDo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	b=xTmgHEPgM0ETTupZZr4H/wmlUFcEHH42sVNi+EpmBTc5q4acAc9Lux6W1J5CFybAb3YaDc
	rVzgkcAiZ1D3QcQUbEUDZE5YOExW+Ql4aMVHD62+fjWEcHMqrDuILn8QjewwSBqvm3GJY6
	e8KEKfKI4+JQmzAEFqKRTqnLK4kcx5g=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g+/SdY5x";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B473346CA5;
	Fri, 20 Nov 2026 18:10:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198206;
	b=uLE3Q6FEw1IxIG8+VO9cNOCCIuOPMvvg5fUADeYLgyp8CVhx42FTYZzH6a7iyteBkied
	 58QdRXbIYTI+D76zeKA+2aPir0o/KJIUYIPVTFQA5fdhL12B+UEPuk1qEdi7JwNI05JyR
	 HeKKfTYVGQeIaLNMwzTDFUf8yC7gFxDG2tF5HKbu8eosvcNZWF84/9Q+uLWTesTjxusXF
	 eDOgOwsObLMVcQf5gumSgQSa+N1m+tU1hsgzSS0UEXHax4pSqeoLxTb4jCYxla0xOR5nZ
	 Js2w/wPeMKgkPnbvn/tULvHtw8Z/HNPoPLdaW0NOD8jIADglqHtzdlCnR+M6hnKGCUw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198206;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	b=I36YE8ZwgW7ZGd7Pf/TlyQtmYptjxZYP4k7SBFGjWhxL2ctzsYsf447aJex3+fz3kc8q
	 0cQd+mgCyKvsgz0uNfBoeTBjJC4DLOzCsADMyG2qYfo04dAe9+FTjWn1kTlQ5QZXXuTgf
	 cFDCQOZBY7ZT+MuDXi2GRP9H96aaYJbMv2BI4ViwI9PuyZwSSyodR1abR/tC4aErKzFG0
	 VCZ9GjSzDH50ICkjLay5K3lzr2zQSWCFA6Q6/GJubfNEG1hIWV0ip1XfWQgwXTAscnMGR
	 OuRL12zdaDyOH8gDUPnqLYlngzIGbE+269+o/zJDQkNPF2kwDq7WxC4k0ihki+jazDQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9218D1F00AE3;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198206;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=g+/SdY5xHel47WLXZexLq5NHoCLXq5Ot87GcAfGnYsvVv/yR9uRqo3e4lV2VN7V2W
	 Ld2dadOy/OMR6moQViKSvqdkp8vxWMCN67rmVgb3PF9FqbJV6R0nipsaYClM/SzvT+
	 RaFuNiO9/QeDpUfZ3DPJXxJzTI4Qgi5KhN5SdOzp4zovIMQ8un8SNe7ZjJ3B98FkhN
	 1udujRmwiqlsW30q7ybcrdY3FX4UpteSO/CZuu6SUIrDRukPb4riJo0u64ADh1sd2H
	 BId5nhBcMt6kZAL1xLE43fnw9mBzVnBng7UUoJOCj8Um+K0eIb6te62mVI8LxJGgs1
	 iSUkmHQ+qHARg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A2E054B8F9;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:05 -0500
Subject: [PATCH 14/60] mm: base hash distribution on common memory nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-14-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=752;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=kzu60kHcR4jg5+83pzySdZg/16HqDs5ZJU+b16doVWE=;
 b=748lnM0UAIWYIikKEzoqzk1NLfEf9UkP/kYV8mG5fcRoZKQ2waLuxmbZewbEadsHLukTRzV3V
 r9lLSXCux+nBTwzYAwYPzqHH+pyb+k2EBGnYxU14R5HCUN2/FGpt/7x
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A995D10000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tyjx9963rdjf6dppaxgfjtiw8y5jyrft
X-Rspam-User:
X-HE-Tag: 1795198207-633947
X-HE-Meta: U2FsdGVkX18E16zZ4AypeBbFNTu+tJIsOUit78J2IGCdq4xx6xKGGvX+70FwCnFGtII2yET4kHbsYK0s9vd8ouDE+7qxT4gIK4OqRfDCEqgQrp3IuXxJ54GIyogs0Qrpkb96Rb5ufA9VTuek3bSQtW8iVBitmAd9sX043WqU16oWLwMxfJ8TFJ0feHlBkbKl0CPkWdHu+kToYcv5OCC8UsPCcpy5khKk3n75yySwIaKLSs9YSbfTjCr5TqABfCJwr192rQIfQGA0RTGHTno6NqK9i49HYKj2PyzJ/DTvdhMtArIHfhXoqcBLLRWb9+Dck3QhAH9CLSd4mj5Nur0L4um4P2kIEFMdFCSzKDnkxiN0qen8cLB+oyt/c5phWrEJYE0uMAcmvfL/qvdry7CQpyyEbu/PhGcmAAK0axsQ676pn8yBWx0wkWsXyKIMpM5pHJUwXlwaAWNjwZtX/pdfeKJFBIL5oHNgM7ISaQSQj6ct+Q5HP35jHIU2FATOFzBlCiGsmuzRFLFf8cDsLvPPEtUVP/H6KsljXxLA8LB1Gq58sr9WEGocBGkNUhj/LKbFY8OYoNYi5PLGTbzYpP7LzMF7k5lydLOpaxu77YuMzVUK8aLcG5WAlwpErhXYxyQG3JrUDzT60IgCyCztdkhQ3P8Rirf/S+kC6MUf9kbZjIa3hJpeanmnTA+8ZLod4g/qyFKnJyMXO3bYuAvWBx2Bflj0y15x9nwQX7o9yjtbsYR834C4bdCIP6eDbEkQnWrY2w+6w5hOTJTCsFl0VCvwRCmbD4oXecBFk2eM1XN19jfWAH93Is/qUUGk8g9UJB3NAEsJtPQQ4HM5RMSWaT+zIT0vzfuw6A+5pdTT3ZGIIqhczKONNTx5z4v/Or+jIfR1vmLCc0/8KX2aiExQvs36aYa93g1BaB1gX6Ex4PoRp2hMQx/DD0T+0+n+INruhISiSj2fk/KyC6V1Jd6Lxrz
 FpH0AXcF
 yEg0HL1s7zc1zfre7tlzsDpkuOi4JbdF9najLpy9I1M95EzGuwP2WPmmGoBAs4h64/mXwn4WlNVNCbVf1DEnSIDFTOwqe+ODxtIdTwRIWQGY5RIc4pfcqay+/Bsxl1daZF6k4rjw4IAn3qCZP5x4CwfG1SxMOB9NrM8uJif6pBPtWufJBzUY9Mwt9P3MmRAUM5GD9UVqQkHL11STbtbeQfyzuB0f3gOhhC3rU5jbFZklPGv/BIHenC+CH9F6In6Ei5adf6ZsNL5oPahGEvB+e55XUgS3Tv/dNzt21w/Oqkc5k4ShGO7fX/L212858Xm8yYsjmjgOiE216bvoenTTqXdfAqZ+Avi+AcT3rUCN/vo+yQpPPmSDvk2fQnTZyrKDmDmX/ovoIk1AB/IcCaVdfTXUSVaYdLP8fNrwov5J1AHCV91PSLD+fTZY6GFzpKLJSC+E/hW1QGhmbHSFrf7h3qBzHJgCm4sFUUo6JcKNGjGa8VV1T6azPVyXS/9xQc22mAR0dbniwrMpcg0kTOTiQG2nZycuZ8hZlnRi9hI4eeyzA/OpNJiKcwf0WV5cyKOjha5KB3YxMW28ZbyU2R/zJtXxsPI4OuCKCAu4Z96yzLjH0PSAsVv0Nely7Aj8gYUF/1YRZU+DcL+Ed8l6txs086aa1vXN9BT07tY8E2C+6J7RFKq6MhBrIt1h/agCP03X2IYrEQUHyhg8gXRQyCNoYka9DKCwSrvbehffl8bvv5N2PuHJDv5tzA5tN2dQKv4muTD71Mof6Ia/Bpzs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

hashdist is useful when large kernel hash tables can be allocated across
multiple NUMA nodes. The tables come from ordinary allocations, which
only N_MEMORY_COMMON nodes serve.

Count N_MEMORY_COMMON nodes when applying the single-node optimization.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 46fe9a274a7a..f21b3dbcc92a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -685,7 +685,7 @@ __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
-	if (num_node_state(N_MEMORY) == 1)
+	if (num_node_state(N_MEMORY_COMMON) == 1)
 		hashdist = false;
 }
 #else

-- 
2.56.1



