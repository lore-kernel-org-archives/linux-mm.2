Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFFCCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4D48E0019; Thu, 16 Oct 2025 06:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC828E0003; Thu, 16 Oct 2025 06:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B098E0019; Thu, 16 Oct 2025 06:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6831B8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:47:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 211A9119391
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:47:03 +0000 (UTC)
X-FDA: 84003649926.06.4E15A6B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4FC8180009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:47:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuTasb8Z;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760611621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWC1fBf3NN4ANTq+x7IzYDPSJqt6PESsXElpj8+2ZTI=;
	b=kZu95zw/a8i6sDk5mey+CSzp6hzco5sriN3DHYXxQS/8njgHwx9x/LZm5o/MiF7/U8UbV9
	nJqSC9mEbBMD4jr/yhwJTKyssySc/nJP45AUOCfnW31oCGarfF3rvzorO15KDwu9M5HLPF
	lzxHRsy19u/9rmVkJFz44I4T07ewwMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760611621; a=rsa-sha256;
	cv=none;
	b=nFF9HKazqfFJdFUzDOw7RdPjgNlMjT/k7PVXkkmVzcJKkT5gUi9ZrtROfYyGh5tLexfoMM
	4y3dSQU346Gobuw9LFVj+LsJAXvm2h0FHjSr2F+mxbQ+CrDWE2xeAcdrMPTRO1IZA7lBU7
	sQ1lCpgGppJnpkyRu0DgCpXrAGUH0D0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuTasb8Z;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760611620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PWC1fBf3NN4ANTq+x7IzYDPSJqt6PESsXElpj8+2ZTI=;
	b=TuTasb8ZzDAF0hIjcvb9DNbX5DUpgnVlahqExJwqoUFui31Y3t0J2tQmewy07JOgX8DdRf
	tsQV2+K1AA3eLyfKrybAe2HYCKVKjLfkHwY7Cgbn5Y2vxWmwUBjac3X/2wMv7iYJoV+7gc
	GJv9nnIbRq6lOm9JHVjVqygVm+7lk00=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-J6hGEAzxNcCavQzmx5Rsrw-1; Thu, 16 Oct 2025 06:46:58 -0400
X-MC-Unique: J6hGEAzxNcCavQzmx5Rsrw-1
X-Mimecast-MFC-AGG-ID: J6hGEAzxNcCavQzmx5Rsrw_1760611618
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso2965335e9.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760611617; x=1761216417;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PWC1fBf3NN4ANTq+x7IzYDPSJqt6PESsXElpj8+2ZTI=;
        b=Sn2B+1oRU3nKPYiAYL//hBIeZWhwt2SaaJYq4ALptUu1V8EjqBf+XtefBubDQS+HWV
         UgpoEK9d6vKyaNkZDCkH2ZGL4C5+TiAZ1j4H7pH/gUxyzMe4YKKwwd0Rxs+FORW5MaR5
         gT5k1sFtv1fR0tj1XGHPLts/Ck5uaQnkbz4Nh9FKin6eO791BifN+dYf4ecBLuxJWobf
         kk67I2T6TCZg1FD41ThfclyLCHcMpfBtqFRZg6y7MyPwBc6ZC8cYTsAEjyVHEhAhr1KM
         /Lmg6v9wWvLj4ZGgcO5EnGpIc+h87JucsdbVin2qzvbSAVMEfoleiGPrnDaTaZePAB9z
         M/7A==
X-Forwarded-Encrypted: i=1; AJvYcCW4n/ws8zv3UUl22tz7ksKnL1LwPteBHaJamx7ljVQf3cUnzGwhCQILYn3KHAm09lt/YRsVrgFVAg==@kvack.org
X-Gm-Message-State: AOJu0YzkK7A+XxzuLp+pafCzwk5oyNiXr/NdhA4brSLZFkRQN0I7Vz7r
	HC6VrA7f0xLHRXzVDXPgnHKVzSHnyqWHeC+I4R/lDYrRyE5qYOtpTo8RFKOMwemII+m5aQII4Bt
	9h+0adZm2bVKRr3Xq42Y8Q9GGbIfJet93PaabNBBExPylGizOj474
