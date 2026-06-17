Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D57CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E046B0088; Wed, 17 Jun 2026 10:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5DF6B0095; Wed, 17 Jun 2026 10:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD626B0098; Wed, 17 Jun 2026 10:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD786B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:54:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9D08404C2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:54:13 +0000 (UTC)
X-FDA: 84889699986.20.C059B39
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1996440002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:54:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GEIv1jD7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgkfhLdBQTxFJihA0zjxwrvGu4kCW5RbkzobYyD9YiI=;
	b=MIaquzF2TNbZho/T9JRe3lpCMIZQGjYpS9+ojUizjeFABz4MbBeVzdXUnKkkS+heWektDS
	V5jKfexy2u+gW6pc1gJye6ICMCEGaIdcNGo3cHXsP/7+MuRAYNaZzBKhzFo3vR3nWhcsc5
	7Bzvwzxz16QfiOE+GDGHRZDc+akHqIY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GEIv1jD7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781708051;
	b=JoiZl71WwsnxXJfGG6Is5YCJLVZOHhTYKEmHz3ggq54+K34LgtP+Ldt+c+QWlvgvxYi9cl
	XWnq6DuJHMHQD6Hv4nBLRJUJy8dSgPyxoNuz+FgZSGH9aH2f6wObIktgzNVJoSU5D/JPYr
	VUDBVKOpoe2GTbi4CZWD6rrwNjprCBY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUK1NhNn2FGBqY3l0vZb5C/i5DV1zebIzxgE37ZM9PTsAr2jOGjUmoUEGjVumfRdkg9DOUnWbdLvv/Y/FQHklUeko4t8oHp4v4hLwqz/xr9wNLYHlKH3mQ/4BexO2LSAzUfrndltFV9y4DHffbruKgX8fm8oKIubSoTzcZbexs7RIY+POBaD0/8pcoimaoPf6hSrTzawbsY1M6T9dY9gt0UKGqu3K+bkPwhLC4ciEI0PRq9BF+yq+YRfS6ykp31u+cAay6F2siCSy1ORNOKJa/gb4yJdyMOOo3/G8/avc67jRf6yRDJJo1kQOmhYUi1Ap5h3SNsOSzDbu5yg+yOK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgkfhLdBQTxFJihA0zjxwrvGu4kCW5RbkzobYyD9YiI=;
 b=i3e2h4hL/Ctbo7Xgxw7RL7Mm/mf3r0xRxNgvm4eBD/xP5u3JUhvUuLBhqaTHEiYlKhxVUMOr/bZ0Wj58PrzGdIf7IuHZ6kVkjOFIp/TSu9w6lS9PQZaWFeuSQKA1suOUcAZ3nMpNzgKzyUWsnCq+BkMQgepxpmUDfb82NygLuxOw4wurR4fCBB5jtoXORGDIVuP9Ll995dLgSfwAk0JDVGNf+2tyQZP0Jy7aSty47nZK8qZ6/h9oniMK1oEOmWwc2YsjXRo3ie/hd+ODvoFein/JldkBiAx0+78wpdDAjBGhWrvdX8fsMov8WYv8cnzQqGEshjtdq0a/h4rrtC+0Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgkfhLdBQTxFJihA0zjxwrvGu4kCW5RbkzobYyD9YiI=;
 b=GEIv1jD7RonU2YBDC9azp1TUq9cL7pnvGqgl/4by13Ih1TKO4/NCRAgbldKTJhE2OrzkOjj4IYOXZ2suWvo8Dtz3CK8CZisEWu422bOsLxMxqABNDsgdeVH78163GKUWxK1emg0q72uWGkihD5dBmS/3PAy3koP//3HALD8/NxQeCub4C5MR8Ihj+PXYHx+IWeiae0IP8IqLhDu/2nYvTNahRUOTocyw4ryI2YySaMAeaAlK4EqPJwh0DoFfAa8If4zJi+9v3m+qkEPLFenDm3bAA39khqeDMdK+q7SlB0zG/6DPIgtpCzqUY/tQpD8xRyNcLgXb4TSmGMe78IHcJg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 14:54:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 14:54:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 10:54:05 -0400
Message-Id: <DJBESGC086ZC.3JSQ5GD3ALCY6@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
Cc: "David Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
In-Reply-To: <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: CH0PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:610:e6::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 9541f768-3daf-4ec4-6de7-08decc8047bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nbrvZXwRVHvtRMP/9Mi8e4ZdLudPkQTo2Wa50ynKdoxsMEKTiC4BhXX4+C8p/VBBjrAWa+0Xat3FuIgbhxUIppqZuOI3Dau16o5p/ZajFwKtWiQiXB6JGo3Z+j/g4+czGMkBqTElpFkcOxsao6LXLtC9KKS+G+UzyL+Rp7BR7lphVOJaiqWOx1FQ3lEIN6EfJKkZK6/U45lUpapEAEBAJRngiUj5GZ0Dp96paLf60J5Ibyxaw7PtTzdux1qWiNpqcIey3BCbxfS2ftMT95wfBbjliLfxJTbBYIXK/+xFto6QjbW7IG+KBh38j2VmBZLoVwcaKiXpjPSiT3zy0NuBHrdCjhU6VVGkyi/HQgX07u3zgHHP9NT+Qx5Jhy2GCQEIe28RlBFp5efubqyd6o4Yc5l8lTWeoUoggywMPgGSJNXOeVVFYeBuyUVcgW6tuOdXaevP/XfrwvjWRHfIsg/l/bhJEgcLN/vyawkMyblasT98F8JbCuf7IycLOkH5UewUS3bIPE8l0UYPLhHbL/50D0c5fH4jiFgThDS8EZaNRVyPIsG5+lNjjbRpwakDP3zoOuxxGDFVUGA3JUdVoJEpwQT/uhUQpfqStQw0Gv50KtQTtyPjv5rzE1rgC25LSA431Ea5WAxa2v1AwDnUict3Td8blccIVKLUDv2RY0nCq3FZpu7XLgsvlf0sZwRMpimA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVMyWWpSdlVNaUduUDZxOVdEQWtWamkyRFVGdlRPajBpRnlkbUhmRk5vWElu?=
 =?utf-8?B?ejF5MWRHQml1UkVDT2hWbEtoWWdhVnlreXZlM0M2MVVOaERrdjdXSjFhd3NB?=
 =?utf-8?B?UVJQWUsyZ1IzZTdkY01wdkZLVzlkamM2YmpqdC9lR1REa0lIMnlRQmI2em82?=
 =?utf-8?B?OE5zbWkzb3dzZ09DaHpjRm04dkpzRkxVZHNjZUlyMi9sb1JBd25UbThBWTBr?=
 =?utf-8?B?Z2J1Y1F3L1RXOVpiUUllc1orN01JSVJVaWdXSUcwOU5EeWdFQTN2S2ZEY3Fa?=
 =?utf-8?B?a2kyR2NPVjdLSmJCTkRSbHdJTG5WREEzZThnK29yeHp3cUJINGh0SlR4MjJP?=
 =?utf-8?B?Q3BFMXJHRG5sQ1NRVEpJUGF1NStSZWlTbDdMOXdneHRwQnZ6c3NVV00yNXA2?=
 =?utf-8?B?V3BoUjFQYXJMalh1M2h0YllTSUVrVXNseVFxdGVUKzN1aHVGdUhEU1NHWkVh?=
 =?utf-8?B?Lzl5ekduR3hlY3U2c3c5SU1hTU9sVkZRVmc1enczRGVlT0JYNGs2T0dRMmdt?=
 =?utf-8?B?c2JOVjluSG1PckdBZzZRRGM3UXZZUTJqbHkvTzRVaUpmeEdWUTZlMmVlc0Fl?=
 =?utf-8?B?TE80YWVDMzNDQ1l0c1F6bVdXRzFmYUVyMXRMMjF0V2JxRXlhVGltWjJBVlRi?=
 =?utf-8?B?aDdpdXcvMnB5N3dvQ0dDeHBpVEtDMnVYbERiTlFTeWN6dERKd3lFZzE2MUNP?=
 =?utf-8?B?NlJ3S0t2dC9BOEtVc3pHVVNCZ21LejZIengySTdsbWhoSGgzVFI4bGlETWYy?=
 =?utf-8?B?KzVXalRjeVFTYjhNOUROVUIxUnlhYzJKQkpPV05WZWdKU0VTY0gvRjRyM2Js?=
 =?utf-8?B?d1lNMUF5dHV2Wk5sbHljeDY5TDg3clZvcUNOVVpnL0Q1VVJDVW90Y2FOS2RT?=
 =?utf-8?B?bWlDcWRaN0xTUGhCTlFpSm5IWmxWam5NL3JQTi9yNld2V1IwbkV1T1RnaTdD?=
 =?utf-8?B?QjJPK3pZSmZUK0luWURXRlVpNG1TWGRRNjhEa2xyWVVGUHBqRzN6MllLeGZC?=
 =?utf-8?B?RnQvZzE0UTRiS2lwK2hPYWo4LzR3czMxdXhXOGVNeW9rZUIzMlc2UjBjT0Yy?=
 =?utf-8?B?a2RoTmRSUytMTTNsakgzRTA4Z3FSeVF2SmRPR2hyMVF3NFJFbTFzU0YrcWhv?=
 =?utf-8?B?MGg0S1UzRDlBZ3JMZnhSMTBiMWpxYWNzY3h3c0xDc2RUS05zazZGTk5BU2d3?=
 =?utf-8?B?UDk5N3MyVUVaMTB1Wld1WG1oaUZ0Yk51aXAwYzRYY0tDNHlFWkdoSVZxNVVE?=
 =?utf-8?B?aG9mZytLbE41TXlHaGczRkxjSGhYQ2VtS1U3aTdUYytDZll5QWxva3lQSXg1?=
 =?utf-8?B?Znl2TjV0R2I4cTlmQlJXcXlPL210UFB5a2ZIdk0rd21qY3VyZnB2MXRJR0x5?=
 =?utf-8?B?b2x1NElDZ3RpS3Vqa01uTTFhbXRoZ0pLOWFMTmpkb1hEeDJuQWVPRU92ZVJu?=
 =?utf-8?B?TjgzbnJCdXlmdDBOQi9wZDJjMzJxS0pZN29oY292cEtGeXF2MFczUFB0NDlB?=
 =?utf-8?B?SW5HNmxNMjNIY1p4T0QzaEh3YTNpZDYxdWI5TnF6eEtpZ3NjRmdVck1OeDZa?=
 =?utf-8?B?TVdxcVhrRE9kWk1PQlhDc2ZSZ1hWY0t4aXNQR1RSNzAyY0ZTOE82dmp1T0RG?=
 =?utf-8?B?eUU3bkhuZjFTc1RwTDEwNmxNKzliSU5YTStSUmFUU2NBWkdRZmlMVHA4TytY?=
 =?utf-8?B?T1pCTmRtajhUK2k4aGI1MmprMzAvbnFPenlFZ1grWDJLdTZPUXp0dGlkWW8z?=
 =?utf-8?B?UTV0YTZid2EzVXlXa2E1RTM2K1ByWDhGYnNINGZkR3lPdC9EZ1pydGg3bTZy?=
 =?utf-8?B?Uy9JazRwM1RVNzhKRnE1ZHA1QU1GTElUb1FBby8wZG4zcWpJZ1FTeXhLVmZW?=
 =?utf-8?B?LzExc1BzRHNWU2hDWkFaZGtuOFZUTE9jOFlVOEVXWkV1NWdRQVRNNmxZek5Z?=
 =?utf-8?B?dmIrV1krWk5iMTJwT0plQ2Vqbmk4NENVeG0yTGVRWXVvNnhVaGI4WnF0VG9n?=
 =?utf-8?B?SHBwRjVmRVh6QURuVUNQVTlWK0FJOWhlZEt2U0Jab01HaU9BTllSUUkrNlhi?=
 =?utf-8?B?L3RhYi9YWGFJYzcva2s2c1h6Vi8rNGF5bmZTcGZDdHNodjFEYzR0ZG1GeXd3?=
 =?utf-8?B?cnQ0cWtlMUtLemd3eFlZaExWSE5yS29JZndVMUdtQXhFdE9MTHhWaDdBVVB6?=
 =?utf-8?B?aGYxL2I0MmJsVitsd2pYNEEwMGRXdS9mT0hlWi9SaE1QN0R0Rit3aXdOd2Nk?=
 =?utf-8?B?aDREMWtDVWJGOENyV2tUd0VTdVhUcWZJOWdMQTZEc0srQWpkQmJzcDhMSzBY?=
 =?utf-8?Q?aqIxhl5ql24bni7ZpC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9541f768-3daf-4ec4-6de7-08decc8047bd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 14:54:06.6534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7h4vVlpBOSfwFeeXkGf/uIBwIwuc1TItwN4YHP41De75gNT1t1vGPfU+UpTSeTl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mj6jgri893o1ynew7phtnxhnsyg34kig
