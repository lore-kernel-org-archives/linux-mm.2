Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6808F8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475FB6B00A9; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8E16B00B1; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2B86B00B0; Thu, 16 Apr 2026 14:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3C9E6B00A9
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85A0113B1FD
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:49 +0000 (UTC)
X-FDA: 84665270298.26.C22C226
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 501221C0004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kc1Y4l13;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9DNylnOF49Hvn5u8xQTo7wMTy2gr5lZSdrZ9Mspy34=;
	b=6PTBltpALxXLbNxqLY/1C14eJ2y6pjBzXi/1KVEDoNrUYf49P4jlrS8DohyRgEVDfKmWp6
	LmwzMuOOgldMTOXluILe0qOoYZ1f2NhTlmCR4zOdcBI/dFtNQ/2pwoC2NqTbAFLNNPCc2o
	t2VBG9ccGXE/dFtxjNUOiIyWvjufEdE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kc1Y4l13;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364487; a=rsa-sha256;
	cv=none;
	b=lx6FPqi3IlZiy14Pvo8uIO/N5iicRMVgC0YJtmYL2NErKT4f3Z3El7l48PNb/FpTTF/qv3
	cXCIt6I6tlV14NY8vLPbu+3FLBmO4Xb6rf9o58W9InML2Bvr8H/AVEsKlB1+hSzUl6XEF2
	8nqwKoFMlv2lRWN2CNtP8zSJcBfJvmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A55E5446FF;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AADBC2BCAF;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=vCN+jnm2KrIoq6Jh4QVagjJUQZD7cvPe58DqpVh71Qk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kc1Y4l13jFM0uMz86aNc15rOvQCpQAijJYy3j+Et/5bhT+qSJdOX+kkZuwg6CsTM1
	 Ao0c7rxNBraNu7KubZBwq4WsGgnGn06uPww1iNXJEKD71AGhGsjjLMrmAOh6hz2f8F
	 MXEhkSwStoW23sdf+66XYKNxw530Ab/NnKteP9+MAnMm88HSPE57xcxDCulGStYpa4
	 9Ty5PQYOPuaWryqzxWFXe2/1kE7RDDCSziaN6GtT6xnzcbicUuF9TL4SdH7uReWo2P
	 CUofdULSdGYfxMeS6pLBZo2DXfTCrn3KpYf0Oxho9Xts4dCUh1/c2Nx2oeFUINOyVm
	 3e4HzSmaBnQkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711BDF8D767;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:37 +0800
Subject: [PATCH v2 07/11] mm, swap: support flexible batch freeing of slots
 in different memcg
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-7-17f5d1015428@tencent.com>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=2138;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YoaWnsRYGA8A2cEs47E+NMl/V2GjNEqDdJTVjYzFty8=;
 b=wj/6qOyQFBRTit1e7iKg9Wxj6FEpM7E7kz2L87NyATQVErv7WhyPAhQYL/Wj4Pcj+VE2iwp3l
 4oSUb0ynR6vCnDfMJOupRgYf8Xkijt82tPcuL3/ANXJ10HlJcuPBDCR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 501221C0004
