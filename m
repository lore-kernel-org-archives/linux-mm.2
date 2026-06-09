Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C7DCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BBC6B0005; Tue,  9 Jun 2026 06:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC8D6B0088; Tue,  9 Jun 2026 06:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB296B008A; Tue,  9 Jun 2026 06:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9246B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:45:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CDC3120535
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:45:52 +0000 (UTC)
X-FDA: 84860043744.30.697DCA6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B5B9100011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:45:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B49z5pa1;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781001950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=No+49IMmQGsjPk0qMclq8vTdt88psTr6uq6iD4QVA2E=;
	b=2XIC1aNgwT54D24kfiLIwYXWwG0HA2vt3vKn2BbnhQK4/3fclv4T8rXRUDeTBscQvfHdY2
	/Sg5PQy3RxoCeuRvr+UDwH9cY7txN4MaUCwMA0Ufq9TGiiQu107YW86OTvDM326bGQp4cS
	z4bkQKSsyVFdxd8+u5FSZH3YB2cuiRc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B49z5pa1;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781001950;
	b=MMP9pFrRHEfRqE8XX1gHnz+5M0LH6HGGjWfAGnLR9qfeeBtdVsV837NVomhqFug1eVHvtm
	LjhrlsN1HoHUbDNEBcp72/nkKfsZ9xUsXTRWsvix+lTbf2aPKXNfUQKyp85JsSyXeaAse2
	f+WFjZ1HA/jzWaYrz83AMrzclPrhgsg=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2bf22c18ad3so504205ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781001949; x=1781606749; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=No+49IMmQGsjPk0qMclq8vTdt88psTr6uq6iD4QVA2E=;
        b=B49z5pa14+0L7yT/R7iIP3HhnfmG+Cqr8EkjrutLu8iVIS+4EOqfAKO8ngow2ZwvYY
         QO1KwKJota/N3a3Ni769+5m8BeqvMh2q3RCXm8ckIJTzvfmyRdri1XProCVbi6Abw5sZ
         e/QTQaCw7mzqvdnj4n7DGgOxptpyIUQ4Oq6FAsQwA7GfKkqmPtMWC1pIhReX7tZZWS/L
         2nQRdqPFzzf4tUE699l3Y/8Bw3ERPJ+D5Rqff74GHW4gV2hO0vfIuhDFZFaqgszD/1Te
         pETzDmOY1JL+1Ltd6NsmKIeaH7epgWM809zN8ISA5Jc1dzSa3K8kufIB5nIU5opNgwuY
         m9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781001949; x=1781606749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=No+49IMmQGsjPk0qMclq8vTdt88psTr6uq6iD4QVA2E=;
        b=rUPU+b417LSvPb5cilTCDLCygPQPKy0Qs+E/TcbpCRBP4IQGYdr7ZAPoGzgbFW+6h6
         BxWM7n8P7lK6HAO2ui4D7TrbWudHdZqC8nEjRf4u/W5dB1a9C0to33ouy4MAVps+Pzyw
         VLf5T9W8vJRp1cZU2/UejIHrT50XMRAnS0JCO0QtfYj3kL99/gdlVBKtAEh/clP8Basg
         h7F5cFtG9vzVPNtVn1gTvL17fK5nhPXH4JSGU9/9F42/LqyyXeGpJgPyz/7USoQjtHR1
         YGrBvNv0YaLPA75DvuxmdOG5ATdnDbv62eQEo2PtD+xCTT/5nCKpIF/Z7a/UaKLqtoHi
         sX7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+0iBZ1RNoBe/2YgmUrxXekLqSoGlI/iRy0u4fVu5DkDI7A80W5lK1jiFBeRdm8GN2BfLfRIiJQ7g==@kvack.org
X-Gm-Message-State: AOJu0Yw6PX1uH0TkFzi1njbepg2vYHSp0GcJERIeAlpD85f+BaiYNqz5
	VlymxZquYO+PTunKoHpBcYLvXIhPyMgKItCsJVIAqUHhJtRfVevU+Jhst8wYCuzgtQ==
X-Gm-Gg: Acq92OGHLXBquAWs/MtdDzBPXh4Epo8bK55kXi+VpyPgxhf8TyRGO0IoH/izGxFcctt
	pFzKYqb5HK2Eq85k/E4ih4k1ln+kedw9T9LjcwPmPJqeRcnzqv8h19+egMM2TtC9s03AOsP+K9z
	EnnQRyD4GirQen5OMfFlRcmcEIt+WQrBV0Q+MwZauoSNjR9zOPuR4+XXhyY2T673zjXrbOekFJO
	LYQt34WusvZYbyWoKkjsodnTDmDLUHKN2Wtejl0ZJy2RYQYVrzGQNpjkf9qZk43aZMpZE2LzIwc
	aAco7e9ZjMjUi2FcNO7T22PVBenliwUK6CvJe13QZwfXVAxe0qM11vEBF0LtzZX3+FWafZ7JCtR
	T7P4q4zLcByrm4xaSk8mRZC7jWWz8iq+b0KdqKX70rXFq069ceL3EL0EJDbpBlB9hJx+hUNKNx5
	3eROG4Ln32MVJQpQaTJKjs32zXiV9ZMGx6zjL1tb82Gjx2yItCHKfbIUrL2ab9E9Bey94t/l8=
X-Received: by 2002:a17:903:fa5:b0:2c1:ee6e:4e4c with SMTP id d9443c01a7336-2c1ee6e51e8mr7663135ad.29.1781001948407;
        Tue, 09 Jun 2026 03:45:48 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828e228asm22864909b3a.47.2026.06.09.03.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 03:45:47 -0700 (PDT)
