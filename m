Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A2CCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB866B008A; Tue,  9 Jun 2026 14:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93226B008C; Tue,  9 Jun 2026 14:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8A46B0092; Tue,  9 Jun 2026 14:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA1076B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:19:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68A001C2236
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:19:12 +0000 (UTC)
X-FDA: 84861186144.20.2A79E5E
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AC4740008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:19:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=g4WjnkZZ;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781029150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KqE8R583ndPf0WEv0mevB0HU+y2IabL7k8Ouzc21Xc=;
	b=jj42b6nVeowdiflh2QvOvHVVly90Nq1I4oEn9jiI5/3kIY5lVNvpR70yLs1nFQox6A38Up
	P07KRzAuXXOWE+XomvIyMpOx2jT6Z21VO3rtGgGHq/tr2H1wEVVZZLxtfZGTUDU302ptKP
	O4OBWWj0t2l0mj/49IuordBh9lWZlLw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=g4WjnkZZ;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781029150;
	b=1drVELt3hONbfwdZBwnpyq0hSxHPuLFXqjUiPc161F2h4wg8RbIPwKCIcuk30VS1XIQmNk
	3slUhQVUjYjImYYQCAPHq6AMzu+hk2xbWuOMOAf5ddU5s8GZh00cJBMy7bunoGbljIAAKe
	CthTus9tALvv4cJqn1LEr4fKxeOS3Fo=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9159951f05aso683297085a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 11:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781029150; x=1781633950; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4KqE8R583ndPf0WEv0mevB0HU+y2IabL7k8Ouzc21Xc=;
        b=g4WjnkZZOLnjIT9Zg9mHlbRTOEEbhL3vT/XQrDo81fWV2Q4myScCozPtMk/m7zXXLh
         TtJNYZAlVXpWm0Nnf5BhESZ4zzN7RJRCQfI6SEwq4qff+TjJoBzo1I/pdDoXUX6piGzU
         18wZWCJxtphKy7Xg5eoDzS53DiYbhebKNP2WFme4yWxWb8PL4ApZCHevbLTuGdQNhofs
         6GtfMZa9zrc+ngr7vwCaTB3fk6EGScg3Jn9ahJFyP7kgGZ9FeOpp69e4yyooUH28Afqz
         9H5AYug6Tm7F5kx5PbqZ42I6qQwKHxFsENgS3yIKFjvuhaxletdugO1QWjwrINVvW641
         G57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781029150; x=1781633950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KqE8R583ndPf0WEv0mevB0HU+y2IabL7k8Ouzc21Xc=;
        b=iemQY/4UrcCFyfFDZqi4aAfbmP1mW2Z58oBrAgvUpCQGgJfIbVZray+439FIPW/JN6
         rDlPZl4vokAfXed5GpuJ0LZVrdRvQg0PNUbw2UeA+eppyCSnB1GTn6qP386zfTgsltOu
         0Kln1zWQec1GRRB5BKYqhNUj0YKYNQt1T3S2JT98F5zEA+k5CHd7XQ5kj88rFq3cONnz
         ns+sYOFxegNus+klaACW1kR7cfdK41lC2+5hPBYeD1p+cJ/KX45iwDr/ouGNtkZnWPO4
         nBj1DlbufSpNLuGkGHMA3CbdhFFFaC/FBI3p5gfPSX1V4UrPLqlA6RM1FEdB6Y3MqzJn
         /2Zg==
X-Gm-Message-State: AOJu0YyvOoJuol2ak0MSB3RNUd6aJV2xjE1rdkJGDyvSH9UMj5KbenOG
	x+rhwrL6z8Gb1qocPchM1hYJCc4KAlsJukulv0fEMjTGLSP+FD/oijJ3ehSSiaezAhPz8NwXzNh
	UJbH4
X-Gm-Gg: Acq92OEhJwrrIIK7ATpxqjWOjWR04apiIaci0EVVIzLap93cWMta/IVmWP3a7NjdSi2
	frHEqsj81eMQ8iau+KNk8LEaZH009UDXR9EOs/Upm2txZOdxR6VOhJ5WmOvWg+z9vRl0n8urM8h
	RSsbIr95qpYeAQ5HjYS6NW16vCVdWf3qjmT1AQqyhxNbKHw4t9WseqWhORE6j89zGdknEJ1UgfH
	euoSTFQ0XnzIgxEx//P/U4eqJ3qvhhQASqHAGQM8Lf2PoVyqoxSkuH8PU2BPXTaUcsMhQ6GdhIf
	uFyS8ukIqAtvnENMcoQniOpypiVgkcjzil30IbJ+JVR8uIJ8Dx6DEshD776e+gX3XMcYtALocHq
	WlshsQDvqdxuuor6cJIkuRDAol7ch9Rg8sCMqX6TJREIo07DV/Mgn2pGHe+WVij4HYOsp17M6Pk
	3kpSN3qe9ELejrB0x4YkOGSsMW/3gEsFaicnOamtKm62o2lFAtsR3/yHHFjAPZ4Z7KuM5MabaZl
	82Q/2qgiAP9Dfs+xg==
X-Received: by 2002:a05:620a:17a6:b0:915:6758:222c with SMTP id af79cd13be357-915a9db8ab5mr3329361185a.46.1781029149586;
        Tue, 09 Jun 2026 11:19:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a402ff9sm2211734985a.45.2026.06.09.11.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 11:19:09 -0700 (PDT)
