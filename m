Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F93C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AAE6B010D; Mon, 17 Aug 2026 17:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752C76B010F; Mon, 17 Aug 2026 17:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6416A6B0110; Mon, 17 Aug 2026 17:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B09F6B010D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:10:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E122314098B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:10:48 +0000 (UTC)
X-FDA: 85112005776.29.20D2AA5
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3400160002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:10:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W6gtXQ7P;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787001046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXsAYGWxJyVowLSo+okTw01FCA+GPEAZRUERjwSXi8s=;
	b=Q5BU95m2KR+470akP/DhZcXQvIua9Prmm/QVgkuDoONXRq65sMGCfFj/L2BGU79iY5o53E
	hIYmEMwy5I09OsEI8QLVfVxHBWaysLlrYstrlpbNFvnAZGNxou1NrNhlLXLu8SeYlYkhNz
	25fr58lRVeAHLdmqxguCtMYjVxPDGeA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W6gtXQ7P;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787001046;
	b=V94yJcYvBxa1WAVU3qNLwogp+d6Vv1r5UwHf24VbhQiyNAbYC24ezx+OBDm7SnZJRycQ8s
	KUGgrB1Td2Ao/pDlWeZmQc7pv9qVJqBdLrTgi+U6rjJrVpaJ5iTRAJIfM6czfMOhlj8FuQ
	bGD62oS6wOnyo2f5rt3jnC94KYDAZzM=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so2782218a12.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:10:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787001045; cv=none;
        d=google.com; s=arc-20260327;
        b=LdzAXBghU+KiSz+H8BqackD5WO6qvzlFYCvGMsyJAhRvR7QKRkO+d3KSrcTTMZRzPN
         73UNIfyZTKud+uDZ85QlrxsLtzMXuhmAv+X+a0sluifyTn4l9Ec/BhTFOdOytV/TnqKm
         QIqtepTgW10RDrKPqiLJphFAZ4xLM5pL95+h67PqsvJP5mNuTwmG0YY421IGbFo+jF7F
         tKZwUwux51ndyJba2IdHawhdCeR8yVxlseCvIncBF6Nwjmu/GNo6VBgqXO5BFFOrKdrG
         /lQO+DyA1REeH65sklMGKtvCEeyrJknqqACIwBHol3BflsWQoUHM1IPoioQb1PYSp56H
         /8yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fXsAYGWxJyVowLSo+okTw01FCA+GPEAZRUERjwSXi8s=;
        fh=m6PTD04EcdAfiDMAFf2onIvbzCFPM5IOaYMhDPyLlEA=;
        b=ppyxJZzxs5TOOeVStzSrHuGYPDTcLfHatoQFGybcFQA0mxr1tr6Ra+d7m4gAta8u/q
         92w1RHWLHDXOsqzwtFJnjxHFn7j63LwEuifGQ3ScyYSlaJpzs3GG3huJld+4Z8ZK+F9J
         duDeXkr+hzmi6hFZlNd8Sy3KmUv4Z0CnMrRynZd3s5d/SjMdQewgK006HvFFIiF2VbG+
         ++eMdz65C24TqdDnxjR1T19L69CPZ3GgDFSzu6mEIhw89YZg/P9AXNTlteTriamsr29x
         2lwDphWX64dRxqkO73CSVSwGgFdjOLRB5b8pTyIaDTBKSm+W0BQ19t+KY0rq9m309R7E
         By5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787001045; x=1787605845; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fXsAYGWxJyVowLSo+okTw01FCA+GPEAZRUERjwSXi8s=;
        b=W6gtXQ7PmVte7nAt+iFN2hLz5aR8eHEc1qVuXhJkgG7+SDps4fmpdTo7T+SBlsSPom
         uiBWvzitgM5/X1SZyDTNChw2IiBVarwQaYolbePWskRsmCrKV5Ndmml5DL9PNKecZhc5
         jQle1Dzif6iKDm/dQFPflLrO1WFuNR4GmAvdfSLL1JnMMJyQhyjkEn6wyMsH/1+1Jy9q
         AsBGMZGMDNvgqXHR8yWDDZObe8bQg/pPmok017K7EAmBu1WB7KOQ40cIdh4wVF3dtbcj
         jmJkYqCnJjtoEdq9YFPkb3O+Q9JK45/mPQJgBbPDsOKagVYr1P6u3lHwxuuxKHAYCKWH
         nl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787001045; x=1787605845;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fXsAYGWxJyVowLSo+okTw01FCA+GPEAZRUERjwSXi8s=;
        b=FZHQO5YGVyvnshUwrd0FWFC72y8vROD+l2bdMKvPV5wlZhW7IG2gJyM9FJQU8W9M+k
         iKFWXryZSej5Qo6TzH3oYSvBrR4xT2IN1T6n+O1A54FRZ5js6aEKbm44aCSZMGaX5Pvm
         QjG5mpl231qk+ZSuI4ygeFQpFW9xLFRgqZ5HCCXp8Fr4nKd+zmEAoRLiDjrhXhBE+GUu
         RETPbqcAx2et/hxp/hFBmjvQezKnkRSHHUVEHCTaN16ZG4hTLBC+TIJwFt3x4LVfAP6n
         ACPETJNPpf41sBRGPtdKjQKodkbQYD8pmiHz7EmfjdxRjZv7x2q3sAwsOsJc6DCxIJ0R
         o4Eg==
