Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090EACD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983A46B0088; Wed, 17 Jun 2026 16:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BD76B008A; Wed, 17 Jun 2026 16:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D136B008C; Wed, 17 Jun 2026 16:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562A86B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:22:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB9B11665F3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:22:15 +0000 (UTC)
X-FDA: 84890526630.20.84F983D
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6DC7C1C000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:22:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=amAb0OIv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781727734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bFbB1BtfczxDB+uTNT4qTGVZYo6BQXoVhZaGmDWFja4=;
	b=QhWM4VTeFTe+F3vrQy5aPVKtrop87jsFSDV529JRGpeUIJB2TCG2JX/Rs+xgJreOg2qCoc
	WOjY3s6wzUmmopjhjH3TrEXlnyTu2j905JmDy4xTZV3FrYHdjNoru7BEEuK0IyvaZ6iG6F
	mweSRSAf3M5XiTweOpjfs39orurRZyA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=amAb0OIv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781727734;
	b=6NWfuahPv79RQ2LbHZ5AG2t5aP8ySGNnwfE292N/N2/07K9ueYdfteFZ3D1G/d20HGQ8jm
	0H92x5ZdumBSifJldkGooNeVQaZEGRKSj5CKBf8hDxO+gJg28huc3RNLqT8FWOY1xbPsDu
	e0Ma+l5Rv6cY6ZRA9b+fjnRsy8AKMHg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781727730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bFbB1BtfczxDB+uTNT4qTGVZYo6BQXoVhZaGmDWFja4=;
	b=amAb0OIvInfXWf4o2w+HJ/T068r7UoZcCTSudJaDxT5hZfiBMINHEYeQ8cAqMRg3iJKM/E
	RT36vA4HAan0H+wug1L0XuHSxyIWCiM8cq/56X//0l5pyUgMGRNAOS958zWEEj188Xe0Lz
	Ee4BduE0YQNFbT45bLzYHlcaEh4+K3M=
From: JP Kobryn <jp.kobryn@linux.dev>
To: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/bpf_memcontrol: mark BPF memcg kfuncs static
Date: Wed, 17 Jun 2026 13:21:47 -0700
Message-ID: <20260617202147.78347-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6DC7C1C000C
X-Stat-Signature: iz3wz7wp31t4qgixo6h1gsxtqh8z57pb
X-HE-Tag: 1781727733-473702
X-HE-Meta: U2FsdGVkX18bFgkR16c6YecjCa2D549i1iYup3R1pAWpD/KJHx9IXj3uMo90bqISPSw8HKGjKNeDKJ+Tj/qB8+8WFNxQPRAn9o9py3hnpQ5tmbNOhCBVqVgppL7NUeLVlIkidKcW09Z/EGs5aybv1/GDCK0A0InoYUtlW2IP8DDHoKPBezOjp12+pJbfPL1nQV0sKkzWJ09ewCE1NPcUxxZ55wAJhMlUseb87gg0EbU8N6L4WCjCkycVmYZ2/+iIx1Qy9ZpzpTEdjmrc2NgZ8gqqcNfkkR8QkYzwWFRIxUapM7xMPKNFZVEFhxsLzB8RA5xa4mWgljxFzrOEk67UAJ6+X4gUAg4KJQy2JAb6DwfCSUMfvJvCmTHj2M1tCQ9EMfkh/Mh4OQpNBG7xr97jymGSnIkc4qrAs2SwSZLDLxDxqtgFd/Kc73fSqk+z45Eouyd1y/GgxDWPlk2GlHMtsLfGE1MnifRNjpnROhQdURNub/+JP9EAmKnvYPSoQYTb+Pbp1znQUkM6wB9zwvrTPAYm1o+OcsKR4splc5hzd5mumRI6C9jDxgdSCEuDJxOvWf4vZIA0d+xiyZ44r1+lTT1HCGciS8okchDRu1y7uRMvsZhenEhlXcKrWELU0RW4DtQ5Xo/l96iwilHQDl03ctfp06TdArDGZ7DWFsyXc1bhFcQRDIFz16ZErGLhP9g+dM1yfEQfKTGrotUaznP8dkHHr/YD6vOJK8umx+WEN8BEamoWY3R69kLXLS/+AVTjkAzv9btGN/8w4fI7PmMFx0/76Ca36ylanE3mPcGXIKrfjXQEDhFQmcGzq5MjKLdL8N/W1NVrAgkgnd80Pg6thCYnTawlpp09qw8zy7jeszx4oOOgDLQVjqdUrKq0Y2kuqsN0Va27WUfAVSNNZflw1yatQLEC4ZVNnl2Q0S1XvDWmg3KYMZJ6OI/CgNcDHrev3PijUBIevY7vOZauYu2
 9teDrxeC
 eUuhDmN/onTy0yud5muYiIsHnPfqpUdmloF7ZDj1HW7UY/kvZhCKvfJY1uCzKk1YtrCL+pcmh5p3ZSWsPIv+pjuajFo8T8mUsdkRYtx1UoDOUH2NO7/iXV+H2O/dwJ5qmsJWBh6cIcmkYi7qrzmACPC7VCedAw6NPOuJLJ4mBDB7qDb+rnRydkk9szw4PCgeeVLwbtQBu32D9NXhwOy/EQ+uP4VzNnyw96IrxTwD7XTrF16RlD0nRzUc2nNZkZ4466Sibnp0BzbkUPZ+9OKf7gM6PHuUwUy0XGKmT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kfuncs in bpf_memcontrol.c are not called by in-kernel C code. They are
