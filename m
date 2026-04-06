Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C529FB5179
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 23:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A696B0088; Mon,  6 Apr 2026 19:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB4B6B0089; Mon,  6 Apr 2026 19:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3066B008A; Mon,  6 Apr 2026 19:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08FF96B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:25:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B64E28BF77
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:26 +0000 (UTC)
X-FDA: 84629714652.24.1177E95
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id D09968000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JQe9wocs;
	spf=pass (imf02.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775517925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e+LsTmUaKDUP6TtbtpmsofePBR8TWMvjJHv9+/xi4nY=;
	b=RVdNGJ0yHcguMPiz6na4c7Bj30DzruD/7wusa7UBhdVmEgbdi5u9rEJhoEyWUsLDlcj89m
	7mXREy0CJzr1gWKztNKW8qAvXBta0QWNz8P9Ok/N8tloJUgM4oNIJYcs3GT2hlybxokqMl
	VHdTHq7EKCBO0hYMBjCFg+30KeK7yzA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JQe9wocs;
	spf=pass (imf02.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775517925; a=rsa-sha256;
	cv=none;
	b=tjyya+/acbT7SUKRpkHkMw3mx0Z6lzkdlzioYZV0Vfv6lKuk3vrs13tJ5ydm+mRUBKm7a1
	EcCf8+JI1us3V/ZzG31qd1byi0WbalwlEf0sWm1HLREcFLKWW6uzr8uaPbzcoHnme8VWQQ
	/o+R00Ja8J5G6pyVbp9DboGc6V015MY=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2ce102afb0aso2630000eec.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 16:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775517923; x=1776122723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e+LsTmUaKDUP6TtbtpmsofePBR8TWMvjJHv9+/xi4nY=;
        b=JQe9wocsGq7o6QFU/W5FDb0/R+h4ej0BuvVsuh/tOjiQ1A28UwkvTmtscrKzKKXnlZ
         u7TBmurkSVIwt54eaLZ00T+BDMfl+Ba013ro9mnx+MUlkeMoUcxBDhJ0brraMbsL7Lvt
         URo4Q3FR8UoRgEKNJr30q1cDRt0GtNU9vkG+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775517923; x=1776122723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+LsTmUaKDUP6TtbtpmsofePBR8TWMvjJHv9+/xi4nY=;
        b=Wp9TV0To/LBZ+XrII7d8CikUpytX12t5ba22b8c3vdGlhrJup8QRjSlNidJvggj/nG
         KPcLremFFjHGpcjWMCf6gPrXPfsHFYlfLeIHupPt1wY0ryTN6wuKthjxoP4HyFNC3gN2
         hZNxGTWdF9Q0yNaYlvB8tAYNkNgr0Ocun33SAiTrOpHN2NHyf1bRHgWIZXud0hHMxj6k
         Munfi9pyBphnTbW87s1DI1aKVa4isIlJRZU9nYUPF3MUpIMT8x27p0j1NFIYzEK2IXoI
         F/mSH18kEqKCQl1QdBIYgIBaHhsxyJ11m4TVmBuZWBgD46elye5vguXnoohHJlwvFKcQ
         1fSg==
X-Forwarded-Encrypted: i=1; AJvYcCWR49+c+MJrGBkWlL3nadwbY++E/Mv8hAbrhq+TfW2ahbks9jBcy1JqWbcF3tizbylxrRk4XnHKAg==@kvack.org
X-Gm-Message-State: AOJu0Yw36Z8nxy16zJdz2otR38ShMQGMprtPZOTaoLdD3xkYOzwYtrsq
	joOgysTcciW2+7KRkMTBp3dPXCNC/L+BxCmokTnXCnk2ZesobAU8IXiuJ2q845p8mA==
X-Gm-Gg: AeBDievjY834aKELsH6jhF6eL4dzLidmlW2Q8yc7UN9bz36yvvR5NcYeXhVo6veMWgr
	a1ONz28hW9POS4XX3XkMxt4iVG/zMY9rhpJjs+XqUcoHBIW0RLWm42F1vDbCGFze/TxIvwUwzjM
	Pt1EZXG3Uar0aK1GykOas9QZgxRoUqI0fipZFQCbu2u2ywPoBDzXbuy8dY9RWZ0Mu+Xl0dm/iYx
	o8Myq/lKsJHdM4x9R2IamoVlj7Bn8dApNKwZ4zOS0Q+DaEYO/rh2baSyxuEz5Ad3VcTlRxdnDBp
	qxcj2QOKb5krBfmGrONHM8Bjxa4L2TM8aFIRU9Lp9TDjD12iCEhYIFWHUn4v9rdADkAD32Kjygh
	tEi6Ej7dH0vgnTjg/+MnljFgT5NQ8C1+SxVjEZzqGauBWw9gEFzKmwUKaK23JzAMdVIto5Xwqf9
	CUmNxGB6hUAhaTkpi18woXIYbn6sGYZ0fAVd1Ojwt5/a7nYKItnA6vTdH025UP2CBDZb1bPVMzq
	Cn+aBmllvwreIkzVIvq
X-Received: by 2002:a05:7300:818c:b0:2c7:3a7:c7b1 with SMTP id 5a478bee46e88-2cbf9503916mr7679632eec.1.1775517923360;
        Mon, 06 Apr 2026 16:25:23 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:c071:3b78:5a5:824a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm14730975eec.0.2026.04.06.16.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 16:25:22 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	maz@kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Saravana Kannan <saravanak@kernel.org>,
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
Subject: [PATCH v5 0/9] driver core: Fix some race conditions
Date: Mon,  6 Apr 2026 16:22:53 -0700
Message-ID: <20260406232444.3117516-1-dianders@chromium.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oxwfqon5ihhb3syk4nk4r64perjhuagh
X-Rspamd-Queue-Id: D09968000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775517924-582801
X-HE-Meta: U2FsdGVkX19kyyQaBjoUM/WIoCaFK+uERSw3/ttWrNX4MXFxuMwYycHLDiFDKWAJurpwYBhHvJW71nbGk0bn/CH1AEbnhTjODCent3ty4dm1fvB4IiZaeqeIYE4m3WSKJfOWODYFvWxm3zXGwy+5Z1byMzJT3XoXLBtP7EpZ4akLtzWZIxgBwk0VI2S2cauBmhhNV/GgPDUU6vYT6F+ckh/6C2qSk1/aAQbwA9AURgmvMivDBewOvm1GTbMcV//S9fj4tjq/MawsXqKeYl5kK0YmRW8ys0AcBLGtjz88ij8Cy32esQM8DErJZW2m6rFm96WBTBdNXLlJdQiaCY/HsBlN+HcbhpRaVAg7jfDfRP1HXpWNEIZYVYFZk9zuhMzTNad65yJGqDpD7gHQuqOmfiV7tl3W899AzOCzqfMFhuEUQgx5TxWAR4jxyd0zW5ekDvSAGdNUysDaHUEmYrv0dKfUAi9/T2640sFXvbZXnJvEh0xR7LKMnlb0sQmz+mJohUKz8DQDo74Uo9cwlCOYNArKBRXELjlO5MMX3wR7bDRJApi7wwNjqGV0iqMCFeEneL3hLI/ozKFGbpwRJdgxOaoBBE5hb2FAS/HmT8KbmkihgLlmpV4tnM8ocSFKM9VcusLBqYIK+wsTezv7hXOEsbwLsnRLlS6UVVwMBUN+Jfmofw+0eHW64gKe+JeYkrbCWHKrMtQY8NlqjqOYSz51b+vj1KXPgkudTi4rbmHfcb+EZmI3pI+BB0ohQ3UV4ynPLmtIRFckvXYl0rF9aa68q46dD2f0cjRt6zpWkV9VpIS06KOLcFnhPxSLkJR8n1OcSv59F5u4JqjOidQLiPTwyZqIi/V8mf35YJDEqzMhRk3toDwDO2GhzKx2JyqbjLQHhkPq6Od1U8U+sco9CIn+Cp8WdoD1sLiImUd35Vmlbu0ZPi6yUJ1pNEtk/22LfFi0r64N19SwmY/YLquEVVg
 toGUG4Xw
 KPeR36zjEElFw78UDJYSUMhLGZNgqgOrH8SXdEx4p0lr1RGLwjKSniegXLS7By3vJiZTKx3w1u6u2R+8EA/5eTdHR0Xnh1tMT4P0V8AdQ+jqUkADi21ftXwQw3YYbcWgykEc42D9YkVM8/oDxfO0PkBqhhzvhOzy2SqJUEN2zGIotJKISO6AJ3HL1pOh3cFXGme99hJofC4ehLE4c4Nx2MFRN8SapSWxKp8xsMj8NiIW999bYwWZir6Sf5tFV52GbD0T1C8Y2jwIL7p6v0vpbyPxgP2zGqnTWIDeKL0ZTGZ61R6heGC+8t3nNZfb0LqV1OsUXg2ij+9mpef8qHr4pJq2OWSibjG5hqkgX7KINZY0EUCAKX4l7gKV+3+M33HdIMBSBXBInWlKKNTkONf4gsbo36HHg/dupv8xwAwE16vgXgDovLwBaC/KdqkoDvsDFrPjTgnbPGo/+0cctTBtl8uYEEruJeevR2grl
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
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = true/dev_set_${caps}(\&\\1)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = false/clear_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = false/dev_clear_${caps}(\&\\1)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = \([^;]*\)/assign_bit(DEV_FLAG_${caps}, \&\\1->flags, \\2)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = \([^;]*\)/dev_assign_${caps}(\&\\1, \\2)/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var}\([^1-9_a-zA-Z\[]\)/test_bit(DEV_FLAG_${caps}, \&\\1->flags)\\2/" "$f"
  sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var}\([^1-9_a-zA-Z\[]\)/dev_${caps}(\&\\1)\\2/" "$f"
done

From v3 to v4, I transitioned to accessor functions with another ugly
sed script. I had git format the old patches, then transformed them
with:

for f in *.patch; do
  echo $f
  sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_test_and_set_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_test_and_set_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_set_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_set_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_clear_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_clear_\\L\\1(\\2)/" "$f"
  sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags, \(.*\))/dev_assign_\\L\\1(\\2, \\3)/" "$f"
  sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags, \(.*\))/dev_assign_\\L\\1(\\2, \\3)/" "$f"
