Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BD0FDEE46
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 19:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5F36B0088; Thu, 23 Apr 2026 15:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65E96B008A; Thu, 23 Apr 2026 15:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55636B008C; Thu, 23 Apr 2026 15:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1D216B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:32:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5726C8B41C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:32:40 +0000 (UTC)
X-FDA: 84690817680.13.E5654D3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010047.outbound.protection.outlook.com [52.101.85.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 72145100002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:32:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Zop6Mngl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776972757; a=rsa-sha256;
	cv=pass;
	b=gtr++ZTcsL5XFInSc4UnfJuFagAFxd5hBc1seAym1Bvt19KrMAZZiWzLZ+a6B7Oreu5HOx
	NGDtxvW1pP6ZlHv7VPXvVqsx4qJ8Dnn/6HlqOGJBKk9uidc/q2K719hhPVhrsJd29kR40C
	cg1WFyXJlpgnV7vEz0TQ+jJcxBb+Vj0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Zop6Mngl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776972757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHOqHBlD9vBnEzLwMzIA9CTuO024D1xoVLeEMO9breE=;
	b=8Hbu5L8tGZLqLhqJWcSR9bhoySvRQbFKqg93BtqeGt4ZsEK4xI/YWq/bogGdRQAImx0Yrv
	ZCmrxazQ61Yp9JBVQ6nf/9txN5XT8OoDptBkYFQh2mnWrepEgVnntyuIj9oeJL3NrZ7Rn/
	CbhIMGNfVCf1Qqxmml5EVvkBnM7sx18=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nftWFB+Fu3Cck+9DfQCOIVZ84aI93g83vrw5vccgF8Skga4hWVqNdBN08uZBysn0PVJx9wwzc5PNi4V0w0TE3deX2koHVeWEIl3ku6Grcxbf/LmT0yZZxey4sJiLKydykIuSm4Zt3CwQ9YCASoV1SiZKDOzxoaJjIaWDb8K9Rv9OQu/hmaKwCV1iGeucsVjR9vhVW48bxP6cFH2mm49sjD3pOyPANBoBotwkITKS/f7q4yhh4Faf3fY3NsrtYrehg8PYfVoDeKGJ7jSbUaZvR23d93R/1nSRXQKuxJwfJdqcoikqDeWUjPyy5DuzOnpYYyXW8YLwANeTJZt5b+k2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHOqHBlD9vBnEzLwMzIA9CTuO024D1xoVLeEMO9breE=;
 b=f67dTdD0MLH28mnXvs21mbQz3VzN+wdDb3EF6zaaUeHWNK5Of1td4Pweov2SXZCzL1pZKbaM7/YxlB+Q1ocI5r2BGQF8RshNi9e7AGJvZgwtVF/8LkVTkzEBRRpQwv4tEdQ5HZJ/3Pxmd44dXNj+Y+w3eM5IasXAA9c/JnSoSVchJ0r3jgtqz0LTVOrvS3UKlGDagwy7rCgwxxe7VgyU8h9Sc48xusk6/tb5yUC7hOAQYuDlUaspXoMyVdT0K9ZtksAriaz4g+Tp7hdK2v15/7HmjUtj/Z/WIYMY+LL7B9SxPwuJqzjpXHCOtDMZUevuqCeX1dlYyDn03xHhC9cOsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHOqHBlD9vBnEzLwMzIA9CTuO024D1xoVLeEMO9breE=;
 b=Zop6Mngl8h2CfxyokWUD0M8lppuEYHoRj0g1yZ8MtVpuL8cd50LWX0uLQAZvl3c2u/4aQ3UK1hBdLEwc/0qemkBYQjD5rBZh0m0ddDV7PHWlAoRIhhJExhy5bBRSY3XOB7q+ktmAv2yLYBK0RcSDwU2WuhG38L7V/m8P69IdwYBx8bKltzrJVQDq8LGmtnhiCb2iOAfIb8/aj0uv4NQjUkXoLPM1ASVCN2LkO4cJXsuQfWXN72tDnQoAAKO3+zCCgoVmlEMVIpDbjZKkGhxzxasC1JQpgtDXKve0LFvyRN52/fScUdvsYtBNIeh97RGiz8Pe6a+BT6ESz3+ZEyuOVQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.20; Thu, 23 Apr 2026 19:32:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 19:32:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Cc: david@kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baolin.wang@linux.alibaba.com,
 gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, artem.kuzin@huawei.com
Subject: Re: [PATCH v2 1/2] mm: drop page refcount zero state semantics
Date: Thu, 23 Apr 2026 15:32:23 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <53FA8505-E7C0-404B-B7F5-3EBE89B64E0C@nvidia.com>
In-Reply-To: <9fd8ebbc0f4f45be611bae0d03dd25dd994233c0.1776350895.git.gorbunov.ivan@h-partners.com>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9fd8ebbc0f4f45be611bae0d03dd25dd994233c0.1776350895.git.gorbunov.ivan@h-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0781.namprd03.prod.outlook.com
 (2603:10b6:408:13f::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 0943c882-7d55-4323-44ec-08dea16f0e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FlTWEHc/wqam5tyTDjkuk7+NhkiHclnRO5dSIIciD9wq8n9MVA7w64xELkMB8/q4HXk5zDu6nXz1jP6A/SCNzOiV7PzYGDY7kcxY/PFfU23TGAXm2O49OeIjqDvjdYxa4PBXy3zW9qTCbwWrFQm/U9Jkk2nXGIBPSA65jhpHuatKC7EL9wLTjSxO37QjN0f4wKvnjPZnNN3d8FXCKCQihtwpwvZnKFubNaRti0BwolXVXzAWFmzdBPA6VgTiCIZnRo+pRficpN24VnXwgFr8XY/6m0UakN9S0oXhFckMSqMBa2B25r6zLHFaMYhPxI1bblELCPV7+p1K8zMgAIOA4owwMTnby5XPvDfw+8ImbsigH9tNX32JiERN9xX1A7VE9OARFh0rSkPcVpmqT6SMGyW8WQbFc8EMMKUv8M0ym8YJPfbpLYhDKYjW8G29+gM3WMuZzMpcsEdjhf3aHTMrgJDgHy6cRrxup8IVu+aa+r5EEDoD5lW57cc33NdArKP+mvKA2LGBJzRF2dS0ZAtBrIXmc1aZCkkIOFB0QOqkByWmTSWbV46/1yMFuxhOgnhceq2LhHIkMGXZ6/HGjPWCqdi3S+ewKx5sviXIAM9JSEjta3LzewqCsWgPfkKHWP7btkirPuwZRqOjUpzyg/FTwvEdSKvvgP8gKESRyL608OuqmiaUXSmGMkGTKBCY8PbNXzjmIgbach3EH8lcwyc8T36O0/FwbXMB/J+jNLrDukI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek9KcEFnSmVtbFpUVzhLTnFoT0FYRTlzNXMzNlR1UHdVcGFIZktRc2NJVlRq?=
 =?utf-8?B?OHE5UFVleU1TVTdwZ2gya0FiTUxzT2M4TldMWDBvemk5MnN5Q1lHbzZXR0VS?=
 =?utf-8?B?czFTWVVNYVJaR1BzZERpWWRPS0ZFM3k1dnhlNDJsYXJkZmd4WUx5aWhqeW8v?=
 =?utf-8?B?RWl3MzAzSXV1VmtjeFNQQ3MwUHpJU0VRYTM2akMyNXFJb0FvOUZRZit3MUhK?=
 =?utf-8?B?QXhTdWdRNnpCbGxVTVFOd3JudEZVVnlZci91UlJoUzFEaUxrZ3p6UWpTWDdW?=
 =?utf-8?B?L2JSMzhvdENIcjNjNTdCY0hjN1NSR1VYOHplS1JrNG5YdDhzcEpZU1JaeWtQ?=
 =?utf-8?B?b2dtM0FQdkdILzBMYnpPWTI1cFFQNlU3aFJXaHJDUjcyQlNCemNvaXlXaEEv?=
 =?utf-8?B?cVU2WlB6ZVFpZXBHdldLd1dtc2swU1VseWJJRTJoWElORVlEVFpESW92QzJm?=
 =?utf-8?B?MFpvV3BwZ0tkRmhIVUFBS040VE5EbnlZNVk2T1lKTG40VExWeDNIM0lBQVdB?=
 =?utf-8?B?YkRzMWxUS0RqZzdGWXdlcUJDUzRjL2FTd0g2SlBNWW5KYkFRWTYvZ1B1ZEZC?=
 =?utf-8?B?aEMxSVdPR2pVbEJGbWdnVXhwcWZmWDJNK1VoMGNrdFBJL1pGMGxQbmJPOGV0?=
 =?utf-8?B?eFJjcU9za1N2K2s5UzRkUDhPTnFNeks4aC8zR0Vtekc1MW54S3lDR254Y0tw?=
 =?utf-8?B?UWYyMlVMR0REMXJGWlNpdWtXZTIxUzNsdWtzRTFqaFJQY1Z3dmYvSVJha3Y1?=
 =?utf-8?B?T0lqeVBteW5GTWMzM1VPMk50V1VCdzVIT2ZIS0xHYUN5cXlWU01Xald2V1Zw?=
 =?utf-8?B?Z0h0dkUrTGRaMXpFWldRbUtkZzJnanU2WDVURTVRd28zeDRjQ29hQTk4K0Uy?=
 =?utf-8?B?VHBlZ0UxVVV0SVNnSTNXZlE1QlUxSDkrTjZjNlJrN0p5ODhWUUZlMWNTSWZv?=
 =?utf-8?B?Mk9Pb0t0WndnY0NtbVVGTVV3YXN6OEJrY3RlaVYvaVhaNGIzaFZsVStpR2NY?=
 =?utf-8?B?cnJwN0tPUFpZY3V6ejhmTkljUElQcFNxUjQ1SVBCOGIwbWZicWRVa0FPNHds?=
 =?utf-8?B?S2t0WVRkK0Vqb01pZkF1SXZZdG8xS3QrMDFsRjROd3pHM1hEc2xJUy9KZUp5?=
 =?utf-8?B?MEVqNVZpZWt2R0wxRlUrTEh3UWsxTWdKbEQxTzlkMmovdEJ3UDRPTTZWcVlp?=
 =?utf-8?B?VSthWWZYblN2V1VORjVJNGVYOG1LWXMwZDNwenB2QU9XWE8vd0d6TDZBOXUw?=
 =?utf-8?B?K1VkKzZmSW5IaVdUdEZxN2QrTXpZQXo1d2piamZ2ZlY1UzlIaFppYmZQemRo?=
 =?utf-8?B?NThuK1ppanVHcDIwUnlXVFh4L0phWHdTOFZ2TmVneVBPbkZwaGVkSjU2WWxR?=
 =?utf-8?B?RVpEZTljVzN2OXRxZEhIN2d3MTZyK3IwU2U2eUU3RWlPc2ZTcm11OWZ6Rkdt?=
 =?utf-8?B?Qk9qMU1ENDRic3R1eDBVeEVxZWxpdWl2YjlYYk1WNDFrS2dBL05iSi9PYTZi?=
 =?utf-8?B?V0ljN0Rza0h6Q055N3hXSUF5eWEyNmlsWjZ3TXJpNVVzNUR0NUdjclE5Q0xm?=
 =?utf-8?B?M1ZqZE5FRmpreDQvSTJPM0I2N0FtQlplYlZGY0Znc3lBUzNST2ZmZWhFMFFt?=
 =?utf-8?B?d21zdENMYnIyMVM4YVN4S2xaVGlGUXFiOEJNbW5MYVZ2MEFKUE5LYS9LZ0FX?=
 =?utf-8?B?VWllVDZ0UzBXU09qeUw1c0pGSjZDbFlVTUV6LzhnRExkY01zaXRrUzM4c09t?=
 =?utf-8?B?ay9PSjhEOFB5dnI4U1k2UXliMXFSQ1BMdFlySnZUdTVQb3hVWmNVYm42aFE2?=
 =?utf-8?B?QWFEVkNJa2VhenFHbGYxSkRFaXRTMTdpdmZMdmVDLzFuZlNVNlhhUXc4VmtC?=
 =?utf-8?B?UWpSS1hoZXI0MFZWOG1zNUpLUjNCK1h4YnBsUUV4cHRoRVpHUmRBQ0lVNTNn?=
 =?utf-8?B?aGNST2huZ0NvdTVZOTJqdWVrZGNQUDM3ZVd5K2F6TllGYlB2di9ET2l1ZlZp?=
 =?utf-8?B?eHVnQmQ1MUczaEQ2U2lVVWFRc0hYWnoxcEMxK3ZqcmpWcXB5alR5R283b3ZO?=
 =?utf-8?B?SzZGNmZUVjBxbGNzRHRKcHNUYjJmVlVjK1ozOWsxUExRTWdySTVvcEZ4TEJE?=
 =?utf-8?B?b3VqWGtWQUx1Kyt2K0NEbEcvaklpMDdhSjVDRmJ5dzJNSnBjNUxiU05ENmRv?=
 =?utf-8?B?UU5rdmJ5VlhZcTFwNHkyR3FoTytFVXcreW1lcnRIUjVmTlB1elVWUGsvdFBF?=
 =?utf-8?B?ZWJQTzRTNFJTWmNkV3BKMTEyK3dKU1VsemY2YmtrQ1hMK3hvUTJEZDI3UW1t?=
 =?utf-8?Q?Cf7oSb66trYg17JswC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0943c882-7d55-4323-44ec-08dea16f0e65
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 19:32:28.9867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/obaxAnM9yMGFyAIIoafsFC+DUjM80KnesCYeZEUwR/WW0/S0nnzCw+89T+7Asb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849
X-Rspamd-Queue-Id: 72145100002
X-Rspamd-Server: rspam12
X-Stat-Signature: dzq53r8brmrrs5bmsbu5nctpb7icxqi7
X-Rspam-User: 
X-HE-Tag: 1776972757-155835
X-HE-Meta: U2FsdGVkX1+O1zI1liRLQQlSST2+wH2+dCdRyk7uR6dRy+vB5bYxHNQTSksnYfA+VRr3IBTTBSMm3UWFyNt2Df5ePKA7gAoh/toybgmWgClUl1tcT7wBzxx7ox7bQORISYqyWZ3l6E9nL3yrQfWFglfYwA3FvXGEGbC5XyK87g/Uc6aksOUbCkXkq8ByAHaBn2WKL4IDSM/GBFnXMDQ2D4k4Xh/46dLNoz5YjLI5Qt9qVehj+KCL0jQp4h5YlQJCOPh6iCLyyjbRwrCLiRy026sBzHuCecigiz6tknIy6R0MvI5VLpg/pihdMxJF50aOAOgANHLFH351U2PgVGqckseVtxs/phL/+/vwfP5bqHnlQlvMCnOr6/1PUvN++m5Ihf+SG6YlRqr4PZwIur11AVdvOaBmMSyA0Z89rnyylc/xAEViFzXbtgPMpGeoIH9kbkxtcnii9Bl/kt7ls5yrdyp4K66LNtR24nystF+pMTXNNcPhNSGOrLExGNCxuUqIjNw6n38xlr1ku9c8ZVR/nqFpxMS8GbcN8NXwmDm8Df3MerqtMxAmBSA/oiK5l/MZUVC5RurcBJf7dzSTIycwXzjl4+UJo82S9L4vyYFO+wocb3loxs8wTLPE613eRB+emkQ9j+qaGXPotdvdGFhqgqkanTK2FgZpmwvPnSSbuT73AuVTYeIaVg/TZHgadLBNVW6QCdMas6Ix6e5/X9m/pSnGw3sJqgVLOLIEfp5wDq8BTFU9ZTI88NSqs5wEd4JrHMNoIfOJF84IhDme9FujD3y4f/gx97OpB0QSAiCHhs2yaI+BnKGI/REu9h+m6A7SQgzGE3/oNvSvHRYWBYnkh4YB/U+LDRHRTAxYSpn8q48FnzgN6rs5Kx1ZwYN380du85g8efRAId2NfE6rs20YZzdDQR50VUHWN3vd8cA6qeDcMdOBfJbtPxy5a1giz4Hxkry2GnO9rP+95V90B7z
 4GH/QgxV
 t8kp5KPEZxXF6Y+XYq1IWBKWCO+LrY/oxv2I4hhcHTj+UgC6WZg3degVL1HJ96WAWnlV5P2NuCpsJSe/svNC1zb2y5LzMMv5Bru16R0qTwBmcbhqXHw+J864/d+b9t5+uB4KjFrX1uGe0IU8IyCoKQmCxGtk8e2QquRTzxg3KNyNZFvBX7HFIT7/sorluIoTR5twQg6M+VIgmCpZxBx+9jpy3S0g1sKDdtNlOB/hLtDYUJDD6e7fnj9bLAl7dAEkf0nHI3vMNvtQFTMFcDGZwxSsV2MxbTp0JvVjeaUeP466HJVk0tf96d33e7UqX+D9YXvYWg8nl1kLgh8AqIfVLrbU4J/wBRv0y58mdAr/HZ1SQjz+GtFbIkduJRm/k7ORqtdvFYmtsJdn13Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Apr 2026, at 4:01, Gorbunov Ivan wrote:

> Right now 'zero' state could be interpreted in 2 ways
> 1) Unfrozen page which right now has no explicit owner
> 2) Frozen page
>
> This states can be 'logically' distinguished by operations such as
> page_ref_add, page_ref_inc, etc. In the first we would want the counter t=
o
> increase.
>
> For example one can write
>
> page =3D alloc_frozen_page(...);
> page_ref_inc(page, 1);
>
> But in the second state increasing a counter of a frozen page, shouldn't =
be valid at all.
>
> Another reason for change is our other patch (mm: implement page refcount=
 locking via dedicated bit)
