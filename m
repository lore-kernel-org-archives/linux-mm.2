Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A21CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 21:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DBA8E000C; Mon,  8 Sep 2025 17:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825518E0001; Mon,  8 Sep 2025 17:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED648E000C; Mon,  8 Sep 2025 17:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA4E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:15:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DD6F13A611
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:15:10 +0000 (UTC)
X-FDA: 83867338380.25.022CA54
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1DAA2C0004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:15:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kxCDqt1k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c1WWIZYu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757366106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xDHIwyikb6yY+WYx+w42Fp6tffwQZNaYSmEQW0N/Hw=;
	b=FW3KbkGQ+M91aURSlhWdfyVJpHPu6nf805q7HtZMEwd2TMURy8WA2+hvNSZNzgCmyoauZl
	kaqqh9isDvlJOSY3RUcrurf9BD7qbW09lqufNd2lvkkth5y5BlJG7U5FpvmXP7yJ3Xjsmd
	ZG0syy4yZGjUv1PmFQlGFkFISnrP6R4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757366106; a=rsa-sha256;
	cv=pass;
	b=gkxSYWy4omQoZo1M9hwl2DqKT/u/R50ZrwnqtlNF5JSwQd7JUHELxbcMsTSNHFbT/W32Z3
	c5Hcdp5DwxFDEEWyhmiSy384r7GWVu9azpJljDrFu6A1tCz0R9/uuQgJuuxIS9nU1BEp8R
	uP8tdPkI9t2nrKol+Kx45Je6UUqYfCg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kxCDqt1k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c1WWIZYu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LCDrR022861;
	Mon, 8 Sep 2025 21:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6xDHIwyikb6yY+WYx+w42Fp6tffwQZNaYSmEQW0N/Hw=; b=
	kxCDqt1kMbjy82o+Hi4h13h5SQlMKrjcuIR+9eoJZ+T2FQb1PPddRnPytvX5Wgmh
	XBbRbBMdetaY/BTGpb7Et0lAE11pqUyJsJLUptjWyq5kFfH0SAl3AcC82yVPagkh
	4fagX0GreNNISeC2kLEcslldDO1KpfJz7GDPGObIiVstOzwtRjxP2ZSeNTNyN0qx
	F/4K829oONx+Yl27N3+GAwk4mW5ZPN/aEVllWPSkZ+5rwGBvIJ+pm9fdmJYJlzFA
	vbJapHM7CtbjTqhM3M+zzPYOxw78uFjc+pLBDR3jHD1u6dR1DDMwJzNLMSoY5hRw
	jZsZUYOQpPX8bYIBc/aj3Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1gqc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 21:14:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588L4POT025910;
	Mon, 8 Sep 2025 21:14:29 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8r9qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 21:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nrP2S84ixpt6UgZc8NnhC+i8tcUFEKFXHsP/c50Pk8RqxlAQpszJRn+ivT+LhfARC1D1GljOCN/V+gtWO5PZlreVyBtZ4PjkUN7Qy3USuEaselqeen6QRvxQGgvmo8fLS3b387c/1Y5yx6wRo0oj6LN2ALUFhzOkLwbaSxfbE+ZDchAQs4soo0cH3+0MunEnQPRevNiS/v6KHfAKvRb+JALZcZS96FoS13/gb0LmFFeEHR3T4h3PTUV5I0KDAXiXpaoIrwBT1AoAWIDA42K7wePkaA/DqQDuahpZ17nKFauLvXGvra9bg8t9ABcliH8Pc/pIVB3z/Dvgu2gATLk5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xDHIwyikb6yY+WYx+w42Fp6tffwQZNaYSmEQW0N/Hw=;
 b=tG8RZVkQ1RKNonUcsbpZJN6HpZEUoMnkXo88CWTXxSXzv9OB53hDMRtS1RgI91FA6fhLoicf47HmrqZEcxbxlawpXTFbsomkbhq4AaQsKEgtd4wXjpuclAISm+fAJF98XR6WO6xXrolnY695ek7aG/USUWnmmpDqx6ZLRRUitSc2bn3k50Mk1b+Uw4DHRqIG50ZRwbfWuTj89LXAvXHkKj0VsRmtgAO5/uesC/wb9fStHdYf+J1lh2aHxOl5z4lMNP4IViKU+2zU6d/6e8E6gACVr93HrQfLDV9uCQBmnmhMIgX4tyCMaNlL+BJD92eBav/2rKQvFZ8ZnL0MEYKbEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xDHIwyikb6yY+WYx+w42Fp6tffwQZNaYSmEQW0N/Hw=;
 b=c1WWIZYu3BlIj6sOD94R/meGah4OwK28vgAIuVHpIPy1kpub26OhIqDk2xFdyB567r4/kQDqyM2rY0ZCqSLSOPsvs6+CoKZ2Iqo8WXJxxAX8A6wGeX2DmEjizXhDFfZnFiXtJV8DlG73qgXKXFqL0ud/gMfh156D1u6W3cgz8FY=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 21:14:25 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::41fa:92d3:28b9:2a15]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::41fa:92d3:28b9:2a15%5]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 21:14:25 +0000
