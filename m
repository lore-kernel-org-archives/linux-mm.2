Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D35CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DAC6B00C4; Thu, 25 Jun 2026 03:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0555F6B00C6; Thu, 25 Jun 2026 03:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEB66B00C7; Thu, 25 Jun 2026 03:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B49DC6B00C4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:00:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23255405F0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:45 +0000 (UTC)
X-FDA: 84917537250.03.49EFD41
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A68640005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJw1YcM+;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782370843;
	b=4IShriJ4cUp9BdMbc5mTzJSS5Xhoz48XPpfJDvj20NrKVUFXYAgJT9Ja0j0koQwnEHFStQ
	qKHMX+EhJR/nPbam1epLZumhzbeqBf6QSzPaRX4h/DWvBsppKdpFdzrS39b5gCeppd6DIp
	o4BtLMOvwR4i3r/gaAW8EGPLCw7053c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7itwZj77OJzx0Nbk553L+ihvDTrBn0KieHsapLPAjLw=;
	b=w9ggDgbSj38PznEWuXHKxxcadsPHF2wCep+5RL8CSfqh1NKQCw52sfClVtH70po1t43b5K
	WEoj/zmLph+StDZeY2YUBBjNC3yHdCV4hXFANwqts4iKne8l7IhihRUUg66qmTCSvvQwRk
	zh2bFEH0IDSsbw53y4UBgyNDeDBjmUk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJw1YcM+;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-519ed52bcc6so181411cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782370842; cv=none;
        d=google.com; s=arc-20260327;
        b=C4RmS/3DVpioMl58pTeMup3FYRh9SutiMpgjjqPfgLCEhkt8SH7A2VXo4TKg0RAQR+
         ygHZIn310P1GLQZFWvtPDI95oQysc4H+zZjHacVFdtGayk7kFtwPQSlsvrPPNffyZeHp
         qF/2xyCDJKfqYN5JRsBKvuTOx5OpviR8nLNR0QWKj3LGMoUogCgewwzALnC/cGVXO74u
         op1w4dSa1Hkf/y72atVLSRk+1VWejqo/1CAlB7J/zs/BxcAneskwJKOzr7DcCL7X11Fo
         RWsqelgDiS1axYkOTbULhG+iUad/LpswR20dyj80aAzWlV2dTV5b/ZnZGNyBMcFpIVd9
         f1WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7itwZj77OJzx0Nbk553L+ihvDTrBn0KieHsapLPAjLw=;
        fh=TW+Sao0rn8mrTVbAB884wcLSrJ1tya3BH//tKSQFiJM=;
        b=GycjIRXP2dckhb14xTkiUfhr8xnTvy7buTg1BVOPRtWK7cY5/pucXtZHEj0gTIau78
         VNCL2iHhVMxo0/AhuoQDIVuTtveJg8Rl/h/xRrLw33mtBRpOnY+XU+1kxf4jtXxI9Hs+
         BZvg4vbljKEVH7R17eNmKilKs//jiQRkdUCTKpnsvO3ReNBOrSRWmeOhYR7lZTomIhgV
         ZlJ4dWDt1EQKPPm0KyYwyaLEZAiRNBLr1t/VXxg4927pDd75CFmj7Q4aPGOb2utvGGoF
         PSIUrgKPf1y9d7KAvV6OP6Q8kNhxqIPikv/Q0d18jqCFBDl0i+ulcqpIHsvaEFC4x+ak
         /StA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782370842; x=1782975642; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7itwZj77OJzx0Nbk553L+ihvDTrBn0KieHsapLPAjLw=;
        b=rJw1YcM+ryUr14iR6zI22WLxbQeDZdVhaweLh75ipraeEMvJr3XhNoIFvM5HvgTLHc
         VPZbnjacYNLkIwsMBxOOrAV65ckaFI2sLli1UtJNzLSYdvC4cu+qHSRcH7B4yff6xmSj
         iQzFtHMjTds9xfkpQ8vZ06wfaRMY2qV/mbPM9lYEUPu3dP/K84NeStNAAGGsYJkBifPI
         hNsskRviN5k+RgSQAWQe3++mz0MPdJnX2t10yTQXhHP4HfaacU+fXkUI4vfH8z3fh4qD
         2KFj2VepPxCBQoA7s2zuTMNerYCDJt2MeT+4seaSgzqdD9nOil9RiDrjL6nfCheRn1Sc
         xhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782370842; x=1782975642;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7itwZj77OJzx0Nbk553L+ihvDTrBn0KieHsapLPAjLw=;
        b=HGW2QFO+GfAB8CHtA8wuLlrL3DUVKHuv47zXVwqkD4oFtZY5zkpVR4DY3r07hPy2bo
         j3JnaC1uOQUcpv6ymEv83hqv+EZWnte+EjY+Fdq0DiGagjPbZIDQiham0SVpumO3718d
         lnCWu5+mNL/Af+TXmsVMlHgy+S7FXL7zYfulD2dEch82bowl9Q0s6LJXkSJt1PtuNJBw
         zN1Zvt5/qqgN5G6UFGJRHUD9ZWgMsb5XfKSEPFVpTacwJupoKyYDuYmss6X2Rt5g/Mfo
         B0UKMAS705Bp0X3RACeouVA9xiyHsHqvAOjkq+zipu7qOS20ZnRTQ77pzh+SWzF45vkr
         xepQ==
