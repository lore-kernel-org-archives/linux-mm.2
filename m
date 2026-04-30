Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF1DCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800B86B00D2; Thu, 30 Apr 2026 16:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A556B00D7; Thu, 30 Apr 2026 16:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6515D6B00D9; Thu, 30 Apr 2026 16:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 507A46B00D2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:36:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B2F81C000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:36:45 +0000 (UTC)
X-FDA: 84716380770.21.D5C9495
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C3751C0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:36:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eHaa+KAB;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777581403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7XgKHoPXsQn1bRJuoPg0uZx0GmeDlDmcffd2v4MAfo=;
	b=SlcbtNrMx8mJn7F06b5HWFFc7ns9ONvlt+RPaz20VG4VO8S9ISjUQSy7lDEVT+fZ3yMosY
	M/qGOp+eeGZCg0C2ihxK7tfFAm9csapZDPKIU8a9AAQYNFTQupGEoWf5VgLgaFT92wH8OW
	CwuS4mNFZjNIuO4PfF8LwRVSu2vKJt0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eHaa+KAB;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777581403; a=rsa-sha256;
	cv=none;
	b=MHDK5llW3nSe+OT5zYmPc5eke1j6nrnzt0yvawVKTVubtpU7L+zSbzFhvXhQCjkyxmJ1Sm
	PCDYXZS7kbilwF8JEgGBJ4Ie3Ihb5yBQxxIIXDoH0eYZF36Uysico/GwZOhNEXfEmhyGfc
	a/rXXWUPLCKxY1gMFFr9JIbZaEHVcFE=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b941cd869cso8630425ad.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777581402; x=1778186202; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h7XgKHoPXsQn1bRJuoPg0uZx0GmeDlDmcffd2v4MAfo=;
        b=eHaa+KAB0uT9DdBvZsruBQ73qJyqlFVwsYBtxIct7F+NL/I+ZFMEelRnVCHClM7COp
         bxmE3uw1j3C46MQwZ5TXBLyZaTWIXxzhZoG/rIaYntFqTA1AMEmGSoELNpBRyysymwwP
         xRTAkDGcfpO1JK+rvRhuRMKXOJuLZBk5GipYQU5rhHPOmJ/S+nfFMx8oI2Px4P+Xd84y
         aVLYy8OrSzvmC8gSSfn8spo2w4BBlAeAGkwgL8AS8IGxfsd94Y+PQrkwr3h6AmxPagEA
         Q0Gl4Nd8xIMKGFIOV+un6iEF8VVNQWiA1M+a9652vulGCX77xhUpJ9jxZEUyOCSIUziP
         KBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777581402; x=1778186202;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7XgKHoPXsQn1bRJuoPg0uZx0GmeDlDmcffd2v4MAfo=;
        b=op9rSzySozTv15pz9y4NaiPPnzyUvgh08yo1uveJq3cYCo043CjnzbBtARx3pgB2E9
         na6aFmzqYsmkpmOFTxDAgqfR2m9yYa4+xH5RGWrtt1RsH3McLlePN/1snLV9EsgzgEPc
         eMMWMVVrjEIY7hPiGNszOswHzaYkMty+ETqTmASaeViTYGc5nnXMyVA1SyRImWFmbXJM
         Nj/9ewd/TNGGuiBdUBYCUPsbPnN9oHzlZrY/rbsxXZhgvVPaHGDl6pyxxtOdfh5j6aUo
         wDFrWVU0cHYuMobpu6OcwBLUfprAUFwZelq6FRlkqQITVjPw+sSIBewnDxtj6mxDACoK
         +oUw==
X-Forwarded-Encrypted: i=1; AFNElJ/tVJRKN+rzv7r1Ne50lsCCpvlgxLOVeG9pyPH5HnxOShseB+g+zLEksTzTzEgrsG8O9aIVUhTgew==@kvack.org
X-Gm-Message-State: AOJu0Yzh0VgVxdSOjZ4y0eqssXtN51c9RHuhzSYW/JQM1O8hMJOBkJRa
	/2YuLHmWK7jKhrqNtIDMzzLdeD3azj4BTIvJlzTbAMyzDvJrOudQNtWPNoRuPC9woA==
X-Gm-Gg: AeBDiev9NaMf6HvTLMitS6hZb4G5eBTa42zuFRNvvE8nyTyyUQuYP/mIZQLkFRKl4Tm
	9e1A2Nr6IWhrEizBC+9vTz2dFC8OpDGW7NKq2LwQNbsaljrLGpKnHxwEtaPCcYgox+vlhUeg5tz
	hJXWP7313mSLreotq8MnkE6OeyXrsgSFsSdeXRfDeZcGRZnn187vrhx6Y+20L/8URB/7dXrFQGB
	LVbTr0I7KPscSDMtsPZ4crT8uK6kIhRJ1SCsTvoyKC0J9+DtSQ7zK3T1QlATHoKiFMoR0Gb4YGe
	p5s9hYY5vQOKxCXm90vTHJPsYWiGdEScfqKM/+LpdVHtT2EIpJsBRaAwmAHdA2JLgEC5CntduW9
	1iBcCHEbkmBROKS5hsFNFhoXnX15wpUZm9Jjv8DZcguOIRTmAot11/zMGEPboh9o28niDQ8vpT3
	3DOBR8+UVpFe+drvQGiQo1eVGqhDwll97R2kBjn8vgCpu0+PIuQkDN1n95HUTAnzuGd93rPlmoc
	vkuSw==
