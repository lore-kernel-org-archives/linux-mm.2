Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED036C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900486B0093; Tue,  5 Aug 2025 02:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8886B009B; Tue,  5 Aug 2025 02:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE6F6B009F; Tue,  5 Aug 2025 02:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5516B0093
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:43:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB1F9140F31
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:43:11 +0000 (UTC)
X-FDA: 83741761782.01.679DE4A
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AB0340008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:43:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IZ4ZQL1g;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754376190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9nhYHdVYijXwXhKsqe5CscEEMmPinucJwaX/wDudLk=;
	b=KByIST3taG47ITmUyafGy5jeG5HjR1Ncz69wBuiG2rGw5GFy6ktFitCoFVGMNbcgzSfbLg
	LtUFd46Bsi1IC2OXJ2g3hM3tAFnCJpAoRuNIoxLbgf6ZQ0pbgaJv1fjgB58MTxmOtt2DRo
	Akf9rNHa17G8jzM8MX5TIuX7hnCFw3U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IZ4ZQL1g;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754376190; a=rsa-sha256;
	cv=none;
	b=z8SroYi0iO0ixScDMTZKqphQ5FQy3ClYIdy6kx+KgxOZvE6oJQ8EPAPYQglh/9KwzNfHoD
	Szw07BlAEfvlIaKBLrIS1gehr863Jol5fVgVh0OuhpefHsPMXgua8n9h17qKo9fLSzj39d
	iMESI9KBEdgFJlSrX98tdso3iGn0ZxU=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b3f80661991so4415705a12.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 23:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754376188; x=1754980988; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9nhYHdVYijXwXhKsqe5CscEEMmPinucJwaX/wDudLk=;
        b=IZ4ZQL1gYvOL9i991PRWrDREG3N3CiLXAVDWxjQW6NbdxEZvRRhl8fqCi2CvQ+pqML
         pTxLmn8SKLSB86ySsbXplF3agY4AfdLmw94VR3InG0y2QkotZHvB+slczHRgfVUPIPeT
         PluFrhl/J7R6kJLG0d7jip9GyQnJzp7NV0mTXx5DzU7F3Dgl6AqqNtuYNk3EYN/p7fFZ
         laH4aIvow3Z/B8sv/Eu7kwkKXrpeFxeCSm6IBDHMJueCi/LB20kJGM6MlG8vurNvRjcZ
         VOVSRxgQdI/sXJ+RCXj4nW0gc7qeIOkynBPzkvLIbXh7u4SPxBHEXA9t7n78AbxB32DY
         yyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754376188; x=1754980988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c9nhYHdVYijXwXhKsqe5CscEEMmPinucJwaX/wDudLk=;
        b=e44EI6PMxa5DmC451FJ25wLUoOKMEK0Cltg+GZRyZCo2CN5ElROnjkQdDeVs1fQyzG
         tEVY5zhx4zYmqSNPzHt9xnzcuw9DFOiqjrg5IHkAaAZHPn1namDxXaJ3W179UdIlbytp
         ATv7DGgYTRL7IwrS1kY7+TBcqsxa5zzkf/rbyuD6L7mOo1j/KDZLlazNO5HSlrtV4wZ0
         Q1ftfgrZGjJ6Fmqhtd7APjMNPupFGosBJ8/7jsWpoAClnh2+A8WoY5ML5ET1CPLgq3k9
         NQCVw2MYSV1STB0Bbkg948R3baE6jO6uO+rKzMcIJtLB62MBKVMNsU3McEJfvliAmi1N
         WKmA==
X-Forwarded-Encrypted: i=1; AJvYcCUddKMItn+rRWdoGIWUVZc/Gn0qE6wvP5HodFUgy/vDxX17l2zVrPG91PZoui7ggbaHKO+ODAw/Ng==@kvack.org
X-Gm-Message-State: AOJu0YzDG+HPYONQKe40ZQbNjEA5M1Sc/C/uHKaVNyOcoXdI6wQ7TEPP
	fnUJxf9qXuhU14cQUvR733URO4vEpLZBLgXuTMfMBjTfKbRhBkvYldZz7qqlXoCn+AU=
X-Gm-Gg: ASbGncvf3OqoEd1osvN4iXArK7vWJaKP4MCjA6EDDw+mzjwRhgj2zFQzGdU8C5LNCEB
	WAe61yx6r7y77ejfkQk/GUaLWD8ue4AeOBoCkMKVZVDWV2t/wYozajKC8OUnhEb6jhqh6sLrSxe
	CIdlMQXbqUNObh5HWAtj39Bxn9sC7v502HXLJxJSbgoMm2r46ubnZj6eiwblH2v5lbtKgenQC86
	tAiJxpd/SyXCDCmfzn5MRsekoh4aAWYJvbLcR3jK35dOPzmM7OWxS7bigYNybl9n5U1KRYSaBDp
	X9TgKwFMY38aJEtx7IzYB5JHuZ2W+2fDKIPn7Q4EWnLS6rkluRplhJT/nWD276vOaClLYrBtVGY
	JccKtLOCRNyMR73BB2aGdjhdmPELmzps6mimrGAsIBZHH4m8OzbJ7FfmvTjxV
X-Google-Smtp-Source: AGHT+IH6NKePpdklUEnERKhxy8cHNhExcNHW5IOQAP4eRTVMhTlFfu5DUYuvB7IhXb/s4ZjlKfsy4Q==
X-Received: by 2002:a17:90b:33c4:b0:31f:35f:96a1 with SMTP id 98e67ed59e1d1-3214feb327dmr3290114a91.15.1754376187896;
        Mon, 04 Aug 2025 23:43:07 -0700 (PDT)
