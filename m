Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A24A3CA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 00:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084818E000C; Sun,  7 Sep 2025 20:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C5B8E0001; Sun,  7 Sep 2025 20:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66018E000C; Sun,  7 Sep 2025 20:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0A208E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 20:07:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F9DE13BE84
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:07:04 +0000 (UTC)
X-FDA: 83864142768.15.ACB1E1B
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	by imf21.hostedemail.com (Postfix) with ESMTP id E3ED81C0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:07:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eIi2UG6U;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757290022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U14iz62crGDpSBTWX4RkycX+He6b2nZmNNVKJO+nNeU=;
	b=pbJIgCSJWPtSP4mkBq7qEAHIKiWtx4DleiLf5hxRAmoPaWyjtRVMKYc7ARt4mrP/0/42Wz
	kCpw2egA9O08CINAcIVWr3/hOgaiiwtWj42v4NG6TWJYYJ+7qLuiebXkNju7gT5E6rsJco
	C/u4rxkmdhHoipBbSBh12eP6q4rsZ5E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eIi2UG6U;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757290022; a=rsa-sha256;
	cv=pass;
	b=SbYbCHBQnhNfK/EONNTJAsmsSWsQVVDNVKKOY3VqJre/AKotsWxjKidDNe3xw7uDL7bwoi
	qvv9R4idlMpQr5zfSRheJzTeODURCfvXUBOUriU82C4UG1NlXnckKgZZTldiXCS49ZdFRn
	ykdzRPOPGrw+4tiHVnJjkPogWB9gEoo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3cCcT8fOGaJAd9VpIwPi69wtg+j4L6hNjCZOeDK8y0SGXRPNKsOPSdzgZwjgzxRKpg1rEbZnR96DqxJen7pBnJKdZdTWHkWrwmRrdrGVtSOBmDwBNBOxFT4XLQ8sqEDt+DKYKDIyfxaAVbrCbW2ie3zIfXXBc2TRxhncTHX11qOIoV0703K39r0pSxH3gP6xr25U14z717Ih4bUClmGMvQP4dV5AMrLYZZGrEIa1yIl2ICrnM7856QXREoMM40RAnS0jxW3X+90tc6w8tBVn19f21spgtTRWgYI8QFbY6wA2NuC/rNRtAJy3e4lRb2K9LlMGfbMtXyEwUpT3Tmz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U14iz62crGDpSBTWX4RkycX+He6b2nZmNNVKJO+nNeU=;
 b=vrZ63Pcqo7CaC/JJFFuz9jI9jS9kZRuP2MU/SDUW1YhMyCXxWRI9iAoy2y8UMrWRiVrrZbMRLBzV48VgRRPo73emvfUOgvn9Dfy75q3E/RfWBn8V3EiJMaavpOyVivhy/tZDD/j5ndo/DAHG2YSrUmGLuNrA/hj7eC6u1x7sXZyl82I0lHftpARkhF0E+608okB9Lv3rzEbHxcGHVwwOuERVgXbjslJdYvIqq+oxWF8IvgQIG257KorPNQQWfWwtr6aXjbG6cHPOH+NF4QBSu9vB866VoZ7NbRHo/VBv5FcRA2T2Y96jdwdk0ZiQcjWFRvsx/gu449osytGYEwNk+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U14iz62crGDpSBTWX4RkycX+He6b2nZmNNVKJO+nNeU=;
 b=eIi2UG6URyk72quJ9E20i4wnvWoAA7JJ8bhi4YS3oVI5Mcypi9CqK/lHlx38mDRQuHuXA1IawA1FAztNj+Paf+YpIj3BysllEZ762zVEQ4iZ2R9KNrQ5Bf/Fs/VXLKv6seQr7YW7Qmt8Q/t3VSjWE8GZ2WcjfcIokSEJwngSWz1J70+yEVNsmAmpMR63glP4lZSrQc2O4OyLCPF/rW+q5e7TAXDM8TAlJK2H+7ZDfiJsftsSU89Kie411wjMj5RFIA1TO7KukpexYEiamOQz60ekindZwohXAH0XtFeUCDnyUHtN7hqVIb1FIYdGpl992VYw7CvVl9MWFmdf9qTMxQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Mon, 8 Sep 2025 00:05:25 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 00:05:25 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v5 07/15] mm/memory/fault: add THP fault handling for zone device private pages
