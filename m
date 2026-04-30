Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53ACECD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911D16B008A; Thu, 30 Apr 2026 14:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8236B0096; Thu, 30 Apr 2026 14:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF166B0098; Thu, 30 Apr 2026 14:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD3E6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:25:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 050901C0063
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:25:25 +0000 (UTC)
X-FDA: 84716049852.07.A353694
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26C23C000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:25:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QSzBFntA;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSG/yM4Jbprzjr8hlewRTOp1V59hFoclV98ulyGviIc=;
	b=aXmfX8tbxHQgZ3x5PxvYOmfquUspYxmtz0Wj9mCxRhrKpUOhUoxwwMGwwGcl2BMOB68lnP
	c3r1KGasywJOiiEHVKDN/cUjSH/V5YpJNDT5Djyg95WL+mmEBbrSe1penBgzppiBn5YgGL
	/DO9QKx4ayVTT0UjTjkLYZoGLVPQdDU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QSzBFntA;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573524; a=rsa-sha256;
	cv=none;
	b=ksfC8PoZY/CpH5CuKOyeD7ty6g7ghCpjObbRc0hYtzUTpebfIL5qsAKZNY0tak0EMpxoQm
	UP2KQmO1EZ5kQSEuZErRfY878Id31ZSsmmhMwbJBqqWrx2vqyKzErOg9VMIBSayCXadwbr
	+vGv0SdHdm4uSzftHXl3BPDMjkHPZ40=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b46da8c48eso18945ad.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777573523; x=1778178323; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eSG/yM4Jbprzjr8hlewRTOp1V59hFoclV98ulyGviIc=;
        b=QSzBFntA21XE2feUJZlGEPrMbarlC/fdHlvpV94XhXupofOWjNBLCV9QatZO/uKjb+
         VobCzh9N40y5/dVpkIwCsa30vdNJlTCWbJVbf10Ve/bJ8iFNU9asMhnYtNHaIe+YjB0v
         jdr9q5Irx57NvJ2JVQhpkKb9gBQP/FHp1DISmwx8FjnTt6DtcUoDwTtPU9p5K86rZJFR
         n04SIHGo/ebG1xdjXXe13LGp6E/gjBBGXZ1qbkkggTUxh3Az0J+4QsuSyyNpi7B8o/BN
         KQnibJrCKIx3JkFBUozcNIFzD01qBij0HDSQQnbZ0MRPoxFyjA+u50pIkZhRqnAcbJf9
         tCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777573523; x=1778178323;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eSG/yM4Jbprzjr8hlewRTOp1V59hFoclV98ulyGviIc=;
        b=UEGZiMm0vajvyK2axsUXrFumA0SpIJfrZ9l2UTguFCRmgAJEe/pFK3vWFbMXnAUL68
         sE4yRqEd8p7oGbCXYrKP3DPOY/utHDFy+BRjZ6L430ceoActpEbfqUlrdh0TbK4Q9z7C
         CSlT+UO7vy/6t0YnRAaqIgJ4gLSabIhPZD6Jka8tdaowD7yeQRBSW/10lwEQFsXtKqIs
         GnEAVhSTKXdjtGS+B08spl20x/ckFm6yG2nVOX6PPdYC58L5dpJJLdN545JceMi6Vgyl
         CHbFz95sDBXZktr2mxoeM2aRYKrhu+7z8OzuUWu/nty3jCpV0VZb0+/MQ3uItb3R21RN
         f4mA==
X-Forwarded-Encrypted: i=1; AFNElJ9P1ThU+dzOk+Dktr4wN8qy0hWa/zhfNLEI6xdLWUC5vgobSLM46bf4jXz2b9o5myqtf9675ylHFw==@kvack.org
X-Gm-Message-State: AOJu0YyD4BslW1x1G++cmt+vFFdpYcExJ8dnE3w6CRt8LitPglDse4xq
	kRuKWm1eV1YMl/HlWK/sO+KcZwcsOWACNQ4PeawJo21RYeQ9uqBSj7BTu1jcAaBAxg==
