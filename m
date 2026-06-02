Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB8ECD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11FB6B0088; Tue,  2 Jun 2026 17:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3646B008A; Tue,  2 Jun 2026 17:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1FC6B008C; Tue,  2 Jun 2026 17:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A951E6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:46:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 517D91C0242
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:46:11 +0000 (UTC)
X-FDA: 84836306142.28.BA920EA
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2F21C0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:46:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="IZ/LOQtB";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780436769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/4Vsto/1l7Al8DkWZsvzlSoLvXQ7vHOlLVSRBNyTZU=;
	b=AbweJaiN0TBqFGJev9VTSc34P2yriMjW4jzPMCbgxyexhRKZVRDCdz2VTVzkQkzUPP0vmm
	53grKaEG3Sh/zQRfIy5OGN5jQD1qj0e1G8boB+wU2oQJ2ZGHar4hjByX7Pw5Vnzr4ddOZW
	OYMEZ9sbE8jXSTWQ81Jjvl/hF7ojmd4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="IZ/LOQtB";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780436769;
	b=oNuz7DcWh5ECUg7H2UWKRlDCleGhdKfr2s2XBm9Lf0oi1iMCYCA4HKdbLGPTYuzvIz7/tB
	qSbAFO5xX4FJT6cvISb3pVMX8HaSETod17xV8pY3OOtH6CDwj1/lnT2QC6zfRu0YaSd1cx
	nzlg1z7m7VLAdgMjy+LXkOBR//uERag=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-91588056619so44830985a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780436768; x=1781041568; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I/4Vsto/1l7Al8DkWZsvzlSoLvXQ7vHOlLVSRBNyTZU=;
        b=IZ/LOQtBykDkPfVxBMRasmz0LqC/wQSfqENohSK9RdJ2ey2ksV2pHU6OTVOpSlyffk
         fXAU7JLSfRZ0da8nn3Uu5vpNWf342WOdtvlTsS3Bjo86+HJ1LMMDhTKSMvdQNortk2Lr
         I1/+GQvdXydVZ1+jUe6lB2Zx2/pnOnsTZqEHsx8SvFRPkNVpDQLEs6pGy/nepnlm0/MP
         o2rK/HjjHrIutdb1szeNNJLaHbGXqhwphlwMlzb7+5aJ/LOfhcviOY7QjOIGl/Guht8a
         vQuVn2YtI31UT2NDS5fd8jcwEBSVVzMt7tEiwQigafuxfJfgvVQRea0l9/UU0YAqDYn7
         hWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780436768; x=1781041568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/4Vsto/1l7Al8DkWZsvzlSoLvXQ7vHOlLVSRBNyTZU=;
        b=hqLzGa8QCUz/ZWIFjlukm9O/5DMMHYCNcUbhkA5DJMWH2ofDg1zmJTwWvk8NG+A9FK
         bbOcgJZONAq/TB9r8Pe5zIWAtWuJP9bZIGeyQZVlpIIJKUB1qRAVcW1XA+sSRHHdJMHm
         11GaNZYIM9JhucleokgQaC+ZYaD/ZaedQozh7YGNA9oUgvHzRipOptwdkzSoOslBRs60
         pJT12l4ULKmgEZkKwkoGjJYcHi5il5gY6E8fkRtrhso3YHcCl2uJJn75SVRGKOUciYDy
         SeaRU2t9wUjkfO977seXr/kcKpqO5d9oNuWOIQeWKaAZcWz1EyBd7kwHdmcXbLHz8J+O
         IsEQ==
X-Forwarded-Encrypted: i=1; AFNElJ80ze0zx5oESugYDodYVSW4j9tQQRpizMpZF5ob+TmvXDMc0j8kr09jz61EujHi2GC2OMKbSmkMeA==@kvack.org
X-Gm-Message-State: AOJu0Yz8HcmO7TgR6gAiVpNTz0Hkty11s7MkhK8slcOUdHRnB6RxKsvz
	x0q7R5+qJhr1mo7CPpbFrWTkrloNZrJIcLzF4DDkipi1lduwSbkrdP4blo77B0Dey2g=
X-Gm-Gg: Acq92OFhc+E+7LFzRz8xcbYoV84A1yu9KquQKWF9uL1KbxNrsSiIBL0hbQRbpjzK60v
	oZWLKBQ58xujgvJ5CBtC7U0insLi49LlTiIRTDQDNeimhX91Ty+u1qkf91C4a9vWpHDPf3PwuYS
	6haks+Z1BkeM1AwVV8lnVCo9dhnYgnw1Jz7LJ8XBrtzglW0gxLsRBFHB2gRz9CYJ/9htHFTDriC
	W0/2B+6bHfyuLuyjZchBfy52jPGnwHkxj07UCXvxuuz+pmkmgb95d2Tg3rCP5IU1xMEJVZBmQeo
	0MsWncRyQHmDM6Oez+BrutOX0/GBSJE5oVZfBKydfOOb+hRJ3yT/twqbrSCedw5OIU51tsHO1ah
	qq+/nh+E7kKArRAnwE8OibvJm/tSbeXd2hOwbpSgvUsQKsgGT7ZJwZyC22Akrd1hjQYPBNJEOWn
	nYRm+KqgiZflTpR5qkr0lOENNajEARzHdC
