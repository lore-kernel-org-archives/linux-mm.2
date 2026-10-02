Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5713CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC5E6B008A; Fri,  2 Oct 2026 03:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D0C6B008C; Fri,  2 Oct 2026 03:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AF36B0092; Fri,  2 Oct 2026 03:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71FA96B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:26:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43A4CA0644
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:26:28 +0000 (UTC)
X-FDA: 85276853256.06.C7D921B
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37187180003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:26:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m6VM6w7m;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790925986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0IgipywrUbAu38a6mE+/+11vCB9AwvCN/MVBbWhCew=;
	b=ZCR59vP15XHhHRWRKRg/OFtFARe7RkL/C2tKITW2CfBrfKf5CIGxwYxrwcbgfcVpHo9iNm
	rTcA8nZa20uWXwBF1XPi23BumiRm4WfjlSjACA3mDPDKUGnKsbVOSJwVsYNk8ltrjlOl02
	vGCsPlkhLQwiS3hy2ZiSnYUgSdbYFdE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m6VM6w7m;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790925986;
	b=EsNKR3IYWpsj9Nz2errw5AEWJ9TiVZB1TVkVzCvjNEnGLTJMxTm/xQoEiXsVl8DhpR5i3c
	Zmfb56N7yRIMs794KEjD8AJIDA5ntUM+/bqWTqKQxPPdK/s8YC/6z0fJYmsLUQbF4pm3aN
	O69RqbTZfWtxj05wXsqMG9agwmFsYfk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790925979; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=P0IgipywrUbAu38a6mE+/+11vCB9AwvCN/MVBbWhCew=;
 b=m6VM6w7mFZhABMGalawLn62qLOVR31W/nCEZZzb1k7wNDes6arNkt/jVZ0QswVmb9TWCD9
 BLQzsMjhPLdd2aDw4dinlvPL08kTHMzzvP1dHfoqxFK+IgvEQOr7mRoTLpnYucXSMaJqHb
 8JfSstE5qKQvJvUUyF8TH+LgNZ816vmGsD2FRM4VbPXuyQJcOHdoACmHDUUiRRVD+i5MZ6
 3FVL7jiGfyjVatuWCPpziF6bOg51bFGbQdQ7DVutpW4EY0IOTXNWoLh8JH6dOOYk4SPvdK
 gWEBX4XghtyVc3jbdFV9AyNHkxUFgI4575PwLZsdiVRoz03lDLrG2hZI/C97nQ==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <mhocko@suse.com>, 
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Message-Id: <93721275-3b50-49a5-9c4a-37bc181a098d@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: "Gregory Price" <gourry@gourry.net>
Date: Fri, 2 Oct 2026 15:25:54 +0800
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20260930072617.64665-1-lizhe.67@bytedance.com> <arzLw18RiTN6Hmey@fedora> <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com> <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F> <e195b784-8a78-4bbb-97ed-168dd86b3d89@bytedance.com> <arz-iKWj1gRO3ALw@gourry-fedora-PF4VCD3F>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <arz-iKWj1gRO3ALw@gourry-fedora-PF4VCD3F>
X-Lms-Return-Path: <lba+26abf5c9a+bb324a+kvack.org+lizhe.67@bytedance.com>
X-Stat-Signature: wxoord187b57q7ojidxyr6t4c7cwzhqy
X-Rspamd-Queue-Id: 37187180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790925984-370431
X-HE-Meta: U2FsdGVkX19LvYZepcqUm5PAlRLRW3pQNaQHH30G0LufPHa/7X2LbSsaqCSRxXPBSB+8W2PXH56lhXqhxjUlSg//7v7Hu2vLpeLN9SOGYPQqsK9R1Wk65FokHkJr7Vj+bCwU40trBvZDuaNN/85/sXRun2vxvSASWnmO0u1Uv3SxFv3D7uc5qlcyv9EXIxKiI1tJ/cz3rQHeFskTytr4tnS0+QnYPUpZsXZPTNTSiHl+tHol21c5qfwcm0ApzSDJyibVOgliuAlgRXJ5JaR73CBZ1BQV157z69zZRjmLqkHtzk2jMv5Faw1YZ4Bcts4Pc5StxpNgPMNmojPOcBSEdNHm2G4ixIG0e4YI8TDb5vo9pUYCaoCh0f6kYDhj9pNWm4TYg9XeXuMvSGSY2MkspVomm9R2W4Fby1gd2UFLGT/34blr+6KTYSJhZne/rwXIqzCYDM7Ly4UCF40611HqkKG1xZNKnUQiFFCmKDM8Fib8xuyVTB3UiiMlWpRvDD71IzpMN8R8LIDNF8GlCsin7D2qCmGu0nxTtms1eIJOzxplmYFWA3eGhh7bXOAWGFmQA8duGd8jIq+mh4MTBdjzVzjsSwJ4GuQ3wy0eR46A7PQNJrHaBWm0+pz5EbzTb4CY3zvU+OgiWSXqaLgdmLHN6tPtAeK3jpFL82pT+r0nTQfSk4Z0F1AHpH1/eHTRGDX/+1shmxGUgLVLZDZJDXPmCaVpNtYCW3EvbYlqEr2VxDJjjQR8e2vo+CNBQp326NgokQIZdirWCIUAZBvPWLF9LGe4bT/o+FUD4rdUHMmUYrMsLLsJbozAFQWy+W3oROayVvWOiMQk/QksyxU9bFO4PGRB84A6PxorWs4exyB62prn34TqsCd6ujFrXa3dEkk8nsFH8z5HSNPs/9OKhKhjB5/PxZayW8EDGX668VHE5tI9Qc2m85GzGehCQtSL9O7/nleAhYGIwMrhfKKp1op
 ol/XdxoS
 lN6lzOCNR5cGlKtEWweL8jwN210evLn47xGINwWgNuqyfUnFP2Rkh5O7iRvA0cG49UsUcA0qTZZ+qvZ9PAq2r2AzqvuLxUmNiur4Ib1HZaNLIyGnW5R9avz4j4xkigATzK3XLruc0HN3Esq8RldrY5ypFF49hNbUVNpgu8ypsVHxJGI7SOOJ/sBaVUw5TgJGE/Rn9aiM6TTTVr2oaUIBcqQDafnqjEO7LOfygWkp7aOheldhi9QrymdGow65wQtbOUh4aAK6l2yecOjD6L2cMhfO4xAiIojzdI8eJ2foVJp6tJOT/7c6kdzza0FALlMf5gQ5X85f0mzcoUJ14vkDMSQmIxalin4V9c9+JBTjl+WDrBqpsbruDF53Z7ZRHmJrFgSCUhrtzWZgoBVesMoMCzXVoIv0Fwq6kTrPj3GZ7cRgvzW87cXVszRHmUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 8:25 PM, Gregory Price wrote:
> On Wed, Sep 30, 2026 at 07:22:10PM +0800, Li Zhe wrote:
>> Yes, that makes sense to me.
>>
>> I do not see a reason to keep the MPOL_F_MORON handling limited to
>> specific policy cases. The flag already means that migrate-on-fault
>> placement should target the accessing CPU's node, and the nodemask check
>> is the common constraint we want for all policies that opt in to this
>> behavior.
>>
>> I will rework v2 to handle MPOL_F_MORON before the policy-specific
>> switch. Then the switch can remain responsible for the non-MPOL_F_MORON
>> misplaced logic, while MPOL_BIND, MPOL_PREFERRED_MANY, MPOL_INTERLEAVE
>> and MPOL_WEIGHTED_INTERLEAVE can share the same migrate-on-fault path.
>>
> I do think it's worth breaking this up a bit, we can decide whether we
> want to apply it to interleave separate of the larger change.
>
> there is also slightly different behavior for task-mempolicy and
> vma-mempolicy, because vma-mempolicy applies interleave via index while
> task mempolicy does it based on a rolling counter, so you'll want to
> think about what happens on repeated faults
>
> i.e.
>
> 1) fault in a VMA interleaved based on idx
> 2) a bunch of tiering and pageout/swap happens
> 3) we fault a page back in based on idx - that means this page is
>     forever-faulted onto that location rather than taking that as an
>     indication that maybe it should be local
>
> Maybe we're ok with that, but we should probably think about it a bit.
>
> We may also want to limit this based on NUMA balancing being in tiering
> mode vs normal mode.  This only makes sense in tiering mode, in my
> opinion.  In normal mode i'm not sure it makes as much sense - and
> that's probably where this all came from.
>
> tl;dr: If we want to change this behavior for interleave, we should
> probably give more thought for how it should apply more generally
> instead of just hacking on support to one or two modes.
Agreed. I think this is the right direction.

The repeated-fault case for VMA interleave is a good example of why
simply enabling one or two modes could bake in odd semantics. I do not
have a good generic answer for that yet. Although we might be OK with
that behavior, it deserves more thought before being folded into the
interface.

I also agree that the current motivation fits memory tiering better than
normal NUMA balancing. For the next step, I will take a step back and
think more carefully about how migrate-on-fault should apply more
generally, especially around the boundary between memory tiering and
normal NUMA balancing.

Thanks,
Zhe

>
> ~Gregory

