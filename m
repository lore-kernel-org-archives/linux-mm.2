Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BF9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFFB6B00A0; Tue,  7 Jul 2026 09:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B70C6B00A1; Tue,  7 Jul 2026 09:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6D66B00A2; Tue,  7 Jul 2026 09:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02B046B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:36:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DDC2168DC4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:36:33 +0000 (UTC)
X-FDA: 84962080266.10.BAE0874
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D7C740008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:36:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M5aQ88AH;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431391;
	b=N0SuESoo0nKZjkDqrVxgwwf/h15gIm1T1xwIATeQYnsxnSsuBC7Ct8fZGkO+K+IOMpcDLq
	ps0KIiwvikzQlGaVNzin+1s4TcXBYSQUm7L+lhHfIK03M3WWlxD1EV3EfBNhoPI4GyQna1
	7gS/KYEoge+govlngEHiUWlEMyNZTDI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M5aQ88AH;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTT2EDmNQmPoFd5ibUkdhfarwMp1tgdKNvXjK9tKgTE=;
	b=PwT5aVY31Is2hfkh9gRZYEDGbDUx7e8mHx8Juojk4c/EHOrZY0fmkmeW33Hidn2R0lKzmG
	wgHPCYIdkIAF+HbcRX5rC0hPEMQKwii9pdMXzJcFLEYxllvks3Ub0BkD2KRCkpGtnM9Q13
	AH3BOvFpkCGHgew6IxxqbcLwsnfhrrU=
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2cc7a345f51so10200155ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783431390; x=1784036190; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YTT2EDmNQmPoFd5ibUkdhfarwMp1tgdKNvXjK9tKgTE=;
        b=M5aQ88AHYVVByldmDCGjumGtul81izGF7ucGKzgNwmgnqptVS1vniU1uubEi71LrMN
         5eqHSCW4Cq0+XUvAVoj08YPh8lfB6doGYhOA4RvutZsFLUtBMtJgvQMEPsPK3vjxgBJA
         vitnHNMxIRvNAl+0bIGf7J7gbVDaA4T4KVDJUUYOnE4IY8GZ+fxJVgk835EnTdCPiQ/4
         EpCNlWQgcbZCuLw82KPsTXDYPIvEIIyYDWMTDRSD+4uZxYJWPg61XzFwqjwB5sOs41uJ
         0g1li7DmBnmwKWFi5ETEBd8Pe5DQxoIVMhS9/KAX8F9a08VUtX7iWcvt0pPBg1k02vzf
         ppxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783431390; x=1784036190;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YTT2EDmNQmPoFd5ibUkdhfarwMp1tgdKNvXjK9tKgTE=;
        b=ltgS05ExjvFtPkWwwRM80M6NMiJY3aGpH5+OkjoGQhR2/N/0Dv60ke+9VESre1W0zW
         wilqPtHm3KDPmpOQFFhLbwdMFywgw0zGZuTfWj8a5X9xwdvHW3Ya3MbhfXlAndSF8MmP
         U2rEUlXl3V9rAEUi27WDUYL9CtKUCkpDF5PDO+6DuyohOle/R+GZmdPO507/O1SJE9fR
         PKibi3jP4OSQz110qRKJNM+/s153uqSxHnewfhPsBXnAfgclMb6rLrWTlF9fu4Oqtxf8
         AAjRqwrH8vcSBo+m/lfuQVN6KOZJ9vjt3HwOXJNCDXnE+LvvF1Btx6fWNzq0+qAcFk9j
         7tBQ==
X-Forwarded-Encrypted: i=1; AHgh+RpiAD43oqi8YDxpm2Xydmrd4lAaZ6jU3JJSJtIRvxjdOAbA3791+5Tkxj2mR4jG3Lf8Po8L1fs7Lw==@kvack.org
X-Gm-Message-State: AOJu0YwmWOvgpJ+3kKJHC4g3PnY6DvFjEjh8d8wVLfOwwP++J2u+Yln2
	obIeIcg8IL0ktucrJSYYrNfef4zYjSlUiyRGa30072xFlPRG8YWRULJa
