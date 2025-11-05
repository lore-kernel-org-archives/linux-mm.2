Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7106CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B938E0010; Wed,  5 Nov 2025 11:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523068E0005; Wed,  5 Nov 2025 11:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA628E0010; Wed,  5 Nov 2025 11:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2956A8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:28:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E572113A941
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:28:28 +0000 (UTC)
X-FDA: 84077086296.22.FC33D69
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 049634000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:28:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E29PUQaC;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePXrH2MpArve6erkgTKyzdPXJ1+xoTXBoBEE23E9vJw=;
	b=uCGqrBFm1z0KRE5KVCTVaLjlx8nh0U+yfSBzVu6QOwLgQ6WMHa3IqEHvr0s3YZZ4Uqlou8
	5F9agb2GAkM7mgrU9+f5YFsBDcPBnCmNP8qtvLORBwvoA56UmbLHYTPq0lTar/QH6EMHx9
	gxTAWc9UuJ6oGV5XKTaD5w5pq6zFyQM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E29PUQaC;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762360106; a=rsa-sha256;
	cv=pass;
	b=l7jk/LQZuOtGds6sNAWKFKHZ7ME34MvVAx3lB34JAu7aGLZNlm3u/OjSZsZFNEUA+TeeXC
	hcTlWeF3cxEoA02OPS/JJ8EeraoiTCcV2BVy3e2cs261gUZNNWuOOOboO5iAIz1gg7qNvT
	lV83XGt+YDIkcRJuwLfm4NiCm79MTEg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Alt9YqB5MU9wof9Qt0JCKr0co/2Mtpv2XG6h6rjHZsn+y9TV8CQN3tlYYkG8HVUwWJ7ZlSl5ur/KMhlfcMGzL1gL69Ym7YumjF1itfQD8wug9Y06XoiDG0kVSURipzzRP4xq9Tma3a6XJ4a9uowCOp6OGB33mbQnnCSNkLst+wtwN4mHsLYyDwmj1baujP+eoPVZoFhhqaYBtVvOINOO3Wgxp9fHiFvgnV5sNP0T6QcHCUDry1KYMrjHsdoPbTMf6D7ztptB6NH+DMwQW1c2YyB0K7Izu0qg0OK9w7rNnNuXiowjjENiVxFMDdPeZdOsl7u4mQijrvOISkp2ZfLRsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePXrH2MpArve6erkgTKyzdPXJ1+xoTXBoBEE23E9vJw=;
 b=b56UfSt2dCl8EYIqgIpzaJv21AaafhZv/kx7rU0WxzN4G+VHDbE6/y9yoeKhegbvsGVNDoWf64OMSoNmjhLHYCX8X825Bq9hswVk5+rCO/+mZ9Ks5g0MIA/UHTk9UFI1tORVu1NaKW0zniWpi2nPSt/eTcz+FWJOLn2Av2eVVl8WHLVE+Cq35zEyUSTIN5iMuXcWPsEyhBZLEdIO7HilHrVd2dhtJugQQRQMcYKk8JQmOi8Acn/VI88hp/jSeCLA/wJVwg5OYRerRPVJ+sKFzrGyvWrPapQPxz2cfdYw1C7sRRY80cZtxM1WqdZsANsT7Whofl62EG0Eg9en/tbWqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePXrH2MpArve6erkgTKyzdPXJ1+xoTXBoBEE23E9vJw=;
 b=E29PUQaCWPCLzJWkI2+vONdyJJuILv9/aRFPlHFwDuKBG9QaL2WClDSiQqzM59qv8s9CxplEcAkvzcjC/oVl5wq7odFY21mI4nZ5ZLTfdFwF0zkldu4+RUEt5dsYXgVJNHukMJFBzNrR2PaoPgTZGRWELLMYoGnKN0i77Ixy4498VSlcTX5JRvCGusGKe4KE+JSgEy3oy8oP+tsfaJ+1WLEwsb8jEEzxno74hG2G4MI//61yVYepPwDjk2Ix1kya19rveGoPXZs6qcXzMoF08ila1xaavL9XlvPC8pSVwgZQFuXi61VDIXPbHIAhCXgtAjm1AZKZNj1y49ZIlPCb2g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 16:28:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 16:28:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Wed, 05 Nov 2025 11:28:18 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <3200719C-7460-4830-9C61-4337D417F425@nvidia.com>
