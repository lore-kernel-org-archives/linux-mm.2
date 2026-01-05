Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF63BC79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417316B0180; Mon,  5 Jan 2026 11:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C35D6B0181; Mon,  5 Jan 2026 11:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7106B0182; Mon,  5 Jan 2026 11:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5446B0180
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:14:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F5EA16011C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:14:36 +0000 (UTC)
X-FDA: 84298408152.12.65A285F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id A45DD20002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:14:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xvyoeqb9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629675; a=rsa-sha256;
	cv=none;
	b=kctj6OJimJNCeIdBzPG5vtfsMJlatOAq6HBzvW1jwUKbaEs92kBI+IRnWz8UkWmZJDr9Gk
	Uviru6UU59lXNrKPHP0X9RADEFdN4EbLg3k1YGMdq54CKcZ+7TSM6/ON5Im6qFnny7Vp9C
	5Rr6w63dCLQo+VijehUsQwtlrynZQpk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xvyoeqb9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+zivRqtPV0Ur5FftE/Ma5edksPr76yL6W4pGhtZvKQ=;
	b=R36maMNMJHoFyU1fC8SDz1jCv5VCZcRXbzJ9UGxoirFqLVgJRLi28ur+LPIEur9d3AD569
	0CW755QOrabe2O77/WfV0h3s808ix+yVru5W489uvFpu7a1wxAlL4JI0epjcK8pSn2Ztbp
	x4Lf9aE0+ISMP7f9FRysVzR7xfAtLzY=
Date: Mon, 5 Jan 2026 16:14:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767629672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r+zivRqtPV0Ur5FftE/Ma5edksPr76yL6W4pGhtZvKQ=;
	b=xvyoeqb9YUuPLOPwb1xhwhjXWvmC0P5r/sUVBZbYz40OC3g+x1zmHzp9BDL3A+WY3mi290
	HcRtHH+n6I6xzqDpAeW9cdHaDloKX0Onm3OFcwie/5oGYl8UriG43YM7nMEa7BFeAHG5/Q
	IZmnFWL9tc86FoM2YxipJWgkX/t1tG4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <hrxsjzcyj2uvxi5h5edtkoc3br4ljvz7m36nczoctyyoinrz56@27gcuui7wfpw>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
 <prqhodx7wc3cbrlh7tqf632b3gpcciwmn5n22qqv7c7rbtsoy3@lsnd7rtdhfmh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <prqhodx7wc3cbrlh7tqf632b3gpcciwmn5n22qqv7c7rbtsoy3@lsnd7rtdhfmh>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A45DD20002
