Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FFAC54EFC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AB26B008C; Mon, 27 Jul 2026 13:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BA76B0093; Mon, 27 Jul 2026 13:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561576B0096; Mon, 27 Jul 2026 13:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 146C66B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:53:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FD26A0149
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:53:05 +0000 (UTC)
X-FDA: 85035302730.22.6E015BC
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id C18AF4000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:53:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKAP+hpK;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785174783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkPvk2eUGVnaH519Z4bYiGg7FI/KZRoqTARHHR55Fmw=;
	b=1/tf2Z3brNV+eWbL8FmnawrO8q8hSFwxNWV0uBsjU0LwMg+EL6bb+9l6gHpElTaWDU2F56
	neuzYiA5j5rBj4Iz+Cd3f0VAHuY1wjaGwKNPi0Lo/E+hzktCl851K2YJNU+9ViVd/yRjBU
	rInT0B3ryevkwIj/Bv1kk+SdW1k4NJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785174783;
	b=r6Ol2MCwRIezpR7886SkRcOP0hnQiUxnG4FIlw3KgxZcim6Rh/ax752doEF6Od+L79/S9C
	RJ08KwkkFpHhbiJ2E6LlHc6ZuLAll1s9I46mezp00SB0kQmoSqYUEMnzIt8N7KsKBjxjKy
	W9mSQKOG1XzkkEFI2FViGQ/Ve9ty70o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKAP+hpK;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8486ac3f347so157744b3a.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785174782; x=1785779582; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HkPvk2eUGVnaH519Z4bYiGg7FI/KZRoqTARHHR55Fmw=;
        b=TKAP+hpKItC1QIg+mFXTsHZBizd2a50Bnd6473YB3UP6sQL8q5ywx3sn6/hRSk+Etz
         SzFXzxP55EZnZwHCghmmP8nIyjBQkjvZKt3s+26dTXZHYKx4wEFleYzABUgIf++OiuFo
         32HAkmQMNRMSxtH0hkpa1Wj1xBPEiATcqMkkGkiRtiGCdttkJ9XwqepidcMMRxEhVewE
         DurUhpqmSzqFlsuyi1G1NXtquPTC0IdQ6hxpHVCufNkrFyN6Ue3J0KA0IIFv5IOIfuqC
         A3imqbNRbpDB7f415654hqPE8y9y9r6WXWalN83SuGiqsJrmeUVp9hSbHFpnkO/wcbI/
         zk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785174782; x=1785779582;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HkPvk2eUGVnaH519Z4bYiGg7FI/KZRoqTARHHR55Fmw=;
        b=BscWSBiHJzzTv04h9NFV7biREKJMgk/DZGzZ/q09PkqYKedZNeChyRhzzmSfDYJtJt
         OWf/Xhufx3B4yWNHPnpOn7pFb2VKNynylfrC85rCPMTFXORsk8fKqLm+HWtr2N2eSV1h
         +Sy57ve/oGZtxDVKcObxbVCUROp6xFNPzVWKya12lxkULWEfvz2s66QShbgTEfecxzx1
         QbHoHNrO8Lv1VOOGRmFKmsYe2DLcF0i2dOpOD2JF99gPCNs4//z+kDbT0PTQ16DcQV4I
         BnijAbw9L5WE6nkyZJDRvNYxxGpGyVZJTTPNYCdOuKA57J22RT41ZynTo7XLCFxa6nlh
         FDyQ==
X-Forwarded-Encrypted: i=1; AHgh+RrKBHZqyoRQAAZYp0uSZDGKDaYurGDo5ylMtc06lRuA2xjis/i+P4Ep+biPqw4CLgmSEf7Tg6qJNQ==@kvack.org
X-Gm-Message-State: AOJu0YwCTtUTFnwoVFul/DXhzO8KQmyaJ9WRK4KSmZwNMbxK6mP0E/jQ
	Izi8i629IL/ExHhpWw+LTnOPwid2+rKQTIqq7dMvZ5tVopUCQePAlLYzaRBwlDWIPw==
