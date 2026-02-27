Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F471048924
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 23:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5A46B009F; Fri, 27 Feb 2026 18:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073786B00A0; Fri, 27 Feb 2026 18:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FE46B00A1; Fri, 27 Feb 2026 18:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D74FA6B009F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:44:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7836958B92
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:44:30 +0000 (UTC)
X-FDA: 84491868300.04.1922BA1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010059.outbound.protection.outlook.com [52.101.201.59])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9320CA000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:44:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZFYwdLHi;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772235867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2jthDnzJUoIOsvrBRpIwweVx3aNelNKRI6ebjHLxJE=;
	b=Nwtx7+s6jM27TpA9Mp1Vf+byNWYjf3QVmkbcNC+3WfftYi2DbLE6IKfXEfUXub3mD5Bwiu
	DtdvgaEbMQaWEcelfLWqrum6v/RLTl/+jJpYa51XO6wX0JMa650LnE+2FtACGyIjoGtPDE
	xXvypP5EfNg2Qldy0tNulQXRL3V07fI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZFYwdLHi;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772235867; a=rsa-sha256;
	cv=pass;
	b=L040rVz7j9vxy/wAPRktPnwuulDal9bHXFVOehSffDGz0VZfRCMKozjktGf5EwCvCkgQy8
	uatYfV1c8Yn977nspfK/y8NKa1gmQbpEiOPvn5yqIomOOUxRlC7aYzuEjiTYfr8iBOyo5l
	I/conIexaD+WP7jIAMC0jId4PRMmXc0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELUlp2htQ42x20lttbKGC8PY6qSU+XbYqlAlMQBuHqf/YeyM9utPrzqbwB1/2oECCj2s8C5USgYstj6qqRS25r8G5zam71LV3J4zbK3Wt8llZdsHXtZXKO7E0cqj53gkKw0UADuSt+RH8o7TLY7QSW/gwGWB+pkM7u2KnuDxG/Og08AHN6VuutxZ5iIyEZpdocz7Q6T+CTuV9NA4f3F5zlTFElytFT++M+Kx4MwwUt/+d247dtj51c2rKUHskdYXWMtsIoolYxQeSw7/2BO/sVO8xR1wPit9Xg0Ex5cXOODht5b/P89SLhjHoxaS86V++zy6jcnrZn/11eO7NMWdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2jthDnzJUoIOsvrBRpIwweVx3aNelNKRI6ebjHLxJE=;
 b=R1+ChZfwhYaaJA6wxOSBuf2Fx9jOkFWWaFuHcZePOWaGWuseudLwWUIHLsplo1QTQA10zIozB5X0u+raA6IDD1XYqPw4zuls6q7yv/3J3MWoJVzuq0pIzWGMPOaH7tOyvPzpiElwHLVdaSGVR7P8z7mZ2BFhY4TrFyWQouXbaKyU2WOSUIZt6ruLbFAzaUeLkTwIQQY6mvaWZQpGM2MF+xhSKCXXLgnpkPbJq0WzIc560Ms2P6YVdBXEm1NZ6R6M8KmoUl8+R7mLMOBEmxPqDKCX3vUyfqc+Wg+psEScxmZ7Dc5oySTpZREWL9evXibw5M3Xvjae0I7CTRbNBxxoAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2jthDnzJUoIOsvrBRpIwweVx3aNelNKRI6ebjHLxJE=;
 b=ZFYwdLHipVLUXZH2RQKffCCTRef9R7bst6/Ya642Pe21SmUcR1k1ERM1ud35IQnkRxqLGL358c0ThFciboDnQD0x6KmxI9VPHnJRRt4MQLtBr675ugmWJ/xZvYNaqpegkt/wR/QhB4zQL3aRbxE1zeEOjxlFGycWAuxhwvmd+Pp2nRoKxjdABa1YvxnAhaDXYO2QxPDPXFB21fvzbHbH69wwfbfk5ErMiGFR+bSvbWK5mM53CUn+VpSspuLQ2j6boSDlsPCsyX9dqcJVn1/jlpm2UAjdayrKkEqNqfynpuoJ1VJ2iMDF7NwgzUJLDx6SG3je4l1apkN4Hpi8LMkRHA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 23:44:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 23:44:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Bas van Dijk <bas@dfinity.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, regressions@lists.linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Subject: Re: [External Sender] [REGRESSION] madvise(MADV_REMOVE) corrupts
 pages in THP-backed MAP_SHARED memfd (bisected to 7460b470a131)
