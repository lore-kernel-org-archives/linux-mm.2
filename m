Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97181106F305
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0062B6B009B; Thu, 26 Mar 2026 04:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9016B009D; Thu, 26 Mar 2026 04:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EB96B009E; Thu, 26 Mar 2026 04:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D14BE6B009B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:55:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E09613C107
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:55:11 +0000 (UTC)
X-FDA: 84587604822.10.7A321B3
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4024F18000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:55:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774515309; a=rsa-sha256;
	cv=none;
	b=l8lHID5jY+zGCnXJWGtxeFik8kQPEkZixiDVDFzu9JK/J7xlVd73/yDwRsd93/6Lp1L906
	MUptwp4On+BvCAJqJriWH0TozU9KwZD7WkeDH+DwtWCij0mCGkOAA08VdmEUcjdqS8Lvs/
	8P+ROWtod2I2rT+ClJWUQlAcFjLpPcc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774515309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDuPFzv/LFjHumoe/goVeRGYrGKHssczcZYKTcPIhLs=;
	b=HUrKBmESSX1okxer+cBqnajW8/+jcONXHTdfayl8x5jFhwLJziBZ/s5D3X5m4f/h85jpAG
	IFLryXyN4F1XNlQwVftc/IxtTqmlqyBr+Slosf/+Um0AnUbKNol9YFIzBEagG0etE+ADiO
	7jgH0SKj70sOI1qWAZD6iae41dN1wmM=
X-AuditID: a67dfc5b-c2dff70000001609-03-69c4f468f747
From: Rakie Kim <rakie.kim@sk.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Thu, 26 Mar 2026 17:54:55 +0900
Message-ID: <20260326085501.343-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260325123350.00004d48@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHeXeO5xyHy+Na+HqhbBBRkLcMXi1CPwjHD5FgBGWQhzy10TZl
	U3OlqFhW3hqGNDfTWeBliuZyeQ1rmvOWeaGl4jUTcWqUhuAFrSmB3/78/pfnw0NhQgvuSUkV
	CZxSwcrEBB/nr7iUnZH86ZT6f5vzRsV1NQSanBskUMvoFfSicBCg7rEMAlWP1QC0YN4EaGPS
	SqL2+QUcGctsBLKaS0hUYLEB1Jg+Q6Ivul4cjbQUE2iqZtcJ9eiqcLSe74Wm80NRZ10jDz0f
	NhBIn5EP0Limi4eqayRI/2mKDPVgmnWTJGMwJTI5WSMk87BzxYl53bbIY0zGpwRjWi0gmW7t
	Fs40zwYzeZk/Ceb3/DjOFOrTmLqGrzjTb+gkmTXT0UjX6/wLsZxMmsQp/S7G8CUjc1oyfiAm
	uaHPLx1MRGQDioJ0EGwujc4Gznty4m094cAELYZd7284sIgOhPbcDyAb8CmMtjnB5Y0nwGEc
	piVQU7GLOfI4fQIOt59zYAF9FvbZlsn9yVOwtn4cd2hnOgC+tK7tVYW0C7S/aQf7eTfYU/Rj
	L4PRx2CmWY85bkF6g4Tb33OJ/SEP+LFyFNcAV92Bju5AxwB4RiCUKpLkrFQW5CtRK6TJvrfi
	5Cbw77PlqdvRTWB1MMoCaAqIXQQx9g6p0IlNUqnlFgApTCwSDL2ySIWCWFZ9n1PG3VQmyjiV
	BXhRuNhdELh+L1ZI32ETuLscF88p/7s8ytkzHaQI2nsPaT9v+ocH7TzCgocitx74eL0rNoq8
	F+NCcti2+iNsSoeLsGhJ3oCL1DN2okPh7q/lu3Vr/MKiBp61hllDyB71bRK72hSSdrwimfc4
	omoWN7fVXs6zxzNL16zlgTknV0pKfVo77OGjZvG6bvpX5fmqVFl5vxu2k3VJjKskbMBpTKli
	/wLtOXGg1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRiA+XbOzjkuF8epdHCksdAoSVMzvy6Uf6ov6UeQaYTZRh7cySub
	igqSYomampqSbSpLoctcmuYdLzHnLcNrjryWmVpeQlOkqWBNCfz38jzP+/55KUzUgttRXHgU
	qwiXhUoIAS4oOBJwXL5m4E48LBTCwgodASem+wnY+NkX9uapCfg0vx/ArpEkApaN6ACcq9kA
	0DTRScLV2QUMts7M4VD73EjAzppiEubqjQC2FXXzYV3iVxL2qT7gcKixkICTum0+7Fa9xuF6
	lhh+yfKGeuMcHxoq6njwyaCGgOqkLABHszt4sEwnh5u1r/6h9knS2x41qCZIpKmKRo9Shkj0
	wLDER6VNP3moSptGoKrfuSTqKtjEUcPUaZSZ/ItAKzOjOFofQ6j0xzIP5avvo4rqYRx91BjI
	a1a3BOeC2FAuhlW4npcK5EPTBWRkrzS2usc1EYxfSQcWFEOfZMbfVRLpgKIIWsJ0NAeYsQ3t
	zsxnvAfpQEBhtJHPLJpSgVlY03Im++U2Zu5x2pEZbPU0YyHtwfQYF8ndk0eZ8spR3Dxb0G5M
	UefqzqqItmTm37aC3d6K6X72fafBaAcmuUaNZQNL1R6l2qM0gKcFNlx4TJiMC/V0UYbI48K5
	WJe7EWFV4N9XXyRs5dSDtaHLekBTQGIpvDndxon4shhlXJgeMBQmsREOlOg5kTBIFhfPKiLu
	KKJDWaUeiClcckDo489KRXSwLIoNYdlIVvHf8igLu0TwSX/DdHVAB8VsY8SIbYb2wmyx9FC8
	aX9gs7OT41Z2Hudhv7Chdvdqaq63vX1JU5vWMukjP4xlymk/o7hj3Dne/6JSQzDXU6YSfE/d
	c3IeC+7XUWc0w37eK2edBhexP0nEG2VgDuvVnvqtPHp53trP4aBpKaFkvm/f4xSkZiS4Ui5z
	O4YplLK/Y8m+PtECAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 4024F18000D
