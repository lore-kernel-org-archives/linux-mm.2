Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFCED73E89
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B173F6B0088; Thu, 29 Jan 2026 16:04:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC53C6B0089; Thu, 29 Jan 2026 16:04:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0A76B008A; Thu, 29 Jan 2026 16:04:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C36E6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:04:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2543DC170C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:51 +0000 (UTC)
X-FDA: 84386230782.05.EF3C324
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A12A160006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CkmtqWJB;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p7dwhjhUx8amshGTbVFKhqWt51EOp/YvCZDul2or7c8=;
	b=vYPBTB7FdqcOeQBk3DgJj9U5rlKh0lDZsps65p6aJ1iK5+sRVkZGQprpAsn2XaJYYUH9zd
	QeW31cvJzDXJVbqidp6r38IGaVq1cdxUDu3t9S2Ia/K69ikHYQTExB7Th87vvFZBKe37VX
	xJn6YTPdqasdJ14eIyTVeIBUoe2qoKw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CkmtqWJB;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720689; a=rsa-sha256;
	cv=none;
	b=yvQfYb3nw6aQ6fMyhyucJD+4XZTuiovPEMEBNhDLYH4YDziGDRsXQD5rdnPZZ5YjSHNjR0
	ueE0kjzDGsTegCy8BZGmZldmaTL/ayWJ5VlSielbJKx43XP0oGLHk9FYSl34r3JymRbqVa
	ktOBitvap6a+4/k4zw8wqRwuphTW12Y=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c5386f1c9fso185467485a.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720688; x=1770325488; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p7dwhjhUx8amshGTbVFKhqWt51EOp/YvCZDul2or7c8=;
        b=CkmtqWJBzkN+MJljjWR187ThIEhZ9/NJpFIEKI/S8Yo/FbhsA/vpwfLTDj1NXASFOR
         tslNNHthd8I5HcHHb871e4LzgNjSaWurZvMOISbBfaEMHaSKrmaeL1pvSwOproep3rFc
         0LBFSYmcarKl7VA1Kj4gXHmMhRLFnbkZYvXDypBuZ4pEwuurkjJ211Q/TMwXOwNFIc7O
         vDmGGvm7RtW66k1Zt6VyJ6Oy3NlRGN6N4H5tGdG1FVKBTytw0MDBHFXa9xqFVmDhfDeU
         4NH3ROeN0B1Lz8il3rH2E9QoSoI402JNuIXc+q4AmP9JBvkOkeFQ5d91OdAOXH+dZ1/T
         db6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720688; x=1770325488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7dwhjhUx8amshGTbVFKhqWt51EOp/YvCZDul2or7c8=;
        b=p7dneGPEylP49H3mqrq/zw1W9iAdgLdaFXo/smlmQSZqS2K68pIDuT2twzPAutAjLO
         Ip4j+ls+A0rJN7zP030GlikxCQX1e5mdXKhxu88JrxoPRmJp1FmzwFGr83Z2muecL2Mh
         HQ1yEyj0Gd5myXx/4xYewX9qWXdREYAYKpLpdPgZsL1qQfORoIPx+dTn/sFF10RmLj76
         wRzU/RiJZmTXI3JbG4LU6HqC3w7u6ByRd2EXAZ2hk/siWG6fw+v4BsOmgB8VFTN0GqTr
         /9hb1vUg/KFfEXemJcJRukehKWrnUuDETcDmyqzAho02sDyxu2z9CoJtxZ3BMz3BHKzp
         3gCA==
X-Gm-Message-State: AOJu0Yw02dUP/uA9cyP/QaDNEcgbzS32EAVrTDHM+iNRTD933CK0lEkR
	gtDcqijQvMITslO5syU2jB+jJ+CPt9ZUaMg/62Llsxb41FzY803OSpoJBr+/LQvl43xv/8jpS6s
	4FZNwVp0=
