Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D275CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECD780120; Tue, 28 Oct 2025 02:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A18C800E4; Tue, 28 Oct 2025 02:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469CD80120; Tue, 28 Oct 2025 02:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36377800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:22:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A5F71A03DD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:33 +0000 (UTC)
X-FDA: 84046528986.02.2BE04DF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7031880009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jAcXNeZ3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ff91Yc1O;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761632549; a=rsa-sha256;
	cv=pass;
	b=gi98SWMaRoZoBox7zmuAo8g7/Z4/jEZ2uY+l8FYN6APr/e+vcG3WtBqI75JJXwFmfMtpVY
	Ur9XornwO+yYFAYzvcZF8O83TvnL5nLsgCquMssMTOUKFJ7owXsbn2ymZJaEGarDs7ZOgH
	g4ysgX1M3d+5IAAsMMNHWYSwM84s1pY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jAcXNeZ3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ff91Yc1O;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761632549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MtVSnCvys/AJYL7KHZ+588ovD6KWCh9EKOJncTc8OA=;
	b=vUu+sD+GHRH24dRi5R7eXQxuXhpPHvmEhm8pbnWBP8g7tOxfTr6fGBziyoOqd06yTkkR+L
	fI7+jx9xSQ9DP75uFmbsPDB3Qyi3vjKEGgVui2w6IrAXAciwE394a81KnLcdLtdzKhljwF
	YepYJl+ndAwvUmUtKZS7KQzFox/KaXI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NGVr028048;
	Tue, 28 Oct 2025 06:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+MtVSnCvys/AJYL7KH
	Z+588ovD6KWCh9EKOJncTc8OA=; b=jAcXNeZ3WsYjE68QfDiWpw5dLR2ZczIzVK
	1z96olugLpS8t3Kk25Ljd77VOAYAYHCWHCPIamJ4lMg4cTFF6YIWKADwaOJUw7h2
	J4MLiQS5DH84+20PQYqQVYAbtEC2T4ZmFSO01Gl2y2atQTcpTjDLMEV77svhrFML
	hQnoZJJa1gSWoBl+cdyZYnsuKiV3xjfuq/ytfx2Uf77AL15d2X0pHtLXZwniYfZo
	2f2XD9lj7yD0+ixrpMHytm1opqQaH0GRGVjFvTfQ3X7yqpzQaj3aHLXnWgvp/1GJ
	4G3t7Dj9T2ZUjVFAbS7nRiT7LZJw1JJJ6hmOwkDknh6ToeLywwNw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a23gvjn3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:22:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S67DmZ009063;
	Tue, 28 Oct 2025 06:22:21 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0f0j14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BbjHkOXeLneuXt9zomRqSvBpT0eXne2zKbNdxge06kRe11b2rhR8VIGa+j8uXC8fvM1lpqaWOjBHvBvA7mu/5xoqfnvff8gqck/sc/rD0qYg5N7cqn4vQtnmBYGiAiWnVr7voRtz0QEmVEt0RN4vekXW1sjf9L0JfAnlxgsYAtF1wO4DG6jbk+ifXZ29y+e0SA/trlwP0h37dcISZHd1EQYIiWSoYGA9YoijiOZV8ui5jTEaUJCOfDmVcw/yF/tyxA7qtTnaVxNTLltszvJEla8cjM1VKPZOcQZg/bMc9m8EFVsBkIZOZMl72fLWoT4V1eeMnojef0hpeVIXQBrFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MtVSnCvys/AJYL7KHZ+588ovD6KWCh9EKOJncTc8OA=;
 b=XDRy+0rbKUFJBz54NiGjbMYWDcr2MsPchnmMdxu9kHpdR02bLvAuSfvvTF3l2DUgkG7aCDdXZsJqyYt1zKdNa7hj7FM438D49GmaYRl51YZ+cMZP6xkNQKlXHPAmCOxE25j+YCLnDKDmumBKjtC9m4uOR+xsztyLrup1R6q/EHpBOzpbpGsQi4fSgOLwM+bbsr+9cK7aR3cJeHh8du8cwzHBwlnqIgV0AH/i3Cj2hVJH+wNNzlm7qP/bo6E+FRy+5pFET6XKVfzrMnn9xAPWnnp+XbPAJN3utB28hKSXMhHVAHj9aeqitXoKS62yWDa7goId6A+SSnnd8pueUfRJkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MtVSnCvys/AJYL7KHZ+588ovD6KWCh9EKOJncTc8OA=;
 b=ff91Yc1O5sBb9CuZAxoEgZIY487t3fLlQyplo36WuKynHT09FaqqM6u7qzj6cuoQ4JN6GIhod4w/71u/Tl+qMFdHGiLUWI1gVgA/SqvjYNCRb6NgowUhO1KD5VcH+/Kio+I2NuzQaYsG0Cms2jKc0FwDj8UcgdXOa+o36vOEBLc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPFE06E70EA4.namprd10.prod.outlook.com (2603:10b6:518:1::7d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 06:22:12 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:22:11 +0000
Date: Tue, 28 Oct 2025 15:22:04 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v3 04/17] slab: Remove folio references in slab alloc/free
Message-ID: <aQBhDItyKGcsNaJD@hyeyoo>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-5-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024204434.2461319-5-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0198.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPFE06E70EA4:EE_
X-MS-Office365-Filtering-Correlation-Id: a08f37af-1de5-44d6-bae7-08de15ea544a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qNJs8uPsu/+oKIWSsLbsNmAmI6wad9eGNO4p/Ve7ajNtXxOnygdDUyF5bTRJ?=
 =?us-ascii?Q?Vj2628TFyM2k/rLYldAh87kk9kk6HAX7GkcTkla+WmFcgkW0srVWfpgMIeNU?=
 =?us-ascii?Q?l/I2M8E1Eat5nl5GcQfscI0Qi3RMCJgJVQjL9ffs9fBUjbk2p/jGQsP6vABR?=
 =?us-ascii?Q?+8k6qiGJDP2GJvpO7s6lQa9izyxHapYn0qm0mVp0vwsg40oBreFBo1k33WIw?=
 =?us-ascii?Q?20lPyLq02aG1WdXBVGCMqxFwotoEUvTu++FOZ5Qfs3Vtn2AswK9684sbGr+v?=
 =?us-ascii?Q?88WZEqKUKiT3X14dq2W767O8ZUoN7W7vvXV+fPt+dmCEbVo64qoOUpLqSJ4Z?=
 =?us-ascii?Q?H2ifd8PuCe4iFVL+4kIRNvBcjEKvtZuN7t2WMP6BMhBp9E4aH451kr+FQ+8K?=
 =?us-ascii?Q?TdDHCVZlxH/nyVuys1vtWMpyd7cChq7DMTtBF/oBy248ECYKR9xw5GH6jZMO?=
 =?us-ascii?Q?2HH+SfmSAg24JUJnTWdbLzXmWh8cfcripEnHjgnO2HTDwmqVKz6SyKSncBQz?=
 =?us-ascii?Q?Trq++jgc/DYJRZghBM9FDE4O5kJg308xIgBFmWrvXNzD7ObRnFYfpuhe6S0r?=
 =?us-ascii?Q?KxyFtYz+X/pwDay3xmbFA6V7VPgq6wW0BK268mOFk8lvKb6IlwCoPn/zYt9w?=
 =?us-ascii?Q?LDn+hAaFKpVZQtJ/fh7zkf+wJuiQyWm3R/6D7T2kRqkqJcSc8Mylrpbv5eNt?=
 =?us-ascii?Q?SK1HV0uD2GQDyKJ+rWj7iLDGxJlBuysqyTWJ/ESQb5RcduGeVE1nuARL90lF?=
 =?us-ascii?Q?xF4uE0XaQQ57VcQkowwJ2QcN5wzmXOMpnxzaiOn2vF2KVWJrZLDx7RA7zWRK?=
 =?us-ascii?Q?Vo0DFmJydDUMr7aUtpmXUKskzq0mWEiaKbwb1FX4NH0g0JvgdoTmrchexqR4?=
 =?us-ascii?Q?TbqvO6C/fBANuGNiwampxL41z+4tfo4a9PVgGRPE670jXS2ItteilTiVm6VQ?=
 =?us-ascii?Q?4I7un1DUPQC4U75IzwarHg962h4BXCcldOkntdPZ5RJSIcH7eb2aCwdNmzXT?=
 =?us-ascii?Q?z1cnsOt+MtLPcGZr8faL7ADudnXUWb1zTrGsdiMtSk4EV+AXJdq27Sb6nND0?=
 =?us-ascii?Q?XNXQ47AFqqEAR4aFppoC/yUcOKugWS3H0ECe+VPSvYMZPynW3Q6T3Taik2uX?=
 =?us-ascii?Q?EipQCPeO2sJGeIhogY72e+jLx5h+OpRGtmy4T6wzgxr8hmCiWK9JZ7jlG2SO?=
 =?us-ascii?Q?HqWOGZrNqqWtGfdWcrp5L72sUverSg41CXWCqfVfnoYI0qvqXZabK5hOp+u+?=
 =?us-ascii?Q?YrwjFNajfyOJvefGM20Rwa7JMdas0tAWNoKJwhPR2/zOCbq6bVYVwqsm8MOg?=
 =?us-ascii?Q?6tfVzU814EXnmecNG3pLDXfYP/obUB/35ydX+GXo4UdjTj9BgH4ohQDRniiL?=
 =?us-ascii?Q?MZqkTK+HiWxUaLm8gnU9vBu/mekJ34jHxJVTJXzd9ni6OtcyizRTIQmfYwr2?=
 =?us-ascii?Q?3BWyd513KIfgRGDjBrvMG9Pqsm003fT2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rd9GgyfhlJaj1iL+GmEXTTb6UHiAEwsp7uwwjl721HGm7M8ltp3giEju/5y+?=
 =?us-ascii?Q?tjeoQtU3w3bEByeiU7t2PJzicXw3CK5EJUp6V3TYswGMTZm93uaZeGH8ED2m?=
 =?us-ascii?Q?DP49CLm+MOb50+StjUMV/+H+hUsGJnLA1+NDT05heuP26vGStvkG3NKJBTo+?=
 =?us-ascii?Q?87hYlPn8UB2KJO6IQH9CUuQTBxtLDMyivj8EOUc2doFNOT6L2eXWpsDV+8B2?=
 =?us-ascii?Q?IjfL/LTInurO3CSjDaJoy4+IwmlqGwzGyOgRlVB3kXA94Ayr12l1Un1QOvDb?=
 =?us-ascii?Q?JuToqKFXpAgMqsFiVNJNjGJuMe5BgkPmRl380kQj3roQ9WKEaFBUf+zb/cVV?=
 =?us-ascii?Q?6ltqiufVf4rBjstbdMlG2d/TZflThwoviKxIf9gW/YQwHsd+ZET991MtRZ2I?=
 =?us-ascii?Q?jIYgEAY6g1dz08L/bNVfeD/O0TD3nOOrvwCX4zs26OVkK7OanU813k9AVYLo?=
 =?us-ascii?Q?kxbS9E/4+aRmAIInhmhaNJrhEfkIwE2/DLpJByFtJ7OjvAi8+Cu9duvN2x+8?=
 =?us-ascii?Q?phAnZsKVkfNU0/kCdtoX9WbYfH6smf2bffhDbM4vFmz9koZSLpvSZWP96Mfp?=
 =?us-ascii?Q?+fzSY3ybm4dph7Np1Z1i7sx8KhGLcDdaqjrubrcSjDTnEz3I33BuhGWx4gwA?=
 =?us-ascii?Q?1DbgkYpDXlT1lmXzpU8Zc1YzxGNiJIuuOhoFspDzlr3nDzzDHFU2KtOXL4ng?=
 =?us-ascii?Q?QDfshgQNsndmnakM9f4U2DJWtjIb5yhnGVP6RaZcAZXVqWKJj06nTbOjpYPP?=
 =?us-ascii?Q?oNAu+yxTuGEaQN8K++zwW1iWOtYlX0/opG2sVRFcch6nUs5gXln+w2vIaM+K?=
 =?us-ascii?Q?TzbezjxrMmk3jXWC8oKFi2ZfN076blkxhD5b4tV2VzhCmCeHp68UqoZvTQq+?=
 =?us-ascii?Q?YZq2//ktZcmZQeCgHw5JADkvrwUkc2VjFpOqon/qKpx5CIURFFOk5CBuuOb3?=
 =?us-ascii?Q?V1TLHjIcCcgLr/fihdbRIZMsTwaExNnmtFExbExdNcqawfM4z1FmjAHb4qjZ?=
 =?us-ascii?Q?4ZvGUoXMHtQWrDmdVjDl+Seua2NuVx3yiIv3Ih0FXLpT79g0i5Z0ibf1DWoV?=
 =?us-ascii?Q?S7RkhD6wBRFXajaj25E7F9OuwLuv0otyzHkt1dGNPGasMzlS4R5mKZ1WhY3s?=
 =?us-ascii?Q?5I24I1BarD+0taSSkheTWFO84XHa38/Hz2MNgC1Sb/l2SiCtCtR05TeBVqq7?=
 =?us-ascii?Q?yiPRdRZr1yL4ZRqRfePGAi+fmLNZBub5cRzvXH5NRjjEB2yXhuo34DKbCISR?=
 =?us-ascii?Q?77z7CRiu75qdd6k7/mSvaWDkB0roEkHfJHFwEcHyzx9dcYtZsMdT4sjjaI52?=
 =?us-ascii?Q?gtbsQ7M6kJ0OYLrg2YUipzXrk82/0EVCd58NEB1TbrrO48w34PZ5y6XnJuyx?=
 =?us-ascii?Q?mmmLTFBsp+P7Fs5lJhYPvZhl1N9jAjMQ4YOtVStqq7bq9tBuEyNsjIDNdUO7?=
 =?us-ascii?Q?S4Jh78jKiNXPHLXA2h4g4F1ClzTxLPT7jaWRH3UKuQ8F8hOohZrKpdYhdni7?=
 =?us-ascii?Q?0iK6r6misfavm07DJKrGOJ/Lbi/1YUpb1jNX/fUfRY+9JDcNK5RHetRbWTXH?=
 =?us-ascii?Q?7Cmv57AXFxiLGSU4urx7odMTNOGgVJPGZpfEWXSI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YV7aDfullYc7NTTXWb9mG0akEjOKr6ZtBBksBJKbwPJK9fdNC06Mdm1Kkaoi5vZNKjumzxZu9fBtyKFnlNVWvYXmXmxR5/XkH/YjWCpmgNi4XQpYNbjyOL2MAontBlnTvplugTj/jMFyhbY042k9rAwPwDHAyqzzbPbOUM18uH3+lxoA4UDc+9S4Zu8o9vLDg8vK5198oL9G2xv0PdF5GK32QKsorLvIHb7ObkSIpPrEdwMnI0Tgo2umyeG6B7HNdr/iwHrcG7p4Meyb40BwwDY0puy2lvoLQtMAkZCL0/04hsiPMvt1XZCpktK9upeGTlhIfprE6GlTkMNC4D7XF1vKOOZVVt4N65F5B8cAQSRpC1yVXXmjDqTMu4zgRa0dcPxLtcxfUMu/HcQkT3f/Ka7a5fdm9M0Qt+ChvH4FvCfYDjaysKQ+v5nmh3JByRfKQNl4bPC5QuEjtBj1E7uDM2OrpCsTDWduc6zE6tDlWzbnP3CW/kczZH5BvyhW+1E99SCkGetW6wrFJCC4Hcqlm3TmewChjBKOjF9TZpjcp1ZVVic/WNAv/XClk+g9kFGitL12kHJAkPP3uWcg1/Rf/IeYNGJtRAaB64LPG8JVR+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08f37af-1de5-44d6-bae7-08de15ea544a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:22:11.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Avf9+m6bO8zuYlgQ6e5uncvB5sTRJBbohOTCjQUwOzCtry8vWYUp3eCwyHtuM4ZIU4Lt6OkuyxEnBmbwY5CMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE06E70EA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510280052
