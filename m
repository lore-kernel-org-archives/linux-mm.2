Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD6ECD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FEB6B0088; Wed,  3 Jun 2026 07:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C777C6B008A; Wed,  3 Jun 2026 07:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DA46B008C; Wed,  3 Jun 2026 07:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB85B6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:35:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C466C1764
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:35:28 +0000 (UTC)
X-FDA: 84838395936.29.5037804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75CDE80016
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:35:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AOsCxC5N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TThOnuJSX9KK+vQX9xQjNnIrM9wL88++yVRScE8ravo=;
	b=HXvc9Uu55lNCLaQq8pmllZrMZyDjzytef3syqV/hUUHgzMQw9tJRGNLYJpzwRGPjHu4NTK
	5ShGwh0Om+5vJ7hwjjrTXjuJ0JuYb+cPhT9oOxs5nI5qaNcMKVDDWNZDCCnTZdAjMVBY5x
	/Bd/cBlx6V/gDniPJ5oKVOPBaNOv7ds=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AOsCxC5N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486526;
	b=JDWBTZNVG+Nz5A3WLmuPBi+KydC5S5g26Iycn0K6vIOuAwIkeTzlA+MO0Cb14F03RktkkS
	TMLvXcUj7m+O+sPe9V5MWAygRV2O2yUzIalxLkLckPEA2CHXEgrLBvIsjGzLSyDb1YF09I
	YgKmn6zdGLMWUWlPcHhdqLX7DOJERlY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC7F560052;
	Wed,  3 Jun 2026 11:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FC51F00893;
	Wed,  3 Jun 2026 11:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780486525;
	bh=TThOnuJSX9KK+vQX9xQjNnIrM9wL88++yVRScE8ravo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AOsCxC5Nj4eKY5rrTt8ykBjjVHP4EjQOuRlgU5qmQzYo1YB4+C7EEc8AaEbhjxhhy
	 nEiE+j4wrwQNpSaW2xj6+OPs6ZAy+18GHkt7Y1G0Z2IW1rgdoDEV/r3eWhxac1K7TA
	 Bh847xSZpq2c3knIERsiuIWDrE1cra2FMwJHSj3DUBaIgaDA+CAvniDmMCHNYZ48sA
	 cQAd6eL7ENlUe5S/9fIQG6IRMhxCp/F5c/bVWUdXvtO0ZMP3jVCuU4RgBTN67luAql
	 7O4eHyO6Xopz1U5hdpoIDcluFaHHb4CR7YLQ+C+hmBGjAqjXzeJHbh711sWDtEKj0Y
	 WmwJu6nMX+Xbg==
Message-ID: <10274d6e-0af2-4f9c-9788-2896065ec16a@kernel.org>
Date: Wed, 3 Jun 2026 13:35:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Andy Lutomirski
 <luto@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Thomas Gleixner <tglx@kernel.org>, Nam Cao <namcao@linutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
 <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
 <20260603114217-9eaaa386-a766-4336-8930-250c2ff91d19@linutronix.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603114217-9eaaa386-a766-4336-8930-250c2ff91d19@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75CDE80016
