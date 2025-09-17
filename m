Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD70CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8779F28001A; Wed, 17 Sep 2025 15:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F10280002; Wed, 17 Sep 2025 15:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716A328001A; Wed, 17 Sep 2025 15:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC82280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:08:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0609871C3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:08:47 +0000 (UTC)
X-FDA: 83899679094.15.B0B3750
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023101.outbound.protection.outlook.com [40.107.201.101])
	by imf15.hostedemail.com (Postfix) with ESMTP id 130CFA0007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:08:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nbAzyicC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.101 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758136125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LP0btEFnlSCURoiH4JpOJzSv/Y3k8wyR1NTG+Y+Ukus=;
	b=yNAY2vJj2YxiHy1pcLFPT22yqye7qLvjZQa9UQMw4lVn0zPE+4UB2dvhdIIXB3O2Ts+dj/
	sG6tToHvQDfHyKavI4SeSC6kTWVhfbXGHXoOs/9Bh7NgUWikkAIxWOdtX3Vu62iWa44/G+
	abpMj5lXROZARdV5ZUoy+5imEHNXCSM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758136125; a=rsa-sha256;
	cv=pass;
	b=iC3IyeRC2HCisfvFbh8KhsptUlVLrPk/xDRrbVMo9qNDDuJEUfd4HBq9d6C92YU0iEoNsM
	m9a0ia3sgJ8fPntwOWsE/5duQSAzBTioBfgMoyWUPBmLDjLXF/SQRORYirRwtPRPKxvgDI
	TaEGjkp1fndLfdK4pNrnWusYf39tdDc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nbAzyicC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.101 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjrj6PU0tPvI04eTcUbzm4CYOEnBfe9AZQP37uB7BYRrn+TgCvvwRsUhaZteXguBeCXu1GNhNv+ujtEGPSREQhgEM3nomqyZr6VUZUF6p7/ZSLoU2ZO5lecz4ambjHInozkleGDcKbmMFXWUDEIOJ5BkRzDBtLe+dEqaxWDM4gZuKfe3kKZq/MVhWVZkJckd+U+DWB+a6wlUjeFKjmBKP54qulquDs5cCI7iN47Fm0DfhxihLV+g44wOeGdwHufZK2FEusVvd++ho6cSyJEpWLGpJ1o9743kfu2UsgYL6TxURQdGubaZ6QxJdQH8dSjrPTAgwVVTdcwXpd4/My75pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LP0btEFnlSCURoiH4JpOJzSv/Y3k8wyR1NTG+Y+Ukus=;
 b=dC57YzfIgBmvvqvca7snb3EPd94cHAuLB8c6LFQjd+Vc0LH51K7Do+wC9f8A8qYAl+5YvSbiho9cudFg1HsEi9GHXdJLCs1mlAsnfhHigc3QOzx3Xzy3xJqgEugyaGWxoT8wCRbsXsBRT2Cyw/7SgrVJ7JMl+D1n2lT8PoCyvYa1wU6QVZQMmRuDcarrIvNqOeraRBPnc3T3f+Snjr3NDeqK1FK0P+JV46Nnnz9tFNwaNLNxYVRrE52cp78nAGhjS4hA3aqcQfp/PvARUW4dOLClDKTt67s+yxtZXOFX5xTMnlyzw9F3RECLTYYZEhl8mPj8inwD2Nd/QkI5MAN3SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP0btEFnlSCURoiH4JpOJzSv/Y3k8wyR1NTG+Y+Ukus=;
 b=nbAzyicCJMXgquGKWN/2nIQPgqjRzqJoQ9mW1molt7ERe8kMQMo5L2fbaYFIliQRTewlQ/5fNO7p+b6D5vitrjkdthnJPZtdVsmiedBONcEmk2LQ7W621BTu5J/0M0C7+CQULbRDbrBw3mnEUodOF9p3LrUA9AhCSdu5z9G1GdI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV8PR01MB8429.prod.exchangelabs.com (2603:10b6:408:189::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Wed, 17 Sep 2025 19:04:14 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:04:14 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ardb@kernel.org,
	dev.jain@arm.com,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 4/5] arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs
Date: Wed, 17 Sep 2025 12:02:10 -0700
Message-ID: <20250917190323.3828347-5-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250917190323.3828347-1-yang@os.amperecomputing.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:930:4f::16) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV8PR01MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: 3351dbe2-5947-42bf-00e6-08ddf61cfcf4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bCIVhSLi6X1XUbk9mgATHdrBfkbBi54p/Ufi8oROVd2nP3PNxa3fSE16qwYb?=
 =?us-ascii?Q?Z2d2xnrGA32ixoADHQJsxTFAcFEpB7+nx8nSJqgAPvYCdAkBBejWzOygYGTs?=
 =?us-ascii?Q?1dyI6uF7NOcrbH5jqil0GjpxPqSWr4YJic+KZtUP/QzdqyIN8+d1CbqTLL58?=
 =?us-ascii?Q?rvmWM9S4fJXAHnotO9I1WShm3cDA8J7BD2gY8RZ8Rdg0EqvC6OdTdWlI3c8c?=
 =?us-ascii?Q?NxtIyRuIkxX42PR0UbAMFWLtE9NGVHGgwnkq6Bw0Uu3mhPSy4k5gRCweH24s?=
 =?us-ascii?Q?4PeY6jrajRe6WAb+cQPjQMvAeBndyjK1qlGxZuMViJsJ5cj2j0sMCkbX1a2s?=
 =?us-ascii?Q?Qu8TpH3esvwjF77VOy5FL7xZT7N74QuLge3Lq9pbHnEcdmSuFOppb+zqdZYV?=
 =?us-ascii?Q?p9LHGxVpDKSGBvGQICe9hLiJPaNXu0TkaPAHqCui6amHFrK11ad8N1X9XzDc?=
 =?us-ascii?Q?ruUyt8i/V6Q2C3d0sHOBIH17s7Yil4m6IHFrMO9nhToxBWxG3zelFhL917GB?=
 =?us-ascii?Q?RbvAnjk+lJ7n5sX2qmWN4sVX5gWz00TRlFGJz6VmycUAxPZK6lTs6nFUFfTr?=
 =?us-ascii?Q?6mZNBo8KljFsLSNQuVEqv/P5kctH6628dUi7RRJYbIKaZUpQ+AHyYXwmqjx4?=
 =?us-ascii?Q?hQeo7OmEtCHalHSR2+XRBSJwt5vlZ4VmsCNRq/ILD54yWrby3RZxBIy3Z3qc?=
 =?us-ascii?Q?+laXfhP3gL/gs31zScF7Q6GxpJW6iVfNJ7wDLBYQjWpXBSNEb++OrigHO9yO?=
 =?us-ascii?Q?bMg8kLoi8EKSn5ut1l2pgn+mFnZp549MopQOJRpxC/1TGl7zqLg6RA3m1aE+?=
 =?us-ascii?Q?ERReHk1DG+hOQNdQKP1XLFxGIBzRofFIjmggx4Omf88QziyQpTgTPq3tGtku?=
 =?us-ascii?Q?c48WFWbTktBmSPMZ9g4u9NDumJcqjQ0jxssE9OQSNstCxOlmmXtwuSLO8wqu?=
 =?us-ascii?Q?wEJCFSYYtlYLV05gaG+q2EojMv2bRiIqGtp3T62j+gAD2Q4bqdgSfaJjFa8H?=
 =?us-ascii?Q?cHZVuvkA15UjpvWN0fMHVt3acShSiRyAFYuIZ2ZZ1i0gY9aDvIIQzqHDMkQN?=
 =?us-ascii?Q?EeTEzPztv8YCuLA5+Qv387PR//cycx2zTWBhlp+FWQSAI5m0VWw6FSbp/uxk?=
 =?us-ascii?Q?hi2Q6w6CbQMaCcjSv81MNvknZ3gXiNYsYpXgKJwzgyUXlUOSsTqxchvfN6fk?=
 =?us-ascii?Q?lVTaNN5k6hGOg0TDM00ns5NXaBxf1y8B4oPtvAn3XVSqeFLLZ51foMBuD3Lm?=
 =?us-ascii?Q?7obGKUXETErM4xMzsvSi38xKefwiJbY11SWZKG0Y4CbYemay2q+8y2qxxaTS?=
 =?us-ascii?Q?KWVC7/ihjXIPqVs8GKBr/hkUFkYMjNqiP+C2Qw2+H+TINYABYQFJNlqPqBzN?=
 =?us-ascii?Q?xLKEl9SZnmVj+71HjRF2M7HlZsCRhOJ0eRRl7Yg/Cgt9TY9qf556DO6o2rWP?=
 =?us-ascii?Q?4lAEzKVsZtgdnd1lJcs0FLnVKXSkL9vpyXjp9Ve8j86u+aYfsWjBSgiCRkFj?=
 =?us-ascii?Q?0ymKmpbN9vWEevE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(7053199007)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YbmkYbKU+7SIoY/2L8M1p1wZky8ChDoAJIBLeItVkfL5nbQTrz1f1z7aWATg?=
 =?us-ascii?Q?o0UeD4G/FjWgWsXqtZ2c1XY8Dcs95svwZXZh5C1bZEgyyrNh4ns7wM0yUp0R?=
 =?us-ascii?Q?XYlbiI543uI1+F5D6RifMICxaJ1XgQGKvdEi8EElEpLa/aQe20fp17w/H/Mv?=
 =?us-ascii?Q?xGTKYmCZhfkapbt/CV5VnP49wV04FTu0QiKJozmKunU5VQfZWz+3J5MykuOB?=
 =?us-ascii?Q?Kg8BpJS4VQc69hd+YwOe+LBFhLSyPX5Fk+ZuM8Xm4U5kXNlcBKd3lVFfHFrS?=
 =?us-ascii?Q?ByzsMNDn3WMwZf+8M5fOLCxHTJ3MzVzY47PB0QjP3t1U5WxXXe/qiY6qvxp9?=
 =?us-ascii?Q?hZHFg8g0kT3ooPD4aYyJz1hGpmbRa6yc2CfkFHFV4fSSpH8xbf5YETcT1M6A?=
 =?us-ascii?Q?1rSf90ULHfTP3Q7ZojT6cgdB9xkBe8AU3pY063LOoskUKGz2kGksFYjrjsHf?=
 =?us-ascii?Q?IX88PugrANCEVdVCqdGzAh5Q9HKQq387XCP307NhRPcNHfgC87QSNV6fxUGa?=
 =?us-ascii?Q?tGZdmLDLxMa8dYba808agmxO374OYgD21yzQxPxwQ4jfL6wejEGrT516q0Hx?=
 =?us-ascii?Q?pTCfUXyKY51jJ11Ba77wPJ9E4jrlLKaZvkiKkmAkhN5gJvesgerQwfrAwVQk?=
 =?us-ascii?Q?vFBSCuEIRf5Nag2pXXZodttxk1A/d1eOugW22LP/4A6ZEGYldE/XG/x/kxqW?=
 =?us-ascii?Q?8hmH8uro/JG4d8QA2Uox+iZ1L0yRcrpCGxkKB22xqXoO/Uaq0CqMkO2BRZi5?=
 =?us-ascii?Q?gcMlFwFoGXAfVB5N+YbKO0JprTzN9ifAWDBWEV7d235IUEB0RoAIXes5jct0?=
 =?us-ascii?Q?IwyqdnkfIr/XQv5FaEdIta9WthMENnU/6Jg5l3JcULMuesRMSrn6r/dwRSlm?=
 =?us-ascii?Q?Ww1lIWfG34oXaCjnMnijypO/9mu+FRovleRzeRBGiArm/mIyjjbkK2g0qXUQ?=
 =?us-ascii?Q?bhyzbOZDRP/M4FlZsAB/nU5e8/k+bR+PpWLPTyZRrh1bpyyWubo8f2VkNY04?=
 =?us-ascii?Q?Qg2M/CxN0+SbYs2J9nEkAeCh30t0W+erufv4gc+awDbIY1gAgMWORde6s11X?=
 =?us-ascii?Q?Mv0bPfZC0K0sdfYmTK87cREsarewyh1Poqdb+fiR88dCJPDzvIUEAn9FBQ84?=
 =?us-ascii?Q?vaxwWbpm2iK0K5VJ3QAHK5OXAqHsvLtSr2ayA4cUis2AizaBJpGXUBl+7Nxi?=
 =?us-ascii?Q?Qh2CelQUcBnLcYLA9TfQ0usHQ1J1qFHP3ib8jb0ynzBQp6OXQmOpmwwMrbHf?=
 =?us-ascii?Q?fBxHx35SvX+zvdXpmtH14SvrxQhl4//IcS4+45L9iuSMsyoPWlCW2ezbw7zn?=
 =?us-ascii?Q?STd65M27S0bzkIGUTYc6UDtViLEo0WiCSRL3w/QadFZBCY2uQvXgV6VRKnhT?=
 =?us-ascii?Q?8S82Cf53vT9fS9WaEuNR9cigSuflSrgxJX3FYPalau42aCfib9cW1hmB5nBk?=
 =?us-ascii?Q?3RchiXsrWaRGb9SOurXCL4wlOv/3ZzUgKZ8GhJS9iFGz7gvah4R8/RJwqqO+?=
 =?us-ascii?Q?CV68ogNurpdUoYPvAqRT8ZD/1gYdv0wQ0myl7NWfUYldIFKGXTXFHNosKOdn?=
 =?us-ascii?Q?TTYIzM02OTh4hz2E/IvoclWO6RY6cawecqhHO1eizxwYkrtHSJVCO4f75vAJ?=
 =?us-ascii?Q?FVWtg4+nuufv/Pc7otKi+ZI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3351dbe2-5947-42bf-00e6-08ddf61cfcf4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:04:14.2345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLPnK1Qu3+w1/Cka+OHHa8ITYlgEuUe6mxfqKOrdSWQ2z1R7X7xNGNNcExzEa+E8HBFniowPTin2MGzYfuGr0ySV8W2K+7WB6bwrhtICaFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8429
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 130CFA0007
X-Stat-Signature: 16f1p1843ouhtqyyck6rnrwy8eu83b38
X-Rspam-User: 
X-HE-Tag: 1758136124-469370
X-HE-Meta: U2FsdGVkX18xHr5zSCuk2+IrkM+Qaho4s5JLfoB7B0XRDpcsD/VtmwRvLa2CIDCkUWhJYxPLnIPngOLjOoYpsCSKKMfZmpxMnz6lHLlGNdc6QWTgPQoYtNY1nx0ISSFcppZuyMm7tWsWRbVQB4Ld9Y2ex8Ne1XZZAJh1iiepYVKKX5elPIsl1DHnXd1998SQZMbs5q0q6zKMqmJe4XHIHaoGknN2NuL4UcUabnQoU0JBHe7VpB+Xh7iJam1Lk1nv/3cmaDtW86Q3v/85gQQNJ5Y/LvRuAzfEzyinjM9J30o9RrGze1fKEuM2gbeTT31YswTrmmZA9SuaNe+FmhBJTjkYPNJcqRJckQw8D9L9rflRuX5c7ohGrWB3RFze7tbh84m6fkWdEQBhqC6PVo32dH2xb5hlQphBoO43HNIa9qDlgySBIC6pVZk1CXikiRvBu0uyZxM7t5kasKK1Wwk9U8MnnIhuzzQ5+f6SYksiogXCXQ4ZmxmLJDVsKtYvavXYlbmUQ7fE8+xNuJeuGGT+OgB+20HB4+Lv2Q6a6nL/QVu0H1zh3R/1wnNQYdlUofORDdzNMYlAGTObDrLufp8v4awkM5z2WzWaqsuc4gViivzuRIOU+NdPUIcPyYTNqp9ypxxkgJMB4tXM9RKzT4zudK7Ff+fDQQ4hh0Bo4NIIHXaPyv4kZ5AOLACIukW9OLpY/P/dlEQ+j++EV/tNs8UpI1ehWWK9EebwSL9VUueuiu4wuh1gYRd1l3JPkYgxHl/jVUMVsirSBg8bXUaf1bp/0AzzR0Cw62sw3j+OnsXnqPzuDB0a7q8arA+0IM2nMwXxu/qU+y8DZih0/Kf1znzAzDvbci8iApNCv76KIzT1F62SJQQfOZruYEvHlwL4MHnOQ51jokTsAd6ASDQz04caHQzVKrmQfY/GcrmhT1hpY0mp8KWlO48Evoi0tjaZV62Xc6YKJSduGoCmkz3gIqf
 7q1wRjmu
 VzRLgdDrsoU0KUx44DkNCTQe1O5OjawVHZ8NreXGu4LjKwAuSEgsC5X27dmJ+47yxq+J+fZ6Vbg+EDYb5efGChL3YoH/cl/Mx8/S8U+pTOPGNvozlklWa+7nJs6t0Y0b6/nnKwFI9Xt2TT4zk1gO2i0XqBRKs+Yu3ByCsGsg4wiB3NAE4emVoIvo3aRuOh0o34nFrM/jjsKyEybC834ibyWS/p1DDcQio3DkmG8JjXFnEhCE3hrjK69uY8dSp4VA083QwrOFRSG9DMCFh6OomGw9QPi0Qa8exPBOM/9xUXieo2N0o0tnxM8bzQdwVlj5YYAVUXZ6f2QzT5hG0OkCsDO45YAZXSoeCaPPt9OefFrTrZZ5/Z1Z/OE5Rul5+MABSeZc/rY0+SXwhQAdM7gLAopQoq3Ti3lRrBbMHphiC4Nm5oKTJCBMYP7FUcCJdgMkCAAisbi1CYngNeMYJW7UhfFhSFwDnLKM38aGhIBsHKko8T3PKmjT30iUXAnf41kU7orHc7JqJ0lNYlEvPhXRywpOpDA/X9Q+4VCkJ5ylwM0H5xt6r76RTppVvyqTjtOTTw9qBJgdeJ0f7twRp6HOCwiMTNpBEOblzzNIolgxS3xuZhATp73gr1lSQieeyS6r3JUUOLLOkJ3sfnFLb+nO4Va3Mjxt7BqgwlfPFV8tFiRwzdSkE1rSS2KOWMIyAbVtwx13g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ryan Roberts <ryan.roberts@arm.com>

