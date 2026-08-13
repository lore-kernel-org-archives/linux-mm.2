Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5D8C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92B66B02D1; Thu, 13 Aug 2026 14:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43906B02D4; Thu, 13 Aug 2026 14:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0AD16B02D6; Thu, 13 Aug 2026 14:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 766F36B02D1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:30:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF7A51C0AAC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:30:09 +0000 (UTC)
X-FDA: 85097085738.05.5B9B7D2
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id CEDAE140006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:30:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UTeGD0qJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786645807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trV1VhVsvTuMN0KspJ0QoTvh0FqK6gua+XSXYlaI3MU=;
	b=SZLEXZjxlhiXfqjSlzvEtPyEHokxwgjQZpCau4hWM8r3k73kfr9WCTBrKmVV7ARBN//XdJ
	eBEIHBdtA4dp9l7TdkEiSJpxryVVwY2HH/aox6Y/crqEdf5nm9CYWLoxNRb7NLS8YNPT+e
	TxBn3sAWEa4EifTmxIcgpn4TkT5m8fQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UTeGD0qJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786645807;
	b=N4UvyWf6wRjB74LiGHHVBpmXqjrghmZr22UPJT4gBTNXkJbw4igGnSkVpuQ1xpRkl/n0nY
	nHQVDP8CQZ9ltgxxRVKejLe6+njNrgitPVqFV18pL/B9of7Hh2Uk02Jsm78LjzoKY8cOiU
	+9ndad5TPZ7Gc8wQOIeQEwR2ydFAM3Y=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1001693a12.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786645807; cv=none;
        d=google.com; s=arc-20260327;
        b=ccamdty+g2/p3zlIFBH0civA3MAicmsI3AzQNwyRUkXyoP7nFlQtLYcUzZYH/XvW/m
         vw5MJ4l1Ism470VKEFzF24J2HkCg7myOMjdkQRMJxlwzA//fE9gZyJnkQv1gYUDN8n7L
         VS3Rb80P3Ot7oz8QlYFWvWkQgZ2Eh5WScds5KO/XP1qIK4AsArOeVAqeuL9MhwTi8HPp
         2trNIKSYnMoMH8nvgfYRgtmnKEeBRbwsL3OXeoJJFJH/LWoY7GGD522atlHDF/3Nk519
         JfPkJ3IFQgeY5JkbuJoU88UHTPZwEOWhv2kGF8FiiiJHWVZjofFgM0lobvIoDwB+xOTF
         tJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=trV1VhVsvTuMN0KspJ0QoTvh0FqK6gua+XSXYlaI3MU=;
        fh=9cFvtefUKjD/enOLyZhhbwSO7gFp8nMuPp6pMixoFgA=;
        b=O6jrMjJGT1M4P4FEDxjZLj5uzmsWCV8E99Ho278Crauw73PsWq/ANx96PB9iv68XS5
         9EnEoVn+kw131Dk5dDJKfu/ZdTXPsOQvLGZcjbrydRXIANMBAJGcs39AVRpRL5q2OndJ
         M35E861BnJjvFz876hu3OM/0Cmr9uh29H3oLWuRqZp4MycILuR/khJnnnykUrBgAfk3e
         PanbfJPp3DBTu+cjpPiEDLvucTDE0UP2XmHRTgjlElDoGx87Hf6BW84SPofRhuJfVflG
         hItaPk7f0lW0L1mO8rsKdqLts1Le48mDAoa9xoKbhmP5gqHNvC7mTsDSXx9FicHupGH1
         QHng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786645807; x=1787250607; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trV1VhVsvTuMN0KspJ0QoTvh0FqK6gua+XSXYlaI3MU=;
        b=UTeGD0qJAEzS7NJAM7YYLiCIV/LHJowHs87Ze3rk12KnkzX4hSE+H8VMi3bCosx+8N
         FN+F2KYbjDLjrPzVk2ONOjnhTme9WMszFcbkXGDj0Pibo/ilk/9ySRFZc1cF+m5YrLgE
         n1/pZE1+iPtn1zE/uZ53TyItHbMfUemf59nDMTNUwUs2dyVGWjGnkqbjDYOqdUoyBkKW
         XUX3gI411q8NRNVwq3570SyFUvhWQhxh83+YFU8rSXDjzddj7rscWvNzJlC+w2t0efFG
         lcnwnG6CpdsEKRpPV7GstCT4NW7tASbBBpnaqfjVHOqhjuVMO/trHSgToObDy40TGpu/
         N+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786645807; x=1787250607;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=trV1VhVsvTuMN0KspJ0QoTvh0FqK6gua+XSXYlaI3MU=;
        b=BSEtdC7cw1Xy6/9CHmaNhp0MNYAzOsHH7GtzLpnXRD0Ca4zxpbvZ60qTARew6afQSG
         4/XUkTS0UB6n7M9RPITYo6OOumOM6tQCSKne+/5hlZhf/lqVwOjTFMA5E+8Mak7f/zT5
         Z0eWjVYoISFmUGP3KINm7KeV/Kk0LbVXwzFKmB8/jI0S3RnH3VeAqfcwJaNBD/qL0tbD
         FoTbicwcSE8a5gB43IcGIiROUGGhw85yBmSkTQVWjg8u+oOEg45ihfa3LKz3668eNuyF
         V1vmRElnAvONWGM9DshQ/tqitlOJCypMb8YThVdR65lq1ZUsHHyOjwDPSdlBr/EUywAV
         mpVA==
