Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80596CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 20:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD546B0088; Wed, 24 Jun 2026 16:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EB96B008A; Wed, 24 Jun 2026 16:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F486B008C; Wed, 24 Jun 2026 16:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 069296B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:44:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 832FF140405
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:44:15 +0000 (UTC)
X-FDA: 84915983670.29.9B3A01E
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C937160008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:44:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rW39Z/Mf";
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782333853;
	b=4vzBONp7TV9joM/w1jNGlDhS+GtW5vjQCL6IcJW2SRSLgpckQl3wr8NPZqErNbrcQPSotk
	rxxV/JJwrcBQaX+X2Q3GjXujJ27fYoCgYHOTqGIv+vHUBRVfOwm44rG07Fb7OnxyFJSZrv
	Wg1UfkBE826UJ1kFCKp1xORuOIvEUuY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782333853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5/9dkbJhmiJkcsjBrae3PYSyLuk0zvc0a2KRC6LUH8=;
	b=3niDGQBcH3e0TDiTArqVbdZYRfdRuekeOk8x3I8sj/+ugZG8ZYYe6akP97HetcdMOM9VMV
	sUgUSuvV9IzWH97ykckamGK1XWMdQA/cVfb5IBHUvyy0Vdg+XnH9Cs1Zmrq8FCqcGBJtAb
	TexR5PKzSB2ubkwNaiGHMLJSehdu/20=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rW39Z/Mf";
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-13810b63a1aso402101c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:44:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782333852; cv=none;
        d=google.com; s=arc-20240605;
        b=IoMrMJ/MQED8SafE1TFn2AbjV+RipczOpddTxGnOOmfcwUa4u0W+GoJ06XlVJwjr8G
         tb0XwDx2i6wxxzXrJn3rUW6MRyzntICQ4VP4y16eU+0/1wWZBXxTf+M+4XIt/vPwzER3
         2C1Ru1m7t3f3ilQR7oXlgjBNuCvucMVtyd06sl3oCSMelqzZJ85avBPwiyHq4uXeWWFg
         me7LDtZhfzKA0E52zLfS8GjjI/+LFwXYpEPrzGpyNIX7zwQDsWiA9ubJA0USzyzkJH+5
         XRAb+9qYgePw+yEb08B4ifBRjuvjm1l9TeTm86RyZOGR41ZgPgxsKVOLsievKbniuVs1
         vI5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=G5/9dkbJhmiJkcsjBrae3PYSyLuk0zvc0a2KRC6LUH8=;
        fh=pv0TxH0sdZeYVfJb1VIssjR2MFkEqMkjs+j8HFm9iXM=;
        b=QhDBLfMyfF5EuO4GHrrG8VA91VlxjviN7iHXqGul3yMi9CRfVxclmL6GfbBgF8ADFT
         gFjhpFKECecFRg/4RJszu9mpw/YblK48ME+2KJoofuoULS9HsgxI1luscc94A2/P8QgD
         ityrOAqPW4usIZT9P56CS0aa3yLqD03o/XjdZDHsAeMB8YVK9uz1udVLZyFqeujF9+Ak
         rhTI1GssVqdn1G6MdZnOPDYcB4tlCCBINANfrFJSTg4D38HuNJ+X4PedtDqOw0xq/OEN
         thRd6mi8azfXDdGTbNjtYya5K8tfoY4KjpMGYHfjfR/ch+ZQwKuHqGIul3LL2yO9E+VQ
         xAQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782333852; x=1782938652; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G5/9dkbJhmiJkcsjBrae3PYSyLuk0zvc0a2KRC6LUH8=;
        b=rW39Z/MfY+kBf8rH727iFFRGBQuTpdc3qW+OHbBX1P13jTneuSNcIzzS+VI4zhMWiF
         CzcLMykOOZWr4fKPVDMVwEa2a2VFjSOTcJxEeyzAzXCZCAOekAPJq8BLeO/2Deu9H6P+
         6owwo9huXB9cwv88cScBzJHf7srhC/6amhSZjHC2hzDcVMfvVTuca6nVvvDd8R/tjSSt
         YLofq0cYB4NG2ebYOH+xk84mH+qQC3tEO1GSwEQLtDyJGoV0jsujox6R2Drcttp/pCCW
         tjyYHwPrEKtDTEyGA0tbN9VJk/YWRPHtKWz1i/4uDCLFH6mZv98HRmOzmoApHtS8R0if
         /r2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782333852; x=1782938652;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5/9dkbJhmiJkcsjBrae3PYSyLuk0zvc0a2KRC6LUH8=;
        b=kjFo5+0B1kaOAPquYFerDJnrIlnzWNQ2IOw5YuR5hjAALUGHx2nQxBS3jSCSWHhUBn
         kvqjF0u02VHXBnhFpNTcmyxsPJ6hTsBEI0IK7LX4YpsYc3d/zTAegqEkBCSNpsdeISMW
         s6zrTh91dzDYHZG0N29Sfg+QAzIZWCW2pfd8NcEw2ItL383rXn1ZfEdbh5j+p+AuEfFt
         0vwz8vx1pFy6t4sUg4JQtfVy4vdcvhhxJ5ImpjgpE4earYKxD71MyRmDLh1bDaLYVrYr
         ns2U+7Lcw21naLR4zY0Ls1K15NcbKGa3+TS62PE8cEx8qyWg/+361QpkqprgMqVQ4Iq5
         ciTw==
