Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9955BC4451C
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B516B00B8; Fri, 17 Jul 2026 15:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BDB6B00E0; Fri, 17 Jul 2026 15:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B0F6B00E2; Fri, 17 Jul 2026 15:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25AB96B00B8
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:42:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 900BC8023A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:42:42 +0000 (UTC)
X-FDA: 84999290964.10.C19DC55
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id B502B4000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:42:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RBDf1Hlx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784317360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwmOrmcqXQWfj6rtFo+8pLNSVXYkj7WYHrCbKkDrWe8=;
	b=EHT1gzUsXtemUMbHCgaDTQY/a6sZ+bthi2tk5xRRkZ6Zp2QRQ1hhIUcoock4zvdY/HMygx
	3SpfrO3eBkgtjiZyhkCY/wuKXqM5ZxLCwgOgyXYxYHpftZ2MZ8p9cpqvI5J2ODLSKCrGJw
	zrwEWL3QKoOblGqrb0B1Tyvw1NTRqUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RBDf1Hlx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784317360;
	b=7m9gHPnEVTDs47gP6wHHDwqAR7z/txuA6QWWQNuUYfOYOSkfIbq0RoObiRYSR6aiZ8JHZR
	9kjLTc+ldOW8capSL9sQ0SFGNKftc9QXudLfsBF4A7rTl7dFgxjn6y1Q1Xk6ZXiD4Etz5N
	/javFYMpdbhqVxW+YA0dCVel0XmDZGw=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e53581361so625823185a.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784317360; x=1784922160; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XwmOrmcqXQWfj6rtFo+8pLNSVXYkj7WYHrCbKkDrWe8=;
        b=RBDf1HlxqpuzVXCRAdRSRrvemmOpoOfsFnHqrWb33Cdr8rWsSgDVV18AbEP3SPcjfx
         kaalckrrad/4p8w0bILC+Sa8/M5SDuP1BUYHszH+Db+P711T7a5FzJxQPY6Yru5tuqCL
         zCaaWA4Jc/H9lnsran94/e5TDtowrCehhHFdJFhKWSZR6ikWn+KbFku8Uo9WbufxmlKh
         JIREre9+53C+naK5fncgv82cR6XJ0ga3W+dF5wg7U4oeg5eOlc+z60z44Jpz+syQD/iz
         8KKd16R3urjXWNYXox+YBXMpFLW86qd3U/uZEydnCatxpNxMBnD4NKn+oRzSxzI24Zim
         fQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784317360; x=1784922160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XwmOrmcqXQWfj6rtFo+8pLNSVXYkj7WYHrCbKkDrWe8=;
        b=Bf9jFZZUIDV90cCfQwqQK85NxU9oeqZolm78XgktgMqmaK6HlRQujvlWDNbfe1PKXx
         BMKSK/doT6Xb61wB5nDyvpphj4vuLUIUZyU88ZjILlQHCpH+NWdbQZg0amkxpPvLL5Eh
         i0/gXNIwveBLJGdtIoXAYGFp9F8ttpI1rcgph4fNo1R1T4jq2nDL+ELqjIU2yFJAI9H7
         Yh+84BueRGYxibQqqDKU+1r8qREOfGevEzkOvg8a5flBfnNF962TXdLqOOAyr/n4JOLt
         b/d9Sh2e5/agssKswHpHE1yJBxmSH6E9QZtTJxqWXoYLM9BOxs19lSnstm/G/AdRn5wm
         Ourw==
X-Forwarded-Encrypted: i=1; AHgh+RrfO9PuQpxdU6Wd2/EZXilnRFBrWeebeDBPqVDV7yEtQ80YPxoz7T4KWEKr5/AtzfBbOC8azSfOlA==@kvack.org
X-Gm-Message-State: AOJu0YwGcHVHCVw23nTMKdpYUeX+RM6C68sHSaG36vFDgMP7FDuFDh2R
	Uo+PHbS0btF66Ia8pXCdtWrL3UD5mkESPQ+BQJVBon5v4GDStN7RYiror4LsEoIoJ3z7KTUrIx8
	FazJ1
