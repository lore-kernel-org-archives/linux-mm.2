Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16A5C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973106B0098; Tue,  5 Aug 2025 22:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A816B009A; Tue,  5 Aug 2025 22:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A276B009C; Tue,  5 Aug 2025 22:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 733576B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:21:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC773135A83
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:21:00 +0000 (UTC)
X-FDA: 83744729880.27.CD64089
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0DE9A40009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:20:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KToWtHxn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754446858; a=rsa-sha256;
	cv=pass;
	b=R2BdZ8y1ezvRpCosMZbs66m6o69JPKHyvomHKzdTdvH3X7NA2o8aH/qzrCp2bzTfMNKd37
	Bq2C7YJwnAsLGMkSHFlIAQx3f3AFQFsxebBcY2V/CwNsWRwLX9K3YU0SjC+uKs/+C4JTEQ
	WO6NegKKUORzh1xGfvLGU00/yuKKDbQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KToWtHxn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754446858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BaQ4Iok6bUDf9ZHlL619OC7yEIrLQ/9M4cmxQQcv3bo=;
	b=VuoO6KGZGior3d296lvEe+uf8ENpXrBY0ckxQG8UJlRxOxLdJ3LlXdAeISqo9jAXoJx41Z
	2wuLf2Yzf885ohDxyYD6BMEaAU2RHQFOtYHjX721UmG5FA5oXtl4ISVyri16LWQGd0qVAv
	g9p8tCxLY1NqLLElj06qbA3Vu7PEXCw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DeVYsP5q1DK0XklkeVIyW4Ef3Ly+hmqfvXkJdDqzRMDWvI/e46gPZ6iyaxXw3ur0k7+5Pl0aCSVMVvj7aS6C6zJNj/y4Yw8kjv/Hq7QBl9VZVzAtvsM/+JcrzvFAtFdT1lsV5AFVWz025D3/jJox0YVwyEY5ZM1JPe9Da14ypVT5rBgFS14kVxlmjNtXBQtEAFrIW8jp3A/L0l+QqdivnWl/aQACABogEel6f/REFmColwR4qKGwfWoJ3fQEt8YAKs2dtAyUCZErvYwEaLfl7E6n0OFZuG9DcRyRx2wNmMlWkRSjPV3Q1B4ucA/HPD2BnVA11nxxyW37VDBnDE+AIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaQ4Iok6bUDf9ZHlL619OC7yEIrLQ/9M4cmxQQcv3bo=;
 b=yLt2c8qpT05nwFX8eTUYpRX5/NGV0jmI8N+FsFTAeygqf7jDSSeMbxBCo78woEsGnyxpAtxZdVWy2FaXtqlbjelzM16PL+dIQD5JxmTuXW29+X3Yy/S2wexI0C4ioDKfmybtdNLkfK5zBLHj6F299al3+amnisjBVqGYUMrPRb2/WSEdW8WWZtsLocu9sBZk4oyM/L4s8NX0yDerQg85qCAYadVJfJzajihmc/sFW8czF+WNsVipEz6xDd4otH6abC/a5hT1dxOG2XF4sgD8cg9qSZfo+7AlKg4VrEN6vJsmh/rAas8nP7H1DVxdRlpoWxUIXiaPpMBL5tgxTln6aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaQ4Iok6bUDf9ZHlL619OC7yEIrLQ/9M4cmxQQcv3bo=;
 b=KToWtHxnfRGs3g8ikr9rDfADyXkIzcaN6swiwIe0tCnn+ySgEiaeVbhm6ZQ59c6HDuSvPanFWhRjNcLRi3Hpj2u1XNZFxpBVZtp2qxNFLu8xUjpu3xuXhG1PhOBO+triESz8Z1VnjGav/tI3SGZj+J37Y98jcel0as8EBjaicEUb7lgj945PYm9GJAMTWuvDWaJDaKn40VLKNBCMXy+pcvyszjS+8X52YcARTezY1nwNWTuRdoA5IKOOIecDbXSICZpBmR7ADcBOiuI9XYw06vOGHIvX+8FXHXTpPih1iOi2xJ7o4vJr3BUt3+ytbAsj83fip9qxJ1pM5gvhTtI7rg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 02:20:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 02:20:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/4] Better split_huge_page_test result check
