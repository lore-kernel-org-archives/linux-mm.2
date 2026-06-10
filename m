Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F182DCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C246B00C2; Tue,  9 Jun 2026 21:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DA86B00C3; Tue,  9 Jun 2026 21:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E526B00C4; Tue,  9 Jun 2026 21:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D792F6B00C2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 613E440830
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:28 +0000 (UTC)
X-FDA: 84862310736.15.57F9F50
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id A082040009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="g/Rkm7UU";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781055926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u+GrVwUVnyXoJ3l/Ws8SD/JHytJBmijCAuGEqrIfnVw=;
	b=ncloOCMp+pSXh0PZGfmwlHVYo/euvDnJkSVQcYQbDBUAxEVKabrC5mUlNAApd9MT+Z0h5l
	oOQd9X1ImrtmBOu+HctSJsuJ5JeT9Z4rr82JEbDLm0D4py3QPqmaCky3G0cE1qCtFLGEwt
	IIweUO1N0/Uzt46rKRepgaw9UwwEjY0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="g/Rkm7UU";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781055926;
	b=QadEpQzLmQVNb2KN31ZQsTLGF6eV+vZLAYMPYEp+IGtmuvGqu0+iQFvkV0FKBYtKGNI0wL
	Ia6GyaUicQG+30Es+yVnFh+iNi83M0Nen/sFVOvAj+K3IvN5HN+FOdfIUVS6SjxmLbkCCJ
	Lj6mqonZrbkxLTWnRYeslZwWjKE5Chk=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9159951f05aso719408585a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 18:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781055926; x=1781660726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u+GrVwUVnyXoJ3l/Ws8SD/JHytJBmijCAuGEqrIfnVw=;
        b=g/Rkm7UUrtLK7tje9Wh9Kk90IjPlLsFJgGaEa4GsGkFo8D05KmSvtfH8n0amXDNHOj
         gqmHWhY0jVeSL0paRnk5y0UGX7l6t8PeM5sDJTnHAQ5LhMFB3Hz+C2LvXIbJg6kHcIAk
         lIUEdE5qf814AYYhw9iTMsagKJaa5vUtbHVRj6Y1D21OCW9CJNTQwAsYvbCZjeNs7Qbn
         O4hrZhDPppKUGVu3ppBzmHatZB5ivvT8jtJ2gizsZ+GWSGd1cbUG+2Qp1yHv3YzQBLBV
         cqmKS/d3SGzFOubpCfrUM5DMAa6ma7yw/wldys0O7jI1zeDb+f/CnNsTFd0N5j8gYiHp
         FI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781055926; x=1781660726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+GrVwUVnyXoJ3l/Ws8SD/JHytJBmijCAuGEqrIfnVw=;
        b=ZotbNCCnCnnpHLhTdvUeeHpeXr2IIBcT/S0aiuno3jIBMEpJ7RVJK+2gULGdSxpGIa
         mdF5OyeNMB9iG16rbPuS+bXTLCZdsgPBznaMtbougNV1d0BLmaFB0lqXz2QI/zAbW6u2
         ePwgI1KR334+XTKhM3zOkDSW1aQ1Yv2mzfqh70jRg0hRzdh+DdVeIOTsy6Y5xSlsfyfU
         zsBuLMprEzajRtrO3WZm+3eMAMtsqJQPkNiM2yzEFEgNWlsl9Ln4IJVvq3qodW4Mk5wn
         m73Ni6Jk52abXpVjuelg9fFKp3v6nwdIRESQ9zt6GyLJAIeD+/gJOKk481KfBdYr+t8g
         ULnQ==
X-Gm-Message-State: AOJu0Yybysl8wJKmRYycS4iHcMDMoxk3FhXmHBjpaMeK07obrdFCPQg1
	5IhT632jQCT+2LYEvaZ+Xl7pe60Nxs5LyQQfdxhDfeZOn+UcX2JPGAGSDsmKgFgxiMrGmGDMUwF
	Fhccz
