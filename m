Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F32C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 20:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484606B007B; Fri, 24 Jul 2026 16:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4356B6B0088; Fri, 24 Jul 2026 16:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DCC6B008A; Fri, 24 Jul 2026 16:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0416F6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:26:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AAF1C017F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:26:45 +0000 (UTC)
X-FDA: 85024803570.27.FBEDB1E
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 34DE0180003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:26:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wBOl9u9A;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784924803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6WRuRiOGlrBru4rjgXozk6E1Vpz9Ly8EIjgzHznenQ=;
	b=yqrp6xl1FzZauEwdNHYWMCP5W2hl5N6LKShTm1RYswADYqAlcdqImGzKkT1gqc5zs2OgkN
	nrUG9av7Xo3E2rvqCs2QQLFZHW1AN9+h0G6B93+03LdRiO23LtZaZFphCVlilUq1XBGOFc
	/F09ABxOIkGLfFNCB2OVD2LqvVa+YrE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wBOl9u9A;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784924803;
	b=zpnx22Tq8xI3Yn31YiInFDDmHAuMjLTlQg+3MTHBdArcZ+Y4PdJJxzbcC48SVbIfAcA5kg
	/9E5sXuyxclxSkHSe2QtBzfHTh6CIckWD7hjo5FHlmXrh9VAoizFTH15VvbnSrrzVsuH9c
	1zau204yqgHM/y4h5jht8S0R3MCVij4=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e347638adso771193a91.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:26:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784924802; cv=none;
        d=google.com; s=arc-20260327;
        b=Qmou+X/7q3y9l4gv54N7RqpbVrzNVYELPIdjolwAz99KwefA8HLLHrb/S3TTSE+dsy
         y/ZSE6NrbDbNvR2MvGeiTnX4v/mZM++c74N5A6GZvn31pBUKh55x6X7t8HSOgXQEORIO
         gnQKb8hmifzN1oUIHNLoph0bMytLlW9NL0pqFteWt94b0ITFokjKQ1O37AxInyzOR3Ds
         QJbFmFH0RO7w9pOwCu5vTMTf7CfR8tmd12Ory/wxzefRCnL+RTSzikVTtRbXCVVtKZ45
         98Y5EgrECNU/S1fIV6INcvt0CS8QyTKiAt3Kh4qRXTXBfflrnhY8aea1nTRR5LMx/Yji
         TKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=j6WRuRiOGlrBru4rjgXozk6E1Vpz9Ly8EIjgzHznenQ=;
        fh=tfZeM4VQS9H5Vkznt/dKYeEgCgPIzGNdhls0WlqcaM4=;
        b=DSaxCYjGufmd8SSWLY1pnmfXM9DuM1OBwKkqIE6MvYSUGY3pZwOkUi9V480SJagtbO
         5eLbQ2GVdDh8FhaLVIdI22RbAkrcSzg9ALJ/o8uWt0+M0HmTZApufZSPPuka3dy6W+rU
         L5ibjhW+8xO9d/G48/ONN/MXBAkq21EIMoL4A3SBP3TyBUKBRchSAQnNfDRFrPEd1lsZ
         CZYfutLkAJJBGQuslgiPtUy6SJRaMDoZl1JmBLrXAuN41y6kFMtLqywF10scYCzi3bae
         N5oP2raZDvzdMnlLVW0f9R+l+AeqeR1vsCSjn1kgzVn8a0JHZcIw2IzeE1oNcneFk5uT
         cBbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784924802; x=1785529602; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j6WRuRiOGlrBru4rjgXozk6E1Vpz9Ly8EIjgzHznenQ=;
        b=wBOl9u9Aoj7uDoi6QDxAwhTxr8dR3AMNrH45gNKKlhPuYRjLDwtp6T9tAhFGkKShun
         JG9QXwUSPem07VZUKGjvAv8dMoV7bLiQcrnklwFc5xfkC2x0fzSFCiqNGgPK92LWnYzt
         R0ZTW6dkAq+RQVEqXh/4U0ct7jFk35E4Ssrh0Uc5JIE/ETBnQ5kIkIF5WuBc6DM+SVBY
         UQer7S51LYd9edVVhL3NaHGzjepdI7jeJ0h+pCzdfzDKkBzg8NYngOBWWNmbd6JZOH+n
         2zzgQJrUOpETH8CHRuhgTYtMklI8VEirA4gIcw6GWPFEgbNpm0sImmXpygE07Qtqn/7U
         eg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784924802; x=1785529602;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j6WRuRiOGlrBru4rjgXozk6E1Vpz9Ly8EIjgzHznenQ=;
        b=NLb7O0FPNSfwmRtx6z33Sye8eq/DmUh+GfMEUX+ex6N9XkyZSUzJE73Uf6+exVVzb+
         dCbsN8Exwm9feHOklHAAuyauq+wn3LXAnNmufRgYSpPkgPJOpjDtYJmCJtSjTaT+XqwH
         XnVIm9rGyswCw2d2qpzxDnY8ARSFQYO0VK44LIHAEAFjkn/jieoDr833z4Eimvfd+RSu
         qJrmeDO8qxnXu+2jCRH1XWdOUkoN/KwqG4YhfTRvAzjghVyxfJzrTVduQD31GecboUM1
         Kp1VqfBTvxzmJfhuKPdLoHOcXtfljDXVqwr5Wx4ONlknLba1SaXS0cAxRtwDiCIAL5nr
         qcnw==
