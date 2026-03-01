Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FE9FD0062
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 19:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310B46B00B8; Sun,  1 Mar 2026 14:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4946B00B9; Sun,  1 Mar 2026 14:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168896B00BA; Sun,  1 Mar 2026 14:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 028C06B00B8
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 14:20:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AC3D13B94D
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:20:47 +0000 (UTC)
X-FDA: 84498461334.20.E6CED85
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	by imf21.hostedemail.com (Postfix) with ESMTP id C24281C0002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:20:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AN8AX7n+;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772392844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzGoQjjVuLVg07DDqg0OC2yQOJfh5JTfWXg0SNoeWUs=;
	b=OVJGmaqmosj+hKzng4C1K7Ax6n2D4aQ5YeuHTmAGSS4xVsagaAS0fqeKG95nc50MqZkyRR
	92KP6ogSTMsn5nQAqh5zS5ko3EZ3u24ZyR1lEahr6+j+hA9rpcYlbuCpL7bFz84VsdEzOr
	CXy4vu4Zja9POSgkoMVRSg4KIgU+9gM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772392844; a=rsa-sha256;
	cv=pass;
	b=WnfE6/JmicoesDOUElCjf19wsL6UDK3R81/9wIWzXwRJMdDhZJdYXw0P/GbjZ2LM1Kr1ni
	jxOa+nV9T4Fl/+Ev9VDpZnOEx2NytSasRasGn+iwRnYPIiLLL+5Zx80bIT8w3PUqXDDJgu
	ZyEKTOeo65MyD3v/ZKkvtu8GvAXhqIU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AN8AX7n+;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IbpLKb1MnNi4ENWJK92O7bqs6uK/EFsWDEg+T5sSUilABwdabYdTSf7NUB6RaFv5sKZRtoaW42VXcAoTIwlK1n5cdN8g4Cez5cT2IhAyRtpVzeogh0SClIH14uoOQnpJI+6KNgTRa3mwDtZ/gGta0nB8RgftsMuFnkwbmV8FhphqXhixk5NvT+/1vvhrrdNa5kiwAjydg3h7TpQoQdRsVKueCS3ySVuA46J4RdAeBP0WpCQUv7oeNoCe2HlsQHnhl+Sr/+0zpzNfX2iWHsmJz1/yGHwafALCtoqr5JmlzvDBjU7TGupGp2A1IepSsMnUzjLPyz7X2hAstL26LXb3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzGoQjjVuLVg07DDqg0OC2yQOJfh5JTfWXg0SNoeWUs=;
 b=BDJwL+FQil7uqsV/L8anCoh8GXwBA6cNZaye3yMDp8o13nKdwj4XQfcBWgiL2uS4efpiOEi8A8HW+ghNCs5/xyCXV7CfFO99GwhWSjfGQAaJmCJh6o4ewAFxlb2YnasBdzd+5PoZlAD1POJZNixMY2XBEYxQ47hvzN0lp/mUI5JxsXtlv7po/Xq+kaEwGbvYpXPhD/dRMXsOBsP8qFWyrNaRGz2gDrptFQjojsozBH17auU5BVNBG9STPfe1LZ6zwwbACB2jJ50KUOo3j0cCR41PHKngo4sIEq8faieYTS2qs7ijadPeIQmB2WAIiiMkTsbqFdcoG4jffUv2HG2CNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzGoQjjVuLVg07DDqg0OC2yQOJfh5JTfWXg0SNoeWUs=;
 b=AN8AX7n+GCGiXHLFBypRfEdBPXuOaNNm5t1vF7xDUdoXp6o9MgO31fdausmjUQP6ABTTnzM6Y7S6TMR1hE5mTLhRIBCj51HwNOnPgy4bwM+VvOOTvqvaAwfe0WCB3ND+V0vpb372t6bw4HzcfQqT1mcydbCuNXQY2NbYaFfeK4DWP44+lZ6Tr+zeKTJrQq3sehjH1vCrojDLw5y2/NGv7QaNCGtgsPERURL1H6+72BCpCSiXZcUlIWemoBBpk9zfvm3qJ1K1u+6v4VSqM+a0wbNEnngyCNi132XynlD25HXIu9uRibQMiErLHnlQXYKOv4v/wkhdr/rkO1AxI7Kgiw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Sun, 1 Mar
 2026 19:20:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:20:36 +0000
