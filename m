Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D02606C95B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T5dkJTut
Received: by kanga.kvack.org (Postfix)
	id 0884F6B05F9; Fri, 20 Nov 2026 13:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039166B05FA; Fri, 20 Nov 2026 13:11:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C706B05FB; Fri, 20 Nov 2026 13:11:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B572B6B05F9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3974D1A0126
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:28 +0000 (UTC)
X-FDA: 85456289856.16.8C00F72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 246BB20005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5dkJTut;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198286;
	b=E5LXypdVNGgRcMzOiO4CGCsZ9riawE2tId0OHTjnkw3QHzpWl5Xnee1GpBDTLSZ11vcr1q
	MtBAl4hKR7TltwXZPmHR/nEqvWsPjK4w0nkm/E9L+fkumM9ileg9bT6eMfn1wsmmo6WHNr
	ZhH1oxB8NLubTEvOZlaPswvLIsKE/Is=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	b=E8b0XNvzK4ywo/JCsZnsthHNmEzvd96xUOzyZ/4wcswWWT39enQsJComzffi4Gvq/lSiGr
	M1v44gRhsY43gvtHGPwtHVLiL4gGWPjxtSnpQSHuFi2wlyBMGvGwY77ezGRGZAkQ5v8Ect
	Bwhsm/tTUegFShPkYICJHOOVS4CMNic=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5dkJTut;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 699B145049;
	Fri, 20 Nov 2026 18:11:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198285;
	b=p1GmRizE15Ahhu8e2hapvrsaMY45ejuyaEWr2QoqMQZdHPVyILsaARX9TlhD3uIWO5da
	 Nmp87p/EFlJEMwHz3g6lNvTO7sCQ4x3nOVsgXu7TawI647FqdA4TpqfEXkN0zFL+vKJKp
	 1mdhXTeosc9lus3IYQF7Ig+U/TbILg/dHoS2xJewVg4rSZgsN1MkkSI/A2EaGWpoz23js
	 pSxChh3dTJqyCGZIzw/0qLAOzz1F1rzmf5bqx0Wpa610wVuXnmCNBLSmsMQxOmSrWpAr9
	 k/55OilasThy7QzL3nX9B/Wo4B3tJSpMff8bHJmyhfXBqHZlOxvsEGHAaRhlY++QYlg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198285;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	b=rLVuo1YDu+kpIyxbRlHOTatrGKhan1ZotOvSkl0cU+/rMu4i5PfwrAJ4QarZi8NMMrLx
	 bROHY5K3Sygyo23wIHDsOrN7rhbtUjW6MaYeGkvMN9QFZGf9XHWdo9rN3heXZRt9S3E47
	 5eYyhrnsdoS3DMvGPEdQ8FbtHEsT0Als0EZCDhaZjco4IRJR/v7Sk9gU7Ldyge6Q+Hmrj
	 1hScvujhVXYjsqTjgbI98njBeIRpETNghGSKy9RdWg094gOfHuLGYlYXDz6M77I18WGJI
	 hwphbRyMDIPWSLUfq6cG08BsPDxJkTlyRhS8p2rPmE/kHAplE9WwbKXUB0B1xabiPXg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4E3C51F01811;
	Fri, 20 Nov 2026 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198285;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=T5dkJTutSHxPb+3/qtTqlNluFBQB1wO8AI5UTEt5/KGehsfYZV3oRVAPBd8psi1xp
	 HR18+N4rsQDYt7gwNfF4pMuWAlKh+wgQikyiUF8wB+vfm/Y4qOh9NfBha0VI0uxVt2
	 8H+FcVuQuHxGCRrHBiH2v3RH7S5iW9ZxllFmOfBeip+kEVAcuyhRxbYxyzltoTS36Y
	 URpOIOTNKgRUc4RBDynvE9sXERZqmAyWMM98LMl1lNYjxCQ2TPA1UQp846OPWaRmJ9
	 MHXAv3sJwGoYPPR9NV2Ibt0tpnOsRexDAWy+IqaDcB6dqL4LsbEDDHRSOs5lcc9FY/
	 kTa+U/U5yRCPw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 98BB24B998;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:45 -0500
