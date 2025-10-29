Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2125DCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 09:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6250B8E004B; Wed, 29 Oct 2025 05:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC8B8E0045; Wed, 29 Oct 2025 05:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4188E004B; Wed, 29 Oct 2025 05:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 360AE8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:57:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D634CBB736
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:57:23 +0000 (UTC)
X-FDA: 84050699166.02.4309282
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47097C0006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:57:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfW2UM64;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761731841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqgl0WoEbTgKKe2Gmw+CbLcc1Ynjine2xgmP5Tg3jQI=;
	b=TmCQZYdKTeLNuKSqcFDdgpXTG1IDOz2a05ideA7oJYIWvVtK0Ex3Gd7PiaRxGOLjqnDZC/
	nk7TzeyymX6Ch2Jl/vi1g8BQlAo6GTDU2m+F4dkHzICNcnuLgsmerPTPwZpN9iDaylgxbJ
	zlyrPcCn2GGsOghvCdfMfGufR3cQPiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761731841; a=rsa-sha256;
	cv=none;
	b=XsrGNuWrYNGUqnzG19oKXav7b5q0NPl2Pr6jldhPvp3LSrlQufCNVEzLipQdZbF59VxIEM
	kcqvKbG3gIbmboj1y7kXG57+vZ0sj7/fPioYdhwqNDyUkO30cY2ZSwcKZGdxheoQNDqAfV
	zXpO/o0Cmj6F3zeyA3smdZDi2fa/1GM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfW2UM64;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761731840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qqgl0WoEbTgKKe2Gmw+CbLcc1Ynjine2xgmP5Tg3jQI=;
	b=YfW2UM64wxSK1R0Wcz9n6lL2iJYnc8SfZinuUbfN9QKfzfrMDfcjSXNk69Ss8VpV8pmCRV
	sDqoDATH7xNvWBqsrALSPVxvinZwZgUKrQahjG31DwaKSyueaPisg3Pb0/2LYJwraRyGBz
	jkjTz97A+5NMVfC3qgZJLYi6g2iKUQI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-MpZ1YfKiOviHi_mr9Fkhqg-1; Wed, 29 Oct 2025 05:57:19 -0400
X-MC-Unique: MpZ1YfKiOviHi_mr9Fkhqg-1
X-Mimecast-MFC-AGG-ID: MpZ1YfKiOviHi_mr9Fkhqg_1761731838
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298da9fc21so2340657f8f.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761731838; x=1762336638;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qqgl0WoEbTgKKe2Gmw+CbLcc1Ynjine2xgmP5Tg3jQI=;
        b=q01GcilANYoMyBh1n64w3K8ui0u1XQ1q/4mX3SjdbYGMwIJ3AuVi0vUMeAWgUVRGf1
         mEJmcMKqJ+VEWCvU5wsymc95ptfIJlK1OJaUUoTjZTsknBEjIoqorwOjxim5UA40Bk8A
         ElEXL3pk1rT7dNvNIuktbTn4MjCiBy37tQtQei4YLpG2IvvxGl57w8ZtcL/iKCROrcyI
         xxeVJxJykytUy1aYLk1hlkjKiF48Tl2ciKF8+whlzAQWmh3Jfrp763pumtet3NjHd/FE
         144ravbFoY8iNtKUGQ4yI5ShjhPNgcUOIpVMC032EGwqLYXFgwUAfjWEAeacr+3i7roN
         CSSw==
X-Forwarded-Encrypted: i=1; AJvYcCUcm812tRe0JQ5/2tppCZuwySkx7LuzuQMaghsM5G9jJCWPq4ev7lHHQvYmAqlux4ONbm6trynevA==@kvack.org
X-Gm-Message-State: AOJu0YxSozh4h0+jCGe7xqkkdQeF2M7K1ZdZOHxXS19Tdg91zIrpq2vn
	JoQPOqnNvR35rjQyCGQpjpxzj1LnftIk5OAI0OGzG4JFMNHlIcPAm9IpUF057ykdjbn5Fz/XS/L
	dnjfLtTVL5/cvuQGLy+varSylBM19ZHAEpqYdkT7JxBEXH/xSKN7U
