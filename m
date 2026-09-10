Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B30C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBF86B008A; Thu, 10 Sep 2026 19:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DDB6B0096; Thu, 10 Sep 2026 19:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96736B00AA; Thu, 10 Sep 2026 19:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB9816B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:51:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2862FC02EC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:08 +0000 (UTC)
X-FDA: 85199501016.09.51FE4C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93DE4C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IznEg/t4";
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=pjUssxhMj5FiuQOqeJ/n4B79y63VUeUxlyscD8iV9MM=;
	b=lO7068bU0RkYPXKzisrUNxAm2o85dIaUYMmOyKLs0JVvAmslu6ZgYfyPswLL3RbDUgSFzy
	svjyssz6ea2i0JqIAgpzYh9Qj+rKKYWoqBHWsAVaQSrmPHNrsiETb5PyPO9XyEshFiLz5b
	VfpgNh+60eZCf1XcJv29sYLLZhHLb7A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IznEg/t4";
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084266;
	b=PBrxSX9qAw4PtkZgY7ez2zu9lz0iQoiMV1rxJK6l8Ipx8V/Uj2AMf/UKqJTFDkTco3rYnB
	5fopDLvagwY89YUucRa3AYqgMPUcX38fqMbUQX71c7rKyduejFiEpQ9TRhYSBR2g3zfFig
	Fsvnvo1YE9R7HpEVGzQqwyuDCyKXJ/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28082601F0;
	Thu, 10 Sep 2026 23:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60C01F000FF;
	Thu, 10 Sep 2026 23:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084265;
	bh=pjUssxhMj5FiuQOqeJ/n4B79y63VUeUxlyscD8iV9MM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=IznEg/t4Jbqs1UnWZoYfs2SNW3eYxJii+gRGtJP4RK3+MXWvNQ7U+9BvnzqbMzdzT
	 ktVLA2JBWKXNKxeDF0IO7dl2nkvPyPHVCzNZM65lubpANrZVz8x3X8eVFjMA2FNHuH
	 qfcGcn33q7udgEPWa7IiDEcY6rFx6R1pq/XJFN+iJQN9kbOzvKIAdtN0ScjUiT5Df1
	 XWw3ZH6CVphruyylZpeUfVYU1Jy++RYDvqFhgZaA3oz8NNVWUbqCIcETZ9z9dBjZKI
	 APtOSYggBul3/7g6jkwJH0gWfVJFyaZ4ETvhBc7Ofpzoq8oNY2NrkmnC8HokuoY4B7
	 QxY+gInKhlK2A==
