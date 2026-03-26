Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0E810A62CF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C826B0088; Thu, 26 Mar 2026 09:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844976B0089; Thu, 26 Mar 2026 09:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A876B008C; Thu, 26 Mar 2026 09:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66FC36B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:42:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 019048D15F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:42:48 +0000 (UTC)
X-FDA: 84588329658.20.D546355
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E6DC51A0016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:42:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kV5ljdU2;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvmTvbVmObL6MMPWQihLKJYeyHCKrXJrr2lSI/8mvnY=;
	b=kZAjIS1f9hbrJljE5BOF9GgEtx4lOyj4YacTyIx3ENHHVFSUh8CrSQh4LiYD3s9tLH7JK1
	kuqhJGudEU9CIcr30xhq6dy13AoqRD4y3i4qa7/9QwWWHcI2m1Zy68t0Uo18X307CxWcXM
	A+9HkLT2FkNkYP8GKqC3uYAvAoxEI94=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kV5ljdU2;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774532567; a=rsa-sha256;
	cv=none;
	b=buAolj248MAj4NS26Rg+5kBGjYMD1/XxIUE8Bo8GYAMB9OoY1wYNasfaTgqR6hOLX38QNo
	vUo+T1xKrEhIfcUjQTlsb/auPiL/yDa8ymAtQJDeaEOurnZdyvPTq43rBekANjAQ/7HR4Z
	ko/fjsUeAjkwvBA8BlXHMgjLu2XgBNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCC9E43305;
	Thu, 26 Mar 2026 13:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4449C116C6;
	Thu, 26 Mar 2026 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774532565;
	bh=aqeaVyOgj2nhbWGaqNG8pdXcUvJ3CJyTuuyl/s9Mc8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kV5ljdU2Wlclco25t1YBWfkmbtNb8y5Yi56M5iUA09lTbuQX6gK8atvoEY3qoPku/
	 UVfi34mtvWbnQ8f4MEPq+UdWzHEcHVC3df6ldOkrnV8We3h2oGHjGobdaN/B0fjgDD
	 kz/x1kP7/HtIcvP9AmZZtDC8Q5F3naLPxqHX1Lzn+m9CSuYCh/4Y/BBndrfQbvpwD+
	 8MCfggugpwG93/9MBrNYPJCKTEe98O20LnYwgTWLagqtpDz8x/THLxcYaULLgJ4w6a
	 CTnat6u3U+wX98CDuB6VZjqa03cbOOYuFYUwtO86iQ+FNIVAcyqJjMZ+3ZU2Jafx37
	 kqFy5mXfAEDkw==
Message-ID: <b340e43f-2e08-4a77-8176-e49667387e85@kernel.org>
Date: Thu, 26 Mar 2026 14:42:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>,
 Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>,
 Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
 Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>,
 "T . J . Mercier" <tjmercier@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
 <67f1588e-a094-413c-9746-9c28bdf6cc56@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <67f1588e-a094-413c-9746-9c28bdf6cc56@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6DC51A0016
X-Stat-Signature: qaysqkhuag6xdatnppjhzi611zct7a1u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774532566-322238
X-HE-Meta: U2FsdGVkX1+qKY5SdvH/eD7VeKzEGG90J9Z97sPrQod6Qq12ciNvtTR1+VvkUSXxhp3s5l4LfoAuDfeJRC/hhHDEad4kQVLY6v/iLcKbD7DCs1jRdX96TaifVpsIHgrW+yyrvifj/fJClcS1kCZBNPaXYL3buOdNSkW8MYrDEoqWAXvvegYWX/rGFJL/3LSTR5yfyI64BOZwShmLJ0DD200Mi97SpIrOQVYUk/owZM4RTAzzWjiInHw4SxO6E/QUdreVPFy7UgUsq7LM/ZcfQ4RyzlOeLN2d+6OMlFxDmUchmMPfF+sxFDJ2ITJZS6DDyfRKF0KSZw8TfWSqm//Qu5soSBe/S6QoQU7FjXeu2GFkRgn4RZtOfrzkcUmRrpcZMf0ShMOTDvMNsmzViNITaVfGHXUZ00D6HMfSc2ZNt5zNoJ2aO6z6B+pOGk2jX0JdX7vbcPmeYoPivA0Tj2aZHUYURdgYYm1kbb1P/6cd0Obi2qbxVyL5N895ePFi2fzuLmho6jyvLHLz44wjKAoVK1cy6yvvl4/FxRHLlDEHuuWtUOHIbEgGEemf/0VobIyk+eTwgeokmO3j/saTi4FmMfjjdfv+Kg9gEQy/JX7UdryqpFJ7ApxZSQao9/XmftqB783zPKkcsz6TlINAwb0vxm38t+38SqOta+98DExfugRidkFxBiVZJEzNunClrsqNkOyKeSFAo2ZO8GyiJW/Db/QsFNcfnecj1o2tlLq/K5076zkRihaKSP8lC0650zzwAc0mV8NRj2nHtVNTOg28pxoKQm0wllr3SBAYqbZ5mpuqf/foiiyJKrj9H6cOCauwh7V1NsVH4r9guKSr4N8nKc8esKv17lvm+ITslpW8r8XWwfrQ3kK0Fky5JPzRqSOVBmEOtfZwNJQouBFomP5oYjXMOj7oN1B2pZXMsD+GmEwPbNDKVxBtwq07dL1N8Ecbc2ajPYC7PIQkdsiHY+Z
 xr09lvz+
 zc2L/n/kW9ZJ1+C2bER5yMBzbHTcs5sqOLJJ1ntcAvkxMkhtlyJXy/41tVHuQx7Qv40XK3ROY9mtKG4VYOnfnSO6qY1LeYbNrdC5+8/gKYlRfJ/drB3Vxdj96eY5qh0e2z+ED6XY4sh1bzZ2FdvP/BINzEsKGsRetPAtOKSVO0k8/uFN/JOLoP6PIPB7FM3IluaCji9TeRhohv3VzR6iQ5IbbOPYb3OwZUbPosJqoi2rRH401o8vmp/wgxJOrim4O79MyAxfGo7ul151rT5nPAnb/GUQU4JFaqSg8GTLah6v7Mv0VCkLt2Yeas8hksjtZeL0MvfKYjT6YT84miWuLsJmHZZ59fZ4QDYwbU91pFAhsCs066lH2GnKGb1p0BN4D78R+rdGMbDpQPVKWbJNiSTx7UmyZQblsxQ6UiDLkIhEZHqqS/G+s0T4bNRK3SpH0jp7Z3L+l6msOLlwJIaCdlcvwvU6BWNFbONteFyS01QgvSKzS8sFsofGIgz4mY2Bfk5T6NSxggWFmi+2yhSdcDQ84lnwnIpC2JahXAZoUfdRhRcXU2yd7vGkqtYE67boGMOjCXLjBM4kqHTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 14:13, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 08:37:06PM +0800, Kairui Song wrote:
