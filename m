Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3BC606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIhLCGZt
Received: by kanga.kvack.org (Postfix)
	id 24CE36B05BA; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6146B05BE; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB406B05BA; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91736B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:59:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B3ECA0563
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:12 +0000 (UTC)
X-FDA: 85396988544.13.C7B97D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 64E2A14000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIhLCGZt;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786350;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	b=WQVyLLxpOR+RTphN79dReyrIRrvIwhVjVMwvn1saDzmnGbm3bHXXbKjREk3YPQ7fU76VdC
	59+LX2DS6tWI/noPgLE66YlQGah7uIRZ74OEf2zzUIxqqupKTcNXaV2bfCl/UofOxzqJkH
	RnULlyqY1ToduvUP7WJPH7+edpwFnWY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793786350;
	b=Z3osP0Hcl0s61qba/1pJKohxuF7TakNwKEKhELHVUvMFokSfOkcCx9VdswldGo33jeMA6v
	tF9gMtA+i11heUkH+zdNU+YvcfWPDNF+2oA3s5qFG5Tj4U/0hik6YQ9Ks2g9czzhvxZR+L
	9HueZTbVtIzY+ZI0oNXXqt9n+mFgtIY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIhLCGZt;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2ECF60D79;
	Wed,  4 Nov 2026 09:59:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786349;
	b=ItzxnYiXt18cbh7Q1pMaBccH4dGH7YRZq0eox+GP2qXQ1gwdbeVkr1bwCZTR4OJX3VFc
	 X2GSCfpNatJj4CW2EN1ncfc4FI2g56p9dSJnT4GRP9+7PBM1E8cARxwcoVZ7Y9KZ0J7kT
	 SOye3OniTkwpR3CLKd7Yw7bW1id9cbbjd6EAj3XKVIITYaRG9MsMvzkYCpK5OkOOe+7PY
	 5UwCPum8wW2y+k7iQ8a5/6QwEO/z705jBUb1mb0qQoZMCJsCwSG8gLnYLhOC/ctN3tNFi
	 5iaS7YSJjj6o6wx06cqgKQw/caplMRN4xnni365aVEbuJjxTvZ3xUMFMiez4tnR3meg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786349;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	b=a87bdR/tMxDfOESEh099KXtq3DxQHDkMdJFV8O4Qz9WINF1DNW+4KYv9gf4td6ElgBIh
	 CVMhVWAJU7DKccOa9FZ/Y5wVTBoilCRbGFhUF6HsPOMfZu+P74be9Zp1Tqw8Rp6vtfKRE
	 nQpg8bqWN1l+6RBTjUiQhLviZo4i91K68swBbHX3r9yPia8PdkLFxPlMm86kuSlFWQeoC
	 TJASsVtyzODke3xXbNXtb9KqIOllM3aCOf80LwCNxkUb49mQakIdlHvTS3Tb1ZcEXVYrK
	 Ri/wtooKiO1jQO/jpUSmNmY8S1BqKQVaAGZ3quhQ6tM1OBK+Hbncrrl+4UjXeaEUptw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B71031F00A02;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786349;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QIhLCGZtJs6IGwSjiOefaAYyWxn2wAz34QveAFQ6O7AAHx34oWeVq1gyKG8HRVE0K
	 rCs39YHJzMo1h4DnHmPOQ9BDnd1unn/dm6Kis6ccRHV7wnAEhDEuL9ltl3Lr2SY5ve
	 psKClZfoHaCcaLH75D5UDDXm3HKwlfoC2wNjx1lCCCltgC3pMLCXX19Zk/97HLdoJo
	 YukWLbe1vWbMCKlKMM0KOqwPGxUCNPPrP82xzf+IuqdOSivvaJaYPK2RJ/GKhuXKgP
	 XueUPkbtZzrwq1yrX53dCpLnrgoz2PLhVl9MqMC5u3132XDnKDmkdf0jR/amEAEaDP
	 oRsK1L9jkuboA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 37FD646D95;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 04 Nov 2026 18:59:09 +0900
