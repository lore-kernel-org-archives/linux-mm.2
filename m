Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3AC606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lML0ho4B
Received: by kanga.kvack.org (Postfix)
	id 9C4386B05B1; Wed, 18 Nov 2026 10:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975C76B05B3; Wed, 18 Nov 2026 10:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8674E6B05B4; Wed, 18 Nov 2026 10:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5789D6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:13:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAEC6160790
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:13:17 +0000 (UTC)
X-FDA: 85448583234.13.13670FB
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1819C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:13:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lML0ho4B;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795014796;
	b=QkhfgB0WvBNK9LwVkqCmkHruan+U9wH7lB+4RsW04f7CoGZWuAHha/XqC3KnOxeIvryF01
	0PMXVzUmK2Q9douP4KaeCDubhD7rzzxWyXri6DV/L3jCVJlrfoI1txCgA8RhBk9P4av9sM
	c2jkfmrzuFwlDTcbAtAYXHtuAycgu/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lML0ho4B;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795014796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMVcoG7RRC5e+6Od8G0B0oNhz3JqDhu+jU7/dRmM0d0=;
	b=qgjmw6Q12C2VZAjDJlQRZpxI+ewEvfLIS6/XF4w+ug/iMkm+kngTefASaDu9CXxiqJbchg
	xKO/TJJDkDMrUrv3c2+42CWkYNuQKU84myfOZGTnwgJ0o3Gvd+O+WicdPS08jyEsQeGnfi
	pfl3VIUONYshRKzQ5ZMMDhj2K88mef0=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-921159376efso10661216d6.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795014795; x=1795619595; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RMVcoG7RRC5e+6Od8G0B0oNhz3JqDhu+jU7/dRmM0d0=;
        b=lML0ho4B7L1OMk7cj73ksIYLBW/Cl16GqJT1GGRz4OHasI0cQvc+NXkSuxEhlqfUz6
         miXrB5iQUf7fGjNerDxFvZv50dSvmUWl8YxtN3IfYFrKzjSPc/quBSgclXf3VrN47Fwp
         TKqQ2TD1FxyE59gwphZrrIrCAfHqrMzeX5lfPfocDIM7CMJ9llkv+XG1DbnboFwBV81X
         21phmhWdx6wlDtdA8RVaL738yOcrBc5JS7SqUGL6cjF/DY1h6i0RBHd0TDXXP+OT2wzm
         Qnm3/N3M7+V9sYQvJczgG1sxSIeTs2KBn5TZ+bSGuyRG/42XFEwxmV3drrp00henYC1E
         At/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795014795; x=1795619595;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMVcoG7RRC5e+6Od8G0B0oNhz3JqDhu+jU7/dRmM0d0=;
        b=2Cte8bkxGluvd7lz/CBoxxmNj2u751H4KQCtsoXruYqXDcUHhW4XrC8i/x0CoUyygH
         JZWEVr3TnnWPNDDyACTfhqA5Eoe70F6FkNrUxvYFczXP8m8cMgh3ee3XLBclEONGaNhe
         3G0tNbRjOeiiiCd0zcgV7RHV5AIO/aMcbE94SbS6pUtvreDUlb4aUuzcP4yvSCxIl02/
         odfRLJCDKTbF88yO1RkkIuFy0qtS43UqDbxJSfWNLwxzJER9oj1U/LKfu+9gt4YcoqfW
         TRvAt0D74b8XV3QBlnOCLpKrR0Jojx4YBr3NG3HWRoxfNmozT4dmF3vKlcyGx3t1rqgq
         Q5iQ==
X-Forwarded-Encrypted: i=1; AL+hErEdA9T1afGzJzh21rPQ4PIo14A9MJOOykDZrYL4Vpe3BgomtyC1VZxtdkmN9nTvnRRQYzv/XcUayw==@kvack.org
X-Gm-Message-State: APuU4Z+RS8RG74gx2Qr7Mmelw1ZggfupWCpmhhGkq7sGdUEv9r0j7Hel
	5Vri5Cnjd38/11MSS0Oc8BpX/s2ODWkduDmMgOWkvK2/7dvNVcAVh3Hqdhuy/JRMZyk=