X-Gm-Gg: AZuq6aKCNqTtiy0l8KJnUTskd1aeMmpXft43FFI43VKQfTIqd5W9ur4KbxL8565lPa6
	pYcmR83tjCrif2VZUg58ZlaIw1pXEutrX5zNCNY0e71wmvqtQ3X5ZhBj3wCCCfL/jenZaYYZNpy
	PoWx9MPNYtq2z6dqzdAJS6VAgojqbe7zPl3ZaL13SCf3PqMGcZ/H/k3h8I0Xl3vaS+/c5wozSUA
	23g581H94VtG3OflnfxlqrzdOJhC2+oBfTE49NjTw0Syuyo6UacG30eMdSMZHX/ARr1nKNWHFzg
	J5MDrz7Vl4xOfbEn/mS7Q6+CXrogr030gG6GsPugoo9OZSky2rtaltGnphGIhKIOFfK+PN/IgRI
	Tka9+6vz9ha64DtsIlEI8Aqg+K14bVMVztWAyqthRjrHPENwhnK7ciTAtQUGyvUezouvkCxQG4e
	9Ktr4cdPkBKPzK9ZKDcnXXTEDG9vSbNFITHPFW6e9zmbFI44Fm/OatqHD+tBRV0YDq30hmWYCFs
	+c70HnwWnoPng==
X-Received: by 2002:a05:620a:4801:b0:8c5:2d4c:4f0e with SMTP id af79cd13be357-8c9eb26aabbmr143736485a.25.1769720688060;
        Thu, 29 Jan 2026 13:04:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:47 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Date: Thu, 29 Jan 2026 16:04:33 -0500
Message-ID: <20260129210442.3951412-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A12A160006
X-Stat-Signature: uebnxxzj7u91p3jwwgm7mhatnub31nsa
X-Rspam-User: 
X-HE-Tag: 1769720689-614295
X-HE-Meta: U2FsdGVkX1+3WGx7DCKBfn2w6d7cfwnV7wwDBY5nXvzMn/ZpNXgp+7KIVN5buo4h0gPzLThpb2t6JmN4fT0qUHJNTFMuIqNAtgj007rfPUWn8kj5yMG+yC6U1fE8Wy20Z+a2hMKv9nUNO1CDfed9tZYtMCOFNyP0OFULzfhXjqU2Tad4JELa4nGdCjcHO48FBffMIo4hfB8fnCTRArLRp6Y4Gddsh5KljZN4xrWJULU5oY3c7OwslFu9IgVJC1KhSosDVTR3uVF+lxXOBb6rnBJttoQOR3AMDnxZyKlGDY+Y0zLYFWsfx1gnFXjeJ/15o4BubGvKGIV43jutQS/MVxty/WaenARd/lI/JW5cl2LsBkWVeSMhEX19AzmfsC+rOKdH6MwNZI8RkrlA0FJoqmWQjeXIAomIZKyWjYBjncRSzBGjAXiq0Rji4g66f0Tyeg1mwxHioGwHJRIu6Fz6WBFKRQ4pD7lxjl9/Z43ARhuSjeswewnce42iLlcOhSvAYCiosWq35+bvC9OKhO90cA01V0/8QHhYmmR+8VfliY4OPTkHCU87KhC08T4ZpKWxaO199S0Vns3yF5DweNB0v9NjvFZzEh3kW6bke0zvYNZXZot3ZvBoFxlv6YQPJExm/zZeJL+Jrg7UV0LyiU8UGwUNkUuvGg3m6K0vQo9qUKVJ+6r/IYhdai0piVGadRi+p1gUSbdJ8hB49h/bVqX26qLL/5m43d8rhYJMdX5lXwzFogkuJCZcsLgu6Qyi5CtR3AYt2dL/+qFUtwzJ/8X5dY+ZTv4o2cu3Gien6iDXtAUUVqHKavv/1Jf0Ex74niHi3mkU6JV5TBNrqDV7NyEKHQ9ggqO1eayzO9ZTYLgSQ/V5lnKW1vKXv1fVIfoMxRe8NYbvZHLWgvKTZmCkRiz5zltWG64kMrg4OdT+Nm6Zv1GY42Z7LVrecPqi1MyHF85EEztVMEH68Vi2OQLIJDY
 mZAdanXi
 QFzXAm3C+Jf5X95vBx9GT+5bMlzYvLq8R3iOdJ8B8yI+Ep38/R7QXuYh6ufV1AWhU51EvggOXAQBPmPh15dguH2mZHBdLpJukwj34utQZUlyx9ZYK4J1aUWtdeOTbXONjbhcNUH6tqpiCQoa0cIrxGE8zQJsE9pFooNsokZu3ngMAKHMwpvEjIq+5+f9g7hc472MXAZR02AU/owbG8jZgEt2ruMD6HI7YmUxrwx3LHwH37j9r/B5A1ufuog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, CXL regions that create DAX devices have no mechanism to
