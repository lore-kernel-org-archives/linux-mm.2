Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5ADC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C504E6B0096; Tue, 22 Sep 2026 10:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00D56B0098; Tue, 22 Sep 2026 10:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16286B009B; Tue, 22 Sep 2026 10:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89B916B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:43:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1494E1204D1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:43:23 +0000 (UTC)
X-FDA: 85241666286.26.EDF30F6
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf28.hostedemail.com (Postfix) with ESMTP id B65C7C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:43:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jbh2KfAU;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790088201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whH5M0KrIKdPPGlwDiRgGwjtfCCV6waiqzkvZNAEFW4=;
	b=WBjGvlArUOmln12HABRQdHPwbmN9TkxhVnZlUAQg4JUSTX+tyt8rdw28oIw5eapvKzLlXC
	DWEbKa0JNtl4HJ+d2HxVsUMlB1cAGI04bTQ1bCJIT9hm8Jc4MEt9xy1QIxXMG0LIfEkK5t
	zL64aExcrqYUNbZA0+6V6Br6yLdgcZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790088201;
	b=hQH3Mz/mVvkaGVDOy0ogqExmOwLzUC04qNcBRkRdSZGySFiOb/xe7NeSfmWzBcLG42xa0i
	s/s2V20+fXn3aw3HJCFnlSL9iQxUHWPHwqyZwblMevFsxfRgqOB3Nv5kRvepM/Vpo+2Jnc
	76HCzw7vuDbqZYmDwfqzcxbp7SYLaro=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jbh2KfAU;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1XVpomz+LNVUGmpQ0CnnMZuywBPQ1iz7wasngwgLM7M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790088199; v=1; x=1790692999;
 b=Jbh2KfAU3CXTaa23kHQngeum45/Mw+8mcTxDluoAlJHP6valLhIKF+dQNdM84rqhSC8wBqsv
 1W4LL5RYJuJS9bSngMj2LWTzTkM7ZOeVHFhOm9E9QfFNa0RwO6WsXwTphVsjqvrtsFiF31Wcb9k
 fokZ9KTR9UEPuq2LH4xX/MAc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8d71456352f15a08;
	Tue, 22 Sep 2026 14:43:19 +0000
X-Mizu-Trace-ID: 8d71456352f15a08
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 07:43:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKRdaNEaKvFOtMg@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: rde5wktua9q6t69hosm15qbdajg5cfzc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B65C7C0006
X-HE-Tag: 1790088200-118390
X-HE-Meta: U2FsdGVkX1+b4vu4PfqMjb8H+wNAZ0uL5hQI0d7v4t0PwbRjDIXX8oHilxO33ULq9Qo+9vumlRCCB3A2SNMbU3CThbL59z8cpn8WK1oyuoakFXPa1EERURDWRD2StGuxENLZeGapBHnjmb/bQBqjt1KxD3lJX89x070+8N8/fcymw2/2ZwUEd71nRRUr/wjskfZ48QhOqcxGQx6Omj2WBShW7MXV/J87EP1Gz4/orzZPtE/Rd3iJZeO6GCPl4d0QpWbHUi0CIOrUYmPIG6aoYQhGXLAbWloBU8QOyKZOXM3qv8rSi5ElZMQkadEYdlaF0xp/xWPECpbdkexva78YLXRVnDpkJ0I+Eh8EPThBzFtGJgNPaKV0LuH3xiToJc8yEUgIaGOMGG2lMk0WoSaPlFKb1Vtv/DCYQZ2cM97Nzeib7Z+6rLLWeb+VZnk436HC0uR+G54BbjPs5EpnAKe6OoJGkpuIjhkA5lYQhjh34DQRXY1hjRijXOgktuJEPvWb+wDmCDNR5GuEkGdeAuedxFdY5QHN0Qo2O+m4/Z7P1Y8Wb3Zkz0WNRXwloFvu8MBk/VuWwD7wfT4GnJkae7/nKWWULL5iNBRFMdkC7zICXiCDKIMDRmhdNvc1fM0yhvOgNywW2IDFthK7wsVGIp7OYOp7vr6n8sec1NL9Rn60Eip+qn/SJ1WXdapxcPJ484AzQu2C+uCQigZ93mCFJUyfbxdyZOQrgsbOY1004furATeTiovSvpe22lTIp3abh+PS1IRTzWmxMaJVxzbt+9wUJAnYKjN/ZalL0Sl57e0/vEX37arQT/UScPRbUcGUFq+joR7mr2ZielTO6+TKYyf0lBswSnhZ8n/9M33IKjAF3clSFTzXP2CZ5dGuhV3hfZDh/O0bB06PvYFKGK+rMQXBtwBkAdl/FydY4wpqDhsn/FGiIfyyuEsyKkYPzJlkf7SW8S6Be1Q4KHgZj7wee57
 1s/D9Q8p
 8s+9IPiOxw4yD1YOqbytLJoqyj6MMH9fmga/AwEFbQalP/6RZE8NBes7kveKARLAUNtcoCfxQnH3YOOouwWVILeZuj5FUHNLMoftrVAb96ZDzYgg3NBifNZZbeizSBMbcAGsWPv0Zj7dzqSeSsOioBmBwSpTfpKhz589HOARygRF5Ma6skEQtYPhvMvLXAv2MWmcPpeK5oJhpWqjFHt/aeBUsO41TrXrTLhh0kpJYpQD+zNIDjhn3f+vsIz+Z4Qz5e/x2rJ3njvPs1QUTSV6BMe2hoAwCeMGFicLbpOtMKf1jt9CteBXIEEeaBDgO4WaOx59pEOze58ITvE4wnSTRL6FqzctnugN0/SJyF1+HWlSZ0dRhk0pBlO+2/OCIb7LN7IDx8G7NT0jhQUI7AM2N+UUxgDLUCIShcprIjr6JVbJeaw9V3g+p3abua1EF9Ey7HB5GmWapBPeeIh348kvDLuUq9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 03:38:38AM -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
> > > No that time slot is too late for Asia developers. I don't think we
> > > should use that time slot for swap alignment.
> > >
> > > We should find a time slot more friendly to Asia.
> >
> > Any time slot would have that kind of problem. We're spread out across
> > the globe.
> >
> > Let's just use a standardized time slot we have for MM alignment sessions.
> 
> There are more swap maintainers in Asia than in the US + Europe, at
> least based on the maintainer file. Please be more inclusive. If the
> alignment is done without key stakeholders, it miss the point.
> 
> Sigh, we can't even align on a time slot.
> 
> In that case, let's keep discussing on the mailing list. At least it
> is accessible to every one.

People can speak for themselves and suggest other time slots. You do not speak
for anyone but yourself here. At this point this is derailing the conversation.

