Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D7AC5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27886B008C; Thu, 30 Jul 2026 16:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8726B0092; Thu, 30 Jul 2026 16:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0AA6B0093; Thu, 30 Jul 2026 16:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE3C56B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:35:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 329E61A0292
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:35:02 +0000 (UTC)
X-FDA: 85046597244.25.BEAD844
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 353D3C0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:35:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mbSv3fru;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785443700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeYSeUDQaPUMgdnk0OR676C/F3UEN+xBjEeugnIWfJ0=;
	b=Y1+EkF+ZDQhm/p/+wnTaETlURPVOhn2UY40DQBsepMY7HrOAzpriq738x90MsZI4W2Jtrr
	DNPkX+VRK2Ikd6HSp2PCExkMswlJRxZDlVuSIYa2r7tc5COqI1uWWz5WoRfi+k6Ig5ZU2S
	0vj4hTzgAnemCFk+s00gYCQmXURYdAI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mbSv3fru;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785443700;
	b=mX7+XiFONYm0qxqwI3bP8JF+JGEAMA3XOmLhN7tF4xS9UxN6WeaW+n1z5jcZgsreXRhbvj
	7QGFZjv4qZOCm+jhSFFX5d8rd+caKRtdz+hDl66Q8e1Fhw66WjUO+bf8nb5r+CDEMLEfTw
	Y+79XK+rBsfccDvyqCtLqJC9+7zJsYI=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e58034d05so343494a91.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785443699; cv=none;
        d=google.com; s=arc-20260327;
        b=A+4gJ4O7VcZsIt5hsxGkrGT6yuMLAfLzXtmNCVyDFT+ERJ/aF8VNXod7l5bAgMUZjU
         qRNFQOu2OVJvGDFj7f6wdvjRz1n63HTPQvQb5EoMzGlNx1I/eO6BsVeNsoUBB2ppxORA
         JwasW+3/8rucka8YxXsK9MpcQb7hqQ975Z9I/lfGmFXVLMrcdrpblAo2sXGlksFVPngI
         0kH7itwEVzx5H/76RTqQWduyVCmyA1TSydUS+i64rbZym0OKPZUreBJxJuaNFPgD4n4F
         H+vdexwlX2fpmm7btFmot/1QO8n+yOU+p+vL4/5f8bfUgnYh2vuXRnQCGuwV42UXBFnl
         oQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ZeYSeUDQaPUMgdnk0OR676C/F3UEN+xBjEeugnIWfJ0=;
        fh=3BbCT3wn0t5CYcDC3ERadDGVa8Xc3EABVC/W3bQWdwU=;
        b=Re11r4jv8YaNeReEcYlSPAZ2MsSLbXipouw0A1VyHxqi5NorravGsYVDHLlQnUSLqS
         f+av25ODGeXQhxbxqki0zorclU6rnBRyeR32iFBfm5/2SlB8KSIuVv1gNtftnBb1+y0q
         UWnaLt/GYzfGahsHO/t40+W11t+MwkgFArihqKx5+wClSPrUITxxsZVZuQ6c6KcZk/1i
         0IpLz4xB7Fy+zs5+6TTZLM+Wnj9U8INWLXrPPepvn1QBbJSBvpqOBvzomGRuB0QoQ8Mw
         wi6tPGu6073ks0quh3cvyCvvLrYHuxfr6zBrl9L53RTeJh15mf6s5EIlECwdR7pGl2ai
         6v5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785443699; x=1786048499; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZeYSeUDQaPUMgdnk0OR676C/F3UEN+xBjEeugnIWfJ0=;
        b=mbSv3fruDqdKzzWU+ytfec8Hd0JT0Z3rCLg9x+aSV1CD5OpJ8jMt9aDwkWnRIgN04q
         5N42QDNtJCoEEEFk9mVRFB+tF/aD/BF/m2WVuwtI+UqGBsQhymimDMisPUc2xBLqAre9
         bFPe/mY9yWbo7M0RdOiBOyv8kjmqUvMSIxHuQVKHk6SThdnigIz/pJ7KGPBAJd011W2B
         fPgx1NiCcT6XAhL34ZTZcakikUGuvBDue09cLsGaTZl5/hk5kK3YtwqGWRhWmctG743q
         YFtAhE0kMC+5PT/yZzarjVCf7ooQlBOL8rbT3bcpCNtEwixzSlKnl9aFaCPTF72JnHpb
         3efQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785443699; x=1786048499;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZeYSeUDQaPUMgdnk0OR676C/F3UEN+xBjEeugnIWfJ0=;
        b=mu+RSWMKtz+e2tAj8/S4bXHp5gG3656et9aZLZ6ZUaLYRb6/zOOCqV/w17o9IS51R4
         Ad2DCrXbQPas/l2MLRrXrtkHaktPRHiFlihPiingsppl6WzBH+FVO8cjn75mpz9Xs4+d
         ZLN4NxwGXCv7RaYSUIwTH3SlyQtfLLtsBpeBbbJx2orZiqKG0Y35bqJxyNGoZmuMuBcW
         hYC9Dfr1zJKLv0wovid/O/rtclaVjavInL4gwaT5K5FwEo8XJKKxabI1GexAqgZvXwYp
         nha6BOUkQMZoVaDksER1UvDPHGQ0Jb2S/6FGCSRLgyIWgB2PN78BLNMlWKxpcrjNnuDF
         T/OA==
