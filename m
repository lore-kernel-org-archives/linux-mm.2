Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409A460A3803
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T5NfUtG9
Received: by kanga.kvack.org (Postfix)
	id 2412F6B05B1; Mon,  9 Nov 2026 22:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216B86B05B7; Mon,  9 Nov 2026 22:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D156B05B8; Mon,  9 Nov 2026 22:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD47D6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:22:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F215160863
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:22:40 +0000 (UTC)
X-FDA: 85417762080.20.CB5928F
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79F154000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:22:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T5NfUtG9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/wp6KJO63iMMRJlz6HcbO/i7czGvSk/CyVD5tv8Mv8=;
	b=zk/+tfs4/i7hvP/dlMrrOqocwGm93KUYNteYf6aQ1o5svRg17z+XBYUcVKB2Bt2nY/wu3M
	6d3ePMrbhfsEU0i7kkCFwgCFfdg808oUc+3UST2WVH8w7qVNGv7ty4Z5tCIEC97BTGKymU
	C4iHo2oAhLIrVmVKLlrxsp2mLBrtQRo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T5NfUtG9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794280958;
	b=2FvMN/HRfSNO+s33qxE/Kqvx79guVAJ75j8I6kFycVPcR0wfBUYgNjuAD9xy9B2vwdicjc
	UcVyuWCVlVMQfj6ALNQ2DD5DTWhVnTemDvu+Gu83MQ2XkI1D8I+pc+5lqYEc6scqpVgWTX
	bPaVVWOrcx18TR9Cm1RVVnXINaxeQ90=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3700ed8dbe3so2105405eec.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794280957; x=1794885757; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W/wp6KJO63iMMRJlz6HcbO/i7czGvSk/CyVD5tv8Mv8=;
        b=T5NfUtG9Qb1tv28NwHwA0jVyJgRU31/gNKJzyL5jRdeC2wOdFFbpWktSiY7+HkWonS
         +Gitzza7sU/l7ihn0nWN7URPuLlZQ2sz/Go1i/JNgj45354NcS+C6Z75/ZzVauZRJrsH
         FR0A2MkaSxKOI/bYf3vZZx+NZqG4EnGyu/ii3L8Vx252fRLrIyuTzoASrP4Ka+yymqxQ
         laQ49v/cTz/hl74a/ihvouR+Uowt0fTP1jbTMB0so6feIdH02K91Sy6nWJxdz3XhbNLU
         bDtKF5Vpcrus41z/OQBgsk7C2pVHOpvaeDCD1tHXpRBD2o5+hr7RRYovszeFdWqckXHl
         Lxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280957; x=1794885757;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W/wp6KJO63iMMRJlz6HcbO/i7czGvSk/CyVD5tv8Mv8=;
        b=O4co+4UIUHxDAyLkbeOMk+lG7WAmMGRx7noDI41XUthMn6wNPeIpVOAFW0L+gvdEaM
         BCj3qodmFU7tZuZBFjWKmqZr+6YSfTscpzXwZkNo7ikE//OI5HzYhwAy0AE3XFqQkb3B
         vWCFuDHvhp3GnB63+taX8fuD5xBpqbtJbs16mc4feRr4ynjRX7CZNVl2jDeZ8QRO9UVR
         zq/M4UR72XrBR6AF617Cy102ibfRExjE44JR4DvSIe/POkeQOAz7x5HHa1An2vIhjdkf
         uNKGyYFlYP8YbTz8RP+fr/pjb6c80fg9JrgCeKpn/8aY98o7aNT6ckZQ2VWSwlRTkd7r
         wT8Q==
X-Forwarded-Encrypted: i=1; AL+hErH8Z0t2ybLi8E7M5+MDIX7rsR9DKe9w8eq+WnSDjnvhgDOIjL7+odzFMRVTykVG0V+1ijfO255wTw==@kvack.org
X-Gm-Message-State: APuU4Z8dP0q2xB25aZfca6lXciVsASdVNBudbjppCcTuDjaotDuUXEpf
	7pdB9G6aTgvTRv+FoFNoOKYfx6nkUvCYU7wj/ueijRcL1xTIfJOPl98/
X-Gm-Gg: AYBFou3xtbyKV4OBED2r+GoQOLfq6oKFfId+TpN96xHsszBwIjNBe8nLwPeyQAZrhPr
	KH+yUllqIRyD3bnNzlsYkvPvpH1Afv2N041iLBL2TwdgeMyf6qGpGdSycimCHoQUzJS2kuR0p4M
	yhP0d71sUdw9RyvLPBZ3IOynHK10aZ//xzOoH9vydvnnnzqsrzEBws40t8I5jz20i8F4x/woWzz
	yLMlZyCfkfCKAfvWvP6d9wrBg4cV+eYm5mnA3aw8AkJxHBUpeAjFzJF7WE/KzMVZOEVXWclg/LH
	0yX7dmGM22Hj3iVKZ13nYNzeF7zb35xG1RRweiKKKd1KnRlAvAeL7pRiLzKEn/XZcTn0PG0/Ma+
	GJDlGY+5aIalCKJ3wBJayVj2DLIOHKEp2K3VBlIkpY37fefJml1ulCH0Y/vbIv7yrExHQvOCJZL
	qsAY7+jybnvTtrUOit4NNhMi9T+cHoVXCvINiKTRJO7cLxKdXTy7Ai09SXf7GnxgDr0ivxxIprI
	hiGcVnmafg4FOz91+AX0yuiSk8tsw82bCikulmKwVzU6621m6f8UTQHU5r9LXD6BiL+7BgYuu+y
	dB9YdKHbyALejXkOA0lA/XbaVxEH
