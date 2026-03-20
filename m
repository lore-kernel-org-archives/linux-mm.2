Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08794109879E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DAD96B0119; Fri, 20 Mar 2026 12:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2786B011B; Fri, 20 Mar 2026 12:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C81E6B011C; Fri, 20 Mar 2026 12:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6886B0119
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:07:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16AED8AF2B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:07:14 +0000 (UTC)
X-FDA: 84566920788.03.00DDAD1
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45A65120021
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:07:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TVIozE7S;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVccYYVHJ+crfYkA2aMufdSb161yYRzvLvUkNA7OCIo=;
	b=cgjJMqbW6US4atN/TMxyHhmf+ANLw4EuECfJeFDM91R8xCd2mDTlVim4Kbqif2D1AR6Clj
	6LFiwT2feG7j4Z8+5E99KsevFNX5cO1heXrpfsFCYEuo3SNSp6w4iEHmH/N9tyUXBb81Zg
	vrO8wpbeP1pqt0+HqiiZ9YLV3Q9uL7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022832; a=rsa-sha256;
	cv=none;
	b=qi/VjnEotZJUYVQT7ZuAhP9eGgToN4aeL7cEt6eh1NNAWBeBJkxPwrAuZUVbblOTG9ISAc
	XpmZ2Lq+9zI1MzOTt65omS8bjEb1HMQYDGev/ODVxtgPLyP94gXQa73yEFearoWnY8WZ6u
	SUkhwZZyYGSS0HOu5tL74mnOA157Jbw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TVIozE7S;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cd8dbf4f2eso226399185a.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774022831; x=1774627631; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rVccYYVHJ+crfYkA2aMufdSb161yYRzvLvUkNA7OCIo=;
        b=TVIozE7S2bAEIiQR+Qi+J90UvEr0msaojvLQKA30WGIJhf2MKvlIQxlZFOl8gjWFLU
         dRZX5Px3+WMY3f8zKq149NqyJofyUAi7bsexoGruhmgcpkjTb3CC75TAGQ1mG4/w8m1S
         BeegWbqnJBt0FxLe1VIqCCUub/zb3yWp97DBJ7ihkX9oH4/LuZekIf5s1kvKQ/g+LRsr
         F7Sidqmg5qMj9y5OGRjhSnDV9rQ0OtHXIsYdqI67TO6SrHLW/+klwOCXQvo2AI5Yrvgm
         Z3lUhkrCjv+nnzCJ4hP/3kIa6Zpz5t+QMMk+ZpJtTGYvH6Jsh6RM5WOBGFfeHRkcm1Q9
         N3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774022831; x=1774627631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVccYYVHJ+crfYkA2aMufdSb161yYRzvLvUkNA7OCIo=;
        b=S0mpIP+hGm7k65nICp6aDUd56gj18ISTXgx/xWDYsDL7jeLbq9VbSJOm+cNcsV4pBZ
         TvhiTeIIv7cXmLaA//8CgY7dLSQFfZUPuwAlayDLtHXp25cNXnfUSiSwpRK0E/QnpZXl
         9XErSVHj3ksja+pzvMtU15CbkVyLWDI/WWlngncPvrxpMGPeksfP2GGzYleq/tpuKSdj
         6ecEDUlGARWeAdMD8tywNkjp8G3uicBo+xyaCOfsgiWfwqhskXnYSEFRh+NAvSpMM5K9
         AQZhGlWWDf2s4fppEudfBqIzZ98YtgIHve4BbDKKf4FAEsXHNvsrtbIoNR4yrW5pYqzX
         JjdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqFkqmyf8IeTCUXmvvLdrwYKApiqjeAYQc7okEl0A5lxjMMCHV05Gm8KdQuWr3Qb9Up8nxLrIosQ==@kvack.org
X-Gm-Message-State: AOJu0Yyg3IOuocNIeIrfu0JeRXN6hZgoufNwSkjSXoqeDqAtanc6rZvl
	cZW3bloqrAD19RurXJU++oiDUpEpMBr1XfdbivrligcDDSl7oj4oAsZoJIpIJdRZVt38qERPFgp
	paFFn
X-Gm-Gg: ATEYQzxBDo/caLo4MsW3RpwaZnqpNoF6lAc0pSeca2ybVehLwuDjPtJvI4a5tMyO7K/
	tXNv4dePwj1yVDRXL1zn7sPQs3JiESUhib3GWVLq/KUW8sm2hU9VJA4YEoklbAcaZuXaddtLmgw
	Obaprw/6CUjlx9HQ0KwneOmXlABbM3Q/76nzlet0SvOXyx7k/X8oOErr+Dhy9kD5Ej5fCBee8h7
	PEfAB+yow/l2ffEjNuJqdysmXfAFhbGVX6im4fXVWcgRsZe/bO1iSAICl+onrKjyQanYekr8Q/s
	1J1u4w4htOBAgkgBtk0mgp0PWKkOuDVljc2aN3zGXW9+keA/XLdzElHHaGkWW5CDgvA/xBvijWr
	J1wJ7JxsXuWFD56RvEkMZfLIx+Iq3yXjuT3Xu5vnMP7i6KOitzVFjVmLKs9C6iHxoiazwVSe31y
	kRDsxSMFyG9FWZXms4XfliaQ==
