Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98132CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 21:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440686B0088; Wed, 17 Jun 2026 17:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1F86B008A; Wed, 17 Jun 2026 17:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0D26B008C; Wed, 17 Jun 2026 17:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2E9C6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:44:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B8CD140498
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:44:20 +0000 (UTC)
X-FDA: 84890733480.14.7B10566
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CE9480003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:44:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wc5EVqH6;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781732658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVgu7F5iihyCKu/G4stgDOvBtLDNemb1ZVF8TxvBGyg=;
	b=dJYeiNqvBr9stK6L8EULU3fLa2GDjRZlMTfK+BW0alYhG/QWzSZ5Jsh83eTzsuCXZIqWms
	Vz8/wkPft+DwsnYNGMGmEKKSDXeodYV9kLp4shXG9WJ5wtO/Z8n0LOS2ykUig0HFJcTWt0
	OvUA4fMvKj3k7l9GI79mBLsdPQsP4II=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wc5EVqH6;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781732658;
	b=NTBvqgytTL32hT+Pfm2Y+AIjx7H6BFsi6YOFFCcgrrkC0Azq/fJxSstg14gyhtq4VmxAOX
	+IpizJPYqlOaaPGg3SZ722njK4KOj+GSVvDSbHcRpWxtP/EAa1IgN4qelxavU/jNCw0c36
	C87DIjID4eKStrt0ebvMYwIC9vHL+/w=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-91578c374ecso24131085a.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781732657; x=1782337457; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVgu7F5iihyCKu/G4stgDOvBtLDNemb1ZVF8TxvBGyg=;
        b=Wc5EVqH6k1kRUkIo+/hxCslKiUCk1sVhVVxWlT2ipFKo87BcKvcEjaYP1IHDky2vnT
         VFsamabebiM0LDkg4ZK3jHmVyUHFd4WFCyqcQ+neolh26ekwYzTj4cGGSmALqJiVMnST
         ygTiD2mN+HoWaw9J9iR3g24uWb9KdfSZNURmOKT6wx57CcX2Ym5r+ry7xVZ92ogsHf12
         PQeaNVLSk+GZonZMczmeCmoMGnjZ7YZKtVnAE1M0NFrje38jYtEMhWkhZkjC1hgk6wOM
         rsk3XhD+cCWEJXxRoLtPXqN/3cY4N45u7zJ+hMtiBqXJKmJhsGGwcUIUpGctk46dyzys
         5U7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781732657; x=1782337457;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVgu7F5iihyCKu/G4stgDOvBtLDNemb1ZVF8TxvBGyg=;
        b=GuIjnKomnhEGnGkQcVJCTNsRFtKoyCDzshVoFROlLsq3VUJ05R2UaywXR5npDP1cYo
         CgUg7+GjMoZnsfPaRjtnEu9sJzz+e5z4JBk9/JE5Ju68KTSI8DSYaenttDp9k4PcjzJm
         oQMK9PucSV5fiPkz+fRBk2MRGfsUnzrPo+pYTiMD/Y6p8LNeWsPcaPsk/9NvK3VdUCo/
         UCo26ym/PDbSqA2EfGPyeT+FUmLw/p2n89s/7aH85cONBEEkGI6orqtl8dX5ZO8D7rn9
         xJMcYumENGGeikQbA1fGLWEQ/0U7Fg9hibEK4Fnz51uxYcyrfBUTd//hQXiLyh9wPchn
         qZHg==
X-Forwarded-Encrypted: i=1; AFNElJ9TFfC+eNM9hMcmGAGCP0AFBvR99BcBbZuEQW/89K85WyRmv7Cllspc2qwK6r+CsSY3C1SeFNeHjQ==@kvack.org
X-Gm-Message-State: AOJu0YxxkBz7vUWss8o5kmIPXMHMsKifSHasUK9noqmjV8YrnoihrsHW
	G/0XgEIW7Hoy309ZmxmLVHZEjAaRMNI9n33pwMfau32uKi9EWFvSOXKI1aMZeIn7oX0=
X-Gm-Gg: Acq92OF5TC9Ogct8bPe3qN4M7uN8NgAX+S/ZzdvONXV7OGUOPd8vz4fTMyxPjiffABx
	A4AzsY1P0tfPshOkSknhCByILT9j4iPE82bGADikTWIFBlPpi4FIz4fLf7TPl3qKoAhL3qDLHgp
	za4pQ7YR+skZAQkKBOaj6HUItlJnR3VxzxCpOYTa0GVD9kAOC81I6fulGd3XMom07Yce+Qq3mJH
	i/Z8zgLpXw8nmTleR2il0K4Igg+PLG+eg50++iMOEIxjPT9ucw91qk/vlC4vf4DN7RQZ2x6Gt3z
	p7SeIhZJUCNzLEvBEoXhEbrT8DeBcGY1iy2kY1sbTBCfgD7Thylq9GcvQQNvwVsiRHS6M6jVMu4
	0Z2BuSQ5bG90Y7QpqDBsBXQx0XePBwWxmaTxEje2gH9/VsL4a7jFi4QdmbdDrK0XFfHwIb/T9ar
	vSvtjKC2pCjyUjHsqcdBx1sfKhbG84ujAoHP+N+f3MnnKFTM1T0pA4NMOBc9sy
X-Received: by 2002:a05:620a:4710:b0:915:7c1a:1387 with SMTP id af79cd13be357-91d8b4b82d3mr974163985a.38.1781732657342;
        Wed, 17 Jun 2026 14:44:17 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f3c324sm1871381085a.21.2026.06.17.14.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 14:44:16 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the
 PCI core
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ajB7EA4tAKqj5XV0@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <178124130274.908199.14827357870284807134.b4-review@b4>
 <ajB7EA4tAKqj5XV0@google.com>
Date: Wed, 17 Jun 2026 21:44:14 +0000
Message-Id: <178173265446.1266136.13359060486033428626.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2540;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=QZkluUiynr9FNYxq4HTOycC4NrsYyGj2uEdu6jqluEM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqMxUvPSD7ryLWoiq0RP6QzEW7bPRTwRVRK1iGh
 4D9ux7x6z6JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCajMVLwAKCRC7dyhM23N6
 3nBkEACIr+qaiFDURkLLKmlla4feY3MYdO7YczubseLaSQZvERTE2vIj19GVL+rKpHxOQTGKjdZ
 6x4uuQzZ1P/ZhxH0s02iqkxWZaYln8HlySKfJ/yRRSj4Md9jM+ui4VxXSMdaEPmxaHTn5xpasmr
 08wdcAPQu9z55T2Bx3Qokb6IF73WyIUIQROgK8q2E54RVuu1OnA14jbvCxyUwY6TTg5MiPHoqAo
 XeBjnZRpboyLxod5YlWDalguHWvvUODhNr3JCmQakJh0xzlC4m1tKgaU+DqgjnSco1PJQMMEgLU
 m5HRtfrrVci4ONbgHzaLQ7y6Rnw/X4gaS+3Ygz+jwYxxFHPGYbUCba/8f1sbRMPknCZhXjjNAS9
 5qRcK97cF6j8aqGrVz+VzKp+z8E6XlWdZXI7Obrcq8C3iCZbvkrNvPcrIAlpx/1x9QmosSMGrpd
 Em28VGCwMHhk0wMDJjvRQ4a0B7+Royl5PzbuLa2m2gxPfLDrjrxkyvHkPydL8A9Tzkp97XCgZQ8
 oMpmW3oXUmYg7Dep1lgEOdQgWiaW57ZS+s83v+pA87Zizu9zGVXVCSZD37h/nVmk5clhlqiH0po
 lcn9njTOGIFROCuQWZBh8jWGH2hMvIdPgL4UpOd7oEauXLnkDvjTcBR29cu6ThJH5cUTDeLIrFy
 VqYf2itiyoZMCqQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: g6zmycpuqdjtkr9ynwdoyad9ucqyn91w
X-Rspamd-Queue-Id: 6CE9480003
X-HE-Tag: 1781732658-530598
X-HE-Meta: U2FsdGVkX19p/A9YX4PZmB+OYOaGsxyjs2qiZJkbBVoaU2OpnMGh63KRVBkMI+MaT4jlIgZfW+RJAKgtwnhT7kfsg9jd8TpcfFm28s+SIY6LQjhcKETq7hm4Dt8gVyw3G8AgenpP646rlAsZO5rjufu0v1ppG0SF0imvUumzTGl+0Y932/LGxWjqH/E0FGEEcLwkp8B3ND9kQU+cFHkXFBCaxUMFEImB5VhaZtsgpUlEbNPCFkqwikwkk4gW5l7DwLUFfHDe31X23+BCaw1AuqwVa9D7+ArRJNFQbsr8JHwjl5062nw68qYgBUNxTdo1++m4GdX2NfFh2kBGAlD4CV0W9gbS/0EEqKVQZkxzTx/4hz7843IHfn/pHtC5RgtJ0oOrVzvtlz5mVUiCq1dtMfUejPSbGzZM/rVTbVFq+2lpcK6TxLSWYYFDASmzE7VCTjABwZp3R/wiCgyEzDDluqHZUb0wSlLF1d8rVXtZjvWfUfpTKRa56qfgP1s339Fp6exXNEEsVdbaKBFp+aBdcvB3BzMFWPLWpbxyKaLlyAN+xPKA+mkfdP7W8HBxkra6ivswrtxvhMDx7CFwqz2wsVBdhVqD0JxKZa6KSAit5ujNepcgRQwFcHRwoPKZyjfDKpVo9Pakk8iJF5zXgf6MzTzxQGjKaIevBGmJAyI+3Ul+ZdRNJxQSJb0v/sYyuVloY7fxYaNq0yQrPQ76PnCsaswX9xoCfto+TiEOUn3DPzAX3sJELIHcAANmxH+FXDibyAUxxyHfucXMa6kY2fPAL5FYM0D78WJdimjbnnvaKkvZvhmj5nDRyRGwOmJsyIJTfe9+taDl3nhwAKKAOiD6/iqiMLFKoTjgDWyoZ/RnZHknGVxaJ+IljFQxeWitEPhNmaJlgwgQSU7P/Dc1Qb8v0H5wmC+zBUYqVdMT2r6CyKBKjHRSPCHLGVVj71yGfYm86JpdWZ00AGXhHpKnKMF
 tc22TrWR
 rBMk26R0o5vtU2cgES2Itaowniu9RpkDR813qFSN+wyPYe64WaiXxblDXrQQzunXBwehRYvKh955UzGa6+Ubu/+XOhQCAU4StfqYedAHEpMO6vxdUBxi+uBOty86p1HxgMMH4FlIxeqQEL+O5I6IgrxESPMQjEANX50iVrEYXeTMdT4bgfNUi1sGhTFAvEyYel45HSsJkWcDwR7PfvAwf8MoQUY7qZQYmyu7sxRvefIqfwz3STPtvNzWKmP9jBwqYs6/LhDT22iYAacbAdjLcj0UVfgF2S/gLIEUxseh2HBb0jqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-15 22:22:08+00:00, David Matlack wrote:
> On 2026-06-12 05:15 AM, Pasha Tatashin wrote:
> 
> > On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
> 
> 
> 
> > > + * PCI device preservation across Live Update is built on top of the Live Update
> > 
> > I prefer to just use acronyms FLB, and LUO, but have links to the actual 
> > documentations about them.
> > 
> > So, something like this:
> > 
> >   * :ref:`FLB <flb>` Data
> >   * =====================
> >   *
> >   * PCI device preservation across Live Update is built on top of the
> >   * :ref:`LUO <luo>` support for file preservation across kexec. Drivers
> > 
> > And also add _luo and _flb to Documentation/core-api/liveupdate.rst
> > 
> > .. _luo:
> > 
> >  ========================
> >  Live Update Orchestrator
> >  ========================
> > 
> > .. _flb:
> 
> Will do.
> 
> I guess I will need to add another patch to add the link references to
> liveupdate.rst?

Yes, it can be a separate patch, but adding to this patch is also, OK.

> >  LUO File Lifecycle Bound Global Data
> >  ====================================
> > 
> > 
> > Nit, may be:
> 
> Did you have a suggestion here that got lost?

Yeah, I meant:
#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt

> 
> > Please sort alphabetically.
> 
> Will do.
> 
> > I think, we want to use kho_block [1] (it is in liveupdate/next branch) 
> > to allow number of supported devices to be dynamic.
> > 
> > To support this, we would redefine the ABI and tracking structures like 
> > so:
> > 
> > /* include/linux/kho/abi/pci.h */
> > struct pci_ser {
> > 	u64 devices;      /* Phys address of the first block header of kho_block_set */
> > 	u64 nr_devices;   /* Total count of active preserved devices */
> > } __packed;
> > 
> > /* drivers/pci/liveupdate.c */
> > struct pci_flb_outgoing {
> > 	struct pci_ser *ser;            /* Points to the FDT/KHO-allocated ABI struct */
> > 	struct kho_block_set block_set;  /* Controls the active blocks on the fly */
> > };
> > 
> > In  __pci_liveupdate_preserve_device() , we would search for 
> > and reuse any inactive  pci_dev_ser  slot first, and only call 
> > kho_block_set_grow() to expand if no inactive slots are available.
> > 
> > In pci_liveupdate_unpreserve_device(), we would simply 
> > mark the  pci_dev_ser as inactive.
> 
> Makes sense at a high level. I'll work on switching kho_block for v7 and
> get back to you if I hit any issues.