In-Reply-To: <dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org>
References: <20251105072521.1505-1-richard.weiyang@gmail.com>
 <dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 49136f20-526c-4e58-b9c5-08de1c8855e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MTnimjJIghIdPz2eu05YueNPymCUZdN90w/E6Kms+/5V3+tAeKpYmDBmnWXf?=
 =?us-ascii?Q?arHgcdxIdO8PmWYHBJ9LzLNXv3PfX3c3NLT8Bv9nfHglueWfmfN/5wITuGKC?=
 =?us-ascii?Q?wq5DNtRgwC6Ahcb+X1/6pNV3EzT7Zji4hXnnCDxG5Run1Qr7wLdwEjTlA0Eb?=
 =?us-ascii?Q?iPEy7A4c02NbNPBgQMJJHtV7LUehzwd7Md3X98ZRjH/vWTBtQGpmuotQtrN6?=
 =?us-ascii?Q?R+cf7squFsmk0sAs+MA+dw7hrkHP1tlQ5QR/GGikMOAM3VOJ9DmHbqaiF/kQ?=
 =?us-ascii?Q?4f0mOTEXVRacRQs5V7awzvVzayMIUAnhotBEXjxCeA/nnQzcgGkA7UckjMok?=
 =?us-ascii?Q?+K/9vbk5055sU53gPfOlN57fsmi2n5W1VxNXtq5gD1eWUmuVEB2SHxDwCHmR?=
 =?us-ascii?Q?Hv77nN26JKg4oMvp7YgbwzCdlYc672k5ot1qXA5y6834Hwpoye5sn8OrM/SK?=
 =?us-ascii?Q?S6W6Xc0UfuguVtCP2SQpCV6UxKApKmGTlcfwmX7F0EMT5DpKNAPr9AerYQeV?=
 =?us-ascii?Q?RnM0iGFMgec9MqG/yNy5vxbiQXyJ5t2FaeLh7KS1/Fn2lF5oE8VXlyy9retC?=
 =?us-ascii?Q?lygfbSI23mmSqpTezShZVWFqCBvn4j8CnRHpkCbUve7O4MAi+q626gPXDrRN?=
 =?us-ascii?Q?/LwG7Xx7u2K4WVH/NjafOZFQKPdocjw5VvulqOy2Ib3bnq7kM7t5SJkQV0L1?=
 =?us-ascii?Q?0c3GsgbtqO6UFx4NdRmhyapqdb4oPRSltP2SjA7kXQlwPBz1w/wzZj0S81Wc?=
 =?us-ascii?Q?AvjRvydAjeqzwW0901HYu4dSpL4Loa2yZqbF1F18G0i45FcuJWYprzxuA8YB?=
 =?us-ascii?Q?nzWmrTjwki+cE4gXY4zGWLk9Z9DTp/o2Aif1hFxO5EwX45frsTN5QgX0LfF8?=
 =?us-ascii?Q?/QxNLk33iEllccQO5JnWCyUESeKSUG8unWv++N7Yb6EjbCenAbkqArQMsFf3?=
 =?us-ascii?Q?2C6I3z7HeqZV3302bZbmXwrcVaSj3RvZ1h41I+yFMS7nPpG4Cu7RGKp2JWjZ?=
 =?us-ascii?Q?6MxyRrkLYTRX+GyVlY+WchLP9m3ABcE7hwZ1NN8Rln6xcO+zkskUKRexBqzj?=
 =?us-ascii?Q?UXuRzHLI1uufzX1tQ91PzXRqW8jLAxD2I/ofI9dECAcR89HB5YJrkv3WkJj9?=
 =?us-ascii?Q?DEAWyeac9hVBAtG8A7zi7k3L4N52UnyIQxlcHkVoV2BdE/bTGowc+y48PKJ4?=
 =?us-ascii?Q?6/GC+4pFO6NqPc5gLIOuplkijxggnR3BsfAVzjr3SBGavYdV6QxxoY1KC10W?=
 =?us-ascii?Q?CjMDJvlLOqCaMZrvedWudxT2MFWo2ofb68bvFkEyww+FU2Zu4/t6yEUMoVYa?=
 =?us-ascii?Q?qP5DF00wmgqpAAVWECFOr8FadaQQGTcplrReHPoecpKk22WT2fPKD5mRBfgj?=
 =?us-ascii?Q?fpkVjGPWBlBogixWEB4GRVtY3PcZc32xWY37qOU7ZxVCUrKmK30OQ48HFc5p?=
 =?us-ascii?Q?ewczIolOXSOh2pk8Ww2l3LzF+P7kCRlm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FsXmEq/MWHjh5c1lxjnCa2IZguQ/ABzIN0CxBPWtS4g/dwWL88pMNxohoo5Z?=
 =?us-ascii?Q?iMicYGfnpASMEJ/7CY4aDrQR8TTE8nwvlwojTlBO+9pJw0Od6RZAC+ksgTLX?=
 =?us-ascii?Q?hgnN8PkUuRlJpQCGI1TO8yg3+4FNyjvw3DuVm3zxRT82y4xZRrORMRErX+NP?=
 =?us-ascii?Q?T09dilTtHFrAuCscfLBup3UcumDpfpFAl0NP7t0GnD2Ls7x6nFHzK6cwZIto?=
 =?us-ascii?Q?OEsRkPUakPZCDj2hKuIoZCif6boU2n2aUMcMsmBoctN2mf/AapFNt4QuutGR?=
 =?us-ascii?Q?9ePu+FmYi0ASa3YX2gj3HlMG7JbHBEW1iC2aMJUS/X7n1oC/6YhwqP84jgwV?=
 =?us-ascii?Q?a2Ofb/tDdoaOoVrBwc8b7vU3IOlgkeb3GJnJ/ubYfY3gSWrv1mk1OUgGW8Fz?=
 =?us-ascii?Q?3vfYoxy8Ftq4HgeB7rV3zPgLt+uBru/9fgLvSKVVADMQrQKfHruiCgxhAWk7?=
 =?us-ascii?Q?JbwM3DKSeFp+9YbX+Lgine1rapiu8DjdOvUdn2dI6C/nEdVrhjFvLkZs7i5Q?=
 =?us-ascii?Q?EqldCK3Q5MvvWbT4L2RLkuargwnfT2ls4Ar4uYWc9lGieems1hg/ktKxsbSZ?=
 =?us-ascii?Q?HBsbiS9Yh8PlHM7JXNVSbNyFhX0AyH0WteqDTEZS3dAqsBsriKVq7jhi5ttH?=
 =?us-ascii?Q?PbwOkHSktHSNCSnoPfok60sq9XP9fKbT+EbPrxZMojgKHaeUT7y/wJIQithf?=
 =?us-ascii?Q?WN6q7Hnjzgb/gWHZKe1RqUyde3Y6hn0cdGSutvVol3d+HcEvOUCZU7n9TjCC?=
 =?us-ascii?Q?YgZ0oZkV9wZnCp/8CIBPQVRCZtfQ/yP0exfl30Ej51JNj0T6oU1UTaPt0mG9?=
 =?us-ascii?Q?/UvcHm3rKf10EFzuJFJrPfxV9VUUpRd/mk0Zp4nUNBWNumiORqVzwNSXGSyx?=
 =?us-ascii?Q?oVaDnr4Z63GvoeCAvcSmZ4AzaDwM3r3XxovVIVK7mxS7hP7hPKWMUkOfJfCc?=
 =?us-ascii?Q?rw/J3YAcKulIDSbKYU0qVOH4DanGq2LpqdTYnfISxgKFg+HIBHK/JfjrAGtP?=
 =?us-ascii?Q?8KBJV+MuE04pYhP7PlmpR1ISfHxJf+gmCO7AXWX3Pn90mSTCduwWDVrL2F2U?=
 =?us-ascii?Q?pjLDR4WkRCj729fJLH0W32AceLkNM9QcaLxAIU1lbiuG9h6BTQnHlVyLstMc?=
 =?us-ascii?Q?sgYp3QfAp48VAOOokFd7dg0S3aTlaKxJq3yw0iOF5qtIAflArVZFFVB72ZN2?=
 =?us-ascii?Q?pGGGJ/we2Aa9RjRPyB5xAMuEcFISrcLqWQ54876gynHSJIZ0uiHG2GKtYyuL?=
 =?us-ascii?Q?8WZh+gTSFpLJWLHvJJFid30cBJ5ljvKuHcHZNxzZFSbV5Rw1lV80atDr3iUz?=
 =?us-ascii?Q?jjl198NR0pZO/kv3HVM46f4RKH1NtrA51pRRSm/Ykl/hbjUdilXR6lgk7Tvw?=
 =?us-ascii?Q?5C5Cx1SS6BG51/Dss52NVMZdkqENsyDur4IaZ1FZAWpFOrPj8v8Rt/Qw/RDA?=
 =?us-ascii?Q?UdnrqBc5Nw1TSyF6AixeSPGHs9vpEFvzY2rhmH6AZjyxBeh66HTghwY7oBeU?=
 =?us-ascii?Q?UeUelVWpDKcMwgjjgvGzWAHgd8rLm0EmpyjJpqgucxP8WDbXoPHQA0JSn+XO?=
 =?us-ascii?Q?vqDybvIOxlWOehlYXG3IH60z4waAdG4O+sItCytT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49136f20-526c-4e58-b9c5-08de1c8855e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 16:28:21.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M71OLQmTc/x2yuSbrddwhYfSTx42h2g5+j3UcWNfVE6dYRW2AyjncR4+MsR4Xwt2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894
