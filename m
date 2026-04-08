Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF3410F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350646B0088; Wed,  8 Apr 2026 13:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328156B0089; Wed,  8 Apr 2026 13:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264BC6B0098; Wed,  8 Apr 2026 13:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13ED76B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:29:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6658160228
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:29:45 +0000 (UTC)
X-FDA: 84636075930.05.D7A63F2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A24C4000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:29:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669384; a=rsa-sha256;
	cv=none;
	b=tkYkyAMZJ772Moo22TW08wlZ4kvXSG4p45t+fS61iaRg1V3m6xyXtRG+xRjLBtm6wsigPY
	cYqXiiqF9Gv23cYw1WZdx5uYvGY2iqAeVlQMZQuxB7RtyheRDi86eHw+pRNWDqBn5LKdfL
	oBwckoaUDooX4wWsTkG+TF1D7ADAmRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=wJLbgIgaYOoZzqIMXNhGoA1t1rejk9QdtZsrd3MTRb0=;
	b=QI9YHreuH7C/Kig5hbhRAXN5jvj5FTmBCdwi9zNSNU8OdCj7qT9dv3nP6F0qnGTir3ZICg
	c/uHmNr7otu39pglg5eSf+unmvtst4dL8EB/O8rxdZhgMvCgmYPvuphU0Xdnru4cnuLHbh
	8fMTK1d2Sz0v6tYQgWKcC708Mty3hpE=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4frVRQ51nDzJ46cW;
	Thu,  9 Apr 2026 01:29:06 +0800 (CST)
