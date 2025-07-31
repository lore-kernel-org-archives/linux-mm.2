Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EC5C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF326B007B; Thu, 31 Jul 2025 11:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC3F6B0093; Thu, 31 Jul 2025 11:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5DC6B0095; Thu, 31 Jul 2025 11:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1B76B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:13:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D7F758C88
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:13:33 +0000 (UTC)
X-FDA: 83724903906.05.796BE02
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id A084820005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:13:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TuTn6ohX;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753974810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcza+JNF+hy5WaiW+B7EB++1RZoUIVbmDY+FEuYBNIs=;
	b=4f4dCCEmtZyNeBy687MgckLKtrMmFMAxYvLuMdtI9ORaE4PTo/OikbHk7C3Lv6+6Sc3IXR
	yUopDqKpqk/bxcKmFa40RD+URR9M4t7EA/kn+Vjus7ICfVTSShtODdzmeWQ8nkJN55FO29
	DypeMSKIk9eWhCHyXB3SUbWbdjronG4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TuTn6ohX;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753974810; a=rsa-sha256;
	cv=pass;
	b=XnnP3iweLWEI+cf0JyGvhhiF1tEuZejR5dAy9xjBVeQ09P9UfcytrlpOlkz4pM7c8ZUtvj
	TI0J+/31VEKO+b1ZXbaxEn+dUWYCBkb9CvKqBDjpWcjfsVa0ObcjV102VckL/SjUKEWrHK
	AR3FBbBR1LXUP3yNvLN3Znt57Ucb6Ts=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RF36mPxoa0Hjg1mJmY4CqDYvl+zG8qTS2eeQGlfp6NChWqeG4FTbsW94fOglMnwwGU3OFU37PbtykS3+CQS+bP1DpOBk7HXNtzKRchcCkKEs46vhcTE7t+SZz9MOb4cM4FTswq20ZRp5SkIGa9RsxE4CeBaq88MVVvNghIrs/DhsdLFkOsVKJ5jIFiva5pq8RSoCSn3Jb1KvuHcmONSjaRlWt6C4uGn5x4FUxLjBn2Jos1b3mHLNfvsxG36NhCX64xlxyceBo6WgqgD+km4ogqh3OtwtCHwtp12WxmkCmOZsLk44e9cO/rX2GgpzhJMDa01BcS/hUC0tq0xZQt+MUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcza+JNF+hy5WaiW+B7EB++1RZoUIVbmDY+FEuYBNIs=;
 b=wFOarpEEjg5E4VlWOPvbfJz4oOAVAk5FLmOtKzIm40cPcBA6BVjysIDskTpP2sO2rMebDo+ydYtL5A3QFAJC79ruYAxs5QbYja3lUjRIZAjwJBqLfgiNrTTkRXa1rdYHdEQS1zDGsg7TaSI1DV7rMOU8KBy4ypFO5l3bdTT+iOFXDg5/d0ml2+Cy1e6iDUIC5Wo/2CHJglNoG2LqJSCj8Y2t2z4OXgOuR01YN8ttVXELBvXIPMq6zrFN+R1pvoic1uXvnPiPwAOz3qa2lTfRTuQUSmks6GCIRINn74QytkFhAO4cak+m58WYYHkTutDjTYBI1CPp1KajG9EYNicpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcza+JNF+hy5WaiW+B7EB++1RZoUIVbmDY+FEuYBNIs=;
 b=TuTn6ohX4M9+J/HzOrHS7V4nNl62t2cQkwFSh10ERTH7paubfd5yWXnzMmPW0JiexDL9PriE0QdK2WuCAYQDm0/n+2wbILNR+CQILCEGuDEtsjRnymcgGbdvf9QjFA28/4LTPSYRbnivKe6uudPdKGkegxUb0VVk3vGVV2jYtKYduy/gwHYD1tnYqPoUPHqpdhvigjMav0ZFyVEemWdigX/3CyU1LySU9WTWnVqeA2xW7OSMok8GmEd80TtbAe8cAyheqNkJ7fq10CkAFd1/lyMZ9c0DuBBwTI5o0JjxvkpjxRzIyqmUnckxTy3Hyxdt069/2YnCW/SN7HmiJBUg7Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4346.namprd12.prod.outlook.com (2603:10b6:303:58::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.14; Thu, 31 Jul 2025 15:13:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 15:13:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
Date: Thu, 31 Jul 2025 11:13:15 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <0ADCB72F-9D63-4202-89C7-D55734804E41@nvidia.com>
In-Reply-To: <20250731122825.2102184-2-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-2-usamaarif642@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0139.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4346:EE_
X-MS-Office365-Filtering-Correlation-Id: da5483bc-e9d2-4547-c5bf-08ddd044cb4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kDsZaovEyR+RTs4ba2Uoh35DLt10JGKVUBFFvIEGAcoxxa0wzKn97fzVW7AX?=
 =?us-ascii?Q?9TQpZAxbB3mLKW5Rlg32moDDLt9sVaMHl4jgxaCWOC9TKwXYuhEo1wvFviW+?=
 =?us-ascii?Q?kEUMI7xqG8d83MEuonwHX7DqVEmHvSfE6nb73MhXJ6iMzEeUgyrEpg1IDuJh?=
 =?us-ascii?Q?X9ZWws6NX3MXPkE5kqb8blE9wNVHxGCyEApeuWSlDZwFIzW/mWiUqvFH3r/m?=
 =?us-ascii?Q?bMFEA7zuI8E9kUgAWqyRcxg6IUxMq9EAd44nAKlGrj/8/TAGwXg3XF2r2jmR?=
 =?us-ascii?Q?MhiGMgzB+LnzoMf1dUOLn5fHChySyOJsbD8gypSS17CSnYGXvf8PwyakTcgw?=
 =?us-ascii?Q?71NqeDNKL0cN/XVcF576XoJ1YUa2cwz76XR0vC7IFAQGO8g2bzW4ME308M0t?=
 =?us-ascii?Q?dyIQsBomM/ddDiDm7S0ngjR00Nt60JNq0/IE1bS4zOeFA8SYJhNlh6ggtTur?=
 =?us-ascii?Q?tiaGtedLv++FD0jo85LaaspjlT+05OMBUCV1Wby8l2EwZVx5bRu7x5WZAq5K?=
 =?us-ascii?Q?y395OhMECVcHm6nnoxWlXaAuPTnGDzL90FC4fwrpx+Chx1kUap3jqempD/qB?=
 =?us-ascii?Q?/QKHgHOq8Y02X12DxDAIWjYnuGMKDIgX788JMGyItBGiZEhP9aoaaydEUF3a?=
 =?us-ascii?Q?XiRrqhDGhRyCnmguhglUcTfbGpb41jWmEtfO3/7mhUf2mV8clH3Jgn8gByLn?=
 =?us-ascii?Q?Kpmnjo5E3EnQ8VoqGd8b466EdSADnzzcw3vsQhWmkavwQFHFA0IJE5/01zuX?=
 =?us-ascii?Q?4hahX8zfD+hrYdSAeipi01WpNK1QkrAtfylrFNGxBX3pvwDNecD3LdOcXdio?=
 =?us-ascii?Q?+WZ7zAOp4NQDLBIQFACwKTvOms4w1zhCpBK1BL6XIqLTp5iqri6VPrK9Vl9e?=
 =?us-ascii?Q?G/vInn57mPD7awrVrcgXJjRlEMtYCJdO4Yn1dcfswnhC0f3filAf1O0DdtPI?=
 =?us-ascii?Q?i+qHhwc0alhk2HBiri5jv+ZFadxX2KzfBKixdFtG4KPgR+2jxWGRzgR0hsJD?=
 =?us-ascii?Q?V7YKQx1ev41hMUeVwe6ouq5G8VGOUaN6O01EJGX4Ha92OGpBynY0aUEtzmz/?=
 =?us-ascii?Q?FoJMgOeJpeLaZAUTuv8UXgZWgYjezrR/tHWsgBvsyhqLNZ34gHIvvEK4LW+4?=
 =?us-ascii?Q?3bfdMydePQjNlFyIr4SUIjwfaD23GzbmbaYtZCiv/U+mxX4Ciy8nSbuD8grM?=
 =?us-ascii?Q?GA3OIrYZ7aOoTW3hBxhkAKA0VP4MNIN4WW9DcX8Xwcd+tnzRtj6Z8NQaZqnf?=
 =?us-ascii?Q?kxaCdBm0MXQPV/FE7RfA3n3SeR7DT/jZN3Zt4kY1iBMRkjxCK42FQ5sF+Rls?=
 =?us-ascii?Q?27W+4jogMBB2X1+jnZKSeDYSG8D1VjMNOxFDA+LFj92v9WexC09KmZP67CgA?=
 =?us-ascii?Q?6gnn7HfgO6KQpDl14eyzwHi6+IYwQqoIRDuydr07I4rGP9RgcdUUd8UvRiab?=
 =?us-ascii?Q?f0ig4Un8k58=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NPaXzW1SRzwiTLjC6jjJ3OCwbk4DeXa4wwD9I/mFq2uSkhqivDfw0fNaYG/w?=
 =?us-ascii?Q?nZovJAaK9a/BHDdOI7SL1uCC/DWPIH8qLvLjeekgf8beo3E1kDR4WJzo3M9O?=
 =?us-ascii?Q?rWjs+piPpYIdGAtCURvyWpIqx+xEMqqWokpYlhGlNLVPrUH0I+wE+Pq7phtI?=
 =?us-ascii?Q?nfQb3IZmYnf3F6Sk9MkQ5YXq8iHjqrKBy6+AU+3GcjVdetrRoghiLVLoKpDl?=
 =?us-ascii?Q?UrVLuS8owo3/90/WLpqPaW24ix7gQYZJAUOvy9pPpb/87O+NLBYbYo/BM+7s?=
 =?us-ascii?Q?ll0ofVIIAxrIv7ITRdPeYzxmz4bXYnXD0j51HJplxW+sEqlqCqaFpqEafvD0?=
 =?us-ascii?Q?bOhfXi1kJPiTDRTMXjAvWnIPAfB3R3tZ0HP4OnHW4tZQkxVcxtY+as4/EFcL?=
 =?us-ascii?Q?5LfF5rlSbEBH0y2knRGvextEDxK/4Qe43wBb5UP0Hhhii8Lt6bRxyjhyIEw9?=
 =?us-ascii?Q?waEAcKAVX22iYTVS6ePQP1Q1lfMcp1c8z0fGA7WSi1csAXxEVJIlGN+5bA4M?=
 =?us-ascii?Q?vPuJkRkelIXqlsF8ec8JG2N/cuNSQYu05301Mw9J5ZU6vqexfHqCv2Vthlqu?=
 =?us-ascii?Q?29Px03rUY0KZN+WHLDJC7NFj+N//ok68g9GT5eLkXUhDELTz+A+I3INPwGsw?=
 =?us-ascii?Q?X7Jm9TQ468WDyxAGL2Pt+7bez3JnlqIzP8O2FnsiPLV91EEMjwp3kySIqoZ/?=
 =?us-ascii?Q?Y3WC4k9hczg8AHNg0jh/Oo5AruZB2swi7yhfPyB0luNKEcVWnKfnhNAUVfyQ?=
 =?us-ascii?Q?OWQRw2mTbJeLyPtHifoOgG+MMFVLAfM6MUuLMthHqVS3enSWXNjSrPm1VT6A?=
 =?us-ascii?Q?ClxDMD4fCxXIkOThGvOaG/v2RYiFAUvSmO9tPwECs4JS/QJW1kVCnlpnoyik?=
 =?us-ascii?Q?URalPRZwnFWHMmSCQsXNMr2RKVeW/m8x5+3aH1soeyjWzqv/kDwb6mtzLlr2?=
 =?us-ascii?Q?GMcCAYpUD3gKw51mu9W0sBNyYkvFWX7FQwRc4kWPG176Cp2wEY0NZSX4qdTk?=
 =?us-ascii?Q?u5xZRAa0xZqNJs9XXWsOR18/q+WUa0xv0jyuAxG1puX/b1PmGVFKQKUizlX5?=
 =?us-ascii?Q?sJCT/vpK04EECaEsztQBQBzbgw/5PM/mxdyuhgaWVP5vSn2zb+s0ZIuAnQDC?=
 =?us-ascii?Q?rzHL9lwOm+dgKpHuaOzO/qrAkZOiKYU6QiVlzmfzD60kscoipbTDhRhBBCsd?=
 =?us-ascii?Q?wmerZVKg6HOWl30JRTMkVtRppjc4CdEnUy55+xtqB7yo8TZG43nF6ww6FL/c?=
 =?us-ascii?Q?a3NN46aEukVG23E+73HFxezYRaI7YbM3Nn8aF78nQPx9MUll8D8wduAiYCKh?=
 =?us-ascii?Q?oEBO7aXuN6qbVnQfV6tkQzVEEyTr7kFjOWwHmFbZKy6jLhXwWGy04/xssPm3?=
 =?us-ascii?Q?1V0K4yTsmeKEPXwMh57HK13cBbGHL1TzUDy+dVT85FaY2BesSqc9nFDpqfRm?=
 =?us-ascii?Q?zhinaDJ3at2yMCm3dCZ9Ci8rDq8DxeOXlOgU/loyL72V0Q4sQh00coUCTyoD?=
 =?us-ascii?Q?IEDRswepo0lS9PmGd96Y6LoPK08GgvJut2mYN8+x7XW7mGILRHCSisoV6Tm5?=
 =?us-ascii?Q?ayD6hXIcdZ4gDgDmdQI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5483bc-e9d2-4547-c5bf-08ddd044cb4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 15:13:24.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75oTQWr6M1bDwW2GmlNQANzdjFEuRDjwED1DFGesCHrgaoJeShc5D//XOaPIicnK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4346
X-Rspam-User: 
X-Rspamd-Queue-Id: A084820005
X-Rspamd-Server: rspam06
X-Stat-Signature: 4rrhauc7mp9goe4agzm1k8dhbodepeuj
X-HE-Tag: 1753974810-46932
X-HE-Meta: U2FsdGVkX188kOOkV1qFdgIB/j9sxHThRlsKu4eBMszYvQcb3wPTlrOjKvht5i+Y7128vjRZNavQjGNSuuoNDjlj949sGwEzuikH6A3ip8aXknw1C6PZA6pRtIp2LGrwIy7n4muYXZES1haOshHbelr/AH3K49wQFigD0uGLZyxDc1r6O3hi7WBH7Bd64NpNoScD1u1QQtBxISKH2AsrFZ02fjmT997U3W9Q1apWzmzTteVKtTHwcbKNvCvaypR3Y+ZHzCEyOrRMfG28R6Qf/pPWdWo5uk1lTS25AQW/RQD+/9wDo0AAZyXYJz1STJfO6yoIpJKR9i2J7qm/9Su1fmV8oHtBjhzCW4T2C7rbXnuYS/nCeLEG35J5UY8wldhHnV/xShySviqZey+BGMXtZhpMSi+FUmACzHCjsk/Ii5FiCy8ihrqdfyCS4CFEcCA0ceREfpC1kyOvxEHD+auZG3Mh/VQG/FR7S6UssWLnnubzs1Uhv6Gzbao4HHa1ZM9zS3sg27GSdk56QfTU723l6RAFnEitJ9/aKNT/y2A1UGr6P2EHJrb8zJVQSZQ4oPvoYNq/EYBpesQUD+p1ljhmawTfxTBOm3g5da4oRQ+F2iD8B35IOGx6cUIt6LVJuWkc3FmnO2CKE/As9/ZWUS84VeqDCL8vw7cEacBnCpnGkgG6GOkQskzxJtd7fRTJTSJ15TuUBLHLnPUQLw9HZAQC7tN8lRrOZCi00xs3M0rSqMSzCpejOfXAmM7Ux3J3Q6CaY7mL1ninr3kd4wkLDXZYyHQ/8kBIym0N8TjCiW9YA5rTC522u2OJoxkyEyOgW2/suG4EznrZeqR9FdLPHd+Oa4JuBwPW97UtnVXQLpSzg7UoLXUEjWSsdX/SFpU+ylWIuTXJWE9ExJbKd/ljGMT9KT5L1Nmtv1taHWwjLUJ9rEeZj3dx/mhKt+d/btNEG9tCIo5Gcw19hLmrkNn/CmI
 E5A6xeqi
 3tJ5B1a/sUV5LEGKErnbO8ap/XGSRMrYNc/xoTHgfi+5fy/eIbZi4sytwHCF/isxswWEwTSj4THDXzIT/SZjRGwKVJmpKxw1s+fs6lCHgJQAtvlipwyh535Ldsnp1tcX8A3DN6pKCRtOV2OcibKtHZByTFc/WLqtfwtPayL2Fe2P1uw8mgC9SN6qiBW0ngjAKfQp/6h7eTrfY8nfQa5wEx9QpECMK78QEEIay1HlPiVm6lMnFfzNmSyaOtouXMaq6NgaYV9+LO6jgySLYYwI1KxOID9BfO3KU4Xla+mxNOWtdK2XY7X9DBDY0WcLTGqVu9LlKeCT8xYB6VMygWXizETzKUaRReYbGr1tUkpuDQjTahoFBQOMVWM8L8gPxTeBcfq038I1KAB3RAmxJwhHFEZLeSuhT50S/xbqRiYujiNgHtncRhN2MoHBbulTtRRRWFI6mX+/wWM2hpBTScXYstAWF+M53x0S8iPaRVI1mZ3kFOdoJp2T2ZXLaObkSysHtq//X9WDtDptzBSeEaXGkb3GAs+Gz86AxWjdMM6s1ILb6J7MNBP6+sRKjvT1rQPd1QEI0RvpOebBfLkxSqhMvYlxNpI+lIqUlCMGQstDLljhEu1ILuO60M5qZFseyDhTHVUiFKxJ9tXx9nRdVwSO0mtWQuWWsirkmonvY5poNj3My3Xlq6Q6cn2pq/uRWEnDeLaKISRm9UPKcnqAo7sOGtw8EWi4/eGGksMvl/hks9PKgDln90RUsK0oFHvxez3PCVqLdu/JKo9xHeNgnZBYHiEd9tl0QB8JMiZdYjNVJOY8bYOP4N1rqv9/R83+sUkHpFsrzbMD4ipO5cEQM4zsMbDRNgqBV0Q8G+xxhOnIKf/3YiVwxiR+Z6Swd6ghp7UOXGjXDTbMYLvLB5xMQntg6Lw7Mghb/Ym4/qzKW5jATh0LOlfYBAu2lx+HtotO8Vz9Y6Nz2DTftzxJ5QYeaK7BXUM8kAv0q
 gCNntj41
 kv2bauwIXsW6WOgfl2K1YWr8nW6tg/rZxA0C4ACjz/L9JWdQsSgqvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Jul 2025, at 8:27, Usama Arif wrote:

> From: David Hildenbrand <david@redhat.com>
>
> People want to make use of more THPs, for example, moving from
> the "never" system policy to "madvise", or from "madvise" to "always".
>
> While this is great news for every THP desperately waiting to get
> allocated out there, apparently there are some workloads that require a=

> bit of care during that transition: individual processes may need to
> opt-out from this behavior for various reasons, and this should be
> permitted without needing to make all other workloads on the system
> similarly opt-out.
>
> The following scenarios are imaginable:
>
> (1) Switch from "none" system policy to "madvise"/"always", but keep TH=
Ps
>     disabled for selected workloads.
>
> (2) Stay at "none" system policy, but enable THPs for selected
>     workloads, making only these workloads use the "madvise" or "always=
"
>     policy.
>
> (3) Switch from "madvise" system policy to "always", but keep the
>     "madvise" policy for selected workloads: allocate THPs only when
>     advised.
>
> (4) Stay at "madvise" system policy, but enable THPs even when not advi=
sed
>     for selected workloads -- "always" policy.
>
> Once can emulate (2) through (1), by setting the system policy to
> "madvise"/"always" while disabling THPs for all processes that don't wa=
nt
> THPs. It requires configuring all workloads, but that is a user-space
> problem to sort out.
>
> (4) can be emulated through (3) in a similar way.
>
> Back when (1) was relevant in the past, as people started enabling THPs=
,
> we added PR_SET_THP_DISABLE, so relevant workloads that were not ready
> yet (i.e., used by Redis) were able to just disable THPs completely. Re=
dis
> still implements the option to use this interface to disable THPs
> completely.
>
> With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
> workload -- a process, including fork+exec'ed process hierarchy.
> That essentially made us support (1): simply disable THPs for all workl=
oads
> that are not ready for THPs yet, while still enabling THPs system-wide.=

>
> The quest for handling (3) and (4) started, but current approaches
> (completely new prctl, options to set other policies per process,
> alternatives to prctl -- mctrl, cgroup handling) don't look particularl=
y
> promising. Likely, the future will use bpf or something similar to
> implement better policies, in particular to also make better decisions
> about THP sizes to use, but this will certainly take a while as that wo=
rk
> just started.
>
> Long story short: a simple enable/disable is not really suitable for th=
e
> future, so we're not willing to add completely new toggles.
>
> While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs=

> completely for these processes, this is a step backwards, because these=

> processes can no longer allocate THPs in regions where THPs were
> explicitly advised: regions flagged as VM_HUGEPAGE. Apparently, that
> imposes a problem for relevant workloads, because "not THPs" is certain=
ly
> worse than "THPs only when advised".
>
> Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
> explicitly advised by the app through MAD_HUGEPAGE"? *maybe*, but this
> would change the documented semantics quite a bit, and the versatility
> to use it for debugging purposes, so I am not 100% sure that is what we=

> want -- although it would certainly be much easier.
>
> So instead, as an easy way forward for (3) and (4), add an option to
> make PR_SET_THP_DISABLE disable *less* THPs for a process.
>
> In essence, this patch:
>
> (A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
>     of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 !=3D 0).
>
>     prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED).
>
> (B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
>     PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.
>
>     Previously, it would return 1 if THPs were disabled completely. Now=

>     it returns the set flags as well: 3 if PR_THP_DISABLE_EXCEPT_ADVISE=
D
>     was set.
>
> (C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
>     the semantics clearly.
>
>     Fortunately, there are only two instances outside of prctl() code.
>
> (D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for V=
MAs
>     with VM_HUGEPAGE" -- essentially "thp=3Dmadvise" behavior
>
>     Fortunately, we only have to extend vma_thp_disabled().
>
> (E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are
>     disabled completely
>
>     Only indicating that THPs are disabled when they are really disable=
d
>     completely, not only partially.
>
>     For now, we don't add another interface to obtained whether THPs
>     are disabled partially (PR_THP_DISABLE_EXCEPT_ADVISED was set). If
>     ever required, we could add a new entry.
>
> The documented semantics in the man page for PR_SET_THP_DISABLE
> "is inherited by a child created via fork(2) and is preserved across
> execve(2)" is maintained. This behavior, for example, allows for
> disabling THPs for a workload through the launching process (e.g.,
> systemd where we fork() a helper process to then exec()).
>
> For now, MADV_COLLAPSE will *fail* in regions without VM_HUGEPAGE and
> VM_NOHUGEPAGE. As MADV_COLLAPSE is a clear advise that user space
> thinks a THP is a good idea, we'll enable that separately next
> (requiring a bit of cleanup first).
>
> There is currently not way to prevent that a process will not issue
> PR_SET_THP_DISABLE itself to re-enable THP. There are not really known
> users for re-enabling it, and it's against the purpose of the original
> interface. So if ever required, we could investigate just forbidding to=

> re-enable them, or make this somehow configurable.
>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> Tested-by: Usama Arif <usamaarif642@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> ---
>
> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I=

> think there might be real use cases where we want to disable any THPs -=
-
> in particular also around debugging THP-related problems, and
> "never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE=
=2E
> PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
> helpful for debugging purposes. Of course, I thought of having a
> system-wide config option to modify PR_SET_THP_DISABLE behavior, but
> I just don't like the semantics.
>
> "prctl: allow overriding system THP policy to always"[1] proposed
> "overriding policies to always", which is just the wrong way around: we=

> should not add mechanisms to "enable more" when we already have an
> interface/mechanism to "disable" them (PR_SET_THP_DISABLE). It all gets=

> weird otherwise.
>
> "[PATCH 0/6] prctl: introduce PR_SET/GET_THP_POLICY"[2] proposed
> setting the default of the VM_HUGEPAGE, which is similarly the wrong wa=
y
> around I think now.
>
> The ideas explored by Lorenzo to extend process_madvise()[3] and mctrl(=
)[4]
> similarly were around the "default for VM_HUGEPAGE" idea, but after the=

> discussion, I think we should better leave VM_HUGEPAGE untouched.
>
> Happy to hear naming suggestions for "PR_THP_DISABLE_EXCEPT_ADVISED" wh=
ere
> we essentially want to say "leave advised regions alone" -- "keep THP
> enabled for advised regions",
>
> The only thing I really dislike about this is using another MMF_* flag,=

> but well, no way around it -- and seems like we could easily support
> more than 32 if we want to (most users already treat it like a proper
> bitmap).
>
> I think this here (modifying an existing toggle) is the only prctl()
> extension that we might be willing to accept. In general, I agree like
> most others, that prctl() is a very bad interface for that -- but
> PR_SET_THP_DISABLE is already there and is getting used.
>
> Long-term, I think the answer will be something based on bpf[5]. Maybe
> in that context, I there could still be value in easily disabling THPs =
for
> selected workloads (esp. debugging purposes).
>
> Jann raised valid concerns[6] about new flags that are persistent acros=
s
> exec[6]. As this here is a relaxation to existing PR_SET_THP_DISABLE I
> consider it having a similar security risk as our existing
> PR_SET_THP_DISABLE, but devil is in the detail.
>
> [1] https://lore.kernel.org/r/20250507141132.2773275-1-usamaarif642@gma=
il.com
> [2] https://lkml.kernel.org/r/20250515133519.2779639-2-usamaarif642@gma=
il.com
> [3] https://lore.kernel.org/r/cover.1747686021.git.lorenzo.stoakes@orac=
le.com
> [4] https://lkml.kernel.org/r/85778a76-7dc8-4ea8-8827-acb45f74ee05@luci=
fer.local
> [5] https://lkml.kernel.org/r/20250608073516.22415-1-laoar.shao@gmail.c=
om
> [6] https://lore.kernel.org/r/CAG48ez3-7EnBVEjpdoW7z5K0hX41nLQN5Wb65Vg-=
1p8DdXRnjg@mail.gmail.com
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/filesystems/proc.rst |  5 ++-
>  fs/proc/array.c                    |  2 +-
>  include/linux/huge_mm.h            | 20 +++++++---
>  include/linux/mm_types.h           | 13 +++----
>  include/uapi/linux/prctl.h         | 10 +++++
>  kernel/sys.c                       | 59 ++++++++++++++++++++++++------=

>  mm/khugepaged.c                    |  2 +-
>  7 files changed, 82 insertions(+), 29 deletions(-)
>

The changes look good to me. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

