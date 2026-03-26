Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABC1106F30F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A1B6B0095; Thu, 26 Mar 2026 05:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510D46B0096; Thu, 26 Mar 2026 05:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E2B6B0098; Thu, 26 Mar 2026 05:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A33A6B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:23:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D93A61A0BD0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:23:31 +0000 (UTC)
X-FDA: 84587676222.01.CF11FF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24F4380008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:23:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nW0qDXZp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774517010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uA9aHmzXIeuJB/u+tsgkbiWNXMAkHf9frqppt1623Jg=;
	b=EA1+VfqjL3cNaOCL63Ar/ZxOkPzNCvDyYIROOECWeOX53Brvqcjx3lcKLGgs4cMyIP21jb
	Xo7BwisRCNOGK6NqHYzcmpolFD53UxBXbuLE13h1xTNQvRx4NpfavlbVaA2zZhIfP4ml1m
	cWWY/21M/lVLYIBB09YZr+EsYIxAHNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774517010; a=rsa-sha256;
	cv=none;
	b=nMSrupxJ7DGD6NEVMeQ7vcALOZT0t0LDsCQFPK1fn2MdnqAEm/ohWcU0rgk2f6er1+RdUG
	l4Yrq7mLpdplvFDFkERZWhY76B2DB9yYCSHBcH5MU1J4H5Y77Bo1J77t+qPldU0xNytr0G
	O3fCIfMDNM1zWt59X3YU6FtdoBWfTmo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nW0qDXZp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB5A60103;
	Thu, 26 Mar 2026 09:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69BBC116C6;
	Thu, 26 Mar 2026 09:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774517009;
	bh=vvvfL4L6rjlE4p3zlY+c8eev/dMIiWoJ6w71OFXwFGk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nW0qDXZpWFsRESTdbhVpOHnzCh3o4J/g0ytAiC6lbT1blHcUPtvWGoBRUDb6XkuCY
	 T+swgSx/JBp6jI3aMPHv2wCbaYawMTUufhFN2/nT8niJR8x3FoKHbiLRoH4XqSeQCG
	 jxKf7CZEJunmrpqWAIkrdpOGrUWKtOOMP2py+hSShK1qjfpL6bjhv8L1HO00Rovrdt
	 7wiR1fesnxgdXuhUSOXrg/+AhElA+8pdwErkWjJNCIfH0jRf4g/K3wvXEFe1X3m6VY
	 y6B2g8XcpLBMQDqWCY0FVZ3sTMYfqyNlloFYBesEzNtkIctSf+hvApS7nvOPwYowbd
	 gIKQufLbYm4oQ==
Message-ID: <b86f559b-6726-43b0-8270-4f041735b7d5@kernel.org>
Date: Thu, 26 Mar 2026 10:23:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong"
 <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <IA4PR11MB9009A2A582EF16AECE1828D8A356A@IA4PR11MB9009.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <IA4PR11MB9009A2A582EF16AECE1828D8A356A@IA4PR11MB9009.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 24F4380008
X-Stat-Signature: wtj4473wdgchf49wd59674briatmq1zd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774517009-683647
X-HE-Meta: U2FsdGVkX1/F1utnWPCQIjLwlL8JiGKdpDl7oVj4N/YlSaiGXMHraBypxu/zMj06CgBU7xMpOIdkrMrTuTaZx3dWjQ+wqqYdXCPvBn/NA627WYdak9ZlM6g6IPczg5DTdoS7DcrLL4lObbJReMr8ArRoTyrfIxyjMiVdupb/cCDxQgQScjqnEDN4Ynck4/oepQldqFLrjpX2KddA76+IglRfz6EN2uCU7i5+HZk1X3hvItPnfw7wMu5osKjjDTTSTLqdknqvvy0fIR2FPB0UMgf+idhEDQHfjkGtJTySZBJDfmTEZQF8OdRd1rzGc6ezL7na8Gciby3ydlcr4esS8x1YrjfFGpDob2lxwuM44D1CIpdODmiVX9pYc45zkYEZKT4mytxAU79U9UfFcmGCqWgeKsHGNP/C/GdLIPravogGM4NmeLuwk707/+aFcPxSkSbLJ91NhcgrMFP+FLiDxV94sLbp8XEnJgu5iLHO8tbiG59Vhp+IqiyZ9hoiSB7158/WM+ADWjEXxVrtOC4QLbMsuPtlhUCwiiBV5TqbOBq/aDgWNjPIIo/s504VDC7RIEE4ei/iw4vsrNTkyyOnDiDuZ0xuHMCLnomTmb0RvS4jvwrGrgnTZLZ5kS4xBnbYNnrn1zToQktWaGDvtI3+Q1nvCvD9ts041HK2g4eEBt3TneG5PE1GOBpD6V+n9WVcyloOG2EWzfiWtEkUoAfB4ceznSvJu5ATD1QkMh7elk64LvW3AQ3Jt4YIJRmi2wRkmmNRXxx8e3aeQLan5y9NeRuQKY27NWtZkiNN8o9UUzbgAn7Q7ltdWfjaY4jxeBW3EQ64NKtJCkUNkHrXbJ2mKP9OLB5WFz8e50uWrwKHwwj3h/5oVyub9SY7Xo3b4BCnUJOANtWl9j2SUQ6D+wy4VnZtX5EStc0pMWprkDOCZq62ROQDYqinEw9Xfi7B6ceF7YaaTh2HWW+h9gu514X
 7Gl3yV8D
 t62s+q7Plx9iS97dA7L4gHWtPHv5LQSWj8a/QVkd13Gm1Kq4/vQ//3fcjzXJaY7AKjeeb/XFjOi//1z47ebpu8LtFHOrUjwPk+DM6SxR03RV93A8A5yac3BdLGcE/Q3WuQEduv8sQrlilaCyo+8J0HBaVxdxIXjeTjpglKFw/h+4OvLi/DNZe/oNwwsv3IK9oMSdG4mP6W4rr5FrUBAhZ3MrNBe1VfjH7haw5qIlKloYM7Lit+MaK7nzwzt2C/pTg5ZGDlijNOEt/amaDgwODDfbPRtAfu6pvShkG4yPHrLiS4Gt93YLE+p1IxNlFMKpSwmmxEWG9+1PSkv0t3yJBy8pslIQf3KARKQam5w7KQPkatM8T4k/h/DPD+DFRCNMeh93Wtcn0jpjm/wMI/S/BgnAfbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> About AI feedback below
> 
> init_unavailable_range() uses for_each_valid_pfn() and skips unmapped
> sections that lack a mem_map. If the full hole size is added anyway,
> pages_with_online_memmap could artificially match spanned_pages for
> zones with missing sections.
> 
> Could this make zone_is_contiguous() incorrectly return true, bypassing
> pfn_valid() checks and potentially dereferencing missing sections?
> unsinged long zone_hole_pages
> 
> I think if I can update the pages_with_online_memmap in the 
> init_unavailable_range directly.

See how I handled it: I simply return the number of initialized pages
from the function. I think that should do.

-- 
Cheers,

David