X-Gm-Gg: ASbGncvWeT3QQBVPowlKT3IrE3fVLXNDr88xRrQzYfDcJNDmmyxeF8vG4h591inmhbK
	l7ji0klKjoKWpOeo7rj/jbxPbfjtt5Z49K8S1MJg0KUczjaLahV291OReXHUE1rJ2KvxSzy2AU8
	J0CxGYIhxJE/DXcpvylwH94/adPCjSbuWP2gPaIpuF60Lc4A7WIzyiX/KW1ttBEVn2s+ihaWaGf
	+9FU0so9PWbZVggtBGwtP7F07vUkeUB+Td62UivlEGnRgG0IAaO+u1BzJ1NsLRYBMBYhkTwhLt2
	13C5Qf9vE95BChRXoUAQo2l4FSMBGxM+/KmsZEJ8Q6MstR0lJ77TvmW8vTVgYQ5/VIaNzrJsMSt
	7U0njnK2Clx3HI4a1hgCNPtKIDzYLaTqxpe1iks7dAtTZzSqQzyYRXpdoW6G2oTRhUZz/81OvMT
	V15Ek8spsTJlxEPKwktgiR7+RBgN8=
X-Received: by 2002:a05:600c:64ce:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-47109b2838emr22729135e9.14.1760611617531;
        Thu, 16 Oct 2025 03:46:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeVBgV9jTy2rMK7hSPUVLMGqdGDRZexkRhARKgF/fANx4xtmRQVfCaL0Mp8w2hsw9kLHDcCw==
X-Received: by 2002:a05:600c:64ce:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-47109b2838emr22728865e9.14.1760611617023;
        Thu, 16 Oct 2025 03:46:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5c29sm18829355e9.12.2025.10.16.03.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 03:46:56 -0700 (PDT)
