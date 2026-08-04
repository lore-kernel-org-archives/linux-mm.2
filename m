Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01199C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172A76B00EB; Tue,  4 Aug 2026 10:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122926B00EC; Tue,  4 Aug 2026 10:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F057D6B00EE; Tue,  4 Aug 2026 10:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD0EA6B00EB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:17:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A0391C00FA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:01:36 +0000 (UTC)
X-FDA: 85063598592.17.9D864E4
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 44E6C4001B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:01:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=ccrlKDgt;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf17.hostedemail.com: domain of deller@gmx.de designates 212.227.15.19 as permitted sender) smtp.mailfrom=deller@gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDTDVJNg3nFxCD1xzYBIHtyRmvqhBISNnhs9ob/+Hzw=;
	b=3pseateP+Q2wB/rN/M3vvrKQhBEfpz8RPxh4/G1aoVsWg9WpYy3eAhtvGxIDCRHN+ssjWv
	aImQ3SyFeAgBZbojrh64FBk7rM582V0L13kyhs2t2SETjCGhTwgkh8V12A/jfSF0rw6Ugn
	ZUORwtXkhOUPsOr8MUnTnNI7HCL8jG4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=ccrlKDgt;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf17.hostedemail.com: domain of deller@gmx.de designates 212.227.15.19 as permitted sender) smtp.mailfrom=deller@gmx.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848494;
	b=IYZHIbjow7xr08yY6qrhJKhUtnRV9UAG/mEzySrel8NeyqUjus9UNnzZuzkbcRcqGw49s+
	S+pozT9m9rpbV9ZWl3BX2MVhWqzC2ADSJsZwvFMXNnoiBiyyuCcFDLyrTNyPCLnU7XFmMN
	j0QDp6xpC142gtWHMTVso3i2VFtFTOI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785848458; x=1786453258; i=deller@gmx.de;
	bh=wDTDVJNg3nFxCD1xzYBIHtyRmvqhBISNnhs9ob/+Hzw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ccrlKDgtIs3lZ7+R2He9fjrrSGMQUJyql5ScZU3YdxjtXJMN5xqIR2mzW4hgSvtQ
	 vKjW0Q0mFivfLKuIxEHVXmTZ31IMm07OoY2Doyp3DHE1f1nAxcjSicAhJ3fqGe8z5
	 qzCuXoQDksTuErnFnAUQZGpU8WxdivG8XMQrY9cbiwiS3/fgVwbfp7FguHavgRn0p
	 C3rjfvT2fRknPlPT7SXTvRr3GyA7vgnj3+MszBQMUMJwf6wWpnQcVgFI2z+mfiTnc
	 2kNKaK4og5MLrUv+l7/96UasN0HDTYPikYdqPOx6rLILv0oAHamQ+stywfeqRBIog
	 jCBSCfnfbLCe5BO0ag==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4hvR-1x1Aqb17Jv-00uxbB; Tue, 04
 Aug 2026 15:00:58 +0200
Message-ID: <e7ac6f83-72ff-43c0-b67b-6b17caed995e@gmx.de>
Date: Tue, 4 Aug 2026 15:00:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get()
 and ptep_test_and_clear_young()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 John David Anglin <dave.anglin@bell.net>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-3-pfalcato@suse.de> <anHHyiHqYf3yLf2K@lucifer>
 <anHcJZYyz9Zrshdm@pedro-suse> <anHd7ho3daZFZ-4r@lucifer>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <anHd7ho3daZFZ-4r@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9cwMUn/XZDmLowNzOiRqoxpFueZH3mGjWh5TO2nLsT+wDbg/A8m
 DpO3vGKHOWUPJfhL5VKuypcxLWK8wTXXSTq0sptMcZjoCPNUZUmpghqaD4KpjHXn59Imkgt
 SVZsL8zkLOfMYwofS/GDaudhA5AITnKORyfsA/13I/VJqUoZai5BOMn+TtsAr6Hiiipm+3n
 7cskdnywo4qytcVXdZeWw==
UI-OutboundReport: notjunk:1;M01:P0:yHazcXd0k5g=;GqK7lRZPjqdzGnJVS/puooI73Dz
 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
 G+9/QRVkasR/3hAtvX8EvhHpMVEQQ0y89C/wI=
