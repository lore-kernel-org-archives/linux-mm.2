Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2591BC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0946B008C; Mon, 24 Aug 2026 16:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D724F6B0092; Mon, 24 Aug 2026 16:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C8C6B0095; Mon, 24 Aug 2026 16:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 994026B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:13:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1624A0227
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:13:25 +0000 (UTC)
X-FDA: 85137262770.27.F33F176
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1F6A40009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:13:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lJcjhCS9;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787602404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RIjz5iu884zqJfy1iBWck/h3gWNzem69636ygLdEIA=;
	b=OnEktgE/xPnLaSq9ySeVY4uW+OWmMGE0lDXNqvGxIIxwvdxzZ3RsCzMjX5lv4KxnuXn9MD
	4+PPb+0vJc7V3xOotIjrox7rfWNycM8iP/9vPJMtSlQk001lr2LRG57k3gpfmPlv3LrU5X
	Oh04CCs8OPlhIeQKMZ2dQWYIylVn8KA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lJcjhCS9;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787602404;
	b=RWlKtreN/5UzTdr3gT1d7DK/FrmjlWFh/KiFu3k8tDxv0+zN2GthIpnVe0PpqvOmwb8zy3
	dt8ncAFQo9woibvJYTLI6M36dSZwSSV3k6A97mtmxA+4Yo+ynjPTkGds0y5JGE/Ud0hHJu
	r8YItDFcBOVvlQTJBzOGjIH80kvcGAE=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d3b440b97aso4915ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787602403; x=1788207203; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0RIjz5iu884zqJfy1iBWck/h3gWNzem69636ygLdEIA=;
        b=lJcjhCS9CylwnIYBL/KL0zvBYfas/8NLd8X3aoUcgyiymY3kExFfVsUGl7XRjE6xTC
         gG8Ktk9O09iiSSIRcUtHnz1Ce8cDkJ9H3ME4O8CbbT8U6RLbBTaqvuX9IC3dt4shrSo2
         2aZcM4hBx1MVafCD7EaOyiPdwD1bkBg9ijwLsFWaVGeXqziPPNmJHmFsMenivOrvFEhU
         GHuTiBKgNekhLwb+3nd1LfvKR7ej/jaRaaQKs+hsrc4jcjQ2jr/6YyuUs5HiBNKuMmHJ
         xwE2uJeskk7S5ZmcC3jFVrmmHxAMh+p3rjgpdULpM8yLoKXCRSZojlzD/xAaNdmmIZAB
         +5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787602403; x=1788207203;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0RIjz5iu884zqJfy1iBWck/h3gWNzem69636ygLdEIA=;
        b=tIzzqfBIxrO7+uQkqQxL81yoDygTTNQEl0OBhSkO6muTydgwqZVOLx+0CG24mtJQnM
         fnnmZwcbFQ7yhQKIiANHV9XKClDXtfHrYXC0vNZ0aZXPI2BDVTLUKvRb2xwJxmvy8fQJ
         xaQ7zlA3ofQPAqSVdRnoh7AI4zaIhPaq+EycrJBCbPjmE8o7FMKQnr+HDu+vUxbe6JJW
         hYhI6J8mfviuaTLSseShtiqI5CRSH5L6hoJpCnZgpha2c3YNcDFfAQk/lNtwwiWmF3XW
         YcIGKzZDv1W8Ypwy+eYckRb2SHJnt6DaCZKcfFXuiWnGGYRttZ0Vv9gOSl7UFYYlFYKs
         V+7Q==
X-Forwarded-Encrypted: i=1; AHgh+RovVgd+i3SX5uLnbcXAi4yvWjWSfotuR5QW6LecR5jza7/F0vthaBP0b6ErTuOzXnKwJAuNDWvVGQ==@kvack.org
X-Gm-Message-State: AFuF++lOJsOICTWnj1w0MacwaJLs4vY3xHb26kiqoh7M418omfGVgpP4
	MarJ9/TAZwOgpMxe6WcwFZ5I8LVBGKM3VfHoDNS6h9ImfKKQEhTm5uC0Wf/bskT05Q==
X-Gm-Gg: AR+sD13gGz5vihiPwrU54+4YV9x7kM3OMaPrNMSByEIfinQ4nv7X5NKjQzXOMpSX4Vo
	hrUk/L/a4jQcJr9+hKTw+3iPKnH7HD4Rp4DBovfBm5Amg7cGzm7D2U/TT87QO/eVfEj2Ugw6hN+
	iyyhjzzUQFkSc/hOuYFF8O8o+uNtSJtT84OAbAnvUKzAFfScf4rwnNtKueKL8BOpCK7JPsr87RO
	DoWl7hPGyxyYTZd7T7hvYQftSZK5Pnr/bjZ/b3jRUhAdS1blZ9howdq/VpWWNxusXU4yRNbO5ZZ
	vNVX18gD92GxK3emkvc/TF/qy1hzXmSfMX8l9WahoLfmIjKs3dPCcGm/mDKgUbq7xPTjXO24rb8
	/h992TEA0fogxtfRNblhcApCHvlwH0QiU0mImZO9ySax0tmnoyaJMm1aIdWHZblaUR89vFXb+hh
	FVmeQjzIDuV7PNWv9jndVxyYuk9LP843AWt33KvEanN8C10dkMxcl6UmA7qwOJSrlTEGJrpAADa
	xPs31Kxbqhqg7X/HT0eP4X9SUOVUCFDwdsRZL1lQMtMozl6nx8mirgvkCw=
