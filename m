Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3AE606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d3AqveNb
Received: by kanga.kvack.org (Postfix)
	id EC6A86B05B6; Tue, 17 Nov 2026 16:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76446B05B7; Tue, 17 Nov 2026 16:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65456B05C3; Tue, 17 Nov 2026 16:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A86276B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:59:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DA61A820D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:59:08 +0000 (UTC)
X-FDA: 85445977176.05.A5564AD
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4E4E64000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:59:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=d3AqveNb;
	spf=pass (imf07.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ppas4HZ2NGOZcFcrTWA/+6VjpboNZmJZl+VQIcgy64=;
	b=tjQfdPFqr8wvZQSPKxEdSBa7WK8Hv8COEehE6f0toYs9ikTMD5psi9wthdGmnhkmHpsTWd
	g1R30iSWajZ1/7qZuBrhMDtUnk4+q1mKxuy3ENb+TbSttGhBYnmsadZ+vlmsJLGI0ZugcS
	xsAwNBCSEjWweK06ZeAgok/VQK5e2Gc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794952746;
	b=1gzYaPjKUzGzxJK3MK0mTVrKE2To6bw1YORyRAr6gN96wLXQ0MRawQ4pmva4I/8fnwRicO
	f3KtF8l8uPGgQVD1JFKxGcXnq1xK7PHfo1FZ18jsPJ1GTNJJQ7dEUbF3+xmJBjq79m5y8J
	DfukttFjtMjA/X/NxqqkplLD2XAcDTI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=d3AqveNb;
	spf=pass (imf07.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed3f563739so21475ad.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794952745; x=1795557545; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6ppas4HZ2NGOZcFcrTWA/+6VjpboNZmJZl+VQIcgy64=;
        b=d3AqveNbR/fJt59DdyYnOLYHC5FIaWIA+xlWfZm57ThHy+cuWdl4+naCEetTigm3uu
         TGAoicwg6LhFTqSUFZrw/yL3vAG+6RM8vd2wP2aNaiQSoxuEQ4RvJJ/vpUEhXNiodql8
         lVwP9L5MFj4DBNQkQAB5VE6drYxf8WJoPf71wPscp6FcwmVnKdDgKV9ZNvJmcmebesMy
         kIMEDA5i60JQwsDE/XzX5Uqgji2k0jSd9nfIk+FXDqrKt1Fg4sbuvyTJUvM7XTt7EJrL
         Sx5amsDEIHUhb94TMRdeSyICOa/O3/k6R0f6jHYpqCbtF5smhuKWYns1IK3u9aBII1Nt
         lr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794952745; x=1795557545;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ppas4HZ2NGOZcFcrTWA/+6VjpboNZmJZl+VQIcgy64=;
        b=soNp1RxBpOFzANc6muZFGoHN1rEUpkGZEK+vXXPZwe/u3A7tzG5hU7/2D9Nb3c8COU
         YcXbOT6xwEiWnkKf/xBQnuOcSZclmc/lqC1hc0AxSrn0Q9h6NciOoxQkC5c2RUjEyJzh
         fTn+Olto7tCA5D9UWkcpvcbBHgma0zQj7pcXiQ8N71uDO7uNDhA7oTZZDuXZmDBv4b1Y
         6cYJn1fLCaaZiKoz/x7W0lY0gmZwDk0Vv1N68KTHDS3X6w01QIa44L/+k8xG5IjGHgyW
         DasPQA9GiQaqVg3BdJ0HU7jMw2FIjJwMbuMdlazrCVjscVFwfAKBd8ROqusQhEePPRGl
         JgKA==
X-Forwarded-Encrypted: i=1; AL+hErFfPYIUefFEaAuoaAp3HqFzXojZXNl9JliDEZVU7hEat0rkUK7tcaBlmTqHpW0uNHUBUAAowGpMjg==@kvack.org
X-Gm-Message-State: APuU4Z+no65GoGNx0PyZCIUlnDLDkByBx9dblq8G5A8YMLPoTgwb38Bd
	S5rTtBwaZcpNgxLccQaKuhBFuQaKHdYrax1VR93W9dbHYeP+u4T+1e3EevrKKcBAbA==
X-Gm-Gg: AZFdTZeZqvHzkPsid2iZN/80ePQfn2FDDC+N3fvmnfxZixodaKy4qccC3fWZvdeTqNQ
	ir+u66jLyx+k+n1fdsf8IN3SdhCim/1zlirmKqfomOwGZP/ZiyGytnVIPG2LrfbGgJGxLTwcSma
	dcA9DKIFT+S4XOr9YZPy9csspE+uSvQxPSbgHex4bT2hsICJJJHEaVPY9Df4ck+D0vmEuJ/SNSA
	DSkCS305DX9I6/XKvtyvFq7tV6P5lHkA4CG1lAL2z+QqlpVMrQjlQQfy6PrtfZp96CbMTyqMNyY
	2Li8oIYSY8tGVyR2ZklH3m14fnOox11aLZ5GBBLD8UQiF/Xt83jyM/r5Rw5+Al9kGvKzNLWfJr/
	LeHWpnu1BVy+3hnivrQuWJDQPWKHHIgPV50+BINh1rvY6cyM4SO0fGbLimXLmiAn7q6oi3fv3wq
	mgWbHJqQ4gTLaYM/7xwYFzXBrnekT47ftzqbFyvKEMjBeeXo0RnoYMvTpi+SRMQ03Dz1UJBRYGM
	U/3DB72hT+3rfstIMAT+2+WQqkCmEtKnUxL2W9DySdqb6rnGdXHGus+RyPEf5rcwzDongV3hNsa
	lAfFNcJXCi9zMHKClxK8GFvotO5V1iHaqEu4vhCiTH49e7DR9P0AMghzQCcaN9AsbuIWXWNSUuN
	h4oeZujB7A5vp
X-Received: by 2002:a17:903:3d0e:b0:2df:96ca:d7c7 with SMTP id d9443c01a7336-2eff98e2025mr646525ad.10.1794952744396;
        Tue, 17 Nov 2026 13:59:04 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff623c4c6sm2756405ad.54.2026.11.17.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:59:03 -0800 (PST)
Date: Tue, 17 Nov 2026 13:59:00 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, 
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, 
	michal.winiarski@intel.com, parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, 
	pratyush@kernel.org, rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <20261117003405.GA4153658.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
 <auzVEUpFEoWltpVg@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auzVEUpFEoWltpVg@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E4E64000A
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m1679zzhhbb14dxkb99zpfworbuht1rh
X-HE-Tag: 1794952746-923217
X-HE-Meta: U2FsdGVkX1/uB7zNGsJdFIBOJDXeqmhWoWJ5q+NnV4zIxxUkb1MJbCPg+E3YbvN3HKQ+uyyHewCyX/z4LjWcqW3d591PYVp+D8tHdHhmxQkcbZmRQ1v4fJ7DyqfCHe8yvVLq2DSBh8oGOW2842Aqu/FMqpJy6oRF0GgmK853WBX7YKWjMRFsQPNlCV5IiopMWawX5u/VMsjFG2jT45ivgmG3kfuMghcPhcVNOLRv/1npvDwr7fMr+rwldxjmKBLz5nRzSp8GTCSFVXlWmv6mhOH3tmDPuuPMl5LMowAivOVs1DWPxg+TC8TZAWyZPDwANCQzadHrE4J3dMTB0sdvkDZFFI78+bF1Q3gEkVKV0LdcA9U5bunt8gPLcBhc2uVyfxWjthUvEaWWiDjfU+h2LuKf7tcFS6gUMIUn4ZbBrzN9dmunAUWoOvfgY8Ymn+G3rij7+np4nHwiGTwV6QfG1ceyqHczPvBdQJfEgwlsTCcSDnyZ+JQUVU8N6fPOlO+2MiXBSB50aKsxBouz9kGB6jdF7zkBgauYRiorY25eBzx8mkNP6mzhvNojVO4tOOBkWsVVUeflNlEfNKu6cQcrlVkLkHNLFYsVkpoHipauKIoPuwrUjGegRxtdCKymumRD/GETh/XfXSYk4o4nyB7hE8TuoRR6Vs99TyJ5LcwWhmoWdyf5zkz+k/syHHJbq09TErQqCLEOmwXo74Zq7+L2jJZTY68fLOx+DbC56lLkwcFjDJDlkqylAKZV8/Xwww846K6jh3ZDMC/qtFYgZ9PppqsIz3FWk9ngiqCr81H6b7E8/7AKkQc++dGakEOe62jcnbrwVHI28roOUYzLMXGsxYeoD7Zv7GXXQqd3KomyZh4Ffl6FNebWSNB51nH/xC0EGoFhoWiwcyTGpaLgmXXuYMRnZHIch535g/Fvi0TpLAfnFrgFDb0R1baA7+hbNcjDZVf+yirsLwMrL2nEQCT
 Yf1rbSH1
 Rmb9c5LKtJ0+Uip3M0vU2OcfCywe38ovI4s7/YnO7KsYZLAdWR7p8+C5C11bBV9RlEE444kiDMBgXG09cp/veI6X3rlP5aQwjXhippzNeGrfZWRB8wbRYvzHqTs3zV7Kt8EluxPY94YMb0ueCCrjbbi3MOh+0kdBniwaEfGD8vg6NqjDxIjY0Ihg4r6HjWKppF5NHQc1s2pzFtn2e+kx18kEmKiKizYommXXTRcOYTm61PgHjiWfmL55LIbdsGMcXw0wPPGxlPSSKR8xcXpPC3vZfRWUuId0cgas7BxC5f+iE2vDhIQ3QLmv7nNcyLk9TpU+nzjE6+K5ASiwob+W4vH4t600SNO4y9NTDXx56YEGzuFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 07:12:17PM +0000, David Matlack wrote:
> On 2026-11-02 07:36 AM, Vipin Sharma wrote:
> >  * TOCTOU synchronization: vfio_pci_dev_is_frozen() is checked locklessly
> >    on entry to the ioctl, read/write and mmap paths, and re-checked under
> >    a lock that freeze() holds before any operation that could change the
> >    device or vconfig: under vdev->igate in vfio_pci_ioctl_set_irqs() and
> >    around every config-space write in vfio_pci_config_rw_single(), under
> >    vdev->memory_lock in vfio_pci_runtime_pm_entry(),
> >    vfio_pci_ioctl_reset() and the SR-IOV enable path of
> >    vfio_pci_core_sriov_configure(), and under dev_set->lock in
> >    vfio_pci_dev_set_hot_reset(). A racing operation thus either completes
> >    before freeze() takes its snapshot or fails, while existing BAR mmaps,
> >    ioeventfds and dma-bufs keep working. Serializing config writes on
> >    igate covers the PCI_COMMAND, INTx disable emulation, power state and
> >    FLR paths at one point (the INTx disable emulation now uses the
> >    igate-held __vfio_pci_intx_mask() and __vfio_pci_intx_unmask()
> >    helpers), and also serializes the irq_type and virq_disabled accesses
> >    of config writes with VFIO_DEVICE_SET_IRQS.
> 
> I think there's a simpler way to do this. Checking the frozen flag
> locklessly and then re-checking it under whichever lock covers each
> path spreads the synchronization across igate, memory_lock and
> dev_set->lock. That makes it hard to convince yourself every path that
> can change the device is covered. It also makes every config space
> write take igate, for all vfio-pci users, even when
> CONFIG_VFIO_PCI_LIVEUPDATE=n.
> 
> Instead, I suggest adding a per-device rw_semaphore to struct
> vfio_device in the VFIO core, e.g. liveupdate_rwsem, that protects a
> liveupdate_frozen flag:
> 
>  - vfio_device_fops_unl_ioctl(), vfio_device_fops_read() and
>    vfio_device_fops_write() take liveupdate_rwsem for read and fail
>    with -EIO if the device is frozen. That covers every device ioctl in
>    one place, including the ones handled by the VFIO core
>    (VFIO_DEVICE_FEATURE, VFIO_DEVICE_GET_REGION_INFO and
>    VFIO_DEVICE_{ATTACH,DETACH}_IOMMUFD_PT). This patch doesn't block
>    the last two at all today.
> 
>  - freeze() and unfreeze() take liveupdate_rwsem for write, before any
>    other lock, and flip the flag. preserve() doesn't need it since it
>    only serializes state that doesn't change after the device is
>    opened.
> 
> Putting this in the VFIO core also means other VFIO drivers can reuse
> it if they add Live Update support in the future.
> 
> The lock order then becomes:
> 
>   liveupdate_rwsem -> dev_set->lock -> igate -> memory_lock
> 
> freeze() can still take igate and memory_lock to check irq_type,
> pm_runtime_engaged and sriov_active. But the ioctl, read and write
> paths no longer need to re-check anything under those locks. So you
> can drop the igate change in vfio_pci_config_rw_single(), the
> open-coded vfio_pci_zap_and_down_write_memory_lock() in
> vfio_pci_runtime_pm_entry() and vfio_pci_ioctl_reset(), and the
> smp_load_acquire()/smp_store_release() pair.
> 
> Two paths still need their own handling because they don't go through
> the device's file:
> 
>  - vfio_pci_core_sriov_configure() is reached through sysfs. Take
>    liveupdate_rwsem for read around the frozen check and the
>    sriov_active update.
> 
>  - VFIO_DEVICE_PCI_HOT_RESET issued on one device also resets the other
>    devices in its dev_set. Keep the check in
>    vfio_pci_dev_set_hot_reset() under dev_set->lock. freeze() sets the
>    flag while holding both liveupdate_rwsem and dev_set->lock, so
>    holding either one is enough to read it. Please don't take the other
>    devices' liveupdate_rwsem there, since that would invert the lock
>    order relative to freeze().
> 
> I don't think mmap needs to be blocked at all. Creating a new mapping
> doesn't change the device or any of the state that gets preserved, and
> existing mappings already keep working while the device is frozen.
> Leaving mmap alone also avoids taking liveupdate_rwsem under mmap_lock,
> which could deadlock: the ioctl, read and write paths can fault on user
> memory (taking mmap_lock) while holding liveupdate_rwsem for read, and
> freeze() may be waiting for the write lock. Please update the comment
> in freeze() and the DOC section to match.
> 

Thanks for suggestion, this is indeed simpler.

> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index 9914f3ac69ae..1f1ac7a798aa 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -644,10 +644,10 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
> >  
> >  		if (virt_intx_disable && !vdev->virq_disabled) {
> >  			vdev->virq_disabled = true;
> > -			vfio_pci_intx_mask(vdev);
> > +			__vfio_pci_intx_mask(vdev);
> >  		} else if (!virt_intx_disable && vdev->virq_disabled) {
> >  			vdev->virq_disabled = false;
> > -			vfio_pci_intx_unmask(vdev);
> > +			__vfio_pci_intx_unmask(vdev);
> >  		}
> >  	}
> 
> With the rwsem, config writes no longer need igate, so this change
> isn't needed. If config writes and VFIO_DEVICE_SET_IRQS really do race
> on irq_type and virq_disabled today, that's unrelated to Live Update.
> Please send it as a separate fix.
> 

This will go away.

> Lastly, please add the freeze infrastructure and the checks in their
> own commit ahead of this one, e.g. "vfio: Add infrastructure to freeze
> devices for Live Update". Then this patch only has to implement
> freeze() and unfreeze() on top of it, which will make both easier to
> review.

Sounds good. Thanks for the review.

