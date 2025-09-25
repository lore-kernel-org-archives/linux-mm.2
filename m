Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DECCAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7D58E0005; Thu, 25 Sep 2025 18:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E688C8E0001; Thu, 25 Sep 2025 18:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D572B8E0005; Thu, 25 Sep 2025 18:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1B198E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:31:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7256811A439
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:31:40 +0000 (UTC)
X-FDA: 83929220760.02.ECDEC35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BA1840004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:31:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C+yZubRg;
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758839498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPGBYTkBK6lmMsctQg86rFzc+ubUYRnHqSeaFKAdA0w=;
	b=ba4xLE8PHiz/SDidS1BwZxNG+41Zi0jr6OuQI+ON3p054krUNhwiLMWMrbDONQnWSieVdx
	zHiS7iIRfEJam0gmbwVIEvH8AS+teL6XskxFAQ5QY2DNYeGhTdBkY030l7wcu4jh0EkMjC
	uZdQKYWd/RSX2jTs7s+AKMaD8yE1bZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758839498; a=rsa-sha256;
	cv=none;
	b=SgUoPi3JKlf+QvyUJPE6EJV1VaWM87uVgMVgs8Jibyk4sc4SQqKIXYOFwOfNsGV6Cx0/UC
	LroPOybkfizY1p4gb3W9XbHRYIfabtkPsntPp8CR8ZP5bEceWjXH8+T5XLjtu2R+qNo/P7
	fYFGnbSZ+DfgBxttd62uqFPHxyO2ejQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C+yZubRg;
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758839497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pPGBYTkBK6lmMsctQg86rFzc+ubUYRnHqSeaFKAdA0w=;
	b=C+yZubRgK7Xuwq8ZYbAwrcRYC9QJmxmKZYhbFEgZZzGy0wcSpRtZdmQIn5cJi+4/kE7I0b
	H7LRxQ7lvfwPszHznmJsqnXlq31xtlX1UeKVoTth1DoVwhxeCom1E1069qr7z2twjZ/ElL
	OZg7vgVrWNEhfNV/vmzboGSLcCUVDtI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-aQdiok3pN-mh_w3at-nvjw-1; Thu, 25 Sep 2025 18:31:36 -0400
X-MC-Unique: aQdiok3pN-mh_w3at-nvjw-1
X-Mimecast-MFC-AGG-ID: aQdiok3pN-mh_w3at-nvjw_1758839495
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42571642af9so5015085ab.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758839495; x=1759444295;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pPGBYTkBK6lmMsctQg86rFzc+ubUYRnHqSeaFKAdA0w=;
        b=d4ruQ1qm7akM+y2yO4mfbtVE0yLWRj3WAcFtjPbWv5xGfvIKXFiPm1TCN0rmeqy60t
         EvKhyMFPy//5vG9Gm/iPMDWlSwS+8TjVsZuPl8Xw0UlaFegzlwolgsXk6UEyn2jTdhFd
         7c2TNpsohu6NvDc4s3QLij+ehEFXitCtMg4q0gK1mYAv5z9r1CO1kYk3gHKX73ZEDsKu
         HAsBu0R7cH0/mALnWFg1jUjNLP5ptl7X2IAqJbHacpPgKbn/czqkkM/WfPKODT182QLs
         e4jfkPnXjI79IR7Ba2rXEIHfQKQEsKISIeUMGscXAhXPhilkxTjgwdHQH42HgBG0WH0R
         s6oQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9mNsojUjww1cP6sasmZpwD8CyyTMb+Nti9ket3TRu7Wl1hMdXjxR56c/z5z4+5E+zXorAT3pXEQ==@kvack.org
X-Gm-Message-State: AOJu0YxXhki3FSAj66BmcwcDBM9vEXH8Hm4KOcj9KfJJ02HY5ozU/Kbk
	Kdck5x6NMe7W2dNMdW1ZygvIV/VFQOjtDMzaj+O1p9r9PJRHpDjrll8ZDikq2R7dFyUfhHUSIcr
	AH72vxPdqHfQHKyYAb6sBeOvAZw4rhs5+ul9g9AxchqCBxG5bWGfC
X-Gm-Gg: ASbGnct6AxU6wjOLrrxsi2u8I23r07JPkHDUIvZ6SeIpQZXUFOZ5MBmHPgkpwq79DSp
	0DqbpeUyzUXq+PD86QoRPG3VBixDwVfY5cP6IOyDgOAnxWArj/8PiNlpH6tUH5seRJ7L1NMpuA7
	mrb0wFAwH7fCwBXQdFDRahqEth49Fdl0bUMxGjQ52sxqFfdvnIymzLdHGzeHtqu8vOFmScSZq8j
	bRQa7t/aEbB6mG1gYFdM9U9mVCKK0iylnKD2CUmcEZ/7K5mL5DFeBQzEukEM7qKUCy+mZDp4mhx
	ZdmTO3fkCwoZ98dAA7965uNMZEJHo7AbXjTZheosd+M=
X-Received: by 2002:a92:d987:0:b0:424:80e6:9e8b with SMTP id e9e14a558f8ab-42595661562mr24720175ab.7.1758839495371;
        Thu, 25 Sep 2025 15:31:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBjWzVlsd5kVvaGcIPZVt9Dy5vtGZ7X7lNybnyhnS6f36pgd3Q/xbJFuK0zszjvTKZaW8Iag==
