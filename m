Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC44C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E838F6B007B; Thu, 23 Jul 2026 16:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61A96B0088; Thu, 23 Jul 2026 16:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71486B008A; Thu, 23 Jul 2026 16:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68ED76B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:21:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED2AAC0148
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:21:24 +0000 (UTC)
X-FDA: 85021161288.24.CA37A67
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20216180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:21:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgHez6Sc;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7NoLvTE348K+Na68Jw9OquhlDUzGX30hZ/eyZXWDcM=;
	b=RyiBLgY8U6L0qDA/bbIE/H7TKNbOldDjuR+OucmUlag5OuB/j7EeTYI0/Zni8VJZsDNqaQ
	5kW5vOZNSOzvNFZ2NtRMrqtbO5ypGIdIsGK4yaj/rm+t43w20b4QlL5V3Eq/MNdNnjbER+
	+r2ViFMe3f9L8I2MaanONLPM4SC1w7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784838083;
	b=1mvOSJf1t2ZTP9UuodmNo6B2YVXHMxswHLqTRKz9ejNilKGrnW6O/WXKvQzNNL3+bKhkzX
	B3T9uGpbrUT6TQRq3p/PrjMRl9DsIlWhQueGHFu3ITko3Rq3isubYwiDXFicVctkTX8V2N
	hgPvI+J9B7bF5ckGUxQ7jb66ct4F6LY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgHez6Sc;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6aae244ef49so247907eaf.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838082; x=1785442882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7NoLvTE348K+Na68Jw9OquhlDUzGX30hZ/eyZXWDcM=;
        b=rgHez6SclP0jJGfJFsfTPQiDp1mTa+p/y3s8oLkclzNsYqzTIy1xFvfcU3yBcqt0dA
         iaSu02n56j0UC9vMBWUG/AuXvyYKmmiV42OmDj2SDjnmuV3/cvCU9fxoNHqU9uxJMtOw
         kxLPQthRwn9GAg6Bt4h3bViPVWrx18/fRlDbSbMntAYqNCSQyWb9dPGxQJOCsrYqpX/e
         2DMpltsLXA2qOwFwIuzL1adlKteXTKhve9iLdMlC9OiRMKn4ie+yJpHqdpgHRrIM/HbE
         st7uvWJPBnC7MbXIWWJmSDRDGm0KkwRS/uvF7jXdXHb6jKKaAk64Loa3SnZl8y2aVGDy
         LjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838082; x=1785442882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7NoLvTE348K+Na68Jw9OquhlDUzGX30hZ/eyZXWDcM=;
        b=gJRo1DJz4Q2ajD0Ju0yYUvxVWCQWSlnOH+wAShRT3COraSzMpaKhsfQMoGnKu1RfAN
         fuj79KuXRaZunyM00VtDLvYoxQe01rn72h7IVasyhPNJ7/tJJ2tRPcdrMzkS7d5xhwMH
         Zcgj+0WQufFG+83Rca6jWIF7h39aIbL901T7c2z8dyIejBbpwBQcKIUFtyfBreL+D+dy
         63Z9143/yvlWQQL7tijWbRQiJzNz++nkrMDD5dTD6H9jF/BLdO3p+gqZNdK33g4EhJl7
         eNda4bx5fvGAWdjnKPwpXImek4kS2om+GVffNy3WwIYA7yYNRkra6zDSG8/m/7T1CY4s
         RV8A==
X-Forwarded-Encrypted: i=1; AHgh+RoJM4THZNa2pQIT3aVhqmyTrFLLxRsigHdZRGALjNWFLe5NkbYS89sZEQCOMC1d7R2FmmSh71yrlA==@kvack.org
X-Gm-Message-State: AOJu0Yw/E0DPAKjLLkuIFT3+TeuMtXY4Too68SAfrmwy9ieAo2F7D96e
	DZCHMD/IiFdLP4iqPtkRMBJldPnCQFXIG8L4KOQoR7bAQ4yIPuxUGlGy
X-Gm-Gg: AR+sD10w/mo+wGteCvNK/k4STS8llja9O8G9XVkOGlZtFireYcXOSEiX4sWwzVvHW9I
	ep7QAdnUg8RNp0jffP0m3nIkCKjt+5obbkyFE8Mv7DkceuapxYVO7tXc89gUR9Qf6oTzEelaROe
	oZ57D+uoeNgDzE6M9u4hEH7PheHyQJmSpFVyKmiSG2L5NiYng05hw1NQAxe/F3AeQSTZykcArdC
	f29rA+a6A1hPsVogZWqBzFJBYdDvvbIlceaGlBixvyVL7iGBenWdTbez7N7yKeBz/qWylwan+Jp
	NkVc0gCA7SwN67xkjvKhdgsOdd/OtH0iApCqP5paGFJFgAGDNpOObCEDCTtq/ggwcxRzCZlyjY2
	oS8l2P1mw+GEHYD8yB3QZ0dngFftOwZUvU7VerQecIGre4b222/Pl4c1Pfnokt9vzOIkAaEY7Zh
	kDnpzY68JvkrvQ58xUUvj9sIDknZdq5o0=
