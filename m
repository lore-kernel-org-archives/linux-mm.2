Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4100BC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2175D6B0095; Tue, 21 Jul 2026 19:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF526B0098; Tue, 21 Jul 2026 19:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE9C6B009B; Tue, 21 Jul 2026 19:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2606B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:47:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C38C802CE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:46:59 +0000 (UTC)
X-FDA: 85014421758.08.48EEA53
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id BDADC8000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:46:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CPAXuxfZ;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784677617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAFJIXu/UVteHEvaICMncjgcIn69HtrYqtQZR1t34RY=;
	b=1YbN20nOa8FoPPr1lSq2kdRn20UHgi03qnOtbJAhnP7XpAnf4QEH1D5ms9ukT75LzySOc9
	U1zNY2Fkfd8z2Zz4vSJzt2eeToM+jYc7aO5r8gZVSX3Dp+IxkPETDfgLWlHiJxwAzDDER1
	l/TxgwL5GrbC3npAn9TzYjDtheaAxiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784677617;
	b=Z16bkFEAMtwvOh1cONVOeCGN9lyj7qGMP0mrlAtu1LmMO+AjtMGBN3+Ne7ujKcSxwGLzQ8
	FHXLy1ohGZqSnDbrlG+Nwbck0+tNlEqi9hsgvtlYMI7srf5Pg7jcfUdciSHsloAHGQgmru
	sZsizY/4M8UntpffCsJ1iblvhZDUEDs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CPAXuxfZ;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-930f4e5eed1so21455485a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784677617; x=1785282417; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GAFJIXu/UVteHEvaICMncjgcIn69HtrYqtQZR1t34RY=;
        b=CPAXuxfZwQnEFE9zyNsvuyHS/wJ2VVzLBNfWIXnV9AnSSbgmip+0t2t1ygj0DgNUpS
         cUICcVxout6c1TaMBRyMR60JNip6hPg2DbaV4cR99/gsT01aD1BUEddSGB6M+UHsIKFO
         DvKGGq4EY7nQVoC2P2hZkw32OxCeXV+HSIUorswc7NTYSiYzzu3U5ihXS1Umkx6V7tUK
         yh9isfAKtcMS7GnSI0iAao0HqDNtVCKRa7ZiHfZYik4C5aYGMElT87B+W+7Y19KKHyQX
         nNHPZjc+PqVftC6vdpmoSWuLF7MlXGrPx64MKIu2wSiSRIMRXU3Xx4LIU3NMFm68gKbT
         qO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784677617; x=1785282417;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GAFJIXu/UVteHEvaICMncjgcIn69HtrYqtQZR1t34RY=;
        b=oSm2AQOffpZhOUD7awM9QfsyN7sr2dGow+aOVM3TBKHbWV33UKsLEJ49+YTPPq3Mlu
         6Q2Dqo2Bat7q/Ai7jW6dX9jaqpz+JWJCigFFmRqgRqMcIOm2Qm6YPVAwA4zEt4KC94yt
         8Ulbx9vKxW8TGDvW5aHmGaxzLzzewAqCaUtGA8G/OtsGlPsMeCGVEreX/xnS3HjzI1qp
         b9IuOmyZXCFjhFGtt7Glj64ueaA8xo28+J2s+XexqmPUJSocJMYYKnEMvoLb1SAi0q+O
         +DRMSkDqwf1Yc+xns4IqYyW5t5TMymsQ+pnH+ESnuO1VpPZQerj0HZ5mua0hy1JLPdmf
         fHGw==
X-Forwarded-Encrypted: i=1; AHgh+RrJ3wCvOoB3LW7w9p2xNbk6hlMDrcJHYuU77ctilauZtNG0WwPs+PKbRqCSg0FI0ve9nzgpkjXpGQ==@kvack.org
X-Gm-Message-State: AOJu0Yzq9shvhGTKyls9+K7po/AzQT+6SQiVx8M2RItGGjdke+ukNOGs
	zD7sbHvQRYQRIVKllqYWwzTCHNUig9eve3OCLLFkY+notARavVFSmuxOn2xPcl9ajNM=
