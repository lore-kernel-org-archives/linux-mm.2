Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C58C531FA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BA26B008C; Thu, 23 Jul 2026 19:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD066B0092; Thu, 23 Jul 2026 19:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7256B0095; Thu, 23 Jul 2026 19:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7C3D6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:01:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47CA3A0238
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:01:32 +0000 (UTC)
X-FDA: 85021564824.24.CD735CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4E89D4001D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:01:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAEFQJJr;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784847690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RdLv00N7jX58E8HADs11ire5JMHBSKT9IgqUk1JawYw=;
	b=fxeAeS9raR4XuqdtBkSCS/d9MkulSJPmmbCDaaGmxYfcY71seEEjf2Lz/mvUk0zoFrRKnj
	PKYpJcltLemee/7Q8ZaQQ6gB9FKD5MWF7GKUqO4g6WN7JGfmaOMGk8OymHWOSVjiNHXBdk
	YZDwr2GjwyvDIg3C39qKhbVo565duAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784847690;
	b=K5MXEULLq/UUO62Edf+PStQ2cee6t9MjaR5TP5DpPJ89aZH2uCw27aIlWczAq+XeCYPe7k
	yYPmk/fEwy2kDDy/lj8ZQolxB9HM8sqBRNCOxlMgJQGAxI0fHmTfYkFJxisBzYhGZWOrMM
	chgKR01W0n3SalL3OM7Owf4Pgaz6p0M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAEFQJJr;
	spf=pass (imf17.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BB95600AA;
	Thu, 23 Jul 2026 23:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C181F000E9;
	Thu, 23 Jul 2026 23:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784847689;
	bh=RdLv00N7jX58E8HADs11ire5JMHBSKT9IgqUk1JawYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=eAEFQJJrZ7uwgqf0SgHo59C09zS97IR7/DOJa9wnEhNJHsi/MrkVGb5B4fpFV2gH9
	 gQoMFN9p8WCk0BnTxe6oAiNlMc7l7E1fdeB6k6zOpKGBxd9IpltA4M2cpnBLTgx9ND
	 s9SevN7RMHz3dtI6CumsFLt/WX6o2AdxtlaQGfwZUC7YQ3hJZrUu2ZtSVr9NtrdtNa
	 7QxgfYUt5cDaogs4th4zU4gzR+2fYpW3UUrHQZCyLJ3QEqVxYaDRpT9FrGiiw8IzAf
	 UPq0t40emte7mzuq2mEcT//7iVtv5WasN7ES9ptQPBCbkDoRRCAUPiDNjmXzAcdNJr
	 dRuw+3ML3Ootg==
Date: Thu, 23 Jul 2026 18:01:27 -0500
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
Subject: Re: [PATCH v7 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
Message-ID: <20260723230127.GA869843@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-6-dmatlack@google.com>
X-Stat-Signature: y6eue3gtz6jcif87oz6j3pr9duyoado9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E89D4001D
X-HE-Tag: 1784847690-177692
X-HE-Meta: U2FsdGVkX1/0e3Sec8yd/DtEiJz1ADfWjtJYP4P2T0bbECn7UwzS6pZpWPL8FdRBTjgrh2V5bq8ZucB32Wq+VSf9jYvdy1zmpw00riqWOSYeWaXWHngOBDNjB85ZY2l6tmcJaG8Vc9bIJq+e1z7vIZIa6Jw1gerpr9GbZOQBMFdN948Eyf4Jp7jzishJaUqLcjJ52C01WNW77/Dq6f36U2gL8C2qqaO8meOumEWoSTnHJPVhyxa2kxQd29lxP7WX4azAOVqGWc6pRbmaZnBX08maftM1gTd8TNFBr3VSTCVwBiyp3V7HhyaSQnTB2+iET6ql/wQVVBo7TEg86mnFl2iwSGRkByxJFNZsHlqaNkKzPsDbshng0GxaX2UwTyQ2r+KBP4CDcSsKa14ma3X4/ySVJpScGrNfd+1lhcoxLJV+xP/hZw69CM/6cAKijeG+rZx3pDaZZCZQwlJp39IRVxUxa96s1Wzcj/ybKSY9Al2/4kdSXfEjvFWUd7HB4vRU1/pulaB+k0+wqwASH5kEOq08AXNFTewkd7odM8ADS0K7SjBaa26t3EaTa7t3briiCsc7Ax1nwPg4JUhdGVMUADlCyhLq5/PHM0EK5+P5oF+StQ3kyM9g78KJHVnS7xrIL7sIoBH/UyNmfyusJgtxhIK9d3oFL6bTBdddwI2BDwP/pBA9kEQ8UzoESJIGLEJptnHqN+K8FwPqhpcQGIqzsYnt1Djxs8glHdMWpHGe1sxXk3deADM9GLj4igAf6hVVrYLP8hbuJoi642QLXiGEYTpu7vogsNJQDPQTnz8acgdnYIs1+UMQDOMbTJIGERMQtgmcq6Vheu+50dNlY5oqYxwpulWyW3JC5MPMTuCIB8L1nua3TgoypPEHNGqC6fNU4mHwzK+COrkus15QZCBUIQLqTuI8BmudHrqRHyKwmI8MQfreDbdgX+P6LUzJpkIMFqeg97kICxnnKG8FOsw
 MGQFOriQ
 oqCdoGoGwM7fYbQgK6km/PDykJjFFE9jfVE7SP9nd84lHOwVowVKHkPg8pnPtg/D5sJtVHk5SSG5m1gg7LJzf6YPGsmdkD5a0hfBL0tzYxN7SY1Um52XN6XkCArC1BLls5KyhP5mvX3Et+V0zPsP75diAxHU0CY214zAveB2cZf5uVIHpP/z0nYze/evupqFZxyZOtVgFbU8odsySz5SB04TvH8s6FJT7+epR9tiHIkyVPtLFSuiPanboDX2QNKw7g4VP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:08PM +0000, David Matlack wrote:
> During a Live Update, preserved devices must be allowed to continue
> performing memory transactions so the kernel cannot change the fabric
> topology, including bus numbers, since that would require disabling
> and flushing any memory transactions first.
> 
> To keep bus numbers constant, always inherit the secondary and
> subordinate bus numbers assigned to bridges during scanning, instead of
> assigning new ones, if any PCI devices are being preserved. Note that
> the kernel inherits bus numbers even on bridges without any downstream
> endpoints that were preserved. This avoids accidentally assigning a
> bridge a new window that overlaps with a preserved device that is
> downstream of a different bridge.

I know there are many references already, but I think "preserve"
conveys more of the meaning here than "inherit".

> + * pci_liveupdate_scan_bridge_begin() - Determine if a bridge should inherit bus numbers

Wrap to fit in 80 columns.

> + * @bus: The parent bus of the bridge.
> + * @dev: The PCI bridge device.
> + * @pass: The scan pass (0 for first pass, 1 for second pass).
> + *
> + * This function is called by the PCI core when it begins scanning a bridge.
> + * It determines whether the bridge should inherit the secondary and subordinate
> + * bus numbers assigned to it by the previous kernel. This is necessary to
> + * keep bus numbers constant for preserved devices downstream of the bridge.
> + *
> + * Return: True if bus numbers should be inherited, false otherwise.
> + */
> +bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
> +				      int pass)

I see that you named it this way to have a begin/end pair, but I think
this function name should be a predicate, i.e., it should ask a
question with a yes/no or true/false answer.  Something like
"preserve_bus_numbers".

> + * pci_liveupdate_scan_bridge_end() - Finish scanning a PCI bridge
> + * @dev: The PCI bridge device.
> + * @pass: The scan pass (0 for first pass, 1 for second pass).
> + *
> + * This function is called by the PCI core when it finishes scanning a bridge.
> + * It clears the inheritance status after the second pass so it can be
> + * re-evaluated on future scans.
> + */
> +void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass)
> +{
> +	/*
> +	 * Clear inherit_buses after the second pass so it can be re-evaluated
> +	 * on future scans.
> +	 */
> +	if (pass)

I think the decision based on "pass" belongs in the caller because
it's really an implementation detail of the pci_scan_bridge*() code,
and I think it's important that readers of that code understand that
we no longer need to preserve bus numbers without having to follow the
chain into liveupdate.

I guess the point here is that we've always known to preserve bus
numbers of existing devices, so after we've enumerated all the
liveupdate-preserved devices, it's safe to assign new bus numbers for
hot-adds, bus rescans, etc.  Right?

> @@ -1397,6 +1397,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  				  int max, unsigned int available_buses,
>  				  int pass)
>  {
> +	bool liveupdate, assign_new_buses = pcibios_assign_all_busses();

I have a pretty strong preference for non-negated booleans, but I also
think "assign_buses" is an unfortunate historical choice.  By default
Linux owns all resources, including bus numbers, so the exception case
is that we need to *preserve* things that were previously configured.
Especially in liveupdate, "assign buses" is the wrong sense -- the
requirement is that we preserve them.

So I think here a name like "preserve_buses" will express the intent
better even though it will lead to negation here and in tests of
"!preserve_buses" below.

>  	struct pci_bus *child;
>  	u32 buses;
>  	u16 bctl;
> @@ -1406,6 +1407,10 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  	u8 fixed_sec, fixed_sub;
>  	int next_busnr;
>  
> +	liveupdate = pci_liveupdate_scan_bridge_begin(bus, dev, pass);
> +	if (liveupdate)
> +		assign_new_buses = false;
> +
>  	/*
>  	 * Make sure the bridge is powered on to be able to access config
>  	 * space of devices below it.
> @@ -1449,8 +1454,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		goto out;
>  	}
>  
> -	if ((secondary || subordinate) &&
> -	    !pcibios_assign_all_busses() && !broken) {
> +	if ((secondary || subordinate) && !assign_new_buses && !broken) {
>  		unsigned int cmax, buses;
>  
>  		/*
> @@ -1492,8 +1496,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		 * do in the second pass.
>  		 */
>  		if (!pass) {
> -			if (pcibios_assign_all_busses() || broken)
> -
> +			if (assign_new_buses || broken)
>  				/*
>  				 * Temporarily disable forwarding of the
>  				 * configuration cycles on all bridges in
> @@ -1507,6 +1510,11 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  			goto out;
>  		}
>  
> +		if (liveupdate) {
> +			pci_err(dev, "Cannot reconfigure bridge during Live Update, skipping\n");
> +			goto out;
> +		}
> +
>  		/* Clear errors */
>  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
>  
> @@ -1567,6 +1575,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
>  
>  	pm_runtime_put(&dev->dev);
> +	pci_liveupdate_scan_bridge_end(dev, pass);
>  
>  	return max;
>  }
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index cfdc3d62ec02..2be98819e313 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -17,10 +17,14 @@
>   * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
>   * @outgoing: State preserved for the next kernel.
>   * @incoming: State preserved by the previous kernel.
> + * @inherit_buses: True if the PCI core should inherit the secondary and
> + *                 subordinate bus numbers assigned to this device due to
> + *                 an ongoing Live Update.
>   */
>  struct pci_liveupdate {
>  	struct pci_dev_ser *outgoing;
>  	struct pci_dev_ser *incoming;
> +	bool inherit_buses;
>  };
>  
>  struct pci_dev;
> -- 
> 2.55.0.795.g602f6c329a-goog
> 

