Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B363CD0D141
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101E06B0092; Wed,  7 Jan 2026 12:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0106B0093; Wed,  7 Jan 2026 12:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C5F6B0095; Wed,  7 Jan 2026 12:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1E406B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:17:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FACF13AB42
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:17:28 +0000 (UTC)
X-FDA: 84305824176.28.9EB3D70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F3C9F40002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:17:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNubg6mC;
	spf=pass (imf07.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767806247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=qqRRXfsnDn/JT992sHlX9c5HhYEqI89XeJWo7L/gqTk=;
	b=xxOnP+VCwuHBIZIcEtfRvQTpCh00p80Qr5ZLwq6t/aVxJCFXaZT8nD8VU743U5byvFsATz
	twAEHfGKqKbO5Mv9seW3VctHtMa1ZTLGG5H0ZU5kY3yAd4w23gNqHpjW9Hxwg8+JtkaSHx
	QSunv66qUjxdrr8/3FCwOmjl0LKBeug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767806247; a=rsa-sha256;
	cv=none;
	b=eYIQpLc5Q8JHib3LpCnNfExgOYH7LchLaBAuIjy3mh8/H5/S19NfV16us1qEGnJvozPFg2
	29EtkhGq4PeIB7BpDt45IovQpbvmSB6t8UuV0xczwd5ak0IHN5x0YRI8ptVVuiDMSBnEg7
	b+SRV56aOriv38hKnB7zvkTnLt5Htt8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNubg6mC;
	spf=pass (imf07.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5471E60007;
	Wed,  7 Jan 2026 17:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80D5C4CEF1;
	Wed,  7 Jan 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767806246;
	bh=q4ABnJ3CuJh6SWMrNmKQBlZ1gSO4Xo85FUt+DD5A26g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=eNubg6mCK0SobRhjYoJFNql7uzoEIcWdOyZJ+7syVmoIAFPWxpQ5qk1OOcXtWvMZ/
	 EbPHNXCZGtKZWWLsyI8zNvbSgvEieOwFWos8HvgZ4qWEKGQTKr05nmNdPviq5otgrV
	 JoQ/n69F/t8qi0aHv/HswTkB3At6+u3ybtrUr1olX76MWaOP4a8ReA8a6ROjFZW+WV
	 QJ2qg+4PSGtZcaScVyLanjOBFEZqkgn8fNRL3vAt6Z6WgA/y3ZaRgAa8awY6iNpQcY
	 4Ye4/PyvwQpPnPzETDMuanANGjYLf2TXtc13gr512AogQUIbY3aQO3Wdt+503UOuhx
	 yoqZd+rSkrJdg==
Date: Wed, 7 Jan 2026 11:17:24 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>, Hou Tao <houtao@huaweicloud.com>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>, houtao1@huawei.com
Subject: Re: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in
 p2pmem_alloc_mmap()
Message-ID: <20260107171724.GA432074@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107143942.GB14904@lst.de>
X-Stat-Signature: s51bam3diqqrrqdwmksbffd78ig7geya
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3C9F40002
X-Rspam-User: 
X-HE-Tag: 1767806246-350022
X-HE-Meta: U2FsdGVkX1+qkHAR0a6sRqcpSSk1Zbe85W33JQsz5dXfnJfetOS0mw8rn37ZOnrvtKpqWBaQGAtKeJWAs9l77/LJt3jqbHUuWtvfatwsEUwmD2zbhVpUueBipHOwAYgnQDxVNiIuSM5Me5SCqfog+1vD6mm97+19vVgP7UNOC83HM5IusatlVCp7apGfOY44m78Fh6fDQWvM23lZPx71KUA5mnHwtHQMU7ito51Na6UPhcDeYP9K1//kVtw9ZatRyZDAjTTPjZ0zb+JkSp6sWBdFjBu8O9jF5zKk9k6p613BIdHKNvkpneAcZoAdW6nwc6tnwTwD3pgOMrj9DB89rNiCIDg7S72kEBcbITAYCi6psblHa2vHo0Hgkfjcb0K9HSZEDGG7VGBxNiGmKbG1J+TvS8IKLMwgBW2JG/KVZIWMn84GFXXNa7E7/w7XNCnnuhdTnMZd+n/MQZwgbSrh0JGK92chE1IHBWPNPF5hWnOnmGHN1Y1A2lk5QIVIVI9SACekgsIqxWhVgUA8rqOWPS9POh4zUKb+C7nkfExUHhMW8lVcnsAaIdXoGnHkC+aL5ARC9lG5CBLbzcdTDQ2R+o93ghJJNA6gtKpT1uNh+ftBZ61xU4MBG+2Nlznr23oI2JGntlI2uQUWSqluzS0jOxRNuk4D20LHtnoNDFhDJaNjAv3Qqmvoppntvk7Fw3c4h12pSbCJV543XRpHM3NWDaPIhCtPjhcXQGUUiXB5HxbEFtEGXfX/q3eh7zqx42QNUOtk0pSsZc0URwvOGUNOGrTB5TGu0cJz1tkMqeW2XbdXm35wyBkrMv9Zb6Yg2vvWgwqR/xUt5BU6EY62iU8N+7bQtGh2MfM9PKxkH8OC2swYZmoqnYCgzKgjvFTQ+AxsSfPXAjXvA5QoGq3klTkWiR5J7uB3ZxFfMEM0jGsqMZGSap+sHmwXTC55mV6+Qa8IpJgL7vH43pgrBTtyfIQ
 lNARvV7N
 YsGDvd/JpgB5r5rCOxJjAxEV4upn8Tecpy2RfgDreVxdHQ8BBZlczZ68Q5KM9KbMaxE5YocyY8i2h1XHLKGOWrLrK2tX//+WCud2HYteZbH/yw+sWzqonVvHQvZZqFHsrI3iRBQ2jEKyRjnnw8uJuMG522PBSJEd0Z0xhXI/lA3AVO8StEp4mu29L3eJg7OSOj2+dghTLghCVl29XVPiEfXm5v01yDoDNZRTv9dZPE95Fn0gtjgIolaDXw3LgGshpEsRzFwdy0rtOvIcvImwZqv47EOmj8tpIWCxSFxZQswtfHIBLVcvEp4m/wjClZyzxVvHbqh20IpDqfAtJ884iNapbXwYTInxM+bQB8us5zdKXcFOc3qw4DJo0JSpmnKn/7e+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 03:39:42PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 22, 2025 at 09:50:18AM -0700, Logan Gunthorpe wrote:
> > > Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > 
> > Thanks for the fix
> > 
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> 
> Can we get these fixes queued up ASAP while discussing the new
> feature?

I assume you mean the first two patches:

  PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page() fails
  PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()

I can certainly queue these up.  The second is a warning fix, and the
first fixes a hang that has apparently been around since v6.2
(7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through
sysfs")).

Given that, I would ordinarily target the v6.20 merge window, but the
"ASAP" suggests more urgency.  Do you want one or both for v6.19?

Bjorn

