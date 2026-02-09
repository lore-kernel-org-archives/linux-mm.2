Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C582FE7E0CD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 17:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361F46B0088; Mon,  9 Feb 2026 12:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319376B0089; Mon,  9 Feb 2026 12:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245746B008A; Mon,  9 Feb 2026 12:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11AA66B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:54:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 918481398B3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:54:04 +0000 (UTC)
X-FDA: 84425666808.25.1C6EA24
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97620140008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:54:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bz37dgu2;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770659643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hABd2jvZOVnjl2wLz3t/00/fhLlc+2ElVVVlmwti45w=;
	b=FUJSXt7mGP2vemvsuClZbEryWAN99vCdw8XVWQ18JlVoUYMU+Wfi5iwKP2V7yHErMU+/jU
	hyBPbaQRwOUn8PHX2XybwOl+i8Sv7hAxxeoo7AYu9+CYfSnoDsm3+PJV83EboYLV775uR6
	qHbYOVYl1XiZrRMSNjagwRg+M8o+BVY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bz37dgu2;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770659643; a=rsa-sha256;
	cv=none;
	b=nsR5k2I+rUqoRwbQqLUKw7Z0u0MQjXVK/e2uNd5G2LyGkk1oRtAacAvK3xG17/loqztz9f
	XKauMLFL4qsdlXFf7r+nDNHar3UI/iXx61MqU6ExhwBQBRHwpRZcP0yrdyDcvdqKY+9/oy
	aJWmfed2vVdXwofChiLY+cU4ekDPCcQ=
Date: Mon, 9 Feb 2026 09:53:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770659640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hABd2jvZOVnjl2wLz3t/00/fhLlc+2ElVVVlmwti45w=;
	b=bz37dgu2WOZ0fHE5mdro7INsfOtdYjgaUiDKeNyEC4e7oAuZBp7HwpM/vqGoMbZR19Nhs4
	xvFUvEU4thB78JQ6srTO+YyJeFZgYJH2RhwSwcXClEVmMV4pS7x8qQm79Va3JpARHVk93q
	RADaYAIS/vvBNLqaXG+ZM73RAquaGJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <aYoezZdqL_AofUgP@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
 <aYe1R2MMcXbPVYUW@linux.dev>
 <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97620140008
X-Stat-Signature: cejq7w3rhtx3idfwot6cmaaodathrmes
X-Rspam-User: 
X-HE-Tag: 1770659642-5175
X-HE-Meta: U2FsdGVkX18XE2bDd8kjKUb9AzgJn7Fz+9/w9vPkxgAUzs2uz1EgMHB713XRInStfNZ2dUnN1jE7g20Kx7YGJyEanm3SZ6ipcmbeDobYA1xFIlTxeOM4dSd+sNmSvOKhkjTcJtk3GDtjSbKzG9NMvEzYoWv5kBsmgHlhv2sA7kGMGvykbrl4+0+aUNejOFDF3Sazn7i94kuLRlTC0oyUgffSzri83uLoho6g5CMQdzsbZKlpggsjmpXZk6V4sePWVlaBWvFVOxugF9hP5J8manHgmXE6MeDEsnexu0GPNFs3DNq5K5Sv+oJC/TwtCxaB3nTgfQpW8qPHYHt+rupGVjC7gwHzVwzkblWncqWT9GGq0iPSlwlYZL1cj/iUbBxWeoiHU8O0OuHiJh2PxO6vSstWsy+tHSxMn6dlvrSpvUIht3tgOl+ITdZ1LO6Na91RbxyZ4SGIy8wH1Qjhjq6I6tW9+hS6bYQHDTh0f+E168716FFBlxefGL/VIxI5Zy842bvOEx9NRlSv/4vEun/GSlBq2VUGJ0fND+xcqCSAf9x3Bq1AvFV+JbJnJxxsPozeiXwbuCv/vx8ip7L6WBTWLVykdfT1UasKWDnAvhH04cnhpStAptS6v7SyQGUVHzReh3YBicFpyw8G785nFpTX+A2MDLGCSADpD+s0Qd8CwUNIoKc/Zo8eUd1nFm/P2IvoouJ7h8wQ8FhH47acEp5wU8KJlYVQFHthmtjcPIu41PhgZK9lqEipYxl0uquIS+3f+OC7xq2YNxZz/+3AKuDaSGviqoZyRGt+7ETPWNlzUBuv0dYr3DSQm9L5XzkaPK8OLe9V/GnuKXEL9wX0qMLaYVFKudk3r1BgJx8Raau8gw+Wf3HGBhWsPzPRBj6hHFPJMBjSvv71Qk7ckc/1zd9/ZR0N3SsGrVso/I+QK2Awo90smzsfAzm/exiWqcPCmkmiRaRwNdQ0VzgnRzP92Iz
 mCQL6I+I
 YgBejnKq/gWJ82pav3G9jwHHF7npWW+8sSqN+H7FFU8mxHgamvStAMsKXx9qm4QQYhJpktRKSXBmIKdzVrif1wavmZ+RLUq59vlal07Z+brYw6HrH0yjReoWxrFgsqfv9OE34QjzxlxHDshdC20cU90Hc414JOrFoTzRuq3RTKWs4r3o5w5RQGiuyXPCPrdsNmve1MijNVehKhRo30IgVI9CGJIplwhcZaVUGP0p6ROV+hZJ4uS1+UWnWtjJcp5oTFBhu6xKP5OBBDLtEGoCHdz3YJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 11:49:43AM +0800, Qi Zheng wrote:
> 
> 
> On 2/8/26 6:25 AM, Shakeel Butt wrote:
> > On Thu, Feb 05, 2026 at 05:01:49PM +0800, Qi Zheng wrote:
> > > From: Muchun Song <songmuchun@bytedance.com>
> > > 
> > > Now that everything is set up, switch folio->memcg_data pointers to
> > > objcgs, update the accessors, and execute reparenting on cgroup death.
> > > 
> > > Finally, folio->memcg_data of LRU folios and kmem folios will always
> > > point to an object cgroup pointer. The folio->memcg_data of slab
> > > folios will point to an vector of object cgroups.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > >   /*
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index e7d4e4ff411b6..0e0efaa511d3d 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
> > >   static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> > >   {
> > > +	int nid, nest = 0;
> > > +
> > >   	spin_lock_irq(&objcg_lock);
> > > +	for_each_node(nid) {
> > > +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
> > > +				 NODE_DATA(nid))->lru_lock, nest++);
> > > +		spin_lock_nested(&mem_cgroup_lruvec(parent,
> > > +				 NODE_DATA(nid))->lru_lock, nest++);
> > 
> > Is there a reason to acquire locks for all the node together? Why not do
> > the for_each_node(nid) in memcg_reparent_objcgs() and then reparent the
> > LRUs for each node one by one and taking and releasing lock
> > individually. Though the lock for the offlining memcg might not be
> 
> To do this, we first need to convert objcg from per-memcg to per-memcg
> per-node. In this way, we can hold the lru lock and objcg lock for
> each node to reparent the folio and the corresponding objcg together.

Oh we want reparenting of both objcg and folio atomic. Let's add a
comment here with the explanation.