X-Gm-Gg: AR+sD12YgBk76hzDaPvhZoaaKzMYuRx+WGKuovF6ANclFYBZAOwAGzT7WaluLkrno8E
	Dhj6Jay9lVo1t9Y3bjZPenM3qA1qSuqrpfEcpF1vjxLalLwMjCsM0gnvD0GTViKcLnSQ10Bl0bR
	j97jGx1qDrw7sO9JbIedpF5ZkVta4g06UnbfW1ViV/yhQzsJY4m9S2fE1XHN1wTIncDp0+F4XD5
	eQaiulHc0jlKjYur3AOahJY4zTe6DpPlB8msZ1KMQn7tVc8knK6nc4ndJJUJF+tA2QxUVMA08eS
	S/N2Z22wTjrQxqLjhiztfUmxKS0DWMGogZgJ6cLQFIdjJiZ3h/QOEuxkqhZo5fe5JuCUq+NFnLB
	tK1jN6ArTzZm41enEr6Vr9wVVnxxqzEAdhNb6ygJ4gj85y2m2ghc/g5gb4bfFeUaXI3/Wt6jCbo
	rEypCQf+bfMKm3ns4TC/ca/k0+3/tXPw==
X-Received: by 2002:a05:620a:4546:b0:915:9fba:8795 with SMTP id af79cd13be357-930b3ec6bb6mr2023091185a.1.1784677616667;
        Tue, 21 Jul 2026 16:46:56 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a41180sm18815485a.34.2026.07.21.16.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:46:55 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:46:53 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <amAExy1vqMbx31WU@plex>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <al_3nOssZoa6RoCq@google.com>
 <CALzav=dvc_bdmFtV1U2APfs1FM-6Zi5=VShcAYQjZ0wwNRfC-Q@mail.gmail.com>
 <CALzav=fYx7R7c6FTQ5bC4bbQ+_KNaC3gopcPihOtKmHGaB6s1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fYx7R7c6FTQ5bC4bbQ+_KNaC3gopcPihOtKmHGaB6s1Q@mail.gmail.com>
X-Rspamd-Queue-Id: BDADC8000D
X-Stat-Signature: iins46fwnop9fhkiidj5f8bn1p46h6ja
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784677617-285488
X-HE-Meta: U2FsdGVkX19JoG1oUZb9D3mW5wqdeQCK9yZlDBeU5wXDoUeXyjzXLd5KJztaML3dKz14KBdR3WX+TiqCL9s4+khs5ucZbPFzjfBWOU11PSu/c4sXK5+8rOE5WIm+XN/yAp8GsHLy5UGUZeVkqf7t398Hv805IXelDW8KuhzL5n+9y3VXeqGcnf6SMmLilpJiEBMi4O2kD2+mgJWLxfe+uE8GKGximpqZbK6twN/ly9GvRg1U4RejIgcBO4kqdw8wbT2lRaRJGueA9Rqs3FJ+pZYXV7acXFwZChdZhv+dh2w4VwNFO0rL/vefDuYrGv299jzBAGNoZ30q3+iy5DNQRuIOI7VTx20I0XioI/zA580WGE+jpwMihjXM3ID2U8RU2GEBdVqWmL1VUqcnc4UoxUZT5M3MYZj//NJZaWxI2/ZUDqMyRYk5YoeVfe2/6283Sv07D9jSdfxAuchJSv0ofbd/ZHVe8dcpzO55KpVaArsQT1yEAvSZKqyxS/PtDGZaWZwrh1RVKqZjHms5bqBJA/RfWmjQyylvyQrEG48UKgHgcDexWdqAKWbmSjrDvAgV9YQNLZ06pdBWYjbmPxXYs3TuNRvVoDJbYheovC4tElYLB5vNw73ZTVWIOt7gUscTRb3rbWp+6Ap6sXAjc4CpWz1Lov1cAseSEnMLkb4XF41w4pG5Z5MPO/XeFTe5s0xKyzwLLVLzNoYaS0QPuxwupHIFbnK3mtbzIMW94qrTZyFGsMx4BQ0kD5d9z/BHQm2VeDbx3I/ShvJW7vUnfGwlzKG8Ee9Bu3x4o2pbYOM8oLA0GgZwM6rn6jEy8UAthHUivDv8amMOJMKsWWFKTjiXFmergRAsnmo7iM+s6LGnvOHDogtm0+nduIgDRrT3XSXnsezmhqaXuZxQJDn8C09UnXiSq+YFHNEyxXnNdl4vqqJm+t3tJnb7RHG4gVGUiH0bIfs4mXv70QDZ/4ykIRW
 gEb7mFNd
 uSq8kg+rSO3dPCVTwjaorFSY7NydSgQWO5DdaJ3eXm9hXYQpjPmCwWCb9iB0VXI01IwLBF1FHgWkGdYWmanTd9/daGiDQYBU0VA/ZI/VCqOwnl9m5orHlMLjBKYygxDQxr0OGU8cb0sjC4qWv63qjz0FK9ZdERytEnJx3LT9pI9jCYCUuRvfnMGYUGCEeeDaHa4STTQR27gpSJhlhaqkYCT0ZCQRNOQQ9QPK8E0pxZXLEveCeSEpHhBpczF+LckAfz6k7QQv11aLvfvDxYu6/17AVVYSxY+dbBScutOZpvqmQPgAsyO7xmsiWOJshNSKdrDK+xK9mqN9vpnUs3jTkUc0Hi9LtQrEOdJ2SGqQnrCYwGa0MDAIwb9mnnEDnPYqIyosnhRVYCyT2oIDdBaj1eG9LA2clMPCHGj9YxwpvYNA9Vps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-21 16:18, David Matlack wrote:
> On Tue, Jul 21, 2026 at 4:16 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Tue, Jul 21, 2026 at 4:02 PM Samiullah Khawaja <skhawaja@google.com> wrote:
> > >
> > > On Mon, Jul 20, 2026 at 02:54:51PM -0700, David Matlack wrote:
> > > >On Fri, Jul 17, 2026 at 2:47 PM Pasha Tatashin
> > > ><pasha.tatashin@soleen.com> wrote:
> > > >>
> > > >> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com> wrote:
> > > >> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > > >> > index 03075ce06ac9..df6a02240aa4 100644
> > > >> > --- a/drivers/pci/liveupdate.c
> > > >> > +++ b/drivers/pci/liveupdate.c
> > > >> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
> > > >> > [ ... skip 76 lines ... ]
> > > >> > +     /*
> > > >> > +      * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
> > > >> > +      * that dev->liveupdate.incoming cannot get freed while the PCI core
> > > >> > +      * has a pointer to it. It's better to leak the incoming FLB than do a
> > > >> > +      * use-after-free if driver does not call pci_liveupdate_finish().
> > > >> > +      */
> > > >>
> > > >> I am confused by this. Each preserved PCI device must have an associated
> > > >> FD preserved with it via LUO. I.e., vfiofd would need to be preserved. If
> > > >> the vfiofd was not reclaimed, and finish is not possible, that vfiofd
> > > >> would still be owned by LUO, and therefore PCI FLB refcount would stay
> > > >> positive.
> > > >>
> > > >> However, if finish is possible, and this is the last vfiofd that is
> > > >> finished, FLB will be freed as soon as the reference count reaches zero,
> > > >> which I would think is the expected behavior.
> > > >>
> > > >> What is the point of holding a reference here, instead of only for the
> > > >> duration of FLB access, i.e. to make sure we are accessing a valid data?
> > > >
> > > >The duration of the access is from here until pci_liveupdate_finish()
> > > >because that it when the pointer (dev->liveupdate.incoming) is
> > > >cleared. So that is why the PCI core holds the reference from here
> > > >until pci_liveupdate_finish().
> > >
> > > I think LUO gives you guarantee that this pointer remains valid until
> > > the FLB finish(), because all the vfiofd that were preserved have not
> > > finished. And when all vfiofd have finished, LUO lets you know that the
> > > pointer is becoming invalid so you can unset these in the finish()
> > > callback from LUO?
> > >
> > > If I understand this correctly, I think by keeping long references until
> > > finish you are replicating the vfiofd bound lifecycle that LUO already
> > > gives you.
> >
> > Yes that's right. I am taking the approach of not trusting drivers
> > (i.e. VFIO) and having the PCI core maintain it's own references so
> > that FLB finish() is guaranteed to never be called while a device has
> > device->liveupdate.incoming set.
> >
> > Alternatively, the PCI core could avoid taking a reference and instead
> > check for driver bugs in FLB finish(). I previously explored that
> > approach and ran into a circular lock dependency between the FLB mutex
> > and pci_liveupdate.rwsem. But I can look into that again, or just do a
> > lockless walk of all PCI devices and panic if any still has
> > dev->liveupdate.incoming set. It will only happen if the driver is
> > completely broken so panicking seems fine.
> 
> Pasha what do you think of this approach?

I like it, let's do lockless sanity checking in flb finish callback, and 
avoid messing with references.

> 
> It avoids the PCI core taking a long reference (your conern) and also
> avoids the PCI core needing to take lots of short references to access
> dev->liveupdate.incoming (my concern). So seems like a good
> compromise.

