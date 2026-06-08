Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EADECD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647B46B0005; Mon,  8 Jun 2026 17:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7ED6B0088; Mon,  8 Jun 2026 17:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E68B6B008A; Mon,  8 Jun 2026 17:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6C26B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:35:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECC6C8D174
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:35:04 +0000 (UTC)
X-FDA: 84858050928.29.6B08EA5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2DE5100003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:35:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EPQtPjAt;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780954503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mok13K1oI/5oKqM9t1zh4zoQDrWvB1QlqYCZOP0VV4Q=;
	b=762irjAC0o9/uMyCWq1c71LCTs8g8iwmPRYVIMY49HHLDvN6uVwwpysbA8xZnvoaJbGCTj
	6ztHOR+IwpjN/b/JuJafT9YIgp4PQivlfXy26Jr5b+IG//OEhp0mEmR9z4ppQ6WfeDZjHL
	mQDI71xJKGEMDBGQZmMtFCHEi78bdbQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EPQtPjAt;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780954503;
	b=YaLhEVEmCeBFcNby+uJEZ6nv/adLD+ZrGzcDiwRYZLhGceI/J3deksLb3IFGXqgm08x1Zu
	LlIiCRdoz/difJD9XEnX0ZI5mRQT5n2UJ3tkAqjokcuZ6LjIZez3V5LO4Hh3LBCvMcXm4z
	K9Aunrb0hkILo3g4fX7vsU6vkbzWDFQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf0ddaf50fso32698405ad.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780954502; x=1781559302; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mok13K1oI/5oKqM9t1zh4zoQDrWvB1QlqYCZOP0VV4Q=;
        b=EPQtPjAt6AnJhjt5NXQwyAvTWoMj40MakP3of22RXAYPW+rxf8woZ8CtlsEsnU81ZB
         uQTAgHr586Nraq0Q9oFLqjHPrAZc3+IdiEK4ztLeWs9ZUihxQ+dduvCJhQYghTaUryno
         pjuVx4CD+vW+0f8nOH+l0gPqWVcKbPmRJwm3t//8gkki1Z8yUMZIINnNHNnqnaFe3sFY
         wg6d8Rr194YlPmMZI4ijaBO99VYMxBqua1UwltYVUzIw8VEcdHbJgRoVasU37jImi4An
         EnA5dH9EEb24ZJPfu/1UXNWD1DatI22P9bnnQhaH2ae7jzmA0n0CiMpHBM8pebIZvRHo
         tjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780954502; x=1781559302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mok13K1oI/5oKqM9t1zh4zoQDrWvB1QlqYCZOP0VV4Q=;
        b=KLGGEcvOLvpZMuqYWjTtJXkaeeL8fd0acwmShXlivrqTRpXnuuR3wp1T9ZCoe6tGeh
         BArdT1rk3ZIg4m6jvJcqbLFthVOX0j+i1CyHzBglJhynpGZEBFR1FJCejYpOOxX/gcgK
         pP9/wG4CA/xoqYm8l3l5cHO/rhp5sGa6gvckgg/3YMKqZTKk3D18K6wzDkTpRADNnbVR
         VOGTqwKLYsMsGPOy13qhyUxOOb8KwOSl9XpawreibRhTrlwIhLYt1o25AYDi/uf0DH70
         GbPN6UMB3/vUDOG5k9bZtbMHUu17BNQ+B1cIyqU48GgcuccWrKVGg50IDGboOvIT1rSQ
         qTrg==
X-Forwarded-Encrypted: i=1; AFNElJ+wvFsk+8GU9tZS2SLrCw5+RcEPB/GhJuNwPOu8X3b1sIf1D5tNd4EpcFeZmagKIoFMvvvEiUgieQ==@kvack.org
X-Gm-Message-State: AOJu0YwI/I0HRSnYqvrqN8XcfoEWyYf+BFpR4sGvKj+PU08AC5DBBk7a
	99EcvZwwjfdUQJ/IbIBjxLoog1nXYAamT+bb+SzosX5hHAfm+Q8Z21dWRKMg1sSlZg==
