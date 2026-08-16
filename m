Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD0AC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F736B0364; Sun, 16 Aug 2026 18:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041036B0366; Sun, 16 Aug 2026 18:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71466B0367; Sun, 16 Aug 2026 18:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADBFF6B0364
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82AEC4063A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:13 +0000 (UTC)
X-FDA: 85108617426.22.1E93289
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E19740005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uv9iAiBe;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRJG9crnjSHGaiMl0ul/ePIhOSVGvO5xGqUR928BxPs=;
	b=rj9+DM3Dz/IjheqHzPFlJOudd3eeoVjGg4glJcuzV3k0Y7p4kh7ZT3HCQffKFwLFfgxbhE
	cHDYrS5eYkXhSeeKkUnsjW7k+BGWlo2fDdylqCjJpZZ0xQSHVyhfqxzkjcwmRH0OMiupFK
	bc3zpTQ4nZSEVqhGz4OO31DiqPnHH38=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uv9iAiBe;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786920371;
	b=fa5rGLr115DpvS3M66i2Pkr97HtkjHjCpcfrMfnn/Sa1o0p058fS9Uvv7OLv14xZzhGggG
	MFIW6l7Ja7cT8c0B6epF8OgQBwvl0Cn0Ti+zK3YtQlkv/fUAk4yNonR8vHxGT38BFBHZIP
	45OhIcHT2uOWxl8nTVivpsMEFHKy8jY=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso1661164a12.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:46:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786920370; cv=none;
        d=google.com; s=arc-20260327;
        b=KXzZhW0OwvD6TwR/i03Tm/iDZVAs3U3bXnOxQyE1fL1SfgpAndt31Ty0fWPJa9TdON
         nY0WVkzLPLDxttgzpZCnILiPqaquKOTadsNxo6WJS7RQS3veFioY+rLArzH3FOUxeA2i
         4ycKpcLNdKk063ycywlc5ucxzclADl8zixwFmoGmcltpxeCl3kvGBiYS/XLqbQQjbYpf
         wmmUeXDswjlkP3D9/gx0aCDLtpIk5Yqe60LYR9ngpDHQT4tpkayooOsBkDC477oIDiZT
         6eB3KulktkUAQc8wCgGmGsQNf4tQ5iNVGsjLsNGwprS7BEn9rbkWB863h0cuWKPFXN35
         6zJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=uRJG9crnjSHGaiMl0ul/ePIhOSVGvO5xGqUR928BxPs=;
        fh=zzyT/KUuCx8iLzzqO4afK7vmkql9Inn/QdnNiJXrep0=;
        b=RvNRoB9CRCUhzaHnRVTmrjmh3EKLIS+m5tMTFQiEhT6bymTw6Nlc6uD4MN4p28q8V5
         jA2fgLPddMJm8Y+1mckl+QVrYWZwvSe3r7yJ8t+D1F0f9SFRoCwAMlqvZ7/B38RCQkpG
         0vvgaLWtvTbPqRj8vXJaapJQ+Wq6z+JsVOB7fe5JPzomX8vUFtVKj5xeYRDN/aJEZp0g
         vsmF1wJVTpvl/AQ+0Kq2JgR5ovqfq0+jwsIeWyTc18SfbiFurA5gfR1COHgvnI5EA2Br
         iNYi8Zzvo8bzJjAAMiSWPzmqEf1qbSAS+aKiEO7MZGHpAiVI1xCtpnjdYudY36q+jvnb
         L09w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786920370; x=1787525170; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uRJG9crnjSHGaiMl0ul/ePIhOSVGvO5xGqUR928BxPs=;
        b=uv9iAiBep5wsdH6YaQ2blk+NDcHoAFRc240KzIC/ufCa50rrxNnUjpzlGWhZntkZiX
         7+iICGG/Gylj2orpy2XukcnS0Hk4AGP2UnRXUjIztFG5jZ+1T8r3kv/Rwb8qDbAZeK/x
         +ZWWoMglnKqyDV4eMDABT/NsnJv85c2Kgnb7ljINFpB0XC3Rztzr9kxJ55xUPLFKWJNG
         7xtP2wROPf9zQv5/MAUP80POgSnIaxfdSdptT83QVnVCZB7UGstkWN8Ova3rN8YP2Agu
         dt8mmRO/0AXENyNYF2te/e03jc/qMX73tstxodorkQ+2y9PbOKG1DMv4oXJFh6pS0FIx
         x9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786920370; x=1787525170;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uRJG9crnjSHGaiMl0ul/ePIhOSVGvO5xGqUR928BxPs=;
        b=L1jrbtVu4qeXN0wra2UWzG/6BwG9FZxJtvRtumvr2zpckklWxsYeOGCEcYTXdi7TMV
         MxwrZ2iLA5W+/sFOgnARjKBgQ6OKqfgFWFs2xTFXhE/FP77XsHBClJYGUErVjYdwLjNc
         SYQjNR6Y+o2Ic84gbc3mGecED5sLSiLEzFSBrB4gqRUYKPiZg9DnhFU/4H9ZP1kYWrnJ
         TWdLV/PM84s0zmFASYLAxFuiaWuHNnmRlRCQkTrK0WJI9ProRQKk/O3DYSpQ1sNaVIyt
         /hDMu1zHXort6V3cTPcZxrHMU6m1DaApw0/u/aba6vAePtrtqlzaVy8D+m6u/aQoafmV
         KngQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBp+j2P2vQvMMbVWwPYNLPcTD1f/6Rs3U1zGUWf3udAYHBEEq9IhPQlhomBRaG/s854e5WrU65Ww==@kvack.org
