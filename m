Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD375CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D3F800AD; Mon, 27 Oct 2025 19:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E888009B; Mon, 27 Oct 2025 19:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042E8800AD; Mon, 27 Oct 2025 19:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E69328009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:18:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9383112A422
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:00 +0000 (UTC)
X-FDA: 84045459120.21.26E2553
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD80C40004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DChI+nOh;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607079; a=rsa-sha256;
	cv=none;
	b=GR+NVRXEg88JEd5kVfxSG8gAABo8GVjxNpoS0/jg2pnvt13uZuO0D632tN4RGadch6g9/d
	6xNBCtXYpJaiZXkpfPiQhpBPGqPO/W9s56qUkksGvyasvuMxyD+hfZ3nVJ6Vy+bZbvb847
	wsRPlfR8jRUghgw9m4mARxnqNoqroig=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DChI+nOh;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vZi5Lm6HCXIvJj/q+L10BffcrsXOVY7/TA959BCzAY=;
	b=jZvvAIpbVc0iInUzUhcGqxpHPyM0qejwE7paWybXVjDm9QpBa6Db/un7qCq8UlkSmx2jdi
	XzEN8w9im0lFTJNrmWJdA5EBXgJ2S10DY30kZ1a7ZtFRdHUPNXZWVdyk5e67kPWzD/RDnj
	vJzRDfgdMWqFlKulJ/4aUTQ355BcbH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vZi5Lm6HCXIvJj/q+L10BffcrsXOVY7/TA959BCzAY=;
	b=DChI+nOhg5pm0r/ehW0aA7Na275GkEkntqDZcK3b1Dwod6J7Mzy4LWhPA9pDr9SZZlW2FP
	O/X9pKzumDkjOjsl0o10KvMl3obEFu91NSz4LHU+7mRfQDrjEm7Hw1/2POKAkt7x9TQD4K
	Ybq7JocSIOeCr0DjI3Vf2lO0N+b5ny4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 05/23] mm: declare memcg_page_state_output() in memcontrol.h
Date: Mon, 27 Oct 2025 16:17:08 -0700
Message-ID: <20251027231727.472628-6-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: d9efq4mf15uyycktuo3ne535pme7t3m7
X-Rspamd-Queue-Id: DD80C40004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761607078-690870
X-HE-Meta: U2FsdGVkX190Q0+TMUkVDH5QkTYmB2uOEXvUb8D182r90/Q62C+KRiyfNy10O4vgjuBGvgTlYAmY7iYqmQhCxK2aH5WkGAZ5hDP/6W91+H/EoMZSWgaKZKhif3/a9UVjZwYYYvDx+XKJyyjNbke7W7p+Jcc9cnp3nlIzIF68eWRA8bxfkp+U1ILhgWKNl6dt75YbIPfo/b7r7lDwAdxk3KgbKG6rBVUD9YR9SQiee03eSgHYY0o02h4CPaAQbciQsAaRKQGtz67PetmDP11JdglmYd8xcB28zW/zjByB8Xo6oeXXmxi0nrwLqDkYgrfKPydSTd6KoP4dhL0n+KcbYgxGNIRcEH0efQz0bvSKzSQPrQotQhjkAKvWnY1mzZP8q6SYeKNd2fPCpYKRIiauykxeejITb+MQzP6HlODxbFRRxtoh3EMVHijUYZw3I59WjuGfQerj0fPd3D0hXBhBpKLRUaEO7B6qGaW6QV6K+VkdQvreFqIJ1do5z/fXpaOxgVKWzdVSY7KHOKxqq+3OBBsOsuVMLOyp1sj33KH26llB79+tfoMy8/voGspZMkaN+3bhPowmPcKpxB77hUN33CtQqNvhqZbvIEoWOqR3RLRFTvV8LxVzOoEmfW23fehrxif1zdL+altuqHlmxjK5ORqRexYz/Lzue9JK6knf0MMY8vgfzLNDQsuxa3scmh9F4nUnPfB9Mn74Jub5Ut2iEYUDR4xUJGQKIIksKekJAdoyE5b2Mj7HjAdTJrN+6Qeb4mZ9p7ax0XSRCL0VqBAFbTgB38m9xot7U53CZAtFSCfvuw56hbvco53a0vua4Mu3IJ06l7intVJgefov2KnetJwqFFUc5EfI66RWGs0A3u3I7fbowGL9bIFNdMhnq7oDNyvmyVRfX7rfFTpWHEXqZ/ZgLdPPtuWTasr1xgYNCgYHDbIeQg6iH9iXinIb7S1Qk2Kz2wqOLJZKqaFNL+k
 JCWgVRFW
 fNztNUe03XAOwPB3NE1a4tlGJZTaLieAzWvFPI3o7owFAmCnDuL/VFSB3I5R6pKV1cb2VG5gAEO1Tq3ssjNcARHe9lw8mzaU4J+0tudyz0kZB8x52yfaH2pQttZTUMR5gLWA2ec0hHa40EdSAZyGrN355uIOWz47OKrZ1wjngnF1ObDKy7nJ6t1a+AWYmKJYfp5lxo2dfiZXGOxIEyVncrCtiGRjIBmpok0/X5zFu/as29s6r1fK91GS4u2TBbxIaNwbnOniLH5ve68r1SJPbRQ09Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To use memcg_page_state_output() in bpf_memcontrol.c move the
declaration from v1-specific memcontrol-v1.h to memcontrol.h.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol-v1.h         | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9af9ae28afe7..50d851ff3f27 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -949,6 +949,7 @@ static inline void mod_memcg_page_state(struct page *page,
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..a304ad418cdf 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-- 
2.51.0


