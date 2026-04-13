Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5344EE93814
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 04:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4522E6B0089; Mon, 13 Apr 2026 00:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A1C6B008A; Mon, 13 Apr 2026 00:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318AA6B0092; Mon, 13 Apr 2026 00:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214C56B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:06:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 613DDBB7A4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:06:43 +0000 (UTC)
X-FDA: 84652196286.21.7107EE4
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011054.outbound.protection.outlook.com [52.101.57.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 883E2C0007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:06:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=puRghlxr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.54 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776053200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJIDPtvfNal+zRkdTb/po8DsleFJ0qvyBuO3zwp5r30=;
	b=xz4L/zja8ngXXje7gq/oetigkMo1P48xD0jOmmkW+nLcNHueD/f84HhKKVgjZUAXlDO8GD
	nsQWvDfKYYakwdHA1ZgwJWXGxgI+hjpoiViLgTrTNFZj040LcC9HV1tEDIpaSOxyKnkMPP
	+VUwOhMg0A0h8xjZx95i9xdmqKMd1KE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776053200; a=rsa-sha256;
	cv=pass;
	b=Fdv1W6q4UapGYm80Ic4rDKV7jcJTjvfcwh9AZ+Hd8GQGv4HZs+OQ5V8OEi82NYJDsAZUAu
	M0mLPxLmEBx7DaAbXb6M57wum+NHcxP0CRsohk0dlm/+byRsMsWWvUeF6w8tUU10do2i/h
	+jmiTkQbBmFI8vnyUwMN3jR5gBos38s=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=puRghlxr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.57.54 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ek4QhPADZlHrvF1evmLxg891DmWEoF1yBK6WTV7iHyo7RArG28emDVSz1v/7lrq/RtoqG1FJjnTuP0eexydqIFExQ7AHCuWKo6VjyVGW4sMqKte1tYLUiwPu27LonK5nEAku9ClusWVMS8cC/fW9/m4WMQh/UwKpevnlZMi5SVQuVqjaf2zXxGB/IGe66lravR9EPsp/fVek0b0Ws9SkMVT6Sd7/ILXr4bsz88G099RtMDzopjfp1VjJ2xwJRYl9m1vR2NsDW99rLDVwCcnn82TW7gBzWwegplP/akBd6NurgxGPREo9pVoeJJzRl+FCWjA8Qndylc8ixUHW3NCkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJIDPtvfNal+zRkdTb/po8DsleFJ0qvyBuO3zwp5r30=;
 b=PvZaJMFBvc0KM8QfhUGcv8bgoipV37LUvW9dRZyD18Z5h3BO3fSho7etb6D35TktrbpaOAVwqU09ijX3+FYYqtDa0OpEx6B5AUtTfaPYH2SSm9QLrdM++t9nTuPPLcAKnwELTlI6NTSIXDpjmLO9c9Sf7Tn8mxhZO4AOwnIwxHsYvH12O5DCrQpgVkrM5Pz7i+fCf8QA37heI/KSTfalHJFxFtjCNPrclrkfvqco/dzzuSLXPNDNFfdtGw2Bt5rhFRZrDXo4C63EPBSx2W47Zy92ne+YtfX95WePMD0saYJVNhEaTwFyE2c0F2QQYID6AQCr4o63B98/K94zyCq7ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJIDPtvfNal+zRkdTb/po8DsleFJ0qvyBuO3zwp5r30=;
 b=puRghlxr/9tnp6NLrWzrcrzj447yO2CtE9x1TmAF1k9xPElNb5Oth7xqjGu8WPV5qqjvFBMuGotbBixusTMUxe4FxNwsoi6c+6qplrsoIr3lt0F8245scTcJgY8Miteh5JxnySLQQAPU0mEO6W5ebZjDzJVR62Lpn0QizUgjof3RoEN9qmUIPnUe9luTrz8KpjejaLf16HEufUREGdeeoGwdEiDGOOsuwy0+ckCNPlHrN2/mAJmSuK6YTjS67jJpX5tBItQ3Mh2JssAf2+aXNCArf/6vo7hmwuyDpnY8nigkwSexvGetG8s6WcwvOiwUrMdlDiLqn7upHVRFDTECNw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 04:06:36 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 04:06:35 +0000
Date: Mon, 13 Apr 2026 14:06:29 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
Message-ID: <adxnwZMn-BHD5bAA@nvdebian.thelocal>
References: <20260410230346.4009855-1-matthew.brost@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410230346.4009855-1-matthew.brost@intel.com>
X-ClientProxiedBy: SY6PR01CA0030.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::17) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: a7dd28a6-1939-4ec0-dd1e-08de99120dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cFgSRt9d+Q5asGXoBZI/yweHOzf+lRTJdiSTVjYx1LJpmjcMOpnEL6LkjB3iLafzdxL6UMqLr3XUObQwlAZ5EwSgNGo191kEr6+f6hdRYcTPJ3iTOFNubFmYLZYhlLUpykbCVbDm3U8Y38CJfnz3nVvhcashcQ9dAJkYXtBm2x8ucRu3HXh5lmB9h1U8eY7mi0eN8vtpqivsBDeE8gcQVFWLJHGBUcKb3t7XU20i1VS4ZjUwDNPsNf48YcwwGmC7L3MHqBvbiYlSujTxny80qHc03LYpXXqx3D2dqFaSKAsqKZFBjLmlAs4gpvS3e1lCNWWgZSuBi7gmc9jdFuu7OBxDKho2FJfekC9QwG129uArXvBwEpQsTNxC4d62cV5/73lj42pT3AVikexvNyVcQUy4guEgSw4c2EMd3IJwoXlGE7JwEfRenKM2Tp4daDEJs6+GjBbDM88L9TqH5NG5nak2+CvFR/2/Pm0FMSumK95rX7AQj6a04hi7HPBIhz7QQ1I0uKjbSs2oz+KtlUHg/llnHNPw1PnB1br1p5xVMGH6GOg6uxfmCGAx/eKkK8kAoVBroPUxyWBxa/ElZjaXjvp6oWSBZNmgfyZ52krtQbTI1tkYxEvEt84a7NjWELyFZRcX8uhhQousFwBORY/XgtO/HuR4QtXG7LqSEAGVYST9AW86PZ2+ql/cYiyMENXTmOGz76NVH9O7eCn2DU/xnede3xpOsBaAjGLbeKAtBzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Aa5dTfGkwJoGzwjPY1cxkh14HEOlZl7/XliOgxKsqSfUxXbuSSXJdRp4MO0?=
 =?us-ascii?Q?KJG/TmuvoGBnt+285GYsLzX0cNt7zqnfpb5/8shnHEM6X2rzDd4NYu/ANOHq?=
 =?us-ascii?Q?D2F+cfjwiYz0ORS9KU3Je2osuAhZtXrDLr2rWYwYomV9d8/hSmogWWjJzUDV?=
 =?us-ascii?Q?IXsOLvQnvugQz3Z8MfXrq1tsX00Zog+iOjtWFK5qYcgDjqAzkGMztZDiw74z?=
 =?us-ascii?Q?FTFiOSahUxFhJaQOeaS2vY5xwyoUMX0GLohltsuYXofXrjYGx+ZzBPzYQvpx?=
 =?us-ascii?Q?1OEXgsY9FydiFsDRZ7I7OhMC1zIrdBr5Q7FUB7vAHC8zk+14KZZXPy+uZMHu?=
 =?us-ascii?Q?saRQFUoPybh5MVzS7ANGCpGlHWANHLtq9kOQPY+l2psDfchjo1DhWaSAsjCM?=
 =?us-ascii?Q?Ygh3qWZvg6bjAibh+eG4SdzapuffPOR38salbI98W3eAefz5qe9cV9YIBvWA?=
 =?us-ascii?Q?w0/MgJTuG8DqtzPYUKKdxBzCMzVbF8t/sIbBb3/p0vbUjbplWb+IjaKvmZdH?=
 =?us-ascii?Q?Bcefsrth++XCdh2/UuoezXj+2GCt8W9eUS6UG3MFrSa6hz/eGiS6cGEnvQfv?=
 =?us-ascii?Q?gFFkAwrRm2syovgVf9uzQNGzDDL6mVaLpgSAVK+49gkYHr8LIl/HgwpO8uVg?=
 =?us-ascii?Q?NSUvHC50FrnQpGKmGEUq+/kR2Rm+4xWI6sazUAniHoqG7n0zkAopVj99QcbG?=
 =?us-ascii?Q?ND/LfWavQc7kc/Uh7xLRDKEhHhCsGSL26R9OhEhnRnNeyyLuGjDzVtEY6fFc?=
 =?us-ascii?Q?Th4lpt98JPf4LE8YBUCDbY4lN+evL5kOBBIrX8vme6kRLBF1CGX26fEcn7gT?=
 =?us-ascii?Q?B4ETBed1p1BK71mdJ2LrazfIofuStXtMf7hRkOA4HSMnZh1tcXjHD1++D/cF?=
 =?us-ascii?Q?vNAcGqh/ADwaQjoMrsoQR40j7wgVCDUdBigZQEe3vo0QCVnbCXrULm3Wumr9?=
 =?us-ascii?Q?vtMfXx6TdwLOLJpGeQEWJMwPmNSHCmjnsTVg9W+CH9b5pWfhXPUGlgEw4dSJ?=
 =?us-ascii?Q?mt6FXRsDxOJY9/TN13pyytAVha4eXki1qUvsYmnjUdnnKt0QANtX08ogfvaw?=
 =?us-ascii?Q?+1hf/63g8YQTEVbVI8CMpOPZEnVbl9APdA6tOWSzd9QCmIsrBdt8RwE7X8X0?=
 =?us-ascii?Q?uizUmrmUnrNIRs8Tj/lOCihcwzGzdPB9CK5VcV13bU9uzdtrFfkC/GAOqESK?=
 =?us-ascii?Q?iswBTuWxDX7EhRPum918WcIngsykLi3MaSNQ4PNs2Ivcjvd1oALzT/0O5WlM?=
 =?us-ascii?Q?3R4IEJEsj9UfqTmzU/Ldsm5hLBGfVTOosxhWP2428Mrv4rA0Ag2uOWCZIjs9?=
 =?us-ascii?Q?BWXlxULmmLyd2l50K8nlS5lvt+822dhOo+xKH1rgmPztRa29r9Zt3Ado5Gz3?=
 =?us-ascii?Q?b6z7gwpWeqHTIrNpn6HmeBUjZsgcF8bru2oQiIaBTa7OuSPAaic/17AIs/rz?=
 =?us-ascii?Q?yvWP+g4nOwkLWJbTalHvay03SCoDWPAXbaldASZXJYnuRmYZg/elHEGnLRrg?=
 =?us-ascii?Q?Mmb19T0nLuVaZ0+J3cNXeOC10kFLfCXzLQGBkfyPJhxUJsKrjBnEQEo6Nwyf?=
 =?us-ascii?Q?hBr7TzoK4W9wqAsCgJIU/7SM0zNnbxKqCAHDZBsdp3lazIGjNP833zkizHcD?=
 =?us-ascii?Q?MBgCQFEmjzUVrKZArAZt2B1YoDfK3URj3eNL5c5h1f8A4atO2CvDSgFfe7hj?=
 =?us-ascii?Q?DMcB76YxBbMJVwdTVkQpU/aNPLYqRtih2sgcgWIQuv2pHjIjSqHF/5fQlj54?=
 =?us-ascii?Q?h/JkXa18KA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7dd28a6-1939-4ec0-dd1e-08de99120dc4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 04:06:35.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuuNS+stkb9e8jh/S8zW8t5x7MScyc7Zdnd6nOgjCSJU0xtbbgsi28TZoVE7lfrwpH6/Pma0N/uNRbb1bUIxfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
