Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84AEAFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F666B00E9; Fri, 27 Feb 2026 15:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD2B6B00EC; Fri, 27 Feb 2026 15:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBCE56B00EE; Fri, 27 Feb 2026 15:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8ECE6B00E9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:50:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78E4E140949
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:32 +0000 (UTC)
X-FDA: 84491429904.25.37BB741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D1FAC40011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mlauLzQG;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SwHhUo7f6e3oK+rCDN++8NaoLTRaeldbKCrEssk4FM=;
	b=bGz3MYrZprdir55JMLioduuYNr3f/JY5mdLPCHhRpsoDZw9XiEExVC5lu2VZJ89BbZutXC
	VZ83Q/qXLSag09Q/uVROMx25g1LXzWAMmp8ivGLGMG4sjqgnx+nMil1Bhu6kagOGATT327
	lw8ytlO9oEIF8NisRH7Y98PzIEEUYhA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mlauLzQG;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225430; a=rsa-sha256;
	cv=none;
	b=RtMBRCi+E51Hy04/pQrAudRHRcH1db42+ePzyuEoGmXgXO8283lNCH+JfM3c3mNNKTafqF
	g6Oe1PMn63/3lqW2ct07aZtIFS2C+5WAcneJ+uX5wx/HwxUOCk6XXHuEzn0oRSHA4UAhbr
	iCjYaSI3B6L08ofY0nMoe1GaLZv0EZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E5126013C;
	Fri, 27 Feb 2026 20:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E3AC19421;
	Fri, 27 Feb 2026 20:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225429;
	bh=W7BP0oevASDZTGnn55NW+Dj0D++HXk3OGi0eWIHJO0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mlauLzQGiJZxJYdDtNIppIVaJ+GnRJrKcMLeRVeGHPIhI2MWCe9B3tOjc5B9vf6wi
	 SJKBc2Ih57Wuy76pija0vrdZmZDMt9dWXynCa3zZgMIiiyAJe1Ooy71HEKDtYGnZfH
	 JOJa6I4DnboqaGyvlpn5XyHiIGEMHM1lTNNeoYNCGui7nWNa1CYCaXMHzNp3CsJJmo
	 yJg54Hltr351bhKrwVC5/94dhohmHR+51MxNeV4Elemgqk/h8S0ikc0heZmHYZnizX
	 mJ+hiC+UMkidKcbvtYgtDnJp6z4n+WzZINHAIzHUste9UBiwb0x7bjlg4b78Jvzdk+
	 w2oc3cwGYjKbQ==
Date: Fri, 27 Feb 2026 22:50:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Donet Tom <donettom@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>, linux-mm@kvack.org
Subject: Re: powerpc/fadump: CMA init is failing
Message-ID: <aaIDkB2xLABDyV1y@kernel.org>
References: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com>
 <87o6lagljy.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o6lagljy.ritesh.list@gmail.com>
X-Rspamd-Queue-Id: D1FAC40011
X-Stat-Signature: 73yic1p4pdfqq43xdets6mppxkarx113
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772225430-559722
X-HE-Meta: U2FsdGVkX1//Zg/GH3QPdbvx5PECVNNcwcFKMJ9h7Qq5qdhZNLJNj3eAa/auETtlyXdkvLSsGe+KBfOaMJ+AG5HapWQPFYQYjxzM/+L7dEm3bKHGsxDPS3R9ays9IRc01cDQs1ioANocOFUtcAnRfS/sHlKvB88XxnSxQc7lLUrLMQSQNnxZh/tbYevHVFgYkFLiBg0YcruBnbNWkYz1Q0K/kbeodj08yOpkSVQ1mAoD4giq8e0xW6bnFlEn7EUsyEfUaVTFIcFDMsSxfh5Oaun9fqIE2jSQjgyimlkb4mji4YdkazJRk9Y73AyZdK94bHK+LuvjKGDFmvQZKp0fcDaGTDHzQctEj6fC1+L1WauY2vQOrpaMGPGP14TichuBnV4uuGjs1/G5rGGBmzqH7mGZ8bJs32BCs44w3ugMKOLaV2UY/XgM5HklSC1UhGyOrGC5GHsf/Wm/NLch603fLLuHjAsiRLxoKyEAz0WIlzjGj3Ffj/4SmThGPzZESnwrV2SvfEdamrO37OCkcQd+XMEEkyuTmnrVAudHOfie27fgBH28KO2dFLnSkecp+fbnu+yaGiyum9bq9e7wIuGGkIPWz6aam2ndwJJGMnn119+4uVs3gPsUgEkHhkgoDqK7SXItDIhT6O3ivEmoegGOysMTCd2/LGupTcBTtGRMlh+yaXmok3bW0QLU8O/sUcZY5iupIOUopHVGwPqWFvRui9uKb+BBooXK8mctwIWOMd0PN+bcpKMAzKBtVXenIiQWMUbUvFztwQDXb2ZgSPyMkHFXqfk19snY+GUxnZ78yQ6881kII8GsCLqR5sh8US3/ZhH8ofJGdQ502FTwgeAnNLmC4SA08fvmjqbgy9c+qldNMdtpmlv1HUnp1unXkxOg7ZGgBu10B/OzrEZH4ESjd4CAAcnzVxOihAG3hADj1tKQPej8xmwWwVg4Ht1yiPfw9ZxV5x7JTa5+eM6pLPW
 7g058cVL
 9NDEyDuXreqmFly+6ia3I2mfg5JANGlTliq4AgP3cm1sNmMmNZrxqxa7MsqGWYcFPoKACP1jXeNfD417tVqQvMi4rerUtV0XhUvoLnvox7NVgq05Tc1vo9Gw9LCTsXz1kgh+UZr9o/zDRdfIlWNl/SrH865jVNt6MCn6ItQU76MRN6l0Zc72LEzZQLpuLnutrOQwrfPABo/MkLkFCKj7Ex+o/P6lO0rtAhNV/y5/Hxl1fIJ1xoTlYghWHtJjFmTBsuYNJ77L7S3SXbe3wo5ipsZDJWxiKQHDGWNuc/P6CBepVVDFElq0rAaqLqzf/5soYkNxzz8VHExONGIBPxUvMinjQuwB9Sy1mJeoVIx93/MPtPBTNmdnqg3cCOICaT7FAVqFTs4uIwioVZTksZkma1jebvvaoYNCZl5S3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ritesh,

