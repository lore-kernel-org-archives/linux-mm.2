Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4D9106B522
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14B46B00A3; Wed, 25 Mar 2026 08:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC53F6B00A5; Wed, 25 Mar 2026 08:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBC46B00A6; Wed, 25 Mar 2026 08:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBD0E6B00A3
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:34:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F427BB6B3
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:34:02 +0000 (UTC)
X-FDA: 84584527524.23.46C46A9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D30F4000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:33:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774442040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WO0dR/NY2JNfumCqOX/M/VrwAyOM8ihHCQeJIbuAmtc=;
	b=lGh3Ap0YtGvLqIf4Chokg/uhuNcIAINT9CcFrJG/OoMfXg+jaYWgTNGVJz826R7BkNy8iM
	N5lZJS/OMec92gK5emR6arTBuETWwiNBbL+tCP+eYIFawkurN4QiLia6Ebru3iTzM9LER9
	RYT/YltQK8+X0hQXeH7Gmodo8ST1xiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774442040; a=rsa-sha256;
	cv=none;
	b=7c4NHY1MzaFcyGjrKu2AwEomvcLOq7ihxIM/Vi/D8EWB3b3WJl+30/o9GMbo42M9Ysp2Gs
	hX6wJ7JHxjiwyUyziKKBVLkqWBj9H3RAi//OCjovLm6TZyjrzBqatWcYFQFifJuP6BnEfk
	LLjKk/VcZL7Jzzcn/7zUTIp8QUQDnMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgmXZ1cdNzHnH55;
	Wed, 25 Mar 2026 20:33:18 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 8520740569;
	Wed, 25 Mar 2026 20:33:53 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Mar
 2026 12:33:52 +0000
Date: Wed, 25 Mar 2026 12:33:50 +0000
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
	<dan.j.williams@intel.com>, <harry.yoo@oracle.com>,
	<lsf-pc@lists.linux-foundation.org>, <kernel_team@skhynix.com>,
	<honggyu.kim@sk.com>, <yunjeong.mun@sk.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Message-ID: <20260325123350.00004d48@huawei.com>
In-Reply-To: <20260324053549.324-1-rakie.kim@sk.com>
References: <20260320165605.000024c0@huawei.com>
	<20260324053549.324-1-rakie.kim@sk.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam12
X-Stat-Signature: et7cyi5uub7cws8ts7bncgdi6c1wsjuj
X-Rspamd-Queue-Id: 9D30F4000B
X-Rspam-User: 
X-HE-Tag: 1774442039-887670
X-HE-Meta: U2FsdGVkX19nEBD+UeSH5maVONshr32pnSdxyyDbHVJUt758x/jevRYNqh1S9Wc5G4ZfQMQiRnXY4fDNsjx48TnO78e7GKb3d2r1JSp2UJdqXlSsetJaX6IWDNQeKB7g359Dn9Ho9U2ZhR/IWiySYIaK5dfwGUZnC5OwUfwDv4EmItVTuQtCLmMFduVJiqt0ZIK1B0RT5DHfYuf47YCUpWcCiljr8yC3y+Qoawf6hWQ18kBPvPWKoknQDkrkAYyJc/Nh2cET6Idvbha0kujtQeepCJjDrsLhgb5H6G1OgD+7r4T5ibtjSDVyGlfZcC/z7gvmrf+bqs00M0GlAQoM6sKWyT3sG8qDy63eLajj5cgQNcJWMVD2RDQxXyR6z9CcUeGqVamWqu+izzNWS7J1ir0ETRirL1D/64dopmTKSUT4I1+29ZJY+Ojx+MGWsuFDMGiasYyBNZdjEdGZ54J6jq1QuNeZv4tkGyEhgQ2LaSjm4WxhnWaPjeHq4bM6P1GomO4tYXJ1kBICFXciHn2wUvUnUJgu5cGa2QpF+wZVMCDgXlA6PW3hFqyZjkTwwbW81j4lzx5TysCNGgZsYG3wkyOdcQFrV0gFHt92rAwjTe2vBfD+DehJbm1wlOV7fwDY5aEbfdBwGkz+xbi0M6hRZbjia6LnetY2yjARBVgOm9ewxCNqexLVkYOYLgsYGdliKxdadS4pDNWvS74pqHrDf3WnEq1nzGLxTozhK1bfyvrYKz39g3xsYhbpQ7QBaw7HQHZr2x6KHrTvUYkP975J0u9NKpClFwfEr1vNMPUfQy46eH78qJtIGl6ndzKQsez9MCp7URQyghA9UoJ52M/CVjkGQKwCsIB7zItCrdH1YSTpVkL1TjUIveGZmY9ObyUhW3obiZRe3BI16I8UFc6xd3TjG5r/ByT4rWn8BuTnJckpDg4Vr7H0nNVrts8mQDkiUZaHwiOdIkUFekOQ421
 wqom7bL/
 Ea/UCwKuDxDrMFjd3T71A3EH0ZCNvsM/G4ipxo6wx9mzr2By0zRZ/H9TeX28hgmTWGQhgDSyCkw7k+rNv8bFUx2U9aPaZpKv0gMJkfiIPIYnBMJ+8//8ZMgrR+YyMSbwjiKfdAbbVpDwwz95PgayKO1RxIxmYJSMckRDccN3Ye9KLBAcWMWIKzRSkKXuqa0mJD+OzOj/PjDMLnrtohyCCxbfeQR0R78tjc0LBJVpQ5pCqzDZHL/6XsqCp053xY+fieaJZyvD2R3uGJl4Zpim0U3OwUJ5emCnqA4aMz9iXSGhw85TiIcUUZxgoON4BHI6KMcugTTwquTTRxDNr2CppnQ/XBA3CErEnc6uayYQgvRq0HFmCW1+GtWZuKnQ7fp9+7h9oNG1SUbuYnarg2/cyJVuncF+exITxatlSjWnEvEhbCOmtvF/BCiZg+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 14:35:45 +0900