Date: Tue,  5 Aug 2025 22:20:41 -0400
Message-ID: <20250806022045.342824-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:91::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe57fa9-019e-4285-232e-08ddd48fdef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xbXdpuBivnxHfRUfdjBK5qYlvyQCcz3l6gtgtkjMLtGeia/koOu0aYxdYzNJ?=
 =?us-ascii?Q?VaopzY/JnHrpoff3qdpiMy/qSO1NV/3Wi/GUVDFh8wOSm/k841oXH0vZmlzU?=
 =?us-ascii?Q?/o2/msSr73NyFzI4jo84h876hu5Wv+b22+M17Usbf4dAwzTwVhdUduBFemVq?=
 =?us-ascii?Q?pCLqvDtUYV1XAzzXIaW8DiHfZVzKO/mEvtQCR2Li67bR3B6yzWTLPUlF9Mcz?=
 =?us-ascii?Q?t9U4EMTsMj+u/LMrCOpWVzs287Ee7vTR7lexFsuZF6GVBb3qFrAtzqPjnlnK?=
 =?us-ascii?Q?gtwx9Jj/GGVAzJbNgCsQpjKVkrAM1Vm5Hd2qQcmhAK9bGesK+lVrmekwy/fT?=
 =?us-ascii?Q?lYiIWcd3Ty9otSD1SDEt+GiDNN5MzAZC/xZvePfN+uUmfCZ37UxygYueElFq?=
 =?us-ascii?Q?HrQrk/ww721jQeVv9bLAwBTzOVc/7bmATqhViJR6sXge0xRDxXDfJVsO+kIL?=
 =?us-ascii?Q?XJeDtz7rr/XOVIQRgO6vbowr2tGSxcVFB2ku5ttmsSBwE66WMkx3VKxgk8jO?=
 =?us-ascii?Q?cf9Lrr2L1ldcoolb0KLMw8jOYb3kNJWqfRcJGRjxXQLn2vmqUiL34vf8lJ7y?=
 =?us-ascii?Q?h9vFSu6bN+ogXNaBCryTUaSicETWF4TZYryHYHXvtwhF6VBbHCXuOQ+kOdTj?=
 =?us-ascii?Q?0kXpvG7pLp3QgLFkb8GK7Ps7H/bj6MmNyrOKuF458nXxAnDLsg9szvP9ipho?=
 =?us-ascii?Q?aNMQUCU8D/9rpcv1/PvtXwg/YsOZg+aQ+xwvpJasUyla1Og5hKOE/f3fgYI2?=
 =?us-ascii?Q?gUsdObvS8HVFnxRCRFVG+iyssP5bFJB/QvbXbqXhPAyV4ipATQZ/P37vysBv?=
 =?us-ascii?Q?VCP7u7JwhTK4gACNiof+L2TbSe5tW9wUELucz9w7yxrSA0d4VPjfDslICpiZ?=
 =?us-ascii?Q?mc+dOHJi5CZXhkN5ZG3M3Um0wyRXRVW9dARyGZR39zVrYr5fEPjZEo9OnFk3?=
 =?us-ascii?Q?IrLzYEly/KcRkXiS438ZqCpFsiDPE2fk9bB4fF3cPo0zbb9qlVhqzZmBZxm5?=
 =?us-ascii?Q?zjJWm2WRuQnusWjdB1Ev6WAqDH6rN6wn8VVR0DkcF0vKlhoRFssVoCTNoCAp?=
 =?us-ascii?Q?reXx7xO/gVvedy1UV60VcBpbl6hkuTGvXZ1tTEUlgls+RCpVtzkbcu39rePG?=
 =?us-ascii?Q?Ok0qU0Qb8rxmb4rGs9AHgiwyQwDthkczYXOwfQQxpWOdH2COWvfcPz/tR9tR?=
 =?us-ascii?Q?fjJPjR7Ny5GxiVeSC3tHzgdYm1lqnrA8/ZsIHd+lBsVOY+qVGLc+FTa68kPc?=
 =?us-ascii?Q?qqW3J7DT0DG7t1uXzSpVHoBVu7Uz+bNt6n/MieNioff6aR8H5pyLRONdQ/i5?=
 =?us-ascii?Q?01Wu9Y5eiM8YVrRZg6WOtJ2QhDA24FdbCL2lxWqjSvR7E2TCSFEbcMCMUsbu?=
 =?us-ascii?Q?6+FOltu/0T+hwwHo1ABN9xJGpFW+vOGhwvRjN382IUbch58ZTdcrAUmTmjee?=
 =?us-ascii?Q?Qv8J9H6JCtZC8SWmbktxj5PZghGOU1de?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P0Oz+RKaBoFRWcSKcb4vAc8dFGwkuwxKcZ5b7bgxsCszwxykOo8peiv/dZes?=
 =?us-ascii?Q?dhAQ3SqhrWLKX+VNDv3I/oxru7neTKSOLsrMw+y7GMXnzNpbTQpfk6x245Ng?=
 =?us-ascii?Q?BVjls1PhNE8b9gReYH5pSflXTC9OHMsn8XaqoclBN8fiAbKphie8OxZJRPnp?=
 =?us-ascii?Q?+nujxSz0cscBsy54MWBR29wXhx3yGAn+xftX905CH6hoDG+QNQTlC1OKdobl?=
 =?us-ascii?Q?qQQ83TLBPwotn9Ix6GCLhyCHVM9A6BdoMg73+vOQSIRG51t9QQGwiAAvRzzV?=
 =?us-ascii?Q?FFYQeAlSgm/95MlFRhPS7k1BhPwwG+C91kfRGaSdnEGGqOxXX8TKb7xmKPnJ?=
 =?us-ascii?Q?bMy4dDpn9/37cv+diTQdjZgunaEtmLIaurQgVfHUsChACJlozyCMCaiMXSMk?=
 =?us-ascii?Q?fgyhtueEaeg3tbsM3o+g/CRLfoqHxEqVE8D2ANu6defRurNlb1Fsp6HCVg5u?=
 =?us-ascii?Q?4LV2cwq2OUJWYDsYCjc1hfHKi2CAUbMHNxfJRtvvlNTrZee/d/7pK004prqV?=
 =?us-ascii?Q?pYTeHEJWDKoMbTfKH0eG/eSpI3iEQkyHUBPAAvdRGqSmEsYZG8oVbRXdOEsc?=
 =?us-ascii?Q?y1mCRT+33lCVNPUS45DwTd1A+B4XY1CLDTfU9omIbVt3Y/1fH5cVGoluehml?=
 =?us-ascii?Q?5yMt5Hq2ZIA0pM2SfPqjrhL8LA7yIEmkfgZJfy7Pz//I93QfzbyYF+tw77rR?=
 =?us-ascii?Q?qgnpheQcd0lg1tFIzxu6ga8bKYXjCC3/G0lJBbsY3sAHvAjwJ3tEoVS897H8?=
 =?us-ascii?Q?ox73+cKgCVvwahtTdEXXoAsDAGyIhvuhiBhT5CPfQMvb+AmuvBAzLKXcJA4S?=
 =?us-ascii?Q?XeMxI8rWDDrRP+prQqp+/p22Ami6Skl04bmdkUYaCcuiAvRcMi7XYraId+Ls?=
 =?us-ascii?Q?5IT17abin5SyifGTj9IpZuFzhhlJCZzLOa1XS2p/wc/Mc60VCdkMs99p8uNs?=
 =?us-ascii?Q?5zntwPM9Wog1m5SY/I6lFaS6EWXsxkkrVmki7BrbJhJCSKR61SUpEy1o+1er?=
 =?us-ascii?Q?TeAIjN9XX1ePE9WbA7zouafDHoLfFwuOVYLdBfy6DvIjCGALdh4bCxVuZVfE?=
 =?us-ascii?Q?TZ1ekPaSRKYPi0kBmX6BItruUiUJzQ7vsFFldHnSVgt9MqeJ44EmtPYfPcH3?=
 =?us-ascii?Q?tQJlT7kvgwm/RbSeRGaAJN9/E4yePc4p3ifn1CVVlfyAntbJ2NXrbxO7GDMi?=
 =?us-ascii?Q?rEX1bAiRHe8gm+4tIW6mywos7p9632D0AUXZudFNekaV/KRwqxOklR6eXeTD?=
 =?us-ascii?Q?cR3UliPkvfveA2XAwJeeK387kxUXCRqaVQ9heyAI+I1LS2N7hY3B7/09kvkM?=
 =?us-ascii?Q?ahetF7qQVvNO2f+6aAkBrDoK9luWB7odsoIBCpgrYjazY0lDF6bcWG7B1gmx?=
 =?us-ascii?Q?mDyg+lbTM0KFBbdAZJ/PU8ClA2XtiRQUXSvDxBe/ZmW0kIzfj0CXVnBGp6qM?=
 =?us-ascii?Q?U9bt3f0Ik/4SCN1rXb31gvrmgH/MbZ8775RuaOvZOh01IuNADDSGOEPeKdSZ?=
 =?us-ascii?Q?qbcnHsH0P12NfWZnZVRLs2yc28wR4SxWqRCOxJt51OBUlkbiJ1IHSEPqcfKU?=
 =?us-ascii?Q?pOBsgS7P7o7Ak+TL7aNBLptee6zj+uDvWvgT5q9g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe57fa9-019e-4285-232e-08ddd48fdef2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:20:54.3181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CysLFvFacT3PjGhSBLYaDcsVq9y9OmF4rWYKTr51UkM+fOMxXVwvy/H3S1Anz1Fq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678
