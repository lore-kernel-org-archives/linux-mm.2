Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EED9CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725C28E001B; Tue, 30 Sep 2025 02:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6058E0002; Tue, 30 Sep 2025 02:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DF98E001B; Tue, 30 Sep 2025 02:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 433018E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1F611A05D3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:45:57 +0000 (UTC)
X-FDA: 83944981554.01.08A87A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7A874100010
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:45:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xibjcj7C;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AIMq+OlhpyT2npgIFmZrEOK/CbKwyfphzbxq2DUajU=;
	b=MMfUnN2DN4OOZD02n83QK4NjlevW3NK498cdVb7JjVluTuJtCyI33pyQp5ybcy6VEcZgl+
	B0MhIgdleiIr4SEyv31mFESZUh5MXHZsgnqKR5jEcKrcnWMGi4RvS5+wNaKoeJFEM4OgQD
	cOtPsgYsNZmGA/ROPzgDLAmN+7Da8Vc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xibjcj7C;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214755; a=rsa-sha256;
	cv=none;
	b=UR7ERtR4//JOhnjs3mYm036AAuDG9F3NcyXI7Lv13Lhip5/+CCCzJYODNiOF0tyaWP9QWF
	A4PJd5uVAuG8bcUnfOFGoShv+lGp2QE4EcdumT4rYz0DAMJU04v6LCKd7xBF7l1BkJTFmP
	jQ6bdnCuGqBa2TQA+kWqa4xNHOBHnQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8AIMq+OlhpyT2npgIFmZrEOK/CbKwyfphzbxq2DUajU=;
	b=Xibjcj7CHeBLRgtTVaUSMBuClYACz5rRf8o0x2mJUi4vR9R9mhdPBwSLr4nk4BoIZwN0yn
	l0crbBv8OWf0Y/5K692MzKkR5PdL3Oaju4S52H/9YkgQnC/12wforUuoyxtR5dXKX0ZiK0
	4e9ewBBV4nya0fYAR4gDU0YuaHwJSKQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-e682dCYBNOeGMMiSN4G1yg-1; Tue, 30 Sep 2025 02:45:53 -0400
X-MC-Unique: e682dCYBNOeGMMiSN4G1yg-1
X-Mimecast-MFC-AGG-ID: e682dCYBNOeGMMiSN4G1yg_1759214752
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so2675682f8f.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759214752; x=1759819552;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8AIMq+OlhpyT2npgIFmZrEOK/CbKwyfphzbxq2DUajU=;
        b=ESPHWNJ4reIrhTsUnWxQKApIMHMDbfz2Z/mP6xdy6zfd3ZkHjt8j/WNimKWlzOj+dm
         bnLZ3oxZsK15vudknZ5zhLfU2zGTF33b9A/AGxssDgYntkjXTj34Og1Q4wwC1hajoaRf
         gSAnp4pj/tvQqVhL0kjz/siGnIEiFrHxuOFDMQ8zCzzyo1Tv575WTFQCg6p0Dl7BP6dV
         jtcLbCst+GxOKff4zBGhddor7OjV6dZIeBO7f/cm/EtrXkRpmI7mkMe1unqww7ahGTiZ
         Z6yH5ZMlNxlnMX/1qgBxJK0+lyxYapBuUnqAlbl+xQN+ZjoA8EewnupkCjleRP4fZMHc
         x5IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPIwCyl1V3q1dq8w5ztK4vOqKC4ptuNmsLjH/6lvuHfUDDNRkghiMZ9wacVF3X9AKvfbLwvwuJqg==@kvack.org
X-Gm-Message-State: AOJu0YxnuEa8nzrYLQOsO4nV+PG0CzjNsIANo6fyZVUI6EY9u4CFL+1Q
	f1VdVTJa/PTR1pxFRsP09n07jPnBQdKHijMggXsIoypjry38r5t4s8+WuHEJTktIjuZ6R5HYZmi
	xHuczCe5vxfNzapTfl4plFySHSb97atmRjMlnt4XejoBO2v0wrU4I
