Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D54C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8381D6B0095; Thu, 17 Sep 2026 19:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8AA6B0096; Thu, 17 Sep 2026 19:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9DC6B0098; Thu, 17 Sep 2026 19:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05B06B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:44:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2585DA04E8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:44:26 +0000 (UTC)
X-FDA: 85224885732.25.1766977
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B47910000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:44:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SjdC0NOm;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688664;
	b=jPpsha7rFyBzaM9zm7pzvam0qWuIk2LmDj0v/zteI8qiHV6yV2Uqn84a76LO+8Huf3R8aP
	KV5FAxhlilCeursi/tUtzp0XSH66xSUow2lx+N6W6QvIK+SumfZiduVuk7Fj+9ejPN+Iha
	5XWTgJoBKR/cYRcVZwXny4IAnUo55Fc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SjdC0NOm;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0O1lZsSl6FgDJ9eTYr2jlFm3jSIkWmZkODdW+Q8s2I=;
	b=fumT5j27WyQJOTuv6BQG4Ki3VhYbWTC88DBYUu4hDT7XuCmH3HQBsAX4u8cHeFWTJLH2ou
	bP/w2oZEr0nzFJRU9U9/R63cXmJrQtOIP653gLl7CO4rnWNv1skZN29pdTwsWZFxGYwiOv
	U+mSJ+EYAd7U1y0faOEIVbHiTfpKyrU=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd4f99dso187650a91.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789688663; x=1790293463; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u0O1lZsSl6FgDJ9eTYr2jlFm3jSIkWmZkODdW+Q8s2I=;
        b=SjdC0NOmvnwNIi6wYzoRxelMem+dFRbQrUf8XdfM25//OqLss9StOe4xGdKyUwQ9ew
         kGMsKIopS0qd6XS3zgF/hYlqtay7f9baH7YiYZY7cTzE4zslhOYxlBoSxoZAP7fiV2iW
         SLK8nD63zxhTaQUAwUqshQEMma6/Wd6N5Z1Q/trCIsp23Z22e3XTDZ5F677O9sF5mA3+
         7/uswOQMJTQpdEravIxyneokS2JWtWdl/snalvPJ+/7o3xsJ88S8oQPXVvos5Yc3jHHU
         dEUzzOIezCbnTX/znmDeVMWoP9gOafv69KwuEEIjIa4X1BMmPtFpnBSDKyauxsqP5OZq
         Piow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789688663; x=1790293463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u0O1lZsSl6FgDJ9eTYr2jlFm3jSIkWmZkODdW+Q8s2I=;
        b=C89yXf+4pn2fq60/6rknPq+LlLhcWXN3OlcUAsKfxVD5/kiy6boGA4WReUOLrj3Oml
         12NFU+9NDH6weZf1Ip1aomsESM2MhM9jckI6VEBX/lGrc5a7wM+sq9g/JNhS21zpxMtu
         qees93BqCKfwkwvg0GzqBdb3gv2oRRfsZMrzFMdBZLr3rSmdDwPnIvQ11i2jtIgrESiv
         MlJvotg7Tn78/lz+ne8fauzQM4fliLtvH/utXzYxVhDtMbO5jxCbMh6STtfTf1vKtnnX
         t+8xqNgBU2UMwJuO/68yOkItCfdpD7mcb9TIc84MboCWZMX20UEhce0JUows628wCgrm
         MCKQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5VkvYaSm/zARjt3bwO+MBK3fjsQwhkGCu0GVgRPnW3a2XPy6q9xnhftRC3ZwfuWm6+bpZDmg9iA==@kvack.org
X-Gm-Message-State: AFuF++kusBpfLHAuePyTlYPHvY9sSGuAeXYg18lk0Z3kUi9iZfDP+9+e
	fnbxfRr+L1MR2sA375WkHqQzkyTdxHxTC0IvZoPCyHalV/xIKkBOVCtgl9HaFsXKeQ==
