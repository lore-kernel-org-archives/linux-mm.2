Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F48ECA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A25940009; Tue,  9 Sep 2025 05:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA33940007; Tue,  9 Sep 2025 05:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BAE940009; Tue,  9 Sep 2025 05:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C09C7940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:07:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C8941A03D1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:44 +0000 (UTC)
X-FDA: 83869134048.14.AAEA536
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 36BD340005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Flnv04g4;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfLFN6eNqIPI3eYn2mOCbZpQPxjwFCGNIowHmmpIIeQ=;
	b=pI2mZ/zOSG4OBM2roXyL+g9btkpgLmZGHxAhvLxqR9WTwoNdxlKX7Ai5fopugkEQ+3JvUO
	BS3lP50RAOJh0o4QWS1rUzdlu8urHGG4p8kej518qHEpkQUhY9b4VQPF6v8fRbt1Exruz/
	gOl0JJ1krtPbH76aPf57rAGVfah5dfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408862; a=rsa-sha256;
	cv=none;
	b=ymBfbXfCFq3FYcRtqaFIumffSL2DYA2+4JSog3XnLiqtJCwts8L4p33MneS72is1dWgkSg
	vxJTv9xQKYzQo08Y9OgY5ka3sypmHu86Qs4Bo4tj8/bT4oDddLygVB+pJX+07lkBEH9mFY
	5LNJKdkbMRhhPUeiARr6uZ6XgPlOq9k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Flnv04g4;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757408861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wfLFN6eNqIPI3eYn2mOCbZpQPxjwFCGNIowHmmpIIeQ=;
	b=Flnv04g4BCDwhTa3Te2nd4UcEtZikSvaj5bIKeDTdNkORNU8G53l+63BLDD1z0tdO/t4AY
	hTXVsahiww91T+h9AzU9219OYaYlO/xUk/I78X1fGMDzOXQ5ObK6+lJO/owirQqlWgYF61
	yVyy4I8tKYgg3Slx7xjqomJpeyXUm4g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-a1jEFWcIMB6z7ypkQknu8A-1; Tue, 09 Sep 2025 05:07:40 -0400
X-MC-Unique: a1jEFWcIMB6z7ypkQknu8A-1
X-Mimecast-MFC-AGG-ID: a1jEFWcIMB6z7ypkQknu8A_1757408859
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dde353979so17716685e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757408859; x=1758013659;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wfLFN6eNqIPI3eYn2mOCbZpQPxjwFCGNIowHmmpIIeQ=;
        b=gmRxvOtHcOSpMCvMAz956hcof+TDZCRLhVQWCpvvmzIjPNW2fC2bFIYcQB9DNc36bd
         tHw3g6+5gZw3zSFdLBIvEhW7H95ThZa7plQM8mzD1llB0e+1u5uHZ+kx6p/VAf5KqfhY
         tz0uFMUL/OkE0iHF2vIU5U1wiX3pVXqXdXD1oc7k7xedPlnUbIQ5NZ+AUNu+tVgr91Tf
         14llP8wbkpiE38050PmW8HG6CF/Ir6ZoGvVdbfAgf1jVBvP/Asb5YXtWFZPVXCvZqWBe
         fQbBOjqWK6inj3eDbIf4XHnnnEGb1eHSKNMDqbuCK927Qqnkx7rnzpD+Abk27rqk7cQU
         m80Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+Htj9oFmU3jgJAz3gpHoQ0xJt09ejlHbIZSr6/GzLsPp/rNPRrKIfmQgEz933CB8YznN0VGGskA==@kvack.org
X-Gm-Message-State: AOJu0YyjL8UZ7E685DThbKsVnTIn+zwCx85lf7gBecH97szdJKVmsPo3
	ZnLgfhgp1oAJhQGkheqIb1JAqvy2rZlyw5bsJQV/hYoBw8PPXlLWDCgopeZ3jgD2S3H8HsiY5LD
	mjJOFzSdm5Sd281UF53Ng3I+UTQrEykXSIxDYMdyKMypwQ1tZmvXS