X-Gm-Message-State: AOJu0Yy5ZuUN3JpU1pNNCjDpfTVXHWTbVT+ecHSnAWJ86oCWa1m7b9de
	9aPNX7S+HVQ1JMzv0LZZxT8nqS1+37HSecut75MtbzszoQSjOefr4iwq/SWTD9FBmN6qjbryj6z
	UFXe1WnReKppGiByf9Ns2XgOAzkqNdtCYOe7GgPlm
X-Gm-Gg: AR+sD11nxwLYKNCy5KsoXxAXdvJAuzTK1xb+93ip7tjJiI/LkakfhqFtttaKIWV7ej5
	TF0Ia9pGjkW158JUWMnCkfDyLS7/VCyWG3vNtpXXYEqVj4nE122aTqB3nuREuYfhoUimoD07rXU
	7RMdWhb6KqOeIxwlkDILUfjRXVYEvzLMvK0tOptGOluarEGuGzAZXaeTPH583sQHByjyvxkw4rX
	l4t4wcSxMrG7u/HaB1+47pZCyGodM+eJkN6NJEnsIvVLAZtM6lcHuSh8SIouBWTEqc5zPp/PqUU
	I2B7274AG9pVOc8ewz1rqYZUd8QeZRV7RBCtjZeDTvj6OvgY4EqM+ydIFEPRA9RzbxZx2xs4gJ6
	1bQ==
X-Received: by 2002:a05:6a20:748a:b0:3c3:a9e1:a819 with SMTP id
 adf61e73a8af0-3cc71fb5781mr22866718637.24.1786920369447; Sun, 16 Aug 2026
 15:46:09 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 15:46:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 15:46:08 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <an8umm0qisEidt4n@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
 <an5AcEG9mqDgnBYk@google.com> <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
 <an8umm0qisEidt4n@google.com>
