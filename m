Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2410CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3452C6B00AB; Tue, 26 Aug 2025 15:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5CB6B00AC; Tue, 26 Aug 2025 15:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD4E6B00AE; Tue, 26 Aug 2025 15:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C30E6B00AB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:18:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBEF61A02B5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:18:49 +0000 (UTC)
X-FDA: 83819870778.28.68AA5C9
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2097.outbound.protection.outlook.com [40.107.92.97])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA3FA2000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:18:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=UlhnpCJ2;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.92.97 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756235926; a=rsa-sha256;
	cv=pass;
	b=2NmptWDKWisGrlZhdS6F1imOROI5W/Oy/rRpmVmyQL0vTLOem+SG2/D/eh1OcjXOnZqCN9
	K/RjhIqZqWsOwztb7+mVP0REputz4RLMmTcIO2GUTYcfLU3WUf5ML7wkxeEG0+P021NmTD
	BZXbsf4ZQYc3v0qYMq1Ws9y7VwR+uDc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=UlhnpCJ2;
	spf=pass (imf03.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.92.97 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756235926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiqtcqWINXikbKoLo+T0IrVCfefG3llLCvmY3rxNge8=;
	b=aoupIDX/ZCfHnGM7e2r5sQnrC5O0Tvcuv9Zr5riz2RHu794UT5Kj3wZ505QOde2or2ftwD
	AVEf0cNZSou8zNlMJl/lcWrfH994Q9GFakwlPVPKPb80jvb8nqwHzahmo/vONBKTgSLhXN
	BtTVuLxdr3rx9EoAlsx2xoxirqZ5xt8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFZC2BeAZLifJmb82KJ7WLbKEqOl+MzfTWYxXlPaprLjugiDHTi8gqrF/ZElKerjpgrk3us88FhxWC0/gINrJwJo7NymyCIhh6ly64SCFbUaF5ouPAnA8P+SPY3IsY3K78O61XBJUA4WQ29NuU8OgKYmWHYmbOzOcT+dpClVYr5RW4gFapY2QUlJZf5Ptr9eUJOJ4X5zXA3a9OvzEmEG7ZsMKV2cA0Gxif2bQQnoZlVkpirRA1Y1Plm97Dy57qlZuCXZBcuiHn+q5Woyn3Q+XUEPi5FcsfILUeHwpAPj1IXHELyXgpBD9uLwJqBOcNh0fjSWFawQD7VPs2IH8eldaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiqtcqWINXikbKoLo+T0IrVCfefG3llLCvmY3rxNge8=;
 b=YQXKj5uMagGxGdlsU4FcjBwvOtqyH1pWCO25TILg9W4UBOtYNpY8Du8GDbknHquxuX0IjDKeEshPN1egkpOOO89kHIvoAnjR/LkrjzCBeYuwSzNXjHtqpJbB/JyygZ/M20LDxawi0w7tF82Kv5WiTwc9/NoyH5fHHZO9FUUx6/hkAQT2FP1Th5UXcI0D26iuoxy0DkaSwhUxvbBVqsWyIBSag9KzJeIvVOWj2L75mYl2E81iQyGo57/cz6nOXK8GghRK3sJrSLzj1xyTYGA5RCW5qZB7M/RvGVeug5Ykq15sYDwZXh+BSx/NbIqUSj6ONQAvD/S8i+ITJAHTk1hKcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiqtcqWINXikbKoLo+T0IrVCfefG3llLCvmY3rxNge8=;
 b=UlhnpCJ2g8DTzcbsooLpUFQbFlpnAiJN3ggMDggMtleI5oaSjdzQGIjs4ZgsYJ/I8MpHJe/mYf9tO4l91ZJNrTMhggh5iZfq3bj7JkpN/vohIttYNXp+BsRBw/7uWDchgTvk2pqPU3nq4nErvdZFnzmAEYmfU5Wy0IeCt6MYFXY=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MWHPR01MB8725.prod.exchangelabs.com (2603:10b6:303:28a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Tue, 26 Aug 2025 19:18:42 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 19:18:42 +0000
Message-ID: <939ac25a-096f-46b3-90c1-d8cd6a9e445e@os.amperecomputing.com>
Date: Tue, 26 Aug 2025 12:18:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:930:1e::8) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MWHPR01MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f8a0ae-2cdc-4d5c-d032-08dde4d55e54
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WERob2xSMVMvb25ROGlWbVY1SnBZRzZHZDRQUENqdlZrSC8zWkpWN0F3bjNq?=
 =?utf-8?B?SUlGMGhrTXlKd2JDbW95aXJKVHVNMUhZUWtvazFlSjU0ZTAyTTltSGJuSW5y?=
 =?utf-8?B?WTBZOUNwbmNmb3ZsQXNNTHNrSVY1ZTJDdnVEYkJ2d0gvdFNvMjdKbnFiY3hD?=
 =?utf-8?B?VlhjcUFsQmVQMVVXTlB0UENWOXRHZ0xoR0laTjFTQkQvRGNYZ3NDK2syMlFL?=
 =?utf-8?B?b1NkeGZvMDB4TnJBTEc1dHZGRWRDTFQ0MnFEVVh6L3V1cDdOTzQ4NnBTbkdV?=
 =?utf-8?B?MWtOZkdQS0lEOTNPSnBBSjZoRFVJMTlVWDlXTUwrUDBpSlltVkNFMFQ3dlpj?=
 =?utf-8?B?ZVdySVlINXpnVFpYRVRVYzZibWVwYUFiNXF0L2I4aE80ais0bUFiSXI3RERk?=
 =?utf-8?B?LzZrNXA2a1Z3VXR2a0d1aCtLVmNhOUlpWi9CaWtUcHMvVURkYitpVzE5eGlj?=
 =?utf-8?B?NTlpTDNKR2xOYmhmM2lvYVhESlZUN0IycVNobCtDVGFMbmVBTlJUM2t5MHBa?=
 =?utf-8?B?Z21mcWZzY0NUUDAvUGZXZmRjODFpdXY5U2ZmUEZrQ2pqV0FZckk5a1Q2Yjc3?=
 =?utf-8?B?OUNPS0N0T0tsTzExM2lobFJhYmxtdFpHd2RLU3JCTkV5WUlsOXEvbURPcmNv?=
 =?utf-8?B?NGRyL29OZE9tdnR5S25YdmoxZkVVZXRqaUdhY0N4ZmN2YTZ2REM4MXo3T2xt?=
 =?utf-8?B?YjVXcFVKRDY1R0hha0VaWGlGcDcwanc5emJnNlh2THpvWkN3Z0c1cUs0UDQ4?=
 =?utf-8?B?TkRQRkhnNktKTHVHZEg1dEZ0a0pqNW5HYkx0REdQN1hPQmhMV3JWVFFrQ2kw?=
 =?utf-8?B?UnRKMk9GZVgyNjhUVjJyK1VTZEJQbnAvWXBnOThHZFMrUGtMS3lBaGVuSHNI?=
 =?utf-8?B?dVNMNXBSMSthckY5YlU1QVBBZmFCcmIvSHVkbnBRVWNoaktIRnNkNzVwcUFV?=
 =?utf-8?B?eEI5aWJhOUJQR1RXRTBZTVc4akhrUkVzNE50VDdyV2NEWWhZc3RDajM1dkJn?=
 =?utf-8?B?cUVDQTJ6Z25CTWJpcXRIRzdHLzNMaWlqK2ozbGcrRmJwZmFmb0orM1N2bEZ0?=
 =?utf-8?B?Vlhsd0pYdGlNOHF2eTB2dGU0ZzRKKzhtRUlOZUpDRGFVcUREV3dyNVRqV2gv?=
 =?utf-8?B?QU9hRWlCTDRwQm5KMzRSc0xYVE9iVVo0NTE0aUxrVkhqK2xDL0N5eW1pLzJk?=
 =?utf-8?B?VjFsdW8vVkRVaTByMDRlWTJCbGFmNXl5Wm1laUg2STE1aEdTTGl4RmZsVGht?=
 =?utf-8?B?c3RwNzA5TXJQTUNDRmdYZ2Y5UFl1T1gzWWhrVEp1VnAvaENBKzhETUxPeGFF?=
 =?utf-8?B?VUhFNWdRM0R1Z2hiQ2J2Q3JQUlRCWkczUCszc3QrbzhZMWFsR2k1WjdSUC9y?=
 =?utf-8?B?TEloV05DVnh4TzB5Z3RKdUg2ZHcySXNaZGZWVkNrb2h5MEd5ZmgxV1pFeGVF?=
 =?utf-8?B?MTVQbHdiRUFEMDdwcDFMZjdIUzRINmNNZUxhOWtabFg5Qi9qc0lHM3ZLa0Q2?=
 =?utf-8?B?TGxsNlY0ekZRejg2Lzh6MnhNUDdHRndUOGR0QXR1bGhWMDNZdy9za1JhUEl3?=
 =?utf-8?B?Sk9iUjRnM2FpV3M1UVlrYjhxQnRZWkl3TU5kWEZUNFlzUlNqQUJKeHBUS1ZZ?=
 =?utf-8?B?TTZZSysvdEtkeWNDZjRuejZ3MFFLU3YvZE5KQ2F1RENBVVVwUjNUWFVHaU1p?=
 =?utf-8?B?V2oyZDdZZmJXSFBZOTA4SnBqeWh3bDFkVERib25iYXNJNExPYUowSmpkY09Q?=
 =?utf-8?B?aTM4ekcxcjJuYWFINzJITElNSTJhRFQ1cWppL2xGSjhXN0YxMUpHNG9WdGps?=
 =?utf-8?B?VE5xcDhzZ1RmTFFHZU41VUpmZkc5Lzg4Z0xsazVWNjVqMmM0dG5TS1pmRmc5?=
 =?utf-8?B?dDhpa1RHYkZ0SXloUFNkSTVUbW1ucUdkRFBkNURmaXRsclhRUzFoV1BQTVk1?=
 =?utf-8?Q?2MPxbXdsViU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anJodVJyVW5maHh6ekpZTVlWamxsUHFNSXo2WURlRXRkZnZ2Qm42OVNyNE9j?=
 =?utf-8?B?bXU1THJNNENobXR6dGh2d0hXak1TZ0h5dUxpN0IwZFlXRGF1N2JoY24wU2pK?=
 =?utf-8?B?NnBRc0VwMTd3VDRodGVxbGJabW1oRDRGSThiRHp1RnIyeUxrdzN1RUhpVXdE?=
 =?utf-8?B?TnIybEpTenM3OFFkS1M0bHlBYU5JQlJHU1M5eGJ0VW0rZldvSlRTcHJ6N0VU?=
 =?utf-8?B?VEJyWnp4OUd5Z2VHUVZJaE5YU0cyRzJMVTFLRFZvUEg2NDRTTzNVeGROM0l6?=
 =?utf-8?B?ZVJzOG1MNEpIVFlHVlN2ck90TWE1c1pMMERmYzZncW04ODh3QW9adWEwYnVj?=
 =?utf-8?B?KzZWWG04SnB4WVVScG9mL1NpS0k1UWdMTUp4Mml0OUlXMmlPZEdtWVNiRktC?=
 =?utf-8?B?ZUl5ZEk3VnV3SUxQKzF6T29ldkdwUFB3dFM4Q3hGaUpRNHc2eDRsbnRJblpv?=
 =?utf-8?B?SGo5KzRhSjJQdTVvak1aSHVJYzdkbVFHSWRtaCtCMXprV3F0U1JBZWZrelhy?=
 =?utf-8?B?MW8ySUtFNWlKYmZpSU83cDZ5Tmc3UXRJd1p5M0dWN1JFNmZoMmdsbFduSDhP?=
 =?utf-8?B?RjMwaXBCZTFQNVBCSGZZUlZKd0JETjV6ZXZHSHdvRUNpeFY0N0hQOHAzRldU?=
 =?utf-8?B?cEVQL1hJT3pFMUdpU2NGOHdxL3dPemJVLzBVYW1SWHFCZ2d2RmtFeHlPTkZY?=
 =?utf-8?B?cjJmTTM2WEsxbkhFMFlVdGVubzkyQXllRUluUUNvay9wdzhUQTl0SlU5cFNQ?=
 =?utf-8?B?NFlpcE42cTZac1BOS3NNdS92NnVaUmlpZ0ZTN2tlZUdob1IzRnBXMktQMTRS?=
 =?utf-8?B?bE5WcjlHYlNCa1JrYTZueHNYWk9RblltSHJYQitlNjFkb25iQk1nRnZvdFBn?=
 =?utf-8?B?dHR0VEwxVjMwQXl4RDd4SjEyakZkR2FhVnVBUmZSbkh6SytsRVQ1V2hlRGZN?=
 =?utf-8?B?RjQ2cFcwMGZmaXA5a00rZGZrV3VXR2NZVnk5bjFmMCtPNFlDUVBtaGRRaWJO?=
 =?utf-8?B?Q0JsRFUvdlhQMmdHZ0J4VEY4MnZGem4vaE55NjMrSldJVnNlUWFVK1JRTWVH?=
 =?utf-8?B?NW9ySWZtaVFWdXhnN2xhSHR0andqYjl1YTFVc3JJeXI2VlNwNHhtT3lYekk3?=
 =?utf-8?B?bkZsSW1BVFBkM1lqSlVVU2xGU3k4SE5mTlgxUE1GdzFoR3A3YmhPc2lBeDhQ?=
 =?utf-8?B?OUMxUEh4TUlKbThuVE94dk5lcEFlN3JQZ0JDMVFqZjhQUWNwaXVvYXZJUzVs?=
 =?utf-8?B?UkxBNTBKY0RtakVGLzYzdUVabCthOTFtanVIMG15d0lDNWt4eUdiZFBvYy80?=
 =?utf-8?B?SHdsSDZRbUhWeEhqWGM2WElFTHJVb0dCc2lrdHRzc3praGRBSmViV25Wc2Zl?=
 =?utf-8?B?bktmRVk1S015Wi80RXNLY09OWXZMYURSUTJNNVdBcmZLWnUrRy9MRzlEU1J0?=
 =?utf-8?B?MVFOTngvR09Db2FsZE0yRjd3OW5CS2VSWVowNkhlNnNYR1o2cHVwRklhT1h4?=
 =?utf-8?B?TGYwVGY4dFFHVUk3SUFabVovTHdlRXozWmhBRzRaQUFndnpBc3NDRVdaUGwr?=
 =?utf-8?B?U056cy9NVmZKb005dERHOW9QUFVDZnc5V2F0MzVoUU10am1lTUIvNm9EanlL?=
 =?utf-8?B?ZjB3cUtSdVNiNzRFRU1DVjhXQzVubTdvUVNJZVhkUFhDZDVvQkh1WCtIMVVD?=
 =?utf-8?B?VmtBMXo5ZlUyQnZMVnBnMm9vcUpHMnVSNTFHbmtEaHZUNTFDaUF5MUlsMEZN?=
 =?utf-8?B?VDdJOHdRR3dQZ2JTejFLK1kxY1NRZjVDTVZlNHh1aW0xVXlMUVlWYnYxNHhF?=
 =?utf-8?B?akV1aVhBOHZycnYrOGhYcnV6OVZoRm1NYlpiZnJNdEp4V1VOVUdrdjNBbUJ4?=
 =?utf-8?B?Mk1HOWJvOEhQb3hVdkJJTnd3SWJRK2xCeTlsZ3FIMVZhOHFDSjZab2VPcjVN?=
 =?utf-8?B?Z2ovTHVac3lpRFFmREwrMXQ3eE9TZnlqd3NCeXpjcWNDQnErbGlsNEdVZVVY?=
 =?utf-8?B?SWQvdm9QNFJhdE1BaGU1cjVPL2N4UU1scE04eTZ4U3FKNzNIenUzclVkWkRv?=
 =?utf-8?B?YnpYZVIzL09mNkRwczZSano4ZGJuVTBJKzhRZS9JR1A3QmprcmJrY0Q3RWZ1?=
 =?utf-8?B?cXMvR3kvNlVJODNibjFKN3NQVVVvOFgrV3JTUTBjOGtPbi9CUmEzc2ZVNDBQ?=
 =?utf-8?Q?OdMbeSDtY+XRb/gdsJ8yY7Y=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f8a0ae-2cdc-4d5c-d032-08dde4d55e54
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 19:18:42.0820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDrE1HbCZaQncVmXDM5cAj64Ht9Q2jgJdg602R+0n2z28XarqEM7W4lLmNSG+cTTvZ/d+MFJpQYbcIaPG1YMfWIh7U2SCA3H2fcs5mvR8cE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB8725
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA3FA2000B
X-Stat-Signature: ukz1a1fao8ypqmfxdd76pxkuaumskwam
X-Rspam-User: 
X-HE-Tag: 1756235926-617256
X-HE-Meta: U2FsdGVkX18Ogps/rAdQMgSOpUFSebaZAEXg2u53dY2urGpH9T/XRUBG/nW+EEAnNSGLwbIyoLUVrkkPiDXsLeANITvIhfWFpcY1XJ5l8rZIr0lT5Op6RFH6pCnlBMISWh3Ozk7H19mAr6Tddl7lugkHwOT7qU3XupkjVP34aEAPW+8ubcU7UNXLMO07YM7c0ssTtYmxH+d4L70Ak5+0q+jFlXphyK76kOYYgTjdansPTXfmlfblvWK9kG6d0JsoDMy/eCMvjP3FqDjSbSKnsgHyF7uMJ3MqNmU3WJNATQtuEjqVimEQKnu5Y9fyKb8fJVKCy+Q4uZg6mhXS7LnK1wNOkm0i0D0u/Z8UHv06xIVrQXqWVTZ+KqAaWZI9f/YdhkgXPrdkFnL742mKwGe9Jixpg360i5c1n7gFYNtgAy1YAD8zY82Q8S1/dJtPwz+8PlIYcnbNvZKqN3plpHoMms1hANIAErSzFrIo7sYXAewyCBhxV9AxtjLYHyAEI9hP+mk07/b6GmLk0wnznefa456HW4KorUwtSAffJ8iQPCxIHeYc3/zbNKixC3KT1Xv2J2trYnLPPH3VNWY512MqCCiArsan/0odx0M657f3H6uYuUdIH+P4K7qXuEkmajLYXFUNc+eRy/RLS9wi7s9esyeIazDHbXRNijFGTotyaSgznlLJIxvoDf5CTmZ36q33n2GOhBACAJsvIszpasLcgIlBWMquiBE3NtBCRebXc1xXG9H/LgTOJi2CXLR0lDBByq0VYGTZphYfYObY17j2WBEa6AFJ6YzQEIh47dwQI1SOFkAABzAHhWz4wASo299M73chf3Hbc/kHXkunn/8M5wxUZqmiIEFHCgYnzTTghLYQNrTDfuCa1InjBGOrza/I/MmkdM1mGEid6Ng1XoIfeNXErHcxNuYHpTO37M/kezrBn1m2JC95nOZ7UI6nY+IYfbXy+UsOs0ZMXXU4ZNi
 fw7Z07Xa
 L8A5QYp0lNaoB+QREL2O7FfxykJQyIQEoKp5dxP4NMZlh9tC6H9Y4oG2/ClkCFFkCJarsOTeiJtSBrT4k/dJYWOSU1mSqLHC7PpI11RL7BdlX3w0KsUvqD2nStJEoms0y/Q5nbpebOArcpwY51J7qraQVGRQnm9uC138KI5+kf4cKQ7eTjO9ZbEjygKnRFgDNkh3kBEAB4upe/PKm45nShtR3pQpQf+3wLEbevYjIivlbF2Zp/rgl1sMTTMGoA9QaaPUVeLidDpcLG95w4LMEuJ7hdlIt62bfpFlG/NWgxe8D2OhtZfODDqeoxwTm+KuPRuVq2e5p6YpKC3fw+4/BJwXN+BGmysHSn8nUCKySzQyFP4jYDBMYKa1AqHvRaSiTpwBbHfKGS0BsR3W1DifJZ9j2kc5raWYXjwcYRNIRu8puKka9FqtupuI9/6YF+jhR7pG/7ThfY4H4VyCf27uU6VAjVghk5tlZFkgaxOELj79I+J0be4zO2KPxbvrrcYCQ0q0js4vulyOoxs1wJa1pXxd5uAJIojY6q8xutYuZwtZziKUahDuab/0AiuS7U08EhFvovtwW2U7YAfLiPf8VGB043zmfxlFbozct8KVC6VZCrcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/25 12:31 AM, Kevin Brodsky wrote:
> On 21/08/2025 19:29, Yang Shi wrote:
>> Hi Kevin,
>>
>> On 8/15/25 1:54 AM, Kevin Brodsky wrote:
>>> This is a proposal to leverage protection keys (pkeys) to harden
>>> critical kernel data, by making it mostly read-only. The series includes
>>> a simple framework called "kpkeys" to manipulate pkeys for in-kernel
>>> use,
>>> as well as a page table hardening feature based on that framework,
>>> "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
>>> concept, but they are designed to be compatible with any architecture
>>> that supports pkeys.
>> [...]
>>
>>> Note: the performance impact of set_memory_pkey() is likely to be
>>> relatively low on arm64 because the linear mapping uses PTE-level
>>> descriptors only. This means that set_memory_pkey() simply changes the
>>> attributes of some PTE descriptors. However, some systems may be able to
>>> use higher-level descriptors in the future [5], meaning that
>>> set_memory_pkey() may have to split mappings. Allocating page tables
>> I'm supposed the page table hardening feature will be opt-in due to
>> its overhead? If so I think you can just keep kernel linear mapping
>> using PTE, just like debug page alloc.
> Indeed, I don't expect it to be turned on by default (in defconfig). If
> the overhead proves too large when block mappings are used, it seems
> reasonable to force PTE mappings when kpkeys_hardened_pgtables is enabled.
>
>>> from a contiguous cache of pages could help minimise the overhead, as
>>> proposed for x86 in [1].
>> I'm a little bit confused about how this can work. The contiguous
>> cache of pages should be some large page, for example, 2M. But the
>> page table pages allocated from the cache may have different
>> permissions if I understand correctly. The default permission is RO,
>> but some of them may become R/W at sometime, for example, when calling
>> set_pte_at(). You still need to split the linear mapping, right?
> When such a helper is called, *all* PTPs become writeable - there is no
> per-PTP permission switching.

OK, so all PTPs in the same contiguous cache will become writeable even 
though the helper (i.e. set_pte_at()) is just called on one of the 
PTPs.  But doesn't it compromise the page table hardening somehow? The 
PTPs from the same cache may belong to different processes.

Thanks,
Yang

>
> PTPs remain mapped RW (i.e. the base permissions set at the PTE level
> are RW). With this series, they are also all mapped with the same pkey
> (1). By default, the pkey register is configured so that pkey 1 provides
> RO access. The net result is that PTPs are RO by default, since the pkey
> restricts the effective permissions.
>
> When calling e.g. set_pte(), the pkey register is modified to enable RW
> access to pkey 1, making it possible to write to any PTP. Its value is
> restored when the function exit so that PTPs are once again RO.
>
> - Kevin


