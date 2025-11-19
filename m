Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E81FCF58C9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F0F6B00B8; Wed, 19 Nov 2025 14:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F776B00BA; Wed, 19 Nov 2025 14:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6179E6B00BB; Wed, 19 Nov 2025 14:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6136B00B8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:41:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF68B4E8CB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:41:24 +0000 (UTC)
X-FDA: 84128375688.10.AC88F04
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id D88B114000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:41:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=WwtYZpgA;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763581282; a=rsa-sha256;
	cv=none;
	b=2QsZrHiq1XFqtXYbCkLo9gz8aWn9pRIcY6Mb01xX/QpZVOAJ1QQhuPlrp02L6Ul3g1Bx8I
	gewOqGvKB4/3lItVBBq+7bXY+nTpxolXrM1lmm8Ti3bYtUXOdoiPSavlA5TNQ1NilnSVKa
	4T1phy1gpDjTXPLlBRJF7An27YhhUwA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=WwtYZpgA;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763581282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xvMcuBzJSIcfclCVWQ2hNnnKt+oezBHS+z89ygHsa4=;
	b=zCr3f8hncydzBacmR/Lg0yy2KGWPBlA8sLJ+gvayt6gjoZbjkoInd5x7tyB2Hzli0IW/AB
	0Bo0HrD8OvbBO41TJb7RkAeiv6adELOQ7ygvMZ7RqH7B41Uog5CaZWdjCcNahDxUsk6iWM
	WMyvW37J3MUyM9Fr7I0L9oj1uVKlHuk=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88249766055so1403046d6.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763581282; x=1764186082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xvMcuBzJSIcfclCVWQ2hNnnKt+oezBHS+z89ygHsa4=;
        b=WwtYZpgAgTLnvGVKMMxtSvs4MZcjWmzxNb+oSGpX1O5A9cpNo9fNTnA5MBNNx4iD+g
         x/cFxgDoobqL+zjI0vb3hkit72i/RA8U5jAlwWGtwLva5TEKZTG1HnLIblAytLEwNt4I
         MLNyFGpHD7O9ePihIx/2xjPEcnRcKy52IRXv3nId28g7qo6QHFHBKX5qv1RKabIUppGR
         xNnUGtiFLINEVMu3eekoYx8pAKHWCDRMBwDP50hIrGhgrV51mfLEaulZtAWM3nHAhwDJ
         bOUa2De7XGNsIM+xo6qU34zkRjSA7QyOOYaXDPfqjiPKkPjLGEL6ZYLnbdxJEhjl/nKl
         TXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763581282; x=1764186082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xvMcuBzJSIcfclCVWQ2hNnnKt+oezBHS+z89ygHsa4=;
        b=Ybo2bgNozacy62qpqEZMP5oe97FjqfCLGnSJbsS+DO47CoqX36Noa9t2TEGjeNCvF/
         CcYEx2+TYyclyZNb49YaJZg79GDrsTJoznfCFKd+LTkueBU7FeoeOFgcrxWThFb6bAXd
         ONUoIj7v5YXw8w102w+9qqLRWWLv5HEPBCQytU64PNnXAcISMvmcvoug0Mi/fZ63sDxi
         7mKDJ97iQII9vf9A37JrUngiNKhdeGFK0hY/6aVlp+0IhZ9o7A1uhWo3OOEys+wWDy8i
         N6wOTNil9kTuQA1nr9hkN9o2zzTeEVadU5yaxYuU66+eR0C/hjlY9WbHZalZqgAB/ZiZ
         dzmw==
X-Forwarded-Encrypted: i=1; AJvYcCVb05XCP16dTL/7va4C4zyGLeZyoynFei1JQRmSmVAD42df94FYWmH1tIBXMKQk4kmTtaE6Kowpww==@kvack.org
X-Gm-Message-State: AOJu0YwIFcIIWgWUZ9yJI257ByGDTWK3XAwvOnRr/uvLaXMLu/k64UHN
	mCKSNrmsiOAWumebC2Zg1ygTTLl+k4HYVbZuqbv0GKBhbWnnrqChWzC8AnK1tnzBqgM=
X-Gm-Gg: ASbGnctznYRfDdg3zVRJYfIgGqJsSQkbry0iYsmqRAJjcEG6gLPgXWfcQUdNowl2KIs
	WZ/1ryF11wWisPnGYZUVFiyfZYllaCHKy/LWcEFW7mxt5cPha0YsYjNRjYb1MXfxHFhPIOJ6NIw
	p2OCKld79KVols/nHqJS+kj7+D+Ws8owx7dRaCwJp25Uxh+YIU0Gm9oXAU5v+6KM//BCS8uu3wh
	JdkaHWlA+AxZQFwnNNcaZBvpgPp8PBRy35N78rgoU0eMRBC6cyh6cc99VLuUsrkOHW/NVNJd4CD
	yiAJ7QiOYWK2QlB78SBOIA0NuEipb97RuATFdUjceLkLIyvjVPIdqMrNwegBOEvVtABz+5MaZWz
	jT0HKDsif9mIxGmZST09qboBkbIJnJIOv6ZWLZbfDnxqGfv35gBDS0u58FAE9iBuLvfzDUmXks3
	eFT7I84rsDZj4c/rKqYtpOpaL+I97EFz/qslYdrRlk6U3VGNr/EZANT+IX
