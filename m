Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA816CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3106B008C; Sat, 10 Oct 2026 04:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA7A6B0092; Sat, 10 Oct 2026 04:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1966B0095; Sat, 10 Oct 2026 04:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F12D6B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:48:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8A8440594
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:48:04 +0000 (UTC)
X-FDA: 85306089288.24.F3805B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4647CA0007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:48:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+QntHaB;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791622083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aAKNdFlAWIBUhCteIbdgam8eQs/tWYWWSOa0TvAgNk=;
	b=x+D0QRWW6PxTiZEWXowl9RyV/SCUZUEDbfA6HCRkO1V23b9GxHekTlvsp4dxlUKV63lvTI
	wrpZ5SHSu/UTQ37eLIcrynjkvBsabTPRr/3T478Su5NzCFnGz+5nrsQDgzPuEYhLRrc2R4
	epb1qpPmQvIcC9+f4htocYFnd6QKBCc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791622083;
	b=ENU/zmtp/GU4r98e+DnYUljpVgvYrJqcDkqWEpj3BQZw1xDr+37+TL2+3SPg8MaAJp52TW
	FMDBMlCu8td6TUYQo05YOf5Zl2mp9UuAurINbQHU5UeujYMvFKOqIXP8D0271T68SnyJPc
	Y/P6XjgxhjcFixeUHaTq9+NsbTXWQUU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+QntHaB;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4704143F5E;
	Sat, 10 Oct 2026 08:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D321F000FF;
	Sat, 10 Oct 2026 08:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791622082;
	bh=9aAKNdFlAWIBUhCteIbdgam8eQs/tWYWWSOa0TvAgNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a+QntHaBhv0z8VDbqJJkqrAwEbrFgBRg9/Xdm5ENmSUmHKoLcSJ8FMMZ1gUr4vKt2
	 kGmnMkcNDCeDjoev+XtP9mnEW/W3AbTtLQlms8kGI99KHAiN8gB4Ms0D0wlymWzpY3
	 A9bZ3rVrc8o9I5DkUPZn69Dq+TWk/7MmKxXr0QQB+04WP/nEaGg0ZWk5RR+xz+Bss8
	 7j/ghcFbgoFQw9puG4IAQz8wyGEuft4Vd85CchZXZtPtCYMZJC3Cw2LlLaQBeKgVQW
	 LkWEQNOgeGNWM1wyUpEfoQkQoV3dm7cHU5Fl9S+m6qv4N2Kw4TOV+2TKCNPET8VLZ9
	 VReZAo7MXRnpw==
Date: Sat, 10 Oct 2026 10:47:52 +0200
From: Mike Rapoport <rppt@kernel.org>
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
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 03/13] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <asn7uP123pDkdkSm@kernel.org>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-4-dmatlack@google.com>
X-Rspamd-Queue-Id: 4647CA0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rotk6ysf6z6fsi5mbya63543ry461dm8
X-HE-Tag: 1791622083-837352
X-HE-Meta: U2FsdGVkX19oVVPyCUIGp2IZp0FIZF4P+CWuh/+mgkSbQkpT0MQQzr+TbZKltdIjhARpQtepM/gYPMrUf9ULENroXdCNzhlhe5PfVcRl8yOwTmSxqB+RnoB3Bi8RvuuJfDsC1rtS8trIwzamKSg3MDEqNcDXsjyO6P+eXrJRuZTQeqp3U9CZvp/hGSfmuGUFBt/bOVS5Iws4j28fVZ28cSS5hsVkWllUEWaj6SfQp4SUdTAmORnVGhkbCcGE5c7LIkP3+2aMMRk+mPfE2tnGDoq0aHQb4ymiuMg8/k7DEs0fquRppfa1AIxL0L5uoCaXmx2ySk9goKDapJHDEPBDTtWfJ/qjuV4+TRsfvc2FL2/jx2NJO3JEX8XpyaDDrWQNMg+LkSSC5jEldev+qSi7vXf88lSluL4/J5QLtHc+Niifxvqf5skR8xYMET+ErZPeE5cM/AT+kEDsT3F0zbEV9NlyXqLjXdXUCBOFYXLEH6XJq62ii97LoNlyweJWFKiSNEN/Ekbw6TjIla+HljA6deC0AVmTxPUYomHBOME7hKAEf/2ARj3FGjTYMSfqL5negrOFrDolHwcUFM8nxjowKfwRW7p/LqaLHpie6bL1H+/oFcQDAC2OmK8j3l54hEhYa3plHPgy9KVuKYVerLgHqZqMThN8VE7Gu6Q/Om69ufAzZYqww7b/TTKSrZ0sC6MjvtZl+Bzm2IkjAWpeyYWr2av22g7mfjK+0vp2V2HOfx9pJ9/pQC+5/x5Jl6hmj8IV3w28frBh/qvgp7habuWa9UT43NfMU7/6EHIDM2xr6rKWgBsjC0md1QUJkHd+Eml1keh/5YooYXV2M2lR5sZD7c3tFti6RoHa2x1wRpJBtAXVsUuIW4FTLqux+NDocXu1ZPEGd87wWoOPLb1hnUnjL+MZIjsQa/o4AWXR+NOHK6OjY9t1ZEMez+0ImeE5B1rogibxVHiUIDx+Bp/9Qij
 r0KMXXvl
 rlwfcpQoNJ6ksU6qXOEjjybKq+i+MZOpHan3XxC0miS5Rpl645p0PDhncwWz3/yHhbBHO7A1FGJT+6SeFslHtXcwCw+F9PwvjDJ7yTVue6Kz67w6kFH/pE3vj9vQsh8XfCmXnSsbbwnI4aG1G4TxJ88J8w9JGRbm8HfVnYzCKt2hwxxx/9qabUh7ml5k3dwEYIi+IZ2mtO2m8YQjWl9Y7qYVFt/6++rD9QcuGmdyMRtlYuS7O1R3j+mTSb9LI5P7JAWT6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Fri, Sep 18, 2026 at 08:06:29PM +0000, David Matlack wrote:
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

...

> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 3781e2b5f095..8af20f558086 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
>  
>  config PCI_LIVEUPDATE
>  	bool "PCI Live Update Support"
> -	depends on PCI && LIVEUPDATE
> +	depends on PCI && LIVEUPDATE && 64BIT

This could have been there from the first patch, no? :)

>  	help
>  	  Enable PCI core support for preserving PCI devices across Live
>  	  Update. This, in combination with support in a device's driver,

-- 
Sincerely yours,
Mike.

