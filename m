Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C423CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63116B0088; Thu, 28 May 2026 03:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C131F6B008A; Thu, 28 May 2026 03:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B021E6B008C; Thu, 28 May 2026 03:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0AE6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:23:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31AEE1404B6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:23:07 +0000 (UTC)
X-FDA: 84815987214.21.E51DF7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8AC60140005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:23:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OTIRfDt/";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHXMoFquiYqwF/6HKOfa/oV8pMDJswOIvcYE8om1ODo=;
	b=7uQZxDiG/ey40wPyGzfzVND14cAXT/tatcqNiTcZMZJAxMSEi7lYDxC7QuXlwLNGZesZF4
	xU+0YOeK2SKQCjSiWjbo7dY9gaKIVJ+MzG0CbCPW+WUmiKQMHmPzBy2kB7YirNOboCA4z+
	knr4Vj5X0FHUTHM5s+15gNjBndbHY5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952985; a=rsa-sha256;
	cv=none;
	b=nMakHKyAF1vgFcEjlkvjK7CMSyQ42OlLZ6CscpAaM0S0lM1SFAOZALtc7VssggdQNKIuyM
	lYeABaZse8WXzZfeu7of1hv1VUeCrJDsxlvfx6l8H51LAXV5Fb+G2NasnUzM07m4qM9Sw/
	clJByZDUvzB7RUfq3u/EJ5oi4MsM5b4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OTIRfDt/";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D58F437BC;
	Thu, 28 May 2026 07:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC161F000E9;
	Thu, 28 May 2026 07:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779952984;
	bh=HHXMoFquiYqwF/6HKOfa/oV8pMDJswOIvcYE8om1ODo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OTIRfDt/2crw/q20AADL1qU3uFYcIxvzokAPq57kqI0Dt8zEfl1g1NHG1Nb26nU/F
	 DHFzUIUYs1CV1HX3AuFsYZv8rP49097eA9j0zjzuOCvXjHxV1MNVCDilr7IF/W84tx
	 Xia0Bn0OXpFx/TEE3++mvy8okZ3sKdRUTl53UkwFO90uScJPgrnevqogE7olUAUIHO
	 ntY8Ju1RmAsHVIEDDKZrW0iJRivTGwnL2hVQuRydTRvQjZfhWcuBqMerbEZigtcjK0
	 1C88h/AeIRGhRjW6T61m9LqiitqN2pEI8SU4e71uQ0AdquRlmsaCCEV72/eGyNhT9Y
	 L/NXndorMH/mQ==
Date: Thu, 28 May 2026 08:22:48 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com" <dvander@google.com>, 
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahfrzwK-RsQOKxy_@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahbSrt0B1aQTwrk4@lucifer>
 <288935c5d9d84794a9120893f61e670b@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <288935c5d9d84794a9120893f61e670b@honor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AC60140005