Date: Tue, 9 Jun 2026 10:45:39 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aifu0wys8IENAK1C@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <aiJhoq_Yj6-1Hl5r@google.com>
 <aicrNNVrMBtJD2iZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aicrNNVrMBtJD2iZ@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B5B9100011
X-Stat-Signature: q5fjzxdbxq3najc3azx1t9me59nsz6ay
X-Rspam-User: 
X-HE-Tag: 1781001949-233541
X-HE-Meta: U2FsdGVkX1/mVTL4UiU9iupKLRqatgUkAripLLOyTj6GStno6SjCIL9VCXaOS7YwfVoGudrHM3URJsZK/eLQuk4/1qDuQRX4AldWueuZGgGRusWsgMBpCv43oudZtmOAQdyY5b9czt+hBSVRdBQfBDCUUgPYnDWZnAnxT+82/AnYK6o2bHFhFWR8kQo0/nJ8NXmdYNLl+HR+/1jS4WYivd2VuR0xP3L4FHybZkSuDp53NEc0TMw1uuw92Ub9cQFEGuJtVsHiZn5VOm1j9b/kKXVq01CrVFE24bAdnKE8XXyCxL3Y3TJet7IoU4za5zTJf/7VbNb8eY0KNLy/48I+PS5/Ydy1HxzVvzwdCUOmEaGmXV2ZmfHYJsOUcrm+SJJvebVXvwrJl8WVPrzsEL/vCZnUioxcM+BzvaXQBDS2gleRjt/bx7xDllqBGe+rbZCOg3Cl03O2gTE2soFxbJ4nSj5/GUh9w2YdWj4iEOx3FnsDDkvLDHEgDHaMmznfqxKVOBuCo23Gb8Oo3cLfoyHrM0NJcxlCWSDn7klLtdY5r5JzvqhRRBKHusglttSTT6rJmPvTtpOCMT8nl4PsmxYJybyZRSyCv5W+McltjEiAvK18v09mXRzdvTtEx+DU2s9ArLUGnbEgn51tjOdYLxe1dbMlfEMzHJlcCcIzCq1E9h4rz997WoclUVfNATNxPX6ue1EK7WKid/mQYgPHtzRMjtrWHSg2kZnF+5SK48XmYFsyptDCtJhTj133JVh/3dqVwy/gFC4h+ZibIOcE1AaTeypZF+fMTvlfCg55MHa5d9DBhGamWU1L+lTWqpcpEdb1/+4RkTsWkA9im541ctOWVFQoSCf41SKt7Njzx9NcAiQQcwpg6UdWymWzvkq82fJjCe5BDyWFOOz4/iHo+HH0NiA4jOUh93XXi97HnYfRVUVCDxepELvbIF1HAmNd0KAML8aK82AW7t4y1Gzyse8
 fkaeAEmm
 g0SrmtBkurlNYVHZd1TDcD8Df2QzDRdK08wdJDqGQjeIqyb5UwNKZawHjGSTg+JVEkncAtJsHn3hj0VvIwIvMMkSWOeYm8Z+Mv2JICLGKejvpcy4XSaskdT2CpYtmVRRJvlG0e+ZfJ0zf3RY7ERB1QdwKbfl77T2O/xbTuApBh83E507zGin7pObzgKeuzvpMZPTMrP/vGgsb9qfUoQTYYf5FRirCf3wb0M+xXb5Xik88HSpb7vDKp4/ea2DrCX6l5duoRP69w7tb9K2nI9Ev2CySyfEayCOAZGC005FHQYqbemztfom6Py8+VfvmSI3hHv4r1D6zKUr4GWphGp2645MDkxqOE3vrer5IEzLiQgsabwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 08:51:00PM +0000, David Matlack wrote:
> On 2026-06-05 05:41 AM, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:23:59PM +0000, David Matlack wrote:
> > > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > > it to participate in the preservation of PCI devices across Live Update.
> > > Essentially, this commit enables the PCI core to allocate a struct
> > > (struct pci_ser) and preserve it across a Live Update whenever at least
> > > one device is preserved.
> > > 
> > > Preserving PCI devices across Live Update is built on top of the Live
> > > Update Orchestrator's (LUO) support for file preservation. Drivers are
> > > expected to expose a file to userspace to represent a single PCI device
> > > and support preservation of that file. This is intended primarily to
> > > support preservation of PCI devices bound to VFIO drivers.
> > > 

[...]

> > > + * struct pci_ser - PCI Subsystem Live Update State
> > > + *
> > > + * This struct tracks state about all devices that are being preserved across
> > > + * a Live Update for the next kernel.
> > > + *
> > > + * @max_nr_devices: The length of the devices[] flexible array.
> > > + * @nr_devices: The number of devices that were preserved.
> > > + * @devices: Flexible array of pci_dev_ser structs for each device.
> > > + */
> > > +struct pci_ser {
> > > +	u32 max_nr_devices;
> > > +	u32 nr_devices;
> > > +	struct pci_dev_ser devices[];
> > > +} __packed;
> > > +
> > > +/* Ensure all elements of devices[] are naturally aligned. */
> > > +static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
> > > +static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);
> > 
> > Minor Nit: Shall we consider using specific bitwidth types here?
> > I'm wondering if down the line another u32 field is added to 
> > struct pci_dev_ser.. in that case on a 32-bit machine 12 % 4 == 0 but on
> > a 64-bit machine 12 % 8 != 0..
> 
> I think natural alignment is what matters for efficient access of the
> array elements. So failing the assert only on 64-bit architectures seems
> like the correct behavior.
> 

Ack. I guess what I was trying to say was we'd anyway need to keep both
architectures in mind, i.e. adding members should be 64-bit aligned
(which implicitly also handles 32-bit) as with the current assert
any new addition would have to be both 32 & 64-bit aligned. I guess we
can keep this as is.

Thanks,
Praan

