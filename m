Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59EBCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26696B0026; Fri, 22 Aug 2025 01:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8036B0027; Fri, 22 Aug 2025 01:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F276B0028; Fri, 22 Aug 2025 01:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C410E6B0026
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:02:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BDB6C05E4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:02:49 +0000 (UTC)
X-FDA: 83803198458.02.1739281
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
	by imf22.hostedemail.com (Postfix) with ESMTP id 780F1C0002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:02:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Hhy3ifP0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of apopple@nvidia.com designates 40.107.100.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755838966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEcdB1aVVvTomPh+a1ct1ukbyaY9UTsXivqR6/oWpOA=;
	b=rXGoSMlZRmnwjVBpD82XqcijMnYxk6sPAiXJ384fDhucFjpnbnZDC8u0lPK8Z2cn9l0Qnn
	ddV/2B0sHNrbCFwqQcSayzOBk1JIf50W7QdOT8VgYAtbxLMYG5ZQzyHS139GYGpbLzmGvx
	Hm3DQ988Mf0h6xBa67yzIgEQ1ZCX77M=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Hhy3ifP0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of apopple@nvidia.com designates 40.107.100.87 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755838966; a=rsa-sha256;
	cv=fail;
	b=v0Lc7soayXGN3UxPPAB+oGuD3Oilpzlphp4KpXOCVryS4a8D6vKm5uyXoHfkBVDJK97X5w
	zW8ZaFpYmabN4ois4pZJaPQgdA3kCD1z3MnMIhnGTGsUx2BCyoK5anYGbU6E2Rrb7mkw/h
	kbNShBni/HFDv3tZymispo3OtDo24uk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8SSp6UaWAiAor8Q+w3WOM2uMrlRxkDm63eh6x/Cck0ddypU7bqlHWrzJnXkGdg3+8+fLEPfJAMiqFHY1td5VrM9hx0AIpfcIkGTggwX3Y7oMx/iIlRq7OqZ5A6VNOADDX670xf6lEGUyf9yi+Wl3MM6WBNomV02oewZF4AcEBXivC9gwTTbuGdOHvd6qif0yUdjQS0YDiY+fSKWsllU1TVBmcY7UP1KICr7074X9htszT5mOlXbUZAQIOLJzRjEkf7yfvA5HLy+JbS83JNn4A+r5ecOYBKYgzcix0kRHgsa5XN/SjMpjorz8VBXVBMM3SBg+D0tr7QFEQmrcWedXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceqpTrbNcOJ6+s5ZxTCQxzpL3aLpbqkomF8N6JlGOSo=;
 b=lzAv6jhBhU3D5rF2prkDjPVWxMd6uujze27j1cpTCy1o1ICPmpf4fanXYGEgtjeiLmWko7ZQD1ShnyESdor6FPhw++tnH2D15xE4XIAUcfdaqlWrjYI0ul0EASPFiOqi8X6TNtglZyeGdfgwYQD/JK7e9gZ6eB47gFmoEdx5Q6WKZhyXtbQTBQPMywl+J52HEEC+df2v6g3fO1PR40Es31WKmfniAqJHCs8er+12td6tktqwjKyjLK6QA48A8JZF5EP8/RylzBOiGVCVj0lE/MyvkwMZfcpZha1EG+LXaKWuHDJ4+cCvkbnUIcM7ATXHxruM0x4e7dl4OLU3sKLzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceqpTrbNcOJ6+s5ZxTCQxzpL3aLpbqkomF8N6JlGOSo=;
 b=Hhy3ifP0uiL1bH3wQJsIy59kC0eVOXmVF4Z+Rs4kuoZNvBrO6EAL8acrY3DwEDtK++QFdu1IjC6Vbc3t6BRvavM4ttJSHXwQHu97Yn7oe4keaf0T1KlulKHc4aTSPoemCnHB5C/p6CHdUPdFjlN+vQXnstQQQCyTel+sl2HHHYD4KorzxBiauo+GwXtyYp/Fnvar2GfEBfbq4oQ6u7rDRNlbUqmhbNGa9t9TtoMT0FOmNadKWZeYu/rV0yDrswUR+rUW6yWW/dyiLw27HuKFvlindPiZOGWQj9Y+TeXQT9j6Yfq1hlPiZT2hnpLMA6guUA7Mqotzfrt+YTW/jo0XQQ==
