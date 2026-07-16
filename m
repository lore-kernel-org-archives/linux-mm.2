Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EEBCC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444726B0102; Thu, 16 Jul 2026 13:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C6F6B0104; Thu, 16 Jul 2026 13:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BA16B0105; Thu, 16 Jul 2026 13:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 057396B0102
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:33:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A28740295
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:33:38 +0000 (UTC)
X-FDA: 84995336916.25.FF4F733
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0F53140010
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:33:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hsLt6yTt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784223216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2q8FzZfR4mwloD+avLyHIbdhXjifcrgRRf6/0HEL3BI=;
	b=H5r92cTCtOyOU0pxDYDx38zIK0TekvCg+AOQjovENhFXamYIvVtceM0Ug0gyEaGiNsbBMI
	4fTS88nlhN4W9y79wYzfkfKxWChspelefnbF9lfw0kKavB9edc7PJBLC0R+mCXK7KPTh/R
	fbeqDe20c3O+MMKnZYbe5x6kCkjqBFc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hsLt6yTt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784223216;
	b=YHgw6YCspoHQki7Fz0yTwed+WBYGxp9aj3qjIceSA0CUpkm1OB1o8Tx26O4bA3wOQRUuOu
	ZKbxcdUoKq/fce565EVN/UW4Otip9MiK2x00LiehEjcYfAub8h/c5ZKh+IFTbeMabxQBCb
	VQrBLhq+oZXVEa4FyNHYsLjJsNTn9bA=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso4609275a34.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784223216; x=1784828016; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2q8FzZfR4mwloD+avLyHIbdhXjifcrgRRf6/0HEL3BI=;
        b=hsLt6yTtjAgJsbYUyR7RTo/P4INmSFKkuBskClltG2CTrA3r2uvm9YW+STaipPUYIe
         A5JzLGvDcWqNScoulXJke1I0qtWs8gnSigFroxRF5GqcmaXseA61l/JBo2Ikzo2TwTLI
         f9wcYzika4kBkLmDpGKsaWYFfBherquYOmQda0WScidabnhcXgug2G37AFbN1GsF5LG7
         D82i2OcX+LrHZgG/aUjvheiljePzQl375zMd9zg5pTCi178wM58jbO/klzxtYC7e1/fH
         OCovbDwyZDhD89OMry0ZhcSctH2TXDLY0eCiBljCf3QaC7AltKu3rLbf51EtDIUThjrb
         5A9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784223216; x=1784828016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2q8FzZfR4mwloD+avLyHIbdhXjifcrgRRf6/0HEL3BI=;
        b=rUa8F/qzEJOF1VYYek/y4Q7A4kVnXrwYVfhYB7bzF40E4/F/uX+g7fxI+XrajQ0qWM
         q7FmjHCu7C4fBwhuZLkxDkcIR08qRM7W+lsm7n3kqLfx4eCG71Z7mlYMnlweHrhe61Qj
         prQB+IAQp7EIYDhZXP1+yYubut6Urop5MKkCEDQc8+pc5HLWW+MEc+ek9pRHPrg/oxkH
         crxmZdkb26LhRgNUIqxKwrFFKXnHGS28To0FS8d2u+olOQvZMhi/PLusIraS+qjZBcrW
         STzGFSs/upmrzbgo5iRNg0U2MdFGBJKOhWnpHdiVRKNbLlyBvLKhFe582tCu7merBuBN
         UjWw==
X-Gm-Message-State: AOJu0YxBynffFyaazAZWa8pna2Xz6OegZ/26x4i0N27yaOeJjVi2qvjF
	2fkAdTlOd/OT3hVwkadBvRkt2fj7AmUkBTp1nRXDCVDZ8ViMvQijgwAq
X-Gm-Gg: AfdE7cnhMxFvogJF47yxRwicmhq6qDuDh3yNcFdl+ggKBHicQMJPXfiLa8tFoyB29A/
	N7++fYmwWDKSE/jFHr70NyKxNan87aT7i3/cggNFa+n0nNU++XviS+XaDN5MV1EzH++C3lV00wP
	FwvFiIaNus6rgoYTogjEvkm9U5jceb/y8ZDY9uQUkBhQidIChQHLzXbMPwDGYEm70MbLMAnYLjn
	kkJKwWP2igUOJyLdf27nAeDnuyB3kBsycgV/d68Wiy9tfjunyxUIL0Q5k5RMQ+AU/HNrD3o/be0
	AmQvbZUzl+GyZhD3W1L+YTOJ+nuw1Ri9roRzn302OaJT6vT7QIR0wOU5xvEeAjCMOUnwOaGYxgd
	2QBtGZXxp6q3Wkq4VWZGPrdySouIzgLxljVhSArYrGPB0JdnHn30IDK16mbq2LZR25Gt+o57+xN
	W2ryno35N1JViWMNdGc129kdYu8TGRY52t
