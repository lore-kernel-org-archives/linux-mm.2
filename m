Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF44606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=VNIuT+eZ
Received: by kanga.kvack.org (Postfix)
	id E30896B0681; Wed, 21 Oct 2026 05:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2466B0682; Wed, 21 Oct 2026 05:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7746B0683; Wed, 21 Oct 2026 05:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A72126B0681
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:05:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 928FFA04A4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:05:41 +0000 (UTC)
X-FDA: 85346050482.08.9B03664
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27F65160005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:05:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VNIuT+eZ;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792573539;
	b=8Ki0yp+oAg7LByQWrTFqcqDhBkGHw4bbpfp6S4juJ+AvFeQOF+LqTbEOz4CgOYB5ZeHDPu
	20c+xvrX+NaUzgmvlT5MrILVncqsOz4uZdroExr4WS0q4UsLm8FCuVITTYVjeqA2rqMOLx
	v/svIYxHihT5unIiL0kNOSKqefNc2uY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VNIuT+eZ;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792573539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qly2ZXVqJU8mRHFencdxpDDot1stjgFFpJM+J90ArtI=;
	b=Hsh6D9z3ipKc+T/DjrE2xn5s6apT9DtMbjstSwIp21nRHKN7lU5QZVAyhtEons+CGe0IrA
	iA/dwHYrVea3XkWvCOi8SZx0SY+2j/s+hyssS74yqwqeHkH+Rpdd9iApRpDibWZpW7mP2I
	XP4JKgZtgfKendS33wIAgiIMFKgAxGY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qly2ZXVqJU8mRHFencdxpDDot1stjgFFpJM+J90ArtI=;
	b=VNIuT+eZ75BYq5bEgDxPMwxDJad0LsRd2qh8O5xIl6lSkVcMxoMw0iYMTpsMxZj6Jahuezyk/
	yCYxoyiTPQ7Vzfr1pjBJxOpwsIQj3XOgI1W9mckRnRaKJwL0kZrJRME/xKwgmPeH9Mbs9PUKvqW
	U5k8YRQq520iy9kJHkZbWqo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j8jks5JQPz1cySH;
	Wed, 21 Oct 2026 16:54:13 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 682B34058E;
	Wed, 21 Oct 2026 17:05:33 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 21 Oct
 2026 17:05:32 +0800
Message-ID: <6d4ba1c2-b672-465b-9683-0aa1ad8dee73@huawei.com>
Date: Wed, 21 Oct 2026 17:05:31 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/8] riscv: build crash_mem ranges from memblock
 instead of resource tree