X-Stat-Signature: x3thi6tj8763eijmec6j1n47mtchddo6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774515306-310344
X-HE-Meta: U2FsdGVkX185qIZUGGOBBntBjL0jijY4R1aRQl/nFOQbf92rmOqCIpIYrn2yW1X/JcnL1VeR4gvp7CDUu+d8mdku3o9OB1SYICgx9K/xCwnUky3oTLI4XP6aOo7UToIjB4nlCd7Cg6sTe9RP34KFduz5utMIhNiq998QNRWqPoBYCOktrlph25XRzy2JgWPF99iCCWU3E/H5MBfVPHVt1aVoJNSr0MQfRsrefiRHBkLK6wM7iZDr6EAtNfiHZMXw+hle0id9PWs7t/zF9lxB5QRUKF+rRM8vq7ZLU3Iu9/BEXlIzH2kXE+DgVR8rM+xJY3Ck4/DDGZHjZksvWWx+lJz+KmVow893HnoDvt3/Qtzgr1amOqyScQ2Xxt+GxSrtPfv8cep9YQtvTXElop3fSPcBknSzkndBHj2kjWgSuuRk3SPZGXN23aRuY8skkGugJSa5wFCy8/rvdoh+ZRO65k2AlmE38CRufk3JUXXdAzWWIUHAa8X4waWVUlODnMwFfJBMSwNrSI5pjaCTbEKrrqSwKVF5hAt51Rdvp4uubiuvMoW6pZclUpszah+5Yfdt77tUtCPWCpX8jvDM+r/V2sGz3zXB2qXYO6AqhvLP8QQTkxEKkubwDumuwyfTmstul2gesXwsGrnZ7Ce42QDlFdEIJXwNYDmiOlZ7yd9H711TFnphiZ/PvRUlMIUSe8gx5cHVMpuPxyujpY1/MTrf2aUTQU/uCzQwJc5E8ilSo0YDWx6HehMnBSZtR+G4HqOL1E/04sejvOABps6sgRQLNuaDCoI5ZBIvM3guAhltXfu1kJBieC5OvI19l2tqhdzSfCJh88hQGrQoKLHuhRzsD1Zsu5I9cjYGFSytnMniyXYLYw/3Ifsk2sjzH9nX3j5J+uyDwYonvWjd2WK7Sq7tpr6nf0tt+DZKGcooLS+mOGvkG5PiXMRGKOx0HUyUz617/+je/U5wuQ7G2kqeZhn
 JMyG+trg
 oluDjE/VDnHtmLz46pqzR4AdLpx74espUIO2SjMd0uSQKu/yNYmZA63wn7nGUefr84ZAxxQ95PDYkQulpVrPju8QaWqdBW9qqJNIG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 12:33:50 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> On Tue, 24 Mar 2026 14:35:45 +0900
