Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B74CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FF98E0009; Wed, 20 Aug 2025 18:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907966B0010; Wed, 20 Aug 2025 18:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E0C8E0009; Wed, 20 Aug 2025 18:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE566B000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:06:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA2CD160178
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:06:47 +0000 (UTC)
X-FDA: 83798521254.13.EBD037B
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 89B0440011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:06:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VKTKtYXQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755727605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NMBndnzKPT1NoZpmX7E2y1iqzOsAWdhRbNpoiP8UFI=;
	b=eyjfoRg8SdgxUeIsonns59B7ONy+wDHsaYIPMi+eNFeALjf61kmGAqWLKRhYQjPdpQ+Ybc
	M+Kd6ib49OG0W82NbzTVBcluyKgaRg10j8Pd+/9mzRgh5cpAcEBIA5SrniOP3QoTycUDu/
	o98efCMUlqag1DquDsuE9kwpMi+KoQc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VKTKtYXQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755727605; a=rsa-sha256;
	cv=none;
	b=kEJzfEGugROjAFds1KLwtVtKJoGO6XrPvE/4KqmBdjRI1eKQJ1c0kFTJu962QacZ7AHVwV
	GL2j+dTEx+FbyxqX4UXmC90sljNp5+NWe3cFzYShakHAMGXu5No6Y0mymICkQ6AAtibBG7
	pmZa69KJptk9pHm5jn/hvcCgHzXqmAw=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-333f8f2d6c2so3246921fa.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755727604; x=1756332404; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NMBndnzKPT1NoZpmX7E2y1iqzOsAWdhRbNpoiP8UFI=;
        b=VKTKtYXQzUqGKEPLQGczXFf1+BdyH1cOjMHXKc7w2jGAA/b2ewWaIrYYmcyKhIOtQ4
         SgSq3Cje9AMzMNpGS3f6pwPcWIJ8utdiHV9ubaNa1N1LN9TV9lYdCB2Dx/DWWqWUHmSu
         HezkaUCPHd2sl4clbS2n/Fwndlwp3w/M854PQJeYr5drfN4M7f3l3mEiqlKEa3Wpc2PM
         35n+2z6sUWVDMwknYxgKrKAEOJAefxA5+n4bKRVoQJI5h5n1eUrcRXBztAPwHleMEfl6
         VlG7CpxqNANAVOB5umbxNrv+5b3g+TPImW6KfTragwqcb8P+2xm/5Bnk/mB8kJcZ/Ttk
         OlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755727604; x=1756332404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NMBndnzKPT1NoZpmX7E2y1iqzOsAWdhRbNpoiP8UFI=;
        b=mo5vP890uG3jGJu7yh6IUxvb1oO0qW65ZatJrDuAXT5c+3699Z6QCaYe2EI4+hKuxn
         nmVg5stSsopxjYBFDKEf5+Jgovex6Y6Dtvh/6fJnYycg/GI8SCMXBFH6nECDvMQ6k5v4
         6sj84JNf3fwI8BxLrZwYolGy/L7BEvGAcY7GT/gyZzNAZ1tpTFTRj74ANbdWaymOzW1w
         Vdlpd04KuwTbMMf1NIdjNX709ZDvqVqUgmuhCRc8UFumzek4CplWvEGEEuIXIB6IsuAT
         YGMLynQ2GcCU1/HzAKX8EmHrzY0AD/pMYz/w7f83cFsTjNtzJ/zWHRECQFtkpufRxmBB
         nMPA==
X-Forwarded-Encrypted: i=1; AJvYcCXc3oOJWrVnOrn/ZbxuL/SuGMVycq9k3ULGUxx+4zeSUBegB0njI3Abi5eM3/UbDp5y/VduhpdRfA==@kvack.org
X-Gm-Message-State: AOJu0YyPc50KCGNcv+0vAdF23N081VsfqMjMgf/2KlhRqq0xVKM5BBKq
	5ncOK3a+jR+IEvIOzQhJR7M8NYGApxRpSpTQYCFrDQAa5pimPyn+wN5E
