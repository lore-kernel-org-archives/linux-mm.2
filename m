Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA18FF493A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 05:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3489E6B0092; Mon, 30 Mar 2026 01:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2556B0095; Mon, 30 Mar 2026 01:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199AB6B0096; Mon, 30 Mar 2026 01:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04E576B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:32:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 682B11A0772
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:32:26 +0000 (UTC)
X-FDA: 84601609092.25.4BE1887
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFDB5120004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:32:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774848744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQzfdBs7pBFXDW6UjdGd51SHdrZ0FoT+OPXE1QhvbqU=;
	b=o10OqyJ1c8zg1yvq1yQITDEQhyav92TCDZINZrRuDsr49+HnG/AlFuB876eSJ6ooVBEAKi
	nDNvkoxV+F0XBWhKKoQ1aeEVeUj62hpAYorQRpjeuhBhHsoNFHAUxOb99nkz2Y3OxES/Wp
	tSjhSwLGGqzcBVFULMRV9GVemS08QFU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774848744; a=rsa-sha256;
	cv=none;
	b=G1+zRaXU6Vsvxs8Pk83emuSpDbbjb4LoIDluFrXwKiA9ahwVyInNgIw3+e7LTw+YFuHHqe
	4koT05SQoIp8ZGtJykL4HdfTcAC+hDfT4+BaupN5bME1/npzX1BzV6wwFeRa6PXCyRauh8
	rkbPnudPobbP1fyE/HziTQ0cT8fdS3k=
X-AuditID: a67dfc5b-c2dff70000001609-34-69ca0ae38b19
From: Rakie Kim <rakie.kim@sk.com>
To: Dan Williams <dan.j.williams@intel.com>
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
	harry.yoo@oracle.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 30 Mar 2026 14:32:13 +0900
Message-ID: <20260330053216.397-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <69c5937425273_7ee31005f@dwillia2-mobl4.notmuch>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUhTYRzGeXfOzjmODY9L6m2WwqKL0swv8hU1vRA6FxlFIZSRHtqhjbkp
	8yMnaYoWTkmmIdYmZgZmOpwuhx9p4tDpTFQciopf4behkIVUCuYUwbuH5/k9z//iT2FiBy6h
	FOo0TqNmk6SEABdsCmuuLAoGFQGDnb6o0mwi0OziKIE6Ju+hivJRgAam8gjUMGUCaNX6D6C/
	s/0kmq9dwVH38iqO6t9PEKjfWkWiMtsEQK25CyQaMQziyNlRSaA50z4fOQyfcLRT4oXmS6JR
	r7mVh16PVRPImFcC0LTezkMNJjky9s2R0RKm3TBLMtWWdKb4pZNkCno3+cyHznUeY6nXEYxl
	u4xkBt7s4kz79zDmVf4WwfxcnsaZcuNzxtwyjjND1b0k88vifdv9gSBCxiUpMjjN1euJAvnU
	l348Jf9G5vDgGpYLXoQWATcK0iGwcs6IHWv75i6vCFAUQUuhveuhy/akfWFpZc8BIqAwuoCA
	bY4Nvis4Rcuh/uM+5uJx+iJcm0UuW0QHwxVnE/9o8hJsbJ7GXdqNjoQTjTrSpcW0EG40dYMj
	3gM63i4dMhjtA/OtxsNbkNZRcGashjgaOgt76iZxPXA3nOgYTnSqAa8eiBXqDBWrSArxl2vV
	ikz/x8kqCzh4cG32Xnwb2B69awM0BaRCUQDhUIj5bEaqVmUDkMKknqLiCrtCLJKx2ixOk5yg
	SU/iUm3Ai8KlZ0RBO09lYvoJm8YpOS6F0xynPMpNkguUgUG6lmfOnK9V+gHdNx5nKbxpvlC6
	NBR2Ll09bA6M64v8XSMkd8fDk5dHlBvxseFCbftkdl3Xu5aFKJnEmpcQ6qcvku/E5fhEFVAz
	MZ9TTOt38O5rdMyjYNvKaepWkNJv60/zRHSEnLxfKCzUZSWe/xGr8pC07LE+A94aToqnytnA
	y5gmlf0PzpD3iNwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsXCNUM9Rvcx16lMg9eXxC3mrF/DZnH38QU2
	i103QizOTZnNZjF96gVGixM3G9ksVt9cw2jxfOsvRoufd4+zW9xf9ozF4vOz18wW+58+Z7FY
	tfAam8XxrfPYLSYdusZocXjuSVaL7Q0P2C3OzzrFYnF51xw2i3tr/rNanJy1ksXiW5+0xf0+
	B4tD156zWhxZv53JYvKlBWwWsxv7GC1uTTjGZLF6TYbF720rgEJH77E7yHvsnHWX3WPBplKP
	7rbL7B4tR96yeize85LJY9OqTjaPTZ8msXucmPGbxWPnQ0uP3uZ3bB4fn95i8fh228Nj8YsP
	TB5TZ9d7rN9ylcXjzIIj7AGCUVw2Kak5mWWpRfp2CVwZN3cfZylodq84d+oFcwNjq3kXIyeH
	hICJxLG3v5m6GDk42ASUJI7tjQEJiwhoS0ycc5C5i5GLg1mghU1ix8lXrCAJYYEMiQnL/zOD
	1LMIqEq8uGsBEuYVMJZ4dnkDK8RITYl1G2+xgNicArYS19Z1soPYQgI8Eq827GeEqBeUODnz
	CVgNs4C8RPPW2cwTGHlmIUnNQpJawMi0ilEkM68sNzEzx1SvODujMi+zQi85P3cTIzBul9X+
	mbiD8ctl90OMAhyMSjy8BmwnM4VYE8uKK3MPMUpwMCuJ8HZPP5YpxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnNcrPDVBSCA9sSQ1OzW1ILUIJsvEwSnVwLg5wnufWIHepsmP9+Qfif7yZOsV2eof
	DXIBKdwll08dVXN7+pJ99Sz/+5Yqmk/0DzPKxQv6Lr7Der86JPCjwtXIDeJ2Ov8PT7X7dYM7
	yvD9UUumxYu3NBovlHywr3i75v6LZ0ueKl3qeCJz1ixrmdgz5dg3UU3fv87r+z0zuvuOQm90
	+9MJKqpKLMUZiYZazEXFiQDFevUr1wIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFDB5120004
