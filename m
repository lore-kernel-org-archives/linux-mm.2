Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F14CD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42578E000F; Thu, 13 Nov 2025 20:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19B08E0002; Thu, 13 Nov 2025 20:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C082B8E000F; Thu, 13 Nov 2025 20:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFB568E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:22:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A9291A021D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:22 +0000 (UTC)
X-FDA: 84107462124.13.6FD34C2
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id A3EE6120007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nI3T6b7p;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083339; a=rsa-sha256;
	cv=pass;
	b=K+1LTiN6ON1DI+2t/AI+X+FvBnmBzrwB2JtCLfQo4FjbWHUvalU64ifxepP4tSHwcAma/Q
	B9DJCcoInMPOOz/+lwkZZOMocWMG3rjZj255mJSqTrS8T1jrHeuAwyFJ5gcs6HKrai0ys0
	SoxbRSsoeNrdXK83OQQNEx0h2sUMCII=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nI3T6b7p;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66i4CRJ3PMhE2+WgDRZkiWZHmo7bM+Zxj73tmVAeQew=;
	b=TWxh9CFIHgqG6Y7YEb6if9BXbfCQp2IvupCILwv59b13EpwtIO2VB95CHgpnyh8WIZ0IKC
	wExW83EGRRVhrqnf6xUV6G2UqISGmK+cNNEhHA4MPgobhdR4U8x7CN7gVcE7uYCqAC09Rg
	XYZRcyCrD8dxlKmz5eAhKxez6jaSYTY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+H4oU7tt6bFoZ2bINEJFfCERrOdqyxq2uO/mQBD/oH8oMjvJtYvr7k9F5t81Ieq/9aY2QiZS60rFY6+4hAWN6MHYc0huUokW41+3wo5C1OR8gU8PJ993/PJI0MtCMPvg6D3xP6xW8p3/1DswFJyaJ6yxu0WOddZ/5zi1qqHoDV0z5+ogq3p5ZRvxwy9THYifrRMJ0n5Q4j8azJ14+PFUiXal5TX9FzlIkPxXNt7mMNWDctA+ArFw4FmlCCFl28rAwzHFF3fpnJwQexqaku5Owvw+Ya6cDiXYbVqVW3Iu7wFwX19+lO82tT1d9mCayRqnrGR+OHksRONOBRc0UAXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66i4CRJ3PMhE2+WgDRZkiWZHmo7bM+Zxj73tmVAeQew=;
 b=dr6ZNiBjYqB5GMBiR3GcVKWsQepW0VIqxZ2YrlRGHukhYr9iydHkd114HmbiYhd1Py0LjEHdbLVlr6WnsRZ6ffJFzdTHUAfKkZ3b1JWmOD1CBdcPwEq32WD8Xz3D1tyLQXaapbgrtTkgOqeGy2XJ6LmL6H9zmx2bfpMJbwMccHLlxJ92xz8U3KD/FBr2vUJYZHUl6nkT/cFs8CMyATsPp1qMxC5NuR60wKBfaTYXfLIzI13uuazBxwJDUBKjcyuF8kXZmDaH10xZjupqf/zo16U+RDS9n/brIA5kgZ/aLpF0Vt0T1Qce4ofiGRLiGAigACzjF4ZS2RoFLxWdCMEsuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66i4CRJ3PMhE2+WgDRZkiWZHmo7bM+Zxj73tmVAeQew=;
 b=nI3T6b7pHrxmApBDwjme00IkC3SAIJKNZPKcPxWMdaN1qQYIh0m363e3fOId30FXQcuSfWOtaWZnqrDKKIBqciotC+0PWyo2zJkRMmOUfmdtZkUj6ma43GdiHx+j7MoUhpmVvHF4RNnROSd4l4K+ZiD4tEpYKxWHUTQ6kPegUGKORhewRQBR4qHWXiA2475wlcrBWqE5M+DZhFyoMxrJ8PxtNl7jp5DnPmmBkRVqZ2c4gZDz9BaMm95Zd4iEw/N/qsE50R8s165NF5OV0qRE+GEmF0RlmMJpaVGncEPfCFebr/UE/tRyu41WM4MQxZQU8xD3D8qjaTVR+lhBAZOoHA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:22:04 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:22:04 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH] mm/huge_memory: fix override of entry in remove_migration_pmd
