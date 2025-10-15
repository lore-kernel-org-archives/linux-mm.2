Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78989CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 02:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB25C8E0156; Tue, 14 Oct 2025 22:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C629B8E0005; Tue, 14 Oct 2025 22:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B786F8E0156; Tue, 14 Oct 2025 22:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A321A8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:09:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36513C0A66
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:09:20 +0000 (UTC)
X-FDA: 83998716480.11.E437503
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C1BA1C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:09:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VvaFYJk6;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760494158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+x7dA3Prk5hM89jVPge4HLz1VhxupN4NfzbWFIPEfc=;
	b=gjhJ9XZCexf9IZdsG7ouKEeDy1b9qom671A495S/m8WbFUz7ztXLtZJ2PXjbAWDVBMcJaa
	xkVDqJ/lQZZNunbIR0rL5/k2hShpKphC1YSMUklpllLRdQO62pIDuh4F1JqVgNV9WV/NWw
	GPoscx+rEH0WuULfo6JCts3V3gHeAtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760494158; a=rsa-sha256;
	cv=none;
	b=SR4loJ/fTADR+UK7pf8Cgo04LZuMxfdzNvVRgXswmIMpfyEdxvC4uYFu3j5e+EHk1Wuplt
	a0DCBnigW5Kax2m3NJ0JAXOJqC7ZzoNtY+pJf25pkMH63CKb/zNfCQVEeRtPK4hHXydYDa
	5VbkiMLgG9HoTGPAJyhMJ20Hn/+qkT4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VvaFYJk6;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8461D605E8;
	Wed, 15 Oct 2025 02:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E370BC4CEF1;
	Wed, 15 Oct 2025 02:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760494157;
	bh=QxXNkXYZ6ONgbk8YHR/mLJATVtR3hsrJ93KLwJeDotk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VvaFYJk6gzu/SrmA09X4ZSzC66zDqCpQdKMerjfFF8ltzZcGubm1Fi6hqS8PSalnU
	 /cJIQJUAUZKfTqzO2x6UAcOcfbBsNE5cUJzXeH15YV6aVonxi5xT3DBuu3ZGeXZb9g
	 JJrJtkPMyBeinuZzO/aSs8L1QZXoYELYABRGGdYk=
Date: Tue, 14 Oct 2025 19:09:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: urezki@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ying.huang@linux.alibaba.com, dan.carpenter@linaro.org, kernel test robot
 <lkp@intel.com>, Huang Ying <ying.huang@linux.alibaba.com>, Dev Jain
 <dev.jain@arm.com>, Uladzislau Rezki (Sony) <urezki@gmail.com>
Subject: Re: [PATCH] mm: vmalloc: fix uninitialized value issue
Message-Id: <20251014190916.e9285e8ac6a8301cdacd9fe8@linux-foundation.org>
In-Reply-To: <20251014102337.5453-1-yadong.qi@linux.alibaba.com>
References: <20251014102337.5453-1-yadong.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C1BA1C000F
X-Rspamd-Server: rspam02
X-Stat-Signature: utsaxdfneycpszud38g5zgeu5ooutqgs
X-HE-Tag: 1760494158-761075
X-HE-Meta: U2FsdGVkX1/yLYI6W4CBhp3KWVB5PBSSy7uvJqQW092GliydeT2Czys9Yh6hnVCY2mgHXfDKmRPw2ro7gY8yiF+3e2BC7VVcUSaqlU3IYtPcP77mBOFI26gEhEfrSAkaB0EQc5EqfVxLIEy56ZNwrQnTdIZ8c3MV5OYEx9Rtk77QHMY1Z1l1X1JcvqXV51aSlvsf9DbPgvfc5hT6XdKUmpPkByTMPz/SkljVOJIfXgpGkaxV2o1uRyhQy1VkdnLPblh3+zKgATNkOOkQYsKu7KFEcbgPWgZoKSmsYhDbbqTQ1RqC0snkBOicUlykJyjb51UXMu91SW8cD0/TjKyPk8WmLsZpp0YwBSdyzVy7JfKjVGvlD382lJjgR7RQRp+uySEBlEhxjodkqldHjWBny/GAFTxyxKHYbVaZxAzjW2SS231ikPn8z/N6hBfhVw0dhVa4Ua4ZxQrwhkJCyOZKfSsqfpfW+EXY8TDNNYidcOBVJb602dhC5wzS+a9Ol2fqdo5lJZrVebuqPxh4u5BVTgcFy3tGKyFHmiUYgbmeu5Dr+o8WIqS0hvHT4YzhOixgBOstvY9vUeeaax1kxGcMu0AMwzt8S5HZdJiKmSJBbpBq6SyIk8hPiC414V56sbCE2s/Z2yxBpRDyovzm+OXT8pkKjHbOFkxjAfrz+CwIQ/vALiAIWcyA3xIRNcOBdgd5RJlzn23XX9nWQidvFcgidwD78xtiwCQWAnZlRGmo/fA2RS2VPuj+euWibSv2w1K8wdzWs6Bfz/s6c7+xdGsXN3204dAGxjLO8h18JVeOjJ0jwCcTyMVFPnV1/EXZPJVyYUGyRJANyf0Iq8GanhZ26ylsS5qhWTTrS8O/Xb+xmGuiy/4PhPb1YiSmneOO3SlTeiqxZ9bJcqQbDJcetJsxCRr58VtPNibHtwDvydOqCyVQ+vIlCbhT+05Kj73724TqNY/bDex2r9kWOMH40uX
 HHFTWO6r
 uTRmnh7E4BGb54npJSgrAezdxVQdpuyzPOWXrSi1dauAIA1qfwVymDRahB0SHlDUExCmhy1yNQiya4tKBlKe3hyCJ4dEPdFe1dLUOfRB22OmOus3L9aJw1Hi0Rb5j0mHOpAl2fUFlWU45/s3FWrpTPs7l95vK0n+VvNNWWes/K3WG8dN9pC+8BOCFgGlILsOseRv/3elaAreGmEgf9PlLCQlxTj5efjmrDbP9kGEVgUhWzxkr3DxNiLZxlMPk8EoVLnaDWENlhYctsKZuF7WmH2RnKPxIBVeacGDxhUfxV47Tbw+DJ8rs+fmcs1XTW7TiWTdzYk7RgtvUDCM7rw6V1BhCsYToHK78XWwX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 18:23:37 +0800 Yadong Qi <yadong.qi@linux.alibaba.com> wrote:

> Issues reported by LKP:
>   mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
>   mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
>   mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.
> 
> Fix by initailizing err with 0.

This fixes warnings which were introduced by mm.git's recent "mm:
vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned".  Please do
point out such details.

> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -170,7 +170,7 @@ static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> -	int err;
> +	int err = 0;
>  
>  	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
>  	if (!pmd)

So we get the below:

: static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
: 			phys_addr_t phys_addr, pgprot_t prot,
: 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
: {
: 	pmd_t *pmd;
: 	unsigned long next;
: 	int err = 0;
: 
: 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
: 	if (!pmd)
: 		return -ENOMEM;
: 	do {
: 		next = pmd_addr_end(addr, end);
: 
: 		if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
: 					max_page_shift)) {
: 			*mask |= PGTBL_PMD_MODIFIED;
: 			continue;
: 		}
: 
: 		err = vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask);
: 		if (err)
: 			break;
: 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
: 	return err;
: }

If every single pmd fails vmap_try_huge_pmd() then this function
returns zero, indicating success.  Is this behavior correct and
desirable?