X-Rspamd-Queue-Id: 1996440002
X-HE-Tag: 1781708050-358074
X-HE-Meta: U2FsdGVkX1/SFe02TPfoe2a1EFaXHwrcIxQeLXA7mnt4X4TzG7pI/u+icDHk2mKtFClUfumAgJwNSLw2m8OSBIAlXb00r4bdpWpRaWnnWS84OsxDHCNRMKiQ1HUMKw6QuDMvcU7jYrLwHPS5JtFJYPhuI85V6EJw/+DKdsw7BO5kvnQ5erURjvqXXkr7V1abcx/JZgLnflochqTUZ+SsMcQLdvRdbLNw5t8N5/mAYxNS+tlnO775xRU05zRVVNh0vJkQ824pyqUox22Af+d3A9ZmDadS1BFw+yuyJEFB5tm5AWDMs3DVFQHUYrabUWm7YNh+zsCpWIoRaQxuSQcQeHIbW2vgnsURrcFcJZVFQ9YACF5Fy+pIgK4ljlX9aBV6/3EDOKgXu+fRCO86XLcDu47CB6uCklAcqDozqO6rdTIuABExxwTi8eoaWFsWFmlj3ROMoxGebru9SXCU1jZCV6ujyNchtQyD1J5wuso6I8PRE9AdixL9y1FI1SaGajMOPE4Ca7sgvhiPpm8+LzzRfnPp5kY8A8tSMqcsZZNE8UQv+hHiA6YwxeTEsJN1thMnr4CYOMy/V2Z4171AkwIeDpjmJZ0t8LU3QP4fyGQX0Au1YtGA1COmXwnpOJG91npJalRJsYRaiPWDiF+xXfcD8Cay+BFgq9dRZV7cjUjA8LwGjojnjXyfmzbojJN5TAyMi8GwP0zDNLCqxbJ6iTdSrq1cpvo8D4gs/D5eMGHzeZc8S4vHbmsRLKYINFyjyniR18iUj9vrGWtBYGKUK9gP80WzR8K2wrYPKFhwIBVinfSHHp2uysm7lawkqKkCC1sf5YHRxTgGS0uUfSs7nxeYW3KeeG7NykDVIEYXoSB203mIbRS6m1Jeh+VKBEPz7bJN5NL+JR8aFGmYrjfTelZoYefCFrsMDmnIlYbHv35DprSH0hny1s6ln+Xhl1oM0TbYUUGVQn84SaC2vXmstbt
 oUaDYI34
 M1S9/v+jpW+RZ9stok1JpvhQBxrJWSBPKyj8d35WqdJjbyqJytT0rhu5VuQ/2zE0ah0P9rmQjAAg25AKI054RQ78F7jDe7D7aCZ1KDcwuBfBA1KIugm4gLcJZAPpDFKDdAWYm9KT3xrwZERWnB1UPsAf8MPADXt0okr1QkGoB4USE/tuLjkj0REo/VhF4TcadigpVdtT7+grBDiTwljTo+v1C98jMfetQ1aYKWV60nDmcdZysTAS/8BAuxEqIZoWReu1aY++ZgI0Cq90Qe2d1TRrmDvr6bf4A8JCw1Ygi7Dq+jCmf91WEgrFoW3WsLedBlGG/jQ1dphBLj7TYlmieyzGW6oY3cYMD+05SoNTigQa6qCSz/l31a9qGIgSZfZKN0wPZTwTLEFhUUxq4z93eVUeh9trXYXeyhel0MsFV2X+mCpb0c5LWBvZp93v2eBLBQenwkxkGgfquV81ZUpPlcP0arA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
