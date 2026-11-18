Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDC4606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ym42NZ4e
Received: by kanga.kvack.org (Postfix)
	id B40CE6B05BF; Wed, 18 Nov 2026 08:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1F96B05C0; Wed, 18 Nov 2026 08:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08276B05C1; Wed, 18 Nov 2026 08:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 727B76B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:44:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05928160768
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:44:29 +0000 (UTC)
X-FDA: 85448359458.29.FDA5D91
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 285EF40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:44:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ym42NZ4e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of arighi@nvidia.com designates 40.107.209.32 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vS1xzBlNSJRoauP4EwKrGSVGopifa8lU47oTDCNQSc=;
	b=YlA7ETc2k+h8/iE9RzG2GuGrF9NkfhFvggtDFg7LOa6Ruo/soPbbSyiOKusA64yCW5WWZ8
	4iZbVOy/nGJf+pcEEcN8lHXGDWi31NU3jB1+NLhkMXdNzM77acSS4NjadFINiqF9DmKAlw
	79q/NOq5DN6WKVVaoczV04CR8iHb0Hk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ym42NZ4e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of arighi@nvidia.com designates 40.107.209.32 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795009466;
	b=oz13ssCtY7JMMIvZQWspEeeRYTTbYCd82Gle/mdtFPA4y16pN63B1zsVZLcV7S4Xns+0VD
	beRvFwSV/qncRbKJUg/eGDbqF8LaGAK0arpU9xVWHSjnp2YX8HI92PKcoqtjXyE+1Ahx12
	TjerAlhob//qOfNjFVwoQm2U3/nlO70=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kx0zXHojXRhtDFH9R4FKPZFGj8AL7PPM/TIzClvVj9ndRIUDwuwpk8abZw3+eiXujVmrvUc3XBnJUVmCO23SkQ7aGGW/JViGlC6VwK5R6U53oEg2vWDNlVQ47PGrHZP6fAtmjhO2CqULTxtMPEvezgJDs8k3Da2yJWWAUqTOgCtiDc9w3AE1cQIiLWYMjbxi0OJxhLG5hzSGHrD4XN2lw6mAmuf4n1occ0CfsmhLX3vWrRi5aT6axetJGuRbMkVJkkgw1a9A2bVVgNF6apQCWqzKo2FyVAcPTGejNSu+OFXvr7U4W41fHpCHeI3tYCD9ZFiMFE1wExZdCNMCqUH3+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vS1xzBlNSJRoauP4EwKrGSVGopifa8lU47oTDCNQSc=;
 b=Glbv2n4i6EQBZALLGj6IzD2metb4qr4Hz+GPjhpP/8yleRTAuzMK6lbjUFSL3XqwqSd0wAaoX64daFDKKzDgxXDsPchEqFvdUVjh5D+TRfggpZlCgT47mWAg08PTpMJRfYp2nKH/M1LXif1nCsRZfSURy1NEQEFJQZJ7iish71s1unuJl1gGSIPUQdbDXHETP7lqmOuVkJCyAu+Ql+0IrclJIKrn3kZ60PrM81nMWU+W9LoPEOVzNjGbNyhwnvvz2J5KkyYcLh1XjZl+dUkjtbaTB/8lm3QQ6spa/H/e6k49Q4xgu8IFgr92KByL71H5LF/PWFPrmPnXr3Qgl+WdBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vS1xzBlNSJRoauP4EwKrGSVGopifa8lU47oTDCNQSc=;
 b=Ym42NZ4e7AkI65xFez0Aouz0F/6s9QNURs7wmzlMua9HDa5abXnLkNY+vzmIo0v0cfzftaIr6sDtR831ze7rS5IgHEMsMLuGRsiRAkW566vj30YgT5ZdQsIQB3408eS5ViLZclXmmn5S9/1WrbVI4TecF6UxDrheVkW6sN0NeF0NSIWUo5eaGC8jP5Ef/zPaQKvjxU7rk8DJE2anpcrSjPHZHSZeSWo7w/yt5PJ2lsIdqwnqGGKuT6Sm1/ZPqq5gZ1BqjacRdNbIylGfJ4uglZqvkez+/Y1FIR03CwCP6OXr7OxeAWMgf9+u+z9E4BpU6ix4habJD2sOVNHn9DC7XQ==
