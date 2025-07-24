Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1670C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F376B009A; Thu, 24 Jul 2025 18:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606736B00A2; Thu, 24 Jul 2025 18:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CA06B00A4; Thu, 24 Jul 2025 18:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 413836B009A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:27:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E25FD11367A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:27:34 +0000 (UTC)
X-FDA: 83700596028.26.F8C37B8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D763A20011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:27:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YgCBz5K/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396053; a=rsa-sha256;
	cv=none;
	b=GKM4J9FLJ0fJw7dctp689Iv1a2N9P3xEfiNYThSHvSpk4j9SYehWz0IQo8BKp4rHtsS5in
	H08OWhUNPYc0C02Tutj/61Tc4k6twrD2Gaq0rhxR1muY5a1gSL7zlOLIxkTF8EPuuQN5Ow
	LDz/UjG3rO6dPfSPDZBHEOnCYJaCyGo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YgCBz5K/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdkxvXYV1D1MezZXWXKeg8AUG+QiWG5386VJ0uuWpn4=;
	b=o4X7PWfnjjnpDWJjVWAI0uqj+Ny5Q3zRe6ln7LEet68d9+OQPVbV1Y7a6xGSMTxXzswXrz
	n5VKT3StsN5QkaZTRMSDI7QEUA+F4w1ybJvTjdMU6x+9y0cGI/bWiqWP1e8k26NnD7v66D
	TLlIejz0+xUTyHFHxHy2c0tw5ghvC4E=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a54700a463so981431f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753396051; x=1754000851; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kdkxvXYV1D1MezZXWXKeg8AUG+QiWG5386VJ0uuWpn4=;
        b=YgCBz5K/T2ad7zAAbXkc8kFnbWI2rsFX1hp9KLHAh/e8Ml37F1F9zF7jLCITVQ/kdM
         CADNekimN5Sh/CMMldCEUOYpH7HDWYUMlfYL1s7+y8eD1sNoKr9jsFrdeEAMuun/mF8z
         dE8sDPAs8oH1blBrmeNaQSwhfBb9S2FaWIXAEh2N7yB42+fOSkQQ04u8xct7Lnfn3n1n
         p8RZn6BMcvcqLBP7NUZSChgdjudnflibSdoL8It/YdUcbZiXWGkVjaZdCFbqKRnD2Lu4
         KZlV2kkzeS5a3LhUXrNkrrysMlPH15KTfx9PCRIal3WayQ/pDUNmM4osVoqsCuwfglRq
         r0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396051; x=1754000851;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdkxvXYV1D1MezZXWXKeg8AUG+QiWG5386VJ0uuWpn4=;
        b=sqkPWFpZwry7IdEbENr4GubJJZ/gclw4YE5mzPBJuiZCcAIrgRTCDN68ds4lGV+fZS
         CkoB6pdu43/s/3S+PubFmh8XKJpz8UBrrx/4uZ9EgQbfQRe4gGAN3tWI45QK91o+CBJE
         N1TylGHXSJigKGa3zN1mtqsWKbry2biAyX+LOYuPVATW9NvXLpFUqojvSIYuS7YZmzvo
         6hQn4pvZ/4/ZcirXR7gBfZ1G2lD6keULZikKxK/rLNxdFS2YC6HFvGVcEeQE+Wh+Mvnk
         mlvOrXvV2pSoJRi8JOtosONZ6huxBY5pE/j7WoDtMHIK4gZBQqbPtwpGHhK0+rCz+j/Q
         Ffcg==
X-Gm-Message-State: AOJu0YzrYXRScek/Lt4SxZ7qy4eC4DMDiH3w+j8LsMGfLFiCsSjum9GJ
	FtxmvTp7/VjAjC301cPAnulyVgCQemh6eIWr3BJNLxIObfAYHmLl4o3M
