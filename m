Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBDBFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4538A6B0088; Mon, 27 Apr 2026 11:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD196B0096; Mon, 27 Apr 2026 11:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAA56B0098; Mon, 27 Apr 2026 11:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 168EA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26D58121E2C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:39 +0000 (UTC)
X-FDA: 84704735598.02.BC1A409
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25D48100012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="lk/WwprX";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6C6LdcR8d9suTBa/3gUUBdhoiR800mTkENfgAVD7Xs=;
	b=zKV4IgHPdTgGVeuJC2upu+ZlPzN8EJtTusyRE4NRRg8l8fO2fPcSDysdBpmrixT8lBh0L5
	N+jxu5NxwTM80KapM6ukd5tEZ/g9FZLcek4EReX5/0PVx9Pxml6sjrFtsRjfVl/GJBfOwj
	zL1hG11tYDNqK/h3zwEWBjC/yVS3Vvg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777304136; a=rsa-sha256;
	cv=pass;
	b=1LhwC+cPNtELL6DrIwruLKPLZMrWvVyloMS1vVmRT3+lP2fynHvVALJP1Dr7OJ4eYVg1x+
	HjP9jk6LSw8fNWmi0nWCYs4LHeB6WYfZ17G/hQKT22M5rJzwg2wEnOZtSiKpz0FtnDwxhm
	yaqIQKtzCtHjRBJ5/wh+GbS3bBNO/jM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="lk/WwprX";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mN/4kLJqNU9rMxvFtd8PpA8Qu+HbVYyMMu/k/z/2bWRnqMnjC9V8jsOn2mNrbnVyzPeCphyG6Fcu9mLRUpwh7G2DsBiUIrgT1hu0X2FyYDOiEkwXzKEjOlTxhQRp57NVupT9Zd4ADcyR6U+QV7PJz7bjXkDsLisnJ2mf3TTNvtOBdsTji4tY9+I/Ik1f9prBID6qADiVWuYYeL+1GczhgE+Dv/2+nnpvzKikvAZKQTiIJcME9rY/xYm7Uajx1x5fACrOLG70d4Yzk5PR++DGxXnvnwRkAsboQAZx17UPm1i0iEA2ZL3Z34LFx9xkxGtl5WOjL+0asrSVH1u6+oOmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6C6LdcR8d9suTBa/3gUUBdhoiR800mTkENfgAVD7Xs=;
 b=ckHmLVk3wyHNm0Z48Fe58WRi9yZe1RBj1g+ay5y6RJTQ549k25qSMqqAbtRAmEuy4AdRc7cz2fRF+qK4b7mN5unjz9NAhBmOOPR9BswGwUjLj/nBWF82DzsmqVKl3bJ6cx2B9Vn4wHOK6UevCou5kzn7fj/l9g0e1RS+B+4QSh1A7bi8/fvEihuFDEP2WbELz/2Gvg/McrwP4XmaTKC7sC/PpPD9AaiZp0tHs8pLfB/Rnu9X/E7YaeU1M3EKEiB/lvK6+Nn+/M4cJwU0QcbzrlEVodyqTd26IIjb/7xcB9hTpXQ7J0Ex+TyE2B2La1YrA3l2Ub4717iUW9L41GksPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6C6LdcR8d9suTBa/3gUUBdhoiR800mTkENfgAVD7Xs=;
 b=lk/WwprXQBnHZFqZzX0YrLvJEchk0wgfAXdXyI46WQ5KqgL2vBUR/Gut2Uvy2lEgywSI4VecPhPLQ5yqk1otZDSk0r2vyJcH3OIrPg4CvOP/3hOBOJTIegk14+hJdZ0M5X39fjzMyxyxMyzd6t0K+XsMrQOnh9Bb14jP/k92t0YL6cpCt0+Fk2Ztvv77HVWi0GsDKYK8oA8FOIHu3gVYJ3OC9L3KPmrpD0vOg106rDJO65GxN20c+Cx2Ji198SvfIj7LHbcj5Zogllaww1thNVsxZNCYXFZ5wjvlGdKIrc9dsg67q7o1zwTBiHenrUwNltqCXWhKomU5HcqZkKji8g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9681.namprd12.prod.outlook.com (2603:10b6:8:281::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.15; Mon, 27 Apr 2026 15:35:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 15:35:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
Date: Mon, 27 Apr 2026 11:35:28 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
In-Reply-To: <20260419155540.376847-2-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-2-zhen.ni@easystack.cn>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:256::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: f90ae980-8858-4ce9-e2d1-08dea4729d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	cqgASODrRAC3jJFrrwFvEdz59XKJjxgJItkvmeibwt6hVsJQUiuNOpgQPv8iM589B5U5Q9MWIN9L6KUfnLyPwZhNpIiDaK/6qtHGDGZGAAzKTt6ze8IQiuzAjWhMmldMIew/8BBuQp5OEop18D8Yp8FuV5MIHbND76xQbJYiEKCCpMmDQdIPLFSufdTTOxn2hwiYQtJr0fDkfuxxau2LQctwjXp3fZNNt1HZSCa7qU2E9ZpiGPO2LLvebeaaU8VHM20A1GlfGIBsUgMTyUrAH8OlnJ9dJ2Z/Dut/jI2X9xFrdVpW/GXOeHkdqTz4HqgGB5DTbVvu7rZLHkukBmLXHrPHrXYdyfwXuNgRWXSxwAgnRT7nPGlJnQY1qD50beqWjuKRGHbsI9pPWWjeZQuE0m3YNytjgBAj368EZXdhHntPJtyT6KkiVjXjHHtqg4wt6vNPScnbIKNNFVBg85yub/zHWWQITrqDq9rOuhTSiyDuttrCSZUNBsIrLkXX0aE2AjrCML2EZ06SLE/7BQtIfpO6FQt8Crn2TyJSd1PSGrbGPHtnnouCIW3D5up10zvi/NgnFTIUbkRTvla06MNUZOsxKzx4VUbmkVdP7G2F0YVx/V0zNEseDWzPrxMTbyxeJPRjgVaZ64KKjOCuVV1Z8/ZRA3pkMmwV2LPISilL/61yK02yVWJUeTSyzyH11UQSFCvrVD/tYiiYSAk4xqrTFx+Oezqzp1sGy+EFB9BJ2POX9IbPeJCRTNc3cqOEbpVj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B1vLdR66+KG5gJklNRdtTSQ0FF1NGcx9blxLOXCDtuvdvcCR/G1hTgu03zn2?=
 =?us-ascii?Q?L7ml4X4ruWQK64qjzSKNDDH+5NOR2qMRNl5jMzab59ualpGIFoXvNPAax9H9?=
 =?us-ascii?Q?b7RBELiJOLUSNSeW9WVkYOeOv3NuOV0wkGvHOAa5UfP3FDvE4uArOpIS3Otu?=
 =?us-ascii?Q?zCEw1q0u7JrLRvyPv7BWUYGbg1Y1xUD4p06fAeOqhLoCN29C+ESMvlMAfY8l?=
 =?us-ascii?Q?RJOeJ9mFokYkTcUnn/pwyDPmf4IRks8Zx4Qn86/HMaJAFcUu8oUlgqM06pC3?=
 =?us-ascii?Q?HAlrLr7A90O6OCAfqMjBVK2n5TQluwHvL2RVj6P4GaaasE1wfL6tgfPu7jIv?=
 =?us-ascii?Q?T56FrVmE3Kpz6+jiCnAkR7RCSaT8qUcYOWGoua/XtoMCUVpJRZoqrSgMMUwg?=
 =?us-ascii?Q?Qw8fDKQ7odPJ+wdrnmX22x/d+xnntOnXAVFng/3DHCcjR8AebnBkTXOIlQNv?=
 =?us-ascii?Q?mzQNLHgaDofFEjNJYcf0yw5wLitEnQMjuM4QjMVQkp7jTiq8pGjpnhl3Zk9p?=
 =?us-ascii?Q?gTp52QmzooINEglaefjMymf/+ITZ+f1VyWUxhM7pmHZoM49qvbq5mXK6MSCQ?=
 =?us-ascii?Q?9zJt/tnsbiBK/U791IAb57bGekd+UNA2918PGSEBOasuX1P6lPFyMt8ZnjP3?=
 =?us-ascii?Q?jPMTs6+TjK22rQMKyQBJ/rKVyNszn49jsy6EtMJokal2eU4KnLs1gL3dk12p?=
 =?us-ascii?Q?FOay9B5LAkqOkQ9Sq76KEb7hEr6gKDTGcE48j8riQCYLCdyBwlcPZclN9XWz?=
 =?us-ascii?Q?NFhCYSrsORz7bCrl/Hta5ofrATlIgKOGXbxaTZgHXT68Rbx3yR7utAEFppek?=
 =?us-ascii?Q?eDqAcjVC0vsIdB0BYQHuDCK/viS4fZZ9YSPkBCUQk+zE9dhzGnjmcHIxNrV9?=
 =?us-ascii?Q?CWg7OwDlrmbcTEvzsu/iIH/fU114ZFkQZzVVIanGF990Oy7nIMFLIu0FBLUI?=
 =?us-ascii?Q?P+rFiQVwioz8OAR58nB18Y0W/wBCraJ2eTANQiC0XqwRfN426hxSn7g7b4WN?=
 =?us-ascii?Q?RF1g7A0yoi8fiVHbnZYlcjD8kLxboSm8xa3U2tfUC7o9D5z/7SMrqS+1nhTU?=
 =?us-ascii?Q?u2UMowWXaQI8kK+lVOGPvCgHr0xCHTxatNhRF5Q3vpoWnxsZU+U43IW0n8Ss?=
 =?us-ascii?Q?2tfJh5TAawcnH8dyZspXoDN7VaJV/B/p0czF+bjp+Krj2B2Xs+aft/YEh2cB?=
 =?us-ascii?Q?5gjHYZxLsjEwbHp13hfgXh6kD8vTONWEYNbiTL6HzsBz2mBZLwouVilcmojG?=
 =?us-ascii?Q?x8RMJxp+XNbIOApwBbevfR84Z/qpU6mrSpM5FQN5pceYTYfm42L6dcG824Mx?=
 =?us-ascii?Q?tsFghb0iIIwHDk8P3T11ThdmsB+/LtKUjyxcA8iPnrrC7Gy19X/3SoBGNWbE?=
 =?us-ascii?Q?CcSHtzzNSxbTa49PzyDGNs3rISYcQVZpOU19MJMadyNPyg/DlDviADC7URyb?=
 =?us-ascii?Q?hpSlq+o9kSucFVU0YhgFi01JJoRF4mnMgvPGysupgPse/+yIrtLBitR+YJBh?=
 =?us-ascii?Q?1SN83W2Eg+SE1FmO+cSmJM3qFKNW+uETbr8KY4dDRvM+r1/t/Sjrq4ek/527?=
 =?us-ascii?Q?PEOqQqxptRUpBs1/Co6fRMl4FUKUfv9MHkMGXOyo1EQVCFe1CCwTn9TShs3e?=
 =?us-ascii?Q?qcRrq8JuR/eBC11lRze69UET8omHEhW6nGihINWQU4FIeGo02HXRORzVLlG2?=
 =?us-ascii?Q?sDr53WIWJS3hU6B8IlqDbIkqN+zO9dgv07yeNfC1atVWyudR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90ae980-8858-4ce9-e2d1-08dea4729d48
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 15:35:30.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vG5AoajnFQb7dVUI7HHSkGoTKgeMub+KtF5UtbYI4pWwgevR4LwEVuaDn9lpeZEg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25D48100012
X-Rspam-User: 
X-Stat-Signature: h6euzoo9k7s7ucxpqrjncuf7eb6x7zed
X-HE-Tag: 1777304135-655307
X-HE-Meta: U2FsdGVkX18ce4aRRD+dxgU8x505LjVyHSeINwgXigJOq8R9FuW0oyGtXgBTtsExAd/w7NjQI3uZpFwPDflSrtLwATfnPgQPpyG1qNVi15MVm1r2lmH5FEMkDrM0EzJUegXR/JutxYQZVx7aZuAvZzHsoHGTUdgt229kdGkNbWbtgziNGlGDaZU3Yqqf7i4nfPZnum6OxYwGNibz+JlnMWp/11mfJO+joeyFadrcWP2v96wnwwcgE5SRLzHenFlxnQ6KUOyaD3XQOBWEpCj7DFBf2xiazVAbQvkFBVyAYyJegEOc45FVJVl3HmZwsJyfQKLcHdBl2Cw/7J9UGEpefKtQP7uqlauVQKmdJaK/UNh23AteSjpuPP7tW9YZLBKfYO17yJUv6jnPmTlGSUfcDeSS+OmI/kUnleJ2NOuLGZessRofajz6bNkNxyRWBRTAMhztJRvR7GtIPagdclgZ2w8vPy9TSHzPklAq0iBMKw+vn7H7aITg0Jy3jmJGKcWQYe25lAXsFLVHM/pLKyFtNp0ZBWeAjCgsDOAV955T6brZW9XLaYHnYahAhyt9xZeJ7SQjmS588xWUGcqu8nx+xtUdXLd7Tb8hea2/8ZzkG1PwOrdFQbOYyoyXNNlAaVuc6nFJ+ZGmRMLTGi02mfbZKtlNFco4/8j8OBm6bmsy60Jh3okCT8NOdyaUWVPtLL9I88ZfgigbT4qVQ1lop42nXvhViXjbe3E7UzM0K0PKwvXzY8n3sRcxUqIKSuY/eKiW2kMS9Lw6EuVMhP6rrDkHKd793nKzkIvQnHGbLg2eYZGuGHuQjP4dvQzCYr3BWvcHzrXIrpRtdapSKxn/1QIjm4sLMJZDwE1AeYlCYoVj5AQCYr2tFQ8d+efQKDy32NjKE6b/xDrmmNXTcS39sJYo6Nj04CL8L1h/JLmfAvGNvP4tmj5N4I4u5En4Z9v7plN/IH/8k6zaVRgptUyvXmO
 2vcPfLCL
 RLTgPVjeBnZooitqjX11HmO8wLOADUhm+8Dx+eYyjmHKucCMynLK8+NDWCOI5gdX+gjK6X2xhQBb844OE46fwdD38Y3u+xOzhcCbl5BLZy815x6EDriBIgctds+QagMjnsGY/sAKIMYjMknOO8GvOPSj6CHZDOUVRPOBSkA+yK/OldM1fqOJa+mRPcim5bghlZKdMtyDCEGIMCKL0M3CHqMSNWGwvFW5ANTulUh4g2GTqVWlMjZr+tCjItxBwPe46dXJPD0woLgETzZmtczaLDH1JITea57eASOKxXqs0cRH0CwmxqeNVF5qG6mx9rCrD+pC5LuDeaiUCT0HODa3EGYkihYH9Zm5LR504PlQVbbIcHoyO9NQUaW2NnP2+ixMfwCc7yC+Zt8jTCs9Xdzd2WIQgmczpuuQb5tvXIWm6Lz4E8U0kx//WLgDk/1Col0BTmc+8nt6LCYzlYyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Apr 2026, at 11:55, Zhen Ni wrote:

> Add data structure for page_owner filtering functionality and create
> debugfs directory for filter controls.
>
> This adds:
> - enum page_owner_print_mode with values for full_stack and stack_handl=
e
> - struct page_owner_filter with print_mode and nid_mask fields
> - Static owner_filter instance initialized with default values
> - page_owner_filter debugfs directory
>
> The filter infrastructure will be used to add print_mode and NUMA node
> filtering capabilities in subsequent commits.
>
> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@e=
asystack.cn/
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>
> Changes in v2:
> - Use enum page_owner_print_mode instead of bool 'compact' for better c=
larity
> - Use nodemask_t instead of int 'nid' to support multi-node filtering
> ---
>  mm/page_owner.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

The patch can be folded into Patch 2. Otherwise, these new types are not
used and page_owner_filter folder is just empty.


>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8178e0be557f..5884d883837e 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -54,6 +54,21 @@ struct stack_print_ctx {
>  	u8 flags;
>  };
>
> +enum page_owner_print_mode {
> +	PAGE_OWNER_PRINT_FULL_STACK,
> +	PAGE_OWNER_PRINT_STACK_HANDLE,
> +};
> +
> +struct page_owner_filter {
> +	enum page_owner_print_mode print_mode;
> +	nodemask_t nid_mask;
> +};
> +
> +static struct page_owner_filter owner_filter =3D {
> +	.print_mode =3D PAGE_OWNER_PRINT_FULL_STACK,
> +	.nid_mask =3D NODE_MASK_NONE,
> +};
> +
>  static bool page_owner_enabled __initdata;
>  DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>
> @@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, =
&page_owner_threshold_get,
>
>  static int __init pageowner_init(void)
>  {
> -	struct dentry *dir;
> +	struct dentry *dir, *filter_dir;
>
>  	if (!static_branch_unlikely(&page_owner_inited)) {
>  		pr_info("page_owner is disabled\n");
> @@ -981,6 +996,9 @@ static int __init pageowner_init(void)
>  	}
>
>  	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops)=
;
> +
> +	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
> +
>  	dir =3D debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
>  			    (void *)(STACK_PRINT_FLAG_STACK |
> -- =

> 2.20.1


Best Regards,
Yan, Zi

