Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90995C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AEB26B0098; Tue,  4 Aug 2026 10:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938556B0099; Tue,  4 Aug 2026 10:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF236B009D; Tue,  4 Aug 2026 10:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBCB6B0098
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:58:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6506C01BC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:58:07 +0000 (UTC)
X-FDA: 85063892214.17.2838778
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id E1ACA40002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:58:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nTsG2v3F;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kfastov@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kfastov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785855485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXmm83TGVs8V0++ogZvMrKHltLz+j+PoXOcZxjRNY7o=;
	b=PKf12PG6srFi1Sjt6MQk7nkB28mCldW0UqYfI7xj1F2YOrZsbSzslDLPprL/W/pCQucMF5
	KPBZiQ83BsZRxGGyV45U8KHzEcWfsi0X2hGhUyOHqKZ75U9l0/E2yuG5qyQ7/dyELHXBrw
	5Q/jTzy4u1Am4NxEISz9JTZMLwAFL5Y=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nTsG2v3F;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kfastov@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kfastov@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785855485;
	b=6ocfvum5SEHsqby7aV6m7M5D3AIqtlagYpQGpTkYMHKMytDF0unCWRcKOEzb4SWaRyFwoy
	dgZnJxohhQxUaHh87E9k+VFRwBSWugIWTSI7vtVcVEISSvgpvzAdycr6Ruoneda9wR1WGe
	FQW8HbLA4D7uvo6OQNnNQxIIgGW6slM=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso5789044a91.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:58:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785855485; cv=none;
        d=google.com; s=arc-20260327;
        b=aPCs8b/Xj2hJ+IzVBiSOnB5/W21r8ufU4ki0K7m03h27pGe58sNCeRK8SAGT6lxj8b
         t7ozDSDfl7Bel7AQ4qHzajtTps1KopddU4a0BW8A7H7lA475vhH0GNGplA9EPxUobLNu
         h4Sh7a3QP1Yo3rMwtRyK3jd1717cZXdKBUC8t6iTfOTsvCqgWCkdpTSlQ0081eyHIb/6
         S9jZ6o2GCuNPdtB7LA+lBQI+jdGbR0tQdK89YoDoUKrhpUiqXF3pZwRtxD8sCEUaxVuZ
         7mA06lpcL96ccWoFzZMT8+lbp7L4XSzbjto7DccO2W+oZ/XAEsUP1VchNdFh4JE0AjaS
         BwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZXmm83TGVs8V0++ogZvMrKHltLz+j+PoXOcZxjRNY7o=;
        fh=Ppm+xMWCAIpFIvUzh8nIL/KtZDdBNmB25/7KL0e/4Kc=;
        b=ntikARgB1Gnwj4sbelE451FDwYVShZC3xyIMmOi0xDwHpnkCaTT6yymhdr6VaieO/h
         6zCDAl1aF+Wzrb1EdBpQEEMFt2JnwmhxPKPHXx42zuul4Ppav2rkwgot6W/mx+5ulh7J
         9fpd0m2aueacZda6muRALZCqxrUH8JI6gUIxi7wZLjrGTSBsPqETSB759uae3VQK1B6Q
         hw3bnBZqRshlMcpDXe8+hd15YHk3kCXjd5VDv71t4FImxBeQHbK+Mm4E6Str1fYuZQRD
         zObEU7SR1m8jQVhpZzluooj8nRePGHGq2vWbRSOgUfWSEAdTKM//kdMkeSLVNHEzE5cz
         YEmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785855485; x=1786460285; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXmm83TGVs8V0++ogZvMrKHltLz+j+PoXOcZxjRNY7o=;
        b=nTsG2v3FXg/yRJPD/m0EFC+hzAKWRUGCPl+HDUxEzycUHp0np9icIiidRJEhkL9yrE
         /v+GfpGHWdUKeZQg2+NmFe2SKlYFuMdpsBXtibZBk0HoY/GN2PYgtufOVfbNXIRJO7Mq
         itdAIrPfKTQsHzC6HvcjYuQevfuPA78pZswUXRCOmH8gMU5CCRMqaxzZ8LyJZVvbGaY8
         7F0j/LHja2FPQljnYsCa7EdetHMmlxAuLWqgumieFFtAMoLH1kA8pUGXaiXUU2hFNGWy
         O41Gp42H6hMpqmH8gaKPTobx83hm7jT8CI7YohuaxYbwbOMJoUHR+/1ZsEDKzf65N/Rz
         ehSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855485; x=1786460285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXmm83TGVs8V0++ogZvMrKHltLz+j+PoXOcZxjRNY7o=;
        b=E/vfAg2lbWMce+wZ3RMjg8/kwkrvYfCfMSXyLlFPy6ddzn7JJzWbbIzTECh+vAc6Tk
         twPr5hMA+2efnJfX74t4j7LGCP5RWuniY0CZL+INCJ5qw2fbsGBy30cNhzOpslvr9IYV
         ZQbx+TFsICHiO9yqjQ8UgymoU9RBX7+Qtqgj+xhT/hu501tNa67P20v5ix+2G7ztrPdT
         STZmU8sbSxkVrH7hnO/B8+ryC1DnlI0fY1aBGeXv7xJF6XU8uAzYsFA2Y4dl4XmiAd9W
         qzgkDet0IN+xpVzIwZ/Yhs9ERg9a0Oz4r70Bg3Je+Uq99pnv1Y5CsnUumNBoUCATapSj
         Z49g==
