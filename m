Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A7DC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D216B0092; Fri,  7 Aug 2026 03:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE2D6B0093; Fri,  7 Aug 2026 03:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4636B0095; Fri,  7 Aug 2026 03:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C22A86B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:03:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04BB01A02B1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:02:59 +0000 (UTC)
X-FDA: 85073581320.06.A4A46CD
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id C54D140015
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:02:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prda60MS;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786086178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmnNnkKZaC6z/s8sNb+drFXBEauMY/l5sTUHuEf6x40=;
	b=lqx2Hp8iT1sNjQfMqUoCwl4OHDpxCot3abcGEu769/OM6S1Wez5i7JIyQMHn/D6XXjdt2A
	cqU+ZDmcmf/8Aw4krpw9X+vocAA/Dvw9DhmJIePkxFfjCgWtFSZssRnxlNoiTf68kOEjZ3
	0sGWYHpe+A/TNZ9kExxmDJX/KyzVIAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786086178;
	b=4Rhk+CG0+kdgWzwDcYDn9UtCq5SS1bXjmuJAStQizYnd++E2eMuqDUEEpR5SXcw146KkhB
	wN5CRf9Nw1gjrJUfsPZZXYJ/JBlp+aJifEau1hxzxiqvN9Gvc7vBRa4Q/Ng8gBGzy1bGVV
	N9BW4MR3gqODOxIrNpZDfXeAKFQF8JY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prda60MS;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmnNnkKZaC6z/s8sNb+drFXBEauMY/l5sTUHuEf6x40=;
	b=prda60MSdMi03FYQX8L+/loT6b5foyZ0pO1qiijpR9hAHQH6/pPFJMqcWbh5ya7u6Y045A
	H7jbnme9dtuLXAx9uGrtRM5C4ARU8ASnohlen1hhYCajk0I7wbX+74sr3PUVS/USXxyuz8
	6kl667qHNptBEFa/dZ7GJcAn8DOCR7g=
From: "Hui Zhu" <hui.zhu@linux.dev>
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
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 1/4] mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
Date: Fri,  7 Aug 2026 15:01:49 +0800
Message-ID: <5cd3efa9a4c614ba0b03cf4a3bd459dea67a9f61.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C54D140015
X-Stat-Signature: 7918uinifgkap8ozrbc4j4ctx5pcmbdk
X-Rspam-User: 
X-HE-Tag: 1786086177-563713
X-HE-Meta: U2FsdGVkX1/zs3KXgHi5RnSOq5TNdQ++BXCXlmmiuxoPpZJ5pOE3CX9MCYO/g/oInXgI0kqEFEG8f88zWJdL5P9NYstegYltKVOC8ZN9UbaB7fQxwOWoZ2YNGBgtPxJjd20rQVCHXnODB+OqYZYY+AZNtZJW26yaslOL7eCmsIrqRYtX6rygfXjI+5uH/Hmjb/wHQujHMCQjrgTvJnCXU9ZZgdnrBdjBTbfi4O2Ci4d+RtfsbpBYI9rxhN2WNJr0nDj3/xAvREYcdiMqcDf3Fr5SAykvLMa3f+wLaPlgCJLHQt4u+5uPXtG9Nh0KTC8iN6hKAlx2S1igQKXNoRix277icc2gLfkx6HdnABBItD55TABev1eEnQDC8ssk3Na8974mhwsfhmwUDjrCk4bBenNLSk4HetOsvEHL2xWscG5OasZZY1SX5ID4w8irHuuyioaHdznwVq1Mb/psXAU8W9j0ssBNj0p+B7Nlx5BaO21DD8HsAd7D28jFG1xDJEw4ntQGCpnU1JMH+iUpqFFzdfbwOa9e0kKaIUHCbVfN2si7b/nrxnWKYTRh7gJlY3QWOdaxIfoneQElRMUS6v0daCzaWFIuQpfE1vsAil8TxOLLXD0wZjM9GkpotnWwfGPPOoinYP/+eJdYRZlSeJPj59dQoZtxb6xExNhzf15QiNzXeVfXu8h5QGP3OfuVL7B0UxZpgCW27ZWillfmfaYn1peQUigqev3WgF5LeVzQC0ne1Ir0LPsv09LFpqcEAS9KiIShC/YZputHf8O/KZ95IeRhh5ymFBxFpj6BOyDx/t/9YaOwjAbJECCZnwJHQtBrKKVsIkiSWrH/hZHWaECpHpqk4mWnPivNJyKfEcWaaom4+AIV4GwSW7/YGgyEwV489eZEY4QcrYZ/r6d+GCim+5WiFJ3fX+JkavW321pDIH8DtOQ+yK5szfS35mHdbh07ulfPQahstJpsnLxDUjH
 1xwB7xcn
 MWVg8fnbU68daMgsMCRawzBZ4bi7WujX3jrhekymroAI9X1TqNw3q0Vfs12Z2AYqRQZ7zketMYKhomxCtRvE/tDP7/TEMwJf5XrhJ84brS4DcCGy47VQ55daCE9/McRIOuI6Sw/YLg2jJgKElwlVwK7s5LvbfWG6GxuCxI1S8lsp6BW1DF1bbCuF1CDH/vgucTcNEpmseMlFKHqQpJRHOM7TVT2oqDw9l9ochX5gUgd0F6n5ulpkP6R3vAya75nAGhVJb4Qxw88/Ht3ERYdXEPAZ39Q==
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
Values above SWAPPINESS_ANON_ONLY result in 0.

Note that the swappiness override is only respected by the core
reclaim path if the MEMCG_RECLAIM_PROACTIVE flag is set in
reclaim_options.

Swap usage during reclaim is gated on reclaim_options: swap is
considered only when MEMCG_RECLAIM_MAY_SWAP is set. Without this
flag, reclaim is restricted to file-backed pages regardless of the
swappiness value or the cgroup's swappiness setting.

Also include <linux/swap.h> for the swappiness macro definitions and
register the function with the KF_SLEEPABLE flag.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..3f7a5c97e135 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,61 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
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
+ *   The number of pages actually reclaimed on success, or 0
+ *   if @swappiness exceeds SWAPPINESS_ANON_ONLY.
+ */
+__bpf_kfunc unsigned long
+bpf_try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+				 unsigned long nr_pages,
+				 gfp_t gfp_mask,
+				 unsigned int reclaim_options,
+				 int swappiness)
+{
+	int *swapiness_ptr;
+
+	if (swappiness > SWAPPINESS_ANON_ONLY)
+		return 0;
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
@@ -172,6 +228,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_try_to_free_mem_cgroup_pages, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


