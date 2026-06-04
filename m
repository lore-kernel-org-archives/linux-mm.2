Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F13ACD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 03:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9650A6B0005; Wed,  3 Jun 2026 23:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C7E6B008C; Wed,  3 Jun 2026 23:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8794A6B0092; Wed,  3 Jun 2026 23:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 760D66B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:11:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E5D51A01BC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:11:47 +0000 (UTC)
X-FDA: 84840755454.30.B218E4D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C694160002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:11:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HHBkq2lL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780542705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjS2UMpdjJpN67amMvH9W0cc0n1WNzw8Vr2I72B9eXA=;
	b=pSpp0uS+OiV2IjsY5+ZPt9Xi/f04pQBevaA++/iaPchCBpAE6PCGjU718KbvIATMbO5Yrv
	73m5Iu+m8w2BSklfujic2aFt8CzxtwXrIt25lnwog2nvUYKLpAIYRPwrwbpR7gYkHa4yZJ
	5YZyHw33jV3EAJjx4c9KfaDKzuMPSiw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HHBkq2lL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780542705;
	b=k5/BMv4L0Aqipt254kh9VoJ5WmdgHW0S8m4oEnppVWRTzY2vpOI6vQBaA/F7GcoG3OSkVK
	jREpUfdPXThGKpKGGtYDZBv0RqVawPImYrmVPXk7eU8gl3ygOCpclt9cR/4AwDoCIrg9AF
	GA+fm55oQAVDbcnoPt+tiaZ2hIilmOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780542703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjS2UMpdjJpN67amMvH9W0cc0n1WNzw8Vr2I72B9eXA=;
	b=HHBkq2lL+VAqKbUNameR6ChCjVLaEhwhG4hqFd6giuE3VskVYq9oX+q25N7PfgVOgwq3Wo
	4VEWhcrapraRcfQxjiScywn1mMBQiFQF+1ow3aWi/uHUdnqEbghCWrU2JlILK0b5x/UYx7
	lqkdWeGEUDbOwMCSQ3ZcF2tC6uYEnpk=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	rppt@kernel.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings in direct map
Date: Thu,  4 Jun 2026 11:11:33 +0800
Message-Id: <20260604031133.56010-1-lance.yang@linux.dev>
In-Reply-To: <db45414a-8777-40d1-91b8-a78789ed18bd@kernel.org>
References: <db45414a-8777-40d1-91b8-a78789ed18bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3C694160002
X-Stat-Signature: 4587ta3bzq3eqrtbbx9de4wguhd58ey5
X-Rspam-User: 
X-HE-Tag: 1780542705-902924
X-HE-Meta: U2FsdGVkX18wDg+j0gzj0ct3VciGTXIpv1IUWikZSP94dybuC8LblBoWFUnq3FZ0bDMffcMqgBj5OL33mEePSvkblPnCvc2VK/AZXkK7XSwAhcHjtE4p9RrkGoQlbxINOwAm7/y4hiRE8S4WN+toI7u9J2jJEKGeGKE+9dSsmMGAuk8Z6ZABTg2qG59Qa4cisoeWEprLPN0HMXs1q9XJyMohus1x3vt+Xrx5Dx192o6VZMZFI00K+R8B4VBUW9dOZZiluYHDzGfwDO90p9AjY49Fc4ftTaF/oDE2IlEfLFvfnVOt66zNqBy8t0UhAR+ZJKClJmWNNnT1uUFI7NmqP1aKeWSpr6ezZfFidIsU6gXeC9rytfZ4lRPPoXKfIdn6J1GKLvxt6UCPVA7qTZ8bwF0D7yEYvfnk5MiD1ZRMl3CaEM4DzHyWZXAR2Spxc5hIkB4WGzTAToYyTCOTdPeA63hYdBTjRTO8JIphtEhCXKkzUa4pGMIEe2MIJyXZredqnOExOmyFggjsNeT3DkZQBOjWl8s/sfWMtHZwKNaMVcEnxQ5p4g63i/6ErGo/jh9Ku8p+GtnURPi0vggcCUmHhD0CgrM5SmfGwmk46uoZ6ODg1kipWZyRnQgk++q/w7kBaWsmx1usB/Gc99NuCENxuEqnoZuumvZ3J5OFBWM6dsaWP6muSdcjL16bP4gyD2HVelP0+E3tvShxxd8kGFf51bDKu3wZGOuhtuHmA9t7SCFvvBtvhaZb2O+zQB75d8HXLDWCkEXuxafu4pt6me/MQBSaFksLki4cXCjU40BrOqesPk9MCIGEwZT66qUgXROTLOTfUbHvnEgzU48Qh1Sk9qWj05c86zqTRexRZ2INDTC3+vgvtszl+8aYobRjCimIFwmlFdKQfawxzLqmNu3kg+OgkUNYEOLIDDPaWSWbDa6n/fqK1q4dFAKQnjPqyZBuvotbEmmihFghDhufKyR
 QgQknnnR
 iDfSM7cYgOfP17LioZgTpry5B3aQsKnWWRZPShgwUAY5YDLdgokg6sfxx5LMuGaHgiS4kun14u9IVtzXAKawmVYAJTYAYJMldFOIpTcZaV/mDjGKP0YECDgASO+hg/ZxtfQwXhH7TEHs+EPZNh8JZA2x8Qn0GaRYq7+f0zdE6hViqXOvZSb/q86oSVoTjgQy/ulqTlOnghnKuD8MJM9mq5t2WiPcOjfnxyg5pshv80Mhs0nj/kHWtVuvd6pfUbkl5iWsgUv/62JxAsnj85sJAnZLHGIoYGjAfb8sT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 03, 2026 at 05:48:56PM +0200, David Hildenbrand (Arm) wrote:
>On 6/3/26 15:09, Lance Yang wrote:
>> 
>> 
>> On 2026/6/3 20:35, Mike Rapoport wrote:
>>> On Wed, Jun 03, 2026 at 07:41:34PM +0800, Lance Yang wrote:
>>>>
>>>> Good point, I kept it separate on purpose :)
>>>>
>>>> Putting collapse into set_direct_map_default_noflush() would change the
>>>> semantics of that helper a bit, IMHO.
>>>
>>> For x86 default means present + rw + PSE, so yuu can look at it as actually
>>> better enforcing the semantics :)
>> 
>> Yep. One x86 detail though, default seems to miss _PAGE_GLOBAL today. Not
>> sure if that is intentional or just historical. See patch #02.
>> 
>>>> I would expect arch_try_collapse_direct_map() to also be useful for cases
>>>> where a direct-map permission change could split a large maping first,
>>>> and the user wants to try restoring the large mapping after changing it
>>>> back. One example[1] is making a direct-map range read-only for security,
>>>> which I am also working on :)
>>>
>>> I don't think users should care. The users care for particular permissions
>>> of a range in the direct map. It should be up to the architecture to select
>>> most suitable mapping size. The splits are implicit, I don't see why
>>> collapses can't be implicit as well.
>> 
>> And agreed, users should not care about the final mapping size, that is
>> up to the arch.
>> 
>> TBH, my concern is making the collapse cost implicit for every
>> set_direct_map_default_noflush() caller. I still lean toward keeping
>> it opt-in, but happy to hear what folks prefer :)
>
>If we could easily do that automatically, that would likely be preferable.
>
>Especially given that we are getting other users of direct-map removal soon that
>would face similar problems (e.g., guest_memfd).

Yeah. Makes sense to me ;)

>
>What the performance impact of trying to collapse after every directmap update?
>Imagine we have a full PMD range with directmap-removed PTEs?

Collapse can turn 512 PTEs into one PMD, and, if the large range is
compatible, 512 PMDs into one PUD.

Eeah try walks the page tables, takes pgd_lock, and scans entries until
it hits a non-present entry, mismatched flags, or non-contiguous PFN. The
same kind of check is done for PMD entries before a PUD collapse.

If nothing collapses, it balis out without flush_tlb_all(). If at least
one collapse succeeds, flush_tlb_all() is called once before freeing the
old page tables, and that is probably the expensive part :)

So failed tries are cheaper that a real collapse, but not free.

Not sure how often the remove/restore cycles happens, whether automatic
collapse is worth it depends on that. Keeping it explicit lets callers
take that cost only when they know the collapse is really useful ...

Thanks, Lance