X-Forwarded-Encrypted: i=1; AHgh+Rr654yRPDjSm/hGOjIYGRE1hclli5mu9O8KKpmVMzsHChUolfaaPBWMZK8Oen1vQGilKeMyMpcPJQ==@kvack.org
X-Gm-Message-State: AOJu0YxRbAmbUcp8MQKoLEbgD2mWsMcNRcM6PnuEz2WK1LhTsdJnu5IL
	PonZ+9R7qD76HDKwPRVl8UHmWBkW/CegWXoguii4G/B+N1ITFW16gyq05Piyzz7cEXigJ/xGgeN
	TgG4Dj5W/+yyjNDK5IP4HvPbeC6EY6Qc=
X-Gm-Gg: AR+sD12Gi151OBwhZY5/C6/tT/di2jjCRHcbw9LJIvAhkr2GBNH462OI4hbq8DDub0M
	ASJG3Ug5DFvCOWzK2W39caQbOGuAg1XQ84hpp85UKc27WnGxyFnwDTtk4mKMgHQJnLxFqQDW0b+
	5aTJbZdVCZ107FAD1Z232Zo1AiyMJIMYPTvLWlXstV2oeOTAhk0THmSCmTRFcWPEdfvO7dKJJnZ
	YSDUg27Xjk26I8AUnbXciZBDH5r2CUbCzbE1tkQIL8ajU9Yye/td7kZQ/Vg4eQ6u8UFmDq6KNjx
	NW61EA/IpQdN1rnSvAORXegu0Qi7iVm5HJM6kOBtsxDNQ35wARmekRnw+S+6pVPbHIib/aMLLTo
	S7nu9EmlXyEci1r9YDRgvh70=
X-Received: by 2002:a17:90b:1c86:b0:38d:ef48:b04 with SMTP id
 98e67ed59e1d1-38fbc4249efmr13503882a91.10.1785855484729; Tue, 04 Aug 2026
 07:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260804140403.16337-1-kfastov@gmail.com> <20260804162924.0268f80a@fedora-21.home>
In-Reply-To: <20260804162924.0268f80a@fedora-21.home>
From: Konstantin Fastov <kfastov@gmail.com>
Date: Tue, 4 Aug 2026 17:57:52 +0300
X-Gm-Features: AUfX_mxmYF7mTsV_kCbKDVkg1SSi2DOX7EMuysDet_SV7d52zqlljQHcxRDaOHk
Message-ID: <CABWhNekebS6dt=Ft+74iG4YpCq-5ZcV1EvvERNxT612VUOC9Ww@mail.gmail.com>
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o1eyaww6guu9r9msg6ghoo6u9pryq34g
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1ACA40002
X-Rspam-User: 
X-HE-Tag: 1785855485-560894
X-HE-Meta: U2FsdGVkX19WGaBDremoMnxU7EcT9jdnkTdtC5OO1iUriyDMBD5HKo7YKrjruRJWlQPpfvy07dRIkXMQtSlH+o3NQZkFaozFMCgaMpHKfy5Yh1t7/w/m4jaO8/JXhkF8YxZgqP95ydrqanEHUToKWqdVect8yXGGtzEo8t1BCwYDojavTB9VD+jSqJrZn4IrsroiFM2U9tfW/Wq6WhkqHL6GPcG7shmLAmfIU3Hgjo/pXwJOnb/AGaxFE3It+bLzXAWSgepwarV1/k8+JAICCy6qVTplo4Thfucl3MrgmU+texVGfWLe3Rgs/RTjmBfP0ZGYUnWxaYzJHsffcqRy0SZ6qeMiv4xVxaIX9dSZRoNbDtVfUKT6i9DC/vTa7/4YNTpa+Rl0MDaTEu0H2djfNFFu+4xhJllwoUYrZSwLBlCMzCY+r5If1IwUN96HfKM6V0zfB1kEEmL3tbfVPy36CyS40s26N377Oo2JRvp2ljDn8C0fdqXr+n/lVbPZIgn24gPO3sjqGEHCm/5CtF11kx3R3Jo/I85hBIWAGWR+lUY2oj8sUS3I3iUbK9ou7cGJr55Ju8OA/wE9SJ7k7iUB/86d7Zza50sMFrhS1EGWld+AORkba5H/egEnKTzK6BQhtePNkxpha9yrbmoG6d9y+v+ckrzCqj1fw+a0115e1n0g3STtR20EG5J4vtebPi/IsG42tacvCrMUiw7/Cor59VUkZLKFVcsEbYwetoY8kYFVgb5WQDOaFSbS1SJOAHQAFwafoY4EQQjtXXIhIVOlsD+OCKzhFktT19WTOKLcFvqQCrRLWwA2hdrmgu3zMBY5A8ofImXcSQnb1bFL3lY0WZ4dbYjBBF/ibWI4nTrF62ZarXRWhGalHMhkzPDEpJy+R1+z62IttYSgKADwqoI1KiNNNz4aVonYqYwi2o2yslKOuBly0MhufKSTqohpuD7IGci2JIpum7RNI1KosVH
 +wwYfL25
 sowYAOfuscLNVQe68KfErVX/LfnGRyxSsS7i0xpZx/xUiT8bBCGk5BkbVwu7lLM+MTSsWW5idoxZXSTckf42lzWQ+LoP5ZLaQEyylbBNwF+9xjwBzevXqW3rs3OYc9tIY7yheD7x8vm7FEy6375h6WyDybPhx6OF1kG0kFL2dCrT5Cvem1VoLZdFlThfYjPrLFMNf65QhACCaEsZ5xHnPZdh0pD44F488NlJaoJS3BbGJFsCmLlPOW8VXwENhgw20CrR8BxdFQTQvxvhQ2mLXNoL9bG8T98ubrZQI+owVY3TAkAPcTnap9iy7Z+d84aAlO3G02M2oDxp7d7fmFcv2kpSxHaf6RtduF/0nRp4WktFxs9mZK/C5ZCJ23Am+VNsADRxETm9aZVdtKZpD/Z1F7gCQ8mrpLerJnlQ6qZwSMABZZBTRq3mwfhEqDg8IQgQ9JnaEdF6eRpR0L9i56th8cdfG1UNdHYV+derAPF04r6i7I7kygvhGJlThmy6zYlxLZPSklfod3z7fS+n7W+3gI4haZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Boris,