X-Forwarded-Encrypted: i=1; AFNElJ+feYDxU4ZEFWNhIMohcGPicJkwF9S/07w8rslHajL85j2i82bW2sYYCntbgnykCtRBXQFQSMJUxw==@kvack.org
X-Gm-Message-State: AOJu0YxiyVA/9zRXyeYGPvno2XurgqzCYWaYu2+plBoJD+PHK0mT0enX
	oDM5zLe+QWge04dPfcosoO6fCGYbNgLrW02Ln+zcl1Nh3ULymuYdogfiMMWV1DbFKhkp6lO17q4
	98PyjF9AuSnDeDsMcoo7K0Kh94nxVQkt1T9N4sDZm
X-Gm-Gg: AfdE7cmJXh7FI7Zd3o6fRI6LRDop1rREpHcrtpZq9opbwM/aX8YPtCS67qCWlOzYmK6
	gTiflH7cBSWnSSyYVYw2B32xhvsgINkXMgnziJI/YyNhr7CLV65WmOIKUmALZNvtIeAu1zz6gi0
	mqHQlSm6dWFrX9Izp+oJyUKUHEY0xuTCFuDn13+E0FkR3gRXpvTS9qbp29lMSb9nLG90ZJpeGAz
	+D5UtJCrzFzIqG6caoh2KC+27CUAxHSGugPGF3FZMeiam7AcnpvRBOQ/9PhzJXRmYZtwxJXyE4r
	Xt/wGrOnWv98omyYihYcRvESbViJ45Cxeiq4C3uAE3v4GJjo9AWoWYW1zhs=
X-Received: by 2002:a05:7022:e995:b0:137:eda3:e5a9 with SMTP id
 a92af1059eb24-139ad711637mr14297421c88.28.1782333850616; Wed, 24 Jun 2026
 13:44:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 13:44:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 13:44:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <2ef455c3-a3f5-4ba1-86ea-b96416d163ce@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com> <2ef455c3-a3f5-4ba1-86ea-b96416d163ce@linux.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 13:44:09 -0700
