Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DC5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D4A6B00B8; Fri,  3 Jul 2026 05:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6AF6B00BA; Fri,  3 Jul 2026 05:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177386B00B9; Fri,  3 Jul 2026 05:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD6336B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:02:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66D4A1C34F6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:02:57 +0000 (UTC)
X-FDA: 84946875594.18.EF499D3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 279744000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:02:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783069375;
	b=Y1B5H30yrKXnty8G/7Keq7oTaWxbeDrdtXGaQQxvVGXLaTyOSto5wtNI8ayJYVy1+5Wb1n
	sZOOkIaldn1HYHI4JbyRg1BBNfKoC/bJ9zNrmtGs3jbxMnZzoRkQ+I8UvlHbtL2R/QBeDg
	qyS8LCuhp5ze9uCApUtE94V5ty2c2nY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783069375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vK3N7aTACID0By/7KCnIUNlw/QfW3yZgLaxjGYBSv0=;
	b=JPLaBdOlUrKjVwrAneqybDpO81zQO9BDwuEUELKe9eDlr44jynJiw6shurnF1wwjXT1XzS
	GnS2K1zbEHebvt3fMo/ACroJA05+Xfk+pnXVfwf0moGzJNzX5+FTPUB9ipTlMnvcn4Ejs/
	+5UvcBBjHdP2/xRhCyHhCcp4bsAjEVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: f54cf2ee76bd11f1aa26b74ffac11d73-20260703
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:aaff1f12-1d33-4415-ba58-b834be07f4bb,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:aaff1f12-1d33-4415-ba58-b834be07f4bb,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:9719779c97f4ff0272f18ecf2c5f68b0,BulkI
	D:260702200044ZYHCF6SH,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:1,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f54cf2ee76bd11f1aa26b74ffac11d73-20260703
