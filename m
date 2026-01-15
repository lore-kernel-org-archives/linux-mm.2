Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DF8D44C54
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDD76B008C; Thu, 15 Jan 2026 09:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A696C6B0095; Thu, 15 Jan 2026 09:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895A06B0092; Thu, 15 Jan 2026 09:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67AD66B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:31:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE442140380
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:31:25 +0000 (UTC)
X-FDA: 84334436130.23.14E615B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEEC41C0010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:31:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768487484; a=rsa-sha256;
	cv=none;
	b=bQaiz9KWg29aHRz3euCRWuZPpWSylUMa049TNhjkum6Szi6HSKawM5Vrj1f4t9VPpzYAs8
	BLIr0UsPoAQHDycI6eF8dvdxZgTllaui6qTasTZUIWKlG10wGG0i2jgrPv0jf7jc/n7aLu
	FKT4+ME3BMBwI+MjN2OrAatzWu3x8Zg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768487484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=6c70Wk6ik33KtFf1N0llO8AslxPsEu3mhVBDddKDdzA=;
	b=SN8RF+igZvu3OSkqIBW/kEP7OnlxQaIAWUKx1pz3CnvO9EdhhqkY+0WFLUUsw9sGAhXJZE
	peallqsUp5pzYRJedC0zLN7ylMigbqEJFzbEbTpa7+Igyou47lp9DShAUwuSNOXI+ObTwN
	FgiSxIoEPOfuAQCQPjituwC1fElJq1k=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsQQD6CLVzJ46ZJ;
	Thu, 15 Jan 2026 22:31:00 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (unknown [7.214.145.227])
	by mail.maildlp.com (Postfix) with ESMTPS id 43B1540539;
	Thu, 15 Jan 2026 22:31:17 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.195.246.32) by
 dubpeml100008.china.huawei.com (7.214.145.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 15 Jan 2026 14:31:15 +0000
From: <shiju.jose@huawei.com>
To: <bp@alien8.de>, <rafael@kernel.org>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>, <rdunlap@infradead.org>
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
Subject: [PATCH v15 0/2] ACPI: Add support for ACPI RAS2 feature table
Date: Thu, 15 Jan 2026 14:30:57 +0000
Message-ID: <20260115143101.876-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.195.246.32]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100008.china.huawei.com (7.214.145.227)
X-Stat-Signature: 6s8n53rjg4b9y4epr9uqd4r7e1gb1mu3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BEEC41C0010
X-Rspam-User: 
X-HE-Tag: 1768487482-798069
X-HE-Meta: U2FsdGVkX192w1/tl5MtiiAA+b5kYbv4P/i9tFvMGSGjiqBnu/gSNnJenHLk6M5ek/S7UvZwLd36Z8r54d7VKnhAKLxiYLW7i/8e/StnN8JIeWSP0/aO4na7S9kh2keYOx1VV48SoB5SBAx2BZDK1RXEwZN9yoO+PRI8tRW8WMyIYGKdGEVJkTseSGzWe2/1/ae/Mbg8iDauP9ABQjM5ipvWZouQ0h3S35RuszDQpEhAa+0KiVaz1h+HVZrbAMELz0CnlEihUROpVo8wkk9os+ylje3gxiHWA3xtXPuKQGvmOYQRj+7Ri0Mp3hHYbs/2MdZnkor8TRhp17xHPUk7U+TK0IQ4W2LLYwBfIeC2ybX0mM1OFihhXyg+pLet3OngaXRSWCaJSfGX6xac2gLec3r5zrO5h4y2YmlRN7IrWu3qHBN7eT//I9ssOqi/ZemS9U9EBT849tP+WkdJKI4JcIjN6VXF+WAapriErHUulK+mstBVv94JSIDUW0EdFmwCRq92D2v7zck95fLnLyRYQR1EAS0bIVjtiYBN5Q8VvrejKLY6dc/yP/IRuVLSNFRaTQwrp4swPlRrXG/s3FR1VCrgN7aZonsPTJlAG0/Ppze9/EwxVZ5a63wSBPSVXQ2lGzoFOgE7N9YktYf5O1W9gxeWjagK4X3BkpALrUEhbHBWXm1XpBdLHn/PzScaCuWKxFzASHGEZ0T6r+yToY/TIeNjwDRQHYewg6CY4C75czZx/8LVu7ktGKqdiMpdF5LZ1BRwOIGFT8fby+izraRo3rUpaQLMA97yyJO9uYcWUkekvbHxR0T3IpEZNmvO1SEocT+tYvUehSyNfViE4ezpjTVhTTQIetPZOjsQkMBYKA7LohHVzL8HaB7PUAruvc4fx1v5/kKsyE+NlfhGSnhDb50+I8iIgeWeAu5gpWJpQgIaUOtBmrJ5vPUlnmy0G8hmjt8GccYLq+TBBP4F/yM
 i3IeFfnk
 /qVraDq/hDAPDz4Vx6dnF82b4gAeVb5qIvnjpnOQyWReIenjrI5PuwxhHOeNHHTAur8+rlIpTBguXbCKPZvXtXa5Iobb7tSm781op1kpVRdHOBustUk2Fh/Az/E+H6ZumskEUkZV0uS73n9eccCZlVE/xhELJImW0lfbiRcbGZ0y30JbzmrIekpUMhjphqzYZQk9IfrXWvVhd1u1ICffpwZUgCiqdvvtrqjz8RYFP6aQFqJB9hAETWcfue99HOYIGzS8OGm7aTryphQgfq3+X6z3dxHHtPkQCOftcuY02Vki3h0WGqyFvItJ+cwr1Mvk9Hcg/RksC/UyGGWEjYJoQsSWLAB3aOiUBHOY6ajK9BzlTCneAx6yRcHNUcz2LNklRR6qgNZ5ywE2ZMidbuLKeHhmkuV1/avkVB7RNO7Uls3R9Ffqb2ypeVyW0GLPEJ/h9moid
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

The code is based on linux.git v6.19-rc5 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v14 -> v15:
1. Incorporated new changes suggested by Borislav on v13.
   https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
   
2. Rebase to v6.19-rc5.

v13 -> v14:
1. Modifications for changes wanted by Borislav.
   https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/

2. Changes for the comments from Randy Dunlap 
   https://lore.kernel.org/all/4807417b-a8f7-47a3-b38a-94ea7bdbf775@infradead.org/
   https://lore.kernel.org/all/af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org/
   https://lore.kernel.org/all/26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org/
   
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
 Documentation/edac/scrub.rst               |  60 +++
 drivers/acpi/Kconfig                       |  10 +
 drivers/acpi/Makefile                      |   1 +
 drivers/acpi/bus.c                         |   3 +
 drivers/acpi/ras2.c                        | 414 +++++++++++++++++++++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 395 ++++++++++++++++++++
 include/acpi/ras2.h                        |  74 ++++
 include/linux/edac.h                       |   4 +
 12 files changed, 995 insertions(+), 5 deletions(-)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.43.0


