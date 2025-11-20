Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE04CF6497
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57EE26B00A2; Wed, 19 Nov 2025 19:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557226B00A3; Wed, 19 Nov 2025 19:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445706B00A4; Wed, 19 Nov 2025 19:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 324436B00A2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:03:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCBBFC066B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:03:36 +0000 (UTC)
X-FDA: 84129036432.24.A373451
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1843E1C000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:03:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rvV3iF7X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763597014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxL6wgBQi95hsi9NwyQ5dm3ZStjH3ctN395ACBiAeAQ=;
	b=1LStGqpedURmy6urDyNakkQa7hDOa9WtE4mUY2xtU+b9yAc7XqMno0++TY+lc+Qf+WPkEY
	vpk3VktTrQQw63JOz8BUnjrjyA3Dbjuh8749fHyMp1rsOwR6Th+eDQCo2M7wb9m5MlzMhm
	tUgb6zdhr6BFU8UirB8QAK3XeQRbh3E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763597014; a=rsa-sha256;
	cv=pass;
	b=KCcFL/791UXBg7Y9D4SdbWunPWAOrCa4ke2UnDHU2cgSGA9ktXNYFTpwzsSY2MBc5E9mUv
	n9RymrOx7Euh1bwvVw5O1DbEtdGuvPziQI9ucE2FM3Es/cGUkrPYRXUN/SGI20JsOStMpL
	ip3WMeRhoYSP6Lz+elHsEAnx4br+B+s=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rvV3iF7X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtSbu0i/N/9Z5Au3n3WKLmZJyG21TspoEXuTmpdn/B+hIHnfH2PAfX6JS4n/rh96ejnFRmOgURffcFJGaYfuqve2JeyVSrZyzGTpQzGSJ54lwRoO1P7h51Tq7ldVxfOBh3qJSPjWl/uU2u/tq/t+TFt8/iCUcf0280kTfsyNVL6AmF9evJqzRGF/JTiWskJd30mflXZ090KcpuaY/Qkjkon73G8RuVmg4GMuxApv9Kpx5O+8mC6ukBwyneaBvepUs6c36fxos9zzMzabcdpwyY3z2bSCbqJzEv/lWLVbrm73lVGz8WjXXCrFfleXVohG0Q6eUIyu+rJqV5kQ6KJbVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxL6wgBQi95hsi9NwyQ5dm3ZStjH3ctN395ACBiAeAQ=;
 b=umjMPUKlxEk489dspDVHB/r0aR4YHP39d2rHo8biwBp/ZYtfnXsYXZYbL8dQ4eIllvZSgJc4iIPibHU6lA2nPclHHSosj/3KJ+pZgDqaXq6Pyo3d9g9+RpRToxVuVtNW29Sk2jLijpxeG+2f7fzcJPYPTbytjFJhOQkXNjvWczYZ9+CcowSA4XQT457r+6m0faJQygAPMGfv4+IiwbpSoJfa+pGE5j7O+9UYtgmrodr7EaH/UkoJqC6Y0oYEdKUJg8cKzLF7monupESd+FP4QRWHcpHRvGJEr4DGMJHcvLA9T5iy5IzwZellrcX1UyA3xZjVDwKB1zmBYgpHIaQrsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxL6wgBQi95hsi9NwyQ5dm3ZStjH3ctN395ACBiAeAQ=;
 b=rvV3iF7XFmBk5bsqN7OMmytqdB5M7b1ugZAJAbFoaSoHG7kHjbe8+RjZ3bN+R2JZKvfTqz+AZ+/HV4ssoOXXrlNiNoSb3p5QmJci9eO/GGZze7w33RhByt1uAJ+gqOl8yllABKzZr4M8T77K2+EH6DLeX7/qXZ1eoqBA06n4znvs7JXIkyyvXWR5COlvWArDhflvJN9THdqrc50jnlwwqeUO+GrVJxxcFiHFZzuOuS4rgovuusvWSsf7AOwwNexB8mlSWLYINMiV41FkCKeBk4o/C4M3fpYlglTRqrhZqAvWU1B/nQMGBJSYm87UJ1HK7474Npw5eCgLfz+aRV9O0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5828.namprd12.prod.outlook.com (2603:10b6:208:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 00:03:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 00:03:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
Date: Wed, 19 Nov 2025 19:03:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F60955F7-CD03-4989-B570-061281DECCD2@nvidia.com>
In-Reply-To: <20251119235302.24773-1-richard.weiyang@gmail.com>
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:208:32f::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d857c9-f987-4f2f-08a4-08de27c83d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TSvpBa1mXNBICbCkDnmiyD40xWbxPq9Cl7+iNwigxzf0EsRISkS+Hpj8sbmT?=
 =?us-ascii?Q?x9ZpxxZbpbBgd8q3JbaodixM6aOpMwYoLL+eyjxNjGo5e+VK9k86QOq3kSwx?=
 =?us-ascii?Q?IKPRYtQx1YbG0D9MymTBp4RVEJyFfCgaBtrUNLCGUYIkZV2WIK/vtc1Qj9r4?=
 =?us-ascii?Q?txdUjf4XmMQ1zG1tRbugocKF1Vnv6+mhWqJ5Ku5UyhsF0mwsjTsYjcTVx8+b?=
 =?us-ascii?Q?soQtaHqHtJkBGGAkncGotvd5cptSFSWMPI17kQKdKPIUCds7Hjl2Ge84aWWR?=
 =?us-ascii?Q?CgAwwDR+3/6TPUokTVcHM0IGmlSqe2Bf+KyKu6ELSIIrMqDSYHBW+02FhE9p?=
 =?us-ascii?Q?MjSgCNQmh3vFG/CfuLV74DJRTJx+voL1uCFqjj42gZgSEys2fZJByNddMKt4?=
 =?us-ascii?Q?rjP/LNrxgRUnTxwLmiAF4bgPO+yz8NmTy7fzru1cr8ymTUUV6dMT6LXu+uoO?=
 =?us-ascii?Q?qYAkXoQeI2IIM8XrHxGRW6Qliwcl1VjkjwfbNZIf7F2oS4GLXd8dFr6RTRWo?=
 =?us-ascii?Q?Z3Onngb/7CfvzSJzv43aUKDR3nymumgbYaUpaV1AQO/MR1T4CPFvMXnkKddp?=
 =?us-ascii?Q?JG9oltCXZffRUecxwP31HhVor6yZmyrw5Gwp0tAhPK0Q1hNgcvmy1prmsmuk?=
 =?us-ascii?Q?PiilWOLkNcsWqOfNiyaBjQN+jqvX+FKvg7R6IESilbpoErvcYMaYfopwYsvV?=
 =?us-ascii?Q?Lnai4ua2MMnQ5z+tPl3xHfBVIPhnp+Ersw5aNkHvaC4/O1xw7QKXoA9peG2o?=
 =?us-ascii?Q?UbjNvFisPOpUJTsVg+MuKicW/BhzzeDE/IExFYMR+MUwBrO+5wNyDXaxzRio?=
 =?us-ascii?Q?AbRrjqdGPY/CLgvRnrFOvLsRLex/N/p2CvYoX1M29WJB/fVNkSL7rx8cL03y?=
 =?us-ascii?Q?1cBmPzWItWAPxWcHl5QVDUGhmWL4utKXAOqfzXKlOGD9+YcA0UFnj44rCP6f?=
 =?us-ascii?Q?JxSt+tIuUxrBhwqdqye0+d3t6v3f621H0Zn2lA/4fjzZcMBFMlikLeK1DLuD?=
 =?us-ascii?Q?r1dXsWVRNkOVzC/pKK8DPfvWZmwnrcj1/ysyYdLtH7nxd9VoHUY3zPAh7c50?=
 =?us-ascii?Q?Q4BTajZWXj1ly3pLqnwo0+fqVDU62Zj9FdOHSJo9d7aMmeNemFjhG30TVVEe?=
 =?us-ascii?Q?6/oxQK8OPRkhpLPegOt7IQQQAkZ5EKciOH+p8ACwNMbABwuTSBGl+NUON4eT?=
 =?us-ascii?Q?zKPyIPruCy48WcCPnAQ58yduw/IEZ/zYhmV3O339FZS3PHatOfR3XWasmVRO?=
 =?us-ascii?Q?reycE3kJnP9yS3eJJsbZQzRvLJMDRWIK5lJQfd3LHJt7RvfDeYp47Qn+SF3K?=
 =?us-ascii?Q?RSARLJNZUzFHW8V/UvbJxyjGXihZN62UysKgHV0Ww4M/QFgS1OypVpT+N+H5?=
 =?us-ascii?Q?S29yzHp075uv331lI+AGRiMME4AgveiXyVnyHbOvWmLMMy6SKl2dneW6SYM2?=
 =?us-ascii?Q?uEN4ARgb0/XsMyjKRSxw5g0lNgKPSO/j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x5gRQjjtbLUQYeN+kcB4HMPJMJhsB87SRgSF9DG5YKkKxeb/XJuR7KND/sII?=
 =?us-ascii?Q?7Kiw9nlaUa+FFyNmTQac90qn6hbWjvuON0UQbhSVE3OqYS7XtKbniBNUS6AW?=
 =?us-ascii?Q?sXt6xPjQXh95stNuFKHtdQ5YFKuKJP7MUhIJJTLBSm7OqiDTMpAjKz0fYH9Y?=
 =?us-ascii?Q?8njDoBV/8iSYIoFAoStP1g/oyAd2UFVunmh1fGjGZshxv2h5GgKApWYkQX48?=
 =?us-ascii?Q?LorZE50RllCJiFZyA9CRc/xXwxyfytK+3kQZsuQflMrz1u0k63Jl9DyqqTHQ?=
 =?us-ascii?Q?ubprRn0FezB09WSQeVCdAd8wMwZ+wS4vsiR0gOPsbCeX3v2OrI/WTbVdk3aM?=
 =?us-ascii?Q?zzPjrt+8dJqHaMGkv3mhFoKD/I722LttPpbzMzXcz4SV0pqBYVY6fdBkLY+/?=
 =?us-ascii?Q?0mEsJRuGl6giuQh2HFld4KcIutsX5Pw796mIWsx6+TCjMZx7nSSYUqs2ntK1?=
 =?us-ascii?Q?W6IqFzCTOvoi/bKEr0VOEJm8WspIB1berJxNF7dz6gXFNZyJhyorneTLCsXY?=
 =?us-ascii?Q?/EseZK9mWABLu0+cQrrYKQVlGQUYCzYcTG+ZceP0fOSy0qexVIV+o5j3xkxl?=
 =?us-ascii?Q?FsjgS0zLfnlrPktlhJLTzRrhQjkMqcAzSYiQr/hhU5DZLtA99KGWCHL+yfOj?=
 =?us-ascii?Q?WvC5sSd8fUO0JbYChNoYQ81oYmiIEWVlz+npo4mqPnIc/V7cpwZ8+wzuJT0X?=
 =?us-ascii?Q?pl2IYMx3RxsVVPzghEYNRCTGkDIWKNn0E8BxPdOxZZZ0WSRuItb90BNPqc9T?=
 =?us-ascii?Q?51LzVDRZITfwVvViZkhsorTcKwK8SBK/fkZuLoh5kJogMN2fOAC+f+3jOT1t?=
 =?us-ascii?Q?BzP8aZsHsgk+ZOsJSyFTlpeD/INrhTOGv7fP5PSWXDL8cqxN6An2SNfczDuB?=
 =?us-ascii?Q?2tzOX+/H+EOhcfsUD61JD5PqoBk9wa00sTEDyPPorhwaQjH/GCXKtx9X5AXZ?=
 =?us-ascii?Q?C3zq+IZPo08l+D2VPkwvbfe/omd8rVVxeRuZwhqH9ypoBJMa/yYN6SuBAKeF?=
 =?us-ascii?Q?gdgifDdrpVTRkQQy9F4tzhsioNovzcKVfO/GD6M4yGLDQ7BFc0NxXdd3KbpR?=
 =?us-ascii?Q?t53FDjOIutd64d8qUQjGjj3g19FHra/i9Jcl2RKXr3oK8e50i9HPLD+tZEea?=
 =?us-ascii?Q?Iek2pserPwY4pBEP8uMrPLS2LPyLGdBdwKOeTxHEZL/iJJ///YYamvqwMtRH?=
 =?us-ascii?Q?GdON4XvIBSfepS15vVKHudAn2Jpy82GHa1Cz5SIDrhgxhx9pj6RveTekY7HC?=
 =?us-ascii?Q?tD/bvCp9wqhnO7TLnzekXlxeWt0tRDdUiqKJtTk5vMUfu1pyi1Hig9LuYpmH?=
 =?us-ascii?Q?DzCwZuSm6dEi7CHCkVLSL2YMMUbJUFPnQ83rbOIfGyiRHEUykLVIuembMzfs?=
 =?us-ascii?Q?de2j88UWI+82zl3Y3LsgMw0HodlRNqb36GdiOj0XCqCjAS+rGKxvarew4IdI?=
 =?us-ascii?Q?Xm9oLvZnfjhD7dnSxc8cSAZgw+x/b06SK1Hzr2ErZVaAmnxP1NzpheNa6uH7?=
 =?us-ascii?Q?LBI9fD2a9/I4Q+xGWZCafmykfgjCCPypD9NdTgln62UWX4dejWCrF7g+4Vfw?=
 =?us-ascii?Q?OydzvsXnzaDD3zhFnD94OMh1SuzieiKhnYgzXLiR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d857c9-f987-4f2f-08a4-08de27c83d16
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 00:03:30.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cq9HzQ5KYEZhqTqTd4Kl2LOvYUOgfL+k+Tt4zHIP+bv3lYFKPE1C406g6FGRLZEf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5828
X-Stat-Signature: ke9sxkn7fw8okesqgaihzjgtf4brcrex
X-Rspam-User: 
X-Rspamd-Queue-Id: 1843E1C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763597013-758331
X-HE-Meta: U2FsdGVkX18S2ZmKexJdSIZHRTmbXK5MLq/G2qvfHHNaJpO24hSdRDUrjZ1cWE/xs64SUT83Xm5IieCWG9NrWu/l9C8auaE9iMt9G47biZtCXPxb8NKhNd09OYWVqLcobGB13Xex8bL4z7fUdeGXFqdJZ7JWl6/vJNeoxdvZWnC4iLupvX3ywF5Eq4cn8bgL2gAugTAghyBx6bJHaYdXgVLqALKU/v4FGn5KctNuKbzn/zUixv53F5CYKEyFTNKgsI/rhcqe6AJAfayPedJEy2ntvB8g0dNri1reiLR+aMu42Ed9AkOml9lhmPElCHAATeOMFKcJNp08H61J+RW9kV0N+Y/O26oSkq516j4q4wysOlpV/EQipLh/wsaxXXRZMH3hegdWgu5XxdvWFKutaVkALN6lFtYCOymYmt1Kjq65nX76HUO3E22cy/ZcEqMu2fKV8a5SM3JrHVesURoIRQ45/1W5GWigifMm8SYmIqdDqAWDy67HO74I8yR1nzcr/e5jEAWunh+EME50PnfviZZ05C/DpWE9qFsBQp2aoGnKcQx2BXfGy5dTi4pkGi8RHmvhgb883xhNQ6QQ0rcUOAVfzlQrZX+QnSz0ECtaq5rkvDleDJSz/1PtXrkEHslaOQN9ZQjiiwYqcd3CWPlFuPM86be5pDNWu3TNbixeltV0kAv4cMFxfkx31jVFb+qyucGSoK12d87YAEuv3DncVLHLeIs+aKiLmkwGtPq4tz7aNgto5QGqgz28QwAJ7BKS/qalDUS0DA8shm8hwb6O+ywuLCKH9IEvBua/ChlyTdhUdF/FGI+wIbqilmT7CjwpL3hvWNjKK5GKtY38zOsWaFL3RhN1cVCm9AWGOSqqFRD1hFyfPCCoDiAsUM2oulr4NszPwNUcfGwr9npSrQbyMrangyU47ThtzVWLrulLeABRHqj8igSn6cyW7dI/1lSwQsnkdKuNcSjdL1OekLE
 /Fg28V4G
 pr2MqF2jbljq477Hqvm8NdhopCjlC2etpfCXxcaKsOlv8PUTmnYSy3AGSyNVaGk4mbh9aWU7HmA30X5MxSLI/DzXOu9IvyaTa2VaslRYUH5022ltuaZDDc4PY2FHd9ipoNb7kYSi12iX+2P5dw4RNRhvMO324hzUCCEMGOgLiWwW/79bWEKyu2QiiZOePgKAhSIrLAPQx3DyO17PLjw4RAer5X8KvuRLqDwreQ+ewkRhX/frI104dVzDh+sn7T1ypkmjE0+ZJvZK6IDLdnIA7/W7fJwOI9sSyd61qsuQl1enpjmgM7NG0ZZMO6NINfePeGrB49xjGmLi7qt1Cc6hjWeVMbQzwYh5tvIKQEby3R852yv4r37CTfIdXUZK1IHSh0YX1O51F/FPnfNlQ+M0XiqOhd8JPs6ls5Hio8UC2EkNh00hrVLoWSEtpjIewLF+Aj/dDZs/53kvUwlW714NxpRpLq0A1e3eh3IxyJgAJLLxKCURQOi/8otXUdM2SDIGVFpWj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 18:53, Wei Yang wrote:

> Commit c010d47f107f ("mm: thp: split huge page to any lower order
> pages") introduced an early check on the folio's order via
> mapping->flags before proceeding with the split work.
>
> This check introduced a bug: for shmem folios in the swap cache and
> truncated folios, the mapping pointer can be NULL. Accessing
> mapping->flags in this state leads directly to a NULL pointer
> dereference.
>
> This commit fixes the issue by moving the check for mapping != NULL
> before any attempt to access mapping->flags.
>
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: <stable@vger.kernel.org>
>
> ---
> This patch is based on current mm-new, latest commit:
>
>     febb34c02328 dt-bindings: riscv: Add Svrsw60t59b extension description
>
> v2:
>   * just move folio->mapping ahead
> ---
>  mm/huge_memory.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>

Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