Subject: [PATCH 2/2] mm/page_owner: also check PageTail before reading
 memcg_data
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261104-kpagecgroup-split-v1-2-f70e947fec85@samsung.com>
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=1494;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Tqm3nbQI1nWClGneJZ4Vn7FgKvDR6MGrjq0L2fxkJJg=;
 b=jF1VyraheDQeftMsTSeeShKLufOP/x6ZE8gVhGZ9J5wjIN48n1F2UD5mWKXUqYitdOutXoi71
 O73YaVFvaRmDVw6oCDkIzhWabi9SfSmF0DAaIx8yLkW/5QSQ3GX9K2Z
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wa5gek8ftxa878kcoid5p979n1wiwj71
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64E2A14000A
X-HE-Tag: 1793786350-152249
X-HE-Meta: U2FsdGVkX1/8wfDzyqMQ431Zyqhoylcdraj7wbe0Q/vjW2mAYF2Rkgz04fWbTNhT2w7/hC3eeRDRr79wWjBIrlGhMA7+qMOBmLkX6ai5CpdIcwPYbxrbdyByxugGAgWsgFBLoiWj86D4s/UGPprFvWErdI0iQNHlaSAV66lpHpYcr9SPdeijMavIi89GgW+oP9B9Bi8MVRCsQWB1ZIIPJMkFwGmUA3ugauF7UNzSRluDAZgoaZmo/R3RJXfXKNmkf83HbtTZ67GR+2AGNBs8RumuMjL+KT+HPUYblalCsmpGkQm23sLKurQ9nIrVZjIW65RLGCSK2LSwF/AimZ4gWu3G3Sy0C4mi6uefhriiVhxtxTxMB2wUUzI0cfOzaJyz6KGA+kLwHgFznisVcwy7szFyn3FDhy15EFajAbsLTFnGBfZ//xymjaT2uLphCOiilZVYtg7dShwSYwGnWrI4Mesr7E0mz/WnkUwgSeZbrAQnjydaVitDi6js80NIEG/+SBLVaHGTl9LpqBh8tspMOIrmYHM9J1QAn8CXH6/gcJncuF+JzCUHDvhyZ0WhQwjami32YF2Z+FhEgLNwrEK/Xs6GeWt4kEefIeaDrEIgl1KFJ7iJPIgG+ZBvvTFBIsW9IEZXyleiMBATnUri006/SP7vZr9PgutAqB2eHmvD2BCQq/cpFEAW1ETiNwRhBnUB4MlR+0YDPniKIC7LYefinvyCtuRQuLgsH6KEve0pTc9BkmeSdpWgDlK/3wIJ6+pqQ98gNSp4SLe4wvMeHb58pSNDvhO6O9lvJCmhOJW9V+AFn0mo6uJE8GCQlGZnWd+DSsCWangM1mXzy8l3WiE+1+mFXNt4pjuM0DvW9soMvmdg+bkIgXIbAjweWI6laBZfkPDlXYLF+CECpK56lzq2BKZRS9A+Y3j6TA/sIJEk2q2pU5YIbqC/x6dSmX8tXoqdQqGCKvw9RjSSOq/nBJX
 A0oCe9c2
 /q2K+I8v993n7gKVTtn0V7CnRZixBGYsfSVfgc+kxK0t7XbsZQYyeRo0Fcm9/87LKfGlpG9aDKSvQBvSc9ZElXBPfpe7nP8BwNmhkXVPV5HCaSuj2WZY8MG2POdWsUFLOmmZSqXrgAM1dcUNrcg8MH5NIpu4YBd/MES+LNx1M+5KiPryx06BPB+0sphUe9To4qufh2VxEKUPh+8cFLPJ7VBFXJtufqVrxv2mjYNW48Ibuxb14xi1O96Ih/yD39sgU0+nJ/hRFGhpoNwxM818F1ic5uyJl3XJmbskyOIct38MgjTvvr/KshOGJ1FyzJMzYtO7zQVRoLXuuNrpx7FZHgbqTQ/k0+CIhZGZHFyfBIDkGl1gy23rIF6in0kYbLM/fXyjbnkms6v/4PrnWBYbP+ipgSP90bxpXWHK3MgXC4/XdWZxrf0EONSlB+f8sDlE8asdToRq9fN133rrUvOCKlFa0amVw0zPTxuto3olQsbLM9WC8j5cMHm5gHyCwZ7rhqLZC775zNSQoHc+Z5NNpNBbqFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

print_page_owner_memcg() loads memcg_data before it tests PageTail().
In the first tail page, memcg_data holds the folio's _nr_pages. A split
can make the page a folio between the two loads. The stale _nr_pages
then passes the PageTail() test and is used as an objcg pointer.

__split_folio_to_order() stores memcg_data before the smp_wmb() that
precedes clear_compound_head(). Also test PageTail() before the load,
with a paired smp_rmb(). Keep the test after the load for a page that
becomes a tail in between.

Fixes: 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Needs patch 1 for the store order. Found by reading the code, not
reproduced. The page_owner oops seen with a delay after
clear_compound_head() is the window patch 1 closes.
---
 mm/page_owner.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d7..058d4dec84 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -564,6 +564,13 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	char name[80];
 
 	rcu_read_lock();
+	if (PageTail(page))
+		goto out_unlock;
+	/*
+	 * Order the memcg_data load after the PageTail() load. Pairs with
+	 * smp_wmb() in __split_folio_to_order().
+	 */
+	smp_rmb();
 	memcg_data = READ_ONCE(page->memcg_data);
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;

-- 
2.43.0



