Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43287D78786
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540946B0088; Fri, 19 Dec 2025 10:00:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDFE6B0089; Fri, 19 Dec 2025 10:00:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4E66B008A; Fri, 19 Dec 2025 10:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 281AE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:00:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF76C14029B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:00:05 +0000 (UTC)
X-FDA: 84236530770.07.B54A8C3
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7DEBC0019
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:00:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rrxphmlq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766156403; a=rsa-sha256;
	cv=pass;
	b=a0MZiWnenMes0TJO8FHD8YwnSi1tU6ftqBwyhZhFNW9/CoS0/Cbl1OxiR9gZgtTnYtBYaJ
	5wo63n429mDvByysd0Fh6fK4dBPS/kcm+d2s4mrPpAe6UdUtwqrZpfRifGkusJuVV2hJCy
	Xv6aIPK4+b1zNw9/KccdMrJDkeXBHuM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rrxphmlq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766156403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HA+G9KM4tvSZKeBmBgJnn1mv96flO5unj1kyfH5aaIY=;
	b=idL+5TGqfuhJraJSqlbVhcHBpUVBYUU6OD/pKaeFUDeIIiNUo/Kf4EW74jMboc8lT2g2wV
	/thlue2O1+/klCZIY+O0eyue8oE2Rl6YerPQ0TfSLgNy8Bc9qFzTHCAXFLbstgV/PzuGFR
	Ngv5X58IgUVkVh1sTtNVaAbHe6oNYN4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQ68UbIpZ67yQuCL/XL7H48CldmU30XlgrpWD0/a0CfPc7kjSvfmG3gricAt2PldWbaTSyX06xkKBbtv/p/USBfEWkeD3eVehd7iJDO6yTL7lRGiDmbcqeKeUXfv5l5q8ycOu8FmtsPBus6AFOxQoAUE2otBYaT16Rcxeo2BfHZnqkTJ5pyrCNcoPz51YXkglZAzIfTgmh9LWJeFkBULABFGwhNuIlSj02rVsULJ2wd+LG1lM9aFZsydKjKOG6naLvTXE2r7kWxf00e/gmI87SQDy/r3ksTF8s2LzzXqogoCsPXm82KkDp+Gh9Rq+x6RXMKIrQcI89l1bSXKIfz+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HA+G9KM4tvSZKeBmBgJnn1mv96flO5unj1kyfH5aaIY=;
 b=RPLd096EpdPG2bktz0G0voduUS14vY7DxPxtWCzkCE758nIX67kgxh46lORrD/9LlrKdZ7m7QKXKcU2vPYvNcTKIs2R2uph1ZXJitkytOiY6V5lQUtTei4pVFJlCtq+G30fG5e3OfjmEOwSYy4zxAjYHM7jdV+lgGw8BfmUyUj/P6agDtV/sqZlXNhGXNlawbhJ5mvO3q6jVE55brup15Z2DovMNvn0N5yZsnIgwVYFGJ7MOHcFf0hXrk9IlZvOpD86WomiaFBYFUjmwQyB7Ce61p7x6O+B9zTxiE/6JO1guDjWsV7oy3zxemd/GoDHvskIk1+PK8EGZL55NE45v7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HA+G9KM4tvSZKeBmBgJnn1mv96flO5unj1kyfH5aaIY=;
 b=rrxphmlq571KYTfJZV076kLMTUtHqnQhjofJlmWrNtODEsus+x6oDn9pHhWIkPN2gNTr3xj5LU/G+CyX/N1qOwmplT7WDoKC+/1onjHpi81dJFQuvH+SnaINBWPcb3WpsdHdJOJIMxgBWEbatqpl8OveWQKRSluD4+w+jGLjD9D0XY6hv9NXFF9oEvF7Bk6Z6STnNxbuiHS0Wn3Z3hXNrklbSKW7KmyyYEn5YKGZcOGaOi/hriXhlGhqFGzI/au/c/kJCouQ5M1TFOPMGQjuAAP7UiIAW202JzKUwYdam2aQCWaPtcDN9h9/f4VHI3sPfy2/3a5TXZTc/8lYuOmXgg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 14:59:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 14:59:58 +0000
