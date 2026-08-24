Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E64C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8CA6B0095; Mon, 24 Aug 2026 16:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3625C6B0096; Mon, 24 Aug 2026 16:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278976B0099; Mon, 24 Aug 2026 16:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D72B46B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:14:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F2331A024B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:14:56 +0000 (UTC)
X-FDA: 85137266592.30.175EE14
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8455418000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:14:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v6IO+3RQ;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787602494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lbrx60MJW7m62aJUfR88Sv9pb7keNNeDEwmAMWLXqMY=;
	b=tOhQCNdtYdxCZ3S+feX3D1i7y6+6WaZOa+W0pfkACDm3Jep49nk0fC5G8GLUqO6IFIli/7
	y5JSDg5BvnwXEZiD0a9xv5xgxJ83wCTOOmtVXLQ6gq5SCMw9zSyopTRSDw3vcvQW2mk+c3
	hCUuOiwo4nmIKfhSJ5W0FAgs/wZXpPY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v6IO+3RQ;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787602494;
	b=x2kaqoGW23hzorxvI5eRKAJyhkjxP3bnjw5b8l3xI9WQEsgX40Ve0ihofPpF6+2d8HmHnR
	9jcSHumGrSbSPthqmYKYUFa0fi3zPt10Uul4UdnFPXBQac/Z7HyZIVfmCUnf9TqO7kLRJi
	A88gfHuen4NcnOAbNWsDuWJYcx0gALE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d3b445a84fso4705ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787602493; x=1788207293; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lbrx60MJW7m62aJUfR88Sv9pb7keNNeDEwmAMWLXqMY=;
        b=v6IO+3RQSlHNDu8N7IOAOqp97HsNhuptx+TLDqZ4yDWp+I9aIKfS5oAd0Dbpg48OeR
         f034zDBCn9PaNLxkL1FIkY7ZXDvvkYPJkhvhV3WJ3OJzqTfzM4gSqR4Y3glweBuc5mWC
         3OfsqAG/oL68Pm9kvkTAiOvhUsQB3NdKYwSqkdVAVxhgu0108lqsOItrGvCzCEm5CMsi
         L37zSOFn8dX8ZEAbKFxazaQGpWX5PjPp9Io9JiazMVZD+REgzysUavcZx6TdWoCkBT3o
         BjWWScA8OJlxFpXJHta4ADWJUF/RMwhtmdu9dYvdxfSxMrVdUW/vxxQHIzWa/sPJzcM6
         4sRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787602493; x=1788207293;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lbrx60MJW7m62aJUfR88Sv9pb7keNNeDEwmAMWLXqMY=;
        b=Osp5WXTrn98cRjBw4oKqQaB1YxHxtXEnOBsvKpdkuoGbzCSU/EGhcW7utcefSfotAH
         p55R610+YjpDT7e5s+2ROSGx5ZN2x6dzP8A4t6NR4JZVrb2ZtcFnsUaDYU6Ap/ee3iKW
         +UTnLD2cPGxXq+pebNkxSY6p1xCW41rJeqy04HtZvB7JqWZnQ3mkPvQiZS8EhzlAdyYt
         L1QU7fXiK53eVbnwyvfJYE1oCU46eDVf3LIlJcNa4eH5l9Xe/IwTOM+BCOne0tKYlIGr
         L6faa+6aVQze5hzdLGeazAmQXp8fecm9O8Dg2vDvSVKRXe+X4gfSPQMm/6huiaItlc8z
         ptqw==
X-Forwarded-Encrypted: i=1; AHgh+RrFSnmKoVP1LLteX3frK+k9rCLb2KfUTRlikaHQJ3R8qjxVOLGgfEKfAMLaBsuz1wP/FXAZiCGREA==@kvack.org
X-Gm-Message-State: AFuF++mo+KBPjEr5+EzOMcdhXqUOL4X41RdrpXYjZ32yHFsscRDMni4v
	4YnRozF/R7LZ6FJ/inPGwI2HnTHy36z4mpulCbV9IHxd4UlXqvFfYbzHTrkryYRRwA==
X-Gm-Gg: AR+sD13+VBaET/lNqsCT15tJBQ4tKGFkiOuBo6oUs/FtCoWpF7YDzqxGQCfHkCwlVM2
	902HpH8nSwQqxSe93l+Hy51NaRPhkpq8AeBQ6l6AtNPr0Xtu1oyEdsxoA1GOuG3E1A3mbVfOyOk
	FYnJib1l8fgGTYNBtvgDsHm/T0NQNCYBcXNPRW/DSAyvmIMYJ4oxJhY3XXFImxRrulnTq7qB8du
	AwJZ8kGDW3jTXIS/sE19JdqP7FQ+4oTOSpTp7b+TAUn/3FJFTLIusjfSOpROtSHEofv6LiOVULc
	8HpuUMZyOxx607bpBINgWKPrB2uy3Kd84z7uTlZVHD3A23twYrndgJnwDJuBWYdIrI8xsLItw0L
	lh7pNCMTTF+sbydPCL8/BoKsJgWCBiWbMHc7Wp6BghxoHppOwwz+B1PZ7pOWh4G5hS4AvqF6vYr
	BaKsPqef72awYcoUkI/5AALydIBBLP/rqsiBvdarDdhzHyDYD/7L6/BAEBcZrFnMNlbmu1RSeUs
	7AI9JLRckWZxApMUVY0dUjShWrKUjKDcoakUx5Eb9iYFjFx3uE1HN3KLz8=
