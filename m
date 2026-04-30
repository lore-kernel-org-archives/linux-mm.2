Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DEFCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6582C6B00C7; Thu, 30 Apr 2026 17:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608F56B00C8; Thu, 30 Apr 2026 17:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51ECC6B00C9; Thu, 30 Apr 2026 17:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 430046B00C7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:06:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E31CE1C0135
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:06:46 +0000 (UTC)
X-FDA: 84716456412.11.5BB7D96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E3664000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:06:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puQeAZOb;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777583205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=C0vBoElXD1efBFNz8dKsovWrAybtaAyIXbJ5scKd1Rk=;
	b=ubBMXndb8fSAsbgzr6aJJw2c1Gf0ZpCvz3S9qhN4knh5TOn4wWVSRb74gCTyyaC/fLJEYR
	XIYxpZ4ECFGg9pNj8BLIRWsE0C+F3B2QGLBn3x2kk+0GC5qK2f0kekYTVY2vd4+XBzYCqK
	fvIM1JsNf/pwDqNrmo6Obt5OIEe0iWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777583205; a=rsa-sha256;
	cv=none;
	b=xlgZo8N7D2q7+ubtDr/ehwJudNKRFc6q5RL2X5kxPHtsRJ/2Q5POeIOh5Lema0uknEvBwU
	cwwyI3P0Ze4Z82oN85XUZndpJZbumWKTWwWNH/rLH8YcJwaGmNh/aOsrjKbuEZlJk1ClG1
	4oeeVHRo/dOVvyiuE3Rr9mcYdVyKpYc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puQeAZOb;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 657D860142;
	Thu, 30 Apr 2026 21:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40FAC2BCB3;
	Thu, 30 Apr 2026 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583204;
	bh=fSFeh7LyM/VW+wkyTESwF1r98DYurH8l0qUBEQElk78=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=puQeAZObx6LcsJjZvu1WHP+8Qjize0ip9P2cmvV8hYk+1hbARQsBepTiOkBvWthHE
	 APtvhoP5m8I/E1y18V1kD/BTX+C9Pm/HjCuQycbFK5Jfpa+ZiRcj/X5jsQaWJ9yA+Z
	 gZ/MVR+TMtwrBvUy/REkOHTbIlNzOpb6jzNWtJHsZ4tT6+SSq2ep9KlR1Fsb5yi0rh
	 3mZuRSvjEI/bYoelZD7EGAAq6Dn80fISgjTt8OAIkRxPbeKMYn2JqYdjFWaqkD5+fj
	 svxk+yuFxLyw188ejvfehH9ozLGi75STutLaHibMhH6Z6IOF0uCXaxI2yaRttJVO7G
	 jOJaHcSyl23Sw==
Date: Thu, 30 Apr 2026 16:06:42 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
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
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260430210642.GA439800@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afFHC6C1Qbwio4pH@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E3664000D
X-Rspam-User: 
X-Stat-Signature: ar7iddkpeppfqtogknyf9d5ch3917fa1
X-HE-Tag: 1777583205-878072
X-HE-Meta: U2FsdGVkX1+JtiPA9lDjY5UHX8yWE+cBeVExRH+KjVaw8WgnxjVI5pjEPPqpQ+VDeFli+mex9DBkdY5TvCBeQd7jFN668vEQA6zXXUBVatpBrw6AjqrkvwdHf1k9+Mj7tU1S5q5YIE0h4quUg91jjXhIlFtS1siULbRLeMxBpKt73KhjntIyvc60lcbqDaNwYjVVJkqPuPS7moOblZ9wBbHzHMGJTi+hGnRTQf6mhcxGK9Jv7mgrGTLy14LSK60cnLoZzd/xtiorpOgDlLUgK9dzGhSPMc7l94386bkXSA8Lw7vqrNRucdKHbuY+Hvtj/SiBTs6JaH1fI8QcC5WlvIgSg9KCBcUtaiAHz2sDJ3WKsbc3e+j4uwByrRvjJ+Srgz1CLboA1qBd0ienNetPsH091pJl6nbeiS+u+5atqKfrYDQ/vsWM595usw2Fn95hUPwFAnnkWgPXRO4J8cRrn46NmS8wUJ31uvTWyKe1hbkpRLLzlEQgzieLEvU1GtiggBrhk4SJEJ9eRMx33nPRDo43TdNyAfJapnVvpwBCjYiflUJvDek6tOUyqWebHlkxiYg/3M9t8FkHRqihesUhnB8TDz8xSzpLWVsZElOdD8gsrQ3gakGyoMajAsl52fuNR20VOd7Gc/VE1wH8oeQFUhpYA5FEmYF7yV0ce9Ksja0uaV5FJCQq2STCHnIImm54IMkZV0AafFzzcpVrbhykF3k0fGec79CoRD0ZoD/WLSPEGT0MxqVMs9MlEvuoXonYeydyD9mF1sEogIqlSxBlJF2l4vIsmTZ95VVM94WbVRB2gQYje/1hRCTF4Gy3ZJDLksiAZ9NRv9vnG/Vtl7KikdYdW2Y0rYq6J8GnK9qYFAlyaLx8AfeWb0D10mVkcJYyKvfxXPP7S4HcQKI3eJYMKaLMrnXMMtuLbUQhzrIjGAL4AAkoSTFTOsnUTG34Lf+mWiPYrxd/klYJrI5ksgu
 /CPx/Cc0
 QDwo1+cL9KqID2aKI9jpPpBM3tVxM8fSak2mldpqDkVLj1YS5HNLZHjIrYG0KQsyJE8bF8dT/EDyhvMfeh7dO+7d1cR6d7JQz4FJCGhWvfzFqbajWT6LdKQiXDoiAR8ohqD4mzo4CXv7q3TvVKa3Llqy/4YU6f7GPlMRPjiOfY/Ju/VGgD3v7PJ0rOO+E6urOowVOdpAr9LPXZ6npQFROCxPkjm9FC6SMr8ONYdjwGGjtPPLVSzJgwrwsjz6u0lweD1V2XE+9uLtsIM9OPG7VAnxgYum2GGmZIdBMy7Vh3hHFVGqnPSON8IeTu441n8TQ1XDdxOAB2HSyI+XHOt+DzF7GVF/VShs5roMHm2DoRQxv0L0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:47:23PM +0000, David Matlack wrote:
> On 2026-04-28 05:50 PM, Pasha Tatashin wrote:
> > On 04-27 23:59, David Matlack wrote:
> > > On 2026-04-24 01:29 PM, Pasha Tatashin wrote:
> > > > On 04-24 14:33, Pratyush Yadav wrote:
> > > > > On Thu, Apr 23 2026, David Matlack wrote:
> > > > > [...]
> > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > > index c9b7b6f9828e..94af31837375 100644
> > > > > > --- a/MAINTAINERS
> > > > > > +++ b/MAINTAINERS
> > > > > > @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
> > > > > >  S:	Supported
> > > > > >  F:	Documentation/PCI/pci-error-recovery.rst
> > > > > >  
> > > > > > +PCI LIVE UPDATE
> > > > > > +M:	Bjorn Helgaas <bhelgaas@google.com>
> > > > > > +M:	David Matlack <dmatlack@google.com>
> > > > > > +L:	linux-pci@vger.kernel.org
> > > > > > +S:	Supported
> > > > > > +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> > > > > > +B:	https://bugzilla.kernel.org
> > > > > > +C:	irc://irc.oftc.net/linux-pci
> > > > > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> > > > > > +F:	drivers/pci/liveupdate.c
> > > > > > +F:	include/linux/kho/abi/pci.h
> > > > > > +
> > > > > 
> > > > > Can we please also add these files under the "LIVE UPDATE" entry. The
> > > > > code here concerns both live update and PCI.
> > > 
> > > Covering that intersection of Live Update and PCI was exactly my
> > > intention with introducing this new PCI LIVE UPDATE entry. This ensures
> > > we have maintenance coverage with knowledge of that intersection.
> > > 
> > > > > We can figure out the
> > > > > maintenance details as we go along, but I think the live update
> > > > > maintainers should at least get all the patches for PCI live update.
> ...

> > This is the way we agreed to handle kexec changes: Baoquan He is the 
> > maintainer, and without his Reviewed-by tag, we won't take changes to 
> > kexec. This is the approach we follow with MM for KHO changes to 
> > memblock and memfd preservation, as well as the upcoming 
> > hugetlb/guestmemfd preservation. 
> > 
> > This is also the approach we should continue using when adding LUO 
> > support to other components like PCI, VFIO, IOMMU, and KVM. It keeps 
> > life easier for the core component maintainers and ensures we do not 
> > regress LU by staging everything in the same tree and sending LU merge 
> > requests from a single tree.
> 
> Ok it sounds like we are aligned on keeping drivers/pci/liveupdate.c,
> include/linux/kho/abi/pci.h, and Documentation/PCI/liveupdate.rst in the
> PCI LIVE UPDATE entry and not duplicating them in the LIVE UPDATE entry.
> 
> I think the only open question is what tree to use for the PCI LIVE
> UPDATE entry, PCI tree or Live Update tree. You are proposing the Live
> Update tree.
> 
> Bjorn are you ok with that approach?

Yes, I think that makes sense, at least to start.  In early days, it
would probably be a headache to coordinate LU things across multiple
trees.

