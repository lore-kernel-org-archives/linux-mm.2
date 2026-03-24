Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F07F532D6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8898F6B0005; Tue, 24 Mar 2026 01:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A436B0088; Tue, 24 Mar 2026 01:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729266B008A; Tue, 24 Mar 2026 01:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62A316B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:36:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F09D55F467
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:36:02 +0000 (UTC)
X-FDA: 84579845364.16.D71CF2B
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF1D94000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:35:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2rQ34qrG9eGdpkrPN5mTJfRKWB//hyjrelS6MUinE0=;
	b=TNTtsk/ljLddfCkq5lFMMQoi8Jm35t9ur4f8cRN/BkYWon8mvTXm2FK5Guy3ktAc3KdU14
	b03LYN9kAT1XkToHCzuROuuQsnFIhNWYZ20y4hHjy71ipsTBlbxMaEaisO+HLb5lxcUTdQ
	dBpa6fVLm2J2MHREZhi0AvrvGhszwvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330561; a=rsa-sha256;
	cv=none;
	b=AchNN+kyNKMrppU13r5MmME/EgDkoQcXstwjNT7gYT+cbDyvXOaRrqofSN6TUwdjv67dVQ
	QkpGSbfL8eFrs1sXTNovHBlQHBMBRxAw6h/Ju1MO+2NrotmhQy3UmJAA5GrGDUE384s5ZH
	TFOI5KQbkppiOjBB9E2PTXHCtKT3Qe8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-3d-69c222b85e95
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
	harry.yoo@oracle.com,
	lsf-pc@lists.linux-foundation.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Tue, 24 Mar 2026 14:35:45 +0900
Message-ID: <20260324053549.324-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260320165605.000024c0@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGeXfOzjlOR8cleNTIXGRYeJd8pQgJw5eSMPJTCTncqa2cl3nJ
	BdbEFJpppoi5jVo3L3NqjcZ05GXDa1iJI9PF1C4m3oIZaJZgTRH89uN5nt//y5/CBHbcn5Jm
	5rHyTFGGkODhvGWvp6EdQps0olUdBbXtBgI6v40S0DKRAutqRwEcmiwmYMukAcA50x8A152D
	JJxu+IHDntk5HOqfjBNw0PSIhNW2cQDNyhkSflC/xaHdoiXglGGTC4fVzTjsXuzC4GplAJyu
	jId97WYOrBnTEVBTXAmgo2qAA1sMEqjpnyLjA1Cn2kkinTEflZfZSXSnb5mLnr2Z5yCj/i6B
	jCvVJBp6+BdHnV/iUM1EI0AVJT8J5Jp14KhWcxu1v/6IoxFdH4l+Gfcn0xd5J8RshrSAlYef
	TONJ3ttKudmWU4UmrZ5UgpFoFfCgGDqGGdjs5+6w3tlNqABFEbSQGehKdcc+dBSzcK8XqACP
	wugagqnXPwbuYi8tYaoaNzE34/Qhplq7SLiZT0cztvtl+PbNEKbtlWOLPehIRlmu23IFtBez
	8LIHbO+9meH671sbjA5kSkwabNutoBhHw+Ft9mOsTRN4Fdij3qWodyk6wNEDgTSzQCaSZsSE
	SRSZ0sKw9CyZEfx/dUPRxqUOsDJ6wQZoCgi9+GmJVqmAKyrIVchsgKEwoQ8/sK1bKuCLRYqb
	rDzrsjw/g821gQAKF/ryo1ZviAX0VVEee51ls1n5TsuhPPyVIDL/7JUcS2uy62iOXVzuffyA
	50bigxfm0M+pDRXozMHU3rqCOIMquKPIcy1h5nRQs3XwXZCvQulMOjalTCsdl2tr5/z2NSVZ
	1kqE645rvw2tdTmxXzVrsSHB5yMSMDZ6Yan+Vrdfu2vMfM4Vnl5YOBrq+Xz+k8wco0rJj0yw
	LgnxXIko8ggmzxX9A89/KlfmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfyyUcRzH+97z3PM8bm49Ls0z/tBOKlpKan1rlFrNd1atNlstVq48czfn
	R3eYazNnftUpRMJRieXHuSHlZyEXztEwxlBHLZzYVVKsaHKszX+vvV/v9+efD4UJunF7ShIW
	ycrCRFIhwcN5ubsD9jUIdZID/aXOsKBKS0Dj534CNo34wd4H+QTMye4HsGs0noAVo1oATbV/
	APxt1JNwomQahwvTcxhsnTLhUPN0mID62sckzNQNA/j2kYEL65UfSdin7sbhYFMBAce1q1xo
	UJfjsGWuGYOLaQ5wIs0b6oZNXNheVc+BWQOFBMyPTwNwLKOTAyu0YrhcV7YWdYyT3jtQo9pI
	osKaKJSaPEiixHYzFxW//sJBNZo7BKr5kUmirtxlHDV+OoqyRkoBupfwlUDzU2M4WnyPUPHM
	dw7Kzo9DVS+H8AuCKzzPIFYqiWZl+48H8sS9uiRuRNOpmNoCDakE7zxUwIpi6EOMxthCqABF
	EbSQ6WwOsMS29EFm9u4boAI8CqOzCCZP8wRYxDZazGSUrmIWxmlnJrNgjrAwn/ZgdOnJ+MZN
	F6by+dg6W9HujDK1cH0roK2Z2epWsNG3YQx5k+sdjHZkEmrzsQxgrd6k1JtUIeBogK0kLDpU
	JJEedpOHiBVhkhi3G+GhNWDtwyWxK/cbwM9BHx2gKSC05gf6tEkEXFG0XBGqAwyFCW35jpUt
	EgE/SKS4xcrCr8mipKxcBxwoXGjH973EBgroYFEkG8KyEazsv+VQVvZKEPGtr8M17sQZYXZR
	uioop8z3xVm+U6x4yVztaUj/sNVpsfzqLj/r0w174pZMvor5tmOJen3oSXH2woDZxp8s3r5X
	W9ozfaRo8qLmWW6dpifyut3DlfGpnSIv+yTkcTNyOWWL+dflV57+pmgvWnretmS8/jZMPxc3
	GDxTz6YM/XUR4nKxyN0Vk8lF/wB2WScv3QIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: CF1D94000C
