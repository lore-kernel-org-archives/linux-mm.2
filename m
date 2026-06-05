Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4BCCD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E636B0005; Fri,  5 Jun 2026 05:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F496B008C; Fri,  5 Jun 2026 05:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CC16B0092; Fri,  5 Jun 2026 05:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47C126B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:13:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D084EC1BD6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:13:42 +0000 (UTC)
X-FDA: 84845296284.26.771639B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 417C61A0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:13:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YWKRzuIa;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780650820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkKyj3KoRM9HMEcDXkoEKc1pwGxNTQ5igPedDln3JYg=;
	b=YJ+HMr/MGQdNnPXO/4ZCCfPSMLRh34sMY0aB0WGgNFouhLx8DxT8Z9p91kqtPG92PVp/qD
	qRSaZo5kD5DNqJgxdtxmMq3Hkuy9rM1NGi1Bwi6aXaSXPQ4tgDh1nUUytEDUiuiZNDc8r1
	jyIhnGtoIRECCsnwOgTMjDxLceeiFvM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YWKRzuIa;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780650820;
	b=vzUo5Qgr0JbBRrKIAeuQO6U+xq2c+6+f/ekI8P1L5sjosI/+Up9NhUyaNN2db5Mc22lQgC
	HQa4rRSeW/7ysyWls1dE910Sqlw0uDbK/vk8+v8t2Ldgjx7bZrfTu5p4b3xn0z8Li61DjW
	6qMhR+rctdgiWdXxtyE1WlThA+XvvAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780650819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkKyj3KoRM9HMEcDXkoEKc1pwGxNTQ5igPedDln3JYg=;
	b=YWKRzuIaW9lanJIeP6h+jcIyJrG2FieLY7o16DFQIkjzLzcJC3DSvt/ANSkX3LKjRnxwLc
	DauoukZUaWS8bR2JaOUMiAKuYOgPvZuhY91hJk1nw68YQKXdTTDfjo2JbbTJaAHqGlu06W
	LTx2McayEmCSB3qv/ZbPhRJy8d9dE3M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-oBuuFWvtOi2GsJTvXi2k-Q-1; Fri, 05 Jun 2026 05:13:38 -0400
X-MC-Unique: oBuuFWvtOi2GsJTvXi2k-Q-1
X-Mimecast-MFC-AGG-ID: oBuuFWvtOi2GsJTvXi2k-Q_1780650817
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45ef63d1214so1111650f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 02:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780650817; x=1781255617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkKyj3KoRM9HMEcDXkoEKc1pwGxNTQ5igPedDln3JYg=;
        b=MhUVNKMO3mCOml4e1Mi0VEyU53HOl/Fs7rrzBMVQuYvHzNnUZ9ac3reefGUZMQ/WDO
         P4vn9gp48HvBuLEHXuvxD+n7UxAWvxYoJbGUIx+UV7NDpeiKRASkoz9s5Se4DdRYa64l
         I6TImXiwZj0M6cuJTXJDO42S6ZxcJROW+GudTDulaShCNRFz3lLX4PFK9we8c1T0pEXv
         KTSOLhWb3szT1OrS1WlIJRPXbTWHe/DzWB3xiQDmJ9qviWdZDncyFSixSVD9nRU5xCt5
         w08X/0BCtv+VqE0RKljmSY957SNZXZa9rwxz9uLvRKYNpm3OFrw0zymZaRXPI/LtyA+g
         dZLg==
X-Forwarded-Encrypted: i=1; AFNElJ+VGG6HAhu7DuuxHY9uTKLE/ejxHepGWHytsqcCrfxaoAjfZUwyNQL8ytfCIfC6aVsXPkbCI0BYKQ==@kvack.org
X-Gm-Message-State: AOJu0YzqCZHr0RpXMURW56XB5MD6BIbgtK3lmO82cVdCRtwqbi/U1L+B
	RXgPxzmsBTdTOgvfz6B5d4lVD0EphwJsHhdlTQwZq38z0UoNuDsjmlIiXvNX9whLAMj0GpGUAnI
	nlhxh5gQFUQY2F+2JIFQF4aVQSVuS8qFzKMPNCwotHxlIF8YQinyj