The kernel linear mapping is painted in very early stage of system boot.
The cpufeature has not been finalized yet at this point. So the linear
mapping is determined by the capability of boot CPU only. If the boot
CPU supports BBML2, large block mappings will be used for linear
mapping.

But the secondary CPUs may not support BBML2, so repaint the linear
mapping if large block mapping is used and the secondary CPUs don't
support BBML2 once cpufeature is finalized on all CPUs.

If the boot CPU doesn't support BBML2 or the secondary CPUs have the
same BBML2 capability with the boot CPU, repainting the linear mapping
is not needed.

Repainting is implemented by the boot CPU, which we know supports BBML2,
so it is safe for the live mapping size to change for this CPU. The
linear map region is walked using the pagewalk API and any discovered
large leaf mappings are split to pte mappings using the existing helper
functions. Since the repainting is performed inside of a stop_machine(),
we must use GFP_ATOMIC to allocate the extra intermediate pgtables. But
since we are still early in boot, it is expected that there is plenty of
memory available so we will never need to sleep for reclaim, and so
GFP_ATOMIC is acceptable here.

The secondary CPUs are all put into a waiting area with the idmap in
TTBR0 and reserved map in TTBR1 while this is performed since they
cannot be allowed to observe any size changes on the live mappings. Some
of this infrastructure is reused from the kpti case. Specifically we
share the same flag (was __idmap_kpti_flag, now idmap_kpti_bbml2_flag)
since it means we don't have to reserve any extra pgtable memory to
idmap the extra flag.

