Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D19FD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27426B00FE; Thu, 15 Jan 2026 15:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF406B00FF; Thu, 15 Jan 2026 15:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C056B0100; Thu, 15 Jan 2026 15:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F91C6B00FE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:14:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29BF7C1DFE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:14:22 +0000 (UTC)
X-FDA: 84335300364.03.337C98B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4377716000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:14:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sahBdAxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768508060; a=rsa-sha256;
	cv=none;
	b=DWB5egxanoGqZ4xl6VlzoxP+UIOupOCF3sbLAx8NrXzMsgixd9xOFugW9Lotwp17XDHXGa
	43HPx9PcywYBgYHFQAozU8UfjoBK7ZxahQD1gE1bISNdbTg/Ek1oQ8ITUd7STHie5k7/fP
	HCbpqGcAuM5/HWQCdchQLC3uLzXB2vg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sahBdAxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahMFdVUT0O7Nu6IY2r4IRBirTiR7gqCq5x8n0YpjfHI=;
	b=6tW7sd9/2SMu797GBZblTAJVuC57YMxUsn8cZ25tg9izZqIXVrv8ekBW3cqIVWb8b97LAj
	N3W3upV+US8dpt1FQVFgNin33LKe/uAZzjIc1A4xylaMGXHw9ioouirZRCJfwx6pae9vjQ
	Wsrk0kHlUUMCVV+mluMb/wa7D2Yvbuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C4E1417E9;
	Thu, 15 Jan 2026 20:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F0C116D0;
	Thu, 15 Jan 2026 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768508059;
	bh=MeRdy2tWqSetzFyivcrMpmAWXOBfo0urVIzqwG6Y0AI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sahBdAxgO6bHDTwAAUT7AXRrCinNVYHG+/tjYTdZcKn2wJNBqVh++8LIJSRp1ypfd
	 KHwlxwy5GczfHeZBZh2KaTnov9XmYURTuUBdPBgFQsF1OdeigO9Icd+zqNhYZeNQNh
	 3rnmygVTBXQgpMqaANI6rD6Jiv6g3YFwQJDLjGYrV6IFSEixSc2NEqA9fQrTQ+dmap
	 SX+t7y+BUIIrtDrhkOjmIDxHyY0LaseKb1VjtWpjL/5r1+nbBn4YymreHPtmNrVXoY
	 u3f9ZQ42ctNL7T6ffCQVDIZdyUpr5jOGJ7OKDYMPFQNGiW8w/c1nyzFQld9l1JzYZX
	 tjdjW1XQEjLlg==
Message-ID: <a63c7a84-99d9-40c6-93cc-6c6fd46c4333@kernel.org>
Date: Thu, 15 Jan 2026 21:14:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
 <20260115181438.223620-3-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115181438.223620-3-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4377716000C
X-Rspamd-Server: rspam06
X-Stat-Signature: keuyjdmhbm5t7se41gcbh86cdcagiw5g
X-Rspam-User: 
X-HE-Tag: 1768508060-512279
X-HE-Meta: U2FsdGVkX18/s5CqJEBdOE2WQU6MUsK/bNxqEFAGmiwOfpwiIJNeQXf7Ss7N/PrHb+q4s2jm8leeRSnyUHFPuymgCrgjkrGfurzPr21jv+DIUjs9oFxUHyFhFRa6BtTFl9Y6j56srmtIDeTRmTzo0FoD/XWrPC7eP6QxLOzNEaUzmctV6w/PduUbr79OGteewmWF1olf/Mb77enpK8NYG0cmmwRngiDQALjEZiBhHtCcRvk+zOrhq63U/7HXrpi0W923v52oh/wFxWchY0anGSkeda4PVFKzpFh4OIdR5jvyc798aon0X4HcSPOEwLooBNXa1i/AJuUiaOgvBd3PV3Te/MSoAvkrnZVS4b7ETaV9rio8PJh+7WIlAfnTh+/BeMzxUXyA5Rnc6q+Taj4yyYPpjTOn1o4bGPVC43gtSStQWS+Qs862KQKqax6PMER1jXEHGN5AAoxCTWqd6s442E3ZxMwbitx8UnhCqAusOuvpS8/wGm/4krEl8NFlfNyRKdXcjUXbjCC1bLNQUk7DIX0Q6zBYabKgY/Sc7BaAGjfOq2Ya7eZtQwbOLJ8D+5xqYj3WgcieErpdTsTq+LO9Sl1R4bCte/2cQzr2G2bRSYokOFsDVpkNhAcjHDDM4mSckP+iO2AFLGdsMoUnXEW9sOMpzq67RazCLfi3p17LKkPMABuQvvjpKydMYe+zeRtsT9H4UQpc2c20MgwkLcnIKDzMF5dIlwdFXx9Yx4DcFbEnU9o7P55Dp1o/bkXGmCAT4bIr8HrNycbwQCh9zepIJX7GGjpVv5P6ajbFnCQ5jOcjdXNJqSQvab2dklEV1053Wh3icgBZwKwsWp55021FTpPhvAYQ/MRApQ/Gw8FAJkodQIaMpeXBuVoWBELY9m5G3TahLzohKDLl1V1nQ+bfI/eQLwdeTYUdkK6BAIwyE4A1GTA+xoz5ibdZYt+iUJPC8VawZ7R53lDng9db/0F
 PCbcgNUI
 Qait0d9QVjFrCKmwDc/5Kq3YDaZvyAevcBbIR1Z60g2hyO5fwjxZpN8CSYt2DyQxzn5bPJqfuN6rmhtbd8twz5/I+R6dX1czxQh3E9Sb/GL9h6mavbc4euTtRnJcTQSMHC017RzctEFIxwz+9Gqm4EQG+27a7Oya5yJZRQlR/O6tTYsJNhSwSWtbUyxFZHUkKCppFVPPOo+CmhRQvnib6/Dt2xOYctoid1SBL10qCGaXWyk796zKjm4M2q/Fgu8R9JJ7GpgCi7sK76YK+i5az2jk3HDs1iov/Xz0HZr9CwneIKoqlIGLhQQea43uNS0ObCFGm3oEiEs/SEErNQwMXn/JIpiQFGVQQ6OK66YtsMMOquPWIjgisNLBhfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 19:14, Joshua Hahn wrote:
> if (map_chg) is always true, since it is nested in another if statement
> which checks for it already. Remove the check and un-indent for readability.
> 
> if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
> 	...
> 
> 	if (map_chg) {
> 		...
> 	}
> }
> 
> No functional change intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>   mm/hugetlb.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 88b9e997c9da..432a5054ca1d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>   
>   			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
>   			hugetlb_acct_memory(h, -rsv_adjust);
> -			if (map_chg) {
> -				spin_lock_irq(&hugetlb_lock);
> -				hugetlb_cgroup_uncharge_folio_rsvd(
> -				    hstate_index(h), pages_per_huge_page(h),
> -				    folio);
> -				spin_unlock_irq(&hugetlb_lock);
> -			}
> +			spin_lock_irq(&hugetlb_lock);
> +			hugetlb_cgroup_uncharge_folio_rsvd(
> +			    hstate_index(h), pages_per_huge_page(h),
> +			    folio);
> +			spin_unlock_irq(&hugetlb_lock);
>   		}
>   	}
>   

MAP_CHG_NEEDED = 1

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