X-Gm-Gg: AR+sD137UvLSRBU0dVN7BHUH5izjyVIoVDtppAaN9ub0yR8eoLioCQXBmMmCc1AudUI
	HOjbvQtINopP+RXtvpParmsYkRt9CgSMqDYavLGK4TZW3SC25fJS7Qy444HQnAir8pRHL+GwXQz
	80rK9/20/2Av9eL3vNmTjy3JR+W9GVwbkEgyHn3TcqNitJu02uF0DZtUFWzMGVzki9RIjewqT6B
	M0ih0xErjHDV4Vr87w9MM02D/j8rqyoE2OVZvt1/Dgem9wGTESawFWF+xiJcNRCU9fdxYOolcIn
	rDYpEST4wTB+376upqyU2LaVelfVV7CRETjt82cskEGA22X7fjxxtI/5tjG6VGJ+cHj+/6gOSQO
	O53SoRSi+tCODZxKRgz8jqcdMEOscOaoN7bpei5O8Sd6jyYOKi72DcaBnW+FrtSVkJ9UbF/CIE/
	IIZJ5Em7fDJBhiZsJQuAuZI+xq9xwPtO0On7MWEdem
X-Received: by 2002:a05:6a00:aa06:b0:84a:65fd:950a with SMTP id d2e1a72fcca58-84e8d3ab7b9mr351943b3a.29.1785174781958;
        Mon, 27 Jul 2026 10:53:01 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e532590bdsm3400120b3a.3.2026.07.27.10.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:53:01 -0700 (PDT)
Date: Mon, 27 Jul 2026 17:52:57 +0000
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 00/12] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <amea-VLTnrO_WxnW@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C18AF4000A
X-Stat-Signature: o61hz8m588kwau1eenhndhyess5zkopd
X-Rspam-User: 
X-HE-Tag: 1785174783-539548
X-HE-Meta: U2FsdGVkX18CJ9iLQ0o/KIChCf8VHbiR18nStqCubvvAHBpIcCI/8usLtA0Yj2iqTSdnXMugi0QwExanTC1eiG5I+rSyGpB5tz+wp119vMXUd593CLc048SF4cRy0Gecx0T06ntns063LLmQFe/PI6W7btRqb4SIXyXgw4QFMDI8C/ZLbfpBfeDD61KVfch4an3plv85c7K6utC8HuxwEcM1tlVNs2PpOMHv45SUmN/8noj8LBhg+GEtBAj9fpDLe2bXPD14dOPhpHnKiYlTZnvg1aq6090Na5dtbMzthiYGyziuwGBqQC5R9ZJzJPb6h6EThLwViO9kVLNJyHVnTZJ5IwXfpHORslgbLKnEARsiBI7RAih51eHyeli2KgOOpyI7REVzD/ZOLdsM9MIsvlRfyN4r7icofjlv4BdUy5Mxu2xLgRZN7fSnzowAlIaB7Nl/0HPgtBKWlLTlYYksmfK0H3fsgXjzXfXgCdww/Fs2Zx1WtbTP9xY2tH4fp+2H+vTo93fO/GnDZmKZTJ5hsLqkvXyWV7xSWvFkt/y5PNPx8q8xMz66+zjYudeKhD40sL20TvhU8d3GZsQ7b59sH9D8y6zqTEnvetZTJKBhto3hZCFsaKHgclFbgeSWaL8eOi/PULG0lci7NS3YKIoyUvhH1Idtvc5EOLbz6Zi2jTNFK24etVJlo29U1pLPauel/oCYThCUPOwRd1uEhFWQyI6uAZBFfSUKbK/njZdlYUr9eHImBHxc0xXpIXeHbO2ec+i/dGr51Gk0BtQ2topBnFXU7lOGzZcoJ+UvaTvMzdL+BOgE6Ix0GcenctymO6cLMUIDM0Y9X/Hp4dEAQuH67lUs32kkxsQmYDTYYg23ziJinJyh3Ydj9X6mV2ltFh+JWknz2U0uDB4rbHc2WQFQtFl3o9xjj7+RPZVrwg9LCny1K/Ju0cVHtyZ1LgCP/8zo+hfKhLSYv+NyN1rB0K3
 Qlhi2QZH
 r9/YkujfHZE66pEvz6imiMWEOdf0hLbUTTxzGXIHV6Ozb4mbIYRS6b5F7ITWa29T7ZrtQMc5ETYljN8I/dS+DxOs/X2yb0HYR8ACV59/vKN6vQTxYK3Hhlme9k72rcJ16qDaObUrRb5U9tQ2+fuaf6o0rlP5Z5beO+TjafSOz5FPcqAj5/wGWFwflupIOSXkjauD6Zo/i3RZ0jIwc+vrmMQYFeAGJEYc/32FWu+AUbPyKKusQC1oUP93jOI+J7Cw3nn5iA1H2A6WhOhcD+eoza5R8amcd2t1P80gDYzrKaHX0lbo0SkvHh1a5o5xrPDH4RwRmbvCgLetorqTSW+kxC024MLfBpw8D6N28X3CXD1BejdT1NcXlxUKfDY4cabQHMCBeGB2N1iuyaLkzRMpLJ8OT8vqI90mSf2aP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-10 09:26 PM, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v7