control select the hotplug online policy for kmem regions at region
creation time. Users must either rely on a build-time default or
manually configure each memory block after hotplug occurs.

Additionally, there is no explicit way to choose between device_dax
and dax_kmem modes at region creation time - regions default to kmem.

This series addresses both issues by:

1. Plumbing an online_type parameter through the memory hotplug path,
   from mm/memory_hotplug through the DAX layer, enabling drivers to
   specify the desired policy (offline, online, online_movable).

2. Adding infrastructure for explicit dax driver selection (kmem vs
   device) when creating CXL DAX regions.

3. Introducing new CXL region drivers that provide a two-stage binding
   process with user-configurable policy between region creation and
   memory hotplug.

The new drivers are:
- cxl_devdax_region: Creates dax_regions that bind to device_dax driver
- cxl_sysram_region: Creates sysram_region devices with hotplug policy
- cxl_dax_kmem_region: Probes sysram_regions to create kmem dax_regions

The sysram_region device exposes an 'online_type' sysfs attribute
allowing users to configure the memory online type before hotplug:

    echo region0 > cxl_sysram_region/bind
    echo online_movable > sysram_region0/online_type
    echo sysram_region0 > cxl_dax_kmem_region/bind

This enables explicit control over both the dax driver mode and the
memory hotplug policy for CXL memory regions.

In the future, with DCD regions, this will also provide a policy step
which dictates how extents will be surfaces and managed (e.g. if the
dc region is bound to the sysram driver, it will surface as system
memory, while the devdax driver will surface extents as new devdax).

Gregory Price (9):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  dax: plumb online_type from dax_kmem creators to hotplug
  drivers/cxl,dax: add dax driver mode selection for dax regions
  cxl/core/region: move pmem region driver logic into pmem_region
  cxl/core/region: move dax region device logic into dax_region.c
  cxl/core: add cxl_devdax_region driver for explicit userland region
    binding
  cxl/core: Add dax_kmem_region and sysram_region drivers
  Documentation/driver-api/cxl: add dax and sysram driver documentation

 Documentation/ABI/testing/sysfs-bus-cxl       |  21 ++
 .../driver-api/cxl/linux/cxl-driver.rst       |  43 +++
 .../driver-api/cxl/linux/dax-driver.rst       |  29 ++
 drivers/cxl/core/Makefile                     |   3 +
 drivers/cxl/core/core.h                       |  11 +
 drivers/cxl/core/dax_region.c                 | 179 ++++++++++
 drivers/cxl/core/pmem_region.c                | 191 +++++++++++
 drivers/cxl/core/port.c                       |   2 +
 drivers/cxl/core/region.c                     | 321 ++----------------
 drivers/cxl/core/sysram_region.c              | 180 ++++++++++
 drivers/cxl/cxl.h                             |  29 ++
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   7 +-
 drivers/dax/cxl.c                             |   7 +-
 drivers/dax/dax-private.h                     |   2 +
 drivers/dax/hmem/hmem.c                       |   2 +
 drivers/dax/kmem.c                            |  13 +-
 drivers/dax/pmem.c                            |   2 +
 include/linux/dax.h                           |   5 +
 include/linux/memory_hotplug.h                |   3 +
 mm/memory_hotplug.c                           |  95 ++++--
 21 files changed, 826 insertions(+), 322 deletions(-)
 create mode 100644 drivers/cxl/core/dax_region.c
 create mode 100644 drivers/cxl/core/pmem_region.c
 create mode 100644 drivers/cxl/core/sysram_region.c

-- 
2.52.0


