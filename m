Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C5A109C04A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FD96B0005; Wed, 25 Mar 2026 13:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237456B0089; Wed, 25 Mar 2026 13:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C856B008A; Wed, 25 Mar 2026 13:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03F006B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:29:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ADAA1A0A5A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:29:58 +0000 (UTC)
X-FDA: 84585273276.14.1F5ACCD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7C6DA0017
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:29:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ay3PDww2;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774459796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tqtdz49F1thS+8gpmqv2HF5sNOiFchZq7BXU6+8jf4U=;
	b=AHHFlKT6jPX2CIDHBaMddYkArNSY1IP85lWxaqu/0MEcK6LRCkE2eWuj4vCsQmB8rRXr5Y
	J3Bt62wTWHIode2cEUWQxFC45Sh1GyrI9/lNxlkHT1J2RziXFJziFt5XwSheQGLmPqI4VD
	CQb3pY9cE5oK14W50znJ0i21IRSMhy4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ay3PDww2;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774459796; a=rsa-sha256;
	cv=none;
	b=gID8NEYAQEk2HNnGQ8srYTEEffK5Y9hEWmfnZnDXs5w1NgMwgBd4zBPhI+siCXJd5Lzebs
	NmnnuK2vlukh4TtsWDoS/oefz/TeVjjZP+m0zIGRBdWLabPS8fEI/0qEasPNoxyPs5O3BX
	QlY9UyKVfV9TxSBRPrJBM7Rueker97Q=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82c68339cf0so860916b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774459795; x=1775064595; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tqtdz49F1thS+8gpmqv2HF5sNOiFchZq7BXU6+8jf4U=;
        b=ay3PDww2uz94pq+6/OJGpxEzdEIHAyzrrip9104AftrHs0AHD7/z386EeE/84lfGds
         k7kJu9f6YkmJobV8CGaYel9OzIA9Xt/8BzlGyXBGDFwA+CdMmIiGRI3Q/eL/b/MEPctZ
         j0JI/RGbLhnS73ZWPrGA/7CPdYk+H+G3tZ1CnsFCECXSQSjdqLXnM+PkvvushrfKa7oa
         cTarTFoGhQsyTuPZ1HdFZnEymd6wlfj10jPA7q7LMFMuDOrB7k6/T5ijxGqh6UP0Oaz5
         ER3Bhd0mV+AicvFs11O/FmmbGVV/Rj/bebJYMlBBxHclDHX6Jl8cngztr7hdA0d3Fm5W
         pGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774459795; x=1775064595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tqtdz49F1thS+8gpmqv2HF5sNOiFchZq7BXU6+8jf4U=;
        b=TrEhhwLUfngxKm4m6sQ9MdFcarpuz7h3H1YxexsOW05fppa09d0pSBpOkwUxtEryIO
         aY3FQzIgy0+D0UCOlNiNNi1h3Ke+xWZCFBNLGfjAlO8msqdcnQaBEpH6CFEoOUInvsjB
         p9nFHQQmLxwE+4ifTQ2/VRVQecil82W2D9u0RjZzaJ5rAuOlV6vwalJ9IXLNhuQRn0eK
         24xUZt4+JgXXtHRxklDSanPA4Bz62H2wM59UxMlot2a3Yt4PlxlAQOLEPjUtbiFt9/PI
         ea7/4Nag8QLAT4lKVm7sT7keUYuzjqplsl5bu8vzbyyW3XiZKEMkhHnqLhDDUetV1/iT
         zUrg==
X-Forwarded-Encrypted: i=1; AJvYcCUT1gNSK07irRT4W3PgQ6WxKpMMFS1yiZfRRAaVkS4ljnMpUKttIxO3S6CeYL3/1LLEaDgs2dMEpw==@kvack.org
X-Gm-Message-State: AOJu0YzlzXJoXMdNkfrA9VUqaRYc3Pf1365cgelrYQ2dt7hsvJL0YJYT
	x3P1JGPJuYi2FKn5y+Gu47OLzYsWS7iy8zXgO1Fm2rsFUPrm1qf4Z0hCFxHZNTPDgg==
X-Gm-Gg: ATEYQzz/T+H15apOcI3X+zUi2tQhnq5eEOfGYP3OTXsWVDf/FLJomhA9CchMtjmkIj5
	+aMxljsUiHvemyts68oHL/8lq/uTdT8Pw3d2tYw8X2It2VJ1QOyAJ4sPKnICwhG3gj9KWcfTsdG
	sNHwu3fixseHj/DpvVLogjw8OFH6fnEMWW+nMcPzpP/ROvhtA85OmSmnUfBsa7uCm95KNukTspo
	As1OixRIMq9ikMaL+8zSs9QWB+pL0pVa+QLq9MXHkQ43j4SVrJ4twFP5sv/Sd0MBbIQSfUA0aXZ
	59Sp+u+TCgOEvBYC4VVJxLeXVOk7UqSW/pGihrIG0J736U8LFdXuQ06P2wx2VMkFBISyOcWpjvQ
	bHBcQsySDBgqm4qZfwFSnzE3GRGcKdNus4rAx5IgaZa43BT787cTpvVORIm7w7emCN9YYq/POE+
	7DOlOuMmBMvebW0d+1WLT8xIU6F4/uZ/Me3nTY92gMJ7wOIWokUzYC/gZIFk8hOw==
