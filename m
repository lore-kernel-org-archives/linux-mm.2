Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A392ACCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC47C8E0129; Tue, 14 Oct 2025 10:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C698E0123; Tue, 14 Oct 2025 10:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9418E0129; Tue, 14 Oct 2025 10:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C969A8E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:09:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7928C13BF2F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:09:08 +0000 (UTC)
X-FDA: 83996901576.08.E91625B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id 967CE40014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:09:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qmHUBqwK;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760450947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HTt/KzKieiee5hMQF+Yl+hZuVbxPhLlk+WHV6D9guo8=;
	b=I+JOA4MhFMCWRieJyqRFJxV+FitLCrZFnDWGh/AiQDWHWX9REtJUfgjUV2sMi0/jehlSr0
	3KsPBnJVDRhUn/UI9T2WDvzt/evWyLgXJgrf0QFABxBYqJlQFEUg1CjmJ1B98X/G7l2OeW
	fjoJvKonhCHRaZ1V3poy+ZZZVMdwqtE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qmHUBqwK;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760450947; a=rsa-sha256;
	cv=none;
	b=qM6CnO3hFvE4XrL1HyIIESByzQRj4Gx6CrVWDtDoGkYlqnqb9gIwmr6DkVrz0/dpT2dC9M
	EkOzI9Mz/aBkmnjcNgr/FktSN0uMNjoJapBY2gjt5pbkuoorsgwa25Rr+ERjvAKaEsQ9qn
	FxrVp2GMs2c3dIFCmLLMTGTpAkpR8+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760450944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HTt/KzKieiee5hMQF+Yl+hZuVbxPhLlk+WHV6D9guo8=;
	b=qmHUBqwKWNT5vYFudzOiUF4zcASTLZYuSKIEBYKIYVECM3evlnYbwtVC8+wujvSBGhkRvY
	OyuizPA56TwSUlr7qmo4GZLrjp3R+5oetCgXTIS7kckygImIJsFsBocWRNnvc2skNg4ZEq
	Ug6JIGrNsyZQALcEojvwDxh6J+Z7bGw=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH v2] slab: Add check for memcg_data's upper bits in folio_memcg_kmem
Date: Tue, 14 Oct 2025 22:08:15 +0800
Message-Id: <20251014140815.383823-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 967CE40014
X-Stat-Signature: 3z9mdbxn78jfb1oomm7iukb13xjqejtc
X-Rspam-User: 
X-HE-Tag: 1760450946-863046
X-HE-Meta: U2FsdGVkX1+ymDpJeKS5dlsTyVGwzdPOAiICJTMsVkU12bzH4WFaRixN8VrwOkp7PHAxI/Mib2uql6Hget+8DnE21/WQUj8EqIgkdHJSKZT0yX6nXYxkCGEsLrHWGepc9AXY12zAs6bvGzWf95nlJg7u66a1nOZY22TLGXDVVUZvKyW+9wb0DzaC0OonZUJUwShoT0oGSa4YktzBpPO7BglIfE3GjyLhOzFZIZGmjSR3tAiLU72l6n4iHtDEbWjE9X0en9yOrMGqnu9BO88OO9schCiNiYQNfS/KV7zcXx7tKNU0ILA7CaWJtsVcmGRZqxwp0q/60Eg23yu3T8uyGPYAjng4l8F5O8QahEYLbRNc3njjXm6VzPLOzBrekPWcfvMN00IwZH5geyD4QokIfyjh6xiuvOXV2vO2Vuap6KylhqZqeGWbipBQJoB5MjTTVkSuWDWyM/vftvjXXhcQjKZh4nRiRPIHNJQE4y3z9fOeZGPnU3U/nX6MpnxTO/a19+Px0QPoBfY0Ycpl6OLwUPqsu/Uo2SWD+nFAheZ5mpjRgVmQHNwLlZPggSF0xctuRy60ZteU9tnHwYGj9FuO96RWL1brdQtI6vW/uQZsHNGRHutterpmQ+lsKZZ7Ra+6ou4QbRjPFY7z3UckhNjzOnYzVkSILUPXBo2yDhpnQHyrrhXYXGWcrt4gn54p7+M9tfF6zMTj9XS7s7Q7Jg0E8gsuAh8522xeZtNhx/hplfKCdBqZhRTaKv1N96BwgTLqMYWKv3vl70832OGrfYTtRdB8+HWCqWUSkV/4EkgSFKbihJMLF/9ufk89s45J8oxlCYu8yvur8MsyKsa6A73ezcsktv5qDvQmfOgP0sI6oMFBCXlVJe11OMdj74wekEUwEpGNqFrtJSRx+1y4W/7K7TeIzSVbWiuPmMJ2fyKQU30Kh1RmNoga+RUo1B1+al0potzsQxP3sY+0In6Ifi5
 iE0dyPoE
 z420EWf1JXfpJyqwN+MTZnW5HQtTs04890mRaL2oJiFwomzS0B+ay0WT3WWrSR5AkfFQ27JmTprggXgC2hjJVkjWfJOq6F2r50/kJhyCx2S69mNsH7regMjzoulwWWL2L2QOdw3BMO/2EJsNO07jmt8xBl1nHTpdxc1IN9aXyRyWNk//Au4JJ1bn8fnA6cPD+/l2q0BTnDfEaTOVRpjdQKzU95842Na8qoOhH0m7T6Du1aIQDklzyX5lyM2uQ/e8nNenC/KfIaAg92gKdQwgFXiskdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

This is because OBJEXTS_ALLOC_FAIL and OBJEXTS_ALLOC_FAIL currently share
the same bit position. Therefore, we cannot simply determine whether
memcg_data still points to the slabobj_ext vector by checking
folio->memcg_data & MEMCG_DATA_OBJEXTS.

We can distinguish between these two cases by checking whether the upper
bits set:

1) MEMCG_DATA_OBJEXTS is set, but upper bits are not set,
   so it should mean obj_exts allocation failed (OBJEXTS_ALLOC_FAIL),
   thus do not report error, or

2) MEMCG_DATA_OBJEXTS is set, and upper bits are also set, so someone
   did not clear a valid folio->memcg_data before freeing the folio
   (report error).

So let's add check for memcg_data's upper bits in folio_memcg_kmem.

Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v2: Per Vlastimil and Harry's suggestion, instead of introducing a new bit,
    implement this by checking if the highest bit is set.
    Many thanks to Vlastimil and Harry.
---
 include/linux/memcontrol.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 873e510d6f8d..f9f7ba14be04 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -534,7 +534,9 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 static inline bool folio_memcg_kmem(struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
-	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
+	VM_BUG_ON_FOLIO((folio->memcg_data & MEMCG_DATA_OBJEXTS) &&
+			(folio->memcg_data & ~(ULONG_MAX >> 1)),
+			folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-- 
2.25.1


