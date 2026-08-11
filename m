Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E57BC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEAD6B0096; Tue, 11 Aug 2026 13:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6006B009B; Tue, 11 Aug 2026 13:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDC46B009D; Tue, 11 Aug 2026 13:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE52B6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:51:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38E421A017F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:51:35 +0000 (UTC)
X-FDA: 85089730950.13.84C3847
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 781B114000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:51:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEtG58WZ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkUWYSo1p4I7KyJCkRY80edi6N6SRNlEyVr8qwAlIsE=;
	b=tTYu43P+5m59OMgeZp6CKpiSCOSXO/Vhwnc3LHtDdR4IrwjU6/kY2CTXTHaj/rhExs9fQL
	/fNGusWe8kvGdFFkMGSGykNkBTCc/ah9j6FcvxpTJPZlX/YaUWnvY2LD/X/9Sd9wqbf0VU
	nfkmooCz57JaVtd9NGJP9d1KVHk6QHM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470693;
	b=YvsXGaiV6zzn7qcwEhgYSW5Di+n+kKeTp2ysv4z3chdfrsPkYgu+FVM2xHpMYqXjpx9nEd
	UkY6k3a4MOoZWezKoe4uCzzknMz+SiRZLZ/K0bKWoCME8i2yLlabUiJR0T0vhfO+HuKfYg
	Q52q3F+zKSXET0MMJg9LLiZ1wYvhpeo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEtG58WZ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 017EF600C3;
	Tue, 11 Aug 2026 17:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9391F000E9;
	Tue, 11 Aug 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786470692;
	bh=hkUWYSo1p4I7KyJCkRY80edi6N6SRNlEyVr8qwAlIsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CEtG58WZP/nb7XjOILQATFtU23EQe1V5++85x1sfQItE9pg9SrqfcAdIwolUaHOdR
	 k7nCkI9LJYVKMsmKJX6TyvhshyBr9/7aIX9RW77T3fXsjlKM9geAVDvrLNCZO1rEps
	 c58d2fJU5s0F5yZtsKnD0HlitOMct+60SRGw6uYnadSz0nd6Gn6ujczut/UZL9v+ai
	 ipGUdRsOTpBfE9/KApz7HXjbAh3ZmbK9Cic/hkIIrLb9aGYDPyCyPciqFkeq7UONxT
	 t1w3zyaU0Is9AkP3G6BxapYcxBlwPgrkBymU0FhN7dpYfGz5nDK+yujgVoPxU3rxnh
	 v9uwmxzNSdtmQ==
Message-ID: <fc5302dd-77e6-40d6-82fa-b08b27da4ea5@kernel.org>
Date: Tue, 11 Aug 2026 19:51:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
 <dd9ebd52-7171-4353-8c83-9363019d55b8@kernel.org>
 <CAEvNRgGSK9tO_-TvQvXoMwVwGygh5WjjBUOY-zLOA5yP2DwS1g@mail.gmail.com>
 <anpqcZlwvjWCWGId@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anpqcZlwvjWCWGId@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hyjjycer8hhh5ico4dkus8x7n79ahmgf
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 781B114000C
X-HE-Tag: 1786470693-122120
X-HE-Meta: U2FsdGVkX18Xb3SqC37I2zyz4DqlYCUzrv/NQ30mHigVlLxEGG9vXxipnYQxaEd+BwegYrG2VTnEeHMNZk22OgD+W8LZWcxEUpwuo9iuxPIjbMed7xHbKYWZYUVCsRl2pSWtbjRcjlr4SbW3HJ/A9M0/HgqrAyAAvlY3HgFW4c2eYEgqu/O6nnZt6CumKLJj6NjzA5DNk3yia0RBxLpxDQaNe5zDIHh7kGjt6l5eZ5l2g/glF9PNkxO6OF0oN1Ek0JIh3TpTZg8KmunuZdKAJF0wurq55JeM68tYD01eWMQ1qc4DQVB90pWLc9VNnsscgqqraTiRfi9fZtOgGYmmT//FhfSLXaoTnnpfsaMyYG6Fn88nGK6R4Ir3blpOdsExvtRgjMBk7/Dsgg5zN4gRXfEGsyqNApbHkGW6G5koO1sq+L5/XTBAvbBdcKBBnmV7l3NlP6f9K66X3SP6tM/sNLgv4NDa+RP4ct/SoU2zag583ntB6YdhVmYPxfsUcYbTJK6eARwxCm0xefiLxuff2+yjqZTwbQpWIp4ernrITxfxlwlYe8bZbGQdZvenQrm6FpAn+mOMRFLWuaXZ6zYhFqVx+3/WLbi/hnR6hzscrzoJKlqi9vCfVX6bduCxQYP8DrGimMHx99a2ceUqvvBOW3AGlSh2kuCezIXw+yAC9j/8uxHKkObZhpx1mgZKAz5WnS4bFbXCN6crulWDnmhCmrVQPY/ZN7ydwlsU+WmWyGTEYpGx9tqkKDcW6/ZZFZ9TI2kaKDlsIZKITMnRUsxBxRiey8VOg0mYW13q9vZuKe98o3GDPoTszXdBzT/QDJ65FCaUY5RkZ854ALVJHsLwET+zPIYnkrBpvomZP3duWE56ewiiUodsR3aufP7ONwgfBLY9NBZkUiwz3DhNW08oFUeB12QtDM6bS1OkSz2RnDa5nUoY01bv7ypPIwO1flCqm6kM3+9LmH86PZj7tHZ
 0HLkumCC
 x84OiGzEykZuSTTrc6ogsrQwWE/lvplwY5eV2e1qPQ5U7C4nmxAC3NJcKqB9nQK/hq82lULhhp/xNOs1ST+aNXSvywHEmBIBBxdPyh5kSazjRFM78YiyhihAaFq7p8r6rWMzmf8BNib/25wsaIVfei/DtgAxSEAzLbnapqyQuIGez+CvqH72b4pwHCi2ildHOGNedwURHu0I+Pq4NgnozvmVkOw9tXjf5MTyWxQ7k+B0NR+WyLpgt9dX5/QAtyoir3nZ/ByPspuJI8u9tHDD4mXlUqOQ8k+QMIwFD7mBFnq3AKL06ph9gPun3IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Previously, without in-place conversion, populate never reads memory
>> from guest_memfd so there was no danger of leaking uninitialized memory.
>>>
>>> In case post-populate failed, do we want to re-zero the pages?
>>
>> I believe we can't re-zero the pages. When SNP fails to populate it
>> could be because SNP didn't like the CPUIDs userspace set up, and after
>> the error userspace is expected to check what SNP likes, then
>> retry.

Ah, okay.

>>
>> IIUC zeroing will destroy the message SNP wanted to leave for userspace.
>>
>> Michael should be able to explain more here :)
> 
> Not Michael, but the above is correct.  If firmware rejects a CPUID page, then
> KVM copies back the expected CPUID values provided by firmware.
> 
> That said, now that we have have @may_writeback_src we _could_ re-zero the page,
> i.e. only zero pages for which @may_writeback_src is %false.
> 
> And _that_ said, I vote "no".  KVM zeros the memory mostly to ensure userspace
> can't read stale data, e.g. someone else's data.  I don't think we need to
> guarantee that a failed populate() (or rather, whatever ioctl called into it)
> will leave memory in any particular state.  It would be easier to document that
> the page contents may be modified on failure.

Let's do that then!

-- 
Cheers,

David

