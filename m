Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C7BC79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B4D6B019F; Mon,  5 Jan 2026 11:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C446B01A0; Mon,  5 Jan 2026 11:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4AB56B01A1; Mon,  5 Jan 2026 11:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF5196B019F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:58:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CE001401A2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:49 +0000 (UTC)
X-FDA: 84298519578.03.D0591F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6A21A000D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxhbXFH7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632327; a=rsa-sha256;
	cv=none;
	b=G2x3O1CoPeZxZS91GLtvaVFVefCSqshi9hsWOPvS3Y2jrjqmAIL+h+NcTkvAbVszUc3RWF
	2zNlLgUIRPgiDWm0bEV7yJjzCs2nCECOrCxvmcp7qX94ZK5e5zBYj3byYbmpQLLnsYOOZC
	g4rcGWc2AFkLxRFbALpd1sohv+N014E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxhbXFH7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ivdXEMRjHX8ActYuqmF+142e8M/tE9eaqLHBL0xTXos=;
	b=515um+TYCk5D7JjM+3n7wDYqfu7lTIJ+ZoYw6pWB/U/h6kveN65Q8xWUTUy4OSt37Cdw1w
	QN/WQ9xgoDafx8aHpJpD2UZ0g6E4uaw1HXStm2OQg4aszwzdmPLkHQ/L825eidDi7yN/Og
	XlFO+vy3ZbGK3gouJaE5D8pqntKhCZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 441C642A32;
	Mon,  5 Jan 2026 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF57C116D0;
	Mon,  5 Jan 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632326;
	bh=mupDn7J1NSAUZ9GV/4Xx6+A3fMSwov+EkCqaBWzjOm0=;
	h=From:To:Cc:Subject:Date:From;
	b=YxhbXFH76Gyi1Q1IeKu6BX24k5shRmCdHTfQU6bcQLC+cFfvY6krzkB7bYUSyKShM
	 uG3/cpRYYGDTPOIHfDhg2kcFrP5Gp6NamzlQawAXRrOlyltMcby7Mt9b8DBtYbpKto
	 96jjELOv3zquxG0gGWkrpuk7p0oWRgvwDoo1qoJl3fH6tAs2rYwQ4SqlsRgydOkP3B
	 NNkzjtmUJXTBdpSoq4sJFo9aigVIYb24zrKwUzbbPMlbk2LV4TRc/U+BGF9XgsMk1M
	 ASKyg5/3mtBaFz2gwK99f/FbiD3h8zdRbVQp+P3XwjyWFE/ZxoqDI4dziDjI6+yBUY
	 Qe4yO5QYs0iig==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] kho: ABI headers and Documentation updates
