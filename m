Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47387EE4989
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4966B0088; Tue, 30 Dec 2025 11:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B926B0089; Tue, 30 Dec 2025 11:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C7E6B008A; Tue, 30 Dec 2025 11:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 610356B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:46:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17E37160273
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:46:14 +0000 (UTC)
X-FDA: 84276715068.03.BBD673C
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B640180006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:46:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eOP289Sg;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767113171; a=rsa-sha256;
	cv=pass;
	b=q/xyHnPqbWVdaVJMRAwKK82zzQTAC8QdZfJ5Y0xV60snC62Y+FIzNBL5URhZ2fsCluws98
	dNJBeJy8OjbzCQmJbJMa+zUTRTRPmn7kN5qmHoEo4oYHNpc/n2BDSXI3kOadsUOT7HA2ka
	tCsC5x6ISisnPu0xuZ+FIw9fouSqdv0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eOP289Sg;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767113171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l27L8epoJcmw3kVjYD/G+zggaX6sgnau8mG0PO/jy5U=;
	b=dJEDpRW6lU3ZaD4BVU+shL5d54FwKia1gG6Xg+pNLxWZ7XMj3VtGK7afq2a6taJJWuKMeY
	VZdWh8IziNurTWoMFoz5fUad7uhGyim/0IcUDWCaUx1somNZRoQz2l3NzcFonkI22JGSAi
	YeSSjpYPAuecPqycKgy/TcgXUo7s114=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H23TxKxwKjWoMDZxG/1Q3pqRlGAevAUYNRAUXTTyGaE4Vy1O1X1GnCFoh97udWXstDerVtl0tOrRCCgBLPE1USrrvXDTL5rWvqtPSmILG6dPOqLUay4+9jaVBDekmNRFVVenGuyaVFqQda7/UVItofIW2OWZknxS6YC8fR7Dk8EFmEw+xTWILPCWNN30dfqWrznDoJn511c9XkZPwkoOCFE7cysTnO8RD46dUR7uptkH9Y/SWQBygSTUIkfjYI8zLiySwnkb2Wkiro85+9brMSTc7Viw0RC54tpOE19rfz7gVacZaBTNOtDhB8lQkMDd4VpOSEtOWM5eB1rgS6BISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l27L8epoJcmw3kVjYD/G+zggaX6sgnau8mG0PO/jy5U=;
 b=jhic4tsvCZbKHBfqHSfxPRoXLoyDxAI9Bd16IHDtxNrGrJcGgqCHVJHRuIK+KafkSOCzZLEn/A+bk3sLvi+WJqHGo65inocl1rxPhqDQNylkqGvZXf+NAtvK/kQrr4liZIIQBhX2WRMrvb4UfrEly3HFkAHrCLrN+jUExOI+O9viHwDg4nazvsY+Eq2sovTJClLsvLwz7zLCqI+iVGQpOnFzOzt3AOCWgZYBFk8hfxf3VMG9eKVy/QG+lcqTj8DlCxdhGWCTVpzyDxkvF8JD3kTuuztZCDvAvaA0E6QBXhXC6zjjrPmVaXFZLXg610CBjQlkXmHWiNKeVQLXg+sMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l27L8epoJcmw3kVjYD/G+zggaX6sgnau8mG0PO/jy5U=;
 b=eOP289Sg7/pDH696mdfMTxdryRp2tvWRWERH7bSH5zyAunrdBQwPBVu3rOHggU82Ko1ESD12Ex+zd1Pd46BHD8pa7hRWrlZN0TBJYp+s+P4OKB9pnJ2rdZjVBNF6uV2YxuUqB6QB06xE12rsItYVozImGXM2IRzp9TN/DMP10Ejomgo7kKZMM6CaQ10KL/dH6NrdynSNQZLUOfgrc6SYNgQ9Oke270NB0SvBdaP8Y4vxhazM4nMY5C8blLvajbvhHEfaquf6EbcXGLo+2wRT/C3X5OnqtRS6/KNEwfZXsPQ0kES/zoVYP/3HJYcDSd+PeK7G4JkSj/KCmwIOvGtyKw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Tue, 30 Dec
 2025 16:46:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Tue, 30 Dec 2025
 16:46:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Date: Tue, 30 Dec 2025 11:46:02 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
