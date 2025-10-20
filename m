Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB00CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3E98E0021; Mon, 20 Oct 2025 10:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B078E0002; Mon, 20 Oct 2025 10:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1433C8E0021; Mon, 20 Oct 2025 10:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F409E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:06:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B76F9853C2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:06:05 +0000 (UTC)
X-FDA: 84018666690.16.3ACFB46
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56D8BA0015
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:06:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9R04OyR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rlyGfNii;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760969162; a=rsa-sha256;
	cv=pass;
	b=EM4X9eqEQG5k0BaND0tFkVaA1eIhQaI+5jht8MTnZyKQqeEh+dBuhICEZJMoiJUyGMh5fw
	8yhCGw8JV7N/i7oK7n9T2yEuCF/w2tPRgKmR1eOICSeNYeuqMyOKf6Oy6XuqcvjVqa5HEU
	cHRiV30sQPYcyYyn0YqknlA7Q8/ZGaY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9R04OyR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rlyGfNii;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV0ZaeTtDnB/zkQUN5OijlHhW3guUCP+js6/H0VS/A8=;
	b=gwnjiVGZftiqm+J+9MSg8RuzZ/EVErsrnYygKLe5tPiTeQA/2v7Wu1ScOLktrJZM5kX7wm
	T1DRsQBMvw4oASKM1JxvsW80VqmC+fsMccFOjVupeFJabmthLsLo9dsnJuFxP2mK2cxoxh
	WVAwEy4ug/m0/zzkyN1tUHuxZH0x+uw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SSkm018474;
	Mon, 20 Oct 2025 14:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gV0ZaeTtDnB/zkQUN5OijlHhW3guUCP+js6/H0VS/A8=; b=
	D9R04OyRpObMQD6mIkJJFYqWjebE+OxhjGHLGRGj4hnbsZ6g9EXNXZbAdPSzQauk
	pxKWsL4j3ntS8H0P1BNXjdxTwDbXumNtdWIvu7LuD+6oeoyPkSvImaJ5i+fxCBMs
	HDu/b9ZKm3+8m+jn4tqPA8HDMLpD9S8ElrRrGxa5AU3JXr99W1cRH+hK8zaelyg2
	c5TE4EL1+vFHDVXa7FQf0Tkg0NBpJOhjF4pJt/Y/Xise6V0nHV0DaXP+l6/KNCSX
	6IkHajlXLNVB8LJ0qrkibwFVlmcIPfizNtJv94Ven2Gl9HHD1pUr4whaK9+wdO8+
	m/SXjCAKn8z49B7B44tQIA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2watbg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:05:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KDOwcD007205;
	Mon, 20 Oct 2025 14:05:57 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1baycnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:05:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOmH7IXp8gvUaYfGppZjkviKMOda6juDOHT/XWykhDMCJfttB7VeNRIk1KpnkN5uQNCCb6p07Hu/mWaybM5BycuUrSdHVqhY4/EufcIDaTz2skJ9AgPNrYWdINYQMRGYa+A/o2EdA+Sqc0ZJ9NASk4T04FFRtRUv+jFY9tVuW38SVYlCkUlM2Dg7LcZFVieS/t37P0e/hYIwaqjfShnt0UD48EYi/iv76SdL6hMLfOdVY45yX9YgXjDw9+SoDH3rF2fw2fwE25cEW/vR9ncefYBAubl0IkDd1zw3Nj35VBsS3QZTJdclROFZA5jLnOR11d72sUxXzwtwi3VWe0xpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gV0ZaeTtDnB/zkQUN5OijlHhW3guUCP+js6/H0VS/A8=;
 b=KHf6RD/TX5fzZqOJvUGbi108hWyFXhZKW6KndGlPUUwWaDgl88KXww7uf5d9PPbeIJ+LNopBr8Nf2oL6ZhxWGqpYEhWC+ixrFA3oqXVDc6tDFGoSwh2S1gcBCBxPdEX+cuMj6Oog8EMQnpQfLe8A1X8jeJ6mGtvqKKr3wD+/x+WfZaaDel5CoAHy/VMypRjGX/4a2Br7c0tz0hBUT2vNZJJkymWm0jD1F8s6QKdfRL5APT1VWC+BroSIpkWCQ0SZjQ1HI6MIKLjr/xC0b1jFWHO3sIqqHvWkz4wWJdtCDd3XEyuYFLfhmL5eqgRmP+oQkDvcm0iAzlsalDscjgYI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gV0ZaeTtDnB/zkQUN5OijlHhW3guUCP+js6/H0VS/A8=;
 b=rlyGfNiikKskgt2dC9knEuTB24MX4FSPbSQXTvLNynroI3gmTXe+f3/S3UBH3UKEAzgL9A0Fv/10JhOlCAV1C64glUSdEvJkMEy6S848SNyzPUZj9CmgfhTjWy8eyEPMwLFGxtKU1mAYWAMT4Z+7dfUzz77H5eTzN7i7ug7VGhs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7229.namprd10.prod.outlook.com (2603:10b6:208:400::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:05:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 14:05:55 +0000
Date: Mon, 20 Oct 2025 15:05:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
Message-ID: <ee54f8e1-0b1c-4db6-9773-7b30d18c0515@lucifer.local>
References: <20251019072509.9488-2-harry.yoo@oracle.com>
 <20251019220737.1431-1-sj@kernel.org>
 <aPXoJWM8oC-P1a0q@hyeyoo>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPXoJWM8oC-P1a0q@hyeyoo>
X-ClientProxiedBy: LO4P265CA0196.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: 7300e932-d0fe-4ad1-38cc-08de0fe1c947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVVLd0V3T1FRdDNrL2dmYlQwUTBrK1ZiWGNqYzdpSFozZFYra3FaNnVvSUNM?=
 =?utf-8?B?VTJWSXJwU09nVHhYRWhrd00vcXBNU2dlV1JMcFR4eTFMdGhoT3ZzSnpRQlFE?=
 =?utf-8?B?VjQxWTVLRk4yMmJLbkdBb3Azd0tTakVRbWRJTWIvQjZ1Y1Y2VkZWMkZnVkxY?=
 =?utf-8?B?bzEzeURQQ3FhS3VLRUJvb1MyU3E5RkhkcXBnK3o3alJadlg4Nkk2NWJLai9R?=
 =?utf-8?B?aXQwRGRpekNaaTZYUzFTY28wQjFYMTJGUVZwOU81MElsdkNzTzNWQkRYVHlN?=
 =?utf-8?B?MEFUWFVjbkFwOHJ6TmlkZ2NTa2Jad21JaE1LTDRUalFiOHlvMDl1ZEZxM2F0?=
 =?utf-8?B?MGdxMXZveFRyellVQWxuL2FkNFBtdU9EV0piZStqOFZmZHdsY1BWYTV4NUhs?=
 =?utf-8?B?VUk3RXAydWV4L1hBMm9XT3dpT0h5VU1sYVZmemdXbkVnY09nUk93VVdRWlJJ?=
 =?utf-8?B?TFk4eEl5ME5icHBjTVBxRlAyeTk2algxelI2T1I1a1NXZlRJbmpPMFI3Y1BQ?=
 =?utf-8?B?MWcwODJ4c2gvZWtRbGVXR2MwcUdYeXBSMUtZMHZGWVZXbXcyaTlEdjRrRG8y?=
 =?utf-8?B?ZkxXRm1VOTBsMXgwV1pmTDBWTk5qMzg4NmZEd2tXN1Nzd0hKY3JiS0RCaHRT?=
 =?utf-8?B?R1JwV1ZHR2VsWVVOSlhvTU54b25hNlBwT1pVLzJLZGYwY0xnR1doTEFYNWxG?=
 =?utf-8?B?OXBCZTQwNlMybUpUZzJIQVlXUFllcGIzZ2V5dDFsVGlsSU5hLzhFb2drK0Nt?=
 =?utf-8?B?Q29sZExrelpOMWFNaURLOHFueDU2Nit4aTU1dVBKb0o0T2ZNd3hyMVBqb2tV?=
 =?utf-8?B?S0JvU3FEVmI4WW5zWmhGSm9xVXZoWkMzckNuSDFlMHpvYkQ0cDhoQUMwNjlk?=
 =?utf-8?B?NVFnN21FK2M3NUJXRFBQSWtBdW1Oa2o0ZllOM0ZZWWRUbjlDVkhQL2RqSTcx?=
 =?utf-8?B?dVVmQ2FYSEkxcmpEYkdlOHBNSm1PVW5RTnQrSlozWFk4WUlTd3ErMU52UHls?=
 =?utf-8?B?MGpjcTVkUVMzV25Jcm9KT21JeVlTUGhnTDZRbkI5T0dmZUVUOGVZMkpBYjd1?=
 =?utf-8?B?SjJFNEdhVFJTYWNleWlEaU9hL3IzcmR5WW4wVldTZU1oYTBHV1JvUGF1Q3c3?=
 =?utf-8?B?RUVDRndTdEdXV2xzMCszREg2UVNjRUNEcklVTW1UcG1HV2JaWTBZT0tXUEJh?=
 =?utf-8?B?VHZYSjNQR0VtL3hYa3B3YUU3TFY5NzEvWEliQmRkUUlKblhPV1g4OWJDUThJ?=
 =?utf-8?B?b25TazZyQ3dFQWdXdUd2YVU5VG15VjlieXpLbTEvaFZiUVcvUUhJU3VHdjZx?=
 =?utf-8?B?TmI1M0d5Y21raUMvM0FDekFnVjNzM2VNRzh4TUJoTnlpUGs0S0dFTGpZZkQy?=
 =?utf-8?B?anNmMXVvNGJsdzg4R2F5dVhWckhuZnVTNFlVWFdnT3NVODA2cFFOUVl4MlZl?=
 =?utf-8?B?TndoMzJRYzRlYlMwZU1BQTNDcXF2ajQ5ZXMvVmtWbzFMQ0MxcFkzSXRrWG1i?=
 =?utf-8?B?Z2pWR0xQdDE4Z1RiR00xbGxUd1k3ekNQR04zeVBEMkJvS3k3V2w1TVZWODhk?=
 =?utf-8?B?c3hHY2JSNXk0ZkJkWlFJd3pURUNWZk9RdnBuNmVEd09RVldTNnpDV3R0SlJJ?=
 =?utf-8?B?U09XNjA5Uld5bWxkRkwxcVR4dHhoSjRIUmRTZUU4bzRGNnhYaERjZFlmVEk0?=
 =?utf-8?B?dU15U25IMVBKbVVYK0xjVXdKeis3a2UvUCs2Q3FmdEh4aVNsamI1WFIxVDFK?=
 =?utf-8?B?M2FGcUZBWmVGQ0FyR21sZi9CeHc4aUdVUWY5allsSjZHRW1YOTJUSlNXWjZs?=
 =?utf-8?B?N3BaTFlDRmVMUW4xMzFhR0JGMUU2a0M5TDMyelV5bzJaamMzWS9jMmovSjlQ?=
 =?utf-8?B?bnRkRHR6R2FaZnlKcnFJV1VmaU1xTHJubk1mT1B1K255djVzTnl3cHVlT2hH?=
 =?utf-8?Q?LiC9yxsKYBMAg/Sw4/hl7ELcZ21IwQTf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWpnUGtLZUcxUWRTVEQ0T2VXWUhpemw1VlhlMEk4b3gvZ0ZodlhnSWJmWHhv?=
 =?utf-8?B?UVZRNXFRNnFRck1XNTRHNHFrTnBGdXdQRG9DUkhDMlNVZXdxazRuc1Y4a0gr?=
 =?utf-8?B?K1g3bkJpeTBnZ0tBS0MvbWhaVXBGUFNyand5bUYzbExxTnhTUGFpZ1lPb0lw?=
 =?utf-8?B?LzdTWGNCeEtqRlRpVDloYUZmNG9FaC93OUZMdmI3U2VpQ0JCMHpnaXNNdnFr?=
 =?utf-8?B?UERPZi84RFNwK216YlhtMEVzaXk3eS9GK2JQWm9ROXZubERCcUhPRXArTVlI?=
 =?utf-8?B?NGhVK0RUVVp5cnBudU1GclhDNTNQYThUdmphL1dYd1JpdkRBaDZ6cG45Q3VW?=
 =?utf-8?B?dWlSSytWeUFxWDF1aUFhaXA1ZmNpTWZmOUdFYjVobnlha2VJdFJRODNqUXhG?=
 =?utf-8?B?MWxEdGVQT2orcHlTWlg1aE9GQTVubXhMdjc3bXVRN1dDU1l6cmNrR0pJdW42?=
 =?utf-8?B?ZlI1T2VpTXFjQzFFaEJPV1dFZWMrazZuSzYwVUw0Ym0zV0JmUFZ5aXY5ZlJV?=
 =?utf-8?B?UHZZSnRRL2NyMVdzTDVGQit4UHFiVFhGWGhXTE5Uc3IwYXJFZitwYm8xOE05?=
 =?utf-8?B?MTl6SXdnTXNYcEpvRVhuMVltMWdyNGhLTzBNN2dUWDFkNXFsczRkeUpQMjl0?=
 =?utf-8?B?U0lINWhPSkZKMVlpMnFHSm56SDQ4K3ZpMDYzbFJpa3lGNUNETjRHWjNPSkUw?=
 =?utf-8?B?bzhCN3VRYUZnaFVWV1ZUYVhzNEhtajZRQkdnWjl4WU9FdnRUMGlMcXd2dmFh?=
 =?utf-8?B?dGR0UWtmN0pvRDEyYWdkcFFweDhGRVA0YWtOcG9tYzNqSm14cXNOQ0dOb0tH?=
 =?utf-8?B?Vjk3YUQyWGUwWm51cWxNdFBkeUFubjNxNUJldWlRNjlpZXQvdGl5cUFnNHFF?=
 =?utf-8?B?REFGRTF1MS9PeDdnY0dtalZnSHAvTVJQN2FqWjBoSjBoemx2aTh3SXNCdEhn?=
 =?utf-8?B?N1U0TkRJaERWUndlLzBoWjRrdU9vWS81T0hURzFHR1M5Z3huOWJQc204eU9U?=
 =?utf-8?B?WlUrT1QyQzE2VmRoZTNqZTVFR3hocjNhTzJ4NEVaaWFpMTFwbFRkYTBTUnJx?=
 =?utf-8?B?dlloVEswNmdOZ3ZqQWFTMFRpZVI2bThqTHRsSkZZNUNDaFl3aUV0d21YZkVo?=
 =?utf-8?B?MWdMRTN5Uk1MQ0ZnV0pPMDZOQ1hPUzNoTElWcGtUK3FxdkM1Z0RTNHMwZW03?=
 =?utf-8?B?bVVQOFh6dHA5bmxGUW1kUjNRc2w0ak9hM1VlRnlWTEFRWVR2ZmRmM3c5c0k5?=
 =?utf-8?B?NzBFK1BZNjZreFJDNVhyUTVKTDUzazRiTEtmWFZMSzA4QzJ5UnZvdVNZTTQw?=
 =?utf-8?B?am1YN1BKYXkzMlcxMllPM1ZmUVMvbmJST0d5dnZ2em9iRHNUbTJSMC92UVBS?=
 =?utf-8?B?cEh4U3NBaVBqbjluNkZvUlRoVHJGNnBvbEU2bU41L3dQVDRNUStzR2drVTBi?=
 =?utf-8?B?cVQ1REhZNnNDWTVkbzZEd0xCeDBpUGp3RHVJZkdkaTFmOHh3VFl2NXBoTFd6?=
 =?utf-8?B?ek5TRGdDM3NKRWxZOVlLRDNrRWtsU2RXYjlHSnlsd0p2MktLQzFsckQ0VS9P?=
 =?utf-8?B?MVVDRDh3cWRiWS9QdjRLVWl3NmQ0VDRsbC9mclVzRkhRTHV3dWZ1bytSNE84?=
 =?utf-8?B?ZTFjOXZCdlJXQW8xRWQ5R3pxSWNxM0hnWjhzais2cW00ZGRzMW15WWtGZzJU?=
 =?utf-8?B?SDZVcFdtV2RKVm9RbTZsT010eFBaQ01iSVNNb0RqQU5uNG10MHluTUw0Y0cw?=
 =?utf-8?B?RmtZM2Z0ejlBaEtyZkltTjFya255eko1c2xwOXRFWGorbnRQdkE5WGFZWEU5?=
 =?utf-8?B?Y1VzR1g2VWVuaGF1UE53Q0JIRElEcGhGVTM1azFyNG9JZXUvN0xHZlBWNTE2?=
 =?utf-8?B?TVF6Ky9kVW40ZWVmR2ptYmRwKzdIUlNPbW5wZldRV0VMRlI4UXNGdDRmM0Y3?=
 =?utf-8?B?emljMjZwbVNBMXdmWktPa1B4UzFCRlJ1ZUJnUFlRTSs4T0JPRWN3NkowUTNH?=
 =?utf-8?B?M0tYNFZMcU9nV0ZubE50cUNSMXFDZmNSVHhoZTZJTUFLT1FEZzhkQjNaZGhF?=
 =?utf-8?B?cHBlRjZoN1VLRG5iK3Aya2g0c0tldDRtU29sT21mOEtGTlMybHh6czVoTG9J?=
 =?utf-8?B?ditzdXFnczdERk1PWm1DWG5oN3dwWVRxZG1WTTRRcHNUTFhLSWdsaGM2MlZB?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AuPGl1R3L6k8YxfxrIAsNqtY9t7AuaIcspyYQJzkiDZQdsjqFTGCFWI5jh8ZI3AQfbAx/BkaU8Qtu9x/DI6bwBbwmDPSsfRF+Ka9QKHfV30Hopzb78Aw21S1iG/gqJGrNwZNR9qbhug+PAYg4rpCJ6OZiG4T6GLsE8CbJC/r7lLJ/UYW6cotUHh+DEWQrKMY4XWva204ex7rfTGHE91VRcNbBhoVWPMpjvO4mpFobJ0k8/NGHX6LOC3PKlA6qbm3YIeGjyGNtHyH26qi0wtQEK+lGMXTYa8vXltWq7ulmuxYiVkAbx2zKgRqtNvGaROZ11O312+7NH77NcshxJErSlqzjVuxUzpgcRKDZ+Wcu60qR7uTwmsl57tkTHi1qgjlEreO9qa5DmE6+ANkZ27OCL9xdSVYQ4dFIlRpf+CBn/QsxeYNNxrrbfOTNNIorVhkmn3ZWcgE8Ec+UEAgUB2yAPNV9Eckt27zt00qhXw5EqwjGWBAHDm1HXeXKDVF0BvdkjND+QzqJsOYlBfKq/mu88X8cSW6TpnpFNZu1IPvoj3dalA+JU6iJgitGGRB8LqY9DPotaQSRFleFQEoWxn8CW1Qks+qhEkVvVYQ1N6rsuI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7300e932-d0fe-4ad1-38cc-08de0fe1c947
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:05:55.2812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8/rEFo+6C6W/8QRM3hcEEn4hnvpDsZYfbWmpskh0yFn8u7W8ZQs39oFEIGgtAFykG7371r0s0IXEgd9yNWEExJ5bLT1/vsW4teEChy3UyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200117
X-Proofpoint-ORIG-GUID: sI-sM9RpreVnzuW7IHtDvIYAP6iWBUqL
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f641c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=ylxWIjMn5iuyEJlttcEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX3FUNuqqtlaRn
 8tCDURMnnPsZh5T6Qv7xA/gaFkWHyOMDIwHWxpbCPTQ6oDJeoAcA3C4E+mqNpyrMZ5278seT4RE
 sUlGxDepwK0EuBQFTqIJG3h6+lsQSrrZw0D/FHwCgDyoO5fXiitzPTnWrq19PafEL3VBt2/g5He
 KXaaxLLQA1uKqRV/2opt9A2GJFAh+7N3Pu4WVulw4iX8CVi50N34YTi8hlQJYM9LBO19VcwEGGX
 FTzruE+cMrHrtJRC3vv+gspdDwIHAFxNlw35Lcd84Vn5AWtQkMNhSfcymxxXpp3OJssFko++749
 RDjRPLbZ47Iq2IlPew7VB0fhlttje+cWpa7EmUPUx/jGDAQqudsKf1y8WLjj0jyWkeQUCWzrc8+
 EWgIi0ozUo6fsSysSSPyn1Pxw5UDug==
X-Proofpoint-GUID: sI-sM9RpreVnzuW7IHtDvIYAP6iWBUqL
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56D8BA0015
X-Stat-Signature: 8ehwfefcjgars5a7z6excwc5mq5w3pyc
X-HE-Tag: 1760969162-946100
X-HE-Meta: U2FsdGVkX1+xyHFZO1uxOVcN9PRCpJ3pAQgZDKSKUqdqgTinqRWeUlxPy+p2pX2Q3FY+k6aqbgTRIynEj3DNyhMlY/MlvMF5xEWWC/7aKldauWG0wlRSvUm/3YUsNCsL0oYJnWHJ90poqYpRBGf36MCBIxa5fxjH3C9XxwPKnSOGrH+j1XoiPIMf0W8Upezkt0JMke6XFpvz8iWHqv5kqXeREbSL8GQlBgwsZdS2AJfwxfFG7Hr6QXbVpfjIo9xVqd6+MAoDFJVr8MLWi9JnzzuSB/5w1GhyzLD9IpYNLZo5DqFfs9+ogyuPfz/D47v+4fySxoH5vSNbIj+i+1Ibp6m3h8xwRu/SClnYVtAKE29V7syFqEQvgJbBnPdHyUD8lYlNYHCTaVb9YlKBsev1/cBTYX9yriUjHWAPM19d6Z1XiF1ghRlFjfW4yILMlSM75sORZg5dfXSwmQOfX5MCd0jSKjf4LbQv/z7PaGm/WuLlnBaHQc9wLCHdwp6IAtZ4DdgDMUHSSRzIzdBKdgLVBE9sILpdx4kdA9JcSUuaA3Hl3w36vWXx6CgN4B16ZGDbl/xA6raNIVP681ik/AxPYph5zIC8Jn84wm/IqbAZSjZal0UcfFcaEdEgCrBGwnGZ08dVcA1dPxQQWed+OR7dhixee7t0oezzRu8ku9iARiwvBc1bTQ2H9pkSrtzavtH09teSK7K3pLDDY0fHcSHpEQqnoFqm0rpYRZc45RMV3Gr38K4vWPFFupTwYGY6dN0fX70qWcJJ2Vx28L/947GDT+Xc93EiebeSq+69ieoCAlgzEPuuUDpJeJJ+h3o91HkxUq9f2YSWPwHEHLmogWW2zUgqBXRTzQ+JRmveczOo3cN1jE7Wgkdx0L8rZS2hMj6yEgTUwJ+k4l7ATbCfl1TPDN0IXTFb7jgTeTh3Oc3Oab86udAYV7bSYp1glnOj1TiVymYXj6+rWsWJcahlEjU
 Eiq017wB
 jMf/5gO9G4/6XL7NUez3JTC3bKj1a5P9vmsVvVSxZ6Prl8HWqkPLb+iNzD5WDFsqNTFoMP6pSkZYZHvB+qrfGD085Y5s6OXQGNz96ZTahagX1EXWZWnNugLhARdZO7s4IrcPvx1mJlxLFkm6e623TX6WtdCbeAsh1/CsOT/0nL8R2urYr13iJsfiSAYFEtvckJRf3nR0KBuvwh3nZUF9d6Ik0SErhkLYRFDPKJYxXva8xkyU5+p7FI13HlYBMjq/VW0IDHcjK6cs6CnaUbnvSbFzie/hDmCVL73mB9cfnqBlEBfBmjpfQeeV4IDIo/3b9QALbGIkCCVDlJIR4nppUV0K8YgTgS2AKDg6SaVqS8RG5k+UmQjDSYgA3Xn5NkzCSmK/GgRPyXGJYuTK8G87ZYf2Kg5FEtbPWAG64E3ALKDSr+siVy/UHok+xk0UoDJriPGvdQAgvEDPaijGWCJgRXlxF3GLermqyP2OcOWY7/jfH02wttPm56cFl5Q4NoKpL/kowl4XMJtM2eEaWrsKG3wCxmfZOzYXHraQaY8lbJRdrnQ8cI4kdNlyfB/L0iJ2CtkHjZo5Va0exHZ3xsmTiDmVjsM6xB1k6QvPSO+sLzy8kgAn1acJovnrHiofNJi7hwIZsRTQp9Rl+Lb9EAVL6vRxRr0Hm4uDQuSu5hg3PgZHQgH3fiXKQ8VI4qQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 04:43:33PM +0900, Harry Yoo wrote:
> On Sun, Oct 19, 2025 at 03:07:36PM -0700, SeongJae Park wrote:
> > On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > > Since include/linux/pgtable.h is already listed in the MM CORE section,
> > > add it to the section as well to keep it maintained by the appropriate
> > > maintainers.
> > >
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Thanks for adding, but please put before pgtable.h to fix the checkpatch
warning.

With that done:

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> >
> > Acked-by: SeongJae Park <sj@kernel.org>
>
> Thanks!
>
> > > ---
> > >  MAINTAINERS | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 46126ce2f968..dedb9525c2bc 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
> > >  F:	include/linux/mmu_notifier.h
> > >  F:	include/linux/pagewalk.h
> > >  F:	include/linux/pgtable.h
> > > +F:	include/linux/pgalloc.h
> >
> > Nit.  Should we alphabetically sort?
>
> TBH I have no idea.
>
> I thought only subsystem names should be alphabetically sorted?

No it's files too, checkpatch will tell you:

   ● checkpatch.pl: 262: WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order

>
> > Thanks,
> > SJ
> >
> > [...]
>
> --
> Cheers,
> Harry / Hyeonggon
>

