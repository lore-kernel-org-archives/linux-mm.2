Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E85CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28F06B0098; Mon, 25 May 2026 22:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFAC6B0099; Mon, 25 May 2026 22:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15F76B009B; Mon, 25 May 2026 22:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61866B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:25:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DFD51C013B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:25:46 +0000 (UTC)
X-FDA: 84807980292.20.05D812D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 560FD80003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:25:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o/QG/lw4";
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPt8FtuCxts2rIT8LYxYlii0QfD3k+uu3aBbt0C8m+w=;
	b=N5LMN0gRZpyH52E4aiu7kWQI+ncz6oM4eudGqTJYzU5Fq6rBWjDmvG1KSX3tWpJzzCJLQw
	xNws7YWGZz44ivEOu797QBMVxuGRI1SZxCuOoI4OAmiWpbtmz7QUlMrlzOSqb1fyc6v/8j
	RM/0BSvImxKSfeJCqC/ddZ0j1yn09aY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o/QG/lw4";
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762343; a=rsa-sha256;
	cv=none;
	b=tukH5a1peZse7labwcw7anlSt9n+T39tePaCzXV0kUX5czxILcouBPqJhRZNq1SqQ4h9cv
	V7aXb+H0qYkLO4ZYuZnLcdV2nWbAB+K8X7bUOJ1dLUJxh/NYwR71b1S4yiG6QU/VqUTOyP
	EvkIjIbShPneKGkVF5jeAg8lA/Ucx+w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPt8FtuCxts2rIT8LYxYlii0QfD3k+uu3aBbt0C8m+w=;
	b=o/QG/lw4IOwQFCUm2A4fnOGTcp+vWpVJ60NU5X0Gvezz8ozDsWYZrgcuzcv03ZqfCU2qTL
	M3iUvaqT4i/xAb93I9pkkdTfnXLSapL2BROqTcHinjolD1mvo89anYgM8mLuwe5rZpZAMK
	2GXMFd35Gsz3WpGtAk2tGr4XzzK8I4A=
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,
	baohua@kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH bpf-next v7 07/11] mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
Date: Tue, 26 May 2026 10:24:55 +0800
Message-ID: <13b10d91aff4307580d1a601f1592efe42a92b05.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bxfprw7ppf69u5rdgokzwkixfgk4ar7o
X-Rspamd-Queue-Id: 560FD80003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779762343-329987
X-HE-Meta: U2FsdGVkX1/v+OLJljEGwlj6zA2KMHIluuTU3Etab9pR8Dr00il2Vbe0p+Ul5kLDhtSMa14VHMcxJbXNAaJ3tvfF/Gny+YjfSkjqcdH/RAMqcQ7Juu/rZsVpFBhltvbAbmIrXpgRSXNqi2aBbGN0W98L80OC/hMJr47lzjDbeoLOSh/CNmW7gVpt5DZzqCEbmcPY30p6Che6qK1G8pko0+eR8T4UtZNZwsDAGYctRk2TzhJPVcRGSvemqa3bf+CMhi162BHM2BYWuSmdrMVfq7nlgUpDg1mfk05ostzir1KthBnYOV8wan75UkcwoHX+cvOAu4RObxQ0tY4l6wT0YABkdk4PhkVkpRDUZzVfhgxKJCkHpB2hCtgQzViOkRBNrzbnyc4bA3BGeCTQ18es0C9SwdGriLfTlb++9oaeQL/F+aSMFsqI2l761WnHf9pXj6bTIIumh7yGNql/xCQKlgYPOAMDL8TGK155v49HBvXLWIeh0ZXfjf82rKnzJRzrfcOQ87tleo0CHj5+ZYhKR6+pczKYtWFNrQ6vcaCUcjXspiIiF8+JJsiIc2nFp8Ek51tRVucci/U/RJb9ZrDY2I95XD1eIZOuRWumemWjnQ2ULs5Ug43iZWITNRliCxkvtcxn+rdvpgNsZsJ2PcYrF13WN5K3NSB7YUxta+CYz9KK0Q7eP+KpwRP+u3keBCximZxET+AX281v3/x9Iqa9OWkUl0JTEucUZ7rhxx7bdGbl6N9G59oDib25Tuly+jTFXwo0fgthNmIK/C9gJcSYuFPKbCt7LpQPRSA56W3RsKVJSfyROKJCSLDkkhGx06wTKL/Q0afv2qR9KlWKWsd54M4wb9YjuyDCZaUFjdcDK4Pv8P0PUMuV5p7SPpgJCcRw/n4KaT8nXe8aIZH8GcA2ELIijWdZ/GOOIsbGl+axl7gYBqcppW61NncJOjjBMcyBt+2bRgQRxUPARjAO9YX
 RlPRiq9e
 htrH2MMh606BL9718w54XG6zXCDd1p6ZZLVrqosq7KUiYVm/ottV59tRyb3AQv5Xh12d3tah0SMniQodJYV1qoR9bkLZDa+KE60K2Bk+/MsSRX/7ksAaaXF2FmWWEuytPM/4dn0bKUzka0iUdRTdcTTWqRWoMBUt032BmgJfr7DSmqebDhcvQrV131zJ8oxnjzE7r2ICdw90mqcj21bGC0OtWDnnGcZGvOvyHodtqfouEclOeyc6NAQ8fC3OOGcPBBfSGw1ePACKF2LrHgca6YR4dMxteu1lwZBgi+qroDRWulfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Expose the memory cgroup reclaim interface to BPF programs by adding
