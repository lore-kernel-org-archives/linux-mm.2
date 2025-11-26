Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD95D111A5
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92BA6B000E; Wed, 26 Nov 2025 16:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A296B0011; Wed, 26 Nov 2025 16:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58156B0012; Wed, 26 Nov 2025 16:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4C976B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:06:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32952160707
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:06:30 +0000 (UTC)
X-FDA: 84153991740.12.CBF13A1
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A03EA0003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:06:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DWUeKOiB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S/mZGiO6iXL04m1lao/u7ZKUMtSE6ZWhIWDZj/+w2ik=;
	b=LhC91VsCrx9kLp2R7kdezn+LzYZhcdx7kFW6/+J1tLxmfuq1EvTr3scJlGdYJvkY6ovhRY
	iKo8ykC0zXTNyuEEuJqvLVizdMRH1NIPcNBNJz6xUU0Ao82eKfkvDd2Hj/vMykwNm7gHzV
	vUKVmtzhdCSzXYTaG119GH2yt+fcBoA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DWUeKOiB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764191187; a=rsa-sha256;
	cv=pass;
	b=8M5onvVaWsZB/svN3aYxbgvXBUNY85mvxrZJjWybys3bpSuCfAcC4RXMuVKJYlnCSQ6VcY
	XloUYwADIfhPPsTtR5HNqnpzQHECaLFC1TCeUHBI7LwOK6seIMYmy980KLTfh7QGPaJtpR
	j/KW/brjEbp5rbgWir9vacAX9dW4cLM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFfZQgYRT5BFc7fFOnjDkUsLMloA27uW5+h8Vnl1IyoHz+lDimgDUeLo4vBCUvNDxA6Vs6VxnGOror3CjdPkoeGBNcS/dR33reg87XyifYMz94yEG1wnNkqFtKpbH+A1upjVvdz5hvycwbM9VheZhwIxp+FeJjaj4vX6hBu6r3yFVN3BPRXW7TqcarnQbldApMRHOysfCbnIwnIcmVg3j5GELRyFx7vjYc6bSWEg83u7q3jmTaeHoIy8rGPQ+dIIofUizIO/3I4U3u6YidRyxgnFM7Cvwb90ezj6NQNJwQ7yZe/xLkUwTP4YWKOzb/9A4Ms8nUGnExskz8h6be0hJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/mZGiO6iXL04m1lao/u7ZKUMtSE6ZWhIWDZj/+w2ik=;
 b=NihYYsAp6Qv4/kCALlhjt9NkMvmUT/Bx3QzKgZ6LgCa4hcID+d9CalIrMMTJn6RbgumKUDGY/DOdGjJMPa70cJiGeEFm/XoyORaIlTApk0kIShVDFB/KP69cUO/v87AnOsKrgNsA0AtqbFx0hMbknpcJ12zTZAcs0fG5+h3Qrw+MEY0y7F1pF5cIlEkg9HIzSjGSPAU9pV/G58DH4IEY2u8I6OKML8gMTsUGjmkaUDyeuD1NmWg9CKc2LGcmhYcDwqlWpXfPHMvpmmQMUi7J3u3SekrTFlFJXeo6DW86P860QwpVsFfpzdtWgJFNDmL50OZjloVbSsWm+c9DTWIBuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/mZGiO6iXL04m1lao/u7ZKUMtSE6ZWhIWDZj/+w2ik=;
 b=DWUeKOiBOsonafs7WusOpXSmvZIuAd5wLORp3hweKNLABV9lrtC7jqhi77BvWdMlXCNiOZxnwQFVUsaC0xSZ1EPi37jrN//s5j+ZJAVJp+ThmsaPdiXN+CqH1+3d5vL9VkY7NFn3VAmmfWrZfqA3FYiaR7yBcQdH4ItQOyVhmVQg52ysEjMyWTn0ej7mI2AWMZbtLOxz2OMQ1ggwwDzq/JL9syf0iVYJOouBlOJJdryOe3JrA1WXBzOiIlgniKWTsDBllb1pQ9iTJb/cQgxN9n565/g+ksviMcTXjPLjE/KuPAa7WJqAjuE/faLOY2E+4u/+dQAgLou91627W/gs0Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 21:06:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 21:06:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] Improve folio split related functions