X-Gm-Gg: ASbGncvg1f/9TkqUYdy0HT95zI1TrEFih9xN0viIK4zjlEIo9/AgtUZcBl97wkPiysw
	YYnd8qbgiVIB1fHgWZ+JGJFi83BEJhANCTdFRH87ya/M5ST2tVgIppDH4HQWh7asbzFiXMaZvRN
	QBuKfdzV0QAm2otbNW3HHMeHLTMd/PLw7bfQmQJwuIwKF3w0c6LXL4PGYPIxGlA2XaTyWj6levD
	4VtQzU75+A++gu2iF5+SfE4P742m4u79QQH10ydQpWPfqD0Tvlvm/KDFXpEySLH5pR9j9dYauLX
	+UNfkIcCV5+uPG+/fIFbLand/0mDfacsB62I16BTaUTe+ZqDCNrKCHsuiYgPws855Lz74xXDOsg
	GmSQWHjKZSp5q8Z4iUopNhg==
X-Received: by 2002:a05:6000:4382:b0:3d1:8d1e:8e9 with SMTP id ffacd0b85a97d-429aefbdfe9mr1681127f8f.32.1761731837809;
        Wed, 29 Oct 2025 02:57:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExZbPXgteVglylVVAK83EpEE4FYesirV3Lvw5YT039orgd8FXfS/PEHBhcvC3TGm9e0tm7bw==
X-Received: by 2002:a05:6000:4382:b0:3d1:8d1e:8e9 with SMTP id ffacd0b85a97d-429aefbdfe9mr1681104f8f.32.1761731837363;
        Wed, 29 Oct 2025 02:57:17 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5768sm26116915f8f.24.2025.10.29.02.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 02:57:16 -0700 (PDT)
Message-ID: <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
Date: Wed, 29 Oct 2025 10:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
To: Luiz Capitulino <luizcap@redhat.com>, hca@linux.ibm.com,
 borntraeger@linux.ibm.com, joao.m.martins@oracle.com,
 mike.kravetz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, gor@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com
