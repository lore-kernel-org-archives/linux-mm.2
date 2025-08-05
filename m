Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9F6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 22:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C998E0006; Tue,  5 Aug 2025 18:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCF58E0001; Tue,  5 Aug 2025 18:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FA48E0006; Tue,  5 Aug 2025 18:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D41738E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:18:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DFE8C025B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:18:41 +0000 (UTC)
X-FDA: 83744119242.28.905C918
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 028E11C0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:18:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W7xwc4N2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fauc0qRC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754432318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iyc6hm2m1Gv1c92vc2zlmFMiw1pfazijfObruQrTbGM=;
	b=uxKLxAK9h5hvA4vEB+2zAYvPZVFN/jE3hU2Ai1B+BR0grflIWdNtiWrffKSa1AEQK41JrX
	4mHjih8tQQkdpRK0jslz4ZdYSotl/NkfWMEat7WCyuoe4oV2OJjEB0tU0vZ5kDimGUsWed
	ALKas7kB3CbKb77z2IiJQIvh2i+VRSo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754432318; a=rsa-sha256;
	cv=pass;
	b=MwkenuQ6hOR/b9Rx49iTnhSPYd6BNhUZhrzZMm9B7MFqr7jATIvGOzFinM4QQEr7COlnh7
	1B0d0o2yBam42JxACrGRuRPPGLIFXoQVot287o2YlqufXrDGpqNQqtmiQXNrMuMnPG76ng
	oHURBR6+CfKra8gGXYvVREa1ERi5wCE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W7xwc4N2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fauc0qRC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575LNAQ8025677;
	Tue, 5 Aug 2025 22:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Iyc6hm2m1Gv1c92vc2zlmFMiw1pfazijfObruQrTbGM=; b=
	W7xwc4N2oGDX1zSZSIoWVcvi2DZ7uA1r+48N5lDsZgX72UA7LmqLen2VL1gwOaZ8
	sWnhrsO45EYFh5Pc3A8r4WYOwj9p+0SOTWH05jtIihPNDylajJ0xG1TWZXzK/V4P
	Twp8CXz5XpkufkxaTUp39eeZZKKy3SsAd3gTmPQIF/7yp5m+naVSCnJqHSw7rPXa
	fr2eDno6nZSDzK9Rzu8xsT2OXyk9wxHj1AzEk5ZsTDUu2DDUObZlaKyqDAD8xvha
	mYI/LGoCVwDMNS+kPuaIq4lXI3vQ3XynhYNkKqnzBKLEJ5roevGx89yor8uc5M1K
	elIpeaOdvxAbgEcBnzAAxA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd0dtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 22:18:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575KrmGe032218;
	Tue, 5 Aug 2025 22:18:28 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010036.outbound.protection.outlook.com [52.101.193.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpraax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 22:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QtfcTDYwuxGjXnwZCKwGd6T/M9LE+9PsQI4Q7YzoyXbGLccJkcrj0+vV6Ik10Yu/6emU1HuMS0ueeArtWDMWTUZTl9EqHM3HCv0361De3ky/b9+ZY7+K0EvID+VgbC8lhVtZpvb3EIV9G21FXIj5cx3MrNCUqaTH0/1v3S4N2tVGs78bUzvHS1BF3jqvWjrf3aZEgaccKaHQ/AMyfz79Nxsce5b/fw5zwtATKhQvMHYAL/hXhHBJcffuPB07ksrW+kyAEvQ10akYOhz+A/Hlx088AJsF9LdsuB1L8cuhwLdU2/DhCX/hSg1b6DKcuyLlg7m7DGvqSHZVVAJKPb+/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iyc6hm2m1Gv1c92vc2zlmFMiw1pfazijfObruQrTbGM=;
 b=MuiMx94Cx0kc7EXo/287cEPXmQkDWRbhz26m8j6SD8pbISO6XWGhod3fl8pGpoXaCkKDZam2Sl4rGxEv7ZxvBJVXD39TRXvK36lGUq9ox3DYvcp3uErf4X2Ijt8wIwKlt0F8CDDuiTDkYpdImlqqvKVrwLzJMhjyQDEoD+FeVaNuHRcbfqs99D2gNDXZf2mUHmVjevmv4So0YJy1Wa7PL4/bdu87wEEwvvC8PlI8Uf2BkGpdztALP5BHEQP0ie09Tpwb3FakZGfgNeN9tRcE5ev5AVrkKBZEhyU0tB/5hgSNimahOkRImfqNarLRi+M17bJ6blHXIgtdL/7/85lhTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iyc6hm2m1Gv1c92vc2zlmFMiw1pfazijfObruQrTbGM=;
 b=fauc0qRCEfpHNp0EZmUbQ6qAw2iZPEju+B9oLIkTMM2Zi7aH2UemwNeWeB20U6skPcSIjmXQeBmvFKCLN0lK3uzdge3Nb4PdjBspQt+JrZGfaEaMtaZwWypEL9hRN8XViLrNr80brhyQfDbBM+nmDBCfxd/2RlWPqmVQL1D0XIk=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ2PR10MB7785.namprd10.prod.outlook.com (2603:10b6:a03:56b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 22:18:25 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Tue, 5 Aug 2025
 22:18:25 +0000
Message-ID: <920efb15-581e-4efb-be74-088113bf2035@oracle.com>
Date: Tue, 5 Aug 2025 15:18:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ2PR10MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: 9975fd89-6720-4576-fabd-08ddd46dfedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3NiemJsU0h1bHRlUVN5MmJIcjYrdTlLV2pxNzdnc2ZoTnN4OGk0T0xid0Nn?=
 =?utf-8?B?RkxKaUtTOURva2Q4MGF0MGVpYkd4U3Z4K3lTam9rRHJyZ2o0OWh6dEcwTE5x?=
 =?utf-8?B?OXhsOWI3MCtMTXdIRjEyV21ac1V0d3RhWG9xN0sxMldYVVJBVEZFSG5UNURY?=
 =?utf-8?B?WDF6bHNBYjZiVFRnOTR2WVdEUjIxUXVMSTRxZDRkOW5uT0FKelJaN090eDhT?=
 =?utf-8?B?K3pkQnphMHNQYWN4aStRQTJUbnRKSGoreEhOT2dubzRaQndvRUpmRDJ3NEhI?=
 =?utf-8?B?ckt6RmxhaVhURnh4QmkrMWRoM1hxdllNd1lES0w4dXZ4cWdOWjRab2M5N3FD?=
 =?utf-8?B?V21yYlRJNWs2OUNxaTFsUmRXQnFnN2hyY1JSbzYvQTJnUi9BaG9oOWhGU2hM?=
 =?utf-8?B?L3RDdGpIRjBsWGp4T0gyQi9jL0N3azV0cWhZSkVyRXZsdG5mMTE1U1kybklr?=
 =?utf-8?B?eGdPNlRqUWRZYzZ4SDlpVmxCVmtvNmg4c3Y0UTFHbzduYXRuYXVuZktObnpq?=
 =?utf-8?B?Y0lvckFXWEsrQVBBSFZZby9oK25kMDhubm95ZG41MEdkUGZIOUtaNkhaOFdS?=
 =?utf-8?B?WHljQlRsUGJtSXlsU1FiNW52MHhYSUZZNDJrRWUvMkZqWmlkV3JrN2J5dkw4?=
 =?utf-8?B?OG1hNzFOQjkwZmVYZjZCdkxiaVdvbjlmdU40L2I0QUhLMmswYXgzWFdXRGxm?=
 =?utf-8?B?Q01RZXltN254Mmp1c2QvTDhMQmhmV1dacml6M25SQTB6NUIwMWU3ZDR1Njly?=
 =?utf-8?B?R2VHbnJ6a3N5aVRyY005YzMrYy9peWl5c1I4aWM0RnIrUVBmbXRPWEVvVXpr?=
 =?utf-8?B?bHVTak5aaHRhejZJUXMvOVRxdXl1ZzIxR2hhZVFqdkJKOE5PNlpqT2NjRndy?=
 =?utf-8?B?c2dzc1JnaHVVQmlTT29TOXI4YWJBNzhaS25xVHF6NmpVc3pVdm0vWTQ5ZENp?=
 =?utf-8?B?aGdVMU9rUGF4UXRXcGo2NmQ5TDZtTHVydFNkRkE1M3lBY0R0aUJHd0NHdXk3?=
 =?utf-8?B?SGxVSEFtbjUvbmhEQlM3bm9kS1Y4U0NNUlRFQlU1MVRjbDlwbFNHM2JMaUxq?=
 =?utf-8?B?eVRQVzR6aGxsN05KdDFIOGZERENtVVNVRkRrZWVFN1hkeUtWcGVoZEZUTGZ5?=
 =?utf-8?B?MjdXWXJ6Si9yaWVKTXA2K3dkSGluc2VUa3lpQnpWZUFlWFhYUXVJN0o5dWtW?=
 =?utf-8?B?ZWxBYllCdEdFTERVa3BaVHBNLy9pR3FpdS9HWVJzSTNmb3Ria3Bib2FCME5H?=
 =?utf-8?B?NE4rMW5QK0l5bUVoNm4remN3NUVjUWgrRmJudnltaC9SVkJsaElwb0lBd0h6?=
 =?utf-8?B?WWpHUERxUVJpUWxQSWFNbE41cXdMcG1hS09vTThqelBWbkdyaVMrRVZPT3pZ?=
 =?utf-8?B?amE4Y1Q1M3ZCaVdRTk1DN0E4NEttVHA5OXJxWHI5UDBDZ1FIOTNLMGpWTE90?=
 =?utf-8?B?UkFqK3JvKzdYTnBPRWxaSTllRmpZRXVOWG5TOE5uQ1VWRmp3OGg3ZjU4Y3k0?=
 =?utf-8?B?bVQwVFNKOU8rYnVSV0xVUVZkcE5Cc09oWmo5OHNaSzBtcHNkZXBkZmlUUWcy?=
 =?utf-8?B?UG85eTBCdzVzUDUvWEpwbGZkUEFpdkRkS1pjSU9pcTNUUFdyeGwybzZXdzlN?=
 =?utf-8?B?Sk1TZy8wTkF2ZDhPSXdmM1d6cU5qM2tIYzZYQzk3QUt1OTk5cUxncFV6N3pT?=
 =?utf-8?B?bU10TFhTaFpHWEVVckZ1MGk1WXRzQkZtdVhtamZzT0g1OG5vdTA4cXZ3QzMz?=
 =?utf-8?B?a2g1RElFemd5WFExUWw1VXkvaHZKMVZSaW9kVE5vWDczSEIwa1pOVGlRNFcy?=
 =?utf-8?B?Smp2TjNxZWlpSENJdjlvSTNZcWk4bDFzV0ZSMkllMVdnWTY2UCtaMmJNL0xK?=
 =?utf-8?B?VmFMcUZLTlN5SzA3SkRneTE2WUVVMDBQS0g0SWtTM2Y2OVAwVTZSY0F4Vzl3?=
 =?utf-8?Q?ugdOkABKrvQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWJIbzkwMzI2TVV1ZDg5S2dWRDlFa0I3c0hMY01WaDE4UFh4NXpmcmtPUWdR?=
 =?utf-8?B?K2Q4cFZRZHVTcmRuTXNOSlNWdEFyY3lTYlZLNUZqV283UmRiNzQ0cm5xdjNl?=
 =?utf-8?B?aklBUmtIQ2FXYTZpanRBM3Rra1lEanc5Yjh4b0N5blNtaDI4c3R5ZzZoRTl3?=
 =?utf-8?B?MDlXUEtNTHZmclplS0l0VS9ab1p2M0tmdGR4M2dGbzR1NHVMTVZxb2NSbWY2?=
 =?utf-8?B?UTI4V1hXbFo5S0piVHQ2VWV4a2UweUg0V2VkblhsalVFbnNybmxjRklEOVEv?=
 =?utf-8?B?TzdQRjcyYzM0N1Z4NlNERUNjU2RBR2VQMk9HVFRKWWNHR3dZanR4K1ZpQWVR?=
 =?utf-8?B?UTU5OGlRN01oN3NrVGFoaG5lQ0xIOXBGbWtkbmNJVTdLK0xZbUlHK2I4WWd4?=
 =?utf-8?B?SmFYNW1Rem53WlVpb3MrZ0RrSGNCY2ZEOUt4MXp2RVV4dFJXR21MMy94Sito?=
 =?utf-8?B?VXI5TGJYNGlQMzRodHFXcFo5UzRQZERibHJqWW96dWJNNkF3cFR1alRWUnZY?=
 =?utf-8?B?NVpWYlJveVRpSjFQZmF6Z0htNU9SMVY2L1kzS3A3N3hwWU1TVW82UENnclV2?=
 =?utf-8?B?M0QyRk9TWWt1QmplWlRzSDlNVG1mMWtPZjhJTlFPbzh5WGVzVEg0d3N6ZHNV?=
 =?utf-8?B?SWpCTVlOY2pYcUpiRkk2ZFJlSkVPVHBGNjFRYWVxNUxQYzk3VFFydmJ4Qldz?=
 =?utf-8?B?UjlBQlhwUWRLZHFEWjZ1M0lXRFpsenhmd0VNVEtiekRyczlEVU0waGF6WHFk?=
 =?utf-8?B?N0tVZVFOVTNCTzFQdHhEUWpOTm1BQVZOSWRIZFpVUG13U3NqRFBmRlBOUDFL?=
 =?utf-8?B?WXRIOVpRVHh2a2FMNytGczB4NzRnZTF2bDBLb2N3Wk94a1liWVFjV2NRTkdV?=
 =?utf-8?B?b2tIR09CdmNKNkZoUUJIMC93MDdFMktjenk5cTF4VXZHZTFmdEFaOEw2U05P?=
 =?utf-8?B?RTI3ZS9hZTJ1RVMrc0dJR1hBcVU4UHdIbWx0TmhmdHZHcUZZeU9KLzliSjhQ?=
 =?utf-8?B?cmIwd1p4eVR1QVRCYmZqRkdhVk8wdnZsYjZocUNQdDRSanRmeXNkZ2RFSzJB?=
 =?utf-8?B?SHNzMFh4a3pJYnlGVHZLeDg1QS9aNHNZUzFXZXUrWHJRcEVzdmNJaFVDeEx3?=
 =?utf-8?B?bnYweThqTFVoWE9BTkx1QWp4L0NqOW42bk1OVlN2bkhNU2hxVEZ3WHdjL05Y?=
 =?utf-8?B?eWJ5NGliOUNVb0JUREUra0RrM0pmVyt0T2lPNUdML0gyYStLOGdOVVoreDNv?=
 =?utf-8?B?ODc3cUVKWGJTVW9lbHpFM0gzQ2FScE1sQnBLVjFVK013NE0yNGFTcUk5dzJh?=
 =?utf-8?B?R29yNnpTQy9KMng3RXJhQ1dmdnQ2VGg1aG9OZWhJajY0V0ppakFkdkhwMExY?=
 =?utf-8?B?b3QrOVRlVzMwNm1Dd2RZaDgvUlVneTVkc2ZmYi9nRkEyU1NTQmhYWS9EMy9L?=
 =?utf-8?B?QTFmSE5XRGZ3MC9LWmhVeVE0OHpOS3M3Mlk3M3hiazhrOThSUzNua0xYQi9O?=
 =?utf-8?B?WHlHVCt5Z1NnY05Qb1RhMjJtVXY2RHFDZ0xvV1p0dDJZc3QxaUhQc1ZuRHd1?=
 =?utf-8?B?ampYeDRsS1ZKS2tIM3J5T042ajlUaE1SNlJNOW1KSTE1WHl6QkRWb3F4KzdX?=
 =?utf-8?B?dUF2aEYzM01FMDdKdUVKZE9BeTdWS2tUTHk0eVJpMm5NTFU3SUV0QWh0SWJt?=
 =?utf-8?B?OVFvWnovNzRxUWxlUXJ4TEcvVDcwenRUUUJ3VkFSa0hIK3V1VTY0SHZwUmhx?=
 =?utf-8?B?YkdreEhIVjIzYzF4NkhJZE1TN1BZYjVCa0p1cHV4M2RpRkxybC93alcrbXJP?=
 =?utf-8?B?NHdqQnQxelpPK1YwelhOc0xWSVRyTVc3d29pNXZOOVFvWHpVZmtENWUxMHZT?=
 =?utf-8?B?a2hUWGVobUpwY2NXQlU3Yzl5QlZVMmhZUm5sc2s3UkpoS3djMVNXaWlCdmlG?=
 =?utf-8?B?LzNrS1Y2M1dSQmtzMkw0YkxwSWp1cGkrK2k5Yk00dzRSYURYdFhhU3J6anQx?=
 =?utf-8?B?MFRGcyt6UnlPbjJDWktxOHowOGRxSFRmcjhpK1lGQlllV1BXUDlXek80aXNp?=
 =?utf-8?B?S0QyZVFuL2N2WVQvcTBNeDM4WlVwcFoyRy83ZXBRR0xrdTNRMFZyaG0rN2RH?=
 =?utf-8?Q?ioPvwO2bgjfT2K9MQNBB+ZW03?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	huo0PeRy6Z7GlMGBgmuLxOYTKpLblCP6pt64Khciovt8+Z1uV7+0/t7Cp2+giUCiR7xXmhwRr8sN2BWT9E/mTb3ZTxJxYUvJsylHLONRZzUwhA1L0MuWa4x+FNKyrMyVVpwZmnPhi6c9eEUQT9w3yQzvZZSUC3FBXIWZRox1Nfb6Oy60OT7M/oiXqJGyK8ZMUluf+MhyBb1AlBto2U60ezzjsevjwrzlfbrxG3Lr22FYfXd9+YdsGZt+wQ75dZD65iSCHWEgSumgwsOne053UP63QdWszy6wYq1KUE0cLDTkHKwozknB5IuAoxEDXsuu/34PnAnvU0W7Yx9P7H6p7WfFwWYmrl4E8TAo2JetmclxBvpPi01B5wBnJfx6IDMFroOeDDku7sde1Rd0DPorJ2aqv8V4RQmahe8q4nBKZhGJ6+RUOg3qwoob8HmQ/H4OPznQ/vwf1Zxjt6cKSnBZs+yTlVue+RyoTpwfnmMBS/NSHf8J0Ys07kuvJteWUASsri9YwPVQGtbGslUcJROGwqdASJvP72ZDd6cGcdMB85bKUquh3wVlPvU3yvBjQYkkuO+ccoZpogJkWMi7Gxr6oPbJ9l18I6/H4WzBqVu0GOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9975fd89-6720-4576-fabd-08ddd46dfedf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 22:18:25.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIlsMoDuyUnaa9GsuHCvCmD30dmUlN72iyEivOQpdQuxetdVIboqICcNWRq1cFoqMzDc7SUKTMr53xqIghGlVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_04,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508050158
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=68928334 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=5t0Z0lGnqSxm1R-A4mkA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13596
X-Proofpoint-ORIG-GUID: mBWAKDipTxcFMbZFYIeXy_5kisojhNWp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDE1OCBTYWx0ZWRfX4Cf7qL2dauK+
 MV1Fh9ZWm/sVm8fGl/QABq73QpE1aMOu2dfIW0NYhO9oVsHGn+B9ZmgaK2eaPqKIqIn+obwtTKO
 Al7+ZSDMWAGctlK3M1Iixp37/ReLTnF5MFieE/uWWl1saF+bvHvZEApsZg1nvEj0XGNkAR9+ds3
 QAgAj07n0+OjjBPkUyuIdLr5OgpntXFJj0wCQU4L1T/nVhVSvAPQmJIfVZ189TPaPDR7u/6jiBt
 qIiOAQ0xrjkEgZnAnPTseikvveugRbZM0ckq7vSH/JIBY76K0HHgFfEiZlegcjuQ4VxdJkPMxoh
 EHf5Dti7RuCd1j29BieEHC3Jm8xO4dpk7qKnz4dQv+ylI0GyChPEfsURwIpogelXBit7enA4RCH
 so87dNonb6kS2SuM+bQUP5D75aMAB9LHn80zJCL7BLyKwaBpegFRnN7vqOGIMMxK1hmZwxPS
X-Proofpoint-GUID: mBWAKDipTxcFMbZFYIeXy_5kisojhNWp
X-Rspamd-Queue-Id: 028E11C0005
X-Stat-Signature: idg3o83ceo5chsyb41rb4xfcuo1igyjp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754432317-636252
X-HE-Meta: U2FsdGVkX18XNbJIrI0auQWrSHVv0QiBOk7Mpv0ZPp4xTWMGrUZ/EGfrujyA5MgfBd0FOjsLTRpl+MMjG1OZ7hVkb0D67Zghwnl6pJ9JtNA9O8/CVbrDmKll0+YctajvxAu1hILaB5rFxbT7Q8mP/Dch2vxQKJAtVZ53fGuKaTKd705qiadm7QteAP6CfekIKtSFOmrubGY+N4wRtt2gvHUfUvt+PAdO7WVeODG3y+ziAzqLSpSqgeqUlNbDQI3paLhjT4eEEqPZXEYIKwKcliTP5gQTwNK5sxkFR32DOmD8d2/2EzN1ng5w+xq4pDtmi0+j0kl8GbxoN/oYGPkM3izs59miAHFRw+TTnNmAYPtxKeuJd77lgGJx4faCb0+zi9wgOOe/sXDTA8/QgWOdGyTO95szUZRPImhd35C9c9iB0J3AjuVYynli1AK3EqPw5297LTbuhs/tKd5LiNPoUgVjvbxoU9ErdudjttBpSQUCpbjkf+Tcz4qdFylL/3IgF1Vo3wzMT2dZAfvaCCCi/xyecctQ728pi65NTVTyTbHwhLpVvatOBS+mymKv9jXKy8VZ25CKIyqWZ0/Ac7qUDe8BDfJwmjJV6uWydxU/i4oy67Y5z2Blcz5q7ftBoTKuAAtfuvqFG1saEJctGg3pU45tYMAKYrB8eqWkOtiASgV55pvOriS8B5+SKum+tINEzI5pW9MSlnWIbVJfhZh7PYzYqWJVLtCyNjo8htTLRQIbrfAnn2/62yRZDEFSRDosgj11zsr7rIqjuypJeZsyoopyy3zx+lEo9IorsG3k0aPgM61ADXDRa+j4NEQB7tWymVIoQ6mixv0zytdFtAAQUPyCAQfazlyF2MuWDCI4jZytUvLlCa+X+qTssDe4kDS6drBbetAqTH+y1JlHknGsewieClbB2MwSGHjBpMqp5y85GbrFpW+BF40wakLTWk111UjmGmVfQoIAEkjP3lL
 sX9ZbZML
 3hLC/Py82mb5SFFPthqEIZpfLPYvTiHJOhHMQQf8UuqabRrL5z7Itr4rw02xQm937V38QALseAzAyJcGe3Tubwqv04BOw/RaD5nSYRTuvPbtLgfNZbnL27q/fMNY3IErXcOLAZehTjYwI8tggV7M4J7/aPrQIX7PLGiyll1qwNxtY6kNi3tjozfR/38/2r6/nJOttJXBZXdM5UsfZGTAKvmFBFWFjk8DgO0HSbdjcXWdm7ijtck6RAROKAkMMMmgGY7zj3rRanIy23gBs58qZwoJWTC5WIIlYkvUqRZ8NwryKzSOCdNkYKMCxEoL1jTZca/m+kNLCHU18O7ePxHOWZPL3zWCwit/NspKTsOMAobXpgsVz/p0jjovB2OOzXlJqxnbcBfR38hO4aor6ENO26vUfSjeBJVRyjHcuIgD9gurgLR/n74KusZ0wZlbqWnXdzyfwqbC4yeUcseKSh71YYTYQETjbjAUXtu8PYHVkMUpup4UB+j848xtTAgutGrh2mplBQINpnxz2yJjm9R63czHQTLZscdk2V0bNahv4nSOagHQNTe+8RWaVLbR4ZCPFBSWTgnM9W6jeodosIU6SofLGEgUT0SVs/8so3VjPCnYijQ8JEHoGde+rigkmBJUuK19scVieLyxWMpXvZloyK0Z7Y/FtNmo3/0QG5FgTJs0GXGOaKncAujZa9RguVB5RV9hdmIxCcc2vHKeNmTpFbUN98bmyxlmJsnCKFxY9Ocw11OOmDUgbRGUWK05W+VlkxBHw8g2FLrwescx4/IuUY3f6AMiQYJJFnmQLhwokrs5HSrgVw1IAiMVrA3OBt8O/vFMx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/2/2025 12:31 AM, Kefeng Wang wrote:
> Now alloc_fresh_hugetlb_folio() is only called by
> alloc_migrate_hugetlb_folio(), cleanup it by converting to
> alloc_fresh_hugetlb_hvo_folio(), also simplify the
> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
> too which help us to remove prep_new_hugetlb_folio() and
> __prep_new_hugetlb_folio().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/hugetlb.c | 48 +++++++++++++++---------------------------------
>   1 file changed, 15 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..5b4c19e7a5f7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1906,20 +1906,6 @@ static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>   	set_hugetlb_cgroup_rsvd(folio, NULL);
>   }
>   
> -static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
> -{
> -	init_new_hugetlb_folio(h, folio);
> -	hugetlb_vmemmap_optimize_folio(h, folio);
> -}
> -
> -static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
> -{
> -	__prep_new_hugetlb_folio(h, folio);
> -	spin_lock_irq(&hugetlb_lock);
> -	__prep_account_new_huge_page(h, nid);
> -	spin_unlock_irq(&hugetlb_lock);
> -}
> -
>   /*
>    * Find and lock address space (mapping) in write mode.
>    *
> @@ -2005,25 +1991,20 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   }
>   
>   /*
> - * Common helper to allocate a fresh hugetlb page. All specific allocators
> - * should use this function to get new hugetlb pages
> + * Common helper to allocate a fresh hugetlb folio. All specific allocators
> + * should use this function to get new hugetlb folio
>    *
> - * Note that returned page is 'frozen':  ref count of head page and all tail
> + * Note that returned folio is 'frozen':  ref count of head page and all tail
>    * pages is zero.
>    */
> -static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
> +static struct folio *alloc_fresh_hugetlb_hvo_folio(struct hstate *h,
>   		gfp_t gfp_mask, int nid, nodemask_t *nmask)
>   {
>   	struct folio *folio;
>   
> -	if (hstate_is_gigantic(h))
> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> -	else
> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> -	if (!folio)
> -		return NULL;
> -
> -	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
> +	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	if (folio)
> +		hugetlb_vmemmap_optimize_folio(h, folio);
>   	return folio;
>   }
>   
> @@ -2241,12 +2222,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   		goto out_unlock;
>   	spin_unlock_irq(&hugetlb_lock);
>   
> -	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>   	if (!folio)
>   		return NULL;
>   
> -	hugetlb_vmemmap_optimize_folio(h, folio);
> -
>   	spin_lock_irq(&hugetlb_lock);
>   	/*
>   	 * nr_huge_pages needs to be adjusted within the same lock cycle
> @@ -2286,10 +2265,14 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>   	if (hstate_is_gigantic(h))
>   		return NULL;
>   
> -	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
> +	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>   	if (!folio)
>   		return NULL;
>   
> +	spin_lock_irq(&hugetlb_lock);
> +	__prep_account_new_huge_page(h, folio_nid(folio));
> +	spin_unlock_irq(&hugetlb_lock);
> +
>   	/* fresh huge pages are frozen */
>   	folio_ref_unfreeze(folio, 1);
>   	/*
> @@ -2836,11 +2819,10 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>   		if (!new_folio) {
>   			spin_unlock_irq(&hugetlb_lock);
>   			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
> -			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
> -							      NULL, NULL);
> +			new_folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask,
> +								  nid, NULL);
>   			if (!new_folio)
>   				return -ENOMEM;
> -			__prep_new_hugetlb_folio(h, new_folio);
>   			goto retry;
>   		}
>   

Thanks for trying to clean up the clunky names and eliminate a couple 
not really needed helpers.

The decision to do HVO is baked in __hugetlb_vmemmap_optimize_folio(),
ultimately all hugetlb pages go thru __hugetlb_vmemmap_optimize_folio(), 
so let's not to add on 'hvo' in function name to indicate additional 
decision.

The difference between only_alloc_fresh_hugetlb_folio() and
alloc_fresh_hugetlb_folio() is that the latter invokes 
__hugetlb_vmemmap_optimize_folio(), while the former is used for huge
folio allocation in batch, and then __hugetlb_vmemmap_optimize_folio() 
is applied to a list of folios back to back.

Therefore, to hopefully make the names sound a bit more natural,
how about
   s/only_alloc_fresh_hugetlb_folio/alloc_hugetlb_folio_pre/
   s/alloc_fresh_hugetlb_folio/alloc_hugetlb_folio/
dropping "fresh", how is newly allocated folio not fresh?

Thanks!
-jane



