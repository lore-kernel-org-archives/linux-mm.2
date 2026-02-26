Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6C8FD8FE4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092966B0115; Thu, 26 Feb 2026 12:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A476B0183; Thu, 26 Feb 2026 12:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B266B0193; Thu, 26 Feb 2026 12:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4A286B0115
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:49:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9406F1A02F5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:49:01 +0000 (UTC)
X-FDA: 84487343682.13.B3CDE5C
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022076.outbound.protection.outlook.com [40.107.200.76])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5662A0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:48:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ZQXLn7hH;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.200.76 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772128138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1y9dS8FM1pC7Jf8VUWnP+haeivPCTFZKU3mMcKHXmU=;
	b=RyOp2i9N2uxWBk70APuRt5Mzt+dwpJjNUF06TAKa1klpaGBLmDkhzCEAsNaG8BrlxWHAd2
	Ee+/I/Srbopf7YxhY/MnSbcQhwu82K51zJNuEZ8fzVZOgrB4qGsSiQVu0856kb02SblOjT
	qf5dCBU7hAHexbcwcen0K1moOaWb/G8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ZQXLn7hH;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.200.76 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772128138; a=rsa-sha256;
	cv=pass;
	b=s7kczondVn8Tep2/lYrQDV0nh/iHD3DuDWm9BvnkS5J2hsUkRMWGRkiYCa8AptjoIsO9nh
	3cZlAm+4PZ/1X0sXxPId4OPD6HnqqrbRirQKOd+/3VX/2bhFYF6t6Dv6EbYFMIhioeHZ51
	qLfmgJBSxvxdmi57/7QxDsWRI9on4Zo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0fOOT74FAgtu2mB0bCjAjcox4VLoezLVp9qXc8NJ+C8QNcs1strPToQ2iGsM++jOiUnXpxCJhYY5UdMQpHLAdryzCwldbJCTO1DJ0exzqT2HMl/3WSktVNBwe7FmXZMU1Ty0QgpNf/YruJSGCfYpMXLBocG2eTw6acb0BVlnKnNEMMQTYN95A9PtXE0B77a5Pd8cWlnsFfq1m8NMFw44V+8T3UGn7dm/LpC/cJF78Or+pVg/AxVdQpBL/GuOVqC120pWDUMqUAsI/kO4shyn33JMyNpbqdd3tjauF0D7fuMw/yv4fL95h8hVNcbuwzkSIhC4LMjMOxB8O1KoNbNxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1y9dS8FM1pC7Jf8VUWnP+haeivPCTFZKU3mMcKHXmU=;
 b=htpjidpoWLnf7UupaZYIWKt27/HtizDC+dM1hcKz4SfyeOjdXwixMSyuOYvyPzjItoSEXJY3Q38EXv4OcGaMOerViUsidtAIRlmnM31ifoYWzlKvDurRHK0R0Bt8v86biAWABxXTTiQPlpGdT7DFjfwh9FW0fKJZHnsduXI/EUp+7fVmCQQWMICuT7ophUzu6qNObxVX1C1EpD2PDOgXUBp1u7z4F9ogXX/A6dV5Tfr/hVHmPPI3IdzURk4lAOfU/gPlcvM5MJ9Hnf4ijfWc9mxQF+L+kD3yuLt7A8NyehAtiQSM9AnBIQbBxO1Cpmm/uSDePgKxc4t+XmuCGhc08A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1y9dS8FM1pC7Jf8VUWnP+haeivPCTFZKU3mMcKHXmU=;
 b=ZQXLn7hHrSku8qS6Zt7N+KdyHdStel/Z8OLfkAiZz9WnaxsiTOAUILr7maLH6ZJzEMAB1v5L5J6n3mLn/rriVn7SfXqINCnEzQ6k2W2afiAFis4KrOpN3UUvcBFcNiD1PbnjPbRNHJFA0SOj95IYoBMOMlZlAoSRn8Mw09YjmFI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MWHPR01MB8728.prod.exchangelabs.com (2603:10b6:303:284::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.14; Thu, 26 Feb 2026 17:48:53 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 17:48:52 +0000
Message-ID: <84817a7f-9d37-4235-a00c-35df02c21fbf@os.amperecomputing.com>
Date: Thu, 26 Feb 2026 09:48:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Heiko Carstens <hca@linux.ibm.com>, Yang Shi <shy828301@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
 Tejun Heo <tj@kernel.org>, urezki@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <20260223095020.8139Bd5-hca@linux.ibm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20260223095020.8139Bd5-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYXPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:930:d3::21) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MWHPR01MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 2715a20e-da5f-45b6-65b9-08de755f4d81
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	XMoLXKcKVRo55VE5zHLxMHT4Y99xrFkJ4A/KzAkxClzfirrvvE/FD/BGNx0iaOQigbFa/XWJMQQGC6imUIhnKD+uHusyB5nwJYBbZjHxSztd4UE3vaYZm/g4S5HLAYWLyCC4MWOWNQ406RlXHWKqtrMPytW485LQ25GIR2SyyrtDY/Igt9Y01c1ZCLwmUPPjF+bY4cnFSY5cxKHIyPBPIYRmX68PkaqHbmLq2UMuMG8N1diMu/Z7wzKmoAC0Jt2ieA3NuJtjzgZXr19AYeWbe1yEW13s7Ee7ArqmQpzUk3ZX/C/7Uka+ZjkJeCVmFO1ObdtPdbV8ucxjlzATa6440Y9HGMylsW0ELoCRlBoz838y7B23bjNLQFtDjkZYaG1hH7hMkhB17KJDf+U10Vs3h46LTq8jZdxYZjyJv6w92T+ELZa0NKaBPbaWBAI5YeWHW0fMwkz/2a7xGIWCahq6FhmC950mLBm1tI0O3r4G+QuWFneACDtsrWItkJUugc0+yig2CkfO7/T+U4bJ5Yyhdw6fSV8A4hkVAIBoHjt0bYG+X3L3vi0z0ndsIrCvLN6/uDS+FucHrx4KexX6XunO12rzAQaGIZuPE15zWqe8d+78MQlOu+eqF4nod/N5OABRv00G8Pil5hWZlaGly/0x6XfqSwOZXpzxLJ+fTpF/9sh0qEp0vh2I7VZL2Sjttk31eOAf4x966upGvzwDoBm4p2/DE6KIDB+HOLmUOrgae3k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEM4cUxNVkpkeGFucHpwMlVnbnoxQkVWYVlQeklRS2w3clB0aG95MFJ0aTZh?=
 =?utf-8?B?M2xPMkF5a3N2YTNIVEs0UHNIWFZ0ZUdWaEVXcnc0ZjBpSFFINjhRYVV2cWJt?=
 =?utf-8?B?ZFF4UEtTZFVHc2NaK1ptS0tEUkdoK0FJeGZHWkV6MFR5YWMvVmdobXQ1YmZ1?=
 =?utf-8?B?a0JVUEk2SnpNeTVjWHdEUzVmRG92OTFMSTZIdHg5ZUlFU29TNGxMeithQmZR?=
 =?utf-8?B?YzhXTlk5TWVBZmo4L3M2UXFIUkpLNzhLUVM4djdCMmxwV21QME1oQm1lalZM?=
 =?utf-8?B?azlwOGMxd0JqbVg5REdTeUJCWUdtdGdWcTJZUXE0RXJiWnBvUnNmbUFndURu?=
 =?utf-8?B?MlRoU1lROHl0ZmsyeDFWRkNOWmFvWHZRQ3FiUDV6OXVkMEFrYmEvbHBva1Fw?=
 =?utf-8?B?Z3BRUXF6Z09vZkk0UzBlclpYSFUwZmE4UHdlcVIyRXpUcEN3V1lDSHRvdE02?=
 =?utf-8?B?OVNKNDNwSStkUENyYmNGbUJKTWlJL2FZdkw4bTRKck9mZ1dNb25BMG5Vc2F5?=
 =?utf-8?B?VGhXbU9VM2duY2MrUnlkSy85USt5ME0wVDdnWS9FN3NpcXlYSGVLSk5KZzBH?=
 =?utf-8?B?SGxpOFF6aTZKbWF3TTVzb05CaTdBVlIvemI2bkFhNFFuTVE0SDRWTmd5ZVdM?=
 =?utf-8?B?SDRqbkpaVWs5UU5SV013N25lakFsSFRJQ1pYU3dGY0UrN1BHQTBBUmdSdTlj?=
 =?utf-8?B?NE4zNFVKMmx3YjIrS3BYYml0VnVQUEt0VEZjRXU2QnllR29zZzNBYUpzOEJD?=
 =?utf-8?B?NkJ6aXplRkZwaEJyRGlabmVjVmxoWm8wTW9aemMxcTlTc1RrbjNpRGErT2JZ?=
 =?utf-8?B?S2NmMkJnSjQ4ejZGK0dNL2QvM1orQmVDbTh5N01Da2RGQU5QbVpvKzlrTFpE?=
 =?utf-8?B?T1M5MTJQNUIveXIwdHV2MVdXbVQwVmpkUVY2UzVaZWt4Q29SdURmVmVKakph?=
 =?utf-8?B?UmN4QmNYRkdpdHN6cTBxc0ZpV2pNcG1Db3ZVWkJlZ1lDUGJUb2RPdXhUTW1M?=
 =?utf-8?B?a1VySVVwaXZxQTNEWFRZS0JxV2VjalM1YkljaFptT21IVW50aFBXd1hlY0ta?=
 =?utf-8?B?OXppdVpSanVGUFN4QWY4QjlHWENta29pcWRLank3UWY5Wm5yd0JCaSt6Zkt4?=
 =?utf-8?B?WGdRZmltRE93bWw2VWpqbE1lT292cFVXSUJMTjVEYWxlb05YT0c2eTVES0J2?=
 =?utf-8?B?WWJ2N0xYTnVQZGt5dzZEYU1vVEJxYUxnYTZBT1NTOHphY0xTV0JkSTkrMm1J?=
 =?utf-8?B?dEhBaXBxN25vSWhsR1hKT2l4RnF3d3IybVVZeDQ1M25sRmJXamx6b3dCSUUz?=
 =?utf-8?B?UjltaGh3U0ROeTJuSDA1c2hOMWlWdS9QZkFWd01JaVdNSHk0WjNoNFI1cHdv?=
 =?utf-8?B?anhQeFoyVXFlQTFqYkxydXdWYmVRTWI2VndVU2lxMkY5Wk1QRzRYcjdnL2RM?=
 =?utf-8?B?eTFKQzhsQUVqcGlWblZvSmErZG1PMDF4aktRNXRFbk5mVTBuK0RHSU9rUzFm?=
 =?utf-8?B?SmZVbXBZeE0vS1NMZEZ5NDlRN3c0dk9yQWEwaXBSNTNOSXJ3dUJpVDBxTjB6?=
 =?utf-8?B?YkZMWW5IYUVpMUJMRDlCUkdpS2wvbHJzSXdzYVcwdEZlMm5YUld0emlrT1Zl?=
 =?utf-8?B?dEd1VndKVkpZa0pYdGg4dkltNXJTZ1FHMkM1QTh0ZGhpNCtPS2xXS1lvN2E3?=
 =?utf-8?B?QmlrTmVRT3FrKzBJSmx5dU9LRUtuZ20wcmlBQUl5Q3QxaDhIMDBKSmM3T3Iw?=
 =?utf-8?B?UUZITzFYczFQV3ZmdGZid2tURFE5V05lRFpGNC9yaDZaUXJ0MmpRSkY1UHhM?=
 =?utf-8?B?U3RjYmc0dFY1c1Z4aXJKTmVzVlpCWmpueEtMdTJETDZzZ2FIcGlxWW45cURU?=
 =?utf-8?B?L3lOd014a2FDQlp4alJlUW1GZVNuY0drNlV2R1hvMlYrdCsxL0J5Mm9jZmov?=
 =?utf-8?B?dXNZSXBRY2JGcjRmMTUzZEdodHRQSHpWUFFHOFloOEtYa1ZwVzhQVlZQcVVK?=
 =?utf-8?B?alFCbVFRTk15TzZzUEZqSldvUUVjNjVldzdEWkVqc1lKNzRwQmwwM1kyNWc3?=
 =?utf-8?B?aXZ6OTRvZHBaRkhoWTc2bVpSZ01sRS8xRnpYdmZ2dDM4TVZycFQ2c0Y3Ykc4?=
 =?utf-8?B?SDlEdHYzNk53Ty9IMy93dVZJUXA0N0pKbTl0cFVJQXNOR2NkZVhuSnFSbktB?=
 =?utf-8?B?Wk9DZHB5WWo4OWg0T3pLckIrVEEzYVE4L1VFZjZJM1R2dXZoNGlqUmlhNDhD?=
 =?utf-8?B?UUVKdHMyOWlFQ0txZkt6Y2pRK3dpdVpKVDJFaDQyTkFzelB1VVIrVGVkK1h5?=
 =?utf-8?B?eGFLWG9Kdk9uWkcwY2xkdC9Lbm15azRDVG9zYTRqb2puSDFueUNCM3FYeTVQ?=
 =?utf-8?Q?oSoNFZScmxETwT/Q=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2715a20e-da5f-45b6-65b9-08de755f4d81
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 17:48:51.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzQtYmBwe6nn1F9kAzI0eIxDuSOWETPzHhFmlSRbDh3FR1EpVL/8ZyLO4S82Inb9Ltl4dYp+QXpz9vOnHeF9R7lsL7kSrSOjBn0yp2mirTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB8728
X-Rspamd-Queue-Id: A5662A0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: w76g7by99bftzeyc9b9jwrjk17qs8zdr
X-HE-Tag: 1772128138-775697
X-HE-Meta: U2FsdGVkX1+VaLFgcZuiOwC8n4vndeBcW/ux5jfJnB4QDchESv4D7jNx7KBzou/e01EgnryZUhCkbkk7MHoei2o5qJ9Z3uvdRSWljCROkdxDs9BMIm+wQ7moIzx7gBliZMez0TwSOo3TUpzfnK/AGn5j/UcwPlA3sMZx/Ki+9Wu4nzIkppfVW4PvHIQfE7hismvYerrHvveli0EGr/ladFSR1X9ojbQJaLB/A7Aa2TPwKZTHV/IqmyUCx96MG19w9N/wi+1dVMAvHGQgN6HVAkz7hvX9GSh6CgWpDobAFuEeHfWOJmw1d7nmtIqxFJuKeNJBgFEmWeGzPmNrugHoDsFogcG2Uy39MB+ZsvVD/jQtjJB3zGBeC8Lq1PUxVgKRRHB2z2P+WN+PYQm8wbas5f///Tc7twkm9a8pt8dL5yBQQNQNzGjaGd8gN73W0S1wSoPf5P2L9djjbCaGWWIojU0IKo6z0bSR1LO1Ge3TrtotZd1Oq9KPSbhw9WJJm1On6SStajSsBZ24Tbhzanq7/tBFPxLlKx+V7BMSLlW4jxqovBwhochqaNhhUshi6l5A+ZevwVVeud/ClTJKHhKWZ33NTNcGxVmccWMBez7A4pgjDagId2FjgM9COwbUTPiekisJBB2/cf3kUe8yYQA99cSg9YZq8dwFhABfSIqwpgQ254EtH/pb1Mu3Fw3Y9m4mAgytEOamWkO0/jS17lkWvNONQPrx7kTFBLN+Iq4Ru/EOxhMyubAxQ3RDM2l24SF60bZcTzVAG/n8Rv1pzq743Q3Ayxiy3OxRwaeLqFAePRAQK4OzH/wtQhp2V1qQj8JMNOR1Q9xV5f2ZsI3qJ2GgNtSxySvvhp6cgImk4hNCRMia5uxCJS2uDh3MdnaWDh/a0gguvPkEWu5Tr/twCfBwSvHhcAV7ubNFLzPhN+1DSUyQ/oNdvZq9+pe6uicuowCqhzI0s8XFi8EcgRUgbNa
 sl/BMPnl
 23ZyPjll715U17Ujg1sMu8+ZYeOxvcnPDUDGYyeMa9ZTi83J8Q68GaqkU1rEhJFa8TD4Uovr6wVgni+IHwiyQZyMezG+JPEg4IY5bdwHOWzab8jkzCgYJr7tD8uIkVaolbjbc0UvFAyHP1Y8wDNlUN9LX6QsZwmkPbJZOOqTcVXk4PgvvWIFUbnrcp28tNUVkPrwjjyH/OefOQOU0vtHIVIJgzGjpbpx2t1TylqvtcbZHwAeAwKeAo9C7Wo3whGv8FXvtA7cRG7qgfK4DgW4tlUy4bHf0wkuQuJNUxGtbD9Dh86qXlX0TvTW9Ub5zJB3pSo0b6EK5xWjSWzUQAFBXrL/Sq9Rh7P1+7e0+iZIOhNAB0LzyzUC6lr5TG2/0fmWE9xanmXMNiKZyGmKC4PJ9b8693betX72sYObRES+0DTYNfALhM1JQfw0M/jxJaqbuTNsIx/Beozz5THBI6loABy3kr90d6/qy3EID+74sP2h7dlD030qLHNcyH6gM2jPQ3TCDc8922sSwB73BWN+rMPshCjgSY/dfVFC2DCgBVNNoC6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/23/26 1:50 AM, Heiko Carstens wrote:
> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
>> Design
>> ======
>> To improve the performance for this_cpu_ops on ARM64 and potentially
>> some other non-x86 architectures, I and Christopher Lameter proposed
>> the below solution.
> ...
>
>> I have done some PoC on ARM64. Hopefully I can post them to the
>> mailing list to ease the discussion before the conference.
> FWIW, from an s390 perspective we have been relying on that preempt_disable()
> and preempt_enable() pairs for this_cpu*() ops are optimized away at compile
> time for PREEMPT_NONE and PREEMPT_VOLUNTARY. Which is what all distributions
> did, until now.
>
> With 7dadeaa6e851 ("sched: Further restrict the preemption modes") this is not
> the case anymore. So the overhead will be there for every "up-to-date"
> architecture except x86. I've been looking at some ways how to get rid of this
> extra overhead for s390. E.g. we have an "access register mode", which can be
> sort of compared to the x86 segment register approach, but switching the CPU
> to this mode and back is more expensive than the preempt_disable() and
> preempt_enable() pairs.

If I read the code correctly, preempt_disable/enable are *NOT* no-op on 
arm64 even though PREEMPT_VOLUNTARY is enabled. I tested with 
CONFIG_PREEMPT (should be called PREEMPT_FULL before), I saw roughly 2% 
more real time improvement on kernel build workload comparing to 
PREEMPT_VOLUNTARY. The improvement for sys time basically stays same.

>
> To make the long story short: I'm very interested in your approch from an s390
> perspective (aka "other non-x86 architectures").

Thanks for showing interest. Hopefully I can cleanup the patches, then 
post them to the mailing list before LSF/MM so that people can test it 
on other architectures, for example, s390. But it may still have a lot 
hack and ad hoc code.

Thanks,
Yang



