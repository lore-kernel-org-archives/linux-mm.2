Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FAFFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5E86B008A; Mon, 27 Apr 2026 16:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75086B0092; Mon, 27 Apr 2026 16:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964EB6B0093; Mon, 27 Apr 2026 16:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBC96B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:41:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 318DB120315
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:41:06 +0000 (UTC)
X-FDA: 84705505332.25.B2B27A9
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 536331C0009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:41:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SNoaDyk9;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777322464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wM+QOtZ9yfNrPXhT14ztNpzNE+UB64YzKseERpnZeo=;
	b=EmF0fNF5hd8R28o4f8kddWTYurfe8bcL/1QFEDv9voD0AT2L2nRo8xkQsaAsX/U+/thwZY
	KhwYOPngpTyFTgI7xRULZIhQFMfOekUg6JXjMHKxMZtUJoRHY01DeXRO273k1Mi/qMbuf0
	I5VbKK9Auph8hpQ8Sf1XGYYhl0w193Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777322464; a=rsa-sha256;
	cv=none;
	b=IxNVrOQcrOiPQ5VcncZj0P5gC2+Nu6koIzzCBvNGlyJrsmOQsIUiffrDH/+e4y2os/q9zM
	klfUiP+9H1T9Q/j+ESXhg0bhy0z8/RMsv2XyGkmvT4ce3ELttVDjn+Gtz59pUe3z9f5XZD
	/D3J+Lsu0q8Sndb8jtpe9lkv7EQmSKM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SNoaDyk9;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35dac556bb2so6162436a91.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777322463; x=1777927263; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wM+QOtZ9yfNrPXhT14ztNpzNE+UB64YzKseERpnZeo=;
        b=SNoaDyk9TMrlZgd2ghdMniRVooO1ugz8uWRzK9ar2CW+jCcFSomZACXZrg6bYGF9sr
         wVyf199TEqKtespfVeXMMmW2b9zehT6Ci6sKjuzKSCuDdgqGE6T0PR42F/f+mTQOcD06
         4YFPyXp5P8umfWK2UZO+3UVj0PGHd/wIx5nNz0wAMl+x51ndjZGojUpiGxv959BM1iCM
         u1cRQtTi6ycKxcyAAPp00/uJdzYsGXo2PWzoTW1lx4nEKjJQGrgujTOa0L4D7GCuFmta
         sLqtr4QKZycEIkZdXafVt6rKgr1ig5I1Kh4jLqq+em5lYxBhH58hzYEdkOYnxBNB7QKn
         alfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777322463; x=1777927263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4wM+QOtZ9yfNrPXhT14ztNpzNE+UB64YzKseERpnZeo=;
        b=PWDfStu6chvjBAiAisGAWYHk2lpTigrB+phxjkaaDwkNFA1F69QvttmXmsekZmYmkj
         uR6cD5LG/2yRsOwIaQX7IxFOuz6NYTnCfm9wa6ixJdb9Uwbf3cP0HskuCL2UbxLEjNxT
         nFhq4sMeMZPlDytRiwISM+MOScDpo175tHuIIfrXH8i5zxMt3HNOEjzeEcOseG6ESKFr
         Al67lizh9fOHRdrINWEVS8S95WLGvcOV6WklLY0BOVxJcs5OaryRyWSz/uBrU/2qjix5
         GlbhPA91/Zdf7CDcMU6N8RhiJv/Nkx2dWULo8srpEdiIEiZr4ajsHo8Xs9bd5uWjhx9j
         zj/Q==
X-Forwarded-Encrypted: i=1; AFNElJ89B5IGuvNaS1oJ4Ycsa//PIwBaLReihK2l6Azuh7oKn6fEhpoWgywbwTMSADE3WBxQMxxUrmNRWw==@kvack.org
X-Gm-Message-State: AOJu0YxHornPwIk275vLa3YF0vdP7iBZepwmRRQNhfT9m4FwCqgdBhmy
	ymq7w8irKsKzXmKeOZcRIi5h1NxxQ3gnEQ8g48Y9igOsiPA8eCLzmLTS8cXYM80nTA==
