Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AD3C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91CD6B0093; Thu,  9 Jul 2026 17:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EEB6B0092; Thu,  9 Jul 2026 17:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1676B0093; Thu,  9 Jul 2026 17:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF6F6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:08:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 001EA167B1E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:11 +0000 (UTC)
X-FDA: 84970475982.09.607D3F7
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 276F340002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MeVsf889;
	spf=pass (imf27.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783631290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8b04dE1EtPeiG0VuXgGkBjWPKNnL5ixx0lYXp4fIqss=;
	b=01QGNvFlU7SFO2mpcCSNMdh95jv4ygJ6en8czBUPqPr1XT5NLz6oWMcN9XGCREbcI1KtKz
	y48HGoVHEPrhBsFWUNaq7Lp1NjnSBSI4oCZEr3ZGKXYY0Tu+UxKyVOPYkPREZ4rmBBA9sz
	/1YULpzYEmvzdsXU9KqyTmRjyz+GCow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MeVsf889;
	spf=pass (imf27.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783631290;
	b=HDB9Kt/RfhMcbu3HAEACEtYnMEtokzx4BOEuiVSIR7iely3VxyouurGYEr8WzzSkZHPuti
	elV7UEOe26XLQHxlBg88skjpvuUxzgd3rffjTeZ5EUwCCd2GFcnq+OloHMcJ5/ZHMEd+vT
	HsYA+PbQceMuVs8qN6eVCPdVrHcDsw0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493b7612475so1925235e9.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 14:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783631289; x=1784236089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8b04dE1EtPeiG0VuXgGkBjWPKNnL5ixx0lYXp4fIqss=;
        b=MeVsf889/gFoEi7vLnbnjQf48MuFmRHTisDfJ8vND66Rx4E+IXYxGNbIFXMGq3Rqbo
         ebU20NTo2UuQSizlH3JVRJZJOfarckV0bShXdJh4fbrDw8lX71xfMOaGnCJEVba6SLd4
         4QVachbtiw8RBjppv/mF7NJwpK15AtP08XRKJioD+Uu3+FrZpQEiE+XemPXL5Ug5VnTr
         auktdSNZiTVQmxVbBxMtATmK5Qb5fTXTdSXHxnYdoEmfevI4FBqvjE0T3vh558UfBa0W
         OHQmeLE6wODoi/0fMCUXSNKpQDe9w15MagoqetNC7N3Hy8Ha0rVqK3S07l9cVHYA9J3i
         aOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783631289; x=1784236089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8b04dE1EtPeiG0VuXgGkBjWPKNnL5ixx0lYXp4fIqss=;
        b=gfFjcXgnSWtLQL75voT2gWEGSPPXk9ElmTBEtig9IRd3QNtHnZ7pEAIdQlULzuawnP
         ZUH8bcSihjUnVv5G3MZrkrOBOrQCNEHQUiSSF1GUtbx0K1MuJ7sehqRv6Quq4h28P3gz
         xXIN/sp36CdYxZYI3c/T0OBpNZEK+2Rl3Er1M1BXV8Ul8HR20PbkHZfonQvQjlB2LbjM
         FeiQqe4swT124Y+SHNTqmUNOmjhquc4LvazpWjxctKwn802ZlmWgEnmz5W41DhyaqlGT
         yz//m1PqsPk38m2baYcel1aDyxUWKeO4SYwfKklmQEcEDaPqF+EX9YJGAnFwFqJ3/FzN
         w/PA==
X-Forwarded-Encrypted: i=1; AHgh+Rox7OMl4PYZb+u0jINXRVaxEq5vMMiUe63pqEE7mpTAhO8fDT1gTsZ3IpS0uBKnqABQG3wbahPssA==@kvack.org
X-Gm-Message-State: AOJu0Yzlewx34+JUCsSKxRu06lGvKbne0BerNK44GfdySiKE9rZyupCr
	rvS2ooIsPqh1qsdW7ziV+MxUGLgNoeMKe2F3O3q7VmpK6bkw2OykuMvY
X-Gm-Gg: AfdE7cm9m6P56FH2FLlhtlVOd+qMbsLNuB1GGTa9Wh8HtLk7yYylYNqSqUT/yQRXqA5
	9GyF0QWBdmPl4xmybohA8gnNlczu3boTSTHXgb/rTAcN2LvP5aDvvf6IqE7NeTl/pU14JEw9OXn
	G2oYIC8GW/6dMX6cSlWGb/ResD3jY05P4P0OsY1WqKHs5/DEy5zTxdOLJtMLskn1t7JJOQdNsAS
	fdCZ/QonOxXCKNO1NES8/vqnRTmHhqB3r+dZnMzIoMWZc/Jp3GFngbv9Nb/LRVqCYKsHyOnwN3k
	L9jdB8TiATRhh9yCveoSWuJUY17qYGWEPsxvTxPJ83CJSaAXZh02ZZRnmWysYDYqD81hxo7mT3u
	Uu/6P6NCO8/GcZlHNraZbFSetmdyePgTYP1LJtgxcoq7r6/tFQYjT0MBbrqFIY6Af8U7fCE2iQ+
	FSvIR+CznLLfrHp7HYuHaB0ypVmnQmQqNrNSia0GSnhSHS3ApZ4lN7ZEeN8e661INvu/NfQoyl2
	pnlEunnCvbpnIu4C5U2gGiiafKyOG/h
X-Received: by 2002:a05:600c:4455:b0:493:bb0e:2832 with SMTP id 5b1f17b1804b1-493e687fb61mr85568575e9.37.1783631288488;
        Thu, 09 Jul 2026 14:08:08 -0700 (PDT)
Received: from localhost.localdomain (stev-08-b2-v4wan-169520-cust2225.vm32.cable.virginm.net. [81.98.232.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm55607342f8f.15.2026.07.09.14.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:08:07 -0700 (PDT)
From: shijujose2008@gmail.com
To: rafael@kernel.org,
	bp@alien8.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	tony.luck@intel.com,
	lenb@kernel.org,
	Yazen.Ghannam@amd.com,
	mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com
Cc: jic23@kernel.org,
	linuxarm@huawei.com,
	rientjes@google.com,
	jiaqiyan@google.com,
	Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com,
	james.morse@arm.com,
	jthoughton@google.com,
	somasundaram.a@hpe.com,
	erdemaktas@google.com,
	pgonda@google.com,
	duenwen@google.com,
	gthelen@google.com,
	wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com,
	tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com,
	shijujose2008@gmail.com
Subject: [PATCH v22 2/2] ras: mem: Add ACPI RAS2 memory driver
Date: Thu,  9 Jul 2026 22:07:50 +0100
Message-Id: <20260709210750.424659-3-shijujose2008@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260709210750.424659-1-shijujose2008@gmail.com>
References: <20260709210750.424659-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 276F340002
X-Stat-Signature: pkhz7r7q1gejkfgpzuyxptxdioes3d9i
X-HE-Tag: 1783631290-409775
X-HE-Meta: U2FsdGVkX18uRPic+CWJgGaxA5Fkh3OERMmutLkmUlT3dlJhPoJUm8CVwR1b73xXZscXd97054Z+buG4cICJxZ/OSeK9PJO4v5EsO6BoiAQ5jaGUN7rUwm91zFLPtsm/NOUN/G8KkJAwjBCUc47NaB1d31ZAAGe2GGKaOUwgx/D6Kk8bgqtff5X/K46uKA++H/zNhdvvZeetaWgMjAwdFIloa2qL4jbJJqUZPtjODtv5IagNJ9/KqPZuOZpH4ZtkI2Z9FEclYdp6IpWugnIuuaMxvym4EN/ddwN6chRm3gR/xMGy6YGKjo4hqgQynR9HSH5TwA/AARJF0D3ohMWfDf47BKcUPg1j0oDtIu7MfAov6wBYk95ZlRVEkYfTAnmNh/BI0B0xGrf3UnmauygRq/ZHXlvRk8tatZLkbHJ7gypnR7bKBSGdVd9jiWM+SS0xIHA6bcxa5lsmnZ/s0PfFlioTyRC7gEV+tkLE8FTqD7n8hhB/bsQ99n+sR9hh6gk4zJ2sJsyV37wLzUSB9x1qOMefGf/nC4pKiq436sHbLf5SX1KiLHJkp87aWuhN3qQ4jXDLfM32Fr542u+u7AfhrnPZYJOlElyal4hrQswcSA4hGXW8mZ2RgptjXQPTSNnUCSDJhNC0sFvU5gnfCAGXT5YbkHPRCZenUdDwehC0rKj8xiIWLDq9KGdbFowAQ6H6DMpDUvXGYmKtCHYXrX0j4gg6YhxUGTtNWeOFHfwgcZSXzPSC+MLMDmxkB70sDuz8vTPTbQUBroTBpIesevCLHXXwY7DFlwHvpM/pGx8KJozRyGRP3gikbPm1S/R1C4hfKIK4uDmWa1JxYqui09ngaIV7IYhF7+C5Pv1c+SC94A04qg3BW5LtGIce7xdiWcsS+D4o7fZKoAjPFj72Cnbs79Uuhf4HmPUWXGhLuvg7VYx6VzFpAqYFjdpVTi4BXnEwJwieSpQ+Csj2tL8duM5
 A9RBirUQ
 6x/Pj0tpCUPce1BJlJKQ+q7ct/1F3qYX6xW97GGzDzFU/1+BID6mWDIFYRTS7+B0+zPy2mN/1ZinZgRKPMFpwrVsTaQnlVGQDRm6oYe6vs3b+U+QJpOmyvwpWRff1CckPVpe+PSs4UXJYxCYVMHDBTRo9PImJzNbrxKwJbaga/y227o/I4sOgTWtmQSoSJ5RLf+jaLOQt8w1N5nTvUKFkW2UHN9pqb1jGPOzzHLildk7AASK9+dVhpQDUxodhshj9zVUUJniCtlP7T+XoE3lDRdvRajfMOl822LS4rvLraJ1iIoOwl3HD4rHiOyE03SqUL7+17PsNMsuqX30D1Kw6YJZtK/aSLzpQXM0dVKcEV6s/KVsOnsfeVFZJ6cLOsCXcGvDHjacmbOMYkLVvbo3RbIvsvrW94X9zBPWwe7n0UwYcX41kaC+GM2e87CSbnumX5Y+YKDdWiivznD8N9zey6iqn0M07ovut4WmeeydFPdG8/ecHDFaL1f6YG+ZtaIkq9G6grZDNRVPfHjlzGoqfPWl5hfzNSpo9XGFShlE2EMCW94LaTI0S0rh9+GpIBxESqVlmNW7n3XOWG/tQwC3dm0KCiIc1wjoOibxI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shijujose2008@gmail.com>

ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
Driver adds support for RAS2 feature table, which provides interfaces for
platform RAS features, e.g., for HW-based memory scrubbing, and logical to
PA translation service. RAS2 uses PCC channel subspace for communicating
with the ACPI compliant HW platform.

ACPI RAS2 auxiliary driver for the memory features binds to the auxiliary
device, which is added by the RAS2 table parser in the ACPI RAS2 driver.

Given the address range provided to the userspace may be the lowest scrub
address range in the presence of disjoint address ranges, skipping address
ranges that are from other NUMA nodes but happen to lie within this range.

Driver retrieves the PA range of the NUMA domain and use it as the
'Requested Address Range', when send RAS2 command GET_PATROL_PARAMETERS
to get parameters that apply to all addresses in the NUMA domain.

Device with ACPI RAS2 scrub feature registers with EDAC device driver,
which retrieves the scrub descriptor from EDAC scrub and exposes
the scrub control attributes for RAS2 scrub instance to userspace in
/sys/bus/edac/devices/acpi_ras_memX/scrub0/.

Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
the demand scrub, which is used in the RAS2 demand scrub control.
When a demand scrub is started, any background scrub currently in progress
will be stopped and then automatically restarted at the beginning when the
demand scrub has completed.

Co-developed-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
---
 Documentation/ABI/testing/sysfs-edac-scrub |  14 +-
 Documentation/edac/scrub.rst               |  70 +++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 603 +++++++++++++++++++++
 include/acpi/ras2.h                        |  29 +
 include/linux/edac.h                       |   4 +
 8 files changed, 741 insertions(+), 5 deletions(-)
 create mode 100644 drivers/ras/acpi_ras2.c

diff --git a/Documentation/ABI/testing/sysfs-edac-scrub b/Documentation/ABI/testing/sysfs-edac-scrub
index ab6014743da5..2b874e033623 100644
--- a/Documentation/ABI/testing/sysfs-edac-scrub
+++ b/Documentation/ABI/testing/sysfs-edac-scrub
@@ -20,11 +20,7 @@ KernelVersion:	6.15
 Contact:	linux-edac@vger.kernel.org
 Description:
 		(RW) The base address of the memory region to be scrubbed
-		for on-demand scrubbing. Setting address starts scrubbing.
-		The size must be set before that.
-
-		The readback addr value is non-zero if the requested
-		on-demand scrubbing is in progress, zero otherwise.
+		for demand scrubbing.
 
 What:		/sys/bus/edac/devices/<dev-name>/scrubX/size
 Date:		March 2025
@@ -34,6 +30,14 @@ Description:
 		(RW) The size of the memory region to be scrubbed
 		(on-demand scrubbing).
 
+What:		/sys/bus/edac/devices/<dev-name>/scrubX/enable_demand
+Date:		Jan 2026
+KernelVersion:	6.19
+Contact:	linux-edac@vger.kernel.org
+Description:
+		(RW) Start/Stop demand scrubbing. The stop operation is
+		supported only if the driver and hardware support it.
+
 What:		/sys/bus/edac/devices/<dev-name>/scrubX/enable_background
 Date:		March 2025
 KernelVersion:	6.15
diff --git a/Documentation/edac/scrub.rst b/Documentation/edac/scrub.rst
index 2cfa74fa1ffd..562bfd6ff630 100644
--- a/Documentation/edac/scrub.rst
+++ b/Documentation/edac/scrub.rst
@@ -340,3 +340,73 @@ controller or platform when unexpectedly high error rates are detected.
 
 Sysfs files for scrubbing are documented in
 `Documentation/ABI/testing/sysfs-edac-ecs`
+
+3. ACPI RAS2 Hardware-based Memory Scrubbing
+
+3.1. Demand scrubbing for a specific memory region.
+
+3.1.1. Query the status of demand scrubbing
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
+
+0
+
+3.1.2. Query what is device default/current scrub cycle setting.
+
+Applicable to both demand and background scrubbing. The unit of the
+scrub cycle is seconds.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+36000
+
+3.1.3. Query the range of device supported scrub cycle for a memory region.
+The unit of the scrub cycle range is seconds.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/min_cycle_duration
+
+3600
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/max_cycle_duration
+
+86400
+
+3.1.4. Program scrubbing for the memory region in RAS2 device to repeat every
+43200 seconds (half a day).
+
+# echo 43200 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+3.1.5. Set address range.
+
+Set 'addr' of the memory region to scrub.
+
+# echo 0x80000000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+Set 'size' of the memory region to scrub.
+
+# echo 0x200000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/size
+
+3.1.6. Start 'demand scrubbing'.
+
+When a demand scrub is started, any background scrub currently in progress
+will be stopped and then automatically restarted at the beginning when the
+demand scrub has completed.
+
+# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
+
+3.2. Background scrubbing the entire memory
+
+3.2.1. Query the status of background scrubbing.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background
+
+0
+
+3.2.2. Program background scrubbing for RAS2 device to repeat in every 21600
+seconds (quarter of a day).
+
+# echo 21600 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+3.2.3. Start 'background scrubbing'.
+
+# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background
diff --git a/drivers/edac/scrub.c b/drivers/edac/scrub.c
index f9d02af2fc3a..f3b9a2f04950 100644
--- a/drivers/edac/scrub.c
+++ b/drivers/edac/scrub.c
@@ -14,6 +14,7 @@ enum edac_scrub_attributes {
 	SCRUB_ADDRESS,
 	SCRUB_SIZE,
 	SCRUB_ENABLE_BACKGROUND,
+	SCRUB_ENABLE_DEMAND,
 	SCRUB_MIN_CYCLE_DURATION,
 	SCRUB_MAX_CYCLE_DURATION,
 	SCRUB_CUR_CYCLE_DURATION,
@@ -55,6 +56,7 @@ static ssize_t attrib##_show(struct device *ras_feat_dev,			\
 EDAC_SCRUB_ATTR_SHOW(addr, read_addr, u64, "0x%llx\n")
 EDAC_SCRUB_ATTR_SHOW(size, read_size, u64, "0x%llx\n")
 EDAC_SCRUB_ATTR_SHOW(enable_background, get_enabled_bg, bool, "%u\n")
+EDAC_SCRUB_ATTR_SHOW(enable_demand, get_enabled_od, bool, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(min_cycle_duration, get_min_cycle, u32, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(max_cycle_duration, get_max_cycle, u32, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(current_cycle_duration, get_cycle_duration, u32, "%u\n")
@@ -84,6 +86,7 @@ static ssize_t attrib##_store(struct device *ras_feat_dev,			\
 EDAC_SCRUB_ATTR_STORE(addr, write_addr, u64, kstrtou64)
 EDAC_SCRUB_ATTR_STORE(size, write_size, u64, kstrtou64)
 EDAC_SCRUB_ATTR_STORE(enable_background, set_enabled_bg, unsigned long, kstrtoul)
+EDAC_SCRUB_ATTR_STORE(enable_demand, set_enabled_od, unsigned long, kstrtoul)
 EDAC_SCRUB_ATTR_STORE(current_cycle_duration, set_cycle_duration, unsigned long, kstrtoul)
 
 static umode_t scrub_attr_visible(struct kobject *kobj, struct attribute *a, int attr_id)
@@ -119,6 +122,14 @@ static umode_t scrub_attr_visible(struct kobject *kobj, struct attribute *a, int
 				return 0444;
 		}
 		break;
+	case SCRUB_ENABLE_DEMAND:
+		if (ops->get_enabled_od) {
+			if (ops->set_enabled_od)
+				return a->mode;
+			else
+				return 0444;
+		}
+		break;
 	case SCRUB_MIN_CYCLE_DURATION:
 		if (ops->get_min_cycle)
 			return a->mode;
@@ -164,6 +175,7 @@ static int scrub_create_desc(struct device *scrub_dev,
 		[SCRUB_ADDRESS] = EDAC_SCRUB_ATTR_RW(addr, instance),
 		[SCRUB_SIZE] = EDAC_SCRUB_ATTR_RW(size, instance),
 		[SCRUB_ENABLE_BACKGROUND] = EDAC_SCRUB_ATTR_RW(enable_background, instance),
+		[SCRUB_ENABLE_DEMAND] = EDAC_SCRUB_ATTR_RW(enable_demand, instance),
 		[SCRUB_MIN_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RO(min_cycle_duration, instance),
 		[SCRUB_MAX_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RO(max_cycle_duration, instance),
 		[SCRUB_CUR_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RW(current_cycle_duration, instance)
diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
index fc4f4bb94a4c..a1e6aed8bcc8 100644
--- a/drivers/ras/Kconfig
+++ b/drivers/ras/Kconfig
@@ -46,4 +46,17 @@ config RAS_FMPM
 	  Memory will be retired during boot time and run time depending on
 	  platform-specific policies.
 
+config MEM_ACPI_RAS2
+	tristate "Memory ACPI RAS2 driver"
+	depends on ACPI_RAS2
+	depends on EDAC
+	depends on EDAC_SCRUB
+	select NUMA_KEEP_MEMINFO
+	help
+	  The driver binds to the auxiliary device added by the ACPI RAS2
+	  feature table parser. The driver uses a PCC channel subspace to
+	  communicate with the ACPI-compliant platform and provides
+	  control of the HW-based memory scrubber parameters to the user
+	  through the EDAC scrub interface.
+
 endif
diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
index 11f95d59d397..a0e6e903d6b0 100644
--- a/drivers/ras/Makefile
+++ b/drivers/ras/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_RAS)	+= ras.o
 obj-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_RAS_CEC)	+= cec.o
+obj-$(CONFIG_MEM_ACPI_RAS2)	+= acpi_ras2.o
 
 obj-$(CONFIG_RAS_FMPM)	+= amd/fmpm.o
 obj-y			+= amd/atl/
diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
new file mode 100644
index 000000000000..268b1c38ddf9
--- /dev/null
+++ b/drivers/ras/acpi_ras2.c
@@ -0,0 +1,603 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ACPI RAS2 memory driver
+ *
+ * Copyright (c) 2024-2026 HiSilicon Limited.
+ *
+ */
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"ACPI RAS2 MEMORY: " fmt
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/edac.h>
+#include <linux/kthread.h>
+#include <linux/platform_device.h>
+#include <acpi/ras2.h>
+
+#define RAS2_SUPPORT_HW_PARTOL_SCRUB BIT(0)
+#define RAS2_TYPE_PATROL_SCRUB 0x0000
+
+#define RAS2_GET_PATROL_PARAMETERS 0x01
+#define RAS2_START_PATROL_SCRUBBER 0x02
+#define RAS2_STOP_PATROL_SCRUBBER 0x03
+
+/*
+ * RAS2 patrol scrub
+ */
+#define RAS2_PS_SC_HRS_IN_MASK GENMASK(15, 8)
+#define RAS2_PS_EN_BACKGROUND BIT(0)
+#define RAS2_PS_SC_HRS_OUT_MASK GENMASK(7, 0)
+#define RAS2_PS_MIN_SC_HRS_OUT_MASK GENMASK(15, 8)
+#define RAS2_PS_MAX_SC_HRS_OUT_MASK GENMASK(23, 16)
+#define RAS2_PS_FLAG_SCRUB_RUNNING BIT(0)
+
+#define RAS2_SCRUB_NAME_LEN 128
+#define RAS2_HOUR_IN_SECS 3600
+
+struct acpi_ras2_ps_shared_mem {
+	struct acpi_ras2_shmem common;
+	struct acpi_ras2_patrol_scrub_param params;
+};
+
+#define TO_ACPI_RAS2_PS_SHMEM(_addr) \
+	container_of(_addr, struct acpi_ras2_ps_shared_mem, common)
+
+static int __ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable);
+
+static int ras2_is_patrol_scrub_support(struct ras2_mem_ctx *ras2_ctx)
+{
+	struct acpi_ras2_shmem __iomem *common = (void *)ras2_ctx->comm_addr;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	iowrite8(0, &common->set_caps[0]);
+
+	return ioread8(&common->features[0]) & RAS2_SUPPORT_HW_PARTOL_SCRUB;
+}
+
+static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ras2_ctx)
+{
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	u32 scrub_params_out;
+	int ret;
+
+	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
+		return ret;
+	}
+
+	scrub_params_out = ioread32(&ps_sm->params.scrub_params_out);
+	ras2_ctx->min_scrub_cycle = FIELD_GET(RAS2_PS_MIN_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	ras2_ctx->max_scrub_cycle = FIELD_GET(RAS2_PS_MAX_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	ras2_ctx->scrub_cycle_hrs = FIELD_GET(RAS2_PS_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	if (ras2_ctx->bg_scrub) {
+		ras2_ctx->od_scrub = false;
+		ras2_ctx->base = 0;
+		ras2_ctx->size = 0;
+		return 0;
+	}
+
+	if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
+		ras2_ctx->od_scrub = true;
+		ras2_ctx->base = ioread64(&ps_sm->params.actl_addr_range[0]);
+		ras2_ctx->size = ioread64(&ps_sm->params.actl_addr_range[1]);
+	} else {
+		ras2_ctx->od_scrub = false;
+	}
+
+	return 0;
+}
+
+/* Context - PCC lock must be held */
+static int ras2_get_demand_scrub_running(struct ras2_mem_ctx *ras2_ctx, bool *running)
+{
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	int ret;
+
+	if (!ras2_ctx->od_scrub) {
+		*running = false;
+		return 0;
+	}
+
+	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
+		return ret;
+	}
+
+	*running = ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING;
+	if (!(*running))
+		ras2_ctx->od_scrub = false;
+
+	return 0;
+}
+
+static int ras2_scrub_monitor_thread(void *p)
+{
+	struct ras2_mem_ctx *ras2_ctx = (struct ras2_mem_ctx *)p;
+	bool running;
+	int ret;
+
+	while (!kthread_should_stop()) {
+		mutex_lock(ras2_ctx->pcc_lock);
+		if (!ras2_ctx->reenable_bg_scrub)
+			goto exit;
+
+		/*
+		 * If ras2_get_demand_scrub_running() fails here, re-enabling background
+		 * scrubbing immediately may not be possible or correct. In that case,
+		 * the admin or firmware may need to re-enable background scrubbing
+		 * after demand scrubbing has finished.
+		 */
+		ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+		if (ret)
+			goto exit;
+
+		if (!running) {
+			ret = __ras2_hw_scrub_set_enabled_bg(ras2_ctx->dev, ras2_ctx, true);
+			if (ret)
+				dev_err(ras2_ctx->dev,
+					"Failed to enable background scrub ret=%d\n", ret);
+
+			goto exit;
+		}
+
+		mutex_unlock(ras2_ctx->pcc_lock);
+		msleep(1000);
+	}
+
+	mutex_lock(ras2_ctx->pcc_lock);
+exit:
+	if (ras2_ctx->driver_active)
+		ras2_ctx->thread = NULL;
+	mutex_unlock(ras2_ctx->pcc_lock);
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_min_scrub_cycle(struct device *dev, void *drv_data, u32 *min)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	*min = ras2_ctx->min_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_max_scrub_cycle(struct device *dev, void *drv_data, u32 *max)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	*max = ras2_ctx->max_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_read(struct device *dev, void *drv_data, u32 *scrub_cycle_secs)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	*scrub_cycle_secs = ras2_ctx->scrub_cycle_hrs * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_write(struct device *dev, void *drv_data, u32 scrub_cycle_secs)
+{
+	u32 scrub_cycle_hrs = scrub_cycle_secs / RAS2_HOUR_IN_SECS;
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	if (scrub_cycle_hrs < ras2_ctx->min_scrub_cycle ||
+	    scrub_cycle_hrs > ras2_ctx->max_scrub_cycle)
+		return -EINVAL;
+
+	ras2_ctx->set_scrub_cycle = scrub_cycle_hrs;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_addr(struct device *dev, void *drv_data, u64 *base)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	/*
+	 * When BG scrubbing is enabled the actual address range is not valid.
+	 * Return -EBUSY now unless find out a method to retrieve actual full PA range.
+	 */
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	*base = ras2_ctx->base;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_size(struct device *dev, void *drv_data, u64 *size)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	*size = ras2_ctx->size;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_write_addr(struct device *dev, void *drv_data, u64 base)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->base = base;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_write_size(struct device *dev, void *drv_data, u64 size)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	if (!size)
+		return -EINVAL;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->size = size;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_get_enabled_bg(struct device *dev, void *drv_data, bool *enabled)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	*enabled = ras2_ctx->bg_scrub;
+
+	return 0;
+}
+
+static int __ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm = TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	u32 scrub_params_in;
+	bool running;
+	int ret;
+
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+	if (enable) {
+		if (ras2_ctx->bg_scrub || running)
+			return -EBUSY;
+
+		iowrite64(0, &ps_sm->params.req_addr_range[0]);
+		iowrite64(0, &ps_sm->params.req_addr_range[1]);
+		scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+		scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+		scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK, ras2_ctx->set_scrub_cycle);
+		iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+		iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+	} else {
+		if (!ras2_ctx->bg_scrub)
+			return -EPERM;
+
+		iowrite16(RAS2_STOP_PATROL_SCRUBBER, &ps_sm->params.command);
+	}
+
+	scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+	scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	scrub_params_in |= FIELD_PREP(RAS2_PS_EN_BACKGROUND, enable);
+	iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to %s background scrubbing\n",
+			str_enable_disable(enable));
+		return ret;
+	}
+
+	ras2_ctx->bg_scrub = enable;
+	if (enable) {
+		ras2_ctx->reenable_bg_scrub = false;
+		/* Update the cache to account for rounding of supplied parameters and similar */
+		return ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	}
+
+	return 0;
+}
+
+static int ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+
+	return __ras2_hw_scrub_set_enabled_bg(dev, drv_data, enable);
+}
+
+static int ras2_hw_scrub_get_enabled_od(struct device *dev, void *drv_data, bool *enabled)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	*enabled = running;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_set_enabled_od(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm = TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	u32 scrub_params_in;
+	bool running;
+	int ret;
+
+	if (!enable)
+		return -EOPNOTSUPP;
+
+	mutex_lock(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		goto exit;
+
+	if (running) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* Stop any background scrub currently in progress */
+	if (ras2_ctx->bg_scrub) {
+		ret = __ras2_hw_scrub_set_enabled_bg(dev, drv_data, false);
+		if (ret)
+			goto exit;
+
+		ras2_ctx->reenable_bg_scrub = true;
+	}
+
+	/*
+	 * The validity checks for the address range to scrub need to be updated
+	 * with (base + size) > (mem_base + mem_size) check in the future once a
+	 * proper method for determining the NUMA node memory range is available.
+	 */
+	if (!ras2_ctx->size || ras2_ctx->base < ras2_ctx->mem_base) {
+		dev_err(dev, "%s: Invalid address range, base=0x%llx size=0x%llx\n",
+			__func__, ras2_ctx->base, ras2_ctx->size);
+		ret = -ERANGE;
+		goto enable_bg_scrub;
+	}
+
+	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+	scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+	scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+	scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK, ras2_ctx->set_scrub_cycle);
+	scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+	iowrite64(ras2_ctx->base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->size, &ps_sm->params.req_addr_range[1]);
+	iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to start demand scrubbing rc(%d)\n", ret);
+		if (ret != -EBUSY) {
+			iowrite64(0, &ps_sm->params.req_addr_range[0]);
+			iowrite64(0, &ps_sm->params.req_addr_range[1]);
+			ras2_ctx->od_scrub = false;
+			ras2_ctx->base = 0;
+			ras2_ctx->size = 0;
+		}
+		goto enable_bg_scrub;
+	}
+
+	ras2_ctx->od_scrub = enable;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+
+	if (ras2_ctx->reenable_bg_scrub && ras2_ctx->driver_active && !ras2_ctx->thread) {
+		/*
+		 * If kthread_run() is called before sending the command for demand scrubbing,
+		 * the thread may determine that demand scrubbing is not running, attempt to
+		 * restart background scrubbing, and then exit. This can occur because the
+		 * thread function may start running before demand scrubbing starts.
+		 */
+		ras2_ctx->thread = kthread_run(ras2_scrub_monitor_thread, ras2_ctx,
+					       "ras2_scrub_nid%d", ras2_ctx->sys_comp_nid);
+		if (IS_ERR(ras2_ctx->thread)) {
+			ret = PTR_ERR(ras2_ctx->thread);
+			ras2_ctx->thread = NULL;
+			/*
+			 * If kthread_run() fails and the demand scrubbing has started running,
+			 * re-enabling background scrub will fail. Thus admin/firmware may need
+			 * to re-enable background scrub after demand scrubbing has finished.
+			 */
+			goto enable_bg_scrub;
+		}
+	}
+
+	goto exit;
+
+enable_bg_scrub:
+	if (ras2_ctx->reenable_bg_scrub) {
+		ras2_ctx->reenable_bg_scrub = false;
+		__ras2_hw_scrub_set_enabled_bg(dev, drv_data, true);
+	}
+
+exit:
+	mutex_unlock(ras2_ctx->pcc_lock);
+	return ret;
+}
+
+static const struct edac_scrub_ops ras2_scrub_ops = {
+	.read_addr = ras2_hw_scrub_read_addr,
+	.read_size = ras2_hw_scrub_read_size,
+	.write_addr = ras2_hw_scrub_write_addr,
+	.write_size = ras2_hw_scrub_write_size,
+	.get_enabled_bg = ras2_hw_scrub_get_enabled_bg,
+	.set_enabled_bg = ras2_hw_scrub_set_enabled_bg,
+	.get_enabled_od = ras2_hw_scrub_get_enabled_od,
+	.set_enabled_od = ras2_hw_scrub_set_enabled_od,
+	.get_min_cycle = ras2_hw_scrub_read_min_scrub_cycle,
+	.get_max_cycle = ras2_hw_scrub_read_max_scrub_cycle,
+	.get_cycle_duration = ras2_hw_scrub_cycle_read,
+	.set_cycle_duration = ras2_hw_scrub_cycle_write,
+};
+
+static void ras2_mem_drv_remove(struct auxiliary_device *auxdev)
+{
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+
+	if (!ras2_ctx)
+		return;
+
+	mutex_lock(ras2_ctx->pcc_lock);
+	ras2_ctx->driver_active = false;
+	if (ras2_ctx->thread) {
+		mutex_unlock(ras2_ctx->pcc_lock);
+		kthread_stop(ras2_ctx->thread);
+		ras2_ctx->thread = NULL;
+		return;
+	}
+	mutex_unlock(ras2_ctx->pcc_lock);
+}
+
+static int ras2_mem_drv_probe(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id)
+{
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+	struct edac_dev_feature ras_features;
+	char scrub_name[RAS2_SCRUB_NAME_LEN];
+	unsigned long start_pfn, num_spanned_pages;
+	int ret;
+
+	if (!ras2_is_patrol_scrub_support(ras2_ctx))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Retrieve the PA range of the NUMA domain and use it as the
+	 * 'Requested Address Range', when send RAS2 command GET_PATROL_PARAMETERS
+	 * to get parameters that apply to all addresses in the NUMA domain
+	 * as well as when send command START_PATROL_SCRUBBER to start the demand
+	 * scrubbing. The validity check for sys_comp_nid against NUMA_NO_NODE is
+	 * already performed in add_aux_device() in /acpi/ras2.c
+	 */
+	start_pfn = node_start_pfn(ras2_ctx->sys_comp_nid);
+	num_spanned_pages = node_spanned_pages(ras2_ctx->sys_comp_nid);
+	if (!num_spanned_pages) {
+		pr_debug("Failed to find PA range of NUMA node(%u)\n", ras2_ctx->sys_comp_nid);
+		return -EPERM;
+	}
+
+	ras2_ctx->mem_base = __pfn_to_phys(start_pfn);
+	ras2_ctx->mem_size = (u64)num_spanned_pages * PAGE_SIZE;
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	/* Initialize set_scrub_cycle */
+	if (ras2_ctx->scrub_cycle_hrs > ras2_ctx->min_scrub_cycle)
+		ras2_ctx->set_scrub_cycle = ras2_ctx->scrub_cycle_hrs;
+	else
+		ras2_ctx->set_scrub_cycle = ras2_ctx->min_scrub_cycle;
+
+	sprintf(scrub_name, "acpi_ras_mem%d", auxdev->id);
+
+	ras_features.ft_type	= RAS_FEAT_SCRUB;
+	ras_features.instance	= 0;
+	ras_features.scrub_ops	= &ras2_scrub_ops;
+	ras_features.ctx	= ras2_ctx;
+
+	ras2_ctx->driver_active = true;
+
+	return edac_dev_register(&auxdev->dev, scrub_name, NULL, 1, &ras_features);
+}
+
+static const struct auxiliary_device_id ras2_mem_dev_id_table[] = {
+	{ .name = RAS2_AUX_DEV_NAME "." RAS2_MEM_DEV_ID_NAME, },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(auxiliary, ras2_mem_dev_id_table);
+
+static struct auxiliary_driver ras2_mem_driver = {
+	.name = RAS2_MEM_DEV_ID_NAME,
+	.probe = ras2_mem_drv_probe,
+	.remove = ras2_mem_drv_remove,
+	.id_table = ras2_mem_dev_id_table,
+};
+module_auxiliary_driver(ras2_mem_driver);
+
+MODULE_IMPORT_NS("ACPI_RAS2");
+MODULE_DESCRIPTION("ACPI RAS2 memory driver");
+MODULE_LICENSE("GPL");
diff --git a/include/acpi/ras2.h b/include/acpi/ras2.h
index f4574e8e0a12..ac75b0307fa9 100644
--- a/include/acpi/ras2.h
+++ b/include/acpi/ras2.h
@@ -37,6 +37,22 @@ struct device;
  *			is associated with. See ACPI spec 6.5 Table 5.80: RAS2
  *			Platform Communication Channel Descriptor format,
  *			Field: Instance
+ * @mem_base:		Base of the lowest physical continuous memory range
+ *			of the memory associated with the NUMA domain
+ * @mem_size		Size of the lowest physical continuous memory range
+ *			of the memory associated with the NUMA domain
+ * @base:		Base address of the memory region to scrub
+ * @size:		Size of the memory region to scrub
+ * @scrub_cycle_hrs:	Current scrub rate in hours
+ * @set_scrub_cycle:	Scrub rate to set in hours
+ * @min_scrub_cycle:	Minimum scrub rate supported
+ * @max_scrub_cycle:	Maximum scrub rate supported
+ * @od_scrub:		Status of demand scrubbing (memory region)
+ * @bg_scrub:		Status of background patrol scrubbing
+ * @reenable_bg_scrub:	Flag indicates restart background scrubbing after demand
+ *			scrubbing is finished
+ * @thread:		Demand scrub monitor kthread
+ * @driver_active:	Flag indicates RAS2 memory driver is active/removed
  */
 struct ras2_mem_ctx {
 	struct auxiliary_device		adev;
@@ -45,6 +61,19 @@ struct ras2_mem_ctx {
 	void				*sspcc;
 	struct mutex			*pcc_lock;
 	u32				sys_comp_nid;
+	u64				mem_base;
+	u64				mem_size;
+	u64				base;
+	u64				size;
+	u8				scrub_cycle_hrs;
+	u8				set_scrub_cycle;
+	u8				min_scrub_cycle;
+	u8				max_scrub_cycle;
+	bool				od_scrub;
+	bool				bg_scrub;
+	bool				reenable_bg_scrub;
+	struct task_struct		*thread;
+	bool				driver_active;
 };
 
 #ifdef CONFIG_ACPI_RAS2
diff --git a/include/linux/edac.h b/include/linux/edac.h
index e6b4e51130e5..be4f6e52ea38 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -684,6 +684,8 @@ enum edac_dev_feat {
  * @write_size: set offset of the scrubbing range.
  * @get_enabled_bg: check if currently performing background scrub.
  * @set_enabled_bg: start or stop a bg-scrub.
+ * @get_enabled_od: check if currently performing demand scrub.
+ * @set_enabled_od: start or stop a demand-scrub.
  * @get_min_cycle: get minimum supported scrub cycle duration in seconds.
  * @get_max_cycle: get maximum supported scrub cycle duration in seconds.
  * @get_cycle_duration: get current scrub cycle duration in seconds.
@@ -696,6 +698,8 @@ struct edac_scrub_ops {
 	int (*write_size)(struct device *dev, void *drv_data, u64 size);
 	int (*get_enabled_bg)(struct device *dev, void *drv_data, bool *enable);
 	int (*set_enabled_bg)(struct device *dev, void *drv_data, bool enable);
+	int (*get_enabled_od)(struct device *dev, void *drv_data, bool *enable);
+	int (*set_enabled_od)(struct device *dev, void *drv_data, bool enable);
 	int (*get_min_cycle)(struct device *dev, void *drv_data,  u32 *min);
 	int (*get_max_cycle)(struct device *dev, void *drv_data,  u32 *max);
 	int (*get_cycle_duration)(struct device *dev, void *drv_data, u32 *cycle);
-- 
2.25.1


