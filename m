Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0CECFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E9A6B0032; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47796B008C; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25076B0089; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7BE6B0088
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E5E089F85
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:28:43 +0000 (UTC)
X-FDA: 84135450126.06.FED4B83
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11769100004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:28:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763749721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=D3mDSkgbl/ChIowwj1yHgyEbiS62OCuzJ8RtEU69P/U=;
	b=VWY5/4b1FdSX0NUu4Wqgxfe8yS3HDj+qrXmjyd1dFGbcezUzq/3MjkfMrwe6cDYZaLmNQ1
	IbVhJYy1Hvz4BcYD6CZzGkVnOblHqJzjBNb03SfuqzFjYx4BkzuLAE+1RjtfEDI2RPt4/3
	oaokEIFajbDGwP2ir574B1WUbuO9C/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763749721; a=rsa-sha256;
	cv=none;
	b=keaphJJ9FoLHxuJdLzyf8bZTJF6quwWQxsABsQk+6l63u3HzJKI/1jcXpYswFnJvijMc3I
	eUTOR+rtWYxdpBUcBUGxHnzOAHuXzO6dDiW6lirFycZX1ZrZlyOeoeLoLuuvM7qzZ+pWxD
	qfDQVjxI6+MuIbl2RyEj4ntVseE98fc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dCkGs36MgzJ469q;
	Sat, 22 Nov 2025 02:27:49 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (unknown [7.214.145.227])
	by mail.maildlp.com (Postfix) with ESMTPS id E556D1402F2;
	Sat, 22 Nov 2025 02:28:36 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.195.246.188) by
 dubpeml100008.china.huawei.com (7.214.145.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 21 Nov 2025 18:28:34 +0000
From: <shiju.jose@huawei.com>
To: <rafael@kernel.org>, <bp@alien8.de>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>
CC: <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>,
	<rientjes@google.com>, <jiaqiyan@google.com>, <Jon.Grimm@amd.com>,
	<dave.hansen@linux.intel.com>, <naoya.horiguchi@nec.com>,
	<james.morse@arm.com>, <jthoughton@google.com>, <somasundaram.a@hpe.com>,
	<erdemaktas@google.com>, <pgonda@google.com>, <duenwen@google.com>,
	<gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>,
	<shiju.jose@huawei.com>
Subject: [PATCH v13 0/2]  ACPI: Add support for ACPI RAS2 feature table
Date: Fri, 21 Nov 2025 18:28:19 +0000
Message-ID: <20251121182825.237-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.195.246.188]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100008.china.huawei.com (7.214.145.227)
X-Stat-Signature: d38gmhkcmpp6ax3bdfyaw5bife4heyyj
X-Rspam-User: 
X-Rspamd-Queue-Id: 11769100004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763749720-201430
X-HE-Meta: U2FsdGVkX18ZqQR2w9rhWv7Q5r021SFL+uJI3PjIo6RSOxnLcYEmZ01PDRL7JdtrnHusi+cXtNxB/TShFmA5BQ8NzEkO7N2bEw5p4B4ExNUB6YNEWq3KZmbK8fqykcDvJBmnWgjcnxQ7ORF+NIFUBYc2V93LG7WvG4bkxdFfFWUF3QY6ae2ETvBS8eoJK80r1poY2EvuXXk4HDcypaTwfS9RThxETfIIVzst55Kec5pspQ3ASsyT7+RRpjuoKxxcoGjsPDMrzQIA4iTFlc/qDMmnG/hCacFrXcomXmxaJIRr8KE2fCmaq2sdjomb+dRwqzWOeyXcxsbMXUOpKwvPSBZ0WQzvAV31wRKxSY0AWPLgJ9Dwt7s0GECJQiarPqhjOzlhXCtX1u4Y6vQbGaeiDxTOveNivnVitDhdb2R9QamJmb6WGcASXzL8LfgsFhe3NW1JRSfDdGWIw33PBkqEfvd8x1A058vNWOPpzUAdLhW9Wdgi8X/sS8Irf4qgnl6yC1R6XhfRaPdnioJ/v7UvFe9oNUtEk/OkeyxafXJENC+6d/6GE0rTf6uk7pZX6e/wapk+U7R8HuLZ7R+3TASU9jFa9MshDq5l24xqlbiDVts8fb7lhq6/8PNeiR8M7bJecHLthKFvAqWt2fA204gSizEOq50MwrU5RUuJiQ6U/S/w34SKGjuv6Jv9wEmC1LV3OgFj3rWHnmMvvRwHuxzRBjMsZC/e9PIrz0O/j7MA2rKTuFZWTECDS54ZH9OPp8kSZRa6gJuTaO1VgZGpJmJXvQiYPX/0VfNgbAeRqlGcYqgTXBANBZ+2BaeTOUMpukrytTuLX95GHs5yOsgC1AWzQ2DJuuKeROeUJh0dkWhZytf+nAP21OO/kJcS94RDxhvV3Kcyutta23xjFwUMl0Lfg1/2L13k/KlEFiKAY/94Tx5KBzP+poIa+AoEkrDmUASSzcvFm1S126GNrr0tZ+G
 226/fAbA
 /y6X8KBPbXhU3KNqJtC4+b68Os+s7d9GSVGy5bamcPkP6VJaASRtfXXVMp4tou6G4dIJj5haLwigIS/FUdJ8AGkXSj4OWjgy3UJ38RG9sKMuHSEpYssk2650lZQUna7dePlfQmxdM2AdA0yg5w+p3UODKX58HMfjN+TnXMwObDSdMbaxhlfPUErhUxsXY3Jx7njNm5WPaXbkpJYDsCwU1Yf0hVRWilPhZScO61oHLCo04RjkrgKUdn94AMsOyR6yWBc6QO1hvu+sgPJPAbx+bSjrAH2d5N4gUkbwZ+2Jonz2hZ/wBIo8DSWD/n2btZeYVN+D+0ki4/DMMvvxgxVqxRVUV5Nl5vpJHf+MvpltpNaChwwJNCya65MdU1s/1+yQ8U7tC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

