Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D161CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C0E6B00D7; Tue, 19 Aug 2025 06:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B63A6B00DA; Tue, 19 Aug 2025 06:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5386B00DB; Tue, 19 Aug 2025 06:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 628376B00D7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:11:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5C1E5A100
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:11:12 +0000 (UTC)
X-FDA: 83793089184.03.0E5C945
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id E2CE120007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:11:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JBXv5/7K";
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755598271; a=rsa-sha256;
	cv=none;
	b=yYD/KiJC2ZflpTUPbwhp4U8CUcnc+A4Dxu96G6EbGmOicjdXbNd8wRaGoIndqrFyM/xZ9l
	gokTkjuTY5quUT8S9KeaRKVHMvAuMye8CXLgP87t3wWgcpK0vK7mt4hF6+pgjS/J22YS+k
	bmYw5MwMvHsFDmns3qTj67TqppC9Bn8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JBXv5/7K";
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755598271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HmdM3IXlCoHz3y6cbIntEEXVkN2Z0YcF/Z1V9nwLjo=;
	b=OCtKPWLJ5FsCi+yAbJksO1QcUWgji9AvcLOJ3wk2GZrCi6CAPc7rSDRwJjPUT1aR3V+ooV
	yInbIGuxwphjfb5hyZ6XqDH6gZ2QEsixULCP4MsHrwwk6tZKXWqLPOxT1HP9YsMpbIpTnn
	ywnnDGRjJ1xNs1J52A+B7fS3/sYAiJM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9edf36838so3161981f8f.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755598269; x=1756203069; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HmdM3IXlCoHz3y6cbIntEEXVkN2Z0YcF/Z1V9nwLjo=;
        b=JBXv5/7KHjyus0ykWvDF/uQjxK1zMk9yxTqKFXXoucfpQWY83B0CqghiZq9N95G4Jt
         hffAIXYDgvr9Mw6LO4o+/EY3TQ+jScRYsmE4ASDywy6yz4EX1DiAqeYmm4cLPlFSiPo1
         KOtinrgAGn3NkHEqZ9CHo7Fs4n5vQdHz4I96QeWw0DDJEPo3dgA8XAmf9lEEXV0J2RUH
         jqiXwNej9OsGCx0kKthYSn1O896mQ9u3+V6H/tPem61Tv/g3LHLNrLnlSgXxNUb59Zut
         ldFcTcrgnxUhs9FEewYUgIbqAMRMLvqQNjUR8vX7PSV0QI9CebfnWlxwYZNgwQoAigcd
         LqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755598269; x=1756203069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HmdM3IXlCoHz3y6cbIntEEXVkN2Z0YcF/Z1V9nwLjo=;
        b=wO5EPkCahUhuyfcdC49e+RPVt0gfn8mhZk46kHWzFY39aRWc3LGfbQ+By5+erknNiD
         1k6GQb2tYaMQMdmzCfmab9gEDINAxX+IPVNBnwQFuk3pysGfaOq44AWzLSsWGij8gzNj
         FW8/vKeEESd6MaVup0QJqJU5N/XdlMn5rIjmsskGEXEHxnOP4TYBlDwWg62yr0JHXnUl
         5I5CexxKRsjlkN74yo9QiOmdc7PXgNABHeyivRgYWubQ05O+tSR1nILhT9WlFQR0xhf3
         a14c6Z2P3NGeBXU/1ZPiBybG4dWjW34MC/VxImWYTUcUwcr56EfMSIUSy5wJL8NrduaH
         ckMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoDQ0HgR/iyRraB7zKnEh6/VxULpW2sGBq7qhkdWgt3FjyRCb1Drw0eEt4chG+5Ku+hOpXN/Roow==@kvack.org
X-Gm-Message-State: AOJu0YzmwmyI8lO28L4JR490d6pX6OmOgtYzwlh958VtL6tmKnHT9kMe
	p+v8lc5MOOS80ELkZPSEXLEnVXWo1hE8vQ3x9V0BOuFv8pU3Va3+vLxy
