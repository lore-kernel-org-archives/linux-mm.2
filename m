Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F89EA7951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 02:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF11B6B0089; Wed,  4 Feb 2026 21:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EE86B0092; Wed,  4 Feb 2026 21:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F006B0093; Wed,  4 Feb 2026 21:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4E16B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:01:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DA5813A91E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:01:14 +0000 (UTC)
X-FDA: 84408750468.23.04209D5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 69EE64000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:01:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xx2YFEEe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcamwLTl;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770256870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jt/sYH9Tu2hNMF2oBfPjMWy2W9yhM/0pb+OeKJjW6ws=;
	b=o5/4G9Uk36+VM0BH0z1WVvmv2ixGt1DA0Bht1o/mJr0XpUKZr5eeDrMbjYjq8rJ1iweUo/
	LGLIIFd3rbwzpHSBpM3PDDLWJTNIktZx8jpT+VpT+pqC6TihVhXsjkKNW5KIaQTstXD/la
	x217SxQ39P8Ca2tjerCQZHkbmJpF+SQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xx2YFEEe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcamwLTl;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770256870; a=rsa-sha256;
	cv=pass;
	b=QNKYKgEwQgGJaNhNSvse4Itdx7fCJ7DiW1vMraNBJFYWQ567zj6laVMbTCj1fmqwlqQr7w
	7PKJ0ZY+BEsL97CnSSiDaHlBvL1pqiKtZLNXU+J4g/VNfLTzjYyOAD0UpRgEWTydXM8iCN
	I6MNnuXVePn7D8vCda3YkORxTnDWdmo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Mu03G1716219;
	Thu, 5 Feb 2026 02:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jt/sYH9Tu2hNMF2oBfPjMWy2W9yhM/0pb+OeKJjW6ws=; b=
	Xx2YFEEeg1yRmMxZnIpdMBPMucvAluUtYoW0ojDJLFyw6aahVhPmw46xlItur4Za
	Fouu8QGvCe3iiIA48YreOLs4U6ftSezykMLy86vaFmVPRnxb2BG6sgu5BlYSynqe
	CVfHtJn3k+HDyvGH7OpVr31nB3UuzIe+jTcd8TBZzpjZdNOh2XuL1MM2DIWc+6I4
	eo2O2WN0HWqRjigwt1qtz98RUO/jzkS2uZMm0LS9qy4NQTIpVCmO42XagypcD3OH
	tfHoM6GIS9Af8nyKpGS+xUFOTQVlkHVL0QS4UMtBTpjZ7U9MvFBWWOvwWJ4Ez51O
	8iakpmhsB/yiqwLBZ0AmIg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb304d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 02:00:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61512N4D002120;
	Thu, 5 Feb 2026 02:00:46 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186pud6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 02:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LTcLasMrL2HKBKX3dtoV5cw4w40JY6VxLa0d24fm6P5UT2LQgn+sMbFfNjo6udPA80vtFWc52eJ3ckCkfWiAyqIwhkrBuo7lSWsx3T7ElwMBcOHVe9ZvO6ruZatzE1EI9ThYZQir7fN1MzsXSkxPNnquysAvKkzoRlMifERt4Gs6QYHiTXT1KW+6UyGv+QPnsIEVf/HbeKBOhDN3cEWHDs5hpBFbQpmXeDAz/BBbn0GITsLemIgiCsTBYVaynqqRvTDg0kN8VlBClWTqFMm6Q126rfuTzfuWY4vRPKMAXn/8sMqRf+zKIMQPWIAcbAcw8DnCuA/YMSXr4/Cva2JmPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jt/sYH9Tu2hNMF2oBfPjMWy2W9yhM/0pb+OeKJjW6ws=;
 b=mVQ+2FateIgcz1OlnjMf/7kBC8Y5Lyar/LXCrxAcmgUv4ClWARt743XAwAUz+VY637yUl1q3QB4m5AtMSZA46hG4BYqNk118yk+HE2nN8Enf+rquq9Rn7KzZYJFnY0YoDPa1O6heZDtiVTL9QR87NXHfmoRx0rfjD1WaZagsZIigIHFokB2kNA2hCaxB8kkkmhJo0fVllnhfE8FwI4UV1BfvdJdTdoc6PmOFr7UwlAIRU+n/5L3kv0nnPIcW2GGNACz+jKc3IAkfSNdfswOLRZSu3f8RCxAijEHPBCc3ISc9aqVXw08mrsb2l52bwhDPrJ+QyrqOCwEl+V0mzXFPjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jt/sYH9Tu2hNMF2oBfPjMWy2W9yhM/0pb+OeKJjW6ws=;
 b=NcamwLTlz7PknGT7tC83w5ZvGgN3mr3ZS+COZ34v5d11xo2tpWyl8rguHL3+P7wdLOG4nqZdcdh7uOpaxwDU1tIekWS2LY5S5jk04/XNOZga6XDwbIEGGmrWrtDli7FPn3Skb0s9E3Q9JrXaL0gPAiedUuBWxaLKr/nJSsQunfA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DS0PR10MB6751.namprd10.prod.outlook.com (2603:10b6:8:136::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.14; Thu, 5 Feb 2026 02:00:43 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 02:00:42 +0000
Message-ID: <7d5754dd-8cf5-41f3-a767-271b28b1f63c@oracle.com>
Date: Wed, 4 Feb 2026 18:00:39 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (arm)" <david@kernel.org>,
        =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
Cc: linux-mm@kvack.org, linmiaohe@huawei.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
 <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
 <94DAA11B-597F-4F8F-AFFF-9D7626A7C091@nvidia.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <94DAA11B-597F-4F8F-AFFF-9D7626A7C091@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::7) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DS0PR10MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d55960c-c63b-4ad7-517f-08de645a5e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHUwWmFNcVNJR3pLVzJvaURVNCtUZHArNzg0RXFScUJxbVBHSkRyVGJ4VlJ6?=
 =?utf-8?B?MDdvR2NrLzJCTlIwVVNzZVcwSEFCdDZsQnlheU9saTdSZE5RaElGazJGdTN3?=
 =?utf-8?B?eHRLbXBoK04vaDcraEtSc09Zb2dDMFpaeUdXQU9SeGlRWXJ0dDlFYVBvaENY?=
 =?utf-8?B?U1NjU203TytnaktMMmdScHhuQlFRYWIrd0NPc2UwOFhSTGNPVDF0WVFwMkQz?=
 =?utf-8?B?eTJhSWV4WVE5Qk5hbkVKS253a0ZBbWJyV3dlWnhkc3JsM1dBRGcxd0JWbTJa?=
 =?utf-8?B?UWZDVUQ5c0tibTEwcy9PM3hocTNQK2VXTVJIRUswNEx4eDc5eHNiSXB6alA2?=
 =?utf-8?B?U2RYRzQwWmRld3c0RFR3dzBsOGh1K1ZSaVcvbTl6NVZmSHg0SXZ2ejUwTnpZ?=
 =?utf-8?B?aWFMem1DMHFreXRsU25IRVViYUtRTFFIZXhYN3hlVlZ0aUxTK3BuMkJSQk9x?=
 =?utf-8?B?aEVvc1ZBeldRdDQ3MmdVOGJ0cTNSN2pTaVRyK2drVzZ5WVEwQmVKNEdpWXJj?=
 =?utf-8?B?SDg4cDVsTFczZHVVUFduYWsyZ3NPY2NvdjNYb201YzRBa1pta0EzdDVQMjFi?=
 =?utf-8?B?cDg4RXFhL013VGpwaXR0ZVFyalNkY25qZkdDWGFqWnlIdnJYMEhLWDNDdmVM?=
 =?utf-8?B?Z2dTdFBHVHo1NE51QkZwSjlDeElDOEZnQWhlSFBMelYrVFMwQkM2RnNsRWdM?=
 =?utf-8?B?QTRBK05QcU9qSU8ySFo4S3V4a2svUERodVJraWEzaWJJNXlsQnloMy8yN25J?=
 =?utf-8?B?Ynk0SUl1WTJ5NGJ2cGRvYkZNYlNWYU1JdEZlMHBuTk1zTVYyNnZ4NVZmNm4v?=
 =?utf-8?B?L09RbmxHS0c5M0RnMnFjUXB4aExOTWV4cXJyVGpPbHlvRk1mVUdlMmRvTDRE?=
 =?utf-8?B?TGk4SWVqQUQzTW03eTFaOTRYS1pjdmsxc3lWRVN4UEVjZ0loOW4vMktvZE5O?=
 =?utf-8?B?VWRXR2l6TlhzdkMrT2dDdlQ4WlNJRVZNTURtZ0FXdzgrMUxDNDFhQ0dZeDUx?=
 =?utf-8?B?aWQvN2J1SWFScFJKVmZLY0pBMEtsU0JHMXVGUElJWUVUMGtHOCt5UWE2MWxs?=
 =?utf-8?B?WFhxY3Z4SjdaSE1ITXVVZVBhWXE3dmt5MW1NYmR3VWdxeWUxMVJpK1FpamE2?=
 =?utf-8?B?MkExU2QzcDBVaFg2TVAwbDIrYUQ4bkQ3ek5ueWNaNzBIRDNJaW01N0dBTTl3?=
 =?utf-8?B?dGpBQnVQbEczeXVNejFnU1ZzSGwyWFExbjhvRXZQb21PWGlna1R2cmg5dmNo?=
 =?utf-8?B?Y1k2azRiWlMvTHBvd05oT0hyc093Q0xZUC9Hd2NLWG5mRGU1VmdyV2p5RGVl?=
 =?utf-8?B?Vk5yanJBWkovQTYvbGhQMm9JemNnUVJjTXdVcjE2eSs4TDdKakJNZS94THk4?=
 =?utf-8?B?dGcwaXZiRWd5VEp0eUF5WnF2cldsWW1iQnliVDhaclZQZFJueHF3V29XZGxU?=
 =?utf-8?B?TTlwQXlTTkIwMTZ1ZFdHQlZCQU1kSEVqMk5wVHBDUFZXUlFwa0RxcHQ1dksz?=
 =?utf-8?B?ZTdwT1BzNXRuN2QxT3lMNzdOY2ErNEV3NnhJMERFbzBwQlI1TDN2TFE5OFYy?=
 =?utf-8?B?WmVJeGp1bzFybGN5T2lEVTRJRUg1TUZPSDhDRlBzMmJ0WmFJQU5OZ2NJanRt?=
 =?utf-8?B?RWdEOEdablJMbExsNlUyZ2JxdmxaUTlrTE9xRVRRMkhnN2NvaHFyaXNZT21T?=
 =?utf-8?B?WmowS21FeXFRSkFpU0FpNTZYbEVxdHBEbGQvVFNXOVF4a3BXZ3ZDelFYUzNp?=
 =?utf-8?B?Z3pjMGJOYXlzVllUQ0N2bkx0a0xPelhqVE1FZzE5YTM3NzJ4d0ViNVI1WTND?=
 =?utf-8?B?TmpJZzR5ZmJROFFNUk1EUTRHMytsc0xXaXEybFlxNXVocXk3b2JFQTJOY2Nx?=
 =?utf-8?B?UUUzaWUrUTRVN2dqdTEyQVh4TXd1OHF3WFJEbk5TcHU0SDdIdHMrQ1AzZGJW?=
 =?utf-8?B?b0o3RGgzOU9pU1pCdXJWWGNUVk1Mb2E2ejBNSDRTVXpOR0l2cUZ3Mm9QSWRK?=
 =?utf-8?B?bkQ4a1lKYjFSTVdOYnY0R1ZCeXRGRUErRVBnUU83M3BJbnprdFdNbGozWUsw?=
 =?utf-8?B?d2lHbWJXd3haOHVPVDR1R1dzNUI0R2ptT1RVVGtaaStuWGVmQ1kwN3FUSE9W?=
 =?utf-8?Q?WiXA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXd4bFZPMzRtdFFOdGRpR1JEMkRWb285cFIzcWFobmJ2a3R3dkNqTG55dHNX?=
 =?utf-8?B?MEtsTHdLOUlheU1KWThHajlhbjRKdHVKM1M5MUk0aExna2lORUFUbGxjclll?=
 =?utf-8?B?K3BUTGorMW1sSTA0WEhkemlFRHFvcDg0UFRLMVUrbVU5TlVMQXFpN0VvVWlW?=
 =?utf-8?B?NWZpMUJXa0hGa2hzTlZwL09vM3FvcmxHMGh5S1VuTmNsVVFDcFkvaEpyVGRW?=
 =?utf-8?B?bGswOUNoZGNvSmRqTnJKbkNGZG14eDg3aTBMREthRlZrS2lianpOVHpJY1pU?=
 =?utf-8?B?M1I5ZHR5VHFJYXArQVRkSUZEb1JMSTNiTzM1WFk5ZWxFM3JKYzFXM3d1M2w5?=
 =?utf-8?B?Rk1FV2JiWk4reDBJa1Q3OGsvdTI5MjArTjR6bVM2bVJiUVNrME1ncnJkNHd3?=
 =?utf-8?B?OE9VeTNWRGgvWWhpVnZpMWY5cHJJQlA0cEpEcVlvUXhFbW1TaE5Gc1NPWlNj?=
 =?utf-8?B?dGVrdkxHVndrdGNVellqdERndkNnUkpZOGVBZlFoUDZNS1EzK0UvT25aalNU?=
 =?utf-8?B?RmFCQzRQYVNCQmYwT2lidEZweVhxY0w0bTRkaGQ2UmdJM2RrVDRwWWFUYzZl?=
 =?utf-8?B?SUJzVjN2aktDVldRalZPcWlUTTdCTXdSTENoWjVqcFhhWVRDRG1mdS8vRzV4?=
 =?utf-8?B?QXpMWnhEYWgyT3RsTllHNmpIZDFFNnlrc3BHSGJ4ODVkRHkxY3ZGSkdCeDZw?=
 =?utf-8?B?ZXpyYlk3Rk45TWpBMk5XRVRBMnFYMnptbUIzMUtjQkN1VVlOR0RKMDFXMjdR?=
 =?utf-8?B?TjY5RElnYUdlNzJCblpkR0xIaERqTEtFQk1pdXlDNmp2KzM0azhZeUh0Z1Jw?=
 =?utf-8?B?YklxeGw2S3c3VENvU3k1bXZYcDI2T2lqL2JSNVJpVmlVRkl0c0NML3JMRnZx?=
 =?utf-8?B?TzRpOEFVYzdubmM3c3FJT3k2LzhMNWpSZGdkSWthM1A2QVVTaWg0Tk9yN3Ux?=
 =?utf-8?B?OGRHK1l0Um81Mm5QbVhRVEdpVHBkaWtDUFMrVDZKdkM1Y2xNdTNjUXBtL3NG?=
 =?utf-8?B?YWt6ZXFwNm10czlZNnBzeEc5R1dFU2ovalpQREovOFNTbGd3T1VCQmlJVElj?=
 =?utf-8?B?YmduUmlDaEt3UHUzeHBTTHc2Y1JseGtqcFlSd1lOd2o3OHpIdEdyOEFoL01Y?=
 =?utf-8?B?eHVZL2JWajk1ZGhwcUxsK21oby9vOFhZL25JN3VMVlljTy9tZ1NDc2RBREFO?=
 =?utf-8?B?NkYzRTRhVm5SeFFhWElEMjF1RDlhbmUxU1hYZEQrWkREU2hUcFkxczFIdHhn?=
 =?utf-8?B?WE14UEtlRmNvRmtNRkFCdm96SnlwUUY4eEdzZk1CcnJGa0tjOHE3UGtKTzRl?=
 =?utf-8?B?WFM2RkZQb2hZNmRGUHg3V29JZ3hOcmZjQWhHNndnZlRCYmVTZ1ZRM1JLR0lt?=
 =?utf-8?B?QXJlcDY1VTE0SHJJeWlRNjF1cm1hcEdFazlkOE5rNGcyZlZLNm96NHJNWVFU?=
 =?utf-8?B?VUtNUEt2K3JqWW14RHlLSEdPRHJ6bk42WUNHVTc1Y01FMlJybitPcE45MTQ1?=
 =?utf-8?B?Qmp1MWs5TWk5MHUxRVFIMnBkQ0lGYkM2NFFtQit2dm5tQ2VweCtTSXVXdWZT?=
 =?utf-8?B?aFFYOXFWM3ZaY2FyZlYycUFWYlpyZEdNdEVTQjUxSFR2QUtvRlZHa3ZZN3pL?=
 =?utf-8?B?ZE1jNW1jNHJDRTc2ZnhZS05WNzY0RFNIT1V4V1ZFb2R4alFBdFhGRlk2YlhM?=
 =?utf-8?B?VGNRUkNVTE1NTHRwVTFsMFl2Szd4dVF3U2I4RVBGMVdaWVdFUnRmZDRXV0hh?=
 =?utf-8?B?bXNuVU9LYmFKRFk5d24yVTlXVGlidDBIZ3RLbVMwMVk5eWEyUUJkMVJUZnJk?=
 =?utf-8?B?YVYxNERzcXRHdzl5amNTWGlBa2FpRytkb0dTWE8rL3IxN3AyaHlNajIvTmh0?=
 =?utf-8?B?ZVkrNnVhMWcxSTNnT3pDUCt0R3BGTFZsQzhNclhHK3pxeERuUUZZNVZxWmY4?=
 =?utf-8?B?bWloVWNiQmpEbWI1WFBFU2l5V3VUZU5KV3RnNmVQYW9QK25FV1g4dVgzRlpn?=
 =?utf-8?B?clAydWU3L3h1aDJKZk9CSkxPU0o0SERtK1R3NEdBcVRNWkNaajRKME9lYU5z?=
 =?utf-8?B?dldGVHBxM1BrM0lrd2svU2NRSGZWakxRRy9LY1hXVjAxSUxCdFpIZk9lY1Q3?=
 =?utf-8?B?MFZXeUVRVXRHUDZqcEQzZStsYkZCZEg5Q2J6TWJXUTB4L2FiR2l1Mm9OUWd4?=
 =?utf-8?B?U2hzbDhzOWNlQTlxcFhzMDg0U3BTMXBleEpKK3o5eXRzM2lHVVRQSWlwc2s5?=
 =?utf-8?B?dXpkYm11N0M2aW04MTl3aEVDQThtZWhFUkMraDNqM1NkbzZoZjJJZ2dzaXVm?=
 =?utf-8?B?aCtHejBEM1p6VGxSRWRJT2FzUXIzVGhQMmZEMGxteUU4enNreTlxdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VfKMobCJf2cuTWGLM+gnpvduTjUqXTNfS1YCXZhGWq2Cbl0ZSnQ49kyl/MUDIKe25Wv34TQ46zV8qWBTyrzenmg9EBk9vBrDzDXIUF512SUoS8N8s6AqpBWJfRYToDBoefkVYNfT2CHjjf82YNedG92WrGGQhH9cYQVc+AH9FnsnJqxwNCZ5ZcIqxor+5U/LUKZmzxIEsq0N3RxEgvF+bDJkeD6x9vrh315px9nFGwEET0lDCVb4aByn3gQ6UPWOwEe8zrLF1fC4KtXC6UiRiQ8gS3ovtK+GOV0QeMUBeDDvcLlubOY+z1vFVywvnA2lvPdFAqTVmK251vB3IzQQh40gDxmY7gVXS6NQMwcl9aGp03zLMmQ+KJDBt91kG5S2GFTrr9lvUKDEC1PDHnc2jGyncIUv3ddPrZF0jHEFJAcqAmZuXefQK38yF6pU40nn03jUmLwHdSghM/8V2GJ3jTKmVE9er0ejNhilFIa5h10Yt6CsosKjEYOLhXRn0DTAKp+gfuq0Sf/kxIkHIG4cGOxapGBOCacLrvuuGQ0f/4Zoetrx9A0+yeNuS7/i8gb+SqeYCgyD621MTlalO4eHJD8Em2LQxVNxaHwUI+3anZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d55960c-c63b-4ad7-517f-08de645a5e52
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 02:00:42.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhaIxDh1rSII0LeXsga72ZrNKjK1lMEFh5IeIw0zpJ7eRahVsej5EU3WLZJ3PstawA1iPiW1hhF5aKB2smk0Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6751
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAxMiBTYWx0ZWRfX1pA7U/3xVxGV
 arfA9y/CpQtRJmdR4KR7/SjPRYV4H0mBoriKXQqrDfPNorkv+gPoQa5pw6DN+hcJCY91ntvvh+E
 LXC/YzKpwLO2SUu6bExnzBPjGWrhTui/WDNW9nLWjB04jTombFGNGhQJKm/RJg/FgnHNIbG2N75
 d67q6X8VoIjlNV+gl32BI4nxbOCtN0gTdrkstcuiJSEsS5vDb80EqiWIHiPRLrhIipsgkeeiMch
 UBeqzPCYcbeqG52rKMux7ZD5uix0sEbxue9LCBNcwqjy9BBJ2raOxvGgA2dDYdqpblAkHGVP0oH
 zS9KYAbNyf/PVBfq6XkeT3h6gmTb3JPRHIwFy2ctWa6U3D515YcLX2YI7IpWohY9yUPi81aDnQ7
 T30Ip6IMdHDSlS3FYNeg8xqF+jT6860DEp3dPUyACj0W9PTC1Y1sOM2bzK2P1v4z5Z76CHlcCk7
 MUdLWZA4R4+7bTemh2/+1K7kIjeX1OejZ9O0JjcE=
