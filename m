Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF10FD7F91
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1675B6B0005; Fri, 27 Feb 2026 05:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115F66B0088; Fri, 27 Feb 2026 05:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021606B0089; Fri, 27 Feb 2026 05:32:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E23966B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:32:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 216A059431
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:32:16 +0000 (UTC)
X-FDA: 84489871872.30.B3273B1
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D4D340004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:32:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+1pwwFR;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772188334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LT1HXP6ImCtKkrDGFwhhoLVXorV0oXPyJhBSmf51vOA=;
	b=68Ow/F2u0IIg1omcacCsA3FoKfQHsSKg4i6x6Dl81haLj2YAJZOTR67Ie7s6CFynxlzn3h
	sixlqz0En4GtYkvvIw8fveWMTyfC440GaIuYej6yEoyHOIjfA3+zC78z5h0NR9vU3GSofx
	O+BgDY6HgfNl1w+BMlkXkFMkN2VyHIs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+1pwwFR;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772188334; a=rsa-sha256;
	cv=none;
	b=BNm8gzYzz2LQ6ChD71NPDwHWT/XVEYZ4mGYOu/wknxXsmXo76DNIzdj0at0+j9qiTorEVw
	EI9/OxaI7tbCNFUx+n48AY0dvA5oYhGpip0z9QTXliHj21h56GvqsMWq/iYivoqq34NNXS
	kJIsJvnuwjzzZa/px01/ZFoMuZw6wlA=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c6dd5b01e14so661340a12.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772188333; x=1772793133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LT1HXP6ImCtKkrDGFwhhoLVXorV0oXPyJhBSmf51vOA=;
        b=O+1pwwFRliklUv6uuwjgxOI7cLV/u9Pd/pHl1uA8ebiw0+5uKUuJyGgiz6WuDLC9nP
         TpQ2AwEJ32L+HlOtBPTmqSOB7q9bNvy3W1XXM5ThOD6D8Rb0Wux6ReH2I2ZEvLGzaa7R
         aF5eYWOFZkrGc5cNIxYgjYKaPVAB6IRLXkm1ESCV4fIn+dOXFdDaOio4b7JrNcmsEqki
         /gEnOO5kMfu9ZP48PxFPHjE4BNot27wBbsLy7eUxhEzFhsViQpj5RP95qf6k8moqcfPL
         +pS0lnGuPC43kYCAr+zJyos9AgFprKHwzcnM30HSkJUEIIaE3Omr8ccwR+R9h8LdbvAx
         8Q/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772188333; x=1772793133;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LT1HXP6ImCtKkrDGFwhhoLVXorV0oXPyJhBSmf51vOA=;
        b=rDcVz48TqS7RQXg5aiB1iBC04FQ71/LISxxRhF/MFcGgYEYAY8UMX7NF8EOeSHCfbC
         lKY7MBsEtnmhJWio9p2kOvU8xL4oMnpjq9HzvFPn2UAK8CQZiVu4UtBPoxMcBtj98Ew7
         sOot19txAKcP/NsmQpsFH14tKxOMXOnFyWJkPzoAGr3c3/z/cLtyavN6v5hZwL4aEUcj
         GZIhrS2S6okZA/iF6bAvhv/bcrvhgX55Ldua3xlJVxrtBxmOnV6d0vWa9xOxWKkNY50V
         6zrMhXSZ6P7j7wLOEJFsZLVL29ssveHmlUWORz7kvsCn5SLdISP4zz9KlUWCeaBNaVk8
         LJwQ==
X-Gm-Message-State: AOJu0Yw9xJGIK+SeSTVwf1rE3ff9Nyrl+ONjMN3NQcwzoAM60A3ahNvP
	CoDo53WuUYKNkRCQIXHmZyZg7saUDCKSc4720J4OysvuNgBaf1KpTPrT
X-Gm-Gg: ATEYQzxtQkH/iRKKHWdQtUgpfsVTqjPT45C77sQ8+xQn6G4baoAeEUD4YLdi60bQ64q
	Q4hyCPU5xxPzE9mywNWDY6GTgT6PwtKlgvColQp3kY5R69jWUlzXe+wLOLqCbhSu7bMnW9JOHqs
	KTvc3gC3BTyT+FWYCETyTrqglf/t8hgXdFv93wBfvyjskwLcQe3NhabYFx7B6q9l6EY8EhI0807
	sglUaznTWGk3LW3D74vN8sUnqXokYbKA113dy/0Fe8rjLA9Dc0C9rLbx4KALTwJlXYO6aIfgfAq
	QdrSShd+DOLL3MX32Rxok+yHY3mPbclvxcjdYJ6mEYrNTsrIWvDoPSavXruVDkxM7PkwAPiEwfX
	lJkrCdmAVvYWb95f18PM2pkIekDkQ8OT+trUELS4MUendPU9uyBfoJSJKvLnh7lBtuERv9LAKx/
	6SM3JEcp9K1Kh57tZf1Q==
X-Received: by 2002:a17:90b:2884:b0:356:4ea0:e9e2 with SMTP id 98e67ed59e1d1-35965d074afmr2219544a91.34.1772188332691;
        Fri, 27 Feb 2026 02:32:12 -0800 (PST)
Received: from dw-tp ([203.81.240.187])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359134a0a2asm3170713a91.14.2026.02.27.02.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 02:32:11 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
In-Reply-To: <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
Date: Fri, 27 Feb 2026 16:00:54 +0530
Message-ID: <87qzq6h40x.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9jdgkpqbsmntytqkbcqxud4o6b9hzrse
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D4D340004
X-Rspamd-Server: rspam04
X-HE-Tag: 1772188333-802539
X-HE-Meta: U2FsdGVkX1+1wukRroiaP0AiyLSGyAoVeWakEQy4D5qCjcIXbBWuiw2XJkO6tRWKoLjjw+4nWR/20k+bovNxWQJg5br1Hp1dDFgEE4+lDG8QFAnPINz1Rjki40PzZhaIDLKsa8OZbUPu1sbIe6dma/msegc8yFnimjZPllC7TVgHoL2JdhhLitTEnq6NlkRlaU7dTR4CRDqv6ySbUrxSh5uM4g/pZ/0ewYVV5P4UcvYKeC/g9A/ozzoJMt3KejC0850U5HJSa+xa1JMLrU0/297Rw6x7kZFbYcNjh3OmbKARf+AAAQYgI6laHH7lyfd4+/R4ad/8fuavk9iVR2fbA06PaoX789ZmiQn++IvZmV/cWwro5c409XqpEEfrxKWOh6MWyo2fo/f3UYFgpZ+fGW/boADlP1Jl5OplKtQcVWWuAW17XeM+iZF5Tl40tcPx2khrV29GhZMVr2GJM3aba8Q0/NVuK4HRH0Uwt0IfHh8DrrbnvbyoGuMvKViKn5w7mPDkuupA71+y6HBfP7gD5GV6dXcmEC0mtz+ExxBWQz0y7XZps9v2/JUGdZUmuhlYYPUhUKvGLpkf0vSYOl5UOglIO09mf/4XbI/Ecx0LsEqtJ/jxQ+XiEUnNPldj+e1J8UcY5yp+bvOqOe5pF0hmTa5ZE9GHfgNymmg4lEG2BGxiKWMXAWxU5hCujvsQJwjXsTp9iqhPbEyk2irq/gJR+KoV51ymvgaKb9mIhqNfyfvAYZM99kMIdG3CmnpJQYOdz4GgHr1GOWMeoj03GB3XpkZi9sTi5oWsS+lMSTTqVDP5E6cOyntF7CGzQJQYpxNt7yIAwvYaXLOSfK143sWuN20Yr5Rsn8v4LoU7jBHq9hoOm+rDhSi6Ez7T5DP/kMHYQtBlz+7TmhJxhHqvBmbToqxhRfTeumt45uhJoOuEcYJqZrIs3tE3kaS/ZGEhWhAzG2lVMvCj6DQrrs7VA7j
 FbrUY8bl
 CiZaA5j2M1ZIAhDbERPZFigtFBix0noKooIEZxiT1rqOj8yYC16dtB4nmC3obCWW1kmLT5gtDSWbRL5in3Y9i9U845D9Ud4gIXi+XKjmwCGx6s4Ydk/1d3BGp3OzfBcKX2qYZ+wL3NqFgk8SDKtGsNTCxy2a8C3appyzBsAmhXAdAuxbaGUU6aDhXLRuwZk8TR9JOI8G85snWw32u7yG7xBQxWA0GiQVlXB/L0csTLvklRPiAqoBO5b/P/A8Y6ErY2DIn5OJ9KeQSQb3JuYV/67ehpvlWYO4YTjGm2NQCZFcpEO8OI2m5iQH19ZR4Vz2UrKkWHwotM2Q6flhX7yxdoTrDnsjRmYo/5H1G77WqgQcPuKfSiBYKGFo5sLPkdvlPV9bXcqLDkIX6H7VuQFXf55SHZIS6KyKSlgnk4oFmSUOTRAZDQ4o72oYHs5F1e5LP4q88at6nwJCPn5LJoiLt2vI/ra7K9Iremqb+mNM4BOfSlyIZz2aQQhD827VCl5IaRLI4CEk/UfXx/MrS12n6oRJokopMkBVMRvnAIFLawQKalprFHrp43nMwcP6Lmq5XNm3dTR5ig6S7Olc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>> Architectures like PowerPC uses runtime defined values for
>> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
>> at runtime using kernel cmdline. So the pXd_index_size is not known at
>> compile time. Without this fix, when we add huge pfn support on powerpc
>> in the next patch, vfio_pci_core driver compilation can fail with the
>> following errors.
>> 
>>    CC [M]  drivers/vfio/vfio_main.o
>>    CC [M]  drivers/vfio/group.o
>>    CC [M]  drivers/vfio/container.o
>>    CC [M]  drivers/vfio/virqfd.o
>>    CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_core.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_config.o
>>    CC [M]  drivers/vfio/pci/vfio_pci.o
>>    AR      kernel/built-in.a
>> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
>> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>>   1678 |         case PMD_ORDER:
>>        |         ^~~~
>> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>>   1682 |         case PUD_ORDER:
>>        |         ^~~~
>> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
>> make[6]: *** Waiting for unfinished jobs....
>> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
>> make[5]: *** Waiting for unfinished jobs....
>> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
>> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
>> 
>> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
>>   1 file changed, 7 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index d43745fe4c84..5395a6f30904 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>>   		return VM_FAULT_SIGBUS;
>> 
>> -	switch (order) {
>> -	case 0:
>> +	if (order == 0) {
>>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>> +	}
>
> Those braces are unneeded as all legs of the if/else are single lines
>
>>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>
> ifdef could be replaced by IS_ENABLED() because PxD_ORDER and 
> vmf_insert_pfn_xxx() are declared all the time
>
>> -	case PMD_ORDER:
>> +	 else if (order == PMD_ORDER) {
>
> 'else' is not needed because every 'if' leads to a return statement
>
>>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
>> +	 }
>>   #endif
>>   #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>> -	case PUD_ORDER:
>> +	 else if (order == PUD_ORDER) {
>>   		return vmf_insert_pfn_pud(vmf, pfn, false);
>> -		break;
>> +	 }
>>   #endif
>> -	default:
>> -		return VM_FAULT_FALLBACK;
>> -	}
>> +	return VM_FAULT_FALLBACK;
>
> So at the end we should get something like:
>
> 	if (!order)
> 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>
> 	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
> 		return vmf_insert_pfn_pmd(vmf, pfn, false);
>
> 	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PMD_ORDER)
                                                                ^^^ PUD_ORDER

> 		return vmf_insert_pfn_pud(vmf, pfn, false);
>
> 	return VM_FAULT_FALLBACK;
>
>

Looks a lot cleaner. Thanks!
I will make that change in v2.

-ritesh