Date: Fri, 19 Dec 2025 10:59:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251219145957.GD254720@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUG2ne_zMyR0eCLX@x1.local>
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a8027b-8159-4c20-7366-08de3f0f4714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wqb4DR0mLNTuEUQi49hMQcfafTtIrP3A00Uv/fcrHTQOGgkO4g4audgZEw4E?=
 =?us-ascii?Q?vfKTj3RgqkgV52oevwtsYm5mta1HgpWXQb7K0BVxasdwkQ2oaKeEhqZkfWSK?=
 =?us-ascii?Q?wL9wX9jQXZduciGnWuSWDmrqKg3T3L5DTHMsouDAzhkUvrsxbqLRlHhcYm4e?=
 =?us-ascii?Q?daTP/QFMTGXQeNLfRPaMSPKJMXVBh8aKMNI7vMCif1tP2mtgJVT6gE1eWMR0?=
 =?us-ascii?Q?wcFIvuxaOoZfCo9jk4+hda1JaWTpPGiE+hhIN7DT8B6veaKq/P3vxjs99GJO?=
 =?us-ascii?Q?tpqC9+rcb07nPoi9NgWQkjQyrxmW4BOErolOpBSZo0PtnoysD6Bkak5KUuMN?=
 =?us-ascii?Q?DymI07vhJaFHtAjlBHMQKYWsm6LWp2WLqAiOcofvyg5wq5fN7X9l5+VmPQZR?=
 =?us-ascii?Q?+oTjILm5+g3QuiGf0oS9c8BVFE65nWh0IkCdA6gmAccOaSnN5sGZvMPpgDF/?=
 =?us-ascii?Q?NwF2KppinyGOFnggCpupgzui37BvmozRzFCBcHSTW3dBVGBShhVUgmzSUDSo?=
 =?us-ascii?Q?DXNx5vqEkK5ZGaWnpnLxMWdhYS6YZq4LP3gVYntEkVC3FQMKD8I3zBHOMW+F?=
 =?us-ascii?Q?7kBa1CFnaREHk7lNDiEOBPJzvLN96xHuRPzC1zdhZY280rkq3JXm3PxHhcfY?=
 =?us-ascii?Q?b592KquFOitLDtMxURHdswsSWFGmFhJrpsUvr06SAdcz9ENLs7EmuO8oQtf3?=
 =?us-ascii?Q?cmq1m0Y0Cv+pWYzgTPamuhFtv1/gb4SF8PNJ9iDJcgsUOYZnTAX+zupkVcSD?=
 =?us-ascii?Q?748SM9+7HP4rVp8rls/VH1RKUo5vC/g3qYSiDe2FRxl2SS4DF0GKwJk79lVH?=
 =?us-ascii?Q?RFeo096X939ihPNCG2YoLf/eAvvPL3fSdhqQBS7DH2i9jP0nsC7JCXMMJM4C?=
 =?us-ascii?Q?2DaJYQ9fkMxPpVHvPtBa1K7bxTkN3fIsXznt1mooLzSn/FxwE/WZV70Q+dZv?=
 =?us-ascii?Q?ResBPQM3O/xz2Lree9YUVWS2HaUO6/xskcseVUAKRZJ+vko70kraXst9wM6O?=
 =?us-ascii?Q?vHiEgOb8Q/ipXTj3kt+Ggy6OuDAHPo+gxYRkD5JPxSDeUuct4oWY/Z3oowNJ?=
 =?us-ascii?Q?6LwMdQ7048l2jMpWl4NMyu+vWpWui3ungPgfrntL7/ZIyO7b116xFLAcl/e/?=
 =?us-ascii?Q?bLyp8IrkO8hoywYPiXBwulMWMj8mg978APMCquUdnhkVzG0XWAtNxeORno/z?=
 =?us-ascii?Q?d5FBzhLBceAeukXYaW7H1E75rmJZoUReXBFPHOgFFLBTWzPpejjCA4gZBkvY?=
 =?us-ascii?Q?2HV0Rm5rVhSkJun8HZ5f7ue7qvrZK6qrn1YjvmSfB+mag/dAOIGO8L6S+Lmm?=
 =?us-ascii?Q?IrRzGgo+7XVhLa7G5wS5xxoSyUay1LYvVcMTWwB0kG6GX2X141UjhJWJD2vr?=
 =?us-ascii?Q?Yd64FqIMD8OYNWwO+QpFQjVb8gUTNkksuXnOYqeOkAfylcD+Gfqes/BYm9D1?=
 =?us-ascii?Q?OhO6t1kV7TP//pXlnoLA86RpkoOtbbN9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zTtiXAG4SH8dWqsnM4Kxqnat87bpmqV7J06qV/TYoVRsb7WI/G2UNGwj42u7?=
 =?us-ascii?Q?5WkOMEGyr8/qzmLbtcMM3BW+xF9+PfzV36FYD7cXTUB3qhQKYveVsZfV2CCj?=
 =?us-ascii?Q?WIMsFZ5ecSa1c9jfY44gLjaKzY4UuhnWliT4g07XVOBu8QjArGLsBIJrQsk9?=
 =?us-ascii?Q?uRISzriZ3ZsrnDNC28lT1Uj+HdJDFyRISRu3KKwZtD+No+HU+upm3gbv+X4r?=
 =?us-ascii?Q?4q94UrLux6mR5B1gGeTvfTAmLzGsMzpAoRTnT11Yn3a+w2euJhdFxsTSrBqH?=
 =?us-ascii?Q?pBFE04pu0jZ9FA7dlMHDWq9fgEsc0A/2PCtBzxfHWMKCmYR/GcNlNMIYDzJA?=
 =?us-ascii?Q?QXhwnEl4JdL4rgkVkcTZCXi6zPLOIlFAyUlEQWRdEgzKAqUWTdl+sTSBov/V?=
 =?us-ascii?Q?ud7TfNK/4xrB76mSGYce4yXxUWPSLYq1hVrZXHPOwRRKTlAOLnvuVeswBQJg?=
 =?us-ascii?Q?bOqVgKsSACYhXpv0rtBz2FwpiQsSscTC89kPCBs+p4gp0pYJDzw6tISgJJIY?=
 =?us-ascii?Q?kf7z7zSNaF9AEu0TWjgNqY5iXsGdvcmkL9zXHiPDCPnN6Fq9p2KwblgE/gl4?=
 =?us-ascii?Q?Isf5YlhvDCq5r7oYZUTlHdHx7kEO+ToSL6WVzqUV2Dh4T5+ZydvMvOugl8jx?=
 =?us-ascii?Q?Q1qO5+DPAXVekxq8wHZQMrfy1Kw9c1HCUn0Uh47SWxAtq1Ggptv4hp78Rs/D?=
 =?us-ascii?Q?S4xOqBU6KI6PtdC6Lo2KZZDm+EAeSgWUjZlnzOv/EuXrvE5Afa4JeafX+bZc?=
 =?us-ascii?Q?im4IJFU5UrycYk0nC0BJzJ89FohyLsDaf0Sl26en0lMan7pK/q+ufUdSGeil?=
 =?us-ascii?Q?fhoTYh7LrQO9V9PEb4HD+L4kqCeJiSVweFtq3tw/XvtD8qDEx/II5Yy1Kirm?=
 =?us-ascii?Q?JhcYtFTlPxAmra9amcCiWQ+WhGBf2+pHJeWiVB8BUSVyYhC5iFO+gHZaVd49?=
 =?us-ascii?Q?++7d1tPQ+cEZXQdx5HQeBUlbQnICMI1nsYWBWnWPUHYBg3yCwfgyRd+LMCi/?=
 =?us-ascii?Q?DzAyq2whcM806dgpCWk/+C0jOaGRfRjHseP0vRaMA2xvCSBgX/oyUsthVWy2?=
 =?us-ascii?Q?J4LfLfe99QdiMcRO3x6S2TFLonQOSDJrMA8AG7do7rnTrqi1XrJOlpWbVOkq?=
 =?us-ascii?Q?rN+AUXc0WeS7FngxFDOyINQcR8iDVA41rDsvOp0FIfIde6z64I56QS74OQ3I?=
 =?us-ascii?Q?mcbWrwrQl8KdonVdkIhgjI204I0/kqcIDcQjO368cEO7AIcxJXg/QJD6dkL5?=
 =?us-ascii?Q?OMhgp30QH0LFdjPUdC/avrjLER2bofLWnO/xCIdo38ZMPQ5qWJDrW3I5ViFp?=
 =?us-ascii?Q?tMtpnJBt1Q68p/SdW0QMz7sdXMSzMvx0M8AI8SBF2TgtB8lxbw0CyV0V1nJA?=
 =?us-ascii?Q?2KfTv+t+SncE/gewdZOqWjS1JwarytVZC/H7FH1e1VG19Mu/NU5/vF6zq8br?=
 =?us-ascii?Q?IjbnALusad4BxChf6zFQARCTFIjKRYoyY6iw494xAKwIJC/LsGF/0cqa6l+7?=
 =?us-ascii?Q?yj6y9fG5SVRDW3wVPvi0LzuZn7JCZc6NjEu3J+tl0E/nfT6OkKGmJ/VOktzs?=
 =?us-ascii?Q?XPbqkXRvyYwizeQCaRQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a8027b-8159-4c20-7366-08de3f0f4714
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 14:59:58.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lGo85411/jxGKAotUf83ifYnH66NDR6RCrFs+ONOmthf6O9ujGq7nxbBKfvVaSp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7DEBC0019
X-Stat-Signature: q6493snkgbfmnyzryis6z88pfwu5ejru
X-Rspam-User: 
X-HE-Tag: 1766156402-494015
X-HE-Meta: U2FsdGVkX19U/wvM7BMp4KRRwF8X4UlaUqKhkcxZhkjlVsV9b1iv5jtfHQg/EcTjt5yKd5Zb6zwTSUZb0ve2muAcs6pOF6OSTfCrG3mOBIyGB3kjwk71sYUtYbKQfTLsYz1gFkE30l1dDc7QFfohW4VHOQiV5TJVxbOAVblzsOV6YI9TkNacTIVtRSYq5b+jv8SN91GU7QRsRxXBi36EcwIFwFvBHEn2yeaOlq0Wd3Kj9d2l9n/+TjLBdRMLCYh9a8dJriHmQ1rwl6McrM8y9HWeNqf9Z912CblG3iiccZ6cx4VzShIQF5OyEgf7KcJYr0mEiT1bXwlrEIByC6SqXo8dLJGu+wGlD/vYaRe8LUBjRUOKmd19lZnn150qg4FJ/L9hdw2zJb25TUcA/cnc3InouDb9R4mn1mV0ulgtFlQPqD9kjYMwF4YrfH1kDLdWwJ8u7vnvGmAUKASmT5ygPlrd6dlnK7by/ZJ526FntgKSh1iAmM25+NRspmkC1Bqjm+p/e/WlOQfD+qSli3pxG3YWiwcZQzeCj/Jph7yYETG8YXJUgQD6XrG9ckbvL8a1Nj+b47qx1SB0tBCKAJy/fa/hZcPxtdnWuPsRZwVUD3w2xg6CP6VGV7+Kz+J403LTyV9wafHnhK9njY+gSWT5c4zbnhA8S2lQqqq/lYTxyZktkEeVrH1GvK7UKAXHNRXkOns8oe9V1V/19sxsL8kOoZ0VpnNGUIqmeXSCEiQvXJG/4YhAGyzxHcN0kFurZO4GKpu88qb5u+E+Yk7oc2QsrTK3Qxb5Og2smBL2CqJG2phKI5g/9dbAhndON/rPhDZWA+A7ugCIc2aft2oxB08iqsQQ1x/cRTgzA8K4VpwqwF6P8p942lXgmDTjmnfE6y/xQhR5zHRendHg01pRUxKQ0KsK/0jUX6YhVSyNeJHMYw8nX88QmGmUMamOxPJXm3SNScnSSW5vwLy1rQo+Kbk
 znRAa0nz
 1yFKmCVc3oZMUHP7rXCq7bH4BeJahM+X/ICfuTMVyE+HidDpNiR+wxC7Ga1Lqgef98xsgoLk8nmKrm7UzsrMn1Js6YIhqKPQohdR7EI68Lqndipu8JoPcNoEx/gbbbrxdWBMLx0Qa/YxkTW+ZZBNdyFzGR/Hyp1Dc0lVaZm0Z0z9L0EickLFXyqdE7/+pKdtNCLUNYb3TfD2x7M65fJjF8aD0SOkhgIo4Ket2ZoLJ/zPlXQg1Msc5n10ynAfmvfZlwj5SPAohtUjcD9KRLMIru9BGM/wGnqI2YadgmLMRERADc6yw1tYxVARb+Q5ZaLyfp8JHCJszAprLWLWx4KrERxw+lOxFg8Vr2S9yHmhLlIbBjuVCsLVEHbEzmSUrdUgLvUEiJuSGWg4HMVN5IAs7MQvqSpbl9hpAmtGSxn8crDb69alNl25d10p++tfXPi+y4B+uDV3mUKJPgBtTHtXGjXEtVtf5RUdyXLqq2+AAMLSx35jVRYEvBTXZWU/a1MroBMmArNAPwIzyVMBf2G7zgEO31rPBHsYUY6txc7U3NF1pKs0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > let me know; some example would be greatly helpful.
> > 
> > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > for the new op.
> 
> When it's "related to PTEs", it's talking about (2) above, so that's really
> what I want to avoid mentioning.

You can't avoid it. Drivers must ensure that

  pgoff % order == physical % order

And that is something only drivers can do by knowing about this
requirement.

Jason