MIME-Version: 1.0
Date: Sun, 16 Aug 2026 15:46:08 -0700
X-Gm-Features: AcwNN1VMiHczbSFfHuHVB6i-2Pe7bEu3JF_t6lQmU1zbdAOxcIWciSwKVy8tMcE
Message-ID: <CAEvNRgFNCDDSeuvbwj7pD_d18o1TBXo4TNR2dXHxpm18KPfR5A@mail.gmail.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
To: Sean Christopherson <seanjc@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k66x3wiy4xk9kd3ugi8szre65j781tox
X-Rspamd-Queue-Id: 7E19740005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786920371-803248
X-HE-Meta: U2FsdGVkX19LNXVFIaGpjyAViAtXyJjIeg8gBz1qA/85R8XNkud8r1WYuaR8I1Mi4eLuCTDobq6hOBs/UzkmfBd070Ua8e9bkAqHkG6LjJt7ThbAMdddrax7n2+cx1+TTOJqMKCQ6ww/AqTfhH6xXWWdZpHHUGT86RVdju1D1sdbyDHCgWgUdDgnmrAH7jpqgUeaOCgPXZl2BBu7QKIlQTILEr/pUTfWlB1ymG6gtq0cGGnH0djETZKD2m1+g5N/c9G5aj93St0UrTqV99FBgUx4wdlZVp+7qir+HutLWt9nBhs6kdQlcjOAjq/4ZqfHw9lPEn2+9UuRZcJXWB3VkbvgNMf9GVdL9HA0OfNkHjnzvVP2uT6zOtdKz+K3QUS0LtzBe6bLHsI4jqGTGFiCL1HCR1jxaTg+5dyLPf7eWh0kJ3aPRdYoPN2EEv/nayziInRBF0KSOxWZB7fC/wXo+Qd52wcV/heIMduVBk6X7wXG37MZTfqBdBipvK1QJn5JbpmnkenwqZpqolY4ediC0U614fZeULBbw/2epfe4A7yjLkV/JSF+MSMhpxqgJA9vrLdigOwKgZTJ/sooqbsQ8xfAJDXamFuPW61p0PsAhqD+cL/aqdqZw3G8PIdVEPp7P9+xxkVFPEl3Mww44GDts4R9A5oqyT6gTtERxqo+D8Exhg3oVcVoSrruohd42SK3w0SQUN2KBR4wc8QnY5fI4juVZLxA7AmvFvT3bbIAVBmBTtoEKeCP1tSycbFeIVQTqHo39WatcX6J+trbIxAutSHR7p6iXfbzldurK//vjwQjBNtf8ysMD3vYkuM/Le98VK6O1pS8P2wEsiGxK9gdmcPQUMdAbLoy9FSANLfJeaIJbMdHuK9oXeboFnh0AVTeq0LW6+WW+yvO8zPLAen6yBwc6cE+AYwW3O2mDaIY6C9g+1RXVuNbJnSCYLr3ExSiBz3fWEuqWkKLYVTb3rN
 MSTpZaJC
 Do5f/mZKmw6Ddvz4HGWnWEa7p2BhgFip6Rjg7iT5LDwxmKnjLSGNzrll7pCsTwwtscG/TCPU2V8cNF/rmkDyg/KsZFbceYsLBwAu57MFqABHZaDpx20i2068yxS4nGlCVY+NIVjqrXfejqTcLvuUk2ohY8EGmHTraJ8r4YtgnUAAdlsmWT8H8QAxotkPg36jMheExjL2OqMif2KzpL3UQ6xDfTTKfq+A4PFNIsB1XtP6gfjbaql6MDo0NF9aHdS/S6sMHCU5yfQI9T2jGlCMLMNsiCpwt1aHdqIE3svy98CXAqiUEeFC+OkHEgK62s409q0GeUvhwEtSdq5Z8Dkl7V2202bc5jRT1ilVU0By1iQrmfNj6DVS9g5o7NviogvbwdCJ+9bxIKkWgJeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 13, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > That's why I think it's worth analyzing the cost: if it's in the
>> > noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
>> > the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.
>>
>> Is noise defined relative to the entire conversion process? Would this
>> benchmark look like
>>
>> 1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
>> 2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined
>>
>> and then compare the difference in time taken?
>
> That'd work, though I was envisioning something even simpler: use rdtsc() to
> count the cycles it takes to iterate over various ranges of memory.  Do whatever
> is easiest for you though.

I made some changes to add rdtsc() for the conversion process as Sean
suggested [1], and exercised conversion like this [2]:

1. Initialize some memory as private
2. Get the guest to fault them into Secure EPTs
3. Converts the memory to shared <<== this is being benchmarked
4. Converts memory back to private

I made it build the VM once and convert 5 times:

./gmem_benchmark_tdx_convert --iterations=5 --size=1g

Here are the raw prints:

[  396.403818] guest_memfd to_shared: nr_pages=1, make_shared=930
cycles, total=39278 cycles
[  396.412087] guest_memfd to_shared: nr_pages=1, make_shared=252
cycles, total=28060 cycles
[  396.420379] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=26952 cycles
[  396.428643] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=27038 cycles
[  396.436921] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=26980 cycles

