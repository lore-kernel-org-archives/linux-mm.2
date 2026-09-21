Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5225C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC02F6B008C; Mon, 21 Sep 2026 05:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98976B00BC; Mon, 21 Sep 2026 05:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60A96B00E2; Mon, 21 Sep 2026 05:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40896B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:43:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 841AD1405AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:43:11 +0000 (UTC)
X-FDA: 85237280982.29.C11F589
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013004.outbound.protection.outlook.com [40.107.201.4])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9223FC0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:43:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baPHJOHA;
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 40.107.201.4 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789983788;
	b=Uo8LUfmhVYCHVQQcyQRb+WE3KNGPpS8U5fg4L9yn0AxCG8+F4RCFS6ZV5Bft/Tlcbq4mBR
	oV46OiYpjOukbFF6gOUsfTZazyGbJNfQxqFEpXyXDNe3Fb2noorFx1nyy9phTEGLsuoxhB
	bVdNjVUz+/+81FbfIHBsredFv8LbNT8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=baPHJOHA;
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 40.107.201.4 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzog+LdhapcQveRFy1QBrMu2kmoHFsmD/qD/SmugWqM=;
	b=jyBUlofe0YpQowVl/8nkkqC1hYk30w/HuleIXJ4XP6hYFw0lYDzXJLaJEsgxKok8mTWKWF
	XXGl7yBNcHjD95182cEULLYt0B5vojDLbJO204XdWqSDHS61IMIwgHcZvDdaSqR7iAhKGH
	UKSeLc0So8mwmjvlGSZyo7eGkawm3ss=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeJ3CP60lVByTm8V778E7jZ86mY8UdTAieHX+iYzBWRbooL6e3IYcxdM3pHAkh7CkACeeULYEGktdTZc/LmN/5owEKhYspcPvxFD/aiHaSDtAtHXUFRit23+y/KViXir4T2sp8KIrqZIHxI6Vayv6us/5Xf2RxnCLYo6QIOw8wirhVrAfBFsrb2Kz45JwWdhIYOf+SC7vDrsrxlnQ+HMGn7D4uy6xUk8t2MAvjEYKEVAbRVeMqfbVIygrVRaWT5JNSusTtBmXTov4UBW7+YdCu0D9xA9gQa1rv5sf0766bkrSHJh4skOUKiZZJ8KQPb/WTTv5bq2pFYgsm/0a/eSrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzog+LdhapcQveRFy1QBrMu2kmoHFsmD/qD/SmugWqM=;
 b=QfrvsIFqx+cY0P1OGIzcZBDeTRm8kRRhlxO+9K+9h+R1b8OOhirGz88RIN3njACm1YHbmjggi3fOJu2fHLw4AJ4Atl8SKkdCcZm+CoeSPKe7FZCJtoVXSHyAeyspi9PM8pohy/TQZattxQEm4/wsPdhHUfr+DA2DGLt3ZYtYnW/asAdu72o59luK88la7crvRpvcb9Ni7Jf9HUFLvUsNbJeYHYy6EWx7Jzwk1FiXJpdzTv3kgaJN5XhPXSNeEa8CEtyxWpPKf41bnADfzU2Cgm5gfXPlLUVmuV3tBHHxXvH1r0Aj9VhYEkHVTG8Ep3aSuyOyV6mPwKdIHOTOpT6NRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzog+LdhapcQveRFy1QBrMu2kmoHFsmD/qD/SmugWqM=;
 b=baPHJOHAoznGTpJcGtpXsMM+UVZSfl5YGVZ50LlMU+JSdtfVt/Kd9iMtrnxln9OSa8FptvGHb1klH08sfOFvtTAKI3gJ3xrIMgZC9tpUIR09Cl3qmwUsikgBaXk1L6IrK1r1U/jY6ZAM6K95zvXN2rXtdhQvX0v8VAa2OuvfzsZ5i4OQe99CjjI2P4oPHyo5R7RUteYpFk0uuI5yo4JSSiAHqmqu/TgQnyREUzNQsy1H4gAPxYTwWRrWl2o/uARLft8TTjARM2wc++368baW8z41eEiYaC2WlIbO7yihb/YMZ84I+KTdx8OSQnB7f5lhrZd8vlEftelkS1IsayKdcA==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 09:43:03 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 09:43:03 +0000
From: Richard Cheng <icheng@nvidia.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	kobak@nvidia.com,
	kaihengf@nvidia.com,
	newtonl@nvidia.com,
	kristinc@nvidia.com,
	Richard Cheng <icheng@nvidia.com>
