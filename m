Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C02BAC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 22:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B02B6B009D; Mon,  6 Jul 2026 18:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A426B009E; Mon,  6 Jul 2026 18:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6055D6B009F; Mon,  6 Jul 2026 18:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37AFD6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:35:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BEFE1401E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:35:44 +0000 (UTC)
X-FDA: 84959810208.20.4DAD84C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 58C0F80005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:35:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iq1mSIOf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783377342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXlheSpT7r8niLDF9M9Q+ZPasHDCny0xeaArmM5oL1g=;
	b=d6f4HmYOJj/E76tSMzdup57YBv06L+l8RrpQObO/+6pkTsV9WWfq3XM3009qnd5uBcx9NQ
	GHpE881BZ40FYk2OaBh7wFp1Q/TS6uGYHXOvpA0vs1JHtXJ+hcmLIk+PuUzjQwdneZEhyC
	gErPEev9/iMzSUeT546eiCCktX3Hv4U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iq1mSIOf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783377342;
	b=04bMjKfsZ25n4Xu26QzbcjZewcKIFEbd0lkZ7QafgN92YUVjxeVkw41zBoBKZtZhN5WUgF
	iuthpf6TK/mBl4X+20eTjSFHyqNGQuMhXpCMdDqtDShfgaU19mqFugdtfMAiTugLsk9GRP
	Jd1ogiMogJokWXUzs9AGGElEZJdlPi4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1D6E1A2D;
	Mon,  6 Jul 2026 15:35:36 -0700 (PDT)
