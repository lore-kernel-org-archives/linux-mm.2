Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60276C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E6C6B0096; Fri, 25 Jul 2025 12:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056596B0098; Fri, 25 Jul 2025 12:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60A56B009E; Fri, 25 Jul 2025 12:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5C426B0096
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:44:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C983C06E3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:44:02 +0000 (UTC)
X-FDA: 83703359124.07.E35B62F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id F0A571C0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:43:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hFBSH23w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q3SGdZH2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753461839; a=rsa-sha256;
	cv=pass;
	b=CWMv4r8A7ns+lJMjQVDvA26LVQy+sCHEy0tj9On1mVpaW3HBO7aG8XuNysh4TsmFm2KvXx
	w4F1rEpylIdj37TGxDaUg07YZDdu76Wm+0jNCNCjxqkv2FFFzCFFJFNvsiZbjiVT4s6j6U
	6LyJ8angCimb5Mf5Oj3XkSZUBi/VwyA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hFBSH23w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q3SGdZH2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wluxZ+Wc3j8pBlMB4MfSBhNdnJXRGdVzSAAau1BBwRY=;
	b=nfQE3n4IcuLz/siJljX2Ei1US2v8zKYacGy3xELr8yZf9iNEoa3aHb8edU1PFlbw5aC140
	vvA4g65GhFPIfAq3bZfCkTBCWa7lyLq73zEBtbFGXpn5HByyTNFQhLXNk9SSkuvqgnYFnp
	YG0GZ51AaoHmSO/aoCbI65jJFFBRAvQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGCCsB026400;
	Fri, 25 Jul 2025 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wluxZ+Wc3j8pBlMB4MfSBhNdnJXRGdVzSAAau1BBwRY=; b=
	hFBSH23w/tZTqXj1ZzSVWXGMK8CO7zDY8Tx4f63sJ97CZM8WJDk3+VfUwWa1l/gM
	+GufC9NweJPK83MiOytdNq561nZu0bPwoOnn+1WM5HlZsnN02+2/ZmXMB9NFTQq6
	Wp6x5kQr5uy/ritZCEZUOWHw2goIv2mERte0w19C2htESv5Tbi0Fj/KG3RHBJj/b
	hwI2AUimBehSoACq38tatKpvqeKizlMLhU92cHTQpkXP6Ejd+wIafZccdMqfXWmw
	CH8/cE9w7bvpDfy14q2+YQoAflFzrD/zMvuwibV2ihwHYzgYXAVQpZK4vRkeyHND
	0p3UG6G9w3YK20xyeyG9xA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jhe6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 16:43:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGWEEh037732;
	Fri, 25 Jul 2025 16:43:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdb255-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 16:43:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pF5qVuACBi6iuhxLimt9KWsBlgrWg6im2lSFPY8ZsFyMbDx6gTsWc0ViC68puiB25JuCGFCyzjG28VBUMt25hHJPJyIdbqTIh7xd4DGAI+0+V6jjVXzAhv9+FZz9/AB3jwrbu1T2zNpuOie8ZcP9xMU6HX0Ub26+OzV3CjZJivGYPf3A25w4B/QAQauBG0lUEyiXUmq8aqOo83GnUXn7acZPPKwjjznw1oJUDoM+6x8O/nyBlk0pBJIbWwuSjrB0Wn1+/oJ5AHCP306mlqHtOs6lcVKhxUjNHR8B5qZapvBt8YDdHAi2PU54WMd3B6dZd6PVLoj8rg9g/xWG4rg+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wluxZ+Wc3j8pBlMB4MfSBhNdnJXRGdVzSAAau1BBwRY=;
 b=yCX8JJ4N+uqNQmR5JM9D0H0zwiPx8u2cFavHYRWFPs9lftIZk3MX12z6xrj50/mb03qwMEaGtBcQXV78geatFyyGt4+2pGNnPWr9l35jbr1Zp+9XwhlsGh3EJBDPQLW6UP3zUh9U+Msuoa1lZFr0k1HVVD80p0twESYKE0ue79YkpvrIRACS+/YVXbr4Wer8rPTderCiqm/GTLU3iriSRuYm8Od6oPT6rQ1DYafpS29WR2pcB/1/goCVsUSNeDu83FEiAbOeXRPYucMbL48WdE2eXDMdHYC1hnEZNjTn0sABlP7wMkHyVIIBasr/DxywJBhNsORs5akHom0P0V+1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wluxZ+Wc3j8pBlMB4MfSBhNdnJXRGdVzSAAau1BBwRY=;
 b=q3SGdZH23nwLGT4kGQyimiyd6q/VYf3j7dRiVO4gne6p7IgKXxFLeE7uCHxavVQT5qk+puDau2hMGy0uWoAv283iyxcnl35yoz5SvwnWRrwtjILpV22uw8+pB6iMa9ytH7eFYVDGdd5bSURHpH3AfpuURD1ybK3SCd3/XscOXTA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7915.namprd10.prod.outlook.com (2603:10b6:408:21a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 16:43:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 16:43:28 +0000
Date: Fri, 25 Jul 2025 17:43:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v9 01/14] khugepaged: rename hpage_collapse_* to
 collapse_*