X-Gm-Gg: ASbGncvnBaSp4Ri2CpLg/K3O0tJqeFjOxChGTBYltcu/mALjIWKtZ7sJn8A1eG1rsEC
	QbG5cutXnpbpax7BlVQCISiB05HxjACUBftEFKGD8V4xc9R5CsT+TJm39FKoEWvdbCAGpgd1EWy
	vno01OprmNE2bAFcFaSN+RwCEgh943a42E1dtWbJRYQalPi51+qytdcw6EDdKf3IfrisCQYMFaj
	Sr6VPovHKpCR3GhU+9SIOIxJn3bM7e8PPkXE/wZBnl1+riMv8/fRW/uxdXxpP8MA/DmW+hbZt4d
	OJbv6heupJSqVtju1tHsmN6OGjigNfBAwxo8LqwBK+S0cb/02xcUghTmpbwrCV4nW5fHavIvjo2
	3IZosLqAzIw5RGN14PNoReB/+7G3mMStkTfiVSgfsCgj2q8s=
X-Google-Smtp-Source: AGHT+IF8q3EOilMMZn6w1YadAvZXVrqgXu54pbYwks8gwAO14G9NBCldCXVPQPbBOIbj8OfT6v70GQ==
X-Received: by 2002:a05:651c:19a0:b0:332:3562:9734 with SMTP id 38308e7fff4ca-33549e15f16mr507791fa.8.1755727603283;
        Wed, 20 Aug 2025 15:06:43 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-3340a41d588sm31320351fa.3.2025.08.20.15.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 15:06:42 -0700 (PDT)
Date: Thu, 21 Aug 2025 00:06:42 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, 
	shakeel.butt@linux.dev, wqu@suse.com, willy@infradead.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89B0440011
X-Stat-Signature: hfqyaxii6i47p9mucsryt4yn3fsqsqxt
X-Rspam-User: 
X-HE-Tag: 1755727605-57006
X-HE-Meta: U2FsdGVkX18y7faYvKijPpt6dA5G8uix+iH5sFhIFzm7b3gRtSY0Q3+dFNOhViFoY+1ysFaoUqJCC3g4qAATrfRY9ahrXLSmVDgLJTy83FSLpF99k3FX4yEFx4ChpAh1LPQfYa5GJimRp/A13XXgn4n2FCL5soNw9cd4kwDR54cssS4v6xXwGd2fQ+Tc4olIuHMATPFuMcSYoIC2V3BTWUZlMejgeFEdoK+6tgudXfRWl3WPUeXK1SgR9QdkHhz7FvZYOfqRkO5rmAcMeeY9ofdPVaP/h+6JnoSfuYgTiBAtPyKhCX0ymuemX2lwX+8e2xRbvDT9+LzLZujxof/6NeZXtc9z+Rxkvq+oHSjyr7Iwor9KOD6kqHwa8TU3y3O0JVmPAby1s59S3aApCIYKXh9NcRUaNJmsYB6SNX9PRBicE5lAky9+i/4lJiCFD3yjG1BuY0B9BLjxyC/FDJNv/41IAA6ssi+G5/36fEzlgI2Xv8fdEgli68LVaNcLWPmvof+z++GD67lX2QGSCvOrVx77EO1hF8QNmAXiJmLwv76o6RNfKdF18sjmCe8sYoASpRvbb3Qm4htEAoiirlpzJZoU/pilydf5iJrodn5A8K9vF6dq+Pp4tryMRPFoQZZnAUsMm3uAxjpRpwa050v/EOmVvZQzvIfTL48M0/GmclecZmvXVDiP0IqlMarASrVdMsnm02AIDnJlqcivxYReR75dupfu7Fz/5djUY7pxvj95Z2C7q0URTz+Oi6i44IrgU82lxsjG9IHLLC8GwiHUbJroX4/B2KpfNaBCN9LdmbSGBmAkAIOYDKvcNVIYmJSqhJ/VNfdqLUHxtI9I1w5y4vfON7/zgE2cvIjGximkXqAulorgDGZZmTFpPStd5Q5qThDIpOdF4Gg6h/jLRZrvwY80b+OYPDOWD6NIhIFVN0Dxm9XdK4/JMjLkmM4HI7Cey1ptTfRHzjSy+I1K6Si
 f627TCYr
 /hdR96RjWvlQGHnDOzzWuVntJaYISO1Sv1uNC7i99lqrQWYSzJiW8I9IBHEDwOB8sipFjuRgG7ZyXUXu1tnJGZPtpDLR5KyxQXypymyLaN1xZoQHbmQd6TK0ycjpvznqqrNfn7PuOPpnmtZonlYJx88XOWJhs5+uc1FG8IoSXNKNgaASkrA2JukCltkE0bt5Fox5cn1/0lZ+AERNuwwrnJYVjI+vHCOsF5lX3lYM81IgLGcn6wfvigFWn+ph8Y5HB8M8MiO8/XJDlslEXif9xf6ZPAEkafIxS7ePmnquAUsO9F0oHnyn34Q9hEA4GRbwBmrFysBUQ/IAssBpNJBgfoMSb040cNQc3poD4N/O94D5pF7GZ4j8aQrj2qQ9930Nxps0FxuNucXOimT+ed/Pt+2GAd3NdcDH7KhqDibFR22h0miTnI9s2AUQkL7PSsKK9BkZS4z5AAZd3UbJCUSSx+14oV/rvFWNplAPrr57xrDs/jabNirzSuy0KSHKk2WD46i7tKWS9MXyWn3vrA9dOqiQeVyUeFHGjoBSOQlyJ/2+7AfyhTUPSmKvTz8SJHwVWWgK5a2jupJRhAUlPFY3KnNf7T/1DcBa5pQohrTKIHTKUaxDVY+5zq5Jqb6VJjkFychC9m5l4SVijK4oBMobTamwod5tJdmqHe+sZnQIjwi33GhACSVRkhfnv260liRD0x6d4KUcWqvQnlUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2025-08-18 17:36:53 -0700, Boris Burkov wrote:
> Btrfs currently tracks its metadata pages in the page cache, using a
> fake inode (fs_info->btree_inode) with offsets corresponding to where
> the metadata is stored in the filesystem's full logical address space.
> 
> A consequence of this is that when btrfs uses filemap_add_folio(), this
> usage is charged to the cgroup of whichever task happens to be running
> at the time. These folios don't belong to any particular user cgroup, so
> I don't think it makes much sense for them to be charged in that way.
> Some negative consequences as a result:
> - A task can be holding some important btrfs locks, then need to lookup
>   some metadata and go into reclaim, extending the duration it holds
>   that lock for, and unfairly pushing its own reclaim pain onto other
>   cgroups.
> - If that cgroup goes into reclaim, it might reclaim these folios a
>   different non-reclaiming cgroup might need soon. This is naturally
>   offset by LRU reclaim, but still.
> 
> A very similar proposal to use the root cgroup was previously made by
> Qu, where he eventually proposed the idea of setting it per
> address_space. This makes good sense for the btrfs use case, as the
> uncharged behavior should apply to all use of the address_space, not
> select allocations. I.e., if someone adds another filemap_add_folio()
> call using btrfs's btree_inode, we would almost certainly want the
> uncharged behavior.
> 
> Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Signed-off-by: Boris Burkov <boris@bur.io>