X-Proofpoint-GUID: sQ-Zm3RLjP8hJE7xK-dWKzmpRbaD53Oe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1OCBTYWx0ZWRfX2g/zVA4aP/6R
 h3jFEcvHk6a8x6zxCSVCTHubba7dPLpAagthWDss3N+lUPG7N1UQlwLwCcbaJGtOIJ1soGhYgwZ
 X7LTYApLP/A0xpkVPmixnK9Oi0YSbtKvYftGfmAt76Djr6zHkxw2rcMJUpayvf8aeW01hiZK3Dm
 QSnghVvMsI8wZoENVvVNA8/0xXqAtSVO+vMDF11b48as2nNx1lHd62wF8Ye3JtACYDG7QWNfwrj
 Ks60d/JFWA98XQVVoh0R+1KTj4klFSHuVzoOMzjKLlGIx77qEDjaOOiNii+Q10yGZlp3VllHKou
 vwWpGQaeFVtavAGURNNw9ztoQBZE5E+wZBZ8eivwsdN9djqek9fdALumOxcABgWT2GgciCMixgs
 W2VpG9j+USE5YPSzLia5DlM9e0uKxDoPcwEFDRkq5ieE2MekHK0=
X-Authority-Analysis: v=2.4 cv=HsN72kTS c=1 sm=1 tr=0 ts=6900611d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=lBMtVDpTZh5DaayZa5kA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12123
X-Proofpoint-ORIG-GUID: sQ-Zm3RLjP8hJE7xK-dWKzmpRbaD53Oe
X-Stat-Signature: t485hhk17bec45odpmw8qsypa1869sjq
X-Rspamd-Queue-Id: 7031880009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761632549-971657
X-HE-Meta: U2FsdGVkX19ZM9G07HVPPaaMOgUjPuPAggTQto2mNzZB7ezqrUJ/lfp4rZX/1ffZmfa9BliAFONGnByZbtl2V+ch+wCn4esRbRMfz8B+TQKHxWSTvzA5ehTkdjEfGUWsz2jRkvv1TAByBiZA5RSTgosk/aXkA2BhnE13ZYFp0oJy7+U9Tw5cNqJ8C3STJlTpMzC8WPSWCQUJBnDGmvSLI996jwLfqYumnfUfDRoV8UyWBZBarzphpRHjSOtvERU2AqLfpr/T7Ixz3H2ptPDrm8lC9Na5lPiFv5I+avZRMbsBwcIJ1i8LYnEAdmHw1TZImUYvPvjMHjgqHmotjym35RXEAWouNvBNnXaV67szy0fKrkcg+F1mqXudKUsqCygNy84D9k29zuFRL82a+LJzYrqbhBlHPvXPgyb0bSNofiUXlKAOOUTRqWsW1fxrXr14qo4c7/4slyLMlVKpcLA/+J+ry1eSQiKFO9wCtWHhZVRf5nZ6gABZc3XCV4I10L9a/gfLhkYBmTsX4qkKgfNVs7cH103g/idvVgm6Y6jeTsiZdhEQySGRRPL8E6hPb4T9bOOeew4Zdh3sGMbYwbVwe/d8nH5jPdT0vvFswNCZVAfjddVwP9C/gNCUPVnV6ueA7ZN6INBkjy/VIuHbW3whUOVBcLggEvI8HMAEnzW6HNXak2O9GmfjkZMQkfeAtPGiZVr1KRuznodWHUi9x/Vhp9efoInMLKurv/4GDNuwG2cGrVOvzPx3lSKsC20GTvDIBRc7QRiLUzPgCZnx8Fzgv1THsAMRaLzYin0IgNktY9zExIicWI+XeoxDx9iHFpY9E/Luvq/zMGRa2AuKVzwEY2tLwQfGR4Y43Maw5wCY2XQ40ZohQmRELIQWZwBaCKXsrWXJDcCM/iwfGjNmeROne6TMbJ48zy4U2rh504Jbp2q879gHAmwk6NKyhLMtSaFNSmLJhAXo/wyiOra46Mb
 GE5v+6i3
 Y99woIX8+5sXADy1qAbZuY99XCQaoFCLKazc46dPoOV7nbuhqkvpvEj34jeCAq23PeOsH2sqVNb/n1kM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:44:19PM +0100, Matthew Wilcox (Oracle) wrote:
> Use pages directly to further the split between slab and folio.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

