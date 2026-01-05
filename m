Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8119C2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 00:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBB46B0088; Sun,  4 Jan 2026 19:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493716B00B8; Sun,  4 Jan 2026 19:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395856B00B9; Sun,  4 Jan 2026 19:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26D2A6B0088
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 19:52:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AFAB161B08
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:52:40 +0000 (UTC)
X-FDA: 84296084880.16.34BC161
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA52F40005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:52:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iSgR5OnR;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767574358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRYss6ETw5xeuIsthNyONCWfDudQEzK9fmP3PsoZqmM=;
	b=n+uXRblUWibXdwHZwW/FfoMiomUmIQYPtuzsiwOixGkcKx6oU2RarCqKtwwaWuzXx4Tifq
	4AaCCb1lVrjZTVPb8I4/era2YoAjonTfQPipcJEUv00yHtmQgfIraDNwQNha4am3PHdF38
	M0QlwWeHPPfSLXaAiJwD3DdXStETfFI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iSgR5OnR;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767574358; a=rsa-sha256;
	cv=pass;
	b=3iqxXRINhyZzF73pUADNHx2GFxAdgMHlSMHJTVSTM8XWGj2JqXjFEOnkNSPSSGobzHa8E/
	oP91MBqSpTIMUySLPV7viui3ZE9G3+k9oGh/J7ulgumgU5PzBYFeMkQTKJ6WVc67UNQnET
	0kZCSGxaoyXdjoIh+Fk8zhf2SnaPTDs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q49IoE4d3Pxi//YcMYuOSVb3l2r6q9Cb8kmOmhZ1RSlwp79v8CzwGeH3A0DwvjwSlqgAc22ap0c8T0B302jzd9JJP/MLSP8CfJsHk3oIx7uVfQtPhNzS6AaF8fCSTERVgteDcco3q4u+5pI4Uzuf58XaGBZxx24E+BmOBkHUteiJgENK3Mz0YZnyfhLNK07R2a/J50lo9Rg4W9eDu23ETjKo3r6mMzC6MvS5XaQWoK5X27gdKWRA/wXFTCa34TdVoFgF/bGtmz5CaLk8ZbAl4eAu5o32ZBHRvlMI2VNuwzgUygrCqP7OszXY2ylgrdTJQxLCbBaWwlP13SyuWXcaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRYss6ETw5xeuIsthNyONCWfDudQEzK9fmP3PsoZqmM=;
 b=XU34j4iLNxQRvR5FHVrtDjiXc4n35yOGKV9Qow++qTu9vqd5V7iRaiTdudClQrUcIux4sTHDU7mEA6Yv8UGP7IKqblOcJ+mzDcftF33mlca1onpiKRvJusGoF/2AhjPAnwUHj7aovzVExnTULdMQvDgjqE7IkodZO5CbpfJBih4LYz8IVfNxy4I4wqa/buSW+ugrN70rrOAgQt6o2wMnq6WoSIPUJUesp/u6w6Cgyu1Jcr+jrMjqLlZxTp2S8y3Uto3kOFA7sVPADsEX15iIJeG1TRG4zFikt+beGsdaq/QpKdnZj5GBc1xo1e4MDF7jXH2vxUB87Nm9qmVZXpWfzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRYss6ETw5xeuIsthNyONCWfDudQEzK9fmP3PsoZqmM=;
 b=iSgR5OnR7/vhjxSFKG/9Vsze0gH6z0Co/bWq7eNEnvhTZwuim65fafPeIudTusPgNy/Hed94MAC1+JEhcsd/thxqIK+4yf/Bdbjq561AG4IikSIDjQO3X7sucLvv36zOo7PNlZ5Y/N/ASc+E0Vq/7w7HWcE2RR5lHyRsx1dXeoae1HzdKmGmntE1PxvKZvYLhjqySvolzmkcOYpvjjivLfadNaHsRf2Q7uC22Az4VtoDCK8K/3rJMw/nK2JRXZsTcZFV9or82JSESUiQyXcTeGiSyijCNknn2UHsMvE3Hc8WTJm448ugxNg5g3zFFaoJ/azKU/Ai/E56SCiGSfKM5w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH2PR12MB4294.namprd12.prod.outlook.com (2603:10b6:610:a9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Mon, 5 Jan 2026 00:52:30 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 00:52:30 +0000
Date: Mon, 5 Jan 2026 11:52:25 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com, 
	dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com, 
	mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org, 
	linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca, 
	Felix.Kuehling@amd.com
Subject: Re: [PATCH v1 2/8] mm/page_vma_mapped: Add flags to
 page_vma_mapped_walk::pfn to track device private pages
Message-ID: <j2lynjj5ilvv7ahrv4bmp5krl6u5ytknb2hxbs7ydjebd2xifd@tg2hj43wwbq3>
References: <20251231043154.42931-1-jniethe@nvidia.com>
 <20251231043154.42931-3-jniethe@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231043154.42931-3-jniethe@nvidia.com>
X-ClientProxiedBy: SY5PR01CA0022.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::14) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH2PR12MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e914503-3786-42d7-c35b-08de4bf4b3d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U+bFDLifly/yWr/oei34H1NACfeRAuxVdCc3PVUMB27ISQ30WCp5sGA+9jwM?=
 =?us-ascii?Q?kD/WL+n4mqqHqf/WVNODdqD2V8dQoti+vwYSzTtcY1GtVNp7FWRMdTqdyFKc?=
 =?us-ascii?Q?elQEdJ9NiAnRg0rK1VaC01FrpaaTua9FzuZrAx5UNjZ73A1ZcDlNMS5kocQG?=
 =?us-ascii?Q?yr76E7LtGxcJpg0Y4LLkHxAbo46JZYU7qjXnmG7UrhNgNwflJPs2jaBrBN5d?=
 =?us-ascii?Q?3gWXsi68nqlbW+ZR1Q8Ckp/oHid0yTqQ/f2sb4zLyPN5kut4jbsQpgq+y8UF?=
 =?us-ascii?Q?0pCLAeWNfOhHpYKxfl7vzFnIT5XCmo7WBhPFzYd7WaZvnf7xDMW4nUzV2bUp?=
 =?us-ascii?Q?Y1FqTHefr0xd/1TixSAy/Rk2pQ1+oYOVHPDEZZlJO0Ru7hwMWrjE7LDAz5vI?=
 =?us-ascii?Q?lXeaoM7e48wUpNKeiJf9bVPrUV3jUAoK7MvLLWN1hyWJzBG7Y1DzbLvapBSY?=
 =?us-ascii?Q?y5MmO6b6Mw77Lpa09sPMv/rCpt08eCRdtf2EW885ods4QJURhVnwCZTvvbwn?=
 =?us-ascii?Q?HCvL1dr87jUIvJYy8EtLKhVEy49sXcmLIBwVOAmibMCssAHMxq+JRK0hPPZG?=
 =?us-ascii?Q?GuzZM7S4UHRZ4loN6AcAEA6/SVfkybDmaEaBnqYbSGLq2NsSYPopmekfH1Fx?=
 =?us-ascii?Q?td4Nx83bHIhbgu1tuyE2eEPJm+jcq04vzLyLJJE1qYJWjjrUdLm7JQUbqSaG?=
 =?us-ascii?Q?HC9CV+u+JsTNJjPhXOR0S4R4gLuy5yHJS6uF67szMIFNNEhIHa5s7ALOnFcI?=
 =?us-ascii?Q?VcfwqRDAi1tJ4ZGODsGDabu0ZRoxtbqg1+J8GLkiJYT8rvA73YvqYxb4MgOb?=
 =?us-ascii?Q?Qi/EEa0P3h3EYb8zTmXXjq/f5thmHl/lq7amiI+cuTiNdohQvtB4I6NXYzwl?=
 =?us-ascii?Q?K39xDz+QKhQVk3vZ+jxr1UTW85KZV37cSj+3iRfaytkiD2hh588P7hvaEqPd?=
 =?us-ascii?Q?t2FVJ9xpdLrtyypPfrE0JfrPzQw6u0x1fAdhb9roykKJluGkg+ztdBFbfwxd?=
 =?us-ascii?Q?Grz61UYmpbEItLy5cXCKLkzZ48XcMFSWxk6/h2FpniuIHkg5vjRW26+822Cq?=
 =?us-ascii?Q?Rj70ZM1mGmOG3s6rMAus71zwo+KbGG3TTecdPslkBk8M3zI/oybW7vf4IOQT?=
 =?us-ascii?Q?T5g4duXj3b+YkDbGmahYctHtVetBeYBQCkO9/S9b1rQPgWsclyhpc7UEn2GD?=
 =?us-ascii?Q?y/CPbzVDN0sFpXUejmPt22rzO2VAxdRfYPYTZOYlh4SJufEIob01bGTYf+zn?=
 =?us-ascii?Q?/LmNvbi4hzQgdLaqBXgBpPjkPRkRDYVaFjwLfb1Z/mmyW/D7zRfGCOZ7LoeY?=
 =?us-ascii?Q?UQAGhiFkeB/In9W2ZVPh8uIR41zxBK+P3TlcUJT8eym8tcf4JtoVgRbZ/uQT?=
 =?us-ascii?Q?Va96k5qD1p5zbz4Z47IvDWvfJDx9oiu8S0yJZ33Jmv1Fo8zhxLgykw33zty5?=
 =?us-ascii?Q?cCr8KahBD3sxbW5iTv4BNwhD3REfFfr7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cl+lfNBwQibTvCpb+65tuQjiuDQCTZaGUxkXiuelOfw6Qqrp5PPVrmt0J4lQ?=
 =?us-ascii?Q?8oI10UGlZ/OYikT5ri/qMmz01sARXF8rPokGz1aNjUPSPxKoD+XvYplysPNC?=
 =?us-ascii?Q?DPJX5sp3gWm4WlB/C4lO1o2cBKXbIy9Bd+eBvuLMmQoQZsrMUvw41yXDM8cI?=
 =?us-ascii?Q?gixwhfL0EEx67LHcQSJS66V0yrLH7IsLW9CoJNpxRbMeladbEN1i9hrXB3cG?=
 =?us-ascii?Q?Z+aB5Ys4YH9rlFFfrgNITfukBiSdIt+kcWhqO3M14/CQPXldD/ymuhtzoraW?=
 =?us-ascii?Q?3zParmzI1O1/dvF8wyshmO3NQsfi2VfqUCHslHMwayP+eqwZhuKEKXaOUVj9?=
 =?us-ascii?Q?easRB9rfObLURFK6iz3qzv01vUDAZVUr3d+rNSaz11WMfZ6ohXR3Wj+tJ2+O?=
 =?us-ascii?Q?m8ZelVzr66CM349afIzSrA9ieecFU7vs3iK7ekFz+GKQugHaMKumZPyYQpy7?=
 =?us-ascii?Q?ncU+aFF4+vOnSc7B4yY/+a0QPLdWT9XahG6THc6e/hp7d/OUMmnk55pSaAgp?=
 =?us-ascii?Q?B3ZSCRYqgDYPWENcxfdpUxj8ZH/i7yPGI4DVT8kvrSMu9HoR79yS8BhMd0LF?=
 =?us-ascii?Q?BkcdDrV6qn7wD8lGcZJni/TUx133CeShBtcLsv7ro9jiV/k9gWEh2WsSYon+?=
 =?us-ascii?Q?KKZjBeDT/SFtTm205LPagQ8JesVXnae2NvRSO4/CxD6nRXE0lZWdndqUOsyf?=
 =?us-ascii?Q?urJdJztRBJAHADrnrcTTFk4AcyT8XbPL3MeLnQGbARWaLtupobOkgwpH9xev?=
 =?us-ascii?Q?cKK7vfZK7UDIuVAF9atf+i214AgGNsPbDyNchO3RRqhgWuSMVvYeOB7gm0Zj?=
 =?us-ascii?Q?6AYHdUE7lSqhbmgh/vAsOw6PLwU/k4aguGna7l2SCFI6H7Wue8Vz/IxniGWf?=
 =?us-ascii?Q?9cFzl1tGuQO9zlpHpkE8ZflQaNTt+yl0KmMUvIS2RJuGhnB0d9mWTJDDSBYe?=
 =?us-ascii?Q?Ure3sAAZgRTreW3BrcNRjzGxoC+0aVqHSu4xBMw/nIJFbqWfmBM0Mi4Hire1?=
 =?us-ascii?Q?3SDvvKKXV+2WkG5bzXmvuy5mMKbMHOjK7qGINvMRUqRTt5QbGfmC6YYK9uY3?=
 =?us-ascii?Q?SSmncVOG/ICqqT/ZLZdTZkFg3k/d9/ZC6bglnmRy99WSkgiKYERMUnqLWP4A?=
 =?us-ascii?Q?UI2a4kTMlT8f/Nwbxlys4CD7hHXsBS10R/gQFQBGvD3c29hJPbSBKLSFSKbi?=
 =?us-ascii?Q?VK9hHZZg8ha5lfs74npAu/dRz3XaWFP1WsyOHLk5DTxUtpp14ZbENWHjmb6i?=
 =?us-ascii?Q?lkcj0KSN+GGIi+/+XlyqvoUI28ZTTpaBBSNuKmc9KYr3csYx/kNNQomOJw+h?=
 =?us-ascii?Q?QIjN5slIIIwxkR09i37kS8QQn1bMIh3r8yWi047br/DFinrh2z4aWFKXs/qT?=
 =?us-ascii?Q?6nau0JsNh47uvq2IqygaHeJCGZntLYKAtdkfnlyuQFhNawmljXhfEbt1DSHF?=
 =?us-ascii?Q?f9ZGcBN/A3A8oIt1GlNHjJ9yw8HOMKBXrea3Iw2AW/6NS4tEYvMb7Bnkfw6f?=
 =?us-ascii?Q?NOgylxfjzl+t/8NwxXKULUz0tYauxR6YHWRzLXcFfGBddcOksaffBjL3E7WA?=
 =?us-ascii?Q?JOo1qiZo3/YplU0qBQhq8hi8+1n2ANlZLCwcmfUrA1chXw2z1E2XoHtpYvG/?=
 =?us-ascii?Q?54/LC35Yuvley+tMWedaZhQSfCjtDUkOjtJMDfD52TKtX2Tmr1R+nlvU+fn+?=
 =?us-ascii?Q?uxaQdOi5IS+2ULWLM/LzPxvk+VP9r42NMd/2iEgS8T9+NJmboB7cTfErc2NL?=
 =?us-ascii?Q?a0CH5aXXGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e914503-3786-42d7-c35b-08de4bf4b3d7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 00:52:29.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atI6h7Gpp5FVKjBLBG4dwh+eTsSq3EycgaAaMA/YnEweBOsoe+TLAetBoTeWoLaVfLT6M5EAeOphjI5skVQbVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4294