Received: from CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 22 Aug
 2025 05:02:41 +0000
Received: from CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6]) by CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6%7]) with mapi id 15.20.9009.017; Fri, 22 Aug 2025
 05:02:41 +0000
Date: Fri, 22 Aug 2025 15:02:36 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [RFC PATCH 2/4] mm: unified fault and migrate device page paths
Message-ID: <gdkzd45iweec7cnjxzyfmbbnvk5m3w6cv4gsh7mo4gn4hlz5l7@ihtpp5hiifu2>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-4-mpenttil@redhat.com>
 <099ffad3-489b-4325-b5dc-90fa002132f7@nvidia.com>
 <953cb2f5-a27f-4eac-b2b8-ee67e35bd1e4@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <953cb2f5-a27f-4eac-b2b8-ee67e35bd1e4@redhat.com>
X-ClientProxiedBy: SY6PR01CA0089.ausprd01.prod.outlook.com
 (2603:10c6:10:110::22) To CY8PR12MB7705.namprd12.prod.outlook.com
 (2603:10b6:930:84::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7705:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a93951a-de82-4e41-4df3-08dde1391f3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?WEEZIsSjbzYdzgRvgEM0GuZ9Xe3JFrvIH4YV4Kc4h8be/joiVhEJxjaSIj?=
 =?iso-8859-1?Q?eANgPr4G7gzmzZzrLNvMAkihFuB3FWoZ5w6o7jYIdFgJgK9b93dPRLlJzZ?=
 =?iso-8859-1?Q?gRqx63JcAtPV7qc+QEd2jqA14eTRP6A2aXlmphpUt12g/UFU1VIZt10F9G?=
 =?iso-8859-1?Q?OspN2gNI0Q3jL6nCOx64cupPvqy0pkqUcWdl+BPEZZ176/1AT7dIeg/iCD?=
 =?iso-8859-1?Q?iMvIX2JBkYUTPpwKomhkFDUsgCv1w3KMadCpmragiZjUth8zfVICFAZUk6?=
 =?iso-8859-1?Q?t899WOjllXQYIVsy6lbQgb8uPWAulTYDCR5PrfJSyyOyFoAQSSWpNJed02?=
 =?iso-8859-1?Q?OxF8+3qrgwSCAAOYU/A2VrlmMgvL5XMABi8Bw+tLLYZef36CV+6X+cOpQs?=
 =?iso-8859-1?Q?uYKZBd3YOKUTP4fGOoMB+FDygPhvDs3uNTNB+BfIv9FPW8fPJ4GG6gvM58?=
 =?iso-8859-1?Q?SCW9GPPTevptBrweqPN7BC7V4pceGEEvOgnP+Oyd36xl480oKosjZrHPsW?=
 =?iso-8859-1?Q?2JgwHK/XeTS38+ZYdhP/Dh2VuiSy6eCu3H7FmY22s/ndYlzLWTvTkwj+tT?=
 =?iso-8859-1?Q?ybuRmXNMl1U9J+iDEVqU3OcJqWNd7tB69Atr2YlnJKde571q1IQpV7cUSx?=
 =?iso-8859-1?Q?MsoLNBJiS8o3Ph3VhxIbdU5yJSMqRuIQsluo/7UQ+S713zGJpLQEQP1juk?=
 =?iso-8859-1?Q?tTgB68z3K8zdKrPynadCMlYH5z9b/0MtFuzM2zcutHZT0ZHs+peu3rXyDb?=
 =?iso-8859-1?Q?EHneq2NDxq7UKO2nt7Y0Z4xhAI9KjpnPJWvqUjXwS4afUM1Y61JEYnrwg7?=
 =?iso-8859-1?Q?5JfYvJM1orupxtNY8ydA1rF5dUFOpg5rodgvk+gNJ90ZAiDmAZaR2U//q6?=
 =?iso-8859-1?Q?mq5c9X/ZzLwEjGaT/bwWhep2srwxmIn+mnI5o/bWedP/63Oyox1Z8DJ1fG?=
 =?iso-8859-1?Q?8kJ6qENAbnXCbsq3xYKuciaoA6ZjUSVhFwGQ3CdFQhdtMUPFG1879tlosk?=
 =?iso-8859-1?Q?gX/qP3V2Kxzy8ju0iLRZh9U8km0rPeKABHAQ4ntR4r+wd2L5PNwP2waEGk?=
 =?iso-8859-1?Q?PYWbbz4mXdN4XMzfjrPaW9cPKphj+gX2jo0/KmI1rhK2wsLf5Y1lg/wvlM?=
 =?iso-8859-1?Q?0xplyD6L71q9pPmit4Jgvhp6BKou8gmx6zH/itrSM19UyGKedn1AhIWDUg?=
 =?iso-8859-1?Q?pL4CwhZkM5bOrnTIUMwJmt6dLC5iRNsE2fDzMQ9QmWKgiH/7SDBv5EqlzD?=
 =?iso-8859-1?Q?GOzRrfXnSXlYLe1spfq2HnWNJ+RLr7oGxcuF4N2Y6yJMgvw4xIdJUvBQGv?=
 =?iso-8859-1?Q?njmLpduI9M8Iaq/phgR5B1/kOhfeROgv0S4Q6vyekcYCVD5FnNDvCX2RMq?=
 =?iso-8859-1?Q?nZaaUTbSULb3V1J1jkoQ1agOARXMphZF0TbHWawrr6Qv7gUSvuWpk9gc0W?=
 =?iso-8859-1?Q?xzZn41Az1SSND0yeiMYE7nxIu5GE5hno1syTww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7705.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?y1Pjnfq5Akq6mqT/9q/OwOVRx40kK2HvsFdycIXlCCDmtmb+ZXmVmax5Rl?=
 =?iso-8859-1?Q?l7gDuDX76Bc4LaPRHAPDG9+likk8bLIVl1rv7/4WM5M8ZWLtzBOqE0AwRw?=
 =?iso-8859-1?Q?l2YBT5jDPawjdHQWgjnl8PuDs7XIAGZ3SNX31AmLD6Gw0IOiRStMERl8q0?=
 =?iso-8859-1?Q?KfPL5HHEz5KQgHn9nPKjZu/GTu14fFqZfIK+YUViwxOsJx51cOnX/oZgGP?=
 =?iso-8859-1?Q?7RW+K8UONkxvRzfr/4l/X7OOTluFLknkFdycVQuwAsMOL/EHVR/lFa/3+v?=
 =?iso-8859-1?Q?968QV29F1aLgZzuz+yf6o/mX1LdYiTF/xeymQQS4UUqtOa23LHteedIYqC?=
 =?iso-8859-1?Q?YPmJXZIqSSSW2wTltENQGo0thd7/yY1G3gSdU+jl7p1gYGLWl4QTqP/xw6?=
 =?iso-8859-1?Q?4QuslL0osd59GzsP6eKeMbfT/IBNcKgHfjxmI7RuyX6tXH6+fDdqMR3YNk?=
 =?iso-8859-1?Q?yVWLwWjqKmMk8XyR4OO1Y6UE05o12/y9deqKDJz+Z+qjo50QdkMcQ6Ou7K?=
 =?iso-8859-1?Q?KfFD79d2vCtKHPXAE8xe0B9KJ1mGSjJnztFqZDZAiaTt7CdTNsNFdtTy6f?=
 =?iso-8859-1?Q?CPXgoOMAbeuHwrkjM661MNBpIKxv8kgtdyQxX5zaYkWvmj+ugTDL8Hgd3B?=
 =?iso-8859-1?Q?yFK0Mu5zsfceltWog1oQMq43kWLPfcP4i3zzoo8cnQZTQ4R3us8qaLgNJk?=
 =?iso-8859-1?Q?KPiY5q9sUGyn8XE4/zT+SjjrLQRr4tN7eCuAQGbO2yyLmsTwOWVZwKb/5n?=
 =?iso-8859-1?Q?LVVNib+is2+KlEHj7BGtk2e3M7aWN6Wfg1rSLuEytUgQ79GiPC108xf/tP?=
 =?iso-8859-1?Q?Vr1IsW6bJk+XMNigCZpI1I+LRcbr3cP1PlS8w6X+ESw0fY4dUgUOnTH8Az?=
 =?iso-8859-1?Q?e0i0iE3TKcxxm1T3uZ8Cwu40vaaf3CBsf0q8OyxDH+sKjN7xa6GKzJVuwj?=
 =?iso-8859-1?Q?sDSSp8zFNVqOrJvny87IvbLdqfZqm1kG8dKt6nNFhA1AumCCU7QREP+exf?=
 =?iso-8859-1?Q?0SDsLMOuP78mgHdPK7nLZASSiI41K5xI0/MzwfcuocpVEI1u6/aKO3+3TZ?=
 =?iso-8859-1?Q?w+i2HI8hhwv2yIMkg15lj098Riz2+2iODRNiL3OoVXnzQ6gF6KtLr0WPbj?=
 =?iso-8859-1?Q?LC4p8cTb0jEf4RN+ncPL53KzxCEA8n+W4pApHada/Jk/Lta2qCFycMgduX?=
 =?iso-8859-1?Q?FEQMNIENgbr9W8bkqQdAkUr5yNDWlB7DjKCpbp5BrPOUuH7ENvbrsU80Zk?=
 =?iso-8859-1?Q?yfsjDkTF1KY1ZRMKporDuqz24GDKn3TKaUgVwhKroF1zN91C4At5/Y6CcB?=
 =?iso-8859-1?Q?loRLy+czT6u+DvuNstlRTX28PQD6SCFhMRv/HWf4OSZkQ44KHjdLWTF9Y+?=
 =?iso-8859-1?Q?MJ2uvbOPqUu0EEMvfahKY14Aurc6hgTSHwApkVKJaK8++diUKQ6VcRdGOb?=
 =?iso-8859-1?Q?QYXp9yg+zg+1fertpInk6yl3rBXtCI9sFmdq9H2duv4Zo6i6sPGzTxXvSU?=
 =?iso-8859-1?Q?wOF4xl1rFAgb7oLAO7Ow1Sag0HBmR6kXsggO98SAf0NIg1QgN/NWlt21tz?=
 =?iso-8859-1?Q?yQjakUEHJ/q5jydMfy9ZdCrxvRoX9db5dLm1IaPL4Uhrbff0e3i9AwZbGI?=
 =?iso-8859-1?Q?/mxXRKPooefdUVnUm2wrrEQ8vfT5LSzyuM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a93951a-de82-4e41-4df3-08dde1391f3c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7705.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 05:02:41.2728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ei0TD4CQM8Bc99ahXuzoF8sINkkAEnIG9IiWEslOuFTfAtySRkipM+K0f8atwDBxgu9t/w1YchAqYRYiF51Dig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 780F1C0002
X-Stat-Signature: k8ehi5br6d96fhd3scbxojfd3xwgjgfm
X-Rspam-User: 
X-HE-Tag: 1755838966-286465
X-HE-Meta: U2FsdGVkX1/k84kM2/+6Zh/jI9UHLUCB/fzD9Jltah8qiC346Imm0JVUc7trNW9Ej9jtYYxKYv1kgrbiue8xuLkjWV0sadcsLe/38EMacZSmD1QcGr0VRZ5QgKM8Y4fZS7yQXk9/dPfticSzniyK3Rf2qsm4Wp4Vs2g7qhdA4okSnt+uZw/8C+Dko4OdiI/ZGH+SXenWIQM2UYV32674reIpG9vGBi4Y7LGJZv1xPPOQj/+tGa6AnrIuxBdaovbdVx8JDNPe6AjIC9RmVuPM1vOmeD1jXXrHstXgs/lw3L/JmG4fiOWfRkvLNKtYzM5ngdDUhb7pYtPmdwUmmQMcN0CWma0/XXVS2kw9SKHGI3jN3Ngom2h+sWiCotgthxkVoWCcVChjpjWbUaGaug6NccHn7Q8SIOHqacfnE7bVzMPV/1jy+3+LRFhnI1R3jwC8gRGva2XR66dNXS5RC0eK98fxzR0omgXCOgcj/hOIsa1DecNDaPSpyglKZjmCoCF72oyPaIcRx97MTqI7YpBG7hRm3S7V/GfeC3DD8y1BHM86A/F1jORjAHfOnJR9VwSIoRveMZ0m7q7PYsSE/4r1yvDMKSBn8/XvlSW7HtS6NSJmVHsZqf8jVChHzcB4NbRYxfWnQ+PbEv5z6D4vm6Z6jnr0FOnzifsiq6hnyVFdMQeuBGjfn3hR81kUd1NoPcR4hX5CmROm4lewr8sFhrq+Y/V69B0UahnUIXKxA7VOoghK0bh9UZrqO7FP7UavwdGk70LfONpOCVZPteC0OxMC1oup8S+mNWg6p1HuFMTa7Z98g9qqUvf81y+g0mMsF67g3Qt4b48SBbSbkhfr9J0c4Vb0cOuqpExb81ZzPj4FEsl0qQBXZjyPZ4S98C+mYh/pWH8QEPZGeAmEAFGRVxENazXsKziiF3lTxWubwY6XG/Nvhqs0s8m27+DdrA9gHdEqwWiA1Pf6Y/VKwL11ptg
 LZBKWrbZ
 Hh4hklU7VE7X+yF09OibVKk0FX2hXOLyUlyzd4oUdKmMCtnUXgM/0GqfnV+5MY61QGL7ztZ2ghd12VOcR1ElC9zFVD6zg4Y8nAdzbIfUe325UwpKplg3lPmszWzweNNlepRfXP5or6uvXmwIBNxXFmBuNkr/WIBFhu31mp0Dn5xHE/j0Khlyl8tnGEy5xAlW0BGeVFEBqAE/wGuMwh1ILsrDQO8eZz9QzuLHVIN5cJleggz0VX6JQAj3YenFmMq8USsmLAI+0WehrAa8/Wz/LmTuoCRAlUnjz0nit3Vn+evn6UeAmBkPr3v2vNW3ylOIkzVvSzEytzEGlSzy/TBlb20Q/u5tr6/4AgxQNJ5pjO/0tgPTlAUsYFs3D3QpRadL48TCVHo1M+GTraI4U1lWRmHtrnl6QnqVwVc3w+oYu9Tr3/Bp7bjqVBoXCu9SVWKLvylZxhdY0MXJtb/91wmJi8zFauaYZ1d0Z0WA+R8ivfzrmBc5RJweEryrr4srcTBoziq8PQpdbLa2lwUrpqjZZ27qFo8WT0F64qfB7JK3kyU7SpeybpwBnvKQG1PI/zDOSdb4DfTmCUeNvMNZMr3s0P/0U3Qh/fYB1FPt0pQHpukVIi8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 08:10:31AM +0300, Mika Penttilä wrote:
> 
> On 8/21/25 07:30, Balbir Singh wrote:
> 
> > On 8/14/25 17:19, Mika Penttilä wrote:

[...]

> >>  EXPORT_SYMBOL(hmm_range_fault);
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index e05e14d6eacd..87ddc0353165 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -535,7 +535,18 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
> >>   */
> >>  int migrate_vma_setup(struct migrate_vma *args)
> >>  {
> >> +	int ret;
> >>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> >> +	struct hmm_range range = {
> >> +		.notifier = NULL,
> >> +		.start = args->start,
> >> +		.end = args->end,
> >> +		.migrate = args,
> >> +		.hmm_pfns = args->src,
> >> +		.default_flags = HMM_PFN_REQ_MIGRATE,
> >> +		.dev_private_owner = args->pgmap_owner,
> >> +		.migrate = args
> >> +	};
> >>  
> >>  	args->start &= PAGE_MASK;
> >>  	args->end &= PAGE_MASK;
> >> @@ -560,17 +571,19 @@ int migrate_vma_setup(struct migrate_vma *args)
> >>  	args->cpages = 0;
> >>  	args->npages = 0;
> >>  
> >> -	migrate_vma_collect(args);
> >> +	if (args->flags & MIGRATE_VMA_FAULT)
> >> +		range.default_flags |= HMM_PFN_REQ_FAULT;
> >>  
> >> -	if (args->cpages)
> >> -		migrate_vma_unmap(args);
> >> +	ret = hmm_range_fault(&range);
> >> +
> >> +	migrate_hmm_range_setup(&range);
> >>  
> >>  	/*
> >>  	 * At this point pages are locked and unmapped, and thus they have
> >>  	 * stable content and can safely be copied to destination memory that
> >>  	 * is allocated by the drivers.
> >>  	 */
> >> -	return 0;
> >> +	return ret;
> >>  
> >>  }
> >>  EXPORT_SYMBOL(migrate_vma_setup);
> >> @@ -1014,3 +1027,54 @@ int migrate_device_coherent_folio(struct folio *folio)
> >>  		return 0;
> >>  	return -EBUSY;
> >>  }
> >> +
> >> +void migrate_hmm_range_setup(struct hmm_range *range)
> >> +{
> >> +
> >> +	struct migrate_vma *migrate = range->migrate;
> >> +
> >> +	if (!migrate)
> >> +		return;
> >> +
> >> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> >> +	migrate->cpages = 0;
> >> +
> >> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> >> +
> >> +		unsigned long pfn = range->hmm_pfns[i];
> >> +
> >> +		/*
> >> +		 *
> >> +		 *  Don't do migration if valid and migrate flags are not both set.
> >> +		 *
> >> +		 */
> >> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> >> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> >> +			migrate->src[i] = 0;
> >> +			migrate->dst[i] = 0;
> >> +			continue;
> >> +		}
> >> +
> >> +		migrate->cpages++;
> >> +
> >> +		/*
> >> +		 *
> >> +		 * The zero page is encoded in a special way, valid and migrate is
> >> +		 * set, and pfn part is zero. Encode specially for migrate also.
> >> +		 *
> >> +		 */
> >> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> >> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> >> +			continue;
> >> +		}
> >> +
> >> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> >> +			| MIGRATE_PFN_MIGRATE;
> >> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> >> +	}
> >> +
> >> +	if (migrate->cpages)
> >> +		migrate_vma_unmap(migrate);
> >> +
> >> +}
> >> +EXPORT_SYMBOL(migrate_hmm_range_setup);
> >
> > I've not had a chance to test the code, do you have any numbers with the changes
> > to show the advantages of doing both fault and migrate together?
> 
> Not yet, but plan to have some numbers later. 

I don't have any recent numbers, but I profiled this a while ago and having to
walk the page tables multiple times was a significant overhead in our driver
at least.

> >
> > Balbir
> >
> Thanks,
> --Mika
> 

