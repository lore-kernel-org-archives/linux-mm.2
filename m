Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65628C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 06:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342A86B008A; Fri, 24 Jul 2026 02:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BAB6B008C; Fri, 24 Jul 2026 02:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230E26B0092; Fri, 24 Jul 2026 02:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7F976B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:07:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 719201C046D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:07:55 +0000 (UTC)
X-FDA: 85022639310.18.6B0D34C
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf07.hostedemail.com (Postfix) with ESMTP id C639940005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:07:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784873273;
	b=MWta7wv0o2B+IIuNtz3peBeZTh1UTXdS+j90GPWIzD74Zo1RKFfpwtu1WikE+UEjQL931N
	FwOnbeMANuSAFhU1SJQ6lnGMLumH7mx8TbTR82kCyBeGAlqAqgfQE5UUdvAuDdQwLWXvoh
	eTYV6G2He9c+xElbyfbJeKDqnX3rSXw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784873273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ClFEpUvHPe08zN0hpbpovG9qEE8USI0KPFPwubrb+s=;
	b=ChQD67VS6bQkdidzDxleInEYiuxs87DrXNgQFMEYwbkSujS5Ksobs9yDJDGldJLzNtXJ8V
	e7ST2WzRz0ySQ+Vp6yyAkDNUDIBzSrrc0KnmilTHBbmjv/2Vm4mvbPdAXinZS0Fa8f5zWI
	jyEL6wzE+XTgfyj+ZuSN/cKdOy9jQvs=
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8BxJOgwAWNq2tQGAA--.2201S3;
	Fri, 24 Jul 2026 14:07:44 +0800 (CST)
Received: from [10.130.40.83] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJCxPscpAWNqcyUXAA--.59809S2;
	Fri, 24 Jul 2026 14:07:38 +0800 (CST)
Subject: Re: [PATCH v2 2/2] LoongArch: Skip address pairing for non-exec
 sections
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
References: <20260721090606.8982-1-yangtiezhu@loongson.cn>
 <20260721090606.8982-3-yangtiezhu@loongson.cn>
Message-ID: <11c42b7c-7805-cce7-305d-6e52c14db20e@loongson.cn>
Date: Fri, 24 Jul 2026 14:07:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20260721090606.8982-3-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPscpAWNqcyUXAA--.59809S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGryfuw17Cr4DZry8tr4fWFX_yoWrCFy3pr
	sxCrs5uFWkGF1DJ3s5tw1kua4UWaykuF4aqF95tryxAFnxXF95t3ZxtrnxJayUuws5Aw40
	qryFgw4Fv3WUCabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25Ef
	UUUUU
X-Stat-Signature: ewacjky8a8sbu8xi39dsdkt1fof6b7pi
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C639940005
X-Rspam-User: 
X-HE-Tag: 1784873271-986900
X-HE-Meta: U2FsdGVkX18yAHy5UjflwJ+EBHCCTXJGieijZvlsQsfyQPi3Qb5dre3F1Re8G/PhX1/zwk1cb9WqfeI3LweVf+OmuMUa0hEv4urtBIDaKYH/I4aKQGdGeZ2z/lEKX/wqTDTi2RMyRHJagdpPqc6aX5JgGkliva0la0QoTx3qEN49eiEBG3sXBiPOSTjCiWzWeW9fZ700c1L073c+yvTacj5ABzABSnVv6LrPSb2oIdcqVkMd/lPPimXIujgV+p5MP8xE/NcyPPrIBvAZ6bthdO5FiQy5BpaYjWuCAweU+9XN834jNAUTHksneExOA195kdAus2TPSIWbK9fkPDliMRC1Ke3m/Jv6+V7eWAHhUBHul2Mp3zWOz5cGI7cyZM1uVG6vurfBagyDIpkjZdExF0MoYiscGjDPybdho61GxkqhjSJ/+mE6Oa2SzYGCB/YwA779bIyqF1BiYymEhwG7tdnfyKcFAv/xwB9kSevQoKzSs/+N21q4fejIlagcANQVgQ2V0jvgYv5gDes8y80qMLLqAR1pLhQw+loqucBwu/NHUtHZTJ2VOU5UgjVD80YoydiGVQPSaIC4dFLQUS/cxLNUUS+BXIlbo2osS2ZIRiE8Dd3LwVqgxzhxdiGg1yFsLt5Mp24Fx2uRv55TQ5JiQ6xVPdvqBeqyZsNLCoUIw+uMTxK72rfMzc5Wq4ofR22ND/QaESerdDZVoOK2SjHiBcbJ5KiEs09SspOgXWdzJyDgpTPpO+V+1L5G8kKnpGLXgpmZV6L41IA2WI05DtpCkdsY/ixP6uZAEGgQQTQUtDLabElglou1paeg13I3RIBUaNhzTAtDWOo6y6A+mgp/Qc2QhNFvJeNMsbKkYgwJgq3UaDihzL6CZ+0UCRoEpBrhnkQinSHaX1fdqsOl6PektnpdCiXDyGX/E/MHoaHYV0lzSR2cq82IbXhlEij+OGsN8puMzLF6F7k9orzyhYp
 dDf5LDYu
 jPkJ97Uhkckvy05+ZuiMm4narAM8x0ptf1EIIOU8VWpU30mlzp6M8L8b6+e7WExd8KVQlVCrKLybqDOiqdkbULNYUWjcZQy+I92hP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/21 下午5:06, Tiezhu Yang wrote:
> The module loader currently runs expensive address pairing logic for all
> sections blindly during relocation. For massive modules like amdgpu, this
> causes the loader to waste lots of CPU cycles analyzing non-exec sections.
> 
> Furthermore, there is an inconsistency since module_frob_arch_sections()
> already ignores non-exec sections during the counting phase.
> 
> Check the SHF_EXECINSTR flag in apply_relocate_add(). If the section is
> non-exec, skip address pairing and then jump to normal relocation. This
> eliminates redundant search loops to improve module loading efficiency.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   arch/loongarch/kernel/module.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
> index 7d4d571ee55e..c84ac1546dc6 100644
> --- a/arch/loongarch/kernel/module.c
> +++ b/arch/loongarch/kernel/module.c
> @@ -484,6 +484,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>   	Elf_Addr v;
>   	Elf_Sym *sym;
>   	Elf_Rela *rel = (void *) sechdrs[relsec].sh_addr;
> +	Elf_Shdr *dst_sec = sechdrs + sechdrs[relsec].sh_info;
>   
>   	pr_debug("%s: Applying relocate section %u to %u\n", __func__, relsec,
>   	       sechdrs[relsec].sh_info);
> @@ -522,6 +523,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>   
>   		v = sym->st_value + rel[i].r_addend;
>   
> +		/* Skip address pairing for non-exec sections */
> +		if (!(dst_sec->sh_flags & SHF_EXECINSTR))
> +			goto apply_normal;
> +
>   		if (type == R_LARCH_PCADD_LO12 || type == R_LARCH_GOT_PCADD_LO12) {
>   			bool found = false;
>   			unsigned int j = idx;
> @@ -562,6 +567,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>   			idx = j; /* Record the previous j-loop end index */
>   		}
>   
> +apply_normal:
>   		switch (type) {
>   		case R_LARCH_B26:
>   			err = apply_r_larch_b26(mod, sechdrs, location,
> 

According to the LoongArch ABI specification, the following relocation
types exist exclusively in executable code sections:

R_LARCH_PCADD_LO12
R_LARCH_GOT_PCADD_LO12
R_LARCH_B26
R_LARCH_GOT_PC_HI20...R_LARCH_GOT_PC_LO12
R_LARCH_GOT_PCADD_HI20...R_LARCH_GOT_PCADD_LO12
R_LARCH_SOP_PUSH_PLT_PCREL

https://github.com/loongson/la-abi-specs/blob/release/laelf.adoc

Thus, here is a better way:

```
diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index 7d4d571ee55e..b1452b8adc63 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -484,6 +484,8 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char 
*strtab,
         Elf_Addr v;
         Elf_Sym *sym;
         Elf_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+       Elf_Shdr *dst_sec = sechdrs + sechdrs[relsec].sh_info;
+       bool is_exec = !!(dst_sec->sh_flags & SHF_EXECINSTR);

         pr_debug("%s: Applying relocate section %u to %u\n", __func__, 
relsec,
                sechdrs[relsec].sh_info);
@@ -522,6 +524,14 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const 
char *strtab,

                 v = sym->st_value + rel[i].r_addend;

+               /* Skip relocation types that exist exclusively in 
executable sections */
+               if (!is_exec) {
+                       err = handler(mod, location, v, rela_stack, 
&rela_stack_top, type);
+                       if (err)
+                               return err;
+                       continue;
+               }
+
                 if (type == R_LARCH_PCADD_LO12 || type == 
R_LARCH_GOT_PCADD_LO12) {
                         bool found = false;
                         unsigned int j = idx;
```

For the non-exec sections such as .orc_unwind_ip:

fedora@linux:~/7.2-rc3.git$ objdump -h 
drivers/gpu/drm/amd/amdgpu/amdgpu.ko | grep -A 1 .orc_unwind_ip
  32 .orc_unwind_ip 000ac104  0000000000000000  0000000000000000 
18592470  2**0
                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA

there are 176193 relocation entries:

fedora@linux:~/7.2-rc3.git$ readelf -rW 
drivers/gpu/drm/amd/amdgpu/amdgpu.o | grep .rela.orc_unwind_ip
Relocation section '.rela.orc_unwind_ip' at offset 0x3a5321e8 contains 
176193 entries:

Using the section flag check reduces the operation to a single check for
massive data sections; otherwise, the loader would have to perform six
redundant type comparisons across the if-statement and switch-case for
every single relocation entry.

Thanks,
Tiezhu