X-Gm-Gg: AeBDiev/c4By5Z4tkZNuEo4kLphdjgtqxoZFN7kg5nsIFlJIEvalo7n0vBcTmTVzy2T
	FTeAX0Z5b5NSzvwp6Yp1d3Kw1u6dPAQbXTKjX8VC2F4gKe6jUPCqPBHP3REJ9iAWmolmBe+LgKh
	LA7SDcgdsFm9RxSNLn6B96vmsfK3wzIk7d6iO9qpkqMDMQqEjOUFnml0LwbYkSsnRuN46U9FDHV
	8RWwKswfLKKVHmvK5hmMKnveNOnZXWPNbv20PcXdco6CIBceTPxVe527UMG2N7ceQRJxProDCOo
	dwqr8cpWyIsjZ5RkWIxYI7xuLRMCHR0B4HoBxmNTnZIRyDyhfdI2R7SQfablq5RVDoUB//m+lhM
	xXUAeQO7rSBk56efbq+GGyr4gRJ52RaMepVoKR0NxepP3mXEqPLmCyfB+TzG4es1PVlkVZQhggJ
	BXwy0Gk7hM1nFS1bOJL+ND0gEQvdyD8D2XBF4wTJdtMC6RrsqVdNSaVjjGWexXvBY6kZsK2fuU2
	FvpkkE=
X-Received: by 2002:a17:903:2a8f:b0:2b4:6153:e541 with SMTP id d9443c01a7336-2b9ce26a5dcmr69445ad.3.1777573521791;
        Thu, 30 Apr 2026 11:25:21 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7ffbcaa477sm278266a12.31.2026.04.30.11.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 11:25:21 -0700 (PDT)
Date: Thu, 30 Apr 2026 11:25:16 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260430175916.GA13902.vipinsh@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <20260428201231.GA3885809.vipinsh@google.com>
 <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 26C23C000D
X-Rspam-User: 
X-Stat-Signature: j7njz4abo1nj3ig7dsjhb7gqdqoougpb
X-HE-Tag: 1777573523-455808
X-HE-Meta: U2FsdGVkX1+Gyppvv+oE5lffB5d4GQ+3iRbvtUIt8CPZDa1UdkzXmtXaFoqgVwbI2DPU/KWS1l2xilBrHaJFFwuqUk8AORKG75gHeZ5e8mCCCj9M9jN+8qxIrZG1YDGCBHRyVDaAGzCorfapSV/u113iR+LQI03DKscGxPE+Mi9pRQcCYJBle0MvKh2/0fLdYTpCZA5f3aUVd7j4meYO3lotmcBjDzG5Wfi0YDl9ZWDjmJUurB+liCEm8KDGbdVZyc3IUc/kaie7XMBMby8khPvvhGmjzpFGRn/NlbB67kWPz0jzRRmoOD0uUPFFmxhWYPO10wsn5nWf+9fndUnwGup3CitesrAPKEA2JSyaPy5JfYSSLAcLv1V7lMCHiBBWAo1BHEp6V4/H9ik5GqBYwOUxZM7MuI+ItMITY+HQ9k3BPz/MHhZtQ6ZDhH+uPd7ij3O2tZY6KDcZ1HO/VCksHECaW6TPIBQhTi/0AXBHcx5uD84g9ENJLUcVs5EOeRJK8gL49c5sxuFuXBnelCDUzfUceS2ZwnRcTNqGXEkK+gHhx3uzyWMDF075pFT4BK5X/4ImEw/J1BYj2IYFcT3UBRj00Ra0+I0o70XvodQ3YMEleszPKb5r3mOBG8tI0GAU6HdaJOBiUtbEqviZgjUr2/9oriOdDdV+9ZMeJadUYBWajSEMlR5Z65kBnIBwBiRhGZZd8TMf0tnd1V/FWu/+IXluZBfIRUjIHUH6oW6UgLsshsifMMibMt2E1aobu0EcDRQbqu/GV5NN4MH5L+ANuqYQF2Xc5Z1giDWcblZC8RlY8R6gaQeuKUMD8+2da+CwZvnQVwQ0tOJws3IHED3Q+3P3ENnSICJWYzRCJttiXJBNy2KhXIr0h9OAaHygiyv3c5Wh8kDnjwe4rPw9ODGJOa5Hrdm/IBYzfZ7V3vzkrqR9xwWWKX9DwvUn6L+oqf2XrwTNxfQE9HNDhtYgpjh
 7O+wZHiE
 foYwWjiGy9pSb+kEoC5rjbuhidCA/GJqYPhNVC+yhzcbuJQZSNwhQrQ/pFVHVL+WHEKZLWnQdP4IKM8pmff59YFaqy5VHWW2bdMSizWWAchGVZF7rOMX6SNZdCc3o2ajxsiTJbv3pgTYIqaTKRlI1gn9yiAa0mo5LoXit2TuNzEstuFFa0oNJtdREIQmd9ZjmVmJIXFmrMrhKfUvi+yZ48lJ12GFTe2I55lLseIQRN9nkbwTpbu9gJTga8GXvoq3wE0KDIWdpztXDuGK/NLaCwL8FzNeA2geEVU0OeDspAddHbT5YctHfZOli0MvXMTqdyA4q6lxT+qnwNd6y0Krzlx/v/Pv61asEhFbkG3oUEhs3xJOzTvCIEfLu5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 02:12:13PM -0700, David Matlack wrote:
> On Tue, Apr 28, 2026 at 1:20 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > > +{
> > > +     struct pci_ser *ser;
> > > +     int i, ret;
> > > +
> > > +     guard(mutex)(&pci_flb_outgoing_lock);
> > > +
> > > +     ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (!ser)
> > > +             return -ENOENT;
> > > +
> > > +     if (dev->is_virtfn)
> > > +             return -EINVAL;
> > > +
> > > +     if (dev->liveupdate_outgoing)
> > > +             return -EBUSY;
> > > +
> > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > +             return -ENOSPC;
> > > +
> > > +     for (i = 0; i < ser->max_nr_devices; i++) {
> > > +             /*
> > > +              * Start searching at index ser->nr_devices. This should result
> > > +              * in a constant time search under expected conditions (devices
> > > +              * are not getting unpreserved).
> > > +              */
> > > +             int index = (ser->nr_devices + i) % ser->max_nr_devices;
> > > +             struct pci_dev_ser *dev_ser = &ser->devices[index];
> > > +
> > > +             if (dev_ser->refcount)
> > > +                     continue;
> > > +
> > > +             pci_info(dev, "Device will be preserved across next Live Update\n");
> > > +             ser->nr_devices++;
> > > +
> > > +             dev_ser->domain = pci_domain_nr(dev->bus);
> > > +             dev_ser->bdf = pci_dev_id(dev);
> > > +             dev_ser->refcount = 1;
> > > +
> > > +             dev->liveupdate_outgoing = dev_ser;
> > > +             return 0;
> > > +     }
> > > +
> > > +     return -ENOSPC;
> >
> > Since it is executing under a mutex, and we already failed
> > 'if (ser->nr_devices == ser->max_nr_devices) check above, will we ever reach
> > here and return -ENOSPC?
> 
> Yeah I wouldn't expect to ever reach here.

Will you be removing it or want to keep it just in case scenario?

> 
> > > diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> > > index 5c0e92588c00..5b4c8d9e462c 100644
> > > --- a/include/linux/kho/abi/pci.h
> > > +++ b/include/linux/kho/abi/pci.h
> > > @@ -23,19 +23,20 @@
> > >   * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
> > >   */
> > >
> > > -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> > > +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
> >
> > Just curious, why did we change the version here?
> 
> Because a field in struct pci_dev_ser changed.
> 
> > It's not like just
> > previous patch is working enough to perform a live update. As the config
> > is experimental, can't we just keep it PCI-v1 for the whole series?
> 
> What is the benefit of keeping "pci-v1"?
>

I don't see any benefit in keeping v1 or changing to v2 as well.

My reasoning is that before this series is merged, there is no real need
for versioning here. This is first series which is introducing PCI
liveupdate. It is not gonna be that someone has merged patch 1 only, run
its kernel and then kexec to next kernel which has patch 2.

> I think it makes sense to follow the rule we set which is to update
> the compatibility string in any commit that changes the ABI.

Okay, this is also fine.


