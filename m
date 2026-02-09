Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00997E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 21:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18EE6B008A; Mon,  9 Feb 2026 16:57:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0606B008C; Mon,  9 Feb 2026 16:57:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8826B0092; Mon,  9 Feb 2026 16:57:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCED36B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:57:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57AE71B1E39
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:57:16 +0000 (UTC)
X-FDA: 84426279672.14.A00BFA3
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F4B780006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:57:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U30VCN3F;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770674233; a=rsa-sha256;
	cv=pass;
	b=8q5CXSfCn/uqD4tSTgF2wKvjDIMxpbFuI3DWUrGFXmD0latqI0ewzr9YMQyn4IrrLpmNoJ
	ChOEFqlCbgqQr0APwnEwe1yRc2FNilPxFIykK6idmB8wiWqOszpAgpNC1bRkhoZMvCrGK8
	MYfND/2N6BdAJwBpRRD+e9t1BnSQrZE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U30VCN3F;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770674233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erAt1BRKgaGGmZYUdjbi4gA072qfwSoug9NAKExGadk=;
	b=z+RfCCXj19E5fQtnriY/pRLBGC7x5AntZNrsDcsAu6uNK7J7y24GdMlR0B8VLw2p2zX6Ns
	wMu3BDd5EoFssHowdBcJxk/kV1VulnMXRXn9ls4CBGA2DnZ3YW9/qFeqgHbfpe2+rtDcg0
	+5/Yw6yXkc3PX1lBniZSIssw1NPunEM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vbq0SrFkn6Se9nTqynIfVgzR+nkWzss5cOfYBoicAFPAJNBYGfNGKdzt4b49wJ/OEjXM2e9unIn9tqHiIin15RR65jqK/hUaUTaq1VihRHrpossCWX4yRSV/4Ea37uipmPU3/FbTBr1fJVK1NeAO9qvKVJh2phhsiNl2rVmJyp8qLV3wGrpV0vPS9Cz2AxlCHVvfVf0G3TDwJByD1cOWjxnTqhswQllN+umsrEKKERW4dLVXBPFvzuFVuGBuoRO/I/lkgC3a2MX6fmxNhtWB4iz0P85mJtdqYkGJ5PcwlMgBg+lNl+UP3mDCOVkCWF4YYzgrNIWIH1GJIUVpG51L4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erAt1BRKgaGGmZYUdjbi4gA072qfwSoug9NAKExGadk=;
 b=BeQ1mCGfwcTqVIvtOnSx71K3/Ncj/tLKA5/aNIgotr7sRF26S+qx7OSv+S3enc62JB2LLWvCXnh4+gZoGQtLrTDbXdUXREia97ABSp5KtZelWhKDOmJlYpwCZGIIlBkBPi01Llu59janhH9Rqr8zpiljxeCsdAFvUmtEvrPelXu88vNniNjJCXTY6Mz8dHKbgNwW8zUm2A/YfbmL59WcwC71vwvJsrJ8aObdGHRaP4zi0G73beswOOObpAmltjEVnfxd0jeZvdgIdwtCfyw/nqYkIcoTTZM44dEuoPRISk6Ge0tzaGB8UKMtt5R8q6ke/yCkcYEYSDyXLNtVScQkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erAt1BRKgaGGmZYUdjbi4gA072qfwSoug9NAKExGadk=;
 b=U30VCN3FIXWnLv7u8w4dhlchmXBp51fe/Yn3DyXKJLiVr6KpUFO0FpYjhuVvlNSWmRjV8G8Zfktt+tlEhUAUGe4KnMw49nXCC3duIpzmNwFyFIiw8qKruQvk7397RYCQ+5E+aYT8bO1vifNoKNRazKyvzsHXWIG5P3pcgJb8nKok882lJWrP733qLPVz2lvzwp35EeBAaf+rN446XBVqIOixpMScDr79qf85tKxK9kh5emgs2N3al4SPm3gqNnc3QW8ISnUti2skLjaZe4OBNswOJfTOkhu9LnZGxVI4u2wpZenjsvBA/wQOSUsQE+7fu4TIMSrdu6z8cx3jQyFWxg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB7269.namprd12.prod.outlook.com (2603:10b6:806:2be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 21:57:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 21:57:08 +0000
Message-ID: <13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com>
Date: Tue, 10 Feb 2026 08:57:01 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
 <e73bdf49-0a6e-4e82-9727-3a241fa9722c@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <e73bdf49-0a6e-4e82-9727-3a241fa9722c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB7269:EE_
X-MS-Office365-Filtering-Correlation-Id: d21e324d-6a6a-4f27-018c-08de68262b91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVplYWJzTnFSd3JzbGhXNDZ5Z08vWTdOM1I1cUt4VlVXT1F2cllCTXlYQ0N1?=
 =?utf-8?B?WmJOQzI0TWJTZFpITXhqaGF2dnNMU2FreFV5amZWZGdiM2w1SlFZTzF2SWVG?=
 =?utf-8?B?RnpidnlNandua2lFVkpMU2t1NDFUaVBvc3V4T0ttbVhNdE42dkZJeWQ2RDNt?=
 =?utf-8?B?bkMvazkvb3RHMFYxdHZjVWxaQllkV2d0TytyYnJZQ1lHZ2hlWmpoMzdMaWFM?=
 =?utf-8?B?VHBnNE16Wnh2c0xPb2JIK3VxbWFhcDhjOXZtMHNhaEhsQ3NUaWRBU3UxTUI2?=
 =?utf-8?B?aDVITDlwMjFBcDV6VDRlK282VFU1VW83OXpTb0Nkd1RVcnc1MVdydjdwWkhX?=
 =?utf-8?B?RTU1MktZakp3LytzdDhYUUJQNmlrOElxeVRXYVdQYlUvQkhUb3l2MVl2TENC?=
 =?utf-8?B?cmtTZU0yUS9uWDNoZ0pobC9CbkZOYlBQSEk0NFJZbFRhOEljSUkvLzJUYzVa?=
 =?utf-8?B?bUdtMGIzbWhjZE85a1lETm9LTklhdytMTGt3YmkxM0VmeEZOVWxGdzlXVzFr?=
 =?utf-8?B?Uzdvd1ZJU1hVNE1CRFpPL2xrdHpTSy9obmRWai84NlRUclFZd015eHRoVjRP?=
 =?utf-8?B?a05PZG02L21VeGVFRVlMZ21oOS9iZzhwZ2VkN3ZUOHlrWWl4MHFmYUFiTVBV?=
 =?utf-8?B?cVdGVzgzSnRjVGdIVEpwZjVHa055T2dBdW9OTXRMMGtxU1huaEZZcjh0TjBB?=
 =?utf-8?B?NmozOURsTEoxK3FVa3MrZ3RxV3A1Vjd1TDV5MkZLVnUxOFB5MTR4bnBQQ1Fw?=
 =?utf-8?B?WjRyNlpmRWMxNDh1RnVyemNNU2RzYWVjVGp0S3BPVk9SMDFZaVpJdVgvNWwy?=
 =?utf-8?B?eEZZN2gwSFhuN1ZqS3pXaG9PdHVzYUFEZEF5N2k5Qk9yQUtobE1STVJSK2J5?=
 =?utf-8?B?SUtmRE9zd3o2OXNRWitQTGZseHRySmt1b1Z3WS8vT2ZPYmZqR2pVZ0htUGhR?=
 =?utf-8?B?QWNRNVljbjhSRmZLK1QzdkN5d0N4a2c4UGtBdzBYS3NRNEhtVFkwUWU3alNV?=
 =?utf-8?B?bFNUcXEvQ1Q4blFxSyswNkRDeFE5MXdpL1RqVkRubGRKa2tEeDFoQWwxTWE0?=
 =?utf-8?B?c1g0OTBiZ0ducHdhOGJWdWdmT050Ny9TK3hTMEFaUzdleThYalc5cDhJT2Z0?=
 =?utf-8?B?N25HaVZhYlE2WHF5dXZ3WnIrWksxKytGcFMrZi9SNkFyUUdmNjZNOFJLTHBs?=
 =?utf-8?B?ZEtPNEpscHhJR2kybWlsajZCVlFNazg1YU5FS0JRTmVWTnMzZmNFY1pTSEll?=
 =?utf-8?B?TmRVMFpRSm9tcjJXWG5lZUo1a3h0dGVUbllsdk1oMjNqWCtLL3RXYkdnZU1X?=
 =?utf-8?B?c044eDdHd0FqVCtSWk1MMFNMaW9QaFVna2tSQXhmRzQyVUdnNnVONkRkSmtv?=
 =?utf-8?B?NXNLNmd3cmhkT3VQeWpCNGd4RHRXS2d6T2RhdkU0QXNRNjJPNVVqMkM4ZVp3?=
 =?utf-8?B?MDEzdVNGT3MwbC9ZMVVvVU5BMHFYM1NXNUFPdndkTjZJQk1SNHJySjlWeUFT?=
 =?utf-8?B?YWI4SUdGQ01MOWVlOVd0cUVQVnViMFk0aDZqZ3VBTE9FTkFsT1lJMDhOTWZk?=
 =?utf-8?B?TWdVZ0VuWEFkcVo1WjcwdS9aYzN2MU9PM2dhR1lVZFNwOVhnY2tzbmttQ0ho?=
 =?utf-8?B?bE44dFpaYWhvUDA4QWVHbUpzejV5SnVQZFNvZi84SWdCUlF2WHNVSUJ6VHFP?=
 =?utf-8?B?ZW52SzBmd2RnbUZnSFBwaGYvNFpBRlFSb0ozbzQzTmp0QXZKQUxKRWpCa0wx?=
 =?utf-8?B?cm9OT3ZiaWhMbXNWYStlYWRPelFEK1ZjTEtiNzNzNHp0QWtKbjA2YlJvL25T?=
 =?utf-8?B?enBJaTJhbDBoY0gwMlRqdWI3d3JMSm9Wc3h4dkg1OWxSM1BETkczNFZJOHpp?=
 =?utf-8?B?ZjkwVlZTS1BQcytRbjcxK1lCSm1xbThXYjhCd1B1SC95dlcxWWRYWm02TmJr?=
 =?utf-8?B?MUlIRWJmOHBQcFlLWkF4cVRyaHBzV2xaelNrZWxic20yZkRKM3FidW84dC9H?=
 =?utf-8?B?cTBWM3l0dUs1aW5Gb0VOWGhyMTRNZitiT0lMUGh5NDdubC9TYTZpOGZyUk1l?=
 =?utf-8?B?TVJCRUdGS3ovcFZ6dFZQL1JRWU8wVWdXQ2FJeFd6eDJVYVVhL2dKTGU2U2c2?=
 =?utf-8?Q?6BO8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlJDYkxhUk9DTjZ1TTJwUkhUWnJFSWFqR0xGakl3S0xDL0xpSGR0RmxSeGxW?=
 =?utf-8?B?cTN5SGZpb3piZnpGVEZRdlBUOTRCdld2Z1R2d0NOQ0d0aUZERjJSUlhXVzF1?=
 =?utf-8?B?VlgwRXh3ZGJtSG9nTXkyU2kzbURuZEJRaVRIZTVGTzgySWlwQjBlbjhjTWpv?=
 =?utf-8?B?REFubFFjUVY0eGFOa0ZEY3RxWVFzYnIvZXNaYjFhRkxETlp5Q1hGQVliemxL?=
 =?utf-8?B?cExtejFZcDEyRDBpbFdmVHNKejRFL01nWFJveEJNZ3VoRnlvZU1RbUhQbGcy?=
 =?utf-8?B?UDJZdGhrd1dpOS9LMjFoaVh4MWRDNDVvUkJzK0lGcngwem5uRDZXSTBSSDR3?=
 =?utf-8?B?UHB1Tmc2RWlSdCtCT3VUTmFwV1h2ODdjL25UajV1V3NnMm5vT2dlT2lLUld5?=
 =?utf-8?B?QmdUdnJBS0RlTWRJYStINHlUaVp3N2lvZmJpKzRwQWlNUWgzeFJ4MTkyVkpM?=
 =?utf-8?B?TXFjOUk1Z0FzdHZjNzBSMWJmZXg2SHZZVlBiRmErcVoxSjZHVG9tWkFWN2ZP?=
 =?utf-8?B?dXpURm5Ra2NSbFNoY1B4TWIyVXFpeFkrVEdDODArMkk0alJHOUpmb0NJalNF?=
 =?utf-8?B?TDV1K1NQd1QrUWlBK1lLU1NreFFzcnNpLzI5dmVUNU12b01FcEFuRGhwODVK?=
 =?utf-8?B?cjRnNlEzaWp3OUY3TVhFd2pJKzllTWkyRVRMV1hjVEU2RjZHVEM3N0U3NGJm?=
 =?utf-8?B?czArVHNqM3ZwV2VCRmVEaDVCa2VpV3VRUjdsM3VDY1oyR2xvWm5YVllQM2pp?=
 =?utf-8?B?L1lHUzlia0hMWE9VcEYwZW9ySEhoTUU2dFI1K3czT05TM3FDMHhwdGhkbVVt?=
 =?utf-8?B?d1JoeERBU3YrUG4yZC92b04zRFZZaXhDODFhMTJXSC8veldua0FENFB3dnhr?=
 =?utf-8?B?YlpjQUhSRHR5VG1FTGRxWEZHQWlENkJrMmo4RE1YOEZvbVdFak9tZklqN3dq?=
 =?utf-8?B?QnRTay9iSVExTlRrOFRFMEZmeGlFZ0JwbFZMenBaU2llZUJvSzB5eEt3L04w?=
 =?utf-8?B?ZjF6VmI2YUlXL3BOb3MzMXVRNGExY0VmbTFrSHg3ZkFZajlYWStiQ0lFcGd0?=
 =?utf-8?B?WWEvdDVjZS9SdnBzZEJ0SU1qMWJhbDdxM3RlTHhwczA3N0lZanVhTWZ0MEh0?=
 =?utf-8?B?aFhTMEhZMzZNRGF4WTNZRGlkSXV3aGljZ0RsdzVNWnFGQ1JsSlFEL0lpSyt3?=
 =?utf-8?B?SWlzVHI2YmxPaTgwb1BpTkorNnBuTlhXOXFVSlhRN2sxaDBNbHhodGZBWC9s?=
 =?utf-8?B?Wm9JWmRYY1RBbHJYN0xjYTh6UnVrK2IwTE5zMS9QNkgvL1pCZkFmSmJIeGxN?=
 =?utf-8?B?cDdhMkRBSGg1YW1EbHpkRW5WR3YxS2t3Nld1ZCtVSFhyN3BUencwQnhIZnZn?=
 =?utf-8?B?cUVYWTNiQm92bVZVd2NSV3ZOMW1QRmo2UjZMeUc3NWtKd2c2aUlWZ29KKzg5?=
 =?utf-8?B?dS9IVVJBOE9ZTmpRYnVzMis1K0hnTlhTU0U5MWdFaUZqTkx1OG56VkhyaUQz?=
 =?utf-8?B?b2x5c3E1SGlBcTd6VFRrOWdSd0lWVU10Y1k4TW82UVdYZUt2NVhROXVsLzJw?=
 =?utf-8?B?Qktya2o1Yjl4S2Q2S1FScy9Gd1ZGSmRjZ3UzcENPbmYrY29La2ZuSVdtayti?=
 =?utf-8?B?UW9LSDdSVEQzR0NRdHRzeWIvZXRZV3o5Q25iM2g1bVE2U2FDVnBWUk16dk9K?=
 =?utf-8?B?azdjN1phcWdMZzJpbzhCM0RqeE1LTmhqQklMMHI3V3FjVUdiRk5IMHB6elhH?=
 =?utf-8?B?YVdqSWZyRW1BZ2NRMzNZT0FDM2FxS293MmthR2lZaGxaY1ZCYkpMRVlDUk9l?=
 =?utf-8?B?VzlBMng1NUppVCsyb3RHNkdwc1FhSDlhYjBKYW9HQUFiUzgyTUVjenQ0NDZn?=
 =?utf-8?B?aXJwVXB4SzBLUU1nenhreFpuTm5NTDdjNnZ1VS9HUm9EblZDaThmODkyNjhn?=
 =?utf-8?B?U0FWVGJSdG4wVW1aQU5ac1ZDY0VKcWNVZ3UyaVo0KzVhbEZtT1NSbWlTNVhx?=
 =?utf-8?B?WGMzQmY5TkdCSDhMQ1ViVURzTTI5WTVlMmh1RmRpeCt3K2ZyakdXYm9BZ0xy?=
 =?utf-8?B?V0NnczhxOUtad2ZtR0dRdzU4VElqSDlJZHFIS3EvRUJKcmxqODVjbzNTMC9F?=
 =?utf-8?B?bkdKeFZCKzRwQlRTbW9Ld01VVXhLODFvQThkTjdpTG9HaXh5Nnh4OVEvMm0y?=
 =?utf-8?B?VG5xMmhINElIN1JpTTFNRExOYTBxK3VweDRLOEY2bGFTTnkzMFNNRzBTMlQx?=
 =?utf-8?B?V3dxS0lLYVZPSDFPVkRabzM2Zms5MkJXeHZvTDdMNW1UZUR2dUg3Z0NoYzBx?=
 =?utf-8?B?VkpGU2VDMzU2dThERjRXbFBCUU5WbmVYMUN4UytrRVIrVHZucndvczFRYWVx?=
 =?utf-8?Q?mVFZJRD6o9P9QMDBcHDyNuPuD2NZRoM1bvsEbuuq1bIRj?=
X-MS-Exchange-AntiSpam-MessageData-1: TDXmPUxghoFVLA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21e324d-6a6a-4f27-018c-08de68262b91
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 21:57:08.3909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eATOVeRhAd2kEiI4pZvbwO7uPq9YAgIQyze+rm091jkPAblbXO+wVHpOSoWQ0V7bxVvB6l25o63qrxEuUzI1JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7269
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F4B780006
X-Stat-Signature: y9emyuyyrcwmycshqn3ndc49hqasjz61
X-HE-Tag: 1770674233-44708
X-HE-Meta: U2FsdGVkX1/Y7fKSDjCBgDGIFPaI8xB7AX/Bh2vctc5IifZikhxnbM9gjWwssJ0mfxq9QjpX1HOskb7ju3SXF4f2+wcrIeCMaE5UCY4FstLS2f6JhTWxrACRce2Un3tvKxLIkYN5xt1trrFAmOEuNxGirgEHUpjSurgMsP7PBXwC9R2PYmikHmF7nRzo+CqogpO7DV3mqUP07AGCOA29VobP/aefB3JzB1DxEVSbMqtxjAZpN9q2j8p1foVFLgtI4AthmVibXTqi04TkypAddAd37D1Aaea18q8w6ai/IHmooI/fXiaOX6F7bN99s6t8sURyu467VZq8hNeKnGiSAibUrn1vvEhyeaBcdBSJtaSB9xWdYe7DhO+XiDJoJ3X8wmUHUGCcL15igvgpKI90cvvROaFLWl4CFq31XAHHxen625sKvnn9WoAopnYCffNPTwPZV37cC8xOxsQVSEczgn3+IsoSSeHbKEOnWZLh54r3NyU04dH4nx9ehTGuBK7lsSFGUC6vWuBx8CQXTxhi66PJRshmRqWSDJxbz9233TikUG2fh9HfqJiT02l56pmQQn6wziIHRkl4uSDa1PpJ7JSqIvPzEvSNWY25X9NwKaL8z3o0vkBp+51bYe4yfO7eAu2IqzvpsBdomPqrPT+43H7lxEoPG9wgtqldpTskWiWiAwD0oFG9VNPo8UqK0usItMZCrI4M7noCiMJMPSAV+q6ixgWRjAO7mwdpU3IRMKzaNT0njpBiDu+SI8oQLBxxITqQq2r/1Ny7HLLbLihkrbVvbwLWCNJjb2J9oxNxJClobH0rW1M2iOR1OrtXG1+ao+HNGC8Zg0uPX3GrlAelKlbEI/b/p0kRf2k7ge5gieFbs6uzJwWzTtg4UDbcXuml+ekAUmCkuu/XeJPrlGE+mLlOnMMQjWp9dUh26EC+xnzIpaSfIkJVA55wu3hgMFtor5A067yfoQ8GZIngfv/
 Z/bOy47G
 EQoBY51Xn/4qDLAP3ibY6gZ64VefiJ06rSx2/5RFhGd5xQu31pedXec+9/e0YAoo3r5rT4UOAqF9WHh0+5gtB9ORg+Fj6PC7HwNH6nKooSP/XlgJpwLbeoP1DrxrTcprRQt+e7mjPR8J0r40/v2FqfYUMGGGc4epjbrUkBkx/8GckvOduSWKpqBPVz9SupZTDInGg2w1qBAIwnlWI512NvjrawCAjBbrLSFvDeAexNcYmQ9IpyBMHFal/hgIxNBMR/LYBEkHIf75oMpohLSU6KFiGq3a6YWMxEp7xSws/x1SWyLX0j38DSbZ7+9PP/UoZBaJCuScs7eFn8ns3EO8zpPwWo7+rioMCkrul8WSDs3hhXvzjz2wprwtiWyNWTx3hUbtuPAb37lt1W5PtIDD4oHz+KsehsFwYWvUCHgn4WAh1v76VSV4eHQgYRND2s2hI5zKOiMP9Y2l65ThMTWVrLh4TndesH/XNBApzYDF39rKGo4SjDwgshtd0MhB7V1R+SALh0b1sCzu3tXkWWt1w6hrd/7XKj3pd/xEfjcpBZ36O5LY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 03:00, David Hildenbrand (Arm) wrote:
> 
>> index 8c95a658b3ec..022b0729f826 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3463,15 +3463,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>           new_folio->mapping = folio->mapping;
>>           new_folio->index = folio->index + i;
>>   -        /*
>> -         * page->private should not be set in tail pages. Fix up and warn once
>> -         * if private is unexpectedly set.
>> -         */
>> -        if (unlikely(new_folio->private)) {
>> -            VM_WARN_ON_ONCE_PAGE(true, new_head);
>> -            new_folio->private = NULL;
>> -        }
>> -
> 
> Balbir, why did you drop this check?
> 

Are we running into this somewhere? This change clearly seems unrelated to the intent of the
patch that made this change (by me). I was seeing new_folio->private as NULL everywhere during
my testing and so I removed the check, happy to bring this defensive test back.

Balbir