Subject: [RFC PATCH 2/2] selftests/mm: Test per-open gup_test pin ownership
Date: Mon, 21 Sep 2026 17:42:43 +0800
Message-ID: <20260921094243.64698-3-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260921094243.64698-1-icheng@nvidia.com>
References: <20260921094243.64698-1-icheng@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0011.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::17) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f411f77-e24a-45c7-8f86-08df17c4bb34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|56012099006|11063799006|6133799003|10067099003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hCq6fOt2D84Mih0C/+OW4K2z14pgoRUcYVf3YVCm3jECJXeywdyRXksRqwSibJkdPewY5NdDrCCWBp6wU28Mm2cqmsmMzPDxeeQsoIVmO30XmmS1kszlwfxw7myugs3iE+COEuvsc3j5PhnBb66/iwwFVNWHPBDGQhmSGtRbirenIOoFZkPU/nIiGNT4zGGIyzKC5DN8RjlaH27S6RcGV2Of8pqM720FdtR5nnf4Lt1GYOVy0fuEGuQACLYX7n3GloKtpXdyxwr4ZOFtPxr7WZudhv7BbOkCS34m4wEZ8TgtN1iCLKngVs42qIl0L+/JmK9YaKFa113mC90vWuD9NE0wTwh56VMTVQBcAUnL9kp4xxS4aG+/ZgVvPpBePvmWTxz0Gw98yhDzZBoesAtCapQfTZGOVvAHcZ01TZ+zr33zzaa0uxncH9qRg/fwai7PfNAo3dhGiGNQSW9SozErL+b/QWdEBZr6k/NGsdkEqQhQEEXHpniemp/02XYFzrEStcW16o421y/bwDfzUVBdOJcIFJtymPBIdJLV8SO4z6WyDnkCZUbFT/8XO+Y5ecdeoEzw7I1lvKDOc4B3QgwleQmF6qDmHBu/2wbXvvT0Y7AAugfRffMYhIFUahLpxUuXRG8uUjB8rRBWCySuada20+SDydGu6wHjVF9TKJsSiGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(56012099006)(11063799006)(6133799003)(10067099003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fpUeRcE34oyLJe7p0mBXe1sXNIjt6c5piRKMD5e0w9LtewecIUoXGCBIfdyV?=
 =?us-ascii?Q?ZGPhBaA4PY4YN6nLiPCOlfvgmm+U6l9vLK3K2DM+nRjlZ+9q3MVLUoFlrNWm?=
 =?us-ascii?Q?dh4UpuvQR7wZJohbdbHPxT+Ffh5GySjxKcDZYcq29iz33NycLtyGtMA/+VnP?=
 =?us-ascii?Q?+EzVjk4715g/1v4xRPoqNi8cbbFxeN6JOY2TvUI80cG7XAoiItZ/FSPN2F2p?=
 =?us-ascii?Q?yk3znsy3fr1Q1g7A5ArfQuzEUf+Doc6rTXR1u4cuG0USm+QXdYG/cMMCE/e9?=
 =?us-ascii?Q?rzGJ4aU2YLcOghhgN3z8d28iS6jLaVjVTUKmzIJJ95zGnKeJ7C09mQQXVlRI?=
 =?us-ascii?Q?fET86ZFI11GZMvIuf0e5MGkNrRp+0yavq2YprPB3kCEqfYkaywaGoRNGVFWd?=
 =?us-ascii?Q?YQC5rehf20r/XNmG2RWwvFvC3mU4kgfpd2v4SNg0Rm+9VhgJ/or9uMOtfuMD?=
 =?us-ascii?Q?OTykT5vffPsq2uS/taUAUYj7FX19UkWmsU0+oliTJJxD/RMp1DvsiWJZxMMp?=
 =?us-ascii?Q?RFcJJJ9hbXMM5eLLzbd3PWkBIqav7GHY+XsmrSvGxlvpt9NtlPCHCoayH+34?=
 =?us-ascii?Q?KSfSb4MFwV6/iG4OQyCrA8De89OnxtMqQvMdKyMvd+fqZLW/y7LuABjHqCG9?=
 =?us-ascii?Q?/isyXIEPIc3W9xY3yGCbm346Vm/ED1VSjnNmp09YcZTY+GsCqKh//F+2CiSj?=
 =?us-ascii?Q?EhZE+QSHpHnmpwcxQRhqaXoXHkPFwG4peLHTberZ4fId/CuJCsxNGDJvyseo?=
 =?us-ascii?Q?yoxsOaFXtvdVYFPf9/VMJaaxUhcqLuvwLTi5Suoj9uU09BZgZMhTWjpXXCBc?=
 =?us-ascii?Q?UJmKVrwiMUh5BURD4IdB81zsPNhjf1VylsUFYI8Sxza5ZL+a9NY5Z63hMQcY?=
 =?us-ascii?Q?Dj5qpi/l053guCyfLhcMxK5vLJakh3imJQkyrh6Wmfxa35TWCT607PAMV3zu?=
 =?us-ascii?Q?PaoVnOlyUEXDONeZQ/O46RdFTlXW2AVHY5FHqEn3lS+e96fa4teeTtvbvL08?=
 =?us-ascii?Q?SZgQLGOlA0XLshZLCnVAMO9qa6F2FTrReN6xgB65EDEKFqW6RoOLKVZffD4+?=
 =?us-ascii?Q?3EjoMqZJFmlJUq/kssuqeHZ2AbvKQ/hOITCFWt6IIIko5q0uB9GD41DB8nFu?=
 =?us-ascii?Q?2oiVp3IAZlvo4xNDMw2/uu8w3w3spWkl78Vkg7owNyQ3baH59MweH++rFnxT?=
 =?us-ascii?Q?gFY+n7tlDE5tNd9nMcNa/X1Wn6ZprYvsbQjaOKYgg+7bLc6a2O/KBFYqQtwv?=
 =?us-ascii?Q?FxHqneuVZhYT4eMPnlrV6lffDW9kON/IOpRzBsADBuk7CyGF9+tBFR9q4wMz?=
 =?us-ascii?Q?gJlSUSS+DHZPaxyBuHa1lQQPOnP3bzNO/3rcylTBtpi88matnPLrNcDkC9WY?=
 =?us-ascii?Q?6P9JZfygA+X6Lh4kCa+O6DSd2ldt5eVap0ptvZDnuhFQg+8OfxtuoekivGRK?=
 =?us-ascii?Q?/snJF6ykB5fbWS6/07qrDBx8H7i7D5YZMTxxAMZHVSBmK4NpZF5mH1YZTcWb?=
 =?us-ascii?Q?1l0UTWcehePkq/mDIWpQRbQhnI5z64jL+7zNU5n2r0CLVeYsaje9ehPTUIBw?=
 =?us-ascii?Q?Rjw5wVodVgIQQpmmiYhFK8APIIAesq8ht94Gf6SHUE0fQyxdh47Ue1WS70fq?=
 =?us-ascii?Q?IgTMHBhe3Zqhin2o1DDFB4R1x1GkqVwPREBgCqu6YrIaHfU41DOCjV+JMFnm?=
 =?us-ascii?Q?RMvv03Hfk0XjxtVqTm031QNmRj32pRfb4BUU7U4GHUv7hh7W87JhWlimoCO7?=
 =?us-ascii?Q?67sR1MsKMw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f411f77-e24a-45c7-8f86-08df17c4bb34
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 09:43:03.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+Tiu5evpaDLm4PHxVVASVP7vu3/Mhx+O0tXKiPW6WUj9nhuqEHRVhuAOrF3KUd2x+Q0FkNJb+gXSNSkcCnk0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9223FC0002
X-Stat-Signature: nsr1hnjkdocoy6kdckx1gecn8n4ajx39
X-HE-Tag: 1789983788-168695
X-HE-Meta: U2FsdGVkX1+VgiC7p7Q/ahIl3IXHuLyf8y+JKzoF9s2IdLocIavPWnc1UCnaJhIb4nsQenDPgLK/r+Ef2gaweCroqnSKHfYZeleAlhvIVFpY06xD9zGQfQZTFwvXASzxkoLbtQIM57QK/HbiKsrsXT5qlNiJElmxGNcw9dwK+KG1knB7NsicOhHIILILQDXlS6k7+QEg3xpkn1V8L0UTljaMPwDk+qDPYk3Jjd/8VitKruPUD1H4WElf0FiXZPLA5MqrRlz+qCBo5CJOuHotYk8vOs1DBgjTYFytN+rUU52bgwkoMxEdyilnO5QyZ18o+2EQXf/RJhyNX6PMgXdza4xjz5qPkuPIbsGfckAO0qofKnVmklA04OSpFiw6A5XBgp9BL3tAt4b3sYpl4d5vBhtZV87KzicDKRCPGfR3t/dRQA6JrCmfTM/74Zlg4ob11rk1gYC4FEkt1bnD/RkUGQrBtdHaA45x7hLx/uQMnWYNbCgr4vPs4MrQ22/dFG+JeH78CuTCsgpMvF6SP3oLBQBKTTedHwwUkUYL9C47hU8vUGfAsjbkHbeunh+nUvXCjWfVC5bthH+dGBVCFN5JKEC8CPiyL3KvgH/7NBRw5KEnH1JqhVK88hKoiUUoKGzymiVqtMG0x14EIADUNgGLcjHDacT+4OPjg+8OoKTPeqQ4f0mM+a1L8h3fze97QOZxLw4WfEPC1IRVJAgsqTMGychIPEOQFXI1/25F+2DsRUU7f4zZBRLdtLVVwDLkokaQPbhM5Wf5yW2sPSQw1eGEznymBx+n2qNPnwsilxNN/XgTy0cupR/6EK4SWGxswcd8iozUPqtENDLlF4gqxBWA7sBS9kI3TjofQPoBSOdiib/oEw3AM9oAuW0Y10NCz6VFsq/gr7SXJTnitKn+8YSuIvq5PVvX3J6kP4DPIrZyBnAjrvC4XFvOiPMABzNSPqOA79OObt3Z5zz5I/a+X6f
 iTz53YYQ
 X4nBBbLuDKuPgWCXgCaJi5gmuQ9bKWrsMDjz9l0f6pZVNJkOhfxg1Itxmwf2XhCMv+W64zUVDI23FYCm0VZKINE6xvlE4ZdcaZccvUqxgBofnHLEw1CvRsK/LC6IXFGkYV4abEyqWEMoMoaJGb3sCCEu4CaaN9ybVfR285Ui4rliHmkxkUOdBQaS0g0gz1JY0b1TwuaHM0v2XGM08h4ja9PLbdWJEEDmztYG+hs7Lgq7sZpBVctgMmXK4yn9r0iR6R6YpJ9B3/S1RvSBnJ/qEMfJMZJB9q5ouAPR4kdbEM31E60hqM0hB715c6IaFL5bkY+rITA0HO01NyCC6nhf5hUFSr6ev9JgzKzp3RDuL+QlvjOvLZ7q9wRI8m9r9/q3/dQiRR9ADKxbCxpjn0KuaxPPkROH5Sa/i3k7hQ32lWn1RwNdsMvDCyI8bIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Long-term pin state should be isolated between independently opened
gup_test file descriptions, while descriptors created with dup() should
continue to share the state associated with their struct file.

Add tests using 2 independently opened gup_test descriptors. Verify that
stopping or closing the second descriptor doesn't disturb the first
descriptor's pin, that another START on the same descriptor fails with
EINVAL, and that READ fails with EINVAL after STOP.

Close the descriptor used by the existing test matrix before running the
ownership tests. Record whether gup_test was initially available so that
a later open failure is reported as a failure instead of being hidden as
a skip.

Also exercise the shared-file-description case: start a pin through the
original descriptor, verify that START through a duplicate fails with
EINVAL, close the original descriptor, and use the duplicate to READ and
STOP the pin

Reviewed-by: Koba Ko <kobak@nvidia.com>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
 tools/testing/selftests/mm/gup_longterm.c | 258 +++++++++++++++++++++-
 1 file changed, 256 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index c03b4f8910c0..ecae71ecedd3 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -36,6 +36,9 @@ static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
 static int gup_fd;
 
+#define GUP_TEST_FILE	"/sys/kernel/debug/gup_test"
+#define NR_FD_OWNERSHIP_TESTS	3
+
 static __fsword_t get_fs_type(int fd)
 {
 	struct statfs fs;
@@ -500,6 +503,246 @@ static void run_test_case(struct test_case const *test_case)
 				       hugetlbsizes[i]);
 }
 