Cc: osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org
References: <20251028211533.47694-1-luizcap@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028211533.47694-1-luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8aVEdvII0sZTWQXsvu8_KvjMHNzj362PkSIsmG6vyio_1761731838
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: sraesti9x5cfdq9pfbhow3ppdufkhcpg
X-Rspam-User: 
X-Rspamd-Queue-Id: 47097C0006
X-HE-Tag: 1761731841-480065
X-HE-Meta: U2FsdGVkX1+pNV0LHzxkedl+m7lcmRseW+lavrXBikmlwLuzLhpgf8GZpn6bejVbyMLe/ROMlfla1FTmCi57s+j54r5WrbDen0zDIEZl0KuzOAa7jrx+iINIba5ny0s8HpBSiRm07LtHTEDI2WZ9j7dVZpkWEdI0LtRwy6FssC6W44c/RdKItz+hRzJKP1sJxwW2e7awDQDniOx3W8EkFA7IzyWUIXUl6o8qNFx4Km5JEJ8GP6lz3y4doERRPIZkutq428aS+onVfECeADAd1uiY4tkldebTrx/2h365McqQYVqkx1mvJhvpKy7rRK70kgKER5/+9RKLuJBsmpq95/VdRtny3gqeF+OmHBA61Mak0hUd1pTsxdy3RpH1GzLL3Xs5USDk9zYirWsPvUHitm/kb+MYRWfNgVWkeXfQkuz/m84pU+bpvFcSr9OEMLBnjUNBIMMiOLwvS5YQIBOlOB8Fxa6j7rFBhpdFTO9X8xuZgMVh4xatBT0kp/nZUxg5cXLZP5uZj4iJcAVlAZ3CvByM4QBg7LeQ1u1LdFDnjF1tViEWk8f4oILKHyhmZ5SVW2ax5Pbzw9Lo3xdp3kxDY3H18hLlB2nZyhyGMclgl7aaJvXVoh63X7+va514HNLepy9uHU4Acfp80yGWczcFfBKuCRBFDLJhkgu5wgpZNl5CbuYwD4bizCMmGBF7j0hEE283M+etzGiz87mgBeXrMC19+5Rmi9vFyx7NcvpyytZZEQ6UVSjdoeQGRcWqW/MP1nDYkdR+UIV2/sFF/fgYrYhEpaEfRJ7c/ZeEwDR99rTQusdOHTldctU3kAQTnczjH88Sd9D5mnJgLq7C5J+EGgcTqWphRRpYcXmD461DnDjURQW+lBGPEQOE4Ff86kVJUB+FtWXEGe4EN5J0paU6dwjcJjAvULBC6Fa4l6Ky1hxDH76aYXSNPcRxoEZ4FNHIRD+mAvcuaxFIiJsJTUB
 KxlFdWCZ
 JEXcYo8pe/mfxIUzLW4QR+cmDcENUpgTVvxUcFnkVEocADbWSPZwEqGyD1mbQ5eDsnzhlLhe0e8ga/zKHmvOMK145UO4E+sJKoLsfwuCcSqZxvf5s4zpt2n5nljQE7ngEbNdLbkRnK0OUoz4Vne340AVljm3sKcIJm0aB1w2wwEfUYwJNysjzZDT8urnIGyo6YE1VxcWVEp0D6Qa4MrLtizATm9LIF9sUV3UuLmFJJSpal2RF+7kd/s1X00RofvKULkJoli9TvaPYLM5HEHguHyYAefJKygnruIpUrZK8OA5uwdZcOUmMMJjAEDvJaLqQfmU2d1yETZ0LNbEy7GW4mw79H6vl9SuIPtCLtXMsQ3L1ikPkpPvBcrpN4ig4PPwCDtIGF3go8poMw54lBNDBQTv87iPpMvt2LnI4/HfLGNLBdNfLWMZbecCqo3NQ43+R9HkTe3/+O/B4Nvt8U6oYlIs6rch0yX7rH+nFuUIYi/Khv/j1VDQj08cITA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 22:15, Luiz Capitulino wrote:
> A reproducible crash occurs when enabling HugeTLB vmemmap optimization (HVO)
> on s390. The crash and the proposed fix were worked on an s390 KVM guest
> running on an older hypervisor, as I don't have access to an LPAR. However,
> the same issue should occur on bare-metal.
> 
> Reproducer (it may take a few runs to trigger):
> 
>   # sysctl vm.hugetlb_optimize_vmemmap=1
>   # echo 1 > /proc/sys/vm/nr_hugepages
>   # echo 0 > /proc/sys/vm/nr_hugepages
> 
> Crash log:
> 
> [   52.340369] list_del corruption. prev->next should be 000000d382110008, but was 000000d7116d3880. (prev=000000d7116d3910)
> [   52.340420] ------------[ cut here ]------------
> [   52.340424] kernel BUG at lib/list_debug.c:62!
> [   52.340566] monitor event: 0040 ilc:2 [#1]SMP
> [   52.340573] Modules linked in: ctcm fsm qeth ccwgroup zfcp scsi_transport_fc qdio dasd_fba_mod dasd_eckd_mod dasd_mod xfs ghash_s390 prng des_s390 libdes sha3_512_s390 sha3_256_s390 virtio_net virtio_blk net_failover sha_common failover dm_mirror dm_region_hash dm_log dm_mod paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt pkey_pckmo pkey aes_s390
> [   52.340606] CPU: 1 UID: 0 PID: 1672 Comm: root-rep2 Kdump: loaded Not tainted 6.18.0-rc3 #1 NONE
> [   52.340610] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
> [   52.340611] Krnl PSW : 0704c00180000000 0000015710cda7fe (__list_del_entry_valid_or_report+0xfe/0x128)
> [   52.340619]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [   52.340622] Krnl GPRS: c0000000ffffefff 0000000100000027 000000000000006d 0000000000000000
> [   52.340623]            000000d7116d35d8 000000d7116d35d0 0000000000000002 000000d7116d39b0
> [   52.340625]            000000d7116d3880 000000d7116d3910 000000d7116d3910 000000d382110008
> [   52.340626]            000003ffac1ccd08 000000d7116d39b0 0000015710cda7fa 000000d7116d37d0
> [   52.340632] Krnl Code: 0000015710cda7ee: c020003e496f	larl	%r2,00000157114a3acc
>             0000015710cda7f4: c0e5ffd5280e	brasl	%r14,000001571077f810
>            #0000015710cda7fa: af000000		mc	0,0
>            >0000015710cda7fe: b9040029		lgr	%r2,%r9
>             0000015710cda802: c0e5ffe5e193	brasl	%r14,0000015710996b28
>             0000015710cda808: e34090080004	lg	%r4,8(%r9)
>             0000015710cda80e: b9040059		lgr	%r5,%r9
>             0000015710cda812: b9040038		lgr	%r3,%r8
> [   52.340643] Call Trace:
> [   52.340645]  [<0000015710cda7fe>] __list_del_entry_valid_or_report+0xfe/0x128
> [   52.340649] ([<0000015710cda7fa>] __list_del_entry_valid_or_report+0xfa/0x128)
> [   52.340652]  [<0000015710a30b2e>] hugetlb_vmemmap_restore_folios+0x96/0x138
> [   52.340655]  [<0000015710a268ac>] update_and_free_pages_bulk+0x64/0x150
> [   52.340659]  [<0000015710a26f8a>] set_max_huge_pages+0x4ca/0x6f0
> [   52.340662]  [<0000015710a273ba>] hugetlb_sysctl_handler_common+0xea/0x120
> [   52.340665]  [<0000015710a27484>] hugetlb_sysctl_handler+0x44/0x50
> [   52.340667]  [<0000015710b53ffa>] proc_sys_call_handler+0x17a/0x280
> [   52.340672]  [<0000015710a90968>] vfs_write+0x2c8/0x3a0
> [   52.340676]  [<0000015710a90bd2>] ksys_write+0x72/0x100
> [   52.340679]  [<00000157111483a8>] __do_syscall+0x150/0x318
> [   52.340682]  [<0000015711153a5e>] system_call+0x6e/0x90
> [   52.340684] Last Breaking-Event-Address:
> [   52.340684]  [<000001571077f85c>] _printk+0x4c/0x58
> [   52.340690] Kernel panic - not syncing: Fatal exception: panic_on_oops
> 
> This issue was introduced by commit f13b83fdd996 ("hugetlb: batch TLB
> flushes when freeing vmemmap"). Before that change, the HVO
> implementation called flush_tlb_kernel_range() each time a vmemmap
> PMD split and remapping was performed. The mentioned commit changed this
> to issue a few flush_tlb_all() calls after performing all remappings.
> 
> However, on s390, flush_tlb_kernel_range() expands to
> __tlb_flush_kernel() while flush_tlb_all() is not implemented. As a
> result, we went from flushing the TLB for every remapping to no flushing
> at all.
> 
> This commit fixes this by implementing flush_tlb_all() on s390 as an
> alias to __tlb_flush_global(). This should cause a flush on all TLB
> entries on all CPUs as expected by the flush_tlb_all() semantics.
> 
> Fixes: f13b83fdd996 ("hugetlb: batch TLB flushes when freeing vmemmap")
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Nice finding!

Makes me wonder whether the default flush_tlb_all() should actually map 
to a BUILD_BUG(), such that we don't silently not-flush on archs that 
don't implement it.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