X-Forwarded-Encrypted: i=1; AHgh+Rpeap+57bW9fpSNSay8u6BRdOh5chOhLi5umbKdTkGVKQdsHO7/c8cIN0l3PhcX45FwfGL5U6nOCQ==@kvack.org
X-Gm-Message-State: AOJu0YxWy0n+85E5h3ZyggQpuCDtJQbQxohbtSQMuS0wmCnimQQaSXvs
	wkyLbISDcpZxItEUctxp8FwRAA6G2uNPz9sat81unZ1us4cwqxtK/Cg735aVANhzuy/UtsFnHzi
	Ol6bIMHXjnctObmY+ZluYuhSaFOqZFPnTMM8KNgb0
X-Gm-Gg: AR+sD13HgOZ2M+0jOpo8PxUD3J4hKL4qidXQEQ2L6y1fPLEUVix2NO110nQbfZBb6cW
	8xxuJHaz6SVBglM/aV8kgDgUqTu9ruq6Y0hoBezFFjXenxo/7JPoDDPsVqVF9nOUWTMG7dvZMJU
	mxteATqm8PTcM0HlH50MG16VFXPzxr0q9RTLcPOa2q7g4T4O/6kBfCvER2mHpObFiBpvSChGDa8
	ZvYaMl2dIIg3vfgq5AkDX844+wefxM0CTx8OXbMGFTfH4XsySoZSfoOqARtb32q2EXN5YPB0ODL
	aVoclUY67U2USnE89pMfhbwZls4iHd2njgGedPZ6MH1hYos2M6/5uFiVbE6y0vwgBFRjBQPSEVk
	XyQ==
X-Received: by 2002:a05:6a21:3398:b0:3bc:5284:5445 with SMTP id
 adf61e73a8af0-3cc71d53eacmr29096172637.21.1787001044531; Mon, 17 Aug 2026
 14:10:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 17 Aug 2026 14:10:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 17 Aug 2026 14:10:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoNlZRb5SV7hyNuk@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
 <an5AcEG9mqDgnBYk@google.com> <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
 <an8umm0qisEidt4n@google.com> <CAEvNRgFNCDDSeuvbwj7pD_d18o1TBXo4TNR2dXHxpm18KPfR5A@mail.gmail.com>
 <aoNlZRb5SV7hyNuk@google.com>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 14:10:41 -0700
