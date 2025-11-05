Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB85CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE9F8E0013; Wed,  5 Nov 2025 04:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3778C8E0002; Wed,  5 Nov 2025 04:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2189B8E0013; Wed,  5 Nov 2025 04:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB848E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:01:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D40E01DE5C7
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:01:19 +0000 (UTC)
X-FDA: 84075959478.27.75028A2
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id E589C140015
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:01:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ByDv8TtB;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqwAluvFQHR3rGs29bqhyFCcj3SAHqQXu+Y8BdSkuwM=;
	b=ARoaV1w5poPSRG44U1EMfkCJHwG78lUuCmF5KjWdVsVf0HRdBIGHVPu/yfuCiuc2UxAVJO
	vIpJd4N3cclJyGCNLLwWRF9+4wS3k4feZA2/tUfF5nyZ/374BSZ0g1UR5WpHrm8/AWPm8X
	WLplUitgx+dYUnyOxxQ3v8Kfe3qThwA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ByDv8TtB;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333278; a=rsa-sha256;
	cv=none;
	b=U/XV0lvyEaM3FwgN7cXwewnmBQRN9FC3GsjFsUd/D14NJc8koNhNCjhrHb/8LECQhQQSbM
	yT9/172Prljesf+CD3pWYZiJ3YR0ZKEpcm4+vwrwUGNAJ0Hqrsy0mvgHRZ3qzVii1YfY2+
	Hn3EkHIGNePOActh+uXbLBjoUO9ZuWA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340a5c58bf1so3609701a91.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 01:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762333277; x=1762938077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqwAluvFQHR3rGs29bqhyFCcj3SAHqQXu+Y8BdSkuwM=;
        b=ByDv8TtB7w+Wn91Q4H9+M40Mqu5aTixK/Mz1mj951Bl1ZHXGnOUN2l3QiylixGV75y
         H6g0sCj8qhMVojqSkfqODUdsgEEUOFv+Cmowpe2C/JN80C374vlxZF0SESqej+rS/v9X
         atyqHazxCwgcBkGHpBGuRpC9aJ/yDFw7ShowVMdfhUBynIvv6JH6p4j87QnJE5f7TDBC
         qi81Fr/10a5PwhtH7rptXuAU81Iz7C0Ow10kMtd0iPyB6mgoqAf1I9mp7txtF9C3SaR1
         Uh9weGDcmd44ezd4xBIOfB3b2L09Ebjm94bxLGqNrQdbXPP5QT2WMiO97bkmW2xnphy6
         LuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762333277; x=1762938077;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqwAluvFQHR3rGs29bqhyFCcj3SAHqQXu+Y8BdSkuwM=;
        b=gSIh7RW6aNqBKtWPrGqUJO29pXjqmAJLBYbKApRTutoHmVcvPiiEO2PzGjyHvehipO
         +wpsNpO4ZeNkujLpWfC1d9cs6A+3jzWvc753pd4vezq/eP6J6+m+XgTQP+l4heNObT4M
         bg3Iei5oXWY4jvZ+kmckqLbsKMIv+UnzEhy5jOcUdoQyCeE/HWpQpIy6GEgmVaUnPqeK
         C0A8L5gwRcBGCjeGVVINawFp7/Zf+YS2PWxHYoK07q1PBB1ukqiw1TqZ36MnEkD0V1yd
         qKY4KEl48vI85TqkcuLEimwR2ZCNBAxosAKIzRqfEbNYvGycNVhM2Fn5Ifbji7DzlwD+
         OHkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbdOG5UwQRSaMkylcWAPzKRz7WunETfVLdKUQdfw4nbqNb62mrhNQ7pY5GhpSMi5Z+LleeCFSXSw==@kvack.org
X-Gm-Message-State: AOJu0Yym7//IRHwyanv1awS1tB4RvMlnka+AsOdxIQLDOpmxTTO9Nqkz
	yaQEuvNmWc9zFFBjmgzjG18q2yVRlojwWXwBRlMrXv5eJeTtmFSL0DSs
X-Gm-Gg: ASbGnctNypFTKecwQMvAX+hE36hQ27qCF+6QiGAbPu9VUiRklxrFgtcYto6VMYnxzpG
	FaQNL28Lk5lOh56eHwg5VojI0dmNPi3WUxsb9V3mucbjs9QlePO7D4I8LXyjv4yOgJPfx1mIsSA
	HFu2rL1WpE5FsvA9HTdhxNQ5uMRh4iLQw5vgxvalLHtfqvsREgK901nGIUmtWB1x/KK2qxlNggH
	9AYp14zn6VlN5AosClNKubeYNs9yt5WBn3cdSad8c8BcBY+r6TSdUnMAcJzwgZEHEUkkhhiKgGE
	P4sXpAGQTCQgBE+Gyd6ftTG2MXb6u8F1XOhV/vTyCAxR1Y3PCbdFKSbsFQb3YNCuJqyPCnaUcP0
	22zn2i+GzZ++26F/Sq9csM4nIZNUGna2Q9VTBXgPOLYKiyFIBOOgi8PqRh6Kqp2/dbV1B+CMSJJ
	FqT2ED
