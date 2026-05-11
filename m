Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E726FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FEB6B0096; Mon, 11 May 2026 09:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6D66B009D; Mon, 11 May 2026 09:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434426B009E; Mon, 11 May 2026 09:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3131B6B0096
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:10:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C52678569E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:10:46 +0000 (UTC)
X-FDA: 84755173692.17.9C1356D
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id D51DDA0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:10:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZY1pwzch;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505045; a=rsa-sha256;
	cv=none;
	b=bb0NqcVaqENQ0l0R3zjKaap21uOqsjy7oR6Sthnsxayt/pkR9YWgHaARXL3LIGE9AvDQrM
	oFxa8CTABsYgOLbPMLh4/JNOen/aQwE4kGI8idC04q9lUXtbEa7uIfUNrc1ETKrlYTDtuC
	SzQGGdJc6/WTHMB0WImkn9Ec/M10Vy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZY1pwzch;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0vj1B2qhWjl7qdvd6qJ1lPZrCOqEZMovr4s8JyrlRQ=;
	b=K2b7nm4a+ntP/AFC7pJs6AVGLxQIWEsGYDQvlI2qDHMEOQr7kWcvV9JlFjO6Ly1j5ckRBP
	JXqY3U+eJXNsecEH57M8pzxfqk6M8Bd8Tk8IePwqwZf+Tb2IwFnjFiTtWRPprFte/1M8yF
	nmZAfZOHmd3u+1DAWNCkYz7J/uQEVIo=
Message-ID: <608bef55-44d1-47f1-a201-4a6bd7be137d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778505042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0vj1B2qhWjl7qdvd6qJ1lPZrCOqEZMovr4s8JyrlRQ=;
	b=ZY1pwzch3L3vJXvoGmjSkcSpbjheRUvps3yGipce8MPxDZtjdD+UHs01TPn/IYSOMcVRgI
	IyXvBv3zu/Dv9ChCjLZ8ZB1CJAhMmLF5TXeCZPdzb9ikA5kG2f6n90dw7R/goyDG+35qXe
	G22Ax3ci2z+5YkbToX8B0ezgY0lQpBY=
Date: Mon, 11 May 2026 14:10:35 +0100
MIME-Version: 1.0
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 lance.yang@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, ljs@kernel.org, akpm@linux-foundation.org
References: <20260510114001.600681-1-usama.arif@linux.dev>
 <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sb6xpxo3rsxjnqat7mrhjk98inb61fj6
X-Rspam-User: 
X-Rspamd-Queue-Id: D51DDA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778505044-223958
X-HE-Meta: U2FsdGVkX1+PusrLlTkDn6iKm71QruWGvTXmBqkw6AyK0Ua7xYIlgHGePLv1MGxYYPouXNkI2e4laBi2JQ2bf5ueJPgDlkQhYZkAcdPRnomwPIcpVDRk2mQ2JVJ1LLGk3Go5BnPJQegROBy7JnmYM9XBcPH9GzQz3HFVbzGf0IylyNLEnsf99rFZFmrDgC5lFRHSZPiKwudBhNJkSh1BW5OearhWdf4C8m994V32VCGtzv01uvNf1H2OThYWO2U3GyZlFoMvmovnAtPqJ7RLabUFjd+avEclvEv7zO7Yfi2XXTqJdHFVj3IBQTCNv52G2Yrpc8DN+7Y47VIHnW+3cCo95ILuhhWtZhikkpySuIE566THXfpA1JvBRhkTLabp+ya/L0I3xejZU5BftxyW8L95Oe9GYpFGMJZKSR28dO7JnDIqNeuEarHyKESVvyDQvlJ9xYhH3Ms3q4FfDQwTH3eFdYHNBfzkCvwfD4btFjJy8e0JtLOVGJPKWKuT0UKoOCuffspzD4mVfNUjdriCkbNDQhrw9zxcWLFmtBQ9uNdu96HBHjXvTL3aUqJso5NZtFsJ1KPTKU8B1OPytAYKagRBI+f1U3BFJBLpWcvEV91v0kPpu2v0Fm3e5jMfJ2SiDaBIBpKF16LVwA7xShFl3jMR02cFRLVwAum2GVBCS9377xyGXoMSLQ42HZDkvWt/E/qIXOgwz93oo/Zcvu11zrqtGecgp9mAJMYup8iXOOP6M0i1Nj90I+epzWgHgEF5PO6p/lMDQcDNEaMV/0gUr7NnFakixbyUGtzFxZ8n7QUDzDwBGZ/axPxiJr9Q8cVFMYl3qoH1jQjIW40Dtnx3Uoxr50NamOkqoOeACp0Bf1MGlYq0v7uM0GaWoevgDT26At+jZsjkFqCgh3l/q5nnoZ26fSKtXKmKiCI6HtyyC3LJ40AV1OjaOJf07/tjXhMmg8z5koIXomroKcb9qIU
 OkBIg2AM
 tXFbz6v7rY2GLVTK2S6mNN/TqssuHGrr4qGZzSzYQe/E90DKkYmled3dtW2PPj2zLWBK86q3WSS3N8/rKxyedSoOAzleXzFlCGawzb07xjDi7b6cRX/UqW77ol5ybv/nyVUHSN+DGOKUudtnU917Eah/3V9ka9k9X0/UaEvQrMNeMr1X4x0sNS0n1EgqAWo9A7KPTi/Me9SdqhESN4EUew/nVnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/2026 07:36, David Hildenbrand (Arm) wrote:
> 
>>>
>>> I tend to like (2), and maybe (3) on top. Opinions?
>>>
>>
>> Hello!
> 
> 
> Hi!
> 
>>
>> I think (3) definitely makes sense.
>>
>> I have not had a deep look at KSM up until just now, so might be dumb
>> to say all of below.. :)
>>
>> What I see is that KSM scans THPs as 512 individual 4K subpages and splits the
>> THP whenever it actually wants to merge a single 4K chunk. That seems like a
>> lot of work for a single 4K?
> 
> Yes, but that's what the users ask for: if there is a chance to deduplicate
> memory, it shall be deduplicated asap.
> 
>>
>> One thing that came to my mind is to have a separate tree for THPs and only
>> merge the THPs that have the same content, but the possibility of encoutering
>> 2M pages with same content is extremely low? so this is probably a bad idea.
> 
> Right, the probability is low, and it would change existing semantics, breaking
> existing users.
> 
> In addition, we would have to add large folio support for KSM, which I rather
> would avoid.
> 
>>
>> An alternative is, does it even make sense to process and split THPs by KSM
>> in the way it works now? IMO this is a lot of work for a single 4K merge.
>> Shrinker is designed to release memory when its needed, i.e. reclaim, at
>> which point IMO free memory is more important than performance. But KSM runs
>> all the time.. so constantly splitting THPs everytime a single 4K can be
>> merged just hurts performance all the time.
> 
> Right, but that's what you get with KSM: bad performance if there is a chance to
> deduplicate :)
> 
> (and bad performance from scanning overhead)
> 
>> If someone cares about memory,
>> they should be running the shrinker.
> 
> It's not just the zero page, but really any page content. The zero page is
> currently only "special" after we added conditional support to deduplicate to
> the shared zeropage in KSM. The shrinker doesn't help for any other page content
> besides zero-filled.
> 
> Further, the shrinker is something system-wide, whereby KSM is usually only
> enabled for selected VMAs (with some exceptions nowadays).
> 
> Also note that KSM deduplicates independent of the folio size: not just THPs,
> but really any (large) folio. Yes, it splits large folios, but that's really
> just to keep the T in THP.
> 
>> Is a better alternative that KSM skips
>> THPs, THP shrinker splits THPs into 4K subpages when memory is needed, and
>> only then KSM gets those 4K subpages?
>>
>> Above sounds like reworking KSM, but just wanted to put it out there.
> 
> Right, and it makes KSM more THP aware. Which is something I would avoid right now.
> 
>>
>> (2) + (3) sounds like a good solution, but I wonder if above alternative
>> of KSM just skipping THPs might be better?
> 
> That would change the semantics where, for example, where we expect that memory
> was deduplicated after a KSM run.
> 
> VMs (where KSM is usually employed) are expected to be mostly backed by THPs:
> except where we can deduplicate memory. Skipping THPs would essentially break
> the main use case for KSM :)
> 
> Does that make sense?
> 

Yes, all of above makes sense. But I feel like this means someone should not
set THP policy to always and enable KSM together. In general I feel like KSM
is not something that should be run on big servers, as hopefully you are
not managing memory as 4K chunks for big machines and using a lot of THPs.


