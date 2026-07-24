Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFB7C531FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 21:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564466B007B; Fri, 24 Jul 2026 17:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514956B0088; Fri, 24 Jul 2026 17:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403F46B008A; Fri, 24 Jul 2026 17:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B18D6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:04:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8606B80184
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:03:59 +0000 (UTC)
X-FDA: 85024897398.10.3051235
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5C031A0004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:03:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awwG2N60;
	spf=pass (imf19.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784927038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ORy7pD3J3tq2ffN0BYU78UX4I8xRQr5quYqmf8Dwz0E=;
	b=SlS+kAqvLWM6HDCR6XEX0DHzPe3gqc9yNgNwXe2KV+ztmdsFY4/+Pptkdx5DlFPbBI0F47
	Hhr6dV2Njsg9XDRcBip3W3FM8sjBCWNWVlu3GhDxhgNa/uN+DgKkk90Rqlp4MFD+7DCP/7
	hHBOSHxnG0V7W8/lvIkGLXjlIb1hKic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awwG2N60;
	spf=pass (imf19.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784927038;
	b=ZRTxwrjms8HVnDKjWRcXzbsKOJGFYByNs1zbZD5Lp0QDVW36yvQ4RmG6DIHAFdH182X9VL
	lusqwMgsAcBIXy0Bvmdzae6eQbYBrIu9Bl9A710qMhbcFIJ1aNUdt90zf0XBHxW/FLyHbR
	3Rs93ci2dr/Eqr83P8mfgxKeFX3ed0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCDD843C10;
	Fri, 24 Jul 2026 21:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC21F000E9;
	Fri, 24 Jul 2026 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784927036;
	bh=ORy7pD3J3tq2ffN0BYU78UX4I8xRQr5quYqmf8Dwz0E=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=awwG2N60+aaqJ3kLhq5nlZL6C/rx1WROQ4/ll5LuH3nXHs1kPA0zvlTOgoRhi17Aa
	 nOiqCGQjQ5jV1cHlp71EJ75x1kxOT1T9nd8meabJtXAtvHVmbrRFR6N1enDeGQ0evu
	 h4gdVbjRuzDNrq33cwbS5oOj2tyyiyh9iiWXqiiNRjG2563ghB9Nw6yktQJoNk7gwV
	 7XLxAtE+LhI63U7atmwMhC4ULTesDHuRr982v+q9UFF9CV0CKGJsEyOtAlM0Ud+Mlh
	 TS5RP/788u8V6/Qs+oE/IxHYboT5ocyv0tYA/CFjT/XIK5cpXO+fV/trhVrZMf24GK
	 yWcy1B6i6Nrcg==
Date: Fri, 24 Jul 2026 16:03:55 -0500
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
Subject: Re: [PATCH v7 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
Message-ID: <20260724210355.GA1052395@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-8-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5C031A0004
X-Stat-Signature: opwcjhajddwcbcba3wc9k4zr4qjtjjtt
X-HE-Tag: 1784927037-42757
X-HE-Meta: U2FsdGVkX1/BRLeVpbpFvP2+9h7llSvTGt0BZNrtEqz+D+wV9huICLNt23zXUy+Jl3KcJ9wqFsvOMYOVEcn+OPVBT/CB8yvULzGzOKbopGObeYKHdth/tbWPssIvPAlBz8C8FMsAYrisK3dviJAdQMuPBqxLAT5WO8Yd8H8s7SqMFgEn++duwZw8KAGCkOJzwsLtWQHz4npl7UPxsQd+mCPaDqDIaz038lGnuDTKQWQg9tUFP4cZOZbmY+W2IuvKHMWfeqWYAjxx8K8UfIwAkbeOdThSTEZOSZRP+1STs71ACfHDrCqC9xWEk1HWKjY6ATguuxDbLVo08TMmZL+/Y48Vm5HZAIj9HZaq9YEkyzhzurNilDXah8ZrB05fK4sdyY5V/4zo5gaCROgkgFqs8n/PUdlK6zmYW8JGi2oHZVv9tOv4/L4+brA29SZHiMrJd7iwpcCSCiKaOc1AE4jz9HaUd8vn7S+xrUlmfJDH4q/7y7NQ2+1oicXPCrQJII7NXrpVOJnD769ERzsJrzWZ3PhNKmWLJuq0wQVqew5C6anmcNuKXIy7k7H8/DXr7khgn5/EYlw/ldfxDfabZBxtagM9lqHLGOz0JOICxgKkK/+kPYkLbqVFJ4uWqtpzNsZwKN2P5dLdIpLK+/Auhbcy73edHI4/OUi/RVSQWjN1n/yOHbTOJX3Aj3mPbqne3Ccr8Lux328yABSNIIcE1LIC0+Z49nBkrGrX5QEFjB+Jdq7ug5BNgRdo7oacDt6MwEhWORtfrqlc6b3KVKD4nlfPv78pwE0GHSQPLJaKuwmDkfXz7ZC0p4pR+szTT0TviicaksJnqSYThzogSjiS05Io919VFYMsQ38h/Vzt9DIBlhXL0ZSWI07YX6DY1fT/ptA5T0fwrjYz/s0ZqK16bbwHYbAKC/ab8b4WYdrvttAYQZYXqd+zu1sh5x4IFIPSn+75RaDTgHzij4jRUFw/bRG
 S8gkF3qA
 xdGmQStMHDgKt5XmWi4u6KELa3b+5/rak6e6+g0uNXtSrno44sut5BvY1folHGl0G1KM+Mc8WwBDwOYy0F4BebmckUoiHf99xjz1lIqPx/PxW6VqvZ+FCwdbRk9d+WKW9T2guB79Rcn8EjbqjVGLlJrsxiPiNtPA2lq5XqVq1CycY6K4S+9IQdfzyKnoxV8paVuhK0shwgavwt6dtmbIR0YkZp4pcuDXM0xg2a/WCnoBvl+lsUZoLVm2y5FSheNjnI32drTlwnUHMwUzFca6Eu7OTOCNTTXRF3C3QPX0oAlhujMZ7dyo/+qT8uConkFOwDNDeGCYZmGx/SYFRh92GMzX87EzaH1V1nvoFB50t553ggJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:10PM +0000, David Matlack wrote:
> Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> the loop and device matching into its own routine. This eliminates some

Can you mention the name of the new routine here?  I guess it's
pci_dev_acs_ops_get()?

> duplicate code between pci_dev_specific_enable_acs() and
> pci_dev_specific_disable_acs_redir(), and will also be used in a
> subsequent commit to check if a device requires device-specific
> enable_acs() during a Live Update.
> 
> No functional change intended.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index b09f27f7846f..7ac39ec2843e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5374,9 +5374,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
>   */
>  static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
>  {
> -	if (!pci_quirk_intel_pch_acs_match(dev))
> -		return -ENOTTY;
> -
>  	if (pci_quirk_enable_intel_lpc_acs(dev)) {
>  		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
>  		return 0;
> @@ -5396,9 +5393,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
>  	int pos;
>  	u32 cap, ctrl;
>  
> -	if (!pci_quirk_intel_spt_pch_acs_match(dev))
> -		return -ENOTTY;
> -
>  	pos = dev->acs_cap;
>  	if (!pos)
>  		return -ENOTTY;
> @@ -5426,9 +5420,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
>  	int pos;
>  	u32 cap, ctrl;
>  
> -	if (!pci_quirk_intel_spt_pch_acs_match(dev))
> -		return -ENOTTY;
> -
>  	pos = dev->acs_cap;
>  	if (!pos)
>  		return -ENOTTY;
> @@ -5448,56 +5439,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
>  static const struct pci_dev_acs_ops {
>  	u16 vendor;
>  	u16 device;
> +	bool (*match)(struct pci_dev *dev);
>  	int (*enable_acs)(struct pci_dev *dev);
>  	int (*disable_acs_redir)(struct pci_dev *dev);
>  } pci_dev_acs_ops[] = {
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> +	    .match = pci_quirk_intel_pch_acs_match,
>  	    .enable_acs = pci_quirk_enable_intel_pch_acs,
>  	},
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> +	    .match = pci_quirk_intel_spt_pch_acs_match,
>  	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
>  	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
>  	},
>  };
>  
> -int pci_dev_specific_enable_acs(struct pci_dev *dev)
> +static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
>  {
>  	const struct pci_dev_acs_ops *p;
> -	int i, ret;
> +	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
>  		p = &pci_dev_acs_ops[i];
>  		if ((p->vendor == dev->vendor ||
>  		     p->vendor == (u16)PCI_ANY_ID) &&
>  		    (p->device == dev->device ||
> -		     p->device == (u16)PCI_ANY_ID) &&
> -		    p->enable_acs) {
> -			ret = p->enable_acs(dev);
> -			if (ret >= 0)
> -				return ret;
> +		     p->device == (u16)PCI_ANY_ID)) {
> +			if (!p->match || p->match(dev))
> +				return p;
>  		}
>  	}
>  
> +	return NULL;
> +}
> +
> +int pci_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
> +
> +	if (p && p->enable_acs)
> +		return p->enable_acs(dev);
> +
>  	return -ENOTTY;
>  }
>  
>  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
>  {
> -	const struct pci_dev_acs_ops *p;
> -	int i, ret;
> +	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
>  
> -	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
> -		p = &pci_dev_acs_ops[i];
> -		if ((p->vendor == dev->vendor ||
> -		     p->vendor == (u16)PCI_ANY_ID) &&
> -		    (p->device == dev->device ||
> -		     p->device == (u16)PCI_ANY_ID) &&
> -		    p->disable_acs_redir) {
> -			ret = p->disable_acs_redir(dev);
> -			if (ret >= 0)
> -				return ret;
> -		}
> -	}
> +	if (p && p->disable_acs_redir)
> +		return p->disable_acs_redir(dev);
>  
>  	return -ENOTTY;
>  }
> -- 
> 2.55.0.795.g602f6c329a-goog
> 

