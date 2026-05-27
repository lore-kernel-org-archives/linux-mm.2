Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7DCCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA066B0005; Wed, 27 May 2026 14:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A7B6B0088; Wed, 27 May 2026 14:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171456B008A; Wed, 27 May 2026 14:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2DE6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:28:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94B2214067D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:28:45 +0000 (UTC)
X-FDA: 84814035810.05.4BB8D4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DAF4A140006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:28:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkJ+CqYY;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779906523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UBPRqt5aK8NgfUALvrYrTLfLGbcXXtkVRVkSHYLKXE=;
	b=EFTPoDvMFDP6P+xdbNWN/Ts6fWP5JdXBNhthWsNUXakG14vh9PqFs/W/apN4s3SotIpu/n
	Hz4Wd5GHPwHJtqlnZRyq4ZQEOHmoX3bBDoGsPdIi6oUuZ8nt39Nz0wCvL6C+KDv8Pxqwht
	+a9roEM3FYXwvYoTY4qmD+H6h/QoQls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkJ+CqYY;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779906524; a=rsa-sha256;
	cv=none;
	b=l6ORFvFx3Gqx9a5iOQPwIVOxMYigGU8pOojTuqcjJRZdX5iu2yfoVtTViHl+cWETZWvKYK
	0to9Rl5ndbkfpCoYsJPGOfbQexT1UOPgiWjthtK5F0mW2NWk6KM4wu9ZqBFEtJE5HMlsbA
	tlbZr4MFFjsxdXP4bjLlRRcW75KhGBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0FAC440D9;
	Wed, 27 May 2026 18:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E51F000E9;
	Wed, 27 May 2026 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779906522;
	bh=+UBPRqt5aK8NgfUALvrYrTLfLGbcXXtkVRVkSHYLKXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kkJ+CqYYC3TjrIVm1bSP+yy6GdPJQKO7KEbDC7tXSg+EjBtPWle0vDTd3Si4yjY77
	 yRu8daKMjU4UKJ2U9zws8q2x144wJBEZChmEBZDwzC2vDaMZ97bf3YjL3ATRdcLrEC
	 49VIBhDs2OnX1bbQnE0Sr77EjRWdUXOQY2SWvyvIZ9v+v+ypv60mF7if+49q8GzTB4
	 5GMvXucJ33tVFMv+ytYkvRkHzdYRxZiMNY5/UiB2oC3EP3c6HvQoPBQIuM/mXqlAbg
	 cMi2T7MWnXYTFT2XR+z9pRhHxDJCUb3DFgvHvch2KTCsDr7QCnCKecHCWtAYgS7uaS
	 +NzC4lFFqR43A==
