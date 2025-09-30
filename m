Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316B2CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8778C8E000B; Tue, 30 Sep 2025 01:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F598E0002; Tue, 30 Sep 2025 01:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78CB68E000B; Tue, 30 Sep 2025 01:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 645DD8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:26:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E41CBC0591
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:26:25 +0000 (UTC)
X-FDA: 83944781130.07.0260537
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 14C0F40004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:26:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759209984; a=rsa-sha256;
	cv=none;
	b=UG7NWnVWqkEMDURfcgxU8gtsQdMER6II3G8jH4/vbXQ5QnpW6lt1u70qZ/FP6xcxG6ZoC1
	Uck9SdMiX0Z27l17Kktk8RSchNExlNwRbcbq7LK17wzuGloV7xikxo3pKpnQV667iFdJns
	AGdOC1eu9O9K1KNNGap4d/tm1jJJz6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759209984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wv9IUesbBnGvMDl+uXl5DUzDhZ8MJQGxru5eJPQA9QM=;
	b=b0ewO4N48vOKM2v3FCksMP/Ogl8d3UBRtiyW+kyBqexglql2/lA9I43TUc+QWPSJIUeIaw
	wDTllcCdj924oPYneOE1LpbBSlnIJbel6NOHFWEnRzpCFsWHEiayzNCm11yTZJa9BwZ5Xn
	YjvdczsRYHpLAzfS7RNbdnkrKc2Jxb0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054201424;
	Mon, 29 Sep 2025 22:26:15 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 145EE3F5A1;
	Mon, 29 Sep 2025 22:26:18 -0700 (PDT)
Message-ID: <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com>
Date: Tue, 30 Sep 2025 10:56:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] mm: hugetlb: avoid soft lockup when mprotect to large
 memory area
To: Yang Shi <yang@os.amperecomputing.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, anshuman.khandual@arm.com,
 carl@os.amperecomputing.com, cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250929202402.1663290-1-yang@os.amperecomputing.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250929202402.1663290-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 14C0F40004
X-Stat-Signature: 9671hndfz5qgd1mfyrw5yy5y938bt9se
X-Rspam-User: 
X-HE-Tag: 1759209983-192757
X-HE-Meta: U2FsdGVkX18LyMawHkiLnE9k2HCIsNfC+RjoTZVWXU3VBzbMOIlafgefe6a3KsMV6aVdy80nOojsqQyeq7xhSdgyh+HaXGekVMMGhsq9Yb56zhkk/ELgeEm3Z4j2iZgMq36RkZlNZB6n09eCEMm/I34WW/jbYtnGJmEIOAAYMpSGmczplkXt8+bm0dKkTDXTcURvfNd4sbKUuYt6jK72dSGJ7hX6emZHDgHHZwP341N13d/Toub4W3q9oiTcS9FKrFEO2qlhnamiNSHYbaL4GVwF370gm/3euj+nquU5GVjDvHT7MnarzcZq6P0I7HehcwKXkNAZbmXrOw4cFikXCBPJrwe2i5CMn0PEaZhtUgWa7tMKlpymebPAVxwxJM+Jz3E2LeE8F4SE2shtA6Y5RJavpZDZjgeENhEgJonr2peo7N/sDvIkZKIYR5ClBRHdsE5mBpfiZS1Q7gDT6sTMMFWLOFXFP5sfnc/iEZa5oH5LxP+3XqA8EmjkSCmWYbhScbywPTUaCT+wr4V5IbQNsVrb/kh6v+RshrF7jGE6irFn2obHoM0xuI4VQL9kZxmJok+q4VbwziqV6qoDX3Xi5Mp7c3/CGLAt8MlQTSoEvuP4JmQ1kdGdcyA4QUWlMYIjVKE8UUyA9wqDI0Ru7FnWoVKh3eZOAqZG6Ee/7ROWdSfRgl6S3++qr5lABr92W4Ib/qCyEGRO3oCbZdyJk4dwP/+fwKSMmyHImUXoBQscU8qZQJ9yhzmMzqhhSqeYzA+f6sTvpRtGSdezNLNSkanQnBn3tHlgIHrw0i3pNWsnzq4UtkwIE77jMqYlo9kH11ab0mr5t9iJ+izH4EGw2msJGGbeIrKTLWl+WTotcZFMDkaivrW+eWCrYo9n1F0fI51pamCjiN3cvdPcyjFDZ4VZ13H2UsDkG3Ncf2LV4VziNm7IRZ/cugDoJ0mf3W2kK5VcZdBTaa+ENnKasi8Z6Z4
 5PaUiBtf
 0DLo1jRa2BJ3w8flPBvCJaVbX1Cqt03pSbstGbC1dsBNpOryi41W5xyRLd3wM2ewv31uti1UiNjKsXCoReECtU7Yhl1z9D0OHAVp5Puw81Qelj2rfxvhJljDDiXcAg8EB1n9gkRXqID7XlB+lY4K6opyzGjRXl75kVOCZhZ00hH8jJfcoRJiN23d3hfEw3mwjHwZCeg0tpV2yNh8ulL2cL+HFFF/j34wrgpHGxllOCBByIcl+1oRWzBtNG/G3f648a89wblSPLVvF9ZzfChTblsniYTXqoie8nG0xVyhrr8jqEASzwoKBJ++ppUIibNO6/tgiQlN3Mrb85McU+JNP/yo+p2Vox/JioirW65gbP68KZysbS1CASXcVFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 1:54 am, Yang Shi wrote:
> When calling mprotect() to a large hugetlb memory area in our customer's
> workload (~300GB hugetlb memory), soft lockup was observed:
>
> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
>
> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 5.4.4.1 07/15/2025
> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : mte_clear_page_tags+0x14/0x24
> lr : mte_sync_tags+0x1c0/0x240
> sp : ffff80003150bb80
> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
>
> Call trace:
>    mte_clear_page_tags+0x14/0x24
>    set_huge_pte_at+0x25c/0x280
>    hugetlb_change_protection+0x220/0x430
>    change_protection+0x5c/0x8c
>    mprotect_fixup+0x10c/0x294
>    do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>    __arm64_sys_mprotect+0x24/0x44
>    invoke_syscall+0x50/0x160
>    el0_svc_common+0x48/0x144
>    do_el0_svc+0x30/0xe0
>    el0_svc+0x30/0xf0
>    el0t_64_sync_handler+0xc4/0x148
>    el0t_64_sync+0x1a4/0x1a8
>
> Soft lockup is not triggered with THP or base page because there is
> cond_resched() called for each PMD size.
>
> Although the soft lockup was triggered by MTE, it should be not MTE
> specific. The other processing which takes long time in the loop may
> trigger soft lockup too.
>
> So add cond_resched() for hugetlb to avoid soft lockup.
>
> Fixes: 8f860591ffb2 ("[PATCH] Enable mprotect on huge pages")
> Tested-by: Carl Worth <carl@os.amperecomputing.com>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> ---
> v2: - Made the subject and commit message less MTE specific and fixed
>        the fixes tag.
>      - Collected all R-bs and A-bs.
>
>   mm/hugetlb.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb5c4e79e0b8..fe6606d91b31 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>   						psize);
>   		}
>   		spin_unlock(ptl);
> +
> +		cond_resched();
>   	}
>   	/*
>   	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare

Reviewed-by: Dev Jain <dev.jain@arm.com>

Does it make sense to also do cond_resched() in the huge_pmd_unshare() branch?
That also amounts to clearing a page. And I can see for example, zap_huge_pmd()
and change_huge_pmd() consume a cond_resched().