Date: Fri, 27 Feb 2026 18:44:18 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <49DBB7AB-9BC7-4543-91DE-DC472D7A5B44@nvidia.com>
In-Reply-To: <CAKNNEtziooemhq3Yb8OpOjg4N0bV+Kc+1in0P7L1i_NBWS-q=A@mail.gmail.com>
References: <CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com>
 <CB5EF1C4-6285-4EEC-ABD0-A8870E7241E8@nvidia.com>
 <D4BD80F5-6CA2-42E1-B826-92EACD77A3F3@nvidia.com>
 <CAKNNEtwZzt3xWh_b1pn4X4FG+cq6FLOP5rR4+G=WUsjHsJRjaA@mail.gmail.com>
 <2EECA9B4-E1F0-42FF-9E61-3E4AC4B4DC13@nvidia.com>
 <CAKNNEtziooemhq3Yb8OpOjg4N0bV+Kc+1in0P7L1i_NBWS-q=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: 538d7503-a945-4ad6-b01f-08de765a22b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	qR81BLpThoBSuQQ5xQEH3YQkTFGJ+HLhURTf2pFDZNfTlWqR/edxrKidmHuW0yR1A2jFhkavea8EGXZLUFN2OQ91ECz8pbmZVaXeB/ametb8VMxd3S9y1u5fjUKoTHVeGndMP46uYdoztbSNKilZ24odqu95qxhBDY5Ip3qsVeRoEJ1S9Ip1Ubu5xyRAokXs3hvnsOPihsBbd+RTjfVIhJ22RRj6XOB/Rh1tlUolLrvyRkiotl5Vf6wDX4BmmxmrfYtB7hIZ/qNwyyuMmKITMj8hWpY07KaHq/wpi21fZaI8GSLaCZ4TF0TlOXjmlUX7R8sDdGaOL+CwMoVBbfcJ/SNpIMnjN9y9SQk8Fu85k06gb4iwhoK82mdkP0mdx7zbH03wN5zCJc+yfJG2BvX2Poj6j0jT1/si1/qb4sRQyfJjMs25Rz62BubfBZrOLzlZKBAJeQVwPNSVP3iaIvEtHnTKxEYYSKpJrQCG0+hVZ63ajrkd29xNbpZlOVdY/miBMOJYyuYm110Pr7muQ4NBTneGGcFeKB4nEi98I2PvhZIbuV7BV5pieATPhRFAzsrbOAbTtF0g+qohUqcHh6vnqVvobhS50TMcajajxi+E7qJLBdlaUdI7dAT6g3GiA58+md1NDHaXHeA7dVROOzStSGMbpnGqLHaT2XWKUyD1ufsn8MTUWnjhU5TJYUPDWY9sXT8btcm6hLYymVZYEfMFOPZG9dDwRRo4uo5zlzfi33lRDrcM6ohqzwIddurLxKdH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2dTMEtDanV0NTc1M3NQYlFHWWZyazgrNWF6SExyQlF3d0RKcmgwalUrMHJP?=
 =?utf-8?B?QU9jQUZhNDh6TVVPOGJ3UmZjZ1BSS3ZHVlB2M0t1NGRGMldMSEhEK2hqOXQz?=
 =?utf-8?B?UzJQdUtPRmdiWFlZVGYwVEpoWDlTLzZSM0pOM3Z0K28yTUROVHd1Z3RvdzRW?=
 =?utf-8?B?anpjNHhBTWFCV2pCNjg3aHQyWkdqYmtTZmx5UUE4UEpMcVJFbE4zMlA3K2hL?=
 =?utf-8?B?YURodHhnZUtSRUNUNGpsZUlPZXFyZXlKZWVLZzVDWGlXM08vZ0xxT2RUbkNG?=
 =?utf-8?B?bGhNKzN4RTJxYVh4ZXhrMGl6Ynk4bzNxYXpCVWpGakxMcWJGQndHayswOVZF?=
 =?utf-8?B?OSs5NlIyUTUrRG5nQTAzOFVpOGpzM0pqMjVQUWFFc1RVT3NKbytFL1dsdWF5?=
 =?utf-8?B?ZS96bm5xRW9WTkhvNnFtcHMrNEVpMVN1Nzlhc1Y2OE9qa3kwSGE2cmVwNVNX?=
 =?utf-8?B?ZGxFSXdPN1VjWWxyWXNIeTBWaEthRE1SZnJyaS9NRGNaM3Ntbmh2ci96c2Ry?=
 =?utf-8?B?M3BYOHNYNjJyZ1d4S3lYTlBzV0VtRUJZblFsZ2ZiZWNFTGU5bG03aEJaNVI2?=
 =?utf-8?B?WW94U2c1QVdjUDlPMzJaMmo1R1l0NTR5dWNEdFI4azY1ZlpJYURYelJza0Jy?=
 =?utf-8?B?OG1Dd1dxUFh0SkFNVkZKMjRRN0NhRUh4V3FMSHRCUW01QTZVaHZLOXRzcVYv?=
 =?utf-8?B?RHhjZ3ZScGN0Y2NuS3kyZmlHR3k4VkUxcTM3VnRZaUFDaFd4akM4WnhKWXNa?=
 =?utf-8?B?L0tZMnlQZ2g5bEk0YVRlYW9wSTc2OTRCQ29LTkhxeVI1eGQwa3YxUWpOUGFp?=
 =?utf-8?B?bUpqTzh2cHY0Sjg4Z1NwZ0Y1Zy9xNWo5KzJtSCtYRGUzQXp0YnlUZ3BjYVh1?=
 =?utf-8?B?ekpRZ0dtWklJUk9SM2xRWXhUcUJRWk83cFFDUzN5ZE8wOXJ3R1VPRmRlQkps?=
 =?utf-8?B?K3FoODcvSmEvVk1tVUJDaithcXJZMTBadFM3ZXJOR0ZGYVBPV2FiMGFydklI?=
 =?utf-8?B?NjZkRjJGTUZpdERGY0xoR2VZUEhJQzhkL2lxKy8xYmdqbWd6MHVkTWRDSmc3?=
 =?utf-8?B?TWdMRXpRbytWOUVkWmxCSkF6RDVBai9pQW1KL2RCR3ZYYjlOd1lGb3Q3bXdq?=
 =?utf-8?B?ZHdvZUxYalo2WENORnNvd2cxQ2JGMUYwNEtkRnBCdzlwYzhZckZxMHB4RzVk?=
 =?utf-8?B?WTVCbTJOcmU3VUpITWsrZElaV0xpcVZSQittbnZIcXhya29HSFp5OVF1SW5Q?=
 =?utf-8?B?UTgrbmZncDAxUmFuVWxtQngyVlArY3UxN01iTkV6OFUyZVJWbmN5akVuZDhK?=
 =?utf-8?B?a3BWUTJ3SVluV3lqNWFxUFA5Uzg3ZnZqNW05a1dRZlRqRk00eENuVTZYRzJ4?=
 =?utf-8?B?VDR0RUNKRXpYSW5KNHRGeklhamh0eFhlak1nZENQbWNBME9NZUZzZnNFdXRt?=
 =?utf-8?B?TEpzU0RMM3hlYjQ4SUw5MDAxdHR0YXUvaGM5ZEtwenhwUHVYeUV6SE9LK2hR?=
 =?utf-8?B?T3hCZndaZm5GbS85elljQ0lIU1kwd08vLzFYKy81R1hOZUY3cmYwV2pjOXZ5?=
 =?utf-8?B?bE9HSENrTUgydURMZ2h3K0llN1dzV0tFNG82YXdES2xoOXZET3ViRDBQa0Mv?=
 =?utf-8?B?U01haFZqTCtNVG5SNFI4YmZpbFpCeE10MGFBWXVnQVRWYXlOalJJeDA5V1VZ?=
 =?utf-8?B?YnkxbVJObjRTQTdjUGVjdi9MMUhTVGtKSkN2aEQ4QlRNZW1yQzFqaHhPUko3?=
 =?utf-8?B?OUZEcTN5amJsaWFneU1QaGdZQ1hia3dPYzBtb3FuVE1UVGcwNi8zNWNHN0Jl?=
 =?utf-8?B?WnFvZTcrVEQvbU5zZmtNcTlNWFliZlR6dXhvZUVoeUxKWGFHUi8zZ09DZlZB?=
 =?utf-8?B?VTRNUFFJeVlVU2tvSlp2TDNkN0pUSWRqSHptRGpqMkZHdThwcHBUWjZaamU5?=
 =?utf-8?B?YWptK3dpODkySzZjendMZFh3NnZVdkYzcTRxSUFHTVF0MUxJQTI2YWdXNlJ1?=
 =?utf-8?B?dCtkb3RoOGFoRm94ZDNGOEdlM29sdDVabUZtUVoyQnh3L1lOcEU3YnZRdkZY?=
 =?utf-8?B?SWxYTzNxZ2MrWFBpTGFQcnRNMGNzVG4zK1E3S2xqODhZaTlaWDdxTHA5eTc0?=
 =?utf-8?B?TWlwTmxzOEswOWJxNEw1YUpZRHA5cXVFMllyVXRXaG93TnZCZ3FGSXZYRVVT?=
 =?utf-8?B?OC9IM3ZyMy9sOCtwQnBYMWJjdnk5M01zZWk2bExsVTBXaWZXNTE1ZURRZThL?=
 =?utf-8?B?ai9Cb0Y0RWdBTng1dWJRenZRQlBXQ2YrMnNobi92Zjl6eVg2ZXZXU0FVRElq?=
 =?utf-8?Q?VyCdqaxTu2d+5XLGPH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538d7503-a945-4ad6-b01f-08de765a22b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 23:44:23.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Snw/274y3gbZtvXSziUHypEKT1+9nyRqhW0FPq70KT71wpYMtJ5/HSFAKptqpM+v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5953
