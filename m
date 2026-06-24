Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C77CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B526B0092; Wed, 24 Jun 2026 18:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB326B0093; Wed, 24 Jun 2026 18:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84B06B0095; Wed, 24 Jun 2026 18:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5E56B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:31:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE5D2C1F5D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:31:51 +0000 (UTC)
X-FDA: 84916254822.15.B3711B7
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00CF84000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:31:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cD5PuVAr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782340310;
	b=unFFiPqUsICJFHR3bUZPPdRDV8n9QJCheG9oSwGls/zak0VFFQrbtWe0AGVAdD266Rh7zV
	3zKg3ByImSzl1Vmfjbu9hqW6aS41gyVOpz4q/MQXpFlj2SXEZHS52pG1P9pEkySxQlWHMU
	VXm3pEjr9+bVEV2qEyuXog5/Of505iw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782340310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6i/SOXitQvG69KsKOuqXfKe3MaqkPv8vgabs7K/yu4=;
	b=13wMtCTP8/8Kmt/H/ITo+l2T3sD6HfGUg5X4I+YH1UKHQ4mylrC1GLFIkZ8gpAX7iRcrPE
	8ji/RCmY90gveu1CSXpVAu67OwJ8CaXrIXMMBVjGOTnYeuMhakm4UmCbVgeohH6PnjkrbD
	+2FmlBoI/5HDpeaMt1YOHvM7rI0S1Bg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cD5PuVAr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-139aff562e1so2225295c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782340309; cv=none;
        d=google.com; s=arc-20240605;
        b=XBwYwIPtAiqmdb3ZYkBlqMgridf5OQP07EUMdYwD8YbjFFJ6mmPJeWqLB3Cyq3On/1
         ih6ycC8T9K1Dk3ptV3rFez954CVyKlTWB2GJlIzzhKVJfpvhg3lhMk3QncriUde/ueKg
         I/w7ETxcOING7zxN2tbPwnpTc1xd3a5NyRFDwzoqOni9XpAXp88JRwUMSkCrncgpufAQ
         UyrEaGwSkyA76ckZQqD1Q8FTZc8Dw82cZ1hYjzU8drqh5MyAt2Y96vf1gt3DAPQZMFY/
         0jVMjk61vdZ7T8Rbs2aCuxpX9fsXgVic1h2hvbxZDM2PdjlZGq0NDZ8udtXabTWWHiy+
         2UAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=N6i/SOXitQvG69KsKOuqXfKe3MaqkPv8vgabs7K/yu4=;
        fh=lDX25MO4YXW1SbQ1jFrdRJQ+jRpO/rRT9aB5srJBuSo=;
        b=MTxgbDCbE0Xt2r6E4p5ZhqUhCaHtulptI5260Jn/iV9XyMRgXkyyv0DFv1WqbW1Sfd
         96BPrcl8yvxomuAR7BAhaAGePOCvKh3y9zEa21S/poaIrwwjzgu8T+bcLBmaFyjn2R37
         LWCtBPPskEsDSTmj5L02cJ5cjkYLS1YIb+0JDdcpmpcbfAPmXmGSreYajln3xce+W+nT
         Gi2Jlq7DLqvwYoOhfTuvpe7mD3qNGfMuNf+TN1G39LkDIeyjSIyxqSATqz9P584j8dTS
         wSrgTY/8pwOVGz80s0m6BWvK3gETS42tiiprLoYz9ocbEkXNuuL3uI4Kr7H9dk3FJSRf
         V5uw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782340309; x=1782945109; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6i/SOXitQvG69KsKOuqXfKe3MaqkPv8vgabs7K/yu4=;
        b=cD5PuVArlGJebvf4q+CxY9FzhYqsrET8S7ktf3tBZpYCTcpTtOXQV76Gh4bWVckrb0
         P9LQOtlyu76WGujEnBqLZ912jLWxVnCVJgGzqWm3Gbj1tmyC5me2C59gtaVvV62cJRGG
         xDXhqS145876q9oNBVd9gsa80NhuK6g8y9EP9rL+F441xFRiYe59INfAdL+4LLMSpu+2
         7A5BjuXuhANUXJpFBYbQVXm2T5jQUJt3suIKUACdA+Eb9Dkku0hnD8XJm14N1dIy0dKf
         d/GDEtw3c8MP1frYY4x+TaUNv1/J4bjteBPKhUOKivi7uLcxUKC4BW8XIo8EVRRta961
         hwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340309; x=1782945109;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6i/SOXitQvG69KsKOuqXfKe3MaqkPv8vgabs7K/yu4=;
        b=gCOmu/4X66Iho+NNr0Ho/VdrvEOAGyAovE28TIxRMlliYzXdzwRWhmJ7SSPMRVaiWl
         Jj2LMSgORPZ/x0e9Z9U1T5Zj09xUhRMd5P7NC6N1TzuMF1sZ5q8SAHcsFqhiHtoXkwci
         ekByP+wMgwD2794VoIhBUbS68fDKnIOKOKNN5EsRY12pU84EB5pIZc1FwAbKzZ883x5S
         wx5UFnc6O52q1bZ03Hva3Q3Q6+BY6RbTDKzIOKwlc4MeW1Q7GUzWB3tnFm1D671Z9s36
         eNpcAhSkObJHN9nRRRsL9tAsxy/QBLtpDke/iuOnfPpfnIuPXXvIGd2D1fVDoy4PJzZP
         5Tmw==