Date: Mon,  5 Jan 2026 18:58:33 +0200
Message-ID: <20260105165839.285270-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6A21A000D
X-Stat-Signature: 8oycypyekmnr1t7z4inbmd968uidq4ps
X-Rspam-User: 
X-HE-Tag: 1767632327-383795
X-HE-Meta: U2FsdGVkX1+N/hjXNPPk4hz1y8LQPrtxE0ggYTdkqxXAHkzuaVaBdkrXrgXGiFzNdpaEprsxT9aMq1hjzbbkfxv6DdE2U+FBTwLcPAqSx0kfDT0z/BM/dp+AqOPA09/yGr/koDvAAMya8M5eot7gnSZbdY7t3Q4kPLx4v4eBfXmBTNCbNwZarIW9m2LqJZjiSZ7qM/2G7bGrOzf7JxnX56VlY5SeQ3nocpNHEUrsAEU191L0Xi/I9iYO3bs7dUgaGWsMmAr/5Eic9OoraPej0+cEYoHi9CKrn2D+VELjv+3PJyiEyLOzQbbaCkowun5Mzn0fghseMDPXm0Aj7P6Vxl9IsS7EHkIkKmZoY8h06+8Vw2TcUM0n8dXNi69dxbJSdd/vpfgtsU43jXoFZ0OPsnW9WPzpBy79ECa1LTqQsg7ASDQPkrVw5Xk8Du3vTqxB1BNnYW3rMX2mhkg1Greweckkia4TlUwbFj1uN2ued17hiD+qwT8HqGdq4Bqd0+H2ML1A8R3ppXf2LzW6EP4/GvJWxiz9Fv1A9tE5VqoxVGjddww0w6gbvxl1149YWjQ+I80+zF1DXzCUv+X9dHzF7gisW6xhVuF0CcMHW2J4CFcIYWBYJa3oBkotrx3XTOH38zpVJR772zCaXkUDpum8fMmImgPKuEJEYOM9QJWVbyxQv8aExIVWeMu4mN3lAxukPjcvxEc8H95ShVadT9GRgda3CCv5LGuzEhOwZZ8FM8c+3g7wNeIF19HI3c8DxoOMdbvdxePAWQHBOJ9Ze1U9muFRebAE5PRGihqmk3Ccs8ti7unzByzB7gLKWMzCyXz7s+EDOYfrcRBwzU02cIfFFUhef9W5ohs/zKWD25RYFingxq2DJuyJjRoF7zKyOfLbXqzZV7RIO0j1fn68nTfZpw+Y3/buJyDk53hHayhPW38U0bs/mT/grg4GHtLTm5+lF1Xm0Efg2h1AzzWFNBX
 4ccOWaWk
 Madjw7PlNKe14Az3ePKB30xFFh/twaU6e1J9tOtmeQ1dV+WYx6YDoYIeT9pMuMMoLgipgA30U/uIub2ADQwttYFxkvWhYQF7+TsOn6tnDUulFf8QpXDtARxz11/WJZPUiVGxoOU4T4cYhooaXjCg9+ILEH6tWfDF/4uB3EOpQjcjp0C2SoC5hR6b335KX6ZIrNKXF9/8E8Sj1QRE32B3gzQsPocX+grYnVzC0jApX8C7u5LQJi+nXTzaVibFTvH5tIB5NfjcULZMF4To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

LUO started adding KHO ABI headers to include/linux/kho/abi, but the
core parts of KHO and memblock are still using the old way for
descriptions on their ABIs.

Let's consolidate all things KHO in include/linux/kho/abi.

And while on that, make some documentation updates to have more coherent
KHO docs.

Jason Miu (2):
  kho: Introduce KHO FDT ABI header
  kho: Relocate vmalloc preservation structure to KHO ABI header

Mike Rapoport (Microsoft) (4):
  kho/abi: luo: make generated documentation more coherent
  kho/abi: memfd: make generated documentation more coherent
  kho: docs: combine concepts and FDT documentation
  kho/abi: add memblock ABI header

 Documentation/core-api/kho/abi.rst            |  28 +++
 Documentation/core-api/kho/bindings/kho.yaml  |  43 -----
 .../kho/bindings/memblock/memblock.yaml       |  39 -----
 .../kho/bindings/memblock/reserve-mem.yaml    |  40 -----
 .../core-api/kho/bindings/sub-fdt.yaml        |  27 ---
 Documentation/core-api/kho/concepts.rst       |  74 --------
 Documentation/core-api/kho/fdt.rst            |  80 ---------
 Documentation/core-api/kho/index.rst          |  78 ++++++++-
 Documentation/core-api/liveupdate.rst         |   2 +-
 Documentation/mm/memfd_preservation.rst       |   2 +-
 MAINTAINERS                                   |   1 +
 include/linux/kexec_handover.h                |  27 +--
 include/linux/kho/abi/kexec_handover.h        | 163 ++++++++++++++++++
 include/linux/kho/abi/luo.h                   |   8 +-
 include/linux/kho/abi/memblock.h              |  72 ++++++++
 include/linux/kho/abi/memfd.h                 |   6 +-
 kernel/liveupdate/kexec_handover.c            |  34 +---
 lib/test_kho.c                                |   1 +
 mm/memblock.c                                 |   4 +-
 19 files changed, 361 insertions(+), 368 deletions(-)
 create mode 100644 Documentation/core-api/kho/abi.rst
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/memblock.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 delete mode 100644 Documentation/core-api/kho/concepts.rst
 delete mode 100644 Documentation/core-api/kho/fdt.rst
 create mode 100644 include/linux/kho/abi/kexec_handover.h
 create mode 100644 include/linux/kho/abi/memblock.h


base-commit: f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
-- 
2.51.0


