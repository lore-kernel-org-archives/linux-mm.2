Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3919FCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFF16B00B1; Thu, 21 Aug 2025 11:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6960B6B00B3; Thu, 21 Aug 2025 11:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584606B00B4; Thu, 21 Aug 2025 11:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 442A16B00B1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:25:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4D89136DA8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:24:59 +0000 (UTC)
X-FDA: 83801137518.19.B0B184E
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1FCC4000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:24:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=arZNgstq;
	spf=pass (imf07.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.102.60 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755789897; a=rsa-sha256;
	cv=pass;
	b=Lau6AGD/wSY0bVFxsl47yBBuI5lbfacvvGAj3ljuPyiZwp4/dL0tOqHHjfCQNqP6IYax9j
	8Ny7ho27IkbYjy31fLLcKezICS5NL8MY2GPiVaMY/ZTPBFXeQu5cpWr0iuA435M1FDoFMr
	TQ2V7F1hSqMKFM/Oz3Cc4WyRHZOkDL0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=arZNgstq;
	spf=pass (imf07.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.102.60 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755789897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRQyD8s572zAl9nNsQBha/CgSlFdHU1P1iWMmgEsTNk=;
	b=AVMnXX7qA4/cRHOWNSu5plAK4Of5VUp6fmMJnKX+h/kpujSFcC+jbrga7B9pSOQdLt78L1
	VCiFGygXWyfHWFBNS9RWyO0vfS2kjbUEVV9oXjdKo7vUE5Ro7L3Ir3+/iycgC9j2DoWni0
	jSfG6HlhFjT+x6HQ2TlZgYsfiK7Fv8c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXjRr1zQKxMEhhYQO+qT5TUJaVsTT72u0t/f5n/e3JNp/EFa1thf4iaqsHwlkNgo8mcoHpUI+WB4M5dTUTUzczKplR3wOkzU6M6mlTfbs4bRde5Fadev3EB3+4F2CQSd/Mv7Gp3mxDC6orN+jk+1mykksIAMBhF/EoMNqN/lut6QKzdO0OFBUJwcjOu7EqWPB1rjaNLr53eNF75ZBZ8aTzMFUSYGZ/7VI3vvsnvRGWJknmgEYRi8WjyBU0xAb96U9UdEDG5rEmDE9HR2B3chh6SkDJywO7qYiNO2Iy5ivHfSB+R+obCMOCEcSWOUUAeFyG7O98/5nqKlA8Rg+KuvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRQyD8s572zAl9nNsQBha/CgSlFdHU1P1iWMmgEsTNk=;
 b=SxR5N1STX+qjyWUaDG9zMQpRA5RHUH2x7uEEqLMDGaqQLwA7+PjNc2lEJZC12ed1ZkgHSccjb2IRNQMMr0RtOi8yGUvaS5t5hdTQzS9fktLIjbTIau7WdvDrx+JxeHX2FlkxGcTVI/TzMijKnC1d7jq1jGSHZcmiT6uwigyXc7FF6eull98DTFbPuKdCEZbrxYZvySAWFKuyoBcxbATD5Z1XOrWHi1zvk6GOqqHZDrcyuLcMb/e0yhJSIcMycvsOfzJGgrsOVcYVn/OuoKGO10ui2+G5q71qvMWulLLQhgCk3h6piEbVAUweww/gVOdCeOkcnKjNXQ2j2QPuS2AmZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRQyD8s572zAl9nNsQBha/CgSlFdHU1P1iWMmgEsTNk=;
 b=arZNgstq4Xjz5eyRwMTqMc2aLvchkOpmaElhmrL4ThAyNXh6h6A5d5mAl8/BAspn3wWWSW9GGQssYnCOf/QjL1fISzJrMx+UrMEkiuceCuXhK5r8bo8mhXsJh7M/WLBSuGSX2H6jxTEVl03q5Xt5vF/g7sMacvm0Bzc0kfnSQV8=
Received: from SJ0PR03CA0088.namprd03.prod.outlook.com (2603:10b6:a03:331::33)
 by MW4PR12MB6732.namprd12.prod.outlook.com (2603:10b6:303:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Thu, 21 Aug
 2025 15:24:50 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::f6) by SJ0PR03CA0088.outlook.office365.com
 (2603:10b6:a03:331::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.16 via Frontend Transport; Thu,
 21 Aug 2025 15:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 21 Aug 2025 15:24:50 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 21 Aug
 2025 10:24:38 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Jonathan.Cameron@huawei.com>,
	<Michael.Day@amd.com>, <akpm@linux-foundation.org>, <bharata@amd.com>,
	<dave.hansen@intel.com>, <dave@stgolabs.net>, <david@redhat.com>,
	<dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>, <gourry@gourry.net>,
	<hannes@cmpxchg.org>, <harry.yoo@oracle.com>, <hdanton@sina.com>,
	<honggyu.kim@sk.com>, <hughd@google.com>, <jhubbard@nvidia.com>,
	<jon.grimm@amd.com>, <k.shutemov@gmail.com>, <kbusch@meta.com>,
	<kinseyho@google.com>, <kmanaouil.dev@gmail.com>, <leesuyeon0506@gmail.com>,
	<leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<yuanchu@google.com>, <ziy@nvidia.com>
Subject: [RFC PATCH V3 00/17] mm: slowtier page promotion based on PTE A bit
Date: Thu, 21 Aug 2025 15:24:25 +0000
Message-ID: <20250821152425.1600861-1-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|MW4PR12MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e0f62d-08ca-404a-cd47-08dde0c6df0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PBLJY8Xf31x7OGTrFMmmhdxX+uIeC/Ho6IRU+cy8hi2OUshY6NdDA4daNwhK?=
 =?us-ascii?Q?v4m+eZSHutV3VnKC2FDwk/HtrJVuoPQohKbSGQIquZ26pqvpTI/n9BRYVFUK?=
 =?us-ascii?Q?H2Mpp10/JmIB/ywlffhkzanu7DhgAaoaImypicUatbHRcHCRbkV6ZfjAulPa?=
 =?us-ascii?Q?W0sc+u3j8++3Oz1m0XrjM0Nf2koiLgj0scvRMoruBQwU89XQr9EytxJfyjSn?=
 =?us-ascii?Q?3xi07X6+8ImUoORMeK41RvnR7v1uKRbLkCr/bd/8TRIExTYh5sy32XT0Awvi?=
 =?us-ascii?Q?T75lAxCcMS6u2WX/Ys6ZKKXAZ2PPNyIsNJz9R4PZNsm/1BEY5bOgo5KS5L6m?=
 =?us-ascii?Q?BCAweIlaggpsYKI/ssUKg4ySjgGW93xEGMT5kfxgqyCFN1pyQFBKUz1QFDjQ?=
 =?us-ascii?Q?5RWRHsysV3QzbdtGP8B3azE4X3e/bSf0I977NiGqiabzzoylljHwpNm4hC9w?=
 =?us-ascii?Q?dGiRToz0nhUFzilRDsf8370cdhIUvOdio/rvAvDBzdIgoBo2LutfyO79CEd4?=
 =?us-ascii?Q?6OnW7TydLUf0L8w6GaYOG9HIRWQ2UqNaiANf5tfOQW+K82UZP+ThHyCfjYgO?=
 =?us-ascii?Q?12AKwIArhXcMPs0cAM/gjvaciARQ/SL8YVqTRvzaLRuCAvQcddMwKD7zPQ6J?=
 =?us-ascii?Q?BuTcjcPjuxyOEm07t6bzAGli5NaObBEKe6vbmWu+aJgEPvrtUsRECBaPkdyt?=
 =?us-ascii?Q?CmoyFBiCP2PhMefX+q6OJ2h6TQ6wCPXJTcok9tVKaL3cB1rr36qRisxdKuHR?=
 =?us-ascii?Q?f4HgNb+pljWUabR3HJn3k6fyN/Mb7aqSRHHM9FP1Fd++ba/mzjf6347UC1TT?=
 =?us-ascii?Q?hmql1KqCLbMD22/6MXMQXIM0mJn9yIsKMAL9oucvLadNKjukAAlfe1imOXOE?=
 =?us-ascii?Q?WV6MqSFOa+yU6snahzd2bXWyzCjWuw/IXnHHqMQqShLvLk9KeKD022Gh7xNR?=
 =?us-ascii?Q?AvyQoUpeJBULAOQsdPJqtSuOWtk1E/QQ+7HaZXfb6xivZjwnqOBILK2UR8an?=
 =?us-ascii?Q?vWyCRMRLfviTXgC0oN45vMOiroyEI6NgwuuHZjZzhIYvUEpvqL5z3BQiMDXP?=
 =?us-ascii?Q?9V/txfl8jZ8AgbjgPpAtizWhm4p+hkE7O8gGnhTLiSZR0fKY+RUq7Jk5o1yE?=
 =?us-ascii?Q?2i+6GNhcx+lSsw2Vi3d4EgzW+zc55uYunhmgSMhAQbvGeWUyFCoTzJKcfvyN?=
 =?us-ascii?Q?96XCw7FRL6y/8IpO4X7C9lxiIyRZh/5TUlfT/6lz7qn8BazZdBPPyyiNx1RC?=
 =?us-ascii?Q?ZYPFI+CoCFyLVBlqPSu/XBuj7As81VOOXMa9weu7IOE9b4Zn0o/ayuW78U0m?=
 =?us-ascii?Q?RC5ukJZ47+mimE88TODykL/FBwYamcZYVPiNMMF5heJYXVeFOcoFb7Imx16B?=
 =?us-ascii?Q?dhyIhUK64zhRBPyv2/jGgv3xrLBoEhwsFppKVlfZ0O1fxRx7UCxdzmALopqe?=
 =?us-ascii?Q?haB9HSJbUN/HBU5rN1whHa0SWRT4gzpnsBQs/hWfhbfMhUf3BYWOJLXjU5HV?=
 =?us-ascii?Q?uadAc9JZsXjCD4SfVeW7IVOpvz9C3DMGe6o4b7VVUsijvisR4ZYIoEjC5A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:24:50.5365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e0f62d-08ca-404a-cd47-08dde0c6df0b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6732
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1FCC4000F
X-Stat-Signature: edf7yrb4js3t5rguazikm6erfjkr11oe
X-Rspam-User: 
X-HE-Tag: 1755789896-397019
X-HE-Meta: U2FsdGVkX1/XHJqr/J9+m5OfiJdvK9up1URJ4EzDIVH8RyGzp6OGOcfEDO57BoLzijWfNA4k2upLlqL1Z5mApr1SlDPK1WKPJhx9JajLkml5lEdrWfqlgqhKeWURZkRhCi9I+4evItxtxMiKepIGaABgleHkDgj48ArLsHV9PWXIbaOZjsCJKICVsShfQZsRZVSOKmlDr4No8u232KTJfjLvIKxTjWRBTDO9Q7alUuWKIOVwJRscU6ir5ndTUl0T0TRnkNLVg77B3NChk8dPeS1nCqnODJqKtx0UZ1xPQUDR3hzdY67aQP5g1SwXNqBRR3AYy2LyQuAzusPNEfHNpho3XFjrxyp0/oe9XaJA4cJK8cwN+5w1XuVO4HRzvnzt3O099u89HIUSJ8AN3UY2iTUvkDRiZlB2OkvSJpnK8yuAoI2JSGVytFrFppUMfO+yk2JGegskXF8W2sAamI11eJ53yC3l8azy0B5Qnp/YFCfumRH1J6wAgx8GncOjbqXTMjZPKNHq/+DRDM13TzcEocyqFFkXIPnnUNvB83sA68X4FsZG72T5M4FnAh4dfzkLmHzaqMIfKL7TC2e+e3rolk6XFvBAjx9wcH61PwWe+INVRvVpwDcKXsJC8I3WfQJVN10CHTa0h7UZyhnIe7ApvcmlKfNp65iRsdEKsFJXjbFLIAc9LMKL+ihvBUbvYmw5m90MOTYbvBxl6N4RsMB9SxIji4kQ2MBC3Ye5PJ00TMZ3VrR/WeKqzpm2ha3UQXZEqOkbH/ggB6uMGYlu+N3ahN49Mb+4PaDnOkhep/b5CD434Twa2S4MzWpuxP4RTNNdTxmOmatZPkWn9ahjquss1+PYm650PKgE+keYHk98uwDZIgzJICTNIsPI+wuj4Lo3PWknpcuzNcqjQFn3InvIwyfI4ROKQVB4mjJwPPf6WrsggQg7Xx93TYTEO+lcCWjmN9urIvXvzW0paS0drYj
 DRVasiXq
 XQycdtUbWLmyIb1P6OlSPk8+78dClW5yq5lsI2DY+nuhPI0eQWtZkxJjVnwURIqNbNqIiqQFOzvqW5cabsad8Dek0BvqZRh1YzFOd9rCtGwjX7/QdTDxmt/xbMT5X8qUej0Hf/lSjTucWDc36Javp+AoxYJX1q6b6tNTOyl7NIbUIFduAuypUqtsOpuR0eh19T/3vefcfoCQfnyhOFejYyNZZwIPhJOMdK7F9tfPlX4B1JXLz1qfPnXqXX9gF3lfFsqTpgPmxiSPcns9THO5qBy5lw5xk+9G2aRH183ekjxlx+GJjo4i/77lhmemIfOwkc1ngB70pODvjE8lZauPkIhMaWSI8XMl8BYnQgXe0HiBvDXMN54b5oSgXwitqYx+81zEX8O9zpzeJUkyzuS388+/wyUoEt6/d7fKiKshVV6UgEwMW5OlSKEa5pmqHj8iuujNl549kNLf2Palk2n8aiYqR8KaFBb34lfjA4v0JRxEzi6xXIrQaIM7emCyKB0jU+aM6dQ6uowpcAv5OTJUuKoR+aGc30Gc7Pk9GBqq+P4RZxUIlkdlI1VdhrccIWRdREN+o8+kBBlTGWUXZHdmtAC1Rxr2yr5Ijdkn6oSWJrOALTS940iqhEaD2tOKmEmVeJE65rXB2cfQQzZw0Rs7krqMSjuLdBTbETatkfowuc3rAHRd6nFYNakwbFYo1/Q44J/1FvbjSRJTxbO02gnz/pfIj6kAVrWh3toYk8UE4Hgzyjo2qplnT/oe5402Thm6r4rRXbZiMSXOTpsXy/MBnpKz9PW2AdFThNYusPE6dCCQsesBMKhWN8DHqnYKf9hdMLqqpLhd7o5y3zlAAzpZWLu9TV1sVuZk+No81fNLOW7HfpzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/2025 9:02 PM, Raghavendra K T wrote:
> The current series has additional enhancements and comments' incorporation on top of
> RFC V2.
> 
> This is an additional source of hot page generator to NUMAB, IBS [4], KMGLRUD [5].
> 
> Introduction:
> =============
> In the current hot page promotion, all the activities including the
> process address space scanning, NUMA hint fault handling and page
> migration is performed in the process context. i.e., scanning overhead is
> borne by applications.
> 
> This RFC V2 patch series does slow-tier page promotion by using PTE Accessed
> bit scanning. Scanning is done by a global kernel thread which routinely
> scans all the processes' address spaces and checks for accesses by reading
> the PTE A bit.
> 
> A separate migration thread migrates/promotes the pages to the top-tier
> node based on a simple heuristic that uses top-tier scan/access information
> of the mm.
> 
> Additionally based on the feedback, a prctl knob with a scalar value is
> provided to control per task scanning.

Patches are also available in the branch:

https://github.com/AMDESE/linux-mm/tree/rkt/kscand_rfc_v3

[...]

> 
> 
> base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f

