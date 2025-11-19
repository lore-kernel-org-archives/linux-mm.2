Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2855CF58E8
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 20:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DCC6B007B; Wed, 19 Nov 2025 15:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865276B0088; Wed, 19 Nov 2025 15:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D746B008A; Wed, 19 Nov 2025 15:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9206B007B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:35:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F41913B4F4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:35:46 +0000 (UTC)
X-FDA: 84128512692.13.0D4DBB4
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FA5F2000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:35:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Itu9oUpb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763584543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nu5f4MANVX0Ifsx5vnCMniUfqnYex/x45nDU/xzBbsw=;
	b=5i8ZiZKjUlBWnmSFp0vo/uQWFhvty2awf/OQAZ3fXjHuw2kylbAeexjNQ4g5QKE9zZqjiy
	vleZW8mbWPhzMHXTbiSwAZbe5Wjw2RrIx7nG4r0Mljq7xz21XKzTk8w7vYbngbr12D/8ou
	H9uZ6+xKVxUksUEle4DgsdJ23eMJu6Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763584543; a=rsa-sha256;
	cv=pass;
	b=jiJdxAc/eAV4SlJ7bXeNix7dZ+Bb9SBM5Azp+lqpFb+rOH+gUpmA+S1BVGX7dKY8iwLpbf
	ReKwJxL+8ji+D5KmBHvJWrde6mfwfnPezVVLzYzb0bjw2SFzMG+lm5Fb1WaRQ0+pkyvf/z
	9SDpbLrM2YO6Zl1sNBphIrZphcV2B4Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Itu9oUpb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5aSUE4vM3Y2Sxy2JRlFNaEMWWBXyy5PZt1vE+KpYI12QDPzd33o4+kLoA3/z5X6UsIglkGOpoERUOyTJCh8csowJZVFFvpZ5o5d5I+iKfnLaXoX5RkhmThCL9/ZnmZDQPl6bWcHMOeIbX+D5ZOFBxYHQl1aUOw1MpJUdO0oMxrsYynPAaiD2m6dHiziQ3I2t/0iI63i8YMr815YmGqv5wbBysCxGDquGMLY2td8bxSxO2sslr/3w0jZopF6qkhSP30CP3ogQJwZS7NDwVaEuKfZTsc4dkpxdL83Nu7Uh7/Kw8fpLZIX3mIWQak6iA50dtgPuOrluismvZcnn2z28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nu5f4MANVX0Ifsx5vnCMniUfqnYex/x45nDU/xzBbsw=;
 b=LjQogwhvNxMx7U015G/nhtr6datkHGhjqnbouboe0EPx1S/dvs3i69ZMTciWPKlt4SJdDcDI5F2O6VzjCIntZiBe2KfFJ4kzuMFwP6umBYuACwf/ZTR+HWAwUh6MpC1H35F33+42Fn5rAz9Mt3BLT/z6EBGdX1d7wCbvq4pPrvyDYTE5ABTN+PRUXvwFrNC5+GCY8/Hcj8i+RFtCtwamNSz72dXVQ7dsp9Z0AfcxqoDl59ErQDKpt9ZlrqBMHfcynfnMPZlYu+rOl11nAzDnWt4E45rrdkKdTlslZ3eGTuYvTZdaxyp59wuLPoda3VX1HXEzu47eW2pZMQMlEDgyOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nu5f4MANVX0Ifsx5vnCMniUfqnYex/x45nDU/xzBbsw=;
 b=Itu9oUpbrMAM1XIEjO4vwBmo+lkMHNdHR+AKVPZqQQpeyHD/9MurDWHgZUgnxTwOT5EdUKq57+k1wdPikdxXvKsQTUxg2uFuB3F3GCHXgh9knNsPXmSxFBVi3K+EC4po51ZbWX7MDqrRcbLjKqKyKIsClvJ4M8tgiibmKPc5vVDUjAN47KWphIvusur8RVbj8QzaaZ941AGR/CDm2czrZH78fpTjsUPkCcHwcgMt+SLV/EnyDrtnoL2jIVR4bgu20QiC4Sz+kboe+AUOkhHhPQ2u95RFQCLp7n0tFQEhCw27Syd6nhE824MsTXhXgJFV5f99Kx2ZGykUuiWNApX0gA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9418.namprd12.prod.outlook.com (2603:10b6:408:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 20:35:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 20:35:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Matthew Wilcox <willy@infradead.org>,
 david@redhat.com, Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com,
 linmiaohe@huawei.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Date: Wed, 19 Nov 2025 15:35:33 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A78D9086-F3C5-46D7-A9B1-8CB4D32A4814@nvidia.com>
In-Reply-To: <CACw3F50OzEuVco762kNS1ONyzFU1M6MQUjYd1ybtHCMcg6pmdA@mail.gmail.com>
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org> <aRqTLmJBuvBcLYMx@hyeyoo>
 <aRsmaIfCAGy-DRcx@casper.infradead.org>
 <CACw3F50E=AZtgfoExCA-nwS6=NYdFFWpf6+GBUYrWiJOz4xwaw@mail.gmail.com>
 <aRxIP7StvLCh-dc2@hyeyoo>
 <CACw3F53Rck2Bf_C45Uk=A1NJ4zB1B0R1+GqvkNxsz3h3mDx-pQ@mail.gmail.com>
 <5D76156D-A84F-493B-BD59-A57375C7A6AF@nvidia.com> <aR257PivQXpEGbKb@hyeyoo>
 <CACw3F50OzEuVco762kNS1ONyzFU1M6MQUjYd1ybtHCMcg6pmdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAP220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: 011a6117-16db-4eb3-13f3-08de27ab32bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmR4RTVsRTBJOHdXL20rMHpvTkxaNitmemdSVy95dTJUaVhzZDRFN0tKV1ZC?=
 =?utf-8?B?K21CbzAvaFZGckk4dUZVc1VOZnNoQ3dFNTNDUUhjSzlBQ0k3M2drRjh5RGN6?=
 =?utf-8?B?RWdPcGJuV05PcXE4ZXdjR1ArVnJMckRtUEF0QW1YbExpVDRBclZOelhFejNy?=
 =?utf-8?B?dVZCa2hzeFR6dHljNEN6bUVIbzdIMUQvMmNnUG81dkpGTFdMN3hwdWZoK3JN?=
 =?utf-8?B?amNiTVh3a05WYzZaYTFRcEJuMkg2QU5uV3k2SER4RjA2UmpCWk9pKzdmc3dI?=
 =?utf-8?B?dVpLdWxETWh0UUYyb1dUU1VWM2NCR2hyYlNTbHYwejladkJQOUJ2d3dBOW40?=
 =?utf-8?B?K1IzQWdndEQ4TzQwYW5GN0ZvNWJSWWtkaW1zOXI1WWRQZjg2RURZYjIybXBw?=
 =?utf-8?B?TVM0eDhacnJIR1BBNkF4UzgvQllGQkVNZlNobzVaUlpWK3kwQXFRc3dGYndV?=
 =?utf-8?B?SGQ3WWc2bTlRaHhsMEo3dnlHbFhvSTNMUnd5YU85RzJua2Nubm9CYUlJeVFT?=
 =?utf-8?B?MzBnM09tanpDWGJMMlNwOE5hWERWNmEzb0Nza1lLYkQ2MDBNUU1DNDN0RE1K?=
 =?utf-8?B?WjB3M2JDdG5jTWYwa2xGd1B5TTF2ampFditxOUNrNHA5bVh4c1lOcFFGOVVR?=
 =?utf-8?B?VFRwam9qOENlWHJzM0l1OFAwakxvMm13V3Z2aTJ1MXF1RElPYVBWRW8xQm95?=
 =?utf-8?B?NGViK0R1NDlUNmlBV01maVZXY044Qlpvd25nSmpNcm5lTGxkeDhmeTB4RmVF?=
 =?utf-8?B?UHFrYXlRdC9GYjlIb1FBSlZScXRLQ3l4M3VTaEpaMHVROCs3Ym9KeDVWTWpC?=
 =?utf-8?B?c2tRZGlSTG9YenFRbWM4RVFuMHVibVF0OVdZMVVQRFAzS3ZkL3dlQU1nZU5a?=
 =?utf-8?B?ZGtnbE9KdEN0OHY3MnhxYzBpdUQvV0k4ZDllV25GY2ZqK0VSOE1PYXFGclAr?=
 =?utf-8?B?MVlQZHpyOUM5OHdjcEZhQ1Vvb3lnTXA0OFV3MC9UL011ZjNnN1ArVnJSMEM1?=
 =?utf-8?B?Y1RoUWdBYzIvaUVOVWNka0l2ZzVGSE1JdlpVU0JIaXhjYVdCeEx3NElFQUdJ?=
 =?utf-8?B?bWZLakZYK2d4YVNWQXdwNmtodXp3UnNPR1RqT3NIZGdrbGNka1NxNTRERkEv?=
 =?utf-8?B?aEJiYTRTVUF1Q09DTXNDRTVvbjNZRzFKOHBPSnFlYVh0Z016bjdEZ2pobTZO?=
 =?utf-8?B?M0tjQ0pqRGJHWnJ2dUMycnhHRWt0K2dBQm1WemJCTitNdFdTd0hCZkJaZGd1?=
 =?utf-8?B?eHpPL1ZmRzBEbGtqTVdaU2JQby93bzVlUGFyS1FzQXNmMnRvZFFEZUZZZUZi?=
 =?utf-8?B?YUNKNEhLcGtyYk1iRWpERDVlVklrVnI2MWlCWGE5MERKUVVyS3doUldUd3JZ?=
 =?utf-8?B?enpxZHU5L21sYlRlOTVMSmNhN1dqWnllTEJNbTZxUEs4emdid2NnajhiNUI4?=
 =?utf-8?B?UVVVRFEvdi9wVHN2UEt3Mzk0UEVQbkFEMm42S1JIMnRzSmk3R3U0K3ZsK1hT?=
 =?utf-8?B?Nkpja1NXekZqd2I3TE9Kcm9uQnNGWW80NU9sTTBYVGFqTVVxZDNtOUNaV3I0?=
 =?utf-8?B?aUdkM1doTVVHeXErVzNQU1VEbnY2WUtWY3JvdHFRbFpoc25YYjN2bkNpR0dw?=
 =?utf-8?B?Y1hRSUhyb0xoRzhIVTJvN3hINUxMYi9yckFlR2hDcWhSTnU3ZDArcUJodU9G?=
 =?utf-8?B?MUhkc1pKUFBzbWRvWUo5RElGdTdUbitQK3M4eHNzOHRDN24zY3FxZ09BYk5u?=
 =?utf-8?B?ZUJ1cjd6RHlrblZ3TklRVThqQUhMUmc1S2h4STZhNnVKRndCQTlKVkp2d2dk?=
 =?utf-8?B?Rm5NS1BUZVB3YVYyVVZpSGx5NnZWcHJma015T0xPTlZBV3VUMkU0NWNkeUFD?=
 =?utf-8?B?R3lLdU44L2o1S0VNTDlDU2VvUDRibCtBUkdiWEp3UHFJMW14YkZxL3pTcnhJ?=
 =?utf-8?Q?SM2KOsuiWMq1Ihx8sjSrLp/zZurmhCIF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUJrS0RwLzJoM0dSeUVjcDVVUnZvbkNxU1ZyeGN4aVBLSkZvK3ZEU1l5Ylhq?=
 =?utf-8?B?SXlReThPaktFWUhtSGZ6d01xSGJZOElUVmRMbGtJNWZPdUM4bmlLdllrRXJy?=
 =?utf-8?B?dWRKR0MrZUJYaWY4K05menlmS2t5SGpvYXVIc0RneURGenN2aTh0dzA0VkNa?=
 =?utf-8?B?NktKNStTeTRHdm5yd3FUZVNCRWpRWkR6Q1YwenZqN0MzL0RXWDRka0VtQ3Iy?=
 =?utf-8?B?b3ZqN2cxckk5ekJabEJ3V1RQSk5QemtkTlRHN0JZbUwwb0h6eWROYXQrblZz?=
 =?utf-8?B?RlN2WlhpT3NoanFmSU5BTnBqZnBXd0dOZFNWdU5USkxIV2o3b0tGUGRjYmli?=
 =?utf-8?B?R2hZSWpxRFA4WDdIUUJpK2E1eU5rcHA0cE5hS1lSaWZCd0ZKdUNFa2hJUGtl?=
 =?utf-8?B?TU54dGtRblQ2Y05haUtLZVhlQTNBL05YODN5Mzduc0JkMEUrUndnSzhKeXlQ?=
 =?utf-8?B?Y3RVdVI0NkRKWUh5NFRyTG55Nnd3ZFo5STZSSkY3UzVYUXg3UXd1dmxuT2Yw?=
 =?utf-8?B?aVQ0cXVHTzErQmQ2Y0Z3SHpIK0p6RnBpMEUzS0J3anRJY2srSTMyNFA1UFk3?=
 =?utf-8?B?dlpyNXFBQXg3d3NvWXR6NzV3MnFMU3hwdVVEZ01nU1JYeFdsMVgrUTNIZllk?=
 =?utf-8?B?T1IvL0pSOGdoc2JCQkVIVy91SGxjUnZ5TTFhRzlGM2hRSEkzQXM3cVlGVkg1?=
 =?utf-8?B?M2RSSDFhaDdjMVZaOXBvazVDdlE3ZzhiRE1xTlpQWEhSeEZvMGlKOEQxQ1pV?=
 =?utf-8?B?T0dBaWNHV08wSjJXZndqMy93OVZROXUxSVpqdDdkNU9GZFFmVGtVTDVKOW5D?=
 =?utf-8?B?VVJxN1ljbGdJRHdza3huaWZDUzhhMU1xVnFpTFErNkxsV2pEQWUrQ0FrUE9W?=
 =?utf-8?B?YjZvb3plTjhIYk43QTYweWsrNENVR05kbDk2UUx6b0RnYlRIb3J3QW8xa3hw?=
 =?utf-8?B?UHBSY3FJYXgwT204cXVQRlJwdkU1TG1OTTFRRmRnRUIrOVBucUhzOUszcVRB?=
 =?utf-8?B?R1NxQUYxNkV2dFJyUlZ0RkVDUHBMeUt1UWFxN3lMVGtzMGdpVW5HNFNrY3VO?=
 =?utf-8?B?d1RLRnhsZmFJQm5rVEJaNmhxUmFYeW03c1BBUHdXNEtmS3Zlc1lvMTVScTk1?=
 =?utf-8?B?MkM1dUpXMzRlblBSREZZUm9iYnA2cnM3dzZvbWVhbkxZcU1VTW1pYjVqMTY5?=
 =?utf-8?B?U1p4azV5b0NaeHBVSjAwbGg0WUZEaklNSnJ6b0x1b0J0Zkx5SWZRcmFUbkI0?=
 =?utf-8?B?STMwQ2dNNkRnK0t4V05pL2UvN2FSRDl0WG9wSWFhNHRZMUVSamxodTFoZENQ?=
 =?utf-8?B?OURVdmRDekNQMXJYWTFYWE9xaFhCWllWcEFsYVgyL05ieXRaY25UeXN3WXFN?=
 =?utf-8?B?R0RjRDZmQWg3NWhiWjFBZGw0T3J6aHFTQ09SNEhERjB1UmpwQXozK29PaXVS?=
 =?utf-8?B?aUdybCtVOUxJNmU3TmZVbmp6T0RGWnVaVVR0Z2VHYzJjK0VaeW1DVC9FS21m?=
 =?utf-8?B?VWFJSldwbzJva2UxaVk2cldKek95UHZtM3laNUZoRVpnRjBtSDdwVGxzZHRZ?=
 =?utf-8?B?RHNrUEJxc3lWYzlvdEZsY3k2S2RxNFRaeUY3cDh6ZkR1V3lzU2dDWGJCRk5y?=
 =?utf-8?B?MTZOYlpUMk1DczQrWnNBVEtFUjN6Q0RidU5ESWRSRTViK2ZpbVkxQ291R3I1?=
 =?utf-8?B?WHQwY01aSUFyVEprd0xqbGtIa3UrYjZOMWVReWo0Z3pjU0k2L0lxTDk5eGpH?=
 =?utf-8?B?U3poK3FTUTViVGZ2S3lIcFZNWVlWYXlGQWJSbnBTQUVweXNQbWlWTnEremZ3?=
 =?utf-8?B?MDhWYWZmYVdlNmd1T3IzQWNvQ0xGK1lXTkVBYjZPakZCTkloWjhHdnJubUxk?=
 =?utf-8?B?c053MkVnbkQyOE8vUE9jaTcyR3VjcWpFS3gvOUFHa3QxOUlFU3ZRTURURTMr?=
 =?utf-8?B?TXY3aWN2clNHNTA5cFJRNWFIcXFRYnVOUW1RM2ZuZGo0TkozR1BWYzFtYXFP?=
 =?utf-8?B?K0VHQ3hsbjAyUWJoTHFITzExSVk3R2VlcExBb0QyREhOa1B0bmF3UEI3RG5F?=
 =?utf-8?B?ZEVZK1A3NHRvM04wbmp1UmtiNWhLbS9PcE93ekNSMEMraEVrQ2gxUEhzY2lu?=
 =?utf-8?Q?oNGuj3UoKTDS1mivhBxFGJnTW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011a6117-16db-4eb3-13f3-08de27ab32bc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 20:35:37.8471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgLACzeT6s+MADQyYWInze3XROEe+63iz1NKGLctk8vRvcGsbI+z+1x5JL9Va81L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9418
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1FA5F2000B
X-Stat-Signature: ykthdt6599m6ia3ea8swdgk1d1ys884c
X-Rspam-User: 
X-HE-Tag: 1763584542-994692
X-HE-Meta: U2FsdGVkX1/eUEDO/9r9uN0QGzNaOaj9/ok8K4dJxOd4XmehbFPSue8myDVaXhaSO9AKdw+Id0PsY92GgzO+Pm0orOZuTPDXyMgg4BQG/6Gl29AsfpObdBKjy/X62+P/IUE0SUEWLuxKTU03GsBe3VSYr/KloBH6tOO8G9q2MSo3qUsdnA9gvJybQjkq2z7F1eLGw/4pFnWElGHpUsjTk2QZezMQhe9FjK4NMuSWqTJMat/M3bVyUvQMhVjattUnDSVWjhReqPIm1RfLYk/4/Teny1vacM2dxmM2gSVyRs3VCPDamTDGuLf6zoGd0mqxCMk3yP5+W3oSACSE9azmo1971122AAEkxKVt3ZsZgzWFQFqTXwQWVWOakoPmuMnhwyRY+bJqF0ZQwpwSpkPzPbgzJ4WVRMJ+/U/2GeXabqhYCVpNfrG8O6r7DZ7nfk7u7nkYLQG8tQUAObduIMCAavMiGoTBVvD/me5fojByNUoef9I87QM6xdEbvOIVBG8xiT56jJwFUXHapsv8cunp9tj5XJIfw7RedvziebR0jdlb+h73WwqgFQCf/D164ZOqx/iUd1PbLmWD8Poz/qzWdn8/6qFIzOt5YeH5BYbillYTUaRlJ6/YRjettI/kSTp/aMVx4WIBoPqj56r5IUAun+m8e3exKx5EPtGXIk1tvh//fueuJleD3PTYlFltckyKCZFTrVgOO2C8ctPvqkB8piiqPqZGK8KtK9Y+iVQxWzSZPE8NL1+oLTmf3nNy/8d3D+YGJFDjvRg7lS8nTX/0zKpqBrkvf9VhbyZ70NN9W0m9x7RDU9EhOoPo+dlVmhx8VxrokivNXEq/OSa8LGRndJ35CA/QBD2IAqQ2NoFaTk1EY1aItbd9/OohK6rqJ/LiMN0AeP0Hg/c+boVHK421f+bgrOO036MlivcN2mJuJqad6QDFTRnCXtYsa/+P4O60O1FSiHYk0zDAFJWk6Bk
 5T/OpWUF
 FX9qunKREfxLOnWax9kDDtY33oOjqKyNb0SgCwLSF7hccX9jyxJWZSfyIitBVO4dMxuXVAtsfd1zcN4rayMFLqItJVe4Wn3jbRHkmNV50CSt6x4YzvYV+KUnPe5b9Lnljwgji1rfsIB512r5NuKlfzO2g6JzViVfWHbi1XE3bjSzAaFwZPqnWcdEpi+s6kJ9QAyrDTX69NhWkKRwWU00xUWmb7V3oUG597rcbiHhe45X9t8SPDsgkMMYmRvTfjsgEEUH63lTYuJD3OYcV/CxbEW9KSofb+18Y+6qT8WR9lLHV86UcJ3MsvVTU+fyu4bC3Wigikcug2zPvnxwKE4VweJL69YMfePJUppGYgwzcw7jKf6q88M7WZvD8lF2dkop0ucyy/v1cv7szBVlGq0hQ4mkcJSpRRKFwmY6sJer9+1zDNSPxz9cb5Rb11v9xljNDqwhqqkmgd7D3+FhDpxLCkK8Sxjlxh10hKrhGlQo0NY2f4hNUNd09miZ6ezbBZtOBYHk8Kyd1HEhIzAdPDCkay8Kv1Uk/qVVZzHfmrXD8E3DFfNRIYY7u8QCEUKTEKYByu89e+4GI2nIp4PqZ+CYtcQR/Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 14:21, Jiaqi Yan wrote:

> On Wed, Nov 19, 2025 at 4:37=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> =
wrote:
>>
>> On Tue, Nov 18, 2025 at 04:54:31PM -0500, Zi Yan wrote:
>>> On 18 Nov 2025, at 14:26, Jiaqi Yan wrote:
>>>
>>>> On Tue, Nov 18, 2025 at 2:20=E2=80=AFAM Harry Yoo <harry.yoo@oracle.co=
m> wrote:
>>>>>
>>>>> On Mon, Nov 17, 2025 at 10:24:27PM -0800, Jiaqi Yan wrote:
>>>>>> On Mon, Nov 17, 2025 at 5:43=E2=80=AFAM Matthew Wilcox <willy@infrad=
ead.org> wrote:
>>>>>>>
>>>>>>> On Mon, Nov 17, 2025 at 12:15:23PM +0900, Harry Yoo wrote:
>>>>>>>> On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
>>>>>>>>> But since we're only doing this on free, we won't need to do foli=
o
>>>>>>>>> allocations at all; we'll just be able to release the good pages =
to the
>>>>>>>>> page allocator and sequester the hwpoison pages.
>>>>>>>>
>>>>>>>> [+Cc PAGE ALLOCATOR folks]
>>>>>>>>
>>>>>>>> So we need an interface to free only healthy portion of a hwpoison=
 folio.
>>>>>>
>>>>>> +1, with some of my own thoughts below.
>>>>>>
>>>>>>>>
>>>>>>>> I think a proper approach to this should be to "free a hwpoison fo=
lio
>>>>>>>> just like freeing a normal folio via folio_put() or free_frozen_pa=
ges(),
>>>>>>>> then the page allocator will add only healthy pages to the freelis=
t and
>>>>>>>> isolate the hwpoison pages". Oherwise we'll end up open coding a l=
ot,
>>>>>>>> which is too fragile.
>>>>>>>
>>>>>>> Yes, I think it should be handled by the page allocator.  There may=
 be
>>>>>>
>>>>>> I agree with Matthew, Harry, and David. The page allocator seems bes=
t
>>>>>> suited to handle HWPoison subpages without any new folio allocations=
.
>>>>>
>>>>> Sorry I should have been clearer. I don't think adding an **explicit*=
*
>>>>> interface to free an hwpoison folio is worth; instead implicitly
>>>>> handling during freeing of a folio seems more feasible.
>>>>
>>>> That's fine with me, just more to be taken care of by page allocator.
>>>>
>>>>>
>>>>>>> some complexity to this that I've missed, eg if hugetlb wants to re=
tain
>>>>>>> the good 2MB chunks of a 1GB allocation.  I'm not sure that's a use=
ful
>>>>>>> thing to do or not.
>>>>>>>
>>>>>>>> In fact, that can be done by teaching free_pages_prepare() how to =
handle
>>>>>>>> the case where one or more subpages of a folio are hwpoison pages.
>>>>>>>>
>>>>>>>> How this should be implemented in the page allocator in memdescs w=
orld?
>>>>>>>> Hmm, we'll want to do some kind of non-uniform split, without actu=
ally
>>>>>>>> splitting the folio but allocating struct buddy?
>>>>>>>
>>>>>>> Let me sketch that out, realising that it's subject to change.
>>>>>>>
>>>>>>> A page in buddy state can't need a memdesc allocated.  Otherwise we=
're
>>>>>>> allocating memory to free memory, and that way lies madness.  We ca=
n't
>>>>>>> do the hack of "embed struct buddy in the page that we're freeing"
>>>>>>> because HIGHMEM.  So we'll never shrink struct page smaller than st=
ruct
>>>>>>> buddy (which is fine because I've laid out how to get to a 64 bit s=
truct
>>>>>>> buddy, and we're probably two years from getting there anyway).
>>>>>>>
>>>>>>> My design for handling hwpoison is that we do allocate a struct hwp=
oison
>>>>>>> for a page.  It looks like this (for now, in my head):
>>>>>>>
>>>>>>> struct hwpoison {
>>>>>>>         memdesc_t original;
>>>>>>>         ... other things ...
>>>>>>> };
>>>>>>>
>>>>>>> So we can replace the memdesc in a page with a hwpoison memdesc whe=
n we
>>>>>>> encounter the error.  We still need a folio flag to indicate that "=
this
>>>>>>> folio contains a page with hwpoison".  I haven't put much thought y=
et
>>>>>>> into interaction with HUGETLB_PAGE_OPTIMIZE_VMEMMAP; maybe "other t=
hings"
>>>>>>> includes an index of where the actually poisoned page is in the fol=
io,
>>>>>>> so it doesn't matter if the pages alias with each other as we can r=
ecover
>>>>>>> the information when it becomes useful to do so.
>>>>>>>
>>>>>>>> But... for now I think hiding this complexity inside the page allo=
cator
>>>>>>>> is good enough. For now this would just mean splitting a frozen pa=
ge
>>>>>>
>>>>>> I want to add one more thing. For HugeTLB, kernel clears the HWPoiso=
n
>>>>>> flag on the folio and move it to every raw pages in raw_hwp_page lis=
t
>>>>>> (see folio_clear_hugetlb_hwpoison). So page allocator has no hint th=
at
>>>>>> some pages passed into free_frozen_pages has HWPoison. It has to
>>>>>> traverse 2^order pages to tell, if I am not mistaken, which goes
>>>>>> against the past effort to reduce sanity checks. I believe this is o=
ne
>>>>>> reason I choosed to handle the problem in hugetlb / memory-failure.
>>>>>
>>>>> I think we can skip calling folio_clear_hugetlb_hwpoison() and teach =
the
>>>>
>>>> Nit: also skip folio_free_raw_hwp so the hugetlb-specific llist
>>>> containing the raw pages and owned by memory-failure is preserved? And
>>>> expect the page allocator to use it for whatever purpose then free the
>>>> llist? Doesn't seem to follow the correct ownership rule.
>>>>
>>>>> buddy allocator to handle this. free_pages_prepare() already handles
>>>>> (PageHWPoison(page) && !order) case, we just need to extend that to
>>>>> support hugetlb folios as well.
>>>>>
>>>>>> For the new interface Harry requested, is it the caller's
>>>>>> responsibility to ensure that the folio contains HWPoison pages (to =
be
>>>>>> even better, maybe point out the exact ones?), so that page allocato=
r
>>>>>> at least doesn't waste cycles to search non-exist HWPoison in the se=
t
>>>>>> of pages?
>>>>>
>>>>> With implicit handling it would be the page allocator's responsibilit=
y
>>>>> to check and handle hwpoison hugetlb folios.
>>>>
>>>> Does this mean we must bake hugetlb-specific logic in the page
>>>> allocator's freeing path? AFAICT today the contract in
>>>> free_frozen_page doesn't contain much hugetlb info.
>>>>
>>>> I saw there is already some hugetlb-specific logic in page_alloc.c,
>>>> but perhaps not valid for adding more.
>>>>
>>>>>
>>>>>> Or caller and page allocator need to agree on some contract? Say
>>>>>> caller has to set has_hwpoisoned flag in non-zero order folio to fre=
e.
>>>>>> This allows the old interface free_frozen_pages an easy way using th=
e
>>>>>> has_hwpoison flag from the second page. I know has_hwpoison is "#if
>>>>>> defined" on THP and using it for hugetlb probably is not very clean,
>>>>>> but are there other concerns?
>>>>>
>>>>> As you mentioned has_hwpoisoned is used for THPs and for a hugetlb
>>>>> folio. But for a hugetlb folio folio_test_hwpoison() returns true
>>>>> if it has at least one hwpoison pages (assuming that we don't clear i=
t
>>>>> before freeing).
>>>>>
>>>>> So in free_pages_prepare():
>>>>>
>>>>> if (folio_test_hugetlb(folio) && folio_test_hwpoison(folio)) {
>>>>>   /*
>>>>>    * Handle hwpoison hugetlb folios; transfer the error information
>>>>>    * to individual pages, clear hwpoison flag of the folio,
>>>>>    * perform non-uniform split on the frozen folio.
>>>>>    */
>>>>> } else if (PageHWPoison(page) && !order) {
>>>>>   /* We already handle this in the allocator. */
>>>>> }
>>>>>
>>>>> This would be sufficient?
>>>>
>>>> Wouldn't this confuse the page allocator into thinking the healthy
>>>> head page is HWPoison (when it actually isn't)? I thought that was one
>>>> of the reasons has_hwpoison exists.
>>
>> AFAICT in the current code we don't set PG_hwpoison on individual
>> pages for hugetlb folios, so it won't confuse the page allocator.
>>
>>> Is there a reason why hugetlb does not use has_hwpoison flag?
>>
>> But yeah sounds like hugetlb is quite special here :)
>>
>> I don't see why we should not use has_hwpoisoned and I think it's fine
>> to set has_hwpoisoned on hwpoison hugetlb folios in
>> folio_clear_hugetlb_hwpoison() and check the flag in the page allocator!
>>
>> And since the split code has to scan base pages to check if there
>> is an hwpoison page in the new folio created by split (as Zi Yan mention=
ed),
>> I think it's fine to not skip calling folio_free_raw_hwp() in
>> folio_clear_hugetlb_hwpoison() and set has_hwpoisoned instead, and then
>> scan pages in free_pages_prepare() when we know has_hwpoisoned is set.
>>
>> That should address Jiaqi's concern on adding hugetlb-specific code
>> in the page allocator.
>>
>> So summing up:
>>
>> 1. Transfer raw hwp list to individual pages by setting PG_hwpoison
>>    (that's done in folio_clear_hugetlb_hwpoison()->folio_free_raw_hwp()!=
)
>>
>> 2. Set has_hwpoisoned in folio_clear_hugetlb_hwpoison()
>
> IIUC, #1 and #2 are exactly what I considered: no change in
> folio_clear_hugetlb_hwpoison, but set the has_hwpoisoned flag (instead
> of HWPoison flag) to the folio as the hint to page allocator.
>
>>
>> 3. Check has_hwpoisoned in free_pages_prepare() and if it's set,
>>    iterate over all base pages and do non-uniform split by calling
>>    __split_unmapped_folio() at each hwpoisoned pages.
>
> IIUC, directly re-use __split_unmapped_folio still need some memory
> overhead. But I believe that's log(n) and much better than the current
> uniform split version. So if that's acceptable, I can give this
> solution a try.

If we do not want to allocate additional memory, we will need to know
all the HWPoison pages within the given folio and skip them.

I notice that free_pages_prepare() actually scans all pages of a large
folio. This means we can get all the HWPoison pages within a large folio.

A naive implementation would be that if any page within a large folio
is HWPoison, which can be determined in free_pages_prepare(), we can
free this large folio at order-0 granularity and skip HWPoison pages.

An improvement would be to store these HWPoison page pfn and
use the offset of each pfn to the first page to determine the max order
for freeing non HWPoison pages between HWPoison pages. For example,
for an order-3 folio with HWPoison page0 and page3, we skip page0,
free page1 at order-0, free page2 at order-0, free page4 to page7 at
order 2. But we will need memory to store these pfns.

Or we can move page scanning (which calls free_tail_page_prepare()) in a
later stage of free page path and free pages during scan. Basically,
keep scanning if no HWPoison page is encountered, otherwise,
free non HWPoison pages between HWPoison pages using >0 order if possible.

This change will be non-trivial but should not need additional memory
like __split_unmapped_folio().

>
>>
>>    I think it's fine to iterate over base pages and check hwpoison flag
>>    as long as we do that only when we know there's an hwpoison page.
>>
>>    But maybe we need to dispatch the job to a workqueue as Zi Yan said,
>>    because it'll take a while to iterate 512 * 512 pages when we're free=
ing
>>    1GB hugetlb folios.
>>
>> 4. Optimize __split_unmapped_folio() as suggested by Zi Yan below.
>>
>> BTW I think we have to discard folios that has hwpoison pages
>> when we fail to split some parts? (we don't have to discard all of them,
>> but we may have managed to split some parts while other parts failed)
>>
>
> Maybe we can fail in other places, but at least __split_unmapped_folio
> can't fail when mapping is NULL, which is the case for us.
>
>> --
>> Cheers,
>> Harry / Hyeonggon
>>
>>> BTW, __split_unmapped_folio() currently sets has_hwpoison to the after-=
split
>>> folios by scanning every single page in the to-be-split folio.
>>>
>>> The related code is in __split_folio_to_order(). But the code is not
>>> efficient for non-uniform split, since it calls __split_folio_to_order(=
)
>>> multiple time, meaning when non-uniform split order-N to order-0,
>>> 2^(N-1) pages are scanned once, 2^(N-2) pages are scanned twice,
>>> 2^(N-3) pages are scanned 3 times, ..., 4 pages are scanned N-4 times.
>>> It can be optimized with some additional code in __split_folio_to_order=
().
>>>
>>> Something like the patch below, it assumes PageHWPoison(split_at) =3D=
=3D true:
>>>
>>> From 219466f5d5edc4e8bf0e5402c5deffb584c6a2a0 Mon Sep 17 00:00:00 2001
>>> From: Zi Yan <ziy@nvidia.com>
>>> Date: Tue, 18 Nov 2025 14:55:36 -0500
>>> Subject: [PATCH] mm/huge_memory: optimize hwpoison page scan
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/huge_memory.c | 13 ++++++++-----
>>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index d716c6965e27..54a933a20f1b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3233,8 +3233,11 @@ bool can_split_folio(struct folio *folio, int ca=
ller_pins, int *pextra_pins)
>>>                                       caller_pins;
>>>  }
>>>
>>> -static bool page_range_has_hwpoisoned(struct page *page, long nr_pages=
)
>>> +static bool page_range_has_hwpoisoned(struct page *page, long nr_pages=
, struct page *donot_scan)
>>>  {
>>> +     if (donot_scan && donot_scan >=3D page && donot_scan < page + nr_=
pages)
>>> +             return false;
>>> +
>>>       for (; nr_pages; page++, nr_pages--)
>>>               if (PageHWPoison(page))
>>>                       return true;
>>> @@ -3246,7 +3249,7 @@ static bool page_range_has_hwpoisoned(struct page=
 *page, long nr_pages)
>>>   * all the resulting folios.
>>>   */
>>>  static void __split_folio_to_order(struct folio *folio, int old_order,
>>> -             int new_order)
>>> +             int new_order, struct page *donot_scan)
>>>  {
>>>       /* Scan poisoned pages when split a poisoned folio to large folio=
s */
>>>       const bool handle_hwpoison =3D folio_test_has_hwpoisoned(folio) &=
& new_order;
>>> @@ -3258,7 +3261,7 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>>>
>>>       /* Check first new_nr_pages since the loop below skips them */
>>>       if (handle_hwpoison &&
>>> -         page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages)=
)
>>> +         page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages,=
 donot_scan))
