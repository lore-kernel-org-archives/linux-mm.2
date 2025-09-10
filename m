Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8EB4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F948E001C; Wed, 10 Sep 2025 10:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072798E0011; Wed, 10 Sep 2025 10:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BBE8E001C; Wed, 10 Sep 2025 10:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFA168E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:48:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D101BC1F6
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:48:44 +0000 (UTC)
X-FDA: 83873622168.22.4BA698A
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2064.outbound.protection.outlook.com [40.107.212.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8520B140014
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:48:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FHO39PVt;
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 40.107.212.64 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
	b=D9oafslibdU51IWQc3PiorPjZOaMxM4ej07SGUpWL1ieYTUt7BJjeSWkxtXvtaP0IHBJua
	UWX/bIUWVOEUKsvXRhSPBacp57X1ieG1k/zK8ZyzQJvU2F8v1cvEWCcfN0Rw3ihT1J1f6I
	TJRgX75f5WbHcrYeTv4nPC8HPyjDFLw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515721; a=rsa-sha256;
	cv=pass;
	b=eWb49kFi/87t0TWCSUyI/2HChyRCRYRNXHtZduogrFJkxK+63GY/1MvFQZQqO0ZfugQDQv
	4RzmnOrpP0JvbGtB0jdUXzVMDhwH/pgarK6tRjcoAQBB6PeWbO8wxA0PAoIQSFahprvZ4Z
	KvZPHaw/NoDLkVDx5yQjykIv8JL1SjI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FHO39PVt;
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 40.107.212.64 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlzkLV2t2Bdl7uCPh43Vm8Np2ggijuk93gzHeEVpQbhMykxF+0Qvx0LN9WRq1jmlx+WwIoOcz1Ajl9YGjTthjLRZx3uOLUhG1LhhPuFBtdT2gn9gNbg8cyc+3wwBizeNr7Mm5sge/CF5jmn8Ejp0Tp/viqfZG1XRgEE45iy8Mh4bw9pd2uJcoEp6DW0j58UgdmJLH68Sg1qRQZn5jqkvrsctx+CRq+qVXMjr6xifMAYN2EYCI53o9+hlgByC9AjsHGit5IyhNWgngwtQgc1TYJg8WDKL6hLWvJ0yUN9jucj2kuthGA4iX/W0+YCNJ0OPW2StfmcPxhsTwmWSoFGKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
 b=cUX0iKHKSpRa2lS5be40BxDcvdkNFevYRH7DgeYlWfpju8tlC8CWm1lEOF2KeYrS7fXo5yD8WFej9ge+k8TG0e8qhmobqcAntnQ2DBGRoum/NdAAJFVw8NXC9tYdLsF8cmguNiRknnFtUpuVT08rNPfISJePe6D2F5R7SBNUAXImvmr5LtsBD4vb3Ir4eem4q0LU15RxxxCO2+xSqa/zWHiji3MJFKOJWHE2ryLwVqp/9xzB+sP0cuiqlWXmQ0uJ4c2de2+VMuPVHPwX41F2YwxxNO6W/ahFPzGAqGi7V0QniamHnoTTyF1kC66NQCvxk6kDzxhB3Nz5MNCW1Wv1Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
 b=FHO39PVtg1DWEcQmqC9B2WQa8KlSEyTpkQgpFJKfOTTvtOySaSu4NppNKmJErnRaUTHHzHNSylecM+kddea6bHOswU2NSwUMyB/Pl1tib6hGC2y7hYdM/kQu0E9rM89oG6DmbTs7wAgEsRAwAOH5U6cNv1XM6DmFV8su0a+Je/E=
Received: from SJ0PR13CA0040.namprd13.prod.outlook.com (2603:10b6:a03:2c2::15)
 by IA0PPFB67404FBA.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:48:37 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::e1) by SJ0PR13CA0040.outlook.office365.com
 (2603:10b6:a03:2c2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Wed,
 10 Sep 2025 14:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:48:36 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:48:26 -0700
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v2 2/8] migrate: implement migrate_misplaced_folios_batch
Date: Wed, 10 Sep 2025 20:16:47 +0530
Message-ID: <20250910144653.212066-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250910144653.212066-1-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|IA0PPFB67404FBA:EE_
X-MS-Office365-Filtering-Correlation-Id: 1200334c-f067-4492-0bf5-08ddf0791fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WCv6LQ92JNEhVpiQyugrMwPSW22htzC8RhY4ZpzI+gP2+6IAo3LZSPVaYAa6?=
 =?us-ascii?Q?mdRpJf8tM0G8WinBSYL0dudjRlUxzde96F1gTCP2HgXSS0qw3ILnNGePovxt?=
 =?us-ascii?Q?7dO9OUuVMutGjMWkvUXCeYNmCOK0xNL0IeykN1JD9yhm/n19RFJJvNVA2u4w?=
 =?us-ascii?Q?bi8mA6SmIqI6hbHpCYb8riPXujApy8T+FG53PqoTIkTzOquixfXv8mB2OSM0?=
 =?us-ascii?Q?L4eQeDC1NNaPf4HGV8QVNEhuKhgU/RUsjUgWuXJT7nItpKQmDAi3nZn+BmDG?=
 =?us-ascii?Q?PiVGAEuCYIrTYpQxH2umX0IHVcKdjJy5wwzNBc8WK8j4IqyrqK7kJVaBQ9uR?=
 =?us-ascii?Q?0Mh6/bkD4St6xRpvP9GIHivvBVWa1vNicyFqdKakA7yx9Jimlf6aTBCXW3K+?=
 =?us-ascii?Q?ZojX+s7VdT2JAFqkgbHMHjx3BDZn3WVdNsT0z50elcfKxOKDV5Gu0lOiJE/l?=
 =?us-ascii?Q?TJXH5FK15hvRoID0UcR/qyUGRekL4U7QCzEVXEvmyn3y9B/xSBl2RhJPMEXu?=
 =?us-ascii?Q?AKiNcANbKTfDzb/sQjoDRWOyqYC/UOfhk6wRwv5W0mf4ltbugvEyo1Wyyp/n?=
 =?us-ascii?Q?pU7DHXIYB4JvdOowWXLoiqiWZqsinSuDgyqVmIXxPKE4liAMCXv6wb9AhKzz?=
 =?us-ascii?Q?2Ucu9HxwZcmx5ml38GUtBYFXB9TXCf1yAJwXWjWDi2l1aYCoUwKF9JEiv+xa?=
 =?us-ascii?Q?q2W/deSWg1UKzRuch+Eu4dJBB8Q+lYAg5Xw5OJiIjeDlg64j35lWeMahT3AF?=
 =?us-ascii?Q?acYQ/NgORmgHTgY4nYekfbvTfXcbk6N0WDaw8WMfUVhChPairtn3mfZxoZBw?=
 =?us-ascii?Q?2k6KABSnV5I1LUYs3fc2V+KzLWcZ1JD3hNffFy6cjXAWiogfcLTDbi/DJoPV?=
 =?us-ascii?Q?23DZlLeJUI2WcG8gIU7bM8Ij9S/KpukBGnOQS2Jq0kr8YYQRh2bGDBpXGkmi?=
 =?us-ascii?Q?H40vy2xqZNnRPodlJCMC6B9A/NiqRa/V93mYXGcEY9MdMFG86NCjD0ijvq6p?=
 =?us-ascii?Q?ftTQFtmMBWxgJerxRRkqp0AdJqYRNlRS7cqnDx4mH/+Jk554PLU8INwWeJ7G?=
 =?us-ascii?Q?n8uZO2/Il528Xkdze/Gw/bfJacqyYmDNkpeG81UgUcK65htLhiEfkhtFNWVb?=
 =?us-ascii?Q?Du4ErnxjE784MY+KKI4VQkmKATpM7HQ+Ox4F1t7aOrXAr5EPNjtnqgc0yFt4?=
 =?us-ascii?Q?Ws2i3lKhxyrFtNeOy4ql0xVu5kmiku4lwA4mYoIRp+Eei4pybRyRa40kcpH2?=
 =?us-ascii?Q?2htpMuieUXf16BVzHQwdF1ttavuwTnOjSILGBHOA9xig5C1qHujJ9h2NY4eG?=
 =?us-ascii?Q?xmCk7vBp5RkuutpNkNqIgTmUE5e85YoS/tm/bIyLU/9zBQ4Up6r4uSsCfp+V?=
 =?us-ascii?Q?xbuM/ce4feq6Phz4pLLFZXqAhVjdDBzpjG8s26VDo2qh3mTeVHqy2J78dMq2?=
 =?us-ascii?Q?daPT5GocKLzfZZLiAGHvraB9Yl0m2ux+Fs81deS7R5xFaCRSibcmTSHRsGUi?=
 =?us-ascii?Q?wlHXC1QB9SQtkNepvk0b56vISfKfZxRXRh8N?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:48:36.8468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1200334c-f067-4492-0bf5-08ddf0791fb0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFB67404FBA
