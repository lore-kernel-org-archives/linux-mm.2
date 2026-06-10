Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9A6CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223A16B00C7; Tue,  9 Jun 2026 21:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160006B00C9; Tue,  9 Jun 2026 21:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FCF6B00CA; Tue,  9 Jun 2026 21:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A6E6B00C7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8442F916AB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:35 +0000 (UTC)
X-FDA: 84862311030.15.D30B7BD
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id B15EC4000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pMzs+tnX;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781055933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsslT2SHe3Ngpr6+flW/+aA6XcPRV1aWnG37ChpGzVM=;
	b=zgEmziOlGq1oMhfuyOhju41JaKLtA8I/P+dgzwTSy0vJ82p1k+qUAkIolpQmgGOBS7nU21
	e5+zGZpDuOGM0cVffChpxzYxlrOUwEOHAdLUxfo3JgA1eOxK9md7vb+qxrxCsTRH+tu6Cu
	07OfihVexbz2fZ8LCPEwLWJtE56SJJw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pMzs+tnX;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781055933;
	b=fkc82etIFyR3FRzP/5P+3eTKS7rR7+N5SXB1QWgj8oWo1YNXoijZWzj6XIs7LNFnzIKxnh
	olHGFPE6/mOe1Z4GHd6XSozSOq7wqbmaqzjuKt15dnMp3LtVbwtJ/+i/mlah+rH2f4CVws
	/ZLQ8tcQLBIf44tviIwrEaZ1GIrfRsA=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5176465a4a4so83806601cf.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 18:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781055933; x=1781660733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsslT2SHe3Ngpr6+flW/+aA6XcPRV1aWnG37ChpGzVM=;
        b=pMzs+tnX/LElqC9WwjyaU4y8wnjOSnbb9w3sKJaa6jASPPH8zoA7IivKJ6GG9SM4qV
         0JUgNqaeSeFw20lE9ywtOvPGnmF/8xgvzrZQ6bNB31ebHXvUzp8gRJsfg4zxWsiZrpMc
         2BQ8wb5RxqjHnYWsHf0pUa0oNJIaadqcFP4NkC/S4JCqZGZdOD1dKgPo2/k4oQ6Wpxuw
         EwuRXQSE922zmqNojn2If9YAtrOCcVyB16EzHaFviLRcycBdJePEe6LgrWkIFJBxdBw/
         73U3I5J0Nk9eOqPyVrRpbQG2aE7m+Y+LYtqYwn0YMSH0jTgNXEkuSJ2HWeURjKoQEDv5
         Lg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781055933; x=1781660733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HsslT2SHe3Ngpr6+flW/+aA6XcPRV1aWnG37ChpGzVM=;
        b=bU802n5+cwNV1/N09Hurm9iK42ZY/++N+eEGKPIUGisXwGVdykNiNg5r+ASs9M8IUt
         ZXwSY18Cg+l5vm6SmwOam79eeDPgpwCWBZhuWpGRSGr+hvYoqTAagXtJll59RmCJe6vV
         RFLk3NkCPDE88Oc687GGN6UPsGPLA4LFODCA9+ludiFFSJ0szkJy1hwb9KRA4Gs66XyB
         jnEmTCpgLtVjG4/EX4vZtU2gHYYw7yhxTdYR5YSClkvF0PyB0GxQ1miOzcEJciQ6Sv4O
         iqN1l60mcHsRIWxC1lyKQf2+SIW6DyV9mjP5Z/UVWJ88nAsP8e4nPTLHRKSiqZ6VRY08
         BYJg==
X-Gm-Message-State: AOJu0YwsF3F5gLjnc+DFOvrTO5fzQENhBl193f601hBcFjnp8LMxaqEQ
	joxjGhKeR6UN0NPFtTWgv3LGw6qtf1VW6jWqZxDT+TJ3arjfUxAlDH1O6yWskjTZHYxwvi5XJG3
	wsHU+