X-Gm-Gg: ASbGncvgWe2tZmTB6QeAw1ZCdbs6JPv2MUdfdiX/HQStVWi2xxM+OI2umq9nasJhbiS
	szw5+NtJXIuilPaZJZYO/xMgjYO3j5d39VKA4McedGrfj4QSlTOXpDYrV/2oAQPwJXyQcuAqVRG
	Sp94wqUokmeWgwqH7NXh9TJiN2fKmydlWSf8O9lbadRMXx/Y895c+iDQRDKvHwKvzzUeaM7Obgq
	FeNK5wTGYwF0W6+XqPKdNniq1gOAgSCOhzNYTVHpNqjPncM475D1Pb+r9qjfPGXd7321K234egK
	70iaI0rQ9YakdwPLxxaA2EZ3q3DkLQiY3WxOqMzOOOrPtqm7F5Ew+g0U0LmjSrJzrrBNaymLI8K
	Jkg/NxWabu8nqSpipyh3oxylnwjcNI0tf+dQO1A2h5Ve1z6QndafRWvNRdiDTix4kXtAmjMQ7MS
	ORZsv4ww==
X-Google-Smtp-Source: AGHT+IFXF3f1sapMa8ONCpGVfGr9sEWq4cBWD19yqnxWJGavX43hKO03sMmwP8WGlfFa4I/vhMstsg==
X-Received: by 2002:a05:6000:40c9:b0:3a3:7ba5:93a5 with SMTP id ffacd0b85a97d-3c0eae581e1mr1350735f8f.26.1755598268935;
        Tue, 19 Aug 2025 03:11:08 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:ba2b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c57aa0sm3091124f8f.66.2025.08.19.03.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 03:11:08 -0700 (PDT)
Message-ID: <c855bb8b-4395-4235-8786-3a271252c455@gmail.com>
Date: Tue, 19 Aug 2025 11:11:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 mm-new 1/5] mm: thp: add support for BPF based THP
 order selection
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com,
 willy@infradead.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, ameryhung@gmail.com, rientjes@google.com,
 bpf@vger.kernel.org, linux-mm@kvack.org
References: <20250818055510.968-1-laoar.shao@gmail.com>
 <20250818055510.968-2-laoar.shao@gmail.com>
 <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com>
 <CALOAHbAzQmqxcJ7HU+gsdX4+iEj0U=E5mS8nXF8OYW9QxuXSLA@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CALOAHbAzQmqxcJ7HU+gsdX4+iEj0U=E5mS8nXF8OYW9QxuXSLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2CE120007