X-Gm-Gg: Acq92OHBD3bWmqX3L2ZGmGxpKN1APx7xJ3+OkpP0j8fA4/E81NYhLP4p7r5xWvyiybK
	D3K/ppIootS2YjGyhyui3IG8YjN/KO8F9uVKjKZ/Q/25sAWq71Ir41z3ey3NQP2C7okdmDOo7av
	22I2Q86Py3pjaQFZK7KNiwoYsTGHGaPmuaMkj5jFZi7r/a6PiRkds/3kIkgksBdxrxRrSPTL5/f
	jc+lNcHpH+vgheJZ87nhCZMJTBjH0ApQaN3A+NjHp34LNT+M7VzwH35esno8SGaaxt+yAvtpiWa
	iAFTr1qrXq8+Euq4IiaP8HdnpSRFktMkCDne0qChf7sS6SqDHb9ZQk/upxOmsjeQ9f4trwEiylU
	y+h1X6oc+HRAVxAuoyojHw4lj6h/bkD+H5H06qmL81cdFib0uTcV/P2wZ4/jCEu8diScjJz8AWS
	+xs/ctvVYGszgxhBiLYr8RBigS/Dz80ntjKvWb71fr1nChiGQH2d3YbqU7SWnCq4IHcoObtgXUB
	8lTIKY0hLxD/seABQErc+g=
X-Received: by 2002:ac8:7612:0:b0:517:a02f:171a with SMTP id d75a77b69052e-517a02f1d7bmr208979241cf.36.1781055925526;
        Tue, 09 Jun 2026 18:45:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c07e91sm205923261cf.4.2026.06.09.18.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 18:45:24 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev,
	kernel-team@meta.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	rafael@kernel.org,
	lenb@kernel.org,
	gregkh@linuxfoundation.org,
	dakr@kernel.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	rdunlap@infradead.org,
	feng.tang@linux.alibaba.com,
	dapeng1.mi@linux.intel.com,
	elver@google.com,
	kuba@kernel.org,
	ebiggers@kernel.org,
	lirongqing@baidu.com,
	paulmck@kernel.org,
	gourry@gourry.net,
	dave.jiang@intel.com,
	jic23@kernel.org,
	xueshuai@linux.alibaba.com,
	kai.huang@intel.com
Subject: [RFC PATCH 0/3] mm/numa: reserve standby NUMA nodes for runtime claiming
Date: Tue,  9 Jun 2026 21:45:14 -0400
Message-ID: <20260610014517.253609-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9sfnd3y56cxogjf45rnrjrxeufajd9wd
X-Rspamd-Queue-Id: A082040009
X-HE-Tag: 1781055926-746442
X-HE-Meta: U2FsdGVkX189uTGIhKrPSiGD0j87aAycQzEaDsk3tNioOa/3ECPCznyZ3PzM5sc3Yo/47DlJMlWUAPSwZBq6U0Ihic4hqDcedApbb3CgZbcdTPis1iNWq6KW2o+2agWUQyAjs5z3EAMdgbqQtY5pZAw0yaiyVuwUz4VoTeJQ2dK2F4QYkh6y12Y/TUfYtNW1tL4CkJKyV/lIVUfriZSZfGw4sOvjBl2X/NFMAruQ7XUnfXYkuP5PklTmGYFMdx/xR7ihfIYVaC7eCJ+zBrFjNXUN0BAuhvOWL1d5yW2Y566HvwK6g5NW3KhPH5osScqlPlko1ilA6Htdb5fQeNUeD6ljzvrVjKDehANOhDh1sv79myjLZydtAcJH6qmA5aBNk6DZ7aEnz4Nb1VWc3ryUfwKmuD/WQ6AMSRTTZT9CE+/0wIJMxW4Glp7tuOo1Wm+ZGlOQnPaQnImqLKhJhxFaeMsrQmq+vzYCEVGJtE/sTNDSJs6JW05e2fiXFw3adpLNnnmw1wlejP+yG7T99zFhRsLlzXpcO0AYsKFS6JxQTbyk7qTMkrNvKt8KChhUMQNwSAS6oeHQSQ7IoUAvE0ftRZX2kmkTZACO82gsiUEyjTXKwMKCl9n26mQQmDMwRb00+5VLe1bNaOWMIxVAX2i2xbat1eYTx14O1yvxsib2IsgtkMr4XdVFC06V6lvIaXPvo5l8wJ1oPeLgeZpTrJ6AA4v1DoF0c/W8owPULXEwSN65BhQGxtRxGI/YnVSAYnBR6a0AaBWjY7T9raGpiM3YytFzHkE+QW7XMNDR/mwQxkUD1m4sejyAPba1falP3BHSmYYTY7jE1mf3BuOIAzvOvjOfL7nr1WOFnlv040aXZmynU0GzKu3MBcjGuhxSKg/6fpNyXBVIm7ntv/cL7e9IQYGFRpFyR9ssUt7HG6wXvWidGN0ybeWRLFGNx7Lc/nX6QSeTsj+x4N862vF5YrT
 N+vtsLKw
 0TE/lPcC4aC9WABEYKf4/xI5OIVd3DKeiJ8agvttP0wejVFJeMrCrQlD3S5LwRALVEtnaGjzgpGsA1v/nn7pRCa7Duu0pe6c0DGeMq105Ja3c9JYhi1/d5dfuM7tM5xgQFbCo1sht5rtirxhrcuwSDHUSIE6o5JLhWaO3Z/ARmrwhOE9ZeQYoqj2fR+oLqjiev2CJ2lQkUjH54GvMHE1z4+sikRQD+AiY7AIwv9rtiy/z90pKoDiYuoEZYvhG3mOt/x7Nb1GRGoKlLr+hEiRHjluQCoTWmxeedzsEci/095ZleDom4w6mVxUwIxpi6iiCJReSAuqkk2mlj0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A NUMA node must be "possible" at __init time to be usable later; a node