Message-ID: <bff57a63-4383-4890-8c68-8778b3a75571@oracle.com>
Date: Mon, 8 Sep 2025 14:14:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, andreyknvl@gmail.com,
        arnd@arndb.de, bp@alien8.de, brauner@kernel.org, bsegall@google.com,
        corbet@lwn.net, dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
        ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
        jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
        liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, x86@kernel.org,
        xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <5b7e71e8-4e31-4699-b656-c35dce678a80@redhat.com>
 <aL9DsGR8KimEQ44H@casper.infradead.org>
Content-Language: en-US
From: Anthony Yznaga <anthony.yznaga@oracle.com>
In-Reply-To: <aL9DsGR8KimEQ44H@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::19) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 574cef76-31dd-4929-df83-08ddef1cb00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnRnVUF2bnJLQVlrTHB1MWVaSjJqdXpHMW50RE53WG9uRjZYUWtXNWNPWE91?=
 =?utf-8?B?MWxhVWNWOEk1c1lKTHB2bm41b0dKZjFuR3lGVDBPSlRFaU10VDQ0eWZ4VzFV?=
 =?utf-8?B?bDUyUFI2aUx5Vzc4YU9TeG80TWovOUg2eE1OTllmaDNzOUtDOTBES2Y1eFh4?=
 =?utf-8?B?eDN6VHpuZkJYbkZNbTh3NE9OSEl2ZW5aeUUrSzB0U1FYSFl4VXBLYVBEM2lD?=
 =?utf-8?B?ei9nWXM0VnZYNkpSVU1PZnMvVmhFUFNCWitZelFIZkEzM1U2T1E4Qk93UnlT?=
 =?utf-8?B?VEppUHlxZCswdlNjMXRDRmhUWGNrbmNKdlI1WnJPRFRJNHgvMC9iT081QTRI?=
 =?utf-8?B?YUZlWXNmSENVb3N3UEdQWDNHcDJlR3lNb0xMbjhlOGI3c0h2WHFqSitmQnJl?=
 =?utf-8?B?V2hFWm8xZnFHYzVpUTFJMDFOOTJ2a0hqTUxMTlA3MnM0QjZDUEtGRkJFMU9p?=
 =?utf-8?B?dEFSeU12OFR4YUxZcEJNdGkyOHFBL3BwYXRJZ2w3amhRNXJBVzl4bjdRTTd0?=
 =?utf-8?B?YjY4QnZvNDlyN2h1SDhRNitIWWpySkc5REM0UUNodHdjVXdnSU5sdHM0UjJ3?=
 =?utf-8?B?MmVoZlJ4S1VwVGVCQU9vNkRDWDY1MFRuMU5XZ2hIRVpvbEZZRE5OVjJWaHBw?=
 =?utf-8?B?Y3V3WVhRTm5XL1hEaE9tbW9tZm1YaHpPdEk1cEZENmJRTVF5bTNqTEFPd3dx?=
 =?utf-8?B?eHZEU0huY3RHWjJTRkNMc1RDRGJtdGYyOEZNKzk2VTVVRk04aklVbG95Y2E3?=
 =?utf-8?B?Z2dhUEdpUGpwbXJQRkY5aE5sbUZTOTNzY1RSaVFHaE54cGszWi9SYkRGU0VM?=
 =?utf-8?B?dTEvVFpJK0ZhL0ZLa212Zk8wSHRxRWVlYXZRWFVWbXpIYW1veDNRQ1lJU0hG?=
 =?utf-8?B?THlYQzhvNHFkdzYzWXBBMGxBSnZHN1NiNzU3VU1uRmdCWWxuUGN2MVkybklY?=
 =?utf-8?B?Wkx0M3NtcEF1V0s4aGtrS1h0QitQYzZYNVlmYS95blp4VGwyVmsrZUJqQ1Nz?=
 =?utf-8?B?SmExTlNjSXRxR1lMbUhGK2hzR00zSzZsa2ZFcDErYXEreU96ZENoWXV2WUxL?=
 =?utf-8?B?dGtZNlNOQ01CRUROdUQ1SVdtV2ZiT3IrSVJFSnNNNUNBTCtYZHpIMHBPOGRU?=
 =?utf-8?B?dW5kOElrS1pNbDMwN2FReUg2aC9zdHZqbEtJeUwwRkIyQjIycTUzTTk2WDR5?=
 =?utf-8?B?bEdtdnR1VkRGSVhvTWdHTnZtVFFVTmlEOG1zQS9OTGRENmlwMnJLV253K1pI?=
 =?utf-8?B?d1RJQTdwMGNKcjVaU29GRGl4aWRNQS9RemdoNTlWT01IeUZuWjY5NndVYTJ3?=
 =?utf-8?B?bWJuaGd3U0pLYTFUVVVEQXQ4VTFyakRCVUJBZ3RJc2pMcS8wREFmQ0prMUNj?=
 =?utf-8?B?ZlFDTVErOWJlWE1qaEM0Q2wyQlBqVTlVZmNhb2RJcjFWREx1YUJEMFJ4Vjd4?=
 =?utf-8?B?djJEeHNwSmtCL2tqU1lWKy91ZWlBN05CREJJTU0xQVQ4YXNoRzdSOFRaY1c0?=
 =?utf-8?B?d3NmaEVXZ3hTQXdJVStxUmkwODBUU28vUXpNUWtpSFRsTXlHRUdCVHg3a2JZ?=
 =?utf-8?B?SVpOU3EwVUNyeUJEeUJqdHl6dW5tL1lISFpVTGp4SmQySFZzeENpaC9kYWhV?=
 =?utf-8?B?Z0pHYXdvcGM2SUNTZU92clNvaXBDeGgzWlFxNCtiSzdTdkhWWWlDUHY2aE4x?=
 =?utf-8?B?bTZwcnd0V0dDUmZHNXBrWENjTTc4WnhsNkF6THJWb3dJaUpCSU9zU3NscWt6?=
 =?utf-8?B?cFJPOWM0SjdMSnZvSC9OZTlrZE5tLzE4eWR0Yi84NUVkZ2MwS0hRM0pXVWRS?=
 =?utf-8?B?NUt5NDZuR1NuVjJVdytsQncwdVgrSHROKzBoNmI5dUduU2lUekc1aEZUN0Z6?=
 =?utf-8?B?L2lralNmN3pRdDg3ZTgySEpvVmFmTEdWaFAzS3FueURiUzYrdzVzckg4MzA2?=
 =?utf-8?Q?jo/BkSIP2nA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWE2YlhFRFNWRmRzSWt6MnREVFRDaGRoK29pdWZJbGxCL0I5enFVRG04NW1J?=
 =?utf-8?B?aWxqMDlZU0NGQkEvekJHQmJaUVEyajBCUUE2NjAvNlFSaitHZHlobDdJZzUy?=
 =?utf-8?B?RFpIT2MxOGUwUnV4UkRWNGc5czYrWFcyWjc0QlJlQXBsRlNLMjNVdkkyR1E1?=
 =?utf-8?B?SE1tSFI0STJyK0pIeEl5bHFTYlAzdWlsL25KY3FMZk1STkhLQzZaUFVSTUNw?=
 =?utf-8?B?T3JpUFB3OGpCQ2pjbTUzelJmZGJWRkRNSFNRUXM2TG5jeFY1RFY4Ukk1YmNL?=
 =?utf-8?B?SjhhRjV6VTlEakdCSVQ2V3pQNklWSGwvT28yVytCUGtYQmxKZEVwWDZoUkR0?=
 =?utf-8?B?bW16SU1meHVrWE12OEpZdU5DUisxY2gvSWJGenRLak55SFBsamNEVFNwSmNR?=
 =?utf-8?B?R1YxWFppMjQvazUrNEF2K3gyWkhKb0dJU1oyOTJEOXBSN2dGQkEyS3RkR29k?=
 =?utf-8?B?dFhDbFFoZ05QdDFZM0FBWnlBOG5iT2tiS1FLaS9lVzBWUVp5SGFDWFRUaWVH?=
 =?utf-8?B?VUdhcTRPTnJROHRnOStyUHp5U1BycC93RWtabW83MnpscFBLL2pQcjNHOE5Q?=
 =?utf-8?B?L2E4NzhrdUNJT05hdG5ZZTJDMVRTZU1lWkxEYXdXZ05PQ3Nhem9PVFRQMkZV?=
 =?utf-8?B?L0dCK0xJZ0NoQVROTkc5TnlHV0V0YjlOa3FCdmRTVmtHZXpyazJKa2VJNllr?=
 =?utf-8?B?OGJTMHdsaXEyOHh1WU83ZVFrL0h6cjZDL3hkMmN5ckkyYlZFOVduWm1hZU02?=
 =?utf-8?B?UVFvZUtRWjRKRGZwcDdjUUtVbjhhZmZxa2NpTUJTb0Q5Mm1QQ3ltdC9lVzg0?=
 =?utf-8?B?WGhJTjlsMFJyYWdhaWgvMTJ1OWU1OWxXdjE4U0dZWDNKNDF3MGozdC83YmFY?=
 =?utf-8?B?Q0dPTnRYZ0xWQVJiaXhQT0xOMFp0aUFRMmZldy9hNG01akUyTVZrRlFCTXNZ?=
 =?utf-8?B?bnFnd21tL05iYVlNSGtXUGdmVHc0dXBsaklhVFYzUjUxZ1pqL0dRak1rNWh2?=
 =?utf-8?B?Z2pEZjdyeFdIcXFZQ1pNSTY0SDkwWHdQem01cFo5ak80MUxUblB3VjhGd1FL?=
 =?utf-8?B?SDJIVjVHYWFhMmVqNFluUDNIQThYN2pqL29ERGdUMFZsaXgxc3cyS3ZwUlZu?=
 =?utf-8?B?YlpzU01vdmlWSmhac2YrMXZGNzR1S1F3b0NFWFNoeDJmcHc3elFaQUN6V0pN?=
 =?utf-8?B?ME0wL2h4NmhrYXVBeVVPSk5CaVlPL29CMmdyeU5PWjNhMjFKWDVwUkhubVph?=
 =?utf-8?B?dy93dzYvNjhVMjE2N0lodFkwWTZpTkRSVVNjWEwwRXhSdFVhNER2MDNIZHR6?=
 =?utf-8?B?Q09jMnlodytQSVRmNVBxNjNxQzQxV2hUTW9IaGpHN1NBU2o3aXp6ejNwT1NH?=
 =?utf-8?B?NU5ycHhLMUpaVyttYnlYVmdpeWRiczdKc2xFL092NkJJa1hnZkxXckJvcXVI?=
 =?utf-8?B?NFNONDd6TVpucS9ETTJEVGtNRnc3RHdiMjV4WWtvMEQxZ1FWdDc0ZC9zUXlD?=
 =?utf-8?B?blNKdHhqREF4eFFRNGc1b3c1dUlMQUpSajROaUdBdXF4QkhqK3IweVI3bHY1?=
 =?utf-8?B?SitONzJQMnpLTENRbkVlY0xWQm1UNTJXcmZ6cERJMGphZmgrK3BZbUdzMVd6?=
 =?utf-8?B?czh3OUpod1B3QmdueXI1WDRuTWZoOWswNlhJL1hqMUxLNHNlWm5Xb3Z0NUJR?=
 =?utf-8?B?amMvS1NXeDdaaWJRNzdBU2dIK2dFK2pKWFp4VGhIa25zaGZzR1FTUzV4Y1Jw?=
 =?utf-8?B?d1FMZjlvVG5ZNCtiNXArWVVSeWEzT0R0YlRLSzFkZ3JicXpwb0JlMHFlVmJC?=
 =?utf-8?B?L2JkOGJIK2pjS3dscHhDamRnZTIwTHFjejBETFZKbnpYSlQ4R3RQaDByYzBS?=
 =?utf-8?B?UmEwZXFRbkoxRy94cllKd1BWQmY3UzR0Z3FDbmJtNGxOR0tCbUJqdHo0VW5B?=
 =?utf-8?B?Y0RNOFNxYU9VSGxnTCtYVHVoaVlzNkVJVFR4c2VwYUJROGsxWTQ3RDA4MEti?=
 =?utf-8?B?MHB6NG8yamZ1bGpLWGhNZFVCK2VIQjZwR3NOMFlmVkE2dmllMXd5UmxXc1JB?=
 =?utf-8?B?bTE5WkR6MGlnSTRja0FYRFRCYVVpSWpEbi9yNTF3akxMK0NpSTdvK1YwemlU?=
 =?utf-8?B?WXFXczZkalNOVGdCQ2E3RDFkdVNrZ3BDOG9nSk0waURHMW9zQzh1N0tETHhn?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wksDxVnLkZFEs+y4q2fbYoSKsjk9jS4em7HIiNXt6fU/l3biH3H6XuFimkFW2RFvSt/D86NIRq6XwLjtGuK4zFXCoiS6fa4ZIHaF01TzCFWEBPmG+MFHluQ/NugCx7vh7cOxCXpnv1TgHBEK/+0PoqwprwHmgQrFU9zupXKCScjn+wlWQchThMz3Sz3gMTrtzMoznYN5f4uWj169D2j4YF7G6CE4jdKU5+5CJsnWtWXmnKi0Zt0APdgV3lNn2O/xoNJitknBIYE9mjHVIFj66WHbb4JEQPvhIR5HA8IJs6o0GkkJUEwBlfbjLWIHg1KnQkvHGpXsR/k413CSC/G63uh4i19bM+KIbK1TiRQiPbhgJyncCLNMYh/nvPCNIicEr6jmCgKyGqT/mm7tfSQwGhkb6EvDrtw21dsCeU8NZ7RFzSR3qjeXwxfNjBMqz6SnA8bM4v79SgeDPOxdC2oLarFM5c1i+X8YVrTLSxs9PP+bUN35dpTDHUPx0sNQ/OdgTYQOwE48U6nmeT6wXxvw/GPvJXV0R89dslvLV+pcjrmccJTOo8wUoFU14ZUbAQfY2IQYftRKIH3uF9HRo48X+G45/5mM3b8DPBEZYhSvE+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574cef76-31dd-4929-df83-08ddef1cb00f
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 21:14:25.0170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GXMiqf7g6DA2KDXA+7VJ2yRZM07bPfcal4wt/zrIsbt1GTqOoqye31+gaBJ6sGRdUDAgLD3BmQKlSdz1eGu42lRe/3xgqBI7mm1hGl2f6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080209
X-Proofpoint-ORIG-GUID: lCTZXaULADeYup4LOUKb5OiroLu5hoqr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX2ELszEMatd3Y
 34/Kh8495Myr1SEZW0LshEu/GTSxHZ3mtaTqMRC97fxVS2+ZXL6htzHFZ9Dp5mi0/4kJ83DfFBk
 QNxSaOHA+q/fZezyuYUmYXrjPFknv83ISNy/SI6dLfWQnwOACBIWVOFSJxvuuXgEvU0I8hq865Z
 P7R1IKQv2u/zDpD1K/aP/bFjM1QJNEI1m0J7w5v1f1xiAeg5WnioUjq9kD3cr8248YMG5TrF7ME
 WN2R3U6ImpxhKuN+sTCbwoacfB6hmtI3Qwpevob6nqyQElc0fFMLPXuc6+U6rnsPsAOf6EuoT+G
 cMXmrH5oLZv6i4v5qPil5aOyZ8rcnuCbF7Wexhjt5gB3y3UXobFEjqtXXkqvP1J44j2DcMdVZZF
 TEKZC0u/6ooEFtqhP0dRGiDORxGeAA==
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68bf4737 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Wy_Uc5C2wgM77RcHBcMA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: lCTZXaULADeYup4LOUKb5OiroLu5hoqr
X-Stat-Signature: 18bro863wfdk7gtdgtjee9m17u714h6e
X-Rspamd-Queue-Id: 1DAA2C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757366105-709655
X-HE-Meta: U2FsdGVkX1/+HyPYzUwmU75Z5wnRIceEFFqr/0FgnGGU0MAGhmg9laAckfmcSplxnfC8X0E7dcaE5/wXkXGarlpoHaGEXOSiNH6c14lHDii7HgAe76IdEQMxdK98I3yicz1GC809P0/3/3019eGtr8GWc6lpKNdcy6B4S+SNz4B3MuKD/gy7T4D1+9ooq4OjmPlpt4NWPBao36fv9039OARsoyDzOtdlawShTLr3w0voqP11s0lbS0vToFy41URCSFn0AoHGLG3kcoHPzjuWtf7G498I2YFkhADZb/+rP0g74DAgW+8goxx+HQ0W+V+A5Cp1yKJ1719XJQntoqiqNxtUOUtTpbnVSgD/hD+ktqhR/W0z8Vbg0Slxo8osDqBgqu4d21TPfqsXxRSqI4z268SMhaPuxm9I5ysS46qkF02FyPWXEfYEYOrGizv9tTOIBTKgVWDC8kgsT4xJyxtYW7sSxAPXoswCaKqjfZqLbMM4X8lKskAdLjwcL3vNJRjekj2yYL9b3CDwNJwSZ9K5Loxg4m0D024P9hmdp1zSM7l0OwseI6wH+9yMX0D8rA0JkCI2J2e/LSBduhofD7FCLJD3cB89PYxKx2S+mDmIo6HB2oTKkf/4WrB5Ic032oK8og9HzLl20OriM1SMZtNTIwocNK/tBKva/IhvIRafhwPVE6dXyrJG1Z73dbGEvGvvq09mJUjZkHrkay1jjONtw3k3HES7Kiht5FBO7tuFUcf0zCBw7QFipFkJXGAJ7q228sHSWozLsCbt+AgMdjz9lcpvEnL/IeuapqhPfhnOg+GDTRbCaZxvElsfSckLUv9Ay7BNsvlPaKMk/bUONECitHCgUmJq8cziigWZ7G/yhpOxQpik2yoFtMuIc2dVQM+6tEVmpqm+WJqBTb7YIfz2ZHw0LHGsa3lpy7Naev0ieI2XFN0Yp0xmFqFQvtxSLxxMV/IYX26w2tdMPNmgzwR
 iUuxqRKn
 WYSekDBmzn0Gzq1wjAK6M6Ev5crqMgsBbjTG6MNkhRHFmA8N5E4AHni5GPyz0yN/WwXlmBpLWrERFouCjeOslJ19zm/qN2zXYLPf+PLo1R5c9VvxpMXqzlcZUipRJOHTvX4af1ZSmdqlDbAGTkOu0tU9W/KzmrD2rDgrTEglXPE0+12Rah4YM8q69P0oGd1baRKARg9+/5Ime+yguIlk8LD3ZIkJgv2qemkGhZp2Qtc63v1DGbcetoN4a5CUt1GAPYYdUsoaxZ4qEVEuJMj+Juxh7fKVPic9mQD8ORyE2mr54Yd9iBHJFUzDaf1sOqCiatilgiWxI3wXC5mjvS3a8NDOkN/V8qf9Z/0U60a0H6yj7h8VTakzir8Wv2MMchoFC2EMiBhSh6Q0/OP4BQ8P1t/sJKBbmtPvsfpHATQpUzMj23ijicdNaOHaNByg31++fYnnyDp32tab+fFYJEHc2TJ+5OFneClO0YVM/QpIp590W0qVbA1ZDZjwgibCNxtILaas37LsArnpJ4suQDnLjUKny/UQ/+ktr6oBALxR+Xja7sYimWrvoYZoixLpXd2dGEnBQjDZY8KYV5VS1mk3uJ0sOGlpn+mnkgchFYOqpYv28sBPgNgYwRm3PBFOsS55ntmAICRPInd5UX7XA+FP3IENsSymWKIfHtFno7Ikx++V0rBetuyOibSRrlV+/EJNJHoOHwcGjp3owpWtLEzYgXgeyxPAWLKhcN5WY7Hq0aBS+MtruvMUpmKNDwarXsNfrmSQj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/25 1:59 PM, Matthew Wilcox wrote:
> On Mon, Sep 08, 2025 at 10:32:22PM +0200, David Hildenbrand wrote:
>> In the context of this series, how do we handle VMA-modifying functions like
>> mprotect/some madvise/mlock/mempolicy/...? Are they currently blocked when
>> applied to a mshare VMA?
> 
> I haven't been following this series recently, so I'm not sure what
> Anthony will say.  My expectation is that the shared VMA is somewhat
> transparent to these operations; that is they are faulty if they span
> the boundary of the mshare VMA, but otherwise they pass through and
> affect the shared VMAs.
> 
> That does raise the interesting question of how mlockall() affects
> an mshare VMA.  I'm tempted to say that it should affect the shared
> VMA, but reasonable people might well disagree with me and have
> excellent arguments.
> 
>> And how are we handling other page table walkers that don't modify VMAs like
>> MADV_DONTNEED, smaps, migrate_pages, ... etc?
> 
> I'd expect those to walk into the shared region too.

I've received conflicting feedback in previous discussions that things 
like protection changes should be done via ioctl. I do thing somethings 
are appropriate for ioctl like map and unmap, but I also like the idea 
of the existing APIs being transparent to mshare so long as they are 
operating entirely with an mshare range and not crossing boundaries.

