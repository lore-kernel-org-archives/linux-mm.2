Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E5EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065076B0096; Tue,  5 Aug 2025 04:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015DC6B0099; Tue,  5 Aug 2025 04:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF91F6B009B; Tue,  5 Aug 2025 04:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDA606B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:02:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EBCB1A01DD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:02:55 +0000 (UTC)
X-FDA: 83741962710.19.5D2986A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C7ED91A0004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:02:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KLGfb8FC;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754380973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSwkbSa6l7ycCc/BOqgqBvcWXEVn79qomV1EWHYkCrw=;
	b=oqfrEkfl3xs8HkZ+YIdyDOWG2V73EGwVj46b7ImrSTscouWo3QYYZlm1Lr7ToXCUDJcAzf
	RpV+3p6BCtKRXLSmHuhwxf2MouBRcFVwKf0plk7bY0pZhPSIw+KJw9QSsrdumpDIaZ93Lx
	8ozzy66jQv3mTcGZ7+w2OwrPXDao/A4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754380973; a=rsa-sha256;
	cv=none;
	b=XqWGyUp0HlmKC/blve9XvkQQbr7eGwT4BG2T+1MmzGlEsPa8mR3gZqEhZ47OzrZkJtSA5Z
	xIiGH9mH5po8/+jTcxWEPQjAonLvOM16HhX9Djm6VIzZgb6luSYLH2ZcYgZK/ATWrPRolB
	848IT0R6nJXyzHPocghAZsbiYIjHqKk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KLGfb8FC;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754380972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSwkbSa6l7ycCc/BOqgqBvcWXEVn79qomV1EWHYkCrw=;
	b=KLGfb8FCXWcIMNIkCr5rhbQ4I9tDWe+SbfYr5ZuSXWgHbMEZA00zw4OalK2HLiMDreLxvN
	7nVmlStgLwjX/URF+IaCNmo2QdIkpPo7mofv/PLAv48k8xjwivtBT2FFD8WDty9RRL2+GP
	GyvlcheVDKK2ys2GP/k1Tky0CN3wKuM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-kq8SueOrOQOxk0piDikcAQ-1; Tue, 05 Aug 2025 04:02:50 -0400
X-MC-Unique: kq8SueOrOQOxk0piDikcAQ-1
X-Mimecast-MFC-AGG-ID: kq8SueOrOQOxk0piDikcAQ_1754380970
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d8020b7bso12056975e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 01:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754380970; x=1754985770;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JSwkbSa6l7ycCc/BOqgqBvcWXEVn79qomV1EWHYkCrw=;
        b=DEn6oAi3Or4Q1U2a1l8BB1jd8NWHg0iKe+m+BS/fmpcbILuJOXuwWOabUxOIuFaCCB
         Wb2GkuPYpmniYq6h4IxWzeqoJKFJFRx3nOdRiAypUZwRYHt4w7x0i79jloMD0wfhX8RB
         ezoiHommMuu0khBXUJM+fRQz+8C7pFMyKo2+cQOBoqj2+RAhpqjG9a68IrQslyWgEogi
         6R3+Tf7rzudYPmTFLgufI0RuvLYb7zgA7LoVh9l/HjOwbmt//aQPQAN1jK7xXuk4HfYu
         DNUI2+8eR/j6G2mNLK4xLDt49IUveSTRDjnLnAPNCnDUVyQYIPy6m9xs/qnOPHdqsVHT
         mJsw==
X-Forwarded-Encrypted: i=1; AJvYcCXldJns3HPYkT/XsZs6i03GIJ+fTJtm2IAOi4a64jJr+DFUks+NibyWAHZRHE/2uHV7sL3XzA89Xw==@kvack.org
X-Gm-Message-State: AOJu0YxhNrWvwww6ajiMI0LsxTHDLS+qVn2GZlgGmI2QYe0Ds2Y9HMeT
	w42VAx2cLx7O2WZiZmXz/ivY8Bo+1DtwhiTvGaCP7TIzIfNmE9pw8JL0xZ8EPcxI+nzptAdUrm+
	Vz9TdoEnvyjfiMyVfiTSS/ogTVG5wjAew0OQud8FC3iceAbHIUOgd
X-Gm-Gg: ASbGncvQgHPzzRjvf64H6/p2ZEd2y0gCEZNZ1HVnnZ2x1Fl9cLAPf5fLyMd1kFzlXKJ
	ijkpXWqy12wH9YLEkuDXpvFyuwGzDVgNDSk/j7MssEzpMHZlwxTFpgRPjZ5ydOcLy9KU8OKir65
	sBjmQiKToplujPmCF2v7rNd/CGoVR9xQayEh6KinEqf8hbv1BpLRj6gh2um0j+qiGYrXDyP3bgT
	9Wh1V97EqpaoZ84WE6Jac2MjbeZvC9GUeBA8Mu60NNfsFIxfEWCM9QhkrtlaFeFiimI5MllRZ8O
	yDM4t1l+jR+6Sk3IstNEgr2auJfWyccDrQSR1WqwHMoSWEsrqH0mXpufRA0tXgK2a4MMFiHdyQa
	NMihvfcTIllWV2kHx0gkrr1NPq7iEB8UWVvr2iSBN7vbbj/EelZnjmCS+IEKcIg9ke8s=
