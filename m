Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7340AC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E2E6B007B; Tue, 21 Jul 2026 19:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9656B008A; Tue, 21 Jul 2026 19:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2976B008C; Tue, 21 Jul 2026 19:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE206B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:16:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13FD2120306
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:16:36 +0000 (UTC)
X-FDA: 85014345192.28.072281B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 47DCD80003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:16:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=crzWEJUS;
	spf=pass (imf30.hostedemail.com: domain of jrhilke@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784675794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTeUMJ8fGG4D2+fB7l4SqWT2YEzPSI0An+cEWlkWt3c=;
	b=PuNqq83spuoK2t5DXra0CDzpqTVgtyS1k3NziYdznczZhg/TQDObaIglEscAfBOP5+xUgG
	rkviWxCBxppLNE73evyMWHTbf65u8jq+KtaMC+fWa1yqQwHzd9LCAta63R6+7ZrNdodDwQ
	YRy+hOpq0P4QiLbnEUrMONQRMnliGps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784675794;
	b=gNiBCcid224/hVenJCTMgr3fOm0MkjUpFp4p9PcIHtcH1Ioj0wc2BWYJ7wNiukMmpKkeRr
	sSUiDIoiJ3KIK4hPr5XgzIFQbpvH6afjoBRwc7hOdHsykXzGKNYcU/6I2KSy15Ecjs1M8F
	9JQRrVuQw2oIMLPch6dt56M7ob8l2HA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=crzWEJUS;
	spf=pass (imf30.hostedemail.com: domain of jrhilke@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ccdf36f63dso605645ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675793; x=1785280593; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YTeUMJ8fGG4D2+fB7l4SqWT2YEzPSI0An+cEWlkWt3c=;
        b=crzWEJUSHcxcCKc8MKVw9/OaqZ1dKLv1SAOe3fxybg+Ytt+Us6WA5rArNLvnMYTeXr
         AlGA/2OhmwWJdkkEHek5yRAeKoKWL1mRPK0BPRgN2OZbMtknzJm44X4KBCAIRg+aTvPM
         3vFNJTuHXEqkRWqDjtymV4Ve+9nu9OAfuBgQkNARexaPvtcTXe3LanQZnvwEboUAvvbZ
         vTYOshtzIg4YPSR8IWqAYp8uhVCEN4G3/UWBdxOx8/ECmHrHsq2NLgWxdPrINk7aRpFp
         7FW9UKXjpaM4JPiI9H1HVG9SbaRZFsrolqVqa2gRGOzzz1M5siVtk71xTA/f7tIe3MwY
         c+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675793; x=1785280593;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YTeUMJ8fGG4D2+fB7l4SqWT2YEzPSI0An+cEWlkWt3c=;
        b=IRqtpYF0Va5CGvgNVNdJN8aqKMWuxVYNG7CNurO2W38wARppKVOqTKzEHWxYVzE1v6
         R+/UbKJaUBL+o0UUUZtQHe7fdcc5H9flqx4/rBVdgUc4DDHU3r3pLir1cCPDZP29r4OI
         3gDUo6sVRVaMRNeIJcUapnpufXVUexJYBzWFA3JS2pShFYrpD4GCTB0TcDSgYCPUln3P
         eQUQ2L0Yi+81PGTboqL8gWGmwnN4wlGQ4mzYGlILBgQfiW/dAXIAYcs9LqYsdmxjJOpy
         wwkafBNAGHcRLqxLW7uBadU0DjnhGrPJNfpZbz7Q9LO/BehTHhR4YUkP6pfaQHmpx42T
         OVYQ==
X-Forwarded-Encrypted: i=1; AHgh+RpcwneJOum9Lf9akiD+Y0NzPqkH4KNCOwK0s13WRKwyFt34XjA5DnNolDnv6jOHhF42n75V/mlHAw==@kvack.org
X-Gm-Message-State: AOJu0YxtV5zFot1pRi9KUegIZNQcTWCA3cl8Vd0O+IYZustM7YxPVUfV
	GlZGYOGoRrzR15Xc7qmaFWWos7CC19OfJUDN6EWY2T9L5I8ts256idr29csl/gEZ
X-Gm-Gg: AR+sD10/kn0oWN72FfE7EycQl7iwMGXswPQLnpWjmeMMVIHrdX+/SY7QC1uukgoZ7Og
	nGdznHRsX+3LxuppwP+LqO82z7TFZ024Zq2+JfndW7hJhyEJ4mw3F0L35JRnMHENzQsk4HtYaqI
	W2youpQtzejRrcgTR2QJ+0oBlvPkDQFAw5cCSVfZK+M3D2wP2TntP1lpKIfHhpO49oVt+MHZ0em
	EIHB5HDA0zGeMiMysxXO6khpdHYiHu+uTfNDY4VDm6+EZr+x3ZmoWJ0UFzC+IoXCoSXqlah/dLj
	U0/hsq373Vp2wIKwnUZiCiu2VRtUvJvp/a5uIZtZHtLhSh/LQfd50oW3BnWP2Ga1ZEKlw+yo3eV
	Sg1OghKRhiKLer/ypEMDCq7ulNEiP8cftEwM++97m9vXGMokij15vxsdrM8j1gA2jweA6KrXItn
	7wERdUZco7QLsfJ0N63qE9++pA01ES/XN6
X-Received: by 2002:a17:903:166e:b0:2ca:be81:b469 with SMTP id d9443c01a7336-2cf8f0f6fc8mr1987375ad.0.1784675792455;
        Tue, 21 Jul 2026 16:16:32 -0700 (PDT)
Received: from google.com (66.68.82.34.bc.googleusercontent.com. [34.82.68.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efae5aesm4141155ad.15.2026.07.21.16.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:16:30 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:16:25 +0000
From: Josh Hilke <jrhilke@google.com>
To: Vipin Sharma <vipinsh@google.com>
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
Message-ID: <al_8v_I9Z2Dc_qjc@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-7-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714151505.3466855-7-vipinsh@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47DCD80003
X-Stat-Signature: 5frjimbjtc814k91nazbwirjuw8is7yd
X-Rspam-User: 
X-HE-Tag: 1784675794-80386
X-HE-Meta: U2FsdGVkX1+MwjWkQ/8UCt5+Bk9/TBP0jODa3raW4x1N+03dedVrShGqoIgr8NBfNQRhDTGbJj+XWx/49fLazKi/UkQN2+n/6j7LXj6U47xiwe3jBp8QyDTNenLWpOHNF3htRlSjhRKuSgWd68Mo6dAYyB61LzevW/B93QttklwDry9E2TkvbpYm+GVX3wk8FHWVnODEJnhgDL4tTieD+i671E1KBwQO78i6nXmdxQ8WMnbVPKZf4YrtUc3HqR4dBuO9nugAQ3/b0/O48TFxkOP8WEemAzRreJUuVzs4oG88rJXeX9TNEh++Y1oT/3EzBvCNZ+wBxi02SfSSM3gyNuktU2FtApvTCfzeDxzVAFTv+ObmSNwraim5Edx8UlALL9CgX/UQQnVz+ychAY72XSDGEdxQpd7Jfxzae2GZtJ8s3AtxrvqGZtDLFmZBHALzBv8SSx6bqEHoehap+22cPznK4GqijqvEk4JMSnREpbeI0ypHyx3Arh4/ISNKqyWWD4kk70dkwEMn5DfYk0szVuobFS3CU4XwJ3yLakyzUZIAkSbRXpUseRZrEX7AOHPpu4ELGOOKReb/434yWYTT1uyZNkfCrJ0pC76VnGG5C1T/Mmbp81bmPW1QLPo9Ujjd2LxeAezIkAKprGF6DXY/vZqtrjMhzX+08sy7vAjNZPo/KitE92SuJMmwO5NlC5kl3jQp1rpvE/oG9hKOWpNrJPcru887XsqIW6W+YNGvIIf204f5bUi6fN9+/P4KctPmibmJQX3E8T9465JCqw7dN7+Un/bGr7y6tLaB2K6r/93Z6078kSV/KHaryxVr14NPYdWeAo4lPa4J40ewO9KeqLBBkQROMr3ZUE1rbu44JBVtVUEWieT2ugEF1JBAmJZeDWp0sVzwm+YGDY/b4t7CzuTW8N+XLRQU4/ljIuLgDLXGSAtn0hDqo3K9bq4/USeHi9oOWVoLTjhvgKDtRsR
 YQVtqEKg
 z6rw/swlsay38TJumJjS09ckSIfwP2UDfnbHrgx6y5trYmlp1Z7rzCZ05pNFa3CzeN7s3g6hxXUjm3pczlXnXQLikngMfURVKO74LLxlbh/BjRYcqK3EyzfCwxYV4A5h/xdnYGZpZBh5MgklFe3ID6w5sFopu/oJKOOE4q1MJYg27ORHMEhCBjZ76/7r192tX76Xpt1nANT7HfJ695/etV75SRCd9HXvNA9lPiN+xdEBPX//EzMprGc6ImQROYF1Zn3FYRpYYrrAA9ce9Vu8bR77c6LzJaUFr9Sb4LjAfOFEG/h35K1Qh/zunrRxAUqsXgibMUP+eTt2/OvBD8s/GqYvwaqjiIDmYJej4E6LMGJkuxU8cPDsU3fLXzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 08:14:51AM -0700, Vipin Sharma wrote:
> +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> +{
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +	struct vfio_pci_core_device *vdev;
> +	struct pci_dev *pdev;
> +
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	pdev = vdev->pdev;
> +
> +	guard(mutex)(&device->dev_set->lock);
> +	guard(mutex)(&vdev->igate);
> +	guard(rwsem_write)(&vdev->memory_lock);
> +
> +	/*
> +	 * Userspace must disable interrupts on the device prior to freeze so
> +	 * that the device does not send any interrupts until new interrupt
> +	 * handlers have been established by the next kernel.
> +	 */
> +	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
> +		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdev->current_state != PCI_D0) {
> +		pci_err(pdev, "Freeze failed! Device not in D0 state.\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Reset is a temporary measure to provide kernel after kexec a clean
> +	 * device while VFIO live update work is under development and not
> +	 * fully supported. It will go away once continuous DMA support is
> +	 * added to device preservation.
> +	 */
> +	vfio_pci_zap_bars(vdev);
> +	vfio_pci_dma_buf_move(vdev, true);
> +	vfio_pci_core_try_reset(vdev);
> +	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
> +	/*
> +	 * Userspace cannot use the FD correctly now irrespective of liveupdate
> +	 * freeze failing or succeeding. They will have to reinitialize the VFIO
> +	 * device to continue using it as reset might have loaded default PCI
> +	 * state. Disable ioctl, read, write and mmap access to the device.
> +	 */
> +	smp_store_release(&vdev->liveupdate_frozen, true);
> +	return 0;
>  }

I'm seeing the same lockdep splat the David found in v4.
https://lore.kernel.org/all/ag-aFA1BJxdJMywr@google.com/#t

======================================================
WARNING: possible circular locking dependency detected
7.2.0-dbg-DEV #3 Tainted: G S
------------------------------------------------------
kexec/13355 is trying to acquire lock:
ff3f086c95315d08 (&group->mutex){+.+.}-{4:4}, at: pci_dev_reset_iommu_prepare+0x6e/0x200

but task is already holding lock:
ff3f082de7f399a8 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_liveupdate_freeze+0x58/0x100

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&vdev->memory_lock){++++}-{4:4}:
       down_read+0x3d/0x160
       vfio_pci_mmap_huge_fault+0xb9/0x150
       __do_fault+0x46/0x150
       do_pte_missing+0x21a/0x1000
       handle_mm_fault+0x7f8/0xb60
       do_user_addr_fault+0x476/0x6c0
       exc_page_fault+0x68/0xa0
       asm_exc_page_fault+0x26/0x30

-> #4 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0x5e/0x80
       _copy_to_user+0x23/0x60
       perf_read+0x114/0x310
       vfs_read+0xe7/0x360
       ksys_read+0x73/0x100
       do_syscall_64+0x15f/0x4e0
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&cpuctx_mutex){+.+.}-{4:4}:
       __mutex_lock+0x8c/0xd80
       perf_event_ctx_lock_nested+0x15a/0x210
       perf_event_enable+0x18/0xa0
       lockup_detector_online_cpu+0x22/0x30
       cpuhp_invoke_callback+0xfb/0x2c0
       cpuhp_thread_fun+0x164/0x1e0
       smpboot_thread_fn+0x17e/0x280
       kthread+0x10c/0x140
       ret_from_fork+0x16b/0x310
       ret_from_fork_asm+0x1a/0x30

-> #2 (cpuhp_state-up){+.+.}-{0:0}:
       cpuhp_thread_fun+0x95/0x1e0
       smpboot_thread_fn+0x17e/0x280
       kthread+0x10c/0x140
       ret_from_fork+0x16b/0x310
       ret_from_fork_asm+0x1a/0x30

-> #1 (cpu_hotplug_lock){++++}-{0:0}:
       cpus_read_lock+0x3b/0xd0
       __cpuhp_state_add_instance+0x19/0x40
       iova_domain_init_rcaches+0x1ef/0x230
       iommu_setup_dma_ops+0x18a/0x560
       iommu_device_register+0x188/0x220
       intel_iommu_init+0x35a/0x440
       pci_iommu_init+0x16/0x40
       do_one_initcall+0xf5/0x400
       do_initcall_level+0x82/0xa0
       do_initcalls+0x59/0xa0
       kernel_init_freeable+0x152/0x1d0
       kernel_init+0x1a/0x130
       ret_from_fork+0x16b/0x310
       ret_from_fork_asm+0x1a/0x30

-> #0 (&group->mutex){+.+.}-{4:4}:
       __lock_acquire+0x14c8/0x2750
       lock_acquire+0xd3/0x2c0
       __mutex_lock+0x8c/0xd80
       pci_dev_reset_iommu_prepare+0x6e/0x200
       pcie_flr+0x32/0xc0
       __pci_reset_function_locked+0x84/0x120
       vfio_pci_core_try_reset+0xa4/0x110
       vfio_pci_liveupdate_freeze+0x8a/0x100
       luo_file_freeze+0xd1/0x290
       luo_session_serialize+0xa6/0x240
       liveupdate_reboot+0x19/0x30
       kernel_kexec+0x39/0xb0
       __se_sys_reboot+0xfd/0x210
       do_syscall_64+0x15f/0x4e0
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &group->mutex --> &mm->mmap_lock --> &vdev->memory_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&vdev->memory_lock);
                               lock(&mm->mmap_lock);
                               lock(&vdev->memory_lock);
  lock(&group->mutex);

 *** DEADLOCK ***

9 locks held by kexec/13355:
 #0: ffffffff85a81270 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0xe4/0x210
 #1: ffffffff85e1cfa8 (luo_session_serialize_rwsem){++++}-{4:4}, at: luo_session_serialize+0x30/0x240
 #2: ffffffff85e1d140 (luo_session_global.outgoing.rwsem){+.+.}-{4:4}, at: luo_session_serialize+0x43/0x240
 #3: ff3f082dee702108 (&session->mutex){+.+.}-{4:4}, at: luo_session_serialize+0x99/0x240
 #4: ff3f082db51c2588 (&luo_file->mutex){+.+.}-{4:4}, at: luo_file_freeze+0x81/0x290
 #5: ff3f082d8af761a8 (&new_dev_set->lock){+.+.}-{4:4}, at: vfio_pci_liveupdate_freeze+0x38/0x100
 #6: ff3f082de7f39780 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_liveupdate_freeze+0x49/0x100
 #7: ff3f082de7f399a8 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_liveupdate_freeze+0x58/0x100
 #8: ff3f086c908911f8 (&dev->mutex){....}-{4:4}, at: pci_dev_trylock+0x25/0x60

stack backtrace:
CPU: 132 UID: 0 PID: 13355 Comm: kexec Tainted: G S                  7.2.0-dbg-DEV #3 PREEMPTLAZY
Tainted: [S]=CPU_OUT_OF_SPEC
Hardware name: Google Izumi/izumi, BIOS 0.20260327.0-0 03/27/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0x54/0x70
 print_circular_bug+0x2e1/0x300
 check_noncircular+0xf9/0x120
 ? __bfs+0x129/0x200
 __lock_acquire+0x14c8/0x2750
 ? __lock_acquire+0x1223/0x2750
 ? check_noncircular+0xa5/0x120
 ? pci_dev_reset_iommu_prepare+0x6e/0x200
 lock_acquire+0xd3/0x2c0
 ? pci_dev_reset_iommu_prepare+0x6e/0x200
 ? lock_is_held_type+0x76/0x100
 ? pci_dev_reset_iommu_prepare+0x6e/0x200
 __mutex_lock+0x8c/0xd80
 ? pci_dev_reset_iommu_prepare+0x6e/0x200
 ? lockdep_hardirqs_on_prepare+0x152/0x220
 ? _raw_spin_unlock_irqrestore+0x35/0x50
 pci_dev_reset_iommu_prepare+0x6e/0x200
 pcie_flr+0x32/0xc0
 __pci_reset_function_locked+0x84/0x120
 vfio_pci_core_try_reset+0xa4/0x110
 vfio_pci_liveupdate_freeze+0x8a/0x100
 luo_file_freeze+0xd1/0x290
 luo_session_serialize+0xa6/0x240
 liveupdate_reboot+0x19/0x30
 kernel_kexec+0x39/0xb0
 __se_sys_reboot+0xfd/0x210
 ? check_object+0x1e8/0x390
 ? init_object+0x34/0x110
 ? lock_release+0xf0/0x330
 ? kmem_cache_free+0x1b5/0x520
 ? kmem_cache_free+0x1c9/0x520
 ? _raw_spin_unlock_irqrestore+0x35/0x50
 ? kmem_cache_free+0x1b5/0x520
 ? __x64_sys_close+0x3d/0x80
 ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
 ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
 do_syscall_64+0x15f/0x4e0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f04e7233313
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 89 fa b8 a9 00 00 00 bf ad de e1 fe be 69 19 12 28 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 f7 d8 48 8b 0d eb fb 06 00 64 89 01 48
RSP: 002b:00007ffe7c91b688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a9
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f04e7233313
RDX: 0000000045584543 RSI: 0000000028121969 RDI: 00000000fee1dead
RBP: 00007ffe7c91b9b0 R08: 000000000000000a R09: 00007f04e72a4ff0
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000002
 </TASK>