X-Forwarded-Encrypted: i=1; AFNElJ97fwSBa5lcg2IaVxF7GC4NoTF4Td5N6ugRlx1m6dM/7qgffrZaCUyGMAfHysxsz6SmVjxHXUmiuA==@kvack.org
X-Gm-Message-State: AOJu0YwoB8WPqaqze/cJIEOGAtgISl3nANToHsXlCF1vgJ21lUbgmgqK
	WzEzOxMgoDTQw5P7eBZCffHdO2YegXPVAeTgFR+sPGJIji35nXyRQJODqhPdqIFYB1EaFPWeKsD
	beVO0zAi4pEb285NLnqhBCerRI+kmpsPcVUfpu8oS
X-Gm-Gg: AfdE7cn5EEffxAXlJVaz0R4ENdg9EDMuBgqisnLvrBawECJHQO1Bya7ia/4lSA/+4xG
	STm8DIiVXuq1k2OPOgeaSSuIPpNzu5Alu5kFbNtpBaMqvhumpvCXF83BbSxfZvnF2roJdSCZKf6
	LX+KI+sRCEMvskL+mAakXha7fx7KpbMleOwlwHP4Zq212ctQajzxVbLhBiske/l89fR3d+hXpdp
	+41Pbe8djnluG5xmen0+FPq8RiKhmGL5bDUGdyu3Y8oVNJvA32fbLIB9XuApAfyH9r8KARS37do
	gKw75s2d
X-Received: by 2002:a05:622a:53c4:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51a6e9b5655mr7053121cf.2.1782370840588; Thu, 25 Jun 2026
 00:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-34-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-34-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 08:00:03 +0100
