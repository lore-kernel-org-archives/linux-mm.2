Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CA4C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F326B008A; Sun,  2 Aug 2026 14:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF5D6B0092; Sun,  2 Aug 2026 14:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97D66B0093; Sun,  2 Aug 2026 14:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94ABD6B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:38:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A1E61C00A5
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:38:49 +0000 (UTC)
X-FDA: 85057190778.09.33E511B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 532061C000A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:38:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fm1ezlTv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785695926;
	b=aX1Txd7vpO9bJ8awz6bg8oR4s4thZfiwCBVFmW0SUmdAQy8kS0jxGrsl0AaZcV3m+MWtrT
	r9jfRXmhMfA6lOu2qVbK3tpyxyGbU2UzsnuQbc3h3YApCceuZ5s6CATj34vJ9BTUpGPAcl
	H9EpsbySVljCBo6ivUbtCti9P0ZAHwI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fm1ezlTv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785695926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+nFUyl7uCnHI39cN8c3If+llDPOW7ASrjeUe/Yjpt0=;
	b=WKqkpmEfT1FDIOocbEhFWQL7z8srnyRc1nQqJ6biyg4FhQLBpW/UUDapqBbg6+6lDW/kup
	OtK0i1EB/w1wjM8kwr5o3tDuH1X4dQ/sJgq7hq3Wbf3NZxCcXqJ1l3qZtwoYyOQ3/45f9g
	QP8UxcYwJS+xkNwTpoBHqVQH4HhiUiU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGVlGLdP6a/AXmMM04GMfxkV+lzN1mg5vDGJvhpBeKbpHz9gwGzp5syZqcR6XHNqNKnEJOE2ikQ+qSDj0xWsPHAPudPgbgKrcBlLRga6tSyhVDSOod1E6dwcMI+DP304Mq5QkeAouBUaph3WxVf1d3xAvD3/hH1ic7pnzNO++0LUpLl5P/VUZQQoPaJTMxOSBu4ZA0ytxBosURwAkeHks5uSmcYVLBSmflymOUlCAxBdoxJ21Y/lTbBX2iDuxFXYqZnRnKW3gbD5EqsyFSRsalRM8ptkNsV0irJ5wZP3IRbf3Y64B7RO2LK4Nbgirkbq98q8+OqsOe/+UzldC4VGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+nFUyl7uCnHI39cN8c3If+llDPOW7ASrjeUe/Yjpt0=;
 b=mQPu9Iykq7ot+uxv6rUy8pmQDIE8RMsrI12pPpD+2EJ0Ktq3PIhj5tSne2lhqAgcrcl1lZ2qwdAMzmmdickr/KOAWbQhj5kid+RMyyemYg/y4wtANPf+YGXqdFCxhALGjlpq46I+SFVza4CwFe+gMsIb7YAOsgdLyyWAzMu2O6w1WuGSpw40RvTHiA05H1GSM4XCuzjyZFuUpctIaIATu8kBWWs7dfbYD26VdEXQO/KZIpePxX2wJGhbs5i3vMVKwS36EDEi+N9kcVbU7RPYr1suykSjXZOu3bnA+PGVYHV8p1p51SuEN8A6n8bGUQrj+72EsVLuT1SmMkBXZs8qyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+nFUyl7uCnHI39cN8c3If+llDPOW7ASrjeUe/Yjpt0=;
 b=Fm1ezlTvTFMj8SlNr0c7jWOkeiFKCQxzLBnLO9wan6ozNaZNf+FBkFOXIjo7Hpuz9xfS3isTqGd/JxPc8cVlhLgPT11XNm67TJjM1jaXl4XqkVS/K6nWz0gN1GtiYWtPdATQLg3vjL2UCgl5nRYjW+dIETxuSlSgk9xeL1SGZsfF0yfa/2Db6rGHU3bqxWOsHfVhTHXQOqpk6q+UCUrjgtW4gAT3jwVHZluqDc5zoCDN9aTBMiPyIW1l2VEct+muB82z6mjKepQZqexmogY6aEyJ4AzGw4dncicO9j5XC52gGJQEd8Ksa72c+Sz7ka6tFumgDr29UEN+yj5nqwIHxg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL3PR12MB6403.namprd12.prod.outlook.com (2603:10b6:208:3b3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 18:38:42 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 18:38:42 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 02 Aug 2026 14:38:41 -0400
Message-Id: <DKEODHFJINUQ.QN3HZP4SVRFO@nvidia.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Oscar Salvador"
 <osalvador@suse.de>
To: "Usama Arif" <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 05/14] mm/hugetlb: use direct assignment instead of
 folio_change_private()
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-5-142c97ba3562@nvidia.com>
 <20260802121613.1590412-1-usama.arif@linux.dev>
