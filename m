Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243D3D65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 14:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D6C6B0088; Wed, 17 Dec 2025 09:29:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634696B0089; Wed, 17 Dec 2025 09:29:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEB46B008A; Wed, 17 Dec 2025 09:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9806B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:29:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C36BDC0AAE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:28:59 +0000 (UTC)
X-FDA: 84229194798.20.9E9175D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1BF2918000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:28:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Sp/bvFGl";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JZeQwHSS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=temperror (imf06.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765981736; a=rsa-sha256;
	cv=pass;
	b=JkuM2u0YhKXBahMbnOj47Ro++zUQhkOKmiHndWxXtp+LAwxhh962Vr2UoUdQOyl9ZOK5fe
	KiTEJCNx5opALqUOmgeVzwZVBUw2pTz0VF/EyXZ7xDoI1X0R8auTne2apRDkwxVZO8HwJZ
	mUvWlDlIoPp/AGYvSmaMXgT9SgkNO8A=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Sp/bvFGl";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JZeQwHSS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=temperror (imf06.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765981736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiByEHrbrtkUK2QsYpzcRC61LIfbMpvbXRmp5nQGPzo=;
	b=GIZHx1mjbYkbzOu3s4doxNR170AVDl59CSxe53kmhwIX5vE0GCumowe86d40/PMtylNDLI
	b35aErxMSk1jEjB3iOhvHegURARUI43DAqYFFrx/ik/OWCO3odCFWO5Y0y7drGilsbtFdX
	nYRKFBRThXLzGzRRTSU3S8+LKznRmu0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHERWwQ2808685;
	Wed, 17 Dec 2025 14:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GiByEHrbrtkUK2QsYpzcRC61LIfbMpvbXRmp5nQGPzo=; b=
	Sp/bvFGloEdMKuKwTYFDXTtTZgVhSRTv+5m4O750BggfvZsbX6i0KnQh2phqGazp
	i05VkcdAQ7ED7arpkOagDjhGuju75V+2awAn0Gpw/E1GdRU67+7Gnjk6gNaCtdXP
	CWMRK1fpNY9Lq5nLEhAAkaenoa0rhYRd0tAN3zPDMpGwvZukdY9n8oi1ukPdUa5H
	+g2TfBIWZVs0+bmcxbxVzclBLGju3p8DdDkWj0996970DvJdYLoEHhm1dB3OsHyP
	MbwNGpB/akVI7xSusXX2rSB0H2rrjTuaCcRQa1gtujRsyJwX7v0zrNRcVqjXQL3E
	+1uNP/Q0A85n5qGaNI0a2Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b3xa2r024-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 14:28:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHDin1w024495;
	Wed, 17 Dec 2025 14:28:40 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbttgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 14:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/4s08BDcPwIKLtymWm9/3ZKW+3KaIRi4j7QqyhuAamNlM4afaI709TSepkOsL2MQuAH6aSrN/BG5dPDxiRdFZ57OEwlA4sSKYHUXEJXTkvBPHF6JQqu+LHVOy7v6xm/aWv91iR7nxU3jS2dsqx9kBy0cAC84w7EdgydyYCuD+wVuCazDzIhWU7UWSXpbV9S6JBdoCFIPEmlDY+DJWISHbNHpBqva0Vl5KS+KKunIDRFsFh/keI2zSi+oXwdfGDzZ1RhBVMPB2LMsofWaUGaR0M/pN5/bXriHrX4WFz5mga58pagrOn37iiUuUm9S5kqZcb675spRQ9xlebq6TaepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiByEHrbrtkUK2QsYpzcRC61LIfbMpvbXRmp5nQGPzo=;
 b=jhGHoA9Hvw1cuEeDdJSSTBnZQd6t+00RdcPVuaecMvzqU/Nweb4VlH4jnPuDRZiFvFq9qeyBwNZsskDMsG1EL6aKvplWtGH3XnP2+sFgbUNRazdazut5BzQF39/297XmlBJNi+zWfIV6kj214AidjWtLzGisfe3N8c1FfyBhwGiiGr3XZ8LaIlyhyGDg0YVNdLDmuJjod23JIwKOXhbR/vn32HJ5/cYye9IXFX0mKriyZJ8qKUEgy9syD+0zOXOR893kXkLh43z5WSy9QE1iek4ibfZDkLdVQvGtQon93S1QXdYiyKlKfudPtgZ3NwqSaPQrF4RsfxSJHQVcxspM2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiByEHrbrtkUK2QsYpzcRC61LIfbMpvbXRmp5nQGPzo=;
 b=JZeQwHSSBRg+2Sn4RQQFgO7eiXUx18LjF8owCgojXus+Elk3iu/lQoPDwO36p5lWAXrBxRS1aeYhsHHxUsygseEHnFd9ysqd+7Juj0wX8gCvojh29rfXDo5sW/Rg2zxcy8WuzKxeoomcKAG8FakEwRKmsgT11r+aOAJN0xW0UfU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB997625.namprd10.prod.outlook.com (2603:10b6:8:312::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 14:28:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 14:28:37 +0000
Date: Wed, 17 Dec 2025 14:28:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
        david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
        harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <9d63ccc4-7243-401c-a07c-60a84392fde3@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
 <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
 <CAGsJ_4xp40A3u=N5_mw00Eo6bPmFvctD3j=1Qmy3vOo2EmX3hA@mail.gmail.com>
 <9e038290-70ff-458d-b46d-bc512c3442be@linux.alibaba.com>
 <e718cfdd-a39f-48f6-98c8-f17683f29bcf@lucifer.local>
 <8bfcae1c-74a0-43e8-807b-fff22a770241@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bfcae1c-74a0-43e8-807b-fff22a770241@linux.alibaba.com>
X-ClientProxiedBy: LO2P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB997625:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ba04a38-5e75-4d89-6d8f-08de3d789133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2V5ZkhiSGp3WjlyTGZscWRhby9NeVBLOTRmdkRNRFJBSGFvZmRYSi9BSFBl?=
 =?utf-8?B?dHEydFJ4bGFzQXNkL3dncjRmQVhGSFhxZmh6RFB5M0JrS1lZWDMrejQ0REdH?=
 =?utf-8?B?Z0t6S3VLTG5Pa2tmWDZtbXZKQmlJajVPQWdLWlRhUW1Qdnk2YXRJeitMRGxz?=
 =?utf-8?B?YnhYaFBpYUZnOXg2ZFNNcjBWdVBoeDBWRU5jaFgvZlBISDkzbFc0VXZqRHh6?=
 =?utf-8?B?VUJnM0d4bk1DY0hDNlBLcEN4eXg4anFJVFFkN3R6Sk1CazZCalJFK3p4THI2?=
 =?utf-8?B?QzRmcnhGSFhLRDFqdU5mTUFjWmFVUVhLUkhpOThCU3J3TTZwVmltTlRKY1Zr?=
 =?utf-8?B?bzVCQ0psN01jUmdGSUVYOThMQjZ0SEpLSTRXTHQyMW9QY3RqVm15NXo1WHRw?=
 =?utf-8?B?VnY2ekROT0xwelJPNEdaanZSWHhybnFuWWRzMHR3cElBZ2xVdE1tamhWNHh5?=
 =?utf-8?B?NmhyWkw1S2RDb3kvTkFwN1U3bjVQQWxOVE81aTBrSVduY0dxenVQQ1JCYlVz?=
 =?utf-8?B?bmxDejJSWWZaTDhVaHJzNHUvRWhGQ0NKS3N3d2ZLWXNha1RVNnVVNVZmYWVD?=
 =?utf-8?B?VmhBNFdIN3ZjTHZGdzU1blB2Q2pMNE5aS0VGZXc2cldRSlk5aWI3TVhQT04v?=
 =?utf-8?B?MTNFN1pJL2Fmd3hLa2dBQmhNdlNueHhQemdUTmc3K3NxRTBVZ3NBNTlXUHJY?=
 =?utf-8?B?QnpGQmlJdEJOSVhLNWZGbVV3MlRkdzVvbTdNL3g2bHRWNVdsU2VqMGQ4U2JF?=
 =?utf-8?B?T2JSdWJBNFgyQlVaY1AwL0Y1UGhHdXFsMjhXc0FFZ2V1SWxjVXF0N0JQOHdj?=
 =?utf-8?B?SE5SOWozWjdEWW9vNDlQUzZLZFd6T0l6OGJmWWZzcjhTanhpVnk5NDhWZDVG?=
 =?utf-8?B?NGtxZSsyYzFzTXI4TGdIUnA5ZFZxTnNxYzJXZDhrRTMyL2U3Q3hVNUJjRVcr?=
 =?utf-8?B?VFlXdGd6aXVWMkNPTnJDM0NyK3NJTmcvTDBTckFDaEJ3MlBCL3RpUENmMUdF?=
 =?utf-8?B?Q1ZheVI1aTI0ckxPY1Nxd2dsTkRpK1dVMUg3cFdVd245OWlXSVdyMUFmbnJK?=
 =?utf-8?B?WDFwQmVHS2dZZXhENmRFZWpZT1Nqb2JlVHU0MndOY3l6QklBT1JBOVhsOW93?=
 =?utf-8?B?NE5mUzFBY2pmMXpLL3lUckhGdllCMUtoYlVST0NLNjU3VERaUDZNRWgwSHlu?=
 =?utf-8?B?SGJxZHY0RWd4R3Z0UmJNTGtESm5PS0tSNHBvWEUxcWUwcE5rYmd1N09CVk5T?=
 =?utf-8?B?MHJGb3EvUWpIRUJBdlN3MEpscVQrZUdyUHZYOHE5dHNYMS82Yk44WWhYejZC?=
 =?utf-8?B?bS9Xb25pNHBvZGRGYXR6UkNURmhTNzI0VFNscHNzVUMraW5KTldhOUd2M0Nj?=
 =?utf-8?B?ZWRZMVhGdk5ieWFVYkJVZU8yUmhnRUdjbHFCYzRiRVBCL3ZzTExYdW5ERzBP?=
 =?utf-8?B?eWZlMXZTbWMzSUxNNUdGQm1Mb1dSTUZtek9ER0taSTIvM2dtYVNNTWE5SW9R?=
 =?utf-8?B?VkI4VEVWZDAxaXRGQzVzeVVYd3YreXdKVFlVL1dxTWhuQ05aZTJvc1FXeUp5?=
 =?utf-8?B?bkVCang2WU5ZQkQzVkVhaVE5K1ZoUkg2Uk5LS3ZjU3lBVGZMcmt1bmt4Wmtm?=
 =?utf-8?B?azNONFV2aE8rMndHT3I4bm5oRTFRdnc2VEJ6Z3FPZmF2WlRNeWRWZXg0dnph?=
 =?utf-8?B?NVJUV21zVFB5dzYyTWcxMEU0dXkyQ2d5SHZ4ei81RVdWWXN5VEM3R25UeGN6?=
 =?utf-8?B?OVRJaFdFdDlsZktUWlozbDlRdTdoWmc4d1VnNVJkL0RlNzM4UHNGQTlJbHVK?=
 =?utf-8?B?L0lpS2ZjOVdwcElCK1hxZkZWMm9TdzdWU3NpR2J3eitVVTFkbzZ5NFlGR2sv?=
 =?utf-8?B?K0Q0ZitVc2QwUW5QR2d3TjhkMThHSFVBdzRBdXB1SmxEV0psTFI3LzRlaW5W?=
 =?utf-8?Q?/fgvEAWX74zRQFRA6KBFYjBUcZ4rEGf+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnVOdkVvY3RwY0wrUkpoQ05IbnVOUExKRVZ4UzQxZU05bEVqTlRNMXBzdjZN?=
 =?utf-8?B?RHQwQmg3WTIwZkY0T3poMTNYOUlVSVVtamxoV3NqSWhNQndUU2NFOUZocFBL?=
 =?utf-8?B?VCtEenpFVUZPQjVZMnh3RFRNYzVhajRpLytINWU1aURKYksxd2xuUkw0LzlZ?=
 =?utf-8?B?VHoxdk1qbXhmeDZqZGZLZFpXWmd1VW04eEhsWmw4Y1RMZGlHdCtxTm41NWFB?=
 =?utf-8?B?STAxTHI0NjhIYlpFNzVyamEvOVBCTzMvNTRUa0FlbGZLeC9uRVEzVHFFcWQv?=
 =?utf-8?B?elhGS1Qvb0F5a09FcHMyaDdUdk1WMlJsS1pudEVJN3ZCNmY5WmtkdkdlVDRV?=
 =?utf-8?B?RUc1OGtFZHJPOTBsZGtOem05RmdJenUzc1hZeDM3QVJiVkthcWNBTE5LMnZU?=
 =?utf-8?B?NzFPSmxUc2JTZnVnU1Yyam9PV3NkcTFQZ2QremRiRXk3dEJVSHFMZGFZclBL?=
 =?utf-8?B?OHVlS1BFUmptdjB0NU5ZbkNFcmJTTDR0QlV1d3hZOFM3MWRQZ3QwZFJNNnpX?=
 =?utf-8?B?NGc0RzNnM2YzSFhFQXkxT0NxRjNDMXB6QlJ0em9CamJWRndrMzI5b0lyUnBP?=
 =?utf-8?B?VDRFYUMvbWFNTVkrS1NHR0dMWlJ3UDVNQ2trdlpKdXhQR2RacytHUUJPNGFa?=
 =?utf-8?B?MHcvR2hTR2tRRjNBbGtRcC85cTN5UlhLZ05PMTRIY1YveU1QV0RaZExYWmFi?=
 =?utf-8?B?VFJGekZxVnRkeWtQajRxMDhZanFjVDF2eVNvZldZU3ZRTVM3S2tLOUpZeEM5?=
 =?utf-8?B?VFM3NFl4UGJMN3cvb21qZ1FuOEwwSVRqbFgzcC9yTC9lb0UvOVJWamRqQjJq?=
 =?utf-8?B?NDU3cEN5RFBzNGttK2JQMkhFSlBkdmhtbFg1aXhZcHVVQUExL0VrcmRpMU5m?=
 =?utf-8?B?M1hsR3RnZlpUQnRZNjFVZ0E1SEVVZ0dyTVAreFlNV2VUOVUrNTRDMXJnbUxB?=
 =?utf-8?B?dUxKVjg2STJFVDFTOHRmdENNZEF4WnE3bWJvVkYvbUs1emo4Vjd3c0RiSWtY?=
 =?utf-8?B?RnFscjlMdGkxMWJOODRqQUdSbWRyRUZ5NDhiSlpOMk1XazUwVzl4S3Jpa0Vi?=
 =?utf-8?B?WnJoTm1WSkNJOUphRzlYWkh1dWVKMVpSZ2FEano5SnFSQ0lmZy9qT2Yvb1ls?=
 =?utf-8?B?TjNBL1BtVmovT1BNVVMwczErRjB4cFR0cjQxWGd5endMb3JvUU50ZXUyNEpp?=
 =?utf-8?B?MVZSYlZaY1dSbzJnbC9KMlNZdWtUTHpJS1BGaE11YmYwSk1GNEw0NVVkOEFz?=
 =?utf-8?B?REI3T29sODF4QkhSZTJDalIwRWdTRnNuTjdQd0pWRUoxR1AxVld1U2RXWFNE?=
 =?utf-8?B?WG5Od3RTTzhMd0ZzNy9ENkUrVkROY1I4ak40M0E5UndTNEc4QnRHbzlCVkRM?=
 =?utf-8?B?WkxkMDVaWlE4ZlNXd1M5YUc5SkgwbTd6WkJGeDV3enVxd25nbmYxZDNLekYz?=
 =?utf-8?B?eTVpbW1URFI3NXp3NTF4TFFSa1pYM1ZwbEppUkxDU3c2WWtDVnVZOUpCQ21D?=
 =?utf-8?B?SnA1bnR2UlZGWCtidFQ3SXJGNW1kdkpDSytOVFVBQkQ1cCtDdTZML1czVm1H?=
 =?utf-8?B?THRyUFRLKzBkbWxoc2hOSDh4aGVLSER4bDJEb1RWOVVSRjhZdHhNY1RYSlZ4?=
 =?utf-8?B?NkZKRXJKRUlrVkpubCtpRXIvT1JnanNqclRDeUdBUldiR2RDSUZ5T213bmhX?=
 =?utf-8?B?Y3UyTWZROStqZFN2b1lUV2JvaXNMbEFUNEVQd1NreWZ4a1lVdGRienNFemtO?=
 =?utf-8?B?cGFEcmtYbzlwZ2RzTEY5azkvZ01BRHNMOEFSOEh3WFY1RjZoKzNnaU5MQW5x?=
 =?utf-8?B?K2JKckdoTThvR2p3dkp6OExkMHZLNkpWWVA5Z3pNbHhRQkhFWi9NV0Q3L0t5?=
 =?utf-8?B?aHFuOUlrVzMvZlpheVV0dG5SeTZJRWpEMkUwcjVDOUNzd3g1ZnNxdUtqOVVB?=
 =?utf-8?B?cC96SWExdGpxRlFZNGtEMWhHditBZTdkTDU5NFJOamF4Y2llYTROUWxhR0dD?=
 =?utf-8?B?aEF2b05QWVp4S2owRUR5c3hxOERHSFg0Lzd0clY4K3JXdDBFZHRpL1VIQ1Rn?=
 =?utf-8?B?SldHK3R0aTJPbm5jTEhSZ01JRHpTcWtxMkg2NHNieWt1QkRwWEJwTld0Mnp6?=
 =?utf-8?B?dXowQ0FjWjN4WngyMmJQT29saEE4WklQVnF4UmlWbzlqeTZhTHk5US8zbGtV?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jjFQS+cmhgy9BmcOUq0ijT7IoUig9ZCpoAUHgDQO1zn/jhNjbai2DkF6TJHqF0bsdneM7Lioec5iaY2TkYCVEF1zYkNWhpXpsGqszjl5XWE9md7fWmnpCCRoTiDetmjmCpNaL6dg6ar152sT7XYaGAbM+nfpR9m2vFI5zN8YZIywfCfnoHWZz8R8ImZr1dT0XVUItJwUivZsfX7Syk2t7BuqexzzkICJnEiae3DT9g60koVbMmkBvU+H2IRMTPU58oOsV4LyzaWhjpGdhGTDUCJ4GZZQT+jeRExFJ2vaQd399E26OqF5LZO96wlQhO6zXK98ynmRFPv7fHS5wsWmKM4THYnJplGY4YZpd1TNL/fPBmmif3S2vhWe9Xsifb3n2BrF0KpxzQr2X2LsPkdvY8ItAigSQmHC6ONzRQpKvLMr/zUrypRW7E9zSQsVEPJvHYq9RkiyUv6OF0oXIc86RJ2UauTePNuaRVYODciL9i5cx0vfUKnjE4J9uqxBHnxPBNQDOnLOZYu/rgClgxi/Q0ZjMLv4S4evUUg17ieZseY6TJ/RM95fFy1kRL1Y2CzJs3ot5b8PLgfe1ScrNA6NpxrJ2/6+1MVa6s6yrgS9JrU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba04a38-5e75-4d89-6d8f-08de3d789133
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 14:28:37.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFwzgA74f7aXA0wHw2+ws7FpV7cVkmARSb+yxDaanpQ/U7BdTv1MeZlR2+byvF42RVGFIbg4ZbW8GSjCJvJB/C3eLlT6WRXvtpU85fp5+X0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997625
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170113
X-Authority-Analysis: v=2.4 cv=Ot5CCi/t c=1 sm=1 tr=0 ts=6942be18 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=plmpkNYzeQjwkmFYCeMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0RTzpCPIyhuvhuPAFZKYn1QoEbJqh0MQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDExMyBTYWx0ZWRfX3IisjVrFtU2N
 McXF+J7Y2h0+7wPNsDmpX9487BOfuFG93MVxmh0Ga623MTXOc90GFULGlVokUABGN2P6wLm6AsJ
 UzhK0axFHvkw7Q3TpA7DXJj4QaYxqmZneDlrebWJ7l26R/UfqJxRAThMdO9PBrDs8v1+hn2vszX
 HrTVRvG8+V5PwK6upPWQOaA1ZTLOWI6lG2rpdHGJw96CTxq19rpDSzTN7UW2nXzrET1xqe4iK33
 A1PNV+v1iaKL/5R788gACkeo7Xp93RppFytiGcslELj0BvrAC4hPNZbIL1111PfH3mgDmFA027e
 pPownz6rUkQZBBIWFBockHVo7T4XWBWMv4ATTGaUUlEZpWSpoQqNQrcvo11lRjJQqCiUCT3MDcS
 2ArGcHgkMUQcXEiIEsczYyUf6rHc4w==
X-Proofpoint-ORIG-GUID: 0RTzpCPIyhuvhuPAFZKYn1QoEbJqh0MQ
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BF2918000C
X-Rspamd-Server: rspam10
X-Stat-Signature: 1nizeowxr1epopagajhcs9i5e3ms4aqf
X-HE-Tag: 1765981735-647864
X-HE-Meta: U2FsdGVkX1+Fcr1wPsn5U/8ybx5U8k9RoNlcxB/6bvxJnCW7PsUPBepk9D6iDrcIvQlmAgdtbjawB1H69pMoY7M7pzLf6jm1InMqRPHxcuJq1kwLLAQmD7C11RpDRynMTRNxglgG7SafMn/0+W6loE6wXW97yD7P2tuqcuwERtIbsnS+oSocuv7a8LfuwDysDvNL15b5m61UOkOHbDV0RDgw2YyIa5qusXUBobroYlSdrFHDmbRuOt9JdEk20NFTlXeVr53Y6FpDO0yaCsS4zoWhX0ZlloVLU0S3rpz9Mcgx0HX7BvOAIZHztYo4oBGozQRAG4U6ND7uekeY440qwbFxqitNyb39/OeFAlACgJi4F+QS/9/UBEMIFhZrvKsxCunW/sJ9JNaZ9Hso+l/CvXumX0JR0o4QBCpx8RUhc0HZltRo90TJ6mUlgdYoZz9mRfSx9Mx62dxbQtiZ6PrZq2Q0JXanqDuV/JtSypWrsetzGyIME/8M0Ovv2pykZbOvD6m5Ad36OARBKDMbJ77XJyMxUPsHnFsG+4nYgVsKgNvxxjCFdgMufUsfD/rj8WOoVPhFfOUsnLIDeO7KoP2SNCRCq+9ECdi+BIUQQsGSNNrxKn6qwVisKdf0optc0idQT68RpdkqzDvXBJPYpPjzBQSbHxW2R18GJBKXODaYhzv+28KsbTtM20NlLz784O1J1rhgPO4sgfL69NNeCLKAefhGgJKEGz+C8K9UKBZdgmXOD58gf+OCdfaY0voSZC8muIAKkh6laQIlav1PlXlb8kYNNESbSi6zs8FVy0tYFLcMSPb6P3+PJycxPPkURoRNINGkoh8Kd08dvihx9nwNWbhzCg6XezIlAhCWJCIGtHQydMCyEbug9xsZA6ryk3gkMNvdUwL2kP2ZZ2c8G39kE3E/kh2XluDxAt2zym+I3rRnRi6MQ0ADng7QrNzRf2s/W8fASjTRMcB2FalmWJU
 sy/r3Fg3
 IwRfGB68B6Erw2NsoEGtU0HOM+SqcbWB0Ujv/6VIkfSXid6ZI91A8BzRAnO4c1qOPt1fbt0baDovufSua7n1wpC60UE2xrX0iIq4T3hHqVsf3oDAMPKGW0DpjFBlkxvfwkKXbsBC9Ot6uX5tP2kjohxauOZ9JjjkOPPgvgTvqTnQli3WnWpDHnOud+xoPTjbJ+prYNMq1DBmSNZmKvgdQG4SKvG04qr5Q//ZUXBKUTmtEvhGRNQUtC8KKSTEzupxLg5sHdu825sjZH+N++ZqKY+gvUEXnaBKplicDFwO0ieAU+p93OQuIzfGa+lhsKAjhP2yofbqvY0GL+wjiMejNKFySJc0uSkrrby6FCHeC6UkkrfnsunsgvvdupFTScPFwwXozTrBSh0JV2OBrVS9QpCKfo5ms9vvOUeQQSTsPs7HpOR4J8rm7K6IfcQUghfMJKvHpRDxhso5xZoA8Xgm6ORZCqQ8E5pLkkmqb+deamQ892ry/RBXvIypMlt86tSHuHZWn0/hWfF/92c/z+ncMGeyzlH8eoFq99JzVQAaghKCaGGWfHa+UAw2HGGMlvQkJhD58O61BZ2258lClEhY1DhPs5B5cnMCTUjd3j7HRV6zFDI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 11:11:35AM +0800, Baolin Wang wrote:
>
>
> On 2025/12/16 18:54, Lorenzo Stoakes wrote:
> > On Tue, Dec 16, 2025 at 02:22:11PM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 2025/12/16 14:13, Barry Song wrote:
> > > > > > >
> > > > > > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > > > > > index ec232165c47d..4c9d5777c8da 100644
> > > > > > > --- a/mm/rmap.c
> > > > > > > +++ b/mm/rmap.c
> > > > > > > @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
> > > > > > >        end_addr = pmd_addr_end(addr, vma->vm_end);
> > > > > > >        max_nr = (end_addr - addr) >> PAGE_SHIFT;
> > > > > > >
> > > > > > > -    /* We only support lazyfree batching for now ... */
> > > > > > > -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> > > > > > > +    /* We only support lazyfree or file folios batching for now ... */
> > > > > > > +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> > > > > >
> > > > > > Why is it now ok to support file-backed batched unmapping when it wasn't in
> > > > > > Barry's series (see [0])? You don't seem to be justifying this?
> > > > >
> > > > > Barry's series[0] is merely aimed at optimizing lazyfree anonymous large
> > > > > folios and does not continue to optimize anonymous large folios or
> > > > > file-backed large folios at that point.
> > > >
> > > > Yep. At that time, I didn’t have an Android machine with a filesystem
> > > > that supported large folios, so I focused on lazyfree. But I
> > > > agree that lazyfree anon folios and file folios are quite
> > > > similar.
> > > >
> > > > >
> > > > > Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous
> > > > > large folios. As for file-backed large folios, the batched unmapping
> > > > > support is relatively simple, since we only need to clear the PTE
> > > > > entries for file-backed large folios.
> > > >
> > > > Yep. It is actually quite straightforward to go from lazyfree
> > > > anon folios to file folios. Swap-backed anon folios are much
> > > > more tricky, though.
> > >
> > > Agree. Thanks Barry for reviewing and confirming.
> >
> > OK that makes me less concerned, but you do need to put some more justification
> > in the commit message.
>
> Sure. Will do.

Thanks!

