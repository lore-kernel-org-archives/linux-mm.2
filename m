Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435FDD25954
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C5B6B0088; Tue, 27 Jan 2026 02:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9F76B0089; Tue, 27 Jan 2026 02:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6316B008A; Tue, 27 Jan 2026 02:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5E96B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:10:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDD1CD3F80
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:10:27 +0000 (UTC)
X-FDA: 84376870494.09.10183DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 176B0100006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:10:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPTXoRAU;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769497826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+H0rOprrggozII+v8Mnv7OPBh2DeahdPFLXV97fGJ4=;
	b=TqcoyLdwyfmuh4dtqT2pklDWmMRUBYueXcxNo455pSGx+YTsYWHRnUADmca0D1MxppqqV7
	3I1DTAuAsh4B8V8lqlsGaMlSFXrtPP+mbte2EduSLcoJeypBsRUKiCsIDa7wTEZlpz5RZu
	Q8ldLCa3R3tLt+m93bV0czl+u7iK1w4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPTXoRAU;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769497826; a=rsa-sha256;
	cv=none;
	b=KHUxw+7M8Ut4jJQBD/t0Sln6Y/i2nLzgYEElH0RlLuv5d8mS7oxVaPKXR1AXZ2fP9APidC
	oLyulKq4q/aapVtF+sDm5v61FO/sSg6oxhcTl3IJw3qSZ6RplpgjSUIuZqyiuQL4tJkoxS
	F+D2TqgRYSa9ejHO5219ywYuisXkx80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F37A7440BB;
	Tue, 27 Jan 2026 07:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76B8C116C6;
	Tue, 27 Jan 2026 07:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769497824;
	bh=cf47isSmYP/qJ96nAoYSlmLKb5vr8p7KFIfjgd9LveU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sPTXoRAUZy7+5HMmKMBg7oSDx64qfa2bYEEcRd1o/4Rk20ewPDlkj8ugKo6nycHZv
	 LG6LJWVSVw8nme8XzLP5CNSpb/oDtkNZvc7+JBFo2DSXs7d8gdkkhGK9+UZxOb2SW9
	 IwcJavRooCZYjp4ma7NgJozCm0ultg3bLazNEc5LXy9otDU9MGBCdMh1B64FUO8dqM
	 UIh4fdAuoO9azteRUa7wIMQHR0OEYfKFFg7USkJBD3ZQpFUB5JPAsXvEO6i+WJWwCS
	 6jP15uCkjKqLjlpVwHJVQ6xFWw1lwN9Eiw+/QSa8p+QLmdAZJBBFfjq8NMqVK6tTyU
	 GDPIqWXYSdYhw==
Date: Tue, 27 Jan 2026 09:10:16 +0200
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
Subject: Re: [PATCH v8 3/3] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aXhk2F3gSXHnCo5s@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-4-tianyou.li@intel.com>
 <aXINUc0ZJSJusel2@kernel.org>
 <0f679956-fd29-4165-a136-18f68e517fb5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f679956-fd29-4165-a136-18f68e517fb5@intel.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 6txmyic7ckbw969cnexh6aa9ysied6e8