Date: Wed, 26 Nov 2025 16:06:14 -0500
Message-ID: <20251126210618.1971206-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 488c6b16-2cd5-4599-cdaa-08de2d2fa7be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FtQDo+Q1LCJa+4EZaq4QlDsx9QjpEmSRq0gYuMluoj4O2Z9iydlmsZFcfuue?=
 =?us-ascii?Q?PLgDPg10Egx96zV5OOzQKEa52ZqCM84/5wpNB/5hVlfq4tSXbTKD828sti0x?=
 =?us-ascii?Q?2E8OcMvGUGS1KZBPu62jfRWifpoOUb7Cb5tMoluw3tRrnV/D1bmQMT25HUPg?=
 =?us-ascii?Q?8q8RKncD7851ZEchsE6NQNdyDZv5pghE+INw0zIkKpyyTPLpg0rpEO3/YYss?=
 =?us-ascii?Q?z7wMzFikSQiGeJPzex/VHDvZhXmOqmzSet1S8RO07B++3CF60ANhPUTO6Z1L?=
 =?us-ascii?Q?kG8jPMOwv/2O27tMgQ3k8cb/sPtQyLGfbpwlXDROfbxLfJGwP5PdoAe+MFt4?=
 =?us-ascii?Q?rUJzNxEXpKk/7DwEXxvv5ayDSxHQugjXXOhIExX8hi67JCrrUEl5MPvaAhbd?=
 =?us-ascii?Q?A83Tc6eJsJa6QU2Va2WZrBPL7c23ZlFkOIs8dpzv5E0eMi7BdQRZHqz3m0Gc?=
 =?us-ascii?Q?qDTnEvIHq6k+8OH5rTKj7wfwCrQPQwQwHecMNABVPyvxipSOnvX/Oqw6fPvR?=
 =?us-ascii?Q?D3mP+Od2pqAKb+c5d+DlfDQhgVHA3Q5IqID/qHRIT1Qxqd0YyQIGeNuehCfk?=
 =?us-ascii?Q?GBjqE2r4hVaCPWEBXhQgZoJb/v1fv1Ny/d28KB5F5P5zTTua2nnHnCvsA1Hf?=
 =?us-ascii?Q?z9rkALElHrIe+ZU7c7RNggt5GAW4caEzvhVVK6d6+GxIG8hSlXULOeBmBZ1A?=
 =?us-ascii?Q?/qpbgFufMCHzEza7wdmhUc3OCsmRWPsgR0UIIET9Yp3EXhtS/QjnsoXf057P?=
 =?us-ascii?Q?0mCvOGi2jeHCkKf1B5GbZuHGz7dec7uHtKdOE4nS+zzTWJ0pmy31dJSwd6NN?=
 =?us-ascii?Q?SuoeIB5ncSZ2J+M0o9y+MDXKWwfF8FYRFXI1LV6ZIDbenmT9o1wIz8mBfe8k?=
 =?us-ascii?Q?yVZqK8aXuCrQn2lf0wkVebDRbZrJ3gopIqlY/Ls1JC1kcQtHcjOT2XNKwaLp?=
 =?us-ascii?Q?kkCpginVpiAgWxKbvHiU1lFmO66j3Yp/PPgPMxCr9XM/pwP7VC7WGAsotrbI?=
 =?us-ascii?Q?yOA1rWBO920pzwDaESgj+hQsJSHDhAZ5hakprQ9WbI5kPv9nmr5ecHyB1LxS?=
 =?us-ascii?Q?DB10VDeY6WpsjW4LSdKUrYSyMfDi/3c5+DLkIleYv814PNN05MJ77LnvC14z?=
 =?us-ascii?Q?VU44eMuhC0wltBHs4YqyqwfTTb6JoMhxnoWpwRZLXL1ZLsf6C/hrUChmPiVW?=
 =?us-ascii?Q?CBptTh5i7ySD1L6bTPJfxOi2zWv4EY9ogA0aigEjHeQfEX5QrGhlhHc3hmpB?=
 =?us-ascii?Q?X3KYPh7zl8keRz4knSf3uRfBsMT4QqNBPQEGZbRqRXWNaEsiEshI4el41Em/?=
 =?us-ascii?Q?aAp+bBk9UNp7iT43Hwb2J0QCpHz6MDqOjjyhfUaUYE8w5UcOb18Zz94jtfp3?=
 =?us-ascii?Q?wkEtPFrSf+eUXjSg9hxlO34rQ4kGrWwdrmnDEI2rWZ4YedJGvcY5DZ1gZVR6?=
 =?us-ascii?Q?As4pih5lC5Mrvmn/vui01FSS5igdaBG3S6ubq9MBLzUMDG4PzYXZCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t71oUlcbNDwR2KDU0uMq7TLENFXGlXJv2htgbqq+aa64lK6EGcjfI6PUfKwA?=
 =?us-ascii?Q?d7mJYv2cACVaDo7NPrwjVCZWY48YniUB4+T5ZjhE0nYC807jVRuJTNCbv7zC?=
 =?us-ascii?Q?O6koXbSwI+y0DXfPgK7v9n+QW73V9JL+wHF387FkxHYCFxIh9pw4Su14vpNY?=
 =?us-ascii?Q?V/UkowfR1RIRDi3S4pH2XxsNoU7OUwgsm03lZScJCYbggC5BkHeNBsc0i/rD?=
 =?us-ascii?Q?AoduAGcQqPQ4/+nVFMSW2XpVkKZ5c8lHpQyZd5avftLbzziTLmwyUZbj6YKZ?=
 =?us-ascii?Q?7aj6ZN4Xl1ijuhSoPgsS236W5wC0B87nIrP5HGzxTagcxK1VVfu5oX2QyccB?=
 =?us-ascii?Q?7anVCTYRfuwNlaZrLESD88F0yvWrluNvZuzCyw44h2u+rLi+dLr2xou9mWEB?=
 =?us-ascii?Q?xVQb1jniS4GD/gCDsJSUJgwblUMLH4aR4lAZjKvOQH/VZjzZ6XFntzNOsUZv?=
 =?us-ascii?Q?XlgwT1nv7UvmXBdtzsnrfjdB2VFBcAdvxyZxd2tH8XR2BFHNhdw1J+Mv23Oq?=
 =?us-ascii?Q?aaly9Edsn2CDYk7q2FM5khiiXZl2dPtT8eQloHuRt8nirFOrc47STwrKfL/W?=
 =?us-ascii?Q?jjalcjRfUKS3n2RaRDcziLuZ2iqfqCeNDoVDmh9grpNfroUvXjfcNiuzG++s?=
 =?us-ascii?Q?L1NluuLDtA6gRxSD2X2RYUvLPRLW0A76+1rfBqg59EZBL1KmlhmaKE3BNxSS?=
 =?us-ascii?Q?4NgEj0sAIUZJVw+096DZSCjdZWyaeXxZwQmd65xAayn8TGg7Uc7NEhwEMvI6?=
 =?us-ascii?Q?8oRG6wbHbKH7sD9Y20IFAe1WNoKogfXCkQZ63+pah1qnbHk4DonPMnEyEEpm?=
 =?us-ascii?Q?IyhumlQlbNe0Z2GuU9CrpwaUgk7teC0R1uUZCKXg3l6P51J3sHo5planxLf5?=
 =?us-ascii?Q?KRIDedjL8pfZnU3YTRL+CuL96m3YMKNJeSVGWhf+TPdoFJzD5VssFr9SA72d?=
 =?us-ascii?Q?xCs1iwK7UZabR+4ZauSvxOXyWTiqBR2Amg9VTPsXSu17DgkG2LochDQEaEoc?=
 =?us-ascii?Q?a7qu7F7MKqbJH27Brj+Mjc+08u5r4T1LqnO/wBq/7/WGhOeQsetuDxQCHsNa?=
 =?us-ascii?Q?rA7JIHhJKKfYYxXlJNtdTy7hn2V5OYXE73ShCAs2DLKFYnEVKdaXdeCnnL3N?=
 =?us-ascii?Q?Dt5cPjGKZNcGuJMt7vEEFSGc1uZCTA5LyEGAMkDxOAqoFO9l44Kui7YIfTuS?=
 =?us-ascii?Q?3iaIwUbI/15/GrKSpomh4CuYNOvHXEMucC1UtpHl5icHf5ovLhmbInm0U1zy?=
 =?us-ascii?Q?F3vwK4QByYPsGp/YkRMze/uF4dZjM8i3R3X3/ZbN8E+YP6Y1cLLvr+JPVySn?=
 =?us-ascii?Q?jZzpoL3m+5kms9vcaVW6dkYT4AavHs8OASvnHZVeJg0FPztm/TV4NkYjXMn9?=
 =?us-ascii?Q?XSai8vRDMlyRVhdSMLc2g5MADK5Ju48RdcZxK+Tb9Uyox0LJZ+l9O/LCx6nz?=
 =?us-ascii?Q?3fey9MHj8dFfDGJT8YDml7fH+iju79vYIpggGpkcrF7HjnVeRgY2L6hVFvnC?=
 =?us-ascii?Q?5M7c8K6yFck+Tr+/gj7ioAphDdwifGSIGJMaq4aLIk0zultP2XSRRrqogDCq?=
 =?us-ascii?Q?U3wqGqP8OERMgxKnZZSpsD34aCekbFDGhu1MTA2S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488c6b16-2cd5-4599-cdaa-08de2d2fa7be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:06:23.5553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQ1ErvMvUCEWPLv6ti37sM+N/lNfokzvWcn57fC2A3sNr8SkB1nwsjHBxoXRSZM9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A03EA0003