X-Google-Smtp-Source: AGHT+IHHv+LyuTSVYYYzkbgRnz7hULJzgzWM0oNnTXqbUlny/y0AGDg1tLVk5Pgi5QjOwQ4eknTvSQ==
X-Received: by 2002:a17:90b:51c8:b0:340:f05a:3ed1 with SMTP id 98e67ed59e1d1-341a6dc8735mr2732523a91.21.1762333276313;
        Wed, 05 Nov 2025 01:01:16 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a68c822dsm2153637a91.8.2025.11.05.01.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 01:01:15 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
In-Reply-To: <20251029100909.3381140-8-kevin.brodsky@arm.com>
Date: Wed, 05 Nov 2025 14:19:03 +0530
Message-ID: <87ms5050g0.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-8-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E589C140015
X-Stat-Signature: sgaz6pwnkkecseotb543d9y4yjarmgkm
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762333277-819786
X-HE-Meta: U2FsdGVkX18K2xX/fP8DB2HIRkwBzZHMc/OUIGPoPCm+NPtwPQBaQoVB/DeJ17TOFmhyfjQYfbPaSBT2UcevkYkyqWJm+5rKZ6c+cEiq/C8Fq2gua+qiwVUKesuUZ3GNUy1xDFSbx3lCfsraL7z1EzbvsNwLBXkPcnHbAFHlrfpurldLqC+TvIX80N64Tca5AuOSsTxoqq4wMoyLKH7/QKwmmaiG5UpIN6Ywdn5QcM5nVr7cf7kAzcsA3oay7ySA8qtuGKaTX94l2O7NRm4phbJyT4Yb1NX0pfUzsj2FlzJJ5LjU1U5oG7uaPYUh+cD3ul2GFsbFPBMxvwIx+x+J9fjz8NR2jEgkNWT6KcCh4pSMRrQys9eUtCC3hV5apMUxb3jrZNxhjieiZXH2l3yL+Bn+O3rWNIbzxG+xyORb+Y5O3TLQZm3YR/GE5/9QEVHVETUZSXGoaFNchTFkIy/1IfmhyAIaju0qowQ5Dlnwki0BJs40zseL9V5uTW/cviNXU2qugwyELOpLH0jW/E6747RPZ7NJqxokzBOVerSW25vFysBaVDCb1A3AwFVfwIzmOGeKy0Uxx+Z9XdKNdIhRS8fYHETvqZFNi2QZLHHH0gZ5rW9pRGpS+kd7oc4r0lguYz6wOUb2PAy2ngzBqouKrgqvccXEteljAqvJoDc/4w1pC2hBMopRefAiwHhe3nl7dE78djzcgTX/XGCwlkrD6GvqzXyeLbldn2O9ZONysBWe3WZ3nBJ2wC7MjA+xQMYwukJRaL9KgXxqooRvDCJztnh8jVCzQF1A6OdcbC9keSLMd2je9cdJRJeoJRs7OMRx+Oocl0M705bPPTPklNbrDVu8midYUwqXYnsuaIT4ppXsCwRQcrIGsJ0LFqMyz51h6y4vNJ0/sADhPfv8veVqYmI5nCNwgaDGMWLe3IInbP4N4ADbsPMuKPOZCdmPAkh66wcGajKd0ThCqkLRuhL
 umSSrue5
 qHxXapq49wSHXufHEkdGKYqr0FMYHYB2Mub9hJQ1DBDL1Vy13zx3ktpmudnwzCKYRVin4stRn3CTMNB1PhsSJxYactzo+f7KccU/t6T3/gUnqBx8sZ4YSHKoPia3y7ctgRCEHMWZRcqaTMpnYX7Q+8I7uCpCD8yIdHH53TfwdQAkVi5Kd1G10iivWP8Gse+t/QlJEmxNEF5Vj1FWpwRHElbqa+Z9Y+jR1FKUQeIi5q+MZDJyO9PK8qg4qdzNsFLzjqQGkTN1jX5Yzq/I0sdP25ofbCwjc3V19v0ZO+IxJ69CzQMnLRiSc6ocyIZiFHGXYcg3qoFbd8XuoZ5pBxgS3nFByxwRYGh8q1tufUJlZXGkwzefagZtoGfRmT12LBbSRYE7Zt30IvoMDprAjoWELpwdycBzEQERefwxF0gx9k2WE9anACYgHaOmr2ybzDnECgNixS5LbmfYJ+ZHpBA738SKlbvANzYBFYPBIHGDRjMLylh6QRGmVFNNNLaCB3YbCJ6RoSAdcwQUjd26aqzC3JI6UNVZiFKXEjWyaeUMLvAcTKKxTh/30xU6HY2cN2BA+5+20oiBxiBGo7C32CLKXiyMD99lCftCMWQR0iLhKOrZ+AvPXqtgl4XmawU0TLgVWiVVPvA814C3HzvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> Despite recent efforts to prevent lazy_mmu sections from nesting, it