X-Gm-Gg: AYBFou2MhLoJqcNZtaj+yx5BAdRi0gPYesWDk8aTxlF8AKSx1EL6Z9lhcry5GgE8nr1
	a8DJSMcXaPvWMyfVGKd7VxJyHS+WmuHMHlkAZCUQtwkwGZPISkXrxbea54FH8A6km/myJYAmO31
	RMaGEQRL+BSOOO6BW8lBDtAAG7Rs/RTozEnDhKH0X5dcfx9vTp3UFCvltIZRdgo7pLLcfj99Vol
	8+M8brYq88KCaYlT0uiRTZ4C0zxpFR+0bixYs0DDiwS4nOEg3hUCDAn23+RXezYqXq03/uqdds5
	TCYoRrTtkYfbpSMsgUtNG2zpYA2y3/HxiXWBmngWU1ARiAsIRIsnMHLv2HHHvAnKS+kPxk1tSZ3
	8t8MmI/cVsjenzSBGkO2+n2Bku5aCF5avBE0ZKgOqMIBm31bHHXqcqwVEFHpNlHxW1o05AdacKk
	jFdXXwFu8OkPRhhtrm6ZNgzGaPDGupuOWtc65HF/j1pIxpx2M1Ly0tUM3vBlNzj7hYp98zpfKXj
	utdHp13YU+JcxhPmjxkyPez4MhG1JfQhSPYjG63MusHWGcoSHdtklLWoXzCe7h8GMgVDQuSDik6
	eymhzGELFjQ9IroPQZ0nvwiRsInx+d2pYeRYbbn5wrROlddSwaeqZQzRxkB60rkH5VgOWdVwn7Z
	W4cQCDRI=
X-Received: by 2002:a05:620a:444b:b0:949:6d95:f63a with SMTP id af79cd13be357-94999810096mr508584985a.78.1795014794676;
        Wed, 18 Nov 2026 07:13:14 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d70a8fsm23976506d6.30.2026.11.18.07.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:13:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/22] mm: introduce N_MEMORY_COMMON
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av1DvCQd_OvkGgLU@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <av1DvCQd_OvkGgLU@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:13:12 -0500
Message-Id: <179501479267.1206716.268867271510310543.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: F1819C0005
X-Stat-Signature: akfg1jjcaqic3s4ydnqfazz8ywqoea3x
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795014795-592825
X-HE-Meta: U2FsdGVkX1+OLafu62VPcMWOtic8OzxebTKgj/KTdeElhxPxGtxuVDb9uonqo5SzuoYpmoyueNx09cuTNnp6iucoLa661HGiqzocfwI0964ldNJoW1JCTdJLKUN1lk4DcO1XPfoE8bAE9C6jWeqgdXRCUu54zVSYyuI4J0jMVQi1fcdGnAASoDkcciqyyN0WzewXqHYmtOZRGxkha5wVzfZxIylzkORGlWKq++xLQG/PqlF0CCXZwbUyhH9l7tH/uNhEfe9OYcSTRMsa7tHQ7Abm/NvNahR0fIXD7dPyBvRCnmLdva/9ojEIJiQ4Z0K9Bsg1AEKwFUqV5+6qUIlV+P4hfvjDFmknFP7gtIlHetDxJOoMld1vPCpCpdmba2gUq8kpg1Gvt0Fc9VJnMqNRiPx9rKRWPoWO3KRQWhaHZOAMeMuoJctan/vf3idsby0Tq5trGUJsh5VFdAnwC259sUpORtk7g7iXmkC7F6/nrgOG+4uJeCZSAJVolDvezhlgheJK8LR89Y/bPjAiyIlF/YW9yFY+qJgVN964FtIyC//u/gD7dacDfXMd6Xu3H2fu9GtX6vfZ2F6zeohzO4fkdF6I/2KpJJW3zNbgS8o+w2ocA0+RoUmSWMFKiy92Y7jEQY9mR+TE2WEGtYqLWzeTIDGboFqCBhDwZUJcnQk4NOEvDvGhm87aJawsnsmmEYElTRsfBkKNTU0vqutzB5OCeioAqosRvIV+Y0Vc3O7zQVznYX/xI+5nnhS6bLL12UxGVGKQ/Qr4QH3riIuSGDd8tbHxb63dKt7/mzvY8af3Y5Dvpr+Bq80h2PaObs5rvt5Fe9Agdb3PvRMeIkuMjbnGqC4zYNcxElL45HC2lSMUVEnbclOdsf0NZLErdhjKh9mO6rT4AYSKa2vbjIk0UwnqTWkQamzdUAxcipwJqwcd6o6HBiJg+JtcZNywwlYJ3fH5iicdEnqE+F7AXoYmaIu
 Fmty0B1c
 4vk4YQ/ohq0nw3MyRRCQumUcMfq6hENGsh8dX6gPa3nMmmV/zSY1zBqa+b3otiaKoW7umFEkuTHTIBlvZwUsY4A3pIN6Ci2Tdu/z/m9+MXb3z4T1H8z94frYy9dYrD4/498Nnc9CY6cNAPUxOfM5GmDxSNq6cqk1AZMYkx79HbmH3r0ttoglqGFsWefSHW7pUTzedHzFH3anA7gdKXQ9t8tMuoptfJeQLJKAkIwLZuGFaC4ahuXIWAbk4gON6YBU0bCYMeRm+0NMqx8futvVo+4VlGSjJiF4FtiQ1h+t4ZPJVaSO+VMeGZDYrR8yPJekffBCR39C8ah2udxZaqt21ohUvq3I+E9ljOvJid/T87mEzKA0jNJO6vRtVif3sOq2KzlTv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 15:01 +0800, Richard Cheng wrote:
> Hi Gregory,
> 
> I've browsed through the serie, I'll go into detail in each patch
> in the following days, for now I have one general question.
>

Thank you for the read and the feedback!

> I wonder how the "common memory only" rule is enforced ?
> 
> As far as I read it, there're 2 ways:
> 1. The zonelist, you build them from N_MEMORY_COMMON, so non-common
>    node isn't in any zonelist.
> 2. A check at the call site, e.g. node_state(nid, N_MEMORY_COMMON) or
>    folio_is_common_memory()
> 

Those are essentially the two cases, which are already present in the
code in one shape or another in the existing shape:

   node_state(nid, N_MEMORY);
        or
   folio_is_zone_device(folio)

With the exception of one or two places, the series largely modifies
these locations to use N_MEMORY_COMMON instead (or in addition, in the
case of zone device).  There are a few places we add common checks where
zone device checks were not already present (because they were missing
or did not apply, usually PMD scenarios).

> 
> Code reaches a node's memory in 3 ways: zonelist, node id, or by folio.
> I couldn't find a statement of which mechanism is responsible for which
> kind of path.
>

Being a bit more precise: How do we reach a node's folios/pages?

 1) through some kernel structure, obvious examples:
    - page tables
    - VMAs / pagemaps / xarrays
    - LRUs

 2) pfn walks
    - memory hot-unplug
    - contiguous allocation
    - DAMON

 3) page allocator
    - freelists (page allocator)
    Sort of its own category since you ask it for folios from a node

> I see some consistent issues,
> 1. zonelist paths are covered by way number 1. Some of them also carry
>    way number 2, some don't
> 2. node id and folio paths can only be covered by way number 2. Some entry
>    points have the check, and some do not.
> 
> I can't tell when a call site has no check is deliberate or missed.
> This matters once non-common node gets its own zonelist, as patch 4 metioned I think?
>
> Could you clarify the rule ? e.g. which zonelist users must filter on N_MEMORY_COMMON
> themselves? and why the zonelist alone is not enough for them ?

Some of this is obfuscated by the fact that the existing code already
does this filtering for you.

I suppose I have some premature changes to add additional filtering
where it isn't needed yet to reduce the complexity of later patches,
but I can see why this is confusing when introduced by itself.

Consider this:

-       for_each_zone_zonelist_nodemask(zone, z, zonelist,
-                                       gfp_zone(gfp_mask), nodemask) {
+       for_each_zone_node_state(zone, z, zonelist, gfp_zone(gfp_mask),
+                                nodemask, N_MEMORY_COMMON) {

This is a bit of a preparatory change to later convert this to:

+       for_each_zone_node_state(zone, z, zonelist, gfp_zone(gfp_mask),
+                                nodemask, N_MEMORY_RECLAIM) {

It looks like we're filtering by N_MEMORY_COMMON, but we're actually
iterating the fallback zonelist (constructed from N_MEMORY_COMMON)

  struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);

Later we update this node_zonelist() call to determine whether the
private nodelist should be walked, at which point you do have to filter
for service support.

> Whether every path that takes a node id or a folio must check N_MEMORY_COMMON, and
> which ones are left for the feature bits in phase 3 ?
> 
> Let's get the rule settled down and make it as the foundation as well as phase 2 and
> phase 3 ?

So:
  1) If you're walking the normal zonelists, you're already filtered

  2) If you're walking nodelists, you need to filter on N_MEMORY_COMMON

  3) If you're operating on folios, you need to check common_memory()

  4) If you're walking the private zonelist, filter on N_MEMORY_COMMON


So let me do this:
  1) i'll restructure this phase to omit premature changes like above
     (they'll move into N_MEMORY_PRIVATE and N_MEMORY_<FEATURE> commits).

  2) I'll restructure N_MEMORY_COMMON commits here to handle cases 1-3
     above in that order, and that'll hopefully clear up the confusion.

-- 
~Gregory