Date: Sun, 1 Mar 2026 15:20:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260301192035.GP5933@nvidia.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com>
 <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org>
 <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
 <20260227152330.1b2b0ebb@shazbot.org>
 <CALzav=fq-3J4WFD-uNd5zJ_Fx2sHGv0vL+EtpV7WvGO8ddG5mw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fq-3J4WFD-uNd5zJ_Fx2sHGv0vL+EtpV7WvGO8ddG5mw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0299.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: f6dc39bf-57f8-4d90-3def-08de77c79d8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	scI7q79XCmKUUG2WYnVtpr22CHDv3B4Pc8pEKjpTbLlPBRwAsadB4MeGLrISUczKlArtMtp+ABhRabS+12uIbfIXVGWk4LNl05OBVLHG11WsN9KACcQqL1EBpUYyvuwUo7fGNmGVjrpyYxVvOPp88fW1aBaLNlp7lXHdcRT0DRsNxwG5L/cQU/3siRWspItMBUU3xPHYHCtEioDDjpgSnhtzKfp4Lb2Qtn+4VutvLoyqDuT2HdmeHsKqZGhVqDQo0QxjeVcqY/5lgSH15wa04zdB3Dy7PpYterLcVo42XDv/YjDgVfS0W9Rw5FkSzfv547YHGUPc3tFPyMcly/zz/6xunrJ6WPwh4QIO/EA4Of9/mzf3TCIrHDHMnQofv4+AiHMO1DAIDkHHbtOQ3fNEJ5YP/6cXQnkrpCNt/DOddANlyl9iIT1xBKOIbU6AjxQ+x2y2efbVbQxvEk2w4ZaWCWOtmNi9jo5vKhqiyOEB6FgFxqw1Vuo1wo4LH8LQTg1VuWDhqkrhly93EAqcnWrm2niicesjI08WND/8nuMhgwRmkeIdI/fgTvx4XNLcrnEV2gC07tM/iUrpSShE4DOxypQ9IAQdzuzRdlu55lgAEZBr8kcYccdwVcooAsfpB2kcwICGuOG1bzziDO7N+/yA8uyTwJltgjNWbLtOKivnPrCFc5XPjIMl3MSEJS4NE0Jao0mbZKISHZ8e3VEm+EJzfvPKoP4HMqTZ3nHOXsnDBAg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G8AnPmQBrmYrmxJMEjVWkFLMHIVhvsztFAYrj1UoeptiuQQ8kN9UWKndBGr1?=
 =?us-ascii?Q?Q9Bij7WZhpB8tqSS0K1JceVuqC587q1GUBLn4rUd5eGU7cIwFVM5HivxjrZP?=
 =?us-ascii?Q?s50egfNXbRJSmy7kXP6TVk92AkAt9x80yXpwxZgVn1xW8XH1PZWgwAasbn6b?=
 =?us-ascii?Q?bCNTSV53uk1bFMZiiCc0y5wbKjhgaWqZ1eb2lHAUZx+cNH/jSqROqMlac1a3?=
 =?us-ascii?Q?A5DDblL5KF+F9stL+XCB0Yu0J0uqv8IorfakNqbz/MvNV1TKOTPs5W4y6JJR?=
 =?us-ascii?Q?3M2HVz7hGDw+RKmz3B6FP9ltR0u8YImEDLk68k8fMSF5A4kZkhU0EvLuXR1X?=
 =?us-ascii?Q?pv1Pi79/X0wyDICeyXZsqahif0l/BnHJp8dIaMzBaTuhfi9DDXywJ0H6+QA1?=
 =?us-ascii?Q?qbCp/jrSYKiCT1eO8gqIXgqW2lI5Tefz0JcA0S8Z+FDMxZDQbpFFsbxMoD2V?=
 =?us-ascii?Q?VMOzqzm7AtG8yqeWjnil+pjyOoSL1r/nx93PUQIgBRN84S7sOsY5m6f3oTqy?=
 =?us-ascii?Q?pQuZ6j90CWL3NpwDF+d9QwsKcXsCXHKwsDVUC4gomAj1qf4/pOwnmEhCjDsT?=
 =?us-ascii?Q?QbRpDC7B7SyPUBDkHiwmOIwIkNpSuiFydBW5px3U7FuyU0345DfhNZUJF0IU?=
 =?us-ascii?Q?Cxtq++xKZjSfNFvvNSKqm3WHFiReVtlQILrjvovUfMl63X2v9N5/sRCBhOhE?=
 =?us-ascii?Q?031FqtyGEWI3fi/vjaqL+MG5z5q3UwfdDrX5pcHbjqhq40KXeixRHwdrYHmr?=
 =?us-ascii?Q?jY7ug9m7hig1LMAqH736AAIbM+8e+zYx0aPcxKP2cEbrwF489TXidmRG9b5U?=
 =?us-ascii?Q?R50fYTr4qgkhcq8lLvVzQVd1IGTvMI5hhIhQwVYeSGy03CBZ8KvW6stzWGU6?=
 =?us-ascii?Q?3CYRw3lxe1SUBPNGk/AUqNJzXnjjDc1aps+y9SvmZqW7b9Cb/3XJv/T5brQR?=
 =?us-ascii?Q?kXX2gid/vmIXHnX+SXhmTzSBBSfc1ivYhwWKaMJpRme2oZ9xL8SizWalY01E?=
 =?us-ascii?Q?sVFHWiCa8LCVoTpa1fl25j1IjitbO+ByfxiCIcQuID9Dn67G5++fGML/BD0J?=
 =?us-ascii?Q?n+YwMOiy/EUzU/oUuPMjoLhU2XSj67tprEx8hfwFrT72M2Evm6+giBvI+S3H?=
 =?us-ascii?Q?0AlRtWvcMGjyo07eVYfWy9Kg8wT4Yiauuw48m/me6Hw0pwffm75lDm8rtGNO?=
 =?us-ascii?Q?ebqhVa7HnUI8dqOSFHe25l0zWK2/bQmPVP5UMEoPHhNVASJYH3lZDEP8p2Co?=
 =?us-ascii?Q?sS+SfW0NmOi55JeCyLLZZuOD0HEq+0kWiJ12W1E1LFFFZOIu+8fZBwjNlbIV?=
 =?us-ascii?Q?w8dG2i2Z1Bn6hJCccSJ31p4E9ZwfVTvCD3orOgJeSdkSn0ppaWZIzJBoORqK?=
 =?us-ascii?Q?ExHsnY+a6Rw4MyOEyoGPN210sjxEuo8PUFkbD886BlZqhuBQuA0KiWPIZnsC?=
 =?us-ascii?Q?9dupOhFUK9YqPypecLoiPS9jC3mawQHZfWSVFgqCiNg+siY15RhwaXJj3r0R?=
 =?us-ascii?Q?vL4OskOuvGk8Owq9yUwy45c0+e2lsb3M2H0AHfBMzcd8fj5MDitweO0we7VQ?=
 =?us-ascii?Q?zsr+AEy6+INzhNbxm06ngzLxC1AvrxuUUkxl+Kio4TfRHcDzyp5ReJSVenEb?=
 =?us-ascii?Q?eEInuigs2drNrnGva46lspWSx3FDbMOb3l0OpZsnkptk8+BAUpbUz52/mPI9?=
 =?us-ascii?Q?Wy9kDJ9o94bTdU8Fprd+Bc8XzqHmdTS2Zj4W0pX42YYRs9F4pw+rXqdQ5KR/?=
 =?us-ascii?Q?cYAcKHhzkA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6dc39bf-57f8-4d90-3def-08de77c79d8c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:20:36.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09t5yMlKlWxicNXNiXcB6WNSdQiIoHCJS7ZDHDudkwY0/7Dai+cdOMFvSkGH1WpL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591
