Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F9EFA1FDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697CB6B0088; Wed, 22 Apr 2026 14:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648B96B008A; Wed, 22 Apr 2026 14:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55ED76B008C; Wed, 22 Apr 2026 14:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 471D36B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:00:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE7EC12010E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:00:51 +0000 (UTC)
X-FDA: 84686957502.11.C826F42
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B51C140019
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:00:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eZ6G8Y+a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776880850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsIpemUN5aladtcAqLVbV2Q/0btyI3Udpb6Wdtq315w=;
	b=mk1i+xTvDuDgeWeOzrcyPRgvGxkne7vk4goI1CTZvZUoTDxn4cs5tT22vuSixJyxWTOM+3
	+HhSWWYZQVG0eTpMTHsiuZbkZc+7ik7U+qeMyDHQDppKqLZKM5JzdB/ldNPS/li0Sb4xxT
	XJ0UpT0XbV7FChqQtcQicmr9eZcoyPQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eZ6G8Y+a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776880850; a=rsa-sha256;
	cv=none;
	b=re4y/rAFxK/uL8daPmIZYt1ycIslpasVFxbL76DzAyhvzj/viBBsY9Y4724TSuwelChcDF
	cIU6iLIhy4bgBzBv1BvCVRSOlGN0kEh1lBbyNpvbxzgjKY7SWbSaJJfAVtBYPEryCmcetl
	WEKeKRqoXMuuDdxU8ln2Xmr8qxGSpUY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C50A41E5E;
	Wed, 22 Apr 2026 11:00:41 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD2A33F641;
	Wed, 22 Apr 2026 11:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776880847; bh=ZRWId2cyQPbIGqtv5LXo706QXNfX8RgsC2E99iractY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZ6G8Y+a+3ieHINeGVnaUq5ovTQIwOFu/Ti2cVg0P+gf9INs3drkr0QbohRQSj5FD
	 lGj8LN2o45FDPFxHGNXgkMZLuZ338Y+rgujmkz1WXMe0I+fEUbnyt1EE0N/C2AtBHH
	 AfSAw1hbSSnOmvNJImz4LtWg462/igj5ij3rHBBo=
Date: Wed, 22 Apr 2026 19:00:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	david.hildenbrand@arm.com
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Message-ID: <aekMvrcBCUTf3yT4@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com>
 <adlCN9sUcQdWbf_i@arm.com>
 <adlDSiuBeSduK0mj@arm.com>
 <aa7c5a29-c8f7-48aa-b0a0-ed147d29fde4@kernel.org>
 <aeHvzh3A0eC-tds9@arm.com>
 <e881c79a-fe7c-46b1-a518-febf7a278cc9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e881c79a-fe7c-46b1-a518-febf7a278cc9@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B51C140019
