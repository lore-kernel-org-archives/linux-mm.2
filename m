Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB866CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 22:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4958E007F; Wed, 15 Oct 2025 18:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085988E000C; Wed, 15 Oct 2025 18:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB74B8E007F; Wed, 15 Oct 2025 18:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D40708E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:48:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9034E14059F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:48:42 +0000 (UTC)
X-FDA: 84001839684.04.E88972E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF8FC140005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:48:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iTFOC2j0;
	spf=pass (imf23.hostedemail.com: domain of 3xyTwaAYKCCAOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3xyTwaAYKCCAOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760568521; a=rsa-sha256;
	cv=none;
	b=4TLRAeSNZSU0ht4mQ0Ypw0Hx2Ie64cPPvDyF1yTqZ8hfPValj68IhHU9nbSA+UJfpcGCNn
	69RkKBihyx4xMMCoGQw8FLA6eFEL2474R4Ou8PEenSoXGX6c7qnbaBRAmOhaMlQbzrjpDw
	59zZckdPZf82N2I2+H4dAYUG5JX0eEo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iTFOC2j0;
	spf=pass (imf23.hostedemail.com: domain of 3xyTwaAYKCCAOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3xyTwaAYKCCAOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760568521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfHhobHRKUrZuY035WUhQS9GUM0Uyoej5h99Za9ASAY=;
	b=aG7Amh1KQ337VAKy7BlctX/lVphEZN3FAyc1o4Ridk7O9TgEEY+/DBDRiiTV3NMFSklPs5
	1lzmoafzlshjAzrjnjZw1yAsCWCuwChX1k9L24arHZdpm5fTTtk9dgs40t46Ur5vC3ESTW
	qkVUwGYyPHtHgv2JUoahaeLl13/fUxg=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6097ca315bso72007a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760568520; x=1761173320; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfHhobHRKUrZuY035WUhQS9GUM0Uyoej5h99Za9ASAY=;
        b=iTFOC2j0iulbnz06dHYAgvqSLAEGCjsYh8V4e32EuRo3AvDIefShluBkuTe+xy7+I1
         NfBG0su2cbhAY/wA/bP+B+35gWhOLIheTVmog5XMVyMBl33Nui+l5oQu852p0Fkfgc3D
         O9+mB9rqzZhqq2F8h9RqdRfGO+16qMmEnvZd5e2cSK95trakgbxCHDO/yLnorbB7VqhR
         iKPGHVRPmb1oNp885gEQHjuLRdfl05jwriVi28gg5hL3TbIFdZXUOI14KdSMNquHZEkM
         Qg0QpmXsbK5pLAkNUKgeARQvGv+/nDeBGZ4FcRcNSpi5y2LNv1KbR3c9s7ZlcbyZY+++
         2JRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760568520; x=1761173320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VfHhobHRKUrZuY035WUhQS9GUM0Uyoej5h99Za9ASAY=;
        b=J96IywstK6V9uSR/+KFPv3dn6qS3I9H1YoPRxUZpR9VC3ktTjhGvoiZUKERoONbi1i
         iuxdXN6SltiQBp8x6nL+UtXvKltGffTozqXeT5QkYwk8RNxrBGBlFPXLlJCLIDegvoZZ
         jpeDeZgO/xR0aDuOpbnhAwc4Jqwxw3/60U5GAmEpgaAd0vfqNeolSmhWX330Wr0IBat4
         Z6E80rx6CfbViXEJtRon+9bgP9sIQImiMu3GyyM7Gd4Vojj2Wd6q4lOohPJmddjDogmX
         O1VGwR9TJS2AKkAJw9wxoLGnb0XpJdSSiwowiiew+SPtWLAe1rmw3ixSe4xrIe2TCxBN
         3kFg==
X-Forwarded-Encrypted: i=1; AJvYcCVcib1dszTptPOjacDuG3bDl2em1WKXnYS01v4sE8vybG12BM/bYg5MBRFRojLDct7Y9XXi05pHXA==@kvack.org
X-Gm-Message-State: AOJu0YyExVtBqD8kYSC3q8A7e67+G9+hh7h0bE6I7JGjiB2vp+mHAQJg
	fjyfxPo/dY6pYF+gtnsmro7W5BTrkrFXYMxCOufx7U61l0B+RirQkFNCyQ3pFZ/TKwniwqkp/cC
	t929idg==
X-Google-Smtp-Source: AGHT+IEyb34/gE6QWzF0uzhcKPL3N9PV8BEpaNWr9b3Rp3K51ypbe1jmOBzkgqmwgOny3WdOfUFKvL+VZBw=
X-Received: from pjz11.prod.google.com ([2002:a17:90b:56cb:b0:33b:a35b:861])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7351:b0:251:c33d:2783
 with SMTP id adf61e73a8af0-32da813ce42mr40108259637.23.1760568519460; Wed, 15
 Oct 2025 15:48:39 -0700 (PDT)
Date: Wed, 15 Oct 2025 15:48:38 -0700
In-Reply-To: <aPAWFQyFLK4EKWVK@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-9-shivankg@amd.com>
 <aNVQJqYLX17v-fsf@google.com> <aNbrO7A7fSjb4W84@google.com> <aPAWFQyFLK4EKWVK@gourry-fedora-PF4VCD3F>
Message-ID: <aPAkxp67-R9aQ8oN@google.com>
Subject: Re: [f2fs-dev] [PATCH kvm-next V11 6/7] KVM: guest_memfd: Enforce
 NUMA mempolicy using shared policy
From: Sean Christopherson <seanjc@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: Shivank Garg <shivankg@amd.com>, jgowans@amazon.com, mhocko@suse.com, jack@suse.cz, 
	kvm@vger.kernel.org, david@redhat.com, linux-btrfs@vger.kernel.org, 
	aik@amd.com, papaluri@amd.com, kalyazin@amazon.com, peterx@redhat.com, 
	linux-mm@kvack.org, clm@fb.com, ddutile@redhat.com, 
	linux-kselftest@vger.kernel.org, shdhiman@amd.com, gshan@redhat.com, 
	ying.huang@linux.alibaba.com, shuah@kernel.org, roypat@amazon.co.uk, 
	matthew.brost@intel.com, linux-coco@lists.linux.dev, zbestahu@gmail.com, 
	lorenzo.stoakes@oracle.com, linux-bcachefs@vger.kernel.org, 
	ira.weiny@intel.com, dhavale@google.com, jmorris@namei.org, 
	willy@infradead.org, hch@infradead.org, chao.gao@intel.com, tabba@google.com, 
	ziy@nvidia.com, rientjes@google.com, yuzhao@google.com, xiang@kernel.org, 
	nikunj@amd.com, serge@hallyn.com, amit@infradead.org, thomas.lendacky@amd.com, 
	ashish.kalra@amd.com, chao.p.peng@intel.com, yan.y.zhao@intel.com, 
	byungchul@sk.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com, 
	michael.roth@amd.com, bfoster@redhat.com, bharata@amd.com, 
	josef@toxicpanda.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	dsterba@suse.com, viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com, 
	jaegeuk@kernel.org, dan.j.williams@intel.com, surenb@google.com, 
	vbabka@suse.cz, paul@paul-moore.com, joshua.hahnjy@gmail.com, 
	apopple@nvidia.com, brauner@kernel.org, quic_eberman@quicinc.com, 
	rakie.kim@sk.com, cgzones@googlemail.com, pvorel@suse.cz, 
	linux-erofs@lists.ozlabs.org, kent.overstreet@linux.dev, 
	linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	pankaj.gupta@amd.com, linux-security-module@vger.kernel.org, 
	lihongbo22@huawei.com, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, 
	akpm@linux-foundation.org, vannapurve@google.com, suzuki.poulose@arm.com, 
	rppt@kernel.org, jgg@nvidia.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: b4oakrq6wurqtos5ag9tswxms6hyskx4
X-Rspamd-Queue-Id: EF8FC140005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760568520-450258
X-HE-Meta: U2FsdGVkX1+mFLUBXFI1fRKrmyrZku5hxMoeJerayCFUWOWfkpW3mh3Ax4AlwktOgmbTHptwpk1e7XE8qtvwAfmClqLQuvtc1aWYjPFrTWorJEGwOC2i8hdikyY0RRaP3NkU6az9GpWWYzYVOc4ZboWappqFGY5m76lk8FktHC83l4IGfE6hcWYMYSpwzna5ImM4D3s5Flz05Q3mGlc55M9VHYrLE+rCjURZJmKkByCaqJvhxiPIVsFNgnb2svtjd2MTUYCe4Ghhk2cZOSIr57T9wqfvcjfe8MgigyAwl0vjKnOHiULNN0/Y8yykgj55xdUs8WgXG2+eh5IiwFZ3Dg4DVtEqSzHdPwkRZRMHN/zTZLNK1J3SvwmqPbRbR9HMCaaOc03GKE4ir6YxgkRH6YpbIdtCFsBDX8zL2fS9RDDLgv2O+zMg7+PRoHKKhJH74sEgVtVAcbagjYw2Psl+48EXhhaCfyyLpOh9yFrRs91rs7YmEsDkxjy+yBLmDNLJ15KOQECfQLWcuJLyVEo06uRZXgoQe5jFjFspq2DKnVWEtnLK81Jm1WLSsNETnDGBrCdV6ZNEVIKm3or7WTjT4ngU0zZT7GwgB2FzM5VWdHXiFisCkNQ/J7472kPhmjtpzUlPRKScFHrJg2ALiZDzNm9K4L+YF96QtrFla02rO//ZJHv/5MVBHBxaqL0FlL8mEHE16h6lrXiMg0L0oYLxomXkElzN29ypcMcFMC5YOc4goGRdHdJjF+vCUBNp480mhd+S8WZLuiEdC0sL9UHHfhGahPxl5fsk5ySse8cMI/5p0K9AYv47VujoodlPVkonam9AvClpaL0I8XU0ncwNQt6eRvYZtDV/8QgDoSt3dqQUd8DkDZl/+j91Vkd7BHMo7/XzRs2yhboUlS/jlSxtWSW6MWn2K97dbISLMyIAlQQu6Klf6/FCOyaURJmsyJHQdoLyGcfG4DSY20x7ZDB
 9PpoqUrd
 NJ/5X9HhNOpmDQT8BtZMbR9n2bkLQBmM7BgytRpuFW0nkSr/wxLoHvTY9wmoYPocEs3cfesBCZMswCgxQHBtNFmtrZAhvw4D8G76/tZtCDbQvJWeKLQclDzJaHeMI6UngSrpojGgQrWbwcPzu3l/5pKfFrkbeoZEKja1szWyrTR4iiYNxcxtJDLPpJ6eMitmOJDP2SOfKTNfOHxl3e2R+v7zUNp9/IcYnYfRAiZY8kGQMu8obZDkiABKjevHt0lQnXkS1SF2izmFZP9qYhbuhpg9vq7VeLLSc6L6zWGOTir6JS8T1o1kZaUhzAfAGA9KDtRJR5dAbsFd8bH/rUdbx03nN/U445W4Ocj5E4kRTD0MzkceHEW7hIjytbmOb02Ym22nbt266IYbDSvnPCg5T8sJHQMLr6BCfEpW2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025, Gregory Price wrote:
> On Fri, Sep 26, 2025 at 12:36:27PM -0700, Sean Christopherson via Linux-f2fs-devel wrote:
> > > 
> > > static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> > > 					     unsigned long addr, pgoff_t *pgoff)
> > > {
> > > 	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> > > 
> > > 	return __kvm_gmem_get_policy(GMEM_I(file_inode(vma->vm_file)), *pgoff);
> > 
> > Argh!!!!!  This breaks the selftest because do_get_mempolicy() very specifically
> > falls back to the default_policy, NOT to the current task's policy.  That is
> > *exactly* the type of subtle detail that needs to be commented, because there's
> > no way some random KVM developer is going to know that returning NULL here is
> > important with respect to get_mempolicy() ABI.
> > 
> 
> Do_get_mempolicy was designed to be accessed by the syscall, not as an
> in-kernel ABI.

Ya, by "get_mempolicy() ABI" I meant the uABI for the get_mempolicy syscall.

> get_task_policy also returns the default policy if there's nothing
> there, because that's what applies.
> 
> I have dangerous questions:

Not dangerous at all, I find them very helpful!

> why is __kvm_gmem_get_policy using
> 	mpol_shared_policy_lookup()
> instead of
> 	get_vma_policy()

With the disclaimer that I haven't followed the gory details of this series super
closely, my understanding is...

Because the VMA is a means to an end, and we want the policy to persist even if
the VMA goes away.

With guest_memfd, KVM effectively inverts the standard MMU model.  Instead of mm/
being the primary MMU and KVM being a secondary MMU, guest_memfd is the primary
MMU and any VMAs are secondary (mostly; it's probably more like 1a and 1b).  This
allows KVM to map guest_memfd memory into a guest without a VMA, or with more
permissions than are granted to host userspace, e.g. guest_memfd memory could be
writable by the guest, but read-only for userspace.

But we still want to support things like mbind() so that userspace can ensure
guest_memfd allocations align with the vNUMA topology presented to the guest,
or are bound to the NUMA node where the VM will run.  We considered adding equivalent
file-based syscalls, e.g. fbind(), but IIRC the consensus was that doing so was
unnecessary (and potentially messy?) since we were planning on eventually adding
mmap() support to guest_memfd anyways.

> get_vma_policy does this all for you

I assume that doesn't work if the intent is for new VMAs to pick up the existing
policy from guest_memfd?  And more importantly, guest_memfd needs to hook
->set_policy so that changes through e.g. mbind() persist beyond the lifetime of
the VMA.

> struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>                                  unsigned long addr, int order, pgoff_t *ilx)
> {
>         struct mempolicy *pol;
> 
>         pol = __get_vma_policy(vma, addr, ilx);
>         if (!pol)
>                 pol = get_task_policy(current);
>         if (pol->mode == MPOL_INTERLEAVE ||
>             pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
>                 *ilx += vma->vm_pgoff >> order;
>                 *ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
>         }
>         return pol;
> }
> 
> Of course you still have the same issue: get_task_policy will return the
> default, because that's what applies.
> 
> do_get_mempolicy just seems like the completely incorrect interface to
> be using here.

