Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFAC606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i76A644j
Received: by kanga.kvack.org (Postfix)
	id DFFDD6B05B3; Fri, 13 Nov 2026 13:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFE96B05B4; Fri, 13 Nov 2026 13:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6BE6B05B5; Fri, 13 Nov 2026 13:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A08F56B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:09:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D79BC01D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:09:04 +0000 (UTC)
X-FDA: 85430882208.18.BDA3E1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E5A31C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:09:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i76A644j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794593342;
	b=XWrIKuLYfn/dpo1BW2yfNJGt89V/feWjWQDAFtBLmUuvmkqz5Mxffj9du0SFwmbYKd7cRf
	QsLY91SILTJthCCNYfLXhzGv3WGcHFTzBrqFCYjukpmjDwNeTvcC68gZHAIWR38iMjjoAz
	mlKm0kF2ahtZr1I2XbJeMtZzipIlEZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794593342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYve4B7tfcs+4qrP0IXYiOdAh1t+su0pgfjEgvnY4jk=;
	b=gBKUmHsmyP3MIxk4WjJ62VW71AyBL9fKJJ477Y6fmIt15otVWCvQ3EQOv03IyL3JhWIIXC
	XweNZVmkPUov1rf0plbbHciYwxFG5klz1e8OMfIeb6hnxeAU7+bl5fV9jMm1MxdFbeVRh0
	ItbHCPXe6mvJO0k5E7XyHu1h2KCfhbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i76A644j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91698409BF;
	Fri, 13 Nov 2026 18:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADFB1F000C4;
	Fri, 13 Nov 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794593341;
	bh=gYve4B7tfcs+4qrP0IXYiOdAh1t+su0pgfjEgvnY4jk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i76A644jOZvI9RY4CcNq0C7o8DUzWe+9qC3ysMy/JwSXMB9tRGZmNJWZrbOfqhSUv
	 aUDdLVOLg+krPme2jYFfg4MXLazXlAFJsy/pjn326/EG+kuBJWWo2s1h8uR7sDZS6C
	 LjmmT1rOSREiHaLYXXPrbmH0j2lefokWVGooRPdOPF47iMVL+i2rqm7v/zqraCSSgL
	 cQnRCdLO+45B0SWnvjk7u0Nsz5CSeYT9LeG+Dm5nVPOVnsjvX91UvhYcVNo+h0d0gn
	 02TKOiusgWqvrdP0a0nIp2r5W1hh43Y4lOx06tV+uVw+oA2+07JRrI7EVuS9Mxia7x
	 GbRUtNjh7VemA==