X-Gm-Gg: AYBFou1KN1f48BPhoNmv5PyA8K3MCJ+Fn77DvbAAhAawfD9B4PwA2cr19GsuqI+1H0Z
	bflYv365h8j/B4sbRBfSrpIv8LYcrJPAh0NTgaqinFLEwuqjjJf5uboFm7uTJ+/OQl0LS0nxwYY
	Xx7zAfCURqobzvr15H20FUz+qNWGP2FFzZZa3aFlFtx+OK5iMM93xpU30M2izIbYx+X4LJG7Gxh
	jKmqoPCJh+jJDCrScRuBZj0iAYLCuEpDltGULdVDtnhoLDgcrfCq+oTEhw9rLvaFNV/MezCwUy2
	t1M7uKFLnjpQ3k2UfQfrdMib7p+8xldougFaQQRugVqvHXB15f5UK2ZyqAkdNXoKkMfyPenX/Lw
	PHPesPTaovgZedKxDhdgmg44w3RdGSXNYaYiQVc+HZdNW7f10USpGNMoHLG/OklXZFN0VOnR0qy
	xLU8L+XM26PGT50HJrET9aygN0PEbq2QYOzJozE3LGdurChqcl5d85Eyrp//K317QuWlmEOFmLe
	wsQzJ8q1DpEIeurPtPqlu7sKRlYRZT0yilWLMgRCVdYqTE/6SQ=
X-Received: by 2002:a17:90b:2ecb:b0:39e:4c81:6c9a with SMTP id 98e67ed59e1d1-39e54fafb06mr1575707a91.32.1789688662542;
        Thu, 17 Sep 2026 16:44:22 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e535f0421sm443246a91.1.2026.09.17.16.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 16:44:21 -0700 (PDT)
Date: Thu, 17 Sep 2026 23:44:17 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <aqx7USJxZrk9GIWm@google.com>
References: <20260728221007.2098560-7-dmatlack@google.com>
 <20260917000723.GA992337@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917000723.GA992337@bhelgaas>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B47910000B
X-Rspam-User: 
X-Stat-Signature: ak6jyzqcf9g89oa3hgkp5i6b586nbm68
X-HE-Tag: 1789688664-808512
X-HE-Meta: U2FsdGVkX19VfG7qIYpT6gWBgGwA5vevZJ0HBchWflWZRoZ7omH7KlXZA0JmrGIIvE9TJuItJ+ZOP5THNVUaL93PrZ4+F0Hu6yxloDJZmZqhA//ioaeHjA7jLB18hLXgy2GC3vSLc4njkm/ZQ6SA6yXqTRUHmFgNSEQoOogck4elwjSLRoisKp6B803W21uQpHi38FoMqUUYY4kGUk19coKQtjr70vlz2KTU1GGun7ffYjbY6SfwBGzQRDmEoJ89l6Glne7ftLgMh5vjwwf4LjS6Z3bVoz38M9ktL2P64lCez0ZPqM7gtPTSZuT+eT/gesCSEDdCC5Kyi6RqOatTr+Uejb9TPXyQLPgE+2n8cGy6DLtiGRB05g4INP158JAM6CeeC04y/M6NJpYhlsdbqUD/7EyaPE00VFlZgLa7rXg7DiwovmALTP0zJhVxrTzJASGU7plpDi59gwXLGCgSsaPPCXZfJVTfEUWYbsdsBzL+mAqvr/tGA81k9gHdUxRQv2n6UPkoCi6P/QG7HzIx45CbWTQxz26Cu+LgtLd315msLYUgrfLWnvDJqGKVM0dLot6x4q2aV1NJYIE0gex1C0g4wOzC+2DDr/Rt1NjwcaSyPRnJ54alho9T5r0zRtN9uo8ienQ3Vg5lNvtO3Gltq8V6/gKQcMmvWwFOJsCMqGxXRMf/PqGxMCFmZrTGU18SdZacNijYz7xWZUucKULW1bjVwx4956txjEPBgkR4Jhhx73pXNyhf4VlpGoLEJVDsD6gWkYv6Xyq6tS+l6kJAzTbkN925WGmUDmMr38RpEgLJP77sMkZBIBW8pR67g44j7K1NO931M3G85ydeE/QtHOj76NRHOcuhtuXxEPjMuFbHGQ85NfZ2uF7fZ4UfB/ueOjEJd/WN9vIdmAhiRty2mj70r06OJIge2AdhTz6skyAC6IsxoFHR1l9J+KQ4YmJ7i2OQ/8PbYZYqmkOvOVS
 ax38DxhG
 +flUwSGMn1E/auP5i5MQ3doZenG0/+eymYwIped1N+9YDumnzKEHSBL4sfE4aGsvE5wNC/0EvqMQaQCdnm1rB8fNdr/89WdAkYPg0LF5MCjAPHF+/DiDzrl4eJm/x24fOugSapJ7aJSt7wcNsSyi1Zui9OsxsUBIQatjo/TXsn0VCvnAZONt8pRiCUj9KOK9kdi/tvK5rIpTP8Ts/8l+8GyK0uN5M6vYLD12Fgji9lJ2o1UdG+TGx6bLZDOd1PPHZd3iQv1p4+w/Lf0sO9lafjkgoUioAmsGbp83Ypzjxk4iPbI91qvKN+Cphc7zSlLvnxB4dKjNBVa2IZtK2lPjWhUOR6OvBSqEAZ6j4gC5HtP5k1K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 07:07 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> > When a PCI device is preserved across a Live Update, all of its upstream