> in which frozen pages do not have 0 value in refcount when frozen.
>
> This patch proposes 2 changes
> 1) Deprecate invariant that the value stored in reference count of frozen=
 page is 0
> (Getter functions folio_ref_count/page_ref_count must still return 0 for =
frozen pages)
> 2) Allow modification operations like page_ref_add to be used only with
>    pages with owners

Should we also ban calling set_page_count() except init_page_count() and
set_page_count_as_frozen()? So that no one can manipulate page refcount
randomly. The same applies to folio_set_count().

All set_page_count(..., 0) are converted to set_page_count_as_frozen().
All set_page_count(..., 1) are converted to init_page_count().

We might need an init_folio_count() for folio_set_count(..., 1) users
and folio_set_count() has no other use.

I see set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1); from
mm/page_frag_cache.c and it could be converted to page_ref_unfreeze(),
since above it there is free_frozen_page(), which makes me think the
page is frozen.

>
> We've looked at places where pages are allocated, and they are
> always initialized via functions like set_page_count(page, 1). However, f=
or
> clarity, we've added a debug BUG_ON inside modification functions to ensu=
re
> that they are called only on pages with owners. In future those
> checks can be improved by replacing operations with their results
> returning analogs, if needed.
>
> Co-developed-by: Gladyshev Ilya <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> ---
>  drivers/pci/p2pdma.c               |  2 +-
>  include/linux/page_ref.h           | 17 +++++++++++++++++
>  kernel/liveupdate/kexec_handover.c |  2 +-
>  mm/hugetlb.c                       |  2 +-
>  mm/mm_init.c                       |  6 +++---
>  mm/page_alloc.c                    |  4 ++--
>  6 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index e0f546166eb8..e060ae7e1644 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -158,7 +158,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struc=
t kobject *kobj,
>  			 * because we don't want to trigger the
>  			 * p2pdma_folio_free() path.
>  			 */
> -			set_page_count(page, 0);
> +			set_page_count_as_frozen(page);