X-Forwarded-Encrypted: i=1; AHgh+RrJ1XsQBLA0gJFRho+o308gSN38XUxBUSaI1arjZ6WaZpEZQsh5Tj5D9OLZ8ff49C4Dp0dbIFA5Ew==@kvack.org
X-Gm-Message-State: AOJu0YyjK2MnzCEet6bFQYATJPI/jfm7HqHSxJp6V1I6kIS4FUIz4FaO
	wEUr//Ad3VID5QppbBIsMpYF7xIF600L24tKp5hEmhKGs3aVW7jstZ6/h+EddXQ0B2AiPEZyAa2
	A29H5KwKp1dy/1JiQO5/x/cMrwVdD1UL7i9rv+Dbq
X-Gm-Gg: AR+sD10xBtp1tz8EbVXsm09QhuKHEw0ZfgynQkR0WgTb4+twWMadWylxZqnUl5o4crN
	8EvlILl2qaX0vv6EoedDPSicawLRafvPRLV4mYrg5Jg6ftLFHVp0LXEivIKmh+6Kl+iQjXPQW/l
	gdIZ9nVs4EGNh6xryBrIB3mSbHBfQDIRrKGIC6xAu77vkwerJF3DhTwdGZRrraqoUduWiFDEfUY
	fgyN4DXsL5JLE4qLsikx4ufThkN2HKHUP6WQPtnCAKz97QRdsL+xJv9+hLOnZZ0xZt2fzfVwuTQ
	v4G2G1mpUJGedtEwnbPbV1nPXbDMVgilNue/xleuXMIVBnDt2YSYjqTWqc/gaGNgAn1Mix3v8+e
	mYYgAdghVuryyZvvS0u6v5WZO7eDeFjA=
X-Received: by 2002:a05:6a20:3949:b0:3b3:3506:cf3f with SMTP id
 adf61e73a8af0-3cc572e1e2emr8851350637.1.1786645805191; Thu, 13 Aug 2026
 11:30:05 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:30:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:30:04 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <anzm_YLft-J7pxiy@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org> <annnrGR1noVuBkCc@google.com>
 <69c86172-9175-46cc-895e-9ecd449332cd@kernel.org> <anzm_YLft-J7pxiy@google.com>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 11:30:04 -0700