> The mincore syscall currently takes mmap lock for the entire
> duration of the VMA lookup and page table walk. This creates
> a global contention point with page faults and other mmap_lock
> holders in multi-threaded applications.
>
> The mincore is a read-only operation that only queries page
> residency from a single VMA, making it an ideal candidate for
> per-VMA locking, so try per-vma lock firstly and use the
> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
> find_vma() lookup.
>
> Unlike walk_page_range(), walk_page_range_vma() does not call
> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> to skip the page table walk. Without this check, PFNMAP PTEs
> would be treated as present by mincore_pte_range(), changing
> the returned residency status. Handle VM_PFNMAP explicitly in
> do_mincore() to preserve the original behavior.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 71 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 53 insertions(+), 18 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 296f2e3922b5..a786a073feab 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -12,6 +12,7 @@
>  #include <linux/gfp.h>
>  #include <linux/pagewalk.h>
>  #include <linux/mman.h>
> +#include <linux/mmap_lock.h>
>  #include <linux/syscalls.h>
>  #include <linux/swap.h>
>  #include <linux/leafops.h>
> @@ -232,34 +233,47 @@ static inline bool can_do_mincore(struct vm_area_st=
ruct *vma)
>  	       file_permission(vma->vm_file, MAY_WRITE) =3D=3D 0;
>  }
> =20
> -static const struct mm_walk_ops mincore_walk_ops =3D {
> -	.pmd_entry		=3D mincore_pte_range,
> -	.pte_hole		=3D mincore_unmapped_range,
> -	.hugetlb_entry		=3D mincore_hugetlb,
> -	.walk_lock		=3D PGWALK_RDLOCK,
> -};
> -
>  /*
>   * Do a chunk of "sys_mincore()". We've already checked
> - * all the arguments, we hold the mmap semaphore: we should
> - * just return the amount of info we're asked for.
> + * all the arguments, we should just return the amount of
> + * info we're asked for. The vma is already looked up and
> + * locked; vma_locked indicates whether the per-VMA lock
> + * or mmap_read_lock is held.
>   */
> -static long do_mincore(unsigned long addr, unsigned long pages, unsigned=
 char *vec)
> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pages, unsigned char *vec, bool vma_locked)

vma_locked is confusing me, since I thought vma_locked =3D=3D false means
vma is not locked, but it actually means mmap_lock is taken instead. But
I am not sure an enum vma_lock_state {VMA_LOCKED, MM_LOCKED} is needed
here.

>  {
> -	struct vm_area_struct *vma;
>  	unsigned long end;
>  	int err;
> +	struct mm_walk_ops mincore_walk_ops =3D {
> +		.pmd_entry		=3D mincore_pte_range,
> +		.pte_hole		=3D mincore_unmapped_range,
> +		.hugetlb_entry		=3D mincore_hugetlb,
> +		.walk_lock		=3D vma_locked ?
> +				  PGWALK_VMA_RDLOCK_VERIFY : PGWALK_RDLOCK,

An unrelated comment about PGWALK_RDLOCK. Maybe PGWALK_MM_RDLOCK_VERIFY
is a better name since the code just verifies mmap_lock, unlike
PGWALK_WRLOCK, which requires vma_start_write(). PGWALK_WRLOCK_VERIFY
might be better named as PGWALK_VMA_WRLOCK_VERIFY.

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


