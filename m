Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5FBEDB7D0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 22:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA036B0089; Tue,  7 Apr 2026 18:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC13B6B008A; Tue,  7 Apr 2026 18:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6FA6B008C; Tue,  7 Apr 2026 18:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0BE6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:58:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BDFE160320
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:58:49 +0000 (UTC)
X-FDA: 84633276378.03.3A32205
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9EA6EC0002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:58:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxT4H0gM;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775602727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMbYOgaDr/Kx+71TeWTaVBU+sUYdKg1v+oxDqlB4JDE=;
	b=cTQMJam2zeXQBQARe7qVzwS3RNclfAqe8joImdPBU01I1kJXuHtmxTF3ozskR9dJUbCDJg
	iYOP7wG5pqBygpUCCNFZwwqe5aKApIr6rvXIK483aMzy/KvQJ5l8H0RfoBdRf543Am6KK5
	pDjVqMsPpXMm/t/P7db7JEQyTuzqT+I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxT4H0gM;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775602727; a=rsa-sha256;
	cv=none;
	b=Bt+0b/hTBEvmrWouq8y7QBpaiNkHPZzz15se9adw76XTLdW1Bbvb/ieetofqY3UE5SHUPo
	1YZN7h2zHGl0nlGQg6EHW70eoefDxjAvUJpJfQRq8hiaStpy4mV1igMOlZM5e2KmZc+Vg3
	t2qTj91olOlpZPjA3/e2KFip6/ifRcU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4480660128;
	Tue,  7 Apr 2026 22:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C69C116C6;
	Tue,  7 Apr 2026 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775602726;
	bh=ZxMhQkn/NMJTsfUq+eNI5wRqTDBwCQBg1cjTyGaGSzA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=YxT4H0gMU1uiOeHwbtOxxGkfFWJBaCzthqg03Sftf8l9d186Y09INkfJ8VCpcsjUT
	 Qfd/Qlw+XjxQGpsD/+wtJtFtyh3etr3/mtV9qhSmixByvSXfzBB7nBSEJNPsodmdHd
	 n6aWnXLqcu6DDQCkFID7N0ab2dedIpF0ftmNXCcvehsYTzafVVvpTSGtJI0Yt78qAh
	 7zcrBzbK4e2mGEgKbxfT4/RQOcj3aPhgKqv9IwN+ABisbMsvBq2hQAvVVGI9l26vIJ
	 NOji8KIk0pikMh4DCWmZrmRQsTJnp7fjTB24k9B9hx+3b4Laf7gnEUw1IEsuOG28xo
	 +wM+h43SmOleg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Apr 2026 00:58:28 +0200
Message-Id: <DHNAMNISZJ9O.3B58NWX64GBGE@kernel.org>
Subject: Re: [PATCH v5 0/9] driver core: Fix some race conditions
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
 <rafael@kernel.org>, "Alan Stern" <stern@rowland.harvard.edu>, "Alexey
 Kardashevskiy" <aik@ozlabs.ru>, "Johan Hovold" <johan@kernel.org>, "Eric
 Dumazet" <edumazet@google.com>, "Leon Romanovsky" <leon@kernel.org>,
 "Christoph Hellwig" <hch@lst.de>, <maz@kernel.org>, "Alexander Lobakin"
 <aleksander.lobakin@intel.com>, "Saravana Kannan" <saravanak@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, <Frank.Li@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, <alex@ghiti.fr>,
 <alexander.stein@ew.tq-group.com>, <andre.przywara@arm.com>,
 <andrew@codeconstruct.com.au>, <andrew@lunn.ch>,
 <andriy.shevchenko@linux.intel.com>, <aou@eecs.berkeley.edu>,
 <ardb@kernel.org>, <astewart@tektelic.com>, <bhelgaas@google.com>,
 <brgl@kernel.org>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
 <chleroy@kernel.org>, <davem@davemloft.net>, <david@kernel.org>,
 <devicetree@vger.kernel.org>, <dmaengine@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <gbatra@linux.ibm.com>,
 <gregory.clement@bootlin.com>, <hkallweit1@gmail.com>,
 <iommu@lists.linux.dev>, <jirislaby@kernel.org>, <joel@jms.id.au>,
 <joro@8bytes.org>, <kees@kernel.org>, <kevin.brodsky@arm.com>,
 <kuba@kernel.org>, <lenb@kernel.org>, <lgirdwood@gmail.com>,
 <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-aspeed@lists.ozlabs.org>, <linux-cxl@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mips@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pci@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-serial@vger.kernel.org>,
 <linux-snps-arc@lists.infradead.org>, <linux-usb@vger.kernel.org>,
 <linux@armlinux.org.uk>, <linuxppc-dev@lists.ozlabs.org>,
 <maddy@linux.ibm.com>, <mani@kernel.org>, <miko.lenczewski@arm.com>,
 <mpe@ellerman.id.au>, <netdev@vger.kernel.org>, <npiggin@gmail.com>,
 <osalvador@suse.de>, <oupton@kernel.org>, <pabeni@redhat.com>,
 <palmer@dabbelt.com>, <peter.ujfalusi@gmail.com>, <peterz@infradead.org>,
 <pjw@kernel.org>, <robh@kernel.org>, <sebastian.hesselbarth@gmail.com>,
 <tglx@kernel.org>, <tsbogend@alpha.franken.de>, <vgupta@kernel.org>,
 <vkoul@kernel.org>, <will@kernel.org>, <willy@infradead.org>,
 <yangyicong@hisilicon.com>, <yeoreum.yun@arm.com>
