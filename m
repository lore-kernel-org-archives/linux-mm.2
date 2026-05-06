Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43DFFCD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868326B008A; Wed,  6 May 2026 02:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8181F6B0092; Wed,  6 May 2026 02:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7071A6B0093; Wed,  6 May 2026 02:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8416B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:15:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2CE41C066A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:15:33 +0000 (UTC)
X-FDA: 84735983346.29.2552BBF
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	by imf01.hostedemail.com (Postfix) with ESMTP id C50EA40005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:15:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gEZQDRQJ;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778048130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8U/LY9gREQWRfFkQEOrwQq6h1rS8Y+J6yUK856jDwYs=;
	b=mBd3v7P1p3BogHi4s+9bqEylxQhHGTldmFq39LhxOerrxKu220k3NKF4reZ5RyeW9RJLGE
	yAreU3Lu9+IE9ZEm+s7Rumc63Mqjz17ROpilM1cknm21JwNH0gC4iHzwMYaXS6V1HL8Ruy
	aPzcNIHfly5Tj0BDUr5jOM6M85FJvm4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gEZQDRQJ;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778048130; a=rsa-sha256;
	cv=pass;
	b=FOepJ53Uy8SrR9OnfkaRW2wFFSpHBo5jxHlXR4oo7HFtYhLyhRH4iGuoWuuJnWq5svo3rP
	Tle2huIhechbOvk5Hp9LmGrKOSyJPV/fqSv78Bdwzapms9jcnYP5bb6tT+0mmpNJ/2FAMM
	qrmOJp+2Y/NFxgmpYSlTkLooIvny9Fo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hltjOnY5Whm9I1nd8fAMuLGdKpu/CLptiPwgEp80WqoQr1Wmu8Ni4hNH4gY83q9zJctnsFESPL9v8Kqzk5mBbVjUzcwNDOCpJIRv71y9C+ncBJZX7WHvvNG2kswEN1/YngMocy0gkl326Iu6nBK7Vr/DftK5DMWHgfXIkyCKklTOOgG9EILW7NwdEY+N74HaTHh5YRYI7ysu5kdQcSGRj1yRdUfwR14z9LfbQbvt0+LARfi1KbzVvBkUnSC3Fifqj8mfuDLcHJTIaM06wGaRg8DZe0NjjjSyaI51V9pNjqCCDmGSEZ/yV3C01M0c590UyTLfi8SHuD5QJvp9uEQRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8U/LY9gREQWRfFkQEOrwQq6h1rS8Y+J6yUK856jDwYs=;
 b=RAyA6pcHPODv5Zg667GvjHkkfGGCkMevmbAflRA8m9ZB0gHln5fESkjQSI8C9gHla0XnhcozodVAIO5UB6YBq1anjaAK/xDsAu6+Ns+F4yV8WWIbL5CmI5yUX/QDxw5T1C4xEkiYnUeIFiDqwlfcrjX3NgazaibDzMHK6VCKFI0/wmQa89oj2LAnSwQjNxVnvTRSqKaL2ZcWMB2bx72AaTt0EHs/2zSoQmpYLdYa0M7jXEksDuCgRr8HtBhc7SuE9ePdCtXAt93U2BNi3q3Cx1hdzhl1z9ByFQCte63DlUfvz7P8Zdv2eE4zVmXAfwImbscc8OMVHvHFk4dZxUsviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8U/LY9gREQWRfFkQEOrwQq6h1rS8Y+J6yUK856jDwYs=;
 b=gEZQDRQJT9ZTA0HxzL+86CRlXWePlWnXvTFzjNDBd4ieB0XQp42NDATHQFRbaTRdD6D6afZtgOqlLE+qb99WKn2Vn7d3KaRJGQJqvth4USkBYx1ix9bdvhhLC/oLCcq8WfZOMcz3p8co7zUJ2T44v1AcbFiBegTlth6c1l8+eRo=
