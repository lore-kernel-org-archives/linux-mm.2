Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0C2C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 10:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0C66B00B2; Mon, 20 Jul 2026 06:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B7C6B00B3; Mon, 20 Jul 2026 06:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021AD6B00B5; Mon, 20 Jul 2026 06:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4B986B00B2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:40:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27E91160126
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:56 +0000 (UTC)
X-FDA: 85008812112.30.34BE3F0
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf20.hostedemail.com (Postfix) with ESMTP id 089851C0009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784544054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi+oThIPyj0GGf716zGSNcuyT2gLMs1+8N5W0FMo5ao=;
	b=0JdU3amDnyNnKE1P1YkyEs7ALlaxb4vj6QsVy+p3tglahosBjg+STLcefdJG0kdcvcZCjV
	8xhiet7TMx3EyxRY8idv0T6esyCh8EBuA/yVZN/nJiPskIFoH5lTWGN0Ond+YMUh4BpwnV
	qXuKDgdsZJe5zD7AuWZjWEwD+xOsHmc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784544054;
	b=2+n6xC3MHCqcft1G2kju67utNJG6QFgPBhfcdci2p8y+LAOVw5vGK989ymCtnsZIYhPijB
	YthZcqNa60H+5jXy+bMgXvtgjU1J4IHGi6EvH+RA6mxAIYtf50CHUURxebEnuI9WPZbwoO
	lBESjAI71rqlWUAgwlTHdhhVPaJfeVA=
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8CxKOst+11qEj8FAA--.20965S3;
	Mon, 20 Jul 2026 18:40:46 +0800 (CST)
Received: from [10.130.40.83] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJAxTOUr+11qZNMSAA--.34772S2;
	Mon, 20 Jul 2026 18:40:45 +0800 (CST)
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
Message-ID: <38d130e6-7036-e296-e058-433c8ba7a265@loongson.cn>
Date: Mon, 20 Jul 2026 18:40:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ba8b2723b563cd290c5c00fb4ec2402626fba06c.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxTOUr+11qZNMSAA--.34772S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAr1UKFW5JF4xXF43ury5KFX_yoWrXF18pF
	45Ga1rCr4kJFn8Ca1xAw1UuFyY93y5CFW5trZxury2vr15Zry09FsrKw15ZFy7Cr1Fyr1U
	KFykXa1UtFyDAabCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jb
	_-PUUUUU=
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 089851C0009
X-Stat-Signature: n4x4cqjoky4cn5uu81t9ozsjnfbakykf
X-HE-Tag: 1784544052-300752
X-HE-Meta: U2FsdGVkX1/32XobRxOIZ0Yff9q1NHUA1ruwXYoeYadLEal96mvV1dejd5i6Yj1gNqSvOj8l5HG+wqs1xD77jpr9itCAzebjEZQYlrwi/Gnnobzh1QXk/MhBEEY0Q671rmRO5qPvlJqsZ1Vy7jjVTCaP7ER5Qi4EMZgko8U9MQFsA9o9onRF193+/8KHx3a5k90Tu4LukCu/nx+thovQhoAlfWlw+Ku24oGb+I3uHkhPdO/M6xm3wenRuzyf+/xmKH57PoOo1/031IXopV2xYJ725ygVtk+yY3Hbm8OFAVZFHIPTUwAEgHQ/HKEkhe5cZuIgZFNfbmy87H/MYjOEyqFwEt/7HnoFlWi4Z7qtoaAjLEZop5JGdZVb2NR345Q72uqNx2ALfbDF5SVAHuH6SQ4gTr509Dc/dUspFgLRZvkDnKcyeLfRmK9R9Cca+C1xNmd1Hevbe7afQrFFxJqGyehAjVeVEKzRZkZPM4D21p+7yp4D0pl7YO8SJ+7JlgnMdjo/wKw4t9Oe+Jbkw+V+Gq4M3u4vmj1Np+fBBe6B2UUCaLjbWWrUZpFKuCYFfD0vJFMukvRjgWHY5mNIRc9JGGJ3SIj6q5I+LmxZhG6oJGsNeWKnSwTOkOkXnNleLeXAJhqHYNlxupRTJ3c61jBRADHRlxVCExImPAlL/DcfU96VPeUz0K/KcqKnYUvq/WEJxmoALZE9moEcuzRz/WQN4v6P7h5egbOtJDT9oWod4ZFPRW7RUtjwrPNjiAIJzfr0wSy7Y+1GMw0RGmHOjjNHIrHViTq97WTvFhLVl4Fj772QAhTgYFbSHwgbsKqwFqV6Qxs07Aj6eplqtaKopMsjeP4Yub/0gH0bJx6EGOIYWvRghsb/eYdu74T+BfF3qGBWTa0lGWTGqSEGfaEICLOpipyCl1NCVNBtt4sARXmcOlNHunWJDnYJBrvrVL0wbmq/uX3NFna5GAOJt9g5hif
 v4XEtU/p
 1VMrfTHYC99plzqdpkZWB7KgZ/b79IsHXWpZk
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

I did the following changes based on the original 7.2-rc4 for debugging:

```
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 46dd8d25a605..5eab1ab8b195 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2972,7 +2972,6 @@ static struct module *layout_and_allocate(struct 
load_info *info, int flags)
          * special cases for the architectures.
          */
         layout_sections(info->mod, info);
-       layout_symtab(info->mod, info);

         /* Allocate and move to the final place */
         err = move_module(info->mod, info);
@@ -3013,9 +3012,6 @@ static int post_relocation(struct module *mod, 
const struct load_info *info)
         percpu_modcopy(mod, (void 
*)info->sechdrs[info->index.pcpu].sh_addr,
                        info->sechdrs[info->index.pcpu].sh_size);

-       /* Setup kallsyms-specific fields. */
-       add_kallsyms(mod, info);
-
         /* Arch-specific module finalizing. */
         return module_finalize(info->hdr, info->sechdrs, mod);
  }
```

With this diff, the "execmem: unable to allocate memory" warnings disappear
completely:

fedora@linux:~/7.2-rc4.git$ dmesg -t | grep "execmem:"
fedora@linux:~/7.2-rc4.git$ readelf -S 
drivers/gpu/drm/amd/amdgpu/amdgpu.ko | grep -A 1 -E "debug_info|symtab"
   [23] .debug_info       PROGBITS         0000000000000000  00b73fa9
        000000000bfde1bc  0000000000000000           0     0     1
   [24] .rela.debug_info  RELA             0000000000000000  280f2e40
        0000000011f754a8  0000000000000018   I      75    23     8
--
   [75] .symtab           SYMTAB           0000000000000000  18934e78
        000000000f1a0dd8  0000000000000018          76   10548226     8

This test proves that the "execmem: unable to allocate memory" warning is
entirely triggered by the massive unstripped .symtab section (~241.63 MB)
rather than the debug sections themselves.

As the readelf data shows, the ~500MB debug sections remain fully present
in the static file, yet the memory allocation succeeds without any errors.

This confirms that the generic loader successfully ignores non-SHF_ALLOC
sections during layout_sections().

However, layout_symtab() must put the massive .symtab into memory to
support kallsyms and oops backtraces. Combined with the driver core code,
the total memory request reaches ~252.86 MB. This immediately triggers
allocation failures because 252.86 MB is too close to the narrow 256MB
limit on LoongArch, especially when virtual memory fragmentation exists.

We cannot strip modules or remove layout_symtab() because we need
backtrace symbols for debugging. Therefore, the ~252MB memory demand is
a hard requirement, and expanding MODULES_END to 2GB is necessary for
large modern drivers on LoongArch.

Thanks,
Tiezhu


