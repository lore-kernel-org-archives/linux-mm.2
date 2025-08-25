Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE28CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 10:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847748E0010; Mon, 25 Aug 2025 06:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7BB8E0001; Mon, 25 Aug 2025 06:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A328E0010; Mon, 25 Aug 2025 06:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C308E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:52:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 499481DCF30
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:52:33 +0000 (UTC)
X-FDA: 83814966186.25.EB7AE49
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4E83100007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:52:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xmu5G9ee;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zXKMLMg2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756119150; a=rsa-sha256;
	cv=pass;
	b=rzHsl4WHiyl0jutW/hPL2cBDoCq9h2pJUYB3n0I2QNPcCRdp6+PJBUAmeQiKJ7kbITG8h+
	NNRu7qCTbHf46iTfC69QJLR8Rf5b7h3slA9+4PeEf0JyMinAJU5YgYVqskBKDD6VsT8P9/
	i9IIADiVWhNol29tirimQB4NPVQJG9U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xmu5G9ee;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zXKMLMg2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756119150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9iOTg+0S7RFPc2WBiC4EzKn8/BSOyW9joUhbSii/C4=;
	b=xmFIwdO4KL2qOBWXOlozCwDhJLLcNITZXYPCLTQh15PKWu0RzXFatBGQ0w4rLq+pUgl8y4
	LBZXF+rcNz3ioR4D0uEULMEJCIpTiaPuSLF8525pEb7CkOoCPzpP54uU8ze1FlqSQ9/Zty
	CiZ+dPM5WaKhdgaDVBpEjgZf/Sx3WEU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P9gTOh016252;
	Mon, 25 Aug 2025 10:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F9iOTg+0S7RFPc2WBiC4EzKn8/BSOyW9joUhbSii/C4=; b=
	Xmu5G9eeNH9xHGHqNXF3dpIbrndeqMHJS8NE0ggTnP0spd7rmNrfEGdi8vcV0rU3
	XKb2KVzQNHJ04eMKQK5/A9BtIhfcgED9JvEY8rarsysfAut/zksa7E521GyC6Z7o
	Xlow49DPhfbC9Sm4C6s1WNPl9P8N5PMkr0pqc3Z6TI7sGB9pgcb0vMLLoqh85T8x
	4NQdj1YD4xoGJG6j3yu1Zj7tBrhWxko3lINx47Olybji35oaD6aGPdmyXzMKsZPC
	evLWTXaRK9MaxhtWrtskUInEYaRKu/6YvejnsQwOaWu4CFgW5Km8SXpNEtVY/pOF
	60FOCTeuWHi7+p2NmRrrpg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678t03t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 10:52:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57P97P0T005003;
	Mon, 25 Aug 2025 10:52:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj88ak0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 10:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bgeiq5s2AhztOmz8D4UvDxtxpXNVN/gIIwrWOgQ3LWH4PkIvVodE5AOK5gykb1XAsvfMaqcPNeNRC0gq8/4dqw3JtLyFUfzNaY8vxDSnoxvXKYDrXyCzNSFZ6mQvpin0nDMBUybFCVodw/LCIbNU8eljna8tHILBRNfNN5ws930jpDDeUWZ/+/gY7ZAw38rEMaMztXJUvUPQLv+71LQhFFqGnLZbs6tXkXvJhfEEXiXiGMkY7Zs4J9iYvSClRqK7ktbOT59aZzIY+L3RmDE+odIOyrFW0tVZrTW5ETeYg2QPX71tGotXsYrFaDkp95ojqEEumYkanSWF8ZruVjiyYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9iOTg+0S7RFPc2WBiC4EzKn8/BSOyW9joUhbSii/C4=;
 b=Mi+w8wNBRmqJ8VVm24dlq710I7UnDpn7nn7qVaZRFDq5a4P8+FHXl6iaV5p0leY3F3fDu2PmYIhHCL+G8MKBU/U2ofSOwI3paJW6hlwcgKFxoaVWTR2SNMKbxVinX7on0eKTYyLJpdls8fnDRJM97L83mlHd6ngOX7zJklUr6lb+UddaKEx4HTw0SbXJbHtrZI+NTotyEG7YPcn4UM6hnjdww9xXL3OiMxfl9f7WvfFX/FYnRGw+kAUdYTBNJF9tdxgCHawl5iiZBKpi6XUZdtbp3JCZfobryjODHVgL32AieCIFO+xQB4azZ9yORKJEYYGxn8WjlC/krZNFrcdymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9iOTg+0S7RFPc2WBiC4EzKn8/BSOyW9joUhbSii/C4=;
 b=zXKMLMg2YrcukxykPhY3IU8bJngmx0WzxfttQy1Zq4a9dRvVbGOeL0VWOFCdh+73YXiBwcSDGE2jgfMQH0aWf57FMj8xFC1WvEdUNG8d2B6MyigXcO/MXht8z2GgvMrWrQYxW40AsfULGaAo0SZN5CwJRvQVx9gAhJ6smx88Ero=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4240.namprd10.prod.outlook.com (2603:10b6:208:1d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Mon, 25 Aug
 2025 10:52:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 10:52:20 +0000
Date: Mon, 25 Aug 2025 19:52:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <aKxAWqvTxctPoumF@hyeyoo>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com>
 <aKqjWqn8lrITKI7P@hyeyoo>
 <CA+EESO6PFJ9A0kbRWd-ARBLmQ9pwNOF=GBuAzMCOyFvps4euGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO6PFJ9A0kbRWd-ARBLmQ9pwNOF=GBuAzMCOyFvps4euGA@mail.gmail.com>
X-ClientProxiedBy: SEWP216CA0038.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4240:EE_
X-MS-Office365-Filtering-Correlation-Id: 507244af-8d42-43fa-1eb8-08dde3c576db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFc1NDdPdGx3dWx4b0xOSDVpazZYcU44SGtDME9sZU1rbWtxd0Z3ZVNaRGpv?=
 =?utf-8?B?QU5yS1BZN292aytQSzlJV1RQVjlsa0RxOEtXS2QvdUxGS1l1bFV6NmlHRFo1?=
 =?utf-8?B?S0JBVUFiN1ZOYkhOUjhjbGdVU2tvQUc1ZVpGc1FwbnRJSm5KcDZkNk5ybUFx?=
 =?utf-8?B?TXROOHhDM2IzNEJ3QTZqT0k0N3JRV0U1M080RGRUenh0eFd6RkZMYWp5eDhX?=
 =?utf-8?B?N2lPS0VtTGdLZ29LL0UreExjZm90V251YjEvVzllekwrSlBkanZ4dDVpWG84?=
 =?utf-8?B?akFWY0JONUwxeWhONXVNQUtBMTdKWjRFTk95VHNnNjN1TG90eUtzaWNyNkZJ?=
 =?utf-8?B?dVZXZk1NT2hOaGk2ZlAwWEJsUUM5WFhaYWthUUUyVWdwWCt0NEdyYU9sOTZq?=
 =?utf-8?B?bGFLZEFqSnVpZjR1UERMbmJyYlR2c1c3UzJpdExuWHhmQ0tHNmhLNmxkVzR3?=
 =?utf-8?B?MWJERnJ1endGVUpNTU4rRkY5QWZQOFdHcXhFcVJMd3FlSjZGUFRpbUMrY0lS?=
 =?utf-8?B?UXN0NGw2aUxRc3BWUlQ2dUJPbHpySTdZZ3p0QkNkNm1Sb0VrdE1Gc05aeHF6?=
 =?utf-8?B?OFpzeC9nbUZPWER2clQ2UUVaaHpLcEZqV3VVTjhkUkg5aDllQzdoZXlzOUdk?=
 =?utf-8?B?eWVoVWo1b0FwNU1uMXV6cFN6VGVPZUVQeFZTdUNDa3plSUV1T1FDMmk0MkR4?=
 =?utf-8?B?ZldYMnZTR3VMaUxETk56bVJYNmdTWjd3UzF5Mkp1NjVXbDduREtXSnRwUWFC?=
 =?utf-8?B?WHF4a2M2amRwWHFuc3ozMjVZWFJZV2RlRld5RWhadWVRRWhCUXhHWmY0dkdL?=
 =?utf-8?B?dnIzV3hVay9SVXQ0eEFUY3ZMT3F6UWV4T290Y1RhU09PTE10M0llaTJPd1Rx?=
 =?utf-8?B?bUNnemxzeURKdHRTeWhuUjNCUGlvVHZUZ1dGVFJEVmVCSW1JRmFsTVJSWEo5?=
 =?utf-8?B?K000RWMyNW10YXpkdmNZRHdDTUJReHpCQWZUYSswMlBSL1p0VmxXNHFheFl2?=
 =?utf-8?B?SG9xY2tzNHNWMWZqZWRCczlCc0dWM3BIdFVEOVd2UVJBNkVvYkhYQ2Vic1Ru?=
 =?utf-8?B?eUJXeUFPcDEzcVhvbnZlWlF2TlU3MGtrUmtUMjZERlNiTUMySE1UdXJjNHBI?=
 =?utf-8?B?NXZ4Sm83Q2NpMDl0UzNCWHprNUZMSWFFV1pFUlFBZEZpS2xtSWFYUUQxK3Rx?=
 =?utf-8?B?N2srMHhuMDZvdnNtMFJzY29qaDQxeTN3VEREOGo3ayt3aC9LWEhqTlBMS09F?=
 =?utf-8?B?cytxcDQyWGh6d2hHTW1MYUNzV0R4N055b1hmZ2VRRXBIQ3U3VGE4NmVzb2Iw?=
 =?utf-8?B?bWFzdmR6NzY2dW45Z05UUnFDUTluT09vT3ZEQ2tCNEhuc3ZpbVVHV3ptb28z?=
 =?utf-8?B?aUVoZ1NvNG8vMWQ3YmNmMDBlNnRyUzI2NHBqQ1pZekJJcll3UW0yMkUyV1VM?=
 =?utf-8?B?VEkzVUoxYkY1ZWZtZVNKa0djaXZVR1A1YUFTSGVETmEzZzVCRHA1R1YyNk1V?=
 =?utf-8?B?aHQ5ZTArMFhEMUYwQnRwczRoajEzSDYybXNnTmVkaE85c3hMcDNQVEczNDJx?=
 =?utf-8?B?d0xXaGRpWUhvcThqcGwrR0VzdmhadDRKK0FlTXhsOXp1YkRxNlR6NkFBMW9C?=
 =?utf-8?B?ZENYRDM1WFBFZVZlUGRBczVKT1NmYWxqV0NpMGplVjFuVlE4OGUzNGkwblNZ?=
 =?utf-8?B?Nm9uZGZlRW1HUUxBbFl5WGZRN1dqOEgrTy9jTzBoZUREOVg0bUpCejNrVTNP?=
 =?utf-8?B?bGE3YXFtUEkyUzgyeDVBMG8yNGZGTEtuRDZJS1A2UER5a21KbHRJc3J0ZHJQ?=
 =?utf-8?B?c2R2dDlYM0NDYmFyRFlxNzd5dklYbnNsZ05XVkJzb1BHQ2RtcDlnbHZvR0VQ?=
 =?utf-8?B?SkFuMGlLdzB5NUtNTGRrd2VuZmxNRHRneU9LNFV2WkF5UzF1MFlCTHFEMWR1?=
 =?utf-8?Q?uE1raLle4cA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1dXMzNjNE12azVZbThZZVpNQ0ZlRmNuOVZyOU0rdWgrOW04WjNldzc4VHMz?=
 =?utf-8?B?TnpTQ1VWaUFPUlNJR25QbTdBS2xYYzFTd0d1Nmp0Q3Y5NDZyWGNOOXg5V09o?=
 =?utf-8?B?KzFWTFprL0Voak0rL0FHc2hmaU1VbStSRTVwMFpQbG1kcGVremE3T21rd3N5?=
 =?utf-8?B?a0k4ZTBSL21Jd3B4aU1uVXdHdEZwTHF1Z1NiQUdHTjJGdjB6RmlJbGJUdXIw?=
 =?utf-8?B?SkF6VTlYaXNDSXZkYW5Ud0FIYlNNd3Y0M2RnSUJ5Qk9NRVpKWXVSQnBnMEp0?=
 =?utf-8?B?VEZEV2xVTVZwUnprc1VvVDFjUmRMOWhLZFZNaTdxVkdzNkx6bDIySlZHTUI2?=
 =?utf-8?B?d2pEMzJVQk41M1pqampKOHZrZlVCcitMbVNUTzdtelhHTmgrV1ozNWFVVHZS?=
 =?utf-8?B?bzVvdVRTUSt2SWRtOHc0THRBZTd4dGo4UUhuUGd3RWltc0lyVnVWSGFFZ0pK?=
 =?utf-8?B?NHd5aU1FYllCRW5odzRGNW1rWGdvUE9lSjBNcjVUWnNobEhCZ2l2M3NXV0xa?=
 =?utf-8?B?NlJkNkEyNHFzY1JtbUhLQ005UUhuOWtnQ0pQSTFGdFIvZTJHMjZZdndFbjBn?=
 =?utf-8?B?VnprK0xDTm9DZDgyY0ZELzM1djdPUGJYejJKNEZxeW1vczlCVklpd201WVIw?=
 =?utf-8?B?RXd4Y3d6Wm5GWnBKdVhqZVh4clBySWxhT2ZlM1Q5aFZFZEdhZEo2dXVFYlI0?=
 =?utf-8?B?M1d3ZkZUSzJ2NlVNV0FtNHU4Tit4Q3pZNDgyZ21yL0pERDJpLzQ1QlRmMk5D?=
 =?utf-8?B?Q2doNjBXemJvVDhrMXY1OGd2V2VJelVPSjlPRC9wdTBoeVFOWS9hcTFnSVV3?=
 =?utf-8?B?aHIwdmlrK0tpMjZJa0FTUk5YUWJUZGI4NFlMcHlWZzdaYWtpa1BjYzBOaEdC?=
 =?utf-8?B?MFp6REdHRGNFZzlSV2F6Q0c1R2lpeXBjV1hsazZLNUhCWk5aVGtFTlZMWEtz?=
 =?utf-8?B?a0ZDMlhnc2UyQTdFdHRVTVI0bkZvUWZ4MW1yQWF3QTRSYmtEclFKM0JueVU0?=
 =?utf-8?B?aHdyUU0xRHB1cDl0cFJHVGxGN001VHZLd05sMjh2YVJqajVVVDdramdScHpt?=
 =?utf-8?B?clBiSis4T0ZkOGVVbi84SlIxQW56YURzZG53Z281RWVMSzR6ZGp6dFIzdmVO?=
 =?utf-8?B?ZTFhQVBXcVdFcE1YTExuRzdwVzJHakY0VFNTcmRuZC9wb2V4R2xTVzA3Lzdv?=
 =?utf-8?B?amxaWUFqM0ErUnQ4RkFVaVllWlZSeHF2S0k2T3QyTWdMU2FRY01yanlJdzBo?=
 =?utf-8?B?cjN5alorQ3BvZ09NUFpib0xEcTI0c2dyU3Zxb1NrMDVGaTd5VUxHYXloenBv?=
 =?utf-8?B?cFJ6SXd2YkRleXR2RW1QS3RKc1VidFZwVnYrSlRoSnQ4R2ZhZjhuUkxOazly?=
 =?utf-8?B?aHQ5dXY2NW54K2RWdXBwTDdldXJnS1R5N3hUdkdOQktia0FuQTJhRFJsTEpK?=
 =?utf-8?B?dm5Xb2dDS2pkNXNjNXNwUlF2TEJTVjBuc1EvbUpHZUlkWGNHVWMwTm02Rnor?=
 =?utf-8?B?OGJuRmE2QzNzYjFHNjhmVVd0Y2JTZWl0NVZCS2J3ZGdoYnQ0MlExMkVScUNB?=
 =?utf-8?B?Y25BR2pseHI0R2c3cWFINTZXZjdXSTVkVmpiMG5ZbE9VZWFDNXU4RFlqYUdZ?=
 =?utf-8?B?ZmdCWmxjVTVzV09FN3U3SFZlVldud3k1WHl4NEEzbkVMNitleDUwWlN6V1A2?=
 =?utf-8?B?WkQ4eG9aeTFoT3VBTHZDaWxmVXNWOE1BL0g3a3BDbjVlWDgvTEFTdDBRZzEx?=
 =?utf-8?B?RGgyY1JkWlZtQ1ZlMDNIZHNzWmZNM0JzV3pkUjlhZkQ2UVV2SGhtOWgzZXl5?=
 =?utf-8?B?bUVRbnN6NFpZdkpUQ2ZOVURkOFdYUCszT0EzRWtzcmxKWjVpT2lBZzBBNnJG?=
 =?utf-8?B?U0ZtMXBFYzhiUVMvaERpdlFXTEJaWC9iVzk3bVdMQmRIbEF5N2RmRUdIb3NH?=
 =?utf-8?B?QnNvMFdwNENFWWtIK0lMeFkwUlhRYTRKb3h6b25BVytvb3o3NmxVRnN4ekVr?=
 =?utf-8?B?WlA4N25zZGJoTEliMStSVytGY0dobzQ4clRxR04wMUFaM3RFTjVkM0F5UVRJ?=
 =?utf-8?B?M3dFY0xrNC9FVHJCWkxxY045OEtwS2pkb3FDcVhpL1FVbDloeUFjUElOZ0Rv?=
 =?utf-8?Q?Uswf2FDJoHIF6HLsht2+SJy4N?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hhC7RuyFxwXF0PCZxhIW5g/v3g7yePHlCj0PG3vH286M2u2Tn7rxU8i+UxoSXRgHIweCp/yCQeIoJzR87iUw48yLlBo80PYN0JQ7Vo3iwC9pFRhid1A+AQUzv4clmtBCclry4nhGaYQ8HgW+KsWhyKv0+2X5XG6OZPxIb3Lw/yk8/XOBXZhcARcZXQKcEZS8sK/84bl1KSw5n/UEppfkZ4PAmUFB3N4PMNq2P1eV5/g5NfTXh4vg+enWiRksg8EmMooBwXbEF3MhGvTO3DN//VAqN1fK50USWiUyQ23GCJAPlXy6S0HCQYhwgYyBfsAr0QkaIPgT+RFDNd5GPI3sYxqnwFF2akF3Ph41IegebcorkUWMFQecmEHIeiUlvoPcqeYnqm9oTfhnilapFHA73JZWtgI+EDRIvhu4WbCz4RvlS2TeuVcFDEyKP8IfBi7AnbxNJz7iMOGSWxY1LjxXSPvpBfyD05oJFoJ17CvO6l7wYjVV1SRRGf3dpsnZsWrLQ7bfWXrfkUyeFC8mwUQuB+f+rNu0SqfvHPX01LrXIr/e5XAMfR9zmQmTsRmQySWwroJ8yBAGm5iDdMps98gWhLyqDPIg0q9D1EhJwIZkp3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507244af-8d42-43fa-1eb8-08dde3c576db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 10:52:20.0804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIjthjMBYpJQXjpP47XUpEKJWPCWW1GiAl4oRKAhtph9uvE+krdDaYHykHEQxE/XFF+K5m2imKHr9Unb6vBCkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_05,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508250097
X-Proofpoint-GUID: N1knzQuSXVGTU_Y62-rQmEoAXNKiZUQI
X-Proofpoint-ORIG-GUID: N1knzQuSXVGTU_Y62-rQmEoAXNKiZUQI
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68ac4069 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=Pp3I1Z9nklXDFLRVzuIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX8xshuq5LMFXp
 D8HcS4xg0WsgM0wDlQePh2zDvimgdugMp60BCG/qTNQe7N6gy1MPD8CznxTYu+VbcsV06zFA+MZ
 iVKgt1TCqET+s11s+u5D6Ulrp/GaUozrxAzvPRtSDeNNjB0WKwhN97lyQTWSLK53qMShNRTbviC
 fX/ce9PkN/mKE5FX3Y6tEdRk8yucrdnxIt543vMcuLjYvLwIsBfQZNn+b6Lgo9gfVzQmpLupRiY
 hzvJ+ftaij77V2KV9y6vEtbHJLHB9GhRWA3cpzB/EZVXZgjeHiPlVMZG+Joaf5KG1WPRpuiZ4Ac
 doJL+1wYwXQAXa2ROadw+7F1W/AJav/+ZS94qaeDhX2JMEXCyIq7916Wt2zzFyPK2NJ0m+wnqgU
 O1is7ahZaH47du+oXgfqvlxT4qEyRA==
X-Rspamd-Queue-Id: C4E83100007
X-Stat-Signature: ir3uqzdu1ao8ubh4zmp9b38xk1xnerb5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756119149-632785
X-HE-Meta: U2FsdGVkX19BEerislvXMBmM6dQ2HgP8vt6e41lKQZKu+K1IY4zzeSD4nvKJ3yuxAbZVM/hiYnFODBUUvGe8Hv0DBw/GfrMu86tgXioAMtuCcbqDp3w0EZP54YxtwFSDYg9yTy4eZh8pfK7o6y0swO3UzfsC3ezFNew9Hv47mIRq9EqZjN0wUl82/4aeDAP9Hf9TNEwLDbkk3YckNOi0YqkwocauBy0EEm8He6OZ896LZ4BM8fp4K2JSW3Ze8EdjCCs3qyqAploVcGdnv7sH+z2Ili8ijOeKaUL5DwByK0Lin/WpC0u4EK4NoTOUAUDwbFPapbxt4xfiiyH/JMYaBNmQ3+zRFvM/x6Q5HkECtXP7RGeKzXJWfypgHPDWfeL9hsbFuBM1rhJv/3NzQnlYeveQInoo0g2JGEmBqBD/ceEMNTnvGBTnru/LK+riqQbX1z1BY3Om6UdAPStABetRuRjgHgwHA0S5q36fHiQPguZDteZ96Ly7k+R72qnlIjoKpShDa9iH4QgQqi1cFqMqwzI+DcJPJuy7WNGClstaS7oQ4tt6mZLaVMZ7l5M3PhmjQeIjiQXlfyLRwkPStkoQj9i5EslfTQ88UGCw04RTb+zYlKzUO5DztmKagCSNv9eLGFo6y6Gh7zOjcJqzWf1amFkyUkiBWBRKw/cV2Ub8AIpYwYFuSl4veaYO0QwszTdrEpQ4XN/d+vWCacxIbfuODuqG5K7llwf45up7tfJoPfiAxLL4+k2aSAjcFScDbPeUmbXS0F+dl+NgdFU13ORB5kOdSOzBVAaY0+EZ3rK5trJCKqAfhFXSuBRt6n+v7V1iwX1TK1okfE8sqEhkFplqM3M0ahTAgvSCJiOsYIoT0LihQhJEjgCoFaHfYTkJNC/T/OBHT9bfHMgpj8XFGhfj2hwHlw6Ht+V5Z8B1FE+jJ27bYw2sIPiA57cTKCz2HXuvt0shtlb+G25FKTBaIQ2
 xV698Sz3
 2vjaL7EviwQ6KZCWfVKp2ks+nsGVt0vEBjDNHg3TziqVAcRLi/m9TF1XG6J3Q4J27fjNRTKvXYiF7xyQe0t0/ioUxR6dI3fVLbIgvco+BkyGDeuoBfODcdrJtd92OyGZ0xv8R9UJUwE8r++WT7qhV60fpzG+jWu4hNterPy1qSAMZMezq84CitQVpJ6KNjCMqxWJJz2HiRvi9SZHsqo7RCrKwvqFg/IUlqarGTsUhw4nwrtXSwfbBv9cboTfGWoQh7aVCDu1vIG38U84A9BQYV+rFWnu2JoYAssGCDXEkoB5DmJ9UUmcEhfDQB/tpVo111J/gqaDdNeHEvKbHhC0pe8jEXlqJvLo+dk8cO+gI9U+JYRCAaNqYAqWwLGBppLslSJmtl31odRGFZb1zmlxjrGQUwW6U0yxa3HwXyhGyV6plNPN4yXqumWFyNDcFr8RG4Wudjx0nOu+46DUd9gEbyxpERjzlUTNuyGH2KN2yhfMaJ+DHJ1wgRH7HBVBr7j3t9iuzxEzk4CIlFpjlLnONXgAsXyTG2oE8TXSOPSEqFYnbNnHdDsYRe3on2FMmx25mUgko6emL6yx/RM1qzSNALR/6wAnOGtBYo+BcKXxfy/2Z0PK7IJUD3C4wMTJC1sLWt+3L7pOb6fQSUQk7uAWs7RnqXSDk7dFwEhfFqIf3qscXG1Kr0TyYSdGoFs5JlryL3blVc7WXgxOGkcQZKIytheexIerNXmJaj3Jy/W8qmlxzWEn0793+9fVLkkbFWz6lSGD0OswGcOoTZNPKLwsBsIoSKnpPjkVyrhKTV3S79MXXpsJJVdmzondlCwJfvA3raqFaQ/jXURwMSPeCcJBHmYc0SO+UqC0GmJZd1u93VD4sCBbK6lLqdli866QikvXSOVuZun87M5PsZHYe4aWZuQUswXmIOJxvgPEz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 11:45:03PM -0700, Lokesh Gidra wrote:
> On Sat, Aug 23, 2025 at 10:31 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > On Sat, Aug 23, 2025 at 09:18:11PM -0700, Lokesh Gidra wrote:
> > > On Fri, Aug 22, 2025 at 10:29 AM Lokesh Gidra <lokeshgidra@google.com> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > > > non-ksm anon folios. This necessitates serialization through anon_vma
> > > > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > > > involved in rmap_walk()) are to be updated. This hurts scalability due
> > > > to coarse granularity of the lock. For instance, when multiple threads
> > > > invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> > > > from the same src VMA, they all contend for the corresponding
> > > > anon_vma’s lock. Field traces for arm64 android devices reveal over
> > > > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > > > user interactions.
> > > >
> > > > Among all rmap_walk() callers that don’t lock anon folios,
> > > > folio_referenced() is the most critical (others are
> > > > page_idle_clear_pte_refs(), damon_folio_young(), and
> > > > damon_folio_mkold()). The relevant code in folio_referenced() is:
> > > >
> > > > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> > > >         we_locked = folio_trylock(folio);
> > > >         if (!we_locked)
> > > >                 return 1;
> > > > }
> > > >
> > > > It’s unclear why locking anon_vma exclusively (when updating
> > > > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > > > with folio locked. It’s in the reclaim path, so should not be a
> > > > critical path that necessitates some special treatment, unless I’m
> > > > missing something.
> > > >
> > > > Therefore, I propose simplifying the locking mechanism by ensuring the
> > > > folio is locked before calling rmap_walk(). This helps avoid locking
> > > > anon_vma when updating folio->mapping, which, for instance, will help
> > > > eliminate the uninterruptible sleep observed in the field traces
> > > > mentioned earlier. Furthermore, it enables us to simplify the code in
> > > > folio_lock_anon_vma_read() by removing the re-check to ensure that the
> > > > field hasn’t changed under us.
> > > Hi Harry,
> > >
> > > Your comment [1] in the other thread was quite useful and also needed
> > > to be responded to. So bringing it here for continuing discussion.
> >
> > Hi Lokesh,
> >
> > Here I'm quoting my previous comment for discussion. I should have done it
> > earlier but you know, it was Friday night in Korea :)
> 
> No problem at all. :)
> >
> > My previous comment was:
> >   Simply acquiring the folio lock instead of anon_vma lock isn't enough
> >   1) because the kernel can't stablize anon_vma without anon_vma lock
> >   (an anon_vma cannot be freed while someone's holding anon_vma lock,
> >   see anon_vma_free()).
> >
> >   2) without anon_vma lock the kernel can't reliably unmap folios because
> >   they can be mapped to other processes (by fork()) while the kernel is
> >   iterating list of VMAs that can possibly map the folio. fork() doens't
> >   and shouldn't acquire folio lock.
> >
> >   3) Holding anon_vma lock also prevents anon_vma_chains from
> >      being freed while holding the lock.
> >
> >   [Are there more things to worry about that I missed?
> >    Please add them if so]
> >
> >   Any idea to relax locking requirements while addressing these
> >   requirements?
> >
> >   If some users don't care about missing some PTE A bits due to race
> >   against fork() (perhaps folio_referenced()?), a crazy idea might be to
> >   RCU-protect anon_vma_chains (but then we need to check if the VMA is
> >   still alive) and use refcount to stablize anon_vmas?
> >
> > > It seems from your comment that you misunderstood my proposal. I am
> > > not suggesting replacing anon_vma lock with folio lock during rmap
> > > walk. Clearly, it is essential for all the reasons that you
> > > enumerated. My proposal is to lock anon folios during rmap_walk(),
> > > like file and KSM folios.
> >
> > Still not sure if I follow your proposal. Let's clarify a little bit.
> >
> > As anon_vma lock is reader-writer semaphore, maybe you're saying
> > 1) readers should acquire both folio lock and anon_vma lock, and
> >
> > > This helps in improving scalability (and also simplifying code in
> > > folio_lock_anon_vma_read()) as then we can serialize on folio lock
> > > instead of anon_vma lock when moving the folio to a different root
> > > anon_vma in folio_move_anon_rmap() [2].
> >
> > 2) some of existing writers (e.g., move_pages_pte() in mm/userfaultfd.c)
> >    simply update folio->index and folio->mapping, and they should be able
> >    to run in parallel if they're not updating the same folio,
> >    by taking folio lock and avoiding anon_vma lock?
> 
> Yes, that's exactly what I am hoping to achieve.

I think technically that should work. I can't think of a way this could
go wrong (Or maybe I just lack imagination :/ ).

Adding folio_lock/unlock in folio_referenced() is likely to affect
reclamation performance. How bad is it? I don't know, need data.

And adding cost only for the uffd case might not be justifiable...

> > I see a comment in move_pages_pte():
> > /*
> >  * folio_referenced walks the anon_vma chain
> >  * without the folio lock. Serialize against it with
> >  * the anon_vma lock, the folio lock is not enough.
> >  */
> >
> > > [1] https://lore.kernel.org/all/aKhIL3OguViS9myH@hyeyoo
> > > [2] https://lore.kernel.org/all/e5d41fbe-a91b-9491-7b93-733f67e75a54@redhat.com
> > > > > > Thanks,
> > > > Lokesh

-- 
Cheers,
Harry / Hyeonggon

