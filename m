Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD1CD73E81
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48DA6B0089; Thu, 29 Jan 2026 12:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09A26B008A; Thu, 29 Jan 2026 12:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB306B008C; Thu, 29 Jan 2026 12:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0526B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:33:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 306DBC0C3D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:33:37 +0000 (UTC)
X-FDA: 84385698474.01.6C8A85E
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010057.outbound.protection.outlook.com [52.101.46.57])
	by imf27.hostedemail.com (Postfix) with ESMTP id 35C8540011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:33:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Efm6Hdh+;
	spf=pass (imf27.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.46.57 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769708014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lIvjCwnlDarIbMK8STpnFZcCEukaUcdMj9TM+iKW1w=;
	b=XCHkb0wlNnPXi9mlrXo1JAyZ3GJq1CPjHXolyy4lHU388nOGhRkpadE3ziBgXH+Q9GL/mO
	Jgp4GBs05LSkwvvyl18suuYb5xSR7H3KH49KDNs4vj3Yi8qeX89qtgUnfrG4hHAZ3RFd6t
	Xg80KPa4lbaAVbsNLVSwRH1D0oV+Bac=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Efm6Hdh+;
	spf=pass (imf27.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.46.57 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769708014; a=rsa-sha256;
	cv=pass;
	b=jGPBTKz3wnRGKru/1UMLvOBi0WIKf5pFBCR4h79Z5Sn0luLNqSC9/qazV+5PC6GfkSfeoi
	RpzTJWT36I0VF26JhIiYOx6nOk3s2QOQx2TtwgNYYqLkw06ydDz7MGup779Ih9VN6R+FB7
	vXeUU1PvqyQqG1SsNGxt1IfKSVZPxsc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5ugNHNsWfvt/IIhetInAgEMVOWEfhs+VxgDUpZQPtKeSqDzoWSZ2vK2uMdxfvMvgQDKST0uU4SY8GQeZFrKMc+VxW9lXfCq05Fwkn+ROqMkJsX2ZkJSqPkw/Hriee18WVj9Rkm3aUwcHDnuZxMQBLqNMoqHbxD6QyaiBKdr2XAXfSK+k95GWYlRMft4kEElwFr53BK0eLP55lWLI099fH4EoaJISQjtyd8TNfdL53arg6Be3Y4WlMQxM0HhqgC6j2iF67Pyqbi1CtECGgUhCjQwFp92edUeiZX7L29cCW8Z2NKk/RqFPZN8JK3lHrBnc326ZaAY2+/XiruW9QHEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lIvjCwnlDarIbMK8STpnFZcCEukaUcdMj9TM+iKW1w=;
 b=HmvsGOLtPsluEUAst1BlWsd7xK/aEDJCf/ZwRVjbPakNP9+vIpaYWVGYOxsbD0WMQ6Z+EMsRUAdioeVs0hB747vu40aPZf5Zx1hz3hJHy5NJ7z7I8s+vzVouSS/a/P4QiLpQm8Q5U5spmtwCZu9xuZjqJO3nzA14YJ24Eh6uZCErZLwGqlD0SGrvj09JEXsKYNfxoe41g6wvdHZzrDl/6Wvky1KZOjywEAvbWI6Zry7yqov7T1WzDaeoc+gJJYKgEMajh0x4PcX001rdKJz2g9SGmTqrnNXzmKOiAppfuYNZs8C8Q5Cn/H370wOFHUl4sRDC3aBHvCJliJb7RS1F3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lIvjCwnlDarIbMK8STpnFZcCEukaUcdMj9TM+iKW1w=;
 b=Efm6Hdh+fU5jnxkFi5HdRhk6LmMHLbLwTtm9SRy7YZCv14IJSElt/Yxi/2gthxb1X7o7jehXK1twwAC19Hisq86Y0o80Ay+akQk4cASRJHG0s5J1w5POVPrtq4jeh6ob41kDvi/hcY2ttBVNKQoV2JHgRufx0f2jXwmNg84P+jo=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 17:33:28 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9564.010; Thu, 29 Jan 2026
 17:33:27 +0000
Message-ID: <097a4980-9d10-40d2-9667-d07bf19e7b86@amd.com>
Date: Thu, 29 Jan 2026 11:32:37 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
To: Kiryl Shutsemau <kas@kernel.org>, Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-3-prsampat@amd.com>
 <16aa84a9-83ce-4748-bc73-ccf5cb6ce376@intel.com>
 <aXs4DTXCbI_c0JPO@thinkstation>
Content-Language: en-US
In-Reply-To: <aXs4DTXCbI_c0JPO@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:805:de::37) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: a74230e5-e669-48ca-4b39-08de5f5c8334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEV5S3FZSGxrY1I5WWx2WXlaZU5RdldFNmpNcW03Ty8reEx0dEtKcFd5ZHUy?=
 =?utf-8?B?NHJpeWxSeFFwV2E2Yy9FSy9HbXhDL0FaNXJWN0xodktJSEVIWXFOVVM5dlp0?=
 =?utf-8?B?d3BqYzBjdGRIZ3hSQlBXclpMcExCMi9Tb2x2WFppbC8xVjJkMU9UbURHMVVw?=
 =?utf-8?B?ekdxa0xJV1kxYnM5TS9rbXNhZVBhY05uTWxNQTNjWUxSMHFMUkVLK21YOHAv?=
 =?utf-8?B?OFlpN0pkNG1ObnlsQm1teTA5LzJ3WEQ1TC9wNjluVlF1d0ZYNGtHRi9sRlNz?=
 =?utf-8?B?RVZsNHhwaG1HVU8xZTMxY0lDamc1Q2QvU1d3L3pWeTcwNDk4Y24yMmNKOU4x?=
 =?utf-8?B?N2hUQzAyMG9BSkNUcHNBMXhiemQ0MFJZcWRjMkx2TzdKNHBoTURQQ2VrQTNh?=
 =?utf-8?B?N1VPZTRBM3hkTE5wMkhMTnM5bElSYk9PT1p2a3h2OUx5K3JOU1c4OW5vbHg2?=
 =?utf-8?B?ZjVQbWd5Y29iMFhzWnhkb3JRWjlxNzg2bmxESWJFa3U2SDAydzZUNGRuWVlX?=
 =?utf-8?B?WHZwUUIxZTkzZENzNzQ5ZUJTajhkUW5Zek1UdTlTOFQ3SEovVDVhTGlIelY4?=
 =?utf-8?B?UlNLbnl2VTMxODM4WWt2c1h5bmZ1NUswYTYrZVVCdXJWOTI0S2NpcXhnVWtn?=
 =?utf-8?B?NTJQZ0xtZWF0b2tnRE1jMStMMEV4SW5LUGlxODZvRVVBaXY3U2Zmd2gwNEF3?=
 =?utf-8?B?bjVmREVib1ZxOXJSMmxiY3R1Qk1OMEtCM2xFMkdQWS9yQ3JLSGoyQVpsY1FQ?=
 =?utf-8?B?RkVzeXBpVGIrWHdPbkhoR3FBMnhzNVA2YTBZWTgxTzV6SG5jR09HckNDeEVa?=
 =?utf-8?B?WkNSTmlMZjJVMXZaQVdDWXV6c25qS00venFKRktxeVpaczBHRDlaTjVBZ3JE?=
 =?utf-8?B?TnBiZnVvT1llY1dHeEZLbDJ2aXNYWGt6UkVKanMwVlpsQnQ5bkV5TTJXVDhU?=
 =?utf-8?B?eXZnem5oanY0QWNaUXBRRVNXZ1lVSXNPTHgybk9XSVdXSEJaYnd0YnFSaGVH?=
 =?utf-8?B?eXkyYUwzdjJ1bHNCZHIrcitXV054bGs5azBCOEhzRkdpQ3l6Vkl4OEoxVEhB?=
 =?utf-8?B?WktidDJJMGdnWlNwaHpOZFp0U3Vpa0tzcndwbnl2citnM0VWWU9UT3dmazE0?=
 =?utf-8?B?ZzkxNlg0amJHdnJTcXdYS1VEZVZNZVpab0c5STNHeEYzbm5mRFFGWkhNelEr?=
 =?utf-8?B?MnhwenZzZEtCdTN5bUxQdWlRV1FOcTZ6dE8vV0NKTW5pdGVlWTByNHZFTFJy?=
 =?utf-8?B?b3dpYm1ZdjlpWlBZZjFYQVRZRGlxMXRHKzVDSXpsdUFwbmZXU0N4dGYrV2F6?=
 =?utf-8?B?RHZTcHdOU0R6MWFIUU4vM0RuZVV0dm1qc2ZnYzF5dVRKMVVGV2pod1pmd0lY?=
 =?utf-8?B?V0ZRNnc4M1cyMlNkUjk5N3dhMG9vcnNsR212VVk2VE0zUFVvS3V0YmRnYXo1?=
 =?utf-8?B?VVd0bVdDSStXRC80MmJmYW1UWDdaL0IzVmFrZnVISnpDT3Y5eVJqeUVacVZm?=
 =?utf-8?B?Wk50MEl2MWkyZFJFeEJMbE5VTmZpeC8rMWV0dWV2aW5sVE5IVlViVm8wZ2lF?=
 =?utf-8?B?Ym80OVkwRGVsanIyR2tkN1JCa0ticmRnemJKZk10UlVITi9QSm5DRktMN0RY?=
 =?utf-8?B?VFMzN0pSVHpSSXlEYlI3OSs5cXg2YXZxRTgzdFMvRU00NHdvUnc1MmlmczJq?=
 =?utf-8?B?L1ZXM2Q5a05lem5NaHJMRXMxRWs1RkVCWGVBdVNKb0ViZEJkVTNZSWRRNEE2?=
 =?utf-8?B?dHBRNlpBNnFVVnJtMGp6Qm9MLzE3RitTemthNDhrVnd5N0FpM3NmWkNtdXls?=
 =?utf-8?B?NW45REt6ZmNaKzVGT3BVT1NhTDFieEFKMlRTUUl3TmFxL0tneE5rRlJWTGJI?=
 =?utf-8?B?NzI0NHBVa0l0WGhVczY3N0h2UUl0Q0FVZ3BLZnV0NnNNdDJsSTk3VzhlR2Vr?=
 =?utf-8?B?b0Z5Q2pyeVczYnNaSVd2cko5WTFyUStkdkhVc2JVMHl6SHFDUTRkY0pZa1Fa?=
 =?utf-8?B?Tjd2c1c4N2N2SHVMd1RhTEo1V2puZ1F1cVpwdnUzbUhNdTNVZ2ZteVN4Wndt?=
 =?utf-8?B?N1Nabm91V2x0MEJxdStYWEZGRERKa1ZtY1Q5b3ZJUzEzbE1ZSW44a085YjVw?=
 =?utf-8?Q?UH30=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmYxaHp3cG9QZkdSSjBEQkdlNlVmanBlSzlDUm9VUkVJK3FCZVdETkg1ZU9j?=
 =?utf-8?B?TmZxUWlGL1VLWlFDa2xiZWpNN0daaTFGSGFXNHJ4VWRnRnNHTnIwUENXYVhI?=
 =?utf-8?B?dXV0T3pNWCtSVzRkaGJQRHZIU1FFVklNby9tQ0FkUzFXWGhtQmwwVGwxL0Y4?=
 =?utf-8?B?R1RHWGJoeFRZTWc2K1dGak4vMXVzWWxPWHlqU0xlTUU5V2h3LzhkMkNSM1Ir?=
 =?utf-8?B?b1p3UWwrMkU4WHJra0JIeUsvNEhMSVJyT1V3L2FaTXZiQTRkNWpoeWkvUlpl?=
 =?utf-8?B?eStvQWk4SURURlVVT29zVTlBRmNkRnFBeGdNQkZBeng1MktReGltOG5MUHJS?=
 =?utf-8?B?TUlEMXFPenQzQ055SkZZNEVGNEhaOGNGc0Y1Mm9ORlhOTk80Z0NvWkhqdmNa?=
 =?utf-8?B?RCtLMlpUU3lBYlc2TldQc0ZITk5aRnN0MEphc20yWERRN2NJQWgzY0xUNG5l?=
 =?utf-8?B?dm03dHNKZjgra1hnN1FXWW5kQ0UvL005VWhPeVB2V210S1VTTnRtM05FK1NG?=
 =?utf-8?B?Qm1CVlR6eTFtVi9WUjF4c0NNc2FrYWJpRXRBa0QxWFFRc2Z0S3pKWHBNQyt3?=
 =?utf-8?B?WnBXTXJ1em9mTjU2bmcwSXF5Q0NyUnAwUWFwNHV2Sjhwd2xSV0tWS2pFZVdT?=
 =?utf-8?B?U0JiL25lRnBzQnliSC82TTVpVTBXZWl3SmMyd3NTWi91VzZyeVZHZERUalI2?=
 =?utf-8?B?RnJGeUoxRkx3UnJmV0RYaVN4dElkUkpXdmFwdytnUGhydnJ1OXVIMGlxYUI4?=
 =?utf-8?B?bXZ6NG42NmY2b2UvcElCRHN6ZEpGV1VNZmJvYmpGaGk3SFZ6VDBZWWJGVC81?=
 =?utf-8?B?bzZad0s4WU14NHBjd0FKeFFNbVlzWTNBNmRVaVJnYmpEQ3VRQ3lZbTc4Y0tI?=
 =?utf-8?B?aGxsQkNFTVdReGtBenJSUDh4VlNiR1YzSndXcHdJZFlNUVdOTSs0blhiMFhG?=
 =?utf-8?B?aE9Ea2VlQ3MwRDVVUmdjenZyV1ZCeHl4T0dBTy9PWjlLZGRWM3ZEc3IvVWhH?=
 =?utf-8?B?R1FMMDNZdmkvaG9xT043U0Z0NG93dUlJTThMb01EcVVPYWJMSHBEdjI3MElV?=
 =?utf-8?B?OFh1QWdLbjMzVlozRTl1SWNWNWQvaHBEWXVjOU9IaWhFMS9QV0orQ1FhK0V3?=
 =?utf-8?B?dFFlblkyNForRWdXY2Q2NjJlNlFzc25TNEU4QXExOVZEeDIxZG45cnkyWEV3?=
 =?utf-8?B?NzlvMm1tUWhhME9UQ2hiQXlRL3lXa1VybnBiY0FrRkdEU1hrYjJqdnZ1OGtK?=
 =?utf-8?B?Zjh3VmtFeXFINDFESXVRa0I1dS8rU1Z5OFJIVytHSVZvaHJhc3dMYnF2VXM2?=
 =?utf-8?B?K01SalgzcGQ3eStsVW9mclhvNkVYdWZldXl5ZzkybzBJNjVZL21XandFUS9k?=
 =?utf-8?B?TFNoa1pUL2EwWDNPTzYybGpPRFd1T2EwNkIzSnlEVG5jaDFwSkR1cGM2Mmlv?=
 =?utf-8?B?VW1vdjlLUUZVYUcwYkptMzVkMVNjcXRyTUJHZ2RwQm1IeWlmT2swOVZTNlBJ?=
 =?utf-8?B?YjAyRDFqbmo1bmdCckY3TU0zYTlFampSZmNFME1uVFh1WUVhZkN6VE53SUlG?=
 =?utf-8?B?NjJYektEWXkxVlNQM1FGNlJ1YjNKaUMzaldHR3NPNTFsMWZURlh4eFFoRnRi?=
 =?utf-8?B?NzNzU1Y5U0lzd1VXZzNJTUphd3o5bFlPbERQTXNtN0dBdzR2aEhqMThjaGJT?=
 =?utf-8?B?WUtyb0NLZURsVG1WbmxiQnBTKzlVbWlqdkRhdy9qNTd2K25mRlFyRTlaTUd1?=
 =?utf-8?B?Z3RNazNRQnc4VVNvaU0vTXZkRUJGTGJ2dGhPU3g3MHUyYUFCMGV1N29oY0VV?=
 =?utf-8?B?SnVZOHNKb3hBOWZnSUtONUR5VThZTERjV0lob3hidkYyUHp6Z2Y0d0VhbWxS?=
 =?utf-8?B?aHhsajR1UzNkZy95eW1QL21wSHkzNUdNeVduTEkvY0plZXpzRFR3WUVTYzg0?=
 =?utf-8?B?TkRiRjE1Q3VjclJTSmhSYlV2c2J0R1M5MjJiWFdiWnVwb0VJZVptNGRoVklx?=
 =?utf-8?B?RTRFeGhKSkpCNUM4U0NiQ2hHK2VrTEZydjdVSGdpRU5YR0VHVzAwWGNXRStw?=
 =?utf-8?B?NEQyWEdMS1NMUHl0ODhDeFJtWkhMb0FUTHZqU1F6SGZsYUZXRTk2bjk4dTJi?=
 =?utf-8?B?aHZwcFh2L1Z5WFcxNXRQcm53Nm42U3VLUzV0OGUyUElaUEJ2dVJEaTJGMTJ1?=
 =?utf-8?B?MGdobElpWUFZdHI5L1M4WUdaT1JNUUVCQjhDS0VGZXpMQjQ1TzBNQk1DbVI0?=
 =?utf-8?B?SW5EeHZ3dWdad0lZVWMzOWptZ0wwMThoaUZjb1JCTHR1ZHFwMTF5dlpYaXNo?=
 =?utf-8?Q?ljjNcwOzlVGFvpirCs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74230e5-e669-48ca-4b39-08de5f5c8334
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 17:33:27.7701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFcqkZ+DTamAgbvlTtR3NYYnOsmwmaxdyXwgM1XPJIA9gwK1EGkLzoCbzwWUUFIJvLhqCNnxVVSlzxGVI575zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338
X-Stat-Signature: db84e3jebctsqqw4tpothtaoz6f8r7gk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35C8540011
X-HE-Tag: 1769708013-916265
X-HE-Meta: U2FsdGVkX1/KJNCywfxmdaFStlxMYANiXXjPRFZjKBNkaKqNzsQwCN57Y70FeFyd001Sv9ZFQBC4Wd5i8WRRM8V+jDK+PUjol7Tl5aNe14wECKVIebGHDsf885gL9fFG2k9nGBxkStWgJht6nhTMDf/FDhho2HvNqhvoJ/W06HeRXNNn8Q4V1mYUZmVdoHNIKZ5rC4yHA5n3ChGhuJjpwL0u6lOyKSHx8j8APCOIfrB8ACw2t6dcNl05tqZ5KjMqtUH0L8ZX6FHNi5bCc9qN5qBVana/MFIr6pOWY9OycoVeKX3tUoy6zI7tZiEMaqPs4ESIn+wCW6fGRHJZflEbiraXBWnAwamE5G5SPOClJaLdiosgzRAO7KTg1BfbH3h5WhksQNC7jUjh0AI8Bx8rV9lGxwJIIR8wRX7z/7mjfeM4+QuCrMo9JGozfbFdJxsnXlInS3PMhs4pHe5vQypM+L83nuOJa+tCZQUDo8AbJh2+A90NnR/rjDqkAFhxGd2K8mOABCZy2k7NGRITL24sAU5FcBLecAdDcTNBlNkeBxenqMlnC9b0BQB/XxkytIp18RB3AL5o15dMguSjG9/5fW2d+RQeCqkZj9RWdoiaiEc8F/RVrm2ZFRtoOi0CwzEIR2bdfj5ewnxGeSeoi1eafzRr3MCHUOuQfnie8jAPHKhl7Yp/Dqh0UceroF+QZmNguDdvfaLgIaiLZEcfZUm/Yyv0844IFXJaQKPz4BjY7sPgONlM65lW6B9joKTDC8DNRLhq4NevDKPbnVo8LU5bN4SX/YbcBFzVfxfjk59JY9DfP60xzlx5arOEohnZfcXB9vzOsofUJu2ve3pZ8cNlxhxo34Y7gMU4vKcGKeD5DlZQWWAQCKp2WTuZYv1l2VZUneGrxL51iul4jQaPqIDYyBCR/Uzds/DbaC7UP8g1BGGBBJ2iFZsa7KIRCRbOTc1tnfaDuGkDAyD8/L4VMLX
 qCmVW8++
 +3L88TNSaEFg0ezFwrClz4bEKIxp64+bqECLOkKuAqLvjwcz0TvFKaH2k0WGPJrsQkwSmt1qutO1yMFPPk2RCyVjpX1K5nhEmFV1ApFM8HyHIY2ESqyTP10xhyUlShiGodqcmA4VpXDyWJjzaZxMbKuiGdj5TLgThjPWDNo4xvHSHth7l6DRzspAp24iiFjkB8slO8R/CFrI6Gc7qVLr+/hgp1qXpFOKMNCl8yi/P0LqS9uyqiDUKRdtHkFBrnmFxTT+JP0KHU0KuA03VCjLiBcFtvLJjI5GiQk4EP0CVJDqicLGwbX6ZCWQPynfauNXb8YMZQqiIHp25WgiH/Y7qFyoMRbhjWDF2FKSrA+4tu9z/jsaTJuLp0rmb4lCisDaR4zJe79lSnrPyritIGvxDH0tKXvNRedSI/OZejR2reF/tlhkXwavjgWlJHdMNvF4UFAL9ZdD9JOfUxLvAxRGeTYea0qb4k5xTn6LcJjkPSb+a99zgh3v5hQBBR8mD46kiPpdYnwSbhQ7BeSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/29/26 4:40 AM, Kiryl Shutsemau wrote:
> On Wed, Jan 28, 2026 at 01:15:06PM -0800, Dave Hansen wrote:
>> On 1/28/26 12:41, Pratik R. Sampat wrote:
>>> +static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
>>> +{
>>> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
>>> +		snp_unaccept_memory(start, end);
>>> +	} else {
>>> +		panic("Cannot unaccept memory: unknown platform\n");
>>> +	}
>>> +}
>>
>> This panic() is pretty nasty.
>>
>> Can't we just disable memory hotplug up front if it's:
>>
>> 	!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)
>>
>> ?
> 
> I don't understand SEV-SNP situation, but I don't think we need to do
> anything on unplug for TDX. We should expect the unplugged memory to be
> removed from SEPT. If VMM doesn't do this, it is effectively DoS and we
> don't protect against DoS in CoCo.
> 
> Converting the memory to shared will do no good for us.

In that case a fall through for TDX (with a comment explaining why) and
panic for rest may be the way to go?

> 