X-Gm-Gg: ASbGncsamkzU9u2xvxNPHv4D9Ho9jga3CKa1wH0I+j+p6P5RBrBdvwkyZr4+bZDaN15
	+Co2ycOID7+y8074LQv8vMnlmFCzHoP7RXS3CjRWTexqV23+ikJU/wkv4uCESx06fYL/ab8lflS
	RCq9nNnVUXJpDL5HXyw2a0wgcHf9AvXazaIo1CiOHKTxZd6OKcwQH6r7H79QdOMNSua6G+cF+ve
	bg9fo6MljmPbI1obb+dTLsMP9UBShpFzwpVJpIgt72NG4kLWyYz+q09YwNy3NOBOCorHaP8m8o8
	e0Be1PucUvhHnjSw9XrRQ4AsMNgo9p43AQZzKFpEzug7lKe9FYuM4ebAlD4mpIs6vzoN+YisD4m
	+k3w7iRUzFB1Kl26KpGMPwJJSAiEBvdZ3h47uZo8qFygD5T5oHqkH1etz2N0GQnmLDFM=
X-Received: by 2002:a05:600c:1387:b0:45d:d2cd:de36 with SMTP id 5b1f17b1804b1-45dddeb8e9emr100152895e9.12.1757408858955;
        Tue, 09 Sep 2025 02:07:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXDnypB5wJ5rDn/zJEyHS9xO4uduYWB/+gBqRR8sdBFWJ0cHWyM3HNnqaB+9K2c1SmVJ00yg==
X-Received: by 2002:a05:600c:1387:b0:45d:d2cd:de36 with SMTP id 5b1f17b1804b1-45dddeb8e9emr100152415e9.12.1757408858433;
        Tue, 09 Sep 2025 02:07:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df16070bdsm5517555e9.3.2025.09.09.02.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:07:37 -0700 (PDT)