> remains difficult to ensure that it never occurs - and in fact it
> does occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).
> Commit 1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested")
> made nesting tolerable on arm64, but without truly supporting it:
> the inner call to leave() disables the batching optimisation before
> the outer section ends.
>
> This patch actually enables lazy_mmu sections to nest by tracking
> the nesting level in task_struct, in a similar fashion to e.g.
> pagefault_{enable,disable}(). This is fully handled by the generic
> lazy_mmu helpers that were recently introduced.
>
> lazy_mmu sections were not initially intended to nest, so we need to
> clarify the semantics w.r.t. the arch_*_lazy_mmu_mode() callbacks.
> This patch takes the following approach:
>
> * The outermost calls to lazy_mmu_mode_{enable,disable}() trigger
>   calls to arch_{enter,leave}_lazy_mmu_mode() - this is unchanged.
>
> * Nested calls to lazy_mmu_mode_{enable,disable}() are not forwarded
>   to the arch via arch_{enter,leave} - lazy MMU remains enabled so
>   the assumption is that these callbacks are not relevant. However,
>   existing code may rely on a call to disable() to flush any batched
>   state, regardless of nesting. arch_flush_lazy_mmu_mode() is
>   therefore called in that situation.
>
> A separate interface was recently introduced to temporarily pause
> the lazy MMU mode: lazy_mmu_mode_{pause,resume}(). pause() fully
> exits the mode *regardless of the nesting level*, and resume()
> restores the mode at the same nesting level.
>
> Whether the mode is actually enabled or not at any point is tracked
> by a separate "active" field in task_struct; this makes it possible
> to check invariants in the generic API, and to expose a new
> in_lazy_mmu_mode() helper to replace the various ways arch's
> currently track whether the mode is enabled (this will be done in
> later patches).
>
> In summary (nesting/active represent the values *after* the call):
>
> lazy_mmu_mode_enable()		-> arch_enter()	    nesting=3D1 active=3D1
>     lazy_mmu_mode_enable()	-> =C3=B8		    nesting=3D2 active=3D1
> 	lazy_mmu_mode_pause()	-> arch_leave()     nesting=3D2 active=3D0
> 	lazy_mmu_mode_resume()	-> arch_enter()     nesting=3D2 active=3D1
>     lazy_mmu_mode_disable()	-> arch_flush()     nesting=3D1 active=3D1
> lazy_mmu_mode_disable()		-> arch_leave()     nesting=3D0 active=3D0
>
> Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
> headers included by <linux/pgtable.h> to use it.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ------
>  include/linux/mm_types_task.h    |  5 +++
>  include/linux/pgtable.h          | 67 ++++++++++++++++++++++++++++++--
>  include/linux/sched.h            | 16 ++++++++
>  4 files changed, 84 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 54f8d6bb6f22..535435248923 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -82,18 +82,6 @@ static inline void queue_pte_barriers(void)
>=20=20
>  static inline void arch_enter_lazy_mmu_mode(void)
>  {
> -	/*
> -	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
> -	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
> -	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
> -	 * permissions on the linear map with apply_to_page_range(), which
> -	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
> -	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
> -	 * flush and clear the flag such that the remainder of the work in the
> -	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
> -	 * keeps tracking simple.
> -	 */
> -
>  	if (in_interrupt())
>  		return;
>=20=20
> diff --git a/include/linux/mm_types_task.h b/include/linux/mm_types_task.h
> index a82aa80c0ba4..632d404f8191 100644
> --- a/include/linux/mm_types_task.h
> +++ b/include/linux/mm_types_task.h
> @@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
>  #endif
>  };
>=20=20
> +struct lazy_mmu_state {
> +	u8 nesting_level;
> +	bool active;
> +};
> +
>  #endif /* _LINUX_MM_TYPES_TASK_H */
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b5fdf32c437f..e6064e00b22d 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,27 +228,86 @@ static inline int pmd_dirty(pmd_t pmd)
>   * of the lazy mode. So the implementation must assume preemption may be=
 enabled
