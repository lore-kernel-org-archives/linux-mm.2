Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE472E6BF01
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649306B00A0; Fri, 30 Jan 2026 06:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A2A6B00A1; Fri, 30 Jan 2026 06:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1306B00A3; Fri, 30 Jan 2026 06:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3656E6B00A0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:12:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E59BBD496D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:54 +0000 (UTC)
X-FDA: 84388367868.22.F3A9C36
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010049.outbound.protection.outlook.com [40.93.198.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1B82340009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JBPEgxA+;
	spf=pass (imf12.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.49 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAZ/+mizc8kZ/p6LbUf+M8l+8hYCGW8mEK4HmxV2eZA=;
	b=0fMEtKiv/YCVvkdRgp4KBjCyFAhm2laySro6WN98MNctm0EWOE/xpdSF+QkZC6mDKusB+/
	wLmyDCa/jdOHIrMXNaCn5E7zqVIlHxUaNzvx08ovlMHfeQsn993p55dJoPmlhFd0Mrc5+W
	bOs/V3C1jK2+a3UjhPyqX6wDIX3JjDg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JBPEgxA+;
	spf=pass (imf12.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.49 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771572; a=rsa-sha256;
	cv=pass;
	b=dO8ZeMBnn4ed5cgc/edT5nEmaZgIawkiG7sHsbbbZwxVkC5FkjwrFx/g2ubdoi9WAYxNF8
	b8gaBIrQLNqAbUqdl2R4vWe9lPzv9ZmAL39zM/JxQUk7BEebgouYZidArMo7muBRQAeKsM
	fG6/Z+5K/Dg+KrXHkc92mo1GICvcRJw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXA90MpA705yuyF3z/Qh/NyduJTWH2qFOFvQVLaRQNEt1JTRcFM/izH2mBqoKizEB3kS+LNJn/h/Xw1nMRPFuu4uaSipC7Z8q7HKdzRN5O/G+s9oTEQ/p56blzPfD6m5CGdnZUbL0m9v7dW6gFqOYrVCMSK4F+vY/QQdKSqhSBG3cP6pivhvhhWtck1WyXi1ZqKAF457S06SMSV33zfm9FREMbfuEyxxK1Wq1AbUkhtvwjCCbFZse3/Tt/2sPZWn61+zXmzZ07E62L8/abdlx/N1nOO3FiWkilGihLee8Mp0C/hlgrQ9tZtWJHVP8joO6nYx9UwNyCmdQFPVoSpSxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAZ/+mizc8kZ/p6LbUf+M8l+8hYCGW8mEK4HmxV2eZA=;
 b=ZS+0HLdOQ1FNzBPZ1fBcWbVsANmkHp5y7FPQog9ejHRoHGMv9kl4LfjkIAzyxy2WW/ctDljD5E0GyQviJAuoV9m54mGJ3zUhlBK3j6LvuF/hi/eNTzoJRveIlBxpZCGzPY7QcXyF9u9+T4Y23SxMH6O71MSBIupZYqses1mMNhr8tPZ8PIBoPR3+bjuTq4liDAPv1P1R0vLNV5+wGfwUD0Zg1wXvqL8wnMDQIG6qzKPatmbmXXGweBFNfzm+V9r5SqtyvxTbs/THrjgB6hG/QW9wq761071lbzXuNJz6alVrNUL983ORhQjBj0/eEzkZPie1Vkj+jAKdAnkRB1pH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAZ/+mizc8kZ/p6LbUf+M8l+8hYCGW8mEK4HmxV2eZA=;
 b=JBPEgxA+rP08K/pqj7MV7fLWs7pYUBvMULMPeDr/qDew+b1qS1YesKTnGusJW3CC+SoH1XJbQGapr8Voot/uM97J4StcQ+yqcVbTaoKrWkYKxLsG7TzC5x0K5Yv0O1qIinjKqdCFUby+ifXHL2Ww1Ve7ANn3WVHJNrrO1Lm7kVYZ/xRa1AaWnH5CHx6dQ+Eo3mX5XGVBylcRFwgHj8BdK8AkG4C4YeAOc/pvca7rlvjaMVfPYNqBIGuk3iCEycvQ79n79yjrMcXl5R0Z5T0YMsWMgPp1KTB4U4tvDmvp87f6sef9SGAQzHAbY0Os2zbd0rO/Xwp7yaH619YckulP0Q==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:16 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:16 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 06/13] mm: Add helpers to create migration entries from struct pages
Date: Fri, 30 Jan 2026 22:10:43 +1100
Message-Id: <20260130111050.53670-7-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::6) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: cb93b362-86b4-4963-1a38-08de5ff049b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dOAmZnCEnSu2yipzJV5Ax/lX93FRdJfw22TwvnWOi1h3d5y4zo4Re9Qnn3pf?=
 =?us-ascii?Q?hQMXdcWwv690oo6LT7KYxOhCTyLUJQCJhLIhsycRDo4s7HFQeTeo1g3g1uh3?=
 =?us-ascii?Q?V5x5UYdQ5uajYIR4kg0dXxW5R4M0spMPkZYMr0sxt9qbrWEML9b0tSt4Yeba?=
 =?us-ascii?Q?o28ixBnHDtzo2koInGFlkFQavbRWIfZFeEXgHjmpqwQsDFE2CjudVWjI4o39?=
 =?us-ascii?Q?tkN/L6vZ721Qd7zPwZNnb96q75SnYtzezZFxjSh3hChkY42EMWU2C46+vZi1?=
 =?us-ascii?Q?muNghuIPto1ss7ZIZgcpigGMwXm7n+ALDxQwZ/v+TvSxdv5Ij0R2IKB1bz91?=
 =?us-ascii?Q?uDWH8TNx1c3yGsRhNOn04ttXqiHAoc/UMWUaVyHd6rAs2stF8V0QigOLazNK?=
 =?us-ascii?Q?rA/b2R4xZnh8qvHbq4wDHG07UZ+l9VpWmSy/j5SJXWmZz00OxIbJA6/UGMAs?=
 =?us-ascii?Q?xKE1Fp8zl0QSCvuBDLPIxEyTT1cUUXyGmtgl0ilLVHdFe1iFOAFM+6IatBqt?=
 =?us-ascii?Q?uUiJFzAwXriuGWAYWS6oW4XEERo+RlIrZte7TeCio29VKdISIiEjqlLCxS6M?=
 =?us-ascii?Q?t/9jTO37nrsOgjDyWuSazqy9KDI/r1X2q+p9VrLr6E3zHFXoSIpk8IAaQB8E?=
 =?us-ascii?Q?wlN69kFmaCWOfkkx9jCqKa9+htUk5lXcnacHAs8uboPN21D26Bk0nFv89dro?=
 =?us-ascii?Q?YCnkBv1xBDBp6mHTzXh8t7ssID1eaat7YMODRan/L5BrlwZeB0RjWcaJ+njl?=
 =?us-ascii?Q?AFS+G4YzH2uGwt8OvZYj0JHM66GbhoG3c0P9bnJwo/u152curOQfz6BWztGk?=
 =?us-ascii?Q?WCgH8mJerB8i99kwEFH5YZ3NzPJjTrk8wMiP2aNDTcYuOBKPI5FizccABEvZ?=
 =?us-ascii?Q?c/CvMy4hSSBMQ3e8m2I7QtJ35qHmWodG6RpKb62MRHD6H0+T+0oDfeQA9zOE?=
 =?us-ascii?Q?lyLf51gbrPjSleQwM/2uFJl0nb7KmPwqTOLgoTjuNsb9bNnEn8J8flfChZnp?=
 =?us-ascii?Q?ydWkNrk3eHbs2aN7//nPJOy3xUGCWwU5/atgEj5QNT97Us7X0XGiLY3cm73h?=
 =?us-ascii?Q?AI8zVJkMSMhIO7Xfi8D3bR/mmdcAhaczgV+bS+dF9tqeTODbcH6QNrRshRDV?=
 =?us-ascii?Q?zxriXt1DUxjz/qyPfRjx5WvMbPEJDrOIBgW+prQRHss8Sj6f/sbHsT1GEr86?=
 =?us-ascii?Q?KA7X/ZYTP1UFXwZjm9BDo7aWQf2L9rAKzQeRBKF9r/cpAmAzv+bceqwPx8E8?=
 =?us-ascii?Q?ZqX5rMNw1E07diGmWGqlqTazhW2KhGHLiSnZZbcBKD2NlaT1mH9TUN4amlwn?=
 =?us-ascii?Q?5EgG4rru18lJ0vWjUVmTS8Z99bps8eXu2aCxpBtfO19OLkugKuB5G12gf071?=
 =?us-ascii?Q?jYAMOEAFGasYYUn0nd9bBXKKXQA7nbgcrPlChxUSc/L6W97sQbRVR8Chi+oG?=
 =?us-ascii?Q?5VQfxzJ+W87o2VVusBpn5wz+Zy9LFtp7BWQkQfNx8WqfxbVvlGbk7wvZZCpG?=
 =?us-ascii?Q?QnfFSSmd6VghzMAZvnneRl/hY9Vl6ZoJ/kUulVvOGL7EL8zgs+oRMYn4VjBu?=
 =?us-ascii?Q?47/mkTN0sh868GaZ1hY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hH0mt/YUI0Ika3LuI1lQToWdH+TrIFl1moZjlnyxOUMhV4SJB3TmP+5D9b3Z?=
 =?us-ascii?Q?nVxWmvv+JCkZTfDG6OLZGxx/MEAun1OezFBFpM2Jn7ygObStlw0nHgh0D7PW?=
 =?us-ascii?Q?zJ6OLphNO5dBktiypsykZQ+33DXzqq+EJ1SZdgn4za4YXoPdpfGB/TlJR3vj?=
 =?us-ascii?Q?lsXbNCe156zUhzwCDyC1R9ugpEURVTOSsYV4iPZv5vJ2/VB9JylpeDqEylZz?=
 =?us-ascii?Q?jaD8mKwqi6K/wkVHqkSPKGsXau5iNShC4wzzm4U6ZV5sX5zzqYUKJpagHBVv?=
 =?us-ascii?Q?9IW97EiBSJPTQb3HUVkuk71glEQpNo7RAl19W3axvHa98a8fEZMFuL6kei7e?=
 =?us-ascii?Q?nc8kwH0vUq6OhKZ8MkxKdR+M88Omurz0kSj36zr7p003QDS4c/OUiEqELszs?=
 =?us-ascii?Q?LysOR7fpecQ55Bv/W0Sm50WBViLSht0xuLCYj5WarjsVrSXVbpebcgIR3K2c?=
 =?us-ascii?Q?YuseTIDcvqhdDU0y5BNz7cVlOhFAgJBbcWo3RmdE3Y3KcXVuzBy/4Tbvt9ub?=
 =?us-ascii?Q?ZphXmwcx17QCWzCOAQ7nHCVfDwFWDKC3e/1f65OhtHKNF/yhyvN+c+d269kY?=
 =?us-ascii?Q?tk8d5BLN4nP7tAtmmsv1xsYqtuQganxs+bkJL55e3tLJGvZNByj6Km0w6l8f?=
 =?us-ascii?Q?Jqzh2r4QWp2lakHvwhTwYYchs4DycoeAfI1FU/gMGlK9kwSn3CBYOF8BxWll?=
 =?us-ascii?Q?sEdq8I+BjhCXxJeNXYsXb6E1GjQpDfviSI2DOyhgBrvLVucdf/1StmuJb1/R?=
 =?us-ascii?Q?kFGXxEEZUf0ajlf0S2zY6/l3yhpNLQ7Ea/qocx95GSjb8R37fmGybat4HMyj?=
 =?us-ascii?Q?DsLnp5viO/Kpn9b4xww6y25CwlzlYKGHZPIn9/eTMUQYb9JoUt8JFyXU0k8X?=
 =?us-ascii?Q?qox3Jlejjm5M0jCLhLyBnOjHCArwwmHUKcQE+7RBpJmltOxxtAvEV55QiK/6?=
 =?us-ascii?Q?YUOhYF/XHUEZqvPerJwAx16GSvR2vG3ZsPuXLvS9WcoiWA+vcFG2cOpIJNNo?=
 =?us-ascii?Q?mpbSZwfxx8ZLSvgARkqm2VqL+feOYeBwU3aOX5htT2LbNqs9G4ZRf72OeVRD?=
 =?us-ascii?Q?k2l75MnGFPr+Hv3ptkRvIE/yYjRS+FJ8GVs0C0yhaEtRnSqjxnzRYUcMvA5X?=
 =?us-ascii?Q?ZNxW9sAIVDR+w9nQbMgg2ySXRzHZqvwvBu8f/GJNyxb+Qd4/MqJGFMQxyORw?=
 =?us-ascii?Q?rkU+rV74JYhKZSj7Uf5eqk6ovnVIqXvaSDtDnao+SX41cSuDLe0BTKNIbyLV?=
 =?us-ascii?Q?FmhWDy7eruXv+/FvHAYKy6JP2YfDfbP9jzkiHjk5+vmqoGjSHcqIn2besxcA?=
 =?us-ascii?Q?/ckIJDymKnViQYEMWxFE0KHZ36Oh7g6pQoMpcq6irP7cHQ9U1fhliC0kEe+9?=
 =?us-ascii?Q?TEE49uiJ9rv0h+Iabb9Bjxwh8ODx3+B9XRyqVDnS2GpYC+t3J3BnmtWBqph5?=
 =?us-ascii?Q?9WEpVY/aCawSdp1SBabXVNQrKGAAka7BRW/W81FG8ARjdGszlLC5RCQggdmR?=
 =?us-ascii?Q?Eh6H+DjDDMof/HPyVZkWeyrWaBZua+fnJCY5+7g9kuHv57BF4etwnVJRNI5H?=
 =?us-ascii?Q?3O1Vifb0eMIeAQVFTQgAsRLrNxJb94iuxvqR3MZi7McuyeuIuOtU1nQ0T6Yg?=
 =?us-ascii?Q?hRfAjuJMpBHQTtLbYojx8Xmo2sEIUUN6vXWpIAzN/ed09xL4M/GDRmkLV8v6?=
 =?us-ascii?Q?X9drhzE6Fq2/jLBGJfLBpO3+iXlfO0cEuKv/xVJfQcMYgH8oulP73hTX1iRC?=
 =?us-ascii?Q?EF1aN5Z/bw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb93b362-86b4-4963-1a38-08de5ff049b6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:16.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSevnpdA19vFTZZAPywgM/YBF0nM4CKWwFOwikRS7g0RcvzJGuoOE2vwQlYvPJGbTZOpnylKzcDMmm38QPyobA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B82340009
X-Rspamd-Server: rspam07
X-Stat-Signature: 976b8djrhjopsicrk14egonnsw3i7mpp
X-HE-Tag: 1769771571-662689
X-HE-Meta: U2FsdGVkX19dwMKtGIO3DsVUXP42ID2GIpNoQkBfRvy81hD/0U1bpm4L6zTjMiuwcUl8hWoH7hNYu7pfgmqzWNkALIIlMrOhDyaQgYiqIeLmO9XV/N1T9C5ssfngHx4KRUTJXS4ul/2bH7mHrGmvftgAPSCjZClI/q5WbXBtYf/CIypRop9nuELan68Ypwx7LBVZTioDX/w8Yaf5MTcDwbZxlt2B6NzT5Z5t4nUJwkVq6dEK6V96fRvXm+e4HpoXLFdTLhpDkFahv2scJ7ka2Je1sOWseiM5mxCIpMNHAsnfE9Ip9OXGZtn7t/NRvttHhaLCWtks8l6eVVyagJYTRTLwhemxyx8HUmzDW88ws4Z2Rm5Ic9EJ8YCf2FTHE+OE9h4TPQQh3RD/050286R7GtkC4P+47V52B+qwFZkrLXORInUolzUt3Rbo7PMKqfcWIqQJ/BKhIqwrKgBYM87hJXOXfz1so15ekwUPlRA21tWeGqV+8foLH5Jn/iBWMEC4bAK3IXu+AtvspIBqw7beBFHMlbm0DTz/dbFWa58TUg60D5LsPdtSOzErZ1jHck2ytNOMSxgMmr/QdjCVJQIm+XnVHiWrY+QB4kbLsJm7GvWw8xPWrUULWy3bbHJnOLbI+7PkPQ7ZyvgGanxufC26v5DO87qGSrAgJTbWQg72anbTPZFdhqpJM1uglLJqcup9RPvNr1DSILXnoF9fDEITMiut+T0pJwocRyJx+Vn8XvHf5o8V24zX10JtGXCKRanDJcJ2TuBH626CQXk9Hm/hj9E1jJapRCfPp8ypdj0Y2hPcs8E4aILhbwPTzUEblJxYmG13KhllMs1jXp40TBFeOq0mFgxb6znuZNtH3i+nID5SGr0rniJBOl5Is4oIEWxDUc297St4efrrgNYQKjmx0IAE85zazhnhIbBEo00474eNPeJZ+lzkSxQVWIU3s1xVt8HVSg3YJS3HiA/Il30
 VuCiCuvy
 FJ2/dPyt4+B/p9dodootGxtHKX9z275lhlORdctbIPOC01+2UY8Q7rJI6BEujCRaiLIIYkGCOjzkKSGWxjz5sR1/Kd5xCpfmW3BrY30UldqWFFBYYylFFNSZmOErpW40rHV7IhkPRWQYMoCeljlQFz47hHdwtpkYNCjrauGeUi4Si1FcK4bZK59KNswHkQW+8kglvsXGArppvUlTN7tv7DwUGNBAHoDnf1VeWYgd5eBRZcAdC31HWLFWiU2c8IRq7bYifXDXGN8Ipd7J4pKxWf4EXPGmtirsD3Go0CbFDtqpUi3RDfCVdYYcMp/+NaztyTOS76TiPzEXo0zreQ4QeTrzsV3rkFhOzZXDAMjmBdQAfQYx3aShEsdu8YVXce0gOGOXAiT4oM6mx6aoOkVFx+d/OSbQxl0CZt013dB8GlGxnlqA1/mwzp5fd+DrzMqxR+GZ5WJgbPA6xDhHmQiq+XVPvdVQNSxLLp+oZCs0NMxS7bXVada23qF42QqdQ4VWMNQw3hzpkVGrRwiYLnojp55wgOOUwzIWc0N09
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new migration entry for a given struct page, that page is
first converted to its pfn, before passing the pfn to
make_readable_migration_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

  - make_readable_migration_entry_from_page()
  - make_readable_exclusive_migration_entry_from_page()
  - make_writable_migration_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
v2:
  - Add flags param
v3:
  - No change
v4:
  - s/make_writeable_migration_entry_from_page/make_writable_migration_entry_from_page/
    for the !CONFIG_MIGRATION case
---
 include/linux/leafops.h | 14 ++++++++++++++
 include/linux/swapops.h | 34 ++++++++++++++++++++++++++++++++++
 mm/huge_memory.c        | 29 +++++++++++++++++------------
 mm/hugetlb.c            | 15 +++++++++------
 mm/memory.c             |  5 +++--
 mm/migrate_device.c     | 12 ++++++------
 mm/mprotect.c           | 10 +++++++---
 mm/rmap.c               | 12 ++++++------
 8 files changed, 96 insertions(+), 35 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..52a1af3eb954 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -363,6 +363,20 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+/**
+ * softleaf_to_flags() - Obtain flags encoded within leaf entry.
+ * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
+ *
+ * Returns: The flags associated with the leaf entry.
+ */
+static inline unsigned long softleaf_to_flags(softleaf_t entry)
+{
+	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
+
+	/* Temporary until swp_entry_t eliminated. */
+	return swp_offset(entry) & (SWP_MIG_YOUNG | SWP_MIG_DIRTY);
+}
+
 /**
  * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
  * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..c1d3c0e8981b 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -173,16 +173,34 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 	return swp_entry(SWP_MIGRATION_READ, offset);
 }
 
+static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page,
+								  pgoff_t flags)
+{
+	return swp_entry(SWP_MIGRATION_READ, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, offset);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page,
+									    pgoff_t flags)
+{
+	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_MIGRATION_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_migration_entry_from_page(struct page *page,
+								  pgoff_t flags)
+{
+	return swp_entry(SWP_MIGRATION_WRITE, page_to_pfn(page) | flags);
+}
+
 /*
  * Returns whether the host has large enough swap offset field to support
  * carrying over pgtable A/D bits for page migrations.  The result is
@@ -222,11 +240,27 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page, pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_migration_entry_from_page(struct page *page, pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page,
+									    pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..e3a448cdb34d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1800,7 +1800,8 @@ static void copy_huge_non_present_pmd(
 
 	if (softleaf_is_migration_write(entry) ||
 	    softleaf_is_migration_read_exclusive(entry)) {
-		entry = make_readable_migration_entry(swp_offset(entry));
+		entry = make_readable_migration_entry_from_page(softleaf_to_page(entry),
+								softleaf_to_flags(entry));
 		pmd = swp_entry_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
 			pmd = pmd_swp_mksoft_dirty(pmd);
@@ -2524,9 +2525,13 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 		 * just be safe and disable write
 		 */
 		if (folio_test_anon(folio))
-			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
+			entry = make_readable_exclusive_migration_entry_from_page(
+						softleaf_to_page(entry),
+						softleaf_to_flags(entry));
 		else
-			entry = make_readable_migration_entry(swp_offset(entry));
+			entry = make_readable_migration_entry_from_page(
+						softleaf_to_page(entry),
+						softleaf_to_flags(entry));
 		newpmd = swp_entry_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*pmd))
 			newpmd = pmd_swp_mksoft_dirty(newpmd);