Received: from BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19)
 by BY5PR12MB4244.namprd12.prod.outlook.com (2603:10b6:a03:204::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 13:44:21 +0000
Received: from BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9]) by BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:44:20 +0000
Date: Wed, 18 Nov 2026 14:44:09 +0100
From: Andrea Righi <arighi@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Quan Liu <qualiu@nvidia.com>, Lee Trager <ltrager@nvidia.com>,
	Seth Forshee <sforshee@nvidia.com>,
	Gregory Price <gourry@gourry.net>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Message-ID: <av2rqSzkvZYQRgAA@gpd4>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4>
 <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
X-ClientProxiedBy: FR4P281CA0288.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::19) To BL1PR12MB5174.namprd12.prod.outlook.com
 (2603:10b6:208:31c::19)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_|BY5PR12MB4244:EE_
X-MS-Office365-Filtering-Correlation-Id: 72f22ae2-7c53-4b9d-5790-08df457a0c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|261026140227099003|5023799004|4143699003|56012099006|11063799006|261022075727099003|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261028144727099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BSQR2x1Vk/ZKLiGBZxUbN24y8a67kVWWtmSvfLMz948URwu1mK0sb7U4Gvdmrpxo5hNpuo3cgSovpHaQVEOdETy5FsQ294IrbS3B1BrIRMKgfWrzFWwFnJxx4P40lbJK0lXmI3OpxyyhoDlcPeHwBDzTB0EBGQmwQ0MtBROI8LshiX+CoPMVRpD0kUBRbN2km+C9g58rdW0SfFEMLJbGKCNjpHnLipyw7XeRS7zB62WB0x8moGLuuGe69WYplCML4TXLriF7YW7o4b6bljmKZxM24un/4tc7CvX7774KNc1Lbe9FCGPLb8vLWUIU3O8EemIhT/b/8Fde22QJsRm7mF/jhTl+hW6sQWXE4d44zmjvJF2W6b5AiQxaFmVQKarz2oy7DQktLWXeWEOc57Ihriqsr8D2bChbeOIv8RoYeDApWBjPV/fJyA+yePuQhoQrKXkh6qOMCMj3cIqzC98sDwYTLdg5rzxlOKN5V3szO/A2jm/g+WOD2gE/3Hd2fJ6fMAbd+z7Qxa9Y/Jvg9FbKeEA3sBIid2TBDxvpJVxVNU32pEfzg9PzWhzybUsVMcGwdMovagxdLEhFLCKaTf20ae2AZLFC5Yp2VbihjLPmfpo7fH/rMz/5byE+ODrVTd19VH6XftAxSa/JN+Canscut1BPmujoi5BYnkDd+rp8rqg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(261026140227099003)(5023799004)(4143699003)(56012099006)(11063799006)(261022075727099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eKzZxAt/UtOdPkkFfz8hCTBMlUjKFO7XgZh2TDc6iRTQwu3RN3b/AlolQaNe?=
 =?us-ascii?Q?PYoJuhLSCY2H+UM573mBjr58TkyCKn4gInK6v3yGF9VYQITrMnrXCVRc4nII?=
 =?us-ascii?Q?2PXOypq8/l82dFTTfijuATusukZ07do/xIBKlnQPrcvqsY7jsQ/BEFR8dW+Y?=
 =?us-ascii?Q?PVRq2Dhor/gB1cE0N/pYuQwtJKpaYbcHAg38PFRcrgwD38fBWXmScNFLYWt9?=
 =?us-ascii?Q?iL/EiKMgwFKO7lmiwKgLfjU1hvbHlIJNGUcNf5y0qOUOdMPJhtNJjUsOzzLV?=
 =?us-ascii?Q?gMkhZrHqPN9vFXyY4bjc8QT/Ya+BFob3v3Jjw7jsMHyP3Q5Iw8j1m5gUkJpV?=
 =?us-ascii?Q?h0QtS2jwhvasAID4+qrBfNYfB0bCHkYZTtxHSm+/HHR6OFCmSorW9/aQUHyw?=
 =?us-ascii?Q?c7BSnZsT7py2QU5iPxfK2u2pJFcEXhJYcunm31wSsvmIhC5Pf/1mcRMSl0FP?=
 =?us-ascii?Q?aTfRFl7YVk6YGhyK7KKvO6N8NNxWscE+Ylw/OcC1JXFgMFocAUvKwaLC/vPF?=
 =?us-ascii?Q?3ljgiw+nV4KJ0dVjexMIu2iiV2EoTJvq0ydQAfD+bTxNYIJmvoiiDIBmikme?=
 =?us-ascii?Q?EN8FhbpjM5I0yfLMNmc0J8nXD0pK53tgEszHLflpXUTIQKGS3AZKhBXMhIz6?=
 =?us-ascii?Q?+RAqAlx8JeoeG4kyOiYjX+GPBYQQuM0E1DGvMPsIHanOOAYJhogyalzgLCpt?=
 =?us-ascii?Q?1vSPwuaFoinTClO0+m+FNGq8IQMH6+V+5p5LYEGUbwWRurpOCwf4gOoIx0ID?=
 =?us-ascii?Q?KJE8BfQzgG26A6ktnYpG3MGESQiOzo/Ln8X735FD0UAyOZ/FaDRpYnhA7AaC?=
 =?us-ascii?Q?gsUAtCw98SUKqSSKGXE9WCXngxylS+qM2gpfEYiefl387WdHzEc1OCEm4KXK?=
 =?us-ascii?Q?ylf59HP0se0JTGzytMChpOv4OeGZV+vWWpmKXLcpCljQBSHx3D83UMNNxyxA?=
 =?us-ascii?Q?nXEUiEqOEy2P/2zVloxoDdhYqSvTNc1nc4DzsC7tzBeZ+eHxZEk1cMplnzP5?=
 =?us-ascii?Q?+havwfNT05va+uaWLwJFSq5HEettX++fIQWDi78njiFaGiifZglBU0mLWf62?=
 =?us-ascii?Q?LJ8Iv2prOVOOFAwDbUKUqVX+1oXNDXfrpafN7qugCpmFSw8lrJv2F7JlkPOT?=
 =?us-ascii?Q?W6Up2GhF5U9P9e8vnLy71UDFFl91FP+D6SnpTuVDnJPjP2M2huBrHpmzmxE/?=
 =?us-ascii?Q?kLDFcg+PjdfRcfO+mrjb9TzfuqzL0IByxZ0oN2ISEn/ycFYaKlLzShX+xxRq?=
 =?us-ascii?Q?rpEVFft0038/Jt0UtfMESbogPJlHem20FQx8iGtN+ESxCpGEW3Tuf31DJ1X9?=
 =?us-ascii?Q?xzxBT67D9aeQUsRD4LnUyTqNnO8tEP4eMI89y4rVXyB1x6+RC9SPJYQPR5/z?=
 =?us-ascii?Q?fXZY+JqBGDz7CuVDWHqXtirONdud+Qx3yHpA3Mq5llr/HKsXA04V5hm3MA/v?=
 =?us-ascii?Q?+EtfNFt6K7lM8Ne3Uw9j6f9yae/nB8QUs6aMKOBIjFY6ieeiFEvnMoir/xQB?=
 =?us-ascii?Q?69ZOVC6UH0BRmYq22EfgfSrD11vR7twTH5w5kwv5eZ0/tdsztLKK3lJ9+JJi?=
 =?us-ascii?Q?X6z9ZFOC8tjxK9OkzMMHECb+Ef8WNHtq0EUCrK5W2sYt7D6zFQRLg9n/Junx?=
 =?us-ascii?Q?ZTmjOj4QaN4wVUpCYbA2837YVN3kD7oMfi5hKZhFdQ5YMUKoaZZ+ucOGZ/F9?=
 =?us-ascii?Q?iQ2xbcDWZL2V7M8phCH9q3XbJ1+Pe8BKh9XZS0vkQdn86QDYDVN+OcbzTOwF?=
 =?us-ascii?Q?n0Nx11LyvQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f22ae2-7c53-4b9d-5790-08df457a0c76
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:44:20.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/KUT4ssXcAoA5ATMFwWyqTWUrVMw9x02IGu4aOLCHEsUJXBFMu4m3izbQ/1ElqEh3KevQ3ynpAZv74/thMRGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4244
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 285EF40006
X-Stat-Signature: a3sosarc5s3jpdtgayz1jpcc8i7as7cr
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795009466-698599
X-HE-Meta: U2FsdGVkX18SswYxyN6fI0ZGQ3lF4j3XmmBeJq6hKT0YeCFxFskBNTV1oBkynB91KDak5nOUSH8M+P2g71LGGnqn7P2fWqqhd+ZbsBkjnocOCWDMtkdw7MwDp+HxuTO6W6r/qnLN0aJuF2Hm6v0ETyCLMqMxjfGdocJoxo2xYNU0VWc/a56uelDFNyg9wSr2cdsCFQsXXM6v+SVZToG0Qv6RTsyB/OajFxBvt3XXCPXtGXCM99U0DgODHaGMfZrpvIsObGV30b47Nei6MfIaMTK++hb3t3CwmM3JDVzdF/MSkuNzvzWjwsk7u+ae5zaOneQ/cmhzaEk08DecP+vG9cX75XXcvxmTWblv2xs27joLE40Qol4HMCczT6dhYbutezVpSNiGOaG6QjKu00lptB5x9IAQ91FU6/q4puJvjsKIJJ31rEC0JS2JAmuug9rOEAAfV4GD/+zJMlW/evUouqLcAE5epa6mxO7+9CfeBIemNc1kkXVbfohrsHUvR57Q420gMO45AcIMbpV9WRS/bHVEz+hwoZD8fcI1L/pmUlKgfWVKbS3gOCd+GsgWrxVe+DoMkJTJVOgfskd3wexePCKxaqhGUKQ5jOTJ9zLkXjIqcSr9aOJPh/bDC3SQISnchXv8vNzZ652HhigLRzf3gTRTH+aPzc+DTJh81qBdi/eYG7Iie+y6F7ycqjBRKPZ5tWy+GtnrG6wUykPj9eZE+H/WyIMcEGoDjml5l0LRYCitwjTvKHAqgGdeF2bSjcv5RGoOUwLhCkSVUX+v6nv2rlno5HnCAHwB4vO5TCtDKDdzyT/u6douXnbmUUCmPfCZTR3bKGz8x2puLPqsyWJijzeaS3gvPV3PJe/6PWWtdrX2X/BMc7GwIZrcaQ45L1THFj0FQdhQWvDjM2M7VIqsbCnhxEEok91QbruUDI3vqJ2+CscaqnvKmf+PkNLxuPf8+4X1jD9aS5ntAISiNky
 +lx1T9LX
 5Ld1i2wUN1l3gyYsgAD/WVFxDBFILyF/SR7OziIoXi5o2Ldus15OxKLnslhoZoE8J8ROKoTaqB5cv4fUwVTCjBxU+SRQF1KSjBVoTKjMCU6g2xZAEgyqJKHFeSRBjJLhM0WqtPxNLmLYR+8MMLUM5eVFm77jt+tkPNgA16j3+ly8JvgVMxpAg7ipyhvxXm7vyI7ayY+JG99HhSOqDTVEJdhHGDOqdylmDGE+4i/R+c59qMaTJ3iKeXCZFF5nAYH2QzFQYYxfaU2C1OL3lEe3GFBCdZfb7CFqz1Qffk8XI5Jsbg2bsj6u75/ZuKBsT3GFBDkQZliLG5O2DXlEVZvH+IFFqR7IYNsO6BuQ5MQm9TEcmmD2Jfkt/faY/ahPyd+VbKzobg7sWEQlF2++IGtuo/EfeZT9UALhr+zRQSfrYlSOtDMlw7c28/MbTsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vlastimil,

thanks for taking a look and sorry for the late reply. Comments below.

On Wed, Nov 11, 2026 at 09:12:44AM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/11/26 07:48, Andrea Righi wrote:
> > Hi Jan,
> > 
> > On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
> >> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
> >> > Generic slab allocations can reuse partial slabs from another NUMA node,
> >> > even when a pipe workload is bound to one node. Pipe metadata is shared
> >> > between senders and receivers and accessed throughout the pipe lifetime.
> >> > Reusing remote metadata can therefore make an IPC workload pay remote
> >> > access and coherence costs on every exchange.
> >> > 
> >> > The target use case is a workload that binds its workers and memory to
> >> > one NUMA node with numactl. The policy node is then a useful placement
> >> > hint for shared pipe metadata.
> >> > 
> >> > Allocate pipe_inode_info and its descriptor array on the node selected
> >> > by the caller's memory policy. Apply the same preference when replacing
> >> > slab-sized descriptor arrays during ring resizing. An explicit node lets
> >> > SLUB try local allocations before reusing remote partial slabs.
> >> > 
> >> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
> >> > NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
> >> > node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
> >> > policy node only for slab-sized arrays, avoiding an extra advance of an
> >> > interleave policy for large allocations.
> >> > 
> >> > Moving a pipe's users to another node doesn't migrate its existing
> >> > metadata, so migration can still result in remote accesses regardless of
> >> > this change. Generic allocations may reuse remote partial slabs, making
> >> > initial placement dependent on allocator state. In contrast, preferring
> >> > the policy node leverages the workload's placement hint to improve
> >> > locality when users remain on the intended node.
> >> > 
> >> > Testing has been performed on a dual-socket NVIDIA Vera system, covering
> >> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
> >> > targeted stress tests.
> >> > 
> >> > The primary hackbench reproducer is:
> >> > 
> >> >   $ numactl --physcpubind=0-87 --membind=0 \
> >> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
> >> > 
> >> > Results (over 10 measured runs per case):
> >> > 
> >> >               avg       stdev
> >> >    before     9.811s    0.130s
> >> >    after      5.770s    0.058s
> >> > 
> >> > Before this change, allocations could reuse remote pipe metadata. With
> >> > this change, both pipe objects and descriptor arrays are allocated on
> >> > the requested node, improving locality and reducing hackbench runtime by
> >> > approximately 41%.
> >> > 
> >> > Reported-by: Quan Liu <qualiu@nvidia.com>
> >> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
> >> 
> >> To me this makes sense so feel free to add:
> >> 
> >> Acked-by: Jan Kara <jack@suse.cz>
> >> 
> >> But IMHO it deserves a look from MM guys since this is more of an MM thing
> >> than a filesystem one... Added to CC.
> > 
> > Thanks for taking a look, and good point about getting MM feedback.
> > 
> > Vlastimil, Gregory, do you think this SLUB locality and mempolicy
> > aspects makes sense here? In particular, does preferring the policy node
> > for slab-sized pipe metadata, while retaining the policy-aware path for
> > larger arrays, look reasonable?
> 
> It's not wrong, but feels a bit ad-hoc. If it's pipe metadata now, what's next?

Agreed, after looking deeper this isn't really a pipe problem, any slab
user can hit it, so it should probably be addressed in slab.

> 
> Slab will generally return objects from the cpu's local node even if it's
> not specified. It's not guaranteed, but it's not guaranteed also when it's
> specified by kmalloc_node() (unless __GFP_THISNODE forces it).
> 
> So the results above are surprising to me. Are they on recent kernels? Are
> cpus 0-87 all local to node 0, or is membind 0 there to force a node that's
> not local to some of them? If they are all local, I would expect the objects
> to be from node 0 even without kmalloc_node(). So maybe we have some unknown
> deficiency that should be investigated.

The results were collected on 7.4-rc1 and I've reproduced them in
7.4-rc2. CPUs 0-87 are all local to node 0 (node 0 has CPUs 0-87 and
their SMT siblings 176-263, node 1 has 88-175 and 264-351).

I should have been clearer about the setup and the results I reported:
numbers were collected after seeding the slab state to make the problem
more reproducible. Before each run, a helper holds ~4K pipes created on
a node 0 CPU, then it creates 1K pipes on a node 1 CPU and closes 7 out
of 8 of them, leaving sparse partial slabs on node 1. Starting from a
clean slab state, or with only the node 1 part, all objects are local
and there's no difference, as you expected (100000 loops, 10 runs,
placement traced with bpftrace):

                                         avg      stdev   remote objs/arrays
  not seeded                             5.122s   0.027       0 / 0
  seeded                                 9.730s   0.125    1606 / 1780
  seeded, remote_node_defrag_ratio=0     5.101s   0.019       0 / 0
  seeded, slab_strict_numa               9.889s   0.188    1624 / 1482
  seeded, pipe patch                     5.112s   0.016       0 / 0
  seeded, slab change below              5.106s   0.027       0 / 0
  not seeded, slab change below          5.103s   0.036       0 / 0

