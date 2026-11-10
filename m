Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF371606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sxzp+Vk8
Received: by kanga.kvack.org (Postfix)
	id F41FC6B05B6; Tue, 10 Nov 2026 05:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7BC6B05B8; Tue, 10 Nov 2026 05:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CD26B05BF; Tue, 10 Nov 2026 05:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5F016B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:16:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 377351A03D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:16:38 +0000 (UTC)
X-FDA: 85418805276.04.630F69D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9312918000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:16:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sxzp+Vk8;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794305796;
	b=lgJrmKde0J/gfJ+3Ix+RyzDq2EKilrVXAmUwvZvM3e7AS5Vf30jaRTvrUxbC4n4iR4I5u3
	MFMKwAYs2TiYFKJ+XViUtFbpeTxC6l923J7jtN3QL7TiwTXMK5Vo2jsf+c7YPaBcAJNMou
	wFioHpMVoxhJKfg0tDG+1CeE3kb5Syk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sxzp+Vk8;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794305796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDp3IqGPnUg5d4UvWr85er90NqjbtetB6LOR1Vib6ms=;
	b=6bWwNVdBvI5nxBi5KAsQC+aJl53qyAz8Xr1oSXxd9m7l63dnrMLVp7A7wiKo5fkTWH68oC
	of/CyVWoA0IXpOhpj5rD7aeGZ1RLgj/uu5ZbAuOkiAupMBNDnG9vWe63drTN123a8sxeGQ
	ohMrfnZP3+LGfGaAlMIN+0LP6806SpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8E96611B6;
	Tue, 10 Nov 2026 10:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB011F008A1;
	Tue, 10 Nov 2026 10:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794305795;
	bh=MDp3IqGPnUg5d4UvWr85er90NqjbtetB6LOR1Vib6ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sxzp+Vk8VglSZ5vV85C7ikwtPz+uz1IRnb3NOrd9Wun8KllMzb2LUbi+i6S0gLMcN
	 5jXugi37YSIvM3zftdxNZttbrWR8y604vZbxqGJdcnIz6gNkpmozDfKF1jHBgGboZ0
	 DcGcz+RSyCQJi3bdbkhFl4xPL+IMrYUIlHLE+CUR4GHE1DWdiu+2AsyFGSd+1Rmb6b
	 pmcE6nCVlxkLCoRYQDlfiqboncz8qtKqB3XFd0hUkPaQZ5jR35v1bgqtrOve73lm8+
	 rPRXSAbkTAra4IPA0HVOaQx4A0yI8AKrAzEBsuthbisPV/Z7UV7wlm7ln7PcMu+wBs
	 CPNwrHnTMpM8g==
Date: Tue, 10 Nov 2026 10:16:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, willy@infradead.org, akpm@linux-foundation.org, 
	osalvador@suse.de, rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com, 
	ziy@nvidia.com, david@redhat.com, dave.hansen@linux.intel.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] memfd-based Userspace MFR Policy for HugeTLB
Message-ID: <avLunMb-pVIigmkT@gremlin>
References: <20260203192352.2674184-1-jiaqiyan@google.com>
 <ahXI0cK9fsOByvKy@lucifer>
 <CACw3F51Q9TkMWr4WbnN07q60L6vj72-hFWwpqf0n6rf+drfb0A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F51Q9TkMWr4WbnN07q60L6vj72-hFWwpqf0n6rf+drfb0A@mail.gmail.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9312918000A
