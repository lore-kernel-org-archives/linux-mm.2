Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB111061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E485F6B008C; Mon, 30 Mar 2026 18:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FE56B0095; Mon, 30 Mar 2026 18:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EE66B0096; Mon, 30 Mar 2026 18:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF4C26B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:54:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EE22C28AA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:54:42 +0000 (UTC)
X-FDA: 84604235604.28.C0AD8BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9516BA0005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:54:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B8syhKKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774911280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=AsHMOe97xyJT3nr2JXGse7sRAJPfDYTkxClSq/c6RB4=;
	b=BLFaH+1W2QzhW4DsO0r+e2m0yFSjMeXtZmK42U72npNABZQxHNeX74hDZBsWoAkTdsC3ex
	Js4ieFuhRGou9eH7AcqQj7xyln1xkbcln8+U+BE9pmO9KeAVLwecN9cvpGQ2MJZo+EzH/1
	vqSyjwc7Rj+BdZgAIyc6QsNcjUZbszk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774911280; a=rsa-sha256;
	cv=none;
	b=mT4V3xcw6pNJ80Be+dnkZFug2UQVVDdWeWm3zdrpT9pvrtfwufEUQDa799defRG5scslph
	W1xA5sceZ5lFJY43BG6CjDB4SqYOUdTe0ijgzcCloRrCx4se6gxKi+YoT2ow8pjQ9OETsG
	6CPyV58TWzyu6dWrMm/Mfa5IeGkv6HE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B8syhKKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 484A540591;
	Mon, 30 Mar 2026 22:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35DFC4CEF7;
	Mon, 30 Mar 2026 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774911279;
	bh=D72YCLwgexObNKWUs+QMeapQr6cp2LwytErV3nWFNrI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=B8syhKKsyFZJp5ViyX++4WrxJjf/s9SAF7iygNRC2lm40WrFlLGTAnr0hFbEHEWpg
	 ia0nmVOXtkUh3vhlhox571th3beaW/qiZ0UhWghrTL0ijZ1lHdbckIr1aHU9zAe5G0
	 CvsSlIKv0lEt3fPrjfgSEPOeIVkS1hIVMfwLKgsEWB5ljchs42iEpW0WypBa1aNJds
	 nbeHvJqpoSsA0leiKgJIfEu3KmnUNxL6DcREVydRzDquesl/x/Xq6CUf44WrwNt74U
	 7/bdEe0ptuFtBXnFOID+jZrpG5MRU/isthWqPdqX6EOggBOF7qrB3M+2MOfD0eEOQv
	 QGKQ7dkrgXF1g==
Date: Mon, 30 Mar 2026 17:54:37 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260330225437.GA111390@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acWne_ZCcF4YQN25@google.com>
X-Rspamd-Queue-Id: 9516BA0005
X-Stat-Signature: pdbs7owhtob98ddk58ox5ijp3irsxthr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774911280-150441
X-HE-Meta: U2FsdGVkX1/g3safOcVasUR/u0U2rOstTTz6uO4U7sBaH4+NfNQTktkFizlCTerdY5CeWuvR8HT6cEcB8DxtzcCjXaJW+4tJUOH1dZKAnq7aC9fCgRrMVnfHdBjbCKEFSjORjhG3XY+U34sgY8T1x9sX0DFoPo+1nR6UkhPfE1iBvaUjEGMUhI0uf9mdgnVxwbYRgdUwQaaWkoRxzqzOAxswnYEq5qG1/7sd/YdgfyYLorx++Rqwxn9rYbDGjk4qxZPCXfFdOxz62JXia4N72Q87GVyQHsq3r1vNlC58xFiumizk5bsUBMe4g8/Hi76BgRyGEOsq/r92xNRYg/oVXkjlje6I/254xR6Fu88NLk/9rirojyEhpbyNUIQPB2k0oJh2hY6Pf6UOPyynQGL9461g1sGM7gWTyBBFI0GGPtHYakveAiUkcj0uszcR7aXuuamzXtyFDm/6Fr+6y7qTDxQc6ox25X2nRexJ/7e9+q1GMiyW4VnNTNBBW1kEbF5SJL7ioyURnRcYQ4fmyS/Nu7LMjev0ogdyaJw89bj4uwXWCIyBP+FjE3W6FBJPQQNrkr0tK3OKev8xHT1ieJF1bvl+dsQqm3JySvFkLLHjZVqSwxwFct57vsNmWutamX7GWmlIcVZH4VVSWUIFbklugZuEpvOWYpEUw5z3pUvoXysqHFygI4lMsk/kOCdzOTpk0pAJ+t4IvTGpPir0C+wHa9wdnpmm+ClHSIsPLm5Zq55cVAGfW96hXnAF3+AKCOZXoSr3qDIqornVkKYjqxT07IYVXIxzWgC2eIevFH8TGusAOB8af+2pgz8jMn6RD0d5OCVYF/0VyHA7BHXxhU1Wd/68yZmqeG7csOPLmcjqVfvNYHit4WOmlpA7KQ6oQk+ofOPiu+m5IPpmrenbF+fWvMXLdA97o9G7oaOrrXzmyjafoZdNGEMlqEt2M2DDcQY2zV+Ixphuoapmojwp8JZ
 PPUxCFBD
 6U56xdRz3fxQM8Mz7euvmJ2imyfUkmMINYVVtB8PascYp4FqdoNZp3+bcHgZiDeL677WIbAww0HasbeDD7BUNKrj3tnFsewAvYMiHmd/jNdgHsgR8O4PjYArkNdBftyymiR3+nWQhdgzAXynC3L3NY9gP+x+smzKjAadfQcnjgISvnBSintql/9Cy/XSiIb8kEQdEb1ZLcCFtYS/8Vd/jCONu3zj5H1NtdAg015wzND4YzITfDmO2op3vIKfxBpRSpfkXp3oqBq1arzSDznFNfvT51TQAyOJWMYH3myy3wTtmbmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:39:07PM +0000, David Matlack wrote:
> On 2026-03-25 06:12 PM, Bjorn Helgaas wrote:
> > On Mon, Mar 23, 2026 at 11:57:54PM +0000, David Matlack wrote:
> > > Add an API to enable the PCI subsystem to participate in a Live Update
> > > and track all devices that are being preserved by drivers. Since this
> > > support is still under development, hide it behind a new Kconfig
> > > PCI_LIVEUPDATE that is marked experimental.
> ...

> > This sets "dev->liveupdate_incoming = false", and the only place we
> > check that is in pci_liveupdate_retrieve().  In particular, there's
> > nothing in the driver bind/unbind paths that seems related.  I guess
> > pci_liveupdate_finish() just means the driver can't call
> > pci_liveupdate_retrieve() any more?
> 
> liveupdate_incoming is used by VFIO in patch 10:
> 
>   https://lore.kernel.org/kvm/20260323235817.1960573-11-dmatlack@google.com/
> 
> Fundamentally, I think drivers will need to know that the device they
> are dealing with was preserved across the Live Update so they can react
> accordingly and this is how they know. This feels like an appropriate
> responsibility to delegate to the PCI core since it can be common across
> all PCI devices, rather than requiring drivers to store their own state
> about which devices were preserved. I suspect PCI core will also use
> liveupdate_incoming in the future (e.g. to avoid assigning new BARs) as
> we implement more of the device preservation.

Yes.  It's easier to review if this is added at the point where it is
used.

> And in case you are also wondering about liveupdate_outgoing, I forsee
> that being used for things like skipping disabling bus mastering in
> pci_device_shutdown().
> 
> I think it would be a good idea to try to split this patch up, so there
> is more breathing room to explain this context in the commit messages.

Sounds good.

> > > +	 * Don't both accounting for VFs that could be created after this
> > > +	 * since preserving VFs is not supported yet. Also don't account
> > > +	 * for devices that could be hot-plugged after this since preserving
> > > +	 * hot-plugged devices across Live Update is not yet an expected
> > > +	 * use-case.
> > 
> > s/Don't both accounting/Don't bother accounting/ ? not sure of intent
> 
> "Don't bother" was the intent.
> 
> > I suspect the important thing here is that this allocates space for
> > preserving X devices, and each subsequent pci_liveupdate_preserve()
> > call from a driver uses up one of those slots.
> > 
> > My guess is this is just an allocation issue and from that point of
> > view there's no actual problem with enabling VFs or hot-adding devices
> > after this point; it's just that pci_liveupdate_preserve() will fail
> > after X calls.
> 
> Yes that is correct.

Mentioning VFs in the comment is a slight misdirection when the actual
concern is just about the number of devices.

> I see that a lot of your comments are about these WARN_ONs so do you
> have any general guidance on how I should be handling them?

If it's practical to arrange it so we dereference a NULL pointer or
similar, that's my preference because it doesn't take extra code and
it's impossible to ignore.  Sometimes people add "if (!ptr) return
-EINVAL;" to internal functions where "ptr" should never be NULL.  IMO
cases like that should just use assume "ptr" is valid and use it.
Likely not a practical strategy in your case.