X-Gm-Gg: ASbGnctUTU+H1UlUgGVFtrS4gVBIt7HJGkqm1mynIqgJrTFMptc9Yau7aNiCSLsdyK2
	CTOkSGEe8g1vNxZFO6E3a44GcU5Dc+RJbLD/5bk2DnI5mSHlxme9yg7MpHwExiniELBMc9uXj1t
	x7FnAmnDvr/2nsN6B8cx9UBdYegTXytzcMG1JCh+XLLqz+DkApTWvHAvE1n05nkcZooJnf8OXap
	UxWOpycvu8lAGcCh2hRYi4W04xdy683rswgw5V4hIkPrYPTxktwKDeUOJvWY23rnLfeS7RWE+3z
	M4xqhf8SOI9c8lVlVmz2pnBqRwsbjq4Ew7TObDOKsPRy7LF/TK0g3kkeQvhxLcdFOWRTN5X7v4p
	pey91mfDe
X-Received: by 2002:a05:6000:1a89:b0:3ed:a43d:8eba with SMTP id ffacd0b85a97d-40e4b389211mr18844299f8f.52.1759214751619;
        Mon, 29 Sep 2025 23:45:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFg/W6e/I7hHziArdv6ifYggaC+j0tYvxahMU2MCeZ7zKwkNHwGQwxT9opm5ct5RbwIhmPfXQ==
X-Received: by 2002:a05:6000:1a89:b0:3ed:a43d:8eba with SMTP id ffacd0b85a97d-40e4b389211mr18844269f8f.52.1759214751197;
        Mon, 29 Sep 2025 23:45:51 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c06a9ffsm7025105e9.0.2025.09.29.23.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 23:45:50 -0700 (PDT)
Message-ID: <d25474b8-c340-4546-a41e-60a6ecfc42c3@redhat.com>
Date: Tue, 30 Sep 2025 08:45:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix flag-dropping behavior in ksm_madvise
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250930063921.62354-1-acsjakub@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250930063921.62354-1-acsjakub@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uHZdEXXET3_fd5P_wvzrUb9x1dMueuD0y7tO39_w5x8_1759214752
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A874100010
X-Rspamd-Server: rspam05
X-Stat-Signature: qesu5tmp4ztoj6hxqc6n7uo4ak7nibdn
X-Rspam-User: 
X-HE-Tag: 1759214755-869502
X-HE-Meta: U2FsdGVkX1/G8nTFg621XgNiKJzy445pJAQG8o8d+A8ZagphyEFsbHMfTGcnYTvJ6WJSeXMMKX23RPK9YSZTo/iwIy6gIJBHefyaMNf7WdELrY2DbiYF2MO9VnDf8fiulwzQ9nQiQxznnpEV6TIKWQy/bpmS8+XC3C9j4dqYnfpJ8NmaRwuMoD0Zdq/9ab8nTsvc3Nu0M37ywrqGR/l0kNiY27zN1sUTuqXtigmN0Zz6ryzRY1Ot1bQCAYpZFLf4f3RbGHUOYsnwDU5piiDR1SArzHhFs+bCfnPRvSjZbm4FeD+Y7jBdL4EoQm+33v6HcQOQ5Q31aj5FmWgPIBQLrsFCAqWYAhlcZLEKRDLm3vxrZvqjqOoVYR/1EdMw8rONnDVR1J3JSbniVIVtC7Y5OexjdLfCzsvXtsxnD7QlC/hBvHHwWxQXWOfY2B2YXFZiCzHZHoszP4iYeG13JzUJkB4NFtI9jzxawG+r3Tcf5T1MknWqh+Oq5c9f6GQ2X4V5J9yqoapmoHf2NCBckPb4PO+3bJBkOg05OVTewa+kF+pLsMZrwCRoCgsgs7mEdXb/uHEWH4RDHeQBHgfXHbIbUIRA2NpTgM+P+XMjW4LHCYjkLR0CQNihZeJZOm6cO9UhnACI8wkclrqT8PJ9OcNUJCrdugcFLunDllcKIe6OP0AJoCp3BhKzsagq58OI0ayqcwVWLJtJ9ZILq89I2qF9zk/LHdEt8jTme1d8j8IdnIyTD9UFj8BlyixrwnAUZwrAM4u4mpDS94vFxJhOqcxznbH/ATK10RcyqfDR5zJ8/XjtIjZrP8O0mAdOuixMhAt5eXsbqS0Ux3bD0urmP7XSz4goXex7iSq5eqvRd3tg/7FMrVXmRUpTXN3nWAo8yqXYV0oovTIjAZaBCghm5ylV6ta8FoovX6wfPjC+cYoktc7fDo0eVUbPM1MidQdaAu7ozyR76Vc/5T+nB0Xidqw
 xUvVGHKm
 IckXayODMls0nbplp9v+0l0b9RVw12FX9GvCBaLT22lbe56mPtL8ypPTRtnicB+lJ6ldZneJjHYJQq46543FOXkcNaY1u/9OqF4MT+8+b8wwWVq2XYCia1BmB8n0Px3O8JRmD0O033uatSp1Dv2lO4r7os4s/tZLdZaCSEQCQutV0HTA+vyKTDlcX7cXjHb6uV81jAOBrtEL3wGpB54OFilxkra2EFAszzo41aD8Z3izs+3pL5kDquzincF7PxiqPh19+U4jmDo/DixfqCQh/+2S0DiSCstkC+7hqxV2oqRQbxRB9Xc68HBj3/H6lXyYknWpFiBD0b3J5f9BPNEg8zq6cBrPQS5u0xZ212YkWNzXb0/7C+BShdSYD89qpzMCy/onuFR5zL/ybGqiKienCmvyE8gRk0ocf00xVFCATovE4ckG+hRmqie8vnNtyzzHfr6DHNowwInS3q1iHL10YUaclRjjIjsypQoZzOLvtyisFkCyvnyHfezdM5djhp+1s5lmKzkWfbZuFHP/jtSZNPAATOnxcGDiacnH4cptU2fwwEjBpZpgB1K24gkeJcj/KMG9f7LLoGVRBY5bObfMzakzV4EBsjzguMH1b+/YYlRsKKCU5iaHFag7cNn0CM3AttaWQJofWgWsboTD7Bv23c0795Lq8ITohoufF9DaBSIohqkL7psu5F1JIOzAYqWe1o5pn8CVnBbByLZWNiqnxVsI13Y54ShtIfOCT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 08:39, Jakub Acs wrote:
> syzkaller discovered the following crash: (kernel BUG)
> 
> [   44.607039] ------------[ cut here ]------------
> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> 
> <snip other registers, drop unreliable trace>
> 
> [   44.617726] Call Trace:
> [   44.617926]  <TASK>
> [   44.619284]  userfaultfd_release+0xef/0x1b0
> [   44.620976]  __fput+0x3f9/0xb60
> [   44.621240]  fput_close_sync+0x110/0x210
> [   44.622222]  __x64_sys_close+0x8f/0x120
> [   44.622530]  do_syscall_64+0x5b/0x2f0
> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   44.623244] RIP: 0033:0x7f365bb3f227
> 
> Kernel panics because it detects UFFD inconsistency during
> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> 
> The inconsistency is caused in ksm_madvise(): when user calls madvise()
> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> mode, it accidentally clears all flags stored in the upper 32 bits of
> vma->vm_flags.
> 
> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> and int are 32-bit wide. This setup causes the following mishap during
> the &= ~VM_MERGEABLE assignment.
> 
> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> promoted to unsigned long before the & operation. This promotion fills
> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> even for a signed conversion, this wouldn't help as the leading bit is
> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> the upper 32-bits of its value.
> 
> Fix it by casting `VM_MERGEABLE` constant to unsigned long to preserve
> the upper 32 bits, in case it's needed.
> 
> Note: other VM_* flags are not affected:
> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> all constants of type int and after ~ operation, they end up with
> leading 1 and are thus converted to unsigned long with leading 1s.
> 
> Note 2:
> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> no longer a kernel BUG, but a WARNING at the same place:
> 
> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> 
> but the root-cause (flag-drop) remains the same.
> 
> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
> 
> I looked around the kernel and found one more flag that might be
> causing similar issues: "IORESOURCE_BUSY" - as its inverted version is
> bit-anded to unsigned long fields. However, it seems those fields don't
> actually use any bits from upper 32-bits as flags (yet?).
> 
> I also considered changing the constant definition by adding ULL, but am
> not sure where else that could blow up, plus it would likely call to
> define all the related constants as ULL for consistency. If you'd prefer
> that fix, let me know.
> 
> 
>   mm/ksm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..c24137a1eeb7 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2871,7 +2871,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>   				return err;
>   		}
>   
> -		*vm_flags &= ~VM_MERGEABLE;
> +		*vm_flags &= ~((unsigned long) VM_MERGEABLE);
>   		break;
>   	}
>   

Wouldn't it be better to just do

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec75..0eaf8af153f98 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void *objp);
  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" and pure PFN pages */
  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this vma */
  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pages */
+#define VM_MERGEABLE   0x80000000ul    /* KSM may merge identical pages */
  
  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit architectures */


And for consistency doing it to all other flags as well? After all we have

	typedef unsigned long vm_flags_t;

-- 
Cheers

David / dhildenb


