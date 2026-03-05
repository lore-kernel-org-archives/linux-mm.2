Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DF9EFCE5A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 03:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B19B6B0088; Wed,  4 Mar 2026 22:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F966B0089; Wed,  4 Mar 2026 22:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7340B6B008A; Wed,  4 Mar 2026 22:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 607516B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:45:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 114CB1C793
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:45:39 +0000 (UTC)
X-FDA: 84510619998.23.8244D8C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42DC614000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:45:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q+ey8CsJ;
	spf=pass (imf26.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772682337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJhVUaJiR6Sf2FRKdFTkU/hDMrwnFyJdVNRrYnTxuA0=;
	b=7z1Kn5C5wf0xKvikrJZ/3g9rmsyfjMW3JkT3N0RDSokrPP2QaU9Je5s1wCPPY2Kz2HVC6g
	+xLg2zpD65Fv01t0dKJKSgEObMW/mK04LwsacC6U+/0tT3ih4q3g+dmu5gpGvkt/J9jxur
	78ZNUplfsK+l/9aE12+nnet45EhZYkY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q+ey8CsJ;
	spf=pass (imf26.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772682337; a=rsa-sha256;
	cv=none;
	b=piPrF6I9O0vuERmveIC7uU3x0rD41+OiZpQndayj6iN7HrGVHu69v8Y7PU+GnCGVCMxdVi
	E47C/zgZT691j4E00/i0GRvycprmqGWRFrM57NcnS87Ve70qV1/FJkE++zo5Da5hBsmeTe
	w3Yiwxn+93D+7v9xeBtntcSGtHGNJtE=
Message-ID: <18666c09-1052-4a2c-8807-8ac330b4d918@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772682335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJhVUaJiR6Sf2FRKdFTkU/hDMrwnFyJdVNRrYnTxuA0=;
	b=Q+ey8CsJGN1BYpIKPzSyNnFZgmkYbgiKmLpsvD4imYZtDjTGLdW5lO3hUxhfurVC7QdxaL
	y9Et4pJA3qi5aqlECSkTEe9lULlzUYb7ogQ4QoN9vSE+XxOVwknj/F6A5sqeSm4kjT3k8Z
	egRtLWGuMvfjafx++YxD4F3DdHmMIEQ=
Date: Wed, 4 Mar 2026 19:45:25 -0800
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] HugeTLB file preservation across live update
To: Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org,
 lsf-pc@lists.linux-foundation.org
Cc: Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Alexander Graf <graf@amazon.com>,
 David Matlack <dmatlack@google.com>
References: <2vxz1pixvk4m.fsf@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <2vxz1pixvk4m.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 42DC614000D
X-Stat-Signature: z31x1x93fm6ca164qx7xc9c4hodx33uz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772682337-301359
X-HE-Meta: U2FsdGVkX18cR/0B5NtX71vRMxwb4M8MDyC8pdHcYgriPE8Q8Rwf/yym4tSuPV2Y8+gCqqqvjSxJdMBSKQkxlNwQMzmbSRey9M+iwFxI/pfdSMpsO4HsQ2FSNHk1fZcLb40LLHCLNn1VWqMm5EiEFMKAQz2nG0Qxyb2zlqBq79ippzE0MA7n34OAzICP8pjsLF8fAKyiPW+GNSqxLpDOidPmmG6/KpGFjgeyH1QaxX6TEHveeEbJ1t8sczKXdgt3/L+ydMXlgHAVVmEvTmNaij8DaCRIk6QT9FkGARDA7TBdt0CNI/HjitDEPyUMdFTETHUaFxEdG0+b2rztRSS1NqYElZ6Af4m8uyCrLI+Bm9tOsQdtGW3CijVSK/QEWj2Nt7j8E7w4xTYgV8CxndEX4pKjIljmkjSP6/m28Mw6kQT4C0eVzg8TCh9xV+3DkTwhaGr88tXnh5eBeTmTVdJZ9/LXTXYeC2yGFqf9oQQQgWf01p0GZfchLffIdJelbFgQ97eVz5hmkYRWvAIHx5Abb2kHmHiEC4gA5FmayALZJ8hs4//9XOr3tgqUle0/8bJyc2h1jPp7MFo4pbTZVdwAWx0XV7wfzQt9vYfnVlznGQ0hWqAx//J9PggyKsY7AstaWXGSw0sttQs4DVxpnt+DQ3Mlhy92/wiUU9vZkL1v3OIq+pzFw/bwsswR2G/EmWO+StxeXxy8fW+E+qKVgtylbXk99vSclajJy7/aV6ObxQbv2EhmuOQonCoHMasXuOP/q/4+OU/jeTkM1xxJE6guzLZQr5xc2naIGngVQAUYaJFqEmzgmAcSW0iDCNhxOkZQmTF8ixEV9exF4zvq0JqLdynyCve7u/CASIzH6c75R2dzr8yqs31+hBWfbpboDDXn2/N65PCOmZh18tQQqFO9/uXAjm79w/7XWCLy8TY2Owalb7j4Op9d06kqAMH0yL8AaOt7FkFySP6HnlA0Qn+
 juSdQyiC
 8mTakYOrVnjpUQeFPEsMv7Yxqo7Jju/MUIAYcq92iBP+XxhghKUJoDhPYo/n3LgNFEhl0CPZIkeKN1BEE50ijrQzSV6OlfCvh48Y448P4q0uES1DZH8I+F3w2c3yo8SGgI9uiCBunH8d28QW+2Nj+dOmMoBW5IiS6CO6eGmVRrpUN8SMKo5pBRvEKeFk+A4HqqfWcNmaCv8gSmrv6ZonMcMMIJyyq+cdFcFRv4MT7Kiz2CCXql5era/K+uooV4g8EDp44z5gQh6hiM1Z0pY24nnUrRTVDU2XVoosozYLreEi435M67JtwlwiM3o9DmTpWdz28NJZYi7cZ3c55hd8fxcUBG9y7NfapqQWnzOQGIcP5d2VclSu7INYhe1HnNaUTvWGNhQQr9BVrCRj9M4asg1HNUjJFBWj/9Q5aw1N0JqK1x0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/2/6 9:48, Pratyush Yadav 写道:
> Hi all,
> 
> I would like to propose the topic of HugeTLB file preservation across
> live update for discussion at the upcoming LSF/MM/BPF summit.
> 
> Background
> ==========
> 
> Support for performing a live update was recently added to the kernel
> via the Live Update Orchestrator (LUO) subsystem [0]. Live update allows
> a full kernel update over kexec without terminating running workloads.
> The main target is live updating the hypervisor without terminating VMs.

Regarding KHO/LUO, while the main target is VMs, the materials above 
focus on updating the hypervisor itself. For physical machines, 
performing live updates is much more challenging due to the large number 
of physical devices—it's not clear how this is achieved. I’m very 
interested in this topic and would like to attend the conference to 
learn more about it.

Zhu Yanjun

> 
> For more information on live update and LUO, see its kernel
> documentation [1], the LUO patchset [0], or this LPC 2025 presentation
> [2].
> 
> MEMFD preservation
> ==================
> 
> MEMFD is the first file type that added support for live update. This
> support was merged with the LUO series. The memfd preservation code can
> be found in mm/memfd_luo.c [3].
> 
> MEMFD can use pages backed by shmem or HugeTLB. The live update support
> in mainline currently only works with shmem-backed MEMFDs.
> 
> HugeTLB preservation
> ====================
> 
> While shmem support for live update is useful for many things, using it
> for VM memory (and other memory-intensive workloads) is inefficient. The
> next step for MEMFD support for live update is to allow preserving
> HugeTLB-backed files.
> 
> Note that we do not attempt to preserve the whole HugeTLB file system.
> We only preserve the memory pages for the files specified by userspace.
> The HugeTLB file is re-created fresh on the next kernel and the pages
> are inserted back in. This lets us keep the maintenance footprint
> smaller.
> 
> Current status
> --------------
> 
> This support was sent out on the list as an RFC [4] in December 2025,
> and was also presented at LPC 2025 [5] in the Live Update
> microconference.
> 
> While the patchset has got some initial reviews from live update
> maintainers, it has not yet had any review from HugeTLB developers or
> maintainers.
> 
> Goals of the discussion
> -----------------------
> 
> This session will aim to present the topic, explain why it is needed,
> show how the support works, and most importantly, collect feedback on
> how to proceed with this work.
> 
> PS: if any HugeTLB developers or maintainers are reading this, it would
> be great to have your initial thoughts on the RFC [4] so I can present a
> more polished patchset at the conference and make the most of the
> discussion.
> 
> Key attendees
> =============
> 
> Live update:
>    - Alexander Graf
>    - David Matlack
>    - Jason Gunthorpe
>    - Mike Rapoport
>    - Pasha Tatashin
> 
> HugeTLB:
>    - David Hildenbrand
>    - Muchun Song
>    - Oscar Salvador
> 
> References
> ==========
> 
> [0] https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatashin@soleen.com/T/#u
> [1] https://docs.kernel.org/core-api/liveupdate.html
> [2] https://lpc.events/event/19/contributions/2052/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/memfd_luo.c
> [4] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u
> [5] https://lpc.events/event/19/contributions/2044/
> 


