Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8633EF4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17B56B0093; Wed, 15 Apr 2026 06:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8966B0095; Wed, 15 Apr 2026 06:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE9E6B0096; Wed, 15 Apr 2026 06:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADD136B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:32:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67B1EE3EDD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:32:35 +0000 (UTC)
X-FDA: 84660426270.30.C69844D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1457180003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:32:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D97O1w5y;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb4ApaNKGbL8+M+FidV52TNNZ3tFHT+hhS09LGCWCpU=;
	b=yGaX3rxhM6ZhkTy0qq+6GA5UjXuwJZELWtUPDUR8IzH1Pz8cSdFo6k1PdXnc9NkB8lNWXO
	4Rm8L0QMBTda2f62HV1scrZmwIBWI82k69KvcCVPWU69qSygqT+yROiQEWTosrX070PQx1
	bkVPVSFkEE/Qn8/tEodXIBiPpbHioGI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D97O1w5y;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249153; a=rsa-sha256;
	cv=none;
	b=HuQkG3IHnm4cJUYZgnTMNgo7Rme6B9k+Hf/v7svG++Ab71xCimRp6OizM+4Q7vtD/5DpMI
	lh1oY+2CVMKYLDO19vCRaqMhB3S5lbiyFSz6XYCfK4sDnogScpw1nQb8TJAgRPoMTiJ78T
	4lJlsG4ENIf/s/uA/WVezl41kGY8Hac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38B17600AD;
	Wed, 15 Apr 2026 10:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBD4C19424;
	Wed, 15 Apr 2026 10:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249152;
	bh=dIKjmnqM6oUTiL+YZGK0NoKhkwGaTLfBB089nc7SMyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D97O1w5ysWxeGP7GcN3ChbzY+zPak2gSdq6xrWTDtQeR5AWCHEw8wkP+Vg/t5LFt6
	 ap42mjvw6UvD1y8evOqk9IL5Xv3v3Zel/SmtKXfnbZnYx8MaBYspUWulwAri/4KOA9
	 TUmh3YJiqY+SJ51dSWE7hRmVDXlVB+vFbOhMImsDY0NqDcCvCZ5wzVMvWY3cpo02zJ
	 HanYvjFWPsQX7N4wfX/iB8N8zTIkHc9pKXudi0++KNxAwQOVjTIFZz+Xrwb+M8X8Bf
	 hYQtAow41nfWTr0jb1GUxgkt6kNO4By0T64Sh+w/RsqXKNBr7k26wUB95m60y0wAPS
	 iFlpo1At1gmXw==
Message-ID: <eaa6386e-4de0-4d9b-a92f-ee4f6e4f4f58@kernel.org>
Date: Wed, 15 Apr 2026 12:32:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 06/16] arm64/mm: Convert READ_ONCE() as pudp_get() while
 accessing PUD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-7-anshuman.khandual@arm.com>
 <b1e1783c-3621-41e4-b65d-38cf66a1124c@kernel.org>
 <6d91c17f-2027-482a-b0b2-98ad258f1687@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6d91c17f-2027-482a-b0b2-98ad258f1687@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gd9r6f36e53wiburo1cwyfukfd755ahj
X-Rspamd-Queue-Id: B1457180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1776249153-461185
X-HE-Meta: U2FsdGVkX1+UeiBvOWaBoEDcJaeIgqRATyGXIqcjIVN7ZvR0yQmwaFLZEFccXCiehEJXtV8oo88FoDvzMK+Gg8L4/iKeIBNd+uRTkxWeH99srMoGbMt6QjAACeaXi1MQD0TE+G4kJjiFAdO2ylM6wkyOc5BYQb1z3RqIYP6H7Gr+tKqdkSqg2f76rJNIJZDfgrJyXhiTTbzFBVyDQiw4UIabtRkAqt3bMOJ4c6mFGodRLH8HTE86H8TXKxbo7LzgTM6WMUDruhhF+Lp+9eZGNspwL7WtT7SC7T4a7CqmajVa7UF/r6XTUQI4ECsBBduSQ/vevf9dJeT4Gug1LxKUSsE+dtmSGywmFdVXIG2LNPngDSsYQEufrSfy2M9lTNvKHSjGH6Tlpv5Z5D++hFXv3QOhvmCNzhmdAeu1RSqiK3jOyYh2HBUS37Tdxh+ZyrOlYWiiR9KxXC9/DBhQlU1LVX2jdN4TALJhDnyGebZZVibXJGd9cE/Y1pkGGr1ZpZdlWkLBsSUSVlFn4WqyHNB1rcRGDqn00fggVZppeDPk75xmm0Y1GsOvEqh/gobIubupBPvcvCudcjmPcctR4fLyF6/iLnN8s12/z3Iudq0ZAALYOA3XwjkAwLnCZyFCYMUWuTty+Rc3bg4YrDHj5NPZ3V/cZz2tqCNzUulJcKLjBaK49ZBiRH3j4O/Xy6OyF+jFSiqyoy/ILNt4Xiqlgal8Sq+vIBvyGI35CJFT36YZ5LnF/+jYf3F2nUlUd8V2PLNAOEHCOx4TVw/fZCuwdbb1IaVxp7UKDX44wwDKd5Q7wNcCM6ELdPcCmULP6sqXRfaQh5c5avftjCP0Gw1oe5BBGrNZzjoAI2El895yN/7Sh7NNFZHLAS1CVQCsSOvw2Uqh0um4bw6RkId7736ceLOsCxUc0Dx6h7NS87HsorwZbkxxmpQaMwjlrhSOH0Q2KiKDs+NCF/v/AJG+Y872zp4
 N/Rg7yqp
 401BN7xbB8HbUqccN6EywoYJ003BjHC990y4cTyTIDlzKYCXhqLK4SiMNPDmFIiPbAQkTNfl+fhOVRkm4WyfLaK0aaY2B7MsnmtfTexTInpSuFY8CGF7x0QkIXoIWUlQo+oFKzrPP/+FgF5PhNOxaUZ5rDKEegQydTmoeGjBFUScaYlCJp2z2knb2NjfS9k2fXLMfmPA5Q7gfZb/IGDda9bpz5SUQsT6Zzz2rAJRhzQ4opzUXEMy8JdSj540YTlqMPzGCkfHM3dIj5+FVKkOGz6XXd0+2wJ7VldZdzetMVL4ubRcEf0AdhU4ZwYKf8x9Y6o5B9rspwKXM4ML154CYS8Lj3kFVObGCO+BhJFSWjINcIZSTSBbYQzySQhB/x47pHJWvVwCx8gpvKvw91dfyULWTdmG8xx/aUT736OEYluIV1DeRR+BTLCVYNYIduqqMgUyWmgI2b/ygOMjf7C6PsHSQHBOyAw6IEShOiuVpdbsTmfkw3HaQta8gx28oCG4PqduP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 06:50, Anshuman Khandual wrote:
> 
> 
> On 08/04/26 5:45 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> Convert all READ_ONCE() based PUD accesses as pudp_get() instead which will
>>> support both D64 and D128 translation regime going forward.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: kasan-dev@googlegroups.com
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>
>> I was wondering for a second whether it would be better to structure
>> this as "convert READ_ONCE to use pxxxp_get() in fault.c" instead,
>> essentially, to touch each file only once.
> 
> But will not that create too many patches ?

Good for your patch count? :)

-- 
Cheers,

David