X-Rspamd-Queue-Id: 883E2C0007
X-Stat-Signature: 8wbyffbgrywgquk14ijbad6ztqa3o9uj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776053200-195063
X-HE-Meta: U2FsdGVkX1+XkVdGRcjiVvDhRa/6Psmu4vU7NIty36uG3Pn8nyDHMWFqP+mz77d58+5atQmWfSrKFcDwbYBRCyb1UQxeByd+2k0y8l5xu2WAvXnNmm0A/GA6ZO+ug4TM/ZGtRydb9EFV/766J0WXX2RDvU81xYAT98pUk7C2B8GaHXOA3WdSdH/F6a4yPW4d/s1XMKSNc2UD3Hyr6GZYWx6tNQowMVMKVhD3tcRzyDCySGpszLXK/7h4um/MX8iU/NEGjnmaepIc6outCjhB9siq6quScu8pOIbg7WSX5fVT9oyZdRqOR4XfmMUzIsQK0F9ncZxOBHwbZEBZLmgwMIuHAACw/T05DSmin1LaZ3XoUMJJW4u2/goMzFyLVFhRqG4cwnnL51teat76V3km2sMVm4XqcFA4EdkG4jmQTkRyO4Yu802om0RrrAvCP3k7bU/dQkZcQDZHEsi2270gn9dVU3XPxOXYeP2+FQ6+eAf/TgGkwj5mwYoMMOtj8dBKgvbWhZk8KcM0z0pRO9zfjDJmyw8s0w7DccRtYhR4eERJeOKsdBP2NBMZXLZYsi38gdKjaX9SVSiWknfQ6AB5lqxpIMXIC2gR1bajkdK9JyMCOJyp72riIkL65oKru8kSk8rqDebRJf/eYsMeUsixqOcNKGW/xgNJvi2/+uQjyoZDmsJEzmdWHcksSOwZ2ZUXxygFi4oRrLl2XO4QpPtt5F0nRXpA+sKrSPQJ8EeG168RWOQXOVOI/GQIcJymU0CSNmbdJCUxqlxSW74DTRg98y4q5TNLC/9NkoDRmdlF9v1b0o7q5NfdDHPk/fXgYrX5OIKVa8G6N69szn4COv/U7FjAQU3FONekPIDx+biMd58Upl4j6orAERQIGnyMxaPLJ1O1YleoiqBUc5zIJNkhsS6KB6Woq1IYUAk/GRixi39Eq2nNiG7R45VX+isIIzdbrtBOOmEuvqk8LrnUyJQ
 7OqZLWZy
 THnQozGBFycJ/Lp6C7arF3oY87pA1ZRwgTg6UpXm/9lTJWPoSwbaGeD0Cdco/gHtMr8D0b6yNEkHg9FFCbddnu+wh4MiN18U2gaca0jt6fkIgxOo95Tv0Qn8/s32teBlSzlw7sTYfpgs6lzekzHNt1fwqC+K4n2/wWoOEix8xzJ9AXiF7TkZdXL4BuCCAydEtu7dnJX9FJbvI2FLY45xDIDyzGbdzf3XOpefsyZ8MAOAP7U+RIq+SrGx58KwLisgREtZUN7uCJefz8Vrt7NpFMgeUjickMDrGWK9QGsWs+LPEaY1IxFzRUD5FfxQSSQb5eSToXcPdC/92CygAWvjnLYWBKtEiPY2AqIvWnNUpgWYQMfhQwD3ehDApqNvfbEBPSqEDiekX/xtZJYlXTRuen41so8gRf5CIlgpSo30cVS+AuxF5E4WxSseaVRcDdIuZgFFOCTmwTFF1cLRxc8V3ixNuIbxQXYqR0zPEHFLczHdP9fJ4PT4y2lvjav9Ruqw7o80TjewrcFfBS+L/mOPlz0Nt7KbpdCnKz6XB2MBeMo+HvNtC/CekAcMMtvilkIa2pd9LMARgjL4XDjgObl2QSEKs6YeQNu0SUqfH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-11 at 09:03 +1000, Matthew Brost <matthew.brost@intel.com> wrote...
