Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CF3FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B93C6B00B0; Fri, 24 Apr 2026 15:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091606B00B1; Fri, 24 Apr 2026 15:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2BD6B00B2; Fri, 24 Apr 2026 15:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8DA86B00B0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:25:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 690EB1202C7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:25:07 +0000 (UTC)
X-FDA: 84694427454.21.B199609
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 886E61C0012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:25:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGs3mmbp;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hd8MGQNQ0vs6/pjt6NvxRQ0PF0JI93MoiYbOCwZBUec=;
	b=A04sBGd4GtpKUCf38qpn5OEy2sNBwm9QaNxKtzjcJAkc44OeLFzZOnppfxW5z+uzAj7K7G
	azUsDcR/viXMV87Yvw9sgnJx71oHdh6JDXqPQJFdpK6VsAAZfBdZgOsfTyRsx/lLfsmWvx
	hJrS1OOrZf6iufqI58gN8ZiCnDCu8L8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGs3mmbp;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058705; a=rsa-sha256;
	cv=none;
	b=fQPMK6/iuBAyvsxv+YJtQSnILN2ZLaclobMQqWHpTS3T4QaHorr2N/xdcRoCrqTKSl2jA8
	RN5i8UbReBV+Yzq77s50aGZ3W7MpZfZUl2HKbRWO+W2fKrp1JY8gskjNGRLmpCTIVc5FIL
	WT4+IByG0G73eVoeCahbq9Nrp0JrK5U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EE8D4427A;
	Fri, 24 Apr 2026 19:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEECC19425;
	Fri, 24 Apr 2026 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058704;
	bh=F7k6cjRg4CFixZ/0jQLerFH32svmezAB7nqzyIjg15E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UGs3mmbpDlum+/IWv9fKQBfKk6bexijAUEvP9+2METrUAY6R4ht8G8ral2o6X+bu9
	 RdEBv/WyKHq8ADVxi3SqY+sF2pUl8uJfSjU1yduJppRz2f05hQhc2IIPMVJW1DAt1K
	 avKVyZGckdxk+2JE6pmf1bJ1JwaPO/lTAzRB6Qpzo0J6FDEjnAZfw9cOPIFFQEsAxm
	 c6++FEuBIF7TQVA3CkvFJpIiJgI5Y31NNq2xoqvqx4BrJKtX8Yw7mDr557s+QkGNsS
	 UL6xfOwr4CTgzip0iDGp9QcZezu43w398SoAiKvMdYqbEiAKAe6rwasX7diGO1HdSd
	 PHaNPs9DzImRg==
Message-ID: <3cc55400-dc0c-4746-8a8e-5f8a84f360e4@kernel.org>
Date: Fri, 24 Apr 2026 21:24:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
 <20260424191703.GB3783056@noisy.programming.kicks-ass.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424191703.GB3783056@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 886E61C0012
X-Rspam-User: 
X-Stat-Signature: fqqs3mfrudzk8ym1wztswrfb8g3zygom
X-HE-Tag: 1777058705-766969
X-HE-Meta: U2FsdGVkX189WBA3MgJogRB5xz3x43zuO5aQc7cz9SJRIUU/Ly3DBjKPxHHcFC6M8psCPNRBIzGaBxvHExeaGfWyUTp9a1gAGvdE42j+iaHg7o7fpNmQ+N1NF/FQuJ411o7ur6DLl/d2q/pL2k3ob+gGLJeAilCuOugL7LB08FmKD6JJyb5F0Llku7m4E3zgnm3vPdqPfzNEcsVBHq3c5CdERxiKVdzSMoqnIfhKKAbE5OIphkGcxK+WJgOp8OvZuUgypqLcD4W5w53g8mV7PpmLOB9iPDi8QnbpacMOs10H2QiVaOFATDZLjNkETL7CJV/zyaSXzaQNWgoek/tbKCOI4JVTxeC92E4D+9CVINxw2L0n1KQqSj2OXSbpGDmIPEkgCENsSA5MUkZOhFhw3Z2bag+CW7FJYVtWjZgMrZ91d6/6Lj3ZcIyyCLsbgA0tjIGYJr26e2bK29afRWXmZ1j+KMKljcjMxpswwfIDuCRmDLEfbd6eZluFkJ3Wpsvzd2M9H565tLaCZvdZ9Fx2FTGy48yyUdqMnfssHGY/bYSCxfH7XjxfyqGqG5PDJ57gQRiG+Je8G7pGZ/aHzb9samjLGZRveJLZoRhdOBVWUIVb5u6Pna1XKlS77LyUZIE9xN73VxOaq980j20NNdbj3ARo+ZQPEFYwXJrXo/EuJ/XW8P0tHWEUHMmouWD2Et2Pfm1KCa4088DZtmdbBWCIzlHUQErMt9IdwtNSXt6mKy51LBix9rYlRKpfCNGO7PT4vv5OXzDyNF7wYX2qNWinwSKbkaKv7lFvUHAPFFxhP6hiipCAVtluUzSnxnG3QJOjYmP97+YZlqEEVACdhJGbNuId6wSvyZg+g3veQMYKZuXDBpEJ75g2YK/6/okWxj00Z417yIQ2tTysjd6edVEAFW7DuDe/GXcjUHDlZJ1G10cQHrflC9c368BdADzBQ/Arfe0nFRlP5CS1Y6l7hI5
 xvdnQ5Gc
 eeElLSdEefb8aMAz9j0VJNBAXVx5tuTKt2ASkZk30M5NtUDwJdn6hQoKvdWTfvD601UVt8eAaNnnq5SYnX/qVKVR/aRkNsy92Y8AQx8SnmYwVCOgSg03mJ3r23za9rlFMmsS6ixrVYOdyKgEmWg15fkfahgbgQE78oLQoWmkct6ygR2iQqYr/R36U/wI0boVWSWY1aQrxgEocziJyktRy6T8OiOAd2dqgc76JbcV7kOmMU6liTfKO4hTHhuCwO+Ej0yLj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 21:17, Peter Zijlstra wrote:
> On Fri, Apr 24, 2026 at 09:09:21PM +0200, David Hildenbrand (Arm) wrote:
> 
>> Forcing contributors to reply to everything. I don't like that, in particular
>> not as long as there is no way for contributors to run it early in private.
>>
>> In most cases, contributors just do the reasonable thing: incorporate the
>> feedback in a new version.
> 
> Yes, so I understand that you can run it locally, but then you get to
> pay for the tokens (and sashiko burns tokens like dry grass). I also
> understand why Google/LF doesn't open this up, its a money pit no doubt.

Indeed.

> 
> OTOH, I see this causing more reposts of series than we would have had
> previously -- and we all love more versions of series.

Fortunately, reposts are easy to review, at least for me, when tags are properly
incorporated and the version diff properly describes the changes.

> 
> I'm not sure I see a solution, other than to read less email -- its not
> like I can even begin to read all email I get anyway.

Sad but true.

I consider the last AI review before something gets merged the most important one.

-- 
Cheers,

David

