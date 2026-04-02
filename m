Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A587D6AB16
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07676B0088; Thu,  2 Apr 2026 19:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7916B0089; Thu,  2 Apr 2026 19:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9588F6B008A; Thu,  2 Apr 2026 19:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 832B86B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:16:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F0E41388F8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:16:32 +0000 (UTC)
X-FDA: 84615177024.05.9FD8C0C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8204E2000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:16:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I3CuMgvQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fecmk5zl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775171788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gd24/x9GPpazbs8H8Eeo0/LeWKUzVg1k9M+VeypQt5Y=;
	b=blrUIdlbhLQmQpefAYDd4PWbxb1D/cGuvbjLZephURVPXVS8ylo2RMIKmBH5OBBVsWFDyc
	Jsm5WZ1iK57+CnZvfNfsmsrW4zmabxpdW7Rr4Q9+t9278a1J8RJ9RfpCzFSOnRpsQq+Zu7
	Qshx4JPwYy2aR8XoqnRSch80UHz2rG8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775171788; a=rsa-sha256;
	cv=pass;
	b=LNlTQdr59xxvkBRkWrBVGrkkgStB3q6m7hkwjjkMPS+VnNCaURanW8QV4pZTAP34WWy02G
	7gPtD5wgZ5MtdJlulZaB/Y1C6s3xEey6ucy6iwFUllEfinUykb79hK7lWcuKeMvg9cQfUI
	dJ+J+sWK6yczOS7+hw0xdMTdH184A4k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I3CuMgvQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fecmk5zl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632LGcQB1499860;
	Thu, 2 Apr 2026 23:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gd24/x9GPpazbs8H8Eeo0/LeWKUzVg1k9M+VeypQt5Y=; b=
	I3CuMgvQWL6L//0ouRKNil0vWJp8ESjwvdHFQyT9pO0V4m4uqF2dHFbn3c5NGku8
	2l5LDSHwDijE1LJiJ5Rb/jOMwH9IDx/U385IGvuFFsLVanLIDgfyxyGsfaA4HvNU
	OR42n2DXyLnLNLSRWeIdkgLzMn6c4JypQIfAirdxj3qAJVb27N/HsbOM/KdpCwdv
	cA1P4ZDErR1ory8Keb1jlhszBkV+mK8w88DVsV14roZZMSswL0HyF2Amf8gVH35S
	ch6pCGskG+mb/D0zWWbG9vH9Uoodnh86Jc61cHO1ulSgG+xXxdvKQQivTA8JHaIq
	90bJPE4IKpLN8F8tMc5WTQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65jwhcxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:16:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632LGwgO030602;
	Thu, 2 Apr 2026 23:16:21 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65edb9r9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nrZSPQgqOW/YOdOYbrui7yzrFjzwAK/NKbwUVFeNYtOBwB28CXNE+v+IPeDrzF11C8p0WcxLXdlOPSM9HZpXeWgHDTqq09yV4dTtkOLEcHbh+L8CMNbe59pQRFg4TqWKDNIUxt/1InXlOBxPFE5X8/g2hf1IKn6hJSKC2IxnnK/vUqWWf7AAp7s+Ffs0WlMs0aFl91gqVvlhMO5e+mRbkul3pN6v5sX5tVwQGcEG0BGPSBa6ygP6APu7bDdpWYAMUyQNXV2b7Oeo++0psFKO1q5NuUsehefceaYSUTqNflW4PuhFwJL5mTvWIVbxhRiF9JoafpKKKHQDRnzCB0HRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gd24/x9GPpazbs8H8Eeo0/LeWKUzVg1k9M+VeypQt5Y=;
 b=DWN9YS/3wJPq9cfx2/CbjFXVpw5eGluFdsM45zal2c30S5Ig+ZzhQTXEgTrAeieQFHqY35Rl15wTDaiDn7G8PupcTVz94ILoiDvNU2g0TGdZvYCOhqXX729UDDBSm6hMvNSCrwhZA1BuVsmLIojJOlogioq6CZ6/YNWP1iudV6qOYmdcwQNhdo+yUP91m2QwX2PbkjNl/MZiA/CS5ui426yDBhcN4j95RuT/CyYf4sIWn5uDs5+EQ0wSQARDS71PuBVwu6SVWR5uo7W2ZH5gJDbuIrM34vUv0IucIKFF94YP8RG1HhtLN0k9G3KJSCieT4pjXOETXtggdzhBfGDr0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gd24/x9GPpazbs8H8Eeo0/LeWKUzVg1k9M+VeypQt5Y=;
 b=Fecmk5zl+Bn/oEF1nz0XrI/Z5ZICfTdAkMPE6ZqhLMTxQbr59b2NcCuDvysnampZStW13Dcgs2xZ0s0TK1Hjii+Z/tmdkvkH0/j24bQohd67iiqSnRDeUH24HRhH6d3Bi5SlAtx105wFN1LY8o2HOXIxHrXzVqkubwNEgm35YQ8=
