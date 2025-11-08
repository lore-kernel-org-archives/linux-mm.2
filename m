Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BE7CCFA1A
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 05:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCC28E0007; Sat,  8 Nov 2025 00:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94A78E0003; Sat,  8 Nov 2025 00:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA3C8E0007; Sat,  8 Nov 2025 00:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAFEB8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:45:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F60712CF8F
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 05:45:14 +0000 (UTC)
X-FDA: 84086351748.13.20C042E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3CA6B4000E
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 05:45:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rK0RiR/x";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762580712; a=rsa-sha256;
	cv=none;
	b=12+QQr2iQaz7u/z3CAVbEZf0+TjSiBFT6cLu3ah9GncAktpi/am6fqDSQBUFg3YbWd7FDj
	TGZ6+VLlSvwwRcqnTepUSADqj1nQCw2rfjN8Esu59KPgTesePfW7ULBGseuMR77tBP7TdR
	eYO1s6b0VEVsFdZK8VOBQBmBza6kX/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rK0RiR/x";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762580712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qwM369YFl+OLlR0vHxeHaLayeXRWU8S1aUt7oEr33o=;
	b=Z+SiWeGKF/Ub716YHWn+DV+2lqdPYgbbJaFTzbslJVJE6OkjpJeKVBif2ilJ2cEFxzBToB
	Z2xlSz7IQzNdtsTIb1h17XmcaSvz8kJuyM6g3rGOZPESfd2OQcr9KrhQFiYTogzD6NBbeb
	vV8ivyWJAanZwusOlUg7ILNu373jYSA=
Date: Fri, 7 Nov 2025 21:45:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762580709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9qwM369YFl+OLlR0vHxeHaLayeXRWU8S1aUt7oEr33o=;
	b=rK0RiR/xnW4uKGxUrWKA2zRLH1gbP10S7SpXJdr/OVXyGy6ziKfstyeaK9hyE7YFNcmALP
	TuHPNUbimbr7zsvineElD9m7kHKYtYNgh7PRcklXJo12snSmGsargyOwaG+vzUlJTiS6EF
	Qi4aL9bOqvocIHBFhhyIRqDetfzcL+k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] mm: memcg: dump memcg protection info on oom or alloc
 failures
Message-ID: <tawekrqql6efopwac3zrqgrszueampnadqp7s3g7wfvohsiqbt@22ai2cryardu>
References: <20251107234041.3632644-1-shakeel.butt@linux.dev>
 <20251108022639.73734-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108022639.73734-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CA6B4000E
X-Stat-Signature: b1pzy8suqbwdub7yc1u33xxpuomhakey
X-HE-Tag: 1762580711-653346
X-HE-Meta: U2FsdGVkX19oSJmQpmN/BYcN+/pThD5k3AHhC+pIlmpMiqPAJDE7NktXMo27gIFP1r8U0RhrdhmuXLcR6/nGz4oZ+CCUCUejXfj0kMO7f/ewxb5UFqyHpeigP0MHWYxkWvjwbBtuUxNUpNveGPlaJaeYt+EwOkthAYNO/cI/0agfCdmOngvFwAa9yWERa5TuYSgfhUJEBjyLuXQxNjERCTTEjPegbr7tdsVHmoQgxHqTbuL8XMrmkvYVo/LXZJbx+SazpHtr7vFzsBrwPFRfeATLUf/Rb57DzkxcJS0yk0yHew+WtOhUGB0QgdSQjNlAYkRu0EPMKK2d/4pRZ62AfsfsXv0gcs3WIJJvQ1TfGvUr30r6flHlwNGnTPFnG/HEU43mDi20T/iT+DZAGSHpZJMMQ23ceTV/8+AGaVuGOc6xYrBRXTP124yVfAfCIqkz9sOzMqpcWUbxv3SiR1WEoskB+drqsWuy7T841mj26f/EGQopV5QlK5cC0GVV1LuEn2G92BOW+I5try9yVWGPwGPexvsdv86zrYanKNZQ0yZ1YuhHVKo3Fvnk34HcsDtMhBHDtFQlBzMEriwyS+aOP1BLsETDVu8kX6lDD9X0IUMEKf6a8Ml2vbTWLASpBEx2iOt0hrg92cmq3ASMwALJrt6qX8IYmRRNiYhaaR+XfqxbvcEX8IHXUqfoM4ZUetigUdWvtfy2vUe4HECNyd2VV3Gz2w52Dp3Ksskcb6vUBaSPZYGGp7ZgpPaxOghh5/vAZwCkPSuwnGfkvaDD+zcudB8ER+Rn+NSGXoGWuXBkeqsiVQXpUes73shqUtl1HQA6KSZ7wdJhRW5ye4oGMk0Co4TaAEzLBQwbP36rV2GwljcWJoOTofSUuYHndZM+bA+2LWifSQpopl0nEMT/14yCoYoZj1HSNvQhuKy59JkSeUKsFATJIWSBoBsPsWo+nO9kgmc6dDk6uZ4gb/5PCTC
 5tNQ/MQ6
 5exC1T6i3xb5YOOaUHBndwwqDSfro1dTJA0Tzqz14FEudFQYwDA2pmZeXRqmH4qvM/QCI7SWFMCCLAT9mx/xsajhjget8kvo61Olrobas+DEPojAwgXwv4+ikDn4YAxxvOz2Sbn80o/UIUXPsAUKdzF5SGC1MFlqkG0F/EiNdSfUBYYaE+QiganhXnmjrbDJdp9QCk8kVk6BQV0jOA1T2NnFp5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 06:26:38PM -0800, SeongJae Park wrote:
> On Fri,  7 Nov 2025 15:40:41 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Currently kernel dumps memory state on oom and allocation failures. One
> > of the question usually raised on those dumps is why the kernel has not
> > reclaimed the reclaimable memory instead of triggering oom. One
> > potential reason is the usage of memory protection provided by memcg.
> > So, let's also dump the memory protected by the memcg in such reports to
> > ease the debugging.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> [...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c34029e92bab..623446821b00 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5636,3 +5636,16 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> >  {
> >  	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
> >  }
> > +
> > +void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> > +{
> > +	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +		return;
> > +
> > +	if (!memcg)
> > +		memcg = root_mem_cgroup;
> > +
> > +	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
> > +		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
> > +		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
> > +}
> 
> I didn't expect this function is showing the information by calling pr_warn().
> To me, "show" feels like something for file operations, like memory_min_show().
> 
> What about s/show/dump/ on the name?  It makes it more consistent with the
> subject of this patch, and other similar functions like dump_page() ?
> 
> No strong opinion.  The current name is also ok for me, but I'm just curious your thought.
> 

I just took the inspiration from show_mem(). Initially I was trying to
put these pr_warn in show_mem() but noticed that it was called from more
places than I intend to print this info, so decided to have a separate
function.

Thanks for taking a look.

