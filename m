Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B872C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733D36B008C; Fri, 25 Sep 2026 03:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2766B0092; Fri, 25 Sep 2026 03:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D41E6B0093; Fri, 25 Sep 2026 03:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F536B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:27:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B23BC160582
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:27:33 +0000 (UTC)
X-FDA: 85251454386.04.5FA5974
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id F306E40004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:27:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKJ4FlN5;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qVH4xy3bEZql7DbItAa1RNXdUwDHnSm6EwoBaYYWu8=;
	b=lLiH+et9cssYtHU1gcTfijdgFA0IEVu+kcagRcNnR05XMfrEJFedoCLlzcH//qmsEivNDQ
	16PXHFZfn3hv/xwGlseAG5DvN2dtelfrVswypxW9rbqOjRUpFpzuHy9vYQVGX4SDUC/7zD
	mYy10LTC+YmzhTyD8eIBOyAdX2ADWDg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKJ4FlN5;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321252;
	b=LyYYUgaIpf8HsCRX69Bf0angrLbEVFhSelxfRXYu6UVY8OUd4i2BaBijMFAq4f9238/Kyn
	mWPdT+Yk/RTICNZHTlEnQOJOcMaJkk8dZINJhc5EL22e/v4Nt5yoUtwD6fKwh61xMJLlPp
	JM2xBSE45nf2id7dGV3hIP/E294fLA4=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso4591035e9.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790321250; x=1790926050; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2qVH4xy3bEZql7DbItAa1RNXdUwDHnSm6EwoBaYYWu8=;
        b=NKJ4FlN5IVKrRfSKuZsvp7BMAUSbtb4g/g4J9kwvk2unu4OCNYqCAxjJiExxHlE30F
         yoJQCgHvhhGMDK2TyOTUuTboosJWEAAfF1jbvInmTgBuktWLY9is426dTXtflxH+/oPl
         dybwyL7xMLb1PJweE5swLPxdnE12IFghUV1F7n0BXuafPtZJN7jDw8d1SyOua79JHRgc
         91pV8iWnovvaJUbMwOkN5lv5pO5zuhoFvqd7zSG9anVUu078cWgZHI5Au9NrihA84Pxq
         TlG/N5CWFpL2PvY6LexUATmeWbS00L1mqX9Fh+zYa6tddfYBiVmmBSz6DK03H2DkFVe/
         /Hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321250; x=1790926050;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2qVH4xy3bEZql7DbItAa1RNXdUwDHnSm6EwoBaYYWu8=;
        b=n81OdQP7ojVKV+IVOi4s8pr/LjgHN/lqXJS8JP/dIdxtzjZE+zn7QM9DOrh1BBNkLL
         +R6JgQQrpjf1HZaDYOXFBwjzXAWVqRGMpcCILVvLNbHN4ad7nUqHhbxiZ52hSmaFxG4x
         VRm/HcFRxmqXrsvrEZspiCbQJWsRlh8zSaCddpUscAjB+73ueKRg/tpIyib4+l8E7kk1
         mqOzIj897tIpOgr6OcBDLNKfVtMdQ4rQiANdBTGfL4Fl6kwTWuZmm4lci93I5UdwEo4m
         ENQvIcpGVOxK1/DUvRs35b+Jy2pcSlRLXzces/bzy3XJW+9swqNrITYyyk9OOyo/+P19
         YA2A==
X-Forwarded-Encrypted: i=1; AKwUvBxBuBv89ZznFSk8acThFLN5MPjU4X1hdfhmfHWu8xi6TWb72RNNqgR2HkoxUrdrXbhjhJldQtUxTw==@kvack.org
X-Gm-Message-State: AFuF++nwxRCAQ7e96LVa35bFdscFnicoY/fzPpWNsVmAf2zPguKzWPVj
	WgpBUC+VkO3NEvn20Z7tLvsZ5w9SF6jXPsWIjjKDFvzRtbf7gGNUHN8u