X-Forwarded-Encrypted: i=1; AHgh+Rr3+mCCzIu9EErZ5Dxp04uLQxsGt4nTohXWYjB8HAbo3YLl1gA/RpgS1RWy/GTtTXmJ1+LfoTinYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2LT9C+Nwd0Nl3X6OKiaUcGFIg14fR4dXB35oYzS8OVsS6m7wS
	KoVDP32QbtrCecOA3zTuajFK4abA6RCgnkWSOwXb8do9tZ35uHF//elwFQBJfdR2yvJXlkRGp5K
	Nz9huZ1mWhdDADPN/8V/vhd7fz20RKuxk8pz8L8NZ
X-Gm-Gg: AR+sD13/cqQq8HCbU8HTMkWX2rpxBLFoDjonHI1lDMD3FcMHEp8GALyIx3MZQxQFx35
	t/fsMNwxRv1OzUsxSXhJTrOfsAmxfnSmDCgTRZquO3sd9hSmSuSaDblm/12MqfEtLPSY2Oqcvhr
	LIfG6vjY1emE98jdOdlFVlXq4NdQSy40cbztU3A0Oieb2/Jx4wcQddSNCdvfX74wld9f1W5Tqt9
	8/aPDye97JxKn3wp8mqDkcojMK9l+dICvgcqwBwTRpEa74xWS8XLMXCCQ4e7GT4AJcfdrJnVJR7
	/FwaVkVszNoWMKBL+x8Xlf4KJA8Q/3+gv0ZHI/zS27e5iddtE4Jd8IUkCfZFdp9ZE28mAmUVvbh
	tUkUbzcaHnMXeETOdTDIAVGM/NA51ZqbRbms=
X-Received: by 2002:a17:90b:2c88:b0:38e:2c8f:a01a with SMTP id
 98e67ed59e1d1-38f9bda173amr3473378a91.11.1785443697893; Thu, 30 Jul 2026
 13:34:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 13:34:57 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 13:34:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com> <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 13:34:56 -0700
X-Gm-Features: AUfX_mzoiUtQGNkPMfuHgGb11yV4gcaKdQOzK-P2tpO8oMq-FVBJLM1nZe0Ady4
Message-ID: <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 353D3C0007
X-Rspam-User: 
X-Stat-Signature: we6ze88xpaa7hz69yoe3riioen6683dq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785443700-561177
X-HE-Meta: U2FsdGVkX1/rYoIJZ80J2xnY4wL24n0oqJWWp+u6yRjC2nn1pSU9zsyMWbTQc5vJgU5aWFZ+FioEGeH/c8hRL/JpwedhIgosz0epB/gZkn0cpLznDrToXYt8Gmbn3EqeMZh/9cWQ4uzjofWvYNeLrsjps05cppT1ciuQjL7fE0GcvIlpGI9sui237OGxvxES9Xfygoa0mwWo8ZnusHdpnvgF9TSahMy/z//QTpqjH++mHfygX1/xLUheCc18IZq8QtEyDRo2Oua1cqjXPW9OtUMmG4BP2Kq8WE1JOqoP6Widm63LoueosqDGA9F4zBviqMaPtuW7UV+scvYqLFmY+ab0O4QcbWef20Ai85c2cL2FQ0/XWIzpJwFY6wj+OK6XmPiTBBCCzb0LUkxSdN/csATDgfN544OZyconktTDZQkjNhfLEP559YuoumG52uCMzOJGqvnYx/ncaTjVl0I/RBv5j9Zj7IOctygpLYV/oB3SMcb33tLkDBuXmz6sHenO27XTE7/Vc1vY3hirNzOU0E631savTTxlQ8GJa23Mow4hnxVBknB3A+vbEaqe7h9MAxXNxgM25yJhjtHLdAKz23wj870ZVHsxZ3VBdsjoTaBrBxTBiIQrvafH/1J18K4zmFFJqNsK9nWMzgCuWZEcRIu3i7+0JO/JzKSJ/8bnv1A6001Uj6XikVp7Esn0yvYvZsE4NTPMbBLGyxi46EiBDSkBcTfvRQIfJrPCWPidc3kVNhQuGpA+7hXThA8kqWryi9tSM5ZHcbZYlYwgGcjGJdx1j40WTl5mixpiYEqWDtPdpO06H0gNJKx2Lq1S9TqCQHUnfY31LC6EpGurZjGl4w1d7eLE6nZh88UTKRFYvSHY7/5pv2itOpoZrcx6cI4DEK/iRCgdev6K+qSrgRG9MGV75ctqzcObCivbqyqQF6F8eaezBAjoU/Nf+/VAdFF8WVV/LJcv9kXQ3rxv0d2
 pGcUmKkD
 DwpVN9xz6Q5k5KqYUbLEpH9Xxl0qP5rk2CFcOX2e8Xqe59Vvn2H1bFgQREzfzXxmTneOj0NMrn4TBFu816+J12gJC7S5tNvT4V0/Z1PMiJZ1OAm/OgrvKANLFVATSPoMKaOZ9m/FAIkKiDhGQyhwXYBFxh37CY3FyuGQZMxWTrDVbCVmzaic/t/M3SmYtNtjeOxmcjMp1Ymhe59xDE9nBSwj7nvVHSaJr44LKckTVRc3+MBoDqQ9Ida+ZqSerQRN+AXTdSQUtRjk2rCWEYzin1GktboU78a8EwQdeJLjNuFrknS23hcv1Y9eeu4XhmzSMC6Lo/xIu3VylDEHVJmsM6ebUMuoLI6MEQvhxO9O3Ihmolzz90tzcK89iE2wFA+fbwoHTwd/2/PJ4qgE/pEWLII15IrvnaUo7mounEdKD4kuOMJJUVCNPoCtmbMoEoP+3c8OT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>> From: Sean Christopherson <seanjc@google.com>
