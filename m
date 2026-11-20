Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BBF6076C62
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EZ+BJsQO
Received: by kanga.kvack.org (Postfix)
	id D7F9D6B05D3; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F2E6B05D4; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFB76B05D5; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7E36B05D3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C431A014B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:30 +0000 (UTC)
X-FDA: 85456287420.23.6B8F7A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F15E21C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZ+BJsQO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198228;
	b=jq0M3DEsS7d1qaNJKEsHA2hqBX7qMKVft1v3k2LWIIknONctmx1HsK0J1Pfk/S7eM2owq/
	E5qCByDaXyclCIuqnWNPtBgvFtr2vRiFst+EvfwB+ZkvqL28s4H/UGxuBAqR4zJzl8/X+W
	knCReV8uwxQC1RBRt7TQyGYSkltbvZ4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oqtpwJ0c+t+dUEI4XWL1X7l7l029xmqIZkf4A3gkKY=;
	b=nB7TII9MzgsfSMjkH3ZuBjYcZTUOjCXp1EXpmF3/kogbUXsILSivkj/4nh54bQQ+LIH3dQ
	V4dVp5febQ7Be+sUgdh5aL/vJgN1k6Qtz3zgMqSMOaHEVDQE03AfyMhf+qp+nRzoGGUuuX
	KnFkCf2bZH6Z7S5+5DS0n9+Rlj8bIc8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZ+BJsQO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4379B44D17;
	Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198227;
	b=TjqmID7E4iOKwAhSKxv/6OLZS5NVKVTLojCnxN+O8B4QzETPI03/3pcfbou7PMwP4ZOF
	 ursLh4R9xLszP+TsSEXDVeznDM+8ZpoQ0UVYNIomtKw4Nyj8IO8wDgQ7gdzXkoBv9fGv+
	 l5/B5vI9IbfgBL6XqcDBfcX9u7TmOPGuK6Kjtda8hno8KnuaYqyb5CKkfve1sAvpFHdwE
	 PbqsE0dy+oPZ/PNxO5z/Uuv5eJUQ8DTL/EFBlBTgtK+Unbhc7oRrqsYo2f0Xbn3Ze2LpE
	 mSb0QsqxVqn6UsNVg4/cV7OXO5fWyt7RJngVX+KT0XprOa6FgpL5oJ0L8eH00lbhRYA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198227;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6oqtpwJ0c+t+dUEI4XWL1X7l7l029xmqIZkf4A3gkKY=;
	b=IsCke32otQVPrYLrX3wiDCZXsCs5U11MVYsk4RJ+lCD55XsTk3aXRdXoBvQtiKISyipA
	 6lDh+sNuSwqs3uuPFXSzlzaY/gg3BtWow+ncIVwR1ya2Wsn/ie/5bOiLOeWyNkeQ532Mn
	 UsRNQirEOSpB6tbU9Pim0lJwyi982oziWKfBafa6ca/di+rtA0OraXUn3xjWp9ayK78iy
	 chCAEtf6mMwqcqYnWJNKTppVCt5oa0J5l3euhwOuKKJAaQ+VP+SwswpF5kdBDAwTTPzCO
	 JQBZ0THqp+Urt8ipb01IASaFpbA5JsyNXuvGEqSlB3Oh3ag3QCy1ED+ZThf+qRHhg/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4F2701F0156B;
	Fri, 20 Nov 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198227;
	bh=6oqtpwJ0c+t+dUEI4XWL1X7l7l029xmqIZkf4A3gkKY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EZ+BJsQOJ0p7U6Rk24X4g6PSNads//EDAyMPSdo+YdmyY5nIaJ3b1CyzHotUeAvWG
	 RLBryL0KbQ0ekPHEIM3kEPGM9j0BYGhYQDdzcztU+rz4BBSlPoIb7hXqyp64Udpb+k
	 L7l1+17WvIkQ2HXaPTnj7Y8gbaip3y6bVtW3Ke09EkxLT38+HbIOGY3OOtn2bAPGEz
	 H+jZmAqnhYYGwEoLOG2A8msZZE7hn9DX28d+VKvGsbphFQKNPinkeHL79toR/ZNaZ4
	 Bf58Ufin0FgWkQMysTEXABk/HyDy+DbOHMafSMD8WO6sDkJYQ7VNqHlQzhZV8zQ5i1
	 pDmk/o20eBbJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 44F6B4B92D;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:18 -0500
Subject: [PATCH 27/60] mm: add the private-memory node state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-27-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=5643;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=zId/m3UcEeKPlrHjDuBTph6SlMWMgHfNTv0FPlTy5jk=;
 b=UQPuu0+30xBC00mgn1hSzuDWDMkKDN3WxupMdh1ZgoT3kBVxhLL5UdV2Q7T1tbGBb8aBZhTom
 a2I0WisarbDDWUsD2+k6+bL9x+5sPTZQCfJRGG2SOn1nC/Y+GahAoYl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F15E21C0002