X-Gm-Gg: AYBFou1T5PXD8zy09HPdXSDmWJ4lcKVMYFxt0n13ghrcNjjcoiHH92HZNVXH4XJy3ab
	20hztrrGNonAl9bZsWptbXLj/SoGyL6YXf+5rCc3D9KdcTv6FgLjx2+0AL99pBJfBST14VVSwQW
	3OoU83xpBnXeEHKBKmOZgaGS6vd0Z/Dr7igMMPE/SM7nOfvbvN3DD60JtVoBS5+i3nsYwMM+TMt
	3Aqsx0aiVxJqvsYf6Vwg4Z2JBVaw73L4XIQaAum6iMNak2B3z4+uB7fBx4pXg+4uBelk6G3SPNj
	wdLYcA3GvUKjohqa/JvBp0++0XlH1PoWoPu2PpyaxLq2VRthmX7EOB0Ck6NwcjiE7rxBKK8prwd
	zKy2B5QT9tqTKuNSqciLPjvDc73KCQSo8NG/9kPXsTQpPQoMl/q0FTh/DfjUI+F3fpuH+VtylhE
	csrneL7YFcW77zLLR5hA/XDgdXsN4K9B1q/fK/x/IaxxaYWr3/pCvLUHxGa+s=
X-Received: by 2002:a05:600c:3556:b0:49f:bd3c:bc24 with SMTP id 5b1f17b1804b1-49fe6708a46mr82223855e9.31.1790321250356;
        Fri, 25 Sep 2026 00:27:30 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fee9203f0sm32571675e9.1.2026.09.25.00.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:27:29 -0700 (PDT)
Date: Fri, 25 Sep 2026 09:27:26 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, linux-mm@kvack.org, regressions@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: don't schedule deferred kernel page table freeing
 while booting
Message-ID: <arYhPon5nrixAm3I@gmail.com>
References: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F306E40004
X-Stat-Signature: ykychcki4atdp8kcybbd7rba7pds3hg9
X-Rspam-User: 
X-HE-Tag: 1790321251-939395
X-HE-Meta: U2FsdGVkX1/94J/FbB7yW+DHF8PvFkwROi82+BixarMj4ANSZkEEEVBXERRsOs1mtIK0C77YRBUdJne2g7jT35oUP9Qit6S1mJ00fZ+4Jofb90yog/8CDkh9VbkYS/ff3g8hIbxjjEm+2eB8Aumv1L/khALSlAVYdk8XW4+46xHeWMCnHjIo0x0YGWa1bOOAld0Uulf4UZgM+P6zjLwz9C+0xfmvXn1OCygjp1MxuGc7MMZDEPr552t8cQ2Vis9gISJ1ub73zndj6sEeKgkwev5++L0FbSJ0Av/Rx7U2kNM7oVPou7KiONxKKTacvaLNXuXK/qfEHd/rW+GkqN+RkmPj3byC7vVjmTEzN4YYxasR1teUuTwkBgJdEQfjQkUsg7k1RniehZ6hIdAomLunxmNNh7PZbr6wxq5IaMqDkX5MBaVc8jU2iNZ+bKTFNH92M+82gvgoyHsHRLZ93fwQx1muucFqneU3DyqCs29jFaA0RqSzxKvBIQYxarQttSYhW2JuhQrf7xgepHpDWBnAU3yTqlJECqVlXGQ4TxfEHaVgocegYlI1n+aBA2kB9l7NkCg5FG2Y3pJLQhETBaqgJKSwFTNWV9h7+dTvckghOYPB2qt2Pa4PTU+0/IlKHLisnrZbY6A3osbEQa1U+sYGFGekk+glTlofUhiEJMj6+kBlIk7IqiYWLovQy1DTt+qfPyR+zhvqT1Q+3YvrGA42GY2HXnhYavH9WX4fSTNs+ca+XBfFzkNaSgoxfdKUe8CuGGkH9R0hL5P6cUtVgbTR6NIWLP7HeKogZF/CeJNiscbahne00kqNkrZClbFdljtnXFEkk6ftZvs4MMEG8tw1dSnhiOQH0yZTUbV5ybGFWQNhimgXd/rFlXqIOWmXeIP5sPY8zFHlrRzENiac8qFFtnzo2+PKSs5r6pvzX1CpCIC1NDC+AAeLew2Yy1psY0+YNovXKlJA9FpnA8ny7Mj
 zZml2v10
 +UkyRXtXrRKOny8HknDyz+e30ACIFFzUIvsmw+kLnyFzFA+OXY4okCzTMXY4xlN7XSwYnfcjKAT7TMJI6P8EO8HhB+POWm8KcM0jpqAp61PpyqkugQj6XQb6sXB+nFblwbmimP/Ls6Vq902lw08UJfMMWcs9gwTLpbEVaXv2VN4oXumfqbzNrqYiZW3Xipw7ZhAyvO9XEccanKYizakXDadWUsH5ZwuPM4kdILRC/w9NpZSfTy0bVYdSrmj7/1eTAo8XMY0XTNi1iV/EFR30dcCE+bT8vJjvZhmJDYko8foXpusx8Zu9i+O1F4alH7Ps9ewFNEvqcD324FNPKYn6lFlcR1kioaLHxoAiz0kwhwl3LGT5uh0uTDbPgXA6VV15abbGaQj5ABI+8BPaBd1sT6DWEF4W11sHBIH2MHXMGVyhHx4PyOs2BM5xWVEQDEVKVDAn9eZ7z4a+odoi6B63RM4xhA1qRzG7K54yfXH9vWVAYUC4BocGwyKzUyCmaQ61cDQioamSsaUwW8yM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 10:06:47AM +0500, Mikhail Gavrilov wrote:
> Booting with a boot-time function tracer and a filter, for example
>
>   ftrace=function ftrace_filter=pud_free_pmd_page
>
> panics on 7.3-rc4 as soon as the tracer starts:
>
>   [   23.531178] Starting tracer 'function'
>   [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
>   [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
>   [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
>   [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
>   [   25.981629] Call Trace:
>   [   26.125727]  <TASK>
>   [   26.413912]  ? pagetable_free_kernel+0x20/0x120
>   [   26.990283]  queue_work_on+0x97/0xf0
>   [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
>   [   27.566662]  cpa_flush+0x394/0x620
>   [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
>   [   29.151729]  set_memory_rox+0xa2/0xf0
>   [   29.584018]  create_trampoline+0x431/0x6f0
>   ...
>   [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!
>
> The boot-time tracer is started from early_trace_init(), which runs
> before workqueue_init_early().  Making its trampoline read-only splits a
> large page, and CPA collapses it again right away.  The split table has
> been a kernel page table since commit 9e4a3ec3411b
> ("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
> collapse frees it through pagetable_free_kernel(), which queues work on
> system_percpu_wq - still NULL at that point.  That commit is correct in
> itself; it only lets CPA reach pagetable_free_kernel() before the
> workqueue that function relies on exists.
>
> Keep putting the table on the list, but don't schedule the work while
> the system is still booting.  A core_initcall schedules it once to free
> whatever was queued by then.
>
> Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> ---
> v3:
>  - Schedule the work once from a core_initcall to free whatever was
>    queued during boot (Lorenzo Stoakes, Dave Hansen, David Hildenbrand).
>    late_initcall would work just as well; workqueues exist from
>    workqueue_init() on.
>  - Keep the fix in pagetable_free_kernel() rather than skipping the
>    collapse during boot (Mike Rapoport): that would only avoid this
>    caller, and any other early free would still need a workqueue.
> v2: https://lore.kernel.org/20260924092307.22813-1-mikhail.v.gavrilov@gmail.com
> v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
>
> Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX (lockdep, KASAN),
> 7.3-rc4 plus unrelated local changes, by booting with
>
>   ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func,kernel_pgtable_drain_early
>
> The boot that panicked without the fix completes, and the trace shows
> kernel_pgtable_drain_early() and then kernel_pgtable_work_func() before
> any other kernel page table is freed.
>
>  mm/pgtable-generic.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..cd227fc05d2d 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -438,12 +438,30 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  		__pagetable_free(pt);
>  }
>
> +static void schedule_kernel_pgtable_free(void)
> +{
> +	schedule_work(&kernel_pgtable_work.work);
> +}
> +
>  void pagetable_free_kernel(struct ptdesc *pt)
>  {
>  	spin_lock(&kernel_pgtable_work.lock);
>  	list_add(&pt->pt_list, &kernel_pgtable_work.list);
>  	spin_unlock(&kernel_pgtable_work.lock);
>
> -	schedule_work(&kernel_pgtable_work.work);
> +	/*
> +	 * The workqueue may not exist yet while the system is booting.
> +	 * kernel_pgtable_drain_early() schedules the work once it does.
> +	 */
> +	if (system_state != SYSTEM_BOOTING)
> +		schedule_kernel_pgtable_free();
> +}
> +
> +static int __init kernel_pgtable_drain_early(void)
> +{
> +	/* Free the kernel page tables queued while booting. */
> +	schedule_kernel_pgtable_free();
> +	return 0;
>  }
> +core_initcall(kernel_pgtable_drain_early);
>  #endif

tested it, boots cleanly and the panic is gone. LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

--
cheers, jose a. p-a