Co-developed-by: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/mmu.h   |   2 +
 arch/arm64/kernel/cpufeature.c |   3 +
 arch/arm64/mm/mmu.c            | 182 +++++++++++++++++++++++++++++----
 arch/arm64/mm/proc.S           |  27 +++--
 4 files changed, 187 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index a7cc95d97ceb..ff6fd0bbd7d2 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -79,6 +79,8 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 extern int split_kernel_leaf_mapping(unsigned long start, unsigned long end);
+extern void init_idmap_kpti_bbml2_flag(void);
+extern void linear_map_maybe_split_to_ptes(void);
 
 /*
  * This check is triggered during the early boot before the cpufeature
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7dc092e33fcc..dd3dbe4c9359 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -86,6 +86,7 @@
 #include <asm/kvm_host.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
+#include <asm/mmu.h>
 #include <asm/mte.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
@@ -2028,6 +2029,7 @@ static void __init kpti_install_ng_mappings(void)
 	if (arm64_use_ng_mappings)
 		return;
 
+	init_idmap_kpti_bbml2_flag();
 	stop_machine(__kpti_install_ng_mappings, NULL, cpu_online_mask);
 }
 
@@ -3955,6 +3957,7 @@ void __init setup_system_features(void)
 {
 	setup_system_capabilities();
 
+	linear_map_maybe_split_to_ptes();
 	kpti_install_ng_mappings();
 
 	sve_setup();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index fa09dd120626..ca3f02eb961e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -27,6 +27,8 @@
 #include <linux/kfence.h>
 #include <linux/pkeys.h>
 #include <linux/mm_inline.h>
+#include <linux/pagewalk.h>
+#include <linux/stop_machine.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -476,11 +478,11 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 
 #define INVALID_PHYS_ADDR	(-1ULL)
 
-static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
+static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
 				       enum pgtable_type pgtable_type)
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
+	struct ptdesc *ptdesc = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
 	phys_addr_t pa;
 
 	if (!ptdesc)
@@ -507,9 +509,9 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 }
 
 static phys_addr_t
-try_pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
+try_pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type, gfp_t gfp)
 {
-	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
+	return __pgd_pgtable_alloc(&init_mm, gfp, pgtable_type);
 }
 
 static phys_addr_t __maybe_unused
@@ -517,7 +519,7 @@ pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
 {
 	phys_addr_t pa;
 
-	pa = __pgd_pgtable_alloc(&init_mm, pgtable_type);
+	pa = __pgd_pgtable_alloc(&init_mm, GFP_PGTABLE_KERNEL, pgtable_type);
 	BUG_ON(pa == INVALID_PHYS_ADDR);
 	return pa;
 }
@@ -527,7 +529,7 @@ pgd_pgtable_alloc_special_mm(enum pgtable_type pgtable_type)
 {
 	phys_addr_t pa;
 
-	pa = __pgd_pgtable_alloc(NULL, pgtable_type);
+	pa = __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_type);
 	BUG_ON(pa == INVALID_PHYS_ADDR);
 	return pa;
 }
@@ -541,7 +543,7 @@ static void split_contpte(pte_t *ptep)
 		__set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
 }
 
-static int split_pmd(pmd_t *pmdp, pmd_t pmd)
+static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 {
 	pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
 	unsigned long pfn = pmd_pfn(pmd);
@@ -550,7 +552,7 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd)
 	pte_t *ptep;
 	int i;
 
-	pte_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PTE);
+	pte_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PTE, gfp);
 	if (pte_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	ptep = (pte_t *)phys_to_virt(pte_phys);
@@ -559,7 +561,9 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd)
 		tableprot |= PMD_TABLE_PXN;
 
 	prot = __pgprot((pgprot_val(prot) & ~PTE_TYPE_MASK) | PTE_TYPE_PAGE);
-	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+	prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
+	if (to_cont)
+		prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 	for (i = 0; i < PTRS_PER_PTE; i++, ptep++, pfn++)
 		__set_pte(ptep, pfn_pte(pfn, prot));
@@ -583,7 +587,7 @@ static void split_contpmd(pmd_t *pmdp)
 		set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
 }
 
-static int split_pud(pud_t *pudp, pud_t pud)
+static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
 {
 	pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
 	unsigned int step = PMD_SIZE >> PAGE_SHIFT;
@@ -593,7 +597,7 @@ static int split_pud(pud_t *pudp, pud_t pud)
 	pmd_t *pmdp;
 	int i;
 
-	pmd_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PMD);
+	pmd_phys = try_pgd_pgtable_alloc_init_mm(TABLE_PMD, gfp);
 	if (pmd_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
@@ -602,7 +606,9 @@ static int split_pud(pud_t *pudp, pud_t pud)
 		tableprot |= PUD_TABLE_PXN;
 
 	prot = __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
-	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+	prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
+	if (to_cont)
+		prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 	for (i = 0; i < PTRS_PER_PMD; i++, pmdp++, pfn += step)
 		set_pmd(pmdp, pfn_pmd(pfn, prot));
@@ -660,7 +666,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	if (!pud_present(pud))
 		goto out;
 	if (pud_leaf(pud)) {
-		ret = split_pud(pudp, pud);
+		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL, true);
 		if (ret)
 			goto out;
 	}
@@ -685,7 +691,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 		 */
 		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
 			goto out;
