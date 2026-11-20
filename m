Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0CC607CE5D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RN2ax1Dx
Received: by kanga.kvack.org (Postfix)
	id DA7176B05DB; Fri, 20 Nov 2026 13:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1A96B05DC; Fri, 20 Nov 2026 13:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98A96B05DD; Fri, 20 Nov 2026 13:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 709A26B05DB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0664E160134
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:40 +0000 (UTC)
X-FDA: 85456287840.01.E6FD16D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8F7C16000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN2ax1Dx;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198238;
	b=5OA7bK6rmgO1AvLsVFkuz4ZL6qDsM2RexF2e5SWFJ9vP6oiU182QddERn8Wks2EtaiPUuO
	9c+CZKsLOMZZJtyRIMauzBLP7DLgubuffJHi7TN2rrEdH1N+0z0GpyAI6B6Gvt64swr773
	qy8AbKO88+67ryu7BOUyDQWscpEc5Zo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	b=YCTPYtj7ACUxj9EtSK5ZXvUCbbLhupdcr/WYtujm6rJMTjRjm+WnfnXFOuy5SIsSLjFT6x
	EBbzZ/NfUTSwKi8jCOZm56YdiWlxz/864xTWSEpzgfrUZZC3edIVBK47z+p3OJdE3hZ+GJ
	ihBlH2Cy9vWLBK5doaT9kHgUYBmrg3s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN2ax1Dx;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51E0446CE0;
	Fri, 20 Nov 2026 18:10:37 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198237;
	b=mDGva4mSuVgtvxlAvTWPMyfXTqmnyRj4Ht3cM0hoLzrEdHNa8+ZX7kTdyWdJXTmv92rx
	 XPoVtuw2VHBtUuVmuizRwD+DiH8GH+CuhIVmx+X2bsoaDM+8r4AnCBHpXT7oiqFfBEOyQ
	 H0qqGdfyzjLgikYDbOPg/u9nmxItEnEdmh1mZqZ+F0t0c8XXnBfTBGloOIbqObEQYInF2
	 ZqiWaim8MbY+ktszFiYRN/ZzFXMMaHA+PcVhKCtt/xauVL7boCCi/BN4o/6VZ2ppEhp4+
	 mqk7NLYidkUwnMCbMOeuEJ5CdNjEgy8lP65KBuHaUE2PuPP4POSCCzC8Lf4RXxiWgyw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198237;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	b=2oIj9p7gAr6h5yhcOdOnPIfl8w/VNACvYJCfy/JS2g9C2f3dbfUPWw+sdO6VTOwAeY6p
	 DZRhQCBf3w8xJPRpebcXD4tdMAgSmugCmRtZDMH9fJU/j+SDmLo+E98xYBBf+ehjkXcVF
	 /PXleDahGWr8xDQLUeOAQZbtf6he9OQTQv8TU/KG00o4p0zm/qV9Guag01e9zc46lj811
	 ZDRX36XAyn4XtvJ0GFjZ9/xE8r+0a7A1JLtEbu/tG+kpXeHw3MlS25LyNkRGlOsA2gYjE
	 YRBiMFneSMqewi6id8at7g9FqJ8ctxph9gZaBhIHenj5T6N9uoYgI73DgdCNfSS5/eg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5E5B61F01824;
	Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198237;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RN2ax1Dx/4YSP7p7jVGSMpn9MJBf5CY3/hUf7sct4xnSXuj3+yBXeu84WBIh9o00g
	 rNepF8xd6E/7biEbPdqHfci4qvbZyhkpdFfISrC9ZuUUkOAD2TqLKzwiv6B+NpF6U/
	 cPv1MvUXWoVIH5st9KUB4FAgURZrxtEmjRlH44r8yjT48ezfLfac2KD2U28CqBh0gx
	 XyKzjbumWlEI3jDntWvlxKplZW5H91UYSfYOBRVzDwgUbYUoX1SXDR2L5WzVQsED6P
	 Y17LEAI4BiRVnVXMr73VrSpWyX9qFBAZyK3iClN60Avm1jT4mKoy2lY3cg0XiP7UbW
	 8wmjZDpPLeiuQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5B9844B951;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:27 -0500