X-Stat-Signature: 6rjr6ayij6bbuk9n74zw3rqa7zzqn8gi
X-Rspam-User: 
X-HE-Tag: 1794305796-150100
X-HE-Meta: U2FsdGVkX1/UCeHIh26z7/XOMj1kpuMyxSRqKBnVF03iZFkFheBV9BbIi7LXnzOelhBCxjYuIc1LylrfnKXWYRwKgqtWP9Fzm1Te9cen/H5OZ8z3uOQQGijkp+hofFmfd+6cIaLM4SUW1y1/0tsa/3sz3qF5bEHYfESBQbNxv2551O7uWu7jpyl+upjW+QW5D/gygRgqL82jNW7/L5O7H/jABFQKHG0xVrwQgAWnreZKcQmUqQbDP1vPVYuXY+55UXWQHA+pn5w9bSOGLoIX4cYa7eECEpwPiArF+e1J6sKgQFQO2j/pIrwPqqDtM71PjIv4hCMWXSDINM5Gh4F8gagb1oGYGG5KSg3iacgV31iKyHms5l2vich5DEdSR/iAxOg8elrOQXsrqdYOqlrfiE3THE83UKSPdw2cXeEG7MgBfq5gNVbS6cr7JC2YzcMW5+i7kwZP5EMIgi7xQGq8+pwN128misDfX3QcXStLrT6g6nmVfxEyuzBWL+I5jxWRTfKwARnQfWKh2i285DC4bS03u5mPeWW4zKmFuHjbv+nhUI0qSntQzb2ms7m/aVG48QcLvkXFYKu/8fzGfJHHnDM+8cUmuKqlwUhcNyzPmE9wEz6aAwArYAov8dVqpmHAEeJQpz5x+nLwOvxSjp35wQGh9ooGf8c3an5xK2oMhxQr5t1hsuPg1fdzcoO7g6UPzbwPNIReOj+ZxzG9ombGwWaakCg1D/IT+U+aPfN3/LRYTE5CvFenxZTKedbPLhHplYCGYrbpUDLd89zupj2POJAWjAObc/XZCOaIiGsGcC8oMPQpP2vZzTLe+oNshFOhenD7FAYH+BoBCFEWt+ANuGKzzKF9z/uU0L4Hs71fpH4d3WQwVpiiqMoOoVA8d0IGc4ObaN5WzGZ+iD+u54PJZI98kUCsr1V/HaWXw35+Aktp9kYfXe7RmjJ8iDPmQtBS+TGnzJOzbQgS6vgxdDh
 ADBFNGie
 RRjqzVmq2EbuyQQTj4sHvCIIkfsraHRm5v8OzcriKjsfxPg2xKgeP0RYb2IH3NCw3itjl2DFxBC+wxl95dgOqliKtNNnRFr2WPRd1DvcGROE9u0JcenFaNzdUxtIjY1Aw/bVOySdSTPHiQbgCMiCvqha8lxne0h2ri7hqPEXQQc4fd6uuwDGrtg2VPJbeVsfOlZj2Lc2N4IQT6yNjLpqjAu7c0mp9p8uJyphnwETvC1+/6EmgFr8zsfK2yOWBi+X5rQt4T3JBr/LXkHiHvLMPpoTZa23WCF8uxmwtJNxud6mAwLb7U5QwpueVQaHYX+bC9Kln99oyiWx9z/zHC2lcfx56YAXr9wrewLCy8zwb9Hk/AijnUWloUiOhQpUj3b6Rvd300N7/MCTRjAUeBfeclwCooHzUd09Vg8WXHqsvc6BiwpnBi3UOu/wRAL4TKcgLS+D5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 09:45:24PM -0800, Jiaqi Yan wrote:
> On Tue, May 26, 2026 at 9:23 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > Hi Jiaqi,
> >
> > It seems this series got stalled on review, wondered if you planned to
> > respin it at all?
>
> Hi Lorenzo,
>
> Sorry for the late reply.
>
> Yeah, I was stuck on the issue Miaohe pointed out for quite a long time...
>
> In offline chat with William <william.roche@oracle.com> he expressed
> interests in taking over this patch series. However, he seemed busy
> with something else and couldn't get to it.
>
> Fortunately we have more powerful AI now than we did six months ago.
> While I worked on [1] with an AI assistant since 2 weeks ago, I worked
> out a solution to the issue Miaohe raised [2] with the help from AI,
> and now a working draft patch series. I think by the end of this
> weekend, I can send out a v4 built on [1], the patch series I just
> posted for freeing high-order folio that has HWPoison subpages.
>
> [1] https://lore.kernel.org/linux-mm/20261110053331.2708996-1-jiaqiyan@google.com
> [2] https://lore.kernel.org/linux-mm/5e0fc743-eb44-b69f-01a2-da7b6f2eca8d@huawei.com/#t

Thanks for the update! Though do note [0], given the current wave of
AI-generated fixes this cycle is focused on that rather than new features (sorry
I know I chased this, but nobody anticipated how busy we would be with these!)

And since you mention AI, obligatory disclaimer: as with everything AI - please
rewrite all commit messages and comments in kernel mm style, and make sure you
understand every bit of the code when you submit! :)

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