X-Received: by 2002:a05:6a00:1826:b0:827:2dff:7116 with SMTP id d2e1a72fcca58-82c6d99ac23mr4021492b3a.13.1774459794263;
        Wed, 25 Mar 2026 10:29:54 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d216a0esm312308b3a.17.2026.03.25.10.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 10:29:52 -0700 (PDT)
Date: Wed, 25 Mar 2026 17:29:48 +0000
From: David Matlack <dmatlack@google.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 03/24] PCI: Require Live Update preserved devices are
 in singleton iommu_groups
Message-ID: <acQbjF53aIzv7Ieq@google.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-4-dmatlack@google.com>
 <376910fa-4232-4e58-bf87-0504202866a5@intel.com>
 <acLRICLAP5Ccqt9I@google.com>
 <b16f93af-1ec6-43f5-b4d0-b1d390e3c23c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b16f93af-1ec6-43f5-b4d0-b1d390e3c23c@intel.com>
X-Rspam-User: 
X-Stat-Signature: yqpneaefndfpfysk8bj8qtt1c9j3wdg5
X-Rspamd-Queue-Id: A7C6DA0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1774459796-963459
X-HE-Meta: U2FsdGVkX19Bjpj0n6YGD1mTOV1WlsWSjrIYWoTvu5hRuUeWa2rSEjXLeXh92XBaR8f458vQTC3qZ3uErVEyloQm77O4gVwKbk5CU7Nh84oCfBs0ZWnCDjU66fgs82ug6NhIUYAYMLY93jHosysvyCjD7JfgMoHRCTNe7geDI8rchTJnBMGPA9CBczZUgFLrzL1jW9OR+1hoXjGyQHrzhHr581C2qLh0k90sLkBIr2My0IuS6aspZ2g1TIbp4T4yP26G8KLvJPu5XQ2UbAImEy3cbKH2BDMEbxeRDRxTca0v+K3l3LCc5VanzB7tpsoq6PVoA50JhcmusDSWPQiZEfl4jGysw9RUJwel27eNkrdtfcx1OJM590LA2P0zb1GOD4HGQhMSXmKDcwCfPN5laGqTBmmUbgoDEewe3pcH5Q3FVkKAsyWNYlhqIuf39yx00wENsvoNQGWfGEkpzr9le3dCosMDN88iGG4K0BkCr5Fn7GYHPzGuTP5XzF4y5JEc+KzvmsurDKP2AAQnr+GUCBj0gIEDvMmkeZdSi8clFqowd+NxP/8RC7USC2vh9//rPaCLlwv4NYJCPX0/MLNVaBot8gXh55h9NajoaFpvUAwpEzwBv6OJk13Y9aEK/nTedwh85pC3OpOBYYJ6aNVExP7fJ66lT26urLze4EVOE1LjdvtuZ2xejapmEzwdrlH0YzvoEtnQ01k9Iz/v4yr3KULTA2XTgYH0a0Ldg160yIQv48dwYwYJKJzsh5mkQVsjYiZ88i2139Sf466YPuIXIs16h2X3Bp4g1bYX8pE+qMkLYGoDy3WmWAX5a2AfaC5iVXsvXbHJXlWzZV9NScV4sZjrT6vFRIJQuqznCY3XTogD9JeRLGTqp+XWsKKsvtFArJ2Z9GTXIRKwOUaS5SFrkGVbK6cm2m+hNOeQj6KVPRc1WHGmC33xrZ0crIfTaTqtqPKNiwWl3yN3bd9Eujx
 TH65qFn/
 2DjVtCxN0oCyfdoIi0tY5oEszFJBYtzKeSWXd+fLs8F7M7UgWyqc3ohL0w93UdNCYgYqD3HhXRCY9jW5QvcyVNu/EEgX9KZYA0Zp4r27aRBdfl5M4536f7UdhfpFyJqTydVaOwQhzO9Q+4qrNcTbYorv1NcHfiGW7766fjgUYVyWqzDpz16/4e4zEmmEx+ldsHM10M9QdDnKb7SxPtc/eeLUR39hL6aAGD9vZST1mQHwN6ifFDYt9ni0vtW0k85AE83PZIQwmikO1/iQQAUPErjuqN9B/FjhZ53bRwqjGBgjJnx01JrDUcy3sgorbTjJ2QoQ409i7nTSzA+q5LZlkHnjxPoxG/6lzqP6T6UxoaBJkJMSAt5owq6dTY25IQw8splq+GX9vTRNwivXJAdAkV96RYJQ/ugBHUl2tLMaNwXnKHt8emu29UmK5Ond45AaBCza6yfMSTWCP1I3vNDZcqh/cEYDyIUXBCZ4AgcHq0EMbSm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-25 07:12 PM, Yi Liu wrote:
> 
> 
> On 3/25/26 02:00, David Matlack wrote:
> > On 2026-03-24 09:07 PM, Yi Liu wrote:
> > > On 3/24/26 07:57, David Matlack wrote:
> > > > Require that Live Update preserved devices are in singleton iommu_groups
> > > > during preservation (outgoing kernel) and retrieval (incoming kernel).
> > > > 
> > > > PCI devices preserved across Live Update will be allowed to perform
> > > > memory transactions throughout the Live Update. Thus IOMMU groups for
> > > > preserved devices must remain fixed. Since all current use cases for
> > > > Live Update are for PCI devices in singleton iommu_groups, require that
> > > > as a starting point. This avoids the complexity of needing to enforce
> > > > arbitrary iommu_group topologies while still allowing all current use
> > > > cases.
> > > > 
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >    drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
> > > >    1 file changed, 33 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > > > index bec7b3500057..a3dbe06650ff 100644
> > > > --- a/drivers/pci/liveupdate.c
> > > > +++ b/drivers/pci/liveupdate.c
> > > > @@ -75,6 +75,8 @@
> > > >     *
> > > >     *  * The device must not be a Physical Function (PF).
> > > >     *
> > > > + *  * The device must be the only device in its IOMMU group.
> > > > + *
> > > >     * Preservation Behavior
> > > >     * =====================
> > > >     *
> > > > @@ -105,6 +107,7 @@
> > > >    #include <linux/bsearch.h>
> > > >    #include <linux/io.h>
> > > > +#include <linux/iommu.h>
> > > >    #include <linux/kexec_handover.h>
> > > >    #include <linux/kho/abi/pci.h>
> > > >    #include <linux/liveupdate.h>
> > > > @@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
> > > >    	ser->nr_devices--;
> > > >    }
> > > > +static int count_devices(struct device *dev, void *__nr_devices)
> > > > +{
> > > > +	(*(int *)__nr_devices)++;
> > > > +	return 0;
> > > > +}
> > > > +
> > > 
> > > there was a related discussion on the singleton group check. have you
> > > considered the device_group_immutable_singleton() in below link?
> > > 
> > > https://lore.kernel.org/linux-iommu/20220421052121.3464100-4-baolu.lu@linux.intel.com/
> > 
> > Thanks for the link.
> > 
> > Based on the discussion in the follow-up threads, I think the only check
> > in that function that is needed on top of what is in this patch to
> > ensure group immutability is this one:
> > 
> > 	/*
> > 	 * The device could be considered to be fully isolated if
> > 	 * all devices on the path from the device to the host-PCI
> > 	 * bridge are protected from peer-to-peer DMA by ACS.
> > 	 */
> > 	if (!pci_acs_path_enabled(pdev, NULL, REQ_ACS_FLAGS))
> > 		return false;
> > 
> > However, this would restrict Live Update support to only device
> > topologies that have these flags enabled. I am not yet sure if this
> > would be overly restrictive for the scenarios we care about supporting.
> 
> yes. It's a bit different from that thread in which not only require
> singleton group but also need to be immutable.
> 
> > An alternative way to ensure immutability would be to block adding
> > devices at probe time. i.e. Fail pci_device_group() if the device being
> > added has liveupdate_incoming=True, or if the group already contains a
> > device with liveupdate_{incoming,outgoing}=True. We would still need the
> > check in pci_liveupdate_preserve() to pretect against setting
> > liveupdate_outgoing=True on a device in a multi-device group.
> 
> this looks good to me. But you'll disallow hotplug-in during liveupdate.
> not sure about if any decision w.r.t. hotplug. is it acceptable?

Anyone doing hotplug during the middle of a Live Update is asking for
trouble IMO. And it would only prevent a hot-plugged device from coming
up if it were to be added to the iommu_group as an existing preserved
device. I think that is reasonable.

> BTW. A question not specific to this patch. If failure happens after
> executing kexec, is there any chance to fallback to the prior kernel?

There are many failure paths during the reboot() syscall that can return
back to userspace, and then userspace can figure out how to bring the
system (e.g. VMs) back online on the current kernel.

But otherwise, kexec is currently a one way door. Once you kexec, into
the new kernel, you would have to do another Live Update to get back
into the previous kernel.

