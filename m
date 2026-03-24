Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2819FFEC0EC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 18:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9906B0005; Tue, 24 Mar 2026 14:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453DD6B0088; Tue, 24 Mar 2026 14:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342126B008A; Tue, 24 Mar 2026 14:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6936B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:00:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 960661A03A5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:00:09 +0000 (UTC)
X-FDA: 84581720538.10.71FC065
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 88EE91C0016
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:00:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MA9qKVSO;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774375207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oR1oDysYc7m3zFicPQmc7IfOCoKYgQXwHXDPwXVzCPk=;
	b=g9R/WqZplvkyQSYqUAlYliM17a9kMGPXbTFK4Lhzz+41zka5WdNWCJ1wosvbQY/TimmSfE
	byud9V1ZDVIlppowfcv3VJvcMjlq6cWm4BtrXXV/g/m4axT5vTQ/GeUYK5mILwVEfzSUBr
	dvARs/W2pPU7T5tCJpy75xBqunrzBm8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MA9qKVSO;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774375207; a=rsa-sha256;
	cv=none;
	b=DodvWY/FQYcU3q412hvrg4Kfft24EMV+dlA0nENakR8VgxcwwW5/WKsUa/UtsbIHEDy85m
	0i1+fJu1HRPvHKC37WdFdFevVjVjpY3PlP7RHQJJsXykE47tM6OikhdJY1dpL+Jg9J23z0
	ReE5tz8t13vcI7A2n0+O+s4oAqnDWLc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-829a9d08644so2404171b3a.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774375206; x=1774980006; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oR1oDysYc7m3zFicPQmc7IfOCoKYgQXwHXDPwXVzCPk=;
        b=MA9qKVSON7QYOAim7tv1BTpf5qltMCbVtJy3a7PEHlLb6SE1eRRNHJ7tGx2O0+nlan
         /m1E9B4PsbKSSJZOTgSd94KaVW/WCQEwVYJR+b1awrTEnNaONzcj1JibkI02HvgS1iU2
         bSsHrQk6J2fJHSjr+4/+wvAgolwQuu+L77ptTJ28yS8uL6eMHgvLiz2IwM5CVvm5RrQJ
         SVouRGtEEcHYdTJ8P45DKjDTUK4YsXWm8G9i9MGIKU7VZcvZcl5GLO19xB+TU5B/Q8oo
         ZZ4AFeG8r5/eAqc8BCFZwzuvknAHVtA3l/my32YztNkxYyStE0IYqoKVHYQHRDNMUE4Q
         BVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774375206; x=1774980006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oR1oDysYc7m3zFicPQmc7IfOCoKYgQXwHXDPwXVzCPk=;
        b=TaFuiZEstTIgV3BiZaINgCxroAo0lcwkIqfL374W6gfk1HEGaVSmiwDWRxSx0DE56c
         pSqb8e6xfma3XVcl4M8oHV90Uk1A+hdYASk1CzBrHQ/AXr66wntlplVnLknf+qhO2w1E
         go+741bDK/e/oC4enMx7ot5SfSjdUyCWV9ddY5rpA61sV1C/hhtQPWgC531qcUHpllk5
         /cD31P6Tw+7AwghSPuVzUAhAhvD6epmzPxQMgH/yrdokwYsNxHC87xUpuZKpbjLdKgVW
         42T3vE9SJ0v6jdQjaWwFCG/XWIFaVLa+izjAvJKBggdCWsQhzGsAc4l1aSdIyd7AEizL
         K0jw==
X-Forwarded-Encrypted: i=1; AJvYcCX5yx3AFCrRBaqDnrhl3DdR1SNWRXpNk/UMrkiWS9fxaCmpQVzRdS5ZidE2fkagiT5onBYGBXDAPg==@kvack.org
X-Gm-Message-State: AOJu0Ywyg5E/UjSfl/1a4N/i87X11hUKlN2cRJfWXvdxKoeNRRlf6kra
	OCVINgXPBOPCuFWRSNryLP1sXwExCmZNOFkafTFCR0phlFggK4VyYfBypMEe8p3KQg==