This should be page_ref_dec(page), since the comment says =E2=80=9CWe don=
=E2=80=99t use put_page()=E2=80=9D,
meaning the code is intended to drop a ref and set_page_count(page, 0) is
just a shortcut.

>  			percpu_ref_put(ref);
>  			return ret;
>  		}
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 94d3f0e71c06..a7a07b61d2ae 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -62,6 +62,11 @@ static inline void __page_ref_unfreeze(struct page *pa=
ge, int v)
>
>  #endif
>
> +static inline bool __page_count_is_frozen(int count)
> +{
> +	return count =3D=3D 0;
> +}
> +
>  static inline int page_ref_count(const struct page *page)
>  {
>  	return atomic_read(&page->_refcount);
> @@ -115,8 +120,14 @@ static inline void init_page_count(struct page *page=
)
>  	set_page_count(page, 1);
>  }
>
> +static inline void set_page_count_as_frozen(struct page *page)
> +{
> +	set_page_count(page, 0);
> +}
> +
>  static inline void page_ref_add(struct page *page, int nr)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_add(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, nr);
> @@ -129,6 +140,7 @@ static inline void folio_ref_add(struct folio *folio,=
 int nr)
>
>  static inline void page_ref_sub(struct page *page, int nr)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_sub(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -nr);
> @@ -142,6 +154,7 @@ static inline void folio_ref_sub(struct folio *folio,=
 int nr)