Date: Mon,  8 Sep 2025 10:04:40 +1000
Message-ID: <20250908000448.180088-8-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908000448.180088-1-balbirs@nvidia.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 1581e081-95c6-4d7f-2b86-08ddee6b68fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTZvMkNiOHBpcENwc2FteWh2RitoMTlreFNFRFJBN0JPK2UxRzF3d3lXQy8r?=
 =?utf-8?B?bXg4Rm5CclpXSnQ5Y3pEanhnbXRrMUszR1BNbmZEeWRTK0liNElzNHVpbURm?=
 =?utf-8?B?M1JDSDgwTzFXeVZ4ekpxS3dZZ3NvUE5YVnJ6NUdMWUZsV296MnBqcXJiMDhX?=
 =?utf-8?B?ZlFVNlNMR3c1SVBJdmZsMElJeXh3djZUaVRSYW1TZHRFOVdhQmEyK1VRYVJh?=
 =?utf-8?B?ZkJhaGR1US9TaEx3L0c5cFJtWlhLa01OajQwTkxvZ0lLcWQxa1VWZE9tMUIz?=
 =?utf-8?B?Z1NtMlBBWXB1eXhDQW1PWVA4d1dLeWFSZ3BIQ1IxVzZsRit6bDg5RVVXT2Ny?=
 =?utf-8?B?bTBkQnBid0I2T0R4Y1VUOWxIb2xrWE91bERaYVZQODJ4bHRaS0c2Rk5Dbjhr?=
 =?utf-8?B?clJuTkFaZzVKaGgwZzZCS1pKcTJFV1JhT01xa0ZmMjl6NUZzVHE0ZW83enUv?=
 =?utf-8?B?TFNqNkRMR0FYUmpXZmxaOGpCQ3NOcnBaYWxWeTd0U1pIZFFIYThXcjdBOFky?=
 =?utf-8?B?akJ1MW8wMTNMdEg0Vk1lbFNxT0djRitoZy9HVnhsN1VHeWJRVVloaWdsaEg0?=
 =?utf-8?B?NklwajFMdmNPcC8zaW44dTdRejNMQ1pCbklGeTQ4ZXpXVzhxNDk4ZkVnWHZJ?=
 =?utf-8?B?V3hLdGI4V1I3c0xzWVRFYnRCa1BYT1B3L0FWbWQvam8xU3U4K0xnQ0R3dDQy?=
 =?utf-8?B?K3VVbDF6MXNua3ZOSm13MlB3bmYwZDEvbjdQR2JQVzZJU1U5a2gvOHZPRzBn?=
 =?utf-8?B?cEwrcnhyMjZxRGY5d3p6c1RpQm5MVThxSndSemc3QTRyOHNzc3h5MllGMUZS?=
 =?utf-8?B?L3czZFhXSlBUMkVoaGZaajBrSlhNSncwUnE1dE5PZHVJM0FyWDVTVXpiRkU3?=
 =?utf-8?B?WmpGRXVWbEhraXZjY3VJRmt3V0hoMktkc1d4MFNUbFFDY01rSVpLMitRZDRP?=
 =?utf-8?B?NHhKSXJ1MWZxWFpVYU1UVjFEZ2dMaXRrNFQyVndwVndGTkpnbGJXQ3hvTDNX?=
 =?utf-8?B?WmVxdDB6ZmdadzVLUlRub3p3WE80S0RXNkJ6WUhNUUE5UEU0d090d1BFWUgy?=
 =?utf-8?B?L1drY1czeFZnU2NWcHcyOU5QVENBNUZrcnhPQ2NqRmxBZU5DK0lmSjlYaUht?=
 =?utf-8?B?T05HUi9HTmxaY1l3YWZDTVZmSGh3QjRVNmJSdHlLVi9hM2l2MnlTVWk4L2NX?=
 =?utf-8?B?Zi95ZmhlKzd3ZDR0MnJKT0dPL0RtWGljTHNZdEZoYklSbkd3UzN0cmpxWDZE?=
 =?utf-8?B?cU9Nck9rdmFXbC9wcXVodlBGM3hIYUZkaW5YUDhST3U1bTZwQUh6Vi9VclRj?=
 =?utf-8?B?T1hVanZpOTZYVGphS1QrVzV6MGVDTktycVk0SkZ3S1VyZzZMTXc4SVI3SFFJ?=
 =?utf-8?B?YkU3anJkVnRNUlc3S1ZBNXdTcVg1bjRaU3J3ZUVUYVZsSnRYZjFoMXBNVU9a?=
 =?utf-8?B?UVNLRFV0aUlNQ0IvQVc4S0xid0xGT0FhUll2ZFVFbFc5MmdibGIyYTVwanVv?=
 =?utf-8?B?Rjd3OUVQN3ZRdm1KWEtJSmlnQTdBckFEaDg3V244RGdXazVSVEFDYXFQNXp0?=
 =?utf-8?B?NThKVHYvdE02d0hZTHlSM0labkV0WGlLbkhiemRValZ1R3lKVE1qd25JYzJX?=
 =?utf-8?B?NXdCVGN5SFF4Q2RBMDU3K0NLZnFiQWhaMWhoR3RZM2JJNWVTN2JRVVVpd1Zv?=
 =?utf-8?B?TDl4TDBYSk9KZzY2VGV4MDNySGh4aitEM3p6cm1vMG03VndlTDlpWlRNL3dh?=
 =?utf-8?B?TUIwS2FkcXdaZEJBWjU2OGpCcW85OFRWQTVueDNIMFltaDRPQjMwekdackp6?=
 =?utf-8?B?TWszRXBwQWRZcE1Ub1JMdy9pdWpVQzlyNXFWWnJzTEYvekR6TFVRNTVxdlFV?=
 =?utf-8?B?eWpLR2ZWb2NFUnZyRkNQMkVLWHN3bVFUdFBycTlZVzQ1UTV5S1BETkIwQmFo?=
 =?utf-8?Q?hQYspdpEZBU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enlWZlozL2dRc1BlaDBuWDJ5M25FOXY5aEQ4YUNuNzRxVEVOL0MxbXpneWN4?=
 =?utf-8?B?Q21xS2VBRitkWnY4SnV2ei9Fb2IxS1BKTDhSWmFwOHFHWWxlTkEwRXFiT3F2?=
 =?utf-8?B?QXJQQ1NjVzYybTZVQngyT2Vtc1JrcDBnSzcwT0xUOWdYUGNGU2xQYjIwMTRr?=
 =?utf-8?B?UTV2MlF4djRYaW9Ta2hMMUZPeklXMHRhTGhEV1dPYWErWUFRazZOWW9aemNB?=
 =?utf-8?B?SVA3MlhXaHJKemh2UDhFRDluR0lLUzF0czRhNnhlS0RMRE43WmhzWFgycnRh?=
 =?utf-8?B?WFpwRXJ1QzNQaVg0RS9qMXYxLzl1bStyL1JjelIyQWtOMGUyZWhQaURRMnNu?=
 =?utf-8?B?RGlINUY4RVBzdTdBN3FQaERCNjJWeE1iQzhoK3NWSDVqUml0UDJITDQ2N0tt?=
 =?utf-8?B?T3o2SUlRblpKSm9EdkpZdk5EQXFERGtlWmlvNkhkbzMzUkw2aGdobXl4c3ND?=
 =?utf-8?B?Z1k2ZlZuZlV4Q1ZJenJpRTAyTHJ0c3MwN2V4VjI2NWo0R2d3N0FJdmJldWd0?=
 =?utf-8?B?ME1LMzIxM2o3UVNIdm15M29vQTlGV2JzQ1VIdkcxcGlSRG9uN043OXJvQ0pP?=
 =?utf-8?B?SG9SOUVQMmNJM0FaYWpjL0o4M053ZkRnclF1N1RBOXlDMGdGOHpoenlKb1hD?=
 =?utf-8?B?TnlQSmtyQU92N2ZTbmJERFNnUGp5ajhMdzZFTEd2V0RGZjhuVHRybDlPbmR0?=
 =?utf-8?B?Y2FPQWwrVUJ4eEtoc0o4V3RFZUdiZ2RZRnhjQlIvYjBCVnZySzBXTnBzVkhZ?=
 =?utf-8?B?U1VjNTA3ODJyUm1BTU9VK01RQ21IaUZjODNuWGV1SGQzUHpKd2RXSkRLaE9u?=
 =?utf-8?B?QkJPY2tmNm0xMVF4VnhIQUxGcVJZMEZ2cnF5T0dmcnRLMllTeDNxdDE1QW5F?=
 =?utf-8?B?ampKdFhScmI2cGl3OCtBSi9sQ3Bycnp0VkFycDZqZFVBdUZBU3Zzam5EYmRP?=
 =?utf-8?B?Z3MvUWlPTFhFSzdzWDYrZVhxblRYL3oyMDhmeitSSFEwMkw3K25vSzN3Zmhv?=
 =?utf-8?B?Zll0S0dlUEorK3NySTdLRHU4Slh3ZzFJWit3b0dvR0s1dUNxOXJYOGpSS2Vr?=
 =?utf-8?B?TEtCV1dYL0prelFpbHY1WWpVVkZ0dUViNGx1LzRQWFdFVzM1Y1JGLzZSOERG?=
 =?utf-8?B?NzRFUWcwZXBEVm1zVWVXYittd1NSRlBRcVRKbUZiZjBCYzdFMms1dnhpMkFX?=
 =?utf-8?B?WGJnYVV2K3ZrOHdJTXR0dHhTdFAxdVI4ZUVKMXRTUW1ZYk5lTlpsQ3pVdkhS?=
 =?utf-8?B?SEJCUXAwRWVlMFdHdXdZSno4Z1ZxcXVVQ0tSZklWZlNEQWw5OVQ4U2UybWMr?=
 =?utf-8?B?Qjk1T3Jhc0FPK0hCN2FOdlg0K1hBN1dSbEQ4UURFZlJxblNma2xvMHJNOXcw?=
 =?utf-8?B?M0JNcng5bjd1KzNOcTYwbGlLUUdyOW5IZHZUOFdCeW5RWFNUZnArMHBOM0t0?=
 =?utf-8?B?Zk8vT2lIYm9JajhJUk4vdm1GeUNUSmNtaVJjaHI5TVBBOVI0eHpJZnJuN2xP?=
 =?utf-8?B?eTFROUw2OE5HTXVlYXF5ZTRYcEdSUXY0cWVKWDJHdi9UWEFSV0lZVlFTUmp5?=
 =?utf-8?B?Y0Z0Ulh2bkt1cHplUXBmSkNKTWVrVkkrZ0M0ZWsvdTFIUFA5cFprZ2FPM1pv?=
 =?utf-8?B?TUZnVUNNdEtzNnVFaHkwdHdEYzNHd29JbW1VUE1uejJxSHdXTld6YjVvbGVZ?=
 =?utf-8?B?L3JDYWFZeUVyZG9Qam9nRURuS3Y1cXdXUXZmVFFDc1VhbWNEamhMZ3I1ZUR0?=
 =?utf-8?B?Z3Y2T3VsRGdzRDU4aVJBWWtKRCszSFJ3YnZhc3Z2OFJ2NFFnSC9GRHNzdnlh?=
 =?utf-8?B?bTdub3RmU04yVzQ5YmNiRlo3Y3djd3RSTzhVdmF4dk9lVDRaTkFJZTZtL1VQ?=
 =?utf-8?B?a0h5YWFHQ211aTdXYS9VdGhsdWJqY1pDY281aVRWcjFkMFBhL0dqbTlWK3dq?=
 =?utf-8?B?VGN1S2tyWkI1QmxVNGY0M2dSanViM1hUSmZxUGgrcXlsM2Mwa2NDQ0RMSFh0?=
 =?utf-8?B?Q2F4a29Wa3R5WWhMMXRkL0VnN0tRM3N4RG1adi93REZnWnUva25TcXJRWGd4?=
 =?utf-8?B?cVRnWmpDWmdnUHZ2YnVmTW5sbzIxdkZraGgyVmZ1ZWZOQXBkc0VCZ0wyd2h0?=
 =?utf-8?Q?4PJTASde/jxLKYJqNehM7LRpU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1581e081-95c6-4d7f-2b86-08ddee6b68fa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 00:05:25.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPScDH4jnIAdiwstIDi8BawsX8Besihsr+iTD242P8UnmpT3IH0lC2XwWAGQd6G63TZ/akCs0SSmdx94Ocl4YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Stat-Signature: ynnicqyw8h6adwc6w3dbesndpmij7wps