Date: Tue, 9 Jun 2026 14:19:07 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
 <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
X-Rspamd-Queue-Id: 9AC4740008
X-Stat-Signature: fxks9u74j7smuf1rxcgky9sgr48cqypn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781029150-427467
X-HE-Meta: U2FsdGVkX1/tS/pEBipKcwRlQbOr2/JT+a37fxy5VMmiR4vmn/kOEeaRA3Mx8I5IEAl+JAtLu5EbPnpHGMk2AlSmxoUqcMOOurn06MTcSxLBDDGgPCywjjdpiruBAORN/GuFg+PRHTqSct6sG+9C9NpSGJThk/0Go25Y1200jhav2/UGDIReRlGQIF5h3o9lUBjurcKcQi2VYNRS1jP0TBo3XJ3P8aivKVFj4dLxlxTUHz65ACSZ54/8AUNbuOKHBcfu+KXjiWsuZxw5HL0huYop2uFvm7i7quYZkzaVgDvKjStaVXlaOIrlqgTnjmBuGqQC+OifawsCsJx9zmMuQvk5vxlIrK+c5Q6IsTHyM6Kh/VFFY+wZQg4BqUUemRiVIYkaft0yCkxGxK3gHBMVE2yx4sgta4jDyfzIao42Wrzvkg4FmL0tgRNOxDQ02ZiDS3qMC1uprU6IM4GFxWzKlInRDafLcnPg/Y4Z33GAhiYMiF40M6Pn+tmyuMMLiAXBzMqdimJVhh07E78cW3HVM1ffA6X/FWOd3TA3Kqr2mhc4IrJSVlZd387ifFdIUcz2woCojUp4+/LAMsPmF2FJOyPxatFQ9a/Ax3C6HCJ2tE15hIAqGGG7haQJORluf52TQGUwO61p4UdnUKzB6CADazvwKHt1msL0/+bTg7bfC540raR7EC1O/bwEgXeO1D3m18XZ7tjR3Psv6hfq/TZKwTOBIipIXqtVkuzZRraOxfm00z4Db+ViirUU7WPNt8zFu9WmG6CNnNE+JLhsiu5iVHZQorSgQGDHbhPNU8uajfSsFAkhDHSYEfo+lJnMaq29+72benC/EBtRfZrKTMexv2aQFyeCkWF/Fa7/dTwX7WUAz4OasWzjzNH2TjbmaNf23uUSWAiYh1Xd/B9AS3m7XZ+yDKFz4+2o7RWx9dKKuqwRJTNUK4oQuHO7eGvdVtUtNQ+AkeFUil2nO865T7D
 y63zBGRK
 C7Fjto2KCv4jLUMcvhYU9A3zcoWWqYc2dIIYojSCK2PPd+ieCSPTlsclq506q19FotQFb5Ur7Qmp2TPKoVfT7ZAxzr1F/aghVD2n3rUCEO9OFcaITzrvOw+sHguE40ZltWYsjtX+zdj4UfTgbmfqJ4svbOxwU8YnJ41CmAua4CC7Fytyur2C0TJhBAXuwjpFqsx19jUOxllGMzqWNSUkpMUncdxlyouXmQ59fYfiBgopAzrVEYxxaycAE23h5I7QIbGqK60DbzWVRqHAMcG6gvk3pouUY5bc1Mr0jW7x/WelPz2E9enygIrFi2wDiqcKF9bps/GwXBWj+4Ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:11:42PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 17:35, Gregory Price wrote:
> > On Tue, Jun 09, 2026 at 12:26:07PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/5/26 23:19, Gregory Price wrote:
> >>
> >>>  
> >>> +static int dax_kmem_parse_state(const char *buf)
> >>> +{
> >>> +	if (sysfs_streq(buf, "unplugged"))
> >>> +		return DAX_KMEM_UNPLUGGED;
> >>> +	if (sysfs_streq(buf, "online"))
> >>> +		return MMOP_ONLINE;
> >>> +	if (sysfs_streq(buf, "online_kernel"))
> >>> +		return MMOP_ONLINE_KERNEL;
> >>> +	if (sysfs_streq(buf, "online_movable"))
> >>> +		return MMOP_ONLINE_MOVABLE;
> >>> +	return -EINVAL;
> >>
> >> Should we try making use of mhp_online_type_from_str()/online_type_to_str()
> >> [possibly a nicer exported function for the latter] to avoid duplicating this ...
> >>
> > 
> > In patch 6 response i point out adding MMOP_UNPLUGGED
> > 
> > If we add MMOP_UNPLUGGED as a state that is only use by callers of
> > memory hotplug to represent the current state - but not as a valid input
> > to memory_hotplug.c - then we can simply this as you request.
> > 
> > Although we'll need to add a couple lines to memoryN/state parsing code
> > to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
> > permanently unplug memory without the ability to get it back... unless
> > you want that?  Seems useless to me.)
> 
> I would just special-case your KMEM-special value, and then branch off to the
> core helpers?
> 
> static int dax_kmem_parse_state(const char *buf)
> {
> 	if (sysfs_streq(buf, "unplugged"))
> 		return DAX_KMEM_UNPLUGGED;
> 	return mhp_online_type_from_str(...);
> }
> 
> So there is no need to add a value to MM core?
> 

Was going to propose this, but then I thought... well if CXL detactes
itself from dax and does this same pattern, maybe MMOP_UNPLUGGED makes
sense.

But i'll leave that for another day and do as you suggest.

Thanks!

~Gregory