X-Rspamd-Server: rspam11
X-Stat-Signature: eydua7mbo1jydf1yndnky1nr6c9h1hhx
X-HE-Tag: 1764191187-151669
X-HE-Meta: U2FsdGVkX18S6a0TlaLe0E3LZqVTO/GNR2M6+WJQLWSkABld9u3jrkseJVrXNBGSuK2idmoWAadFQvl4GYXlO2oY+LDB8qs/zyiN1aPEoKzF97nS3JmF/9E9/FQ68DWPjj4WCI18ubvfFeL8XKIgFA8CHfjttedBvMgIZNsLeOm7SNw5c3ZIH1+YPwAzxxSvpHSB7HFNFmPNrfspoF1DZIq9F6QnvnQ23k998u/dYanaqVkn16meQoHXxzcTpWoLWhcinCOgm2r7FAGwJh42AET+poJwE94L5owvk/fOHNIPV9SfOrdW+k1dhiRNrU4eQoIO3yukxL+HbhMDLBXiaF+LI5TWCrMjnlepsM3gsZV5ndnJCGhx6dW/u77BoowkAw8hL0EzNZWE2DVsXPT9+E7lRxrJ8M1F3WHgHt4AFy0UMWVSVPN3ktblC5E17587I7lQqiSIcelJBnPXpl2r1816cE5osSJWXUIjW3ihSgW2iGY4MIjA5ozjUMIwVBxo1NRaprZosxTZHYdMpPdnmYRwNBf+AfqAvFRY0dlKGWV6xqysvdfX/EcLlkmKOcCd9SCg9caD/9xC9ZDJZJ4cB6D11faRwxdG23+SEn8mulz7fTgaWRNp8DJPE8UKnv10WRn+lfw7DnOoIZb6xWWBLnUqBYsC0wIBc9/TbRN+wGaqv/FowpyKd+2qFQ3b5KeJk/2DKs4cbhHyf0weWPJuuBDKZPciWxNTZfq7Dn9Nl/eRrzFnhRObGsnqttO5nqNyrkwy1TrUXluw8RSSrOvTnR1v7bOmc5pDmSRUHHNugNNpMPxTA+WtETGtUG4lkkNIA2RvbIdY12f/O9kqxJ7A0epQZn2BXF0gWNdLkTTyae7D8o2tRtggRfG3Gg6lTCiYJwbn6O08taHDC8xjuRB2f+OKhseoCcgALDxNlVopKyKO2cThAwcP1Rn6hIN7NJGGZS3SRMCqirc9ZpS/d/n
 P2BHx/C8
 SzblgK7jfG+FBc5HGgR/X0uyk8pSsxLHK9sxyNYkk0ga3af6hNJZimxJRE449VcLHaUguMcIyjfNGQ/6Vkxb9eEnm5S9qpUw9W1RA9c6bkF0fYsai37rWh8d5KeViO1zS83kWLPj1zLCn8km8S4HrqUD3EpERVYahp62t68FNuqp3TYohrUGFkm3m120AwSmlDtPLayMW6RkHZ0UbmpCBtpW/Yje2+3P5VEWTtg7pM6veVDrJ+s/gkUvIOYTJrv3KMr+X5ULauyTPSrfyivUT/5bdFqJ/9+A770JLFD5dxvtnkorhCg6CPDs3NBnMVRYY1Zhiyg4mr3Zy2gLnuuviaWYts6/l+IBt7zqdzKIBiDUklXk4zF0NhiWGpB570Lk6JUpkdTCM91B+j+IxOBV2I+ehziU0MyE4AeFt1VrmuShgE1hEpIQLBgPrHm/nYGsUzlBshTWBIriXbXRfohvVTEZabmR8OejOSmRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset improves several folio split related functions to avoid