Received: from dubpeml500008.china.huawei.com (unknown [7.214.146.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D51D40575;
	Thu,  9 Apr 2026 01:29:38 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.126.175.151) by
 dubpeml500008.china.huawei.com (7.214.146.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Apr 2026 18:29:36 +0100
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
	<shiju.jose@huawei.com>, <shijujose2008@gmail.com>
Subject: [PATCH v19 0/2] ACPI: Add support for ACPI RAS2 feature table
Date: Wed, 8 Apr 2026 18:28:47 +0100
Message-ID: <20260408172850.183-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.175.151]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500008.china.huawei.com (7.214.146.94)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A24C4000A
X-Stat-Signature: 1bm5o1zy346gmgieqi68wakatsu9hc86
X-Rspam-User: 
X-HE-Tag: 1775669382-593859
X-HE-Meta: U2FsdGVkX1+kFlWwtF7QmWXg+KPsdo41zsBmkvehpHM4MgzuvZeitmtDG7RqlC0Xv7L65b0c8KH7h9ZSfOivXLifWF2kThY32FQlHSmhJqdlSlMevHJjRWD/uqMynKttl+cUQ5Fq04ZY+y+bRZIVzSG6Lh7CI3iwVPoAyoySNkwJl2iyCFT/Aq5w9yt2Q/otTK5qqfMW/uvdhrAHeEgVU11uFXo1vr8dRPCNSKkhNUkM+lsBET3LVmJXl6RZhKbs2376R9V9CFWTG2JUjeCBZ6F6+bIQ/lwz0awiiypcvk19+GkmmSAP3a6NvFApq/SLWga46/AO6XAD/8fxAoVBmfKiNGQ2VwYXd5HGlWxoSkQWlg/MO2J0EpDvccqZUVmw2CDKOF6C2hFfAz26rCmHfTXm4/nI/AAQufT8zdZwBY0O5s0+g/5Ne6Iyr+OP1XeYEx8ExtDjtDTnYVQrZoySFZJ4z/dSibyET/DHRNpf7x3d+EKRQKC+PWB4KE5Xo06pGL7e4tk9jm/ukQrW5D0zTjYdoDyUAsCrwhgAZ4YFuSMJTU97sP4vUB42tidoEQc4JFDzVNaYMIYpW25KbYMq7aj4Q03BsFG5B7VRSXyoLnIW/HjVkckX/MhxhGbsfud/5E3zkBBc6AxLsEqyyEVwtvRJpy99JPtporQS7kP0cObO2BYr26Rj6bno3NZ9idGmMk1aK6+8i/jlVnqMNRMy0qT3FFowZZtzgz1kRP8sIzMfdrhqLdu39ufGgCRnDuJ4eXx3e8G/ezleSY+z9CK6LMMdZEgEb7KBb9g1guRk/b6Pj2R9Q79OCipIRnuAqnRuiLCFJ15vC4260Mj0K+iyn353V8uhUSeRva+ZjguQrIEa0iI942f9E8d1NNNQD8F3Uz//fvVaHJOG8cN/ZYTHabjK2GoXFxYniEkRlSXwHyTrwqtQRZI5JOplkaUpGyId8l/RDX7188NZFTYfHaT
 hujiGYHR
 1dNOJWZTiK7VeIpl1MItEn9YaRg32sMoZTUnZi1QxUjeJaz+WG0Xb537fkm4UfhZaTZJf0uNQBvAe1lxoJNKDG6xJ3uLwWT9DaXgXGHzfDR7YdlELCTRJGfHYTvv7npKRY7RBEw5LP0fN6TEY0X8TUi08tHHO1JvMtG7mY4Pa/kYJpG+rcuJRNuiR/n6qQiZnaOd+F9NCf/UQUfKy+rmUnC59uczujGCFA4i5QoVAJZ5EViK4aumr0Dod3mLToRdJmuwff8Y+bk6E9sGy5axCMG+mlS8FwaS5vvBCrRLfXJDf3Z9jlUaPO4oQ26iOWMZ4J6BllnLSeaBTYIGzBWbX6CyoQdug6Xs9JuMAhIpB5XWxOlSERUyz2/XBOlNBHhdlJtaOqY+xyufLYyp4sQv/Ra+rE1+flHHGUXdgOJycmCjrR+0UVvjg11SyirYJmb0KDCtxdOWT5Jl22P+Zqpcbn5h4n4c7+WLSBOL/NoYtrogYnwwU3p4a+Li5P47sNBImT6ooJLsmCJRQiFCmshli151VKA==
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

The code is based on linux.git v7.0-rc7 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v18 -> v19:
1. Fixed gemini tool reported issues sent by Borislav. Thanks.
https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com
 - Replace with iowriteX() and ioreadX() for reading fields in RAS2 shared memory
   tables throughout patches considering big-endian architectures. 
 - In ras2_send_pcc_cmd(), add extra check for non-zero last_mpar_reset,
   changed time_delta to s64, add lockdep_assert_held().
 - In register_pcc_channel(), handled case of pcc_chan->latency is 0
   and fixed timeout of 0 to readw_relaxed_poll_timeout().
 - Fixed double free case When auxiliary_device_add() fails, the driver calls
   auxiliary_device_uninit(&ras2_ctx->adev).
 - In parse_ras2_table(), add check to verify table length is large enough to contain the
   num_pcc_descs elements it iterates over.
 - Add some missing cases to acquire pcc_lock, such as ras2_hw_scrub_read_addr()
   and ras2_hw_scrub_read_size(). 
 - Removed clearing base and size in ras2_scrub_monitor_thread() when demand scrubbing
   has finished, to avoid clearing the user set values, though chances are very little.
 - Add new field set_scrub_cycle to ras2_ctx to avoid user set value is being cleared when
   ras2_update_patrol_scrub_params_cache() is being called. 
 - In ras2_hw_scrub_set_enabled_od(), redesigned to avoid prematurely restart the background scrub
   due to race condition in ras2_scrub_monitor_thread(). 
 - rename ras2_probe() to ras2_mem_drv_probe()
 - add ras2_mem_drv_remove() and call kthread_stop() to stop the ras2_scrub_monitor_thread().
   However unregistering the EDAC device which registered in the ras2_mem_drv_probe() will
   automatically happen in the EDAC via the devm_add_action_or_reset() in edac_dev_register(),
   edac_dev_unreg() and edac_dev_release().
   
v17 -> v18:
1. Fixed few AI tool reported issues shared by Borislav. Thanks.
https://lore.kernel.org/all/20260312165247.GSabLvX5DjzhDtmyuh@fat_crate.local/
2. Re-add support for user setting scrub address range for Daniel's 
   reply in v16, which was removed in v13 because of request to simplify the code and
   with the expectation that the firmware will do the full node demand scrubbing and
    may enable these attributes later in the follow-up patches.
   https://lore.kernel.org/all/df5fe0ed-3483-4ac5-8096-447e4e560816@os.amperecomputing.com/

v16 -> v17:
1. Merged all changes suggested by Borislav.
https://lore.kernel.org/all/20260126171552.GJaXehSJp33nFnpvVd@fat_crate.local/
2. Changes for Borislav's feedback "Add remove_aux_device() which unwinds everything
   add_aux_device() does for all those devices".

v15 -> v16:
Attempt to modify throughout the code and logs for the below comments from Borislav.
Thanks for the comments.
https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/
https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
https://lore.kernel.org/all/20260119111701.GBaW4Sres045xnfkpz@fat_crate.local/

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
 Documentation/edac/scrub.rst               |  70 +++
 drivers/acpi/Kconfig                       |  11 +
 drivers/acpi/Makefile                      |   1 +
 drivers/acpi/bus.c                         |   3 +
 drivers/acpi/ras2.c                        | 441 +++++++++++++++++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 540 +++++++++++++++++++++
 include/acpi/ras2.h                        |  84 ++++
 include/linux/edac.h                       |   4 +
 12 files changed, 1188 insertions(+), 5 deletions(-)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.43.0


