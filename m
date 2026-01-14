Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED33D31A2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5335D6B0005; Wed, 14 Jan 2026 03:52:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1946B0088; Wed, 14 Jan 2026 03:52:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D62A6B0089; Wed, 14 Jan 2026 03:52:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2D96B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF22D1ADA98
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:37 +0000 (UTC)
X-FDA: 84329953554.21.5FB7FE1
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A4071C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWyNtnUg;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4uI7G8mzCwfWt6hpevWSKMuVc2LUYnlWS3FX4pvAwGI=;
	b=z1OR42dK59SCFl8WjlroFX7HxLt9svSLCRYzM4HqCnksX6fqTqkwS8BvUKF2Xm7VLMJ8Cn
	ixmHymz3bR1QYFYFjfGjElJI2EesIuepiDerDhkaUJdgDodWbCipVhHwHS8UcY7F66BWS3
	2DXvecGH9TgQXQzCx4qOJQko7RxriUY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWyNtnUg;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380756; a=rsa-sha256;
	cv=none;
	b=u68ebG4nvejZvyu+qhO8S1xk9a0GCy4oOTSxGfIogt0SSxMHonoEShZ8T0dWJq09ju1SEA
	lEW69h7Fxth13+DUKPXm4cdtKhOWvwYZQgQ9c5faw6az9DnKHYIho/JcqMxRqGMtwQEfZ1
	Dncz/0NcbKQBKQQBmuVZwEsyb2/D7qs=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5014d4ddb54so2528611cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380755; x=1768985555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4uI7G8mzCwfWt6hpevWSKMuVc2LUYnlWS3FX4pvAwGI=;
        b=IWyNtnUgovMV1tQOF8dQV5bBSmavocb2n0HNTKFQ4Z/bDUd8g73Esh8os04w81bEgX
         tvIdUFrjDPqWQKewWaiQxHubsX/U0sfWGjlz411LnD9jd7kdJpfPx85SZzkJ3F/hb7Rf
         EFw2mBKHIA/PZsbqpqEHsVY9OGnAFdEhVuYvGLRccGr6w3+0wfvCYiu72qhyXZkOysmH
         CtUnBi6MoAaYQ7a67oBjgJ36DO0llaFTSi4bLi4U0TcNYLvqDQGpkh1l1ulSBk65rAje
         ddYDC8q7perOXJrqlOo2gj4wI/vsRsQpm1f0e+cJisYu1gLaOi99i/Usw23RyNbjkTIO
         aBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380755; x=1768985555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uI7G8mzCwfWt6hpevWSKMuVc2LUYnlWS3FX4pvAwGI=;
        b=JsvmWewbEuo9br1VrHnCZ+e6qy0gYLwDWbUFJDLQi7ZbIPF5MEoKSZb8kZbU2T7yd+
         GgO60FhqmUtAfgvrfz+y220w8f4VhaFUzWTii+7aLdshDeLxSYyz4k+P+fqYACBlBjV/
         mpCy/203/iuNs1MX4Db7X5uWyE74Ctf4CHVTOIuIn8eoB6C1uXNV4auf6/zc206IRDZf
         FHWy2NBKr35blLRyZJkCagy9+2eKoXvtaz8kjR0+9tBadM/2ajgN3l4jFnat7om4XDca
         RfY0ORZGVDpWi8ePWkhQ+AQcrXgmR2AlG2t7Cm8fIm6BSN5eaZwRfZX7zeDvQPuYJEE/
         CWrQ==
X-Gm-Message-State: AOJu0Yxf6dPT1+TbTjqy+btS21T15bl3AOgXs9Zk90OqPecO+Gds6O5L
	GKIgihMmxAest7FhqCC0bhyBrk+KsVdd4HUHHstAgUh+OO1s5MyGUiNqJzM/joIusIYqxhh7+NZ
	BlA8buvE=
