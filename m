Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7971EC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB2A6B008A; Wed, 23 Sep 2026 05:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CD56B008C; Wed, 23 Sep 2026 05:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDE06B0093; Wed, 23 Sep 2026 05:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27AED6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:39:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADE51A076D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:39:55 +0000 (UTC)
X-FDA: 85244530350.05.7DF7A68
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D22D40005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:39:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcD3OH9r;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790156393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTvNjfqp3vWgW6mBeOYWH0dCuJI95lHGIMwcJ+GgyDk=;
	b=69gAPtmLvxez+XJTB4cJ6apKeQ1yntWgi2FUUC+3Zbh0HbRUw1R1292Dyh9PdC8EfabrZ7
	EQGiFMEix3sM89drj29s2I0aqzgTYxrBABl/awisGikr5jKV11m/XDpHMWYVJ1OeZFJ049
	6or2wyTofdrMC3TSPhPbQZEp6Boi2YA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790156393;
	b=cy7bHJJluKEXpkJAi1yA57mxnE0upGahY9AVOv2O6LtHmI+IHfFBrExa5MSodmBBKL76Ep
	FbQ4ap+N9eoUvxv4Z4Y4yjS9+6gMXMuYHUH8rYAmoAuBnOr4jRQSelXVbiXpaODNUHAtBw
	sYu7PCkt5NqL6N1F/ZlFwpEGCjPdDfg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcD3OH9r;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MzOAhLKmbJiSI4FocgslvkepFbs+VNzpkEibZW2q3/8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790156392; v=1; x=1790761192;
 b=OcD3OH9r5GDLa1RAtiQXePDtbn32B679l5paNIzso95xSS7zE5uSQ49AcjrQCyAadzN7S+NY
 5+ZPJKTWZyRM2K1EV1GqeNtE6PTFzZG9NDvmsDPrGpVLhuL2mb2qoHmXNHGpMnc5FAzJ4Nk5aRG
 SqaDdHpDF56hmsHUtnCUyLlQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 637d28ad337e819f;
	Wed, 23 Sep 2026 09:39:51 +0000
X-Mizu-Trace-ID: 637d28ad337e819f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 17:39:44 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Gregory Price <gourry@gourry.net>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D22D40005
X-Stat-Signature: tbcmgwj5ukj4o5o5exrymst9ncr79qb6
X-Rspam-User: 
X-HE-Tag: 1790156393-467897
X-HE-Meta: U2FsdGVkX19ZNeflzumA2MiXAzBxtclUHZKHHkEJ6xa4PTgqGAg9eak3/3o1gHzdFAY8dKjgGe3frhpVonfKKBL9ts+q3BaPM2d385p5bi1zvK9RrFcH7AI+bA59VmT+VqZUsnCsSm/TjUFDCfDC1trWww97wNQVH5/ZW9Wk7cmZI6Uyt1dMalqIRcqtV0/hpEnHWePqfYQg/G0etG4hNsVF6ND9kFUV3oSd/PkYQ25hYjDW8mu9SWLSmFfh/XdxDY/c6FURO/xfm+JIEX2viak+8YvFs6iUjmwz9QeflQI4bQ0mzwSMO6LerFav2f1tGqn9ekulQ/XuPdZCG9WpVse0+ncxwXAvSsiJjCaZQhCn6NRmuwO3ZwxGjqjb+oPKJiM+plC0sYJRZns4Z+PMdOHJ4RpvDy9Tlq+EHmKov5bhIm6/tI0ClXbi5nk2BHRZMRsL2FXysGKwo/synhM6L1WEzFqoH1tyI/nBeOFlO9NUnR2uABqXZxxoTTeWHKOBPwVi5aqn1o5qmhF1SgQIkWJOGVsHz9l4zQXATVCyT6LCdk9GC46znF51TrbhRv6Jtvs7zyRewrxh5AkN7Y5J7HoCdj9mtUgu/7+J4cHhmZAM3I2UY3kH5LqqQBXMLbQlGyVJDM65Rt/6CcgHHPrUDAPBB/y0T5w6mMwDKXroWvi3X82guXWU5RRIvmOK8VVoaRP59hrQ1eHUSvuCCI1l12sfGBEd1EeqFs16cO16Z6BHyibLNiUec0Hz23e2Gi5vTyABgRo/Sumdemcjas5W+nuLffBTZ2yXljW0U1NDyEZVygqvUgISHZqD0Eb/bia+NqrnGma4OmeNawnqKATsNIWarLmUxEcg+Bs3RhCLSIDedSk7hf7a19mU4TBEnQi0lGyimHSB3rY2yUuMCEdorxuxlnWkN6Sb+sLIeTPEEmwSm2RheY9GN1JonibTe+Eh74lXnFMD/4FX26wFj2s
 /t/MFO/S
 ITys/gN4KxDuSvI+b/WQkzoBLmwr+Bl0oAkDidJ6av6ys/Lao6lnnxKsd1tOIk0LD8Lp/BVGqcNsAb2PB85lqlik/yUAL8KjPjHODLWIMLkD6i5lmEPM4j4YUuSgvXTBVXpyJ/PSM6PGvGL2xd2M42jYdiIGBAaqjgoku15mx1jCkUBeeY9u2BTJrmZ0fRX/9Aai8j7+WiRmrT/fTXMQgVGbljBT+Ovy0jAkqt2bYnLShjDpoJKBAkX4+0CjQQkj8Uti/Xa6XeTt1RTngmU5qVJl+jtYiObzfAe+mcrG78Pnz2fUJwee3WWI74Adwi7VbFTB4XIAeJ/q8E67y8i+V73bqR4ZHJdDuvTa7W+Um/dMEcPlP2c0qpFC485F51wbw/kKbjd7WgEl8QdQB+fS3pW7w5O6r/wnl8jyasEA6ERfSTBb/QcpAzsLW0eqGqtin75DrT2PKeezO6WFHao5g4w2JkF/JyiUjBgFhJ/gP4bY1QXntyzsGbGIJfFDxqMED8V0VNsb490E1LGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21/26 at 01:02pm, Gregory Price wrote:
