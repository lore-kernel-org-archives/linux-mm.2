Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5A3C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 20:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81726B0095; Tue, 25 Aug 2026 16:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C330A6B0096; Tue, 25 Aug 2026 16:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B489B6B0098; Tue, 25 Aug 2026 16:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 933AE6B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:06:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 186E180145
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:06:05 +0000 (UTC)
X-FDA: 85140873090.17.DF16E28
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	by imf30.hostedemail.com (Postfix) with ESMTP id C381B8000F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:06:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F9U2jhQT;
	spf=pass (imf30.hostedemail.com: domain of atish.patra@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=atish.patra@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787688363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbjAz7qal9P/BA1hWjjA2A6ymhlraYwWduqNMnGPNfM=;
	b=3upO7hUknUFlW/IWLhXkVUyj6X5+vuHnVUW0G5v33ynnKbriBPj6AGg12FtCV7wYGgvhIW
	Ip/Brbd5fdIJiBV9Pmhhl5xgcQP/WikjfhbYLZIKRhWsINIUyM6TcB8x+OxQFxpz2th6UK
	HosNaIlNlgWwW7ly0MoL4t3vBABH6D4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F9U2jhQT;
	spf=pass (imf30.hostedemail.com: domain of atish.patra@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=atish.patra@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787688363;
	b=OOVIywmaWadwh6jC4Jjzinw4qorJtiwrn1u+TgQMzcexFAPnEjxoBxgpzjC4FIapPwkwma
	moaG8Lqb5ips5l9eA/HM9rhDt+9LWUWBzJvnuvlDg4i5rxyw7GxvcaQtQojK/jHvBQCaQw
	lObsU6IqASd654Gx85EgmPLS1N/r/aY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XbjAz7qal9P/BA1hWjjA2A6ymhlraYwWduqNMnGPNfM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787688360; v=1; x=1788293160;
 b=F9U2jhQTev4uP28NPHwP7qg9cVC0YxNRBdvTHtPArQ0MbbPTaCi1UpBz/QCeF39oIA6JP0zR
 q3SQEbybvl1aBmhYFEkjqvfjnKayhLneiA5C1OiukTjpvXQYs2TOhcIzmpdeENdoY+k20HLtQLt
 twS2PFIjdz9R5b54EltRitKQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1156:1:10b7:9472:4142:b7b7] (2620:10d:c090:500::7:759c)
	by smtp.migadu.com with ESMTPS id 9b0c0d836eb66a38;
	Tue, 25 Aug 2026 20:05:50 +0000
X-Mizu-Trace-ID: 9b0c0d836eb66a38
X-Migadu-Flow: FLOW_OUT
Message-ID: <ddb64a7a-70b2-4c3d-8b80-2c7bcd7f329d@linux.dev>
Date: Tue, 25 Aug 2026 13:05:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Steffen Dirkwinkel
 <lists@steffen.cc>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
 Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 syzbot@syzkaller.appspotmail.com, x86@kernel.org
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
 <556337a8-5e2b-45fe-a1ba-90a90c1f3c4d@linux.dev> <ao1EtJG_Gj8f90WQ@gremlin>
Content-Language: en-US
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <ao1EtJG_Gj8f90WQ@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o51jmdfct9613hf66f1mtbd8bc187h7k
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C381B8000F
X-Rspam-User: 
X-HE-Tag: 1787688362-550025
X-HE-Meta: U2FsdGVkX18Vdyh9E1h7VnUM7IakZ24ycERW7/cy89O0QIAsTxPn5F3crnYXynXbRVZReS8uOtnRxUiBq41ed1Mk9JpOfeODFEawTFMUWMTpz86hM+7F0JMnykaViI+kJNaB8eK7gFk/KX7loO91szHdJAzNj1oCi7Su69O35AxIsfKNaoMoppR9do4EOzMWLSuy76jU1kXvAoFP+4vl8eFuV07Ubu/giViZ9PwT0MxJnhi7v21mJbV6tZ3+5cegWyAHont8OGk/cX/SlcP3uk7KffRekLqIGTbg+/fWlxM4ExRscs6w41GPKddk2GZzJFeikbXqPqpEVgXNEi2+SfORiszZ8U7V+ofxtIaBcAe9U13hhopghuGKHx4tySAJE0xkrvDnfrJG8WUom2Weyj8fWJqqPZz+N4yXhD3DKkUSG8feptbIuAYFqMmRILNSU+gxhqt8ktfp/cO1sf5o/eefF7sG77jF/QZUMSSyQBLK4ZKoId1todir82exHbYD3wkU6qABsGJr5JdCxUfmr+KTjs4f1HuWYFpvWy5RPcUCOADlEtyGCcDVM2TxYGSGpKKKjbfq0oDTR6ITCXc7/TTfkevo80o2zWCbo/aHKJcFphyhz1Q3lpWDU/CBmEQ99xYrVpq4S+acJuYN8I2I5i84zrcXHjUyWOcfdh8IkWxg51MOL3DjnQPUdjyHqNtgZLoxGAnOYD3+y8btk1e3fR/GjJE72H5XLd8xQqj+hBriPuQwcuBHO4ibSZ1xrsnbposqpdGq6jMRPvvrsrf6U8GoXJuNhN2UYAivClTol67eoukKAndsEiovzhPPrzOM2/dyXzCrXGo2bjP2SmN3ybkbJwUGfpZTUUlZOWuPI5cruZvUn+nEY94wIqnTybEF9AYbaKE+CBBt276d+vbRMV+B1r2ahpOSUwmRZVkJFKkSYNIHz+LwJAsPt8Pn2H7f6rUKo0qW7KvQTGYLfvL
 3o9UTN1L
 KxRFXvdY8l7XOdqwer5f1gAfI/5f4XWZA9QW7qawMNqcbBhEr56XHCv4jfSdYxFDpol6W9IYhEGK7futJoPvEPom9pBiYpgMOy7bMqWsQ/DtzqKjmMO02gOxeSBbYc79Q6uTi5fwkdk0T+tYT4ZWXONnUTQKftsfmPFF7iy1x/2wLuFNCbZtvjPdS3M6fZhASDUnDaDAjaEflQJU1RPkDxPIu9RUfyCNb+iMxb9jCxtDCyTqBfGb/RuQFIov470g6Amc166Y6RfHkdXF1DJ0MbohgKLuNaFEn9eMCaHQ9TDCoNDCE4JKtrOQRdl9xjxOuOfRg4FMCqqZTSZ6yXks+BAhtTBdDjsTcc+UkGyf9BQWTFHLOAcHgwvIW8B4lZ57cxBUY+EGdTcAuup7byNHg8xJxRLBwYJF/zGOFwNZXC4ie6Wc+KlDeW7ooig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/25/26 12:31 AM, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 25, 2026 at 12:12:32AM -0700, Atish Patra wrote:
>> Reproduced and verified this series (patches 1-3) on 4vcpu guest running two different kernels
>> 1. mainline (commit: 77ae27fd98f3)
>> 2. Ubuntu Resolute 7.0.0-26 (production kernel hitting the issue in a VM)
>>
>> The Reproducer consisted of
>> 1. A debug patch a cmdline-gated stall between the two *pmd reads in vmalloc_to_page()
>> 2. One taskset-pinned insmod/rmmod worker per module over stock cfg80211/dummy/veth modules
>>
>> With the above reproducer, both BUG within seconds in unpatched kernel.
>> 1. Resolute in 0.71s at alternative.c:2564 (BUG_ON(!pages[0] ...), RAX=0)
>> 2. mainline at alternative.c:2473 (BUG_ON(memcmp(addr, src, len))).
>>
>> With patches 1-3: zero splats across 10 runs each (600s/11,378 module load/unload cycles on mainline and 1200s/55,980 module load/unload cycles on Resolute).
> Amazing, thanks!
>
>>
>> Tested-by: Atish Patra<atishp@meta.com>
> I guess should be applied to patches 1-3 only strictly? Or perhaps 3/5?

Yes. 1-3 sounds good.


>>> --
>>> Sincerely yours,
>>> Mike.
>>>
> --
> Cheers, Lorenzo

