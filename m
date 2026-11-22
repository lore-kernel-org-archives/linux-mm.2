Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0841606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hqGEpaEJ
Received: by kanga.kvack.org (Postfix)
	id C2ED16B05BB; Sun, 22 Nov 2026 13:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05946B05BC; Sun, 22 Nov 2026 13:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0066B05BD; Sun, 22 Nov 2026 13:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 789C06B05BB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:03:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA92AC074F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:12 +0000 (UTC)
X-FDA: 85463526624.14.6FDF1FA
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0320C0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hqGEpaEJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370591;
	b=YtwDm37yM7ib7RK+l8kSFXxMrNms1u33urrWrYikROFR9H9TB6LWsu3mg1WuNvLYVw22pI
	NUjrxcqKNl8gBVh1j0XuzBLzTb/isaMuYuAYAiBvMD6COrPzOQVRdQtj8VKIuzl0rOzg6A
	QeuqEs86LtwL8DnB8gJ2HkdkH/BYuq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWsKXAM/g+dJIEPiarpqPbtvlz+whrT4/Vo/Gurv3ys=;
	b=Ibf+aUZOHqIVlz8kdUPIkQIHPMHeLgMyV1D9IZ0hIg5AcGS3jK0i5emO0+VkMzLxhWR/hz
	lTmNCKxhuZR8Tb65hCgHuSfqbELh3J/8544DNNJVycM7IPFpfP767CCXhAsP1xdWLBI2PD
	dbDMWWq5fHwRYvynAfyEVKBmIrQREQw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hqGEpaEJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d05d51553so17187915e9.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370589; x=1795975389; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EWsKXAM/g+dJIEPiarpqPbtvlz+whrT4/Vo/Gurv3ys=;
        b=hqGEpaEJzdv5cgV983Ttxvla8iT5Ux3huVsnEzMSr5IW1ilSknMOBCUyK5hsqbWeSo
         G9bC9U4XjCta5jvEwuRGsfKGTo8haXmBgDRTest45YVoZDi6lNa1D9ijNHsR3tVZtuLZ
         xtjM2HIRnL2nJ70qRkq3wZ71T85ZMVf6wdbV3JZB0Rd6bSK2AdPgjwvDLELdHXoxdLN3
         nt/AMN3gOhUJ8eB8mH4xzwEhkB936d5vFnWqMHwjSeIJshvXDWuzoFR0Q89iZzpMGp4+
         4pqANZ0Cs+JfdMDAcCN/l1HcXgSkpAJc5VSsFVWq5pVkYS2XYmWS3t+dxW1xhaxK6NiB
         6mRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370589; x=1795975389;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EWsKXAM/g+dJIEPiarpqPbtvlz+whrT4/Vo/Gurv3ys=;
        b=qAbkqi8ppSmZxQKs43RdmfjGY5U/p8Jok5wMYgGmRQNxNrr6vqGWVpoq/4ZUEKq6T8
         LS8YAln3Bl6ujMzZWzF6WKt4bFoDcd1dkBVmP4sU4PnkKmyUWuL+SlIpPJLHZFAuC5Gl
         VAYLQAhMC0+IYQ0DuQl2MEIC9At6amK7p932aBr7hrTBNcHmLpyOIdsSx35EbXkyZao4
         D5+H4Ktb68FXry2oCBI/dbDHsGOvGzrjBTDw/APrKjNcu0qmj0vzZT/YbsbKtH4B8b8L
         UQpFq6Yv1XoH0cZoLLe88/CLCdF+L5767qyBIlXVd6iEwa9rnGlrqU/SqzcdixV86eDu
         F65w==
X-Gm-Message-State: APuU4Z8d9ww2byukHorFObmCOD3uU1JhmgeDINsiKIx1dWkUx1ypKd0r
	CbUeP2+uLAGpX91yCxVFhUyN1SFaNOCMAutVSWXVlr21iGyNV5EBXGHu
