Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3657BC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0616B008A; Thu, 23 Jul 2026 18:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA09C6B008C; Thu, 23 Jul 2026 18:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92546B0092; Thu, 23 Jul 2026 18:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79F286B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:29:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7DEEC01DF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:29:51 +0000 (UTC)
X-FDA: 85021484982.10.4292C39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FE4640009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:29:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jxZW/nu3";
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784845790;
	b=OVr/wLF6qif2oZFdttmpQumNtAmr/Wx02hU6MP/cp6Rrt1ofW8D+Mja9teO7+rYDdb954F
	XcfFPQBC6uLs8MZoorEZvvbsqfjNILYwFWvhX5h319D/uFUJ2d0LTtSMlwl9T+88yCxEgC
	flJdpO4f8MlqPZ352GQ08x1/yQmJnkE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jxZW/nu3";
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784845790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=AzhkvE35OLgSJeDoG4ympV/KpNSWvwXjJ0euGOpNYdM=;
	b=cZFoTK5JcemdUxYc+RxJYGAP2VWWIbW0HsafBwC8DMy0qLJIQOxxs02YcFgX3I16+efuZk
	LGveZ/y+pMuniUTGCWFXxUPpsbQayDoIl/fy/4ueuOkmGJVU7VnP9cKjkHCyCm1v3wjsDI
	rXK6YyQFSmiY7qKg7sMQD7Gt1rpivTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31FCE437E5;
	Thu, 23 Jul 2026 22:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF061F000E9;
	Thu, 23 Jul 2026 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784845788;
	bh=AzhkvE35OLgSJeDoG4ympV/KpNSWvwXjJ0euGOpNYdM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=jxZW/nu3CXPiWcwj+x6K4YRDb3DrW8DFXGAxUW/O/c41NSdn+3EAAGfV128mF4txX
	 u1ujjcA2PwqcZUC9bf9hS2Igqo07ugIeH4d/G8zLSxxVkDF7rKuq65okwe/EbAMegB
	 Q4xAVC4G8ItofSVuXKgtcHFDz5EW1+Gq4nEZ9boWdkh1PIO7Io9jIZG/LzQCZyMfU2
	 Pfk7jJNctcfToZeLftnQ4AJ9ZmSCbwyht6uQ60I3sWz6Mqc3m4v9iNVllRdCQa8Xu7
	 rTzvBICrwzL/iafIpRv/MiTC0qsCRlGWXIrWPdBjdTl/ewxIJAvdwUrV5Ya/ZhAOYX
	 gev15MW3uJHEg==
Date: Thu, 23 Jul 2026 17:29:47 -0500
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
Subject: Re: [PATCH v7 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260723222947.GA868047@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-3-dmatlack@google.com>
X-Stat-Signature: k9qg1fzjkuxcp9hdzci3pgx5rwdkgt69
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FE4640009
X-Rspam-User: 
X-HE-Tag: 1784845790-276703
X-HE-Meta: U2FsdGVkX1+371Ub5igd28jNjeUaL1y70z5speSb0z4DvQWjaJPsvrWroqgUWGp9zHPakDOz+tdWEzLb3QyaSWaWYt8Ap0+wKSN3Rj/CKaLdb9bkZ2a8WW1zQY6cJu+G3qk85p9QVcAGmflhMgTNlag1bX60kePcrnbT+W4pVkoMAcJj8Wn3uzAhHFdXHe1tO/uOplQXMlCnI6YGkwetujGBpOYClJ3rn2Dno7Y15zulHj0dXztDIaf/DmexA0pV8L3pcLBHqw7/Pive9GP3eNf17/0BMnmw+hZPBIeKXQx5MgyiuG5Mfv976OzZKi0yr6WL/HwfUjz4w/N99Hz2oOqF48+s/mDYEjkaBsUdzKs/6Xs/VW7q+WxIYxwWyZzbmyO2T45gg+BFs0fwxXcrYEeUz2Ra3JCd5++8lmojQx6hmzoQQRzn+sCz05kzm9CKV51GYZ509pBUzC1Kr7pJ0IPBHxSE4TIct8xGCDrVbEcZFYUWQRB+DP7mqysr6tjTynzcufuA5eDTtbkqYhCPcaVmbTV3Rlwog11XSvsMWl8Zd3b35XcEAsBmweC92bwRwSdzix/bZ0Y38eBRMircxHiYikVcHJwqwpURuFJq2IlmZ+tECXjKiwXJ/jZ+2TICfQAWUseBZTpC8W6ns61F1nxPOPk9Oj3Qm6bKct5TZ6YhsUHcRQF/b3iK5EC9YVoGP4vcsYQ2efKptbhM//LIN5zUCqbOY0Xe+vZsB+GZyg/lgr3PvGILU93MM8M+ET0+8RQjKPjkE+HY2fZTuaHsV1OE8oRUXYDDAQdkRgoxdY5AeyZvkoF70fJ78QnL+k7cmKhgloz/VtefuRj1ve5jbRxP/0qhosIN9ytHwO7KBAa9lXrn6KwGZ7pcf5VXxMr1SQQsrKj5YNGvIiDIDi76zFwp+3FCj5cgSAqOLewUsVPSAL8unhFimi+unqdMg/vonNxMqpyGOY6fnT2KNX5
 apcBuu2G
 EeW6EjHXUuX8x6jdfmENSRUzozkMvZiERYiXB2GaXzaZAXIYvlS3Q7AD/uYArS5ozuvGZkNcVBtp4I6AvMiRYKznrCGn7U17nx4NO7FB8SIUtx2cY+z9u+dUttdiQh4NOqlAUvAXlRjgyYlQw6AJeRwhQBYQ519vMZpTCLfyvtyhVeUYxagHiJallD06TgYr0tgDBIXhEGBM4bhJ8WxcQK92IH7lVECkTzQtwi+OvKzqJNs7MBWD7VEBrwqulN5NviHojLM0mDOUraSq8WNLnMvkZ3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:05PM +0000, David Matlack wrote:
> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.
> 
> Drivers must notify the PCI core when devices are preserved so that the
> PCI core can update its FLB data (struct pci_ser) and track the list of
> outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
> device must be preserved across Live Update. pci_liveupdate_unpreserve()
> reverses this (cancels the preservation of the device).
> 
> This tracking ensures the PCI core is fully aware of which devices may
> need special handling during shutdown and kexec, and so that it can be
> handed off to the next kernel.

I guess the antecedent of "it" is a device?  Maybe s/it/they/?

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com> 

> +static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)

Wrap parameter list to fit in 80 columns.

