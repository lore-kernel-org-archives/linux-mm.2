Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C92CD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43C76B0088; Thu, 21 May 2026 04:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD706B008A; Thu, 21 May 2026 04:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E816B008C; Thu, 21 May 2026 04:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E61B6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:08:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2ADC814057C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:08:21 +0000 (UTC)
X-FDA: 84790699602.19.2D3EE86
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35C8AC0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:08:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pjQOtVQG;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779350899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RmlTBsfZu7jfSANKVaOagnr+/jgA52gkBUY+7wdM10=;
	b=D33tsPKV9G/MpE0jf1Jd7kO53fdFBdYli+BAijGyUhrUjC5xE53HgLp2ODmkwqiTgDY1EQ
	DccMUSKNlmnBVhCrl7hZOg7U6CH8PdnJi2UnyMKlOTNfhtt5E49cdFFBNSVmbIF5Ais+4e
	ThhNu7IY4dqmTRbycU8o67bwAZ1TWqc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pjQOtVQG;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779350899; a=rsa-sha256;
	cv=pass;
	b=21rCIbN0PLbv0yfyolbJv42QGNs2VXqC8GcMHG8Duy2v0RZ/OQ4d8VvrWO5zLW2sP3oGbi
	w81S2hU3XTPKwxM+qd1KCurkpGKazuHdL6dnB0kTUqK156r+HMWD0+UXp8MHYDnooSxwFH
	LLMxj6j+sDG0+y5G6m0plPpwKp0571I=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-515548f390fso3421cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 01:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779350898; cv=none;
        d=google.com; s=arc-20240605;
        b=JrskVTcYh5tPt+V2DZ6CjEtZ7MJokDjLOeq+Dj4BFK1PuWewmo0p3UkT7HM6XvdaB9
         2iPK6zSahS9ca1JnyM9pVBJiMlda7OIULH3csNXpOTCN2E3Dq+tjMyI5YjAo8BSzGNqb
         191G/qbl/YzcCPlleFl+qa2LHKsIA0L3cAsAZSqsAXb2gKKY6w9X3D4fYy3QPz3FAbqR
         9dMWubMQs+Tw7Am/Sx0E3DHwGY+n0HwGxogpAzoVW6kYxm2+EqoV/AzSRrA09xPUzuDV
         H1M5yPM6ifZm9gb53EILZ6TljFTRkMyJ2Ra/vrKstcTDP5xKQvqy0jillEDMx1vB575t
         I0ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7RmlTBsfZu7jfSANKVaOagnr+/jgA52gkBUY+7wdM10=;
        fh=Vd2lqxDV6+nRk+NdjuydcvNlEA0mCV1Ben5UOob0iP8=;
        b=bMeViT5aOuqeIHIvUqDPeUKkpGz7JprkoM5jkW311XkT2F7FPS+1aKaMpzjQkYh/7W
         LYU7RR77r+FFLjokm7qry2cmctcMka5iZTFTW9Lb4DO6vQ6rclA2xSREweoXGAhdFOFJ
         c5W5Nw3xGOAcxELPHwaihLDkfvoy/dVEG2bC7mCkj6J0wH2Dznb1lvB7cR0IoNegqMCi
         tIuAI6LFUy1tFijBcQ6x9QlBQ+OJg200UfN0HJ0LRoXTBprLbBGsDXNG0jhznnF+gNpF
         m4epIfcGaS+r4F7Bh6D1q4b6ebtw+L9DeDyndwghkHss4xa4VwKPiJBg47N3NvRxA4z3
         sJsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779350898; x=1779955698; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7RmlTBsfZu7jfSANKVaOagnr+/jgA52gkBUY+7wdM10=;
        b=pjQOtVQGOnRJmmDkjB+cPRj8LDcyL4nEptfIfDDeXhDLF5CcucyZM8I+fx0ddLHHpA
         OyDhLw3QLddvWLTNbnhdymeNKBkwu2OFx16eP/bzTSI9DkxD3HNnt9FqINuWvCpib8Yf
         WmZmiIhb3JDfbqyu+GmoZ1y4pocdGsxwM4Q9DENwqbZR4sMmCxHwFuneTwyeEp/pwSDB
         6TZJElByhbJViFsx5QB9UUkTSPfdJjIkhxSjIXZRvy8A3jPJSxnorm8ZoDHLh5LLlNPz
         /Q9dndsYvQb8/khToInH2sy0yr3cm4ZFI2PMVijwUuBkByhPFV3vDW6wJUHTYEjbym5H
         hiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779350898; x=1779955698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RmlTBsfZu7jfSANKVaOagnr+/jgA52gkBUY+7wdM10=;
        b=T/JGqgb5K7h+kAc9znGe7eJl2ipyQe/oKbe8OprQknnV1wWoZKiLIKybnjNpxG89Vc
         yq1I9O9gwy8RC9b4Gcvhg0J/VtpdquGj5/ktVONb5dl962CCbaeb6rH62Patug9LS1w8
         Ljp4i3xuIS3nVUE05h78ZLP6mjx03nupPSKZKqkR2kzo/XuDFXsBhmNUsHgAdtAWf/az
         5P/gWcE/I7GURNfRyJi6JAyccu2ydRyPjg8UmYZFJPrZeaCTrcqv2fXZplCGI/+WIPNs
         A2nZEAXq4E1buOq+AfhXF+MGcRm6+Jz1PR94GZ/weKTT57XWUniOFoIWksYCIoo5L7Nc
         CUlw==
