Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A86CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 18:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CAD6B0093; Fri, 22 May 2026 14:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E544E6B00B1; Fri, 22 May 2026 14:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91AF6B00B3; Fri, 22 May 2026 14:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6C906B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:02:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 601F0A0A69
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:02:03 +0000 (UTC)
X-FDA: 84795824526.04.BE79B90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0AAE140010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:02:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXo6wUbv;
	spf=pass (imf26.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779472921; a=rsa-sha256;
	cv=none;
	b=p/FvkgukSSy5Wyjduoweveri9jz5x9ikWMR49Hh4kZ8r1hggFlE11o4Lm3P3PXkY3yF7WX
	2mcTsq96FryAdg2K3xyAklx97IGXKTCNNc+bTNOhK+ieANQ0UMNS8bttOSgolWu/ahcDCV
	iAAopG2g6h55yublTYXILOHiYUU7Hd8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXo6wUbv;
	spf=pass (imf26.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779472921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=3pwqqJmK0UZHpTQbgMPdFytZpYtz+77BknUANKGAa1k=;
	b=2fwA5pD1pozfFlfh8SURj6pyeZOw6k0pwdSYN3IDbVlx06xzGJsfsLy09Pw0FAbc01eVsM
	2JBoDe+INtFlPpDyMcSaV+I5+t4sVqvN0D2oRmiuZX9cNBpLzftEUFZqZ5uVBUsCQddKfV
	54EV6+agbUkKSdudR3o93tGXVE8kpQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D93A142DE8;
	Fri, 22 May 2026 18:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91D7A1F000E9;
	Fri, 22 May 2026 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779472920;
	bh=3pwqqJmK0UZHpTQbgMPdFytZpYtz+77BknUANKGAa1k=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=TXo6wUbvp686W6gRZC9qm8zmd4BiXLPz+wTU2Jsq2lT4E9qOQM9JxVXC0FxlBZ5pg
	 iVw25MMaBsEi28vn1ODnZDud0jzMfw9NP4SR4+uPXPdaQLdtGDAKm+TIOPQSuX7fjx
	 yk/Z2M+PGaVjVwx1oP3yx6UayfL38rLK20qYZ+qf5KhiR4ygA7F/s3E+Fm1++h3vnl
	 Z07mNXiFezn3JCqacgY51FX6uymKGoCnYQPub6wfFXnuNVTZZJIVNpB7KgHDxNkwSC
	 unRmAtTZKUdsX9Fn3QNUMDYspPEoPO0/Xa2Weh/cf2OfnuHBRN2njlHAHVl6ZgSqzO
	 gfcXyx/Vw6YbQ==
Date: Fri, 22 May 2026 13:01:59 -0500
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
Subject: Re: [PATCH v5 10/11] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Message-ID: <20260522180159.GA231364@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512184846.119396-11-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C0AAE140010
X-Rspamd-Server: rspam03
X-Stat-Signature: 8g7stahc5zt6bso1nwhsx3bbudjkq1wa
X-HE-Tag: 1779472921-73916
X-HE-Meta: U2FsdGVkX1/e++Vys/C33/0kNXgDnGSiwGKwi9ZKVQdlxtsjvc2HH0NlXP7jdd8jhVO86YVtXCJv3QtJyOGuIQloRtMDPMkVbqMudRqya7xYnSCDbfqp4neFbNOjtb3FL+O9A1Wd/XXJV35wYiqegP0JaHDx8HDGoWMoSXp9/d6ry0Sqoq0bYgb3JQCay4oTFQFUg10Tiif3b622Lb0srszkPjedV703y+GnhyQjbDMkEJTQf2ju6RReiFyhupB7WGyAn3J/gWTO1p+iFLDbSAxAN2BGFOhfNCKDWFThHUmxXWEadOeMIp8tfoI0l0r7pz/TSbOFTo7jpUfwwHvE0E7W0xOWqe4DxsfTmw4TnptYXzsyFkCZz4uC3esHSesenVANc2H+D5qBwdH81niIz5pXidRBkY9oQx2CvTWWnlGoEoe4a2IiarBdI13/pH4HfEnEefhzUlyNu0tMYD/AR8FKzEnuAvdF8mGwjcMqfEyx7WFTwRkQOd4UBuVLazWFmTv/k1aCAWmeebqhaXXnWEeiyUTDz0Sy+u/wBRMOrWPvE2+oWUaE7mLJxBtj3LocLYE0sNaztiFfgVLdWjS2p51gHfGQzqi/YerrzcKt+bi4rgkPLAyM+W7QNAJZlfmvNvS+FeP7o3i02xZ7vAysFHvyQkW2/fSKNaX3b9lj3QKIXHoZv+3sODsm3WYKZDpCwuDnmiJOBp4c04iee94pvHtghmf1PSZabId91oSqa6DmIbzbkeJtAD8o/GaGFsb83dde4Kiv+XhQjhppB2/w1Z4m53RHmHjj0XHwMQ2T3/dzyzsQc+8MO7XwkfQ557hLxQNne5aKr4IQtlFSt+YUUC6sIYNkmyK37SzYiHU/Dvyh3ib0rwLjoc2VKqZjrtRFE/L9G9xaFryn+sg208oiY0g3OlaIwn74w8kK5yWyMfrP1cgmOGJCciFLD8F+klmt1e5Dd0hQu3yUaILqU4R
 Ae8bq+7P
 2T1G06HVJz9dp4NXvIQimGvVNfQ0BXHF39J3lq9KazizAgEw5cYF1pcA/Nezeay/zO887iFbNXaSpMiyq2YLB0NLtHAwOTqRcPl+5rRZToIp6PV8bVsABLF9P9YBlxzKIi+7wMKvAulAsBnFCN/jfLZstzHR/CY++qLhv1ld98BxiKrw71dc7ld0GgSruTCU3EczssXVxTliFMJGCaDsCmWtZNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:48:45PM +0000, David Matlack wrote:
> Do not disable bus mastering on outgoing preserved devices during
> pci_device_shutdown() for kexec.
> 
> Preserved devices must be allowed to perform memory transactions during
> a Live Update to minimize downtime and ensure continuous operation.
> Clearing the bus mastering bit would prevent these devices from issuing
> any memory requests while the new kernel boots.

s/minimize downtime and//

Ensuring continuous operation is the critical piece here.  Minimizing
downtime is always good but IMO it's not actually a reason for this
change.

I guess what this is probably saying is that the continuous operation
and Live Update are what minimizes downtime, and preserving bus
mastering is a piece of that.

> Because bridges upstream of preserved endpoint devices are also
> automatically preserved, this change also avoids clearing bus mastering
> on them. This is critical because clearing bus mastering on an upstream
> bridge prevents the bridge from forwarding memory requests upstream (i.e.
> it would prevent the endpoint device from accessing system RAM and doing
> peer-to-peer transactions with devices not downstream of the bridge).

