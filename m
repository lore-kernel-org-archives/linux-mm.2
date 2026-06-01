Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA73CD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E666B02BF; Mon,  1 Jun 2026 04:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F756B02C1; Mon,  1 Jun 2026 04:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96CA26B02C2; Mon,  1 Jun 2026 04:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89E4E6B02BF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:26:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EAF7C214D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:26:47 +0000 (UTC)
X-FDA: 84830662854.18.6D1E976
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A101C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:26:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FzJV5bP0FBFUhYMhPqUiIUxss0AqI7oZALNqmVWrGcA=;
	b=DVOKa66NB8BZJHTJ1TBpA23ASQJkNQmrktXdCfh5CCJe5ww0QjUvP+GXvBErc0C2zMIRCC
	upYGFbrNspHNIbX3dqi1PA3TJ9FA/cE5eprOeqQ9VJOrHukNKo3snTTnxX3QPvUUsdK6Aa
	IT2ZR+prWrux8Hm6R4S3mcmQS7W1bL8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302405; a=rsa-sha256;
	cv=none;
	b=iNyHFciu9xjDOv8/+B2hOw48tr0bI91QZo/9682gSmVMAkyZa77WDk5CrzLOcxf4F7cdC+
	UartFJ2HNEPTokVzW6QNbayVerLzyKkIpV6n37/0r80WRoSf0cYGeLk69YfttoQlfh9n/N
	o1rbh8dAoUri7Xmuo/SYdCsK+sIBTwk=
Received: from [10.213.19.193] (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAB3F9A5Qh1qWQpVAA--.175S2;
	Mon, 01 Jun 2026 16:26:34 +0800 (CST)
Message-ID: <48855978-6834-4427-ae55-e05650b1ea89@iscas.ac.cn>
Date: Mon, 1 Jun 2026 16:26:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] riscv: mm: Call mark_new_valid_map() after hotplugging
 vmemmap
To: Mike Rapoport <rppt@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn>
 <ah0xLeD1_6oRKDkx@kernel.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <ah0xLeD1_6oRKDkx@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAB3F9A5Qh1qWQpVAA--.175S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4DKF4kJF4DWw1DGFyUJrb_yoW5Gr4DpF
	W29a1fKF4UJr1xuws7u3WIqr4Fk3ZYvr18G3WrK34rZry5uFy29wnYkF4Ygry7Gr97Ga40
	yFn0kas8G34DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU5-jjPUUUUU==
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Stat-Signature: wjguxpg6yhk6nnszwtduezf3e4xz1ege
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A101C000A
X-Rspam-User: 
X-HE-Tag: 1780302403-318242
X-HE-Meta: U2FsdGVkX1/I0M+lwxCICMo2fxYEBxHTRDO+rL3FQDPm3lwZGG5jex4lnDqAVrtRVmxawhXAnqIs9KnFL9J6XyFtgOOaqtsUE1vpGJe9Xq8ROLE8L5QzkdFB2HBcu4yveFg+5LET9SPqLii918O1MaD18DPQ0b5N98ukZEuK7JTdaYuRBRr0XB0UVHjaAkNt9n+pmu0gqDPZZQrnSierB9z986haQa+baHTKyjGEv9lHNHEEXPmzpV3u4I26iO3OCwixSxOjSCXg4hxrNOb/3sdiKRyPmzdumwmV5NK3emXJpVFsuSCpC9rhRgWQDt2k8VW3U1aMECb4WJA8cOcri0sealdvX/736L15FhlyWyBI9tGiYDwU87i0Mgi7BnFCcD29TRM9KD2ngqtGwslUH99uUh65z4NNsjkrNohJlmMFt4+WUTvCTqE+jbi+Hj4gkbhh8KoyGiKGAIDwtLy8bhbO+gBPq0io2P00Zai/yWuXHHthnfpKIcbPm0NF8QlYZ+woS76lu8ersd3RKYHsrqVmoKpm1hWh2eY50A5gZmmSky7Ti66xBC8ydMUBbUS04HUZsZ2R5NVJqatoX/g+zRn/3nZMjeRcskG76ykFWCLbunEljanzMKirO+UyQW3z/TZKOqaJ1tjvNoDkNRyFvaPLmBnvYZDSjvoBPxIKJLE4A4VuX0xmV4nyUugKln6t1pysNFSK6P9NhckhsMPxec7I5cnE1oc3/1krjzBVcZgv4/1YcgRtDJgvIKfL0NVrAXe319IugecCQbRxfZs+ya7/SrzTrx4pzrrxUQr1ayR12IGkDPM99BY3CJ2c6j34+ciOm/rf9T6EQQvVKBybQzKYIQJFaYCjyot/PIU5FZPaY1zgVLYlEIl3Ohy+GuDcWMPNuGGJlTw/DdHPbGQ/N8eI7+Hfs2qIfF31P5dWFAftjpjvEnfPrPlLPXYnHpQWdBWxwfKKJRGRRBTla3b
 WN9Fgiti
 pz3J9XY4M5Sw0k4jw2ryJeRxDOQVVgGpk+YUiwVUkM7ZpqaEJGVAiJIjiTJbIIq2iuSuGSbyKl3v/ja19xYt4uOOmqUX9dV1kY5L2GVcynD3HD6cspSvCu6yCsZtlafrMSekHyQu38PXP2XTRwCgX6t0NgMq160TPdusKGtzUJ3aIit8Nn71ihiCNqbsOTY62JAl+N64o/wO21O0oiR51yuMfH6KoQrihtsN5C3i8fCmr8ki4Cqk6Gwk+wXrbjIqh4nOgQCNwSvungog1UWEjJSAL9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for your review.

