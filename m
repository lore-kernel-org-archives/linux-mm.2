Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A60CCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7603D80175; Tue, 28 Oct 2025 12:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711088013F; Tue, 28 Oct 2025 12:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEFA80175; Tue, 28 Oct 2025 12:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516C98013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:14:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DCC348B48
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:14:01 +0000 (UTC)
X-FDA: 84048019482.05.9911906
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7D80D18000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:13:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LVD+P2iG;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668038; a=rsa-sha256;
	cv=none;
	b=g3q+6u3BSw1ADIesE1UZPcpAxOYuQXjbOfZxIld9xy7V3Vlbsw3LO77wdLiYWhkSMXamlV
	fSio2DVhSw9iFdHuWHu9cgz7GgdwyPLiZqNOQ7N7HFnqhoqRwgd7eeONOwKdor4IY5jJZ6
	PwGHiQZqn8Hs27IuXrcSL/0bksy1Mkw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LVD+P2iG;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvvpFK250LHbofQ0y9+Mb287YMhgXcSSFNTTgJ2zzcM=;
	b=txii0vWloIOUpSQZxkYdXNz3C9vzl85AuKFGrcJVyFWK1kM5qcUOmke67HuUVa2GqS8TE+
	3zvtIEQz97SHKOqQ7uduNyKak458of5e1itxer/4XsH26I6OA7fWGoNP42rv9M+klymPES
	XLAGeUsI6TwBvsl2h+/luZ6m5JfEdMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761668037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KvvpFK250LHbofQ0y9+Mb287YMhgXcSSFNTTgJ2zzcM=;
	b=LVD+P2iGhXC0dpgA73KIxOJm4B6LhpDBDvvw+ZMSpn7Nc8jBTvpyLa/lrcAIplHR36Lmnr
	IT/CW2ytQ4uU0sjhx+bZtASBN6RbtlnPiJDMCFVpEFhImt7p18CD60BMUuWdBy9cSvH+h7
	lh7ysnsoGExwwYU+HV89yEU/ElWeA/c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-WzzhBuypN2SIojpw69oJVQ-1; Tue, 28 Oct 2025 12:13:52 -0400
X-MC-Unique: WzzhBuypN2SIojpw69oJVQ-1
X-Mimecast-MFC-AGG-ID: WzzhBuypN2SIojpw69oJVQ_1761668031
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475dabb63f2so15460575e9.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761668031; x=1762272831;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KvvpFK250LHbofQ0y9+Mb287YMhgXcSSFNTTgJ2zzcM=;
        b=VU96aviFC4GgI+JVLwlc0fVIMLhqUawqowu7rdRJfM9sVnB1GXvc02SG/YpslfrwEC
         Vnm5dsKJEbmXQKm5Wv7cyixIDcs79awEAe0d0yTXHVnuoEbNQHloCYB0Tg1ya8dAkkGn
         WrwWEuBQU8Gc6s4S8WMgzI8BCKi0fMQaNaePQ2ryDYiZJi7ToJEa/hWyMc80VnG/CUYd
         fohQGNjjm+Nuh18TLkvhjHCS8BKb0xxXc8Rp1rja3U7/pQG2T0MPvgQrJ3IqcXyXS1o3
         UgtjIUXg4GyP9TpXIRqR2P/nOcKnmO+4AIPkOCVovpAdSmPnAVVAYsrHbEUwWa9fxf8Y
         MYBA==
X-Forwarded-Encrypted: i=1; AJvYcCWO7KgVqSlcwlcjOPFp1+m3W6qYtFMPBBVnsBuOjyfB0kYZYhq9qYRWosDOrJAUw3hOvK8/oXSDYg==@kvack.org
X-Gm-Message-State: AOJu0YzKIoNh+ymRN5xIOrNAycnDTVWdGmPume8vDP4vlvmwYUbAvjgf
	UElRgC8o9Nw0MDhcHcqOXnkZqnmaje2Rjct4JSlWEa1GLu73TzcQUFSvMhVru+LqV8SxHCk56pM
	PuY4CMUD0mUKpb3VBI1efRY5C+UTXtthK4I+Gu0is3xxeVSRDaYgJ