X-Gm-Features: AcwNN1XkDnEKM5GNqm9LOem-ACT2KBKH21AQXps-0CKMqEJi94nO9ANnicdLg5A
Message-ID: <CAEvNRgEojt8Kpot9VaFUyVbVH5QVEdW-TgQUbVnpVCNzFtdVag@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: xrku5bjb8f5muaxbn1dfghatqxm7cw3u
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3400160002
X-HE-Tag: 1787001046-244022
X-HE-Meta: U2FsdGVkX185AR/Lrb6VigVJBAZiykVa7rIHp8irIFm4M0bojffz3jvfIe1MUxnbZUaxmqsLfwQs8nxCVVWD/rFJd2X3vn5V/65CDSmwwkMuFGJUgnB2FjD7kj9aQxdgMoG1u+fZ/vf+g8Sy/Ege718Ufj4WDla7RXwYsMwx+gBilo7C88ok4M0ZZJ/jEYUvDLEY5gl8TYFArITHOrY2GbLe2KJiOytyHzoFrArDAJ6j34RPorQUEZIA/mGoA5VGQOTbQ/ZJjsetuRVeAAIByLjP3Fl3M/iC+MDB2w6srDVU/b1BeWvGnQF6/aFq9j7XMXLsH5GQLITzQcQkl0ognHnIApVkbAo1C0NlEJBHq+eVKR2hBKAAaONhansvTgFmcz16r/G8GOG1BA3wcVIGuGyPxW6WfsOHhCz6v5c/tjGmLpRHTR+be5DMrLqZq/zwRYpErFBDqofeJS6HAAn9BuznE6ephiH7ta3EkgT54mltyx6j7gwvOMu3ispLoKJ4R9AQeSj/C2mMKNRnq7+tOFdplkNGZZHHIqJClYoXcZS5VAXfr1zEh7MWb52Ubkb7ZMiLUF42TXavLpGnB+yvAs7QsRlyEZe8LtG9u6T9WuyCeU5HYoR/AZPUOSoOoQMYWvpxh2ysZ0YFzl1Qbu8FyohnFHJoDBGziPb1tX1G+60toFsLWp6miIIWnyRnTxxxUTn57rl7Gx5HnCQGc9I8vbQ/cO3ftEWpHmVJYiDuhQsdZvAU64S1wLG6YpSkT4Tubh4FCqnOGoHJB2N25iupV0lXUrWg3QcDGqigzFN100zjWaWKBkwjiE4moSs8WHxO35hf35EVW1KwMuVFzJCmW/2pmCCZBwYMF/ikQ2gyMvhiHLLgfYxsbkoh8pXL3Xw987Bkx+Ck6WwfDtrancC9M4zmF6GyPWY9as1zzk3k2dPaeadnfWDPraB18nvvVE8lyLVVLQOz3sMnAvct4ej
 +4HsGEyk
 J/Gn8AMyMaKMYGAI8jIGU7flUzqrSUPqdAuayaua1SOBE8+fAhIn8igObVLFJBE8yvBhhSdnMl420Stt7NI5AJq6NfLyl30bybDldzE+e+Vm+kvbGVHTjevTqIzuGJJE/dI9QvHHKxm5FsGopRkHudh+FM7cx/WvBqLwzHjGncTBQ+bmAILw7mdVwXxBlHmbrqGf2khCTM0SnSPd5+gExb9Rt0bEkCbHwme9moocUWK3hM4isWUaUDx77x5naSjg9MF+OnQH0329Lnx0BYzIaByfBkr2icX1M4LW154kcQtI+u1V0paaqY7LnYp5495SSBBuZ/sKuWNLnnFoJU+VTJGnskpzW8JoRXUx+CACVUpqeMEpRwR+bH7NLpxkR9MdDB2FgJOYYfUUBz9lf72wTrnats96WMWiqVAo/XpqGtw+bqiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Sun, Aug 16, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> > On Thu, Aug 13, 2026, Ackerley Tng wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >> > That's why I think it's worth analyzing the cost: if it's in the