>
> Though the patch order and diff of this patch is adjusted to what looks
> in v7, per Sean's request [1], the changelog still looks somewhat
> confusing and part incorrect to me.
>
> [1] https://lore.kernel.org/all/akVGZOeR1ytfkamK@google.com/
>
>> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
>> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
>> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>
> As I commented in v8, the "in anticipation of" thing is not correct.
>

What I think was intended here is that in patch 20 of this series, "KVM:
Let userspace disable per-VM mem attributes, enable per-gmem
attributes", this part

  -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
  +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
  +    defined(CONFIG_KVM_INTEL_TDX) ||		\
  +    defined(CONFIG_KVM_AMD_SEV)
   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)

decouples CONFIG_KVM_VM_MEMORY_ATTRIBUTES from
kvm_arch_has_private_mem().

I get it now, so CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not actually being
decoupled from kvm_supported_mem_attributes().

>> guest_memfd support for memory attributes will be unconditional to avoid
>> yet more macros (all architectures that support guest_memfd are expected to
>> use per-gmem attributes at some point), at which point enumerating support
>> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
>> supported _somewhere_ would result in KVM over-reporting support on arm64.
>
> 1. I'm not sure what "memory attributes being supported somewhere" means.
>
> 2. the kvm_supported_mem_attributes() will be renamed to
> kvm_supported_vm_mem_attributes() and it's still under the guard of
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES, what's relationship with "guest_memfd
> support for memory attributes"?
>

I think another way to phrase this is that if we don't make this change,
say, on the foo architecture where there's no CoCo and no private mem
support, kvm_supported_mem_attributes() would return true for the !kvm
case, which is over-reporting.

How about this, replacing the entire changelog paragraph above:

  Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE
  based on kvm_arch_has_private_mem being #defined. This improves
  reporting accuracy by not reporting support for
  KVM_MEMORY_ATTRIBUTE_PRIVATE when kvm_supported_mem_attributes() is
  called with kvm == NULL.

  Give architectures full control over overriding the default definition
  of kvm_arch_has_private_mem() by removing the coupling with
  CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

  In a later patch, kvm_arch_has_private_mem() will be defined based on
  whether architectural features are compiled in, and made orthogonal to
  CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Shivank Garg <shivankg@amd.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>   include/linux/kvm_host.h | 2 +-
>>   virt/kvm/kvm_main.c      | 2 ++
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 9f78a466c6f3e..c125d2e8155a7 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>   }
>>   #endif
>>
>> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>> +#ifndef kvm_arch_has_private_mem
>>   static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>>   {
>>   	return false;
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 902aa166c9c0c..9501dd8d015d1 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>   static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>>   {
>> +#ifdef kvm_arch_has_private_mem
>>   	if (!kvm || kvm_arch_has_private_mem(kvm))
>>   		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>> +#endif
>>
>>   	return 0;
>>   }
>>

