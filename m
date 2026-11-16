Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19A17606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CX0//Lh1
Received: by kanga.kvack.org (Postfix)
	id 3A4DD6B00EF; Mon, 16 Nov 2026 04:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354686B05B2; Mon, 16 Nov 2026 04:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243306B05B3; Mon, 16 Nov 2026 04:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC0036B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:02:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76831C0913
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:02:14 +0000 (UTC)
X-FDA: 85440390588.11.3EA2C7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DEFCB180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:02:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CX0//Lh1";
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794819733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R27gurMrWAiF1nO+wwfwz9JAI8Wko+vNkDI3bBCyoGA=;
	b=3nwIGXtpIimA8m0NWC4LVu1bsJh2izZbwd0Fbzod4kh9U1aGGNCbFCC/9MUAJcA0QJ25Ts
	+TDXuO8efSpimonDgmeek3TufqDmJnVc4PHKYb+N2vXaGZ+dSLDOW1lxxqfaSFWd+NkJ/1
	qQ5DLJ+J2doLMysg7xfBCqjJmcIfEaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794819733;
	b=xHjGBufM2zwIedLL7UuUkPFRqWQ6oa/97mtVTqww3KntrWSoR0xObQeS8b12RQMmhxYCJ1
	sv/aPyIvbdrBREsjMxwDaNy5EWdDUsdG4pZw58BqFqUfEywMJ9WInZvArt74vtz4HKXtJi
	0l35jj7+danihHrWAMOcfqXJtUkti6s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CX0//Lh1";
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1CBC43C70;
	Mon, 16 Nov 2026 09:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516FF1F000C4;
	Mon, 16 Nov 2026 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819731;
	bh=R27gurMrWAiF1nO+wwfwz9JAI8Wko+vNkDI3bBCyoGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CX0//Lh1DA2ZuZWTrCVzVp8OeJEfR9s1eHs9sM0eWGUOIC9KU+xsNgo/scrwnqxoT
	 STPM82v+CeZnOw9+9QAbCRY/F/UWwWHJuyMggJQhYpnqaSvLWvaxsCYh038SKEaJr/
	 ED16gtiwBKRRWxC95NOw37M/3SPf2JEzXVtMKyo5kW+EYe9OmRr7QfWqrU1ZSule3m
	 kbKN9jciHEq40qa1aBpyQlc7thbx1JPGlRqu1nD5/evGRNEVjurHAiVKiBkJ1s0Hs4
	 IIUEzvLdl+yL/8h7HeZ58/UxZ5fypajiJDdWgAYEXsnlxnMTsbnWukmmR5qXv6p/m5
	 KGbW3/9d40W3A==
Date: Mon, 16 Nov 2026 10:02:05 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/hugetlb_vmemmap: fix HWPoison state races
 during optimization
