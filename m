Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC31CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CABD6B0005; Mon,  8 Jun 2026 17:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2716B0088; Mon,  8 Jun 2026 17:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8396B008A; Mon,  8 Jun 2026 17:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE346B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:03:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4B4C1A02F3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:03:45 +0000 (UTC)
X-FDA: 84857972010.09.3805BD1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71A001C0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:03:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KyTogdYk;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952623;
	b=gadFg7aK3E/+CqHnNT8BZTcsuiTMjdVBssh5nm7NmBHCET48fOvKM2V+uLKxLqR/6heV/A
	NbZlinkWgn/7YFcVBPh8V8TPigJhfPMHcerf8TEbiI46ItMTzMa7K7tI3bc5pS9SGEwyeJ
	7uxQvKnxgalsW4tg6HEcvWufDVMVnk8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KyTogdYk;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPKXt45eBuYwq4y81CcQcHJA9vR4mX15BetGx3tuktA=;
	b=Ux8K1AmvZMGXiPZeaLQEb8qc9xgKhFYDed4Qiw+JZeSrXoyJZZhhcVTxaaZCe8eobSHjq6
	zT79h41oGIT8ObR01cXxTHLL0NhKLO55505hGhqGg3zoTBZMwjVBAQUYXijyALSRg7QEyE
	cnTYJImoolaZjguPT47aUzqsN+koOVY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780952622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yPKXt45eBuYwq4y81CcQcHJA9vR4mX15BetGx3tuktA=;
	b=KyTogdYk2PdrXT6EXhR6BfxEbYbYMnuhgMJRzvhZcH36lmRhnPzs74AIazXB2FvDvAohdv
	fCPf4fzgmmfWAiBUrMiXg0IoKoYu+800CvX/Wrfilu10BJDW6wDhK3+RutnBta2wOumTbf
	2Ll18XelQEE8J2rpC4vn+aV6jskRU/Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-lSrSjOR5PkOsTy01q_dtCQ-1; Mon, 08 Jun 2026 17:03:36 -0400
X-MC-Unique: lSrSjOR5PkOsTy01q_dtCQ-1
X-Mimecast-MFC-AGG-ID: lSrSjOR5PkOsTy01q_dtCQ_1780952615
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45efa7755faso1791511f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952615; x=1781557415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yPKXt45eBuYwq4y81CcQcHJA9vR4mX15BetGx3tuktA=;
        b=Rc3ObNMo7Pts1W6AU5bPYtIfmS/FFEsTujY15Oj+6m2Xi+kOnQWlX6xHUKef6yttw5
         87hRDl+koO+/Imi2uUoViW9LPR+CuMnYUzqKSB4x/1a5RZscnuQvrrUnGLlxGHOQ8Xzs
         xXJYX6NWNMpp1edehCBqy9UQyrNHUsamVXtdHWrxz4Z94LlaAxqTgzlIrDbziLjNyuXL
         jy8/+sCPkMfUbZeUpvuf4zuXiriG6+A8ELbI78E9XEOwrHudp6opS0vwmmDYc5zrCP0j
         iYg6wf1bMizXL1w3zDj4yX1qASdcoT2Q5j/ST/do0XIdTEK9MTr0OUXEPzS3eCHHCbiE
         OkLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8l1TryIdUtMSvvUbeaBvtqqceLqZ6FIEAQ+7zoQWo3LbWIku+G3jmVyd9QZ2l7OSozyVrH9fPwKw==@kvack.org
X-Gm-Message-State: AOJu0YyqUmZILm4McJRjFTR5F1EEaGrfXclng6ig2/75StckoRzyXK9+
	ht9Ry0ru2svoUXFnYhhLwzU4kq3o/Bf9Ijp4LCqiXn/jLGdPhcB1IsqNsuOvEOvXtsopWMRYZ4s
	LOOR5lSgoKfTiiMf0Uxuo63EmNEZsoPexHWEyLJCJtn9BBV2qcrx7
