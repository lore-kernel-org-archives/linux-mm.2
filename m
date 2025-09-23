Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534F0CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7378E0013; Tue, 23 Sep 2025 13:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77378E0001; Tue, 23 Sep 2025 13:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F448E0013; Tue, 23 Sep 2025 13:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593068E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC26BA235
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:53 +0000 (UTC)
X-FDA: 83921253066.26.8AF2805
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 34231C000E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mlSWpLYC;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zro2hd4Ble5cJHXwetB3OFEMfa0I21dYEBYdyGm1024=;
	b=hcFp5/8nRTVCbc0usZ+dFksz6085mhCZkiF71CvreBCf7bTSN9ATs7zCKUZuJhnzFyUTJC
	fqMcdSNlPg5cUyiSP5T/g0KUAXEwofAatHTzt+SMrgjqpkvjobz9CRHkzq2ropfDihmQWO
	qcTiJ/xtJKY+87+AJl08yRHO8duKaxY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mlSWpLYC;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649790; a=rsa-sha256;
	cv=pass;
	b=xJTO/XIKjbRgxJ/hW2o1l/Q/pvvvpinpPNltGehF0oGkaffMHAWOldA/Bav8jnTG6xu0Rs
	AJ7fAPdHTFYJ9uD/miH2HWXQ7t2byPP0c/tnlVlK7x6gOni6k1kNWibld7wI5ZiSbEPZOD
	lj4Q60XW2Poi+OEQ0B8bbLe5iwlkRtc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UuTuv+O0dCY9+hQ1qWkAG6Elze9adBWSDRNIbVaJqIFvJogBIvMmXAwpOShWO/IDUz9VkdTETriBLovD3kvaB2kj7+0XcMpFne/DyQ6CRdAXYUWIEXOJBQxQR1xQ7pWJ9BitnvSBo+QrTt1CKfyWDZ4Xd2ThKi7rlO6e8eJmgDZA3NYnhJ8MPTcqCuBvxoDFqkUm7vYDwsIIwO5iyh4k60whmSsdwbFqArwLtld6iCXR+nzzNlaQFaM7uC32rChGahV6xoq6H/vHQmqfkPWZ0P+Dl/NnffHD8Gj5oXavxKTGy0aPnoAQUKL33LT+IIUgoGbeXCW/eUEWSLnBBREW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zro2hd4Ble5cJHXwetB3OFEMfa0I21dYEBYdyGm1024=;
 b=p6qPaRJriL4Or6GIXTAERJeox2aMC/V6lNsBkCDU2B+mcb+xlmCrK0S6+8yaiGmw2TziCwTrUr5bGbNfK54YW8nOOQj/MKRP2B6dVUamk+b1lHVWIAsMjpVzK5ck0jyQIg4EtbzJW6MfLBW816Gw9p+x+FhQIjLoJc5HnVN8TUDcSCfNpXK1MFF5KX5U3oenvhemIc+xvGi4vnAbO0bgwEaAk/rrPFA3vaY79ITeBH119F2P0fiJfDMVKPbbIq/SiFkx6TO/WyhnTHKYhKUL8TXAMPh5hnHX/ixN7O+78kvtNyL27udpxk5i2TIp/gSfkW6e5c6BuSMDxFYsoVrFaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zro2hd4Ble5cJHXwetB3OFEMfa0I21dYEBYdyGm1024=;
 b=mlSWpLYCdutoKhwJK50QHmMdUIKl+xwBsGJOl+73GIbU34b10+kogIGn5wokiMGWJs0zlMb1A8x5dVajVrFOEcQrlo4IPkhhh8JHv0DlNaoGMiz55GnJ0ZzsXr63evZ7Ol//GuXukZGHIwnUYK9K9EnC4Ah+YTGhb/u471Q9SXQ=
