Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB82CCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 13:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E188E0028; Wed,  8 Oct 2025 09:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E550E8E0002; Wed,  8 Oct 2025 09:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91E58E0028; Wed,  8 Oct 2025 09:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8BCD8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:15:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 686B314057C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:15:16 +0000 (UTC)
X-FDA: 83974993032.24.549C1AA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id A8063100009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:15:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2n/AuEGt";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 34WPmaAkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34WPmaAkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759929314; a=rsa-sha256;
	cv=none;
	b=WxDOw4BL5j+nZ8sM45fEMXdrfWyeBP/RxKPUwPhx7mzuYoU3dZMJUnONhN7Y+jH+2JqVvm
	GqULl9pVaE5NQGkC7NYPBnIf8+S8iH5+iSs2o7PseLLoo/CLV03BJYzZDLRlI6JEUcrI7G
	Gzzet4lRm8G7Dzk/P9ZlUcdCvcC68Zw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2n/AuEGt";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 34WPmaAkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34WPmaAkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759929314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GMh8gF1Uu4hd329Ty2DF0Ok3lYIutJuQKHJlpedSPk=;
	b=YxcG4lEl4SqqPGVocCbP9syEKQsEwKQ6kd5EnyuRSvBFJgFKDQMTLO8PbDnlu6s1v6NdLu
	8/72WBnV0IJcOKv9K/4G9odmtyIbZJNEe1kk0dj6GAPM8mGPRiq9O/L677fvo0eFTkGSNd
	YHIwwvd0wxGcMaBJnUWNTcFv2b0tp+o=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso39633615e9.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 06:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759929313; x=1760534113; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3GMh8gF1Uu4hd329Ty2DF0Ok3lYIutJuQKHJlpedSPk=;
        b=2n/AuEGtINJLoViNTvhINkAydVK8iKzr4a5nBVr0qJpMmpo8jfwNdzgFTDn4lSg8ri
         Xh8evsUFqX5hxhhP84ER1iPwbhoGqX2Wfy+IAHoVZHyqEYbg5jKIxD0XHmEFgLD0wLsE
         7QmD6VzOxeR/PTxbZTnr7cp9U3u7WyUFwmRVzX/3eSeva01AmWepKQj+ujC2vb3++OGO
         ZreLMWbn94v0Avuf3xIW4HkgmVOtYiBaaDrDQAaSAl/J4wPP1qdsZdMoqVVs+MfRpDz7
         GDTDEipJ9x8vyp3X2/I9rlsFpAVXQp3oiVMmrncJaHt2nd8la9LZnQwcjRvFGggN+xFL
         LLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759929313; x=1760534113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GMh8gF1Uu4hd329Ty2DF0Ok3lYIutJuQKHJlpedSPk=;
        b=Yk/95BNMtWi2KPko2xPKK7PdRYo2NImikPodQma+4nuGvJJZsqdN7Gri0sXMAQz9Y0
         EGUYCHW0qHd0TYeoi7Xsin5+u7GFrurI09xF2Ms7rtfL31mF91HIwdP/XO6m3hkM1Ofk
         fJ9VHvULmiuIRqzh5i+nIFx3RbO2i08A490oCbKoAL2aYyxMPBD3/ibHqFy7WiiqUXhl
         8DUDQPecdnVf4th29Ul32FYtH81N9qmTBzIivnTmpMOYiEimxnUXsT3KL+REiUovMDcs
         UlnAraPRtu/FOatFmUy3+YfXzS+LGz+53cSqo2A5Ix8TC/WgD+bk8VZ3yIq4uppP7tRF
         SebA==
