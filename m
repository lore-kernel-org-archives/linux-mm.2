Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17E2606A8B6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IM9TpDQ/
Received: by kanga.kvack.org (Postfix)
	id C9CB46B00EF; Fri, 13 Nov 2026 12:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CF46B05B2; Fri, 13 Nov 2026 12:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C9E6B05B3; Fri, 13 Nov 2026 12:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81FAF6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:04:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BCAEA6DD9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:04:28 +0000 (UTC)
X-FDA: 85430719416.05.553AEB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id A96A3C000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:04:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IM9TpDQ/";
	spf=pass (imf10.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794589465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDSv49j+RC7blbeAA8J/fPgGpqdzGyAQV5qTaZUyPN8=;
	b=4BXb2Gatf+6En79jwoPZNuFlPp/A0kKRd83Ik7IamTsXFa6F4czpN+kKJeF4RX6rPSayP/
	Hw4uGTjtYbMinI5A62O3zpphSh5h0/0jKmfgHtMRqLtdA56XzIyWzn5zIcVpbpoC59XIcL
	D8pV2RJmoy2Mq/5pcK03opb2SVBdjC0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IM9TpDQ/";
	spf=pass (imf10.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794589465;
	b=OLpGLA+fUUHubsbNDUFbjYXbkuLD6ANes7wQMOXXPTAiHmrbkS1nruE/4FDROuQ/nuSO0x
	tedDvlbL4r88VI1MEMN4PjrdISdeImKXYyhHHBGZtZvn1gWJQeuO0FGtCaenlUFPArDz/W
	JHE4pSofno+CrCLgTQAcxCPGV+9/kB4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794589465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDSv49j+RC7blbeAA8J/fPgGpqdzGyAQV5qTaZUyPN8=;
	b=IM9TpDQ/6yeiEZD5MT89wAjpbCAJgEdL2Ry6wrAQ0iw4OL5EQgNl3b1RKJ0usTh4Iuu5AV
	0hrXl5GEy4y3+1qS2FVY2FFTa0qaT6YW8q4v0i66WNxQaNvIo48gdBFQMz8pZfmc1w6GQN
	5k1v6zjTIhYeCzySQPefA4FzlN0XBkM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-dfNbwrHeNnm7nzs3ZqBHyQ-1; Fri, 13 Nov 2026 12:04:21 -0500
X-MC-Unique: dfNbwrHeNnm7nzs3ZqBHyQ-1
X-Mimecast-MFC-AGG-ID: dfNbwrHeNnm7nzs3ZqBHyQ_1794589460
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b0f667a666so1636290a91.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:04:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589460; x=1795194260;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zDSv49j+RC7blbeAA8J/fPgGpqdzGyAQV5qTaZUyPN8=;
        b=CyLDS3wV4mKmiqBA5YfTaNbY6Li8psp1vltonbuzaXWpakN+Wb9FGxPBt8/vjZ6uf3
         o64Vi0ovS8cuhXTbzMnzAauQ6jW3yOx9hDAw2pIhzSFvqu8xkYJv4xn5KaUF/72V9oKf
         knGu01rlEKhxUKhVJAg4YZmPlNMv7E1Ltdqel+0lof2xuqqhKq+3ymH9A2tIUp/I1ntd
         e/SoYc4HBeyow/r+XNpj4xtxYena+t6baJtJhxw/g8grS+8Z99fgS8YxtZrfLy/DeyPQ
         9IkpQkJz15GXt5mJ6z9xjDVH0cYIU6vSZa78trHd/ckGgQvDqg3yQJGOSRGpnLsdnAgX
         ergQ==
X-Forwarded-Encrypted: i=1; AL+hErHMv2aBcctb+TRxC1h7xGRiy77E62aVzUa+um/MTG7MjtIFWbeJiV8JjyzeMDW02Du1uyIfagG6Zw==@kvack.org
X-Gm-Message-State: APuU4Z/+CFQeCsDnPMId4x8TWHIQnvXqoHyt8jDUiVgWi2jHAk0VqZjl
	Uq6vJXJ56bEd9szhcSuQIFawY3+GVxOSjEUhg/iEO4SDC84SPM+qnYL1gbmNC9XEl5T/s5UH/4Y
	glwhqC1rfly+NIYyJpGH7wCaGDXNb7ioZPKs6H1L+39r+NYjBfrdQ
X-Gm-Gg: AYBFou1NSCim5gXEN4Zn/O+xNFiAn3ZMmaJDYZyI/eXP3odhet3bXhweaNOyq61RFSR
	WvU8RcZYzDjv5oDq12Lk5SDZH3BpA5pHtZWWjHwQkJyU+7SuNTqH8lc+KJcEvUReyx6IpRsJB7+
	Wyg8uSoQ25+hOWpa9v9wuaGpSSsBs3LpbqBi1dKYN55BBYP+LxbkjpqHD5VpZfyqsC5NvGn6SQf
	O+VrgxiMsf+W1t/AU8+/010GGAVO7A/HLkmlnNc91IE794Gx2bj1lDV42DKWtWIOGe0cRbUY4Pe
	gn+mcpwkUHhuNDfe5beagdhlOVsVMtCR3vR3FX9f5sMEhUVKmKiL7vo37W3ITV/Fu2JQOIaTRYY
	hnCgNq5UgOYSVQs0uTqOig9UwjO9IiqkplRxtsnTCEYEZ686rDiuqFREvWvBkgEx9Mm6+9yk=
X-Received: by 2002:a17:90b:4e8f:b0:3b0:ce1c:e754 with SMTP id 98e67ed59e1d1-3b1b0b52de7mr2828517a91.62.1794589459552;
        Fri, 13 Nov 2026 09:04:19 -0800 (PST)
X-Received: by 2002:a17:90b:4e8f:b0:3b0:ce1c:e754 with SMTP id 98e67ed59e1d1-3b1b0b52de7mr2828163a91.62.1794589454220;
        Fri, 13 Nov 2026 09:04:14 -0800 (PST)
Received: from [192.168.1.102] ([117.245.168.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7d9971sm13310855ad.34.2026.11.13.09.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 09:04:13 -0800 (PST)
Message-ID: <7d5f300f-ab18-4086-8a61-c3347168067a@redhat.com>
Date: Fri, 13 Nov 2026 22:34:06 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
 <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
 <avV9qoaPMBLCNOXD@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <avV9qoaPMBLCNOXD@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: etkpchV7eytMROfq8vlucB6ABe9EtZLlESJEPM33I4k_1794589460
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b3kcjpuxx8n4ydtyuhkhz3s7yz4peph8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: A96A3C000F
X-HE-Tag: 1794589465-881070
X-HE-Meta: U2FsdGVkX18xRfWJ5M1hDV6lj+eeicXVFs0u9qLbwkerRrN2pg4i/AA9NumQ63z2CF6xcMRVm++r8DELzsP2bsfqPUebpsHIsyQt4ZyuoJyDs5K3AO/nw1kEUHID7O90BJdwkBpTPCxARpGq6FLrnuS/TR2kmVufhghe6dldc+HL8efnmUYNa68qYeMS+48oAOff8OaSS2iZeaTb8uK2Mn0XvBtZO4h6u+OwuLtLEhsSQ09iCQhsRWNP5K4incKzETyeq3xBhgsMQ+wSqXZ9OcSy+/G3B+9mDD46NocDZqCn4EueyksajApOJxcdTYuSH+q+lXIxGTgbk7n5kx6KwCN/7kFGgSUTuOjN8q+AvEyZA0uMFwz4KKswno9S3tbzTNIPviBTeA6MppMypAjP8AfcP0897xb48IrJPtTBoMHBB7IpPQomEoo1buTVBd3g56M7UVVY6yjt12miWIdlxHU0rf4H3SufN5nzAJsNwPpRMZEbuqdcthlHA2+P75hZf4uTFwEUeVCumJ6BGkaqiF/S+SaKk/PLC7jrXg8g/7no6nhGULEYh0JEQSldR6A4SvaSxSNb19pGFoygBPrkrzD9TUBN0RVcMWazCbTLsGrykaOgbzIBMrKO4v3dUF7dF6tBYK4SOWb/fMQg+GWJeOOTIG24Vj0NylHf1plsbZIlFYQT5xDPLTyRzAVuJRBS4sIhnaS5PfCAaIarNCF+KfZDG5mnW2BVdCPuQAN+B48GPCIXw6ln8C2aZE8O9aA1peEpmB5F9v0Qdp8NQC5+t7h2/uP8x/pgRpkVjkdlRaxHPP+haC1Z86Jtv/O9BnvZmG4coQie0EI0QDJitjb5Jc9DaKlJAAwWM4PU/MWw3koDFsT+S/B1m0VbY0LRxbCzyc9GPmG1LdJoYcGqMnlHpB/2irshxytyAAKlTH1RqHoUpFCZE4a4my3kaJQTqgILH6ZefGMlKBh57xMxf9R
 a4IgApXY
 TwkNrIbnsjomvAT6xSG8BcQFvunaAvdXJLiLuSjWG81zVsR7VCuQRIIwq5qRPbXk5vU8lviTgTkIg1Jq3lUzasPC5FSYha5DKD8KiVYE+oKN9qJpdW/dr6kc7b+lrsVvt55/IbwR5YDw5vBYZDmI6K4sL06B8Y2ESbn+9dsYzXUkC9DjOXBWYHQFsqtIzxNOnb3c323/mVoUa48HiQAmwVDA7kjarftgT5sUtcSaMv+YtVjqFGMucoq8GqcTmTui2FKEWNj31V2L9VahqjP5BskDgoZftaNHXIjuxuWbU5ICjXWetLxXdvC+i28yPCvkjHpAk3+c2unOJAl5Sh6ZLngTydXhlYRd3A6ZpxmvpRjfQMf+YhAk/Gz4NpSd5hzPrEqgW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

Thanks for the quick check. I apologies in advance if I am missing
something obvious.

On 12/11/26 2:19 pm, Mike Rapoport wrote:
> On Thu, Nov 12, 2026 at 12:02:05PM +0530, Mukesh Pilaniya wrote:
>> Hi Mike,
>>
>> On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
>>> kexec_add_buffer() users may depend on the order in which memory holes are
>>> searched. For instance, arm64 places the kernel bottom-up and then
>>> requires the DTB to be above the kernel.
>>>
>>> kho_walk_bootmem() walks the bootmem areas in the order they were
>>> reserved, so if the kernel lands in a small area at the top of the memory
>>> there is no room left for the DTB and kexec fails. For example, on an
>>> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
>>> reserved first at the top of the memory, the kernel image takes most of
>>> it and kexec fails with
>>>
>>>   kexec_file(Image): Could not find any suitable kernel location!
>>>
>>> Sort the bootmem areas by address and walk them in ascending order, or in
>>> descending order for top-down searches, like kexec_walk_resources() does.
>>>
>>> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
>>>  1 file changed, 46 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>>> index 6f1f55fe31819..2ac5d94f33fd4 100644
>>> --- a/kernel/liveupdate/kexec_handover.c
>>> +++ b/kernel/liveupdate/kexec_handover.c
>>> @@ -26,6 +26,7 @@
>>>  #include <linux/list.h>
>>>  #include <linux/memblock.h>
>>>  #include <linux/page-isolation.h>
>>> +#include <linux/sort.h>
>>>  #include <linux/unaligned.h>
>>>  #include <linux/vmalloc.h>
>>>  
>>> @@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>>>  	return false;
>>>  }
>>>  
>>> +static int __init kho_bootmem_cmp(const void *_a, const void *_b)
>>> +{
>>> +	const struct kho_bootmem *a = _a;
>>> +	const struct kho_bootmem *b = _b;
>>> +
>>> +	return cmp_int(a->addr, b->addr);
>>> +}
>>> +
>>>  /**
>>>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>>>   *
>>> @@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
>>>  	 */
>>>  	kho_bootmem_cnt = i;
>>>  
>>> +	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
>>> +	     kho_bootmem_cmp, NULL);
>> This only covers the case where this kernel allocated the areas itself.
>> On a KHO boot the array comes from the previous kernel. A kernel with
>> this series that is handed over from one without it therefore keeps
>> walking the areas in reservation order for every following
>> kexec_file_load, and the arm64 failure you describe comes back until the
>> next cold boot and vise versa because the ABI string is still
>> "kho-v4".
> 
> If we were able to kexec from a kernel with no reservation ordering, the
> issue is not there, isn't it?
IMHO that holds for the image that was just handed over, but maybe not
for the next one. The producer's last kexec_file_load did place that
exact Image, DTB and command line through the areas in that order, so I
agree that reloading the same image from the consumer will find the same
spot. The order is still arbitrary though, and whether it works seems to
depend on the size of the image being loaded.

To give you the case I was looking at: on a QEMU arm64 guest with 4K
pages, 2 GiB of RAM and kho_bootmem=44M,64M,64M, the 44 MiB lowmem area
is reserved first, at the top of RAM (0xb8800000). The Image is about
38 MiB, and the DTB has to go above it on a 2 MiB boundary, which lands
exactly on 0xbb400000, the end of that area. The load then fails with
"kexec_file_load failed: Cannot assign requested address", and the next
area is never tried, because the walk stops at the first area that
cannot take the buffer. With the areas walked in address order the same
image is placed in a lower, larger area and boots. So the first area
decides, and a few MiB of growth in the Image or a larger DTB is enough
to flip the result -- which is the part that makes me a bit nervous
about the first kexec after a handover.

It also does not settle down the chain, as far as I can tell. A kernel
booted by KHO never reserves, so it never sorts: B inherits A's order,
C inherits B's order, and only a cold boot sorts. That makes the same
binary behave differently depending on how it was started. Sorting in
kho_mem_retrieve as well would cover it.
> 
> And after a cycle of KHO boots to newer kernels we anyway can get to the
> point when bootmem is not large enough.
That is the same argument, and it is probably why I am not fully
convinced that the previous successful kexec covers the ordering case
either. The inherited state was adequate for the load that produced the
running kernel, not necessarily for the load it is about to perform.

>  
>>> +static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
>>> +				     int (*func)(struct resource *, void *))
>>>  {
>>>  	int ret = 0;
>>> -	int i;
>>>  
>>> -	for (i = 0; i < kho_bootmem_cnt; i++) {
>>> -		struct resource res = {
>>> -			.start = kho_bootmem[i].addr,
>>> -			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
>>> -		};
>>> +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
>>
>> kho_bootmem_cnt is unsigned, but the reverse loops in
>> kho_reserve_bootmem() and kho_bootmem_walk_top_down() start an int
>> counter at kho_bootmem_cnt - 1, which for a zero count is UINT_MAX
>> converted to int.  That conversion is implementation-defined; with the
>> current compilers it yields -1 and the loop body is skipped.
> 
> We never get here with kho_bootmem_cnt == 0.
Unless I am misreading it, we do, via kho_bootmem=0%. The parser accepts
it and stores the scale without a zero check, then bootmem_size_update()
takes the explicit-size branch and assigns the zero-initialised
bootmem_size_pernode to every node. kho_reserve_bootmem_area() returns
early for a zero size without recording the area, so kho_bootmem_cnt
stays 0 and kho_enable is left alone and only the error path clears it.

kho_locate_mem_hole() is guarded by kho_enable only, so with cnt == 0
both walks return 0 and the caller turns that into -EADDRNOTAVAIL: KHO
is enabled with no regions and every kexec_file_load fails with "Cannot
assign requested address".

FWIW this became possible with 214f9649 commit, before it the
zero-sized areas were recorded, so cnt was never 0. The zero-scale patch
you posted in the v4 series [v3 1/5]thread closes this one.

>  
>> How about using this one.
>> 	for (unsigned int i = kho_bootmem_cnt; i-- > 0;)
>>
>> Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
> 
> Thanks!
>  
>> -- 
>> Regards,
>> Mukesh Pilaniya
>>
> 

-- 
Regards,
Mukesh Pilaniya


