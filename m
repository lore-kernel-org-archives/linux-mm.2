Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA4BCC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980696B009F; Mon, 20 Jul 2026 03:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931806B00A1; Mon, 20 Jul 2026 03:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846EA6B00A2; Mon, 20 Jul 2026 03:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0946B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:16:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6E9340732
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:16:39 +0000 (UTC)
X-FDA: 85008297318.01.8364D44
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94CEA180007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:16:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531798;
	b=BFv8rGMHCSvSyqlPwQOP7quWu82m+4C3cmwiCe11rLUEpPV12SoJV6zM/6q49I5lXXomRA
	gvOrbNQLtiADsxyAcYXzP9UTdTShdqZ1DdL9q+CL+rAiOm4OSyF/z4pHAeYNWQ9UGj7n8S
	ZJPJjZvsR0Ehn36Cg9dYIqcf/5vLRbI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YC/10U6A/TJBZ1fmIDZOZazaOwF0hZylMcnM5HfXjjg=;
	b=y8XTdl4OjpTBnE7n/VWQ5tA0IbUKqt3038h2PLHEqlwDI2SycKUiyQfO41L8lpu+dk7m1y
	w4BS4FwPmwKpoTGyToqXL/LMruYvr608HJ4NC4TWjHf8jiSHwTRJIq2Z6TsRJ73q4mm9Nc
	0Iq+wN/d6qc+/2e8WFB6lHKHqHxoHjM=
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8AxuvBOy11q_y0FAA--.20516S3;
	Mon, 20 Jul 2026 15:16:30 +0800 (CST)
Received: from [10.130.40.83] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxEuRJy11qT50SAA--.31041S2;
	Mon, 20 Jul 2026 15:16:27 +0800 (CST)
Subject: Re: [PATCH v1 2/2] LoongArch: mm: Expand modules virtual address
 space to 2GB
To: Xi Ruoyao <xry111@xry111.site>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mm@kvack.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
 <20260717075715.25513-3-yangtiezhu@loongson.cn> <alySgaaQen6ZtwSo@kernel.org>
 <ba8b2723b563cd290c5c00fb4ec2402626fba06c.camel@xry111.site>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <8ea92daa-ab71-92fd-4449-af51b5557c22@loongson.cn>
Date: Mon, 20 Jul 2026 15:16:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ba8b2723b563cd290c5c00fb4ec2402626fba06c.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxEuRJy11qT50SAA--.31041S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAr1UKFW5JF4xXF43ury5KFX_yoWrJF18pF
	4fAws5Cr48JrnrJw40y3WkWayUu347uFW2qF98Jry29wn8ZFy5AFsxtry3XFy7ur1Fyw42
	gryvqw4jqa4DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-
	UUUUU
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94CEA180007
X-Stat-Signature: ygcm7agwmqhfri6ydecj6sdojgqak8j9
X-HE-Tag: 1784531796-492848
X-HE-Meta: U2FsdGVkX1+KdQ+j8nwZSyZce95tATXYZ1l5Z+2ARIm4K20wC/pDW5SqiIbQVgNPLXY5sorfuRcTYfihw9mIsa+mRL8uqEsnGN46tSLNKauWQN9MCC068pN1YKSAPc5uHhn+iX+P9rUtNTp3CQvwZWdh/Z1nokja4ZSmV6rHrfkPHZ7lx7SVLuM/1pD6UF/0ql09y9TnzKem84PYn4LC2bh/MaWKPN+KG3lJx4enxfupptgSCclCciyXDiv0N3dJv8j3y4oz52ud4pfNP+/sTIMkKIqyMcwl6VRfI3OwltyrPHjo/Zan1LiM6fo2+I0pkREB00JrLwkbqhRC3iWK9rhNV6S6UcJfb+Ekck8V6U6gswU7Jl+vwjCAGcA5DiI9w9HmG+LSThh6RKWP9DemKWJZO4LaOx+2KbpS+DdtMBrmFP950VNAPWsBkA0zG0IcK4YCwhWncD93axzUOeaSQRTn121JqM9xyoXjsYNbTToNv4vsyhJhLia1jmTXr3Hru6npKi3ybep73xPIf1tX5/bJWCOcWwxtZYO8U4c5qbQzGJftO0ekna6upkvUHnOrT6hYPpJa72DOl+9vmOmqQaGdNgcop8mAq9hSPYTBJt+QK96YOFdNIOxx9PQdRkwFMTZLnbqwfvqvb9uRNAhUMeuzn1YUl1tNJrcaFib+nGaK+oLewyRTi6+7n+l4RnT674e27rm9XdxjvV9H1DxtztG1jo7rCgqmWgummaQv6WEEqKrrv3FFU/2987QfCZF0Y+3TK42OTxhAp4q6IYbhSTf4/viE1lmXvn+UBPM2jDzvXvhzpnm6JolcSERJrIRadaLwJrepjkhQd1UzgkGCHlUbG4hXUeZcDLfV5Za1mEgT2GGArfGDbPARZMrM05AilQnqK1DVEIPv5DYT8yMOyx+BcYvYrgSVwASraUVKjWk3k3RiAWR1V37T5UxpppMllTSdb75d8CEK5Yw06I0
 7ZuhfPiU
 TybGy3L867KAXnjGw7VClPJBwUyhTbFp3CzE9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/19 下午11:28, Xi Ruoyao wrote:
> On Sun, 2026-07-19 at 12:01 +0300, Mike Rapoport wrote:
>> On Fri, Jul 17, 2026 at 03:57:15PM +0800, Tiezhu Yang wrote:
>>> Frequent "execmem: unable to allocate memory" warnings are observed
>>> during kernel module loading when updating the latest kernel.
>>>
>>> This is because the modules virtual address region on LoongArch is
>>> tightly constrained to 256MB, while ARM64 and RISC-V are natively
>>> configured with a spacious 2GB region.
>>
>> The constraint follows architecture ability to address kernel instructions
>> and data from modules code.
>>
>> I don't know what are loongarch requirements, but I remember that arm64
>> added a layer of relocation support to allow 2G module address space.
> 
> IIUC on LoongArch the size of one module is limited to 256MB, but the
> total size of modules can be up to 2GB, as the module loader creates PLT
> entries for calls across the module boundary.
> 
> I'd seen the "execmem: unable to allocate memory" error loading the
> large amdgpu module.  But after I stripped the amdgpu module those
> warnings gone away.  To me this is very strange: shouldn't the module
> loader just ignore the debug info even if it's not stripped instead of
> requesting execmem for it???

Yes, after "strip --strip-debug drivers/gpu/drm/amd/amdgpu/amdgpu.ko",
there are no "execmem: unable to allocate memory" warnings anymore.

But we usually need the debuginfo, here are the details:

$ readelf -S drivers/gpu/drm/amd/amdgpu/amdgpu.ko
There are 78 section headers, starting at offset 0x3acdf0a0:

Section Headers:
   [Nr] Name              Type             Address           Offset
        Size              EntSize          Flags  Link  Info  Align
   ...
   [23] .debug_info       PROGBITS         0000000000000000  00b73fa9
        000000000bfde1bc  0000000000000000           0     0     1
   [24] .rela.debug_info  RELA             0000000000000000  280f2e40
        0000000011f754a8  0000000000000018   I      75    23     8
   ...


$ objdump -h drivers/gpu/drm/amd/amdgpu/amdgpu.ko

drivers/gpu/drm/amd/amdgpu/amdgpu.ko:     file format elf64-loongarch

Sections:
Idx Name          Size      VMA               LMA               File off 
  Algn
  ...
  14 .debug_info   0bfde1bc  0000000000000000  0000000000000000 
00b73fa9  2**0
                   CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  ...

The size of .debug_info is 0x0bfde1bc (191.87 MB),
the flag of .debug_info is not SHF_EXECINSTR or SHF_ALLOC.
The size of .rela.debug_info is 0x11f754a8 (287.46 MB),
the flag of .rela.debug_info is I (SHF_INFO_LINK).

Furthermore, I think the following changes are also necessary:

```
diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index 7d4d571ee55e..5a4cbd27f97d 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -484,6 +484,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char 
*strtab,
         Elf_Addr v;
         Elf_Sym *sym;
         Elf_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+       Elf_Shdr *dst_sec = sechdrs + sechdrs[relsec].sh_info;

         pr_debug("%s: Applying relocate section %u to %u\n", __func__, 
relsec,
                sechdrs[relsec].sh_info);
@@ -522,6 +523,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const 
char *strtab,

                 v = sym->st_value + rel[i].r_addend;

+               /* Skip advanced address pairing for non-exec sections */
+               if (!(dst_sec->sh_flags & SHF_EXECINSTR))
+                       goto apply_normal;
+
                 if (type == R_LARCH_PCADD_LO12 || type == 
R_LARCH_GOT_PCADD_LO12) {
                         bool found = false;
                         unsigned int j = idx;
@@ -562,6 +567,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char 
*strtab,
                         idx = j; /* Record the previous j-loop end index */
                 }

+apply_normal:
                 switch (type) {
                 case R_LARCH_B26:
                         err = apply_r_larch_b26(mod, sechdrs, location,
```

Thanks,
Tiezhu