X-Received: by 2002:a17:902:bcc4:b0:2b2:490c:410e with SMTP id d9443c01a7336-2b9a23195femr34674875ad.7.1777581401489;
        Thu, 30 Apr 2026 13:36:41 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae4a127sm5909845ad.67.2026.04.30.13.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 13:36:40 -0700 (PDT)
Date: Thu, 30 Apr 2026 20:36:36 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afO9VOckgyiiokw8@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <20260428201231.GA3885809.vipinsh@google.com>
 <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
 <20260430175916.GA13902.vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260430175916.GA13902.vipinsh@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C3751C0009
X-Stat-Signature: 1663iupsxsb48cbti94ry8e6tqn1rqfh
X-HE-Tag: 1777581402-344855
X-HE-Meta: U2FsdGVkX1/54wW+3emfOWLIC8jdW9oRzqla917aPeIVf3KGkmIWaIjTnvHDnUZVJvz/tukLhPae05jsRFDfd5dnxfQx1GAy5qeKVkSOKJ+QFUlziFNh9aBLVereCxmaoqLxOWV+ICrLDrds0EyhuZyDyTvDf+Y1/DiJuyhxsLcRwIIzHt8JtQIShcqQd8qm6BdAKRxHAZ3jV6iFrtz23EWX5x5jJcdoUvox4ZgKCKe3sLIWxaDN4ra6NuArDAJrhn1A3GIjb5coWNjXyoNpAe+zT4ewORwyJ9Kz4O+5RZnXGcWHRaKmfFT13zJ7joIKR3ij/YrCJFt6oDzFbwTwD4m+qK7VfcysIQLklXnXh8o4HX+iC7oBuEeimc7dk97LO97Vt1F6foeb4IHCIUekzNo2GYxmVhM7XcZOSRlGaohNn8xx4xgtyLkAtaZu5ntNxvaavmQLAb1sgTYOEm1RgVeQyFyYcAyQj2RzXj0ZDjekTyFPx7XWGGCMizKRCSeHIV72UOC13F0v8rGi5i2tRFz24mVNLy0WoJeMA5hCVyS6fnY3kg75nqAH2x1pkDXmxGdYFndofRelFmXasY/BQgqvvd9YbGQZoHeiF8e6ShQ2/7EFgzvvm/ktI6vFKvtpzHgTl8sioDFvy5OYvnL3wPTB9wbdAWqpcGMh1FxTtHu6Gitozhu3jjVTI/Uy7ks3ooUerSsvuKQFUxptFhlL1MlgFS2TGZ3WAZfnfMMGKEKMzkC4Fw2mkeLOfaVNvv51s9H7n9dqTGstc3/37u4khmIJyJ/7pPiHtrYztQS66p4VHCDtKjY6vC7G0c2q8LP5etxrCL7UVvSIxXHyS3mYkpc4sKsGsdbEomfKwM4wJClxxBVvDHJSOIot78n1uUb0TZu17t1kHWSFZbGbpoMM81oDzaUt+xBoCRAGepEKRGhBlMr2xvohd3cDtibv4Kl5uJmJFADGorgkeZzRBDC
 lecbVXIU
 E5wqmXcXN+8d+kV/ow1BcxWPjbS0hIJ/9f2P3LKH+zZSsKP2VwcREisBFj55Z0fFtEjjhuzB6VKuwe3CeDs3U62P4+hI453rzIGpOeFv6EILUsdhVywtmXy7FO61ZA8aUq+o2x99fFpp2AtPsRWEwNj79wSQxeKnUcX0T7DAX74nM1JN7woI/rQB28clDsO1ivKt2JwNIkBNI5h9NbTsRSYgjzWavCbvji/yDx5OqX8x84DZsROSS4UquHAAHydb3CpihSmfewn1DtdmsSQYkyQqkA8LQT6/1Ma5gSJcRiP8z9Xkpw7cDdu+gg17FWI18daqLIyWt3elY32J0PvtwfR/bk+XD3sGwfRkmSniKdq0N5B5Gxgb2ONs11A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-30 11:25 AM, Vipin Sharma wrote:
> On Tue, Apr 28, 2026 at 02:12:13PM -0700, David Matlack wrote:
> > On Tue, Apr 28, 2026 at 1:20 PM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > > > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > > > +{

> > > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > > +             return -ENOSPC;
> > > > +
> > > > +     for (i = 0; i < ser->max_nr_devices; i++) {
> > > > +             /*
> > > > +              * Start searching at index ser->nr_devices. This should result
> > > > +              * in a constant time search under expected conditions (devices
> > > > +              * are not getting unpreserved).
> > > > +              */
> > > > +             int index = (ser->nr_devices + i) % ser->max_nr_devices;
> > > > +             struct pci_dev_ser *dev_ser = &ser->devices[index];
> > > > +
> > > > +             if (dev_ser->refcount)
> > > > +                     continue;
> > > > +
> > > > +             pci_info(dev, "Device will be preserved across next Live Update\n");
> > > > +             ser->nr_devices++;
> > > > +
> > > > +             dev_ser->domain = pci_domain_nr(dev->bus);
> > > > +             dev_ser->bdf = pci_dev_id(dev);
> > > > +             dev_ser->refcount = 1;
> > > > +
> > > > +             dev->liveupdate_outgoing = dev_ser;
> > > > +             return 0;
> > > > +     }
> > > > +
> > > > +     return -ENOSPC;
> > >
> > > Since it is executing under a mutex, and we already failed
> > > 'if (ser->nr_devices == ser->max_nr_devices) check above, will we ever reach
> > > here and return -ENOSPC?
> > 
> > Yeah I wouldn't expect to ever reach here.
> 
> Will you be removing it or want to keep it just in case scenario?

I'm not sure how I would remove it. The code doesn't not compile without
a return.

