Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49FAC88E46
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96FD6B00A7; Thu, 10 Sep 2026 19:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49016B00A9; Thu, 10 Sep 2026 19:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50EC6B00AA; Thu, 10 Sep 2026 19:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5F686B00A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:50:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8AF61606C7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:50:29 +0000 (UTC)
X-FDA: 85199499378.03.A87F0B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 371F440002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:50:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWvdIX1B;
	spf=pass (imf12.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084228;
	b=fyzoEKiZyDGkKDVV+cntGBzaLbPFxBb61JxODLIVSj/296LBiO6cvdkmQPMO5Y1ghXgStN
	iobl0OjaGtXTMWzIRoxKmh+dKZNbF0sbA91Z09E5hb7SYmroARZIZg0ViAK/wsJtYxPbd6
	sl5xinbxPnlhmgogJow6SyWkT5jfbvU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWvdIX1B;
	spf=pass (imf12.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=c7OopUXEb/cYzDlfPWlrvtnzMRjL5zmzmrpAgsq/8e4=;
	b=igXiFjP6isOK8tvuaGtIA0KNIMr2e/AJSrArkyZ+hHqZHznbGZj3AjvD8LuDUKtrjPod0z
	HYd5DJlHEpHJEfcDnvJPxPuLLT6Jkhm0YG2a/vw7WkmzbhxOD3UsDjygXCDSVJ15jkQBnL
	tc4C52SGIV8I2d09bhewHDRoTyGi1xE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD199601F1;
	Thu, 10 Sep 2026 23:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4762B1F000FF;
	Thu, 10 Sep 2026 23:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084227;
	bh=c7OopUXEb/cYzDlfPWlrvtnzMRjL5zmzmrpAgsq/8e4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=SWvdIX1BHb3G2mc3DqyJOJjeon1cveuDPti+i3UgGtydjKjjIuLAZjugxNUQntTsi
	 k7tFsAfMxEDD74cLH2E2ATVZW0vSV7mAZi8xvAU2u/v2UxvgpL1SiJ9zaZfiPnkOwz
	 FlvYWyzKMnXsILexLoAROHTxfm7tg95B/q1KUSnYjg4TEInmOHalF/wvvi2ASprk1o
	 OXiwI6ZzjvtlQrp+guF0OjE8unAGgEOS6gN2HtwPZSxLM/IE4b+fN5mwOdiAeGLFyH
	 aMCTxt7YV/SH4HFLDZzz6tKLnsRLto5qr9a8Vh1Akv8a3F/OwlToXzlyvB6J85vUbQ
	 CbfiU/LHnbcNQ==
Date: Thu, 10 Sep 2026 18:50:26 -0500
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
Subject: Re: [PATCH v8 04/12] PCI: liveupdate: Document driver binding
 responsibilities
Message-ID: <20260910235026.GA367309@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-5-dmatlack@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 371F440002
X-Stat-Signature: mpep785kcqkgmau8q8a3ncgzfgtum6n5
X-Rspam-User: 
X-HE-Tag: 1789084228-286698
X-HE-Meta: U2FsdGVkX1+Ju/MBtyyowRpXc8rmroISWOOb/ogYRDbl2J7izE4jIci21TcyTnR16DO0Kbf+hG1DcJkXM/P7wmClVZf85hWdBPhNAt2EPmxtIs4EfmjNnwPR2IKp1SLIkXkWjgu+ujTvbxzbGE2i5geHGUPcL7yy/EKxcjAKp0ht7pEAoVtKpET46ymIECQnT+juGTQssdK83N5zbH70RsTw7G8S4A76ptj+pYXUB7w36Z2eMq0p90CZ+0jQug6jSRH0bHkqVN3pcOYcZ++qfKWOY3++KzqLl2rtPCcy4kH0jAVpNAWdAtpx4oxAMdyuQG5hKyyF7sCb12cmlKn1RSvJj+aWCl1g+6qnEY6QP9M0LppxV9gb3zkRvvXdFMfI+IZ/YXJrUxTuTVa8E2SRaBtJKNDwww/sM/4fHb/2sGBDii775caMPJuLn5YsauyHOlPeK6MBQ8CCGD+THKAu/Xvr7CplEFIdX5bhIAQ2VuIW1uithp2IcmViF+Zi5EedgPGXknkBQJWaV/u5c5HftmJ/YWhd6s7W0MsTq3cN4tYjJmF/+u0PfkisBwwzrGn6UPCoW9PVKaKSCDDQNyttylRbu4A+6zzjInM+g/IdHYQ0bcw2IeuMFjgSuh5DRXeua9Vb10HzcZmL6dQ4pTYfO2XT9mMq6CP8PKr+uiUJRIpz1Jk3vJAY45HRNQbtlUxqxi+ra5Ey5+lMFEfxGO2YkDl2r/zQtrmxYLuqg6CXDC+r3FIQaI8qTAA/VR+v+zNGPiVYhp1CLp2PYxRnj9LQIEwL/PTmYZHyNT2MIM8S4WhV+TkoUniBUtlfpZ3ImTUd8JPNn1Fr35KqqDipPXUEilCdeTsNi5FGkGaWGDRckPAaaFqCh85QqJNvqolujhisxMbB6kHZ1zTUsB/nE7BmCTyYWgphq18oGLCgDbNSTBKv7/r6ozH5B0Dg03/XTz5gULDRXit7ira+zHXjDpl
 Z3KzkHw2
 WrtLKIGSl3fN/kvc8h0SY1J5PSUp4wfo/OIOmJ4yKEPibtraGX7tDnqtonA9vLUK3VyMvrbYh+v6olXI5iqjk/8Rt1d05Vf2dITE4ZVuij/1TAyvTBhS1JF/bsjXUEFILw5psb49mFgC+4CvGrwLVywXIUS1NsQM8YxjaNrs+RRL5OJLohvP5CVao+Nunl9OFZeMhxDapYG3FE42U1e925u0T6j9fUXb5811CGRwzOf3/X5QAJHKOOJHTe5s8/AisIZ19ulghmhuE0y+hOgQH4QQh6sT/x1Lci5d/sJpLfpwZigfcr7q9Z/Km6a8TnAnwUHpllSuUrDN+Rqq6xurbgEyvayslG+t48F7zlUwidoxUioI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:58PM +0000, David Matlack wrote:
> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 5ce5f8b36902..0f7a018ddc66 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -71,6 +71,22 @@
>   *
>   *  * The device cannot be a Virtual Function (VF).
>   *  * The device cannot be behind a PCI-to-PCI bridge.
> + *
> + * Driver Binding
> + * ==============
> + *
> + * In the outgoing kernel, it is the driver's responsibility to ensure that it
> + * does not release a device between pci_liveupdate_preserve() and
> + * pci_liveupdate_unpreserve().

Possibly "the driver must ensure" or even "the driver must not
release ..."  Also could apply below.

> + * In the incoming kernel, it is the driver's responsibility to ensure that it
> + * does not release a preserved device between probe() and
> + * pci_liveupdate_finish().
> + *
> + * It is the user's responsibility to ensure that incoming preserved devices are
> + * bound to the correct driver. i.e. The PCI core does not protect against a
> + * device getting preserved by driver A in the outgoing kernel and then getting
> + * bound to driver B in the incoming kernel. This may change in the future.

Same "i.e." nit.

Not sure we need to be reminded that things may change in the future :)

