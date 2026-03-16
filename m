Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB76FD58B09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F05E6B0105; Sun, 15 Mar 2026 23:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A776B0107; Sun, 15 Mar 2026 23:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172F56B0108; Sun, 15 Mar 2026 23:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 052646B0105
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:48:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9933613C0BE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:48:40 +0000 (UTC)
X-FDA: 84550544400.17.80EE196
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A1E0180004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:48:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nu6W2PDk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l5Tjzxf2;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773632917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ar1cSMZ+tm/YSuJkC4KhGSzYvrVy3RDPc+8p+nTXFlo=;
	b=5D73+R+pKPeOEq4qvRz6O7OfKGjFmGXuOLc1c7trcrNExvMqdKhxurwQMHyUUCFkEv535r
	Gcd9RJlgo8ikUAC9uct5eucZFIsM7Di8juwmyM5Ul4VL3kmiwNEHfsUV3ZKCXjnX3DfZ32
	RwMa7soZr7BfOfIx6DkaI6rK3agxLIQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nu6W2PDk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l5Tjzxf2;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773632917; a=rsa-sha256;
	cv=pass;
	b=v3cWB+whIq1G1seAFaD2fTd2nv6Mg9v5/nEXVe0Z/e0utN26BWXcCncbhlf8sJyKXh04um
	VX8cDGH3BoHfp7984oRylX7Jl007Gw7k1pzG9hv1dXEmwkcZmJXhz0+Q5A1wxAT9npA6NP
	U5eQn6GfZtp2TraycTZrT/cTO/cFOoM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0AMmx1864782;
	Mon, 16 Mar 2026 03:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ar1cSMZ+tm/YSuJkC4
	KhGSzYvrVy3RDPc+8p+nTXFlo=; b=Nu6W2PDkHnBTbB4OvkjAYjdEVhXR7/UmZb
	wTpDAMw87JeY9yvOA8pIAaXg0UWjdarxIpkKTOqHE6pPVe67d2yOBQVx37R0v6MQ
	KCZ9DoVRFqPi1TW7ccoBaRd7kGvGvdNI3JBO+SflFwaWMRGxmjGFUpqGHoqZ1poI
	Hc5etULUcahxkJ+/BYyYGSal5YxVTR5iZ/OdzjOsH5Pz/xKp6yBBotfuvRuo4Y8z
	HPd2C4+r0wiMKgFpYsARmZFCpkDGakVhGm0ZPVbdabRXFz/GflIF4j4cYwcR6zpk
	rehlRDiYAzJ6VQPLq5gaJml11XfzSN0F1oLw0LquQHIkyRYqL2Hw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf41ef3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 03:48:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G2PVNB021886;
	Mon, 16 Mar 2026 03:48:31 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4kb7eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 03:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDrAFvcwM4AZ9R7iIrYNrziX8/G4B6jaCcO9aZmcOv/T8oi9kKQhD+/dGTaKSX9ksB+Z/z6+6Gp44dphaktB+TC/qiC3HIdrsaehbyk9HNBwpl98yvk8grtUG6vVhBBF1GOB6+3peHa5AcKLLtr9pNBM4BI6LUWasSLcGEgrk82fwodXneByZ4TVSrp3XwgxEsPNVP46jwZ5Rv04ezaokb31YXxs19tz4MIu5JJSjJkw9x4C6OE4DmDPbAPA1GZcPaf32frKiClUwKmgwh/WHvlik7OSnd64qJb1fr7X9lm2yZYAwFRJ/Hue8GZ+pPaLKbEKTF1fAXJVdPJNOqLuQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ar1cSMZ+tm/YSuJkC4KhGSzYvrVy3RDPc+8p+nTXFlo=;
 b=G6q28Pn4ALZzzCnO3b+yS5T5kpwHV9ob1zKnlFWYHYnRU3gmQtOa72WeinCLNwZcIpjLdymOOm0/qXs8wReLU3MNTXBG57CoeXAfaQYNSck2lQAVpBghUdSDlkWg3/OP9YeVsf/2hjPu3b5R+i7fyduMCJiWxHUPpVrSYFRXxLP6JuSoO19tXyQB99SexNT0IvT58XLaGbntQjcxC66+7i/d/qJ7km0AKWfwgnNtc6bt1z1+56Lg8ngGphEcmLAUxz03LzVv0w61omyeiqVHMo6NqY8Tz0E4NCC6KOO6dedQVePoNwJ0Qgj9TPDCUeENPtsbNftck5scZHq0mFLeJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ar1cSMZ+tm/YSuJkC4KhGSzYvrVy3RDPc+8p+nTXFlo=;
 b=l5Tjzxf21UaM6VUlhRiAoSEe3JX6e70TbTBAqKf8M2oDvoiKbVMYbi/G4b02oxFnlYC604bZL3yuXYi8BwAzWpKLNuUPVCwpqvIPRlbgPj7GoZ9dx+sqE6sLc+KLqaqCTd8ECezRuqoTM7vtu6QTD6hvF1mLKPAClRsglkr5LG0=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 SJ2PR10MB7736.namprd10.prod.outlook.com (2603:10b6:a03:574::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.24; Mon, 16 Mar 2026 03:48:29 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 03:48:29 +0000
Date: Mon, 16 Mar 2026 12:48:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slab: free remote objects to sheaves on memoryless
 nodes
Message-ID: <abd9hGqWUZ5WIELG@hyeyoo>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-3-70ab850be4ce@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-3-70ab850be4ce@kernel.org>
X-ClientProxiedBy: SE2P216CA0079.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::12) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|SJ2PR10MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 703ff9ca-d556-46f1-9505-08de830ee2a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	LcUYh+vOMV1OGsDkG8PLvcZHIcVyfMdFPqQKYaQR7MSguzNDPn27otSRPVNhh2t8ZJCGe2+tK6Qx/JkMqeizAIYuHuND4V0iCE/nBxuBxCx4ISv6v8lWV3tUIseZbB4Xuv1OYufnc1Usq3hegSEVj4gtDzZlqGeU+91J0mKzb/2UFVLF7XQwuBWnaswt6/1W1/P8xshdiKPv39+VOtidZVeLjyr1Uc3c8LsjO2ltgCD6m/48l0OrBugHUhzZaNBokGOD1BDcInk5EG2jYtc9H4H+JwadeBQhsJXnaoiQpS9qjVLkmOtHzLmmdxurgMJBJzTFo7wddJM6HG9V5meA3zsplQeHdwaojIAXd/nECyGXqyHSLMIR+xwy5EyWrnEsqo0DLHHovHdD3+jJbVVWw6jQIqTSD17bVQLE2VxRGaXRf/paI8a8qVimKFjYYhexwaTnq7K1gUwrJVBHNPDe7CwTw6mvNo4irG6LMYJO7Euc1SsnDwvHsFisDiOlsMTIRLP+TgxVSjTUQfnveqD/9ZXPfgm9VSSqkIRHNALc7qSYFN81DAV/YrIXFubzRyI5t/YIswZ4PedUtbIhZ6hlerqhBXBqKQM4kY9/5/i3D3QG373I4G3VhGuZQrCCxL7NWNNbqbgZlTBTx/t186sLxqPN5tKPmzyoDoQ5r7pNKZmBsHCW722G1pO0+v5e+6j29h/Deddc5NVHSITO7eNuwXKLXHDXztLMQ9ihi5sBFxM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l504PLrUOv23IS7ZfRGdzQygohwfKFX/XBP5DDSo4dGQYAtdaYqVHObF1X4Q?=
 =?us-ascii?Q?kF3BfCOwDA7XwUMR+55olbL250yHy6yPr8IxTGOcqgkcSNv8jJMowUmSlekR?=
 =?us-ascii?Q?D1Ge8ISMwqiFJ7zflZkgAPm2czrgZst/OagCDrWu+0mx9UQ8WFFcTWevW3Vq?=
 =?us-ascii?Q?E6DHXq146AJnWRatqC2gK/9r4PXRrv7hHOj8ZshGnYT/u3wa6vVQafV7jdnX?=
 =?us-ascii?Q?i9NBn3DMTFMgTkkFGQZf/eIoXP2oTTxX5wA+H4AtqrqGs5r1UlnssFG+jST9?=
 =?us-ascii?Q?Zblr2qj/PYfPm59gCDF4X8MYx5ZQRPXoLFM40eM41D2IKhQ33QrJpAkIhCdP?=
 =?us-ascii?Q?JAwgMdGGy4uRk+vhPs0HhCcer7S/faFPNQftn+5xLL393vO7TNd9ARVoJ/mI?=
 =?us-ascii?Q?cdOXhr8b7llm/YRIsGbz2iOKOoJ2FddceatBvob96dHn7ll7//MMhuxFnUCx?=
 =?us-ascii?Q?x+x3H4VLqEWZdXtsXgncfzWY6tkZe1+SMtb/MzUkeaEH5Juck6lTQiFXWNs2?=
 =?us-ascii?Q?DxhdCY8J8G8LvT1iSpbWDxsZProtUZL7vwe6nvecDHX4/fgw8aQ+ZPJkmiV/?=
 =?us-ascii?Q?GbtK8lyLepHGxWo3OJXk7W8x4zvWjmE4Q1OZNu8QtKxFb4GCZ20ZewCByJ6e?=
 =?us-ascii?Q?l+j/pc/gly42WUcUsXePfZo0orDtwdURVlz3W0kMtnaileKm/2dkKbXImNW2?=
 =?us-ascii?Q?kxI3FXjliX1e80hpdoU9p7Qw+HyTxvy26ccgWrzGKDd3liuTzc+7lGdDfMmh?=
 =?us-ascii?Q?bGjoybLAhh97F+NU6/SKrF4zY5DuE2SE/5FmXtEK3LftHTqdQ9yJ4im3bDvz?=
 =?us-ascii?Q?efoIU0vn1DxgcL6ir03nedPIGGTE7H+GzU/g8nI24vgtRWfZnqRcgBP5KmcK?=
 =?us-ascii?Q?YG6cM/70cQD33favvkxsXOzBEGFmXsviGdD1h+pM5+kXIOnie+ucZ5cFASqV?=
 =?us-ascii?Q?Lf1dOzN+2GtOTkDTNL4AoPTDZ/+HytiPfbTE6MIkYY9FcKlBssEerSf/O3MY?=
 =?us-ascii?Q?qSaZUAlnfFv9oSBCK7yejeazacZcxVuYAtt809CXptZFtsLE0wTmkpUbJUAU?=
 =?us-ascii?Q?XdV45DcjN6MzeJs527kwzB0WmzWZ7hTmESNJpo2OxNLBJL+h5K3jKa6FYWXu?=
 =?us-ascii?Q?pdevoJ5tYhoPHiCxJwF6JVAVVl4iaDwHPR2n5tIxkQyFIKT3x+T/b7fv5PB2?=
 =?us-ascii?Q?CqZHfGTSzv+BjKx17ejASSfD3YN/Ay5mKylFZRNjYlwU6Jz0ozPoxRcw7UPK?=
 =?us-ascii?Q?dmjbe/uCu4y/3O5EZ3cX1+WbiNAJqlG+KhzL9p2lxvrKRnjUDuN19a/DyUm4?=
 =?us-ascii?Q?Sw5mZ4u5Kv4T+hxpO8SfRfx4pB+fD5f9rYulrvkdz6tyY8V35VJLsAkyAM8L?=
 =?us-ascii?Q?eHWSiL14YK4IdA7Zq+jCfF7pUUc52dQA75ehRyTPKx0eQJ+Ni3ZBCrFTxbis?=
 =?us-ascii?Q?zQf+zww6tlp1oRh7QLosQMFYX74R4LPAUClKV8Y3mVB9FROA1ZxqDC4Jq1b7?=
 =?us-ascii?Q?F0vtufkqSscFEo0vIIg8uOphfFZ43PUvbPU6lsbdpkzYOYFbH7ORP3XEp/oW?=
 =?us-ascii?Q?erAnDtGCCMJnf0cqqw+5RuTgUc96VENnNvnJf2nToyyZvBmYpvG9h/YxZsQ4?=
 =?us-ascii?Q?/O788jQGUJ/lrH26MrJBvBIHalwdTsHfdDfl9dIN0w9BMDxKEklY4FG1n5Cp?=
 =?us-ascii?Q?PesG0OH3VXjWPpRzOM40hxAzmeP4QKCZgW27MRKNAe8aNg2hf1Pu+UBmtLCg?=
 =?us-ascii?Q?QDLxmwkDuw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Di3p8LwmORFs3x2y118e+b2AMSeQGDsxpInDf5ZTXlGiHgEgQUqjp8ydydERdYbJTqTc4wmU7s/KiDJwIY35NZGb4yZJfaEMx2x2q10U9jLKw4jR34nrn08g5WafO+TuId9xvvlkhTaWyk6MroB17jksTuYwWr5KYzkoPA8kY8w1gGtBh8ou1XZ51IWfdvPMhPk6ePZrz38ONJcRQEsyvRqOaWyxpqXgJBUfxQmPJZnCKN3WoyW5CLaTsGVXEn+eF7LsUKmnm/Rm6KiXgp451Ux/JlstX++sRYx3UMcqHs5Zb9gSpSllujZ9yKXbd6FEZNQZCTX2FCsjVe4dI4Wtkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PORgT3OFYtz57DmBvSI3Dr/AOkdqOBTzrfdIgWaKcUcssGwjGcR6ZzBKjdaidxT3wqZolbrzjm8CgMLPygzibT4O2eT9ctGHeHePq38jnTSKnHZRYYPZBBpJwl0caCZOej92yzeJSaApNwlpfXPzNiBlt/i+EMG0x9D7kSj33fUcN1KD1AxBqvI1aR4PvGkyX8B9YMef51sWSuvRPkSnbDzg8ptwxOrYYHEd2QffVyNVceqmV+RhDyPlUHbtqEDCJwca5dr6pk1VylmP0Y4GXtwPu9JguCTRL9yad02F3+HOr8I12jyjgW0EMeTuhEtmBV4BgiFsSdauODGdTe5CACmy+Pm9/rlZ95auRpt1tRFBsBYHxhwrHylJ5qf3hmaAMsfOSXAP824OMzVfkZRmI15oAwIYDWb2AT8QgkSpj652Lql+opYurhlLRPG+ZwyohybmmgWeNyxKf1MDl8OzYpo6ZCgjRI75902GiESuYE0RwvoffLcgwLAU8Pdruv2GudqlwamE5DjdvbOBQJTVuDcIc0GAZWkOImnLmZkLgRwKfhSC19lySdbG2xKLeOTR6ZW+gYzCKq374PN4EisfPAD+dApdmmw0GLFssjicoO4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703ff9ca-d556-46f1-9505-08de830ee2a1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 03:48:28.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulzzTMdjhUotPg6vV7tmKvkK6QQRJCJ5MA+9TO/j0uDFNHw637j6L/6YJj9KHL5VktK6fQv6EgmutnnJ+LrdbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=504 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603160026
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69b77d90 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=usiX45OKwP_ow8_JWysA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13824
X-Proofpoint-GUID: J0QtB1K-KRjhIAcs7ZzAN937v8sGgFFN
X-Proofpoint-ORIG-GUID: J0QtB1K-KRjhIAcs7ZzAN937v8sGgFFN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAyNiBTYWx0ZWRfXx5w0pQQ3CiFB
 3i/fmxE2XtGbYhCVd3jhLBGQ+u/JEYL+7+eKah9r/MLkHe7Q79IMEKULZaC6JHjAYy1j9qkNFhQ
 k1cnErcHwEGJeWpgqzlYIdTJR/I5yJv8lTHKSxumNwYtrfjVJQMJYRY4yjEZ3b7zpOLdBMdDUUR
 1PE260eKOamdr+d4OQi7kR82mom8LzYF97w147jum++ukp9l3fZArsr1krgtbicG62J1u+PMdeI
 Pfia83fvoFi6fNS8/pLdr0Y6vAnFYhMD1IOBWz0/6rzDdHujU1rM7wFht9hzI/2xXBfTbCUP1yM
 hcDoqm2IdU/DNEwC530jRHoopBRVpd6MI5hMZgY9pecJXVlwfGhJg5sexUIvJgs7ezHise+BR/R
 uteU7/o7rat43h7ZCQkNX8rguuuw+1Us1i5S83i4N4BfdBpg5dMI21LcP18s9FQHo+qDH43SIuf
 u1Cx8KngiIFjBCI3ZEnXefmhEYJ6CmAZt1jKCk3k=