that is not described at boot cannot be brought online afterwards.

For memory tiering or isolation it is sometimes desirable to spread
hotplug memory (CXL, GPU, virtio-mem, ...) across more nodes than
firmware describes.  Additionally, some memory devices may provide
more than a single class of memory and need flexibility to redefine
the effective topology at runtime instead of depending on BIOS.

This series adds a way to reserve empty "standby" NUMA nodes at boot
so drivers can place hotplugged memory on distinct nodes later, at
runtime, without those nodes being described by BIOS.

Using the feature
=================
A standby node is an empty, offline-but-possible NUMA node: at boot it
has no memory and no CPUs.  A driver claims one at runtime, brings
memory online on it, and releases it when done.

This series adds 3 ways to reserve standby nodes.

  - numa=standby=N
      Boot parameter.  Reserve N extra empty nodes.  Platform
      independent; works with or without ACPI.

  - CONFIG_ACPI_NUMA_STANDBY_NODES=N
      Reserve N extra empty nodes on ACPI systems (honoured only when
      firmware produces a usable NUMA configuration).

  - CONFIG_ACPI_NUMA_ADD_CFMWS_NODES=K
      Reserve K extra empty nodes per CXL Fixed Memory Window (CEDT
      CFMWS), for CXL topologies that want several nodes behind one
      window.

All three default to off (0 / unset).

Reserved nodes show up in /sys/devices/system/node/possible but not
.../online until a driver claims one and onlines memory on it.

Testing
=======
Built and booted under QEMU (virtme-ng) across a matrix of boot
parameters and topologies:

  - Each reservation source, individually and combined: reserved nodes
    appear as possible-but-offline with no memory, claim/release
    round-trips correctly, and node distances are sane.

    The CFMWS path was exercised with an emulated CXL Type-3 device
    presenting a CEDT/CFMWS.

  - Fallback: when ACPI NUMA init does not produce a usable config,
    no standby nodes are reserved.

  - NUMA emulation (numa=fake): renumbers the node space.

    Standby nodes are created only after the (possibly emulated)
    topology is final, so their ids can never alias emulated nodes.

    numa=fake boots cleanly with the feature enabled and behaves
    identically to a baseline kernel without this series.

    Tested with CONFIG_NUMA_EMU both enabled and disabled, and with
    and without numa=fake on the command line.

  - Default-off builds behave identically to a baseline kernel.

Gregory Price (3):
mm/numa: add exclusive node pool and numa=standby boot parameter
acpi/numa: add CONFIG_ACPI_NUMA_STANDBY_NODES
acpi/numa: add CONFIG_ACPI_NUMA_ADD_CFMWS_NODES

 .../admin-guide/kernel-parameters.txt         |   8 ++
 arch/x86/mm/numa.c                            |   2 +
 drivers/acpi/numa/Kconfig                     |  35 ++++++
 drivers/acpi/numa/srat.c                      |  14 ++-
 drivers/base/arch_numa.c                      |   2 +
 include/linux/numa.h                          |  14 +++
 include/linux/numa_memblks.h                  |   3 +
 mm/numa.c                                     |  90 +++++++++++++
 mm/numa_memblks.c                             | 118 +++++++++++++++++-
 9 files changed, 284 insertions(+), 2 deletions(-)

--
2.54.0


