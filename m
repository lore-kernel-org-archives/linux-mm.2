Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545DD606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=BtIu0Yrh
Received: by kanga.kvack.org (Postfix)
	id 42D926B05B8; Fri, 20 Nov 2026 12:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6F76B05B9; Fri, 20 Nov 2026 12:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6596B05BA; Fri, 20 Nov 2026 12:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF9646B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:49:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A59C40119
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:49:35 +0000 (UTC)
X-FDA: 85456234710.21.30BA6D3
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36BBA40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:49:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BtIu0Yrh;
	spf=pass (imf17.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196973;
	b=n6wdbBeAAgj5OzsXHM2EO26ekhcn+ZbC+mPJ8BudReDJto/WusKf8TJdfiapnFnMo5uv1D
	im2BYJ4CQv7YnHDqScDiGHP2AAgIU+C8qfCoNzzTBbYUt7A+3C2bxuwXWRQTPqQ1Dqn6mK
	tLmPt1cBBYRYiy8W1rCipZsp4GqotI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6R4bkEbuO1sKsBxVNTjwrRYQXlyXlhs6GOh+EH27R7A=;
	b=eMJGK/bFLIp9+L82mIQCvQMfVFEwQiJPcNBhBXc7XX8TMibZdEuPip2UwbNURoOxdsTC9u
	30qMo66miCdhS74fvClQCCK//OD2sI6gF+2u65bK5DDcVG7DEBt8l6auAcAqAbVY8vRNQA
	3Duf84kTohTuu3pNSRMh0giLSSZVQMI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BtIu0Yrh;
	spf=pass (imf17.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795196973; x=1826732973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6R4bkEbuO1sKsBxVNTjwrRYQXlyXlhs6GOh+EH27R7A=;
  b=BtIu0YrhCwgU/T8dcm2FnqkQpvVHo6w5hcWlX/XyXy13z9i+1QFEimXN
   TdeQpU6xSuHe1siXoqYO8aq+6lmSsTp0o8BDHIQqXDhVIQ61nsw0Zv2ob
   3EbG6hy1Lrn4D8xhZFvCxl8qhKksv0Is4BHN1PdkJpNlef+yv649ls+mj
   18jhIlxxJwY6RJQH54NVG6MXVUjJP60hMUpip4+vrP5bowrUa8nYXv4mg
   pX9mPHEqtm/qia4oKgCI5v7VYH17flnPdXtKK+sqqWwvJCSGEq43pwc5z
   v+9JUWBW1WcQfSS69Xfe2KNpscy74wUBwRDi+KgElCtjynZV9C1sPg9Xq
   A==;
X-CSE-ConnectionGUID: czFhMcfzTxe08cWvEc2TGQ==
X-CSE-MsgGUID: nPKQctD3Qeaak16icO4TvQ==
X-IronPort-AV: E=Sophos;i="6.27,223,1787011200"; 
   d="scan'208";a="34665825"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:49:32 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:17503]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.204:2525] with esmtp (Farcaster)
 id cc4b8551-c795-4eb1-bcdd-34b19247f660; Fri, 20 Nov 2026 17:49:31 +0000 (UTC)
X-Farcaster-Flow-ID: cc4b8551-c795-4eb1-bcdd-34b19247f660
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Fri, 20 Nov 2026 17:49:31 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Fri, 20 Nov 2026
 17:49:30 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.18.y 0/2] mm/execmem: keep the ROX cache huge-page only