X-Forwarded-Encrypted: i=1; AFNElJ8jNbC0LSEuMu7q+Dh9EjwSzYyLo8C+43vzuiegKSGyBkY91HjlBHVx8Xzs3qbesaqjma66JX1COA==@kvack.org
X-Gm-Message-State: AOJu0YwHrN1fQIe3RM3VW+GviLZ0vrvFZv/FjlhzOUhvJQMZB6U72Cwq
	krIPoW+/WSXVGHdDBbqs4S9G4n0Nrm4UjoL4wq1jS9FNodcwJuZau6oiwDKKQs4f8uAQKYdEvzk
	93G0peJiQHS5bHZH2lDNTcVRZOuuDoqtNPOS2ryzx
X-Gm-Gg: AfdE7ckZxebCwMmBf0LP3C3m9/u6VyORluEXzgz6SauNY+ArfRgiyz0sZ7cMiNrOeoG
	TGJ92oLKPD5oxb2BetN4LvQclOeqrSwDypfcspgdX09A9wsaNGwzNKgBL/fgGkMSNLbWydUR6XB
	5DU9Vz0lCI0SqGVqds+mkN7Crxh+finrkEg2Ef+AsotCcHTB2bBJfOMX3cTO8akct/nzYNF68JU
	61bf2Cj+NarpM0MrTL/s1oVLF66nQi+ilEJ6kESwUmgo2FBQYUGQhufoEc4iAIT1KxDJAi4sKmR
	gEbkfjbIYsqE/PpfJsNdzeRE7bvEUFtnXVGL6XyHB2HaJOG6ZGQs7zFHHScc2AtOYaqpPQ==
X-Received: by 2002:a05:7022:f687:b0:136:e639:9c05 with SMTP id
 a92af1059eb24-139d0c976b8mr3775881c88.31.1782340307804; Wed, 24 Jun 2026
 15:31:47 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:31:46 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:31:46 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTz3SW50EzxgXm8VysoaM21RReUVG2px_WUYU7zUwjXnpQ@mail.gmail.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-22-9d2959357853@google.com> <CA+EHjTz3SW50EzxgXm8VysoaM21RReUVG2px_WUYU7zUwjXnpQ@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 15:31:46 -0700
