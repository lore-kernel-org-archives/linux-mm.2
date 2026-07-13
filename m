Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF26FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BA86B008C; Mon, 13 Jul 2026 05:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C4F6B0092; Mon, 13 Jul 2026 05:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A696B0093; Mon, 13 Jul 2026 05:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFB9E6B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:04:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B16AC6C99
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:04:16 +0000 (UTC)
X-FDA: 84983166912.05.4ABB1DE
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A2E880003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:04:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tH/Ef7uL";
	spf=pass (imf30.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933454;
	b=z/mGSLoRXPqBRKd4DsT4jjkPpm3tjtNnXelZJMcV1ucDVJJIyoO6Oou+/d4drhH96Iq9mI
	xyrvW/wmJpx15vQGMMFs+KbY3fiWvni6EYlUJ+s4DGbZT7M7B3CDFSu0PBXMSzeDRoPovM
	rWA6AWmK8doRqCjozoEOKhPyoXB8amE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tH/Ef7uL";
	spf=pass (imf30.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k7pIu+GwSXbzd7/h5Hc0V60GatPWQdzqkR6KAvscHwA=;
	b=5notSzeOnvmptKaLZgiRB8OfxUTummfhCwZvWWUPFPhxjbwyK42M8bGDel9wOPJd7XVebd
	hno21tadBzjUGPcN1IapDKVg5nRNdtJE+P4Q9doLcj19WBoN6aJ5NiIiOV/AzW8I0mdSQR
	EZuPqvB/io9kCr1ZYcs5BAGz2v7gv9A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783933452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k7pIu+GwSXbzd7/h5Hc0V60GatPWQdzqkR6KAvscHwA=;
	b=tH/Ef7uL2uQAR1yPyzTDywxVIArHSl57v4dm2Q6ALV5SZ5oXVIHfNp+APaWF6gi1T021Cp
	slFXbFki6xLEv8Zlor9TSgiLNN0HlPy5F5xZoDml750bS4Cjvdq3Oo//JEF+CJuM7vhKn8
	EHDmyGPGpCLjJMTuL4bXJp5DCd2KqAQ=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
Date: Mon, 13 Jul 2026 17:03:04 +0800
Message-ID: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A2E880003
X-Stat-Signature: 89pxgnfgwx8mcxerxgahczop5ugc3coc
X-HE-Tag: 1783933454-440509
X-HE-Meta: U2FsdGVkX19QnpqrJs0q2Z+bqIrkmZXHpkgAybFzsq1SIgRM67DDWWZD3U11K2g4Pzu+1/DnuUp5y6ONjZ1I2fIdSd5Pu11C8rEQUMha9LF5inFfhPKmEHsUA1KZk7qydufaTFrwCeHeQd8vVtm041K+XqiCPoyDpBjDWpel1VTDZZCaERuGD4RT/1oNSkAF0CZ7qlvZRiNGuXpd6ujrclfvtLM0Iz70B2LS81r4HXOGgLk5YZJBJE1/d+MtRNs5g0DqhzQ7AjP2FXLp6NRn8Hp92EwUDBiqUE2EfYeOMUUlafiiKEAhOKfbdXk3mD7P/3u/+U7Z+RnFgxLpk1nD0WVa9voHObFVhzfFAYE2TsKYB6yL9g2mhe3m9utLEHTBXn3idx7L5Pl+aiM9Tht/PRmZjHWJ+j5JENJwWcfRP/QkQubQs4uUxl1wy5xW/cuoiNLCyUoFTy4JC25x11L1BjJSrwW8tmAPFImZYQTTzd1anb0+DgFANErqoZ2F/TQWT6vDFYTvlRpiuFYHrja0MZZhX8xL7Gs8JiFk03G+n8z2JGmQTU/K69WqGw1uz6qYqrVQtM1+mlAKcxgThfNGVaphZyPPQ6jvN8vDsa41ybb9zgwsfvUuZd7DqHRnNLgaBOcU7MF7fkSVAdfAfh6FQmiIBf8tqhSYZiBJBfyB2ItFi4Jl1iBDyMoIv0yPZZF4uWdVsW3WclMBVVydgKmD3p2nRbyrVuMEAZq6wqFvfX7SYKXlUX56kODd3oyp/OBzsz3evQ50OrTGIUdvTte1k4Bb4ULD+pTrL2ExZFatYKuEBFNNMbyVyCf1J8O+UxdXmphDNRXQnCZfE5AwEQQJ3fr20nh3RBHV4T8Az6llHhNZYtlBkNlNxOn6HYX6feyOgXuruPvx1dbbwo0LuLs1aNcW9ou8JzA0FbAxAKm/374/Vxcb2qQq5YQJ8npPmNK2olvl8c08IiHl+CsEvEX
 sbcr1Imp
 2SFD9lYRD3wxjsvSHZFnWufC5vKHN4AtDzp8DONvhUkh1z8ssmJk6ezT891/KdXnOwAxnawbVX8pB7nY0MUke6LMQd/FzQsctg4DQoLjCCHe6pg1RqkSavsB9p2dDeQFypyAJiEoo+iezudvSbOhuAaqtMBT8UuWCBWxXZB85RMkHj2gvnLD8ow7qiMOJL7Yb2K/+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
small memcg_uncharge_kmem() helper. The reference get/put stays at the
call sites, as they differ.

No functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22f55aeb94f3..86acfe55a201 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -137,6 +137,14 @@ bool mem_cgroup_kmem_disabled(void)
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
+static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	memcg1_account_kmem(memcg, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		memcg_uncharge(memcg, nr_pages);
+}
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -172,10 +180,7 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 		struct mem_cgroup *memcg;
 
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-		memcg1_account_kmem(memcg, -nr_pages);
-		if (!mem_cgroup_is_root(memcg))
-			memcg_uncharge(memcg, nr_pages);
+		memcg_uncharge_kmem(memcg, nr_pages);
 		mem_cgroup_put(memcg);
 	}
 
@@ -3329,10 +3334,7 @@ static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-			memcg1_account_kmem(memcg, -nr_pages);
-			if (!mem_cgroup_is_root(memcg))
-				memcg_uncharge(memcg, nr_pages);
+			memcg_uncharge_kmem(memcg, nr_pages);
 
 			css_put(&memcg->css);
 		}
-- 
2.43.0