Date: Fri, 20 Nov 2026 17:49:17 +0000
Message-ID: <20261120174919.3789837-1-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 36BBA40007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ntwnnpe3ezboeekmxqid91kfo6anxkpy
X-HE-Tag: 1795196972-730243
X-HE-Meta: U2FsdGVkX1/rxh5UI9jRUVkhpqLKob2ITKvSft6m2rP31rRgpxbAwo4BVjKjdoD3RD/V9fWdI9uTZ/cWo3NxXI5EuWLxtLISq5iNo/QqA2mTaxC+BM+sxuzWPgLl2TBUO1W5MmO8yI+78QvUF4kRnzThUAXXiXOysqH/LOMcECzXBLlpNy482AmnbEVdVL5tRIZ+unqoGc3rLQVMtl3ANJzgsnyRQ2hle+vwgltGMvXNKnj9Ce/4ewtfCmsjpgwCl/tpbvpVspQCQ8wXAfGBrKALpDhSc9j6DOIDsgXYAaEO/sLViPtBZfK4JymuKiNqCVteHy8U/fLudFhkEr2b9VNu36fRYu98LsUkKxg3uvcRxTFVqJzvqPIjJr/iSO//b9QnTezwMa31AJGEWxIvgRzO4izc4M2/vG2zp7rXyvN7WUMe+cdSAaUxbRN2hYhQPefzkG+xvThjdrU3qsBeK2CqkooWaxUcU91TZ5gzZzZdYIXDTUHJwWGdTKQXMPlHSCQhK72XWQC3vxYJbmCujRuyj+GlI4PHcNZeYOzI+318Dz+aLFUfZZrV7e6QNdjZRzamC8bv/4/5j9asKqifAswLG/GdMrbRb399JyvhGi+8A1t7TfbW8OEAhmhl/2xT9TzoCLNKpP/hjFlMQWPr7S66wghvvO9z69X+oUk9aaAg2v/jvD08eswIGO/AjimBOAfrDjMz8WA1t0luDavPPTP3xT7s57xuCIhGD7lGaLwr8hiwszo+0ePk0vUGnVT7pmAs/OIGcMH62MeByxrNPuaJeqXhbNKMg5/PDSpKWiltizUhhBIgZCymv2X5Q7BXkHd/YPRE2PW6EtWw3MPYdpOW7k6jgYS+xqaDRj0TI5dNMXwwPuQuP3NEyUfs/Xu8Uj9oZjJ/fBLqYUzR9GV2uvQyspfSJFrhU2Q00Mb5194h4Q4H22wuI8Af4mIA4Im3Gc9FGX0p1LIu26Mmg7N
 +S7NJTHb
 ELZrnuT4lUBgdDyBc+hf8idyurLVVv5OVVvutGkfPYXmWntMFW13nO1CVxLericmWeMClm77i/y9M5WBQjVkwkC2oNvcDHQEQQBEd6C4f4rM9o4e9Oi9l3SKq6RTIxrro9ZyGuwGjiqHgll0Lf6PSVzW0douST9uU+RG1dYMQe5b4UtUfEbGWh5YiRxZ9Aeg/lA5vVF5Y2vk3USkE20dcW+dxnoRfTQlJgrMmgUpUQcqUR2m65UC/ZPZoGNZb9/1BxT6QCIOJuAwQgIUvYRXtYkDu55WMHNtGNxdB6jg+PbJ0aey0P5Y8pqQBNYadYpCwe6Jbba72nLMGEyjiEnQz9C4yseNLGOJKtLOzMIU8mPsWGdyfl4Ir4FXpEN0TN4sHEbFdirc9bAQUT3LHxSkz0QdZFp5O77PLAO5AfYEOChRQkRhCLilP8ue3H7p+9sZwHiPIKZ8iVQmoeZh15ilndD0I59uLjNO2YozFeU2xXEZx0mp8N88gUYgRp+RunuV7Sr7H3EgaeuObbwCln63tgiECjJgBm8RFD2BSnfRDcnmXoEvlT89KgyjVS8ALmQpPE1W5o0TyG/wFRGbkUXSxg+hllJ3yhc1E37FzlKCYCth0X6eLMKxh5k3DvU/d+Pkktdel2QiwPXEAWd0Xw4I7vUWXdaUVDeT4CzJilH83LnAYaJQEA5vQKz7gJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please consider these two mainline commits for 6.18.y:

  d80773cedde2 ("mm/execmem: handle potential allocation errors in the maple tree")
  569db54d8b7a ("mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE")

They complete the series whose first patch, 52d95a55a011 ("mm/execmem:
free ROX cache chunks only when they span an entire vm area"), is
already in 6.18.63 as e4dcde9709a2. The same two commits are posted
separately for 7.3.y.

On x86 systems with 384 CPUs, udev coldplug runs several hundred
concurrent init_module() calls for the same modules (kvm, kvm_intel,
irqbypass, x86_pkg_temp_thermal). On a ROX cache miss,
execmem_cache_populate_alloc() reserves a 2 MiB area before it takes
the cache mutex, so these reservations briefly exhaust the module
address range. Each failed attempt prints "execmem: unable to allocate
memory", although the exact-size retry succeeds and every module loads.
The exact-size areas then stay in the cache and are never freed. On
AWS *.metal-96xl instances this shows up on about 1% of boots.

With 569db54d8b7a, the cache refill only accepts a huge-page backed,
PMD-sized area and fails quietly otherwise. The allocation then falls
back to an exact-size ROX area outside the cache. d80773cedde2 is a
prerequisite.

6.18.y does not have 4c4b2ed5b783 ("mm/execmem: use
VM_FLUSH_RESET_PERMS for ROX cache allocations"), so both patches keep
the existing execmem_set_direct_map_valid() handling for cache chunks.
The uncached fallback is freed with plain vfree(), so it uses
VM_FLUSH_RESET_PERMS like the non-ROX path. Each patch documents the
change in a [ 6.18: ] note. Mike, if you would rather have 4c4b2ed5b783
backported as well, I can send that version instead.

569db54d8b7a is above the usual 100-line limit. A large part of it
moves the ROX setup into a helper that the cache refill and the
fallback share.

Testing was done on c8i.metal-96xl with an Amazon Linux 6.18.62
kernel, without and with all three patches (e4dcde9709a2 plus these
two). Both kernels also carried a test-only patch that keeps the
execmem helpers traceable. Each run did 20 udev coldplug cycles of the
modules above, with two runs per kernel:

                                     without      with
  "unable to allocate memory"         20, 29      0, 0
  execmem_alloc() returned NULL        0, 0       0, 0
  module load -ENOMEM                  0, 0       0, 0
  uncached fallbacks / allocations     n/a        709 / 88288, 346 / 87832
  median coldplug cycle (ms)        5496, 5777    5845, 5986

Both patches apply cleanly to v6.18.64, and mm/execmem.o and
mm/vmalloc.o build with W=1 on x86_64.

Gyokhan

Mike Rapoport (Microsoft) (2):
  mm/execmem: handle potential allocation errors in the maple tree
  mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE

 include/linux/vmalloc.h |   1 +
 mm/execmem.c            | 109 +++++++++++++++++++++++++---------------
 mm/vmalloc.c            |  15 +++++-
 3 files changed, 84 insertions(+), 41 deletions(-)


base-commit: fd7cfd39c88596fec816639ad83cbf3e9d316372
-- 
2.50.1