Subject: [PATCH 54/60] mm/migrate: route explicit NUMA migration to private
 nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198154; l=4872;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=LdBmn7sW2WZfOe8jPXvczezaQql167iyE39pQOO8QgY=;
 b=sTml8+HqIUvMTacUxZiUfSUZimAOAY9MiHZ9lsqd24xS7lWLntm08ZOzq3xfS7DqVpEkNzuQu
 aE+pXSWkZHlDCm/IGuzhatOFii5433SjI7oHHeyyJr2YhuHNaROFriH
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 246BB20005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pm36oyaznysata4wn1zs56natxf7e99x
X-HE-Tag: 1795198285-918851
X-HE-Meta: U2FsdGVkX1866BvlH4MYm+WMDS/w/Bh0a2T9KG/qs8HdA6+3AEU+3sBSnqPxOWDwsa2aWuAe7cAz2CiWsYjSfN2nWmtPEShLNCP35LSVmcXaq07imcAczC6zB7SdFXR7Mu6LilOxrC0+GGJtVJejprefZGCAt0hHgpQTGmG3nizJbyzGkuH1f1j3Chc6BWa7uK+3t7pp8X0ZzBv4KBCdhd1LWVa6r22bIWXryYyYTQ9gfCVg8OQWVR0T7+Tfp5JUuWjgCi8Eq1bsj9pV+J+tfwjvS4+oN34+T6pVJ6DvkbXZCsuKqVZomJWDVrUDKGjPcuDg6i+Xj34TkE4YPntXqw3bprPAE2ER8SZaGsO87VNtjQ4RYGDeg3EfapYBXB7JM2JWJbSIA/YBHWt9IIR++pt+4A/VRn4X0mcuZBafePTuoK0SLcbPaTeb0ZMfgr3mREdyuiIAcnEWU13aM9Ee77wQlygh3jtbcqxtWXU6lPtI2h6XjKR/W5HCS3HiKySN+d8MCx8KzHgbi2UsVOd0gg12EDEf92m7qqDszsgtQ9H0wSsigJu/pRg6uHXG7LDj3xnPs5u8Aut7KqRjcg/2nEeeuNkHS6gMngl3pugMF+owI85A3iEsK9jBN4XxPHhw/Z6OiJz/6XJS62/xDu9vxVkrXa4/Bxa/wyl/VyqqW3pwOKDali26DihGLy3dbUfVLO7Hl0lEYFpa0u/+CC5sWC1GkVXHTsaxtlvqcYM31O5kOdzSQ/XcQr28rASQuDmB2pMcvqWraZIRgzPt9p6Q7H6X1IBNpyy9jC79VxbGyM8gE4ZisGpm6vO/1fNlcfqCvrJmPJTT3aaJXsX60Op4Q77Y/Q9UG2SNA2SHYLt++E4gcv6f12wTk4rO84WoeHjO95rGyQr5SO8QXNhOUUioeMZQXaIDfH8HH+pSM4krkM74waNlxljRKjhp07t7KWrDVmToL/56kkQs3gzEUQo
 69s07FZo
 7qqTpOUP3oLmBO9sml6OlEOye+ewZhGPoanzhvWhJZ/c+1h/jEp7hwWQwpT08OHQDXdEjbcyVHY+DImJ9MEu7Oi/Q70Rj0jvo1Fyuv803/lRXICZTtYckGAAhZKKky70L6odKn/HMsK7CBbRpmQ7SSIadTv9pBUP1TlFcqILrI9ygO+nSiG5qt2WTemZkvVEqj5OjHGPNKGmbdHER7pWftV6N28OIYsLPkUubhAQpBtOnUeUsPAK6hWWpWg0zCk02Zp+OmLehrQcj4NaR6/DAHZBARZ8Fnw8npsyDUAe1gfT4FNNxLXmJ3bg/9LsO8jI0rAvv8b7ZxTG/ROQQbqR1Te5AKzj126UPeWLHRctM6hlrLm3ZiQfxxT++nek5Kqin/ihUwGNW1Z8hDWVEwTeh9+IVvfW02DdBNpHs5ntfPqAC0Q9AtH7ROUWy3xydG4WczH3gGJWDpklKL+PXCf1bQq+SM/HbkJy088ctpT02LY1N6xzyqr+h+2jo7QD6OYLZLm7bB+InfB+Zfdg/52BaKU0oH5nfQDaYyb1LZdVozheGiUDYhCNCm8r/JdkgORF4lZCE1mmStELaWVcWNjAQA8WYJ08bVJ6FX6DZDu+qY4fYBRDtYiJqe4ScbNNj4iXkY+3QzOjW6DJKKZyVEY23fm3zDk0x/TA04rkinzf05vW8sbV6Pxsdx/tW1TAXruZi8hYEnq9LV2NutDZobe4kMwk5nlvA/GHDHn9llg5TlhBjMrSc75dUnClJMoaYkj31hg6VPFqeOdn2u04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) and migrate_pages(2) allocate the destination folio by
