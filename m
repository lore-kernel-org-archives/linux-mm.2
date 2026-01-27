Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60C4D25953
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60586B0088; Tue, 27 Jan 2026 01:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EB06B0089; Tue, 27 Jan 2026 01:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0206B008A; Tue, 27 Jan 2026 01:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA76B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:53:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C2C4C34F4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:53:38 +0000 (UTC)
X-FDA: 84376828116.13.A87E88D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADAEC1C0002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:53:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kSCpHrcc;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769496816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK1a3g6mxnXBOSM3Ki/8fC4ZD69nPUzU329MrBIqzyg=;
	b=QiKENB/dzSp/J76N1CcvlPk9nxcyY5OB3s/0CjD5qeuPcO6+oKMFV2mMuwrKhdljU8XMWH
	+zE9BouaebouNsuB82b5oMTdFQAng8sDh0JXFW+uJR7G2VXD3eCnCENP15qJJcP0LL88Gh
	60J6DyApYQSsSyyVy5vv9NP0B8OAZZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kSCpHrcc;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769496816; a=rsa-sha256;
	cv=none;
	b=mxpqIuoxopgCpD2u2vH+hBgLH6xD4bkpmtuxdT4HtQBE9QWcfaJafKOCzlnh5p5Hlbh7EE
	bx8Q1N8bJTmtNPKU42V6bZJLY8VqXk+GD0/TW8ftXd/Wnx0rqiOZSN7wJq+5RddrpFny8M
	tWApaoA4+YwMzNJldJdqFqcoRW0sckw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19007600AD;
	Tue, 27 Jan 2026 06:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B3AC116C6;
	Tue, 27 Jan 2026 06:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769496815;
	bh=50wMCzxr36MRlb1hSig1KLolI+AyaL/USxre+7UqoW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kSCpHrcc9e+sZ5hxdjPvDcrO2ANHSEr9mFBfkc2sCkkCnk7Vpf8Xo94IUKBkBtb4e
	 HxnM29pvbD3YkqtTY1qCItMhmppAIqRA7Cj7KplC8P7rfD+aytMe4x/K3vx8DrrG5b
	 VjK3DAPcM8QT33XIA4zPfsH8cQJv2LG8zBM4EA25ikAhNmFTcyrpBeL1/y2DU5gLHt
	 9JKejy2umrwAxpOTtRvcS8K7hSr27xEroJdsksBwtOfKhMOCdtOHD4NZNLDtdIRN/U
	 +2z91rXhj0DkRN4oHVpJiU0q4owEH1A7D/fdAZ4iRMzkDz1URC/sRK/vDzEDz4P/GY
	 +CENkD+NbHKOw==
Date: Tue, 27 Jan 2026 08:53:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Li, Tianyou" <tianyou.li@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
Message-ID: <aXhg5k_iAwzQr8Wa@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-2-tianyou.li@intel.com>
 <aXIHG8MQhMRt7M5d@kernel.org>
 <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ADAEC1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: fm9kkzbw5kgtwi5hqmw87wtbjmwic9sa
X-HE-Tag: 1769496816-912498
X-HE-Meta: U2FsdGVkX18EpjZcRoSIqOvsNH8mwQh1haHC6tlHZdgdjdJxtuRlya3i2YAfvnYNGT1jLQ+2G4ESaHdxFoBz/7aHUZOgsfC8WlEvIS6ptsydvLbqWs47eBYDrJZ5FprRxvm3+2MBNjg8tSeN9fLyOGbthfcKkomuwiDuiDo6iv9TA46Fk0ffFjSYv7Xeb0Ja58sx+sgO/9X5B3oRm9RH2FnVo8dOqEnoeccGqUP5FHPtMnPeO44KJHWE+NHplCEN5+J+UNlmd68XWv3EKb2oy6dJiOLgYUfI7WDBE9/GiVIv2MeTLhCD01DCXR8/9/jukWVnSge/IhEngvAT+nYI9gtXEKgAgzl7tyif3Jo9qZ7+2sWkeZB15loJ1h4wTdPlM5AEhfw1xBsxtdm7gTCCD4zkJLorUV1awzxXGDs5BLErITO2H6gCNjR3aW6H7kYykJm54TzYXS1sGBGRjSydCE3D9QCedU4o8HISUQRUiowpfkmj6WsVHqez6d3OQ1hrl4+tPecGinxiHuZoZ4GmPH+LJi1cC2ksUEiDL9b/blg8fQ5MUBWk5IaVMemONjI0gYGbtxOnLlawtvNvS9VvBboxHzrW6Mfj+qWuS3ghrYRuzpmgy+rDeCdaNum4HDBk26JuiPtUPCdoqpN6a+Loqo/2sHEunsDMr2kun1D8XEJycryZl6lv7qYREOSDljo1ThisWhX6V9VzdAHyW3r60BvZEmJQtI4HytzO2AJwfijYgHU5ZJPiRlWNA37O93NcMIaa2SSqbUg9OUjq59aJ+iRTozO5kv/UfqvlSDEvCsFYp2i2tNsy1UGGLIzLxQfTYkgdoJc1M31lFS0VKY27r2YpeS2bFOvc8iOxAC0ckwpWrL727A34SW0rmF7ZmluZd8+vyi3l4lYfPTcmEpFLmMeVystK4Pdn56Tv+ghqlOjxmXwaB99zn3rUJo43a1jT8yiwj16ZRcwhpkNjh5C
 HHM0KiJu
 hztSh7M3A7XQo8UCa51rdsc/YiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Jan 24, 2026 at 08:18:39PM +0800, Li, Tianyou wrote:
> On 1/22/2026 7:16 PM, Mike Rapoport wrote:
> > On Tue, Jan 20, 2026 at 10:33:44PM +0800, Tianyou Li wrote:
> > > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > > index a63ec679d861..c8f492b5daf0 100644
> > > --- a/mm/memory_hotplug.c
> > > +++ b/mm/memory_hotplug.c
> > > @@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> > >   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
> > >   			 MEMINIT_HOTPLUG, altmap, migratetype,
> > >   			 isolate_pageblock);
> > > -
> > > -	set_zone_contiguous(zone);
> > move_pfn_range_to_zone() is also called from memremap::pagemap_range().
> > Shouldn't we add set_zone_contiguous() there as well?
> 
> I did not find the place where the online_pages was invoked along path of
> the memremap:pagemap_range() function. Would there be other functions to
> online the pages remapped? Much appreciated for the guidance.

Currently when we do memremap_pages() we have

	memremap_pages() ->
		pagemap_range() ->
			move_pfn_range_to_zone() ->
				set_zone_contiguous();
 
Once set_zone_contiguous() is moved out from move_pfn_range_to_zone(),
memremap_pages() path never calls it.
I'm not sure if the pages added in memremap_pages() are online, but to keep
it's current behaviour I think it should call set_zone_contiguous()
explicitly.

-- 
Sincerely yours,
Mike.

