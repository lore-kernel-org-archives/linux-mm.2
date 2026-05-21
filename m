Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EADCD5BAA
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0B96B0088; Thu, 21 May 2026 04:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7C16B008A; Thu, 21 May 2026 04:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDAC6B008C; Thu, 21 May 2026 04:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D40D6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:54:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 279421A02ED
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:54:07 +0000 (UTC)
X-FDA: 84790814934.18.05D7E62
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FAF1180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:54:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8xYa2eV;
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMVZurvnpW2R3v2VYKC4plSUzv3+qTXQO7hckbnpapU=;
	b=uSoo6LR70Cu1alPtOG5XbhaVtQ1Phvdu61mlthHPxXLQxG+VKXRnqc303YZDGiZrVtOw33
	whXI89tTfxyqBveFw/Y4clYOdu7wkeX08m2GNlneM5W2AziWyGSOASBT2Ivp3FaqZDx6eX
	F2u/GJC9X7J02yZO9nkxnaOOR6dBgAY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8xYa2eV;
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779353645; a=rsa-sha256;
	cv=pass;
	b=DcPnNy+JaGTsy0ebNjz60cmrPvn9cQeDfXc7lEJeFlPr4DO1Ml6suCvKx4NKWv/crvmWP+
	CG9803htYivgyi+4mnZSJJF1wQn/5F3jTUwNCyElxGZMIcIGAmMrvtdP1LGnQ0q1VkyTsr
	uIWsNtO8lYeFJioBi7OOHGak7EM5WXw=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d864c23bdso10411cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 01:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779353644; cv=none;
        d=google.com; s=arc-20240605;
        b=l0KrtiqN5e40/PSkyXnT28iQ1SLeAoOrlM4lcG0iE6MvxHRECsowEXOnH3iYl++dUS
         UgmFalh2scz72bSAWamSy+TIF8do28yJqeEnFzKWBmWwsp17YFr0aWp4jqqyO1b3orT2
         C+iDnH5fjAuKyp/pjVY8iHEHQ22xNoh9Hvz07rn6tCCSluUdcV9ewwWX1GHeXlB2T+Af
         G8rKvKDEnZCc39eDwpwn0fTtUAwl9tD7p3Lg4SJgTkX+D5Z1FA+57VBR/8HzdWBHqZSx
         xLLywSsCx7D+ORAyyd6o7p6TFDAPQeknLmcDYnlyHLwe5SGCGpI1q7I3dzJuzXb8CqMo
         fsMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iMVZurvnpW2R3v2VYKC4plSUzv3+qTXQO7hckbnpapU=;
        fh=wsZyLRmZVo6PuUSM/E6lqKvN/EdH15jR3p6/bIvMZb8=;
        b=GDokesCk782VEb3QrT6T1VmzP9uN7uO+G9deG9D4OnzGj3SfGF/Pjxgv6/dURMhPkB
         R6/FAaSL8IZnJhybD+pg0BBZPK7fwF272PAzrVuOyVNjw0rtPBSkMVgCYvhYhdZB0qJn
         FojOvv8c7mR4/+X87vCTTTGEZoMGSfRlLMN39sxWz9I7qFuyFeFchQmb0lDkNuXuRCOw
         eWMxqrkeqzH+eGAG0OeWrtxdPozKPOSTYz3Z1fNnpve4fcyKmKLz+ZTz0MQl4wMYo0wz
         ZPf5z6it7jz7KckO5gWIZh9BHTp3c9v8ZpLZ4Gy5tWnWDaSUOIYq+6sGv8sUH9gvSRCo
         V1JQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779353644; x=1779958444; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iMVZurvnpW2R3v2VYKC4plSUzv3+qTXQO7hckbnpapU=;
        b=Y8xYa2eVQYZx+CLOUk7kK2N24V3pYrdCvqFwTU9bFEmG/CTtXWyQIftQ0IU7I5htvJ
         Pk4JTHo/h/eIuA5MQbg28LQLxIQlEZsshFAbLtMjQjLWAy6SvzrSjugVvJ0ufwd0B3If
         z2D/eKjUepcqENp20gGZnYj8jpiLbq2XMoOc65bmUE1CmgeLJBT8H9M1sPwu+jJlsQVm
         9bweakGcnXnSca/9S5Qy4968wgQwFUyn6Ddlt2bmwTidcEihFAm4+22CUsJjkoT/cjR0
         Bz88x725pylOkPZJ4PyDEv7bH6vRFjI8eV92bZDoVP5u3UT87icLSAeYxoeK4FY8+AaQ
         r+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779353644; x=1779958444;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMVZurvnpW2R3v2VYKC4plSUzv3+qTXQO7hckbnpapU=;
        b=GXLzzVpZrOPywkjvBtIzKR3zuH32s3sPzGmHzocgdY1YuEFTHaqZKotJIaUYoqKAV7
         wzNAZGYgLnqLKUDgW0+tmcFOZSYGHWhVZraP1nR6gW6yZKIMEjhzRqNffPPbFrzFhGkH
         MVBbcdDzNfIRcsAmbqSB09XmamqyU/pkVV24/Uz2SBd9tE3byj3rwliS2X9ECPG/ZvDA
         cvfI8fspibtOlNt/QgoCa28Gl0Cg2UqudBy3KC3nwHSiYLcfxHcfSpFTHvaKEmKEQBfZ
         djR06RhukTsMgUVkgM+Tx125P9gTezorzpSRpfZs+w7tKBubwrP+A9QNBiJw3YrIwm+8
         aohg==
