Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADD210987B6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9936B6B0095; Fri, 20 Mar 2026 12:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B206B00A1; Fri, 20 Mar 2026 12:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880E26B00A4; Fri, 20 Mar 2026 12:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 739C26B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:56:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 178311D8A1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:56:20 +0000 (UTC)
X-FDA: 84567044520.17.EC9F25C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DECC18000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:56:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774025778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8k5tYET5c7sHmOyLEGXMti0SXXXcwl6FzKQmUPn4pg=;
	b=kdweM2Ez6P6POKzu195VtOU/U58AecGKKBJ7iDSvCUJkwqm5gGFmZub/L+k40k+ws09Aj8
	DkKRemkXxWAo5C/otgCbY9BG5gTJhhPdWUuqaED/2QZUmAs9vR60KE5+bJCtZviv+qaod2
	dxhGgmHRnwA2sUSiOF0h2fwic2Q3V5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774025778; a=rsa-sha256;
	cv=none;
	b=l5v7LjrP2ioaUnMrx6HxEIf9QsT71jt+BVopO3/hdd1GCA1gfMROc9yHj4jaPX+P7VW2gm
	/IUuX/7fYafQQs1IOxWWO23N9774uBuWrFLQliM2/YKW86wNUyZGzEnBr51pemRVy1FT1b
	ZXK//UbhepWCvpKOBiyA9/yAU55z/eI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fcpZy61S8zJ467Q;
	Sat, 21 Mar 2026 00:55:06 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 2434E40086;
	Sat, 21 Mar 2026 00:56:08 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 16:56:06 +0000
Date: Fri, 20 Mar 2026 16:56:05 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Rakie Kim <rakie.kim@sk.com>
CC: <akpm@linux-foundation.org>, <gourry@gourry.net>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <kernel_team@skhynix.com>, <honggyu.kim@sk.com>,
	<yunjeong.mun@sk.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Message-ID: <20260320165605.000024c0@huawei.com>
In-Reply-To: <20260319075512.309-1-rakie.kim@sk.com>
References: <20260318120245.0000448e@huawei.com>
	<20260319075512.309-1-rakie.kim@sk.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DECC18000D
X-Stat-Signature: 6bzaojfu5qxibpecxksgy3g7nbnc55tc
X-Rspam-User: 
X-HE-Tag: 1774025777-643913
X-HE-Meta: U2FsdGVkX19avRFpIG6XH2pXL2DWUKvD0xs3r2Ot415PzAbkRI/Ccdl9kVlUed2u0qMYgD/Zj0RpVa6kkAzI1AsavOdBNDHEhscvqfX1GTbzj/sBgkLKWdGv1x6gxbAOkMMRY/GR3lKe1CUrxV00GL3u/6HqSgrQLyeDSc6Fb62pZ+ZygyUtDtB3d7N8ZGuxQkI62tiwRL+SvBSJHc4yD7tx4X11jCMgvfTYz8ZaVbOn1VlpvdkZ/nDyIsRInnUB0LRkI5dbm3X9tO8ju3Yz8rTz/CGeIWOJ/sqfsSA9yUILmZuFIe1IcLCY7M1wl9HXGCH0mQ2mYZgjIaGyGqR4FX2hRYygODsnf6zLJ1ikh9vvd4MGnsf2+YPbMVw3CMPyV7JWzZvquBN6tKW2kMv94fQcOXvJ/c7yevT7wsSzIa6yeSh9BcCD9WzbHwqO4JTm40oqlF/an+sRLS0RN2sn57BSg5Kq84aOafrQU2UC5wcXwB0N039cFsJURGeP3z476kPzqX7v6o6B5MjcNxbo2bHlR+2xlHP1QS+dCLay8CN6/ncYgYAYegZOeTgx4hQJ2aVrmOLuX2g9OcRzMJjFVpoyR3Cl5tWxs5BP+uC5b9y9Ibt+taJuWauBIkXvZVbL1UjPZv9qfHtONzs2H76rQ91AZJiB3hTLHoOgEOdIjVilz/ikvoJg0CbGW+1iyUhf/O+6lCE6E+5sLHCaQMnBU7+AW5F2kZ5bzveaWU3DA6qWWhwXe7Rch51sJAvHiNc8bzezQdvnW5yqA5o72wgpFlglq7rlJ/l7BwETCxRs1BlIZDE4iZf1vst0NebFJ5rTT3UcXmZ4cYFVGit6zMezMRAZC5WhkUPBt1s9GeNRndnTQcCtSiXGhEYDp8y/2OfppRht5BkOtYVueUbf4t8fC55HBlRKQ5fkfr3egFh3q4LuZG6u5kpe1Skk7XTZdtAEhnbICE1uKhraxPbkQFp
 kKv1NR1+
 12NNoN+GiqqYXfM13WQ7aVb7shE1jNgATi6qKbZjag4t6bt9GpAkVhfE4hSM3jWdxqa1qKwy2w8lNkWFV6fizTKLtuYlfgzLQIJcrvGzCVWqUYHRLd4bMxpr/gCglcHmMdhqBmiNpDjlcHHj171KeoYRpSA69ZIWk3fsLU75HIDCLVce4Lb0sEjO/Dkuu984TqmsopjLi5pZLLAYKb4ebP5TbtdejHg6v/iC0nf22JtYZu0lhK9X3fSdKYFlcUba9UvhVJL6o+mC+hIpfWJE8dSZSZNXSUQ3+rHVu81Zbh2RB454=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> > > 