Received: from [10.4.54.91] ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3207ebc0e79sm13561149a91.10.2025.08.04.23.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 23:43:07 -0700 (PDT)
Message-ID: <35417160-86bf-4580-8ae9-5cadd4f6401d@bytedance.com>
Date: Tue, 5 Aug 2025 14:42:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20250805035447.7958-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AB0340008
X-Rspamd-Server: rspam06
X-Stat-Signature: pkr3gdw8tzykrqafn6fdkk68fthk6xmj
X-HE-Tag: 1754376189-329846
X-HE-Meta: U2FsdGVkX1/gB2yZYLFwJ3mrbqtunrbb0SGkEd4QgV/oyh9ckRvPs2zo1AtXjrAjv4I6F1HDyXESx5gSPJKks1IDll5tu7kvzAk7Td4MDIJkVYFlXW4ox1zqtPsXtjGDaTHXBWmMOOJeAqA5F2NvlcIcZ/i4pBmAS3bLOJTOZOyTkCYYflaTWk2y/cB4GVDvbsV7a6owOqxed9CkPQdB1dHYiDzCWefsX1bZeQUzy9upXkbQV2Ur7zHuCdQ8Z7qscYxxJQaj+5DC2aEWOxC+iXpDBNfmNdPIDUkESJRLbciabEOexzA46Qs50SNQhxnqHqDSLpjgiXZwthzau2PhHdDCGzFqgeM2PtitqnItTfqg8XxgbIR46VSr/8BbExHGmr2gLcuZJfxzino8J+8qw2bIJ9HHYT0hGEezGGksY+uIlbdEyOklbZfp62eUjCr3tCBlby4o5EVnnyeCg7FJWEo5Q0HuaTuqRJhFwzmojcrQE1XtAbEgIVlRPnaHvoHRzrtcpgYZfldvY5NM2cWUytHmSBO2wDVDh1+i09Jv2wPPGJbvsSHVf/i+UjV5cXlCSHEQAaV2fuhD8bnnk+WxxsPk7g4RnpCWGkOw5+GaTmfsTp8gitDtgEKq+HcZ3QAfh5xW4zW+VDXyOGNTuKU2z5fzqIQ3BXCMHgRrSypeQvgEMQH4yJh0dXP7zhZDYPNa6fDzsNGRqaBoHb2okbox8SrgeJR8rjr7L2f/xqe1chCMZBYtSPH0n8PGAmPfPvVaPcxThxWXMkF6WnXaiGUJ4Y4+T6h4AHcEPsfuHNkmTPtSwZriIMmzCF/KrJKnQnQWM4Ut7d4VgbQ8ErdE1um5GGPEjuCAyqqYMR0FrssGI0BMOQVYZyJBS1/GnGHqKIbAJI8wiv3ks2wIjqEa81jPcmLCmWTGAwZomjuMw/QomG9S8NUPFvHaK9uLQHD3nUDCu29Z7gHUINMDm8iXNek
 weKEdNDs
 OysR6ZDN0L8KPTLX6bPjh4W8M4PXLjYmVbNNxmTes2U9LUN5YDT0Bc2Mrt19R86xuFvupOCkD9K9xzMHJIhwIlI0e5URgL3867qYhsO/gBVwAqkfZu4MCKG1+LDZwk2iLj3r2oUhOu2SlT6OqPRSqWp5ISWpT002PxtkjpKQ9IvQjw273IASFALatCzYPWJ6bZ21oPlqM5sZZezWRhWVAnTYtHuF4a5R0CfBzbljy38Pi42A8cSg3ZaJS9jTHj+6FnkBPNWRx2EOz2b6IGx/OD8o/nhvGK11NWLpTIYDnQdSeWHB+QxW7p4l9euNtVzUrKMh5RiJgaYvavinyq4TTsLUYGE/Vk1OqTrS8yijdLgJgH5TGFtPB+7zCqu0vh5SRpmAlEeQ4y09hYPQeOZV7g7t+TniPG1jfS0DgppbQKjz65iklEGcm+ocAv2qrCseWRVZDgJRh1LjX2yPi8l0SfLPaP2rPM51pK9RI9QQf7Oymb/A6QmJhHQqSqG1m3AAUf9deJsWRllnlAZuNBr6cQUink3XhyZuBIbvUZMczX96wvdUTbk1ukePNixF1FGOgsWyQatkcz55D28XJ5gF7+7nFQrQQLtUdlJrIJaXfx+dMHOrgMDbcrAe3WB0z0jQlVSjO1WxZI3Fxp2XELQe3b9PGThv7u7FjDpItMM2jOaHmSQDE1ciTI27O1d1mpBSXdEQhjk31D0iVq2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 8/5/25 11:54 AM, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> The check_pmd_still_valid() call during collapse is currently only
> protected by the mmap_lock in write mode, which was sufficient when
> pt_reclaim always ran under mmap_lock in read mode. However, since
> madvise_dontneed can now execute under a per-VMA lock, this assumption
> is no longer valid. As a result, a race condition can occur between
> collapse and PT_RECLAIM, potentially leading to a kernel panic.

There is indeed a race condition here. And after applying this patch, I
can no longer reproduce the problem locally (I was able to reproduce it
stably locally last night).

But I still can't figure out how this race condtion causes the
following panic:

exit_mmap
--> mmap_read_lock()
     unmap_vmas()
     --> pte_offset_map_lock
         --> rcu_read_lock()
             check if the pmd entry is a PTE page
             ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
             spin_lock(ptl)                  <-- PANIC!!

If this PTE page is freed by pt_reclaim (via RCU), then the ptl can not 
be NULL.

The collapse holds mmap write lock, so it is impossible to be concurrent
with exit_mmap().

Confusing. :(


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