X-Rspamd-Queue-Id: 0DE9A40009
X-Stat-Signature: u4k9zxf4ww9y1wx5chcxnuwhnnmut1gi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754446857-219495
X-HE-Meta: U2FsdGVkX1+iC7ze2i0FwbfZtXHZHBDjD2GsNh4gtWYORqlZHAcfZPbau7e9age5eLJIpkTeP7pijYwvYMAXRDcsOXQ0nF3B4IxWhe+xs7UAHGmmoidnivKFVIfENGtuQdM6cgM+A1eiXiNjRcpEPx3+Jl2LOgQPrM1fQEcBlXLWVNa0+44/Z9DrZvkgTzadunFKs5Cxj5FP35+G5ziHESJv5e4eWtdXUU2dqMrSlVqX2JwOyTctDJl2479TUXEfN3R5qD2ckFQ/V9NBKWLpP89nlQrags6XAKYg0oUV4mppDUTH4m7CznZQpvwHOUjKE7uYwY5Ztm0QMs6g7uHsgXyRYOgoKw9ts9T+vxlpICEzYK9xTBlvBu6yhMpPApNS67+DiCGgrimkYd4iZ01A/vAoZhLe2QeXkDjf3ppAv4Yp/oLNtg0O7aXbQV/p++gG92z+MS+VwXvWlgXQG63QUzxv72+QSJiRDdZGgvtkH+NPfL2pCHZlSBGGNFZowfdSj6sWoRCe6+Tfr2o0VW1uhfb0RMcVjW4sWFpc2Jt/mlGV+vaJDBkbxS5EE8NiCAbE1/FI7jJsYCY3yz0KBN/ozmytawZcB5I7v2mAVO/gfx4w59LCPX5wKODsR7JPxsmVyEPa80cCYRwtBAw7ZyROp3O9+7LUlDmSn7CB8UcHFKJDzGXDKrJPM9MXNwQAYC8BY23qvH3A1xARbAxIQfgewfRBgPXHDQJVNIkq9uSuBMqgcyCCx37npnaDslXUHqwYwRQILmrmbbtDqeCRz/1FI5PrCwx10BF8lmtrHVyYQ/kb6i1dsrU/ixOGfmbtpBELC6CtstrjlGvbOqgBs2K8NHNQ2+IdWiMVtfj0y48PD4Pr8UYZggixFH7Fee8vQrOzaqnTUlR1PXPZPWckftgrSOqO8j//+tKiQHSHQdENlFg332wPmicF2tDsmqvc7OWjzQghFpZS7IiW1EJsNU/
 x78mDMAb
 pGfXQK4P3x80ylvFp80ysdAm/QDu+nvUoO97ADT+gsrXbaIBZ5Jgz8FvYgT44up0oKE9p3k7pvFy9EKEyfbQYImcC0lnWM3PKjmnV8NjX9sed96VCoXGc6kv69dW5346UGzvncgNvGdp/bfl3+mHNMzW6vaH7y/FpRGLT2EbftWw5NPsW0ELblbzbqAALSOsXGiAavJq5eQ+x4+fCrRi8JfCPc6iSlfhlydOLeRgutJjJH0l917vkLEdYcPjaPD0z3tSb73YyiZXaTWMfECn09ZAi+om4kJcnt2fkuZ061r9TAketKm2mlFboGw2IF4DI9HrN2/hO4WrScMDAEu2Fip/qhw/c0JawxaQ6HnqhacPQickuO8RcOWrTpGbQxeYDA2bVSRHXeKMsoxKGj4Re3H67FCRTtx1q8XLy2r+cKJR4i/Npvi2KtWwW2CL7a0/btJxRRU8Z6VY9ryaFEuv3CrV4WpzXxuxHsT+gvAy4wam76TE2vxGq43VEGVCa9Q3aGdbDYi+qYB0dAwxnyFtfTJWZRGv9XTF206sEZr0T9uXtDPssdP9b+ohJdlFR9A23QpAA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David asked me if there is a way of checking split_huge_page_test