X-Stat-Signature: 8nrutb9pmsa53o4oy917oztjnjbf6g39
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774330558-112725
X-HE-Meta: U2FsdGVkX1/T3DqrCAOpld4Y9nzKP6NCPw99gcXqQEVGvpAbJbpqujTxKUZXA+Xx3T3aAAmoD7+L5wbnUsxX7amZH4yFHsRewfPggjm23TKEJFq1liHwu7o3Rb7pNGKhdFLbxDLn/z9J2RDaSwNdpujkxpUH3wEXrOsRH8SKN+66kzEs5DsR3B+nLzrUNnMtXaOBdfChZySkITiPQe/EF5xcpDVEMiEAA3yhUkyj7SI6q5cJ1wrVg1M0OQIV7+l7T3WVu3iaCiQsiVqkcz/Ca/t/xkwafcicFnKYYgUjWAWg/RRfsaZSe1SyAOYvd87kKgwqB4z79jMoP8aZiG5PEIupS0V4gcH2MxxOBdCKGR23bhLl7oMY/t63LYxPezwBX5gs95IzXiXtdv1oKWCrjtm8otjn4LQETBM55JesMDmIz+bUPp8h/yGdvxzGoHpoInibqr3ovsaCRQjYT06hpiQufDIoFdlL+mxXWIfhzL+0SMXibd/z2a7fQgakhxBPqnk0oTWHHPcNCHQ4tlZqjwnFmnC5ngZrEbRjf9QptSoApwqOdBU3dumlgnh/2SCh4HWkB7ZjQt/CDVFV/rjVYdUcyBkphqX5ESvjzGpqVTMsCpEbftgD9Fs7PdFsQ3wqJ5tQ5XfgQOeERXSr+MXclxX2fhGAm34h8IboeVMqM5cs/XjNx/gC2yMu6h40Hdc1rueTWO97O/DuSvobrEQm1vVH7vqd/JvoiiCMl9qvOr2/mDiVvYg59g7j8XhBi75YpVrvhIgPB2dZL9+5zEs64tgiM4mg0ltCRcWNdsfcXzcVIdH2HU4Qrm4OlBR5Nvg6dG7u7ive17Klq+/d+g/FZHJXvCHzrtqoziLGBe/9+/gRixhpSdZsSL0Dlqz7f2QzyLiLfNX7ubaGnUloQLJvrFIT/2SbYqZwNuge7vsoQFdExbReWMWKZUMsaPH5FrwL1qj5etBtxr4vVO28Pxl
 XS/rsGp5
 LB2MT3WSgeT1yWe5+x31yCzMFkOmDmZDDV4YDi2ih3NuOkCliPCw5eqUtl+gRr0z7Aq7xI20+Ee4dqSy5jJ7Z+8hiLQxDphP2+qqw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> 