X-Stat-Signature: 7ef6tizggx3ajaui3nrpw8uwd7hj1y9x
X-Rspam-User: 
X-Rspamd-Queue-Id: C24281C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772392844-277139
X-HE-Meta: U2FsdGVkX1/USdXv2ncRGZPYAcEJXydP6DTfeM1FAexlbLoVIaCGoU1Nv+U3W4uqJ1tcF1b4YITZW4t3e3MlBPCo857iCe1gqfSv6Jr2rkze6PPsGYfutKW9im2GU030/JmvcksqNlvpdXFacwXkESDrDkmeRKbktmrSvUcM8Pf+WXZrKkIaPe4o0r7tPrBd671FfOKPDpIPSZpqrljyw+Z6YeLR2RuiqVZbT1bin2Jm+xlng+KB0oGiEFgA5KtuzH4DubvLFSuPDoELjNmGvLazPCgkxCD/hTa53Y4kY+9ZCvLOCv+/bqi3sD7fu9SkxybEiCuiIsV7E/JHgbzyF3ED0meqmu4/RSCXJ861RhuicP3msbv5zs4wUbVQQ3UFLgJYyzEtI5/3VVJ0dnqZyltpJFCsPSvHCEIYIUJEYUDYrCThlF7qhqSkVq/KHcxcHIfVNdYdF6NEcLBOM4zH5xUcBHlEqI2OHMhVT6/Ccn0d5nM+2wxwbJRQnN6akn6FPwx1kn/uEPOfqKs2n5QCkLHukB92r4x671sDbiG6TY1qVWaXJY03eJpCAX0ukPaWlH/HcBTBxzZ59tWR/frjkre0/FPb68ZGKKfdLL/YxIclVXFqpMAIlVcey+0QOSlNSYab+rsATg6YNUA6b6GLfqCxPVSr4HJ0rAA3V51vOmKVqQ3v82ljDzWjfyAM/6iiREmFie9JR+QyIpuDvVWChjSYYhxEoYh81uDu94hhd+cdl8gdrj3WRVsPgVAQIQYV84m+RtGP9f0CxaPkrYXfmqtGjABt264ScaUtqY4GnOgjz/OZpX82ZZRjKxNuIbQPrDwBjku34ygUPExOZrwzD1rMcVIxYKUeAFzFUIEHA2t/OoJ4X9Rg2uXdMKtjOvj/pAkxewNN1WEYSr24ia54krxbNm2mEPBm0HNvPslC4AEpnMzi1uYowONYzP18usPnssRFabQKclrKrJmY7qq
 5MOBeX2e
 13cS/E2isHb5VgkPiTU31pAj/JI3ZKlCKc6gxqxXHKZJln0XFXGodiTn3ubku6vRRTH+0O+p10T8Wvb81fBeOBiEk4fuBp1oDv+xzgdx+9g4pKHSwa5MW0259LttueSgNLNqln/v/OTWGNhOwoa2FKsyxURxE56edboX2jEAo287S9rxZI3BcMlc0wvenaRPvuG35y0BfQOB8sklRI50c71xwQa+vJEUMcvnW7phS9rYQuAmWtScxrnrCok9Cr9qH5uIgtYl5yyQMgWJP4rIVHTOKhOzqpmu7YZDi3JFbrKHAPOq+a7qGCDsYWM9BYQaEYj5o5FzTwIe4jayReNfL2trGT/sGgakdpNHF0xAZIbGcSRmxYDney3D5Lnkr2qgWpK5QASaYLw9Y5pq9pKAZxEDpwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 02:35:42PM -0800, David Matlack wrote:
> > Live migration support, it's the primary use case currently where we
> > have vfio-pci variant drivers on VFs communicating with in-kernel PF
> > drivers.  Thanks,
> 
> I see so you're saying if those users wanted Live Update support and
> we didn't do (3), they would have to give up their Live Migration
> support. So that would be additional motivation to do (3).
> 
> Jason, does this change your mind about whether (3) is worth doing, or
> whether it should be prioritized over (2)?

No, not at all. Live migration of VFIO devices has turned into a
valuable but niche feature. This live update is a different niche
feature. I don't see an issue with making them exclusive as the
starting point.

I think people will eventually be interested in having live update as
an option on otherwise live migration capable hypervisors, but that
brings a whole other set of problems that are hard to solve..

> software with minimal impact to the VM. Live Update really shines in
> scenarios where Live Migraiton is untenable, since host upgrades
> require VM terminations. 

Yes, exactly. It is more important to bring a new capability than to
optimize something existing.

Jason

