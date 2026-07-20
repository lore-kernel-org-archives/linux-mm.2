Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C3EC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773246B007B; Mon, 20 Jul 2026 15:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A0F6B008A; Mon, 20 Jul 2026 15:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6391F6B008C; Mon, 20 Jul 2026 15:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33AF76B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:20:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E73C1202AB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:20:41 +0000 (UTC)
X-FDA: 85010121882.18.AC00105
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0AB51A0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:20:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CQ+S4dHO;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784575238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkzEIC1IqyHuQ9/mMCKgxaucbBPmXznIZGz0CPZhxec=;
	b=vSgtdmzSRll/msB7b08gl01LTm3jiCXCNZae11Y6OfiRGYgir61Uck0HKiGkAomy8aBNGy
	/u59AZRY5d5tXcZuzy2iMck9/N3++ke2BZHg7epklVi/fxa0OZqjxMqXO0C0MZ7E0r6eFy
	f/nMHTSclKjSz2IalqPpCkFjdcBtMHE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784575239;
	b=tekxZ8gKVjbBSLoG/6UuB8r7STWNpJv09yXjwA+vAqIoZl7qBunrqaF8uyCBDZ/wTSlE8a
	6spIHKKW5Nn6F0xDRgzQ6asQPkDC8aBrGXOaONan6tsRFBvsalDB05PCFBH9P1rQkuIbZC
	Yya4qtq8CaJ8rV4T8ouVGQy/u7fU6fg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CQ+S4dHO;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUG1GPLxf+LRrVwF1e0YP50bN98LDdaGXpZZ5+ms767qFjvnpIGijQH4pRFVRGLNYIZsd5uqjV64OfAcM62kv31Mmta9+HEwLjYWhK3PM1HMNZLV0qooSFJOZ/svu6LYMTz+KAnlSABJEWbXdvaQYPVXbfTIi+L/LGHJ+2YD+8k3tBH99BXT2MKlmeSjhdrst6ZA3Nl/le+n6a1cATzOReOx9IyTpd4dLDU2kW0dHeiB/LZrWujQUTu/5T1BJ4EdQcPea5AhbRBoS+2DunyntTDSUzMMvHeRkz+jcW/kPR7K5RbbWl/9xh3Q83OVbUSGZtcVqX/aEbq34uWVOYeAsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkzEIC1IqyHuQ9/mMCKgxaucbBPmXznIZGz0CPZhxec=;
 b=cHD5kAQ0So0FCBv0IsPfj2I3o2OMwjQhDRZ3en2ecgu4tU6D2M7zBH+gYGtoDJavKh7TGyd2zBNFmFrqCkKptoTHKfCWZsOPEz2H+SsPae0UIXt3upFPAfYa8rZlesoWgWvStNwOpiedssdumFkKJ0SinHFPpUUn+xPqKu/u4ev1gBsRnUgmDZuT9FaNKM84bykGYzrkdlj3Bf6HRW9+FxEY6Al8OGOTjrawSc884cCr/ZY8bHzraJZg2/P1UeaGFZwMbEk9lWb6i78n8w33SjZ66lc1cD1LS0SzTxI19ChfnWixsmF2gR9cztH8TgvAPEaTcnEsgUFBqMMYtmrL8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkzEIC1IqyHuQ9/mMCKgxaucbBPmXznIZGz0CPZhxec=;
 b=CQ+S4dHOQkm7nlcUap9GoCUybciyDSe0te6MfZe22PNN9VD9yrpAPDuimoKVPva/dEjx2Np1wMANleortLKjrHtjL5bwQrnX3yrMvB6tCEoehKrMdvzVGn9NuTCx9R7v2pA0/llQQSdnDD4pC8d/bCiTXJMEBgQKNwqIP4IbOIMC8xchqdvXNHx8nES1zFvALzdAlxpJmE4ZmnyCyRzhi9Nm1g+8z5z8AUCqZ8gPNiTdYaSDaOCBIVycqDSf1mwXRUxediZ0OKGwoeql59Unz/dsdkSoKYL5yLjsU3tFzCUcBwADkIk1jWHFB9z8q/8cDA0gMvqY7lUA1E8au6t1dw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LVXPR12MB999196.namprd12.prod.outlook.com (2603:10b6:408:3dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Mon, 20 Jul
 2026 19:20:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 19:20:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jul 2026 15:20:31 -0400
Message-Id: <DK3N4FET9ORM.327QYW7L79VOK@nvidia.com>
Subject: Re: [PATCH] mm/percpu-km: fix bitmap overflow and accounting in
 pcpu_create_chunk()
Cc: "Christoph Lameter" <cl@linux.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Sashiko" <sashiko-bot@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>
To: "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>,
 "Christoph Lameter" <cl@gentwo.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com>
In-Reply-To: <20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com>
X-ClientProxiedBy: BN1PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:408:e3::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LVXPR12MB999196:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b33bd20-f8c9-471d-b95d-08dee693f76f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Qw5AUgW/+RLU3pO8cNU68S/PKdxa97F6xA4A9LP6xBq1vffgmN5zz7R6zAjMgqdbRFiVnJevj0RofGM0Qtb5K16Su2LTG8VwEeAhwqSO3+AOnX0abMGkw+frStquGGgvqP+F7K+3eC5+Vxk04uEMAgj+M9w9oNjlQWZUq/rT32UVFrNv5xvrow76VvxOjpkOhGGhYb6n1AxKNmGJw2ZTdKdXXjNYCNWCOxXnlAVAgchSjkl05TmNBxR1uGRunbiJcO7JDWNyU3dEuSho6HGO80zy+MONtYAi6REFHaqSyzK1+m4YKt3GqRxwLROBUb7zgJnR4yTVAm8EoqNTkqzX/qAZ1OfFenxjZVsxyRIWpuCkW4szrVLr8/PFLMlzo6EtJNUXhRISwKF2HMiG/E94IeQ8NIiJSzEWXO8gQcbu/uxVwpYcLY9eq3LMtt3rn8H9Zg/si/HV4l4hwGKbrTSVyAAMlqzIlH4XMxcA9d2gv8BZci4wzrvHMuk8FNI7iXxUbeNJNDPAIZC3JHIkpexq0Vbse1Ef2B8zn5j2CKkCMArABAPAjMUrVdfOgecKorD2uGLOsR0sgSXBZe1AAPMz/a8vxgrnkiO60ALyDWacp3wA08kddpubypZClJS6LcyvqD8kMIaRaMn3YQYon8PiFWBSu5hxWaQ10C9IUghDz6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aU1OdUNWbnlHb1prQ1FiVGkreS9rYVU4MkFua1o1YnZnZGluTFpSaDdXbmVn?=
 =?utf-8?B?NEp2NWlkR09RL3pqb0QrVkVncVEwRW9KeTJvR1luNUI5SUFzWHcwTHY1VWdH?=
 =?utf-8?B?RGh5dktkbFlkK0F0OVpYNnRZRmVGUy9tcXRoZlhNSWVjcDMxTzhlK1RRWGE3?=
 =?utf-8?B?ZkJwa2hPc2pyM0VxRURnemVuR0pMQ2dtM0hzMk9vdlNnSXl0WE1qQ25ubnVX?=
 =?utf-8?B?Y2p2V2lnT2prZEp5N0ZHV05pUVFQSEtleUMyVVd2Z2pxQUYzUm9Yd0o4MUVu?=
 =?utf-8?B?Ynd6akpDcVQvNjFOQWU3ZnVDMzc2ajdNOExOT3JoU25SYWYvYVNKSXdPcXda?=
 =?utf-8?B?OVRmMWdmNElKM2RBRUVheHpaOHRZRm9CcUN4WXZmZGJLVjF5TVlxSHpJTkEy?=
 =?utf-8?B?SXJHVDY2TWZLNXZkYU8xWVFCOVAzeVgwN0owNHFOZWhFMVFCNkE3UjRSQkc0?=
 =?utf-8?B?T0ZWT0RMMkRMeHZtYkpzaDdSeHZ2Ymh5VnJVWlNCNTZwMmpPRlNickxpNEdW?=
 =?utf-8?B?d2duMWxSQkVZc09MZnFSREQvRXBZNC9GVmVlL2RkVlZXYTJ0Yzk3a1ZHMG93?=
 =?utf-8?B?RDBYdjFUN0gyV3ZiZUs1RFQra3Y5OWUvT0tkQWpXNThXRDlwTEEwTlQ0bnAw?=
 =?utf-8?B?c0pMelRXR1VVT0hKdDNHZmlSZld6UlBOdE9lajNacThyOWhnUytMNzVPWlp1?=
 =?utf-8?B?ZHFVb3h2Vk5SMkNaZ2JzVmQ5RUJOcnNYNVZ1UW1uMmcxeURNQ0dvR0xUNkFp?=
 =?utf-8?B?T1dlTnMyNzhuZ2R0TVlVNEx0MDRxUjU0bkFZQVZmem9BOTl4U0tYNnJobll1?=
 =?utf-8?B?ZGNuZVlPTHozaDQxc21KT2RLbk5aZFFXTm92eGQyYldQREozZTlCTVJDU29w?=
 =?utf-8?B?WGszV1hrQzM0OURTVUNEb3p3ZERWRk9ZK3MzZnVWSjBVVC8yTi9jd3BrREVF?=
 =?utf-8?B?YkR2RjhyMnNhTjRvYXRJV2R5cGFSWjJnK0JLL0ZtZFBiU2ZGcTA0NE5LS2ZS?=
 =?utf-8?B?S1ZsZTd3d091YnpYRHRNWDZIMHVJc29FZXk3b0E5cWR0Tm9rZmdudHk5ekJ0?=
 =?utf-8?B?UFYycEpZTFNGWWFIbkV6cTJGRzZkYmdDSXRUSW9aWXNXNm4wbldHV29ETFBE?=
 =?utf-8?B?Rm42aGtYNXM2aHorV3o0RHZHeExST3F5eGUzamdBYS9FdlAvZnl0NE5RSW9Y?=
 =?utf-8?B?dHE3Y0NLVHErVWwzbXBHd2FmcHU5K25MUVlZVE04dHYzaGZoNlQxbHJFWVM4?=
 =?utf-8?B?aTBSc2tlSGxCaEdBaHQ1cE91Nno0MGtGSEhYcGdmMldpMU9CNUNxZkxOc1I2?=
 =?utf-8?B?VTd1amozODBMTmtOaVAvczdPd0EyVTB0d2JIRG5kc1lkQUhpdzBSUGEzNzlr?=
 =?utf-8?B?a0hxZzMxWnNMY2NxeWdZSnM2eDNhQnhoSjdXS2Q4M2xtR291Nm1JSDhYRER4?=
 =?utf-8?B?NnFrdnNiR3Y4TUdlVGlCSkhPRVlEeHpPbUVZT2E1Z085K3pXZHNrbnRDdll0?=
 =?utf-8?B?Y0VrM1h5eElyY0RGdEdDZDM3bkJya2hqTEtBWUp5bEd5NlZBdG9VUjdTMFRD?=
 =?utf-8?B?QXowM1RlS0FaNlN4cXZwTis2YVNBNXlUNHlFZUM5d2ZyL2dVNDViNlA5c3pQ?=
 =?utf-8?B?d2VNbC8xbEpDb2k5TlF2U1IyYzgxSXppSXVvdVlSdWdDYjZoVmJGdGF0Ny9V?=
 =?utf-8?B?SFBDL2lXNkJHbVNhL25MQ2FvbW5KTkFISmFlRjdwOFd1M3o4VldlYTQrenFm?=
 =?utf-8?B?RjJrL1JaV0dkNjQ4bVdtS3lDRDhocUxhQ291QUZuWEhybWlRL1pMMTV1YWta?=
 =?utf-8?B?eWJLb2xjcTlxTVphVkxaU1M3SlZ2b3BLNWF2L0RzQ1pMZWpqQlVkcHBYcUNU?=
 =?utf-8?B?VDVtcC9TZEFYQkRNL2QwUFRDYXIzM1JwWUVSM0JMWlkwMlNSRUQyUDBEYW1j?=
 =?utf-8?B?dEE0aStTK0xzNjJjNVdBMHU3NmV6QzRoRDAxT2k4TktRaStrUE9wdGpxaXJ0?=
 =?utf-8?B?eEp0K0hjOEdETlFsdU9oSXBybzNyU1FkTENXalJHSEJFcHZyRmxRcndDekhh?=
 =?utf-8?B?Wk5oc3JPa3V3a0FTeHRxKzExRGM4ZHBUV2l2R1FzY2FIM1V0V3hzV3I4OStC?=
 =?utf-8?B?b2l5Q0Z0cmtVQllCU29CRERDSFVxeGE1Qk16U1VrZmMra2NMZUN6bGNpNkE3?=
 =?utf-8?B?M2NScFJYWmozZ2w0eG1naTJjRFNoTUFLS3YvMFVONEs4aGJjRUNJamlJaDEy?=
 =?utf-8?B?T1lqT1pNU3hzZEdVTUtObWZSRFlZZktkWXB3SlJRSE56MTFsREZpN3lKZVdk?=
 =?utf-8?Q?sLYTnIgTIHkVGnNhq+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b33bd20-f8c9-471d-b95d-08dee693f76f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 19:20:32.0298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNdqnBiRyZDOoSPCkZplhsMqu06Np5UNhxVrvPOWqEz10k/SBFQKp82ZkojYTvCl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR12MB999196
X-Stat-Signature: gxxxg4pmmbb9tqfwdyycnok97htihiob
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0AB51A0003
X-HE-Tag: 1784575238-128471
X-HE-Meta: U2FsdGVkX19DniNNa4sJW343oKCiTwQ5vrCfPfzN9i4QOzuRVOtHX/gdcih4FgdCQbAAXEEn8acL+CiRPNJtytYel9MklfBdjjZkSm4jdu9CQ4bzhiWijqQM/qCG7ydnJLmdfRrQmiIoWbddusSME1aupIs4ZihdrzQ3MJ4YfSkDKXox5fE5+4I+6KnfiEAlWpNOSNN9jS5vypmqg4aZyHjBEV4Afixe8AQnTx+++sGdADNezRgug8aZjgssagYCv4V5KCVvkjWx31mLwyGXlzJqjKY5+8f+WEgSw2lGC15WJAuVzqPMAkzqDUiroP4YPNOAXjvi3hTketQ5PqlPrxAkjfNp4rvuEMYT7snIEymhVNyRGm+nsKGa78YV4XGUVWtL2pCFKG7SjgkzOqddtTlMDE6b9c7XWkihuXpbmuPA9zAcQB1SEJEIJAPy/Q9wvSsgQG2jALppLFFTnsOaq4KoRPc0ynAGZZBNkwl2LOfjMwBeI1+V12Ae0rq6UArqPnwfoih0I4PMVdCQGcC6Eq4Sgm+WUK86kOVmTHKN7EHzYhjzYudzk4k4+2LWaicwF9Lno0VO09OTEBpxuO7aVG4BcyQugxkLU0JBedOKCyK3btmIfSiX+R4L55hhr1w+sFcHM/W8DoLzq6Jj6X5qa9fqC/qZxKNHHlcIDsAhydYM7Hyir9OLAQQO2UNt5ZxZHaqJX+uzsBbRLKOmi0E14+g0lEnn5Cs4E6GrPrYCPys9XElhPk1sxdMyGD7CJoFh5d9zCkLdkNCG2cb4fGEi+SewCZU6sju+DA5ZbEKRLz7agMMFUkBByZ+seEzLGI1b/Ry37WiohemVXWT3YDEKx31D5Mz7d8dr95f5G6LT5oubOeUjUuKwGGuWbu2cFW3LykEz13zEWN0nZBbqpJ4p/KDOxJSRRMwFVnz83rVf9wkXUyBnXktW5bU6pchCK97I5/dMxxGgOB2DciUnTLk
 FrVD0eau
 nTxa5X5E12ymdtaLmyPJAGpjWtiIuo8zMWkUY2fPqNsut1V9TkxzgRdnIkI6BCsHRk0xeBQVlDBpj0XGoFHVIF8WMEYKWxMHug7wmrivM1+hgF+5B3HJ/unrwBDfJ1UzL8HrpGuQ3uTBGxkAcrP7hkSbBs4Zc6J2pVMae/veBgq9tUs3URPQmDl8QfM2kpxWJy8OCGTdPGq7xir1BxfYXairzhoEVM8A07UWtENAQ5tTkioHS5nmUvGu4g/lAMMb7YW8oby8+KjBaFl1xOWyDgn4TmBpeb1xyaWm6HmKQ30RnUdrc0EmOqn77GOcfZEfdfSW9fXkMvMPudwXOofI5V/nsKo10qdPs4qdpE/eu1BiH2sPCuU+JnilK1RAcGqecX81od+8jYKJMHfknQd4d0UL4VSv4Uvp1v7fmrRh2leeVTHPVOP16ndFS7yiYIW0h4AaWIqH3x813vHRM1BmbPqS4ukbJ29F9R9LezjjF0WAT7ItijGmuaZvpd1flRL+N/o3TnLlAGEoiGzhraBlq9Ry47w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 9, 2026 at 3:12 PM EDT, Zi Yan wrote:
> In pcpu_create_chunk(), nr_pages is the total contiguous backing
> allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
> uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap.
> Since bit N in chunk->populated means page offset N inside every unit is
> backed. When nr_units > 1, the function writes beyond chunk->populated. F=
ix
> it by using chunk->nr_pages.
>
> It also fixes the global pcpu_nr_empty_pop_pages accounting, since
> pcpu_balance_free() only iterates up to chunk->nr_pages.
>
> Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
> properly") introduced the bitmap overflow issue. Later,
> commit b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
> chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
> accounting issue.

A gentle ping on this patch. It would be great to get some feedback.
Thanks.

>
> Fixes: a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap=
 properly")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero=
-at-free-v2-0-2970fe777dd6%40nvidia.com?part=3D1
> Assisted-by: Codex:GPT-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> To make nr_units > 1 in percpu-km, we need SMP && !MMU && NEED_PER_CPU_KM=
.
> RISC-V can have SMP && !MMU. SH J2 can have it too. The kconfig analysis =
is
> done by Codex.
> ---
>  mm/percpu-km.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index 7ffe84adadb9d..65fd5580e4472 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -75,7 +75,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
>  	chunk->base_addr =3D page_address(pages);
> =20
>  	spin_lock_irqsave(&pcpu_lock, flags);
> -	pcpu_chunk_populated(chunk, 0, nr_pages);
> +	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
>  	spin_unlock_irqrestore(&pcpu_lock, flags);
> =20
>  	pcpu_stats_chunk_alloc();
>
> ---
> base-commit: 59e34180e138a293260301c139cf7ee800978533
> change-id: 20260709-fix-pcpu_create_chunk-in-percpu-km-6dfa8f28b175
>
> Best regards,




--=20
Best Regards,
Yan, Zi


