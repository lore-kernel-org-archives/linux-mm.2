Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EBBC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C666B0102; Tue,  4 Aug 2026 10:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53A26B0107; Tue,  4 Aug 2026 10:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69BD6B0109; Tue,  4 Aug 2026 10:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B18416B0102
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:44:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADA8180111
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:06:03 +0000 (UTC)
X-FDA: 85063307406.02.0753CF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23DE240012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:06:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD5Zmkw0;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841562;
	b=Qms7qAcR6kxTZbqw7VHtmssY+XS6HaTIFflH9Bcml5kACOS62GqGI2W8nuUdIr7dQaN40o
	+E/FfeFumORmI1B20+Q6kdNbLZslq3Ptt+ysLpYj2p51mb/G+aE4aqwIRJqr1GFeHBpmc1
	Ak/7LsHcnjlA4HMu6baWWpau0Vy5HZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD5Zmkw0;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mc7qeLHMRbW/wC7gufGWIVBnXgSs6EdAYNqGrTgnYxk=;
	b=44cEp/lgHVnHfRvVuy9nkTL6/Dz8ys1TiEIGSHiP1dkeUK+0/8ld6dB6mvTz1qec28v+lk
	CdEIHDxvT/kJbthZr/3j1wYPrV+M76muQWp4lilsoKUPVs1hLH3dey0ZlrPdE+d1hyOt0g
	gxhL/aHAA2l6xJdEWDWuu34SwvQmsLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76910600AB;
	Tue,  4 Aug 2026 11:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA24B1F000E9;
	Tue,  4 Aug 2026 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841561;
	bh=mc7qeLHMRbW/wC7gufGWIVBnXgSs6EdAYNqGrTgnYxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oD5Zmkw0aY6RdWQAIBbdYCG78Nk2rXWrkFZsM3mMlbhiE5pm9KGqkkdsvap9UcY7W
	 xnnd0ZaLiP9GsAPqrHEzYNtK3JWjoR77bSfunQQIY5RhnKuQqr6KpF+LrtULpaIyrx
	 gcCgMkd8YIpCCpjipttzwbUxQnkglxYtOTE+ZkZHJ/a5/hE7uQH6jxFv9+sqCDiwJ0
	 kaY1EgRhdppszstjOWbZpZF4jqfY6cu7Uicd9OgWIu/Rbg0dTDVMi3DB/RlSgf37Ps
	 XkmpcOYaILXsmybetLvLW5De9Gz6Z2wYc2a26LZhIMeiNRcXbs2r1rp52Ec4535LHO
	 M6/k5q/jUOp6A==
Date: Tue, 4 Aug 2026 12:05:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anHG7BcQ8EFrwvGm@lucifer>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
 <7e7c8e04-646f-4135-9ba5-e0c7fd6d8b41@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7c8e04-646f-4135-9ba5-e0c7fd6d8b41@kernel.org>
X-Stat-Signature: myrfgffsfthy9oim9xmgrxa7k1afkb6d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23DE240012
X-HE-Tag: 1785841561-53182
X-HE-Meta: U2FsdGVkX18ImB0DU/A2xqEUJDhYR0hubboHmSyuvKMDqc+lj8+4sY3gdbMl3qCFw6VVK0HVKp9MBaUvVJClhR0eGS8xWb8ykmckWf9duj1ciVGgy9Po5IQDNGSL5OUtuWidmpLvNLXu3fRsXCarKKxvUXs2FCwwdohqeNWzYF+Fkx1O873FPV+/hkc2y+vIXFNpR69IrkQyhLkwz1ITBTiSLDVwO3JRG/gCBqeuLs0Fu/X8jWpkooLoQy7pKs9nmZdtK1qBS+PzLbhCN5uxg7X62halpV0YmITO8NzPrNaL2fMdkeYp9CfswL5/Som7hNxtbeDtybs++n3P540YmJ+omyYnPbw+wKlvSVxOG4MX5fBiXDyLYL7E63gx3bu0bbz1LV7lD4VXaUIEbuuz9pcRz5uHVDfMheBSw/Dfpcg2mxotdk2Ul6BkJy5/IcAISiAFEXVeQx0guWVo8n8Ha7Kql09WiQ02YFpmExMQmkfeDPG96wOavGVMH/XsdLDBtvM5wFObEZUS/9Cz0ejgPC2o/oCAw/yHwvoIfXBb5b38GN561a9Fh4WM7inT68D/M+pxeE1o2ESv+jhm2sJ7zDu7/Bd+QgjzdGJCCSuqmpRw4Qm0lZItjYZ4ThQIECmbTLl3OlAd45quT9pb3EWTQcbKGYb8ivgUNKcDg0zqDS00MDAbDDq+z37mTrMniIG3zWEpC2Jw0ZkZEdmtJ8ebNuGPqpQiAKIln3Q0HVHo5iilF8x/fuCWrlx1NeXYUB4jKmB6yYXfBND6Y9/qtqTt7b0aMIbFa0ozNnt+PNnHzuZ8IeesoaqJQvLRgwWWpTkPoB+KGvWm0pBf1q3RPB4auXuWgSRYhJ1QYXD0iLbp1dcZd2OJK6dff0q76IDqCHN9UuwBDQjXZqqFjSYzphDPjazE+m1jpGgw2ySy8LW1q7InSVV13gwMhwF7qQWu8Ms2Pw71BSp6BGBBjtD26nj
 qawPTtOl
 KPlpPG+m5MOD3Hh0MWO8WfLm6Oz0oadM9ieUKnO4US9+DJA6CegL++bIdE+ISxviYe077pl1wmIvGtfZZUezabeRv/Fvbc2tcmHR9JMAHq3LmOMPfHnRfeij/xbp6/qLVAHJodd82EWVW7+fTne8lwGQVXi5V1qWQnDA/UjCHoJKDBdhdMnj3sTE9nOCTZe4CMBb73SuXBaXB3zDeuryFrexHFY1RkOSicpHJYdrMPHNmpzZKL2EmOiRDjiC6JI86Y6fq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:51:40PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 12:45, David Hildenbrand (Arm) wrote:
> > On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
> >> There are a number of internal headers local to mm/ which reference
> >> functions and data types without including the relevant headers.
> >>
> >> mm/vma.h is a special case that intentionally does not include additional
> >> headers, but the others are not.
> >>
> >> This breaks tooling like clangd (which is where I noticed this), though the
> >> build is OK due to the C files including the headers happening to include
> >> required dependencies.
> >>
> >> It's better to be explicit about dependencies anyway, so add the missing
> >> includes and fix clangd as a bonus.
> >
> > I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
> > e.g., mm/shuffle.h including mmzone.h.
> >
>
> To clarify, I have clangd running behind a vim plugin, and so far it just worked.
>
> I had to generate a weird XML at some point that does magical things for clangd.

Well for me I get the kernel build to generate compiler_commands.json and use
that via:

	scripts/clang-tools/gen_compile_commands.py vmlinux.a arch/x86/boot/

In a build script.

But maybe I need your weird XML... I do get frustrated that it limits things to
what I happened to compile. It'd be nice to get it to index literally everything
somehow.

>
> So I'm curious how to invoke clangd manually to actually get these reports.

See other reply, it's just that I noticed missing symbols.

Actually this happened with vma.h (I sloppily got AI to figure out any other
cases) which _intentionally_ doesn't have includes.

But clangd lets you work around that in .clangd:

If:
  PathMatch: mm/vma\.h
CompileFlags:
  Add: [-include, mm/vma_internal.h]

:)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