X-Gm-Gg: AY/fxX7WTKiduE0vE9I3mYP1qXiyc4LgxqDMmLkmIUscFOwHO3/cEbjiWKtHTEesP5w
	T6zIib2uOGydf63yPLTehMpDzxjr2HtNnMwjjQdDHZOTSeYl3mDjQzOAmpZELp1jfiN+YWPw8cG
	XhdicRVlcDc5NK3m1hT/xiOheCBXDullCQ540lpguxb4ca9Lw1FeYNIJX8BwqvCI8XvNFEVKRk5
	Wev/e6otQ1s6I4a5XYkHiEPXcGJNxhyqU3CbT3qyB54RPxjfhJingQcqmLJmAtflCdfFNB4FhbB
	Dz58zz2WIQ/B1GmPHjU974LxWCZE4/yZcVkKIPqMxvqUcHgzD0rzJCMFT6XMzZgNkzcDfzGRC3N
	nN8Dlip3Z+8W4y3AWKZoeKzFA2et28LbBRibfTftJGEHkRzSDVDeEbzaD+UILnfsc3JrItylc5J
	lDIlhbIjnOMiOEKSnsbs7RlVD5oIgaoAMMeWCEnWKgjJXfVaj8MJzwIf19fPZIVeKt4P5v1w3ol
	ts=
X-Received: by 2002:a05:622a:58c5:b0:4f1:ab46:8e36 with SMTP id d75a77b69052e-5014a905f74mr11547531cf.9.1768380754428;
        Wed, 14 Jan 2026 00:52:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:33 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: Subject: [PATCH 0/8] dax/kmem: add runtime hotplug state control    
Date: Wed, 14 Jan 2026 03:51:52 -0500
Message-ID: <20260114085201.3222597-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w9fouoy8hxo1juhi86g9t8pmcprj4b5k
X-Rspamd-Queue-Id: 0A4071C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768380755-115754
X-HE-Meta: U2FsdGVkX1/h6NzPD5KC1qvy4ONq7ZryAOIpp35Ip2IlYwiG6JO+5llTYWMCSxuYIGzhwCpXuCJ23bUFLpkiv6GRM8yyPmIAZbcC5hc2GeCv/BK7zWV6TXFVht9IlUanA1OE5g3YXRpfmDFnSayNoPpyAgFdSTa4p9loYJbSvdKqH3OM4m0M/S2Xi8UylzXk7+m5F6IJlRXvPqEuOs2KdN+JV8edK2xfzk+PZF7tAfgEHQHj+sLG2AQfNTXxEHVn9sE8eXnu8xRfX0D11hChwN+aIO8mfi9NDowRsaLEUiCV5LKFYOrSzlXEsprny7nK2USFlPREEJ6CXGaKlXaeYYHZe793Y1/GsiDxbi5ZDNo6/qn2sQNIPqUEs2aIWenRZbDToOO8fjNMVqPPXZWwQLmkKPaijNTLDAsSt+FvcgvbnHoxMXhjRToUhHaR9JN0itCEKDeBeVMFGBIvN66j46ZffdpY4VXnCZbFjxvPrCaOsccgl1+7jrRRaOrhLVPdjtYdyGW+kZIm8GzaXh4ww5MFhXN1JIqLcLDbWaqh4U0LfSinnOcXh7zpwYtCocJm/sRrxbVvZSUiYEJV4RrCYFGJdfa+srqmJfgqnAzbygkEYOOqj86oeBfCyvY6NfaNZyr9K2FB7N7rIrGzFCoO+UbrILem6om6cLLo3rodS0/UvXZHCK6MLAd1weQ26dI1nqtUKTBtRdOO9dRn8P+XjbMgeVbEUDX0ibQFWHTCkCmQ5l4Venhe7o1I63H99Z3H3E8cI13xYlYO/S3IMkrF9wTmXgmKXwbESdDMTlRpsvDyyigylsK9Tj0ica0xhd+74ECNl37w+DR2mbTRJjYzADNtGOYlKccR5TdpSie0wCSEPi7S4Brgt0S9AjrEEv7TEBUKegsTUKjLd11egMUjrTXcOqKCToHbNnlHLkchdtuifacAsEsd81u/JTwM6kKO7aofk8aE6sjr6KA/aFU
 j7KMwRJq
 lMNP8TmXqyMaZR55DEXwBkWjZ4azcOFxBuaU9S4b/oRX0rzeth0blr/vXPwg/gpDOSCPsSVGH3wN1XM0nFP5dKhy3IcwP1jwohE71/iCyO9R78jmbHGTGfQsQbFyJjb+PkORYbPSibV1Cc9fJ4XmxhnfAETswXlnb+uzCc4zqDGO/1zeSVpMgr3aAw76JfwEmNbguKS9JXR+7gVSr1WpB/ydJoLD7UdU0nDkhrtpCPrx3hVvBVpTp87PLfC+HrrPJcrpr53qTToXV24TBpisqODGYZZh2wbbV4WNl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds the ability for the dax_kmem driver to control the
