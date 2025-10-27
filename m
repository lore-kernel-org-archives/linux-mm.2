Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D1ECCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5054680091; Mon, 27 Oct 2025 15:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCF28000A; Mon, 27 Oct 2025 15:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DB680091; Mon, 27 Oct 2025 15:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25C328000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:51:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C806712A22B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:51:41 +0000 (UTC)
X-FDA: 84044939202.20.14B9A52
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C53C40008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:51:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MVCKumiu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BNxmBu1T;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761594698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGRICb9bJXwiTc2Fj4rKkRHJWpAEK2PAQCwTK7Gbrn8=;
	b=nDmNEbS2xYwXee/ym03YBK/a26RPEHv+gx+yM8bG/1sTn8MonaUSCMwmPPDQsAvmqW+MKG
	fNAE9+leRqACP+87wRs7nrxABvDzAuMKnlZBDCQK7sUBXdhZG5Mh35PWJFfcFS8EX2YWcx
	8LPAVHgoIzZYsNMruiz3CK6bzO2Fm10=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MVCKumiu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BNxmBu1T;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761594698; a=rsa-sha256;
	cv=pass;
	b=QKRYBTRiWTjyJeZnUNXoRRf0EPhqX0i+DFL2ZtqPuQ99UsICeIo2J84d6iW1L33wbeR9uQ
	UTBCPejlH0HDq7tj7TAjPqAaX+Vbbp7kr28aZCt41s0RITUirCpywmHfG+V1oX9cM4G1j+
	XSV/znJb9oXJrF8kASxAj5IzaT64In4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RIhbRF025014;
	Mon, 27 Oct 2025 19:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dGRICb9bJXwiTc2Fj4rKkRHJWpAEK2PAQCwTK7Gbrn8=; b=
	MVCKumiuyLe2p6zJ464jnSE6JwTmPRj85eE9Oy/ELMFtuRxV9KsG1Q1Kkp+pm7Ew
	23iHIxyCjIRQfry6p3YntU4l33pav/zMKfVG5/uafUsriTJN2pYq3IlJS8NfXaS5
	BI4pjoxnc6Vg5CTlNX9i4l1eWlzHSaH7bfY5vVrdf8h22eq7KGR7nwqq4xsr9FvG
	386uHVlgPf4VNi0IQjN3297kut72OKLE2ObC/Ziaz4KAhNYyjDuBd9vkZTqoMC7q
	imUj3gxuNuB4QLpqy4wpYtihUJ8cjbU5U2ebTRtYeJYbL9IxWvgoWeZWRs1RB8uI
	6O5mjHtNhqiJpmFxSURMaw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357hu2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:51:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RI3U9r034917;
	Mon, 27 Oct 2025 19:51:19 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010071.outbound.protection.outlook.com [52.101.46.71])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pen415-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXdH1Xa5L9feQ0KsLvpi6NoBzy9020XA7TXg336qAkdhIgA8Eij6IT7mcREE9qvYD10YHB84lrdaxKD/VK4f1hfdg0q4kdTquYmY7vtWNx/1FOX5yoPJYqwsEhcyEQiCtBLyQ6FQeCRYB2rwBjxXGN1ToC8bV+EmMPCNEcSLA3J5Swz8CepaDLL5JrMsslAGca2jppUDDYuf1Jz2bvXeYEjU/lhzm8Xg0MXf+opZCso/nGfnPq8SesCS+qkgI3lKKaR1F9vT9Cby+ugHmZE8+eVUAY1WPVfk8pBh8RWoJ9mQtt8KaqedlZWGKiQdU8z7x1PNK659EbUzkTlyos2rUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGRICb9bJXwiTc2Fj4rKkRHJWpAEK2PAQCwTK7Gbrn8=;
 b=qmD93EC7rDsmQxkQr7g7JCW6pSTXbGvx5igbn10DYksv5kYK3pN3wS6z0V1ha6e4D2rL0TNjz1xDNoNu/7b9BELLcaMP2ZMxRlHhsO3XKlLnbE4yYKzDi8R0cuxzPC0GRV20pJ3Up1iQbi51aDsD4HGvy1IRUACPOxy2ptg868pCsqJclQLJ6cDTKbNdIaN9UWSn+vJuHEupz31yqWj529h4MYxdcaooVW4159TAPEIvXbQsNjA3BCbUYdX+yKvf3fxbJXPeZsuTA14TUuLJj4aZ+vWqJ28yp8t3zQ2Nmn6TFSl6aYYhpvVPvbN0HcyjiPoc5gGo7KzJ4dm65WNCyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGRICb9bJXwiTc2Fj4rKkRHJWpAEK2PAQCwTK7Gbrn8=;
 b=BNxmBu1TjCSvERK/O2pjFjB8DQWcXkg0qufByrA8Au529o5aMo4R0/krVXW1RrdU64t7eSHSHJHzq8JFMv/yW64Upu8tgadF0H0tpa7syhiegGK6Fxdg90sZyYReS5997yYh4jnWJSF4pj+7IWSWCiwSvWTB4LcB1slu6MP0jig=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW6PR10MB7688.namprd10.prod.outlook.com (2603:10b6:303:246::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:51:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 19:51:16 +0000
Date: Mon, 27 Oct 2025 19:51:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 1/3] mm: Introduce can_pte_batch_count() for PTEs
 batch optimization.
