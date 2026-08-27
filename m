Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F25C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 21:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139746B0088; Thu, 27 Aug 2026 17:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9B16B008A; Thu, 27 Aug 2026 17:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000176B008C; Thu, 27 Aug 2026 17:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01336B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:47:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54CCF1401D3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:07 +0000 (UTC)
X-FDA: 85148385294.10.713E58F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CBF4220002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOnm5D+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787867225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=tviM4X2nvvvLqMpeuQF9l7koJaDMsc88vWcy1La/8as=;
	b=MiYJ7h8tcbJlEW0pBVjMqtykTC0HBXM1RtA1g60QelCLEP+lLpAsQevJLjlHNvT3DOO/3G
	HNFgDgTWsna6T+8UTHMeASPY/aA3wsybLwSYu3JfZXcRrHT5kY75u3yPyk+Zf43oV1OPCr
	+8+wS9mexLvgod/Tcc+ogZ4F5L3yVng=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOnm5D+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787867225;
	b=zc+fTHQ6QFoOCqHJ2cxZCslA4odV+twmgdIkHXvDYzKUCThauXpE85fjuQLrEHBXONJA+0
	Xz/hoICFkF9y3hdYUXyuFKvD38XgmsnjtyvEJodjm9xmJF3id5QxXHr6wSn2mH8DbTDPSp
	JPz9X7eHi2Yw4HQ7+6jCnw7SUpjR460=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73D58601EF;
	Thu, 27 Aug 2026 21:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5EB1F000E9;
	Thu, 27 Aug 2026 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787867224;
	bh=tviM4X2nvvvLqMpeuQF9l7koJaDMsc88vWcy1La/8as=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=OOnm5D+NhalAr8wIMcxMKb6VaxdR7MfXZrVr6waUND5kQ2IBfnaKblstAaUWXsZHe
	 yJ58QN3mCNgHX47Xtk9I7+p8DaT5sTD+VexFUJkz29OKusmhRsdT9Y6VngaWiB8PbT
	 VpiDPdcqlswFHeb5OZtylVmAX7ZxuZ0XmxtgOBj5/zvvfW8SnDc8MfF2A76BSFlQle
	 7Z1/avFAPLYTtPBdj3MZUI7cVEn+IB1SGbyKfXlTbzHSrtPHSPgNLm2y8ENTkPGjnu
	 HGpV8OOhAKSF7sqEjYJ48iGCXGgk7gTdlk80vG0Yi5u6Ioi8YHNuzvyVkKeq9Z3Avi
	 OoCVbShyvHzKg==
Date: Thu, 27 Aug 2026 16:47:02 -0500
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
Subject: Re: [PATCH v8 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260827214702.GA1636952@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-3-dmatlack@google.com>
X-Stat-Signature: sfjyafu8t58is67fiuhkrej3abkzqkgi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBF4220002
X-Rspam-User: 
X-HE-Tag: 1787867225-556826
X-HE-Meta: U2FsdGVkX1+IWMniSknItZMz1ji1QybK/bhM3VCo2066yc5tTzQbNflIj4FwloEB24MgpEDYjWSYUIg911klVSU0Zmzqh7PTfvksOmL2X8JLzK4mGQfPsjbnH4E6A4L74Ab8xrmHMiQ5S0e7CnV99olOzlStcNJs2dnILD3eNqgIEqJGAVecTLQMlLCBUWFMxHXaPSmtQ9VtucO9ZyDUdLeeVfMCsSZY1pfJyKse6dKDtKEppZFpnkQCeYKE2KtTeMPwM6QplCXMbBb1JEZvPExvQ+ay2mr7QU8N9bGb11CGwRjl2AvRo64h0wYCf/lx/I7Z9bMy93DT7a11HHjykC4hjMWkXXnN/jInBOwhENUfO2JKr4oO1BR2ipWIJMC39eBwDKG41ZVY2lWJiY5W0hUBLypYwRd1R3H1ovglnTQAZ7nAtXDL6xM2zrgCuMtagBNvH+idJqkXGkaIpV7YkGae7JmALJJja7Bv8fWZo4pGTCB0IQ5Hl7BNAvRDhvhk3Y4b2puYPNiyQ3FbOFKu5EVD0dUlScINcDPhGX0OrAENJctMfkGq8+d3MLruxcz34rvxm2tkfcBxAMKQOc2On6OWx5FNMX1qTSypwkITX7PiB7i8hk0fMgeHDBmF3MrcvxAHMuSP5FCrxuWYfwn+2jUZFNnq/l7TGT4pCMaPQVEK6qHmyp7hHi4u57wGG4aR1avcrTG/2Npz2OncKevLqX1UtcYV0G8MxFgwIT7Mw8/HWZ1Etx45QnCnB/U9oszHdZA9ooOSP8FwBYKdGNVb9givvwjUQSm/1inITXYTjYRiM1zTbZsloGSALuAJUudmW/RgcXLw+q6IYunnuh5F8MQKDxxsq/5KXFInGTLWcZYrPinRpeiZE6KkIJE8B8O0BAEmLeRn887ssDspbiJniDqutuwm9UK4YNBzkmWouEgt9jw9n/ZPMvOMRqJZCNh68Hm0mxCADYxdRo0Gjxa
 MMNbLIH7
 S4xfIsstJtiby2rWn9xYQpEb5dPCVmWp1N7cqYUmkaJYga9zNk7rLOOqjTfYiQ5hcfR7f9ddt4ZBK6fAxmDPr7GY3xaGhz5ZCYMpIKFcMUfbqxwaZgQe1g8TjCW1V/ejR+gm8akhl1p633Nm/UO2FUxbpy2UZAFR4Wqjf+9CG1X+i2JiPMRFqciUWj2kagl7uE+QexunGOGo22NiOYGS8RBJsAdUwP7eZjC7U/2Z7VUX01tlM25dHywhHe5dQqnCQ5K0bg9hEWWXInElnQM77fNURokb7KMR2QsvOgg0Zx1n8nlZNIQigAmFwvNwYYsR+OIsaeEpU/2sjJ5iEQ6gWjJDCZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:56PM +0000, David Matlack wrote:
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
> need special handling during shutdown and kexec, and so the list of
> preserved devices can be handed off to the next kernel.
> 
> For now, the API only supports preserving non-VF devices on a root bus
> (not behind an PCI-to-PCI bridges).

s/an//

> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