X-Rspamd-Queue-Id: 049634000A
X-Stat-Signature: 37s31bj54a1tgspkxixbyb9cwroihser
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762360105-880530
X-HE-Meta: U2FsdGVkX1+o1WAJY+JIYK8AzKU++zIj49IQIgw9yGyEJuL/9lkugbx5n9ryiaHSi7R2GgGmoNY+0uYXlVZtRClJ/cHimIrUEV1QipEukrmerkUZOGXdIKS6yt47reZ95wVjr/pKFHkQn4l+iJZthXKV67x6elvFTMJcGx3BLy72lFsb8uH0nkdvlo1GBJhQ5YBH6dPnRfrw5GnyJ+2xejbJlIViZ7fWomSD32fdDHIGOHomjyNvoGS7rU1TS/3DEAjNwix2MVsTnH39BtFy7SMQWqSFwDRNS0Oi+WZKiN6Iet4XGnibKyx5xTywk3Z3Kr558ciAUJhgBOh6WPSFfBZn6cokzqckm1ECFy8OFW+zEnEgT0MTzUjEI7F8od5ebTP9ZT12GjJ4T6jeXA7WGprco0C8qw/9tL9fKOizuYAaQ/wPow9+VIotIRQSYPEBelvkLEFIbm781tzwFwEa/LaVTMrCU4DAwSKWHm8EVPWbNQr6bwV1gTNAdtdVyeB8eHpZ3Z9vCILeM5J4vTB1SSGj8GkzvasiqtVf1fzArl3xAjCrHQb3rE8WLowFvVsXBHM3gG0pcmWfBKE/3APAjNFRodbnyZHBWoE8ogp9UO5ygtLsnh4X7KXVnuB6B+VLKUbU8zgr1WrhlwnQwS/F0LMnqVyVhkNeLqzCRIVF7AihRWG5K/9UBWQBiWtrxdR/dAJAsMtyGIf6EdI0JXKt2Al+z0uosIvHb+J9XsqnTqkb70JW/DAIunYm2craPlwPCAx7emvr8areUGuOp21UJ2p/JD7MpWyCbf3s96ndlOQTfoJrRMHcfIzv9Ojd7G28RO+nFVPoC+wMc7OVBAVY97EB+uJ0tofoW1703ZfQPTq3AdWWm6EjFnbHEwcN6X8hrSXMIU21B1gp/g5JEvMWwgV+c31AtikmFLp4/rx72IoVlqb2PHLLOvgx0URnw8ztHPt6mwt3q14DsbVcypV
 4sr0tI1n
 O+FBnNyrbWQ5OhPs1gejjMbm/ipth8kFx+r1yiSX/kxjmVcVxP1aojOd2PiLLnDtRBr5jKdSCnD5NS2tnSg63RB+xVsRrzB6HFWYIB1YkbhwIq+LPwh6/zX4+cXpzAo4xHvkMb96dec0AE6bBBszJ7Z8UzVzwJ70h1CE31glQmrqAtCmqh2Q3TRwpTj83lmllpfdJQ+02NDzQlGse6tM6+JS/Fm0xqBplY4/GMsLeTg4TD+M7zggAkOL8llXrqX0NGfBRETbvskxcV7yQHKSoYXWvXhsLo3XsMVTh4EmAVT5q/fhX7ENHaIQcAuE1Wx1Kzuu5rr7y/YlwB9+TabXMrK6aDMqY2nRLTWb7qlDhrZGrUOeQF4j3fbNfXF6ss102v853HNnpJ7O823LSmFPgqhkVJ1qhtAHNDFj8tLtUudMMXXzV6LGcy1k7+C62VFhJ2OQ+0MZjJa+YdTNHRUjtVOQSBxq1vVq02r3gwAk5jLjkTnhgazlOD4BXEMIDkyWZWN38hA9H/WyLa2pnxfJ3BixJOX7hmK2s31Easd6kAI0MSKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Nov 2025, at 3:05, David Hildenbrand (Red Hat) wrote:

> On 05.11.25 08:25, Wei Yang wrote:
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order.
>>
>> The reason for this check comes from the following two aspects:
>>
>>    * some file system or swap cache just supports order-0 folio
>>    * the behavioral difference between uniform/non-uniform split
>>
>> The behavioral difference between uniform split and non-uniform:
>>
>>    * uniform split splits folio directly to @new_order
>>    * non-uniform split creates after-split folios with orders from
>>      folio_order(folio) - 1 to new_order.
>>
>> This means for non-uniform split or !new_order split we should check t=
he
>> file system and swap cache respectively.
>>
>> This commit unifies the logic and merge the two functions into a singl=
e
>> combined helper, removing redundant code and simplifying the split
>> support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>
>> ---
>> v2:
>>    * remove need_check
>>    * update comment
>>    * add more explanation in change log
>>    * selftests/split_huge_page_test pass
>> ---
>>   include/linux/huge_mm.h |  8 ++---
>>   mm/huge_memory.c        | 70 ++++++++++++++++++---------------------=
--
>>   2 files changed, 33 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index cbb2243f8e56..79343809a7be 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct pag=
e *page, struct list_head *list
>>   		unsigned int new_order, bool unmapped);
>>   int min_order_for_split(struct folio *folio);
>>   int split_folio_to_list(struct folio *folio, struct list_head *list)=
;
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_or=
der,
>> -		bool warns);
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int ne=
w_order,
>> -		bool warns);
>> +bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> +		bool uniform_split, bool warns);
>>   int folio_split(struct folio *folio, unsigned int new_order, struct =
page *page,
>>   		struct list_head *list);
>>  @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct=
 page *page, unsigned int new_o