=D0=B2=D1=82, 4 =D0=B0=D0=B2=D0=B3. 2026=E2=80=AF=D0=B3. =D0=B2 17:29, Bori=
s Brezillon <boris.brezillon@collabora.com>:
>
> Hello Konstantin,
>
> On Tue,  4 Aug 2026 17:04:03 +0300
> Konstantin Fastov <kfastov@gmail.com> wrote:
>
> > Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
> > .pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true,
> > so vma_set_page_prot() removes the write bit from vm_page_prot of
> > shared mappings, and the vmf_insert_pfn() call in the fault handler now
> > installs read-only PTEs even when serving a write fault.
> >
> > For regular CPU accesses this is transparent: the retried access faults
> > again on the present read-only PTE, goes through wp_pfn_shared() into
> > .pfn_mkwrite() and the PTE is upgraded to writable.  But consumers that
> > resolve faults through fixup_user_fault() + follow_pfnmap_start()
> > perform no such retry.  In particular KVM's hva_to_pfn_remapped(),
> > after "successfully" handling a write fault, finds a present read-only
> > PTE, treats it as KVM_PFN_ERR_RO_FAULT and fails the vcpu run with
> > EFAULT.  Observed as AsahiLinux/linux#560: muvm/libkrun microVMs
> > mapping virtio-gpu blob resources die with EFAULT on first GPU access.
> > The traced failing sequence:
> >
> >   follow_pfnmap_start()        -> -EINVAL   (no PTE yet)
> >   fixup_user_fault(WRITE)
> >     drm_gem_shmem_fault()
> >       vmf_insert_pfn()         -> NOPAGE    (read-only PTE installed)
> >   fixup_user_fault()           -> 0         (fault "handled")
> >   follow_pfnmap_start()        -> 0, !writable
> >   hva_to_pfn()                 -> KVM_PFN_ERR_RO_FAULT
> >
> > Fix it the same way commit cb2a2a5b37ad ("drm/shmem_helper: Make sure
> > PMD entries get the writeable upgrade") did for the PMD path: when the
> > fault is a write fault, install a writable entry directly and record
> > the write for dirty tracking, instead of relying on a refault that not
> > every fault-resolution path performs.
> >
> > To do that at PTE level, add vmf_insert_pfn_mkwrite(), the VM_PFNMAP
> > counterpart of vmf_insert_mixed_mkwrite(): insert_pfn() already
> > implements the mkwrite semantics, there was just no wrapper exposing it
> > for pfn inserts with the default pgprot.
>
> The same issue is being discussed here [1].
>
> Regards,
>
> Boris
>
> [1]https://lore.kernel.org/dri-devel/20260804120529.1730187-1-pbonzini@re=
dhat.com/

Thanks, I missed that series, I searched dri-devel but not the kvm list.
Paolo's patches 1-2 are indeed the same fix (down to the same function
name), so please consider my patch superseded by his series.

I have a fast reproducer on Apple Silicon (Asahi, muvm microVM, dies in
under a second on stock 7.1.5) and an automated test rig, so I'll run
Paolo's full series on that hardware and follow up with Tested-by in his
thread.

Thanks,
Konstantin

