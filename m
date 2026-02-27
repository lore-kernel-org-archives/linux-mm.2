Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C716CFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00516B0089; Fri, 27 Feb 2026 12:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE346B008A; Fri, 27 Feb 2026 12:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FC26B008C; Fri, 27 Feb 2026 12:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 830106B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:42:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E57114077F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:42:26 +0000 (UTC)
X-FDA: 84490955892.30.ACC8704
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53B0420003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:42:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a92XQnMR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et77aHJTeuGzmmNrAkPK/DYt1o94w5tXvKsba6OelYM=;
	b=HR74N73k8TP+z7T3kEf9Hvymjhr+KYeMSSnPdAWEqvAOy83uB+Gm0x2qew85lLSs+nudFG
	ko88wSP9aB33IGqsFbJ0vBSQVfUmce9sK3nPSxPL6kGqms2q5q/hbP2zgWtEuGyMFz1TkG
	sRKMSYLSYLcLg+2pOixhyS0CZojI6rA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a92XQnMR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214144; a=rsa-sha256;
	cv=none;
	b=hhnlfKXkROTSN1AFcftgpE41a0yhl6vLDgQLLGRSL1NnYW1Wq5/b7ZqP5xs3acDKjyNUZJ
	PL6VcWzCFEYNUuz+LqijMvvEvZUqqdzANZxVhgu51MKq7HePNvuffP1rUj3Ie24G0zYj1H
	KT0odNVljJsmaY4IEAOXp0q1BtfyZ2k=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so25275715ad.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772214142; x=1772818942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Et77aHJTeuGzmmNrAkPK/DYt1o94w5tXvKsba6OelYM=;
        b=a92XQnMRjt7VbHPU1bz8XfsHlZViwyE42ZC2Ea+LXmPDrIMVue8gspYxLJinJK4t3m
         fyvW/1o/k1FiV7wcAgBdv00Gyz3z3ax0wwWwvOC/Z2lfKZVwlJZO4cgg4YRcqHigLIXO
         131YAlO8jPbZT1tfDH6raloV7gM8iL2oAgJSD/Asvu5EXbtFIruDgJPi5haI6hozs/N8
         r8TvjEIPVOccCFMEfeWBcdK9fQwqR1k4MA50/m1PolT/7skwY6o/ANL1b48sw1wju/7Y
         TCWUn8mW10dTcd+xmcHASh+ATLhDappO96FJC+sEonTEvbbEwbkzr6VZcdv6qyoVk/yN
         nt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772214142; x=1772818942;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Et77aHJTeuGzmmNrAkPK/DYt1o94w5tXvKsba6OelYM=;
        b=aHsTLm3eFqB2AkRm+RrGvKPhmimJlm//XpGR6yO9pkHBsDZ5zxRqtiv93meotV3kj/
         7X/5r0cr1b58YTn5+O0r7TNh/Yh0KsfNSAmeta48l/9TcfBC1z8Po2fP1zVUtbg78zvO
         qgYQGA5dKWb5juAlR0W1nu848agg60HrV8fiwwPHtOy5mjQtoH4/H+AswVdo9vnI6U80
         1uRA2NTVNfIqVAz/ihhgkLied8OtpYt9xpf2o9TlWJ/7CHyEOQBEq1z9r6vta8ARfsj/
         bmQDytHL3N0GsNiW82mdysNmnf0SAYU76Sz9gh+kFZIQuA36PUHzyR+ilMI15PZI3t5Y
         kQpw==
X-Forwarded-Encrypted: i=1; AJvYcCXVscb+BIkUk3I/bbvvCv65WvIZ8arbcVagDf192G09k/N63DneeSseKWzCS81Yv5gMkMOPuFEiiQ==@kvack.org
X-Gm-Message-State: AOJu0YwiYFOWQNUox1r+qBvDTlY1idAvK5e/QVkAezociBdjv8SUs/xA
	VrHZNfwM9bHoiThRZHY0/be+IqbOa7OrOElQj8vUP4XlxU3MG6Ob8n1R/aCa+w==
