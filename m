Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE6BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3E08E000A; Mon, 22 Sep 2025 08:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ACE8E0001; Mon, 22 Sep 2025 08:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162448E000A; Mon, 22 Sep 2025 08:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 031C78E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:46:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2D5113B8E8
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:46:53 +0000 (UTC)
X-FDA: 83916860706.24.2D99D83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42F1E120007
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:46:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6imtOKD;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758545211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mv13huhT0gqfkBDZT0hXlMvGHFMtcIbajQQZdQ6vz48=;
	b=1SBwVHYDfA39qheIB7YURtxx8vG0LW7dHZVt5KNhl71RMFPVFpUaluptErRahO8LGdEvHv
	AQP4Q/7xNJlYCyusiuLini5PsM36/WUAFo0c2TqR5DD/1fraG1izx1bcdrSjLJ1bbD5ank
	xKncT0tyVBs00stutirvEuzmImH53LI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6imtOKD;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758545211; a=rsa-sha256;
	cv=none;
	b=U1DgBOh3OPpLhOzHoFDW62YRPW6MrPhYBNby0fDJUvIA5DUVvYhB0NQgtMyZL5QvctBmNp
	YWoaTeuGDhrEJ8esaMrrpNxJmfYi7bc6Z4LYDfOYamaZSgF/VfMZr01mQ/MDM/MBtYO7H8
	mcO2uVy1o41beU/c/iahKgeUMZNfHgs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758545210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Mv13huhT0gqfkBDZT0hXlMvGHFMtcIbajQQZdQ6vz48=;
	b=Q6imtOKDA1DfG7h+4nT6VPYILwyNIn75Ve58ttwb36xxllHEliRcE1RWzZuNwxw3ggDJC2
	QvX8IHQiK3LplPWeawaLk228jsm4G7JEfvoAr5kSYw3wHYIZT3DB6cQ3FlK/TfmqhZaaM0
	Rw5Gn4wzXQ+2DUR23ZmwSlEoNBfE1qg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-oPzE3nhAOT6Tndqv-ggAqA-1; Mon, 22 Sep 2025 08:46:47 -0400
X-MC-Unique: oPzE3nhAOT6Tndqv-ggAqA-1
X-Mimecast-MFC-AGG-ID: oPzE3nhAOT6Tndqv-ggAqA_1758545206
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46d46692831so4802995e9.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758545206; x=1759150006;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mv13huhT0gqfkBDZT0hXlMvGHFMtcIbajQQZdQ6vz48=;
        b=M6GEVY/AWBwzNvNjsJmnLODSpFDQ6xbNJmRQ/VGi8X9jPIqKpvBlwR+w6+jWBB7asX
         nTWpE+2AVqsDDZzUhAGf1egzhlpoSenKGprXyLJtzamEp1CDUEpQpUCWq7JV0grP9Oxc
         V+k22KaX5h0GO7qLdyRbLYlpnP4LgzHW3WwfeyEMtfuPJaCzTfN4FAHk2pOmu+5+5lDH
         AhaVkhPXkOXd/KoW1NnqILTzLQyqdRzyUpIsma89wBa0CrERV+QJyAA7pWOx0DvcIoaL
         w25ANIeOTRBml1uhmt064w3poA9yURB78MqgCDrcs5ZMHEp1UjZHHd3EKP8jNegWGCBh
         YHJA==
X-Forwarded-Encrypted: i=1; AJvYcCXWj3XaC6FBToaxXKvGz6UtbQuMEHdICNNoWndf6a35hJ7xwr6/P89IKoPjdKIHKvpEl3rQMIA0vw==@kvack.org
X-Gm-Message-State: AOJu0YzvL0YoxnYWi+0i/yXuY68dOAkMRAXBneVSux6FuITScRGLYEra
	cSOLealFTPSt4RN5fSH8E79GIp8dbchocXA3aDPI3WB7RgzNZ42LOs3cPq9YI5UBCRPm0sA6oVr
	GCQorIkcmdUXW2V0SKThSevY9wiOuh2iZj9i3LkSibFVi0S12qoLN
X-Gm-Gg: ASbGncuYXd0wWGvOS1zn/ZNHecySGk8/CLnW+efaIrYY4VKltOa853o03S3sOn5dZqL
	HCO099thgZvxiQHf0lR+JFUFa75UQGRF5Clbb9yW/t63ZvVD2SqTNVnVaI4ORA6fP7a74Li8IDO
	NTF4/7XCmjVlGhImoSNlS70byA3XJcnr0s9hOLhE6CtjjMMU+YXL7u0eWEjoLW7+JS2T1bhqLUE
	HYZpQjQ8Mp60FRCrT/3Zcppr/ZGxHVt/C3MiC1Aer+Zd/eQB/gdttACEbRGulx2VuhHSTuVKia2
	vMZlc+qbhsXmpuIn72r8VTJHXFh96Rrb5dqM7U37ee4AKHt+IjDN3Fjrcg8Q1aLnNjTO3SGXimV
	Ikd5sJNZ4AEhtgcPQLJUbvxlyqrqnGePzoOY+06sEClkPOoVnyaVRzrdknvc4IWA=
