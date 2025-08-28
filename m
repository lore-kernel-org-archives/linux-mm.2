Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B84CA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C578E0024; Thu, 28 Aug 2025 15:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC408E0020; Thu, 28 Aug 2025 15:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994298E0024; Thu, 28 Aug 2025 15:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83CD68E0020
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:10:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 110C91DC0D5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:10:39 +0000 (UTC)
X-FDA: 83827107798.28.8E53659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E7E3180014
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:10:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiAyKBDP;
	spf=pass (imf16.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756408237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCM7BtjhSSdjPD2pC7Een8DTkoaQQR4fjFPHIwA5Djs=;
	b=5Qcm3e+ffzxOAZd3Mtf/vlmkNmPb6AK7p3blZMQkgoQ+Sx7Z7RAiTOjanY8jZzENpfLt6Y
	iVy96wnuEKMcrySkG+W+pUuHr7bcjKYq5XfA8rCCUPfzVprYa2XFcZF5YvcHVXuwfEKWtv
	lFLTcBk+HJIJCP4Er7pOgXZVbuAzcbI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiAyKBDP;
	spf=pass (imf16.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756408237; a=rsa-sha256;
	cv=none;
	b=NGDRbgNsScK0ZB+XhljMiqw/GRVaeuYhV6aIgS+FZEHDfnt4Zkx0yrbJ/eA/TRZjNlwEfb
	jm0duWgYnfvHND/NSZPmjgSdL0R4xuDUQO6BZZGBAIvsFpfnR/zrFYsdd+mmVoXpy0s88o
	5oBcIdi43Pgq6JnK9QcOcfp1yBOdzD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE2F160139;
	Thu, 28 Aug 2025 19:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBADC4CEEB;
	Thu, 28 Aug 2025 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756408236;
	bh=nTTeahhIb0FZNTHkQNMJBnWQfHnp2aJ+r4oH3UJmf9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kiAyKBDPTCAig6cfYhRFzVMlXt8gF/BgqIWlzfngucl4yl5Wcl8PEMxeGxZyn4feY
	 9QNbLauol7wPo69EnbsJUOvYSMo6YfZ3+owIkOs7tkWX5BPwXZEGC9l2iz9VL73nWJ
	 LMeYGO+x9LIMWkAgoCM0LVxjf0/nrBlT574LedC07bLp9s3BQzVau6M5uUSf07U/m8
	 vqELaFQz9N5nFU8S5MsiAq/DKmR1fhhzHyINYKZV0xBuVLm5Y0saWfzSXpuLfpmwbf
	 9eS/h5nEcBCqmS1GS4AcOq4YDto3/XpsP6UcVeqRbKR8yG+flv5A1aPbY1iMmgWmoI
	 HI/G0rHOVaaNA==
Date: Thu, 28 Aug 2025 13:10:32 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <aLCpqI-VQ7KeB6DL@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
 <20250828165427.GB10073@unreal>
 <aLCOqIaoaKUEOdeh@kbusch-mbp>
 <20250828184115.GE7333@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828184115.GE7333@nvidia.com>
X-Rspamd-Queue-Id: 5E7E3180014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jqa415mski9r3urjx6r3cm5knfn1uisx
X-HE-Tag: 1756408237-902248
X-HE-Meta: U2FsdGVkX183UylotPmnfK0PNjUVaC6Qo5E6v/vCjUhzCZDCOeRmSBpHPHjh3dAitI6l5bVvbOzpARAnAJNSEzP9EybXZ+0NvckcX/9LWXZyhsz5axAnvGzEerBgGtxNrLBv7AqVcvFxOsukmZZt5ZkFfcYCyaO8VsYwmARIslbVDPB3djgzOaKQI+9gq84fdW3wwwYjvv7p57BjkF6QhTs+MO22ZkP0DiTixt/ilfOtCJ+PCa0kHbkc4OMaSTxs2qGKaEbjs5Xb7QWR+ZOgyvzv3J0lKQlqFk1gghEeObsJnxGnoLnKqoH2AlxMTOTsgvSRzgNucF4/xGbrN5mj0z46qoUHFdE2Brm+cXqqdDj5vPC8cQTakoamChagfHJJwAHu3bphSCHOoxRlkq9jLE9RYLebtYYbLzMtr2CV6hoMWfzS8OOv5e4cnDSmJb8trZzgFADmb0pAdyeOp19j5X7JYkxNuICZb3F+FeroFJrzbzX4srHJ0w7ZA/PRIizpngn2YXVDOkxwJw+1wnDz4UzTMG2KlVrcuQR9pHHH4Qph0Escwrcaxqb1Q27FsUpawnGo5AfuO/CkX2aBi8dUTXk8oJuUVdO9ciNWVj+4iVdbkoJTSprh7aCymnumAGHfG7eIrkDHFjMSQ3Rn4czl4oq1jyE9t13NEWxb+dueXOJieCOPGUWQD235qwk3sqnunvxTlNd+fRDyj2n++uJ0MPyQx2ZmQmJUgg3NhOIeUbdeBsOMj/rfn8O44ZaPY59a81V6j16RcvvoEEEMLH5niqgJX4x8QOtXJsbx61cai7JIC+TFQriA/9eRU7c0av7PeiiPf5gp1DGZa4PwRiB45gshuPbyhQfYbA5Q1iWqE1adRWECdmjne/1GX/iFRiJb79546M1FpOda4VTHdeTf+RorykYLmwdiPbHj1mhK8XMhM74NXEPde4PdbVkHzqfUOeUTxwtuoAPbyTkeM+c
 S7kxZLq2
 djpQNXuRW/7mbJDSKk8teXj10jPBoKwaKoT7IsCWVOVPZ3glq3ef0Z6FFIIzBLyOTq1d5qmNql8kXeF1Nuyac61qjV6/prGdzNDuUoA7q6ih0x8p/MyqkQ/DueGLDzO5At79c7c7YOVzv13yDEBSjb4wLOnop/r6w4CERzyjR734eaiQRpD5sV3hXrpkyCW3/Vfs9UfDe9wXRXY/et+DWlRyDkGdr7/v0E120D9To02c1wlhVGSQTUZwVvBxsk0EveR3wNsRs3kqFCh5QQucRRR3MC0s2vhbYFgUyyMLviYJO5fG/Kn3wJzY+lT0w3MICzM20
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:41:15PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 28, 2025 at 11:15:20AM -0600, Keith Busch wrote:
> > 
> > I don't think that was ever the case. Metadata is allocated
> > independently of the data payload, usually by the kernel in
> > bio_integrity_prep() just before dispatching the request. The bio may
> > have a p2p data payload, but the integrity metadata is just a kmalloc
> > buf in that path.
> 
> Then you should do two dma mapping operations today, that is how the
> API was built. You shouldn't mix P2P and non P2P within a single
> operation right now..

Data and metadata are mapped as separate operations. They're just
different parts of one blk-mq request.

