Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B3DD116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2056B0007; Wed,  3 Dec 2025 04:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A596B002B; Wed,  3 Dec 2025 04:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08E96B008A; Wed,  3 Dec 2025 04:24:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2EE96B0007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:24:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 149691604A1
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:23:59 +0000 (UTC)
X-FDA: 84177622998.03.662D717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 41B5F40003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:23:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cvu5yFI/";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noeidY/JxZUlaO2BBPuBf7W+PlJySPwIeLEw72dpWi0=;
	b=hbPMl8dh4K+LMiyYFMQ7pSN5B5TxY9HrapOKZ0iy+tKvcL5OGeCfN2FNl6bB0DtQTAfomd
	ndl/2MtyRmI5pUnZC2R+snrURW0PIbfD1kE0UMrXikbEtH+RclD9+5TRdDdODZoItzpYnx
	EivgacZdpHqSq2fW8towQJLaRw1J67U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753837; a=rsa-sha256;
	cv=none;
	b=iz2oQk+bKh2iDd/6qHnT4ATw7ivWG2iA9VRzQ8XH6u8NbtSEhB59bNDFI2oiLXgCvCKtgE
	1lBpYE7E5mLfUCPwH6CLNboZFKd4dmVyAQEQToF3DkMM+q8VtwBln5S2MYRrOLsnmBO+Lh
	mz81kW2cHrCj4tPORCMP7PIMl4xJVJM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cvu5yFI/";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1343241AD8;
	Wed,  3 Dec 2025 09:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E1CC116B1;
	Wed,  3 Dec 2025 09:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764753835;
	bh=S4e+WORc08941gqGHI+Qfm/GmNkEJ5ySt5lGOScr0z4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cvu5yFI/MWJfoPp0dnwR0P+NhuCgNI2hiu03Tf6XZELP7zbJQpqm5isUjY9e/Tdfh
	 T1FAti4re38m+kkle6trKUG6LfyK78Gorj+43AS2e5UAaONj+LDyx6102ue5fHUWS6
	 OWQCREZ83ki2v2ja4OzL7nuPrPyjIF9xnFm7IcSjDbr+EcpfIRDxFigHPBc+ze8C9T
	 DsmjFaKLsK5OTbq0yP2MUJdYQq+Mr6/7x5jCf3UlJikpFhCn5E7Tyafj+CHKqJ7j/d
	 df7sIZoXwXVkQsejcLEMJuSYUCn/VVgUw/1IjYzOtcfs6u+RP8EKhtBYbWSfEdziKj
	 RoG6FWK4bU01Q==
