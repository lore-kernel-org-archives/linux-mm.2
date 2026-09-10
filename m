Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E8AC88E45
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76FE56B00A5; Thu, 10 Sep 2026 19:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7192C6B00A6; Thu, 10 Sep 2026 19:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2026B00A7; Thu, 10 Sep 2026 19:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3181D6B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:50:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFB63140610
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:50:00 +0000 (UTC)
X-FDA: 85199498160.18.5C372B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B51C40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:49:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OcVJARaH;
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=yDpON0CfstrMMVvgyqFjuA8QunpXRg/nhloNK4nTqMA=;
	b=hHS22AIbYJ5EEsIale+XkkIvDYSxB/QoVaXSup/gz2a+W1y9M9ULVyQEz2sAsZR0slWkVl
	BOLlrruUc0APXgeGw/0Z6wF1LUX2L6e45pR+zpcFBhGIhxt9OplKA05BVRQ1Pl2lkKsPyH
	PB8Yw7xfgTwt3W/yh4/VQCCuvDRDRwA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084199;
	b=WzExiOktLEW5esyoRaf5Sb4Hjw/4zb/t9iJBy9bAWlMcHWTP5eScjS49QmKmispqK5PWRt
	Y0EHjltYc/dBnw9h31qXqQPDbxD4MyqhoqwUJR9TKtRGHhRCZF/EAyU/ddGscPTGGeIecY
	t+n6Y0KV0LOeyg4KZOQjDdAd7azmQCM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OcVJARaH;
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2CB6409AA;
	Thu, 10 Sep 2026 23:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC061F000FF;
	Thu, 10 Sep 2026 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084197;
	bh=yDpON0CfstrMMVvgyqFjuA8QunpXRg/nhloNK4nTqMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=OcVJARaH6Oi1j8XuEcGXhNRaXpqRaKPdDm2jT1O9TnaIFERSfP65WUqSnVo8d7Fsi
	 dh2sMWmgUOA5sg70lpCN5y/sesey3628HvmXS2+yXCP+WzaYrtcsPy2swaFDr1S/ML
	 negKqmBZROzz0wR6IdBYzxXLm6h8Mw4vbquWhDRvx6hT8lpbnlJ+IStE46soZ9vToa
	 EueBn4XirkPG3SkFz5lg6BJroLl6uN4O1kefqRFehAWQEZGV5HVZRKUqBcxYTV3M8j
	 n6JshkcZkGKKcQM9+PwBnjcwWO266P762oW+Up/K12YE2Bp7Gz9q0zJzgTpG5K+UgN
	 UQEwHZB2IgRIw==
Date: Thu, 10 Sep 2026 18:49:56 -0500
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
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <20260910234956.GA367108@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-4-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B51C40007
X-Stat-Signature: fcnp8785royq8i7kz7dphczqymhwiddm
X-Rspam-User: 
X-HE-Tag: 1789084198-543945
X-HE-Meta: U2FsdGVkX1+TCGMoNxNpxSZ4MPUcyfe3Q6u0Qv2kl55VJ3KtyIFW6RUuPi/7VT4Uf1b/+7J/LmccmvW/of2+AGfP4NAu8LSpjeOzkYTy4Ebps8xdpc08wyyC+wyXotPTzAIjHvuRRjNqTOByH6eHHdxgKzPgqepnvOFv8nzRaxSAi6aJx4HtMB+qOGO+4Dvx95/TPhy8xI3Ol1PmNY/JBGYdldLDxWdHaAS+kp4sF1Kl6hqzwjRxL42WLmAbyPfGISm3zo6+kOfuJAfgNTSrh9mMNJ7UFPOSzrEs3/Wv/ngsMvVWdu1TBpXpmze4VGNxS5V0SlfIWVQcAUszw4boA8gD2EqhmHYELzT9kv0Gqouqku0G2/lP4/xCvmH57c+HX/e8Cvqj/YQ/gkVqy81RTAQdFUaCBZAvrn6ESYDzcRHFK4zKuIqhHquYiE3Omf8uIcWM0jQwaBlLJWbVXYEg9H4hC6bkbOLLEr6YBd7neCg3Svu8sxg/9F9qcJtWc6xz5KMUE9akXuO3zypwSgAXqr4U7SZlOXh4mvbEsS8RndH9x2qwq1A7fMi21sVZ3YBLGN6dQnlZaAlgyriDOtYCUiEKLUh1jYQTgrP9+kKSj7HzvRJ9QxUOMt5us5pWQVUpdk2o4JspeL2sF3vYe/147dbpqwwNP9ETf0bckVKjccvETAPaYlsjj9ziHmFi8FnI8k5MWOLLEBowCkrLdcoHxTwweBQqrJTs5YkWfgT87mzjJ8QUohxRl2f/1HWfLaY6K/XzaZULjpq4u6/wtELf4FWfQxz6s92lhaDoLybePPM8Cuu17adOK4Dj5/9zPRngxambgtyCarhuD68krACi4uvurykAn9xxyHcL0zcoxOu5LYVGUxWL2ijuf/u5Qtk/q9/QvDbhPdlS9EVg/EgB0mLnkkCoEEyf30O2T3fX6ch5Et8UGwv36P2ISNRxtjEpMz5X6Hd28v0b9P8a5ya
 zDqVVAhj
 Eq1Hl7pySFfgqq58sRofWOGdB4BKR2Sp6YUmKrlFLIv5BqvUGVEHtzyLRy+yb2hzi8OYx1ZulX6sWOIPnAFweJ7rfzHV35x7ZisTwqvQm4vg6Zx62Onq3wZcM/WQDEaQQFpv14uBSUlP+pH05mS/e5CDpSnIqApbaVtQaqhw+xX16uO6RoSzVcGUV0Rn5LZnxYI47ZMaGjFCBolYtvHpJdl0MYRp72IW/OU+D+c/PrlhGC3mnN60ESroB9wKPaCc1x8gQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:57PM +0000, David Matlack wrote:
> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.
> 
> Add pci_liveupdate_setup_device() which is called during device setup
> to fetch the serialized state (struct pci_ser) from the Live Update
> Orchestrator. The first time this happens, pci_flb_retrieve() will run
> and convert the array of pci_dev_ser structs into an xarray so that it
> can be looked up efficiently.

> + * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
> + * ``pci_liveupdate_preserve()``. i.e. A PCI device can be **outgoing**
> + * (preserved for next kernel) and **incoming** (preserved by previous kernel)

Thinking about how this will be rendered in the formatted doc, I think
"i.e." is really part of the sentence, so in U.S. usage this would be:

  ``pci_liveupdate_preserve()``, i.e., a PCI device can be ...

I understand British usage generally omits the comma after, so that's
OK too, but IIUC the first part of the sentence shouldn't be
terminated with a period, and the "A" shouldn't be capitalized as if
it's a new sentence.

Similar issue in "PCI: liveupdate: Document driver binding
responsibilities" later:

  bound to the correct driver. i.e. The PCI core does not protect ...

> +static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
> +{
> +	return (unsigned long)domain << 16 | bdf;
> +}

Add blank line.

>  static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>  {

