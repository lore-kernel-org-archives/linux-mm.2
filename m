Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872BECDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D2E6B0092; Thu, 25 Jun 2026 08:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8650B6B0093; Thu, 25 Jun 2026 08:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B596B0095; Thu, 25 Jun 2026 08:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A1F6B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:57:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC79C406DB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:57:45 +0000 (UTC)
X-FDA: 84918436890.24.2D69DC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2B2C1A0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:57:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHmpLCYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782392264;
	b=suvmCuYMfzvhVD+LtKpe1oT39zHeRBM448s68aKNsFVnuASbaoyMZotnRL14w889f+mufK
	R3jOGr0nE07qnqtbjqB4BEVuv+MQC+XohBr3OG8W7QNDKLq54VcMuOwEikyuAU7XgshumL
	AIRhtpflrxKhQkJ6B3eIuUmT4gcZTB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782392264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBH/vS8hZh8Igpj0aw8/HaHtMjB3pKyKAfYdrgPsQCU=;
	b=BAWYy/gBtxC0xfdL3eBuBWrcUt8spWDdD+hmfVZ+dTuOU4LNSVE+Yn4CtEEaX4CZJFx7OU
	NlS0kMYGcpYHQeQ3Vfk67fvnYH2eT62rnhYgJ2tXjcBxgeaS1bRd6hJuDRF/8c8gwYWoOR
	wjnmOl+6ZTxKgNOiLVLkbKHH0mWA9Z4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHmpLCYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FEC84091E;
	Thu, 25 Jun 2026 12:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBCE1F00A3A;
	Thu, 25 Jun 2026 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782392263;
	bh=kBH/vS8hZh8Igpj0aw8/HaHtMjB3pKyKAfYdrgPsQCU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dHmpLCYxkcYHAnhShuZZiNteUIsANckSSdSG7HqREuNtilbYWQipbTko618b1Yqz0
	 TdmqsVsHCGZsqS/WBZm4cZsmyAR29Rb2Z0yEWyZqjWRGGDfP33LlQQ6+1lxyqZxoRp
	 yjEiovspVIARiluKrlsUuXuVAk+XCr1BoRB8pEztZQ7RjuT4jQfM5sBPW4JxKpY3v7
	 Yr8XpCL4sC80zDNED3TFkKh0otLxXx+aGAsD4h0vpvKtyevTGOjQ3tMZyxONEStJZh
	 27J6zBoo6Pu7SjU7iu4yPlyB6hd1OxletytvTKm7z4321BrdJn+b4w+S2Yu07TTkhf
	 WX1h0k78BILkA==
Message-ID: <6ed7d12a-c3a1-4572-8385-754e6d5b8b44@kernel.org>
Date: Thu, 25 Jun 2026 14:57:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
 <ajwMYCSrPlxg-Fok@google.com>
 <CAEvNRgE8HZDOnexMJeim6TjmxGG1AUXFY2+HH1YyKB=aM6D-DQ@mail.gmail.com>
 <ajx3vmNPRf-M9kR6@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajx3vmNPRf-M9kR6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2B2C1A0005
