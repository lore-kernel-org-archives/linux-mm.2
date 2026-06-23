Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5546CD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BF96B0088; Tue, 23 Jun 2026 02:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED116B008A; Tue, 23 Jun 2026 02:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802D06B008C; Tue, 23 Jun 2026 02:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE556B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:15:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C978CA03A1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:15:22 +0000 (UTC)
X-FDA: 84910165284.20.B2F1CF7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1210180006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:15:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lrfmkd/o";
	spf=pass (imf16.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782195320;
	b=hJkL8F4BNgV7dkDvtulV0aEqZgsv3P6Gqqq1A045vLuu/fcXA0BKRlXcr0FEqe1qr/K0mG
	phoYDG9qL9GI8ijSXA/dqPcldtqq+uK0sfT2LBvKJvio8yKCuSuujhApccaLn8PwBV7lwo
	sfYqFWFIW3s2iGYtwUWXRejaSQA1cJA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782195320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12Bq2lPgl3lHA/eb76mJFC+iKMtT091uXNPaTItlLz4=;
	b=aETrvJk0hmacn8SHPxdNbyInO7NS6IcABN+HhvdI93hqWCNLB5z3jkXydvRYweraHX0Cxf
	L5yaRcpRVOBcTLhhPcBhxtCTuSFPNDZAmYX58hCvKRGX84+fMFXrY17a4xBxUbOGbTSxOF
	FOrRNsREArSFGYVynd+Kvb+7fj9ZbCs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lrfmkd/o";
	spf=pass (imf16.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782195319; x=1813731319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iDJQ8q9y8/lBVlCSKCHv2KFuzeprLfn94oYskcqsbro=;
  b=lrfmkd/oPosmFYSIK0dRC1w2ZktklZCl/OyXO4Mt3Whi3mAE07NIP2sV
   m4z8w+wvVjE52clObGa6pCMaADTYK1JEO0lecDTa8eSVNE7RDH1pXjpzp
   VcQb5u2VmU/1sA72bVnIL0wvsSjV1ruFBSp/am5IgWD0/TkyuO3TUcRTV
   aEPJGMVwAk+boEswVP4CgMAbU7v6YSqYW7iZU018bl3ShCvTlgFMsK0Cp
   HTLdHj9zzOClVlfovku+H+sQl4fNz9tcykr0JBcMgbvOYTenrJ4o1MNsM
   aG+rAlViHegHB4aEi7HUNCcg7ivwPVM6uZyuvMWIrznjbDP2hWASMWtgF
   A==;
X-CSE-ConnectionGUID: e0NbaDZtSkmnQE6yaxwF2w==
X-CSE-MsgGUID: wZeNLqtpQyq++7nj4DdqyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93293261"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="93293261"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:15:17 -0700
X-CSE-ConnectionGUID: HBGg64mmROGLAXtatw76Ug==
X-CSE-MsgGUID: FlT3tdEoQW+kTfbe58pb3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="248278935"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:15:04 -0700
Message-ID: <2ef455c3-a3f5-4ba1-86ea-b96416d163ce@linux.intel.com>
Date: Tue, 23 Jun 2026 14:15:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/46] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8ipgczj8txycnazi3xayfpaun85xffo
X-Rspam-User: 
X-Rspamd-Queue-Id: C1210180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782195319-93474
X-HE-Meta: U2FsdGVkX1+3xyrrpB1eQl/8VhooInSv2vSQ1JryusnBV0OUZ+5+OPa1RJqp/EG8XqSaxK6FDxXvDW3sfaAMc2EBe5Hq8wr96m958S3L+n9zDOQ0BnIeu9b+HBL3yiVZ418T/bWxw/0IbiLnaI6rufkqk6pfU5g6jBQOh0vHJXOmMzVEwipQbA6HRgFTYCZ7CzFNRw7w6vaIn6YAIUfTFib0jTXKOGOpjHG3UPyjyKMTsf7+g6/QOEUufZb2DprH61N2cTRh6zyOPZsiVL4cmQjPREPRK6oii9FbKNBPP9FgxE3JHD7GetamQBX4ivS2uavnKcFmElaZmIiqnxOQnV6FLEDwbfJ8hidR41yBljI63UL5KjKbHaVg9i9TxiVpP2b+zxBkm6Q46EMyTfE1FacWbc0HDCjZz0jQY0nyCZw6IdIabveFy3iaS6RnHQJU76POxZdNNkrJ80Q+lNSm0TTG8JXDOtdDASzZv31VdhKSLKvH/+FD0HPTi+C5s5pIQ1q+cqZKB/Q2GHr5VObqGEvbPP8XBYDu1yROJbkVoWBlp6fwZXAg00PBDKxR3UttLsDC9ATWsXwA++6YBwODh7b36iSc6qYU44sj5xCD7IT13ZKg725gjS3uShXFSoPrg5JZ1/4O2q7FlK0L7d3w/rtnbYwGZgIMt2pZtKFBL/GEOQsbUxA7fpIisTv7tKZ+yeNLjCQCkGMiHKe60rcwya+yVxc8LLayfpCMtOL6XGNyZXSyk7ct3J2pPev1p8PFLyaZYmS5+B+16VrBQy/xTp72OonDQRFqA2snPGoZPBPfZY94Klq7XNfxV/60ymMqui910NmaPD+WvYaDUKsttSH+fT5k1K6QURi1IqbdMEl+i9/YFpok3LLEH42tukJz/kM1V85wFvAL9BGYjIeK2yQ6YoaO/xeSoW8w5fV/Owvd0GXTZthPy+Iqs1pZtlk1pHEIe/b0E+LPsidkFL0
 Ux7DgsQi
 s8VFDYDxayCX8mTH7vngABdbYLc7Us1xJxm/j/fhDUHG4GQguQB1wmEphbZXAwm7ye/Bw9L7rB3k54bomh7NMw5oX36hHsh+26m7Lxy7C8r0ptzNmSU3rzhmnLgtpAi+YTA+0bKXgDU0E6TF3pUdBnJ0/VI1J7m3p7CHCYaTYajNVbCiUUyrSE+yYVQl5vBxtaEzVHebI9ZPg9/isOscY0gEv7wF6noPD+aYCzNR7JlKUx7KEBKI6hHqvywJ4UTCwulJ67KrtHV5YFn+fZV/JWo+7sAfkCgt4OSM3bLvOntb9hBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:

[...]

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index bca912db5be6e..e0e544ef47d69 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -926,6 +926,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
> +				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> +{
> +	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
> +	pgoff_t end = index + nr_pages - 1;
> +	void *entry;
> +
> +	if (!gmem_in_place_conversion)
> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +
> +	mt_for_each(mt, entry, index, end) {
> +		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +			return false;
> +	}

Patch 1 noted that "Ensuring every index is represented in the maple tree at all times".
So I think the queried range should not be a hole in the maple tree.
However, there is a inconsistency: in patch 1 kvm_gmem_get_attributes() explicitly
checks for holes, but this patch does not.

> +	return true;
> +}
>  

