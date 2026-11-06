Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C57C606D812
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oY+DYiQh
Received: by kanga.kvack.org (Postfix)
	id 4518B6B05B7; Fri,  6 Nov 2026 13:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428FA6B05B8; Fri,  6 Nov 2026 13:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3679E6B05B9; Fri,  6 Nov 2026 13:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE916B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:40:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C527120114
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:40:36 +0000 (UTC)
X-FDA: 85405560072.08.4371C88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EEFED1A0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:40:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oY+DYiQh;
	spf=pass (imf19.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=d9rgt/0ZjW9cJWRqIx3PEfjuDN/5drVoS4iqtSrIJtI=;
	b=IZVbcntqh06usxiI/AOMfFGhBOCy4Gy/b43qu357cYzJNton8Xgs58BykdJR61sVSIz6qI
	kZUKGJXQ4/t1a40H5tN6tif7xPuAvmxFmEkbk5v10mFf3fO0yly+5oGFKJvhtSabiV4hLk
	hSX02vi9mru/dtgdQBf48EnMPolA3AY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990435;
	b=ML1oMHjbwHeDdQNr23mS6DsmdEsjDRinFaesMN0vJ7yeLR8F4K+op4MNLpAqemfIGA7Q7j
	jkKsOne1ZhaR1fdSJ8ezgPo9aM9v8uQ2i/EgeYOkkvkXASRKYR4cPItgxNPqZI0J4n2zok
	RjZGxsYzZRJ6hPpk1M2pYo0gsaitPi4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oY+DYiQh;
	spf=pass (imf19.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 277F9601F8;
	Fri,  6 Nov 2026 18:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B31F0089F;
	Fri,  6 Nov 2026 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990433;
	bh=d9rgt/0ZjW9cJWRqIx3PEfjuDN/5drVoS4iqtSrIJtI=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=oY+DYiQhz2qhURLJX4BDC/kmudYeEjDpY0mTplMC7by/77+JSrwJ3cPy0pAcpZY97
	 fZehsr6eSagi1hfvJzy6tX6lqz29+bGYK3xSKa0OTnst9MaQ5j8E/D30O63P4HUDk2
	 1xT7ZDqhrzrXp+rAMioUXloF0PcDNOLqEyE1lY6PX0Jf63xyCqAwU8+rJ1zfx8gvnK
	 Ab3RFED9RMqASj9LT1swYH4CwBPe0jo1CtmL2IXstISB9dUcaO1BVKpTO/pd9kGcwQ
	 ttaapWVgo9M3UfMpozYSTbixGW+reEsNu8DqEFOQLmf10nJD4nZksup2s2GpGl5JYp
	 hlebewHwXEDBg==
Date: Fri, 6 Nov 2026 12:40:32 -0600
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
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 05/13] PCI: liveupdate: Auto-preserve upstream
 bridges across Live Update
Message-ID: <20261106184032.GA1640926@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMOC3XV68W0K.3FGK4UZ87838R@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: mofwhc7rc8ujwn8ifwh36ge6owhiossu
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EEFED1A0006
X-Rspam-User: 
X-HE-Tag: 1793990434-366777
X-HE-Meta: U2FsdGVkX19uXeY83XAF0gmod4e/QjgMWCNgOuCBryuNM38NzSUep3H3Xs3Dx5VGjF3xDItscb543nVWhFOntc0inJKaL/AYQY09a0GLAzj0X1EsRYw7ql7vgn7kxVg6e3Tp8PEAfGZkP4rHd1GQa0MucVlz8SuViktj4f7qzG684t07fDmNje5Iafg2KDbWaA3gXh5ZcFwsmqXs2d59Xe5zr9jKfnDukhLDWR0X88XV08FnXK3X6S5ADIku0q4sQlGdtg0FAENAlqR2xkLeoukLoOYiOWFr2kcWo3YIk8Gm/ppO5bdRNxjgC4fzNrtYbk6OQjA3dKrx0iger3gApYGbffCLKPcVhiV+sAkwRHG4K//hwmfLBDm7P5Qh0w+IVFmDAa+WMU7m3iYTqYIYZ+pOII+vxK+4iRVajhzzMhwNIklss1SFaI9o8Q8bOakZ3kIJCFRzrGwp/VaQvgpIVJj2RdV9fd5XnBFN4o/tQlrwjJ+JFrmHMAVOobAGVPV5CIY5fn9QX2x5bZ2y8z0Q2QAJWNplrcCkHr6EPEGbNqvc6ISl1PVCDDpFWYwqQtHWMQd6TniVkR+Sn1m5KPmV8SxMz8rGRd49PDHOjJGIJEFn6zDdxQ3tgy+QY4psKAeNWHs2elq83M9NPj7tKuc0Ec7HGlLsTvnTuZrVeSqGyjUOe5OHHzzO8xbohnNtc1Dj4SN1JVtMXg0/whCXFJGhtEJSvS3cir2AZfg+cja9F2lyghCNPKd8KDuRt4PWELmEcQ/MADMT/iaf/9AKONSZRzXc4vAReahLanJAu9hH6rUXw90Mw0mDJ3iD7Z4zx8pu5ywiAuGQ4OV0OK8wnP09rdHsHcVnQkU0I4S33lalKvl6a62HwCH4Kbmp3vRxOzoBtABqEbbjkMy5wvqidbQUgGbhiI1hwjLowHEFcfZSHKJGF42IDdfSOaTGG42giw9xMXfsk/ulifQrWKE2CBR
 p9shD0l2
 qsz2rLFGNCdmFxFV0Q7PQoB7Cdgv7/Mb4iXGHdXhjJI6G2H03jaA7KAaQg7zp9P7mxuBSHXmvrMq9+224uXH/Czk8ztJdiPkiB3h6l09KQ46Ljb6xa0L+z2KBPupGgXN4z+tp1Cyjnvdp30/LEQMLPM+NHDD/YjKXMLvuNoLrQnpocb9JX6Lqra+WoKLW44j4rC/FEA0PUUg7yRsisYmHxEvhWcZHxWsGLV7WYRYRr0TjfE1S6KOXaNZUG3p5V7aS565S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 06:20:36PM +0000, David Matlack wrote:
> On Fri Nov 6, 2026 at 5:34 PM UTC, Bjorn Helgaas wrote:
> > On Tue, Oct 13, 2026 at 04:25:21PM +0000, David Matlack wrote:
> >>  static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
> >>  					  struct pci_dev *dev)
> >>  {
> >> -	struct pci_dev_ser *dev_ser;
> >> -
> >>  	if (dev->is_virtfn) {
> >>  		pci_warn(dev, "Cannot preserve Virtual Functions\n");
> >>  		return -EINVAL;
> >>  	}
> >>  
> >> -	if (dev->liveupdate.outgoing) {
> >> +	/*
> >> +	 * Endpoint devices should not be preserved more than once.
> >> +	 * Bridges are preserved once for every downstream device that
> >> +	 * is preserved.
> >> +	 */
> >> +	if (dev->liveupdate.outgoing && !dev->subordinate) {
> >>  		pci_warn(dev, "Device is already preserved\n");
> >>  		return -EBUSY;
> >>  	}
> >>  
> >> -	if (!pci_is_root_bus(dev->bus)) {
> >> -		pci_warn(dev, "Cannot preserve devices behind bridges\n");
> >> +	if (dev->liveupdate.outgoing && !dev->liveupdate.outgoing->refcount) {
> >> +		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> >>  		return -EINVAL;
> >>  	}
> >>  
> >> -	dev_ser = pci_flb_alloc_dev_ser(outgoing);
> >> -	if (IS_ERR(dev_ser))
> >> -		return PTR_ERR(dev_ser);
> >> +	if (!dev->liveupdate.outgoing) {
> >> +		struct pci_dev_ser *dev_ser;
> >>  
> >> -	pci_info(dev, "Device will be preserved across next Live Update\n");
> >> -	outgoing->ser->nr_devices++;
> >> -	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
> >> +		dev_ser = pci_flb_alloc_dev_ser(outgoing);
> >> +		if (IS_ERR(dev_ser))
> >> +			return PTR_ERR(dev_ser);
> >>  
> >> -	dev_ser->domain = pci_domain_nr(dev->bus);
> >> -	dev_ser->bdf = pci_dev_id(dev);
> >> -	dev_ser->refcount++;
> >> +		pci_info(dev, "Device will be preserved across next Live Update\n");
> >> +		outgoing->ser->nr_devices++;
> >
> > This looks a little funny because prior to this patch, nr_devices was
> > always incremented in pci_liveupdate_preserve_device() and always
> > decremented in pci_liveupdate_unpreserve_device().  Now it's only
> > incremented once (per device) in pci_liveupdate_preserve_device(), so
> > it looks unbalanced.
> >
> > My guess is this is because previously we didn't expect to preserve
> > bridges at all, and now pci_liveupdate_preserve_device() might be
> > called several times for a bridge, and it's all just fine, but it's a
> > little subtle.
> 
> Right. nr_devices counts struct pci_dev_ser entries that are in use, so
> it goes up when a device's refcount goes from 0 to 1 (the entry is
> allocated) and down when it goes from 1 to 0 (the entry is released).
> For endpoints that is every preserve/unpreserve call, but a bridge is
> preserved once per preserved device below it, so most calls for a
> bridge only change its refcount.
> 
> > I suppose the "(dev->liveupdate.outgoing && !dev->subordinate)" test
> > above is what allows us to just increment refcount each time a bridge
> > is preserved.  And the test around pci_flb_alloc_dev_ser() is doing
> > basically the same thing.  I wonder if there's a way to connect them
> > more explicitly.
> 
> Agreed, both points come from the same thing being spread out. I think
> both can be fixed by splitting pci_liveupdate_preserve_device() into
> "already preserved" and "first preservation" cases, and moving the
> nr_devices accounting into helpers that allocate and release the
> struct pci_dev_ser, so it is visibly paired:
> 
> 	if (dev_ser) {
> 		/*
> 		 * Endpoints can only be preserved once. Bridges are
> 		 * preserved once for every preserved device below them.
> 		 */
> 		if (!dev->subordinate) {
> 			pci_warn(dev, "Device is already preserved\n");
> 			return -EBUSY;
> 		}
> 		...
> 	} else {
> 		dev_ser = pci_liveupdate_alloc_dev_ser(outgoing, dev);
> 		if (IS_ERR(dev_ser))
> 			return PTR_ERR(dev_ser);
> 	}
> 
> 	dev_ser->refcount++;
> 
> with pci_liveupdate_unpreserve_device() calling a matching
> pci_liveupdate_free_dev_ser() when the refcount drops to 0.

I think that would be good.