> On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 3:27 AM Gregory Price <gourry@gourry.net> wrote:
> > >
> > > This would preserve the existing memory.swap semantics while allowing
> > > both backing resources to be constrained independently.
> > 
> > It sounds like you want memory.tiers have limit enforced.
> > 
> > I suppose it is possible. Again I want to see how people would
> > actually use this feature.
> > 
> 
> Possible, but arguably not needed. the swap and zswap counters already
> work for this existing interaction.
> 
> As I pointed to in my response to Rik, in every reasonable use of
> pswap+zswap the global swap counter is pointless.
> 
> So then pswap=swap and we're left with zswap and swap.
> 
> And I'm not convinced your reading of the swap counter as a limit on the
> *logical* memory allowed to be swapped out is actually accurate.
> 
>   memory.swap.current
>         The total amount of swap currently being used by the cgroup
>         and its descendants.
> 
>   memory.swap.max
>         Swap usage hard limit.  If a cgroup's swap usage reaches this
>         limit, anonymous memory of the cgroup will not be swapped out.
> 
> There is no documentation I can find that has ever documented these
> counters as "the amount of memory requiring a fault".  If you put a
> compression system in front of physical swap - the counters as-described
> would still be accurate, while your reading would be broken.
> 
> "swap" here is highly implied to mean "storage" as opposed to memory,
> which is why "zswap" defines its limits in terms of memory.
> 
>   memory.zswap.current
>         The total amount of memory consumed by the zswap compression
>         backend.
> 
>   memory.zswap.max
>         Zswap usage hard limit. If a cgroup's zswap pool reaches this
>         limit, it will refuse to take any more stores before existing
>         entries fault back in or are written out to disk.
> 
> If you're presently using swap.max to mean the "logical amount of memory
> allowed to be swapped" - then your usage does not meet the definition of
> the knob.  You need to justify that your use case cannot be expressed
> via memory.min/low controls:
> 
>   memory.min
>         Hard memory protection.  If the memory usage of a cgroup
>         is within its effective min boundary, the cgroup's memory
>         won't be reclaimed under any conditions. If there is no
>         unprotected reclaimable memory available, OOM killer
>         is invoked. Above the effective min boundary (or
>         effective low boundary if it is higher), pages are reclaimed
>         proportionally to the overage, reducing reclaim pressure for
>         smaller overages.
> 
> That's an SLO interface.  memory.swap is a provisioning interface.
> 
> As it stands, I'm left viewing zswap's counter inclusion in swap as more
> of a bug than a feature - they account for different things (memory vs
> storage usage).

It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
cgroup2") introduced memory.swap.*, it was clearly defined as charging
"the actual number of swap entries used by a cgroup". Please see the
commit log. With that, zswap still reserved a swap slot even when the
data never reached disk. And not to mention zram, it's backend is RAM,
but not physical disk.                                          
                                                                                                      
Now some deployments do use memory.swap.* as an SLO signal, and that is                             
real use cases as Chris and Kairui told. So I don't think this is about
who is right and who is wrong.
                                                                                                      
To keep the existing deployment working and at the same time give the
physical slot its own knob, I think the solution is to add a memory.pswap.*
counter as you suggested. And that is not something we think of from a
brain storm, it comes from real deployments which already depend on the
current memory.swap.* behavior.

Thanks
Baoquan

