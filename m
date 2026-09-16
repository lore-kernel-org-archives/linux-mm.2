Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13948C982CF
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AF16B0092; Wed, 16 Sep 2026 19:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC0C6B0093; Wed, 16 Sep 2026 19:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF22B6B0096; Wed, 16 Sep 2026 19:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1186B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:54:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F9BE40172
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:54:36 +0000 (UTC)
X-FDA: 85221282552.19.2ACFD7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9AD4E140004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:54:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYc8Cui1;
	spf=pass (imf09.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789602874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=wgoX0NFNrnLOccx1kwVwT9i8vW+4UjtWT+bTNhxa1JQ=;
	b=xRkyFTgAip28CtUyu/ZThPaZ94TFS0za541648L+a1lwwbYN6FwC7sjnrW28t2ikCnDsKZ
	BxRt3rUlI85O1cOxc0WYNp5o0MsEHmcut3tXqCvIb84FhUkgPf4gXH+cw6QdU9i+XEtKD2
	JaL8eLUa+UbyoTZ+/azh6Sb2GV4yEWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789602874;
	b=AjrA4pcXeKkL9IGbTdRDjW3YOe8M14sFNaPH8oZcWwcaXEYgvj2XkavCCMFOTRKB/+UCqi
	wyEtr+DCxmpSVBWXJKAgG5LK0qjU73AptpFwDp9PhvuLYBdIcJXposGxmndMzAqktL85uF
	E/f0urWsDfXjban/VC0HIsXIhUzm9SY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYc8Cui1;
	spf=pass (imf09.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2026406EA;
	Wed, 16 Sep 2026 23:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1981F00893;
	Wed, 16 Sep 2026 23:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602873;
	bh=wgoX0NFNrnLOccx1kwVwT9i8vW+4UjtWT+bTNhxa1JQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=RYc8Cui14PqHJGYd2OA4w//4W/q+vKpT9752cZehXytimpFfD8DdnJqfm6nox2RHc
	 iQQsK4TBBleeaWmaW1texNzMvSu1FYdqDEj3dGhP+6tNJUu+aFuB6cNmkwEqmyXyNe
	 ThdDm0PA87ErxznKkitA2GRnCrjKO038Y/efClSt40jtmT0AjIALjPknHaQHTdYTJ8
	 PuNo4hVCuIOwkiLYuw1lx+h10AMaIohr8rHPa5PBQdkWIZdvO3krGkjQxT9zYtmBx6
	 awTw+7Q3iewdwm8pVHMKqfNiyGmFEGT/mJRu8cYyeh2pRZjCunC1/ZsBMUNN+QlMsK
	 Ccfl8goJC1ExA==
Date: Wed, 16 Sep 2026 18:54:32 -0500
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
Subject: Re: [PATCH v8 05/12] PCI: liveupdate: Preserve bus numbers during
 Live Update
Message-ID: <20260916235432.GA991837@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqWMjrea2MMMZHxr@google.com>
X-Stat-Signature: 9x7x7twupqybf11bzmi11hobm31a5aec
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD4E140004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789602874-25328
X-HE-Meta: U2FsdGVkX1+D1N8k1GSpz0KFz+LrxlSGipVZkaTd304EOw+sbltMxv8JAMsE7YoQKgT9aIj2Ch5WujMxUvxTcHNnXh8fSusE4dlvTAWI9NKBC8nh62LJeJLA3BN06a1WdnmMZ4Fx3C1AmNmtU0xDIfU3YhO0xu1vuOl75BBbNjCqWec7oiHDaXtC8S4unZfEoGXdaH01BmZmDbGur8xVwgNlmTHJ8fxKIO5QVlH2S/9EP9Z+sBWn+uJVD614EgKEBW61dMCZso1iDQ43OqbQiBzAfepHvbOcwb/JShogEPA4p8OLI9qhtaO0q9p5AIC8mhexuaxPqyG7Z8lWxrqPPG1HetHpjA1SgReo5aKbafQun6JboX83cZ+p9MVmmLNfFECbJKoS50YjFmJLdpohmENlKXu6sD4NgfAKzkrQSNo7VIh96P/WjPnjWA34TJHxch2C0meTayedW9qTq1KZ9rxfHBFgnZ81pJDGhofWXPFFjS0dXOstb57xfRohP4JFar3vDmjF5MQnFDS89u9ZwaRvPkkMWZUwAofjYfyZNcIeonCYQuUlbAN561MleWuiKkY/4izVdgV45xUeFfQsXuQPmsGfudVpeVYPXLLwwIGehpWV+ByGoHpGTJQugdDYQR1dWshxS2ZTkmYsCq35B7EsRK2Yq0rIF9L+OvkrA+JUg1pDr4Ug28ocVTD9HtYXSUiaLHc/+7v3nK/0lOaqyySN/8r1aFgwEa/r06XWA71TVzbNGZiyNMIq5OEaOXUQTPk0TaKjAR9BIqV3cJTWPPB5WWnuGGVaCoZyBiP3v7fDtFeA19qqD3j/JvyMTXB8SHeoqqTbSBet9U63MQ6P5nZPH4tBCkdajmFYDPtAjKvQD/LSuSkl128XNygJSQHVlMe7clUtxrQq/pMVIZHezX65cR2/T5kVWQ3w0Rv7WdIKKaOIdIXR5Q+PTM1Z/rEAxDqpObi9SyHN7Afay/z
 McIKr5/9
 HLBXfnGqw4h8sWt9EVGO6G11Yvt7POrBZsMLITMm4CVS37nQhQ8kLHznjonxaK1nwCdWmr9ZI+BPnczn4gvv3awI1buKkjd9QuCSKswSNPhEdGI5hidw2tAOCjnkfj1W/PyBf3BFpfHjCgrqu37e648taez3HQh/NGVEgA/gvIMB9u3dTNtprLuJa5nHf0X6Ine/x+9TjAKOE5UN7Iel+b74eVKINiWeDn3lKIH+KfLupOD4AymmQgAuSfz9B2DUmNVSr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 05:31:58PM +0000, David Matlack wrote:
> On 2026-09-11 06:30 PM, David Matlack wrote:
> > On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> > > On Tue, Jul 28, 2026 at 10:09:59PM +0000, David Matlack wrote:
> 
> > > > +bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
> > > > +{
> > > > +	struct pci_dev *parent = bus->self;
> > > > +
> > > > +	if (dev->liveupdate.preserve_bus_numbers)
> > > > +		return true;
> > > > +
> > > > +	if (parent && parent->liveupdate.preserve_bus_numbers) {
> > > > +		/*
> > > > +		 * Preserve bus numbers if the parent bridge is required to
> > > > +		 * preserve bus numbers. Otherwise the PCI core could expand
> > > > +		 * this bridge's reservation beyond its parent (which cannot
> > > > +		 * expand).
> > > > +		 */
> > > > +		dev->liveupdate.preserve_bus_numbers = true;
> > > > +	} else {
> > > > +		/*
> > > > +		 * Otherwise preserve bus numbers if there are any incoming
> > > > +		 * preserved devices. This ensures that the PCI core does not
> > > > +		 * allocate a bus number to a non-preserved device that
> > > > +		 * conflicts with the bus number already assigned to a preserved
> > > > +		 * device.
> > > > +		 *
> > > > +		 * This is slightly more restrictive than it needs to be. For
> > > > +		 * example, each host bridges have their own range of bus
> > > > +		 * numbers that won't conflict with other host bridges. But the
> > > > +		 * previous kernel should have assigned a sane bus topology and
> > > > +		 * it is simpler to just adopt that entire topology.
> > > > +		 */
> > > > +		dev->liveupdate.preserve_bus_numbers =
> > > > +			pci_has_incoming_preserved_devices();
> > > > +	}
> > > > +
> > > > +	return dev->liveupdate.preserve_bus_numbers;
> > > 
> > > I'm not sure why you don't just return
> > > pci_has_incoming_preserved_devices() in all cases, which is what the
> > > commit log suggests this patch does.  What's gained by all the logic
> > > here?  It's not like devices will be hot-added during the kexec.
> > 
> > To protect against pci_has_incoming_preserved_devices() flipping from
> > true to false while the PCI core is in the middle of a scan. It is not
> > likely to ever happen given most host bridge scanning should happen
> > during early boot, but theoretically possible with the way the PCI core
> > code is structured. I did not see way to structurally ensure these 2
> > things cannot race. A lot of the host bridge scanning happens without
> > taking the rescan lock, for example.
> 
> After working on this more, I do see a way to simplify the logic in
> pci_liveupdate_preserve_bus_numbers().
> 
> pci_liveupdate_preserve_bus_numbers() is used in 2 places during
> scanning. First to decide if the PCI core should preserve bus numbers or
> is free to allocate new ones, and second to decide if the PCI core is
> allowed to assign bus numbers to bridges that are missing bus numbers.
> 
> The latter case should never happen during initial scanning unless a
> bridge was somehow reset during the kexec, but could legitimately happen
> if a bridge is later hot-plugged and I did not want Live Update to
> unnecessarily break that scenario. But then that creates this problem
> where pci_has_incoming_preserved_devices() can suddenly flip from true
> to false at any time and I needed all the complex logic to keep it
> consistent for a given scan.
> 
> Instead we can split the handling of these cases:
> 
>  1. When the PCI core needs to decide if it should preserve bus numbers
>     due to Live Update, pci_liveupdate_preserve_bus_numbers() can return
>     true forever if any device was preserved by the previous kernel,
>     which simplifies the logic.
> 
>  2. Then to handle the case of a bridge is enumerated that does not have
>     bus numbers assigned, we can handle that separately. If we reorder this
>     with the next commit so the PCI core knows exactly which bridges have
>     preserved downstream endpoints, then it is possible to determine if it
>     is safe for the PCI core to allow bus numbers to be assigned to an
>     unconfigured bridge.
> 
> After re-ordering, we can end up with something like this:
> 
>   bool pci_liveupdate_preserve_bus_numbers(void)
>   {
>   	return pci_liveupdate.had_incoming;
>   }
> 
>   bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
>   {
>   	struct pci_dev *bridge;
> 
>   	for_each_pci_bridge(bridge, bus) {
>   		if (!bridge->liveupdate.was_incoming || bridge->subordinate)
>   			continue;
> 
>   		pci_err(dev, "Not assigning bus numbers, preserved bridge %s lost its bus number configuration\n",
>   			pci_name(bridge));
>   		return true;
>   	}
> 
>   	return false;
>   }
> 
> The net effect on pci_scan_bridge_extend() is:
> 
>   bool preserve_bus_numbers = !pcibios_assign_all_busses() ||
>   			    pci_liveupdate_preserve_bus_numbers();
>   ...
>   	if (pci_liveupdate_refuse_bus_numbers(bus, dev))
>   		goto out;
> 
> We could further scope pci_liveupdate_preserve_bus_numbers() to only
> return true for host bridges with preserved endpoints downstream, but
> that doesn't seem worth the extra complexity. It also seems nice to keep
> the pci_liveupdate_preserve_bus_numbers() policy global to match how the
> existing pcibios_assign_all_busses() policy is global.
> 
> Does that look reasonable?

Yep, sounds good to me.

