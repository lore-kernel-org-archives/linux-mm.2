Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8D7C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45916B0098; Fri, 11 Sep 2026 14:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4F06B0099; Fri, 11 Sep 2026 14:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEA86B009B; Fri, 11 Sep 2026 14:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 813A76B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:30:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65966140307
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:30:28 +0000 (UTC)
X-FDA: 85202321736.16.2BC487B
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 871E920009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:30:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eb3FGkiX;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNS06P8dgAVGWElToa1LxbVILkDrDt7tgcn+fOWtX1k=;
	b=MONZuPbb61XpMyFJDoJAxO9gTEx03AF4s4DDBMv1IGBSEcZA34fRMEf2yKLqvwW4p+tP+o
	1/OQn8Kw1qR02VNJkLHhQOuCu3pHMQXPHmgGSQ/4lvIJWEnpqP7/3XoXm3igRgRmSEW5YD
	5qbL+h/j5AOiWeXOk1I1QYz+lBMlAhY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eb3FGkiX;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789151426;
	b=XJDlmfgRRQm9ljBc02l5U8k+bBDis1NFQgh9dibLnP4vYRwIzVEIIyhoTaHW0Wnv+ZSrzs
	Vkn6B09SjVSX28UF2zWXcYpKpF/Lbrs8cxo+bWdNUq3u7F2QVwzhzwMdhl4lXm19yQ+3bn
	/X9ASU1e93H8K+i9Wnp9d0szn+aW+7M=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d6fe26ef1cso17373835ad.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789151425; x=1789756225; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wNS06P8dgAVGWElToa1LxbVILkDrDt7tgcn+fOWtX1k=;
        b=eb3FGkiX8Tl3487oMAuT5hGigresuCdBTqU8iVr4zb8eYxC32A8z3d1je5PDgGbUxB
         1JjK33poHV9bLQg5ozGLxn98HNneE7VDiTXgdFVRQSaCUTrP+h5zjpASBQI8FbXBoSjL
         xs/1453XvhFAPsLnE9Gzg9Z5C+QwCZFcR5QQUVIxWf2h2tP4lQNGxpI4edPJYrtiwNZJ
         jTr9js+9k5LC5nalYWhhn0kaIs+SrD6ilsQf6yB2gD2fnJyFNvxTzEZiCVcg3tqwO5/U
         NEXZYYgFAEE4Y0gSE3CexB98QtS5+gHB6PBlS2/bnpTGKyScKfH5bqjTvOtr9SbAOe8M
         3zWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151425; x=1789756225;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wNS06P8dgAVGWElToa1LxbVILkDrDt7tgcn+fOWtX1k=;
        b=RkA5Wt6vHuvZhSMhDoNreC4HMIm88BHNlyb4puPtyYw7jdYyplzel+VBlyFNKchDkX
         gzFlAGg2JaPJejI/NetbdmgUyto+5I9iBcw3B/0FoFUj7EEeRNCGyrldeaX2C+Nu3DDo
         PDThQxCcZ/CUHxpnD5AaJVdUYzmjjZfO3NliOlCbWdVWcVp+PqGYzNi888YJXOZXX5SS
         N4uqVWVIv6ja+OeADT8REIYWpxK7jBFiFARZTd/atCsj7ugXHT2zdQSdI8m4Jw+qCo0E
         TUwpFxJDf7zmH0PJ932Yrgv1kS+uaxcTq5SkBYrySOfwifKbbGU/XlaQoaj3hZDYtzfc
         IrIg==
X-Forwarded-Encrypted: i=1; AKwUvBzZEkn4EWqTDZ6En2JaNG5IKfPP2tgCua+IrTSm7cjU+WpKbhms0MVdFuN7rQW8Vy5IsrjDCE04hw==@kvack.org
X-Gm-Message-State: AFuF++nNEzFqNLcBMv4fHbq18HGv2hTXa6aSbn719gPPfVUe3K0DsJp0
	clZ6x8VDQ3466d3mxab7XIe7ZhIi8zqahyG4buauE0sW4LK1vjpb/WuxvVto0YGLPQ==
