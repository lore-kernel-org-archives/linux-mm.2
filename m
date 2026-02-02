Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9B8E7315A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE466B00CA; Mon,  2 Feb 2026 06:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471456B00CC; Mon,  2 Feb 2026 06:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336D86B00CD; Mon,  2 Feb 2026 06:41:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22FD86B00CA
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:41:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E084413C081
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:41:01 +0000 (UTC)
X-FDA: 84399325122.18.F4DD9F8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	by imf19.hostedemail.com (Postfix) with ESMTP id 231151A0002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:40:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Cj2e/nXK";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.38 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
	b=asXq0X71Nt0ZPdnn5r+OLAyy6DY42GmlnXiZQWP2RhOYvwIIG+saoO2Vy/5AeCHTNX1sMf
	174m9DBFSZ0sZlvATbtZQBo+AoKv476c0oqvTxRM2NvwNNIVWHUp6lbb9nWJRcN8/G/yIV
	R1mCA3xSi5+zEXu+29s7mtICnd2Yc58=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032459; a=rsa-sha256;
	cv=pass;
	b=ESShjNiGIoNBXGlaUpzEPPmaXtMtKJJ2CDgrRcLqtP3o7TBDOFZo3XT6CND8eyMe+jl0Xu
	3IAB8Bgs3hzFOKJRMDJCDpZNY2hwLpYng020FI/COfO+3dNK2LpH9d7/aTkHTNOUjF8Mgs
	3k/fVMO38aSz4ySfKySeKxH+gv3YyG8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Cj2e/nXK";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.38 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9+DIz2R0E9bFHHMzvYWymc7dtvqpHOekwLPfzSXLHmm8gLU1+NNFuH3EJx5Ls5UjNZxWpr7QDs8hZw3vjT29CZor1tuJ8sWlbb2zgt/4903ysaD5fnGN+2On17FfM84AUFy6539l+Ro81Ez82jBpfvczq4EXBBG0jLdtkcci8mlIIW7rr0lwm0GZnE8TQMkn8SEC7Qu2kjxZiUwAGrvlPGKHome7sEOSF+fciYvox2uLngPNGt8eKqMY4opz4mmpvMUGXZZCqVnj5PBYHX2X/MtY9ea+p5MSRTp+tEeIneQ+DJ/3VKTg8FuB6qI2c8X7w+yb50aUmsE/43mUhoIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
 b=RsATXlTPAl9Ws7xqoT2NpR9eRKQJfwgUJHieeSg1UY2koVnvUvjGcdyakiC/xo2MSarvu7b6CnrfgDW+CLTGRrQ2sao7ghZMBhxjDUVAop0KG1UILfhYu4G+2QPV35EPdQgExAvKpEQ7a5QlN9Qfcr4ZFHfaHdDFLXLwAR1Av1kxAidhdOtddEcNkkq96jv4nZY9XVY1QRorOOGvDspRUy4pjZv0h71ADfV0zHUkbns6EP8zTSHUUzlmwo6WlO80xcjdap70qn0piflc9/CjUiehHFaCk6GBRIe1N05HisUAZDkHIKv/xvKQHghB+7NiLwPAWs+8l0zjbJ9TTpaSbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
 b=Cj2e/nXK7JkoBBJ+AtX/15gY6BF8HOUWGHVDfE+8pvQodjMEHMDql72IKOqah64VNSppm0NzK9iV/wYIyPQEX/86g6h72lDQ82A/XZfOyeYCuRmFpiL9iVtVvrc0o/VqvTZasslCEekThD6lYVHVdVDu5Tg3N8ZOjXf6POOrNPpZLqlV7TmA/fjfN4TbOgUBc0sX5T9pJY3FGuFugOXIQI7+TZ0QAFKF5M1JDQheAEiu2/aS9XOmsIQvXX3OVf0xGhEQg2pQWRnaievcjZ+TnNXeJYlMKq0eGRNENRCppoKJBXJy8rbWxqBnbPTOh+7qTEMsmC9n4VqyID7DN2t1vA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:37:24 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:37:24 +0000
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
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 11/13] mm/util: Add flag to track device private pages in page snapshots
Date: Mon,  2 Feb 2026 22:36:40 +1100
Message-Id: <20260202113642.59295-12-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea8170d-27a6-43f4-f9c0-08de624f6f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zWG7D0MymmdZwLS2z5OHGDaxgXByPKl2d2OQgrdMPJIrKRcRHDBPSlGAgarD?=
 =?us-ascii?Q?ItI6twGAxCJBBzYxwV7/Z1KqziFvB6uT3juLOD+efsIUPOAqTji8sTRBIATK?=
 =?us-ascii?Q?F2s1sxeMCjyjiM19vIVKvjNzLWayZWkbHv5t2LZF44j5xl8KN1exxMU+qP1u?=
 =?us-ascii?Q?zROmAvClqPQGIuz0GCdwHPk/cFHOM7xUDenaeHMd7b3eS0813pC/Z5z0UAb0?=
 =?us-ascii?Q?TMCQr/lmH4v3bbblKuZ58Ix19fxktdYavEjAnzqQ9SaDaDhziYnMi65PV0hW?=
 =?us-ascii?Q?r9GYH/Vz4UFsFvFpSyEfXLI03HiAL5/GomNcn2en5p1RvfMp4JIwyh8tGGCV?=
 =?us-ascii?Q?qokh9+XLsauNqbSyuOvwijNb8pG8uxvj65ftJZNyohLpqeRbgsx1+m+oGgHC?=
 =?us-ascii?Q?r032HchUajA7+fK5t3t2bl5Cy8yZJrpUeNOhSlRnrLara37VfG0KwZw89XnV?=
 =?us-ascii?Q?hk2vhr4YHRPvLNhhOokHnEdB8oyjDDVIi2DcGWm2FV6Kf0YwBWipUC2F5TLM?=
 =?us-ascii?Q?JljnMe4o9d16oBZY+RIsbkGhrMO7jUl1X+rPYcZ29mG/oOFnqFNbjD2AWd60?=
 =?us-ascii?Q?lAe3Od/NJtHoSwBKqHze3vxntH6IQmuM1g6b9+yPZimBBBxL7X7hv2ia+ZEP?=
 =?us-ascii?Q?d3NWjj7TFoCg+j1ATeXTYi4B04xCLKzrcYdnDGB7KZa3KDqop/yEDo4TbYW9?=
 =?us-ascii?Q?UGTTx54ypOsM130l29atnHz6/kB9v7YjkBd36GNxoPb+VhqBTZp7RxnmHy0j?=
 =?us-ascii?Q?bb/dJHTnRqp1mFBMCSo6MZEw2BghWhjqMK7r0/r1dHd55LADDmKjwi57hIFp?=
 =?us-ascii?Q?nPrARvIgCyIFkp4YLOu8ZUOXtka4g0i2BnJlza6jn0xuj0dMW8mhI0e+0uU/?=
 =?us-ascii?Q?e46YQDpZuF6kyG8E1h+Vwk7ed2v2eYzKKirrQYvweo5g3l5xS01tmpKXdzUk?=
 =?us-ascii?Q?qubJlWDn5VMl+7a0KsyupO6Eytj6m+4hGwY5JgOcujFERFGDCN3qhf8uWkSj?=
 =?us-ascii?Q?gT+fbP1gTo1P6653JSOjtKw5BwTkZbl0o0gYjZ58Jl0R1ujCKchp1uLzsXIp?=
 =?us-ascii?Q?IiocKN64H9DS85FgSceIukb5FgB3o6mdDz84pBeI4s9wJqyl8gNj1hiVDC7A?=
 =?us-ascii?Q?KSZa6dznZl7tfJcEVd570wWOBhbwfYNyUIA1nuNHv/f93/FC7sgWKrFQmJjq?=
 =?us-ascii?Q?Umh2hLjNV2mzKjlByF5/pajGs68RiejdsIDtPaFXD44nA2/ct8w/e2JmqB7R?=
 =?us-ascii?Q?Sy5kkDpn6S4QD/dG9RQ8Qz5Qo9tSFIClA+nkjg/C7d8RT8/uLXqZ8zkL/kAv?=
 =?us-ascii?Q?HqrrKCsKr6pbaQwbObGhttCvzFU7B6zdfbs++naqOZXB/bxJ4KRGKs4XhKCI?=
 =?us-ascii?Q?zhoLgoiYOs+zNoZNeu8NdOKgPuHOsqGtWi2untX6es7JFcnGOUIhaL9z7Utw?=
 =?us-ascii?Q?hlW33zuz0+TLOkw31kVkqFMRwj0bh1yDdUfQd8vF78hGvXfKVHibuCdymoWG?=
 =?us-ascii?Q?eZHWAx605YJ6f9xKAJANfW4nB8jaIjGJCpOd6GLXtEkwBgn7GdcQua47Lgo0?=
 =?us-ascii?Q?3nWlMJu/rMd6j7r4JUI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oye/fW3/QYYZdkVK5cWVPRhqxkT19Gwplbv2iBR7P8ntofhKOTPeqAq3lG59?=
 =?us-ascii?Q?c2jx5ynV9/eJJLS2ywJCyNWWI0YmYKRUsepNbHuVIJL7wtpbptkr7O2WN8Je?=
 =?us-ascii?Q?TfnW/ZDbG04NCd5KmZ/syE7dQBlQsaSH62EsHwTFMnrIAS8dm7dAi9VEP+dL?=
 =?us-ascii?Q?lV69GeQmWvW/DI7I7jQksGg69FjKD4rflc6jTs+2ydpDzLdeRsC39fPvsNum?=
 =?us-ascii?Q?MW0xYlnf1HBPNt8x1b+RrcrAyRGYQ7lIc9OIgv5rAkuRdS8wgntFiIViRr9f?=
 =?us-ascii?Q?bhHVu+LypmA68uHpgEXny/hyJ0zI7nuF5pb2IMz9XDU84m/wK+FP5baacDM/?=
 =?us-ascii?Q?ZGXKuLtgsr/DmsvA2njp3VPDAkXzFaWTKh+EsvNrC+Hi36ym0N0CR+eZeRGt?=
 =?us-ascii?Q?4nHzRQWIunr9BC+K6fJUgYcDYtMW27Ugw4Wjlt1hs3jLWdarbt4eLGmnOdy1?=
 =?us-ascii?Q?PqCt0rgwHoFte8mxJfjMGRvMfRk8j7Cb/BdlQerwMvKmsKH4sAr4Heg8kEv8?=
 =?us-ascii?Q?Rr2dx8pzy6GB2xLlx+3JBC7j5GTjul4ZgTOLnX++850AtFx0d3Yk44eN6NFm?=
 =?us-ascii?Q?D2pjJFsN8b6JavasLNwsBTd9UtNvRuLoQsboJFr+ybarMqgt/61oHK+e5z8e?=
 =?us-ascii?Q?cdC9jLh2dSTR9OraEr+MousjiA/qyHeO1OLNN/aP2aOFNDK/wVYna7Bglgl5?=
 =?us-ascii?Q?v9kkXsYekt0Zmpz/IWy8XtCNVTR+VFZ7ed3LF/U+BVKwQNkrsh+dtM3QhhAo?=
 =?us-ascii?Q?srwxcNt6wNU6lNl7ldkkieiQHBVEyCOzxUPZePcgDvIA99veqcIuM/FYAoDH?=
 =?us-ascii?Q?dpSMqt5zcBsU/zmT+XhKjGK8hrRB/z8uF20zJq3TXlaiK8a0vjotI+q0aOZ2?=
 =?us-ascii?Q?vUYFF5w8ToGzCxs2DIZUXbhuXeHUi0EYrU2gbX619OH0Sipm0mIRrSCmcONL?=
 =?us-ascii?Q?QZ0yg1a2H4BIPZk17RjSVkXPKXK/TmWMcRedmHReMsvgu9rW0AxkwIqoV4ks?=
 =?us-ascii?Q?QhLp5DfF1ZDd+Q5vl4H//CA2ThuG6w6P55i21eq73VJPnkBehy7ij4YzGGuF?=
 =?us-ascii?Q?VE74tQ28iixXtejTwzp9r+dDtyZnEWw7QQYZKUVlUMvk4PeQAZZMUoVzU1n5?=
 =?us-ascii?Q?4qvQThY/gCh8gM3MgVeWaKB8VFo07TiO7ygUDggxrmMcQ1zW+poYo6dFxcvz?=
 =?us-ascii?Q?i3VVrQZnw9tfxsg9m1quGCZDEZ0lLWhwSC6fO1o7APxpyW/fmx91EBXe4Rm+?=
 =?us-ascii?Q?avRVtoezbu+2n8Go4ekAY0sMofPP0k4CTdBzmMoMjItD965LzYdqDuEjmapr?=
 =?us-ascii?Q?+pxbrSiZRLcljBk37NWoe9u8D7Bb80h6QZLpvYbyFXmDFtPaQUd4PRfiDdeW?=
 =?us-ascii?Q?WLsLciXpc2Fr3X9ECfkp0lYKwTzeQfKGBbfGnEE4yw2OB/XQ5BnvU3Dqu55u?=
 =?us-ascii?Q?84SJ/gQie1CgvFovlSW+nOheBRNpfpkFbeAw3blrL3K2//d0eIWehFbsrpyj?=
 =?us-ascii?Q?uWL3b7cXDDPcUvQACYQ+FgEqv5xsFCV5rveu1oyD0sH8nXo/hf5JLsR169s5?=
 =?us-ascii?Q?sjncouS/FkX3J4O+/1IfqGNaFjcu7mKiqopAg+lIoIuJ4ZtgDOiHXgvNOFvn?=
 =?us-ascii?Q?TxbbIHZZRFVGwPBbNhGtmnj+tbbF0DDgrnoHpu9NmvDSwg3d68nhN5Wppg/p?=
 =?us-ascii?Q?asep30d2SKvQngD6tXz+VEpycNnLXesJAcjfqo70woQX0o6nTaCCpTsYne37?=
 =?us-ascii?Q?8E2e4UoNew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea8170d-27a6-43f4-f9c0-08de624f6f6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:37:24.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L060hsHVZDwS2jc0Oqs30nOB4+7Ci2m2+e5SZo4pmFBWEbH99+5N4BleR52x2ybsbHq8qvIHw/kqhWFCpxs3lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Queue-Id: 231151A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rf3sq77ywafjfn9iiu1dqawbixi61jpk
