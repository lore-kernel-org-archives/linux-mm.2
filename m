Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0F7F364A2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BDB6B0005; Thu,  9 Apr 2026 12:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343606B0089; Thu,  9 Apr 2026 12:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EA86B008A; Thu,  9 Apr 2026 12:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 132346B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:48:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9801813BC6E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:48:51 +0000 (UTC)
X-FDA: 84639601662.23.9321B15
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E0E140003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:48:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=JBa2iyPy;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="j FdnhQ0";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of boris@bur.io designates 202.12.124.156 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775753329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3IP8RghDZznaGjEmBTDPbOMMDpuWMs623Nter0+ozU=;
	b=xrq9G3DLMOz+LhSjU1WRdYcWhjG1tV+hM9b2QlTJONx/PD49ZZ1UE+NWjOjPpFUZINni4w
	a6PjYe6/gqD+zGXZZQVS60dkPQEBSTEOjaKueOGJLLaQWoYKMRAC2ZH/w8eNR8etivv2Nh
	C7Wll3WlavCuwNVNUTbmS3pq7IkLUOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775753329; a=rsa-sha256;
	cv=none;
	b=gABq7G6PMFnzkKQnOo5Pjozjdl5lDHjJ2WLck/VW7JQWlJYS5fdnYpUTgPrGGgOHIhIgbf
	hUZ2XmJ1Dto6jXGEEdWvekD5LERUaCsKud2rAOlGwtLyYTRKbaAxee2UiPms6tTsHVprd4
	jzsK2pjUSZvkuMD4CQePcSc/lfGC6HU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm3 header.b=JBa2iyPy;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="j FdnhQ0";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of boris@bur.io designates 202.12.124.156 as permitted sender) smtp.mailfrom=boris@bur.io
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 179837A00DE;
	Thu,  9 Apr 2026 12:48:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 09 Apr 2026 12:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775753327;
	 x=1775839727; bh=d3IP8RghDZznaGjEmBTDPbOMMDpuWMs623Nter0+ozU=; b=
	JBa2iyPyBSx865Vm57yQ9EewtxMcG+eG7Jgc9CSUH8jaIINA093WZQry+7gh2yl+
	aNz9zY/SRV79rLLr+1mmE68CBMOyouIrKLQia8AEuNk0TMnwPihLwDa6ihvyPCb/
	jKiYLcCuQr3aWV9qVfOaaJEseShsB9YcdNfafnHicgJNxjfgiFkPNi29yQNBQNQv
	Djofhw4vcCmKrSK/kFRJjzvpX6zxmTpzl7DVKJFyfVcxoFbnx6xzZQroFOCbRMaD
	thvra328CsJNvF/RTxouILIt+rIJquR/A0PPk6WYWjedpUMFRDplK4iz8+QzwbcE
	EG+2UQukTp62CjhEyqZCng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775753327; x=
	1775839727; bh=d3IP8RghDZznaGjEmBTDPbOMMDpuWMs623Nter0+ozU=; b=j
	FdnhQ0j8JeFI/3d422WWF0ZdEqWBOoBRxcWGHP0bHR0KsxBFnaKxk5jSGKD+TmbL
	oM9C/T1t5V44YXRg4J39hTbGy34O9CF8LxKmbm3nWhkiZ8Y2s/r2yuYaWC/dTtGD
	wwcpPfILPpNnG+31sNrDrBMIDYUwNXmkJ97LjEkit4CGwpSDGzmyj751Vcirp5d1
	vyOxPrK5gz/mdJMe+O06ED6p+DR4Hx1Ecsp1lpEBSkF06xxUuIQCx0UhIyVdEMkJ
	7xxUCDgQAkbxquK/PeA1AYsQA8UNPwziK8Er77RdaG/L2Td5WUtcOfgHYhXCjlOT
	nWw4wRDmrGk8zWhaU9sAQ==
X-ME-Sender: <xms:btjXaTIj4JALk8eSIe2zHXPgtiJHACUvV4YcL0OVlHL1e24bNSEReg>
    <xme:btjXaQdYE8GcM8qo7oMzKqKioGC009rkLsNv71Emq_s3i1_BUvsfuhPH4IeBiKjpL
    _Z0Y7AUGCOCd0qZUlAkie7zmXKK-uywvw36bnwYuL3Q2iUoY5I4hfc>