X-Gm-Gg: AYBFou1yzTjgS0K13MTvATJZyesrd0TztHfFKPNurMgtdq/tRhoegcfgFLyXSoaCvYJ
	tqKVw52fTz3CzQhfF/6kks0e0axhJqqZ5p1yYGg0ReNsI/sRzG43OqPuWH3OaQ7puOBorBntOsx
	NT9rrZvR/oL7qj9sWmCeovMUXoHfuEA+I5tKoHDMwPtClm/hevy/FvJ7PusMUH9RX5Tis+iGtAg
	Aa2OOi/hxVBUEZ3ITAuetBQiu3iiHAojKurfx3LmhTXiud1KsrmD18wrQTYdToeYfXrWx5fBWxB
	/OnaPIcCriAR7y1juli7LIMQXI0gpdyMXUW/bj6SbaJ2js57AOaIachJeaE2RSis6Jjp1uURLY1
	aDj4QT8oSTy9WrS0VwH4VybER7547+IoKwuzo1gEbBZHhwbt8c1sWBFVpVxvt6hayq2H2WqN+NE
	4cMB4JLASpc5SI940xWkmGKaAoB8iWVvdv9GYQxgX3M7dQXBZ2sqCGMt9ljwnyxTB7r9z/FwQVf
	7Tyt0WL0dHjFJK3ttqMIwAlL9FPrUgKwghTSMR0
X-Received: by 2002:a17:90b:53d0:b0:38e:bfe:81e9 with SMTP id 98e67ed59e1d1-39d9bc1b0demr8040768a91.1.1789151424426;
        Fri, 11 Sep 2026 11:30:24 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm6613109a91.14.2026.09.11.11.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:30:23 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:30:19 +0000
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
Subject: Re: [PATCH v8 05/12] PCI: liveupdate: Preserve bus numbers during
 Live Update
Message-ID: <aqRIJs1SdJwoV_cf@google.com>
References: <20260728221007.2098560-6-dmatlack@google.com>
 <20260910235104.GA367522@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910235104.GA367522@bhelgaas>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 871E920009
X-Stat-Signature: brtueg3w8wkdg91am8tgds6q8xi744yn
X-Rspam-User: 
X-HE-Tag: 1789151426-88412
X-HE-Meta: U2FsdGVkX1+U6ogFgS58hNH2AWu9XGy/KaiVznX09nmOXQSBm34znzDm6l60MOJfFBANSwhP9AJOe9rSjIZy/hWlrN0UG5nTQEh8FJ+Bv7BBEa81zmnWKUZ8WJVgc/6CtB2Tt/XdRBoH/r8Pn9vDR2lsHCnOfD2xmOmpLIEDYo6JB3prDYUKCLCicIbZK0nnBtQYOMrmBLTjUy4xpBwRAg2TZypeBEsoydQxfvsej/hBRHz/cmjA3PWWT+pHJqS/r0WAX7KE1VuIWZIG7ohzakHZZiW56oAHwluJC+9+7UgqNCKQGizadTo/w/tEHPej2BgeBrO/QEgnKOZbkD2wX7waOOFdI7yv35xjhrKAzQ3E46rs41+pYj4doNidDtVe+LvT2r0CdKTPRwxH0wB8SkuuU4msvn9R/oqyQbrRNEKV9lgJ0M0ehBsQuUGFIlokfR7xdBpdE4wbZvCJpQRmJaBCiKVu2QdC1vNMOzhF7sSM+2DtlOwBOAbWQ0IeLLooy43lNuEOug1FEWOCY1bs13MWO/UN7RWuO6X1QgkUNmreDm3O3B8VvEVcUSgbhxYrbVOoFVxE2t7cfjwuctB7bL2FBCHfPibdKNsM+wKjwVp1ed7gggEhbNT2aAW0LGIaw3eV0SEYCekNu0vqR+d1/+ICOyTeKq0SzeeV8G+5My26Rx9c7Sh6GWk5ND0RrSKem+gsHr3l3O+YiiBuDyZZvFN154sIUFaxZtlGfbyDYVbMPOrETy1sTMyufGyywIbJdsITNsKLbw+hKxvukTFSRm94c09CtJDlPEE0PmI/DdCUm8ZGwWwUCEz4oG91UAUYpuIYBRycULkjtavQTIKycWm+tr7XOn9dsDFZFUvQvqcY5ulon97a3FChEQO7jbwo57K5fdWIER4XYkHCZPXXSQxdd68Xw9r6anWuT3H3nyxDeJi3UWu8Flyh/vQWoOjhKCLdYquTcoB2anlmt8d
 VlOKfsLl
 Insj8plZBg1qth6SJkE56nEHOHBzGm0d0rOuk8L/6Bx4DKIiOCYhHD+EXxH4TaMmCAnONsorcZ0rCxLIJSpHHdy33IDtiOCwvaNOlW8gMOf4RGR8loy/BAy2vVt3mEBV2OBEneuLH4X+bnHght+lENnCJm82D/2ETm21POOQeQJOa//rzvLeC2V3WY1pVUelsmKW74QWd0mosouV42MXsvwxwmMbIR7rHMqwXPH6DNUIzJ3IaRUdJiqYgbhy4SnXVzbKS81j7w0jrCYL7K4MjSZT6qMrMsFFTCoTtB2ocBh74M9W8oDqGUjeS9RKt6INoarTcoeldLdhgAsZ39rXLy6E/Ksw4qYpXMJFGnWZsANq5OGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:09:59PM +0000, David Matlack wrote:
> > During a Live Update, preserved devices must be allowed to continue
> > performing memory transactions so the kernel cannot change the fabric
> > topology, including bus numbers, since that would require disabling and
> > flushing any memory transactions first.
> > 
> > To keep bus numbers constant, always preserve the secondary and
> > subordinate bus numbers assigned to bridges during scanning, instead of
> > assigning new ones, if any PCI devices were preserved. Note that the
> > kernel preserves bus numbers even on bridges without any downstream
> > endpoints that were preserved. This avoids accidentally assigning a
> > bridge a new window that overlaps with a preserved device that is
> > downstream of a different bridge.
> 
> > +bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
> > +{
> > +	struct pci_dev *parent = bus->self;
> > +
> > +	if (dev->liveupdate.preserve_bus_numbers)
> > +		return true;
> > +
> > +	if (parent && parent->liveupdate.preserve_bus_numbers) {
> > +		/*
> > +		 * Preserve bus numbers if the parent bridge is required to
> > +		 * preserve bus numbers. Otherwise the PCI core could expand
> > +		 * this bridge's reservation beyond its parent (which cannot
> > +		 * expand).
> > +		 */
> > +		dev->liveupdate.preserve_bus_numbers = true;
> > +	} else {
> > +		/*
> > +		 * Otherwise preserve bus numbers if there are any incoming
> > +		 * preserved devices. This ensures that the PCI core does not
> > +		 * allocate a bus number to a non-preserved device that
> > +		 * conflicts with the bus number already assigned to a preserved
> > +		 * device.
> > +		 *
> > +		 * This is slightly more restrictive than it needs to be. For
> > +		 * example, each host bridges have their own range of bus
> > +		 * numbers that won't conflict with other host bridges. But the
> > +		 * previous kernel should have assigned a sane bus topology and
> > +		 * it is simpler to just adopt that entire topology.
> 
> s/each ... bridges have their/each ... bridge has its/
> 
> It's true there should be no bus number conflicts between host
> bridges, but it does require the domain as well.
> 
> > +		 */
> > +		dev->liveupdate.preserve_bus_numbers =
> > +			pci_has_incoming_preserved_devices();
> > +	}
> > +
> > +	return dev->liveupdate.preserve_bus_numbers;
> 
> I'm not sure why you don't just return
> pci_has_incoming_preserved_devices() in all cases, which is what the
> commit log suggests this patch does.  What's gained by all the logic
> here?  It's not like devices will be hot-added during the kexec.

To protect against pci_has_incoming_preserved_devices() flipping from
true to false while the PCI core is in the middle of a scan. It is not
likely to ever happen given most host bridge scanning should happen
during early boot, but theoretically possible with the way the PCI core
code is structured. I did not see way to structurally ensure these 2
things cannot race. A lot of the host bridge scanning happens without
taking the rescan lock, for example.