X-Rspamd-Queue-Id: 2A1E0180004
X-Stat-Signature: 6fijoe6ific5nzetjtnbu6f3rzjo4erk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773632917-106154
X-HE-Meta: U2FsdGVkX19DEGy0FzHEjT5nvfbBmZbolkO17FjLwpRQGWw05jsv9XQGkWICPtSd1pO5z1fz5+nb1GQqX+ZjC0gSvrtIIMrQ2sjJG00Hij/m45MxkYSV1LcQf9nWrddXXMr98nbVND6SKBv1r17+OkkOw3U3lXsy5cdu7gav5hz9aKu+p//hmc4v5+lLMcFxQu0h53M7t35AIwwfiFoyd4zerfr/Ei/mCibA2cToy9ryixx4BxZZZrD0k4yBJpPb7L8Ymd/8UxCqq9Xon75Iy95TBjFuH0T0l/SZl1tJhwNFcBIc/Gt35UsXH4LqAginzY58AzXGhrtPJK5JcVInbwLpmvQMtquc2atxqyzoUDrMOaO1YKR3lkzYJRcnSaVBrUSzE8AraJTj1rTYuojxpo2VLRIgDIBFOVlwYVX9xAh7oCUQ7/9UQKXpnWuOkwSY2Po8xA4VAOUuW+aXaGVH1HgAuJG7JLlKkt1AKn1+on/EF6jvzBKilS2mVNcmg3G9YHXBVwmLL5xgPk1BzoMHHAaTsXlqttd4Bc1ereaz/xC8gv51U4zpM2uqMlT58YS4R5ZE1aRNLKfwLemJ39AgYI7HUelUts2fwvjdb+5q/NBk97whyu4iJ2TV5VNNjdmBA1X6ZvKQgTPE0SU5yTCumOM3aW/6LVeZ5BDYXzG5uvoztZYyu8FIHjKkyH4Aj90Aa0G1YsTRxvFsDJdfm4Wm5loBojhYrenV2KSdgeN2MilA1DC8oz3KJOUewMypuNSlP5N/gGEiApjrj3fsHTWU1DrLwN6enSwM57OmrP3gMBo7xnzOhGXcvo5eH0E2ZphCo+JSfrKic3hKmPWVtmK8h9YXEhHhlim70J3/C/SnCOavz/Ua1mEucpbyoMv1rATlwhs2pWxIePJxVBJw4d3O/PrqF0DJ1dA5mPwDANfSueRIUM02Q5FlR9mQRX/cpZyNSy1DD49jHG10Rjf3YXI
 94iRBfN7
 QeadTCcJXB3JS8ncQPI6+sgccyQLde3reNANc2il7E7jGvXGBH4pPaForF5cvB9IUjXo5IcfLuhuaC8+9E9KjmJJDf4M5WSLyTWfbK2I/jc21HWuO4a8t0Kc8FySeY+v7qzBtm7CnQjZcMvfpC7vkjUyY1ypNrFX6R+Oe8jM3NJxF975WwAbHqgEnmsXHNsu1y16V26ebukYLvsj1HbLQ+ZyeB63/ysWHTEPWiTwfYAkPYe1dle8zZL92QheKfuzuqTXfFgxNaznsUhrl7JgKQuJSccsD2liYjI61YNvGclU7DsMF8JhJsi2fVx7tnqMNTS8Reb+oWpHjrdy+VxTtBG7pOKx+3TbkQigKbCF/jNqa8NAg7C0hziQQcSrEPkZ/7Ks2QKhtjNs0ap1DaGdo3T3o6akZR4RbVK3Tv4rMOOeCmPrKwFWhcMv7Zfs1DQeMkWcXw5pJOAOcp1XYgTPE9/kwe5w6SMw7gIeAQEtSWk/gxliEmqoPZ+7EEf0tq+mwx5g+P+eAuy/LGKqPX6H9MJa3auTxjmbwfybpr8X23/js+5QsJn7FkANtJOWiMDMbqmrWTGA2yfKF9rYlvYzhFahguKbUoAO5WBV9fBFl9+fKY7Qkdmj1fIb0ijlFXzAH/G8a3hELAHdIpXRdv71gQiEd8acUpsbBLmVSK7Ia2OgI+Q8GnYvaJG62sLLwJ98jZVdi7wYiOkxuoFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:25:57AM +0100, Vlastimil Babka (SUSE) wrote:
> On memoryless nodes we can now allocate from cpu sheaves and refill them
> normally. But when a node is memoryless on a system without actual
> CONFIG_HAVE_MEMORYLESS_NODES support, freeing always uses the slowpath
> because all objects appear as remote. We could instead benefit from the
> freeing fastpath, because the allocations can't obtain local objects
> anyway if the node is memoryless.
> 
> Thus adapt the locality check when freeing, and move them to an inline
> function can_free_to_pcs() for a single shared implementation.
> 
> On configurations with CONFIG_HAVE_MEMORYLESS_NODES=y continue using
> numa_mem_id() so the percpu sheaves and barn on a memoryless node will
> contain mostly objects from the closest memory node (returned by
> numa_mem_id()). No change is thus intended for such configuration.
> 
> On systems with CONFIG_HAVE_MEMORYLESS_NODES=n use numa_node_id() (the
> cpu's node) since numa_mem_id() just aliases it anyway. But if we are
> freeing on a memoryless node, allow the freeing to use percpu sheaves
> for objects from any node, since they are all remote anyway.
> 
> This way we avoid the slowpath and get more performant freeing.

> The potential downside is that allocations will obtain objects with a larger
> average distance. If we kept bypassing the sheaves on freeing, a refill
> of sheaves from slabs would tend to get closer objects thanks to the
> ordering of the zonelist.

When I think about ways to avoid this, the right solution is to
implement HAVE_MEMORYLESS_NODES :)

> Architectures that allow de-facto memoryless
> nodes without proper CONFIG_HAVE_MEMORYLESS_NODES support should perhaps
> consider adding such support.

Exactly!

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