X-Received: by 2002:a92:d987:0:b0:424:80e6:9e8b with SMTP id e9e14a558f8ab-42595661562mr24719995ab.7.1758839494991;
        Thu, 25 Sep 2025 15:31:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a69a1c574sm1211405173.40.2025.09.25.15.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 15:31:34 -0700 (PDT)
Date: Thu, 25 Sep 2025 16:31:31 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250925163131.22a2c09b.alex.williamson@redhat.com>
In-Reply-To: <20250925115308.GT2617119@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923150414.GA2608121@nvidia.com>
	<20250923113041.38bee711.alex.williamson@redhat.com>
	<20250923174333.GE2608121@nvidia.com>
	<20250923120932.47df57b2.alex.williamson@redhat.com>
	<20250925070314.GA12165@unreal>
	<20250925115308.GT2617119@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jEY4pf82zoZKVemIY0MWEyLhzsInPX_ADqDaG2vdfsE_1758839495
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1BA1840004
X-Stat-Signature: 1jko38ndhkkewkuxwwcxwe68ykr85u4r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758839497-428807
X-HE-Meta: U2FsdGVkX1/iaOJkBE57cMn06cuUYhKITdodPTsI8XcqHgF7WsnH7WwfKo77OWEpKxOH4u3TqQkuhnDVTwlUEs8yqcvPe94Tlz4kGbKZEOQ1Jgnpzfuw5kuDAtjgHuwUn5KVPjGp+LIeJjnF+CEQuckGzwGzatAu1790jhOibtvX9eTAsgsGwu61XQm3kslHD0OzxOc51T3B0UKXCWzYyp59sFagbJrLRB2MkGMpWrjbbtHQXVjuUDUU/oF4+YkPs2giBkaY7Z/EUfkUXNPBeR/YowpuY3L1NXdkNlpjxtY66nPntmeuZtq4CU+fSS1RAN0MBxIOPw40JeYnbeH2JNp0oxIOgG2b3VxxuB7Zk91X6nnY08465yy4wXAllyNqdl2Cv17w4ZtxbCmLlAB9Y883lotfZhXn8yYABNrWkMLcs3p8OSYhHKOSYJNA0/d3BCsefUeJrYB+5+RYX05wrd5Kp3IVDwEdplCGNAVS2vNIu2qwPMNjMFX5hzmwqi3JDJchUPhMB2lmKigODqvZ7GDDQGzcR29NcHlfUKbbDRyOZ84neNenXZ0cAT+KZt/0SlCFKA11RrdOzimXkXbwMNkErUgc2ssxZRCJi7TukRkAoxvwAZOtfHodQJeAJcG2PdB/7Sjb1R086CeqJgCwoDTwaf17IlOU4qUzyVFe07p2t0YBKgPdoN1VpFslH6vyMuNcT87lHJjh3HJeYvkuaEz5s1zGM1gn/zu7xIjaCZB974us1zlFj8WRTKA/ISP9e/A893Gkw9MTe4EJpXCGnUzPdId/AXHUniah8oFzFZ5TyHGhf0Net1FAXSxZVYW6FEZHObeq9UbDI7zQQBOT0KxyjQQmTe+wqBzjekuBOd1emIpgy1J0OCWh2nvfnIokVC88YD0/n+UCYKDvJspQnffWawwjdUewseH2g8k7V69mcE2qvqCAk6E7J2rxgRtoQeOmmc/UO/e8FmHHkPD
 fHjGT8Ro
 vmVb6tOg7xkf+UiwNgvhjCMMYxlleztHyXz3A41eoCQx6kUHX0yPe8NFuMIUlVYOQS1BVkVGEI5PDpZOVIH9/bROON/fTE4NkQDJiZP+cgqpMwjueHHVm+7igUFsT5EnHgnqtWMgosv726kb51wWEWLbtsMDMtjsWJzE3C3WnJ6iO0lZIOlvGDQWuisfesKrNhzOwF1sj2FcLMKfHjmpOIK8fO4j23jmpQdk4ZBO9ILUc5GajzG3z6naM3a3YBwa66eRvKXKSstq+ZwDkQQLbuXkrxXou3KHEEEaxTxD/sG/DJLJJAqCTGF4P1v4k4b/ZT3BGpHbFjRalmHjFVJ87JaDtgSjJ1trKfZgnBtyshSmEeeysB8I9k60Z2diZPS1+EKmu1lwsg4EJnlSNZWY2OF4ZGg5IqObBZneGbqGbiQu4jNetIDuDw0aNYDe4yEgdgfEiKsRXfkVYPHNp6jbtWCUWDCwZQx6Fn9AqkP/SpToVapHX/OVk3/FGIX4r1gvrssfLc24PxS3J94QegRuXjwpAZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 08:53:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> 
> > > It would at least make sense to me then to store the provider on the
> > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > the inline #ifdefs.  
> > 
> > I'll change it now. If "enable" function goes to be "get" function, we
> > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"  
> 
> Not without some kind of locking change. I'd keep the
> priv->vdev->provider[priv->bar] because setup during probe doesn't
> need special locking.

Why do we need to store the provider on the vfio_pci_core_device at
probe though, we can get it later via pcim_p2pdma_provider().  Ideally
we'd take the opportunity to pull out the setup part of the _provider
function to give us an initialization interface to use at probe time
without an unnecessary BAR# arg.  Thanks,

Alex