X-Stat-Signature: 8m3fqm4t9pjbsit7cecs9xqs9az33xzo
X-Rspam-User: 
X-HE-Tag: 1755598270-763826
X-HE-Meta: U2FsdGVkX18BxLKFHn84FriwWhd4B2CjvkjI+GSQFJDBV/bDLT0AI3+9GDq9gKRV+Fb/D/q4rG8sd51LNub5kGqBqtbGN3Ks9HzXAq5gFVlr/x2qqLO4OEu9dBxyWUx1ISABS6yDCDTmNYVOa0oOdvMYPTExcrFtfYozcT1vfQedIxuCSLINfm1A6p/qHvhGDGHPP+WVPKMgmHhFObQ9X1tlCuacqhVXSHWLLjCsA69pBvQshBrY6ZGfAX1fUVVqfK23r8fceEgic7A8ntBh9WPZu07HZGftGShTfLMa5NsJx4i+o7KEvH01PxJXkbe49GFXgz6p7HgyRhVcIjQ23qrDO7i8hBtx6qizluZgSkpcHV3DDaw4uefdZcCmW3Mw34ifNC6WVFSg+qVQB9o/vI2j6XMbi0rtA4jqEbcNWRmVtvMYwfcEgXhvyl60b1ABVGCCfMgsKhHKR7gZ9fki4xpTThmKmg2yMiDyKo9m4vOWf6eFCZK8nv0MLEKgo3ASQFm3Lcox7o73j7U0b2Lt0L19vsoU23pfwQG8JEYLmfzmShri+Tqu2+xRwX8rNiq07ZLsezTfBpZA5TSVpJOuZ5B/gq5HxaCF/iowAju3uczUnbAEZPvZuKlngRAekXWWU8iYO8whWoHuwEaatu6GxbhVlhhA5BVxGXlm5/2FloNIr/VY9j4zchzhzCJ9E2AjUFqBJWPNte0yJ02qAvT3ZbQoG7TyMTibNPcqZ3Ao7GkUn6cFeE3zlz76zz/FQAGFrc6u22874roA8O4FuPWXQP1gcxICL8xrCJwvuSO/JBv/ZW3gqRfZFG8X3HpEu9Nn78b+gbB98ojkwJ2HO/zsk/tbcDWcvcjIPI+X97Mn/VCPiQ0EgOErsvmnsgbiJu7nq5qXyvzvuMi555FfHaKoFMtuSMs2QTjyF6YWOBevWc4/O+CP2uMyAt/ad2mNP/icylcttkcz1ceeINZxREJ
 MsSU8zyE
 eWX+u4H79GJ+UydO8irXkEF5EPu2IpXpt5fX89kijeQhil43wVBbl4kU2SC12q7bxzYbzhs8vIsfC1d5t9RNjdj+sE96zDOCZbm08eps87WIKibB9jh074pB1icSXNBNP0sYE00DUZDDw+o1bexJhdjXv8HaMZmWm9TE5vcVBqpXHVKqU147eKCBadEDQnsqOVPuWNRMsfTIIRt1fosljT/mdTExSlRLBgztXv8qRrEhtY1I7RWJBqv0TaIAPuXvMr4Au9Qpk97wRHSjFYij5lcjBZrIImBuudeIRMDS9vntx/esY4+1xGJj5ve60ibn+K6bSmUXM47QRxePbiszidHSOYiFdOHU9S+BnztvExmyd797c3jPYtScPREp6Tb68G/KwycxbPV8FrE1ClBjbRtN17MpcQLH/8vbK1GmTEmDbpmSGHakw6CQAG24UhK0KtRYhS/xlG0+cdmHtgq4xecoI/cCVYKOE+tEqZRd2ivZP4WtPfAXTInwI1JqJhCv8M5ena/cApl2DF2Fd3SnHFq3C8Z8LQ03UeAxc+Zk58CJkM+Dqf8efvF0w3fuPx7Q7cERaOrE+cU9pZF3YAsfkW/BTgDyWxBoAJ3WaJ108N/Gg3yM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/08/2025 04:08, Yafang Shao wrote:
>> Hi Yafang,
>>
>> From the coverletter, one of the potential usecases you are trying to solve for is if global policy
>> is "never", but the workload want THPs (either always or on madvise basis). But over here,
>> MMF_VM_HUGEPAGE will never be set so in that case mm_flags_test(MMF_VM_HUGEPAGE, oldmm) will
>> always evaluate to false and the get_sugested_order call doesnt matter?
> 
> See the replyment in another thread.
> 
>>
>>
>>
>>>               __khugepaged_enter(mm);
>>>  }
>>>
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index 4108bcd96784..d10089e3f181 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -924,6 +924,18 @@ config NO_PAGE_MAPCOUNT
>>>
>>>         EXPERIMENTAL because the impact of some changes is still unclear.
>>>
>>> +config EXPERIMENTAL_BPF_ORDER_SELECTION
>>> +     bool "BPF-based THP order selection (EXPERIMENTAL)"
>>> +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
>>> +
>>> +     help
>>> +       Enable dynamic THP order selection using BPF programs. This
>>> +       experimental feature allows custom BPF logic to determine optimal
>>> +       transparent hugepage allocation sizes at runtime.
>>> +
>>> +       Warning: This feature is unstable and may change in future kernel
>>> +       versions.
>>> +
>>
>>
>> I know there was a discussion on this earlier, but my opinion is that putting all of this
>> as experiment with warnings is not great. No one will be able to deploy this in production
>> if its going to be removed, and I believe thats where the real usage is.
> 
> See the replyment in another thread.
> 
>>
>>>  endif # TRANSPARENT_HUGEPAGE
>>>
>>>  # simple helper to make the code a bit easier to read
>>> diff --git a/mm/Makefile b/mm/Makefile
>>> index ef54aa615d9d..cb55d1509be1 100644
>>> --- a/mm/Makefile
>>> +++ b/mm/Makefile
>>> @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
>>>  obj-$(CONFIG_NUMA) += memory-tiers.o
>>>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>>>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>>> +obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) += bpf_thp.o
>>>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
>>>  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>>>  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>>> diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
>>> new file mode 100644
>>> index 000000000000..2b03539452d1
>>> --- /dev/null
>>> +++ b/mm/bpf_thp.c
>>> @@ -0,0 +1,186 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/huge_mm.h>
>>> +#include <linux/khugepaged.h>
>>> +
>>> +struct bpf_thp_ops {
>>> +     /**
>>> +      * @get_suggested_order: Get the suggested THP orders for allocation
>>> +      * @mm: mm_struct associated with the THP allocation
>>> +      * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
>>> +      *                 When NULL, the decision should be based on @mm (i.e., when
>>> +      *                 triggered from an mm-scope hook rather than a VMA-specific
>>> +      *                 context).
>>> +      *                 Must belong to @mm (guaranteed by the caller).
>>> +      * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
>>> +      * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
>>> +      * @orders: Bitmask of requested THP orders for this allocation
>>> +      *          - PMD-mapped allocation if PMD_ORDER is set
>>> +      *          - mTHP allocation otherwise
>>> +      *
>>> +      * Rerurn: Bitmask of suggested THP orders for allocation. The highest
>>> +      *         suggested order will not exceed the highest requested order
>>> +      *         in @orders.
>>
>> If we want to make this generic enough so that it doesnt change, should we allow suggested order to
>> exceed highest requested order?
> 
> The maximum requested order is determined by the callsite. For example:
> - PMD-mapped THP uses PMD_ORDER
> - mTHP uses (PMD_ORDER - 1)
> 
> We must respect this upper bound to avoid undefined behavior.

Ack, makes sense.
> 
>>
>>> +      */
>>> +     int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>>> +                                u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;
>>> +};
>>> +
>>> +static struct bpf_thp_ops bpf_thp;
>>> +static DEFINE_SPINLOCK(thp_ops_lock);
>>> +
>>> +int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>>> +                     u64 vma_flags, enum tva_type tva_flags, int orders)
>>> +{
>>> +     int (*bpf_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>>> +                                u64 vma_flags, enum tva_type tva_flags, int orders);
>>> +     int suggested_orders = orders;
>>> +
>>> +     /* No BPF program is attached */
>>> +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>>> +                   &transparent_hugepage_flags))
>>> +             return suggested_orders;
>>> +
>>> +     rcu_read_lock();
>>> +     bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
>>> +     if (!bpf_suggested_order)
>>> +             goto out;
>>
>>
>> My rcu API knowledge is not the best, but maybe we could do:
>>
>> if (!rcu_access_pointer(bpf_thp.get_suggested_order))
>>         return suggested_orders;
>>
> 
> There might be a race here.  The current rcu_access_pointer() check
> occurs outside the RCU read-side critical section, meaning the
> protected pointer could be freed between the check and use.
> Therefore, we must perform the NULL check within the RCU read critical
> section when dereferencing the pointer:
> 

Ack, makes sense.


