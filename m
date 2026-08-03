Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB17C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F8B6B00B0; Mon,  3 Aug 2026 08:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF8C6B00B1; Mon,  3 Aug 2026 08:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97C36B00B2; Mon,  3 Aug 2026 08:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0A46B00B0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:56:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 099EA1406EC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:56:00 +0000 (UTC)
X-FDA: 85059955680.01.4878AB5
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010069.outbound.protection.outlook.com [40.93.198.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 120F21C0003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:55:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YXriw5Kf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.69 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785761757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pG0DhMEhsPeVA03HUBYf1GPPERkT39nbO8S0cTGkXQ0=;
	b=DEPUdAL9MLt9U7zlRPwLX5Fb01DN8Q29yGAD6AIVjBk5JZev8PziuzBkau9Bkcu4gNtxkj
	WHxBCNSRR1aqzuqMDfPf8XZ9QdxMZq4CmQrPC8vLmKGNaEpoKoDWGKzvnD/Lqf7Bpvki69
	jk/yglliFQsfVAcdoAX9hTuVT0gOGJs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YXriw5Kf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.69 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785761757;
	b=VHn9CA39Ys6TzyIojEu36zDe+aCBdn62Lwsv+/64muWu59L3lpLydDN3iZD1thzkzaPuuA
	am8LqUKYuhSerhtrzjP0bOiPgAfc48T0d70TtCUrujEwe/wyDALTVEbbwG1m853lCtD+zY
	LATQxgZXrZ0aEP7CVfGg0hYOANBVDRw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUTRgX+n8zFuSQHMVDFrB+PngMuz4NZUyGv+3PHc6z1fYTSISH4ANR2bGA14tG2mZPGcA4uKpNqH1r0togWIUn7l5VOVssIOtXmbHcMRDwCg1ErmcV0mJ7hgF2R4xeg2aaK1EPMz68VoJwqdAQFDmF15cpl1Tlxp83rGYdIL3rN2GOQ+ziQifkHB3VfPtnPGCYTyoUKwcaIquZS0z6lp14dAS7bJn/X/hbLmvkhK2WbM7no/z3y7UfGbClvAvqmunZngs4Bk0yDcSzg+FAdnIGMR5ZJJRnh1GyIJFX7kw+gT2vzvVoDL6LsZwrLvM9Up74PQ8SoWPJxF+kBXNF8SgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG0DhMEhsPeVA03HUBYf1GPPERkT39nbO8S0cTGkXQ0=;
 b=J0nOgsgY2bdHopQtlZD2u/Ch/MX5V1fwDiD3tV0rOTohOEuwnhuEj6VVrTOuD6W/ENSlSt4pWBnId3IRrxNEf0XtpsPR7v89kqksBPulkiJ1qGb41Fl/JfVvIGLYvUgZOWps0w4AENINaeDBgcT65NbOr2DjW1KWVTXayVkdUd1Z5lGiMvzoTFVY9H4RsW4psAXHgOdItPUR65YQQWAn2P+zrZlD+0KZzWWnum65bhXCG1qPhVzIFggfZCknD9sb5K8xNVwe+v+IYvbuUYrZaIyw+8sccNcGdJB/Gv32MU+3USFyAGl4hBLFvYlkIWByY7JSw7eEn2BUgq4nAnNGOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG0DhMEhsPeVA03HUBYf1GPPERkT39nbO8S0cTGkXQ0=;
 b=YXriw5Kf/WTdMQHEuUWoT8GBmjkZokHtBHO9EiBhFYCOCOaH0RDMF66hqwcBhALETGm8ILMB/MNeV82GdxCMyAoHs0q9Pz5jU+w4yqrCEfq/CEagIxJjYSfBZzVs6RSfhoHQ5RaacM5KOTvueZ0exz8VfoTIgbGNamx7lD1RZvY=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB7891.namprd12.prod.outlook.com (2603:10b6:510:27a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Mon, 3 Aug
 2026 12:55:50 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 12:55:50 +0000
Message-ID: <c9f42173-4ad8-4818-890b-7b0a47c6c6c4@amd.com>
Date: Mon, 3 Aug 2026 14:55:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
To: Matthew Brost <matthew.brost@intel.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Mark Brown <broonie@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 Huang Rui <ray.huang@amd.com>, dri-devel@lists.freedesktop.org
References: <al4jGBGNG_QACaNL@sirena.org.uk> <20260720144141.GA16699@lst.de>
 <al40qCMTxhEP3Kx8@casper.infradead.org>
 <al6cVnNv2TuhuiV3@gsse-cloud1.jf.intel.com>
 <al+kiyFVgrulSneA@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <al+kiyFVgrulSneA@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB7891:EE_
X-MS-Office365-Filtering-Correlation-Id: 39251f17-5608-4acb-1fad-08def15e8b52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|4143699003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4jvctMv0chgknXckk5gXCcRxNI+ii7+pqVAuThTbUF9Ol9/QKmjU2TzFlFrMwFMwYbKKsRX52nj0e7HW/8S0dC0c9KkAObzR9PstZDAL/tZJAW40Ad9Qi76mfyY7ywsLzDvOCRzPJLof6gpnyutsXbG4jaGfx/NrpApa9bKsOkyv0bsePGUjVZ1RxYgCq2jdu6R1TtRkFE7U1V8DdFqJLC6+q3etHPSmtOzS41GQbrvxlejh0SebI7S3LxWj4lZt1b0AUzNHnA+gxHeJFAgRXQ7vQsaI4FgmtIYCHUYT070DNODmAvFfhBOHXArVEwPRZoy9V0MnjEvEBcUg9fcCfTHLHBtvIRiO+Na+LfXfv44qHB4nR1tFY8VcCGHOcRjJDS9+P6O1N9HhLVKNyug/vHKn7Uq1nXG87tftBQNku04ucMoyaAKM4YU/2tMYWNbjKaYU830i52xQww9eohEqOCzuCHM4gEtpmssHy/yRvLBhSanLi0qILhrnOHKUQgXC9BdZFMhaGLpUuoN2adozVzKYXfwyvyrYYbC8NJ8PNpZ+91yRvFqgGlFHHBO69APd9QzWpoDD5MtBXhwp4TAYyOriGX3EYjxV8tliUiWClxDNmQ0rM6SIYrUoHRp+Umuciih3j/OR1s0O+6hqAWlhCtHUEgmjWV3ZxRaYe+OO7sc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWN4d09lRkNzWnN6aXRVem15VEtqSEgydVl1bFI2YmpCTzNzNFloOHJJSHRv?=
 =?utf-8?B?VGFHQjZOcWFGbnVDR2xCTlFkdmU4QUU3QzJnNmhFWmh5NklmVjV3aFdhZFVL?=
 =?utf-8?B?bG5Nd0x5VXdkQVcxWS9OZ0NDL3dqWE0zVW5MaFl4T2RHSkQ3ZzExTUk4VHNW?=
 =?utf-8?B?MFVDY3k0MjQwa3FrUTdadDJZVUxWOWVXRTZpZ3ZHZll2dzhFWUp5b3lGaXRK?=
 =?utf-8?B?Z0YyQWR0dUozckxHUXF3S3NjWEQ1eW9KbURhdzMxbEFsMmZ3U09CQUhhc0Rm?=
 =?utf-8?B?Zis4eHJZMWdCUkFTRVh5c0N0VU5KY1JudU1CQnhKR3RkRk11SVJXYTc3UXkz?=
 =?utf-8?B?b212T1E5NFovSVUrcFVXV0oxSTExSGVKVG9XM2pBclNJU056dGpsYXVBZmhs?=
 =?utf-8?B?WTFub1p2a0lKdnV4L1dsc2owazdsdHJEYWZtQmtZWHZiK2pJbVpNczFMeEV0?=
 =?utf-8?B?bjA3WFp6WlNOSitpdnNncDZWeVBlUThTUk5SZHVyYXlEcWZLT3Uzemk5NGNa?=
 =?utf-8?B?Nyt2ZjhGTkFwS09ZOEFhVklkaXBsUFlaZHg4aW54ZGdLbms2dEF3TXN1TFFV?=
 =?utf-8?B?aHgzcUpTbStoekVFdzEzYytSNjZIRTRmMmNFWWVOUWk2OFR4cjI4dHJnaEEx?=
 =?utf-8?B?d0JLdXMzNStxMW5SMHExTUU4Z0dxcFhCYTBCZERMRTQxWU04YlZtdlh0aThD?=
 =?utf-8?B?Q2RUY3d6UHo3SGVXTWNZemlPeFkzVFFidnkzcmQ0WkVCNzJMa3ZuRWUwQ00r?=
 =?utf-8?B?aG9pa21hZlVSV2FtRXVOTzRKS3FIVzJ0elhRNzk4ekxBRE1kMWs0RTN6aGUy?=
 =?utf-8?B?US8ySXhGY0NqTUFnMzdLNmFsMlpzejQzOFpWbWhiSFVhWk0rdTMwVGxRdXpS?=
 =?utf-8?B?SWVXaFJOT05PZllXMGdoYjhPS2hqU2JvTXExOXVVNXhMcEIxVis4Ti9mblFG?=
 =?utf-8?B?Z29pSFdLOHo3TjBoWVV2SFpGU2hQQUJvUTJTdTQvV0JKd0VHNExWR0Rxc0dh?=
 =?utf-8?B?QWl4VDNUei9TTHkxejFDWHJNUmFiK3pQQnFwRFVubXcyWFVUMG1wWmVkSmM2?=
 =?utf-8?B?LzhORGw5WGllTmUrZXBraWtQSFY0cVJ4SUZqL05vSzJuUkJZYlpWS3ZqLzkv?=
 =?utf-8?B?RHVZWnpENHpqdWc0V3JselNIQ3NhbWtrS200VG9mYktHcXdqVHFsSTkvTUZS?=
 =?utf-8?B?ZEh2U0V5ZDBodHNmWkFzQkRweXF0ZEJkaHpnSnpYSi9UQitIYThBTnRmMllK?=
 =?utf-8?B?UER1dGtUR1NNREJXUVd3M2dkVW8rNHFqV0VUQ2pvNUYwc1haZHpZQ20rVklJ?=
 =?utf-8?B?anU1NmRWSFZHcjJLZDZRY1BSSEUzSVhuRVhYaTlaY0pxTWdTNzZmbTlXMzBk?=
 =?utf-8?B?dEVUcHJyTmx6WUwwcjdSeTNkMm50SFVQa3cvbGMyZHFUR01aTkgrZ0NHbWNE?=
 =?utf-8?B?dDc5TFFGTjhvem9CU21LaEpwZ0ZxZUg0OHBmWDEvc3hIVUpZSnovRTRvS2VE?=
 =?utf-8?B?VjRtQWRIT2l2U1Q4Y1p3VmM4cXhGam5VRUcxOUdpMHREOFh0MkxodW1aMXRp?=
 =?utf-8?B?SjQxUG43SnNXb3RrVGVKdzZjUE5rWDJWUjJtVWd4RG9oWTMzbFI2L0VCeXh5?=
 =?utf-8?B?dm1jQ0lMY1JDZkJvWkdHVEtOdFlvL2J4bVlQZ09hOHFQSTA0TDc0Y2dEZ2FV?=
 =?utf-8?B?Q3BEb3FxZEttQUIzQkhTTW1rQjA2T1plb2VrR1lxdjhOYUhnand2cVBiaTNP?=
 =?utf-8?B?YWVDQlRrOGRGMGdFWlNmYksrMHluQ0lyOS9TdVJHMkZKUnlTS1M1dit1U3d2?=
 =?utf-8?B?ZlFKQys5MStLeFlmZWRSd09vN09kTmxjZWhaTmV2alBqckgzcmw4U1AySnN5?=
 =?utf-8?B?VjYyUFYyYjArRW1aMTJQMHM5NitNc0FwVDl5aUwwVENqbEU2Y0srWnI3UGFX?=
 =?utf-8?B?bzlrdCtsUEtxNG1SUWRNSlkrOFVHQklFcEhhM3NEVGtIR29xb01JdmpKb3lh?=
 =?utf-8?B?UUROSVE2M0Z3VHpsajMyWDVaOUp3eW5xMDloekJubWNwZHFPczBEYjBMTVUz?=
 =?utf-8?B?L3owSVl1a2NLc2JvczZlTlRwVHhReGFlTHVHYXMrY3VBNGR2bURqd01mRTE4?=
 =?utf-8?B?UG1KdnJkMFBtU2FrNGpMVVExNWgzb2pIcUpZZkRYUDJRZWl2TG1KeEFUZmJa?=
 =?utf-8?B?dVh6VEJ0VW9YdDR2ZktYU3RmMVllSzY1S2tiQ1JkS3Q5eVlyOHZRTnlwN0Fh?=
 =?utf-8?B?a0p2WUREczUwYmxHSlNlMUw2SWsvTVA1ZWZtb3dLNTFrUU5oM2RuN2F4TFdN?=
 =?utf-8?Q?qf5z+VAA13FzRzkASs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39251f17-5608-4acb-1fad-08def15e8b52
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 12:55:50.1176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/DmMbsFzDdrqC3ViZoo8na+b0n+dHT73gtyyGM1JFyb71CrLPMFOURnPu0OZ5QE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7891
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 120F21C0003
X-Stat-Signature: 4fnncqc8ajfu9wy8schciuim4yhjbp9j
X-HE-Tag: 1785761756-863765
X-HE-Meta: U2FsdGVkX1/qmTSeH4Km+Fs6Trazy8GqPrLrd2o5+/0kIKZiJ0wfKQ4LgQrFR/n7pxZhVyFKl3JTvxPHSM3o5ZRv9rIJTedEkxIvdo13T5OEd2480mTbr8BXQF46WJr5ZkaRFHNGqSqb86/+lyalIoYA7SssFwC+GfnQE0KCTYMbj5g/SXHk4vzPBAKo9tb7Ed7lxoQIDAoMDqpQ71vmM1nH0SZr9Z9AMDDEF1x/jHnLed/Sm4tTO8dwVaphJrx1KgfdSPmMIXLw0ccHSB54X9UxOTiPyBhumAHlixin7mxEP/iBNHJDYOlRK5hW3kcNDBduKQcLnneUQKyzjAX2Le2lM/FX2Z3XIdhN0iHA9ITmhi8UnIWycIQCGUUH5G2Xc+j64bV5FftmaFBNKGip2NPkQNL73u9WhT/SeITjWcCG52zkaU1ey2QbI2wgokLXTYNEt+k2JeCtG5phb+uY/hz5g2rTpgyt5i6TUojAyzk/2YP5H3DNfn7UxrVqIy45Cak/jDXptaTOAjF/taLE5yDiJLtbJUMunO48dJVrO1nD0YiEpb4bzW1Mh0kDEXFBfey/fU+VPPSUa7Icp/TAT7eYzOMkX38dQ6AcKyTJOFRyKAMvK6+PqrXbJpV1Se6u5A34fBaVpuxA/l412apmo90Su4/+/JTWOXGDCCPwbCr2H0m5dvwpT2Yvwe+726R7XdT9RSjACt4bABm9oKh+i8kXwussYJCNBthXTgWhtDWq2nsksyS7nA6g3ivGcpnPX3kdTRrFupnPR8pM6FR7TazxWbKH8ww06weihWcSh+TMqhY72yazdWS3qcvLQ/NX0BcbpMG5fi6ovtPeNI0Z86K/eZHosylhOJfp4GySezFfoLwpBL7PspLw+rnLV1eEwsLM83QrukuhTlTytdbOlLqKYfc3JxQBDCNZDBMomNBaRJdcRq84q3RoDAIpJzEVOJYURGCPAh8ErN8R09e
 ROun0bgH
 PN6BNn8LcHYgcTA6tOClyRL3MUjYy012bVVtUr+yPv25pKNoWq6fLpvkDmKTkeCaUbNzw6Kl7GrMKUgR89qgGH5+XUJNvCJBXIp3Rqg3viCo/I1OC6RABPGwR9IPesv6CGwaSa5xq25WcAo0kQA6u1ChM/JbTvmNt5/rPYZgmu0n4lQwvQHgaFHqhiDVud/7Uq/OeFvnepgDSN5rYnODTC3TpDqlfGuU6DVfmx54lsLw1tE2qqNqhbOiJjOhMuQVSB+IB9BKJJVKGk3GHy9AHWqmVrRAG44d2raM6C//b5yCVLYpZltMZjzLVb9F/WgsaO3XXWB0vB4gEWfTwvfQk8gOY3ny5+dLqiSmWQOPjStsER+Js/XED9yu9HZKhH0CtkwwUp8mEQ1nqSGj5I7Vx8lw4ywpG2kcczz4yefmkXmA6Dh6XLVrYG3ArLmKWSB2ac+FiGtLWJap3byRP+WxknjY1dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 18:55, Matthew Brost wrote:
> On Mon, Jul 20, 2026 at 03:08:22PM -0700, Matthew Brost wrote:
>> On Mon, Jul 20, 2026 at 03:46:00PM +0100, Matthew Wilcox wrote:
>>> On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
>>>>>   /**
>>>>>  - * ttm_backup_backup_page() - Backup a page
>>>>>  + * ttm_backup_backup_folio() - Backup a folio
>>>>>    * @backup: The struct backup pointer to use.
>>>>>  - * @page: The page to back up.
>>>>>  - * @writeback: Whether to perform immediate writeback of the page.
>>>>>  + * @folio: The folio to back up.
>>>>>  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
>>>>>  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
>>>>>  + *         return 1; the caller must pass the true order explicitly.
>>>
>>> Wait, what?  This is just broken.  TTM should change to allocate using
>>> GFP_COMP.  Why can't graphics people ask questions before writing stupid
>>> patches?
>>>
>>
>> To be honest, I have no idea why TTM doesn't set GFP_COMP. This
>> predates my work in graphics by nearly a decade.

Oh, that is a rather long (and sad) story.

TTM (or GFX HW in general) has the requirement that a page once allocated as huge page must stay a huge page as long as it exists, in other words a page split is not possible.

This is not a problem per see because in theory there should never be a page split required for such allocations because we map everything into userspace using VM_PFNMAP and vmf_insert_pfn_prot(), so the special bit is set we don't have any direct I/O, swapping.....

>>
>> I found the following comment in TTM, which was added in this patch:
>> `git format-patch -1 bf9eee249ac20`
>>
>> As far as I can tell, setting GFP_COMP would make things a lot easier in
>> a number of places.
>>
>> Christian, who maintains TTM, is out for a couple of weeks, but this is
>> something we should probably take a closer look at.
>>
> 
> I have looked into this a bit, changing TTM over to allocations with
> GFP_COMP seems pretty straight forward. I have local patches that are
> working with my driver (Xe), will post something shortly.

Well it should work in TTM. The issue was (is?) that we had multiple other components in the kernel who got that completely wrong.

Especially KVM tried to grab a page reference from walking the page tables, ignoring the special bit in the PTE and then just incrementing the page reference from 0->1 and then later doing a put_page() into the middle of a huge page allocation.

Long story short that already resulted in multiple CVEs.

So yeah in theory we could use GFP_COMP here, but we need to make sure that this doesn't break anywhere else.

Regards,
Christian.

> 
> Matt
> 
>> Sorry for sending a stupid patch.
>>
>> Matt


