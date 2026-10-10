Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD9ECA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE426B009F; Sat, 10 Oct 2026 03:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B53F6B00A0; Sat, 10 Oct 2026 03:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EA46B00A1; Sat, 10 Oct 2026 03:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16AFC6B009F
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:59:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 043F61C4006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:21 +0000 (UTC)
X-FDA: 85305966564.12.415D5B0
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEC60120003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:59:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YXz5Adt8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619160;
	b=piQRlCBzPpau5gE71pK+dfCB4PCYC6NInSUA5BTavpwJtvkzNHQGNZ+lNfEuu47tiovrG/
	JJ2zk7fO2nmXGkUkL1U5xbR6W9Yavmm3wagm9uQSqx/WjrUurQJ/TNNoJScojleqvFjEES
	vz638GDmTa4khaMPct6/Y/B6i14+xtY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YXz5Adt8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9enHGmaDPvvJJBwJoSb9UIn3R22GPADXFoJJNtoblo=;
	b=tvPn0EC6zHJOMS7+Jt1mlRGXsTYpHubhHtnnSfMDg7ZbLx1O+7B3KzlrqyiPgCeAUbd/yY
	WMN4TmjMQrUfKONZhNntH6nNONp9X6a7ZxO8ZYqyYMNqN6jI8kNfOqgyvuKepX7ghw5QRN
	E804mTg6qQX1b6Vq3l7Ph5wls5K2Wps=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cd1e069cb19so256587a12.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619159; x=1792223959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R9enHGmaDPvvJJBwJoSb9UIn3R22GPADXFoJJNtoblo=;
        b=YXz5Adt8mzNMGUnBkm28D+7GlNid4EapexKKJAr8Zttcn1KI7mlM9D1r2297ve/J/Y
         qx9CIO6HAywjZBggkkhlk3568qYxMDqqoCP7FHr+CUsGa09RM/LFw6OWf9wW5DojNeLw
         QtsIJlTYMc5/P0lbrix62eL5rcZFnoZrZYq9wBTrtG16TyapOkBOxnatjE2F71lbBpH9
         9j6L+a6nZNZvMGLCbLlnxfv6XXxCe+Ru1FhxvXKMRUN1eSp6REms/eibG2k4CdcusYn5
         XzNg+38VR7LE6y46sfVK6h0z73ArfqE1yEVWoEmRaXcqC7qX4UETptVvlfoJhKn1HU6g
         P8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619159; x=1792223959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R9enHGmaDPvvJJBwJoSb9UIn3R22GPADXFoJJNtoblo=;
        b=W0nW8tzII902XJah2oj2viGS13xTiGxAAtSwNxsj57ZjcRt4b9278DkSqBjJZE9nHz
         j0tkNB67cmF6bxeWv8ZiRWKvQF6VGfKSKpNTdMqwJ1HydWz3DkvOYjU8SXN9hiB0F6eY
         ZAxmivSScbHw6Zx1m4sBXIsENtrZVwBQlg8THJ10y5im6Ab39Bqd0rIvxpVMYoH6oWyN
         PKR6YX8bo9GzLKeaMD7Z8V8fy2nPgD2yChD9ETzQ1avW1JqltLo0B0WjSAKaEj0DIFws
         UIyRGWvQSl0n+P95E6/CoiAjJzHir8osz6dcSvZ+3UQog7YRGKsusxl5JZhO0KdpuapE
         dGmg==
X-Forwarded-Encrypted: i=1; AKwUvByuTru3Dx20/61UAab9EZbSTXiM9qYd/6/+cj423oAv9fZUreft96pHu0ECccSu38sX5TtUzoybyw==@kvack.org
X-Gm-Message-State: AFq9FYKWRc+M94upUYgc8BFDKaPfH7EcC2jwkNrhwdDp6ef27WE29isg
	xWKpoYhV85H3lqdApsU4hW4RoaINsTS5adK0eXCzVR1LiYPj8jrSTo9iDEFzufyPZ3U=
X-Gm-Gg: AYBFou0bIcrLZIlC6oK65wzNYUlnKF+PPpTGLHAnKGWSjvNMgOLBdNqJgcHFAeTX7p2
	2zHhdIdDgLiafB7tMI3FqrR0dlUEM35mDXvArUI6oX3M+1sME2neEcJB6blcEjvwkF3RbF6mjOZ
	eYOtVDE9qXf8Crx+pwD4gbup8aeEKFyMYxU+U5hlywliEV+K1HQLHDao1YK0b8wH/2ZZYcw0nBu
	Hg02TAzzppWxVg5z3F+v2wKZDNPc81gYbLyRS/UZ54LlIteKt4BxAzDMk2Km2JgdSWTYRD1fGtg
	UevVxzZX2Z9wra6iYy3ss/S6MQhEcU+uI/DToiwWK7ZyVvCUzGEodUQu5Hfmh1hMFMbdubeVtBd
	41s15dCZNM3VAJoBzRdfqYKXtfscGyn2B5Tv74wLVSirES65RPDaehZWAUiLLw2HH8mkZhUHnk9
	bsf9boI9M0pLWYtsx92P6TeqwzNEJgl7WG0NdiGpDvz6uoTq6AKRHxOB79vPScGLDwIbSULe7fa
	gpTh9daSsQz8L9yShFtu8bY2RHmleSQ3dmiKw==
