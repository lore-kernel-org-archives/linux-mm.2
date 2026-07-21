Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46864C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 20:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8FF6B007B; Tue, 21 Jul 2026 16:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D752D6B008A; Tue, 21 Jul 2026 16:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15596B008C; Tue, 21 Jul 2026 16:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82E666B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10AD38021E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:25:26 +0000 (UTC)
X-FDA: 85013913852.20.C4F9630
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 30E2FC0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:25:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FsNNWw4K;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784665524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbz1iYT6k9l+H6Z3FTtCF6cLZIfTcAcJKlDT5dYK2AI=;
	b=ZlHilkRZ+CX5WVemm2RF2/+pDmMfJcOPVOWd/t2lTNjNMpA7Zcv4rwnUe6BxyRsDyfammK
	WnPm4aTPiPlZH16u07aWIaLtr0fIH0svcCLggLk4vGc6+xBN+ZU8NRdYR60opRCkKQycLX
	c7sTCsAQC0WM6o2G0gOeP7S2YcfGHCw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FsNNWw4K;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784665524;
	b=YqNzSPMAXyrt0SRkCrGkYZ8WMvzXvR8Nu7utnwDdMnVIuzMYOJmEcFV+fI5irKxzJf/1D6
	DpoPEKZGFKLFeP7WnK40YHw5oWf32D9HHcFSwxO3VTT4IBxp4lr7bnd7t+1PaUz2Ia4d/t
	efIdXfGrl5c5aSnm7Zet2QDhWEcD6zg=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cab973140bso144899445ad.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784665523; x=1785270323; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vbz1iYT6k9l+H6Z3FTtCF6cLZIfTcAcJKlDT5dYK2AI=;
        b=FsNNWw4Kd1ZFq8/76G/hkUxsyIuk62GswfQ+d1YuBhvRqZDChWVL2cLA/QVTXQoSsM
         pCmISCeYN0T8E996Kw6ndhtPlWcJr63EgdbQ/T0nTpZXqj7JrD4aYrkTB03Ou6/GMGRw
         N5rG+wWEJFBslTD7Ng54kk+B9nHjxV2mGHQO7W6fC7RdFNyv7kfMq6K+mKzfQezwqUTc
         hlhds8A9m8ZRF5UTTLUq5orR00FDN66Yy9rf4uVy5nAsWn8OPiHdbAiynP53UJ7P43NN
         K0U3W888cnHjuNhf0aT2TtADvvJ0dNnGMpBJNhjwyvZZc6sfegU0CU7L9d25UlgGxp0H
         jgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784665523; x=1785270323;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vbz1iYT6k9l+H6Z3FTtCF6cLZIfTcAcJKlDT5dYK2AI=;
        b=GIgkK8p3m51cOAB1xnfTCrgxlobCWTEh0AHfSI6vyulwe5Y/Xa0m6Fq4rJ1hUQEDum
         vf6CXmS4BTEuB3I3uiUaM3X7unB2peMqSUoN3QdCoc255pzKora6Dg5rZWmNJhuPKTES
         wNQQqO+HUGJNRhqA3rYBUIg1PjV+7oilcO5Y4m+Oli00z7egAKAOXYxizRqk4zSSAbVy
         smoyFbQQhCdWlt3F+kt3k5lVxOxWwfLxujoClg8HGiP3IqX2FS34gKx3jWXr3uIweSmE
         qKsmXhCWQMUTETusP+QDFSmaZXm5HLntfSaQgbnh4yS0oYgnOF7132K/ziUdpZYAFU7k
         +kow==
X-Forwarded-Encrypted: i=1; AHgh+Rr9MO0s/rgno+FDwMkyBJHHjoMJrguXKx510J5GIDC1GfLvbASKBbyjRbzhS7+c3UXOxDjclskKEQ==@kvack.org
X-Gm-Message-State: AOJu0YxiO6pyE+ev3kVlPIt/ZVKshiT9+C+3UWurEPcaznElDD0p0ZxG
	Jw0zWNfsJUeDDD7mC/Siw+VVld//qY9Rtbhg66/1r4iJB8zuJw3hHRFAh9JHAOXICQ==
X-Gm-Gg: AR+sD10G0hwpxLXDEISPurmEOU9TzpSXfCvrt3tLDbB97PnnJWCvVnGacBgPQtFJho7
	DICXRDWF5CIki1FsKXXkYUHY9DMbP71zJujz4JQZC9MB7OanwFz5tEF2W1H36cdSYfUbhD4VeWO
	nfbCaYy8edKkUifjBYiCSi54uEzqAIv6RTft7eoz/dLsIgnCu2St9V8dKvxO/eZ18F9CozjaUXo
	8ArWHx1rcw4RnHc9L4Xl9I9RpkMlEnJxYkH1TwjJqnM8Lwv1XgO4lrnn9V4gYUtqgafEFpmkfI2
	8W8+eu99ue3GPxWVhRqrNc4RQ9zq19YpE3tXbe4cJNzdyEoh4P8JWiTFBU2k6m+9Qr1sDSzhXSe
	euwPv+qAiuFpPk1k8nteh74OuPNMgnEkcxEptnhjvDJVjaFLNO1DC8pfwuKXizVHCLj1e8Fou90
	L5nXtnDFyUXamjSQpTO0ZLGhz/ASnre4UaASmors3L