Rakie Kim <rakie.kim@sk.com> wrote:

> On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> >   
> > > > > 
> > > > > To make this possible, the system requires a mechanism to understand
> > > > > the physical topology. The existing NUMA distance model provides only
> > > > > relative latency values between nodes and lacks any notion of
> > > > > structural grouping such as socket boundaries. This is especially
> > > > > problematic for CXL memory nodes, which appear without an explicit
> > > > > socket association.    
> > > > 
> > > > So in a general sense, the missing info here is effectively the same
> > > > stuff we are missing from the HMAT presentation (it's there in the
> > > > table and it's there to compute in CXL cases) just because we decided
> > > > not to surface anything other than distances to memory from nearest
> > > > initiator.  I chatted to Joshua and Kieth about filling in that stuff
> > > > at last LSFMM. To me that's just a bit of engineering work that needs
> > > > doing now we have proven use cases for the data. Mostly it's figuring out
> > > > the presentation to userspace and kernel data structures as it's a
> > > > lot of data in a big system (typically at least 32 NUMA nodes).
> > > >     
> > > 
> > > Hearing about the discussion on exposing HMAT data is very welcome news.
> > > Because this detailed topology information is not yet fully exposed to
> > > the kernel and userspace, I used a temporary package-based restriction.
> > > Figuring out how to expose and integrate this data into the kernel data
> > > structures is indeed a crucial engineering task we need to solve.
> > > 
> > > Actually, when I first started this work, I considered fetching the
> > > topology information from HMAT before adopting the current approach.
> > > However, I encountered a firmware issue on my test systems
> > > (Granite Rapids and Sierra Forest).
> > > 
> > > Although each socket has its own locally attached CXL device, the HMAT
> > > only registers node1 (Socket 1) as the initiator for both CXL memory
> > > nodes (node2 and node3). As a result, the sysfs HMAT initiators for
> > > both node2 and node3 only expose node1.  
> > 
> > Do you mean the Memory Proximity Domain Attributes Structure has
> > the "Proximity Domain for the Attached Initiator" set wrong?
> > Was this for it's presentation of the full path to CXL mem nodes, or
> > to a PXM with a generic port?  Sounds like you have SRAT covering
> > the CXL mem so ideal would be to have the HMAT data to GP and to
> > the CXL PXMs that BIOS has set up.
> > 
> > Either way having that set at all for CXL memory is fishy as it's about
> > where the 'memory controller' is and on CXL mem that should be at the
> > device end of the link.  My understanding of that is was only meant
> > to be set when you have separate memory only Nodes where the physical
> > controller is in a particular other node (e.g. what you do
> > if you have a CPU with DRAM and HBM).  Maybe we need to make the
> > kernel warn + ignore that if it is set to something odd like yours.
> >   
> 
> Hello Jonathan,
> 
> Your insight is incredibly accurate. To clarify the situation, here is
> the actual configuration of my system:
> 
> NODE   Type          PXD
> node0  local memory  0x00
> node1  local memory  0x01
> node2  cxl memory    0x0A
> node3  cxl memory    0x0B
> 
> Physically, the node2 CXL is attached to node0 (Socket 0), and the
> node3 CXL is attached to node1 (Socket 1). However, extracting the
> HMAT.dsl reveals the following:
> 
> - local memory
>   [028h] Flags: 0001 (Processor Proximity Domain Valid = 1)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x00
>   [050h] Flags: 0001 (Processor Proximity Domain Valid = 1)
>          Attached Initiator Proximity Domain: 0x01
>          Memory Proximity Domain: 0x01
> 
> - cxl memory
>   [078h] Flags: 0000 (Processor Proximity Domain Valid = 0)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x0A
>   [0A0h] Flags: 0000 (Processor Proximity Domain Valid = 0)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x0B

That's faintly amusing given it conveys no information at all.
Still unless we have a bug shouldn't cause anything odd.

> 
> As you correctly suspected, the flags for the CXL memory are 0000,
> meaning the Processor Proximity Domain is marked as invalid. But when
> checking the sysfs initiator configurations, it shows a different story:
> 
> Node   access0 Initiator  access1 Initiator
> node0  node0              node0
> node1  node1              node1
> node2  node1              node1
> node3  node1              node1
> 
> Although the Attached Initiator is set to 0 in HMAT with an invalid
> flag, sysfs strangely registers node1 as the initiator for both CXL
> nodes.
Been a while since I looked the hmat parser..

If ACPI_HMAT_PROCESSOR_PD_VALID isn't set, hmat_parse_proximity_domain()
shouldn't set the target. At end of that function should be set to PXM_INVALID.

It should therefore retain the state from alloc_memory_intiator() I think?

Given I did all my testing without the PD_VALID set (as it wasn't on my
test system) it should be fine with that.  Anyhow, let's look at the data
for proximity.



> Because both HMAT and sysfs are exposing abnormal values, it was
> impossible for me to determine the true socket connections for CXL
> using this data.
> 
> > > 
> > > Even though the distance map shows node2 is physically closer to
> > > Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> > > routing path strictly through Socket 1. Because the HMAT alone made it
> > > difficult to determine the exact physical socket connections on these
> > > systems, I ended up using the current CXL driver-based approach.  
> > 
> > Are the HMAT latencies and bandwidths all there?  Or are some missing
> > and you have to use SLIT (which generally is garbage for historical
> > reasons of tuning SLIT to particular OS behaviour).
> >   
> 
> The HMAT latencies and bandwidths are present, but the values seem
> broken. Here is the latency table:
> 
> Init->Target | node0 | node1 | node2 | node3
> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268

Yeah. That would do it...  Looks like that final value is garbage.

> 
> I used the identical type of DRAM and CXL memory for both sockets.
> However, looking at the table, the local CXL access latency from
> node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
> unjustified difference. This asymmetry proves that the table is
> currently unreliable.

Poke your favourite bios vendor I guess.

I asked one of the intel folk to take a look at see if this is a broader issue
or just one particular bios.

> 
> > > 
> > > I wonder if others have experienced similar broken HMAT cases with CXL.
> > > If HMAT information becomes more reliable in the future, we could
> > > build a much more efficient structure.  
> > 
> > Given it's being lightly used I suspect there will be many bugs :(
> > I hope we can assume they will get fixed however!
> > 
> > ...
> >   
> 
> The most critical issue caused by this broken initiator setting is that
> topology analysis tools like `hwloc` are completely misled. Currently,
> `hwloc` displays both CXL nodes as being attached to Socket 1.
> 
> I observed this exact same issue on both Sierra Forest and Granite
> Rapids systems. I believe this broken topology exposure is a severe
> problem that must be addressed, though I am not entirely sure what the
> best fix would be yet. I would love to hear your thoughts on this.

Fix then bios.  If you don't mind, can you provide dumps of
cat /sys/firmware/acpi/tables/HMAT  just so we can check there is nothing
wrong with the parser.

> 
> > > 
> > > The complex topology cases you presented, such as multi-NUMA per socket,
> > > shared CXL switches, and IO expanders, are very important points.
> > > I clearly understand that the simple package-level grouping does not fully
> > > reflect the 1:1 relationship in these future hardware architectures.
> > > 
> > > I have also thought about the shared CXL switch scenario you mentioned,
> > > and I know the current design falls short in addressing it properly.
> > > While the current implementation starts with a simple socket-local
> > > restriction, I plan to evolve it into a more flexible node aggregation
> > > model to properly reflect all the diverse topologies you suggested.  
> > 
> > If we can ensure it fails cleanly when it finds a topology that it can't
> > cope with (and I guess falls back to current) then I'm fine with a partial
> > solution that evolves.
> >   
> 
> I completely agree with ensuring a clean failure. To stabilize this
> partial solution, I am currently considering a few options for the
> next version:
> 
> 1. Enable this feature only when a strict 1:1 topology is detected.
Definitely default to off.  Maybe allow a user to say they want to do it
anyway. I can see there might be systems that are only a tiny bit off and
it makes not practical difference.

> 2. Provide a sysfs allowing users to enable/disable it.
Makes sense.
> 3. Allow users to manually override/configure the topology via sysfs.

No.  If people are in this state we should apply fixes to the HMAT table
either by injection of real data or some quirking.  If we add userspace
control via simpler means the motivation for people to fix bios goes out
the window and it never gets resolved.

> 4. Implement dynamic fallback behaviors depending on the detected
>    topology shape (needs further thought).

That would be interesting. But maybe not a 1st version thing :)

> 
> By the way, when I first posted this RFC, I accidentally missed adding
> lsf-pc@lists.linux-foundation.org to the CC list. I am considering
> re-posting it to ensure it reaches the lsf-pc.

Makes sense. Make sure to add a back link to this so it is visible
discussion already going on.
> 
> Thanks again for your profound insights and time. It is tremendously
> helpful.

Thanks to you for starting to solve the problem!

J
> 
> Rakie Kim
> 
> >   
> > > 
> > > Thanks again for your time and review.  
> > 
> > You are welcome.
> > 
> > Thanks
> > 
> > Jonathan
> >   
> > > 
> > > Rakie Kim
> > >   
> 


