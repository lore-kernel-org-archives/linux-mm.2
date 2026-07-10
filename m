Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27988C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A79F6B0088; Thu,  9 Jul 2026 23:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758FA6B008A; Thu,  9 Jul 2026 23:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F3B6B0093; Thu,  9 Jul 2026 23:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41CBD6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:51:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5CBE1C87C3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:51:36 +0000 (UTC)
X-FDA: 84971492592.26.478CC99
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6387040003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:51:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783655495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/ccZUMjbpOplyiCO4s9pEUiXVkVlU0NyYFuAU4fHow=;
	b=rv17hD21rldg49fhRLRVOTqn+0itY7lSXf/2e4YAAKoDwrYoXz2gAxvsKx6toNS6wU7eHW
	OEbgnGML2/8ikD0b+JrCDQmJnsB2sKPI56P1oWkAFOwi2s1nRmGlQeT5ZaLBxl6JODczf1
	jR0Xvg1/OR+AqnktVROoMgXsdyB8f5c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783655495;
	b=Uo+TNQcNd0grIgZknok/z2NbPf3EElHVtgbpM2AcWdY+I6v05MhPgVtm0bgjcKgKYHG3HB
	BYlJHComTaFsCaJp7F1XFSy7AmAtbWXALisypckjjmhv5vYn+Ss3hJxWwmz8pkBlkWjZO4
	45r5wQfQa7tpYewzBAg1Fv+LSlq0T4c=
Received: from [192.168.0.106] (unknown [123.116.46.73])
	by APP-03 (Coremail) with SMTP id rQCowADn47o6bFBqubxUFw--.3467S2;
	Fri, 10 Jul 2026 11:51:22 +0800 (CST)
Message-ID: <c53d323c-1416-49b8-9a17-faf99604b6f6@iscas.ac.cn>
Date: Fri, 10 Jul 2026 11:51:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
To: Paul Walmsley <pjw@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
 <db0de3be-a6e1-e4c7-6a1f-2f573499a2b7@kernel.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <db0de3be-a6e1-e4c7-6a1f-2f573499a2b7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADn47o6bFBqubxUFw--.3467S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KrykWF1fKF15Wry7AFWfAFb_yoW8uFWrpF
	ZIk3WkJFZrZFy8K34xAw17Wry8J3sIga4Yk3Zayr15C3Z8XFW0gryvg34Uury8Xa9YqFWI
	ka4YyFy5Cws8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
	8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7IU56yI5UUUUU==