>>>               folio_set_has_hwpoisoned(folio);
>>>       /*
>>>        * Skip the first new_nr_pages, since the new folio from them hav=
e all
>>> @@ -3308,7 +3311,7 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>>>                                LRU_GEN_MASK | LRU_REFS_MASK));
>>>
>>>               if (handle_hwpoison &&
>>> -                 page_range_has_hwpoisoned(new_head, new_nr_pages))
>>> +                 page_range_has_hwpoisoned(new_head, new_nr_pages, don=
ot_scan))
>>>                       folio_set_has_hwpoisoned(new_folio);
>>>
>>>               new_folio->mapping =3D folio->mapping;
>>> @@ -3438,7 +3441,7 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
>>>               folio_split_memcg_refs(folio, old_order, split_order);
>>>               split_page_owner(&folio->page, old_order, split_order);
>>>               pgalloc_tag_split(folio, old_order, split_order);
>>> -             __split_folio_to_order(folio, old_order, split_order);
>>> +             __split_folio_to_order(folio, old_order, split_order, uni=
form_split ? NULL : split_at);
>>>
>>>               if (is_anon) {
>>>                       mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>> --
>>> 2.51.0
>>>
>>>>> Or do we want to handle THPs as well, in case of split failure in
>>>>> memory_failure()? if so we need to handle folio_test_has_hwpoisoned()
>>>>> case as well...
>>>>
>>>> Yeah, I think this is another good use case for our request to page al=
locator.
>>>>
>>>>>
>>>>>>>> inside the page allocator (probably non-uniform?). We can later re=
-implement
>>>>>>>> this to provide better support for memdescs.
>>>>>>>
>>>>>>> Yes, I like this approach.  But then I'm not the page allocator
>>>>>>> maintainer ;-)
>>>>>>
>>>>>> If page allocator maintainers can weigh in here, that will be very h=
elpful!
>>>>>
>>>>> Yeah, I'm not a maintainer either ;) it'll be great to get opinions
>>>>> from page allocator folks!
>>>
>>> I think this is a good approach as long as it does not add too much ove=
rhead
>>> on the page freeing path. Otherwise dispatch the job to a workqueue?
>>>
>>> Best Regards,
>>> Yan, Zi


Best Regards,
Yan, Zi