X-Gm-Gg: ATEYQzxkC7R109awnw89zeHLD4qimtoc+ck9UnvVhDYnRVfsB9Wn6/O9Wq9G729atw1
	x6hEEvwvwjZaJWTpZzAlw2EMxi17gcSf82yFq7h+6ctdKMa59v+K3TcYQj0qp14KfeZ8XWnT8i0
	RJ9Z+Iqrj2gdhjxYuHberJ1h+qUJ3H7nDFzFHjVHeyZ0FSscODjsH2Fanp0Tdba37tU6x10ujbn
	3WNCYcVOjKbVkxfZctm36Je2N6n7gAoT5RHoTAy8OgsfmeBuoxJWCQfOEtyPe6dsTiesGpqHhzn
	RnGu3tZbkjqdRjJrm7gMugFcN04qxQQzAMR/AoQ7IbjiAJdVVdZrjKZOq9lUS5rDtkggdHAwCHz
	cUusDIo2xyiiSaMrG8dU2ej5emxl3sniMaZh1yDDo+gNTyIO6cTsPPskp3VXZW+SfSLn2g/HANo
	LO1maiqQmXrkmlQQrdJ6qtW+9v44Rc
X-Received: by 2002:a17:902:f647:b0:2aa:d350:fbf0 with SMTP id d9443c01a7336-2ae2e4a5ff3mr42125155ad.26.1772214142121;
        Fri, 27 Feb 2026 09:42:22 -0800 (PST)