X-Gm-Gg: ASbGncvFCFWKb/LBGN08MJbqm6RWzm3S3ZgCXjaJMH830UYJwV9SUY3MzILZI+oCucQ
	rF4LGiMXs7ut32l/Wn6nPwiUVnXYigx5vNdWIQl6/I5z4TBsup+IdrSUPKi1wgi3d+uyw465iLf
	OFtNLDkKeemjtg7aBnyWtcDOYiflw1mMJz+WjpjmECj5UVWweMAwQA7VsddefdtSzcILqbZhzSJ
	UPiuWyeT5XrJ0/c+paRRmNdBnDD8Ry9qh3rnNrIunYCASqMcnILJjsTBz+FRP5TBdi11JgbFfck
	Iwrdc8XMVc0tbo7ZV+q6dFg17/1seOkW1OTnxsmQFwhN+qQKzt1mbkCnBCt2KeJyWmj0I7mLgjr
	uL4fPIJU9ugSb7CFR7bOZQwKjxdnnf1mtFCnpBmr8mH07ip/SrzURLfMvVfwfAnKqB7np7v1lnY
	qIWZkWTDX13HON9O5xJ1kT
X-Google-Smtp-Source: AGHT+IFyHNIR9eZnX6927KLgXv8HWbQyVdZCWFZ8/hlhXiyIO1E9ae/3HuNltJ/DO2eKAukxzmYnPg==
X-Received: by 2002:adf:a2c7:0:b0:3a4:e231:8632 with SMTP id ffacd0b85a97d-3b771355208mr2526117f8f.12.1753396050739;
        Thu, 24 Jul 2025 15:27:30 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc605a4sm3285674f8f.14.2025.07.24.15.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 15:27:29 -0700 (PDT)
Message-ID: <99e25828-641b-490b-baab-35df860760b4@gmail.com>
Date: Thu, 24 Jul 2025 23:27:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, SeongJae Park <sj@kernel.org>,
 Jann Horn <jannh@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20250721090942.274650-1-david@redhat.com>
 <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
 <601e015b-1f61-45e8-9db8-4e0d2bc1505e@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <601e015b-1f61-45e8-9db8-4e0d2bc1505e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D763A20011
X-Stat-Signature: 3cwrxptj794u5kxkb7r1e589nu3ubg7g
X-Rspam-User: 
X-HE-Tag: 1753396052-757006
X-HE-Meta: U2FsdGVkX18ZAMZb6BmUIY/SsZ+oBH59bU6a3cCGznsUU4458LADxxA1fpFpCocjhVkCTwGEVBnTiznvqLpXR7RaXKTIob7mM6pl+/Xb0qz1lC2GmZcdbeJf7zXWU+2FupCNqXPAXjCmJQdOBY1Qk4zQ3iTLhdvFk3Cz44Y5t3oPyhfSlBYoAR+iUSFP1dYfhOAAljuUkYfebip6u9w2kxVfPZ3Q4HEGYO7SLg4ydXr3qXts1Ya0+rRGWaY1ESNcFZ3kRH8LDo9sx0qqqNoH21cVYfmwrliSjjR/6zNBI1HOl8lsEg0AlAqzmwEaqbuTGgtiWMT8RhXE0xoSXweFJoRJGwJXS94uOr/zeKqkRe/vvF/1V2khmCvR8PJcvzLBnDEZUZ7N5DEtWkJHXNYAz/EX1EBpGTcZXjRupEB5ST1cuj2UZdBBCWjtqP//f0yyxuCVNRUvEvOyRmfIOd6qMCSFlPDOKHd4MZ7TVJGAbmBcWiGsM+XrYOZf8GPRcZ2JJMkxwFzKULCpxTx0x4dGPoD8paBsSyfv73s8pW224Z35m26rWIHfIze1Rcm+MDfgJ5SaQoh9ElEeXVWCvuds0cd7dlWdvqwl4DOCV1xWX7po3e1i0WXyzB2yPS90sFohkPj7gLzoq3qeCpB/DqlilmZSy04u/MuAt6RArWFjfMDxWrKetG6Cdclt8yQ1hOO0nxlRF/5QXDlMiRzIPEdb1OqGqQRRlAvu4JspgdNFKjJ6kk0ULiOAnihgb0gMBMtF3TSqqx7rjZFbjFF3Rma69ijjivhKzPdQdiRZIYNfY/f++MVXVb4Vc/WPXbaajs40wVKZbUyq00NdWdXoa6cBrosNpYXSVnalL/fOKiOWSqoqIiCeDMV8GR40RcvtRsTU+0mw11lUxk0aK2O8/QuwcHDuuT1Ed9YdNaJKC5XVBLi8WFWsl6PgYuXxTOhhGSkAs5en9JYieHI/zolEohe
 AKnpO/Me
 PZIN4t7xrs4gCdFhKKnEwKEXNjBNKwRtq46UDjC3Xk8UEzEymRNibOVZ8ZJZ+e7sMu3G0nWNNrjEV88Z55f+coZnXblWh8kz5xW5zZdPZR8oqkOQ2Q7cfQmyc/UiM/9KJoPSOYINVGXj1UWUttGJidhFxrpcbV0xAfBZPHG/vWBvk/3ibGp8f0PzlUwZCfUK6BGUAOsiZDbh7c+KT2jKTWVCeL+Z899zDzBelIyGvOx01ftJOnuIo7XR3EL+IYgOVyOc1EtS4z5dWXNKoU6Riot0Rj0M1XvtYoBr4eTWG1fMwEGCUUoyAO74n/+p0Cvu04IxIp/QvVP4NvKuGhxHigeoO+aFgGmOg85ZPaXcu7IkTYzeRBWrIB1zy1silf0Rs3AiO9/f9etbV/00+7l4izECU1F0podYDuJBSyNUtt9zO8DpZDh5RgCLHw4tYVhRVOdqi/siD1eBDO7ET5PlzZreP49QhIxTshg3N0SV9UF6hpuCUe09UHCGRGJXKtZ0xO1304ybXBABY5fIgfxPq9nSRd3eoj2dkvO/1pLkPG5bCEF7XP/7xCK962LPZvwLMKaXeX7tT88o70q4+nhm2WG7QpO75ebGeKexOuQ4cCYbs5ZUoWpeP90d5HHwrIh66DWMXCmE0o2mP4GyR+TXn5ndVXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Hi!
