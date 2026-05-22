Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A28CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413D46B009E; Fri, 22 May 2026 11:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4316B009F; Fri, 22 May 2026 11:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320986B00A1; Fri, 22 May 2026 11:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2031C6B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:13:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57656C2862
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:13:16 +0000 (UTC)
X-FDA: 84795399192.14.F14964B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A86F9180005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:13:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B4Mm/jjj";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwmdH4Y6VTSDIKPcMv3e/jCQbBDrDMuGZ7Y1gLKOyec=;
	b=L2Sj6D7HP8ucJGroUvSdMHgn/kEhe8ApH1IFmYZFzqNinkZJGHHVzOJTjgTWjcxq9RiiBg
	mH1EjVAN90737QQFGPXgyJXMK/ocR7fvmbzoGEAycsDj09+RGMrpKxfIQd25oAOT95f4kR
	LntELrGb9yWQ1bNUnKrUkRpEoVGyWCo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B4Mm/jjj";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462794; a=rsa-sha256;
	cv=none;
	b=eyK94IH9t25HJjVylMtfByeRqY+5xGX/J57/1o1EXfQ2rMQbyYLmBaBgZ8W7KCf/7IcJs9
	B/Msi710pspALxeftYImMwNzQdhesfxWxdGwbFv6j7qhQqToi4f1qJwp42B/SerPUwyjdi
	S9P+3/OutVdKU9DWqcp2kms7atmNDRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE44860138;
	Fri, 22 May 2026 15:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F43D1F000E9;
	Fri, 22 May 2026 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779462793;
	bh=FwmdH4Y6VTSDIKPcMv3e/jCQbBDrDMuGZ7Y1gLKOyec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B4Mm/jjjRaPcrfjt/1sddtWIF9oDFwkJhy8uNkcNzcagpwMifGf2KPjwymhlleHHR
	 5HNK7OwvDNBjLXWEPj9af7MgZHlRmxoDL/qwZ6cnJpskQCnW8hmazLs3TgKNXxvYRm
	 lzyGT97VT41Aou7m8eUL2m8iVb+IDoxlQptJ68bYSA07TITB8nQAaZVcWoP+Mk26vZ
	 bLb26fqEsceq7r/CYFNa82Lom/VqDZHBcUsCjshccRZjl0eWlBE2RtmRR0fOmB1UzY
	 H8/UBpzdN+qRqIo5BSb7gjwCFSwuoaK8UFaubsMzkK05bAGTjupZDSvZHyhHMwzNOL
	 1LQly0acqtMaA==
Message-ID: <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
Date: Fri, 22 May 2026 17:13:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1xhf7wbm6fk9tfguqs89jbbbbj1at1kn
X-Rspamd-Queue-Id: A86F9180005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779462794-804971
X-HE-Meta: U2FsdGVkX19TsWHKZXLt99sdPCTbk6VKec0qrJtBa5m0EqByDPNaSlqFK3jzJ+K0GanaM8xdCSoxNyOvrLT+CWLK+kH7qm3p3uP3gLSbB87BWrQ2MdSIkUqvdkgHCfnl0vg8P8jCviMvpg7OBUDP5V2j1DvP/pOP2dmnqCavLVK12qN/CnM4uDK1U9x9Au3MJF4yEj4aqd17TwcIaIT6U4VqGF0l++cD+dyeyBgSr4g2cfxcZt6hQcZLKo0zzc5y/NdckktcNRTJZEI+2xlDdAroxiw31NFzHXDy95n0BkaWUfJBxqknTAH41AJkjqKHAyemATckR30fu3IRMQ/NvscI5LNx+nDpXvD3kNu9XA1zHpAzQd/Q5eDF+FY4zw3iRbk/ZACmgI8NI/rOpIwulMZvzYcpH/TwaR+Zun5LwjYQTqfwbeVVs4KyTmx/mAwqpSfSUmG6UVhuj/+e9O299IVmxUK2iNImsvX4MAxkrSH+2j3vkLTRByld6gpiZp0J1KSSlgq5RFWanKp0UK9l53WcxlP7ausTVaLm7GjNIGbZjCvYCcd7uh+7m47oMb+Okh8yKe7RkgqIFfNAhCwgRMXaqadZoQPZBq4R9Zx9JXR1XHAShMkbVfDuGcPR3hBgRWXqvu4dNJXiNGZwB9HRlsrhztwAFs/sDevMoI8SM9smsSjewivbTBsiZW7DOqQIdsaRzae9W+y5+1RosyD/F8wZmcCISV10vJpzgUpqSlY9xpQHCMApTIp9DalM7RFgYh3xBO//sveF3QyEkC4jwqk6/vl642dSTmhM5Yfaku29G13J+B7zdba6lfbbCr60rETGJcFpNqXp9+ylTy8/uWg6KtOAIRxNELh6UcSLvBX6P4734hpG9/GV4TNhEr+qb0OPAcEYrAXOoe56je9Gd7qv3f1cb6swSlr5TAKIU58o4ZFWyg1nNwfcNYv65JiFYFwjbbCsjyA5ZfdlTWD
 GJ6qkC29
 xW9vNxy9gaqOAc7wcZ7zIVag1tiao6igtGtD/XEUsI/G/6rXtcBqIHnfVxJ2ngxKOXqnWQl0A8SDL9b+8DLpEqfDXZ6FLXb072/vvPXnK21kVTVr0WKD093SgUlxNAxAIfjF71g1jX1Izw7LoXHoXplIjoWSBd+o9Z2f5ZryiczQJJX0yY/YZQkAtbyXRRIn877NNew3f+TsquLWHTSqzJvj2XhOG233KL2Ptb9+IyO+nRtKKwNMtqE+igzCLRnSHco6sUrvJHAcdnYkc95Cyu7/E3fd/jSWVbPQMF5q2vajJvwut8gfGEqDYLoeysLJSeXxdHRYab9fNv5ueaMmT01iI+R312ceHiwG7Cxb01WjytMu2jQ7SXCogRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:07, Nico Pache wrote:
> On Fri, May 22, 2026 at 8:59 AM Nico Pache <npache@redhat.com> wrote:
>>  include/trace/events/huge_memory.h         |  34 +-
>>  mm/huge_memory.c                           |  11 +
>>  mm/khugepaged.c                            | 634 ++++++++++++++++-----
>>  5 files changed, 584 insertions(+), 172 deletions(-)
>>
>>
>> base-commit: 6c8cb505a5634594b3ea159fd1c71bce2acf3346
> 
> Whoops I manually changed the coverletter subject to reflect that this
> in on mm-hotfixes-unstable but never updated the others...

But why? That branch is for hotfixes that would go to the current 7.1-rcX
series. mm-unstable would be the correct one for this, AFAICT.

> Hopefully that is ok. Just a small mistake. Base commit is referenced here.
> 
> -- Nico
> 
> 
>> --
>> 2.54.0
>>
> 