X-Received: by 2002:a05:600c:35d2:b0:458:a992:6f1e with SMTP id 5b1f17b1804b1-458b69c6c25mr109428675e9.5.1754380969418;
        Tue, 05 Aug 2025 01:02:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq10p0Yw1CWG98R18igCn6l3zn4ByDpEOpw0MCY9quOv9K2UgJyFw5g8PFcpNZuwG5NHll3w==
X-Received: by 2002:a05:600c:35d2:b0:458:a992:6f1e with SMTP id 5b1f17b1804b1-458b69c6c25mr109428095e9.5.1754380968862;
        Tue, 05 Aug 2025 01:02:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0cd2c90sm25665045e9.17.2025.08.05.01.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 01:02:48 -0700 (PDT)
Message-ID: <2e95f6a0-7376-47f0-841d-8f442890149a@redhat.com>
Date: Tue, 5 Aug 2025 10:02:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>,
 Tangquan Zheng <zhengtangquan@oppo.com>, Lance Yang <ioworker0@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805035447.7958-1-21cnbao@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z9W-Jtn_OJIMOP3kHJ0cXVZ2Ha1EJ-z4OgP1G6PM4vA_1754380970
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C7ED91A0004
X-Stat-Signature: 9fj5wbjg3t64useogdaq1xka11us4t54
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754380972-855233
X-HE-Meta: U2FsdGVkX18L7a9AnpQmBwVMz16l3jL6ldvhnIMZea6R/5rx2lLtJKLUr1euhvQLZ2VPEciZqbFcFn9saMNrda+dVHRK8yJtcWUS1Sjl2D8ALaA7wVpwHA0Wh3yiigMDrfq4BtnLaUwhiUKtCikwMfa91n8aB/Yyce2McJFKTv1CRju+s1gyRlYFQoxM+zLvOeytMomZL4+6dfChf7E+DDMSRuJZdoSbxGM5u20UA+l+5Rf4VuZg3DYqn0xb+qw6PiZSJKxPcpBlWVLCrT2sVsMvnQDCejl03ikCaV8ZeAF705QQH43xIdMZpfKxWGTD/ZbhMz7Uo/IVHGqjpSZlw5I0LpMiQBbo0nW+H0wDH5auM78l+Wq62UvRcSxCE2QXX+2t3L2K339R6OFMzBENnCyZdaxzr030N0o0O7DwqYE2BC/SpWMqGkmJZnaIAfVyYDgkKO+4f9fwi6OknzIn4Pxv+PUTGJqM/GyyqIPaJZUdPlTYgxaBr51SCjcaAeUeEr/1Qa9h7gMG6Ka8hvtO/LoY4WpAE7ILvsWNtzfF/hA67IhWLYv7VXGegCHGIIrjMKpFmuZbjybhyEkIf+DtwOIzsCkYMS0vBA6EpQx4i6vJ+WoLI4mH9MT1qzB1pmslOk0JiCJepiXiq6aX8+Qg6Zrz0HMMehdZEUsR8iLA7WmYItPcK3aNUUFIagP0AiSYTQYrLElht1p4Uscvc1BHe12bHsTuW2EANeu23gqwvakHDavw+e+3ihvlbvmwxzKYAOjiCE1KnuKEqWraq7gqGxeJVienRD0FKOxG63BNC4/UqnYKjp/rsBKyBNRnozJAKoL3vKXaDq9/jR6VgCRMo6c+YGJdI/lprmSFpj9qFN8UGBFgmnaoHXosCqA6yujZwOhoHi/RqATsWwmr2wp0euJ2H66huESAyMn50OKd7p2vMl3cz3FsWg7tXbYDrMxLCuEN5d/39e9u/Jq9ZXk
 1TYIbnVC
 AOBU8Yx6MbAFCC5FBi2+HMY718/JLcNlI52iLt8ekBPTLmLecag00Buc+RXoot1b/yrVxkmCUgccki5vm15+TDRdR7q8VjaH1EJsSzAIGZxNncO/DGPN84sNgCXZmGG2mw4u+/7Y9o2h0eHZ0Swfhzb7k/EO9FVmLUFXH7OMARMd86QTCcDabru+9ktMHgS4RsR0+cncrzVh3+CQ1IKquxHsxwOXGS2m04Uje+01NXxkyC2gXsBahNaCcA4YEVG3fnxOoX2HSVYDWDN61JknGZQ3JVEWTkqaiJmILtszlXfX6d/JHSNxXG4YWJ2uzOm237k0EyjKFWLso7S0JMOrkuTz69oOInSEK5vwUgKF/Xi+UZRnUW3P+Lg1qTxXq3isPE3iLCnKtQ4E4AMWS/SPzS4YLpOtO0+Ruqh17dzV/gmyK9jsY7LNUUjCzWHsbxVMV8SObpHTADL0n/9hpT3BBINAKYBJO0ORZPobqstsXWCD2QFAIBeic3ONAm+6ZNJCrfzXDSurB5bSI0Qc48O90mBy5KrIcFF5hFU7JPLlfewte66aDAmSesb+Bgo2tKgyu/w4bIMj77UlB7CqPp68jj8dAaVx0aN7sHtmxUxTDPJUUriPUD6vynDt8++MSFvqNhbUe5PSswbikIkK0qt5SD9kSGywywXCOJt8dTP8t4KoZx8It4jDuDAnO8ZrFXvYZhgP+vNQ358TNTim6D08R+imm+VgFu2ZsFe+ZldC9frzOUV6jvtUSvt4oER207xjtjX96u5BJihzbtgGf77FPFB0+RREFyezRE5YBFEbUvqUbUD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 05:54, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> The check_pmd_still_valid() call during collapse is currently only