X-Stat-Signature: quzcm5o44jrhyoacg5mspa7r4k8hmwq5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA52F40005
X-HE-Tag: 1767574357-811039
X-HE-Meta: U2FsdGVkX19ZBQ/LQYuMf25pxnOBKH7wjlAy4zmLL+G7LDL8WWsFKqbbp6A7p8prBkpGc0aIEWfzNkCMLYuH4Y6BqUw0uXsl48oLwwwMOx7FenraQ3QBmUDn/frz+L0lUgzp4VyzgqZib04rY/Otm8j7ybFAQhnLvwL8spQZ85rtyjq2tXv4Ew+rjeBa91tobUrzvP1wdjLHEMBBkhYpS9bbED6W2yfByNUwQnvwAVJ0umFtRRcDLtuT/nEvrHaI3akFu+rH9SNhO6ZyuTbLbWwTXIn4knQDhJ5+56B+IS/0tRoTkLsPCRLOPuCa50nBr+Gc3i0IQ8VWjoppAA/Fw+b6YjahiZSXX0q1OWNBiU0xylBG40prwscxdz8inV1RF03Zg8d8Uck/ioz9hwI4uz952EG8cLo8tGdlljnrhzJ2+yV+eCXJRISO4nsEW2MNgk2y3NPY2IY7feRDWnbxGhoguT6fBLnkju89SuCNdCae6hzcrmizBSaFNu9vOE3TSo6WTTJPRhHDZuz21ypI2TdgH3Tl+n2SwVEMIAki4ttMUDu0J6iVcEqZwg6fAc83c7+tJxn9ggpT18QtETXdxjhGxR/bCN4D49hjEwc62Y1nbn4smvuJUB8aE5b2MrAYiGnUQeJi2uwVpi5c5r1H5F7YsN5c+WyiuIcs0hMQ8miKAmd1k4YTgvMdEbksH36GAcBye5DMjN1pLLDilfjz6Q7Fp//QkXFuAPCyQWp7X0HpXwl/DpqsLiXLrJ2LLNkGVuLsa0DRfR+e/j0KBVtny/e4MYUS+TD3bS0ceuiWT4fp93WL8RX2wCKAyVc8i29ASwBPmEmmIBjxcviTVsI+MwaLsa3EryLwVrQA+dZidmwu7IPJP/d9YUvc8nMZYwPhF4IZJ4b23ydaerog10JNs6B2Pa+BKYTbOY6ng1TDoFCIpvlOTVKVDFibsBOm0iNg02Z/uNJCENLFrcunotG
 ftRunjW8
 +8r6cZbEKBt8S1dFJ4ObreYQwyWyJszm7D1DiyQZh2sLp9dAekwjLXXdiXJJ39+MZhLuMif5fv9XKf/pjHZjOdNqTibUhCiuiJ1ohXHF1bXSHU+eX4w+SD+rLeIdW3VqLRxVW8WH8BHEM4Ena1e/2aCk5Ix5DbOu90Rro1mw765hP5DemoeWVcGQb7hWwsM9sEDnnzV2UqBE5XaGuW4BwqpvVo7bZsNtnFAumqkOmod+KJ1K/aVHPJnsusu2/2YeqBT3hcnHYuUswEE9nngXD0uDxPcEnVMxErLGreyUSNkhIYIEHde+Xo0ZtHH2pqB0y0LYPKNK0FFrcFyUw8cijYaDqEk4InR17OAKY7XK0WKrZXVrJCqkPKYKkJLwuWNYabufpJg0s6V85Y+YdCMLbOeGDR3Bj0gQeG/Qfr41cG36ByTUIsss5NkZe7So0PjFmwzmyhLrqvPaS/dBNfQxQMiHFgZ9PtVKaAF7T9ufjrtn43ulI7Kz7H3KnKb37ANtnOYFm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-31 at 15:31 +1100, Jordan Niethe <jniethe@nvidia.com> wrote...
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
> 
> Prepare for this by modifying page_vma_mapped_walk::pfn to contain flags
> as well as a PFN. Introduce a PVMW_PFN_DEVICE_PRIVATE flag to indicate
> that a page_vma_mapped_walk::pfn contains a PFN for a device private
> page.
> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
> v1:
>   - Update for HMM huge page support
> ---
>  include/linux/rmap.h | 30 +++++++++++++++++++++++++++++-
>  mm/page_vma_mapped.c | 18 ++++++++++--------
>  mm/rmap.c            |  4 ++--
>  mm/vmscan.c          |  2 +-
>  4 files changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..57c63b6a8f65 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -939,9 +939,37 @@ struct page_vma_mapped_walk {
>  	unsigned int flags;
>  };
>  
> +/* pfn is a device private offset */
> +#define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
> +#define PVMW_PFN_SHIFT		1
> +
> +static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
> +{
> +	return (pfn << PVMW_PFN_SHIFT);
> +}
> +
> +static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
> +{
> +	if (folio_is_device_private(folio))
> +		return page_vma_walk_pfn(folio_pfn(folio)) |
> +		       PVMW_PFN_DEVICE_PRIVATE;
> +
> +	return page_vma_walk_pfn(folio_pfn(folio));
> +}
> +
> +static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvmw_pfn)
> +{
> +	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
> +}
> +
> +static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long pvmw_pfn)
> +{
> +	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
> +}
> +
>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>  	struct page_vma_mapped_walk name = {				\
> -		.pfn = folio_pfn(_folio),				\
> +		.pfn = folio_page_vma_walk_pfn(_folio),			\
>  		.nr_pages = folio_nr_pages(_folio),			\
>  		.pgoff = folio_pgoff(_folio),				\
>  		.vma = _vma,						\
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971..7fddafed3ebb 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -129,19 +129,19 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>  		pfn = softleaf_to_pfn(entry);
>  	}
>  
> -	if ((pfn + pte_nr - 1) < pvmw->pfn)
> +	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>  		return false;
> -	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
> +	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1))
>  		return false;
>  	return true;
>  }
>  
>  /* Returns true if the two ranges overlap.  Careful to not overflow. */
> -static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> +static bool check_pmd(unsigned long pfn, bool device_private, struct page_vma_mapped_walk *pvmw)