-		ret = split_pmd(pmdp, pmd);
+		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL, true);
 		if (ret)
 			goto out;
 	}
@@ -758,6 +764,138 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 	return ret;
 }
 
+static int __init split_to_ptes_pud_entry(pud_t *pudp, unsigned long addr,
+					  unsigned long next,
+					  struct mm_walk *walk)
+{
+	pud_t pud = pudp_get(pudp);
+	int ret = 0;
+
+	if (pud_leaf(pud))
+		ret = split_pud(pudp, pud, GFP_ATOMIC, false);
+
+	return ret;
+}
+
+static int __init split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
+					  unsigned long next,
+					  struct mm_walk *walk)
+{
+	pmd_t pmd = pmdp_get(pmdp);
+	int ret = 0;
+
+	if (pmd_leaf(pmd)) {
+		if (pmd_cont(pmd))
+			split_contpmd(pmdp);
+		ret = split_pmd(pmdp, pmd, GFP_ATOMIC, false);
+
+		/*
+		 * We have split the pmd directly to ptes so there is no need to
+		 * visit each pte to check if they are contpte.
+		 */
+		walk->action = ACTION_CONTINUE;
+	}
+
+	return ret;
+}
+
+static int __init split_to_ptes_pte_entry(pte_t *ptep, unsigned long addr,
+					  unsigned long next,
+					  struct mm_walk *walk)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	if (pte_cont(pte))
+		split_contpte(ptep);
+
+	return 0;
+}
+
+static const struct mm_walk_ops split_to_ptes_ops __initconst = {
+	.pud_entry	= split_to_ptes_pud_entry,
+	.pmd_entry	= split_to_ptes_pmd_entry,
+	.pte_entry	= split_to_ptes_pte_entry,
+};
+
+static bool linear_map_requires_bbml2 __initdata;
+
+u32 idmap_kpti_bbml2_flag;
+
+void __init init_idmap_kpti_bbml2_flag(void)
+{
+	WRITE_ONCE(idmap_kpti_bbml2_flag, 1);
+	/* Must be visible to other CPUs before stop_machine() is called. */
+	smp_mb();
+}
+
+static int __init linear_map_split_to_ptes(void *__unused)
+{
+	/*
+	 * Repainting the linear map must be done by CPU0 (the boot CPU) because
+	 * that's the only CPU that we know supports BBML2. The other CPUs will
+	 * be held in a waiting area with the idmap active.
+	 */
+	if (!smp_processor_id()) {
+		unsigned long lstart = _PAGE_OFFSET(vabits_actual);
+		unsigned long lend = PAGE_END;
+		unsigned long kstart = (unsigned long)lm_alias(_stext);
+		unsigned long kend = (unsigned long)lm_alias(__init_begin);
+		int ret;
+
+		/*
+		 * Wait for all secondary CPUs to be put into the waiting area.
+		 */
+		smp_cond_load_acquire(&idmap_kpti_bbml2_flag, VAL == num_online_cpus());
+
+		/*
+		 * Walk all of the linear map [lstart, lend), except the kernel
+		 * linear map alias [kstart, kend), and split all mappings to
+		 * PTE. The kernel alias remains static throughout runtime so
+		 * can continue to be safely mapped with large mappings.
+		 */
+		ret = walk_kernel_page_table_range_lockless(lstart, kstart,
+						&split_to_ptes_ops, NULL, NULL);
+		if (!ret)
+			ret = walk_kernel_page_table_range_lockless(kend, lend,
+						&split_to_ptes_ops, NULL, NULL);
+		if (ret)
+			panic("Failed to split linear map\n");
+		flush_tlb_kernel_range(lstart, lend);
+
+		/*
+		 * Relies on dsb in flush_tlb_kernel_range() to avoid reordering
+		 * before any page table split operations.
+		 */
+		WRITE_ONCE(idmap_kpti_bbml2_flag, 0);
+	} else {
+		typedef void (wait_split_fn)(void);
+		extern wait_split_fn wait_linear_map_split_to_ptes;
+		wait_split_fn *wait_fn;
+
+		wait_fn = (void *)__pa_symbol(wait_linear_map_split_to_ptes);
+
+		/*
+		 * At least one secondary CPU doesn't support BBML2 so cannot
+		 * tolerate the size of the live mappings changing. So have the
+		 * secondary CPUs wait for the boot CPU to make the changes
+		 * with the idmap active and init_mm inactive.
+		 */
+		cpu_install_idmap();
+		wait_fn();
+		cpu_uninstall_idmap();
+	}
+
+	return 0;
+}
+
+void __init linear_map_maybe_split_to_ptes(void)
+{
+	if (linear_map_requires_bbml2 && !system_supports_bbml2_noabort()) {
+		init_idmap_kpti_bbml2_flag();
+		stop_machine(linear_map_split_to_ptes, NULL, cpu_online_mask);
+	}
+}
+
 /*
  * This function can only be used to modify existing table entries,
  * without allocating new levels of table. Note that this permits the
@@ -912,6 +1050,8 @@ static void __init map_mem(pgd_t *pgdp)
 
 	early_kfence_pool = arm64_kfence_alloc_pool();
 
+	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
+
 	if (force_pte_mapping())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
@@ -1045,7 +1185,7 @@ void __pi_map_range(u64 *pgd, u64 start, u64 end, u64 pa, pgprot_t prot,
 		    int level, pte_t *tbl, bool may_use_cont, u64 va_offset);
 
 static u8 idmap_ptes[IDMAP_LEVELS - 1][PAGE_SIZE] __aligned(PAGE_SIZE) __ro_after_init,
-	  kpti_ptes[IDMAP_LEVELS - 1][PAGE_SIZE] __aligned(PAGE_SIZE) __ro_after_init;
+	  kpti_bbml2_ptes[IDMAP_LEVELS - 1][PAGE_SIZE] __aligned(PAGE_SIZE) __ro_after_init;
 
 static void __init create_idmap(void)
 {
@@ -1057,15 +1197,17 @@ static void __init create_idmap(void)
 		       IDMAP_ROOT_LEVEL, (pte_t *)idmap_pg_dir, false,
 		       __phys_to_virt(ptep) - ptep);
 
-	if (IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0) && !arm64_use_ng_mappings) {
-		extern u32 __idmap_kpti_flag;
-		u64 pa = __pa_symbol(&__idmap_kpti_flag);
+	if (linear_map_requires_bbml2 ||
+	    (IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0) && !arm64_use_ng_mappings)) {
+		u64 pa = __pa_symbol(&idmap_kpti_bbml2_flag);
 
 		/*
 		 * The KPTI G-to-nG conversion code needs a read-write mapping
-		 * of its synchronization flag in the ID map.
+		 * of its synchronization flag in the ID map. This is also used
+		 * when splitting the linear map to ptes if a secondary CPU
+		 * doesn't support bbml2.
 		 */
