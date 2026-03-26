Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AA510A1E62
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626CD6B011F; Thu, 26 Mar 2026 06:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDAA6B0120; Thu, 26 Mar 2026 06:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513B16B0122; Thu, 26 Mar 2026 06:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4576B011F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:42:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC7F0BD186
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:42:15 +0000 (UTC)
X-FDA: 84587874630.16.C735DCA
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9129F180008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:42:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FrtoI4cd;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774521732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/no+d7M7pA9wHG6LHltuYE9vVAZuxXeRXo8wZybwAo=;
	b=lxSlltJTPfzccpOzlmI4zE9b/6R9x0RX/kdTS6WS55jHIS6LlSZSUggbh4LciIBMrrBqXt
	mGxpUWFFpWOk1Bx9utxvLmxtPISV8jCApt+GaUQ8hjsalDp4Ae9OaE7lrd/9Ekpd31CyFG
	kdet6WrBhToJZavJMUeAb9G6tkf6zOw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FrtoI4cd;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774521732; a=rsa-sha256;
	cv=pass;
	b=acC5Yw+AfwfpTB3sQJH34hymiQ37Smu5QZRVXKwqzoi/2cZpnXf+FHCPuHF5eIfRuAe0Ds
	MzleDZFqYVonDlLucFSOMogjdlHBrbpc+zyvGkRBR9t6Q8i2YlyJ49Xt8dZrgq9T9/zYR8
	gA0iR363f+JyoMu646OTMYgh9HDhNaE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTHiz9FAdFNSSwDLWtsbwjMeY72cBHPZeYFY0+Ln07vGUTAaeF/4ix4E8qq+XtcKRruAxGNUfvTQT+/W/mHGfHCfl8qYx3WOf4z4sgEJJLiKGuthE8nIr1mUycVsXuG6mKTFDUqJq+sllcYp4r9VTymmnLQw2QqhsSIHu7HvcpwtQLIcXhFagn3t7m3FGMNmdCEye+1QeQFjjp8oJs7ZSfICZYc2SpvT8R9Lp2nu31H25AIVK/nbz8HQyrVFF5l19c4bcXnEZo/cenfT8az9bzcXo6NmwPblVMRvREPZbvzqjLnfo3Ejdfr5nQ0U0ZP6mH2RArbF9BgB+zhBgpE51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/no+d7M7pA9wHG6LHltuYE9vVAZuxXeRXo8wZybwAo=;
 b=pSEf8SF7nIRS8pKIT8ZUOrjnXR/Tzdf5sRa7nQKe8QOzuUluHNoogpH0likdEPTpmxmXFleKGq5RjiuLXN1BZgkMGoc/NBsZYDbT2BwGZmYjyYpH0HnB0DFmmhbTDqNC/qGEnpV6+nzL0J/mwNNDZoef5rOMuA3ADXsQ9eOg8UUAuVGNrOOzOZ8wEMHZg0YvVlua21S1cVJSaZ8UisD9YdXKvPtdXZYVaN5iHRklpJNDPgzjCKhzMxFlmhY790tAjpK/ksyrbzjDulvcqUlRWsFrs9ZJj5Jhr+JuaFmmekdjUqBKw9YMuNtecI6A+X36kgC9UeYfcUxXXtqTJwCjGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/no+d7M7pA9wHG6LHltuYE9vVAZuxXeRXo8wZybwAo=;
 b=FrtoI4cdydRUVrRtHAmnV9V47xbsuKxXgTLydIgV47ogWRomml7uPiVJjt81vb2hUMY20+vgla68NufqSHZiJXq+AnqRJfqDPbnCL4PYBuh5uc/3UizfJm52VGHv2o8jWmGmfCClnE64zA7zB/Fix1GtoNJXhDX7qaCy1zDtOcE=