@@ -3183,14 +3188,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			if (write)
-				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_migration_entry_from_page(
+							page + i, 0);
 			else if (anon_exclusive)
-				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_exclusive_migration_entry_from_page(
+							page + i, 0);
 			else
-				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_migration_entry_from_page(
+							page + i, 0);
 			if (young)
 				swp_entry = make_migration_entry_young(swp_entry);
 			if (dirty)
@@ -4890,11 +4895,11 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	if (pmd_dirty(pmdval))
 		folio_mark_dirty(folio);
 	if (pmd_write(pmdval))
-		entry = make_writable_migration_entry(page_to_pfn(page));
+		entry = make_writable_migration_entry_from_page(page, 0);
 	else if (anon_exclusive)
-		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
+		entry = make_readable_exclusive_migration_entry_from_page(page, 0);
 	else
-		entry = make_readable_migration_entry(page_to_pfn(page));
+		entry = make_readable_migration_entry_from_page(page, 0);
 	if (pmd_young(pmdval))
 		entry = make_migration_entry_young(entry);
 	if (pmd_dirty(pmdval))
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1832da0f623..a2f9ac8a3177 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4955,8 +4955,9 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				 * COW mappings require pages in both
 				 * parent and child to be set to read.
 				 */
-				softleaf = make_readable_migration_entry(
-							swp_offset(softleaf));
+				softleaf = make_readable_migration_entry_from_page(
+							softleaf_to_page(softleaf),
+							softleaf_to_flags(softleaf));
 				entry = swp_entry_to_pte(softleaf);
 				if (userfaultfd_wp(src_vma) && uffd_wp)
 					entry = pte_swp_mkuffd_wp(entry);