future misuse. The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count() and introduced folio_cache_ref_count().

3. Changed min_order_for_split() to always return an order.

4. Fixed folio split stats counting.

Motivation
===
This is based on Wei's observation[1] and solves several potential
issues:
1. Dereferencing NULL folio->mapping in try_folio_split_to_order() if it
   is called on truncated folios.
2. Not handling of negative return value of min_order_for_split() in
   mm/memory-failure.c

There is no bug in the current code.

The code is based on latest mm-new with V2 reverted and can replace V2
cleanly on mm-new branch.


Changelog
===
From V3[4]:
1. Reordered conditions when checking truncated shmem or to-be-anon folios.

2. Removed expected_refs.

From V2[3]:
1. Removed "bool warns" parameter from folio_check_splittable().

2. Removed all warnings in folio_check_splittable() and added a single
   warning in its caller, __folio_split() instead.

3. Spelled out in the comment in folio_check_splittable() that folios
   without a mapping in the swapcache can be shmem or to-be-anon folios.

4. Renamed folio_cache_references to folio_cache_ref_count.

5. Removed extra_pins variable.

6. Replaced folio_expected_ref_count() with folio_cache_ref_count() for
   folio_ref_unfreeze() uses in __folio_freeze_and_split_unmapped(),
   since they are equivalent at those call sites.