X-Gm-Gg: Acq92OHLTgwBQc4BhIlzY5zASuHhYa4krnV2zZqprTNzUIW6rlGEJzKSkUQurEhHbev
	EeBDInlb4em7hLlCXpfHrcWCgrbaEYjJf1k47HQ3W9AJHj2lWZU7JTU4enVrYeeEe8A75F4KV0O
	CPFoSZ7WiSLSQruyny0lcOJ389YQqttHaUx9vMQWIbKzaMsUg+ittU/9mza3NMWhlWfU/OOQq7p
	T+mGGcez0/RPh6dJXhKAfQoQNXRYdDMkISp39W58KT9zPNqQKIHDUtJv3O9rbjjQENEn2fkOJI6
	HX6sXtv2UaQ4+znRlEjMHtjSUJDg6LcHsf5+mMq1s1KGUsMa0l0GMXMx/EFy/2bcAlwoptOWlJM
	QKAV0yp3AvptEqhlBlMKbPzm/j3QLFVvcCQGy3E6/xXrLLVWPo4spc1DNy191Sqbv+IVlEaDc1j
	ian+TO00IxcgXMatIVAwzlbxYzSucoJE6A4+B9RW3sNJArACBFPJUc0qFHrt4RmCP9Ja1Sj0q4
X-Received: by 2002:a17:903:2451:b0:2c0:d99a:2fc with SMTP id d9443c01a7336-2c1e78e4e7fmr195316255ad.2.1780954501183;
        Mon, 08 Jun 2026 14:35:01 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e05fsm197449205ad.54.2026.06.08.14.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:35:00 -0700 (PDT)