I bisected the following null-dereference to 3f31e0d9912d ("btrfs: set
AS_UNCHARGED on the btree_inode") in mm-new but I believe it's a result of
this patch:

 Oops [#1]
 CPU: 4 UID: 0 PID: 87 Comm: kswapd0 Not tainted 6.17.0-rc2-next-20250820-00349-gd6ecef4f9566 #511 PREEMPTLAZY
 Hardware name: Banana Pi BPI-F3 (DT)
 epc : workingset_eviction (include/linux/memcontrol.h:815 mm/workingset.c:257 mm/workingset.c:394) 
 ra : __remove_mapping (mm/vmscan.c:805) 
 epc : ffffffff802e6de8 ra : ffffffff802b4114 sp : ffffffc6006c3670
  gp : ffffffff8227dad8 tp : ffffffd701a2cb00 t0 : ffffffff80027d00
  t1 : 0000000000000000 t2 : 0000000000000001 s0 : ffffffc6006c3680
  s1 : ffffffc50415a540 a0 : 0000000000000001 a1 : ffffffd700b70048
  a2 : 0000000000000000 a3 : 0000000000000000 a4 : 00000000000003f0
  a5 : ffffffd700b70430 a6 : 0000000000000000 a7 : ffffffd77ffd1dc0
  s2 : ffffffd705a483d8 s3 : ffffffd705a483e0 s4 : 0000000000000001
  s5 : 0000000000000000 s6 : 0000000000000000 s7 : 0000000000000001
  s8 : ffffffd705a483d8 s9 : ffffffc6006c3760 s10: ffffffc50415a548
  s11: ffffffff81e000e0 t3 : 0000000000000000 t4 : 0000000000000001
  t5 : 0000000000000003 t6 : 0000000000000003
 status: 0000000200000100 badaddr: 00000000000000d0 cause: 000000000000000d
 workingset_eviction (include/linux/memcontrol.h:815 mm/workingset.c:257 mm/workingset.c:394) 
 __remove_mapping (mm/vmscan.c:805) 
 shrink_folio_list (mm/vmscan.c:1545 (discriminator 2)) 
 evict_folios (mm/vmscan.c:4738) 
 try_to_shrink_lruvec (mm/vmscan.c:4901) 
 shrink_one (mm/vmscan.c:4947) 
 shrink_node (include/asm-generic/preempt.h:54 (discriminator 1) include/linux/rcupdate.h:93 (discriminator 1) include/linux/rcupdate.h:839 (discriminator 1) mm/vmscan.c:5010 (discriminator 1) mm/vmscan.c:5086 (discriminator 1) mm/vmscan.c:6073 (discriminator 1)) 
 balance_pgdat (mm/vmscan.c:6942 mm/vmscan.c:7116) 
 kswapd (mm/vmscan.c:7381) 
 kthread (kernel/kthread.c:463) 
 ret_from_fork_kernel (include/linux/entry-common.h:155 (discriminator 4) include/linux/entry-common.h:210 (discriminator 4) arch/riscv/kernel/process.c:216 (discriminator 4)) 
 ret_from_fork_kernel_asm (arch/riscv/kernel/entry.S:328) 
 Code: 0987 060a 6633 01c6 97ba b02f 01d7 0001 0013 0000 (5503) 0d08
 All code
 ========
    0:	060a0987          	.insn	4, 0x060a0987
    4:	01c66633          	or	a2,a2,t3
    8:	97ba                	.insn	2, 0x97ba
    a:	01d7b02f          	amoadd.d	zero,t4,(a5)
    e:	0001                	.insn	2, 0x0001
   10:	00000013          	addi	zero,zero,0
   14:*	0d085503          	lhu	a0,208(a6)		<-- trapping instruction
 
 Code starting with the faulting instruction
 ===========================================
    0:	0d085503          	lhu	a0,208(a6)
 ---[ end trace 0000000000000000 ]---
 note: kswapd0[87] exited with irqs disabled
 note: kswapd0[87] exited with preempt_count 2

> ---
>  include/linux/pagemap.h |  1 +
>  mm/filemap.c            | 12 ++++++++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index c9ba69e02e3e..06dc3fae8124 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -211,6 +211,7 @@ enum mapping_flags {
>  				   folio contents */
>  	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> +	AS_UNCHARGED = 10,	/* Do not charge usage to a cgroup */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index e4a5a46db89b..5004a2cfa0cc 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -960,15 +960,19 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
>  {
>  	void *shadow = NULL;
>  	int ret;
> +	bool charge_mem_cgroup = !test_bit(AS_UNCHARGED, &mapping->flags);
>  
> -	ret = mem_cgroup_charge(folio, NULL, gfp);
> -	if (ret)
> -		return ret;
> +	if (charge_mem_cgroup) {
> +		ret = mem_cgroup_charge(folio, NULL, gfp);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	__folio_set_locked(folio);
>  	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
>  	if (unlikely(ret)) {
> -		mem_cgroup_uncharge(folio);
> +		if (charge_mem_cgroup)
> +			mem_cgroup_uncharge(folio);
>  		__folio_clear_locked(folio);
>  	} else {
>  		/*
> -- 
> 2.50.1
> 

This means that not all folios will have a memcg attached also when
memcg is enabled. In lru_gen_eviction() mem_cgroup_id() is called
without a NULL check which then leads to the null-dereference.

The following diff resolves the issue for me:

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fae105a9cb46..c70e789201fc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -809,7 +809,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || !memcg)
 		return 0;
 
 	return memcg->id.id;

However, it's mentioned in folio_memcg() that it can return NULL so this
might be an existing bug which this patch just makes more obvious.

There's also workingset_eviction() which instead gets the memcg from
lruvec. Doing that in lru_gen_eviction() also resolves the issue for me:

diff --git a/mm/workingset.c b/mm/workingset.c
index 68a76a91111f..e805eadf0ec7 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -243,6 +243,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	int tier = lru_tier_from_refs(refs, workingset);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	int memcgid;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
 
@@ -254,7 +255,9 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
+	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
+
+	return pack_shadow(memcgid, pgdat, token, workingset);
 }
 
 /*

I don't really know what I'm doing here, though.

Regards,
Klara Modin