X-Forwarded-Encrypted: i=1; AHgh+RqcM6qLWAAdTw+ag67iZKtPBp3bstcblfseEiLYKiYzVkxYrrpYGJiKqi1uoUpxryB+GMNEVhr3dQ==@kvack.org
X-Gm-Message-State: AOJu0YytdhEnMIy0vVAwH2t4SR9MImdfghkKOV25LidYJhgmNR03+s58
	JDjrfRxxamBbh6v/aEgQMe+BsXOji7tZxstTXeJ8Ahd1Xkk5AlCS9x6GfhCrZzGFXpCtXTEApEa
	Wfekh4qEI6DKQPQzTtM3A48ijydQf6TDw2m+QP8NN
X-Gm-Gg: AR+sD13wHja4CX+ii1bTvi6KWSdSWkVzFC3tvnlbucIkS/fseYWWQwGRIyGuabMYLEb
	W3pwA2TnFlOPnvgZuP5z9VfxBqhA/fxXHgCGaZV+FbvXE1a0nCQnXmLC288fiD91l19ZESRUawW
	Oko82/KzYPoqkKny7do7M2Kq0dpgfQ2QYxdc1NNLpSDHWJ52CjW2WAuIx+xQPiF/a3CUg1tBgVn
	+KbK9DaLjLxNqu6+UQ/pHRsC17Hm3IJN4+1hVIH2oKU3oS9taB4QmbYMnw0+tXsXt8lSYyNIyog
	Hks3t6BT3CFnVfbWqN18/vZRXikGJ0NyrtbQQcnd0AOex4TO
X-Received: by 2002:a17:90b:38c8:b0:38e:b400:a860 with SMTP id
 98e67ed59e1d1-38ec642bd98mr9249020a91.13.1784924801177; Fri, 24 Jul 2026
 13:26:41 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 13:26:39 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 13:26:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <c0e2df0a-19b2-4234-b0f7-41e010452b06@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
 <584a8f9a-1538-4f8b-b576-75ef0fa961c7@intel.com> <akU7uAKb5E_Tklx-@google.com>
 <c0e2df0a-19b2-4234-b0f7-41e010452b06@intel.com>
MIME-Version: 1.0
Date: Fri, 24 Jul 2026 13:26:38 -0700
X-Gm-Features: AUfX_mza0pn9bFWoM_88BD1HVQ8VVpLGhsBYWrYX7-3MlRMmF5M63UsjEJ6b88s
Message-ID: <CAEvNRgHmhpP=Re-RzojAp7E3E-TsdoUPhtZ6eSW4bf+5RVbzew@mail.gmail.com>
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2
 ioctl
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34DE0180003
X-Stat-Signature: fqt3r6ikn137st8uix9km9ar85ed5yur
X-HE-Tag: 1784924803-525111
X-HE-Meta: U2FsdGVkX18fvq9uh61DsI+d9FNbzUq4emGqFf3C6R7+T+U3uvunkpQmqcjBucTEfg+sLH+VphNKsJtHzcy5j6Wl7J/GkjNMs8NNnezlG8XDWsINVBitR4GC9k/nYSOSoFWBYTud/VVdh3l1WvZk5MxGrVR+5Y+wc/5jNxd8zykTwY6hqgOLJVNdiufZshiT6Suqa+i+bLztJLDWYJWPTnBsCrrHBytsDRjTDccrQEVNVjoAVf+XbHFmUDGz4wd5POhfXO9bx2u0zR+G+okfEaDhVXbCnz6WmapAYb/5lXcElM0hH3LHRS7x2JHdL4S0C5/q9voVYCDd2/v8EXywh3yTzCxp0aN2Po2UXzeSpISwsQFrcux6Yqhg/wvLRNAWItHVlJR9a4VwMfd+7Ary8KxnqbCEmria4UaTB794b1S+bESmS2hThLUaS3MFtjfVVLHdmD2xX6j/kxjghSwFyMAcRVxBNjZJQAAD8tY3K3SO1EXVUZKQVVikPT4Hp2tm4e9keU1TOduLaQE2JXtouICr0J7dcHL2rKoQP6QfcuIaeQJKjhafY/dyz8+hzn3BxgYqat/k3USIe5LEMWy8Z9UljslY1JBcC9MRH4ZOxBiKzyJs8U3pPg5vFoMXaqbt5j0w/Y3r61yx16VFAwYeHD+psYXbtKYM0UvbyWc/DVl837U1UMAbPZqk5bfeNGfuXGFpx65iEjsiGtTmlupbZieQ1Sjz4iKdZmtvJRXCELoPqGIQ0Fle+10BmovXTBh2OD6Rlejj/EHE+UjCQSokO98ATqFqhm6Znns3RZFHnRn+Wf8pmHVm/1dHLzUCnBuROVNxF6qEn1q2aWCWYpOOCKULj1jgdPP91h9s3iGuRup4askInrYNYr6OZuF23qdvnUfbZmO9mFrPJKAS0sbWTPNlw6cZiYSD6FoDUMcO4B/EUJ9aWzChFGjcKV+c3ns2nTPnxl52CYPpnNqhQzP
 1DjrQe5d
 eSkgq7OonHrvosMFKPE1E7/HizJ/PoJVDA/sBWUY0RBI0DXSCEh5El1Awedwj4FxAOaPubeTWuR6Px7dDy7vEMO1LfCLKc2m7i6Q9VZiwMRE5x55m8slF+sIYe7muSP7/f9akVGARnSffYXdrO0j+2QGEv17dRpFrgqFGXbpc0maDxUI5qe656hYb9RStIruTb+udyUgvlFl5cBAbMpEjyh+hYthOIu+DuEnYT4wsrx5PDRIYjUvVtZzAexXM6jfQH8LMVnALRtSVNO60AMEHNv0rgGFxCzbYLDnqU/2bQ3PU7mdN8uSI5K1qRpNGA5wwPnD3BNLdfNNTgyeBA5zh4E4R6pyaxREKy5TAlWJrKqFsEg5wGvHXnxLKG4ydyE7hBzZ81dl51wRJ8s5djEuv+E2gkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/2/2026 12:09 AM, Sean Christopherson wrote:
>> On Wed, Jul 01, 2026, Xiaoyao Li wrote:
>>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>>> @@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>>>    		return 1;
>>>>    	case KVM_CAP_GUEST_MEMFD_FLAGS:
>>>>    		return kvm_gmem_get_supported_flags(kvm);
>>>> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>>>> +		if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
>>>> +			return 0;
>>>> +
>>>> +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>>    #endif
>>>>    	default:
>>>>    		break;
>>>
>>> this looks inconsistent with the
>>>
>>> 	case KVM_SET_MEMORY_ATTRIBUTES2:
>>> 		if (!gmem_in_place_conversion)
>>> 			return -ENOTTY;
>>>
>>> Well, the check of
>>>
>>> 	if (!kvm_arch_has_private_mem(f->kvm))
>>> 		return -EINVAL;
>>>
>>> is buried in the following kvm_gmem_set_attributes(). How about moving of
>>> kvm_arch_has_private_mem() check to put it along with
>>> gmem_in_place_conversion check in kvm_gmem_ioctl() in Patch 13?
>>
>> Me confused, patch 13 already adds the kvm_arch_has_private_mem() in
>> kvm_gmem_set_attributes().
>
> I wanted to make the check in KVM_SET_MEMORY_ATTRIBUTES2 in Patch 13
> like something below:
>
> 	case KVM_SET_MEMORY_ATTRIBUTES2:
> 		if (!gmem_in_place_conversion || !kvm_arch_has_private_mem(f->kvm))
> 		return -EXXX;
>
> and finally, with the introduction of kvm_supports_private_mem() in this
> patch, it becomes:
>
> 	case KVM_SET_MEMORY_ATTRIBUTES2:
> 		if (!gmem_in_place_conversion || !kvm_supports_private_mem(f->kvm))
> 		return -EXXX;
>

Is the request here to make KVM_SET_MEMORY_ATTRIBUTES2 return -ENOTTY
instead of -EINVAL? kvm_gmem_set_attributes() also checks for
!kvm_arch_has_private_mem() and returns -EINVAL.

I'm about to post v9, which squashes the patches as Sean
suggested. Please review v9 instead to see if this concern is already
addressed :)

> So that the guard for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES and
> KVM_SET_MEMORY_ATTRIBUTES2 is consistent.
>
>> That said, the ordering here is wonky and misleading.  A cursory read of the series
>> would make one think that waiting to advertise KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
>> makes it safe/ok for KVM to plumb in support for KVM_SET_MEMORY_ATTRIBUTES2 over
>> multiple patches.  But that's not actually true, because the ioctl becomes live
>> the instant the code exists, userspace doesn't need to wait for KVM to formally
>> advertise support.
>>
>> To further confuse matters, it is actually safe/ok to iteratively add support,
>> because it's all effectively dead code until "Let userspace disable per-VM mem
>> attributes, enable per-gmem attributes".
>
> yeah, before patch 24, gmem_in_place_conversion is always false. So
> KVM_SET_MEMORY_ATTRIBUTES2 on gmem fd always return -ENOTTY.
>
>> So, I think we should go a step further than what I think Xiaoyao is suggesting,
>> and fully squash patch 17 into patch 13.  That way the reader doesn't have to jump
>> through as many mental hoops to piece together what is happening.  It'll obviously
>> be a bigger patch, but should be easier to review/understand overall.
>>
>> Oh, and that combined patch should carve out error_offset straightaway, so that
>> the full uAPI can be reviewed in a single patch.
>
> It sounds good.