X-Forwarded-Encrypted: i=1; AFNElJ/yxputszrpmKVswO7ldi6pNeCRb5oxTPW3sqnr3O1IDWYwIsvQTqhNGi5GCYJ4buEaBnzu3ty8cg==@kvack.org
X-Gm-Message-State: AOJu0YwQIxPLTgpBbFH9E/lR5Pp+f8MEXBCL2FEQhzEikmbcfmkP0u9s
	IfZ2dDq+kNalk1gcD8rAeZsJN/fz1qZHjf4Bf419L7lBjvkKiLJCUEGpo5UsMmMJFn+z8EgEnST
	PschpWTFENYemCcJkjBHj9VBvxdHsTVbtNXqrsBoN
X-Gm-Gg: Acq92OG9lxCCI64h3tYGTMAxbHKiBSx+Ua8Yq7OysVV9uifUVwbWT4/1MvtIwkQN5Mc
	jGzKdfx28tfMpTDr9D7cH0QaJJhaThvJ8M8+s/FrcikXIM8t9Q4S0zPCA0IJAvPsq4Y9YcVtJRi
	Y2CqGmpU2LO+v0b1KJHYOZsxt3LSKpWvLKUcNeGrRzwQjJD1Tp6tJgPCNVrFsDcbp7FNjucw1ND
	V9LUXihXViVPzu+tYOdRRovYvAXBaKf4FtNlYN5b8VgVOvM+Q3SWRcOuVqKJl7lqtdcPna2BwiW
	AGQmwPcAeMm/HPBr++E=
X-Received: by 2002:a05:622a:2682:b0:516:cc18:4760 with SMTP id
 d75a77b69052e-516cc1848a3mr1318811cf.21.1779353643586; Thu, 21 May 2026
 01:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-20-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-20-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 09:54:00 +0100