X-Stat-Signature: rniefgddm171ckqzrepx8w3e6swk81da
X-Rspam-User: 
X-HE-Tag: 1780486526-845494
X-HE-Meta: U2FsdGVkX19nZ3JLCcoR+4XIM+c5qus2O83NSeElV7Xq8n9QIZ0bInN9AaFF8WH58q7zv54l2ijD9s70MQa+lgd5R/7ekZkHgqjRgstBk2kILvEL8WIl3RI6WHQfNRXUuAj/JHb15TrTAAHxWmJsBWy6p6u/sNc32SIry7PtWmhcSv5yXjgna9EQTxh5iAXEZGDuDBXxej6XvyJmMvO9ZZv5mo5GhLXUrA+Kd3AHpIYrlj8jupYoeIP2m/clzXvv1Jl+pPWzA7C1zzUclKh/Cx9wgSY1m4BANaKYpwmJ9TV/4Q1vh5eM7aleBX7T6Xx58PVdOkNEE1Vi7EjAdGREO3KHRDrkjuxTg5wgXBS7nD2kMVFFR1q+aWJZX771W5Xqtg2lhVr+Ixj/J08eST8MTRTQcnI9637pCsO+vM1KB5ZceQIbFa87PJSy7//Pfdw3SF5YcnWrQoKKAe+gUcEHQWng92K+LGVdu5SanopRHecEeK2groHKoAUR+EsoP/eKnPZfVSPT7mE0J+AXQhYA7hzeFc8VS2cF4Pp8iSh9lG5uGOoqqdz8bSHRjUbAG6A0ZnMPgbf8RNPxtRxV62Bb1yqxj/FaeKgOuWqBYGSLUyw3qiDKUj6U1+wJ4Y/iAu49ehDVmeKeulh9YtMYsf1i51+TxF/3Tfami7/4ElEeKWRpCS3K2yLvmYaQTOuTbGRkGJB8Y1P6AxQ6lPYhzRcj7FNdj3XVsFdExcwI//eV7ofaTUAQD1MhGmRM9BRV438eXAyUXc8OtzLuhovf81JBh7sARH2WPw74CyTWilUJGfIlj+UtlVpU+by40Ft3Gr3ci3Ni6JFW3aYYNYDllgrWapJ22kDd9k3Dg7rpK6C6NtfMvxJqf6lXSYMbuShQCc0n72Nbq9O9rje2dZYORZH4x1FBFavZJMWPXkaSS23mJcY6yv/8/K0q48yUtd6doA4EzKSCij4QJTdRPjkGrQY
 hkUnCS0z
 6p1e4mg8G5Rd1A1gJH+GsxMVqZue7eyz5o+9ejG1CY23G8EqkfBNUfMzzGkPoKuLYgtuk4pNzj7euz72u41KetWOVH1SatZ6wsB2sbRl4ghGCx3D2pb93kLQ9vk7eCauvMITxPKJthaRRUf3Ke4LGd38HMSGAV6OYQibY8nCIXwIQwXHwZq/nped2QYeWu/BeCP9QpvK0xWv5GmnGJlLiaq1DdbU19/pdgx8KRQ24OhGzlQC7h9jgbbOkrDY2dxGpJQXH/q9PBxuNqCRPBdH+Vy+B6dljSGb13a3A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 12:10, Thomas Weißschuh wrote:
> On Tue, Jun 02, 2026 at 08:41:31PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/18/26 11:49, Thomas Weißschuh wrote:
>>> While mlockall() is meant to lock page *memory*, effectively it will
>>> also create and lock the corresponding page table entries.
>>> Latency-sensitive applications expect not to experience any pagefaults
>>> after calling mlockall(). However mlockall() ignores VM_IO mappings,
>>> which is used by the generic vDSO datastore.
>>> While the fault handler itself is very fast, going through the full
>>> pagefault exception handling is much slower, on the order of 20us in a
>>> test machine.
>>>
>>> Since the memory behind the datastore mappings is always present and
>>> accessible it is not necessary to use VM_IO for them.
>>
>> GUP also refuses VM_IO, so this change unlocks GUP'ing these pages and using
>> them for DIRECT_IO etc.
>>
>> Well, I assume that GUP-fast (no VMA available) would be able to GUP them
>> already. But mechanisms that don't use GUP-fast would get reliably blocked for now.
> 
> I am not sure about all of the side-effects of GUP.
> Userspace is allowed to read this data in any way it wants.

Ok, good!

> It is *not* allowed
> to interpret it however, which is obviously not enforcable anyways.
> *All* writes from userspace need to be rejected. But those are forbidden via
> VMA flags which as far as I can see are respected by GUP.

Yes, even for FOLL_FORCE (see below).

> 
>> I've been wondering for a while, whether the VM_IO for GUP is still required.
> 
> If that restriction goes away, mlockall() would work automatically for the vDSO
> data pages, no?

Yes. But I guess there is this "debugger should not read/write memory with
side-effects thing.

Again, the GUP-fast interaction is a bit confusing, because that should still
succeed.

But debuggers don't use that. So the VM_IO protects that for now.

> 
>> IIRC, we want to disallow read/write access that could have side effects through
>> ptrace, including process_vm_*(). For memory-mapped I/O that might certainly the
>> case.
> 
> There are no side-effects, this is just global shared memory.
> (But as mentioned before, writes can not be allowed)
> Accesses from other tasks need to be prevented, which is what
> patch 4 tries to do based on FAULT_FLAG_REMOTE.
> 
> The only data in these pages which is not globally shared and accessible
> are the time namespace offsets. But /proc/$PID/timens_offsets is
> world-readable anyways.
> 
>> With your change, you'd also unlock get_dump_page() on vdso pages.
> 
> We use VM_DONTDUMP on the VMA, shouldn't that prevent dumping?
> Dumping these pages is not a (security) issue, just pointless.

Ah, right.

So we still have

VM_READ | VM_MAYREAD | VM_DONTDUMP | VM_MIXEDMAP ...

So even FOLL_FORCE cannot write to it.

It might be good to document the change (pages can not be GUP'ed, including
being read by ptrace etc). But I agree that it should likely be fine.

-- 
Cheers,

David