X-Gm-Gg: ASbGncugG9Pwu+RFdbVEi1Aaw/TScWxBajCI0nZTr9+pZ0C9GzOkyuTrNR62xRx4vR6
	NQR/LXXVUV31Kkb6Wj40/cnKGlfWGiGo98MP35y1Y3BC5P70BJY2uLPbCvmGz+3M0O+AajObmbK
	lKr5+qTvyEWFXiuve/cQ+qsMhToDPp6ZbKjy8nS7Sr5m+vywIzrKe44EX9AL0JOz9yxtQR3qgIj
	lMJOKLYTEFHxEXc70ndcFtVlJ/ZoSs8rI6mJycfnuY+mWqTeIIxi/Ele4gU87FIMRr4WY4Bewzv
	p8isiMG13hqxRlD4oGzcYGrkY6vzWTR9qE9RjrBoFSOdKg4F/1LNCwmaklayj1k9aTz8UDCYtIb
	EOaXMxCD1U7UXSUCgeGdRGYEoZTIm22tz
X-Received: by 2002:a05:600c:3b27:b0:475:da13:2575 with SMTP id 5b1f17b1804b1-4771e1ab8a0mr264315e9.35.1761668031172;
        Tue, 28 Oct 2025 09:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYLMRn+FNd6v1pe6gevrEN6O2ueeH/AKghCdZ+vk7Py4/AlR9hq5U2B0FyPXLgVOsHfXK9hw==
X-Received: by 2002:a05:600c:3b27:b0:475:da13:2575 with SMTP id 5b1f17b1804b1-4771e1ab8a0mr264115e9.35.1761668030728;
        Tue, 28 Oct 2025 09:13:50 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db80fsm20703850f8f.31.2025.10.28.09.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 09:13:50 -0700 (PDT)
Message-ID: <c1c9aedf-fb1b-47c8-8204-dbc28e9da4f3@redhat.com>
Date: Tue, 28 Oct 2025 17:13:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: fix HVO crash on s390
To: Joao Martins <joao.m.martins@oracle.com>,
 Luiz Capitulino <luizcap@redhat.com>
