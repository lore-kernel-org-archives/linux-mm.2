Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFDB3CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2363C6B009D; Wed,  3 Jun 2026 11:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7566B00BA; Wed,  3 Jun 2026 11:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123166B00BC; Wed,  3 Jun 2026 11:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F29536B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:49:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAEEF40443
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:49:04 +0000 (UTC)
X-FDA: 84839035008.09.D81F018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E82E018000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:49:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U6pbP/IJ";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYUk6vW20DB8I7Vftloyl0dbtzWNes19X5Rj0mk5KyQ=;
	b=H1M7/3DyN2UnN1k7Xyev6WSVjZUBD7V/HnccQ/5VzoNxxgkPrpYFlH8vISyL8MGQyxnrPH
	hjEX2RlRbADk9WsFNvZZHNOQzrDahrpZJMJbxJztnfNTjDB1kREnarH/PZk8uai3q31Utg
	/4R6OSGJkBR9p99mya/3NDa/aROA4SE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501743;
	b=B/OF+DByvfkVaotMB5qaYk4nR4rlu1j4UdLj8pvlokDlwxu23m5QwFU82DyMyyGIj9AAWG
	CQS+b4ZJqluC4bXPbTE5x70kdMINAgKEm3FjzSEV6g6GJJlZLxhv6+tWLEuRQLaCugWUE/
	Of4vEFk03zExKSXIKGnMCQ7nXBmdZDs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U6pbP/IJ";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7731760138;
	Wed,  3 Jun 2026 15:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4881F00893;
	Wed,  3 Jun 2026 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780501742;
	bh=sYUk6vW20DB8I7Vftloyl0dbtzWNes19X5Rj0mk5KyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U6pbP/IJZ5p1e2csLq0FLEBF3slLLyoJBCa/7Gw3ja4mHFR7RrPzQqJQ1mwDpj9r5
	 FTzlfUp4aySgreHzJ/77ZhBvpYaBwo9PHPy5+dRrdYidEnal4iyRNiq5uWH0ZGJVFq
	 ydnzXgYp97Tcute5q/pHMrMQR60ydBZYfxHEZKu4tAJ6Gp10+1kisPqXQ4+X3Aqw5j
	 XfzlWU9uDsQG3fHS2em15jeQFvi5Gqck086IZXBv2De8q+PQlNyYws17YzpNY69AzO
	 DgXQrJmMtShNbkmmRdj0E1wWLMshIeHHwE3X3I0FbauymGr84g9NfAARyM/dWRlMed
	 txBsRqa347D3Q==
Message-ID: <db45414a-8777-40d1-91b8-a78789ed18bd@kernel.org>
Date: Wed, 3 Jun 2026 17:48:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings
 in direct map
To: Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com, ioworker0@gmail.com
References: <aiAJG7gdey4oNr4a@kernel.org>
 <20260603114134.3010-1-lance.yang@linux.dev> <aiAfnw088f3ZT3va@kernel.org>
 <3ec76ffd-2650-4302-87e1-8183029a0553@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3ec76ffd-2650-4302-87e1-8183029a0553@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E82E018000A
