Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE9B606A337
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=SKGsWxO/
Received: by kanga.kvack.org (Postfix)
	id 6BB866B00FD; Mon, 19 Oct 2026 16:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DAF6B0101; Mon, 19 Oct 2026 16:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533CD6B0105; Mon, 19 Oct 2026 16:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6686B00FD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:22:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C59914073F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:22:05 +0000 (UTC)
X-FDA: 85340497410.26.4503D71
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id A1D0C80005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:22:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SKGsWxO/";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792441323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaZswgjMQxqUYMWBnUZYKi38KmIZV7yoAiPyk8ZDoPQ=;
	b=7YMzWlRFWt12kY+MjgNb0anPurMR81XI79MOASrPP3ajQRyBDkWHgpvex8sgBY0nImjzaF
	C8wiY840Wd42P8yEyUVd7IcmE8kcRM1eOgzuo49Y/CKCt1s2isiYDUKJv/v1naUyWYFDtZ
	Ii4u6mibvJsSqRgPeJ24TjUPBAPeZ64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792441323;
	b=HE9Xous504RVi0hmNR36ZuBWoLGY86XyKZ18E8zsQ91hNexKc8hrfmtzNS/x+9s8IprVPp
	574bvyUNJfCG+pYprmfAhYAEKIDwNC9CIcqNt2mYP3kQzygCtY0i+CwjwNMJEWpNUYuLuZ
	uTsJaGWIVoYgCIBvFL7q2jZAkx5e5pU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SKGsWxO/";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e515769d3so235454485a.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792441323; x=1793046123; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xaZswgjMQxqUYMWBnUZYKi38KmIZV7yoAiPyk8ZDoPQ=;
        b=SKGsWxO/fcy/lD/Crq3JMx56hZi4bf4KAsxlSctm8Uvvafv5OyszUxhEizDdWGkkcl
         rhiwORvQAoidoqt6R/k0eozQ4xN8Z/Dcq1AVK5IdKr2FX9f+/PywODxLsYcGBQ2B3zdu
         DBUk4ZAqYMRVNNyOofkw9DdwMmnK3QcABwXaU93l2WP9cjGr0vS6scOrxPhtuc5AlR8r
         pht3sDytycPHVA3MApjiX4Z7vMUFShUASN03JUSJzgn0PwPHqCD86JtUg+i/N/LJ9Sqp
         cEyEQF13/Pa/AliPnKwQWqDxQPga5jfZlOAVnKTlATsExE/6ex4CTNhiVJfG8TSkDcgy
         69Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792441323; x=1793046123;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xaZswgjMQxqUYMWBnUZYKi38KmIZV7yoAiPyk8ZDoPQ=;
        b=KSpMIT9Nfj0PMNbSPZooyOnjywPKRWJnn8WAfjIQwxPxG/5pJhkL1gLlr0N2H6ijqS
         piKzXrd2IkJE6YkxC9Gc0oTIPj6BwYrV3mfFsQ2ajwZAa60citZEOIlUoWqcwaJFIcET
         E7aGcwo+5qYvUbb/mxBTT02v3i+xF/9g2nn3b4CsFPP4fhknkRyfi23oeFxAMVyQmht6
         oeWChxyFOMi511VKPkgTr5RSWl5RLSHoGhu8rtb/uH+gPdQI6Puv0ECsHMxKtFTyB8oh
         XAD6Jc6UfElg6bq2877kRmXLv9B++z9yDxYAes7xIa6n7PJGCdgFSI04CvYnKaHbzemx
         SMcw==
X-Gm-Message-State: AFq9FYItB9s1TJkS8Fi8u+SaEjXO0TfAMHHHUh8DsdrNYbp/4tVY4Fa2
	QFweKCn/VkIfA3oU4oFxuydYpsa4GhYqCHpGySGrE+2HU12IVFsWd9REC7tQg/qoYxo=