Date: Mon, 8 Jun 2026 21:34:57 +0000
From: David Matlack <dmatlack@google.com>
To: Pranjal Shrivastava <praan@google.com>
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
Subject: Re: [PATCH v6 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <aic1gdmisIT4sqEN@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-7-dmatlack@google.com>
 <aiSb85Ec6jW4xPaE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiSb85Ec6jW4xPaE@google.com>
X-Rspamd-Queue-Id: F2DE5100003
X-Stat-Signature: uuxrdg818x5bknnbwuxmko5gih53ensm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780954502-144486
X-HE-Meta: U2FsdGVkX1+uGxh1UoJV49DN6TQBxt8wDGDmFlpGBu3MCbt1rWAvoB1Io/FEYu5MLBRZewIQ+7h9pGvjmX7a6SytJOa812QF52bt9vXeJ015A6JWz0QVmN+8CCyIakG85fxqHUNfNd8oVMJfFjfrU0aE5V9Mql8DxMz4MbyoAVRfHxvMaraJ6nV3VdoQnSRD42KSn47UsXZe1AbcfTV1ntyvi4QecFFg1Ru1xBo/pBvqfCJ5nngpvFTIDErlikZYrXNOg2J92L2iWOi9oEuzNLr/1+dWwyoiaDIvUXQdmvfCfx5FvPhAxfBBTNVJY/4pidsFCQsipVR9j9uEApNEnNJpFDk9r34F96y3sRnkrD3rxZzJ4J+fSEtiHX05weH3PNpVBcE+m8MI6xTpTOKehsuJ7ehsz5wEn7zPEk5nZQnhCuikRiJKpG8wGjP3RW6O6TN/DsL0IoShfnkkb+hglvofuoqcR/qWAefIZ9NJ+GMAIU4iZkhfNKyPz7J6fCpRt1Ne9m4NLBVlF5CnFcQohyWhq8QmQeKyATDzrzHVky6RMC/F5twfjPpLos8dFlNkSU7bEIlIw7bdME08SCXq7K663VYUhKxXUDpwcqDVYJK+WBklINcKsxWhmia4onE9eOR3+c0mgBct/pWKqXuwlWcNufTpTcNPcUKfymeaWir9xmy63gE3d6iBQdauAYNrJJ6wBr4gq8xnUGgXKuvzNVolK27UD2dRwPIxurTJc7S01XMZ18v7W8dr6sbrNlVRg+ZAVuS9H0iKMudYQZz/GZ4EwFk5n6whRaULEZ1KEV7lKrRGqY4LPJPD/Mh7QRxHlzprPFUeCXebzLMTwCKD6kSJLjKvmWcikr/vv1KLn0AM5xCfnrdc20uMXXHoBe7xUyzBJ8w9d223V+3H1P8peF2TztNi5AKKcT1OeEgYFvXtNqeGlRa4oKyYUAWx3QZQEgy2r8YMcPQRBGkKXC/
 RAPzQo+a
 4gi2q+Y+TD5bZtdFNvzQ25bL3TyGIDgHlBXGXDWdqP1WfvQJOlUPZKMQJ1unW3XlxytwypsLR0x1PudbFSqsdSemfpd+ijD/79Zl68MrQE3VKlomjgAq0lLaYoiYd7+O21SMFyIHY6hRRAXV6h+OoWJ7aqZLqTI7CfIFDt2x98laQrokcS4HC2RT0DrwHaaQNSH9muSaiR4IE08ndh3j0w9sHXQNlZCWynrWbPLCEsHvxu0s7kCmicL0cSNb5jPmpGn66vtrQ+1bh04BY/++lYfiuAdikMu8CO7c0MVqIxRziGxTaQFJzGXBtjTJuv53O6Ml7kU9MrBv6Y5TWFYpyMeMl6l0fvVcw3mF5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-06 10:15 PM, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:04PM +0000, David Matlack wrote:
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
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
> >  include/linux/kho/abi/pci.h |   5 +-
> >  2 files changed, 122 insertions(+), 19 deletions(-)
> > 
> 
> [...]
> 
> > +
> > +#define for_each_pci_dev_in_path(_d, _start, _end) \
> > +	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)
> > +
> > +static void __pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> > +					     struct pci_dev *start,
> > +					     struct pci_dev *end)
> > +{
> > +	struct pci_dev *dev;
> > +
> > +	for_each_pci_dev_in_path(dev, start, end) {
> > +		if (pci_liveupdate_unpreserve_device(ser, dev))
> 
> I might be reading this wrong but are we leaking some upstream devs if 
> an intermediate node fails?
> 
> 			  EP0
> 			/
> Assume we have: RC -> B1 -> B2 
> 				\
> 				 EP1
> 
> and EP0 & EP1 were preserved successfully.
> 
> And then we try unpreserving EP1, we follow:
> 
> unpreserve EP1 -> unpreserve B2 failed due to a corruption.
> 
> This aborts the loop, skipping B1 and RC completely?
> Their refcounts remain elevated, effectively leaking them as preserved 
> state permanently? (i.e. if we unpreserve EP0 after this, B1 & RC will
> still get preserved).

Yes, but that would only happen if there is some sort of kernel bug or
silent data corruption. I guess we could proceed with trying to
unpreserve the bridges upstream. But I opted to log a big warning and
bail immediately.

pci_liveupdate_finish_path() has the same behavior BTW.

> 
> > +			return;
> > +	}
> > +}
> > +
> > +static void pci_liveupdate_unpreserve_path(struct pci_ser *ser,
> > +					   struct pci_dev *start)
> > +{
> > +	__pci_liveupdate_unpreserve_path(ser, start, /*end=*/NULL);
> > +}
> > +
> > +static int pci_liveupdate_preserve_path(struct pci_ser *ser,
> > +					struct pci_dev *start)
> > +{
> > +	struct pci_dev *dev;
> > +	int ret;
> > +
> > +	for_each_pci_dev_in_path(dev, start, NULL) {
> > +		ret = pci_liveupdate_preserve_device(ser, dev);
> > +		if (ret) {
> > +			__pci_liveupdate_unpreserve_path(ser, start, dev);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
> >   * @dev: The PCI device to preserve.
> > @@ -321,6 +403,9 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
> >   * pci_liveupdate_preserve() from their struct liveupdate_file_handler
> >   * preserve() callback to ensure the outgoing struct pci_ser is already set up.
> >   *
> > + * pci_liveupdate_preserve() automatically preserves all bridges upstream of
> > + * @dev.
> > + *
> >   * Returns: 0 on success, <0 on failure.
> >   */
> >  int pci_liveupdate_preserve(struct pci_dev *dev)
> > @@ -336,7 +421,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
> >  	if (IS_ERR(ser))
> >  		return PTR_ERR(ser);
> >  
> > -	return pci_liveupdate_preserve_device(ser, dev);
> > +	return pci_liveupdate_preserve_path(ser, dev);
> 
> Minor nit: I might be too nitpicky here (and it's NOT a strong opinion)
> but naming it pci_liveupdate_preserve_path_for_dev() reads better to me.

Noted :). I'll keep the current name for now since that is pretty long,
but if anyone else votes for it I'm happy to be overridden.

> >  }
> >  EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
> >  
> 
> [...]
> 
> Thanks,
> Praan

