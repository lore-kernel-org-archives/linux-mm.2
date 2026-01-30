Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC1BE6BF01
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A746B009B; Fri, 30 Jan 2026 06:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB2E6B009E; Fri, 30 Jan 2026 06:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3896B009F; Fri, 30 Jan 2026 06:12:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38D576B009B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:12:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE7C91A036A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:29 +0000 (UTC)
X-FDA: 84388366818.27.F9C807B
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011058.outbound.protection.outlook.com [52.101.52.58])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33615C0004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t93XEsir;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44VXs0DdkHzVsIy/CsPvvqAnow0el6Pgh9B4iKsEvP4=;
	b=LVPuch3hP5kpwErNxK52xTdEf6SNXYgv6ST7bRjntXnz27ihHo4wThH+TA08N+cpYgNUww
	7njJFl7B4TBSd7eBWlOacVgZp30g4+KJEYsjWcu/Tf51uKjAUiEAA8XLCz1TZWAILOXaGz
	Id66kEFni7KWvZSp5JoyOv2622FU9is=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771547; a=rsa-sha256;
	cv=pass;
	b=jRzRLIjSgGS67RFw5IitSZLRHI76WsCizbAMZMBPKc+dJctwD0IoK3ox9FU3YVwmCyMWn2
	HgGk3Z4OAWF7nSUE6KeV5cmx8MlnCitdTRAWvMiJp+kG+RwpvJdN99MUxwrZHAghcR2dqW
	EbizzR1mME7U6MEY/92IOtI/Xc/v7tE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t93XEsir;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZoDHSljPZOS2vfpUFGr++jP3iF2IZZFUVsPNwz4j0jaSvY6grvwLXR3p5/jyp+TCD5iTLhGG3q7aQVMbudsOyUdgVbou0tDJLklx/oF1ypfbRVtdRIHNd8OaaY54VZY78Ae0bBnrN/RCxuRoNE1GLCELBkY1MAT5R+1n+0kcsMyTYHYGNd/ZW8wl1PbgeiegdOKWN4mcwLDEPrku7mKnqEhzYKNDxKGljxrd/1sLF5HRRehnhOaMKUb7cKfmZtMlj5G1v+qUeMtxWImgOJ60oZFs1KNjplD1Bp5ag9TTuFo2OYniT6yBJ6jvOKK1ERPc2waHiGKKi7c1ybuDZ9o7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44VXs0DdkHzVsIy/CsPvvqAnow0el6Pgh9B4iKsEvP4=;
 b=AvN+O36ksbmn7NM00CFnn9QX7HPnShdqK1BxQ4rMynPb+YDlqAKJcuMbvR+wPo2JX6Wxc1Bhu8/JxAugghnCxIh2RtKVOWWaPdM4JpAjmBnc5EK7nwKns4EVHxEbWMzZpe+5xNasDMSL+YCwAlPaoPJtZb6oIIFnSGYqT7RWbM9P27On/bExgePV5YN3bLsX45L/bVlyg9qUagddb8aG65ke8INjq6DbXAUI1RbEefLdcaRMXM4fyyIPReeJCNEac+l+2nDvYu52GpYG6Vl7WiWg4GLEaee9IL3bFR552crd5JzcxzeAkn2GRWGTtvq/GJ1utY8FhHxJ6mkA106+hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44VXs0DdkHzVsIy/CsPvvqAnow0el6Pgh9B4iKsEvP4=;
 b=t93XEsir/SvlJesqrgPmbeHnp5Bh2NZk4mFxmzMDDtgsFkm+JtWu3MuYSh/1TnlocI1M+gTk9yCKub3/f7+ZlUNDqpIbZhLXDTVbQ/ZYYRzsLC+cmDMb/cirlnUNDhlCPxEkE/FbhNJTfFmITrDVhhqS7coQNot7n1x4NdoYO5x6mon62kfxypBfKf2+vqFco6wQu+HmEGvUuorn4ENBdyPePLcpwxn2rzLb16UXtoibNxigNsQGirl4VuoIoG6TpEKNNfe6eg0j6Vwuk2/A/sR+zPNXQCEPECqaAMxfFaQBFEBKm5+3IMg2h59YXsoZcvz7/Gl3SdtyOziYycMcJg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 IA1PR12MB7712.namprd12.prod.outlook.com (2603:10b6:208:420::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Fri, 30 Jan 2026 11:10:58 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:10:58 +0000
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
Subject: [PATCH v5 01/13] mm/migrate_device: Introduce migrate_pfn_from_page() helper
Date: Fri, 30 Jan 2026 22:10:38 +1100
Message-Id: <20260130111050.53670-2-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:a03:255::31) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|IA1PR12MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e07ed76-bdf6-41c2-e7bd-08de5ff03eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oYeJRhL/E6ltxFd7++whoi2n0KPBkZn/cx1mj6VJ7ixE2Of6c7ZN8SkjaMtG?=
 =?us-ascii?Q?A2obA3Q66ttFSCb5KRrEmmRk7bj2iUWu1Jip5MfGBpR7glS84ujIKJa3ggUX?=
 =?us-ascii?Q?dA+J4C0SsQpFtLzmkzqDvSVoQGyiCslXsfmSABfPxtxwFrlp1cuIWlX1gERe?=
 =?us-ascii?Q?35QCVSKi+HieHhn/2CrIQs/IhS7Mu5G+tTSBKEabwCngTbkEP6ong8un8im+?=
 =?us-ascii?Q?a9gfxxI8CMpiFUKfQ2C4e8JjThYg1G407phumdQ63A+kmconp1El0IqKsjSi?=
 =?us-ascii?Q?LpW4CmY5xA6azUG74yJNpUwbyYT/5lMIPTGuRtbAyz4wAHFXDw8BKEYElClZ?=
 =?us-ascii?Q?Nq1EkTYlLOEfw3akWB0LCXG4drd1EpRbA3l8iRyDegkC3GcVZZGc1jwcw1M5?=
 =?us-ascii?Q?1tMHj83if3fTQps7SEE0OQRatdffRK7OoubJ+INr7mqfokjnrgZ0Z7dGV6fD?=
 =?us-ascii?Q?bR8KPWYqPQirL8g412FdNadv708ZhuMo7AW+WFqTlMweZZ2IGQYhVvkrYxtb?=
 =?us-ascii?Q?y2omu+OnmWmrP0kHv8aUPtED9JvtjBm47Dmj7e+gbBMSom6PpvH1s5QbcNFr?=
 =?us-ascii?Q?m/Jo4CkDHkDric0YcdQhtuQ266HFk3E8QPgvoY6otXywvlLsVmRYEKZVSvre?=
 =?us-ascii?Q?Ui0ONOuq3CiDyoybR10D5hd6d+4r/u5tOcD1/rQb7iwd21Ef0rwCleV1/OMP?=
 =?us-ascii?Q?EB+EARaydLpIt/QP13Cyn2wpEATdYX4gWa8QAOvaMyUghYLW+8jVyeq972RM?=
 =?us-ascii?Q?QRTijD19nTGJOA2eTpUsKCqLUlsY53ij3IVDlPAuyhusQPnXLWqopgMpJz+7?=
 =?us-ascii?Q?ZvHTNHV7e8106Ua5KzkjSJ53kxGZXoHjfqAzf+LTFUMKBR8K9n1NnQ6RCVRQ?=
 =?us-ascii?Q?Vldrw+jLWm5Nh3s2hZUVDadfba+ThgqAoRqjfJw1IxrIrPWvWp45BPBj4RI5?=
 =?us-ascii?Q?Brkb1s8X7vc5q4DGZOkgoeuMv3Bi6cFkMUdVJVQ1OOMjAcEx5Qbdir2InWmX?=
 =?us-ascii?Q?UPyKAeaB57mkrMqiaz0wOtQCtGrNDgZ56PLsYnNRKWHEd+r4Qqr+OBipjNdo?=
 =?us-ascii?Q?P7RLkJbkErHh2h/AWpe7FkGuHlSGrBGwWiZ2stu/usTrfYSA9DEayF28s/ig?=
 =?us-ascii?Q?NZEKIz5jZFMBhAoLZapp3l1HD1msNmdOi68tQQNmt3fj89/dJN3t6tkaZRI/?=
 =?us-ascii?Q?imovfsi//KEWCRxWFq+uqdn4qyCCMHy4ho278dgWe4USgiwcRjeNwg3kWrPP?=
 =?us-ascii?Q?A2IMnDbExomb5pF7WFjWorTUov251otIP9pF7REMJyz6bUCc+mCEMsJS2e2H?=
 =?us-ascii?Q?DSkk5+k7Hna+usmdSYz1zmU3fIG2XDfZRQq2yLSmP0P7SY3O+IzS0IEgVZ1R?=
 =?us-ascii?Q?xZtgLes64TbxtFG0kX8mBrGhh9gdv2GONhQGx6m+1ryn4S0a2gDb4MPDFtOv?=
 =?us-ascii?Q?yU+67aH1O9w8sWLj3rjyKNxassCyzrB0NQPpGWiR3Ax7tqowgknDA/pwd/Bo?=
 =?us-ascii?Q?OsMmp9EPpzmySHik1cOw404yuwJ7Z9TgTfVfzQCPT1iIpRwojtN5M+ce7Pe2?=
 =?us-ascii?Q?GFqTH1adtc0RPgnn6Jc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZQ/hJT498wW9T2rndcwylhCu2xu6Pjij295InmEWpcy6mBdrBE+AkSSPKtmS?=
 =?us-ascii?Q?eY7I+gK95mEtErXGwoMN6IwFxj9ftNclT/7k5JjSV4He8q6Q9lpydRwWHosa?=
 =?us-ascii?Q?JXSNqMqSKnNIoKI02ptcnGLdIBg88eLmafnrsInbCy9raAqCb2XFVJtEt1yd?=
 =?us-ascii?Q?Yu94V/jewbEAqqS30NmFPIv/T2XKVDLlK4Vah2lihWLQKffpWal3FX6/Glrl?=
 =?us-ascii?Q?I0WHUfQcAh4l0o+Fw2jao2EoUJDO26n6+oqKh99UsCvWLcSI40LYGgSouh2X?=
 =?us-ascii?Q?aWrfujbaZm44AoYOkAjLXGlAiwLveZT7iqmRHdlF1y+wKe1cqMFL+LzKM26E?=
 =?us-ascii?Q?t6SOKLGZigGjsBKXJ4aViRoerK/ab57O90OC8rdOZIo/zQ65gEcEGg1657wH?=
 =?us-ascii?Q?BWr84YX5kx6y/u1We0km1gljwPzTQJL8bwiwvYyGW5lPCIQ84P1kZcvFRehQ?=
 =?us-ascii?Q?pUrYiBUTDwldj6RiLmXZjd6NQht0OtB+TCWRuCrQ30FmFd4nsZO2JvM3fZVI?=
 =?us-ascii?Q?zcYYUjdILTb/9+0OXXmpp8ozxo4Do1wtU7eM0D7YSJUx4xrpJf5tCTI2X+xN?=
 =?us-ascii?Q?VWkf0rX6H3eK/7qqotUNL4H/axJMaDOIme5nfvCGhpBpgeBzk5EpUNk1w8Tw?=
 =?us-ascii?Q?gaMpmQXhH+KDQqBA9fGMjLXIWsTIg01G4IfKYIaY+J19ZvxTTduzXhfQjQ7/?=
 =?us-ascii?Q?SprLC8USNAHTgjvVCAnMWaHDUMUzBWc5DcP1PGtcAA5F01cKiQ2OWPKPSxsy?=
 =?us-ascii?Q?8YGZ+38260LtdrVaeIJP3331graNQJWIIixk0WV8+jonWSMus/tpMjhH13R/?=
 =?us-ascii?Q?qGtBeCDleFpnYSdGYufAfeSUlYCJSGG4CM0YpEtLN56DxACANUl6kOQumd5w?=
 =?us-ascii?Q?7kAvPZcm910KKPiN4P6+6RkddDrSEEUrgcBNm0AspY97XGJkLFD8ghXCJjRR?=
 =?us-ascii?Q?IN9PnTplurDGG4ObNTf0GqAK+iSQGtmy3hngsendmALfMbDpLY5GADwPm58a?=
 =?us-ascii?Q?JKI7hatOtAElhceVuGntjA8VVziAyoSOCDH1Ags/DUpKb9jlv5xm6fZfv9zn?=
 =?us-ascii?Q?H4SM5TJEKHg0vk1N0/EqgZmOrRwdm7iUo2Omf5gwarkzVQOxfbWgYIw7VGQg?=
 =?us-ascii?Q?o6vTZB410NGf2jJ7psakmgjH5XFi4ihI9TxFWSZtNCUiJvazALA9JpL7QwyL?=
 =?us-ascii?Q?F5rVg8EvCSJAnpml4Fvshu0CUxcviaQNTAI/kw/DtcCrEu90GB0phBJBk9XE?=
 =?us-ascii?Q?rs/9gkt5HJoSIULP8oYjXy4yQqTHgueyjDU+bqcB3LxV9QLEC/sLZIWMh4v3?=
 =?us-ascii?Q?5dL3cNtoe/A/8XFdc3108Q5AbJ8mnfWzZXOBDhG3Ke712hINlBJ9qstkNPZv?=
 =?us-ascii?Q?/UI9El4zpYd/FqOzvqi6pMIZA9epv76fnDvOV9ZuZcH43OdqpxxZcOqbg+Nw?=
 =?us-ascii?Q?nsm7gy+vkbrik6albwXVh9w1miMV6GXsyfGB75iCTv+4O1DsLxylXRHh9yHI?=
 =?us-ascii?Q?u+j9auQeKLaQiwPYapxZOXzjpbeJjCWQk/aUehqfrlE2rjGwLhMAVJj+d2bd?=
 =?us-ascii?Q?0Z2cxa2kcsHoDiDM7Q7ql/FA/YYJ1pgqhqfMyHi11CglynIYME8AhfKWMbwt?=
 =?us-ascii?Q?tu75ECh09CEodU00C41dLPA2IYYjr/GyZz0TumQR/fHhOgFLzCouptKG1gU7?=
 =?us-ascii?Q?GrlCrQWX6U2bZ2yH4XFFC3Su6RwFW2Tx0WXynOKZSW/L2fdlJ0HyVjuWpWp5?=
 =?us-ascii?Q?USqtmXsltQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e07ed76-bdf6-41c2-e7bd-08de5ff03eb5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:10:58.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HizVxq8048KlK3X695c8o7NsACutERej3tSJbJ96/SGx5dadxoLwoyJ1p3hKCxr0vTOIJfPeArE9icdMk3xwBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7712
