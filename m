Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93842C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78176B0254; Thu, 13 Aug 2026 05:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EFB6B025B; Thu, 13 Aug 2026 05:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91C76B0254; Thu, 13 Aug 2026 05:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 891F06B0254
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:31:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33BD7140577
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:31:40 +0000 (UTC)
X-FDA: 85095728760.21.DC8A20A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7DCD120002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:31:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mt1DAUli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPWRbYV6TCDAvxwAQ93r3v8jMQsGV73j+wzwL5QA0LI=;
	b=aUebT9W+fAIIg0nlujLD0YxfMLisLnbhwC868mTdpb8jtlpQp0wzcaKepyMpTJGNMcxeze
	o67n9JoqO6xGNTvGxoUFYbdRgSz6ZWX0kpi9HyI9WNdcgJ28Kw+qhPrfOOjBVul+gelSYO
	uc0SWZLGhAwroWDFV52Tom0lOl08AFo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mt1DAUli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613498;
	b=y3RjuglQvZ1kSxU0yWU3eAAOJV06kufhWAoMibl2r5Buy23YAnY5F58Fjy5p8olffiiTvO
	iw95/Fl/KV8gKdKfd4z5/NhirJalwrp1WB3nebi5WXyK1a0rKV23Da89y6HzuaJbQGniyZ
	ZJxUlHWWP/RNKH7bmtNIdbq/l/rrhZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2753E600BB;
	Thu, 13 Aug 2026 09:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264371F000E9;
	Thu, 13 Aug 2026 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613497;
	bh=RPWRbYV6TCDAvxwAQ93r3v8jMQsGV73j+wzwL5QA0LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mt1DAUli6E0KbctTMEUJSRtrDQt3jR7WNsGXypzFOmMb4zRkFkZrMgW/HP9bC8TWV
	 864GweWLaUewxzREk5i/Trv07mMBnEdtKN0EOaPz7pjLJNujHFJZVnQ3H0e4JqPVKt
	 jsWrbVwp+kL5kr+aY2a/eP4VoFqtxJBV2EG6Npi5V+iJLJC6b7Y+zxiZDecN1VHBu7
	 Oiskh1H9493M1rkzR95i/8kYUaMsjtMZmvUrbAi18rJ5niihmnRwF7/ROMTM47lj7H
	 Ff3mCt3CBqo7Z8WeQdP9QUhF80uN53Vl1lKZa764tP53Bs6/UCXch97fy800Uvef4j
	 whKleZqLtk+2g==
Date: Thu, 13 Aug 2026 10:31:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: david@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, 
	apopple@nvidia.com, bp@alien8.de, byungchul@sk.com, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com, 
	linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, mhocko@suse.com, nao.horiguchi@gmail.com, rakie.kim@sk.com, 
	surenb@google.com, tony.luck@intel.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <an2Nt3Wi-WagS0xP@lucifer>
References: <anxOOiuSIL6tjufA@lucifer>
 <20260812115529.247548-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812115529.247548-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: A7DCD120002