X-Rspam-User: 
X-Rspamd-Queue-Id: E3ED81C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1757290021-831288
X-HE-Meta: U2FsdGVkX1+kJCgGtn9WyFWm2N8OtltO10EzlT5OSfOVAW5O1JdyLik8ZS/8qcKymQt/tNbj/kVEyJRag8V3TICbmO1iZ6j73jwN1Kc9nRUZMoHu01dxMUQZdQ6Xp5Kbllhq+TqcW1LwU/XyV3a6yRk1AzvLedb9ThJmB3Gwbq3bPbOAzq2lLGHlzpiM038Y52KY7jsj16BShk5WZEGfGmyY77/4GusM4bhyE7nmjWp/8VJc1PcB7KEiChC1VLF1xxHkCfZn5uIGu6zy8PsYyIJuQG4Wtc4viIiHYJKfuurKTzJH2IW8xE4VdffRAZwxT9RLNBhIwzmZsjrI0vS6S0iqExO5cEujyva0QQhDH3lPuySIJhIfVzK8fEic+dpdM1Th1l1CKSoNb6weAxr0KES6f8wIzMNfDai8OyxCLn0c83XKQy8pgUhGNYZXLPJFcoTrZhmqv9Q53MFbwaHVOHsPG4OtMUdhp5KglIF34CCkGOsN0w4HrFYEyvKY2fureNkwthgqiKVtxD9V+KDBoXAOsL2fsD/fOD1428/UE6v0tNm4Sj9giWzhSCstPnivMkBUaRUCXhTEeTzZMUcdWgF40d3ZPc2SKf1hMVDHMZdUs2Xm4STH2JvBQ8jJtOF+YXnzG1BQqx4yJGh2fiAqgk9RUpNlWj9Xa4Ap8q2LkVCvV5DfwoJpoQ2UhroKOLNi/u0D48CukiFRXy+Ofi+TMJDDenx+k30I2vXgkClr5BI581T8d8veNlZ8UYpo3pBFkI9reViaaiElu0sCCdQpDDaUhZe7VWdNWzkAbyLFwBUxkBNzKZd8xRcgdXjy6X1MCzT77gf29oJxNdr8CyHRbD472AtSl3rO7+CVlg/2pNpaDcuUxBOgJnXuFYHtUawrNQbeiZ6cYvMsO+IUnqF0xu8PkZMrHN9wXy2d7Bl2zRb2tPSfBiYzNSOKAyze0K3636Ip6j2GUDdUSPyzTkZ
 rwsEczM7
 SJh6qi3oNFb5/bNtMQxD0aFDxFQyA9BygE6cdOKhe4JkSr/KWaLOJysCaOyAsAmVaWW9GLm3D1TW1ufS0hwQM28OJkk/X9R105i25/3pNccr+Vr+oc1e8SkmkAZoSl5VL9hz7KDMxH2OvWL2bHc4fTtP5NQxkabKRVfaD/sdoc24s1lhlhtX1c15JsJ/JldXkAf06Liyo1ktFUHOZDRFHKhNsYLvrgvEdvFXfl1TX7eD3b0XoMCLkECVT35mWIrtgG6dNdQuBvz8dmMcBpromDS5jnnXePVRy0MmDZJaM9F+Dv5f4TBH+0rwQ/eIVMLhkHJnA33o3Sh4yibcfoARbOTHqvyLtPxfKzSiEewYMF+no8YIRn7Vb873NE+CvLCKSP0tGuPcd+ExbHsHG/vBR4XGnhWST1eY9Rxhy8DMW9Mr7bY8ez+GNlwb7B/V7xxqPqmTUwTtaUlpsO8g9c9v1V3+1ciZ5fl4DPf/uNmn57Mx70q9wBsDhuPhcZmb7S7P5aC+oAc1qeIEJLPwCiNbSdHzJXFF3Z8dflE6QcQDYIvqTPhQS5HtEzQlrQ4bw8hRjR5npFg1STgMvTd7R1k+wlulB7eTDNfD9EpOTD6YgbOUZbUs2Orlcv/vHsOpMK/BsT+H0tFMEJWXfm4qfen5t4Hxzxa6qvPLq4w6tuX6HhJTg9IpBd2MQT1FM/J0VuZY7FHm7as27hTJXfdRIw9DxqrknREmogcfPnTsyY/IEV8uvqiBXfISnjBaCrQbu6bZGh5+c2kh7m7h/VzuRT2jjByxEmy9dUrbY0KwlKF5HxaQUsBMj2L27pLBv/WvAsNQ2kDgRDBqsAi0Z7d8WG7pdHWUEwPb9HTsSvrXUbGJiIx6gts4htYO8RHvp35A7jV22za+LSjPbXfp3InNkQpuXN6s6tyHFpo0J2DRcnDav9eRJTQfpLoyaDieqtj//jBg4DdJKtTSWb5yLMKamLWinECk57Boq
 n575Nvw3
 z9pbA+FQ7jDtAJ7H1H+IIMA6/gTe9CL1MVfnxtYvXCBWBOe7t2+wRhgXk/QUZiSo9YaScMVWQ3t6FF4OPinC/i+PDsgQLBo0rqQEMNLF315dPvFmRsNkVQw8MRkHpF7p3Rug6SxekaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement CPU fault handling for zone device THP entries through