X-Received: by 2002:a05:600c:1d1b:b0:46d:996b:828c with SMTP id 5b1f17b1804b1-46d996b8a1cmr27602085e9.10.1758545206006;
        Mon, 22 Sep 2025 05:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxdA8IYtBgItRbRxudMnIH8eEFMOAJ7pRm6IRhcDJcEGS3N2hn+i06fgbwEoEqPhQRHhAN3w==
X-Received: by 2002:a05:600c:1d1b:b0:46d:996b:828c with SMTP id 5b1f17b1804b1-46d996b8a1cmr27601765e9.10.1758545205552;
        Mon, 22 Sep 2025 05:46:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46da6900832sm14460365e9.0.2025.09.22.05.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 05:46:45 -0700 (PDT)
Message-ID: <8e8b4aa4-18b7-4928-a9f0-cd47a59258fc@redhat.com>
Date: Mon, 22 Sep 2025 14:46:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
To: Pedro Falcato <pfalcato@suse.de>
Cc: "wuyifeng (C)" <wuyifeng10@huawei.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
 <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
 <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iUmqd1EiBNKli4JD1UI5onODJsa6bEqGAh8BqeZWiDY_1758545206
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42F1E120007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qgmwdyj3754rowge1ccz9mp3qgn1cjfe
X-HE-Tag: 1758545211-936992
X-HE-Meta: U2FsdGVkX1/nLRrPZLWT6qLFj6UD5iB3CZDcihrR4nfEr7RWkLT9Vkw5LhoN88XDa/OnBEL3AbtyoYNTQ3FNbb+EyPisj+NTvJXnkHhOsw7+7RqE2C6cw5v2n0PT6Nzu6u01NfiXaYxSTBG9ZFb4DYmswYtlun2xyHNHq2FCHmunjbKvUZ/F/WoSzuh06eDwEoeaAfUw7FW4B0H6i1RCaKqQGOBiF3U0H2iHSACzVszDzLeQdaiOQ7lHfVoDdvXS66ykQltkDqYHkPqcVU/ctIzFLnkdcO+RpCe/slK1FGS2EcaeX1aMJifVrVLRidj/iIKq4I88T0ITP20GJxZxMJNfW7kO59SkTdOug7D2+LCU+JYPbOwsfblgLumosBLOLbgq3xVMsL29NAlZl2zhCaw5AHiBvxQqLdV6ssvNY6hQn1g94G4F05nnwSDGwYizZFA55bPgzSNW94C8Dxd/Nnrc3zdS6DIAuHmuFwnTZeriA9XozDHdLI/JVz0M5VVInQ/oNWN9/nwfERsoRMZRDmg+xEMcqOsa1SnNvkVOg9CajSGt2yDMof57m7BOiX2ePuXxXI1z44ShQx5n3udAqT97SRs06LO4gvWP52nq6vMHixta/LnPkvV6K/44mrqTzLKKtYfrVDv8A5mbTKLDjtpNTNZJ5PgajPTvtDph6gXukJZZbc45eKSoBxiA5l132FLBvp9LIh669dJDDAY9K3AXXQtDK8SD2975rFDlyspdCJCYL+yxmQJPMssvoMC/i6++Z8IrxDw2lmngGgOKeLrVaZKjZEq9e0YK0av2dbXKypNqNNW1T+91rBIg2q+YKFUMOnqthm3dSLnKoXXX5E5XVL44f+vT48+vVBydaVODP5XG7ZDm/p1aFezqF0L16ProxVHD8Er9wqjMJuesOmJ5DfJjOx0+HsCSoWPo5D7OhdI/lJTMNwdZmjhE//D33ei41UwK+GHmDGJ6oz4
 69SI5U3E
 iQXXt8RHwHNWvGRvO2IafwxP9EbvmSQSt4ANFBNlacScBD5a4kD6cTn/6MUtVogSiLCg4+KGhhrwXCAWIFYkyqzNsp4yx4R/MseMlIiU+eaTdj78CTKIpyXw/gpb21ESIZ/ppnH0HIcI2yLlUsohCyMhUJnnp38vxy73SE8jfylDf5fkLH4PkToW4R3YBCOFMaCAUjCC6pG304h0BK1PYPYzSgXmfDP6XAS7pOZy1zVMTXHbGTAjJQW//MBLQfv8lnpl0rLb0bZJfOsUUKCzyFfJAE01ZT/1qVKC6sUE5WQrT8tJGJ4SRMo48YhbtDQbbfZzd8rjhIAOF1W/smeroWjbcaG635KzRPVlIGYM3iVl5kwQ2AHPUHhpshJhZhswizzXbnWJ0E+q9LL99fpHTqk82E6LhJ5O85u6WWe3YiSZLEwzauw2+K9cp04U1gis0L0uq50Ts/R1MAtch3TOgS7Zooste43Hdk5csNxYESAwEHVcYjMsabo5L++eARIeBn+YluqQnfFavJUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 11:37, Pedro Falcato wrote:
> On Mon, Sep 22, 2025 at 11:07:43AM +0200, David Hildenbrand wrote:
>> On 22.09.25 10:45, Pedro Falcato wrote:
>>> On Mon, Sep 22, 2025 at 02:19:51PM +0800, wuyifeng (C) wrote:
>>>> Hi all, While reviewing the memory management code, I noticed a
>>>> potential inefficiency related to MAP_POPULATE used on writable
>>>> anonymous mappings.I verified the behavior on the mainline kernel
>>>> and wanted to share it for discussion.
>>>>
>>>> Test Environment:
>>>> Kernel version: 6.17.0-rc4-00083-gb9a10f876409
>>>> Architecture: aarch64
>>>>
>>>> Background:
>>>> For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
>>>> is intended to pre-fault pages, so that subsequent accesses do not
>>>> trigger page faults. However,I observed that when MAP_POPULATE is used
>>>> on writable anonymous mappings, all pre-faulted pages are immediately
>>>> marked as dirty, even though the user program has not written to them.
>>>>
>>>> Minimal Reproduction:
>>>>
>>>> #define _GNU_SOURCE
>>>> #include <sys/mman.h>
>>>> #include <unistd.h>
>>>> #include <stdio.h>
>>>>
>>>> int main() {
>>>>       size_t len = 100*1024*1024; // 100MB
>>>>       void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>>>>                      MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>>>>       if (p == MAP_FAILED) {
>>>>           perror("mmap");
>>>>           return 1;
>>>>       }
>>>>       pause();
>>>>       return 0;
>>>> }
>>>>
>>>> Observed Output (/proc/<pid>/smaps):
>>>> ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
>>>> Size:             102400 kB
>>>> KernelPageSize:        4 kB
>>>> MMUPageSize:           4 kB
>>>> Rss:              102400 kB
>>>> Pss:              102400 kB
>>>> Pss_Dirty:        102400 kB
>>>> Shared_Clean:          0 kB
>>>> Shared_Dirty:          0 kB
>>>> Private_Clean:         0 kB
>>>> Private_Dirty:    102400 kB
>>>> Referenced:       102400 kB
>>>> Anonymous:        102400 kB
>>>> KSM:                   0 kB
>>>> LazyFree:              0 kB
>>>> AnonHugePages:    102400 kB
>>>> ShmemPmdMapped:        0 kB
>>>> FilePmdMapped:         0 kB
>>>> Shared_Hugetlb:        0 kB
>>>> Private_Hugetlb:       0 kB
>>>> Swap:                  0 kB
>>>> SwapPss:               0 kB
>>>> Locked:                0 kB
>>>> THPeligible:           1
>>>> VmFlags: rd wr mr mw me ac
>>>>
>>>> Code Path Analysis:
>>>> The behavior can be traced through the following kernel code path:
>>>> populate_vma_page_range() is invoked to pre-fault pages for the VMA.
>>>> Inside it:
>>>>
>>>> if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
>>>>           gup_flags |= FOLL_WRITE;
>>>>
>>>> This sets FOLL_WRITE for writable anonymous VMAs.
>>>>
>>>> Later, in faultin_page():
>>>>
>>>> if (*flags & FOLL_WRITE)
>>>>           fault_flags |= FAULT_FLAG_WRITE;
>>>>
>>>> This effectively marks the page fault as a write.
>>>> Finally, in do_anonymous_page():
>>>>
>>>> if (vma->vm_flags & VM_WRITE)
>>>>           entry = pte_mkwrite(pte_mkdirty(entry), vma);
>>>>
>>>> Here, the PTE is updated to writable and immediately marked dirty.
>>>> As a result, all pre-faulted pages are marked dirty, even though the
>>>> user program has not performed any writes.
>>>> For large anonymous mappings, this can trigger unnecessary swap-out
>>>> writebacks, generating avoidable I/O.
>>>>
>>>> Discussion:
>>>> Would it be possible to optimize this behavior: for example, by
>>>> populate pte as writable, but deferring the dirty bit until the user
>>>> actually writes to the page?
>>>
>>> How would we know if the user wrote to the page, since we marked it writeable?
>>
>> On access, either HW sets the dirty bit if it supports it, or we get another
>> fault and set the dirty bit manually.
>>
>> What happens on architectures where the HW doesn't support setting the dirty
>> bit is that performing a pte_mkwrite() checks whether the pte is dirty. If
>> it's not dirty the HW write bit will not be set and instead the next
>> pte_mkdirty() will set the actual HW write bit.
>>
>> See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or
>> arch/s390/include/asm/pgtable.h
>>
>> Of course, setting the dirty bit either way on later access comes with a
>> price.
> 
> Ah, yes, the details were a little fuzzy in my head, thanks.
> I'm trying to swap in (ha!) the details again. We still proactively mark anon
> folios dirty anyway for $reasons, so optimizing it might be difficult? Not sure
> if it is _worth_ optimizing for anyway.

I remembered the same thing (proactively mark anon folios dirty) but I 
didn't easily spot it in the code. Did you spot it?

I only found the folio_mark_dirty() calls when unmapping anon pages and 
we stumble over a dirty pte.

-- 
Cheers

David / dhildenb