X-Received: by 2002:a05:620a:4144:b0:8cf:c757:f1d5 with SMTP id af79cd13be357-8cfc7f67d39mr483816585a.50.1774022831007;
        Fri, 20 Mar 2026 09:07:11 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc8f93489sm178520185a.15.2026.03.20.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 09:07:10 -0700 (PDT)
Date: Fri, 20 Mar 2026 12:07:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <ab1wrRdT-4GfWbcH@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
 <absr1vgNP_tM1OEP@cmpxchg.org>
 <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
X-Stat-Signature: 54uahdcfa5a3g9egzo1fn16894ytiiab
X-Rspam-User: 
X-Rspamd-Queue-Id: 45A65120021
X-Rspamd-Server: rspam12
X-HE-Tag: 1774022832-891829
X-HE-Meta: U2FsdGVkX1/ZhI5vGbSV5J+rU3tMgLwXmjjv9Ycz1EhTpacQ1aAI4y9kkptXy5BZtaDttQvr48QlMS8CTdZFRnUl2v6fsXzRuCYamBPN+PKuxaBBnObNIb5kzoES2HGqRGoM1ZsQg73FJdt0mTagm7KNqEq/gP/REgaqeJGy+ubcTPG6jX91sS4CPwwB4NLlgJZogopXgyZzrNIqCUZYssyGoxRj1csaSTVeBHWumllkldDjaZf7Yucc5Y0HtGn2AEPacRTv0IBfbWx5eNu0b/0H4o38DUCmaBBohgrDYoT2HhzEFMG7XC/pg97B6GKjbSGVrslkEt8fVNMjHWZjaBGoiBV1ozIuGC2vHM9oCZ7i8cWbwIVyPllzmyQexi6iGLBEDfZtVWrn0Acq9kdUvTGRIqHPwZHfCgZs9xE4zyOtJcoX2ioQ70x3L1NunbW0Weuzoe3GBD71SHsPct/1uAYDViB6SC32QMaWGFSecAkaL/NkQ+wPhDzJaBoz7BoOv2fz/NkW+QB1JVhfp3ny9Nvmi8bbWvnalTqSgSd4y9zLTxtNfOP3PS2ANMIBhCw6sCtXK9jcwUotM+KoWjFkRKvlOju70MJtX1MFWGHv8F/O9CVkjR4LtbY78GxEXEo6hPTcGq7VOiJ/QgWT0qZVPsMTUo6HwlsyZs9skyEebatraWuM3ePTwhgJsq7o+0pP0uKOhigXESL+yiub4uz8rODeebKA0HhPIVwj8CIv7DaBQb4paeYCsCN/fPUIcRWFCttcCKWU4HnDHIo9fNi1lJi4weZzBed5cnbTe/FhNiyCM7iQsFSUcAmWAqwHKh1U8yICkAYXyClWu+O4TTvET/VYc8GoBqw5VgtOhDYMW5lRvWKU+CQuvKwOC2KY+3wQ9Ub/aNQ4mewu7fom1q65cJkSK78RwwOTM4wW6G4ay7C9JD0uqQNHQT+ChDRD9/TbNcxa1mBqhvPtpgwD9nX
 wsUZ3rr2
 AGob6BSo6KFcB4bJAK9KHLfIS68DxPYtuMHsi8cdnzoUKDcwC4KUqh8uQ/oZfThVurt7Ps64Uinhl6I1FAIWYcuBuBkfSY31vsJ1NCjPzJ2voxS4qk+JxVhU+bUwvMDWYkyNdotJPifuXhas7P5YAkG/V4+IrGau78Gzee8s3xucnBRuvaLe8hseWBYmEFJYrxnPMUd46eRjTQtxqOteHiQNn0Df1d0OavuH9uyLJrR8QdpxbUlJGpH/4bige3ucXbH3M/U6L8pXkxJwOhsobsaMNaYPrYwp/oorkL1NmHAAzmHIWFkozao/SkUXNentCNVZMwgV8zI3SyWIkcZzVqyJ7+4dsJl+6v8w/Oevu0KYO0rJlMk85ZJUkxq2EDUwLhM9TDy61+WhIlwNuVBk1OI7exTFCBvnYUotTOymkNOP/CAqyTg51j3rTjF5/LL6TKRbf1Bu4q4zlMHx6ZG2xXg5QjOiZudXdiFzArqx7dLozZyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 08:21:21AM +0100, David Hildenbrand (Arm) wrote:
> Of course :) If list_lru lock helpers would be the right thing to do, it
> might be better placed in this series.