Received: from dw-tp ([171.76.229.104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b974csm58040095ad.65.2026.02.27.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 09:42:21 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, linux-mm@kvack.org
Subject: Re: powerpc/fadump: CMA init is failing
In-Reply-To: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com>
Date: Fri, 27 Feb 2026 22:39:53 +0530
Message-ID: <87o6lagljy.ritesh.list@gmail.com>
References: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53B0420003
X-Stat-Signature: w6nynigqsoyrkxspfg1tyw66ydmzxw4k
X-Rspam-User: 
X-HE-Tag: 1772214144-843334
X-HE-Meta: U2FsdGVkX19J5Y4T10VZxiQ93CB8i+3vAGneKn47P3X5QbvPN+NcN9ZR1gIqA+3E+k+3qZ/PTxk1rV2aGR0to9B8enaXVO+8uqcKAOy0itjj3IRmvb6NVf7n4er9HezG1rEJeqezYG78gkSQyZ/FoDSpaaaITCt4YBNZgajJZLKN4Ajy5VkP1ldcJdl+0Jf3lpQMsrskRW79FOP968NmpU+1L4g9IH8Tzxt8jy8p6kZeMYrrpoVfb6ze0D4t+jdgR3jvkBdsoG+s0Sqlw23PCRNyypSsm+ApdF5zJ+dcH+4B6MX2bUoVKgGUoUUMyYo9nYhk0hKaEpiy7qf3j7rhsiukSTg6BF2AvQf9Nf8F5RmoPHHZ1kOw65a08Bsx6UHq4DJUyjgrbcsQxe6z6KAanNhXDVixoFIg9bqYfjmZciMYTYqkDhC4hdNjDNCPLOOTjNj6oJciXCJzNt7Zo7KUvon4knh+gSghFW9lNAV5MEcXAnxVe3LeYzRahAGilKhpVTLMohe7qOmHHTeNvdJEhwks+FhQPTQ6KHIAtO2rJt6anXGjZ1eTGyIYHoCmX4kxBIGtZMCtIMq8vIpHqUekcTndEE1gYuX8f7uJxAIe1I1bx7xri4ExBisWU61baw1rkTrc85nziYlm0zglvdm/XXHJx5sUhrA6DxlyKhAfeJkKPdCVV/bkHEIJCOlGHE7bcEOZMGgIpviVg6vGpe/FcY/wBk0Ksl87tUjjkox6F2Eps7/MT3ZCyTw6S+L8CAOS0EWlgiELPdPLQQ12BHg1im8rnFE3ukawQ6bIIFgc/l9D+Z7SdyeyZcirv42v3N4bs8F1Yy7KYEMDHk5ah495Ocg+WXS57V8rbk3j8mqvlDhvGQiBCAlxTiQfOJESX2T6q6DqBMJmfb7+5oP32IgpPFLooXv59hEjOL41Hcqbwz3B9sPPQq34Ihuvc4vCAabTpkSUcYX633Zg3xD185U
 f1hCWn8P
 A5wxtU6CVPQd0vImr4K5XV9xQKumRGpMgODLVqWQPn49MkSmTj6T0KkvqFASPIGf4h4SsgCHwNYEnZwXaS6xgKciDm4bmToZND4Csm5VxDzjCzPYW5NPnnmKyAlpts5hzLj5araVIx4a3ihTlIJTL+6R2HOLqxaiD+j7A+4w2ftT7r1jDAf4uMRTpiNFjMFTib+1NojpJe2wIhrGmrodtMJu4rgJL3X5F2n323hl8vDs3h4tDH7G/ckSrw7LJEmRrlQ1pOj1L8LTQJTeeQUjmwaegOV+V80oFyGHJVDg9JCrGzoZptNYIlna9vQ1HccreHnRS7FSkh2c1r5Ogh1vf0FoGj/v58HU5HDfguGn84xao+zF41n8Ys3ma2a5k3qhRYuycEkpfqHZRTrWryxOpEEDWN579wsEx5F1yJBvYJ88zy6SAGU2y7hU3MTrMm9MVsugIZCgOnUwyiDqLZ8rx7+CdJRrYtk/1IdysJd5X4xFoGHuzrU7SziRNa/qyRovm3KgSViLLMGXZxkBQt4Ib1bQep41b4iuWhGdvFzePNqIsS/QinBiWyvYQ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sourabh Jain <sourabhjain@linux.ibm.com> writes:

> I noticed CMA init for fadump crashkernel memory is failing.
>
> [    0.000000] cma: pageblock_order not yet initialized. Called during 
> early boot?
> [    0.000000] fadump: Failed to init cma area for firmware-assisted 
> dump,-22
>
>
> kernel command-line:
> BOOT_IMAGE=(ieee1275//vdevice/v-scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc1+ 
> root=/dev/mapper/rhel_ltcden3--lp12-root ro 
> rd.lvm.lv=rhel_ltcden3-lp12/root rd.lvm.lv=rhel_ltcden3-lp12/swap 
> fadump=on crashkernel=3G
>
>
> Same issue with kdump CMA reservation:
>
> [    0.000000][    T0] cma: pageblock_order not yet initialized. Called 
> during early boot?

Good that we added those debug prints ;)

I think I know what went wrong, as part of this arch,mm consolidation
patch series [1], I think the order of initialization is changed.

With this patch the new order is ... 
start_kernel()
    - setup_arch()
       - xxx_cma_reserve();
    - mm_core_init_early()
       - free_area_init()
          - sparse_init()
             - set_pageblock_order() // this sets the pageblock_order.

Whereas earlier set_pageblock_order() was called from initmem_init(),
just before cma reservations were being made. 

start_kernel()
    - setup_arch()
       - initmem_init()
         - sparse_init()
           - set_pageblock_order();  // this sets the pageblock_order
       - xxx_cma_reserve();

So that means, pageblock_order is not initialized before these cma
reservation function calls, hence we are seeing these failures.

setup_arch() {
    ...

	/*
	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
	 * hugetlb. These must be called after initmem_init(), so that
	 * pageblock_order is initialised.
	 */
	fadump_cma_init();
	kdump_cma_reserve();
	kvm_cma_reserve();

    ...
}


So what if we do.. 

start_kernel() {
  ...
	setup_arch(&command_line);
	mm_core_init_early();
    setup_arch_post_mm_core_init(); // and here we call CMA reservation functions ?


References:
[1]: https://lore.kernel.org/linuxppc-dev/20260111082105.290734-1-rppt@kernel.org/T/#m5adf1a845e0a0867066c4f7055f28e6304b73fa5
[2]: https://lore.kernel.org/all/3ae208e48c0d9cefe53d2dc4f593388067405b7d.1729146153.git.ritesh.list@gmail.com/


-ritesh