-		ptep = __pa_symbol(kpti_ptes);
+		ptep = __pa_symbol(kpti_bbml2_ptes);
 		__pi_map_range(&ptep, pa, pa + sizeof(u32), pa, PAGE_KERNEL,
 			       IDMAP_ROOT_LEVEL, (pte_t *)idmap_pg_dir, false,
 			       __phys_to_virt(ptep) - ptep);
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 8c75965afc9e..86818511962b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -245,10 +245,6 @@ SYM_FUNC_ALIAS(__pi_idmap_cpu_replace_ttbr1, idmap_cpu_replace_ttbr1)
  *
  * Called exactly once from stop_machine context by each CPU found during boot.
  */
-	.pushsection	".data", "aw", %progbits
-SYM_DATA(__idmap_kpti_flag, .long 1)
-	.popsection
-
 SYM_TYPED_FUNC_START(idmap_kpti_install_ng_mappings)
 	cpu		.req	w0
 	temp_pte	.req	x0
@@ -273,7 +269,7 @@ SYM_TYPED_FUNC_START(idmap_kpti_install_ng_mappings)
 
 	mov	x5, x3				// preserve temp_pte arg
 	mrs	swapper_ttb, ttbr1_el1
-	adr_l	flag_ptr, __idmap_kpti_flag
+	adr_l	flag_ptr, idmap_kpti_bbml2_flag
 
 	cbnz	cpu, __idmap_kpti_secondary
 