> 
>>
>> Over here, with MMF_DISABLE_THP_EXCEPT_ADVISED, MADV_HUGEPAGE will succeed as vm_flags has
>> VM_HUGEPAGE set, but MADV_COLLAPSE will fail to give a hugepage (as VM_HUGEPAGE is not set
>> and MMF_DISABLE_THP_EXCEPT_ADVISED is set) which I feel might not be the right behaviour
>> as MADV_COLLAPSE is "advise" and the prctl flag is PR_THP_DISABLE_EXCEPT_ADVISED?
> 
> THPs are disabled for these regions, so it's at least consistent with the "disable all", but ...
> 
>>
>> This will be checked in multiple places in madvise_collapse: thp_vma_allowable_order,
>> hugepage_vma_revalidate which calls thp_vma_allowable_order and hpage_collapse_scan_pmd
>> which also ends up calling hugepage_vma_revalidate.
>> > A hacky way would be to save and overwrite vma->vm_flags with VM_HUGEPAGE at the start of madvise_collapse
>> if VM_NOHUGEPAGE is not set, and reset vma->vm_flags to its original value at the end of madvise_collapse
>> (Not something I am recommending, just throwing it out there).
> 
> Gah.
> 
>>
>> Another possibility is to pass the fact that you are in madvise_collapse to these functions
>> as an argument, this might look ugly, although maybe not as ugly as hugepage_vma_revalidate
>> already has collapse control arg, so just need to take care of thp_vma_allowable_orders.
> 
> Likely this.
> 
>>
>> Any preference or better suggestions?
> 
> What you are asking for is not MMF_DISABLE_THP_EXCEPT_ADVISED as I planned it, but MMF_DISABLE_THP_EXCEPT_ADVISED_OR_MADV_COLLAPSE.
> 
> Now, one could consider MADV_COLLAPSE an "advise". (I am not opposed to that change)
> 

lol yeah I always think of MADV_COLLAPSE as an extreme version of MADV_HUGE (more of a demand
than an advice :)), eventhough its not persistant.
Which is why I think might be unexpected if MADV_HUGE gives hugepages but MADV_COLLAPSE doesn't
(But could just be my opinion).

> Indeed, the right way might be telling vma_thp_disabled() whether we are in collapse.
> 
> Can you try implementing that on top of my patch to see how it looks?
> 

My reasoning is that a process that is running with system policy always but with
PR_THP_DISABLE_EXCEPT_ADVISED gets THPs in exactly the same behaviour as a process that is running
with system policy madvise. This will help us achieve (3) that you mentioned in the
commit message:
(3) Switch from THP=madvise to THP=always, but keep the old behavior
     (THP only when advised) for selected workloads.