X-Stat-Signature: 7thz4waqgo5o6kpc1y4mpe4ny4k8m84q
X-HE-Tag: 1782392263-439174
X-HE-Meta: U2FsdGVkX1+oR/x9FwRMIKK1ZkVq5WPIN2b61thiNB41rwHRmla/4pH54HZITvKq/7K7H6+moakT51q8Wq40wCHBoyxP7tKepVaHo0DN7jXKJ26AX1k1swkozX7udyqhnAGeECIqRUPF3YyBETMrnPXM2HL8kQws61UOQqh0zR7FsylbaJKIXgs/hWFzUxoBDg4h+x7yXJuIXP8n+VAikqzOC28LXkrokztVrFEjJriQB+BibxneFhQb5F1RYp/wY0go25A2wyEEBdqhSMyxP8S3EKGpesROkFE16TUZTKuSbRHwNwVq8POcRhAYoqjWgkUMu3kZ0/un31kUC6zNQ16mbDaAQ8qDH2JaE6RbmjPWsAITFnAN9IzTlceShXSPWYvojoHg+c2ZjV+OpWTtpPYVAYe5BFl4PJuTpMdHdtkW2DD6rdzv6RVf/eLWBNIaNwG/GHuAMk0TumLDcU5eowovZ+EGKmNQR3oY1IVje7WbhpM41pajsf6w5qtZSqvM24+Pu/N5BrvfJ3FHseJrnapcbi2G0tGmEJyHBvLoiN+gZQ0mLDUXDYBDx/g9ki/3c+Qr3Ir3rQaVQoTe90qUxXgGEQsZU8WLAnIyYeTv4CMSz6dCapOFtIlgkHI3hw33UDq6c3vyWbpghIW6ElV1EWjMZCypXSAIiUHD3RpCmJcsnFlpEcK5T2sPob3pxOXr8Lay0YZWts5bDLgaHlLyzJ6mQVq/ope8GgdvCRTP6243oVVNb3QQGR4J2NzqX0+OA1TEHxnkGlJpmhuzCMBhjZwRWORb3iWRCvwbxF9wYeJKq0NgVuUuRGfmAMuMrWr53djYGH6lHBAYtT2BPIelU0yqkM1lgwYxIbkgiz7zmwuXeBcXtUwR0szwWHHM4x3TqxjxGA0CkjCsXp1WQh+TTISq2TfHXAe2SrnzziJWtmrMRrofgpXd77kjWxIGMn+7DFUCvAIEPm+vJGfh9MN
 k3oW9Mq1
 oWZyzLAnJlBrqOb3mY8pOqCvGnJUMJPr0RQw8Em8c1NgAQfjQhsWgugcK3zWITvGP+d89/0cQTGU5VffeOW9e7i7eEakdn9Akg60x9R6+9e3viOOtri9PW1gLd4Tx+6FKKZeha+EGkVY3qOSQCexx5jCzUjkh1BAQRz4g516aAlJdC38PCZxr89plrW8LNVBwlrV8yFl6wl3JyiDb2AYl7qiUmqw2oXH4IhBxpSRfE4/1KhlaTfb2Udl3nbeEukUe+uHiR/y+/k9dZ1umFHLHcvEce+mlXkPeL13APMQF3CK5NjuTANM8zjiISSpi2itBR7XCo1a0t2Dy5A0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 02:35, Sean Christopherson wrote:
> On Wed, Jun 24, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>>>
>>> Under what circumstances does this happen,
>>
>> It happened 100% of the time in selftests. Perhaps it's because in the
>> selftests the pages are almost always freshly allocated and so the
>> lru_add fbatch isn't full yet? (and that the host isn't super busy so
>> lru_add fbatch doesn't get drained yet).
> 
> I chatted with Ackerley about this.  What I wanted to understand is why guest_memfd
> pages were getting put onto per-CPU batches for lru_add(), given that guest_memfd
> pages are unevictable.  The answer (assuming I read the code right), is that
> lruvec_add_folio() updates stats and other per-lru metadata for the unevictable
> lru, and does so under a per-lru lock.  I.e. we don't want to skip that stuff
> entirely.

Hm. Our pages don't participate in any LRU activity (including
isolation+migration). Isolation+migration would only apply once we'd support
page migration.

But yes, secretmem also does it like that: filemap_add_folio() will call
folio_add_lru().

Traditionally we used the unevictable LRU only for mlock purposes.

But yeah, there are "unevictable" stats involved ....

> 
> One thought I had, to avoid the IPIs that draining all per-CPU caches requires,
> was to disallow putting guest_memfd pages in folio batches, e.g. by hacking
> something into folio_may_be_lru_cached().  But due to taking a per-lru lock,
> that would penalize the relatively hot path and definitely common operation of
> faulting in guest memory.  On the other hand, memory conversion is already a
> relatively slow operation and is relatively uncommon compared to page faults,
> (and likely very uncommon for real world setups).  I.e. having to drain all
> caches if conversion isn't safe penalizes a relatively slow, relatively uncommon
> path.

Yeah, the lru_add_drain_all is rather messy.

We have similar code in

collect_longterm_unpinnable_folios(), where we first try a lru_add_drain(), to
then escalate to a lru_add_drain_all().

Maybe we could factor that (suboptimal code) out to not have to reinvent the
same thing multiple times?

-- 
Cheers,

David