Message-ID: <69bfdffd-8aa3-4375-9caf-b3311ff72448@kernel.org>
Date: Wed, 3 Dec 2025 10:23:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: kalyazin@amazon.com, Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com> <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41B5F40003
X-Stat-Signature: zsmgoyr9s4yt5cbngkbnfqfeozuues5m
X-Rspam-User: 
X-HE-Tag: 1764753837-347701
X-HE-Meta: U2FsdGVkX19UHeAMpP5iQJECZuqsfxxhOd7IcEE3Q4i1F5sEXMkkv3ph4v81nSrgbsxnTevMwEbL15/hh8xXxP9pZMaW1hupiy92M+R8vd/GHiP2wJMLHEpethXWesQrDlbOZ2E7HBTI3z2wlqR/eSBAHjQRmA0hxfDwlhUOAp5z8jwrWnKOCKes0cDN0hPJllSo7CLBpfQWnut5xlqIiAJjaYe8SLFdMwDqB+2nMD3IfTZa02YjsGIf5U2s2HFG0XZMh02tfNqzu0Ju+U0V3FKz4x91mk4GHdDd68DQ9BSx74vjw6ibXreFsBWRQW7ght154QrortU8NbWtTE4rCkjSBV6AZ3S1X/QH8xw0xS6x0DmG/Y1M6PGFtAT/DF45KmECi8aK4pdP4fqRHyIDF2tRQZq3I7lwHjJBrX5gWAdynZUHvay8w8DsjjE+cnotz7FwmYSiclRhrBOkBmceQXIplB1s2OwsLn0PedLmMlZyOLCtRiV+DwM4RL2f46CzBGg/vKQov98ocFVJyUsFlEnGCRFJOPqpow1FsjDuf9ejXOhm2zJrr4QlVRnE0v6jfJy0ACKAL2DQKCG2LyadAASKguO3DDJKbzY0aAiuIbqE1VScUChFtBCAIQj+hYoRoGi1oWZfTqicCK0a4B3qz1G7vExvecxTwhRy0C6qTP+ZsnO9qQ5vbAC1yiCb5BOzPLdCW/SDfK0Zod8AAtyz4tGgfJ42CsINVcBKQBNuFen9sFkFVtdmoV5CoJu6p5Wqr0jkO2iXIUTPMDwdCs6u0NyfIVFKL5uoY10yixRxlwjsS2dBi2c+ILR0NWBTuMnfriuyJ+Ad5+a6rOIk8+KvntO/k9lxxIjiS+rNZ5YA8AJphmyUSBFDHHHVGkTG9CguugcgRouUWmRYE1JT8Bw9u0Ee5icwwff47gMoo0SpWCudvr/8TniPWnYDwPwduwlrArk8GIiLy8lEl1eGhU0
 2PkFPEyx
 Sn0t6+rSRlnlae9Wk9OeHsLhuOarzYhgibbGM8baaxjVtCS3Ch8B/x5j7Sz4V4vwS3yXBz/+WV6BszNksM+MVmBlW6d31fxjRk6PZXeCC7HU4IkX4zIVok9c7oxw3/nsuAdG7i7Sk85Pl18cvZt0HXMYQwEbIg5/Tk49itjBp/8k5ijwaBpjYNog7RiTZUWPPkkG6DtDDK//9FAQ3ptLQGgDv8Z0kClMxO6lfHkV6tTNF7MIOIkgCRm+FEYfx7x076oxFlTW7k5fl0MZF/IR16BraIjyAmpwPBW5HQpfEcVKXwmh1KsS+mo4qlU0a+Oe9rrv5qufCPZjM2xCtAbx4aP/S0AAhgdgCtdxE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/2/25 12:50, Nikita Kalyazin wrote:
> 
> 
> On 01/12/2025 20:57, Peter Xu wrote:
>> On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
>>>
>>>
>>> On 01/12/2025 18:35, Peter Xu wrote:
>>>> On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
>>>>> I believe I found the precise point where we convinced ourselves that minor
>>>>> support was sufficient: [1].  If at this moment we don't find that reasoning
>>>>> valid anymore, then indeed implementing missing is the only option.
>>>>>
>>>>> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
>>>>
>>>> Now after I re-read the discussion, I may have made a wrong statement
>>>> there, sorry.  I could have got slightly confused on when the write()
>>>> syscall can be involved.
>>>>
>>>> I agree if you want to get an event when cache missed with the current uffd
>>>> definitions and when pre-population is forbidden, then MISSING trap is
>>>> required.  That is, with/without the need of UFFDIO_COPY being available.
>>>>
>>>> Do I understand it right that UFFDIO_COPY is not allowed in your case, but
>>>> only write()?
>>>
>>> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
>>> whenever we resolve stage-2 faults as they aren't visible to UFFD.  When a
>>> userfault occurs at an offset that already has a page in the cache, we will
>>> have to keep using UFFDIO_CONTINUE so it looks like both will be required:
>>>
>>>    - user mapping major fault -> UFFDIO_COPY (fills the cache and sets up
>>> userspace PT)
>>>    - user mapping minor fault -> UFFDIO_CONTINUE (only sets up userspace PT)
>>>    - stage-2 fault -> write() (only fills the cache)
>>
>> Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's series?
> 
> Yes, that's the one ([1]).
> 
> [1]
> https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.com
> 
>>
>> It looks fine indeed, but it looks slightly weird then, as you'll have two
>> ways to populate the page cache.  Logically here atomicity is indeed not
>> needed when you trap both MISSING + MINOR.
> 
> I reran the test based on the UFFDIO_COPY prototype I had using your
> series [2], and UFFDIO_COPY is slower than write() to populate 512 MiB:
> 237 vs 202 ms (+17%).  Even though UFFDIO_COPY alone is functionally
> sufficient, I would prefer to have an option to use write() where
> possible and only falling back to UFFDIO_COPY for userspace faults to
> have better performance.

Just so I understand correctly: we could even do without UFFDIO_COPY for 
that scenario by using write() + minor faults?

But what you are saying is that there might be a performance benefit in 
using UFFDIO_COPY for userspace faults, to avoid the write()+minor fault 
overhead?

-- 
Cheers

David