On 6/1/26 15:13, Mike Rapoport wrote:
> Hi,
>
> On Mon, May 25, 2026 at 12:23:29PM +0800, Vivian Wang wrote:
>> section_activate() creates new mappings in the vmemmap range without
>> flushing TLB, which may cause faults on some RISC-V implementations that
>> cache non-present PTEs and crashes.
>>
>> This seems to be most easily reproduced with DEBUG_VM=y and
>> PAGE_POISONING=y, which causes these newly mapped struct pages to be
>> poisoned i.e. written to immediately after mapping.
>>
>> Add a hook vmemmap_populate_finalize() in __populate_section_memmap(),
>> and implement it as calling mark_new_valid_map() on RISC-V, which
>> arranges for the exception handler to deal with these faults if they
>> happen.
>>
>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>> ---
>> I'm not sure if this is the right place to add this hook. I didn't add
>> it to vmemmap_populate because it doesn't seem to be called in all
>> cases. Please advise.
> Indeed it looks like we'd need a new hook to let architectures run
> post-populate actions.
>
> The explanation that says why a new hook is needed should be a part of the
> changelog.
>  

I will reorganize this in v2.

>> Depends on my earlier kfence fixes for mark_new_valid_map() [1].
>>
>> Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
>> ZONE_DEVICE requires another fix [2].
>>
>> [1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
>> [2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
>> ---
>>  arch/riscv/mm/init.c | 6 ++++++
>>  include/linux/mm.h   | 1 +
>>  mm/sparse-vmemmap.c  | 6 ++++++
>>  3 files changed, 13 insertions(+)

[...]

>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 6eadb9d116e4..2b860d2b1703 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -544,6 +544,10 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>  
>>  #endif
>>  
>> +void __weak __meminit vmemmap_populate_finalize(void)
>> +{
>> +}
>> +
> The existing hooks in sparse-vmemmap use #ifdef <hook> rather than __weak
> functions. Take a look at vmemmap_can_optimize() and
> vmemmap_populate_compound_pages().
>
> Let's keep it consistent.

I wasn't sure since it seems that both styles exist in this file.

I will change it to #ifdef in v2, as that seems to be preferable.

Vivian "dramforever" Wang

> [...]


