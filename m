Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6D510F2842
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0BA6B0099; Fri, 27 Mar 2026 11:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8686B009B; Fri, 27 Mar 2026 11:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F52B6B009D; Fri, 27 Mar 2026 11:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0E36B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:24:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68210161127
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:24:51 +0000 (UTC)
X-FDA: 84592215582.13.2C13681
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C6F780013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:24:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NnJa6XL+;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NnJa6XL+;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774625089; a=rsa-sha256;
	cv=none;
	b=3rSDMB/DnVfTYy3JLttJIhGiB3RrBHUHeNx1uLIUYCzivEzcjVmlDgIvHH2ouaU+CVB6SS
	Y3WuZilDJaQ1MsZ2R6lxs8ZwF022+HAKvFeFjHkNq/mZ/Go/6UO+6j9NVHXAFgmKVr4M3p
	CrMKPylvDDIbxzXRxCwlmFgGv1g6ZXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774625089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Q2PffA6YYifiKcf2EiUk3uszb0ZXVQPuQyxIcvhv7I=;
	b=XWL9bVYI02qtxFgYviwskrcRaalXc7psSE6XrI1pTbxcDrxZsB4izfC8RvWmRozJZxrEa/
	JGYwpPSxhvgyJyFVEDCVwBAdIsV1pGxkt2tkFAH37CukIQp0lWZSVngqM9mUdqW9Iyy0cX
	76SQzSB8ixhXy36064uZEp+FjhRRVxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5618B4411E;
	Fri, 27 Mar 2026 15:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D571DC19423;
	Fri, 27 Mar 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774625087;
	bh=VYDOdE7sgW/03DVpEUGPbLiRjdDvx9n0cfqzfv8tiI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NnJa6XL+xT3kLl1ceyl2OHKf2JXNWdFzP8N/4v2qXjqc58mkc0qI8n+IJXyNgUlWp
	 feAmBo7aXumOAtOcxV+qUCcBiZvgm3fFAuHLsHoMsWJ/mIDDbI82t5GgzendgIhivU
	 EhRVW/VC5s5CcDjMgKwnOxuCz/w53MhA41RrAXvA=
Date: Fri, 27 Mar 2026 08:24:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Jeff Xu <jeffxu@chromium.org>, David Hildenbrand
 <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Message-Id: <20260327082446.4e7fd5398043d56cebb35a54@linux-foundation.org>
In-Reply-To: <20260327090640.146308-1-ljs@kernel.org>
References: <20260327090640.146308-1-ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C6F780013
X-Stat-Signature: 7eemge57gam5yka3aec5fy7q1ewydyrq
X-Rspam-User: 
X-HE-Tag: 1774625089-945442
X-HE-Meta: U2FsdGVkX19K801PDXKEBEEctbE7imyi0wgy2aFm3seca/6HrSBenIN+hBRjwZn2pAkX5AcivHIVYUyAQyrtoWylDS7YZd49oDizDwIfcFXU6qHbIZu2oRTaOslK2iYvl3NNA2nsqkVC+HRed6ouc/x8Yo+xXWPFBBfswdfuYvbk4CfiRFYVGqqfF8sbZyNzr8lcegMDi7wxEan17JyMGSPfuqNhYLDvXkgu8MfnEivHKiqOhjJhShOga4yMqB3NdUAHWJAO1W4nfo7tzaJ37nuGqgQD8dZ0pcofSDqQT3EGF4EfGXWz0E+NVNw+rcxiuKHGYktIERX4l2Qdg7N8iwBM8uxRwgl51gkpMrf+j998gGpFISTR0vAz5co4i46u0uF81XYMVWncbvO+sqI3nhXGc4tFfch46EOMOox5G9DIR0r5cd3mxR1IGwn8LJW6jNICM491haiou/o7h7c1l82I4K1mjx4mGHADmgW0DgO+o2+/4pZG7GhCV8s5CwCT15biYc1zFZcA7fv8I7toeok+HrChfhcq4zsTvPekO8DEBm3JysGo44pye5oi96V6o57qfEHlSIaPvqJPmg0Cm0ZWkeydNm39v47V/9jC/WlpIJdIrIlEPmz+SnSNZjLX/UfdZ+JtmdD9nJcrQZnF2vOWv3o+c5Zhzc9/uBR9UcalJ7FL2EsP1CXwgeKBq6LjnH4nzW1NT/s1hZRsDH2OmizljHDVI+P5GZVyy/aePyxR4aRpyHrggmk4iW3VDSWbGeQ8M671cCfvdr5Cdiyxns7KfifgVCQoineaFVhCXyS2wTKeaLuXVRmyVtmOhqL3GNnQ22rPA3MtNGJZjhcf7iwQKVl/oKyHuDzvruSnJobrON4SitVx/bAWmoHzisPrFZobwXkPNvrPRdFcTK0mIgtCIGmROTuw+vI1SyNBPrbwadO+nbhpgQ2LrxAVCL1MMNwiL7zspl2yb1RlkZd
 4IYszqpi
 cyiLsVJnSIbvs5YbkoYUubBblBeo4s+gleKv4gP9mZu74a7sAHSLkj4T2bB+6L8g43YaTJxb4AweSwqZdyWvureOEntUJPi9nCQDEDRuHymLRL8kfkjAtxi0Fj1ElIVdfWP7WoNENitOxnJ3GivYZ/BWhm9JBAxmDQdiy/8XWWOHxANfkuDx/h/QyGT7/Ndg/XmDEW4x3VaSU/wjoVflEzE0ugqVYsr+VgEJCbNfR8jAWnM+vEiVl72myPvsy3irYkJcSohYFjwhLtw4Er16kvaVsxKHxu6em+qoBuzovRZHWjfwPoXLmI74NDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 09:06:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
