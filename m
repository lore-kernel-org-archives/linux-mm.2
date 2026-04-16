Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56925F433D2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11B56B008A; Wed, 15 Apr 2026 21:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9506B008C; Wed, 15 Apr 2026 21:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7FD6B0092; Wed, 15 Apr 2026 21:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3776B008A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:11:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AD7C13B6B4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:11:20 +0000 (UTC)
X-FDA: 84662640720.24.AB58637
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D48214000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:11:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iirfZGrG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776301877; a=rsa-sha256;
	cv=pass;
	b=0VyPO2Prni422ODr3HmWVIqFlzYVgyT5Xak+g78+iE6xhAfojUoRXOPbCpwlJc0eymx1Q9
	ZvqUSSJSDlSnqKkfB9QG5yq5I4lznZ135frhkavmhf/fl1ebdO5gsjJP5Vno9A88OgD475
	YPy7vhoXVIvZlLJ1AZWvyBxeuDo0VLU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iirfZGrG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776301877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOiLQ61Eyk9aPsSxsb1p77G/ah6pqUWq11qPckXFfao=;
	b=F7iOSLCfKbKl+VCAL9tQGoD78GRlnIbQFL0+Qq+Mq8Br8Aq45zb2kWOIaqFCI7j8gNpPq7
	futb+L/o3LaP5sZX2mR8n1hMgyc5MMHFWRXjT2McBVM+bWirwroH0doInSV9UnSRofZLoe
	mnXNYllpJxzp/vJaBwjZr6SMBkjMaVU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9TUTneqRSTXIoQPeeVLmHPRFKdR+CTcC5hN6UglS9ofQike39Kl6MXAaNAt39+g4iwn0nvy0nKG+U+OMn0SvGTRQ5ub2jS/vTT2z+S73g82pP0G6Lt7sMRgCzRTy5vXDF3dgfc64iF+1kvVStRlsSuME4ruV9hbn0QeczQlstiEOHveylXNn8BUod/ZYufCIDQq8WLYDRJBFJrlmEnMYd18oML9hLP4hCK9ckfYd5XQKRTATB2iKGYYZHO8HTWRPb9GxWS0FieHDxnIfQFt55C7dVlg3m3edTX5eOJlmWd1bTXtZuYfhm1gyrpwiVbBq+PsHz7ugQUuiYDQDu/LnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOiLQ61Eyk9aPsSxsb1p77G/ah6pqUWq11qPckXFfao=;
 b=tw9pz1DIGZYQvcKXZjgfq8pZSL10VwusqchIxW4sUIfpzm/n679gn3DCnfGJTO91eJfoXo0UkI9//QRz681UUVIjBIiwmHwZZpn0NoOCdsCWkIVP91oGV6yqpqS2YLBAzwJYK0k+k41cmt/6gPMb83mKMvLQTECptdycZFpPHHg7GTnOEEdmAQBE8DKmCHIdVe8m056hLwn18oJLvsVW/s6loMOHBB/jKAd2VlpZ/E/XjQBhZ76qps6tqqLiJSNYHv6DVIdKCO/5z00t0+zgyAV6vHtALnMoEwps8+8+Bx87Y17QhAZ8UwjoxHxFt7sQhC0bLWw0xW54H7ZFB0DLNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOiLQ61Eyk9aPsSxsb1p77G/ah6pqUWq11qPckXFfao=;
 b=iirfZGrGyMWzSc4IDoAADDJWIlY2SV3WlJfed8C4qyHzVnum7embItru0BPgj4aT8rZlIgDSHPQVDIy1tYiiriqMnXASkPAs+vKtvGb7poIuTcvnthH1iaFTiscj+D1jDSafhv2F6/eO2e/Mmp71xd6kRvvI2ltAC7p7yQikd/QlJpVVIaNv03Spxao8jw6CNbrLtfHn4ycTMCDyHcXt30jKVsp8AJa1kxDxGyBVeHu7dGAJYwSxBCuEMarzFPGUU6y4HAPMRhcGYyI6ZUAcLdvh1fA488uzHrB7XGY9zX3wv8BFzs/zRtuwS+h4yPrHarktR1xL+CUXz2ahZ64Vhg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8158.namprd12.prod.outlook.com (2603:10b6:a03:4f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 01:11:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 01:11:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com, willy@infradead.org, ljs@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
Date: Wed, 15 Apr 2026 21:11:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
In-Reply-To: <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 620972e0-2e72-427e-87dc-08de9b550cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bo8IKZT/qDNmeUM9rMnxXAW74elnD+3mT40QAyBt+TmAVNHWZBvGTiO9rpxflZT/vQdMGxMyg8poSIrjHJizVGfF4hrESR2OH+8pTeWxMvj3D32j5QyfxL9XJ0oPyyfKuYDNYDS4rGoBppJSlMzSy31vbvsE7SNNsszhIRFiIBuC/nQnMNFRbq+P3zb0BhR5Y8aDPlf4ZG1CdqfFg96P0NRpr4qPVxYa09+cMoZmOXOnwqf74N8q8tw64LLpBOBEcJB0EYoSPJM+E0oe5F42JJPzEAndpbNSipSiWxM0OKjEgIpHPPSJfCnfpvZUZFUgmqebsYgKDYyggJzDXKBBSr761Tcc0rTqc27SfqsJ/fwKDGDIHHHHbOEt/lkLznuqU6EEHOKdTNjqtCBxfsCEGay6gWRPixgU6S4aTdvLMWygfjygvA1Vvx43ZwjwpwqMJ1l4xQvAS3BYP38rKxdzRoq3PFo0FTtS11iBFq2F8vBotj+zSI00s7Q5vkTPcGVlEq+NrQsKQzwajy1IQMOXsvn4QWkwi+5Kqld74IXEZ/gygl131hjJQOOCaTzbNZww/4G26h25snL7UxDq01CPCOItxSZxzDdoXQ4Fc5kmsnKoZMX0UBjAIdRLWMSsR1dbaKh63LBuWVim9hmuaLJQ81XJTwr5jT/ZExbbJwFdxbFptGK/A0WUbmes/c5HfrGO5kMp2S792IG7DNLdL+JFtTVI4qZmOd1Gj4CEXJAQeJI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUZjSXZyMVZzejdNcHpwYi9BNmp4SXZ0L1gwNzlZRUtwUGZaM2M0Vmgzc25z?=
 =?utf-8?B?N0FQVWYzTHlKaU5QSndBSllRbVl3VWprd3FmRGhkb3lkTCtTd1REMVU2Zmsw?=
 =?utf-8?B?SkpqekJwajdUQ29nUzUvcFVKbnVlUUxJdVkydkVKOGtDMDhQZFljbnBwWUU1?=
 =?utf-8?B?ekNTaVZWQ1JjcDFRR2ZwQXlnSDRCZHZRZCtEaWNhSzVyRDgyalZjelZ2b25Y?=
 =?utf-8?B?U1hnWDhRakZqb0x6TkJvT2JXdC8xdWZMVzNheTJuUGIwQUZ6ZzZtUnZqZzBU?=
 =?utf-8?B?V1dtS2RaOWk3SHhSeWp3UUtaRFg3T3FsT0o0eVV5UmJkNTczR1gxSVkxdTB1?=
 =?utf-8?B?M3puOHVzTk1ERzhac1pQbnJCUFB1U0p5N2k1c2ZaL2s2TVc3dnVBUE8xcVlT?=
 =?utf-8?B?NkY0SGZpa0RBL09YbW5BY25LaG12SWp3aEp4bEpxVXkzaXRTQnFZcHRYbllv?=
 =?utf-8?B?WjlwbW0vS0JESmwrVTR0R3RhVmtIYjVyS2xvcXlaVmtjWjRhWkQvai80b2ZE?=
 =?utf-8?B?TDVzQUM5NDVhbG10eHFzQXdWOFNDNE52cllKcnUrbDJnTS9SeFgxaWU2cEZ5?=
 =?utf-8?B?bXcxenoxTXhjdHlGWjhTUWxFemZLNmxMQW95S3ZqYUNPcmY3S0s1VWhMSlcz?=
 =?utf-8?B?SVFmcE0yUFU5NTNUOVp0Rkw4S3VQQ2g3MGZkNUFIRWdrQ2lLYlVZZkM3NGw2?=
 =?utf-8?B?dUFBU3pyNmJYSFdnVHZIdEZIVVhJcVhGQThPSDd1ZzFuR0MydGZWeXNmb25y?=
 =?utf-8?B?cGc1TFd1K1lhNlk1Rm80ZVBMaW90R1VjcnpYNEt6YVNId2RuWDE1enc2Q3My?=
 =?utf-8?B?akFodmdadjlmVWJkWm1FMDhKWExsWDJSK0t3OEFQZ0RaNHhneHRaNlBVbTlP?=
 =?utf-8?B?VUY4Qmo1eXVVUWpCVnBpeG5wYnFpTWZzb0E1RWtENVhTS04zV2c0ZjRGTVZV?=
 =?utf-8?B?V21tTzFIbjhrTEwrRXlMNVlZR1pqQk5TNCtzMHllNGh3MGJWdmZJYm10cjRk?=
 =?utf-8?B?ZEZxSkYyT2E1c1VOVWRSa04zQksxbnRmdGdxOTUwOS82azBPTFB1d0RhdXdY?=
 =?utf-8?B?SHRyZEVVRDZRdUR2MjNkTEhVeThnZm81RUFqaEJKWFJpRjFwMXBrSG00VGdm?=
 =?utf-8?B?V0d4NGlXMURZYXl1UWNuWlhYU2RQWE5PbjdzS3lLVzhwK2RPMzBNeTRza3NO?=
 =?utf-8?B?OVhxUHRSVnZDaGovOEExQ1BuSVhZTEJTNEd2NS96MDJmZVgyRTZLZnVKa253?=
 =?utf-8?B?UHVSL25rTk04UVZHVzBWVmJIMEVzeGFrajY1NGdsVXVwTDhuaHM0QzBGc3M4?=
 =?utf-8?B?enlkaWZMTEdZQzdPcFEzeUNBWDM2b09pVFBRMWN3a2x0eUY1Z0tvZFVUN0Vm?=
 =?utf-8?B?Y0JvY2x4Y1RIQkVMWDVaTUZMMXdubUhkY0tVQ3BrNGJtZ3p6S2xBZHBlS1VZ?=
 =?utf-8?B?dFE5VG5vSjc3cmZYMW9aR3hEZEtVcG94elRNU2Nmd2M4aFJxMy9LcHg4ZURm?=
 =?utf-8?B?eWEza1BRZEdnSGUrSEY0TlZyc2J6cVR4MUdKeDVGUGNGN0RmbUxKcnVlQ0Ur?=
 =?utf-8?B?RUowYTVxMUJYUU5xWngwWFpaWFAwS2R5bHp4Wk01LzI5U284MWRoM1NCVG0y?=
 =?utf-8?B?NlBtVzhuditCNnh5SmVQTEFYTHdTS09sRmxjWGJQTThzeVRqa3RkZ21iUFVD?=
 =?utf-8?B?Wm1sZmlNTld4MlJxK01xOUhPa1pqY3lLR0VwaXd4Nk9wTGplZ0xRai9PR1E2?=
 =?utf-8?B?WWV2Vm8xaXZDNEoxMzl0aitweGdZUHVKQWRPV24xdmU4TkZ6Tlg1YnNhYUxU?=
 =?utf-8?B?czFwT01adXJ6UGl2TkcxaWREVXRyeEdaOTFQTGJJQjhqdUNrb28rTnFTME5Z?=
 =?utf-8?B?YWVEL1grMVozcEZqS2h5Zm1BU1IrZURZM3NNM2tSb25PMkg5Q3VFSGtoY1Uv?=
 =?utf-8?B?cDlVOURQOVBSWUhGb0lWYzd2VFIxZDhiMXRaRVBweDJLWGdOL3UzdHhaK0xu?=
 =?utf-8?B?TnlPMkhhV3Y1K3JzTUdkdkhoWjcxNHhCMlZOaEJ5M2ZNTnRvNHNMU0p3K09Q?=
 =?utf-8?B?L2VjVitpajdtZi84aXhUY3N5Y2lmclV5eDZlSjZsdWhXcDJyTVEwdmc4UHlS?=
 =?utf-8?B?Z1Z5czYzVE9RKzBFZE1JTHE5dWM3SGhUMEpIZys2R25XejR3K0pJeWorUW1y?=
 =?utf-8?B?TThQdTdEWnNpR1JCUUI0b3VTSEIzbTNHTVdLazRRQTVGMGFkWkh1VlJJUkZ0?=
 =?utf-8?B?bWFSUTdZRVlNcmd2NFhQUEFYVFNabytpblBUM0kwaEpCZ3NudWlnVTkwRGJX?=
 =?utf-8?Q?LjQQCdi47g19LBqRBy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620972e0-2e72-427e-87dc-08de9b550cde
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 01:11:12.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SEhix18cMNpYTa6kpv3UtF9D3H5g6W6VRRgoI2x28P8Y2JusEqcTbzA9G77ck10x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8158
X-Rspamd-Queue-Id: 0D48214000D
X-Rspamd-Server: rspam12
X-Stat-Signature: odmsgcqemzfhrac1qb16zxz7nooc9kyb
X-Rspam-User: 
X-HE-Tag: 1776301876-965515
X-HE-Meta: U2FsdGVkX18+POEzgJ8SFWtJXETFNqMGeqRc3cwQ7FFSth3SCloaJz2OPz9MzWeUb1NoKVPVQRc+bTLtmcNcn5VzeCqGa5WWFwXhhK0boQDl5NS6Uex0gBiQfX/alkG0z9WuCyZlv/p6wyiRXjGxg/FlnbUwftn6S2E6AedCLrXSV4IQR+8nBl5m4FsLrc8aV32VGBbCrKz3ldyLeslfXv2u9+mzrXtjwDE2EXuMcoiMGWTGJQNd+O2/icl4ciITMvQ8M67ZCfQjrqFCyfsIchT9mF1aO9z5IC/1dM2XTPDLy7PaKkw22gm0ZiNhzMwImb2OLWA9iiZeIAJcT9b9ad5cyYqBi5gIGjg7RlgeDrEcbSAiVV0sVnMzTvNAQQjzsGFmzytxqdTUN/vA64fRmAguk34CrulE/VoxF+geMMJkWd7SmyBwL2t1ln7KyBl3gzJzF8kgAQVLKuefrZUtt4XO10Qk0OQQtQOYmw8T0oiHpS/43yh9to/zPSuPQ+CFHvxwh/1xkZ1mUn5BX3yLn90UXi3W8gLAE5ZKme+HMisiohn6HpH8mMkGVjk7tUmM8TZLMKouKyPogNti8n64p8MHfiqXMDc/Uv5fzOB5N9iN4gwTSNtqebhiBp4qT3qOk96m4s5kT4JEbBASmBS5ZC0dnxSyPDUYDC8hzNfzPUJ1YxtOMp1xC/Z/3Jm1pmZ8cuLdwJP//oUXgR8rAYg5I8CsjFco1Hnz+P3ifpZEJGWivuh9ENpE0yvhMpzFNLBJjaRF10BarOvX4NiYsoCwvFpxrdVFS0iSBRPSBYd7o3PlqWQUkbjUeJkcONDA5MI6OIPl/n5vP3cr/xRLtadagse7HjEADLAmmdncA1ZX7K2ntX3sb6MeIFtakZfRZrsPjBAiHBaaQdTESiVAuTc9TpbMl/bTCNyG5yt8iXxeDA/3xFaOl+0LQ9sxwzjQ/4u/HQhJVfRoLnq3AcBVnBU
 HGo3JY3b
 zhQA93piG0c7nKF2hZUn/jdF8HLMszpn/RRfNzBhHJ+QKM2J/DnHKGL6YXaZsO3n3oX3kWKoydrwwruaTuMqdmfSLdUzjnpQp0Y6n/V3AtG0yQMRqTfiTLb8fhUM7iPAsd5Ra7nTf4uE3dNJ3gAY+Kniava5QovYZzChrOC19kYT60Rg430UGnh0klDhDzO1HJhDpIs21BvB4g3uu3QFBWNBNgPZyIGlF9BdeDihO70wQvgKYHz+lRa9lKwVhEQwtOUIl/ZZZFxVHtvCWR2cVxeEQeek3enmhyUM4VF4+y6Nf6TxYDCsxY7Zq9BGoLBlO2zAOfisB+0eEPsDMIvmabCFpoIhZgvYf4IzEwkb5rtMeRiS8TJJf78Cyjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Apr 2026, at 21:05, Baolin Wang wrote:

> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>> On 4/15/26 12:05, Baolin Wang wrote:
>>>
>>>
>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>
>>>>> Yes, that makes sense.
>>>>>
>>>>> However, it=E2=80=99s also possible that the mapping does not support=
 large
>>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>
>>>> That's what I am saying: if there could be large folios in there, then
>>>> let's tell the world.
>>>>
>>>> Getting in a scenario where the mapping claims to not support large
>>>> folios, but then we have large folios in there is inconsistent, not?
>>>>
>>>> [...]
>>>>
>>>>>
>>>>> For the current anonymous shmem (tmpfs is already clear, no questions=
),
>>>>> I don=E2=80=99t think there will be any "will never have/does never a=
llow"
>>>>> cases, because it can be changed dynamically via the sysfs interfaces=
.
>>>>
>>>> Right. It's about non-anon shmem with huge=3Doff.
>>>>
>>>>>
>>>>> If we still want that logic, then for anonymous shmem we can treat it=
 as
>>>>> always "might have large folios".
>>>
>>> OK. To resolve the confusion about 1, the logic should be changed as
>>> follows. Does that make sense to you?
>>>
>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>  =C2=A0=C2=A0=C2=A0=C2=A0mapping_set_large_folios(inode->i_mapping);
>>
>> I think that's better.
>
> Thanks for your valuable input.
>
> But has Willy says, maybe we can just
>> unconditionally set it and have it even simpler.
>
> However, for tmpfs mounts, we should still respect the 'huge=3D' mount op=
tion. See commit 5a90c155defa ("tmpfs: don't enable large folios if not sup=
ported").

Is it possible to get sbinfo->huge during tmpfs=E2=80=99s folio allocation =
time, so that
even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can still
decide whether huge page will be allocated for a tmpfs?

Best Regards,
Yan, Zi

