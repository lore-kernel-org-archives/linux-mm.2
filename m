Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1E3C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 19:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8330A6B0093; Mon, 27 Jul 2026 15:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4396B0095; Mon, 27 Jul 2026 15:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2F96B0096; Mon, 27 Jul 2026 15:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EADF6B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:27:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9936C0195
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:27:05 +0000 (UTC)
X-FDA: 85035539610.12.71D8CA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 168CD180006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:27:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IzYilg/M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785180424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=sKZJ5OViBbK3ZJT1F6pApbVMnloDUEEXkiEo8E43BZo=;
	b=uW/XNmNqQ16NshZt9g37dAd4vSqAEd9PRPm823w4YVrZRE80L/wdN72EONIydcJyscsStw
	jtAnB2vO9nLnWqPx8PGFPngjIH+9oDOpRBYRmVcdqC9exBwLQCbPCafcaNBe6F5K+6Q4/q
	jrUfR2DmTc1iSS9FSCKhZkumRElIucI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IzYilg/M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785180424;
	b=Y1Lf1ED2CqwCKN87Dg9vHcfNLS4NspEKwfEFHsguvdxom6dUJIRqqGLmFrZz7EIQz15pFT
	D3KwkjdKFSVCOQO4H4EBWodclLaEv3EM9DACEKg41y7Y1pu8uPuZcIvAZJ4dlNJDYq88HJ
	47wDTwnLXkPTyaCvyYH34czS3eS4sXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B69A40164;
	Mon, 27 Jul 2026 19:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36551F000E9;
	Mon, 27 Jul 2026 19:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785180423;
	bh=sKZJ5OViBbK3ZJT1F6pApbVMnloDUEEXkiEo8E43BZo=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=IzYilg/M8OJawVypIyI6yqeauwbZiYHFTE/2k3KHuRHUxMx0FStRiRDIYwLSXuz+j
	 05E1VSdnB8lEC6Dizt4VUGoyC5z/mveyiibWsgRdAlvKKIkj48/ah7F6UT2aCwtI+P
	 M7K/wl4ZU3s2ty47OdvEC9FdpqZZooqnD/YPe5dYLEcIqXgPRe9z+IRv0OGOjxpiCI
	 Jkkv2KqNrNrHHFyKWrUSu4jKNcR9MN7OKjAKqyH6336kbZXEsU0FdJisLbzQ98yFFp
	 BOxeFggnvJIK1ABfQTx2tpoMDd3ziP5gU/FGGW5Hjp9V/egQQBr6nc61xzYH0DhpGX
	 yRf6bic++oydw==