In-Reply-To: <20260802121613.1590412-1-usama.arif@linux.dev>
X-ClientProxiedBy: BL1PR13CA0296.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL3PR12MB6403:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d7ac1e5-e72f-42f8-ef69-08def0c546f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wGi42BEYM/93fpTw0corajzseMFKDs6bzPh1315aI6+TISSfmApYCeFfdK1WLflF1gPlY1pscWJq+HibJHSFV7y50arJTAGIRPs+1Uz8m+3MM/QeeG3QnclrNHjGeJDhD1bhIXUWMQ0b3VgCmKmzOZOj17E+27DbuLhNzflszdXoGuzrGNLnlMl7c67WvzV8m2dF9Kx6qhm4FyZHWH6lrbgLFzthRxJIDrJoij4A+vwU9HS9p4ebDV/OnV15Pa/u89fLvX+QzUBQ2aloqj0oQK1CIzJZZVl8QeAnjYaEljPpr6cD4Y3QBo7sKG2v6VlElwKjK7J7LN0ZnmjRM5IX7gumeh2DKlSVrgngj17JHknj5qiTfJU1SN/BHP03OCVuV1+zz5V4vnWkv8X6qo9R7uTjP9aZh/qCMuJJefidQ80cwq6gRsK8XdSgNXkoAnQ6LzkqdiLacy00oOyqAF6cpqWO4SGZ4W/aV9rEelch8CpsRy0s7i7Wo/89kbPvCNgznNmmYsr/ckwxLU65qSBaNB0XlnfTsYKelrSVsVge13d6bvNlm/8MqLGanPpE7SzApcmERTyWJy+EEUFuxabsInv1lz/JofHUi71g4K1PMjjJKX+opXz5AQMCmialBtj2G1Hb0fxEoxhkCEou5SET+AXwk8xn/PqQT1JKI2sDNYc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHN0bDl2TG5RM1BKOThwODFTam93OU9ZcmJpTTdSV29SN0hiWWJ1SU5mMVpO?=
 =?utf-8?B?ZHRSbCtxRHNaNkRNVlByR3VVWmxMd0pad0dlTHVzd1l1bW9zNG12em1EcEZ4?=
 =?utf-8?B?L3dQVXpCd0lKMFd3RURzUWo4ZUZ1MTlnUE5mdkZnWmRKNkc1WURUWW1sd1d5?=
 =?utf-8?B?b09VcWZINUVHMkp2d3M3cEVXYTF4RnFJQ2NOaGtERlBBekNKM0YyeWV0cFM2?=
 =?utf-8?B?VjJqRGV3YzdKTGI0VEFqSFREZnRuNUN1M2s1czZSUi9jTTEyQjdRdUc0TlhU?=
 =?utf-8?B?NWxOL2hlU2d4elRpTy9CUzFnY3luZi9BM1JTQmYyMEwxSEVZNEdqOTFKelNE?=
 =?utf-8?B?TTR4YU85a3d3anQycFRKL3E3MUUvZmd1SEozUERoQjl1Qy9aZ0plUC9YOGxv?=
 =?utf-8?B?U0RZemUxQzUrc0NVSkNGWDE3UzBUeWF1Z1d5V1BUcUFhNHB5T1lBMlFSdTJz?=
 =?utf-8?B?K0xNWDN0UmN4ZFI5d2pEMUtHajVWeENTTXZrMzZvc1h5TVNRQUlXZ0ZzaXFY?=
 =?utf-8?B?VDlGUUZESUpSb1BrR2lBVi9jV2VJQ2ZneDBtMkdxQlFacWVxdGZTUFh4bm5F?=
 =?utf-8?B?YTJIV0JQcFBXTFFFRkJUaEpoU0h1a0Q5MCtLMkRMMDN3ZHMzY1l0TEY3QU9t?=
 =?utf-8?B?aS9UdjUyTERlQThFTkVDOVB2T1RZV05Jd0pkbjRjSWE4ZTVXRGJXVWY0dUV1?=
 =?utf-8?B?ZkdTN0ZRdTRJZ3Z6OXNUUWU4UGpLODBQb2ZaZjByZ2Y0aHJSREVzRUlqT0tU?=
 =?utf-8?B?c3dJZnFMMzZuQTRyOFRnNVZBTUczMWV4MHk2dWpDVFV0QU5RdEUvbk1TOTkz?=
 =?utf-8?B?Z1A1WUFacllreVhsb2Y2Smx4R3ExVTJaY0l6S1RRa3lQUWUveGtWZTdJS0tY?=
 =?utf-8?B?dnN4U3phMlE2T1I0WU1QWVdVM2N6V05KOEdldjg4bWZOaVBMR2w2QUpaSmd0?=
 =?utf-8?B?WUhGWmpNQVEzZ25JVGtpYzBhdXUrd0RkenNlS2xKRnB5alRTM3ZabkFndEl6?=
 =?utf-8?B?Kzh1S3dNcHcxZmRuU1lvZjIwUThRdHM4TGx2WCsrajFWRitpQUFnSitJb1ZS?=
 =?utf-8?B?MnNpaHU5ek51Z1BzTW9nd2VCR2VtRXdQUWp1UUdFUlRQTEQrSE5nQ2FvZEsv?=
 =?utf-8?B?SlFBYlUyUEVCelFhUFpnbEUrN0NKaE5zc1ZFV0d6aUtwSmJuTzV2T1NQeUNw?=
 =?utf-8?B?cjRqajJVTGJKWDVlTGxHZUFteXovdUFWZWVRR25XSEF5YzFVcUxidnNhakJ0?=
 =?utf-8?B?REN3a3RGMDVQb2hYdVgzQ3FFVExNYWFiREZ0U05Pa0VOVUhnUzFGMFRnem5I?=
 =?utf-8?B?ekNjZVF1ditnT0pKelBJZHZtVU5ZSjZQWHFNV1pSL0prOTZmS1ROcVZYVGFR?=
 =?utf-8?B?MmxSK2pWajBtSkw3ZzZNeU1DSG1LLzBtN3d5QkZCNXEvaCtGTWdwWG83MWJy?=
 =?utf-8?B?VFZHci9ackRuek1YYXpvZ2tQeXF1akJZS1l1a2JRcWpWRGpRSVBleDFkenNZ?=
 =?utf-8?B?Q2VEdE1uRml0Uy9TanByTlBrQTZqN0RJNlhDU0xhZTFOMm9GeDRPS0h5QldK?=
 =?utf-8?B?ckpSVURSQk5VVlhBQkdha08xWlpQRUx3K2xiV2tHZkhpdzdLVmhFVklUZ0F2?=
 =?utf-8?B?SDdCd2lIdkp4clU0Um5KNmJDU3g0L2tYSTR5K01UNVFhQTM4S0krczZUdmQv?=
 =?utf-8?B?bkJoalJudGZLeDRkRDVZd2J2cUNMOUVCN29ZWFYyNmdNLzl6cWNDQkpFd2Iz?=
 =?utf-8?B?ZDlrd0JERm9Wa3JQSHJ4VlI1UkxkVEJUN2pOUE5PR1p6LzYvV25PdnU5UjhE?=
 =?utf-8?B?L1hlU05oVFJJWDRxeEtpeUd3M052VlphSFh5MlZEQVlNNlIzb3RqdjN1Z1Ny?=
 =?utf-8?B?NzVOWEVkNG9iVXp0VG5hVnRCKzRlelc0OUJDZ1VjdmxPb3VpU0phdEV3cDRW?=
 =?utf-8?B?dmhRMXdIZTJaRitmdzczdVJJYlRFc3Q2d2ozQXJ5UElRWEM4ZkZYS21RVW51?=
 =?utf-8?B?TnBrdEdTVjFwb0p0Ym94MDlKbzgrNjhDbGppYThndFpFS1BYWE1zdk02c1Zm?=
 =?utf-8?B?TDl1RWFOTDMxd2E3YlY2dm5nY3RmVS9oY3p6dk9VeloxSXo3VzhnVkJjZEhl?=
 =?utf-8?B?RWFPSkNmSXRhazdNaWZ4UWMwWFZ6djhBL0hLSGJubWN2VDE3TzRyVkNBYWhT?=
 =?utf-8?B?S0tDZUZia2JObnVYaEFHM1hYejgvTUtpY0k5R3RvcmdkdW5uNFVRTTBjMDBw?=
 =?utf-8?B?NGs1S1Z2bXlMdzB1SUlnQjVkVFRzbWRudmJtUjNzWU1keUdQc2pwOERuSm1v?=
 =?utf-8?Q?S8cbK0Rr7J3a6+Mcgx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7ac1e5-e72f-42f8-ef69-08def0c546f6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 18:38:42.4370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odb5MxCzPlpr+cnQ0/zCEuUrr3zkXGVZWS0p2vFBMUfBO/lIaZ9XARfOj3uAr00w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6403
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 532061C000A
X-Stat-Signature: 6boz6qa7gfzzhgj871rub8g13hidprur
X-Rspam-User: 
X-HE-Tag: 1785695926-9928
X-HE-Meta: U2FsdGVkX1/EMzYI47fnON8p1UBvj/owkz6uHKpJ2katTuKMT8In3ca3zG8JrsRh9HQtpwcHhAZKp4RQjGk/ONzetYZmuOuCatHwzO8LZpOgjP449TuNi8WAIeyrRCYS4COwkpgIcBTll8AINh8ZMDsQRjV07RQE/fGPAxNRziA5oKILxax7i5gJ7MhnMnx2SUC9EAAhx+zW6XKsthy6ls9XIMvPeUMCDqE8VOdmlKRifqjNMQcRPyY20HkEZsWUEqsJ7+giLA+Edo43oh1qh5no1j7uTklLPJvzsS9FkZ+VPqp9JHtJydJAxS52sgLx2fjaCJQ0FijGQqvUENyCZqj5M0mP2Y5153xH91ioMnhZA80EtJtic/HFk6MOnrx3JTIMp/t/KnceHhn0tswRbQRH9rVSJE6U+KHWa3CjcCIhGm+BteWM6MuEA/sG46lBtWoelmppYVToaefhJoyqMg0X4naU+FR8SwVMLOlPyU/JSDIY5zIxNdntTVpLMlrixAyiKWqHV4PoRjddDZBRdttBsxYSfM5L11lli7d2j4k1Y/k6c3LYjf7nKwFL3/qy7VER7COQuWec47FlPZ/OwD8Dq1qESGHgClGCnnYxStSR4PTGILONU2Y8yPYo0r35phFw+h2D47eelrS9QGg5wipO7KUEB74cGcQG6o3nR4XGQqjOaQWRtaEZP9CfI/UA+yw2PjlO64HRHpySafFtYJI0HOkB0wQIJ6kBbsYt049Lgl+lH0oUEOhhBoDpWkvycsBqIw6loz4M4Uj77pAkZi1Uwk1A4ht6UYn5ijSOoqqIrztTH/Jk+2Mf7ryCKgc6xAgaItB0fnOuvLoMdjKmmvKSOqaKR5zG0WSfsf11WfxWqTeODBX0WKUxZDLFMgW88oJa6xaHfEwV2DyjgoNl5xxoiNkR8cCwLqUs/kBIbOu7Qy6jbRiZzqxKv+aDFmnZeETaOefWvub45cL02Q7
 dgLFJlqX
 w9AR6p9S38ZrLCwK8IS3S9Fk0CEcDgfyIUfHu4VoPaZ2cwdLO4wbJtKEyllHI1EtA+R9cBmlMOuc+m1hfZCMEMyWqnKFezAr1cPjfagkd2FgFRByBW4tQM5MORvxUN/kPY0q8iZ035bv4GhPFj2QggYoykNPj5eVsyVhgC/v9RS8xRkFY7rtIGbnMlR+xIsmZx1eUz9dT2g02ZYdlNaqcHOX20hscFnrzRbttUg1NurJNH4sDk+WA8FyiS3iIR9h4KvBHMfnhViE35Ro9EyFRaYf0iTuLtGvhB1AlKCsF11VGOpzjNRvQdatORtjOHNeCEGYUd151+EnYMN3MhiczCE7Zjug1LciZxIja8lgPoapNQT0sBhZH864ZvUCfWa8vjDF2Psacvxb8zdS+6E2ixdWRN4HRRUIgS6aVpV6cc0cbIMZD7Z4X4MHZY2BUx2oBk2/i4I0RftX5SIBVbZNR7ikXQs3I8fPQLbT37OZKzKLzGWmJWPj7GAHdG/fh3EhPYg/SQqfBiWD+/Rivg2PXWNuN9vye1nAJGaZE/NmGB+kdzU/1oMhdo9gxSytoEejrgL/RIsMANIEJpGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 8:16 AM EDT, Usama Arif wrote:
