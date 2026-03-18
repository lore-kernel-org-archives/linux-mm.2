Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900D2103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05ED36B017A; Wed, 18 Mar 2026 06:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F2F6B017C; Wed, 18 Mar 2026 06:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E673F6B017D; Wed, 18 Mar 2026 06:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D79EA6B017A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0D95160646
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:38 +0000 (UTC)
X-FDA: 84558888036.22.8827355
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 19D5E4000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnSbOvdZ;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rOA8H+GQtvpdRvXXbxgFmO+ydfxm9AeRJ39qbow0dg=;
	b=Y30AFPhday9qZ4+1/vSBfGSCGwMWR0e+qG0Nl9Mc/xXc7gF1lT1MY/tA6tyuF58dfrntqi
	ZIl74jKDJhbHUUIHdmtSHpcX/9QvPeRZzR3UBQwvnMn/W1FpwyHb4AyOuphus4Q49KhkRt
	8qHgCfcmdIaNzxIjncrxn0hfSsFwU4Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnSbOvdZ;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831577; a=rsa-sha256;
	cv=none;
	b=Ojt1SUb2LrpM9Mi1Uz1W9gfUKVBRFo3KYWTs1hjtSwDW/VjiGtyJm5tk41E3pRHG1R1YLl
	1lic+LaZiRFwwFJ4FzxqHsANNcx/v2aqlH7GMOonx1N7ctjsjCWJ2qAMWrNALvO46koyYY
	Cpm81DZRQseYxLpjkVB3sOr6ISsN73g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B79760130;
	Wed, 18 Mar 2026 10:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33DCC2BCB7;
	Wed, 18 Mar 2026 10:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831576;
	bh=0ShdU6XnHry9BalQwUrCEadIrmh8eEmlFfcW58xBUdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RnSbOvdZOETy+Kgv5ZzXnwjSaFczKrOid2HwZ5foMfSo2d5oliCd/6fp4a5Nf1NVc
	 /vARLcLVdio9+MC9DffplSNb1AayJthJAl/zW1L3ReOLZlBqA4jT0WiTU2bO13B9T+
	 2c0g7R5o5YVep7A3tCL2dLfEnyKCca2HL9DD3LAG57Wc0kTo6E5bylr6sYLgGP0F4V
	 dNFM7CyT99aJUkK0qLvi6TsRW/st9BczIE4hsUC+XlwGb5gHxGn6fR+UFXDYHemc3U
	 GaJ1rdMKkVldDwujLwFgooKmSsQoqO7E2dBnpXIdR5PVBL4D/cvFza6yDP73yd4sqs
	 5bjcSVbwy00tQ==
