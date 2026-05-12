Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CCCCD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FA96B0005; Mon, 11 May 2026 21:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFF06B0088; Mon, 11 May 2026 21:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7496B008A; Mon, 11 May 2026 21:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48D366B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:28:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E87A1A0179
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:28:43 +0000 (UTC)
X-FDA: 84757033326.19.8D93FB1
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id EFD484000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:28:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XkgGnXWw;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.14 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778549321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2gw3dS1qNcrU6k5IbWC4xNg0O68yRWzSwp4Hx+eSCY=;
	b=vghfWELKa0FTeJDoFYXV6FIuXnOeDPcoiexg4dbqt9+wuBz2WamSwC1qvWprVrqD1jAOBj
	c4gtWC930lOl7eD++1VfOUMAFGLjAHeBzqT1RrtLR2F+W0ry756XDk2LsQISKT2IPM160e
	JRNeKZWlB4Hm/MQ5E7XVA2NV1/5Gs98=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XkgGnXWw;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.14 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778549321; a=rsa-sha256;
	cv=pass;
	b=7wtxVfW9fQNjjCBBVA0iR1hMePh39hwlahISnIjeChy4SMIw1+giowwaDcf86C6JXS0kCv
	2Wv8m25pebzAlWLXwMtAasYCALLIJTFPguWD7lW5dCaq76OFjyeFT6M3STXwXpKFW5Wipg
	iTD4DXfe94KHTbBLKc4I1CI9l+QTj4M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0rWuE7fTWKia3gFPhdxg10Z9MuuQbQn+dKbsNKh6Z/1ew6U9alZz+j9oN4S2Yy/NPTwdA37QC1uuxH/umSiQ/dHTqM6HCaFpiuQIwLr7TvOLaXzhsPnATzIesTLuCQhc6Vdt+Q6O/q2Wy0LXHJHbAitBgUGBAq9IFFsC3ZOv2VeX4FbUeYB17PtGlFLpMe6X1dbWutAqT71NXEUw1cBQZrO7lXtEYfMapJMjvPP5oQ+De4U+fgPIbgkLkuqtlvc6tYdKC+zE25Lbm50azDShWvutELd9UoVmF5ZhR60sRg677OT0QUX0RptyX2FQ4NjeI2VnCkv2nWpnvNpO9UIpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2gw3dS1qNcrU6k5IbWC4xNg0O68yRWzSwp4Hx+eSCY=;
 b=oHWof5fioq9aaRCZjpxJ3VLjzvKEjYFK306fuUAGeD1wTEl6DTygXG2BhAeuHljlNRfZ09deyFK60Ey/W/7+qKJV+oiixv7OZc3wCH4gIkudhFLypE0jDgGOIxkGgANF4Tb4EnuPTtJY6TvAVeiq7ljpPEB5KRXX9295FoZBAqNcgCAiTgYnM5U4EQwEgAdZi3z87LJ2qLWtUjo2DJBKp0U2qgnM+MZVgyHnxT/yDeZtH1/uyCVZ1LTWgrJ4P2mnX2FtiZwTBhz70xd6E4thpR2wb7RqUQJqrycN8XCeKH3TBElzgt15OyIpmtYSTy0xW0XlcGMCwauyQyQIkzlBUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2gw3dS1qNcrU6k5IbWC4xNg0O68yRWzSwp4Hx+eSCY=;
 b=XkgGnXWwntA3a95ZgoQkSnCmvuAQEwpn4xhWdLl+BCPwB9WMrhGzzCw4jMShFRr4Ud03yIKOVM1cGhLccQoL0ws+GQusr9W8HJm6LuVw5nT/i23HdW1RdZl/0hdFWDyjl6vB6kbqkm0bMuWjgHB6hr21cOFZQ6P0S5L9a4Yqs2MV3k0eV1h5JALGfmwEIHdSoEO19hGOBFASdcLy/6EZ/zmd77sD9l77I6XHjMdijzLZXx3x9tpk7r42jT2EPcmP4nQOVwxRFoAddwS+T3RSAJtTDt7fqbINRJnQ+LCNGivDTn32XxTPs4bW8DQrY6WnnD6P4NJv3VWQpNCg7kWewA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 BL3PR12MB6452.namprd12.prod.outlook.com (2603:10b6:208:3bb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 01:28:33 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 01:28:33 +0000
Date: Tue, 12 May 2026 11:28:27 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, 
	leon@kernel.org, Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
Message-ID: <agJ9762r0HwKSsb7@nvdebian.thelocal>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
 <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
X-ClientProxiedBy: SY5P300CA0008.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::10) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|BL3PR12MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: 006dd090-33d7-4b95-b971-08deafc5c7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|11063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GPxAzJlC4mklXCKSKb9HHzIYzuKlujV1XaZhgDCV1dZhvj3DaMLmcKiJivFX8I5lAA5VV4zpaW4CRrMEWIrQ2VyDrcf6GDBwbvzMXqR3WxbygMJLY9nRfOb/Jam3X3x6ZAXPjMxHDtI1HMYXyWFigC8vCNaoGwKkRxQ0RzqGT2BgAtvU55jrQjdjyS+4BpqXJ7yMdykNHEAG0BurMnyZI9TBWV6uK/JZfuLTPyHkA1hS5vvxM2W5KmmOZpqYaBeYu+pXpP5fZPw5EI17JliNyH9CdyCeKi9s2AWI06oyx/ifZ4YwDuiknEBWVe+7AMxU1gkka6dV7nsT0z9fRi7XUSGJ9M9rb28rRLXoEGQpdlPXm6dBhCbLVKHb/ZTsNNLsyBwcmTRoAECRvbYhPAQaGq/X5rPOvt0c9KwWw3yrfOrDQt9CcuolUV+XYJsLwgBQ0GXIvjwf5gAtJdw3EsqKN+uDIhsvwhnK3cfzfh+V9bmPYorT073ZlIz/3dAV83hTnHNU5Q799iaNaqEzJqW+6sRW344G6/EBQNDElmLMkvusucgDsGuOadf/2JhEHd1z8xSBKmO+dOEMFNUmsnOSInt1YfrnXaLrVgJLHBreCZOfoIH1q5ybx3vYjCk2Ju8uMHdcWTcZXt6GNPB78qgGC9K02pYT5DcV106SfK1yLecSbS3qGCZSxZZVSf99jO3i
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(11063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8bCnnbUjLk23n5YXTDkJLILiBWdxmfxMDt6lEBM2TjKe3a67PHmuNS8AKvq0?=
 =?us-ascii?Q?syPTz76oe6RqYcOLMO2ILmA5m63v/6Z9roEFwjBHb1U0RNgLv0MilRnesVXa?=
 =?us-ascii?Q?R5/S8ocW7llOuVrm+mXlNMmYxyJ/M8X1/W4GOCQkdRd5X7L86xO+uwKwiBpA?=
 =?us-ascii?Q?lXNYY4DUm3ifawrQvRUJtYqATOHZvKVl/WYxvUTJUzH7BtArfUu6YXMNgPYp?=
 =?us-ascii?Q?Deh3R9plTBxnMdm5d9QunDPo2D2D860cdLOBXotlB1km1WPowydnLRVhxloY?=
 =?us-ascii?Q?yTxjnPCwXRDmqap8KJ9DIPMCwbLS1nB2XPykLCMEtyfg2DNip5frk50gERwI?=
 =?us-ascii?Q?rwwHUfDBYHTl7hGEOUnZcAxX4MsW6wITydVzH2JKGX3vrl8TVwh4pYTUtC39?=
 =?us-ascii?Q?Je1Flq0Xj119rjXLPAujP6Koj//LbqJQYjUXC6nCBPVO8O/8904j0IQIZoRG?=
 =?us-ascii?Q?yS8nMUHQ3egWE2eqTK7VtUqaej+hhp2Wdzx+8ehOvw4tBOBm9IGl9yuGGEQM?=
 =?us-ascii?Q?B9IurCKVSgnSEy/pEUHwVTYNSafalnY3GB7mgIYfhMimbDQmwaBl6z5huxAi?=
 =?us-ascii?Q?isMkYrlTD6ij8InMZiE7+ybwn3zrfprL4InbxY5mfLxUOmxQiBBDH7UvtxfZ?=
 =?us-ascii?Q?ncjO7Mr9FE1cPNaFolp29CuLMAhku82bVL50SUjJtDud2lHKXDJMnZPQWeLQ?=
 =?us-ascii?Q?tpoIIjLekZgjpKWfXZII3B8wRZqipgO3ugNG0WIIEOmlqZwyaVhPx0+cUYwo?=
 =?us-ascii?Q?i2q69taW9/fleHvYzdbZPF5XRJctoCPJQani0YCp5uPSSOjysmMCLACfRCkX?=
 =?us-ascii?Q?osfFwGxI/hxYCQgwT9uyKqfbOgUM5VQdPyu3hs73Ei5GobIpO0qZrZSdRmd7?=
 =?us-ascii?Q?qFWtHKN3rqngb6FlybjY5DXA5PuhK8edl8jUEhQN9bSzwX/Mjzn6mBBey5Dm?=
 =?us-ascii?Q?PKk57dM+eSSHqyStFC0PInAjnSw9Jg2VGCjcYAMokoQIp87EBqKAcBsyR2mH?=
 =?us-ascii?Q?o45kigvUDu8XefEE30DmdqVbrnMJ5495pFguZg/0SdAm5buNPTKPNwKBUqx5?=
 =?us-ascii?Q?Smz0B1Ta/aG+Fo3MAmlm9RkkvpQd7rgI6HFW6RF+D6rGPTkOsSe63kiKLoTt?=
 =?us-ascii?Q?lDaRJkmVXhS6Ubb+lBg6GbzDr08gvYAb2BVlzxbPJOiH0S5QSK2LCuACmfq7?=
 =?us-ascii?Q?uWacgM9kJvoidVdNvdJME1PXPkkrUMNYy30C130XAcioAUadcEWm3Kw8Flxs?=
 =?us-ascii?Q?sDzO5/tP7wRUAUH+++abYRLS4EJ0D+5NbvFYHlz/WVwv1hf9Jt55CC3BrCuS?=
 =?us-ascii?Q?xDfLyH3EQsuPDZt2LXkMjjLV7iJUd8dtos2Y+A4BozxuE7EUSvmDk0zjen8x?=
 =?us-ascii?Q?Xx8ff4K+Ia0oM2Ucvh/XBvMYpZZvX9MvgSso6KWAKHXysmS4iVgR9gOoHr5k?=
 =?us-ascii?Q?RDFxLidqiYdVg+LlNkipcfaAoBKkmlZPFUtEbFKrRLI84zjhahuC2BRtcfx3?=
 =?us-ascii?Q?9Z4ytcNQiXXyNlMOdsqIuKCA+flZw8d4Gx1MkbATTz/9F32F0ZGut9jhtKx5?=
 =?us-ascii?Q?s1CDDVnJ8EVc9Q18EidJWZrPNu7CggT2HfUZsKvGY2qB9o/VpQs4mikC9aA9?=
 =?us-ascii?Q?P+MiGoHI54a3zT5MCAD710qG5mne/qvvkkW2TG2id3X6CVv2W2OX+/stiyAx?=
 =?us-ascii?Q?QG43V4yVkr6VUmbgyzWi7YboohzqiArjcd9g0GbPQAHo88Z0Jq+jG5RFGAX4?=
 =?us-ascii?Q?vCCFxUO65A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006dd090-33d7-4b95-b971-08deafc5c7f1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 01:28:33.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xreo5ElvolhTCBXkEBtz4ppgjOdJgMLS/C4+b50NtL7nh3umPTqDNkiRU5vLjcOKIaOdOybeYZEBYiP4803z0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6452
X-Rspam-User: 
X-Rspamd-Queue-Id: EFD484000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 6eigayufhgtxar8idqr8stkubtqhtkwb
X-HE-Tag: 1778549320-442979
X-HE-Meta: U2FsdGVkX19PJba2XMY0zfImyEjW/iZ9UBp6ZwHXE9gvc5kp6KlV4p+hzdsjlJfEOqrdwiSGyao6BwACAzCxhiK37dGTM7TKudaA/YL6U33qRr7qKoV1qTMxfBkKADjPklUgHgAVy3poO7Y4UFhnSRXLQVepUT+kk/OHW0EvP4dn88sqJJ1MjNUcihd8C3h++Q/GXcdLfXjoxJSoXSiBHOK0QWRaCB/u1UhRknP7zqYjwn8mO+TZmdZ2R9Ch18vPa1BvCo4F5DI4R8xxqqwL8+o3fxRFfy3Niu66qk34wjWmCgb7uMiyaQw62mphrUzYV6rw1sl8W1UR/dz40FjkzAsFiO0UL1uc49ltkZYhaM9oZ0xQol6nNAj22Ek/A/LZR4h3tDNTBL2yIwLkjN2R0+JclnI97FtoI5oESlwu2RolTM8/xyjsrwfacd1OqnmAWUSwDZJVK79yZIJhcAf04YKCvTvPju5ECjMjb238IjcUYAdOkqVjxoMmYfVsvFsDBq2GGJce7cZOf8FqNZyvLi458gaCOu6rSxDIYISgkcq7PV+Vr7ZBpbEAhxrhARIZSW6kQmPdbPaLFHp0rXX4ppp1ujzuiHik8ofnqzqkiLQIiJA3PqQD8rjgWr1wIsQBdeT7WRSDhNf/AM5HEpUs+9oZF/urSQBC0gAnYn1dia4vRkWTU5Zh5No5EoVv/LFDLO3Ykk2EvnLNG35YxzT+1SnxB8U5SV8N3GKwFj4bXomMc6svNOgTTI08c+3XK1/05srdgKFksrb5YKtp0emOAxDPVwwRjEA3pL490HCW6+WTWhEKmk+jFB7irwtTlzndsDkd1DvvN+MKjg4R7g/ew2rUiSbNhbLbSkLuGmdKxHCAAo8P9knyJnPcuJOuugJtgV+8pzjQ0G2PdIQYCmzIXMh52cvfBocuKIk8M5YNzQrfXgB/Yzl4z4uYy+8+3y7UNS1lglrncgytVET0XhU
 waSZDK9O
 W23mwXyGEMF0w730UZ4eOApuODSxuFjAcro2GLaWyeuCtACsCqcP9gVUvTygiLUTGQ4oaZdpFdNbq7KcuqZnnAm0QhJ57VFWfKdFZ4T4SCJDaftyPu11m3YACow5vDEmEWSdOKbZ+iI+uNWV9S9r3JF68J5jwc380GrILTf/CPG92TBmK+ReD0sQxQNwweNjUmk2OG+bLRKtqyQ/blhgDNWSmTz1v09WaygOkEMQPR9xguM8j5OisclCRQg4RGLQnWRE7RFnDbcVr06JGEW6xL1lZvER7xtMZbHnEuhsTY5FgJg6gkwW4EN0ar0AyXp93dCDNusD6SPbD/bUPViF97XIEnoMuqSp3vxUdV2wxkyP6vEvM42Vt8256/vqyK0tVdYcAPLH1M4v3DU7OjGSKQuykSAdFmNrTFAo1ueaWkhmi0rB7IQrUDaWV8qgF0bcQWTX9OCEbupq11MeLIeLdQ4g+a7qtXrvA9RSc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-12 at 02:38 +1000, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> Hi David,
> 
> On 5/11/26 8:47 PM, David Hildenbrand (Arm) wrote:
> > On 5/11/26 14:19, Zenghui Yu wrote:
> > > On 2026/5/8 19:53, David Hildenbrand (Arm) wrote:
> > > > On 5/6/26 17:42, Zenghui Yu wrote:
> > > > > Hi all,
> > > > >
> > > > > Running mm/ksft_hmm.sh triggers the following splat:
> > > > >
> > > > >  ------------[ cut here ]------------
> > > > >  alloc_tag was not set
> > > > >  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0, CPU#5: hmm-tests/2020
> > > > >  Modules linked in: test_hmm rfkill drm backlight fuse
> > > > >  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
> > > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
> > > > >  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > > > >  pc : ___free_pages+0x2a0/0x2d0
> > > > >  lr : ___free_pages+0x2a0/0x2d0
> > > > >  sp : ffff80008345b530
> > > > >  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
> > > > >  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
> > > > >  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
> > > > >  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
> > > > >  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
> > > > >  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
> > > > >  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
> > > > >  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
> > > > >  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
> > > > >  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
> > > > >  Call trace:
> > > > >   ___free_pages+0x2a0/0x2d0 (P)
> > > > >   __free_pages+0x14/0x20
> > > > >   dmirror_devmem_free+0x13c/0x158 [test_hmm]
> > > > >   free_zone_device_folio+0x144/0x1e4
> > > > >   __folio_put+0x124/0x130
> > > > >   free_folio_and_swap_cache+0xa8/0xcc
> > > > >   __folio_split+0x664/0x7fc
> > > > >   split_folio_to_list+0x50/0x5c
> > > > >   migrate_vma_split_folio+0x13c/0x25c
> > > > >   migrate_vma_collect_pmd+0xed4/0xf68
> > > > >   walk_pgd_range+0x598/0x9a0
> > > > >   __walk_page_range+0x90/0x1a0
> > > > >   walk_page_range_mm_unsafe+0x194/0x20c
> > > > >   walk_page_range+0x20/0x2c
> > > > >   migrate_vma_setup+0x18c/0x224
> > > > >   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
> > > > >   do_swap_page+0x1458/0x185c
> > > > >   __handle_mm_fault+0x85c/0x1ba0
> > > > >   handle_mm_fault+0xb0/0x290
> > > > >   do_page_fault+0x1f8/0x6f8
> > > > >   do_translation_fault+0x60/0x6c
> > > > >   do_mem_abort+0x44/0x94
> > > > >   el0_da+0x30/0xdc
> > > > >   el0t_64_sync_handler+0xd0/0xe4
> > > > >   el0t_64_sync+0x198/0x19c
> > > > >  ---[ end trace 0000000000000000 ]---
> > > > >  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload
> > > > >
> > > > >
> > > > > It was tested on kernel built with arm64's virt.config and
> > > > >
> > > > > +CONFIG_ZONE_DEVICE=y
> > > > > +CONFIG_DEVICE_PRIVATE=y
> > > > > +CONFIG_TEST_HMM=m
> > > > > +CONFIG_MEM_ALLOC_PROFILING=y
> > > > > +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
> > > >
> > > > I assume there is a weird interaction between alloc tags and simulated
> > > > ZONE_DEVICE memory in test_hmm.c
> > >
> > > FYI this can be reproduced by running the migrate_partial_unmap_fault
> > > test case.

Thanks. I have reproduced it now that my fingers are skinnier.

> > > TEST_F(hmm, migrate_partial_unmap_fault)
> > > {
> > > 	buffer->mirror = malloc(TWOMEG);
> > > 	buffer->ptr = map;	// points to a THP
> > >
> > > 	/* Initialize buffer in system memory. */
> > > 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> > > 		ptr[i] = i;
> > >
> > > 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
> > >
> > > 	munmap(buffer->ptr, ONEMEG);
> > >
> > > 	/* Fault pages back to system memory and check them. */
> > > 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> > > 		if (i * sizeof(int) < 0 ||
> > > 		    i * sizeof(int) >= ONEMEG)
> > > 			ASSERT_EQ(ptr[i], i);	// triggers a fault ->
> > >
> > >
> > > dmirror_devmem_fault()
> > > 	migrate_vma_setup()
> > > 		migrate_vma_collect_pmd()
> > > 			// !pte_present(pte) && folio_test_large(folio)
> > > 			migrate_vma_split_folio()
> > > 				split_folio()
> > > 					[...]
> > >
> > > __folio_split() {
> > > 	unmap_folio();
> > >
> > > 	__folio_freeze_and_split_unmapped() {
> > > 		__split_unmapped_folio();
> > >
> > > 		for (...) {
> > > 			zone_device_private_split_cb(.., new_folio);
> > > 			// -> dmirror_devmem_folio_split() which doesn't
> > > 			// set alloc tag for the backing system memory
> > > 			// page being split, i.e., rpage_tail
> > > 		}
> > >
> > > 		zone_device_private_split_cb(.., NULL);
> > > 	}
> > >
> > > 	remap_page();
> > >
> > > 	for (...)
> > > 		free_folio_and_swap_cache(new_folio);
> > > 		// -> dmirror_devmem_free()/__free_page() which warns if
> > > 		// the page being freed doesn't have alloc tag set, in
> > > 		// alloc_tag_sub_check().
> > > }
> > >
> > > The WARN disappears with the following diff. But I'm not sure if I've
> > > missed more important points (which is likely to happen ;-) ).
> > >
> > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > index ed1bdcf1f8ab..eefa2a739917 100644
> > > --- a/lib/alloc_tag.c
> > > +++ b/lib/alloc_tag.c
> > > @@ -191,6 +191,7 @@ void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
> > >  		}
> > >  	}
> > >  }
> > > +EXPORT_SYMBOL(pgalloc_tag_split);
> > >
> > >  void pgalloc_tag_swap(struct folio *new, struct folio *old)
> > >  {
> > > diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> > > index 213504915737..3bec51828916 100644
> > > --- a/lib/test_hmm.c
> > > +++ b/lib/test_hmm.c
> > > @@ -1713,6 +1713,7 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
> > >  	rfolio = page_folio(rpage);
> > >
> > >  	if (tail == NULL) {
> > > +		pgalloc_tag_split(rfolio, folio_order(rfolio), 0);
> > >  		folio_reset_order(rfolio);
> > >  		rfolio->mapping = NULL;
> > >  		folio_set_count(rfolio, 1);
> > 
> > 
> > zone_device_private_split_cb(), that ends up calling ->folio_split().
> > 
> > We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
> > __folio_freeze_and_split_unmapped() before calling
> > zone_device_private_split_cb() when iterating the folios.
> 
> If I read the code correctly, pgalloc_tag_split() in
> __split_unmapped_folio() deals with device private pages' alloc tag. But
> what alloc_tag_sub_check() warns on are real system memory pages (device
> page's backing page), which are allocated by
> dmirror_devmem_alloc_page()/folio_page().
> 
> static void dmirror_devmem_folio_split(struct folio *head, struct folio
> *tail)
> {
> 	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
> 
> Thanks,
> Zenghui
> 
> > The zone_device_private_split_cb(folio, NULL); is then called on the first folio
> > after looping over the other (new) folios.
> >
> > I would assume that __folio_freeze_and_split_unmapped() would already do the
> > right thing?

Well you know what they say about assumptions :) Although in this case
__folio_freeze_and_split_unmapped() isn't called on the backing page anyway
(it's called to split the ZONE_DEVICE page, not the page simulating device
memory). The problem is we're not splitting the tag associated with the backing
page for the simulated memory.

I came up with the below fix last night, but I suspect it will quite reasonably
get NACKED on the basis of the symbol export so was looking at other solutions.

The simulated memory should just be used like a bare physical address range. So
there really is no reason for the backing page simulating device memory to be
allocated as a higher order folio. Using the struct page to store some metadata
for the simulated device is convenient though to avoid creating a test-specific
data structure for this. So I am looking at going back to allocating the
simulated backing memory as always order-0 pages in the test which is what it
was prior to the introduction of large device pages, but that was causing a
crash I'm yet to debug.

 - Alistair

---

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..8828cfcbab43 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -191,6 +191,7 @@ void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
                }
        }
 }
+EXPORT_SYMBOL_GPL(pgalloc_tag_split);
 
 void pgalloc_tag_swap(struct folio *new, struct folio *old)
 {
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..977f080de6f3 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -29,6 +29,7 @@
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <linux/pgalloc_tag.h>
 
 #include "test_hmm_uapi.h"
 
@@ -1713,6 +1714,16 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
        rfolio = page_folio(rpage);
 
        if (tail == NULL) {
+               pgalloc_tag_split(rfolio, folio_order(rfolio), 0);
                folio_reset_order(rfolio);
                rfolio->mapping = NULL;
                folio_set_count(rfolio, 1);

> > Maybe the issue is the hard-coded folio_reset_order() in
> > dmirror_devmem_folio_split(), where we seem to assume that we split to an
> > order-0 folio?


