Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018B5C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6F96B008A; Thu,  3 Sep 2026 14:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEDE6B0092; Thu,  3 Sep 2026 14:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86376B0095; Thu,  3 Sep 2026 14:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 557B06B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:57:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B0B6A0662
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:57:38 +0000 (UTC)
X-FDA: 85173359796.04.A0082C6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8CF7918000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:57:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CMrkg05o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WCUJphIG;
	spf=pass (imf06.hostedemail.com: domain of dongli.zhang@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=dongli.zhang@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788461854;
	b=s4j6JWXRxzfxMtU+jgoG0MLctKEB1V3+PBFtHpYCh6mxiUlpURTLBkowSfW8/gl6tq1JdZ
	nEWj35Lg9iMZekMiFbpoM9H49kqKg/ARm6QEws7LHuEgRFMSTZvsEMOVCOrrP/vblmWfIY
	cTuVoxhImr68wm6sBoGMo2b0URbEPqE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788461854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeFotQIuKmGC0rruOoQwszQWpvFnaPNPdUCGbUdKLlw=;
	b=ZbcnsPy2TyHCfLnf8P1SQP4O6DliPohgaDenLOWd3Fdx9WM2KjqhP9z99+r28Ulbb+U5KX
	IFCn84w8fxrk76CTQZPkX50Vm2KWbwdFi8FFrmmvl/0mUCENegoScKPnd0Brvb7dkydP6p
	ejbt4XteB9i+PFw5p2FmV4GiMyyrlxg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CMrkg05o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WCUJphIG;
	spf=pass (imf06.hostedemail.com: domain of dongli.zhang@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=dongli.zhang@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DvugW415351;
	Thu, 3 Sep 2026 18:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TeFotQIuKmGC0rruOoQwszQWpvFnaPNPdUCGbUdKLlw=; b=
	CMrkg05oxh+eV+b1CDxTKS320GUANTT+YW9KWJBkwWxPEfrCOzk5E/ubpg2BRZCr
	kLHoBwLS3maAnPEin8212Xb5Y3BbQlGkmnsIVpr84A+wTn3uHJv+BfrbDNHDXvRm
	14wehWOWMynSuTwzkcnp90ZhnAIaxtXC20QDE29HYpp/383y49hpxgsAyYkfApI7
	jY7zsRYS+qEKpxFnJfjgpNI76gqaXNlZb3XMsARmkf4EEVMp8EtSnSqAmaRGxIiA
	ZkqgAyNxKv8sJnjoKv424Dn7FSbKXsXw9FJbeY6/uvO3APN0YsamYO0DHhRkZxM5
	jc3xoglol99gUyHMl4s4pA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqys1jtg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 18:57:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683Int7U009026;
	Thu, 3 Sep 2026 18:57:29 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvh71s3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 18:57:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJTx5qV8e7a3N09JTo1n3rcj98gUTf4440l1LvLVfnCS7MHw4eeEd7lKj62Nbym2FmfcA9D1ato0IvY5XhOceji/q/Hj+E4QzdUO64R1WSZHzBkxfQF5QW5tcGvfC/agzCXmZZyIVjartf1HpFqvgphSSinStxU8P3uWm+OGN+MibV3g3X0CSVtzxDolKY/YLAaPwkpQ4UQ1WVgQ3+GY9xoJMaDboLhdX22XJTnZpZsHShuEEftDA1imyOYn8+7GKDMyUhvZGribjHLgICui6ThXtpAkJ/5FgrQymAx/uCMWnlOjPyaJhn6LHPPFOV0CHXjpJ+ajqvddNP1tWGlzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeFotQIuKmGC0rruOoQwszQWpvFnaPNPdUCGbUdKLlw=;
 b=qeqkd7l2UH47zxB6knMCs2tScuB1B3GqyuxqHaBJfcCZ1OiaYx3UgxGbupk35d3SAU1JB2634GYZk8ZeX6xVz+W10OO6Yq9SMrAXWskbUJHVEXL3NCv9GuIOsDDNKWn55ZJbcVeJeDlHoF9FDllYZjzXL6N5Yqk8wWJt0XFBYB4oJCnr0s8GFobbo8UTFuxwNsiNrYyrY7pPNUiNxXlwnfe2SpPTif9MXgm5Z70YV+M6CqKIOrtmQLOlcP1lvgAe2xfBbYPaTpDqo6nKVd96LpQyDHWgDDQ0wSU0r0ZfpebMAEGRAUqLHi2vdCPhfZGx82joOUi+d+qN9If/P5r2VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TeFotQIuKmGC0rruOoQwszQWpvFnaPNPdUCGbUdKLlw=;
 b=WCUJphIGjpcPH1wBJo3OZ+R8ySDS/R8FihkK/objTrEBtZ8rDhlKD2wi5lc+ITZyg3H2bKjaFpAieHXdUMJg9pRlMerPJJr+UI16WMTEFmxZnyKTHsZJuYKcgy2JCAL5IkzVStLslezjtdMa7X4Gka69SxLkf0GRNpp/A5c0yGI=
Received: from SA1PR10MB5510.namprd10.prod.outlook.com (2603:10b6:806:1e5::6)
 by SN4PR10MB5591.namprd10.prod.outlook.com (2603:10b6:806:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 18:57:24 +0000
Received: from SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96]) by SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96%6]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 18:57:24 +0000
Message-ID: <5c223d7d-4f7b-420c-8019-d4f343f0f232@oracle.com>
Date: Thu, 3 Sep 2026 11:57:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
To: Tarun Sahu <tarunsahu@google.com>, dmatlack@google.com,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-mm@kvack.org
References: <20260903155907.1065681-1-tarunsahu@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260903155907.1065681-1-tarunsahu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::14) To SA1PR10MB5510.namprd10.prod.outlook.com
 (2603:10b6:806:1e5::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5510:EE_|SN4PR10MB5591:EE_
X-MS-Office365-Filtering-Correlation-Id: add30f0b-e1d1-432d-bc37-08df09ed30b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TdAdv/wf7ZZLN2eN5S2kSC7uyGWknJLOwhiTlrDAoH3XnYbd8Q6kNamfcsTgvMmjpZMjrUNEUIa8GflzW9amHHQOMRqiN3k6WMsSOFPZTt2b8W86aeyY6vTwlIEkhdBXipQHMBYOpLy66Q3pZcb+gzFhzBjZvfPizzZ5ShTDZAepeqx9MhJLx8qgm0CU73Szsw72l2CdppigQbSDCDGQGl8O3aFfNqAPqt00LVO8+sbMPhaRdMhDz2Fy+IF3EqIWlYm6KaGSiuF9VC0EolsVPkcJW1AXD8k7txz5r+/6r3b9B23yxkJVYgvvREeOccMA+PKXhFb4U2O5qWHdjP5SYef2mGjsz+kLPEnDngLyfko1coAx5px5UTH+/bGBmcVL5t4CT7ygEr8+86MWhV22/nwkTEgY/1TSwjJOUp7etstuOMmErT7rKeaWAaMGKr85ikymQwScvVTi6pWXvK9dfnSiQZ84WBZOG69y7n+qPl5unSvFn315OEIZFyNm8vpl6I/c8gJzcj2SpSBcEl4SoE8IGgzfN4O2bpx3r5MMyj0WX4w7R0jRhzN5WgGoUrukOLbm/KW6Jq6KOhlpXBhHKGy1HTHkrs2oM7HGBNPOqiSU9PcgG80oEXL7f+ALVReFj0nVXLG2y5CRtmDfVbJJKJwC64fiLPutFtwOh3LcFyU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5510.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N21CZUFhVExVZzBBZ0NHTk1zUXcvb3RuUDJNb2xNdUliVnpYTFFmSkxHa3o0?=
 =?utf-8?B?OUNjRUlvL0ZtUDBPQWFqM1cwOWh0SkRqREc3NllQbFBoa0NFVUxyOU82cnRm?=
 =?utf-8?B?YzcvVStNZStRNGpnS0RvU2l4ZjMrNmUvT3ZoUFVoWkt5bis0dVVxM3RxcEZ5?=
 =?utf-8?B?T1ArM2xvVC85VXJ2VTBwMGVxMmlNTThRUERjdnE0ODBQQy9aN0xheUNzQlJq?=
 =?utf-8?B?QjdLbmtxaHNrbkJiOVhoQXRQcDJBN0gzUkd0U3FSTkRNcmhzb2xPZWRCYU9C?=
 =?utf-8?B?bmpVeVlQdjFweWhQUW1HTkI4TmhUa3VLQ1BFTEdDS3V2V0RwcDNYb0RiUWxo?=
 =?utf-8?B?RUxxY2xFT08zY2Vud3dLOHNLZEVoUHJYTmNVcDNRdUw0QU4vYWdzRFlsK3lH?=
 =?utf-8?B?c2VYcHRYVzhma3drRFNWMUZxUmdXUXd0VytKOFNBZ0R1bkxaSUh4OGM3NEpF?=
 =?utf-8?B?NXpodUg2aXd1VUJuSG5rSUFnd3BsMEd4SjRiUmhVQnNrVHI0Y2FXMTI2dkhR?=
 =?utf-8?B?RzFQNStIN0VMUlJ3WTRzVUxxSlIzVEd6eGlBa0JIV1ZybVpXbjM0Y2loU1Fl?=
 =?utf-8?B?UFBDOUdwSFVxWit2M2FkazN6c0lzelhrRjNDYVpBU1NtTzBYbE1LTHRHMmpM?=
 =?utf-8?B?RE5mNXh6N25BcDlVc2lBclhydUJXQW4rZXBHUkpwcVF4c3lvZHphd3FBRW5w?=
 =?utf-8?B?WUNrNmRqN1NCRXpXZnhFbjJyN0YyZ0tVTENCVlptcURmemlpNWZIakRkVitD?=
 =?utf-8?B?bVFNYTlCeFJFdkRVa0NvaXc1Y0xkTWd4M0VPa3dIcDFYK2x5azJGTCtNYlh3?=
 =?utf-8?B?MmpmYXdaYkZBMWh1YkRYaUR3SFN6N1RZdnpqWUVKdDV5dzIyd1d5MWtKSlhP?=
 =?utf-8?B?S3lzdFcwa29OaE5EdXBjUFBKdzlraG1IRXlhcUpzZnBwZ0hram9BeThKYVdI?=
 =?utf-8?B?eS9ZTFBhUmFIdkVXYlFKNFZKTlBEVGdndFJ3SU5lcEdJNUNlNmkyMENKUFRE?=
 =?utf-8?B?bU52M01IMm8yRHBmK2VYc3F5eGFjcE02encxZjdFdGVOQ0hWRytYMVNUWURh?=
 =?utf-8?B?Zjhoa1VLUCtqUU5VcSt4ZitMaSthZkN2WWdGd1RjWUtkREZzcUc2dFYxL1RV?=
 =?utf-8?B?OWxzWXU1MDR6Y2lpUnI5U2xURi9BdjFkU3E2Z1lUbkV0ajVtOE5KaW9xSXpE?=
 =?utf-8?B?VHhVUDJTeFRaTUR2UndJUVNTY01IWCs1aWVNNjFrNkNyUVF5ejhmeWU2T0tE?=
 =?utf-8?B?Z21KZ0x1UWpFMGNvODlCUE5RVDIvM2h1MXRSN3JDYW1JM0M0RzNCTkFZRE04?=
 =?utf-8?B?OTRYc1YxNmJJTmFXb2t0eEtSMThMWEdVdGIxVXc0bUsvZHBJUjEzbWNaRnVV?=
 =?utf-8?B?QWZ3ZUtiNU1YNVRiNVREZlVCTTVnWjg0Y3hMK05jYTJMWmNBcExHTzIxb3da?=
 =?utf-8?B?TFZtdnpEZkxjT3Rjd1FGbEhKNWdKVGF4OWdzZ0NKZ2FDVmd3SUhXa3dLd1li?=
 =?utf-8?B?cVBWbUpNRVhqaS9sSzhBR0hWZkN0MDJMeUFNd2YvUGJRa2w4MjFjV2s1Qzhx?=
 =?utf-8?B?MFpDSmxSNDBYZUtaSEVweTg2Q21VakhNbDQ2TG8rcGlFdS9TMEJ0WUtJMUtT?=
 =?utf-8?B?bkd6aEtHWkJlRWwzQVVnTDMxcWZmNzdKZ0VsVXRRM3FqbzVwMk14RnEwVGlV?=
 =?utf-8?B?enluWUZmb3BrTDRvWUFJaGYzNXo4S0VJc25qUWlpV21wMXdIYko3WHpPTDRH?=
 =?utf-8?B?c0ZTWUxoSzdMSlVSeTNJN0tUVTI1Vzc2dk55dU1XT0UyT0REbWw0NWd3blha?=
 =?utf-8?B?aU9LakZra0kzTVJXYU5SQmkzN1c2TWtmRTFxbnJLSUplM2dWc29WdGdoVXR1?=
 =?utf-8?B?b09EZ1JKSXBNM2hzK2xzWU5vTkdJdHJlLy85bUF3Ukt2NWhYcTFyQUtyWEg2?=
 =?utf-8?B?Y0xMT0FoeHhDTHVKbFRSbVFxRG5QWnhqc3JaanRxKytCdnl1OGdub291bmkz?=
 =?utf-8?B?TjdHWUc0NkNyVkNIVFVMUmhkclhmWnlUWldxWDR6QlErMFFkMTVGREJ6Z2FU?=
 =?utf-8?B?UzFFZWt1d0xOcDc2ekR4cFNhVUhpb1JtQjdXWmlCTlVMMjgzYmZ4bXJpVGlQ?=
 =?utf-8?B?NmFsbmYzcmJGVGpMd1krYkdQdzBnLzlGeXYxeUJJUEtzWU5Hb3UzSFZJczZp?=
 =?utf-8?B?d091c2Z4T2ZBRlRTRVRkWUh4eW1YZEtZaDZsV0w2N3lMejhYTWNQakFGZ2E0?=
 =?utf-8?B?YXNja3VQK1RMWjl4QjhMbmM1ak1EelVKTi81Tnd5V3FROWtNaURoL3gxdHB4?=
 =?utf-8?B?eEZ1cTlXUS9YR2E2dTBDcTFpWmNYTVFKK1lxaDhSTFAwK1p0bEY4cUs4QjBk?=
 =?utf-8?Q?G9UK/JF0xle7pc9g=3D?=
X-Exchange-RoutingPolicyChecked:
	LGy07GP8NZf+wApO+RdK7srpTI3+EZJ/EUGxfaf0kkpwvyxoPDoINLhf/Xo6RyAaxpst+Q7wt74gXJK4WLm3qpYPgCpHmKSxihD9whHrlHI/Q3lM3nQGHiieJOglF2Q1EaTfUmcMw6QBmr9tqInf00dWfDCm54MA1upC24pP5FhVYs/r4AIUZkHQls4hoB4L+ae+DuysgIgKDcIY06rg5EOLo1P2Mnd2kGprd+ajCZo8aTwzv+T9MYU09AsRt4yuVvdaRGWSreTxkeq1Y7GYaxsOOiXBsa/2fst4zazugmSgze7xDuqo5SfvwHlSDeUscApJX1ncZuYNOKY4CJVxtw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xgf0bi4Etel2aUoh5ZWtEnTI0yCYxi6uQCHwYi+89INIpLruQZHtTy3vzMD6B+YUkIbP72ykqnnQrykIHHGmXblH0GRVhxQAxzsBh/HHQzwu2iuM20repqZA3iG70L1olN0tW0YNA9HYeB/b3AJLhLfaA3cQEsioji8W0+LkmarnxDsQs51hg8m20hb4w1DDGd3Ytie3zMWdDJlyXAFhSOnCkW9/k/TVe6ql1/8TCiWzoamsFnxHeGzIu7vncnoeOUfGDDOYUgcOQxLJ3nDymcoE3ZFb7IPbqSt+QBwAHacShISY5u5cFOL6B8EfHPUsts/t62kkQJpTGtfL6WN8lr3ps7p8tnus/p/HsVFFvnVrhRL8CR/1BufHFT3o64OnBlH3zLqvYxKLVfjcQq9qOAC6pZri6s5jT+VMezpS4kI7ncMG49uyaqkrPymXWi8b4g/PuI5NbCgru+hNfohYNKirHQIDvXJ5NPhOmgBNSQcN7KJDTGZvzGC4gaXJn4qzvm0VyWnNiJzxtrLHO7009j2++xnFKi4taueaMtimM4SWU7A6nL7C7kvV1TxvN0ajxWi3e2eVwFySYTSXWXFjaHcX6vJZTJagaLAowHXMG2w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add30f0b-e1d1-432d-bc37-08df09ed30b2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5510.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 18:57:23.9865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LI8OBum5FnIlYaitoZd8+qnEVd9mnw9Tdkk9KcAx9j5/Iz0JKvtY5QuPQ/KRRXAQ+G5PsfkvP5Y7hr61L/lm1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5591
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030165
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX6c/bs9qW+VG0
 RGsKFBa+5/jfi74dr1WBQr7SdgUrJ1+4YTO6Gk5XH2nvCOMOTqcXXzBrscKqU4oBgFjpyohuUST
 I2UChTqQmxAXSs0VHBt3iS6IRN7ImQ2CMa8jvrPDYEXLUAsca/QocpfZtP9A+WH+UQcHj+O/7UT
 skYfNDV+AALrPd32HxUKnlRSdrpmrhG6ixMvddjTEGPoVPt5DEJgROElHqV1JniGaATQarl3mwp
 ZzoCe1zmUpGer99UCJHbPNNagK1VSBQEyCKWIXtzlBdATksDCcOhmitH4nSk6dkbsv955QEmXAN
 BS1m85iCtJD0ads7XjAnHHM6Qk/L77CIZUm8qkxfqZy6Jun4LkvrovAP3IFkVzDxo/xQKiwdIsR
 muix7bFjMgXm9WD6ZcQ/EEF5gI5e5xvfzJGCKjPl1K7KERDyGJd3wOk5iAKp2wl/IQnMttkwMvQ
 o3rNM19L0+ZELTubiBg==
X-Proofpoint-ORIG-GUID: gka62W9UiXXhJnXZ_9jqo96amNWiq1wC
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a99c319 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=1XWaLZrsAAAA:8
 a=EGV9gTcE0ndGCJ_sItsA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: gka62W9UiXXhJnXZ_9jqo96amNWiq1wC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfXwAehzaEiP9cM
 DsSQqcHxVkt4qleaZRKR/dapdkXjV8Bob+FtVTR/I7oe2jrJVTxCuuUua2ANzMYGbRc8F6Uq6Uc
 ZkPuJjxXm/zsdGrgZGHa6vNUH6qC4Jl6F+HwzSMRU4sWBCVMA/W4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CF7918000E
X-Stat-Signature: y73jrn8te7h34iheusabj47sdx81kmp9
X-HE-Tag: 1788461854-647928
X-HE-Meta: U2FsdGVkX1+WodTHZU+kOpK1ZPAysilxvm27re5y4x7VFmm00uzs6faWtFUQaz1MbKL4IBCV4hW/qHRR9I1la1Nk+8FVbRMurhHDcLhBpa+xzRDmsrAOCgoyEZ/yK4moFtIDiQKSbB5PIyzwfX4ervuSOSIu/FrfEMhZ76b1Wu11zjiJgAksLqDLSjEe4A3yQiSmkV4YsV8dhYnBHwP+exb2+s692H93C7GMn2Qr7wlmfMFFqnuQEEKp9YHMpjvlMO77YkRcD/i2AAW+K9HogmxHUokqM1PQ/2QgIglc6rd/nDYlzKp4jjlITFgS96OmstIQ+VD1DObUBqplBfOYZPzekOtOtHEnFCx5804AWjMrtNIfNvgerg9pXcFYN+Nh6rDnM4Cr+Y73vfqgsnJvaPCuCoeOrCDqVt5VY0WdHB+sK6SUo9HFKt4/aNL21xNaMG8PrrEInI1kamq4xJIMbug5zbak5VbU9hUu+lJr7R6y4bO5Ag27cDZlgx5Evyi8XNe8yaFLP/H9DXLgIHfTQt+qzukxmKfSoNDpIPpJSssbdeFmYzHBIef7+x7KBmmlrKVyHyytudmw4r/Cw5XHTOxzSKEe3GAUNlS7tZFDivRPjxyIRNpyX5NP1rpsJOhNFlAwD26htAPCYkDmKOUduKu16YI1ay2HyEjjngySk+SLxE7hAJ9OD65QjvRDxIQTFgBX7nUj2Jz27oFz+U4PxrCPbBjCa2CHpX0yjh96mjmfiVsTS3mYSN41eJc4bz8jP+PSM+6JC1vOUOOgCfE63fbJ5oIfPdCke0IRU5b6cOchBwQlkPZRB6aXYqrSynrTlSX+YREADE3/RA2bDuYnDk3DcxMjIE17DRAEwlLKEx3CbmQi9l0kcP4274XiE+Mav4gVSNG6YDHaaPf3Z5vtJnJxyHEUgGWOVHIKVYgQ7MDrgJ4i+p+mSnMQs/4HNxTsoW/h/xQ2eAfiEmm8LZI
 GgrfwZ3U
 YT2h31Ns888h/N2fmj8QRywRXMkXolckRlLxFYp1h8vtLlE57iFV1kY+2HfvD7IJ+1Xm5F9P35Ycvsb3dZellFL36vD378gO9KZ3ulzpRX1jeMnucNE2FbzdLKORw0rux5eLwlwec60GUjLFJ7JmgvuyZ4nu6OOfXo+pAaihy7FoX3Dz1uOjaqR3VTmCz1h9FrnxNU06CUdkXWTFOM8/anrO5xk8kEQQh5j0qRsG7IkXqQSqIy7hmOEVdWFffqZyT9p7r61e9vqP/EpsJKXjiaHrIulGdL3Il2SjCTG/JtYX7iWOOyvTeNODsuCRui6IjVxcua20KKAbsyJK4WUnnYDiquKeLP/JTK05u/QF82cMDle+6wDA0uc2uW1IVjc3ukrJPSRiU6APrkXZMvWAbcHf4zrm8hAXMlMIMdH/1OClL3QYp/m3+CkfayxW8nPYeoBvEenmwXTuOWhehQFzncSu1XX+WTKi6NgTIH2vT0WjMEVZxR1kDJlAh9OdVbEJ3Sjq6sGwFqOtgudW/UprXRmktVzuwgAhhk7KZJdM9ctbIrFS+qJKHjIpuBbaQijcuWCA+etmRzUVc4bEZQd0+RFdNCRbJSnSOAMYiztUJvpq2aOHDtsKkydXvWGKxgJL1oJjdrCPXV6dI1/c6QvhQAh1OBBOt+74JociEtB1ENLrXj9Wf7CSjn3Pu5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, Sep 3, 2026 8:59:06AM -0700, Tarun Sahu wrote:
> Use binary search (memblock_bsearch_start) in memblock_add_range() and
> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
> 
> Under heavy memory fragmentation (such as KHO page preservation registering
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
> 
> Using binary search reduces the worst-case complexity to O(N log N)
> (and O(N) for sequential appends), cutting KHO memory retrieval time
> from ~268s to ~50ms.

I encountered this issue with my workload. Initially, it was because I forgot to
set THP to "always", As a result, there were many 4K pages even though they were
contiguous.

Indeed, I noticed some delays or hiccups with my workload even with THP set to
"always".

In the past month, I used something like what I attached at the end of my reply
to reduce the number of memblock_reserve() calls. I never realized the poor
performance was caused by memblock_reserve() itself.

[    0.231623] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
--> delay
[   38.587378] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1

With your patch, I ran several rounds of tests with THP set to "never" (4K
pages) and no longer noticed any hiccups or delays with my workload.

[    0.247746] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
[    0.512019] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1


Thanks to this patch, I no longer have to put up with the delays or hiccups in
my workload!

Thank you very much!

Dongli Zhang


diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7c4d86daf86d..03e1f914c800 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -67,6 +67,8 @@ union kho_page_info {
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));

 static bool kho_enable __ro_after_init =
IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
+static phys_addr_t kho_preserved_batch_start __initdata;
+static phys_addr_t kho_preserved_batch_end __initdata;

 bool kho_is_enabled(void)
 {
@@ -610,25 +612,58 @@ static struct page *__init
kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }

+static void __init kho_preserved_memory_batch_flush(void)
+{
+	phys_addr_t size;
+
+	if (kho_preserved_batch_start == kho_preserved_batch_end)
+		return;
+
+	size = kho_preserved_batch_end - kho_preserved_batch_start;
+	memblock_reserve(kho_preserved_batch_start, size);
+	memblock_reserved_mark_noinit(kho_preserved_batch_start, size);
+
+	kho_preserved_batch_start = 0;
+	kho_preserved_batch_end = 0;
+}
+
+static void __init kho_preserved_memory_batch_add(phys_addr_t phys,
+						  unsigned int order)
+{
+	phys_addr_t size = 1ULL << (order + PAGE_SHIFT);
+	phys_addr_t end = phys + size;
+
+	if (kho_preserved_batch_start == kho_preserved_batch_end) {
+		kho_preserved_batch_start = phys;
+		kho_preserved_batch_end = end;
+		return;
+	}
+
+	if (phys == kho_preserved_batch_end) {
+		kho_preserved_batch_end = end;
+		return;
+	}
+
+	kho_preserved_memory_batch_flush();
+	kho_preserved_batch_start = phys;
+	kho_preserved_batch_end = end;
+}
+
 static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 {
 	union kho_page_info info;
 	struct page *page;
 	unsigned int order;
 	phys_addr_t phys;
-	u64 sz;

 	phys = kho_decode_radix_key(key, &order);

-	sz = 1UL << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);

-	/* Reserve the memory preserved in KHO in memblock */
-	memblock_reserve(phys, sz);
-	memblock_reserved_mark_noinit(phys, sz);
 	info.magic = KHO_PAGE_MAGIC;
 	info.order = order;
 	page->private = info.page_private;
+	kho_preserved_memory_batch_add(phys, order);

 	return 0;
 }