X-Stat-Signature: fquftsdyxd61j3g4uuqazoqfy9e1mgh9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9320CA000A
X-HE-Tag: 1772235867-739936
X-HE-Meta: U2FsdGVkX1+apzN/MFcGyi/ONXUkd3vYXWzEV5luf/MkbH6eaRMEL5BgLFEXFCEdoFlE+sdGOoiQ3/NwBdQQ/CgKoHIKJd9WbavpcFH5K0IhpGtHGawUyBBMnd5I2H1O8IhBhbYfUQpSR4ejOxi9Z5fEYDqA1wFrGBEMrjHGY2XYBi/uqdssC5H9bCER3zfkckL3aXiI+ifl1gA9ZynrRqZ79wB4NezzRlsC05s363fE0B8DKWzM6LME7aexLSH+9M5ZoyszOMIJicXZlJf45N9NEgrrFt+sv6vGVjPtefxoK8/2DdQ/G4yFuVP/YTWhvZuMNGgthI6Kw32oVXWC13h5LMqqazjLygB8DfjyiXsJF5O7+x9v/3WEaK3K8wVw0zCOLz6EKuY2+RBqe2zLdqpI4yA/WPEZowvjaQhAapUm1KDFmTfBBr/IqsgbFXNvGr22ST53wN/1uYSPQ+WYDcrmIym3oJij3Bhcjq4f+k1saqMSRZVEMKhh4cRQ7QfjHmAm0GEK0buVSdJVTu16LHDe4xbqmUorGFjj8jKDGelMjxeAoxHFQQ7JAopkhnDuQDpcMQxc0oYiyV2znx/BUI8pHCiTKv9R3sy49bA4QkpZ7NULYJgA7yRvXu0KEbDUAPMJBwvqwIbUngrfgYoPfTsmUEisZedBvJOA6bnVu9JLUkZaab2TkTRSh/sGOu1t2YROuyvXWm49MlG97EQ6NIygsrn/OmRK0xWb4HTba+eaT95ReTlCdvQxtbUQvGwOoXc06PvhA1CxFtC1DeogAOWHrexA29Pl+ng3+9YJ6fftsj61RDAYyvSuqvEpbesg74tdoe8tL50e4sgYj/rcRmTNSkpXwVbCtmPASevZISqfMS8vS3XBSUrrHQ4U46mxUw2fZux2W8yPRSw6nl3M+df16TqYc/fVO7B6htjz60Z1dMlC077DebJVfx7QGbi6fX2KnRtIaSj292CvwpB
 rrp7+u56
 K9XAjv6VPh+EzFFFL3OaKf4KC70ViWoGFoasg88MSwaGQh3B/lHagoItXZ3XTH8wqb8cLkD+Z9+1n/c2vtsswGSkW89NBGzckc9Fxyi6rrTIozbwtKXqwTbAKRH07siVgkSqA6QMmXjQ0dyHSdRTsfKqOQB4jOnGsvoeEw0YmNfElGevUTSvhgCm5nMjoVfxojw0kTZwL+LtJUXbVBjw5TjrsyDy8aR/ctwLc5nqow8C5a390I0x4wmI8kWg+bF8MkXhrUxEpl4ooWd+yN2u+0eCbHUGGBWL5HdKJNLPc8MriuKCIWo79JtbWSGKo++O2hSYugFkV4nhEPjkWu+mtVh5S9+Q4Igo3D7iJ4Y1eTBtnj2TmxTYENp+n5d5axX1YU38lZ0cxAVyR2atcYLtlM0ppSJ4YaT11ciEPKZyRUABkl1uG8+bietDOFejIh/iHdFslLu3RJoRM0rU2hZlZlDDfieLSnb1FIKBy6oYZ/gDuQf4A9ccSMpNhycRV2xgdbSnLRPHLTCfhN2xTsJoZ3VKHSCjl5zdOt8Z5yMSenfGmO0wQYD1PY3BC6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Feb 2026, at 18:32, Bas van Dijk wrote:

> On Fri, Feb 27, 2026 at 8:29=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 26 Feb 2026, at 16:16, Bas van Dijk wrote:
>>
>>> On Thu, Feb 26, 2026 at 10:06=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> On 26 Feb 2026, at 15:49, Zi Yan wrote:
>>>>
>>>>> On 26 Feb 2026, at 15:34, Bas van Dijk wrote:
>>>>>
>>>>>> #regzbot introduced: 7460b470a131f985a70302a322617121efdd7caa
>>>>>>
>>>>>> Hey folks,
>>>>>>
>>>>>> We discovered madvise(MADV_REMOVE) on a 4KiB range within a
>>>>>> huge-page-backed MAP_SHARED memfd region corrupts nearby pages.
>>>>>>
>>>>>> Using the reproducible test in
>>>>>> https://github.com/dfinity/thp-madv-remove-test this was bisected to=
 the
>>>>>> first bad commit:
>>>>>>
>>>>>> commit 7460b470a131f985a70302a322617121efdd7caa
>>>>>> Author: Zi Yan <ziy@nvidia.com>
>>>>>> Date:   Fri Mar 7 12:40:00 2025 -0500
>>>>>>
>>>>>>     mm/truncate: use folio_split() in truncate operation
>>>>>>
>>>>>> v7.0-rc1 still has the regression.
>>>>>>
>>>>>> The repo mentioned above explains how to reproduce the regression an=
d
>>>>>> contains the necessary logs of failed runs on 7460b470a131 and v7.0-=
rc1, as
>>>>>> well as a successful run on its parent 4b94c18d1519.
>>>>>
>>>>> Thanks for the report. I will look into it.
>>>>
>>>> Can you also share your kernel config file? I just ran the reproducer =
and
>>>> could not trigger the corruption.
>>>
>>> Sure, I just ran `nix build
>>> .#linux_6_14_first_bad_7460b470a131.configfile -o kernel.config` which
>>> produced:
>>>
>>> https://github.com/dfinity/thp-madv-remove-test/blob/master/kernel.conf=
ig
>>
>> Hi Bas,
>>
>> Can you try the patch below?
>
> The test passes twice with the patch manually applied to the latest
> master (4d349ee5c778). Thank you!

