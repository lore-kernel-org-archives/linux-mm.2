Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287F4CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D0D6B00AD; Fri, 26 Jun 2026 04:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103ED6B00AE; Fri, 26 Jun 2026 04:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041246B00AF; Fri, 26 Jun 2026 04:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D145B6B00AD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:21:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6704FA0397
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:55 +0000 (UTC)
X-FDA: 84921370590.19.DAA49AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACFEB40004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLkaMOoe;
	spf=pass (imf12.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462113;
	b=6NuGFrSHQHnDV4bg8ZUW/ReHJ6oU21iXwgEJgE15e2tGhwAR/nD4gOgabonZNvLOP8Ndc4
	MJVzrFY5SLye/U21oQ2Al3FqF7osGNeP2jRW3zb8VP0bbIdIeC+3Rh7snhlZkVNdZLHeHw
	2r6ZnEC5QyNZE95lTedx0L7pMyCmUwI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N6xFs6HldNaJtHXB+1so7kMQ4CsatgFOfKvzUpfQ6c=;
	b=rAwWTWpJ+T2Xq3WEzzaDZj01dJi+pNn1f3yrH9SApkAi4YftHulJZ0J3b6pmdvtn5Sh5dm
	V68UYaKgORhJBrZKN9JA9+xGCED4wsZpiUxeicsQMNDT+gBbJuw8zl/c7pDNwXlgBXQcBV
	QvS+ubKqhxeVG7QkrvvGB+4OtNETUtc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLkaMOoe;
	spf=pass (imf12.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 085944430E;
	Fri, 26 Jun 2026 08:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDAC1F00A3A;
	Fri, 26 Jun 2026 08:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462112;
	bh=7N6xFs6HldNaJtHXB+1so7kMQ4CsatgFOfKvzUpfQ6c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DLkaMOoe7jjLq0zrWVM7g5T3weWBVn0GKvdUrsWL1NS6Qs/YGb/jSI/OCz0xvfzqS
	 Qaym8bn+YQ7Yv3mFvqa3JZPMQyeTT1JkI61/DRV2mqoJOQ6RCZahCcrN/sZ0P41GxN
	 lQMkVEyzffwbljfjI4cRAmJFH6TA/MXXocYqdJ0r2fyaFbY7MUFYbzOT2mQ1bO9ESQ
	 aXENlZ4+KidZLyWpFEQCN/4TQ2SdvjPzYQw0gZqKyFHWnTN9MR5o7FqI9NLTieKhiJ
	 eEE7hw/g70YQVjdOMlBaDUGyYwudw/LY4An0H/3ioGWkJoeS59H947CE7rYTKgUHWr
	 baMoIKRFCt04w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199D639389E8;
	Fri, 26 Jun 2026 08:21:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/9] driver core: Fix some race conditions
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246209959.3816447.5329631417058038374.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:21:39 +0000
References: <20260406232444.3117516-1-dianders@chromium.org>
In-Reply-To: <20260406232444.3117516-1-dianders@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-riscv@lists.infradead.org, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, stern@rowland.harvard.edu, aik@ozlabs.ru,
 johan@kernel.org, edumazet@google.com, leon@kernel.org, hch@lst.de,
 robin.murphy@arm.com, maz@kernel.org, aleksander.lobakin@intel.com,
 saravanak@kernel.org, akpm@linux-foundation.org, Frank.Li@kernel.org,
 jgg@ziepe.ca, alex@ghiti.fr, alexander.stein@ew.tq-group.com,
 andre.przywara@arm.com, andrew@codeconstruct.com.au, andrew@lunn.ch,
 andriy.shevchenko@linux.intel.com, aou@eecs.berkeley.edu, ardb@kernel.org,
 astewart@tektelic.com, bhelgaas@google.com, brgl@kernel.org,
 broonie@kernel.org, catalin.marinas@arm.com, chleroy@kernel.org,
 davem@davemloft.net, david@kernel.org, devicetree@vger.kernel.org,
 dmaengine@vger.kernel.org, driver-core@lists.linux.dev, gbatra@linux.ibm.com,
 gregory.clement@bootlin.com, hkallweit1@gmail.com, iommu@lists.linux.dev,
 jirislaby@kernel.org, joel@jms.id.au, joro@8bytes.org, kees@kernel.org,
 kevin.brodsky@arm.com, kuba@kernel.org, lenb@kernel.org, lgirdwood@gmail.com,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-usb@vger.kernel.org,
 linux@armlinux.org.uk, linuxppc-dev@lists.ozlabs.org,
 m.szyprowski@samsung.com, maddy@linux.ibm.com, mani@kernel.org,
 miko.lenczewski@arm.com, mpe@ellerman.id.au, netdev@vger.kernel.org,
 npiggin@gmail.com, osalvador@suse.de, oupton@kernel.org, pabeni@redhat.com,
 palmer@dabbelt.com, peter.ujfalusi@gmail.com, peterz@infradead.org,
 pjw@kernel.org, robh@kernel.org, sebastian.hesselbarth@gmail.com,
 tglx@kernel.org, tsbogend@alpha.franken.de, vgupta@kernel.org,
 vkoul@kernel.org, will@kernel.org, willy@infradead.org,
 yangyicong@hisilicon.com, yeoreum.yun@arm.com
X-Rspamd-Queue-Id: ACFEB40004
X-Stat-Signature: go3zb9rt9g99h4afywgcyd314z6amp8c
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782462113-18262
X-HE-Meta: U2FsdGVkX1+5IUwTxvmCWEBaU8bw3GtmTKqKmuwXW7bIC45hxaioJBWcph7AKXWayX7sswrAnJDoVfjKhgZU6fq32qheLR8cGuQZYXVzYJFx/wC7cf9UU14EN96yoBfb4NoRCTVf2R8Ku3NRoJw5Fk+WlbIXKkMV8WnezLHUrKfdP12ElwqYaaSsB+UAqtHJHXP59lX5tDHb53NkDbR/TU2MtCPYP+zbMuli6qOsEycsrwczUGHhOZr8Gj/vzTPWjP81/vhLw9yvMADmtyttxC/QK38be+Nj6LVsZQfiucMExAlneFzNiiZeN2T8qwj8Sav8LtWHihwH12v7HLaSRc1lHxrLNBnkRRf0RZWKKYIKw/eTJEcCIpOW+EkaFKnZFb630DXr9toaZUQmavgkhS3Im61xlMgxuN505xHgOpUgu2S3yxvAuVwvKeRNYh4E2ApNXy8EXVI3HTt+dSUlPGLoa+4Zygq9sUb5gQdtbPaAsB5v2dX4VNh6KF4c1YDAKzblZP429DMNIx+OqXvpPvh5fFEs2bSiTOsby0keuAIOhTt7Mxr+aPswBhh1An4mT16KBoKN9yzKg4lC0Vcvn+yvaf3FPGXVDDzPxlTTiIi+cZo1TAkbacKF/PlDhBXAuHGGiQEeJ3UgdxbJyd+wrlnr5QLMEK13qQFhe2CUEcurbqyXmpuelaJls3xnEP/6xyIR0TCBiacmTyjgv9hbNwRj6QUYS0BGaHImjeTGVE2rQXnaLbuwyDGF7SPJNzlP0vR/0r8BYwjIRX3MA6Q1yoZOeaXH9TN8F+kalnyJqFIRvqvQVdichtiVFe6pFdcNtPQTaqiIkkTeG6ztpZREnTSIMjbwHjqANt8EG78KH0Ce7ol7Qr6akIALSEwCfCIemEDOansfKHwHf7FjfH+M9F1ybp1iQtqN2OtQHGGcAd/2h7YdV/2+4DNwHeC8ANyCpQb9rICXDRCSbrFnD3v
 /RtwG6dN
 sSwi23ond7Wek7E7+CXlGneGDcmulTXluvDvBNDEGTOzvPbsiEb6MPDV3DbuiJGAa8uEZt3Oh6YkupDwzzJ+PgqW7H4+gz1YkkVGjacjFbsMO+1tPRj99jz0+88I3hYnVu3AQnjicfxWMzbcjtkVu069ECt6wfLll1qsZ/AYODMDdvpuIQozeqLSU9nD9j2dl4oqudrW7UEslNfKFjf+ER95QwHYUC7KpQ9Ag/EdOziyiCWlzKb6uTJGojrxLDzJ/0eLfBFI2Q0q/ej5fLMQEUpNpNI1EAHAYaH2PZbbU68JaYfRC2RsmK0CXmTmzOYK8pRl8FUVUOhA/byOzcolM04Y+b7D7GWWRVjtN+pEQ8k0jFlB+STXvmQY6r+WhK33zwQ/1uI2RdV0+PWVP8/QesjnEsvuscrmBfI+dAczh3j3EWYJVNZrGSprJJoYlcrw7MnXRy54fuJ2SaCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Danilo Krummrich <dakr@kernel.org>:

On Mon,  6 Apr 2026 16:22:53 -0700 you wrote:
> The main goal of this series is to fix the observed bug talked about
> in the first patch ("driver core: Don't let a device probe until it's
> ready"). That patch fixes a problem that has been observed in the real
> world and could land even if the rest of the patches are found
> unacceptable or need to be spun.
> 
> That said, during patch review Danilo correctly pointed out that many
> of the bitfield accesses in "struct device" are unsafe. I added a
> bunch of patches in the series to address each one.
> 
> [...]

Here is the summary with links:
  - [v5,7/9] driver core: Replace dev->dma_coherent with dev_dma_coherent()
    https://git.kernel.org/riscv/c/3e2c1e213ac2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



