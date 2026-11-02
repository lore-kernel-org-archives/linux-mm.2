Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CB0606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 04:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SNvqp5G5
Received: by kanga.kvack.org (Postfix)
	id 48DAE6B05B2; Sun,  1 Nov 2026 23:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43ECE6B05B3; Sun,  1 Nov 2026 23:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307FA6B05B4; Sun,  1 Nov 2026 23:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0112C6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:03:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DA4040BAA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:03:45 +0000 (UTC)
X-FDA: 85388835210.04.3C09F7D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8CBC4160002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:03:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SNvqp5G5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793592222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
	b=GMFjuQhjnBYMDakQ9ePxp0XVUlu464BDM4sh8Xvx0k+eUqfwnFavhRifr1F0IpFJ8QXv4w
	ZBsV1V1DUhERe8UxdM/2oOQTJ04y6sMK8BS+5XkaDkkmYjz55kIf6uZLEjGt51gn4ilaAC
	tMQTiBCmu1iZRtcoymgTsSW6CTkUuHI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SNvqp5G5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793592222;
	b=EBKYtzbwri8oyKTtq46/nrtEa12MhIywU1MRVilfA1fIZ8tmW3gPrbJXEmknfkvt/h/M2e
	Uy/ku34xlkYpVBeEkF2Lc9dW3XR2lnlvPRn4aNJiS17Tmm9dOyVnbiRrc2hxMPBRbg7UXb
	QfhWqi4LY+73nvXDeUKvVWKwFEG1C9Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmQBdYIWP3tzR/vLiH/pOR0xwLnCitECQyrNObfft6JwJlrKXHCSalSk29H/G25h4ro2k5JZ5si2QzuRQh6nrHSoEVYB97Ef8HJC+lc6XH6z2XR1bivYbQUMyVmkZ0XFw3jmkWgWOLB5kYYSALGqCCNf103LBx8xnFP9OJEBmZ8sQj2oliZ1QQlmKUSYOb2M51mT2fWjGMlV2kimEr4F3vPCFfA5Y5IstQ8/8wzeFZb0qfUkijSoOy6ek18CZmG1EX1/BgqZZVeQeeoA7oHJA124PJ7pxhARo1uNlqAaX1oL9XhzsMrrMhk0CfgDnEDx9JmuC7fjh9FM/ePjnT9T6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
 b=bwAt7gxVNX4RYZqD00IT/baKV0azRIRpz3j3NdJIbQuKpMrJyOp8Db+7D28G8cyjk4wXxcJvCwwR4rkpTElwPFXFCFCEkvoHOdcS/+lsYjPiOyntRg0V6p8fNiEHSgZPNdZL7r84yQNsVO5pN+u6YDTXgiIsFDCHqhBzhgUTEtQOdtDWh/4vxnuj+rcLg6Bo/aNBsRgC0fg+R1pTD/XSgF0osNerObXb++c60KdTNqnLYy0wt8Go6DqxDrNRcCG5R3Xo/qbhLvZhAUoMnjMpqkIy4lq6MdGbui/jifLPE0ldz46iK+LLmnZqADYH/YR7UEP7Fekzx29eyXJo7VjWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
 b=SNvqp5G5+WMk8ROVRDkZ+/y1XFhdxsMNy3M8zXBHzfmSEZZCf+Tg1/r9VhbOxbTQhPR8gs+AudoObdlyPflIMfMefrpSrXdBFIUWwZL1xGMlDpJreMisZCfo2qWTQ+7A2w5r34Ng7U6uudeO7lH4pBr18RspBlVzIg+blOvVdi+8HSRy7vCsV8AgCmQHXrCSo41pf0hFTcyLcbI1nC17p72m4gXRi5q4vAvRqXuS0p7VIsm02X4jFTdCB1FDPekFoNrjYsyI12n5INfviwSrcSh4ejkACkKKzD+GCgq+ARzkLpea4GTVAA1IY8yDzb29fFbVqt0YKi/tXggTobXFqQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS6PR12MB738673.namprd12.prod.outlook.com (2603:10b6:8:417::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 04:03:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 04:03:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Nov 2026 23:03:36 -0500
Message-Id: <DMKFDL3A2TOX.78ST1JQZ0C3K@nvidia.com>
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
Cc: "Mani Tofigh" <mt4022@columbia.edu>, "Mike Kravetz"
 <mike.kravetz@oracle.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi"
 <nao.horiguchi@gmail.com>, "Frank van der Linden" <fvdl@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>, "Kaitao Cheng" <chengkaitao@kylinos.cn>
To: "Kaitao Cheng" <kaitao.cheng@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Mike Rapoport" <rppt@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
X-ClientProxiedBy: BLAPR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:208:32e::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS6PR12MB738673:EE_
X-MS-Office365-Filtering-Correlation-Id: 24fc83b6-471d-4401-e45f-08df38964532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|22082099003|18002099003|921020|56012099006|5023799004|4143699003|11063799006|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261022105027099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	mOqYEilScVPEK2+YebiOE3sZ710pkfnn57FczT5oxLmLLmPPNgfQs0eZ/0n+fCxzReo6JS0CxZgJSzcaOM60Sdmn8PwYwhGKBSVB9gPlMeY58vYLU7TmjV8EOhuKv7MRa70Am/h2wzTnu9BaJZNi1w3mZb3kWcJGMK1TUYvnDvRR420qUMePJC70dIBkiUUpkOvn31mVuMigWO8uUCga7I13TRy791t02rFnA8qovpcd/QfeVJHBb7zM6TiOoUtyDft5zdGKnxfcttS1mHjaXApqsMHOKq+zyMoJda3rEACkFB7LbGlMlu8VGyEDIndS0Bx8VhHe9nONEKcMRs1u7Bo9Xe29cg8uk0/WfKDChVwkqWbyVsct2Ruv5mhhl/L++9RHKvPrCPSRmWohK5KBLpezkOmmav3zH8VZezFPbeWUm28AAHYI5HnvntLTYu5FFTqqr65MEmgC0mT5Hd/sXyP+duCaAWT5p1re7PiBI/xfpMrSTXAaTNtpo4ig47PVlAmx0I3v2DzRsl2kryeSmWyXhNrvIccErKhMop6PshGai3MSxcK2omaO2TsHQBrQnJUhocKr97yqJ+TY+nThwEzu+BuEuMyrn7hNlJeb/ZorzMoIpg0+JNTBnR8W8/JlhyBu0EAUsUaObfaHVjhVzocjHBsiY6ib9ZrYM18CxDi7xeh2ZMjv4PMI64b6KIgWIJjnJjRXVLTI+qe4lAvm3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(921020)(56012099006)(5023799004)(4143699003)(11063799006)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022105027099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0FSek5POWdwZ0JKNFFyVkZmVWNCWkpsbmR4aFdYdi9VbjdJekdIWVFJVFZR?=
 =?utf-8?B?TUtMSXdXMCtQZ08vdjBaQXVLdHZzdFVRYW9JOTRicEpPU3VFanlMcy8zOHJx?=
 =?utf-8?B?Z1VYUGxoNTZEcHB1QTRHTDR1MXc2bVJCMWpjanp1ejhPU1pnSlNwUTFoWnNV?=
 =?utf-8?B?SkNtNUg4ei9Qa245aWdibzZKdk04SGNsY3ZJLzNpb0UvdzFHZDQyWFRDL2xR?=
 =?utf-8?B?MGVHeWg0bUMxTERzK0RCT3R1djVOTWxVTVlqQ2U4cjFWT3h5QjdKeTdYcEtG?=
 =?utf-8?B?K3h0emFLWHBEOXJSaEpjTTY4ajNOZVphbDhmbEkvZjNEcGVURjFvbWRGUnBV?=
 =?utf-8?B?TjQ1WXRJbktQRnppN1p4SWt4ZW84bGhoaitCb1NRLzg1azIrZFlKbkwyblkr?=
 =?utf-8?B?TXB5b0lmbVFsN3ZzaTJIZE1iSC9nOXp1TnNCSWhPcmJyczBBNzNVVUxGYVZL?=
 =?utf-8?B?clBEeXI2QXJqbXRndVF1WndSaU9LZjhuV2VRQmZPdlVIbDNXVVZyUFNub2d4?=
 =?utf-8?B?NUQ1bFlQVVdoQTZrRjE3c3owek9RVWJSb09wQTFSV0tpTDdxZEN5SXNYMU9n?=
 =?utf-8?B?RTBCZVhBNEZPSVVEOGh5dStMMlRWcG9oaTU4MXhMR0xTLzQxRFUzNm5Nc0l6?=
 =?utf-8?B?R0lFV3NmeU1IOHZFRkszbzR1SjdHU2thNitJS2NZRnlKNTNKeTFDWjFYeldz?=
 =?utf-8?B?Y1BHTUlEMmRNNVk0Z0RwbkJEc05IU0JFM2MwdEMwR1MxeFZBY1JFY1FOTnRw?=
 =?utf-8?B?b3J1NmhIeUhoNFdmZjF1ZC9zTEE2aGF1MnMzT2d0L040dzZFcGRuT25rQ0JR?=
 =?utf-8?B?ZW96NVBmeFgxTnN2ak9sU0xJYXhjdmMyY1cvWWdhdUp1T0xBQU16YnVsQnFW?=
 =?utf-8?B?M1V2Yk8ydE9xQzZnUTA1cEpwNGhRR1JYZXI2WHF5SStqQWRZSHhlTTZlc21L?=
 =?utf-8?B?TnozUHgyR3FXSmpTQWFDQjBzNklnSTh1bE4vZ01KRlhvTFc4RHVmMEhZOVND?=
 =?utf-8?B?KzB5SjVTanpGQWxMUzJWUkhWSGlSZFFqNVhNdklQNTMzd1dscXZ5QmFSTTNi?=
 =?utf-8?B?T0Y5M1krdnFxUXJmTUZmOGR1WllCWGpIcFJQM0F5elh2RHlEYXV1ZXJPbnB3?=
 =?utf-8?B?VHEzZy9TdjVGNjZxYTJTMThZdWZwb0FmTnhrWngwVlAxbVkrR0dZaHJHdyt5?=
 =?utf-8?B?cTFxc3ZPRm5GcEhDUy9NWE5OWXB0TSs4Q2FFTmVnL2hJZklId3RycXpZNGUv?=
 =?utf-8?B?SmY2ZDk4UWlCVTJFWm8yQS96Rk5oOVk5Y0d1OFFWaE1sSTdlajZ6SVlHekZs?=
 =?utf-8?B?c01OaEZyak8xMmJ3TGRWdk1wbk1WdmFtandIUHV4bTJTWnAwUkVsMTY3WmNp?=
 =?utf-8?B?RDVIQk9TZWp6bVBFQmNBdjFtaUZCUzkzOWxDSUwyaHBBVWJQZGxTQldBZ3Rj?=
 =?utf-8?B?M3dRbkhmcHF5aVY4dUg3cjQzZHRQUGxJRmlFVjdNSTQ0WXk0TnRNN0pFa3dK?=
 =?utf-8?B?U3A5cDYrSUpZK0prQ1JCRnlaYzJSUWhWOU81UFFXcExIc0VwdEorN1U5Z3RK?=
 =?utf-8?B?NDd6RVFkb056ZWs0TTJISElvMGJhUy9KQThHYjFYNHg1YUVDdEkwQVRTcnFY?=
 =?utf-8?B?M2dBWDNMLzFZSEJ6bkhYQ1ZMQzhpRWRNelRZUkZqblkySEhnZDNoREMyT1gx?=
 =?utf-8?B?NkR4MTgwcDh2V2hBNEpQakdLSmtUTTlQOE5WOUE4K2FaRzJHYVpkSE1hOHVD?=
 =?utf-8?B?WVQ2bk5wcmhQZzdjK3c4cmJ4YmpRNC84SC95blcyQXYvTVRodFpQZ0ZxOXFZ?=
 =?utf-8?B?YlBHMHdGQWhTSGJRbVgyQlRVeVgyT205WTYxSGp1NXVZMG4vUXpOeWw5SEZJ?=
 =?utf-8?B?S0J5Y1NQclJma09HTktjWkQwK1VCL0huR2o5ZVMrOGtwelA3SDBVSCtqbDNK?=
 =?utf-8?B?d2FKV0owVXdjK2d1dm5Sc0RZZVdXbGxrdndTVm45dzdUK01ZbzEzTWUxbVla?=
 =?utf-8?B?a1l3WUI1bXh3OGU5S243Nmh6aHhEdWN4VlIrbXZrZDAyQlg4YVV1eGFmaEFV?=
 =?utf-8?B?Rmw2bWVVdXRGeUI1RE1hUjlJdmRDSWJ1SVVJbXc0THliVmZ3TWxsMnIyb2pT?=
 =?utf-8?B?cnNBTW1ROHdmR0pzQmFCOUMrRnFMZzhxT2tKVUtMV1RWUmVucy9mV1o4dVAx?=
 =?utf-8?B?cUl5dWFTdHV2clJWdDByYk9IZUpDWW9wUElwTEFnaEJkMGdpK3luZUZFM0pl?=
 =?utf-8?B?RzJBSmptK2hlSGg1clJoSlA5aGphNkFPdHRrcCt1cjZxQXMzNG44b0NHN0ll?=
 =?utf-8?Q?ZP8znxEaaa9p6U5RZ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fc83b6-471d-4401-e45f-08df38964532
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 04:03:36.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44rOBgg5Qrek7xgPgwGuxWShN1YW9QTlRbA9b/pLD62hd2a1VLgdaMpg6/uTdkBE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB738673
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CBC4160002
X-Stat-Signature: igupbwj53a9ieq8kgquq5cyqcq3dcc7x
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793592222-464287
X-HE-Meta: U2FsdGVkX1+/hkXUztgpYqcFcpw6dmzpqxmY+8aX2QGk53UYrdlqhpODmBAFKxMKZhrDOw2f+/uN0OOKNqEFQVk697wSuKh29bLCjxEx7KpsLgA1JvrrGWU2/nRGIBOkpA7oq+aT0+1wRLhaNTFw8NP/X/ewSlnWETyygwEn24BB8VSpQ2uDrS75WGGbMiVNpxpjBVGvDvOCOfL0wF6aNdG69j1QnDvtP6//oAI7MLPBULvPvChLsJLVvvbE1P2ccou0SzGbM4UclFXGs08CeiJaMf/voTY3xF6xri0e8n4/r+6C7g3fG+ew7sFg+/mcpoBErZ3E24OmnUPKlOdv0PQgo14tF3nj5cTNXCq3clHJtTkdpzIfnnQ5yl7MmBVpvQgehxQEQtogdtp/+fZNo9e5VmPN153GLz4Dy7EMub5mDF44NzGK/iyqrNiTkUCvGmYRbPr7HFzSpKboEsvh9FxWYBh19UaG5MHbAYTr7pg09nFl8O/eLSJeqXeB+io6A6wG4i4H0yWhXvnBVHZpNKl9WxCzwMXyCwQpym3ooENYSVvLZKoLK1MRI9RVok5K8cIyyiu767+5tyjLyMuXfGp0jPZqMdqKwrKEydQjBhneFaXFYnwqUQ+lL+r+VKZfOnxkphUJHDNyHCX9gSkQwVIOy5s3zHa8vgiWegkmzTMEtQc/mWzMIFdeks8aULePkeJnvY4bsjqUv0p6Lw91CzDKUUWLb6JomtVvI/GYKXczyULA8Oj/an2BbccWSMIk5K9PxTsseks1O+I7l15Ej6v5J9ALRj45sarDg9M6JyMi3dPFUIJbeJQR2Gbxu7Xrrprb58Y98GhC8D5U6Y8blhlPr9qGcssA+Q2Ughv96O2wyr1iAcmGid52y5rriOT0ILAbPWEdnCC3FUcBxAOC1Ji52PaoEFcBaxE5nRJe5xVvaLt/m5vvzhzvVnQ1o00Rh9DhXDZI4v+0pD4Ffy0
 jrErsTo6
 9GDCkOXHp4wAYkndSvFO8f3khZ9c06BXkp7HMe5C+L/cQYg/PaRNoJ1ToqR5AClROuJf56jDHTuQTT3rD2ZuhfjV2dg9dZaDH4iBMjnsdO9zJE8vqn1/2r80ztLBJfzGX2yi3cTQ7L2i6ARQ1tGJOd48RJ4BVNV2RFlnckwxxSPVCzu4i5NdEFhHYi4J/QOw+mL6GMLINpicr7xXju+bSCJzq+awqvsqm/uSBwq3jtRjEB9Oxi8SvpNep0cfJ7s+/dtBYQLT4FqCBKZn4l+86Uu2SV4BYpG3RJxQ+zRKLhdI4/GH8Hnfs6XVXEvn+C6J3Kiq2zNSpsUV8C6LDzdyU+0DzNH3O7kBg0y5x5MAut/2YyVh476iyqnvyces0WRbd+sRDCnaLwgp1xQRWmXDmyENQo3VLUKCAQjbs+FEnKXADBKQM+g2zCAoIJemmEM9otC6RjbK5sfj6VCAn1rVXsSEEX6llz3hu4RsjmHmxNKChW+HXJBy3P/VH0w6+k0Xwn75vBQVgqEVYB9cwTtq014WeKevzRllE17uhOfCwVh+QDEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun Nov 1, 2026 at 9:49 PM EST, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the rollback.
>
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are unknown,
> undermining the checks that prevent freeing or unpoisoning such folios.
>
> Preserve the existing flags instead of resetting folio->private. Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap restore
> does not leave that flag set on a folio returned as surplus.
>
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
>
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of =
raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA area=
s")
> Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b=
258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/hugetlb.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