X-Stat-Signature: aqmjdi17hjopttj77ffg1db3ifk3owt1
X-HE-Tag: 1795198227-11925
X-HE-Meta: U2FsdGVkX1/+W8lqzIhUsxHatg8X+m0RcS98TopvqVZOQjKyCtMLbOmOfO5rIrYlIxkVobW2uJQy2hLMgvNXwPq2AH4Qs9IgwIvJ6iVX6lCuUufiSsJvzORDgSeWm4VWn1sab2l/zHo2Hp3jJULX6MtP3ezbhrspa7AI9aAsY+Avbh5slhYuZOcer0OmnHpizggzty+jZK1vcs+GVnDXjzAjHK+X73SgNZlwsNn6rX9rOaW1MNMNi69yTFWme9+hOCF51ZtHw8NJQuIXW6RNeJRO/p8Tws0hOdZPKS24nhd3BCuG7Uz2u+TY5G4MPMen/E0i9kOkW7laKL8j0CzVDs93m39caUAz5SLy9Li3mHvlx+SEocACFak/HH4IbooRJRiuFr1OVhtAouO59/RoKFMQznS5/RS8tvFz3iUMMGz9UbdfxkbDUD3rI6515JY1lhYPKG8weQMKweqK2TnzoW7PkUkNYO9G/z6aIMZAzHFpv1A4NVC+0B8h1XlVwEuFsxFA3vG++crP0W0S9UdHdKUlRfVM6m3xR/9atppZXN+0ILAAdVGHt7SjZAliFDRqfIi9E0dStS8oiXcwZtxgmJgmQJO4e/tvCntC/PXgUIAZVvNggC3BTazHu81vC7CXZhOVeek8EcMPfh5G+t3d3hTdfjw+AZ5VpVcVZ4O+mr3DE3n0JJb7w87zztmjepzQ1akgwIcRVbqpYb7perH2fMBkKZ/+37JeRFzjwnjaBzXVudAXiCxUnQiV3u5soJSePeh6x1U6Szfw00UPrmvOtSZfXMO6wtuQwejtk4bCex/umIysbiNEgzgqjRB9iIdolouoSo/zIugAF/tAJ6LFl1dmWL+tM1ttpo9QFovPmg8URx7tQSDOxDCfJnzC1eHPDRZJtFsFf5A9Y6taqHKCtVzGeMciVGbwsOUzmrUQzc2e4UP7ldBzYoqLulxPxR5E+FB6RTk5sh35r+uhd2i
 shPU73HJ
 wfhYmic43EI1w8erzdn3guZuhEh7AAJKRjzLUIcmBZeabj0XSzXxZyTEpSbGfflQ6ZMVGm1FbUPAuItUGo427tlIhFPfMeDOzDm4RMiZlFVK5gqPc5wdmB6NK/O4v1rSokc9YK3Ng8bmrBne5qS9WqgF0a2Qafs+4fSpMDmA+dTDe2k8mbxxOFcwEGNVi7SagdLCn4zkvAFskpHBn+3XmoayHGBtkopeyoLcajTr8h88gN0TiegN/dQ0FA7s6aRRFziwbkp8PDB7+Xr/Psp9ZcOIRvWf5mqiO55G40hpieo5eKp8yJNfacgpYTlIYL6jjMBOaUNqidFrfLzsdmQ31jmJbM87ePgDToWIxPUzLrDrrqcyEJzD+zRXoAivO03QCk9pPc6srq6zC4NGQdIipw9o9GjmEUjfiq9t3g5k101cz8ktsw9Inv9LwLh/P8qdMhSLtFjF376x3yTttvrsR+A3PhjPxvLDRplT+UK1eCOSvrlPLVl8xLoOf/ThBYGeygRSRrdF6avZw0ftBNIgnG4Zk1WryQL26Pk/Knw/PALOk1j7nvqcS9o/QHRTXAUlpiiw+MzvEzkgPLh3FoXsCQ/aUkjj9pKS7WG5NpIuVjFmtEyZAvmcNHS9ZukjHJE2/Yyr/ETPE+eEz3/ngJTek5L6krLYaCANOf7vloBnFvFaEPNnmcMh+xOOvolkqq1GV8Qou4/guuoSw8a4elgDzcn/pYia9rXlBZ1sTmam1lI3ohgyAXmFXqoSvG3TqDa4Yzj5VaDlOa/ary/kD41VonxyaD9iUGpNwHn1PNqiEfrNkqTAqscXi2k9DLpVgtgYMkymsL7kNBJlAJSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY_COMMON describes memory that ordinary allocations and MM