Received: from [10.57.37.79] (unknown [10.57.37.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17BE53F905;
	Mon,  6 Jul 2026 15:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783377341; bh=5xW0Je1r/s8tU9FKAdzH8VS2dCLUKRAZPS9x3TJeUEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iq1mSIOfXLG3hXRFL9Kzv3yFJEcMbbMa8QmqTZzQVZz0ukxoYCO9wIEiV1IhNjKF2
	 JiQVfDNJORA0W4vyoEAG9Nv9JW4K9btsU/AGo0ZlZ8x2kv+Mcd5RWNMOyYQOn4y5fc
	 wcc/AlC5LPxEhlwBgbOmsH+v7PRJKr3UQqfOja48=
Message-ID: <6835134e-7f45-4d2c-b825-b45120e53d57@arm.com>
Date: Mon, 6 Jul 2026 23:35:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
 <114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com>
 <CAEvNRgFKbKfTMkqh_XF-igm07qYWfRwYJ5SH7wHcLZnqesCzTw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgFKbKfTMkqh_XF-igm07qYWfRwYJ5SH7wHcLZnqesCzTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 58C0F80005
X-Stat-Signature: w78te4bcaqk8yirr6o7j5ms9b713djj6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783377342-949994
X-HE-Meta: U2FsdGVkX19o3AYf7Tj0w3LsH5Penn2OiFY6566CUdhwGETydGB+i43pHn8Jd3SdiPAnZPPZHKGB8W+2imTxfxwRjqWXXFkW7EItq2H7FbwPYPjjLJAmAL7MA7ThthzdCyqEF0MV+b9E7WP8iIqHRiW9cz4SkrBxkYQ+3V5b0P/v8CBMphDFMqtsEtJc3FcmFMq71NYTZgsIEwA/Tm2gxbwCsckG+jc2X8P1d60JD733DI91BfBLRa75Xb+Gw5G8ZHFPzOPse2BtKENP1R85RUoGQ/yplx5reK/GxPGyzZYM98gFc131PWbdAcRvPUXM2qtdKFxXwz2KQQxZ0l2VDmyWFwUQ/G+qhyo9n/GF5woLRujVC/puAJB1o1K0jQShHEYJYwOuZDZFsMhygChBJ3qFmt1Txhkvq0R2QBbgC6U1ZpG51apJJO6SmYz2xBePuRsL+Wn/SAWH0W7zWE+UlS5grEjc2FoAGJNBXRHJaH12cOiZL1sd46A9XKLmAI/BpI6eFwYlNoUlzWASxoS+cNjnyLMusqLkZYQ3MmVcncS+EtnpIHU+ysrCCwZxqxa65UBaDpCbi6KQoA4EuRrp82CiLCeACMyViDawOiaEpBXzRT+ULcPFg30wW/MUoBGly+jaRJKH4xRhz1J9IKoESSeEtXb0sUA6fT4+j9zbtPJ1um53E+NZlnkE7w19YnvILT6NDvR8SCUKVeAXDym02BKMHarrcq0+cXSIo2D4o31gf0mLDjvlrPiF/8KNyOaWAsUS0r0ML83375zaP5mK+VlkZP8/Wk0/7YSDbxL+uIsiZZAkb4ICxO2N10wY/d2LjZJONg+V4OXYMWy2+/OD1Ai0KoW+gRmP/+oTtYtKN0L+GkNpzGG7SkedqKyuAi/4BPyKNGXUspHdDL3FOCpO4ANVxhNRmIKZHdsIAbIpl7mBLhLcqWz2R4YufI/Lho2cBRQ0kyS4zfrFnjXLaW6
 QiNWbkgx
 jBT8IP0vbRnv0W4zbbbWvrSnX4omAGuQ45ueNFod50xp0GGLKhPkTx4lwZUm/Nc0v686PL2G6AaIsF6L53Gvt7VlmQ5Kt9sNb0XSZNHZy2qXc2abQtyeobs7+TIXv/txew5gnE6AlV/9SV3PJtb/QhTeDge1d3yduICtf0NDrt+lC2QPXcAtmGaYMw8IuzZrYWN0XDzfcispFq1uXiyYJp1Xwvb4nygmkYSE1Hw0gUzS60lg3CtpqmFUatAHHmfcs5o+cjhkXuaEkl+lddC90qmUQYNjQzDZrouqSof+q+Wf+kjqKNuLByQ9stzJFauEeofyvl+YDna78G2USINR9WHlTUSc/22r/WrtpgdwEyPyRWts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/07/2026 19:17, Ackerley Tng wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>>
>> [...snip...]
>>
>>> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>> +				     size_t nr_pages, uint64_t attrs)
>>> +{
>>> +	struct address_space *mapping = inode->i_mapping;
>>> +	struct gmem_inode *gi = GMEM_I(inode);
>>> +	pgoff_t end = start + nr_pages;
>>> +	struct maple_tree *mt;
>>> +	struct ma_state mas;
>>> +	int r;
>>> +
>>> +	mt = &gi->attributes;
>>> +
>>> +	filemap_invalidate_lock(mapping);
>>> +
>>> +	mas_init(&mas, mt, start);
>>> +	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>>> +	if (r)
>>> +		goto out;
>>> +
>>> +	/*
>>> +	 * From this point on guest_memfd has performed necessary
>>> +	 * checks and can proceed to do guest-breaking changes.
>>> +	 */
>>> +
>>> +	kvm_gmem_invalidate_start(inode, start, end);
>>
>> I added support for Arm CCA KVM patches with the inplace conversion and
>> I am hitting the following issue.
>>
>> 1. I am supporting INIT_SHARED + MMAP flags.
>> 2. VMM creates the Gmem_fd with both the flags above.
>> 3. Uses the shared gmem-mmap to load the initial payloads (kernel, dtb).
>> 4. At the VM finalization time, Populate the loaded regions one by one
>>      by
>>       a) copying the images to a temparory buffer - Since CCA can't really
>>          load the contents in-place.
> 
> Sounds good :). I see that you blocked this in the kernel by returning
> -EOPNOTSUPP if (!src_page) [0].

We could do the copy in kernel with src_page == dst_page, but that would
affect the batching of Granule delegation (and at which point we might
need a temparory buffer in the kernel as big as the vma_pagesize)