X-Proofpoint-ORIG-GUID: i1AVwc-Bg-PEkAxwUlYqh7h_NI0DO9xJ
X-Proofpoint-GUID: i1AVwc-Bg-PEkAxwUlYqh7h_NI0DO9xJ
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6983f9cf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=JuP579D9e4uVtNFJH0gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12104
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69EE64000E
X-Stat-Signature: n3b3diuhzuuexjcy9d476g8qnkqo8nzs
X-Rspam-User: 
X-HE-Tag: 1770256870-904562
X-HE-Meta: U2FsdGVkX1+arX38YUGOeMdWk079E9Lx0O64A0nnM4BBfUAn9eNqQxA6w3dtzFYmEV9tI6ehaEyymGiOKQl9ogHZfQK/+baUjLm6npS8l5RJRL0KBxQdqcjX9XI3Yw8rZKtKjGaea2soCvoliNgUeW9og1ZxjSWPB01o7bhgSqAOb64Hwmu1hOmWqXaLUNjIHbcMzFm2YNSo3GToTvlBVD+TJqsULh1tOV6+lYeZwWv/w4EIXgBtJxALM8v+mca8eqz9nBRSXvJXish9QX+7kV3CoeA5AkPYxqDt+BtGfo+qgR/6b7fS4oQkGl5Te+FJjvVVbsDnLWjwvRApegWLlwMlEvgDxVbKSLlP39mhyyDjDWVkjfi+2Ww8dI4Uz5Do7QcnmodsCX1Zh6deQiK7uqRpjunRXdBnifnMg3N75pvdk4qQg3zJ2ARoL+mQ+1g0LpJiaD3FYN4ozU5yAEYnW8DswMNm+vRGqhF77MZCqbgLG55zuGr7DVeb2CLzeMD+bDZhBzwqR0hQVtn4FpdMB5PkgopkdVsB3QJJU1XAcwtJEQwa50ALGPuLsTCi2r6N7oyaM0syTivR0zqRP9cvBOpgCrcdPde4KkEMtCJwAgJaPsoPJ+J9Aw0lqUWoP/XdEaXsqhHGaEa0FHOZxG26FSixCX+6mDxriP9x233GdikIUTjS0HlnVptvkyDU666W8hz7W3r8d3UaeLj4iNlUFfz4G2O14D8v2zKjcVFdtbtENhkjkLkJFlP9m2PMx/6DPZezfH2yVqHtuCyHwH4Eour4vYB6Kt42c0wHlSdthW27jhR2cdxMfhjhqj0TSuFqYBInTZkEvLAcGStgG1SdhXIZv4KUJ+BvKTDZUQgO1oFxnU+h/8WowndEIyHUXmnQvmtPf3tJ/yCrK7Sb6Lmi+ynFsbttHLdmVXXWwxogErHTwvzjepRzAKG/ylSrHQgZpeS66mJZJtSY72VmOZY
 sojOZAJg
 bt4QvFmkVnQlajW090tf4UFdMtGClhWBZOh779PS7frIwWEc9lH47zUx7SIHfrLVh9CpHgV72IMEYPSeP4zNInVcty7FLDyZ0AfTI3YQmf4eBYqSjeqxfJFC1i42Kg/TH1lamIyvzCcDoBBqW72BzbJRViG+Pqlu/gm2O/ELes8bjwpJxeM7JoqUTa4TdikaRYk7FWorxBxgyoaFX+YLSUnglWikPZNc5dtdFsbZpdATY0oV/3EF0kpa780FasXtgmedzM8eUB6/3DtlbAi+qtknRsf54ajK/17B7P+yopVxQUnKQmBPYUoFWyi8Etw2krqyGXZP3i9h8jTLVvOIUj71hoJE2+mKLw6/E/4BxJq17nEBKmnQ8KzrcOci45i5b2tz2FO9W3BxbpRM+ZVSHS/LHf5VBpi9jioDohwzgVRW/ulUF3/aJAId8xNEVcLweX5Dq0PF/UZh4Il4bDGT4ywmufRmrWy109cQiANK4Fexh6WB2YBemNRhf6HE5ChljAaHanGcrrIi93UBZLYfQkxtTpW7BZ3P3UOvNkTzS94wDdYUDSlGdCBODbSPeiNzWWJgW9R8rQtJn3rzYpBHylL0kexiWLOTgq6p9hQf8qjYIgrv+gjMyAHJbjFKw7wwhyCyLmNmMmjGebHUK6fpBP2PEyeHliOyF4RuNVfBeJoh8ixveF6/HMFCgK3FcKqySGbDF8xKga2xzcdP03x7CITidlcceh0Ap3rvBX6xAWxS93o9I7LqSfIbSM8TBDx/dj2J9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/4/2026 1:41 PM, Zi Yan wrote:
> On 4 Feb 2026, at 16:37, David Hildenbrand (arm) wrote:
> 
>> On 2/4/26 22:08, Zi Yan wrote:
>>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>>
>>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>>
>>>>>
>>>>> More details:
>>>>> later at sg_vma_fault(), the driver just handles a page fault by supplying
>>>>> a subpage from a pre-allocated compound page[3]. We then get a large folio
>>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>>
>>>> We can identify such non-folio (but compound) things by looking at PG_large_rmappable IIRC.
>>>
>>> OK, back to the issue. The patch below should fix the issue?
>>>
>>> Hi 是参差,
>>>
>>> Can you test it?
>>>
> 
> <snip>
>> I think you have to test for folio_test_large() before testing folio_test_large_rmappable().
> 
> Oh, forgot that. Thanks.
> 
> 
>  From 8dda4bba9964890462eca3ef3cce57bb4fab8313 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 4 Feb 2026 16:04:19 -0500
> Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound page
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/memory-failure.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 825c706ac576..137c67fda57e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2440,9 +2440,13 @@ int memory_failure(unsigned long pfn, int flags)
> 
>   	folio = page_folio(p);
> 
> -	/* filter pages that are protected from hwpoison test by users */
> +	/*
> +	 * filter pages that are protected from hwpoison test by users
> +	 * or unsupported non folio compound pages
> +	 */
>   	folio_lock(folio);
> -	if (hwpoison_filter(p)) {
> +	if (hwpoison_filter(p) ||
> +	    (folio_test_large(folio) && !folio_test_large_rmappable(folio))) {

Just curious, would this filter out pte-mapped THP/mTHP folios?

>   		ClearPageHWPoison(p);
>   		folio_unlock(folio);
>   		folio_put(folio);

thanks,
-jane