X-Stat-Signature: 4ghmwu7sndtzyczet85kktxb76p3wjra
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786613498-13893
X-HE-Meta: U2FsdGVkX1/5sxcqt2xKlFHg+UKVyyrgyLX3qvu7XK7UVX+/qo76apYmO+jsZc8pjfG8dHxG7HR9o1rWG9TqnNlw8M9F0Mh/olr/rjL4sHCJtxnkWeQ5/+o3qQfK4fkWPgs+0dd1vzneMnbWNM7Ap6JCe5DLuQMg6UfwFZCuYUUvxHyZF9lBB743KbaSKqVykc5BZTwS2jKjja8WaIVuCEuO4gebaxOfcDzi9exZVT1gZ9PAPCJySTKaR+4ebsnYfsGebnlwYUnbTpkOgh1Nwvx8u8gdI0V3HxbE44u1lLL7zsQQDpCCh2rSGZ+RsRgowSy2xTUtOKEj2pK4FVoMuuxvbIUi+0DNvKsu9+XVP9/qNAy7VrtI1L4Nj/CcIAgjpUKHn4PrgJXC0+APJZYB0TZiip/b+xvQavEkVggNQ0Crrt9y1iEjhH9V9ofy3RZeDZEnsHwjdoJ+87hezEwVLveubAdPWft0ynUELfG/6+MsH0zMVYaNclsKDtC1jVHmQVWDNv7PXLbPYP/FSQ22TMpmUaT8tNqW7MdgqBaTfztE6SYHODygbfnTWVMuRKL2Rl8O6WPreBYsRgz67/7QvHvyBIqN2f5kVrpvpi0FWbFXs7EhP0LVzJLuJxc9nqASg49/8zprnPPAfD3ojdvB8IbQw9DY21yUv81ahpWSQXXHN1J99AMBfg1DpcT3l66iPhTju1zPvfTQjfvYGQLVXM7Pm1LZxtyhXXUJvN+R8uYUaiVsHf0SThyFjTk+2XDwbQbGAvO6dzMenFHO8qxrbo6xPkjiBMClVjZou1jXGv7CSr9UFy98+NlIdVIG3alA1TRFZ16+UJWmCR7sQ/GkDvW84q/8ofMOBzCIGuzO3PgTeMKiSd5VO1+Q30rFbvgqDcbeqMv8pjhhmkOm+9VW7D7VPtG6NlQH7mju/IXAZgiNzYAT2q7hnA8Dhv/bD5GBFyrxx0Z4YgL4zbUA8Q5
 Ux9XMCW5
 sK8A5FHbqj0hOcBZ81uwpF+8q8BtoaVzpv4xICpjt4YjzWQnGmNkxLBDWdIHvAeaeWrTtTFydpJPxhUq8687+oRRABKeOHeU2yWEf14UVAM7txpyi/7SeDNTdlBcVElpZwYF2+tfIN1GGQDIeLtYsjQuGyyuMkPzeGX+NSi27VRVB9wIvKjwqL+0RHWjEojlF3zwq05NkEg3LWOK35/0bzZXSZFt+4zZmeqpyheZYijVSucLOpjhB0agARFvqN/PC/7kJM0LKuXPe9o27r9rYI9yimIfPKjOUAtN3oMwQ+hjjMMumNpWH+101bwVDxp/fE80r8Col2TSBLZ4AfyvKjSjfkoMsTgFGauT6fRvuehRFCXnTXHavz2d7Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 07:55:29PM +0800, Xie Yuanbin wrote:
> On Wed, 12 Aug 2026 11:53:29 +0100, Lorenzo Stoakes (ARM) wrote:
> > But you seem to be implying the two options cannot both be enabled, that's
> > untrue:
> >
> > $ grep CONFIG_MIGRATION .config
> > CONFIG_MIGRATION=y
> > $ grep CONFIG_MEMORY_FAILURE .config
> > CONFIG_MEMORY_FAILURE=y
> >
> > Have you disabled compaction somehow?
> >
> > It sounds like your .config is broken and... you need to fix it yourself not
> > edit mm/Kconfig?
> >
> > If not you need to spell out exactly what config it is you have where you must
> > not have one of the things that select migration, but do want it anyway.
> >
> > I'm not sure we'd even support that?
> >
> > Right now:
> >
> >	CONFIG_COMPACTION (!)
> >	CONFIG_MEMORY_HOTREMOVE
> >	CONFIG_NUMA_MIGRATION
> >	CONFIG_CMA
> >
> > All select CONFIG_MIGRATION. Why is it that you cannot select one of these?
>
> As you say, currently, MEMORY_FAILURE and MIGRATION can be both
> enabled, however, you must enable one of the following configs
> at the same time:
> 	CONFIG_COMPACTION
> 	CONFIG_MEMORY_HOTREMOVE
> 	CONFIG_NUMA_MIGRATION
> 	CONFIG_CMA
>
> However, for embedded devices, these configs are not always enabled, and
> they can indeed be manually disable. This is the actual situation I am
> currently encountering.

Hmm really? It's a small embedded system that still needs to defragment for
large folios?

But...

>
> > What
> > weird config needs CONFIG_COMPACTION disabled but does want migration just for
> > soft offline debugging?
>
> It is not for debugging, but a real configuration in the production environment:
> 	CONFIG_COMPACTION=n
> 	CONFIG_MEMORY_HOTREMOVE=n
> 	CONFIG_NUMA=n
> 	CONFIG_CMA=n
> 	CONFIG_MEMORY_FAILURE=y
>
> > Users shouldn't select this at all. And this is an absolutely horrible way of
> > resolving whatever your real configuration issue is.
> >
> > I hate hate hate this. This is just completely the wrong resolution.
>
> What abort making MEMORY_FAILURE select MIGRATION, just like what Mike
> Rapoport said? If it's not appropriate no matter what, then let's stop
> discussing this patch as if it was never submitted. I'm sorry about that.

...reality trumps theory, so if this is really a config you need, Mike's
approach seems the least worst way.

So respin with something that just adds a select CONFIG_MIGRATION there and
please put a description of your real world use case in the commit
message.

I doubt there are users who would find the combination problematic.

>
> Thanks very much.

--
Cheers, Lorenzo