X-Gm-Gg: Acq92OGDLkvmgnhq0Of/HX4RvLVAfjDRQOw+DdkEuimU5DR9mQ4H6DhfJTxz18KxLNV
	wh34RUTaq4160B3V3XkWHVT7EhqbjsZvs+nSX+feDazDlA2N0ujALnVZ0CZ3Zo2Gj4/FdPkuiPF
	Jg6qxDHmk7mxWEx2zXQ/KesFQnFOyU0MmwO9XI4WVRYQXklwZgbBJ277mgavGEx8mlWY7UZa93/
	qn0f14/etd797F8yfSNedrxLl4SwIzUT/E1u0gMfuCZvMbFALjijBTokmTAqMQVdcYCI/rngIam
	yRFV6E97e6Ozmk0i+z4ZzAxGnHE+xiRa+sHGzZ0B/xgvVa1Tj6cFxn8retJFP7CP2omkmEqqQNJ
	Mh10OlE20lg1q+PmDCICy+MnR7/tI1ETg3nJp7q15YVk3RZ6Sg8IVrQ==
X-Received: by 2002:a5d:5e08:0:b0:43d:77a8:3baf with SMTP id ffacd0b85a97d-4603062bc2amr28471141f8f.32.1780952615065;
        Mon, 08 Jun 2026 14:03:35 -0700 (PDT)
X-Received: by 2002:a5d:5e08:0:b0:43d:77a8:3baf with SMTP id ffacd0b85a97d-4603062bc2amr28471102f8f.32.1780952614599;
        Mon, 08 Jun 2026 14:03:34 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm58735162f8f.6.2026.06.08.14.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:03:33 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:03:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260608165819-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
 <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
 <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
 <aiclJGgB07L3rV-P@gourry-fedora-PF4VCD3F>
 <D754DEDB-3A3A-4F6E-BF64-79086F0A6467@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <D754DEDB-3A3A-4F6E-BF64-79086F0A6467@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z_bFESLv2lZUjLH05Ia5qX3y-0ooiqKeDRtHIgeGU1g_1780952615
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 71A001C0002
X-Stat-Signature: af17374tdp3httgkbf6k9yg8gn6ocgt5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780952623-494619
X-HE-Meta: U2FsdGVkX1+PuHdMr/2+/77QaMRZi5UW+WlAGW0iNN0Xd15o0ibyKx28u2jXMb4AP6wRPVOzJfGrkiLt30oay9N+BWJ7KhMCfomTLgnxN09KLxiF9AKActE/nh24EYjTviVGwRuE+3Y6qGf0wzwdALjGzbje/q/CMysgx1a37/B/D7bytilU+4W/dizVdgfJKxiqBHCJmrMQxfZgbpXfkByY1cgXUnnXASVkOacGb0vxj1bTQIT8zgcDC4EmpJ3Bou2Rvui439NrBm5vxFr2glmiHpJK3mU43cVmIpdR3hIzqssgk2lH7P3phMYCMw/7gy+kqAiTRwmqxa0kfwz25PEiX7/9Zecko/uz9X1fCP+wftYk0ur6yldN0E5MtheDzKNmd+TaAkYpwLaP3lyrqj85hTTRma6X4dpQh+gXxBoS2JuhOlCerqgiWP7qtsj+S1NC3mwViClY7cFBy92Z8RKatjl0ML/GgU+CZcP6whtXPDLhnFTKNP1DQNYZJOzgrvXR10tLpU1Wqe1XKSkIrbUrLxIBK9gz9hQabtncGG4q4tP+ic/pCANmstfTl7CPk8i5bl/FOle8nyf9Qg/t1JlEAVFKSHP9rGBEttISF2R0PjOc2XZwtL8kMiF3EtyjNMkmku1+1Y+1GzSxY51gIyQocgvIoH/EuYxDuXLsailOE+pCj2AaLaetOd1+bXPBF6LdGnIvm5+qfBE6S4AFn15EhajnSjNHdMNXx6FRfAay27rkPVcKsq0OdRreviv2uP0D3V2MNosRLisu08s5xn0Qk2wNRi5gs4sKiFhMPmKOidoTSyaWrrSShSHzYMAKfpXwSWi0DKIO4UXCEergiimQCDN/NioF0hAwPhLVXgjKosajEgPsdCpDphehIdrVDRPd63XB5IFtoWrH2+vHNl4gOXNvt9AUsmybBWdLLmqXzZZgIDENJNPdPBhHxxe3/7GMJa0AezZaRfi2uK3
 OKfC1axo
 OvJc21pzLhLGpvJpEjHgq1AROOm1+sxiyCNyBLbZomRmKqjbvJgVPqTt16+sXptMjXnAFf8Fnlv2sgZ78tQQYICLBgr2okVwkzDPSnV8bbvujfRngcJzvfqEwcSgPgFOT8N52rWEvKtIk26bT1E9OjXwnuwRFjp536wpjXanaoqxN9LqC+Q60cKgZ4RLS+ky0G4ZS/Ts9yJRjuUi8LQfPr0zMxqKGGEQCNPr2+UN9ID0u5mG9c9n4dx00JhqeYhDM9hQ7PApl0+m+Eq47QLnKtCJLpSv/kX3FCI7WaWgA57/UBCB+8r2DUtHRi2lBb/dOVtR7pu9pAOsLZSVaury0mFTVcXCEU6aut6haIe/c4qbpuSobsgavpco5IHeYsfZxkpQZMNezX/B9vqkP8/uHdXsiIR75luc2GS9s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:59PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 16:25, Gregory Price wrote:
> 
> > On Mon, Jun 08, 2026 at 03:52:20PM -0400, Zi Yan wrote:
> >> On 8 Jun 2026, at 15:43, Gregory Price wrote:
> >>
> >>> On Mon, Jun 08, 2026 at 08:39:10PM +0200, David Hildenbrand (Arm) wrote:
> >>>> On 6/8/26 17:27, Zi Yan wrote:
> >>>>> On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
> >>>>>
> >>>>> Or should we defer zeroing after a page is returned from allocator? So that
> >>>>> user_addr does not need to be passed through irrelevant allocation APIs.
> >>>>> Something like:
> >>>>>
> >>>>> alloc_page_wrapper(gfp, order, user_addr)
> >>>>> {
> >>>>> 	page = alloc_pages();
> >>>>> 	if (gfp & __GFP_ZERO)
> >>>>> 		clear_page(page);
> >>>>> }
> >>>>>
> >>>>
> >>>> Not really sure what's best here. I think we'd want to limit the lifting to some
> >>>> internal API, so it cannot easily be messed up by random kernel code calling
> >>>> into the wrong API and not getting pages cleared.
> >>>>
> >>>
> >>> We're a bit in circles on this.  We discussed explicit interfaces a few
> >>> months back and the trade off was:
> >>>
> >>> a) add user_addr to the existing API and cause churn
> >>>
> >>> or
> >>>
> >>> b) add special interface like above
> >>>    increase the buddy surface
> >>>    leaves open the ability for users to get it wrong easily
> >>>
> >>> If we forget VMs for a moment and break this step out separately, the
> >>> core question is whether page_alloc.c is the right place to be calling
> >>> the folio_user_zero() or whatever it is.
> >>
> >> page_alloc.c calling folio_user_zero() is fine, but my question is
> >> whether we should do the zeroing inside post_alloc_hook(), part of
> >> allocation.
> >>
> >> What I propose is to lift __GFP_ZERO up as much as possible,
> >> so that most of allocation code does not need to care about it.
> >> We do the zeroing right before the page is returned to callers.
> >>
> >
> > essentially we end up with something like
> >
> > alloc_frozen_...(..., gfp)
> > {
> >   folio = whatever(..., gfp);
> >   if (gfp & __GFP_ZERO)
> >     folio_zero(folio, -1); /* don't do cache flush part */
> > }
> >
> > alloc_frozen_user_...(..., gfp, user_addr)
> > {
> >   folio = whatever(..., gfp);
> >   if (gfp & __GFP_ZERO)
> >     folio_zero(folio, user_addr); /* do cache flush part */
> > }
> >
> > The downside of this is obvious: it's easy for developers to get this
> > wrong and call the non-user interface for user-bound allocations and
> > miss the cache flush (that is only needed on some archs).
> >
> > Not saying that's a deal breaker, but it's something to chew on.
> 
> I agree that misuse can cause trouble. But if we do the churn approach,
> what prevents developer from doing alloc_frozen(..., user_addr = -1)
> and using the returned page for userspace? It is possible the allocated
> page can be exported to userspace later.
> 
> BTW, that cache flush thing is fragile even today,

Probably arch dependent. On arm32, I think if you miss the flush, then
PG_dcache_clean will be clear and then you get a perf hit but
it's still correct. Didn't check others.

> you probably can
> do alloc_page() + vm_insert() to get a page without doing proper flush
> and export it to userspace. There seems to be no mechanism to
> prevent that.
> 
> Best Regards,
> Yan, Zi

Because maybe you want to expose data to userspace?


-- 
MST


