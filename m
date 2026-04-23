Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD79FDEE28
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD46C6B0088; Thu, 23 Apr 2026 19:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85CB6B008A; Thu, 23 Apr 2026 19:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973F76B008C; Thu, 23 Apr 2026 19:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 835B96B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:27:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DC7212060D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:27:53 +0000 (UTC)
X-FDA: 84691410426.21.793CF39
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E282100012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:27:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uVs3RCZx;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776986871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lt0LRXP7f5oacTu2NcOl/7iPlzf9+apNICsUQAZ1DMY=;
	b=Wr9fUta7qiik+ox7n+sdBG6G9DTXiR3IQ18ZvGUu9ypFAu8toGp8jz0p10jQYPrxuWnUuY
	SbeJVYqztKyRRpGSyk0JSmT1hOiGkt4g85mO52MASkGKJZx5ebl7DgupnHLcK/+5L3IxcU
	u8aTo3A70HNqTTuX+owCjK7DNEEOAN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776986871; a=rsa-sha256;
	cv=none;
	b=S4RijFwnsuoiTj2ddhmwz7tDRti6e96QG/fiyNHvxLqLSeJlMPWMqNQuFtDlTpx1J97dxH
	J4tSPK31m/nCCFRdLcTAfVHH7f5Djy6DO8UTd0BtbRn3gf11uTH3UmV6UODqKabolOyDoH
	wdKg6r8jhxNSAcUkjPFXdm8Csww5voM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uVs3RCZx;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b243198058so187555ad.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776986870; x=1777591670; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lt0LRXP7f5oacTu2NcOl/7iPlzf9+apNICsUQAZ1DMY=;
        b=uVs3RCZxbndtzjxmjeR55ET0QTJn9T6axmJl/qIF54kGNWzZOoQZq9gDOsPpNNnSu+
         aDGY6DN7D4hXkSUTIesYXuys7T/mo+/HUY6Zl/HBwDFiRKBkzF9c+YafzbUUa0eYEpfo
         0JIoLpfczXg4R9f/au+ospWETyBcyBB+H4v0orffr9IOn8fRAKsdMzlEIubp3bRLul6M
         4PY8i1XbO8QEX1Awz4IsKQksEgLAkbKXUpytn4iW/DwZNBX6xTeGVtOZOfVu+yHBeo8b
         B5w+E769FqSpC4sN7MMF70Ivh2z1PGvebrm+6TyOQFDr3zSbZ0Vi7Tztsh97ZoVhSgp5
         2O/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776986870; x=1777591670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lt0LRXP7f5oacTu2NcOl/7iPlzf9+apNICsUQAZ1DMY=;
        b=GQjzyy+ACKfgyZuz8zvtxg4q9Ih0rPhD7YHBdW03xrZPdDqZI2JCOoMvvwjd3Idx/M
         t7S3FZh+SPdO4sjCLZIvUHBxwA93miEvEFNu3unhrnzmD5hNnnc99Y6qa2XvpmV8V1tM
         Xkg8uZTc5r2se40V6pfIRfPy/XdPKTAX1Hu3Jt1y5MYMszST0NyMNtNKvuMEujw1Jm6d
         eMbKQnh8w7q989k/l3rpdS3L+iGc0RnYTUzlL1lW2KfXEAqpqql+bk1oL5vPNpWqCAA8
         lJUX9LYQQ0rahB8SCjS50fME/07+vfEI2McJFvbia2XHNhqH2XqwIHQ6Y9I0MKlc1FeK
         1Qpg==
X-Forwarded-Encrypted: i=1; AFNElJ9wc8i5JabsA+W+c2/mehrcF81BG/LXLGMv/jv1O3nYIxOV03PdpTKDIQ6y6qr0PKoRy5fX58UezA==@kvack.org
X-Gm-Message-State: AOJu0Yyuh4B/u+O0tBPwuho8E/lhthUezOxRs30AfFeZvCvM4Ecf8sX8
	x2ISmqG2WobF8Bg0iS4tdwnvvAxHK2m+a/LpoRQS9fmmsdomuQ5prCGskRFTYVeULw==
X-Gm-Gg: AeBDievvr3H87fz+tDN3WdhDuWC7UhJU+DagAL3Z5LkDulbqAEGFPHGjmyesZo9UqBr
	7Vvt+1DmwRS/IL4usUATwtXPZFcGyZ07nUFhN5GQRqnYU+XTnGgTWgqWXN1Y2nmWwkzzcEUBIVC
	pQwcgWNpT88zsXfSA7RpEW6vCvzJpk0AhVNl0ao+e3rJkcIfiOGsEygOju9PfVfTOi3Ti6W4wWB
	IgMDZWnjvgKYFda5UPFN0I2RP70eHhbv0toigap9jrwx7TpFEhxf8PHEVKjSed/5EU1Achh65Uc
	OG4yjfNtEzHy189cuZGzR4hwkY/M0sO1McTR01Wldyp8xpicfc99VlC9DOKzc4DG2lhSUtEiJzT
	n6pSU3IkpKB5t6EIansy4n6fx8G6gbRBqcTKEmK3c2/rbIYQgi3jC0HtgtHU2CqhNvXQLV+Boi2
	yTvzQJC4AVVm1XUaZ3CUBTufNyv2mNvXjR+SOMZqPlm/upCDgGmLCPxGx9DlW2xbtyhk0Uy2mJF
	tZu/D2OIjA=
X-Received: by 2002:a17:902:cf01:b0:2b0:5e19:1862 with SMTP id d9443c01a7336-2b603f4969amr20900125ad.5.1776986869309;
        Thu, 23 Apr 2026 16:27:49 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f9cabfsm18153636a12.9.2026.04.23.16.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:27:48 -0700 (PDT)
Date: Thu, 23 Apr 2026 23:27:46 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
Message-ID: <aeqpJ7BeBtzoPIx4@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-9-dmatlack@google.com>
 <CALzav=dGpHEnEjyp8qc50iZrGeKJ47vjLvwtvkLCyNzOMJhozw@mail.gmail.com>
 <20260423225253.GA3444440@nvidia.com>
 <CALzav=fraXLgGs-XMc-=whMPhMbS99twFskGtV5Eo=UQ9mU5Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fraXLgGs-XMc-=whMPhMbS99twFskGtV5Eo=UQ9mU5Fg@mail.gmail.com>
X-Stat-Signature: 6occ1qauotxtfzjmjcyskicwmpybqim1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E282100012
X-Rspamd-Server: rspam05
X-HE-Tag: 1776986870-821163
X-HE-Meta: U2FsdGVkX1+sz/O4fivpA5V+TnI1qekq2P7vkBsMJTjG6ZC2JawzrnBtsXAIgeuCL4hwtXJUXCZudY+fYlIjKVd/oyGGVrsrHnWQeHxxvPEUgqVyjbgdcWQ/8IC+xkCmYQgkzUl1rZURa5UjUHAqnM8wyv98UA1PDiHbO6J8xH9qImQ/0+47eFe1cX06dq3D+t1BzloVtskcmsmBiXkI9vrY6khv9+1Rux+PBMPkCnJ8qXBmWCOlR5ImF1lg64GbRyE0idUCFecGteoehNJt/832QHrHhc1ZSPinG1ECaWywfxt+bf8r4YP0zhQgS8gJglnF5XYIVcTPB9hRWRla4JzMkwiLJi2sE4OLnuBw06EoPCl98rdYgd/j4hucnHQL11uoYegBK5xHIrfnEVh0Davujy+zLjweFaiNAoSReVUE9cvwAlc6QmxyRKXu7v3cD3zoU6G4FHsmBrIpXmoegklh/SwBlaYRFATGaC7p5btddUfLVKkR/FszKq3QRXpugVIkWSxyIMPrXD8TUhJQtMMzg24yaw1PXQf5Z8bzZbKqiaEzsdKZQ9ZUQOSigmjVertfEZi8pWINbEoJY8GV+YHl24eQGOLJqK4U0nNSjmSUi848K002rovMHFWV/BJVqdBPeqpuk8gxchJM31AZE8I/Wv01RthXNIregXsAz+fEVPt2B/KW8vY7vOR+BFyAxLGHZ7UKTppUFQD9S38SWALIDwtEF2uSA5CrUII6R91cLXEe9FsbvY/RP02qgnT46lXGGAWnefTpGRWg5YbM3JyJcm5h7Ui/VxFRY5RiW0YGkNAoLXhJAEPFofI5crafH4T6x4+Jzih8WmnikE74ci04h/4xRe0TTG/Dos0pmFQMKlvBioiImetBbyHgmVJx1rVF4OuPXa1h8wV/cDin3CHdsBUCaDRkSc1P6TP21760lJeXAuAEIJmrPgm1MEk4TtqQTVZmsLOYRso9rtB
 PPE+7lcX
 ANxJ1QOJXr+YokD8P/DJH8+Mtxr20s5e6dqFWEHU92g8/CB4dl8kx60LZ7IZlRM+v6JukmCtV+OfT9W8OUSy0UMAw9NVcqkmnrNWehg9nPOC0c+b/Duw7MxFOOT6cBHz60Fvvk6gx0D9NXCUP5N0BjKqtAxMgCtJmkuo8iCSHutLIU7PVYcb5t5mope3qcuYTlJe7itCV0sKrp4Cb30I9qybTuM/Q6yVbMLnHnGsmutRxfeZUVCreRp2pZPEoEnGvlPZ2PJ18SARFVZuSaizDVuMmOU+a2iauVB+nYs3mPv1OYdJZv7fNUxnf9A4oALfSJ3dFPJSLeRMlC+nPL+Ukrubvo9xGWEsVseWHPN6nxmxYju/DD2NhSg7XfHR1DglzmfUyHoxnyQkgDs4aBZl1myV8p7A0sN1LHBRTwmPci/GBNaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 04:09:01PM -0700, David Matlack wrote:
>On Thu, Apr 23, 2026 at 3:53 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>> On Thu, Apr 23, 2026 at 03:10:55PM -0700, David Matlack wrote:
>> > On Thu, Apr 23, 2026 at 2:23 PM David Matlack <dmatlack@google.com> wrote:
>> > >
>> > > Restrict support for preserving PCI devices across Live Update to
>> > > devices in immutable singleton IOMMU groups. A device's group is
>> > > considered immutable if all bridges upstream from the device up to the
>> > > root port have the required ACS features enabled.
>> > >
>> > > Since ACS flags are inherited across a Live Update for preserved devices
>> > > and all the way up to the root port, the preserved device should be in a
>> > > singleton IOMMU group after kexec in the new kernel.
>> > >
>> > > This change should still permit all the current use-cases for PCI device
>> > > preservation across Live Update, since it is intended to be used in
>> > > Cloud enviroments which should have the required ACS features enabled
>> > > for virtualization purposes.
>> > >
>> > > If a device is part of a multi-device IOMMU group, preserving it will
>> > > now fail with an error. This restriction may be lifted in the future if
>> > > support for preserving multi-device groups is desired.
>> > >
>> > > Signed-off-by: David Matlack <dmatlack@google.com>
>> >
>> > Jason, do you think requiring singleton iommu groups is still
>> > necessary/useful now that this series preserves ACS flags on preserved
>> > devices and upstream bridges?
>>
>> I have forgotten why we introduced that? There are alot of funky
>> things about iommu groups that might be important upon restoration..
>
>You had originally suggested it in this thread:
>
>  https://lore.kernel.org/kvm/20260301192236.GQ5933@nvidia.com/
>
>> Like if you preserve one group member but not the other what do you ?
>
>Yeah I imagine there could be some tricky cases there...
>
>I wonder if PCI core is the right layer to enforce this. Maybe this
>fits better into Sami's IOMMU core series since that is where all
>those tricky cases will be (I imagine?).

+1

Also I think this should probably be checked by iommufd and invoked
through vfio cdev. Basically when vfio cdev calls into iommufd to
preserve IOMMU specific aspects of device (PASID table etc), iommufd can
check this and return error.
>
>> Even if you have ACS flags there are cases where groups are still
>> aliasing DMA..
>
>Hm, if a DMA alias can be created after boot time enumeration even
>with the REQ_ACS_FLAGS check, then
>pci_device_group_immutable_singleton() is not really immutable.
>
>
>
>> Frankly, multi-device iommu groups don't even work fully last time we
>> tried to use them in a VMM. So I think I would not expect them to ever
>> intersect with live update. Blocking something tricky you can't test
>> does seem like a reasonable thing.