> > > +	if (pci_WARN_ONCE(dev, !dev_ser, "Cannot find preserved device!"))
> > 
> > Seems like an every-time sort of message if this indicates a driver bug?
> > 
> > It's enough of a hassle to convince myself that pci_WARN_ONCE()
> > returns the value that caused the warning that I would prefer:
> > 
> >   if (!dev_ser) {
> >     pci_warn(...) or pci_WARN_ONCE(...)
> >     return;
> >   }
> 
> For "this should really never happen" warnings, which is the case here,
> my preference is to use WARN_ON_ONCE() since you only need to see it
> happen once to know there is a bug somewhere, and logging every time can
> lead to overwhelmingly interleaved logs if it happens too many times.

I'm objecting more to using the return value of pci_WARN_ONCE() than
the warning itself.  It's not really obvious what WARN_ONCE() should
return and kind of a hassle to figure it out, so I think it's clearer
in this case to test dev_ser directly.

> > > +	for (i = ser->nr_devices; i > 0; i--) {
> > > +		struct pci_dev_ser *prev = &ser->devices[i - 1];
> > > +		int cmp = pci_dev_ser_cmp(&new, prev);
> > > +
> > > +		/*
> > > +		 * This should never happen unless there is a kernel bug or
> > > +		 * corruption that causes the state in struct pci_ser to get out
> > > +		 * of sync with struct pci_dev.
> > 
> > Huh.  Same comment as above.  I don't think this is telling me
> > anything useful.  I guess what happened is we're trying to preserve X
> > and X is already in "ser", but we should have returned -EBUSY above
> > for that case.  If we're just saying memory corruption could cause
> > bugs, I think that's pointless.
> > 
> > Actually I'm not even sure we should check for this.
> > 
> > > +		 */
> > > +		if (WARN_ON_ONCE(!cmp))
> > > +			return -EBUSY;
> 
> This is another "this should really never happen" check. I could just
> return without warning but this is a sign that something is very wrong
> somewhere in the kernel and it is trivial to just add WARN_ON_ONCE() so
> that it gets flagged in dmesg. In my experience that can be very helpful
> to track down logic bugs during developemt and rare race conditions at
> scale in production environments.

OK.  Maybe just remove the comment.  It's self-evident that
WARN_ON_ONCE() is a "shouldn't happen" situation, and I don't think
the comment contains useful information.

> > > +u32 pci_liveupdate_incoming_nr_devices(void)
> > > +{
> > > +	struct pci_ser *ser;
> > > +
> > > +	if (pci_liveupdate_flb_get_incoming(&ser))
> > > +		return 0;
> > 
> > Seems slightly overcomplicated to return various error codes from
> > pci_liveupdate_flb_get_incoming(), only to throw them away here and
> > special-case the "return 0".  I think you *could* set
> > "ser->nr_devices" to zero at entry to
> > pci_liveupdate_flb_get_incoming() and make this just:
> > 
> >   pci_liveupdate_flb_get_incoming(&ser);
> >   return ser->nr_devices;
> 
> pci_liveupdate_flb_get_incoming() fetches the preserved pci_ser struct
> from LUO (the struct that the previous kernel allocated and populated).
> If pci_liveupdate_flb_get_incoming() returns an error, it means there
> was no struct pci_ser preserved by the previous kernel (or at least not
> that the current kernel is compatible with), so we return 0 here to
> indicate that 0 devices were preserved.

Right.  Here's what I was thinking:

  pci_liveupdate_flb_get_incoming(...)
  {
    struct pci_ser *ser = *serp;

    ser->nr_devices = 0;

    ret = liveupdate_flb_get_incoming(...);
    ...
    if (ret == -ENOENT) {
      pr_info_once("PCI: No incoming FLB data detected during Live Update");
      return;
    }

    WARN_ONCE(ret, "PCI: Failed to retrieve incoming ...");
  }

  u32 pci_liveupdate_incoming_nr_devices(void)
  {
    pci_liveupdate_flb_get_incoming(&ser);
    return ser->nr_devices;
  }

> > > +++ b/include/linux/kho/abi/pci.h
> > 
> > It seems like most of include/linux/ is ABI, so does kho/abi/ need to
> > be separated out in its own directory?
> 
> include/linux/kho/abi/ contains all of the structs, enums, etc. that are
> handed off between kernels during a Live Update. If almost anything
> changes in this directory, it breaks our ability to upgrade/downgrade
> via Live Update. That's why it's split off into its own directory.
> 
> include/linux/ is not part of the Live Update ABI. Changes to those
> headers to not affect our ability to upgrade/downgrade via Live Update.
> 
> > It's kind of unusual for the hierarchy to be this deep, especially
> > since abi/ is the only thing in include/linux/kho/.
> 
> Yes I agree, but that is outside the scope of this patchset I think.
> This directory already exists.

Agreed.

Bjorn