X-ME-Received: <xmr:btjXaS-UPDU_F5TXjtUY_b0fTLBHzr1iaGpbcv7QIHXqxJwPPLhRPAuIaVEYKOJBeNNmEXT0EphZC4zeUmHmlZ9ZcsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjedtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertd
    dttdejnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudelhfdthfetuddvtefhfedtiedtteehvddtkedvle
    dtvdevgedtuedutdeitdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeeipdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtgho
    mhdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopehlihhnuhigqd
    hfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugidqfhho
    uhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:btjXadpwcQQ2ZRj4u1tNxPhoPOIG8sKz4_AyTuHyuFNYBuRXnmbFeA>
    <xmx:btjXaXBfsfJdNHtC8jzasYRcUlrByLIrNikW9LO1CT4FgCDXDw8Rjg>
    <xmx:btjXafxGUsuFqAws7MR3oUl9hId454ofOKQlVjkadRXQ8NoCuIEtww>
    <xmx:btjXaU19YmEB3F8nG3286Yh19t264tjA_nQ7pTdeVt33MbyYxuNrQQ>
    <xmx:b9jXaZZXMdY46GcseSt1rTR0bhID00IyipGp6U9DJH22JwFt_009-ZpX>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 12:48:46 -0400 (EDT)
Date: Thu, 9 Apr 2026 09:48:34 -0700
From: Boris Burkov <boris@bur.io>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <20260409164834.GA3472346@zen.localdomain>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
X-Rspamd-Queue-Id: 5E0E140003
X-Stat-Signature: wwtd691p3rs8qa4hjf4tf9rwpwrsw7xx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775753329-116134
X-HE-Meta: U2FsdGVkX1+NV782k/HdNWjmRGWKxm/ap+MRukj0x3pT8CfdjIvbPXMReWd2h/SlP1Gr+MqPbEKx5M5NjH/pEoU2khTkMOi6wQSyq0vlN68wNWwPkq/bIpsi4iPER6cDRH2pGz4f1DLuGLWKujUdm49D1Ie9lw4wo4m8/0/I03JtKoHpt3TxJrwShmZo43NdqE5DtW4rqvyZzYE0tgfuckRi5K/iXm1Piev/WiEe0zBmFWB66sIgz9L0Xyo6sUI3TJZn39cYvVWWxCElvU/WfQ5S3VAXSBpOiTVqV0bvUGo330NdIhM43an2flYepDnmNkGAlxHAAb1icnJVZYTBX+MEZXXbRVwwGgpOfprz96lnHJFU1N8PMvaQ5wrIPxeWDVbUWKWPeG0kBkSepSOciE37u6Aa/ngzepQejlizDCPz7nBhbmwMJWuMZ7hIA68eJijqWsERhZ5tlG79NxMmD9Sqje5/6Untlx13hKEs8VpHwbbH7n4mr3inxbyGmIlgvMuiLNMBZQq/cruU1V8/dZ+cF+hV7RyiLaqc5SRh/332s+jNHw9pRL878s5iwRjcZWmyHRw1sK2YQHgoWQNlvy283KctNmLchM6jjVH/ai8IuMTysU0oYKyDQJGkPlilXcITbus6KYMqby3SICsceWScOZOAhS5DcDqfMTjMsByvly6d3csZt6pyz8VS74BXXQeSQlMkFW8e2otYSkiZ4IqYWrBc8qumpwlJu53UG9afz110WZoFOLnzFBXDtG6AJ6Sq4cwnhPI4iiEy9bjscA8AAUjD83emkcaZq72AuntkFlXKYY5ib4/MlvksPc1Cp4xXCv1qREisR56EHQTNSZpxSdSXX5kBeFatOQelonL7T7WKAlKvVYGry4/YbGn+kFlhNTIhsROkSkKZZ9XY7WXNsWkkxg7ffnT4gVo+jQgTttYKXVrAsW9j9JJD/qV7otEtnT5W6bPoNgpdUHB
 qX/yUQfv
 b/hpnQknqXtST6B6VFYtevOcGMzVTywcdqHSn8WkeOcEhT+hEgKAnYBd5pSEHtf4WKz8OA7EKu8/B9xn/vADLZ3W9LJ9De3zNSnVCYIEXuZVZ7Z5RkxEG4Q2Udf2Q+KXbeS1zwkpqpbOH+fJew56uBElEdwUKCOolfH9v/1OnvEaUCGo/KXp/3b+tEfybaBl//mLPJ/gMHri+JVt2MOsGPh/Hd500Bv5PSOr/j7XrscJjdrXaeUEgA7yd8q3MEjL7+UrgtLSrzLQEHBPE6UV+iK4KZWjGAUY1S2ymJX0tR14AWqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 02:57:47PM +0200, Amir Goldstein wrote:
> On Thu, Apr 9, 2026 at 11:17 AM Jan Kara <jack@suse.cz> wrote:
> >
> > Hello!
> >
> > This is a recurring topic Matthew has been kicking forward for the last
> > year so let me maybe offer a fs-person point of view on the problem and
> > possible solutions. The problem is very simple: When a filesystem (ext4,
> > btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> > complex cleanup - like trimming of preallocated blocks beyond end of file,
> > making sure journalling machinery is done with the inode, etc.. This may
> > require reading metadata into memory which requires memory allocations and
> > as inode eviction cannot fail, these are effectively GFP_NOFAIL
> > allocations (and there are other reasons why it would be very difficult to
> > make some of these required allocations in the filesystems failable).
> >
> > GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> > trigger warnings - and for a good reason as forward progress isn't
> > guaranteed. Also it leaves a bad taste that we are performing sometimes
> > rather long running operations blocking on IO from reclaim context thus
> > stalling reclaim for substantial amount of time to free 1k worth of slab
> > cache.
> >
> > I have been mulling over possible solutions since I don't think each
> > filesystem should be inventing a complex inode lifetime management scheme
> > as XFS has invented to solve these issues. Here's what I think we could do:
> >
> > 1) Filesystems will be required to mark inodes that have non-trivial
> > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > whatever :)). Usually I expect this to happen on first inode modification
> > or so. This will require some per-fs work but it shouldn't be that
> > difficult and filesystems can be adapted one-by-one as they decide to
> > address these warnings from reclaim.
> >
> > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > performance reasons. I expect this to be a significant portion of inodes
> > on average and in particular for some workloads which scan a lot of inodes
> > (find through the whole fs or similar) the efficiency of inode reclaim is
> > one of the determining factors for their performance.
> >
> > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > to process them.
> >
> > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > inode, doing the hard work.
> >
> > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > and they can work on freeing memory needed for freeing of hard to reclaim
> > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > they should really be addressed.

One question that pops in my mind (which is similar to an issue you and
Qu debugged with the btrfs metadata reclaim floor earlier this year) is:
what if the hard to reclaim inodes are the *only* source of significant 
reclaimable space?

> >
> > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > control for some workloads (in particular because there could be multiple
> > CPUs generating hard to reclaim inodes while the cleanup would be
> > single-threaded). This could be addressed by tracking number of inodes in
> > that list and if it grows over some limit, we could start throttling
> > processes when setting I_RECLAIM_HARD inode flag.

Anything that pushes back on the "villains" sounds very good to me :)

> >
> > There's also a simpler approach to this problem but with more radical
> > changes to behavior. For example getting rid of inode LRU completely -
> > inodes without dentries referencing them anymore should be rare and it
> > isn't very useful to cache them. So we can always drop inodes on last
> > iput() (as we currently do for example for unlinked inodes). But I have a
> > nagging feeling that somebody is depending on inode LRU somewhere - I'd
> > like poll the collective knowledge of what could possibly go wrong here :)
> >
> > In the session I'd like to discuss if people see some problems with these
> > approaches, what they'd prefer etc.
> 
> Hi Jan,
> 
> Is this expected to be a FS+MM session or only FS+Matthew?
> 
> Boris,
> 
> Is this related to the Direct Reclaim Scalability topic you wanted to discuss?
> We are still waiting for posting on this topic.

Very much related. Thank you for the message. I (and others at Meta) are
working on this general class of problems, so I will send out a separate
message right after this email, but I don't want that to suggest I am
not interested in this particular aspect!

Sorry for the delay with the topic, Amir.

Thanks,
Boris

> 
> Thanks,
> Amir.