>   * and cpu migration is possible; it must take steps to be robust agains=
t this.
>   * (In practice, for user PTE updates, the appropriate page table lock(s=
) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not pe=
rmitted
> - * and the mode cannot be used in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode cannot b=
e used
> + * in interrupt context.
> + *
> + * The lazy MMU mode is enabled for a given block of code using:
> + *
> + *   lazy_mmu_mode_enable();
> + *   <code>
> + *   lazy_mmu_mode_disable();
> + *
> + * Nesting is permitted: <code> may itself use an enable()/disable() pai=
r.
> + * A nested call to enable() has no functional effect; however disable()=
 causes
> + * any batched architectural state to be flushed regardless of nesting. =
After a
> + * call to disable(), the caller can therefore rely on all previous page=
 table
> + * modifications to have taken effect, but the lazy MMU mode may still be
> + * enabled.
> + *
> + * In certain cases, it may be desirable to temporarily pause the lazy M=
MU mode.
> + * This can be done using:
> + *
> + *   lazy_mmu_mode_pause();
> + *   <code>
> + *   lazy_mmu_mode_resume();
> + *
> + * This sequence must only be used if the lazy MMU mode is already enabl=
ed.
> + * pause() ensures that the mode is exited regardless of the nesting lev=
el;
> + * resume() re-enters the mode at the same nesting level. <code> must no=
t modify
> + * the lazy MMU state (i.e. it must not call any of the lazy_mmu_mode_*
> + * helpers).
> + *
> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
> + * currently enabled.
>   */
>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  static inline void lazy_mmu_mode_enable(void)
>  {
> -	arch_enter_lazy_mmu_mode();
> +	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
> +
> +	VM_WARN_ON_ONCE(state->nesting_level =3D=3D U8_MAX);
> +	/* enable() must not be called while paused */
> +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
> +
> +	if (state->nesting_level++ =3D=3D 0) {
> +		state->active =3D true;
> +		arch_enter_lazy_mmu_mode();
> +	}
>  }

Some architectures disables preemption in their
arch_enter_lazy_mmu_mode(). So shouldn't the state->active =3D true should
happen after arch_enter_lazy_mmu_mode() has disabled preemption()? i.e.

  static inline void lazy_mmu_mode_enable(void)
  {
 -	arch_enter_lazy_mmu_mode();
 +	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
 +
 +	VM_WARN_ON_ONCE(state->nesting_level =3D=3D U8_MAX);
 +	/* enable() must not be called while paused */
 +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
 +
 +	if (state->nesting_level++ =3D=3D 0) {
 +		arch_enter_lazy_mmu_mode();
 +		state->active =3D true;
 +	}
  }

... I think it make more sense to enable the state after the arch_**
call right.

>=20=20
>  static inline void lazy_mmu_mode_disable(void)
>  {
> -	arch_leave_lazy_mmu_mode();
> +	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
> +
> +	VM_WARN_ON_ONCE(state->nesting_level =3D=3D 0);
> +	VM_WARN_ON(!state->active);
> +
> +	if (--state->nesting_level =3D=3D 0) {
> +		state->active =3D false;
> +		arch_leave_lazy_mmu_mode();
> +	} else {
> +		/* Exiting a nested section */
> +		arch_flush_lazy_mmu_mode();
> +	}
>  }

This looks ok though.

>=20=20
>  static inline void lazy_mmu_mode_pause(void)
>  {
> +	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
> +
> +	VM_WARN_ON(state->nesting_level =3D=3D 0 || !state->active);
> +
> +	state->active =3D false;
>  	arch_leave_lazy_mmu_mode();
>  }
>=20=20
>  static inline void lazy_mmu_mode_resume(void)
>  {
> +	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
> +
> +	VM_WARN_ON(state->nesting_level =3D=3D 0 || state->active);
> +
> +	state->active =3D true;
>  	arch_enter_lazy_mmu_mode();
>  }

Ditto.

-ritesh


>  #else
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cbb7340c5866..11566d973f42 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1441,6 +1441,10 @@ struct task_struct {
>=20=20
>  	struct page_frag		task_frag;
>=20=20
> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
> +	struct lazy_mmu_state		lazy_mmu_state;
> +#endif
> +
>  #ifdef CONFIG_TASK_DELAY_ACCT
>  	struct task_delay_info		*delays;
>  #endif
> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_=
struct *tsk)
>  	return task_index_to_char(task_state_index(tsk));
>  }
>=20=20
> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
> +static inline bool in_lazy_mmu_mode(void)
> +{
> +	return current->lazy_mmu_state.active;
> +}
> +#else
> +static inline bool in_lazy_mmu_mode(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  extern struct pid *cad_pid;
>=20=20
>  /*
> --=20
> 2.47.0