On Fri, Feb 27, 2026 at 10:39:53PM +0530, Ritesh Harjani wrote:
> Sourabh Jain <sourabhjain@linux.ibm.com> writes:
> 
> > I noticed CMA init for fadump crashkernel memory is failing.
> >
> > [    0.000000] cma: pageblock_order not yet initialized. Called during 
> > early boot?
> > [    0.000000] fadump: Failed to init cma area for firmware-assisted 
> > dump,-22
> >
> >
> > kernel command-line:
> > BOOT_IMAGE=(ieee1275//vdevice/v-scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc1+ 
> > root=/dev/mapper/rhel_ltcden3--lp12-root ro 
> > rd.lvm.lv=rhel_ltcden3-lp12/root rd.lvm.lv=rhel_ltcden3-lp12/swap 
> > fadump=on crashkernel=3G
> >
> >
> > Same issue with kdump CMA reservation:
> >
> > [    0.000000][    T0] cma: pageblock_order not yet initialized. Called 
> > during early boot?
> 
> Good that we added those debug prints ;)
> 
> I think I know what went wrong, as part of this arch,mm consolidation
> patch series [1], I think the order of initialization is changed.
> 
> With this patch the new order is ... 
> start_kernel()
>     - setup_arch()
>        - xxx_cma_reserve();
>     - mm_core_init_early()
>        - free_area_init()
>           - sparse_init()
>              - set_pageblock_order() // this sets the pageblock_order.
> 
> Whereas earlier set_pageblock_order() was called from initmem_init(),
> just before cma reservations were being made. 
> 
> start_kernel()
>     - setup_arch()
>        - initmem_init()
>          - sparse_init()
>            - set_pageblock_order();  // this sets the pageblock_order
>        - xxx_cma_reserve();
> 
> So that means, pageblock_order is not initialized before these cma
> reservation function calls, hence we are seeing these failures.
> 
> setup_arch() {
>     ...
> 
> 	/*
> 	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
> 	 * hugetlb. These must be called after initmem_init(), so that
> 	 * pageblock_order is initialised.
> 	 */
> 	fadump_cma_init();
> 	kdump_cma_reserve();
> 	kvm_cma_reserve();
> 
>     ...
> }
> 
> 
> So what if we do.. 
> 
> start_kernel() {
>   ...
> 	setup_arch(&command_line);
> 	mm_core_init_early();
>     setup_arch_post_mm_core_init(); // and here we call CMA reservation functions ?
 
Unless I'm missing something these cma reservations can be moved to
arch_mm_preinit().
It runs after mm_core_init_early() and before memblock moves the free
memory to the buddy.

> References:
> [1]: https://lore.kernel.org/linuxppc-dev/20260111082105.290734-1-rppt@kernel.org/T/#m5adf1a845e0a0867066c4f7055f28e6304b73fa5
> [2]: https://lore.kernel.org/all/3ae208e48c0d9cefe53d2dc4f593388067405b7d.1729146153.git.ritesh.list@gmail.com/
> 
> 
> -ritesh

-- 
Sincerely yours,
Mike.