X-Forwarded-Encrypted: i=1; AFNElJ+l6zg7sqO37CF27+hlKdCOVH8MWkrQJ6iN459Zf5wUz9GGxBrU8jL9SgG28OoDr1/FWVwSlRwhFQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6shn5vfCVI71ttwd10Rp68FNE9VvTdkxgjgSxvpDdMLfbQ1i+
	DYJHgfmYmy9p9ITAMr9iXYJHio7fZRP7EO9lXE2/6Ghz0xDuTgQkSR5cFIDbiKPi8jzyDe6FT7U
	8VDZfu//2+xS6qi/qHLb8ojJpMFcTVMMMqvHp11BC
X-Gm-Gg: Acq92OHsO/UHpH5RAaqJ3P3WUusmnYXZXwOWNydAxg45+LliF2jv80nz0GQUHeGeBbz
	84SSwMSXMLPm5/4bne8yArXeXqnACWJHbt6Nqr3Wb1nVDUh07AfjeoimpCvRJTxBVYlDoXGw5xr
	BKGCcHH1RbyJbCPty/luaM8R06zmHttCBahZ8jrdJggLJ+p2MJp/If1sZgxXHK4WpWBsmlsyBRg
	ys1ujBrxgmCBpVX4GExj6RzZcIeT8gP0lhDmVHSxY3kinBSth1lzb0VO7+zs/kLohTLka6+C/QM
	BiocNjPcbS5HhMpPoq8=
X-Received: by 2002:a05:622a:588c:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-516c534d1f0mr6941501cf.6.1779350897637; Thu, 21 May 2026
 01:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-18-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-18-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 09:07:00 +0100