X-Stat-Signature: jbqzixbeq6zz71akd79ggga8ybygn154
X-Rspam-User: 
X-Rspamd-Queue-Id: 8520B140014
X-Rspamd-Server: rspam10
X-HE-Tag: 1757515721-596344
X-HE-Meta: U2FsdGVkX1+MpiDzcKGeMPe/5SImWd+jESpINcQ21A6qICtUzJZpqxg+fg8vhNlKX2fL++Ly2PHneu+LqrGDriY+u7m2hge7In/HHMs22GlMPBH++L/xue01vxT6i2K5G6ac9Q6pmfDjiItW4yILB29HssZSVukoBiNHZzOKz+MBcbyspHZoyJBVU3/c/SnNNj7HG4VBiMSEBmwI5Lx9/t5BH+69TXFrUgBUDKQa5y7kwWo0FyXCnnlCcwKD/yQC1UJsKuZEv/dkAIEPJ0E6zRb6OFSanMmQVKCJWUAarNjwk5zlmsqJ3AIB6r57LmqbpJMn/y/PYBe5DzCUoQbN6gJ8Z+T3mC5WHV0nA7qRRJTPOQ3JbHh+DFgXHEmMIBHc8FFtjAogh9EqXmxcKmrGNO6mMIliET6p/t9ivUoU14BKWHo5vaHYHNXfkPLLx+COYKPu9Lzn4f/YmtMk8E4wrEYXdOOoYu4HyYChbD7eB58hx4MeG3mod/2Cv5GUMx/KT7xu00dQhbyZtz04CzOPlfEeG4mDE5XobHIjPZ27zhXJMhawZjBmIKExLY+I4FY8gSUXlROgOHDQxQ2h2f6Mc0g4vQr5R9ySn2eqcTvmrd5hZTiQJbFzOTRfkAh+BAV1Go6c+oZU5TJAizDMj04wcxppPhNrEHJBZMaXBq4hSo6Ny4dcSs0ozOnsk7G0L+J0fgzQhl1P0hKdoqbxvNmsFESSgJHJM6+sYs1tSFUOx/3NxM49COHSuwzH55s85MejlNZ2ND46yVivAcmuStFmk1cxzxqL5kWSBwGupIaT8jtsS5TS097ZJiXWB3H+QyseoCnKXfbTNQqCx/N088vd/uGTIlzhrVloLAw6mAi3H98t/NFbTNRSrm1Y8cZfGT1uXLlsJ40iKAiyvxwpkDXYOtgTfMdHdUAn7iB1ZU9ETzIJiQy8STIhvLqOIRrcNiyCV4cgorsR88YXvdg17Yf
 39HmnzF6
 S0D6f+ll+/33ruUvqJfXvMcwzSC30YXRJoXu8vyScHxymYxYVOu6RrCKZLQAh3COsbpzPuit6aZCEtOo8ZWWjcA66n0aWucyFC6zs+HaFWibFDjofkbZRWiRCO2jluWEgZY6EuDsL2qPVBuwFvcfX+54T30iFhbOsgxZDfY8o/wISllpjm3uts7Qk2eoY0WCHGdflvx5cwSC8dSWXaa7dkXn/RTaUqUHofMNiSyyH2c679ReOVnJMApFMd63OMn+CqNKZZ4AMYEb3tJqALHqUZPaPTIt6mexQJ6y6222XafC3/zBCCgDnAquxNviNn5Sk//g1ABxkxIEVFrB0qTO/VT/H8bMbI/Qotg78OqtAVw6Phawl0mtgFpxx3UrISwI/k1OFFrF0ng9trJOrawOx3KsLmyRoklF0eAjqCTzXkdIOdeiDjnJLRQemICLgV2WlVTHszIRzIxN2sZ4FHaaFqXd+YkkoJ4KQG+VLel8yHT0twRkhaMG+kmWttc+e+b+zg6Ry8ZIZd+GvrBhox/FqdEHK01mJXpVDzzg07ujggmM96QCNGrIjmtxOCjP/1F3C+cZUbud5SjiJcmkGCdwNx5jC7TizCYKI89LsoOJA4oalT/z6djxFJCwlOLe9JoXKf5CEZ0wfeqCRfLTSpHFQa89Su8Fmsq2b7j0/o6pGPZ4OFoXCqkxpVL7WC5ktRowDNPJ8sE5MvfTN0pyra2DPTCbIZK8uAmsRtcJYuYDD5Wg9avQlOdg4yFYoVWVe01KdpkvkMDX+qH9H8Z7OlPBkvmE1sWNTrtWgqr2zOT5eg473TuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

A common operation in tiering is to migrate multiple pages at once.
The migrate_misplaced_folio function requires one call for each
individual folio.  Expose a batch-variant of the same call for use
when doing batch migrations.

Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  6 ++++++
 mm/migrate.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..0593f5869be8 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -107,6 +107,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -117,6 +118,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
+						 int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index 7e356c0b1b5a..1268a95eda0e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2714,5 +2714,36 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/*
+ * Batch variant of migrate_misplaced_folio. Attempts to migrate
+ * a folio list to the specified destination.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio.
+ *
+ * This function will un-isolate the folios, dereference them, and
+ * remove them from the list before returning.
+ */
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	unsigned int nr_succeeded;
+	int nr_remaining;
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
+	}
+	BUG_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.34.1


