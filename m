Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D0ACD13D2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B516B00C4; Thu, 30 Apr 2026 17:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553086B00C6; Thu, 30 Apr 2026 17:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4689C6B00C7; Thu, 30 Apr 2026 17:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335FF6B00C4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:15:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2CDA1C04AC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:15:23 +0000 (UTC)
X-FDA: 84716478126.09.B7AF191
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE0CE120007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:15:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UeodY6Ue;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777583721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuRbo58QsKRQvu4meQcJrzjCe/FSskWcv20z3c8VC1o=;
	b=yKf433qoVavuhPoQ7YQNaZLhD+iRpGWrXQdI1icqNoLp4xI0QNKNxmfbD8Fjt+S/AhsNUq
	PPsWRVlp27rajJIKQQzQhkEbVZBbP7uXM4u0U7wcYmNZIkzB6S13cDMOfxmuKSC0ImJKel
	Ov9LPqfh/vUE0d25U661KD1Ge0x7xfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777583721; a=rsa-sha256;
	cv=none;
	b=49YM98yNVNumVRpsKoYAWP8S21OWtSglcPP3RKOvdNz7fbI3hPCFKARoVfaA9WvgxqlKrR
	Ncf8nFrKKOXj+Vxa8yQOQhBjAao8LLkmnuOo7LCnBePBa/FvSbcWfxHgyBXwwxyIjHUHrW
	ebjWlgnRNDi5Dw0So0wBlN65SR1RUk8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UeodY6Ue;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35d95017a68so1134413a91.3
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777583721; x=1778188521; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tuRbo58QsKRQvu4meQcJrzjCe/FSskWcv20z3c8VC1o=;
        b=UeodY6UeBFnIVgkmRrP17ZXItTbmKTOx42wq3cIAWXX12jYQw/JMmmuQmL/BUIFs3H
         +9P3Y4HEyrnUjLEY354rir25/cDo8jwRx3OL1j80/s1dBkT+00th40NWo6HHYH2ROZv4
         vBIGsPQutfSTMh/wR8wTLHl5T2BzjItejuM7ab6qQALUFttWuyBCWBeYha0AOPkA+Y28
         JayuEWSXOGFv5JlfjGusqyKhxs31TJ1ebHJvlA3CtBaW96j5nj0W83ZdCVkyFhxemy8f
         rnKh7rcX3ZrI2x2euMAICK13XCi0JOUpfGTIxIbVz/UNPUrmPgYKUN96plrg257dJ0gh
         0FQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777583721; x=1778188521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuRbo58QsKRQvu4meQcJrzjCe/FSskWcv20z3c8VC1o=;
        b=a4PkiKcMwx4vd6hIilccJxxQ0a400HPRoY6fXib29p/JCk3LWzk2H57h3EClhd5jf0
         bnkZDRzA//7T3G+r/o5++ODiRRjzQ4JZdmaN4+hW8R/FZ5JJ2qbDTZPbeL8V9yurFP9/
         0NSXHFHr503Brez8YdRcrgpHtjaIVtbxxjtb4EqZ0va5ZdcueYJMTq4NtMDAuPZy3Jgx
         N3qIXoA0jvXLnZWlUJagsAj0aREVfd9+43dcEzRPfSdVTHq8mJAyuzJpBdch3t+O8Gf1
         OE7IaAych9rKYMzonNvYEREPXDSLq7Gs/fFnibDLz4+9lM9Ul9RpwrdzckPS4dU2uMSs
         3WaA==
X-Forwarded-Encrypted: i=1; AFNElJ/0h6BPaxCHevZCi0hD3hRYm8gxnf81amYdqQKSA+xuDX3KvOgwizoo3ZCHADooCl5XYX4Hbtmxzw==@kvack.org
X-Gm-Message-State: AOJu0YwNdxioax4YDAMCz3ifN8juS8Rwx753ohmn4GExYuSO2jw77Aug
	gVTlGL2OK+zmGQW+FIZvXhDLoXeH9CmXsgbBHklGJKZ4fsugZgbmNIjOgwAyYOVXMA==
X-Gm-Gg: AeBDietWYXRfhV8aP+Mm0lkEwbQL6A7NL9CwMcFdP82CBJ/BZLDLVt3Zu44sWxni1WW
	gDFeVs9EG6RbA1f/4N17stxEoEEfEGwPcu5EUaaLr9HVf1Q0lzD37ND9dU3k1tpb6g0J0OVImxs
	9sAggjFvw64N+kfRPQTBZrBUzxotwf87W4vGqXxjvW2uVDt5bmyCAyxTTI61xm6t9GZgAzhl+w1
	8rJPcMyaeymndlPq2OlFeTjqDTKZ9m/R6i1TQc61lUff99GxOOSr7nv932SZ6lE6zsOgzV7Iq78
	Sgv/pIxfsAWvf2oa2GxHNNrobaawQGwX3ft5pH41Su1kvhQtaedCq82/UFkDFE5BeS1cURwzRgT
	btB3W/SztZqyxn6CJCC6Pe/kluN0FBMrtVRr1dUSVzoFqohtQdXsWeJfen2Sd/NhZVuqE5VL3Ae
	3qGQgBlEcfpoFDd9f6Y/3NVF1FZdbIp9NRORmoztlquABDr3vGAklOELKdYepPtxB6tHUMLfdXC
	vuaeRofaWw9rRk5
X-Received: by 2002:a17:90b:2790:b0:35b:e51a:ec77 with SMTP id 98e67ed59e1d1-364c309bc21mr4610958a91.16.1777583720228;
        Thu, 30 Apr 2026 14:15:20 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364ebd46484sm474408a91.0.2026.04.30.14.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:15:19 -0700 (PDT)
Date: Thu, 30 Apr 2026 21:15:14 +0000
From: David Matlack <dmatlack@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afPGYp145FbrvURR@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <afDqs6oqWlhoVqMN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afDqs6oqWlhoVqMN@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE0CE120007
X-Rspam-User: 
X-Stat-Signature: pob8zsxipmkm4e4uunuu5fne7b4g16qu
X-HE-Tag: 1777583721-799312
X-HE-Meta: U2FsdGVkX1+Ccz6K+a7kLlJx+L4gJj6FhlYxGoPwTg51POpKp3yjXUUbslXLOLUAURj8DjarjQwqY0YwPwyRmKNvx/KMz/cyc3Q7CdtkSu5T+0/koxeXjUEdfJfpvd4/PNJ6JdDXM/4OoItSYNoQlYHUqSlVn17EEGTKHf4QH6yAz+txvmBG/Dz7iR50FH/64tgzQfZjSWKvgb7vUfKlBDzaAqtWxkX8NrMSu2ViyA/4w8YSAklA0PoZwUpObcVJ645Qy/PiTajdHitYOSHgvwUpPs4ofhXHF0dU/bNB8Yddt7RLp/9lHukPJhp9+3466s0bDk2E7Ubtxtup8yqLzABtWh83bCXSj/Al7jScI395Pp2+55AIOJAiQtQjebQtzKfMRfWnBjOOit0jXqbex6tTLSreC7DivPRH69qjg+bkjIC4gys06hQsBiqHh0oPS/m8J2JyaHClzy2tth9lQjo1h6spWd47++UesGbZjr+n0YcYHuynMWGp47QgR9vnM+hLUTd0HtGCB372PRdEMnaOjII8elSP1jT1sM1GuFwClbIi6qio8pzbTIhHEmYq837z4sp6+nmM9n9AWfmxv1r+ewMDa1Oh7Ki6TpMycGef9wsmV44eyQ3M5yI3lZz2785OOFetRlh8N+ta/+lFjUfl9CvFEbLvQe4KLok01eioc307nhNFmGkS6LdqzzYlPLkiNga3gEciW5wSbtNatIhXgVFLtE6twXqMNwEobdSRBjJVS93DMKXvv0r4GK3fyd0Lu0nJgm+6R48sm0iiLfGh/hgZ4Dzwl3DTpWEWgjTM9bffBEGp9dcJwujZtiwcEKn3qx91RAe7BfvRcVQHzXJtDDC6vyAPJYJmkLfSwbfFi9zcLe8iKeOx36CiKnUs67n2vmBF3P1oCL4E43PU52iYjQrq8vjAoqRkWjqIGv0v5r6p2KffXIBxkv7E6AiCEkTv8aBvJ6E1pWkLeIt
 +tPl/iZ3
 x/cSZEuMmIaTLiLFlxPgHKjoPtjPryQIeRQMMzhwptS1izxoy83NHK+DiAozZkiXwGjctVZaIAKz658xVxBZIFWzrCD6fUY6OpDTTwV/7UvhbC+bEdB3tRgpFDwKYNYqZQfdeB7EbpNixAR8SHwqQk4rI+bOzuyoq9lgZ54gvq2WnBZTzfFTxIOR8Ua79xO3RbCS7+vPzU0GvUhvrweWVdQeghd8EyTCRhWcN2wzydEsX67gPJGV0+dBnu8NMKUvUtoSUVe/7eVeTIkPq+rDoZZNqLcAmamOcfdOHBti3iwB99UkWwpzAAatd6kIQHkLsknHXJGxJNfjnUs5wUjtOD1gJm0v80rUAive+zbEoPFlAba0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 05:24 PM, Samiullah Khawaja wrote:
> On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:

> > +	for (i = 0; i < ser->max_nr_devices; i++) {
> > +		/*
> > +		 * Start searching at index ser->nr_devices. This should result
> > +		 * in a constant time search under expected conditions (devices
> > +		 * are not getting unpreserved).
> > +		 */
> > +		int index = (ser->nr_devices + i) % ser->max_nr_devices;
> > +		struct pci_dev_ser *dev_ser = &ser->devices[index];
> 
> nit: Maybe we can move this logic in a separate function as down the road
> when we expand this to add VFs and Hotpluggable devices, this might
> change significantly? It's good if it is self-contained.

Did you mean to leave this comment on pci_flb_preserve() where it
decides how many devices to allocate room for?

> > +static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
> > +{
> > +	return dev->liveupdate_outgoing;
> > +}
> 
> Is this expected to be called under the outgoing lock?

For now this API is only used during shutdown, at which point userspace
should have already been stopped so drivers should not be changing the
preservation status of an outgoing device. So I don't think this needs
to be under the outgoing lock, but it would be nice to have some more
explicit synchronization.

