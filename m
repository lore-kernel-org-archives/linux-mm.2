Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E9EFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFDF86B0088; Mon, 27 Apr 2026 17:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5A56B008A; Mon, 27 Apr 2026 17:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBEE6B008C; Mon, 27 Apr 2026 17:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF326B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:08:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67E8B1A0312
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:08:04 +0000 (UTC)
X-FDA: 84705573288.19.98BF37F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED5F1100002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:08:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGEjjy4F;
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=nULIG7ClBBNI/AWIbW76qlekbMCSvE2pfN+/Fn6exkg=;
	b=AQMDtD3S6uGdf7Wno7Iop4eOiW3q5uHq2FM87w2ZyuZgpTBcVyAudclFk7P6I5IsnApUau
	D/VwRNhEjDz9BICoFXqaxk+akESOs9xN+w7ypZyxHMRZenyTRZZsCxd05JgJyeNBSvHsTn
	KN132rVEef2/ROXVFECaT+pO62+ywb4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGEjjy4F;
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324082; a=rsa-sha256;
	cv=none;
	b=ZyFmJOrcF8Kwd7+A0s69PhfWhMgxM3qD4oTz0PFyhmlEnRqKYcmTHCYdLF0CfmzF46zDro
	plLPpdXCboqAjYoHzDnOYu9IhaL7rWLqq+bib0CLyk41wxsbbKtPJu/SK5qpNFBaS+y6RC
	ht+0TFchoeql45LMJIiop1+HzGPb5p4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76E9160139;
	Mon, 27 Apr 2026 21:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010B0C19425;
	Mon, 27 Apr 2026 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777324082;
	bh=HAhIww82BvlkJia3sROkCN1IHhF5mIbxG7w4f+smGgw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=FGEjjy4FAaFY3A5PuDOdwJ8Xj4EEJiA4g1yL5cIGR7Vn92lO9AV/7gQgs0RIJp88+
	 RSTByY/JniJOtzZ0Blkp+9wjKoA/q3uA/W4Os0CJ2ORUAWPdqd+ACdpKfo/pIUhQ/n
	 Qz/f5MkmYFlb4sXREbt/X0QQc7hmBvgosVjVBeM8qOrO81b8+/BOPDEXGa885+Ix5I
	 avII16tNuOj8GG1TOOxM4oUwXtc8+P8ELkjcrD4GHUMnMVFQWLd8ZhsTj4bKZOsp2d
	 akjmbU2gDr8yaabA9KPzS3D4e/OQNnGX3sOg3vJEwuK7mMSs6wnM/Ur/TEtpTvdF36
	 lF/CQTdsWnCAQ==
Date: Mon, 27 Apr 2026 16:08:01 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
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
Subject: Re: [PATCH v4 10/11] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Message-ID: <20260427210801.GA185338@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-11-dmatlack@google.com>
X-Stat-Signature: g78qaxy7wztu4hgy7idjqdxp7x6nq7oh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED5F1100002
X-Rspam-User: 
X-HE-Tag: 1777324082-376261
X-HE-Meta: U2FsdGVkX1+VSrwBcA/MmZMFN0wTgnXgeoYxo9qjCReHm4fnItK7hNexJ/UGAyzS3ul118kpySQV72TTBBuqnzvnBiTyFAkTXtlIhqUGW1T/3PmS1vmUfyNenE6hWW7wQLcCvcOX/ZY5x0019ojUdquBVH+2s7kAjoItXo17O7klo8qdpqpzjN2FHgUFXQtKJvVOvmUh2pZvC3BvYadMRpbDpYR7FERpVEvZIgtoZJw767vbPhyFb+wr6Fo2a2yBCsjjvd+YQBXl67DpSjzcuXRpmsNan2UAvGi0epjTQXRvsnOG52inpaaRvBe3wxXYyttOwvPUkNVCU6tl7KwsMzFVjKxIyEGL41mhe+Ub1BimCZM0DreZfckd8DZW1VpRQ43ei60DnshXH16MEjLKmjdlrEdjEHtIz6ZeXKE8Kx27SgB/LSsPkR0LWIOWaJ9NxPprUMzOWjwkKAnvF99nAIK8SNf3yB0hUtA7uG934ej3iLMWEhwHfV1yywM9k61dRwPdqCurmsnWGjKMIiZOq36V+eCnaHCDgiE3L3fSC3v24/aZZ1HAlj1rNXr4ZBwJ3xB2ePecx5vMRB/ujHk/WLaHvqHdDZyG90pIM4TYEbm2yrxJYA7/I5AWpyqgimWAsQItEfF4TKzusvQpfoJ//hLoZ/KcBWKsBFDjHsf+orm0mnDYUgRotT/J7hi2d/VFwcIu8A4IQ6pJr6SCYxFy+2FtGH+BH4htqDt04ImrFG8M3PhSaQecdmebn/fwViSk2nyHTMjQJtKrtntK1tiFtDuaKH1b7IyOS6qjUyLhrZ6qWvOCpFNfx3J6LQiNDD8IjI24AR7S66Rf2T5WNDsGM4aY0Z+gtNioBead0BMb6RT7Z/oBiOa3PWGJrfSy5bCsZwjvHDSnT0ZBqmsE9HqHgGrXrLcpQoNx0SUt8zH8YOxh6xq7wsEqMlxrYIGiYaE9Tq9xBScq/E9ZZtp6FYB
 /EMVSkQK
 d/jpOoL+nt8nfeDRXBi0bPKxN+XAPYdcfk7qaOM+KywigZJiiCj6JT7y4HyxNMkq4Q6ym9+eiWE0yO/ri7tveIJpo47MG34eApCNK2rug1W22ck/v2bktzn6pZLFMVsvdX8uBpp46vUIMSmoPh7iFTWIu5Gciqz37yCpiXnj/A66o7iJ0J0tCoZfCmrqi/BJwmsm74gvl3w9ihKX3K4S+7QMof5XsSuvMG/Ng5OKSimpaMK35GyARo7bXqCmprf6XgfNk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:14PM +0000, David Matlack wrote:
> Do not disable bus mastering on outgoing preserved devices during
> pci_device_shutdown() for kexec.

> +++ b/drivers/pci/liveupdate.c
> @@ -132,6 +132,10 @@
>   *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
>   *    preserved devices to ensure that all preserved devices on the bridge's
>   *    secondary bus are addressable after the Live Update.
> + *
> + *  * The PCI core does not disable bus mastering on outoing preserved devices
> + *    during kexec. This allows preserved devices to issue memory transactions

s/outoing/outgoing/