X-Gm-Gg: Acq92OFdf9CuTOUd9GchEvMavYcQAV/yKEzC1VHLD/QyCL+xZpFaLfcK0VI6JksKDWV
	TL1Z8ZCXT1yEf3bCCmDAbjamRl7ulmZGNGqzrz0NLieivg4CvfZigE+UdDreipP35jXBVBU+7mG
	fYv+yYi/v9CW1zOS8W1bRRAVvjIZ7Iq5GmxXQCBD7YY2xdxZcjw7M1BX0iOD7ML7/V9zwVMfzzx
	B3e3WvnpVQBwYgh2uzrYlA+ujl6ZBB/jJkbJkut7BbUVrKhN9/gNWrdTSEnUWC4Lo4B8HFilwvk
	nG7TQ3YrAQJ2kTP+xVFeahr5H7rmsagmJvdSFld/4Jtq/vynBTdjJA+tMxFuyUZSiXkeX/ERJu2
	u3LjWRLKRrYtN9BRLBZDNkZ0FkJtNFNmSoWZRuBopbdiLvYDvA+tcqH0=
X-Received: by 2002:adf:f290:0:b0:45f:f142:d569 with SMTP id ffacd0b85a97d-46030505eddmr3383873f8f.15.1780650816672;
        Fri, 05 Jun 2026 02:13:36 -0700 (PDT)
X-Received: by 2002:adf:f290:0:b0:45f:f142:d569 with SMTP id ffacd0b85a97d-46030505eddmr3383825f8f.15.1780650816107;
        Fri, 05 Jun 2026 02:13:36 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46028a6dce6sm15969430f8f.30.2026.06.05.02.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 02:13:35 -0700 (PDT)
Date: Fri, 5 Jun 2026 05:13:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm]  504f40f6bd:
 kernel_BUG_at_include/linux/page-flags.h
Message-ID: <20260605050955-mutt-send-email-mst@kernel.org>
References: <202606051117.7b999010-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202606051117.7b999010-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NE5oNM52fvMuBW3HG4aPj06umDECX3AlVxBkao3gAxE_1780650817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 417C61A0007
X-Stat-Signature: 1emtyp9a45nei4pw798ywieg7j81449x
X-Rspam-User: 
X-HE-Tag: 1780650820-713860
X-HE-Meta: U2FsdGVkX1/Svh3W7nbay8SoJJ8TaBzqNPl/WDOEjJPH1FE/tBj++oD+Iy5FnUlZhGeMGStJkyvOzu/LwoDq/F+NMoW2VGBiJM6APM1tdYYUpydxGeuvDsuEyq2h5yZgj+MwzibIj7UjXBzAJZ8TkqjdirvaoasJoTePODvf3qSvX5duC1RSbR9ctrpGGhBdrOzzNmt0t3JFJzqHzTpqjGXeFhragIclbl0FG3fyaAfQJ3xw0c914uHd6B7c++PahETgbi3ZxQTxp8kI1sLKdX+mRn8NtMgqyejZf9aLHEinRGmO9EwvkpbjRySTQervnF7fsG3YC7zuJE2BnEAkG/NLgTzfMO1EJBvypx3yfigTabNzBUAbcoUmXliXlGYkGQOhvrR8eldaygl7n3BnqFqwddb4iAMHhWAOqJTFQkPjRrSAeCIGiQBzYzYT21VG7MNXN19k4HnXfjvQ9lnbUbI19aoTZq+8CkEdvO7B3NWovdWmckI5y61jvPP6qCSCLdFZllV2D8WVCfVAVVhlkXbTU24Eu8SaLByXjfx8v58yBft0DQPt1xwuGpewlgWPeedu8YwJUUVmdk2ytihAEchGdJFALZPgG1quPXN4LdWE51DIX7r52HuTd6SqkEgrbHyjZJ11f3IbwMUozsuLOXHKH9YCNS3nekshU2I29YCQAxIcLD8UsUJPiS8aORfraPC7rOdD2vV9VTGykuBKwbuxIsSdr5nm7JA15T1TnnpR2xwlZntKLGLSLy11v1qfpVH6Tv/YrX5uVB5dIcU9cdsEWvawsz/nKNrNMnN2eZtegfwJWgBOy2NhMsTR2Cv/Z+0eEDYXJBfdLmyaWs82wHYAJ7bQtC/oFdaIIXgdCQ5m8Qwm2R3BK1k6+l9m3PVOzTF7k/G8xxn77FC9GH/NcYi8LbtvQ1efXHYDcmY/tm3+Ok/kWGzLZUQLPInCgwGMTShS8kIrX9epUsFO0YP
 JOZDDRNn
 UTZ5Ig5ecdGJT/mWPE93PyKupHdi0mpeCHMZlgXT2xxGQ9yfkZGHw5FvLG/qYBZmxGdQq/RKiZaXABOY3quOJxuwPl+Y/SyXBbAxi2x3H/IzdZm7C4vVJx46xFg9IFVetjkPArR/jAwnzw1PxU4Zs+X7EF/XZ967adkW7x3tFYZNxZctsk+VYbwY23h0cUsK99wzatCHdu+yqS2AhZwrrr9bUKzT7rtQPO5M5AvQ9fn0h3afnWSpzz90Wt94n+gQw3jZrqHezfaEQrhnNwtjB9y+X0g1RLq3JctrFzemlVSepluT3/n8wwVZzbgd1xJtL+TOZn9nHNseA1OeES0DKrR+wvxVXIeJWWcz7Gndvux8cZ16nFBKoefwh4n5EFXsSExDsNuRzQRuRbEXiCAUrAeJD/Yp49o3UoJjdqVKXpatygcfFPOegVkRjK4C7LLkar/Gp6rS9DgO3He5bvC4HWmqkbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 01:40:41PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "kernel_BUG_at_include/linux/page-flags.h" on:
> 
> commit: 504f40f6bda6afb3c5dc9924f74c583b6e394554 ("mm: page_reporting: skip redundant zeroing of host-zeroed reported pages")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master a225caacc36546a09586e3ece36c0313146e7da9]
> 
> in testcase: boot
> 
> config: i386-randconfig-002-20251019
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 

Gift that keeps giving. Same thing - I pushed a wrong branch to next :( Sorry.
Made it a separate remote now so these pushes are intentional.
Donnu why I didn't think of that earlier.

> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202606051117.7b999010-lkp@intel.com
> 
> 
> 
> [    0.218502][    T0] ------------[ cut here ]------------
> [    0.219180][    T0] kernel BUG at include/linux/page-flags.h:688!
> [    0.219979][    T0] Oops: invalid opcode: 0000 [#1]
> [    0.220604][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.0.0-rc2-00009-g504f40f6bda6 #1 PREEMPTLAZY  25f758a7ca9ac6ee8258fdb39cd5b7566f523e33
> [    0.222356][    T0] EIP: post_alloc_hook (linux/page-flags.h:688 (discriminator 1) page_alloc.c:1868 (discriminator 1))
> [    0.222995][    T0] Code: 83 7d f0 1f 0f 87 10 01 00 00 83 c4 10 5b 5e 5f 5d 31 c0 31 d2 31 c9 c3 8d b6 00 00 00 00 ba 44 7a 3c 9d 89 f0 e8 f4 31 fc ff <0f> 0b b8 14 5e a0 9d e8 90 53 cb ff 2e 8d b4 26 00 00 00 00 8b 45
> All code
> ========
>    0:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%rbp)
>    4:	0f 87 10 01 00 00    	ja     0x11a
>    a:	83 c4 10             	add    $0x10,%esp
>    d:	5b                   	pop    %rbx
>    e:	5e                   	pop    %rsi
>    f:	5f                   	pop    %rdi
>   10:	5d                   	pop    %rbp
>   11:	31 c0                	xor    %eax,%eax
>   13:	31 d2                	xor    %edx,%edx
>   15:	31 c9                	xor    %ecx,%ecx
>   17:	c3                   	ret
>   18:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
>   1e:	ba 44 7a 3c 9d       	mov    $0x9d3c7a44,%edx
>   23:	89 f0                	mov    %esi,%eax
>   25:	e8 f4 31 fc ff       	call   0xfffffffffffc321e
>   2a:*	0f 0b                	ud2		<-- trapping instruction
>   2c:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
>   31:	e8 90 53 cb ff       	call   0xffffffffffcb53c6
>   36:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>   3d:	00 
>   3e:	8b                   	.byte 0x8b
>   3f:	45                   	rex.RB
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
>    7:	e8 90 53 cb ff       	call   0xffffffffffcb539c
>    c:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>   13:	00 
>   14:	8b                   	.byte 0x8b
>   15:	45                   	rex.RB
> [    0.225477][    T0] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
> [    0.226363][    T0] ESI: f4102340 EDI: 9dc37ba0 EBP: 9d633e20 ESP: 9d633e04
> [    0.227277][    T0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00210046
> [    0.228243][    T0] CR0: 80050033 CR2: ffd99000 CR3: 1dd74000 CR4: 00000090
> [    0.229132][    T0] Call Trace:
> [    0.229534][    T0]  get_page_from_freelist (page_alloc.c:1938 page_alloc.c:4006)
> [    0.230201][    T0]  ? __this_cpu_preempt_check (smp_processor_id.c:64)
> [    0.230883][    T0]  __alloc_frozen_pages_noprof (page_alloc.c:5297)
> [    0.231617][    T0]  allocate_slab (slub.c:3269 (discriminator 2) slub.c:3458 (discriminator 2))
> [    0.232174][    T0]  refill_objects (slub.c:3516 slub.c:7153)
> [    0.232743][    T0]  __pcs_replace_empty_main (slub.c:2818 slub.c:2839 slub.c:4602)
> [    0.233433][    T0]  ? mm_alloc (fork.c:1157 (discriminator 2))
> [    0.233945][    T0]  kmem_cache_alloc_noprof (slub.c:4695 slub.c:4829 slub.c:4851)
> [    0.234624][    T0]  ? kmem_cache_alloc_noprof (slub.c:4689 (discriminator 2) slub.c:4829 (discriminator 2) slub.c:4851 (discriminator 2))
> [    0.235315][    T0]  mm_alloc (fork.c:1157 (discriminator 2))
> [    0.235814][    T0]  poking_init (x86/mm/init.c:824)
> [    0.236341][    T0]  start_kernel (main.c:1072)
> [    0.237088][    T0]  i386_start_kernel (x86/kernel/head32.c:79)
> [    0.237969][    T0]  startup_32_smp (x86/kernel/head_32.S:292)
> [    0.238817][    T0] Modules linked in:
> [    0.239561][    T0] ---[ end trace 0000000000000000 ]---
> [    0.240564][    T0] EIP: post_alloc_hook (linux/page-flags.h:688 (discriminator 1) page_alloc.c:1868 (discriminator 1))
> [    0.241521][    T0] Code: 83 7d f0 1f 0f 87 10 01 00 00 83 c4 10 5b 5e 5f 5d 31 c0 31 d2 31 c9 c3 8d b6 00 00 00 00 ba 44 7a 3c 9d 89 f0 e8 f4 31 fc ff <0f> 0b b8 14 5e a0 9d e8 90 53 cb ff 2e 8d b4 26 00 00 00 00 8b 45
> All code
> ========
>    0:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%rbp)
>    4:	0f 87 10 01 00 00    	ja     0x11a
>    a:	83 c4 10             	add    $0x10,%esp
>    d:	5b                   	pop    %rbx
>    e:	5e                   	pop    %rsi
>    f:	5f                   	pop    %rdi
>   10:	5d                   	pop    %rbp
>   11:	31 c0                	xor    %eax,%eax
>   13:	31 d2                	xor    %edx,%edx
>   15:	31 c9                	xor    %ecx,%ecx
>   17:	c3                   	ret
>   18:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
>   1e:	ba 44 7a 3c 9d       	mov    $0x9d3c7a44,%edx
>   23:	89 f0                	mov    %esi,%eax
>   25:	e8 f4 31 fc ff       	call   0xfffffffffffc321e
>   2a:*	0f 0b                	ud2		<-- trapping instruction
>   2c:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
>   31:	e8 90 53 cb ff       	call   0xffffffffffcb53c6
>   36:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>   3d:	00 
>   3e:	8b                   	.byte 0x8b
>   3f:	45                   	rex.RB
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
>    7:	e8 90 53 cb ff       	call   0xffffffffffcb539c
>    c:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>   13:	00 
>   14:	8b                   	.byte 0x8b
>   15:	45                   	rex.RB
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260605/202606051117.7b999010-lkp@intel.com
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