Received: from BN9P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::16)
 by MN0PR12MB5883.namprd12.prod.outlook.com (2603:10b6:208:37b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.7; Thu, 26 Mar
 2026 10:42:06 +0000
Received: from BN3PEPF0000B070.namprd21.prod.outlook.com
 (2603:10b6:408:13e:cafe::7) by BN9P220CA0011.outlook.office365.com
 (2603:10b6:408:13e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.22 via Frontend Transport; Thu,
 26 Mar 2026 10:42:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B070.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.0 via Frontend Transport; Thu, 26 Mar 2026 10:42:05 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Mar
 2026 05:42:05 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Mar
 2026 03:42:05 -0700
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 26 Mar 2026 05:41:58 -0500
Message-ID: <ce3b51f8-812d-424d-9848-3ba408253c9d@amd.com>
Date: Thu, 26 Mar 2026 16:11:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 4/5] mm: pghot: Precision mode for pghot
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-5-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-5-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B070:EE_|MN0PR12MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: 4346f67b-ca71-4536-52e3-08de8b2452fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|7416014|13003099007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Mt1lJnq6EeYS8E7hMm7t8Xbgt2KRqGAhJNfJf6sYMREK9TsM6152W1UwZvJQfOkNN1OrH6btw0dIzEeM6nCf608dpXN8uuO14rumZ7MHkdHVFekFeloE2KZB08+2a3DIQhP/4C+gPGlAMVn/vyfTYC/w2Gpf6OrNSQ3SrK4fpNjqgBzWeRSm8W4CTCuCxbGJfuSFETofrhKljvvxzh0Oz58A2fwxmKVaTBx07OKbWGdXalMEKAQLOgVPEDSVFS3rzFQNIyOjrHXC6O9FaugO0Fx1fou6uDkLzPyKRlBmVRZHkJFGDX1jYYKi9OsfqA0sLHnRlFbaqFHq4cbt1ZfYztDmS6uqa3DXzkgUm5GVgpo3YSul5/E1PNe0hKUEMbK9TEgPlzCEQP4tVJ75K6cq8jmgzf8uu9IZV1/6doEM0dEgho8rG6C5zQQYbxE04ovvXSoNq6q1oQEzPlKD84EDGgTXSYuF7l8V2xPFOVmYqB5eW50dC36/hJNWHRDxOAhoGaRjwI1Gumv0onR/5NXvCFOUPaSKh/o+fMOG6kY1AxWVPXI71/VIDOtb6e/6HZZEki5vgXzRN+XoDizTUysDdkrCoxEwl7B2g8zruVdTSCfIeMoXaUkJQRaqc56AZhm/hXv9VsQ2CBXYy1zg0SWqmUVEs1dFLCIyWB/+x0J7Z45oYth0gEaB/mSzZSBwH7i3CnNRHJhP7f8K6WcOY6MuXg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(7416014)(13003099007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cci+Xkdf5p+qkBNGsz7tJJmvr7q8gDuMKB71TA2xSHztFbwr9hFvgRZvDY7NsajHpMnx5Y64uQ078uZHv4lfsTiwwdKNG1Lx5tS5xg7sTJoaIluOGVgAZ99hQhRbtn8gm6ASvIClXbCHy4JXYcfwrcicjWydcmVZRv14119BIvKfgpjkauCMeHBKV8hvlgTIpoKE2zNDC0PzMC9Ny17H1Xn9k8sgrM6jkAsjqhJt3MDKI8XT1xNvHdVr2ov8h9wIzA+MMemwxOu0N69Ccro+Ox2RPw3at5hz1FT8GLtmL4SPYEF/Cinqovl0/2ypTD4V8jeVKUTyTCK6j5Gxe+/CLuOo57mTxZjQSdQpM0R1As8P/t4bKtKX5aqnsMsKC2QhzIHHEHe46ZnV8YNFLfmZpjmELoQbIbLBmDaYl8xOxetFR/jgarAqWKyW3wEFLNU2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 10:42:05.9978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4346f67b-ca71-4536-52e3-08de8b2452fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B070.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5883
X-Rspamd-Queue-Id: 9129F180008
X-Stat-Signature: gmjg4ejshwp9tbarqt7sk3f7fkqpawai
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774521732-918622
X-HE-Meta: U2FsdGVkX18FhlyVbI761NHJgGKkyu+RvEnzpD0QP2cHVBVyHLsQFVJeOT00nQYyS2eMxYARgMcyljbdivzbv+4RKe3vdZ/BKqGchLqJ4nAthvszpSwNM5TV/YtFhjOLmwxUVaYZpBoPEfD1ceRZv8gGxGkKjbJUFU2Tu6y7dgbvEilbPMplDZIJ6TdOR9pmdG+rb2pq3IFo3e8TbD8dxUady2WA6NwIme2RfifzknJoea3/vh41CeYSr5UBnWmlraMKXkA4SWGHWisE/3VKVSBhdITFzTowhsWg4OuJbxE+qogRLSRbJ+DfJJL5Yg8IyEEmitQB0j3p8WTsMBrv/PP2ume/GVVk3OqZJ/Qg5ov/OSUAVLnvG1H/77YfwJX+gnXGNHFjyQfuxsFcQLAzy1YDW+vgb9JaYLc7NcfYlCJYJDuny3bN7S5HvKsSlUOgeojI3JTXlUVNAIVkKKAh4yJupDpQwWtD4MRkfaCYpi6KcUOydks3pPvZSjXi1zpiUAFnSWnn95CeUPpegbdz1aWj7AsM2xjcHs3tmyAKg5Ue2nt6WPFSklYfR9isB6cXW5yODW2dOS6HhCNcU6cItQR/dIIx2mIPEtcsqmtvnSvGKkNsLtPodgXLO/wvy3qAbBAz0vVm5XN3StM1fwEucmFZqXQZcK0IEI3Z9IkzHy3oNG8AOuZYoy0z1ajjhoZRhlZCj+BKQ7to3xxfj1j7QilA0ufnMiA4UEDHEesqY9qMZGMI2id/hJCs9zvrLOkCE3av6IH4wCjb6I3hy07pGefHXWoX/tOxGVANSOMuiDRn279LnvfKjMGqGV8ypNTzup0VDHOCytiKGW6IQUdr10e9eaXmoSWkvS56RFA/LY1WJIZTovz4xudlma9F6NDKDhAVvb1CQnbHT2ouYLn8QfPQ+0YpTxoeSmS2stZhMLIwCgUZD+Hl5ivXy+K1dUAoa4zFBiBXX+nOUuIcQd4
 ssjcoqCw
 grrOw+N9pWIYHydNW1AhGJiM9jOR8I+PYRwYZWcWE2fB5ciEx7PNIH/UYDnNJTMhkSh9cdSarXLkA4hzbFUArqIum5nfKgjmtlxv+T7dvorwMm4E1C4WNabeJj6IBLOI4dBMA9nMFSEdODcTS1S2XnXNepHoi1AYC6KMLLjqgMKgP6KR/H46UX/bcKkrZErYfCcs1QRfSsrM8paKTRmtI9gAjCWMVUzN5hrzEM73Qx3kB1vTNLLLftURvqPpGYYHBQiOSE17qCSrtlP78Yw2ca7lba6M5Zm3OlZgjnuuLbwmEpBoEZqSk4BD7xXqMhrdNUAyXWmTdpbGQfP+fxY5A7zuFVD6w7Q44pEBivg7ZBoYmKiJeAxRA1hMrXqUTtNks85kiq0C6qrFGPy3srNIu1b5+6U1ZdoRZIb95I1WEPVHjgmxaRYlfr2fOD7WFSMRetHchXTMjk+U88nxGIahWgV/wwCn9kWLUAnfZf6T+83ih0EGY/zrrBM+Um55am2GA0jkwY07kUCP2JIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replies to review from Shashiko
[https://sashiko.dev/#/patchset/20260323095104.238982-1-bharata%40amd.com]

>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 4aeab6aee535..14383bb1d890 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1485,6 +1485,17 @@ config PGHOT
>>  	  This adds 1 byte of metadata overhead per page in lower-tier
>>  	  memory nodes.
>>
>> +config PGHOT_PRECISE
>> +	bool "Hot page tracking precision mode"
>> +	def_bool n

> This isn't a bug, but having both bool with a prompt and def_bool is
> redundant and can be confusing. Should this use default n instead?

Sure.

>> +	depends on PGHOT
>> +	help
>> +	  Enables precision mode for tracking hot pages with pghot sub-system.
>[ ... ]
>> diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
>> new file mode 100644
>> index 000000000000..9e8007adfff9
>> --- /dev/null
>> +++ b/mm/pghot-precise.c
>> @@ -0,0 +1,81 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * pghot: Precision mode
>> + *
>> + * 4 byte hotness record per PFN (u32)
>> + * NID, time and frequency tracked as part of the record.
>> + */
>> +
>> +#include <linux/pghot.h>
>> +#include <linux/jiffies.h>
>> +
>> +bool pghot_nid_valid(int nid)
>> +{
>> +	/*
>> +	 * TODO: Add node_online() and node_is_toptier() checks?
>> +	 */
>> +	if (nid != NUMA_NO_NODE && (nid < 0 || nid >= PGHOT_NID_MAX))
>> +		return false;

> Could this validation allow node IDs that exceed the system's actual
> MAX_NUMNODES?

Unlikely as the nid gets passed down from other sub-systems like NUMA Balancing
etc.

> If PGHOT_NID_MAX is 1023 but the system supports fewer nodes, could passing
> a large node ID bypass this check and cause out-of-bounds accesses in NUMA
> node arrays like node_data or node_states?
> Also, is there an off-by-one regression here? PGHOT_NID_MAX is the maximum
> value that fits in the bitfield, so should this check be nid > PGHOT_NID_MAX
> to allow the maximum node ID?

Yes, will adjust this in the next iteration.

>> +
>> +	return true;
>> +}
>> +
>> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
>> +{
>> +	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
>> +}

> Does this timestamp wraparound allow cold pages to be improperly promoted?
> If a page is accessed exactly at intervals matching the wraparound of the
> 14-bit time mask (e.g., every 16.384 seconds at HZ=1000), the latency would
> evaluate to 0. Would this bypass the reset of the frequency counter and
> falsely trigger migration?

The hotness timestamp is stored in a limited number of bits (14 bits in precise
mode, 5 bucketed bits in default mode), which means it can only represent a
finite window of time before wrapping around — approximately 16 seconds for
precise mode and 4 seconds for default mode at HZ=1000. Latency calculations
rely on modular subtraction of these truncated timestamps. This produces the
correct elapsed time as long as the true interval between two events is shorter
than the wrap period. When the interval exceeds the wrap period, there could be
approximations.

In practice, this should be acceptable because the system has two independent
gates that a page must pass through before migration actually occurs:

1. Access frequency gate (recording time): pghot_update_record() determines
whether consecutive accesses to a page fall within the same frequency-counting
window. A page must be accessed at least pghot_freq_threshold times within
sysctl_pghot_freq_window (default 5 seconds) to be marked migration-ready.

2. Recency gate (migration time): kmigrated_should_migrate_memory() checks
whether the page's last recorded access is recent enough relative to the current
time before actually initiating migration.

>> +
>> +bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
>> +{
>> +	phi_t freq, old_freq, hotness, old_hotness, old_time;
>> +	phi_t time = now & PGHOT_TIME_MASK;
>> +
>> +	nid = (nid == NUMA_NO_NODE) ? pghot_target_nid : nid;
>> +	old_hotness = READ_ONCE(*phi);
>> +
>> +	do {
>> +		bool new_window = false;
>> +
>> +		hotness = old_hotness;
>> +		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
>> +		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
>> +
>> +		if (pghot_access_latency(old_time, time) > sysctl_pghot_freq_window)
>> +			new_window = true;

> Is there a missing upper bound on the sysctl_pghot_freq_window configuration?
> The time is tracked in a 14-bit field, which represents a maximum latency of
> 16,383 jiffies. If a user configures a window larger than this maximum
> representable latency, could this condition permanently evaluate to false,
> causing sparse accesses to accumulate over arbitrarily long periods?

I can add an upper bound check.

Regards,
Bharata.

