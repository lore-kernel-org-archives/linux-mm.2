Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8A3FEA835
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0B56B00A2; Wed, 25 Mar 2026 05:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578296B00A3; Wed, 25 Mar 2026 05:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E586B00A4; Wed, 25 Mar 2026 05:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5036B00A2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:21:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D32B81B8A8E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:21:45 +0000 (UTC)
X-FDA: 84584042970.12.26BC703
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96B29140002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:21:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Odp7fj/M";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774430501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=othJ91rGJfaNbm5EnN+LGnI73TscjzICSbG66MEUtIc=;
	b=mvP5BSsF7WOQ1BRPx/slfzH50giaaBPEf3JCkT8kmNARVe42D6BdyfxhU2iafiqAtb7ieC
	yc2A/Ls2knEJJXWB+2jXZ5vYkDrVqL2aSRPrpNKiPvp6oanj4CMGblU+cdowG0nWNsYpQA
	e5kz7G9CERTKENC/p6qsKpvrtZcJ+lU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774430501; a=rsa-sha256;
	cv=pass;
	b=w2ggBQ1snb2aBUm1xMH2Q0jgCRs/A2bE0XyA0u1h5CHnWVSAJpBpCyc14xTp3xyjMBTCDG
	4AT4+e56aPiU1V45t6tfcCMo4Q0eHpzZvmabInnj0act4pFcIKnXoF1oGLRusI8VHoezI5
	4qY4TFUYMeuSvYCm+q3RT+XzjgVb/hw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Odp7fj/M";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TYWH/VH1ji93BgpJ2NpcjBBXBVQwDt80+FNKrBt5tJQxUlM89Xn9o/e5D20LyQfoHMvLJ1/jFVTsX3Spu7KUsStn0nCoH6JQxcADbkYQLJ9RSCYnHf4A7ENgEI6eCI20Dr45CtgYugnvahBKQKJSRWfN6q2MMgkTawv+IBaFb7aNcnTQciUcUzyCHfsH3OscA2wpEKL/7q1NmCqRGmFHair7h/iG++ZguQlZDCHkUUE8IzXJ6Xi9u9pY8pGjiiry/rbn1enS7TCG5f10Qv2HmXcsiBlh+pSC5zF+ROozW2pTtbge+D6ndInE2hEFQ+rbBhAWiNGrjec9VnNTWmSqeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=othJ91rGJfaNbm5EnN+LGnI73TscjzICSbG66MEUtIc=;
 b=FMuz9Zo9Yjgv0L20BZYOheJ3vqadlwaW1fJRt3Sex8lyq9UOpuYcqVZa8/d//skkqspvxNYo4BDxG707q4C6nzKl4HvC4BGMbXFWwIsL+G4KGLNthgY7CtCVk0GoMulqjfcW8JCQ1JtTVGjFkXuyoeu0s8UQalts9FMlCjC+F6a6JmTIXtWWIhw0eDkJLoHBG74AvJupP00u9MNc3ePsbQdRfJ5qA//RVARBSAIrnjDDA8ICfnRVWdM6XDtqNldG0u9+sqDQnQ7VAzVwxAAprXCyEv9HSdx/X3EpqATCAcsN+KMna/emybeZpvIvsTtKw9D+wceiZooxpVT6ZLmb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=othJ91rGJfaNbm5EnN+LGnI73TscjzICSbG66MEUtIc=;
 b=Odp7fj/M5XVN38TlIkmdKJft3HKQyCvSstjBWSvPTMN20g5P8n9xXmPZvTpCwd43zzG09X+14A9h4LLBd7H69C2mFUG6nrWOgxtvlxiKFgUa8MJwEdNX7EEUHXKYPtss2tzp7NYIJDzAdeVDK7m/qVT97/vLQhlKiPf6L02gYmY=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB7582.namprd12.prod.outlook.com (2603:10b6:8:13c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 09:21:38 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 09:21:38 +0000
Message-ID: <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
Date: Wed, 25 Mar 2026 14:51:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0060.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::6) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DS0PR12MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e801584-918b-4871-5455-08de8a4fead1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VVeBTuV/mmvtFO0HomBaV47oWvvMc26X5foP0YOlXfldPGhGKb1KSRcA3+yYKCZMcAF8C+DlMgYfIRmiZrN2BBDhL/uj+6naqG5LeZr2VGLbFSXbiU82H/QKKkGn3LhaOiH2NM+lzEYTrV47AnR/7BCw9HcU4VQfIm06xAq9vXgLmyNaVphidgW895wF5m9SmnWA+zzSjIcjdd+IW3dLrM5/E+tEHMooob7N1a7f+KkxJ27YhOwfsGHDvVBmoopst9OHRXuRcsgzxLxo8yzeBbMpxBZLQBnxdhtMQk23jFxWRfkxW8DjiU7tJR+mDuDuIoTJrHt4yYE7Fv01S51AWH53hp3wrvBWYqTtk9Lgh1b2u8zjHNJdWCDi1vLRjjFhj2Pxj7IC+ValpkF/sAWkhQ5NabVsP8E2TPPLk2bHuNQo0RImFNdMG3QhT/9zIY/+ptT3rcSRrbec+AC4/Nb4+7rQeZpSr4XESYE/ThkWfXh5oohsJTqFnHgm3/qV/LR4o4uEQfmN1zXvCDAX+iPOCZUEcJ0Fzu19Edm5htJQAvXhciiozACp3pnIjxejSQ/FBlRklSftJNUl66m68MbyavgefmjsEMnbnytrBmJbxPdm6oHgsEUHA48aP/Q359Jf/jdcK+xLs2YMVIixy3MCQ52jZUHls0FYu2Bn0LVvU2CilXf06xkPVLX4KQ5KrHvef1yZ6ca8OpJbylw0ldgvqcIqHdNQZ71I6+1HDvqqAYg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3puSk0wTWpCTVJha1lmei9WUWkwYmZqYkJRRWJtQTJXanJUY2JXT2IwS0p4?=
 =?utf-8?B?L2h4aUkzRWVlVDNIckVkM056TjhuUVpJdWo5WTFQa1pFaDROV3FldFpKbFFO?=
 =?utf-8?B?UXIzRUpsWXFreFdORTE1S3k3MDUyVXo4THpiOUxTeTNKSzErV05SeDRpVzhZ?=
 =?utf-8?B?eVVqTklqa3V5K3l3YkRqbmMzL1pTblQzRzlQaDB0bjI4SUhsQitIRTBvaHJG?=
 =?utf-8?B?WU9kMGgrYWFJQUZGNHFLeDB6Nzc5ODJCNm1Qdndjd1dmNXdoWjdQbHJYNjN0?=
 =?utf-8?B?bkVVREY4djVGWXNOQzc0endncGFXZkVCYVNURzhvSDhlM212UGgzTVlRR3M5?=
 =?utf-8?B?VW1SeDRTaHlub1lVNG8yeTk0bTJOWVhYNlJNeUkya3dLUUJmbnV2NFg3NWxr?=
 =?utf-8?B?eEd6eDFpbmVSVWdrMUlFQmxJOHJ4Yk9Gekg5R0dJQTBjT1AyaTk0RWc3djRG?=
 =?utf-8?B?di9Kd0xDUldoOWdqNEUxWGhUTXFsVjNqVDhLMk50bVBCZ0o2eW0rM3JiNm02?=
 =?utf-8?B?UXJIR0xteHNMaGNXMWFqSWlTYlRFRThQUmhkMjJrVTBZdXpiU2VXYnBoNFZY?=
 =?utf-8?B?RU03Z3pMcmFLTXFvZ2pQQTYrVTBoNDR3V08vMndOcGtBRjA0dCs4Z2hKZTlm?=
 =?utf-8?B?dkU3OEJSN1JXVHNpMzN5bnpkVFE2NTQ1eW03VEZNeGYwY3FGVXYwRU1XVDRC?=
 =?utf-8?B?b215bEhuaTc4VHZzN3kvVHRrM1M2M21IVlg3WmVGazNMRzF4UXdFM2JwSS9P?=
 =?utf-8?B?bVBwQnFPQkUyVmQ5dXo1bEE3M1dJVTAwaDl5RnMzMkg5MHZFaE1jSUhtN21m?=
 =?utf-8?B?UVpwMHpQUzU3VW5lRmM5dHZHZUgwU3BTV0h0OU9Xd0QxV1pWZUt6T3RvR1ZC?=
 =?utf-8?B?VzN4RWdrakovaExBTmpqU0JqTlppSjdiUVBpdklwbmpDam10YXFPeFV2Zzlq?=
 =?utf-8?B?OHYvOVRCWVJTcGprV0N0YkZXSXI3ME5ZQW9ndG1oNVRaU2lJTnFYUGVzamc2?=
 =?utf-8?B?dE9tMkd5NEJXM05YOHJaUXhiNVp0ZStzaFFrSXhSS2R2WGRMcnIxS0NWMEow?=
 =?utf-8?B?WFNYMnVaSHg4NEMxUVU3dGZ6VUQ0dEc1eXJ1N01JOUVUeGtpb253REVVMVAv?=
 =?utf-8?B?dkV2YzVsRENXNVZaMUg2Q1lZRkpYTjFSUjBta1BsWExCbHhyci96aGVRbWxu?=
 =?utf-8?B?bDBmcG9hY0daZHcvUTNMQWZJcXErc2JBNkVzWDVlNnlEMlZnODFKN25HV2pa?=
 =?utf-8?B?MWEwRnltWXEvdTczajZUSVZaQ01LOVFtcVRtLzROWjJGZkdJakwyZXdBTEFO?=
 =?utf-8?B?d0t2WHFrQnI2M2t0UTdoc1B3bWZaZXR3MHA4Si9DVDhvOHFYYXZhc2ExOGdK?=
 =?utf-8?B?Y0F1a084UGxlNGdMTzgyMGJXWkZCeWlaNXo2bkZ5MDZqbXJLTVd3OWtxYkxu?=
 =?utf-8?B?ZUwvd2dJUS81QlFTK1JSN0xNVmJrZGgzTlArS2NzcXByN2VSYkdiNko2OVc1?=
 =?utf-8?B?VnJ1VzI1YUpUTjM5VzRQelZPcXdoaEdkbzJJNGhpZ001VVVIcnlSVzlWMk9u?=
 =?utf-8?B?NWxWWFFnNW5hYmZQTDQzelYzNmFqWlN3MnZjTkE2VEN4MEVXdDBMTzNlc2RI?=
 =?utf-8?B?c08vbFRBekFKNlA4WkpjK1EzRU1VT2xQR3VFMzlSdkVCaGJKRkhnZjZNYVN4?=
 =?utf-8?B?QkVWY3VuNE5ZQTRUMDdqeXdzOXdpVk8rVG1GaWg1ckc3akdvcC9hSzQrZmll?=
 =?utf-8?B?TEZ4SUxGN2ZMeEZYdXRmRWx1STVFUU03cURTOGlvanN6YzZDWmFLMlVhR0xa?=
 =?utf-8?B?dDNZYXpzeUFVWnVQdCtyd3JjN0F3NXlpblExTVZiNExmditKWVRENkozN25J?=
 =?utf-8?B?U2Z2ZFJrU3I5YTl2YlhCV2FnenowVlUrNTBrRzRwR1RPQXlWTFdYWG9hTUFv?=
 =?utf-8?B?WXBQUVhjVW5JZzBHeDBKMkM1VDFmeDcrYTl3YkNvTDIvR3BUc09PRnUvTXlv?=
 =?utf-8?B?OEhIb0dxSUpVY004MFdiZ0puTEhPWEwrWmNzY0daR1RQaEJuT3R2dEFzZDB3?=
 =?utf-8?B?dFREcnpqaXg3djdra1ZWeEZxYVRpNnlWbWhVd2dDbWE3WWRXSTVPSTVROXB3?=
 =?utf-8?B?cDVYdEwxRnVYc2YwdVFqKzB4UmFiVE5ubkIyTzgwMWt4eHJNdTlOM1g3Z3Mw?=
 =?utf-8?B?Q3B2elBQWGRsRGI0T25CdVQ1UC9RU0QwUkxpTjdIMWJQanBvUmpuZnk0MEhC?=
 =?utf-8?B?UmQ1NkEzM2FNV1NnTkhvMGkwWEUwczRGaTRtREh5dm1RUlBFcXZZUHpmNjB5?=
 =?utf-8?B?ZFBBNW92K21OL1poc1RualNCTFZ6RXVVeitQR2pETUZkb2xXUHhndz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e801584-918b-4871-5455-08de8a4fead1
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 09:21:38.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnGLYuVy3zROiLqNxcc+vmxGxy/zO2Cas4lsLnJVLjFOT4BeiFEwmB1pJP5SHodRPoCTR91zmvvRVCWaK32CVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7582
X-Rspamd-Server: rspam12
X-Stat-Signature: pmaqsr9zko3rdic8dgtif31i5pnh4xb5
X-Rspamd-Queue-Id: 96B29140002
X-Rspam-User: 
X-HE-Tag: 1774430501-580721
X-HE-Meta: U2FsdGVkX186s4FcPivBer9Wjm9FkQ9rP1Dvbx/ogBV/eoiRAmclSffezkzrLBe4v1QlHPmKgkrIwt42j4yWC1TaXVR+Av/HzEDKPKN7h+mTUPLtBT6eMxgugJCPWS+wHWp9tgcoRk9wMvcrgevh0iXHlb5nawP7C9VXCo9CC/F+xEadDqu/TgsPaRO3liRaQWK46eZNR3RYYiFaMCK4ksRpbrQ32c8AHoE8tYo7CrqIzT2s5rOHYklGeCsSuSjsARcEqBxnOOJvwa8sBbCAOnzz/8pMTNCBrLDuNQdGUsLrWBypFzx0mC9E6RprPOtcTet7jDKFwy1SVxD8HfW4tNsfK8jwhkokkQD5YNLbLZCWDoNZRsof5/XjUtkEVIObT4lInUZzzYEhaZSlUht1FgSVoopchR3nwO6YLQpMHmhCiizaUEGaY2SAQYGJMgZWnydPbwRW2Pbh6UIw0fqsPxTs0IspORkZScbVJ/P6YkhzN72jcRbbhGSb5hAlsDZhZ13UWnB7RMdnMozSt8jTF6NyOwkslIrm+VenniDDF9Soe4y79cK7Vn8XWp7ZWtrPbVRrVKJ5A6tGvweh0KH19zz2g9A7VEh6kWHNRtR6o3pAfkNNzogunlY5WAl3bm9K3JzBTyQnKlHckpMGPtyPqZ2K87wnaBhswy+3yiPfMhS+VrIYOjfH3mn3H/iy0SUnZew7o6od63ClH6In+hizVyTDU0e2ZIO6oxMOvb7wOtBNTGQluiJc5Ta6SDtqWdG8Bj88imwCwDKeidCLQXxlKanjyywnlMzpeZKh0NeaPkr3RgCJA6XpMrj/mCNXNFO2yGQOasYDdxuFbBnE/04NRs9FQFwcwY2U4QgsEI6aIaulGpfIeL9Zw2WeNcRvuZjDFnY/ZPXqmZtLAdRZLXUu50IbNp1LDwhv7Ua1WJkMoAk6ZZjVLnuCJfkdQXOiXFuBfW3DZ3r8DlHbWrp+k0b
 KwECQ87L
 DOeyImcmX017IRVac8pSAKbvBnZzhx5I7tMVFqjJsyiaePCEkAHawMPII6gKKMhvd/8gypwx4uOZpyk+GhBy20L4i3K5DhLNlOw/9Xe4jnuBT5DhEVl4sqZG1gsGLK30lyiljjIA9M2QWumXPHLRTtFYrNp64vxNMGP61PJq/JtFPGhldZs4Qc+WikIkeF2Q5wyiEH1X8nCxrHtoT2IUm8KKvPnRPhXzZMY8gZiHg6+Bh5kzdkI4PVenNOYvaWFOmI7MBNlO38CKozG7h6fK0V1mrLI0sqMInemuUmLNCwshcZUIJnwnjiGw9m1XeKnc/AZrzwDwTAV+lfNVOVjW1D+L1HitnrPokCZ5GE5stkn1V/S35n2wqvwi2Td7sQD5k5PndRnWFfc3PyqjggRSZXml22WZvKL9j2M3qcXA8rYzd4Fi5o+z9e7yJhejkiD3QHKGzqL9fBNY79goXYZ+++SbI69br+vM3fxb9iwjTjkZqglM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>  static void __migrate_folio_record(struct folio *dst,
>> -				   int old_page_state,
>> +				   int old_folio_state,
>>  				   struct anon_vma *anon_vma)
>>  {
>> -	dst->private = (void *)anon_vma + old_page_state;
>> +	dst->private = (void *)anon_vma + old_folio_state;
>>  }
>>
>>  static void __migrate_folio_extract(struct folio *dst,
>> -				   int *old_page_state,
>> +				   int *old_folio_state,
>>  				   struct anon_vma **anon_vmap)
>>  {
>>  	unsigned long private = (unsigned long)dst->private;
>>
>> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>> -	*old_page_state = private & PAGE_OLD_STATES;
>> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>> +	*old_folio_state = private & FOLIO_OLD_STATES;
>>  	dst->private = NULL;
>>  }
> 
> Just an observation on folio->private, it is void*, but page->private
> is unsigned long. It confused me a bit. There are folio_get_private()
> and folio_change_private(), I wonder if we want to use them here
> instead of direct ->private accesses. Feel free to ignore this,
> since it is irrelevant to this patch.

Would something like this as a follow-up patch work?

diff --git a/mm/migrate.c b/mm/migrate.c
index 6d4a85f903d8..55d1af6c9759 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1143,17 +1143,17 @@ enum {
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_folio_state;
+	folio_change_private(dst, (void *)anon_vma + old_folio_state);
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 		int *old_folio_state, struct anon_vma **anon_vmap)
 {
-	unsigned long private = (unsigned long)dst->private;
+	unsigned long private = (unsigned long)folio_get_private(dst);
 
 	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
 	*old_folio_state = private & FOLIO_OLD_STATES;
-	dst->private = NULL;
+	folio_change_private(dst, NULL);
 }
 

Thanks,
Shivank