> 
>  	for_each_vma_range(vmi, vma, end) {
> -		const unsigned long curr_end = MIN(vma->vm_end, end);
> +		unsigned long curr_end = MIN(vma->vm_end, end);
> 
>  		if (!(vma->vm_flags & VM_SEALED)) {
>  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
>  			vm_flags_set(vma, VM_SEALED);
> +			curr_end = vma->vm_end; /* Merge may have updated. */
>  		}
> 
>  		prev = vma;

This led to some rework in your "mm/vma: convert
vma_modify_flags[_uffd]() to use vma_flags_t".  Please check my
handiwork.

reject:

--- mm/mseal.c~mm-vma-convert-vma_modify_flags-to-use-vma_flags_t
+++ mm/mseal.c
@@ -68,14 +68,17 @@ static int mseal_apply(struct mm_struct
 	for_each_vma_range(vmi, vma, end) {
 		const unsigned long curr_end = MIN(vma->vm_end, end);
 
-		if (!(vma->vm_flags & VM_SEALED)) {
-			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
+		if (!vma_test(vma, VMA_SEALED_BIT)) {
+			vma_flags_t vma_flags = vma->flags;
+
+			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 
 			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
-					       curr_end, &vm_flags);
+					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
-			vm_flags_set(vma, VM_SEALED);
+			vma_start_write(vma);
+			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
 		prev = vma;

resolution:

static int mseal_apply(struct mm_struct *mm,
		unsigned long start, unsigned long end)
{
	struct vm_area_struct *vma, *prev;
	unsigned long curr_start = start;
	VMA_ITERATOR(vmi, mm, start);

	/* We know there are no gaps so this will be non-NULL. */
	vma = vma_iter_load(&vmi);
	prev = vma_prev(&vmi);
	if (start > vma->vm_start)
		prev = vma;

	for_each_vma_range(vmi, vma, end) {
		unsigned long curr_end = MIN(vma->vm_end, end);

		if (!vma_test(vma, VMA_SEALED_BIT)) {
			vma_flags_t vma_flags = vma->flags;

			vma_flags_set(&vma_flags, VMA_SEALED_BIT);

			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
					       curr_end, &vma_flags);
			if (IS_ERR(vma))
				return PTR_ERR(vma);
			vma_start_write(vma);
			vma_set_flags(vma, VMA_SEALED_BIT);
			curr_end = vma->vm_end; /* Merge may have updated. */
		}

		prev = vma;
		curr_start = curr_end;
	}

	return 0;
}


