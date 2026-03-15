Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F385FF3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 19:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CB46B008C; Sun, 15 Mar 2026 15:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF056B00A9; Sun, 15 Mar 2026 15:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D77F6B00AB; Sun, 15 Mar 2026 15:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39FF36B008C
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:11:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90D9E160C73
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:11:30 +0000 (UTC)
X-FDA: 84549241140.20.28BE424
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022107.outbound.protection.outlook.com [52.101.66.107])
	by imf18.hostedemail.com (Postfix) with ESMTP id A725E1C0009
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:11:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="X/puvnYy";
	spf=pass (imf18.hostedemail.com: domain of aleksey.oladko@virtuozzo.com designates 52.101.66.107 as permitted sender) smtp.mailfrom=aleksey.oladko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773601888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b97B/eehhfkDzcU1RAj6VnYtAd/LZ7Q5x0tin2iEU1U=;
	b=aQKdSiBaEb6nVIiKkbQpMKZGztr7qyOGNcVyAjNo/vp+HCLD2tL52sY8erhYEtx3T3jPll
	JjbHUnUmPoUebw9GYM/hhfHvmFEy3+0b7lnHViceMyNeAEodRlv6Pfvmz+AD5MCiFli5+x
	zHa4Xtv3fossC05avnPcyUqzUMmfkjU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773601888; a=rsa-sha256;
	cv=pass;
	b=Y/xJuJmIXroMfT9ItmaKkxnggY243XzSjLO+BynkBl65p6LpHACFxjEkrZD0wtW7upT97+
	ZWhWhfh2Qs/mRwth63sDH5HJsuuSlf1TpWxbU1q5mCXLwRCO0JNoAu/gmQOI3AA/mg2nDU
	Uevm54G0xON2QH9TXrpTZ4U81ij6Tc8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="X/puvnYy";
	spf=pass (imf18.hostedemail.com: domain of aleksey.oladko@virtuozzo.com designates 52.101.66.107 as permitted sender) smtp.mailfrom=aleksey.oladko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b2IAOmuqeMaahq2GrN0ae27sCHSSyNOTg/0MwxnkwTORj+1rUuGqZ6xMoPpn055caXr3HddV6gOxmTfsMDH46/EocW6Oi7v8UQu8gXrGuinGLxVj+rxp9NJrCeIkM8OOPJl/E9enGFd1F/dmLRT5jzS/ofL0Z10ytBxeSDmsYP2662IOwhsDnld+Tngmy2vnXjwZpN0xcaSdVYpR/n4BgKr86ID/eaFa5Hkkr667zEWjD8IWkmeYgGVexVUFYfzLBBSYPiy3GErxcXmAqtxxENpVehDqRAqAjdNW3QTH9Rh1F2TBeycCfdOGNLrF8ajGWH1uqN+SSNr6hiU3CsUjlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b97B/eehhfkDzcU1RAj6VnYtAd/LZ7Q5x0tin2iEU1U=;
 b=ejeM2OHiRD7R5BEHg7CzFYixz9mZbeuEUBu2Yp0oLzVYjQwCVkvHZbtKP2GjJP8v14/K8dNQWEgB74MQB9mpFuxYXEUWCemR7WTLwmwqbCvsHGwUh+cU82cqTrRHVKY5GrYrazzTu8vjz6F5RP+8N1KF564o6hTI1oWC9O/CBb8NgT6/viBmV+hNFvy2mHDYdMMTgcH3FDapcR+7JNWNykyx2odvKUsPeIE/CFAgLVhNSsvCMzsJ4Hq/dAHzMgFj84e1ovbAdfvOoviA7Um4qjMUd/PhrOsrgVxHNlE5IFg1Q0I8Umn70J3/yXtYKMBobX2IvDgeY5otXkI7VOGy3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b97B/eehhfkDzcU1RAj6VnYtAd/LZ7Q5x0tin2iEU1U=;
 b=X/puvnYyi1EtY/PdHcsjSxEy0Qq5UgIOAzBDwLZYR9pKU0n4dwCrswl99sTab6P1bwcCNi88kxPQ2RmfmGAhayab6popCxrlnWLHTdIgJuWCyj9gVED6T9kT0EKRIp3sKTrPvqcsb0RDvYfX726dfBosh8SGTdDIId4njO7mv++EtQzL9F93iuIArtYUlUIYCAR+rh8zsrKxoPr6tw/kQ0yeNTjmnxHWfZdr14U/or4WY5GlEz7d6JSDh+GZ+hg2hMWo6Vi2sBHo9y3x2W8sYFlcZjmPcF8zLl5A5DaqnNuPh/2YeEXo1F/8jKe3zBzQGPxecLugObpK0rdET+C5WA==