Received: from SJ2PR10MB7653.namprd10.prod.outlook.com (2603:10b6:a03:542::22)
 by PH7PR10MB6459.namprd10.prod.outlook.com (2603:10b6:510:1ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Thu, 2 Apr
 2026 23:16:16 +0000
Received: from SJ2PR10MB7653.namprd10.prod.outlook.com
 ([fe80::f05:2c3:660e:b36]) by SJ2PR10MB7653.namprd10.prod.outlook.com
 ([fe80::f05:2c3:660e:b36%3]) with mapi id 15.20.9769.018; Thu, 2 Apr 2026
 23:16:16 +0000
Message-ID: <f5d0a290-73ec-4ff3-b196-d58e76dca6b7@oracle.com>
Date: Thu, 2 Apr 2026 16:16:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-3-anthony.yznaga@oracle.com>
 <4f6d4ee8-9f2b-4da8-9456-f47cccfe4367@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <4f6d4ee8-9f2b-4da8-9456-f47cccfe4367@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH1PEPF000132F4.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::39) To SJ2PR10MB7653.namprd10.prod.outlook.com
 (2603:10b6:a03:542::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR10MB7653:EE_|PH7PR10MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c78591-4ab3-42b1-dae0-08de910dd707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wsErljqKpAShf/aeCMmdyExwPr8yYqjJxSblrZiw2XUk05IP52s95cPY6kywfkkY+2CrRSXjUJcZp+mpecVuZTL/lVyl++KW08duXKk50ynwCW4G9bnEoXe4gN75lqeVI1kmd3UmEbxE8A75iP+I57S1ixOYdG70RjLDT8KMX2y5CaRhTEik25D/GcQl7XrO1kgz8pqiGpXbCpQkSUwcGVz+vZ9reFZzLAPh4caSDHuRmyppvTadDQaOr116njtWeVyuVmmqoCjMR6CbEa2RnTpW1s/KyHW66Uc6cKwzPpZC5akIF+CrnQZlCJMX3AEa3NUOXmVEJeaVcFQ8Yjf8l6hBfP3BgZEUQI/f1AuTmV1HGDVpLcBZlR+P0wBdKlQFzd/AVtauGCeiKpgEHP6MEPm8n8bUPeCoqP4IH3tpRDZL4ZzHNh32/uGY1T+c1Dt2JsyHseOc3Lw7JsBaBj/+Aqh4P7lda7eHnbI4MgV2x3COhg6iicl9137PSMcJVS8CD4xpJmnPH89r0YJo2151v84YPB0nN7jJVVGHBWC/8NOvtCTzkMFOpYW6jddlesXfGA21NjFTzI0hlzrJoLuLUqk+SEm4MYS+Et35H16BsNQaxHwMbty/pFp3AN7HZ0HxUJkjc5mCZQuQKZn6T8uoTGxCbAwpVhhj7VXD3cJiKQUCVB6p2+/3VlND4FNIfDUlfXKGid0AAkiZNeV8c5a5dLtZTkCnw2TmozK99Z/SySI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR10MB7653.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N01jME5JOTlmZTFES2VKUHRCL1hXY1JSMUcvZ09SOFNpUkpGSm4xZXlUL2I5?=
 =?utf-8?B?d3lPdUNkT1F0c2ViU3kwR204MUdPZFVpM3ordXByTTYzMXNlRlNaRzQ1UGNs?=
 =?utf-8?B?UGNyd2V6M2tHT041dE43UTRYdjlrU3BpKyt4cDZZRTBDSHRzMW5iUVZWZWdM?=
 =?utf-8?B?VzB2NEVtZlRQR2tRN21Ud25FazhjbWtGVUFBdmRKcVMvNm1yUDNpRzRBR05v?=
 =?utf-8?B?dGlIWG03bTE4cnZkSEs5ejN5Q3pDTDN4Nk1YaWFYZnFhS3dxZ0xxTzJ0REN6?=
 =?utf-8?B?V1hPall2Rk5TQjFMeWk4U0xYbGR3bUFvaTFiTWtwdWxoV29NaVBadStIR0Fj?=
 =?utf-8?B?dkdFUUpoT0VHYk5OZ0R2QkZoOTY0Ny9vdGJvRFRJMk1zczFBUWtmOXVLSVcv?=
 =?utf-8?B?SVUzd25KU0IxVS9Pd0c4N2pmZ0piYmtJSmZ0d1hNTUNNWGtkUSttU1dwcGty?=
 =?utf-8?B?dHFUaVhpMWdvZlQ3RDA1U21UNm9oNThTM0hWZndRbzhNZ2laaWxrMFVtaDY2?=
 =?utf-8?B?QzNodjVjN0tIbm9ubENnUDFMVEh0UjNGRjVCS0hUTjFHeWt4M1grZFIzREF4?=
 =?utf-8?B?Z2M2b0FqYXR5M1ZXVUR0cjA4aDhMUEQrbW9PZTZyZVN0Nm9ad1NNTEJxRjZ2?=
 =?utf-8?B?b0RlMmcrMTdkalZPTlpyQk9DM1Z0b3dyL2pDOEdlNjlZS2Q0bnpzeVFYRXRz?=
 =?utf-8?B?dkxYS2N6TXdDMmNwbGpKRWpxNHczOENIYlNSbk51dnlWRlh0bDRGQStVOXhO?=
 =?utf-8?B?MjNlYVdhV2FwU0FqNDZZd2NsdXgwZ2NSdWJhRDFtcWYzcE1wYjYxNHY5S0cw?=
 =?utf-8?B?SlRpRUd4cU5ZMlJsK2c3eFVWbmp3QnU4TGwrQ1BuREdCSHIvQklnTnI1eUkz?=
 =?utf-8?B?SXJGelVLbUpKYUtpbnhPMk9nVEZrZVE3Q3c2NUdVWklSa3ozSW02Q2Y4OEwr?=
 =?utf-8?B?VjBzeTd4dm1zclFad1FzVTJReEhrS011cThtdGt3YVBQZ2ZCMzlFU0laQ1ps?=
 =?utf-8?B?V1RHc1JOT1pNOU9xM2RITW10WjlrQlJpUXZTUTlxTTZERzljdVFLRTUwY1h0?=
 =?utf-8?B?VEZHWmNPczl4UEhkVmJ2T29YS25qd2hFNXZuWG8wRndLMVFzbjdoZEtYZHp0?=
 =?utf-8?B?TVQ0UWdFRE5zOTFZV09KMFFLNkRaTW1SU0hZNmg0VEtid3ZQaExJNGxhZERW?=
 =?utf-8?B?RXBneVZhVFBpNnM4T1NtQml1TG1JMlJBWDdtempCdXNjY0xDRm9GN2FMUGJM?=
 =?utf-8?B?c1NkK0VmVXpsU0ovaG5PZWUyczhWRzhML1RaUFczUytqNkh0ZUlTNnN6b2Uz?=
 =?utf-8?B?a1MrTnZnWStoK2xSNXo5QVhhSURqcHA4UE4xZGVqOVJSRFdLR3Y2Q2NoVjFq?=
 =?utf-8?B?QitBdTc3a0wzM2hVWDV2ZFJxRjFKRlZDdXd2VGR2L3FSdHdqVFRyMFZUNnVv?=
 =?utf-8?B?alM4MjhzOHI5ZWMxZTJ6dXlCWUNlcTNkKzloR2NDeEE3RXR6eGJYRmdPNHhL?=
 =?utf-8?B?OFo0aUY0dEhmeDIwNnhhck1NUk5oOGFRaUlYUFVqclk3b0gySDJYdUpjMHJt?=
 =?utf-8?B?R1pYd1RYb3l2SnEyeEI0bnNRakxnZ0dFM1FybDkrT2xtTWZCUSt6b3dGVUs5?=
 =?utf-8?B?T28xWWUwMVJweGxIQkZNc1g5cXRxemtGZHovWXlLNFZtODFSSHJaRmZ5Z25X?=
 =?utf-8?B?NWw1dTQxTnU0eHNRM0VaeWY2Y0lPOFFPQ3R3dXZYQVQ2eFdRQ1FGTVlZMGQy?=
 =?utf-8?B?Um9FRzNGUVZkRUdxSlVhcks1N2w5N1VZYWtPVDhJYlpOY2FpeXRQRys4bUxB?=
 =?utf-8?B?bU8ySHlXTFA4ZU54OVIrMlVJUHZjbnRtYVRudzlNcU1mUlk3b29tSnJOQ0FW?=
 =?utf-8?B?L2tkN1lGdzg5dTFvdWUyRE9XYUlrZ25OR0lpZmRrd3JRdE5rYXBQSE5vdnc1?=
 =?utf-8?B?YnZYcUZWc0hhelRnVUo1d2xSdGRpZmJwZ2x5cklvU0w0bGRsQUlqdXArak4x?=
 =?utf-8?B?RDRWRTg2Ym13UnJJRmpJaW1IUmlOUVpCUEpEdjRGcTg2bUZxMEtlMkNKUlh2?=
 =?utf-8?B?enJDR0Y1bTZQaGRZTFFqVWl1NG4rdmFDVG8yTjV3MlpvNG5NU29aWVp4VGhu?=
 =?utf-8?B?UG5BSWVVbDA5TUtlM1gzMVZONHM3T0hUY2xLRy9MbzBob2JRQmt1SytocytV?=
 =?utf-8?B?MFBmZ0tyZHhRNlhxMlRXVlNsek5rMGhIQ2t0QlFkWDg3cmp5U1dWSC9RMWkx?=
 =?utf-8?B?bFU4WThBekgzMS9oRTB4SUtNUEVFVG54UFBybEl4dWNaRjd3RmYwclNYZVpq?=
 =?utf-8?B?ZmVmQW1jc1JNR2RSb04vYXZlRWhmVWlLQXZsbzFHUWJYVXlNVUNrVGtQVGYr?=
 =?utf-8?Q?uxFDOzAQnxCBmBqI=3D?=
X-Exchange-RoutingPolicyChecked:
	ZOl6LTJJYnVAy7WqYMfoqEtpvd0Nnifrsryh+/i3gUAMmujbiYuvVgDcpdeOZKEa8Sizp/ClmfJmSQWeztF33WuakBIGJt+e2G9W6LJS716fyn9s+lyc2r4F2f9UdcCf0hqL6ISUKwuqp+DLbp3OIxaIK6QHNTBP+MBR9JoceUk+YGh6Nzsbu8rM+2dpu2CWjJ60CLSsYcN5HlUsyqUF9llCA8k2V0mFu+/z1X0ae/RrDBEAjPmsqCxXXRNWLbdCtyOvh/kRqAd8aHcirmTHK8ejrnsaD4wdihJYlrJ0fCuU7bgpYXyYeB56aqzByWPl0waxmdi56AefiZAy8Ztv9g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p8EmJVB4sgJpHLFtyYzXvREBfZ3xlTpbU191FLtJaNs8nU1NJoKzApoEMUPuMxy/LjL4e4RizWlVy7zdNZ/Gn9HufAKdykukeyiAmXkgGE7XkYZax1xGUl44C4hiOkrRqI4SAL/YFt6CdHOlCmEW0gIhWUxLF3OyCyr7QfOC9m/X1rHzhsCvLJmvYjjx61/u1MmVBUODprclpverWeRwM+H+8X0E3NQN6PsojDWeb+7wXqhGq41W8YpoLzlTkcsbEHotgG6fjT3HHBjs9OPVVNzSN9YflKthzkRaqpIdRnWNzsY9RLTB1MPnqVbo0BJvsSXDhLMBUeL4pxUI9/xuBXhvTOlLLmISFg+5icdY5fyqj/fFZZ9+ke/6O1jb3X3C80mhAubG71HMTPNoSNTM3lOW+4b5DHKkoMI3B79Z/KbuRCPbbd4/h6L5Oc3a8jwMDEX2uGHGJ7CrOfrPBsAuoRxb7nf+HYfI5MhRRhodDhVN0bvYl+l1u2gSoHfrqVBFNaVsCkNhn9Dwep8tawjAHL6SVOjMpOIhU/3GpCXESK1BWqjiP5k59gsEVJEA9PUrAMVU7UOwNtqtp6fRqNFADS/yn4JKxqHrIjyVQ+WsLVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c78591-4ab3-42b1-dae0-08de910dd707
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7653.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 23:16:16.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duTkKXpH+oof6XXg5niACTjHkW53V48zFvU0LuAva2HxqMiFogKay/IfG7CkLXnhgYGLwDLFHB5xG7VPheGndk3sFAVuB0iJWbsVq1sEFiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604020207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIwOCBTYWx0ZWRfX7UuhsImswCzA
 PVsJCT2G5VW1HLl9XxKqVMEHZbQwHWOwArCtjgWHLQIEsytwRnxumv5BLBdnURgY9ITdV9aj3fB
 fwjAvquCjT7xzeZKxFhZ8ACvQAVe4fBPDdF1xlxrPUVq6EGZLgFzXxZ//5ywOnqZwSqB9aeNl5B
 NqP2hqlLXZPkiW2XggxQ7o5wlOewQlABnkRld8QUIugj+Yi6BXHYsJ5bepc7XJlVIuxhonC68ZU
 YydQu99EoTudhhb5X+Fa0JSepnRF5cpKKEOIwveeORpSVJRawdTX/G8V4YAHf3MkoIZphXxk7lY
 W/TjAxL/apUeCuiFVM5yEz3goODqneAqNZuQG2x1qq/l3/UB2lqJ1UhYzxrZegdfLp98cUmW2qB
 KoMda6CbPdYS52OV6TSlPAgUqggW7vcBnh9RJf7JzdgHUfM0EwWptHY34P7jT58FUfSL+GQ0Frr
 TetSIUvtZccAH8jGhNA==
X-Authority-Analysis: v=2.4 cv=CJEnnBrD c=1 sm=1 tr=0 ts=69cef8c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=Y1SGS-vSWauLT96NxJcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zNRN167AWaLbnK5V97BfvgWpgDB_dkqs
X-Proofpoint-GUID: zNRN167AWaLbnK5V97BfvgWpgDB_dkqs
X-Rspamd-Queue-Id: 8204E2000B
X-Stat-Signature: xapfc7caimgnax79hubo4reziegcqsfh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775171788-278228
X-HE-Meta: U2FsdGVkX190SezgqLPwDNy7DU1IU+1tNmDrGp/OLqbe/09PgFZv9eKOzV+fcmOglubXEdmHPyOILfb1X/7PD4UoHoHAxlIidngU60WGM7y8Lrmxj9qrQ4twhV+uVgFMeUW7pg3kebr8zkJoRo+Zd2WR1mEGhnAmOWkDcrlkCvT7Vbvn+qm4kPfeOuVqNCYturx2ovailkGJQwA3RE01l0raFWrHHawpxGuFLml3W2jrfcAvuMfRQQkaHOLe1Ce+i2nmGWEzA+cGwyeyMFDMGU2WyOZXZmR+solP9kSLJm8J09ZQ1Z/W+sDflfDJ5Be84S0x9QQ+ODWrqw3u+z1+BI+4PJV0FGHvXT2Oxue9vdZSxMz7WY8fUoW3rKg1n7xkJqBym97Kb0YUHUd4oDOtdExUP+h9vCMTvc/6oOMbMyEoeEza3ClfYO+UX4e+FlVa4W/dm32hZqZVm6LH09Uzr/w97sduGufJ++lGRwNkoeG3Yjo/Cv2oFMKqObYl7RyNtv2qmgB/GSv+fK/CvuTvmYqny88KBGzbdB/cpvtEj+8YbWzartpKoead2yP5P7OblJ8AXl5KX9LIBACPUM6DHWbODF/5RY64QLfjrta6eA0RSM1ZwMXnOpecgdB8l6/pxiqtw+CWG141z5h/mMaIcLbfgpNu9qtH/i9gfXbgztgSZXruRX95b3VVcVCzkXSuDTz7msFRM8PsI8kj1iWDBlOuNbVLhX/oyl/hXPyNOpche2vfJt8Y0K3NwQ3u1rnUyl9y/hSi86btPKQH6VBBcHqbxyIXeGSZe2Bse4tVM4Hx/5PNk6pIPFCefiLeyZ9II80CKW6hqta78U/Tvy2HUHvuFDDb5dYhXPcuSMJfHiHFndQjQT/ZgGQoda7bKUVaIJagxVw85jp6e2v7JbbIr1klV3FrWWcdFf8TmZmQ9776T+DwnmhAzQbBM9Rra0BYWj+SWMaQX5k7FcNx9q2
 3XCiu5MO
 10uOeI7N3i0DAfTXd86q1JSU+ovDA1VQiYMMg4+g72uau0Ii4sbhPCaWIXxPpsO8PscXD9RmtAIqyK5M4zM1K4oCmGvZDAB4LT8W/yRUwChwO0lbY4m7seJohJAuhf/6y+bEGyg4RP9ykvD8fCXRtMvt1xyU626jgNwdEmL3lYh+M6kdaiRBrK2gzGL1wup3ZbJoPl6DLfoVq+d2ZL4tCFvktyryIZUpyfJb4rjWmNGykEHryoDP1kUrLPPJzNtn+Da042I40o4OY3vBGbB2epRiL82sahQX5ABWNaZ2JnCBXjen/5pwMkC3sU2Wjb7e170FSjshH9gzThZj8w2N7y/XUo3xpCBkQ+cSJCPkMpPlmK+9hAYXRJs35Wtf/NSASedDHQ8y7AFZBQZOcf9gqKichkC+LieJ3VIyyAi9Vpw8jIVTGVsTG3PbVaud4TUpJCzaOE+oLtCbdBUx5PqQRx5yotFMDYFYmYqpfZH03hF+wdHtiLQzRDw/UYkQTfSPI7NSgcvaFcZRpXdagmhDVB9IzG7bisN4/hBM3YAuEkrR8LBTrbh2y/W05rOCEhDQ4lyVLzijkWfECfOSNpurnplu01kjY5AtaOhM0hg6K9gawqXFllU7jZpxoN0lGedT5GC2o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/2/26 12:28 AM, David Hildenbrand (Arm) wrote:
>> +
>> +/*
>> + * Droppable memory should not be lockable.
>> + */
>> +static void test_mlock_droppable(void)
>> +{
>> +	char *map;
>> +	unsigned long page_size = getpagesize();
>> +
>> +	/*
>> +	 * Ensure MCL_FUTURE is not set.
>> +	 */
>> +	if (mlockall(MCL_CURRENT))
>> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
> Why do we need the prior mlockall()? If that is really required, the
> comment should be clearer why the munlockall() is insufficient.

The mlockall() is not needed. Will remove.


>
> Also, why can't we fail only the test?

The tests can be failed without the exit. I'll update them.

Thanks,
Anthony

>
>> +	if (munlockall())
>> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
> Why can't we fail only the test?
>
>> +
>> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>> +	if (map == MAP_FAILED) {
>> +		if (errno == EOPNOTSUPP) {
>> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +			return;
>> +		}
>> +		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
> same.
>
>> +	}
>> +
>> +	if (mlock2_(map, 2 * page_size, 0)) {
>> +		munmap(map, 2 * page_size);
> Not required when exiting either way?
>
>> +		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
>> +	}
>> +
>> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
>> +			__func__);
>> +
>> +	munmap(map, 2 * page_size);
>> +}
>> +
>> +static void test_mlockall_future_droppable(void)
>> +{
>> +	char *map;
>> +	unsigned long page_size = getpagesize();
>> +
>> +	if (mlockall(MCL_CURRENT | MCL_FUTURE))
>> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
> Similar comments as for the other path regarding ksft_exit_fail_msg() etc.
>
>> +
>> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>> +
>> +	if (map == MAP_FAILED) {
>> +		if (errno == EOPNOTSUPP) {
>> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +			return;
>> +		}
>> +		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
>> +	}
>> +
>> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
>> +			__func__);
>> +
>> +	if (munlockall()) {
>> +		munmap(map, 2 * page_size);
>> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
>> +	}
>> +
>>   	munmap(map, 2 * page_size);
>>   }