X-Stat-Signature: tdq6xkskotsid5whzy5khu3hbkjueb4p
X-Rspam-User: 
X-HE-Tag: 1776880848-806371
X-HE-Meta: U2FsdGVkX18onfPNUsyOU83r8qYH+ZoebVvTiG+ykRr8u3zD7tc+hfAx6XcrlVycfemS7rLFek/jNAirOOMrU5OoE4n0g1WrS0RjkQsXyXwNipnvDxiy0Pxi0JBIk7Rw3P56xKzbeC+lX+MBy1KIG29pR4sPhjV6gRZbQWHsdNdOkvGMF7yR5qjinVHfVe2R1hwQjOYiXb4B5DTd5+NZQW1+2ha7WeGqBoLVWA9/N4q+F9FdPnFzhdXpzkbPfa4px/6B8JUbiOXPeJO7jsNNq63tcIErL1eQKik0azjcIA6SXiB6coXLWpHeB2LCmu2R3PQW8jCfQvA6C29YnTbD75BvG/ctXwuIPb3yq7JEwhoUN24i8YjdxNAJw3BSzjOydjb7mYxGnpgqrKE8eS3p/TQnFg8hgxFx8jfVWQPr9PwKQfMEBIktPFTTPZ374LrzsU3obCt41fqB2sfBPhYXlKALihL8BvV7LK5r9UHg8iXNUt/7+iRxYhA/gKz/fQGZ1g2A9h7c78lvBZ/avzLuz/HXZca8BG34/7hy0ZTtTooovr8pz0YDSZVbNYM8vi87krinTmJlHnUpQNXohGrRAHBzxT4H2aSCZThkv0RQ6mV4hApKmvPUDXKsJXCbL1FQYyhSNHC+1YEJfiNZvI0/kG7HDDYwKC3mu7++/BgDRAIs8jjr4Wlca6U3OURTt88H4ZfvGmFiz2tTEICAhGBf5UDVzs5Ea+zli2TiZ6CRPYr/hIcU5suewTUPTh/4713LfA9D67d2MwTEcS5NBR3uqBMxTAL2orcyLAHV7O83dYqMBtGgaxozXkY2mwRN2qR2NcjGjdIlwK8TKgfyJM6CcfNCjYWi1ge1UABYUC8naz84PkXo6M3Jo1ixFHXCEBwHCjo4U3OmsHGNJnxdQzqaeXzdV880pAeuTdCYx5IHNgEBGzCUSJV64rJZnqyFp1FmIvpH5+Bo2z2hzwco5ig
 NKnYfSTn
 /pcd2rCEym3DtWjY/0OS8TdSlb/DNDl5uufKvco+inzPbOzKlxTeE0ksVBM/B02cZtyS1utbNTdXqmItgEk/e1jQ8o7KYvp2yvgtvKxZYycivm5+vWrlIhRnOxPlOXoUyMMvmtamtkM5cmc4UoeSZFDphDNkQddEEBRchSetbMjk5PjME05vM40mwS/zI+hbg5FFjSQl2EOBWhH4xJYfVts/Ah7PwIcLxXbc+NpqT88GiY1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 02:31:14PM +0100, Ryan Roberts wrote:
> On 17/04/2026 09:31, Catalin Marinas wrote:
> > On Thu, Apr 16, 2026 at 11:03:46AM +0200, David Hildenbrand wrote:
> >> On 4/10/26 20:36, Catalin Marinas wrote:
> >>> On Fri, Apr 10, 2026 at 07:32:23PM +0100, Catalin Marinas wrote:
> >>>> What the original approach might help with is use-after-realloc in case
> >>>> we had a tagged pointer in a past life of a page and it still works now.
> >>>> Oh well, that's I guess for other types of hardening to address like
> >>>> delayed reallocation.
> >>>
> >>> Another thought (for a separate series) - we could try to map the stack
> >>> as Untagged (unless stack tagging is enabled; needs compiler
> >>> instrumentation) and enable canonical tag checking (newer addition to
> >>> MTE). This way, any stray tagged pointer won't work on the stack since
> >>> it needs a 0xf tag (canonical).
> >>
> >> Do you mean mapping it as Untagged in the vmap for CONFIG_VMAP_STACK or
> >> also as Untagged in the directmap?
> >>
> >> The latter brings in the set of problems with direct map fragmentation.
> > 
> > Just the vmap, there are a lot more problems with the direct map. Not
> > sure how much it does in terms of security, maybe marginally. A
> > match-all tag (0xf) would still be able to access the canonically tagged
> > memory.
> 
> I think with the first patch in this series, we are alredy vmapping the stack
> memory as untagged, right? vmalloc only calls arch_vmap_pgprot_tagged() if we
> are not skipping kasan. So I think we already have this protection? (perhaps we
> need to explicitly enable the canonical tag checks?)

Ah, yes, good point. So, we could just enable canonical tag checking so
that untagged memory only uses the 0xf tag while in the kernel (not sure
what might break but in theory these would only happen if we have use
after free bugs etc.)

I think it's just a matter of setting TCR_EL1.MTX1 but it has some
implications on the PAC bits. This setting would affect the kernel
image mapping, modules. Anyway, something to investigate separately.

-- 
Catalin

