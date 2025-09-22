Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08CACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245758E0012; Mon, 22 Sep 2025 05:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6478E0011; Mon, 22 Sep 2025 05:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF208E0012; Mon, 22 Sep 2025 05:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8CC78E0011
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:00:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E2AF11A688
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:00:32 +0000 (UTC)
X-FDA: 83916290304.24.53BC63C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 10ED880006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:00:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIIWO2Oq;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758531630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rU/SEVuepvPKMkDh1FX/e5Es+tXVcPvnFUVwXgl5Yk4=;
	b=Bf/T/1fRJwaBMvMn6WmudVwKF/HHgwT1GRn2Z/mMQAUyCh1h90zFk3AAXw5NFtI1GGMWRu
	8O2KUPizbcYfTQECzx21j2bzQnB1nEA76/fr44TArei7W9JlZRFIQTYqEl6EkQV/aWp9K0
	6cScuh9/KVP2XRsIYgRDRnlktyJ366o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758531630; a=rsa-sha256;
	cv=none;
	b=l+LZup1sUt5m39OzMvrJeqEy7IXOPV7mhQ9xGyOiJQZqZUZ4RvRbX8Qp+C9tHNsnY3rR6Z
	ptfrw/XEVC2HrdWsAjdCpjoLpWafc0SkkWy5UsQmr3XPR+CIipsD7evrw4yBz0B1xnyXwN
	0J/wngQNMU8tBASXVLWdG46RfL7SZbY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIIWO2Oq;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758531629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rU/SEVuepvPKMkDh1FX/e5Es+tXVcPvnFUVwXgl5Yk4=;
	b=bIIWO2OqkUaTMrtMEJO6L54NyPzL4WwY3loceQj1/XdD6LMwzEdL9B6De35BFkk5bgcmvV
	VaJlfc513a1ddeCRGp/lecEzFCbN7F9VlFQkHrP3RHuMWNboX5E7XinIJpb2mxPl8U6/2B
	DmoppsUcojSY7QLJPM2/hrRZf7gC8Qw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-l8tfKnprMXiI1LlLLYzVJQ-1; Mon, 22 Sep 2025 05:00:26 -0400
X-MC-Unique: l8tfKnprMXiI1LlLLYzVJQ-1
X-Mimecast-MFC-AGG-ID: l8tfKnprMXiI1LlLLYzVJQ_1758531625
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e19ee1094so2130455e9.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758531625; x=1759136425;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rU/SEVuepvPKMkDh1FX/e5Es+tXVcPvnFUVwXgl5Yk4=;
        b=iSYu1Q3Zaa8BIipjHhOm072zko1HJ0vRKD+IYeZOALokQHvFLoObxA8UbmYomatVLz
         kjI4fPDP3cxNjWVhJkdp90K8p/9oQHmrAR7c3F8HRzbLpsoBMtCgqZaCMc1p/RueDmEU
         3ydZPWVFng8UpZSa752HfNyB/IqJ1Bgcudh3xOLZa8HF/5T7rjj5hxIWJT5fmXctYzUu
         KlOvdBTVjEYWdxPMvA6NW/CqjwHf3bOaoZUc89uiWQCmmJs9kYC6ynWPNNlWh025bGvs
         WbjTXSE5jSUKiCjKa/3+0rTQqjnjJV9f11+pfxpaPDExvJecOp9VsejmvET8VMk5nzjQ
         ZuvA==
X-Gm-Message-State: AOJu0YxQXlWQu8oZy8SWzWQk0I0cQeEjiGnH0adX0VjW4spZODeHEqTy
	o4gfulm4GVXnPecwwgSpEZIwzZFBzdYNTIoP4JoGacpbDbG/QBcmdl+/d7Bd51UcOKuJtL9TgNB
	ZIcWrsQjNVgZ4xNvyK/hwXxgKYvJaJwKLylZlaXj3w7M9XnFqV76S
X-Gm-Gg: ASbGncv3W6viywOGY0aHzvUoJ4pZiQtWbnsdCYP1JvVl1Tj1L30Ta61YFuIsQ7n9Nbt
	qlaARDT0nS0BDAS2wjmj/dgtHzXvWVy62SaHN6onv/au4Y3F2D4TMpFQbvI0BesRAQPpPXDNR9C
	/gtyFu8mhFIo6mXkVlvRAxBdxAmKjoT3gKVQZd7+hIpCJmlTb6sWrNZ0a/CDTmJp4jLMy+Non/X
	uIKHDo5KNh1hOagkqdkw5YNGvhk7VbSca2fQSsX9zR+SScdbDkIRRDteZ2dlSvsi5pQ4X3mHL7a
	bGgEBB/SScTAQ7IbueRUWxblrDce3NA+W2QHBc1ux+EmbJIWr5YZjWP9cFmQOG3jZqcSyGB7srO
	4IlF42D5x6GsOIb4y6xXrIDwE7DLT394bvX2BIpJANTgswjWb7257pTzbqKFcZ+c=