In-Reply-To: <krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
 <1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev> <87tsx861o5.fsf@linux.dev>
 <c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
 <krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR18CA0021.namprd18.prod.outlook.com
 (2603:10b6:208:23c::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 306bbd56-7273-4718-7ff3-08de47c2ecac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UThmVDlnNGN3K2tickR0RlBCWlIzOHhwc0tkcEkrdE5GZG9xSjZkem9jRS94?=
 =?utf-8?B?UTdzL3NKcmt4a0E0T1g5M0paT0czMG1kMzk4TlYwMlhBUCtGK1REMDZ4MVZu?=
 =?utf-8?B?V0hHR1RJaDY4TEQ1K2x0M09Ua0IxMjk2NjI4bzlXKzE1RWtubDZhS2c4V2VE?=
 =?utf-8?B?Y29oSDJYQ1dTUXQzL0hRTkRvMjhGRStlVUpDTmpIMmc3QitDU0UyZ2o0WGUr?=
 =?utf-8?B?Y1YrUHhzK1BsTlA0WHhFa3hqYUxPc1h5TDdqaVNxRC9kclprakJZTWk0VjZC?=
 =?utf-8?B?T1Nxa242Qm80V2hZZWwyZkczYUlNaUZFazZXcGlmSUg0QXZpZDlHODJQTllq?=
 =?utf-8?B?OVBNVXFhSU5CckhHbUpLL1NJTjErSDV5VGwyWm9TNTd1dEFKcDJwSG5VbW0y?=
 =?utf-8?B?R0crbk1MbGwyQ2FSbGZVQ3hKQVQ1R2RRSC9oemZqMDZBU0tIV1IvUDFEUXkz?=
 =?utf-8?B?VXd6eTd5elN4RmRJN2dOTDQzN0tzN0ErKzVzbWtqWUhRUXc5UkZhQW1CQ1V1?=
 =?utf-8?B?WnJlVDNKQVcyMzN2Tm0wYkJHbG1UQWNreHRaeVp4dCtkSm8yYmVGbXhrUkNG?=
 =?utf-8?B?Tm9KS1JibmZ2cFk1NlludXptdUpsa0N0ZGczK29WTXlCd0UxUXdTSFFUc0pF?=
 =?utf-8?B?WkhIeUpPV1FUUHR6dDJoeklwUGNwT29iQU5CVjg4UWQ3TkZKL0tRS0Z4bDRw?=
 =?utf-8?B?TWxmRWgxMDh5dnU3WTJLVDZ0YWtZMjA0V29mSm41QTROQmU3aU9ISzhTaXNs?=
 =?utf-8?B?d3J4eXo3T3pQOGtRQ2NjZFFOaWVONUFUK3M5RXVpbFd2V2lueHloWDVCNHM3?=
 =?utf-8?B?aURRMzNDbUVabTBGVnhYeEk4ODcrMkNWbTk5bXY0ZVh0YzAyYUV5aElQTVB2?=
 =?utf-8?B?R0ozWVlXRzFaeFlMYzNxYUJ4UDlGTDZ2eXMwT1ZGdXdLSW1waGNYcFV0UzRT?=
 =?utf-8?B?SmFzYmZHM2kyYmViZmZuWlhMd0owd2VQRFNlZ04vT09CeTRvZ0ZVZzRQMTNi?=
 =?utf-8?B?OWNRc0hLOXhESjBXK1BQWjlWc3JqTXRKeU0zbGtvbjBsSnRScGl1VC94UjZv?=
 =?utf-8?B?a3NraGVDb3AwbDRtTmhVYVVGN3lNMzlWZFdZNjNCK2FxaWw3WkhjdFZpY2JQ?=
 =?utf-8?B?Q2dXVitidE0wRkliNzJ2c3FHNGpaWTh4cDhsWHVLRVJyODYyMDd6RC91aXo3?=
 =?utf-8?B?aFc5aExoWGwyaE5sMHdmTTRGTnd4TVFrdEx2c3VLRWJUamd3TGY0TVd0WmVj?=
 =?utf-8?B?RktLa1hRT2IvcjE3WG1yeTVrZ2NMQzllK1U2SDJkVDY4VEdab1Q4U2pzZS9v?=
 =?utf-8?B?eWdwSGRyYUcwRXlaMEtLODhDdmozcVV3TzRPZ2ZwYmtNY25GQ3hBa3JrRVZq?=
 =?utf-8?B?TzFJNSttVUlxT1FRbHZJUkJBUHNXc1FyYVMwWFU0eEtCZjEwNWNhY21EZHhy?=
 =?utf-8?B?Njd5aGtUdFc5N0w4TlJOdE9XZzBzTXQzL1k0YVM4NzlNTzlHMW5lWEw3bjJ0?=
 =?utf-8?B?OXNIa21JaHhmV0lMSWNFYkJFVU5mbm9TUnF5clJ3d0oxSTBEb2ltWGpQR05q?=
 =?utf-8?B?K21QcHlXVHBWZ3JNa0tOQjljS3VzQjBZSHdsWHhaYVRZNS9STDZqZ0k0MW1O?=
 =?utf-8?B?eFZoUjFrT0RvM1JQaGtJcWt6UWhrVTA0T1FYTndlaXN6WTRmQ1V2QXo3NWVU?=
 =?utf-8?B?MnF3VmRwUnRVclY0VmM0SUMwQUk0SGk3aUtKOXByVFJ0RXNLVWRuUzRMOUx1?=
 =?utf-8?B?UkpUOFFad0tzSVlDYzArZTBER3JicFZaQUIybGJQTmwzeURuckduT0dNN2dr?=
 =?utf-8?B?MHZkV09vVEh5NXBFMlVtQWpTb3NjSUxOc0VrdEJTNFo1dTFaUUZhQU85dUZY?=
 =?utf-8?B?d3Zvc051ak45WnQyZlV3U0dkQ3dvd0Y5cDFUc0Z5L3Npd0JlT2hjM3N5ZGhw?=
 =?utf-8?B?SXZDN2MzSGl4akgvVjlpckE0V0Qzb0FsU3F1ZWpwbVhQZ09uQ0xnZHlVTldH?=
 =?utf-8?B?SW9ONkYrRHZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWJMaW1GWlV4Z1grb2RsRUxsa083ckl3Z01kNzRoRDlFZjJxM3RQQWZVam5X?=
 =?utf-8?B?NURWTjRDejJCV3pRbDFlUXJpb2x2OUlJSEtKV2ZMWnBrdHEzeExYa2o0YS9X?=
 =?utf-8?B?SXJuY2pCV2lHSEFHMUMyTnBlMERIdUZPMVVYU3lab2RyelpzRnpUTjJDUGda?=
 =?utf-8?B?QnpVd3E0REFPcnA0Z3RMWDQyN2ZDV2J2UkRYTWdwMHlVdnlBN3ZtNGJsL3ZH?=
 =?utf-8?B?eUVXMEFQK25IVVVtUGp3RVkrTFNqVFJCVWZYMllyMGpRaTlJM29ZMmhheDlC?=
 =?utf-8?B?WVZOTjJxWEsrc3hEVGhPcHVCL2hoNGlYeHpPWXBJb2h6STdJdXNRb0taTUoz?=
 =?utf-8?B?Qm1PZzc1cEZVTXFFOTVYK3ViMXo2WHpOTjFYQ2k5akxUQjVZa3NwNjU1V3Ny?=
 =?utf-8?B?YlJ3SXUvVkpiYjNuQzhPREJabyszN041U3dJZ1JGWk1vNGJONHVJcDJvRUpT?=
 =?utf-8?B?dmh6MUtTWW1MTHA2QW5Ua01RS0psaU9mTHc2QzdZS2I2YnFUTW9CUUZYSXZo?=
 =?utf-8?B?MkdUQklGd1lnQW9uczBIdFc1eGZldkVvRHJvYXFYM1NjMUUvUkpFeWNTOER3?=
 =?utf-8?B?aWhHTmVyaXZXam10RExOb24vR3FCc0ptcUk3TjVtMHFYbEhIbDFlSWt6STNY?=
 =?utf-8?B?dVZiRVJ0VThpOVJ4YW8xbXkzd0cyWHN4dFh6WDNIb29jMkt3dE9sQjg4VE5j?=
 =?utf-8?B?dlYzdzV3Y1MwRGhYVTNDR2ptUGc2MmlhNTlpNWVHcDBreXFwOWxGTFAxeWls?=
 =?utf-8?B?QjJFOW83Q21ocVQxdzF5eGxyd0JmK2lTNzBPcmpBMmdLRTRXMnlJWCtFUkRt?=
 =?utf-8?B?a0dFR0tRdzc4bU51U0ExbUo3WXZwcnFjbE1BZ0cxdVlZbkxiOVlTQnpFNFln?=
 =?utf-8?B?MmNyNk1Fb2l2R0RoUFlYSmJxS0dKTTlIWGQ4SUNCNFRMbXNYWFZPc09LamVQ?=
 =?utf-8?B?MDFDQmtjVHRucEJ0eGg1T2E3MEl3OFdXNTBEVzJ3dmhzb0E3K0sxRWQ4Nmlk?=
 =?utf-8?B?d2hoTlZ2aTRIaU1Zb0xKc2RXY1hOMFZGL3F0Ky9YSXhaVDFWZm9pVXoxRy8z?=
 =?utf-8?B?OENrU1hsNkFPVVdaaHg2VllvTjgwdHBvWFVjbUdPQ1NuT3Z5OEZYS29mS0pn?=
 =?utf-8?B?R1E0cFdoMWo5UFVHMkRXeHRnbGZsbnB1VlhiS240OG9IcFVTeDVsZXZpT0dM?=
 =?utf-8?B?bTVuZHpNM3BPQnFLajdvRGxQYXVYMWtKYXBvTFY4WElsL2xKNm91aU4yLzlR?=
 =?utf-8?B?b1NjTDgxNk1jbFJzRXFrN1lqNncrWllheVMzTUdFSndPTHlubUc0bXNYVlh0?=
 =?utf-8?B?ZVNxT3FyNDV6Yzlscmxrb2wvZVcxM1ZUMEhQTk80eVNpRjVqQ0tkRjQ1NXRJ?=
 =?utf-8?B?UW5Cb1JoZm8zSmxLa1VYQUE2b2xHK3kxZGd2L3JPYWFZNm9seEV2K3NMZldV?=
 =?utf-8?B?MGdvTGNSM0crNWRqc1hacm1TelB0Z2VyMXRFSldkN0krQytyVldKU2tyL1NX?=
 =?utf-8?B?SGMwRWFIQXVEUXR2TVFZVDc5bjNqV092eXNiL0tlR0hDTGFHMlRXYlJ5R0g4?=
 =?utf-8?B?MFVaa1NDUytYTFgyVldkR3Q1a0NhdDhhbnJDUnFJK0FpU1N2QUZkVi96REYx?=
 =?utf-8?B?ZjRUdlNYdmg1RGs4M213U3NiejkzN2VkdVlTUzI2c1FRdmNsVjBGUDY4bGdu?=
 =?utf-8?B?Rm9MSTFScUNBVEw2NklocUIyaXJPcGhnQ09KcnJCdktKRTUrNDY5dVZ6NWpX?=
 =?utf-8?B?NDd3bGdSNzVHZFI5OEtsWm5sU3FueWdGZzRXclQwcUt2SjRhV1hKZ05yVnQr?=
 =?utf-8?B?OStDaWFhNWdEckhCQlNPaWZ1OXFnN0h1NzE5THdab0wvLyttVm5pZDFQUXND?=
 =?utf-8?B?TWJtcWV6OExKSjBGLzJLZzVJTGQyTmE2Z0N5WlQyNmxjV1pqNnRmeXdhUjJh?=
 =?utf-8?B?WVpkOVN3V09oSWZsdHlLS05ZK0xKTkRPVzVMQzFPaUF2TXd3amN5VzhyM0cz?=
 =?utf-8?B?OW9IaWM0M0pDdDFMYlhlVmNlSDZRd2ZBbEI2dEZqUHE3eU11eWo2UzU5UERU?=
 =?utf-8?B?VXY0b29zYjVIV3k4L2VPZFdkUHNCSnRwaHFVckxXL2JYWGJiME9rd25oUmMy?=
 =?utf-8?B?WXhFYWhTYXZJb2NOY0pUMnJPdnFlbVBFTXcrVnlOYWlHUDBGUnpKME1zUDNN?=
 =?utf-8?B?RG9ZanBYZHFsZ2JmekhJeWRSZDhiWXNrMXFFTmNsVGZhejRERWRtMW91ajdO?=
 =?utf-8?B?VkVubk1UME1Jc1hIdVA3bGtpVnZYVnZvZzBjeDFGT2RVaS9kVUNCM1VGY1RZ?=
 =?utf-8?Q?UUZ+XVupTyS/ZWLOwf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306bbd56-7273-4718-7ff3-08de47c2ecac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 16:46:05.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQJ9w6wlqJwwQTJBPRQ67/otmYS94AVggkrvKyL7/kyUtP+EdMhx1R0EYNT8ervN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B640180006
X-Rspamd-Server: rspam10
X-Stat-Signature: pj8g97fcy1o94kuksbf3qh7ernms7ua1
X-HE-Tag: 1767113169-781769
X-HE-Meta: U2FsdGVkX1+ctE/mf/3iZQWD/JUydmRcIXysVBvUPeQ+lKGYQR7NWTo7L3eJw4EpIENRISPRHZypv/E7t/jDF0MnuAijZqRqFueSNAR8Rk3BH9B+CwvVozB5NX9rP67bbfdE3gNn6FfEz5E4gih+TFhNluMU02UP7y2o196o+7ZXEggCqhYbRP4f4bkVosJdcv298dfa9SXSoR9eHanjG3u4QhBgnL1Y7+FyE7CdY6yMHwqZu4dBZE/MIBYmeyK4ohVTk+fVTCh/xgUmd0VNyGJ7RcqBlYJAuCzjM/GCTlTpjTE2elRij76YLrrn6GKIi+x8gTR+dMawyi0PhOGAV22D5OrKYEm3mIb96xgbZKI6Ir6yah3VXsi7TbGvKuzOKUN6v7mYDlKUjAl7pn7QsY4ZZVR9jx6nACZP2dgbtJJo3zRJrJA6Ljp6518pPeAa88U5tVbLzgl7Imh+sZjlSnA3ll9UNOMJohbis5GakoVmeEhivCOF10ktdNbpZufTkIFV4Pq7yBaqebbsspHlNhPo1poCjCe5c5K1gwqMM9XeXTH5kBmgUNleRMJnVQKTvJ8xfdPNHLpkYEc5Ma+mJv9+0whnfnxP4Qbfa8X3XKlkwQAubawSjgaruzvYPvHAvceWsGEbgWARgJYxcEy7TLfDgeFclgvUQq90lYRe5l5A1nrCUTEB8hVIH4hb6NtqvBs+lH1xe6yQTCduagzpGDJM3du5iE6ay6N4f6INNRxPXLoATawlHbJ9OltuwG0IoIOU3/miaRbQA1PKJ+uT6tjBysveplRhstD0M8GNZjeX/yjtxyuW+GnM43/sA9zLB2geV2zvLLt6E3nTnkU7c+GOf/87WSH+YwiX6sj1Pz9m6oHW3yxia5+jq3epKxp7XIMbUX6Z+GkKLMebV0TOwUu2aS258YAj1b00PoCBNYQPQAGVbI4QP+WuYj1C5RNs6dYSyfPRZI5Z0DGPgpr
 ZDxmi35F
 9j7xktiWBqRvHvIoMm7WjmzA56cfqpKyMWIHW1faxORrKfu21AHqMisq9jxCmm5jyXDOe+cLCZzdBOECkPA+b5FWaS8SNu95jDrPIrrokPXf3DlQXEAg3dGXtHzuK6pl3RNjIoPEmlV+vjECXWn28CsCQ9t03S/iRk+jMcWllVp3lkpegVgznvcXnaBzciPM8ewXXTDgPumt336rcE9aCNOEb9lWeN/rqWD7c5P+2lNNaDIQs4UpSQxjpALeJ9dsg+8fNQnbq/LMAVbzs44/3WfcTdr3K2+Lh8AkKp+BPnReW86F1dIRL8cNqDFuhD/M5PHxDB1YXCb1PG4dzoYnoAb9udl4EfNVsNIzoa1351/uKRbSUe2CggWSvmhwevpO1EY1G0R/99dLOOh1gFJpi1djRkJW+Y7x5T+hYhOEYez5Ja4Mi096JbqZLS15lI8XAuupPnYl2s6j8QNs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Dec 2025, at 23:48, Shakeel Butt wrote:

> On Tue, Dec 30, 2025 at 12:25:31PM +0800, Qi Zheng wrote:
>>
>>
> [...]
>>>>
>>>> Thank you for running the AI review for this patchset, but please do n=
ot
>>>> directly send the raw data from the AI review to the community, as thi=
s
>>>> is no different from automated review by a robot.
>>>
>>> Hi Qi,
>>>
>>> I don't know why you're so negative towards it. It's been great at
>>
>> No, I don't object to having a dedicated robot to do this.
>>
>>> finding pretty tricky bugs often missed by human reviewers. In no way
>>> it's a replacement for human reviews, but if a robot can find real
>>> issues and make the kernel more reliable and safe, I'm in.
>>
>> I just think you should do a preliminary review of the AI =E2=80=8B=E2=
=80=8Breview results
>> instead of sending them out directly. Otherwise, if everyone does this,
>> the community will be full of bots.
>>
>> No?
>>
>
> We don't want too many bots but we definitely want at least one AI
> review bot. Now we have precedence of BPF and networking subsystem and
> the results I have seen are really good. I think the MM community needs
> to come together and decide on the formalities of AI review process and
> I see Roman is doing some early experimentation and result looks great.

Do you mind explaining why the result looks great? Does it mean you agree
the regressions pointed out by the AI review?

If we want to do AI reviews, the process should be improved instead of
just pasting the output from AI. In the initial stage, I think some human
intervention is needed, at least adding some comment on AI reviews would
be helpful. Otherwise, it looks like you agree completely with AI reviews.
In addition, =E2=80=9C50% of the reported issues are real=E2=80=9D, is the =
AI tossing
a coin when reporting issues?

When I am looking into the prompt part, I have the following questions:

1. What is =E2=80=9CPrompts SHA: 192922ae6bf4 ("bpf.md: adjust the document=
ation
about bpf kfunc parameter validation=E2=80=9D)=E2=80=9D? I got the actual p=
rompts
from irc: https://github.com/masoncl/review-prompts/tree/main, but it
should be provided along with the review for others to reproduce.

2. Looking at the mm prompt: https://github.com/masoncl/review-prompts/blob=
/main/mm.md, are you sure the patterns are all right?
	a. Page/Folio States, Large folios require per-page state tracking for
		Reference counts. I thought we want to get rid of per page refcount.
    b. Migration Invariants, NUMA balancing expects valid PTE combinations.
		PROTNONE PTEs are hardware invalid to trigger fault.
	c. TLB flushes required after PTE modifications. How about spurious fault
		handling?

3. For a cgroup patchset, I was expecting some cgroup specific prompt rules=
,
	but could not find any. What am I missing?



Best Regards,
Yan, Zi