X-Received: by 2002:a17:903:985:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2d6e072a392mr1090655ad.10.1787602402239;
        Mon, 24 Aug 2026 13:13:22 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b7ff6dsm795785a91.10.2026.08.24.13.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:13:21 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:13:18 +0000
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
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <aoylj_gaj7jMSXvQ@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-4-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1F6A40009
X-Stat-Signature: w8sdc66x6ns5s7nfh8t5ckte78137bud
X-Rspam-User: 
X-HE-Tag: 1787602403-182465
X-HE-Meta: U2FsdGVkX19h9+5jkP8jI0uWHNpOlqHebVEfbCcXMThTE9BIs7ac+NqSuwtgG3JJeBx9t/6OQgmQ/mnoyAOkKcMobXVKVNHQwmCbHXBNHb+WxFGV9NXONLZMXBRjGQxFutHmTGxIxk3hIrIyQcfzmO3gx2QbVC4Kze8cvFXcT6RmYL7FCZJ4+6an+nW253UgUMZkasqcUBqMBHrIn/9QyCksJKwMntfTuIWHUO9BS5xIoudLy4G1nH/O/M5A4VN7HbEbNJLti0T0S9Q0RzxtJ14aOjIHXYXaRHrCvR3If1HMKNYziOKTMcRzT9E96mRDBAJtniyOY2jTOArGF1JK/0/agW8Mf/D8L4H/PBfh5SR3St9Cci2fc8cLjnKLi+Gq1L+QVIdY+fdveNW0TKLzkcVpZzCZ4E0OruEYiKjKeEWAZBHq7n3cjMiVftSXYwnURSvOmUrnQwlOIMKKXgy5ApBxXeGCajSNvISzMvU+Uwdi+DVUjOmDCxZkmq9qHJ4AyVSLxBfdRe7YpJULeqjST6Rgxwm9YraPA9FE12q1VG7gUmn6EEIgPpht9GPH6OXK+8KdRJXylTh3ilvoOL7/t9Nz1ktxWT5Otr6wJHNm04OqogIFuHdbRvEAPK274gIpEM/zY3T8wNAyKXPbCC7dVeNY7f1Gy8MZWEglP35qvjKuXGHHkuQRMrT3AzfotypVPQktC0QO/+eMPrHdezFY2XAkcbm8Hp7hLqZBIUsXZ9gihtjPbsyaretx+fpKUdj2nnZVeB4Pda/esQEYRendighOF3je7BUvbI7HNON9rtrUhIhznVvRNq9Fb2xrQFLq1KNGIXigax9nWmL7dJhHIhsetCVv4WgyVx8Z40Ej3t5+N/sF5KzwDksL3HQaudcn2hGFlVfkCGg8NXVMNj08l4vfhRtLUjFuolSms+Gp2IE85oKhaYLpIyTFEJ85dWUPL4qSffdnw6gHDmnXUFt
 wN7Tl3Bm
 dfe0kIVQoukC4cpi5XaXJT9xToE3cukRmz5RHMklfg0tFJpMmuAB0kCdHx/LGi+MqNjXX/x0MhPAcgRAxeSdodeEnEBAOt7znRKQe/Oz7ejLQGyVd7lf7Et5oycK48ueO//ghz4AVskdEY0ubZ97K4KuC1+d2p7vRWYhbgoHoNvHa7/omlToeQKGj4MH1Pie/lUOLriQyzAzC5NU6H8Pf3jj8NRKTYeVLRYmLHBY6kaBYGn4EmFXjCrEf7tA3yKsRyP0TsehJcCS88aBxY5svDfwMrIW2CQjkPFTcPp/+VsRgsdyHKKERCfN1xKee6tEF4BOgTd+wLHO/2+m+kJRhwuIEzctzdpnuqu6S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:57PM +0000, David Matlack wrote:
>During PCI enumeration, the previous kernel might have passed state about
>devices that were preserved across kexec. The PCI core needs to fetch
>this state to identify which devices are "incoming" and require special
>handling.
>
>Add pci_liveupdate_setup_device() which is called during device setup
>to fetch the serialized state (struct pci_ser) from the Live Update
>Orchestrator. The first time this happens, pci_flb_retrieve() will run
>and convert the array of pci_dev_ser structs into an xarray so that it
>can be looked up efficiently.
>
>If a device is found in the xarray, the PCI core stores a pointer to its
>state in dev->liveupdate_incoming until pci_liveupdate_finish() is
>called by the driver. This pointer allows the PCI core and drivers to
>apply Live Update-specific logic to incoming devices in subsequent
>commits.
>
>Drivers can check if a device is an incoming preserved device (e.g.
>during probe) by calling pci_liveupdate_is_incoming().
>
>CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
>domain and bdf can be guaranteed to fit in an unsigned long and be used
>as the xarray key.
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> MAINTAINERS                    |   1 +
> drivers/pci/Kconfig            |   2 +-
> drivers/pci/liveupdate.c       | 256 ++++++++++++++++++++++++++++++++-
> drivers/pci/liveupdate.h       |   5 +
> drivers/pci/probe.c            |   3 +
> include/linux/pci_liveupdate.h |  13 ++
> 6 files changed, 277 insertions(+), 3 deletions(-)
>
>

[snip]

> static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> {
>+	struct pci_flb_incoming *incoming = args->obj;
>+
> 	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
>-	kho_restore_free(args->obj);
>+	pci_check_all_devices_finished(incoming);

This should handle FLB/FD lifecycle nicely. Thanks for adding this.
>+
>+	xa_destroy(&incoming->xa);
>+	kho_block_set_destroy(&incoming->block_set);
>+	kho_restore_free(incoming->ser);
>+	kfree(incoming);
> }
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