X-Received: by 2002:a05:600c:8a0c:20b0:468:11af:77f7 with SMTP id 5b1f17b1804b1-46837c5b280mr105000885e9.16.1758531624535;
        Mon, 22 Sep 2025 02:00:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEprKsCMnU7a4w0iUlRQNBrjlwXYWiCed9Tn506IPdEiBUIJqJFqHVG/dHpAoAkii6kH7l+Tw==
X-Received: by 2002:a05:600c:8a0c:20b0:468:11af:77f7 with SMTP id 5b1f17b1804b1-46837c5b280mr105000345e9.16.1758531623948;
        Mon, 22 Sep 2025 02:00:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f0aac33esm196826465e9.4.2025.09.22.02.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:00:23 -0700 (PDT)
Message-ID: <696c74b1-269a-4dec-989d-5ea74b509f30@redhat.com>
Date: Mon, 22 Sep 2025 11:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
To: "wuyifeng (C)" <wuyifeng10@huawei.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jtZ3LLPrmf_xkHG-tiKqb6u3oTxqm60_Wupae78FdAY_1758531625
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10ED880006
X-Stat-Signature: eyqr48s6gnxkfa6nc44iu7f9rzbaknio
X-Rspam-User: 
X-HE-Tag: 1758531629-874096
X-HE-Meta: U2FsdGVkX18bUulveNh6tSWZor8+tbg/IEmhxLT1KWdcdJpuoNQEQRv3OuGrlv2VQ/CysMl5IiKxoJerzu5JskvxtIMFcxu8Su2hNLr8kYsWZXkto3MdC9WKiHAQqxpQvQkV+hZ85LkCmnLDXbWbT82Vvw94WHUxaZplhwguGSZ+7WBMdh2eKi6V+ypVf4O6jsJfCa4RtMrakzycYg1ULNqQqu3pDOjPuA1SE8z5tiAMgLN0Mrk9nGjjaoonoaPzSWhzPaOTTzfnqmdS+b62zYVYGxfT6vrllGGSd6N544uJxmVt1hO4zti02Mt4ET+ox0wUvXtoQJDbM7Op5m1HBUIMvcfQeB1cgaNmwELyLRkqGiPC57gH4jCsDn9leFP2iCgeekLJ53j5Vsuk5InpEa3BX9Fplh7LCDXdVlW5XAED7m6GkUNi0G7FTpk60rvIbY3vizwe9VNgAp23a1ErrHFgO2k0qpuOTgi8QU2n++b6YMOi57Bjjp+LbB1KToLrs1eEoc2mADIkPVMb+vqSXzHy4ZeO71pNKQvyE4GfSXR2HD0Unhy7kq2iXP42TV+H1/pj1tgTQ01VdPPWla58YJwP17O2CZ8O/uylClB0X2LNFD8oL4i4sJeOrxvt4tWd8/9wYeXREBlt/5ueWCdl6Rzl4sp4N/z812YwJZZxu0HIgjssXTs88PeKTmmTpYwXCaf0WttD3G8Lt+LJkV//Su1FdmGSPN1QdTg0mnkp1ztUOBRa/enBf7cDrgrYl6EqF/h4YpSf8pWmItiPZ2tLcVpcYi8k65SWMO3jps9Ijt5YBDW0R0qR3qHH/HdgGBQkno6KVdwQ7KAf2SIug09ghUSlLneNzO88IPWog+uwGg5YWBreUNsq4DyEA4CLf16o0gBn4DZbaGoH7MOEvjBJrNgK7udCCLCMuZGaKNezwedsREexSC3zcCDyNiBn0JspvtIiPkAULJ5XT4CXs0r
 dgVW5mql
 4K/v34jWGYzaOzkR3ss5Ol2G04UFEzH0PPdtuXdXslJAv25b3ExyQ8suo2rZR5z/SovetU3WZ9LMpvDhFDQZ8w8mtaIYsEKc0H7Wpn8R1mkw/XggTRmd8dyzbalWbXFtziUgJU5nPME5oL1VuqoXi4bvkMLU4Rjb0CHRSBqxPuU1c7Sk7Xx+MAcRGhq9dy3K3UsEvWi32SIr1DPMfc8/TCluY13PmM2iG1xx1BeSHN0G7nAX6vjE7wHWLS1LkqGL3hEivFVN7fyNyzgVStEqQF38crbmHVsCxOrXHnZ3khQtUGlPnyVf3d5ATOW+xRhLqaURsZv+uRyU2HViVyOLrICSEITS/7MYG10WGSHl6y2TQImaj7StaLsjrT18ySEkfs3wKPA8d81gxUiIYJVs4Azy3UIdVcGSskslVLQnmgtBphnzgNXxZt7DohRF7DhrxKqbWTATW57Dsexb/5J+BjbwQ4o/jaAKBZDA8CPd1uQuv0zPEsQdwCieRvxldzIoofLYCBpHCkyIo7ls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 08:19, wuyifeng (C) wrote:
> Hi all, While reviewing the memory management code, I noticed a
> potential inefficiency related to MAP_POPULATE used on writable
> anonymous mappings.I verified the behavior on the mainline kernel
> and wanted to share it for discussion.
> 
> Test Environment:
> Kernel version: 6.17.0-rc4-00083-gb9a10f876409
> Architecture: aarch64
> 
> Background:
> For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
> is intended to pre-fault pages, so that subsequent accesses do not
> trigger page faults. However,I observed that when MAP_POPULATE is used
> on writable anonymous mappings, all pre-faulted pages are immediately
> marked as dirty, even though the user program has not written to them.
> 
> Minimal Reproduction:
> 
> #define _GNU_SOURCE
> #include <sys/mman.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main() {
>      size_t len = 100*1024*1024; // 100MB
>      void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>      if (p == MAP_FAILED) {
>          perror("mmap");
>          return 1;
>      }
>      pause();
>      return 0;
> }
> 
> Observed Output (/proc/<pid>/smaps):
> ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
> Size:             102400 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Rss:              102400 kB
> Pss:              102400 kB
> Pss_Dirty:        102400 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:    102400 kB
> Referenced:       102400 kB
> Anonymous:        102400 kB
> KSM:                   0 kB
> LazyFree:              0 kB
> AnonHugePages:    102400 kB
> ShmemPmdMapped:        0 kB
> FilePmdMapped:         0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> Locked:                0 kB
> THPeligible:           1
> VmFlags: rd wr mr mw me ac
> 
> Code Path Analysis:
> The behavior can be traced through the following kernel code path:
> populate_vma_page_range() is invoked to pre-fault pages for the VMA.
> Inside it:
> 
> if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
>          gup_flags |= FOLL_WRITE;
> 
> This sets FOLL_WRITE for writable anonymous VMAs.
> 
> Later, in faultin_page():
> 
> if (*flags & FOLL_WRITE)
>          fault_flags |= FAULT_FLAG_WRITE;
> 
> This effectively marks the page fault as a write.
> Finally, in do_anonymous_page():
> 
> if (vma->vm_flags & VM_WRITE)
>          entry = pte_mkwrite(pte_mkdirty(entry), vma);
> 

Yes, as MAP_POPULATE ends up triggering ordinary write faults through 
GUP, this is expected.

For write faults it makes perfect sense to set the pte dirty as well: 
avoids the cost of setting the pte dirty immediately afterwards (either 
through another fault or through the hw).

MADV_POPULATE_WRITE has the same behavior, but it's even documented to 
behave like that: "Populate (prefault) page tables writable, faulting in 
all pages in the range just  as  if manually  writing  to  each each page;"

> Here, the PTE is updated to writable and immediately marked dirty.
> As a result, all pre-faulted pages are marked dirty, even though the
> user program has not performed any writes.
> For large anonymous mappings, this can trigger unnecessary swap-out
> writebacks, generating avoidable I/O.

Is this a theoretical issue? Applications are supposed to make use of 
that memory after all, and at that point, the folios will be dirty.

> 
> Discussion:
> Would it be possible to optimize this behavior: for example, by
> populate pte as writable, but deferring the dirty bit until the user
> actually writes to the page?

The only way I would see us changing that is by passing from GUP that 
this is not an ordinary write fault but a populate_write fault. We 
certainly don't want to affect other fault+GUP behavior where we can 
avoid the cost of setting the dirty bit immediately afterwards.

But then, it could be counter-productive for workloads that will just 
write to that memory (IOW, use it).

-- 
Cheers

David / dhildenb