>> >> > noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
>> >> > the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.
>> >>
>> >> Is noise defined relative to the entire conversion process? Would this
>> >> benchmark look like
>> >>
>> >> 1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
>> >> 2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined
>> >>
>> >> and then compare the difference in time taken?
>> >
>> > That'd work, though I was envisioning something even simpler: use rdtsc() to
>> > count the cycles it takes to iterate over various ranges of memory.  Do whatever
>> > is easiest for you though.
>>
>> I made some changes to add rdtsc() for the conversion process as Sean
>> suggested [1], and exercised conversion like this [2]:
>>
>> 1. Initialize some memory as private
>> 2. Get the guest to fault them into Secure EPTs
>> 3. Converts the memory to shared <<== this is being benchmarked
>> 4. Converts memory back to private
>>
>> I made it build the VM once and convert 5 times:
>>
>> ./gmem_benchmark_tdx_convert --iterations=5 --size=1g
>
> ...
>
>> And here's the above, tabulated:
>>
>>   nr_pages      make_shared            total    percentage
>> ----------  ---------------  ---------------  ------------
>>          1              930            39278       2.3677%
>>          1              252            28060       0.8981%
>>          1              176            26952       0.6530%
>>          1              176            27038       0.6509%
>>          1              176            26980       0.6523%
>>          1             1072            37236       2.8789%
>>          1              316            28338       1.1151%
>>          1              176            27182       0.6475%
>>          1              176            26972       0.6525%
>>          1              176            26886       0.6546%
>>     262144         15041018       6616067680       0.2273%
>>     262144         14937462       6608542680       0.2260%
>>     262144         15138858       6599494898       0.2294%
>>     262144         15721972       6610219850       0.2378%
>>     262144         15000406       6615114540       0.2268%
>>    1048576         61902982      26400884028       0.2345%
>>    1048576         61746114      26401170984       0.2339%
>>    1048576         61096794      26404409058       0.2314%
>>    1048576         61446290      26447461896       0.2323%
>>    1048576         61774646      26444608360       0.2336%
>>
>> Looks to me it is within noise.
>>
>> I also actually tried measuring the conversion time from userspace with
>> CONFIG_AMD_SEV enabled and disabled. Converting a 1G-sized TD was faster
>> by 0.2%, which is in line with the above table. Interestingly, when
>> converting a 4G-sized TD, skipping kvm_gmem_make_shared() was _slower_
>> over 2 runs. I don't have an explanation for that.
>
> Might be some cache/memory locality benefits?  Though with a conversion that big,
> it could also be nothing more than bad luck.
>
>> I think the code was correct. (If it makes a difference, I skipped
>> kvm_gmem_make_shared() using a custom guest_memfd creation time flag and
>> skipped make_shared if the flag was set on the inode.)
>>
>> I thought adding a kvm_arch_has_gmem_make_shared(), defaulting it to
>
> I would do kvm_arch_has_gmem_convert() for consistency with the Kconfigs, and
> because the cost of the reclaim invocation is a non-issue.
>
>> false for all archs and having x86 override with
>> !!kvm_x86_ops.gmem_make_shared is not too bad either:
>> + doesn't leak anything, since the function being called is
>>   kvm_arch_gmem_make_shared and the accompanying function is
>>   kvm_arch_has_gmem_make_shared. Or maybe just a little, since all the
>>   other ops don't have the accompanying _has_ function
>> + it's a kernel-internal thing
>> + not too many lines of code, not too complex
>
> It also provides a good excuse to kill off the #idfefs in guest_memfd.c.
> Compile tested only, but I'm thinking this?
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 17 Aug 2026 12:31:50 -0700
> Subject: [PATCH] KVM: guest_memfd: Optimize away conversion overheads via
>  dead-code elimination
>
> Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
> of arch hooks related to converting memory between private and shared, as
> only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
> pure overhead for TDX).  At this exact moment, the overhead is negligible,
> but that will change when in-place conversion comes along, at which point
> to-shared conversions will "need" to find all affected folios prior to
> calling into arch code.  In quotes because very technically that work could
> be pushed to arch code, but that would bleed guest_memfd details into arch
> code and would be far worse than adding yet another kvm_arch_has... hook.
>
> Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
> rely on dead-code elimination to eliminate the call to non-existent code
> when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.
>
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 +++
>  include/linux/kvm_host.h        | 3 ++-
>  virt/kvm/guest_memfd.c          | 5 ++---
>  3 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 283847619ff8..5d5a7723abb6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1854,6 +1854,9 @@ enum kvm_intr_type {
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
> +#endif
>
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bfc92864b6..e824ba59c60c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2599,9 +2599,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_GUEST_MEMFD */
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>  int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  			       kvm_pfn_t nr_pages);
> +#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +#define kvm_arch_has_gmem_convert() false
>  #endif
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184c..39d94938b5f6 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -773,11 +773,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		folio_mark_uptodate(folio);
>  	}
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> -	if (kvm_gmem_is_private_mem(file_inode(file), index))
> +	if (kvm_arch_has_gmem_convert() &&
> +	    kvm_gmem_is_private_mem(file_inode(file), index))
>  		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
>  					       (kvm_pfn_t)1 << *max_order);
> -#endif
>
>  	folio_unlock(folio);
>
>
> base-commit: 1b731e5ded480bd1e5546aed35584238661ce72e
> --

I'll inserted this as the first patch for v11.

Then, the later patch "Call arch make_shared callback for to-shared
conversion" is now:

	if (!to_private && kvm_arch_has_gmem_convert())
		kvm_gmem_make_shared(inode, start, end);

kvm_gmem_make_shared()'s definition is still guarded by #ifdef
CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT, and there's still a stub for
kvm_gmem_make_shared() since kvm_gmem_make_shared() is defined and used
in the same file and the optimizing out only happens later.