Message-ID: <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
Date: Tue, 9 Sep 2025 11:07:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908073931.4159362-3-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tKqknDeveCRGbnnvl9eQZvraaK4Q9I8Y2GZUHKDQJAk_1757408859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36BD340005
X-Stat-Signature: fbhsdmsdzjnkpumken8rrdwkp4z5sy5x
X-Rspam-User: 
X-HE-Tag: 1757408862-362649
X-HE-Meta: U2FsdGVkX1+BSBKy77hJtJCXbWZ2gXJved7sA2fFrDCROScmyD+6krC8uIt4bHc0GnrcceaPBPzn8ORX+kjYUXCawj2TiaYEzCPuWkVLf4L+S26ttHnRg1kS3IOMczmt74QmbMPNf7agEa1H3p190Q0TcvMPrcx6s2yvLqHxgQy+r6n7rT/S9ODC4hpGd2UIu3NEoQ7LrhczYn8GtsNjshnPEcZqGOJ1JedKQa/Qz8d9IlED5uvQKyosox/EAt2/MyULEV+Dbs9K+1Cl2kzfKYELvgy+DddLPKB+BsLZIHZl/zkn/WjAm4QJyxZdpKo+Kt7hfLpLp9qeOQx4W1buNQvSX/EUY1Iy5LVHMG3qHXA4435p/52ize99UWfiRzqEFe1+pybqL2EbMMwSVMitwexbdCk+i21NWfThTE0k8C2GUlSWrHSnetsk/aLpO5qicdYX+oqwjzIV4gPAJZXChkQ8NX70zEPMqetRIeBALBX5hditNeyRF5nauIp4iD3pJZNQwueCNcW3CCvXzTR75owjE9Wzvp70cWSrt4a9bunQk3xYtRSIMEgRcQHmWmBXFlNmXQeUmJtvtdhtzukGV5+1gbg438VafrK+p5VDYFDTXNkT/iIsI2Cx5KHejFiMIeP6YGPFeB41KSDlrHLqcI9DEZGTRna5NkNecfkt9dIsYGBFiG+y5bQpa8libh5/HAkHgRp48+ygJiw1a39PY5g6nuSm/OjWwlhFBXgApl0PlthhkMT/0Axox18cb55W/ZXp7lYOkizceaAf5rQNKgufC/nZtjwZtdapY6ohG2f3sBCmp4dlkkdLJ2Er43wjMWubtR6g3DF2I4VbObX0IlTqJqe81JZ0wyvVX6+JkRpZVpo3bz98ExjCm7YVlaZPPEuFjTvDkjA21kpCvn6Tc3DmXFURHZ5WNujVR6EAayajCaEEeDsdaKaCm5/kblIKMK9r6AN4oTzlCbjACos
 ouHM95oE
 77Ym52BAvr8/ZvXDxrYvtLKd2YdwEYoWtu0eR6nDiBXeNlIQkSOvPvduPDvMJ1HdNdBMhzlAAzpyBv4TP//7oM6cmCLmvDMEewk7Lo3Jtka2bdCmT92gEMG26f7hIXiMHEqDUOp8k7vyWwGBHDgl5zNuLdqr/PV6YucSOoSJSSOCcTzxMcfGIGtIY4syrtdXwzJIvxELco2sc9hDECEsPaeLfyB91FHYehlViFiBhn3N8+ZUbYOHQueL3+1EiWkv4VcVqrkweflttjRvWY3AwckSFRQkLqe+n/0sdhpIeMgtLzz/DueVsgGba6BLi57pt6UdAL2ElIrvrmYGOiCUEcWN+jqQI1Dg/4v2QPz28a5XcciqwBrakzQTmgL7FXskGcL6ViksXpkOoPQqaMa2dd9AGV2X5lz9Ws4MEFN8wauTzmLCEb8+3+tCoLCP2OoBZZpTCIgysWHRByZQ8zjWpLWP0nUvhQTsHL0Ya
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 09:39, Kevin Brodsky wrote:
> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
> (taking and returning no value). This is proving problematic in
> situations where leave() needs to restore some context back to its
> original state (before enter() was called). In particular, this
> makes it difficult to support the nesting of lazy_mmu sections -
> leave() does not know whether the matching enter() call occurred
> while lazy_mmu was already enabled, and whether to disable it or
> not.
> 
> This patch gives all architectures the chance to store local state
> while inside a lazy_mmu section by making enter() return some value,
> storing it in a local variable, and having leave() take that value.
> That value is typed lazy_mmu_state_t - each architecture defining
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
> For now we define it as int everywhere, which is sufficient to
> support nesting.
> 
> The diff is unfortunately rather large as all the API changes need
> to be done atomically. Main parts:
> 
> * Changing the prototypes of arch_{enter,leave}_lazy_mmu_mode()
>    in generic and arch code, and introducing lazy_mmu_state_t.
> 
> * Introducing LAZY_MMU_{DEFAULT,NESTED} for future support of
>    nesting. enter() always returns LAZY_MMU_DEFAULT for now.
>    (linux/mm_types.h is not the most natural location for defining
>    those constants, but there is no other obvious header that is
>    accessible where arch's implement the helpers.)
> 
> * Changing all lazy_mmu sections to introduce a lazy_mmu_state
>    local variable, having enter() set it and leave() take it. Most of
>    these changes were generated using the following Coccinelle script:
> 
> @@
> @@
> {
> + lazy_mmu_state_t lazy_mmu_state;
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
> ...
> - arch_leave_lazy_mmu_mode();
> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
> ...
> }
> 
> * In a few cases (e.g. xen_flush_lazy_mmu()), a function knows that
>    lazy_mmu is already enabled, and it temporarily disables it by
>    calling leave() and then enter() again. Here we want to ensure
>    that any operation between the leave() and enter() calls is
>    completed immediately; for that reason we pass LAZY_MMU_DEFAULT to
>    leave() to fully disable lazy_mmu. enter() will then re-enable it
>    - this achieves the expected behaviour, whether nesting occurred
>    before that function was called or not.
> 
> Note: it is difficult to provide a default definition of
> lazy_mmu_state_t for architectures implementing lazy_mmu, because
> that definition would need to be available in
> arch/x86/include/asm/paravirt_types.h and adding a new generic
>   #include there is very tricky due to the existing header soup.

Yeah, I was wondering about exactly that.

In particular because LAZY_MMU_DEFAULT etc resides somewehere compeltely 
different.

Which raises the question: is using a new type really of any benefit here?

Can't we just use an "enum lazy_mmu_state" and call it a day?

-- 
Cheers

David / dhildenb