Message-ID: <avrGjaCa05UnK1kd@localhost.localdomain>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
 <20261114112523.75208-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114112523.75208-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 36etb5ey9pe7j68i6sybr8rbjoncnfko
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DEFCB180007
X-Rspam-User: 
X-HE-Tag: 1794819732-259535
X-HE-Meta: U2FsdGVkX187VpI2ajcmOr+zhh1en8glfkTozifa5OrFUA9vEy0Djx6DII+MJ5I+N6j4GDK3kEyllDcV9MbRry6FX54qKPDfLvIzDskOO1cTQit9K9fAdj0tT4niOQ7idii8VQORwv6YP+DByGBS0t5XRlGgBnWLO3Y8EfpyT061t6C7++giE2/PHeDVqXQo1+YU8OI22D2jWUwuFVMV5sP+fF8/XN5oIHIyFMPCE1ZSEET/CDMBnTqw96Ne5ku2wammTHQEwzaYwPnGpp7z1rfb0pC1z97uHjSeYQZ9E/NDKtP16d01fTeuZMhUCN5ap9WU3H2kxGXic6tNTbYbVPyTtNWRmWtyjXmvBghvhx41iOjtyrAUnqN6llk/ReCH9nw/Qec7R/zTktMX2APK0gU41gjk0uRdaTD+3MjpGvSbzwmSAUFr8cvrjGSOGXoru5cF1ng0m75TkLoNUnlTid4h3PLMOuBiFiSqy7e7Gjcl5cAUGn2jiNClPhKWQ/xxtiuQHzL48aVo1gZvV80M3P3gKGtAt2qvka3qVSxzP7blmmks+B4eQ7reJXkVOLfQed/ReorP8WBvm0u7iMK46SSfd6GXfozenqVNHWdJUCbnX+vdM7WxosVSpGU1RgyhHOQC/+v3+ZsfsjieZyKRUgdEN1lJJIrNbL+31LIGByhd7djXmX5UDwj/75sM55yqKmhFfk47m988tJW2ApgHrGNiZTr+B8IpwdQH/TKzmnd0NzAJjXqr+u8wXYGVtvyRWD/IZyCo4gKkGjrPl9bLVXWw21hAf2EGJL7wVcAfxS4AyDWHmIBlG0tzcnPZeVcT6tVv8/CQNB9Kri5qsG7cipKO7kES20Qv4yYi/xNkCcxffbTn3oBRPNu2crh8yN3dFb6aIVsjseTRMRmm7nOL340JQYXlXgvXt1aPCBO2XBpBLDdfspurVcgAnscPNPu0mgT2M0N2lkW+NqTHjZ4
 upRCEYfj
 o+n8/r9YOA3x+8fr4KYboj5Beohd9UaJ5s7qb4MUItH8RLMOxGlo3irAx/b10zcfMu5bRfH3xI/DHXYQolFHaJNCZnKlb4vCiu7q56BjiqyBPG7/XmxFafSCKpdOKwf2bGkz0I3vrzpHflrp0aBhjYrrnFJHs2mlMuaXJyi5yuaxLcxO0UQuJ2Nnb9aA1S/dAx9NkobSqK+jC9n/tDv9mJCTRv1ko/DXWb93mDkJeCVGnymVAdANN3c6bn3F5jk+f8ix6nYyGpQgzjY1Ko6QHlFyyqGkxvFaZlO42Dz20T3XNxyIREIXo7GulgTrIKPy7TsRRrPV0C01DMd8evPybGYU66dSwuVpdx4luj7CmtYFRTOCriwlndCnqZ4PHR/JjirfkcmHmUmE3lOXEY724tAWm/rbgwTxVMcAwfMgL03WeJBnQ74R54d8WCtCyCwsO6h4FT5tYMTCF+xI1B2Z8btNmomGLmdgoDOy9Z5AezOmkEeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 07:25:21PM +0800, Muchun Song wrote:
> HVO copies the vmemmap head page before remapping it to a newly allocated
> backing page. Memory failure can update the old head page after the copy
> but before the remap's TLB invalidation completes:
> 
> CPU 0                            CPU 1
> init_new_hugetlb_folio()
> __hugetlb_vmemmap_optimize_folio()
>   vmemmap_optimize_pte()
>     copy_page(old_head, new_head)
>                                  try_memory_failure_hugetlb()
>                                    get_huge_page_for_hwpoison()
>                                      hugetlb_update_hwpoison(old_head)
>   set_pte_at(..., new_head)
>   flush_tlb_all()
> free_vmemmap_page_list(old_head)
> 
> The raw_hwp_page linked to the old head is then leaked and the folio's
> HWPoison state is lost when the obsolete backing page is freed, allowing
> the poisoned huge page to be allocated later.
> 
> Unpoisoning has a similar race: unpoison_memory() can free the
> raw_hwp_page and clear PG_hwpoison from the old head after it is copied,
> leaving the new head with stale HWPoison state and a freed pointer.
> 
> Serialize HVO remapping against HWPoison updates and removal. This
> ensures that an update is either copied to the new vmemmap head page or
> applied after HVO installs the new mapping and completes the TLB flush,
> and prevents unpoisoning from modifying the old head while HVO installs
> its replacement.
> 
> Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
> Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

