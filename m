Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77990E88D6D
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 00:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B4B6B0005; Fri,  3 Apr 2026 20:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCEA6B0089; Fri,  3 Apr 2026 20:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C44D6B008A; Fri,  3 Apr 2026 20:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDD76B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 20:07:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADC51E19F8
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:07:23 +0000 (UTC)
X-FDA: 84618933966.16.40C3D43
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id D92A44000B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:07:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c66Wm3tH;
	spf=pass (imf01.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.172 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775261242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KGKsMy9vhlN9yvdnOvYy+R4lmavPYuTzTATeThGwgQc=;
	b=W/aIULBLC4jpvqoe7Wyg86BIoiuUcglFWWEJA+shex7fZS4px7oSAl9lyr21+9gx0jUZOf
	FxCcOwsMry4OnFUiNQEV+TNTCvBQWdZEVD2+H/2J93wNFaOs5R8/1PZP4VpseLXIxSLjMx
	FTt/VMmJXpGHjpxtcg2ROsTC+x45gLY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c66Wm3tH;
	spf=pass (imf01.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.172 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775261242; a=rsa-sha256;
	cv=none;
	b=VQskaQItekUeG5263e1AdrHPivVoNH5vF04rikZlfAiJ6Y5PcqnhWn0e6STlujFDOMvf5i
	U5h3FqqWKVUB/2MgkNrimmQ1msZnWhYGA7E4bGMzfxDQvhB1HCHd6iuAVrFJHmccwSQwtp
	8BQnK1Ux7ww7hpZWSL0zzBAzy8wkrZ0=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2cc4c693d59so2340880eec.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 17:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775261240; x=1775866040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KGKsMy9vhlN9yvdnOvYy+R4lmavPYuTzTATeThGwgQc=;
        b=c66Wm3tH/1Vv5h8pe3p1j3aEJWJmgUrc8i+Dk9ylceNpHd6v3QU5ZAny3F44iu97kE
         HWLD2dKBqXtPV5ryPexBGf/R5E5iAeH3azC8hiD0zpRzpHg2a+4TvlxAPksmSD0FUEVI
         FONHPl10jvruhOaUXS2Lx8WG4QTO4XexmzotE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775261240; x=1775866040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGKsMy9vhlN9yvdnOvYy+R4lmavPYuTzTATeThGwgQc=;
        b=DXC1GGPVv19mKAbEw9cOvYO834SRzngAZOO7K98VQOzZXzI6Doo9i5KhIJ8FTl05eT
         +MpyS2R9AsBm+v3asDNXmRFl3m9AUzxHSGPvGoQsJtjGH7SlfGqq8DnpmTWo4eQudFre
         Cv3FqjmPg8FfYUPkxQ+cHGzAX61/O1ZcITyMYnGreUCOExBtN2VUjXFEHK5w5h2OT2FQ
         /5gapad/txUW5GbSut2vzlguD+FTk81qcwwK10X2ROb1wRadUi2K9crQkV+/QTr/4CAm
         ygNG1xUCZ42RjuqpjXOueolaFml3k8wwKAe45ByPpUQRe/4XRcY0ObO8uE2Vc1pfmLhV
         RCpg==
X-Forwarded-Encrypted: i=1; AJvYcCX0DC4zcLqXW4Qstebl2ty07NpZrkMqav3/F7LADAZmIstMFkvUDIy59dtUDbxtyzuSff92NIngww==@kvack.org
X-Gm-Message-State: AOJu0Yz/eZDzhmGJI0C0ylDipiuSVfh4RQkNNLoRBb29oKTIIzP8g5dP
	P1mYD0aHSJM1bJfeoUyk7fyMmSv7f8+1lWEuPXA9PJKtrzn7WAoDSvEJ0kL4u7kX2g==
X-Gm-Gg: AeBDieudlSIVRKoOjVAmuS1P98hrlenKjWZ1hfEGNalNVnhQjcrjqZisjtYKNrbCaph
	bKLTaSyUoq/oa46PymfjcFzzV6MYvh32VTaDutYJDvfB2gR6LUijQCY4ZdPuE/42f9NlKcodOzs
	nvkkXeIhQgC+1LnfeXjYnk8UbBmCIoQ+tckOEqRRJJGMOhBVJuK0dm6RrIU3DQ2XCg0KFjXTcuM
	YHLf02hLHH5zJFZGJlLXx5yO8w8zb/qDmnzTxBbXMDWG/u4CNWqK3oLXPNsuk8JyfZea5Xl0CJT
	6Z2ICYftV1b1hOZkR31uVljd+A0gvtrm5nziMFF3azeysFWONMVAfB81nG+3Fjpp5mIgfCnJM+E
	EeakrJngGskqAWjUxW5echXG89o3Ls4Q9stdbAXs/yBd8foLddfGyw4SEvimh+wHlwuzqak9Ivp
	eEif1KflodkBGA96PVqRcfuvdP8y/Fb6sYO2M1z9MQ0Xd9z3seWjIzi3iQMxvScYvvvpMRgCTDn
	mYfLG9CM+4=
X-Received: by 2002:a05:7300:5722:b0:2c7:ea98:da0 with SMTP id 5a478bee46e88-2cbfbc8aeb9mr2680118eec.19.1775261240285;
        Fri, 03 Apr 2026 17:07:20 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:a8b6:55b2:3eb6:2c0e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca79e1d93bsm6520716eec.12.2026.04.03.17.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 17:07:19 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Saravana Kannan <saravanak@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Dumazet <edumazet@google.com>,
	Johan Hovold <johan@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Robin Murphy <robin.murphy@arm.com>,
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
Subject: [PATCH v4 0/9] driver core: Fix some race conditions
Date: Fri,  3 Apr 2026 17:04:54 -0700
Message-ID: <20260404000644.522677-1-dianders@chromium.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D92A44000B
X-Stat-Signature: mqkzzkjzjpr3w7b57b3yadbrj5uosgds
X-Rspam-User: 
X-HE-Tag: 1775261241-636005
X-HE-Meta: U2FsdGVkX18D/2tReE0J8EG6fxNBsrr7VKyDgm4i9va5QscddgRKYtPDcKaQEpqpJZhCD9C9Ebveq+mqhCQKTYH5wrAuVk/6UNi27ZizLIZHOigrDV3r7TqzQ8iU6F07M1hOhHiUJfydNjg6E4PB7luwgF9vf250ZbBVmOHFzxE05CrK7nK3MbcfIfiCQwJ9GCEHBTqk47t8XK/4MM1Fza7Nbw+9iSW+wahIcU6nIOD9cR+9cw78evkWlWOc5bNzfT5pFM/MFjCbWjIak7BA23xZ9OjlSgd1gZMKsR2XPYk8Xo+hcRmFXpqQ1j+PxtviQKDn+JUAXtwm8+SQSHVDVVjEmhnV/zKxyIdpd+dvQI9cCpKPj5F41i7C+T57+L1H4NqDj/XXSVMJB8nw1wW4ET5QXR22CKlXupD82MMZ3U9hiy1xyHlWtEveRBsoET7+Vs655R5LkrYYfaj8Mdiro35FPedlmr6Ccvtm03706WT+vtCrDXwNc/8k75n1Q3IBl8AY/+kHcth0M5kY7oXRqqaIUKZveou7ON6bIwGNf6dYggO9PifmbbBOv9Nxd9V1+YAKEJ/sszhMwcXwIjBaFc6NVlR7Wzmmpo8AYZsPtnmnRMNsXri8Ug39J/GHgVR+ySiJeaLFDGbNlzsZA5x8rTToBdQTIzYbjIf7aTkPBpcDGGqquYI0T52AcCke8tNtlIGuMPasx5RcVSApPTY+i+ZPufLK111NmSMawamX7ZohCP1hKVXIN5Y9kLj8jDGiiiV52jr1t76JNTZ/dXjZ76TzNe5SuS/1VFPIFdwKCMp1Ow+d61sG05aFQoqOFGM3Zj/qT5zRoXNuPdBd9zA1QaKetqIiQU+gDk6p1pYOapIPl0newg54HDyh3Grv+aZX7M4eaI2fnUDbv2YbOsblmmUgawNtWR90hHRxScnmqskGbIZJdKH6kv9fBMrqvCEJpt3r8rZy2ChGZa/UFIG
 ynTc4r6y
 you9oFwPAJktqZBmgmg7zW2UJIYm6i9GxeD2RlJ4oW27AsQ6YekwgEZKKP64K+dVJ8jUyjuxiV+Z2jW2g9ewrUE15hw1i1rLKSs+IrpSGoYCMIpWO+DU1hDBUiyeiYKO++VasdCdKzSYw2MxvQ/Bs8+ONzbmS7MtVn1RMe8mCrY1VVHlh+B1jIoobzIVk2QZ18VvwZsR9nTh0jVVin1dXFHaCra+2Kq1o5ZBlsb4GQP489x3im7536iJQOYYJSznc8ghYSEHnhBS++xmDsMon6uExDsfsL/02zAfQjv3lPt/cvum7qZvtJolmmc3bObIki7tQ5lFIqgkBw6hvZPgso/mPuWWQn2MJ9x3BwRwoqAyIAKEJBfns7feON7iTzUAPdp6864y4/a3UAeWM8cKE9AYQgv19OVNFOHAqlpgk4862tXU2mgka24qwNPCIsPbXxbphqi7NuNFnMQoa9U++uD/iZbAFh8wLGKf7
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
 drivers/base/core.c                           |  53 +++++---
 drivers/base/cpu.c                            |   4 +-
 drivers/base/dd.c                             |  28 ++--
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
 include/linux/device.h                        | 120 ++++++++++++------
 include/linux/dma-map-ops.h                   |   6 +-
 include/linux/dma-mapping.h                   |   2 +-
 include/linux/iommu-dma.h                     |   3 +-
 kernel/cpu.c                                  |   4 +-
 kernel/dma/mapping.c                          |  12 +-
 mm/hmm.c                                      |   2 +-
 37 files changed, 206 insertions(+), 142 deletions(-)

-- 
2.53.0.1213.gd9a14994de-goog