@@ -6491,11 +6492,13 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
 			if (softleaf_is_migration_write(entry)) {
 				if (folio_test_anon(folio))
-					entry = make_readable_exclusive_migration_entry(
-								swp_offset(entry));
+					entry = make_readable_exclusive_migration_entry_from_page(
+								softleaf_to_page(entry),
+								softleaf_to_flags(entry));
 				else
-					entry = make_readable_migration_entry(
-								swp_offset(entry));
+					entry = make_readable_migration_entry_from_page(
+								softleaf_to_page(entry),
+								softleaf_to_flags(entry));
 				newpte = swp_entry_to_pte(entry);
 				pages++;
 			}
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..349f360d82b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -963,8 +963,9 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 * to be set to read. A previously exclusive entry is
 			 * now shared.
 			 */
-			entry = make_readable_migration_entry(
-							swp_offset(entry));
+			entry = make_readable_migration_entry_from_page(
+							softleaf_to_page(entry),
+							softleaf_to_flags(entry));
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(orig_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index a2baaa2a81f9..c876526ac6a3 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -432,14 +432,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
+				entry = make_writable_migration_entry_from_page(
+							page, 0);
 			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
+				entry = make_readable_exclusive_migration_entry_from_page(
+							page, 0);
 			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
+				entry = make_readable_migration_entry_from_page(
+							page, 0);
 			if (pte_present(pte)) {
 				if (pte_young(pte))
 					entry = make_migration_entry_young(entry);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 283889e4f1ce..adfe1b7a4a19 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -328,10 +328,14 @@ static long change_pte_range(struct mmu_gather *tlb,
 				 * just be safe and disable write
 				 */
 				if (folio_test_anon(folio))
-					entry = make_readable_exclusive_migration_entry(
-							     swp_offset(entry));
+					entry = make_readable_exclusive_migration_entry_from_page(
+							softleaf_to_page(entry),
+							softleaf_to_flags(entry));
 				else
-					entry = make_readable_migration_entry(swp_offset(entry));
+					entry = make_readable_migration_entry_from_page(
+							softleaf_to_page(entry),
+							softleaf_to_flags(entry));
+
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
diff --git a/mm/rmap.c b/mm/rmap.c
index 7fa976b7fb5a..79cba3d441c3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2536,14 +2536,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte is removed and then restart fault handling.
 			 */
 			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_writable_migration_entry_from_page(
+							subpage, 0);
 			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_readable_exclusive_migration_entry_from_page(
+							subpage, 0);
 			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
+				entry = make_readable_migration_entry_from_page(
+							subpage, 0);
 			if (likely(pte_present(pteval))) {
 				if (pte_young(pteval))
 					entry = make_migration_entry_young(entry);
-- 
2.34.1