X-Gm-Features: AUfX_myERGap35A1bA3IvemF8mP2h9L2MeL4s3gAw6GC_Dq7e6Qb6MukNKA94AI
Message-ID: <CAEvNRgFGt2Unre=iuXhdg+ZFjWQcewObA54h-R4mBcpfksXdKQ@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Sean Christopherson <seanjc@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CEDAE140006
X-Stat-Signature: zfs4sf6a1fnp7s5g94b33waiafgamq7i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786645807-793417
X-HE-Meta: U2FsdGVkX19PpEEu2hcB6WLmlC5AYKJjZJC5UBmTvCUs3lPG8+Fk1rpNYedXatgDfvEe0d8VhSPUVIHQ0rkFrmdQHMas2/djejWA5zJTx2yHsLH0nYIXu/RsNt5dRXt+8/LXYmgocFCx9ZoJyDuIKRLxowBb6Ra1U0aBJ6Rvrvv+JvdTkeBRy5r52YM458IRkQj0gpdzdkOOlmckIEHim5aJJeGi0Ftbdjsv01aiSF61RZwVdOoAlRMxhYQt7aPjCo408ezw9yDvikpmattIs6djnSf03bulr22yyBfSa8z2InhuaXgunDdsg0cun8ESfPhcyyH5AgMEr2LyHnuKxt6SXb1mv8toyveWIvFZhN3ITMpmmPjAJA/mdyAHYrLyLQFEAXz2aU9ZXjSRExK49Vx4z7cFlCLGuVjzbWiCkWzLJlJ1eRfbzw5dk1IYl4sUYeY+fcylIobEOBLBqG0TdSXCba7LzGWNs5YYYDKL3wgG9smbzBaVyRQUT19l2e9KpMX3vI+kdlBRnfmTW6WQsR9jnjFJD8V/fn21slRXzrCANnZsQo4ag1WI056Ru/dEgzV71TAkGKn3P2kSo32T8j9EdI0ahg6IMk0hJedqIyYjQ5fUiMtL6RELWeKZK0DiP/WRe4fJFAX2ktjTR3dsHn5FTHHG5Ovxz8oXxXzzgGTw53KT425ukp43scS72wqHOayqSGfNamBGAPk7Dw/z1HelGVex+zb1sULMi/XT6ywm44wx3x5mYpS+Dglqw1ulFaL55l+oNqV7PELl80qPRj97OVDEzsPtaDdkHtgV3OwaWshfA2YP5zuZeT2DAHtRonxBNlJg5yNYeBH8hp7bO5NmVdwaX/gc3DqVjrCCVID1o9sAkwig1XrmnJmNb2KNJZbmJr6AF3eLVOtqRKEyVn6ez9EB/Pefd+zHoHS8PaPPXTFhVJCcYhQcNJLCb5/++3656IYhViK0sVdX8z2
 nDSLoDKU
 cMizf9uguOeDOjxsb55/hun+QZyF8Z3F5k4FtM6dBiZccWl2Bj6nZECzDNssQGMJzsuQRqMqrc94kwCCp01VJmywRUBArkbINnqaVi8NKAKT/ptKB/iQYiIEODjt/+xaaRrqs0t9cISIed5WVNrugwQhQAJodSiuLEXSLBGwYj3Bf9skuvlBZOMSlvK3gtY5EvgRlMXMxQTz5HoEVInHT9l/MB08VRPCqarCngHY3LzJokATr2c9O1Gk8bLul0rmb84OMNcAK1q49U5CFdKCpecJwdW3G9CzYBtsCijWkhP4OfrDrBFXQi8y0B+Ql4614skQSVpb6qd1NfuKKHM7pUFLm2Crs9eN0NEGXILjm8PguWykKuZVnOTbX67/BcGcRCyUhi13pSuvsEDJX2uGMw/ko1dNQQ6sXr2D7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 12, 2026, David Hildenbrand (Arm) wrote:
>> On 8/10/26 17:01, Sean Christopherson wrote:
>> > On Mon, Aug 10, 2026, David Hildenbrand (Arm) wrote:
>> >> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> >>> index 65fbce46b63f4..9477ecebbbced 100644
>> >>> --- a/include/linux/kvm_host.h
>> >>> +++ b/include/linux/kvm_host.h
>> >>> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>> >>>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>> >>>
>> >>>  #ifdef kvm_arch_has_private_mem
>> >>> +extern bool gmem_in_place_conversion;
>> >>
>> >> Is there a "supports/has/enable" in there? And should we call it "kvm_gmem" for
>> >> completeness?
>> >
>> > It's kinda stupid and definitely more than a bit inconsistent, but overall I think
>> > I actually like "gmem_in_place_conversion" the best.
>> >
>> > gmem_has_in_place_conversion and gmem_supports_in_place_conversion are misleading
>> > because it's not just that guest_memfd has/supports in-place conversion, it's that
>> > that KVM is tracking PRIVATE in guest_memfd and so in-place conversion is the only
>> > option.
>> >
>> > On the other hand, while gmem_in_place_conversion_enabled is better, it's not
>> > quite accurate either because userspace isn't strictly required to do in-place
>> > conversion.
>> >
>> > As for a kvm_ prefix, IMO gmem_ is sufficient for a namespace, and not having kvm_
>> > is consistent with most module params in KVM.
>>
>> Maybe we should have a helper function instead of accessing the module parameter
>> directly, then the gmem_in_place_conversion could just stay file-local and
>> kvm_gmem_in_place_conversion() would be used by other code that wants to obtain
>> the value.
>>
>> Instead of the
>>
>> #define mem_in_place_conversion false
>>
>> We'd have
>>
>> #define kvm_gmem_in_place_conversion()	false
>>
>> just a thought ...
>
> FWIW, I'd rather prefix kvm_ than add a wrapper to get a boolean.

Could you elaborate on the rationale for a wrapper? I don't really see a
reason to encapsulate this boolean since this flag should be global to
KVM, it toggles between tracking shared/private status at the VM or
guest_memfd level. Since KVM is a module I guess it's already global
just to KVM?

On the naming, Sashiko did point out somewhere that
gmem_in_place_conversion as a global might end up shadowing or being
shadowed by something else.

Prefixing kvm_ was one of Sashiko's suggestions too.

I don't really have a strong opinion on this but I'd like to know what
to put in v11.

Will using

  module_param_named(gmem_in_place_conversion,
kvm_gmem_in_place_conversion, bool, 0444);

help? The module param doesn't have the kvm prefix but the variable
does.

