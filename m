Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58501C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5774E6B0773; Fri, 14 Aug 2026 22:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528AA6B0775; Fri, 14 Aug 2026 22:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1D66B0776; Fri, 14 Aug 2026 22:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 038FA6B0773
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:38:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80C3FC0230
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:38:52 +0000 (UTC)
X-FDA: 85101946104.25.40B7269
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4582A0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:38:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iadBY4Ai;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786761529;
	b=2cHBaLLdFk7h11zyd3V3PUmnBBxsKElsDFJKFeguMU6Nen0kIsDunCsViTMus+hIlt2opb
	UG2GOd7hoGICbsylm6TF1DY2l5DX68MO9hZ5+GG8BlJfFul0+bxkOgIqJiRhaCx3i2pISm
	aehr7/ULg4bCaDRlZotng/ewpw5D3vk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iadBY4Ai;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786761529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMlEojgIN/ZTfws00biBidDems7ojlsv3Ag8jLXvS+M=;
	b=DFVMxwv2pShfnObcWBOtQ79m2+BsCQp6ibweIbeOGQ0YZ79s/PVNxUGs8ouGGOnsdY1fqj
	gsvGnr0wGNFWidb2f24HfRwHAx6maVbdCmqN9DD7oeKkfoVbEmeSO8ycVuuYgIPZv4D/u7
	ZATJZJEvylx9cXLAaTQGseC/WLGw3bs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6UTlYttxwXrdwBxXqygcjxBD0OttytUDQTAy4jArlrjtbMiXcEiaP887jIXd+8BedYGJaOHmJJdQblul5ftBrvALh8c7ZO5kziLUq2W8Lnu71vnCZyWG+SWJiO8QLlX1hbc/QFx06EltYomz3MJWGvTaiUleHEAtcCGB9/B/ZaFmfXdx8AHKAu0oWcgOXzhicJ0jWUF63tupeT6mP9KIBW5zLY9iv1LiRmAOKX42aRGopxYTlF7jcgOt1eSUZlmvXrKGkcVYbDKjkjF6MbtRUZth7Sjcs0UOyIZN70AHFtr6G26xSTr7/Q+PDm1etjjo3lBKivmXA7V+wfeq5Ihjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BMlEojgIN/ZTfws00biBidDems7ojlsv3Ag8jLXvS+M=;
 b=ESgu/fS3K2XGnQToWw3RsTTBwLQNAv0MLGLiHuygQklctv3ApEIJeNv8fTWeCtfQ9RylaLbCnLfYMuSxQiKtjVsupFMQMRMh+I9LpYaNl/mZhzuEcYVDt06tU/UXjti6LPMeM+r5obiCDL3bPt4ZGdogv5H/zyLht9yUiF7crV2D6bkMRchsc7mIhJCy8gCZv/ImnCOvTcpToLGSZlcQIEkJr5jn4Sytx9WSBFPF1/TnOVvkmIA37ZNMZx8SG1qi7I5s48bphjMJbSbM1UtHTw9LnZWh2rcDErP/rQjzaS6cm9tAFQp7uKIQEUSYH8GlVsZi/7H0Hf6Mpvq7i9uN3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMlEojgIN/ZTfws00biBidDems7ojlsv3Ag8jLXvS+M=;
 b=iadBY4AiBsTZKwn71isoE6sPswSjxsf6aud6S2WLitI4SeoCkacZwZQbG6Z3F+4rO1kpn0ZjBaw5Yt3PSpM9+KsQQvBTK0Za3aC01cBv4Sr1jQTyZyaniNoiu2heUG5uZqZC5O/V5lLNenSmgn6E31UmCWk71q433u+jkANt5YRbaDMLHUXfhiYuqNw8IuuWUZMNdUwUn8DFz/2qDZYi1x4C6fhA3nmL9rsMh1diZ4+4eMPumOPHO71e4eGSu5+WGR3dQA3nadvv9acq/qZehS1q9BzZ8IQq+hNMFQsU9RaVHupw6nC+BgskaI7VgSarsiddZFn43wSrswPgqbKtgA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA5PR12MB999323.namprd12.prod.outlook.com (2603:10b6:208:605::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Sat, 15 Aug
 2026 02:38:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 02:38:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 22:38:43 -0400
Message-Id: <DKP63K8PH5MS.3FE98OTOO5JYZ@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 05/17] mm/huge_memory: rename
 __split_unmapped_folio() to __split_frozen_folio()
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>
X-Mailer: aerc 0.21.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
 <20260813-swap-thp-cleanup-v2-5-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-5-d2ee48c6aa49@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA5PR12MB999323:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e169ab-0dfd-41f6-7966-08defa7653fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|56012099006|10067099003|6133799003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UK70+RguLJmiaKU8WnF3dAZJTrRZSQ3vIwy1FTDNDw6UcNO6Ko/zSHrjLE8JtrdeOjFoVtBBE+MhTJ6SQ0zfI55l+z/CLeBl6efec9V3YPL6aLT0ADPD1gy4ObLOlosbGXoXVqsP4X3VHm+cc9X5+N076xk4Gv7Sixa1zMhUbHGuRW4Bls/+3I0eBx3nUD4yH0ljeIK36R2ymuE6Jd6tZHXatUWwOLNLtz++zJtRVXMefsQ14Xs/znipeGdewGALxTO1zk0ZlQVzPRxMwqBGpvMlVIFcNHgx7jby/nqZxOdXLD2PNo5Eo5z6tYTO4SoXlwV6JYc1/bi56068u2XsYVQoHa46KWAc+GO8r5yX288h4fKoTIGnTPTAirYD10UWU+Y32jzCCBE5BOLr85mIujmcfWN2z0DhSme3gJK9PLTb+8SfV3mTDBBDmaE/+xsVF6k3/jQNvHR8sLKoobktzVWT5t4a62y5iyt3k2B3v8bOYk7kep9sDVffj92eURuIjh+PPNNH97dmXvVPXzfXg0YXtI8PIZUOaUf7ld0r3Y6w1n+4SuZv0aK9gS4ndcJziPsUN4Pgk+iwEwsp7ZjhUsUwni77fn1kwSfA81V7sWdlznrBF2spNyEKHLLlFJsjrkgfRBsonMQGH5xupa+aVrGcxuu2SOB/ST24XY9ZQDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(56012099006)(10067099003)(6133799003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2l2S2ZwOUNjQ2F3UUhybk01TlNDTzc3aGlGUThSMzFQcGh2Um1DbDY0aStr?=
 =?utf-8?B?RXNsVjdHaXpQUEg0WTJJTXZ3ZWJaa05iK2xmLzdCR0FoRzU3ME1aWHFYcDdF?=
 =?utf-8?B?OThLeGhsL3h3a0NlYnBWYW9yaVRWTmdibnBLa3JCaFVwVlBVQUkyWHJ1dTBk?=
 =?utf-8?B?RER0Wk55U1lyZFhscStMcDYrOUIxeFlkSzQ2TDJnckNzaURKam4wTEFFNVRy?=
 =?utf-8?B?VTNIL3hsTWZJYVV3Wm0vSXhhaGMrQklDYmI0OE8yYXYrUmNLc0RkTElVcDBu?=
 =?utf-8?B?Tk5GQlJmZU55Q0FmNzUySmU4UE03ZkxVK3hVQlRRYnNvaGZ3c3IzV1cvdEZl?=
 =?utf-8?B?UTdVNGJPanA3djhVMXRxZS9HWWlCVUEwMTRKMkk5SklMWXpqQW9IT2tNejRx?=
 =?utf-8?B?V2RKVUVibDlveFZqRWhhdkJuNE1oYjJsV1l5dHhtemg2eUd5UW5wYUVBL2cy?=
 =?utf-8?B?SyszdVdoSnRRTVhDWjV6U2VzVHU2cHpIa2NkK3B1Q2k1ZnZidVRWQUVMSXpI?=
 =?utf-8?B?clJ6SmE4OWRINk4zaGtjRUtRVFNRSFBHZ20wdjYwWkRvTTh5TXQ1eHVhdmpx?=
 =?utf-8?B?QzFSVjB1ME5BWmJZb0x0Zk9VVDkxcm9DZmovQy9Oalp3UDNWdUJFWGNPcHpR?=
 =?utf-8?B?RGNkSldscHBzTVZuaFhIcFJSdDd6cDBIQU1iOW5tUTloTEtFRnJiaWVWdjdG?=
 =?utf-8?B?V1FFRGxMS2IyWjZ5ek5VVnU5aFpMQVRBZCs0ZzRMQnY1bE9VRjk5MnlzcVk4?=
 =?utf-8?B?MWlib2tNTDBaK2pBVWxSQ2hRdXIvNFFoaWlqWkw3V2lPdkcwVGxua21CTmkr?=
 =?utf-8?B?VklEWE9zMzBmNTROR0RDU0g2RHd2Y0RSOGNlSm91KzI0OUQ2eWRNZ09Mb3NR?=
 =?utf-8?B?UzRtYVdGK1lhbVJMOGFYZUZrK2thMFlNQ3FyaXN5VEViNjErRXJlQkNUZWE5?=
 =?utf-8?B?SmhtTmh6V3huQTNqdHo0NHJaakRYcHJRcjJlMEZISXN5QWQvb2ZDKzlDdmM3?=
 =?utf-8?B?bFR5dnNCd0E0cjNnaFp5d0NNUDNQQUJ3Mmh3b3Rwc1hZUVhXTXV4NUp5Z21a?=
 =?utf-8?B?K1JDWjBuQmZvSWRNT05aZUdkd2dlMmRRaFR6b29pNy9RNEtmQVNma0JtOC93?=
 =?utf-8?B?UEEvQmt2dGpoV09xS1RZMFo3dXpXelZUTGFLbk1NUFZnM2QvQm4xNFlPempq?=
 =?utf-8?B?Z1VBY1Z6OGJxSjUzMHBEWnY2Qnpnc3VCc3VGTy9qRmVFa0Z6SXpIY3NnaXhj?=
 =?utf-8?B?dWFKNzFFeGYra2kxdU53Z3J1Y0QwRGJ4UDFRMnJNMk9JL09jb3VjemlWeGpn?=
 =?utf-8?B?c1ZYRDgwdWp1cFlhVGM0aVFRV01LUzhEdWpJOFNubCswS211WWZiVVpwbTJa?=
 =?utf-8?B?SEQvNnJiYmEyeWRSWmo3eTFHTlhGNzVkbUpTZVJTT0NXeHBxL2lEdXBNNHV1?=
 =?utf-8?B?UHZRZ21NWFlXTkM3L0F4S1RkVlFQcXREUW5kUWwxSmNrdU9tMjhxb0lpVGZo?=
 =?utf-8?B?MGlPc2tUVHV0alc5OE9XMzdFZ0txdnhqb1VpSEVaYWhLdjhBckpPQ0JHeXZt?=
 =?utf-8?B?c0pRUEFmRDlYZ1Y3L25iQWpNZWZ3Q3JZUFljaHg2dlBUSE03UEdNSGNUYmZj?=
 =?utf-8?B?QlRzc1RmcnVkRDdSS1JxUE9JcTdyc0VWK3BPR1FWV1lEWkxud2FEL3NkN0hz?=
 =?utf-8?B?Qm5oblhTTTVjd1JHZFgweGtxTDBVdEY4dXJiSmJsRDZXZW5NcUl2UDFnOWpJ?=
 =?utf-8?B?Q3F2T1kxRXluY1l6R0VuV01VOWZaYllMRitpSjEvZnFZdWRNVDJtNWVnRWQ0?=
 =?utf-8?B?M0l2LzlmejFlanNibmgreURnUjV5ODBXZ2NjYjg3aEhuMjA3M3VaNHBLd3RK?=
 =?utf-8?B?azR4cmxwSWdnZ05YTU5GbFg1cG9hSlFSMHNJdUlFaHl3K2N1L052RWFUWDdw?=
 =?utf-8?B?SUpPOFN0OTRvaVdoeFhRTGNtNXpRSERDc3JJejExVlp6dUh2Rm96cnpOS05x?=
 =?utf-8?B?SG9Mb2ZrN3Zya3owdG8zRm5qVlhoUHBUWS9ia3o0bmlnUnJDRlRiZ2hWTVFr?=
 =?utf-8?B?SWp5RTFkNHZtT1ZoT3FhV3hnR21SREdKRzlRUFNWalo1SExrVE1waFFZMUZh?=
 =?utf-8?B?dU45ZWYyeDE3Z0VmR1dONFQ5VVROOWZXd1Z4Rk1iVStDdC80OHpJM1V1Vkdz?=
 =?utf-8?B?T2c3eVdNUFd3YWFHaHozV0tYNGo0djFLMkNseFEzTTZSejMySXBIcXYzdDRX?=
 =?utf-8?B?eUprSjBxbmkwQmZGRkFUZVNhSGxlcHR2Z2N4RUFqMTkySWpYL0RNa3BJVnNY?=
 =?utf-8?Q?QoeRTEbABl7V9yh8pw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e169ab-0dfd-41f6-7966-08defa7653fe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 02:38:45.7142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+EBjOfwTR3pmh8C52h7daY0rfGCSncpxOz2pIXFbmBYmxJPHAY80vc4S5U+aZ3H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999323
X-Rspamd-Queue-Id: A4582A0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qquwocikwjoaudn9rzb9xcg1b4xq3dt9
X-HE-Tag: 1786761529-136140
X-HE-Meta: U2FsdGVkX1/Nzu+up8Rn4h0iT7QUT/ejRWF5sc++TIjcFn/gAJXeQSyI5lDhv++Sr0AExNnZhCi8s4tWEuvcDJfqOBT8Z0T7WMcqtmuWd9vy3QNN4mkSrGaNAwsodvMTpXPI9s216kq2zpLcd1qDsawSMy/uL8/0strWhifjktZDe/fVDjM9pbunazALr60GaJUI1R1Q0RHqa4sZj64KUNN4z2kCBl3zH2HfBand2092GlZFGuLm/7fx1Eg/vVoA2UFA2zwJ26vJNTKebKKBWphH67X2t/mWBYjz6nnDwyyRcNWzE1ngFfsoaD/JP5qrpPw/tzIYuVh+O5icMEUzmwY0c+G/yRHHHg6FILC/D71Z4uV9r+17kDp4535I0ZYdGkZ/SZQDKQ3iePpbGd7y96dPu/IJ7tTpaC2YUiUm+9Zsbllnm4WTleGYXEevOuYlWzRK95bb7VvMFvXpDEdD5ZDIKBDiUhtJZqunWwKDbqlVPBzckfwwT6wjCZNZhfQhu2BxtXH8jDb19G0QuoXS2jJ/pBkCFzYG7tKI0rbdrQliSIKZfCRA7f2QfqMctmmjOXrR+N+6WlyAZmIsDv857lE9CCxOF1z2BqsviNiJZcOFbdlmF3Y9yNbv1ShDmg1LUDW7c7eGX5x26D6V+XGHhnbYY1XovmNdv0Chc6CGJUrRDYgydbqbYiZfnMqiDhbNHqyCdBa8ghx4IbsJCsBbU1+f4H9sAWRxesA+GH6EJiZOlzanzqObOhMr00NrDgcFFivEXQwZM6WDH5QLnO8tN7GFgBN2KdA5vbSfjjdJFsoQ3Q6onuMwOIySQOvuc/XNyvcQWosLvZ1H+NOTVJ3OJPddEy5FYrSp3dxkNE0DyUMX1+VAh9YlPsmC+9snuAnerAp9nWCx4yB4/HnntZj9A2moKhekcNBRxklzy8rCmfLrjLCLa18dIWGiqHt2INZB8xXzhEacl47LgfEz3Gp
 ooUO+AAr
 P78HiHtFfhX3yGsfdIgBtVivWRbLgh+adakf2wJLcWgxmdMt098TUxVlZ1yv1OCFwFv60fnEW600gs2SrcpSik86JZy/acrf5KRtdHFwpe+I55+JyoZPKgZwPc0EH8Ng2EIBAV5clPXL44M+9i5WbrRhyQr/2Tv3Not/NNnH4/HO/MwFogs3rty8QhMM1hh2NAnG1E115qawC4ZuRdafV5xZ+BU+VtqWqdNbYM87NPXkhqhS8IxJkCMw1YV/V3nAIG3CS4WAKZSwW7mFd2wVXBNAa166+/Qoc0hLJ/m8smK84KD54s6SnaWz2lAaLZjybHNF2KKr3I5WqEXi3sX6FCOrMiPYBRjVfLYL/2tlPI2hy5vUNMeJRDt6/63L3H2h19xLJrBrhVfkXn1EirKCrIQo/Wp7XCYS6zUfOkdOxcLbqzufKL1fDA70lVS5ZkcJHUp6MR0uzFKYZU5D2vDk8rRUpzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 12, 2026 at 2:48 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The helper splits a folio whose refcount is frozen: the frozen refcount
> is the state it relies on, while unmapping is arranged by the caller
> beforehand. The old name caused confusion and people may try to call the
> helper on non-frozen folios.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