services may use. Some memory is online but is not part of that pool.

Add N_MEMORY_PRIVATE for nodes with such memory.

N_MEMORY_COMMON and N_MEMORY_PRIVATE partition N_MEMORY, so a caller can
drop private nodes from a mask without also dropping memoryless nodes.

Expose the state via `has_private_memory`.

Without CONFIG_NUMA, node 0 holds all memory and none of it is private.
We have to adjust the node_state check to return false for this node,
previously when CONFIG_NUMA was disabled it would always return true.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/ABI/stable/sysfs-devices-node | 10 ++++++++++
 Documentation/mm/physical_memory.rst        |  3 +++
 drivers/base/node.c                         |  2 ++
 include/linux/nodemask.h                    | 12 ++++++++----
 mm/page_alloc.c                             |  1 +
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 0a2cf3088233..70ab780c6ddf 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -46,6 +46,16 @@ Description:
 		requesting the node explicitly, and that kernel memory
 		management services manage.
 
+What:		/sys/devices/system/node/has_private_memory
+Date:		November 2026
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodelist of the memory nodes absent from has_common_memory.
+		Together the two lists partition has_memory.
+
+		Ordinary allocations do not use memory on a node listed here.
+		See Documentation/mm/numa_private_nodes.rst.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 86a7d6080535..ddba7c890418 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -174,6 +174,9 @@ nodes with particular properties as defined by ``enum node_states``:
 ``N_MEMORY_COMMON``
   Ordinary allocations and memory management services may use the node's
   memory.
+``N_MEMORY_PRIVATE``
+  The node has memory but is not on the fallback zonelists. Together with
+  ``N_MEMORY_COMMON`` it partitions ``N_MEMORY``.
 ``N_CPU``
   The node has one or more CPUs
 ``N_GENERIC_INITIATOR``
diff --git a/drivers/base/node.c b/drivers/base/node.c
index cc6696d1390f..56a1741a6a45 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -966,6 +966,7 @@ static struct node_attr node_state_attr[] = {
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
 	[N_MEMORY_COMMON] = _NODE_ATTR(has_common_memory, N_MEMORY_COMMON),
+	[N_MEMORY_PRIVATE] = _NODE_ATTR(has_private_memory, N_MEMORY_PRIVATE),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
@@ -980,6 +981,7 @@ static struct attribute *node_state_attrs[] = {
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
 	&node_state_attr[N_MEMORY_COMMON].attr.attr,
+	&node_state_attr[N_MEMORY_PRIVATE].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index c3b984105bd1..5a9722d57701 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -403,9 +403,12 @@ enum node_states {
 	 * to manage per-node meta-data and topology decisions.
 	 * N_MEMORY_COMMON indicates whether the node can satisfy arbitrary
 	 * allocations and whether a service should manage that node's folios.
+	 * N_MEMORY_PRIVATE holds the other memory nodes: together the two
+	 * partition N_MEMORY.
 	 */
 	N_MEMORY,		/* the node has memory */
 	N_MEMORY_COMMON,	/* common pool (fallback zonelist) */
+	N_MEMORY_PRIVATE,	/* memory outside the common pool */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
@@ -478,9 +481,10 @@ static __always_inline void node_set_offline(int nid)
 
 #else
 
+/* Node 0 holds all memory, and none of it is private. */
 static __always_inline int node_state(int node, enum node_states state)
 {
-	return node == 0;
+	return node == 0 && state != N_MEMORY_PRIVATE;
 }
 
 static __always_inline void node_set_state(int node, enum node_states state)
@@ -493,13 +497,13 @@ static __always_inline void node_clear_state(int node, enum node_states state)
 
 static __always_inline int num_node_state(enum node_states state)
 {
-	return 1;
+	return state != N_MEMORY_PRIVATE;
 }
 
 #define for_each_node_state(node, __state) \
-	for ( (node) = 0; (node) == 0; (node) = 1)
+	for ((node) = 0; (node) == 0 && (__state) != N_MEMORY_PRIVATE; (node) = 1)
 
-#define first_node_state(state)	0
+#define first_node_state(state)	((state) == N_MEMORY_PRIVATE ? MAX_NUMNODES : 0)
 static __always_inline unsigned int next_node_state(int nid, enum node_states state)
 {
 	return MAX_NUMNODES;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1ec7d8000792..50336eb58edf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -217,6 +217,7 @@ void __meminit node_set_memory_state(int nid)
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_PRIVATE);
 	node_clear_state(nid, N_MEMORY_COMMON);
 	node_clear_state(nid, N_MEMORY);
 }

-- 
2.56.1