> The contents of a device folio can immediately change after calling
> ->folio_free(), as the folio may be reallocated by a driver with a
> different order. Instead of touching the folio again to extract the
> pgmap, use the local stack variable when calling percpu_ref_put_many().
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> 
> ---
> Stack trace:
> 
> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
> [  632.400919] PKRU: 55555554
> [  632.403605] Call Trace:
> [  632.406039]  <TASK>
> [  632.408131]  do_swap_page+0x146d/0x18c0
> [  632.411938]  ? __pte_offset_map+0x3e/0x190
> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
> [  632.420053]  handle_mm_fault+0xbf/0x250
> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
> [  632.428256]  do_user_addr_fault+0x168/0x690
> [  632.432399]  exc_page_fault+0x74/0x200
> [  632.436117]  asm_exc_page_fault+0x26/0x30
> [  632.440092] RIP: 0033:0x5587554ff70d
> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
> [  632.502547]  </TASK>

I'm not sure, but I think Andrew likes the stack traces included in the actual
commit messages. I've certainly found it helpful when debugging traces reported
from the field so would prefer it there.

> ---
>  mm/memremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index ac7be07e3361..053842d45cb1 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>  			break;
>  		pgmap->ops->folio_free(folio);
> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
> +		percpu_ref_put_many(&pgmap->ref, nr);

It's a pity this was open-coded rather than implementing put_dev_pagemap_many()
which makes it clearer what this is doing, but that's unrelated to this issue
and on me for not catching it when reviewing. So for this fix:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> -- 
> 2.34.1
> 
> 