X-Rspamd-Queue-Id: 33615C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bknxc9duuoc1yokz4qzmkx3x5a3kqatp
X-HE-Tag: 1769771547-616665
X-HE-Meta: U2FsdGVkX1/gdhMpzWpjGy6X7htEX/yu4Xq2UU0AJovL2ICxIT3elMYecIdvGAnGj+r5WDX1gd04lal2dsDMF1cfKhMjSVuBdQgh02quCliRLvU5CDP1GOfcMX61AlQoqH/ytIDGU9Z8gsFJP1kqurX3nZqQPdbMW1qJS0yooH7uJrjwBhocupiVHDwi2yvuYTuABR70FOJYvKEWvGms/JUnntEi3TGsTyDrWGDc91IHxBJs5S6zT/YX4x0lI/yDxzBxk4+3ZQGLtNXg4rGaIOKWm2drIBxdxgepjCVVHw39utGUn86yBFhjCEJS1I+ekK2S8IWx4ejwpwExQgb3lcQheFX4m1QFQ86WLfgLp28BryqtjjqLo3eFBi+k5Em8FKeCk1tkTp0J4lCf0bcoreTt+5sYj0ERDBL6N/G+j7U/Ad2ZdWa8arzcjl4ICi7lay2tPxT3c2+c992kVnJtMnXXa1SJpFqqJPXXzeuOCTmYC8FpNox9Gr5Pv3pcCQX4E+BiwEDrH0eNpl9YR5RN8XuHPWXPj6TZ0agvwke8+hroLipmrRzMwxNwCjS11mDybCiDSpiM1jRpKafGmaZfbS9AGUf/rPg+PpAbDTHxBLDp0vBR01bxDnHmroGF7TcIbe8hOWlzTMM21y7FMQVHMl+lWF6sQhGeXoOrOGko/FXhmcCEyl9M/P58vwHIkgoi3pM7vrfTordmqqbT1ssE+UqUWxYjNgqlRGyDbF4txnd/TeLOr9kY1lgQxFVLbSHOKiR7rArqNI9BncmceRc9Yj/zbAtoVAHfGwqiS7mZDR5+Rmp8jAX1Rv+aVNYPprvBLAhN19gmcbLHeqxs+cd0hWqA8jOxK8KhEdYH8ctbcr6cEZgPM+oEvhwk+Scg7OvxFDb5IgiVyG95Miwn5KzGF8DLjmTrAarWXA/N6EOnK4syynfET1hbrn/ygCyVyftX7QawZ0TwN2g5+GBth01
 GyLrLD+z
 uxEPWU58bkZH2YWFfk32EI6NWJoG3Pkm5mUqWBV4jz40anbqAxGtviDyd9FScyYmXw2I5qbjPwxdS+8oKMQEL6z1cfoqh5B718eMucyEhh+g/+42TAImgl4sF2+COexBgu2sNX+LQ2TSxgyNSIy4JOCfkWvj+bsdCfvmEOuG3sZb0R22gVHCbGibcefbRXzcB3zk6GhrHVNg+8BfarH05+xBM2D0wpy4zHrgqf1LmkWF8QO0evxxJmohvLeDosrs3SGBRE64IPU0Vo1M2VZjdrqXF9mx2QF2nmHRoWfNolyFcW7ri5vAmCTS70RhZtdlLJFFx2kZLuVAaPztHtfDqs0zo0db0/uSQLA2ToOLR3kB9mReseWoG6C/LfxnivxMZ9vRwthXQMeM2rlkd+p/G/irGc+9XRmuSzPysSG7Om73wOEHW/UApPd2eMOXOoJlL/3aTkuS30fa3k28EYRkK9WCXy1alN2TJoJUXfGL1WyMVkRCvQF5+o/FRy9/xdhsY9Di0NkKWpYTq217dPC7F+lkbUTrzkx8Vx+13NLNvdP2PtCZcOqbluJHilkV81VGpPG+7VDchtBDvqwE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a migrate entry from a given struct page, that page is first
