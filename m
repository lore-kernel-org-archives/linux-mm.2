Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F510606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFuaSYbA
Received: by kanga.kvack.org (Postfix)
	id 81BE16B05B0; Thu,  5 Nov 2026 08:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC8B6B05B2; Thu,  5 Nov 2026 08:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA556B05BF; Thu,  5 Nov 2026 08:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 513EC6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:07:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5B6840996
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:07:09 +0000 (UTC)
X-FDA: 85401090978.23.F333C8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 388BB140002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:07:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFuaSYbA;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jOK42kEV/R7k8n51sIGLXDORmkNj62Y+kfJMXSo5Mc=;
	b=qoDGzgrJEzL/IS4fecOb3tCyONZYK8oSuZhNjZFsgR/5kJPisus6/V/IOuCX+ye4cysEyV
	IDHWw56/GT/vDhNDOEzE9wSM8yzTK3X09fEbL/SCMfsZR9GuXTRR8lGyUfcNFhSHj4IodN
	N0hLQ76beLA7k56iBPtb1o0L+UsTAGA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFuaSYbA;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884028;
	b=bBQWLC3MBbcLRwZzLCf1irzy9zEmEDZJQnJRLHsdH+u6hvQzsDb5vsMPnh0KZD58rus/tA
	FbIqyYg4Cb1WD3/sDpHKlXKuTfmNirRsGnKD63fAkGrB4vMpYO73AUyW8JTWHjGEikw0v9
	aFhm0Dap7oX7D7Sy02rcgK7yDsIq7y0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B70C960267;
	Thu,  5 Nov 2026 13:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805411F000C1;
	Thu,  5 Nov 2026 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884027;
	bh=1jOK42kEV/R7k8n51sIGLXDORmkNj62Y+kfJMXSo5Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFuaSYbAn6Wzfg2xYzR2T2rOKC0XDbDYhBWedM5J/RUQvjbBWRjzNw4K4Dn/iQ0pF
	 dSQ+7RvtRYpBTa099A8orQ6Eoq0V5fe9WiOoUXLjtRgOgAQfU0xXOlZ0vTQXkEkXgu
	 KhEdHwOq6KB2VVmaJviQHb2UVnhjNnwRasKvHuuLi/RCLBovWXTXG2Kzg30H2E/hBR
	 jaktqUPHCfXxQqnxAnd3VasCNIvl5thBnv+GSakC2ip8kbNsnxNBgqP9PzvcDFP+aR
	 ocLUpRelVHZhyx0N/goW4szRfWco2GGXiVwl+gLHV7g/U/TuyWb0AGwAN3fy0m7uJe
	 vaUjtb8+88F9Q==
Date: Thu, 5 Nov 2026 15:07:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr,
	pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	shuah@kernel.org, guoren@kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v2 1/5] kho: Do not translate the handover FDT address in
 is_kho_boot()
Message-ID: <aux_dPnvXk3LYDxs@kernel.org>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
 <20261103080926.2079-2-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103080926.2079-2-cp0613@linux.alibaba.com>
X-Stat-Signature: 7udbfcgnqcqhqi4iwgt1w4qe8abfbcr8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 388BB140002
X-HE-Tag: 1793884028-710615
X-HE-Meta: U2FsdGVkX18bkkNlyf0bcP7xuW/Orud74z/SNNcYEL7fk9AFCJ9YkvXQuo8PNlAeVWZzEhm9Y/7hUelaYsi4Tn0sVC6fN9/34B79ceBztuLAaMbqKffDst21CrJ5EQZqayV3XySjNFs+wft7icQ84/3RDY38UhkP2vq1PH5QNuMf9ncBXESzuL9srnIiL1WbQO+knM1BBnxbsPnl2xQSRoTirjt55SbP5EFQsPxf6jvrEoDay8cWwxHJEiHlUAPm9uXLf50geykZYZMSJeFff43eSy59Pj2w3fdxvnhtMjkizODyAq5EjG40CVRpBgeZlUKJ6/HftqRAeLngtTgIgKgtzpLhTY42ZMYzsCfTj3Mjx2GqK2m3+Fvm+3/8vxPuzhsh18fIRaahQd7yVJSoTaUfSDxHv2LG6YdMCMfTjrpx7ptrORrOjGbJkld+NAn12IVf99N8apLiA345ASZiaKxn6ba9ZorkuXRt+oqni4Erq9bpOCNsw4iDIVYFNnaFFVwoaxR2K+KWWwwVBDTcvVzXmvSXgDY5WRQUH31XIHG/+GginE5gfYQSHCMl/SN+qHKt4qnvHcXZMu7V6t7TT4IrwhvxRNy6znWPKRXtJqu8026lO+AX2PB47BUACrGf7DyYqT1rXPvy/kHgP+vNZVs4kkvpNqIzR9HcbXufrLFYz1pHi0cmZqe+DJ2SauyUN1CYdr2/qfcRIXuvPuDL384k75nJ5FFIpsDvRumKYrlbPYxV/+XCmS5OigehPksbCQhtm1XkxzCmQlwRug5wHV3DbOWFKl5EKWBN0C/1XgwCXQ1gHaSs+Cq0ZkOTS8ft5CV1CG7xq9+QrUwoLUMkBAtBMhT1XQC74J9LsnVI2feuRAPemWrMECSwbIKSPGguqdyW6+IrcXPooB3VUJiUfZG9zhuT2uDupn7FKubGdZsrtyBkOJGL+hZvleAQUrZ6fMmKCq9E3sFPd7seMLN
 40plX3qd
 pCp+Ag9rjBc9KZeUp/RfjOrWso+wiyRmkFEIDj4z+Ye7IHAWqM0r1xN/oyvgcc5pzlyMkzxMsOO7yqyeBF+ypTWDByqN6eZ6uhgPH9G3Zj/HOQWOJXqiQwfEmOz0maraGE9DzUgiJQt1uzI4W9mnG6c+hHPr6s4NeRKimRcjOGwuogmECI/w8Yg1v7t7jDTP8FbDMlOdLIsNpMO1CLXcZ+k0Gc+v+m1RqGn5xgrsilmdUiIP9HgVwRI9fIFiDWN1Znwpo5YAnwbPLGCVTDloBBCPrCi1oepeGhJqfCJoOTDaGsVmOYOZz/MF/0CypEPakQ1tewP3iMDxYA7mQgxvHhxGFgO2AbVlb7tNPSQmkU6j1rBrb8cmSr78Kaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chen,

On Tue, Nov 03, 2026 at 04:09:22PM +0800, Chen Pei wrote:
> is_kho_boot() only has to say whether a handover FDT was recorded, but
> it asks kho_get_fdt() for one and so converts kho_in.fdt_phys with
> phys_to_virt() just to throw the pointer away. Both callers use it as a
> boolean and never dereference the result.
> 
> On riscv64 that conversion is not valid yet when efi_init() reaches it:
> setup_vm() leaves kernel_map.va_pa_offset at 0 and setup_bootmem()
> assigns it later, so a handover boot that came through UEFI panics in
> linear_mapping_pa_to_va(). Only debug builds fail -- without
> CONFIG_DEBUG_VIRTUAL __va() degenerates to "phys + 0" and the boolean
> stays correct -- but the panic also goes unnoticed without an earlycon.
> 
> Check the physical address instead. Nothing needs the translation, and
> architectures stay free to bring their linear mapping up whenever they
> like.
> 
> Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> ---

There was very similar patch: 

https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com

and while both Greg's and your patch are correct they both have that wall
of text with too many details commit messages that I don't like.
 
> Tested on qemu-system-riscv64 (virt, -cpu max, TCG): edk2
> RISCV_VIRT_CODE.fd/VARS.fd on pflash with OpenSBI fw_dynamic.bin below
> it, and a GPT disk holding an ESP with grub plus the kernel and an ext4
> partition as rootfs.  Kernel config is riscv defconfig plus
> DEBUG_KERNEL, DEBUG_VIRTUAL, KEXEC_FILE, KEXEC_HANDOVER and the kho
> selftest fragment; the outgoing kernel gets "kho=on" and the kho
> selftest init does kexec_file_load() followed by reboot(RB_KEXEC).
> 
> Before, the first handover panics.  earlycon= is needed to see it: the
> BUG precedes console registration, so without an earlycon the machine
> goes silent right after kexec.
> 
>   KHO: found kexec handover data.
>   efi: EFI v2.7 by EDK II
>   kernel BUG at arch/riscv/mm/physaddr.c:47!
>   epc : linear_mapping_pa_to_va+0x1c/0x1e
>    ra : is_kho_boot+0x18/0x28
> 
> After, the same setup keeps handing over until the window closes, 29
> consecutive boots and no BUG.
> 
>   KHO: found kexec handover data.
>   KHO: exec from: 7.4.0-rc1-next-20261102-00005-gfca49e548231 (count 29)
> 
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..6ab181de345c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1643,7 +1643,7 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
>   */
>  bool is_kho_boot(void)
>  {
> -	return !!kho_get_fdt();
> +	return kho_in.fdt_phys != 0;
>  }
>  EXPORT_SYMBOL_GPL(is_kho_boot);
>  
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