X-Received: by 2002:a17:903:b08:b0:2c6:90ec:f601 with SMTP id d9443c01a7336-2cf34835859mr235453285ad.8.1784665522497;
        Tue, 21 Jul 2026 13:25:22 -0700 (PDT)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f3b7c9dsm2391865ad.83.2026.07.21.13.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:25:21 -0700 (PDT)
Date: Tue, 21 Jul 2026 20:25:18 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <al_VrpvPE-RLCF5X@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <178458744511.332171.13770778781241262180.b4-reply@b4>
 <CALzav=fjTOnyg2++GFFe5B17rHqNCWW=afjsD0A=EEjycPW7Sg@mail.gmail.com>
 <178465652971.412167.17838319728990505256.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178465652971.412167.17838319728990505256.b4-reply@b4>
X-Rspam-User: 
X-Rspamd-Queue-Id: 30E2FC0004
X-Rspamd-Server: rspam01
X-Stat-Signature: hh5neeqghzx57nzqib179u9w4if7o8t5
X-HE-Tag: 1784665524-379447
X-HE-Meta: U2FsdGVkX1/PQCRD4ra0hY+DXa+5BhyzjnaUPijprEf3wJ2bD2sbF/jVHs6PDP/+aQ5fCiFcL1ES9P5JhVRLcZhQO+pTaDzj7mwWWCQddUISeEty7O33BL45bsRoQATT8imBmqWJpTBOQJzFkxbGcZ75WNCuOiqAIMuG/tDCyDlTrYEzYHvBuSFfkh1/kgxJrrLMdsyxkASriWJ0j2Jg7kI2/uXs0V0RXmgnmaKUytyZ31IMpbwtbhUs/HvfONDWpZcCSFM9YldFExwN1qeoBDRhT++S57IHW8FboP0jb/ZmzW6hTewDXRXY4lAQOVw7/phOXqqrgTdJYTy8lvpLkBYjZZ17BJwYl7v+p4Iz0yFSbkGkDS7bYDhr5g3UEE+fiMeBXANyBuCibKOSnLZvelJUFSQm6DN9SX9miUpsbBYu/Bh35VFkWba8Vm3h3sbabIVcfL96RLWJYMDgIX1Dc/lBIBW2PKd+AIfZbdXw3mNIzno9nUkU0RNgpUfmOGMcdkuYDbKhRB4XVHXCVeh2sIwn7JUQbbSoo59my9dNDhUyFEX6m9t4Gy4XlnFKg/bq0iQYXUZqZdZM0Z1TCRY/unlUVXOA4xyTh7zn3HKNzgXk1JOeSAQZNqvAwv0eMVYHGekmH0cc+pRP5d5PKNSU8VTX3WSwVBHPG28/zwbjC+eXA3ycsdVEiEwzPyj91s+PgX1SO9Ezps2ftprdo1ud0YZYYTb8Qkrjt7ntOYEGOa2nv+g3Jbu/3JSKO+vgWR7jUWBLlvyOXTeEwX3bN79PT7nqsv1C84ibZNUWOSDCrSJOiMTlurHHQN6FZVn0n9n0VzlItKawNZcxZ0oRPxt8SqOF5rsFL0SAemfuvR0Ifn5nFObzPDSi7eqxxh4IJdvcWidO9XUBbFlkNyQ2cRmvyQYXmjQw0DxnWDXv7vPKR/pEc5voRV8iM92RNA32BRD3K0/uOc1bygn4JxKLkQ0
 ILX9T5mf
 7Ev48Lfz6jBOkO0c9D34HQnTG+psI+7CYAXq7nlrLIa4CHjwDXD8j+8w9cjFVCp9FgfGxcDCQjWaEGdLcqC9mCkRWcZaMq/RiuLff0l3At4by9rP7D/TymjMKoEYN85SlyzKbqVeMXcLUA8fyh+0Mnfko2cejvGPnJKvhtBGWro9gIrdFoEcXFSV2Ny6FkfibcWVxentPSL9eI7LHSSJmzUezoXmyzqZdpqR4svSYGubqJPtCqU+q3wmbB2/m4TmNBCGxkGfun6KeK5V0dbe+lQVMGdY6uHy3P/Rh2ez5vbCG11Rk5GMEpTdeBFHbDRmGU6Sf0sWmw4DdSjuXNPrOUwmN24NAnA6njvGIQHW04tGTSjGNAvrJ2GKav8BXVe5obrOOK4YMZ6T7d8DUZwqD4W8WhDFyCiCUbS3kxELw3Ns/isE76G4OOyaljT22ZA/oXHI4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-21 05:55 PM, Pasha Tatashin wrote:
> On 2026-07-20 16:07:47-07:00, David Matlack wrote:
> > On Mon, Jul 20, 2026 at 3:44 PM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > 
> > > On 2026-07-20 14:54:51-07:00, David Matlack wrote:
> > >
> > > Thanks for the explanation. As I understand, the most straightforward
> > > way to avoid holding the permanent reference is indeed to delete
> > > dev->liveupdate.incoming entirely and perform an xarray lookup on every
> > > access, like this:
> > >
> > > bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> > > {
> > >         ...
> > >         incoming = pci_liveupdate_flb_get_incoming();
> > >         ...
> > >         dev_ser = xa_load(&incoming->xa, key);
> > >         ...
> > >         pci_liveupdate_flb_put_incoming();
> > >         return dev_ser && dev_ser->refcount > 0;
> > > }
> > >
> > > However, as you note, this is inefficient because it affects every
> > > single device and adds lookup overhead to every access (not sure about
> > > the actual cost though, xarray access is pretty fast!).
> > >
> > > We can, however, still avoid tinkering with the lifecycle of the FLB,
> > > and instead treat dev->liveupdate.incoming as a "hint" that we validate
> > > on access with a fast, liveness check:
> > 
> > Can you tell me more about your concern about FLB lifetime?
> > 
> > The lifetime of the FLB will not be affected by this reference unless
> > there is a bug in the driver where it fails to call
> > pci_liveupdate_finish() during it's file handler finish callback.
> 
> From a design perspective, liveupdate_flb_get/put_incoming() is a 
> logical read-lock/unlock pair on the FLB data. We use a refcount for 
> optimization and sharing, but holding a get over a long asynchronous gap 
> (from boot-time device setup to driver probe) is essentially holding an 
> unbound lock.
> 
> Unbound locks make it difficult to trace refcount leaks or debug 
> lifecycle issues.

It's very standard for refcounts to be held for a long time, e.g. file
refcounts and device refcounts. LUO FLBs themselves already have
long-lived refcounts taken by each file that depends on themm, which
aren't released until that file handler's finish callback runs. The PCI
core is just doing the same thing.

> 
> > 
> > > 1. At Setup: In pci_liveupdate_setup_device(), we do the xarray lookup
> > > once, cache the pointer in dev->liveupdate.incoming, and immediately
> > > call pci_liveupdate_flb_put_incoming(). We do not hold a permanent
> > > reference.
> > >
> > > 2. On Access: When an accessor runs, instead of doing a full xarray
> > > lookup, it just validates the cached pointer's liveness by temporarily
> > > securing the FLB:
> > >
> > > static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
> > > {
> > >         struct pci_flb_incoming *incoming;
> > >
> > >         incoming = pci_liveupdate_flb_get_incoming();
> > >         if (!incoming)
> > >                 return NULL;
> > >
> > >         if (dev->liveupdate.incoming)
> > >                 return incoming;
> > >
> > >         pci_liveupdate_flb_put_incoming();
> > >         return NULL;
> > > }
> > >
> > > * If get_incoming() returns NULL (the FLB has already finished/freed),
> > >   the hint is invalid and the device is no longer incoming.
> > 
> > This avoids the xarray lookup but still requires taking the incoming
> > FLB mutex twice (once for get and once for put) on every access. And
> > if there's no incoming PCI FLB, the LUO will iterate over all incoming
> > FLBs under the mutex to find it.
> 
> Can we do a fast-path check first?
> 
> static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
> {
> 	struct pci_flb_incoming *incoming;
> 
> 	/* Fast-path to avoid unnecessary FLB querying */
> 	if (!dev->liveupdate.incoming)
> 		return NULL;
> 
> 	incoming = pci_liveupdate_flb_get_incoming();
> 	if (!incoming)
> 		return NULL;
> 
> 	/* Check again, now that FLB is acquired */
> 	if (dev->liveupdate.incoming)
> 		return incoming;
> 
> 	pci_liveupdate_flb_put_incoming();
> 	return NULL;
> }
> 
> This seems to gives us the best of both worlds: robust refcount hygiene 
> and a sane fast path.
> 
> What do you think?

It still seems like an overall worse approach to me.

 * From a performance perspective, the PCI core would still have to
   acquire the FLB mutex twice every time it needs to use the device's
   serialized state (once to acquire a new reference and once to release
   it).

 * From a locking perspective, the refcount doesn't actually protect
   against the device itself going through finish. So we still need the
   pci_liveupdate.rwsem.

 * From a hygiene perspective, each reference is held for less time yes,
   but there will more places in the code that need to acquire and
   release a refcount.  That is more room for bugs to leak a refcount.
   So I'm not sure taking more small refcounts is an improvement.

With the current approach there is just one refcount with a very clear
lifetime (that aligns with the device file's refcount) and no extra LUO
mutexes required to use the device's serialized state during device
enumeration & setup.