Add support for ACPI RAS2 feature table (RAS2) defined in the
ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
scrubbing feature.

ACPI RAS2 patches were part of the EDAC series [1].

The code is based on linux.git v6.18-rc5 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v12 -> v13:
1. Fixed some bugs reported and changes wanted by Borislav.
   https://lore.kernel.org/all/20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local/ 

2. Tried modifying the patch header as commented by Borislav.

3. Fixed a bug reported by Yazen.
   https://lore.kernel.org/all/20250909162434.GB11602@yaz-khff2.amd.com/

4. Changed setting 'Requested Address Range' for GET_PATROL_PARAMETERS
   command to meet the requirements from Daniel for Ampere Computing
   platform. 
   https://lore.kernel.org/all/7a211c5c-174c-438b-9a98-fd47b057ea4a@os.amperecomputing.com/

5. In RAS2 driver, removed support for scrub control attributes 'addr' and
   'size' for the time being with the expectation that a firmware will do
   the full node demand scrubbing and may enable these attributes in the
   future.
   
6. Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
   the demand scrub, which is used for the RAS2 demand scrub control.

v11 -> v12:
1. Modified logic for finding the lowest contiguous phy memory addr range for
NUMA domain using node_start_pfn() and node_spanned_pages() according to the
feedback from Mike Rapoport in v11.
https://lore.kernel.org/all/aKsIlFTkBsAF5sqD@kernel.org/

2. Rebase to 6.17-rc4.

v10 -> v11:
1. Simplified code by removing workarounds previously added to support
   non-compliant case of single PCC channel shared across all proximity
   domains (which is no longer required). 
   https://lore.kernel.org/all/f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com/

2. Fix for the comments from Borislav (Thanks).
   https://lore.kernel.org/all/20250811152805.GQaJoMBecC4DSDtTAu@fat_crate.local/

3. Rebase to 6.17-rc1.

v9 -> v10:
1. Use pcc_chan->shmem instead of 
   acpi_os_ioremap(pcc_chan->shmem_base_addr,...) as it was
   acpi_os_ioremap internally by the PCC driver to pcc_chan->shmem.
   
2. Changes required for the Ampere Computing system where uses a single
   PCC channel for RAS2 memory features across all NUMA domains. Based on the
   requirements from by Daniel on V9
   https://lore.kernel.org/all/547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com/
   and discussion with Jonathan.
2.1 Add node_to_range lookup facility to numa_memblks. This is to retrieve the lowest
    physical continuous memory range of the memory associated with a NUMA domain.
2.2. Set requested addr range to the memory region's base addr and size
   while send RAS2 cmd GET_PATROL_PARAMETER 
   in functions ras2_update_patrol_scrub_params_cache() &
   ras2_get_patrol_scrub_running().
2.3. Split struct ras2_mem_ctx into struct ras2_mem_ctx_hdr and struct ras2_pxm_domain
   to support cases, uses a single PCC channel for RAS2 scrubbers across all NUMA
   domains and PCC channel per RAS2 scrub instance. Provided ACPI spec define single
   memory scrub per NUMA domain.
2.4. EDAC feature sysfs folder for RAS2 changed from "acpi_ras_memX" to  "acpi_ras_mem_idX"
   because memory scrub instances across all NUMA domains would present under
   "acpi_ras_mem_id0" when a system uses a single PCC channel for RAS2 scrubbers across
   all NUMA domains etc.
