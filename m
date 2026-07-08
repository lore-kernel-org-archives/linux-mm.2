Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196FEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4EF6B0093; Wed,  8 Jul 2026 10:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C951A6B0095; Wed,  8 Jul 2026 10:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D7D6B0096; Wed,  8 Jul 2026 10:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86C5F6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:35:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 095121A0188
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:35:36 +0000 (UTC)
X-FDA: 84965857872.11.749B228
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 363F71C0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:35:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nx1iAiI7;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvTLEPO7rNdWcXoWjMeCKaTxG05tfAfpZ69UNEp5nRA=;
	b=W6/WD2DVZy002aE4ss2B4iXgAD9dd2crQOQvKqvMsS5CbHJQAecxM2cHvzWhudJQWBvWSv
	mfl25njDKqG+8CVbmjcRqhsK1SwdoD7Fgm/Dm3dI5h3GywSS8kagdZzzZTbkIqH4WaZgpl
	+IEeOi7Aqpf1T/fWJT3H+Ub3KtbSxg8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783521333;
	b=3D/ZIPh1AoxWVK9Mjg5AicZI8DUIp9EuiS1ZG5w7giNZGKaXBHFighj9BLAMkcyCoRyLwC
	PoBVds0P/ElV6C3ls5fhBEVbagmra48fc27NzBxG855AQC1A3em2DaiBWsgHHRxoBMYOCk
	BCDn6r/CURAbfO5Xqy4qomVbNwXiEnw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nx1iAiI7;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SE+gp2HpztbrW2CMyuZZd9151zSAvkTQSpP1Bl8so2UBXqnCtVyOJacggjNIQD9lvDAaLYgN7vy8qf1Gs5/P/3tRcH/jl5RMRJdOmhDU39v7jd1FbTq/PW0H0NEQIAYvEEgFT3ZGNJVVb+sCDYc5uO2Qjdoe/b95GWNsViz1TON4VCXjfAW23B5mV+SYbMIyO8iOiJE2ObhN7SjZIAIP8dD8WHnpSAbJ/fuNXka5Y7F/6gpaQr71TE+Z1+N2gqrEOwMv5j8ZU5g2EQvgQ+L9p71XDy/bGi2Unaj60cFw5VOJ6jWwPhWKZIq1pOd881SEzXV2qAcpNlEF2uGNn550aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvTLEPO7rNdWcXoWjMeCKaTxG05tfAfpZ69UNEp5nRA=;
 b=wL2oUJLjt6IfZWs8CimNIGXt2AxuWqQEb6drguz0Hv+hXW/oV9A9b91SuOh4z1fJj+VpiqU9enDR/DeaNxVZNl4wq+NOSjixeKMvWHPaHOsjeAZxSTgEWUaCcCw6cOB76c7CjNtdYYi8o515MY0pnoixOVPHjwIzU0W2AHIMslTt82BBd5xz6C/hc3ZR6zc7XQGMGHg8eNGBxqmX6useb0ds6MywdzQcD2SmD/SqSVCBPbJriE4ip+mvG1T4QL1ggPsEJwDuJreupArRrHIwEhCDxGsrZqUfUTXQB5Ck338/1hy0ImzGSDM7QsXYHrNmF//VO0Kapj3hp0gfNgmzSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvTLEPO7rNdWcXoWjMeCKaTxG05tfAfpZ69UNEp5nRA=;
 b=nx1iAiI7ECA2A0hVYZG4TLybxTphYNcXvWuX5j9ZXjZelvfp5X7DnJoCcdi2yL9IafOPD04MKytCdzZ4AuuevzK768F/APcP0M8ufk4JlIDj3kwveDm/1CNoX247ttkSoaWBb67WIjTDWojVLkRhO49gw0/8Vd73LFEvE2Lytxq2m4d+vv2RyLYLTGNXH6cEU/rtpjF3BWYPTCpZuVdwXfJLpjEo/8s09FsMTbjXhIHs5+5467idkQWGaneRcyIsvjjr1BaWBWfT+JQ+TF/ZDQOunjplWdDmtN8iGJA87QyqotJ1b1C4v6kVEHNNAPHN+JA3lvcSYi4qbf0r38b/kA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8453.namprd12.prod.outlook.com (2603:10b6:8:157::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 14:35:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:35:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 10:35:15 -0400
Message-Id: <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Balbir Singh" <balbirs@nvidia.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com> <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
In-Reply-To: <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0098.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f94012-c562-41f4-51a3-08dedcfe2177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|921020|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qTx3101jxFmwJvDGXOLYhUL5bHVFUQJcA3sdI63sfImrMdE6rRCD57JI6Exruj/cPJybLBkdYVh7Bdz1YHFCop8elAhRgR49RFVH4nYcJrSOMi/d7GkMU92hDXh+zC6bQTcUYkMgpOEh8rmEh138gPdU6fZqXkgrpAnPJx72FDh4xl8wEwhpXRPaGH9/KKKkT3/Rn+RrVnnyEtzYGEV4lLWmigcwAWljTpbLMDtDFL6Vb8Ma7xDN7Cn237JW1xVXll5RQwE6e3p3vYraKVJYaupqRm4/O0U+XuMa3PjFXihhExFAlztZOwT+9JnnJd0y1dg61Vo+VtP1VM60Z519EUM6D6uJGxS7WXFGVxVfh0QZLtIgssBJf/w/nCjBaHwcZ4wugZcPT5nN1KnEBuNl+k43sDK1ejKghQP8UXOKc2QBpNrnEd0zF9Wh41ivdV+AI+aDE45I+OoDHgA6BFOEmdMcRZ4mUVwU4LePx6w/0FtQ+Pp3wOBB+5qFMLbYdPb2eGQd2ElKFqeg+r2E7+ShlAiEWo4lUgFpLtleAQ19l6vrGgwH0Yhg0H0vJKYO0qWKdjl2j6t5QAduzaVVVb7NQqbjhK7k+anmdaZmShPeBLvRHn0DxvJrp+JsPzjHNSp/dD09fsHfF5mKPwiH2WKH9S7QY9bSHa67WteKhj5Yn/p520TzijnTiKUwIq+Wf2Y0BzC5uMEAobUdYd2tYV4m4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(921020)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU5BZHNCdDVGcG9Lb29DSSsxR3VHV1R4RjJLTFUyM0UxMk43UjdIZTFudlVF?=
 =?utf-8?B?QzdTNVZkb0UvQjhTT1ExTVlEajgvbjljbXdWckR3NnFxcnNuZ1FhWnVnSEQ1?=
 =?utf-8?B?cTdnck1kK0tMQVlwWkh1aDI2Tm5uL1hqZ25OdENrT1pTSVJGaGgvVnlyU0NO?=
 =?utf-8?B?SExXNFpUNU8rRjgycGQzZmFuYVNad1FWRldJaDhXS2pxZHlTSlBiNmV3bElO?=
 =?utf-8?B?Q2F6b1MyRGlEb04ybnhrVmQxZnlSaWtpMVdiUUIrQ1hkSHNmV2NYM2FwdEl4?=
 =?utf-8?B?Nm1pd2pUWXBsNEY1WXowb1dkVjRoL1JsY2k3Q2lCaGZwQXJMUUxOeitjTXZF?=
 =?utf-8?B?bzdQSFBReno5ek5qVGlQRW1uaXo2Ymc2anErcTF0cExyMnc5Snp0ZWJhOHg3?=
 =?utf-8?B?TEhPQlFTdGtuTEtocVN4M1RncS8zUGxBVGt6VTYvQzNUTnIvN0tOaFdJSEtW?=
 =?utf-8?B?TGpzc29hRzlrTVFlRmlhZWdaVVU5WXR0SHZJdysvV3ZhczlLV3IxaDRMV21w?=
 =?utf-8?B?ek5IZmdhWnlxZGNsN3NGR3BqRmZRSFZsTXlrSktzTXdaR2laaHdGOUticUhO?=
 =?utf-8?B?Q3JKTkJaaUMrZG8vVGhwZkdwMTRqMEJDOHEzUURqMFZTTkZLMExLczZZUWND?=
 =?utf-8?B?WTU5dS9UR2ZONFU5Q0pDWWdQcFJYTFpJbTdLWHNVQm55Q2c5bWF5OW9XRkdy?=
 =?utf-8?B?NDVHS2ZjaEc2eWFYcWEvQ0l1bzFUQzF5YlNDejM2bTgwVlZOL1VwQStDdTdk?=
 =?utf-8?B?RGc5NXBkV1F0cE5DbkZ0Q1pscHpxZnRkeEoxRzFudHAzV3NyaDlkcTZqUG9R?=
 =?utf-8?B?MExJZ0dvN0d4U3ZlT2JqQ085RmxrdEhnM2tYc0FFMlUwMXM3N09wTlFOYXI5?=
 =?utf-8?B?T3RQVzhPd0ozeVc4K3ZWZVd0TzRUOEh6MVRBbG9wU3JEdHZKVmNxdUZLVWRS?=
 =?utf-8?B?QXRLOEwwTTRBVm0xZXlicnRrckpFQWxrVGdsSVVjT1dvV3EwdmUwc1RWeXpE?=
 =?utf-8?B?UjBIOXpwenZaY0RkVnFCdzJZTTRST21vb0hScXRyT0dvb2d1QXZSMXp2M0JI?=
 =?utf-8?B?S2tGNDR2LzcwSXk2MzdSUzVxcW40eHdzdlJOMXl4RWZSY3VDSmZFczZjNkN6?=
 =?utf-8?B?cU92RmJ3Q3RVZmRZQTZMMVR3Rkl3N3czVlZuOU9uMHR6ckxLaFlJV2gvTGRM?=
 =?utf-8?B?ek40YXMvRS9PVU51c253YmFjc3VCRG92S09vNk1BWTA2Y0J0cStCbElHQ1hy?=
 =?utf-8?B?ZVlNdjlIcG9iSFdDb2I1TjFlcU15NG9EcWhlU2d1VHJHbzFneDZUN0JtazF1?=
 =?utf-8?B?Ukw1UzQ4Nk5OUEdZRzIwZDNPVEhXV1k3dE9yNmpRZk9YSGxXL3hpRlhvc0Nw?=
 =?utf-8?B?bkRWTUpzclp4SDdiRUp5NW1tODhOclZVSEhWN1VjSE0rTDBHd003b3hlLzcr?=
 =?utf-8?B?eDlHOFU4K0N5UnlnY080MllVOXNEMk9KVk92Z0dCenBtTUMwTmZraS9MWlA4?=
 =?utf-8?B?R3lVSFBveHJVVmZ6SmtJQVl6OUkyb1dmeGZyYW9HWkU5bCt0SEs2cnY5WnlU?=
 =?utf-8?B?T3ljNm9Wbk5YZDNpUFgzczh0RlBoV3A4NkJVdlZXN2tMSkt6OEQrVllPZGc1?=
 =?utf-8?B?cUtkQTRYRmxBVWpuNzkyZ2FHTDdMR2RmcFZPZmJySm5wVlhxY1VlOGVmQnl0?=
 =?utf-8?B?bWxCYzRrLzhkV24vbjZGaWluM0lQcThwd0lveWhBcWw5Q1Z2MjA0NVhmN2Va?=
 =?utf-8?B?dXJwMXZOT2dKSEVrdmp1VVRPejYyMmhJSFhtZENQOG50UWVYUkFEWkdJcUlq?=
 =?utf-8?B?ZUJkTHRoZGRCQUN6QW5GSjJYWWNXamQ5QTJzeVZVVEFRWmF1N2wxWmZubXRV?=
 =?utf-8?B?S3g3L21XL3pIbkhWSWFTN293Nys2TU9nZVYyOEVYbWZ0UnVGa1FLanBOSnVS?=
 =?utf-8?B?L3VFUlNnQ1ZnS1lUUW9QaFdZNDBHZTZzYlRNTHhxanFaQjZJZk5SVTRYbEFG?=
 =?utf-8?B?VUJNdUlUdjV5VDFnVm9maGhBMEdmU3Q4VXc1NE5VK3k1bm42Z29nM05BY216?=
 =?utf-8?B?bnVIZ2VzTWtlSlFlN05GdFdwem01ZHVCd2dpUit1aUgzU3dMUHZxcGZMcmx2?=
 =?utf-8?B?YTQzbFdPY0xWZFFMZVFzalhiMVNZY1JKUEU3d3FhR0VFZkVNdGlZUTZLODFv?=
 =?utf-8?B?cy9velRsVTMyRmFqZFJQOG5kTWNIZS85R1lXTlNBNk04ZHRtSXErbnVVY21z?=
 =?utf-8?B?Q2hBTm5sc1hHMmlQN3VIbmxleUs4c1ZyZXQ5ZExFa0V2MXRIT0lwZ2FiRHBp?=
 =?utf-8?Q?qfkeanwLP2NIJZ/RV4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f94012-c562-41f4-51a3-08dedcfe2177
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:35:17.6578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4sq2/WuwLs6rOYdDnGee9gdwg3fgPubloNxzg8y8xDkI35he2TK/cd7X6KiYCfyY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8453
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 363F71C0005
X-Stat-Signature: 1ma5xeqg3o1t1k1p6y8dodd98hx8y5p3
X-HE-Tag: 1783521333-515241
X-HE-Meta: U2FsdGVkX19zkFc9+CPcAR3rZCtKtnWjlbzDrt0jdhFp8CuC81Mzigm2vzBmA1prLSE/WaAirSQwyLdl4kK+0T9v3AabHqkZoHwha9C6O6f8RntdplxGrIQrznvnTI4vJxPEr4NEWJM0I0inilNplVBKFxFeEB3zAo3zF/Wu8haWla405cNINzkskOPfVTFhU6me+JpKoa2TK+eu9+u9bY9N5DXABYaYx+wX2yFo0EdmSEake7zj23DwWg43/g4U8iSf/6AWGAnJ6akn8gctD6IbqjS44qxbiy7NLLoC3xSLb1u9heRHQj4K/Ewlo7JMKqWFx3CBZssz2eFXMUAOAr2/0W6G5zFLLrEwQ7w5T8kJfhS5VsNVG5THLWhZdEe0h/ceKsjULIXa408kgemxShQaAurqxmXDGooQAqYP2pqoLXIOG2twGmCAmd7MGyd4xWoFXYXvZhmajx7W76bOagZrpxXkak1e1vjv5KfOAx6YUOjeAamAOY7RhVPg7E8YaGnbQjoTWWSjbZpf2g7VyWyvqpd8Vk5iF5+bzFsvmxxSEkrn6OfyTN5KjYxMG9InbQxqmpN4DFPOCYbXDLK+kJGkc/Nvsc6blYCddT5gVreHQGwRCjwXZy+tG1TKSUHyzjk1qjBcNnGzsJqr1o3XOVoPiJUo4finCHNYZi0tHCrCDmIt11lzN60gudGPHM2Cpsf21YB5qjAbStffXI8QPhiM9s+r8oGODqGVQp9jpav80/MBd1hGWqK9QDzNwyFMwTDPLP6FAP/l7BJCTLZCX078mI+JebvaxlPwzntN4y/UE2UtIr6PIuKbXQxJRWEYoXcOTPneA8gsyXSefTDpCEgJvAVSFnU15iLi+gQyy2wgqJ8n+MXw+sgVrlDYkiDSyWT/uuEzZI7Nu3v4NI+ZL/naAT+agH83w99Z6CD/ZSFsAArFHitOvl0txrDpW2ogIG9oigvfSr+TrT5TYaO
 n9cPVzu3
 C/E0eRqQqkPQD9jaBRvTvZh37fwIYAAoBJ0TYWcpJ9KXCOTYl3sv705RMca9BWnFmZef4MTUAbAtTfhgdMVRgszdnrEaVWyeTj7aeMtaWDiC1DLKxN/k+yaDAVrEkh5775eiPPwZxlAY3pRu1zLKiRSy8Ys6dA/ndEvkom7aa3ajHjK8Pe5ZyMYw8lcO77y/lV4vkTVR+Sh8WBpEwA9JPjFUiSKBGZ5Kf066qMyNGFLmZ8IoQc5vauw2oVs/vPYFyrOPpXptCIPoRN5s7/+ZKxvjSROr+9rzE3ewBpc6RPX3iH0wWubzp0B3DomjQ5J9kfYBczRGls6teE2TGoxPgShzy7gV5CNCVVbMRIQTLU0ni80nQWBZZgybVlxoWGmjb5rqdoP/h2qUl5BPkmjjXvF+sTrd/JyZ/ms/QRwIVkbxV7CBjcKxsSzwP+DG/+VCg3a3iXfWI3bSszZ6CqPYUC2Q+QgPuUv9LUOG85YEgZ8Yq8vLbcr3XD4Nd8mz3MnvkE5Sy9xF+WbqkuJyPtFfi8yAw++C255bgnQ5ljsEWL3K7+SMCARanDRFyldTQwDbkibhg39E3jlyK43/O1mVfpglIgtkRFKi80cYhi98p16rnWnr67MGQH5ND+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 8, 2026 at 4:43 AM EDT, David Hildenbrand (Arm) wrote:
> On 7/8/26 03:50, Zi Yan wrote:
>> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
>> restart. But the code does not handle restart properly when pmd becomes
>> huge or cleared. It can overflow migrate->dst and migrate->src arrays
>> during the hole or skip collection. Fix it by:
>> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
>> 2. skipping the rest of the range if pmd no longer points to a pte page
>>    table.
>>=20
>> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zon=
e device pages")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefe=
ng.wang@huawei.com
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> The issue is spot by Sashiko during a patch[1] review as a pre-existing =
one.
>> This patch has the minimal change. An alternative is to reset
>> migrate->cpages and migrate->npages and restart the whole range from the
>> beginning, but that also requires a restoration of no-longer-present PTE=
s.
>>=20
>> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.wa=
ng@huawei.com/ [1]
>> ---
>>  mm/migrate_device.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 2fffeb1f99694..6ceb47ec1da24 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  	pte_t *ptep;
>> =20
>>  again:
>> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>> +	/*
>> +	 * Only check pmd when addr is at start, namely no pte is collected.
>> +	 * It avoids collecting the same address range [start, addr) twice
>> +	 * and overflowing the collection arrays.
>> +	 */
>> +	if (addr =3D=3D start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)=
)) {
>>  		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, faul=
t_folio);
>> =20
>>  		if (ret =3D=3D -EAGAIN)
>> @@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  	}
>> =20
>>  	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);
>> -	if (!ptep)
>> +	if (!ptep) {
>> +		/*
>> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
>> +		 * pte is modified
>> +		 */
>> +		if (addr !=3D start) {
>> +			if (unmapped)
>> +				flush_tlb_range(walk->vma, start, end);
>> +			return migrate_vma_collect_skip(addr, end, walk);
>> +		}
>>  		goto again;
>> +	}
>>  	lazy_mmu_mode_enable();
>>  	ptep +=3D (addr - start) / PAGE_SIZE;
>
> It's hard to express which feelings reading migrate_vma_collect_pmd() giv=
es me,
> haha :)

I guess I have the same feelings.
>
>
> In case we split ... couldn't we just undo what we already did, before do=
ing the
> "goto again" ?

You mean we reset migrate->cpages and migrate->npages and restart from
the beginning? But it is not only that, since the code below also
changes PTEs into migration entries. We will need to revert them as
well.

Hmm, migrate_vma_collect() documents itself as "update the src array and
"takes a reference on the page" without mentioning changing PTEs. I
wonder why changing PTEs is necessary, since later migrate_vma_unmap()
also changes page table entries to migration entries, although
migrate_vma_unmap() changes all entries to a folio, whereas
migrate_vma_collect() only changes PTEs from the specified VMA.

--=20
Best Regards,
Yan, Zi