Subject: [PATCH 36/60] mm: refuse explicit reclaim and compaction of
 private nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-36-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1212;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=eVaoyJoyzU9zyOtulCuIbI+hG2+czzxVMTo5PX+qnoE=;
 b=67qX9eYJBrvlvPcdtzToXyRPuTdmsGPvAub9aazmEHJk4ZHCWWJWu7Tqa8XRPOPW+PAeiRoBS
 +WMnYQ09bUHA4ZgWD9y4UJK3j2zi7pY+0jx9YkmAbm61ZjkvAHWzQu6
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8F7C16000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 71hk7remkzhfrwiqpnpyj998r1wt66ms
X-Rspam-User:
X-HE-Tag: 1795198237-257729
X-HE-Meta: U2FsdGVkX19WEl11FUb/dd4a+4DgCdtXaoF3Z/vPmdtYL0xqfrwVCiKsT1/hG5fYzLkukKigmik0Yq5jo6FT0N1YOB8kvPlMyrcl1vEbbbfTswb8qLlUrR4vjxGfjqQw4TF6Y+EiBwGsDWTWiFCxY/g+sbh76wLB08BgqtELpotZcTOjn8dyZFzXcoe2o3oRZc48WGC1WO53RJjO58OnIau2r+ufixfTDuJJyo0vRNoGYUpbKaIKUg0ZBsge0RoKNVMs4UaUMos4RjzgM1XSNGlt7AzdRQCsvziXmr1omTsSc3+z6ym0JUJkrftn8+0QY9G6TQrukaLjyoWXgnkj5TDlPzVzTSfuXVMYFGbk2yi9rfUCMZjl6YOjZvqXyWF8FQLntd7OsyBNbiUybjxdTxvrVYUbDKuaKbgRGkNOTsy6C4M2DO0XWUiaSNNosWcquLJtQr+fn8NqTTMggIuQxPVO2OpvATue8OvXC85tMwGa06K1Arr+tBJoaqsnCoJyknmLLx/s4Ku4Eu0XBuD5Y5xmn/VVUBoPwa8wXKPXu0ekNcfnIM5PjT57Y76jmju2oASHeEIYNYOWO5O65sGx6TTCx+nW6k/R2XYHD09vbwcULrTOvDvmKrkd8AvaHxhQ77lHQE/cF6UR/7i9LUrm9Z2/M1BsiySTeSG5TLpBeeclvfGYlZXrmol7SteufUWw/VTHForLlVEqWfg6JeAkciAGvApxi6n8ix7BILNZv7J+Iqm2EfM8HERGBmCGgiov72/EBCgpAAPSJvQU/jNssHB6PdtREQRE/6u3NVNqt0J42QR/vrjXdKBdXZMxmg325eQSfQfc6wB2y0SeKgjoPPAFzG4f+9/DG3lLTt0lLwAjm382GPEemGF+9Gu2MzEtry1ubDtE2kLYpm6se7M7B0gi+I8Pouhl0toFgYbQQyCuxBLmj94MSiUyl2+oKS1xrqPSPxP1LFGfb+gvpVU
 SCeGZeK1
 gF9YRmTWlQykVXbshrJMkcViimYDbglenFFJOwQ0k04pkRmle7rSza9VNfxJqzPk7MR39bb+JAT1JwJp2qhW+CPfqO40CtukdYxEdLL7BfPIB1vb1MySOiG3LLbC+OqQKK+ML1DoVtidmjB7trpjPf3G8Hk7nLWDkj2QYPapHnK256Oh+c2UhVS1zwnjP/Z64iJ4NxQAOKLAdjOy2dOCsCzwo704b/UGaPonKkNKoiElKH+E+Amoc4r+GquefFxMHp3uFZmNdm5srAwf9+UpqdajXKlkAa+KiqixwA+N5pnMVNZJwdMOLt19T97fgjT5EMc5ga1iGjHI20q7/ZzN54lKoyn7oSXVJbc7VNNo2edxrkU0D+ZyLfulwuyEKVA7J1hDuAsWG5X24PHFq8FIOvLmO64iu7AIIZEHRFrD7uE2A56SLgUriT/DDAw9Hxj2pHIzyyLvsjeZdk0X0xoNqgq4eg5Uy+f0EuXaXmFqCTft5wuj0Gk+NwzUjr3NTr9kjt4n339uNMFWuwMDGgxC95Zb/d4oPQXHy+nlxVr4wiX0FgiIkmPdMSxggg5TLOYVQUv4O1SDHUrPx/02+oQp2L6bUjDnJD1Jok0TUH6UuAihNhsyBoRIAYE/HGg08+ca61EXWH3ZMOdtGkWIQ/8zF0boB0pOEJXFKpzNnoQuE/IugJbIhZ8mszLbOXGr9zhqOIvopSiaBIBjfAS5953dIUvs+yW4VaZY5N57kc0qynn4DNktOE1tDJ2YkGIlj+3KUEF4grAfrf0vEuC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

kswapd and kcompactd do not run on private nodes, but nodeN/reclaim and
nodeN/compact name a node directly. Reject them for a private node with
-EOPNOTSUPP.

Memoryless nodes keep accepting the requests.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c | 3 +++
 mm/vmscan.c     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 879f372a891e..283d4d4e78c3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -3038,6 +3038,9 @@ static ssize_t compact_store(struct device *dev,
 	int nid = dev->id;
 
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
+		if (node_state(nid, N_MEMORY_PRIVATE))
+			return -EOPNOTSUPP;
+
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5b53e0391d80..3e934135e805 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8268,6 +8268,9 @@ static ssize_t reclaim_store(struct device *dev,
 {
 	int ret, nid = dev->id;
 
+	if (node_state(nid, N_MEMORY_PRIVATE))
+		return -EOPNOTSUPP;
+
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
 	return ret ? ret : count;
 }

-- 
2.56.1