+static void test_fd_isolation(bool stop_fd2, bool gup_test_was_available)
+{
+	struct pin_longterm_test args = {
+		.size = pagesize,
+	};
+	char *mem1 = MAP_FAILED, *mem2 = MAP_FAILED;
+	char *read_buf = MAP_FAILED;
+	bool pin1 = false, pin2 = false;
+	__u64 read_addr;
+	int fd1 = -1, fd2 = -1;
+	int result = KSFT_FAIL;
+
+	log_test_start("Longterm GUP pin is isolated from fd2 %s",
+		       stop_fd2 ? "STOP" : "close");
+
+	fd1 = open(GUP_TEST_FILE, O_RDWR);
+	if (fd1 < 0) {
+		ksft_print_msg("gup_test not available (%s)\n",
+			       strerror(errno));
+		result = gup_test_was_available ? KSFT_FAIL : KSFT_SKIP;
+		goto report;
+	}
+
+	fd2 = open(GUP_TEST_FILE, O_RDWR);
+	if (fd2 < 0) {
+		ksft_print_msg("second gup_test open failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+
+	mem1 = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	mem2 = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	read_buf = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem1 == MAP_FAILED || mem2 == MAP_FAILED ||
+	    read_buf == MAP_FAILED) {
+		ksft_print_msg("mmap() failed (%s)\n", strerror(errno));
+		goto report;
+	}
+
+	memset(mem1, 0x11, pagesize);
+	memset(mem2, 0x22, pagesize);
+
+	args.addr = (__u64)(uintptr_t)mem1;
+	if (ioctl(fd1, PIN_LONGTERM_TEST_START, &args)) {
+		ksft_print_msg("fd1 PIN_LONGTERM_TEST_START failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	pin1 = true;
+
+	args.addr = (__u64)(uintptr_t)mem2;
+	if (ioctl(fd2, PIN_LONGTERM_TEST_START, &args)) {
+		ksft_print_msg("fd2 PIN_LONGTERM_TEST_START failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	pin2 = true;
+
+	args.addr = (__u64)(uintptr_t)mem1;
+	if (ioctl(fd1, PIN_LONGTERM_TEST_START, &args) != -1 ||
+	    errno != EINVAL) {
+		ksft_print_msg("second START on fd1 was not rejected with EINVAL\n");
+		goto report;
+	}
+
+	if (stop_fd2) {
+		if (ioctl(fd2, PIN_LONGTERM_TEST_STOP)) {
+			ksft_print_msg("fd2 PIN_LONGTERM_TEST_STOP failed (%s)\n",
+				       strerror(errno));
+			goto report;
+		}
+		pin2 = false;
+
+		read_addr = (__u64)(uintptr_t)read_buf;
+		errno = 0;
+		if (ioctl(fd2, PIN_LONGTERM_TEST_READ, &read_addr) != -1 ||
+		    errno != EINVAL) {
+			ksft_print_msg("fd2 READ after STOP was not rejected with EINVAL\n");
+			goto report;
+		}
+	} else {
+		if (close(fd2)) {
+			ksft_print_msg("close(fd2) failed (%s)\n",
+				       strerror(errno));
+			fd2 = -1;
+			pin2 = false;
+			goto report;
+		}
+		fd2 = -1;
+		pin2 = false;
+	}
+
+	read_addr = (__u64)(uintptr_t)read_buf;
+	if (ioctl(fd1, PIN_LONGTERM_TEST_READ, &read_addr)) {
+		ksft_print_msg("fd1 PIN_LONGTERM_TEST_READ failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	if (memcmp(mem1, read_buf, pagesize)) {
+		ksft_print_msg("fd1 PIN_LONGTERM_TEST_READ data mismatch\n");
+		goto report;
+	}
+
+	result = KSFT_PASS;
+
+report:
+	if (pin2 && ioctl(fd2, PIN_LONGTERM_TEST_STOP)) {
+		ksft_print_msg("fd2 cleanup STOP failed (%s)\n",
+			       strerror(errno));
+		result = KSFT_FAIL;
+	}
+	if (pin1 && ioctl(fd1, PIN_LONGTERM_TEST_STOP)) {
+		ksft_print_msg("fd1 cleanup STOP failed (%s)\n",
+			       strerror(errno));
+		result = KSFT_FAIL;
+	}
+	if (read_buf != MAP_FAILED)
+		munmap(read_buf, pagesize);
+	if (mem2 != MAP_FAILED)
+		munmap(mem2, pagesize);
+	if (mem1 != MAP_FAILED)
+		munmap(mem1, pagesize);
+	if (fd2 >= 0)
+		close(fd2);
+	if (fd1 >= 0)
+		close(fd1);
+	log_test_result(result);
+}
+
+static void test_dup_fd_shared_state(bool gup_test_was_available)
+{
+	struct pin_longterm_test args = {
+		.size = pagesize,
+	};
+	char *mem = MAP_FAILED, *read_buf = MAP_FAILED;
+	bool pin = false;
+	__u64 read_addr;
+	int fd = -1, dup_fd = -1;
+	int cleanup_fd;
+	int result = KSFT_FAIL;
+
+	log_test_start("Longterm GUP pin state is shared by dup() descriptors");
+
+	fd = open(GUP_TEST_FILE, O_RDWR);
+	if (fd < 0) {
+		ksft_print_msg("gup_test not available (%s)\n",
+			       strerror(errno));
+		result = gup_test_was_available ? KSFT_FAIL : KSFT_SKIP;
+		goto report;
+	}
+
+	dup_fd = dup(fd);
+	if (dup_fd < 0) {
+		ksft_print_msg("dup() failed (%s)\n", strerror(errno));
+		goto report;
+	}
+
+	mem = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	read_buf = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED || read_buf == MAP_FAILED) {
+		ksft_print_msg("mmap() failed (%s)\n", strerror(errno));
+		goto report;
+	}
+
+	memset(mem, 0x33, pagesize);
+
+	args.addr = (__u64)(uintptr_t)mem;
+	if (ioctl(fd, PIN_LONGTERM_TEST_START, &args)) {
+		ksft_print_msg("PIN_LONGTERM_TEST_START failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	pin = true;
+
+	errno = 0;
+	if (ioctl(dup_fd, PIN_LONGTERM_TEST_START, &args) != -1 ||
+	    errno != EINVAL) {
+		ksft_print_msg("START through dup fd was not rejected with EINVAL\n");
+		goto report;
+	}
+
+	if (close(fd)) {
+		ksft_print_msg("close(original fd) failed (%s)\n",
+			       strerror(errno));
+		fd = -1;
+		goto report;
+	}
+	fd = -1;
+
+	read_addr = (__u64)(uintptr_t)read_buf;
+	if (ioctl(dup_fd, PIN_LONGTERM_TEST_READ, &read_addr)) {
+		ksft_print_msg("READ through dup fd failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	if (memcmp(mem, read_buf, pagesize)) {
+		ksft_print_msg("READ through dup fd data mismatch\n");
+		goto report;
+	}
+
+	if (ioctl(dup_fd, PIN_LONGTERM_TEST_STOP)) {
+		ksft_print_msg("STOP through dup fd failed (%s)\n",
+			       strerror(errno));
+		goto report;
+	}
+	pin = false;
+
+	read_addr = (__u64)(uintptr_t)read_buf;
+	errno = 0;
+	if (ioctl(dup_fd, PIN_LONGTERM_TEST_READ, &read_addr) != -1 ||
+	    errno != EINVAL) {
+		ksft_print_msg("READ after STOP through dup fd was not rejected with EINVAL\n");
+		goto report;
+	}
+
+	result = KSFT_PASS;
+
+report:
+	cleanup_fd = dup_fd >= 0 ? dup_fd : fd;
+	if (pin && cleanup_fd >= 0 &&
+	    ioctl(cleanup_fd, PIN_LONGTERM_TEST_STOP)) {
+		ksft_print_msg("cleanup STOP failed (%s)\n", strerror(errno));
+		result = KSFT_FAIL;
+	}
+	if (read_buf != MAP_FAILED)
+		munmap(read_buf, pagesize);
+	if (mem != MAP_FAILED)
+		munmap(mem, pagesize);
+	if (dup_fd >= 0)
+		close(dup_fd);
+	if (fd >= 0)
+		close(fd);
+	log_test_result(result);
+}
+
 static int tests_per_test_case(void)
 {
 	return 3 + nr_hugetlbsizes;
@@ -507,6 +750,7 @@ static int tests_per_test_case(void)
 
 int main(int argc, char **argv)
 {
+	bool gup_test_was_available;
 	int i;
 
 	pagesize = getpagesize();
@@ -514,12 +758,22 @@ int main(int argc, char **argv)
 						    ARRAY_SIZE(hugetlbsizes));
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(test_cases) * tests_per_test_case());
+	ksft_set_plan(ARRAY_SIZE(test_cases) * tests_per_test_case() +
+		      NR_FD_OWNERSHIP_TESTS);
 
-	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	gup_test_was_available = gup_fd >= 0;
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_test_case(&test_cases[i]);
 
+	if (gup_fd >= 0)
+		close(gup_fd);
+	gup_fd = -1;
+
+	test_fd_isolation(true, gup_test_was_available);
+	test_fd_isolation(false, gup_test_was_available);
+	test_dup_fd_shared_state(gup_test_was_available);
+
 	ksft_finished();
 }
-- 
2.43.0