To: "Douglas Anderson" <dianders@chromium.org>, <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260406232444.3117516-1-dianders@chromium.org>
In-Reply-To: <20260406232444.3117516-1-dianders@chromium.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EA6EC0002
X-Stat-Signature: jj51d5noc6f6xao3uxhfjqap1hxeidsi
X-Rspamd-Server: rspam06
X-HE-Tag: 1775602727-549269
X-HE-Meta: U2FsdGVkX185craA0t8t5I0uzTu2Fxgfnkyms4eFLGgtSQbnNoVYOA+fxEjsA9WrerG2glU/LYhgyzzAuo3XOewF+GbssW5uPpxG4GE/b5RCuaMKdZRpHZMSh9M1leVIFJr2NfB7Y8JPKVGQsxuhZR2RZnWdkRY0cn2tiqAX7xO11ibgcBN5HGDHf3CUQ02foMnDYzxWyoCM67XKmsw4M8DtZljQhoJrz1ti8mKv/AFamF2g3ZI8bP6gwHvEsmuydb8bm/v1aXvYB1Stdxx3/mBKGfAAseoq1SrITG2IS7GDkt35gQGIpYXkrBkdx99seK9mXZiFgDrxtU51Rs9dpivhTRc7yYkjJ49DEEBnaVU4Pjt9lMZj+qLIJTIgevR/Ss6Ss3g4GpC4qt2nXKXVuj1RCBNWG5XI2gM6ctI71mEqryb73Mr+SwIHzaF1E3aa6EyESexgopP7pkKAp3dtSSWuAdBouorysDUl1IA7mVTE5dJx0eBB6SNcuj+D1da5eA+L16XCJgxj6/EXsf2/njj2+JpQ78847cHqkdYoz99XQph92uoBnlFVuJd9D2ey6LuRA3JaDv9gzvvfhLc9mOoyGcAoWWTQyqsxEJGluqpnr+2dPx+d/Pqj77mFG5fTeuN1wBQmxgFZMAEuqVPA2Md2O+wGcpueDpmnlwTl+h9XXd4Mh+KK3RH4vxTdVacgHByGc3grbbT0sB2Q7rYRND/NToyu0Q9Zx8zlzYRo64WK0zUnVf+Xu0iZKRhFNv2We/qbfflzm+v3MOBGfjKm54WfrDcER13WBBqabTydgdt3RI2Seo1OIANx6rEOo9aG3kzSj5ZQjifoipCf8Rjxz7LHixI2s5tHE10PFQCITcrZH5xMAOBrTwpxhGhUCYR0SPYcBXnsi1X7+ffS76EXF3NgcaVVR00qtDs34D9UsY1ij5TmYEu/bVlQFc6nVIvVPAa6EwCLNQvxyTYdyRQ
 ocueCSxV
 1jbgtiss7Vf65AuZ+1FJFqFDn55CRJI3CLO+H/UU0pinAg2HtVl1R/KZXAbmxFAoIuyiJJKzKb7AcQal98OiIeLLBaxIxJCSgdZs0VuWAQJjYPCUQBDMHNndTh3K3l6EsainkMG4AVcAuEQRfPbVcsuhoU5QCs8D9zvLeoeUVNmeMoSJRBprwab84obK71Y/k5vlSD1wLnXF2YhEfeAVwA8j6OcDcmhb8E6n992hw1oAYcRIcrQWzW2sx4SinES4SylTSyQGqenaCyrXvgXLVAzYrPmr8b6u1CEPBjs1Ouv1vT8CvSL+e5nVAvbkFE77W3WXvmhvfSDxqRrJcTjnnEngA4tm2y0VoxmQF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 7, 2026 at 1:22 AM CEST, Douglas Anderson wrote:

Applied to driver-core-testing, thanks!

> Douglas Anderson (9):
>   driver core: Don't let a device probe until it's ready
>   driver core: Replace dev->can_match with dev_can_match()
>   driver core: Replace dev->dma_iommu with dev_dma_iommu()
>   driver core: Replace dev->dma_skip_sync with dev_dma_skip_sync()
>   driver core: Replace dev->dma_ops_bypass with dev_dma_ops_bypass()
>   driver core: Replace dev->state_synced with dev_state_synced()
>   driver core: Replace dev->dma_coherent with dev_dma_coherent()

    [ Since all DEV_FLAG_DMA_COHERENT accessors are exposed unconditionally=
,
      also drop the CONFIG guards around dev_assign_dma_coherent() in
      device_initialize() to ensure a correct default value. - Danilo ]

>   driver core: Replace dev->of_node_reused with dev_of_node_reused()
>   driver core: Replace dev->offline + ->offline_disabled with accessors