Received: from AM8PR08MB6355.eurprd08.prod.outlook.com (2603:10a6:20b:363::24)
 by AS2PR08MB9920.eurprd08.prod.outlook.com (2603:10a6:20b:55a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.18; Sun, 15 Mar
 2026 19:11:24 +0000
Received: from AM8PR08MB6355.eurprd08.prod.outlook.com
 ([fe80::79bf:15ff:6428:dea9]) by AM8PR08MB6355.eurprd08.prod.outlook.com
 ([fe80::79bf:15ff:6428:dea9%4]) with mapi id 15.20.9700.021; Sun, 15 Mar 2026
 19:11:24 +0000
Message-ID: <39daf4da-911d-440e-b175-ec5c2a8425d6@virtuozzo.com>
Date: Sun, 15 Mar 2026 20:11:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: do not override CFLAGS set by the build
 environment
To: Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Seth Forshee <sforshee@kernel.org>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Abhinav Saxena <xandfury@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260306002100.519673-1-aleksey.oladko@virtuozzo.com>
Content-Language: en-US
From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
In-Reply-To: <20260306002100.519673-1-aleksey.oladko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::15) To AM8PR08MB6355.eurprd08.prod.outlook.com
 (2603:10a6:20b:363::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR08MB6355:EE_|AS2PR08MB9920:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e12ad75-2136-4a81-cb53-08de82c6a6ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3E9eaTnSnEfRQ6cjIVmvwA/oaCk44XHIEQxzXto0B559lgqQ90JdmoL/ky5Xphf0lybg+vzTTBAYXOsAAxc0UHU4IiUvvO1TK69NJHkctWXr6GtnCNxb0aamP/omBItvit52HOTvwAqZL6p3VZPgSVEnQwqm5GHbGSngJpSLN8sYRvgWcFWZkk4Kf/zpYjHlwzQJe3ADm9EkUcCx1GsUB1GB72Vb7bRmSIUF7mDdJOH8v5iNEFsoA9Dyn0jpkNgzT3Rc9WatS2rD971B45P8dFdZTie0xYHDlbDwkj04O5/MYyvacc1n+nXr5xc6fnCovU7Cf29tkgDI9yYiZuM5ELHnBJXZQud3mBn8Z/5wymPNqpErxD7XRoW0DIXSaWQv3nNnHiVPRBIVfYq7jY5oMM8BG46/a3LH6xkhuTOoGf9svjYQGEwlg8TBihVF0OVTDTp5iHEM7VLlRPqNHj7OZ6Oqg1cQfYkyg4AlPkUBqSWZEdL4GuQjejeNQwvYzpaUoxv1+IeZQHJ2GZyn288EHVcGzDAwUlvd6q1lpiYMJ0ih4mxHKPonEouLAPOKFhHi+vJnod021NAJ6W/aHdXuKLloFjEKykS6vqPl6kjmDC2HkJip3kQltZgPpis2+5FLsuAn7cMA6vtxZZPC9gTu9RL2jLVr2u1h2un7LuvpSs2i3JFqq5PGt5EuA/XLOaYV8QqQpnODLIMVgZYmSTASIye3DLqUiAFEmRQ7OOO2CFqPHWT1zVCfv0Qvo5JEpkclQFd1k6Bo5dC5rNOAlA2yDQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB6355.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTkxQ0cwYWxCdndCaGdKUytHNWhYSm1VNVNsekVXZ3ZnbHdSWit1STVRRTlZ?=
 =?utf-8?B?RlVSRTdxb05lckRMcy8vclZFenc1RTcvRW8wV1pvNWovNDJEeTBDWXF5OVl3?=
 =?utf-8?B?eTBBeml1RDdvZEpESE1jUWpFdUxTK3BpcWZjUHB6NHcrUDd5UEVvTjFKbjZ6?=
 =?utf-8?B?eGhFbUtkSWxoR2pGVzBnMHFhNzNmNDUrbW0vaG9nYXY0YXFjekVxZlBodkhp?=
 =?utf-8?B?V3h5bmpyWFRId2xZSG05dGo5cnQxc2ZEUDRBWFVLRFJXaHVyYWowRnI1bGRl?=
 =?utf-8?B?aFJobno5eVB4cEFyblA1S0hHRWpNQ0QwUHR0cWMzR0VNemoyYWFodSttQjNK?=
 =?utf-8?B?TnpjSk5WVGRDc1MvNWlDMkV4QTBLTjJ1and3ekNTQ3QxbUhLRmJvSkE2eHBs?=
 =?utf-8?B?SjQycUFvVkwyMDNaUStWRmdEenBvek54dVVpU3FJQTlkSjdEcUVKK2FQbDd3?=
 =?utf-8?B?a1BLdGcra3RMbXNoR2Q1bUY5eHpFa0FyNm9jOW5OOTh2Q0RBYnE4a2YvWHll?=
 =?utf-8?B?MVlzTGxmdjQzR2tpa3QyLzBuS3MrU1dwZWRpZlpCdGFYdEVPbmlqeWxJUUZa?=
 =?utf-8?B?RlZCVXBncXVCbWZ0VTZGL0JYY3l2OGtGK0FGdmlkOHdrSVYwWTVJY05Fc3Jn?=
 =?utf-8?B?a2k5L3FBc2VNeTJ0QTNOcExydUVlcVZWNERybXdKcUF1KzJGL1oweWpSemhs?=
 =?utf-8?B?aG1WOGVGWHdCcDVLbWltM25kbnJZa0NPSDlnOUI5ZTBDQlhEcjRzT2JCV3d6?=
 =?utf-8?B?WHVQWmdiSXcyVVFmOFp2ZitXcE5QVmFuUjRxWmtwL3BNSXRCSTZMYmlsMmtG?=
 =?utf-8?B?S3lrVjBrYkpWZGZmenR0RzdVZk9UcGlIUjFuVHowVTA4N2NjbmRtUVY3R0xB?=
 =?utf-8?B?TEMxM2VXYXVxNE9UQjNyeEhXS0d6VFZCLzhGWW1NMzh2VlNJVGpJOVo4YXN3?=
 =?utf-8?B?Ylp3QkhSUWE4c09FQVpvaTlzcGRrdzFDV242Qk5icXZNand2a1dHZlhsVkhY?=
 =?utf-8?B?Njc1a0dieGJIeW5GeWhhTlRpd3dIM1Z5SEV6ZTNMazFESWJkcDEvVm1ZNGxz?=
 =?utf-8?B?OE8zVGoySkU1RGNhdmhDZ2dCY0Z1NGNRSlRhVkR4RURjUDNDcGNVUTU2R2lj?=
 =?utf-8?B?c1VPSis2clptUmxDaE45MjdpcXRuRnBXdFltOXdJcVRBeEkzYWFsUklPc0Nk?=
 =?utf-8?B?amV3UGtDNUJZUzZJNWxlb2M0V3dsUklxYVE0MTdkZmxTYjJpaEdKOXdNZVB1?=
 =?utf-8?B?Tml0aHBvVVN5a3Q0NEZ5ZVNzSVcwMGM5c1hsMllvMng5dXdudVVGWUlaYU42?=
 =?utf-8?B?bit1REk5Zlc1STdYZGtiTmpVVUtjR09pNEJvR0FhQ2tOK0F2Q3dXU0hiUnN4?=
 =?utf-8?B?Vm1pRWFiTmJyZEYzdzdqV3ozNElmMmxNTlBSVG9waWU1YUtpa09TUVVJSmJH?=
 =?utf-8?B?TDdGZGh0OVBpbXVnbGtpemNZYTY4MSs0Z09OSGpCdVZMU1EyNER2YzdlZnVq?=
 =?utf-8?B?NkpSc0ttU21YUytlTnpsdDRiMkVkcFBUazNoRGhVVzc3emExMytKZkdzblhi?=
 =?utf-8?B?NGNWaW8ybGpKZnltMU1XOFlpdXRsZmt3UE9EdDBVS3JSUGVjK3RNaXA3Umtu?=
 =?utf-8?B?ZDZvTjZSOXJBNjErcGZqUGdkUmdmckJGa1oxQVJWYXNhMW9seEFjcWR3dUF3?=
 =?utf-8?B?OUN0MG41NWVuTHlkWDFxRko0cmptdTM0KzFXcTZBKzk3WEVzMncvTThDSE1h?=
 =?utf-8?B?Tzk3NThVMjhuVmFkVnZzb2EwZmd5cFdQdzhNVXZjN0h5VDBDTi80cHh6cURF?=
 =?utf-8?B?c0RkMzJic0pFZ2lvZENaTmgyU2g0ZWlLNlR6SDlYWVh6THU4ZGVxK1ZFTEFT?=
 =?utf-8?B?QzJUWkh0Wit6d09haHhlTFhrcno5K2VLWXd4dSszUXpDTm1DQ2FlUzk0SFBn?=
 =?utf-8?B?enZyTU1CWTNLdFVLMk5KWHNwNnIvcjhVTitCRWFJTXRBd2g4OWdRcTZKOUF5?=
 =?utf-8?B?eE1sMGIxb3Vwdnc2ZWI3c2k0ZnMyZWRKa2JBZENiakQycy83Lzk3TlZmdVA1?=
 =?utf-8?B?OXUramU2cHNRZjZJZmJ2UzVvb2dEN3k5K2w1RWZaNEE1WUhsWFBURllLblhx?=
 =?utf-8?B?TGd0U0Z3MW0vNWdLeDkxclRzMldPN3IwbE5VbnZNdDdkL3JVS1labWc4bVo4?=
 =?utf-8?B?bVdMb1d1UXlFV2gvWlFPS0RpbnFKbkhkbmdYSUxoNlZHK0lxMldVS3NNbUNS?=
 =?utf-8?B?TzI3TkkzMzBKMTBQaUFhV3NKd3BkYjlFZk56eXZNUXpHVG5SRnM0RXkxdnJ4?=
 =?utf-8?B?cXVtVS90ZWpIdy9PY2JLNWhiaTQyMXoxOU00QzJLV1pwYk8rYjdaajNxcEN2?=
 =?utf-8?Q?OCIKZDH4IJjusAts=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e12ad75-2136-4a81-cb53-08de82c6a6ac
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB6355.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2026 19:11:24.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM1hmeJCnM+AnvYmnE3cnAHYbKlD2Ij2NsAE7lOivkoRsBDB09d7YtiVg6/koJHVK/T56WGuJ5936go/KGsQcXm/IKEpkOtmwO8+k3U+4og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9920
X-Stat-Signature: srweyyxkroz47i1pmn4zzm9czzkyi4g1
X-Rspam-User: 
X-Rspamd-Queue-Id: A725E1C0009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773601887-162076
X-HE-Meta: U2FsdGVkX18nPQl4F3ilGYdpJ459phuwMR6PvYb2f9mk3pRYOP0s+KdhiGzaJH0m76WvNDCJcJoyOTbLkOSsQTPEu4hXyWB9lAuJpJ/aqokggC1e33FGMcyh3WS15WWCYnPZnCLB0tIJkX/oKUvJhfzwCdNFWDG7hdfMqHYAz33RvbNUi3DhMqV8IUYUuAoFRLL1N5fvQLZZtjvK3dMifmr4EliSGTP9Ds/313/iI43q1ecL0s1sw/PDQFvojkqXBDSZu5Vxfy0V2e6S8yn0O6aRfzSLRCpTHJUrGXdF4PxxBPllgdah8p8aSCDopi8eHl2iDC0z4IXqdwVBmnaKr8+lAm6f2IzYkMZ3nMp/uj7MROsIMchpcTljSh93L0KM0A05vdywndUTpR0jBsT7+YIXX3YcQh22B7dYs/ZV6W0D6M+cUFa+E3gV6Hin0a44WVBC8Ke4jlktBPOtypj8QyMUewJfiHps1bjAa8axT/qHd3GeyWTmEGLspg7VsDeYDN3ZpLA904swLdQIv/U5GJiHaRB8IrmxsS9W1uajSXlx22dTpwW8jS2SO184Yo18hFWqXOAk9nTviAC8kH1ZNKoaRsWg/GCJ1+dGaj2L8PXaJfxpG+7y2NMMsmWC125tDX1JHMJNK7e/XsbJhV60gWYSeYAtKsBtQNngC07cho8z/ASslH8ZpXGm18EUtaATfRqTE3d6kbX6Bu/N8mVLRbrWo7a4NkZoQr2jUmJVobavi0/fdHz/231Z1H+KTXQP4jZLdFtZBaJPY9nPVFz0SqkD+NgdNYr0lEwu0ZuMaX6uY90Vv7NNwELP3ot3ruVJQbt7TKZEcm15k7cxh7+QL5dIZLGccJn5i+BP1OzlnpumSOzEQuY/CTdemnB3xqRjCwHIcrYKYqEEJwifQHY+VhluL8vMpH/6mUm2Z28kYbPw96AHWCLOHZXHwjtHuUsRqMGsglAxTq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I just wanted to gently follow up to see if you had a chance to review 
this patch. Please let me know if there is anything I can clarify or 
improve.

Thanks!

On 3/6/26 1:21 AM, Aleksei Oladko wrote:
> Some kselftests Makefiles assign CFLAGS using 'CFLAGS=...'
> which overrides any CFLAGS provided by the build environment.
>
> If the environment set flags, overriding CFLAGS may result in
> inconsistent compiler and linker options and cause build failures,
> for example when building PIE binaries:
>
>    # export CFLAGS="-fPIE"
>    # export LDFLAGS="-pie"
>    # make -C tools/testing/selftests/ TARGETS=mount_setattr
>    make: Entering directory '/build/kernel/tools/testing/selftests'
>    make[1]: Entering directory '/build/kernel/tools/testing/selftests/mount_setattr'
>      CC       mount_setattr_test
>    /usr/bin/ld: warning: -z pack-relative-relocs ignored
>    /usr/bin/ld: /tmp/ccikConN.o: relocation R_X86_64_32 against `.rodata.str1.8' can not be used when making a PIE object; recompile with -fPIE
>    collect2: error: ld returned 1 exit status
>    make[1]: *** [../lib.mk:222: /build/kernel/tools/testing/selftests/mount_setattr/mount_setattr_test] Error 1
>
> Fix this by appending to CFLAGS using 'CFLAGS+=' instead of
> overriding them.
>
> The fix is not applied to the Makefiles in x86, riscv, mm, arm64
> and powerpc as they fully define their flags.
>
> Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
> ---
>   tools/testing/selftests/efivarfs/Makefile             | 2 +-
>   tools/testing/selftests/exec/Makefile                 | 2 +-
>   tools/testing/selftests/firmware/Makefile             | 4 ++--
>   tools/testing/selftests/ipc/Makefile                  | 4 ++--
>   tools/testing/selftests/mount/Makefile                | 4 ++--
>   tools/testing/selftests/mount_setattr/Makefile        | 2 +-
>   tools/testing/selftests/move_mount_set_group/Makefile | 2 +-
>   tools/testing/selftests/resctrl/Makefile              | 2 +-
>   tools/testing/selftests/safesetid/Makefile            | 2 +-
>   tools/testing/selftests/signal/Makefile               | 2 +-
>   tools/testing/selftests/timens/Makefile               | 2 +-
>   tools/testing/selftests/tty/Makefile                  | 2 +-
>   tools/testing/selftests/vDSO/Makefile                 | 2 +-
>   13 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
> index e3181338ba5e..f6c412059af3 100644
> --- a/tools/testing/selftests/efivarfs/Makefile
> +++ b/tools/testing/selftests/efivarfs/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>   
>   TEST_GEN_FILES := open-unlink create-read
>   TEST_PROGS := efivarfs.sh
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 45a3cfc435cf..54cdefb9ccb0 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>   CFLAGS += -Wno-nonnull
>   CFLAGS += $(KHDR_INCLUDES)
>   
> diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
> index 7992969deaa2..dd9acf972cf5 100644
> --- a/tools/testing/selftests/firmware/Makefile
> +++ b/tools/testing/selftests/firmware/Makefile
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   # Makefile for firmware loading selftests
> -CFLAGS = -Wall \
> -         -O2
> +CFLAGS += -Wall \
> +          -O2
>   
>   TEST_PROGS := fw_run_tests.sh
>   TEST_FILES := fw_fallback.sh fw_filesystem.sh fw_upload.sh fw_lib.sh
> diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
> index 50e9c299fc4a..5a5577767a35 100644
> --- a/tools/testing/selftests/ipc/Makefile
> +++ b/tools/testing/selftests/ipc/Makefile
> @@ -3,11 +3,11 @@ uname_M := $(shell uname -m 2>/dev/null || echo not)
>   ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
>   ifeq ($(ARCH),i386)
>           ARCH := x86
> -	CFLAGS := -DCONFIG_X86_32 -D__i386__
> +	CFLAGS += -DCONFIG_X86_32 -D__i386__
>   endif
>   ifeq ($(ARCH),x86_64)
>   	ARCH := x86
> -	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
> +	CFLAGS += -DCONFIG_X86_64 -D__x86_64__
>   endif
>   
>   CFLAGS += $(KHDR_INCLUDES)
> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
> index 2d9454841644..38361a896363 100644
> --- a/tools/testing/selftests/mount/Makefile
> +++ b/tools/testing/selftests/mount/Makefile
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for mount selftests.
> -CFLAGS = -Wall \
> -         -O2
> +CFLAGS += -Wall \
> +          -O2
>   
>   TEST_PROGS := run_unprivileged_remount.sh run_nosymfollow.sh
>   TEST_GEN_FILES := unprivileged-remount-test nosymfollow-test
> diff --git a/tools/testing/selftests/mount_setattr/Makefile b/tools/testing/selftests/mount_setattr/Makefile
> index 4d4f810cdf2c..fbdb8f69b548 100644
> --- a/tools/testing/selftests/mount_setattr/Makefile
> +++ b/tools/testing/selftests/mount_setattr/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for mount selftests.
> -CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2 -pthread
> +CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2 -pthread
>   
>   LOCAL_HDRS += ../filesystems/wrappers.h
>   
> diff --git a/tools/testing/selftests/move_mount_set_group/Makefile b/tools/testing/selftests/move_mount_set_group/Makefile
> index 94235846b6f9..8771a5491ea3 100644
> --- a/tools/testing/selftests/move_mount_set_group/Makefile
> +++ b/tools/testing/selftests/move_mount_set_group/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for mount selftests.
> -CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2
> +CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2
>   
>   TEST_GEN_FILES += move_mount_set_group_test
>   
> diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
> index 984534cfbf1b..1d566a91faa7 100644
> --- a/tools/testing/selftests/resctrl/Makefile
> +++ b/tools/testing/selftests/resctrl/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
> -CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
> +CFLAGS += -g -Wall -O2 -D_FORTIFY_SOURCE=2
>   CFLAGS += $(KHDR_INCLUDES)
>   
>   TEST_GEN_PROGS := resctrl_tests
> diff --git a/tools/testing/selftests/safesetid/Makefile b/tools/testing/selftests/safesetid/Makefile
> index e815bbf2d0f4..d3811515d8e3 100644
> --- a/tools/testing/selftests/safesetid/Makefile
> +++ b/tools/testing/selftests/safesetid/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for SafeSetID selftest.
> -CFLAGS = -Wall -O2
> +CFLAGS += -Wall -O2
>   LDLIBS = -lcap
>   
>   TEST_PROGS := safesetid-test.sh
> diff --git a/tools/testing/selftests/signal/Makefile b/tools/testing/selftests/signal/Makefile
> index e0bf7058d19c..6c437f95132d 100644
> --- a/tools/testing/selftests/signal/Makefile
> +++ b/tools/testing/selftests/signal/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>   TEST_GEN_PROGS = mangle_uc_sigmask
>   TEST_GEN_PROGS += sas
>   
> diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
> index f0d51d4d2c87..357077792395 100644
> --- a/tools/testing/selftests/timens/Makefile
> +++ b/tools/testing/selftests/timens/Makefile
> @@ -1,7 +1,7 @@
>   TEST_GEN_PROGS := timens timerfd timer clock_nanosleep procfs exec futex vfork_exec
>   TEST_GEN_PROGS_EXTENDED := gettime_perf
>   
> -CFLAGS := -Wall -Werror -pthread
> +CFLAGS += -Wall -Werror -pthread
>   LDLIBS := -lrt -ldl
>   
>   include ../lib.mk
> diff --git a/tools/testing/selftests/tty/Makefile b/tools/testing/selftests/tty/Makefile
> index 7f6fbe5a0cd5..e9c22dafe5e1 100644
> --- a/tools/testing/selftests/tty/Makefile
> +++ b/tools/testing/selftests/tty/Makefile
> @@ -1,5 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0
> -CFLAGS = -O2 -Wall
> +CFLAGS += -O2 -Wall
>   TEST_GEN_PROGS := tty_tstamp_update tty_tiocsti_test
>   LDLIBS += -lcap
>   
> diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
> index e361aca22a74..1f4628ceb975 100644
> --- a/tools/testing/selftests/vDSO/Makefile
> +++ b/tools/testing/selftests/vDSO/Makefile
> @@ -11,7 +11,7 @@ TEST_GEN_PROGS += vdso_test_correctness
>   TEST_GEN_PROGS += vdso_test_getrandom
>   TEST_GEN_PROGS += vdso_test_chacha
>   
> -CFLAGS := -std=gnu99 -O2 -Wall -Wstrict-prototypes
> +CFLAGS += -std=gnu99 -O2 -Wall -Wstrict-prototypes
>   
>   ifeq ($(CONFIG_X86_32),y)
>   LDLIBS += -lgcc_s

