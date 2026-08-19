Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886D8C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E216B0093; Wed, 19 Aug 2026 10:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE716B0095; Wed, 19 Aug 2026 10:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE096B0098; Wed, 19 Aug 2026 10:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65AB46B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:40:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC277160150
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:40:02 +0000 (UTC)
X-FDA: 85118278644.19.31B3D25
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013044.outbound.protection.outlook.com [40.107.201.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2710A120004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:39:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L9mSPuVF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787150400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z39wAlmLd/xzU7zMq73bsWsSYnzKn+/DMJUKrUR6aGs=;
	b=EfBfS9RIHofP89HwAuUPbV4kFOHwPuu+v5lCa6N03k5SWr/Cp4yZ7ZV5bAumN6CsLG6zeB
	Tr5wMA7uCD/lUMjmSLDLOSAsfohVR3rR2uZYHV2vVBX0rZmEBtKCpxAJRRr5RZI9a1HMhp
	0Ch1EZviupMfHduFhPs3/xZVYS1pTk8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L9mSPuVF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787150400;
	b=TJO61yWdomQTmW0iEv6eUtAn7FqSrZiE8jRKsFHbx6Q41FMTqTOZ+EhUeH8Eo6StmU4TLz
	+misQpkJLlAEnc//ecfaBFhyn74JcAbgeDu+T5wnpUDunht2ZiKTjsa9uKwAGVXLQe/NWL
	yQGJtw6XbMSnIMFo/eOiZlnEshvLDnQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t85AFr+rq2ap0FPLXMKH1ghxC8cVqHAU/JukyMoZH2qwMb+KtWZy+5MkZz0CKO10FDjJvaKnSaUlckJ9+KHUG8AQZLb9iS9NfpPoThcg56UVW+RiILtbKDshCTRhGCDLzKqvnyJxL1XLUt/arzlw9WkhwIMdJXHwQMt1wdWqIeN8JQZb+Wmvi2Y/cFVzI8uHng7oFAQXrn3CcnYCMy7kEwDDIBubju11omc3r8Lv9+bEnN+/dBB/ey7b+TCIQvv3dhSCh4wyMxND3y1MEdXBSvhRW0KiF6+TDY9JHxeRl3Glc4olc5wpQxjE5hmU8TFEd39UCJMt/urXpUDEQr4Tog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z39wAlmLd/xzU7zMq73bsWsSYnzKn+/DMJUKrUR6aGs=;
 b=AI8hD25ADzNpQR7QY5qQm/GZdc8vsUafvKzic2N6llxo1zh/QQ9dRbqcI0QGqjtnEBy5MuSIAKn4RzNPJlkAx8OUZBGLiaZW+IYc9bGw/7iVWiTlHbt8ama3Y79gHgrxWBEIXrfM8Uvg3SAC1qQuET85xv71P6mASLRmtjZWtanpe0MsCWqw9TOBPdp7oVo/p2YBUyJ+Sj6OQxMAcbMxz5dV1ZZHYeSmeZjS7M6yTQ5rnpE/o/+l63fJaGCi4zm7rFNXaTkxGNx4XXx94jrBWt+kyOoYcQz752qSpXL35tg4AG68Y39N+52r1RgfbM8fT0QtTCluDN/ZdlDnH2Bj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z39wAlmLd/xzU7zMq73bsWsSYnzKn+/DMJUKrUR6aGs=;
 b=L9mSPuVFMID8D/QeMVdbxhe2IIB3R4+ZeJ0qUOA/bwIgMu1MKXMstkCIbDLy5KXaJV0RHc/NMsXe5xZZxBPqY2I1tJOb/VFJ7gEdz8vdOBOnnqi8+wmPWsc/43HwfrCocAjbrTX/Hy7z0pjfSDcCVqkpbXsS4qrC2I514iD566OoihQzUFgbSuHXZjQSWiuENliVT1DNFWepb2dVPGrejMB6xGjrCuJVVK35NA5zwHy2icJHZE7p4gVQfzYNhlDJYMTRKiuGcZoQTGaFmkX59UXymtpIjplN8/rDVP0Stl6kO1XxVJ/Oe+C+D7iJGwF8w7zwm9l9YbDQ0HwP3HI3mw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4482.namprd12.prod.outlook.com (2603:10b6:5:2a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 14:39:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 14:39:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 19 Aug 2026 10:39:52 -0400
Message-Id: <DKSZXW5DACTG.31Q9ELZHJQDJ9@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
 <wangkefeng.wang@huawei.com>
To: "Qi Xi" <xiqi2@huawei.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/page_isolation: fix UBSAN shift-out-of-bounds
 warning
X-Mailer: aerc 0.21.0
References: <20260818112855.3831692-1-xiqi2@huawei.com>
 <DKSB5XV53PQN.2G3U9Z7HJFLNO@nvidia.com>
 <ad225cf4-143e-4c6d-9fe9-8c6fe8c621a1@huawei.com>
In-Reply-To: <ad225cf4-143e-4c6d-9fe9-8c6fe8c621a1@huawei.com>
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4482:EE_
X-MS-Office365-Filtering-Correlation-Id: 44311ab9-b8b0-4e67-ec61-08defdffbb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|18002099003|22082099003|56012099006|6133799003|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	9oH9q6Zan3Abh/IFjqnzq3V3m3ZlD/wboAuqRcVBxsDVDWnkdnZUyxXyAUuBYFkauesTvbeMfptQnCNKSqRBvlTk2CtTm3yq+xjQ8uWMnnkh0O3DUt9psrw6bakLzCa1SevOmCWAcdsSPRkuVmJx+sehOoQYAuBAGAGHU7GUPZ+xstWaB//f4g1HkklptbxtJ8vok0WbCnG19XFK8dCm1ibd1qRDhDwrq2I8HkdQhiHpjamgQKZpYQyrmx7hF5+z3am9Mq01wTfEax6UuaHczoAaRkmiBzwMbErS005XzQbLwZ+fm+CFVMKKLDA4RGQI6r/jeEqy2toeMokHsbrqsg4/kXeumOElg1aK5tdtIMLVteqQjc3raYyxSTrVo5SGy5XFUQi/zjtVNPvXvLUUvgZBAkVRoSZUst+Z+kStV5ONAj44yKwtoX+BXpOrARH1ujqG+7nZBdUhgKYSV7CU6IDoc0ujSt4OOpbFSyk5s6eOBY1Oqu7A2TiHQsyk62UMxZ5C8u8SYp8DZDxEIIFsE9WmFKOYtLiO2V81QmqhzqGy7CoZxaWXnaBNEdSXeRKwPUZzoCsu4ejCtqyw3WERvKiFbV8hM7cJOSKE5p+QMAWypir/Oyh5xmvgg1VezCZaA8hsycz7yHFk4UBeg0qFEbqGChr/qWfZYUqFLspZnVg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(6133799003)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGtiK1dhVWNyaFNTRXlDdFJZeFFMN054UkJ0K1ZaWFYrVlZLdGJYQ2xMRnVm?=
 =?utf-8?B?TDFWVWF5OWJsSzlVNnRjYytseGZjbU9sTUhURHZ0anM2Tk9uRVU4NElmQ3FG?=
 =?utf-8?B?cHJpN0lGYW84REs5LzVveDVkcVIvN2FDS2x5aitGd1lzWjVCeXBFV3RmQTFF?=
 =?utf-8?B?VGllcGhYSHFPOE9rdk9SckdJUmoyYlg0b1pFM1poblVNRUxwMWRQRHpKRHhC?=
 =?utf-8?B?b0RQeThTdEd4MTFBSHZaRGNoNDdqNWpNTlRHL2lWNG1hMWZRRkJlUGpDUGNy?=
 =?utf-8?B?VkNZZnBCVXhCMTVCVWhhaUxtb2xWVVNSU1RUY2MrSGFVcVo3Q3RtT2t2TU9R?=
 =?utf-8?B?ckZtSUFMRzVqd1FFM0FUbndSZUNVYWZleERrOEZBbkJiK0ZxS3NZbVVRRFg3?=
 =?utf-8?B?Y2JrTlJnVHZlWmY0S0dTZEt1Uml0VG84WFNaaXZIUHBNY00wV2lQQVVhN2Vi?=
 =?utf-8?B?K2JSblRWMHJiUVVRd0FHRVpaSVF1RVo2VGNIeVB2b2dTeEsrTGRmc2d0WGk5?=
 =?utf-8?B?U0doTlg2S1VTVld3eUJMMnZ2bEdodFZwTHJjQmVNcGdPMExpMUxhcFVuYldw?=
 =?utf-8?B?MVVLYmszV3pwZG5HRW4xbFJJZWdsTHJIbkI0LzBYY3BNMVNPVEpmWVNxM1A5?=
 =?utf-8?B?S3ppU1h1M24vOVBreldjNnJJSzFLMVN2bjd4M0FVMnJCcFg1bWVZRjdpMHJy?=
 =?utf-8?B?R01NVnBJR3BoWm5jNExqNUFRcDhJbnRMTTFwS1hwbytyRVB4bTVHSWJjNHZC?=
 =?utf-8?B?ejZsLzF6U1JGMVpLV1ZCTERnN2xXbkdyNXBTRzJBTjBiWWFDbGtQTHcraTR5?=
 =?utf-8?B?VEpmZEVONW9HejYvYklkbU9RNE1XYWhucVZQM3gvSll4Ukh0ekVCUjV0bVpq?=
 =?utf-8?B?M2cyOGZOQnptTGhCRXVVZXl4ZVJKaGF3b0pDZDBEL2lCYXE4bDkyUmYzb2Jr?=
 =?utf-8?B?UVZlT3VRMXBqQ2NtM3lGTk11MFlZQlp1VHJlZkdWVk5PT3plWnJrWGNKcGJW?=
 =?utf-8?B?OU9Id0dpWTk0aEFjWTNkSFc1dzBVRzEwTkE3eWJ1bmhZd3JaR2pkaTl5bW5r?=
 =?utf-8?B?VEpLK1BMSmtrS01MNEVyZ0ZiZE5mZVhtSCtnTXZGd1NwMmZtaUczQk9ObmVu?=
 =?utf-8?B?VmdJLzhmY2w4OXNYcitvWmpyRzZHclo5WmpTa08yMnB6eExRUjNFdlR4RWR1?=
 =?utf-8?B?aFFOREhQT3NsTVpxaDR0U0pYQWhNa2gvVERtenJ0bk5zVVRNZnBJVHczZ2RP?=
 =?utf-8?B?MitTcW91bEphLzhMeXJhVjRPdllMQkE2NDNFaUkvTTZTbDN3RWFmQnBjMmFh?=
 =?utf-8?B?Uno3RDdzNlNlWHZFejRnNFJJLzY1MERGNExWYXZnZEdvY2xaUXpqRkFlQU56?=
 =?utf-8?B?N2RYYzJOaW5sdFNtSmkxYkMza3VWRmdESGpCZ1VMQ29VcEhMZjVIL3pqenl0?=
 =?utf-8?B?MlQ2ejJDUHBtd25sQmtkOElCWS9ZWmdKdEFJaThLMGFwak5HSHJVNHgzMWJ3?=
 =?utf-8?B?ZXJCc01zK3BrODdwaXVHR0dCejNZRjhzVWdTYmZUcGtKWGduY2V6S1J5ZkVF?=
 =?utf-8?B?VHJ2U3pBM0s1Q3lMb0szbGNlNVVheUMwcC9WSFVyd2o3dmtsZit3V3M4TFN1?=
 =?utf-8?B?Z2J0eHNlYk53Y0ZsbUtmSGJVdU5jNGU4Y25iV29hYjVPNzlPa0lzYlF4M2Zs?=
 =?utf-8?B?MVl1bno0cHZDZ3hQQ25pakR0Vk15ZzNwdXNPQWk0YWQ0NHI3T3BaY2VZUWlQ?=
 =?utf-8?B?ZTNzTWRxVk5MajRoS3FTbFVZaFBobW5ZNmZRNlJyWWdPMmUrNGtpaXNmTWpp?=
 =?utf-8?B?azIzM2Q2K0xCWXNwcTBoa09uZ2k4WFYvbXNld0hDNXYzNnpIS21CTk1QWEpQ?=
 =?utf-8?B?bUpRQmV6VWtZZ1NwZDN3YkxVbWZJaWZmUHRBTWRRSm8ycElVYjlqaDAyV0RX?=
 =?utf-8?B?OVdyNWFXUmFkOVpEajFQeE85QzA5NE1tbzl6SEFqMGFPRFdybWNOb29tekh3?=
 =?utf-8?B?M3U3TS9WTXkwZG1kQnBjQ0VJZ0J3SW1mVjNOMEt1NUErM3psRlVPeSs3a3kz?=
 =?utf-8?B?Q1VqNVFYc1ZpeVpWdmJ6WWxKV1pIU0ZrcHdjSkZVdmd3b3RPejZxZml1QlA4?=
 =?utf-8?B?NUxibkk1OUVCRVZ3dFk0b1VsaFpNY2NoSWN5SEQwUFhmbnQ1ZEYrbTVwUlFZ?=
 =?utf-8?B?MGZRam4wenJtS04xcjRvOWhGVENEUGVhZWtmdyt6Y01nSVRlMS9VeWlWTHRn?=
 =?utf-8?B?Wnd3QVNRQ1lITzlSL2xGelQyc3hjY3FVY3dCM0JTTlQ3cTBLT2F1QTJtVGZu?=
 =?utf-8?Q?7fB7FpEnjzEkTbXU8n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44311ab9-b8b0-4e67-ec61-08defdffbb3c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 14:39:53.5290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HMIELkFEq8E1NGQWDOQumDru6j98PgjGMO4AQo7QlXMdSOpgQ+MFgDHGX81CGGle
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4482
X-Stat-Signature: 4w13phxmwksy93e54dtjzyams535ijs1
X-Rspamd-Queue-Id: 2710A120004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787150399-122577
X-HE-Meta: U2FsdGVkX19BSPTwOQSsclpZSeSmxD4SFDgR1jjuLaPp9Uj6n0bX3/lH01PmxVZ6bHvclMmtBauaotQfnd5iWW8uf0vjg+ORDy3rNLzS5mxMdDWc56FdaMs5Adgbl4YjwgRGXNLUQF/0pLkotMiyK49rctMvDdZL1q1MKKPXD/PMIP9Mh2TWMwTFItAl3cDLomb4uLBg4euS6B7SfA1RSML1OpvI9/pApOuHWyifcpN7d5EEqFGqC3XCZkIU0F86s2m+j1VjmMtTNGiKc9nV8AYI7m3KzKxpzGaNWdulhMVukqbUMrPj/Tq9jAlt0rxPh8VzAf9dyHREswKkYVESsDNPAiQaaFvE1rsy689vfCJxXTYDUakrVAykxU/BTB8flaaoy7ptbD35WxeIHu5XBbWDNjVgyIrBMSRXXOY8y+ZAc6++V9qZ4rhrg+KqLe4TdsVMHrFjeTcO2g45wmc8atEgtCPm3syG04QzRiEu8Z0mx4LGSPMh6hQdpDtR6JAN8R+daaw4ZMIMuzw6e/67LKQbkrmanFFSjcRqIirKd821kdUWwAhjoz+1bZt5Pbo+dHW18ejuLpVdGKNtKbJgWYjgpEPcArpyaaYvNZ+DMvpJv0rOcIEoKVYzIxeKfQlNGux05dgx5MWKqTWP/zkOUxmEX1UK92DIGzTf7If7M+t73qkKWuEctKPrOsk8T3eHNsJKA1g6VPbJN2eeuJU6qyEl9/QNluYTlcWP/jXA79fgD8A0M3bpVDarckatQY7I2phlWzNU6ltYXQqEduS/iaSho1V+T0/T008WZev6M6+jmJUo/1q+Dd5HJ04vQqY2oSPW9HAKU8qG3RUG6AZJAxxazslqSwwzijeC97ntjZiHeioVC+Ud0xUVHvCXA06JAP7LLKzneUbYANd4NCcsGvVMO6BaBNf0Kq3RAuyAY48bYWLPNnu6lD7EhxaYz/YMKR+zuIomSXv3tdUEpuR
 3wtMsGZn
 1/ZI56Dr2HP0sXC8vkcJuV6nBWgPYRBSMRwRqP+eWce1OOCCQbVv9RJQGedGx2kSIl+BWt84arpL8x4zB9t2b5AUXVYa2P/T8ZCOSev5+5broh23+aanj1iaj/qmb5uskbZu0+oVzksYyiwQK+dtY6nicOsTZLKoCV8gM6lRdWStKUKcryjPRuwG4wwCGDoalFf6WHEL5/P01yIvGS5HXhHu1asUIvlaieZX4qD2afYCnM2WdU+exB1YN8i5qoBHzrqEkWStmd4NL8yFvkHkwFTUxAJlZHJy4cX5RmdQr6gx/nREbink3Cojiy8QOKnMFcpZBeJC1a44JNJrTFpi75EGfEzmRYIwvA5r6BFzxjp+5Yx05I11r4bKZnc7EklSEEqTT+xtz0sJIf1RG27LNUAaw05y9GyCwvkPT9pWmozk8rfi6Wbg+U2LNi7IJNR0BNSMe19dc2+/W7IZTMgSBoOI1mYG1xSUf7ZLJmCL0ABzWRHCuZ42ysCPKbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 19, 2026 at 3:55 AM EDT, Qi Xi wrote:
>
> On 19/08/2026 03:14, Zi Yan wrote:
>> On Tue Aug 18, 2026 at 7:28 AM EDT, Qi Xi wrote:
>>> A contig-range allocation racing with buddy allocation on the adjacent
>>> pageblock can trigger:
>>>
>>>   UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
>>>   shift exponent -749042176 is negative
>>>   Call trace:
>>>    isolate_single_pageblock
>>>    start_isolate_page_range
>>>    alloc_contig_frozen_range_noprof
>>>    alloc_contig_range_noprof
>>>
>>> isolate_single_pageblock() first calls set_migratetype_isolate() with
>>> zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves an=
y
>>> free page straddling the boundary out of the way.  Once the lock is
>>> dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
>>> boundary_pfn) locklessly, only to skip the free pages already handled
>>> above and to detect in-use pages straddling the boundary.  Since this
>>> scan only reads page state to decide how far to skip and returns -EBUSY
>>> on a straddling in-use page, it does not take the lock.
>>>
>>> The window also covers the adjacent pageblock, whose free pages stay on
>>> the normal movable/CMA freelist and can be allocated concurrently.  So
>>> after the scan observes PageBuddy(page), another CPU can allocate the
>>> page, leaving a stale value in page->private that makes "1 << order" sh=
ift
>>> out of range.
>>>
>>> Use buddy_order_unsafe() to read the order exactly once (READ_ONCE), an=
d
>>> guard the shift with an order <=3D MAX_PAGE_ORDER check so it is never
>>> performed with a bogus value.
>>>
>>> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock gra=
nularity")
>>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
>>> ---
>>>   mm/page_isolation.c | 13 ++++++++-----
>>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>> The fix makes sense to me.
>> Please Cc stable for this. Thanks.
>>
>> Sashiko has two more concerns:
>>
>> 1. order can still be bogus even if it is within MAX_PAGE_ORDER.
>>      a. it can trigger VM_WARN_ON_ONCE();
>>      b. it can skip arbitrary pages and miss an in-use compound page.
>>
>> For 1a, we can remove VM_WARN_ON_ONCE() and just fail
>> isolate_single_pageblock() if PageBuddy crosses the boundary, since
>> pageblock_isolate_and_move_free_pages() handles it.
>>
>> For 1b, after we makes the change in 1a, PageBuddy skip cannot land us
>> beyond the boundary, so the concern is gone.
>>
>>
>> 2. In PageCompound() branch, a bogus nr_pages can also cause the
>> shift-out-of-bounds.
>>
>> It will need a different fix.
>>
>>
>> Hi Qi,
>>
>> Do you mind fixing 1a along with this patch?
>>
>> For this patch alone,
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Thanks for the review and suggestions.=C2=A0 I'll address them in a
> follow-up: fold concern 1a into a v2, and send a separate patch
> for concern 2.=C2=A0 Both will carry Cc: stable.

Thanks.

For concern 2, I used Claude to do some investigation and come up with
the code below, feel free to use it as a reference.


if (PageCompound(page)) {
	struct page *head =3D compound_head(page);
	unsigned long head_pfn =3D page_to_pfn(head);
	unsigned int order =3D compound_order(head);
	unsigned long nr_pages;

	/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
	if (order > MAX_FOLIO_ORDER)
		goto failed;

	nr_pages =3D 1UL << order;

	/*
	 * compound_head() is also racy, so the derived head_pfn needs
	 * additional checks to make sure it is valid. Otherwise, just
     * fail the check. pfn comes from __first_valid_page() as a
     * legitmate PFN, so use it to check head_pfn.
	 */
	if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
	    pfn - head_pfn >=3D nr_pages)
		goto failed;

	if (head_pfn + nr_pages <=3D boundary_pfn || PageHuge(head)) {
		pfn =3D head_pfn + nr_pages;
		continue;
	}

	/*
	 * These pages are movable too, but they're
	 * not expected to exceed pageblock_order.
	 *
	 * Let us know when they do, so we can add
	 * proper free and split handling for them.
	 */
	VM_WARN_ON_ONCE_PAGE(PageLRU(page), page);
	VM_WARN_ON_ONCE_PAGE(page_has_movable_ops(page), page);

	goto failed;
}



--=20
Best Regards,
Yan, Zi


