Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE63CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A749D6B0005; Tue,  9 Jun 2026 10:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24D76B0095; Tue,  9 Jun 2026 10:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961FF6B0099; Tue,  9 Jun 2026 10:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84C8D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:33:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3898FA05EC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:33:35 +0000 (UTC)
X-FDA: 84860617590.10.2087B3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A8211A000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:33:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR6h5cLR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAwQzCcKV6xIGEtBzqxQ3COTqDOfT90qmmiQBuBzWZU=;
	b=y3ZHC/4XKd0SeT6LQlthhmL6ipHt0WzKmId1MNIiAEi8mvaWFpbgP+SENvTqCkzmN8Xuqz
	YCwSGOrmLlDEEYSSIH3R6sx/kip197gwYk+X0KF5yUJinRGHpmEaxq4u2muYq2z9eULH1t
	qV/ESQbgXDHagY9povvTRqpo4T0xy84=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR6h5cLR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015613;
	b=lJZJR5MmIr3jlZ1XXhtgQut+YE4PhPQxZsnaWc/m1mFKJZNPqtjtYXrQ00icRqLcGTubow
	q/ecU6QL2eg5o2Z/hn4Na8xS201Dp8mFwqEp93h1id2HpbcvSwJy8BUIj26lO4gn1TNFIM
	VmaYv4qdiEBrDx4hnFB0afZm955aFWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B199E435AE;
	Tue,  9 Jun 2026 14:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4439C1F00893;
	Tue,  9 Jun 2026 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015612;
	bh=yAwQzCcKV6xIGEtBzqxQ3COTqDOfT90qmmiQBuBzWZU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jR6h5cLRTujiltPSm689nN920+3X6yo5OD4R884+TkTANE/D6veFgcNFK8J9g6K2Z
	 OK4at4p99jOAG8zdRm8aWzewXlItlUeUEUh4JkkNSplo/jRskZZ7h9b8BE80utgoTy
	 bLGqLeqXxHFzP92wW/MtMiSWEXdUaJPdXhHOz2+E+Ay4Hm8rGEzjykfbW2yqIX1ItT
	 DXJ1F54Fyvux8kMJiS9ZauKV9V5vnjHC4ZC7fKP1PnC/Ht0w1fWeGT4xRMewWcwo5e
	 xK4sOtVyJOp8m4bnjyXthx/HCjrBBH6toZ87zTvyau3Fy/kYJFCwBdBOKl2G/rEO9B
	 +BP2y6GDEmaMA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  linux-kselftest@vger.kernel.org,
  shuah@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  jasonmiu@google.com,  linux-kernel@vger.kernel.org,  corbet@lwn.net,
  ran.xiaokai@zte.com.cn,  kexec@lists.infradead.org,  pratyush@kernel.org,
  graf@amazon.com
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
In-Reply-To: <aidnjw5pH_z45gJT@plex> (Pasha Tatashin's message of "Tue, 9 Jun
	2026 01:14:53 +0000")
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
	<178083348872.1648214.17778188633648887952.b4-review@b4>
	<aiVp5RlbWRz5VnPB@plex>
	<178091437240.1648214.10761111570005003901.b4-reply@b4>
	<aibYJvzQQnpoN6YW@plex> <aicF5Sa11B4ujfSa@kernel.org>
	<aidnjw5pH_z45gJT@plex>
Date: Tue, 09 Jun 2026 16:33:28 +0200
Message-ID: <2vxzjys7ss07.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ytzbi14ce1n6uxnj7yizxgi5d68eg9jo
X-Rspamd-Queue-Id: 7A8211A000C
X-HE-Tag: 1781015613-261275
X-HE-Meta: U2FsdGVkX1/EdEga76VZwetQDwkLc34JxKULIW1XwTWxGrLmbmc0aVJaihggXI73k1FyrOJzCoS13n5Rw4aOARglWH8qGu62tIsjmtzo+P/tgKs8eW9phGmHhPgTXv3lo597lHi4j9oDi/kZ3Sx3FJ4tz4P5tlD2OudvmxmKKko4PmKG6DZaJ+rUPO9Lisx6l6SkfUenIDnoYeecoZBH/3SnF+prX/DpxzkifeJk0ahGfwN2NDDyRrhi9Khj87L69Ye2sEmy8NZYhh1Q54wcmlshEx18tYwTmNwowRzjZNTFnNWXl/iGCY4Q7FtbUytjJdtEUyT54FSgwp3QRQfUjuEXoM9e4Q4IX35/m4UsFrEveLmBzj29VdlzBas3T7RJLWNaZGfizf9tdk9y/dmvAYnpvbrvkDKzSUPzE6EaeWpLpUDiQ+EdezuBgRzNRK60RIiK9m0fdYfj1TT11dx7zlqdzaqMHJsA/9u6VuYgcUNbKl4j/9aiBqErlxDgtLuX9Y3kWS814Sq1H2iPD0CeUvgQtQL4NeVILOXbxSS1SZUebeDnJ6Zz5DngtNF6fmdRwHH/w/vSMAE/ptQKStpi36qHkriGi6vo7I6Guy/rQwrSvcewLB/p2gp2eMaXJeKZxy9vm/1VZoRibR623r9x3So7hvIsgcDb0zji/YTOdukXNPzVc6YdPXjBfykTkLog0ICYkFJPO+Kdf39WXjMdrbdXZM0wiiTKupjA61JYTNr40Lrxe4FTpWktRQscSaVJ2/FayS435bTyTvVtucRHPdRWstixJ8mmkE3DcThBvsGohL3Y/k3MSfulX3pMHIDxcpAHgHfIqjnM1mhXIuZnBvgq6azMqlEI0yQTEY1fNcUsMmvynfO1yRuMaEVLVIK/oVE1eMI7Ys2hRUrDsV6IMZRSFuXdTBTi4Bz/ZTcVA38w5JUkwW5UIAqKbav+gNtxlPC6gbXcb5wLZQT6a4B
 JIJodFLK
 FK3FtuICJAChaHQo+QmrqyByULwuCtTByNkVfCe69t2KpNnQACvTSEg8RZKNualMrhmyPkLQcBvXANk8KSTg8KdfbWQ5VYUPQB8K7heHerYmIj0OEQsjRePFLidK5gKzCykyshDADu6afIg04rgAATEHUNxp7yxJ0/hArR9zGpTn0d+COuFOTaQFtv0pcS2IWSaReEXLTSN9FL6CV3t6PpdquKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09 2026, Pasha Tatashin wrote:

> On 06-08 21:11, Mike Rapoport wrote:
>> On Mon, Jun 08, 2026 at 04:12:56PM +0000, Pasha Tatashin wrote:
>> > On 06-08 13:26, Mike Rapoport wrote:
>> > > On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
>> >
>> > Keeping all of that in a single KHO file is the wrong approach and goes 
>> > against how other logically separated subsystems in Linux are organized 
>> > (e.g., mm/vmap.c, mm/vmalloc.c, etc.). Yes, there are some messier 
>> > places in the kernel as well, but keeping this in its own dedicated 
>> > kho_vmalloc.c file makes complete sense to me.
>> 
>> Either I hallucinated or b4 ate a paragraph from my reply ;)
>> 
>> Regarding the code movement
>> - splitting radix tree makes perfect sense to me, just the documentation
>>   part needs more care than mechanical move

