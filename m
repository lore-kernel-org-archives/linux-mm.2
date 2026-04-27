Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFAFFF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B7B6B008A; Mon, 27 Apr 2026 17:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9636D6B008C; Mon, 27 Apr 2026 17:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879816B0092; Mon, 27 Apr 2026 17:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D586B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:07:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 256AC1401E1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:07:04 +0000 (UTC)
X-FDA: 84705570768.27.11B5F22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7091440018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:07:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFGNDaTG;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=NSfP7dnw2gP3DlZMyk6kvLJqbY+uoXgiA8d0A2mseMU=;
	b=VNw1gS08oPQUj+2R2dKRidEupmujr+VlqsEz6ocZ84HQVvJRuoW5tgifr8ulGwQ2FLqAHN
	lEYmuzHJiRQw1/2a9BIW0wf2CFSWDW50z2W9rexXzoks4AD0b5CvnR0c3syzcAYpfZwl4j
	mA1B0uP3LyIF1F/pcfwwGJhyvq5GZCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324022; a=rsa-sha256;
	cv=none;
	b=m9hr1Zhasy5RZfU5n59Heefpghj3Ec3SW0HdYHkuJ5aCYsxHSQE+tFXOkDbwfKDhpL+Ogh
	IcckMfJCM5KxL5zbVrA6nl5Sp0JjjtYAMOmF72CSiKN9JfdC0COZppbuTPuiFMUWNqaWEd
	g218abSRTTbQGZ0aIvxrT2HhE8T3yQU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFGNDaTG;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B55A40667;
	Mon, 27 Apr 2026 21:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11644C19425;
	Mon, 27 Apr 2026 21:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777324021;
	bh=Ji6QG+tICOp3jZRjVIPmRNoeZX3XNm+1s3nZGqpXmws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=QFGNDaTGW9a6kdfYz+Q7sP5WR3ZkbzEL1ZCMz/x/Se8P+hqKd3UU21B0gzVx4pqBl
	 kykxyVYNOR7VMHGZ+ds/id+OC9sE4OJiDDrLvBJuAtwrEL/oYKUj25SReZiK63RWqV
	 zqLGHgGm4CQzNaDmqo+Ta83Ay0qv+7jcHNQkaY/6E5JQ9nFVjxzjC2iuYoPQaq1/27
	 0XleZbQtLDheHJpPJP0IVRsnCI+hQSiEFIetIZfoCYJn1sRQx3kn2wlhuvPKWYM0G1
	 nI8/zJ/fR1QDFe6OK/JGPNIwx73t5SJiu7g/Tn0MksDCYe357ycHL/XROhv+A4Hhfc
	 cSXQLsRyl3SJw==
Date: Mon, 27 Apr 2026 16:06:58 -0500
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
Subject: Re: [PATCH v4 03/11] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <20260427210658.GA186673@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-4-dmatlack@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7091440018
X-Rspam-User: 
X-Stat-Signature: wssq4z3crjcsrm5nb759mw7fp56bw5qf
X-HE-Tag: 1777324022-368153
X-HE-Meta: U2FsdGVkX1+hfl6raZ20Yx5kEkAbMAOypZbOCWNw/o5L8pY2N3YBIk6ioy4mcVWpeMQfcGDfSGz5q0bS5SjprC32sUbUZD643LwDuF6KnuOmGBwxcyRX+ON7sIP5uKqFhi3ocJ3JJTPZytbbZOXPDydfVhImpTgXV68TYiAQ2gbgmHr+OXz9QQ32TprCsJ7NGv1NFUi9fMyHDXkaKcXIEf/u05tur871SSZxxF61XhkZ3GmuGT7oKCjpaG9g36oKcbKhV+Lea7GXC4LQGH5zbK+JCkMTVJqA+D7HTDRyGhIFpjIQAmT5UkP2fa4B+NnFdHkoptK8xdOXH0bE5Ql2ZZvtSli7Xx8/tXqEAi4t1kx1hTy+9fwCaH18ctviyx21Bh5ge2LEkhhelhxw8FHP3d5sAdmQf4Ie5BUgmc9vZj6kf47wfD7tPpYR7+7XF0BeIyeyUU17zPaJmDKYNF8qxRoo1FerZWeLEBV/Q8aTu5cNKPfvV2ImbKpDYvkd755Bm/6Hk4rkTrH2K2XBa+aOZsKnqvjJN0Rw0DWGr7jG2Ghdp8NlzrLgtiaEH8/QK4RAsdoPAcbNp2ZFBu+0pRDdbcpuKPJXkx4MVnLoW53f419Xem6PU20SRI5Ld8qfUP5dcLsTjACcz11bV3CIv5amPfL1Xz0MHixJw0XgPU4a7bWNRsNFfTyXxxKjrsfEIv6Vzc/prVOtjcTdXO7vgn8JyvAtNHenftXsBbvr1Q7pDJ6NYuzCaB2WgDEJA9aKPBU1qktJG7Ez3qG6hHikHTCSLteAtf8YktjBDS9F5R9hGXpD3hcZH8C6TZCpyDC9X1maDVKCRJ8CKnH09qQL9A03MMRzwmLBGGr3qR+S2uRbq1pM0j3JXitT3lL7t8KFb8Sa8Ql0PuGThwSBKfZfv918C9ZKRrWe2/pferwUsMJLIjGxOAI3c6iHkLLG1Dc5RuCYufkwmnOvl+GpI8wP3H8
 Dkewu6fF
 rYdjERqZ16OUygmF2IddaL0ybMs+DDjaVlaRqum+DG+2ocaPGxQGO8dD7nXYCKqoY9erQDNGw1Ug6XobybaJsk2mUGQd9ksYmB1HXkfeEt6ebkaC7GoqXj+YkJqLb6ecTaUwp/WtXAZSxqYbLwssfrzoIwhACd5Zbe5XbcFrwjACtqjrubdDP32lYVsnzBphmilpbxZr6dx3xPP3UOx5zB+/+yqZa+0CWZnfKz7JyAJ8b3z5lkLVVEW0xMYcxcH3ReFyF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:07PM +0000, David Matlack wrote:
> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.

> +++ b/drivers/pci/liveupdate.c

> +void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +	if (!dev->liveupdate_incoming) {
> +		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
> +		return;
> +	}
> +
> +	pci_info(dev, "Device is finished participating in Live Update\n");
> +
> +	/*
> +	 * Drop the refcount so this device does not get treated as an incoming
> +	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
> +	 * again becase the device is hot-plugged.

s/becase/because/

