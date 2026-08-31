Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BE5C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 02:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4216B0088; Sun, 30 Aug 2026 22:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCE76B008A; Sun, 30 Aug 2026 22:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86CB6B008C; Sun, 30 Aug 2026 22:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2246B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:23:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCE111C1D7F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:42 +0000 (UTC)
X-FDA: 85159968684.06.7F602C9
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010053.outbound.protection.outlook.com [40.93.198.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 134FB100007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Yoz4bql6;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788143020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pKQ03Ud1z7nEF2VMdIFa3oY2Ivkf2VKV/A9qrRQ/nTQ=;
	b=SWnO4/o4OAdvDcJOGFxZuL2r/nHbd6rj2nBbY7RO9bi4Abq0Cfi7fBnb2zRfBE1tXhgJYD
	f2xRBpJLxYLTzpTSrmWqn0O6blvNdNCPAAFS5LRUb/h4wOZiqFaja/0wU7WticB45SPFj+
	GScjhZbvXw1kjb8eCXjSdPOW6lwnuko=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788143020;
	b=vDHFdwhdaw/wJJZa8VIbGY26p9jV1VAysvDNvBf2sV3tJczNnCX2UC8Wp3jh2wObUmwKAR
	PqeznhaPp9IJtTvxF6Yx1h2M2hpbf1g3rIZjQu8OT8gI3/lMJLceNuh2TivBni4GuU7UjP
	XAEaWpTZX+f4xSUYcCgd/NTZLcuG24E=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Yoz4bql6;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rky5BsVcYyRET4r4y7z2I/JPR2RUZsKSTZlW5UBiPQ9HLNW1R9200pFheGx6Kxwv7yaFYPrfSKw+5EA4TQg204fKnbhrSLCV7s7NrlMjo1Gdk3Q7tr/3qFBiW9vGLGwPGASJhKoNenOOktiZZy8nMT/JaZ5g2+nhR9v3BARPM5Qbl9NGIuo1mwYHZB4xBD8kJZvX2QWIwrTP5kty6F0lKF2oYY8zt0Vy1EUiXG+gQ/su15aWt7WXKkmvl1cndENKq10znRfstiaPbYMpIQLabYegYvdr/cKv9XDDpn+MjbVEgi56/w2+Mb+ikXkPB8Kk4qd/hj6OciwInuYr+WVO+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKQ03Ud1z7nEF2VMdIFa3oY2Ivkf2VKV/A9qrRQ/nTQ=;
 b=A0jqx+bf93UN00eOo/KJ/B6l36XgWaHBVRmzr8vtxgaaYktbculvQGP5GJHPjnw2MtINM4srUJ9wXcrSrCXgIWnq5nHe2k1HBVZk+5wF+NxR3vd7zukjfOGWdq2J5iEb1ZbH5pjBX0V/d78jT3nDwkqUZta9PACsmRqiQs4xXHnPi6XEae+vlC5kNZP9fQPlgp3advzo0rtrUgjsbrzaTCOEPJ/tNWYlENRpb6ArOquV8d9QYfjcMQChUctoKBDO3QyuhXGb+HZMkvj4SXopfXiA89V/dshbLo3acmA/pdZe+JVFy5JNEKYnFGfuwQJGUMaaQ3+DNgHWKjZu6ML9bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKQ03Ud1z7nEF2VMdIFa3oY2Ivkf2VKV/A9qrRQ/nTQ=;
 b=Yoz4bql6+lMxnKjumSVQz9+tSAZszvkuGlVqN1pN00XEVDFBG9DulW7E2oei+PPgY/OE6Vf9SXDZnp0BtKqErYDmJNAdyRSg3+NKaANML+1FrtHNmfSoZFmPE471VRHdXiU6f4y0A7G56A3d6V0OVNLhYg/0EIthV4+hx1HLLY5qMYmsYDmFRSAQkGpedY5/MnMHkgW4+bSQIF3HcN/6L8cTNCBtjOpTLrZxuvuUVMyjnIrQY+Fep8IEl3060S6LUYH/7jGUlat7332s++p0K/SM/Ruxh9Ws6nJTPgo/zr59qHWeitkEeyfJx4npzZtK5dVHq4tTVtUOIcB1ItkVng==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9028.namprd12.prod.outlook.com (2603:10b6:610:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 02:23:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 02:23:35 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 30 Aug 2026 22:23:23 -0400
Subject: [PATCH v2] mm/slab: reject unsupported kmalloc() sizes
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-limit_kmalloc_size-v2-1-bf4ca9c63c88@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ6CMBBFr0JmbQ0taIkr72EIKcMgo9CaFhuVc
 HcB9y5f8v77EwTyTAFOyQSeIgd2dgG1SwA7Y68kuFkYVKqOaSG16HngsboPpu8dVoE/JDKTG4U
 6q8kgLMOHp5ZfW/RS/jg86xvhuJZWo+MwOv/eXqNcvb8HUQopDjW1eaF1KhHPNnLDZo9ugHKe5
 y9zyTWVxwAAAA==
X-Change-ID: 20260817-limit_kmalloc_size-3a4a2c73beac
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0098.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9028:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c7865f-e3a3-41f3-337a-08df0706dc05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|6133799003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	GltRCiDAzw4Uh3hsBmz9iFJwcPLJV/1akq8GtbLM0TQpKkKjI087vnN6fIfEtfyjapd0LyoT4yqOyDe013G4rR42HOb+YeuWVMYIC0RYwYCTIhpPnHU++/eI73IONIDTnRsaZte5peViDFANkjI5Qfej/rn0smGuaBOKE5CSYmqPmZKXbKpJ8zLrgA3ynEIUiX8vMb/O9C1trT8gCI8GiLZtrU7d1GJKgX7YC+6DNpV5D1QbvVZnzFY/a/FXJEid1otSiA/PDJHXPy08gJMYK8HW9JyKqtfoeVhMvDZrJEM4xzOeDUhIpBxASs6WKvvatFpgFkGNRfd6TEaWK1Z7fGvvpjXaQHo37pBbjBvOaR3+GkJJRK7Bq8pCnYbFKCXFDAreo8XfslrUQR71NnjTm1Cp0fqQkCZDX8Ix99+wPvTpRCfMmV5FvrG+u678NztDXOV4zMLxRynOUy3OLFtupa29XXHVwrAVPieCtiecW6kp+3yGNOSJ5j+IEjZoeyvIKPycxIr829RVcfa/JzWyxBKkrjvE4xlUDmQaOs1AZ5vLAkRUYYhE+yq8vYjfVLULvwOdMzONCyW5o62Gnz2wJVar8LMOwL+gsU9SY1PJ7+HM20IRboczsEFppuRBBtRMaGxM1y6AYY4MxUh/BbB9+9MU5P5qWXRnnkYI58MDOVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUp4RVBZTlBKLzlWa0FHTUVyRWl1OGlDTjBLVmJKVnI2TVJNQW53RmtKeUE0?=
 =?utf-8?B?aExCeVdxNWVHMktPQWE5b0VDM0lIL0o3TkhkUlQ3SVZ1d3F0UUtxMDdCZGFw?=
 =?utf-8?B?eVNJamJPVytsQzRWSG5DcWtUSFhyemtzaTNONVhkSVhyZ1VaKzJydlRNdmdL?=
 =?utf-8?B?M1NjUjJKakt1VXF5UUlkR3dnTzIrbEVySGduNmlCb25nZXdJTUVocTI5WlFW?=
 =?utf-8?B?MENhVlNVOGtVc05HTlBhMkpqWjI5UU9vV3M2Qy9vOW85WlZqZDRoMXhuVGJ4?=
 =?utf-8?B?QVhMU1pGWGQ5cDIxMFprbldva3BKVkhid0x6cXE0Yjd0MEpuU0w1TWhIb2Fl?=
 =?utf-8?B?dXFtK28zeHNBKzYvTVZ6UHp6cFZtalo5UDBBWnhzbjErNGRYRWVBWVNqRmYz?=
 =?utf-8?B?dVdDSDNVTXQxaHZieUNyakJFeG9tbVBFa1lVY0hDeFBOVEd1UUZyNDZHdnJu?=
 =?utf-8?B?di82a1FocVV6MFc3cFM1dkRQVGFxZDljWmtEekVUaFJCYXRzMHNtWDJ1WFdx?=
 =?utf-8?B?dUYzdDVvV3BoRG5SUlB1K3k3QTYwV25EWklIamt5dkVheitWQm40M3V1MFFF?=
 =?utf-8?B?aTBKS2htS09RQlV0OWlTNEdHWVpKVVA3UHZuTFVOM1EvSGQvYlU5NUNBU2Fl?=
 =?utf-8?B?STVGeitIMmptUEVhbktqNEE5cDh4T3R6Z1U2ZXo0dUVva1k4a1hOcmxlandI?=
 =?utf-8?B?VUI3RTR3LzNPUHR0N3hZKythUlI5S1ZiRTZjcWlwaGJ3Ylp1Q1JiNlVsdVdP?=
 =?utf-8?B?d3hOcDVQSTBuU3psYzBGWmhyTmZUWXhoUkwxWFZrbmNKRlg4RjVNemVGMDBM?=
 =?utf-8?B?Nis3Y084dTVyUFMxM3hKczFCZkluNGhFNFRETUZiN29MS21NZ0o0Tm1qQXJu?=
 =?utf-8?B?OXNLWTlad2h0aStJM1QwUk9HamxUOGNlUGlHOTBzYTNCdWlaVFVZTUpFdU9z?=
 =?utf-8?B?ZklNYTFva0hHOEdYTUlIY24wbWdtZjFMQnB5dXRVaWI3Qnk1YlZLcStZY29v?=
 =?utf-8?B?anRkZ0MrVitQMTlQNG9uS2dMdmQwZkh3UTJhVTVPcmd1elBtNDFTeEVydE1y?=
 =?utf-8?B?dXNFWlYxRWNJanBBWXZNaDlZdmxRcFFyY2Q3djMvY3NLbFlaeGVhQWwvWmlG?=
 =?utf-8?B?VlRxWXZZSTJQbmN4WTlQTzRpMjJGSXpzTzdnNXVFeG8wcUtIRW5VTWFxeHFp?=
 =?utf-8?B?NzhtYjZETHZoWHNUN0RtMERZRGFFS0JXUHE4Uis0M01jcmZBd3l4MVhHQVR0?=
 =?utf-8?B?VVpqZEIvWFErLzB1RFZJRFdmU1p3emF0ZFpvOU5HUUxLOHFObE43OC9nU3Zq?=
 =?utf-8?B?cUZLVzZRTnZoMjZNMm1DVDdBVjdFWEFIZHhPSy9GL3hHc3V0R2JBcUV4MXE2?=
 =?utf-8?B?cHoxeExtQWxzSEFNOCtaazVFOVpMZWNFN3Q1UHV3YVR1NUJLSDE1YVczNWRi?=
 =?utf-8?B?enZMS3E1cmZVZ2VTWmRWa3pKbUE1RTFqRFREcElrdlRrZXJGbFNOUW8xKzlw?=
 =?utf-8?B?N0NsK2s3djF1VlZ3SWQ4N1BHT3pwNHluVXR6SkFxWEkxMitwYld2c0g0MmRJ?=
 =?utf-8?B?d2UzYm1DSjFLRjFGSS9OY3g2S0V1eEVBb0dVTllveW5yOU9KRDZnWFROTzlR?=
 =?utf-8?B?T09PNDU2UENZSmpCRU9IQVdxazIyRnoxcUZ3UFRoTW1QNlV5OFpmeHNCYjFF?=
 =?utf-8?B?VUdNSHZXRytVNWN1OTJEZm5SZk9zZUpQcnMyaG8xZnpTVTZTQTZsNG9IMWx2?=
 =?utf-8?B?ZHpvdVNxWmxuaVFvTCtqZWVzWk5WTWFIWWF2V0hCd29aWnpuV3JkYWRVbGQ3?=
 =?utf-8?B?UWV2VkpTRTBTYzJ4NGF3dmtEd1laTjdBcWczRS93a3ljZ3ZtQ3NaUjM1TFhw?=
 =?utf-8?B?TDRDNHRMcWlwOUQydzBBNXpyZUF4cXdlVEk0WUszSlg1d1k0NXNoakJVZ25i?=
 =?utf-8?B?RXpuM1FaM0puc0ZuOUtZdVd0Vk9lVkRTbGpjVmtNTVRHaXc3TlJGdExLZlZH?=
 =?utf-8?B?YUFzOEVlMXBpV1hpYVd6M1VyRk9GTTNoYjZUTUs2bldUSlorZy9tUjV4cmZy?=
 =?utf-8?B?RWFlc0V3akRJQVJnN1g1MmE4ajIySzUyRjEvamhCQjFUSTNOaTMxZGUxd0Iw?=
 =?utf-8?B?YzBXUWF4QldHcDF3eHdwS3pBQVh1U3ZrZzNOVEd1dnhkc1lkNkRYRWJNZWgw?=
 =?utf-8?B?WVhzQXJnR0o1Q24xYUxKWFJpbDRFOUd3cW5jaXhUKzRtQzNTeEFRSXJDWlJM?=
 =?utf-8?B?NE9zRVhHV09LSG5jQlVyR1YzMUtYUUZLdFFrbk01M1BYV3BTeEZ6ZStyLytQ?=
 =?utf-8?Q?bKYVdvCd0ZIps/pcSQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c7865f-e3a3-41f3-337a-08df0706dc05
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 02:23:35.3722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubMsO3kfgEw34yqAK8MgAK8U60F9zlNlRPoMs1y3FOTruTylknp+sIL8HXzb1pOd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9028
X-Stat-Signature: 8yje5zmndj9h3tgpo4t3mjy195wdd9ao
X-Rspamd-Queue-Id: 134FB100007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788143019-642803
X-HE-Meta: U2FsdGVkX1+EVJOnikyUjHav8h2B7pWRKRsz+EmKz3sISjlHCFPgHqoWo079LUrpTNhhxOo3C15rAjBQ1t0fq0Gytbve84U3ctISDgD3U9psaFTu+KBuEOpYyVR7XYcOLgQFZSkcmwrzII3OH4yTGDGFhe+hcbNXeX4dbwV8eEx2DLUvONtcmcSS1t6zTwNA9OO5d08l81FAwXTQf9bmhE881q2Vi1CTGAm9ekcH2dJNsh6aXPUYDMGjnk67R1MEZELw9r0oxqHt5VyEu8VcBk+1LVwXVRHn7lTbFDSpqU2yz026JXj7G+6pxZ1uce6wunrBtKBZQB4EiFtvRNltns4jIX4STaOvanpqBMjci9BCajtOa2KzMCg76mv6JNhuiB+ePrmcsOp4A4ZmmO29D0XK+ILAmqBXJY/3tnq6e/Fz6zD0ILbRyeL6WZc8EF0EvPqXj6DZrPQhz62lna6il9AgrbjOUnp1up3pQ1pzZs2NKc3BYFdNsz93DJrrhg3LP2dbAQectsfDE7QSMYTT5/pqZZrkuA7dAWSdSQCVTwydNB89kXPehbP7SE98ZnDVUOsdI0pZvzkBtG7z067uUYDis70i5oFdaDAM08l54HLjsjwuuSSVf+ipkvzn5qKxElyEAvmu/K5qXvPJN/+HThr0eMETuCGL3bAjF/yX4PDgHmq29prBwHbuYSngZxIM2j3cpnfheWZKV/4iyI7CPJ06H5Z96DfvuSC8KoF8khg3A1dp9Iramcg1oqPlw1FqI/1RNs7mjmZEw6JT8vfcQVFLAvchhXEOhm58VwIgASlEjapNMqj0/OA5oMs6ok7ITh778pB/sdCrqkiYbd5bm+StWrjVWTAeUv98cKOC7wYr42vcvqrjPv6xS4mmKJx9i32y3wk8YlFHmPNpiwJFbHEKSHjQsDdNkOzYHHYUgDBTGvPDWCp+PDgonQUkEBtA0MDo1xw8IPdAX5X7f8i
 /GiTC+Rx
 lo8ORWK4rjIP9rx3StDXgPFRFGhg6i8jVQUFQqrlEn1vynaj9wFuS3Fbk4Tjm8Eoso6qWdC+RHAHYuEY4Byg9007ujuD9jzc8cSWK0q8RFcK6eDY+RdXD1TwIbhe0NsIdnZ8NnNaw20GKjqL9PpNKQhtcL4QU9RTPdPWfbmS9tPY3x4Rr8Fv0CYSRsOaJEyckIeGVUteEcX1FeYz1YLYf60uI9fLYWENOhQpfkKyJZX7rNQZGRApordIB1qSxp8JysuMRpzdlkogPiVlUXMWpVpxdUDAc9No5VYaSo0KMi7Q+VDc3LWjL0AduJRqr7NxGBqEoyalsQJ/hVUN/uN4ZNqNTLL7OkkWDf/xGrSFaVCahWoIv/FQcl6Wfd6GKxchGmhCPuyCpQQDZ4jl3ZSf0pTB1vYkzBPB4XQhKitKoI+OLsEUDu3EX5Sb/3xZwN1YAI1VDOiw2odIDKg/oilI96r33hQda9G7i73356YjyBEcKqaB7MUGJIcTWzwthF+zocw/L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmalloc() is used to allocate physically contiguous memory for kernel
allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc()
uses the page allocator and can only support up to KMALLOC_MAX_SIZE. For
request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
WARN because kmalloc() allocates an order greater than MAX_PAGE_ORDER. To
make the KMALLOC_MAX_SIZE limit more explicit instead of relying on the
page allocator check, add a KMALLOC_MAX_SIZE check inside kmalloc() to emit
a WARN and return NULL for requested sizes bigger than KMALLOC_MAX_SIZE.
Like the WARN in the page allocator and kvmalloc(), allow __GFP_NOWARN to
suppress the WARN.

Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Instead of passing requests greater than KMALLOC_MAX_SIZE to the page
allocator, reject them early inside kmalloc().
---
Changes in v2:
1. Rejected kmalloc() request sizes bigger than KMALLOC_MAX_SIZE by
   emitting a WARN and returning NULL inside kmalloc(). The WARN can be
   suppressed by __GFP_NOWARN. So the page allocator will no longer see
   excessively large requests from kmalloc().
- Link to v1: https://patch.msgid.link/20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com
---
 mm/slub.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e70..23e57a8fe55b4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5342,7 +5342,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
 	struct page *page;
 	void *ptr = NULL;
-	unsigned int order = get_order(size);
+	unsigned int order;
+
+	if (WARN_ON_ONCE_GFP(size > KMALLOC_MAX_SIZE, flags))
+		return NULL;
+
+	order = get_order(size);
 
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260817-limit_kmalloc_size-3a4a2c73beac

Best regards,
--  
Yan, Zi