Received: from BL1PR13CA0246.namprd13.prod.outlook.com (2603:10b6:208:2ba::11)
 by SA5PPF5D41D38AD.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Tue, 23 Sep
 2025 17:49:46 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::a3) by BL1PR13CA0246.outlook.office365.com
 (2603:10b6:208:2ba::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 17:49:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 17:49:46 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 10:49:31 -0700
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>
CC: <ziy@nvidia.com>, <willy@infradead.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC V3 8/9] adjust NR_MAX_BATCHED_MIGRATION for testing
Date: Tue, 23 Sep 2025 17:47:43 +0000
Message-ID: <20250923174752.35701-9-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|SA5PPF5D41D38AD:EE_
X-MS-Office365-Filtering-Correlation-Id: cdba7694-7d0c-4780-18ac-08ddfac995e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QsYamSeARRtEJf8M93bgYAEskzEFS/5tCh3TQu6I11uQB4hKJfzm6FaecIHd?=
 =?us-ascii?Q?DQtPX90U4zhrvV9r31QHgaz3n/flYiRU0LsNgnvB4RgCN4VNM+x6OgyqMfnP?=
 =?us-ascii?Q?bKo9zgWdFoqwTCmZ9gg/+8rJzawL5iMk/cZ4/2iIHWhrb9Fa/pGMqvFX2/xu?=
 =?us-ascii?Q?f5VDPo1G3l0dhExa1aFHfPpvWuDPBTlCpg3Tca4m/m1YC8cyU6gz7NqGECEz?=
 =?us-ascii?Q?sJXfY3hAKO+0jZ6Q3BQEaOMi25C244VJ8NJWJ+DxKZfndTJHvwBuKbt5WMkv?=
 =?us-ascii?Q?ETWve7QlAW/Vdxqv8KaQdz6RyrOnS7hRdEwzHcz1j9E7/a+98qSNXS+RcEnL?=
 =?us-ascii?Q?jPtDtDE73X/dPB+ha8/ZjDzEQo71+SNyey1tt04xJHKe3OWInPWAB5o12wHG?=
 =?us-ascii?Q?UTVkqf1ZlyEYQPDR2oCcMIQj7A11v45DmEdJWzgl9T0Vg0ECl+DqRqKIudVi?=
 =?us-ascii?Q?GnfxWXR78SnEjvQG+67wgB7ykqQi4YAxufAa7AZ4WHowtFuy15hohJPBS3/S?=
 =?us-ascii?Q?lmzOQNJsa41bwKHzV7BdG9CrPmZGWzGBcC3Fce1yoUYqf5W5nzMpLs6GFYnf?=
 =?us-ascii?Q?4lqWAn7HHVynpFRzCYJCWeDK3YfgYg/kwnDQusUGYhAMaJDoj/59atMfe6Lx?=
 =?us-ascii?Q?JdnMUgW1GOz4NFofRteLlYLXgdQn03Cia7I3XKGa1hOhzeL5l14rvXSz+OTA?=
 =?us-ascii?Q?FSHOPuo1/Ut3iLgfOBYoNN++f4+LFn5mv/CppK8nB9jhpJduBqFBFhEx5Pup?=
 =?us-ascii?Q?axC2mL6a+jbMQQKHlP77Vhj69lxTuBPuL4uF2VBOBq/Zcs+6ATuUDczezKsk?=
 =?us-ascii?Q?y1TpDWMIcyj0Dk5OrKiv/9SHvXoyw/Jj625pZw9GxzUhQn4cAi6HEYgnv5ck?=
 =?us-ascii?Q?Bq+Q4XG63TFNdTz9jpneFYwGVAOmWH1Of1ypoaXc+rqpHolAgMkA1QesRHvf?=
 =?us-ascii?Q?cj70MdJ+EWN7LhNgtNRwZKwb4s9kGhxZEKq+fKXUvlvXzdETvIcYbSeJwJrY?=
 =?us-ascii?Q?JuYboA51o92mICal9RFyKXWunXOWUfmAhQDXr1z+i1LLANHsodztsYGdPv4X?=
 =?us-ascii?Q?27pJM+a35mj5Z/vlNR17JJeLaIht4RE5eIstthFmmFI+LiPTzwu8qKpWv2f8?=
 =?us-ascii?Q?4cq0hOdmi8jjwRSVKcREkakOrcfPxuS/gUcS5//vXU9aRHNKGS8eMAfEn+gT?=
 =?us-ascii?Q?NNAKkVtuO1MQNBhPynanSKHVbmctKhsopzImuwTitKg6J/oH+DR6IjEjHQpf?=
 =?us-ascii?Q?Bd6YXzMYYVf3nZp3gS6xqM/OyFVUjuIG61L4WBwNrjX0bEVYBtOnvX7qrxxq?=
 =?us-ascii?Q?MMIWvBITkswD6wBZBGkysTkQ0hqdtfmhERg1Wl2/vsj1E/oVa/RxCx9UHuTL?=
 =?us-ascii?Q?VwrN9wPYHs0R9VUU4dp4H6hp8mCjcetbe8vjaDRm8PYZbHsR+vfyh9i38bOU?=
 =?us-ascii?Q?5RzZPbArKjw/PtEcxXVeGKdPT2JGXbGoV7gZJcXEbyZlDp1PAhOdvskd5h8K?=
 =?us-ascii?Q?cMSwIHLzgxSWA2weQQ4qZVSeRPIF9Rpii6ob?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:49:46.5981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdba7694-7d0c-4780-18ac-08ddfac995e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF5D41D38AD