> > > > 
> > > > To make this possible, the system requires a mechanism to understand
> > > > the physical topology. The existing NUMA distance model provides only
> > > > relative latency values between nodes and lacks any notion of
> > > > structural grouping such as socket boundaries. This is especially
> > > > problematic for CXL memory nodes, which appear without an explicit
> > > > socket association.  
> > > 
> > > So in a general sense, the missing info here is effectively the same
> > > stuff we are missing from the HMAT presentation (it's there in the
> > > table and it's there to compute in CXL cases) just because we decided
> > > not to surface anything other than distances to memory from nearest
> > > initiator.  I chatted to Joshua and Kieth about filling in that stuff
> > > at last LSFMM. To me that's just a bit of engineering work that needs
> > > doing now we have proven use cases for the data. Mostly it's figuring out
> > > the presentation to userspace and kernel data structures as it's a
> > > lot of data in a big system (typically at least 32 NUMA nodes).
> > >   
> > 
> > Hearing about the discussion on exposing HMAT data is very welcome news.
> > Because this detailed topology information is not yet fully exposed to
> > the kernel and userspace, I used a temporary package-based restriction.
> > Figuring out how to expose and integrate this data into the kernel data
> > structures is indeed a crucial engineering task we need to solve.
> > 
> > Actually, when I first started this work, I considered fetching the
> > topology information from HMAT before adopting the current approach.
> > However, I encountered a firmware issue on my test systems
> > (Granite Rapids and Sierra Forest).
> > 
> > Although each socket has its own locally attached CXL device, the HMAT
> > only registers node1 (Socket 1) as the initiator for both CXL memory
> > nodes (node2 and node3). As a result, the sysfs HMAT initiators for
> > both node2 and node3 only expose node1.
> 
> Do you mean the Memory Proximity Domain Attributes Structure has
> the "Proximity Domain for the Attached Initiator" set wrong?
> Was this for it's presentation of the full path to CXL mem nodes, or
> to a PXM with a generic port?  Sounds like you have SRAT covering
> the CXL mem so ideal would be to have the HMAT data to GP and to
> the CXL PXMs that BIOS has set up.
> 
> Either way having that set at all for CXL memory is fishy as it's about
> where the 'memory controller' is and on CXL mem that should be at the
> device end of the link.  My understanding of that is was only meant
> to be set when you have separate memory only Nodes where the physical
> controller is in a particular other node (e.g. what you do
> if you have a CPU with DRAM and HBM).  Maybe we need to make the
> kernel warn + ignore that if it is set to something odd like yours.
> 

Hello Jonathan,

Your insight is incredibly accurate. To clarify the situation, here is
the actual configuration of my system:

NODE   Type          PXD
node0  local memory  0x00
node1  local memory  0x01
node2  cxl memory    0x0A
node3  cxl memory    0x0B

Physically, the node2 CXL is attached to node0 (Socket 0), and the
node3 CXL is attached to node1 (Socket 1). However, extracting the
HMAT.dsl reveals the following:

- local memory
  [028h] Flags: 0001 (Processor Proximity Domain Valid = 1)
         Attached Initiator Proximity Domain: 0x00
         Memory Proximity Domain: 0x00
  [050h] Flags: 0001 (Processor Proximity Domain Valid = 1)
         Attached Initiator Proximity Domain: 0x01
         Memory Proximity Domain: 0x01

- cxl memory
  [078h] Flags: 0000 (Processor Proximity Domain Valid = 0)
         Attached Initiator Proximity Domain: 0x00
         Memory Proximity Domain: 0x0A
  [0A0h] Flags: 0000 (Processor Proximity Domain Valid = 0)
         Attached Initiator Proximity Domain: 0x00
         Memory Proximity Domain: 0x0B

As you correctly suspected, the flags for the CXL memory are 0000,
meaning the Processor Proximity Domain is marked as invalid. But when
checking the sysfs initiator configurations, it shows a different story:

Node   access0 Initiator  access1 Initiator
node0  node0              node0
node1  node1              node1
node2  node1              node1
node3  node1              node1

Although the Attached Initiator is set to 0 in HMAT with an invalid
flag, sysfs strangely registers node1 as the initiator for both CXL
nodes. Because both HMAT and sysfs are exposing abnormal values, it was
impossible for me to determine the true socket connections for CXL
using this data.

> > 
> > Even though the distance map shows node2 is physically closer to
> > Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> > routing path strictly through Socket 1. Because the HMAT alone made it
> > difficult to determine the exact physical socket connections on these
> > systems, I ended up using the current CXL driver-based approach.
> 
> Are the HMAT latencies and bandwidths all there?  Or are some missing
> and you have to use SLIT (which generally is garbage for historical
> reasons of tuning SLIT to particular OS behaviour).
> 

The HMAT latencies and bandwidths are present, but the values seem
broken. Here is the latency table:

Init->Target | node0 | node1 | node2 | node3
node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
node1        | 0x89F | 0x38B | 0x3AFC| 0x4268

I used the identical type of DRAM and CXL memory for both sockets.
However, looking at the table, the local CXL access latency from
node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
unjustified difference. This asymmetry proves that the table is
currently unreliable.

> > 
> > I wonder if others have experienced similar broken HMAT cases with CXL.
> > If HMAT information becomes more reliable in the future, we could
> > build a much more efficient structure.
> 
> Given it's being lightly used I suspect there will be many bugs :(
> I hope we can assume they will get fixed however!
> 
> ...
> 

The most critical issue caused by this broken initiator setting is that
topology analysis tools like `hwloc` are completely misled. Currently,
`hwloc` displays both CXL nodes as being attached to Socket 1.

I observed this exact same issue on both Sierra Forest and Granite
Rapids systems. I believe this broken topology exposure is a severe
problem that must be addressed, though I am not entirely sure what the
best fix would be yet. I would love to hear your thoughts on this.

> > 
> > The complex topology cases you presented, such as multi-NUMA per socket,
> > shared CXL switches, and IO expanders, are very important points.
> > I clearly understand that the simple package-level grouping does not fully
> > reflect the 1:1 relationship in these future hardware architectures.
> > 
> > I have also thought about the shared CXL switch scenario you mentioned,
> > and I know the current design falls short in addressing it properly.
> > While the current implementation starts with a simple socket-local
> > restriction, I plan to evolve it into a more flexible node aggregation
> > model to properly reflect all the diverse topologies you suggested.
> 
> If we can ensure it fails cleanly when it finds a topology that it can't
> cope with (and I guess falls back to current) then I'm fine with a partial
> solution that evolves.
> 

I completely agree with ensuring a clean failure. To stabilize this
partial solution, I am currently considering a few options for the
next version:

1. Enable this feature only when a strict 1:1 topology is detected.
2. Provide a sysfs allowing users to enable/disable it.
3. Allow users to manually override/configure the topology via sysfs.
4. Implement dynamic fallback behaviors depending on the detected
   topology shape (needs further thought).

By the way, when I first posted this RFC, I accidentally missed adding
lsf-pc@lists.linux-foundation.org to the CC list. I am considering
re-posting it to ensure it reaches the lsf-pc.

Thanks again for your profound insights and time. It is tremendously
helpful.

Rakie Kim

> 
> > 
> > Thanks again for your time and review.
> 
> You are welcome.
> 
> Thanks
> 
> Jonathan
> 
> > 
> > Rakie Kim
> > 

