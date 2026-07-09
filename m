Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB15C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085116B0005; Thu,  9 Jul 2026 18:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035E36B0088; Thu,  9 Jul 2026 18:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FA16B008A; Thu,  9 Jul 2026 18:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5E016B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:08:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53B011A02DF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:08:53 +0000 (UTC)
X-FDA: 84970628946.30.EEADC43
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FABE10000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:08:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A2ibOb5z;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783634931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5hy/40qOWrDje+rO1HwX24k6GcjiBFx+d8whX1kHrQ=;
	b=ZwbEnYMzrPGcb75BG79XTrEmtZUEkjQQbaxpTrrhUsc+hOXyKTBDbgGFs27CpzawKxgEfr
	q5ni7t9O2arXA4O9ohXNYJS3o1e+CNYdpw1iifQSvf5OgEVD/dWDI21VHY28a273V2HpFk
	DcRLuRmxhrz535SN6KxcFcqR59OK53U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A2ibOb5z;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783634931;
	b=AEqKocmC2o940VqkRtS5/R/SrBHOL584DA2gjXVC/TjN4uPef5rq44liTCNl2LtyYnv0xu
	lAZHwYm5nKbxVSLASNgFUXrWXri4s1cphBH/NGu+XOf9c7jy5moo43hhG0aWSovQ30wNCJ
	Dx5gKmIr9b5SCzbvP3kO1TjcwUtFnfk=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so3560716d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634931; x=1784239731; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y5hy/40qOWrDje+rO1HwX24k6GcjiBFx+d8whX1kHrQ=;
        b=A2ibOb5zVouMsvLOJr+0YqwXQ62JoHb731O6K7liDmOY3xZTQXjzRzGz3zPGscryDi
         I7BW45TbKJiAHDD0DPC+jvbfyRwfwHJkkA4YdB4Xcz5IQx/8p+hotqtPKhmHe2Xr/qsu
         Dx6NAlwCP+z97AakAnvpLcFRG4swZ8Mwdyszp7lDzRwS+Rf8wlR/+XbybqQyNTSVVI5n
         hqi6vgmhjVWODUORWVCrFdTXOH6c05I/7SwwYnK9TpsYHI8O0cKeCSPDtY7eu4d8IEND
         KyEyqof6UjUDqRRYi1KHZ2lJBq2pXOh/EC990md/qoFvCCKnkytlSFc0IZS3Lk+Nq23k
         fY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634931; x=1784239731;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y5hy/40qOWrDje+rO1HwX24k6GcjiBFx+d8whX1kHrQ=;
        b=qA0LqsoUyzK9K0CYPwxJ3FN1fe8pJV2f0Yx1ajVCUD8qrsmh+GWYlDB923a0EP3/1n
         QCI7n2ZlfyDbCGXjgqQi/A5oQr7ME9dghvj4FMpwXgGJBfRLx7TVUE/RJHJ172h/6bG4
         fR+QiSAwC9Q5nXaV8rFKNqPcA9EFESIXdVeoHUvjaGjPfzNw8X2a4wco8SbT38PflpsQ
         Fz9o/QVMX+JKHiTe+jmIz58w5h2h+9U5zWHZylFaNotXyKmlX25FPDmJFtj6+5WK9OYL
         9rYvmhhdq90ZCoCnZwA2YpmTKBATCPmFj8BWwVRXdWZBhWlKxsARFgTJCuICwgSUnueA
         LBdA==
X-Gm-Message-State: AOJu0Ywbbbyy5XOlx2CLyMp5DpwKsHaVtqOwWPdh9nBs3bVcGIFWHXrJ
	FNQvQcEEt+o/0/NR1koauinh8+iIfSBaC8wPwNRp8a8ALvXPh3czycLX0A7LFJTWguE=
X-Gm-Gg: AfdE7cmt65Lr/kjYcS9fkqfdGpxQYqNjontkVbQnOraCtMo1TOIMtkATYw2IsM+bcOM
	rqbNf7hn2MFm1jCIUPLrAF30iLmTAgWzWdz4SVA1MK1czHIIn0o2qND+cmSyx608x6TulV0klec
	RrnURaDBNyxDVmcYaonA4sD4YdwMNctLeB2Swr4mDeYYMtgfGCO7R4qiod7cJ035vGG75lngAdk
	/0ABCSfGK07uoXbaYAzEN4VCnrO4RKc8Y8mizmXC2j61Se2YP8TTvAwLadjyGEMbBibidmEuNDx
	EMpozbO4ANOxN8oJQnl3MGxDtbttOkMuWzEkMvIW0R4KZDb/F6NlYZ9/l0yJK+vYgie4Z7K56nX
	pw+RH7bbqNqOw7M6kGpOSTks8iTgrJ7qqtg1ucGrV30XqoZP8TDygCyEuWOvHCI3G8QuM5cRVhO
	PP76wljVnAGvkci+jRoikjbB5KFhjSuH2472Ov0HpFY0AjLhoLgpgUIuEgQ8TKPwEbc4zI
X-Received: by 2002:a05:6214:1306:b0:8ef:1840:2bd8 with SMTP id 6a1803df08f44-9024204ca5cmr14984856d6.33.1783634930620;
        Thu, 09 Jul 2026 15:08:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87cacb8sm26797256d6.49.2026.07.09.15.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 15:08:49 -0700 (PDT)
Date: Thu, 9 Jul 2026 18:08:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FABE10000A
X-Stat-Signature: 7nkcmmhjcb534iwakqii4zsa98ka5sff
X-HE-Tag: 1783634931-896811
X-HE-Meta: U2FsdGVkX1+296n5CAERhLS4SNScL0olbTb64IEYd9Hz9jmUyPDf4vMh2Jv/cbBJYGPWwh5FOVCBUVWQM0iT+qUx3VJ+ZxRtALvoVQ/dKM/a8a1f0ETDzsSPq6ZCmEb4Hai0XdBfcFcJGkMjYFI77YcP7Qc3MLeY83x9AmdxlR1jt7GwjF4TKBS54D0qOJkY4Oz/bkms2941Q43fNr9Wkr48XoIagwbAEBFfhmBvMCN+LT7XLs3MbKiN4ZCj5nArzU9EDVbrEGlNV9QPmMagYhgcIRiVOjDKzkF9qJdAtDTGW8AcxHPvgELk4c4PA5cdTk9IKNlWaaUWqqgHG9Wz192HYMPrrzdiKT8eKzfNlX2wckxV1xtPTTrXz1mNTNzFF9kO5b/SAR2RmxNpn4Z7F4EalGKOQ51ZRifxBC/RMCvaZA/6GbQMiw8A+MZoi3Y4VSpgwzfgralF9jqtxKMPK8hU476c/Gkb6oyIy7bDTZFuM3gQtoURTUzmT2aNGBKZxjjGcslOPIOh7kbixuRm1w3iLaZKRyK4HiyWcW8Bd7eVNI8WzqHXNgusCVsFuzCztCYteRTmo7mtOFbRlpLwkxzfVBnVTZwQc3juZts0rJTYLxS3o4C/2ZzgHmhKTaYfvviTLOddJFMiuwgEA4JPmzkg+BlTawY5gY1vMdfXgl+IYzMyyGCrhOdwKOceoUAJ7HvxZKUfZv/effoVXWs8XoQNwRYMV2wP4RDvUoTOepQrkHNvQw/2DsvX4lQ4HV/VrZfHvf3fk8s5jcEzDXyBSNUJGcOFncnZ+xMUeVCxmKzs6eCLVLroa0dF3NOdFqClpv80gVRcv1JaJLjcFnnI8QQ64sgQsAzoRVwrCq+9zqzhRh370iOM5Szy/bX/bPCTyzL3RzyLbHrd18nXaZnuIJqOFbrWKFqrA2e9H1ppwHOJX36G5qxoYl6GfWpQc66/KuZ89PouxZT5yJu6yLb
 C4z0O0+4
 WIQzo4wSDWW3ijmsS06BxQwOXcR5PaHiPAaF9f5vdfL7WMNi+kSuvU8txdjKf9tv3NVy/R+awRgtVdSVPVc5m65EvQ2r1JVyA5gEe6WbiSMf4IlYq9OmlK98a194PCz9AaKl0X6UIGL4n8HeTKecKLeomRaEbI+U+nOohoAqeIE0v8XcwJn5zZNnIdYQR+VOxSbtvrxgXd4tNAy1NkeDNTL32W+tziFK2PvQ4E4DFGvuRm+vtDyMQLCPrNtNRfC1if7y/vrRrzkd958dlSWOdz0y9j8hK4JvmgHB+4yD4RM0ZiZ6cq/eF6Ytr8ZCJtCClLyQYqFFDk/RxFMDjAhYBg5DrUKeXicpwl60Yi3DV8ZrpbDNSqsPXs8D+Jnbyu3jMsCECH4PdV7ovyNKcLOTE9t/qyqLuMHl4WXXVmLNGWBIraA6vIfPup9f9gu4T4hQnuEhD84VoNMSxlqdBzV0i/pBrdK4t5MDt8+bz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > There is no way for drivers leveraging dax_kmem to plumb through a
> > preferred auto-online policy - the system default policy is forced.
> > 
> > Add 'enum mmop' field to DAX device creation path to allow drivers
> > to specify an auto-online policy when using the kmem driver.
> > 
> > Capturing the system default would otherwise break the ABI, because
> > the system default can change - but we would be statically assigning
> > the value at device creation time.
> > 
> > To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> > the current behavior, while providing a clean way to override it.
> > 
> > No behavioural change for existing callers (still the system default).
> 
> So I know you have some future usage for this ability, but it is not
> present in this set. The only piece that *is* used is that the
> online-type from the new sysfs interface gets plumbed through to
> __add_memory_driver_managed().
> 

Correct.

I didn't want to cross three subsystems in one go, I do intend to follow
this up with at least a CXL build option to override the global hotplug
policy by plumbing it through to the existing cxl auto-probe process.

Some of the accelerator stuff is still a bit up in the air but the base
driver can still benefit from this as well.

> Are these touches:
> 
> >  drivers/dax/cxl.c         |  1 +
> >  drivers/dax/hmem/hmem.c   |  1 +
> >  drivers/dax/pmem.c        |  1 +
> 
> ...premature until the first user arrives that with the background story
> about how it knows to set the policy?
>

This was more a matter of having the DEFAULT set consistently across
the dax driver variant probe() functions to make the behavior explicit.
I didn't want an un-set value bug to creep in here somehow.

Happy to drop them if you think that's unneeded.

> If DAX_ONLINE_DEFAULT is a sentinel for "default" should
> DAX_KMEM_UNPLUGGED be a different sentinel than (-1)?
> 

They don't actually run into each other.  DAX_ONLINE_DEFAULT is
overwritten at probe time with the system default policy, so
`dax/state` can never perceive it (even if the values are the same).

But this is visually confusing i suppose, so I'll just swap it for -2.

> Feel free to add:
> 
> Reviewed-by: Dan Williams <djbw@kernel.org>
> 
> ...to this and the previous patches when that is fixed up.

Thank you!

