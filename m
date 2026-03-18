Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D659107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1656B02FC; Wed, 18 Mar 2026 15:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A823D6B02FE; Wed, 18 Mar 2026 15:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9980F6B02FF; Wed, 18 Mar 2026 15:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 875826B02FC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:56:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DA7356677
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:56:04 +0000 (UTC)
X-FDA: 84560239848.03.FC6C260
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 659C2160004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:56:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nkNHq1UK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qn28qcTqY23acAMwPqY5EzcQaQiRCWYQzB9ll9fxjks=;
	b=Sxrz+bhLtu3iyoQm7M+7x3F8oXWF+kwwCLtY/SgdyFAz9uLRGYxUuPVazq3vPH5AEsr8XP
	eZYatTv3y2m3r7J+EPkuscOvOuZ0Mld6xe4B5nw3wl0oF12nbSHKCCwgliYtzXAmozFnPy
	v4Qgx3NSA5X8DMAxry38UJE1Rc9egvA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nkNHq1UK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863762; a=rsa-sha256;
	cv=none;
	b=zhtGDj9hF3JW11ooc7GEF784HVlWp5aufSwHKlTL2TzP3yU3o3zvE9znxNrk3LkVb/KKBx
	bKe2xYkwcA7NdfV3MQf+A2ctz9PcMZmdUsJ1DgaIWZoamUE4CCZHttC/N9wo/OTtUfJG/K
	6ImnmTeLKu6yltC0120h+M8mpl70Hzg=
Date: Wed, 18 Mar 2026 12:55:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773863759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qn28qcTqY23acAMwPqY5EzcQaQiRCWYQzB9ll9fxjks=;
	b=nkNHq1UKY0IObCr6MXOxnFOXYvZm2QkeEXwfwhyKIOC/nQgOgcRJ1odex9tA1LmOyv8J3N
	0HD+6PaSAg+JNu+4lj6sN6Z4n301cAV78luQjzQCHIjT6m9uBa6nSAjjkQrlKWWU79Op3h
	xe4ADbiNKxzt7MtIJ/uQwO/4G8zuo4Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <absA_ryDAnfaKJXC@linux.dev>
References: <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
 <abpue_k_9mjQAP6X@tiehlicka>
 <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
 <abp3-iJbazCpygIm@tiehlicka>
 <b9ceff32-1f8f-454e-84ce-b8788b3a4952@yandex-team.ru>
 <abqQtcNqxzxiZyf1@tiehlicka>
 <fd7409a3-5f8c-492b-836d-559b001a61dd@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd7409a3-5f8c-492b-836d-559b001a61dd@yandex-team.ru>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 659C2160004
X-Stat-Signature: h3mr457grwap5xwk8j4mysferat5q5ha
X-Rspam-User: 
X-HE-Tag: 1773863762-445914
X-HE-Meta: U2FsdGVkX1/euJZKkpPRYtr34TrmyRrgLCuEWvuSkv3l7oCOZdhGhqQW2seG6i0dYbVXFLI29Dga/YBfHKU3CFD50vZe3tC087o8TVL2K3Go/NWYwLAvAVrSY4BTX7mvg8HHKJegB/Ir0XlbsqRXgenM72LhM8jKnADU1LbnpMXpf/UTqCqsi6MyH2CcNCInbq1PDVgjWutE6oAmp9SKsSe1QQhBTO82j1PpcSEz+CpG9CWmkV7qH4z+v8/Ku6htxmPbHPfZ0+6Kikd5kY4aMEk36jw359UW1y1LgBDpa4mwq/py5IIy/qaANa16rHWHZe8XJ2K5oJprc5iPTHAPguEYBSFzsWbPC8smKyQI5kV3JOb3F1rln4j3RYvqUyQ+d+zNlV+NBavy1I2RSZyCVAmY6gBwm5xVTG9CvWjisum7V0BopYcDrrc2b5bwwKAj4REREc2ETp2h1KHeLd9djhPuua+jn9ePpgKYBBlF44aOlImrm1Pa18SpXE3uNkdVG13PU0+7fAVMQ7X9oQJpUjc4FgWUZH1QCFXheWFZxuFcTFg3BNeWuXwh6nS8adwlbCOfj7XTYqG5pv87X8Op3yvan0NHzbYhTBt2Z/dhylRzorzxc0nBZPA78ErN0M7t+rXnPfHNzDbC98GUQGaVSpxdtIAv1VgAbpVnPUIUSsFBCqu259RG8UJeu1uFYA2Q7LMfJ3M7238LrnFQtNmodmmcbGjn2hRwzhe3bQ3yBI8iktQgn/NApyCo0YAqzXmbYR7raIsS9fsmLc4SSNb/YcSMp4qqGvM/m1ew/abICkwd8LM8+kpbNDZCO2rExB6cBaZ1rf7e7TlNT21OHENz81GQakQQAI53Wkvx4rn32MuLAmVAw0Dro/44qHMHtoNuaHIw5vxk80x0dE3cOFW8a6heiCojupd7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Daniil,

