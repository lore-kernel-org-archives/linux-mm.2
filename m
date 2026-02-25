Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356C2F5543E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912F56B0088; Tue, 24 Feb 2026 21:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBB66B0089; Tue, 24 Feb 2026 21:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3EE6B008A; Tue, 24 Feb 2026 21:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9556B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:31:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FDF08B428
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:31:07 +0000 (UTC)
X-FDA: 84481401774.06.81B3F9D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1CF9B4000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:31:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KIOm225O;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771986664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2801qCJ7bMDrUhFOo3f8FJF1sy4Qo2e7DDjcSU4EExo=;
	b=Mf1viC7578Z54NKJyEylKxirYkatpxabPmpOrhTMakbxV6pGlN/mPXpOsMLk0c0/MaN8u0
	xkofH52oOIC6KK4hNt+zXqttVmqMWM5hnlkFdJPAT/P4Exv59GHvpV4NJsNE2e985V5VIb
	RjAwUoU2vQKntfId5nZXrp8T3oe0Lwc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771986664; a=rsa-sha256;
	cv=pass;
	b=a3WG+Ov9oEGElopG+7npJp5KSwqcQk2Gd2GdYCbVG83GcYf1V/I6k20qmw+lAupjlNG4O/
	3or8JKR6W3Y8TeK0ZZE659xYcW1/0LrOsuUcZaW9AbHLRzZ2NR+8ZfNMQShM1/qrz8hS1f
	Ei3Xp+odI5bq+jDOm0rf9CtvDPyY5iY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KIOm225O;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEbrGDu2U3FbaqwmsicQsCnu40B6Ok4hEBDPF1vv1/PrMpSTmsMI6nJE3ZCTVaPxat1m6eKqYaEoOsHen+EmceMzRr3x76lbu0EjcFlZIryxVaQsvmlyGG6LVzdPfn3d3b5LNiYogOa50AxtEoq2Cu78zYXqrRITL/yDiwJl9kZuYC2XFxMxWQjRwtyhVqhs+X/XNbPg3psDZjkkF211LMpSBm39tu2/MIFIm7Ey3QORDRnYON189LBTtD4HGA+AAz2t4zafYJUU0t8dbyPnscaHktSUWkL9QvXc63o8dx86f+rd240GxHJwfxooNARfzrwLFB9D/1vDSOMGCYDPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2801qCJ7bMDrUhFOo3f8FJF1sy4Qo2e7DDjcSU4EExo=;
 b=SiAHiTx+VE+Mu5hlmrwF8qH4virICjYd+zDJWATBip1UCR36hdcNW7gKToNec1Sm3crqmoi7IDUaSbo3unJgeO/xZ/RVIpkxbBFYNCLmysuZb4sHF5TWDJ1FYdHxo+vTD4kswBiCTgyGlxkp15oPnY7Vd+QFcj72qgxfnQTCHh472ZOOBRRl8Ro5OwslSU/Y7rI9t4C8+Dk/c1ByXMlafXpNbdtNkpcf0aG0SWfxeBUABBZdc5C+8N6m8EmOep9Zmq9frB4jQTOAPNULDIDdf0Zpj8zGSzHJXQltFiMGSvWhMVUX1P8+g4GHoM89bvkbU9ZsdpMfrbQHMehwZ5X4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2801qCJ7bMDrUhFOo3f8FJF1sy4Qo2e7DDjcSU4EExo=;
 b=KIOm225OZhUoTd2TGWu68wMSlgGt6D/wQKQ3szZdQEqMij5/Z4gFEOh0ymsrA7lIIpEZxJcPSjD8ICYhfW2USgodHodbdSUhRXVT7Lx9Tu7Knk3ywe3HorK3BtR84u8Be7/ksicgpECSiJTJci7BU++C3x7TgJrsXJEJGE7M+erCpTJkxpbvIXjoBoSL2ZSz2nGLaS8RLelk+4M8gRlkQa20WZQ+xeXVIg2kNdKyIsmUhGHaueyxMpTZ06z32dZs/XT2sF+sW5iuaLpN9IAyZYB2xpR08wz53bbCx2gwnufi/c528XJVZ3zJr94eTyNEoNoP9Y/WPmrgP7lJ4Tc4sg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 02:31:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 02:31:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	SeongJae Park <sj@kernel.org>,
	Ron Economos <re@w6rz.net>