done

...and then did a few manual touchups for spacing.

I only marked the first patch as a "Fix" since it is the only one
fixing observed problems. Other patches could be considered fixes too
if folks want.

I tested the first patch in the series backported to kernel 6.6 on the
Pixel phone that was experiencing the race. I added extra printouts to
make sure that the problem was hitting / addressed. The rest of the
patches are tested with allmodconfig with arm32, arm64, ppc, and
x86. I boot tested on an arm64 Chromebook running mainline.

Changes in v5:
- ready_to_prove => ready_to_probe typo
- device_lock() while calling dev_set_ready_to_probe()
- Add comment before "can_match = true" from Danilo.
- undef __create_dev_flag_accessors

Changes in v4:
- Use accessor functions for flags

Changes in v3:
- Use a new "flags" bitfield
- Add missing \n in probe error message

Changes in v2:
- Instead of adjusting the ordering, use "ready_to_probe" flag

Douglas Anderson (9):
  driver core: Don't let a device probe until it's ready
  driver core: Replace dev->can_match with dev_can_match()
  driver core: Replace dev->dma_iommu with dev_dma_iommu()
  driver core: Replace dev->dma_skip_sync with dev_dma_skip_sync()
  driver core: Replace dev->dma_ops_bypass with dev_dma_ops_bypass()
  driver core: Replace dev->state_synced with dev_state_synced()
  driver core: Replace dev->dma_coherent with dev_dma_coherent()
  driver core: Replace dev->of_node_reused with dev_of_node_reused()
  driver core: Replace dev->offline + ->offline_disabled with accessors

 arch/arc/mm/dma.c                             |   4 +-
 arch/arm/mach-highbank/highbank.c             |   2 +-
 arch/arm/mach-mvebu/coherency.c               |   2 +-
 arch/arm/mm/dma-mapping-nommu.c               |   4 +-
 arch/arm/mm/dma-mapping.c                     |  28 ++--
 arch/arm64/kernel/cpufeature.c                |   2 +-
 arch/arm64/mm/dma-mapping.c                   |   2 +-
 arch/mips/mm/dma-noncoherent.c                |   2 +-
 arch/powerpc/kernel/dma-iommu.c               |   8 +-
 .../platforms/pseries/hotplug-memory.c        |   4 +-
 arch/riscv/mm/dma-noncoherent.c               |   2 +-
 drivers/acpi/scan.c                           |   2 +-
 drivers/base/core.c                           |  55 +++++---
 drivers/base/cpu.c                            |   4 +-
 drivers/base/dd.c                             |  36 ++++--
 drivers/base/memory.c                         |   2 +-
 drivers/base/pinctrl.c                        |   2 +-
 drivers/base/platform.c                       |   2 +-
 drivers/dma/ti/k3-udma-glue.c                 |   6 +-
 drivers/dma/ti/k3-udma.c                      |   6 +-
 drivers/iommu/dma-iommu.c                     |   9 +-
 drivers/iommu/iommu.c                         |   5 +-
 drivers/net/pcs/pcs-xpcs-plat.c               |   2 +-
 drivers/of/device.c                           |   6 +-
 drivers/pci/of.c                              |   2 +-
 drivers/pci/pwrctrl/core.c                    |   2 +-
 drivers/regulator/bq257xx-regulator.c         |   2 +-
 drivers/regulator/rk808-regulator.c           |   2 +-
 drivers/tty/serial/serial_base_bus.c          |   2 +-
 drivers/usb/gadget/udc/aspeed-vhub/dev.c      |   2 +-
 include/linux/device.h                        | 122 ++++++++++++------
 include/linux/dma-map-ops.h                   |   6 +-
 include/linux/dma-mapping.h                   |   2 +-
 include/linux/iommu-dma.h                     |   3 +-
 kernel/cpu.c                                  |   4 +-
 kernel/dma/mapping.c                          |  12 +-
 mm/hmm.c                                      |   2 +-
 37 files changed, 218 insertions(+), 142 deletions(-)

-- 
2.53.0.1213.gd9a14994de-goog