X-Received: by 2002:a05:620a:271d:b0:915:675d:a2d with SMTP id af79cd13be357-9158a858a41mr159358785a.51.1780436767594;
        Tue, 02 Jun 2026 14:46:07 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3e0d55sm57779185a.43.2026.06.02.14.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 14:46:06 -0700 (PDT)
Date: Tue, 2 Jun 2026 17:46:02 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	shakeel.butt@linux.dev, mhocko@kernel.org, david@fromorbit.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, qi.zheng@linux.dev,
	yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org,
	usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
	ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
	npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] mm: switch THP shrinker to list_lru
Message-ID: <ah9PGv12mqai84ES@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260601083652.59539-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601083652.59539-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xswhdyybue4a1mcwkoms3f14a4cndfy6
X-Rspamd-Queue-Id: C2F21C0004
X-HE-Tag: 1780436768-736868
X-HE-Meta: U2FsdGVkX1+XIkVEONQ5DWtbwYJb1wW4SYrzA9SFrWh1jgmWtfctBShB0LfWx5kjNgHOQQsWpz4cXJ/+4dxaJIQ+eyVEoDGt3D+wVGgfZvxemLjGfBGdZTQZ4wo9DYRuhIJGtw18C8GHkuCQL8y7laMu/mdF7a0y4GoA5C6TdDiNjL73aJMs5PCMFpZXqodVy6LpVxEwI/X6fGj7aLxnPjG9O5BBQUxHfWlu8PfxU7+7TlOb1KyEpizEvhqGjzkbx3BOL1ca6Vk134YrdfBN/gQFyBVzaEX/YB+5gFRWBiP/7+ywUAMVKDaILuSFzapVtkqGHvuiHGIu8h3kaO1VNoKalf/K7kOmcRw6ezqJbccMY2K+UXIRjLyfhCElIsSfY7nMH7WD/7whfdz3tlYc1nUKTMa0dyzbnno7Ypn7qRiGFx/BNlPMmpRzCFHWEtmjBXCZPuzB2yTBjlmsyWxmbGQb1a+ETBq2TJu1QBO20j+LIqSkzvDzkAxjZMq/7/w7erWe4gKwn/bkhc3wiQYbYiSQOr3kf3PfkoqS9rf5xRdm0unPz0IyKxF9N49hPBoQfA0s54EmlUqvwAtce6AJfVq83p2ZYd8x51w36fzK8NtuhAM521+UmDP5+CP+dqOqcGX+HnNkI/2CFos2JVdPC+4ylOlXriU1tzBRfxTsbCZzR7ub/Khc/s2CcAe/vCgKpGEeGTjo1yJVw8eRWzGvYqL3JbLYSuKLT5s3PaOI/YsxXMGQHUzLJwTJWivODD7hMR5xZx238nDxxHNh0O7GzWzVD1uVWsvah8ASU6U8HtDcx9cpX6FQHRy+RtDxdRisVJ974vHRiDGocjX5ov1LQynJ2Lp/wDKIEqyCdIy2Q4MAghULLqHAkQ7wO6R43apCgyaxK5A1zMeK09mLpQOFGaX5QHPX+/vnNhhDJ1yaJNThanbNpR+FOMUjHofLUC9WnmtxOVkrsb+rDEIsSNB
 NNLHRFHx
 WgY7eDHiZivjCL1n39qNX7qEczO3x9S63mgXMhkXhSDrrx8rgp3k+YbcKogmcPloAqNyw5G2i9/j0pXkSFXvJrYXsG7Ne9qJBmL1kHTfCX825phqmjwxBm/aUfeYkL8slEftLRCuEb7vBuwrpF+oognu+TVIhUuBgEgiHEU5swHnmJCPQTbySDq8Jx1oUUs+Jv9hf9SNxT7tPAQqEQWFnEHKJEZl/RRLCsj1gUKVghQydMwZpCQjb61lO7NWp7rnnBnnzuHusBD4gn7JaKgOB+rVrRINTeH+RxOh96foXf3ZpzCoFQU4g5oA0U2/RLyu3u6vMlsucZoU7HuQARq04eHDFxYTyLIOO1g830p62RIBPk02lDEVqj73f6bHgqBfhXlLCGckWW6CtkQnoSS/xHUZM2uAah7qLXvcHBH0mf+z8rkJNS1wUPtUroQVzslFq2b53FKpk4doSL8eRq3THzo3uUoyZmC046D9jNOWoF26ZZ8LHbMmOhmf48zaOxJPxd6GFQQ+RhGnybw6JLDRG8/KVlLG0AvZKBX/2clifyRIAqcEd6T7QvrORPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:36:52PM +0800, Lance Yang wrote:
