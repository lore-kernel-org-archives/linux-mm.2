Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6250606A68E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPmCzh+A
Received: by kanga.kvack.org (Postfix)
	id 396F86B05BC; Mon, 23 Nov 2026 13:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E486B05BE; Mon, 23 Nov 2026 13:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237D06B05BF; Mon, 23 Nov 2026 13:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5256B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7234A409D9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:31 +0000 (UTC)
X-FDA: 85467282222.11.573373E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54063160007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPmCzh+A;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460009;
	b=1BUtK25HBFX4s/6Lmc+Xbh8E2kJNXAmHWNDkgPKOwQRpAcUwj6l86dbareHE+DfI6wWI86
	t1DfOFhN4DXlFqwtgWHcPjsnJdjIGrM4BRKyLw4w4PeY/BDO79ODYGQCE3S1Pgw2LqcYGg
	k6pyO/aiMIpXipBEtDIp6DeKll0s/WI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460009;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	b=k6Ts4TvdShdwtvA+Rovlm0lMcJPhzbWJFIpOXzIE6c8toEcArWSfLTaZT/v+kIKK+u73Jf
	yl5v0Ns3rFgX4/m997NNrgROVipQ4z6w4aYrzftdXuJTuYqcBynYXCyibfaTMes36LIlV+
	TCTJjuWm+hiPowzmTcMkNMo+HXXfSyg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPmCzh+A;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDEE4389A;
	Mon, 23 Nov 2026 18:53:28 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460008;
	b=IkbSjM02YCct6LCo/t9Qk/DWKn07wS8mnfownjERpqrxhqez7LwNgIPHDNld+8S6l1Bz
	 TKaidyI5WZIuBLq97ctd7RuTQiUpFbFQZrTN5dYX1FEmMDfzsq0WCWp5DOj9BDCGQ+PJP
	 XVL2fmUCEfAnXywIZdo+3v7ssWams/OluFZZHHNSnSyzrTfNBs96Oc3lbrQ6KjyA+czpG
	 1UWv2WSzL5CvQBb197E4tjfRzZEbejulIN11rPldQcUdh9695cQoJarTyyeWYPkTm9x4J
	 GxbHCS/ppc51jMnfUdT4Pg2weAgCZqDV4pfcwTwJ1xAPwyFy4AxrqTlyjVZ1IWUV0Wg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460008;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	b=JCI7xh3rZEQiqQDQf61q1Awg7CNrP3tDth/6aaokH+0Z4ZNkSXdXz5wxjHpWEnGmEXYa
	 4Vf+H5dMRVN1uOngC+ykxpawx7NhVPZwOqw5+oAa/t1Ts7luSFg6CQRrGoipGIfiHXMbD
	 S6NsOGfi2AN+ayfCPELN9zzVmkCilf7xKQNf06kk81Ib/5jjHE33hCDapwctlc2SWkkzS
	 89F3xLtbn/xgyYYUEFOp1EZ4B9zgydhljLGkO8W/fZPNiwidhu31n3iELW2FVSybYjY6c
	 MVE0vDxbqT6EfpSIA2f7C15VSmHco7d5+KOJV+fIcOJ+4dBvAcA/H3jyEic2WJm2Jkw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C4F8A1F000EB;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460008;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CPmCzh+A6NNjMRp9zp09y6UEKz+sTvoEMJ47tNe55++QR7rU8b+uaKoL+sJfnt5hh
	 XhF2hdmHgj1Q36KCvJN7TYtG2w9QNN9tZb8o0Ha6hF4orsBeGBwuU1hjovob4y4qPV
	 kDQMOoXB/3hmBbwpMrMnhiRZA1b62YF+eVDQfRQEOHRtFARhl+u+tJEyKTb7En0eht
	 BDVvMF1AxylU8S9VrzMVC2x61301fI3rjSE59Tznh77qtWY3V9QsdMq7gw+pnI7H+i
	 JuKeqCpUOohaX8K90iUf2cqEAIPBlPoo72IT2BWFCj69Lb7kV3BeMgjTs3zBG7pDEK
	 l8nUyTZlmpiRA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5A4E44C635;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:55 +0800
