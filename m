Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9651DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AAD6B009D; Mon,  6 Jul 2026 13:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312006B009E; Mon,  6 Jul 2026 13:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228196B009F; Mon,  6 Jul 2026 13:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013C76B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:48:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8802C1201BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:48:44 +0000 (UTC)
X-FDA: 84959086968.17.71144A8
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id B7CD91C0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:48:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RtCUKs2D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHIujCKTOGPNugTb5N8DODxujrY7RJkaEbg7hUbcIIA=;
	b=lg55JLK2amzdJS3WSkup5DDXLh9RvIl4F+BJJW3Opxk78VNXH5/T2ez+GSeQa/2Xif4r7o
	WpWEJ6G2aaIa4VFYJZmh7tCHR8uaK8OmMHeH+Dq9fjmMl+JYNGkMes9oKl1Gmcp7bswe6d
	Q9SbJ2G+A+z/9rPvo40YuJ4qQMXZsRg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RtCUKs2D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360122;
	b=Qg4lfp0Y7+GgU28wWSG/XzdINN6As7MmNpaZoHfC7RiH67yTqmeYKwdJUAFL8bo3n0wKUg
	aX0DSKYWDeRqBhGQ8vlkmiwQnB9kBgiIDRzu9TM1dZNvyQtR7btXppfMRrWceYGWgpC9Ue
	O/49Kxgzc3c7haj2QJg1DzTdBXv54Ds=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3804e42ad5fso4154694a91.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360121; x=1783964921; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jHIujCKTOGPNugTb5N8DODxujrY7RJkaEbg7hUbcIIA=;
        b=RtCUKs2D8gF6dKLOrQFnGuuN5v0UwCzAvY7bqBVqpcET6vqCpPb2POoLsstEhbP0uB
         p5M38QaAqS7OodZTErjrkBUGYQd0A5nV57iBzA1UfdEO8A7FpjMPJqorb2vULl7zJUWb
         4OsLXvK9cHUuhXP0Y0ryErnSfFcH1r3i2EvrAFJKnebDDhwlRaPSbgfPId8/WzvAhzyX
         ChL8DydXB1ACUka0Do96tvPYGMCewlP/GRpPpJF7HxS9Cwg81QnCiSg+nu/Y5ZoRlVCE
         z3EJZrfQ/FKaNsqV+wgc2485Z9VL9Cg2cW+tT9a5LmgFlExMH7tChQUq/gV622LgV8Gt
         71Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360121; x=1783964921;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jHIujCKTOGPNugTb5N8DODxujrY7RJkaEbg7hUbcIIA=;
        b=kmex6+JgOwR4tOOscs52QS0DFufJXaIbkXe4Y3d59sriGw2LjckcwAT6t0Dz8CQBG6
         BmZCtxGgDg5ICUYNaXr+f8KEp0LF2UA105F32hZqriO3M7e9wtRZ4In/pRinYgOwY+BN
         xm5hQE74P/GqGglRenpkH1fKDNJOcT4qO2Jyfu3Wp8NeifGvvBDCX7NMBdl6910dG0LJ
         HQQhLwpGHQkqg25pcVrX2fjfoidKugzqTbWaA/oIarVxdE8m4JF4pNLjMuLG12W5i0Cl
         SnyBDGBQrur56eS81IsdZ1iPTUc1rjuXUxsf/wa5NsR/FPSZ0J91vaHacpBtrKEJW1MF
         e8HQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro3UUHEqwl0aSvcCCTkvczueI23LGVOwvqMW8SeaCQizxM7jduSGNueRTv+zxVfVErw8QWMt/gcrQ==@kvack.org
X-Gm-Message-State: AOJu0YyDIWFrEmTu4XEsCryM5foITT3cl0t+/8WGv2TamoJ//ocsk/aQ
	i7eMq721fV71iXSfZDXHYDIwODnBX19O8Uw+twpBJN7qG9cjJB/1u4Oy