X-Gm-Features: AVHnY4JjgkDwC5Px9qxOcGZwEfL7vQEDZaLkFA7McDQJ3moR9Atjhj_tt-FGzFY
Message-ID: <CA+EHjTwkX_K4S4CHNFvoP=vDUnzW9MyLxBFZzDrR3tM6yuKNTA@mail.gmail.com>
Subject: Re: [PATCH v6 20/43] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 353y4upfswn8rtoppt6qfn7oei74qygz
X-Rspamd-Queue-Id: 2FAF1180004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779353645-716237
X-HE-Meta: U2FsdGVkX1+zDOfZz6VO9/W277GbJXf6wpKKRXAqsXKoGAyNSRO5j5Ma7VJ1Rppk5yvsydYl/gIe1aiu/UCtcUkqmCdn9M1/7cjAh7CB6WjQo2eixl6AdPIGRv6A2q67jCeLarrEf6bbFka4vKqwlQnMUuVvUXL7cgqpy7dsEzWSwQMX6fU+eG9wDkZtZAxO2Rxf/eKTEO7tejYAuLS8c2BraytdN3tfWmCXpjPF/VkVpmNO4w16l85s3V1JtCQ63G8jIstEUtqmZNTUOTRFJPLQSjx/jWPYPQddFPvDeT1PJZsll7mfOqBn6lkakzDGRY3JSSfL7P+PKxtoF6TK+sKOmehkAjqVHk/ohv1Q71CeIP2ccmy+YCP2YMqPGdf6eZUWz0ZzfYC78Kodw6NmaAtSnLTuokb31KHzVjKgMIYEdlHCk+x5wyU1/4viM9nXApu1hk6zBjZry5WHw7TCyt+S5g4SappdPX+FFh+t1Vs2pTnUON8indlea67f/iXM0DIjW7Twmyjfdv3vpOdBqmcKN4c4bL8mfjnXaZeadfizibetpizOL1fcNLhtq5Wx4wN8rYVrle8a9DV9cdwWU74lY0BUPzcv+mTkcJPFOYZmjBX3nmgofEHWYqKWejr8kVT6cqbe96Qj2jldkEB+g2LjUmDKgn+HRivdlPXBd5LyTEO6ytySiCQhxKqb7PpCHO1tI0/bP73KLKWM+3zlH0fD/LxAhLPZUP+sRXf2hrHvyWECZTObb0FSaPWMgAbjsq1zXqJg9X3DsF+MwG39/bnH1W2aswzkiRw1VuNggd8AXGqZpD3JKGIYUiGv5ZhTp8CwgRwmGoO5r46Pxshv4pTv1cPrDQrHE2wwAZg4afo9oL0jp0v4wqRhjze+Mgw7Tf9oB9MR+MCR20Din809VsXfI4yTYURPjuoQMiqauhVJkCl/skv4BsDOK3FTYfN598Pyc/trX9wTKA+xnlB
 TA3UkTlS
 p0MvJaR/ZVGD5qgc/5VNNO8Q74GrhAom8RqwCq2KjSC6tlSUwQU5afcuPJe4dT7OZrRjiCOBXIqW4hiXTKgM4lAV3kS+fAfMzBuKSM8b7J+yJcHzK6pw3nCqeUR31ds1vJV3nv8XcXryLqzLOPh52vSzilx8i80QzXfPKf78DsUc2DD6gQpCr5ebmd9K3hMl7QYITiE/kkgUqcB98WFwPuVkpHaBEaLZEUpaUd3oy70KepQcMH3/C439gO26n3LlX2awoKQErILAFO4t6Qq77SVcDyDS6cXxe0UXy79xXG/QiyFQNAcrBrgpaBhgWtAyjqkoUMFZ8ZADxY7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Now that guest_memfd supports tracking private vs. shared within gmem
> itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
> for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
> are disabled, i.e. when it's actually possible for a guest_memfd instance
> to contain shared memory.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/x86/kvm/x86.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1560de1e95be0..6609957ecfea3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -14172,14 +14172,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> -/*
> - * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
> - * with private memory (the private vs. shared tracking needs to be moved into
> - * guest_memfd).
> - */
>  bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  {
> -       return !kvm_arch_has_private_mem(kvm);
> +       /*
> +        * INIT_SHARED isn't supported if the memory attributes are per-VM,
> +        * in which case guest_memfd can _only_ be used for private memory.
> +        */
> +       return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
>  }
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