Received: from BN9PR03CA0709.namprd03.prod.outlook.com (2603:10b6:408:ef::24)
 by SN7PR12MB7252.namprd12.prod.outlook.com (2603:10b6:806:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 06:15:24 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:408:ef:cafe::27) by BN9PR03CA0709.outlook.office365.com
 (2603:10b6:408:ef::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 06:15:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Wed, 6 May 2026 06:15:24 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 6 May
 2026 01:15:24 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 May
 2026 01:15:24 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 6 May 2026 01:15:17 -0500
Message-ID: <8b515b2b-e37c-47a5-86f7-da4f3c644c60@amd.com>
Date: Wed, 6 May 2026 11:45:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/7] mm: migrate: Add promote_misplaced_memcg_folios()
To: Donet Tom <donettom@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <20260504060924.344313-3-bharata@amd.com>
 <2fd0aca2-4be3-4cab-aee4-b513ba67103e@linux.ibm.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <2fd0aca2-4be3-4cab-aee4-b513ba67103e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|SN7PR12MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e861b1-92ba-4b03-57e6-08deab36dc54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gVApPl904JpW3/l6zbYrLOWJrxUen5rD3AUCVEFc+TgGz2ICiG0A8T69nlhPin8+UbBPyzEzaHvo/ssnIOILTDxubocRUlY3qUZT8s5BHCpnZbqDdYCTrPh2xUwIU1h+gzL89XqNaZZcT1rbx1mrrBy/liipQrlhgiFHh9J8DdIiCEoMGMTWWZuKBu3VY4tXPOxQVeXuBt/4jxcxuTlV4caU4s2xNXFklR6NUWKAM6WhRbI0TM+siFo9CcA1X8aFa/WWCf3gsUUFFGok+OWmi2aM0h1sdEOU1JcEBclgyCeI0NUs/fdWQ+fWh3m9e4MJXNekhzxSGSvmb4Ax8D/3AMkvcZe7VfSKN79RZ2QOPDeDji8oF4JzUF7cbyjtXbbpeLic8GOyydpCLWao4PIhRsqmGW91wldZnU/VXxnVHwz+eHU2H5/hz6oT3cImAukuApT5U4jbdL4QtQQ7vT2fkvf9iqsqIv4McWfndwfZelXpq2gz10/6MMOD4HrlULU7iH9E++famm7DwG7AayAv28j9sJWmkd8b4VTEzgsT+OCf8a7MsG1eiPewV3da32sa9AyQyMq9pdN01ISvRn1YFYALV0RBKIE4oseT5vVvXiUWDvAHA7SoqIZBtDYGwc3YNl+jNwSD8uwdBlO/jMZU/crhwytxwdNgJXOSHkjwHQtafmFuvfgP39wjPyo7KwlBLUEKahvGicPwedJ3J92byZtBrH4xwg4HcSwcSiEX45E=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X9vPRN10tetIo7Cs8aBLWdkKbrIe3ZpYH5nwwnb83Ki15+M0fQcNl1g/qRvEOYe7U21l9PGqhQpD3+xFs3mCXxtV03SOqmTV+ube1Oaa2eFsSATITyjRyqyDnUfsCWB1hdV0Gy82PR4Eb+b7F3bfDHB/W56W46SCXahlzb5fxG8L9lk0I3bqWz+v1IF0TB1wS92AamdvyirQ2POSLiGN4wb4hZdy7WDjY54fXZpxImP+zJ5NgFXLzDDaPOM47xD4eaNRhWOZQ5oi+Q8UDblnd5Ax/fcLJLz/6nHzz/DphKdM4QcT9ZrsUeCI840obJxYMmh1Cn8f/mSy2EGXmpv30BpUIyQ9yESHyYm3LNDrcxIGshI0ytd/dQj6sTwJe7dpXHBW3LtdLTRa59y5pY520iYtZ2hLcsMjeZIbmHC5y2keP1un9Y0D0vpPRK1M5Kc8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 06:15:24.5905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e861b1-92ba-4b03-57e6-08deab36dc54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7252