Message-ID: <27ee1e9a-be41-498c-b64f-df161dfa4b98@kernel.org>
Date: Fri, 13 Nov 2026 19:08:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
To: Roman Gushchin <roman@kernel.org>
Cc: sashiko-reviews@lists.linux.dev,
 =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Zi Yan <ziy@nvidia.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <sashiko-outbox-212974@kernel.org>
 <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org> <87y0aw8x7y.fsf@kernel.org>
 <79c3445e-623e-46ac-a09a-0a5d21f117c9@kernel.org> <87a4nc7gqh.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87a4nc7gqh.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5E5A31C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: yp3u3uy16zetfa1ns83n5pcz116bphw6
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794593342-474683
X-HE-Meta: U2FsdGVkX1+10junZSTDEQ08WSdb3xC7dYqma4Mvd02qSH3UvMoNL84rFd31axNZmU76u/I2LSFuoY7wPBu4C4qURn8whzsscyEIvRMU5t7jbkEMlsGXA7WRB2e3VUdBwY54Oj2Euubl2uxnvI/aIvpJuoas64D6YycWc5ktOILqzPRyGe73J5ddcy+ICl1f0l+unBBJZSkwxYTXRpa7MHDT3dCg8fyJbdtxPt/mAUyYOJ1SCsvzhiauemBv+zo4SK6S4y9tBbzNwyJmhZl4AnMWWpIKtEODbTr4dVOWI38Ye2mpVh4cL8YQhhOnsH90LcDt4h1FbYx81jfOsYLF6zw2OKP9bNIoKujwqVQKizJaxjYlJhOUIrQlojisWcI8F2pzW9F3LaOkipk2CO11vGpVUBmYpg27qdizib/XfRO7IrDarM548ZlCq8xux/3CDg5cjL5Nfy25OgXdBg44qDVcQrrSJBsqB2dZmu9Ha6sPe4QGgV7Hd4bO3yqCWmzdCEaBg/V1J8VlZuFdrNGMyMKB1ZW9Jz/6rwCyLP68PwRDDAs21tlKa0Y5hBfCmYNTlTCHRU/ldHqF57Nv/WgG8c+46p22YIKQcTkVJRwzcteH2F03uBjFmylaWYMkeVGuPs2VVFFH9Q6xzfFNpgU0MVuZ6+hkuR71OawMxbglu2vJnIB8YNzPtu4SwsqUgCpTJW0jGuTe4itR0RZZn+JxdkmD9Kc7AIbGb7dCk1uL4pJjhS3eairZmyAr4rGrS8D6I21M46a20t3KGKBpHCbMFUFo8Tz09K/YQcnHKquZh38VywS91kO9Xufx7kjZR0JD+Vxy7TvyxH49gq9oApjW/FI2QzWYpKVC4uaGSyoICBK514xRUyJTxMxI8cV+ulhm5LSrvYK2Ks9P54QlwlkXeSIkidAy98iIb6lluYBlLvgF8clsrBfhGmFFRsUpDIGD7k+v5qzOM2Zz8KRA+XO
 ky5qhntO
 ryPYyPkghUcSkBATYxSYAbhOcWy+yKMo+p6nWyLoqGL7PdStxZ9A5uuBIGukDI67is2Yq/FOmK27sv+OpYmKecwmwcdsyK1rCHSDpsl319/XVh5xQ5Wxh/iRNIu/LZGNXO72QJPX1OCFEcGRhrCXng3TRCaxQ/amwH13KM4Pus86cZdgp0lJW9Qduz+oZ4sMbf3j9J9sOmt3kAvpPjCHzapf807ieKhKKEHByRyFhmixE4UVPp/5RV7lPf1goKc+J92g7vkwHHCZwBX3n4wAko7eeIAb6bnA/baw2Mr8rUISVHSFUEQyYhKEmG1QQ9jG16zbU69mOBrtfQdM9psVLyvguZrp3PshPdthEoqwN/Hg6lP+LdDhqSVFW4RKzV74meaeNRLV+wmcdj61t4vhPuie5++oN8fH8MgKDBIlUyaaYyJp200lTGOuCOzJtln5jzKQEb260qVyE3E9sDcr61qMTpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>> Posting preexisting stuff to the mailing list is not great, at least
>> not right now.
> 
> Yet I've been explicitly asked about it by others. So at least there are
> various opinions here.

I suspect these other subsystems are not as exposed to Anthropic's long list of
fixes :)

> 
>> We were very happy that preexisting issues went into the private bugtracker. I
>> want to delegate stuff to people in my team to screen them and see if it needs
>> fixing. Well controlled.
>>
>> Now either:
>>
>> (a) it was never really gone, and we were in disbelieve that preexisting issues
>>     are no longer posted publicly.
>>
>> (b) Sashiko maintainer decided to re-enable it without consulting us.
> 
> The correct version is b*, it's indeed back, but in a completely
> reworked way, as I wrote to Lorenzo yesterday.
> 
> Pre-existing reports are now limited to the first non-rfc version of the
> patchset, they are limited in numbers per patch (1-2), they are
> _deduplicated and posted strictly once per issue_.
> 
> Re consulting the problem is that there are several hundreds maintainers
> with drastically different views. If we'll wait for everybody's agreement
> each time, nothing will ever move. So I have to make some decisions like
> this on my own. And, yes, some of them will be wrong or not perfect.
> I do fix/adjust things constantly. But some patience would be nice.

Right. My ask would be to move them all into the bug tracker instead of posting
them publicly. There I can filter for stuff that I know is already either being
discussed, already fixed in a tree, already delegated differently, or already
sitting in my backlog.

I would really appreciate if that would be possible.

> 
> Btw now you can delegate access to bugs to people outside of MAINTAINERS.

Oh, that's awesome! I was trying to delegate the last 2 weeks but was always
busy with other things (guess what :) ) ... and wondered how to send people
these reports.


I'll try playing with that next week.

> 
>> I'm sorry if I made you angry, but I hope you can see how I suspect (b) and why
>> it would make me angry.
> 
> No problems. I understand the problem with the maintainers load right
> now.
Thanks!

-- 
Cheers,

David