X-Gm-Gg: AfdE7cnOdduOmxUK9XaJ4Zb//fXtYK22jqpvNp9g0FKYWS2yOJL6vDzVGsu82V9lxwr
	u9dpgcoX/6a4407GDJoyuGZvF7fBOyAPMawIOhRlLYsiQkmeHWtkt117YK3QoM0MbVj2qlBiCba
	DXyH78vSXC/Rd/4cVA/e75orODhJORGLZrRQ7W5BYoIUL1hhksCLK7F1XwPSMYqIJi8tIK9u1pr
	Gcg+b65RPELqbP2MtARpifJwLxVEUpkszqXOYLV1t8zS03ElmPvUx44bZEp9EmOLzjmK7hSaIpF
	+XyzCKw022TqcASD+rawq7IbZTKN2+sQMMSfz0zSetPkwQGFPwA0HbKRz8P3lgFN8l4voFa51V5
	4AeS1FVbxAgJrOsuZsQUi8cXdqiMue17pMPaq16a/OT2Z1z0ka+0tJKIHzeU7MTZSdGv21hDzZj
	FwJnxgrx5Zg4jqANlbnMBDZP7gOuM/3A==
X-Received: by 2002:a05:620a:4691:b0:92e:e125:55bb with SMTP id af79cd13be357-930b3e9c541mr429942685a.4.1784317359852;
        Fri, 17 Jul 2026 12:42:39 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52dd3easm225279585a.3.2026.07.17.12.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:42:39 -0700 (PDT)
Date: Fri, 17 Jul 2026 19:42:37 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <alqFcmDsFdjzNZQJ@plex>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-2-dmatlack@google.com>
 <178431652443.189683.17611165218179620081.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178431652443.189683.17611165218179620081.b4-review@b4>
X-Rspamd-Queue-Id: B502B4000C
X-Stat-Signature: cd473ekstfttuqw5z4xbspa7y6k7tj5b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784317360-713150
X-HE-Meta: U2FsdGVkX19z1AUEED/kWbFiqWkFcUr2D2GKsvdKNJf8/4+Y6PYlKC6maGo8xZtoZ8TSQsPouVNCG80rxPbWbO1irgYWo38gR5kPf+aBxWVnJ3VD/txUe8Z8CQ8k9hYn83VzrwjdP2Lb1JtJsHvFE0TN/Tljr6k2PpGC0dn1lpuQkchc0fh+8vKqubR9E4HwM1YDhopPmTy28kCJGcsen7O3qk2dX8po3j55NzwrFjXhh7WjScgQdvDCEvKZSEvrwzRrbM36YW6wCdAYKZXDxlS1usmAvCJQ3D5OMdj7xigIVjEJidCfQkpDHeV0RBIGjzlSfyGg9piQpSfJU1HDZD/DDqgm8Jip1Uy+jfVnNXsSix3c9ziFzrYqreh4JIqfl79ik5Yx+5zzVZ5uYVdNpxgTSazvd1XQsKthZb/Ujaik3A6XBphiYXM+kRHRseu6pblmmbF32mFZ4BmaAK1mSo2YsoLNBXCegrNukFbffZUvGiuqq0RHRYrRlmg2g329BLNUtHrh0jHb1FhnQ81sN6wU2Rp62vWbCsT0Y6P935+z1urN5rz9+382KmCMJoOKdYlt0ZtqqhyI5EEaQ5kXqrQgtSrsWug9S+yV1bG/jaAp4WWu7MEpKOFLXR8QBR/cba3P/Djz3Nd9Yi3rp9nr6GVkusC7StMyPyC2Quv0P16aaMmYph5uKajd0gLNeizBrkpmeU2YKMEi5veuMicbfYxQqUnE3ECK1JYDVQBW1iqNMFAUmRsV0d7rL3+d+RpbgJ9qzS+R3fPmdFWijSSlyWTv6JWmbx3x0Uup2Kxa4RVEDfbppVvuwuEzSN542iLsZQit+wm7DEM9LoPUtHLAneaKdKzWZuUyYLF7eZSTPJ8OaLO0sxBTar66fXLsNbY8Dfb6hRf6NzAzJge2vRY2BZfcGNEBybsltS0ytRpi0co+8s6tDaq6XGD6eMDYCc4K96sLkjS9fr4VRJrZRmM
 5rKhr7g3
 +h2MeaGIhUHPQFY5GDZbpwm66cVCN710ffv7Fhjp1X8EYN4PvorRWxFhQR9Ot33RreNC2Y0EokvT6A7o9/5SMUTiE1Pmtxkbv4WGclELSXxnjnI4/3o39Edb1p8cCdVYO5FaBw5rDMOX7RfA0BNECQLjJqL32DwS9mstYd6d81K0412+47fVS4e2dxjKwPfjh2BC0x3oBxlRdTAj6PvpwVua21jbImpQxGj8qULhaQU46vSEN8+rK3c2Sul1qQEB8oMPVURh1NdFoTq5ymvsgEpBNKJKwdz4dvn17maJQQ7j59t6Dv+f2RRrZ8jqATfKzZcthrLmXkFCA4Wxe+Mq5sRGAb6i6iTdKDG+GpWJEaLB875GAclzlR19dpKP/0yL2sv69NJZVPiS8VFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-17 19:28, Pasha Tatashin wrote:
> On Fri, 10 Jul 2026 21:26:04 +0000, David Matlack <dmatlack@google.com> wrote:
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > new file mode 100644
> > index 000000000000..899758883dd5
> > --- /dev/null
> > +++ b/drivers/pci/liveupdate.c
> > @@ -0,0 +1,155 @@
> > [ ... skip 50 lines ... ]
> > +#include <linux/slab.h>
> > +
> > +/**
> > + * struct pci_flb_outgoing - Outgoing PCI FLB object
> > + * @ser: Pointer to the preserved struct pci_ser.
> > + * @block_set: The KHO block set holding the outgoing devices.
> 
> AFAIK, these should be aligned after column:
> @ser:       Pointer to ...
> @block_set: The KHO block ...
> 
> > [ ... skip 26 lines ... ]
> > +	ser->devices = 0;
> > +
> > +	outgoing->ser = ser;
> > +	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
> > +
> > +	args->obj = outgoing;
> 
> Nit:
> You could re-write the above:
> 
> args->obj = no_free_ptr(outgoing);
> 
> And declare outgoing like this:
> struct pci_flb_outgoing *outgoing __free(kfree) = kzalloc_obj(*outgoing);
> 
> Also, remove kfree(outgoing) call.
> 
> >
> > diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> > new file mode 100644
> > index 000000000000..de549016807a
> > --- /dev/null
> > +++ b/include/linux/kho/abi/pci.h
> > @@ -0,0 +1,58 @@
> > [ ... skip 30 lines ... ]
> > + * @domain: The device's PCI domain number (segment).
> > + * @bdf: The device's PCI bus, device, and function number.
> > + * @refcount: Reference count used by the PCI core to keep track of whether it
> > + *            is done using a device's struct pci_dev_ser. The value of the
> > + *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> > + *            0 otherwise.
> 
> I believe descriptions must be aligned.
> 
> > + */
> > +struct pci_dev_ser {
> > +	u32 domain;
> > +	u16 bdf;
> > +	u16 refcount;
> > +} __packed;
> > +
> > +/**
> > + * struct pci_ser - PCI Subsystem Live Update State
> > + *
> > + * This struct tracks state about all devices that are being preserved across
> > + * a Live Update for the next kernel.
> > + *
> > + * @nr_devices: The number of devices that were preserved.
> > + * @devices: Physical address of the first KHO block containing pci_dev_ser.
> 
> I believe descriptions must be aligned.
> 
> Nit: Please order the included headers alphabetically.
> 
> Nit: Please order the included headers alphabetically.

The above was supposed to be right after #include, but b4 had a mind 
of its own.

> 
> -- 
> Pasha Tatashin <pasha.tatashin@soleen.com>