X-Forwarded-Encrypted: i=1; AJvYcCVsycVgPMhzeeLwXOG78lhq8yK+FQS+lYdetvz3Ik7v0H+jvPP5Oyr4Se0A8YpLyz4HbDHeZUW/GA==@kvack.org
X-Gm-Message-State: AOJu0YyzdkJyFHgb/AYfseM8xOafOJxmK1ZWrImoVsvIIbc9KHPMIP/N
	LvvBlkRJmzyHEJSuNhe7Fyc6KXxopvCnvbfTfG+xPgOjFwcKvnD8bOybXR5sXfjv/tb0P9/r1Wp
	zVXq7KpENzetBEQe6Lw==
X-Google-Smtp-Source: AGHT+IE89beyKsvULLcf3UqV4s6rtxpjy11EnRj5cgsae6DgqsLnVq5SrKgEBnb7OKFnTiIg04Lj/tLVIr0qKRI=
X-Received: from wmbz6.prod.google.com ([2002:a05:600c:c086:b0:46e:1bcf:3f8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c162:b0:45f:2cb5:ecff with SMTP id 5b1f17b1804b1-46fa9b02fa3mr29367005e9.31.1759929313030;
 Wed, 08 Oct 2025 06:15:13 -0700 (PDT)
Date: Wed, 8 Oct 2025 13:15:12 +0000
In-Reply-To: <20251008125427.68735-1-acsjakub@amazon.de>
Mime-Version: 1.0
References: <20251007162136.1885546-1-aliceryhl@google.com> <20251008125427.68735-1-acsjakub@amazon.de>
Message-ID: <aOZj4Jeif1uYXAxZ@google.com>
Subject: Re: [PATCH] mm: use enum for vm_flags
From: Alice Ryhl <aliceryhl@google.com>
To: Jakub Acs <acsjakub@amazon.de>
Cc: djwong@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, chengming.zhou@linux.dev, david@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, peterx@redhat.com, rust-for-linux@vger.kernel.org, 
	xu.xin16@zte.com.cn
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8063100009
X-Stat-Signature: inf3q5g9uf5m37ywr1ckmmph1wqzk77u
X-HE-Tag: 1759929314-358035
X-HE-Meta: U2FsdGVkX19AlM/ntX4NvOZgtUz3RRpoH75DpYeLAKr8Y002wSU6+KZ+WOtGIYev4O5a0/1D9avryO5SL4ai8UpVpnJM07kuhouX85J2tdPmeuhyHsjOfnBnCw2PH5EBQk0XxYXcD3yU+PqzAjezGUfvXrKKGGJA4HCJa7/6vu5avSvig01Snn6uk14v+Sz0Q+xBkHHUHC1Ujf6NQE41RnJqOML2x3k3cyOYx99dw7Oi3eLc+mEP7fDljYYcEzoyo2k/hwgPzAYWuU6+Az1srHU2cDgh2wr1xavI0deOJ+sQbZujiv9Mv8GNQfwTqJ7bmq2pDMWjLZckAUXG9CWee/N+QgugAJA/49xDiw5HV9m6CVrKNOUV75Ei9870WSLPI/UC37C0xklm3+6W0lCbNpnBJrns61Ol8AVjnnPI0Dyotbfm12gZ4/zQup6YK3PRMqJ3YdMnSUI9JoD/HUlKeA42oKB8/9FakV132dWsur0TRV5UIg85dCs+BfcT9cnEeuz2xJja74z9DLywlsYHCOCBMYtXkQdHLCiv9MZkrRoS9UNIB8StOeUE/nzfeVse0fPXlVouo0eKyCiK8nxHZH3ATSY7DR/Sr07EBgkswz6rHkIQuJXiFUqhLFpDvbDS5ZTw2yPwJyidEqalfylnEzF5G0BwHakCMCCBOZRr0GV4DKb+DQ8bx10gpuvQRmPnq6IP8oM6gvVjWAJBOp3Z/TfZEyBsr2HFIY87iLmCiQc5vlITS2k39wDTMGzJ5I3RGTqBms2B+q6ni/3R0DortxtYko1DwOq6+wbjonX6lZFeaAQ3gFncPGRKSS27Ov7N3mg1FRSb3rpflHSlfjcRGW1aXXNIpqe/+J7fCGBeduW1z9nn8sRe5x+k/ZnwLO5cPW14+z7St6MFuUIyVasN49BJFjYLzQBve8EW3p0iZMREaclcGsYWJd5/34AiBsAdO4sB3iVmAhKvCUWh/2l
 iG2nblu3
 aqSKr88yiazBOWE2onwOpgAOVBXb1kwmCK9NxiOFyNDYZxLuqo+7OmZFtEO9bNywIaAacin4Sbw8BcFKgkDIZcEyv8ghsj1rVdGSKHhvrDBXU6TGsl3m52uWxOHnBr8yMFV/MORxygwO3zT9R3/CGQfu+T3dQKoVaIb50gs2Pfm3YA1LOwTfY13ZwgwPqZ5WOPd4s0YHB1ggPMyGCYRWTkACeApVb5hU9DtWPdkrcfVqdX7oHq7focVER9+TVW00NfN/FjWwSqc2ThInkEo4zTKRQlI07yRDrANulqlNILEV/Wqi8qlkvPMmqT1doFaFZ8YwtiiJiYTQ/TAyLaNcHIzpRfSJ5NPwBZiDDt4NZMUEGGVcAsTD1ohpuSSGeX4etL81a47Tyr6FdoaCy3JIvJsDc9v+rR9yXG1lFY4mQtafTc6o8lRTQsepQ8Ec/SmOsr32kEe078/4k31dA4agGoipLzZxH14tETgP0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:54:27PM +0000, Jakub Acs wrote:
> redefine VM_* flag constants with BIT()
> 
> Make VM_* flag constant definitions consistent - unify all to use BIT()
> macro and define them within an enum.
> 
> The bindgen tool is better able to handle BIT(_) declarations when used
> in an enum.
> 
> Also add enum definitions for tracepoints.
> 
> We have previously changed VM_MERGEABLE in a separate bugfix. This is a
> follow-up to make all the VM_* flag constant definitions consistent, as
> suggested by David in [1].
> 
> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> 
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> Hi Alice,
> 
> thanks for the patch, I squashed it in (should I add your signed-off-by
> too?) and added the TRACE_DEFINE_ENUM calls pointed out by Derrick.

You could add this if you go with the enum approach:

Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>

> I have the following points to still address, though: 
> 
> - can the fact that we're not controlling the type of the values if
>   using enum be a problem? (likely the indirect control we have through
>   the highest value is good enough, but I'm not sure)

The compiler should pick the right integer type in this case.

> - where do TRACE_DEFINE_ENUM calls belong?
>   I see them placed e.g. in include/trace/misc/nfs.h for nfs or
>   arch/x86/kvm/mmu/mmutrace.h, but I don't see a corresponding file for
>   mm.h - does this warrant creating a separate file for these
>   definitions?
> 
> - with the need for TRACE_DEFINE_ENUM calls, do we still deem this
>   to be a good trade-off? - isn't fixing all of these in
>   rust/bindings/bindings_helper.h better?
> 
> @Derrick, can you point me to how to test for the issue you pointed out?

I'm not familiar with the TRACE_DEFINE_ENUM unfortunately.

> +#ifndef CONFIG_MMU
> +TRACE_DEFINE_ENUM(VM_MAYOVERLAY);
> +#endif /* CONFIG_MMU */

Here I think you want:

#ifdef CONFIG_MMU
TRACE_DEFINE_ENUM(VM_UFFD_MISSING);
#else
TRACE_DEFINE_ENUM(VM_MAYOVERLAY);
#endif /* CONFIG_MMU */

> +TRACE_DEFINE_ENUM(VM_SOFTDIRTY);

Here I think you want:

#ifdef CONFIG_MEM_SOFT_DIRTY
TRACE_DEFINE_ENUM(VM_SOFTDIRTY);
#endif

Alice

