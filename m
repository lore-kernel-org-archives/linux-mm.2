Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873E1C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 21:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917436B007B; Thu, 23 Jul 2026 17:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8486B0088; Thu, 23 Jul 2026 17:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5756B008A; Thu, 23 Jul 2026 17:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5206B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:55:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98E5E1C011F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:55:23 +0000 (UTC)
X-FDA: 85021398126.24.BE520CC
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5AA91C0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:55:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kFF7vOAh;
	spf=pass (imf20.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784843721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIzr+JgqewNTQ/0gbtkS7twloS48+dLUG20Ii2mnmEA=;
	b=IKajcU01RgOW/yfvMKoHVefkcaDuK13dquGf9YPdwQBOtumBHqzQ7/6GSWNyrUKY0MX4Oi
	EQDzWuRzYkum8gU6b01VHahBb04M44Bbe9OH+oyDI3M8hjm6JsOjIJWSg6pFc7ZOvuEH/4
	SE++hTtZphIcIusVFvEJ6EHZvFYOr6Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kFF7vOAh;
	spf=pass (imf20.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784843721;
	b=oEIG2CAac5fGhLguizc+oQ1TH1gVaA/mh648wyyILhpm28BixhZoTjJS/ieAfQuVaRqBGK
	4CCjuAVnT4mvXZtt7pNO1pw+eeToJLoKQnoSBVeJg1eiMD3RoC/RYhhkNIfhYHd+i9poWd
	SRmLVKSDM/0H0kQUYiymYHF/aDQ3rSw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ccdf36f63dso50035ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784843721; x=1785448521; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WIzr+JgqewNTQ/0gbtkS7twloS48+dLUG20Ii2mnmEA=;
        b=kFF7vOAh4Uv6Mgw0rMSG2GdsQviyC/Cp28nrcJfwnNYsgl7wxgVa+9nHz135pc/VN9
         l4QQH7jJPjXzn36AP1PsGbfZ9eerXYHj5bP6VlJBqJpKgvRiTZdexNNG5RiN84aIryv6
         CAJ/1ymq7U60deOYrw+8AhqNMnj0l6yw7316Zg2Sg3Mo/6m4sqIpotdsa+/pFl3PQ7It
         uDZ7oGsOeuPrC0yqxe5ahFhpTPm/qH/nlEhTgUI+5niFaetxykvHmfFwJpy4BJCwDZVL
         WxtN44mmw0XkL6CDRwT3vStC1bT0xpE3sNUBKvAqGKJB68tyvGvrtXTocurk48uunHKH
         IRGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784843721; x=1785448521;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WIzr+JgqewNTQ/0gbtkS7twloS48+dLUG20Ii2mnmEA=;
        b=ht5yg04oPXBzerZ+PtAdl0ZWsiKRSsYzqMbBscT1XTcpPyWnYDDgbsL+d/iZkb4gsX
         +BrL6A6KjQsDsJuyO7I/u93uoHGsv2S5xF2HzewgS6kP22EtI3ONO7safl8gKQdr8YID
         J860NS1ABUV0OwS7RxYGNur857OkCno46EBiVCmd0lf5yoTGnJ78TC8aSkU56b0OB+Ub
         XlRCfI+8eKkCG1ycbOqco3ZoBH/Y4aqODkUsx5aJGX9v4+l0qQirP16FTVNrU7h0A8iX
         Rzn0V+16Q8RX3BdzRb1CLaNdBotlharIFLjrcxZS3lo5qLlxP+P5hRJy/cYFndpEhIWU
         R4AA==
X-Forwarded-Encrypted: i=1; AHgh+RoLCIrDNf+3jLcqOqvPHx63oLcxHjBQlYevC0b01FDrSavgOQRLNd8p89KyK8GYwB0u1QEMS0RvMA==@kvack.org
X-Gm-Message-State: AOJu0YwLEM5tgDCYQKoeGsyEvJ+3jfKn9yrVKS2sPhwgDUI5XXLSTbHb
	6c60l5hokIBH/ZgHDNsbRt6bM3y0Df5WJpNXoUv0P1gWM816NcXwUWihkVKFnUd/Dg==
X-Gm-Gg: AR+sD13ER7s5oB1fvMpeVuQ2JtpXLu4//teIO2qVXPMLBACox5gnyTqQPLe4/uiCxJy
	jcE1l9vvtK0IcoHZaILYyDaDDG0UToTj1sEQlx0NfzLBtGH/Xsy8853TwXlseQyWlQQhRlg6ble
	u+ddwOjwLYVxqWW3ijXyuKN+IcPwTGtYWYornTRtN+Y5CAvURVS8z3G9+TQrwJOMfyBdvU4BmGM
	ifoYSj4bpP7uRXT/D2HfmLKPDFsV/hCSSy3c8jUWJ6MkrGmjCWSTBIBzWQPgevBeFVrV0EsuWhJ
	XAeuhrbGisrB+BpMb68RRFlMhSk7CGem9Z4bNSobQToJyi+Zv686bHLh7geIEFvWjQlnnjfH79z
	wcbIXnI4YG+zbOiMKP8hhsYxbC+4JB1qysx9PEO+jsopHM5NMhb/dkyGaeGh1dK9hwKF5H7yfq4
	5QwRE2qSXTIDpdWjWxFsyZdkQ/5u6YyjfCJhUl
X-Received: by 2002:a17:902:f687:b0:2b9:e831:5e5c with SMTP id d9443c01a7336-2cfc01915f2mr1526335ad.4.1784843719386;
        Thu, 23 Jul 2026 14:55:19 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f2e6252sm40455355ad.52.2026.07.23.14.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 14:55:18 -0700 (PDT)
Date: Thu, 23 Jul 2026 14:55:14 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Josh Hilke <jrhilke@google.com>, alex@shazbot.org, dmatlack@google.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, graf@amazon.com, 
	jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, julianr@linux.ibm.com, 
	kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, 
	lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v5 06/20] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <20260723181436.GB260824.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-7-vipinsh@google.com>
 <al_8v_I9Z2Dc_qjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al_8v_I9Z2Dc_qjc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5AA91C0007
X-Stat-Signature: 911wu9r6gxmea7q68xz1k5eg1pnukmgr
X-HE-Tag: 1784843721-570145
X-HE-Meta: U2FsdGVkX1+bA2KJ2GO5FmGy04gvuAe9VyUZv1Gvi0jIJBFEFxnZA3cA4LkWhxO1vKSMzqI/23zMVcCxpKgqrS56Uqw2dKohYQ3GFxU3mFwPjFis+zuSw3YLxD/sibEtzvARde+JIZm9FNDRPcbv5VHnsxQrgI6Agq9+fxHleye/70gqi0xGWckSG2GVAN1+Q8UdmcpNMKPyurlG2Qdp4aj8ujvaGas5W6UCNbyoAcpmjdGi/I36vCXaCrxGLgc2sGrJq7wGBQzeE3vy5HTrbhXrF1dhax51yXRKLbf1n9xWIPo+ArzyQwUne+Ik/ZaLM3iLrPaCmVecTEEqReMUaL+LXaIcBAEQBwwr5d573roWvG9EXtl2tbX1a3m3F5wFPgdVgJn+lqWKhNrRmZeCn/Do+Uks+G+ij2649HQmB95VzGfDsz98hU1Qek8G9oqWTMwJ7FMmWJzcsH8C31JKO5N+IGuMvA4donrIy6mIPhr30n3YWwS0mr4uruYmJiYp6H4nFTjmPYPaP3X9i9ex+mw6qovH/ZPAVszcSXTKrvlcA6SKXnZ1KjsUpoBFjIl2AIEIyI6J2tSxEjAcQcJ0LWgojOcDQEMOk1giBoIrUMr7/8ERZRpzAsl/N2VLq9P34beSVCoKFPCEPjPcRmYsQgOxNhccEUBtIrW3BNbU4+SDRZKXC3shn5gDelhNg15kmVjXS2DMUHqliW6b1GWC5TjdDSkZID+u/LP6zYFZPsBQ0bRy6vVfK+xaLvYbaUOWgoH9inD9UhzeWC3Maet8LsIT5gNmgJ0iv1U36iVwz/VkTNsQgPM0cW/c/ElbORn/WXOZTsOwX5TFIlxeVq/rb8doBIiU6+UCvdkZeJ2uqHUvtESVRt219MsrzSOx6IFKyucEUln4dUWD7VckrKkeB6LJ93mx+C11BUZF7ozJ7D6TvudQLrxKcFa5CxQsrWMrwiblqbJ6nA9U/gmAuA/
 IuARvhIK
 h/Qc9FvknJkfEhm4vlZ0vWsM/0M1f76vsJl1g1DwZeWMesDRVDfdS3SwpLS/Q+BiuVh+f2zd3F0lDM9kOAtIaho6gZxjban+JC1K4EsyoApRXxeWaISK1vUMsQ0atUmELLppKEjCR3fIk3dVG8PE6lx/scBQ/hufabh9WG6tBQ6xmCZMgLjB0aezabxseYrmurtdYLL9vC1htulT0URAwBqCLEMSOMlfn99A6LlZKaxhTIWAl/phNTVlg9zeifLg4DXYEkH6dSl5IslR3jX8CPoqnN9hVSv+igx8+LNJ7S33VlnmSMn7HvnIOsr5fpCv9jnlYBkVga3ER5m/NyVzn1V0yvj8R0JjzyQgogHNf+ih/fZyPvxDJ0dQiss0naDEQlkP6+jP/6LL3wWKeCa4Kx4h3pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:16:25PM +0000, Josh Hilke wrote:
> On Tue, Jul 14, 2026 at 08:14:51AM -0700, Vipin Sharma wrote:
> > +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> > +{
> > +	struct vfio_device *device = vfio_device_from_file(args->file);
> > +	struct vfio_pci_core_device *vdev;
> > +	struct pci_dev *pdev;
> > +
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +	pdev = vdev->pdev;
> > +
> > +	guard(mutex)(&device->dev_set->lock);
> > +	guard(mutex)(&vdev->igate);
> > +	guard(rwsem_write)(&vdev->memory_lock);
> > +
> > +	/*
> > +	 * Userspace must disable interrupts on the device prior to freeze so
> > +	 * that the device does not send any interrupts until new interrupt
> > +	 * handlers have been established by the next kernel.
> > +	 */
> > +	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
> > +		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (pdev->current_state != PCI_D0) {
> > +		pci_err(pdev, "Freeze failed! Device not in D0 state.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Reset is a temporary measure to provide kernel after kexec a clean
> > +	 * device while VFIO live update work is under development and not
> > +	 * fully supported. It will go away once continuous DMA support is
> > +	 * added to device preservation.
> > +	 */
> > +	vfio_pci_zap_bars(vdev);
> > +	vfio_pci_dma_buf_move(vdev, true);
> > +	vfio_pci_core_try_reset(vdev);
> 
> I'm seeing the same lockdep splat the David found in v4.
> https://lore.kernel.org/all/ag-aFA1BJxdJMywr@google.com/#t

Thanks for reminding this.

> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 7.2.0-dbg-DEV #3 Tainted: G S
> ------------------------------------------------------
> kexec/13355 is trying to acquire lock:
> ff3f086c95315d08 (&group->mutex){+.+.}-{4:4}, at: pci_dev_reset_iommu_prepare+0x6e/0x200
> 
> but task is already holding lock:
> ff3f082de7f399a8 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_liveupdate_freeze+0x58/0x100
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #5 (&vdev->memory_lock){++++}-{4:4}:
>        down_read+0x3d/0x160
>        vfio_pci_mmap_huge_fault+0xb9/0x150
>        __do_fault+0x46/0x150
>        do_pte_missing+0x21a/0x1000
>        handle_mm_fault+0x7f8/0xb60
>        do_user_addr_fault+0x476/0x6c0
>        exc_page_fault+0x68/0xa0
>        asm_exc_page_fault+0x26/0x30
> 
> -> #4 (&mm->mmap_lock){++++}-{4:4}:
>        __might_fault+0x5e/0x80
>        _copy_to_user+0x23/0x60
>        perf_read+0x114/0x310
>        vfs_read+0xe7/0x360
>        ksys_read+0x73/0x100
>        do_syscall_64+0x15f/0x4e0
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #3 (&cpuctx_mutex){+.+.}-{4:4}:
>        __mutex_lock+0x8c/0xd80
>        perf_event_ctx_lock_nested+0x15a/0x210
>        perf_event_enable+0x18/0xa0
>        lockup_detector_online_cpu+0x22/0x30
>        cpuhp_invoke_callback+0xfb/0x2c0
>        cpuhp_thread_fun+0x164/0x1e0
>        smpboot_thread_fn+0x17e/0x280
>        kthread+0x10c/0x140
>        ret_from_fork+0x16b/0x310
>        ret_from_fork_asm+0x1a/0x30
> 
> -> #2 (cpuhp_state-up){+.+.}-{0:0}:
>        cpuhp_thread_fun+0x95/0x1e0
>        smpboot_thread_fn+0x17e/0x280
>        kthread+0x10c/0x140
>        ret_from_fork+0x16b/0x310
>        ret_from_fork_asm+0x1a/0x30
> 
> -> #1 (cpu_hotplug_lock){++++}-{0:0}:
>        cpus_read_lock+0x3b/0xd0
>        __cpuhp_state_add_instance+0x19/0x40
>        iova_domain_init_rcaches+0x1ef/0x230
>        iommu_setup_dma_ops+0x18a/0x560
>        iommu_device_register+0x188/0x220
>        intel_iommu_init+0x35a/0x440
>        pci_iommu_init+0x16/0x40
>        do_one_initcall+0xf5/0x400
>        do_initcall_level+0x82/0xa0
>        do_initcalls+0x59/0xa0
>        kernel_init_freeable+0x152/0x1d0
>        kernel_init+0x1a/0x130
>        ret_from_fork+0x16b/0x310
>        ret_from_fork_asm+0x1a/0x30
> 
> -> #0 (&group->mutex){+.+.}-{4:4}:
>        __lock_acquire+0x14c8/0x2750
>        lock_acquire+0xd3/0x2c0
>        __mutex_lock+0x8c/0xd80
>        pci_dev_reset_iommu_prepare+0x6e/0x200
>        pcie_flr+0x32/0xc0
>        __pci_reset_function_locked+0x84/0x120
>        vfio_pci_core_try_reset+0xa4/0x110
>        vfio_pci_liveupdate_freeze+0x8a/0x100
>        luo_file_freeze+0xd1/0x290
>        luo_session_serialize+0xa6/0x240
>        liveupdate_reboot+0x19/0x30
>        kernel_kexec+0x39/0xb0
>        __se_sys_reboot+0xfd/0x210
>        do_syscall_64+0x15f/0x4e0
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &group->mutex --> &mm->mmap_lock --> &vdev->memory_lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&vdev->memory_lock);
>                                lock(&mm->mmap_lock);
>                                lock(&vdev->memory_lock);
>   lock(&group->mutex);
> 
>  *** DEADLOCK ***
> 
> 9 locks held by kexec/13355:
>  #0: ffffffff85a81270 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0xe4/0x210
>  #1: ffffffff85e1cfa8 (luo_session_serialize_rwsem){++++}-{4:4}, at: luo_session_serialize+0x30/0x240
>  #2: ffffffff85e1d140 (luo_session_global.outgoing.rwsem){+.+.}-{4:4}, at: luo_session_serialize+0x43/0x240
>  #3: ff3f082dee702108 (&session->mutex){+.+.}-{4:4}, at: luo_session_serialize+0x99/0x240
>  #4: ff3f082db51c2588 (&luo_file->mutex){+.+.}-{4:4}, at: luo_file_freeze+0x81/0x290
>  #5: ff3f082d8af761a8 (&new_dev_set->lock){+.+.}-{4:4}, at: vfio_pci_liveupdate_freeze+0x38/0x100
>  #6: ff3f082de7f39780 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_liveupdate_freeze+0x49/0x100
>  #7: ff3f082de7f399a8 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_liveupdate_freeze+0x58/0x100
>  #8: ff3f086c908911f8 (&dev->mutex){....}-{4:4}, at: pci_dev_trylock+0x25/0x60
> 
> stack backtrace:
> CPU: 132 UID: 0 PID: 13355 Comm: kexec Tainted: G S                  7.2.0-dbg-DEV #3 PREEMPTLAZY
> Tainted: [S]=CPU_OUT_OF_SPEC
> Hardware name: Google Izumi/izumi, BIOS 0.20260327.0-0 03/27/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x54/0x70
>  print_circular_bug+0x2e1/0x300
>  check_noncircular+0xf9/0x120
>  ? __bfs+0x129/0x200
>  __lock_acquire+0x14c8/0x2750
>  ? __lock_acquire+0x1223/0x2750
>  ? check_noncircular+0xa5/0x120
>  ? pci_dev_reset_iommu_prepare+0x6e/0x200
>  lock_acquire+0xd3/0x2c0
>  ? pci_dev_reset_iommu_prepare+0x6e/0x200
>  ? lock_is_held_type+0x76/0x100
>  ? pci_dev_reset_iommu_prepare+0x6e/0x200
>  __mutex_lock+0x8c/0xd80
>  ? pci_dev_reset_iommu_prepare+0x6e/0x200
>  ? lockdep_hardirqs_on_prepare+0x152/0x220
>  ? _raw_spin_unlock_irqrestore+0x35/0x50
>  pci_dev_reset_iommu_prepare+0x6e/0x200
>  pcie_flr+0x32/0xc0
>  __pci_reset_function_locked+0x84/0x120
>  vfio_pci_core_try_reset+0xa4/0x110
>  vfio_pci_liveupdate_freeze+0x8a/0x100
>  luo_file_freeze+0xd1/0x290
>  luo_session_serialize+0xa6/0x240
>  liveupdate_reboot+0x19/0x30
>  kernel_kexec+0x39/0xb0
>  __se_sys_reboot+0xfd/0x210
>  ? check_object+0x1e8/0x390
>  ? init_object+0x34/0x110
>  ? lock_release+0xf0/0x330
>  ? kmem_cache_free+0x1b5/0x520
>  ? kmem_cache_free+0x1c9/0x520
>  ? _raw_spin_unlock_irqrestore+0x35/0x50
>  ? kmem_cache_free+0x1b5/0x520
>  ? __x64_sys_close+0x3d/0x80
>  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  do_syscall_64+0x15f/0x4e0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f04e7233313
> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 89 fa b8 a9 00 00 00 bf ad de e1 fe be 69 19 12 28 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 f7 d8 48 8b 0d eb fb 06 00 64 89 01 48
> RSP: 002b:00007ffe7c91b688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a9
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f04e7233313
> RDX: 0000000045584543 RSI: 0000000028121969 RDI: 00000000fee1dead
> RBP: 00007ffe7c91b9b0 R08: 000000000000000a R09: 00007f04e72a4ff0
> R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000002
>  </TASK>
> 

This lock chain is slightly different than what David reported in his
email on v4.

Current dependency chain for v5:
  -> #5 (&vdev->memory_lock){++++}-{4:4}:
  -> #4 (&mm->mmap_lock){++++}-{4:4}:
  -> #3 (&cpuctx_mutex){+.+.}-{4:4}:       // Different
  -> #2 (cpuhp_state-up){+.+.}-{0:0}:      // Different
  -> #1 (cpu_hotplug_lock){++++}-{0:0}:
  -> #0 (&group->mutex){+.+.}-{4:4}:

David's dependency chain on v4:
  -> #4 (&vdev->memory_lock){++++}-{4:4}:
  -> #3 (&mm->mmap_lock){++++}-{4:4}:
  -> #2 (&type->i_mutex_dir_key#4){++++}-{4:4}:    // Different
  -> #1 (cpu_hotplug_lock){++++}-{0:0}:
  -> #0 (&group->mutex){+.+.}-{4:4}:

This seems like &group->mutex connects to cpu_hotplug_lock during boot,
and cpu_hotplug_lock can connect to &mm->mmap_lock through any 
subsystems like Perf, VFS, etc.

One thing to note, VFIO has an existing ioctl VFIO_DEVICE_RESET which
calls vfio_pci_ioctl_reset() and locks are taken in the same order in
that function:

Lock vdev->memory_lock
 -> pci_try_reset_function()
    -> pcie_flr()
       -> pci_dev_reset_iommu_prepare()
          -> Try to lock iommu_group->mutex

pci_dev_reset_iommu_prepare() is added in pcie_flr() in the commit
f5b16b802174 ("PCI: Suspend iommu function prior to resetting a
device"). So, this is relatively a new change and may have not been
caught yet.

This is similar to what vfio_pci_liveupdate_freeze() is also doing
regarding locks and reset.

I am not 100% this is an actual issue considering group->mutex to
cpu_hotplug_lock dependency happens early in boot.

If this is an issue which must be fixed, I think we would have to makea
flow like:
  1. lock vdev->memory_lock
  2. Disable memory in PCI_COMMAND.
  3. Unlock vdev->memory_lock
  4. Do PCI reset
  5. Lock vdev->memory_lock and resume as old flow.

I wrote a test code (with assistance from GEMINI) to trigger lockdep
warning in 7.2-rc1 kernel commit without any liveupdate patches and I
can reproduce issue on a host having Intel DSA device (8086:0b25). This
program mmaps a BAR of a VFIO device and reads it, after that it
resets the device.

Expected: Program exits cleanly, without any lockdep warning.
Actual: Lockdep warning is printed similar to above.

--------------------------------------
/*
 * vfio_cdev_lockdep_reproducer.c
 *
 * Standalone reproducer using modern VFIO cdev (/dev/vfio/devices/vfioX)
 * and IOMMUFD (/dev/iommu) interfaces to trigger Lockdep circular locking
 * dependency between &vdev->memory_lock and &group->mutex on ATS PCI devices.
 *
 * Requirements:
 *   - Kernel booted with CONFIG_PROVE_LOCKING=y (Lockdep enabled)
 *   - An ATS-capable PCIe device bound to vfio-pci (e.g., Intel DSA / idxd)
 *
 * Build:
 *   gcc -Wall -static vfio_cdev_lockdep_reproducer.c -o vfio_cdev_lockdep_reproducer
 *
 * Usage:
 *   sudo ./vfio_cdev_lockdep_reproducer <pci_bdf>
 *   Example: sudo ./vfio_cdev_lockdep_reproducer 0000:6a:01.0
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/vfio.h>
#include <linux/iommufd.h>

static int find_vfio_cdev_path(const char *bdf, char *cdev_path, size_t size)
{
	struct dirent *entry;
	char dir_path[256];
	DIR *dir;

	snprintf(dir_path, sizeof(dir_path),
		 "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
	dir = opendir(dir_path);
	if (!dir) {
		fprintf(stderr, "[-] Failed to open %s (is %s bound?)\n",
			dir_path, bdf);
		return -1;
	}

	while ((entry = readdir(dir)) != NULL) {
		if (strncmp("vfio", entry->d_name, 4) == 0) {
			snprintf(cdev_path, size, "/dev/vfio/devices/%s",
				 entry->d_name);
			closedir(dir);
			return 0;
		}
	}

	closedir(dir);
	return -1;
}

static int setup_vfio_cdev(const char *bdf, int *out_iommufd,
			   int *out_device_fd)
{
	struct vfio_device_attach_iommufd_pt attach_args;
	struct vfio_device_bind_iommufd bind_args;
	struct iommu_ioas_alloc ioas_args;
	char cdev_path[4096];
	int iommufd;
	int device_fd;
	uint32_t ioas_id;
	int ret;

	ret = find_vfio_cdev_path(bdf, cdev_path, sizeof(cdev_path));
	if (ret < 0) {
		fprintf(stderr, "[-] Could not find cdev path for %s\n", bdf);
		return -1;
	}

	printf("[*] Found VFIO cdev node: %s\n", cdev_path);

	printf("[*] Opening /dev/iommu (IOMMUFD)...\n");
	iommufd = open("/dev/iommu", O_RDWR);
	if (iommufd < 0) {
		perror("open(/dev/iommu)");
		return -1;
	}

	memset(&ioas_args, 0, sizeof(ioas_args));
	ioas_args.size = sizeof(ioas_args);

	if (ioctl(iommufd, IOMMU_IOAS_ALLOC, &ioas_args) < 0) {
		perror("IOMMU_IOAS_ALLOC");
		close(iommufd);
		return -1;
	}
	ioas_id = ioas_args.out_ioas_id;
	printf("[+] Allocated IOMMUFD IOAS ID = %u\n", ioas_id);

	printf("[*] Opening VFIO cdev device %s...\n", cdev_path);
	device_fd = open(cdev_path, O_RDWR);
	if (device_fd < 0) {
		perror("open(cdev_path)");
		close(iommufd);
		return -1;
	}

	memset(&bind_args, 0, sizeof(bind_args));
	bind_args.argsz = sizeof(bind_args);
	bind_args.flags = 0;
	bind_args.iommufd = iommufd;

	if (ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args) < 0) {
		perror("VFIO_DEVICE_BIND_IOMMUFD");
		close(device_fd);
		close(iommufd);
		return -1;
	}
	printf("[+] Bound VFIO device to IOMMUFD (devid = %u)\n",
	       bind_args.out_devid);

	memset(&attach_args, 0, sizeof(attach_args));
	attach_args.argsz = sizeof(attach_args);
	attach_args.flags = 0;
	attach_args.pt_id = ioas_id;

	if (ioctl(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_args) < 0) {
		perror("VFIO_DEVICE_ATTACH_IOMMUFD_PT");
		close(device_fd);
		close(iommufd);
		return -1;
	}
	printf("[+] Attached VFIO device to IOAS ID %u\n", ioas_id);

	*out_iommufd = iommufd;
	*out_device_fd = device_fd;
	return 0;
}

static void exercise_bar_fault(int device_fd)
{
	struct vfio_region_info reg;
	volatile unsigned char dummy;
	bool bar_mmapped;
	void *map;
	int i;

	bar_mmapped = false;

	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; i++) {
		memset(&reg, 0, sizeof(reg));
		reg.argsz = sizeof(reg);
		reg.index = i;

		if (ioctl(device_fd, VFIO_DEVICE_GET_REGION_INFO, &reg) < 0)
			continue;

		if (!(reg.flags & VFIO_REGION_INFO_FLAG_MMAP) || reg.size == 0)
			continue;

		printf("[*] Found BAR%d (0x%llx). mmap()ing...\n",
		       i, (unsigned long long)reg.size);

		map = mmap(NULL, reg.size, PROT_READ | PROT_WRITE,
			   MAP_SHARED, device_fd, reg.offset);
		if (map == MAP_FAILED)
			continue;

		printf("[*] Touching BAR%d to trigger fault...\n", i);
		dummy = *((volatile unsigned char *)map);
		(void)dummy;
		bar_mmapped = true;
		break;
	}

	if (!bar_mmapped) {
		printf("[!] No mmapable BAR found on this device.\n");
		printf("[!] For QEMU, try: -device nvme,serial=1,ats=on\n");
	}
}

int main(int argc, char **argv)
{
	const char *pci_bdf;
	int device_fd;
	int iommufd;
	int ret;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <pci_bdf>\n", argv[0]);
		fprintf(stderr, "Example: %s 0000:6a:01.0\n", argv[0]);
		return EXIT_FAILURE;
	}

	pci_bdf = argv[1];

	ret = setup_vfio_cdev(pci_bdf, &iommufd, &device_fd);
	if (ret < 0)
		return EXIT_FAILURE;

	/*
	 * Step 1: Exercise Page Fault path (mmap_lock -> memory_lock).
	 * Scan BAR0 to BAR5 and mmap the first region supporting mmap().
	 * Touching 1 byte causes page fault via vfio_pci_mmap_huge_fault(),
	 * taking down_read(&vdev->memory_lock).
	 */
	exercise_bar_fault(device_fd);

	/*
	 * Step 2: Trigger VFIO_DEVICE_RESET ioctl.
	 * Takes down_write(&vdev->memory_lock) -> pci_try_reset_function() ->
	 * pci_dev_reset_iommu_prepare(), taking guard(mutex)(&group->mutex).
	 *
	 * Lockdep detects the circular dependency and reports WARNING.
	 */
	printf("[*] Issuing VFIO_DEVICE_RESET ioctl under memory_lock...\n");
	if (ioctl(device_fd, VFIO_DEVICE_RESET) < 0) {
		perror("VFIO_DEVICE_RESET");
	} else {
		printf("[+] VFIO_DEVICE_RESET completed successfully.\n");
	}

	printf("[*] Check 'dmesg' for Lockdep circular dependency report!\n");

	close(device_fd);
	close(iommufd);
	return EXIT_SUCCESS;
}
--------------------------------------