X-Gm-Gg: AYBFou0+VTDkhNmxuNWJnM0TRZEgN/k4V2nMuXckfnBLdNxVREsQlNETfjR1llmCcPG
	F0MXayqjTpoSwDQnJhw/plvx9y9L0fslK9irNlHkG/U3jIIy4UUcCAmaCTA24gkt68DSE+8VH+R
	8INEJaIeYQL2ex5GR9ng17/3rAPlYqzUzZfbtZzJGuoQPd83Jor3KVNh7jAim+9G7iQS8f1viiX
	CFv2/d2teviizj0hjene1R3ElKzAg8HESg2z8DqfCKsSmGgT5wVLCbiESyZIUFaIH0sOgt2Lziu
	jh95Tlt/acKQqxATUBx/hKrhEEJ1uAHo5cZP5vDH9lQVsBXymWSmXGlt6YNJqaJFbWozcRouNCR
	YReZk4C6OInBVE5CUMTOj1iVxPUlvocn8tnMpvZhsHlqEvHMiqSPNng5DyMfC1aqKQxnQmV6SYg
	Mlg70xqPJXtMSfx/5UHCgdvs0m3KjkiMo4l9YKyZGpoRKPs1nr5Q1wZPkfhNNTAMW660LW2VD6y
	1FgxOItto3V8zHFD8gk5Er72LFKQcNG64s7MVcgMZrUQUP0jQLgrVg=
X-Received: by 2002:a05:620a:258d:b0:93a:f9:614a with SMTP id af79cd13be357-93f29d3838cmr1482213385a.34.1792441322748;
        Mon, 19 Oct 2026 13:22:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4b0b9098sm46239385a.30.2026.10.19.13.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:22:02 -0700 (PDT)
Date: Mon, 19 Oct 2026 16:22:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, weixugc@google.com, aneesh.kumar@linux.ibm.com
Subject: Re: [PATCH] mm/memory-tiers: reset demotion targets of nodes without
 memory
Message-ID: <atZ67m_JYJADzY-C@gourry-fedora-PF4VCD3F>
References: <20261019184712.3422641-1-gourry@gourry.net>
 <DM91RXTJ5EFF.2YQARRB6TXQIK@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM91RXTJ5EFF.2YQARRB6TXQIK@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1D0C80005