X-Gm-Gg: AeBDietg3OSiwH9qoJ4HlmS8qeoIS1yP0c7z4KetZsC6Fhs97fml+mTOpS2aizMweXp
	NjtIS+rjhOnCjtz2oqdZClDBU2Al62pP8qWbmxH7yHNx5fiPNZOWH9L/IqusjHhdGacHngnROdu
	wPRCbHZmy17ELe/wDybPWngC3SAsWcadeRO3K4BnCQWinWtLivNWUd3PPbExiQhh6Qh/t2tfS5P
	Gm5DUqeguNxf9tKcYLA0qEIlf/I+sfQZmb6J/rfniK9V3R3sbJO4x3gAtyt5fbVZck1y5DThq4t
	PPBsQqCVoqhUKt9DeP1irJAJ6fnRM3IAR2Fc/1rdPFKC3fgrJ4Z7pyEwVrDigexMFTHnY3zEl8+
	XninY+3JkCAN9gb7d9No6yQNeBbWDZHjoWlz25S/h256eAyl2v0droPdrvHRVfaVIeSuAOnnTeT
	vj17NZ72OWUT7ATYUX9oQaPjLB6ro1lBQLRcqkkWH3Vevb5akypSuXqZuk5MMTj122XUWRkflCv
	EATuW3QDywf+Dz6
X-Received: by 2002:a17:902:c412:b0:2ae:57e6:616c with SMTP id d9443c01a7336-2b97c3cba0cmr1478985ad.3.1777322462621;
        Mon, 27 Apr 2026 13:41:02 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac784c5sm3813795ad.45.2026.04.27.13.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 13:41:01 -0700 (PDT)
Date: Mon, 27 Apr 2026 20:40:58 +0000
From: David Matlack <dmatlack@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
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
Subject: Re: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during
 Live Update
Message-ID: <ae_J2pRWFf5qjZXb@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-6-dmatlack@google.com>
 <20260427114745.00000656@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114745.00000656@linux.microsoft.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 536331C0009
X-Stat-Signature: 4ajo36y45gd9kjaw5oamureqotuynjfr
X-Rspam-User: 
X-HE-Tag: 1777322464-732314
X-HE-Meta: U2FsdGVkX18HeKoSScr0FuwQKih66+1/sx3FW/BH12MMW46utuMO5v7JLvQ84XP3RIBLzcSl+G1P5PmgL5Iq4OWWbl22XnNx9yyYwlGq1VeLzBiw1IRhDI/AZpN/3OlKkhx4b8+g3BOagRjHppeQDL+KTJqbRgkZOU9U9RdtGofqK8oFNkmubN3pNl/Tk9uHrW6SBBQaxkLuX3LhcKDiKrUpa7UzAZG/CavIccjLKZo1fshMAev57sRehOiLje5GcrZAqItGI6H7DrWZFfGupT2SQCFIgxc9+Sj90kYXdznIHPJIE264DJiOjejnDIEJULG2U/bQpKMXGKVC2taCDPtjTB5ftFaV+QGB28fsRkztur+LPnuY/YSZ8KLH/r+1uAsV0KWV95eJ6eUanqzWGrclUiVxoBMpARXger6gpaImiAEQHBomywNz2iYHCOhh/jmOc6DBk4DS5eOeYFqDlcyGx6rQU9bn+4E4xHRlnmTdoo16ceO9lpYZmctPLtQOlP9/oSiVuszCSji/alMAKGkMUs8lunKpezZdo9QOwhjSUrsPsAPQd/oigAVaPuN02diqoXgwp/qwhmT9aPlLxSHHbWyXyMv/LWmJ2LFn1xjw4NcFgANVA83sQnWfdhwKj/RDfyllcOosmbw7OjkTf9t6ru0VA199ITlEKS8oEMC0Ah1GE0yN1JO3FBjGpTOUx1bgcvdi1LF7X5iLF3o/PvAIjyoNMDjdofRfrebbvvnrdzznSsqPzmYCUlXpAdHOGpgMOEk5iENPN+FeccabBKcr6GeXtZuJX0DvEZaAR1IRspcMyFGHMMdLUexKU55r5Fs5DXlxhdePkR+/JFSPhGaq+N6ipnTGFxxYsUf0ubNeQaH95u2GrzwchcnkNKAKBSyY7VFiFy/r9E4JbZlhz8DDVGnWijVdLSs69Fc8NajzAjJsg81fv1od5fSiD4hl0K9pH0dt8Lh40OHhNFx
 rJUMLjz9
 3a3dKiKcbdDIt4DVZVXHhm+b00wd2OnOxLFwmUwp/rP3rvqTpyyNYq3n9je3mkGyUf7PkQjG7n2LLwyhyaf+W5l0gz333kvcpffo02SjIJrWeFOmv2p3aqsQ0YeYEGFecNbXy1cVgCNSinVSBNqEhGamhkCBmzzE5wkCgegeTpQpbyfbUDM/27tm8kyKddbx9XhYZmCBc1qOg914ESc7+OrWYDo54O9KGhOtV0of46w5BGD7s6UfrgThByLtaQd6X25LrT7oLxFQnv34cOzW9uuddjgVdZ27oa773p17xQpMlde/E2IGgVdv+HpHdBoP6ENDDezuzeqbfuyUrUdFTxk5Bar0oKYN4q6uB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-27 11:47 AM, Jacob Pan wrote:
> On Thu, 23 Apr 2026 21:23:09 +0000
> David Matlack <dmatlack@google.com> wrote:

> > To keep things simple, inherit the secondary and subordinate bus
> > numbers on all bridges if any PCI devices were preserved (i.e. even
> > bridges without any downstream endpoints that were preserved). This
> > avoids accidentally assigning a bridge a new window that overlaps
> > with a preserved device that is downstream of a different bridge.
> > 
> > If a bridge is enumerated with a broken topology or has no bus numbers
> > set during a Live Update, refuse to assign it new bus numbers and
> > refuse to enumerate devices below it. This is a safety measure to
> > prevent topology conflicts.
> > 
> > Require that CONFIG_CARDBUS is not enabled to enable
> > CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
> > bridges requires additional work but is not a priority at the moment.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>

> > +	/*
> > +	 * During a Live Update, preserved devices are allowed to
> > continue
> > +	 * performing memory transactions. The kernel must not
> > change the fabric
> > +	 * topology, including bus numbers, since that would require
> > disabling
> > +	 * and flushing any memory transactions first.
> > +	 *
> > +	 * To keep things simple, inherit the secondary and
> > subordinate bus
> > +	 * numbers on _all_ bridges if _any_ PCI devices were
> > preserved (i.e.
> > +	 * even bridges without any downstream endpoints that were
> > preserved).
> > +	 * This avoids accidentally assigning a bridge a new window
> > that
> > +	 * overlaps with a preserved device that is downstream of a
> > different
> > +	 * bridge.
> > +	 */
> > +	dev->liveupdate_inherit_buses = true;
> > +
> This flag never gets cleared after the incoming kernel boot up, what if
> the user does a manual rescan via sysfs? i.e.
> # echo 1 > /sys/bus/pci/rescan
> pcibios_assign_all_busses() will never gets called for this device, and
> may hit this
> 	if (dev->liveupdate_inherit_buses) {
> 		pci_err(dev, "Cannot reconfigure bridge during
> 		Live Update!\n");
> 
> So, maybe clear it in pci_liveupdate_finish()?

I think we can allo wa rescan to assign new bus numbers once all devices
go through pci_liveupdate_finish() by clearing
dev->liveupdate_inherit_buses on all devices in pci_flb_finish(). We
would need to hold pci_rescan_remove_lock to avoid this racing with such
a rescan.

Now that you bring up /sys/bus/pci/rescan... I think we also need to
set dev->liveupdate_inherit_buses in the outgoing kernel, to avoid bus
numbers changing on outgoing preserved devices. pci_flb_preserve()
should take pci_rescan_remove_lock and set dev->liveupdate_inherit_buses
on all devices, and pci_flb_unpreserve() should do the opposite.

If we did all then then /sys/bus/pci/rescan can work like normal as long
as no devices are preserved (incoming or outgoing). If any devices are
preserved then dev->liveupdate_inherit_buses gets set to prevent bus
numbers from changing during a possible rescan.

