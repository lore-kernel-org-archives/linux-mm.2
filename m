Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CC0FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C7C6B0088; Mon, 27 Apr 2026 17:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F47C6B008A; Mon, 27 Apr 2026 17:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409C06B008C; Mon, 27 Apr 2026 17:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3271A6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:05:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D35871A02FB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:05:33 +0000 (UTC)
X-FDA: 84705566946.24.7A561F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C351140010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:05:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f2Yasvoi;
	spf=pass (imf09.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777323932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=eR7WRDEIu0A3ltOUaleJIJZmRlJgFK+aFlYE1BqZCLk=;
	b=vfZkJ2zUGI/fTRtVEkJgpKHW15Nzz7QSIsFjAA24WNZGqM6USA7gznhYqn7+xpgrY6D3jQ
	mQQMI3sytgjS3pIOjIVVYCsVdICANBtU12ZKOLnUY6jOqyrSrVIaB8W70tQsu60qVT1Hpb
	9Smr5D2xoRFXcxXD1OIzGEKsGmjbEgQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f2Yasvoi;
	spf=pass (imf09.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777323932; a=rsa-sha256;
	cv=none;
	b=ztHUamhey1veIOqht1vR4Q9mmJxqbY350M1alj45IdC0/B2At9P+w2U6ZrcHRK52F9AVSF
	FGriReo7TC7+Rf38bJKliMDed/ZYiO9unz7wuo8Vm1l4vyR6imhmqKFLKIWzYj80m7Z4Fe
	Sj4FJE59HqZKitOVR5TTdMUvxNBv75E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97C1360139;
	Mon, 27 Apr 2026 21:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222BEC2BCB5;
	Mon, 27 Apr 2026 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777323931;
	bh=BKvU8n8CmmLGOo/iWjExHY4UTAHtpbclc/VETFqsn3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=f2Yasvoienx7V+cC4PCEeVthUNsSP6+lU5/iKedPkKipBTK3W9hQlKQOizBDpjzWt
	 tmNepResRGa9Robr+yPwMgrRAe7aQXzQ2jhIQgRJwvJEOo5f7UtB42dPaDXfDIIcUX
	 afIekttok4tFW/iR+rCngQveUvcIZiUoA3WIpOc8oBp48Bn3VRBy58KHuIkjYwkEFc
	 ftQaqsh5nTtMk8ievxIuK556Wzq+jWivXo+c6aFEfpXiH+ww+Ds4y1wq8ksZKb1Iiu
	 FW8X5Rtq0CoA/Jo+Rum76rkryfic5YtzKPIShtN7H0Nv1vappKhtvXjZXcsJO2PIOL
	 MZ+Bgj4uYDiiQ==
Date: Mon, 27 Apr 2026 16:05:29 -0500
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
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260427210529.GA186381@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-2-dmatlack@google.com>
X-Stat-Signature: q5834cwh6qyrfzc7saruhsmabwzu595m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C351140010
X-Rspam-User: 
X-HE-Tag: 1777323932-427551
X-HE-Meta: U2FsdGVkX18htZoO/xVmHdvZm8YEsb35dgNAG1Z1MMmOA+UQUoRsooWw6dpnuFPg05oOxR6gOxKHMFfDLEw6uei0LLW7q0qTtv7PDSjSfLTWSlFjqZuX6POLDYtDTSGLC/ejILFaWifJ6VLFrMlYzzv4bix2xkCCbWnhCAL2WL6PbOZyjFlL0Ejid3PnM/+fZAGXlsmeQFEAhTj2gdTYA50mGunWwz16lx3s2Ggomy22dUWDR1GG7UV3kwd1Nv9bCgjUX7og3PgYC4PJr9/LBjUOv1pVyfHFL/dqLh2qE0yyjYQ7rHiLBTAigOSHRXJ6UtOi38q7yjYdDdsgj/dT3LRcLOjO8gpplnlFmKWPy2q6i3eCc6Zt9QP7fPiyNTS/rMieMsfngwsftYeV28jZrV753G+5Eb26AFS739s0LnnEBY6iUWDe9XX1SlY4ORwjoOHpzM6H9+8/sU17ORhszZ4MdPN3wQltIvfCCaofgm9hNCs8CkXoOhR9lK2zbQFV6lOOjl1lg3SsxDfylWl/6MbY2F/EF0NryAQ5GrJKuMuncM/+2JoQeIUjyzvo4u797uB+f2U9ERrdsDmNyIV9PImsSPZlbFZg/Hn5xFPZSaMKwW/z9452dJnupPxkJwV+kieut8cOj5Uk8uyqKcLaNO8lzkEmxZ1mbW2IAMUgtBMSVwx9BP9ycNBreSI5OY4iHUfpeZzpCICP47eSpNViXr+4j14OdgDIa4ctx3YNujVV/Jk7j/DLeRYe/24pRYupn3t1dtsVKtKk54xeJQ9DUku4xwA0GgDEUa28AhkHWbHLrELF5S31zZHlvUR9+ce2PXpFU4FXnhpSZdstp3adlq4OpUNTYoERXZc4JgVl4tAtn2iEGoonRtwDFiqzGniPe3xFVbX6PX3RS/N5+WOrb7JhBLXMobFOjNoLFFNKUeEt2dzDCpqjg5V8Z+2r7vCEFkPPfLmkuaJ/UzmvRBv
 NfNqmOR/
 ze5QJIHYRK4KwkAWTMverAr8CepOI4hLXH6C/sXqPzRlCz2ULQ4jjeCQJWItuE/TcGQ7yUS9gyF5QOOsfSTtCeoqP99zcPVfaFc/xlJR6MSlCjGucvuWYtvR+8kiLp6Pnd/LP76b3o8/I+RYEB8BjIbP+7isN9EJUM5+PyceJkgj7PYSSYU0yBr4uUohyOtQWLFg+oah/hp4Qf9rJCwFnvdcHtDSftdvNTMlMo/KH5haS9gANJzc8g0Ro2sfaLFMb7dJkIQir9k5XbAxKoGWpr2O4WCBtemyZRZFZPCUDG7AyP8N5zr44PvAqrEeLeRX/C5VMG2jQsKcQKvw5G8/Y+/1Ahw89ZBdLVPO/YovL78V8Ya4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:05PM +0000, David Matlack wrote:
> Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> it to participate in the preservation of PCI devices across Live Update.
> Essentially, this commit enables the PCI core to allocate a struct
> (struct pci_ser) and preserve it across a Live Update whenever at least
> one device is preserved.
> 
> Preserving PCI devices across Live Update is built on top of the Live
> Update Orchestrator's (LUO) support for file preservation. Drivers are
> expected to expose a file to userspace to represent a single PCI device
> and support preservation of that file. This is itended primarily to
> support preservation of PCI devices bound to VFIO drivers.

s/itended/intended/

> +++ b/MAINTAINERS
> @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
>  S:	Supported
>  F:	Documentation/PCI/pci-error-recovery.rst
>  
> +PCI LIVE UPDATE
> +M:	Bjorn Helgaas <bhelgaas@google.com>

I don't think I want to be the primary contact here.  I'll see patches
regardless since they're on linux-pci.

> +M:	David Matlack <dmatlack@google.com>
> +L:	linux-pci@vger.kernel.org
> +S:	Supported
> +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> +B:	https://bugzilla.kernel.org
> +C:	irc://irc.oftc.net/linux-pci
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> +F:	drivers/pci/liveupdate.c
> +F:	include/linux/kho/abi/pci.h