X-Gm-Gg: AfdE7ckNZVrCUnsRMG6nCMKdRGZgXxlK7qHuG69mu0/dfRtPIbYdad69Be5FGjcB+eA
	Mv8dBHO53tmoNtVGDYYKUJ2JJ2IRuKweIxBcIOjavaj5bGpdk2TSP3nfRwjaBo1TKJTGC7H7Xc0
	wdEv5JVdpG+JQWrRBfF15DChb+ngRm2Nx1XeVgFxwkfosZpeRi3xFyqy8W3Aaow6fkabhipiDC1
	pBS+mUo4CRCgw/Gdwa390ddz01EK6XSozSEcywaoMaKlEstTM8yYeD6jb/Ge6Qp9Gj/zvJ8KLrQ
	Fdue24MAnLWi3DtjuP6i4SFo6mcCdY8HM7YxmL2hyoDkrTCzrWVQvkiJ++iatWk7KSYt8mhiK5y
	3St/Tbw+SOWugDnSkMhyAFXMpoSCMy7O03k6ZcdKv5lGwv95BbciChzGaqP0z9mUfwkrNQLrqWt
	FNJMZ14Hxbfgydxwm1vVrY
X-Received: by 2002:a17:903:2444:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2ccbe40b8efmr55426065ad.2.1783431390369;
        Tue, 07 Jul 2026 06:36:30 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfe040sm12488775ad.31.2026.07.07.06.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 06:36:29 -0700 (PDT)
Message-ID: <bd88f65e-000b-4dde-92f7-28af6a34e977@gmail.com>
Date: Tue, 7 Jul 2026 21:36:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
From: Wandun <chenwandun1@gmail.com>
To: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20260707125925.3725177-5-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D7C740008
X-Stat-Signature: wrgb6ob1ick5raf4nefh146k5ba6puse
X-HE-Tag: 1783431391-952884
X-HE-Meta: U2FsdGVkX1/5HZ4HSA3erOmAFKQnglobnHh5ESD/1quAlOYvx1ecDY0FtfWmrj13dVAaTjpUYhX6BTWi9QUvi0Z8WYE6t3+8hd2FohJ+QqU34M+zA2OsOdCLCS4Um5bA5/aE6m3hSIFYMbYEjDYCbsjFDvTilCdAFCkjPU9LbSxhGaycFXFTkLdjLqFJ2qkyY6IjEB+aL1QOq1lFITMsmhqDL5RtocOOmpBcyoC6l8HIOZbbdrIx5RngfjQvDNmqCVXpPOnstP72RfcV4dFCd/OXcat4+txA7wsIzICGqqHCP2PuTGh/b1XCEGijh80n3mx+ecWdU1uU9XJOfO0c/sPP+74KuXYAr70gP7rFuQRReE+ITIrGbhIn/pci6SMWdP0KM0CRSFGUjMLy4jjzMZSq06w+akX6hhCSk1TV6WRGKqCJMO6SzvSjH1rfZJ6TnEQ2o/x389/BNhjlNAid0ZHnhwxBx7Th7xrpmo5E01WVCJTrGsm5n8K0fpszi6wd0PXKJmde4+z9dENYRurD9aBTD+FfBDuYKT+TXGkWAR44gnvfe9I7sn9v7AJ6ex2q+UyJiBStRtw7SEauwFVDQ1hU0EJI5AyrT4kP2A3Q+xuKpcdZIBZC3XN14/n56ZZ9BM3lvcDCmOS1Z3tBYOfgVNZWFrZXkj+QIpr0I2Le9HqB5u3RMB83wWS7RZiFTOe2xV4rKqVDERPo6ta29gAIwDTtVkS/KRHUdo01/R0diN2IlQtz3TSs4Br/3A3ybmtbVpbJ3D0bJzzK5frKoXqB5sO7hVGFTshq5q31uYxGbpL9xZtOf0NFbCjFS0YhOJsL+b3fKSzcfb0/ZAKPwFnbXGYjhvfXuLtp/p1xWAKhmejPh1/jnZ8DXtu6GoGV/zXNwMfecYJFBKX3c1ro9djkkj9uZrFIbNyhJjc7OS6pW94lQJo+TfY4B3RqUaeDVIAErZyRygmCULWvBnW+paO
 ySDUdePR
 v6U/af62H8+JGzv+koeypbPv0IwAoHIWJoai+pWE00ixxcOUisTo5SrED1Ewfhti9aadNArovnuzC3q8iwoKC8+bhrjmknRvve27rz6TOE4y5xVgGqjNMZ8mLUygUU2BypDuLX6BnrtRe/+aYfuIGktAstQKUQdgRXuWmz5EReSakeqGpOAZNhNED7jryTYI4WSdaNFomo6rHqhCNYFzjb9THFyeT8RWUKOpMjw8/pteP5UmmGR8l0DuNqBtBRGDXiN2wA5Sl+jG5AalUFBT9XWGcEs0EPN/nt/EJ89AXDIzO7z7gRjSS2FleEwS29NABIwpDAtXrvYkDTzPFhPJJZ//XKd3/HHrNbAOIOVX6W1vHjJdgYsfPE2ywlMUk304R5vklqZ7sQZ8W/1Cj+YKuBEfNYlZP5RIENULsDSJHU0VYEjHU1x9Q/AEy7EeD6s2nYnXezs5HURNmM5JW5r3f0by8GLQF18ukPIRj+tzOz0IeTpxZdeoNob0bWrOJ4IAw3nzC/omcnZQZGb/eym8Akm6Spak0iLBSsRUKxivbCk/9npuLMKILIYjH+Fti/gdNUsAQFWNUbP9aeLnHHAMNVBdMs3Z81LNgw4+2cWZB4Uo3P9QHPhLv67H2Ms10GP2NrkZlnmuHfEXc4lc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 20:59, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> The region covered by mlock[all] may contain CMA pages. cma_alloc installs
