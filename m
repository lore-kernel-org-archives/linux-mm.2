Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2CEFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45586B008A; Mon, 27 Apr 2026 17:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E436B008C; Mon, 27 Apr 2026 17:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A896B0092; Mon, 27 Apr 2026 17:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C66C56B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:06:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 587D11C042A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:06:19 +0000 (UTC)
X-FDA: 84705568878.18.F04A886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CD7FAC0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:06:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoNJN0KK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777323977; a=rsa-sha256;
	cv=none;
	b=52GEojqbvWQI1+v6XkECNwTX7j3fX5bvs5Y7xg6hxkoAj++Q0TAMYq0t7YcpXW/Mf9zSgS
	SQIqwiyzgYjeAb5VGovAPMFdHAHwSFx2dHvFTAmuFaO4797gCI2VJtdabo2bP2Nnqto/Cp
	9xciv+6Rzf/WMhsfm0ZYfPXN+wl0ReM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoNJN0KK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777323977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=hgHpiDOCUudw7O/cEVLVNH4ElJQq9HH5iQOKl9zHxME=;
	b=GFcRb/9g5P/xPge2ZNhAX66D1uktXo1TT9btpey700DnA6SCrTyD3V9vpswxbxct6dvH+F
	DBKWZP/TTkJA68RmXSeuxQtU1ZgK34rs1xt5gcrxF7BB0JSJ47QLdw0DhwRP0Y83pcmM8E
	pzdE/uYxtO4nwbAZoOW2Ez6gySgRmBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 332236057A;
	Mon, 27 Apr 2026 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4DBC19425;
	Mon, 27 Apr 2026 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777323977;
	bh=CIswUHjtV6oSUsxjeWT06cacL6KEcFHO+pUSNAd7kso=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=YoNJN0KKRc41UjoNkjKTVxHCQ9uHmb1vXRgaeoA4tQWz/iAKTXe43aboUj7ZhDG0t
	 grNENZpJKNHzFBJy7Y506+AuuCHjO1qZfDRXYgBS/0Yw8y5dlIOWegmRBKPba4bB6Y
	 5VcibMz6TPsiqAgZkvXp2IBx61Yw3YfO9M4cAandeRfDj83rXbzcmH2WqXx6KVwMY1
	 tFRBliyM+9VjS8JW20gNO4qb1z7tkpfpIBwBl3Wh8cGH9NaUQh2VAbsD4l95ckOfFr
	 7cMHIO7JOZkCSv8VfoEMbGIMwpAhmicK4vHq6YczTKvrrB2AuD0Nao69SvIM0v/DRr
	 xVcZfTO9P4O2Q==
Date: Mon, 27 Apr 2026 16:06:15 -0500
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
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260427210615.GA186434@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-3-dmatlack@google.com>
X-Stat-Signature: dmt7tbf1e8mj4mc5twjoggx7r8qbakk9
X-Rspam-User: 
X-Rspamd-Queue-Id: CD7FAC0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777323977-836466
X-HE-Meta: U2FsdGVkX194nod70wuoZsjtLO/H5VtP4miC/o8cnvrUuam6PdEppZf6lYGA306NgrBCzA3u2UHavjrvzKrWq+aK305RwmJ+cIjhwN7rV8ngembJ5gpiCQYCUKDGWJz5arMhmhH6u2g4oQx66eX9d/j3jEdj6RirLDALNOXOa27tt8m/cet597sT/OQ/C1g0cl7uK0eOiBhSmAVBPFhB5jQyBsuEQHWnV8lfN47dw0/rq4mykMOLokLCygm7vJtXRJhRpN2851EA0AY1YnMQe19f4UmRjmwRP7LsLN8m3HuK9w6eEhLOZCiFO1DflzKipajSnfLmdOS6Kp3en0Ylroncv/8Uc5jsMr13kcyM2EM7Zhlz21KQ2u5kMm3RBEfQFODmJ6FGJCZLhY6mmM6uxTlM29m0pezt3879uXqaUGn4VIVCRUWgaTh2F+fcSUMCYtzqWLj3OwlrIFyvsO/sWigZkHrIHLB1ljnf9pv5wZ4UH/4GJd7L9vIiLG/Y5b+hT3QkdXSrbDZZmRvCGQ9vQwWH3p2lTpkKJhWbrkjVA622MN114AEi1o8A96RNaqAKR34ekAhospNbP6HY3Lt9pCTWeRCLpbxFMV3JZFCD/K5im4ZueSLNPIZtB9rb5I8C7txAJgaN2b5dnuzLZz9yk59fkKkeVyiHv2GnjjSvla7m1/VvodBY6IA66E+Hk05rczfn2zj6PaBjoZzIQuQPiQ8sD1hhNAu0TZ1No0oTjzkC9UgP8D8z9wvfetUtaQAaYdOnExJXXMxS3qlIsB8XmibmRkF2tKoyEwkmDEMr6Y5VIz3bgEZSaSjhF1MX7if8RRyg4Ywzxx71PRQQnfny78lZLVFhiJyjkrUwtVaHUigc2kTI0k2ImY5GjeRTvCuchGZe6BoPzF7MjwNUsCoPud0iUgURzzd3GSKtLZaDM/tdQWr5vWuEpDBJ6yLOK5PGj9t06ShEnKUKpNVBQEp
 bFQSP+Di
 aVB9Ep7oY1CeRNBFllTHbZiFDzxykAJuuk39Wzut7516yjqEFiuxP9raCtZ5W6VxVVtAO8Wfk3O/UwTepxvvHUUbPVJvVecfHtg05Z6BOcXWofrIfEpXmDP8uJ0M7hJrzXTL6+4+GqTEU+N1jelbsc6V/EzCtw6S+ShN26p1fExUUGH1GWAPEand+Vrp466bShWEMx8Fux+6iGDH2/guXHoGUetw3dAzCcIGzQR1hbihCdjoegzOyN+kGtVoTGfLROjMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.

> +++ b/drivers/pci/liveupdate.c
> @@ -43,6 +43,26 @@
>   *
>   *  * ``pci_liveupdate_register_flb(driver_file_handler)``
>   *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
> + *
> + * Device Tracking
> + * ===============
> + *
> + * Drivers must notify the PCI core when specific devices are preserved or
> + * unpreserved with the following APIs:
> + *
> + *  * ``pci_liveupdate_preserve(pci_dev)``
> + *  * ``pci_liveupdate_unpreserve(pci_dev)``
> + *
> + * This allows the PCI core to keep it's FLB data (struct pci_ser) up to date
> + * with the list of **outgoing** preserved devices for the next kernel.

s/it's/its/