X-Gm-Features: AVHnY4K_Cpc3lp6TF05Y1I39E-kRC-mXXncMC4rrkZH8FAVJjZ2CPai0rhLiTAg
Message-ID: <CA+EHjTyiAgmBQgmrAHAHx3G1yKsP7tSgd9r-y4oPKQM4Nn_Kjg@mail.gmail.com>
Subject: Re: [PATCH v6 18/43] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
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
X-Stat-Signature: re398dbdhy5zdzujj8sf9s47hiyfzitn
X-Rspamd-Queue-Id: 35C8AC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779350899-309792
X-HE-Meta: U2FsdGVkX19LbJj0u3R1WIHE0YgqFi7EW+5CdnMxmInRRDLwTUPTTL311qHi/g14A0IAnj4anIT1ILaeXa3UP/uWUiUv4Wnc8QUwogtLU40nj1SNpyQAsAyFhX4VKPF5HHKFEw4pr1Aik6w8iMscY4c6MNTXzI2Z/u7ZJcO01qk90REcXz/xgkM40Z2GQzc6dTi+dgTHcVxnEf2H6HGUIq+SaINwU+FD6mGppzGaurgC/BkFX7+cy1KsUno2KwgAd3L+gLvrdHL3U//WhDvo757nG0X1g627YGwrinCHCsMwrGbBzfUmmyWg92dKFtQI7G4Hr94pzZ+O4yXpUS52BOUYItYO3fRmcnvo6u+twOrWwi+u1hf5lPzu6jZ/fKzJpm5sOYK26pi4ssC8PKkevVjDoE1pXabM+9N6qy6qSAZtUOwAnLIEqvxpgCsEUjtqs+N+Crs5pk8kGdIiLTqX5HCmlsRQuqS2BES14ktbW401mwrAWKV4UVxwEd0Awq+6T5E79Ay5vhyijiOExWktecx8lLtunvHpzy3sZClm+EBU00qS0QukHYcbpIMrcMPDwqpqZ/iaVAkZsOZF1ht+TT5CfGCs6P2fnFkNm1X3m7fPuPPbptZXiyVOA4UnJUzs1CFg64zQbViwqb3625U382zGorBpzpi9By5hTSQ7LXgDpsO6DdwoxHSkPZ43a4Dscu28NoFGBqhMcavmXk5SX2jnJO0quD+DRR/yPrd7eM9PObFRup6g7qrabGNNiocZcidxSWyeS+Aq1NKx+dIGtZLwYfBosjsU6X8HvCJ/25atfs+VeubZJO5BbhiTbABbltqeKkvdjEPYpJinG8W9LMG9VnCDZW2treByZK61eNK6cBp7kZxL09kWxiA1Wnc/E1PiXfoovveI06dfsiMzV2YlceF2jfhU/MyYZkKboDuxSGjmCIjdrmqV4quKEB5I9SgblSn1/qK18wH5TVp
 jlfSOaFN
 BYIQuHu6eZ+H+2HREfxCimv2oOxydAKK7x6OTVDJbzMK2+/yaglc/ylZVMK1GL5fhOYjUgc9/adW59ggn4g+zTz+aUifecItK5xl6sONY7QIy2lhMxm7Y/DxHu6KF5RPtW6YkuxNMKxGxwYvmJ9w0n/x84cilNEsctsj8coEUbbl4Fi0GxMyFDbFOe6c7zK6O3XUNnaOiImoL8U6/IOH1k/hu1EadWdW9aP7iLhAa8HMk5KuG0S9+aIDoum2q5E+6rmusyYnY8CAWDDGvF/nvk3BzZhwHE9IU/FBAb0FG129YpIJSwZMnxcSVroqxMwsjg0wn5JhTedGmSfc=
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
> Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
> from adding support for per-VM memory attributes, because tracking private
> vs. shared memory on a per-VM basis is now deprecated in favor of tracking
> on a per-guest_memfd basis, and no other memory attributes are on the
> horizon.
>
> This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
> user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
> Now that guest_memfd support memory attributes, it's entirely possible to
> run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.
>
> Leave the code itself in common KVM so that it's trivial to undo this
> change if new per-VM attributes do come along.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/x86/kvm/Kconfig | 4 ++++
>  virt/kvm/Kconfig     | 4 ----
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 26f6afd51bbdc..b6d65ee664d0f 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -80,6 +80,10 @@ config KVM_WERROR
>
>           If in doubt, say "N".
>
> +config KVM_VM_MEMORY_ATTRIBUTES
> +       select KVM_MEMORY_ATTRIBUTES
> +       bool
> +
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index e371e079e2c50..663de6421eda2 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -103,10 +103,6 @@ config KVM_MMU_LOCKLESS_AGING
>  config KVM_MEMORY_ATTRIBUTES
>         bool
>
> -config KVM_VM_MEMORY_ATTRIBUTES
> -       select KVM_MEMORY_ATTRIBUTES
> -       bool
> -
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
>         select KVM_MEMORY_ATTRIBUTES
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