I have written quite a few selftests now for prctl SET_THP_DISABLE, both with and without
PR_THP_DISABLE_EXCEPT_ADVISED set incorporating your feedback on it. I have all of them passing
with the below diff. The diff is slightly ugly, but very simple and hopefully acceptable. If it
looks good, I can send a series with everything. Probably make the below diff as a separate patch
on top of this patch as its mostly adding an extra arg to functions and would keep the review easier?
I can squash it with this patch as well if thats better.

Thanks!


diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3d6d8a9f13fc..bb5f1dedbd2c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1294,7 +1294,7 @@ static int show_smap(struct seq_file *m, void *v)
 
 	seq_printf(m, "THPeligible:    %8u\n",
 		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL, 0));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71db243a002e..82066721b161 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -98,8 +98,8 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 #define TVA_IN_PF		(1 << 1)	/* Page fault handler */
 #define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
 
-#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
+#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order, in_collapse) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order), in_collapse))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -265,7 +265,8 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 unsigned long tva_flags,
-					 unsigned long orders);
+					 unsigned long orders,
+					 bool in_collapse);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
@@ -273,6 +274,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
  * @vm_flags: use these vm_flags instead of vma->vm_flags
  * @tva_flags: Which TVA flags to honour
  * @orders: bitfield of all orders to consider
+ * @in_collapse: whether we are being called from MADV_COLLAPSE
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
  * hugepage orders for the provided vma. Permitted orders are encoded as a set
@@ -286,7 +288,8 @@ static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       vm_flags_t vm_flags,
 				       unsigned long tva_flags,
-				       unsigned long orders)
+				       unsigned long orders,
+				       bool in_collapse)
 {
 	/* Optimization to check if required orders are enabled early. */
 	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
@@ -303,7 +306,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders, in_collapse);
 }
 
 struct thpsize {
@@ -323,7 +326,7 @@ struct thpsize {
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
-		vm_flags_t vm_flags)
+		vm_flags_t vm_flags, bool in_collapse)
 {
 	/* Are THPs disabled for this VMA? */
 	if (vm_flags & VM_NOHUGEPAGE)
@@ -331,6 +334,9 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	/* Are THPs disabled for all VMAs in the whole process? */
 	if (test_bit(MMF_DISABLE_THP_COMPLETELY, &vma->vm_mm->flags))
 		return true;
+	/* Are we being called from madvise_collapse? */
+	if (in_collapse)
+		return false;
 	/*
 	 * Are THPs disabled only for VMAs where we didn't get an explicit
 	 * advise to use them?
@@ -537,7 +543,8 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 					vm_flags_t vm_flags,
 					unsigned long tva_flags,
-					unsigned long orders)
+					unsigned long orders,
+					bool in_collapse)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..ecf48a922530 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -100,7 +100,8 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 unsigned long tva_flags,
-					 unsigned long orders)
+					 unsigned long orders,
+					 bool in_collapse)
 {
 	bool smaps = tva_flags & TVA_SMAPS;
 	bool in_pf = tva_flags & TVA_IN_PF;
@@ -122,7 +123,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, in_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2c9008246785..ba707ce5a00a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -475,7 +475,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+					    PMD_ORDER, 0))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER, 1))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1534,7 +1534,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER, 1))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2432,7 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+					TVA_ENFORCE_SYSFS, PMD_ORDER, 0)) {
 skip:
 			progress++;
 			continue;
@@ -2766,7 +2766,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER, 1))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 92fd18a5d8d1..da5ab2dc1797 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4370,7 +4370,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * and suitable for swapping THP.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1, 0);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -4918,7 +4918,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * the faulting address and still be fully contained in the vma.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1, 0);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -5188,7 +5188,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
 	 * PMD mappings if THPs are disabled.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags, 0))
 		return ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
@@ -6109,7 +6109,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 retry_pud:
 	if (pud_none(*vmf.pud) &&
 	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
+				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER, 0)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6144,7 +6144,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
 	if (pmd_none(*vmf.pmd) &&
 	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER, 0)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index e6cdfda08aed..1960cf87b077 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1816,7 +1816,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, 0)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,






