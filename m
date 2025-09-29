Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB701CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 09:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AB28E0005; Mon, 29 Sep 2025 05:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AFF8E0002; Mon, 29 Sep 2025 05:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA008E0005; Mon, 29 Sep 2025 05:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D76428E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:55:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5754858638
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:55:33 +0000 (UTC)
X-FDA: 83941830546.22.8A74F0C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FF1E40003
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:55:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759139731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Khx8t87VP2N9V4ijYQGSbhtjRbGRVKetYymJ2WDPclM=;
	b=k4rf2TSNOiClC01avu2auzz5GkqJ12TNBOy88Zfgl3OJiB7Co0xJPIWXzhK5eZrDdgA/x+
	XZTGsyf29SfKvJhFhOhPthSXFrzKhwgOTEk5nRqOe9VmCVHTw5wpEl+Zy8BONertqmy3vA
	cHawiCc+YLRDbiaPTfks3vjP/MhLd9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759139731; a=rsa-sha256;
	cv=none;
	b=t7wd2aYQq6owqvAOS8Z43fiwdTioNNmF3id0wvYlyaqzSHO5V8HtC8tYDVCRqeYXvVwQww
	3Q8+aQPvCQfwuBmMlSLn7DGcDHuqY49dZ3o10zJWLsu2E01qtIg6gS9677+OfQBxh4z88f
	mJynU5fJ1HupIlEUiZoQBGSnl4dzkYg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 028D5150C;
	Mon, 29 Sep 2025 02:55:22 -0700 (PDT)
Received: from [10.163.32.148] (unknown [10.163.32.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 920603F66E;
	Mon, 29 Sep 2025 02:55:26 -0700 (PDT)
Message-ID: <738db21f-5026-4bcb-a102-969c4379c015@arm.com>
Date: Mon, 29 Sep 2025 15:25:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
To: Yang Shi <yang@os.amperecomputing.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, carl@os.amperecomputing.com,
 cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250926162034.1785899-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FF1E40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: c1uth88ww3uy4ig1hxp13fs9pw6kdhsz
X-HE-Tag: 1759139731-569247
X-HE-Meta: U2FsdGVkX19y/2U/48/199IH2bWL6aEKgXlzkuowDs4wCDvpo32CLNrfch3nwt8QnVFHa2s8gD96QNqRb9uaCTYXNwFSiX7T8Z3xLQurmdyKerkKwVB18UIVwhDVQcbJefY4hKPrRgExHlGlMbfuskTAGn4CqkUdqtSSJ0cGRHk3EmWbG1CPmRfexmjAa9AF2wMrKbtjzjvUyj0RS5zxs0y9OJco8MBLvHrP5k7DvrxFZywv25AZ7DWciitT26IkdyLO0CN30l1DCoUPCahXz+hl74QI2No+iP4BwAA4SDa0OuMdBhpWWwZ+/W4VACyjnMggtKx59QgmTh64rvjzoMREtuXIKx8PuExabbgU3cU+DIiOQa5SwML+ZreQiH0vN42oO1fXNEiJQ94PRpGWt4f4mus+lBGD5doo2cgsVx8eoBRv/RYANAF+GErXpzBnYc9eydvgtLNvthGCzyKtjMnJIbFuUx3+9sxVL8fQDm0TN8f2kdRpCHFDxVn/rDWzK+pX7EsjvDLSU8fScxSdNQ+J8k6wAvkfSjaam8fKC61F8J22vt4W0DzHm54US6nKKNxwfZIDG2GoyEt5TuwiM9uBUBoeUVh8s5To2c7R+J3iVwR3+iFUPXCm2woGF4I4eZdHp5Mem1c7BOEQr5chAlWP484U5NkBZ1zroPsw1mneZB3DttBp9WAoLVTKHEk4JE5GjCX8FTjxdfYuEb6cPhNCifJS2Q3XrFf5i2GI7+Z1/5drhd42TtOKrVLE8p4YHRgRZDngZ49bNZJrPdBqPcWJuPmA+JmK5F6DDWymOb0Anp4hljbL0OanAQUKdxXwgAUpwhUHyqDX1FHyLEYCtEs9n3fGyK/OgpCKXq1jB22XFvlxHykvLEDQFMofYVAgqg0yYtFF4rCUtPNZzM1cJKyV5LQXrrg/Rlv4dIzySsTx2/1ssMstseLjiL2DA19LefGojDSWDU10e3X5K75
 vhcSrWp1
 t/J/MRbBx9gZakgJ2UGwcU83UHHgo+ax89cq8f2ZDJHWYtAHBu9O/2Z9ljl2RorkVgRbMhwqY8Yo2sUlxHVFf7wDLEZa4BnemoZCilYK+bhDaKWKObsmSdGV422xZ7IDfAsmvwv7tM5UY+8hlt70xYjew8nCIBaiO0Xk59OAu1xCIU8x7L7/J16sRBHPjtscL38f/zMH+u0vKO77CtGWb1UQDTUbRuLKxSO2IGc1bbiWGegwqv7YXoBN2pTK7aN8dOj1SQLpxR1iu+zjQrhjm134I15h4q55do28opAIHuXou/taZKg83ViFBKGVB4YVLrp16BrhQKXMAZYjqOervVJGDj3prSMIxxdFcsnkQ0JHhpiJPC/Q54wuDbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/25 9:50 PM, Yang Shi wrote:
> When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
> for every single page in the affected area. Soft lockup was observed
> when doing this for large HugeTLB memory area in our customer's workload
> (~300GB memory):
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
>   mte_clear_page_tags+0x14/0x24
>   set_huge_pte_at+0x25c/0x280
>   hugetlb_change_protection+0x220/0x430
>   change_protection+0x5c/0x8c
>   mprotect_fixup+0x10c/0x294
>   do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>   __arm64_sys_mprotect+0x24/0x44
>   invoke_syscall+0x50/0x160
>   el0_svc_common+0x48/0x144
>   do_el0_svc+0x30/0xe0
>   el0_svc+0x30/0xf0
>   el0t_64_sync_handler+0xc4/0x148
>   el0t_64_sync+0x1a4/0x1a8
> 
> Soft lockup is not triggered with THP or base page because there is
> cond_resched() called for each PMD size.
> 
> So add cond_resched() for hugetlb to avoid soft lockup.
> 
> Fixes: 25c17c4b55de ("hugetlb: arm64: add mte support")
> Tested-by: Carl Worth <carl@os.amperecomputing.com>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb5c4e79e0b8..fe6606d91b31 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>  						psize);
>  		}
>  		spin_unlock(ptl);
> +
> +		cond_resched();
>  	}
>  	/*
>  	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare

LGTM

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

