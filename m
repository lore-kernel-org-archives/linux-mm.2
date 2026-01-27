Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26068D2594B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9026B0088; Tue, 27 Jan 2026 01:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376FD6B0089; Tue, 27 Jan 2026 01:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282E16B008A; Tue, 27 Jan 2026 01:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 140906B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:58:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BDF05C5C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:58:56 +0000 (UTC)
X-FDA: 84376841472.26.4DC09C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A89BCC0004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:58:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cWIP8VPG;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769497134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9qvLSnLBWadzAsi7hY/Uo+hau2BlqaY84OBOZcMLXM=;
	b=qCJrDzh6khZ6SVVRj2nt3RK6O9zlJdNRgQjKcWIQlaHb5qRZY/GThmXtNTbKi3KM+acK2A
	5ShbnBKQtEM/eSvVn+o+5vin2Iao+64QjMEdxdh27jQnMuA4Vo8vYtx+XbtFnBgu5g2H2l
	LKh/bZGRd1aDXLjsoFbKQx5oRfIACSE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cWIP8VPG;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769497134; a=rsa-sha256;
	cv=none;
	b=galmBBXplpQ64ATDQPj05EcEHqulGt3aWDgek9nGs2DUxr5Cx7xFGt9IHej96kxsYaW3x6
	l6HxDgbWQeY7J4wdgU/piSe7xyklKVR6XYTkINr7+ByLPhzojo9IgGNQIXxmX7+GW8ufNU
	OZXLryPEHUSBB5atbpThhyZRJeKj2a0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76BE341AF2;
	Tue, 27 Jan 2026 06:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACCBC116C6;
	Tue, 27 Jan 2026 06:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769497133;
	bh=k6dfEQf49JWtiO8s+3goGp6rxKKI+aKNiywZpo38Cyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cWIP8VPGVhlGZeBl3t6fbSrKKmLY4Fy6gEBQ6kH36mDf+3V/4yKIBZ4J83GdGz9fd
	 bdWk++BnElexxDDqgfl70DoYHcO90NEu7JmQ7uWtD0lDg3KHUX+x2aAJuCF+DPf07Y
	 pTu5ywcjspOmabUwJqOafVS5AacjEmLgYcQdRoKQPjoRUdDOZfKoUUp1xorA+oONjT
	 ZnVz3PLO7t/teYcndZ+0BlFLyGhMBy1XrXMXjOQc/iawTmtNGONDLGQsQ4P69Brw57
	 EzY80qyrttpZjTOLh3YNB7OlJOXqO2cc9L+Pan0zS7b4l2hIYC/nF/zZkEJu1/MYJp
	 7omJbUjTmEeyg==
Date: Tue, 27 Jan 2026 08:58:44 +0200
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
Subject: Re: [PATCH v8 2/3] mm/memory hotplug/unplug: Add
 online_memory_block_pages() and offline_memory_block_pages()
Message-ID: <aXhiJFvEKFk1Flpb@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-3-tianyou.li@intel.com>
 <aXIK55fQeKfB-jM0@kernel.org>
 <705d63f7-2451-46bc-b1f0-bef718b82283@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <705d63f7-2451-46bc-b1f0-bef718b82283@intel.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 5patozhhj4334un615ek7egijjqe8imp