X-User: duanchenghao@kylinos.cn
Received: from localhost [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 560380739; Fri, 03 Jul 2026 17:02:46 +0800
Date: Fri, 3 Jul 2026 17:02:41 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Maximilian Heyne <mheyne@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	jianghaoran@kylinos.cn
Subject: Re: [Hypervisor Live Update] Notes from June 1, 2026
Message-ID: <20260703090241.GA148322@chenghao-pc>
References: <aiWW6ZwwalqQmVcB@google.com>
 <20260702060202.GA78893@chenghao-pc>
 <20260702-pay-effect-93be8ab0@mheyne-amazon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260702-pay-effect-93be8ab0@mheyne-amazon>
X-Stat-Signature: ooyqij4mqbrb74rxgzt6dgim6twngk9z
X-Rspam-User: 
X-Rspamd-Queue-Id: 279744000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1783069372-204380
X-HE-Meta: U2FsdGVkX19CV3lZ5q/2Uh0icyw0aRf3n3sbv6Yh8P1QDb+BOpi6xrJyqBSaajGUK8OgaP2QUrG4ihhdwwFxkIxL6b87jmCuBYopRjVzu4yg2nIdMCpc5YtEgBAnbLctqBRVJK4AE6W3lXTdoo+ggZXLkGeHzx1AjeT3GIdPvavTJo4fWK/8wFalhzdqybsoit4owlMfxiEe4nzwGSqX99gAE29Savl5gR9QIPc2vuF/SBQ7VoiK+S/y5XliDRhSfXHb9dPQFzrrc9RFQZe7Ha3Ub2PTSSZJcMl+MJvpehvhArubVM3ordzylb/JDOpOit4Ozn4ThGQG0L17mvTIuaVK+3LUSL29hJUISss7nAwWWWabbdK4wP7AobpdeHwpe+jSMgsxAVElgfaDJJ9neF4NgNLwdsZGvCtvBDPUnohvYXvl8o853WQO2UZ+9TMb5ck9ApmAzmWuJGOLjYyvdqp/oXhZw2qPdHdp25WZxTaj5Moho22wt5sww2MECv6qOrOwcIBB2Pu8l0o0aDosTv9ByxGYtV6rdILtjIyjExsA11dwufY/ixTDcGyy80RyPx06GZm3TZQVwBP96rWIijIDhRzew0Wi2qoKy1/iFF6df1b8sprwCbjhO9Rwg3waVnUVKHVV80jefAjxKT7oYEzzZsNcC/fzvPnywyIfPuCeq6KnARofZl4tCRzBibc/6fgEqgExjNmzflnlSqSbLOurjNA+/PFvF5G3XDtv9UeyuRz7WfwmIysIzaEJo0LNUKWIfyQGQMuMPn3FfyfPJCb3SvqMuUPbRrwJ6IOWbwahYD5hDNrbVUWJELVrr2ys7TBUTrsDinYwjnXn+4cnZ1T78UUexWfSWNR6KcVx/sepW6M8ANALjjAXHN+R/iFJp7G8pcdjZCdty+Ytba+yJsTmB/RIbPv2qyNEcbYc+nc2jbEY93Nk5A5RBibg3V8GPBFTMt147f1R4NeC5nm
 Z0FsBvMD
 Ta/d7wTDF13io06E0qhFR+njwOTqDVSR0EqBW+vZHOJGaUBL6c4/UoDVe9nsfbLBOaPqHWfwJjWO23xESKW6um+FctIhlfdBJ4eVwRrzek9Fwo6lGIX+dEK8RthBpRJsy/98AROEzeYvcuY720UhzmlkbGT0Wn+4MqhrMlS/a4vnktet4iOa+OkJaq4LuBN3UVpkHCAsgT4GN+rhTi0ja923P/4AQoKv66RPvUdkhRnFDsmJj63ouiFnD/kAZLGUy4ssv2VbtaslWmJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:00:16PM +0000, Maximilian Heyne wrote:
> On Thu, Jul 02, 2026 at 02:02:02PM +0800, Chenghao Duan wrote:
> > On Sun, Jun 07, 2026 at 12:06:01PM -0400, Pasha Tatashin wrote:
> > > Hi everybody,
> > > 
> > > Here are the notes from the Hypervisor Live Update call that happened on 
> > > Monday, June 1. Thanks to everybody who was involved!
> > > 
> > > These notes are intended to bring people up to speed who could not 
> > > attend the call as well as keep the conversation going in between 
> > > meetings.
> > > 
> > > ----->o-----
> > > LPC 2026 Call for Proposals
> > > 
> > > The Call for Proposals for the Live Update Microconference at LPC 2026 
> > > is officially open. Please submit your topics and proposals before the 
> > > deadline on July 24th.
> > > 
> > > https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex
> > > 
> > > ----->o-----
> > > KHO Xarray Implementation & Core Data Structures
> > > 
> > > Pratyush is collaborating with Mike on a KHO fallback allocation 
> > > strategy for memblock. Alongside this, Pratyush is designing a 
> > > serialized, sparse "KHO Xarray" data structure to lift current mapping 
> > > restrictions across all three memfd types (shared, hugeTLB, and 
> > > guest_memfd). By allowing runtime page faults and allocation tracking 
> > > post-preservation, this avoids flat vmalloc array scalability 
> > > limitations.
> > > 
> > > Potential wider use cases for the KHO Xarray were discussed:
> > > - MSHV sparse bitmap tracking.
> > > - IOMMU page table tracking (Samiullah will evaluate domain/device tree 
> > >   association fit).
> > > - PCI/VFIO sparse tracking via Bus/Device/Function (BDF) key spaces.
> > > 
> > > Slab/Cache Preservation vs. Linked Blocks:
> > > David Matlack noted that using an Xarray page per PCI device would be 
> > > too expensive given their small struct sizes. Pratyush suggested 
> > > preserving slab caches via dedicated kmem_cache flags to manage small, 
> > > arbitrary allocations. As an immediate alternative, Pasha's ongoing LUO 
> > > limits refactor series introduces a highly compact block-linked list 
> > > structure optimized for runtime file/session tracking. David Matlack 
> > > will review if this fits the PCI core tracking requirements.
> > > 
> > > ----->o-----
> > > LUO Limit Removal & PCI Core Status
> > > 
> > > LUO Refactor: Pasha is updating the LUO series to address Pratyush's 
> > > comments (primarily renaming iterator functions) and plans to send out 
> > > v2 shortly. Given that LUO is not yet in fleet production, the group 
> > > agreed to fast-track this into the upcoming merge window to align with 
> > > systemd's fdstore integration.
> > > 
> > > PCI Core v6: David Matlack sent out v6 incorporating two critical fixes 
> > > spotted by Sachiko regarding get/put semantics and double-retrieval 
> > > failures. Review tags from the live update team are needed to help 
> > > secure Bjorn's Ack once he returns from vacation next week.
> > > 
> > > ----->o-----
> > > IOMMU Persistence & Process Memory
> > > 
> > > IOMMU v3: Samiullah is addressing recent review feedback on the IOMMU 
> > > persistence series and intends to post v3 by the end of this week. The 
> > > associated development roadmap document has received positive 
> > > stakeholder attention.
> > > 
> > > CRIU & vm_splice: Maximilian's investigation into optimizing vm_splice 
> > > for copy-less data preservation remains deferred but remains in the 
> > > pipeline, with potential future collaboration with Google's tmpfs splice 
> > > efforts.
> > 
> > I’ve also been researching a combination solution integrating CRIU and
> > KHO. My approach stores all image data dumped by CRIU into memfd, then
> > persists those memfd objects via KHO/LUO.
> 
> I've experimented with exactly the same approach plus if a process
> already has memfd's, don't dump (to yet another memfd) but preserve this
> memfd directly via KHO.
> 
> > 
> > I’ve reviewed the historical meeting notes and would like to clarify:
> > does the CRIU solution discussed in the meetings aim to save the full
> > set of a process’s metadata and data, or only the anonymous memory and
> > shared memory allocated during the process runtime?
> 
> I've been the only one bringing this up in the meetings and my idea is
> to enable a reboot with negigible process downtime. So save the state of
> a process, kexec and resume the process. Currently, preservation and
> restorations are quite slow when processes have a lot of anonymous
> memory as this needs to be moved to a preservable memfd first. So what
> I'm researching is how I can convert anonymous memory efficiently into
> something that can be preserved (currently memfd).
> 
> And to answer your question, I'd say save data and metadata in memfd's.
> As the alternative would be to save the metadata on disk which would be
> slow.
> 

Thank you very much for your explanation.

I know vmsplice enables zero-copy operations on user memory pages. When
used together with splice, this syscall can establish references between
user pages and file descriptors. Could this be the optimal solution to
our current performance bottlenecks?

Or are there any other better alternatives already available?

Chenghao
> > 
> > Chenghao
> > > 
> > > ----->o-----
> > > guest_memfd Enlightenment & VMM Documentation
> > > 
> > > Tarun debriefed the community on his upstream presentation regarding the 
> > > initial guest_memfd preservation patch series (currently covering fully 
> > > shared mappings with page-sized folios).
> > > 
> > > Key design and architecture alignments include:
> > > - VM File Association: guest_memfd requires an active 'struct kvm' 
> > >   context to be retrieved. VMMs must preserve the parent VM file 
> > >   alongside guest_memfd, using LUO tokens to re-link them on the 
> > >   incoming kernel path. This sets the stage for future private 
> > >   mapping/secure EPT table tracking.
> > > - Relaxed Fault Logic: The group agreed to drop strict upfront pre-fault 
> > >   checks. Instead, standard runtime page-fault semantics will apply. If 
> > >   a guest page fault occurs post-preservation, it will bubble up via 
> > >   standard KVM_RUN ioctl exits to the VMM, which can safely pause vCPUs 
> > >   and retry the fault post-kexec.
> > > - Centralized VMM Documentation: Pasha and David Matlack proposed 
> > >   creating a centralized guide under live_update/vmm detailing the 
> > >   overall live update flow, timing constraints, and subsystem 
> > >   requirements to assist external QEMU and VMM developers.
> > > 
> > > ----->o-----
> > > Next meeting will be on Monday, June 15 at 8am PDT (UTC-7), everybody is
> > > welcome: https://meet.google.com/rjn-dmzu-hgq
> > > 
> > > Note: I am going to be traveling on June 15th, David Matlack is going to
> > > be hosting it.
> > > 
> > > Topics for the next meeting:
> > > - Presentation of VFIO roadmap (Vipin and David Matlack)
> > > - Status of KHO Xarray development and slab preservation feasibility
> > > - Review of PCI core changes v7 and upstream merge coordination
> > > - IOMMU persistence v3 review feedback
> > > - Detailed review of guest_memfd v2 and VMM interaction documentation
> > > - Review and coordination of LPC 2026 Microconference topic submissions
> > > - later: KHO support for Confidential VMs including page table
> > >   preservation and pinning
> > > - later: versioning support for luod to negotiate
> > > - later: KHO enlightenment for ASI
> > > - later: update on PCI preservation series and next steps
> > > - later: testing methodology to allow downstream consumers to qualify
> > >   that live update works from one version to another
> > > - later: reducing blackout window during live update, including deferred
> > >   struct page initialization
> > > 
> > > Please let me know if you'd like to propose additional topics for
> > > discussion, thank you!
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597