X-Gm-Features: AVVi8Ce3XGRWH9AR3rw80vlHynjgwNotwUVdlcJvIAaDUMJb2MBvPhhdMigDY2U
Message-ID: <CA+EHjTzR9r97Brau5KMmUf7UZvevmhpCKhTEt-9wT=0YXFLpFA@mail.gmail.com>
Subject: Re: [PATCH v8 34/46] KVM: selftests: Test conversion before allocation
To: ackerleytng@google.com
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
X-Stat-Signature: 3u1qrcu655e3zesx5yq15pon9o5mb7kz
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A68640005
X-HE-Tag: 1782370843-770648
X-HE-Meta: U2FsdGVkX18GbyJaeb/BUI3dfb60HMh/Ywjqrt/qKYRHsGToykotSi5XXPWQEvNa7iWxj6z/36bXNHtztACBfhGbgJ7J7pog+JXWw6xJL3JuTRXwk7COxUh4ojJO6pm64UqRTID4oaKFEY4zPH7BTzzlHHLXbxAEWrd1pv6uPLFBQA0AZJmy5FocGXPkqXT3DRUZ8q3LkiPYF1HvYE0ClG3UITJddovNqdAFI9dUsYdqFUziTcMZT3XOSfPnXFn8hKCp2PDV6wqqclZNplP+yPlreKifFZw2bfe0PwBzXdeyPeMr2pg2KZlvM+jc7LuPS306PT0gCcJPMDwSHYP+EJtJ2WcF4XB2VEx23G2aIRZ2rFwISc4rir0yfi1PdoKpAoiHuvt/OPUgGRdVi4OrJvV7SSK7w+vO/41Dm9Qflqkj3NwYipvFK+II3o4IhmfNZ8C+QiXrFhmfv4SUWGXubm+nP1cTqoVmAFUevWkXn6bL8LfZ7FibeaKHjKc/yWxLrDZMTbBzkwmD7tdUQn5BohkbuQDUq3BPeNjmDvvEevu40lBo+u3jqFtfkgGDpkE3i/H5STVWHqk2nqfZQqJ0LO05ZllGRT+WeMKSuEhWbrTEPg3zXSX4ao1W6FQiasRW9L3CSV16jPfWRPzewM/5XfTZmrv9EhEg9GOqwNHGvHg25CODkpF/VL4czy8Fn4wgFUymUvp/OM/q7Sk3zhl4Ll1JG+m0AVbKJrMcc7v0wvsk1yUEvmDWR0DDPh33eA44tjhBeLd9QaN3R5o1S87E4hJ5BxUV2dmJqbbobOUjIWXaqTl7GVC9FeZ2U925+rzBKEhi7dthEScRanhiRL6DEKhMHLQhls8D0XUkwOi1BEuiEkYH6wmdcqtH1Ph+480g4V4ZcDy+Mv9IxEpp+jtRbo51eLH7guUAuNxZQQ+35pj+YL3zzlcW6izU/F4cziWn54PtD3lWGXurY5whxw4
 rUp+rckw
 5g4hiANWhHMJQTm6GypXzi09SdhYYqp2/CwNPUdw+sBoZNCqQevDkBiSjq//Mg7ZZRc7/KPTGQwa/S0gwAusIsXhoRjhGRczl6zkMcO+GzITn13eqpbyJmM64T07Qhm0EcAMDkLKaLq5u5+yMi2gngT4x7V2eFn6TZLHLdJr7SKAjLYVPQ/v5LsJChUmZVDAyISwHSK7AhJA4PrNbbjv1XQ7cCdC6H6oFKPDnd1ycOXwKZbRkAOrcENJJAwLAV5w3RSegVhcSxu+Z7E4G4dd15rs5mI3xgbidzK8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Add two test cases to the guest_memfd conversions selftest to cover
> the scenario where a conversion is requested before any memory has been
> allocated in the guest_memfd region.
>
> The KVM_SET_MEMORY_ATTRIBUTES2 ioctl can be called on a memory region at
> any time. If the guest had not yet faulted in any pages for that region,
> the kernel must record the conversion request and apply the requested state
> when the pages are eventually allocated.
>
> The new tests cover both conversion directions.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 8e17d5c08aeb8..b43ac196330f1 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -265,6 +265,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
>  #undef combine
>  }
>
> +/*
> + * Test that even if there are no folios yet, conversion requests are recorded
> + * in guest_memfd.
> + */
> +GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation_shared)
> +{
> +       test_convert_to_private(t, 0, 0, 'A');
> +}
> +
> +GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
> +{
> +       test_convert_to_shared(t, 0, 0, 'A', 'B');
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