X-Stat-Signature: 6k1ayo73xqyqwa8xi7uwwpt79ewshi88
X-Rspam-User: 
X-HE-Tag: 1774848743-7472
X-HE-Meta: U2FsdGVkX1/W75UPRD0xwSJ+hr26noG1SPvJRasXxPKwORhV+Ydv3ySQKlb037uY2P/ZaaTyRq8GiTtGlOTlqNQzxjEGOhIj5mjZHbMOlM64J7RAV8TUUuP6BfoPWiV+Sa3u9bGDUxv85M0WX56wyCSeFaF/H8wWv9Qy12nzMUf9ez+8kpSo4FapCCzTS608LKuLQsDuSdAWwCYEezABCY1mHr8sZo8U/3+CtxsCylo7Y32pB9G6nxFTgbdGdE+RS/FQeQY36j5CkFHoUHt1RHJVsLHA7+G1eVwLnCArZpyln23iriAdyiS3SlzEwZXPynp/COmDOW86pdrP5F8yvg2djX9276D+JmljIb/EsDWET43WGPtsu1HJmRx8NIBdQuNo9PqjfQq5ehlgkm/SDoGLgpaLE7XVwM5YvfUbLL9gsyyylErcPNoIXv0oTPzqDgMDzdU06VIMK860ph+UP7ht4bhQXXmk/hFRDTeljA6y6XEHHhS2UgKcUyZQs6zvbZKLHcibIz1SvGInJLJWy2r+u3vWdm5GsZwTvmvQ4iMIkkICe34bZnZ9AbS0xWVaxW08UvQOlsQEG4HdI80SrdhIZYeAPULKnHEoZOfl8AM2MKFFa+xVxXy3CvipZZu5YxGd+yV8P9SurBQpQXszXxlm2nJQYM55DR7klaNZRXBFaM9sXJsVlh84gQ9ntsf+54AurFFLjmY5d/MwWC3XO3w29RM3nfNr+oFVl0UwAjze4cc5E/hlJUPwMIbh5FTtvuUIBGsZkYiU/jaUyo4yfIgS1E0LZomajsONuWb3IgBPHScUFxNv23qLy4ezYnyMC4Rb/jo8NvmC6pJUnk/sFtv+/iuJDdCIgHkEKAd6eqP7g/Q9sgRrxXdo4Ke8Z00YuK2c4Yrcwf/VNvH26s47Xryr6Dfg0jxuT0wxzJinuA+Pv0KarF4AvjQwlY7UI7+rJ+MX7cKkGvNtV2j/Uok
 UJWVdJeH
 FKX6g2MVq2VnKLRpLDJQfck8xL8c0zt3xSv62lArS9oh0bQlS7RkcCtWczzhfWZq/eygunNI6pN9BpyvyAhtGw0fFqTeuDSXvwHNpsUo23lLABYLh1tsLE9trZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 13:13:40 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> Rakie Kim wrote:
> [..]
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
> This looks good.
> 
> Unless the CPU is directly attached to the memory controller then there
> is no attached initiator. For example, if you wanted to run an x86
> memory controller configuration instruction like PCONFIG you would issue
> an IPI to the CPU attached to the target memory controller. There is no
> such connection for a CPU to do the same for a CXL proximity domain.
> 
> > As you correctly suspected, the flags for the CXL memory are 0000,
> > meaning the Processor Proximity Domain is marked as invalid. But when
> > checking the sysfs initiator configurations, it shows a different story:
> > 
> > Node   access0 Initiator  access1 Initiator
> > node0  node0              node0
> > node1  node1              node1
> > node2  node1              node1
> > node3  node1              node1
> 
> 2 comments. HMAT is not a physical topology layout table. The
> fallback determination of "best" initiator when "Attached Initiator PXM"
> is not set is just a heuristic. That heuristic probably has not been
> touched since the initial HMAT support went upstream.
> 
> > Although the Attached Initiator is set to 0 in HMAT with an invalid
> > flag, sysfs strangely registers node1 as the initiator for both CXL
> > nodes. Because both HMAT and sysfs are exposing abnormal values, it was
> > impossible for me to determine the true socket connections for CXL
> > using this data.
> 
> Yeah, this sounds more like a kernel bug report than a firmware bug
> report at this point.
> 

You are right. From the hardware's perspective, the `0000`
flag makes perfect sense since the CPU is not directly attached to
the CXL memory controller. I completely agree with your assessment
that this points directly to a bug in the kernel's outdated fallback
heuristic logic, rather than a firmware error.

> 
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
> > 
> > I used the identical type of DRAM and CXL memory for both sockets.
> > However, looking at the table, the local CXL access latency from
> > node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
> > unjustified difference. This asymmetry proves that the table is
> > currently unreliable.
> 
> ...or it is telling the truth. Would need more data.
> 
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
> Before determining that these numbers are wrong you would need to redo
> the calculation from CDAT data to see if you get a different answer.
> 
> The driver currently does this calculation as part of determining a QoS
> class. It would be reasonable to also use that same calculation to double
> check the BIOS firmware numbers for CXL proximity domains established at
> boot.
> 

It was indeed premature of me to conclude the table was broken solely
based on the large and asymmetric numbers.

Interestingly, Dave Jiang just mentioned in another reply that the
Intel BIOS folks confirmed these HMAT values actually represent
"end-to-end" latency, which perfectly explains why the numbers are
so much larger than expected.

Also, I have just posted the detailed `SRAT` and `HMAT` dumps in my
reply to Dave Jiang. Please feel free to refer to the exact firmware
structures we are discussing here:
https://lore.kernel.org/all/20260330025914.361-1-rakie.kim@sk.com/

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
> > 2. Provide a sysfs allowing users to enable/disable it.
> > 3. Allow users to manually override/configure the topology via sysfs.
> > 4. Implement dynamic fallback behaviors depending on the detected
> >    topology shape (needs further thought).
> 
> The advice is always start as simple as possible but no simpler.
> 
> It may be the case that Linux indeed finds that platform firmware comes
> to a different result than expected. When that happens the CXL subsystem
> can probably emit the mismatch details, or otherwise validate the HMAT.
> 
> As for actual physical topology layout determination, that is out of
> scope for HMAT, but the CXL CDAT calculations do consider PCI link
> details.
> 


Thank you for the clear architectural guidance.

Knowing that physical topology determination is strictly out of scope
for HMAT reassures me that leveraging the PCI link details is indeed
the correct direction for this Socket-aware feature.

To discover the topology, I actually implemented a method to retrieve
this information directly from the CXL driver in PATCH 3 of this RFC:
https://lore.kernel.org/all/20260316051258.246-4-rakie.kim@sk.com/

However, I am still wondering if this specific implementation is the
truly correct and most appropriate way to achieve it in the kernel.
Any thoughts on that specific approach would be highly appreciated.

I will keep your advice in mind and ensure the fallback and policy
designs are kept as simple as possible for the next version.

Thanks again for your time and all the valuable insights.

Rakie Kim