X-Rspamd-Server: rspam03
X-Stat-Signature: pz4bz19y65s1sdw9yue9wxrkues9fpuo
X-Rspam-User: 
X-HE-Tag: 1767629674-92329
X-HE-Meta: U2FsdGVkX19SwEa7/MFSuyrbqZyx/3tUdbuAKR2Hek+gNiNQFLNWs8kdRjm8/DWk6ASakZi8klFMKWVcM7XScg0II35Bpc1vb2FVbsi8Q5VqCbDiCuBi1bm/kh17lDDkIsa4+id7JaM1SIyKOc4Ahfq8ZIe94W5EmXhtNRRvzy0huOt+s+Wjl6gAfcF7NzEAh6iv8KIslqykqucVfnd1zDw6ELdYFjLXiOUC4l8YFiWk8ZfAIBpzBCsZ92Fmg85z1d2nWGu3iTX0UMxWWnK+oBB4OcdVeQ5xaB0JpOUd3oBQDkkUMUOMg0pH50pD6XurVFDl53DfXwpmIT57kipzBjSqn6rhFJ3SGhvpwVZb6M3ZCwZSIwTa0c3fsiRtWWacOxociOXwYXa+5GBtgwUwKnfVJz2huVEJN6kewaCNCGN0IoM8xLVkhdA+EXWwwhXVEpAG378sZiCc4tPkz87ixAeTtwFWLedV/UHXh3u4mtqGS6aLGkzHBzao+xCuww48WTpESpEzmlKp+5SYD6irkcPDA3CfEYML6WD/aLbxFu/Pmo8TbG2V7qkB/9RjQTo8J7ZBpTD38ABIGvWA51m9BG7hI7IXGS2cZJG3HeyBKw2siTF2IKmyH1JHP2g8A62UQaNeDRjy1RuUpjHVVHL8lMG8EoHXhQw7gpWhj494X5lKAANMKbIDJqS1FC3bl4y5DAXM6icY6BDkYybnAuxMc5peNrIi/rD7E60nY3GEY2a4Ft/8jdfmPmUVFgmbCoyGDPZMKvWmQCRpU6s7na27Lq4lzEXqAC9Bv5Q8R7X5knkBokH1xCQdHzsfJ3/YPD5Y8FvA5L9H0V5WQU4IwyUG7hcSKNHZ/5At6TquP560FNV9wXTiw5SG1CGrNNDDWMajyubVHWcO217zkVhvuREeWvTG1grfQp454JZnijVs28JOZHjm6NCvVRmlFIiS7CiUUD8iTxwN4oeLIPXlJn1
 J5+pFu6H
 r59hgpWGgAEehK1qk+p9E6X5Zn61V7gD0eDKksfE8jRwSMB3o9+0CN/B8sv0X9av5HeGR/S2lN+kO8CoylW1J5pKWm6+STpNJbM7760Y4pmNHgVSoGxA06UFR6NYV33i1Mt47kAEbuKAuix3kAggy4kkBHKxOIzwDruX4WSctMXGmUynIOJBsGvV9bQ04BDnv2zXseMkzo39nUxqvGIovMZoklQYJsLCL0IvQHpd6gpWGf90lNEWZMqhFNfuvGO1JA6WM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 11:41:46AM +0100, Michal Koutný wrote:
> Hi Qi.
> 
> On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> > @@ -5200,22 +5238,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> >  	unsigned int nr_pages = folio_nr_pages(folio);
> >  	struct page_counter *counter;
> >  	struct mem_cgroup *memcg;
> > +	struct obj_cgroup *objcg;
> >  
> >  	if (do_memsw_account())
> >  		return 0;
> >  
> > -	memcg = folio_memcg(folio);
> > -
> > -	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
> > -	if (!memcg)
> > +	objcg = folio_objcg(folio);
> > +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
> > +	if (!objcg)
> >  		return 0;
> >  
> > +	rcu_read_lock();
> > +	memcg = obj_cgroup_memcg(objcg);
> >  	if (!entry.val) {
> >  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> > +		rcu_read_unlock();
> >  		return 0;
> >  	}
> >  
> >  	memcg = mem_cgroup_id_get_online(memcg);
> > +	/* memcg is pined by memcg ID. */
> > +	rcu_read_unlock();
> >  
> >  	if (!mem_cgroup_is_root(memcg) &&
> >  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> 
> Later there is:
> 	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
> 
> As per the comment memcg remains pinned by the ID which is associated
> with a swap slot, i.e. theoretically time unbound (shmem).
> (This was actually brought up by Yosry in stats subthread [1])
> 
> I think that should be tackled too to eliminate the problem completely.

FWIW, I am not sure if swap entries is the last cause of pinning memcgs,
I am pretty sure there will be others that we haven't found yet. This is
why I think we shouldn't assume that the time between offlining and
releasing a memcg is short or bounded when fixing the stats problem.

> 
> As I look at the code, these memcg IDs (private [2]) could be converted
> to objcg IDs so that reparenting applies also to folios that are
> currently swapped out. (Or convert to swap_cgroup_ctrl from the vector
> of IDs to a vector of objcg pointers, depending on space.)

I think we can do objcg IDs, but be careful to keep the same behavior as
today and avoid overexhausting the 16 bit ID space. So we need to also
drop the ref to the objcg ID when the memcg is offlined and the objcg is
reparented, such that the objcg ID is deleted unless there are swapped
out entries.

I think this can be done on top of this series, not necessarily as part
of it.

> 
> Thanks,
> Michal
> 
> [1] https://lore.kernel.org/r/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn
> [2] https://lore.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev



