Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A075C79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AAF6B0098; Sat,  5 Sep 2026 15:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB8B6B0099; Sat,  5 Sep 2026 15:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0F86B009B; Sat,  5 Sep 2026 15:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F2E6B0098
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:36:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB4EA803F6
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:36:55 +0000 (UTC)
X-FDA: 85180716390.16.EF4B67D
Received: from outbound.ci.icloud.com (ci-2006a-snip4-3.eps.apple.com [57.103.90.134])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD2EBC0005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:36:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=jofXPMkk;
	spf=pass (imf10.hostedemail.com: domain of bfguo@icloud.com designates 57.103.90.134 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788637013;
	b=WCz+2lUOefjVVA8p6rHgodAMTX1EN453Z9hZgGiuVtoPWYSykqWxUHUkDPdxT588imy6n1
	gv1XpDpQQy8Bd0tZ52KWVFHyLEnSCFPzi1CS4M0s4Qh7De/Xw2qLzA20mQTpV3jw5khhrd
	cxqzqjuijcjYLNDbTQgvzkxH900UKcM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=jofXPMkk;
	spf=pass (imf10.hostedemail.com: domain of bfguo@icloud.com designates 57.103.90.134 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788637013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PC2pRNtqdy7kEe5lF1ZHl4XVumVkfLLoGiTBdLWhYp4=;
	b=hakhUCjjUrvHOlxQxGwq6jEbCxbbZi7QlCMhyKp/eQVxQq2ynyd9SqFtt/3vT2CZ035pxR
	0MjRk+gyCilYewyRKxYQiyqFnUeweDkTqleXkC1LuqF83HYrbaeSWHYKnpyTPP0BPA5DD4
	vXI3EzT3bIe8GlhvJgyc2caThVLucbc=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-7 (Postfix) with ESMTPS id E9BAB1800163;
	Sat, 05 Sep 2026 19:36:48 +0000 (UTC)
X-ICL-RepId: 01a07312-d3dd-7743-a70e-6a22db0e2eca
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0OXkVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKBmssfglaAkZHXSFYWHcpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637012; x=1791229012; bh=PC2pRNtqdy7kEe5lF1ZHl4XVumVkfLLoGiTBdLWhYp4=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=jofXPMkk0lhwcEGgNW8GLnZK/gJwnbofuMabnYZOtTIYi97y2+EhoJDxgphVegR0whRwyqleEvSxSOXwqIH8LgQWdsL8w6Qy43A17cxMln7jvsdb0g6IEaEPBy6wN/kNnNGx6su3o4DqvLpAQTdIkm/CpAxA1noQwNGkXnqKnuFs0a2J441WwpcgjE0iwdCei+KgHhSBOn5XItF1u87UsfcsqzBzd3sBf1cVTcP5w/pqJ6O37NGMCl8pYo0RUNQ+3iuvnJ2XDgV2FuZXCqgOeSOfYZNp8BXob+wasgkLsx4tdw6OcR+MOWBTuDFDJH8sRb/shpANlnSZ9iJdvI7Siw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-7 (Postfix) with ESMTPSA id E8AFC18000A1;
	Sat, 05 Sep 2026 19:36:42 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:36:37 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: bingfangguo@tencent.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
Message-ID: <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
 <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
X-Authority-Info-Out: v=2.4 cv=Is0Tsb/g c=1 sm=1 tr=0 ts=6a9c6f52
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=RnMKIuOpERM8nik1lK0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: p4Q2hJtHhTaNPS4UtdXOLTXi8dG3hPFG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIxOSBTYWx0ZWRfXzpXclV0Pypgr
 AFFQcokQv+YX1+N3s0m2/roHny8krnmks5UKgPChWkp+woS7DjP2G52jOKv5+TkXb7qElQ0TVUi
 8vBCoLVDQg5sfbki19T/lKsJRhfsLOcKYWsCmelP+LgvpezHn9U6QdH+PhHlM16O6X6cDNmfmuZ
 LJeuFLR56KmvV6tDK7oCVyOWCmoOneAX89impebxv6WRYJBM10sibqznDZ4DQkk+oBnPuqyARIk
 HtdXqXpwAcxyRWxWQB9yCsDqqjC4bh0rwEB8A1HHGUDO78eQhRK4257IiC8xr8iiYevtNkQKRFB
 ipH91XIpuZkL8B8VGzp2GbxXNHCSc7nxZ6CzICl7S9d6jmqhtO6KLyhATrZVIk=
X-Proofpoint-ORIG-GUID: p4Q2hJtHhTaNPS4UtdXOLTXi8dG3hPFG
X-JNJ: AAAAAAAB1YHLZMnlLxriG8Q7OGpKoLkFgHiy/8fjVXrZqLZKdCkWLwiHorGiXqxdIj3FtBwHEUD+14/XM5YakMsDnzA+McYXxHHYAXP48LuRVFPGVA3Y4vSBRpdrL/oIThuKYI7Wf3SA5BuQtBB9Ted71IMlC+1Ng3oz7y3LkRwgh09ezwiNycI6MuoT+PitUDK0Xx+Pz1ujH8fAbPk0vDaDMAIcJQobo+2Cv+BC7nfd5nANPCRmeKtpRIySrl/iFQzolJnSaQHAbrtr6XhxibQKtAj51l8x4KWCiYMfTQNE6ndfw/27tTP3wOfYPQJ1hcmJrAMJqCM37CIYqf2+eCLBTGR3wwg9zZ5skBPM7VW9ax3MGJ8gExLVO24aPGe4x1z2j8b8yJMYT8gJCGZRFmihlg5Bkryn1P4r4vwlrs0WamABIinJXKqPY2n97xLw0g8ZiUpPHmJe+Eq9kG2lt3dBdAlApg4j6Yf7JbnvbNPzCDpAhZ1sAlo0AndqmYH1l1w/+3Ssk9L0uT/AJDLeS0h2iaUEsxDJBQlLuPWrQLwrJ1BBhjgJPsc+utDRoJT97MQciC7ehi+puWZkyr/+HrEjZbj9lHl6udY7NErRex1pDFdGxgSxp+QG05yu4bXmQ4lPn3KS4mVZKaJuvIMOH/llWc8fBsQcQQ3ktbfy/iZZIs9vvFlWOIe1wO5bwQFe/5ICuIqSQS9J4ktxmPDbOz7Xy5CwE8tRFCGcU6A79KqL0uOBTbyPusCwKD2Rz02twx911x8cAQ+T/daNX9lvccVUffWisBGMFf6cZPjLxzWlU0kGyUIfp0X8QZ6eZeeTnTynmOjD90DntpkWEWRUBRsI7ALAldTjZdQQz4/uHBndWXa3lwWBdyfHbXp9+OkU9/ImJ5VXdQGMIfn8BuNGOm7vWa5Q1fRBlDcvmcRhBbyeW+fuu2LC0D9KVtUjLrxNf+kZC5+9usKbPIll8XC0k7r
 i4jrkz7g
 cVOnDvIFH1Xc8JPLdb74XdcE1wOjERW7pg5nXwh0WjGPpkwhkzfOt+t+vhHu3IGuUcMYwfhS7A1o8NNRr3W4iuOrS7LxqdlaIrCK4tJi9S7QZKE+6TL0pMRiMSG0tLc7qtjQFBzxX+oDp5s7tFNo6RjsiRfSRjVUqwlnjUTiubrvE8hAOxaMo1lixH+G77GlIX7VVG0k6zki6+IDZTuEQAzNw/WjWvW53hQu8294Lagpd/0NzAibiZor0OLEdQgMe2qVwEace8PNymUAv05nwGIH0M+uRG4wtlZP1M7kZTRMmFxI03yocBgu9dOJKUsaC7c+3ydnBYBw/FZi05tDcJsSEmVonxHBwwVGanM0VdQacq24tQ42Wwbr01xpfUQdyJ4SAT6ksXWcpgQOWGobZBvpD+UJq71NmE6Hg50w+8ZVVHxxISGvzu8KM0rcIRbbLg5djObeyT1kHTX9T
X-Rspam-User: 
X-Stat-Signature: 858dzjw5owip3hym9cxuoccok5spstnx
X-Rspamd-Queue-Id: AD2EBC0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788637013-224316
X-HE-Meta: U2FsdGVkX19FclNK+FLvz3GD3TNaPqrbY5jzO6nz0Y23X77UZmWNu8vgumJkCl8t3Orq1Tr8wTeykonYON3AUYP/N24Kj+hD2M/UKLwJXDFhxeIIx9DFpY95rYYXSllcnHTGf3gMh9QpafIqNdFeQqFSyeFm8lSUoR0A6M3+4o/K8AF1awMLAlU4KQgZBAGx8/uRWCM03OWMtiW0LC0Ey/wVg44Nrpv6K0MbUSDF5wJjCrvnJTewkI3EtzD62tdhj+AFTMeJyg0GfO4uJkmAfeuqcvjekpRP1UENg94u/Wn77wpnMwAs0pE0htTOYvmBPT3oUgLp65NPByY0sTSqERM/9ukvOdm26mXq9lUFhyet9Mp9TfCGMmLYmXf4mz96NuGHA9SYhr0X2kaI4HnJOKvy0U11LiCj0I1xZsE0C8O4SCCD2HxAZ2Y/3FQSYddpFoFkyGZKtTXN82vNoGBDrWDQZmdhX17nzu2NgOenF8lBI5INcb30/RDjTSEsdv6aFLPEWPsFNu8GjztJAr6C5HJcitviqQ/lx3cP+Ur+zD7kU5hi7XV2vvD4H1/pX+5jzOysuhUGZkPl6gcGg5nGcawhlnCt/P7YpYst+65kRl/UyC3oe/4xFgmfBlKEwHb9iS/fPH2XYocBICOG+dXEZW7nfOjdhxhg1TeBfYKVlYtV/jRIQNVe3scMfgigziLadC52g01jmL3Rm/gnVcG3YE2ogv5fY31THPYMYYSiVXCXIcLH4xs8JfgcOfev2SDWlKHAYy1FEPKh+YkdN+QBicNKx1U6pOOWE80Z4b/AP84tgsni06AteW5DgVvAojk8zBCywHWkEiyl0ePCjgSdoIl+lt7+V5yt8ltgCMUGhQYLIlyc01M1vhKgoQgHx5EKkdP7dPRNUCD7ca3xo7Q6iVkmXdsYKM76+i+uQ/rlREKnqHcHY/ulfK+ZHpL22bdtw/7ZNK2398rDgJt0hru
 LMNK5Vh0
 ud3/f8rqTQZsBVs6juUOglFnoBKAxU6QSefOVzl8x6lCDv6jUUoryS9A/F3ZSNpUBtaRaqyMi7356OWzFUKL08X+7dfyE5uf57iEaZxTjj6kN9pl0xBNRg7gVry5vrRb5UdQ8LcaJdqgviFxIt+a6OU5996ZXhmg615jAy/oeOBqu3jNANoUW0rc0zp94E8rb7/OwRxPRDKa0KkP2x7srKzw02v8lGW+ASnPDRkWMRnDMXn4/DXkR3W+84UbqQ8lcugZohPWKRlLpdxpWrrHfKYdYF6dGwjqc3RDBuN7QtA7ORQQQqzIKF5H6EAqbM0oxqyLKkvtjqZRYEd9kt/kZH/7HgC8o9mOfIaXzIdAVs5/KuGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 03:28:50PM +0800, Muchun Song wrote:
> 

Hi, Muchun!

> 
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > __mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
> > drop.  Right now it looks the memcg up by id, uncharges it, then looks
> > it up again inside mem_cgroup_private_id_put() to drop the reference.
> > 
> > Make mem_cgroup_private_id_put() resolve the id once, drop the
> > reference, and return the nearest online memcg with a reference held for
> > the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
> > and drops the reference after uncharging, avoiding the second xarray
> > lookup.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   mm/memcontrol.c | 20 +++++++++++++++++---
> >   1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 048c9bb0fad79..f0503a1e5492d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
> >   	}
> >   }
> > -static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +/**
> > + * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
> > + * @id: the memcg private id got from mem_cgroup_id_get_online
> > + * @n: count of references to put
> > + */
> > +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> 
> Having an API that put reference-counted resources return a struct pointer
> is a very strange design. Please don't do that.

That's true.

> 
> >   {
> >   	struct mem_cgroup *memcg;
> >   	rcu_read_lock();
> >   	memcg = mem_cgroup_from_private_id(id);
> > +	if (!memcg)
> > +		goto out;
> > +
> >   	__mem_cgroup_private_id_put(memcg, n);
> > +
> > +	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> > +
> > +out:
> >   	rcu_read_unlock();
> > +	return memcg;
> >   }
> >   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> > @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   	struct mem_cgroup *memcg;
> >   	rcu_read_lock();
> > -	memcg = mem_cgroup_from_private_id(id);
> 
> I think we can introduce a new helper like obj_cgroup_from_private_id(),
> We can use the ID to get the corresponding obj_cgroup, and then get the
> mem_cgroup.

I actually did this in some local versions but gave up in the end
because the ID should be referring to some memcg and I was not
sure if getting some objcg from a memcgid looks normal.

So if that is acceptable, I think it's a great idea to do like
that! And the put can look less weird then.

Thanks for your idea!

Regards,
Bingfang

> 
> Muhcun,
> Thanks.
> > +	memcg = mem_cgroup_private_id_put(id, nr_pages);
> >   	if (memcg) {
> >   		if (!mem_cgroup_is_root(memcg)) {
> >   			if (do_memsw_account())
> > @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   				page_counter_uncharge(&memcg->swap, nr_pages);
> >   		}
> >   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> > -		mem_cgroup_private_id_put(id, nr_pages);
> >   	}
> >   	rcu_read_unlock();
> > +	mem_cgroup_put(memcg);
> >   }
> >   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> > 
> 