X-Stat-Signature: my8gfa7wqmp3pt4jgg4hspbofwrp71fd
X-HE-Tag: 1780501742-338941
X-HE-Meta: U2FsdGVkX19GKdNJFYnJ6OI05jGz20JTXcoG9fdrmMh7iE3ZUKUUe00OTYRwC9O1uiJ4WKvkbfq5OsBxFFLPgsXQW51JOWMEdfTw69tXDHAt++zIt1OVbJZWSzzSEnYt/IxvSWiKvomRtrCjqGYJauMeoRSN4XaA3iEKsuJmifcb5FOjPaGtxF0V1HlLdljr5JZ1MGQJqkwoBk/2+R0SEZRbj0+OMPpqCnMLJVAiqVBXUPaaHS8FhWCt5nR1Nya+Ra8WSqZC4R9Dy8uBs+6xCTHGj4en8b+O113ZqYdD3BxgnivYi8vC4Oyw1GXbkNEpeaTN4b3mPacTtj15tVPOcXmYtkEqCsCp3OFrASF0eYWkunhVAVgoyG0ammTMjPAT864yoEze8+v6WfcIzZGLaDoE6bnzRZ8rszlY0Au8hsdAqzop+wrpZrsCUnzrpPi6d2NFBTiro7qCi6o5SUgXR5T5nArhEnnMSVh32cX1OdLSmvRDan1/KVNgxYmGI74wWmBbG9N0rzornPISuOT9ahOJUqEUiO8rIR3ixPH0kVjvgJobO4F57fY50ObpSVi46Fkb+m6XEEklk+vNDrBZoMOW/UIN9i4HbUGvJSI0R/4d2dCp9/8FkMYUReF1MdP1WJJzohl6mu7tCp5wws0jDgvTQyh8JDRHdG7DyXoDUNtd4uoXr+9/+Fsq3Td57CIxfWNmrI0SWjsMZM/1I1SvEl1O+rtvUMZLECEhE/NQu2wCkD8VNZyi1rPgTBl+Nk9bCtmbohFoX5nqSFUinN+i3+tdPXsWk5j5mvGq+cfc6Id9UARp0E1s7K/v8M1ET/bKhA86ZM+GZfPo1WoGFtEBL3QWDiSRhyvPd7OMgOLD4XHOP0sw7BxEMld5QWDVLYkLsDi3PXy8rVZ9B/t1/CyxqSaNvgcNTFMr0uEsHoUmTUUWVQl7Dy3C5q5d7xF6Sp0yF0D60VNSiNrpCEwAZZm
 ZqRS1c+z
 9a3sIJHdCTVaQZYx3qRWaOJg4+WzmIvC/Jvb0gCFDQGLVrMsAp5+7FAO/IBS6lwgyoC+YpUMdtq6EtbB2m+DWwOxR2t42DF6fCQRMOPQl2/zLS0fbm6msX9gjFro1KtaTteodDkbaTAe98eSGm8ps867bOt6Mh4uUBdXTfi17aTkPqX6dmXm05IJ/7PUFAd6zhqiJ+pXm7Fk94YT7miCa9SwS/o70qrrx6mivaGjmrXZAnCmk1+rOWxg4wZIoL1FS15LBviQuhJkZfnl4NSmzHaZ4/j0rx0Vc+WL68aOxryyCsnKQscJzj/xNH20L6485lViA/1BZy26FMjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 15:09, Lance Yang wrote:
> 
> 
> On 2026/6/3 20:35, Mike Rapoport wrote:
>> On Wed, Jun 03, 2026 at 07:41:34PM +0800, Lance Yang wrote:
>>>
>>> Good point, I kept it separate on purpose :)
>>>
>>> Putting collapse into set_direct_map_default_noflush() would change the
>>> semantics of that helper a bit, IMHO.
>>
>> For x86 default means present + rw + PSE, so yuu can look at it as actually
>> better enforcing the semantics :)
> 
> Yep. One x86 detail though, default seems to miss _PAGE_GLOBAL today. Not
> sure if that is intentional or just historical. See patch #02.
> 
>>> I would expect arch_try_collapse_direct_map() to also be useful for cases
>>> where a direct-map permission change could split a large maping first,
>>> and the user wants to try restoring the large mapping after changing it
>>> back. One example[1] is making a direct-map range read-only for security,
>>> which I am also working on :)
>>
>> I don't think users should care. The users care for particular permissions
>> of a range in the direct map. It should be up to the architecture to select
>> most suitable mapping size. The splits are implicit, I don't see why
>> collapses can't be implicit as well.
> 
> And agreed, users should not care about the final mapping size, that is
> up to the arch.
> 
> TBH, my concern is making the collapse cost implicit for every
> set_direct_map_default_noflush() caller. I still lean toward keeping
> it opt-in, but happy to hear what folks prefer :)

If we could easily do that automatically, that would likely be preferable.

Especially given that we are getting other users of direct-map removal soon that
would face similar problems (e.g., guest_memfd).

What the performance impact of trying to collapse after every directmap update?
Imagine we have a full PMD range with directmap-removed PTEs?

-- 
Cheers,

David