online/offline state of its entire memory region at runtime through a
single sysfs interface. This eliminates the need to manually iterate
over individual memory blocks when changing memory state.             
                                                                                                                                                  
Problem                                                                  
=======                                                                  
                                                                         
The dax_kmem driver currently provides no runtime control over memory
state after probe. Memory is automatically onlined using the system
default policy, and any subsequent state changes require userspace to:

  1. Enumerate all memory blocks backing the dax region                                                                                           
  2. Individually offline/online each block via
     /sys/devices/system/memory/memoryXXX/state
  3. Handle races with auto-online policies that may re-online blocks
  4. Coordinate offline+remove operations across multiple blocks

This is error-prone and creates race conditions between userspace
operations and kernel memory policies. There is no atomic way to                                                                                  
offline and remove an entire dax region, and no mechanism to prevent
external interference with driver-managed memory.

Solution
========

This series introduces a 'hotplug' sysfs attribute for dax devices that
provides atomic control over the entire memory region:

  /sys/bus/dax/devices/<device>/hotplug

The interface accepts the following states:
  - "offline": memory is added but not online
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE
  - "unplug": memory is offlined and removed

The driver handles all memory blocks atomically and prevents external
state changes through a memory notifier that blocks operations not
initiated by the driver itself.

Series Organization
===================

Patches 1-4 refactor the mm/memory_hotplug infrastructure:

  - Patch 1: Pass online_type to online_memory_block() via arg
  - Patch 2: Extract __add_memory_resource() and __offline_memory()
  - Patch 3: Add APIs for explicit online type control
  - Patch 4: Return online type from add_memory_driver_managed()

Patches 5-8 implement the dax_kmem functionality:

  - Patch 5: Extract hotplug/hotremove helper functions
  - Patch 6: Add online/offline helper functions
  - Patch 7: Add sysfs interface for runtime hotplug state control
  - Patch 8: Add memory notifier to block external state changes

Backwards Compatibility
=======================
The driver uses MMOP_SYSTEM_DEFAULT at probe time to preserve existing
behavior. Systems with auto-online policies will continue to work as
before. The new sysfs interface is additive and does not change the
default probe behavior.


Gregory Price (8):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: extract __add_memory_resource() and
    __offline_memory()
  mm/memory_hotplug: add APIs for explicit online type control
  mm/memory_hotplug: return online type from add_memory_driver_managed()
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add online/offline helper functions
  dax/kmem: add sysfs interface for runtime hotplug state control
  dax/kmem: add memory notifier to block external state changes

 drivers/dax/kmem.c             | 645 ++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_mem.c    |   8 +-
 include/linux/memory_hotplug.h |   6 +-
 mm/memory_hotplug.c            | 139 +++++--
 4 files changed, 678 insertions(+), 120 deletions(-)

-- 
2.52.0