results instead of the existing smap check[1]. This patchset uses
kpageflags to get after-split folio orders for a better
split_huge_page_test result check. The added gather_folio_orders() scans
through a VPN range and collects the numbers of folios at different orders.
check_folio_orders() compares the result of gather_folio_orders() to
a given list of numbers of different orders.

split_huge_page_test needs the FORCE_READ fix in [2] to work correctly.

This patchset also:
1. added new order and in folio offset to the split huge page debugfs's
   pr_debug()s;
2. changed split_huge_pages_pid() to skip the rest of a folio if it is
   split by folio_split() (not changing split_folio_to_order() part
   since split_pte_mapped_thp test relies on its behavior).


[1] https://lore.kernel.org/linux-mm/e2f32bdb-e4a4-447c-867c-31405cbba151@redhat.com/
[2] https://lore.kernel.org/linux-mm/20250805175140.241656-1-ziy@nvidia.com/

Zi Yan (4):
  mm/huge_memory: add new_order and offset to split_huge_pages*()
    pr_debug.
  mm/huge_memory: move to next folio after folio_split() succeeds.
  selftests/mm: add check_folio_orders() helper.
  selftests/mm: check after-split folio orders in split_huge_page_test.

 mm/huge_memory.c                              |  22 +--
 .../selftests/mm/split_huge_page_test.c       |  67 ++++++---
 tools/testing/selftests/mm/vm_util.c          | 139 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   2 +
 4 files changed, 200 insertions(+), 30 deletions(-)

-- 
2.47.2