X-Gm-Gg: Acq92OGkg4s/62O5nec2vXiLnY4zK3gaWGQS/7eUrrfSIuNAz+5twxOuUJK1eMzhsWk
	x0qu1mISMB/rq78hoapL5J7AEZvGp8RQNmGBFovYEXFgMInkqp61BP4MGiUqC9CZ7sgOpPtcMJH
	6lVXDijc5Y90olQohHIv3Dl+9s9NpeTKZQJlBNwpuRj22yPc6W8I8J3Apja57/gQlFuOS8UTi5C
	ebZYP8ylmASNO3nks9tl3kA3WuJKdZgMCrWBqZjXY8ohIngkSC2VQYh6FKNT8GgzOYA5tqtzGt+
	GAXBlt2C2g79et981WOEUjvHZgi5/9/0LPJ97wrXR5scpkj2nv2wnR0kMBIYWbJ051PfrQpkmG4
	OEpuvhidhps0SvnQC88pua1kjP90VtBI1GW6qkvmpGpS6UE7qoboCD/kU8j0+A22VvgwysdG2RF
	/1FpPXEtpC8VIsXVEshPTmMJhAt4jIZSOy/+RQ1jsgK7t7u7DHzvv/4bckHs5ePrNPx3/vsET+a
	+A1LMI2mrcRw/OkLgU+j40=
X-Received: by 2002:ac8:59cd:0:b0:517:b68a:8d84 with SMTP id d75a77b69052e-517c22529e3mr130851341cf.56.1781055932831;
        Tue, 09 Jun 2026 18:45:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c07e91sm205923261cf.4.2026.06.09.18.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 18:45:31 -0700 (PDT)
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
Subject: [RFC PATCH 3/3] acpi/numa: add CONFIG_ACPI_NUMA_ADD_CFMWS_NODES
Date: Tue,  9 Jun 2026 21:45:17 -0400
Message-ID: <20260610014517.253609-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260610014517.253609-1-gourry@gourry.net>
References: <20260610014517.253609-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B15EC4000B
X-Stat-Signature: sbwbdw6y1uksyuym7z974r96q4jyct6z
X-Rspam-User: 
X-HE-Tag: 1781055933-894056
X-HE-Meta: U2FsdGVkX19B5CEY5eX37oEBcmDgxPAVnwVaD+3Dn9B6rgsgMwtayfENTj6bYh/sXF/2fqB6GUaq5STPO8WqTXopH0NegC08Jk7aJQUzB2e3w9S9daJf7vx4j8ZbqC3ZledO54mB9OI3Burr7CR5Xy4z9KGuBQ/AvGfv9ORGt+QKC1wrs2bQXNXAt5BbD4JHxvydr7ny7MFTWm4bvMDP7kXbLyzu1Z/EyTJzxvA9yWA6N6Id1a/HveEyO7oQzOHSrh0NFKFRCjQiGpChyA6dk+Q1ioC5E+XgalUGiBSlMSTOZSd6Pj/qENrhYV4gx80gPH4xxqgz12LENoNgk6u8rCpaHkRM6qzpKMOLl7jd+tJGiEJXTIsGIA13f/3uFJqXRklO6G/lrdl7EjdjshUaf1R37IvX21BYdAReG+D+vuEekE65Z7I5zOC+OYkOxB39vF/HA8HZU1RkszUbodyAQ1V5eKf+9WqOgKI8QS12FNKurC+kHyaYQ35s1m9MhRjk4SWaKo6Vu7zaLIY99cweDDCCIHLKL7B6o+GGbrwPGt3bTL6OBXRxr6iIw9xYag/2X0vcgGs+QSj67bN3FR4UHviJbqri1zhdNlMqj+1aNcrXowhYR/aDS4+38XnnOHsPfXpVK8NLDRSr3MMbZ4/cuelOhtK/lyX1gWB7CfBzegXUARyDx/6i1IMC2AKVwjTpoR8v3W3pnqXuqfk/D73LGL2LSvxQxlmTF/yr04HHqdkkOM2FKM5J81ZvjWlaYv34ReVo9qHnOyKi2Vow2jo2FCTUMgfCtf4EvYnyrwtDMkPA8vYPl9RtavDvcl/IxpwaM4gznf/9zXphbxMRe+ujk4+euAbrzJUDOt3Jf00hOssnjVZNnAMz5ZKl6EzF5IxyfkyGe/TNPkNZJgDdF0NJ1AiWA3p/khGaN7E7WKteRT8P4KnOH5VnLcOZNEtVDcITru0eNAV/O/ueiscJF2w
 k2gGF0p5
 7gv4FFfEZsIkAvGkv7Dolu8l/XZRnkfx98VynUXRx1nXfu6AD0u/JwMKKjl3TmtTPUckQhWbbPjWdFUMZC8BRWK3F3JDHfX8hUtToV06EMnbFW3RXV3YypvjpTR9aqVvC7VUkC8zhhTCRb87JMDfmA2CEQ4RBQeyCcrMAJJtKJNSfKMQOUo5GylsPSBYtvrzXzs61e2Y1epu5h9jfdGzR658UWjp6FGwVqXFQLDc0a5w3sM2J46rfv+msLe+L223X5Vn4SItc3b1S52d8nzf26vEP7wp0uJAAXc3ibGSfXG3U0IXxFLoY045AQZSc1wuSZ/9/QKAF1gtGZ3V5PWjAHfINLpI2hnRQ7sia
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CXL is intended to be a programmable topology, and a single CXL Fixed
Memory Window (CFMWS) may back memory that a driver wants to split across
multiple NUMA nodes for tiering or isolation.

Those nodes must exist at __init time to be usable later.

Add CONFIG_ACPI_NUMA_ADD_CFMWS_NODES, the number of additional standby
NUMA nodes to reserve per CEDT CFMWS entry.

acpi_parse_cfmws() records the per-window count, which is folded into
the standby request on successful acpi_numa_init().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/acpi/numa/Kconfig | 20 ++++++++++++++++++++
 drivers/acpi/numa/srat.c  | 13 +++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa/Kconfig b/drivers/acpi/numa/Kconfig
index ecf27bf45e5b..65d7eb9a4022 100644
--- a/drivers/acpi/numa/Kconfig
+++ b/drivers/acpi/numa/Kconfig
@@ -14,6 +14,26 @@ config ACPI_HMAT
 	 performance attributes through the node's sysfs device if
 	 provided.
 
+config ACPI_NUMA_ADD_CFMWS_NODES
+	int "Additional standby NUMA nodes per CEDT CFMWS entry"
+	depends on ACPI_NUMA
+	range 0 4
+	default 0
+	help
+	  Number of additional standby NUMA nodes to reserve per CEDT
+	  CXL Fixed Memory Window Structure (CFMWS) entry.
+
+	  By default ACPI reserves 1 NUMA node per unique PXM entry in
+	  the SRAT, or 1 node for a CFMWS without SRAT mappings.
+
+	  Setting this > 0 reserves additional standby nodes per CFMWS
+	  that drivers can claim at runtime via
+	  numa_request_exclusive_node(). This is useful for CXL drivers
+	  that want to place memory on distinct NUMA nodes within the
+	  same CXL Fixed Memory Window.
+
+	  Set to 0 (default) to disable.
+
 config ACPI_NUMA_STANDBY_NODES
 	int "Additional standby NUMA nodes for runtime claiming"
 	depends on ACPI_NUMA
diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index d7b0e4ece610..6c54d5f0cf0a 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -354,6 +354,7 @@ static int __init acpi_parse_slit(struct acpi_table_header *table)
 }
 
 static int parsed_numa_memblks __initdata;
+static int cfmws_standby_count __initdata;
 
 static int __init
 acpi_parse_memory_affinity(union acpi_subtable_headers *header,
@@ -454,7 +455,7 @@ static int __init acpi_parse_cfmws(union acpi_subtable_headers *header,
 	 * window.
 	 */
 	if (!numa_fill_memblks(start, end))
-		return 0;
+		goto standby_nodes;
 
 	/* No SRAT description. Create a new node. */
 	node = acpi_map_pxm_to_node(*fake_pxm);
@@ -473,6 +474,11 @@ static int __init acpi_parse_cfmws(union acpi_subtable_headers *header,
 
 	/* Set the next available fake_pxm value */
 	(*fake_pxm)++;
+
+standby_nodes:
+	/* Request any standby nodes (created after numa_emulation runs) */
+	cfmws_standby_count += CONFIG_ACPI_NUMA_ADD_CFMWS_NODES;
+
 	return 0;
 }
 
@@ -607,6 +613,8 @@ int __init acpi_numa_init(void)
 	if (acpi_disabled)
 		return -EINVAL;
 
+	cfmws_standby_count = 0;
+
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
@@ -666,7 +674,8 @@ int __init acpi_numa_init(void)
 		return -ENOENT;
 
 	/* Request any standby nodes (created after numa emulation) */
-	numa_request_standby_count(CONFIG_ACPI_NUMA_STANDBY_NODES);
+	numa_request_standby_count(CONFIG_ACPI_NUMA_STANDBY_NODES +
+				   cfmws_standby_count);
 	return 0;
 }
 
-- 
2.54.0


