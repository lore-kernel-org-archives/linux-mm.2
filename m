Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043A860A2605
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KmjfHBMG
Received: by kanga.kvack.org (Postfix)
	id AEDB16B06D9; Wed, 21 Oct 2026 07:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50A86B06DA; Wed, 21 Oct 2026 07:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918896B06DB; Wed, 21 Oct 2026 07:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655BE6B06D9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF6DBA8051
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:35 +0000 (UTC)
X-FDA: 85346458470.12.8A31EBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4853F140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KmjfHBMG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5tAUz/tkiXqS8hJnljlzMQfqWaNZ/lYqApYxklXIbU=;
	b=A5p+nUKOqPgBg6GqNmFwsqh4aKSSyKyrICGGUjH4UIa9alxcsgcdN0Ilgsedr/i4KPcyFW
	RpPq9UEdp+WNRLlCV09pMSTUKeh8aIn658r/oGZakUgu/66jndeGfR+jnMo8kDelTjsoDI
	qDNIq7iHYafxRlcZvwZJeRCVody2Zoo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KmjfHBMG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583254;
	b=Y2m4zl3I4lPqs99MLPj3xwMqdJYNUGZ52ol+kjcg9BTCp/Q0FEl9fPdVT6ZZicsJ5QSRP2
	IidSsM696yuZgzB6FuBNN34vHS5EnjLP3/1neE838gStugcTO0kmvquPc3AyoSw/AFiQuz
	02hxDy9NKrjDjneTNCJ7WjCW9BdZCRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E9AE44799;
	Wed, 21 Oct 2026 11:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8DB1F000C6;
	Wed, 21 Oct 2026 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583253;
	bh=k5tAUz/tkiXqS8hJnljlzMQfqWaNZ/lYqApYxklXIbU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KmjfHBMGzG71BBUUV9FeGHY/xvy+/c4Vnrc44gX4jucXojg2nTgIi8T46RM+52sIh
	 CgG/UumtBk/l6Hxq78hLSFQOHjHAwkdGcU95oPB8EuM5G24kWATQKMra0NMQ5LIC5M
	 /SiAOtWXWIg7PBpFsBvaj+wOTBPbxZBoSVpR2W0+mjb1FFgW1ok87RIvDoDwfjG2g2
	 WdZ78CMqOuBUccxQP77+dfbibnob4H0ZElJTlDuIQzHwMPTGWW6Pit98D/xJr8a4bR
	 /0DG+ck0ogX23fUXpQ2jq2OGBtebDg7WQbfEmA1NTZkMosbIUkf3+MsGAYaZu9Bw52
	 SJvrec4At6Jhw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:44 +0100
Subject: [PATCH slab/for-next 03/14] lib/xarray: specify SLAB_MAY_ACCOUNT
 for radix_tree_node cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-3-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 4853F140006
X-Stat-Signature: gyenhwzc4wiokbupbt9fh6f6pefitt6c
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792583254-189198
X-HE-Meta: U2FsdGVkX19hnpUDnT9jr5qv6ttGS9p6i3fMM/BJ0kd314rqwXiDbeNZUXlTET5ZKe452sXLI4Zv2Y7Sdic/cLz1O2DS+T2wi8aShM/FK5HHNJm6oPiVEbiNGw9HNxsABxjPzKWG/LjPksJLWt7pvcULQX+Gze+Q2lTpO5O6ZRXg8vtPp433JIqV4pThFDKMgn7BJ/a1+Rj8xYN7d6kSPaCugQfObqW4QhDs0t8S3bOHqg1UrKw7VoazaLPkuohYDog6QZyQ6x+JOPpdCrHhvQsaM4M3Zkq5JDmckrsmGQOW5nw3H9ib93WbCWbNisoJZPLaRpEowC0VSbn74WrfwWTV3UQQ9Tr/dfhK/8CkghBEicdUbma/n/+VfGfYKH8qBHeZIUCoP6FPYv9nsncN358UdYGSjwulFQms3B9+64p2OjwI3hmGOnThPxDuvhrEl1oBxwNgHIFMU1lJG4IMx7KVk6HUOd+TNmWFmeU5e9aTpJEiW9xnJAC/I9c6/yUz5AMBZehmt9UVU1kSf2CtEh2Rf6/we3wHv8vr3KVpQrH+cucLlRadm88UjPFaiszaKdICOwqCnUWgm3GaoMwIM30X+xsIeScovUXRyb6x4XlbxeeXR5B06l72k4j7IwJVCXUYSh8x0SH9SuH6RI6+KOaMu+x6up6E511ZT/B5Kanv57h4XDKF5q9die44AfeWu5tAldQqInQwNaWRQTRsSsTXHh15JtiEkdNxidKNqdqGn7TV4AXZWWzpw8V0Yq4yi0t4gzwDJqyS1Ky3pH/Fk/RQdN1KvOh7+U76N6XYnZPF/05Tm6QEvtMuAODzafbbhoKPBrMJ4PxfsXLDV6lewyrXRq1f3idK0s+44d2C7VgsVCvW8rhrGp9Kxb19lNuhIxS7S2QPCDB+pzNKyFAsefZEl1Co5nfcFZwageOQ2kgVsCHw8Evh4odvJgkaVUqhNoYF6NFYTU+PCrnFmpl
 Sj5M5iS9
 Fqa/sJ51xO9Gfbh10nQ99JFRHvIDpILVjGPhaInU+SIHxbYqurcwiYdi+EmWI67F89C5nFofeag9sng2wvspVyvWnpdp7VJ+pafAFIit4ybt+a4QeKyrOCO9VNw+kew5EklG2CNF5AEXZNNjXEg/7jutNzkzVFkBB3f/mXjiwkU6+qUSiSkj2vysUZ54yz6aJiT7KqXD4ePWf8ppTJMye4hn8fLBUxuuTp4qh26YNPXwFdCWsJssQkoYy33IYZnRVIEV6GwK3ol2g8VWCMJt1PFuy7JmrZYmslDLFe0mr8mvGywbeNhOPtFx0RvifvbzbAYZjkGOXXz6MUBbwBmPeoqARa0gz2KohG545
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

XArrays with XA_FLAGS_ACCOUNT (e.g. the page cache) allocate nodes with
__GFP_ACCOUNT, and xarray/IDR callers can also pass GFP_KERNEL_ACCOUNT
directly. Specify SLAB_MAY_ACCOUNT when the object may be charged to a
memcg. __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: __filemap_add_folio() (i_pages has XA_FLAGS_ACCOUNT)
  -> xas_store() -> xas_alloc() (gfp |= __GFP_ACCOUNT)
  -> kmem_cache_alloc_lru(radix_tree_node_cachep)

Assisted-by: LLM
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 lib/radix-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..2c7531deb0df 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1600,7 +1600,7 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
 	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
 			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
+			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT | SLAB_MAY_ACCOUNT,
 			radix_tree_node_ctor);
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);

-- 
2.54.0