> protected by the mmap_lock in write mode, which was sufficient when
> pt_reclaim always ran under mmap_lock in read mode. However, since
> madvise_dontneed can now execute under a per-VMA lock, this assumption
> is no longer valid. As a result, a race condition can occur between
> collapse and PT_RECLAIM, potentially leading to a kernel panic.
> 
>   [   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
>   [   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>   [   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
>   [   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
>   [   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
>   [   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
>   [   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
>   [   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
>   [   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
>   [   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
>   [   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
>   [   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
>   [   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
>   [   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
>   [   38.168812] PKRU: 55555554
>   [   38.169275] Call Trace:
>   [   38.169647]  <TASK>
>   [   38.169975]  ? __kasan_check_byte+0x19/0x50
>   [   38.170581]  lock_acquire+0xea/0x310
>   [   38.171083]  ? rcu_is_watching+0x19/0xc0
>   [   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>   [   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
>   [   38.173130]  _raw_spin_lock+0x38/0x50
>   [   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
>   [   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
>   [   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
>   [   38.175724]  ? __pfx_pud_val+0x10/0x10
>   [   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
>   [   38.177183]  unmap_page_range+0xb60/0x43e0
>   [   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
>   [   38.178485]  ? mas_next_slot+0x133a/0x1a50
>   [   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
>   [   38.179830]  unmap_vmas+0x1fa/0x460
>   [   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
>   [   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>   [   38.181877]  exit_mmap+0x1a2/0xb40
>   [   38.182396]  ? lock_release+0x14f/0x2c0
>   [   38.182929]  ? __pfx_exit_mmap+0x10/0x10
>   [   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
>   [   38.184188]  ? mutex_unlock+0x16/0x20
>   [   38.184704]  mmput+0x132/0x370
>   [   38.185208]  do_exit+0x7e7/0x28c0
>   [   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
>   [   38.186328]  ? do_group_exit+0x1d8/0x2c0
>   [   38.186873]  ? __pfx_do_exit+0x10/0x10
>   [   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
>   [   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
>   [   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
>   [   38.189313]  do_group_exit+0xe4/0x2c0
>   [   38.189831]  __x64_sys_exit_group+0x4d/0x60
>   [   38.190413]  x64_sys_call+0x2174/0x2180
>   [   38.190935]  do_syscall_64+0x6d/0x2e0
>   [   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> This patch moves the vma_start_write() call to precede
> check_pmd_still_valid(), ensuring that the check is also properly
> protected by the per-VMA lock.
> 
> Fixes: a6fde7add78d ("mm: use per_vma lock for MADV_DONTNEED")
> Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Closes: https://lore.kernel.org/all/aJAFrYfyzGpbm+0m@ly-workstation/
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 374a6a5193a7..6b40bdfd224c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	if (result != SCAN_SUCCEED)
>   		goto out_up_write;
>   	/* check if the pmd is still valid */
> +	vma_start_write(vma);
>   	result = check_pmd_still_valid(mm, address, pmd);
>   	if (result != SCAN_SUCCEED)
>   		goto out_up_write;
>   
> -	vma_start_write(vma);
>   	anon_vma_lock_write(vma->anon_vma);
>   
>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,

LGTM, I was wondering whether we should just place it next to the 
mmap_write_lock() with the assumption that hugepage_vma_revalidate() 
will commonly not fail.

So personally, I would move it further up.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