X-Received: by 2002:a05:6820:7042:b0:69e:43a2:349 with SMTP id 006d021491bc7-6aad4139c06mr1581776eaf.47.1784838081210;
        Thu, 23 Jul 2026 13:21:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aa79ef5a37sm4173918eaf.13.2026.07.23.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:21:20 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	David Rientjes <rientjes@google.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits tier-aware
Date: Thu, 23 Jul 2026 13:21:18 -0700
Message-ID: <20260723202119.3688800-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <alkB4tnJxOLyVCi2@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20216180004
X-Stat-Signature: ofc7q49o1deja9ec7hwzihjji64tztqf
X-HE-Tag: 1784838083-240737
X-HE-Meta: U2FsdGVkX18mmEGUeo8vBwbvhD+luhYyfFSRfCZl91lvo2/3wPprXMbIq10NqaqaLC02nejJjE+zq9YmKMIJHmvnLIQ0hNouLDteXnEkE25O5tJe0vYOw4Y2WCc+ZLHF/uFjR8uFSi1JjjsES9gEtX+Dsi83y5k8bCm6ZVW88B3IFOkmZbn7wx2iNsQhC9pjkfcClIAYd0q2TqW2l8yAdQLAEe7Y3hXvfVc2n6xZCYjFhZJ1uLlNR7tSFQN2fAVLUBqPsUR4MC9oGCswp4sMli411f3imBCH99AqVa3u/FygHdPdNjgC7Qk3pAmUcA+2VBNaa2SrN0cBtyfQ62BdpHVfv7FakkKNw6pk8qlgNbLzEXfi8mjbVFJI49H8HC0SoomAx9EvRNqFDpoBikg/aZOntxTGHpj0k7SYS3LkKjl52eSgwZ1SlDNBuW4FFksmCEImq91QKTaiDElmxtgnb6TpviP3xAXbGSX2/GJQhKsoxIcHV/hD+95/d0iHr1JNJxEYH3QyEQwcqMKRL9QDcT0NQooU0T2sBXAIMOBAhKYn/KwD1j2op3av/UG7MvkmywLLKEGnIW6WwyAOw7ReGtY6q2gA6+24vk3Z0xP4bhbGJhH4g0O4B8IXFum0/hTZv4veki2y1yFGA9KxWd7nIJgOd/VS2DtEZCeGhQasmPrnGqqN9dNyCeVs4+07rddcAPMZmfo1IyHnNUDHWwZz8aXrDq5a2Gh6yv6NzhhrjsQhD4IUQPLzbIb+Bc1B0P/bQwz5K6lkZciONR5+PunvFmI0zqOFQrQaawa65R3xRKIIQQx3tm4f0kOoKPW3PWNwocJCsRhRQM5R2csIUOC2GJ8ZjwgxyuscX6W2YOWLlX3lzk/fUu9LqtdAGgmio17GEG5wCBMlGMay5fABMvW6EDdruqN19JcsXy7N7IItWSRqBSYZMBklXgIFODZmf9QRRy7ynRJ5aO5EpnAoGxu
 +XQYZgUL
 uSAT1gx41hyx0CjjlLlhac87WFALVqgUnidOk45aslHotmBR+RmHlms7Fr1rujvy5aZrtrJTdhNJBZI3/aolbg5os1CepKeeboCzHEQKJqcXXMgP4XpjBnk7UAszsNlL8CjEObrjnRxrFQ8f6dM8Q8qMflYA5dd3z+1B4xbull0+owd6o+8VckXJ7We38DwRSXc7oc7zA521B6QFGOz0ZN6K7HY2/diIUxLL9C+UC+ZvDSdbyDMgXzXPV8Vbh+3WU32eIgsHEp1MV9+jiEjfWaWClki0HaGg93klg2YDJjfkXEZ3JS9XfilALUM/aANKIQ13ZPpUB4NPbreZEJp05J00BChgOuWdM9HR2iWnMLk08olbypwoZMgVxbuLtxZ1gY8yiREcivbMfzPAO85OygQsPJE8RyC6tflj423nCX5jEDh3e9YQW/penqbQ79DYKMA7zD1zvLthptbKqwwM3iZsa9TaWCEA08/mVevSe/WfN474eBQTqeX4FavjCTf/Ueg9lhUbTf08LM0sNe11zH4sEaGYFJM8rn8b+823QeqSpN5dzRMyUXWhfo0YNpDucUAx9e02zXF6LzGwtdvNOzEMqdcTlKMrri8cVRKIXZ+yeEDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 12:55:55 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Thu, Jul 16, 2026 at 03:11:30PM +0200, David Hildenbrand (Arm) wrote:
> > > 
> > > First, for the multi-numa-per-tier case, I think this is already pretty well
> > > handled by my series. Once we realize that a memcg is consuming too much memory
> > > from a tier, we trigger reclaim from that memcg via
> > > try_to_free_mem_cgroup_pages,
> > > which as far as I can tell already handles the multi-numa per memcg case.
> > > Other than restricting the scan_control's nodemask to target the nodes
> > > from that tier, I don't think there's anything else to be done.
> > 
> > I am not really sure about the "toptier" notion, in particular if your memory
> > hierarchy is not static.
> > 
> > Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
> > memory. The you hotplug some HBM CXL memory.
> > 
> > The meanting of "toptier" changes, which is rather confusing to me.

Hello Gregory, hello David,

So circling back here a little bit (sorry that it took a while to get back)

> I think this is a naming problem.
> 
> Maybe we should start calling this "initiator tier" or something.
> Maybe tier is even the wrong notion here, but it's the best we have.

I think the confusion is that "toptier-ness" doesn't give the full picture
for whether a node is a promotion candidate, a promotion candidate node
needs to both be toptier (adistance < toptier_adistance) AND also have
CPUs. So a HBM node that is hotplugged can definitely be toptier
in that it has a smaller adistance than the toptier_adistance, and will
probably even have a smaller adistance than the DRAM node, but if it
doesn't have CPUs, it won't be a promotion candidate.

It gets a bit more confusing because this distinction is not a tier-wide
distinction; you can have two HBM nodes hotplugged where only one of them
is CPUless -- then we cannot make any statement on whether the tier is
a proper promotion candidate, only that one of the nodes within that
tier is a candidate.

> But I agree "toptier" naming doesn't generalize to complex systems.

The merits of calling a node a "toptier" node is therefore a little
dubious I think, it's just one part of whether a node can be promoted to.

Anyways, I think this is outside the scope of this series. I think that
for the scope of what I am working on I will try to move away from
referring to things as "toptier" nodes but rather call them 
"promotion candidate" nodes. I hope that distinction will make this
series easier to understand and read. 

> > > $ cat memory.tiered_max
> > > tier_0 20971520
> > > tier_1 31457280

One change here is that it is not really possible to have 0..N-1 indexed
tiers, since those are not stable. For instance, hotplugging a HBM
node (as David pointed out) would replace what tier_0 is. However,
one thing that remains stable is the abstract distance (adistance) the
tiers are associated with, so I'll preserve the ABI that I have right
now, so we can have something like

tier_42 20971520
tier_128 31457280

And if HBM does come up as the "highest tier" with the lowest abstract
distance we will just have

tier 16 1048576
tier_42 20971520
tier_128 31457280

And we will not have any problems with tier_0 defining DRAM and then
later switching to define HBM. It is certainly less interpretable but
I think this is the only way to have a stable set of tiers, since
adistance is pre-calculated for all possible nodes at lateinit time.

> > memcgs are currently not NUMA aware, so this could be one possible direction.
> > 
> > But is "tier" the right abstraction? I really don't know.

> Really I think we're trying to classify 3 general pools of memory
> 
> - Precious:      HBM
> - Preferred:     DRAM  (initiator preferred targets)
> - Non-Preferred: CXL   (fallback and demotion targets)
> 
> HBM nodes are already weird in terms of fallback ordering, but ignoring
> that for a moment.
> 
> Non-preferred "tiers" are slightly different than preferred "tiers".
> 
> Under normal operation (assume no mempolicy or cgroup weirdness):
> 
> 1) Direct reclaim NEVER targets non-preferred tiers (kswapd only)
> 2) Promotion NEVER targets non-preferred tiers (promotion -> toptier)
> 3) Under total system pressure (direct reclaim on top tier), we swap
>    directly from the preferred tier out to swap
> 
> So non-preferred tiers don't have the same reclaim behavior associated
> with them.  In fact i'm pretty sure we could summarize non-preferred
> tiers as being managed hyper-lazily in the current scheme.
> 
> (if there's space, have at it - otherwise you have to wait for kswapd).
> 
> In my head, I think what we mostly want is:
>   - Precious      - controlled entry,  Private node?
>   - Preferred     - semi-precious, fairness desired
>   - Non-preferred - not precious, lazy managed, no fairness
> 
> Just some food for thought.  I've been poking at making non-preferred
> tiers less lazily managed, and I'm just finding this results to massive
> regressions.

Thanks for your insights Gregory. All of what I am saying is just in
aggressive agreement with what you and David have pointed out.

I am working to make the next version generic across tiers.
Thank you both! I hope you all have a great weekend,
Joshua