Date: Mon, 27 Jul 2026 14:27:01 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
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
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260727192701.GA1250952@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=cRhFW+zNX6xCnhjJXXDHgyhOxuoX26FG2Ve8+wMccypg@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 168CD180006
X-Rspam-User: 
X-Stat-Signature: quqknmtbcf579mziupef4zb9qs3khcox
X-HE-Tag: 1785180423-605330
X-HE-Meta: U2FsdGVkX18hfKNLfqS8lvLT+1U446aG0ldT54T5rgTQNMdrSdNGhes3LWCS0CLfxIEJfDqcWIoeKSKZxu1L47PWooLJlie+cTTJQkMSQu1MKJ34Z3gxSSiJ+eLNEWmCxkMz6Kw0EltSI1vbyupIpvou5PeS3C9lJbGkCvRR2lj0g9JAqxBzYBYX7Ha7MEG7pSQchOIAL5llQqzK7tsohPZoAXabjf1SAFb1nKa8VGM0LLQS9E95WOXBBlSzh35YRX1cdpXsp4AXGHRSOSGPFMpp6iCQPJPpbI7KrVA+OyzjrsJMHWyMiuocD2p5UVdTsy6lSeN4ThXzoBwtbRnVxtleuv5SLbbIvJkKlu8shlve22vYRt4N1CtEVPgtd1vdTIFvAGIA5XKbeXU9NIBYZwBMsNrpZumQFmLJe4ul5XlePXBXIizxDgQxOt7xDpoHLX8o+qU3Gq1wYEBOkBauxnAKPX7iUZ0woZjmgMwQsr663Hs1TR8dzv6tS/Rw99jTLYZhezNkWpqAuuJrhcEkbH+ocEConPZ6dh26ufnXMuUAGEhEgaWJ27Ze3RRZ+3giKEsjMgi0T60GkDWzWyTQqy31qwmw+IRfpykqCaDDFmInWfj6yEox8CLibl0aJmE835Nz7aXMcTuiuDc7C6Op/zIGeDMBSnO/h073qBNav/kpGsnxsppMndbDi6aXRQS0ZgZ0ZLqMVSEV/PsFCwO7xNgMfN6veWnyIx1EyKnlwtxCUypjCgXfHvj7HqpefgwFw8J+n97JJAxbIkG8GZ8lZYEXogOgIzBGROLhKS1Iiz+YJqdotd13j7mDBkXeMvyYrGPcdaWbVff+EggsWcvSOwJCM518ffqrUTLvjkzfa2/NrSTpbWm13ppFLxd89va9xwMldT39Tvy7jAemwWyDQ10jOLpQ1y2nmkSyHNq4MQQu2/iV67Zw6WcOPGNDpERouZGq2z5DfsrL/VO4j7C
 VZMxV/bG
 9jRVtyHl69skYdoGBz+pJ0ezenQda37FuGSmS7m7ja+pVrYfo+9MCY8Z/E8P1pGpqOFu/nHy9Q+JBtvv6FtIH8a6mGRnyomYYJ5/TGbThHehS7EmdD6UamtOkV5VsXCrZx8MYxMEZMm44xiutek/O0qqa+YkHcQPQF32htSgcO58lmcYfmyouZueuq0S3CmlWLFTs333ltIGQQpwGKOdLQxk16dHlQkhH9QMpvYELY7ARU2sLYIGRZOkuAJPHo1dVOLlkL1Gdt3iE8Bu3eoqbZ9jlJnZgShhvjRmymsvk6K48yXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 10:40:52AM -0700, David Matlack wrote:
> On Thu, Jul 23, 2026 at 3:21 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Fri, Jul 10, 2026 at 09:26:04PM +0000, David Matlack wrote:
> > > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > > it to participate in the preservation of PCI devices across Live Update.
> > > Essentially, this commit enables the PCI core to allocate a struct
> > > (struct pci_ser) and preserve it across a Live Update whenever at least
> > > one device is preserved.
> > > ...
> >
> > > +#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
> >
> > Is KBUILD_BASENAME buying us something important here?  Just from
> > code-reading perspective, it's more work because without some digging
> > I don't know what it will end up looking like in a dmesg log.
> >
> > > +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> > > +{
> > > +     struct pci_flb_outgoing *outgoing = args->obj;
> > > +
> > > +     WARN_ON(outgoing->ser->nr_devices);
> > > +     kho_block_set_destroy(&outgoing->block_set);
> > > +     kho_unpreserve_free(outgoing->ser);
> > > +     kfree(outgoing);
> > > +     pr_debug("Unpreserved struct pci_ser\n");
> >
> > If this pr_debug() is useful, maybe it should include an address and
> > there should be a corresponding pr_debug() on the preserve side so we
> > could find things in a crashdump?
> >
> > > +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> > > +{
> > > +     pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> >
> > Is fh->compatible enough to identify a driver?
> 
> Not necessarily. VFIO could theoretically have one file handler that
> handles all the vfio-pci variant drivers. But I suspect we'll end up
> with 1 fh per driver in practice.
> 
> Are you thinking about how we can ensure devices are bound to
> compatible drivers after Live Update?

No, I don't understand enough to worry about things like that.  I'm
just wondering if there's enough info in the message to be useful,
since fh->compatible is the only text that's variable.  Same reason I
asked about the "Unpreserved struct pci_ser" message above.  E.g., if
a user reports these messages, will we need more information to debug
it, or is the message itself enough?

