Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BECE5104892C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 02:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F526B0005; Fri, 27 Feb 2026 21:41:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907D66B0088; Fri, 27 Feb 2026 21:41:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5206B0089; Fri, 27 Feb 2026 21:41:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0606B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:41:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F84C1A0297
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:41:14 +0000 (UTC)
X-FDA: 84492313668.06.98922B4
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 36AA41C0008
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:41:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZBtkavJe;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772246472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+42melSSCeyVi5c0QcjrNxM/6c8TQZ/GmkZEvra0bKY=;
	b=pklQ/bBGwWnsKAMTnnyLboh29TfIAX/z8mF0NCvNr+A7FhdzqrhkA5A1OeLY919cI8NO5V
	3NGZi700TXlPu9xBAKSo+wiJGvKB/KBwWJMlFjqBpe23wR7JNYwr604Et/l8bxmA4cWj5U
	ylGBdMgMXBjd8Tu7ouZ9rbpnMa2t3fk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZBtkavJe;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772246472; a=rsa-sha256;
	cv=none;
	b=aFD6M54hRN6zWPZcjti5bdEU11o9KlXNI0rAhoeoge8WEygAYJHv1WAc8ieSMzxFWqvgTi
	2N/Cz9ryUhhm1nLl7xlshT23a0zo8UaoX80/4cnin+b7YdllZr/gI+v1nSYwiko0hFm600
	jEobw1H+QjEDIlZb6U2Rzp3bJ+1lxOo=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c70ea5e9e9dso1042276a12.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772246470; x=1772851270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+42melSSCeyVi5c0QcjrNxM/6c8TQZ/GmkZEvra0bKY=;
        b=ZBtkavJeafpi6jaCyfLIVA5EeJxyZ5Hf7MTtdtOtjcnDfENx5OXRbOD3rTJhb1ONSq
         b8IU0b08ZmaxnYOtWjhC5EwgPqWj+DQvSFb+e3fOD4/WPSXpkNByUyNm0gr085PS2XAx
         uCnOS/jfmzn0jEOxjzw94oGifY0Y0z/JUxAKlwUbdyfJI0Z8K2nICEPee98AszBMQNkz
         sbOAMdGzbJlor+rqPbmywvZ89SbuLv575GrobMNmeMWWYbkHEhyqgVlY6Syb+hWEfGAq
         t5LtE0+6FSZ0EHNu2VVgzE5hKjCPWoZyjsHOnKA96Mk1lpGB2Ro9vYMqVHYDRDEJCV0r
         nHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772246470; x=1772851270;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+42melSSCeyVi5c0QcjrNxM/6c8TQZ/GmkZEvra0bKY=;
        b=UXgY6AfgKO/tDUyFc7DsYPUkk6DWmRuyeDE2iG6bucacLQ4CobiM0//zSKSvNWsRsw
         M1dGY8HImv/0FjKl+zFXogIybVyPKJog85Rb6WGUHu19ie0YpXwkZVYm9UdTKkmJJeBo
         DgWmcWdpirJt+Vom0o0cDvAEJfoiWY8CQiqCitgGv7kZob8xsgF+GEcXZ7Mg0adKchrd
         Ij5w7JuDWdCYay4WW8f5Y0ohkJUUkFEb4II/5HkruvTT14lPa/8wZjPwF5K4+ZKcBvX+
         hmks+p0uHkOcKbTx6fQhf1DivcxpHHTm+CVJNEyL+bFk2aT8ch6YTJIdGUBYmxxuS1dj
         OjOA==
X-Forwarded-Encrypted: i=1; AJvYcCUDUxu+lc+t8Pa/Z2uXVCGq1y7akxyuyQo1nkgJyPZIPrXox/b0n+MHQz3UeRnqjx490/z6dkjVEg==@kvack.org
X-Gm-Message-State: AOJu0YxDhZ+bBE9Am4GKg0ILIHJlCMzEhFN2BXtKGS3rPBiVs6hjvEvd
	cyUX+++weiDjgRnwg2IC2ydt1tjYA/3GZP6gakk0+EB+WGDnzrzUTW9aSTknPA==
X-Gm-Gg: ATEYQzzkvs68kokETL2NUO/oEPe8xmQqRvDotmWX33jtkw5MgNWaYelGaESyGtMCcvk
	OIhkGYzaRqJocWodlwm1QQHwdWoIeuE/vkKYvr+txppTyJLjdB82yk8Ua+mOfT8lnm3m62ss0Xk
	l7Nv5GCG1dqNdmlIsFQN+Kom5icAbc3ksAvF9OeWgtOpVmqy5hgX5tvD81DsCb0LH3laDXDv6Zd
	1iXUtdW3B1RA+aSPAc0MUk1Rpg9EW/213RKdKJsH1HFMe1EnNR6SeLcBov1BqCph4wG5nSXJ61a
	+AgWQZwyUtML8RXpknRrmygrMGMSIxWDe6BjMKIpOt2l13mXG6u0kpMukoSgBI/MOvKUXJz1JfS
	gXzv1D1aO26JP0FzyGlm64AOLfhxmd3hiLsoojEmG8OFKXVl+0HEj4rirUZ3Zu0DqXiChEOhO8g
	YV11ns6Zy0B15EyHarQQ==
