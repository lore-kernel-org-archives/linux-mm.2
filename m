Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CEEFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47AF6B008C; Mon, 27 Apr 2026 17:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F496B0092; Mon, 27 Apr 2026 17:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C396B0093; Mon, 27 Apr 2026 17:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C55146B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:07:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E749401C6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:07:32 +0000 (UTC)
X-FDA: 84705571944.28.7B96FFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7DD3100014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:07:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXALoBTZ;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=w/ZY/a428dOMEzZCQMPOjC/dr2v2uct5csHJwh7YqPM=;
	b=uJPlU+OEa2X4pUBWVv+iPvD5j5xDaP34FfGD4/sPywQzmAhSyfPfxoNqgW5y3+BmM/hft6
	vpyquf6ZVdN8qS45Ozik74j+dcClUq3re5/TPFiDmSDd8vb5cLJrK8OIudc56ZWA1ip91j
	jk6In7p4ZWh7Ooy94DWQ9zBLSiiCvU4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXALoBTZ;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324050; a=rsa-sha256;
	cv=none;
	b=Vj1ZYyNxC0lauN9Nkwz/I4nikfPyGs/YhSIYCTfl8vdj8Urqb2MMzHYXPN7nMMxRUWHx8i
	iXrlKX0PY4QaYUbcbj8E/DAbbEZEsqSLUl3cQOgbKrIi2S8Dl+WZhzN2GKTZr+UcxeMa4L
	85IfPWT0YiECZCvepbRemvyPjuBoli4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28B4F60154;
	Mon, 27 Apr 2026 21:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5968C19425;
	Mon, 27 Apr 2026 21:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777324049;
	bh=eTCpxLZv7LpMubk8KJGg69LwpKjJ4rCvsaQuqSw9Ybs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=YXALoBTZ96HEbK/in8Mcqf+FcEg3cZ5fOQmzXfQw8l37KdDHJKEmdE1SvjbZeiRUV
	 VjQLZPadaTR3oR6VVLBF0kc78fhKbe+XimUyJpt/bNLks1VVxuBNFtwP4Eey0qEitS
	 d5cnToMQIQCGp38txEqfX8AkS3c9uVTSLVP9ETBVw0YALt9UsN8VG7oBDzRgckokRb
	 tVJHOiw5mnG6eLdlPfV7lNskftueKD74BpFt5HaWzYuh4tsk9k1bgjN+gzC9jPc4vn
	 BLwseIuVEzRz0DUfkLvXU9vK1VX7WcRcJJ10fQd2yr6magkpA+cv8wcamZrmJjRPwO
	 QDO5vWHVk853w==
Date: Mon, 27 Apr 2026 16:07:28 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
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
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during
 Live Update
Message-ID: <20260427210728.GA186712@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-6-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7DD3100014
X-Stat-Signature: nigegh7y34ycdk1cfi3xtjpfwazjbggd
X-HE-Tag: 1777324050-726609
X-HE-Meta: U2FsdGVkX18Z0UZn82g4Y3aSI4x3dgzY+6POIeS0V8eovg1J+l1lkBfYDYwK4IUTiiWE04s2IBOPE8pPZTeuVxQz9Me3qOGgF/w0yMHvdMlMZPrqk7fEI7Q6ZdFAm1dhOsJVyR7BqrJhvsDInX+18HnndNzon0D8xRe4x8N2eia78HTQrF9bKX84+X60Cz8LeKpAkHC6PfrGygFSQh5gd/q3IlB9sDIURx9LQAF7QhSEgZAfQZa3CSNsUtJ+eb8Nz1ITWsoesLh5oKnBPPqewgTYOxS/wKZrPCdteY0pYLGRjQGjv4MDx+FxpZ1A9o70WOJK0JaK7PXD5mU5LBHWJVTpb833Na3eIgNV76yzU9i1Z/m6LHMzodY7IUrG+UnPzei9vIsPtP8d+rDpdtoQMwTG2/6L204ysoBt8GNpbcat7a7LSd3rONvYoBlhU8Ub5dmlHqUhDMjDxFqhjrxMTiWBHKTnb5ZD8t2tGGdpKhGo9OrfybqWhWmuFn664GkdgpVe3eV4tTFC9xkZ6LXk4Q6FUh5zdcfbYnV/bBSxpTnfeqqpKdAaggyuqrvi4kp2MNfH/KfaTahWy2Xw42svPulMZEe7BawZgo7WWcPvwTGQUt0TP8/z/a8BD4olv+GXONr3guISwBv/JGPJlJLJIJqwa3G18Mf2CmkA52XHb6T0HG0rMtFxRIet+TYWEp+eefoD6Kl53XH1PCyzPw6yZa4QTr4FOtsj1mtWqcelwbMCX+lSEgHrfw76ygBs+jtlw60fSQmbF77lrZA8QWYq39H8Z+fBcqy1R13u33/wKHZs+FMgTmPDOC2TK7rVg0w6VFqw+DN+N19j8hrX8gJnFaPbKVTYtDrY4cwBwFv9vGIlCWjRm/bcfsO8+VGkj6yN7N3arYL1twp9IybHiDLR7+EJwmjbKLEj9GTohGkCvMnOZA44REGU7517aNDzijxWcRo8sfnAC75/uXU4IBa
 PGyBls3A
 dIbaPg7Bqm610P2hlCZIr4CTkEUUjNnDeCPmNAwfOYK1Ivj55I4a1XBuzji+C24PjASX2k0tB+jaPnUIzyScAlbuqqvWU5zfOm1pu+JT7Bywd90GfJP+JB4Ee1x4PZJ3cx6QFKk8KngV+6/LQKiwhJKfwupHHEFudLSRrJb40ugAZ3VLs1tzai3Eea4fmDBskPjaWawtOFFNHTFPNM63gbONPA1ODqe+Ie0ky4KWFLUN/Nmdi9QN3dXMl7sXlFYw5rH4Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:09PM +0000, David Matlack wrote:
> Inherit bus numbers from the previous kernel during a Live Update when
> one or more PCI devices are being preserved.

> +++ b/drivers/pci/liveupdate.c
> @@ -93,6 +93,19 @@
>   * bound to the correct driver. i.e. The PCI core does not protect against a
>   * device getting preserved by driver A in the outgoing kernel and then getting
>   * bound to driver B in the incoming kernel.
> + *
> + * BDF Stability
> + * =============
> + *
> + * The PCI core guarantees that incoming preserved devices can be identified by
> + * the same bus, device, and function numbers as prior to kexec. To accomplish
> + * this, the PCI core always inherits the secondary and subordinate bus numbers
> + * assigned to bridges during enumeration, rather than assigning new ones (the
> + * PCI core assumes that the previous kernel established a sane topology).
> + *
> + * If a misconfigured or unconfigured bridge is encountered during enumeration
> + * while there are incoming preserved devices, it's secondary and subordinate
> + * bus numbers will be cleared and devices below it will not be enumerated.

s/it's/its/