@@ -416,7 +412,25 @@ alternative_else_nop_endif
 __idmap_kpti_secondary:
 	/* Uninstall swapper before surgery begins */
 	__idmap_cpu_set_reserved_ttbr1 x16, x17
+	b scondary_cpu_wait
+
+	.unreq	swapper_ttb
+	.unreq	flag_ptr
+SYM_FUNC_END(idmap_kpti_install_ng_mappings)
+	.popsection
+#endif
+
+	.pushsection ".idmap.text", "a"
+SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
+	/* Must be same registers as in idmap_kpti_install_ng_mappings */
+	swapper_ttb	.req	x3
+	flag_ptr	.req	x4
+
+	mrs     swapper_ttb, ttbr1_el1
+	adr_l   flag_ptr, idmap_kpti_bbml2_flag
+	__idmap_cpu_set_reserved_ttbr1 x16, x17
 
+scondary_cpu_wait:
 	/* Increment the flag to let the boot CPU we're ready */
 1:	ldxr	w16, [flag_ptr]
 	add	w16, w16, #1
@@ -436,9 +450,8 @@ __idmap_kpti_secondary:
 
 	.unreq	swapper_ttb
 	.unreq	flag_ptr
-SYM_FUNC_END(idmap_kpti_install_ng_mappings)
+SYM_FUNC_END(wait_linear_map_split_to_ptes)
 	.popsection
-#endif
 
 /*
  *	__cpu_setup
-- 
2.47.0