> As the changelog above says, the old queue is per-memcg only, rather
> than per-memcg-per-node. So reclaim on one node can still walk the whole
> memcg queue and split underused THPs from other nodes in the same memcg.
> 
> But I think the new one can lose reclaim in the cgroup.memory=nokmem
> case ...
> 
> With nokmem, the deferred shrinker can still run from memcg reclaim,
> because it is SHRINKER_NONSLAB. But the list_lru is no longer per-memcg:
> 
> __list_lru_init() clears memcg_aware,
> 
> 	if (mem_cgroup_kmem_disabled())
> 		memcg_aware = false;
> 
> so list_lru_from_memcg_idx() falls back to the shared node list:
> 
> static inline struct list_lru_one *
> list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> {
> 	if (list_lru_memcg_aware(lru) && idx >= 0) {
> [...]
> 	}
> 	return &lru->node[nid].lru;
> }
> 
> That makes the shrinker bit unreliable. __list_lru_add() still sets the
> bit on the memcg passed in, but only when the list goes from empty to
> non-empty:
> 
> bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> 		    struct list_head *item, int nid,
> 		    struct mem_cgroup *memcg)
> {
> 	if (list_empty(item)) {
> [...]
> 		if (!l->nr_items++)
> 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
> [...]
> 		return true;
> 	}
> 	return false;
> }
> 
> If memcg A adds the first folio, A gets the bit. If memcg B later adds a
> folio to the same shared list, B does not get a bit, because the list
> was already non-empty.
> 
> So in the A-first/B-later case, reclaim from B may not call the deferred
> shrinker at all. The shared list is scanned from memcg reclaim only if
> reclaim runs from the memcg that has the bit, such as A here, or from
> global reclaim :)
> 
> Anyway, only after the shared list is emptied does the next memcg to add
> a folio get to be the one with the bit, IIUC :)

Sorry for the delay, this took me a bit to think about. The shrinker
code is a mess.

I read it the same way you do. And this is true for all list_lru users
when nokmem is set: we just set random nonsense shrinker bits.

HOWEVER, the generic shrinker code fixes that up by IGNORING random
shrinker bits like this when !memcg_kmem_online(). And shrinking
correctly happens only against the shared root queue when the reclaim
iterator walks root_mem_cgroup.

HOWEVER, the THP shrinker explicitly sets SHRINKER_NONSLAB, which in
turn overrides the previous override. So yes there is a weirdness: we
get the root cgroup invocation against the shared queue, and then one
more time triggered by that random memcg bit.

The most direct fix is to just drop SHRINKER_NONSLAB. It declares
independence from kmem, which is no longer true.

Cleaning up the shrinker code is left for another day.

Andrew, if there are no objections, can you please fold this?

---

From 6787efabb9584824c196bf01c517d93aae3764c3 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 2 Jun 2026 17:11:46 -0400
Subject: [PATCH] mm: switch deferred split shrinker to list_lru fix

Lance Yang points out a weirdness in the list_lru code with
cgroup.memory=nokmem: in this mode, list_lru collapses to a shared
per-node list that holds the folios, but __list_lru_add() still sets
the shrinker bit on the owning memcg.

Usually this is fine, because the generic shrinker code ignores these
random bits when !memcg_kmem_online(). But the THP shrinker still has
the SHRINKER_NONSLAB flag set, which specifically declares an
independence from kmem. As a result, the shrinker fires twice per
reclaim cycle: one during the regular root cgroup scan, and then one
more time triggered from whichever memcg got the shrinker bit.

Drop the flag, since it's no longer true. The deferred_split shrinker
then behaves like every other list_lru-backed shrinker under nokmem,
including the non-kmem ones (zswap, workingset shadow_nodes): skipped
from memcg-internal reclaim, driven by global reclaim only.

This needs proper cleaning up on the shrinker and list_lru side, but
that's scope for a follow-up series. Just make it consistent now.

Reported-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/huge_memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72f6caf0fec6..aef495891f8c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -956,8 +956,7 @@ int folio_memcg_alloc_deferred(struct folio *folio)
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE |
-						 SHRINKER_NONSLAB,
+						 SHRINKER_MEMCG_AWARE,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
-- 
2.54.0