X-Originating-IP: [123.116.46.73]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6387040003
X-Stat-Signature: d971n4wy6ouuq7zp1h18suq1nrbnwjud
X-HE-Tag: 1783655492-196288
X-HE-Meta: U2FsdGVkX184+2rad1/lUC4clsMUDTalEhji1BhVoJtanQszrrvZC3w7fhPoahThAPgAxR1hqCbAV0reB52dJr3/B2INbmJbcYMw7uU+Ux61wuH7GVXodnJUekhfUMRGr4DqI9Rr++RfrUBDXFGIWriddSqbNDhF6THXTSHFXletORzAoviZcOcs3oe1/OS+ecf9GhKqkgre3IHEbef8HKuElVmuC15HHi8kpsSiEnozxFk0oSJh+fUW1Ez6vJiFgn4LNVav5DPRICVlnynOMo4stbBiqpObYs7wfHR+FH/NCOG6ILr1mxwODRhwT0wekbv9m/LdGAMfplVzFoBdg1GG/Glp7lJY6mvfVF0vcc/S2H2fs9lqk/97EOo5VsG5rP7H8i8X8wZNXviiedF7O622ymRY/4lSqcloEZHJxo+ZS4RhL1WqsxKCA3jX7uX2prnx2Lc/PUi/LCwPXCwLeXdPUPppGSscuC+hzpSliepPo1yAUq8Y/v2tPyDg34UAmcldh607Qwwad8woPlEQDhc+TPS5Wx6ilWr6QApB7lOsuJJzWNIpcbp1scWkWutgrCflnxsQgWKlw5kQte85CnsVeDc2ZUrUqhtxHjlWEMvhvHSrChNNLnQu/ddNRo+pREYkDstSx6VN4J6b44kecbnp8BlddhbUvFSuRFrKiv3NLgFW6qG+xbmacfq4S9u/w2VfJaFVjPBvEdTmp0rMM2AfdR/k7dD+gDyW/3sxRxVoQn0kUVnJ9dQ/RRyvg4ChtCIsXKDR1pCIGSV1tvcatr1ahND2u7fMX+NtJuFmIo6hE08qORW2dn/BDjL46WOias4ltbAAy/W+rYfgDZUINiOHk6O6Y9bVM7TSS+vFu4Dt3Hsc6yXCErUHgDwPLrCG+iaLjQ7sjAQ796wmpcdm+UBtv3IlTSURw9mm3iJwmLIwn+iuIr/MOXgTC/4hRqsCP2UCDW+d+jcts1AgTUD
 v0v4mQbG
 q4uIAyqiWx723iWzTK9cO8Vz2tIBOKAzaqYzO7FmM7YYRtqArJmaLF9S5iEWTRiaeYUyz6Ryb+I8d9Nhf5pYYrb82DYodbgO05+JqwpAE0gkTeQ9zbKHPREZkDk4KwfXrSZJNiMSE9j1tt+muVfPmczlWeGxSKmhc2sclGRs0Uv2Dr+WRhGk31Ti5nYbSG562pcogt+GIodlwItIpykkPW2eooCJXVbMKqc20l7q0LyiTeEH0Urq0V036x7pMHVBQN9wFoj5FhBDxohnvKJfpwQbBgKSkDXWT7ffB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 09:58, Paul Walmsley wrote:

> Hi Vivian,
>
> On Tue, 7 Jul 2026, Vivian Wang wrote:
>
>> [...]
>>
>> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
>> index 8cfe59483a8f..e935db27f09f 100644
>> --- a/arch/riscv/include/asm/cacheflush.h
>> +++ b/arch/riscv/include/asm/cacheflush.h
>> @@ -56,7 +56,8 @@ static inline void mark_new_valid_map(void)
>>  #define flush_cache_vmap flush_cache_vmap
>>  static inline void flush_cache_vmap(unsigned long start, unsigned long end)
>>  {
>> -	if (is_vmalloc_or_module_addr((void *)start))
>> +	if (is_vmalloc_or_module_addr((void *)start) ||
>> +	    (start >= VMEMMAP_START && end <= VMEMMAP_END))
> Is there an off-by-one error here?  VMEMMAP_END is currently set to
> VMALLOC_START on RISC-V.

I do think end <= VMEMMAP_END is correct.
Documentation/core-api/cachetlb.rst says:

6) ``void flush_cache_vmap(unsigned long start, unsigned long end)``
   ``void flush_cache_vunmap(unsigned long start, unsigned long end)``

    Here in these two interfaces we are flushing a specific range
    of (kernel) virtual addresses from the cache.  After running,
    there will be no entries in the cache for the kernel address
    space for virtual addresses in the range 'start' to 'end-1'.
                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So this is one of those half-open ranges. When end == VMEMMAP_END, it
means that the end of the range is exactly at the end of the vmemmap.

> Am assuming you'll update this patch one more time?  At that point I'll 
> plan to add it into v7.2-rc, assuming Andrew doesn't object.

Yes I will. There's an extraneous hunk for arch/riscv/mm/init.c that I
accidentally added to this patch, which was the thing that prompted the
"oops I'll send a v6 to fix" earlier. And there's a build failure for
MMU=n, which I will also fix for v6. (Why is this code even compiled for
MMU=n...)

(Muchun: Also thanks for the hint on the latter point reported by Sashiko.)

I haven't been able to get to it this week, unfortunately. I'll
definitely get to it next week if possible.

Vivian "dramforever" Wang