X-Rspamd-Queue-Id: 34231C000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: chxbtaaqxpo7kikpc61btjeieert973e
X-HE-Tag: 1758649789-929470
X-HE-Meta: U2FsdGVkX18upoSU6bWrbfoDmAIp3eUmHZKS3N/yxY0dXpxqAd3y3Vz2DSjqAwwrV3go6pnwD3AvOMHStvP6Wj02gr+FcU1CvLjZy4yiwZ4pagYJ9e5dyoMElTejDqpkbH8NI9u93y1rs84Qt4fP5+kRk1aYoiYjO5euyA3DPxGZmfD9E5LViBS+pNtVM1uE5y8cL4WyiPOdd2oaYTacjOVjFawGpM2K1FFowttFfdsw5kqb9rFEs2lvkV9MdYPZ2EYA66LMrHF1PW//95TMobRTghre+Tbcxurtw3tW78dCvflMApxO6PdkhkHJO+htT//25Bbb9rkQ8KbszqGb+KHIkXS00k/3ldSNN9i36EF77tdMK57OsEpGvT+BJmg4A5I1XZCeJkkiWX1we3ePnTVNL1Sw99bxohXvv/RnP5Wb5xe5/PL/uTl4PnGPMdCYSWQZSCiGjFrfDkcGRtzXik0wh+wbfEwhU8yBTIze75DM2bnPb5P0YptYn/OXmQAKQ5MaHZIN+Mm68ACkmlF9DChW8i/RQSJ3GeZF1lZqk+Z1B0oDDUzSqd/wxH9BSxYjvyn8nCZCSyVFWJI4a9rg3EpVOkUSCAeDt6u/XKNAHOIQ1t3q49QP/bJXxmE/kam56e6Wm0oZF3sfp3SDHX3GZi0dshaqRHoCMGBg0xSsUJaY7p41SItgo++pf78mmFLxOzxhSYxHtQ9/+F4AGf4ouVBqcOP8ThTBcpLOrAHdt+5pdIk5eu9ZO7s/CeY51oeY/W+YwnrO6qk4HM+P+MkkdU0IaPEWMphtd//3KaCjOljGkc4fKO3FqOhtXE6Hls2upsW2s8yJM+9zbsllJ9+z+ecKwmfsbIno1NoURXpuR0A89rdceeX7V4ESK5gp79yDzqBgcAAjDs+kBnwzQLAO3V92sQjBDQGKd76gh/W64Xfz4Y6YSqhWEkK/Pf5d0PUQ8dLruIV9ASwGK8QChUq
 M+i2cfXD
 WqZXCEQgLtX/rCev+qXZXZ7floSHna+kaLvVKpoX0vGgphoXkPIcjVHOgZWiy6h+kss0WA/PM81URF8bTDimK6X/KIR+tjAoL41axUS1tlH6zTa6wIdo1cvaWJeSVT6H7W1JRs4CZQex9bFHGfrD2QRztrHte73QLR71QqY5QaLl8IfNkErcFKMCR3Aq+LiWO2Uf/hYAVIMmLEm1s0HSSQatrbY3nVdlVugXzeeO/vH7ku8/hzxksSkiV9WSQ49mnB1imnhb9V1d5SmMXGUbzpHvmMnRFMqf2M5WTU/4Mw9ZL6x7pjlJmb8uN1GAEpVzeFRyp63KcuqM+QrErHv+AnU0gLsW0NEJfLyfPlVne8Ajke3fGDakDuHYPvoYBk4skcKFex6JiMzh1aVvvxiZs7fkSMIuvneYNl15ZIJ5AhBths29fX+0vDl6+8aTxNH4IPYe5fhNfNp0f4XWCWyldanFr9CHSYvHPt6Hf8M/EJ2sG8v1ow47XGFBJE/qr8ZjfEFXg32ad9wKIDJysB3HFMBkbQ26/JJZdsxSmrMOUfj/pCAhAxBc2JCJHb2bMwTkvzlZf1DTXvH3DneX6bjDg+l+w2j3uFBfG+TWiRwAQ+VJ26wkJHHU+Ww1DyZEVpkTYGzlLTkBfSk+Xsh7kEJNfH84iCSwOwUP/8tW0mHFNI9WpzFgtaSJuX8mGUN+rxR3I4CRveisqPs1wod+pZLRexVTBKJFDUlOkgXlHMnA8iFgYDcxkDKbyMdejWsa9enEQsAtZItcHTnsQawA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

change NR_MAX_BATCHED_MIGRATION to HPAGE_PUD_NR to allow batching THP
copies.

These are for testing purpose only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 41bea48d823c..7f50813d87e4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1668,7 +1668,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PUD_NR
 #else
 #define NR_MAX_BATCHED_MIGRATION	512
 #endif
-- 
2.43.0


