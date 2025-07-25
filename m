Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF85C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 04:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EEA6B007B; Fri, 25 Jul 2025 00:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF8F6B0088; Fri, 25 Jul 2025 00:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8807D6B0089; Fri, 25 Jul 2025 00:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77D836B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:24:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24BC5C05E0
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:24:50 +0000 (UTC)
X-FDA: 83701496340.06.6A84BF4
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013024.outbound.protection.outlook.com [40.107.162.24])
	by imf22.hostedemail.com (Postfix) with ESMTP id EF61FC0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:24:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iNqFX6Gn;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iNqFX6Gn;
	spf=pass (imf22.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.24 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753417486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri+AlUbzumRXmwGQEZ3TR64yOWHcH2D40s7UfMATZSA=;
	b=yGYmP+zJ1C0c80WZ2N+lKMbF802U9rHZOz+M6SOHVlamzucnSmSLpnciQ0ZJaInj1OM1Hg
	T+OeZOIETsRS2CRWjBFYPYF81KxuxbGUzaGVjMbYk1GJTMBF9dkfH4SRxflBPdABkI1bpT
	zJt5Tunaag076GnlQBV0phWjLifrxnU=
ARC-Authentication-Results: i=3;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iNqFX6Gn;
	dkim=pass header.d=arm.com header.s=selector1 header.b=iNqFX6Gn;
	spf=pass (imf22.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.24 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753417486; a=rsa-sha256;
	cv=pass;
	b=r6LtxlsiVrO7o1rCRE6+WjAI7ic4kvQjn2h2TxkUszBEWKDGoCcOMVrNTjeJlX6xCzGfIO
	cI6UjSeNGWxCZBiGB6pgYOGJOHbeVtxpjCkJNqE3ECrbMafTFSZ8mererToHQKPqOLcKB9
	sDjORtcyqlAfybofnQByj3CYvUCwY+8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v0ZoOtoDdKK9EwBJaKZi/miEgvtSRKAgC5LsdeJFjDRrErHOVagKrrhdDPnPcE+G9RnH48T+G0wh84bJaVvCwFJBa9ujGRsmGwsjCy40THP0za1JxnrU3YLt7mmJBzcC3wDLriPPZLoMMSfoNFq/lTDPKj+d45JoTP9dm2628zTGRCeNE3tSQo/jr4nPtD1rxMpunHBEAsgDLi2vXeP1C8lyXKtbyXxZ9q1oI/fG1j2/IYr/GjO2H1+aG25Pg1i1WHgk7I7izI6dAoNL3QA+ekYjK8U9f4rD41b/Bm2bwsATen8+E2hA0F+YtjqhOCzIvuMBgzPDGSqOs+BxFeLHhg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ri+AlUbzumRXmwGQEZ3TR64yOWHcH2D40s7UfMATZSA=;
 b=WkdGF0pCX3Ezrr7iTlJzqrxnpRHf7r2kuAGJV5p444WqoJXVDT0Sn6jxdq4CqB0haCzolxAHWuulCzAivLzR0kalaX2UdMqunzqcWDQLiM/SYcBdoKu1IbfbuIE8/NjP2iT4m+oO7cYd8OJyhehYAX8sPIb/4Q7SLMG+i+3/bW2JK/gqLBWEX0zab/nt/My2Wo7qRUFcuhrjXNtwK8VNCgo1/nNEnEaQbsCOe7LKcQi0AYpTeIPBkMJYLJ2m+g40wWFX73nJ1gWhhXXZMh0V37BEZaEO2/97oToiA3WJiJV+++A3ti/2CkKlaBVzb7z+6f66pW5VHHseLc0cDalyNw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ri+AlUbzumRXmwGQEZ3TR64yOWHcH2D40s7UfMATZSA=;
 b=iNqFX6GnYEsskYeSyeLkwj7vtwVgW9DyfEdvKTx4qvriiu7ppJSBEykPTIr2K3q6lLQktsHFi544eRtF2lCssEfGQY4aRWO7g3p/nbklscOq5eMAVMBNSrfjwfoo8LOLPD2t70XgNPrS8kgvnhzuDya8kMvAOkquFWT67s4Ad3s=
Received: from CWLP123CA0086.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:5b::26)
 by GV1PR08MB10453.eurprd08.prod.outlook.com (2603:10a6:150:170::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 04:24:40 +0000
Received: from AMS0EPF000001A3.eurprd05.prod.outlook.com
 (2603:10a6:401:5b:cafe::7c) by CWLP123CA0086.outlook.office365.com
 (2603:10a6:401:5b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.23 via Frontend Transport; Fri,
 25 Jul 2025 04:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A3.mail.protection.outlook.com (10.167.16.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Fri, 25 Jul 2025 04:24:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LoBuaYxPqA+0sc4Hx9hRY7m0B7VBv+kwJf0Ym7UlIgIb18V7syIe9iYQBdNAIwI4+TH+yc2JqdWpI4UsEG5kQEUgVrSEBg8lrSrwUT6PZTNCpQm6GQpIU7fltzkDMen962NFE5lJ5QOnw6JkSaKHFFAIVW1XNUHZUGQRn1V9b2CtrC9uDqqJ5f6p0oQlgkxYtd7fjRJsc2qL1hrWdCf/3QMkq8aKPXBKn6x400gSaZq3lowsaugH0NSSu3XTNPjBlCX37GfzqWt3vmqPiAueUPAg8ASuHY4fBNbJG+o0JiSDxzoU1awamxKKrHwWWEQs8v4wyqtHOm6L6NdLvRHwBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ri+AlUbzumRXmwGQEZ3TR64yOWHcH2D40s7UfMATZSA=;
 b=dGKUOAlJ0NjMkXFbbuWtvM1xBf2g11Bt/oYXwGGyH8g/zjL8/6fXnjjR+9PrIW2Z1SxZJixjh6LXaISVjM6VBai1El/5kJ05w/flOJm13KPXgez8A6DcVQffavuNlT7M9jpGkPov2uJ53fAQB3QQDGCRnEUdMfPCIzGZCHiG750Rhz8RzvjJKBTauBhQCjRGvyDWE564FgNFsMDlWbshg75Lqcp6byzIOuE+oMn35vmUNg9J8w5keVKir5xNabSh0bbbgtbKvRlUFtWW7ML6SJEdUmtr0rC0Sgpu7xeOF2nnUY1ufqYPo/94aeFYg8DxDs2dsQw7oBNnTKtRjjqdfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ri+AlUbzumRXmwGQEZ3TR64yOWHcH2D40s7UfMATZSA=;
 b=iNqFX6GnYEsskYeSyeLkwj7vtwVgW9DyfEdvKTx4qvriiu7ppJSBEykPTIr2K3q6lLQktsHFi544eRtF2lCssEfGQY4aRWO7g3p/nbklscOq5eMAVMBNSrfjwfoo8LOLPD2t70XgNPrS8kgvnhzuDya8kMvAOkquFWT67s4Ad3s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by GV2PR08MB10384.eurprd08.prod.outlook.com (2603:10a6:150:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 04:24:04 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 04:24:04 +0000
Message-ID: <b5e98ad1-e09c-47b9-ae3c-22fce4640bba@arm.com>
Date: Fri, 25 Jul 2025 09:53:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] arm64: Enable permission change on arm64 kernel block
 mappings
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, steven.price@arm.com,
 gshan@redhat.com, linux-arm-kernel@lists.infradead.org,
 yang@os.amperecomputing.com, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20250703151441.60325-1-dev.jain@arm.com>
 <aIHsiPtG0Ycm2DTe@arm.com> <b5570f50-8534-444b-8c7d-68d676840eef@arm.com>
 <aIIf8Q7EVsQ5MGOX@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aIIf8Q7EVsQ5MGOX@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:178::13) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|GV2PR08MB10384:EE_|AMS0EPF000001A3:EE_|GV1PR08MB10453:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a7838f-6be2-42d0-f9a4-08ddcb332c00
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eVJrbkN2Z3Q1THBEWHlYU0ZURHg1TjJ4S0tVUExhMmFaSnRFNFBvSGFxaE50?=
 =?utf-8?B?WFZiRzRqeUJJVFM0V3JQeWR6Mnc0SXA1NlNaUkIwY29NcGdNZmJwN1JkaWRo?=
 =?utf-8?B?SmxOUzlGU09SbVVBNWpSc01JblpEMnJ5WEVMaTl6U3ZlS2JQR2gwakdtSUxo?=
 =?utf-8?B?SGx6YlZlVXErL0FNK3R1dTgxcUJtam5TejJRMDBwZmZaOHJQQ3Z5ZGhpK3FV?=
 =?utf-8?B?cE5pbzAwRlNyNFd0SjRXZm9PbXdHMFJzcTB4VEg4U2ppM1B2WXN3TTVkQm5q?=
 =?utf-8?B?ejg1MW5xTXdWb0IxSUp1SnFvSHhZTlRrcm5zTHdmTkJPYUtqVHRwWGNKN3Vp?=
 =?utf-8?B?RngyTVRMRHZ6Mk5YbUJEcnZjOVg5aU85dWNERzIrNm10cHZVV2FSU1JWSHIr?=
 =?utf-8?B?TzNtVU9SOVFrTWhSOTEzSUhuRzgxbTBHanNtOEl3T0NDNFFtSnBYejRHMUpx?=
 =?utf-8?B?QVlrTlc3cTVUS2VlRjU4L1dqb1ZzSGRucHpKNWpIY0VDQjFZbEU5eHVRUTh5?=
 =?utf-8?B?ajh4UDZlQmh3Q0dNSlUrTVc1bHFzV2NQeC9qZXpCNzFFbkNISXJtcmJZT0ZD?=
 =?utf-8?B?YTNzTnlGMnFRVnBOK3BaMHNiN1JOQjExeHdwd0lnTXlaRjNvRXdFTU4xeUh2?=
 =?utf-8?B?a3cvdHlxcFVDdjNUVThRVWEwbDljYlhsYTNUcSt2N0V4UHZoUHF2SFlFeG9T?=
 =?utf-8?B?OEVwSnNoRWwvVEc5eW91RjhYUjZBOVNzcUcyTEhJUjlDS0NwK3I2aXFqMk05?=
 =?utf-8?B?Nk1CbWdwbFRCWjRibFozUDRDZmJFenhsd1ltRGtkY2VSK1ZRVXY1bks3Wkpk?=
 =?utf-8?B?Smo5ZzJPZUlOYWFOcW4raWoyc2MwVXJRL3ozNEVhQzZ3aWJEYmFxVGNSeExY?=
 =?utf-8?B?aUlReW5TUzFJMzN3T2h5dXV4aTNPOXhENm1RRDJ4VlY5MDBNZHBlZWdWQ3Zj?=
 =?utf-8?B?RGhvNTkwREUzUVpPa29hSi90eklEbjNDbXhrVFRSMEtRR04ycTUvTkJJZXQ3?=
 =?utf-8?B?Q1NMYUJKdytyeG1RZHUzbUZCNWM4aVpXOGdVc25WSXNNOEFGZTArSjQ1Y2Nw?=
 =?utf-8?B?cXRuQlNOWWZuT1hFMGV0UTYvTjBTY2pucTdvZEcwQmg4NUJseEJpSFVrNVFJ?=
 =?utf-8?B?OFh4d0RXdFJoSjBWR0lveWxpcE9reWRvNDN3YzE2Q2NYL2tnOG5Na1Nrd2dB?=
 =?utf-8?B?QUM0c2tNc2JvbkxFSkNXNW9RZ2pMSzE5QXVLK2lFZmtMMGUza1BIRTVvdW5l?=
 =?utf-8?B?cU9aWHBoMlFyUEd3amNHNUl2VER5WEdrWTNPUzR6YkhzTHhxb1AyQlQ4YTE3?=
 =?utf-8?B?QmRJMWxhN1JQcmEvb01JZU51dWlPSlptenRuRXVTY1MremFNQWZJV05OVHhJ?=
 =?utf-8?B?Mm1GRk9aQkxrNndUVXJHQndoTXExQ0J2VDl1aGl5cXBjcm1hWElud3hndVQ5?=
 =?utf-8?B?Q2ZOd01sM21IUCtqVmxBMDRaUFhFQ040anpWZG44YXRkWlZJZ0tITVl0SzBy?=
 =?utf-8?B?aSt2YUJjUGMyTEpkSjB1bHBzRzNXSnpNWDBWMXFpTjdaVVlDQnpubGR3aUI2?=
 =?utf-8?B?VUlCaWhxUnNIUkY5MHdLSVI1SUlsVWk2QU96Y3R6akpjRll2aERGOVpXT3Ar?=
 =?utf-8?B?aitxTlJMS3pQQmE2NFZ4TUpQaytPbWY2VmFjemk1UklucWRQbXV3L2NudmxP?=
 =?utf-8?B?Q0lXUTJPbW9Nc1ZiRElGQWlxNk1ESXplV0t3ZlVKTnRNT1FSRmJ1UzZSdkNs?=
 =?utf-8?B?algxaS9jaTkwa1UxcE41RUlkcWZiK21qajNiZm92YUlaNVdHeWtPbHB3ZUVq?=
 =?utf-8?B?Nm5JNHFwTTArMC9SakVUL1h3QjZ5RlZUeU9XQ2dpZ1dSOHJ2Z00wTmlyeDNm?=
 =?utf-8?B?ME5CaG1OS0R1elc3a1ZEa0p0T2Z6OFc0Y0Q3dVdWZTFYMWw3OVBsNHRlRDZj?=
 =?utf-8?Q?Y39i39Uacdg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB10384
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7892facc-64d3-4ae5-9090-08ddcb3316aa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|36860700013|376014|7416014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ym9UYWlmRnZFdytweUdoUzJWZGdrajQ5RmxnSUc3ZDNHQWk4eGd5RjVmM3Ax?=
 =?utf-8?B?dFFudjEycTlHdE1YYWNNQkYzbkg0YzlnUXZvWjJWVEFyNEFDVGVuRTJWLzQ0?=
 =?utf-8?B?bGoxQ0RqRkNlTmF5RlBnanVLNzhCSXBLN01KaG45WVl1SzZ0bnNhV1BGUVNT?=
 =?utf-8?B?VE50SzlkK2RTWWt1a2FvZml2N2Jvd3dmN0txQ1FSWlNLZG9DK3ZMQ3dIdFVI?=
 =?utf-8?B?V0k4K1FWcmV0Q25KcTg2aGZ4UHJNekIzdi83WW5MZlM5aUUwVHhRR0w2VXEr?=
 =?utf-8?B?RDJxYkJ2NDJLVmJIVnZWQjdaNzY4Q2FlL2RjVnZWaDhuQUx1dUZsdWo4SkZx?=
 =?utf-8?B?Mm1yaXhsbXowRnBEeWdIei9mOWJ4bHRKWDBIYklSeTBHdnFpK2hWUitFRXBu?=
 =?utf-8?B?Z2lLMnE0M1ROb25KM09YdmtKMitqN24vc1AzcVp5aHJZMjV0Ymo1NS82U0t1?=
 =?utf-8?B?UmUvZDlKWStuZURrUElPbUhrUUtpK3RTR0NBUnlRdUdkUWR0QWJJN0M4SGlB?=
 =?utf-8?B?eXJjMHl3TjNYdjFnNUJNckswQnp6ZXRPVkF5T1FoTG8rbHN1T295OVk0cFVC?=
 =?utf-8?B?YWk5OEtsR1FLNC8xZFN2R0pZSkQzNm9lVTl3TXZFVEp2R0RpRE5mWUxtYjhp?=
 =?utf-8?B?SGU5Yzl6bVh1K0VTRlp3alVMbWhPNTBvNzdxY1h1RGNsUkxmMWJHblFDUzBn?=
 =?utf-8?B?clB6UFlaQ1BHeTFTdVAveU1IUHZmVHJVTkJFZFVhWVM2VXAyRXFVdjFaa1ZP?=
 =?utf-8?B?MzZCZzJ3T0VVTWYxd3Zod3N1ejhJeVNIUG5kQjB3akF6aXJmcEE5WWI2S0ZV?=
 =?utf-8?B?NTR5OGZYcWVQakpkYkt2SDlQSk9NanVEN0JXMzJpN3c3TzBITXhpcEVWdFFr?=
 =?utf-8?B?ckxsWFRBNFBuTWMzNS9TNTgzOURCaUhUUzlrSXh1T20xM2F2eG1pZm1yeGd3?=
 =?utf-8?B?WEErYlBScDVLL2ZOTnZTdlhFZVZWaHlpR3c1bDRMOVN6VSttOThpR2RrZ2hw?=
 =?utf-8?B?Qk5ObkZBWHREUUlEM3RiK3JBSmxQMmdVeWV3a3BFdVVuYkpGNUE4U1hBODhz?=
 =?utf-8?B?bm16dFljY2ZLL1k5NFd0cTJzNVdyNDlVSmxCczZjYzU2RFJMbDJxaExWbUts?=
 =?utf-8?B?ZDdQejhPUXplL1l4WFJnY2NTYk1KOFl3a0ZvTUY3K0kvS0Fjd3l3b2lSTmw1?=
 =?utf-8?B?N1R1NjAyVGp3UERROS9RalMrZDVHRGN4VnUyRW0xd21YeXFUZTNqVWFpTVFv?=
 =?utf-8?B?MG45NFdSTkwvbDNUOGZrMUhtZzVnbDU1WmI5NzAraEs0NnJHSTEvSXFLMG92?=
 =?utf-8?B?VTBRU2ltUjhTQktIN2plM3ZHQTB5UUdZRVE3L0N2a0hId0dFN2RjeVZ6SC83?=
 =?utf-8?B?aVd4Z0s2WG9pYVA5V1B1cGxkcklSdm1jbnprNXEzK0U3TjlwdGw5UURKcUN5?=
 =?utf-8?B?bzdQNFl1eHlCWUxvcU5WNzhtY0ZYTnJZcDBNR0xZbFF3azZZQ0tzV0tybmRL?=
 =?utf-8?B?ZDRYbVcwTG1RSlRGem1YbnpKbS85MStYVGsvSlRBaUNaem5TOHhJOHVIY3N5?=
 =?utf-8?B?QTd2cWNmT3U5QndZcTE0SVJiTmZGejJxcmdXZzhWZHByc3UzcEhNbFlzYkJm?=
 =?utf-8?B?UmZsM0lMYitpQXE4WmttczJUL2ZaeGs4T05PZm5YTWZFbEFGdzBZMnRIT1BV?=
 =?utf-8?B?NmxZWDhRdEpZZEpmM3Bkb3g5MDVBdkFNbTU4YXRjTVFyVUdjZ3M3UVpqSmxS?=
 =?utf-8?B?Mys4aWhnRy9wdGpzZy9Fb01FbW1leG90eUdSVjcrYWEyNUp4WS8vc3ptQVh3?=
 =?utf-8?B?dGtrWmtpNmt2bkVuUnBmb3NPZnJSZkVHMEd6VWw5bzdtbncxL0xWQjdJckR4?=
 =?utf-8?B?RVlIMUpWeFNYN3JtN1JtMzdNWml3SExhMmswM1FvWUlmRDRTTU5vNnQwc3l0?=
 =?utf-8?B?SS9OR29kUjNKQjVjRWR5QkxZWlIxU2kySTg0YUZwTzFWV0x6a2tJV21ka0dE?=
 =?utf-8?B?MGdEV3RmQmlLc1NvS01SeEtWRnRvcnRIRmpNVVFBeldkaW1YWjFuR1h1TUV0?=
 =?utf-8?Q?osrwVJ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(36860700013)(376014)(7416014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 04:24:39.7631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a7838f-6be2-42d0-f9a4-08ddcb332c00
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10453
X-Stat-Signature: n3z3zt6eutkmkho68u5k8o3iay6a63jw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF61FC0002
X-Rspam-User: 
X-HE-Tag: 1753417485-168940
X-HE-Meta: U2FsdGVkX1+dtWybYQoaHXPgNNQbM3qI70U07L+vO3o9N7xka62DQfGZMey85SPhfz0cQVyT6JBq9Es99e2hUugxoYZfZkU04LIgu7u+9k0dsLeXS+WpzaJApgKyGUkJdmDJ9hwPF8Glr0xF6rrYEAXoYTmwLRJLvva96gPeCrSPbyL5hGVcUtK1TyB3r4Bjqy9uoBblw5TgiWqziy5ZH2GxgBCaI/0NWXCk+9p9Oxua2ev8FfWEDW1vYu+Y9HGy2v+9us0RUI7QL7hJBH8Fx1R9y7A9atr1Ch4L4ustmXm02WOp0O8JpUA3EQ5tfy9td8VFu4AC9K67gAj9HDm7Xtb2Fo9Ti4GO6j0WCMnlbmxqJG6gn5lTx3k3somzAtn7gIph/8mA3ol1Hn7kYoxBxT5Dg+a/1TurzqrIRVtDk+7BFg5zBAoXqhA3z67yiuWIs0KHMUEMZSPLxplhLbr6b58pAd8aKqyE3LblhtsZGPj+ynBu5OaFDO3Yo4e0hnrVqQAaBCMrDJF0xjPYRnQ4ujqHX+N6H/mj37TaWRfkm+XaLuJ8LuQL1Lzrwq3cKHfdyDrKU8R23BpUxZ1YpZTC9D45o2U9PHfBq9C9Psn+/SjziRpHL6c9n2VMWcdR+9cGTE+t00C6pAdm+pAPhhRGsGa/LNvB0f1UlDb6iN4m19b69/SGwGM12EKmg/tQ9Ksb/b2VnfGumEdKt//0VmHB8OkjBN2WjyN12aJ/DLbjjW/JlC8Rmc9yScNrvRswwQNwv+Dfr/4ZI4ZPAu2PnwWk7R5/o1v3Qs9r3PvXjkV346ljbviqHpMKeiAVoTbus0JTdJbF+zx2oIC4ivT4KzVFTBvh74HV0+EPElQ0lpbZfG1GmWPU9PglIJqbuCgIG5RQe269GLM9cwhJBPOo8RVmQlagPmMeRp7Uo05shsXR5J9eXhljxY3TlyLZMmjZWcu5Aa0wHLP/vwgbYMss3Nt
 gUIKc9Ha
 576UZHbEt3WM8MxpMMsELmdLoRxYSmh1Z98qCskulFIPXf6GGVsxwXfD1DZWH6HEfXfxZATJOKMI1u0QQdJU9c7uFyZBKbQpPN0wkR1IPnvM3c0kNffNBDO0QKDgP2tgKyZ3WpGvGVE/ttHuctGdD1iEjHZJZTPx0c4xW6lFyzuaI2vgGfc4k2v1/RGFX2EXkYwexLSLfbMRsRHe1/gh2YE31CSKS3hVmblGm3tHsSw7n3FTx9pMRVIV7US8NUiQ02+qv8cGOAOSw0crIao7ejy6XvJZK4i6Em5Ov+dQX/shLKwHCvWjG9qvGT9nUjETY6p9tBxTcR8pLsl+/F9RxGnomejyp4HHMZFLpiz+ddceK5mrO9WGtYTfRKojhLv766hYVnRjsBHMwoSgkJEztZlsVOCzkdc9A6WHQuH6AECMm0Mf3jiJlLOrpqEOzFzGZCCS53rlU9jT38A0NOqRrFFMYevNT25PhDJO8SD/X+D3uc8J/4Z8DfQhtBgJTk41hsxk9eaF+sJeNjY5HgMlmYn9RQ8yhC26duR92wC/2YcRT71k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/07/25 5:28 pm, Catalin Marinas wrote:
> On Thu, Jul 24, 2025 at 04:10:18PM +0530, Dev Jain wrote:
>> On 24/07/25 1:49 pm, Catalin Marinas wrote:
>>> On Thu, Jul 03, 2025 at 08:44:41PM +0530, Dev Jain wrote:
>>>> arm64 currently changes permissions on vmalloc objects locklessly, via
>>>> apply_to_page_range, whose limitation is to deny changing permissions for
>>>> block mappings. Therefore, we move away to use the generic pagewalk API,
>>>> thus paving the path for enabling huge mappings by default on kernel space
>>>> mappings, thus leading to more efficient TLB usage. However, the API
>>>> currently enforces the init_mm.mmap_lock to be held. To avoid the
>>>> unnecessary bottleneck of the mmap_lock for our usecase, this patch
>>>> extends this generic API to be used locklessly, so as to retain the
>>>> existing behaviour for changing permissions.
>>> Is it really a significant bottleneck if we take the lock? I suspect if
>>> we want to make this generic and allow splitting, we'll need a lock
>>> anyway (though maybe for shorter intervals if we only split the edges).
>> The splitting primitive may or may not require a lock, Ryan and Yang had
>> some discussion on the linear map block mapping thread. I am assuming
>> that since we didn't need a lock in the past, there is no need to take it now,
>> since we are only changing the pagetable walk API being used.
> I vaguely remember Ryan's and Yang's discussion. I'd have to revisit it.
> In the past we were not replacing block/table entries since there was no
> page table splitting. If we are to add some splitting, even at the
> edges, what would prevent some other caller of this API overlapping and
> attempting to do the same split? It's not just vmalloc ranges but the
> linear map as well that's touched by __change_memory_common().

Sorry I wasn't clear enough, what I meant to say was that the locking
will be the concernment of the splitting primitive - once that is done,
update_range_prot() does not need to take the lock.

>

