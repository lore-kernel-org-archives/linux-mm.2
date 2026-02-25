Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EA2FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251696B0088; Wed, 25 Feb 2026 17:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E42C6B008A; Wed, 25 Feb 2026 17:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1111C6B008C; Wed, 25 Feb 2026 17:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F31E16B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:47:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB8AC1B7140
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:47:50 +0000 (UTC)
X-FDA: 84484467900.15.17DBC44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A76E40004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:47:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KN3WnNG6;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RWJQBb7FI+E6UXTMK0GR6QK91Ndc7kSh6Tn7RraZLas=;
	b=5v4LCq4BJ2YIrxGcWgrYgtPjm5U0o6JEvXQGqd4hvuwrfmxEr8qX4BJAv+hIz+FR0Bcdwc
	17IgMWzD2xpvjZCt58pZpT745d6Nagj9C8MGTYpBoPLtX2SDSFlgGA7rGmZhL46ctKOIRX
	RIX64hRGswXikne4ELRxSt4fCfBP1rY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KN3WnNG6;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059669; a=rsa-sha256;
	cv=none;
	b=lPcWJmdjQfpKy20yBw8FCy8RcvOQCv74TgsJw3Dxn6ZEVrauMa4JYyUI6Cwd7gpKD3JLcz
	qyyX526XGpwvkmnkCafwfRzZf7YHGyizLnKaS7KmzsiPlUxFSdZ8WCgSZYH62aM+l8+v3x
	YHh/zyS0Sz1fhab0Zr2kHqTi3obRV6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70D1B60053;
	Wed, 25 Feb 2026 22:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB83BC116D0;
	Wed, 25 Feb 2026 22:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772059668;
	bh=xWdLF6QkhbCc2tLcZVVjn/HGUxUqWIXlhi0KcVCVHrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=KN3WnNG6ESqaiUtKkFDTZzH5NwOfPaEq3SyKjlnj2BVvSVQdzrUGi+rO3bBGnd9Ho
	 LpbZbnimfO8+EWuNKwp9Kq/5DffXALvIy8g8aExAHiolfdguYmdbVu0XP84pBoVoDG
	 2ANaWg1zO/7DOmKgmZKDkcv1ZqdjQpAE9igTSVdboUsROFqdafQ4Ta1ZmMLSBkwm5g
	 zQZOt3jfGQKtw6ZQ2AYAzx6QVBaEg7bthNexA/udyyfyBqcl3NkKXPxr3odyqMidAa
	 N9Jhv8lkZdyJYuDO5Mg8YthFxaBnptnFCNCrWT2+YaGtcpTMCUtsROxDVq68gXD+2b
	 uimsyOI0k4irQ==
Date: Wed, 25 Feb 2026 16:47:46 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260225224746.GA3714478@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-4-dmatlack@google.com>
X-Stat-Signature: y5in9c1u66ni6bu4oofoj3ox3s7wpeod
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A76E40004
X-HE-Tag: 1772059668-190482
X-HE-Meta: U2FsdGVkX19cG6qNNvLGIWpP30NzMV8bHehrMh/IfbvChPn8ZuVvH3xrAnV3M5kEHZmQNsT76cd5ToNvByS79GcIMpVZqReVaPss3hOoxlyjD/BJbJR0zm+9ThQgP00FcW5oRsTco1sOzc8nTYC9NGhaDE6VLv1231VTsxZZ1LI/hWpwC+Tmrm4vTOdzsja9udqxHQ/++UVfsBwj8+iJl0Gr6AnF0DALxUvr64ctNxwPs9d428k6jEuNDFW2foKk3duQANpcBBNPmD9tDL3XSBJo/P/ViJyQDv3kMN7m6otU8lEy+DpLLTrjDN6KHQULaIzBpikMze0HzP6bBpSyVqvz+l7XeP2oo8+uxdqr+7/zwRzMU2zYHj7vOFHYkwbGEepFPwpbOUmPvBZDdGfXz7Y9wFHxx0+zR0KvkIqnsE13lSWRkHAkObVxn2Iy1ENhb9lLeyo+Ks54L2o5XWjhqV8CDN12BiKxKkCILtRMQGXIznsDPynjgLcbfOWruc5cbSvlGTruiJ9ahfosXyvsO5Ru9zaik9UXEGiy/BM1+Mmy2tw9RzhjIC+TjJf/oDH4zYcmKvgnLbSqMlOgwHRJ0CMwqe62UZlVXuvv//z/7CXSvSAOGgJlVpmcU9pgb4FGo92Z3u4QCpcl8v5mmd0Z3vM4LIBA+GRFiaICOrCaIX9luzv/tKshafY0/Fjr3y84Y/Efw9C9GmmqVz7Axogvn0i1jVqpcd08lmgpQa62SpzV8UNHaibBq74s8jsp69cmWp4YpLce5OT33rz15AlXMa/+NCb/lYlA1MZe8fnKncZZvELce4f8mgulL4aR4WSdgOQHkcfLhhuO+Pu5A14E8O0ilSYz5imGB8CeFGxZFPmv1961AzCNMj70uV+ok9mgWHYhqBf7GXqygecSbGYfTCq6o/kY7A4/YQaZEn6YWwsqLkVoi4YRJxrviWRT6WgjWo0W6FC8+BvjzbnztOr
 iqNewYT8
 y5RC8CS7o34b9eXXsHRXHyVcL3wWTKLgIG3cudV1qvpeLbwHsVcJzLwhY78RQZ664Gv4rY/SjGn6HfDE0yvH+BL/Jy0Zb2QZygee7Q6gBa663nQO8iqyy1NaLJptQv7+Mv8E9N7BOevHM2voasLJkDZdvmDCPn7M42Juv+UBhLkuMIwc6OZBLu9naiojMy0/5tNS6cCDTAcffGnhhx+OTWrUIbz6dEtsTirbGXpjI373o7ZHNL4eIhjV1GWFN4zflC43E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:
> Inherit bus numbers from the previous kernel during a Live Update when
> one or more PCI devices are being preserved. This is necessary so that
> preserved devices can DMA through the IOMMU during a Live Update
> (changing bus numbers would break IOMMU translation).

I think changing bus numbers would break DMA regardless of whether an
IOMMU is involved.  Completions carrying the data for DMA reads are
routed back to the Requester ID of the read.