X-Received: by 2002:a05:6820:4ccb:b0:6a3:a54a:367 with SMTP id 006d021491bc7-6a3c6007e30mr8115803eaf.14.1784223215792;
        Thu, 16 Jul 2026 10:33:35 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-455b767413dsm12696507fac.3.2026.07.16.10.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 10:33:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org,
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
Date: Thu, 16 Jul 2026 10:33:32 -0700
Message-ID: <20260716173333.1413857-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: twahg9qnpemoda7feouskkrk1t98etqc
X-Rspamd-Queue-Id: D0F53140010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784223216-252475
X-HE-Meta: U2FsdGVkX1/qsQCku0X2PUgRFSvD50+I2BPLKGHtfAEhQNb/tkg4LPKL4D4gTUsBzJ8F5oWyFqw9WydurgS1Nf8Hzc7PHsamL0AWSHDbUl45vfSoxhVQgglvgNs1gRtTb46coExrMHRtPzm982oK04bHKRJ2GS7Gceb0WGV3S/TdQEer1f9JmwV8PwM6c/BZRUg/EcmzbcGO2caMQA0FyiacCsn199QSaomRGOrzV7DXgnGjnXDjTu2Bzw3+kurx2uAbT09XyqV9Z4akFLw7+R+bSWFuctrn6TfWWg4E1vur3Z8saunyYhU2blKDiApjHFGK3bqu2zSRGbks6ScIWBIXk6AR7D5+4hymS6hoEw/LIRePq0jRXLtEIO5a36mpXLYvSyZZL8nXZUAY9h5dFC+Mbix5gA+RlpBUcpQ9HHLaBABe+AibU1AvxMMTGBHsJs1oI2TpvxjGcypz4ERTeJSZa2cnbhWXwXlOo+/SIWpT+QR+In7Cd36xOUwGuKXQe20WIlqzHPhv0ahcVRJRe77lW0AkmnmEcYYJMUxO3arFMKjYWd6oFvKUKz7FrZLC0/s8lCbe5eAOpK28id25mPrlmOZKT5Rl6ISCLsy4pPsXxpZxK9NL1fOh2HpYncFrQBukjordy6PNZLMwxEerjbfM1h0672g7SrhwovK1luIO7J1IDgsAOVaMwcpjontsKGvnsx2h8aFoyhnmz3rnx4t1T9uuCX/XG97mjblXkG2OGDwKiUX+JEPt8tdhjFxHv/IAS+fazTc2c4ydUu/y0Vvq+Bwbw5MczdLghwjs2XRfoivf/sZYHI9k9lc4NH6XhG4OfK4s2Rz5PqRBaKoZXzcK/TFnFH0APPiTpc9de2bsmm+xDb/3j6kdWHsgxJ4Beo+FC9M99Dk16/GsTbFobEJM77z+ll87njETQwR4P8vcvxIE3Ir6Univgzi5uhYZj2nFK9mRj5v7phFomdo
 7AGifMrI
 D95iwNPRXp6pwCN0j3vZgn84HJkqb7F0TXmohpASXTwI9d9khkTycrJD77uOd/U9gouQjrqk9ebOs1UYT69z04Bkutv1e60VOFLdlw4K4qepD8jWDX7uzvo+CSUb1KWKvqLOB0KYuIBhX6Rbw6A3cnE5WPJBTV2Yp6XwMbOTAG5ZpCiFLCRCW2KnaXgyc2G9d0mY1V8cQST30kFi9CGglcBNNnwOKoZ6WGxJ878ET8DMVf7RNn+yCrSmlToi/VIkynmhNVbpqnr5WPWPbJWRqM7Pg8iA4/ErUCpKkrbzGELfwvhqVu74SHdl96RiVXV7NDGM6eXjOe4Ha0hnMvDk+8ttQCAEkCNKbPD1QLea7Mhkp9oLW2QCNaObmFTCd3ulXdZ5pB135n2T8ZWUcEJKPKQF0FwU5aIGPiIcHoIyjz/TR47UFkWtFVZ8ED3c6ZUhir1Wh3bXqFZokjVFe65vtKP7IrwWDSZ7o+QLeKgdN/LkuMI2xK/Xwv4Aam9vVq2tERldC3EM6apAGrUgTcuNxIzsG7nRLxsLcbsq2oU7t9MAlLLZr3M0dchbp/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, re-sending because linux-mm didn't get added to the reply when I
sent it out.

> Sorry for the late reply :) Yes, hopefully talk to you in person next time!

Hello David, no worries! Thank you for taking the time to consider this
series again.