X-Received: by 2002:a17:903:1212:b0:2ab:3ac6:8d01 with SMTP id d9443c01a7336-2ae2e496d6amr62031895ad.29.1772246470373;
        Fri, 27 Feb 2026 18:41:10 -0800 (PST)
Received: from dw-tp ([203.81.240.187])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5dbad2sm69336145ad.34.2026.02.27.18.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 18:41:09 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Mike Rapoport <rppt@kernel.org>, Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Donet Tom <donettom@linux.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, linux-mm@kvack.org
Subject: Re: powerpc/fadump: CMA init is failing
In-Reply-To: <aaIDkB2xLABDyV1y@kernel.org>
Date: Sat, 28 Feb 2026 08:05:26 +0530
Message-ID: <87ms0th9xt.ritesh.list@gmail.com>
References: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com> <87o6lagljy.ritesh.list@gmail.com> <aaIDkB2xLABDyV1y@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36AA41C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: fezbw56ssddyzwcfqt1f96iaagaipo4d
X-Rspam-User: 
X-HE-Tag: 1772246472-201738
X-HE-Meta: U2FsdGVkX1+RIH2BQJL3IxGngmlaL5DmuuaKPr9Bs1oOCYOqAFssaUtQ3uiXyWNWqZSppo1Nsae7Z4MtVCgwTUDI114HKfCTKvm/LKwXGfClvlXi8KbhXFq6xLeZmYBmaMHLFqwAO1e6xM3u7EOKwMNxbAvTKVv8EsdZg/8QT+d/vk91sLtGRXQaN0jFaevyvT3YUx/IVegGsdfjEkJfqXMLNSFimUjQhQ/GjCxMmRNKzPx65jMmm9TpUDrxT+VK7EoI8fiRJWbjtFWJT60zfL05luWTwEzo+AKQusw0HKPaKAWVle7e/V+CyYRY/2ztuyZamVkxaHAcfMZb9R0CKjZnFkVYlHtNsv2dNG9CJ9ALK5h/gamkau2r3bXakE1yHz0RQ4LKaDghZNsEYOD77INygaILmNtnQiAL+ohtMBgdoGpYM26idcr9390mXfgT4AMltHBG49vk3dbM/LsHaoE6EDcTfOpETiabprVLI2NxU8kvUnJUA0ulfiJCd/b+w0U/jjPe5yVHOVhrLA5hkRgonchkqgaTkAyIREr4aywp/DuS34S+6+OV1wvjQWRKRN8D9OnwY8AcAe2iN3qVwYkuqQKoau7eTOkSm0mxrbOhFgMnt8gRSVY32DCPOTj1VgstdvxV4yl/OZCGaTEpljNy6RxR9nk94ZHAheTQ+DJ4Kq5/FshiYuCbWcHw2kEh4IXO4OGXZ6cTtXV/AYAX957f55HuEivnQ+O7WZN3vIRY6mrcoyKckihk1KErNpNmUmf1/ktFHl8ceME/uZ55dDDRIKm0v7DI+FWX/OrdDBcjCrEzoIBQ7TSrA5Yje8pSuJBnLlmPvOjLkn4YutFWCW7nMmMwFc8moHLB5yFuewzKYZ2cv9pxelcqsDu4s4VqukklZ+QUoX2qfpXm8T5bnQUykoTHJ9kLfBRJ+Y0nXLNVDoEvWYMmDFNf5nc1u9/nsD6RjOlCoLuJj2/ceL/
 sqvpbtTO
 +aYUoPKwrmQC4J4YJ8yZtaPIaijokrnDEXcOQxij3vWHqVV2NB2Kj/mqB0CkCDplVp0bSd1/zkcOeGleHMZLbkDLdBdy0S/96Gy2PAFSZzVMObN3sTlgB8OGivrL4Aiv/p7Hq5ONtCtT86JFiE8boqViswYsSS0bxRBcC9JWPPLaepBMuPkNRLQl8VaNqzufDlJeVbpSkHq2DxP4+W/2p0pqNv5Uai6Kj4Q1R577eTidBwJmGMncpQYcW9ULflJlOHan+qmISxc+Ua7B+85M2+hjNbQoyZPYjE3AUVUe88XTuneZJZZGr5saXBSvMfTVlFlapOVIsUFPBc/Cc7xzsVOGxzDzvhpgjQ39ET6ap87zX/lsyXU5sjK/RlvTQ5qhujqkAkGk9FFyEI6fRHqEFjdan36ZNsSnVUOfIcwMk3F2jmDhqq0Ow7BaBIXVTGbK+rDJeRIQLpiBLGl754JZ5fzYQdJ1ZW57kSVEHCIuZ3kS2BBXYflEEPc3NQd+72S+6xynz2tcG3ZoTZjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> Hi Ritesh,