On Wed, Mar 18, 2026 at 05:03:53PM +0300, Daniil Tatianin wrote:
> 
> On 3/18/26 2:47 PM, Michal Hocko wrote:
> > On Wed 18-03-26 13:08:31, Daniil Tatianin wrote:
> > > On 3/18/26 1:01 PM, Michal Hocko wrote:
> > > > On Wed 18-03-26 12:25:17, Daniil Tatianin wrote:
> > > > > On 3/18/26 12:20 PM, Michal Hocko wrote:
> > > > [...]
> > > > > > Shouldn't those use mlock?
> > > > > Absolutely, mlock is required to mark a folio as unevictable. Note that
> > > > > unevictable folios are still
> > > > > perfectly eligible for compaction. This new property makes it so a cgroup
> > > > > can say whether its
> > > > > unevictable pages should be compacted (same as the global
> > > > > compact_unevictable_allowed sysctl).
> > > > If the mlock is already used then why do we need a per memcg control as
> > > > well? Do we have different classes of mlocked pages some with acceptable
> > > > compaction while others without?
> > OK, I have misread the intention and this is exactly focused at mlock
> > rather than general protection of all memcg charged memory. Now
> > 
> > > The way it works is mlock(2) only prevents pages from being evicted
> > > from the page cache by setting unevictable | mlocked flags on the
> > > page. Such pages, however, are still allowed for compaction by
> > > default, unless /proc/sys/vm/compact_unevictable_allowed is set to 0.
> > > That property essentially "promotes" ALL such (unevictable) pages to a
> > > new synthetic tier by making compaction skip them. The per-cgroup
> > > property works similarly, however, it allows the scope to be much
> > > smaller: from a global setting that promotes literally ALL unevictable
> > > (mlocked) pages to this tier, to only promoting pages belonging to the
> > > cgroup that has memory.compact_unevictable_allowed as 0.
> > This is clear but what is not really clear to me is whether this is
> > worth having as mlock workloads are already quite specific, the amount
> > of mlocked memory shouldn't really consume huge portion of the memory so
> > you still need to have a solid usecase where such a micro management
> > really is worth it. In other words why a global
> > compact_unevictable_allowed is not sufficient.
> 
> In my opinion both mlocked memory and non-compactible memory have the right
> to
> co-exist on the same host without a global switch that turns one into the
> other. I agree
> that it's not a super common thing, but I still think it can be beneficial.
> 
> Some examples include but not limited to: security: so that sensitive data
> is never swapped
> to disk yet we have no problem if it gets compacted and the actual physical
> page gets replaced,
> performance for some apps: so that we can e.g. memlock a large binary in
> memory to keep it in
> page cache and improve startup time, but again don't care much if the actual
> backing pages are
> replaced via compaction.
> 
> On the other hand, some critically important/real time applications do need
> protection from compaction
> as well on top of the regular mlock, so that they have predictable latency
> and response time, which can
> really fluctuate during heavy compaction. Both of these cases can coexist on
> the same physical machine.
> 

IMO we should actually deprecate compact_unevictable_allowed and always allow
compaction for unevictable memory. We should decouple the notion of mlocked
memory from the pinned/unmovable memory. Pinned memory has much more
consequences on the system related to fragmentation and availability of larger
folios than mlocked memory. If there are applications which need unmovable
memory, they should request it explicitly. I don't think there is an API for
such memory but for such use-cases, it makes sense to have an explicit API.