X-Stat-Signature: sfj1hqcz6kfinxpbqjr3sq8d763c71yo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C50EA40005
X-Rspam-User: 
X-HE-Tag: 1778048130-856132
X-HE-Meta: U2FsdGVkX1+SR6cV4SunXhP5VK2C6yZCHJRhWZq8GPRIWA5Nb0lLJwgKiuEqsKdbzU1AjVZDQHzuVG3Xc02WlmuBCgreGAwtmbkFqrCigMPmvMSijgtF+cpARw7DbesfpXmkMjQdLsXZJXFvp4kjx3HDnIP5hmk1Sf/X5yC01f75RIBOed0XS4SPWxLDQG4FyBlm3ewayVKFog4pxdIq1Z0NA6PuUPfqES5v/NZ5nve4VpNAJN6UM1noJSoHFa3U0PR//a8B+s7KvB4FKZ+GZH0+2uaHheJzcHcYi5mEE7NRkDUDxo2q72si3dPXXW9QC+ota+1fjTWMdx+I8luikGqMfHh2fv7idtGbwqgNYLI7A3dnLRzHpgTeVauhA8PqBtNzEFUjrWi/ZWeL6IlC3Zru6X70SuamXbWLdZIrK63yrBt8avi7PCoDrm4BO6hC2fmW9vlqeItCGCIoPsLetjWgH7hNoxOKPSeCBSZwqHoDhUvs2wPQgJeTp03ngoDkMJ/FDXHJ8OCB1PS9uxfzWdbnhl7aQF70iTY6SQeRyp8a8U7klUkE148RX4GSzWoM3XbabkONBJfna1YgY++3TSZxyJ+u5VdUJUp9YkXi4IQeQ8q/Zw1te+iOrJJROFtUXKhramBJaK3VKQYxAOdVr180w7+DME6omF5SNI6VvEYbhHBvRN+fPwna79n6XzHGUBO/jsjNNFsNn4F4o9CxgkT099G7D60oqpjw1k1bEn5WvXpE5AaW02Hcj/VEfx9x68Td1qf4n8k5aTPmCcoL+f4cFlk/Sb+LjawvSOfFyVi7gM2SD6YwfKRCYY6fcYd7Kj1lIoUbbyrgAg2eYQ98sLpT79gISbcyhFTJAO4bcG7/mzW/yXyTLBO9E/3yaGaeIb9AVXFG8i8aECcLC7dt3hkmFGvl+oEAx1/JwZ3wXgwD68GDYrZPIxZ0UlkRwJzwDWsYO4S+He97mAHFm/+
 Hg08Hf5W
 tj8GeqLJeNdU/nu+5EFKrJ94ZNdYC1MgMXjNorxexb8qItO+eolWNouBB4eYfh1cHJobNix7ek+WQjgaxUUKqR0+ld6pB39PZvNhxEClxwgwgCO4HpQPJXsMUyXIAhsL9BCOHznsOKS6dtwYqc3LX/tqEwDWnTZh4JXPgQJ2oKnRwZ5gu9VgDMz31yyx2AM1++nbxA76tDO3b3vJ73hZ2MTTtaRtdLS5L5diNI/ZPv99x1IsHsOkt8EPdzNmpa4Pgf9u1AXSk5+lPH7t28WSDzKNhjul3omUUyPSVHOKigVMItSlG7hQI43yid6VouetS/N+iZOw5COVmz44qilXbwQS/DRfJ17kQXolmZfO9MdLGUiB0AQUq2bL6wLVr6dyy1daKlm3X5AQzDUfSqMzWaCaUtZsPaGG/4gJl/yxFdD1go7SQlVWmOyeqsHByOp90DAg4As3txA6CVdD+SGQL16IU0KxdgA+DSRUnpx8lVR4y56SjfG9VVFIpT1DkiolW9FLQG3aooHjtfkN+zgWqzXMmj5kdZ/Gr9HgGA6Bk4uyrSxkPVEfyQjzlsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-May-26 11:44 PM, Donet Tom wrote:
> Hi Bharata
> 
> On 5/4/26 11:39 AM, Bharata B Rao wrote:
>> +int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
>> +{
>> +    struct mem_cgroup *memcg = NULL;
>> +    unsigned int nr_succeeded = 0;
>> +    struct folio *first;
>> +    int nr_remaining;
>> +
>> +    if (list_empty(folio_list))
>> +        return 0;
>> +
>> +    first = list_first_entry(folio_list, struct folio, lru);
>> +#ifdef CONFIG_DEBUG_VM
>> +    {
>> +        struct folio *f;
>> +        list_for_each_entry(f, folio_list, lru)
>> +        VM_WARN_ON_ONCE(folio_memcg(f) != folio_memcg(first));
> 
> 
> It looks like the indentation might be off here.

Yeah looks like. Will fix.

Regards,
Bharata.