> On Fri, 31 Jul 2026 22:13:28 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> folio_change_private() should be used along with folio_attach_private() =
and
>> folio_detach_private(), where adding and remove ->private content requir=
es
>> folio refcount change. add_hugetlb_folio() simply sets folio->private to
>> NULL without refcount manipulation. Change it to direct assignment to av=
oid
>> semantic confusion.
>>=20
>> It prepares for a future commit that remove PG_private.
>
>
>>=20
>> No funtional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Muchun Song <muchun.song@linux.dev>
>> To: Oscar Salvador <osalvador@suse.de>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/hugetlb.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index a77c3c1cb8943..0abaeb47890cb 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1433,10 +1433,10 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
>>  	}
>> =20
>>  	__folio_set_hugetlb(folio);
>> -	folio_change_private(folio, NULL);
>> +	folio->private =3D NULL;
>>  	/*
>> -	 * We have to set hugetlb_vmemmap_optimized again as above
>> -	 * folio_change_private(folio, NULL) cleared it.
>> +	 * We have to set hugetlb_vmemmap_optimized again as hugetlb page flag=
s
>> +	 * are all cleared above.
>>  	 */
>
> The return value of folio_change_private() is never checked so LGTM.
>
> In the comment, saying "above" is not very clear. How about something lik=
e:
>
>         /*
>          * The hugetlb flags live in folio->private, so the assignment
>          * above cleared them all; restore hugetlb_vmemmap_optimized.
>          */
>
> With the comment clearer, feel free to add

Sure.

>
> Acked-by: Usama Arif <usama.arif@linux.dev>
>

Thanks.

--=20
Best Regards,
Yan, Zi