X-Google-Smtp-Source: AGHT+IEkkwKLlD7bgArhzanqcgyJXrNkTCLmX/zPs7UZp1FVMILPKD98FXvYwEVi1NAfBqdDip+8Dg==
X-Received: by 2002:a05:6214:4a84:b0:7d2:f787:1978 with SMTP id 6a1803df08f44-8846ed7f961mr1725046d6.3.1763581281958;
        Wed, 19 Nov 2025 11:41:21 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e47115bsm1948696d6.21.2025.11.19.11.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:41:21 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLo3M-00000000bbB-3imG;
	Wed, 19 Nov 2025 15:41:20 -0400
Date: Wed, 19 Nov 2025 15:41:20 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v8 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251119194120.GR17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-10-fd9aa5df478f@nvidia.com>
 <BN9PR11MB527610F3240E677BE9720C2B8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251118142849.GG17968@ziepe.ca>
 <BN9PR11MB5276EF47D26AB55B2CD456EE8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276EF47D26AB55B2CD456EE8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: D88B114000F
X-Rspamd-Server: rspam07
X-Stat-Signature: spgyonccxrid6yapzqh383a1b7j1c38w
X-Rspam-User: 
X-HE-Tag: 1763581282-314536
X-HE-Meta: U2FsdGVkX1+Z67vHeEY6sAJczgjoyGv9G6vPOEoCULzAKvjbMVPckinpM5B/fto3hqyaiyf+7Y/DuhinT43MPl0ecy/pcUTt8Q09WHI2WOSA9V+c5iuP5uYVvBYjWH88vUfVDO8wEU1S74uynV/5zlnNc3Z3fnt8VjSxfhRSLpsmX5KdCJl6QAz7TkcL0gZ7uJgnns4gFz7nPs3EP+LuIYB32S20gz9gZ95xzmINWdRtusYT4JRdPLrAzqrtgLG+EgDvpDYRI83IZeYOMwAtD3rErKvbhDMoV5039UcdG2hDfoJw5kewCR9QX3DtbH1lXVuL51YJkk5WYZRSwG6rlqUT0rnwCapVNadohQPNUfAPK1Bm/XxVCyFQHYZdzIyvqPU82X1cg2NroHAY0hdnrth3QK8nYqqLVS5xFNg+UJWdvIuCac2LNRKPeFaYND1IhD0ymyIhqV8wDvjJIbpcovCQAmBobp4jmr9x8+rhUGXUy2MVdVjjmqegtNgqCe6NDu1G5wmnLzynrhujqeQsBhk6SToYuXYjJcSfUNVyfZQk3hTpybTC5jSmmIoimSaIdvDZD1pzRdQhya9xTiO3jvEPqKWxUyh0zZDk5NN7n0oSzv7+k1xnHyx7BTNDPV5WEjA3qYuR14EFGpaHFCh1RW/zdAic1IQknwcS+QZyaSve1R45ofGLVUWG7ypCTzP1VTh4C5Tz2RnYK6oWHwHV8sqoFsQPBNRQKIZtCodfJhoVhSudhgF9jAnKGPwXzOfnPgsA6ku2wStFsRbQUFfwzCyUn8Vu51W6TuU3zZKjoHNwGmJdv+WJJyMfrZ4PbWiV2bY9oPrfehCt7zepZyKTRan70JFNP1q3CVHPXOnxAaaXELIJb9xlEzG/JhZ7XaqnGG76yErV1bNBlI9iIfR9xiLsk5HuJwQubDr39xTQlBKhTGGrg+4mDwrSqEwzTkJj1sJSP/0k/YU+ITiwe1J
 gd4lsdJz
 YecehHlbMo4BrGBGfP1DfKqGcxYMLmbLepyv4AeuKQkMX8ERZ6zTnN29JWtNySzy8n/Bak5HjKAy0HUoVS/1mt2TceqkDvARn1ciGCmgr4SOAGafUFMS39ERSggwYkrN2Jd9PAl9OS4v4q0tnohrs8yEgVEc2UTFKrS+8/3RL+fqKsu2sSQhybBFavfFiirjH5Ux7QG0FFv7WrT4gOSbS/IFeU/gwfe55Wx/vIifwnIKCYWIA2bB5X5RpWhSLmYllFp10kQjLixcKW64yVIQEqq8kTbURUFD7h9vS9+81m111H0TBLSpMFCwD6eHJFF7B9nyknUPPuh72NEE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:56:14PM +0000, Tian, Kevin wrote:
> > > > +	down_write(&vdev->memory_lock);
> > > > +	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm)
> > > > {
> > > > +		if (!get_file_active(&priv->dmabuf->file))
> > > > +			continue;
> > > > +
> > > > +		dma_resv_lock(priv->dmabuf->resv, NULL);
> > > > +		list_del_init(&priv->dmabufs_elm);
> > > > +		priv->vdev = NULL;
> > > > +		priv->revoked = true;
> > > > +		dma_buf_move_notify(priv->dmabuf);
> > > > +		dma_resv_unlock(priv->dmabuf->resv);
> > > > +		vfio_device_put_registration(&vdev->vdev);
> > > > +		fput(priv->dmabuf->file);
> > >
> > > dma_buf_put(priv->dmabuf), consistent with other places.
> > 
> > Someone else said this, I don't agree, the above got the get via
> > 
> > get_file_active() instead of a dma_buf version..
> > 
> > So we should pair with get_file_active() vs fput().
> > 
> > Christian rejected the idea of adding a dmabuf wrapper for
> > get_file_active(), oh well.
> 
> Okay then vfio_pci_dma_buf_move() should be changed. It uses
> get_file_active() to pair dma_buf_put().

Makes sense, Leon can you fix it?

Thanks,
Jason 