> > > To make this possible, the system requires a mechanism to understand
> > > the physical topology. The existing NUMA distance model provides only
> > > relative latency values between nodes and lacks any notion of
> > > structural grouping such as socket boundaries. This is especially
> > > problematic for CXL memory nodes, which appear without an explicit
> > > socket association.  
> > 
> > So in a general sense, the missing info here is effectively the same
> > stuff we are missing from the HMAT presentation (it's there in the
> > table and it's there to compute in CXL cases) just because we decided
> > not to surface anything other than distances to memory from nearest
> > initiator.  I chatted to Joshua and Kieth about filling in that stuff
> > at last LSFMM. To me that's just a bit of engineering work that needs
> > doing now we have proven use cases for the data. Mostly it's figuring out
> > the presentation to userspace and kernel data structures as it's a
> > lot of data in a big system (typically at least 32 NUMA nodes).
> >   
> 
> Hearing about the discussion on exposing HMAT data is very welcome news.
> Because this detailed topology information is not yet fully exposed to
> the kernel and userspace, I used a temporary package-based restriction.
> Figuring out how to expose and integrate this data into the kernel data
> structures is indeed a crucial engineering task we need to solve.
> 
> Actually, when I first started this work, I considered fetching the
> topology information from HMAT before adopting the current approach.
> However, I encountered a firmware issue on my test systems
> (Granite Rapids and Sierra Forest).
> 
> Although each socket has its own locally attached CXL device, the HMAT
> only registers node1 (Socket 1) as the initiator for both CXL memory
> nodes (node2 and node3). As a result, the sysfs HMAT initiators for
> both node2 and node3 only expose node1.

Do you mean the Memory Proximity Domain Attributes Structure has
the "Proximity Domain for the Attached Initiator" set wrong?
Was this for it's presentation of the full path to CXL mem nodes, or
to a PXM with a generic port?  Sounds like you have SRAT covering
the CXL mem so ideal would be to have the HMAT data to GP and to
the CXL PXMs that BIOS has set up.

Either way having that set at all for CXL memory is fishy as it's about
where the 'memory controller' is and on CXL mem that should be at the
device end of the link.  My understanding of that is was only meant
to be set when you have separate memory only Nodes where the physical
controller is in a particular other node (e.g. what you do
if you have a CPU with DRAM and HBM).  Maybe we need to make the
kernel warn + ignore that if it is set to something odd like yours.

> 
> Even though the distance map shows node2 is physically closer to
> Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> routing path strictly through Socket 1. Because the HMAT alone made it
> difficult to determine the exact physical socket connections on these
> systems, I ended up using the current CXL driver-based approach.

Are the HMAT latencies and bandwidths all there?  Or are some missing
and you have to use SLIT (which generally is garbage for historical
reasons of tuning SLIT to particular OS behaviour).

> 
> I wonder if others have experienced similar broken HMAT cases with CXL.
> If HMAT information becomes more reliable in the future, we could
> build a much more efficient structure.

Given it's being lightly used I suspect there will be many bugs :(
I hope we can assume they will get fixed however!

...

> 
> The complex topology cases you presented, such as multi-NUMA per socket,
> shared CXL switches, and IO expanders, are very important points.
> I clearly understand that the simple package-level grouping does not fully
> reflect the 1:1 relationship in these future hardware architectures.
> 
> I have also thought about the shared CXL switch scenario you mentioned,
> and I know the current design falls short in addressing it properly.
> While the current implementation starts with a simple socket-local
> restriction, I plan to evolve it into a more flexible node aggregation
> model to properly reflect all the diverse topologies you suggested.

If we can ensure it fails cleanly when it finds a topology that it can't
cope with (and I guess falls back to current) then I'm fine with a partial
solution that evolves.


> 
> Thanks again for your time and review.

You are welcome.

Thanks

Jonathan

> 
> Rakie Kim
> 