X-Stat-Signature: 4o4gerybp8pqohowrnnrc6dqrsrfosoo
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792441323-847397
X-HE-Meta: U2FsdGVkX1+9Yf2h4OQNGJthcZQfoMo09sJrm5GK4SfyzinqvVSfHlE5fHRdDNg8Dz50nRRrYMrqrk3VisQxBYuHxFJ22Iw8hx04W2jquakbtnQ7PSd0dD379ZPFqej0Qh+OdR68zU5x9pek17/KaVik1jwzW9YCklrqjWzLapsIMksJtIozjaT1rOoNzh3hBnxHheDNF/BTo/RfVf0FHy4tUMS0vK5MejJJpsJu3DHi5Ls/Xr6KDdy8lWmksj6GIDik4EYqe2E8A/DMiLI2mbPQoQJbqRJQXLkZX/eGzcgnCB8WkRLYMxKp5bvaiL1aNoPXDaCQCl9DudU8+KSdLk0orqCjc2tuB1eLrqLaYzWce5WMGNZU+H8yANW6vmKcogCymx0/6M/B2uQqb9KAqSSCM+UozmJXdXrnEzifzaOvQuyGccSsBB3Cfn4mbq5cD/UM/Z+RfI66eDRdYA795zaa8t8f+js+ZwfiNlxBEGbjEgSSL7DWTAJ9n3LRqNzjHbn08bHrJHLvQAfSKjp4BS5GSwfzG+ALssltcvux1pN/6kEl4UMKZSLoo5d167b8sw1lVDdtxXv2E2Vw+N4N9MwnwRDgFh0Gl0rQR+4cW/gv/wfnltxIuZ2hciWHbPjXAoDd4ngefcf1evspYMenwyyczJnZENQOIoAkZ1VbUfXcFqtbr0OHTb+GVfORvSODFR9+3BbB3VEsqogvAcT0TX+ztSJ9HwcHM5eYnwe/I4nJlsyjtwwiU3DsrF6ffnM6fLSh3K+St03xzdb0cURV5GgwvlAzOYxJpUs449WnRmT3uayfIXcEsQFcc/y4KZHdzkQvRKey1O9Y9oJZUtyOm78kad6AO8IB8TuLTbhl4s36xK3jzMqZ4uo49SHgFcCTNJpnzlc2tvP2coAbUt6Np1Z1+boy2pu7FNO6nyU7yoV3Ztvtrka3rrSolgcTjDuUfugXSiKloDPWRJuFssV
 jx72loNm
 xOuadbM4/auSC8S3WsIUe/kFBVVv3+CeJfjFDBjvNxlXXNdDEqHZSgxXyJXf9yUNkfhwQ3/EIubSE8tuhPgSOkpqqWYpYCOITRjZf07BGm+75aCnoM4oKEfmsF43KBui2Mk85hQVDfKpTa6wesaXYxzqFCRYI1/ohmEmB6H3covh8GAP8PmX5f6rxBvi+yWpQghKPC5E76V9U66kridX+lMMEqMQjRlorUjOQGsjyfvjlwqlx5EdSHMUih39dPBTMtlbIPRxjHlcnmAWwiQlFC/Entn/HJAW0twz2gzH1IXSeSYG3fRp1irUgqg8dHEx4GLwYrMwYVDEcu+hkU8K6cOMXBvPUVTlcqfxNNTO+rn0aTYEyaAXLTCzgtDFaQUZq5JGSi/FTC/kGQQMYA7iD1YJv6+fgHfzBqLzrd/N6GsLVwgepPIiuG1Mk8rkzVXORxTQmIQYMiy8W41Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 03:04:45PM -0400, Zi Yan wrote:
> On Mon Oct 19, 2026 at 2:47 PM EDT, Gregory Price (Meta) wrote:
> > When a node loses its last memory, offline_pages() clears N_MEMORY
> > before the memory-tier callback rebuilds the demotion targets.
> > disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
> > keeps its old node_demotion[] entry while it has no memory. Before
> > 6c542ab75714, the reset covered every online node.
> 
> establish_demotion_targets() uses for_each_node_state(node, N_MEMORY),
> because the to-be-online node is already added into N_MEMORY?
> 

NODE_ADDED_FIRST_MEMORY happens after the memory is already added
(though not necessarily online). 

NODE_REMOVED_LAST_MEMORY happens after the last memory block is removed
(and therefore N_MEMORY is gone).

slightly different timing for each event.  There isn't a reasonable
change we can make otherwise.

> >
> > A reclaimer reads the stale entry only between the node regaining memory
> > and its targets being rebuilt, and it filters the entry against the
> > current allowed targets, so there is no user-visible effect. To see it,
> > online and then offline a node's only DIMM: a debugger still finds the
> > lower-tier node in node_demotion[nid].preferred.
> >
> > Reset the targets of every node.
> >
> > Fixes: 6c542ab75714 ("mm/demotion: build demotion targets based on explicit memory tiers")
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  mm/memory-tiers.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 25e121851b586..7197f1a67a340 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
> > @@ -378,7 +378,7 @@ static void disable_all_demotion_targets(void)
> >  	struct memory_tier *memtier;
> >  	int node;
> >  
> > -	for_each_node_state(node, N_MEMORY) {
> > +	for_each_node(node) {
> 
> I think the above code deserves a comment explaining why for_each_node()
> is needed instead of for_each_node_state(N_MEMORY), because when a node
> is added or removed during memory hotadd or hotremove matters here.
> 

Sure.  Will respin tomorrow and give others a chance to look at it.

~Gregory