X-Gm-Gg: ATEYQzyTqfnojJKZN1Nz2ktJERxcYNilNG5lEcZ4NPwJEc5Gmj6IXljU5VlDUgkkJZ8
	udEzlIeBcJM5da4WTHFh4sStMS5uKKwhxQiu8M0oG+ciT2czh9yG9NE+30YTqJnCZt8NdxxCT5O
	izQKToJ1r0nGitnBgl8NH/PFYDiW/Ug7Qb/N/gv/t3pkoEfmf6NiGAUIuUiKUdreHHHyFd/rP0n
	TmX4YR14fcU2rAvTiykU8i6qmraVNmS8qTNfnUeXVLUyMIoWyS28pEywPWHpMyZ/n42ERYeZQ0D
	6RlUbkDoLXPtonzDMk1tdUv8W+MwYsI30vNlUfVfHL/4xyKkTlz28nyoqNpaJVlp3cXZ9psUqXm
	nw1OCkc9a1O6E+D7IXbxr3sYCpI+0znllWp3/O6iMwNFgjDdQ85F7aty2eTr1znaJu0Lm0D1oc8
	kgmxzUoPtFs/uT7h2BeeRWelCkIl6geSDQ9flTJvRTszrNGxaQXLE5iyFg934rLA==
X-Received: by 2002:a05:6a00:2da7:b0:827:3e19:574b with SMTP id d2e1a72fcca58-82c6e0bf7bamr488776b3a.43.1774375205765;
        Tue, 24 Mar 2026 11:00:05 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0421df0esm15901970b3a.58.2026.03.24.11.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:00:04 -0700 (PDT)
Date: Tue, 24 Mar 2026 18:00:00 +0000
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
Message-ID: <acLRICLAP5Ccqt9I@google.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-4-dmatlack@google.com>
 <376910fa-4232-4e58-bf87-0504202866a5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376910fa-4232-4e58-bf87-0504202866a5@intel.com>
X-Rspam-User: 
X-Stat-Signature: cax14m8uuriyiq93cbbtrcrz375grit8
X-Rspamd-Queue-Id: 88EE91C0016
X-Rspamd-Server: rspam09
X-HE-Tag: 1774375207-546186
X-HE-Meta: U2FsdGVkX18XbHIgS18+74YFIEq5IzsqExPJn+Zs71BqRRCXhrwFVM57bNWUQJNxz+oFo0DNM79LLlpFbslGUNeh25U03zGewufvH5Zu/TN3EmPFZ9skER6gOLOW+u2fd5Cu617vTIhknwovpvej/Pk17eIZmj+DZ2SbiEoWpZWT9cW9Co/8H6seswRvpJwKp6lLbTNB2H2GzbBTrqIl6nSik8J3VISLuZKcQV3LGotQcHaCHuThucMzU4TQZaJf1hb7Aluiv8epIEVIoJJTQ2FIf614p8nZSrwBwbk2pqUNxf1sQAxFN3kIkBLLRvtHNdNhoPRGxqGj80VzwVjFgNC1yGNHAnv8zwUgf71XctmRYakE3gE7eM8cgJI01epn6buxlJ2np80bX9q4smEkWAgs13MbxJEXj4+tQhuBSliSqnc+nuytN+6gMtGSjay/HYa8ewEKr0bsvfoLBB0i/bpCbeK6cFByE93MMq006ugRJA4W1bPPnkeVVuAKiY9ZFDUEwqF/ibG/VmDPaZnRjp1F5fzpUdZQj2FpEjcAn0lKA7Qg86Twb2pmOsk1bWG7YtXdjJRPP+tffMCkqlxL6loG2OZvuIsA2LfHG2DyrAiMg/qRmChyIvpmbBU3FruOkFBgwrnmwNXsLrFnbhmzOblIPZ4x8pE2w7Q+56RR+6+1I2hO78R/Avw4FLea8vrxBeRSrk3C1k4N+QtyL3F11SNvSlbY1yXR+JvwlDALM5n7AJxC7ngJQUJ1Zo/AY1WkG6o2kmQ7jntMWZMm8UDHhqkzCG2l6buhrAmpUuo5YAa77aSFs5msAE0++D8AOFvqjy42T9j1h1l0hcoDwp7ewqMDdxHZ603c0qxR8UKjpMaELau2qU7M7WZBNTiDvDQzrzIAiug4aj6S+O7NmUo5vEK7mxT3OHgOdfdc3AwNWHIp6q7Cq7YxXTgxDupqPZDnCM2Lu4UsXq5N9LMgqXn
 UZKY+M/S
 sjfR9VLIdjlmLgSumtQLNZq4HVH+T4H1g25S0KDc9FvNB3Vx31b89z2dPRgiAP5u4bYG3hpHMG1z72p7sRobFN1TKpvuPXQ2qtdQ+65RgSti4by+319fkJtzDmlLC/i5jIXTwt5EMXyII5R4nRQLiZY9JHKGMqgtk88ibsj50ogcszQhwHwSbptg3tMvO+VyHsyTwTo1vI/u+IHiYLbfMgL+1tGS4eEHK7R+4KB0nEc0ESTXRbDe01W1aHAKC/uXJiSYo83VN0L9vWv3HJDVZ6ojtGjjH5iAd5DpBkQm2cBCl5wIwZYqnLelEmf5s8o86Z1bo9zTneklRX71QnNk6c7G7OZ723PLvlTZOHjR9NP5uG5GTt6ofhTxH4+tbU+QDtl1zN7BOaB+Yt4DLfgMyT2rdlvkDjV/CV4EvOS/sk44j4ugawMaxJrHS/OUC6mLCjisY5PoaDrtxPe0fzfpwhsN5wJ19Y4YRsv9p0jprkL2KtCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-24 09:07 PM, Yi Liu wrote:
> On 3/24/26 07:57, David Matlack wrote:
> > Require that Live Update preserved devices are in singleton iommu_groups
> > during preservation (outgoing kernel) and retrieval (incoming kernel).
> > 
> > PCI devices preserved across Live Update will be allowed to perform
> > memory transactions throughout the Live Update. Thus IOMMU groups for
> > preserved devices must remain fixed. Since all current use cases for
> > Live Update are for PCI devices in singleton iommu_groups, require that
> > as a starting point. This avoids the complexity of needing to enforce
> > arbitrary iommu_group topologies while still allowing all current use
> > cases.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
> >   1 file changed, 33 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index bec7b3500057..a3dbe06650ff 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -75,6 +75,8 @@
> >    *
> >    *  * The device must not be a Physical Function (PF).
> >    *
> > + *  * The device must be the only device in its IOMMU group.
> > + *
> >    * Preservation Behavior
> >    * =====================
> >    *
> > @@ -105,6 +107,7 @@
> >   #include <linux/bsearch.h>
> >   #include <linux/io.h>
> > +#include <linux/iommu.h>
> >   #include <linux/kexec_handover.h>
> >   #include <linux/kho/abi/pci.h>
> >   #include <linux/liveupdate.h>
> > @@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
> >   	ser->nr_devices--;
> >   }
> > +static int count_devices(struct device *dev, void *__nr_devices)
> > +{
> > +	(*(int *)__nr_devices)++;
> > +	return 0;
> > +}
> > +
> 
> there was a related discussion on the singleton group check. have you
> considered the device_group_immutable_singleton() in below link?
> 
> https://lore.kernel.org/linux-iommu/20220421052121.3464100-4-baolu.lu@linux.intel.com/

Thanks for the link.

Based on the discussion in the follow-up threads, I think the only check
in that function that is needed on top of what is in this patch to
ensure group immutability is this one:

	/*
	 * The device could be considered to be fully isolated if
	 * all devices on the path from the device to the host-PCI
	 * bridge are protected from peer-to-peer DMA by ACS.
	 */
	if (!pci_acs_path_enabled(pdev, NULL, REQ_ACS_FLAGS))
		return false;

However, this would restrict Live Update support to only device
topologies that have these flags enabled. I am not yet sure if this
would be overly restrictive for the scenarios we care about supporting.

An alternative way to ensure immutability would be to block adding
devices at probe time. i.e. Fail pci_device_group() if the device being
added has liveupdate_incoming=True, or if the group already contains a
device with liveupdate_{incoming,outgoing}=True. We would still need the
check in pci_liveupdate_preserve() to pretect against setting
liveupdate_outgoing=True on a device in a multi-device group.