X-Gm-Gg: AZFdTZcfaQBeSg6vladgEvqRbJtXiL42N/a/kMpY7vS0kjeItf4d8Iqq2Hs4nd03gjV
	4adSZI+W68WrsNpBCZNSXVfTZB2+KCyKCY2cDO2qaJurCybRcE8S6CKRJABuV4WayCeidQ6bj/E
	N96rzJxSEGCHGro0qcw5HuTnoLnxvaruIa8foVfft0Xqg2Ol3QX0Ic8xmEdzvs0VVz0h4JmpU2T
	8+Xi2sVkAvDnprdg7qC5wDr04VOgXDkVnvb/NIFR1MVvQaDL/anFQDcn0EHIfyfRs2bh0vKIj7G
	+Gq35dibBylPjaYo/YQAKWc8HWIBHvj2OhpyPZ3VZeANMR3K9e/2q1YWpcHa2GqF5tZSWa2g+mj
	e9aFp7Vbd+R8ciIMXN290Nj92TJGweXk6vo8qlWBHlNwvXKan7/+yssp7nr/kS/6ohVebzFSN9z
	XDtcJV3rWHyzKvIYK+AgOkIr340CVS7p6Nzyr/IuUMYxpvIyA5ivF0Qy+hPnkp1NreJRi3LYNtK
	fs2vyCOADQCDVqSIBjDiTIV4c0q8DmGYojsSaCHyY0M/cUu51XF6WkWhZTT0zYvwyNyy+fjPZIi
	6WDtMWJLAAiHpbmQPrsPSIMm
X-Received: by 2002:a05:600c:4e0d:b0:4bb:69b2:d3b3 with SMTP id 5b1f17b1804b1-4bb8881eea5mr202859665e9.27.1795370589422;
        Sun, 22 Nov 2026 10:03:09 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb9067846esm139868215e9.4.2026.11.22.10.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 10:03:08 -0800 (PST)
Message-ID: <725b9135-2e01-44c0-b30f-dab16d3932cc@gmail.com>
Date: Sun, 22 Nov 2026 19:03:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/vma: error out on invalid bounds in
 unmapped_area_topdown()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F0320C0007
X-Stat-Signature: qakinhg6mckic81jtyt5tqhjmj4gkoqp
X-HE-Tag: 1795370590-753258
X-HE-Meta: U2FsdGVkX181DBm4EpRMEWRUexh3ceX5Dzn7c/803TpLCsyWRJWD8MlmP9lqEWpRHQmuQvMZbPHLX0qjiigyRaZegTzZUEIg0VqV7f1YP0D1XUVgaAOVxMawZvmxzTYIU5rlxeSwWY2bmQ7KYiU9/AU6lrMAuxaLDqalzkU78wHMBy7vHBbB+MsRc2oHXqJP/oR/fGwznGayI6ROxRzQ3Kyd7SnGdt0zEFoNXQaOs1hLrGdM/FcJKSifa+EKcX5W8NEklx/STp8iMbqb7yBtsL5nyIoo47I0Fmr938j3NA19FpzRUJkvVYZxov+w6Tcvci4qmB0c3pzlx64j2nsdZ40+P226laiVNVbFuSndDM8L0gzjlPjZxA4h3/WVwXXquqGPWuqfi/sP45jqu38k6XL5RNptasRnaYk1uSsjx2hnR8r0TRn1Lu80/dJ5VSNcMgMrxuN/X3m2l7hb52Asrdq3aCuoqr1BFDtmf9ZJe4tpmifIDaxSMuFUI/ZF3To4LkBrZpUCz1EGw3JftFjp8YsOSI7nnHHImGTh13Otdgvetopk97hd3Dxmp0YDmZiSn8OA9ZJ7Q4UrZMlU2nvxFhwQxxkk/cxCQIPDP5Icx5oN5uR8rTsBZIy5PMm2Sls69N04WaQTE/BuWaSvHUbecCsbPedI0gativR3tIHKMHvMArvKd8aV/t9ttddBRjGwTou29Zc1h9K6cqrRKEVLEyJrf7qjxyKE4hMx1DV89arjS2L0S4stRKQ+sVsgYW8x1aq1y1Clt63db3N5VlDOG+cN6kp2XVidPMO4DDdbNZKW0lhA5iI0oT0/FLchqPg5M/TnI6o9+tID35jNYvQjROfr7xRwslkIVGRXWLddX2oXewqOwgz5VJRK7QxHBUSHW3U11lkKa4PghEiRUUyqFiA6AuEEYnVQqYjivGGB6rhSlBy0F92KBlwABkl46xs0fUctBuXPpnhHPk81GGT
 nSGgJ0st
 6i5p1Ylx2F0PHgBio9paqEORiuOgn17nMjB9fnoc6trYid65+5udjCnZTdiQ7HhyFANXFrKIUv8iCq5pkOz3grU7ylinnw3z+jYMVz3jUYOtbh3rAjZiwSlQyOmeX0WEG4Nh5poRaJmEx3RjU7ABXt6LCnM+qAmNoWRiuxoO/PbnEkd/r2zpLxBXgvzS76E+IatgLSxOIe9et+OQewkQVpYEaP9Z1GCfq077LD2skI2IYN4FOXz3u8BnCJ4RcumNJtreLv1OR+CS1Eig4HwqG5uENBbFpwB5zNV9QgzUrbFKVxeEc93Qx9IwvkKMqxoTB0ieTzD2pLxCIAXwR94cliAY6W+tOCHASH4SiTHpUALIXdAkg1haSgwrUm43j43BTp9ZmtXxpWo5YDWpr/SoGERzJvPEfSkgpsX8vJuDEQB1AZJjPSpOGquw+WT7L2Qmc2ru+lZapjrbQvY79vyKdvXn2YpMP1uv/WpDdOnR7uArn+uHiBh7myFY1b2+5SR8ddcWJhfUX5dY7unL8+RrZQRmgiH2l7a2gGy2XG0Xr6ILyE3WikXsxVJyYpdmxBxOn0ejegaEqzgEIxquRP0jIVvAJgZ1DLjiUIsywBxbMqMvpSD16kcWfFCj0o+530xkBBOm8DnYA6nY/kIiyPyaLruShcx3iIinrX4UmriXdGFOLwKxTAme9GZL8rVo4YocSYB9UFwFEsxRR7/kBWhPyyV9fSGYmkJmzgy+TEVm+f1bYp/4BYLaf0LKbOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 5:02 PM, Lorenzo Stoakes (ARM) wrote:
> unmapped_area_topdown() suffers from a class of bug arising from a mismatch
> between how maple tree functions and VMA iterator functions express ranges
> - the former inclusively, the latter exclusively.
> 
> This is problematic with an exclusive upper bound of 0, as it translates
> to an inclusive upper bound of ULONG_MAX, that is a range which extends to
> the end of the address space, and start < end or equivalent comparisons
> evaluate false in a situation where in fact the expression should evaluate
> true.
> 
> unmapped_area_topdown() calls vma_iter_area_highest() to position the VMA
> iterator into the next highest empty range spanning [low_limit,
> high_limit), iteratively reducing high_limit without checking whether it
> has reached 0.
> 
> This can result in a [low_limit, 0) pair being passed to
> vma_iter_area_highest() and thus unexpected underflow. Consider:
> 
>     vm_start        = 0x30000
>     stack_guard_gap = 0x100000
>     info->length    = 0x1000
>     high_limit      = vm_start_gap() = 0
>     high_limit - 1  = ULONG_MAX
>     window          = [low_limit, ULONG_MAX]
>     vma_iter_end()  = ULONG_MAX + 1 = 0
>     gap             = 0 - info->length = 0xfffffffffffff000
> 
> The result is page aligned and below the IS_ERR_VALUE() range, so it
> does not look like an error. What follows depends on the caller:
> 
>  - mmap() with no hint can fail with -ENOMEM while space is free. The
>    bottom-up fallback is skipped, and __get_unmapped_area() refuses the
>    address as above TASK_SIZE.
>  - On x86-64, find_nearest_trampoline() can pick the address for the
>    uprobe trampoline. _install_special_mapping() then inserts a VMA
>    whose vm_end is 0, and exit_mmap() frees kernel page tables that
>    every mm shares.
>  - On powerpc64 with the hash MMU, slice_get_unmapped_area() can pass
>    the address to alloc_extended_context(), which then writes out of
>    bounds of mm->context.extended_id[].
> 
> mmap() can succeed with an address from the wrapped window where the
> range above TASK_SIZE is too short for the request and its alignment
> padding. On s390 that range is one page, so this takes no more than the
> default stack_guard_gap.
> 
> Fix the issue by converting the loop into one that explicitly tests
> low_limit < high_limit.
> 
> Additionally, simplify the logic by declaring the VMA iterator in the
> loop (it is reset on each iteration anyway) and exiting with the correct
> output value on success rather than performing a goto when an iteration is
> required.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 58c5d0d6d522 ("mm/mmap: regression fix for unmapped_area{_topdown}")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