X-Gm-Features: AVVi8CdGjNdamkK1obuu8yqfMxgZ_h-GaO78YorUefDXnXrkakD9WS-D2oU1DQk
Message-ID: <CAEvNRgGnSgYBwsgTh34uTTBvah12SE55LW=7Dm7RQX2U4sA7Jw@mail.gmail.com>
Subject: Re: [PATCH v8 22/46] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
To: Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00CF84000A
X-Stat-Signature: t5zrfx7rjbd7am8pco4mwy74zdy6powy
X-HE-Tag: 1782340309-127956
X-HE-Meta: U2FsdGVkX1/mP7Bs/+8R5VLj1ETQcQ9v4I6p+jGSe1QOS8LACkiwJCz61pkpw7N4bq+3PM2EaHypPrpTx0yrQjOKs3iQXFqpHQNWSsbKCjiBQHKMtkM6BjoNzyHVK4Mk9sDOv23ZDZQbvX0g6sznzTx6FMtOUbJoit0QiMFLEloBywPZXkdwtCrQ92jbNPUkFp4om9vLdjX5dYOJCNUB4pX2wsMzeHSebYeXfgtQbJ7g658LYt8ETwLD8UeU9LA91vz8PdGuOSTi0r5mfFiDz4mLnHN6ijRsqLObUPU/HjUO+XxNyry+tD/6ta2WuQ6kGXagXm3dANa4xKxApuxMppHc3o5G5wre1BUmEyZrvmqdXCiffFntum+iPOoBA8H0wFC1hDP4LqCupKoyaTH6CnQSI+mhh3rZjTwFlQXZChMbbV+xT2Lt36FgNl4j5WpVEMIKxbuncPvGfjIIeFb2/ZgAS9OnLDavkZZOlDKOu0wRFw9E8h10IMjgD6qiYHkPiCgp2WPTLXv5hzreR9fF2WV4grc4YzGy5rVnIMd1Mi166edzR5egyrDn9lWckufJB0tE102683lkqRUNepmwtnWQ2Uv9V6YNiX/eLyj9XpDcWRlcwMORmYlCrjTvLKyEMEHeazgcBUl/pA3mIK+aakQwK7TNN87VkLXsYh0NRHRQO8mejkIUFuFhrwP09wfXs4/WDlx2MYjYRPSQ63uWdC64hJtqmnhO1kNgeiRsQEnP8NZMssv9G6c/kCLrQPigaxL2A3URhPqWMWTLsaLwbUvBPaG6rL576HdtiAc6MeyzV7fE2+rK+wLrzXH57ZUVwWJm/08WbO6PVqWXDnxlImXKMNTWiW5ZM29RS8jZrXwo+YfYgmzHkzOgB8tGVfVhnuKboXRauLIgmOwLaZCPpQbyUKW30Vl1dtmyBWDFanP8Ifd6D5jEmxq4mJiDgGwezO9ysBWpZQWdRA55ylH
 PC/UgP+n
 Ysm9iZ61vcEATNGeZ3JuoszvQNI5OREKxtqNyAj7plPBzgikjHNNjenDAHdfJNDfZakaHSMqjQEVGSospzsQF+4D29/22c6qqLUmktxfimvQ3RP/mZArEfkwO8j0almQ06XKxLEguHp/vysUakHO2Xo6IwRxYr5zam0Sy1xV4/hpcGKLizY5TC6gmjX2r3EH7F0DTAQtcfI/qb271o3RgycbdOqZX590ISrDpzUrPj569E7qdpI6jOlS9ZwwQ02c6/VTwF/5iO9woZTmfN1WbJNkFBMoDNwGVeSYCWc/FwXHaqQRUwYFhYni4HllRUhna8b0Ii5tf1Byku51GJfyrcRgWCEBjbnMdlSOUvVTRjhTjyFzxg/Q7e2C8YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

>
> [...snip...]
>
>> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> index bd04a908a8dbd..29409297f1ef0 100644
>> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> @@ -503,7 +503,8 @@ secrets.
>>
>>  It is required that the GPA ranges initialized by this command have had the
>>  KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
>> -for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
>> +for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
>> +this aspect.
>>
>>  Upon success, this command is not guaranteed to have processed the entire
>>  range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>> @@ -511,9 +512,13 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>>  remaining range that has yet to be processed. The caller should continue
>>  calling this command until those fields indicate the entire range has been
>>  processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
>> -range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
>> -buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
>> -``uaddr`` will be ignored completely.
>> +range plus 1, and ``uaddr`` (if specified) is the last byte of the
>> +userspace-provided source buffer address plus 1.
>> +
>> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
>> +ignored completely. For all other page types, ``uaddr`` is optional if in-place
>> +conversion is enable, i.e. when the destination can also be the source, and is
>
> Typo: "is enable" -> "is enabled".
>
> "when the destination can also be the source" is hard to parse without
> context. Maybe: "i.e. when the data has been written directly to
> guest_memfd while the range was in the shared state".
>
> Also, how does userspace discover whether in-place conversion is
> enabled? A cross-reference to KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
> would help here.
>

Will fix in the next revision. Thanks!

> Cheers,
> /fuad
>
>>
>> [...snip...]
>>

