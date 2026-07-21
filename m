Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41569C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6508D6B007B; Tue, 21 Jul 2026 14:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600DD6B0095; Tue, 21 Jul 2026 14:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8D46B0096; Tue, 21 Jul 2026 14:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E03616B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:45:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F540C01DC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:45:51 +0000 (UTC)
X-FDA: 85013662902.09.C6B853D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B9F040011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:45:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iaLg40dw;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=osndobad;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebtAqKRr7trqDjDsohvbxPPPKpx+SNLMKgv48yY3Ic8=;
	b=3gg+K8mreo6mP8feOjp6sW4uOnAu6CYrupHws1MP6VCMJGzSgF3OEZJ0GXDaKZMFxmoqRV
	j0EO64VKfu0p8hJ+jrPYcOMoSTsMfrnf0yZfCClNlCVBzAezkb/zdzDdSz9l2/U4v6+0yV
	8QJG06r28+N2UaLUQo9KZb/FeEkrh4s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784659547;
	b=qgFXWHYBuo+ndj9gD6W981KrSSrbqLEXBI0bj6BIFXJpypq+pQVTkqVKhlN0Wa4+g8bm65
	n1A4+QDG+KmanneZG2swqIvwh5Nqm8HYcnxE9EYAu4kSZB3PP6UZQn8NAeW/egZu8IMqTF
	LiNEPS8hxeOXylDzUe9GUZmv3CRmByA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iaLg40dw;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=osndobad;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LEak1C314239;
	Tue, 21 Jul 2026 18:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ebtAqKRr7trqDjDsohvbxPPPKpx+SNLMKgv48yY3Ic8=; b=
	iaLg40dwt9uwodKKlXOxwS4NqFyJVnMJAHtco6UROAufw6CUmm2OeeU1UI+BKJoX
	gv0DOVrR0o671Pkq2P4+HMP6ssCbDFeufUseVuNOnM671Hkx4RLFpGj4UrD9dPpL
	HMxv6XvClG/Evs7OmJpMcOSpC2a5/161Yl3hjspFWbtYdqRRnkGhL7UopPtahgZx
	++lisDi8m2sh8wP5jUvnItYxl21XVJdYeRV/4B0zvqeluHGnHQA+YG5IRDSzoxpb
	Qr9X8xz7MlIZ//gaX7JjJB1wZ9b+N8Klx3ramSlVS7GTbaAS98AZGK0W9MVlhNcV
	7SQ9eLSf9NCk2OkwhBJFww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv40qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 18:45:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66LIiIQd037634;
	Tue, 21 Jul 2026 18:45:43 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011020.outbound.protection.outlook.com [52.101.57.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxq3een-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 21 Jul 2026 18:45:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AF7D1C4+FqTle/6VptDnrMLk4Bf7P2mI3bEE9pBUkvxiEGkgy2hTDiy5QpezSdIdJSGLB1nAc6NpDEaUoBP8sa9D59sAYu+9PQ3uQmtE92ONY4JQyXJ9Ca5aJ+R+H8FPL49ZfKEsswXRJ3Or65F3NNls0XW2SpB1pIGjc3+Z88F47owVdOCUJbvdAezLIuRgEAmb6lNckgF3qIUt/Qc6hyFWLkGoa+oIjfmVn7kM7dZRqSfa9jztBgC5pm6HkhaP9EdHscCJjWPpjK1dla2RCScRgS5txOjzfJCERg8x9gy5N30YBYc17uXHjbB+tTeu/VMBkav35szKvwpQsDUYHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3c0/xrN2motkEwUoqAB8LV4hnFk0rP5iHidMAliFZ5c=;
 b=bRc8qDW/nDknjQEI77GMogoIt5nkMeV/cvFCFTQp7gJud9goQALyeU32II571uWFYQ9f4e71KO7DjJEix7qp1o0+HDiO67JFkZTCufaBzbkfBN0XYxqdMphzQbGfpQXZW00Uojn3+8es4zoup+yaInT45neyHO53SmsPNVKiY7QEwU1S3lD2B/4eYL49jIByoz/PKKTDTfJ1hpWEw13MD5eP7sPwhqUbiBPYoppWwVLrxXq6sArbUqV0B1eKJBay1dp5wN86czomZIrOfXeiF8VBhaRaNX5KbVOdBkC8VkWlfGlv2H5Y8ckpqPThThhjHSfTJ/8cDM1K/EToMMpa6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3c0/xrN2motkEwUoqAB8LV4hnFk0rP5iHidMAliFZ5c=;
 b=osndobadHge/zzAIR4PcLTFPAi4Rt09uCCEg3pWqAuY/Js3jve+3ThkB6F8KdmHSucAEm2NmA05UXI/vBWUUIGBJ5Ykae/xD7TxR76MWjDHrLN+ylQdb1a77XKFTvQ2iIjN/pgv4Ki9iqTi6/21L8iZiMVZIPsFS9UFDjtvDAtk=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 PH7PR10MB6227.namprd10.prod.outlook.com (2603:10b6:510:1f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 18:45:39 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 18:45:39 +0000
Message-ID: <56b1fe97-791d-4303-8480-c91611772f3f@oracle.com>
Date: Tue, 21 Jul 2026 11:45:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] hugetlb: evaluate subpool free state while locked
To: Yichong Chen <chenyichong@uniontech.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260721035207.1437935-1-chenyichong@uniontech.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260721035207.1437935-1-chenyichong@uniontech.com>
X-ClientProxiedBy: DS7P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::32)
 To DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|PH7PR10MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f3a90e-f077-4e5b-3d88-08dee7584246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|4133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cI6RK3APCKhiFVmTii2+oNUIn+GLFWxR6BKqGW5jK8AxpATAgZpnACoCpNgB+GGDNCGiIwx2oMXHIZLyEaG7uhH1MxShwjgzttwxH38TfWTMEQltw8i0ZgYwEomiDtEqLty5udWxPdvXZAUlldCNtXrfbmP+I1AMlXfgjLwP4WSlUlbHPOXTetSGDLaTElKZWsI8fQUvtlGghTob/O98jm+ghem8aCkZJZkS9P7Lr1zbIXjq0nhC9rB9oADIQzhVhn0Y63BFoTPCRXfF4FYFMZXUXQRkkpD5ro1ojwLwZDrn4EqP+GMZ5sMbm8IwABN6QUP4hH5K9LqkJGAdOMJxevXHpNE4h6yDxp1lC9EOmxiBnFPfaO0XehOjaA3Q4yWGyoos1qY+dgfEo17hSOKiafmpiY7MlcJH87gHFpjDv8xa4SXSUghqUztjQGPAAMg3cNYUQ7/Vvr8oINHxY/4wptxib57OxqU5TSb/Yh/rYyyr0+GPiIIx9hsdJ80pd4dshbowZ+SEO+S1yi+FmHIQE/AozG4IDVelQr1hYWVjkO/ISCnmVTOsOcQsZP7kwYxeS3zrZXuZFYlRxFgy8G8hCWfaSxBCHp3z7fzRmtv+uWo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(4133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXJsZldpZmw4S0hRQUR1S09XaTdaaU56eG1EMHEydnJMM3gxdnFFUWo5d0lz?=
 =?utf-8?B?RHE5SUtrUmxrcVBzTFNMSDBKcWMybWJuaU1zbzBaQkpoUWdtRlVDT21mZXcz?=
 =?utf-8?B?cmVENUFjVUVpTzNyQVFyK2dxcUFWaDdVRDVmLzlMRSt3c1JNL2R3YVU1Y2tZ?=
 =?utf-8?B?anlvUFpLTmZkdVZkU1VqL0VkYXpaZ3A3V3BiYjdaQ1dPK0FSNHV4U1BrN1JC?=
 =?utf-8?B?Z2w0ZlY0cEY1djJOSTl6ZE5oOXptODQwR0NGeDY1Wkp0Kzg2bzgraGdibGh4?=
 =?utf-8?B?TCtHc0lUTEdURHd2MDdYMGttTmNEZzc1NzFFQUFFL1hoR3R6azhwbFdPdytN?=
 =?utf-8?B?RUtLS3ZucXAyMEJtQkdBQlBMUnE0K3k1dkhkS0ZWMUJzbkd2OVhGb3Jtd2U0?=
 =?utf-8?B?azBmUkIwZ0pqcGE1dU5QTGo4THRPTnJSZHppTE5jZTRYRXRpMjc5bE9mVTF6?=
 =?utf-8?B?eDR0SHhCd1Y0WjVkaFZ1V0RUcVE2OE9pSlpjZTRWN3JFd1lhcHNNUlJwTGVF?=
 =?utf-8?B?L1V1ajgvZytNZFFqUEpBU05YUE9XaXVISld1dmFoM211Yk81dGdzVy84MnVn?=
 =?utf-8?B?WHUxVTRzQ2RiNU5vMEJXbXp3WHBGRjFWd3A3WUJRVm9NS1psOS9ldkZEZEh3?=
 =?utf-8?B?RWVVOVRyU0tucmpML1VPelNSZytjeTZOR25QS0JZQU5xTGdlSzNWOUpvYlNF?=
 =?utf-8?B?a05nVGZrbWJ3aTRmRWpoSlM3bmg5WUpUZ3FtTys5ZzF1bjhqNmt6NEdhRFpz?=
 =?utf-8?B?TDh5WjNETTByblBPTisrNnFKOHh4NXdvQkVrN0VnblJBTnhPeXYrOFQwSUcz?=
 =?utf-8?B?TTduVnpQN09kdHpwNGtBUXNDSTNHQktZUndKNWVWT3hsU0dZU1NlWER5dHhw?=
 =?utf-8?B?eS9qSDE0NUpxa1dPVjFCeTFac1V3ZUtUeW11cmRkRDBCU0lLLzYrSVpFQWhY?=
 =?utf-8?B?UDV3dlNRNG5MazR0c2tORTJsWjZQK25QL0Q3Z0lYNmVlUEMyckdteUNsSjJC?=
 =?utf-8?B?Zy9Xc2QrZC9aYlI2OEI0QnNPOFF4dlZpWXA4UFVodDBqSFVTaHJsZXRaNXRp?=
 =?utf-8?B?QkhQbnpsdzlJbFRuK2VRZzdOVmJkTzkwYmM1YU1YckIxOWJiOVJiU3NPd0gz?=
 =?utf-8?B?a1M2OThDQzI4dGdFOUlEOUJtM3Y1ejljN0pLeTllRnZBRmZPQStWUVFSd2lq?=
 =?utf-8?B?ZFhMV0hFMUs1aGl4ajJhVWdMK0F6KzN0RjFxUTRrS3g3cnU3R1Z1dTJ2SHNY?=
 =?utf-8?B?K0tnaW9CbFVkc1FPaC8rcWJUV1RpZkhwNm9LK3pwcXh4K1JsQ3I1K05HM0l0?=
 =?utf-8?B?dmpscE1SK3orRFVjTkZjU05pQVFSeUw2R1kzL3VGYkxkU1BCMHNDVHpYNHJK?=
 =?utf-8?B?MnpseklDb1ZGMjFjRHdsa3l2ZStadjZGSWlncVZPbkJiU01uSWM4cGZLTW56?=
 =?utf-8?B?VTJaK1oxL0V0clVrM0xTcE9uTitIVWhJMnRmRllsbkEzajFXUU44RUx5cTZr?=
 =?utf-8?B?Tm5RMXd0WTl5YzVwcDB1MERubUg0R3h6bjhjdCtlb1g2eUJpYjUyRXltdk92?=
 =?utf-8?B?Y2lrVm5GSFFjWFVDNkFsa1dKZDE0VVg4emFpN0RtRUVIU3FEWkV6Skx0cDMw?=
 =?utf-8?B?TnhTUTJaSXppTEwzYUZwYWlSMDdlMXlHMG50S0JkaHFkaFo0aEdnVzJxakI2?=
 =?utf-8?B?Z1J4bGQ2ZHpJZDZaRUJZVXdLMHB3a0FuVkUvVU0vUTdJaUxCN1VxbUs4V0JU?=
 =?utf-8?B?MENSaVVZWklDbHNxVXdwYlg4Ym5LOC82aENvcFE0K0phMkxERGRmd0NxT3RH?=
 =?utf-8?B?WXVuTnBBM20yUWpBekNhUjdwK0NNeUVKTG9kWm5OMFVFVmNaemdTRjJ6VnQ2?=
 =?utf-8?B?SHFVMU8yb2g2dXhNS09VQytJKzJIK0xTblpTdzhQdlIyVXZYbUFHUGFGd2dP?=
 =?utf-8?B?WGhLdjVUbzI5WjVCaEhKKzFCSGc3aWcxS3FTRmxBdUFFMDFBcm1UdWh5bjY2?=
 =?utf-8?B?MW1qUjZSK0t5ZnZZWUhzdGpabXQ3VHBLaTA1bUtuSWRJem8xaFM4bGcxQktv?=
 =?utf-8?B?VXd2eTRkS1g5QzEySE9CNTJ3dTdkeDc1RUNVaEFQZElKRXlTZnlBVmNUaVIw?=
 =?utf-8?B?UGo1NzQwVkpmY29IaHRaU3E5RmFjcmV5d2kveUpCUDFBTmVWUUJrcFp1d2R2?=
 =?utf-8?B?YThUSmZJUFVsUVdFamswQlhhMmdZRHN3bWRScGh3ZEF5alJIdmF3OUw1dXYv?=
 =?utf-8?B?QkxIU0Q5ZnJIN3I5RlZhR0tDTDhXK3haM0ZvVVgxeldYYjVmOFVZK25QQ3pC?=
 =?utf-8?B?THdlT1pPcjVjSHpEWXRPQ1lSSGVJdlhrN1kzL2oya1A1QmVtVzBMUT09?=
X-Exchange-RoutingPolicyChecked:
	Lj5SgVyVquVHkUVORofKnK7VGd3MwrQdtDVaQej2+SFurpM25VjFjxWLJQI8pEIBdhqxYU8r+HA9YAxOTZdKwmc1MhiO3LBIOWn1OerH/TW/kPfo8TGYUEBg+FVKNR6y8Gaq6KNVSc909CkeAhdqqznF9de4gSqjv8VGl6T1uaLzPTfio6VXK//eUSxtcoKxb92cpBw4zq1ivmTp57drqVWeLWoyFy8MCbEgClb3N2dxPS3ZvuY8bRWeTLHQ63o/a/RShQCgpl6cmu0+TABaru+2BZ+XRTIbArYAWa5ocZTWGFiKLSW+6vYsgpU7Q8rDbEPfObePm5k4b5jwaUpC4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qIRAH976HMLq0UJxrKu+8Za+kQWFXS+VbDSsqCFJV7rOiVAs+dKRasjHxNshByeux0c3oTjO7xbo0zoswA4C3Yb3Z0WKn18Rwx7WKxsK8xd9QJaSxRCswB+o9XbJxyVYudQdEVNUfLxHBcyTc3C50we618IjUxWoCLtLES4eRpXM24lzSZI1VA8lcT2egW/H6jLyja2t6ygQOyufQ0CWNTNx1GFK3qWS2cv8a9BNllof0UDxBR7dm/pRTcEiokjUOpTO/AZIWdWT6+4T7fAGNGyaHUoEH0Wa9Gw4kw1fhokIVvHY/NmB5UzivnKRNozDb9vEuxqniCSo8ouH2+QlNUjYU0q3YfNwVdViFXtVzvpKGvL+8D9eIFim3zMD5UnOQncvk31PAP9Vab+olPMKlLdddx6loe60OtrrYxKXr2eXkPnq5CdSYUlw5qokb2Fyz1t+q1PJfqRmcBd//LLV0tuYCA8dhZpN/bPRtIWkKY+tRKMVYTcWm1dl4WKoJCSEvyuUs/Ue7S6P4QJ6b7aUIWFPdmS8/Q9rPv1NyENR3eg4O70Xnlh3VxR7r1Hg0M0DCUA61vSfMRlF5fdaPanJdijg1CdtcRak9tLWouio32c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f3a90e-f077-4e5b-3d88-08dee7584246
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 18:45:38.9836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PJJEscPkeZSIu/6OnJC7PUZ+u5WwrYe7LVTme6spjuouHiIHNvrL3ORl/TXCphpIo0NYqlII0YllR9Sir+ttg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607210197
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: wax89AKBSdJwoDxpdwUw9CArDS2kOzKO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE5NyBTYWx0ZWRfX9XkPoj+iEWxd
 hIjI1hg3VfQDxur0sguetfIg2U+WSqvMeCXecgC75GHOSmzzBkjCv4DNf63S56CVMZw2F+wEXuH
 ns4X2YRvagQrw7v6ZoLnvzrsPKxpC7to9wKUE7ePxO8KiFoqW9HR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE5NyBTYWx0ZWRfXzmQ9N8Fw9BGv
 AEKWUK5ZQd9ZMjUl/F7ZjR1BFd5eY9MjgwSsrYelxhcTU/uiugDttcaO1Of9qDVoLuC8ecJqC45
 bMGkuI+SP+IwIdf5AXGwYhZjZabkmob9cDPaGEYcl8ZQIioxCrmf4CHyTSeHkXSbM+JLBZn6akE
 J8X/JwMLXx/ePCCcVNWKVinJAqYGzvsEvXfFU9XRCwrvSs/4RvZ19+pnWWX0MrCvf+sLWLdBoIb
 PwcPThvP0aNga6xdosQxKuqULeIBj9SSE0bGfr22T3mPfDjtEPmNow6h3ocJX+VZ+inApir/K9Z
 Gc9JWY43VSPk3gL/jfR3zS/hQu3ybEXdYG9LsE0S3w5UUQrsxgrDAHlgbKeRY7nbZ9d8sUgveLt
 34stAqmsMIM5ZQFlH+vLFkQtA/zFY3gGjLbyc2xZ6PqqYhgczyg7O7eclWwHKg1ZSBRw7XUHecY
 4KTa95lC83a3EFwfRdzVP580wbs9kFlFa1G9Ei/I=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a5fbe57 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=RpNjiQI2AAAA:8
 a=c92rfblmAAAA:8 a=iHwBjlyiAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=s58ztl8Jgqz07n3gbNcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=uNSKXYNwxGiU6LD0JREI:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: wax89AKBSdJwoDxpdwUw9CArDS2kOzKO
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B9F040011
X-Stat-Signature: 7gzzhijexgmrc1k96amau7tjhua8oe5e
X-Rspam-User: 
X-HE-Tag: 1784659547-591089
X-HE-Meta: U2FsdGVkX1+PJAwp/cZEEHefE76eBqD7FshSHcQngc9uKWmvXkCJz+CaUYqoS71+eosAoEMLVUY50cOgDdz8rOfqI6NjfWkCgh7xot9HJqkRh10CuNJAdL96BaFgVyBFTS7aQfytjgFr7TumXfwW8mGe7uNTjbbAMoJL/lW0IuDWCv0noz9JoIKWrmLHp4SgVxHFmMDvLWCN2gE6JGp8Vk3gtrbpvqTLw4jmdhr45sPd58PVKYpyvhzLdxTCG33DdJY2qmqqc0wkD7HPyw32JpGHiM4md+aL2jYa0b2g50P5NsLoyriSdGzNwOOfE2X0caCN18V4RMEsF9KRHikBhiditMXl23pKoBNkzl9TjlBYN4EIHZ2ioK5S8fMxzhXyKfujQ1bNFzIl5U7GEDCiT78Zc8OB7N/8zyHCgj/QvFftwS5WKnn7R4PFroSLhuJ0qDe/U7VEIPGZC0gfM3QY21+SHzFoaqDliEek2gFjcEyyDQxoHVv9U90iOOposfrkoHCJ4tGVa6QJGWBeHwfqDhbNKOJrqPyEzRN8ZhVBMIbRkpCDSTjG2NMf8OJy95DDIE1uC3xF0E8V5Mgwh3ofpwzXwksiXxWBrDnenPTgSoh8xkq+G6kmk5HLZ/yu4/tvGYKVFYZ5/D3vZa8PWZBCCJf3B5Dr0r/I5tX6c4GB/+w10F8NXaFX0kIy5q/skhzXNFNRonK0+RSyLsSTH70AIh+xeAFslS6tERKU1rDRlZTtkbifib9ufQmEeOnnH6o8uN2zHDkAlgZPYGBeMArt9RaGK8ZqIOj9zx7HhYnYWG+nBcaeO66rl5aHypx35ieM2bANtjc5tEvMLPz3Krhfasn4oL5UZ0cgfPOotB6XPCYmgKlNqA4nauFunUTf2e2sHSlHOksruUbH/ag7GvM7QB4/p4mc8WBgSuolEYscBTZe8Nkt80iM6dpMnKGXVvr2TEPQ0XYcP9Wpvzb6kSP
 tk+GFOWC
 mwGc9saMeYjJn8suDDto82IEs3b4De15eUpVw0IytoTVLieQQJHeh55ghVaNuKZafO6Sy4NA2kh0Ejswur2du9tKDOQ7FrlW12T0rs5pmDhCWPlrU4Doh+MLTBzRX4AIhpJnx+Azz88w+LUMGqk3kGOw0X+5Z89y+7VFXaSzU+2V21Ng5IrvDGVAnsz9nl4inYz1F73CnoyTi6AhgnAy0ukhL2dtMchxhsbrRIm17JVij3r/48Ju6hRI+7xqsaSOYZiScq+PlyciQGg1a1gwjlAC1LyNkrJ69sZo1i+LPZLoWvHjlmk+FnbAkjbjmaA1rE5+H6Xq1ewNryFuUUiXEnCQrhLrw6enXXX8hJl3wpMRwfhQDYxrkdcadB4bO5CpcphI5HVI+S6TetQRAGeAM6LfiXdpMdld6VIJE5zbcQJllWHqy7GCY9ayJs25aaaBebqYr3LUvwEfwG9bpVeBiSPLb62tEPcXP5U0ibzf1O/BZj8NxB8jmQm5djoO2ZmM6WmsX9RThFKuyMMfSNSF0smZMj6Hl62kp+xyEG1c3QYQsjcyuilkR8DHeTO8iVfeqOHOqIkdYvFKX5CinfBG07+1aOq3uHZJBuRzp4mD34rHWlawryWHhHoCI/Pwy+NYvURF1YNSuXAdz2t4cpj0sRHzHsovq1vHgLnHqvHyk5C45SDFrlmaSJFqy68f+JDMyuOq9N4eUKcF+6a8smGaSyS24EWBxZJWp1b0peBkJ2zSSNJWjRa1p/GPJmS31X/172VmfT1jmqkys2spBSicF47px2lY35sQjzV+NzUM0KUaIComzvuewp/zW6xp/5Ro0Vj4ln60+6YScSo8tCqFuypJ0QRVEAN6yi/NeMW3HtNO6xM6HehwrPLWf8K79yHK8iMxkJjc5UtnfQuUM6Mu4RC90F3JMd75EXwP5C3aM04Ru1yLkmzr2+oW+8zKcOi9lUcVnmfc+4a2M42d9Rhb2akWBJKzp
 KXC5wmwj
 xpXMBs+mjUi+FnTpH+XZGQ5SUUXoPtw2JLGvowWJXmwDZ9ywCn6mbT9Wao86VqjJf/JgQO6EtLzEsaxryXI9cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/20/2026 8:52 PM, Yichong Chen wrote:
> unlock_or_release_subpool() drops spool->lock before calling=20
> subpool_is_free(). However, subpool_is_free() reads fields that are=20
> updated under spool->lock, including count, used_hpages and rsv_hpages.=20
> Keep the free-state evaluation under
>=20
>=20
> unlock_or_release_subpool() drops spool->lock before calling
> subpool_is_free().  However, subpool_is_free() reads fields that are
> updated under spool->lock, including count, used_hpages and rsv_hpages.
>=20
> Keep the free-state evaluation under the same lock that protects those
> fields.  The reservation accounting and kfree() calls still happen after
> dropping spool->lock.
>=20
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v2:
> - Reword the changelog based on Joshua's observation.
> - Drop the Fixes tag because this is not known to cause a user-visible bu=
g.
> - Add Joshua's Reviewed-by.
>=20
>   mm/hugetlb.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e319c6a00555..46ab702c0fc0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -140,12 +140,14 @@ static inline bool subpool_is_free(struct hugepage_=
subpool *spool)
>   static inline void unlock_or_release_subpool(struct hugepage_subpool *s=
pool,
>   						unsigned long irq_flags)
>   {
> -	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +	bool free_subpool =3D subpool_is_free(spool);
>  =20
>   	/* If no pages are used, and no other handles to the subpool
>   	 * remain, give up any reservations based on minimum size and
>   	 * free the subpool */
> -	if (subpool_is_free(spool)) {
> +	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +
> +	if (free_subpool) {
>   		if (spool->min_hpages !=3D -1)
>   			hugetlb_acct_memory(spool->hstate,
>   						-spool->min_hpages);
> --=20
> 2.51.0
>=20

Looks good to me.

I also looked at Sashiko's review

 =20
https://sashiko.dev/#/patchset/20260721035207.1437935-1-chenyichong%40union=
tech.com

where it raised a pre-existing issue which, if I'm not mistaken, is not=20
an issue?  Because, if spool->max_hpages is not established,=20
spool->used_hpages doesn't apply, that is, the subpool tracking is not=20
needed for limiting hpage allocation.  To add on that, if=20
spool->min_hpages is also not established, subpool is practically not=20
needed, and purely for the syntactical reason, when spool->count=20
refcount drops to 0, it's okay to free the subpool.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane



