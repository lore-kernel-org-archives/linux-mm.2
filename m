Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C8AC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01736B008C; Thu, 17 Sep 2026 19:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8CE6B0093; Thu, 17 Sep 2026 19:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7436B0095; Thu, 17 Sep 2026 19:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A125D6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:42:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EABC1C28D7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:42:24 +0000 (UTC)
X-FDA: 85224880608.14.00B0697
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 56D5720004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:42:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HhR8u8c5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HhR8u8c5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688542;
	b=A8TddxoWlFXyMP8gy1KzXVGhBtX3/te0Oy9ErtYz6LVAED1Zq4ucEA12Q3KB19flUrzF4W
	Lxuga2LF2rzqDkDoS89LtdVwkVwxhYmwiORsUbropH76lwCeVQjnUeLXOWRdaqGJsFa4IR
	wu2r9j530WSxXy6mOGCn3MvqepcDATc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrwLbYHW+qBSkERcNwvno713R7/9AiFADa/N4qgCkwM=;
	b=XwmVyDQP4YqNgsUd9QdDZH/DA2ypZDOS4mxS5ZPThvvCNfuXXwLYLY6TQM5R+IDqdzH3+7
	mb2YVtBLLF49Tr9j/9wB4Cu8MqnRK+Ir8plgm+4nuy8NG34a7y3NNuO0UCfAo/B3UgWdMK
	JvKucBH28KeXHtwIS+vxgyUrY1o9efc=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8692a8568e9so151470b3a.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789688541; x=1790293341; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FrwLbYHW+qBSkERcNwvno713R7/9AiFADa/N4qgCkwM=;
        b=HhR8u8c5QqOYKt8Wi4ij+GS9UqV8hqxlVG421wqI2nKbFJd1YnE35TgjAHjbBtbltN
         9lGx9hRxrYTMAutUWPF5iTPrKisDNu0+8PsfefzBRALx+y37OBi5IftvE8ra5Ch4bA+A
         lgWwp9FiZiVSeG4/AWC0f+4sxTTUJ9PoD5tC9MKrfh3ixzfKkhbuNp7frPli6V3CBCio
         uYPRzHAxV9XmFUcrRRIxzqsc7OXH09nsVcX2vMuJ/Q6fni+q0D1SWpw7AfwYQ0EfiNgo
         oK4xS5lokydXjMbxECnsX1uwnmmRlN2oadi713mwFVzVVPSgsqjj8pjcsaccrBuiLiIL
         6HWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789688541; x=1790293341;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FrwLbYHW+qBSkERcNwvno713R7/9AiFADa/N4qgCkwM=;
        b=tM84UMsLj8ISNsAjzVi6gekD5tIJeKY/DjDlhTRSgnTIenYC8Slw1ecH8qKTjYa1b8
         S1jjzQyNKz2vdRsRNQncDeNWCQ06A8Q286TH7hWv8KkQDXnJgtj0TqQAtHAjktQ4YSSU
         kcBBT9nl0fH2FiMCmZQONP7Cyb8Nmitqa2yYcxyWbleFaaCzWaRAALDnr0jbOFYtY7b6
         eCKH2ND4jyRVAceIPoJLaznICMMUMDTiAW7+7XU8JbTx5k1F8TDloXmzz9nx75yrGq2A
         MtuxF2trqX0NPak/75PEJ4PK715Uh5y4OomsHqOr21Wxoz5LWeEzodQ+7px/loUkDWfQ
         +iGw==
X-Forwarded-Encrypted: i=1; AKwUvBzIvLp0iLLIHumNLN61u7Mo4299H/DdPhOLgoxfcyULXO/EUN/yC8awYPBlaQBdHOMrMGiStTlNmw==@kvack.org
X-Gm-Message-State: AFuF++nYVN/prY4h1iVO3LOEqtJkfAcFiimm7lHkFfurLWs5uGUHvT70
	Zb1c5P0i9kWacU6byf5uck6SDj8TNbQ0cvK7shtTdF8w1xClmcdFj+jBphJXHYiKiw==
X-Gm-Gg: AYBFou2OO4EOafF/15bTSk79g/J6EaMvDpJCIHUJifXOHAQ9E8OshnkgDIBGk+o12kd
	VBmkXhgUrcxiHBYvCKr8qLPlGuZb5jVuctpw1zZj9SCXsQMrx2FZ63qE321ijmRhrou+YR+DraX
	0Lg8Fvuhrsed4aw3VZQs7/HCiRGZRIufBTDSzkzru0vmPrnFHVRg+vC3YOmy9wthCSBlUVUZftO
	jlcqAjjpt/GnSTIDeFfvLqTIflLQKbsNq6rOH0uMOnJBwSbIzedXKDDRKtiUxh+FLeutBhDQpuk
	YG9ndEbv5uyrp+vbhVny2UwwkjnYLNskVN5eLFDRtduHfpHkxB5SuYY7Ueq8jN26322cQKhzaj1
	1Qac00Ayo8186boWvwLJ3hdAWQQLBeaSHYeHxYz7/yg9auQjSkSIOGQEI/GMKYYmFeA5nhrLw2S
	D000Rl5FvuW2xPbsZMm0EhTXYCQMpRWAnvf2+BQ3WmdGHQe2r/4fk6PbnQrTZWx2uBuwFwvf7g/
	08Mhc8aoj8ZiTLxS2/U3iIn0ysDoYYTLCb4wuyS
X-Received: by 2002:a05:6a00:2d26:b0:857:72f8:dc98 with SMTP id d2e1a72fcca58-874dddfe1ffmr1080071b3a.25.1789688540476;
        Thu, 17 Sep 2026 16:42:20 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-872024e5acfsm3586862b3a.57.2026.09.17.16.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 16:42:19 -0700 (PDT)
Date: Thu, 17 Sep 2026 23:42:16 +0000
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
Message-ID: <aqx62Czdkh9unP86@google.com>
References: <aqQzmvgILmU8F4TR@google.com>
 <20260917001847.GA993118@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917001847.GA993118@bhelgaas>
X-Rspam-User: 
X-Rspamd-Queue-Id: 56D5720004
X-Stat-Signature: ppha3sbu8aycei6s7xmm9hk38kd1fwq7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789688542-180912
X-HE-Meta: U2FsdGVkX1925pK5mCqmZmD7G85m4MP5e1UDEPgJVbPnCi+TrgBeAkerNyEBNkXrMKZybhpGu3cxgEfhkIvvhtI6vIf6wE4cZA+TpYUSapoFNrFUQjcvSwuEfev83km5EIuqOX9sk0wWCvPRvQ7LMGxdx2kDe5Va9+94xASbPMQTVZpInXyYLIvJ9g9LnD54lun9qMqMaONzuYN6WhDLKkYKqo40YYMlnoKLbcp9x48AFezViKs12fzjJWNSF71C7qjrwAb45x6LDALun4MqVeH4WXogx1RQXoA+BhOzGAvNHvE3KOn4+hBYLEh77nuqXEOLQo66uUO7SNdVAG4u6RiHsoqdT778ZHS5p2K8VLxL/O3eb+YYQv1gfWzskRSHFFufcb3o1i4VHV9A/t+KJAZKBiB2HunmBuZ2Jpqd2R9+hndhW0Sm/8Hsa9MXP6WuUe1dJjD+/lanUZQhiGpmdP67U/CucJpXqoWJG/TNR0FHAiKyRumXT6uoMes2ar1K0t2PiC+uy9FjH9v6UgEOKRMdBr7lb1ULAAb5D9nH+BNHeCW7uNqsWwHV8h+85eTo0VPmgabZcqFnZbHZ7lQANRF3SL/N5Gna7kkGLyuw+DE+2Yr8Ov0uVkifCUW/XKlC9nXMIyk0Z/1eP2O3aW4gvR/+YtWHo7wXkm1jnBbbk4ITU3HVB2nz4pzRcUtjruG+xqdSMGuCNmk54XMPmPfkYmq88YpgniNW3X1skZ8lF5pOjRVb5LU4rHOrAs1wU+TWZtoL1yHfD6tb7vxsSVlycqVbAkCz7tHY7H1rIZfnScSt80mlmHusydyqj/Xyp7shwHraEW3AnwIbAfhm0icVOYhRjQSxRCHSCQ0kPtm7i/0m4HkYuHOs2bjypP7egyO+JzCRzqyYY6194YGhd9ois7E0bTe3/w6nKcmE56JwmUbqONc+cJl6lYz2jB0PT1s4Z5BQYLD7bI1RlrdijgX
 oX1Kjbh1
 5186NLEuc74mlOwRHtBzvTIso8CyLxW1k4i6jaoYbHk3+29s6Mi9CEKNOZ3aUfJKCnA3TnbHmWRj0bGCI/oHwBKE6534t7cLLI9JLLYo5eMCHz7/S+IyfgMrEEw3qAg18OIgj6gxAcKPnT6vKPk8b8Ijlqr1mR+iDarRDA7xMLQ10J+Frol6DB8cAiWrAedOA2nphgl9K+pt7P0dVQ+xuRIhmfgEdqWQx1LUufID74dMmNDi9Ps0HLwmKzBhEaRaTikkNq9WChmDLTYebHwLkd0ayXIpL6EhUwHxc/DGVNteiYYE8uLcCNONtVMc8IgdIwGI4ZGbt8J4UbF68a7OJUyGlIslnDrafSGMNqGqOXFhjjhkptUGla9c0LFBmkQ1bFYEL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 07:18 PM, Bjorn Helgaas wrote:
> On Fri, Sep 11, 2026 at 05:00:10PM +0000, David Matlack wrote:
> > On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> > > On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> > > > When a PCI device is preserved across a Live Update, all of its upstream
> > > > bridges up to the root port must also be preserved. This enables the PCI
> > > > core and any drivers bound to the bridges to manage bridges correctly
> > > > across a Live Update.
> > > > 
> > > > Notably, this will be used in subsequent commits to ensure that
> > > > preserved devices can continue performing memory transactions without a
> > > > disruption or change in routing.
> > > > 
> > > > To preserve bridges, the PCI core tracks the number of downstream
> > > > devices preserved under each bridge using a reference count in struct
> > > > pci_dev_ser. This allows a bridge to remain preserved until all its
> > > > downstream preserved devices are unpreserved or finish their
> > > > participation in the Live Update.
> > > 
> > > This seems to hint that we're going to allow bridge reconfiguration in
> > > some cases, e.g., for hot-adds.  The simplest case is "leave config of
> > > all bridges the same", and I thought that was what the previous patch
> > > commit log said.
> > > 
> > > What's the benefit added by this patch?
> > 
> > It is used in the following patches:
> > 
> >  PCI: liveupdate: Adopt ACS controls in incoming preserved devices
> >  PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
> >  PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
> > 
> > to preserve certain configuration on bridges that have downstream
> > endpoints that are being preserved. To support P2PDMA we will also have
> > to preserve bridge memory windows (future series).
> > 
> > If we are ok with applying those policies to all bridges on the system
> > whenever one or more endpoints anywhere on the system are being
> > preserved, then I agree we don't need this patch. But I thought it would
> > be cleaner to track things per-device.
> 
> Yes, I agree tracking it per-device is good.  I was looking for a
> traversal upstream to increment refcounts on bridges, and I guess that
> happens via for_each_pci_dev_in_path() in pci_liveupdate_preserve().
> 
> The actual refcount still confuses me a bit (see
> https://lore.kernel.org/all/20260917000723.GA992337@bhelgaas).  Maybe
> it would help if pci_liveupdate_preserve_device() alloc the dev_ser
> *first* (right after all the bail-out checks)?  I wonder if the
> refcount increment could then happen in exactly one place, separated
> from the one-time dev_ser housekeeping?  E.g., something like:
> 
>   if (!dev->liveupdate.outgoing) {
>     dev_ser = pci_flb_alloc_dev_ser(outgoing);
>     ...
>     dev->liveupdate.outgoing = dev_ser;
>   }
> 
>   dev->liveupdate.outgoing->refcount++;

Ack, will fix