X-Stat-Signature: d1bekig8ri6m5umj8rdjka9oizwtg7u9
X-Rspamd-Server: rspam06
X-HE-Tag: 1779952985-22773
X-HE-Meta: U2FsdGVkX18Snw5+H78jCO9GsbpyewTtkAAcdTiQ93bOrHGrAPdCpT5qPf46cL1ML0uaKndOXMNQBCL7d5i50e+Fx2ZAc3K7v0gFxt4SMu5FYpRq8ibPhwgJHStb9hIvmx/SLr/PpM32+9tJamVQqu6651ZG/lTyTacza1hsRcBgUD7RD9RF+D8HGVzo+F19SK7KC7ZhAr4OkCQYAOGPYESAiyugd6kbUkzR5h/4ey4A/pbO8du5CAzu3Pds/Gf1FeHOkb5uXbQTuoR9zHu2nZAUNs+VIaKgFmZXeKun0Gq3ODyWjJ6IIWxbMI6voZJmlrUVoXg+I+6If6uqWczNoGEwsieQ50qgChSgI/w7V7xJkaQeB5DgOXWBmu3ocWElUvmELAXAfb1kQtDGWoib3TrzZbhB0IDcGr7l4PD/KXtM9XmPUHOQG054yToJQfBiNWYcJirK23Du4CaMudBs5BfvWfARYxi+TC2lcw6R2sxHLujaF6/itODaIWGdw1iP2bmv2KJPKknBzumbU6HM79ve3lUTHNKwuT7sGf5hqvuvZBjqhvJ0zwkZO1eKpUmzP4gPgBuqH6tPcE2xP/YNQfAtox2pKEf96NkDRykVs6CPs0aCqTyJAaQSS7LwsRkEGeElvVVGEkI9WtFKRqFFc9vqltaCkqNeG3k/hZ6EpE0OyfaZqQ9+mYE8N6AsiciwjZYvE38W9PEPHLdB9UuSqv2nLjAoMHhk4jiUT5BQCE6wThjaEIls3e+8/25Du/cH563YEhb7MJklRudYVxO4kyHBdRBW2vGGoFLPBxXx7o4VM753ya5nWPKUm3aL2nczAJ0oZRIuxM5+7vZqzNZUPYvSXKpzjBKeO6au+tSkL1khg4c/HZ8QaDzJBYU2iOaIv6qjL9hpEgpQmlLV5RaU2MLjWU/UjPxsgQNlYBptKcQwTFnB7AaAcqeejj8G1eEJfDxjT9YXF+mmIIgoEJX
 IMhX7NaO
 pU/Dx2OEF2WcHc0Zg55LIFBsS9YRNNa+e20iWNkNgLMf22/6B5YkPsOaFOLDWocGqqqKtK3lAuJ/hTo4wh2YHQnyM4WFZWuRGTvrKCML5kgYWnefkcMgx0mN5FAHeYxe/4/erXZVWymfkKj9iu316tEHKIm8XY2FMOLeiLgeL89sdywflLftMqaNInoXAPncUhhgosCqEzxnCqMuwQ0DHubaR4ohmnKI2N+X0N4hmEllUvus6bSjFp18Q2/BSfGU4Fyr+w+3AAD9sTq8J2vbwVsTgQ+WvUYud1UFyPbTy4+Mn5Oy8K48W9+UViDp8cO9MVmw+Rd4HI4ZeQFVooaMWO8NC+/0YooNcd0gjTk/WnmE1NCIclu5zJI+Dnka1Xr2EOBNxbdQ6ZGFJVUvV2wRRx4e85bW64lemF7dt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 07:11:19AM +0000, wangtao wrote:
>
>
> > Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred
> > anon_vma creation
> >
> > I'm sorry but this is not how kernel development is done.
> >
> > You're sending a series that's very invasive, that you've not coordinated with
> > anybody else, nor have you mentioned it at a conference, nor engaged with
> > in discussion with anybody else in the community in any way.
> >
> > And you've sent it without an RFC, at -rc5 is... quite something.
> >
> > We do NOT want to extend or expand or hack in anything like this on top of
> > the existing anon_vma machinery. It's a mess that requires replacement, not
> > more hacks or expansion.
> >
> > I've been working on a replacement for the anonymous rmap, recently
> > presenting at LSF/MM, and all of that has been very public.
> >
> > In fact I have engaged in recent work which reduced lock contention in
> > anon_vma, it's really quite discourteous for you not to have contacted me or
> > the community in addition to the above.
> >
> First of all, thank you very much for your reply.
>
> I'm also glad to learn that you have been working on optimizations
> related to anon_vma. I noticed your work from another email in the
> thread.
>
> I apologize if my approach caused any inconvenience. My English is not
> very good, and I have rarely participated in community discussions
> before, so I'm still learning how things are usually done in the
> kernel community. If anything I did came across as discourteous, please
> understand that it was not my intention.
>
> Recently, due to increasing memory costs, I revisited the memory usage
> of anon_vma and found that it might be possible to reduce its
> overhead.
>
> My original intention was simply to experiment with an anon_vma_lazy
> mechanism to reduce the memory footprint of anon_vma. However, while
> working on it I realized that anon_vma handling is quite complex. In
> particular, after multiple levels of fork the topology of anonymous
> pages can become quite complicated, and it also interacts with other
> subsystems such as reclaim, KSM, and migration.
>
> Because of this, I tried separating the functionality of anon_vma
> into two parts: anon_rmap_t for anonymous page reverse mapping, and
> anon_vma_tree_t for topology management.
>
> anon_rmap_t provides the reverse mapping interface used by reclaim,
> KSM, migration, and similar components.
>
> anon_vma_tree_t manages the topology internally for operations such
> as fork, clone, split, and merge, and can also indicate whether a
> VMA has experienced page faults.
>
> My hope is that by separating these responsibilities, it may become
> easier to reason about and further improve the anon_vma design in the
> future.

I understand your approach, as discussed it's not viable.

As mentioned elsewhere, please refrain from further code contributions to
rmap, as there is now a trust issue due to a high likelihood of undeclared
AI-generated code.

You are, however, welcome to engage in discussion, and I'm happy to discuss
the approach publicly on list or via private email whichever you prefer :)

You are also welcome to engage in discussion/review/critique once I produce
my RFC for this.

Thanks, Lorenzo