To: Wandun Chen <chenwandun1@gmail.com>, <robh@kernel.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <m.szyprowski@samsung.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<pasha.tatashin@soleen.com>, <pratyush@kernel.org>, <ruirui.yang@linux.dev>,
	<robin.murphy@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-riscv@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>, <iommu@lists.linux.dev>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-2-chenwandun1@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261021083011.2170525-2-chenwandun1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: wh1pud3z4q1erx9u7y85qxnnutt4h69b
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27F65160005
X-Rspam-User: 
X-HE-Tag: 1792573537-70742
X-HE-Meta: U2FsdGVkX1970AiQ9NclEF1WQsf/WuNGWd3PPEbMt3chrv/OS6XySroaVSUdcaaPsuYtr0+2M6gwyFsQiMyn00dceC7abBemoBTG33irrUCjUM3FNZv5teztcBSOAoQ/VOIAPUXuh2ILWFC7cyj9Tc5/2xcgqg5hm7BSYR4LBAHo0OHDM9AJvXQfNZCPBe8izAd/T7uQqFbCBzLhbhe5FsQ25W6vExw+VAWvpvk7ejslcjoO6K4pdA/IUAdiJCRqrBuANQ/mqAoBpb0IFEEoyjJ0dig0/XMvFl9aRaJGh6UNjlB+VUtto2eBnBOAH1hXl7cAC1vBDaVznhmpv2nGbC9WNg4wrqmbJGhQVRpECgyPN7kaqf3HZx9kMZra90TgM+rUCqtf+E2q9+QHUU58Ku1mRb4zo0GHvNpzaYqLo6noaucIuLyUHLeQcNoE8UpOLrsKTqTVAqyiK3Pdz3dJ8TYqJugYMrLnWABA8F2vfFu+PpEOpvg62kuBWAcHmkdcsrQpDhPz+qU4SwPhsDIjejCF2DEfULQD9fjKgKaHY2/i9GTWV3LVYnJ0bwucKeL3kYZL7/WUiThcBlh6EwhDXsBFTPQHpWqlNf4X44FWgmVxFXCgfiU6cMViz5V8mrEE6pURe8si/X8KBjBRABImd02wV/fW0vIdbo7Kf0cek3nc1gFcmcOXM/s0QyZTXZPQmSG4jwEmn2bUEsQqSO8MCNAeFFGQtvkHH0+uPUO5tpR8ah2fOWMW7+et0UlGKrR2VzEC1DAVucImPKRwFhPnJ7UlszenbAmbgY6GTvPWrk8Lss3BE5Nysq4VGx1eBHilDCbWBkD/LC3wT0d1wQEXFp86HDR5cAgivcM3GBh6lpIIVoakIrr5Lq88BI6uOLCHPHUNM4I7dloarXi4T6rKY/rECP+GTk1xhcqyrvp5JCGyz/vmpnwztdw4C6KPfeCwpp1IjT5e7szJMtNb3sz
 uGeZdrjn
 8WkpFI5Zg7az0+PMVxP9MhM6mtiLtui/cEGApXYd/bdWXg2xFhYcHtx43CGVzDdKSm0scW43HSg+F0mTJ7NWhZuahtuMXh0DelarxTn+tqU12+5PvgGqxS9ujvocNyOZvdoHTRdALG3R3ov2aeB38ORcsZkKS3yt9W45M0sgtmx+1bHx4rWif42aBJqNoIiNlvkTqkiSQbBDNmuSKJW1ROjFhzfWtPucOHrqg+Kyqi2oQgiZmnYpXBQLNy5nnL4YyKHsP0+0Tpyk+KpLKkHI1qvS8xpiJq6SOdJWizllGtJ4ENZo6W1B6zVLP07CroU09DIF/+ATE3xuxMTPFTv87Nih2XttiEhTxzryoLglk5+zqTaUbnhWg23TEVj+edMloWsQappd0AzOFBfnEmOS1dCgFg6GfIfBA7FwfOjY8p59ayLn6cXAfiOHscFKIIGBD0Mpf2HjyCzfK7JKlaPNmyrALDDkOSD3gxQx6GaoVhkiVnFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/21 16:30, Wandun Chen 写道:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Replace walk_system_ram_res() with for_each_mem_range(). A later patch
> introduces MEMBLOCK_NODUMP in memblock, the reserved-memory regions
> marked with MEMBLOCK_NODUMP can be excluded from the vmcore by walking
> memblock.
> 
> for_each_mem_range() iterates memblock.memory, which is freed after
> init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs ARCH_KEEP_MEMBLOCK
> to filter reserved memory from the vmcore, so extend its condition
> (ACPI || KEXEC) with CRASH_DUMP. arm64 and loongarch already select
> ARCH_KEEP_MEMBLOCK unconditionally.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  arch/riscv/Kconfig                     |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e7891a2a89da..e21d0bab77ee 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -58,7 +58,7 @@ config RISCV
>  	select ARCH_HAS_UBSAN
>  	select ARCH_HAS_VDSO_ARCH_DATA
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
> +	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC || CRASH_DUMP
>  	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if 64BIT && MMU
>  	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> index 26cd2a8bd0cd..808e872f4063 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -37,39 +37,32 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
> -{
> -	unsigned int *nr_ranges = arg;
> -
> -	(*nr_ranges)++;
> -	return 0;
> -}
> -
>  unsigned int arch_get_system_nr_ranges(void)
>  {
>  	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> +	u64 i;
> +	phys_addr_t start, end;

The kernel prefers the reverse Christmas tree layout for local variables.

>  
> -	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
> +	for_each_mem_range(i, &start, &end)
> +		nr_ranges++;
>  
>  	return nr_ranges;
>  }
>  
> -static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
> +int arch_crash_populate_cmem(struct crash_mem *cmem)
>  {
> -	struct crash_mem *cmem = arg;
> +	u64 i;
> +	phys_addr_t start, end;
>  
> -	cmem->ranges[cmem->nr_ranges].start = res->start;
> -	cmem->ranges[cmem->nr_ranges].end = res->end;
> -	cmem->nr_ranges++;
> +	for_each_mem_range(i, &start, &end) {
> +		cmem->ranges[cmem->nr_ranges].start = start;
> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +		cmem->nr_ranges++;
> +	}
>  
>  	return 0;
>  }
>  
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	return walk_system_ram_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
> -}
> -
>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>  				 unsigned long cmdline_len)
>  {

-- 
Best regards,
Jinjie