>>   static inline int try_folio_split_to_order(struct folio *folio,
>>   		struct page *page, unsigned int new_order)
>>   {
>> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ fa=
lse))
>> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D */=
 false, /* warns=3D */ false))
>>   		return split_huge_page_to_order(&folio->page, new_order);
>>   	return folio_split(folio, new_order, page, NULL);
>>   }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 381a49c5ac3f..db442e0e3a46 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>   	return 0;
>>   }
>>  -bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> +		bool uniform_split, bool warns)
>>   {
>>   	if (folio_test_anon(folio)) {
>>   		/* order-1 is not supported for anonymous THP. */
>>   		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>   				"Cannot split to order-1 folio");
>>   		return new_order !=3D 1;
>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    !mapping_large_folio_support(folio->mapping)) {
>> -		/*
>> -		 * No split if the file system does not support large folio.
>> -		 * Note that we might still have THPs in such mappings due to
>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>> -		 * does not actually support large folios properly.
>> -		 */
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split file folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	/* Only swapping a whole PMD-mapped folio is supported */
>> -	if (folio_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	return true;
>> -}
>> -
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_or=
der,
>> -		bool warns)
>> -{
>> -	if (folio_test_anon(folio)) {
>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>> -				"Cannot split to order-1 folio");
>> -		return new_order !=3D 1;
>> -	} else  if (new_order) {
>> +	} else if (!uniform_split || new_order) {
>>   		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>   		    !mapping_large_folio_support(folio->mapping)) {
>> +			/*
>> +			 * We can always split a folio down to a single page
>> +			 * (new_order =3D=3D 0) uniformly.
>> +			 *
>> +			 * For any other scenario
>> +			 *   a) uniform split targeting a large folio
>> +			 *      (new_order > 0)
>> +			 *   b) any non-uniform split
>> +			 * we must confirm that the file system supports large
>> +			 * folios.
>> +			 *
>> +			 * Note that we might still have THPs in such
>> +			 * mappings, which is created from khugepaged when
>> +			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> +			 * case, the mapping does not actually support large
>> +			 * folios properly.
>> +			 */
>>   			VM_WARN_ONCE(warns,
>>   				"Cannot split file folio to non-0 order");
>>   			return false;
>>   		}
>>   	}
>>  -	if (new_order && folio_test_swapcache(folio)) {
>> +	/*
>> +	 * swapcache folio could only be split to order 0
>> +	 *
>> +	 * non-uniform split creates after-split folios with orders from
>> +	 * folio_order(folio) - 1 to new_order, making it not suitable for a=
ny
>> +	 * swapcache folio split. Only uniform split to order-0 can be used
>> +	 * here.
>> +	 */
>> +	if ((!uniform_split || new_order) && folio_test_swapcache(folio)) {
>
> Staring at the existing code, how would we reach the folio_test_swapcac=
he() test for anon folios?
>
> At the beginning of the function we have
>
> if (folio_test_anon()) {
> 	...
> 	return new_order !=3D 1;
> }
>
> Aren't we missing a check for anon folios that are in the swapcache?

Yes, sending a patch to fix this.

Best Regards,
Yan, Zi