the bpf_try_to_free_mem_cgroup_pages kfunc. This allows BPF to
trigger memory reclamation for a specific cgroup.

The kfunc wraps try_to_free_mem_cgroup_pages and introduces a
swappiness parameter with the following semantics:
Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed through
as an explicit swappiness override.
Values below MIN_SWAPPINESS indicate the use of the system default
(passed as NULL to the core reclaim path).
Values above SWAPPINESS_ANON_ONLY are rejected as invalid (-EINVAL).

Note that the swappiness override is only respected by the core
reclaim path if the MEMCG_RECLAIM_PROACTIVE flag is set in
reclaim_options.

Swap usage during reclaim is gated on reclaim_options: swap is
considered only when MEMCG_RECLAIM_MAY_SWAP is set. Without this
flag, reclaim is restricted to file-backed pages regardless of the
swappiness value or the cgroup's swappiness setting.

Also include <linux/swap.h> for the swappiness macro definitions and
register the function with the KF_SLEEPABLE flag.

Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 57 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 1f726a7b22e3..0353c8736aa5 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 /* Protects memcg->bpf_ops pointer for read and write. */
@@ -162,6 +163,60 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_try_to_free_mem_cgroup_pages - attempt to reclaim pages from
+ *                                    a memory cgroup
+ * @memcg:           the target memory cgroup to reclaim from
+ * @nr_pages:        the number of pages to reclaim
+ * @gfp_mask:        GFP flags controlling the reclaim behavior
+ * @reclaim_options: bitmask of MEMCG_RECLAIM_* flags to tune
+ *                   reclaim strategy
+ * @swappiness:      swappiness override value, or a sentinel to use
+ *                   the default
+ *
+ * BPF-facing wrapper around try_to_free_mem_cgroup_pages() that
+ * validates and translates the @swappiness argument before
+ * delegating to the core reclaim path.
+ *
+ * The @swappiness parameter follows these semantics:
+ *   - Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed
+ *     through as an explicit swappiness override.
+ *   - Values below MIN_SWAPPINESS are treated as "use the system
+ *     default"; the override pointer is set to NULL and the cgroup's
+ *     own swappiness setting takes effect.
+ *   - Values above SWAPPINESS_ANON_ONLY are rejected as invalid.
+ *   - If @reclaim_options does not include MEMCG_RECLAIM_PROACTIVE,
+ *     the @swappiness override is ignored entirely by the core
+ *     reclaim path and the system default is used regardless.
+ *
+ * Swap usage during reclaim is gated on @reclaim_options: swap is
+ * considered only when MEMCG_RECLAIM_MAY_SWAP is set.  Without this
+ * flag, reclaim is restricted to file-backed pages regardless of the
+ * @swappiness value or the cgroup's swappiness setting.
+ *
+ * Return:
+ *   The number of pages actually reclaimed on success, or -%EINVAL
+ *   if @swappiness exceeds SWAPPINESS_ANON_ONLY.
+ */
+unsigned long bpf_try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					       unsigned long nr_pages,
+					       gfp_t gfp_mask,
+					       unsigned int reclaim_options,
+					       int swappiness)
+{
+	int *swapiness_ptr;
+
+	if (swappiness > SWAPPINESS_ANON_ONLY)
+		return -EINVAL;
+	else if (swappiness < MIN_SWAPPINESS)
+		swapiness_ptr = NULL;
+	else
+		swapiness_ptr = &swappiness;
+
+	return try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask,
+					    reclaim_options, swapiness_ptr);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -175,6 +230,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_try_to_free_mem_cgroup_pages, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.43.0


