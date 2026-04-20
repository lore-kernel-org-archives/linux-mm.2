Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F540F36C51
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718996B00E9; Mon, 20 Apr 2026 04:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9B56B00EA; Mon, 20 Apr 2026 04:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606716B00EB; Mon, 20 Apr 2026 04:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4896D6B00E9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:01:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2047E531C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:01:15 +0000 (UTC)
X-FDA: 84678188910.24.3E42058
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6945B14000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:01:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u17F74nc;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776672073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=buRq9RvF/EF6GKBQx2WyRvyRBOYOt+melvj1U+/4eY0=;
	b=wpZkDwXLWxyYl7brwHjprKqqgz5vYGboydqnYKfzjQG9+yPV4CjAVeg/SjI+RK114YeQnU
	ph8P/Oe5COTN6Bm7OlDjBIxRL62jOg9FGPkJh11ZgXx+oRzZyMsR6A2uE2Q6GX9OtWTJmB
	was7kIl1IIP8wSHHGheKkqbdBFUweHg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u17F74nc;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776672073; a=rsa-sha256;
	cv=none;
	b=JoA/YCIzBpgGFv20J1IIern8KpCjHgOvDwYVdl/5Hv0eQlTVBxVLurn3fqLoKVPWKVpfcX
	naWBzx3tmEFyrHA0rA+ughlOPkz3plIb1bXRuYUQFBirjNoraB3V4MdvWSgyvfbHaxHdSu
	Gi5NNKE6t7a9UYO/kAUfH13OljF4mi8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776672069; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=buRq9RvF/EF6GKBQx2WyRvyRBOYOt+melvj1U+/4eY0=;
	b=u17F74ncbXrC2kof5lcm7YZMstRbWgpdd/iKJAkBf9sz0dpiAeRi1TxtQ2ikY+GyC4draUJZrttCsJE8BeHG6XRRP8o81K5QHvY9iOWRI2FcZUb+Wp1wgRU9aHp6oMXaUAMVQgQhy+kw2+1L24V2blzh2X7nrsjDYl/qgsFEneY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X1J0Agi_1776672067;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1J0Agi_1776672067 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 16:01:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
In-Reply-To: <20260419174747.10701-1-nueralspacetech@gmail.com> (Sunny Patel's
	message of "Sun, 19 Apr 2026 23:17:43 +0530")
References: <20260419174747.10701-1-nueralspacetech@gmail.com>
Date: Mon, 20 Apr 2026 16:01:05 +0800
Message-ID: <87tst6hxha.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: imxzmspfdbmrr133kg8nmbh5heek7yns
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6945B14000D
X-HE-Tag: 1776672072-139946
X-HE-Meta: U2FsdGVkX1+bsN6u7sWRY2VPK5W0pu0jZcPfG57jxWw9z4zmOZHKoZQN9m+px32z7aSUQM0OsN5cybwONuhI0ftfwwPnlIZdcNm6+aDjp+pa3JtT+eg51uPzUzi/1DwTwf+/C8gSss5zKKvNjO4m+z5QDySJMAk/3HgTf3iLaoYgl/nm032l4i8O9gGeyUPmrcyxVmvVXfwztj86Gde8eFBRJ6jBJgUP+Yt0zzjn1CAPy0j43dd71TYl+QMwASE3C8yafzwbAA7NKTs8/U8wu0AfHdi1k0DxK7tOXy6IBrMSGbiCN97EIoalvgYPmFAifN5WIDiKxi30yjvFV8IwayoYC15vSuXXENmfD2MIdZebW7rO24FDComjZoa+NPwL8xxzzGXW95vbnIoD1owoN74CDLPiwiMF2rJtN35uTkTDWsqwQ1v8vVVpLq3SuFjGGf67nsozXlXR3x8LhkTR7v37BsIbBWUJg2WzJyXua5hntogmwqIbAE5PQ3BXtahThPf50/kDpM9a++Qnf8b2knBCH0su/7++NubfufTYxkZnybmsr5dzmryzZGBGKl7jPMbsmLzqO1Juf264idk0tFr82I15SUesekuTbFyyu9hSX1z/JuRnUjHsliPqgkN/SdLaurJTIaoc8qjgeiUhWbQ1dGNY89WKFZPTver7/raVEn/x0roy84J0vEgMvmvvMtlbuVu0VyBdu9GHKGOzO+3uc/CsQpb6sb51PT5vBdFL/eW8vPCOzclt7Mc17g4u8J71xwHOyHn0AfUEpUCvjh+/R19c+qDSLYLrYVsfSkAT0Kl5Xy53MrKG2UbibBOwR83F0ZaFodMFEuPFlNudm8zBKkbxNyLNQqNivw+fUBWlkt/Y+MyRD36zQuicXGqyCox3MEt61wQWYy0dLYaBOB2cwRFOy88ui6LbiU0A+q54GhpKfgNQKi4U8eMUlsc8qX1gB+61kBPAj2FcoIr
 MLQ3r7fX
 mB3Bkr0ICcY5n1rWxuBQwYr0Xr/tithViu3ZSYWS5Mn3VTNDI2Hx7kRK2mzUME6onA9bZnEGFIEMIpl0g7QZGluMwvJaJ7OfeJBdv4aAjs4GTskVlz3GaeobYXSAogG9CErwao3gQ0pUUTW0dlVu0x5dSa4GOiZRl/ccCJmLuhd70HiuRpnfGag/yk/15vsA6ot8UKsMyAGFeYZjvjpEd1C0kbDQ41cG9zjX0eis/r7LExJnJU3Ympd1OWypbymPFKqAGE7TNmpLJTeYCITGpHkaR7ORc8X90cDBbHmfSthRsBm/huZ0fm/kRT5+X4LDECnpZwz0GUo/gaY7a2FhbVg0KLkiAwmR12SQ4Aj32BDQgHigYx6J+jCrmg2VHIteFLR7abXIPHjwyG3S7OkG9SLyasA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sunny Patel <nueralspacetech@gmail.com> writes:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
>
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
>
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>
> Changes in v2:
>   - Removed additional check for pmd_present() as is_huge_zero_pmd()
>   already checks for pmd_present().
>
> Missed it in first version of this patch.
>
>  mm/migrate_device.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 8079676c8f1f..2c7e89a6d1b1 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -807,8 +807,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	bool flush = false;
>  	unsigned long i;
>  
> -	VM_WARN_ON_FOLIO(!folio, folio);
> -	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
> +	VM_WARN_ON_ONCE(!folio);
>  
>  	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
>  		return -EINVAL;
> @@ -865,11 +864,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	if (userfaultfd_missing(vma))
>  		goto unlock_abort;
>  
> -	if (!pmd_none(*pmdp)) {
> -		if (!is_huge_zero_pmd(*pmdp))
> -			goto unlock_abort;
> +	if (is_huge_zero_pmd(*pmdp))
>  		flush = true;
> -	} else if (!pmd_none(*pmdp))
> +	else if (!pmd_none(*pmdp))
>  		goto unlock_abort;
>  
>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);

LGTM, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

---
Best Regards,
Huang, Ying