@@ -1687,8 +1722,13 @@ static void __init kho_mem_retrieve(void)
 		.leaf = kho_preserved_memory_reserve,
 	};

-	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL))
+	kho_preserved_batch_start = 0;
+	kho_preserved_batch_end = 0;
+	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL)) {
+		kho_preserved_memory_batch_flush();
 		goto err;
+	}
+	kho_preserved_memory_batch_flush();

 	return;

> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  mm/memblock.c | 38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ce86349a29f..88940474b020 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -160,6 +160,11 @@ static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>  	     i < memblock_type->cnt;					\
>  	     i++, rgn = &memblock_type->regions[i])
>  
> +#define for_each_memblock_type_from(i, memblock_type, rgn, start)	\
> +	for (i = (start), rgn = &memblock_type->regions[i];		\
> +	     i < memblock_type->cnt;					\
> +	     i++, rgn = &memblock_type->regions[i])
> +
>  #define memblock_dbg(fmt, ...)						\
>  	do {								\
>  		if (memblock_debug)					\
> @@ -591,6 +596,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>  	type->total_size += size;
>  }
>  
> +/**
> + * memblock_bsearch_start - Find the first region index where rend > base
> + * @type: memblock type to search
> + * @base: base physical address of the candidate range
> + *
> + * Returns the first region index that could potentially overlap @base.
> + */
> +static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
> +						  phys_addr_t base)
> +{
> +	int mid, low = 0;
> +	int high = type->cnt;
> +
> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
> +				 type->regions[type->cnt - 1].size)
> +		return type->cnt;
> +
> +	while (low < high) {
> +		mid = (low + high) / 2;
> +		if (type->regions[mid].base + type->regions[mid].size <= base)
> +			low = mid + 1;
> +		else
> +			high = mid;
> +	}
> +	return low;
> +}
> +
>  /**
>   * memblock_add_range - add new memblock region
>   * @type: memblock type to add new region into
> @@ -651,7 +683,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	base = obase;
>  	nr_new = 0;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for_each_memblock_type_from(idx, type, rgn,
> +				    memblock_bsearch_start(type, base)) {
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -827,7 +860,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for_each_memblock_type_from(idx, type, rgn,
> +				    memblock_bsearch_start(type, base)) {
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> -- 
> 2.55.0.970.g62bdec98f9-goog
> 
> 


