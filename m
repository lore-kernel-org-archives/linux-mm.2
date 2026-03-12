Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF0D106703B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0489F6B0088; Thu, 12 Mar 2026 10:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38186B0089; Thu, 12 Mar 2026 10:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E444B6B008A; Thu, 12 Mar 2026 10:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1CB36B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:26:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F94157A86
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:26:20 +0000 (UTC)
X-FDA: 84537636120.09.C946606
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC3EFC0011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:26:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FHS86o44;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773325578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhyHTRhO4qLOZKTEybzXY/CiyPdSzoBcqB+Ti2SR1/g=;
	b=HSI4FH895Fw9ZvhbLRcADiMZnTjCGvT4XUrEg3l5N5cPmqYzx3xAEP6KwKiOOpU0jV4Ss/
	MGlRD8jpdPWcV7SwtltqLdomvIT3Pa9SW0V+t8zqzYh3dHdiYpgbZpYg0ftU/5OeOZedG4
	9BBHa08Wlv50R73hbRJSNhhEeDBMc/c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FHS86o44;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773325578; a=rsa-sha256;
	cv=none;
	b=lLyez3Aj2wq5C6tn2BJVdluwyW1lacUMfCHeSvtpjqWZx86INdco4j8eKuj7hRMc4/Sh+/
	LLdQRKYN95klXkTPcSRC5nTiLdrZMwXGUg8DrTjOqtJ8JcxfrJ2YZ6A73p7wFcH8g9McFm
	qtG77mrbsQNM6hByO2U7bmQwZgzEElA=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb4136d865so139396685a.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773325576; x=1773930376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dhyHTRhO4qLOZKTEybzXY/CiyPdSzoBcqB+Ti2SR1/g=;
        b=FHS86o44BkbpKb40sUrNYUfvaFO3QzGyDtUmQXr7N6Lkb7O6e2PaSzPcYuvmfJMYAX
         4FcuQgjrkf2028m712hh8rGjjdvR66BSVlcJydBnpkeUUBedJH5XKFL7FTq/FocU0f8l
         eqz7dKkCKeyvRE8n7B6fwMHbMqKL35Tax4/EjsT1Sn3oob+uiUThRdPREKtL2PoK4Jbs
         hzILywYKdYmIKobcKhklxFmHUnyxKwnHZRLTOMChlYGhXAT9chpHqWQaUfIDxl7rF0P8
         QZZvkvQ8tTC8F0UN6A6i0wbzOgmdqICwcVOwjD7/EXdTxfxoHjK5/UHvBRvm3Lw6DlFu
         JXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773325576; x=1773930376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhyHTRhO4qLOZKTEybzXY/CiyPdSzoBcqB+Ti2SR1/g=;
        b=UwuIuiqgfZUTdOydEH+u8a+Zf86Py+euaeFJLj8AXOXQRDOse+wztWEGWdZSJTPAJO
         IywNiIX28Dubazhp4kLhykfwMkjglJfADBAKAzXjNVOvWYt2Qc5y9W8iXEAgGX1y5DQq
         ynekiuhs16ttgzljFwSIlecV2EGrUshZg1JTZC080gBHfNJG8qzxB40eKQKph8GVSOsR
         6hYntXvSus27j0tiCIqBmALv80/edeaWPG4Ar4GGfr+LScYbP//K2SogmvjhPEasq3dw
         NY6bwCmfLpfZCgtmBUHiyb7eVlSf3Yv4ttdOdQmdyYipXZfC1Xtlfz7bSZcSZwI9qHvi
         JVuw==
X-Forwarded-Encrypted: i=1; AJvYcCXkS+S8WJHdCgxRlBhMDv4VyVnNHQ+32gNW91maFDSBHkZR9aCleNRiCX/ncBYEi03wHA0Evs/KJQ==@kvack.org
X-Gm-Message-State: AOJu0YzcorJNek4cazE9bWEeS0qIoF0bL/fim6kR1JLf+O2RDh49kpgz
	MRmUnMxWwK7qEjwZNH2OBJptRp1/I0U+40WU3/FfIRSTSTCNNbXUA8yugRMrr3qPeEI=