>  static inline int folio_ref_sub_return(struct folio *folio, int nr)
>  {
>  	int ret =3D atomic_sub_return(nr, &folio->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret + nr));
>
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(&folio->page, -nr, ret);
> @@ -150,6 +163,7 @@ static inline int folio_ref_sub_return(struct folio *=
folio, int nr)
>
>  static inline void page_ref_inc(struct page *page)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_inc(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, 1);
> @@ -162,6 +176,7 @@ static inline void folio_ref_inc(struct folio *folio)
>
>  static inline void page_ref_dec(struct page *page)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_dec(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -1);
> @@ -189,6 +204,7 @@ static inline int folio_ref_sub_and_test(struct folio=
 *folio, int nr)
>  static inline int page_ref_inc_return(struct page *page)
>  {
>  	int ret =3D atomic_inc_return(&page->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret - 1));
>
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, 1, ret);
> @@ -217,6 +233,7 @@ static inline int folio_ref_dec_and_test(struct folio=
 *folio)
>  static inline int page_ref_dec_return(struct page *page)
>  {
>  	int ret =3D atomic_dec_return(&page->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret + 1));
>
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, -1, ret);

VM_WARN_ON_ONCE() might be better?


<snip>

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 65e702fade61..27734cf795da 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1639,14 +1639,14 @@ void __meminit __free_pages_core(struct page *pag=
e, unsigned int order,
>  		for (loop =3D 0; loop < nr_pages; loop++, p++) {
>  			VM_WARN_ON_ONCE(PageReserved(p));
>  			__ClearPageOffline(p);
> -			set_page_count(p, 0);
> +			set_page_count_as_frozen(p);
>  		}
>
>  		adjust_managed_page_count(page, nr_pages);
>  	} else {
>  		for (loop =3D 0; loop < nr_pages; loop++, p++) {
>  			__ClearPageReserved(p);
> -			set_page_count(p, 0);
> +			set_page_count_as_frozen(p);
>  		}
>
>  		/* memblock adjusts totalram_pages() manually. */
> --=20

Not sure about these two, they freeze p and p goes into buddy without
unfreeze to refcount=3D=3D0. But at the beginning, you said there are two
states:
1) Unfrozen page which right now has no explicit owner
2) Frozen page

1) means free pages in buddy. But the above change brings frozen pages
into buddy, mixing the two states into one. Is that intended?


Best Regards,
Yan, Zi