X-Rspamd-Queue-Id: 176B0100006
X-Rspam-User: 
X-HE-Tag: 1769497825-894962
X-HE-Meta: U2FsdGVkX1/xuQMAGN6JJooHIGIv2EERNCitTBCIRAIQrsDhB3JnvU7A2IOtIbVr9/yOtnO6AsAdE+QgnECkdqsEmnVlBmt0pTMsZ58KfTRngTSgbThBKrJt6LUP6FejMAZtkch4heGVJK/8oIhucNy5UfTnhmFdJ3U48dxIOeeKLuFSKZCqHBBkoBol7OWu6hb6p2vj2AIsj+J+3l5Z2Kc6rv85pd+PwEmsMECd8vMQ6uJR8AJoIq1wLdvkLkp3X5wblaTJ3hNcTlQXA1xidtgLr0NO7R+CTZmxeyv0wJSFgb3GFdzXM0zTwH5ecYOeDB+tgbhaz0h33SZpeJpAqEGM3LpcsDXdpPM77QBDfNnQo5SXptbf8ROnnaLSNDq36tkFMmzuxUaShTp2RIj774l7c8DYdMC+JmZ989+N5j6rnnjKFJVlUqKYRn0x87M4DAkf/CsiugdM//x8b3JqyP9fDeHgRrSszme6dstLPrNHJV5zM1G9np52tBiP7Y3EDGk/u2IUdG7IGTxJreUKaAl7G3f8Ergtc5DbODEsZY+BR+ScXX5UNz6k3s4vGiWrLO46wbRUxY4QPVlGtTELYFgmuBmX4KtkjKSQNVcWugI/82SxXyZ2TQqQwNN44USaPzPcB7VTabS95vLttFtHx3cZgDuJLDW49AZJGAtmres16hEBW+DotLGt+qyLd50G39mboHKP1JE2ZxWTZ0XadfVPu8xGAsUHbBifcPzsqFOMaKZLpp0l+JlnzKTYpL8WSbbMi/Ka/dBnF9McsKDX4o4x8hTI1eDPiIo4O6IVj5IyyNVzZjobjtd+A9JlcXbvbASUlLe5Zta10rUj/9BRZx6pShHHmIIG1Oh03cTx/P/7SUxL+7N9koDudLiYODzQ1ZxMSrDuuqkooo9rGaBHCFe4YKmph3Q5cTgszhEAHJahnp/k7P3xJ3SfHswrTbhl2Wsbj4+gmEx7IM02kxV
 FipTHGbm
 CEVHSnDJdypHsyyLLdiLPpexKodPi5PWTQ/yhXPeDbUStABr/08ImKi6HXyMzr5qpFDurq5vrWUhaBJirOxUqiOA24/XCqPWQjKpUSHRwhYj03wfi+scQ4VeArH2/9zGXRVeRhaLdgESon8JKScpT2nGnsIZUz6/8pSTON/zqC3ggpy9tnzhz/jL0I86F2Nh1yqypI52EO4TXjuWwApv8WEf2l9fh62gBaEe3D3OJp+VhzQUOVDcnLqvsj/b29eJG+uDHoInfLOz1jM0y7jw4hUKjippc7WqU3nUWsdNSDTFPn5guS8/Tk5VRY5SL83czP5VzBkqyDTizsakRrL5d9iZAdHxhk0gbvwS7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Jan 24, 2026 at 08:43:51PM +0800, Li, Tianyou wrote:
> On 1/22/2026 7:43 PM, Mike Rapoport wrote:
>
> > > +int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
> > > +			unsigned long nr_vmemmap_pages, struct zone *zone,
> > > +			struct memory_group *group)
> > >   {
> > > +	const bool contiguous = zone->contiguous;
> > > +	enum zone_contig_state new_contiguous_state;
> > >   	int ret;
> > > +	/*
> > > +	 * Calculate the new zone contig state before move_pfn_range_to_zone()
> > > +	 * sets the zone temporarily to non-contiguous.
> > > +	 */
> > > +	new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
> > > +							       nr_pages);
> > > +
> > >   	if (nr_vmemmap_pages) {
> > >   		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
> > >   		if (ret)
> > > -			return ret;
> > > +			goto restore_zone_contig;
> > But zone_contig_state_after_growing() does not change zone->contiguous. Why
> > do we need to save and restore it?
> 
> Move_pfn_range_to_zone() will clear the zone contiguous state and it was
> invoked by online_pages(). If error occurs after
> move_pfn_range_to_zone() called like in online_pages(), I think we'd better
> to restore the original value if previous zone contiguous state is true.
 
But after move_pfn_range_to_zone() the added pages are still offline, so I
think the zone remains contiguous and the call to
clear_zone_contiguous(zone) should not be there.

BTW, as we have set_zone_contiguous(ZONE_CONTIG_NO) I think we can use it
instead if clear_zone_contiguous() and remove the latter.
 

-- 
Sincerely yours,
Mike.