Message-ID: <0c15f911-cd4c-4ad3-97b7-e7153679f15e@lucifer.local>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
 <20251027140315.907864-2-zhangqilong3@huawei.com>
 <276b70aa-9853-40cc-8e7d-e790166706b5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <276b70aa-9853-40cc-8e7d-e790166706b5@redhat.com>
X-ClientProxiedBy: LO4P265CA0196.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW6PR10MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: fd73ad0e-abb3-45fe-d806-08de159230d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHM4VlVwL0tyUUpJWlNKZFpnZ2FseDNTalNrT2hIZjBsaVBGOTBsVGdVR1RY?=
 =?utf-8?B?Qk1VNklSZnJLdVVpamNSOXhDNFovSFdDYk1jR2RsaWhlNUhBd1U0dTZTTmhX?=
 =?utf-8?B?QVBScHZvVDJxcWh6ODFydWtNeE5mQ1R6YVZFQlpPaFRacDJweCsrNTh6TFg4?=
 =?utf-8?B?WldycEd3WmR3SmdabEFkUCs4SnZlVk56TExyK3lrZkd0aHB3d2NyTDVsRmFo?=
 =?utf-8?B?M0N2a2RBdlBEY1lUVGlsM29tanFsc1JaQU11TCtUaG5LL2dqNTNOdnNoODdp?=
 =?utf-8?B?UVdVT0JmMWk0YXNPYXUxVVpqb1l1ZEdtS0R0Nlkwb21WQVV3eG1TN3hPK1Bw?=
 =?utf-8?B?NU9lMVg5bkxvK2IyckVacStRcmlQdk56SHJncXZ5RS9ZT2l1dERlZzh0N2l5?=
 =?utf-8?B?bDFwdm5xcCt5Rlc0ZWpuamo3SlZ5Y0o5aUxVV1hhdjFycnRvaXB4cWZ1a3hS?=
 =?utf-8?B?NTZmZlkzM0pSM2VwRTF6WmxnTUcwUTNIblVVNUw2NnZabTBtRTJyL0k3VDQ5?=
 =?utf-8?B?THliblRhZVhuczhpb0tYMmdyK0J1b2lVREc2bkhPZzh3ZzhHMWlmUVJzaHZx?=
 =?utf-8?B?VTdIOE1pNS81WGsrSkFzTmk4N1Nsb1BHdXJTWW1qTXh3bzg0Y2xvS0xqdzhU?=
 =?utf-8?B?NzFtQng2U1JBU2tYb0g3NmtoT2VQWnB4YlZtUExTeUd5Z3N6NnF1YnBsZytV?=
 =?utf-8?B?VXMrVkhOcmZwMlViWGVzUWRucndDcisrOEM0TGxSVkJFQUtRTUFtdlJFTEsz?=
 =?utf-8?B?ZjIxKzFwa1QzaGZyM2p5UC82MTdTbnBma1hndGdlcHdGOFYxVHMvenlRYzdO?=
 =?utf-8?B?Ym81eWZkOTRwSG9Xb3ZOOWs3bHhsWldnVXloYWUrdHhndzBZU0UxNVZpUFUz?=
 =?utf-8?B?SWd6K05IdHR2czdUSnBBbmUzQ2lUUkduMWtYOWkvbDI3dE5uQkN3dlFrRzUv?=
 =?utf-8?B?dGVWTHNwRmFiZjRWWEc0aTFydWJmTTJBWXFKOG5GajEzZnNDV2xvZGF2eUx5?=
 =?utf-8?B?QzBNMmZaeUd3TjBRSU5lckNXdjFQUkova0srSStXTVVsN1dwRHhiQTUwT2xm?=
 =?utf-8?B?ZlNDeDVsd3NNZ2V6M2tHay9KUVc3OHdxNFBTLzRpZGFOb0NzbGZIdzJoMHlZ?=
 =?utf-8?B?L2pYMDlGNXNGeEhqOGtCLzkwTDNhQlJqam1DaG5oT2Jwd2M0ZldFVzRtcTAw?=
 =?utf-8?B?a0s1cVhMYm00VEpqYlJmVm9kakpIbnZlSDh4MS9NdXI4WHprZUN1WG9hZ2U4?=
 =?utf-8?B?VXM1QVE3d3U3ZU1Xb2xQNGtibXJ4VE8wQkdmRGlDV3BsL1ZvaThrMDJGQit3?=
 =?utf-8?B?bXFVZlpBSFM0RytQamlZTHhMSjlURmE3Rm5iTjBheTRDbE15RVF0QUdOaU1Q?=
 =?utf-8?B?MlFDM2w5VGxCc1ZxYWx0T3ZXRlJ0bUh3SGZxeG9IZWc4eTNVSEZaakp4WFRa?=
 =?utf-8?B?YmdyTXNNazNJTWJVU2QxdWIySFlmQkFLY3ZPQXBoZmlLdE43ZWUwSFJFYzZz?=
 =?utf-8?B?NDR3dlVSMXVKZnY2V1ZGeVRVREdZUndOd3pxYWdCaGR1NUdJRVZmSy9mWWxr?=
 =?utf-8?B?eVFyY3dFUW1mbkVrcGRBN0VoVDk4cE4vb3hjR0xxWTllVHZpOEdUWVBvSDFF?=
 =?utf-8?B?QzRwZ0JEZGFLNGtxSUpEdUxWUUdmelZkM0duaEMzK3VTa3Z4bjlmbTFrVVkw?=
 =?utf-8?B?NmZnVzVnY2NZR3FvSmNZVUNBa0EzTmMzekNCNlRNWkZLMDYyUVF2MmUxY2VT?=
 =?utf-8?B?QUVlM3pKdk1mRk40Wm4vV2trNkpjbXB0cm1pYk1lWk5BL0tFd01UU3JGSkw2?=
 =?utf-8?B?b1VmQjJaaXd6UnVzdktFcjI0emdmT1loZU9GTlp0aEQyU0dhSGtCRjE0UlpB?=
 =?utf-8?B?UDhjRTJrL05NbWVwSkt3dkNDU2x0WE1xUzdaS3A2Q2lZWjlQS2RwbnhMN2Iw?=
 =?utf-8?Q?xixm8FizCczkO2v2LFUH6oOb77wTqvgK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1BaRGxvbTNQQ3dPMFhWQmlka24xM1BTQmY1bkcrdExHQnQyM0tuWHVCeDNR?=
 =?utf-8?B?aC9PNVp1eUhrUmEyeXovVG5KYXROOXpGM1pEbnl5Y05PbWcvaThrYmxWekww?=
 =?utf-8?B?eVNPdHA5UVJrUzhHV0lRdlBnbFlESWcwRlNWVFp0K3h6LzFBV2UwYUFYUisv?=
 =?utf-8?B?amc2dS91STZkK2dEaVFzWUU5RTQyN2lCK3dvaVppcGVtM01tcXZncitsWHhO?=
 =?utf-8?B?RTJUVjlOWUF6cWxwM3RNdFd4d21STmpFb2xhMHRWd2RTTEZoaWFwS1hvU2tr?=
 =?utf-8?B?V2pzaUVWUHRsWk1oMW5Nc0NxU21jdzEzWEV0OXZNV3RFamxjcVN2dm8rc2Fa?=
 =?utf-8?B?VVFzUlE0dDlyb0Q5TGlDUE5ZV3BRMWZjeGxuUXlvNW1rMmtSY1MzV3cybEhC?=
 =?utf-8?B?VmFkZFlONDF0dXFTNjhlR2xLZDI1dnJFMXRxOExONm1DQ1dLeU5xczc0TVJx?=
 =?utf-8?B?LzJIUkNaR0xhdkwvS2NQUG9pekJPdzkwM3c2YjVaOTFnY1FZVnZTM3JUZ0c1?=
 =?utf-8?B?T2REWUI5b0FhdkpKUFk4TVNCUUZsc3V5bDB3UHg1Y3FuL0Q1RlA5K1QyVjFy?=
 =?utf-8?B?UlhIanpKNjMwTXFLMzZkT3Z5TW1WenNPOG5Ic29TV0U4VkYwSnBYRG0xMW03?=
 =?utf-8?B?MHJCZU1taHdKQjh0dG5nbUxPMHlCaWJsTzB2SlB4TVdCM0R0T1B4QS9wYWo5?=
 =?utf-8?B?SkFRbU45dFozc01pOUJSUkZzdkJDYS9sbmZ0MTI1bDlJUTc1Mi9uQjlOUkkz?=
 =?utf-8?B?Z21CdllmaWNRU1UvSWd3UjlRSlg1RlU2bnBxV3QxY3puUE12d2hzMTFmNXk5?=
 =?utf-8?B?SHZaQlFOL2g2dVdvWDkwbG1QSFFzS1VnQjBSSGh1bXpxbGRKYTRablQreFl2?=
 =?utf-8?B?aWwvTndHWE5PczdlczlNYytyVSttdG4yNFpuQlljUXMxdUVjQThuRVNKcnlV?=
 =?utf-8?B?SzRyNjFSSTQ3SFA5MWRlR0p3QzJVTms0ejFzSWszVVJ2ZU9tMGNUY1NNNzZU?=
 =?utf-8?B?dnhCNnEwcUFmTzZNOEJPS2hVOEpzdldrR05YQ1AvNEdXQXRTMWZ1L0VzWkRF?=
 =?utf-8?B?S0dIUXdOL3AzKzFDL1RzTlJiSTI1V0ZDdDN2SS9TSTRBMlNjcjNpVDE5bkN2?=
 =?utf-8?B?ZXFacHgzMnA2QWdnUDg5cWh0R3FFQ3BYd0U2YVptYzN0VnRlYWlIVzgrbUFF?=
 =?utf-8?B?WWo0QjlRSk1oS0E1TFFxSW1ndFY3MGlhY0Z1TDh6cndYUzE2bm9WK0NjVDUy?=
 =?utf-8?B?ZEZFelgvRkdjdWxNVUVNZHlCZVozNE92NTJKRUFFN1dSQUsycFJWUXNDUmxD?=
 =?utf-8?B?SEtuTmpiMjJOdjVIV0RXVEYzM3ZXYVE2bTlZa01ZR3RMVjYrZzRhY3N5VmVv?=
 =?utf-8?B?d0d1YlN1R01KaVZKOVZvRGVHcm0xdlI4Nk04V0JLUTNHWEFqc3pZNi9kN1g5?=
 =?utf-8?B?THpndUNJakxnMlRxakVyZEFYK1dXVE01ZU1aYVdYY1hQUkZSL1ltWXpQbE8v?=
 =?utf-8?B?VnE1bjQ4TlhGMHZFMXZSOHRJa3VsMVA4cGw3MjZZVXhPdHBNNFJ4T1lQWDRM?=
 =?utf-8?B?TjBGNmxMNkdSa2V6LzNSeWltUzVNWStvNU0zbjNBeSt5azNSSmZxTk91NmJk?=
 =?utf-8?B?TENlUUZVdXV4OWV6OGoxVWowSlNWWW1CUFg2VkJ2eXNQaE8wQWFvc0hmRlpj?=
 =?utf-8?B?SDdmZnRtZUhVU2hTcDBGYld3bWtTeThJRE55bEpaL2RxODh1TzRrblVabVNi?=
 =?utf-8?B?R3lQZXBUdHNaTkhxV1R2TXY0K2thZUNsTGlDL2dVQjh6azZyVitOam1pOUFk?=
 =?utf-8?B?cHhUOXQ4cldwNzd4Ymt4NkFaaWUvdTk3Qy9LZTFQYTZyMXF2ekcrMEV6Y1dz?=
 =?utf-8?B?TTNKSlhqN0NDdE5QOEtYQ0JCN25hKzRFQXk5MkNteGp2a1VENWZWZ1p0b1Br?=
 =?utf-8?B?WjQwWjZoVUJVUEJObEFEaURyb21CbEkrU3NSbkZmVXhDRS9FNEJOcWc0cnJX?=
 =?utf-8?B?UDl3T2d1SnRITW1MaGh2SElMY1JrcENVNkVoYkFyTm43VE5GMmJqRWtQWTZk?=
 =?utf-8?B?cHg0WDNJaUlMOW43cDVzWHlxVDY1cnY4Q2s4YXBVaWNRY1dURHdKajBTbTZL?=
 =?utf-8?B?dURoMjFleHpUMnlCeE9TZklQanF1a25KbENnYW5yYnFnR2VUZC9OUXVXSEsv?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tb03bORObYNEhTV8/NeEgfJwyi5BLNZIPrEDnb90dBedZWci4IfuTQNpCfmKjBsUbwP+a7xWCSyyMm/Ds6XEsN11fVueP+Cjo1wDpZLQGaVxPhi1ZF60w+GZA+3fiMld8inkI1NmlsyixAsVrgODuxsJnesnfoc1R57kPL2tHoTH0aiDruZoNI66nOZD/UXF4192DCD6xi/0vbC2Gfy1O4ROcRYEXRtnCuJSmKCw470O9TlH0TOlAzKaJ4hcCPPedErL2l4szOxKnfpVht8jMcMhMhb3slsX9ZgvTsVslV8r4xZMQEARq/bFYO0UqV+Ou/cuhzRfoGlrDBSaN4+Jot29K3CXPBWW0pvkvZXBS/70So9sEtOzuAwQrlrbxPS7hq2yA0mVyERG5iUKwuUCaxNjAjb1l/kRLeGC97l4RsTzSTvk+Ta5SbGeTfHnEbhfNertat3Vl89FTfgpnmMvmBDfDsB127xwoJxFFzIRAhWAYPxYPMKobYJRHXzIuH0J26jdaVzoSvywMF+Wxkou7B/6zyYMMXwxIfrFRiSvdg0AtneisqSZzVBE7qHdQGp5xi82cWhTSeYiP/pykiXpVRmQ2Lih/bkFYoRBYD7JVyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd73ad0e-abb3-45fe-d806-08de159230d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:51:16.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lnc/hB5QWBH+DzIwi8Ov5ulKF+hmpmECFMil72gX38iP2AirXx0u1ewke6otjgLAZcP3Nre3/XJ7AHvzfT2A2iFnGwxrlP3OsBFuskCI/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270182
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=68ffcd39 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=deDIJCEiTfKNnnNhykAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12092
X-Proofpoint-GUID: v_Old1BdspbeplyKUchx1cZQdzloWnFA
X-Proofpoint-ORIG-GUID: v_Old1BdspbeplyKUchx1cZQdzloWnFA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfXwMcwqx5Cjryo
 M5yqPJ2wytcPEfsNYNYa4Oyd37V8jr3Kgm2oEQOcAQMjaHj339uU7oOfTCRiZanejwiYhQ4a0A+
 /qvBdKdv1bweVKsBUTU0pgb2SVRjNHcklg1NuYZ3w+WAuywDdyAGg7unXjjtvzr17CoY26+hRNA
 /Yp5IhXzI0g0rPcYDiXLxGGv0kZOeEmu2iJzXmG263qs+dGYP8YoMMVlz4pVhvH9zkaOxs4Epn8
 3hl0Ix0jcMvswcTZTqqiYPKYeqEzFEfJ4s/81evHfsUBOZ7Ffk7N2+eE/35qAOIbUsX4z0u6IQr
 ziagfVA/YlrgJag4F4t/4cgqqEcT2wzPMgJlrZVon1Q+3Si7a3ptV39Ap7h4CD+70QgPXTTGUgW
 YVHjTPbFEps4DX+kaXorATGP+VE7ciH+NeJNMVOJ/M2ec/9KUuw=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C53C40008