Date: Wed, 27 May 2026 20:28:36 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Karsten Desler <kdesler@soohrt.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahc31AChKqnfItHW@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahcTYufV7P5Cmotq@localhost.localdomain>
X-Stat-Signature: dd5m9ehe8sab4nc8nycoz4hmhss3scbj
X-Rspamd-Queue-Id: DAF4A140006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779906523-759103
X-HE-Meta: U2FsdGVkX1+7jYb0Qz3CZnrMxuI0BGrImnN5dct28xuSZyanz6YSPq7wyVMGKtG31jt2GW1Pz82CfqBomSSAdap8mmUbaOdoTsuVPw8YxbQioX1bNUziilx8v98NxD/FLW6OD9YgMk8QSwvZ7ahzn54y9OHTGnuSgK7ux2hsKhVBevke0LSV7HuoJeKJwKbfclqxo5zCWj71g5jUVJzIvldlqQ5u57QsJTnwMxmOYJDhTGfw4kj6prQb1RtBXMt194MSt8D5Pgo9fXMZ9QoUDCN8JlC0bK1nsg4WTbfaYKMO0fy8+4fdiSd8GuWMMoCs5RVbmyr1lQl34G0nfQQNyqaGuN5hFXTCDhWYSgTpoNkSWYojZmEElcWCWLJ8ODGU+SdbjwoQbeVFi0wWjaNwTKyEAfyXN9FcIpXHpBLUn+5hTxJsnfxxdZExlu/UflaMJoCOEUOuLUqfICTT+waTr+ZT5J/hGCU5cR1jZ4Mqgp7f3WXm0XKdeQD/I4z2kXQAdsBhIWAeR1xOh2dZEc/wRz0WJOsphs9sCVNuHL0atyiMKQU5dxYZqYBywWm2/a6qGTUt2uAF0ReJIJzkMsTp5EExqGMRloR2KdfwLNNtgdHp4WoOiurMYE3da30h29iRpQaBzIDYSH7mbBffe8Mz/xbpYuayILG1p5Pwa1molthElFmiU7S7yN/Z915XhsWzEBVfxZ5iZ23nPyXnDzH2BX0qAT/R9He+526n0N4FuRlkNoycnchlRTocX2oMvfiJRx43lPJMROZJH0KHBqtoixzhg/qzNF9BH7BiSCRL61lCPnAP+rUSrcMFAol8ONeJ9yOkN/g5AyY8W5tFI0Y82oNznt3eO06fpiy3JbhQ07qPV9oUSqqfCE0hiZdFwVMIm16J5AuxuLY38kEPb0jy+wkcKJaAwVdVWBvDSLhNvFcvvm+PvEEFbz6lt/W30gc3w3iTWSnkW7KQ+VhFawp
 9Z/Mw2GD
 c64M4cSJfO0p9oxx6ABTZmUA6KGbzwmfGt1JqqU5aKCf6Rh0Q07vMYybptAhyM30XF8CjpDhNfpej0moCDHpw92V12Lzi/6jplSMz5ls4z1xJrOI0a0FeeslpnCEek/dCrm6mAMfE/NnBf9YjW72C+R+fCT8idXtbGkPRNxLNCZ1b544B+BlQ8KwW6/ejWIqzbMyX6PizoD6hGKD7ILsMUnbUMyz0qW3PAu7j+I4/trvJ8aRQw/Mmev3dmC328lJF4vad
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 05:53:06PM +0200, Oscar Salvador (SUSE) wrote:
> On Wed, May 27, 2026 at 04:36:43PM +0200, Karsten Desler wrote:
> > 
> > For hugetlb, get_align_mask(filp) correctly returns the hugepage alignment
> > mask, but get_align_bits() can still return the AMD F15h per-boot offset,
> > e.g. 0x4000. That produces a non-hugepage-aligned hugetlb VMA.
> > 
> > Likely introduced by the v6.13-rc1 series:
> > 
> >   1317a5e7f7b1 arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
> >   7bd3f1e1a9ae mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
> >   cc92882ee218 mm: drop hugetlb_get_unmapped_area{_*} functions
> 
> Yes, that was part of a refactoring I did some time ago.
> 
> I will fix it up later today/early tomorrow.
> 
> Would you be available for a quick test once I have the patch?

Maybe this? Can you give it a shot?

 diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
 index 776ae6fa7f2d..60f876dce8e5 100644
 --- a/arch/x86/kernel/sys_x86_64.c
 +++ b/arch/x86/kernel/sys_x86_64.c
 @@ -157,7 +157,12 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
  	}
  	if (filp) {
  		info.align_mask = get_align_mask(filp);
 -		info.align_offset += get_align_bits();
 +		/*
 +		 * Hugepages must remain hugepage-aligned, so skip adding an offset
 +		 * in case we enabled 'align_va_addr'.
 +		 */
 +		if (!is_file_hugepages(filp))
 +			info.align_offset += get_align_bits();
  	}
  
  	return vm_unmapped_area(&info);
 @@ -222,7 +227,12 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
  
  	if (filp) {
  		info.align_mask = get_align_mask(filp);
 -		info.align_offset += get_align_bits();
 +		/*
 +		 * Hugepages must remain hugepage-aligned, so skip adding an offset
 +		 * in case we enabled 'align_va_addr'.
 +		 */
 +		if (!is_file_hugepages(filp))
 +			info.align_offset += get_align_bits();
  	}
  	addr = vm_unmapped_area(&info);
  	if (!(addr & ~PAGE_MASK))

 

-- 
Oscar Salvador
SUSE Labs

