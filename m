Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD08CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4018E0008; Tue,  2 Sep 2025 13:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BF68E0001; Tue,  2 Sep 2025 13:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9558E0008; Tue,  2 Sep 2025 13:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09D368E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:31:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CBC6576ED
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:31:00 +0000 (UTC)
X-FDA: 83845000680.10.92E82BE
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id F340A18001A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:30:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=xuhor4mLYRzI8zW/Zrz5fq+y2rUxc5JCH9lcwdLr2Z8=;
	b=bJznsj4p7fvCfein33KO5KC5EuuuoTVKHVANlAcphuuxYBgB2Hrqr/K7l0zzapLn+z6BCX
	U6KWv2NeK6cPjkmSffddiL4o0e/nMFeucvuLQH9Ut0vPR36cGc0NMycK/Yo0xiMPcMYf+N
	mKAZyu2YU3aDKBIjHr/mjEW3H9IQf4c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834258; a=rsa-sha256;
	cv=none;
	b=26CFg6MBVbXUVec00fIi9jILQdk3TPBJPQCi9s1+0lwV+/h5oAnH/A6uM85xSxhj+sjI8W
	r7ICTQKHYMH368ZLooPptJcZEGWbQDUJCj0Bf5DjC++MCSfl1wEjEAdCKB3BBMqo1aV1io
	VzmTXn/2GE1HCZ5MDIDZ/JxPGl3Ngfg=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cGXlG2zsDz6M4hF;
	Wed,  3 Sep 2025 01:28:26 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 7568B1400C8;
	Wed,  3 Sep 2025 01:30:53 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.48.150.145) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 2 Sep 2025 19:30:51 +0200
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
Subject: [PATCH v12 0/2] ACPI: Add support for ACPI RAS2 feature table
Date: Tue, 2 Sep 2025 18:30:38 +0100
Message-ID: <20250902173043.1796-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.48.150.145]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500007.china.huawei.com (7.182.85.172)
X-Stat-Signature: 38x3watuokiw9eu7riuj5bumhh4yciqm
X-Rspam-User: 
X-Rspamd-Queue-Id: F340A18001A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756834257-605759
X-HE-Meta: U2FsdGVkX1+0s1CWEreSClsOrLeb2lglil3C+fsWmoWiIRVrkJkaxkVf4ZHtky7N7IOgmRwyngi6flhhzRwy3Sgp0P+327LLq8GH323GLAiW8exX60GyWp5B98nTDHmauPpQY38CuJ/38vvLSzzcZ++rc4rx8K4Mzcz6fjlXogWBrj3HEGMtbjHI41pJaJUJQdL/XZbEnaQOmlhxl9v9kRVv7VHFtjps+YPSZC/weflJs74SSSGbpKPR8ti6FmUwwWAQPm/ynhGzDlz8mfLskfsu63MbqagWa07uGJuiYf/pSlQ+dDYO0yT7N8RPDeenOvsHNxsrkFFKg6Qi56i0St5PPrBeitFJKa9csBqKOdcNUIa8dbHunF11QQN8MNUism1n5qpAwTgzR+FkJoMBb25qCTZUixfsP2W0XDIdX9bkSgnrFObsKh7UaEY1OzfMyZ/Bt3pYFe7mT0QBLbX2meJ4mbJ/TQrMNlNf1yh/9UKmcKN3kYA3Z9DC7b5HE49qVUH/NljzAVbEcrYbIaeo3mjMR5UHVHq+QXz113urM9NFBvPfFJ0dFur106LOiEEa1S+3eF+aQeNHul3DYFQ7JFk1XOWkUV5FGKTJxzdtevO53wwSyhE4yqA2OA2smXtetHjqXw0NeqBebCjqs4axMM7l3dcA4C3vVkTfte1VPJA/fYCv1ET6dA7qQBep5fprah73qYlnmaAqVgiWXT3sUdlQ3j/eyrrwE4dZ9oobVITlXUZyiKhhtVL0hezkqOHncRuhGKVYtlf0n8cjWZVbnKErwUjz1W8k8br4Q6KZo5Q9E0RwVrF8y5DHEjHX/AbUM0iixZUiYxjTbamiz4MiDSGvnfHcM+Fcd/f1IzuTLX3I3WUCHZZ6HAzbtx7QmHAM8TlgamX7Xx0Mnl0UjrDGGy1zjvIu2LsF2ffWdSHbmxav5kMnaSiRIRvETYmz+VOQ9ITsmUdbPfrZVIm4E09
 655mMpQt
 xkcCqQ3MTygVKBtci6fi6PfYACH29vv0IWyM7dSyEebZ9R9kpFxf+BlFxfGrQoMb7d67PC5ABkOdtAohmVW5n43ll36a/5jZHVHt9dqa2xX8Bqdg0QXfZpTNum0c6kZRJjWO9hBmWlDmD2j+f93qTeXGosbhFrO5Sdj7CmQIGiaJfzIebKHdVDobriGGKLkC3d0tJASAc2s3GCqk/3SOoiNqb8whCkb29rzVSXmiBb6KmsurjD9pFQGTZ/BlmF/MSj8PyhLyunG3SjUa3dKeoBXB5c7U8u3ZoQ+e4k/KMtxsBqhKqEUyn0y+sljZJMIWNACRtTPEPL+J/Ot7SpuBzIbVKKsBKYN7iQ1WI3kEemqgWs9FlDUlpPJ6+t/biQM48BsUX
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

The code is based on linux.git v6.17-rc4 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
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
  ACPI:RAS2: Add ACPI RAS2 driver
  ras: mem: Add memory ACPI RAS2 driver

 Documentation/edac/scrub.rst |  73 ++++++
 drivers/acpi/Kconfig         |  12 +
 drivers/acpi/Makefile        |   1 +
 drivers/acpi/bus.c           |   3 +
 drivers/acpi/ras2.c          | 389 ++++++++++++++++++++++++++++++++
 drivers/ras/Kconfig          |  11 +
 drivers/ras/Makefile         |   1 +
 drivers/ras/acpi_ras2.c      | 424 +++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h          |  77 +++++++
 9 files changed, 991 insertions(+)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.43.0