X-Stat-Signature: i8wy8bsyzgownwxw4wb6r9ddordcwrpf
X-Rspam-User: 
X-HE-Tag: 1761594698-353037
X-HE-Meta: U2FsdGVkX1+gD1vazbA8TjGTIXaTltaieOAE0GVbJpAhUY8u1SWkIxtMP5M6oBkBc++P8mwnLSUziImAif8AL/1zB0Sl+Hq2y8sWPbfVy42QwaRF1mJ13e14vuwEDNX4a9XhtcKpMLPview/7oftJd166WiMBeouqYZN0SO130SCXTIR2oFnPFdFFaJu28aVnzuWczGHf4xuHq51du9YSgYIKiZwLeVB9f0UjF1YBQc2gVwaOMDeYM45b3GpIkoxxggNaWx/rAsNLLY0A/S6JraMoszVbl6GiNX4LkVIOD2HbpMvroPDuwNkJboMeRguLfOHRRLX95+/BKj9PvPCMOiagQ0l0w1vBiUe3adIXMtaougiBlX2flmo3pnqaGU5L5Ul7UYIplK+HgYrwRuzNpgFxXe2NwcbT5277ySGdYtNmw9lJx5SUvi9ftf/lb9oVVbDiHAUp3ouB50zSesxSPSCsFc1MjVYIfFPNc406iGnFLsik/ZgFgrtXVZKBSWnD+y9OGHHHIh9exv+K0riRB7BOWbQgz/6rM7ACSkwwxn/27tac1od2dRhcy9fKOHPLcdWNhuJYkyH8qmuUGk7RZMHCo92BGsmVddlZvmz2ZXPqPP+85pKR7uXLOdXCocOxUd/2i0krNa4ORHAJfop5BJctc4+AVRngKP0fH05eNg9QMNBPg4qPXYGGDk2p8HjyXYxP7By7nhd4Wbac/s+e8WbV+B0EqDGHWqLFi36ObmiM/0g5HSEM8EHngf+tNQ8UthLVS+uAKjli7rmUpUHhfy0gEk++E9ISFqhH5vAl+kky5b9ZiBZZhcd5eFGMM45RbGiL3Rf0jfSR9lNNuojekZMat2shqUdchN8DBO61hq16c2J5U+FQjsH5J0xBwkUy8LCZfq97/KDu8Dbma2cfOvsEUOHK+an+4g1ikmDBnp4cTFHRDztaQO3QXomujxmsFycdnMfO/BECabFWFj
 5MSIsHvm
 2ufmyjl8EnYyqbz9z1K5Z12zmImf0tTIcqskR95tLX+EgLVYfZXtqnGRyITEnG/9ou3D95Ktj9VFKpv6R8RrqLM5ltw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Dev, Ryan