X-Received: by 2002:a05:7300:3b03:b0:366:2893:7421 with SMTP id 5a478bee46e88-3751e6acd4cmr2378114eec.10.1794280957102;
        Mon, 09 Nov 2026 19:22:37 -0800 (PST)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bf3e18sm4159008eec.16.2026.11.09.19.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:22:36 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, =?utf-8?Q?Lo?=
 =?utf-8?Q?=C3=AFc?= Molinari <loic.molinari@collabora.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, Madhavan
 Srinivasan <maddy@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Konstantin Khorenko
 <khorenko@virtuozzo.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 3/4] mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com>
Date: Tue, 10 Nov 2026 08:30:44 +0530
Message-ID: <pkwd8k6b.ritesh.list@gmail.com>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com> <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79F154000B
X-Stat-Signature: nrqfxukosajnwcp59d5ibwcrdoc8dwb9
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794280958-450594
X-HE-Meta: U2FsdGVkX18KUnBkhnHUF15I3zFSbfxuzX5e8X0mHtNF0vNVw0xD5+27lYdP00qx4Y1cXw5X7xG0Yb5CcsLbYh0sZGzX2AbdtX1OtEhIgzhzYso5llFO+QQyaOFMVap7Tf2lr0gg5iL7sB9Dz2jcKD5862BO8q/GOBS1EHXoxW5uPy2lpyxNmR0oMQXoWW5d9v5FY5u0v5ogXh0rvb70mxLKTfQMFNhlfbi1aC4iACuoAqNX4nu8GhQzMuLvB4HD3tKINET144o8p8zl+BFB9Vvr4+WrKM6MoO12/QEWRlPH6eewBrT5e3X12Caolp3kcwNm+LVWbfDakDeiuJtPowoZH2ZScdlksSOpFq62Q1MaWaNe3T3JZ0niRocL6m8M6WZmagGYTi/+U3ibFaheaepoUjZisYgqW2PuP1I+ZlqSbgYSrRwq2BN+c4IzJi/dHu65GAcOs1TZE/sKdYgBK/q6PJQzAKY4tSRSwznc90xkmyTvty2GCgbvMexjyNUttumv0H+Qfkyq8dumDmLoDBcYVvDRir1b44WbHIQC91ZaVAWdnozTocueeD/Sh6zRTQ9elKFVcd64AE8OFT1FblKq8kzhQ5DAQPyQb4ou/elaWjU3z8GqQ28OrQHouqoxgU2iD8jsEm7Sl0lr7B4isd/ICiUIjLS02FsITrIOGYMQyTfgaTopbp0Mhw6YBFe6Mq9XJKIBKraqxTQyRSwNa2soan1Dpit301iql1S/QSQ+REfq4YsSb9GQTgfwUST70QEIq2mGjYS7LvPbb2LMhaC6moe67aDoht9Gp6/BdLH94pBAIz2sL543cIubUjXVOEa+a5hWeY0BHKHFVJMQqb3C9WoX2BzQf1fYirrvdOp73jah7fgPKRkSd8jaSawC5Qyva+hSX23L6UwKcZ2r8POFcraHUD0lHZA6dFCSci7drRWdi5aqvSnOvA2mCAmKbpneGJ+V3R1KrrT3soN
 oRSUkoCS
 5z+ncLeR1Fv3OCYTYiW8YJYsEColbbnuBiY2mSQ+AXvxxscu0/LrLzlfnyJ6d6jzlgJb8TsuuEl/rl0qKz0d0EXDquBszbtIHuokBiNU2od3E6VbpmhD5DJ3Vlo/g4F6qQolBEm+ldwCCGEWfXsRuxGz0E2Z0aJBWCK/0EDXK0NtT+qnu3qnjDdtbEden3yzSUc8U44i7QyZLlI6fZo5y1p9wQqqXL+lFN0gcW8bNv6q/gdL5ysXWf7aKmTnzoWQJFp62ntvHMoPOCUoxM30fhkpZooHrGz9sUrlLu/+BlaKCb0rHAGR/QARzXrvNQ19YToksO2/356PGbOu6LDJnWnlsCEjeSnXJAuopZ5YQNk2skKYKj4sBcEneI/1SEFtgnrdoz92rFk+jgUc6KZCOAijyNpgnPRb3jW4Dsw/+4ynCU78FS+33yRNT25PmhFW4FX61sk2coz+3BDx1cQRa4xgrlxwnoBI3FHaa/XvdGoAKxZTsYJ06xBx4BWXkC7l07dvASs75rjVSoTdHpfhL7wyMi4CkonhidQLdKwVee7Fym6DoVI9+CvtlUo6/0pcNRUXoQiDgvktswPUI54RO22U7UcEdaxdLLQhmlnMVl3rqqjWmLwYjFDv9qrN3+0XneFRL2oAU6tVPlwVnMTtMVTdfYN2G0ouedAPHym411wcRezdWfqofFVYuTdPiiIwfRorcrcWBGVwl4v3+1AjiXBu10g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Konstantin Khorenko <khorenko@virtuozzo.com> writes:

> copy_huge_pmd() reads a special PMD without the page table lock and
> copies that value to the child. The mmap write lock held by fork does
> not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
> lock.
>
> The zap visits the parent VMA before the child's, as dup_mmap() links
> the child right after the parent in i_mmap. If it clears the parent PMD
> after fork has read it, and passes the child before fork copies it, the
> child keeps a mapping the driver has revoked, for example:
>
> - vfio-pci: the child reaches the BAR after the device memory was
>   disabled or the device was reset, instead of getting SIGBUS;
> - panthor: the child maps the pages of an evicted buffer object after
>   the driver has released them.
>
> The same branch deposits no page table under the copy. ppc64 in hash
> mode keeps the hash slot array of every huge PMD in that table, so the
> child dereferences a NULL table on the first hash fault, in
> __hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().
>
> Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
> from a folio under them, as copy_present_ptes() does with
> vm_normal_page(). The zap clears the parent PMD under the same lock, so
> either fork finds it none and skips it, or the copy is in place before
> the zap reaches the child.
>
> The copy of a PFN mapping then goes through the same tail as a folio:
>
> - it gets a page table where the architecture needs one;
> - in a shared mapping it is marked clean in the child, as a PTE is;
> - in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
>   protected instead of a warning being printed.
>
> Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
> Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")

Thanks Konstantin, for fixing this. Without this patch I can reproduce the problem on Hash
on Power (on my test dev setup), after fork(), when child touches those pages.

[   62.543247][  T242] Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
[   62.544992][  T242] BUG: Kernel NULL pointer dereference on read at 0x00000000
[   62.545335][  T242] Faulting instruction address: 0xc0000000000a0ee8
cpu 0x0: Vector: 300 (Data Access) at [c00000002035f9d0]
    pc: c0000000000a0ee8: __hash_page_thp+0x218/0x560
    lr: c0000000000a0e14: __hash_page_thp+0x144/0x560
    sp: c00000002035fc70
   msr: 8000000000009033
   dar: 0
 dsisr: 40000000
  current = 0xc00000001fb08480
  paca    = 0xc000000005010000   irqmask: 0x03   irq_happened: 0x09
    pid   = 242, comm = vfio-fork
enter ? for help
[c00000002035fc70] 0000000000000000 (unreliable)
[c00000002035fd30] c000000000098a40 hash_page_mm+0x688/0x8d0
[c00000002035fe10] c000000000098dc8 do_hash_fault+0x140/0x368
[c00000002035fe50] c000000000008be0 data_access_common_virt+0x210/0x220
---- Exception: 300 (Data Access) at 0000000010001b60
SP (7fffde6dd7b0) is in userspace

With this series, I see that the issue is fixed. Thanks for helping in
fixing it. Please feel free to add:

Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> #PowerPC






> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  mm/huge_memory.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e00632edb3856..9cb5f99aba87f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1961,25 +1961,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	int ret = -ENOMEM;
>  	bool writable;
>  
> -	pmd = pmdp_get_lockless(src_pmd);
> -	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
> -		     !is_huge_zero_pmd(pmd))) {
> -		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> -		src_ptl = pmd_lockptr(src_mm, src_pmd);
> -		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> -		/*
> -		 * No need to recheck the pmd, it can't change with write
> -		 * mmap lock held here.
> -		 *
> -		 * Meanwhile, making sure it's not a CoW VMA with writable
> -		 * mapping, otherwise it means either the anon page wrongly
> -		 * applied special bit, or we made the PRIVATE mapping be
> -		 * able to wrongly write to the backend MMIO.
> -		 */
> -		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
> -		goto set_pmd;
> -	}
> -
>  	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
>  		pgtable = pte_alloc_one(dst_mm);
>  		if (unlikely(!pgtable))
> @@ -2021,7 +2002,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		goto copy_pmd;
>  	}
>  
> -	src_page = pmd_page(pmd);
> +	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
> +	if (!src_page)
> +		goto copy_pmd;
>  	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
>  	src_folio = page_folio(src_page);
>  
> @@ -2061,7 +2044,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	}
>  	if (src_vma->vm_flags & VM_SHARED)
>  		pmd = pmd_mkclean(pmd);
> -set_pmd:
>  	pmd = pmd_mkold(pmd);
>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>  
>
> -- 
> 2.43.0