X-Stat-Signature: jb8atn4xutsgu4azcnyknwf7xujc3c19
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 44E6C4001B
X-Rspam-User: 
X-HE-Tag: 1785848494-777630
X-HE-Meta: U2FsdGVkX1/1x8F/yfM5LMnIm21VP9841KBncDn3Gx0BD6+vG8qUAk5uGto23iJ221PZiXpz6yfNSokpiphdtw2AlW/9FF+pOi1nE3CDrnOgcuQXurf7/MTLtVfc+KgETCSH9XHJ7XVUWiobkVw75Q1nanWNqvlAsLCu5divGiEcZdWHRlrg/jjFl3JHGNKXnmbe2UtEUHKa7YwFnWKoNVegRpTWCZB0AOj46pim+IWUs5R+t24OgTuDrihVTerRrUmVK/iDg63WIh29cq0qeCc2q9pyzz0EuB47e5ZfFcR171UjFA6L1yFuMhvViqUtX+xzB6RZMTp96XSxA7WtMJYaVYHbdtJzdzWGj7LgV27jmmmlVBZDRoAp1Ms/mP518OhyXnEz6bYHcJHr0cLnCxHAHcvxhArF+Xro24jzE2f2m8JuknNMPgJP0qT2M5j/Wb/hwytDvNx7o87LQXYnsq+MT8N/jN15hwxLmt8GTMYh/uorll7+xjJZsIePt6UW9ZYha1v+NIFZfPNHfIKfV/YdMj7dBp7gNK63DeXz+7g8GGyvOAlYbvcsH0+eXzrrnM29YWsDWc5aMpcNx5yemf19UB0Us8VF+wcxe/swYOWd+aNVPkikD/M+UT42BTPWFtxF2wVICUEPaVz5STHZWeRx2YeWmKl+Bvq1s4vEIA2Ff5OZt/Q1OcxN+xSjfa4MOyK029/U1K5JgQV4+RKLHj8+BvztcEdy5SbIxP4kSu9+hZ2QsZV/mgJd1xqqL7MtPxm1wlIScMBQHVFEQiQxvKtLrkwZWKVgUuWgCJvSQ2X/a0UtHYHwMtNrjJTdjxKxp53upzta0raPYLPImiExIS1LzUqI1mXq+gCsziBVO5LeY5lgVSwMttwtqEIFXaKZ8tTI5qttUi1EnuEY+XVM37/FCpC06MHvAuHkDdme/E9tTBrNCj3oFChX3kURefBwi2MTppmeeqmrD3PJt6U
 mxHlIxPR
 NNnLehIfnEOAbZQFeWfSG39Q7A6Af0J92gjc0Vrj1Rd6GW6aCRjfscNGnc1UT/jrzkywfiq3s1TmX+PbPNQ21a+m2r17bGx37cmsoZ/yn19L4wBdcNHTnk9wF1GKK/AEDrWH/0veisQoKur5ziP31FMOqg+72eMhwPbp+jo7PZWTh4fQy/zYzO7MWvojgL/DUPdpB0i8Xx/27VO/LCxxdZnoM1htuuKEuMHGIUt3Rme3W9QuthMima8aw0XhJLyxK26ClCps5ktv8nBzrHyAC6AJk2e7183raBd4920CyqMgp7X3bZRpuast7/idLxHKgyqj34w/P1UNyNvEV2bcAfpDySFQYe4EIGgzgzWkwyCYnc+5iC1usQ8a19B0ep4TQ+c9jtYNC2+XXwdeVU/39bgbDSLNvtzgrxkbB0FGd3AAy/riOgG3GzmvPUeKuSWkWKPg/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 14:42, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 04, 2026 at 01:34:41PM +0100, Pedro Falcato wrote:
>> On Tue, Aug 04, 2026 at 12:11:08PM +0100, Lorenzo Stoakes (ARM) wrote:
>>> On Mon, Aug 03, 2026 at 05:43:56PM +0100, Pedro Falcato wrote:
>>>> From: Helge Deller <deller@gmx.de>
>>>>
>>>> Switch to the generic implementations, which are identical.
>>>
>>> You sure do like succinct commit messages :)
>>
>> I didn't even write this one! See the From: :))
>=20
> Lol well then feedback addressed to Helge ;)

Noted :-)

>>> Maybe worth saying by dropping the __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOU=
NG and
>>> ptep_get defines you get the generic versions from include/pgtable.h w=
hich are
>>> functionally identical.

Isn't that basically the same as:
"Switch to the generic implementations, which are identical."
;-)

>> I can touch it up though, if you insist.
>=20
> Yeah, I'm being pedantic here it's not vital to have this change :) but =
be nice
> if you could, I'm sure Helge probably wouldn't mind too much? :)

Yes, I'm fine with any cleanup/rephrasing of the commit message.
Thanks!
Helge

>>> (Being pedantic, they're not quite strictly identical as the
>>> ptep_test_and_clear_young() generic function does some weird unnecessa=
ry
>>> indirection with a local variable and the single {} is dropped etc.)