Subject: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when
 reparenting local stats
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3407;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DITLxusEF3jFekXchW/A6iHzf//ot6gPbXly+2fd+cQ=;
 b=oQEvwa9i+84qyXpmUPi7pXNiCe/5dSBG7wL+wB1oC2sXK73KSejhjUMAwogTXAJ3+Pcs3FOdO
 fyAevJbJU6HADPweDl0ahO3Xr133F1H4Ez41aJ+ynn60czLlmD8SsmG
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ocuubpz3r5sedaj53e6m1e5pb9cbf7gp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54063160007
X-HE-Tag: 1795460009-435856
X-HE-Meta: U2FsdGVkX19jHVw+OzmqwIZPZiZzebqibUzZ74p8+hkhu2Sqz4lESmDXYgp+LYqrOwv/lgDe2z9twJhQK7+oaNICdoUEVdmd74lqXi7JP4RkODex1kl40UlA/iWwi1v1SemWgCeoSErZw7W+soXseEWNXgkVNsCM0V/RvcxxxjkYvGZLzZXrAmqQSFS4Zi6kE6fL1+zNayKnnYJzylo4auCA303dggmou/qfrve8T5d6P8gNToqCp3g6sGsvTg5BIUmedBjeMZhhAH5D0cuZ/LYJHJ9o+OBJT9JgLDvkAzUalkTuoeiy1wLlLtdZWQ8kKZVJMDuzVkWYUuq/85FHzQdLnms5uyD7WTKrN+CTvKfg2nxSofsEjuhfnBbboz5T7JYPXHQoUnnFHE3D5GkYsFhTkd5WP34c36joSZiFnl2LUcKIZt7FDrINxZ7ky5UAh7N9sX3BgH2ZAlI7WOmRpCdwF7nrpYjj0Vb0nhWT8iYFfU1Bg62qTzgVKHHl0VqS4tpxnBSHMVjXOPLspsxXXMtWb9jjcv73p2yp1VwDy/WE3FvS+tfxLrXPdF5j9XXpjG6I+A5xYmvi0EOV0uWnoZZewMbZLPZW0ala5yZgoRFJeqqgN6bKpCk3xN8rOxWXg0qQeyqRW1KHwiBSqWWIJp+wnX7deqhWgDK/9NloREN5bpMUJiP1kYvPgkQe1SwVKjIWbijeVNj97vXEUugeyjygh36T6vDQ5r0iimEun6aFI/F/SEUxmQ3CB0tX9YvXzCC8aIWwAgoGAbxNtuu2gFoGD4wrTlft+09hl6ktQe7z7m/Flxhds2jhV7CRLSFdXgBuqMN2H/me6La98G/5iHdq23+r7ULO/aNODkT6FRpXYfCBxYOHVMuEb7kwwl19RQgVN0mKNOK5UJ4YNJACdEp3fpOXfYeyPzWErjqQ0WXpOy1sYpPVRVMPnNgiXT+U98+YBgjhdwXm3lXSZK4
 VOlFWk6k
 tIjC9sBH7fb654R0xw8i3g9gNTcNaGXl9QdG9rZVdsQiQz9wFOR2KfvKD1kqyVcVB987OIoMh+rijinPiASt6RyqT7aUceOaiQjFhB9WQ87uhnuZmsWoze5BJg3wjHZPZkq4vMzCiB4mBLxSvUBVXIWhq5qnUBCzvHm9w3aP6bsFDRP3VoPuf3pMBqajPfG6pP+8gqqFpyckXNVkfo0blzHAtsewV+ZhMEu88ka2ESQchTO2OKqZsgYg8pMfhH4U69fz0l1t3xot5qNvBBzKxywI76XiAQfJ+2sa/Rg7a9f52bB0Yk6o7w9MROHpZCIJwVUgc7lCCog3BPPxyzdD2Q4E0hdCgbbkaKhBmz0qmglJ+iG4f75FUCGaybIE7687f5l46s2HYXjv9Hvur8I/czCoICZ7dOJc7eMqoYGKaX9fDWRDQFoDvm/BWYv9Y2pcU8O3nXEvbxWiWpVid7xSlQ9OlwdXJrV688CezAQJk71Lq+EKoMhSwFhLW+nHIvmOXUYgNeT/2DcThH/sh+sKyK6FLVQyLIQPN6UsbCRFldtw2JjpIVa9Jj2K/KIVjMQuP4c7dq0Q2bQ+3Dq90PeElhrclkgoqQHhohQEVM6Sf9Rn7N2+O31gRSQa8ie6XXSvP83yTTUauyoX3rpvQwIlOCT4FBiansCJP0U0XA2wFbeLaVaQ1QtPom19lUwKWovk4a3/RC4MTe3FmWkmDa1BMXEIRZ8bttkSx/vCCNWJZFIX+1JYPl2rgPrO3xEYEeWVT/Dbr3RoDHSQd4RzVuS9kYt5cHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

lruvec_page_state_local() clamps negative values to zero on SMP.  That
is right for readers reporting page counts, but can be wrong for
reparenting once MGLRU updates the counters without the lruvec lock.

Reparenting runs after the forced stats flush, so a negative is a real
balance that has to move to the parent, not be discarded. We will
introduce lockless MGLRU promotion which may cause following problem:

 1. A refs CAS on a folio on the child's lruvec moves it from
    inactive to active, and its active/inactive counter update follows
    as a separate step.

 2. A concurrent isolation of the folio reads the folio as active,
    debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
    to it.

 3. The child is killed, and the two __update_lru_size() calls from
    step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
    +delta.

The child is left with NR_ACTIVE_* -delta while the parent holds the
matching +delta, and reparenting the child's raw value is what cancels
the parent's credit.  However, if the child happens to hold few enough
folios for that counter to be negative, lruvec_page_state_local() clamps
the child's negative to zero, which drops the debit instead, so the
parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
total overcounted as well, permanently: the child's local counters are
gone once reparenting is done.

So use a raw signed helper and reparent with that.  Ordinary readers
still keep the clamp.

Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..3f551e2e3206 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+static long __lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
-	long x;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 		return 0;
 
 	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	return READ_ONCE(pn->lruvec_stats->state_local[i]);
+}
+
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	long x = __lruvec_page_state_local(lruvec, idx);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 
 	for_each_node(nid) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(lruvec, idx);
+		/* Reparent the raw value: the clamp drops the child's debit. */
+		long value = __lruvec_page_state_local(lruvec, idx);
 
 		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
 		__mod_memcg_lruvec_state(parent, nid, idx, value);

-- 
2.56.1