[  400.338157] guest_memfd to_shared: nr_pages=1, make_shared=1072
cycles, total=37236 cycles
[  400.346509] guest_memfd to_shared: nr_pages=1, make_shared=316
cycles, total=28338 cycles
[  400.354805] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=27182 cycles
[  400.363090] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=26972 cycles
[  400.371349] guest_memfd to_shared: nr_pages=1, make_shared=176
cycles, total=26886 cycles

[  448.761474] guest_memfd to_shared: nr_pages=262144,
make_shared=15041018 cycles, total=6616067680 cycles
[  455.807988] guest_memfd to_shared: nr_pages=262144,
make_shared=14937462 cycles, total=6608542680 cycles
[  462.848856] guest_memfd to_shared: nr_pages=262144,
make_shared=15138858 cycles, total=6599494898 cycles
[  469.885694] guest_memfd to_shared: nr_pages=262144,
make_shared=15721972 cycles, total=6610219850 cycles
[  476.928399] guest_memfd to_shared: nr_pages=262144,
make_shared=15000406 cycles, total=6615114540 cycles

[  762.980690] guest_memfd to_shared: nr_pages=1048576,
make_shared=61902982 cycles, total=26400884028 cycles
[  791.022885] guest_memfd to_shared: nr_pages=1048576,
make_shared=61746114 cycles, total=26401170984 cycles
[  819.054580] guest_memfd to_shared: nr_pages=1048576,
make_shared=61096794 cycles, total=26404409058 cycles
[  847.120994] guest_memfd to_shared: nr_pages=1048576,
make_shared=61446290 cycles, total=26447461896 cycles
[  875.219750] guest_memfd to_shared: nr_pages=1048576,
make_shared=61774646 cycles, total=26444608360 cycles

And here's the above, tabulated:

  nr_pages      make_shared            total    percentage
----------  ---------------  ---------------  ------------
         1              930            39278       2.3677%
         1              252            28060       0.8981%
         1              176            26952       0.6530%
         1              176            27038       0.6509%
         1              176            26980       0.6523%
         1             1072            37236       2.8789%
         1              316            28338       1.1151%
         1              176            27182       0.6475%
         1              176            26972       0.6525%
         1              176            26886       0.6546%
    262144         15041018       6616067680       0.2273%
    262144         14937462       6608542680       0.2260%
    262144         15138858       6599494898       0.2294%
    262144         15721972       6610219850       0.2378%
    262144         15000406       6615114540       0.2268%
   1048576         61902982      26400884028       0.2345%
   1048576         61746114      26401170984       0.2339%
   1048576         61096794      26404409058       0.2314%
   1048576         61446290      26447461896       0.2323%
   1048576         61774646      26444608360       0.2336%

Looks to me it is within noise.

I also actually tried measuring the conversion time from userspace with
CONFIG_AMD_SEV enabled and disabled. Converting a 1G-sized TD was faster
by 0.2%, which is in line with the above table. Interestingly, when
converting a 4G-sized TD, skipping kvm_gmem_make_shared() was _slower_
over 2 runs. I don't have an explanation for that. I think the code was
correct. (If it makes a difference, I skipped kvm_gmem_make_shared()
using a custom guest_memfd creation time flag and skipped make_shared if
the flag was set on the inode.)

I thought adding a kvm_arch_has_gmem_make_shared(), defaulting it to
false for all archs and having x86 override with
!!kvm_x86_ops.gmem_make_shared is not too bad either:

+ doesn't leak anything, since the function being called is
  kvm_arch_gmem_make_shared and the accompanying function is
  kvm_arch_has_gmem_make_shared. Or maybe just a little, since all the
  other ops don't have the accompanying _has_ function
+ it's a kernel-internal thing
+ not too many lines of code, not too complex

Sean, let me know if you prefer to add kvm_arch_has_gmem_make_shared()
and for my learning, what your considerations are regarding adding
kvm_arch_has_gmem_make_shared() or not.

[1] https://github.com/googleprodkernel/linux-cc/commit/3295072cfeb8920e48d9e80c98fd1695d4bbad99
[2] https://github.com/googleprodkernel/linux-cc/commit/a644618f270f02c832fb7e8402fcae98bc91f4e5