> Rakie Kim <rakie.kim@sk.com> wrote:
> 
> > On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> > >   
> > > > > > 
> > > > > > To make this possible, the system requires a mechanism to understand
> > > > > > the physical topology. The existing NUMA distance model provides only
> > > > > > relative latency values between nodes and lacks any notion of
> > > > > > structural grouping such as socket boundaries. This is especially
> > > > > > problematic for CXL memory nodes, which appear without an explicit
> > > > > > socket association.    
> > > > > 
> > > > > So in a general sense, the missing info here is effectively the same
> > > > > stuff we are missing from the HMAT presentation (it's there in the
> > > > > table and it's there to compute in CXL cases) just because we decided
> > > > > not to surface anything other than distances to memory from nearest
> > > > > initiator.  I chatted to Joshua and Kieth about filling in that stuff
> > > > > at last LSFMM. To me that's just a bit of engineering work that needs
> > > > > doing now we have proven use cases for the data. Mostly it's figuring out
> > > > > the presentation to userspace and kernel data structures as it's a
> > > > > lot of data in a big system (typically at least 32 NUMA nodes).
> > > > >     
> > > > 
> > > > Hearing about the discussion on exposing HMAT data is very welcome news.
> > > > Because this detailed topology information is not yet fully exposed to
> > > > the kernel and userspace, I used a temporary package-based restriction.
> > > > Figuring out how to expose and integrate this data into the kernel data
> > > > structures is indeed a crucial engineering task we need to solve.
> > > > 
> > > > Actually, when I first started this work, I considered fetching the
> > > > topology information from HMAT before adopting the current approach.
> > > > However, I encountered a firmware issue on my test systems
> > > > (Granite Rapids and Sierra Forest).
> > > > 
> > > > Although each socket has its own locally attached CXL device, the HMAT
> > > > only registers node1 (Socket 1) as the initiator for both CXL memory
> > > > nodes (node2 and node3). As a result, the sysfs HMAT initiators for
> > > > both node2 and node3 only expose node1.  
> > > 
> > > Do you mean the Memory Proximity Domain Attributes Structure has
> > > the "Proximity Domain for the Attached Initiator" set wrong?
> > > Was this for it's presentation of the full path to CXL mem nodes, or
> > > to a PXM with a generic port?  Sounds like you have SRAT covering
> > > the CXL mem so ideal would be to have the HMAT data to GP and to
> > > the CXL PXMs that BIOS has set up.
> > > 
> > > Either way having that set at all for CXL memory is fishy as it's about
> > > where the 'memory controller' is and on CXL mem that should be at the
> > > device end of the link.  My understanding of that is was only meant
> > > to be set when you have separate memory only Nodes where the physical
> > > controller is in a particular other node (e.g. what you do
> > > if you have a CPU with DRAM and HBM).  Maybe we need to make the
> > > kernel warn + ignore that if it is set to something odd like yours.
> > >   
> > 
> > Hello Jonathan,
> > 
> > Your insight is incredibly accurate. To clarify the situation, here is
> > the actual configuration of my system:
> > 
> > NODE   Type          PXD
> > node0  local memory  0x00
> > node1  local memory  0x01
> > node2  cxl memory    0x0A
> > node3  cxl memory    0x0B
> > 
> > Physically, the node2 CXL is attached to node0 (Socket 0), and the
> > node3 CXL is attached to node1 (Socket 1). However, extracting the
> > HMAT.dsl reveals the following:
> > 
> > - local memory
> >   [028h] Flags: 0001 (Processor Proximity Domain Valid = 1)
> >          Attached Initiator Proximity Domain: 0x00
> >          Memory Proximity Domain: 0x00
> >   [050h] Flags: 0001 (Processor Proximity Domain Valid = 1)
> >          Attached Initiator Proximity Domain: 0x01
> >          Memory Proximity Domain: 0x01
> > 
> > - cxl memory
> >   [078h] Flags: 0000 (Processor Proximity Domain Valid = 0)
> >          Attached Initiator Proximity Domain: 0x00
> >          Memory Proximity Domain: 0x0A
> >   [0A0h] Flags: 0000 (Processor Proximity Domain Valid = 0)
> >          Attached Initiator Proximity Domain: 0x00
> >          Memory Proximity Domain: 0x0B
> 
> That's faintly amusing given it conveys no information at all.
> Still unless we have a bug shouldn't cause anything odd.
> 
> > 
> > As you correctly suspected, the flags for the CXL memory are 0000,
> > meaning the Processor Proximity Domain is marked as invalid. But when
> > checking the sysfs initiator configurations, it shows a different story:
> > 
> > Node   access0 Initiator  access1 Initiator
> > node0  node0              node0
> > node1  node1              node1
> > node2  node1              node1
> > node3  node1              node1
> > 
> > Although the Attached Initiator is set to 0 in HMAT with an invalid
> > flag, sysfs strangely registers node1 as the initiator for both CXL
> > nodes.
> Been a while since I looked the hmat parser..
> 
> If ACPI_HMAT_PROCESSOR_PD_VALID isn't set, hmat_parse_proximity_domain()
> shouldn't set the target. At end of that function should be set to PXM_INVALID.
> 
> It should therefore retain the state from alloc_memory_intiator() I think?
> 
> Given I did all my testing without the PD_VALID set (as it wasn't on my
> test system) it should be fine with that.  Anyhow, let's look at the data
> for proximity.
> 
> 

Hello Jonathan,

Thank you for the deep insight into the HMAT parser code. As you
mentioned, considering the current state where node 1 is still
registered as the initiator in sysfs despite the flag being 0, it
seems highly likely that the kernel parser logic is not handling
this specific situation gracefully.

> 
> > Because both HMAT and sysfs are exposing abnormal values, it was
> > impossible for me to determine the true socket connections for CXL
> > using this data.
> > 
> > > > 
> > > > Even though the distance map shows node2 is physically closer to
> > > > Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> > > > routing path strictly through Socket 1. Because the HMAT alone made it
> > > > difficult to determine the exact physical socket connections on these
> > > > systems, I ended up using the current CXL driver-based approach.  
> > > 
> > > Are the HMAT latencies and bandwidths all there?  Or are some missing
> > > and you have to use SLIT (which generally is garbage for historical
> > > reasons of tuning SLIT to particular OS behaviour).
> > >   
> > 
> > The HMAT latencies and bandwidths are present, but the values seem
> > broken. Here is the latency table:
> > 
> > Init->Target | node0 | node1 | node2 | node3
> > node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> > node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
> 
> Yeah. That would do it...  Looks like that final value is garbage.
> 
> > 
> > I used the identical type of DRAM and CXL memory for both sockets.
> > However, looking at the table, the local CXL access latency from
> > node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
> > unjustified difference. This asymmetry proves that the table is
> > currently unreliable.
> 
> Poke your favourite bios vendor I guess.
> 
> I asked one of the intel folk to take a look at see if this is a broader issue
> or just one particular bios.
> 

I really appreciate you reaching out to the Intel contact to check if
this is a broader platform issue. I will also try to find a way to
report this BIOS issue to our system vendor, though I might need to
figure out the proper channel since I am not the system administrator.

Regarding the HMAT dump you requested, how should I provide it to you?
Would a hex dump converted via a utility like `xxd` be acceptable,
something like the snippet below?

00000000: 484d 4154 6806 0000 026a 4742 5420 2020  HMATh....jGBT
00000010: 4742 5455 4143 5049 0920 0701 414d 4920  GBTUACPI. ..AMI
00000020: 2806 2320 0000 0000 0000 0000 2800 0000  (.# ........(...
00000030: 0100 0000 0000 0000 0000 0000 0000 0000  ................

> > 
> > > > 
> > > > I wonder if others have experienced similar broken HMAT cases with CXL.
> > > > If HMAT information becomes more reliable in the future, we could
> > > > build a much more efficient structure.  
> > > 
> > > Given it's being lightly used I suspect there will be many bugs :(
> > > I hope we can assume they will get fixed however!
> > > 
> > > ...
> > >   
> > 
> > The most critical issue caused by this broken initiator setting is that
> > topology analysis tools like `hwloc` are completely misled. Currently,
> > `hwloc` displays both CXL nodes as being attached to Socket 1.
> > 
> > I observed this exact same issue on both Sierra Forest and Granite
> > Rapids systems. I believe this broken topology exposure is a severe
> > problem that must be addressed, though I am not entirely sure what the
> > best fix would be yet. I would love to hear your thoughts on this.
> 
> Fix then bios.  If you don't mind, can you provide dumps of
> cat /sys/firmware/acpi/tables/HMAT  just so we can check there is nothing
> wrong with the parser.
> 
> > 
> > > > 
> > > > The complex topology cases you presented, such as multi-NUMA per socket,
> > > > shared CXL switches, and IO expanders, are very important points.
> > > > I clearly understand that the simple package-level grouping does not fully
> > > > reflect the 1:1 relationship in these future hardware architectures.
> > > > 
> > > > I have also thought about the shared CXL switch scenario you mentioned,
> > > > and I know the current design falls short in addressing it properly.
> > > > While the current implementation starts with a simple socket-local
> > > > restriction, I plan to evolve it into a more flexible node aggregation
> > > > model to properly reflect all the diverse topologies you suggested.  
> > > 
> > > If we can ensure it fails cleanly when it finds a topology that it can't
> > > cope with (and I guess falls back to current) then I'm fine with a partial
> > > solution that evolves.
> > >   
> > 
> > I completely agree with ensuring a clean failure. To stabilize this
> > partial solution, I am currently considering a few options for the
> > next version:
> > 
> > 1. Enable this feature only when a strict 1:1 topology is detected.
> Definitely default to off.  Maybe allow a user to say they want to do it
> anyway. I can see there might be systems that are only a tiny bit off and
> it makes not practical difference.
> 

Your suggestion is very reasonable. I will proceed with this approach
for the next version, keeping the feature disabled by default.

> > 2. Provide a sysfs allowing users to enable/disable it.
> Makes sense.

I will include this sysfs enable/disable feature in the next version.

> > 3. Allow users to manually override/configure the topology via sysfs.
> 
> No.  If people are in this state we should apply fixes to the HMAT table
> either by injection of real data or some quirking.  If we add userspace
> control via simpler means the motivation for people to fix bios goes out
> the window and it never gets resolved.
> 

Your reasoning is absolutely correct. I will not allow users to modify
the topology via sysfs. However, I plan to provide a read-only sysfs
interface so users can at least check the current topology information.

> > 4. Implement dynamic fallback behaviors depending on the detected
> >    topology shape (needs further thought).
> 
> That would be interesting. But maybe not a 1st version thing :)
> 

This is an area I also need to think more deeply about. I will not
include it in the initial version, but will consider implementing it
in the future.

Once again, I deeply appreciate your time, thorough review, and for
reaching out to Intel for further clarification. It is a huge help.

Rakie Kim

 

