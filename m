Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCA0CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7128E0001; Fri,  5 Sep 2025 09:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E456B000D; Fri,  5 Sep 2025 09:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAB18E0001; Fri,  5 Sep 2025 09:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 697BF6B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FCAD160138
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:13:13 +0000 (UTC)
X-FDA: 83855237466.17.B9F8FAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11D5F20006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:13:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qqjp4fTG;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757077991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FyIIqegIx0wfHeURsTvCMPzANphZ+sLHWvGCD0oe4C4=;
	b=8bY1Ct8TYoVZonSmVxvF/a45ckdJqjq1dHrAv3stMdyZ+YdHO4lm95hkknTk1DkS3iJHrx
	uTKxS8IpW9Kw+Ry/jXKJSDjL9rruNTL2IipKPysngXHnFQl7RKgnP7Zdfzs/NTmZ/Ql+Gc
	TV83JvoBnvrJCOVDOXGYgO0NpoT4AMg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qqjp4fTG;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757077991; a=rsa-sha256;
	cv=none;
	b=hoAq/HJ3ShBbqWmLjD3m5g0UegrYzu027FUwjqvi6+qKWEpZybDmaARVWr7/3PlqR7QHZ6
	RFGMgakvVYBcUABQ7RRQxKMd3ovKzUtxihCuwD6WjRdd7yNJ7itrWuHAZm6utDW4x69WeM
	o38sUEaB+MTp27J51Zi/MUX4XmyjDZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B3243E60;
	Fri,  5 Sep 2025 13:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FB4C4CEF1;
	Fri,  5 Sep 2025 13:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757077989;
	bh=lAKGsfnUG4rgDzqjzr2gwTb62JFdmQhbLIaqo8Ydwj8=;
	h=From:To:Cc:Subject:Date:From;
	b=Qqjp4fTGmt1agJ5gkKDXDVoyGrBWy/+xs1oMAD+t8nIH8Wne+DsxUYs4uLh71rW4o
	 CkzGfZ+CFJZFEAjsuwqMOYzhZtYtjxTz3V0LXTgzxpipASA3L6qCJzPPSxuBCZFgnA
	 FH2NCGEyCRERVJ1wUthH9fmpESPTPQu/YHMIO6nGfxlWN0Ffxo3lTx2jWyoMlcQ/H3
	 oY1UkN6LddelAKES3d2dDxpEudIpgymD11FGtElL1NPFBYlLdF3KUEoui5ebcDzTe+
	 Sur1SvJ7GpsshAC5gaIuKSJ0HAN4lz374eMfLPyRfQ9HeI4sdzSJQ53f4aVUac6dPz
	 E2ydBOL4tqx3g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] kho: add support for preserving vmalloc allocations
Date: Fri,  5 Sep 2025 16:13:00 +0300
Message-ID: <20250905131302.3595582-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11D5F20006
X-Stat-Signature: enoz57r3dbr6bdg8pd763zkngudadhim
X-Rspam-User: 
X-HE-Tag: 1757077990-828987
X-HE-Meta: U2FsdGVkX1+ZhwfU0nCLmU0ihJt3Tu/ejv4HJhdnT2Up1CaQNuUAUzxvYYnaaayXwQt6f5YWAXw12LFPH4lpdetW2KcQ+oqW6SSOeiTdkPtKV6M7gKOvkuvPZuTako5GxO2OZ3vPtU9iWyyrITxCrO491vCJfgd1eBjMHUONVolBhK2R2iqJthwj9LG/nowuzxtBk/n/hfyDj8Ta7OGPZaTHzzvGxL+51sHEtT/z07Lh+gO2OaXBwxBvoZvFzayhi7PrExYj6MMCJ9Wk+BsBbC53ezK0VdmrqVEH83FgfoX1yPfIna5ousxZLAr7TjGXvnGJs0yal9imUQfTThp97mfjUEYsUA9KwocfmDC+uqvVfv3eHd7otevPul9RrRPVstEaOeXA1hJwtcJ5N8rjZxXnPanRnyCJfZmSStM9rHuylvHiIBIMFokypdBWlXZw5Dz/Um1bcoc13wAw98w0E6lXOrsdzXCw11v5nhtL7cBCe+RPlQzCLgBPCPe9ceqg2ErPch2q/jxvNkLVZkb7iFIVhW4SJvvcCwIFJLV6mgRiWMvYUq5PjMQr5eRal9O6Q+TkvxBZsn4IASLjK2nDUUlF+clplyaBQSTOQR0uUBGLnbAKH29F0sfFNfZBrISdLa2Drs4wgzXkzSv9wR4Wwj92VZruy+Pwo07WaEtRQF/z8FyOCy49nRIyNathqiHbbNxKFoWAPVpRYisaAzsTdyADsuxKHFmRjIjJYqzr1SZyb4fwTK3uCBfxftGWXK3Bgv8DemweK6TRqa+FkXtsWqZDlyy1heu8O98bOMzCTY5iSvrefeQWtAhRcJP7a7mXr2m9nWtWQqJxw1PJBu0zZY/s0WO+sDK5fhQ9LDWQEebuL9wZDaNDjooK4hcQ46vg68LX1Xxon0ICLWWo5XhBHp/WPt+MnRAGoHo29dpPgXtd9BSb6zeYk8vy5FIS14e+niHz0cHhmJ8aHi75+58
 DidWLGhh
 ETwqPQUIOg9zSBLpEwJgYOVQ0sOtvSEQUJzlHkppHn6LJn7O9qSBJFSmhz02lXE3atRUdRgkzSnYdnGoYonSUOSFD8Q6amletocuVZVcGhTc6hb+4n0pZfVm8fUm/nUFNiwWsPq0PlA2REQUdSKOZTee8BHt3I0ylrl2YI8QH40qxHwLXVWzXaJgby5yGTc9Wd8A2wwBl91yOpOuC0tP5tlAut7ZSAjY1qfw+3hFnqwncWwk0vPqxhctS8U3yHWN19OkN5CNRBjFuKBU0a6GZF90WYztu2mlVkGBf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v2 changes:
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  30 +++--
 3 files changed, 235 insertions(+), 7 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.50.1