X-Gm-Gg: AfdE7clwLrh+i+f3gIDXUsDmQioL490rIcdmsDfnxbnDiZoCO2x2tcX3pOxB2wdNraO
	nhiS2Mxlml5dmYMDpvpTb2nBbWDpUHOqDHXyXUynclLC/YuZSKt6u6Bp7VxkZ4ed5xo1xwSWT+J
	bHUZXzG5lJL8mTRyYHO9qbTTu6rnjLRdU83iG5kmzSDZaxA6Y1C4GicUkCljnfNaiZCGlVRPVxV
	sFMo13govTRc85NAXdhM29vmIoJCvo3+2ibj02v/01ADFSjr9cSldvk/8TBm040lnk7MkY1zpeJ
	WJTl3zq6Fyg5NLV3mT72R7ZFo1s7w1n47WOmqGjzKkWdkWMxjUJ23D1lwnLKUwBlfEANiG0BOGv
	dM1D8671Np5NJxeqIfHj9J1+zcNt08kZLJF3unuTmRc8Ye/cOxjRN/D3RwJEJS8tx13m6WPrRB9
	2eamVVpt5GvUpq97pLiQ1j4hscvtDGUZ8v942Rw1gI0fdh
X-Received: by 2002:a17:90b:3f88:b0:37f:9ce1:cda4 with SMTP id 98e67ed59e1d1-38759019fc1mr1587029a91.26.1783360121520;
        Mon, 06 Jul 2026 10:48:41 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812801e8d6sm5515562a91.12.2026.07.06.10.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:48:40 -0700 (PDT)
Date: Mon, 6 Jul 2026 10:48:38 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2 0/9] Convert x86 pgd_lists to ptdescs
Message-ID: <akvqdoZI-jCn3lrk@fedora>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
X-Stat-Signature: qu694gj3capu314zf8uubog3in8amkfw
X-Rspamd-Queue-Id: B7CD91C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783360122-973060
X-HE-Meta: U2FsdGVkX19a50TaWZM0x9UZkhF6AFjb3wkA2UWLzFeQuR883edimsYaCrHp8R5cMUnVlkrJ116WiTXWbWGFN6QEQbyEt0ROvKUwhZPQaPXuYPTvrOQXKxg3wsNxrA5P6Uzd2ZjwwXQDTGB2gSXwppN/t3ELWJJJsGTTup92oFcCJhKnYFvEfaD9ejVCyGCNa92GphRA6iiV8+yoeu6kY3E1qEH3v3ue4/emw201opopevLjjpap7D6sUEsuHyDxAg4HVId443bxJgLFgMPsAQnVuhyu8SBF7KX607mATxOw/0x5VYZTGvBeZIST5rhxOeHVIqJ/HVJJgp2Z2eEg7k67LlRWh+wzpfzghTw4R5Z/X+pA58eCJz98djKat5STO98Pt6pfdp2Se/KAdwgv2WFvppj1m4vsOI/6l1P5a9bPQEnIXxnwYqyrE30fEIACTCP/FLcFvfwO5hN3eMJHB1ZtwzJHhdQXigHnEu8PlnBws4zqCCPLW2VLZIgaSW7JRRV5x2NkbHh0GxjZCU+e2YsStQ7WVqQ6TzSwjK5g3pXb5yYk8KARtkmoGK67sPIsU+vyNO/P0zAp3cObg6FFwRyfLh9vd3IBtRUgHTk7YYMJT+QbOvRQA/kcQ5npBnPyzL9ELNNYaqY6/YTautEJXKQgUEwTuNPaN/e02DOXbp+uzPZVsRN3u3MVxB3NSAhzCP/qZhuoXwUutAEeLnBlRFiSLdD/bQxupmYri167IWx3z/orgMHnL1528miDcyuKlrV5UEB2nnx5Adki7ub0P+ibvrOGTRaphjL2ZVymJbNDE/pAYgtIedltR1b84eVWHcSvpp2Ip5Bq72+v7wIoItkv0GeVrg5nFU2zjXdvGhKwrDdF0E0CWQ/8+IceQ9tcLQKfWzfAg2DhpIWedLOSDn5xxRWaqgEU9a55Kg9SsjNwtW8PHNbFT7l5/L2IXa3QeZbycYYSwCSv0iARhXU
 n4RtEU1E
 lv3BeNLCv9VoBNusu5KAQZBvQGn8HXat0znG3zou+neyFs4u+XV65G6mrND7EhqnjysiX6wW5qoE4vE6A/ThdH+paCK6T/hu3MRTr3SCqFR9FH72kZ1T3MpM1Vlj7rFTaZpWeE+Rm8gfukjw8JIxvjsoUUjWNvCNpCeMqLMqazbxqePpok6yU+kKmRETA3yIivQNc7f8cBZJti1c9S3TNUpDtu4DtPL8KsKQfoNW042st+AW8VtE5XL9zXtkfjkXPqfD9TsfGo5pHPiT+fk1EVlAJYefqsXW7Kwb4krGWoQ+RdG5MVMfsLmXpEX0qILWCn6K6mFj+zVF+JdUU12GJ5kStxrd4yTeQwatrZ122BDw/91bPv8S3lXpMxSny5EHv1CPrz80vo5Vyb3E4PvHvk1w4IRikaNopbG7BEg/jJooeR1QCjV6ENZkxIc1oPUHRC8MIdQJzBN87B/puj2JZkn9onSko6thXWBDi1IEtnzOZR9lpygINqiQTW3nh39DRlW6TmtRnmmATRzBjv6otDq9Gi64vhRTEC5AeChAiK1Yn99XQ8cPL1k7yhEJtOldT2NAy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:57:33AM -0700, Vishal Moola wrote:
> This continues the ptdesc conversions for x86[1]. This is a necessary step
> in preparation for the separate allocation of ptdescs from struct page.
> Once ptdescs are not wrappers, the pgd_list should be used to find our
> ptdesc, not page.
> 
> In fact, after patch 4 we can successfully boot a 32-bit x86 kernel
> that separately allocates ptdescs.
> 
> All of the patches are rather straightforward, I just kept them split up
> for ease of review. There are no intended functional changes as ptdescs
> are currently still wrappers around struct page.
> 
> [1] https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmail.com/
> 
> ----------------
> 
> v2:
>   - Collect Review tags
>   - Rebase on 7.2-rc1
> 
> I've compiled and booted both 64 and 32 bit on a kernel with separately
> allocated ptdescs. I ensured the codepaths were hit for all the changes
> except Xen.
> 
> This applies cleanly to 7.2-rc1. Dave, can you please take this through
> the x86 mm tree?

Hi Dave, will you take this through your tree? Let me know if there
are any changes you'd like to see, or if you'd rather this go through
some other tree.

> Vishal Moola (9):
>   x86/mm/pat: Use IS_ENABLED() instead of ifdef
>   x86/mm/pat: Convert __set_pmd_pte() to ptdescs
>   x86/mm/pat: Convert collapse_pmd_page() to ptdescs
>   x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
>   x86/mm: Convert sync_global_pgds_l5() to ptdescs
>   x86/mm: Convert sync_global_pgds_l4() to ptdescs
>   x86/mm: Convert pgd_page_get_mm() to ptdescs
>   x86/xen: Convert xen_mm_pin_all() to ptdescs
>   x86/xen: Convert xen_mm_unpin_all() to ptdescs
> 
>  arch/x86/include/asm/pgtable.h       |  2 +-
>  arch/x86/include/asm/pgtable_types.h |  2 +-
>  arch/x86/mm/fault.c                  |  8 ++++----
>  arch/x86/mm/init_64.c                | 16 ++++++++--------
>  arch/x86/mm/pat/set_memory.c         | 17 ++++++++---------
>  arch/x86/mm/pgtable.c                |  4 ++--
>  arch/x86/xen/mmu_pv.c                | 22 +++++++++++-----------
>  7 files changed, 35 insertions(+), 36 deletions(-)
> 
> -- 
> 2.54.0
> 