X-Stat-Signature: q9arixhfeyyxhajzhboi99xwgiwfknp3
X-Rspam-User: 
X-HE-Tag: 1776364487-912558
X-HE-Meta: U2FsdGVkX19J25tfzjKrJyhkODnccGISryTZDTMgUY65GO0zY6YwXc80gHjh43dRBWmTx+L4UGckGtbHLSeK4VwHoSwvkDhbAa5W1VLZJMJeHfpP6r2Gvzj4GfiS7OBzotx0Dt6ULLcu7NWX4Ea3EnzxFvhQvmixsqQgBlDiJepVglk+1ZNYgml2uGcWXS6UYMp7VH4LxDc1xu9JXlkgFdxu6UVaftV0kyd4ZV8d3QwkMBZLdoT0ha9WU8jeF0xF2qfsaUcMTcaangjAg3/UA5fRslXeW8Awj5XBPKMsJVSCk9aBO2P++XNln6hcF6hDpivwyqJEJWU3rb3TzppTesvAFEWeEsjk1/aNrQRnWUBMWytBy5M5iiPbpO2s87w6qWmj3N+QvTgmLkU/5Q4oa08SYaaw40em1obs6WPB7RCIKdBtLZUB/VDhFAlQYph7e4cgw2EoJtdJs6qGKlX0j2Mv6ksq1XmTJbXDIzYlixxVBV9TattOTqqK3MoStZ3PcZuWXDtvHDEtjsZqD5LdRanscvo3JJ/kQrLlfIi2/H8vZ9ioAf2GRMkmJ9BixibGjGZ+cl/HjCibC5LuZc4P0Oi4QErQK3bZfNO6W1r2JmxsvqwxplGkj90jNtOZLCLbpCGWhoa5Cn59cQTE4yw+q4cPUdamlXo4+uKnN3bPPTK//PjK9TFYnOyEpa1EtnqZDmVhlgUi6TKJCehdhfgnX2VQoboZRCnnJkrfVkB4CcFuaepDhKTceGPavua0qtA1xcCLP4/eg8oiV7UgB6yCg/hoyleA2bbBD5vEnMkhONbsXBsRJY+c7z7hbmmwVW7p5UiAl8huGx0Ktf2NKwfYp148fWkesP9HkMarrMr5kJqMbPP3mUJXIpwEgeakqAclvF4NIu39f+Ynf3WkSBmP7x2uKodCqct+m6Oersi0n0jweB09YUOxC0+BTn86Vd69CMkNjcJVeNc/7w09tKA
 0H+T5JPp
 Aoa6o3qbhn0ClRTO0XuP/FsOBEEPdm3Bo9GIAFChbiHS7ZIVNni3HvmqEcRrpiqqGegmCfC8ux0xWWvl1LZqCOCJ1KxrTTpxoLNRuY7Ic7PVK6tx8BR7LNmS+8eR6sDYSkaESHMrGfCa8t350Q/F/PjeQ8xdPUROpbDvVsw4PSI2OSSDbuEz3F1vcgfdaTbCWQxE2N+RLmrBJN/qfltgDc68U0rCS7tZ+jE3t0WozAhbn1FgNw/1DP+kEnvVWuhvFq0v256CP555/91b8vjU+lpLopnZhctDzg8/4kF+gyRIuS+zUeeQ3++s1J6RLsDFyrcWuBnkAD58y+uy90ulJL6KBaOHxruFN/Vp+jMcVvV3B2ZGKPShZYIkUe3qSnDQc0pfP/J+67X9iVbpB+QGwT2jxwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of requiring the caller to ensure all slots are in the same
memcg, make the function handle different memcgs at once.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2211d290ae95..b0efae57b973 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1872,21 +1872,46 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
+	unsigned int type = si->type;
+	unsigned short id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long offset = cluster_offset(si, ci) + ci_start;
+	unsigned long offset = cluster_offset(si, ci);
+	unsigned int ci_batch = ci_off;
+	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		/* Release the last ref, or after swap cache is dropped */
+		/*
+		 * Freeing is done after release of the last swap count
+		 * ref, or after swap cache is dropped
+		 */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
+
+		/*
+		 * Uncharge swap slots by memcg in batches. Consecutive
+		 * slots with the same cgroup id are uncharged together.
+		 */
+		entry = swp_entry(type, offset + ci_off);
+		id_cur = lookup_swap_cgroup_id(entry);
+		if (id != id_cur) {
+			if (id)
+				mem_cgroup_uncharge_swap(swp_entry(type, offset + ci_batch),
+							 ci_off - ci_batch);
+			id = id_cur;
+			ci_batch = ci_off;
+		}
 	} while (++ci_off < ci_end);
 
-	mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
-	swap_range_free(si, offset, nr_pages);
+	if (id) {
+		mem_cgroup_uncharge_swap(swp_entry(type, offset + ci_batch),
+					 ci_off - ci_batch);
+	}
+
+	swap_range_free(si, offset + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)

-- 
2.53.0