node id with __GFP_THISNODE. A private node is not on its own
__GFP_THISNODE (ZONELIST_NOFALLBACK) zonelist, so the allocation never
lands on it.

When the destination is a private node in N_MEMORY_MEMPOLICY, select the
node's private zonelist and a single-node mask in the syscall path, and
pass them to alloc_migration_target() via migration_target_control.

move_pages(2) now accepts such a destination rather than only common
memory, and still refuses other private nodes with -ENODEV, so
do_move_pages_to_node() only needs to check N_MEMORY_PRIVATE.
migrate_pages(2) keeps such nodes in its destination mask, and drops
other private nodes as it drops nodes outside the caller's cpuset.

The other users of alloc_migration_target() are unchanged.

HugeTLB folios still cannot move to a private node, since private nodes
hold no HugeTLB pages.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h  |  1 +
 mm/mempolicy.c | 19 +++++++++++++++----
 mm/migrate.c   | 13 ++++++++++++-
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index c83c100a5253..646efc2eacd1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1309,6 +1309,7 @@ struct migration_target_control {
 	int nid;		/* preferred node id */
 	nodemask_t *nmask;
 	gfp_t gfp_mask;
+	unsigned int alloc_flags;	/* ALLOC_ZONELIST_PRIVATE or 0 */
 	enum migrate_reason reason;
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cb5419cb7ee8..a7cbb05ac86c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1340,7 +1340,7 @@ static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 			    int flags)
 {
-	nodemask_t nmask;
+	nodemask_t nmask, dest_mask;
 	struct vm_area_struct *vma;
 	LIST_HEAD(pagelist);
 	long nr_failed;
@@ -1351,6 +1351,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 		.reason = MR_SYSCALL,
 	};
 
+	/* Private placement is reachable only through the private zonelist. */
+	if (node_state(dest, N_MEMORY_MEMPOLICY) &&
+	    node_state(dest, N_MEMORY_PRIVATE)) {
+		init_nodemask_of_node(&dest_mask, dest);
+		mtc.nmask = &dest_mask;
+		mtc.alloc_flags = ALLOC_ZONELIST_PRIVATE;
+	}
+
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
@@ -1951,7 +1959,7 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	nodemask_t task_nodes;
-	int err;
+	int err, nid;
 	nodemask_t *old;
 	nodemask_t *new;
 	NODEMASK_SCRATCH(scratch);
@@ -2001,8 +2009,11 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
-	/* Private memory is not a migration destination. */
-	nodes_andnot(task_nodes, task_nodes, node_states[N_MEMORY_PRIVATE]);
+	/* Private nodes are destinations only if they permit userspace placement. */
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (!node_state(nid, N_MEMORY_MEMPOLICY))
+			node_clear(nid, task_nodes);
+	}
 	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 6791834f14fe..eda961d43df0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2250,6 +2250,9 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
+	if (mtc->alloc_flags)
+		return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
+					   mtc->alloc_flags);
 	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 }
 
@@ -2267,6 +2270,7 @@ static int store_status(int __user *status, int start, int value, int nr)
 
 static int do_move_pages_to_node(struct list_head *pagelist, int node)
 {
+	nodemask_t nmask;
 	int err;
 	struct migration_target_control mtc = {
 		.nid = node,
@@ -2274,6 +2278,13 @@ static int do_move_pages_to_node(struct list_head *pagelist, int node)
 		.reason = MR_SYSCALL,
 	};
 
+	/* A private node is reachable only through its private zonelist. */
+	if (node_state(node, N_MEMORY_PRIVATE)) {
+		init_nodemask_of_node(&nmask, node);
+		mtc.nmask = &nmask;
+		mtc.alloc_flags = ALLOC_ZONELIST_PRIVATE;
+	}
+
 	err = migrate_pages(pagelist, alloc_migration_target, NULL,
 		(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
 	if (err)
@@ -2411,7 +2422,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY_COMMON))
+		if (!node_state(node, N_MEMORY_MEMPOLICY))
 			goto out_flush;
 
 		err = -EACCES;

-- 
2.56.1