When node 0 has no partial slabs, get_from_any_partial() and
__refill_objects_any() take partial slabs from other nodes, and that
scan only checks cpuset_zone_allowed(), not the task's MPOL_BIND
nodemask.

The seeding is only there to make the problem deterministic, but it also
happens without any artificial setup: right after a boot, without
touching the caches, ~24% of the buffer arrays came from node 1 (7.30s
vs 5.92s with remote_node_defrag_ratio=0).

> 
> Also note that it's possible to force this behavior of respecting mempolicy
> for all slab objects, usigng the slab_strict_numa boot parameter. AFAIK this
> was added for systems where the interconnect makes remote accesses
> especially costly.

I tried slab_strict_numa, but it doesn't seem to help in this case,
because apply_strict_numa_policy() leaves the node as NUMA_NO_NODE when
the policy is MPOL_BIND and the local node is in the mask, so the
allocation still falls back to the remote partial scan.

A more generic fix could be to make the remote partial scan respect the
bind nodemask. Do you think something like the following could be
reasonable? (only tested with this workload so far)

Thanks,
-Andrea

 mm/slub.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index cd671b9347191..dd6f69cf2acdf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3981,6 +3981,27 @@ static void *get_from_partial_node(struct kmem_cache *s,
 	return object;
 }
 