>
> On Fri, Feb 27, 2026 at 10:39:53PM +0530, Ritesh Harjani wrote:
>> Sourabh Jain <sourabhjain@linux.ibm.com> writes:
>> 
>> > I noticed CMA init for fadump crashkernel memory is failing.
>> >
>> > [    0.000000] cma: pageblock_order not yet initialized. Called during 
>> > early boot?
>> > [    0.000000] fadump: Failed to init cma area for firmware-assisted 
>> > dump,-22
>> >
>> >
>> > kernel command-line:
>> > BOOT_IMAGE=(ieee1275//vdevice/v-scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc1+ 
>> > root=/dev/mapper/rhel_ltcden3--lp12-root ro 
>> > rd.lvm.lv=rhel_ltcden3-lp12/root rd.lvm.lv=rhel_ltcden3-lp12/swap 
>> > fadump=on crashkernel=3G
>> >
>> >
>> > Same issue with kdump CMA reservation:
>> >
>> > [    0.000000][    T0] cma: pageblock_order not yet initialized. Called 
>> > during early boot?
>> 
>> Good that we added those debug prints ;)
>> 
>> I think I know what went wrong, as part of this arch,mm consolidation
>> patch series [1], I think the order of initialization is changed.
>> 
>> With this patch the new order is ... 
>> start_kernel()
>>     - setup_arch()
>>        - xxx_cma_reserve();
>>     - mm_core_init_early()
>>        - free_area_init()
>>           - sparse_init()
>>              - set_pageblock_order() // this sets the pageblock_order.
>> 
>> Whereas earlier set_pageblock_order() was called from initmem_init(),
>> just before cma reservations were being made. 
>> 
>> start_kernel()
>>     - setup_arch()
>>        - initmem_init()
>>          - sparse_init()
>>            - set_pageblock_order();  // this sets the pageblock_order
>>        - xxx_cma_reserve();
>> 
>> So that means, pageblock_order is not initialized before these cma
>> reservation function calls, hence we are seeing these failures.
>> 
>> setup_arch() {
>>     ...
>> 
>> 	/*
>> 	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
>> 	 * hugetlb. These must be called after initmem_init(), so that
>> 	 * pageblock_order is initialised.
>> 	 */
>> 	fadump_cma_init();
>> 	kdump_cma_reserve();
>> 	kvm_cma_reserve();
>> 
>>     ...
>> }
>> 
>> 
>> So what if we do.. 
>> 
>> start_kernel() {
>>   ...
>> 	setup_arch(&command_line);
>> 	mm_core_init_early();
>>     setup_arch_post_mm_core_init(); // and here we call CMA reservation functions ?
>  
> Unless I'm missing something these cma reservations can be moved to
> arch_mm_preinit().
> It runs after mm_core_init_early() and before memblock moves the free
> memory to the buddy.
>

Right. I think, we should be able to use that...

@Sourabh, 

I don't have access to the systems (travelling back...). Could you
please give this a try?


diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index cb5b73adc250..b1761909c23f 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -35,7 +35,6 @@
 #include <linux/of_irq.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
-#include <asm/kexec.h>
 #include <asm/io.h>
 #include <asm/paca.h>
 #include <asm/processor.h>
@@ -995,15 +994,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init();
 
-	/*
-	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
-	 * hugetlb. These must be called after initmem_init(), so that
-	 * pageblock_order is initialised.
-	 */
-	fadump_cma_init();
-	kdump_cma_reserve();
-	kvm_cma_reserve();
-
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 
 	if (ppc_md.setup_arch)
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 29bf347f6012..5ba947e4fe37 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -30,6 +30,10 @@
 #include <asm/setup.h>
 #include <asm/fixmap.h>
 
+#include <asm/fadump.h>
+#include <asm/kexec.h>
+#include <asm/kvm_ppc.h>
+
 #include <mm/mmu_decl.h>
 
 unsigned long long memory_limit __initdata;
@@ -268,6 +272,16 @@ void __init paging_init(void)
 
 void __init arch_mm_preinit(void)
 {
+
+	/*
+	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
+	 * and hugetlb. These must be called after pageblock_order is
+	 * initialised.
+	 */
+	fadump_cma_init();
+	kdump_cma_reserve();
+	kvm_cma_reserve();
+
 	/*
 	 * book3s is limited to 16 page sizes due to encoding this in
 	 * a 4-bit field for slices.


-ritesh

>> References:
>> [1]: https://lore.kernel.org/linuxppc-dev/20260111082105.290734-1-rppt@kernel.org/T/#m5adf1a845e0a0867066c4f7055f28e6304b73fa5
>> [2]: https://lore.kernel.org/all/3ae208e48c0d9cefe53d2dc4f593388067405b7d.1729146153.git.ritesh.list@gmail.com/
>> 
>> 
>> -ritesh
>
> -- 
> Sincerely yours,
> Mike.