X-HE-Tag: 1770032458-581600
X-HE-Meta: U2FsdGVkX18Fc90EpIFRtEJSZ9/SqYu8SQhDAZejufemXY81Bbz6LjUR8+uXHgrXBXFsNVcLmT9ovaPQhCytMGoxyK7VZ2swsMRKiClbEMzJciw8H/BZOcF/zoYGRYLMDYVSrD7SaSL+4B1WlLvLfKuvqvX2Z4W/euBk32Q8pjNkurhXhi4qB1wA9AUdHj0K1Lxmebspu0pHzpFBri9Y/XqfykOZ/5hnjbEEHRv6vbXR+jnAoENCw/3Ga4zsB5IH1Xw9PX6M1HNwilWdTEaKMKDht5mn5EsUq5p1M1XYzmOTUgXmtM4jiDEJnkS2C8veRt7yRiRoVQ4jrfQr8hY/0QaynAon3Nz/ogR3i2xkdPBZBofhDkL+dUm4BQYBzXyHl58y+A2U06JjyTyohyk3Kv4dakbClzWTeUYi3Gw7X9dY0nDVXTGe6LC5S54oXw9+zLUeRNvKCyVivyS2y9dZlhNRsVjkuqWWoXH3yhYe/Sro06xPhdPqOzBsqbBJkQwA+XvjqW1rEL8HyNi8DDPXsA7/qd68b0PUhCVOc3/giVnRQeafGBU11ioc18H6Sr3AUyzjX7WGqpFP2gtNrcMoFJeLDZZ6Njhpz3As+YlvCE21gto+Bwt8ibinp7NMkgJDP4bjkNDMwXWMaqHtYJsPK1tKVDepdw2fuFPz8vGOwZM8qxUjt/YpChVUs57exQ31Ov6FPAxB0iODix9wmB/GUxDGrq00Frn68Oy9dq3UHnbucl19itj2wilU6ER+pbqgC9ZVlujFTT9v9NfIzDSJZhH1ABMGXvXDFZkHmYmv9o0ikyDgZmy5iLCwmXQMV+DdsCREiYnDzwziqOFwkzVEIiPMHhJQQVnFI5aZTjOmlkhOfHgdLaN2OQfeznBtWBI4kIQlBMytdtoHac70OsamjYArlDrf48S3zjnpPh7ld+P44WCpGsJiNj1Vba4FbmfR3+m7LhjaUBfAW1vrjQd
 0fYhokIT
 xAkfKbPU06zFPmHjRzfkqIk8QgKgxV9enV3yAppLuu3FkxLgLbCjC+ZllqFCtza5rqQouP+PsHaYYxR5uKVMdH5zuvZbx2XyfOoOkKs96DZi+N0RpB48H0caiBGQC9rpb+36wV4R+IPGf46yGtI5lzc56kvp/wNVgTweWurIndkV69v2f+sB08viIH1RFIGaFAOLzZ2o7uVfYocgNuO/FP8mXsfJK48xofQjS/OWHdfqmosjZ253LONIOLV1iY2pw+l6b0rON7jrKwMj3+PcQbm5aIGJ5LuGKN/NlRmNveA6GjVYJ6lOqbgK5Qzw6Otgvp++hcMsIFRYVINgwHKQ202r/xOlw0mkU6sDbKOqTdSaxH+SIteMAPrKQLn/Y1M0ONlAh+MNmaSYdkrp/7/qRJc5EYmvWQZKE2IrXy4Z6Wa1gUyuUahZT81a8mmiggyN12ueNV/m0a4zlFjzBymBVPDU24Kju3TNZmswuNQaDnmsJGXc+K8onxi0dHXQ6k4u2AYro76qG0VK7LzM7gwEuDWHaOQLskAlnIyb6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
page snapshot is a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - No change
v2:
  - No change
v3:
  - No change
v4:
  - Move logical continuation to previous line
---
 fs/proc/page.c     | 6 ++++--
 include/linux/mm.h | 7 ++++---
 mm/util.c          | 3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..bc14f7ebc369 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc736..a52979536a5e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4627,9 +4627,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 }
 #endif
 
-#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
-#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
-#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
+#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
 
 struct page_snapshot {
 	struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..65e3f1a97d76 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 
 	if (folio_test_idle(folio))
 		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+
+	if (is_device_private_page(page))
+		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
 }
 
 /**
-- 
2.34.1


