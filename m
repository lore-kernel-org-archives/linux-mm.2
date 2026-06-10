Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5FCCD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35196B008C; Wed, 10 Jun 2026 18:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5396B0092; Wed, 10 Jun 2026 18:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4896B0093; Wed, 10 Jun 2026 18:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9BC06B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:19:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EEECA0337
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:19:54 +0000 (UTC)
X-FDA: 84865421508.02.AD0E3A0
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B631120009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:19:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=utP5HQrr;
	spf=pass (imf29.hostedemail.com: domain of 3BuMpagYKCMs9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3BuMpagYKCMs9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781129992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCXjEr9VLMiB3RNr9V4LUHEdwVcyHXL9rlViMmJIYhA=;
	b=C4b7UBsKkDUA9+gBSCuAtwdFmfEyH0Q5mTXrqYACOYZt6kTJjrY/wT1TGblCic9THkp0MF
	lT1K9bLQY1sd2SBbN+oolMtUqRHqb98GycMlXEC06Q44fWRkXx0HlFWATpybyyBiJtyWNC
	Xzk8TiremyRwKy8CR+fTnkC51gnFJd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781129992;
	b=Wz3RyF5a2oqd8+hu/Y4OxOmxd28njv97xE829g7oSz2kN9/sSdC/i/W+7Lke2h2ISFtWWF
	H978n6i2zEc9iyMhfu2qmRQhDnTZkuq+x+fgVmnQ254k3oyRTyzERY26kNee0yKFvLnyK0
	ltv7J5lDBuEXQR3vk/5v2400uA/hfws=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=utP5HQrr;
	spf=pass (imf29.hostedemail.com: domain of 3BuMpagYKCMs9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3BuMpagYKCMs9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c2d0a8b5beso8706905ad.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781129991; x=1781734791; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCXjEr9VLMiB3RNr9V4LUHEdwVcyHXL9rlViMmJIYhA=;
        b=utP5HQrrvnE81wPAAYxoqwq3ln7KCPZCK/2FEyWfWDpQ2D/jYMcKSaVga9nQyd2swB
         mUiumtOj/v+HPjSYhYuZIbWdbc+kIzPTxqO6hQr69jhxpfPBHpaF/BS+CVl0QEdBQ1y4
         pRm4dqa0i+vWMASZ4xFXgIr8pnhdGtrN+aMqBwr+lDzMsBROTNPfaA+7eE/wFFMl0+67
         NXE2BdVE44OnaF73A1f7aO7kXRE+Nfq+YGPuME6FwdAW8pRmDxrs1UEhm1d5bizJyfNX
         qso230W0cx2NPdht0mPrEsY3TDkT5sw4ug1M77UmiuxdSneGq6j0e8CyY/pvyqB8ajot
         Ezaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781129991; x=1781734791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCXjEr9VLMiB3RNr9V4LUHEdwVcyHXL9rlViMmJIYhA=;
        b=jdRIQK4oQtl7pMI6MlCu25czjVGEpiDJQkfDdo/isSW4KyLWtRvlCtrgZzWaXH6kH7
         FvKQzmXhhhlpg0Xk6A7EQULVMqcJSGe96oeSn7ptcxjqx/xNPGtMO5beHzFPDUkwrNBC
         3+fwEWFiV7XxKpsAsa12X5+yi+kMCZOEpbyUUSKbHLx9SGsa71cZ4euHF7VPTlNeU6uB
         4OzzvaUnPnfPNmwoe8qzm7x4y0w8DSplkKlfchbmNw+z/YdlyB/YHYX3gV9OMfdhRO0t
         InSt5kg5UX6D/v5d8IFfDrkVtH4d9sMDlOVXXcn6qFsmtLoNr9giTDmhaEGVNFnRJXDV
         E7dQ==
X-Forwarded-Encrypted: i=1; AFNElJ/kzO16NnsguwO4OWXlJf44YKVY2ODrbG5ZxnFA9lnN3IHR697MJa4QC/AId1lBv/LOQbf0aP8O+Q==@kvack.org
X-Gm-Message-State: AOJu0YzxKUGNjzx8n3UkzF+Rt1e1uFzrnQfcu9eP3af+3FGaJzhUr7Sb
	MJ0kwVPwWgjjdZp0hf6Fi7AMn76v/K+vZ7sx/vGpZzuE2vlCBBmS3QS9QieXzSP+djuw3SQl+LW
	ZOUB/Lg==
X-Received: from plcp17.prod.google.com ([2002:a17:902:e351:b0:2bf:1958:c64d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1acb:b0:2c0:ccdb:e02c
 with SMTP id d9443c01a7336-2c2a1baf93fmr114931065ad.7.1781129990748; Wed, 10
 Jun 2026 15:19:50 -0700 (PDT)
Date: Wed, 10 Jun 2026 15:19:50 -0700
In-Reply-To: <20260522-gmem-inplace-conversion-v7-4-2f0fae496530@google.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com> <20260522-gmem-inplace-conversion-v7-4-2f0fae496530@google.com>
Message-ID: <ainjBvqDTU5DNZR7@google.com>
Subject: Re: [PATCH v7 04/42] KVM: Stub in ability to disable per-VM memory
 attribute tracking
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 8B631120009
X-Rspam-User: 
X-Stat-Signature: p5iyg5fr35dkwkx5kt61cosha6iin91d
X-Rspamd-Server: rspam08
X-HE-Tag: 1781129992-108348
X-HE-Meta: U2FsdGVkX1/iJ4IAt4pLzNXoBS0hzoRGV34vuFXSdlceUzVExW4YEb+poQvrr1NCSEHiDcQeKbexYq6jbyYiwgYRFnAzRiIKQju/W+JHDTC26ThmT6khYYMeo24pGM45l6jUHK/UJwS8glsZ6r9jNKdCzGVzP/XPx7MrrBSm64AduFdYk9uNPYBv0PPJ7JWaVO0YjUtMiZYVkXZIKTFp1KkMyaO79a5+I49E+m8p30d5rhSRHY1BgImWFmh489lNu64ddSzduJDR+c168DGepHjdO2/FgDJNTHKfbaJMhCgfpcaISsI8Mgywfv3mrDNQL/6SpD69cZBoSCLoakSPklf3AwjJfus/Z0X8p/WavUWtuvncmJo0isRp5iKx/ycWFeITj/RgsQ4yWi4tBITThOv14ARrIwmblZNISl6AM/SQMpy9K2JNtv3gFX94PEJ+ead5W5HTi9UF3UWeQOi8Gd4treRPoUNJis2hAjVv0v73O6DMT2nfHOk0AreS6gcL00p1kmBhVZxjTzZ07sblZBkEjAEbmWEmy466MDig/4ihJ+LoeJyBRzCBDBhbCGaY5+9K3LVr6jFIH1oNI38IerJgkKLGlYtavTqYWFyen3IV2GAoi4nZbW0KpuULhzufDiZq7KwREuFIjIyobgO2nqB9PfFE1dQI3Y6wMbC5pCabJrZCjTOg9hyrhZfNCpwAW6eC2IgzbeUhc6KAq5suvdJcQws/4SoYAbk8cUx6BNJqEmxTwSdUGr4igEeJqrZ6xYUarJ22LqR4ZJ541k73uW8bW5+mLvQFdXptZ173vnqJvemEWSYjm12vrCAOMaagPz3EmhxiEGhxE0dsdC6ksFROYlZgB+5aq8uofCKD7DNL1zQkwdFp5OPwDCV6loet9OZK6RpOHB0fF/JhQq5hVwX3Jen3vCaRJGQ9mIP87atN2ouxBCcHd/7Ybx30L1YIlpbvYOETmfgNLpfp63K
 bFpzPEj/
 wUCMTWxjCQ2m6uOgciHLJuSfZ6xxNay983K+4q1GpFBpE9SQp1AGIvLhPuc7fueOCBbdwxflgBhzo89oatqcukSoU5ZRcswGDyCaywzdErYAve2sZ/L+EWspPcwumb4ba6+sH1I4ViqGFBj8C3McZy/GD+fN9b5zSV6Rhs/zmMrndwbIfATKqHYK8WVHb4jfzu7ojr8FRL2yUxB7cBM/XqguJ/rQKP+LY5qflUOHevi/Tg3oKwvcnlkw4ROnEPBafxlHiIx2SCm8WtkinUDiyEnqdYRGoIlw4uyZ/KRn+gYSXt8ooQ00YmYgOEveNwvsr17+UHr7s0cYr9gCKxY/UImMSDCjPvXBLT43Y72KLPYmBeUXckSEkANZi6j4MbWBdmY/R8lgLjkW6ga7XCWOaPlE1wmM0i6OmBErimyggy5+Csk+Cwax/Ys0l/YKcnJp0pRmjegBT2p0mO9n9oUArEM4GVqP0H7geWHULn9qiI0N5Oi5Q2m0cPm3/thT6J6tmIMoRx4q5PT+qM2pvzEGHngW864wq4J1pAOTbbAlWVu8yb0TmcRwHq4MNW6uPmCHfMjr+cXj0+o+9UeNxruYb/ScbrJaseM5//Cdy0dZoCjcfwzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce the basic infrastructure to allow per-VM memory attribute
> tracking to be disabled. This will be built-upon in a later patch, where a
> module param can disable per-VM memory attribute tracking.
> 
> Split the Kconfig option into a base KVM_MEMORY_ATTRIBUTES and the
> existing KVM_VM_MEMORY_ATTRIBUTES. The base option provides the core
> plumbing, while the latter enables the full per-VM tracking via an xarray
> and the associated ioctls.
> 
> kvm_get_memory_attributes() now performs a static call that either looks up
> kvm->mem_attr_array with CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled, or
> just returns 0 otherwise. The static call can be patched depending on
> whether per-VM tracking is enabled by the CONFIG.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index abb9cfa3eb04d..ee26f1d9b5fda 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -101,6 +101,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
>  static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>  
> +#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +static bool vm_memory_attributes = true;
> +#else
> +#define vm_memory_attributes false
> +#endif
> +DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
> +#endif

Fudge.  This morning's PUCK discussion about VBS made me realize that we really
don't want to kill off _all_ per-VM attributes like this, we really just want to
kill off PRIVATE.  And even if RWX protections never arrive, conceptually shoving
all attributes into guest_memfd doesn't make any sense, because it really is only
the private vs. shared state that is tied to the physical memory, things like RWX
protections aren't so tightly couple to the data.

It'll require a bit of minor surgery to these patches, but the silver lining is
that I think the end code will be slightly easier to follow.

I'll sync with you off-list to splice in the changes to your current series (I
have them sketched out).

