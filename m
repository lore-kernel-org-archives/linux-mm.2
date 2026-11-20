Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBB2606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=OlOdkf7i
Received: by kanga.kvack.org (Postfix)
	id 54E4E6B00EF; Fri, 20 Nov 2026 13:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE816B05B2; Fri, 20 Nov 2026 13:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6736B05B6; Fri, 20 Nov 2026 13:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04A006B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:56:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CFD11C20EC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:56:43 +0000 (UTC)
X-FDA: 85456403886.06.4A842BE
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C0E414000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:56:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OlOdkf7i;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201001;
	b=ETZ2MsIBWxQjh/rOSl570+IcMzT0eIJJmaXJJZa0xr86nUo6XPkINg9KmjVTI+whVrKil1
	Os/a2/grp1b+OgRUWip+pEy3E/ZG2ajVSB1bFH8g5ZfklK1Noiaovz0cBBU4jKq0hZIwuh
	LGxgGTRwSy4pIBdgWXQcP/6DCfevNJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CO2FmI+t47mxhoA5B32c/6+xEdoEj1zDOKWg0tAGKfI=;
	b=kf4b5lnq2kk9iWK2A6ME9XIpNaaDJlWDWt/U0UXs1Uj7PgE6XUeFGrGxCLbURcaL/l9tt7
	pH9V6mig1vsWyynrWyGFP7GIfqoiDGe6Wt7LusPla0AyPWE8rAAqSBmh350WewqYEECqFq
	EhnvIvQbAAbnr39kl/bPmobSwWKV03U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OlOdkf7i;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-9212a5a66f8so10700376d6.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795201001; x=1795805801; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CO2FmI+t47mxhoA5B32c/6+xEdoEj1zDOKWg0tAGKfI=;
        b=OlOdkf7iqUnmFYqs/cyiFLSywMlVre/MZd02OtnouvTNvlnARgPRFAtM8xg7MHfg6u
         +CslG/cP1Z0eTD3Lo20pYCLrmDa+vkOs4vC6Z0tR+9KjLkfwMT3h/ElSzJPnjdZtd4Mo
         1GKhtxABpeTyoaBDLnPBSgOfdPgJZugMFamgZJQwZ/uVAwYpM3/YzkdNop3Ypga8HSCA
         7w5gqHekEXreZo4LmqGXJiYapBj5GzdMBtruTsKESBni/OdSuG4btEVZgmMISMhQQeWh
         DMyQSp2cCCEacG8rDqpaiKta3aB1huVincrLn1L1HuaCWH3pzRYSXEeE0tsCqjQayH76
         brNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201001; x=1795805801;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CO2FmI+t47mxhoA5B32c/6+xEdoEj1zDOKWg0tAGKfI=;
        b=p/C2bmoG+uzbAK3h/wzSte2JciEn3uhMQVseC97oJIxty9Dul7fcsiQP6Vha1MrahJ
         Gbl0xskfCgr0/f3VXWCFtFcYD9GlUiDv+DwsRDsa/75ABaRv6q7wcpv9pOIxRUF/tTqY
         qIF+bEjiYa/tOpmrMTVYwa2CE0+zM7GrIi1Bzt/GO416lCx3tT0kOTwiH4QXuYTDbAHO
         XSnlOoi3IOrEfkVJSnLTNFn3lk+du91A4XfXnQO+WJc8g8CISbzcWvs0Mg/K+qRHqEuZ
         fNBzgRbTXo7FnQpju7wxpjK0xF2SmgR4+W76oPLDrErt6pELlOmCUC5HpJTSw7S1vTfF
         Spug==
X-Forwarded-Encrypted: i=1; AL+hErGX5Um9+GrWwv2XJQNXrQKGd4Usd1depxy3gtbxI33oYD3Ngg3HP4IzORNecNnWvDjzAb4hyEnInA==@kvack.org
X-Gm-Message-State: APuU4Z9RpaqSjUX7Ff8lInQeUJb0lznqgCD/NY5qdzoG0zCdanTmR8lQ
	RzSbwL8nb0FgsO+IoyDHeNZflKn/BJaVpmCEwtFsjEgjHXBl5KhsibYTBQBpTq1lAzw=
X-Gm-Gg: AZFdTZccx/gJEMQLhbvwI7rI2PQLFSZamuLz5K+bIY7QNvMTMRj3ufHPDWobeSqEuDg
	tOLq3f2+2pKD/wOaoKarb3KaXrR2QOcNi+zPDR1h31bWflfNr2NpZ/84208uI0cwSMO8LueTrB+
	f/zNIR0pg377ZtENWJ9N8XoY51FiMCSqhRTbL5aGdz1OFDQHQKYuk+i78q/+bJl034tyYbpfvUj
	k3BfZ2zD2noVa+avNDGWRgnQqa1kBArREeQqjwVRgfQ4qVldCedOIO3WZMJvBsg9pMi9rylzHn8
	6TDK+ibkXFZdMoZ8Z8A0UkuzGD0iyM8Qa48bgnMqGo12z621EPe0/A6sRehOQ2lTFcJbVUavHMJ
	jSRbH8HMfeSOo+PMdheGtQXZxMazWvNiETEfOFn1V8XeaPKPUAxpcoFdM463vfsASjI4ab7itDR
	nKnBisnH1sjLQwiwF0kAg/oskxg3lpBfMRibZkmB/3e26HZGR/kUWFmxwsc6bGQlnFUnCyQigu6
	xMOLgj0fZ0POO9OVEeVHId6vGDnb2QFJKePi3Ex0tg5VyqKQE1koV7EI3v5s+T2FdmpeR2uLkWO
	3TFMdkHqH6XVTNKmbkph1o6vLv3K8x9soHeFpw3r4Lz+/Ots3wEOAC6k8BZm7+YxIt7PZCCjcFT
	4koJ7wfI=
X-Received: by 2002:a05:6214:320f:b0:921:3541:ed1a with SMTP id 6a1803df08f44-9213541f3eemr56576466d6.32.1795201000560;
        Fri, 20 Nov 2026 10:56:40 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921366d853esm26687146d6.27.2026.11.20.10.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:56:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 54/60] mm/migrate: route explicit NUMA migration to
 private nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <sashiko-outbox-225861@kernel.org>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
 <sashiko-outbox-225861@kernel.org>