> >> Assume you have a bigger hierarchy (HBP, DRAM, CXL), or assume you have multiple
> >> NUMA nodes with a hierarchy each.
> >>
> >> Your proposal doesn't really seem to be very versatile, or am I wrong?
> > 
> > Let me address these comments separately!
> > 
> > First, for the multi-numa-per-tier case, I think this is already pretty well
> > handled by my series. Once we realize that a memcg is consuming too much memory
> > from a tier, we trigger reclaim from that memcg via
> > try_to_free_mem_cgroup_pages,
> > which as far as I can tell already handles the multi-numa per memcg case.
> > Other than restricting the scan_control's nodemask to target the nodes
> > from that tier, I don't think there's anything else to be done.
> 
> I am not really sure about the "toptier" notion, in particular if your memory
> hierarchy is not static.
> 
> Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
> memory. The you hotplug some HBM CXL memory.
> 
> The meanting of "toptier" changes, which is rather confusing to me.

While I do agree with the idea that tiers in general are not stable, I think
that for the most part the "toptier" node is generally stable through hotplugging
nodes. In your example above, the DRAM will always be the toptier node, right?
In any case, I think if we are to support 3+ tiers I have to change the
semantics to distinguish between higher and lower tiers instead to be
generic anyways, so I will change the wording to reflect this!

> > Next for the 3+ tier case, I think this is a lot more scalable than it seems
> > at first. This series depends on another RFC that I sent out [1],
> > which pushes the concept of "stock" from memcg to page_counter, which means
> > that it is more scalable to just add more page counters to each memcg.
> > This means that each tier would just need another page_counter to track its
> > memory usage, and we trigger selective reclaim on the tier that is being
> > targeted via the scan control nodemask we introduce in this series.
> > 
> > At my talk in LSFMMBPF, Usama noted that the user-visible API should probably
> > remain the same, no matter what. The way I have currently established the
> > memcg files aren't really scalable, so Usama suggested turning the
> > "memory.toptier_XXX" sysfs files to "memory.tiered_XXX", which would include
> > a newline-separated / space-separated list of per-tier limits. Something like:
> > 
> > $ cat memory.tiered_max
> > tier_0 20971520
> > tier_1 31457280
> > ...
> 
> memcgs are currently not NUMA aware, so this could be one possible direction.
> 
> But is "tier" the right abstraction? I really don't know.

From my Pov after working on this for a while, I think tiering is the grouping
that makes the most sense. It is my understanding that memory present in
different nodes, but belonging to the same memcg are fungible; memory from 
one node isn't more or less scarce than the other node.

However, if the system has multiple tiers then the memory is no longer
fungible, and memcgs will be competing for the same scarce resource. So I think
it makes sense to limit how much a memcg can make.

> Are tier numbers really what we want? I don't know.

If this doesn't make sense, I can change this to just tiers 0-3 (MAX_NR_TIERS
is currently hardcoded to 4 across all architectures).

> We'd really need some feedback from memcg folks.

That would really be awesome : -)

> > So we have a way to make both the user-facing side stable, and the internals
> > also more scalable.
> > 
> > With that said, I've opted to leave the internals to 2 tiers for now -- I think
> > it is not too late to add the generalization series when we start seeing
> > 3+ tier systems out there in the wild. My goal was to introduce tieredness,
> > and we can work towards generalization in a future work.
> > 
> > On that note, it seems like in general mm is aware of 3+ tiers, but most of the
> > existing work revolves around distinguishing between toptier/everything else.
> > I got this impression from reading mm/memory-tiers.c -- but please feel free
> > to correct me if you feel like I have the wrong idea here : -)
> 
> I assume you're right, but it's something different if we end up providing a
> proper memcg API towards the users.
> 
> > So perhaps the generalization work would benefit from first introducing more
> > general tier awareness (not just toptier vs. rest) in memory-tiers.c.
> > 
> > What do you think? Does this approach of introducing toptier restriction for
> > now, and then generalizing in future work make sense to you?
> 
> I'd suspect that we'd want to support multiple tiers from day one -- especially
> get the interfaces right.

So I think the interface that I have at the moment (in the v3) is stable across
any number of memory tiers. My idea was to land something with a stable API
and then as future work support 3+ tiers. But if it makes more sense to land
the scalable tiered memcg work as the first iteration then I can work on that
too.

I've been working on v3 for a while, I will send it up sometime soon so that
I can start the discussion on this again. I really want to discuss with memcg
maintianers and migration maintainers to get some confirmation on whether
the series's direction looks good and whether they are happy with my
vision for the series.

And then in v4, I will add the scalable tiers.

How does that sound? : -) Again, thank you for coming back to this.
It means a lot!
Joshua