do_huge_pmd_device_private(), enabling transparent migration of
device-private large pages back to system memory on CPU access.

When the CPU accesses a zone device THP entry, the fault handler
calls the device driver's migrate_to_ram() callback to migrate
the entire large page back to system memory.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 36 ++++++++++++++++++++++++++++++++++++
 mm/memory.c             |  6 ++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 23f124493c47..2c6a0c3c862c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -496,6 +496,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
+
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
@@ -675,6 +677,11 @@ static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b720870c04b2..d634b2157a56 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1287,6 +1287,42 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 
 }
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
+	spinlock_t *ptl;
+	swp_entry_t swp_entry;
+	struct page *page;
+
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
+	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd))) {
+		spin_unlock(ptl);
+		return 0;
+	}
+
+	swp_entry = pmd_to_swp_entry(vmf->orig_pmd);
+	page = pfn_swap_entry_to_page(swp_entry);
+	vmf->page = page;
+	vmf->pte = NULL;
+	if (trylock_page(vmf->page)) {
+		get_page(page);
+		spin_unlock(ptl);
+		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);
+		unlock_page(vmf->page);
+		put_page(page);
+	} else {
+		spin_unlock(ptl);
+	}
+
+	return ret;
+}
+
 /*
  * always: directly stall for all thp allocations
  * defer: wake kswapd and fail if not immediately available
diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..860665f4b692 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6298,8 +6298,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(vmf.orig_pmd));
+			if (is_device_private_entry(
+					pmd_to_swp_entry(vmf.orig_pmd)))
+				return do_huge_pmd_device_private(&vmf);
+
 			if (is_pmd_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
-- 
2.50.1


