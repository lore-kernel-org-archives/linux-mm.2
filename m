Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49091CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0ECC6B008C; Mon,  8 Jun 2026 10:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6536B0092; Mon,  8 Jun 2026 10:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A236B6B0093; Mon,  8 Jun 2026 10:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92DFF6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:17:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DCA4C024F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:17:46 +0000 (UTC)
X-FDA: 84856948932.09.F07D1E0
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDCB6C0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:17:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A+uxWeZyQwki7QfKKL/1dp9YQstUAVMSh+PWgHHQTCg=;
	b=V87HkDyxOVa1Vs5fWo+/pNcfb+j/9kGT0vVqH7n7c3hJHvqAJTZtJ4fJRwh2dnJMEu+bkM
	hd/ohjwjGguTYV4C/casAIqT/k3R/ujyfwfsDbCMB4eYBGUD+20Vl5FlPkY42p3R8oLFVO
	VqZNkwVein/NJpR187k1Q/CiQvXxZzk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928264;
	b=TkATi6247Su9qCuy3WHcAWVzspY5CjwULtJHRUEAyz1GXRufGENE7rbIL5xeAL6V1V95uQ
	cmHVVosd0/RyEswqyivnFCi+yL5Uer8OFx08ZT79JDdhPtiaKu7hzdWrzVTXd/Oe2DFRNd
	D5UkAyLqWmVEvzNEJ49ZUzpxH8QhLuY=
Received: from [192.168.0.111] (unknown [123.118.218.239])
	by APP-01 (Coremail) with SMTP id qwCowAB3HNX9ziZqMi7mAA--.3556S2;
	Mon, 08 Jun 2026 22:17:34 +0800 (CST)
Message-ID: <b904d79c-7314-463b-99dc-1fae6d4ccd91@iscas.ac.cn>
Date: Mon, 8 Jun 2026 22:17:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
 <da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org>
 <953d7a60-456d-4629-b133-afce62cc5b3e@iscas.ac.cn>
 <3c88dee8-6fcd-4f72-9a73-17044214b087@kernel.org>
 <6a92f2c6-3b67-44fb-b645-91164118d8fb@kernel.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <6a92f2c6-3b67-44fb-b645-91164118d8fb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAB3HNX9ziZqMi7mAA--.3556S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1rCFyDXF1DKw4fuw1UAwb_yoW5Cr4kpa
	y7K3WDKr4vyr1Iyan2vw4UZF1Yk3s7W3WfWw45t3sakw1jqrWSgr48trZYkasrZrWkZ3W2
	vr4rt3y7uFyDAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY
	1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x07betCcUUUUU=
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Queue-Id: BDCB6C0012
X-Stat-Signature: ebsoujetbcyy8zdtqgrya3er5febryxb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780928262-905986
X-HE-Meta: U2FsdGVkX19c2xqHcOyHZOAcgebPMUMsOFHKlev0LOFL0XWM4XNSyffS0ItPWSqIJYq/6MHV5zvbM7jADFYXUaOL3/xpcOzzeEOcUsYFZZxrZGl7d8nkqlfNwkjJj17J6JZ4JqaOBbS6cRRDGkUVh1hCwcafAaHgoQOiEqYOrur0EQMGWnud4K1b+mPZqRSpZzEOjkTyKyjTW4nifDaIMaQes5X1KVLOiYVO4fo8RNUh9jMD0S9OTIakogtubCNmdadh119xouOjXQKmgYulb/DiirOi0q55iPo8l187EruEV4AvxZoG6DuFi7AVhcJNgqwQLUH4CTzjWZzW4aXH8HcuVu+9QzCU+KlGI0KHq2yCPcFUOzeybKoU1e2HeBqDRi/KrR+JQ554nAcSPKN4pn504fUzaublGruZ6+eMYejcBPIvlWRKfokstZfui6I9IBayq7PXlRqWb5p4bIPzNQmtPVwmV1J+abLeBGZAWpP86E2BqBRhsWEGX95GTOYfWW+zdR6iRoEjcl9AEubB4vG4HMNYH1PbS0L7ysWXYPNt/ENzrEXWSawMb6e/Mg7Svvr5JKH8/ltQEQb61QOpGeIckoCSZ7VC0URsyuQ7jSoFJcP6kK/Uk9B4Mqx9T87D+P7lNxyoLGXcsnn0QjHspf10/c94FfY8JJzewogyPNXtRdSzYedDrwAZNTeYF2Sw7kKd57Hu3NgeI5lmI6SZUEiuijMl8et4rlBdNEAuivJSIqOhvgwhQjzrZzQyhS+0nUcSX9W/ykJ97LpzAdmbU/hdIlyjCJicqJuJ+9UuxGZaBTPc2kQsupxhep9Tk6LJTLPdcodRIoKb9dSBQr9igfaYQ54j41r9e+Ni8PTdSMn2HGasn0rdpTjnX4cD4IgBXYX+ey94Y4AZ7/rJlic1dSFNurcM2xsSADwOVTN9IblYzUKjKGnGui2SHOQr1WPaISEBECWa3dvuC2XNhhR
 1JlN1qmv
 aD5mlWCT+RItMY3TQbdHsfR33KUEwRnUIQ8AQOuk1jAdqvLfWW9EGyyPf+lVthOCU23Tyz/9d5sRDus0Qg1uXrgn6ZwNex+J7dz5DvC9/I6CSWsf1NQxWDgOPyA4AkK0z3/y5FVfs5R2QFO+ClXosSqNrQLSPL+mW4+MAFIkOUCr2L63RfwdNwLujuP+eojm//fFbXK9RG1y/GS16Vk1JYURfpqpDhYDFlpEYqDCE3gB5SuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 21:18, David Hildenbrand (Arm) wrote:

> On 6/8/26 14:43, David Hildenbrand (Arm) wrote:
>> On 6/8/26 04:24, Vivian Wang wrote:
>>> On 6/5/26 17:16, David Hildenbrand (Arm) wrote:
>>>> How does mark_new_valid_map() handle concurrent access?
>>>>
>>>> There is some comment in there, but I am not sure if that actually implies that
>>>> mark_new_valid_map() can be called concurrently from arbitrary context?
>>> AFAICT, yes, it is intended to be used concurrently from arbitrary
>>> context, and this is why I used them.
>>>
>>> I had not originally written the code, so some riscv maintainer can
>>> maybe chime in on this, but as I understand it the idea is that we only
>>> ever set bits in the bitmap in mark_new_valid_map() while "allocating",
>>> whereas the assembly code in handle_exception in
>>> arch/riscv/kernel/entry.S only ever clears individual bits. So at least
>>> the access to the bitmap itself should be fine.
>> Right, flush_cache_vmap() looks like a bitmap_set() -- non-atomically.
>>
>> .Lnew_vmalloc_kernel_address does an atomic bitmap clearing ("Atomically reset
>> the current cpu bit in new_vmalloc").
>>
>> I am primarily wondering whether we'd want atomic bit-setting as well?
>>
>>> This was added in commit 503638e0babf ("riscv: Stop emitting preventive
>>> sfence.vma for new vmalloc mappings").
>>>
>>> Do you think the mark_new_valid_map() function needs extra
>>> synchronization like smp_wmb()?
>> Right, I wonder about atomic access, but also about memory barriers.

Oh dear, I've dug up quite the rabbit hole haven't I...

I'm going to leave that at "I don't know" for now. Maybe someone more
confident at their memory ordering knowledge can chime in.

> BTW, does riscv support a better mechanism to avoid such spurious faults?
>
> E.g., on arm64 we have emit_pte_barriers() where we issue some barriers:
>
> "The isb ensures that any previous speculative "invalid translation" marker that
> is in the CPU's pipeline gets cleared, so that any access to that address after
> setting the pte to valid won't cause a spurious fault."
>
> I assume the riscv case is different, as it's about actual TLB entries, and not
> just translation markers in the pipeline?

So yeah, conceptually the "TLB" on RISC-V caches the actual pte_t words,
and RISC-V cores are permitted to cache these valid=0 PTEs indefinitely
(if no "Svvptc" feature bit), or for a finite amount of time (if with
"Svvptc" feature bit).

As mentioned in the kfence patches [1], SpacemiT X60 cores in SpacemiT
K1 appear to be able to cache these valid=0 PTEs across even an WFI, so
the "indefinitely" part is probably real, although that doesn't mean it
isn't pipeline-only if all the WFI does is to stall the pipeline.

Not that it would really help, since RISC-V also has nothing like the
lightweight pipeline clearing stuff you mentioned defined.

Vivian "dramforever" Wang

[1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn/