2.5. Removed Acked-by: Rafael from patch [2], because of the several above changes from v9.

v8 -> v9:
1. Added following changes for feedback from Yazen.
 1.1 In ras2_check_pcc_chan(..) function
    - u32 variables moved to the same line.
    - Updated error log for readw_relaxed_poll_timeout()
    - Added error log for if (status & PCC_STATUS_ERROR), error condition.
    - Removed an impossible condition check.
  1.2. Added guard for ras2_pc_list_lock in ras2_get_pcc_subspace().
        
2. Rebased to linux.git v6.16-rc2 [2].

v7 -> v8:
1. Rebased to linux.git v6.16-rc1 [2].

v6 -> v7:
1. Fix for the issue reported by Daniel,
   In ras2_check_pcc_chan(), add read, clear and check RAS2 set_cap_status outside
   if (status & PCC_STATUS_ERROR) check. 
   https://lore.kernel.org/all/51bcb52c-4132-4daf-8903-29b121c485a1@os.amperecomputing.com/

v5 -> v6:
1. Fix for the issue reported by Daniel, in start scrubbing with correct addr and size
   after firmware return INVALID DATA error for scrub request with invalid addr or size.
   https://lore.kernel.org/all/8cdf7885-31b3-4308-8a7c-f4e427486429@os.amperecomputing.com/
   
v4 -> v5:
1. Fix for the build warnings reported by kernel test robot.
   https://patchwork.kernel.org/project/linux-edac/patch/20250423163511.1412-3-shiju.jose@huawei.com/
2. Removed patch "ACPI: ACPI 6.5: RAS2: Rename RAS2 table structure and field names"
   from the series as the patch was merged to linux-pm.git : branch linux-next
3. Rebased to ras.git: edac-for-next branch merged with linux-pm.git : linux-next branch.
      
v3 -> v4:
1.  Changes for feedbacks from Yazen on v3.
    https://lore.kernel.org/all/20250415210504.GA854098@yaz-khff2.amd.com/

v2 -> v3:
1. Rename RAS2 table structure and field names in 
   include/acpi/actbl2.h limited to only necessary
   for RAS2 scrub feature.
2. Changes for feedbacks from Jonathan on v2.
3. Daniel reported a known behaviour: when readback 'size' attribute after
   setting in, returns 0 before starting scrubbing via 'addr' attribute.
   Changes added to fix this.
4. Daniel reported that firmware cannot update status of demand scrubbing
   via the 'Actual Address Range (OUTPUT)', thus add workaround in the
   kernel to update sysfs 'addr' attribute with the status of demand
   scrubbing.
5. Optimized logic in ras2_check_pcc_chan() function
   (patch - ACPI:RAS2: Add ACPI RAS2 driver).
6. Add PCC channel lock to struct ras2_pcc_subspace and change
   lock in ras2_mem_ctx as a pointer to pcc channel lock to make sure
   writing to PCC subspace shared memory is protected from race conditions.
   
v1 -> v2:
1.  Changes for feedbacks from Borislav.
    - Shorten ACPI RAS2 structures and variables names.
    - Shorten some of the other variables in the RAS2 drivers.
    - Fixed few CamelCases.

2.  Changes for feedbacks from Yazen.
    - Added newline after number of '}' and return statements.
    - Changed return type for "ras2_add_aux_device() to 'int'.
    - Deleted a duplication of acpi_get_table("RAS2",...) in the ras2_acpi_parse_table().
    - Add "FW_WARN" to few error logs in the ras2_acpi_parse_table().
    - Rename ras2_acpi_init() to acpi_ras2_init() and modified to call acpi_ras2_init()
      function from the acpi_init().
    - Moved scrub related variables from the struct ras2_mem_ctx from  patch
      "ACPI:RAS2: Add ACPI RAS2 driver" to "ras: mem: Add memory ACPI RAS2 driver".

Shiju Jose (2):
  ACPI:RAS2: Add driver for the ACPI RAS2 feature table
  ras: mem: Add ACPI RAS2 memory driver

 Documentation/ABI/testing/sysfs-edac-scrub |  13 +-
 Documentation/edac/scrub.rst               |  58 +++
 drivers/acpi/Kconfig                       |  12 +
 drivers/acpi/Makefile                      |   1 +
 drivers/acpi/bus.c                         |   3 +
 drivers/acpi/ras2.c                        | 398 ++++++++++++++++++++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  12 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 403 +++++++++++++++++++++
 include/acpi/ras2.h                        |  74 ++++
 include/linux/edac.h                       |   4 +
 12 files changed, 986 insertions(+), 5 deletions(-)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.43.0


