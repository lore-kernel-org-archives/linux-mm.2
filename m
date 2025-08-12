Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BDEC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4D28E0147; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC6A8E00B0; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609C38E0147; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F80F8E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01A62824A8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:31:17 +0000 (UTC)
X-FDA: 83768343036.27.D599C15
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8836540008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:31:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755009076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=gqxde3mMjbzUl272KdJvaagdUmEvrpKVU2h3D7C0isw=;
	b=Qc0ZmjI3rPjTjApNdiYq59pns9BaLfHfwkoe96LYVtY66m/NqrBreBk35p7MYFDW6WwrYM
	nn52URLKbjFN7TxbskwoJRGymTtiDeOcTiPgjfACQKmxHB/tD8fd2kPfrMTxrRDWSU+7ti
	vccZ1rULHDJ2rF612BQbQWt/JL/ZPB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755009076; a=rsa-sha256;
	cv=none;
	b=sQjQuik8mO6QbJhKqi2rI4MzzF33buTwvR5YjQzUtmp51SaKPo6pgckFs3xAuW58UMUyg8
	aODJWTtvFdLOMqFtpcefXzO3Ab16JC1zlNhnuLsebK6ev7U5pOBujZCta1Q5f2obFF1GwH
	rHmBPpqpdrN1X6Jhsha8hdjhIZbC7Qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c1Yhr5R4zz6L55k;
	Tue, 12 Aug 2025 22:26:20 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id A37EA1402FF;
	Tue, 12 Aug 2025 22:31:10 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.48.144.134) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Aug 2025 16:31:08 +0200
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
Subject: [PATCH v11 0/3] ACPI: Add support for ACPI RAS2 feature table
Date: Tue, 12 Aug 2025 15:26:12 +0100
Message-ID: <20250812142616.2330-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.48.144.134]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 frapeml500007.china.huawei.com (7.182.85.172)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8836540008
X-Stat-Signature: u7ex3pmkskqgsrfsxo4muj8qwcksurig
X-HE-Tag: 1755009075-913563
X-HE-Meta: U2FsdGVkX19RuNm3cOrU6pIsXwIqSzYVG6/ntXGGs+o0TIy4raS4ZOcYiaaRSwidve9WaOGca13YoNyMAtBMQo4UTnfAOP9lcDm524JyDX4wEiLgq5IQye34JhiUGvOmIkvU0rPzxM1DqKCQNGGcZy7V99u83JH3aOU5idx1VOukngEUvHjVl130JHAoYhJ9vTMxyDcyXWYfs9Ip1/lrQbUsucrR9p5/Sviti16ANBtvH0h29teSl5diFuxmoDq0z80byTIEvGl1mqO0nG6HBN2OGNfTDvKZDXk5kIVspXoXnQnKL8abrFXcgSS2IZ5SB5iFjwLje3k1P6E2BeDx05etvwZ41+QEMW7BruFPmtz6ww1iBrzsQp3sR0dvD3iAwsZTtiTXljS87tty2UaXwwlx4ORHqsuoOT9oFtiIKhFrTAih6pAc/Z58OHlJ3vcB/aTZTP3ymat0P1lctrwqLWXWgSYTVo7EcfQaBnp3kgJ2X+foGEXBDZkbflokvw2riZ1f8eABOBZjIMc36WFkb4uCR7Y+Lti2y/y+WnMRlf5jYDxD2ZDiBmpgb3Q8FRKYFG8Trcaw0eZXtLm3E9meCpfICceYHyFRzLL+fsDL53yH46CZtnoNPi/Y7lWsjZ1h9HGMOSEPtU6/DEXYyqr6pxu0GY0loKlAde4p235wRkrXFxd4Iih1VV/puU5cFyWSmE5YTwvdojRs3NWdtb24g9pDVb98x3Co5om4OlWcdFMPJJKWM79v/x+0G48PfG9UQrzFMzOhiFfqaPQeXPPudc4AMHFq7Cyp3aOTCy1ISHQ98hVWv35qvabHassFMdG58OzEMSr+DMUFZ7nl91lbFLA4Bas/M39xz3z2C0iZaNrY6tsNhCXVDlIk9VJlMnpWtKQwBJBFz1W1yaG39ebUwRi4RiNImHzG8NCfOPHpHAU8GdxmUx607rYb03c8LRcMCij7Ok1G3xwWpyri2Fp
 fEP5rmrE
 aIxUr6D/Hn+SS9ubSmNg8mEO8tUNQ1DCM2JZp5tPRcK2wpC+sh02fWPnusaYb/RarLRa368RY3BFXlUW1jQVBs1oEabmMVHQFweVHM7hFXq627mp6Vm9xrRndzrFlZ9tEneLo9jRUqPg3Lm17Zdk5FebyK2bKdPPcxukeJRUUzsPeIqVqtSWMu91CGEHCPZl9PMHSm9pIr7VOC8d3alFxKEGMC0ol3SC0hjFzFim8V3/nwJRyIHhSS5jdIIW8WAFppagZM75GebURUqmiUpfeUGNvng8L9rwIhnu9OJC+6PldjXj8qIfTYAXwBcHRMRpQQvaUOF7wWjVPXHVfdsoTak5uhKPJBSBJEO/HhV46BetuiUnuWLeMb0QouXUnJahdxhnp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

1. In numa_memblks, add support to retrieve physical address range of
   memory in a NUMA domain, which is required for the ACPI RAS2 memory
   features.
   
2. Add support for ACPI RAS2 feature table (RAS2) defined in the
   ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
   scrubbing feature.

ACPI RAS2 patches were part of the EDAC series [1].

The code is based on linux.git v6.17-rc1 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v10 -> v11:
1. Simplified code by removing workarounds previously added to support
   non-compliant case of single PCC channel shared across all proximity
   domains (which is no longer required). 
   https://lore.kernel.org/all/f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com/

2. Fix for the comments from Borislav (Thanks).
   https://lore.kernel.org/all/20250811152805.GQaJoMBecC4DSDtTAu@fat_crate.local/

3. Rebase to v6.17-rc1.

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

Shiju Jose (3):
  mm: Add support to retrieve physical address range of memory from the
    node ID
  ACPI:RAS2: Add ACPI RAS2 driver
  ras: mem: Add memory ACPI RAS2 driver

 Documentation/edac/scrub.rst |  73 ++++++
 drivers/acpi/Kconfig         |  12 +
 drivers/acpi/Makefile        |   1 +
 drivers/acpi/bus.c           |   3 +
 drivers/acpi/ras2.c          | 385 +++++++++++++++++++++++++++++++
 drivers/ras/Kconfig          |  11 +
 drivers/ras/Makefile         |   1 +
 drivers/ras/acpi_ras2.c      | 424 +++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h          |  77 +++++++
 include/linux/numa.h         |   9 +
 include/linux/numa_memblks.h |   2 +
 mm/numa.c                    |  10 +
 mm/numa_memblks.c            |  37 +++
 13 files changed, 1045 insertions(+)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.43.0