only referenced by BPF programs and resolved through BTF.

Since no external linkage is needed, mark these functions static.

Fixes: 5904db9891f8 ("mm: introduce BPF kfuncs to deal with memcg pointers")
Fixes: 5c7db3239c9f ("mm: introduce bpf_get_root_mem_cgroup() BPF kfunc")
Fixes: 99430ab8b804 ("mm: introduce BPF kfuncs to access memcg statistics and events")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606150332.Xy4Egd9s-lkp@intel.com/
Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
 mm/bpf_memcontrol.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..eff79bb2c758 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -20,7 +20,7 @@ __bpf_kfunc_start_defs();
  *
  * Return: A pointer to the root memory cgroup.
  */
-__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+__bpf_kfunc static struct mem_cgroup *bpf_get_root_mem_cgroup(void)
 {
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -41,7 +41,7 @@ __bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
  * Return: A pointer to a mem_cgroup structure after bumping
  * the corresponding css's reference counter.
  */
-__bpf_kfunc struct mem_cgroup *
+__bpf_kfunc static struct mem_cgroup *
 bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = NULL;
@@ -75,7 +75,7 @@ bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
  * Releases a previously acquired memcg reference.
  * Implements KF_RELEASE semantics.
  */
-__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
+__bpf_kfunc static void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 {
 	css_put(&memcg->css);
 }
@@ -89,8 +89,8 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
  *
  * Return: The current value of the corresponding events counter.
  */
-__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
-						   enum vm_event_item event)
+__bpf_kfunc static unsigned long
+bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg, enum vm_event_item event)
 {
 	if (unlikely(!memcg_vm_event_item_valid(event)))
 		return (unsigned long)-1;
@@ -110,7 +110,7 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
  *
  * Return: The current memory cgroup size in bytes.
  */
-__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
+__bpf_kfunc static unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
 {
 	return page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
@@ -122,8 +122,8 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
  *
  * Return: The current value of the memory event counter.
  */
-__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
-						       enum memcg_memory_event event)
+__bpf_kfunc static unsigned long
+bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg, enum memcg_memory_event event)
 {
 	if (unlikely(event >= MEMCG_NR_MEMORY_EVENTS))
 		return (unsigned long)-1;
@@ -140,7 +140,8 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
  *
  * Return: The value of the page state counter in bytes.
  */
-__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
+__bpf_kfunc static unsigned long
+bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
 {
 	if (unlikely(!memcg_stat_item_valid(idx)))
 		return (unsigned long)-1;
@@ -154,7 +155,7 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
  *
  * Propagate memory cgroup's statistics up the cgroup tree.
  */
-__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
+__bpf_kfunc static void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 	mem_cgroup_flush_stats(memcg);
 }
-- 
2.54.0