The device_private parameter isn't actually used until patch 8. Looks like you
should just move the usage here.

>  {
> -	if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
> +	if ((pfn + HPAGE_PMD_NR - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>  		return false;
> -	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
> +	if (pfn > (pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)
>  		return false;
>  	return true;
>  }
> @@ -254,14 +254,16 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				entry = softleaf_from_pmd(pmde);
>  
>  				if (!softleaf_is_migration(entry) ||
> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> +				    !check_pmd(softleaf_to_pfn(entry),
> +					       softleaf_is_device_private(entry),
> +					       pvmw))
>  					return not_found(pvmw);
>  				return true;
>  			}
>  			if (likely(pmd_trans_huge(pmde))) {
>  				if (pvmw->flags & PVMW_MIGRATION)
>  					return not_found(pvmw);
> -				if (!check_pmd(pmd_pfn(pmde), pvmw))
> +				if (!check_pmd(pmd_pfn(pmde), false, pvmw))
>  					return not_found(pvmw);
>  				return true;
>  			}
> @@ -350,7 +352,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
>  {
>  	const struct folio *folio = page_folio(page);
>  	struct page_vma_mapped_walk pvmw = {
> -		.pfn = page_to_pfn(page),
> +		.pfn = folio_page_vma_walk_pfn(folio),
>  		.nr_pages = 1,
>  		.vma = vma,
>  		.flags = PVMW_SYNC,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f955f02d570e..79a2478b4aa9 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1112,7 +1112,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
>  {
>  	struct wrprotect_file_state *state = (struct wrprotect_file_state *)arg;
>  	struct page_vma_mapped_walk pvmw = {
> -		.pfn		= state->pfn,
> +		.pfn		= page_vma_walk_pfn(state->pfn),
>  		.nr_pages	= state->nr_pages,
>  		.pgoff		= state->pgoff,
>  		.vma		= vma,
> @@ -1190,7 +1190,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  		      struct vm_area_struct *vma)
>  {
>  	struct page_vma_mapped_walk pvmw = {
> -		.pfn		= pfn,
> +		.pfn		= page_vma_walk_pfn(pfn),
>  		.nr_pages	= nr_pages,
>  		.pgoff		= pgoff,
>  		.vma		= vma,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..be5682d345b5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4203,7 +4203,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  	pte_t *pte = pvmw->pte;
>  	unsigned long addr = pvmw->address;
>  	struct vm_area_struct *vma = pvmw->vma;
> -	struct folio *folio = pfn_folio(pvmw->pfn);
> +	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw->pfn);
>  	struct mem_cgroup *memcg = folio_memcg(folio);
>  	struct pglist_data *pgdat = folio_pgdat(folio);
>  	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -- 
> 2.34.1
> 

