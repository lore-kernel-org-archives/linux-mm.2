Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68889606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IrbpN+Qg
Received: by kanga.kvack.org (Postfix)
	id 5E22A6B05B2; Mon,  2 Nov 2026 22:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593A26B05B4; Mon,  2 Nov 2026 22:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BC66B05B6; Mon,  2 Nov 2026 22:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4816B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:14:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B9731401E5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:14:04 +0000 (UTC)
X-FDA: 85392338808.21.DB975CB
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	by imf16.hostedemail.com (Postfix) with ESMTP id 851AC180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:14:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IrbpN+Qg;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793675641;
	b=mhhzGKeUrJq6dOgKy5pgjGhsPVdBHzW8K7dHBfv6UJ7b4y/XSlLA8Y+1q/a5Q3tG/+m5D8
	0E2VZSdAopxCZhi3NTAxdyhSHZYRY609uQUSJit0iJ/jMpMM0pgVeT5+e74rFg54/kTCYK
	4Z6KAyh3V5O1YewbwE5tI9TxXWfIURQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IrbpN+Qg;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793675641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZASsjjTs4yOtopvDV5SjaTBsyc+0lOLk5XZxt3K3Yo=;
	b=2D196PsSq4mleby5o0aARZ5X7aIBH6+RqKSh8W+mGdQH1EoFghM/DTDCbZ63pVcj8LOlaS
	8JpytDoM5jjcXnrVxcroDISsftyJh1QdTRlV0MsMlz/TbOacJg6EoRvL9iZcBzSnTknEiY
	kzD9mrY6SbpGPca3nW9DoA/FLVtPT6g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSRKHeUbSaTzdMiyZEa1bZcGGmXw9L/ejQLOnwuwV3u7PmdVnDoZd1pDtMbX6VT2RMkjLWW5x5gKZ0FiIxjDerdUgZmdyfNI11Peo3J5piY59qAuAA5bUKEmkaakmL7TwAomC+DVa59bKNfYYOn4E6UGkGLtEj+7PIf8umR+E6fu3ELUwI6gep0DyS+UcVgj+anXPiq3L3Cy958IT7qpqEzCmerZUPCFn2BmFWOzQhnnppmk/XlwFQlaAsnykkyteGSywbuzzX986ROgBNBSENj/M7uj5JiSs9jg/3SdUWo5P1Tg7vLvs9CQJN+o6Wkgf03EdIJUNFYfAQq31+tpvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZASsjjTs4yOtopvDV5SjaTBsyc+0lOLk5XZxt3K3Yo=;
 b=SEas3kqvT1dxOB1bbRh8BVczVVqBoyLJU6UlixUzd3LCVVKOcLv66VuOWpJqwEa7mn73Tny3CocSEI+0YpeoIzPToBOFPW4fql4WWqqshUZiuwut4M5gVk404oaWFV5qPcjxy63n85HvZjKCOnrt6VAiL9R6ZcvuUm2QzWkyc0cC5mHkVajT0dmKNF/mKJhoNZz1WqxI4uYTYeOF0SHHkz/iIWu27m7GFf3d+HjAaLYHohretk1tM4faUXCW5DTfufdCcIJfsicAffH/9ze/6OjzbpENcf00kVAV+xtKtKzHHAP2NG6ogBSoWLECJVvFwB5NMH1P8KOhrDzlr5n8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZASsjjTs4yOtopvDV5SjaTBsyc+0lOLk5XZxt3K3Yo=;
 b=IrbpN+Qgjq8gckPbY5TGMWA0yxXnxS3f1R6RUIQvuvibIeZpL+ssLoBLrgbACSMFw+X4nA+ziRgZ3ELGC9bqYkdQy1585ierlNVaGa4F11hlJG/MxjWO3JG/aSdmn3vVJJwfR81oaHmV/ZVmyp80jWmnw+x2oTm/WlMq86/aTdcE4XDPXsKCwS7l+YDdcTyDCgHaS5XWw3NMTGX9xCByfNdjy5usz6HTKioBuZ9/4rNCa31ZMwQftpiUGkP4mcnhMXNIA7EdMO7K/IX2FAlBkJS3P/Fmu4qzOOJs46oG9xPuy1m2iLDyYJ4gaV7sQMQIpfOILAzmK6h3xgQABaBlXw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:13:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:13:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:13:50 -0500