Message-ID: <7e533422-1707-4fea-9350-0e832cf24a83@redhat.com>
Date: Thu, 16 Oct 2025 12:46:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Longlong Xia <xialonglong2025@163.com>, linmiaohe@huawei.com,
 lance.yang@linux.dev
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016101813.484565-1-xialonglong2025@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251016101813.484565-1-xialonglong2025@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KW4wGkQrooKrZZ3FGcvexkerdZU7Feo-aX4kLMt82xA_1760611618
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 8ndaz567arnjtbr8skp13qk3c4a1xudo
X-Rspam-User: 
X-Rspamd-Queue-Id: B4FC8180009
X-HE-Tag: 1760611620-111530
X-HE-Meta: U2FsdGVkX19EjgaMc8JXY6LqVxSq1ia7n9Snh5nTdKzAXzPYwNOYQTtIfTZY2/H2dufxbiWEZPLXgizuB6dAen1D8LV3wg9eToPf/qS/vDOuNaC4Uj1XN4cdHPMcnkoU9CA1nQUW7J0H7oSpma713blS/v71J1SRlCwzUZp6viY4TaZmrT5TyarjKzybxuSaCqxQkZm9GvupG0jn55L0g/0jkkBw8MgJ2dZMTAmucU0nzgImtP8k5NXAj3uuIcDL0Ja8uhj640dAlwYVc5Wm4gl/i0yMLLXGqV5iQXjEVT3v3lRHatPyKKX5Zln5TgVLhJOzMGeMkJI49oEDlCZJoUFULrwwT1gXLjb+c4+L0kY5f5E7IHr80NKeqaoiddeZ7A53MdRSzF+aE+HGJ8CfPPiKjdqPBnnv2Mdj0IKhKHAhqLKvkyk5kc4MX5twJb6vnAiTHP0ZD27i0parhD8y1EBB6A1xHycVZifOL2OQhlLTWYjrGjdfZaUGdY5V42Z1rAn1031qDcxw8EI7R74SQfJXvFhbHEQakASpBdtN1NkUMl/+ijitjpinxkg4MNx9ml/zvej3wOIp7RbS/f+va1XmWsLDp4CcRPN8Eqo+IzoNlr51f9SnPo4rPCtztLXfWMUZEJb6hh4k/RP3RTZt+Lnm0+HaUh1V3hODFXwUXXw4H7KLDH3GD0E7tJjFcCQnJrFHGUCU/cWFsdut42d10naiDmM242y+NzIBZqRK/OIm1MiA1dhty49OKaY8egJMrXbq5R14Ql3Mu/oIZMUrEr4UjFNfMnQod4x6/qJVLWbPk3bEFq5bwcpH+9fNnIPK1klqXwbPcFbQarTAGEce6QVCNH8bhXwE7EqSEkzqqK0WwQC7yuBa1j0Na8JeKayBa4Fv8DPaWpd5eCJINJbQIvK9E2f6VI0XzKCMkbjkkUTvj/xFSSA97YRNoxBHg1LwYEqvsgmDz2azHDvag4n
 eC/bkYS4
 zPloKU7Gw80yYq6xY2RCh5lXmZFuPy9NbjoyzDbyyv45I1Kps9tGi7bRoVDXpKu4AHIDNzkFtrLbpxzEg1DXb0FxQWIAvFYDEaAScfP84Rk9NSNhuSbZUq82WFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 12:18, Longlong Xia wrote:
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
> 
> This patch introduces a recovery mechanism that attempts to
> migrate mappings from the failing KSM page to a newly
> allocated KSM page or another healthy duplicate already
> present in the same chain, before falling back to the
> process-killing procedure.
> 
> The recovery process works as follows:
> 1. Identify if the failing KSM page belongs to a stable node chain.
> 2. Locate a healthy duplicate KSM page within the same chain.
> 3. For each process mapping the failing page:
>     a. Attempt to allocate a new KSM page copy from healthy duplicate
>        KSM page. If successful, migrate the mapping to this new KSM page.
>     b. If allocation fails, migrate the mapping to the existing healthy
>        duplicate KSM page.
> 4. If all migrations succeed, remove the failing KSM page from the chain.
> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>     error) does the kernel fall back to killing the affected processes.
> 
> The original idea came from Naoya Horiguchi.
> https://lore.kernel.org/all/20230331054243.GB1435482@hori.linux.bs1.fc.nec.co.jp/
> 
> I test it with einj in physical machine x86_64 CPU Intel(R) Xeon(R) Gold 6430.
> 
> test shell script
> modprobe einj 2>/dev/null
> echo 0x10 > /sys/kernel/debug/apei/einj/error_type
> echo $ADDRESS > /sys/kernel/debug/apei/einj/param1
> echo 0xfffffffffffff000 > /sys/kernel/debug/apei/einj/param2
> echo 1 > /sys/kernel/debug/apei/einj/error_inject
> 
> FIRST WAY: allocate a new KSM page copy from healthy duplicate
> 1. alloc 1024 page with same content and enable KSM to merge
> after merge (same phy_addr only print once)
> virtual addr = 0x71582be00000  phy_addr =0x124802000
> virtual addr = 0x71582bf2c000  phy_addr =0x124902000
> virtual addr = 0x71582c026000  phy_addr =0x125402000
> virtual addr = 0x71582c120000  phy_addr =0x125502000
> 
> 
> 2. echo 0x124802000 > /sys/kernel/debug/apei/einj/param1
> virtual addr = 0x71582be00000  phy_addr =0x1363b1000 (new allocated)
> virtual addr = 0x71582bf2c000  phy_addr =0x124902000
> virtual addr = 0x71582c026000  phy_addr =0x125402000
> virtual addr = 0x71582c120000  phy_addr =0x125502000
> 
> 
> 3. echo 0x124902000 > /sys/kernel/debug/apei/einj/param1
> virtual addr = 0x71582be00000  phy_addr =0x1363b1000
> virtual addr = 0x71582bf2c000  phy_addr =0x13099a000 (new allocated)
> virtual addr = 0x71582c026000  phy_addr =0x125402000
> virtual addr = 0x71582c120000  phy_addr =0x125502000
> 
> kernel-log:
> mce: [Hardware Error]: Machine check events logged
> ksm: recovery successful, no need to kill processes
> Memory failure: 0x124802: recovery action for dirty LRU page: Recovered
> Memory failure: 0x124802: recovery action for already poisoned page: Failed
> ksm: recovery successful, no need to kill processes
> Memory failure: 0x124902: recovery action for dirty LRU page: Recovered
> Memory failure: 0x124902: recovery action for already poisoned page: Failed
> 
> 
> SECOND WAY: Migrate the mapping to the existing healthy duplicate KSM page
> 1. alloc 1024 page with same content and enable KSM to merge
> after merge (same phy_addr only print once)
> virtual addr = 0x79a172000000  phy_addr =0x141802000
> virtual addr = 0x79a17212c000  phy_addr =0x141902000
> virtual addr = 0x79a172226000  phy_addr =0x13cc02000
> virtual addr = 0x79a172320000  phy_addr =0x13cd02000
> 
> 2 echo 0x141802000 > /sys/kernel/debug/apei/einj/param1
> a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
> b.virtual addr = 0x79a17212c000  phy_addr =0x141902000
> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
> d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a)
> 
> 3.echo 0x141902000 > /sys/kernel/debug/apei/einj/param1
> a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
> b.virtual addr = 0x79a172032000  phy_addr =0x13cd02000 (share with a)
> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
> d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a)
> 
> 4. echo 0x13cd02000 > /sys/kernel/debug/apei/einj/param1
> a.virtual addr = 0x79a172000000  phy_addr =0x13cc02000
> b.virtual addr = 0x79a172032000  phy_addr =0x13cc02000 (share with a)
> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000 (share with a)
> d.virtual addr = 0x79a172320000  phy_addr =0x13cc02000 (share with a)
> 
> 5. echo 0x13cc02000 > /sys/kernel/debug/apei/einj/param1
> Bus error (core dumped)
> 
> kernel-log:
> mce: [Hardware Error]: Machine check events logged
> ksm: recovery successful, no need to kill processes
> Memory failure: 0x141802: recovery action for dirty LRU page: Recovered
> Memory failure: 0x141802: recovery action for already poisoned page: Failed
> ksm: recovery successful, no need to kill processes
> Memory failure: 0x141902: recovery action for dirty LRU page: Recovered
> Memory failure: 0x141902: recovery action for already poisoned page: Failed
> ksm: recovery successful, no need to kill processes
> Memory failure: 0x13cd02: recovery action for dirty LRU page: Recovered
> Memory failure: 0x13cd02: recovery action for already poisoned page: Failed
> Memory failure: 0x13cc02: recovery action for dirty LRU page: Recovered
> Memory failure: 0x13cc02: recovery action for already poisoned page: Failed
> MCE: Killing ksm_addr:5221 due to hardware memory corruption fault at 79a172000000
> 
> ZERO PAGE TEST:
> when I test in physical machine x86_64 CPU Intel(R) Xeon(R) Gold 6430
> [shell]# ./einj.sh 0x193f908000
> ./einj.sh: line 25: echo: write error: Address already in use
> 
> when I test in qemu-x86_64.
> Injecting memory failure at pfn 0x3a9d0c
> Memory failure: 0x3a9d0c: unhandlable page.
> Memory failure: 0x3a9d0c: recovery action for get hwpoison page: Ignored
> 
> It seems return early before enter this patch's functions.
> 
> Thanks for review and comments!
> 
> Changes in v2:
> 
> - Implemented a two-tier recovery strategy: preferring newly allocated
>    pages over existing duplicates to avoid concentrating mappings on a
>    single page suggested by David Hildenbrand

I also asked how relevant this is in practice [1]

"
But how realistic do we consider that in practice? We need quite a bunch
of processes to dedup the same page to end up getting duplicates in the
chain IIRC.

So isn't this rather an improvement only for less likely scenarios in
practice?
"

In particular for your test "alloc 1024 page with same content".

It certainly adds complexity, so we should clarify if this is really 
worth it.

[1] 
https://lore.kernel.org/all/8c4d8ebe-885e-40f0-a10e-7290067c7b96@redhat.com/

-- 
Cheers

David / dhildenb