X-Gm-Gg: ATEYQzywO2rKbILqXOP4W78l78DPPtF2r58xnReIKtokappV988aAdQvKSmevDtomGF
	B3zetLBuEJJwf9Od7tx5USVhVxIsX/PjjrySOYzqbxmcTmy3m+b9AGwLcw9TJLnJ4296MA4XCyy
	bYn0kzHHZJyhE+RYyG9wVFmqKLwV8y6wjUFjHLIMzDfY4Ir5b8IC4bJ/VRgAfs1uGKB1lIqAMM6
	ibrPMZag1wjJ1brlKkRvJEQ6iSPtNJB2LeVe2/9ECSTOeIOcDAnY6CIoJRRzKCevgj/0bb5NYXK
	otwTKMVnOHK1eBKrKkJz4NyC5rbFWJQkqiveNInMJ3+Rwn4OwxddX9rcncTcu2nofrLJs2o2+Ze
	1mT8f53XxjhZZ1kwmMYcYkNnsdWV6C/32uvFLc81fZjWsAdWwmXoaJgoT5pwGRn6trC1djLsEfs
	tkmxeRjZMzCG86MKv0quU50UkBZIHCa2cD
X-Received: by 2002:a05:620a:414c:b0:8cd:9b4c:1470 with SMTP id af79cd13be357-8cda1ab570fmr851624885a.60.1773325576500;
        Thu, 12 Mar 2026 07:26:16 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda210d972sm391016085a.28.2026.03.12.07.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:26:15 -0700 (PDT)
Date: Thu, 12 Mar 2026 10:26:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Message-ID: <abLNBhh4cMtUo6RD@cmpxchg.org>
References: <20260311154358.150977-1-hannes@cmpxchg.org>
 <abHrZ7VoRIU71vAH@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abHrZ7VoRIU71vAH@dread>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC3EFC0011
X-Stat-Signature: xtph9jt9wa7z7yf3gc33nn5qqzg88wsk
X-Rspam-User: 
X-HE-Tag: 1773325577-922184
X-HE-Meta: U2FsdGVkX1+X8xwQhrNV7m839LhSvCuvZzufyQgho2ZgM+hSO9YIXrtmt7v7CkJa0oOxD0X5WJOnr068mF5gVGbbygdWH0E7hwdkYzNeFuLT1xQyetSmg3RM5fXpqvLKmkZ9wp0fIIGk7FUHC99pH5a5Nx7S049iCOXXzIYCbouKlP9dQBcN2evask4RB4eU3b95IwYQf4yy1Xa8JE85miB8XU/UThRrZczOmdsiNPQgoOLIdHcek6SyRp30OeR1oSPVxG9c3H5C2RN5Xux9SneKUlJEn8NossN1rdQVc7y9kkXGlMSFeXKHTvgUuecznOdUw574xp8feEqca1xjRGhcf6VQeT5gvqVkpsamw0uNwuJditsND5rKDsnHhZfzloxW8DHKxHi0NARnlgr6nf0kEFDFBGfqdB0KZuu1Z8xy2ll7BmQjrKtMrnqCPLhcaI1jGoPux0eCC/mPaFDmo1OzUFTK9GXmvBG1yixLo/LqsC188D71EpXoV0J0WXpj4WCKOGygrUc54AUVz+QmKeuzDF7dPQpFCm1z9zfUCLYyQEyt8oTXqXVYkcyTJOkX57kTdZdvg+F/eTiiAouuMox93KgfqRflvPvfVXtmqSemDaDS3Fu26FFzYkFsdJNdV4G9jSLCb2jxSFpX5u6Y6eGoSoM+/hC/1ztqKsqplpa9tQ1PIkcUeJKhYrh1IsVRZV4MOX1LeSbpf12Ge7zQ/DXtSfn5xGSxX5iD/foye48ere3e+2tEQX54HKDUxwWni4Hrw1kQ2CDHhBCsrTBt5AbFvlVlN5r85qaTFj8L4RQJ0xCjatTR1JI3Odl3nZV9AhZ9OjoAeyD36ODYF5e4G2lDPhohCnyEND2+ekBmxzJ3O91xZay5ZFMJpVozwuwSlZFzMTtnWg8s1Xco40d3eUlnUzWWfiQa6vWe31No5XEbqDgPHy4SzRAC3ZuvINz6sZDOfZdhxe36/X4Lnx/
 GDL0e0+G
 jrWWcVAW8HYoQ9QJ4OOh+WH0AUwJ+Mshl0XzoMMTivoVAAL7zMK/7jVW3Rrx0TtWVAhWUWvd7KnRsy6uETOJiseMP07rY/a4gMjzLu7SYZqBifb5KZ+Hws0gG4aoyD1u5vXkh9oUHWKZDZiP7gbJoOK/5xBIEbEREtKAHp0QMZRvMvPfWkAPBtM7rZOZRXcsWnLMxTAAJOYqVLEcW7mwTY44FyMSdQ7mn/A/qQS43z5Q0aiAPSPo1W2v/lPIxx38hkD+yhLuXgbPb3zLFEC3VGonW049RcDi4OuBwhhXhAOtgx4flPG7MLkiQ3oLo3loMFSkFvIB/BPJ6rkNXKTX7zU5kLlKU+pVpK1vRDrRZXKZD4ktMZHYLDwq2CS/fYylJHjXIqO9ScTbfzqItXjFw71d1kxU+krE8KO5/SlOYsSp2oubzc0jAGht9b+qUPx+zgHvhPD4PQxxbHXssn6TqW8UYbbVLfHinCBP/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 09:23:35AM +1100, Dave Chinner wrote:
> On Wed, Mar 11, 2026 at 11:43:58AM -0400, Johannes Weiner wrote:
> > The deferred split queue handles cgroups in a suboptimal fashion. The
> > queue is per-NUMA node or per-cgroup, not the intersection. That means
> > on a cgrouped system, a node-restricted allocation entering reclaim
> > can end up splitting large pages on other nodes:
> > 
> > 	alloc/unmap
> > 	  deferred_split_folio()
> > 	    list_add_tail(memcg->split_queue)
> > 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> > 
> > 	for_each_zone_zonelist_nodemask(restricted_nodes)
> > 	  mem_cgroup_iter()
> > 	    shrink_slab(node, memcg)
> > 	      shrink_slab_memcg(node, memcg)
> > 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> > 	          deferred_split_scan()
> > 	            walks memcg->split_queue
> > 
> > The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> > has a single large page on the node of interest, all large pages owned
> > by that memcg, including those on other nodes, will be split.
> > 
> > list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> > streamlines a lot of the list operations and reclaim walks. It's used
> > widely by other major shrinkers already. Convert the deferred split
> > queue as well.
> > 
> > The list_lru per-memcg heads are instantiated on demand when the first
> > object of interest is allocated for a cgroup, by calling
> > memcg_list_lru_alloc(). Add calls to where splittable pages are
> > created: anon faults, swapin faults, khugepaged collapse.
> > 
> > These calls create all possible node heads for the cgroup at once, so
> > the migration code (between nodes) doesn't need any special care.
> > 
> > The folio_test_partially_mapped() state is currently protected and
> > serialized wrt LRU state by the deferred split queue lock. To
> > facilitate the transition, add helpers to the list_lru API to allow
> > caller-side locking.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  include/linux/huge_mm.h    |   6 +-
> >  include/linux/list_lru.h   |  48 ++++++
> >  include/linux/memcontrol.h |   4 -
> >  include/linux/mmzone.h     |  12 --
> >  mm/huge_memory.c           | 326 +++++++++++--------------------------
> >  mm/internal.h              |   2 +-
> >  mm/khugepaged.c            |   7 +
> >  mm/list_lru.c              | 197 ++++++++++++++--------
> >  mm/memcontrol.c            |  12 +-
> >  mm/memory.c                |  52 +++---
> >  mm/mm_init.c               |  14 --
> >  11 files changed, 310 insertions(+), 370 deletions(-)
> 
> Can you please split this up into multiple patches (i.e. one logical
> change per patch) to make it easier to review?

No problem, I'll do that and send out a v2.

The list_lru changes started as only the locking functions, then
things kept creeping in...

Thanks