Date: Fri, 14 Nov 2025 12:21:53 +1100
Message-ID: <20251114012153.2634497-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251114012153.2634497-1-balbirs@nvidia.com>
References: <20251114012153.2634497-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY8PR01CA0015.ausprd01.prod.outlook.com
 (2603:10c6:10:29c::10) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 3237beaf-7cb1-4bab-bfee-08de231c3806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVFpOE81Qm5VOEM2Lzgrc3ZJc0RNQlNIVkljVFhZWnlBUGFtZlovN2ZYSEFU?=
 =?utf-8?B?eUxpN3ZoMFZtR3ZqNXB0dGVKTUQ2NUdzYks0R3RCYzBBdU5hejl0NmJoMFVK?=
 =?utf-8?B?WHFqck1veTI5aEtaRHdYRHNlckpxUXVyQ0JidnlieS8zdWRGYW9ZTzRQWjl2?=
 =?utf-8?B?MjdCYUhQYUtheTdBREdGUGY1TWY0WGdHeUdTdmdvK29XNjdRSE5TMHpjYndS?=
 =?utf-8?B?ZThCRU5DRmVHOEZITzJDRjV4c3hER1B1WUNpd3AzMnVZbE1Id2tFeW5vNlRs?=
 =?utf-8?B?cDdmVDFvNERpWTZQLy9qaEVxSkpnblU0SkZKcC9hcEh3cGpxMDBqUGgzOWdP?=
 =?utf-8?B?OUlsdmkwbC9CR0d0dDVCSmdNWDhzVm9mcXcvblA4Z2xtSTRYN042Q2Z2YVNr?=
 =?utf-8?B?Uk9ZVjNMWFRwSEtKZEs5WGVDY1BSRzNXdjFaOGhDSFRJbHRsQlRJTFpUTzdS?=
 =?utf-8?B?cVZTd3dPVzlyNEZtdVV1VHpLSXhQQkxuTFFtWkN6akdaeDZsclVpNEcrZGU0?=
 =?utf-8?B?VWd5MEp2ZDkrTDhBU3ZPd0RrT2YwL21FcjlrZzN0MWxXVEpaVWxxKzE4Zitv?=
 =?utf-8?B?QVdIZ0N4Mm5ROC9KWkRUVWZRVnhWbjZDMmVuemR3RXZMRjg3NTNKYVRJRXND?=
 =?utf-8?B?M0xMU3gzWCttZ3dhaElVVTBRdDhYMnYrOE9wTnpEcVhHT0JGRlNLS2xwK3pZ?=
 =?utf-8?B?TjdZY2lWcTl6WVNqaWx5UW56WjZBRGJ2K3FxVWxUbE9Wa05qbHhqT3d1ZWY0?=
 =?utf-8?B?U1Q4a3BoR01NZ2tEM21jYkxrYWIwWktucDI1Wm1LVUFlVjFFZHR3dTR6MjZG?=
 =?utf-8?B?Ry92NllVdEtEQlFrNHVvUjFGc015MXZRNE53WEZZR1E2Y0dSVGhaTEJ2RzBB?=
 =?utf-8?B?clNKUWxMU0hPT2IwaVhjUnN0ZytTM2lXclpka3hFUlVJMHcwVU0wUmV2K0dN?=
 =?utf-8?B?ZUQ2c0VVUGRzSHppTWhDV2dXb1lTSnJZVFcwVzVmT2k1K1AydzRJMEphZVJj?=
 =?utf-8?B?WHdqdkJtRC8xRUloaVJIU3k5VXcxa3ZUQ0hmL21aaVM4TXExTFlWcURvZlVB?=
 =?utf-8?B?ellCZGxCd0xhd1N0QnBJUjBDUFplcm9LTTI0K0hzQkdqaXlVdE4yT3owdTha?=
 =?utf-8?B?QnJJbHpadWdicmYrbkcyR1VvZ0c1YTJwYjNLR1QraFhkV0dlck9KMktHckFI?=
 =?utf-8?B?QTVhS0R3d1JZZE9MNFZaKzgyWjV4c05neWsxMjRSaHRlWWJPR2Y3bHdERyt6?=
 =?utf-8?B?amJDaFRMaGxNdUc4T1kxTFlNb29pL0x5K25WeHVRNlh3Rmo3UzcvQnVMclNX?=
 =?utf-8?B?TDdkS3V6RXBLNHJpWUxwcjJlZy9INktqakEwWEFFa3NscEMrR1ZoWllQWjBY?=
 =?utf-8?B?S0NqeWVsbG9SS2dFSlREdmpXQWhMYWZZckEyWXVhN3NaTkVUeDJuUkUzYkRB?=
 =?utf-8?B?YW92aUVaTWVDSUprN3FrVUZLaGdldG96RUJ1bEc1YXBRb3NLblRUbzYxZDJH?=
 =?utf-8?B?NitIaS9lNGgxdzNiQWRMRWkzMHcyUFB1OVVjRnYzSkxOZFZXcGc5VUpjZ20w?=
 =?utf-8?B?UGhPNUdCdUxSZHBrOEc4MU5aUHZOaXFGSDVaclZ0KzVKakwvZThUaDRBbDk3?=
 =?utf-8?B?bmpsZ1QyMVhRWDhMellMYW9vK3R1ay9neEtMMHNac1pxNU5WRHlNVnRqb0xF?=
 =?utf-8?B?TmlZT2lpc2VDWEpsY3o0a2EzSXl0ODlJTVMxUlYyNzFkQzdGNnBKS3huc3N0?=
 =?utf-8?B?ME1ZK1REOXR1RU51czJNdW1qK1pmWXNNVmR4Zmd1MkxRTEpWNEVhVFluakNL?=
 =?utf-8?B?b20rckJqK2ZyTXZLYkwwNWdaMlVXTDJQdndOZmNIZGFEYUgrQzh1V3d1QzNK?=
 =?utf-8?B?RkdCdUMxeTY0OFhPMmlKQVhZNXZCUWE1ci9IMWJTT0VtVzVWc1RXN0tlbWU3?=
 =?utf-8?Q?tp1Nn/6MIDSWwkeA/iP9PehBv/AZxmHs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFkxMU5YYTZYMXFLckdJa2ZnZ3NKU0J3UTZDTkZIOHovc2Uza3FzdEZwU05v?=
 =?utf-8?B?Y0hQRk4zT1dFV29KNm5tMkpvcTVKMkpXNHNxK0dwbnFDYm5BOHY1d095V0I2?=
 =?utf-8?B?eDdEcC9Cc24vemh2UTRIQlVLQ3BiOXdleG55TG9odi9DRE1meUJEYnlML2U2?=
 =?utf-8?B?cEMwalRmWmJ1ZEhvU2NMTEFpQWhVY29kMGdJM2tZZlJRZ1JrdDNiQ29rSVRU?=
 =?utf-8?B?Z2Z2WXdhVDFNZGl4SW5hK2VjemR0RlFIMEQzSzlaMlJaek9mdkFwblhPdnI2?=
 =?utf-8?B?OTBSZ0k1bDJoYkh1dERzWlVpR2NIWHdJcUdnci9ENUNZOURDdFFPMXMwRXlD?=
 =?utf-8?B?eXZqaU5SWjNrVU9CM1NrS29MaHdPS0pXQVBVVnlNRnlldFNTRjlGUGhEbkI0?=
 =?utf-8?B?NWJKOXRNZ3RzNGlPcUJzaXFGR2xQY0N5Zm1saEFFTkp5cXpxNSs5RzZ6OFRO?=
 =?utf-8?B?SFUxUnA2WHExUWQvZHV0cUcwZkllZWhjdGFnLzZUN0lnOVRCZHFMOW9KM1pO?=
 =?utf-8?B?ZTBSenFLN1Q1cGVuSHE3T2hjdzBvVklMM1JmVTRONWphUlRibGJUS2VmVjJi?=
 =?utf-8?B?WVhlWnFXWG91aDU1bWVuY3BXeG1ObWFMcHM0ZGM1aFZjWWtqQkViRTBCNVM0?=
 =?utf-8?B?VVVPWTJHWkdlM3FrdWxaRDU4STRTWFdIOWRSNWRvUDdjNmpxdDJRdm1OTzI3?=
 =?utf-8?B?TVMrY0ZKTGNpL21sRWhJUWVlVFpiSnhDcnpQZ0I1RUdnQ1piNDhQL0dYeUFL?=
 =?utf-8?B?eHNWWWd1WkFhNllqbVg0OEQ1Y1BXTTlNbTNRVmhvRm52TEppZ1h5RytvWURj?=
 =?utf-8?B?TFNHeFd6cnZXZVI0ZTNuSU5vUi9tbW5ENDVMRXJLemRYTzBpc3d6VUpVYjlo?=
 =?utf-8?B?cDM1amE0N0FuY3JDc3RoTEJDZGlzelJFejB6ODNvelFpeU0vWVNyclJaSnEv?=
 =?utf-8?B?K1lHSkV2ZitmUkR6ZkNXbkNDUjh6V3VIdWUyaUk4bitvdlZwN2VCR0tQWmZq?=
 =?utf-8?B?NEQxQXN1TVhVN2NSc3dnSWJvdE1NTGdWVzQ2aVhaV3BmTm1VMTFSczFhTEtn?=
 =?utf-8?B?aU1QQ2VxOEdpWUFtbDNYaC9tdkNrREJINEdyV0x6TXF1a0ZsMUFmdDVnbDY1?=
 =?utf-8?B?aTA5ZkNkSjRKWFp6aDBrK05IQ0R6YTIyaFBud1BRaGk2Z1dMdmRQQmdWRWE4?=
 =?utf-8?B?MHlOdDM5N0VnR2w0dVp1MlY0WHd6dlFZT2pLRXZBTGZNZjBzYWZPK2dXWVdC?=
 =?utf-8?B?TmxXNEwwM2lVN1EwRDJHamZzd1lsM1VyVlpvR1o2RHEwaVhUREhML3dBUmtj?=
 =?utf-8?B?V214S2ZYMk5DSWExbjVKeFpzNjlIcjNqR2RjTWhna1lRNjlHRFVVajB6cWpS?=
 =?utf-8?B?RE02bFNlQWcxRGg4REJJOG9xU01yWlhCOS9WV2M1Z0pzaisxWlJjdlNCWnJJ?=
 =?utf-8?B?TDEvb1prNndtZW41TkJqQ1o3KzlCbWVwTXZrRlBrT1BZaG1HVnU1ajU4MjFD?=
 =?utf-8?B?VGlyVDFXWkR6eXZqVGRVUURFa3J4c09SbjdMRUg1UXlLeEM4OUFDUzdqRmsr?=
 =?utf-8?B?eFIyb1RuNkJFdVBhdnU1RGNkNHdFK3NkZjQ0b1ZXOEdzbm5KQjdWdnJQOWUv?=
 =?utf-8?B?eE0zMjlOZ0ZSaVRRTTIyWG16N3U3RFFVNWk2UEhMQXZsbkpieWV2STQvVi94?=
 =?utf-8?B?WE9LRFN1WlR6VkVVOEJ3NTNBM2NueExLaCt1TnZwOWFwYk83b2dZblY1dVhU?=
 =?utf-8?B?Lzc1Z2FIK1RBcE5rSSthTWRTZVNmUkFiNGlEK2g3MmFSQWFUczJMMHN3b0wr?=
 =?utf-8?B?ZlM1N2VzbHhzaTlEN1RMTHdIWVNmcHgxNUVwUk9EWDRJWlp1UlViNDQ1Rm44?=
 =?utf-8?B?THRwa1VDbzAyVUxmbnlHaGtNeURJcDNQa2pLZEU3Zi9DWUVKNWE3c3pNN1FW?=
 =?utf-8?B?MTMySEkzQzRGZ0FrWXpWNUI5Mm4wN0JGcGZ2c05jaDFZblo5NmFwS2RFbENB?=
 =?utf-8?B?Z2N6U1lkcEtDMVJRbG5ObkhVWEp5TENFVE56Nm95M3BJREp4bkcxdzlIRWxF?=
 =?utf-8?B?MDlpQW5NSUNSMGdpcEl4TWg1NG40c0s2aHY5b01MaWFtcjRVYzAzZEN0WFVR?=
 =?utf-8?B?NXpVanFMcG5vQTBrK28rcHhyTGhyUWttNWtCTC9GMFc3TkVPeGNrc1BKZjVn?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237beaf-7cb1-4bab-bfee-08de231c3806
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:22:04.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0GvU3r91KvQtfjwllb3BZ1//dlBlK6dLLKUF7qazBFDlYggAPMfNKgqjwpdLF8xuIrlCh4hMivDK3Y2RCnh5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3EE6120007
X-Stat-Signature: wgc5oszxs7doau93haaiwu64yb3gn9rq
X-HE-Tag: 1763083339-460132
X-HE-Meta: U2FsdGVkX19iOVB1qRF7eNMBEUI0S5FN7gX+l325qAtnF7ZoboGEBUndIDqXM8jAhlx6uUnx08dSIVK9OcDAwWq4q4TzKYMXkal/UbH22hU+D+Dfk6o0d9cjydVFWyFXRMc4EIQTinZd1zYk60gnxpx0xq7Gl+5ItTLmHkjmvDwd3gM1mSZJIRDiRbOn1AC8OkC6hEELCO/em04V1LiaCWzuNag4Y923bifCahoCOYIS2ZeuV9wWHclI81+2CugdtMlWix5raOX13RpzjAYTDRETa55sfZZRbbOxcUaG9SgpoezAJSgNEuRgKFud2Y2O3+SN0UkPTRNKg1KKLJe42euuaGNF6pjbPIdkOcF5wnqIwW7RVf1pfh0dAD+OqItshrbmIfliyuzJh8XiUYz19yA/bh6DUMje+uzvIEY4O5J+Im8p9sw4KihbSa0epLXBi+qBy0b3YbpmLK363uMjyQ8ddl4sphwkbMa1YuVGgJgQWymAY4E9Ee3+GVkSbACQ6+8rWHNP7tTyWUBy2cpOYV88L7PMsHdPKdhtzSdE86aSCZj/cJppZU5JvYYjKJ5EsK24Xc3XgyUH+Z4fb7NFNKfM/7aptKbOjEJnAG7CnFl7LzXuzBEzZ4A5QTQKjNk1VdAMA6UMTi+LtkG1kfJjWC8jEs0g9B1T4OUHg/msZbfYAmGhlBrikn7L2rG85rTP8ZPEiwFs8NhZZQC5niHW5SR3OTI9OAsyeCuoaR2aE/N81OQdnGNihtQh7T5dcClqw1puqSMNA2gONwDTHZgCfDQszhxAwqiQLpGaI+WYb50JiFshjx7sPuTQfxd85WSFNb0TyvyXtDsMK6fLEeBxP1Cgkx+NLw0t04Ia2cOFyHP3H5IB+3U6KXNGKiCu//WYSzaUvDnxiVv3mt/g5p7V1gdIA6k5jmry2WdlZG1uhiA2URiKYpFMkxK3Mr6GbBgeA9pSxmxE8KT5GeuMcws
 qmVHWUrn
 xXYHrTf445W5r7ta9/GtzXWN1x2G5HnENPF4D83nvIcY23RomxG7DQIYL/cuM+a9laOYDzlkMsrzJhkix85KkqrQpcmRMMGj+5YuQsgdmXFqBcj6MWCBCXQvTaMewR8iTB2/1KfYJhBRSYgSyBG6F71HroaT3+re+TyK38aZ5cUn+q00j2s0retxE3Xt/bOEEbxLR+WizNJWAVWvT+NajZv8w+YiTPy6qyvygCUMkNBRfreapwqf4uAcHPZCWLuxgOaFiL5Bge0oNfoZi+ZkgiuGE6GlJ1bbUDfVLQ95wpOKnKtf7U4bHRbQbE3/lRWQ4sVhHAlHHNqAlJHD7WxW4Auv191IU74Oz/nbjZmtrYVtryc1kfhUfjevHucOUmA8NLH/P5lUA9+/d82dXo814stAKzKG0Q0h4XRJUQ3BwsQIahsWWWwc56q6A+PNYlGL4FEt57YJgtwjjMiiirtlxH3p6SQPg7c78yvuK8IYUMATx/LRXVOCA1ywRGe/qnINPgRlYw/6wXci9mBoOM3tXOKJEsnPa/Abb0kjDvmXBnjIwQsXPCj1I8esY4pB5Pxp6zUivUY4v3DEc4W2xLYoDmOfMM7uQbLwrKCYPYq5v46h1zj33ZjlEhywe1c5FTCqQZn7DtlMAVLcyTt8+rgfMMjxKh/8MOFRGAWsPrDpfAHXtYSeQOUdgnZmqgEi2Rr+wcyU3sG9iUj5PfMYG4H94svIylJe64KYoqnFlUpcTLNXfMghjkD0BwuPhh+kZMdbramCzefc3Gh7nRc1Mhi4i2o3jOl4MJWCnLBd8cuHD7fz9rCQLd58TYxzmaz62rQ+T8QEqrJuzWZssInY8bjOvUeYbyxsvhelIddYj9Vv8ZBEpd2xJ7EvdNwVfQVD8Y+8AfZRwOssaXeievb4+03zr7gLKFqmOcRPh/JB0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recent changes exposed a BUG in remove_migration_pmd() where the
migration entry was being overridden when the folio is device private.

Use scope local entry for creating the device private pmde. Make the
pmde writable if the migration entry is writable by moving the check
is_migration_write() prior to creating the device private entry.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/huge_memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9dda8c48daca..df93768a6e15 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4698,7 +4698,12 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 
+	if (is_writable_migration_entry(entry))
+		pmde = pmd_mkwrite(pmde, vma);
+
 	if (folio_is_device_private(folio)) {
+		swp_entry_t entry;
+
 		if (pmd_write(pmde))
 			entry = make_writable_device_private_entry(
 							page_to_pfn(new));
@@ -4710,8 +4715,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
 	if (!is_migration_entry_young(entry))
-- 
2.51.1