Date: Thu, 10 Sep 2026 18:51:04 -0500
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
Message-ID: <20260910235104.GA367522@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-6-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93DE4C0004
X-Stat-Signature: 8cjkyuifdr4uj3zpcxo5pzpyqxzr9jhp
X-Rspam-User: 
X-HE-Tag: 1789084266-525256
X-HE-Meta: U2FsdGVkX19ipr2Y23TQ1hNWLIop1nvs6jjlruqORS4+D/CwOkcFKD/KfdseaHvUx5AZHfrrcus9TeBHUlDmvldBU19MPpuJT2jiURglt5reDZRJcW1DA1QgrKTsxcKtVHAM2EKbN4ot++Wly+NLKZiUfIpKrYsV+hn6DsDTvViIBN5/Bxfgx826hsJfd0fafZs83WAqo+NAUn6CCbYZUqYH+G7L0ENddKpHwNGv8xthLgju/K57IvTknllWpcVlrykiocZzV8LhVUDUY6LPmUWaQPkVZLyuGwIrcWdd/eG8b4fHKTGMze6/Wri3gtrEUjF2akkmFXeVCc/9rwSgfrIV1DXTpNcokwA1DbkZiMgae8BWk1CrTYa3p9EyBMoVjN0d+xTNmnm2JiSZdmUwIpvDSh7nPSiPBRy0foeng7/idwDfVC+B3bm+w4tEi69JjxusCY0v713WMVd6Dapj+mtnxcDSL6AOvPT/x5qnDOpHorWnVwAANm9WhACNlQOJgMZ/h2yRRndi8oolK6zDkz+FaAfkuItySoYAaRQmFhTSx0g9OizO4vrdDil31pLH3Pxfnt1aZB0E+rE26OHj66/urE4JyQqJhgFr3ym1Z+Zt1ISZpaLLTGoULlwJpnY+e/+REAL8oFCXey3WVMgtqiBJHq7PP0EQETd2WyFDBEISKOcT3r8iVfCgDc9fQBxe/SiNfYTtZSuavkxcYDu+xvnZLF8+xwaVqCME/d2UMXyCi/iunfb3MpcUJ11GRAmOZWOP9cYV5BWY5Q60gTytoCJVdzK9OIA1yuBaMJpkNO6sKvbcNYYlFxPP/B4dIqytupb4aAz9za2ftTrBO/8YJisac9xS9lMKhFS+/NuXXizaAlvzlzz6EtTRArdQ2XCkaF709mqeG6Kkj8YUHWSw7yXCqClb7aNEyPO2NlZUR+7eZAbbfN2I7rWtf2oYivF7KJbPchsUUPZSDNHIHGg
 U7roSwCv
 /IVbWVrpFEFAbUOOjiuWrUxgcQHa4paRUVEQJknSc647nDo5zfacaCGMC8jLJOTY9Ti+0twbYU8QGksq0voKnIu7fFSipEZPf+64xddk6OJ2agnv7qFUR5Nd9tnqJVH0P1kZ4Ci1R8abTGpYdIj3f2wm6KRHmb0OOP2jW/UfkOv99ZDblpWy0WlX6uTa/3rY50AXcsGwV1dfBFJEMYA+C+Ce6bY2UjlxMSJzzNdBViSgVSgaFS2tbqPiMjdQ5bn6wjX5g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:59PM +0000, David Matlack wrote:
> During a Live Update, preserved devices must be allowed to continue
> performing memory transactions so the kernel cannot change the fabric
> topology, including bus numbers, since that would require disabling and
> flushing any memory transactions first.
> 
> To keep bus numbers constant, always preserve the secondary and
> subordinate bus numbers assigned to bridges during scanning, instead of
> assigning new ones, if any PCI devices were preserved. Note that the
> kernel preserves bus numbers even on bridges without any downstream
> endpoints that were preserved. This avoids accidentally assigning a
> bridge a new window that overlaps with a preserved device that is
> downstream of a different bridge.

> +bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
> +{
> +	struct pci_dev *parent = bus->self;
> +
> +	if (dev->liveupdate.preserve_bus_numbers)
> +		return true;
> +
> +	if (parent && parent->liveupdate.preserve_bus_numbers) {
> +		/*
> +		 * Preserve bus numbers if the parent bridge is required to
> +		 * preserve bus numbers. Otherwise the PCI core could expand
> +		 * this bridge's reservation beyond its parent (which cannot
> +		 * expand).
> +		 */
> +		dev->liveupdate.preserve_bus_numbers = true;
> +	} else {
> +		/*
> +		 * Otherwise preserve bus numbers if there are any incoming
> +		 * preserved devices. This ensures that the PCI core does not
> +		 * allocate a bus number to a non-preserved device that
> +		 * conflicts with the bus number already assigned to a preserved
> +		 * device.
> +		 *
> +		 * This is slightly more restrictive than it needs to be. For
> +		 * example, each host bridges have their own range of bus
> +		 * numbers that won't conflict with other host bridges. But the
> +		 * previous kernel should have assigned a sane bus topology and
> +		 * it is simpler to just adopt that entire topology.

s/each ... bridges have their/each ... bridge has its/

It's true there should be no bus number conflicts between host
bridges, but it does require the domain as well.

> +		 */
> +		dev->liveupdate.preserve_bus_numbers =
> +			pci_has_incoming_preserved_devices();
> +	}
> +
> +	return dev->liveupdate.preserve_bus_numbers;

I'm not sure why you don't just return
pci_has_incoming_preserved_devices() in all cases, which is what the
commit log suggests this patch does.  What's gained by all the logic
here?  It's not like devices will be hot-added during the kexec.