+1, separating radix and KHO block makes sense.

>
> Agreed. I'll also pay closer attention to the documentation.
>
>> - I'm fine with abi/vmalloc.h, presuming KHOSER_PTR() is not part of it
>
> Yes, I will move KHOSER_PTR() to the shared compat.h in v2 so it's not 
> tied to vmalloc.
>
>> - I can live with kho_vmalloc.c although I still consider it unnecessary
>>   churn
>
> Appreciate it.
>
>> - I'm against moving vmalloc APIs from kexec_handover.h because they are
>>   very close in nature to folio and pages. I don't see core KHO as
>>   responsible for preserving physically contiguous ranges but rather as
>>   preserving allocations. Not sure we'll ever support kmalloc(), but still.

FWIW, I agree with Mike here. I also see kho_preserve_vmalloc() as a
memory preservation primitive, same as kho_preserve_folio() or
kho_preserve_pages(). So I think it belongs in the main KHO header.

I also think it would also be nice to have vmalloc in kexec_handover.c,
but I can live with either way.

>
> That is a very reasonable compromise. I am fine with keeping the 
> consumer-facing function declarations in kexec_handover.h so they remain 
> grouped  with folios and pages.
>
>> > However, overall enforcing the use of KHOSER is unrelated to this work. 
>> > I have my own thoughts on this, and perhaps with proper versioning, 
>> > using KHOSER_PTR everywhere would be appropriate, but let's keep that as 
>> > a separate work.
>> 
>> This is a separate work, indeed. But regardless of the versioning it's
>> already better than plain u64 because it provides type safety.

It would be even nicer to have some sort of type safety for KHO vmalloc.
On preservation and restore, you lose the the type of the array, and it
is very easy to make mistakes. I gave it a try some time ago but
unfortunately couldn't come up with anything good.

-- 
Regards,
Pratyush Yadav

