Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E29FD4F23
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AE96B0088; Tue, 10 Mar 2026 15:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152966B0089; Tue, 10 Mar 2026 15:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E946B008A; Tue, 10 Mar 2026 15:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48E76B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:10:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80FC98B1ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:10:22 +0000 (UTC)
X-FDA: 84531094284.19.FC01972
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010055.outbound.protection.outlook.com [52.101.201.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3E41A0004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:10:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q3SmJ8Bz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773169819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alp5fBNIXdfDNHa0bsIbkW2yAs3upBfyUtOzWvb+APg=;
	b=aXxiTaYHvx1Y28eSoCVv8LcHLLRTKm2hxOmwsHV81qPj3Y3yEBNaMCsWdHEtiYvFq5gmQV
	/dFCbw87y6KRIn29JXiZF+zFliB/Zb6yDs78iI1BaycBbE6t1qQHeefJGrEgPC0Xbf+H2Q
	cZi1u7GO56+TRX75qNv29glpIBG9QIQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773169819; a=rsa-sha256;
	cv=pass;
	b=s3p5jnm4eWoWEz/MqlKBhpRgqMaZV04Fn/6g/UmIuEtcgKjvpU8gJPDxjlyid7BmnAE1LE
	d3J9s9yoVDC1WFegmmtl3P0UIav+iEkslflhRD//gpOb+B0PB83iFX5nUlEHVa35bVaUY7
	ZZUNbp7F9tNjfIpocZt3p9idcXR2A/o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q3SmJ8Bz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YML8A1KnohPq/BeD3nZtK9b+qL8NWORjx4ZPMmOBzx3YVoAa72Ymy5ZmNbWrrLsZz+MNOgMOIsaGxcb2TmEXuaMro35fhFhe7BVYMxsG7XD40etMt075VIpgco6NmfqKtJ5X/W4R3wTN5DqKbr+GKNiFYWmNlzlL0RVtZ8xk8gQLtrrola4ihBOkoTEWYw7+/XiL0nZG1aM6Ad25Oum6g9AHCDWBXeXOiNZcZR3bEfxhUbr4tx+AymEffSm9NUKemXx+4FAK+3lMqUtP8q4VzOy4LjJ9Qy2LUXNF59VG+yUCytHRsEEmAFSinegHXbup9kEeCJXgjt2cKegAVxql0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alp5fBNIXdfDNHa0bsIbkW2yAs3upBfyUtOzWvb+APg=;
 b=EQCrpAeqgaTRQ8lpGBvFHUGgmV5TmvUbue1DZwnN021X91/0vVcRCdF/m1mF5uGYmCSy8uqBy9dCouraEtMBEkmO94zkBnpZvjYYWWwjWYu550E81IBfXPBzRYcIetnC4GcRczgCL54wGJj5e1I8SoV78NttRSJlFw6CatOjus73Pme62wuwlK3S0JHt5MHBncrdZfff2r7ZyI0BQ8etAaYv5vaeCOcbQ+ajH7fBxANtLXKvwi44EQrJCyUX5y3wekn0RHrSR5+he7ysnyD4bfKkgHEG/vgxVIsC4NUdIp50kqwbs4W4WAzS9Pzn98X4Sk2thbO/P7UCkhYf1q1YtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alp5fBNIXdfDNHa0bsIbkW2yAs3upBfyUtOzWvb+APg=;
 b=Q3SmJ8BzvUgybBqlYLSAGC74ijJ2M/Ekx5fGyXv61QlJecclTL8gLTfKK8XA+R4wxZLm2EHkj01IHWt6pjTX7BaHdtgPz9RgSzilxVJKgP670cxRc6wNJ+o8tjXYp0XeV23UJ3hi/+jQPKt93AjqK54U65wyYeJi9E3epAlW7VuO3EbgKUQCogNYD0132c+ji1zVygHFal1xQoF1TaLg6F1ubTcQfkMiUqJkVlO2iQuxjzEUxP9g44yGQNf3qcXrjo2YJ74DiaKAv7lVEgYBBIdHMdyaLYptxwUiujLxS0JdgaFyhUfUUjkA6zC6gkIewORUSSu3tOG0MfVl3wnC6Q==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by BN3PR12MB9596.namprd12.prod.outlook.com (2603:10b6:408:2cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 19:10:16 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 19:10:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 11/13] selftests/mm: fix double increment in linked list
 cleanup in compaction_test
Date: Tue, 10 Mar 2026 15:10:11 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FCDD7172-E942-4544-897A-26F3E4BF0AB1@nvidia.com>
In-Reply-To: <00fdaa3c84427958f51eaefa7603094a090fcebc.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <00fdaa3c84427958f51eaefa7603094a090fcebc.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|BN3PR12MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: c4f18ffc-e062-4abf-dde5-08de7ed8a9b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UYVvku/OUz+exsoSfNvOSQa1lLdunIK+MyPC/ec9Pxm25ZKBH/f1s8hEtYl1iDusNzPJcEG8Dz6nTLGHr8DSMmfiwmQbRLfWrtXvCJo2CmcPnli8XAKfO5eo87xxigqLY4exARx7NOCU9HwfB5k4/BxBQNx7WvHXx0IrA7jQOXdS4VYLSQDXMp3hETbikXz8fLuC/vuvHJ6Rm2ESGd+btCBoVV5fJdmz+49L6FX3z8Itg2VqBxz23Q0zt8jK/T4yKMpTc8GpuZ+qUPMYawsDdBkkKHhU1djTmi4wwbXOyDNjdf1erUXmxVN/Is6fcT6Uby72VN1hUcH2I1l/+tjI8eUXrDKAwjAhh27KzCKdbG/wq2/L1Yt7mFT8MpgzTvJCxiWHed1BdmvtKq3fSM2aaiAKpZdXH6gRqg8h7rJk+J9sOWWP7THeVNCjsQs95xuutcGonqCvBuY9kBykm71/oA5BXHsjYglMte9b+/8CtVLHbpiqcAiaIvrzW4dh2W/oBf13Kycruly+6hlSEmIGJaPtvLZzM6nT4VlYBRCFI7z0b+FbIrpUJA02peITnUOt+2kXhzOU4S9FvhT6l3nmeKT+X0078QsAiyeq3EYcERN1ImDR8tE36pJVQSKyMWhAkNxkN7T/P3uqU+D1GoDhaN+4meCwVr2gFYPJDsFfa92dUWV3iwCuG5ixwlR83GA7/+4T9wrQygoqRkzJcAlZTGU1ZoBnu9m/VQduOsAl0BI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dObrSzvl2pCcgS7FyExTT7dIFL1GySNhN5q+mUVR428+4qBMInpfPTwi6SJT?=
 =?us-ascii?Q?yDv8NsKTonZbPBRdFCcOfGqleWHLr4vSpNiqGgSz/OLW7jMNth3xauB/NZ6Y?=
 =?us-ascii?Q?S+sG/p8FKqLTB2IwuWa4s+v24501Az8W3zH66ML0Fr6pC+QzoyDrUmIdcfXO?=
 =?us-ascii?Q?COUOGZyGjXC/tbywckygwGi9U8+Aqra699pkTIkD/Z9a2zxwmRZ9Mp9DPeql?=
 =?us-ascii?Q?/YfmNf8MKPGuzI3BvxcfZH/thrIJlTo0kp5+dmR5e3dHzknPkz21/mpF2aN9?=
 =?us-ascii?Q?/OlwdlDBdUWBc2h+CAgc5SyYG38m2V93/lQIjkZSL2+TopJ3InP8mh71e+7P?=
 =?us-ascii?Q?o9o4J9vmDvA0cR0XzXpG1S+vTZZ7i4eaNpMuUCzkZS0Vx+gPx81oomR/Fodu?=
 =?us-ascii?Q?a01Io9oVUXr3lb78emKE3yFaDpjSOyLwGnoZALfXt+teZBXj4rt/qgg0rHrw?=
 =?us-ascii?Q?Pv9s0Sx3Newpfj7kYj1ItGu6eIrZ0lIhugQJVpf4Bc9K20XAxC2g/Vgi7Ne0?=
 =?us-ascii?Q?pRoUQTGFTBslZKuSuIfYvDyW7fJLBkTzXma/Dy29BE+i4s/9GdVe6HG34jLr?=
 =?us-ascii?Q?A3EPMpuRpiRtitNr7nIPvuPAK6/JocgVw6q3w1sTBrEeC+7jbxqggw2ZuSLV?=
 =?us-ascii?Q?/Fd5rflmmFdIFYkStItzcVKbPsmglAK5dzPBOFYRnnmixUgfkJQgKF9YzkOL?=
 =?us-ascii?Q?G6eZpyJ/rE75bejsMQLQT/6M5jLtwzUKHTUkSyV63cwK4oe5mt0af54TnoB+?=
 =?us-ascii?Q?gjPE6IVSG9ZJwCr80t6Odxk4xeh3xWdzUp8bAyM0mfa8+K2RSYB6lLpoangu?=
 =?us-ascii?Q?CPBWOMhUP+mtTI1Bxqh525RqSjXhG9kHE4VFqyAhKkmlz7vKF0RcsObXKu6B?=
 =?us-ascii?Q?fu5oLmBc/tGVmKKf+QbyOn51tpy5/oji552sLYly7pviLGhYr0ga2LveqKzP?=
 =?us-ascii?Q?coY6U1pigYQ7bBj6RCTVZy8j512hQWzlJHIUvFhMWpy6WS/aMaqYbZZZ1t7V?=
 =?us-ascii?Q?44YI7HWx8hSn0pt2sA5x2HoB6q+aziX2prXKRyIOiy5SMqI9mb2xSF18AJKq?=
 =?us-ascii?Q?XPmGpPKWaklmARV1uK6MbsoJ5Wa4Dw8EKH26SDUdJ4alScDTKXtJJhfAW8H2?=
 =?us-ascii?Q?CReSCLxJNZtniphG++ihfIOw0LszBH7Dr0n3TZlhUxPuRTJSqKs712rrETi0?=
 =?us-ascii?Q?Zi4+IPt2jzARH3QdTKdhC3hfKjB1FBgpSYt2DV+tZIDruEAEHotfraRi0M5a?=
 =?us-ascii?Q?fr9fYRZyz+arfPuHj9vGm3oyD3l3toeC1aVMxUTNh8cqfRBVidHgLTdZVTBZ?=
 =?us-ascii?Q?mkJnuz7hByMjx4KAjMz3lyolFlJIyNagVj8RI4FCAIJfMoFxCOhDFhMwMRM/?=
 =?us-ascii?Q?1AZYztjZiyAzkeiQol+lHGdDNd0gFY46VUUQvprht3duNrSUrf2PTmLMe3k8?=
 =?us-ascii?Q?EoU/LWRzldSE3AbzyFJsDyNKiu925Uy34emR3FclMngSQyMDOE1RP45ohkHT?=
 =?us-ascii?Q?jYxtbmOpX7IPyuIAQaS6VFQtuMnOEahejCY+ngD6HTn4nVCd6sTv2m6U6xqU?=
 =?us-ascii?Q?rnNfqq3Gw5DsTei/4Zp3jyjiuWx96cnsgtZPzn8x8U0LnSK9KwmfWyZBvbWd?=
 =?us-ascii?Q?1+kmG0RrOI66d9zO4s353rmCz2AIHOxaC6or4xT6hLTjGGq+glKbeR+7xCgV?=
 =?us-ascii?Q?YrMobLNuRKYOvEI57SWaN4NWw0sBL40Vt+S9RPjMHFy/h0m93M2CXJm1DeKg?=
 =?us-ascii?Q?9jikXL/alA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f18ffc-e062-4abf-dde5-08de7ed8a9b5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:10:15.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKDsi+ZVrtO8ap56o/diny6UfLsOKR9q05tRV2rBkhyvpMDZmnnSmBoMgbQ5Fgwb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9596
X-Rspam-User: 
X-Stat-Signature: 5ej8bef43uz5xa8g8h47wi7gax5wzzzp
X-Rspamd-Queue-Id: A3E41A0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773169819-210549
X-HE-Meta: U2FsdGVkX19EHH/yzK6LwW6kH+67aRuZ0zuh7tpdruiT3PjwgAiQrMEmUWW0oDsssUcAL0djeG5AdB8N6hz1f7m67VDJKk9kncaB7WbH2IfrcH23yaaw+Lzjg90EDgbmP3i+St3rpHeZC7ZJKQ9wVEy3qeOH2nL5oa8AM3A0o59LABYXGL7cMVHyn4pJUw1jbRLzQ24erF/GAd0Y/d2IcOVd1TPij9ObH+7FZ0ufU+8kPzauJbHDPM3ZzT1r3TaiUf50ZS7FIf/onnYt5aIP+wsZ8GzRjZvEdYDOJWJj8EueP4an2dRt++M+3WxRzyGRbjAn/jC6gS1E26RGESJwqI4zn75O+A1dphXMvwnZJQWMXecA1KC9r1irLiLMtjgBNNJ+nVxKn3Icmdf5KZoxTj4sZZNUYG12lSifmDGsy2yBThAQRTNFirrLZXsaJW7DkFTz00vvq/KoPRsDGv+v/pEeX1ncXKz3s+SgQ2ltQdiLjLDVl5Fd2DJCBKy5iVn91kXbwLoMKETzTwV8TKn/L0mZdfDAj0qOOIbw1eDXPiF71InM9sVpTwghXY7UxFLWTpxO4dvFjp4mw0S7oYHDqslAefIr1THHWDcMqty3jFPXS8xangjSLy1M5eog4eE548O00b7xcdgQTxW4EpCfQoJnu/Z4b/BekncLaLXyT34BnywnKs01hU3/VNhg3UQpC6AvCB9PBLBxRFNolenvRjLy1pMOLaoAnupYypGcUx7kqC59LHJ0aDdaifjZpUS3sRaqG6ze6D+A3bfU6Qx6/ZoGa7UQwnADV4TQWEOwtmS6/in9F+//37UoNGcjRFdDPLjdfJAR/fTWJwCxmgaSEfnTw1lXldNf3T6MMFe/9ecwlby1kUvd3YfQGpxjCdwap24adjE16TO1gN/TrW39Y+OeyJfjov1sdDEyPIm+nAHhQNdFR2qsRN/5QbSbo4sK2Zv8QvY7OKFwzYj1N5S
 +tmaRswo
 QpL0j0o3VPix5xePPJvauJ0NF9Sv+j+ua7CFs3Y0XEWCJeNFejygl/dNyMxiIsv9ckWZz4QVSPaH0zPt1Ro+8kaO64dUgc67yBS0ktIwqXBodow3YhEcAedy8PYh7x7sK3pUmby45rYWKQyTKaItOHf71PFPycLwNX5ZKJRJwE+KDftKE/y66NnIJgkChPX76dY6m8upVVU3NWViUXQTBdZ6t2IoMZFisGB5UP4Ev6BBcEmZcBO5lXQA0q+jGypP5WaGHaD+mjctPq9c/6svWUxIYDKR1ck17UHiH5ofP8jEPp6sIqHeZa5gEhFyrzw/hWS7P0l3WUjUvC+myNJATvS946ESZWoS7xoSlPuQpkV5aEc8eU1kRvjN9GaAmu9uxCvvMgSxSPxnXnXbcXbIR6UCE+R7AiLFRJYFdZRet2S2YOOsuxHT6XplR+zztjyPI5gIddx58JGXjwVPrcdWL6LMvKsmiXUpXH1kZh85aRfQvHW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> The cleanup loop of allocated memory currently uses:
>
>     for (entry = list; entry != NULL; entry = entry->next) {
>         munmap(entry->map, MAP_SIZE);
>         if (!entry->next)
>             break;
>         entry = entry->next;
>     }
>
> The inner entry = entry->next causes the loop to skip every
> other node, resulting in only half of the mapped regions being
> unmapped.
>
> Remove the redundant increment to ensure every entry is visited
> and unmapped during cleanup.
>
> Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/compaction_test.c | 3 ---
>  1 file changed, 3 deletions(-)
>
Thank you for fixing it.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

