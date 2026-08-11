Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21F3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BFD6B007B; Tue, 11 Aug 2026 15:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724866B008A; Tue, 11 Aug 2026 15:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B546B0095; Tue, 11 Aug 2026 15:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3053F6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:38:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A2D51201F5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:38:09 +0000 (UTC)
X-FDA: 85089999498.14.D0A9DD5
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F02D100010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:38:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NEsFGMkh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786477086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAu1a+d1NPMHdf3zHTDTxjSzZgyMUkS78CETRBT0b/k=;
	b=QtyMtyM0gIaUlGKqpe0XLPLvU5w2pvgguCdx7kLX3dmT47r7qbywbBD/5piqVgfEeO8dhU
	tsv0gxsgEp7a2tHL4AhaFFwSwH/AQVaGENCa7HWRvNDP8LYBi75N+1H7ZHH10A6Vy48n7L
	2Jg/KEr4yXX6nO7dNNgss+vQ80blNd4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NEsFGMkh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786477086;
	b=Pg6dgZaoOYDhijLSC0sBCEOrnsEDurJ86Kg8k44stQkLqMvas6PiAsK2Cx7FMF6I34bvHc
	XHjV6u/06cZElQjWq0v1q95XlR+nsHsR7gZ8xHREYgMmeYVqyQ3LnGroH+Pn9o8iN3GlE+
	NxbVwttiaZ5VtlNM1lM7IGw1pEDYkHo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1oxQ2Kg5+cgYLiKCn6soq2wYQoZP4OY0/JK9pdWZXVOdfNYrUfQZPtcl0pPgR96OQzd+dqP7UTABY9lTcKxMsMZw+evwMCYH/NOGLue1+cGI96pHwMUOy3XjcGefX52Xuk8TSVa4kYbyjU0rvweVOwoSoG0inY8M4olSJiXPthFWjqE01AzDwBbpNQJBQkAH9WPyFR7Wrizy2lmE5umNivGgZiPAJzaKn+OfUHqkFFdG+gSwFSziPwTe8pY/lNNZl1A6I/BBbr6prmC22LDdHOGkIzCv9NHm15EWSuNKsuSqZmxPtsbGZYa+GicggbwXUI6bIqAD8La8LQe/Cjqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAu1a+d1NPMHdf3zHTDTxjSzZgyMUkS78CETRBT0b/k=;
 b=v4KrqqtjTpC6zp+qW67Jo9dK8h+GivTOE8u9cFxYJ6Lb1RRmgLMepQDmuSFMZN5iD8Jf2HR6MDebKxf0HEaGRsjAgmWH/Zt8bGMqhTX+8k3tSBQw4qV3zU47wO/DRtaeM7FUK382Xf40meLL9/RYNVyodIKfUuVIxe8akjYh11nNebWiAoebl75O0+L6iQnVzLkBT32LWBC0iGxiOOyt+8tL31TK3oBXGsMQ2IEJPL7MF/04JLGh1tvoRzzBcvjfcz8E2xBBrlv/ysFFNA6VwHBdXc9mTaLw9AU+9Rkcn+d0AF/aRDzGDh54zk8D98SZ6iZ/ewtLGdzvI8Y5WGC+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAu1a+d1NPMHdf3zHTDTxjSzZgyMUkS78CETRBT0b/k=;
 b=NEsFGMkh+IIj9b8yPPQOIQxot4LUYqwZg7wV/1zpqmZS4TPfVpv5BAFlzzE6tCbcyO5JF3Z2NMRE2P+Bqtls/vLfJd/Bgnyo1nMEEIuZ0EfskTjFm0vujYK9jjRCWXI2UPtLzW8uk0z6uvCy/3X76XpW55j8EukDVhS7upQc0cskkueVegPrArTban/4OTeIPug5rzU3aGBDYABEAbKdc7Mq/IaG68WKCs0AmZyhqvoDAJS40G5+jiS/4t5HVe/7vUuZ4SDc/GiUkTVh7dvWQjXzmS16iq1DCqSeEeottKQmZtibQ+UqCqucDdItWklTi9JLSYCrlyQSbqOVG3AR3w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9751.namprd12.prod.outlook.com (2603:10b6:8:2ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:37:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:37:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 15:37:58 -0400
Message-Id: <DKMD9S2SNWGG.XECBZ6G8LS3@nvidia.com>
Subject: Re: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Pedro Falcato" <pfalcato@suse.de>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-2-pfalcato@suse.de>
In-Reply-To: <20260811172156.356053-2-pfalcato@suse.de>
X-ClientProxiedBy: BN9PR03CA0519.namprd03.prod.outlook.com
 (2603:10b6:408:131::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9751:EE_
X-MS-Office365-Filtering-Correlation-Id: ee911ed3-1fba-482e-e27f-08def7e00cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	mn7WJ6WrLWh7OtD80qUUMoOvURJviU9SchAdm54hu4LAj2oBIVFS3ZvE3VdsSStkW+suFZFsbWLECcsM34JJ3bunYaLzdIAe4bjhRfhKV30gSISKdWR1zCkbJ4snKvP9gnTXCoiHQ6iHyE1MvBJ9dyfKGwnJ+9TOKsuIvGTSOEzstcohAvCxe3SiKnt2gw72fIAwXmEkRBG/i2tJzNfJwZH0npCtIGgvoMMzfPQ5vTLb3fCA8Wj9LNmZvo+OHp9PMtygDBFfZtVOTWgje/wBO6Uutg2ks/Vxzy6bZ1fNRcxNalYfY/5UedQZfMK9nQDCiMBJogRO0fG5OwSc1y330XPF44vXxSUPmTZFH9bZJlAxjBkCSIGycHoJLkifWxOk1+4mSrWCRdsMJvgepU4PbIJXA6Rx/ky8GCn8vNY9mRY8z0W9bslXlcCk57n1EjvFKYWs1rq7gDUCu7EPg/HZWs8SBsOQswMrmF/ygPZdBSH68eFS4we52V1GyEaZTadIH5WbWqiCuOAbZix1YuSUrsuX44x43xQcEK7ToSqIZ3ztI/YSF8sEYA4dyr5rFtj/BDGsxgXI314t6auS5Bl8RpE1pO7EOWSCSA3xg1nNC0vDnViMZvD196phstCmSJywZf9Tk1phuhDNJX9hYEIFE2OO/K+cHUQPSjzqM49VY1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU4vY2c0RmdCVDF4c0I0dlVaRDhlYnErSXluRENSNFhIYVRibVFlWC9pN2Vt?=
 =?utf-8?B?cEMvdm9qZlhZZzQybFMxZG9XYkVFTkZjL1JMSmxoUGxFVlFueHB1c1BqUnU0?=
 =?utf-8?B?Wmp0YmZsaTlhbXcrWkV2Nnc3NFNJQ0M2N2cxdENzT1VJVmFwS3NWVy9GSEVh?=
 =?utf-8?B?akdlSVk1dkN5cFdOL2Iyd0hmUytRZkt2R05MVithWm1MTkhXcy8rbFJsZ2lS?=
 =?utf-8?B?UXdnUXY4NEpJL0JUcDBvaFBBaFZUSmw4R2hEUkNRZ0lyUGY0eTV4emhTTHE1?=
 =?utf-8?B?Y014U1FobktNOStZMXhkODN4UkJwUmIyeTd5dWhtUWxZSXlZZnBVemE0ekJ2?=
 =?utf-8?B?L0djK3NneDBUTkNWbVdVakxMMEdBbUlPelJyZFMzVWhSeU1yL1c0RjR3dGZ3?=
 =?utf-8?B?NWVFSmNUbjZYRHZYTnJVdW04Ynh2WGNJODYvMDcxVS9SS1BBQzdWSjE5MGRh?=
 =?utf-8?B?Rnd4MTdLbzNUdnlrVTB6LzdDMmU3UkY2cXA5UWFTeW53aEM3OENNOGgvb2w5?=
 =?utf-8?B?V2tpUWRyR2x2bWgwMU9rcjQzTHhUajI5YUdnM1Z1c2htWlR4TGdUdXJ6SHJD?=
 =?utf-8?B?UzJmRFNnMEQ1TUhiWkt2ekpQdGtYV0dKNVNUSFZpWFJtWWNjb1RxbndCcUJY?=
 =?utf-8?B?ajlNK3NVaUZZVElNTkQwNzJvUlpOamJ3OXR5ajU5NGNXMWpPRDdaWmROdk9r?=
 =?utf-8?B?d2FKTnhjcUpMODBNZ2poM0pXTUJaQTlzMVA0NDVVVEwyRHl6QmtkZ1FDR1l5?=
 =?utf-8?B?QkcyamZGV0c4b3I2b21zUW9UV3F3RW56SGJGVmwwWno4Q1VMSC94S1NBK1cy?=
 =?utf-8?B?akQ5aG9VS0VVY1ZpYVRhYytiMFpMdlRyajNxMzRuQ3JlUjQrRFJOSDZ6T0ky?=
 =?utf-8?B?V2FtM0pLbS9idUtPdENIUkd1V3E0LzBLRmVvTTZJVmwyNzU3by9xUmlMdHls?=
 =?utf-8?B?NWlXMWFZTm1ZMUlaRGxuanpVNW9rNVZNS3MrY1FhMWtCcWw1bk1tTGJ6Ym5q?=
 =?utf-8?B?VjlOMTdJMCtaVnc3RVczblNweHhXdDM2RXljQ3NCbGxLTUhMUzV0WnhtWkVt?=
 =?utf-8?B?RHN5TmlWMmlUOFhuVkZpZWxONGxXTWpMdjc4UVlDWkEwdXQ1b0NBWVpxUzBS?=
 =?utf-8?B?OUdFWGhhYW5wbGs5K1VXdzgxaWZNMUlIQkw3M3NhMnlrZUtSOHcySWlBQ0pN?=
 =?utf-8?B?K0NBcjV6Y2hqS1ZDVnJkaXA0b0srRm1NTWpOdEU5aWJxcUlRYTVCaEtPOEhY?=
 =?utf-8?B?SFhnNk9TeDFuQ05HRWFsRjJsaks1ZC9CaUxkSFZKMEVxRU9DbFpMWUdiNUFK?=
 =?utf-8?B?Y1Z5NGRTVCtLRGpsa2d4SlRkM2NCdGFDa3FzVjFPblZQK096cVRkRWhWUTMx?=
 =?utf-8?B?OU1KdG42Z09YSjkzRWk3QWswbDhyemJlT3Z3dWhLcUlYNXpRb011SS95bkxX?=
 =?utf-8?B?VjhpRHVkWTRUcUx1YlhzZnpPY2lza08wcUlRVWpFWkJ1U1k5aVpuZjFmT1E1?=
 =?utf-8?B?SWUzRFdZbnZZUG9QZ1huZUhPRWJ3M3ZmU1BoYWN5d0ZyVW9Vb0V6YmhWNCt6?=
 =?utf-8?B?SVJMckJtRk5NVG9PMWp1MnNJb0NWZDhFa29sTFU5VHNKRkZWNSs0a3JpeXJ5?=
 =?utf-8?B?cGhsY1k3NUpOU290aE5vUUxjTmxkU2VwS1BTbXhFSXBlOXloR01ISlFBRjcz?=
 =?utf-8?B?czFvSXAza3V4eHphdWlDc2doVDFFY3ZyaXdkMVZSMjNHVkVRVXJ5b2tmMnlK?=
 =?utf-8?B?UUVaWXZxMFV6WHpDaUVJaUNRallhWUpuUGxhT3hONHRLYldHSzJ0b1JBQlB0?=
 =?utf-8?B?QTR0Q0N6enhzYTZ6TDhNeUVIMVNBOE5xWm9SWUdJSERHNTA1TTlydVZPVmNC?=
 =?utf-8?B?K25pRlYybGtvRldsQmhZUi92SWlsb2JYSGNGU25hWDdpU05lanNML1k4eFQv?=
 =?utf-8?B?SHBJUkoycmtnZ2NlYWcyWkdybysyaXEwOER4TURreElVdFh4ZElZOFNhQ0Fk?=
 =?utf-8?B?UGhDd0pvVzRlTTRJcEkzcGh5QmRMaXFoSEZYY2hVK0g0cUErdjh3WU9meDZJ?=
 =?utf-8?B?eW84MHJLWUtta2R4WHlLbkZHdjJQUTA1VWVmUjVOTTVPOFBBamFTVGZCWm9a?=
 =?utf-8?B?bzRuTHpUNk01NEk0TEY5MnBqZjcyLzVnNzY4OFZ3YU85Rkh4UXo3T1pDdk5p?=
 =?utf-8?B?L1BnUld4b3ZRdlRDYXF5VGZvaVJ5bnBnbWp6UVFhaXB5VlpVWFJUdFRRdStJ?=
 =?utf-8?B?M29jQzZwZnhGUFVoN0pRUC9Fb1pPK2dEOWNoK0dsSDdrU1hWVkYvQzZDbkJB?=
 =?utf-8?Q?qcI8+i4WP23gp5p0ow?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee911ed3-1fba-482e-e27f-08def7e00cf6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:37:59.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOz8h4/ZpaK6iL9vmYKg+8P6gLT/nxBe4pIjPkZEzKfLyoQslduGH7UUFKFIz3Pv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9751
X-Stat-Signature: gw496nxo4oryqq56paicu9i6ucw41nko
X-Rspamd-Queue-Id: 8F02D100010
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786477086-16956
X-HE-Meta: U2FsdGVkX19oqIamcJwzUoyLFczyVTFSnxFB7Cn7ISMZ6ek5HeuuVKox+UV8jbdC75R5yG+F8yiHtpVJhDXiHHN2z4yINo/bWVBVSXemmR4g2wvTOzAUKjqMQCaChfwfzBAzEIsWi4O+HWH5Lmn/MfJCBkSUirM96rFlapgMs2L5E408kfsw6iq52aRgZR/ZWCC6tnVRsJnrMMLgsgcXGn28sNQHUIsq4Lxbok1JquUUn8eTKzjPRTSvXUCAujvJimVX9Pixmkz2AgPT702twiQ2HUHPHiRFjEtpaEKNByS/iP7ZO02HJ/fEHzm2Y9llgXtmQc0evGkkPkkE+0eGmTzMCHTjD1+4B4JZxYNj957UIz7mu0f/silwXDOYRy7TAcVFO9IxUV1mlD4jReTwpEmBXiYcA9Rztgsi1kVBuhCO7KklM6Hr37rzzArTdSbGJTo2d3n+Kl3DEeyj8mnhgZPM3yDF3ixa+o671OzT6PPmJ2UmDIJLkr4pG1t1e7hbcPN+uteyX5igAoZ+NctRZkWHExxVxp79Yx3TnRk8F5+wGDNwJwm7+qodnvCtkxpEBiTm6XqCy8M9WUWtjbMlCMq7HnsQwmQVeDQTM0b/tK98DH2QNIhrzBPpaTirCpGzP7ppgdMdf20DHsfsithmiJnuZdaoG3JYB1enxDoQdkQ8myFM1cz2nYvB0RcHAe92KC17LIbzNdk1rbkAiFISfBfVfCPLoXWhZdXQCLW7NjGZQtbiGjMoIKQKTeBtjT5ssLEO+YMTT1kuv+XBOYSqwjpHNSRLK4xCV92F/pHRJw75U2zhMim6VvS2aw9RhjohhvCWLhAjWCysTbZEMFRHA064AdT2INTGf+VZGVqi9ZUBhicTcQl8le/ikFHXW614sKGmloa3K+vRpqUEhUjRn1w+sZ4l7RqiuCf2+B3ZR2jKilyYRalCFBopUpJaqVeZ80UkLyuWkWwj3G/nBDi
 dA63qcJ1
 8TFz9Rzzwv9Z/46yJemHGNx3oLFVXdheULggkzFQtbMacQU9a974sFsXwqndViiMHxKXAmQjPkI21YQNEGIfQ1WTucMMo7NHG1v2nls+iUkfqwYzkZCy1W7SKxX/OShlbMfWBV0vkJiTOJDD1adQsaJ+xwCESSPu+gIMu6J+PKB6UD8S1wMuQHkYq1xNdrwRkKPVfjJ1e9J6BbxR8yNTcSEmqCP8qTeWTrvawn13aaJBTNH3HMfbht8AKgZzkaLpMH+3smQX1N4C4oairlKiGLKwaIZZb9CGiHd67Z7Ws/QWpcelhIzuAoCvEezY8gAcib7Nj0hWnrXQvkl68LycVlklgpT+eLodTsCLn5VBz2iGotvl5BM+uWVsfGSqUsuQUWwqek4j9iEFyitKU7WBF++UI1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 1:21 PM EDT, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kerne=
l.
>
> Do so. The only functional difference should be that the new logs will
> read something like:
>
> KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...
>
> But that should be fine enough.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/memory.c | 30 +++---------------------------
>  1 file changed, 3 insertions(+), 27 deletions(-)
>
Great!

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