X-Rspam-User: 
X-Rspamd-Queue-Id: A89BCC0004
X-HE-Tag: 1769497134-202485
X-HE-Meta: U2FsdGVkX19TUy3GTRCbkdpVl5mCMnXccqRmr7TggfAP8orNxuYzdtpeZs1kH/b10jNybUrEJalmx75BVqnb8mZOYIhLZ8Uwgm6/o+H++I94QrgZ3VrjZwOFtXU99bDLe7HinS8RJAKcVuEj9lcdgQiK+AYDJI336JWdgWakPlrZVakkKhxWOgB4LPPneU81L9npx7mlEcD6W84Gy7SS8rH2lHLcqcslZas42TSEvFAF2R0uArRoetLIKWMzNZFobKO7t2bx9E2u1DGYkNVvkHzIHt8XS76GBfQXqOInCSAhCaawH9j4aaTEImokIdvOVFPjyqWap+gXM14xsvUGFEuKyFA5pLJMc4beRpGHyAPSFiU2Ex6C7ZAWflW6wrlJ205eKza0depAFryGzF7MNazSm7CzENd0Kh+uO7AfL2D92uANZvXTi/DT0z2qQxtjeC+FaaFSA/wNcKKuugYtPpRWqFUjYHSfwwjuUe2mynM9FJQAqGS2BzHgz4KYbnnY7YzKExkceAsxSVGwkWVtrPSb4TYJ267WyDbIlCDQvq29OxkzvLNaUAA+VqFXPAe44BLLYmShL7Q0vO14Ef+He5S7nT9EPzBfYD3AInzvxVftWTrRmvyhTAkMqFIzdWoim6sZXueYRW8kV/E8x6P3euO68i6g/FIQNJfnNElZhln9Wzi39XraqJWf26AjJVyhNIeDcpMFXkWVvb8hb/xvmQWo+aZcNvpXTvtFsI7qlrdMfhglKWhI/TLQURWo1PFGp38ItLUfI4UvY6LHPprazmZxHn2gCnbWKvNNyabQr28M8ds/ImFtRkrFCQGNZOLDloKkjk245yzFyGJipCxiYZ+E9PExx5wgMtyZEpaksCpJ967PiR1DxB4EfXte3lmaYuGmkhcomVynLY9Z8K274CfScY9lRY60iU57pnGwPQMy+bgJwvDTTUOhPOn6nxNuXN+obHmPDBQo7xJmrwU
 Frahkipm
 LnFc7FuVbc7HfCujpeHkh28HHR2QB8Kgj28RTzTfCMEYLTn4kFBgswTDKaeJuZJlf0dSFUGVLUL6m5qEnFNS7QQb9vm8zvRkstWO1Pwys5carR2FncfGSoUkuFpNqoDtifAutjO+XA4wpipN0LWtLKvQmu7LyLn2gEjDUqn6PjySAy4NyGWQJsGlnSXE2mQV6bQl0Mg3tBG8xrv0t3QCODh81ZIY7BQATk2B+kpG8WSi9B6lF0cyrNjx5i9YjHflCIa/w0BafEHAXndhfX8TPG7t+Y0zIAlYw+jCVRsYq7q+aN+qYWUwg1wuQ40b05t5UAsa0rBLT7G7QxPALbHKTjJ/6/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 08:30:57PM +0800, Li, Tianyou wrote:
> 
> On 1/22/2026 7:32 PM, Mike Rapoport wrote:

> > > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > > index 751f248ca4a8..ea4d6fbf34fd 100644
> > > --- a/drivers/base/memory.c
> > > +++ b/drivers/base/memory.c
> > > @@ -246,31 +246,12 @@ static int memory_block_online(struct memory_block *mem)
> > >   		nr_vmemmap_pages = mem->altmap->free;
> > >   	mem_hotplug_begin();
> > > -	if (nr_vmemmap_pages) {
> > > -		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
> > > -		if (ret)
> > > -			goto out;
> > > -	}
> > > -
> > > -	ret = online_pages(start_pfn + nr_vmemmap_pages,
> > > -			   nr_pages - nr_vmemmap_pages, zone, mem->group);
> > > -	if (ret) {
> > > -		if (nr_vmemmap_pages)
> > > -			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
> > > -		goto out;
> > > -	}
> > > -
> > > -	/*
> > > -	 * Account once onlining succeeded. If the zone was unpopulated, it is
> > > -	 * now already properly populated.
> > > -	 */
> > > -	if (nr_vmemmap_pages)
> > > -		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
> > > -					  nr_vmemmap_pages);
> > > -
> > > -	mem->zone = zone;
> > > -out:
> > > +	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
> > > +					zone, mem->group);
> > > +	if (!ret)
> > > +		mem->zone = zone;
> > I think we can move most of memory_block_online() to the new function and
> > pass struct memory_block to it.
> > I'd suggest
> > 	
> > 	int mhp_block_online(struct memory_block *block)
> > 
> > and
> > 
> > 	int mhp_block_offline(struct memory_block *block)
> > 
> > Other than that LGTM.
> 
> 
> It's doable, if not other comments I can change the code. Would it look like
> moving the functions to mm/memory_hotplug.c, change the name to
> mhp_block_online() and mhp_block_offline(), and change the references where
> the original function invoked in drivers/base/memory.c?

Yeah, that's what I thought about. 

Even more broadly, I think the functionality in drivers/base/memory.c
belongs to mm/ much more than to drivers/ but that's surely out of scope
for these patches.
 
> My prior thoughts on this was just break the code as small pieces as
> necessary to handle the pages online part together with zone contiguous
> state update.

IMHO moving the entire function is cleaner, let's hear what David and Oscar
think.

-- 
Sincerely yours,
Mike.