Date: Fri, 20 Nov 2026 13:56:34 -0500
Message-Id: <179520099481.412063.3035407964761903218.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C0E414000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oeti178a5edzqhz6eqdaj5xxusafzbi1
X-Rspam-User:
X-HE-Tag: 1795201001-923162
X-HE-Meta: U2FsdGVkX1+Z92HH44jrEeQmfvEQafB/W9IQG7NicfrI9mFxw1v1izlN8ClZgStcARc5QUUeF3UvNPQI7FPpP6yFaAWwaoNDU4HxngFRQip4qUkwxPG24PMZGGzvbLD9v73tI6SS/c2IjzBx6As0zX/OrsXi8b3AuySf2l3DJVB7Di9WDioz2AnfiUNefBC/QAUDJGzjpiuILPB9qXJlfPk4BI3zzVIgzyG7PWCVL8/KEsYDAerfiYNQO69U+j4M7umMr14FErsvbcHd98Wfwzs4AUNBrwz0cmpj0hUfxdTX8iLHjqr/xV8Hs/nt5Mk6saepCfAv3Ucmvr1W3uU6sbLro89Y/giNcsMY//RYz9SWs/vPKNY7pytRhyuYFmaN1HHPPG7/NdsL6xcdbpAkWu1edR8967LpLu8t+wJq7P+cvGNrQ9vQv8biG65K8UVp+EarjUSM68buvA2+kQOp4V4Mb6tTLdDNDe2t/+0sOjZ+wWhi7GbVHCtyjh7CAfGSY1alnEpum88GRMStOe5i648DT1tR5jj92qrRQBAw++03O3XIP49fizNIq+yQZJtedfFUj7bxQKi2GViMzyyBvE1gVp8sJMK5A5Ah6/vaMj+mkeNMiDdqugfVufmzyQLUf9PPnxSaL3xx2sXn7YmodlkfOzsZzwyEgob2t7DhIsPQXip65CCVkT9tMn7/4mKFBn7bSgfGxFrqeKdx0y7LPRe39JCyhn8aY0fblU3i59ZL+2XzvkpO9P6np7JjCbcjLSbVNTqJKW1HbHE2azoHb2gZssNJxubE5Zk7sNl/hgVQEz67R1vYkLayFBfhzMxOXfHEvZfMZSP/WAcTZMnLg2MNktqK997V8QS2W0qjMTZkyku7BQs7aJUieY98dQFNHmdJ2F/+xGdBSWzmsZ7MMD/g1d3ocI08t4JgCvvNg84k0iRgnKh3pu447qVlakeCduvbPepbXmutgcqhMe+
 frBzXnTQ
 SCRfJ147LVoZVytIv4q9qwOtVOworwwiPyAV9x3P1nebJRYItnUiMJmXBKEKHzRGv5NJvMYJxhEXLthZqwTcGV0CSUqhGgwE1sy37twBd0QbPFGI8EmbL9mXwkm4PTplGaLvAdb2eXBFGTMAm2RwDqbF8xbiuj4irV6LMUJJqCURO89TRMkvvyxowRXkEPbjpv79NBCnPmCvtYVp3oeTwRWsIEb41UH3zVnPvLC/lRLg7CDCLHp+HPJMHkGDeT71OSaNIFgzfUpED3adbMub/7DfDy5TBYrg/hwe0IhiX6pWJEPxn3qnF99R17JZ0PInm8xScJuXX/US6RUl4uUe/FUOhWWr+4vw74eU84qbSrL/A7lvzmCmtmYfdlJ4k+XmvUw+ADlzLJClKZtqKHErOPN/L9eglJ6BFl5YGxan9XSYQnMEUQnb+9zxBErkWFpH9jeXONZjNRdjiNQU+xghFMUiUnWTLcCTFH77q39N3jF79tuY18ueyKtvch3PwUC0HGND2S2oZixqS1D3TSb/QqXY4v85PhQ8zvFiCpLnLIX7i5fEaEVxmar2ytUXN4ZStJe+JwA4X00SBisSLoBQ0kr+N/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 18:42 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/migrate: call to undeclared __folio_alloc_flags() in
>   alloc_migration_target()
> --
> 
> commit ca3cf1708bab40e7c2c443ad00cbc882e2163cee
> Author: Gregory Price (Meta) <gourry@gourry.net>
> 
> mm/migrate: route explicit NUMA migration to private nodes
> 
> This commit routes move_pages(2) and migrate_pages(2) allocations for
> N_MEMORY_MEMPOLICY private destination nodes through the node's private
> zonelist by passing ALLOC_ZONELIST_PRIVATE via migration_target_control.
> 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 6791834f14fe1..eda961d43df0e 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2250,6 +2250,9 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
> >  	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
> >  		gfp_mask |= __GFP_HIGHMEM;
> >  
> > +	if (mtc->alloc_flags)
> > +		return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
> > +					   mtc->alloc_flags);
> >  	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
> >  }
> 
> [Severity: High]
> Where is __folio_alloc_flags() declared?  Neither include/linux/gfp.h nor
> mm/page_alloc.c defines __folio_alloc_flags() or
> __folio_alloc_flags_noprof(), so building mm/migrate.c with
> CONFIG_MIGRATION=y fails with an implicit function declaration error.
>

b4 dropped a commit on me when i made the prep branch because it
it was tagged Author: Brendan Jackman and I filtered on myself.

this commit should have immediately preceded this one:

https://lore.kernel.org/linux-mm/20260923211041.3127588-4-gourry@gourry.net/

the branch in the cover letter has everything

I will respin this again, but i'll address the sashiko reports and
let this sit for a bit.  The first 2 chunks are still largely
reviewable.

-- 
~Gregory