Cc: osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 hca@linux.ibm.com, borntraeger@linux.ibm.com, mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
References: <20251028153930.37107-1-luizcap@redhat.com>
 <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 39ud8EnT6U0y74kSWtVUwaDg63I1Y5tWeM9vMphmyds_1761668031
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 86hmk6x3y4g61j7dy6pwtnzxfwu1q911
X-Rspamd-Queue-Id: 7D80D18000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761668038-991955
X-HE-Meta: U2FsdGVkX1+lS+A0O0ibCqkIvZDh+gm8PUt5cTQtw2w50EGm+r69RBPS5QmzBhHPtSDl7xgL4hyodSPsqRSwW+w/hxcH9zE8Bpyfd/z3QUKk+y6FCL+9Vw7FJI48tiur/7z0e7EfqT4TyoDlHrM4cs1HKPzCDDIsEZP3JhKAuIVOspoqk0PrhxFckgoBoxDKwUYQOdUFVXqnFVwLIdB4vaQQFEmQU4geCLCWqVEic4fhib/Uh2CAN7/yPgPXMjyuY7JF15BgDBF7QLn/ZLG8RtX3uSMfJaR7i98gKTY6uldByrsfS1+upUEdODQOsYvuhwBeXweg4V1nGyIrGg7ksVgZTYVkfgR24HgU0FGTJ0uk5vD63fgevDmGtK6yR+uxpNskoK/gnquLokVclzYvOQrBDh329WRWVoP9ZKJEau9kDCNNLk19Qp7J0hqrMgbEvU52Yj2b+y2UaawQnwNIhWtfH/Xg1JjORw1fJ8UabzufhdrGDeuIuaC51OsXEqQnam1xKC/NSAy5K5qnVFEx/O1tz7hbB/4SSuodfvZwcY7YK4GP2Vl7Cc3jc+YyUToOKweKw5x496nlgTh/tQPUizOyOpZHvNdLdgFy7dEVuXEohvlfl0ygAq9Sc9XvmB9ZJ1DAG6nQurBhduYy207e+hxf04TLr9Ur+kJstHPlOAPUCyeQC5LXACPARQynShMGxeGSQeAm/LbmqH4O2I3dbz3TAky09yp84F7g9XlTsflSE2fMyEA/TJaPLKliYqVGyQQsrdDvM9d/F5Ihajp42TIM1CklPgvhsMlH1+VSNNlxZAUrwYbALluwKGRdt48ux3QjypZ3eJRERqj7xEjEn8EhFF/TR1SUewvYsuKi8/FLSJht9RTnF6tBgBDlLmFgtEaEnL1g7U+WOm1qup3y67PxdsUKOWHLxyD15QyaEP98FjIiX9f8gONgw4wg4EK1lt803v3h0HjFZXqKLhz
 NMticnTJ
 Qgd2FCw06O3o0Ivwxwg/xQw6ksFLMHugvYXyEzCYCxqlHzsKMur0XKtuHGxysIj9T2NaE7v6jxEjgBgUWmkX1x8YK2AU1b7TEIM6ECIeXdpoicD6MGJohS1BoIDijUwEijazL37fprbhzFqG6t9inCk0vkn7JICjesEMm4Tq6C0BvhlbEySWsdKBAy9u3b5Urg8hqLCLmBFThmgdr1RYmOv49IodjfWNCaawtVbivqgFAmV0o7U1+2nbkxFytqHYQwRPUl8xxbg0k8YL90p9VmOuDS++Mq9ElwlCJu1SyGeXRsZI7nan/5npYXBsmH8ne12Hf6FF5RdLEmyyJ1OQ48+InJ0PkNdU5y1eOo6nGx3sqiTyIswdqmOfs8GWMXprwXNFFgu9U1AOJyrEb4IkvDX7X0o4pulHZP6D2yinRrEwffakfoCbFcpcLRUNhwsRO7xJlcYyOhn+awBMLTSsB7uMz82kklnWd8QbNhx/2Y9rdiSjxVuCgrFf9n9lRt8g8nzNe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 17:05, Joao Martins wrote:
> On 28/10/2025 15:39, Luiz Capitulino wrote:
>> A reproducible crash occurs when enabling HVO on s390. The crash and the
>> proposed fix were worked on an s390 KVM guest running on an older
>> hypervisor, as I don't have access to an LPAR. However, the same
>> issue should occur on bare-metal.
>>
>> Reproducer (it may take a few runs to trigger):
>>
>>   # sysctl vm.hugetlb_optimize_vmemmap=1
>>   # echo 1 > /proc/sys/vm/nr_hugepages
>>   # echo 0 > /proc/sys/vm/nr_hugepages
>>
>> Crash log:
>>
>> [   52.340369] list_del corruption. prev->next should be 000000d382110008, but was 000000d7116d3880. (prev=000000d7116d3910)
>> [   52.340420] ------------[ cut here ]------------
>> [   52.340424] kernel BUG at lib/list_debug.c:62!
>> [   52.340566] monitor event: 0040 ilc:2 [#1]SMP
>> [   52.340573] Modules linked in: ctcm fsm qeth ccwgroup zfcp scsi_transport_fc qdio dasd_fba_mod dasd_eckd_mod dasd_mod xfs ghash_s390 prng des_s390 libdes sha3_512_s390 sha3_256_s390 virtio_net virtio_blk net_failover sha_common failover dm_mirror dm_region_hash dm_log dm_mod paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt pkey_pckmo pkey aes_s390
>> [   52.340606] CPU: 1 UID: 0 PID: 1672 Comm: root-rep2 Kdump: loaded Not tainted 6.18.0-rc3 #1 NONE
>> [   52.340610] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
>> [   52.340611] Krnl PSW : 0704c00180000000 0000015710cda7fe (__list_del_entry_valid_or_report+0xfe/0x128)
>> [   52.340619]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>> [   52.340622] Krnl GPRS: c0000000ffffefff 0000000100000027 000000000000006d 0000000000000000
>> [   52.340623]            000000d7116d35d8 000000d7116d35d0 0000000000000002 000000d7116d39b0
>> [   52.340625]            000000d7116d3880 000000d7116d3910 000000d7116d3910 000000d382110008
>> [   52.340626]            000003ffac1ccd08 000000d7116d39b0 0000015710cda7fa 000000d7116d37d0
>> [   52.340632] Krnl Code: 0000015710cda7ee: c020003e496f	larl	%r2,00000157114a3acc
>>             0000015710cda7f4: c0e5ffd5280e	brasl	%r14,000001571077f810
>>            #0000015710cda7fa: af000000		mc	0,0
>>            >0000015710cda7fe: b9040029		lgr	%r2,%r9
>>             0000015710cda802: c0e5ffe5e193	brasl	%r14,0000015710996b28
>>             0000015710cda808: e34090080004	lg	%r4,8(%r9)
>>             0000015710cda80e: b9040059		lgr	%r5,%r9
>>             0000015710cda812: b9040038		lgr	%r3,%r8
>> [   52.340643] Call Trace:
>> [   52.340645]  [<0000015710cda7fe>] __list_del_entry_valid_or_report+0xfe/0x128
>> [   52.340649] ([<0000015710cda7fa>] __list_del_entry_valid_or_report+0xfa/0x128)
>> [   52.340652]  [<0000015710a30b2e>] hugetlb_vmemmap_restore_folios+0x96/0x138
>> [   52.340655]  [<0000015710a268ac>] update_and_free_pages_bulk+0x64/0x150
>> [   52.340659]  [<0000015710a26f8a>] set_max_huge_pages+0x4ca/0x6f0
>> [   52.340662]  [<0000015710a273ba>] hugetlb_sysctl_handler_common+0xea/0x120
>> [   52.340665]  [<0000015710a27484>] hugetlb_sysctl_handler+0x44/0x50
>> [   52.340667]  [<0000015710b53ffa>] proc_sys_call_handler+0x17a/0x280
>> [   52.340672]  [<0000015710a90968>] vfs_write+0x2c8/0x3a0
>> [   52.340676]  [<0000015710a90bd2>] ksys_write+0x72/0x100
>> [   52.340679]  [<00000157111483a8>] __do_syscall+0x150/0x318
>> [   52.340682]  [<0000015711153a5e>] system_call+0x6e/0x90
>> [   52.340684] Last Breaking-Event-Address:
>> [   52.340684]  [<000001571077f85c>] _printk+0x4c/0x58
>> [   52.340690] Kernel panic - not syncing: Fatal exception: panic_on_oops
>>
>> This issue was introduced by commit f13b83fdd996 ("hugetlb: batch TLB
>> flushes when freeing vmemmap"). Before that change, the HVO
>> implementation called flush_tlb_kernel_range() each time a vmemmap
>> PMD split and remapping was performed. The mentioned commit changed this
>> to issue a few flush_tlb_all() calls after performing all remappings.
>>
>> However, on s390, flush_tlb_kernel_range() expands to
>> __tlb_flush_kernel() while flush_tlb_all() is not implemented. As a
>> result, we went from flushing the TLB for every remapping to no flushing
>> at all.
>>
>> This commit fixes this by introducing vmemmap_flush_tlb_all(), which
>> expands to __tlb_flush_kernel() on s390 and to flush_tlb_all() on other
>> archs.
>>
>> Fixes: f13b83fdd996 ("hugetlb: batch TLB flushes when freeing vmemmap")>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/hugetlb_vmemmap.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index ba0fb1b6a5a8..5819a3088850 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -48,6 +48,15 @@ struct vmemmap_remap_walk {
>>   	unsigned long		flags;
>>   };
>>   
>> +static inline void vmemmap_flush_tlb_all(void)
>> +{
>> +#ifdef CONFIG_S390
>> +	__tlb_flush_kernel();
>> +#else
>> +	flush_tlb_all();
>> +#endif
>> +}
>> +
> 
> Wouldn't a better fix be to implement flush_tlb_all() in
> s390/include/asm/tlbflush.h since that aliases to __tlb_flush_kernel()?

Agreed, that feels cleaner and avoids this ifdef here.

-- 
Cheers

David / dhildenb


