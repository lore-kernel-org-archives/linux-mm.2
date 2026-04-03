Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94464D6AB1B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92636B0005; Thu,  2 Apr 2026 20:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69AA6B0089; Thu,  2 Apr 2026 20:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30CE6B008A; Thu,  2 Apr 2026 20:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEA3B6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:51:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19A83140239
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:51:36 +0000 (UTC)
X-FDA: 84615416592.10.ECEF5E8
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 496DC4000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:51:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=boiWIGrh;
	spf=pass (imf17.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.176 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775177494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lb2HYWEQxB/om4yhyjxjNip9666HK8Fi8TGkiu9j7VQ=;
	b=IaLLJ1b/BuVzg/jQA26RyFGXB6F3ePg83qDGm/uVtJ0LJz1u5rxIg4zLKzS2jFPHtd5eR5
	9X86kUaXbhNKHRU2olrps/RPvajVmsh0Mc0hnQ7YPRS7MxWIg4dRXzRmq/kOpGNcDGpJHe
	5Ytu+R11kOIACsXgXwkJzXeVTjA8ft4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775177494; a=rsa-sha256;
	cv=none;
	b=gU21GX8nA3g92jyHClwlMITbVBicoEYwPwYGsq2Zs9gEHUyYC493MYfwi2QlTVsfzogq3N
	/Ho2Vt9pVbtdWM+679Q0oawrWXZl8kHRqSnbEay6vWjPr9BDAIQ/BTFL/5hjIIw3MQUSWG
	YGuIE+EOXnbrd5vBcfjz1GTgOj9J3HA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=boiWIGrh;
	spf=pass (imf17.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.176 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2cc1534e026so206283eec.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 17:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775177493; x=1775782293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb2HYWEQxB/om4yhyjxjNip9666HK8Fi8TGkiu9j7VQ=;
        b=boiWIGrh1gZ202QHocOEO7h2fMS2/fs9cnj/r0HtEth4UiA4hGfzZ8zx94CTvwRwPE
         SOwlcUrGR09AFp4CeeIeOmMfecYVxERb8yjttVFqSjludhGW3afTzbIDhIiJ485Ri+LD
         l9TSYVj0D5W5l6+x64Hq7N8h3FE+dERzb2VA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775177493; x=1775782293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lb2HYWEQxB/om4yhyjxjNip9666HK8Fi8TGkiu9j7VQ=;
        b=Ot0NGwvi4sPRLG9txUBiPR1FyfwgBv5+brl94epRU+EpQIr7jdTl6D3E+3sQ0/1MdB
         OHOe0c1YVk2m+GTB8ItryfbDHuh16JfSVJDHtw3ECq3Wx6K8z7P6kDC+/hdhf/PQ2pHc
         zsHFORqG61pvRRenllCJOK6PbFseIq4baox8mgCYaJWUJa39drAf4CZEUemB9xx2RaoG
         KYFtYGpnuQUYYk9/HMznmtKNfJxBmwGuiob0A5ATKM4LjqKfjAlCH+SFCHcqYuotuwrq
         dhqahqojzuiolkv5DXEN20oeDw0MxPL/FW2/V/SnoUoiBJr88UZMRY+OrTFOypfV/Ls5
         0WyQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4LwQb37Be88r3fX9ZkfP563nR2F7bt2YtHNT1vQ0LwXWj6lZ26p7L7SLI+8CDsBdbZPN0mJWMCA==@kvack.org
X-Gm-Message-State: AOJu0Yzg9moDmi5Z9M3dy1U8ZCIGJ7fQeTvdzngtii+ypFLPmu/7YL9Z
	a8GTRbIB7r1+hMhi7Dtdqq/SWa8vF+lsOZENa9MVT5KjbOTRXl0GdY6fm95/V+bETw==
X-Gm-Gg: AeBDiesu3geDoYKZswsWI/aqAMj9T3OvSTLiN8+J0q8vu0QTNe26MAScRfEKyqDxjB5
	vw/BG5Pjk9KTkPB8Q1jO0LaM0Im03Ou55VaRMZNfvhhbWbeEEvD/oiZ2WlGqlDcAqjFSAC0t3Zs
	W9RxQVV5NHHCP3uaob1xNOip0Xumiep0ykPFhsBKivW5dMEhjEQluNGDPS/ZoFZMhzV1TdgKQtJ
	CIxpHyCsjPdJIy9RmeplV6SO1INX7ZeJJbuLllaQLvJKvWacSUxlvT/eMQpKar3uXTYVQKTJVWP
	quSlqOqZnsmQw6Oy82eO3SzW/VuiIJ2sJtcVJKbb6DGciBVxo+6/dAQPLJPFEQu4d+fyTGfcKOL
	DxaYJRHlLNYkodmyUN3wjI1HpDfUCF2I5SxHtvSvHvwEYOqYxb5x2oqyisYUkdjBiEWYGFxxQmO
	i1GbXeYpWCpdDjyMYkNceilsckqjm8LkrK7YmefrLK2GS7WIscZJ7o6M5LZU4ekSUMG9KbAWyC7
	OsghjK/DlE3blQyujNEXg==
X-Received: by 2002:a05:693c:3009:b0:2c1:558c:16f7 with SMTP id 5a478bee46e88-2cbf950392cmr655589eec.6.1775177492780;
        Thu, 02 Apr 2026 17:51:32 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:5db3:7542:a530:f43a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca78df3b84sm3630074eec.5.2026.04.02.17.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 17:51:31 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Burton <paul.burton@mips.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Christoph Hellwig <hch@lst.de>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frank.Li@kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	alex@ghiti.fr,
	alexander.stein@ew.tq-group.com,
	andre.przywara@arm.com,
	andrew@codeconstruct.com.au,
	andrew@lunn.ch,
	andriy.shevchenko@linux.intel.com,
	aou@eecs.berkeley.edu,
	ardb@kernel.org,
	astewart@tektelic.com,
	bhelgaas@google.com,
	brgl@kernel.org,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	chleroy@kernel.org,
	davem@davemloft.net,
	david@kernel.org,
	devicetree@vger.kernel.org,
	dmaengine@vger.kernel.org,
	driver-core@lists.linux.dev,
	gbatra@linux.ibm.com,
	gregory.clement@bootlin.com,
	hkallweit1@gmail.com,
	iommu@lists.linux.dev,
	jirislaby@kernel.org,
	joel@jms.id.au,
	joro@8bytes.org,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	kuba@kernel.org,
	lenb@kernel.org,
	lgirdwood@gmail.com,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-serial@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-usb@vger.kernel.org,
	linux@armlinux.org.uk,
	linuxppc-dev@lists.ozlabs.org,
	m.szyprowski@samsung.com,
	maddy@linux.ibm.com,
	mani@kernel.org,
	maz@kernel.org,
	miko.lenczewski@arm.com,
	mpe@ellerman.id.au,
	netdev@vger.kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	oupton@kernel.org,
	pabeni@redhat.com,
	palmer@dabbelt.com,
	peter.ujfalusi@gmail.com,
	peterz@infradead.org,
	pjw@kernel.org,
	robh@kernel.org,
	sebastian.hesselbarth@gmail.com,
	tglx@kernel.org,
	tsbogend@alpha.franken.de,
	vgupta@kernel.org,
	vkoul@kernel.org,
	will@kernel.org,
	willy@infradead.org,
	yangyicong@hisilicon.com,
	yeoreum.yun@arm.com
Subject: [PATCH v3 0/9] driver core: Fix some race conditions
Date: Thu,  2 Apr 2026 17:49:46 -0700
Message-ID: <20260403005005.30424-1-dianders@chromium.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ijutmmaytu9hsuyzwi6n5jif9gjuycat
X-Rspamd-Queue-Id: 496DC4000A
X-Rspam-User: 
X-HE-Tag: 1775177494-135721
X-HE-Meta: U2FsdGVkX1+AjwqzPdfDb0F8t6vTYpC0NH8zCSBKxaUtRBcbkOJcybvA+mV2kqxB9v3FW7RBTVf/ZcP712G3hkoGA12YLlVfI5RnRKS1x4r5DlOqVjCCP1XsMmhsE4331NFBUrJI+lvaMYK2GJuLDe+C59+ZthhSsqHHoRY5mu2/gBuZh49SuOpdC0S2va37sH2JtVMaLU1jY6/Z6wz9TW5uGHwRwDNNmojnLQv0kxLc6YCsfoz/rEC8xJb2LG5reJLM00pKVnTCv3e8szocb5AY9qY3iXafehJQFM1eACEjwW4KyL94WJVoKA6w9Jk0/HypJD+D+RiGEeRZvpoKznt0fkVvTfU+RPqTUSHwW1A6wU/ubWvc8MxdYyejsD9E+KZ8J0xlBoAv+1K2m151cmbe0F4Ma0JbgbUPdiUAuslTvLgyfaO58c0Ia0hTk50qxTcjj2X6fy9llCoQgWTvTgcR0Vi1VhOvj3d2k0qGx/TFLEdwlFGPgWEnO+dL83wGWbJ0/HmhnYZkoh8xSpCAM6WQ/BoF8Q4Ruu4MGqtjnEp1S9t/70dTx5wf8NgtTz373nnM1GWPwYdTlndgxh9sQ9fh7RzpeCtklMBlA08SG10ZR/W2ljnlzIiiZTuNZhgXna41WX+sYWub9PQ0I2C84o8tpkNTAJiK7HOZQnqGI7MoSch728V7pg1wCLH4oQhsrXAvJnACCPV1Q9yJyfNQkT0CpAKKo6e5lygmFWCRJAOwmhMs+6xxSmKO4ZmWsyTDZ9FOsUrJG8FH+X2FUdi++XEbEglN6KOOYJ1rTMr6Ot89vv9+ticExQghJrZ9dVmXyEuDTER+YD/kdd6cTEluT0tDSFGZxaysIthoPbqiJRjbU8aEVlmpaf4n+lGtf9b02L77f8MPDLl/uLM1m9aB7ospVQvtMu947Oj1A3CXtpxnV2D6IFnwhgDeoRB3x+vNZ+7mqd3WaoT9s5zuoen
 JDnKtqQE
 isLqw6T1IX+y8b/mGTOlTbDCE939wJc/kRMcK3DXmnK3QMFaV9+S/qOtxT0WXnKRUbkHLe7XDYuEP+6dGZds29xPpE/e/HKKExm6dGViwSxa1+Q9Vx/B1TTqFe8Xhj0i8rS9CzL8nBW+T6CxgvLcz1S8l6cj5flQxn8Xl584vtivJcfkw0fuHKha3zjG2Dv1bp3AwFVcW8qdPX4+LutZIkCA6V/n3XUZRBw/Q9scOaNHnXfGFnGarBaNtR+DOIb6Ok4UrPrvJsPCQrVS0La6YkHcc8Jdcj5OLcS2TNHRwY/DscsI8eC937q8KHZ8yPnLob8ooX45KwBKES0qUNn501JanFaOUZEUV5YZ8La6IzHjCh9Pb92k1DoRDqf3hEi6w7w3ooGM2mhGAlxbDHlTqWds89TliDw42fpd2Cvtdhkv+e0HZXivxfT8ML9V/JiSefW9xq/bXByu3k1XQFEjLbWwrcBcOCNIl8Tiu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The main goal of this series is to fix the observed bug talked about
in the first patch ("driver core: Don't let a device probe until it's
ready"). That patch fixes a problem that has been observed in the real
world and could land even if the rest of the patches are found
unacceptable or need to be spun.

That said, during patch review Danilo correctly pointed out that many
of the bitfield accesses in "struct device" are unsafe. I added a
bunch of patches in the series to address each one.

Danilo said he's most worried about "can_match", so I put that one
first. After that, I tried to transition bitfields to flags in reverse
order to when the bitfield was added.

Even if transitioning from bitfields to flags isn't truly needed for
correctness, it seems silly (and wasteful of space in struct device)
to have some in bitfields and some as flags. Thus I didn't spend time
for each bitfield showing that it's truly needed for correctness.

Transition was done semi manually. Presumably someone skilled at
coccinelle could do a better job, but I just used sed in a heavy-
handed manner and then reviewed/fixed the results, undoing anything my
script got wrong. My terrible/ugly script was:

var=can_match
caps="${var^^}"
for f in $(git grep -l "[>\.]${var}[^1-9_a-zA-Z\[]"); do
  echo $f
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = true/set_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = true/set_bit(DEV_FLAG_${caps}, \&\\1.flags)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = false/clear_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = false/clear_bit(DEV_FLAG_${caps}, \&\\1.flags)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = \([^;]*\)/assign_bit(DEV_FLAG_${caps}, \&\\1->flags, \\2)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = \([^;]*\)/assign_bit(DEV_FLAG_${caps}, \&\\1.flags, \\2)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var}\([^1-9_a-zA-Z\[]\)/test_bit(DEV_FLAG_${caps}, \&\\1->flags)\\2/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var}\([^1-9_a-zA-Z\[]\)/test_bit(DEV_FLAG_${caps}, \&\\1.flags)\\2/" "$f"
done

NOTE: one potentially "controversial" choice I made in some patches
was to always reserve a flag ID even if a flag is only used under
certain CONFIG_ settings. This is a change from how things were
before. Keeping the numbering consistent and allowing easy
compile-testing of both CONFIG settings seemed worth it, especially
since it won't take up any extra space until we've added a lot more
flags.

I only marked the first patch as a "Fix" since it is the only one
fixing observed problems. Other patches could be considered fixes too
if folks want.

I tested the first patch in the series backported to kernel 6.6 on the
Pixel phone that was experiencing the race. I added extra printouts to
make sure that the problem was hitting / addressed. The rest of the
patches are tested with allmodconfig with arm32, arm64, ppc, and
x86. I boot tested on an arm64 Chromebook running mainline.

Changes in v3:
- Use a new "flags" bitfield
- Add missing \n in probe error message

Changes in v2:
- Instead of adjusting the ordering, use "ready_to_probe" flag

Douglas Anderson (9):
  driver core: Don't let a device probe until it's ready
  driver core: Replace dev->can_match with DEV_FLAG_CAN_MATCH
  driver core: Replace dev->dma_iommu with DEV_FLAG_DMA_IOMMU
  driver core: Replace dev->dma_skip_sync with DEV_FLAG_DMA_SKIP_SYNC
  driver core: Replace dev->dma_ops_bypass with DEV_FLAG_DMA_OPS_BYPASS
  driver core: Replace dev->state_synced with DEV_FLAG_STATE_SYNCED
  driver core: Replace dev->dma_coherent with DEV_FLAG_DMA_COHERENT
  driver core: Replace dev->of_node_reused with DEV_FLAG_OF_NODE_REUSED
  driver core: Replace dev->offline + ->offline_disabled with DEV_FLAGs

 arch/arc/mm/dma.c                             |  4 +-
 arch/arm/mach-highbank/highbank.c             |  2 +-
 arch/arm/mach-mvebu/coherency.c               |  2 +-
 arch/arm/mm/dma-mapping-nommu.c               |  4 +-
 arch/arm/mm/dma-mapping.c                     | 30 +++----
 arch/arm64/kernel/cpufeature.c                |  2 +-
 arch/arm64/mm/dma-mapping.c                   |  2 +-
 arch/mips/mm/dma-noncoherent.c                |  2 +-
 arch/powerpc/kernel/dma-iommu.c               |  8 +-
 .../platforms/pseries/hotplug-memory.c        |  4 +-
 arch/riscv/mm/dma-noncoherent.c               |  2 +-
 drivers/acpi/scan.c                           |  3 +-
 drivers/base/core.c                           | 55 +++++++-----
 drivers/base/cpu.c                            |  4 +-
 drivers/base/dd.c                             | 28 +++++--
 drivers/base/memory.c                         |  2 +-
 drivers/base/pinctrl.c                        |  2 +-
 drivers/base/platform.c                       |  2 +-
 drivers/dma/ti/k3-udma-glue.c                 |  6 +-
 drivers/dma/ti/k3-udma.c                      |  6 +-
 drivers/iommu/dma-iommu.c                     |  9 +-
 drivers/iommu/iommu.c                         |  5 +-
 drivers/net/pcs/pcs-xpcs-plat.c               |  2 +-
 drivers/of/device.c                           |  6 +-
 drivers/pci/of.c                              |  2 +-
 drivers/pci/pwrctrl/core.c                    |  2 +-
 drivers/regulator/bq257xx-regulator.c         |  2 +-
 drivers/regulator/rk808-regulator.c           |  2 +-
 drivers/tty/serial/serial_base_bus.c          |  2 +-
 drivers/usb/gadget/udc/aspeed-vhub/dev.c      |  2 +-
 include/linux/device.h                        | 83 ++++++++++---------
 include/linux/dma-map-ops.h                   |  6 +-
 include/linux/dma-mapping.h                   |  2 +-
 include/linux/iommu-dma.h                     |  4 +-
 kernel/cpu.c                                  |  4 +-
 kernel/dma/mapping.c                          | 16 ++--
 mm/hmm.c                                      |  2 +-
 37 files changed, 178 insertions(+), 143 deletions(-)

-- 
2.53.0.1213.gd9a14994de-goog