> 
>>       b) Set the "region" to Private in the gmem_fd (via
>> SET_MEMORY_ATTRIBUTES2)
>>       c) Invoke CCA backend to populate the private memory via
>>          ioctl(KVM_ARM_RMI_POPULATE,..) [0]
>>
> 
> This flow sounds right.
> 
>> [0]
>> https://lore.kernel.org/all/20260513131757.116630-27-steven.price@arm.com/
>>
>>
>> 5. Additionally, VMM can mark the entire RAM to be private before the VM
>>      starts running, again via SET_MEMORY_ATTRIBUTES2. On CCA, this
>> action is measured and doesn't require the Host to "commit" memory to
>> the VM.
>> Instead the host can lazily donate memory on a fault.
>>
> 
> For both TDX and SNP, the host can also lazily donate memory,
> guest_memfd supports this.
> 
>> But step (5) triggers the invalidation of both private and shared
>> mappings of the gmem area, from the kvm_gmem_invalidate_start()
>> above.
>>
>> This is because, the entire DRAM now has, some portions PRIVATE (the
>> loaded regions) and the rest are SHARED (from the Gmem_fd creation).
>>    Thus, kvm_gmem_get_invalidate_filter(Dram_start, Dram_end) causes the
>> invalidation of both "PRIVATE" and "SHARED" regions, which results
>> in the destruction of the already loaded data and things go south.
>>
> 
> This destruction will happen for TDX as well. I think we managed to get
> around this because we didn't apply conversion on the already-private
> ranges.
> 
> IIUC on SNP, zapping pages in the stage 2 page tables doesn't destroy
> the data, so that's probably why it has been fine for SNP.

Additionally, the Guest at boot, will try to mark the entire DRAM
as Private (RIPAS_RAM in CCA), which would trigger this anyways.

Suzuki


> 
>> When we know that the kvm_gmem_invalidate_xx is triggered by a
>> conversion, we don't need to invalidate the existing pages that
>> are in the requested state. i.e., the following patch on top of
>> this series does the trick for me :
>>
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index a97fcac34a0e..62e0427a49f4 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -250,16 +250,23 @@ static void __kvm_gmem_invalidate_start(struct
>> gmem_file *f, pgoff_t start,
>>                   KVM_MMU_UNLOCK(kvm);
>>    }
>>
>> +static void kvm_gmem_invalidate_start_filter(struct inode *inode,
>> pgoff_t start,
>> +                                            pgoff_t end,
>> +                                            enum kvm_gfn_range_filter
>> attr_filter)
>> +{
>> +       struct gmem_file *f;
>> +
>> +       kvm_gmem_for_each_file(f, inode)
>> +               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
>> +}
>> +
>>    static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
>>                                         pgoff_t end)
>>    {
>>           enum kvm_gfn_range_filter attr_filter;
>> -       struct gmem_file *f;
>> -
>>           attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
>>
>> -       kvm_gmem_for_each_file(f, inode)
>> -               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
>> +       kvm_gmem_invalidate_start_filter(inode, start, end, attr_filter);
>>    }
>>
>>    static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
>> @@ -724,9 +731,14 @@ static int __kvm_gmem_set_attributes(struct inode
>> *inode, pgoff_t start,
>>           /*
>>            * From this point on guest_memfd has performed necessary
>>            * checks and can proceed to do guest-breaking changes.
>> +        * Also, we don't have to invalidate the regions that
>> +        * may already be in the requested state. Hence, we could
>> +        * explicitly filter the invalidations to the opposite
>> +        * state.
>>            */
>>
>> -       kvm_gmem_invalidate_start(inode, start, end);
>> +       kvm_gmem_invalidate_start_filter(inode, start, end,
>> +                                       to_private ? KVM_FILTER_SHARED :
>> KVM_FILTER_PRIVATE);
>>
> 
> I think this makes sense. Thanks for catching this.
> 
>>           if (!to_private)
>>                   kvm_gmem_invalidate(inode, start, end);
>>
>>
>> Thoughts ?
>>
>> Suzuki
>>
>>
>>>
>>> [...snip...]
>>>