>> On Thu, Mar 26, 2026 at 4:02 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
>>>
>>>
>>> I'm quite concerned about maintainership, as it seems the MGLRU maintainers have
>>> not been all that active, and the MGLRU to me at least is currently a black box.
>>>
>>> I'm not the only one who's raised this (see [0]).
>>>
>>> That'd very much have to be resolved and the community reassured that MGLRU is
>>> _actively_ maintained before we could even contemplate it replacing the
>>> 'classic' reclaim approach IMO.
>>>
>>> I hope that Kairu, Barry, Zicheng and others who are interested int it resolve
>>> this, however!
>>
>> Hi everyone,
>>
>> Right, I think we are starting to make good progress on improving
>> MGLRU recently. For the last few years we already have some commits
>> stashed downstream to enable that on our fleet, most of my effort in
>> upstream is spent on other parts like SWAP, really looking forward to
>> making MGLRU better upstreamly.
>>
>> Yesterday I was still discussing with CachyOS folks about their usage
>> while working on that series for MGLRU cleanup and dirty flush
>> optimization, and got some nice feedback later from their chat server
>> that MGLRU's TTL resolved their thrashing issue very well. With
>> classic LRU they needed a le9 patch downtreamly.
>>
>> For many other typical workloads under stress, MGLRU performs
>> significantly better too (e.g. database, build kernel could be more
>> than twice as fast), it would be a huge loss to leave it unmaintained.
>>
>> Barry also provided some really helpful ideas about MGLRU like
>> readahead handling. We are also seeing other vendors and people
>> contributing to MGLRU like Leno and Baolin recently. Things are
>> looking promising.
> 
> Guys, can I please make a plea then for you guys to AT LEAST become
> reviewers in MAINTAINERS please:
> 
> MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> M:	Andrew Morton <akpm@linux-foundation.org>
> 
> Well Andrew is Andrew :)
> 
> M:	Axel Rasmussen <axelrasmussen@google.com>
> 
> git log mm/vmscan.c has 0 results.
> 
> Axel has however engaged in discussion on
> https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
> recently for example, but not much in 2025 afaict.
> 
> M:	Yuanchu Xie <yuanchu@google.com>
> 
> git log mm/vmscan.c shows 1 result from August 13th 2024.
> 
> Yuanchu has engaged in some MGLRU discussion also recently, here and there.
> 
> R:	Wei Xu <weixugc@google.com>
> 
> git log mm/vmscan.c shows 2 results from October 2024.
> 
> Wei doesn't look to have engaged in discussion on MGLRU recently.
> 
> L:	linux-mm@kvack.org
> S:	Maintained
> W:	http://www.linux-mm.org
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> F:	Documentation/admin-guide/mm/multigen_lru.rst
> F:	Documentation/mm/multigen_lru.rst
> F:	include/linux/mm_inline.h
> F:	include/linux/mmzone.h
> F:	mm/swap.c
> F:	mm/vmscan.c
> F:	mm/workingset.c
> 
> It doesn't really feel like MGLRU is currently maintained at all, quite
> honestly.
> 
> So I think we need people to step up here.


Ans some serious cleanup of the entry to reflect who is actually
involved nowadays, if at all.

Master of MAINTAINER updates, I assume you'll take care of that?

-- 
Cheers,

David