> > bridges up to the root port must also be preserved. This enables the PCI
> > core and any drivers bound to the bridges to manage bridges correctly
> > across a Live Update.
> > 
> > Notably, this will be used in subsequent commits to ensure that
> > preserved devices can continue performing memory transactions without a
> > disruption or change in routing.
> > 
> > To preserve bridges, the PCI core tracks the number of downstream
> > devices preserved under each bridge using a reference count in struct
> > pci_dev_ser. This allows a bridge to remain preserved until all its
> > downstream preserved devices are unpreserved or finish their
> > participation in the Live Update.
> > ...
> 
> > +static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
> > +					    struct pci_dev *dev)
> >  {
> >  	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
> >  
> >  	if (!dev_ser) {
> >  		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
> > -		return;
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!dev_ser->refcount) {
> > +		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
> > +		return -EINVAL;
> >  	}
> >  
> > +	if (--dev_ser->refcount)
> > +		return 0;
> 
> I guess this is a nit: I was looking for a dev_ser->refcount++ in this
> patch to correspond with this decrement.  I *guess* the
> "dev_ser->refcount = 1" in pci_liveupdate_preserve_device() starts
> that, and the "dev->liveupdate.outgoing->refcount++" there is an
> increment of the same refcount?  The connections there don't seem
> quite obvious to me.
> 
> But I guess "dev_ser->refcount = 1" was added by a different patch, so
> probably *not* the same?

As mentioned in the other reply I can combine refcount=1 and refcount++
into a single refcount++ to make this simpler.

The refcount=1 is for when a device is first preserved. refcount++ is
for when a device is preserved a subsequent time. Bridges are the only
devices that can have a refcount > 1 so that's why this patch introduces
the refcount++.

> 
> >  	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
> >  	outgoing->ser->nr_devices--;
> >  	memset(dev_ser, 0, sizeof(*dev_ser));
> >  	dev->liveupdate.outgoing = NULL;
> > +	return 0;
> > +}
> 
> > @@ -385,13 +418,23 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
> >  	}
> >  
> >  	if (dev->liveupdate.outgoing) {
> > -		pci_warn(dev, "Device is already preserved\n");
> > -		return -EBUSY;
> > -	}
> > +		if (!dev->liveupdate.outgoing->refcount) {
> > +			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> > +			return -EINVAL;
> > +		}
> >  
> > -	if (!pci_is_root_bus(dev->bus)) {
> > -		pci_warn(dev, "Cannot preserve devices behind bridges\n");
> > -		return -EINVAL;
> > +		/*
> > +		 * Endpoint devices should not be preserved more than once.
> > +		 * Bridges are preserved once for every downstream device that
> > +		 * is preserved.
> > +		 */
> > +		if (!dev->subordinate) {
> > +			pci_warn(dev, "Device is already preserved\n");
> > +			return -EBUSY;
> > +		}
> > +
> > +		dev->liveupdate.outgoing->refcount++;
> > +		return 0;
> >  	}
> >  
> >  	dev_ser = pci_flb_alloc_dev_ser(outgoing);