converted to its pfn, before passing the pfn to migrate_pfn().

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new helper:

    - migrate_pfn_from_page()

This helper takes a struct page as parameter instead of a pfn. This will
allow more flexibility for handling the mpfn differently for device
private pages.

Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v2: New to series
v3: No change
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  4 ++--
 include/linux/migrate.h                  |  5 +++++
 lib/test_hmm.c                           | 11 ++++++-----
 mm/migrate_device.c                      |  7 +++----
 7 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e5000bef90f2..67910900af7b 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -784,7 +784,7 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma,
 		}
 	}
 
-	*mig.dst = migrate_pfn(page_to_pfn(dpage));
+	*mig.dst = migrate_pfn_from_page(dpage);
 	migrate_vma_pages(&mig);
 out_finalize:
 	migrate_vma_finalize(&mig);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 7a8990b30fa0..1f03cf7342a5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -652,7 +652,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 		pr_debug_ratelimited("dma mapping dst to 0x%llx, pfn 0x%lx\n",
 				     dst[i] >> PAGE_SHIFT, page_to_pfn(dpage));
 
-		migrate->dst[i] = migrate_pfn(page_to_pfn(dpage));
+		migrate->dst[i] = migrate_pfn_from_page(dpage);
 		j++;
 	}
 
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 03ee39a761a4..526105aa4b05 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -742,7 +742,7 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 			goto free_pages;
 
 		page = folio_page(folio, 0);