X-Gm-Features: AVVi8Cc-v85YTGgbOrOpBNr09aOMCIpUVvlduJvADSpw08YaAcwUxrqW73F-Zbs
Message-ID: <CAEvNRgFYpTAi+F8iF_m3mQnP_hB+DWN1oTnhEQ5WWxduX2D5MQ@mail.gmail.com>
Subject: Re: [PATCH v8 10/46] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C937160008
X-Rspam-User: 
X-Stat-Signature: nssudyn64riu1ixe1zkof8oxipenp5fc
X-HE-Tag: 1782333853-954973
X-HE-Meta: U2FsdGVkX1+FLA/AJrbhVLkXROi94L9ZEyzoG0msKpDXpnkDybZS2SHKZPiAtDGEGbwbcpdNsootfZqEgdvwI/byUTmU44/oZLW2Lqu/Jg30ISf7mdG8Gt7pJAB/ZXF33YdwKBwsaC5i0Gna1lsyF9xkEK1NKPRW19TpfjYRn6NZPn2/8m0s6IzVhqxABWlRwb91xQ1ficQyEHk3ZJCj+F7moNTLzE0VUS+B0LoeyVeu0T43r9ptTKo8qm3bwlgR1sHG+NQRJWo2zrEahlKj9j5xbX1s/c69qaG56b7CwWqdxvcdG/5CkDZ4+kfTFkJNgNDF4D1Txx4e6arE954HGOlykAXChObW5qXZNjj3JL5X8uwmI2fwHlLkvxHnG/q84/zEiEmkERDILc5VADM/vX9Q0O6lWKYlRWKLOwQX/nB7xzoeb5xq0SYWTsLXRAXnk848XcdUv9bADP2EG2IfZ+UXCS1cqJdYeZrl28azMpWUWB6w1XYCcFQEcaKjhJhogsNwf3qtmj3VHgKupkJh9UQ3z+tHl/T7b560eO8zFzj5/jrcVP5y4SP9uQPtpVCJadoZp5d+ZtFH+9IhXIIV9pHLQjFo5ebPpURcncRFIYE8BsVZ77F/6u1u8wlxG0U/4D5Rd/WmhUz9CDba6L9W9ww6fc45LqITXceWk5kLLpYpVMsOfxiQqeB4XvXdFleHZHi3LuZMK58rYoR/jCIghX64wikcxQt3Ur4OhDAIgGrSjZEB8e0opTbm7im9NjLNGuBjYxgJ58rNsEEqrvS6iegTyWRlkiqPOQieaIbuMjef1r9kb4d+6lphLJ7OcE5/KvlZMKHovBOLkyhEGWUUwmPy8Y9KkeHGei5YdkV2b92iFal7eNDgJFGtm7+TMinVVJ0ZXstbxjX6megB9Gx6e8TilfFkwCpyp5QY7mz92t8l8AZAi2vgwZtz02iQmZ8i9iUV9g1YrxFXJO/nXFd
 UqxXN1pK
 ySYPs7RIQ1hT+bgalzBRzxGdT3LK+mmxrbKpn87IBT1/HdYrnzkkHB6IOn/im+U/ud/BCYs2bOKuCMSRviSrioovHAW4asr/cPf/OyP6pzzGcs68Q/GPbMgmEX5bRp5p/2hV63ukeOu2PNUaLhvqDVR86lv+Qro/K+mwujkE0Ux+24v7i7PFzaZbpHYVZ1jGXFz64tqp8m6xjuqsJ6ZCFSjS3tporzaRjo3S4FAdmoF9lPp3b4wJaQb6ZZVeU4W6cNcebGUhHjrYjP/CueoYrwDacWjQO3kUSkMuIUqJOmK/1eYOGXQdZMpCVIegpLg+ZjjdsJ8Leeplty4ZyYxJU6IeZjonJz7o6QJY+USNPf/u2EMayW3pvkReMnLUYBelD3BmNuT4YjZtsDj/pHwiTqUkVGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>
> [...]
>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index bca912db5be6e..e0e544ef47d69 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -926,6 +926,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>>
>>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>> +static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
>> +				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>> +{
>> +	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
>> +	pgoff_t end = index + nr_pages - 1;
>> +	void *entry;
>> +
>> +	if (!gmem_in_place_conversion)
>> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +
>> +	mt_for_each(mt, entry, index, end) {
>> +		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
>> +			return false;
>> +	}
>
> Patch 1 noted that "Ensuring every index is represented in the maple tree at all times".
> So I think the queried range should not be a hole in the maple tree.
> However, there is a inconsistency: in patch 1 kvm_gmem_get_attributes() explicitly
> checks for holes, but this patch does not.
>
>> +	return true;
>> +}
>>

With Sean's suggestion for patch 1, I'll update this one to default to
the "init" state if xa_to_value(entry) is NULL.

Thanks!

