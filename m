Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB4CC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285426B00E6; Tue,  1 Sep 2026 04:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD0A6B00E9; Tue,  1 Sep 2026 04:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C32D6B00EA; Tue,  1 Sep 2026 04:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 965706B00DA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2528540348
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:20 +0000 (UTC)
X-FDA: 85164591960.28.B8B80AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 24594A0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NV3Gp4if;
	spf=pass (imf25.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253098;
	b=4PWvSbkfJCmO0UU1f0FDDT/gc8hR0HGVtemcfdjMX/S3kTyfcSmApJSwLv9ZLd4dVOj2cR
	FWA8uP5NM5UZgekIRfoi6DT0yPE+oLE1z50Qs3i4Z5cmUgEFoMlMCI6o3FTkosbLW8scHw
	HWRwbr3dHJgU0Q/QrWaj7o6m0aOGMqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NV3Gp4if;
	spf=pass (imf25.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7fdTFlSPi11yRu78APlisEbRW1kbqQnjXZAow87VJM=;
	b=QYif4JrBUoqZ/dh1aE43s29nvH3QvyIw0wTkR8yh53CplqL2seaYfAq5gRsNS6wjn6BHVZ
	qEFxgQT8GzeWdsBJRvW2Dw4wYSIR3psyiJj76bWmgmf919wgM1+RhA1YTaUxgqd0aV/qV+
	5JIgLQjhHjwnnKu8vVv7C/RBO2C9LKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC27419D9;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCB02C2BD00;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=aIiuh9ou8roZ4tGxttm9/MkqYiiC/wiCDtUiGOaAUGY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NV3Gp4ifFweltofgntqM4I5Ys5cvDmz7WMnaPulUCAhHV8UA3bQpbGbDNECc/Q5yc
	 +KyB9lsEcxniPZmA85tkj+SJ6Mz0KAr+YAnizrLvfs4EKNquNP01JnctXttyhG/ijJ
	 WIO9scwhne+xGVzEAUbed2MUkvjtu+mp89mRNOa15Xxp26oA8xN1qaUM+yMT1EbOdf
	 qnwBXyn+TYx+zECCoo0+b6T1ixcSvpoUIOdsL4ia+RVeYtC6adkSoWJ0jxopeU713C
	 aCL7yfnv5et2Q7KRow+nKvpFvheQDIs7AOEd6TA7UOE1ZThyDXb5PJsDcUH2GTe0fL
	 9TTUBbEmltPzw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB832C624C6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:01 +0800
Subject: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after swap
 charging success
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2079;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=ErkCRKG7+ifvfMdPwACVPkm46ElNXWlnuq1XQ4FUIi8=;
 b=DDtDUpfBr/Cr35KrVKoFXS5DDP6UzA+O0oBVcDic8cgdd5zeProvls7hwZXdQbkadI2cVWUcU
 lmlkGHHPgxyDvquRgY9UsYRryi10Q4EWn81coSXY+EukseXogsThSAF
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Stat-Signature: 4ze6go56jfiapxzt7wxigmtxy97j9u4c
X-Rspamd-Queue-Id: 24594A0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788253097-899401
X-HE-Meta: U2FsdGVkX19c5qzmO39W54w0JpJ+9uuohbrjedh7+h7ElFLurGjfjYUQmAinq9dBfAbJ9s52KXOc5fEkkb9+xzSeCIADkOxDj27n+frBCc7RLtgMHQlAYvim3croG0yNkV3KvnSRcK4CC394ph+1RmA3IwQhqVOpHtn0yNABJBb4cNilHiSw2KnLkPP8Zkz2gFQSqV5QmtA1aihafguY5UJy1k7JA0lWBz2CoCuSMN4eXTazCnihd2qlquak4WiS/y6h4CeTd0x8tzEf5s8qrIkSS6dbgbUYwi87vri21hgw18o2x/N0HUybZld/CwApE20pEeTt36fzXmjyi1iB6NTRsgcq7x2iJ6RMC9W7IK7PUyDTOb1xXo7PWEsLRuBQrfaiAteDNc2DSJgliblXiaKpFtefEVpRrJpUPN2KwbuTcd9BQwJdnUoPiXABH7dp8GbZyjVzfd/JZkQB9yQRFydZKe1K3dWO01KG8XprNEYOSYmjbqQNnBxntitxvXuC+PlAyAqPpvLIqNIcml9z6GldR5cR8Q1srHpWJkfzf45LxzUsoO9i3OGv69iCNzRCZ957sFNiV7yhL/Q5zFoHBQxUrA8w6S60rWTQ9hYotkX3MZUzbDjTDe4Mm7bJOluwKC3O+WGVTy/ANjxFR9P+QFQug8l6dHRAKjubhaKbjVPGUMagOPTIhecjXdb1r5if1XRNtz+jLu8PScYx8ys4mFhqOqFuSGyHgesML3Kmv3kgWVEinU8OiPprYNP9yllVRWIBgB+xwBt4f/wmWGkBZuqCqIzf6+1RkMpV4E7Gukxyu69S6XGBJjCUbIa6VRIVTwIn329/SGO5OECcGVvk+Xp4JTEe1MM8oXkN4awEhJXtRr9pSj43QXuoVvqtzjVYgdE9kPlT45mMxSE08IxBUYBf9rsKwiApcpZ2H9oV0Tuc1v1ddDPsvqSewP7vZJUiBtl2SFOWwOPRDqIxQAm
 Cg/I+o3T
 MTAm6fTcZKiX3n2MUII1rXDviMUoXr9vJrhE8A2EmHosSKD53kR/JkBk64fysmtpLFnEaAqD6LarP9Sy/As4rLVPuR2NYAbsas5XATRcDNwXk8HuT3egr9ifNnvuqb4tc0+hSaJhWLFGU1jRX4AoW8EBYMvhAUB241NzndhB3gBZujG7e+rBQeVxT3u5jmupJPukLhFRVHfa1hZR4m4pa3RYvQFMR/rkJghwQKjER0R2mfOV38wXL9pZz9HcPVU4n4ZK/EFvKjkJaawGGoJrHrHpTRA0g5vanSIPwrEzPyReSP8hnvyta9A+MLU5pVYDglU9NdEKjOmF99ThZbd8P3BQZV8a3vbpcGMxopP+5JaYN7D8/bua1dyjMpaQz7INXny4KJR8o5rxFmBwQGDT9oqsnVlzTNvdjMQ6eGGVi9SFiHUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

__mem_cgroup_try_charge_swap() pinned the memcg private id before the
swap counter was charged and had to undo the pin on the failure path.
Hold RCU lock for an extended period (which should be fine,
__memcg1_swapout() does this as well) so concurrent memcg release can
be avoided, and take the id reference to its online parent only after
charging has succeeded.

The failure path is now a plain return, and the id is only pinned for
entries that actually end up charged to swap.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 31cec9dde55f0..ecb4fb07d7735 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short memcgid;
 
 	if (do_memsw_account())
 		return 0;
@@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+	while (memcg_is_dying(memcg))
+		memcg = parent_mem_cgroup(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		rcu_read_unlock();
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	memcgid = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
+
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7