> migration entries in the page table, if a memory access occurs at this
> point, it must wait for the migration to complete, which may cause
> latency spikes on the RT kernels.
> 
> Try to move the migration cost into the mlock[all] caller, which is
> typically a setup path. So reduce the chance of latency spikes on RT
> kernels by migrating the currently mapped CMA pages out of CMA region.
> 
> Suggested-by: Frank van der Linden <fvdl@google.com>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://lore.kernel.org/all/CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com/#t
> ---
>  mm/mlock.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index ac65de40b22b..f56c685533f5 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -25,6 +25,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm_inline.h>
>  #include <linux/secretmem.h>
> +#include <linux/migrate.h>
>  #include <linux/compaction.h>
>  
>  #include "internal.h"
> @@ -428,6 +429,119 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_CMA
> +static int mlock_collect_migratable_pte_range(pmd_t *pmd, unsigned long addr,
> +			unsigned long end, struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +	struct list_head *folio_list = walk->private;
> +	spinlock_t *ptl;
> +	pte_t *start_pte, *pte;
> +	pte_t ptent;
> +	struct folio *folio;
> +	unsigned int step = 1;
> +
> +	if (!(vma->vm_flags & VM_LOCKED))
> +		return 0;
> +
> +	ptl = pmd_trans_huge_lock(pmd, vma);
> +	if (ptl) {
> +		if (!pmd_present(*pmd)) {
> +			if (unlikely(softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
> +				spin_unlock(ptl);
> +				pmd_migration_entry_wait(vma->vm_mm, pmd);
> +				walk->action = ACTION_AGAIN;
> +				return 0;
> +			}
> +			goto out;
> +		}
> +		if (is_huge_zero_pmd(*pmd))
> +			goto out;
> +		folio = pmd_folio(*pmd);
> +		if (folio_is_zone_device(folio))
> +			goto out;
> +		if (is_migrate_cma_page(&folio->page))
> +			isolate_folio_to_list(folio, folio_list);
> +		goto out;
> +	}
> +
> +	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> +	if (!start_pte) {
> +		walk->action = ACTION_AGAIN;
> +		return 0;
> +	}
> +
> +	for (pte = start_pte; addr != end; pte += step, addr += step * PAGE_SIZE) {
> +		step = 1;
> +		ptent = ptep_get(pte);
> +		if (!pte_present(ptent)) {
> +			if (unlikely(softleaf_is_migration(softleaf_from_pte(ptent)))) {
> +				pte_unmap_unlock(start_pte, ptl);
> +				migration_entry_wait(vma->vm_mm, pmd, addr);
> +				walk->action = ACTION_AGAIN;
> +				return 0;
> +			}
> +			continue;
> +		}
> +		folio = vm_normal_folio(vma, addr, ptent);
> +		if (!folio || folio_is_zone_device(folio))
> +			continue;
> +		step = folio_mlock_step(folio, pte, addr, end);
> +		if (is_migrate_cma_page(&folio->page))
Here should be, sorry about this.
	if (!is_migrate_cma_page(&folio->page))
		continue;

Best regards
Wandun
> +			continue;
> +		isolate_folio_to_list(folio, folio_list);
> +	}
> +	pte_unmap(start_pte);
> +out:
> +	spin_unlock(ptl);
> +	cond_resched();
> +	return 0;
> +}
> +
> +static const struct mm_walk_ops mlock_collect_migratable_ops = {
> +	.pmd_entry	= mlock_collect_migratable_pte_range,
> +	.walk_lock	= PGWALK_RDLOCK,
> +};
> +
> +static void mlock_migrate_cma_range(unsigned long start, unsigned long len)
> +{
> +	struct mm_struct *mm = current->mm;
> +	unsigned long end = start + len;
> +	LIST_HEAD(folio_list);
> +	struct migration_target_control mtc = {
> +		.nid = NUMA_NO_NODE,
> +		.gfp_mask = GFP_HIGHUSER | __GFP_NOWARN,
> +		.reason = MR_SYSCALL,
> +	};
> +
> +	if (compaction_allow_unevictable())
> +		return;
> +
> +	lru_cache_disable();
> +
> +	if (mmap_read_lock_killable(mm))
> +		goto out;
> +
> +	walk_page_range(mm, start, end, &mlock_collect_migratable_ops,
> +			&folio_list);
> +	mmap_read_unlock(mm);
> +
> +	if (list_empty(&folio_list))
> +		goto out;
> +
> +	if (migrate_pages(&folio_list, alloc_migration_target, NULL,
> +			  (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL))
> +		putback_movable_pages(&folio_list);
> +out:
> +	lru_cache_enable();
> +}
> +#else
> +static inline void mlock_migrate_cma_range(unsigned long start,
> +					   unsigned long len)
> +{
> +}
> +#endif /* CONFIG_CMA */
> +
>  /*
>   * mlock_vma_pages_range() - mlock any pages already in the range,
>   *                           or munlock all pages in the range.
> @@ -678,6 +792,7 @@ static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t fla
>  	error = __mm_populate(start, len, 0);
>  	if (error)
>  		return __mlock_posix_error_return(error);
> +	mlock_migrate_cma_range(start, len);
>  	return 0;
>  }
>  
> @@ -790,8 +905,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>  	    capable(CAP_IPC_LOCK))
>  		ret = apply_mlockall_flags(flags);
>  	mmap_write_unlock(current->mm);
> -	if (!ret && (flags & MCL_CURRENT))
> +	if (!ret && (flags & MCL_CURRENT)) {
>  		mm_populate(0, TASK_SIZE);
> +		mlock_migrate_cma_range(0, TASK_SIZE);
> +	}
>  
>  	return ret;
>  }


