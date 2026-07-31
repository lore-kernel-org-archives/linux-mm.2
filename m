Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680D3C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE3D6B0093; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361166B0099; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2260B6B0093; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DED5C6B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 571B212048C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:15:01 +0000 (UTC)
X-FDA: 85049570802.23.2FD9464
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 168BD100007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:14:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qj8xIUqC;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.93.201.50 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785514498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgdif1GWTwTtXNPIiujShiW5ohR13c3tbe7bTxXILMM=;
	b=RTC7LdNnSTKEWlrHdj5pvNFF+twm49JeiIPhThYlxhHx2M+ocqIdTYizrQSnyt/m/zMrCH
	fQUE+wCkkUY+SBY2Q9Fc1h0FunVE+wY8ib0rmvCnrleNS0DX/kv16HROFoGzyA4uNYwp/j
	/lRdBgkiAYDgLxwUU19jJ7Fw+/fHX7A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785514498;
	b=wq2eWjKjYk543N7EjuJxsDlDflGnaPjtD4AengnMKOGSEddUWRm3AenDTUHcDhCFhhyjgX
	u2rfQ3N6ansB/qYXz2+Y+5GJb5O10QoaarmG3/5CVoKKEBhu/RRsDJWiuGtgewlvCGZ3ys
	oJ4XHfK+11asmlFczQGrxRjqDofA5mc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qj8xIUqC;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.93.201.50 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEMyH5+s8jQQ3USUvMWj+qtxbZ2Pxoq/kbFj0VWJdxOqN116II+9bFVFFahu4saRVtS7ID6A1jUBWEqMckdFnjC9niS0/qyWlOV92/t4i3TKVMH8H7HBpfsSiQucdqCZ7yDz15ALo1kp0o8BC4UWicaDlFtOv+MOj9WCOr2dHeJpVhiSJz/bbjZRQsRgffRWws35uW6z/6AwGkrIbh331a/SbvmzsIthhFWWFLdqDD6sqEk+49UKSuQsKozSaIiq5lrH9dIWcW7UCcq/bQg5WFRrr2O9c42KOYHrd6htabt2d9uDQhOgBcH2XUElP0Yeml3LVqvhxiidHkeG1g53DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgdif1GWTwTtXNPIiujShiW5ohR13c3tbe7bTxXILMM=;
 b=Cgvku2aqVnnkoRsD9tHRJnqimX4Z+UspQF8Z59hkai+ZHNjbno2PHOTo7qICvKukTfSsaPhcb7h0GqwD/Ouj3gmGDtxmbuxXwCV/f1gFHeVffA5Mfd58hntzzefvVJcBmOhqPYnCbtN8EAsz6AETtimTmjFWGxwc/Ht2PodpjOtvNDHY+tG76TUvE7d2tWz5IHc2Im8x++dBPP2kaQAW6yqI8596g4ny1iGK6gPz9XC62F25UjoBnxENdcfDVy0C7jjDRrOWIZOb3SdLFgOpXPghtbHiWfg+qfJtE4RB79UzZMi8JyXabTWau6Xtbr06JBFoHSJTear67AKXc97vXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgdif1GWTwTtXNPIiujShiW5ohR13c3tbe7bTxXILMM=;
 b=qj8xIUqCaZTQIuylnB1S+jbM+qPc+eCjN2srr4vGD4sx0oKqk6VlfpRM5jce5rlXuFNPnLRTQPaD4kIBidmo6zWJOD93Q95sW9igh5Jndn8LlB+Y12X/VXJG4meMwCFEi10sLedkuN3bHCO2l9qTwvcShfOG2uJ1aP3J8FHj1vA=
Received: from CH0PR03CA0188.namprd03.prod.outlook.com (2603:10b6:610:e4::13)
 by SJ0PR12MB6927.namprd12.prod.outlook.com (2603:10b6:a03:483::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 16:14:46 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::7f) by CH0PR03CA0188.outlook.office365.com
 (2603:10b6:610:e4::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 16:14:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Fri, 31 Jul 2026 16:14:46 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 31 Jul
 2026 11:14:45 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Fri, 31 Jul 2026 11:14:38 -0500
Message-ID: <dccd24fc-f4c7-4d33-bc10-0c2c8981e9fd@amd.com>
Date: Fri, 31 Jul 2026 21:44:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/8] mm: Hot page tracking and promotion - pghot
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-4-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-4-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|SJ0PR12MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: a6816cad-1cbb-4c3a-79c4-08deef1ed6b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|82310400026|1800799024|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gJMsjTRE87NhAHl/2icTZm1ho8uXe6EOowUQIC15/qKQriF2aSopQTLBFtSPeOC90TKwX3cYHw+ryuCHjPNU6U4bKRIEyQWCaduMEnONyAEV/wcsdsOz/L4hjle6Gh+by5akktP9LCAwNtbsTEw7ajOgXlI73E7yybI8a0hMa3lYnER2kKMaAqP20afeP9P2uKJBT+xQQpWm/PB0yCLWGzphCnHIbEh1hjqxGbfXYR9h3dx7bPq9bn+F6MOHVYJmfgoP6Gj9U7SghdccNIy8+IKQEBmmtX+a1ogzsDp0bVHHX2zxGGVijx3MzdrADL1mCUDX6ns/XyiP1ImdYrNmYjbLkOyF1EYh4wiGO+uAHN82FGKFzOduLnYoDq7+vTv8rmjDwBlMYRzfiKh2ClkD2pLyODX+eGFePrwvawo0HjwJi8Iofn8QKzZFYve5yDyIsMd5pEJUPt9JmtwceIwLExaOhR/Cwy5dxCzXnDvr4ysFWZzNbjkwCVtZ5W+AOwCXtEzNR43wQRz1yfsSU6m7RH82mnLCf/UMMzBtCZMWDLwI50lYJ96OXyPP+kNFucSs81BpdCSBWXPgF62G4lnOYik8S38qKiCcwRmO5F7v76mx0wdyUPffPB2v/6Wd4Azp5tvz+/nfWWkIv9GPnb/Xa8mAOLltNcB1cc2aLkFQ68qlmGNk1LfvKTVkhnnYE3RnloM4ViQ/QESQWOIjgJWeLA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gRMPmMMiS2TsQAJrGqSkUgEcKXssxdo0dSJ8EAvRV94xyR6KbLKDed+S22Byz16MBNVqgFnBRv8NeYVZDIeqWDx7QlR5znXtwZbgpDWwR/pPio4gVzQ8iohlK0bJquuwHLtgChEvucXQ2qFTu23LS9fm4o5sRj4zUG6uBngVggh5uTxyxO3a4GIsVq70fOo+rDSEqaXqbTc0VOPhRGSAbrKdHlhPiwT5YSN97k0RwJ5c4sNprbGecr0cnVDomhex7puZnnXkD/DbFeI2y59IfFelt9eSyYthDXp4fhkivQ/ZRj6kbUDWW4mB18dUwzc0TkIXAKWA693Z9JF1zwkqLkAqYO0/0HP+3Pj39VC7kAns9LuZRK0AL+Z+Or0Bqj92jKqxipywqgqnJO6BJ9bFXawRDHPU75UAYNcOFKbCLgHKw0zD8BseZl44xAc3Avav
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 16:14:46.2601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6816cad-1cbb-4c3a-79c4-08deef1ed6b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6927
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 168BD100007
X-Stat-Signature: y3ubauah8e49yd6wmbki8t5iydjh6oum
X-Rspam-User: 
X-HE-Tag: 1785514497-788949
X-HE-Meta: U2FsdGVkX18psAPDlxsINRFcZ1yCq2xVjUmE7S9Dq09OAwkUGctXVznDxpdWHO386pSSJ7rP/ExYNeo78L8lNpe0Y5FG4yah9JLHUMk3NKnTxQTwFFgoSnxmkxt/JIZPqZ5xJO4PnWq4ENTSsx1ohRZvXabtjKFUmrwjFIrdhKo0frZ/r+AvZv5SDz55gnrZPLkHRq9Eijzb6KeMX9PcW70Qt/84gmnaEOtWtjIgr0jmtPQq0oCLO1uGmT/QC5fAra3bW0BlieBLQl7G39vK3G+FC/V42gjAtXZtXLqOWWjEMEU8uAjuTbNK2eJJET8ioEp2CAGtaNuoUJPa5BAByRscIeK6yocp6yihbkonYi3pr+L8jOHU/t4BYTGZF/VqjHXtyk9GNxhQbeOb0SoIQY8gNQuZ0Z6riyqYprdJoR8GDRCmqVQXaTfcJtmdbeN5ZfVBPII8G/e5mLpLEVr7ILT1XxG76hU/+QlwFCEYvwjAXJsxNR2Kl/hbH8DjxxE88981kwnMK7zG4AZcWO74MqnySQqovkNBYZAtYaYnJXd5DZE5Q0dwA98nxjVpD663l3/dhQBqvV+1A9MpLzAhJK4CVHAWq8XrakVPmfDOAVM8XqhbDnN3R5b5VwCtiuRhrpe1WnExPdn9BDwEC0KVHqhw8Q8ekmcvyEU459kPtab4QRJFrHDxtKQVQfMDPpAa9RkNOlhjDmtjXxNhuTOqdUxLFlOaWsXx2rCpX8LafTDgCJxRX9Ml6/PeOhfxyL+HkNjatU5YAhbFM+k9SHVNYoAwNZmIuilJLjhOte3oUxw/+ApvJwnVV2ogEuqkTPKde/HIEmf95OnxqrY6YHWjkNcL8zhNuW27/AW5ZAGjl9Hdc0pKwS/4sIrOk0hjxC7m8jFez67bbnxzxXEI0tUanc46ct+etRizqZDOgvl/7ZkFPp6HCv4bFnbOrKUNmLKZN5mZ3KZbNpN3340XZ8k
 62jJ/+n1
 ccF3RNVmj+lZn/pycf5OUrr1iJ/NAYpZ8kvb6rl3Tn3lQm0MrYSCTJ8mxEdc6hwFpcJNEGOrqtOnTQ/I6GBOCC5rq7E1sIaUOytvUjkqFeS5j9OxzNtLSBJIzQJwRSu1XZDIqYWMTfuKGT34gZqXOnjniGWvvGGhZJ+YncG6Puhn2fXOEKy7teWX6AKzNnzq6cuFH0GM4gWxlv2KSRrWk8QIUZ4Mk/2BjGpaX5tttt9f6qClp0Gj8ES0UWSWd7ZD375/dwgJeXDWu25Gjeo3EfLHT152g8d8P3KYUxtj/pxOcwvnarrafNLexE7bisV3jzWwuIeYADz3EZcRgshcU24UwNSgvZL5t5/DTgTLMi8ZaRt2ZI0advrkwhc9YAKLqtteKjQMlWEnMA2FNHSd8kJ2QiwCwGSVQc2EHHsnl0pJte+6FUE1JrPO03i9AG9sI4+RlIL6uaVpYmxi+WYk8w8YGXYrlxaX1q6ZFkWGeACqe/mueEDdhhUeZe3QZ3S2Gu3C/H4GOyulXop8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Reply to Shashiko review]

On 28-Jul-26 11:13 AM, Bharata B Rao wrote:
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9e0ca4824905..0a5bcd5d45ed 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1509,6 +1509,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> +config PGHOT
> +	bool "Hot page tracking and promotion"
> +	default n
> +	depends on NUMA_MIGRATION && SPARSEMEM

> Will this fail to compile if CONFIG_PGHOT is enabled but CONFIG_NUMA_BALANCING
> is disabled? The kmigrated_promotion_rate_limit() function unconditionally
> accesses fields like pgdat->nbp_rl_start which are gated by
> CONFIG_NUMA_BALANCING.

kmigrated_promotion_rate_limit() and the pgdat->nbp_* fields aren't part
of this patch (3/8) -- they're introduced in 5/8. That same patch moves the
nbp_* fields (and the PGPROMOTE_* node stats) from #ifdef
CONFIG_NUMA_BALANCING to #ifdef CONFIG_PGHOT.

So with CONFIG_PGHOT=y the fields exist regardless of
CONFIG_NUMA_BALANCING. PGHOT depends only on NUMA_MIGRATION && SPARSEMEM,
so PGHOT=y with NUMA_BALANCING=n is a supported configuration and builds
cleanly.

> diff --git a/mm/pghot-default.c b/mm/pghot-default.c
> new file mode 100644
> index 000000000000..ed66a867a644
> --- /dev/null
> +++ b/mm/pghot-default.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pghot: Default mode
> + *
> + * 1 byte hotness record per PFN.
> + * Bucketed time and frequency tracked as part of the record.
> + * Promotion to @sysctl_pghot_target_nid by default.
> + */
> +
> +#include <linux/pghot.h>
> +#include <linux/jiffies.h>
> +
> +/* pghot-default doesn't store and hence no NID validation is required */
> +bool pghot_nid_valid(int nid)
> +{
> +	return true;
> +}
> +
> +/*
> + * @time is regular time, @old_time is bucketed time.
> + */
> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
> +{
> +	time &= PGHOT_TIME_BUCKETS_MASK;
> +	old_time <<= PGHOT_TIME_BUCKETS_SHIFT;
> +
> +	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_BUCKETS_MASK);
> +}

> Does this time calculation allow cold pages to be falsely promoted? Since the
> time bucket uses 5 bits, PGHOT_TIME_BUCKETS_MASK wraps around approximately
> every 4 seconds at HZ=1000. If an access occurs hours later, the modulo
> arithmetic might yield a small random latency, tricking the threshold check
> and causing widespread false promotions.

This is the same scheme that the existing NUMAB=2 has always used:
numa_hint_fault_latency() computes (time - last_time) & PAGE_ACCESS_TIME_MASK.
pghot's default (1-byte) record simply keeps that accuracy-vs-space tradeoff;
precise mode (CONFIG_PGHOT_PRECISE) widens the window to ~16s.

This is not the only check that allows promotion. There are others as well like
frequency threshold (by default 2 accesses), pgdat_free_space_enough() check,
the dynamic hot-threshold adjustment, and pghot_promote_rate_limit.

A genuinely cold page may get promoted (and will eventually get demoted too
under pressure) but I don't think it will lead to widespread false promotions.
I'll add a comment to pghot_access_latency() documenting the bounded-window
tradeoff so it's explicit.

> +}
> diff --git a/mm/pghot.c b/mm/pghot.c
> +/*
> + * Walks the PFNs of the zone, isolates and migrates them in batches.
> + */
> +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
> +				int src_nid)
> +{
> +	struct mem_cgroup *cur_memcg = NULL;
> +	int cur_nid = NUMA_NO_NODE;
> +	LIST_HEAD(migrate_list);
> +	int batch_count = 0;
> +	struct folio *folio;
> +	struct page *page;
> +	unsigned long pfn;
> +
> +	pfn = start_pfn;
> +	do {
> +		int nid = NUMA_NO_NODE, nr = 1;
> +		struct mem_cgroup *memcg;
> +		unsigned long time = 0;
> +		int freq = 0;
> +
> +		if (!pfn_valid(pfn))
> +			goto out_next;
> +
> +		page = pfn_to_online_page(pfn);
> +		if (!page)
> +			goto out_next;
> +
> +		folio = page_folio(page);
> +		if (!folio_try_get(folio))
> +			goto out_next;
> +
> +		if (unlikely(page_folio(page) != folio)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		nr = folio_nr_pages(folio);
> +		if (folio_nid(folio) != src_nid) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (!folio_test_lru(folio)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (pghot_get_hotness(pfn, &nid, &freq, &time)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (folio_nid(folio) == nid) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (migrate_misplaced_folio_prepare(folio, NULL, nid)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		rcu_read_lock();
> +		memcg = folio_memcg(folio);
> +		rcu_read_unlock();
> +		if (cur_nid == NUMA_NO_NODE) {
> +			cur_nid = nid;
> +			cur_memcg = memcg;
> +		}
> +
> +		/* If NID or memcg changed, flush the previous batch first */
> +		if (cur_nid != nid || cur_memcg != memcg) {
> +			if (!list_empty(&migrate_list))
> +				promote_misplaced_memcg_folios(&migrate_list, cur_nid);
> +			cur_nid = nid;
> +			cur_memcg = memcg;
> +			batch_count = 0;
> +			cond_resched();
> +		}
> +
> +		list_add(&folio->lru, &migrate_list);
> +		folio_put(folio);
> +
> +		if (++batch_count > READ_ONCE(kmigrated_batch_nr)) {
> +			promote_misplaced_memcg_folios(&migrate_list, cur_nid);
> +			batch_count = 0;
> +			cond_resched();
> +		}
> +out_next:
> +		pfn += nr;
> +	} while (pfn < end_pfn);

> Is there a risk of unbounded PFN scanning causing soft lockups here?
> cond_resched() is only called when a batch is successfully flushed. If a
> section's hot bit is set but no pages qualify for migration and the code takes
> the goto out_next path, the loop might spin through millions of PFNs without
> ever yielding the CPU.

> Is there a risk of unbounded PFN scanning causing soft lockups here?
> ... the loop might spin through millions of PFNs without ever yielding

kmigrated_walk_zone() is called per-section, so a single walk scans at most
PAGES_PER_SECTION PFNs (32768 on x86_64) not millions. The worst case can occur
if kmigrated_do_work()'s outer loop walks every hot section of the node
back-to-back without resulting in anything to migrate.

Hence let me add a resched point once per section in that outer loop.

> Could this PFN advancement skip valid folios if the loop starts on a tail page?
> If folio_try_get() fails on a head page, nr remains 1 and pfn advances to a
> tail page. On the next iteration, resolving the head folio succeeds, setting nr
> to folio_nr_pages(folio). Adding this full length to the tail page's PFN will
> overshoot the actual end of the folio and skip subsequent pages.

Theoretically yes, but not sure if that can happen for standard THPs. And
gigantic (1G) folios are anyway skipped as they aren't part of LRU.

But then I will fix it to ensure that it won't ever happen


> +	if (!list_empty(&migrate_list))
> +		promote_misplaced_memcg_folios(&migrate_list, cur_nid);
> +}
> +
> +static void kmigrated_do_work(pg_data_t *pgdat)
> +{
> +	unsigned long section_nr, s_begin, start_pfn;
> +	struct pghot_hot_map *hot_map;
> +	struct mem_section *ms;
> +	bool hot;
> +	int nid;
> +
> +	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {

> Does this skip the very first present memory section? The macro
> for_each_present_section_nr() internally calls next_present_section_nr() on
> its start parameter, which means it will immediately advance past s_begin
> and never process the first section for promotion.

No. next_present_section_nr() is called with (start - 1) which guarantees that
the first present section is considered in the loop.

> +		start_pfn = section_nr_to_pfn(section_nr);
> +		ms = __nr_to_section(section_nr);
> +
> +		if (!pfn_valid(start_pfn))
> +			continue;

> What happens if a memory section is only partially populated and starts with a
> memory hole? This check appears to skip the entire section based solely on the
> first PFN, which would ignore any valid hot folios located further inside the
> section.

Hmm what kind of sections are those which start with a hole? Device memory
sections? Those are already excluded from pghot's tracking. pghot tracks only
on-LRU RAM folios whose sections won't get skipped with this check, I believe.

> +
> +		nid = pfn_to_nid(start_pfn);
> +		if (node_is_toptier(nid) || nid != pgdat->node_id)
> +			continue;
> +
> +		rcu_read_lock();
> +		hot_map = rcu_dereference(ms->hot_map);
> +		hot = hot_map &&
> +		      test_and_clear_bit(PGHOT_SECTION_HOT_BIT, &hot_map->flags);
> +		rcu_read_unlock();
> +
> +		if (!hot)
> +			continue;
> +
> +		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
> +				    pgdat->node_id);
> +	}
> +}
> +
> 
> +
> +static void pghot_free_hot_map(struct mem_section *ms)
> +{
> +	struct pghot_hot_map *hot_map;
> +
> +	hot_map = rcu_dereference_protected(ms->hot_map, 1);
> +	if (!hot_map)
> +		return;
> +
> +	RCU_INIT_POINTER(ms->hot_map, NULL);
> +	kfree_rcu(hot_map, rcu);

> Can two racing threads double-free the hot_map pointer here? Because
> rcu_dereference_protected() is used without a lock, concurrent calls might both
> read the same non-NULL pointer and call kfree_rcu() on it.

pghot_free_hot_map() is called for three places:

1. pghot_offline_sec_hotmap() — from the notifier on MEM_OFFLINE /
MEM_CANCEL_ONLINE.
2. pghot_online_sec_hotmap() rollback — from the notifier on MEM_GOING_ONLINE.
3. pghot_destroy_hot_map() — only from pghot_init()'s failure path.

First two paths are already serialized by mem_hotplug_lock.
Regarding the third one, pghot_destroy_hot_map() needs to run under
get_online_mems() to address your next two comments. That would close the window
for path 3 as well.

> +}
> +
> +static int pghot_alloc_hot_map(struct mem_section *ms, int nid)
> +{
> +	struct pghot_hot_map *hot_map;
> +
> +	hot_map = kzalloc_node(struct_size(hot_map, phi, PAGES_PER_SECTION),
> +			       GFP_KERNEL, nid);
> +	if (!hot_map)
> +		return -ENOMEM;
> +
> +	rcu_assign_pointer(ms->hot_map, hot_map);
> +	return 0;
> +}
> +
> +static void pghot_offline_sec_hotmap(unsigned long start_pfn,
> +				     unsigned long nr_pages)
> +{
> +	unsigned long start, end, pfn;
> +	struct mem_section *ms;
> +
> +	start = SECTION_ALIGN_DOWN(start_pfn);
> +	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
> +
> +	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (!ms)
> +			continue;
> +
> +		pghot_free_hot_map(ms);
> +	}
> +}
> +
> +static int pghot_online_sec_hotmap(unsigned long start_pfn,
> +				   unsigned long nr_pages)
> +{
> +	int nid = pfn_to_nid(start_pfn);
> +	unsigned long start, end, pfn;
> +	struct mem_section *ms;
> +	int fail = 0;
> +
> +	/*
> +	 * No section hot maps for toptier sections.
> +	 */
> +	if (node_is_toptier(nid))
> +		return 0;
> +
> +	start = SECTION_ALIGN_DOWN(start_pfn);
> +	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
> +
> +	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (!ms || rcu_access_pointer(ms->hot_map))
> +			continue;
> +
> +		fail = pghot_alloc_hot_map(ms, nid);
> +	}
> +
> +	if (!fail)
> +		return 0;
> +
> +	/* rollback: free the sections allocated before the failure */
> +	end = pfn - PAGES_PER_SECTION;
> +	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (ms)
> +			pghot_free_hot_map(ms);
> +	}
> +	return -ENOMEM;
> +}

> Could this rollback loop inadvertently destroy hotness metadata for pre-existing
> online sections? The loop iterates from start to the failure point and frees
> every hot_map without checking if this specific function invocation was the one
> that originally allocated it.

Though there is a check to skip allocation if the hot_map already exists, it is
not really possible to hit that as I think memory hotplugs are section aligned
and we free hot_maps of those sections (ranging from start to failure pfn) for
which allocation succeded during this onlining.

The only way the section being onlined could have a map is due to the
setup-vs-notifier race, which I will fix as explained in the previous and the
next review comments.

> +
> +static int pghot_memhp_callback(struct notifier_block *self,
> +				unsigned long action, void *arg)
> +{
> +	struct memory_notify *mn = arg;
> +	int ret = 0;
> +
> +	switch (action) {
> +	case MEM_GOING_ONLINE:
> +		ret = pghot_online_sec_hotmap(mn->start_pfn, mn->nr_pages);
> +		break;
> +	case MEM_OFFLINE:
> +	case MEM_CANCEL_ONLINE:
> +		pghot_offline_sec_hotmap(mn->start_pfn, mn->nr_pages);
> +		break;
> +	}
> +
> +	return notifier_from_errno(ret);
> +}
> +
> +static struct notifier_block pghot_mem_notifier = {
> +	.notifier_call = pghot_memhp_callback,
> +	.priority = DEFAULT_CALLBACK_PRI,
> +};
> +
> +static void pghot_destroy_hot_map(void)
> +{
> +	unsigned long section_nr, s_begin;
> +	struct mem_section *ms;
> +
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {
> +		ms = __nr_to_section(section_nr);
> +		pghot_free_hot_map(ms);
> +	}
> +
> +	unregister_memory_notifier(&pghot_mem_notifier);

> Is there a race condition with the memory hotplug notifier during teardown?
> Because the maps are freed before the notifier is unregistered, a concurrent
> memory offline event could trigger the callback and attempt to free the same
> map again.

See the reply to next comment.


> +}
> +
> +static int pghot_setup_hot_map(void)
> +{
> +	unsigned long section_nr, s_begin, start_pfn;
> +	struct mem_section *ms;
> +	int nid, ret;
> +
> +	ret = register_memory_notifier(&pghot_mem_notifier);
> +	if (ret)
> +		return ret;
> +
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {
> +		ms = __nr_to_section(section_nr);
> +		start_pfn = section_nr_to_pfn(section_nr);
> +		nid = pfn_to_nid(start_pfn);
> +
> +		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
> +			continue;
> +
> +		if (pghot_alloc_hot_map(ms, nid))
> +			goto out_free_hot_map;
> +	}
> +	return 0;

> Can a concurrent memory hotplug event leak hot_map structures during setup?
> The notifier is registered before the loop allocates maps for pre-existing
> sections. If a memory online event triggers the callback concurrently, it could
> allocate a map that this loop subsequently overwrites and leaks.

Both the above are locking issues. They can be fixed by holding
get_online_mems() in both setup and destroy paths.

Regards,
Bharata.