-		mpfn[i] = migrate_pfn(page_to_pfn(page));
+		mpfn[i] = migrate_pfn_from_page(page);
 
 next:
 		if (page)
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 58071652679d..a7edcdca9701 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -249,7 +249,7 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 		goto done;
 	}
 
-	args.dst[0] = migrate_pfn(page_to_pfn(dpage));
+	args.dst[0] = migrate_pfn_from_page(dpage);
 	if (order)
 		args.dst[0] |= MIGRATE_PFN_COMPOUND;
 	dfolio = page_folio(dpage);
@@ -766,7 +766,7 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 		((paddr >> PAGE_SHIFT) << NVIF_VMM_PFNMAP_V0_ADDR_SHIFT);
 	if (src & MIGRATE_PFN_WRITE)
 		*pfn |= NVIF_VMM_PFNMAP_V0_W;
-	mpfn = migrate_pfn(page_to_pfn(dpage));
+	mpfn = migrate_pfn_from_page(dpage);
 	if (folio_order(page_folio(dpage)))
 		mpfn |= MIGRATE_PFN_COMPOUND;
 	return mpfn;
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..d269ec1400be 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -140,6 +140,11 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
+static inline unsigned long migrate_pfn_from_page(struct page *page)
+{
+	return migrate_pfn(page_to_pfn(page));
+}
+
 enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8af169d3873a..7e5248404d00 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -727,7 +727,8 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 				rpage = BACKING_PAGE(dpage);
 				rpage->zone_device_data = dmirror;
 
