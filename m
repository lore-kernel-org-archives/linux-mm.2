Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20DDCD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 18:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A376B0005; Fri, 15 May 2026 14:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ABD6B0088; Fri, 15 May 2026 14:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C636B008C; Fri, 15 May 2026 14:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3D706B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:35:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6411EC0EEC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:35:46 +0000 (UTC)
X-FDA: 84770507892.18.66EA458
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020114.outbound.protection.outlook.com [52.101.56.114])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D0FC140015
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:35:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Z3mGD30K;
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.114 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778870143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2OM/oD6QjZc15mgA0iHvo1fgalv+nvyDI7GjO6RT2M=;
	b=uKkBernukeBRRlsilqjog0feEBhUHVe4yBm7D64wtfk07e5HnFs8k9S+AvKz+hmFGDphad
	Bn6kftoTkjZfGW6jfX7utbCf4KeCiXl5XB444YM86+6M3Udb8ED1d6SUjgRpZr1iqsBaFo
	sr9z9/2+e+t74PoN2OIpGf2z6raWF7o=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Z3mGD30K;
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.114 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778870143; a=rsa-sha256;
	cv=fail;
	b=YxUOg4HvY3BZd3H3CdKxgVqY+zzRJHPqij3Verpn/StviW/7qxLD4O0DltYSxf81aVxGzc
	hI1HRxj2Gs7ewPYOq2a95796wBjHMs+Pv7Q4OTjZu9ZzXQ2bThzzeRa2tHg/RwxPIw2Lf+
	qX5SAbBVKeYZRk0bAmqccYoZ7PBQQR8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjRtGV8v7OkzLjlhsyQDtN7fQMajG8mmOwcJpLakaJiD9YQVtIHpAXQmO7M+hIX9k+gNnxJYXZ0DlcvHHVGLGshX8/b6j/jnWVJckzsq4PBLz3cezoJ8nWNLlnWCEzDJ922AUmo/S0uEdSy22BQazQYmY3nnlhLoX/9aoSytl/XdPMo7O5P2UpHZIBjx093I0xviw4T1BEWge7n+Iqv1B9lWh9ckM0R4Fcbb/eFMH2YE3UNlwc0VPvwDDmNNywmzK4O5ocGvkXIoj4q6qLpJH+HxtEsGhcr/DxsGyECn+kz+LssrE4ktd7+iyQ4ORw3kBwEXGuvQBRp3YFSeVJwPAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2OM/oD6QjZc15mgA0iHvo1fgalv+nvyDI7GjO6RT2M=;
 b=ISkLIdo7MoERzsEmz3putC1lHIiPOi/bThXEFTyIIJVDMpD8Zkqaw9OSlBG+YBeY7N7VkdezaVIhYUtUMVrvSuC+rhSc0mbTO5D8Ia+AiedRQgkZxnAog2Wi+BMLnQyzik8H2GGvLiND3M/SfYk8zgk5gcefCWp4JL5NpUvP01n7SDj2mPOhbvGp/jxNHKPqg3azsJ86mj+7Ga+cZ2sKCimHDU0fLdXojrzLCViCPg9C0PId6kMNwYCwa7c9TZzvQNR0CiBW6fQbfWJb9KYO82FGpGZlPhK1usAiJw0XfFLB3z0pH2KVj0/q+Le5RsUoLiwnyJ3rrbUHU1fb7MC1+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2OM/oD6QjZc15mgA0iHvo1fgalv+nvyDI7GjO6RT2M=;
 b=Z3mGD30KSRjs7mI3nRrsfapjucmNyl28h1LozXU6zF8ZIQ9Wl4pUJOE27+AmAyyhCfhdlLzggyvugeRcjn83w2KAPpxZT9pM/nho8N4O/tcWOjxCW8Josa0Cux9aQsiiIxJ2JsrNJ6x/OXAolX72dhRX7ZGDs9dvCiQxlH97AUA=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH0PR01MB994345.prod.exchangelabs.com (2603:10b6:510:3ad::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.20; Fri, 15 May 2026 18:35:39 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0025.012; Fri, 15 May 2026
 18:35:39 +0000
Message-ID: <124aabec-b4bf-4d76-8bf8-de30c31d44c9@os.amperecomputing.com>
Date: Fri, 15 May 2026 11:35:35 -0700
User-Agent: Mozilla Thunderbird
From: Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [RFC v1 PATCH 0/11] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Heiko Carstens <hca@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, cl@gentwo.org,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
 <d16893b5-3a21-4595-b4ce-e34a7e8a199c@kernel.org>
 <583d5984-fc21-4204-9845-8ceabacf823f@os.amperecomputing.com>
 <20260515162804.10935A18-hca@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260515162804.10935A18-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR15CA0174.namprd15.prod.outlook.com
 (2603:10b6:930:81::12) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH0PR01MB994345:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f78e77-4491-4c11-17ff-08deb2b0c314
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|55112099003|18002099003|56012099003|22082099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	HyR0Pj7rKsMgcD92sjxwrNPaxgTf2PsbXXyT7AEJtOcc5z3/qYsU2Z5AY9nMsI58Imm529C8vHPjMxUSy/Jbp57mvdaRLBN8XnUXkc9Lh9nvxFS3RsFoCp4QJxaUVI4WRQaRCj5jLZNvyhuq8QbE03QgwX7Ppu6BP38hPjLfnrJLsX4qCYrGSGZPnaEqF2tHSB1hu556oKnKYWNUAUh7u+uD8XSQKgyy+INHVmJPX6DMloadTTnlLyyk85jUFpRemE9a1RJA5vXhHf6WkWZnTJCZNN9EViN5wVIbfVEO8Ji5KFGQ+buyrWzGcWUcKuu6qewTCMdW4WKky87PHHbVDJmq0wGdgVSL5anvOwnrcpY9h989I/NlYQQd0weMWN7ue4zxQrfF1SAqGrd7bNfvVkLiQdRBSRi9w4bFr3oDE98/I+94z9PQOVuagiCfdmk2T79OApBmaN8/LnAqt2LMTekDQoSqu5BShiWkiREKvrGsXBEwLJt+Li7DXsrGgaRtbRzr81ouxbIWUn6/niLWxN9Cvlf9pjaiFbRo2g2M+P63Oj/pRHeX30DxlHLli71WywRSJTFuFilWATJ+AM8IiMPEXPtLjW+wE4nG3LytsFu8GGdYDoyHYZ4fEb9LhydyHtc76+rNGOJ2JLgTjnkN2G3LLZt9X+H0HXQJCEKf1yJoXYc0nnRWie9moT0YhK3l
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(55112099003)(18002099003)(56012099003)(22082099003)(11063799003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGF6NUJBd2RLZ1FXNG1ETHpoVE0yZkZtYXA5OWdWTFViYWFqUnlYZTRzdHAr?=
 =?utf-8?B?TFoxQnF5aWxwRm9maTFhazJaeXJjQUtGNUVXUEtBRUR2c29TaVZwN1o0Z2Vs?=
 =?utf-8?B?Y1ExbHVXSnQwejJqeFhkSDFaQm1COXg0WXZNaFRFc1N4SGg3ZEgyU1BBRStw?=
 =?utf-8?B?NVVsZ2xXOHo3NnlwTUJDY2lKYTFUQWFxKzRLd3lURk14OENybGwzNjJWbytj?=
 =?utf-8?B?dTNBRWxxdGtZd01VQm5Uc1ZNd1dkaThXVmhEenZpbGRGTnVuZm16bE5pdFBP?=
 =?utf-8?B?aDBXbHhFQVdRYzJNUWpGeVRCamZsTDBxK1pmSUk2MWNsWGlFUUw2aGZ2OXhu?=
 =?utf-8?B?Mk9lQ05mbCtPalM2b1hocGhlalVwd0RlU0tTT1RPSUdkRjdQamRxZlhYUzRY?=
 =?utf-8?B?ZzFEMXpCeTFIbDg2dVNlUDZlQ2MrdDFzQS9JVFI3T1FMQUlMTEpWOE5TQXNq?=
 =?utf-8?B?anNxUTI4MnRsYlg3Ym9UeVM3UEFRQnZTbktmOUdGd3BrQW9sVzRLdnlYbEF6?=
 =?utf-8?B?eW1vYWpWU1ZuOHJVeWJOYjNzOEpFS0dpQzV5SUNkVmIxalBDaC9vME1DS2dJ?=
 =?utf-8?B?RjdtRmNMbE9HdkNJRnJrRkVJR2VQREt5NFBHbFNaZXlKUkgxM3dVRFYvcjFp?=
 =?utf-8?B?V2lGeU0yT3ZPRFdtK3JlZHFFQ1oydlhqYmJxV0U2R21pUE9aT05panlLRmRa?=
 =?utf-8?B?YU9Ma2lZK2RRSU16MkZmSVZXNFRJalkwL3ozYnUyeEtLWW1iZHVBNlIrYzZY?=
 =?utf-8?B?bVJPbENFSTNQQjhxVDYxQ1JyRTFLbjBhZTZQeEpNcUM1WUllTkp4VWw5dVl5?=
 =?utf-8?B?ZmJ4ZlhYZjVGNlhwdUg2QmtQZHFRaW5TR3kzaklJckVqMEFYNTFId0sxTUZD?=
 =?utf-8?B?L1lhSmdjTk4xRHlGd2ZSK2YzR1pjWkw0Z2daN2NIcFpGTVJHQ2crSXlNa1R2?=
 =?utf-8?B?ME1Vdk5GTDR3UzNhR2VWRjdVVXZFcUM2RTlNdm5BY0pydkxveitGMFR1dlIz?=
 =?utf-8?B?Nk1LZ0tPNlV3ejZwZ2RqaFhGb3JlVUpUcDg5ekRvY2pIc05kczZYUjJ4K2Jt?=
 =?utf-8?B?aFcvd3N4OG50Uk05SE5obGcxb0ZjUUlvVXBYS3h4WkVGSUJmSHdMTXFzbi83?=
 =?utf-8?B?STBka3prVmhIbEJCNEtQOWF2SjUvMTFaczNjdHZraUJhMXRFMlRMbTFyTlAz?=
 =?utf-8?B?bU5PYnIwSmR2Y3RMT0t2VXNxclg2ZEx3S3lrRkhyNFFUVFZCZlZacG85eXpB?=
 =?utf-8?B?WlVrRDg3OEY4TktvZ1dMallTcVdibUw2RVhHZzZNNG1XeUFiajByUUpnb0JT?=
 =?utf-8?B?L2FZRDE2N25OYmxSc3pzbHh5K253TFJGZEl3NXJHb3Y2c0RoTTQ4anptSERz?=
 =?utf-8?B?SEZET3hpOVZpUjg4dmpQa3VxelRuVDZ4L21YSHFMZ3pYNnBsem5FZzNUREI2?=
 =?utf-8?B?TzhQNVErZ0lsTE5Ea2EzdmdvOENpekJTdWdDY09IL2RzR3J6U1B1THhEK0lH?=
 =?utf-8?B?cHRWZGhhSDlXdmo1VDU0SFN0bkhTSzdTY0lmQzkxQUh0NEdPR255OHF4S1BM?=
 =?utf-8?B?VmlaYVBUM2hqenE3ZTUxUVQ3MFZkOUpnS25OQlNVVTMzcnBTRmFFcFhjZ3E3?=
 =?utf-8?B?aGhjaGFYY1o2ZWZ1K3ZWVU10eUhLeDMvajdqN04zMklFb2N1REMxWVJIZmxq?=
 =?utf-8?B?Uld6aXdHQjU2ZjBpVjhzcnVnczM4bTlSeGtuODRRR2FXZ0hvQVUxekJkdkNk?=
 =?utf-8?B?d0paVmVuOWJyOTlFclNKSGd6dm9TbisvckFUNTZoNCtNMFA2S2o4L0Y2M3ZU?=
 =?utf-8?B?SUMzR0tjNzlDQ1ZWZis5SVVlMk5vSGNBTkphMTI2ODR2T0Rzc3I3RUFDMjRx?=
 =?utf-8?B?dWxyRXNXMUNXZHRSSG1abXpWYngraEx4NXVzTFh6UEVCMUR4YUJxUm9rL1FY?=
 =?utf-8?B?czVwZjBlc0FUaHJqc3owSzYwS3JzMVg5RzVwdlgzRW1YNzNEUGxSakRuNUNR?=
 =?utf-8?B?d1l6bHFZZi8yOXdRbWNFVkNuNTJmYmtQUUlWRUk3OGVyMFZML29IWDJXU05H?=
 =?utf-8?B?ODl1Tm5pRFdmei9nd29wOFpwazRhUEdsTEJISFdqUWNYV3p4Ykx6WkVYRWZk?=
 =?utf-8?B?aVZKb29PVXlEKzBaamlxSG8yT1VnMk9EbjZoc1dSTmJpT2ZnYm9DaEl1cWR0?=
 =?utf-8?B?S3VaQlRzaE1CYUw5aXJERTl5elBJWGc4VVRrVDdlc0lwZWVwcmxDNVFiSUU5?=
 =?utf-8?B?SnNFWFVab3J4eGJ1UjF1aXJWbWJRbHdMQ1dEa2tTTmt4aEZTUVQ5ZC8yOEt4?=
 =?utf-8?B?NUovekc2QTNTWFlIbld4aTAxRjVVME1kcDBleGpXbm1wRmxlTU5ldExyZ0Fq?=
 =?utf-8?Q?dwQC95l34C4Nqx7s=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f78e77-4491-4c11-17ff-08deb2b0c314
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 18:35:39.1489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svdnUJvYVPO65bLrG/laBmC8pmipoCUVbiKwskjhSOszC/VMfFJtJOZOjqMJ4EEFzYzcd6z/icYWqYAjqptWs7sl1bQ7Jho/k3KVzJVzrtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB994345
X-Stat-Signature: mmyj9ohnias1kf5ntmyqedrcfo3simgo
X-Rspamd-Queue-Id: 2D0FC140015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778870142-96664
X-HE-Meta: U2FsdGVkX19QbTjsUJcRqb1GwBmX+Qg6FpItU8R587HyqsnHE4r79Vezo3cdG0LqpM8plXAL+whX5Z0J4amALfpDyNhQQLEVmLneGYQMHtXdNeJg0l/Fm5ocBcDCmu0iT0+JJI1i0ArIpw711eA+Ts9UVA0XuDM7lbV0UkelLHIzBOqsiqFtJ/HAOkA1lK9aWf0uMZuC3RzIdb3qDMkJJv5bdDsnlN8FcwxMpAbI8fu45oT6WnDFqC/SsxY3H4UaDCWNrZz8gtZPLhSW0mak6UK8Z3wEyQlbY7UtV7AWOMAF7V+GgzRGNMq2XxwyVAa60sBBmxPuvAAmPTRgjZ+QjfiPWXka7XuYBWoVpuCnw4i4wJj9bdMJhvXEQpSe0o1KjSaPwYFcut6SKMYlvhX95uQwl9hbv6K0EL39x2SGT/IG2y2RgNYcjhQLJPEBsT7Tf7B3/Xu9WaO+Is5aOjwStHfRJjw7k89ndz0bCMaSCDZLw2YWQbD252HPLublcUPZRLv1R8GuQBKSeu32B+XClUSZDCaPnW8Yr5NZUo1bWkfk9agmmEGmfCsLN/b6xweszcqQlu73vGX+T6KsmY8RxmzA+qkOOqSqRfWqZBSb/Wxhevri2bJteIcM3FNBnvKAGQJvTDOdJaHcFUtUMVggGVc5OyK2PnucZ095R3aA2Jp/nLVl1dgu+mo/j6/JwueNHV+ixfEt7ywmam+BpJ7K4Jnk4ToNaQL2iEhqjNLtZC0JDM8dkfr6RL4JifqDeC0lMq8irb01XIdz7fQPEpIzv4zL2rlBqKEFsnUr90yZT3e8mzRillUpYMqcBuCLKx8v8RW5G4i/ORri4ZoRBzyKL39zWMEcFifryGJiBZiGCYgLo7RQ9nh1VgACTGFRhJxBvL9Op5CtnzHe6SdE/CxfdxRzIxXbDGhgkTdkSE0F6Bt1x0FX/RX2QYv8DBg724hxuChikZabPASCAq3E/UX
 /clO4Vrl
 jW7zRfOYqOUx5o4m9PMt9Ry85BcmCf69/ElePkZOJl6+rVbCI/I+gwdCBbZeIYGLZuSfHyN9X2ecWCaMhNfVvOHATIRlShiwmyXf9l833nA0nozvAlTmt3HCY/a2FdSE5Q3qkVvsgeVhFunqDTC7Jd4edeiq4peGuX290n3cET+bsqC3+tPkMfjV5GQ1786wArjK6MqtTqtH5QiGXw1EOn9YIk7b5cHZhVKKKTrmR+9oUi4zX/Rbuf/VLZvEFZgBAJGtqsy+9Bp/Q3NOTl+4A8j0AAPVyJEtLXaI40Pweu2S3rIcZUPhBLhVXGDLlk5I8VikxOiG7PEnTbdf80do36Vahiqcm4JgOv47gVju1QOBQDMzG+WAhStfYzSHMkrCn039G1XqQgkbZeOuLK5p0a044It3rJx0WrfBTSMtDz51YQdNKeV0HN2pSzNP0R6Zp4RVep2JpmWVXagRJFk76HH2jBV3eCzB2BwxV80QZvfMZH5f8W6uGyiEpYGtlhWJgpI+YkcOta8cuCgk69nhzq2mxdhsOjnANckFA/42jZq+ZeeDgB5hI+Fd1B3idfVehODZLcj1zpOeoBGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/15/26 9:28 AM, Heiko Carstens wrote:
> On Wed, May 13, 2026 at 05:00:19PM -0700, Yang Shi wrote:
>> On 5/12/26 2:02 AM, David Hildenbrand (Arm) wrote:
>>> There was quite some feedback during the LSF/MM session, what's the current plan?
> ...
>> I'm not sure whether S390 folks will implement this on S390 or not, anyway
>> they are cc'ed.
> I'm not sure yet, however after I had a look at the architecture documentation
> a couple of weeks ago, I think it shouldn't be too hard to get this working on
> s390 as well. I was a bit concerned about TLB flushing, if changes to the
> kernel mapping happen with per-cpu page tables, but as of now I believe this
> shouldn't cause any harm (famous last words...).

Yeah, it shouldn't. Kernel needs to flush TLB for all CPUs regardless of 
percpu page table when kernel mapping is changed. There should not be 
any extra overhead for the most cases.

Some extra TLB flush is needed for "percpu local mapping area", but all 
CPUs use the same virtual address, so we should just need one more TLB 
flush call with the same virtual address for all CPUs. In addition, the 
percpu chunk destruction happens asynchronously in work queue. Umapping 
page tables, flushing TLB and freeing pages all happen in work queue 
when the whole chunk is freed. The fast path basically just updates an 
allocation bitmap.

Thanks,
Yang



