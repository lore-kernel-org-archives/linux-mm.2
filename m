Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BC7CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A47A8E0017; Thu, 28 Aug 2025 11:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2776A8E0001; Thu, 28 Aug 2025 11:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FAF8E0017; Thu, 28 Aug 2025 11:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEA188E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:12:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B95C118445
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:12:29 +0000 (UTC)
X-FDA: 83826507618.12.128A38B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5B2720002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:12:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A2dE0mwJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uL5nrURd;
	spf=pass (imf03.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756393946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCc4Ms2y60PtFyCiRmdx/yeK2m5KTpr6/Shyh0C3b1I=;
	b=2Cv/Ugzd3sQDfRKEQ4svTAQfASMkXyWM9QFyXdGscslfvpxv46+7urzDe+0ptNUZ9K9/8X
	CVC+spnI/Cm6q2V13hCDkKYyAFW4YFgrQ6ZdZKF4S8sJ8YavnW3SoEI/2MH9QgmDEO9bHg
	ZmI2z+A47aoMb6/YSYFcZGLxWNrWiPA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A2dE0mwJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uL5nrURd;
	spf=pass (imf03.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756393946; a=rsa-sha256;
	cv=pass;
	b=BoOanrBWbMVLD+YQk35yVlX8zrw1kfwVbLA2cYBDe3VUutVefEDoyaaRlL/jMETocxx6Gd
	HTZW4NiOgY6HvQdbpzOAhA02/Ii9Wk1ShvSdAnjN2wwG4Cyvzc3PKheq1QCb9e+4qCqp8g
	XW/E1CuFZ0LZpKRRlPDAlCho74OpfUE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN5bG024211;
	Thu, 28 Aug 2025 15:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oCc4Ms2y60PtFyCiRmdx/yeK2m5KTpr6/Shyh0C3b1I=; b=
	A2dE0mwJrvx72tNh6i3/wEmj1ICAH8jjvtqG5LOG1x1aD1EGm3DVge1bOCPERs0I
	9l+2BGb0NsKLOKe+xE6CqtIrS8JkePFhzIifsGACe5Hj6f6acz16RFlsKG4TkWUT
	De4w5moV27La3U+TISgcHMwjYc7Ds84J8tUUf70OgCYB18tWzOLAdIB7PwQ6ydOn
	8wqGfrShTUB/onXotXaGt4L9lHBpvAOUsKNBioOi0niwE3UiMoiSwiIskDj+xy8I
	NiEHktjsvx3Nu06UK20k3E1M1z9yAh3+QXxtXk9tPw3E25T2ROSR3H135QsVG/7P
	wsxC4WOV+NZ0xzFY/7sjIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jarrha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:12:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SExMr9027332;
	Thu, 28 Aug 2025 15:12:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bvqd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:12:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urbU+j92+rqigEyU2H2pskpJNkVpZa8SgB+F7XkOW+nXW4VA11TT//5OyKwOqGOyTq5QCKy9V39ad/XADq4I2elq+ixRz6EBFe1qxPBY4PzeBCTnJZMjhZBBhTGd1TWx/MJfBn6Mn5KZgj/kE9HWWJJukJS99GYhHNcBKQMohlUxEnnFqnq0rY6fm9k0YrenhQVAcOb9nSVYZipsBjCq9DLqBpUQd9VFOdsMdpjwUz1sGRz5SofJowWcEvCVueknlRL9GIcTy/ZG0Tn2q81WPYxBPVszwzSFB7SK9APNXPSqfQqIWool4ChvXuERdWXzLPnbS2iTQysRUyeW5x0/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCc4Ms2y60PtFyCiRmdx/yeK2m5KTpr6/Shyh0C3b1I=;
 b=LaOwv10fPhMc1Hbtqz/SvC2GKGpH7JKbuC6oge0UkaxSvSPMFVDWrcGp9lVCZOAWNHngJxEgWx170JIyHdPI9vJ/K4pjm81AjldpNCQOZnaEOQbUJRco4lexag+mL1t639iF6e4gGc8nCebK5LqW1XhV+yTYxSrzFU8oy6UOhmbPu5QQoVfvbSGJWmsDRekc1Om8mptwUZnwB3lY95nxIuIh6Nt1HLE9R0eTw3Gau0a8a5zlra4PUkO4fOJA0+IpgVTqQIGbrNvWVDhfaTHi/+Cj77IavYAmXNdg5B8j8piTbyn9TKM489/l4tAyl/0EBloS2d0aP8eYyYlPrg3cKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCc4Ms2y60PtFyCiRmdx/yeK2m5KTpr6/Shyh0C3b1I=;
 b=uL5nrURdFWE4o8Cy9i8CjEWE9k4akKMTvWI+TXudyHXrEY4T4StDGl0kgnv8UFJJZ/T4H8zd/vLyKPdWA/oKrLOPOn2PLwst8K2Bl9n2XEhACU1Y8Vdd7it0cqQFdjCjkUzwgIGu+/WwJU/ZE8qVUMfG4etNxC66cVuJVOMuXh0=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH0PR10MB7411.namprd10.prod.outlook.com (2603:10b6:610:187::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 15:12:17 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9052.017; Thu, 28 Aug 2025
 15:12:17 +0000
Message-ID: <b69c03f8-9de1-44a8-9e21-322b0816be37@oracle.com>
Date: Thu, 28 Aug 2025 11:12:13 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] maple_tree: Fix testing for 32 bit builds
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250828003023.418966-1-Liam.Howlett@oracle.com>
 <20250828003023.418966-2-Liam.Howlett@oracle.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250828003023.418966-2-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:208:32d::21) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH0PR10MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a60fb49-239a-4a68-52d3-08dde6454695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTBGZDdmNWRvMWYzRjNZZXkxSCs0bVZla1R4VWUwWk1OMG53djNId3JLcWx3?=
 =?utf-8?B?NEhqczdESXhvRGZ4N1MyditYZXhRanZJUjRYSEhDVmR2NjdHRTcxOXRFRzlm?=
 =?utf-8?B?R3NqR2pDbzlaUXlDTnZ1TTBSUEg3cytIS3hlN09nRElCYld4TGdCREtReGdq?=
 =?utf-8?B?VTY0U3pXVngzNDFxS0NaZlQzVG8wdmlMQTRBamFIR00rdXhHOVVTN2FyZnpi?=
 =?utf-8?B?UmZ6aGRiSkd3cU1iTXhTUitXR3V1cXpMNVZJUU9yUHRJd0FsTHVkdW02cUc1?=
 =?utf-8?B?SWs1aVlYYVlodTVmSHlyeElBRUpDK0dUdE5Udm9EWDBqeHR5ckdlNlVUZWY2?=
 =?utf-8?B?YTA0SVA0M04xNk5qaGxJTC8zL2YxSkpFTUk5eElFOTRKS3NsdlFWVTJYenZq?=
 =?utf-8?B?czNGS3RYVUJVTjhRU1hOanhwaFo1bVRLdzM5aWpmUW9oTURpNm9qUFNSL2RT?=
 =?utf-8?B?WlVKUzR0NlRqbXh2Q1ZNcm4wdFZmWWtDU1hWL2JqZi93YU4rUHl1aU5BcDZB?=
 =?utf-8?B?Mm82M0VNdXNEMFFhVjdrNyt4N3B4UUZUVXUyRHJjdm9zWDJmRTZRMStvRHl3?=
 =?utf-8?B?K21GNFhTN2E1L3d6Mm91TnBqdGFwS3VoQ2pBRkIxcW9NbDRyVHVoaEZxTkhT?=
 =?utf-8?B?S0wza0xIeG40MVpuTXZsZktVQ2IyRzZVM1dPYXF6R0RWUGp2VitWTWxkb2JO?=
 =?utf-8?B?dGVqWmVqUFhlK20vTG9mbmxUdER5SGRRbG9Xa3RBWVVtQnk5WnRVOVc4RjNJ?=
 =?utf-8?B?Z2tnVEZhNGRhM2lpSThPUHNQV3JCUDZPd2xGWmhGMERGdkt5RGd5MFM5MFVW?=
 =?utf-8?B?azdSUGp0dVVRRW54MjcyY3QxMHNHQUVUVGdLSHV4S0tUa1FkV3lCeE5yQ1Zj?=
 =?utf-8?B?djdSclFucXVZQUdjcUxlaWIza1c2aDlxKytOZFplM3JFc0FwNzZrRVFUVGRK?=
 =?utf-8?B?QkVzdmxndXExZzZJemhaSWlpVHlGSmMrL01rc0o1OUU2L3lDbldJSDh0SlFQ?=
 =?utf-8?B?YlhJU1dpdG52MTR6RnBaMzl5V2kvRy9iVFJtVXA5VTRseHpLalVWdDkwRVN0?=
 =?utf-8?B?STgxV3FjUUduOERtSVA2L01ONVFDSWdSSXg1ZHlMd3JmMXVwV3VUUFBFT01k?=
 =?utf-8?B?YjRMYWZ2WWFkWVgvOUY4VDBoUE9DMUVMeG5YaERKV0ZYNWVRYkdkbXFVNU1r?=
 =?utf-8?B?V0k0Q0gyRkI4MTIzUk8rVUtwZmNwVjZMQWRRVXEvZlJ1T0RBNWdoc2F5c3ZL?=
 =?utf-8?B?M1hobVJIam5uckhMU0IzUXFCeDVhWTAwaHJwd2RKRFk1NldISVg5WFM0bzQ4?=
 =?utf-8?B?TGhQV1VvbjRWQUx6RE15OXNTc0VoQnJnQnE5MVVQNzlPbXdyME93eUlvSlcz?=
 =?utf-8?B?ZXJpZFNEWEI2M1NKc1dYUEtwWjM4SjR6ZHhGNmI0UEw5U1h3dFpkMVlSYXNR?=
 =?utf-8?B?UWpHN2xJZkgvdkFIMFVoakJ3VjM3L0lWU0djbDBUUHBDblhzOHllZ05wUUh4?=
 =?utf-8?B?NTBjWkxaSTBUM3gvWm5CdE12ZEhZNjcrbnhESFVNMHl4VXAzdHFuMkJxN0Vp?=
 =?utf-8?B?cUd1bU9qWHZ5YmZKY1h6SnNZMEpCcXFwUkIzTEFmMkZXM3lwWHJyaWo1aFZF?=
 =?utf-8?B?Sm1iMnFsTytSY1l3d2lUenpKK1JzTVRWUE5kK1RyakNMdVVuYmE5VUlUOVNp?=
 =?utf-8?B?V3RPckdtK0dmdnlYVnlkRGFOaUY1UmxyWDJKei9XcUd4ejFYMklVZkVJVGtK?=
 =?utf-8?B?UnlsZEJaOFlxVHdIb0JFait3RWZMN2NGcFppbTVBQW1DdUNGNUZiQXR2SmJ0?=
 =?utf-8?B?NUhUOVViamZpalc1V054b3lSZURGWG44TjZlMEtJR08rSE5uS1Fod1poNU4v?=
 =?utf-8?B?aDJ0V1MrMDJMWEw5ckZjMEJXeXpTOXlRZmx0dUE0OEVtT1J6UlE3MjAxeFMx?=
 =?utf-8?Q?gja0VtSmvIw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTdFRGF4S1BOYzc4K1dSdGZlWjZMbHhBSHJXR0lvRkl4M0RPdER6UW5QRSt5?=
 =?utf-8?B?aXUvNUVQRnZFY3NNbHNKQ1VDWStYY3ZvRjBWRnhYQVp3d0c1VUd4WkVpM3RB?=
 =?utf-8?B?TGZTYldnQzM4RkhWc1NZZElaVXJtWmhiZ2dFMXNyWFFpSEFZYkwvbStPaS9K?=
 =?utf-8?B?SFJScElBZTd5em9ERHplOEdQdURJWGtpQkxuSjBLblEvOHhSN0hPT1hhOEpE?=
 =?utf-8?B?UjVPNUJ5OU80S1dRc1dlYWpZalRVTFpKTEhGVzR5SHZGZU1hVmdtSXRLVFNa?=
 =?utf-8?B?R04yYzRXT0QyRkNlQ0poUTFyTEVpbUxtcEl5U1lRN1VQcHNpOUh0SjZpODFK?=
 =?utf-8?B?ditpRi9lREo5UmpEVUVyS29Ob0xUcXdaWmw0QUliWjFKZ0RId0V0SlBsa1BM?=
 =?utf-8?B?V2VBTksySUFVTzRRMyswdVdmWm40QURva1hGQUJyTklWREJiOWpqOEZWUERB?=
 =?utf-8?B?bHE0akNxdkgzOEZrdll4dEpCbTRXS3RlQmtYSnVoeDRKaHpTeDlNR2kyODdC?=
 =?utf-8?B?bDI5WU1iNTZldjVDcUZmM3RBZDVPWjFJdWVPb1pUSTJiampTN3dSNFBVOElL?=
 =?utf-8?B?UGZ1NkZpYUcvR2tOZjBVMm50ZjNjWkdnUWtiaktjdU1yMHJBUkl3a0JaUFdH?=
 =?utf-8?B?NEp1ckQrYWNzTnFnUy9WbVA2TUlETitHN3NxUmYrRVVNV1NjN0dEbzRZOTV6?=
 =?utf-8?B?Nlpta0RudEsvdjJSa1RaS05neno4UTFHMXNVZzVrUEF6RkpZbm1kVm9qOVZO?=
 =?utf-8?B?aDN5bmp5N1pCLytwWGtBS2tIN0dTYTJrdWRsdlAxNWErMGdreDBRQ2VzdGV3?=
 =?utf-8?B?cUlZNTVlZ3FvRGpkb3lyWjE2WHgwL3NLNkR4LzFSY2xMWUxNK2VvY0ZVYjBy?=
 =?utf-8?B?SHVhNTlOVW0zaEJKU2t6dnNwbWM2emVJSXNxTFg2NjVaSzh6a1M5dGZISUhn?=
 =?utf-8?B?UEdvWCs4QXdESkI0UE1SNm92enhtSCtZL2QxNmZuT2tWN0RDcXIwUW9NVzgx?=
 =?utf-8?B?V0pGdjJsNk85aTd4NDI4WUczV1MyWHZla3Z5dG9yWWIwVkNJQk92OXVpS2Qx?=
 =?utf-8?B?ZUwrQ1I1RFJsRzAxZ0VlZ0hxNnRpR3NxUjNrQnEvdzJ2ZnE0QmZJRGxUMFhO?=
 =?utf-8?B?V2tXRHhLWDFJUG1RSzluMVdwb1plNjBvbGJ3YWJ1dm16aS91NnQwOFZCb3I1?=
 =?utf-8?B?Q3VpTVQ5bVdoUHNweXhUUzhpZzViZWNtbTZzUTNQZmx4QTZVMHFwZEdydVlJ?=
 =?utf-8?B?VGR5Q1M0dGNSMDcya2xZSmZBOXZvWDkxRzdZaEhpMWVVeDFNVmc2UzY3c3Bt?=
 =?utf-8?B?MTg5Snk4WllMTzZqdk9nOHlyYjFkb255dDVVclFKV256TzNHSzFrdzRYajc1?=
 =?utf-8?B?UUNIRlNpblFJbldzTzZ4MnJIcTRYZ1BKMEVFVTlGMnNZem5FeGQrK3RBdG5j?=
 =?utf-8?B?UVNheEpRa1JOdFBwK2FFdS9tckl1S0RGb0RKdExlV3RCUCszWGU1MWZMb283?=
 =?utf-8?B?WEdXOHJjMFNKVXhwK1dVOFh6K2ZwVXBINWoxU01DSFdNS0VmeHpzQjZsY1R5?=
 =?utf-8?B?SnRReHpOVzVlbGh6dWVWSEFrT3BFNXQ5VnN0MkNLdkJJd1BWaDBMeXloaUtC?=
 =?utf-8?B?V0FGSDNwTGdFdWs0dFIydW1kUDNzYXlUdmxYMFJjK1U2VklBZWVIdldOZk41?=
 =?utf-8?B?SHpCM085ajJYclZIOFFMUEhyT1B4THRxaTQxMWRndkRmcFZCQjJKMzhqVnZx?=
 =?utf-8?B?WVpZeWdROTU5dEVZV0Y2bjBQTitxQmZ4UWRGZ3d3Vm5TSkVMalNDQlFEL29r?=
 =?utf-8?B?bTBWSUlCVWZyOFkrYnV3VXRLcmlYMFFjdzlSOVh5VmN0RFRLUU56LzNhSnNn?=
 =?utf-8?B?V0tneVVwQ0FnYzJtQVd2OHZkcnRNRVVZMmM4NXFvYUdSakJvaVk0S1JrT0hQ?=
 =?utf-8?B?QmpieWlQSFV2U0dvbjJLVGZIc0Z6SVcxK01HUndmRjJzYjRtcnhyRFZIejd1?=
 =?utf-8?B?bkRQK2ljUVdCRkFLeSszeTlyMUJ0d25pdURjcTFOVTRJd0NUN0NmWkgwekhN?=
 =?utf-8?B?Z3BjL3FBRGl0ZnI3ZnRJMG5vNkFPaVcvVXI0bCthQ255UUQ2N28xZVBMYkZa?=
 =?utf-8?B?RVAxTVRSN0pqR2lFTW40N1J5VVRtR0RJRFpKcXM1S2swVnFodGJES1FteW9N?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9/RbcgqgaUJeNM5vV3Dn/EhitRPWb/dCdUcMMawLgFJIYiMrNLI9QH8jzxV0VDd58ogrPgbOg1beLls66I6cizBP9/Z9NkWek6zAcUvcB8uANis/PdhlOkpCm0Vr7Qu4sFkRlg2Ap+rI9dBKenVUqgeXBgGd2VNEUcr1XhoiL+U9rO7BqkGwyXGUBdOU3Qf4UYQHQ2TVYlrpagHPd6HvTjkWC8rN7EyM39mAy0TiM5k0ljw6VQypMM/CoGIyZIUCMnnVEZ+04Bxe9ujKbPYgfB6SCUD6gS23Z5PuELk9FCJm2nCiU2yCB0sjTE/KdBrWzIUANJXeiF5ncaG4Nf8y6kE4F+t2Vdzrudrvg51+ERLPxW/646S9ams+Vrms8cA9ZBtePSQrQaFo6XXmezZf+UJIW/DohqGRIsSXg+LufWUGbldLEIG92wfdNgC8uFDMHXsOUBEURP2sJfaceQMIqNPkciM7fEoepPMnVYrwNJoyV3Zf0TjJqXhJpgvX3/gjM7e4b0JjMu2/M8M8VoXWx4JGxFMCLAGuUkpuPW/hPH1dn16i1Inzug/lyvAQ7V/QMpHjVfWnw++J8kU32hfNNcfN2CpXe7bnlbTKKVTNtx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a60fb49-239a-4a68-52d3-08dde6454695
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:12:16.9645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzeO4tzICcErUcNcukhI3u7DCpii2z5RiRuAVx5ewrXgCrCwBJuCZ+R3N+xYjVBgX1LI9LLzy/fpRGuu+AD6tgpU9LJ87mlrSCPXfyvCK1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX2DsXfiXMeVxv
 VSnKV8ik52mjBLsroHFFVmn7AW/AH5Szo80/4NwqKpQ5zfZpQWGgQqDnlvXw+noONKw5EE4ogOY
 DlHFEW6OIdRkBbRtKWlCnfwCNM7nGFjKZScgSipbeubMTDkyWd1AK8MxTuKUA5DCZzVHnHMzDIc
 0sK4r2yNQ3T3q2eYGUcBlxzcb1VsHkbxMz8SaQMOc9InKjH87qAe58U7bQV+1lFzegaW3422sfM
 sjNRepUsiGWR+wpxJWJu0boboJlcTZjM0cN7SvWzWZA2O/IgR1elTSwW+4pq/CbZvQBLc6Fg+U/
 Zlp17hnkBCnkHkF5XtsFcri0UhWZL8AYTVMVO6c72PptLe2c5RvuA9onTMm8/DLHub6wMugh+pt
 y4YYD8Fv
X-Proofpoint-GUID: __hD2SvB66cSHMbWbQCb2QzUbIAWqtZk
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b071d8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=A-giuPrglBJoTuMkpJ0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: __hD2SvB66cSHMbWbQCb2QzUbIAWqtZk
X-Stat-Signature: 8an6am4yoqzn48i3irjhzwp1cnxpbd5z
X-Rspam-User: 
X-Rspamd-Queue-Id: E5B2720002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756393945-385659
X-HE-Meta: U2FsdGVkX1/upmzVkWq68gjMfEdN5boYPIeRu1Sef18ga073qwyuhnPccQ9NmUbq1TKVtE5mxrcHaDP2lOLJUCglCO7j/cZPLLg9xmD80kx3IEfjjN613MCbEsMsO9W2PYiAu6EZYQFqRrr9m6xwgAlO3i+o+MnbxoR0y3A+eRGy/O+D58+Z8zoADvQGqDebLxsa/erH4JfXv8xweM1JpGlJARn6+0m+cJmn1Jg1/fU2459AbL8ZI7Ot/XjKQjIMXnUyGmpKIIcKNBeSAxjYNyLODOy9SAMFEQosmnWRd/yGxIpWSEGkKdp5WwLjgLgWRI9aaaZ1KX+/IRWj8+oLYTiXCLkT3880quXHGEF6RWE10CQuy1YzZ9NzrrsY+I9w1pwgm/pUQr9KNwc9Lpd8DuzwtdjoHPYrD1/hLHyAd1b9+B/VnsTdyWNyAhM9Wboh0mHXr31/JyJWMZMvY0f6A+Uwe4BcuP5oqlFD/srbu+IEgdMjNJMOqKP88B+vd/SFteWIxs1bhXlNeGeFb56d2j7ER+FC9EBXMOwZNFDqxfZAltiaOGMAU8+GWjG/oJIItvUmSQ3AWRRb03vJFw3H9DpFdrtVBq79AoBFmactV286lqXKIjGWYRnTZwhpkNbEUTlLAIfOM8wohWNz4HvMu4e2b4CxC+qMPQb2+/qnqhv5JM7VcB2SfkTYaHAZKFXr8x1bUrn3UBOVI1ATL98Do0hi2e6TrM1r59d2hko6k+UftLPE5PUNplICkJ8s5AnCBu9pojk9lo1p+N74QJ0sANZH3jFrH6STfH0KtJs09VBanV6rmLrQcn0al82MlSLrSRdT8yE/leCCtgSxs2OUME5F+VEjej5aXAz0SXKftTDycxDYFg4bs/4ta4sfiOcyMrEtxoZOQcrHPaX2zMkxChope6Xtz1ia61rIEs3ABn7E+dvH55KqOt1dDRXmK4y+ERvmRXGp2vF5oS+BQv2
 HlYkUjut
 BpxQ/CWa5aH9ew7fVDEE9CC4x6q0pMgdVojY5vghrdpw83YiBRXmszYBbsNZDcpvAShDB9iMQdVaPw87J5FPOc/inggprqG4sV365LffRodIFqQrRY6p5B4HldVjus4aUOUK0/mSPJHQz9BAOAVmGWj6ELmr6RsEsbsGv/PXceCXhVryYTF5ZIJiCyt7HweSYava4cCRzN3+X7jDv0BbdaBGsS/0ayCaPYaEdz2FaXV2dUYOwuCCbUwuAQxCEvJjlrcD8JJ1+y2vOcc8g82CiaYbYIlnsjsqTkL8qOofpZk0XSauxYq0vsWjJWkc3u83HDJicLHXIGQ05APl8e9nmiEwNCtkiBkMYmuGyrUImZ5i/6sNM/JZ5SkyswaIqeoZOIZx+PmNX9hmG9TJgm8U6HkCgcIU964IM0n0y6Y6SE4ZUrVfUBXRxxUHfxCypB0vED+gvhRtvDtU0GdFH+QCTbVlJf3nWIr3QXJZYqrByBVNK8WaiH4Oi7OgTznmAqhV0Au3WaNDAs78RAWAV7Ai+lbMZ1YiDnliYagmXhqm+EZ/csdkqQPu9UjPpkDSwwz8G0XoPXrWha2R9AeMnnft625OK+hGz4u2IxkfdX9Y/HBbrYattuqEMR018UEXQHfG+9m2uE/DZPVbfE1ByzRHtS0ko0Ei3QlBGOUDeTc2D1Y63v86pNKE1ZxEASkgeDSLTG06DMnTg2leIxoN5KCmctG5LAt2amApvKgFZMCgTeX3JVx2uITx4ISPjqd4JovY5+aGoLl4n2d+zRaY8GIE16JC2L2PbE4ITVQxR6+TrrxL22Ior7b4BYKNsO77+Q/1VSoFNu+CnlAikH94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 8:30 PM, Liam R. Howlett wrote:
> From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
> 
> Some tests are invalid on 32bit due to the size of the index and last.
> Making those tests depend on the correct build flags stops compile
> complaints.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>

Should a fixes tag also be added?

Fixes: 5d659bbb52a2 ("maple_tree: introduce mas_wr_store_type()")

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   tools/testing/radix-tree/maple.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index 172700fb7784d..90a0db45a33c3 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -36428,6 +36428,7 @@ static void check_nomem_writer_race(struct maple_tree *mt)
>     */
>   static inline int check_vma_modification(struct maple_tree *mt)
>   {
> +#if defined(CONFIG_64BIT)
>   	MA_STATE(mas, mt, 0, 0);
>   
>   	mtree_lock(mt);
> @@ -36451,6 +36452,8 @@ static inline int check_vma_modification(struct maple_tree *mt)
>   
>   	mas_destroy(&mas);
>   	mtree_unlock(mt);
> +#endif
> +
>   	return 0;
>   }
>   