X-Received: by 2002:a17:90b:224c:b0:3a8:5d33:c615 with SMTP id 98e67ed59e1d1-3ab3a8d0ea3mr3496429a91.39.1791619158743;
        Sat, 10 Oct 2026 00:59:18 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.59.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:59:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 6/6] mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 15:57:55 +0800
Message-ID: <20261010075755.83339-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ikhhnjqwmum9xb5rprp9a4hrti9g3dt3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEC60120003
X-HE-Tag: 1791619159-318003
X-HE-Meta: U2FsdGVkX19mNOU9autDHZJrDS+ch6uLuMvIZGoQozMaS950bGqjGYNpWqLOO99pN01d6UcvvKrABud4ZYa/39prl6y/lh+MiKknpf6QFxd9XaDDt2KycK8oC0D+0xuFBiB6+ynR9r5O83Gbv4Io9JGGzGnEyooYYZrU39Dk6E0IcuHnqi4JRXEMxNUUlo0Z/MboAPhmIWC7JZAdB8quAMmYKkYgUGJdVPUFsoaLiIYhOlVU7y3zwV+64j/lixFEJrIGTHBkpZFr5FOQIJ8otUERplKNJDO3a32lfkQG1z3oErCydTL13vLLVKFBOQSexYIHDWxIBo+9kRFaxTexe/BegzZRDGkIKP8sdv/7qMDbIqEcEJa6yxmO5xLwh5zJmHwbpCgrF6u6Fwj9yM3TBBRvuycF+/6pv8AWOsthbwywP57uYg4JjMBQpo6LDyBXQP3F/yWsVvP5JQNNp2tHnq/fNVWqgz7BEMgEqmLB/PkuBm8FLcWao/HILswIthYqbnfpIfgor8tuX32PQV5LhW3/ZVixLKJzW85+pVbMz1qnL81RGsh/PfrZalbU2y38NkGSmTzefyCDzqL4/B9RINgxfplboOWFeNm8skpbfpU5r/Fv4j7fMsEi/OHACJJiMJT99seqGDA5pEKjI6WOiQ+vYnJ+8BAEoFASNQOP4K8BpaaqNqsfyKab56aDPZONzQC3IIKdG82Orq042uCpPnLPjDqSYNP0ucX23NwQD/rDzYSLYNYK4veJnANWZIHAyFGnGqK5nhF6C8Tqh0JYzlbK2MWnkgyQatTXT97MVaGgQDBhNFpniCxpUSxyAKm79fHy8kCZag1oXDTf3hOapwgVqBH+K+/Be/NfzYaWveSTrkTbhIzxEeKuZV4c+Hp8NMxsq4E0ugLm7oiC7RalWnFQ97ibLL37ppxvbJ6/VzBTJsEeTJ5TZRnQseU8JyQQmA7gw2yg7N6hLQYzs0T
 N71UO3mx
 Y1JMlIvAlWk0/Yad7qMKm6t37zbFAQ8SeQ/x8TZC2vQrXDL6ra+eEXe2Lpl1mizLbmUcgyPS28Db2SO9HBzSKSTYE8VhHqjTrtcgI5lUyDT/Ch6Pv8bybK7pwjYS4c5fATPbNxRpt2G2vRaZ1YMMDcIq0OJOar9BQ3Iaj9cdZD70QLVrD3lilf5enXgp26dSk3OB+V0pgU2IaPznzHXJQsGYTf7+CbCHNc/6b2eYPgwISPlU4uzhmghn0JSlZVnNMYP6j0qrqxcdE3tMfkhOvxoq6+DcdPyYZZC8wqyfbvLhDkPdb+tq/McP2VILBmthGXut0up9MHxh77Wv6Xi644zkzrusYuGhHo5+eYT8vBgScEef8ZezVMcZQkMzfbyVENPJypdVRD/M3R/27x3uhlowp2BeJgWoiKiLF3VkwyewIl3oy9RBRdSpVdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmemmap-optimized sections, tail struct pages may be backed by
shared vmemmap pages. Those shared pages must carry the same page zone
ID as the struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Factor the zone check into a local helper (suggested by Mike Rapoport)
- Collect Reviewed-by from Lance Yang

v3:
- Collect Acked-by from Qi Zheng

v2:
- New patch.
---
 mm/mm_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1650d6bc1211..6deae33db882 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -593,6 +593,15 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	node_states[N_MEMORY] = saved_node_state;
 }
 
+static inline void vmemmap_optimization_verify_zone(struct page *page)
+{
+	const unsigned int order = pfn_to_section_compound_order(page_to_pfn(page));
+
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(order) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
+}
+
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
@@ -609,6 +618,7 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	vmemmap_optimization_verify_zone(page);
 }
 
 #ifdef CONFIG_NUMA
-- 
2.54.0


