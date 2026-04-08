Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75A710FC45A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 22:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11CB6B0005; Wed,  8 Apr 2026 18:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9AB6B0088; Wed,  8 Apr 2026 18:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2A36B0089; Wed,  8 Apr 2026 18:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA2E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:26:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17ECC58559
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:26:30 +0000 (UTC)
X-FDA: 84636823740.07.3475077
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97C282000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:26:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g0RdPzrL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wT0roOZb;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775687186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwbEL8vgea80m/xXXulolxTs3hrBgWwCZx68e5pUAIw=;
	b=p7Vmx0QL4OI9cQfGux8NdEMyUryiVsF6LlV2Tw25i7LtEn6RAsc/CnfYYyDRaAB/+aHIbW
	mSKBJGwlTk/egnXkySUNYXjQ/15XtC/ub+XW9Nr+JpaeyqoM111sW/3LdUfMfaO7C8nrbJ
	rZ01NOYjgmZ8IxuT/V/HuAhL7LHLuFc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g0RdPzrL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wT0roOZb;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775687186; a=rsa-sha256;
	cv=pass;
	b=oEXmwST+kgM2TWk2kCWQxmSSerPvu7ij55fCNLUQsAVhydtc7lB2gXsDoOwlAxhT3S0+oq
	apYWiFscfHbTE5d0Yrc38YEfDusif2T41Ft5CUMHUwANQI7DOQG2d7Kifz28bXtaKhkqri
	lV3oyRetMUzdgDjtDevQrDW1DFH3YC0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638KBkbO956525;
	Wed, 8 Apr 2026 22:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WwbEL8vgea80m/xXXulolxTs3hrBgWwCZx68e5pUAIw=; b=
	g0RdPzrLf+i+3J6ZAHxILG5D0xhgyXxmA1wVbI3Pm2nbDWfFwA90u+LZ2Frfh4Mr
	FWQz1UQLeGwhJPKJAoBc/hHzC+PCXGXsN2T9Hnb/hST5T/Bn1HDtFfBc4Tl4rlp0
	9qNtROFQPk/sexp+sKElChxOIQXfTFjuH9VOi9+lKe3R1I7lf/RoQdnfBd90ZgHl
	mNfEVLFBh1ChhZ4ZK/bPZ+3aOZFau+XjDHS7bn3yJjC3YGq5fYsq1UpLqtH+CSyy
	HOA/FCX/gRlKuuMT1/AkWyQAzyZxY9nh51GXfklScy9m1f+uGcX+DpA3BfyzG7+r
	aMDWfa5UWa8ynVjox+QltA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqecdjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 22:26:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 638Laesa008088;
	Wed, 8 Apr 2026 22:26:21 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmekcqcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 22:26:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E34hef0lgLfTu6e5VnG41g9RV9Cp5hZ15noCcvQFUBExF8aJjZWrtl3fL7kSk7yl8alvKO0nCIwfWUqWH+aCy5U7U+Yw5oqHHXrVSiH5U34FPGbCcLqv11MdLQr2BZ1jX1Jtfukauio0SwuRq+63Lc2uk3smrUglS8+OadQeYhQP8vDAie8c3XIfLp4nc/LgV0bRXxGoNJEJVH1xYEc41XYKyiOKB048Nreyx0xBBw1zRgOdaOSCiAkTh1Vbl4zD5o4pUs79rDVO4lG6KqSXXyiC7vc2lKNLb4N2di2QDwV4mtigu6MDfxV5G2fi756+rqR9Efszh0tFJ45P7EmdfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwbEL8vgea80m/xXXulolxTs3hrBgWwCZx68e5pUAIw=;
 b=AO7QsTCSviMz/ht90decJ5b76NkJ9Zf3efGldizT6v++1wgsNZW8f72+MoYX+sZoUK1di9UqDmUB4//3qgvl6DVxdQOVNw60sPw+v3ixGKr7soXnF1egzJ0OOjfAwpW7pHsdZOS3yfmK3j9YCOU4QOyFbs2AT2yw/Rf027ErMWGvcBle1f1kxKT8wATLJWuJThYLf81JOU13aCohJfJI32SOLPfcgAFgiSulrFwcGwq/CSlgrbTQn4WpTxhWhUlW3+7tB1u8QJGwLIzwrqX21YdzqLfF1v4h7d3GvAW9PbQxtSiVGEKKg6ZC/qcu8oEkLIJSrB/5f67loJT6gUDI3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwbEL8vgea80m/xXXulolxTs3hrBgWwCZx68e5pUAIw=;
 b=wT0roOZbLaqvnQoEOi81Umgdug596u9s+bab7gwFT1SF+CTIiBIQZDghEYWdeq2j3QD2tGJML/Z+Ff8AOB/Gdl8WH9VP2ibJ1HwB8HYkNQH40308Dt/M1tnEYSQwiyNSCUykCIY58mQIO3GNXy3J59Hwip3/qCsaLfkJCcROyrw=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by SJ2PR10MB7733.namprd10.prod.outlook.com (2603:10b6:a03:57b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Wed, 8 Apr
 2026 22:26:18 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 22:26:18 +0000
Message-ID: <ee802934-0be0-4c33-b3d6-38ef713e6bf4@oracle.com>
Date: Wed, 8 Apr 2026 15:26:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-3-anthony.yznaga@oracle.com>
 <20260403123120.82cb5becb19e1b572d474394@linux-foundation.org>
 <83b56ffb-6e2e-4c9b-b0cf-9f04b61ebe7f@oracle.com>
 <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0424.namprd03.prod.outlook.com
 (2603:10b6:610:10e::21) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|SJ2PR10MB7733:EE_
X-MS-Office365-Filtering-Correlation-Id: 680cc2a0-ded1-4618-367c-08de95bdda85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PrYhUyMsiMbi00dwHq/MGXzqv1aSwOmiwNpC1ijdepVWDRpunzxw5dQaOx+xDXEKaw2vnwN45VlctuKpNJ5VBV43UYRJkKnMxBYfHV7Gy4Q6PreYvY+lD+xe+LmDG59RKzabfMhR+KRxDfjVjAFhFKK2pOPntgsyOsj0hSWmh6Bcl23UAZ3AAnPSxwBgagFVWfDIY0qyWc8cg1d1+ewMRnbxJ3pyrW1asMWH13cIoltOc0gKenwM2R46rMQLxD3+8QJ6BtjeYILKnHk2vrc82PA21aoYt6cBUhXD8Gj/2PF5u0QuA2QeP7lTWl4+OqFXx0HZj1/0vacWHC7LimTwkCgJWgzNruKgzQryQzhK0zUj/PeDqxeBNwQphy5XjjS5k2y2V3oZ3Ec2jypR7Tkr1rjaQ/mnh75DBn1E9HNt02EGhKJ7ftQAp3WsXzZfJN24T3DILVPuNKNO+NXByIwpI/6Wrd3HdzJ7JyfMf/RpfWpnwIGOFqwa4HrjAa+/aK/MH6M0DGSDwNs2KZvBHTMASd2OYaqk2n0Ke50yZep+LnNJwqntiK2laHThdJaS8HQsz5izZKjdSLWGiB5bkea1s2z4h5ZOpdKfEsqDpirtT8XtKSjgPd8K8jHZApxxySioi9uRpM0vi0Prqlwd8BWM/8UKcodvjrPOQKZ+AokQlns1rwWqq3xeLcjxCVRgyWMj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3BUQ3RpSi8vTGEzTkUrRzZOajNvOFFRY1U2L3pucnZBMVhlNXVxZUt2WWdO?=
 =?utf-8?B?NGgxb0N0RUxTQW1ydlJvWjBKazI0K2tEdW5BWmt6MGtyK2VIN1IwUUdVZUYv?=
 =?utf-8?B?OTNKemRvaCtSOXdpVkNFOWxiNUhYQmdPSVNRUmtacHpqNkZZNjQ5dUlJRUFB?=
 =?utf-8?B?a0lTTDczTC9jRlpSSmZ1cmxWYW5tQTJFN3EreWloVWtTYlgydndsekNtdVI4?=
 =?utf-8?B?MW9Ia0tkekpwZDB0NHJhNzJUVk8wN1dPOFJPMWViZVZneGZKZ2p2K3NOSGFJ?=
 =?utf-8?B?aDdVTjNROFpNYnhsZC9KOXg3VFZhV3JkUFhMR3VDUzFFdDVzZHdPSThIYUdS?=
 =?utf-8?B?VldkaWJHZmw0bVI0RGExTFBBdTdzQWFkRktyU0tmR09zTFMxb3dhSEtSYVpG?=
 =?utf-8?B?VGZWeVRZQTFuODd5aCtNRS9FM1NSV3RvM3NGanJXKzgxS2hDMlVEZEx5QUlT?=
 =?utf-8?B?VEVGYi81emt3UjZVaGtqcWorWVRCdDUvcXpuQW1HcTRoakNGQ2FpSkU4NVB0?=
 =?utf-8?B?U09UcFg3Sm1LN01JSG9SNFhtc2VkbjdSWm1CMHk2ejZOTlk3T1Y0ckl6TUlD?=
 =?utf-8?B?R2EvQUcwMHYxN05hL0ozUUw2MHpLL01MOFpyR0VLbHNzYzB4VUg1UkJsSVJV?=
 =?utf-8?B?Qi9QK3RhRFdvck1uaVMwNmx3ajlvUE1MVTI1V0lUVmNuMGVvZ1lRQ1VXOHE4?=
 =?utf-8?B?cjgyZzdLeklhRTJoUGRrSi9kNjlCSzkvWmQ3OFJNNEliZ3dGNlFYRmp5cjVq?=
 =?utf-8?B?c1hadVJTQzlEcGxqSjZwNVQ4d0N5aHNFbTBmc3hPZjEvZGxqODlZVEJqK1JL?=
 =?utf-8?B?eWNXS2FwNHFaMis0R1lOTFRkSVJtSFIranIwS2w5V1VlYTVwMVJCc1BzMGJ0?=
 =?utf-8?B?QTRXa2gzeE1mUGtUWFJ4dStXVDFuQW5teHlmd2N2VkVtYjd4Qk14SE9BV3R1?=
 =?utf-8?B?aUxha1JqQjYxN0NDTEFSUUZaa2FNNXpDdDcvUjVGU1FnR2xYUEU5Qk1Qak9V?=
 =?utf-8?B?TjVzZjk1a3lrZ3hDUkpLTHZ2NmJmMm5DOCszQWlWQnBqMUJObktpVG90Z24x?=
 =?utf-8?B?SmZSMTVtOXUxTmd4K0ZxZWhOcWhVUER1RmkxQjhuVEQwY1NmR0NEUUVqSUtn?=
 =?utf-8?B?YUhPMG01VUZQT3ZnN0JuMlNlRUxHVHZrL0FrZUxVaVZsZ0ZTcnNWd1l2Qkds?=
 =?utf-8?B?ZjBBb1Y5NE5weVM5QmN1TGdVM1pCZFZLS2dxczVFQnNpRS9nRmVmR2xYY0xj?=
 =?utf-8?B?NUhGa0IvaUlNYkxIN0JDczZDU3VSOVJxeGh3L051R0pXeE1zWW84NnNqSXp4?=
 =?utf-8?B?Wi8yNGp5bUhYaXVoQnREd29zMmNFR01tMEZKK0pRTGFHQUJzNWM4SjcwNnFn?=
 =?utf-8?B?RGViaXYrWG1GNGZldWlLUHFRVklaekdFdXhVUU9oeVU2ajdMZkRpVmx0NURO?=
 =?utf-8?B?Mno3Q085TnVCV0dMb2JScC90Q25TQzkwdm1CK090a3pPczlhZUl4eTZrTmNo?=
 =?utf-8?B?bVlzNElxSytDNkg5b1FPdFAxbkVXcXRKUUJPWUFLQlBLU3o2eHlGRmgwVVBq?=
 =?utf-8?B?V0RFTXlSRXFSSXNveFoyK1RqY2hqWmE2eDJRSTY2SCtsUFJEU0oydHZXOGF1?=
 =?utf-8?B?TFc3YTVZc0NpNldBSVdJYklpOU5iU3k4L09jMkVLUHBtME1FQ1hWSnZzTGR5?=
 =?utf-8?B?MmcxRk54RDVHUmZTK0IrMngvdkZPcmxDdE1hMDlqaXJmanRxWkJHOENZM3dv?=
 =?utf-8?B?a2lzOS9BMVh5bzV0Nlg1QkhLTHJubFdOY0VFRVJnSG95ZGlCMTRIMXdITjBL?=
 =?utf-8?B?WnhMcDFWWjBEU0FqNkI1Q0Zaa21EcWRoQXkwZVltL1ZaZ2RjbkFrUzJMTWN3?=
 =?utf-8?B?Z2hwNElvK3QreG5wZlRvdWpUaUMzV21OQkRrTXJ5dExVbFN1aHJ4REsyU1h1?=
 =?utf-8?B?RUpySkVjYndPYkR4UXRoVkIxNE1pUUtkZnZOMUh4UWJrQ0Q2QzNpakE4bEd6?=
 =?utf-8?B?RW5QQlJ0ODNiVGx0eXhXM255ekxqa2p6eG1jZlNLeVJNSzUrY1R6VHVZZGVn?=
 =?utf-8?B?aXB3NGppK0Y2N2lwa0ZXWlAxQnkrYlNrN0RvMnlYQnhtS2F5OW9YZ2hyU1c0?=
 =?utf-8?B?VGFyaU1MbVFJOFFFSkYwOHhneDAvcWNGbVpERUcvbEVsTysrbytPNlpIL3M5?=
 =?utf-8?B?UVVsV09YSG5KSmxDeWt1WSs2QzdpcEZZQjdsWlU1V05RbW82YTRTaEJ0cUlM?=
 =?utf-8?B?WDBpS0RxZkFmZkEvS1VmYVVCSXo4RGFTaGpOZzA1NjBFQjFRMVA1NUhMVDBY?=
 =?utf-8?B?YTdodXRFbVo1VVU1SjQ3eEY0bGphZlZmNG83ZGNmZEVuNzlOUlF0YUYydHBa?=
 =?utf-8?Q?+3HyRQ8/7/Ajk29o=3D?=
X-Exchange-RoutingPolicyChecked:
	DnIPojcC0Dyt5DAJZT7i10gF9iu1BE7rKrOU4E6013Lb70m1RADTpB42r32mJTeVsKGEqGy4ZQ3c4VbdTJ2JGw9eO9sLaUsLZs3h+IuYW2KB+E6ZGVL0SpIEkzDAPiezDoMNKWUTi0cd67Xd9GVQRGGjWb+FHQ+LAPTBAgZYYoDeZnPVLYGrfvgWJSemPSLQmwUtTAqSiwmLthj86Fu1i2KIKSwPoXlht2lJdMJJmQ9fnNxwP+sIvrpvQSsM0QBbUxISgXNOnZ/M8bYd7+aqCwVBcbHLC0Ok9gHEqVI2H/uhJjvhd4iUoI+yG62hydVp5JlKp+Uv4Pj3J38D5s4sjg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bg00Xx427MciTETxaN5giZfJq2CZxBIZCTfazbMLNp9Y3nO5eNo8KbbGTqZvblA3ATVN5xpyMviaPv6Pm2GPnkMJVfqc5WyIEgQnseDJXD9ZguN5ORoOEbgjwDs8QeFHoJU99FZrfGMSQoWHD+iIkvI3lXM4dU5RvB34iNqWmMeFyWY5w5pfoka/WD2pVrWISxEIXUs1dSP6+BdaIwaHZPhfmhmw1bbfnt40sn8OTL0Jxi4Hjbuleo/d/1NhvXkJCroXtUubPKGOA7G8kvroSK+Me4FQolE/bvD3NzDf1t16ma16Lh8PISSb5mJlK3JwoZphnD6V5cJP/kWscYH5yN1LbDzeEHiPrMinb6PZe0eZvnAXD1oB8cC7SKxwp5upkscaEq1X6MMHCAnR26yI+2ferpyTOSFQbgz2vQWhzm3ZzR+ylfov8YY6LFSXioClcvTOmFDWlKU35DWVvi3T+jhMVksEtLQDZiY3bneaV1oY5v8sCLIKSEpdWIENi/BnqRbaJLWxwsQgRnKjLbZ8kvJvAufl2PrYelmSc61hgmJdzlrhkh6ai9oREEo76Nse5yehV5QdbyqNBuYpCglGimWzHX7ca9wvjH2DhiKegH8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680cc2a0-ded1-4618-367c-08de95bdda85
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 22:26:18.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QavshO0r0buNLF+uxSCsCMtGvNUuPm9dHbAsJdb7L22cjl5DxtNsMAcf0MfGFhbubay4tUU8J85NctUh6hmSoktU7sTUJn1qFjvGnf6QYk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_06,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=837 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080207
X-Authority-Analysis: v=2.4 cv=MtJiLWae c=1 sm=1 tr=0 ts=69d6d60d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=c92rfblmAAAA:8
 a=yPCof4ZbAAAA:8 a=rDCK9RucUA1GLYu7KuUA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 cc=ntf awl=host:13825
X-Proofpoint-GUID: 0pDe81b-i1mG6KDb2y_15eF7sIWKE9An
X-Proofpoint-ORIG-GUID: 0pDe81b-i1mG6KDb2y_15eF7sIWKE9An
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIwNyBTYWx0ZWRfX1N0/78sfVyw7
 iAOnMun94SriZTMBQHDeblABbFeVN/ihUrAUi4H7PfyJ/5H5c3H1Wi2DhXoCdZOXnqeUwI6OwnN
 mrvbmploEVRARRkg8RuBlkkVdQlyJ6u4PWM41dDVda+vK1355yoDMGUG5XGoPHYKyjwI6u9naIq
 uTDAilRCKblXrRuJSVzl+WY6zOINmrcfmXx9qU2HzJGr+wUCAkWPhNm0olOdpAddCrHOFkacOvy
 J1XjXi7X4RFpFLFbWyAjD3cuHibovIUR+SLW+MOf6KdXSN3Z78GmIwBK64ncocN3MLVdqfEuM9H
 8Th+++3eTmDWw2DfFR//9+VIcjo8YnI7h1DwTpKAxxEX/t0rVOm6avzlknjkdMZTuh7thERrPh7
 kSSpI2jWE2yS9sf26bdZH+iej+6U6yQXzMGLgP8Dw4/K6mjMbLdB3I0WB66MckpCHDKdF7uMdPD
 ZbfKUVwKiAsq2kd/3UE94bATFDdsZcG0gWoN0Yik=
X-Rspam-User: 
X-Stat-Signature: jqg9w6b3qz3yu3mkaja59xfguuu8tqzp
X-Rspamd-Queue-Id: 97C282000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775687186-823976
X-HE-Meta: U2FsdGVkX18JlBtdQz/tAaTiMT3Tlea2uGCmz8hYyNappDiil9TFMDrffHjIqpgUU4XIeWUhhddgcsglVTp/9xzV7r87HX1w4t+n8lMRy0DoEMDDibvl6DYyvFHW1MfA+pxhbcwB44dD9eeQP+FqidTeh7hEMOKMapySseFzHNGuY7dhUfZbz4hfCxq3rIUjli+30tVuLCObCC/oVSAWrtuCXmEMpFGz4C/60srp1UZd+57t5s8UjSbDfIvugGCY/N5iXactYAUXPVqekER3SISWvQNFaMOobomJvoTw2pidNyrykO46RHdQX1loGSYjCPaYKX2vELx7v2mMDR+WO6K7dJS7i7K/ankxjfeBRfzqr+Fase2RiIgrSDVLNWuxu9oVz6AJGA2R6yJYop7cS8jR4iJBybBRUq9Qj9QSHQ2eG+7m18aaCbPoT085KhTELBj4gF8vgoZMw6g77/1M8MejnH9tLaBIUVl0tUfeLjirE9iZiaK4G8ggbZhuhpemDnmG+V4FBuUgQ68lacDUzehE54GUS2MU3ioAOR70tvbFowABSOSPQkEZBp0G2nJQ3nih7q8H+FQJ9DjKuZIcfFYrIkp0mM6J6ThpSOrzIgU+3Foa9JvYWfXUp0ZbCXBsiQjYbVQxCqMVyOxlH+kxaOb3UtslZDR9h1c56IkcSITQrhzQu0kvWpztl3/7jvWe0P50RVTrWHiToPTPUX8Bo6bbDW/DMPtbsHaPr4tBlYh0ghNzJQI52nH35MPtstJf4rblojGLKylygG9nK5V+uflx/WW/XuwqwPHsgrGFQlT9SI1AtayfiKgVSxh8eLAL+XuexSXFVa8pFo4Lnn/t0p7Ya04bkcCkwim/jgzHoJwMu/2BbzCA6drY84Zez4BshofWfKYlHnbE/nzQz2BXP2LkNzDZSKXIh8K2XyCXF70aq0QatXA2uFWvRsWXhy29joRC2/0NU1k4W9Y09s/
 iUmBAsWs
 ohTAhBJFWLotfQ9152Vq42g+KBxVdVM2SF74X9JXozuzAJy5TyMXlpL1rH7hjBdxnZDltsz7fSrP0l1CxhE7zhle9WNzq6bq1dxFrB6YrOHfsa2O8tTT4sYBJt04YPclacJc1IXZR1DD4XoWVCJzAhgaSijXMdUo6RuY1qWWrhHQW39ZFJnz4bK71V5e0fBUZbfOTMSj3pnRdmMOu/Q9GceOIReRIHS2slnKdJBZhYqCPfvSZznOeuYsazpT/9vS/EoSvlJKiLZEwr1GJlXCv0VSRrHJ3Ni1rCk/xUwPJpbIZ5bVnoG0hvZKQAOtBX05+PxvrgmNihNd6zbpRtbeGW7mC4dwADVNZoryp6PjQC3oe5mi+SI5y3hFzQBBom2MEij+G6fnqTj786WEOAqtMYIHIVNHEha/tDH24FwoNeXnXEZZYafR3g6U1HZWt+KFt6+6gTQuBFF7PquNnC6JCy/HHy8OS5LEPkj1TFip44rTkYZG+gxTAWxzpDQShOkd8rwjsQzkwT4aCHkrC1Z8QcC9u7GttoLAs3jzVtVmzMNRqI2VMUsO0OCj4Rw1Oopk1I7b4s1cOhnwFkwcyTxp3xe0IlaOdmH8PNqrNIT6LHWGZoFJAKkYEyUTWYj0UYnaV+XCZPM6iaYPkJKNOmL/0WWbx+cIAUVgiYNL0ml3ei5MTE2RN3dPQiDAISbSkIL4dOWiljgecYjj7qf4xOeFrrJUPNt1JVmzw/HiGYZDwhUxYfIB8nhufiPvLtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/8/26 2:02 PM, Andrew Morton wrote:
> On Wed, 8 Apr 2026 13:35:42 -0700 anthony.yznaga@oracle.com wrote:
>
>> On 4/3/26 12:31 PM, Andrew Morton wrote:
>>> On Thu,  2 Apr 2026 16:59:33 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
>>>
>>>> For configs that support MAP_DROPPABLE verify that a mapping created
>>>> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
>>>> be locked if it's created after mlockall(MCL_FUTURE).
>>> There are a few queries from the AI reviewbot;
>>> 	https://sashiko.dev/#/patchset/20260402235933.10588-1-anthony.yznaga@oracle.com
>> Interesting. Of the two issues, one is certainly legit. I need to add an
>> munlockall() on early return from test_mlockall_future_droppable().
> Cool.
>
>> For the other, the question posed was whether the tests should handle
>> possibly being run on an older kernel that doesn't implement
>> MAP_DROPPABLE. It seems to me to that a selftest should not be expected
>> to work (or even necessarily compile) on kernels older than when the
>> selftest was introduced, but I don't want to assume.
> I don't know that there's any policy on that.  My attitude is that
> selftests are not intended to be forward- or backward-compatible.
> That's why we ship them with the kernel source!
>
> If we get a selftests fixup then I do like to backport that into
> earlier kernels if appropriate, to keep those in good shape.  And that
> has the effect of reducing people's motivation to run a later kernel's
> selftests on their current kernel.
>
That makes sense. It's trivial to skip the tests if MAP_DROPPABLE is not 
defined so I'll do that.