Please ensure to keep Dev + Ryan in the loop on all future iterations of this.

On Mon, Oct 27, 2025 at 08:24:40PM +0100, David Hildenbrand wrote:
> On 27.10.25 15:03, Zhang Qilong wrote:
> > Currently, the PTEs batch requires folio access, with the maximum
> > quantity limited to the PFNs contained within the folio. However,
> > in certain case (such as mremap_folio_pte_batch and mincore_pte_range),
> > accessing the folio is unnecessary and expensive.
> >
> > For scenarios that do not require folio access, this patch introduces
> > can_pte_batch_count(). With contiguous physical addresses and identical
> > PTE attribut bits, we can now process more page table entries at once,
> > in batch, not just limited to entries mapped within a single folio. On
> > the other hand, it avoid the folio access.
> >
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > ---
> >   mm/internal.h | 76 +++++++++++++++++++++++++++++++++++++++------------
> >   1 file changed, 58 insertions(+), 18 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 1561fc2ff5b8..92034ca9092d 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -233,61 +233,62 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
> >   		pte = pte_wrprotect(pte);
> >   	return pte_mkold(pte);
> >   }
> >   /**
> > - * folio_pte_batch_flags - detect a PTE batch for a large folio
> > - * @folio: The large folio to detect a PTE batch for.
> > + * can_pte_batch_count - detect a PTE batch in range [ptep, to ptep + max_nr)
>
> I really don't like the name.
>
> Maybe it's just pte_batch().

Yeah the name's terrible.

But I'm iffy about this series as a whole.

'can' implies boolean, it should be something like get pte batch or count pte
batch or something like this. It's silly to partially replace other functions
also.

But I've doubtful as to whether any of this will work...

>
> >    * @vma: The VMA. Only relevant with FPB_MERGE_WRITE, otherwise can be NULL.
> >    * @ptep: Page table pointer for the first entry.
> >    * @ptentp: Pointer to a COPY of the first page table entry whose flags this
> >    *	    function updates based on @flags if appropriate.
> >    * @max_nr: The maximum number of table entries to consider.
> >    * @flags: Flags to modify the PTE batch semantics.
> >    *
> > - * Detect a PTE batch: consecutive (present) PTEs that map consecutive
> > - * pages of the same large folio in a single VMA and a single page table.
> > + * This interface is designed for this case that do not require folio access.
> > + * If folio consideration is needed, please call folio_pte_batch_flags instead.

I'm pretty certain we need to make sure we do not cross folio boundaries, which
kills this series if so does it not?

Ryan - can you confirm?

> > + *
> > + * Detect a PTE batch: consecutive (present) PTEs that map consecutive pages
> > + * in a single VMA and a single page table.
> >    *
> >    * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
> >    * the accessed bit, writable bit, dirty bit (unless FPB_RESPECT_DIRTY is set)
> >    * and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
> >    *
> > - * @ptep must map any page of the folio. max_nr must be at least one and
> > + * @ptep point to the first entry in range, max_nr must be at least one and
> >    * must be limited by the caller so scanning cannot exceed a single VMA and
> >    * a single page table.
> >    *
> >    * Depending on the FPB_MERGE_* flags, the pte stored at @ptentp will
> >    * be updated: it's crucial that a pointer to a COPY of the first
> >    * page table entry, obtained through ptep_get(), is provided as @ptentp.
> >    *
> > - * This function will be inlined to optimize based on the input parameters;
> > - * consider using folio_pte_batch() instead if applicable.
> > + * The following folio_pte_batch_flags() deal with PTEs that mapped in a
> > + * single folio. However can_pte_batch_count has the capability to handle
> > + * PTEs that mapped in consecutive folios. If flags is not set, it will ignore
> > + * the accessed, writable and dirty bits. Once the flags is set, the respect
> > + * bit(s) will be compared in pte_same(), if the advanced pte_batch_hint()
> > + * respect pte bit is different, pte_same() will return false and break. This
> > + * ensures the correctness of handling multiple folio PTEs.
> > + *
> > + * This function will be inlined to optimize based on the input parameters.
> >    *
> >    * Return: the number of table entries in the batch.
> >    */
>
> I recall trouble if we try batching across folios:

Yup pretty sure Ryan said we don't/can't in a previous thread. Now cc'd...

>
> commit 7b08b74f3d99f6b801250683c751d391128799ec (tag: mm-hotfixes-stable-2025-05-10-14-23)
> Author: Petr Vaněk <arkamar@atlas.cz>
> Date:   Fri May 2 23:50:19 2025 +0200
>
>     mm: fix folio_pte_batch() on XEN PV
>     On XEN PV, folio_pte_batch() can incorrectly batch beyond the end of a
>     folio due to a corner case in pte_advance_pfn().  Specifically, when the
>     PFN following the folio maps to an invalidated MFN,
>             expected_pte = pte_advance_pfn(expected_pte, nr);
>     produces a pte_none().  If the actual next PTE in memory is also
>     pte_none(), the pte_same() succeeds,
>             if (!pte_same(pte, expected_pte))
>                     break;
>     the loop is not broken, and batching continues into unrelated memory.
> ...
>
>
> --
> Cheers
>
> David / dhildenb
>

Thanks, Lorenzk

