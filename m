Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268E0E6B25E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 00:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434566B0005; Mon, 22 Dec 2025 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E18C6B0089; Mon, 22 Dec 2025 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298866B008A; Mon, 22 Dec 2025 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1725E6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:37:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DFA08958D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:37:12 +0000 (UTC)
X-FDA: 84248871504.01.B2E9C2A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 210D014000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:37:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mE19hmfK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pwzvom2w;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766450229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6d86Qbqn6hwgmm7+RbfbCcM7wq65dvSVyNw3PjLfHxc=;
	b=wfiBdrodOVX1k0WBM3BbMMm53/uMBggh3Bz3MSh0Thj+ERUn5UoNyNGNLoGv0nbqMimBYa
	vkmKBGHqX4tcGocRykQFacv4U5lTST+/q1pyhiQSdAcVmp84uDULeoAtxHhMrOrz6yGFN8
	6EiETDnfW88N8WDrPKAUqqx5YnpiWCs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mE19hmfK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pwzvom2w;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766450229; a=rsa-sha256;
	cv=pass;
	b=FcpusYHdWVOQu0SNlYpXsIMitGVdZ6fNgfjmSjotq2eNEkk6KCzRfsc23WU//Fqy2EtmwH
	7QGh3ZGfRdbuJ/kVzckYRB4CnvLgsFgsFPiFiXI3vIjcbq1NArgfgd0fYrSWAvX+CTeigz
	9J7UE59+iKT6dp+pmE/r08oncAwkYD8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN0KTJi3383605;
	Tue, 23 Dec 2025 00:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6d86Qbqn6hwgmm7+RbfbCcM7wq65dvSVyNw3PjLfHxc=; b=
	mE19hmfKL28dtz19RGxIb0MJS6C0587kA5BG43hU6UriYPrye3/XZ9L2KwGKhbhR
	rLQrH1Vm0UsXKbbKOkX94XllZbz4x8exnWH/UAgSZthhK8JmjbzCzSDAxRypewe3
	cbhjaMPM63Hy59P9D9PmiY5ymDawny1s7T8/rwvnjyWzGUKoSJi9kMWhJyfEMFec
	pW06CZ/veCjktzGu1cUrJCTp+tpLMQSrZEPrnLm16bWaEo0n5O/MHLb0GXFzROMI
	qddsK2vi7IYr74uoe7U4u5Mj6UoS+LEVJ33ZYGBCrLy0iSIYC5vsgLj1MLhZeZJU
	GxDvCeuPcBA0GAW9NA2cmQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7ges80s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 00:36:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMMoSVe016542;
	Tue, 23 Dec 2025 00:36:54 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010041.outbound.protection.outlook.com [52.101.193.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8hwuqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 00:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PLy/uXJkGwfdG3YKx6awRqKQ9THpebzVWZDEuYfTKDook7j8tfxByxMslYpdYF0xYh2TuOR4scfvAE8I0A21PKPHfpzyC/B4SerjdqLOszFm56L/eSLiKTMOtbxc7DISOVd8zl5F/KbRQP1g+O+m3ZRjE9d+lbeCg2gF1GT8nDZz3BvPAnG72zEGsUKuxrsSdmsrZRXy6LAa09AECHH8S7Gd8vCN67p4UYozMs36JcgBXE4tb/M5WGdRpYWlduvJq170xbSeNMx13tPaRqBPfFJVpjdZQoJKzPgAXXyvjVlpo+YktkywUwPFsqIcI8/0W0seMIN08P0NNWoD8FmnYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d86Qbqn6hwgmm7+RbfbCcM7wq65dvSVyNw3PjLfHxc=;
 b=JM0pC+HUaBap0VRa4PXKAorP5O+cQV1hWMUmc0XJRsAOqEcJhfPfJ6xL+myJdTTikQb0sVWLpAf2PxfczTzoNodhFIJ19vs9WSWrpjGU+OXvoaCJhNPS/qnAk4ClRaBp0Aoqx3oso4lLEnDS64OgXxbaDljdLqguepA43R1Uq8xAJd72pHdXxNJY9C0AjA98uCJYEgGD1K46+ao3q5BjnXhqL8Xy7e+funxOcDTmZC11EqRnT4q2wmo7dk69+oZdz1N8Av4lP0WffWQQ/g+OqA1tdCbrtwxkUO6F0f3yWrSc+2954MmLX8E9pcr6RQGuTHsvtgDaf+LxxlutSo89MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d86Qbqn6hwgmm7+RbfbCcM7wq65dvSVyNw3PjLfHxc=;
 b=pwzvom2w3v+2SXN4N/bjuIJoA7wjvSlxlQvXCufYKPsbWrH315snGZYfmUNqL9DOAtZuieM4BSRTc6EsGW5YCKsGjAEXXbEO3ewOcotiCbXfSCHIjudIyleTpR4dU8m9bquYht8/itJKatDt+ogA5j7vZxNrezZEBoFfGCI+Xtc=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DS0PR10MB6104.namprd10.prod.outlook.com (2603:10b6:8:c7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.11; Tue, 23 Dec 2025 00:36:50 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 00:36:50 +0000
Message-ID: <bb051136-abe2-453c-8181-614d283403b9@oracle.com>
Date: Mon, 22 Dec 2025 16:36:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <20251220151301.b0ec3c1aa6527b0b1bca1e4c@linux-foundation.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20251220151301.b0ec3c1aa6527b0b1bca1e4c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DS0PR10MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd24efc-0da7-43ea-f69d-08de41bb5c5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFdkc0dMVHdWQ2svY2owNFZYTWdQVW1hUVQ3T241SjVhN1o5MUZVeEhEYnky?=
 =?utf-8?B?QWpTdE15c1JoVzM0cnRTN0xhOTlnSDhOTU1Sd2ROSE5vYjNrZW9IYUc1RmR0?=
 =?utf-8?B?bTJybFBjcER5Wkd6V1p0R0phdEhreFJkVmc0VVVXYlp4SWcwQ0gycHNDVm5p?=
 =?utf-8?B?d081VFZ3NjZwdDBFQjhwWThqcDh3Y1AvQ3Q3L0ZkZEZDalVDVDA5Kzd1R2Zh?=
 =?utf-8?B?ckpiUTE2NE5BL24wRGVkMlBFdE1QSFo1UU02aUVvVzNHeFU5b0pwN0dkQUsx?=
 =?utf-8?B?OFBSZy82WUU1eDFSR0VnUnliN0dVelZHYnZxRWJpY0c1bklUdnFFcmtCelBR?=
 =?utf-8?B?dW8vcFB1NDVRMHJkSnArcXJIS1JJYkNCMWNGUXZ5RllCbzl4YWJkc1E5dE9a?=
 =?utf-8?B?STQrSmZvMENtV1BnOVEyclcrUUo4M01EQ0JERHdUSndjZFZPY2dwR04zbzNt?=
 =?utf-8?B?TENRK3RZUm84NW1vZUtONDEvUk9QMU8vYXBoeTh3UlBTVnErdjAwbmpqRzNI?=
 =?utf-8?B?VXkvZVlyQmRmdW5sMHpaTExkWXkwTExMc2Ivb0ZGTGtmWmZTQ25Dem1qOHJp?=
 =?utf-8?B?ZklwS3poL2Zsc0h3T09xc0dQd3dZbXlsM1ArbWZ4Zkdoc0pPZEFYUkRUdDJM?=
 =?utf-8?B?bWFadnJYZXkvTjFGSHY2U2ltUE4zNFhkS1ZGdEVXWWV2Wkd4dlN5Znhkcm5I?=
 =?utf-8?B?SVEzUlF1S1RrOGVReFZOV1lZRkw5eW9VWGY1K3RObGtkenhURkRGNCtNbk4x?=
 =?utf-8?B?Q1ZpRXNERGhUQ3ZHR3MvMmMvQW41ZVc1Mm9Kb0U1eEV1aVNMeVZDRkpqQ0Z6?=
 =?utf-8?B?MVRvQzY2ZkJ4cmh0Y3JXRXpSMmF6QjFzN21qSTVpNTlQdUxOUFcxVGorYUs5?=
 =?utf-8?B?QkUxNHFYWUJOcEV5T2dEQy9uVGp0ZVJ1UkpqUVQ0Z0EwVGFQNHUvbWRBcERa?=
 =?utf-8?B?QzlvV214WkFGOHdkWTZ4d01Ed2dKaE9VVTI0TitCMlRJMFgzZ2dDZnVCZkFj?=
 =?utf-8?B?NE5CTEYzRlFLZytLblN4K1d4T1FKNWw3cloraGVyRGpZZHNZb0tkRGJJQnJ6?=
 =?utf-8?B?ZGtTcEVkZTVwbGJVY0RkOW9Ea044WjlScFpRSWt5cENodDFNdHQ4TW9vb0Ux?=
 =?utf-8?B?T3JyZ0UyckVGR2NRQmJDUndER3NaS1grdlZrUTR1UVFqdkp0NWgzL1BPMStq?=
 =?utf-8?B?NXNlYmIrVUw0OXlHS3RPMmhkSHlVZVFtd3hDUDlsMWl1ZElQUWs3eHlpejU4?=
 =?utf-8?B?d2ltcm5mdDhPelAyYS9Ca3BOZkVxQXJncWZUYnRKcDY2NklMcG54NzJURzBq?=
 =?utf-8?B?WFczdm4reDNLYlpCVDVSOHJRTjQvd211UmRIbFdTZHovWXV0ZWdLWThlYUhn?=
 =?utf-8?B?d2NzdENFckdpZjArbUFFRjVXMmpoQXlGTFBzMDRGSXNaazdsMzNVSGxseXM3?=
 =?utf-8?B?WnpjRnRtWm5Oc012RjNDREU1Tnp1M1pVNmN4c2JpS2xNcTBsUUFwZ1pOenow?=
 =?utf-8?B?YXpHeXZOenYxQTMrSmFmN1RGMEZHcFFQLzE1V1c3RnE2dXZBNnA2VEZYbEt3?=
 =?utf-8?B?a3FzVE5xSWJ1YjVaT1dwOTVyRll4eVBHd0ExRmw3ZWdEOXh0c0NaV1lQTlpB?=
 =?utf-8?B?K2xoelpZcVk1QWs0ZCtPR1IwVkcwUXFtQjFJVW5obXg2cE5XbURDSCs1RGgw?=
 =?utf-8?B?QkJQVnlybHk5RitlMERMcjhhWTNWTzdQV09JQmxsQ2RzSS9KY1JTR2RQb09u?=
 =?utf-8?B?WnEwNjdweVZRY3dsanp2VVltMk9MZ3orQXBKenFVd25xa3pGV21kY1pDeWNl?=
 =?utf-8?B?RzhLL3Eyc21tUklLdUJsaVNKeHhzVzdEdmQ2WWpsQ3JoREVzTS9JWWthcnFL?=
 =?utf-8?B?MG53aTNzUmhKMmoxQ3JkbVlJQUtWS3E4Zkd1RnA2Rk52bjFpTnk3dGRKYW1a?=
 =?utf-8?B?RGFlNXhXM0RIbTBlaWxwQzAvT1l6OFFqSzRVY2p1SDRyK0xHU3pXZTJNY2Jx?=
 =?utf-8?B?SUt5RE5MUGhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEprSFQvSndya25xNFdweWVBd3dZa1lSYndQSWJZU0RKVEVjcUFjRXNaVzNK?=
 =?utf-8?B?UGpvaXRjNEZOY1lWbk5sajIzNGpzK25XM2ZJNlBTY3piYmZRWUxBdU1lQTJx?=
 =?utf-8?B?NVdSTFZGdjdadFhLbkhRYzNwQjFjd2VvUThyM2x5V01jSFd6bEFwOFAyc1Vx?=
 =?utf-8?B?N01yUjUvVHBOckd3Y3FOQUhGWlU3UnZJdEJ5VlJrcFI2RFUvVHpOY09CSzhK?=
 =?utf-8?B?YWhqNm54RkFXMWNXRnk2R3hnMnJyQlhKb1Rhb1JCRVZFNnk0RkZRWmZJUk9p?=
 =?utf-8?B?azl2MXNJMm1jK2hFSWY1QzlML0ZNbVdjYnllU2FIYk9kMVltSUswUjloNFA5?=
 =?utf-8?B?cVZaaVJONDhSVUxjUjRSZWhmMjhJUnhFclpOUGNpblZkTytTWU9GenpaUENO?=
 =?utf-8?B?YkNDbVJrQUg3bS9DYndwK1pqM3k2dk1WaC9nT3Q4Rnd3U01QOFlUeU83Mkhw?=
 =?utf-8?B?REtVSm1OZXFvWlZ6SzJmWlBoYU83dVEwclZQeHBxcHloL2ZJbUs1WXB4TU5F?=
 =?utf-8?B?akkzTjRzZ3dpMytkdnZuMnpwL1JKSm9RRDhTSU1YZWJVSk5PVldqUGpSVzJs?=
 =?utf-8?B?aW5oZHN4Y2pSd0I1dXMzUWttR0F6YWhRaUhTNlRjYndPczRadUIyNXRNaVBt?=
 =?utf-8?B?WXJSOEJzZXlFTnVLTlBBR0sxQmg4TWlzOU1SUGVQSnZvTytyMll5cVhJdmwv?=
 =?utf-8?B?a0Q4R1VLblVLdHU3MGRUOXNFZ2FzTG15Y3REODdiVTZDblRmNGNkYmYySDEx?=
 =?utf-8?B?YUpsaWxFbHFpUHV0RXBvMURqcUhUOTJQRzlpSHpCZ2hucjRFZU9ScXNCOURj?=
 =?utf-8?B?T1ZLNWtoRURFOVkvaWEzaE5YVjR0K3ZjVm05U1Fid3JFT0FFYnYzU2w2TmFt?=
 =?utf-8?B?eHJkaTBMVHlDL0lKZzZuZmhieFpKTE9vQXpvb0cvQnlBWE4zZXh6c2lzZXFK?=
 =?utf-8?B?anpsUTY1N1FKZGpNOWx3SVNqSzN1ZzVYUDFnMVZ4V2hGb09EdDNHYzA5K3pB?=
 =?utf-8?B?RE5TRkNnOCtGdjZBb2laKzZlbnhlK2hkSWc5d1ROdkdlS0xtbFpTa3BiSjVY?=
 =?utf-8?B?TXpJb0lkdkJ6OUFaTUEwMk1qWEhBVWRsb2cydE5GdUdCZEhJM01EbUpaODY4?=
 =?utf-8?B?VWFhbFRycE9pb1hua1lVYTJOT25nTGdTaCtIRWVwN0dUcHFOTEMwZzI0dTd2?=
 =?utf-8?B?WkN3SU9rcDdNM3IvNmdkOXVZNUNwVnRTTHZnZUYvMHpMMjNxb0RHS3hIaGlB?=
 =?utf-8?B?YXZraUZPbmhObnFCZEVtVXpVdVhVTSs5MjR5Z0pJdXlidk9UeE1saEhoRVow?=
 =?utf-8?B?VGVMaTVZZ29zZlBMcGt0b1FTa2JkUzVlWlVWNkg2K3NyaFNMZURXTWNGU0Q1?=
 =?utf-8?B?TTBwVDM4MDBKbU9NNm5Obk5OTE9ENEVsdzBncXRZbDNjY2J5Z0ZvM3I0NmdK?=
 =?utf-8?B?bU5scFplMnBNYTB5N01hSGJRZ3J4SVJxQ1MrcTBwKzFzR2FDM3BJQ3owOXJu?=
 =?utf-8?B?SVRPdnRaRmtZOEVQZ3I4L3hLbDRiQkxIQllFY200QktyeldITmNUNG1vZFBL?=
 =?utf-8?B?ZWNmVWJJZjd0eDR4Z1JMMmQ5Ti9IUDlUejd2T0RyUmpkWkJaR1Ztd2xMc2pP?=
 =?utf-8?B?VEs0VFJ0ekp5U0FYSDM3UG5ad29oS2hUNlVtMDhaR0JFVkRQVll2dXdXUXlO?=
 =?utf-8?B?V2VkcC9manBXTjFFMTZUU3hFTnZuZ1FoNHJJV0NxMjJrNXpzekRCSlRjTGlH?=
 =?utf-8?B?SEFZVkpTMGhNajFRM0RxeGpVV3hQd1hmZ3RRa3Z0UXFBWVl5Sm9jejU5ZGcz?=
 =?utf-8?B?bDc1RWxKVktaNjdJeTFrM2FsbjVmNzB2eEd0eXlJNFBNSmFVbG1aYXZwZWRK?=
 =?utf-8?B?dlgvMjhGT01wREpoOWRnOU9xL2oyZTFUMWxJQWd6ZU94WlpuNWlFNXJZdUtY?=
 =?utf-8?B?eVlSME1IWldlMEdNOGk0clVVRVNNYnFBVkEyV2V3VTFRMWpXdFYxa0VvMDlY?=
 =?utf-8?B?cEl2M2p2TEFJelR6bVRReDZ3TVpMUUt3UFIrYllyK2piaTJ5NkROenFVeFVj?=
 =?utf-8?B?SUdnTnBIbEswT21xK0xzQzNjZUlnV1VhZ1VaWmt1SnpHYjU2bmtrQ083NXQ4?=
 =?utf-8?B?SUh5ejhXSFF2cVpyNDBSTnRBTGw3WEkxY0lNdkN4aVhjbnhIdkEwQ3VaMk56?=
 =?utf-8?B?R1M0ZWdTYWUwTUE3bDJLTGpwdExFdlhTbi9mTE41dnJiNUxqbmp3QW1taEgy?=
 =?utf-8?B?Mll2MHlZMTdReVN2dkpNeklKMHcweWMzYTZyd1NHL1RzenNZbHgwa1hsdkU1?=
 =?utf-8?B?Wk5GVkMvMGtHY3pNZ3N5Vk1jLzNlSTYzbStyY1p0TzY2SjJmL0REQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o42oiesqqkfmulNaSb5oCOXbryGSFnvqsd+rNUCLKr9ZR6E94BbqLoiYC7L42E0zk1s3Cj8uf4zFsEJf9kVX/iMASF/BFDjy2VHqwTk4qslyVyN8j2RolbKLhORIP4NA15wls7Vg4DdojFAbUFAPA3JNDvLaCwigKKAoTPJRSZiuIJiSuR293Qfkita/tsm0sgdcHj/HjqkRB1vp6HmaUFFOaY3l9HVdCnr1u1iebC1HEgxxqt+zUEACx6HW1i6rCkrkPtQQ9jjy9H+rS/NX9+DIHdg/wOY5jfSdMkttOz0QLFU8TIgp5MSWQKCL1Ycl3riuW5+nw/kBqZMN2LmqiWkg0eLJ/WJxBtoF4DyWcuXj4zdWRKjFwXuyFMFWFCmVCSjnEvuk2EyKMFPvxWWpWyOELnCTAdeKA1H0oyq1chSi102o53Mes91RaQpv7AmahwSy5CLm4Ifiod5XK5U3gDq5IeD0pFiJiw8teeaPiCbH28Lta0aUve0SBFFKdpk2EiBPwuCWvkE3JF7fqkZ1s6CgVcYUJQte8bbIuqDKS3TLeaU8weDgD0n+F76w+vsg38DpcibiIRaPLluBOae7Yn6W1OcCa8kz3fZFqDw3AUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd24efc-0da7-43ea-f69d-08de41bb5c5d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 00:36:50.0682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvbdJ8iosWCnbONDnTyIPvFAalPbJk1voyDVdpj/pfJdLEnChOwpFWL9kKLJ7p0v4qN/rso7t64bY29IvFyg5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_04,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512230003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAwMyBTYWx0ZWRfX+BEpMPeIBjD+
 QjExMBMbeY3yPrH/lWARvoifKorJi4S4jtBnFqit7sYWoCXUrXLRdduKinMprWSBlPGpj904hhm
 95QqwxBhRs/B16A63f4oXT58uygpET3YtVnvZr+k5iM1S2w42jWYWjDB3BPNZJKH0X+v9LI6Y/o
 SVPQbasCpwpKN9iwQJV6oFgFGYRysNe8Pul1L80XiwS/AZft+4ug5XR735mSmiorZH9l9i1/Mq6
 29WuBLpPZI6xHKjp+a17f14hsYnkkFN83lUjJ2is1ERlGxYyRN3MHb9CUzuhtSndsRokUI8dn8F
 Mn1es1X1gjVU58ndUPtrdjziKIfCpe44WPesl/ASHDopc2wOtBsft/FtQ3RRm/pjbib6GCX1Sph
 mUxZAAO+yYJVR7yK+h7Jxbr+CzxCv2lvKHuXg77pPhlrFvN68bEXupmt4EJ7DrVZBuQ+IDyGn9v
 IxZoFFp/6Emok1cpnfOXilsjvCgpqh8CkX5L674k=
X-Authority-Analysis: v=2.4 cv=U92fzOru c=1 sm=1 tr=0 ts=6949e426 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=H3UEhRBmQiwo4kdA2VsA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12109
X-Proofpoint-GUID: Cx676rOQVtqXQIVLnkjRP9IR2HVxGk_Y
X-Proofpoint-ORIG-GUID: Cx676rOQVtqXQIVLnkjRP9IR2HVxGk_Y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 210D014000F
X-Stat-Signature: iomqdmsm5jn869xb7tu8hftt1enrf87k
X-HE-Tag: 1766450228-326700
X-HE-Meta: U2FsdGVkX18BkEYVSLb+y/ISeJtA8lFJVk8FykRfdFloEfOvlvvFLZONBShHE90RNkwcbufOMwvB2jzfC5l5gYvFRab9Xg8S6mEu0YELKNWiM0WqGriMyG+5oEqinSZx1+Tmt5zTg7mqsjGjTjRWy3HRXfgctV9ItNoCPq+MZM2CTRwD0/uIEDh/4YpUB6MuUqdTg1FB01TmbIoguh2N+2H7tWc8jCx1hGxNzF6TIvsyDmHnVJHpD47Xlee80LHuJpbyZM/doO4k+waA2jRhFmgn+XXFvNp80HimLkUkXGaFOX6qc01e4MFBF/x41ojZz/nDpMGlyNMuo0leYBgI372yBkO8ek+aENuW/pulCQ2vkjQ8yROJm+EAl4ysOH3WoJyRNknFk1i0gp29yZ/euydylRy3Xa0lnSeiyNQFBjuohZE9Xzj8oEC7pJkX1CU9Gh0V03IDkn12oxnqjWjdyQe4GEpl67JuqGkz20nP7utOlVvQtGBK4tMXYyvPQFAHyxMa1Hm7O/eTPXh/8Gm7Ssq83WflWH+jJtVcS7lghW3bgaRMRqy33LUAkqWBB4odLG35fScx6Bc5Jf7CJBEKG52nOlAxF2ENCu15TRLYMGZZOQNi9t1u0TWHsFm2jUHDEyRY0TPdZbsMWL/QIbW37fUMOEyn9JcyXlVSZ+rn1+GnA0WE5EcZfCpxdyTFnuKw1zUoBD4ANGcuuKUpoqiqnW0dRqiBkiqImsXFqMvvo3N9N77LXvlie4c2uIDYqK1J7vkqX7JPQ9D9ib8ZCKT8thMyZKBVUfG3Cir52qYTLJNTXpO2B95P227vB3Hg3L2PCQeWTFSNVHmOv7xQpfnYs3XwvJH+DCRxTSCDgj9sVIkS+sE7cYa6MhtEXtGIWf4R8KRDjnMsuaHqDqYZFU0F95ge8PnLunBklrcVujTNOHreTObPD7P1WsI5qy8Zq1A9+AnO6+AftjrE8az32iS
 C+HWQhq+
 iMai8KwM9hFDRN7mmuO9HSm30IFDMP8ItL1uV4uUOBuppVmTQi2KA98CnI5fVwY641cUQ1qLEmv5ubDGe8+rHjvfNajaCCUpdqkmLKNwKDDQ1O/LfpVEZiHi6kQcFmswD6BUFQvLrx8WpJvDcU9470/3+i9u2HMN3OoFD0kcagn7YEMKUiyrNmpmgbNvJBR8dqsV/5CA+Xuok0xdDfZ7/M8TYBIMjp7y52HbSPILllwhoNYMebA8J5wSOwFMr/r9GF5Yo6avOXCavbJAp8Hq69jnnWX9pj67IdNyJmONp08A55XW+HylAkEB5h/Z0eLRYKxUV8euuoeoeMKxmKKN+VoMS4BEnaMBA0q18NDQ36zG7la5ha8XMPfc0B7gzoFHQxs1qDhv9z3nXcoEXSxqKqlKTxYx5QP8oogRX8FJ3HEi9aXhuab1I739IGxi1jyFNdlbLwNq0+RuqOFYQbo1Iz1141mrIohW/OEetBCcD4Y8ljlw9wVG64OrwruwW4TW4y6Hi1cWmkP2dwM+DM17QNeWjo2buoKDi1BUYgs206nOcqsZSNI4n16MzPtboARMr64r2RFJXbJsakhqxyPYT4XUz2ZIoms/QoLZlXyUh5p76ZLu2pZ7j0LaGYHl3Cc9oyD4hlAijnllNUHo9KRYl90VS54lyQcRiA6IPdV5eIRJK6DI1rD4jFUzDM2dglWnbC0ejz3dSSiGXCFAZxRUzjBtEMNdLD0cv/KNJJV87I59JFrTVJpxkH5CLNU+APgeFMQ6xxip2PSJHLLEzCxK4RnHkGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew,

On 12/20/2025 3:13 PM, Andrew Morton wrote:
> On Thu, 18 Dec 2025 23:28:19 -0700 Jane Chu <jane.chu@oracle.com> wrote:
> 
>> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
>> passed head pfn to kill_accessing_process(), that is not right.
>> The precise pfn of the poisoned page should be used in order to
>> determine the precise vaddr as the SIGBUS payload.
>>
>> This issue has already been taken care of in the normal path, that is,
>> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
>> correctly in the hugetlb repoisoning case, it's essential to inform
>> VM the precise poisoned page, not the head page.
> 
> This conflicts with your "mm/memory-failure: fix missing ->mf_stats
> count in hugetlb poison".
> 
> Also conflicts a bit with "mm: fixup pfnmap memory failure handling to
> use pgoff" but that one isn't cc:stable, so this patch (which *is*
> cc:stable) takes priority.

I looked at
   https://lore.kernel.org/lkml/20251213044708.3610-2-ankita@nvidia.com/
looks like we're changing different function, perhaps the conflict is
peripheral?

thanks,
-jane

> 
> Help?
> 