Great. I will send a proper patch and cc stable to get it backported to all
stable kernels. Thank you for the report and testing.

>
> I had trouble applying the patch using `git am` to 7460b470a131 or
> 7.0-rc1 but this is the first time I've used `git am`, so I might have
> done something wrong.

My fix is based on linux-mm tree, so there could be some difference.

>
>> I was able to use your app to reproduce the issue after change my shmem =
THP config from never to always.
>
> Yes I had to write "advise" to
> /sys/kernel/mm/transparent_hugepage/shmem_enabled since it's set to
> "never" by default in NixOS. See:
> https://github.com/dfinity/thp-madv-remove-test/blob/d859609820113c690238=
48452bdba8b619d78a8a/flake.nix#L93
>
> It would be great if the patch could be backported to 6.17 used in
> Ubuntu 24.04 LTS since that's what we use for the Internet Computer
> and where our tests first started crashing.

The one below applies directly to 6.17.13, in case you want to use it
locally.

From 03b75f017ffe6cf556fefbd44f44655bf4a9af48 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 27 Feb 2026 14:11:36 -0500
Subject: [PATCH] mm/huge_memory: fix folio_split() race condition with
 folio_try_get()

During a pagecache folio split, the values in the related xarray should not
be changed from the original folio at xarray split time until all
after-split folios are ready and stored in the xarray. Otherwise, a
parallel folio_try_get() can see stale values in the xarray and a stale
value can be a unfrozen after-split folio. This leads to a wrong folio
returned to userspace.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4ca8cfd7f9d..3d5bf3bb8a3e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3628,6 +3628,7 @@ static int __split_unmapped_folio(struct folio *folio=
, int new_order,
 	const bool is_anon =3D folio_test_anon(folio);
 	int old_order =3D folio_order(folio);
 	int start_order =3D split_type =3D=3D SPLIT_TYPE_UNIFORM ? new_order : ol=
d_order - 1;
+	struct folio *origin_folio =3D folio;
 	int split_order;

 	/*
@@ -3653,7 +3654,13 @@ static int __split_unmapped_folio(struct folio *foli=
o, int new_order,
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				/*
+				 * use the original folio, so that a parallel
+				 * folio_try_get() waits on it until xarray is
+				 * updated with after-split folios and
+				 * the original one is unfreezed
+				 */
+				xas_try_split(xas, origin_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
--=20
2.51.0



Best Regards,
Yan, Zi