-				*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+				*dst = migrate_pfn_from_page(dpage) |
+				       write;
 				src_page = pfn_to_page(spfn + i);
 
 				if (spage)
@@ -754,7 +755,7 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
 			 page_to_pfn(spage), page_to_pfn(dpage));
 
-		*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+		*dst = migrate_pfn_from_page(dpage) | write;
 
 		if (is_large) {
 			int i;
@@ -989,7 +990,7 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 
 		if (dpage) {
 			lock_page(dpage);
-			*dst |= migrate_pfn(page_to_pfn(dpage));
+			*dst |= migrate_pfn_from_page(dpage);
 		}
 
 		for (i = 0; i < (1 << order); i++) {
@@ -1000,7 +1001,7 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
 				lock_page(dpage);
-				dst[i] = migrate_pfn(page_to_pfn(dpage));
+				dst[i] = migrate_pfn_from_page(dpage);
 				dst_page = pfn_to_page(page_to_pfn(dpage));
 				dpage = NULL; /* For the next iteration */
 			} else {
@@ -1412,7 +1413,7 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 
 		/* TODO Support splitting here */
 		lock_page(dpage);
-		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		dst_pfns[i] = migrate_pfn_from_page(dpage);
 		if (src_pfns[i] & MIGRATE_PFN_WRITE)
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
 		if (order)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..1a2067f830da 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -207,9 +207,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 			.vma = walk->vma,
 		};
 
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
+		migrate->src[migrate->npages] = migrate_pfn_from_page(folio_page(folio, 0))
+						| write
 						| MIGRATE_PFN_MIGRATE
 						| MIGRATE_PFN_COMPOUND;
 		migrate->dst[migrate->npages++] = 0;
@@ -328,7 +327,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				goto again;
 			}
 
-			mpfn = migrate_pfn(page_to_pfn(page)) |
+			mpfn = migrate_pfn_from_page(page) |
 					MIGRATE_PFN_MIGRATE;
 			if (softleaf_is_device_private_write(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
-- 
2.34.1