> 
> This series introduces initial support in the PCI core for Live Update,
> enabling drivers to preserve PCI devices across a kexec-based kernel
> update without interrupting the device. This functionality is critical
> for minimizing downtime in environments where PCI devices (e.g., those
> assigned to VMs via VFIO) must continue operating or maintain state
> across a host kernel upgrade.
> 
> Specifically, this series allows preserved PCI devices to perform
> uninterrupted memory transactions (DMA) to/from system memory across a
> Live Update. These devices can be behind a bridge but must not be VFs.
> Support for P2P and VF preservation will be addressed in future series.

> David Matlack (12):
>   PCI: liveupdate: Set up FLB handler for the PCI core
>   PCI: liveupdate: Track outgoing preserved PCI devices
>   PCI: liveupdate: Track incoming preserved PCI devices
>   PCI: liveupdate: Document driver binding responsibilities
>   PCI: liveupdate: Keep bus numbers constant during Live Update
>   PCI: liveupdate: Auto-preserve upstream bridges across Live Update
>   PCI: Refactor matching logic for pci_dev_acs_ops
>   PCI: liveupdate: Inherit ACS flags in incoming preserved devices
>   PCI: liveupdate: Inherit ARI Forwarding Enable on preserved bridges
>   PCI: liveupdate: Freeze preservation status during shutdown
>   PCI: liveupdate: Do not disable bus mastering on preserved devices
>     during kexec
>   Documentation: PCI: Add documentation for Live Update
> 
>  Documentation/PCI/index.rst                   |   1 +
>  Documentation/PCI/liveupdate.rst              |  29 +
>  .../admin-guide/kernel-parameters.txt         |   6 +-
>  Documentation/core-api/liveupdate.rst         |   5 +
>  MAINTAINERS                                   |  15 +
>  drivers/pci/Kconfig                           |  15 +
>  drivers/pci/Makefile                          |   1 +
>  drivers/pci/liveupdate.c                      | 910 ++++++++++++++++++
>  drivers/pci/liveupdate.h                      |  68 ++
>  drivers/pci/pci-driver.c                      |   9 +-
>  drivers/pci/pci.c                             |  14 +-
>  drivers/pci/pci.h                             |   5 +
>  drivers/pci/probe.c                           |  22 +-
>  drivers/pci/quirks.c                          |  58 +-
>  include/linux/kho/abi/pci.h                   |  59 ++
>  include/linux/pci.h                           |   4 +
>  include/linux/pci_liveupdate.h                |  77 ++
>  17 files changed, 1260 insertions(+), 38 deletions(-)
>  create mode 100644 Documentation/PCI/liveupdate.rst
>  create mode 100644 drivers/pci/liveupdate.c
>  create mode 100644 drivers/pci/liveupdate.h
>  create mode 100644 include/linux/kho/abi/pci.h
>  create mode 100644 include/linux/pci_liveupdate.h

Bjorn,

Do you have a preference of whether to merge this series through
liveupdate.git or pci.git once it's ready? (Mike Rapoport asked if we
could make a decision on the merge plan.)

I am leaning toward liveupdate.git:

 1. There are some LUO core changes around how FLBs are refcounted in
    the next branch of liveupdate.git that this series depends on.

 2. We had previously agreed that the files covered by the PCI LIVE
    UPDATE maintainer entry would be merged through the liveupdate.git
    tree (which is the majority of this series), so this would be
    following that process.

    PCI LIVE UPDATE
    ...
    T:     git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
    F:     Documentation/PCI/liveupdate.rst
    F:     drivers/pci/liveupdate.c
    F:     drivers/pci/liveupdate.h
    F:     include/linux/kho/abi/pci.h
    F:     include/linux/pci_liveupdate.h

But if you prefer landing the initial series in pci.git I think we can
expose a stable branch in liveupdate.git to handle (1).

What would be your preference?