From RFC[2]:
1. Renamed folio_split_supported() to folio_check_splittable(), changed
   its return type from bool to int to return error code directly, and
   added kernel-doc.

2. Moved truncated folio check, zero huge folio check, and writeback
   check in folio_check_splittable().

3. Changed zero huge folio check's error number from -EBUSY to -EINVAL.

4. Replaced can_split_folio() with open code.

5. Changed min_order_for_split() to return 0 for truncated folio instead
   of -EBUSY and added kernel-doc.

6. Fixed folio split stats counting.

Comments and feedbacks are welcome.

Link: https://lore.kernel.org/all/20251120004735.52z7r4xmogw7mbsj@master/ [1]
Link: https://lore.kernel.org/all/20251120035953.1115736-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20251122025529.1562592-1-ziy@nvidia.com/ [3]
Link: https://lore.kernel.org/all/20251126035008.1919461-1-ziy@nvidia.com/ [4]

Zi Yan (4):
  mm/huge_memory: change folio_split_supported() to
    folio_check_splittable()
  mm/huge_memory: replace can_split_folio() with direct refcount
    calculation
  mm/huge_memory: make min_order_for_split() always return an order
  mm/huge_memory: fix folio split stats counting

 include/linux/huge_mm.h |  13 ++--
 mm/huge_memory.c        | 165 ++++++++++++++++++++++------------------
 mm/vmscan.c             |   3 +-
 3 files changed, 98 insertions(+), 83 deletions(-)

-- 
2.51.0