Message-Id: <DML8Y1C80SPN.2OBHSX5SNKB9A@nvidia.com>
Subject: Re: [PATCH v5 10/12] mm/page_alloc: retry alloc_contig_pages() when
 the zonelist is rebuilt
Cc: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <baoquan.he@linux.dev>,
 <baolin.wang@linux.alibaba.com>, <rientjes@google.com>,
 <rostedt@goodmis.org>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <ying.huang@linux.alibaba.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
 <nathan@kernel.org>, <ndesaulniers@google.com>, <morbo@google.com>,
 <justinstitt@google.com>, <Bessel.Wang@huawei.com>, <jiang.liu@huawei.com>,
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>,
 <stable@vger.kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-11-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-11-gourry@gourry.net>
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4091:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccee873-ac2f-4256-30a9-08df39587cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|261102123227099003|18002099003|56012099006|261021121427099003|11063799006|4143699003|261028144727099003|261026140227099003|261009223027099003|261026121527099003|10067099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	KovL9N1DOkBY5CnQvb+rRarDk2ZkfTkpe03jYqxJ8twAqOG4eUn6JUZylTxnvS/Oe7mxGiPfOYtQz9qw7yJLWmZFFvHUgtAvLLZaRcfd6RmqgGzbxPwfoAOlZ30XN7yeWU6Irlzf6kC9VZ7g6DHRfEidhFKbCCGvluzu2KKUn26EdgMymiQ8eZWTX9WQLHRNZxvoNOAMmdD38DcGFmidHorXKJXxFDLe+29y6Zl3KJ0ZXmRNTDX6OZArWYQM3/LX+jM+50OyW23EFDD5ISdU5cz21RTa4c+y7pxtjwK7z/JXuWgnOCI1yemY74rOMpYoEtrHuNZeM2n9/WNe/Jbjl0QlhX75YmAaFKjrUx5B6aPPGf9xXxwyqtSBG/kNTs2z5o4DQvPNwS2usiG/MSjtsxUnBpLTLugP1fo84EoVYOt7Icq0Jlmj84D2QwRAqAH8CrbfMAPmEvGe4XjoZVWD28ed8MITwzHo9Dya6+ClucGR/uw0xgROF/dayn2kPva7+0ZXGxFyMtfu1CddGCRe5R7rRoj9coTC3ZzATGlBsgBxEeZtzA9Evo70YzP0DhZdd11kWeYJdZXffL90mWKPDMMEW+E1YuXezwiwaYiEGJyv+qoo9LVZSERMhXYQAnJhYdCz8vexDfz2ZuBySuynP/SreyoWR6neH7Os6lchATg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(261102123227099003)(18002099003)(56012099006)(261021121427099003)(11063799006)(4143699003)(261028144727099003)(261026140227099003)(261009223027099003)(261026121527099003)(10067099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3F3ZUErc2hBUzh2Q3p6VjhXbDNhNHZTWm91clN5ZGdMRHRlMFZ0MmE2VG9t?=
 =?utf-8?B?UVJwZnpCSHd3V1ZBTUpxQldrV2ZMNDBzeXEvNWlTeGRuQTFlSFZmOUVoODlN?=
 =?utf-8?B?MTRDbFl4NTdBSWJCakRpbjF0dHlIVExBZVNZWkNIRXhHd1NrSWFqTjl6NzNk?=
 =?utf-8?B?SE9pcUZ2a1JKcDFmc2tYMVlFeEVsbEtvMG5xcWdMQWZMTHgzVVg1Q1kyb283?=
 =?utf-8?B?emkzMHEzRnA4NXNNSFBNVnljUThhQjErTWV2VEFkWTRMcHk1RGJXeWtSZGgz?=
 =?utf-8?B?bHU5aytrU2lsa09JWEJmbXUweExESGVPVXRiOUZlcFpyY0FJSjlOdWRtWFQx?=
 =?utf-8?B?clMyV3lNVlhNSzZIbXgzUW93eDBsTEdjeFVjU1dCdThhcVl6V3JmazI5TXpJ?=
 =?utf-8?B?WTNEMTFyUjhQZERDNnBKdzBGdHpSSFc5ampPQzdKSU9uc1RIczBTRTVIcUor?=
 =?utf-8?B?SzFabm42dEFFTVVQZlNaNUNjUDlvbVJCcVlCTzQ5bndFelBoMXAveng1S2JO?=
 =?utf-8?B?ZW4yWWRuaWVHSElFL2lEaFZjMVlNSERZVU9ERzdkQUV0U0M5ZUxITlJaU2dN?=
 =?utf-8?B?djloR25DUndqVUNOd3JzaDExcjVnSkJxSUVaUjRWbVRvM0JvWVoweUxGVmVT?=
 =?utf-8?B?OW9QOTcrcU84NzQxRElBZHM4empoSXIrdmwrWVBtdkkwSkQ0VklzTEFhYUEw?=
 =?utf-8?B?MGQvUWZSSUsyYlFvWWdOVC9Fc3FvekZ6TURYY0R4MkRmSUZ1M2Y0Rzc4aW5h?=
 =?utf-8?B?WndsZnp6Q0RzcEwzSmpjZThva1NhNklCSEl0eHM0bEhicE5WTkVBb1BURFh6?=
 =?utf-8?B?YnhORGJNQ3RpeUtHQnNIZDFSRFRVQkJ6VDVvNEdBcDdiNEVpbi95WTM5eEND?=
 =?utf-8?B?SHBtTldDOUxYMkM4K0tlOStNTllVdXBPVzFqR05ZWXJqaHdjTTJJQXJEcWYy?=
 =?utf-8?B?VllDbGJucU5pQ24rUDRYUGs2YmtLT2MzZFJFMEVSbWhBM2hYaTA0aUlOc2Jr?=
 =?utf-8?B?RGRaMnBTMTFOTUZna01MV1l1TGp3K1lFdGxWRmlBVzROMk90K2FXNkxZejZR?=
 =?utf-8?B?RFgwbDBPUVJQdndwNWRRNVN6cjQyc3dmcExONE9UTkQ4OC80aU1waWVQSFhH?=
 =?utf-8?B?NU16SnVxUVRLVHVkcnNuampkVzJPNkdTTzd5YTN2NnF1SDlnODVERHlqOCtr?=
 =?utf-8?B?c2NEZWRlMDhWWlVqdnNxYmIwaldtdjJuZS8zTUlEZXUvczFyS00zdFJEVFZ2?=
 =?utf-8?B?UnJIdjNPRFV4d2daVjkyVzRSSUsyRWlrSXBIekZzUFJhckM1K0NkbVQ4WU9q?=
 =?utf-8?B?TThsRXdtQ1pBeExGQ2hsNlhKRGpITW8weDFkUS91ajRJK3JJem1lMEJ1Y2lU?=
 =?utf-8?B?R2JneEFSd0ZzY2JPeEh2NCtlS1pxd3NNcUJnOGdXRy9SSS9ldnZFbWViVm02?=
 =?utf-8?B?d2ZpZE81aCt4ZVJWd0R6QzVqZ1FhLzNUTlZRSWlOY3ZOMmhiMjV5RFgvYUV5?=
 =?utf-8?B?blVEK2kzYlRyYjdCeGVJZmtqNStaTThraWx0TWUrYTMyUWJIa0hGSXlOQTRD?=
 =?utf-8?B?UDl5Q3Babi9oM3JsN0F3MU9TcjQvdDNueDRnNXhGK3UrdXdyeENVNTYyK2xH?=
 =?utf-8?B?MVlnOXl4RE9PVnhmbS85b3h2ZUtya0tyeXA3cDRYUzRBRkhaZDNtTzU0NGxZ?=
 =?utf-8?B?eWM2d1R1YmllSnlIQTc2MlZDQWJaelZRaExwZGtQTVVvM2hRMU8zS0tDS2JT?=
 =?utf-8?B?QldRVjlMNG1jdGxOc3hzUnluTUI3OTBmQXNmRW00TzRxNVVyNjhoKzkrK3FR?=
 =?utf-8?B?dSt1ZlB1eHRuMlByd0Izd2VqVWlDOFBNcFlrakpnWXBWRVJtOVpreVBuT2hx?=
 =?utf-8?B?TExaYldPRmluSWg3ZGlrMG1sdCs3Y2Z6bkJmSm1FRWNYVUNsM01FSTlaSitS?=
 =?utf-8?B?VDVyVDNLb08wdFQ0UTZRakR4OE5wVVQ5anNLNWdybjlvSDFiY3Vjc1BHY3RQ?=
 =?utf-8?B?cUlhQW10cTFJV1YybFJwR2RRQUNsdlRJRXNLa3pqMHhjTENrUDRzZ0UybW9S?=
 =?utf-8?B?SllVc2h5UnhraXFTUW5nR0M5RGFia3FZeHpPMEdvTk1jbUZ5aEpPSTdqYnNa?=
 =?utf-8?B?L0dYZFdnTjBMNUhlVVB5U3JLY1BXUVcxMEt5WWRhYnNLcWFWNWMxMU9Mak1C?=
 =?utf-8?B?Ykh4SXhjcCs2WjlGbEhONkxueUxVS2hYMnhJZVdYdko5NkROelMvdnZLODNW?=
 =?utf-8?B?R2tLR1p3Mjd2ZTR1N3EvakF6NXg1N2E3R0pmUi8ycCtRWElITnJoZlVFL3hL?=
 =?utf-8?Q?KJRhwC31LOqD4vG6Pw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccee873-ac2f-4256-30a9-08df39587cbf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:13:52.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GvAW/hNt8IvlkSUg+RWEqqnNBnCVt2T5vleK2zX0n8DI+q9u715ISmvm862W+VK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 851AC180005
X-Stat-Signature: tenz7iyoruhodhs18o9tyoeu4or6w5wx
X-Rspam-User: 
X-HE-Tag: 1793675641-443678
X-HE-Meta: U2FsdGVkX195G95LEnotRF31CIdSQi4KyVkL8RXpzN3y8Jf+i6VvEi0X8/qa1gyOosXh0gqg9ehaJEWHqzG4+D9wZAAtMQo3w+sw2/N5mAb6sdjE+Z2LI80engQuTey/Xd0Lm/unWbxBZLZHSZAiGK5KLZXklQXoZt4XuqMVnk7XX22F+UvrIZQu2X9KSnEm0yxTQGATaXUdrUvr1YPUchdhZXkWoBmXLW2yDz7TQ9ON+3/nDdW4Al/v9vKrtg9oJ3EGs/AF3u+c8ZozirAPlIZ4krxD1/78xSZtHVamz6y8yLdzXDtZhJy7cEnUmJu+2VRUYgtMl/eMLvkAGddT4+tKyrqFsMZCVLNMdTI48p6AQFLSvwbzdA4hVChxzeZZZpHrsotXsooXESa72tLjkjT1TXc0/CjoyidqZdyPCEvdiKewqaHXm/Wn8npodN6J1k13IQQ7ARv8XBtxc1a8SY5R/1IrZVV8cOWez2mGMGoRgP4x5agI3sWQbk/qng+ldFz/W64EhtRJAH/7w+BSnwfrWb7NuqTtPOnxUuHKy0iG30gj85AlozVcaTyB3IYFBvpNMXdnFEEHzjEg4IBdF46Zx4mE65Zg0Gb+R69k3bsd6ZShuEDm1n0OLh6oIZ2we/AdFEXc7s+C3DHFoWeK7PtZmV0Q8Ka1S6LXUw/xG1sHC96SpiQ+KU6OgaWXJsEeFupki6T8iRAATFEymBx7Hain8EqJfsPBmZVGhsVOyDies/29qiPtfJjYq37DGpFsJ/DvyXjeixN5CdEN4WckwnH77DhUTO95t3HA2BUYvCJUBQc0Zitcs8Zou0NYXrYuZ43RlgbKUun4ZTuB8KmSMn7AvmghQ4/r3FmDcUnW73BJKHcFWrktrJX2UKNyn+RhQjoXUI3UnLPlh3lZ5rQik4UEzW1vFcXNAsKoOyw0ZBf9Wwc4MAeb9euo7eafRTLaPY0eibwG/stoyQ+VtlJ
 wjOlyryB
 C+PRez+GO+lXZGDDE8Ux5j/zA1XkSUcUjKszXprAQQS0nCJ1t+punBPFQzoIZVzioBGq+J1pSfv+jmfpPb0X1yucnbetjKNISXNp9O0Zg0KjadiZ/7dfnYwiRQjYwwYRfgWnabgi1Auk3b7TyL8eksmhi9xrB1/cxPQlGtEYMqc80+qHB0xwc7sTDPK3RmKikAI0uO8RaXXpk2f7d5Ug67+4FQ8fn1MCgV+9OlOUvNmq1s0L4Z8xCqkmzDYEx8EXIoCQF/flCqF0u6WfpumGuTyOve5BfhfRuiAEZxW3GxmsO093mJSHM6dXoUg4e3Mgx3tkdMU/AXvq+G3macN2zogRQBKaXYQrnb1OlVVNd8Zb6oY8cN2aJmaf2CISnSIlvg79X/PXdJjWgk2m3gj/cfe1LsMWQdXJmLywE8p8pJGE8jHvVZ0ONz+434ZltZkg/yUxG5bSsO6fP2WwsNoeM9MRf7tX37WAQf5++moNfhRPH10bG5TlE3v4v5M6FhsnXXHVIfVCz9W+yS9hwgA0LUKwTZ4uMvpzhOD24j745uNtJuEFVTi263YxzQoSCetRkB2I76sutW0UM+Z2VR8nFWwyHQIONSuZdgs+m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> Onlining the first block of a zone rebuilds every zonelist in place,
> shifting the slots after the new zone.
> alloc_contig_frozen_pages_noprof() approves a slot by the caller's gfp
> and nodemask, then loads the zone from it:
>
>   CPU 0                             CPU 1
>   alloc_contig_frozen_pages_noprof(GFP_HIGHUSER | __GFP_THISNODE)
>     slot 0 (NORMAL1) approved
>                                     online_pages()
>                                       build_all_zonelists()
>                                         [NORMAL1]
>                                         -> [MOVABLE1, NORMAL1]
>     zone =3D zonelist_zone(slot 0)    /* MOVABLE1 */
>     alloc_contig_frozen_range(MOVABLE1 pfns)
>
> A gigantic hugetlb page can then land in ZONE_MOVABLE, and a nodemask
> caller can get a range from another node.  Gigantic pages are kept out
> of ZONE_MOVABLE since commit 79b63f12abcb ("mm, hugetlb: do not allocate
> non-migrateable gigantic pages from movable zones").
>
> Check zonelist_update_seq before using each zone, and restart the walk
> if it changed, as the hugetlb pool walk does.  Check again before
> escalating to the pass that may migrate hugetlb pages, so a pass a
> rebuild cut short is redone rather than escalated.
>
> With kprobes holding the walk across the online, the base kernel put the
> 1G page in ZONE_MOVABLE in 3 of 3 runs, and this change put it in
> ZONE_NORMAL in 3 of 3.  Direct GFP_KERNEL calls with nodemask {1} and
> {2} got a ZONE_MOVABLE range and a node 1 range on base, 3 of 3 each,
> and neither with this change.
>
> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net >
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/page_alloc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


