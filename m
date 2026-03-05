Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10BBAF513E4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 22:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCA46B0005; Thu,  5 Mar 2026 17:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A686B0089; Thu,  5 Mar 2026 17:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041786B008A; Thu,  5 Mar 2026 17:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E41D96B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:04:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 933A3C1652
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 22:04:37 +0000 (UTC)
X-FDA: 84513389394.04.23D0804
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010018.outbound.protection.outlook.com [52.101.46.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 955B040006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 22:04:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ukj4HOiJ;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772748274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=we0v2QYImFuYNkGgyYnlU9AgluyqJlq55BwfxPMGeMQ=;
	b=mZktsUUWERUYWvWPvIkp/7TsRLhJW1noyNvvjhzBam5XzM6E4xPlyE4c5Q7Nz8DxCBDrh8
	HttHwiuWJoj4iM1NCsvV5+J82GH8hsgJKmFU2us5nItux0wJdTmtQHB/obnLinQYGvq/B1
	eqs9rzkADutioQiHSlE191luCec1mcs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ukj4HOiJ;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772748274; a=rsa-sha256;
	cv=pass;
	b=PgHoFC5VJR3JXxUjgHp2l6931NQME0OioSNBu5xgyxM8uNUZkig2zJHtdGN2lBIjrbME+Q
	unsKOmd7rAIqgimJvoeE0z+f+ybRy/hcQSzjzpyeqmpB5nV3fMja93DHGvtZ7TLU7XXOCd
	nKr721dzk+ZYTjOuoioI+ruo26d0w1k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YpMRSGQ14DyglRi3rlL522ysswVToJdI2VxIIuqZP6eOhTriBOe6IsxfuT2Sw+SerlErwhe7XWfDsWWUnk4icg+IRIhDax7W4n5lbXLOjBd9uZaiBD1FR3rdpmM2RRY7q5r8udkLRbd1ge0pJbuA77LPIU9+oS4zwIE91j7dwVqFQVzXqHb2M7y/snv/tYOy2cIwpQLk+RM7mJAYC504/pq9YaQ65U3lKsO2O5mGHkOMesdLNqUla/4J7mhSAMFijfH+L5e0Qi0HTyL8zlgKl6EDOJaFiZ65y+ZpMTYeYCTUdmKjmf4adhNJgA/X+RzunuPpCB2TV7dFpWkPtDJfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we0v2QYImFuYNkGgyYnlU9AgluyqJlq55BwfxPMGeMQ=;
 b=G9VJGPDnnSCpG6Z6p9Z2QkTUDdAgl8qLtLAvuJCSYy3KojndL7scvsN8K1OV0/vRIOC3UF0M1FRFRrmjeq/66+Be7Tx+EmbVrRNb2P0HZFyBGngelm83/d2Kp02Rt/mAjewqK6jJrvQK1YP0tOHtxvMHhUJ27PCOgxNC1qJHv5LK1SWwWy6uQ36t19Yi79nkUU/HlvYnIHUrquFkBsL9DS6cUzeYwIpd08xux8AuBOQz6rWNYzb6YzhZi+yhxVrQICioQ9E0jVW+9iBbHl98Baueel1j1rdzCYUwW/cEpxmuByrnAYgSYBihaIJldgxlntVPS8tjCjFlIm21x1NbyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=we0v2QYImFuYNkGgyYnlU9AgluyqJlq55BwfxPMGeMQ=;
 b=Ukj4HOiJuF5/oZ7P5Qk0MWI6TCz59QjcZs856zGOSVM8pmsAAJ9aCvZoJ12M1Gm74PGwNrt+wy4D40ew2v2iq6D5Tk9fZn1awJxROJ63bfQN6/NEuo/tskR8e0tctUKG9Pb8Xk5P/D/UpeBDqo/detpsJgWqDqLr2AtJZGviUNTAkdgb82yrbnYSB7tHNwg+t2DHJMmI5Us1iU2peBqy2t1vG25uEpFcOZEIcrvk0Rlp/a2O4GNLNllq6bENZG9X+TRXxDs1NHHeO2mZhAywDsxXeQbmZbL/It8jeDdp9LlMmr1GT0eq4fQd5F4BcV0fX855biVc+e0q3jBVQP0vSg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 22:04:28 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9654.022; Thu, 5 Mar 2026
 22:04:28 +0000
Message-ID: <ee77cb18-3ca2-4f2b-a1f8-1083b1a9e879@nvidia.com>
Date: Fri, 6 Mar 2026 09:04:20 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
To: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, matthew.brost@intel.com,
 npache@redhat.com, david@kernel.org, Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
 <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
 <CDBCA254-3E40-4BFE-81DE-70DAC9D4222D@nvidia.com>
 <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB8371:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e33930d-fa55-440d-9115-08de7b032b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	k9c/p6sZeCMdlyXVHi6D6SLm3jzY7XvkQefKG3Y27hI356YNz1+rRvlOIeYC9ZxFRJrN37L7lW4dn2AaxfW850sQ1YTRT2ObJ4AEh/RC/gaykFP3G/l+tseHROdkYm6BP5X3n9YtvFDFrIliha48UdudUYWT98CygErWa+sB8zXGZhOiRKWh5oj5gZE6BFV2a0fZyF8BECq4N2MGOKyWOxqfcJnMoXDirx0jf/sheJ/rih0ZyLQnBZ5rcI0Wf74mJgZOApm2ibiIPwLhQm+J+8xx9FXpuEZt+huPiPqfgiiVQRJhXyas86sJ1qFsn0EU5WtPfTc8FlzlFuqSUA2budA3ivk0aVIbQSDBpI0trDA/zS7yDTXEpRXF1NtPUTwWsoxU//0nNYStSVVEAT21r6chnvfcGmJox7c8dZV8eVlThbl8dhqKE7qkThITkH+lhDoM2RgvfDyNEf4LeyhkYh2OpiRt/qKdYxDa3n2f/0V4IWAmrfylP0PzzB7vw3wR6Kka53uEl0uwYOC4HInzcfpQtaThqa50nzUcZ1EjhI67Vr3WFCIWUyV+Txr77NyUnl6aw4kb5QURpDtWGFHNsklfMFX5oDK1x30uv2ArgfNPNG+1NEJ6RVNn1QYpMQzaMhiAv4ydK+3Q+JkpfQoJ27MtkjP2Ffgg5OB9RDJmdnQzYR7/Oacc0DXxkuvaBgexZK44V02gKWnor/a0lTqtzArs1SCiGdjkq1wvihmIhMc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk04YzFuaEVQY2Q1dmNuUVVaSDRKdERmTlhpN01QcUhKdm5vQUV3WlZGelBm?=
 =?utf-8?B?RENVTHJoZmh1QXExMHBLWFdJdFkwNE1vRGkvRnprS2FFRFErbkJLSHFXTUEv?=
 =?utf-8?B?YzAyUEdLM3Z6eHpKcURFVlNKR2VRVWp6NWtOSW1WMWVQaDFhVEo1NlV5RHk3?=
 =?utf-8?B?c0xrUnV0UzNDS3BNUW9Dai80bThlSGlvZmhnUnJ1eldudk9QUHRyUk9kcDV5?=
 =?utf-8?B?aHJqYnMrK2pXbFlJL2RmQmhDSGpqOU4rdWZxeWd2cXhCMjdyZDRxZnFYbmd2?=
 =?utf-8?B?eGxMNkJNNytVbkdSaEJxUXYwLzdLT1NtWTlhcCt4Q1VHZlBUQ0NDdDFpTEtn?=
 =?utf-8?B?NU84M2FuVGxyaVhYS29NZU9icUxaK3hyUnVjOWtwSXowbFRRMnRCZVZ3Sms5?=
 =?utf-8?B?cGFkdVNMQkJ0Nk04MXVoWDJzS3NRY0ZaTnVMckRnODFqYURodmdtT0NJWXh3?=
 =?utf-8?B?cXNBTTRESnVTbHNqSzZkTjRrY0Nla3IyTWhrYXhtWFRxQ3ZBaGgvT2pKOEs1?=
 =?utf-8?B?M2NteGRrTkVHMk1SYlZoajNpQUQrSHd3MEFvY1ovRkZ0L3JKQmlIdEtwcVNR?=
 =?utf-8?B?cThqZUp3a3pLZDJPOUswSkx0aGRuWnBCM0xraWh3eS9SZ24zRDI3c2NSaW1K?=
 =?utf-8?B?eUtwUGdjQjhXejUwV3VRYlZVY2kxeW9IRGNHQzlCeG1tV28wejdzdy81TElD?=
 =?utf-8?B?bjhwMUdjVDJ0TllCSjRiU2RIVkdlMEkzV3pKY0dES0ZTMlBtK1MvY0pIcm5L?=
 =?utf-8?B?YUhYaDJTVUt1Y2NZdXVDTGU5ZDdlVmk1Rlg2QXRuMDZpcWNWeXp5TTY3djlT?=
 =?utf-8?B?SnVpUGNVRGlnY1VaNmd2Nll6TUx2M2JIWEMxRVNKUFVZWWFoRXRsQ3RrVzdl?=
 =?utf-8?B?MUV4UG90YmtxandWbWNJRjZ6TTFnNk9mb0VTTG54Q1ltdHRZWEpQT2k2N0NJ?=
 =?utf-8?B?MEpEUHY4eFpSVnJ4bFZRd21NWm5oczlXTlE1cnlDYzRBaUlUc3QxOUN6bndQ?=
 =?utf-8?B?NWc5QUFQMmFMZi9QVzVPV05wdlVWQVhhdnZwOXFQUEFXSXM3M050TTh4ZWtj?=
 =?utf-8?B?U014SzFEL3QycHZ0U00yUnV3QlBjckV0VVRJdTBQdUw1czJwQ25rei8yVnZX?=
 =?utf-8?B?blR5R3lvL1FGem85cFdxOHQ1SW9oV2l4Q1MwUTF1UnpSeUpTek1xSklnM3oy?=
 =?utf-8?B?QzFNdzdxY2xKc2hVL2FRazhmZ1dhY3ZBUVoreXdJSk96YndZajBSVitUNml3?=
 =?utf-8?B?c0tNU3doUEVpRkJTY3ZKM3NPa1Z1R1AzMWRnbWxNZlhGK1VVRE8zMVJTSlIz?=
 =?utf-8?B?U1VXRTBZMmVLQko4TEQxQVNLSkhNZ0FmWmtwYmlkTWlIcjF2MDF5b1dYUnNk?=
 =?utf-8?B?bEw1QzFMdjhzRGxjN1NmTVQrZC9RckZNZXBKdlVCS1M0dzNPOGszTElOU2hT?=
 =?utf-8?B?aTJJUVFuZlUraHl3MXhEemU0eUlnV2xKcjF3NU1ZbHYyZGF5eGhzb1Z4ZEdr?=
 =?utf-8?B?L2JvdU9YVE4vOEZ0c013NzBIZjNnM2RsZFdESFVqaDVWSFhJU0N4OGFaSHdn?=
 =?utf-8?B?Vk5rOVVkMWhmVGcwRUdEYVo5R0VxOWZkQlg4VDlOUjdXS3E1MVZGNzZJSmg1?=
 =?utf-8?B?bFpja21qK2Z6aWVPcUdhT1JMNGFiMHRjQlNpelVsN2trZSthcEFYUDczR1hO?=
 =?utf-8?B?VGNwV3NZNnUxUDdrZThBSzVvRERUUkM5bnBXeUwwYzRVOUxpNlh3cngvbGl5?=
 =?utf-8?B?RHBaZnpkZFNnWVhlTVNCeUNqM01BOGNraEhtMU9Vb3dta3hkc2t1NGxrdmx4?=
 =?utf-8?B?T1liTjdjcTNyY0xwMWVLVDFSdVN0US84bUs3UzcxSDNKZk1QWUZYRkhNbmJK?=
 =?utf-8?B?TlN3VFlZZEQzdlB0RkFXSm5WTE4zYitxWW4rN3pGVlppLzZ4TXpWbk1JS1g4?=
 =?utf-8?B?UTVvSnRjT2Y3ckdrblZ4M1RXMUtRN0RsN0g2eThDd1pUY2pvMmdNS0NsTm5B?=
 =?utf-8?B?STFCZWp0Y2RwZ3lYMzEzS0prVXpaWVhIaWpjY2gyeGpSVzRvZ2thMnN4T1Fh?=
 =?utf-8?B?TFVkeXJTZXBWYXJoNCtkc21QL3YwS2RqcjRKUUFRbnlPOFYwNURreTVXVHFR?=
 =?utf-8?B?TDVYVTNHVW81elE5R1FVdmhMSGVYek5FUFBvVTJ5QldQQnhjSHMwd0MwTnFT?=
 =?utf-8?B?dWpmTVhHUXRNNGxXeHVqY1FoWEpibkd1ZnJacExlVk1VT1pyb0N0bHlvQTk3?=
 =?utf-8?B?ZUMyL2VuWUZ6ZlkwSlhmWlFwYzBnL2lsbmZGbHdlbGlQQVFJSWduOGNZU1FB?=
 =?utf-8?B?TlZQZ2JqRmRYQTdWU3JROGthRUV6MjZPM0JsT2VTMVR5cUp0OHBiZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e33930d-fa55-440d-9115-08de7b032b7c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 22:04:27.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqEwFzcf4espCttzoEZ2C5Kp/sFPyz+iwm0f8fvU+D/0KfKSiU6vlewyNPAyB1lY8CicKorwChxmm/M7p9ViQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8371
X-Rspamd-Queue-Id: 955B040006
X-Stat-Signature: 34nj5kypaywygn9yzwpefbb7ds73wa9n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772748274-328005
X-HE-Meta: U2FsdGVkX19KKLn7tMl7QmgHBzU8hftnENyNLAwwB1A2cjM54Tqo5/eL/t5KO8nA0J+KqqUK+Kx8MvQ+ASrB+jicn5gzgTM5OR5G+/NrBuSoBD1wqAoKM/oDkigT/zC0bdiKFJeF4P+JrlC10tgvmk5cWd+ZLLOXtKZANV3qaMW3JCLfyAiZNua4dMBFdxIyvfaQ3Sj9+BjY/sJ2Bbr1z91lDyTh66ZYaCQV56hyqv7mAxKEFop7NTFrYrE/iuxT6LkNqf5fpyHMuXRNWZrIsQVhBlKjAdkt2wwnPboP/D6Ute6fBeFhVkJqPNhhS0mUX5BPq5LV7DpbMlKM5/NA/oIZ8hNcofRYKBCGSrDzfKYlnRe2DrZMzYOGtb2GqG43MSlKZXBApeVOt8V3Yf2Nux74SA/FlhF0TjOGp0GMx7LCIPGtu/RVcCXbSvV1hsWn0/jo21aayg4Wd84t5eZiI/Mz1Cqbo9p4yVXKLIZYR14Prq/sfA8Yo/hwPULDO7k4njp1AMidTmFGwvJDFKEDtXTpZ9dkALSqPBw1gQ3I3jIKItUW5PG4141EhE13KtFuGXnUOsEta0nOipWr8JvTMDyxbbNLjitI7ppXnMYUdVzWFpF+AyQm3u+Gb4kzTFYjmZuops9JK/NfEti/Z9F7tL4dUoblSX5pg2l0L0wtPeSmGooz8MuyTNsqtpZkmZhay7pMhqMJO1ewPCFOICyuM2Bv3ecmfDuZHTFEsQxpz8Cv9H28nar2eDVI0L8lBPrLP8foUKCTU7/F0KDt+9Qyoo/8layKba1sNmR2eeoad8fQEEwYqk8vS9GG1gsvQwqfyiSXbonos/1rDpFkZF4795pnbYVC6JpcgdOGEt2PAUosxVCYcVtCI8FX92j30BgfxBAfWGEq+afEQHfj3odbpfed0rFNxwL03DmDGPsja2RZwHAxx1kyrx630bds2WmdxS3JF+4Zax2FuYcrXpb
 WLIi3tbR
 cxVMGww2+2BxLg5+avyHH2JdNZlMJCrwBd/TlyG6/iaCR9OBzFEfggz+OCou1RVL1427ibS9VG596YT6IYkPDop5pEjZ0XjXO0CIadGu6TGtnw8AtoZN4bCC8qFOXM3Zt3rQHzSFThDErcUpPjjuC1IZwJUl9VCmbIyHBSIPHxA1vfm1ZBRoNjIQQO4ohLdXEk7hDvx9CKZlkRt0r5cXIBckDGGFGuS3jN9ZD+4jLo2ydS5CfcXVkYdmfIeT7eZxvjAgjvjRD1n1ovabVDuIVT6LV/Gg5EcwZCxuaNgRE1IOHxmg/DwokfTpJSRoe9hNDFfIi6n8EFmr5Sz8jAHEFe8fpX8fJW5ruJ0m/OLzS2HDUJ+L1qQpj6rshTOJntz+h9CKXTqIuWyjm2uyDdJmY3+o4xW0wTByv9qVgZd1rIhssUE8fIoRkzzkrkAu+Is/eO8dfvpUMG+tqMWm0nZa7vM+XHrFJCK6BWAexC4K+g8EWthNrnjCp+pMhoxU4cchhdHIB4SwwNYvsuzRcOue+doCPgrBdhP/zsk7Olizdaz44wUALXbp4mMCoEzuXJFfx6HJ2dLk4INWgLGzDYQNZCuwHc1NvRKggErItq4/u3ypnJXUraKBd3Bvcxp9sRebKWAan0Z0p7dUru8q4JPlIiwqvy8FvP6aQIWdCQiP8yW0q4CDQAHSk4+dVet52b9ageo0kOz7RqRPm65A4AeiLmQsYOITeNCyjNjUt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 04:00, Usama Arif wrote:
> 
> 
> On 05/03/2026 16:39, Zi Yan wrote:
>> On 5 Mar 2026, at 11:36, Usama Arif wrote:
>>
>>> On 05/03/2026 12:09, Mika Penttilä wrote:
>>>> On 3/5/26 13:44, Usama Arif wrote:
>>>>
>>>>>
>>>>> On 05/03/2026 06:09, Mika Penttilä wrote:
>>>>>> Hi!
>>>>>>
>>>>>> On 3/5/26 01:28, Usama Arif wrote:
>>>>>>
>>>>>>> On 04/03/2026 22:09, Balbir Singh wrote:
>>>>>>>> On 3/5/26 08:54, Zi Yan wrote:
>>>>>>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>>>>>>
>>>>>>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>>>>>>
>>>>>>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>>>>
>>>>>>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>>>>>>>> folio_get() before calling folio_split_unmapped().  On success, the
>>>>>>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped()
>>>>>>>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes it
>>>>>>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>>>>>>>>>>>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>>>>>>>>>>>
>>>>>>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>>>>>>>>>>>> -EAGAIN), the function returns without calling folio_put().  The extra
>>>>>>>>>>>> reference is never released.
>>>>>>>>>>>>
>>>>>>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>>>>>>
>>>>>>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>>>>>>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>>>> ---
>>>>>>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>>>>>>>>>  	folio_get(folio);
>>>>>>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>>>>>>  	ret = folio_split_unmapped(folio, 0);
>>>>>>>>>>>> -	if (ret)
>>>>>>>>>>>> +	if (ret) {
>>>>>>>>>>>> +		folio_put(folio);
>>>>>>>>>>>>  		return ret;
>>>>>>>>>>>> +	}
>>>>>>>>>>>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>>>>>>>>>>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>>>>>>>>>>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>>>>>>> -- 
>>>>>>>>>>>> 2.47.3
>>>>>>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>>>>>>
>>>>>>>>>> Thanks Zi!
>>>>>>>>>>
>>>>>>>>>> Just wondering if there is a reproducer for the issue and how the fix was tested?
>>>>>>>>>> I expect migrate_vma_finalize() to be called for folios, even when split failed and
>>>>>>>>>> drop the lock.
>>>>>>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
>>>>>>>>> If so, how does it distinguish between split folios and failed-to-split folios?
>>>>>>>>> By comparing source and destination folio orders?
>>>>>>>>>
>>>>>>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  We do a folio_put
>>>>>>>> on the src in finalize, if it is split then on all the split folios as well.
>>>>>>>>
>>>>>>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>>>>>>> it adds a refcount for all input folios, but only drops a refcount
>>>>>>>>> for the split folio. Isn’t it cause failed-to-split folios to have
>>>>>>>>> additional refcount?
>>>>>>>>>
>>>>>>> Hello!
>>>>>>>
>>>>>>> Thanks for reviewing everyone. So its very difficult to create a reproducer I think
>>>>>>> the extra reference would need to appear after migrate_device_unmap() but before
>>>>>>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger reliably from
>>>>>>> userspace.
>>>>>>>
>>>>>>> The fix came about when Nico indicated there might be an issue if split_huge_pmd_address
>>>>>>> fails in my patch [1].
>>>>>>>
>>>>>>> Below is my understanding of how refcounting is working over here step by step. I
>>>>>>> might very well be wrong on this, and the refcounting is a bit all over the place
>>>>>>> and I might miss a reference change somewhere so would really appreciate if someone
>>>>>>> can confirm this!
>>>>>>>
>>>>>>>
>>>>>>> 1. migrate_vma_collect_huge_pmd():
>>>>>>>   a) folio_get(folio) -> +1 (collect reference)
>>>>>>> 2. migrate_device_unmap():
>>>>>>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>>>>>>   b) folio_put() -> -1 (drops the collect reference)
>>>>>>>
>>>>>>>
>>>>>>> Without this patch fix:
>>>>>>>
>>>>>>> 3. migrate_vma_split_unmapped_folio():
>>>>>>>   a) folio_get(folio) -> +1 (split reference)
>>>>>>>   b) folio_split_unmapped() -> fails
>>>>>>>   c) Returns error — without folio_put() which is the fix
>>>>>>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRATE_PFN_COMPOUND
>>>>>>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGRATE), restores the folio:
>>>>>>>   a) remove_migration_ptes(src, src) — re-establishes user PTEs
>>>>>>>   b) folio_unlock(src)
>>>>>>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>>>>>>
>>>>>>> The split reference in 3.a is never released and the folio has a permanently elevated refcount.
>>>>>>> Unless I missed a folio_put somewhere for the refcount increase in folio_isolate_lru() (2.b)?
>>>>>>>
>>>>>>> Please let me know if this makes sense!
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>>>>>>>
>>>>>>>> Thanks! Yes, the patch makes sense
>>>>>>>>
>>>>>>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>
>>>>>>>> Balbir
>>>>>> I remember stumbling on this while ago also. The folio_get() in migrate_vma_split_unmapped_folio()
>>>>>> is balanced with put_page() in __split_huge_pmd_locked() (freeze = true), can't fail for device pages.
>>>>>> Folios at this point are unmapped but have 1 refcount from "collecting".
>>>>>> After folio_split_unmapped() the refcount(s) is still 1.
>>>>>>
>>>>>> So it seems the code is good as is? A comment though would be good for the extra folio_get..
>>>>>>
>>>>> hmm I dont think the put_page() in __split_huge_pmd_locked() is there to balance the folio_get() in
>>>>> migrate_vma_split_unmapped_folio(). There are other points where split_huge_pmd_locked() is called
>>>>> with freeze = true [1] and they don't get a reference before calling split_huge_pmd.
>>>>>
>>>>> I think the folio_put() in __split_huge_pmd_locked() freeze = true case is there as migration
>>>>> entries are being installed?
>>>>>
>>>>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334
>>>>>
>>>>>
>>>> Yes normally you want to drop the reference when installing migration entries but in this context
>>>> you have already done the collecting for the THP folio and you want to balance with the folio_get()
>>>> the put_page() to keep the refs unchanged. Is that right Balbir?
>>>>
>>>> --Mika
>>>>
>>>
>>> Hi Mika,
>>>
>>> You are right, This patch is wrong. I tried the below diff to force folio_split_unmapped to return
>>> -EAGAIN. I ran tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_private.migrate_anon_huge_err
>>> to trigger the path for folio_split_unmapped.
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 8e2746ea74adf..6df33b4990a13 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4140,6 +4140,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>>>         if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
>>>                 return -EAGAIN;
>>>
>>> +       return -EAGAIN;
>>> +
>>>         local_irq_disable();
>>>         ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>>>                                                 NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>>>
>>>
>>>
>>> I inserted a lot of traces to keep track of refcounts [1]. Without this patch, I get
>>> ....
>>>        hmm-tests-129     [000] .....     1.476233: __migrate_device_pages: SPLIT_UNMAPPED: folio=ffc536e2c4100000 refcount=0 AFTER error NO folio_put
>>>        hmm-tests-129     [000] .....     1.476234: __migrate_device_pages: PAGES: split FAILED folio=ffc536e2c4100000 refcount=0
>>>        hmm-tests-129     [000] .....     1.476236: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 dst=ffc536e2c4100000 src==dst=1 refcount_src=1 mapcount_src=0 order_src=0 migrate=0 BEFORE remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.476237: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 refcount=1 mapcount=0 AFTER remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.476237: __migrate_device_finalize: FINALIZE[0]: src=ffc536e2c4100000 refcount=0 AFTER folio_put(src)
>>>
>>> i.e. refcount = 512, which is correct as split_huge_pmd_address was successful. Full output is
>>> at [2].
>>>
>>> With this patch, I get:
>>>
>>> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_FILEPAGES val:-511 Comm:bash Pid:63
>>> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_ANONPAGES val:511 Comm:bash Pid:63
>>> ...
>>>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pages: SPLIT_UNMAPPED: folio=ffed210c840f0000 refcount=1 AFTER error folio_put FIX PRESENT
>>>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pages: PAGES: split FAILED folio=ffed210c840f0000 refcount=1
>>>        hmm-tests-129     [000] .....     1.468318: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 dst=ffed210c840f0000 src==dst=1 refcount_src=1 mapcount_src=0 order_src=9 migrate=0 BEFORE remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.468357: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 refcount=513 mapcount=512 AFTER remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.468357: __migrate_device_finalize: FINALIZE[0]: src=ffed210c840f0000 refcount=512 AFTER folio_put(src)
>>>
>>> refcount=0 means the folio would be freed which is not correct. The full output is at [3].
>>>
>>> Thank you for clearing this up!
>>
>> Thank you for doing the investigation. Can you send a patch to add a comment
>> in migrate_vma_split_unmapped_folio() about this to avoid the confusion
>> in the future?
>>
> 
> Yeah this was really confusing.
> 
> Does something like below look good?
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf024615..a302f9d3ce921 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -910,6 +910,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  
>         folio_get(folio);
>         split_huge_pmd_address(migrate->vma, addr, true);
> +       /*
> +        * split_huge_pmd_address consumes the folio_get reference above.
> +        * Therefore no folio_put is needed on the folio_split_unmapped
> +        * error path.
> +        */
>         ret = folio_split_unmapped(folio, 0);
>         if (ret)
>                 return ret;
> 

The comment should come above folio_get and state that

/*
 * folio_get() is required because this reference is to be consumed
 * by split_huge_pmd_address() for frozen entries
 */

>>>
>>>
>>> [1] https://gist.github.com/uarif1/65e1e816af7aa0ae38dd6ec64d62a993
>>> [2] https://gist.github.com/uarif1/79ea9500667daa4e2ef09cb5d308f041
>>> [3] https://gist.github.com/uarif1/8a35a6c65ba8b3a1c1dfe72dc30e821d
>>
>>
>> Best Regards,
>> Yan, Zi
> 
> 

@Usama have you figured out where the original issue you are seeing stems from?

Balbir