I think this is slightly more promising. See below. The callsites in
huge_memory.c look nicer. But the double folio_nid() and folio_memcg()
lookups (when the caller needs them too) are kind of unfortunate; and
it feels like a lot of API for 4 callsites. Thoughts?

 include/linux/list_lru.h |  8 ++++++++
 mm/huge_memory.c         | 43 +++++++++++++++----------------------------
 mm/list_lru.c            | 29 +++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 4bd29b61c59a..6b734d08fa1b 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -123,6 +123,14 @@ struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 void list_lru_unlock_irqrestore(struct list_lru_one *l,
 		unsigned long *irq_flags);
 
+struct list_lru_one *folio_list_lru_lock(struct folio *folio,
+		struct list_lru *lru);
+void folio_list_lru_unlock(struct folio *folio, struct list_lru_one *l);
+struct list_lru_one *folio_list_lru_lock_irqsave(struct folio *folio,
+		struct list_lru *lru, unsigned long *flags);
+void folio_list_lru_unlock_irqrestore(struct folio *folio,
+		struct list_lru_one *l, unsigned long *flags);
+
 /* Caller-locked variants, see list_lru_add() etc for documentation */
 bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
 		struct list_head *item, int nid, struct mem_cgroup *memcg);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e90d08db219d..6996ef224e24 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3768,11 +3768,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
-	if (dequeue_deferred) {
-		rcu_read_lock();
-		l = list_lru_lock(&deferred_split_lru,
-				  folio_nid(folio), folio_memcg(folio));
-	}
+	if (dequeue_deferred)
+		l = folio_list_lru_lock(folio, &deferred_split_lru);
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3785,8 +3782,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				mod_mthp_stat(old_order,
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			list_lru_unlock(l);
-			rcu_read_unlock();
+			folio_list_lru_unlock(folio, l);
 		}
 
 		if (mapping) {
@@ -3889,10 +3885,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		if (dequeue_deferred) {
-			list_lru_unlock(l);
-			rcu_read_unlock();
-		}
+		if (dequeue_deferred)
+			folio_list_lru_unlock(folio, l);
 		return -EAGAIN;
 	}
 
@@ -4276,8 +4270,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	rcu_read_lock();
-	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
+	l = folio_list_lru_lock_irqsave(folio, &deferred_split_lru, &flags);
 	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
 			folio_clear_partially_mapped(folio);
@@ -4286,7 +4279,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		}
 		unqueued = true;
 	}
-	list_lru_unlock_irqrestore(l, &flags);
+	folio_list_lru_unlock_irqrestore(folio, l, &flags);
 	rcu_read_unlock();
 
 	return unqueued;	/* useful for debug warnings */
@@ -4297,7 +4290,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct list_lru_one *l;
 	int nid;
-	struct mem_cgroup *memcg;
 	unsigned long flags;
 
 	/*
@@ -4322,9 +4314,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 
 	nid = folio_nid(folio);
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
-	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
+	l = folio_list_lru_lock_irqsave(folio, &deferred_split_lru, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4337,9 +4327,9 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		/* partially mapped folios cannot become non-partially mapped */
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
-	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
-	list_lru_unlock_irqrestore(l, &flags);
-	rcu_read_unlock();
+	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid,
+		       folio_memcg(folio));
+	folio_list_lru_unlock_irqrestore(folio, l, &flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
@@ -4445,16 +4435,13 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		 * don't add it back to split_queue.
 		 */
 		if (!did_split && folio_test_partially_mapped(folio)) {
-			rcu_read_lock();
-			l = list_lru_lock_irqsave(&deferred_split_lru,
-						  folio_nid(folio),
-						  folio_memcg(folio),
-						  &flags);
+			l = folio_list_lru_lock_irqsave(folio,
+							&deferred_split_lru,
+							&flags);
 			__list_lru_add(&deferred_split_lru, l,
 				       &folio->_deferred_list,
 				       folio_nid(folio), folio_memcg(folio));
-			list_lru_unlock_irqrestore(l, &flags);
-			rcu_read_unlock();
+			folio_list_lru_unlock_irqrestore(folio, l, &flags);
 		}
 		folio_put(folio);
 	}
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1ccdd45b1d14..8d50741ef18d 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -173,6 +173,35 @@ void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
 	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/flags);
 }
 
+struct list_lru_one *folio_list_lru_lock(struct folio *folio, struct list_lru *lru)
+{
+	rcu_read_lock();
+	return list_lru_lock(lru, folio_nid(folio), folio_memcg(folio));
+}
+
+void folio_list_lru_unlock(struct folio *folio, struct list_lru_one *l)
+{
+	list_lru_unlock(l);
+	rcu_read_unlock();
+}
+
+struct list_lru_one *folio_list_lru_lock_irqsave(struct folio *folio,
+						 struct list_lru *lru,
+						 unsigned long *flags)
+{
+	rcu_read_lock();
+	return list_lru_lock_irqsave(lru, folio_nid(folio),
+				     folio_memcg(folio), flags);
+}
+
+void folio_list_lru_unlock_irqrestore(struct folio *folio,
+				      struct list_lru_one *l,
+				      unsigned long *flags)
+{
+	list_lru_unlock_irqrestore(l, flags);
+	rcu_read_unlock();
+}
+
 bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
 		    struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)