+#ifdef CONFIG_NUMA
+/*
+ * Return the nodes allowed by the current task's bind policy, or NULL if
+ * the policy doesn't restrict them. Partial slabs on other nodes must not be
+ * used to satisfy an allocation that didn't request a specific node.
+ */
+static nodemask_t *slab_bind_nodemask(void)
+{
+	struct mempolicy *mpol;
+
+	if (!in_task())
+		return NULL;
+
+	mpol = current->mempolicy;
+	if (mpol && mpol->mode == MPOL_BIND)
+		return &mpol->nodes;
+
+	return NULL;
+}
+#endif
+
 /*
  * Get an object from somewhere. Search in increasing NUMA distances.
  */
@@ -3994,6 +4015,7 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
 	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
 	unsigned int cpuset_mems_cookie;
 	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+	nodemask_t *nodemask = slab_bind_nodemask();
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -4028,7 +4050,8 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
 			cpuset_mems_cookie = read_mems_allowed_begin();
 
 		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						highest_zoneidx, nodemask) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
@@ -7466,6 +7489,7 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 	enum zone_type highest_zoneidx = gfp_zone(gfp);
 	unsigned int cpuset_mems_cookie;
 	unsigned int refilled = 0;
+	nodemask_t *nodemask = slab_bind_nodemask();
 
 	/* see get_from_any_partial() for the defrag ratio description */
 	if (!s->remote_node_defrag_ratio ||
@@ -7475,7 +7499,8 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(mempolicy_slab_node(), gfp);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						highest_zoneidx, nodemask) {
 			struct kmem_cache_node *n;
 			unsigned int r;