Message-ID: <02aa93fa-b179-48b9-a319-264be0e027a0@lucifer.local>
References: <20250714003207.113275-1-npache@redhat.com>
 <20250714003207.113275-2-npache@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250714003207.113275-2-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::29) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7915:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f0a4cd-bb6b-4a86-7860-08ddcb9a61d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlpHY3g2VWp4eVJ1MDdOK2NkaTRiMEl6cGNyOUp5bFRJc0FFaEs1K0lPb3g1?=
 =?utf-8?B?T1V4ZzIvMXQyZXp5MEM0ZlYzRDlkZ2hJdFladk9FMlppRTVFRGZkeENiZUUv?=
 =?utf-8?B?b0ZFWGNMZVRSYU42KzI1V0dtRjdZUTl1K0pjclE1MmpyYjg4TXhqeno5dnh4?=
 =?utf-8?B?RE83MkVyWkdQbkxRVnJOSmlDQVV4TC9oNWlqVHJCRjgrTTdYNTZkcnhvV3pl?=
 =?utf-8?B?emZlRTU3aFlFRGNadjFiR2tzMlZKYzBYWERGOXFLTjVpL29IaTg4MWNXS0RW?=
 =?utf-8?B?V0xJN0d0RGJZWXB0My9NUDZTQUJHZEdhRnU2U0VEdlZqSXJiVnZhazBLSnBx?=
 =?utf-8?B?VHRGKytpTDNndjVhekYzNGpvanFFS2dMS1kzcWhoU2d1dENGYURGWnZieFBK?=
 =?utf-8?B?TXNDQS8xaGlmVStvVWozTUJ2SENRa0pkTzN5U2ZJb2hYdVdwNVVpdWJaUGkw?=
 =?utf-8?B?N2FnWWpORW9LaWRwSTdyb2MrK0FDYUpZa0tHczNoUXZMcEhhaW9ZME1FOEJK?=
 =?utf-8?B?cmdVcVBOektJNzF3blRuanUvSHBQSDV0NXdyZU5DcVdLY0JSVklHWllTOGR0?=
 =?utf-8?B?VUpFNFdUemlHdS9NZWRQN1NOZ0RxNlc2U01JUklMUEsvMjhVc3JmOG9PTmND?=
 =?utf-8?B?dWg1SXZqeDZTMHpIUTNqVEI1RHQ1VUF3WjJFa0xCQThwWW5tYTI1SEVPbHhY?=
 =?utf-8?B?YWtXTU9QZEVEbE9KQmprdk82eXdpbGV1cEVDSXpvVks4NXBzVXgzWUFLRmM2?=
 =?utf-8?B?OWRFc1ZaWlZDNEJBQzh5VXMrNFVZUEpBK2FQMG9ZamM1UFQyMWRWRDJKaXJC?=
 =?utf-8?B?cnVGaXd6cFdmNGhCMmUxZUVPQ3hxUmVrdmdNUERRZ0ZPZlBjTC9NSDJ1djhT?=
 =?utf-8?B?dHlQOUQzT2tsbHJhVFJWS2phWGswbWtWMXpPNHpIQVoxbjRrWks3cHRHVGZZ?=
 =?utf-8?B?RFhkUk83VHlmMUdLeXo3TmsxTzFzZzFHb3NOM05PTldNcElSQVpyM2V3clBG?=
 =?utf-8?B?b2FlVStJTE1MeWZpR1poRXh6NjRzZVZtb2kzK0paNmlEaG9aNFJLZVVsbTlG?=
 =?utf-8?B?eDBPVHpGVVJrbXRENG1VY0JQNVpPZTZYaTM0MFozMWNpeE1mL2ova0t5SlFO?=
 =?utf-8?B?UzdTVXZHT2pYamJ2a2R3d3BwN3N0STNZZWtTWklIYURZanN4Y0ptTklTNG0v?=
 =?utf-8?B?R1Q3czhoMnd1Q1FnWVhLYW96V0R5V1BqT2ZzWWIrMEpWQTI0cXRsTkdMcHpC?=
 =?utf-8?B?MlBGMEhvL21tTmxacldrSjhUcm5sTlp0N293L3pXZnJXcVZpM2tFWW4rT2hq?=
 =?utf-8?B?SURKdGw0UVhpdXBTVzl3TmlZWGFZMkJQMTJiS1FhMXlkd0xkM2QwQ0kwcUQ3?=
 =?utf-8?B?TyszRnF4MUx1Y0Z5RXJpUHJSTURlUTdnMDErL2UwNXY1RkNkdW5QMytDcjA1?=
 =?utf-8?B?L3dvVkx2a1cwSU41M0dsZHRLOVVvS1Nzd3llWUl1a0dhQ2pldHhHbXZ3UnJ0?=
 =?utf-8?B?UVFjMUlKaDl3SHczdWZCWVQ0WVo1Z2YxcUZNaW9YNXpmR3hyYmJZRFNWOWxy?=
 =?utf-8?B?djdWWTBoelYrZ1pOeHBlb29GVUtGUEQwTEdMTmlWcXFvRERuWERqc3hkbEJ3?=
 =?utf-8?B?WURVT29tWjY1cXhRSzdzYnNvM1JJbEsxSTM3RE4rcTVWNWJ2ZUk1WWRvSlUv?=
 =?utf-8?B?RXhtREZCblhkVWpxZ0JIL284TGFJbVRWNi9vSVNtcFUyVXRGNXFYOU0vOFQv?=
 =?utf-8?B?OUEzK0tndHpIb3FLWkRBRVJKQlV2a2hEcC8rM21CbzNTRVA3dEUwWUFVK1lD?=
 =?utf-8?B?WmlIVFNzb3lqYzVGQ1U5VWl1VmJaM1o3T25aR09GYUxnWTZSNzBSa09wZW5l?=
 =?utf-8?B?ZUJQenpPbC9VaTQrNFovOWlNUWYvUVJNbklvaktvOEhENnRhaDJEN1JyR0dO?=
 =?utf-8?Q?5wEANeoVCaU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFNMeXFnUW9zVkMvQlJlZWgzZjBTTG9jRzltSXBPTkJIU29ZcTlQelVFbHNE?=
 =?utf-8?B?R1F5RGJtNFliaWVwUnEvNE4vR2RvWFZ0cEpydDFiaVdHTURVbHhaU3FGRW9m?=
 =?utf-8?B?eXZpc2MvbCtZUnVuZXpsZGdWeTRnNHU1SzdtZDF1bGxsM096Zk9rbE9YWnBL?=
 =?utf-8?B?NEVTTlBMSk5UU0QvQTU5L2ZDNlNUUjR4REVlUVFsbnZVK2c1Vk9hVlhOWHNU?=
 =?utf-8?B?UU5xak9NZmVKOENQSlc0eExnRzAxOFhZK0lUb2UxWlpDWmxnY1RXTXZseWF1?=
 =?utf-8?B?bTNGSlM3ZGVLcm9QbnZlai96ZkF6cjB2ZUJYOWxzc25nWVBhYjVjazRoUzNu?=
 =?utf-8?B?eENKQlNEa0lkNkxFcHNPTXRLMTdRZTkxWFdyL250b3dQaS9wMnhTSWcxMVlH?=
 =?utf-8?B?a0VzKy9OUG1sSE9LbVZkaEh5NGJrNzlXaVZ0RVRLM0pEUkRUV2Y2K0JaLy9U?=
 =?utf-8?B?ZlZQbzhzVmxyMG50dEYvTUVDYVBJMWl6MEJlMWRrbjJRVnByQmdMNVcvOEQ3?=
 =?utf-8?B?bXBxQndWZGpDK2FiMVh2bTFZOXpYUWI5WU9Od2h0bzlnZlZVMGNCK01nOGVG?=
 =?utf-8?B?NStOcks0U3JXTDNrV3RuWWV2SmZFUkwyWnFkVjJBejVyRFpHQzhTcWRlbUdR?=
 =?utf-8?B?SU0xRENZNXVJRWd1OU9yRXNLNzJPTnU4Mk0yYzV6Y0lMa0JTcGFHMWVlM0oy?=
 =?utf-8?B?bnF3dnJqVlFHNS9RaUh3RTFMY1JvcU9XRWRUL01kVkNCb2g0NURrejYwbTNi?=
 =?utf-8?B?SjN0YWVMU0xaRkprc2NyZG9ja3VSMmVvWXZIQWlweVJtQ2paMnM4VHRUQ3Av?=
 =?utf-8?B?c1Frb3VuSWRhYndtRzlzdjk3b0lCRkdVOEluVzkraE5CT1MvbG1JUThyN3BE?=
 =?utf-8?B?cm1ucU5CTmFrOFdHNHlKRzZ1OWdwZzd4Lzhiek5POGdLVHR0KzRWckd0dmxC?=
 =?utf-8?B?VGcrQVhBdlg2bUhmYUZtQjM3V0dOdDNlU2dvaEdzdmo5d0tld3daRUU3ZG1G?=
 =?utf-8?B?RzF2emlyekJFSG82VjBEN1FnUW5UeWpWM3I2MXFQL3QrT0svSlFxc2dJN0pr?=
 =?utf-8?B?VzhIOENxUTZSV0ZHMzlhbG1PS210WHppZTlSLzdqeGhSalJyOG9qOGRlTmlm?=
 =?utf-8?B?ZVozSE1NYTJhbnVHT1R3b20yd0pkWkFlTlRVV0pnNU1kZWxCcFJscWk3alpS?=
 =?utf-8?B?QWZTNHRqdkpsZmsrNXdPWUkzdllpYjQwMkFUQW9iT2dqTXZ1STcrS3JaNFVO?=
 =?utf-8?B?L2d4Uis4L2hKTUM1Q0ZCWWV5YWo5L2duejJIYkt0UmxMREFUVVFrWWJjUUxr?=
 =?utf-8?B?c2xFc3lOdlFLNkRvR2xrUEJnd0JMalB2WDQ1N1N6N2FrUnFabkpHMHJhZm9I?=
 =?utf-8?B?akYzMUo0RlRibEpldittbHM3blEyY1pKWnYvYjA4bG1ISEJSdG4ycGZDYmxJ?=
 =?utf-8?B?M1VvTDhxallqWGFNYXNtazZEeCtrajJtRUdqcGZYTWJUczYrL3ZGejhIbHhL?=
 =?utf-8?B?RGxEL25BNDEydGF0VjdWYW1RZS9Dek1Xc2c3OS9qT01FdkZINWNIN3F0Ynph?=
 =?utf-8?B?Rk1OZXJpTG4zR2Z6QVNyK3NzYWRPcnV2K2t2eXYzRmhzVHdUYVBPd2I2MDJi?=
 =?utf-8?B?SUJEQXNwMWY0bGRkVFNqRmZBNzdFbmVRT1B1RlRkMW5kRUYxSnd4ODF1U1hT?=
 =?utf-8?B?eVNNV0VvSFNJWDlJaEoxT1U1U2VsL1F5T1VLcmdORlBLZmFndG9QQkdRbDBl?=
 =?utf-8?B?am1rY1RoZzF3cjFDOVN0RHNHMTFJODZCN3N0VEZxQWovaXBOeUQzUlVXclJz?=
 =?utf-8?B?SFpTVEVGR0JZYllKOGFkU2pMdVh5QU9TNk9GcHdaeURmWTFJZkUrU1IzQjNw?=
 =?utf-8?B?VmNvNk9kL0hkMEF2UThRcUZBSjZaZmRlZitVUFBDdjdzamdmMTBkalNueGtG?=
 =?utf-8?B?OWZONXE3QUFxRDNMMy9OUlNFRWZvbEFMazNuK0RBa01tcVAzclVYbklhT0NM?=
 =?utf-8?B?NkppbEZJaHhiQVNDb1BWMGNlSGM0MXBXSEJ0NmpVc21COGZXNlF4WjhxcFla?=
 =?utf-8?B?ZVliMTlENlpYSzJLRStBRHl4YWFYelUwS3YxRHZrSitZQmxadjZUZ0p4Tk45?=
 =?utf-8?B?dys3bjNCY1ExWkxlTmMxUXFUdkZ2aWVUSnl3NUh6Q3FpMlVjQWJkeUc2S0xP?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wNFU1ZWury3wKy2h6dnFoifQIr7KQP48Qx4fn8Gh9YXPdql8CNFqgp0EH+sqVExCoQE9AvUXx0l3p5NIUvRIDX/A2lNJ08E2CuQw4JuVGVN3faiNhUz1isKjveVMqkHECC5V9qtDe2gz2a0jE1y5a36HqCYkeGwIoLzt7UCv1jVNIQg2CgG446NrNfLdxngU0ogTlEn6iO8FLJe0bcoHNDonppIGdraoFrNdlZXjyzemsuSOrqD0BDkDbRQDk5H6HCN6teSk2DdsyaeWFSzSmjVoIut4/0lZ8DUnbjQ5znC61DiQdEgOkQ5aoMGJ+cp+Q+BVOubVCGOBpp+IrkH8EoBM+EinPa/MfAoIq3IeKKjd7fudK1AZft3WWZIAqrVcN2Kyc0+7xSvgyO9/n6DI50drMpvp/QBDVthPPuoXt0vvQAd3dNWoo5z3rX1gZ3FxL/yO6+wIvQhtryW8iNQKKqwTJ2F8AlzFYRsBMVqkY2gDDJCyPJHxhgRIMFCCNrJdzLxG4wlZxL9SIJ/2w+Vya612A6M5whiik3sjWotnk6ro8ABf9ayqt6EH7zlPNk2QFWQ/2AlYtFYjoJgS2OlNHUq1ckiP3u9GjlXOXe04voI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f0a4cd-bb6b-4a86-7860-08ddcb9a61d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 16:43:28.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ts3B+uq6hoZ5ixdK0JbzewhkAQLGdWQifUlVG9gx4xIgf4GxwxYst8qbMkoph96ptNIiFNyKEYfJPTwtIeKpoFhK+24KjjA2ok3XHbdeJPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=833
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE0MyBTYWx0ZWRfX86arKi5mkkZr
 Ymr+Mv7TLMzcYisByAm+oKWgFbqMB/SQ7xUQcUa1Jq5JHVFwWQULFEDnlbGVozzazPkrwCvrJEN
 M/6+Nh4ABhuCphrpWLLFce7iotG88LHfxFX01rv3K4lmrdc8iJ9kHEW1I1jqZsJPS4u7g5ugd8G
 XsplSqedB9OUltAR3V2It55osPUw2VzGqWxWuijiAWCJz0x8Q6J13H2V9eruWte/6xqa+AOn0Oj
 KV81B8g1D2VlQBcBHc+DMdiPfE+ohm4jsa950dz6Np/5gaquwBcH2FI3P5cgWWEFLP63Uyr1Qa2
 Alp250eOtMXxsReY/Lzv5rxn3IKxX9zCk9wJB2ztLRQ1HEriUivt+5i5IvcU4fTL87/VVx9G3lq
 elNuuk2aOnLNsQaFpzJw+Q9afi9AjBggLXVbUcDad/Fay6vNowRL5GBhC6sjASt8i2X5lZ6B
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=6883b434 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=LW_1up3cSLnti_pvJ_0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: urkWo9Cud6Fc4hHLBS__yspshwMFLDBx
X-Proofpoint-GUID: urkWo9Cud6Fc4hHLBS__yspshwMFLDBx
X-Stat-Signature: pw58b5xf38qo4z4us54fgge7bwebukij
X-Rspam-User: 
X-Rspamd-Queue-Id: F0A571C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753461838-801243
X-HE-Meta: U2FsdGVkX1/9xpqXg813mRWF7aJJqZIKTK99Fu70d/1NGL6Hn5Nduxb6sberSUTLW9cEbjUBFr8G80wXoJ9R89kRLVqI+Z3z8eZfdmTql2WTm7lDvgtWgFH8i2IkT6EBh+EugG007tCPXufZonFi5ObhYWMEwBbVjaXygTOAp840UeGYPS7wxdy6fpC/3ZDmUkKIcFBcK8HGd2JzUzIS4oVtgDLDg7ra7e1ymEww5XEvWAeNcOh97C9GqDH0TH5JgQbJSUUe8MHkEP/MQcAV634MxowB7HcQd4vMF6s72VWuQjH4LQ/vI9PvrChaxfehBZflRQry6e2+p0Rb6CvP7n69G++UovfTRV1/ueCJqUqTZMb7ZsnY/mpU5tol1G+IwZXsM44wL0WztozKpCZm4TNXpR8eN05yEins2Pi3sSb0SWiVLs3VDSyIFcgJY43tGXGWugzOMsappRmTZAnFXXBSryVPAmg+mT5nluVo2tygixZIrsb5hF8uXy2zPEztbd8nbl1NOt8Si7h/BbYbOP1cImG+0p9u9wZrHd1eh22BB7IGu6l3QKFh7GJkY873zbsj0cF/ivy6cphyeArooiz1uNq+VV6TydTdp7rcJe6cQRhScKJvuPOiPH70cSpUDV6HxqdHQPD7H1IZGYtVtA0syMh2lQgoQ6/WZyUWDFxaOBZspRudoDp5ZkfPXaMjB/8zdXyJovoli9s5H8mh78dlDpBsvHhu4e1gq/hXo8aGtA43ekxoVf37tO41NX4DteXsZGZuiUQapeOwT4v7IOu2Wxkv81OazrnI+xmsjilqoME6968VOqfNBD3cqyBhc1+npQ3eGaqB+70QrlK8XWeF5SmNXXv0E6t+ZbEFjyAJZfnfCneARHv0SIW1liqNL9Gp34IqTpxlwU2xEsacISDw/psvZc3lFKCkIpitRoId1/YbtNjABd3Owl+Vg2fp3H/FG8LxPXdOnXaEPyc
 uGuwn24w
 YL0FbKKEK3/CCMzE0EbDjUxXVcEaYuHfXOw/m0x7ZiPcqPt+m9IavRvKYDcpcJk6SAHP4Hv2KKRwCdQxbFY1JEcIRPDsOTnj/vqhaGapgkg+F5saemDf2b/a4kwOx3LCvKj5bpMtqUTagMKXSTS1IVj0DVcwGfEh424hUUgzt0yMGZVVcSnS3T72HQQDw7nxiCUTPybujQhn17A73lA6v+BlIQZ5s0gmCIrvzZkZwRcGI7JHW7BcEytYdduJThzI40x7KkiMkQNHUrUKZWgY1qGbXQGleFHF+ZH+Apa70p4LjdAT/Vb1U77T281gyy19jxz+qse7ey8kRyO1mp/9kQrFbh7rD0c9qa2YbEjhoUdT/6RhoopjY0HA4sh5oLedfx7zbw3trgYCoQK/u+WyPdqGPLvwcbonVwc6VaLicz/qMxFGqT3K6enHx+KNs8WsaJoAyQFBGYAl1RrVs6RzmfPzuqBRG7E4CU3/5um5eooX+iGVF8754G+01BL7GUYbMi8TtyupuOh4bLs8xYxxO9DFruZxlzRmCx8p3MY8+xn9IuM6Dg226lEow6gcnHWcQs6fywMhzgeG2YQzKrpdG7LYG28PrQlijBXwERyCXRbB8Atd+ek19SC6VRFPnl/oKQRWhPthmoxqQBD0G+P0QPkJM25B5Woygx63Bq0nR4p4r4c3U5ehC8bA5IFplsNKo7rU/9SphcjPwqzEJP2pg/kzZBnqDsTUjYadna3jgGiLl41khXfXbi4/oATt2MXa3CytqpTW1rIDHlMSr/7++jE15gRq9CLuHzjiNI/B0SYeXuRW42/Ubvsfaa2qgUQsiWhRnIhoBR++nJ7Z7Msyy2V2iAINE+Ua0V+iFdFGCycONOYI4G5JCac5RQwh0/d4N7GLvaIX4J3D2HfXqWhJw+Df46HLJnSg75vNqV7j2xME3W7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hm it seems you missed some places:

mm/khugepaged.c: In function ‘collapse_scan_mm_slot’:
mm/khugepaged.c:2466:43: error: implicit declaration of function ‘hpage_collapse_scan_file’; did you mean ‘collapse_scan_file’? [-Wimplicit-function-declaration]
 2466 |                                 *result = hpage_collapse_scan_file(mm,
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
      |                                           collapse_scan_file
mm/khugepaged.c:2471:45: error: implicit declaration of function ‘hpage_collapse_test_exit_or_disable’; did you mean ‘collapse_test_exit_or_disable’? [-Wimplicit-function-declaration]
 2471 |                                         if (hpage_collapse_test_exit_or_disable(mm))
      |                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                             collapse_test_exit_or_disable
mm/khugepaged.c:2480:43: error: implicit declaration of function ‘hpage_collapse_scan_pmd’; did you mean ‘collapse_scan_pmd’? [-Wimplicit-function-declaration]
 2480 |                                 *result = hpage_collapse_scan_pmd(mm, vma,
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~
      |                                           collapse_scan_pmd
mm/khugepaged.c: At top level:
mm/khugepaged.c:2278:12: error: ‘collapse_scan_file’ defined but not used [-Werror=unused-function]
 2278 | static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
      |            ^~~~~~~~~~~~~~~~~~
mm/khugepaged.c:1271:12: error: ‘collapse_scan_pmd’ defined but not used [-Werror=unused-function]
 1271 | static int collapse_scan_pmd(struct mm_struct *mm,
      |            ^~~~~~~~~~~~~~~~~

Other than this it LGTM, so once you fix this stuff up you can get a tag :)

On Sun, Jul 13, 2025 at 06:31:54PM -0600, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a55fb1dcd224..eb0babb51868 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
>  	kmem_cache_destroy(mm_slot_cache);
>  }
>
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> +static inline int collapse_test_exit(struct mm_struct *mm)
>  {
>  	return atomic_read(&mm->mm_users) == 0;
>  }
>
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -	return hpage_collapse_test_exit(mm) ||
> +	return collapse_test_exit(mm) ||
>  	       test_bit(MMF_DISABLE_THP, &mm->flags);
>  }
>
> @@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>  	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags)))
>  		return;
>
> @@ -503,7 +503,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (mm_slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * collapse_test_exit() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -838,7 +838,7 @@ struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
>
> @@ -873,7 +873,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
>  }
>
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	int nid, target_node = 0, max_value = 0;
>
> @@ -892,7 +892,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>  	return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	return 0;
>  }
> @@ -912,7 +912,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	struct vm_area_struct *vma;
>  	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
>
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		return SCAN_ANY_PROCESS;
>
>  	*vmap = vma = find_vma(mm, address);
> @@ -985,7 +985,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1071,7 +1071,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> -	int node = hpage_collapse_find_target_node(cc);
> +	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>
>  	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> @@ -1257,7 +1257,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> +static int collapse_scan_pmd(struct mm_struct *mm,
>  				   struct vm_area_struct *vma,
>  				   unsigned long address, bool *mmap_locked,
>  				   struct collapse_control *cc)
> @@ -1371,7 +1371,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		 * hit record.
>  		 */
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			goto out_unmap;
>  		}
> @@ -1440,7 +1440,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>
>  	lockdep_assert_held(&khugepaged_mm_lock);
>
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
> @@ -1733,7 +1733,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>
> -		if (hpage_collapse_test_exit(mm))
> +		if (collapse_test_exit(mm))
>  			continue;
>  		/*
>  		 * When a vma is registered with uffd-wp, we cannot recycle
> @@ -2255,7 +2255,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  				    struct file *file, pgoff_t start,
>  				    struct collapse_control *cc)
>  {
> @@ -2312,7 +2312,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  		}
>
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			folio_put(folio);
>  			break;
> @@ -2362,7 +2362,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> +static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2400,7 +2400,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		goto breakouterloop_mmap_lock;
>
>  	progress++;
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2408,7 +2408,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		unsigned long hstart, hend;
>
>  		cond_resched();
> -		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			progress++;
>  			break;
>  		}
> @@ -2430,7 +2430,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  			bool mmap_locked = true;
>
>  			cond_resched();
> -			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2490,7 +2490,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
>  	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (collapse_test_exit(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find
> @@ -2544,7 +2544,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  			pass_through_head++;
>  		if (khugepaged_has_work() &&
>  		    pass_through_head < 2)
> -			progress += khugepaged_scan_mm_slot(pages - progress,
> +			progress += collapse_scan_mm_slot(pages - progress,
>  							    &result, cc);
>  		else
>  			progress = pages;
> --
> 2.50.0
>