Date: Wed, 18 Mar 2026 10:59:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, riel@surriel.com, vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 19D5E4000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 4n9zrckuapjoqfw3aghy88j84a177kpp
X-HE-Tag: 1773831576-113572
X-HE-Meta: U2FsdGVkX18EQN4qdEM9o5U1uAHMz+/NR/zcchpIHUO77QhlFt8q+KuqOHQeaIiMDuRcsNnEHaN3tIr5eTDfO4A/171IsQT1ju4MPnXktUmJn5qCClyBW4exYXpR57kOQYz7E+bH7tko0Lb1iKr1Ybz3sb2n1eftoU5L+lZEQE5K0B6h5Kdxv2Ri9rJaBqquH88Zwh5MmyxsjbydMwONaaVB8GUjm9veN/cXn1MxV/0N9op3PbEQK/Dtgcrib90OCqeN5DoVTfq2zyTxFkXuRPCfo0xIPdt16TL2RjerdNaLHj/Wl48klf1PG2yGMjLOIOxpPHsxz8XFMPn++amNd0IaK0ZCXGVGiKMdDAnFAedaO7nMtSKc0UglK9aam9upcts+50KPInlXJH7K65woeb0FnF9cI0D4FKjrjiMFw+1f/RR4N9XqliDzrUg6pdwskdHwOyV78nWF9wA/uU6Ybweo4v062WLPfGOKZyFH+Ci1RId4UHYhnUGghbyaJd6j4j4eGpYrOWET0n9wZ0CVie5+wtPk2Ofhp97iOPAY1a3d4nZEQqttwhqHttzNEy9plNqqFWKMIkTsTqgWXEfExmuJGA9dDr4gu46HbyJ+i4mHktxp+3NXsYZLmq8xnBIUJhNn0XwrQ6Q3SLmLS3VgDcPHgqH1EnpU4eImBKavkTYmUHbbaacz+SuVd5qPBEaq2mZzghjNm5ZUBQM1q1vYT8GbhVAAGL2uOXntFWIUhoWSDkWEtKuBGTANmZH+lvhQuwfCB3kmiAu6XmUKJUYt8TiCUWsW0p7xi2VIIPD7SXBIcba/iDdR6VyHEu1cV/pO74pBsNJUGrjc/SSIBoYRzjGdEmOBvsVvAJMidxml+JxwwVKoESZJepXx9DYwOsfgnRLbvm9dx1I7KBwUsIjk2fq9uJ0IPMiR6rzhd2578MbA1mPG+ofNs3CaedV45Apde4X0VSP7XNnXLyVSMTs
 syWjbjP9
 cAE8kBZ2rHiesfWR5wQmUThfXhZ0dUAV+8vqW/7mf6OoU5MS6dVARfyE4+tzS7f/4bppC/j65KF5BRjvBrgxr2sH9fZxZiTVwyN10OeCym6+yIHvh/UzUZwR++oLDemtjOMYeRjlfCt9jsJNsa//nFxFc/7EXDdKNWq1dYf87AgXgsKuaWhGR8cYfSSO7AAcoQdfCEWIGD6jcw48z0ju4R1o9pGz2Nj8aNBAx1UlD24TcnXGUbf5MlObD9v9zusC7j31N2XKOVqzDft6zuiKRPrnxAewdFQqqhPwMcegrn8WtgCvSk08amOZXLaBw/bGbAUx0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(-cc old email)

On Wed, Mar 18, 2026 at 06:42:49PM +0800, Jiakai Xu wrote:
> Hi all,
>
> While fuzzing the KVM subsystem on RISC-V, I stumbled upon a kernel WARNING
> that triggers in unlink_anon_vmas().

Thanks!

Will have a look at this.

>
>  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
>  unlink_anon_vmas+0x562/0x768 mm/rmap.c:528

Assuming there's not some big mismatch with kernel versions this is:

VM_WARN_ON(anon_vma->num_active_vmas);

I seem to remember a possible case where the resource cleanup was wrong on
certain error paths which I was sure I fixed, but I can't find the patch
right now :/ so let me check that also.

>  free_pgtables+0x2a0/0x860 mm/memory.c:427
>  exit_mmap+0x406/0xd14 mm/mmap.c:1314

Fact this is on exit path suggests either misaccounting of
anon_vma->num_active_vmas, or a VMA is somehow not being cleaned up
properly, most likely the former I would say.


>  __mmput+0x114/0x3d4 kernel/fork.c:1174
>  mmput+0x74/0x88 kernel/fork.c:1197
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7de/0x2adc kernel/exit.c:959
>  do_group_exit+0xd4/0x26c kernel/exit.c:1112
>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>  __riscv_sys_exit_group+0x4a/0x54 kernel/exit.c:1121
>  syscall_handler+0x94/0x118 arch/riscv/include/asm/syscall.h:112
>  do_trap_ecall_u+0x39e/0x62e arch/riscv/kernel/traps.c:344
>  handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232
>
> I am not an expert in this area and have not done a deep manual analysis.
>
> The full crash log, a reproducer, the kernel .config, and the relevant
> source/commit info are available in my GitHub repository:
>     https://github.com/j1akai/temp/tree/main/20260318

Thanks, much appreciated, will try to repro locally.

>
> If this turns out to be a real bug and there is anything I can do to help
> with fixing or testing, I am happy to do so. I hope this report is useful
> and sorry for any noise if it has already been addressed.

Thanks, and no it's not been addressed AFAIK but let me dig into this.

>
> Thanks,
> Jiakai

Cheers, Lorenzo