X-Received: by 2002:a17:902:f142:b0:2c0:defb:557e with SMTP id d9443c01a7336-2d6e07f52b9mr751815ad.1.1787602492814;
        Mon, 24 Aug 2026 13:14:52 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b49e76sm811208a91.6.2026.08.24.13.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:14:52 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:14:49 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <aoymLetUiJPsqrfI@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-3-dmatlack@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8455418000D
X-Stat-Signature: f1fbf9oin5t53f7ej8bqyhxjq4iefqdc
X-Rspam-User: 
X-HE-Tag: 1787602494-288118
X-HE-Meta: U2FsdGVkX1+kX7hRRhsXNkLw5Zzxzhv/S2gmj9/Rh4O476JNBL4yrHB/zHlqO0JrqjMqG/Me1YZyf4u02tfhqPmZ3AIDHQY2Ex3O5p7+BTCwwjLGB65fkObuhhAJhdyTb4Iz9+VKrjyxs4T/5sq10AdGNbjZY4bD7H3MzNx6G1Xy+akZKyzMqIhJ2xrikO9xsuOq1Dg/Jc1RVSg64bpkKGhYb22NXU+mVVXJvNPe/8XoXtipAhXkndT0jxQBzkvwdq7bUTBwYr4LWotx4pki2pEc3Ex6qpQos+0At5Ezp/dKxnQeCor57OjG6+0mxuMH4f7oHJS38oAlUqvU9TadOsWxyIL++UfGN9LGafeuvSmn95Z3ObcJJV2CxKIsB9pzGVgBAbmGFn0Uw3TBuUxDYcpwtftEpSfeSXrI/1lrb0xAU8Xn+a0dXaU4kYkwtdWVJWr2Trclng0cpBMTfCvwBQ8Ww1HPo+2S6eCJV+mkSS6hE4YbQdkr5afk+j1imo7TKsDZEFEPUCseG9RtLL7HKBjoEhXaMfcwUGqcfmyjc5RY9lqgpKVHFIUV9LGTW+nXb85fryHCYx+AUlBxdzZth+RJYRIJtSOn/NMNuJhxc9v9hmHP/ssGmzDqdKB5texSwwJs2/nKCOKAyOQ7iUsq53A94+OA5eAB6WT1bQjMcGMtfcTrfF1q+1KVRUC0uEKWTZcCbUY0SlI44/b/GF0d5qdyHATgJho6GO6GVcG1V7pA9bGtFNsI+Wpav/WDYXqMFbTax4aQGtzrnMeve78f89+SW9loo8PUBGuV3MtJN38T8Y4Hv9mymk588mJvHiTY1rvmf9NABcEZ/ut0CVxTJONVz5PIEyMVNjPW6I67u7vZeLny6UhvYaZ7WaBNZz6NUbjIssJQMwHwIXQfncniRXkKf0gGDoIFaNSz+G7PpNLG14yD4hGM4d29Tpsq1sGNwIub2oa8ONkhF74WlZQ
 O+t3FgdZ
 glf1S+tAoC/lNIqiWmCcEx3xhpqmezPg12COxWScGc/aygmyzy5mt0WB9QRZfsTq3JmN3L0ZeB5puxLxGp8tV3Qfp0dCfJc5iKVAGHEj2CyE7Jy6HNG6UiwfrL0BKEK4vIHa7GKB0DRVo0IDfvOF+tTjzthAfOmz+iLhgwg3TTMpNZU3jJmrfOOVcObNiHWXicXeCCzOWwBFTpxfTkSiHDBPTFHIBZoTymwbxidPfaejBgV3m/aLSCVi485168bKYBPx0fJ2Vu8jdvXw43+OMEhy+IPSij7Sk/kvERAHX9481OG7e6xWAon404yWckuRaD6RNJWm2fxHySGhgsO9HA34vpB2CvPcVaHYFFyj2O50cBKN+dbM0FCaqr3vV4LdIPzTa3mtWjlo6OzD6g9YFOepNLGvacX9rRQ+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:56PM +0000, David Matlack wrote:
>Add APIs to allow drivers to notify the PCI core of which devices are
>being preserved across a Live Update for the next kernel, i.e.
>"outgoing" devices.
>
>Drivers must notify the PCI core when devices are preserved so that the
>PCI core can update its FLB data (struct pci_ser) and track the list of
>outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
>device must be preserved across Live Update. pci_liveupdate_unpreserve()
>reverses this (cancels the preservation of the device).
>
>This tracking ensures the PCI core is fully aware of which devices may
>need special handling during shutdown and kexec, and so the list of
>preserved devices can be handed off to the next kernel.
>
>For now, the API only supports preserving non-VF devices on a root bus
>(not behind an PCI-to-PCI bridges).
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/liveupdate.c       | 210 +++++++++++++++++++++++++++++++++
> drivers/pci/liveupdate.h       |  21 ++++
> drivers/pci/probe.c            |   2 +
> include/linux/pci.h            |   3 +
> include/linux/pci_liveupdate.h |  21 ++++
> 5 files changed, 257 insertions(+)
> create mode 100644 drivers/pci/liveupdate.h
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