Subject: [PATCH v2] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 21:28:52 -0500
Message-ID: <20260225022853.2347732-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0333.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa87df8-cffa-4624-0566-08de7415ea09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6FP4+6Jrks5yp0XX+3/iKUp47caF134VsOO1Q0wIRcFr170KK+nuacR1uw77?=
 =?us-ascii?Q?pZ1+rzSXxjSsNFh9txmda1b4zMojsYZeE2u4ZeceR1J9q4XoL6l1ymkIMqmh?=
 =?us-ascii?Q?weit07KrkBqf9IdU9cWR1AGHzqlm4nM/QGCyZap/ZFNFqkjpgaYKG3DwiXyE?=
 =?us-ascii?Q?fphH+a2+Iw3XlcNUApPaMlv2ke38NlG60sFh7UeZgPoymsrrWhst0Icf/c7l?=
 =?us-ascii?Q?aRLLVdAT3MZ6+vSwcAN5wQovda9JbIdhRT0iXejW6fecEgSPYfCiDoGOjz5n?=
 =?us-ascii?Q?wZ+HSFEvej9G7uwVRI/p/mDQli4kT+WW96XZmosCNDhpiszWGyBsiHEBWIWz?=
 =?us-ascii?Q?xk+LtIBGeZ7cxpM7B6sPtWpmGqmh5N0xOL8aIZh2h/Dj/0qPcZov3g2kXVX0?=
 =?us-ascii?Q?eIRY3b/2Fs0kAVluk6BPDf/pN4KBDgZk4MJ/NeO/jlTUzueSteEdFMwgRMUD?=
 =?us-ascii?Q?LgNMibr+icNpsxlXP8NOGPjHiDlun5UgOaT1nng7imkaj1bGr7BbwiU9lJxX?=
 =?us-ascii?Q?8BkJe4SCHGAT0D8Lc//EpG/y3cGhMFGy1AFnemjqBxIM8ILSC+1jSTnC2MdV?=
 =?us-ascii?Q?NBOPvYwye3yBdAwl0wfuM6KM7A1cQj4BQjJXgD0W4t7WhYGW3F/njQiIBV41?=
 =?us-ascii?Q?TYc23/y2Gb5QXNNXHZ2jTjM6x3Cd/0wY9EV3E+9SskxM6cUSGdwPtTI35UPv?=
 =?us-ascii?Q?s3BexbgHCDnC6ycKDk+ywDJlZqDs8x2FCI4VG4di9V/l7hXNdSN11QAT4l6q?=
 =?us-ascii?Q?ojoRlWWOA3NwgCtCmDDcUNEDw0E+EFZk7NKb9pllD9mftuw2GfVoXUMzmM0m?=
 =?us-ascii?Q?N0KcFA044IqybGSXxiuajQNs+cQ68kiHmZh6XNYHsmnZnQWohmP+mXKUnZM9?=
 =?us-ascii?Q?0ka3hb9VQ4z6eRK5eAbEua5wIzyBV9chIeqYi05SRUilhU7xsrPFZw50PHkH?=
 =?us-ascii?Q?SMtLrS9KN+rPXjwlrGOjBqnYyCiI3emC3bkLebMmYoHwZn7uCLqV0qeL8/Ac?=
 =?us-ascii?Q?8zXcTlHlvRttwhjYf1Gr6UchXG0PspeN5s0J5HjtQQutP2NuJ4c0nM/vCa5t?=
 =?us-ascii?Q?Mf/tXklc54iHbZTZHETVV4U00vwvY/BqTvbxxp7VgrpDIr8vKcAXf1QA6Thq?=
 =?us-ascii?Q?dt7ljKPnLT/LG07cTUGDuuuz/4RMjQf43fNfJE0JBDziCFBkH+XlYO72zTXK?=
 =?us-ascii?Q?QpsH9am3FPQKqtLyf0yte0kGHH31B2CCe1vshtyEeZku6YovJKhGDWNlUwS0?=
 =?us-ascii?Q?V9ScbEefckCHNk0c9EM32PEf3Awb4L8HbIV2xUZz9jyycosCUCSPc6fX+OlK?=
 =?us-ascii?Q?td0GXn6+umDrPaauidFhLR9fkBSK1HCP2SYRFfsaCxn/7PnNu9Kl61WGwqY9?=
 =?us-ascii?Q?2Mfg984m/kwScs0g09w23fGmtbDltN5qbLJaq65Y47qpzRIpZK1mr0rpqJZw?=
 =?us-ascii?Q?IJHK9KuZ63PCJi0FcZXvDg4bc+Q7hJpmq6dMm2lLlVGOXSR0xiuGMsjtkMLA?=
 =?us-ascii?Q?b6SchL2EqoqRpz4TbLa+RdXg9YjgQJYcPPyydjsbtATSnW3EYMLCu5tqbDT7?=
 =?us-ascii?Q?IOo/eGsOMh2lN9q1nnM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XT7xDx4lyRm3EAyhMVUIxDg7IiDIl9g1R6prFF2aybGi9u0pF/yviL3qaiqo?=
 =?us-ascii?Q?CyHVah13qxc+bgI6FwchXbnoysn3ZDjsXhugZFgpTczTH2agvnk1VJgLIVGS?=
 =?us-ascii?Q?8CitulRGHwoVdF4IrzEXOKUOcPDPFvyGfFA09TGRLn44GnC9pA4YHEf2XBUV?=
 =?us-ascii?Q?EXNNyeDB2APnepwdrCr3xk5AKRhaTS6O65k5eugxb9s/aCOQ3FlGLGB5ogSX?=
 =?us-ascii?Q?LBX6YBGGMS5R3cs92Zz7a1B/lxoZw6vJsqb4HhA6Id58oe+zddPfxfJREyFM?=
 =?us-ascii?Q?nlOMIoJWGVSar/RWIq99fI9dSdlP0I3BuuUxms5BHGu9WRAbPvZYLG8cho7x?=
 =?us-ascii?Q?r8aykrVy99XjnjC5BywFsrVDFjYsrt4FKGHB6S5tewW5Ff3Ix2vLVWOg8sjE?=
 =?us-ascii?Q?rfz1sWAqRhXxUFsrN2N+rq0V5fKrmf3bj0y3viZIlO2jGlXHL0vrHUXDrtxo?=
 =?us-ascii?Q?Leo1ZH3elnhZFOjajJTWQS0ff21FnEAH4f3HE4mZ05LXlxRR7Jd72MxkSVkh?=
 =?us-ascii?Q?SpGXe20rn214Ph110uRJI9L/caXHzI+9150Mdlc9UdtYH3ZIm5UM2TBhe+0H?=
 =?us-ascii?Q?ZlU7EuPxpUenn5d3XJsdgnu7OjlmL8uNHCz4ViJZ0rT06umu90+nHLB8SI2j?=
 =?us-ascii?Q?zXdIgqw9YVsk8zcDnYlvvxiIy4CwjOhDcV715EmIghkIcFbv+FNcfUPw+EHe?=
 =?us-ascii?Q?Wg1tKYTLO2dVtYcJwvTujFsFHo6u5mk0TZ3merBeRnidBCYX1faKBR/wn/0A?=
 =?us-ascii?Q?tGCsRKZU2X8EJQBOguPV2I+cmcbLQ+1/OzDgxaHXbbcS06Xen8Nkpve3xpNu?=
 =?us-ascii?Q?BlwY86rmIFlWEGI92paltP4/t5ZSwVuelFXvqDNN2SbHUTNiztaDXAwtHNMf?=
 =?us-ascii?Q?ivj71fw0dyvx/WB/sY2wtkCwdO/Wrc0zMMxE1pRA1D3/Fp50V/8Inq0XymQz?=
 =?us-ascii?Q?lwOf7hrLLptlDMQxNnBnKnfllBbZoxH5blu6vQuWOwV6B1SfmIRF8wtmENON?=
 =?us-ascii?Q?XMIbzWmKExoT7UMF3aOgI6Ef7UZ49Ha/CoeJmReLYayFuDM5sbYpNGPixTLQ?=
 =?us-ascii?Q?ZyRXFVuz5T6lPISArzpdjTDpECWaY8ou8LFHdOwBmzt6AN4ua+gjCtnjq54J?=
 =?us-ascii?Q?lZSrK3lo7Je0/bpIVw7CQk8lC3x/OlVafCx77UzdEXqodPvSe659iP2+Utut?=
 =?us-ascii?Q?ApAsQFreNZjXfP7B2IMU+jtEk+euhN2a3FSDG38VZDnF4bT1Q04ZWl/dRTo8?=
 =?us-ascii?Q?+GUiTG3Y0HPlvn+3VmgwO9lGwsBi6u0ZvwybWJIG2dJy0JCA+efsATWDb8RS?=
 =?us-ascii?Q?UdtCwYKTwK5F6ls3w2FPN0mH0UzG3HzhjiwEyAOkzgP/1qf4InoVq+26BDQ8?=
 =?us-ascii?Q?C4qkou9AEQvHFOH+4CjOwuPOlLY3enVGD7ZGe7Z9wtHWPkwhQ0VLLE4+3sh4?=
 =?us-ascii?Q?ewirjhJkcwLi3i9+IZNWO8oh/7JEzVVqbMz4NDkXwAqA7ujo6hVBZs/k47kl?=
 =?us-ascii?Q?7c/GGkAOKr+mF3nglWfB85GXP+sTfeagkB3Dy01YagawGlm94y836VB4W3w+?=
 =?us-ascii?Q?xhIZGElecEODCDrS9dICRNae8sBrHPkClJTDZ+W+AW3hUBLwfZP5R1JCiNZ7?=
 =?us-ascii?Q?7vqL5LV+rBl54pAO9QgoVYS4ZublpqgboU5ce+HWDAK8c/IigbBWh7dcY8sU?=
 =?us-ascii?Q?kdHmnksfkGG2U4AeYFfPvb4eJoq96m4kziVrTuqGzYwmUi2+dv7UdfZc4x9N?=
 =?us-ascii?Q?+gMfbvdq/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa87df8-cffa-4624-0566-08de7415ea09
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 02:31:00.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+KinMb4MMcczbrDDPHsq9N1+D7l5ELH2AwwLmNLKd4I4Jbi6HvLrForqM2tft/X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
X-Rspamd-Server: rspam09
X-Stat-Signature: trd3p3kt5e9aytwmhta9gawc9w5nqt7k
X-Rspamd-Queue-Id: 1CF9B4000D
X-Rspam-User: 
X-HE-Tag: 1771986663-84462
X-HE-Meta: U2FsdGVkX1+9j+6i4/5FEmvTT0XhvMOki24u9vbbLjfJta9kXZIxh+M276bUGczfG6E4SkpJ3bkcjgdJSFvqrdT+3C26eh1jFTnRtwYzg1RBuq/OpZ+Ot84gQFkcwieMGU1Z8r/VmUtX/tHbvBchbbiYUrj0I3mFBJYAHawMUoBd+IuH60bHDK+gCvNFHw8JxyJFTlBWPxnV/bVeOsI1rq0mrz0oB/9OU5fgaTwusF5BZ+PvpvHwGW0HOlo7aQsILV6Bdtx7NqMbKbO4Ssdg1mc/w+SEteoO4bH6mhO8di5OaPbFkxlW2JXQihNTcM0H+loA2XISwG/OEtHI+DwP4rEiiSf/TZEUzeB2IFT4bcH6a1l2p109RiZ1ajj5t6C3VVjeYUD/0KeZ82wG6AE7UPwjbun1nYaX4kUiEwC1CxYd3JDy11N8wQAPc60Lo+EEYbBrC69z5LqJeXUsszU33wXGkRHmZwDScJkhI+9eWYbA06QeZvQ1F7cW+kmk27d5Avs70TLcX0BCV6n333BERcU0muWZrJDchBJxZWqcerKsLeQ4zxi//uBo6vJoRuosL8K4/otbwCpaYIKmM4WTox0o1xpgZwk9OvBgrSCKisaM3m7X+U/v+nbv0mZc5w/I6MxZN+JskKvhML8ups5wwetKKcipQ4zdeDwKE9g6Qq+LbT5j1o6CO5x2IzXWcEXE72yX6mXrf8Kyme21cb+787PZbqr27a33FAcgISMwT520pOucYh4mnJ087dRY9f8UvmXQXgeopBFTL7Xjsg5cB2Ej9hdGoleXRjs01NUix+HLd/TCq/IbviZ96H7lScHIyoE1PFPQsi9n3WyOlv/ulemmHLxutuqLuq5iIzhi8DAYK1YDtEIChUYbxfwWMOgdO8d13AK7irMiPFYQ50duWin1VzQ59qSd6KXKbkiMLAw89CJbPdGXVIlk9HWdPeaAvhv4MiPeXiAgVJsWSXN
 PJvs4fpY
 2LHyKf907fA29CGf40mgB2XhiCdTsRnnmYkgsCFWdSEk0joDV08OLHKFHiyfxT4jP3/XcMpNjIiNSV7cVLK9KjPUsE+IREp+3jhrru1nBhlVMz5mrccU9fPf/VrmUmHGmCICJYtAtF3GUdFOYvwqtNiP/oK60Z/q3KEan0D9kamAYN4YjkxO1k31FaZHNmBvf//5N8Rs4nvRyrbHfF1krJkF0FYQmnLN6I4Vp969Ek0YX3i8e9bfHmV34zdAZ2HBafFEAcgQzzAFo4InGS/oY5YqEpwaPZcxDUbWrYm/hqPQ8TnxuzPfZtdgHCKZzzKu/mbXbY1WQ5pEcPhxUqM3okTDvBiWWYFGQ6uh55ZDTfL48a+64cWrQUcQkwjxl+012hZkcL9HPT3LSWTBTXDxzW/JCiO++iMk8zD2AewMSThmjcRP+I2jvBzOfmVjuWb2RVwcKQ6kEuqekWfsAQLFuBQNWkEx7gBpVJnpE579Aopd6ReHlHIv8gcsaCE5GYAssYHyw+m7/mjpNCd7pFcsCYUUlQqA3L9Z+ob4c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
with side effect inside it is incorrect. Collect all put_page_testzero()
results and check the sum using WARN instead after the loop.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Reported-by: Ron Economos <re@w6rz.net>
Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
From V1:
- Collect all put_page_testzero() results and do a single WARN after the
  loop.

 mm/cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d..ea540d3f473c 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
+	unsigned long ret = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+		ret += put_page_testzero(pfn_to_page(pfn));
+
+	WARN(ret, "%lu pages are still in use!\n", ret);
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
-- 
2.51.0


