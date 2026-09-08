Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFAA4C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C856B00A2; Mon,  7 Sep 2026 22:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF5B6B00A3; Mon,  7 Sep 2026 22:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937856B00A4; Mon,  7 Sep 2026 22:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57EA16B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCA29120357
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:54 +0000 (UTC)
X-FDA: 85189082748.27.E81D6BA
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1C03120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=STZNLkkP;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3OGvdpd4OiovkXh5tXxkNQnwhyLzYKAKygHFZGComE=;
	b=hRdhwJOP5u+tD4N1POIUM5L74d4lBLmzhlZa0exFtgiOM5Jhmp2FIFaKvU/YbK8V5JjJoS
	EVOrRPm2Dzllxh/YhDfjf8PTTZF8i7QlgmexKf2zRMTsCOZC1xicWnFUFNGxwUA12Slmro
	xdnzo58VsrVUnjxcmTU22ycUPwt1zuc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836212;
	b=cNTGxRRbsGoYYFNxBIFWpfEPkhTfLgaWgsiWnQrN1LaGPxVpVT4xQCLBSOVaPiygbar7qj
	Z4ck1yXIRoMGy/3hbOfk07emYf5rtnLZ/MfdfIiwsoy+vjsm/wGOuLnM7vgaSc5Z9l5TK2
	1MLUDvgNFZySYQFdfg02Fp7BE08eSE0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=STZNLkkP;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlF3BOEzRr/E6Q/mzXpd3HomY7QvU1GySAzsbn3Jx3cXQowaxfizug27FvLBIIPMUYfMFE68mIHUZ9DsyYn0fLv7DabK6WLRmSKG3PcVO70VqdWRNed3VnyGKKGna4J30GSIRzWyAPGuFfegz/Lwb9+BOXL/Q34rn9NbeZm2pcETbbKqdpqwriZR1nSl5FrvvyjTJXdPX5+ceLlG0gQ7989jMdA3cYybFmZxPHqCm2fG6acMzqU31QdugQkfnEktmsrUcCMeeKjZPAvfIoTuWhiELlgLlydK56J78nMO83oAg+RMrvWcglOJOLySG+qcNdUCSlMuj2qWsQNQIFnJzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3OGvdpd4OiovkXh5tXxkNQnwhyLzYKAKygHFZGComE=;
 b=mOKJxScTu80rSlNf21gQo+C49MG+oX2jycQzIaLXDyGUIPFhu9q7QUSAk63flT1BWEvMfhOr/n/4HrvNasB2sZsavrJTdeKMadAgqMOfnjPOR+8Mp9Hr/8aF/xwxzeyf/QImQbsElkMlEmKYELXxRuafWqPR8RnhAr44DJsE63Y2XQtPEVHmht5AhCtsvqZvSVVRH2cqmk2iOH3oLYgT4CZpz1KkF6uoBXRn8ogGp16/FeunTG9kPiDGuhBjJ9nHyOkFVnqwTpyE7djs3171W/KQyGecZzGDZyDoh6JaawhKvPAsZQNzQnRc1uLLRKCxHvANfEeUcVJrdXUR0PuLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3OGvdpd4OiovkXh5tXxkNQnwhyLzYKAKygHFZGComE=;
 b=STZNLkkPDRmgZh0r8zMOtnIbVb5lUrmN5wzVXmP8NgoKGU+14ZjhX7DegFtgkK39HkLimShxFsvX5gqihtrOZGhIOL0CmqIa0BFVNnQsKcMoEr+qgBSkJnAu5Gu4QWyOijjEcpSWcgpYJ2gbDt1kzZyPdYVSnOpYpt7I9vTPlV77NmUnKIaGdq8+mBKCrteuUfJpBKbnhQz+xOtjRM0fJEVTqep8zCMASGuONxMhOrzSFddftEbpm5pSORdo0EBjqJoAZIn44/2EfJhsecEoL8Hx32EkvkjXzz6rANMyzs0bynjjxGQ13vmiOEm8WIhQTXDV21LbFpVrsdSyC+g3yA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:39 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:16 -0400
Subject: [PATCH v3 09/14] mm/page-flags: check page/folio->private instead
 of PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-9-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0228.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: fa00bbda-88c9-4b53-6355-08df0d54cdee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|6133799003|5023799004|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	u7y8AdCrDi2QW87M/rFGHCAZfPEr0z3oBDdfVeoGiZOeuZdlWD7BfmfPKseH4Rf0F9ltRgbCBbZ5uXya69NqTBoayQ3Ss+VzErO3pPNsF8ZX3kBBpEGqZfKnumwPwBnUQFiXzzj9HvFabMcnZ/cyaVcsIJRnwy8kEk9qeSsBbRBuTaeHOdqnoKtbawVQXcVgyCZq7ZajjebqY620K2C9ZCJ5rEBy5XIeX4LXmkBU2K4Navhmyt0exbX+T/P582NrcqxiGgVfbNsf5YFKVIX6H+5TfRrhDGtvc+UTdeLiuDUsBlvtb1MwPaTXIcbM/QoOXdccQf007MKuQUsbRzYHemsY0oypa9NQbeEtHAUD7qi/Cbv7b1+7QrX6Ul/T7oiRP4GBHiWgsHez+puIjE7fNDsJjrhr+vjNxUC4YUNWvipbta/2qGcAgvxoGdRmLBy/9Pag1utY7C0CZy8wbPXPJ9VBWvFn3nWculcaNVk2R6xspfLiGUWNow+5h+qwaRI9IAOGyBcuy5eIKeks5ndwvcZaLVBI5QFojS6Jn3BBbz+51UIv2wzb1ph8N0MSZ+v1ul15O+EPAh8iN/Z3VTMikO2jDQIkOwCC/nS2fIFevR8Mu+7qGhKD/Pp5y97aGa9RpUHNSLJHT74DVkEXEkCfxC9+r+jUfsM9y2FXIp0OormjoD/1wXOWWjhKYmuU9ge77So7HAPOT6fu7C50jJVBGQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(6133799003)(5023799004)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDJBMEgzeWR2SUc3WktYVThsUWx2Zm1jWll4VGpDdkhWcFFHWW9lRGRSVDFM?=
 =?utf-8?B?V29ERU1BQ3hJRDl5MjRxa2pFREFaU2pjK3JOellFdldxcElTRjYzRC9jV21n?=
 =?utf-8?B?UUpxaE80OUozVHFyaDRPQnVlYzJWa1F6dHM4MkdoL0dqaXJtRkdGWCtLZEFa?=
 =?utf-8?B?Z29OT2RlU05TYTJpdXcxVCtUVE9BaHBhdHlZUm5kcU5jdnpaZ3MxU3Z1bHN0?=
 =?utf-8?B?NjVmMWtDNkVkMTJWWVArTE5tdVhNeXJ0aTh0ZWxmSWhXeWp5b2E4Wm9WRmZC?=
 =?utf-8?B?SnNBMHh5N0kzcDFmbVBoTUxYMnJvWi8rMTB4dStJRXRlclZGdTVuSnRQbitE?=
 =?utf-8?B?VVhZNFhqS0ZLcWlVbW9mKzFmemFuYldMdnJ4NzcwOVFtU1pjUEhSQlFHdEJn?=
 =?utf-8?B?WUU5Z3pjYzljWURuS2xYN0FzTGVXVXNOWGZ3RkZFejZLOWhnNHZpY1NLY2pH?=
 =?utf-8?B?UzdLRGkrTFhUUElOUkZZZnA5V2pCQWhReDJRUWxWNnJxbjBCYXJWMnFqM1FK?=
 =?utf-8?B?N2hhRGtCclBra0RiNWI3c3pNbmJsTE5PaGoyNTVuV3pKbFZDa1RkUnF0YlAw?=
 =?utf-8?B?YVhyd0oydmREY0s5d3R2NGo4cmVQbDB3RW9YN2F3UWFZcTI5RFVVMXAvOEs2?=
 =?utf-8?B?ZEtmNTZUVWVQU3RISENRakxDZWVLQ0N5eTVxcHYvcEFMK0RTQ3NQcThtSWtm?=
 =?utf-8?B?cW14V09XL2tQRnJTdXlNUzJHdFFkRC92d3dWS25KekQxdXVDVTl3QWNLZkFM?=
 =?utf-8?B?RWxOVDUzK0dtV2NJUms0U0p0MjJZREFLOUpXOXBkNi9NdU9GUG8rSjNRdjJz?=
 =?utf-8?B?NHlUdkQ5Z1hxNmx6NzRweVowdU1ndWhQNlpFMTVkbCtWRGthLys2ODM0ZXIw?=
 =?utf-8?B?MVZ0b1ZxWGRNdGI4SEo2d3VCMGhtam1YVzkyaHRHTzd5RWo1a21OdE1zdytY?=
 =?utf-8?B?Qm8rU1JwakEzeGlVRG9aOHJ6V2prSlZRS2RMR1haRTd2NEZsd1BkalZzbjVJ?=
 =?utf-8?B?YzFNaXZRSm5UNWcvcDRKNXpRUis0SXNlOHgzNDJVZVk4aW1CRjR2TUJqMzdz?=
 =?utf-8?B?UnBtdit3RFNaYUJ0blkrS0FHWWtBNzBmQTd5NGxxK1dwUmJrMlkrODBFNXBs?=
 =?utf-8?B?azJxUDYrWlE2b2p0ZjNKems2NVpQWDR6ekxoMzV4R3FWa2tDS05ORDRHZ3h3?=
 =?utf-8?B?VFRhanJvSWx2ZE9wdmV6OXZUd2RJb1RWT29XMHBianlldXBGQWtmZ1FkS1Fs?=
 =?utf-8?B?UDlhZUxtdUl2R1JITE9UZEJ6MnA2WWptTTdTTXFxdzlTSzF1NUlWc0FjZG5p?=
 =?utf-8?B?bG5nN3Y5SHd0UmZ5d3h3SU5CWS9rUEt5cDFMWXR1K1NwQjJsQzBIRWZaekYz?=
 =?utf-8?B?a1M0d2xqS3QzTTU2TFJyR2t2TlB4bFZxeU1xeHYrNUE3VVdPK3c5TkNNMllH?=
 =?utf-8?B?UzI3UzhXY1NSUFNFbGtYR0VWc1RiZklrK25xcVluM0NaL3k4T2ZKSmdsVlFC?=
 =?utf-8?B?N295UW1hWndsb2lBRGRmWGRzTERDejRXaHRDNjl4NFMrVHF3dXZudm1YSGQ1?=
 =?utf-8?B?enl0Lzh4VldvN2hpSllIK1VwRXZpM1ZxVUxmbzg5UDVBYUZBc3ZHQlF3V3Fw?=
 =?utf-8?B?elZVMEwrendVZmxZckN4TFJWZ2tJb1BOL1RUaVB6aSt2cTFLWWdYT1ZraW41?=
 =?utf-8?B?QVZMRGY1ckRhdDVuRnUwb3BIaHVkZjBCVTdHeld6OU44UVNVUExKYWZaL1B1?=
 =?utf-8?B?b2NIeVNpd1RyenNkQTJuT1BHQldINzVLQS84UDZZMiszT1diazVhNHdwU3VS?=
 =?utf-8?B?YW9nM0NGZ2ZlYjcyRkZlYXEyMXJ6L0Z0V1ZEUUgrT2Z5emVYalVucFFXODRW?=
 =?utf-8?B?cmhxeERZbFE2L1VtR3dsbXprQktSQW5KbTVUS0tVWU9pdXQyS0ozc1YzeTRz?=
 =?utf-8?B?N2xTRFgwbmpSMHh5aXJndFlPaVgzamZRaUtPSXhhOWt2NTJCb1hFa0hNMG5a?=
 =?utf-8?B?OERPT2Z5L1RkZkdiOHErZ0NuNDY4MzJscnVtSGN5TWsvVHIyT3JhVEJUNExi?=
 =?utf-8?B?YmtPS3Q0Qk5xM1R3c0JmSE15dEkxM0Z0Q1Q0WldyWUhOSWZZTmtWdS9SMDlk?=
 =?utf-8?B?UUUvNm5VNXp1VDg1Tm1BVE92ZEhJY3dCMUJESUZ6V0JsaVRZeGVFUUhkZDNQ?=
 =?utf-8?B?WkczaHpkcE4vY3FERmlZTEpRRm9GblZzRkwycytuVzhMbDJadkplTUpwcGt5?=
 =?utf-8?B?Z1dKcWhWQjVNUWErVnM4a3dVYjc3YWdKYkxCZTRKK3ltLzB2RlNrQWxQK1g4?=
 =?utf-8?Q?UoQmuLwgijFvk5p+/a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa00bbda-88c9-4b53-6355-08df0d54cdee
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:39.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgiB4vBhYTOh6T0srLAkcDVFYNq4zSPHnzczV0qhe+GLqIP1mZVrl0f1boQQDx0K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1C03120004
X-Stat-Signature: g3qjmfxkot8qm7qymz317re65fkic97y
X-HE-Tag: 1788836212-795898
X-HE-Meta: U2FsdGVkX1+DzkOGMbKcDwxiqnitx5L5eocYxvhTcplxcDrL/9YZIN7s0l0oRUb1aDAHmlQcUexTLWfyohlFV1x8MaCB4/WT9MYBZJpxAzBhQole1Bml75AtLWpsqBJlfrre8/0siwl9wrsWbuKd9DiLYrnKr7qWxuLDxJwcyOmzzM7Ju0nCL1CHb3VrqB3IC80GUFSy6iUpA66ZIjJiVi3C6SRcampYXvd6xm3EiM7aoXY841sj/ylUP5lg6awPzMYeElMLVEEV6xPjEm9KxhxqQ6FZUgCrcd0u0Ig08+A8LgoyKqOs5tWMKBUOKRuxx7/uTc5GDK0fIVAd1NJOf5y9vK/owuCpQosXBIuj7kxXDCYwwL/uFL3Bf4PY9SIHzfIIAoTicZFK3eIYguIZDnDYKzgOSbAQdcVFbHCYwIUUZT9sA8i2dU0xHaC8heIGNNIkeoXh+NTM/xC+qme4eizyhX+Qk0kZZxZl95ZkVmJZBy0UMeo+N4FDX+njT7g/sstnFiWv1klO6A6rtMoHaYyHahS9f88Y1VZ7eyIfGlOQBMwrZO7Lp+hBdikbFIVglGXo2QMwjmQNXu4vEMKBwHaZiAM3WEEfqkObeKYkoN0M4MfdSlWH7P+Bwgfi5sJ2DzELmaOSf3w1Yzr4lS3ChM0ERsIjhxE+GLYc2r4P1bMrMNAaIzrhL3q+lLyvgtzT0TiZEbAwNJtfDr7e/EgfFBXmApwzTg81f28BN32vRqahzWjDM/c+YlcsP6fIKf8uzP9cUIEsj09PhS9UhKFsgoRyp8cd68Zd/KULNlNjgFahGnRFW35cTzQadm3YEtxfNVvqaxXLNd+TRAa0LuwjDQPCF4kcBT5I+AWSHRhdvj1z4+REcbTLEnDEflkWsKsraG4B4pu3dl6qTdWmuAYPKuZDed6o7B2f4jpT8YLglE3pTDmAI5aUWbRUppxY7G7x7mpXktGcgh9BKhZ0RXn
 mbbk+ITR
 4on/vwEAEl4nYSMPvP03t1/G4QAz4KNgLl87amJrikfkQcGXqk9triIMP/aYM7vkrj+Q5Ju1dRIHDVSzRmWk+HrUDTHShFvLQPH759COoJLUhRzmY1FlTWAYHVId/6OVM6NOPqD/6WRApPEDTy60glpBURzm45IZ8pKOLw5lVJAArPOzMlQKBkGhFUMFLV1YB38a2be4MZlbWRGV8B+x1kLum2F+9XOiDCIa+k4ueJYjARawB9DxC2BB8VxOdpdsLqFl3Wt/5JGQVYmzofg3DURpN6tl3Oi+G+126nwIC99cSy6U51HZ5PUN1WpW9fYq3ElVZUtauUUDRzQQqE4Ciz6zzIelWThD46rr+r9FxhZ6DDjir1+CKNFKBvEHCdIt70Tc0/yXOQNfLnBex7RqE+ZSzv56ZgJoUxnUtXUXsozdLWT5w0lo0rAvATbgpzbgN22db0xft+KnlX+FPLnb+jCdjN0DopMv0cuERbneiW6y3yGHjANWczy/3FtT7cfSHE1HaJwzyBQeQ4ylELn403J7NF0ycbt9Nmz0QjXJNtWRt4ZcYpMS8Pi4M6kIwzWOXQGKDMzaPBm3uAZSYd079YL/PHQAfOjLStwpOb0LNvATbNQPIpV8ZoL+01UeVFbg7wTjhynyqB9cQpNTnEeqx2MGHzXQpKSVvV5asnHubwKBTxp36Qsw3evLfPEWyizCuUupVIZqy3VgYIGEdQgKZuPTyFJ8GvgMMa7hIDFUS1K/4CidzvBHfEjf8bN+oCTPm3g7NRyTIQFikpZtZmVCQFdpSyhkgNTixRHW7x8tjhdrD8Cj6mXBVVhU6T6rGkGYi0k8oPrefJq7BMRwr3nUSOauPoa39mi0vjOlN5H3gRd4cRRnmZQhnIQD24CpjC+pamLVZg1MvdD/NKd6B2hM1sm2lO/rJQTnNKYraerXzhp2KrS1fB8Xz+u0M98tG9b+FUy81WK/8RSBuXnK7d27syZ4crXvo
 8ALhlIYc
 1BvcTP3bZnGS2ft9NW3TTZ47+rGh316GQ7SjMwCaeXzN2NR8c0Ku7/NeDNYArSu67NvoR5DRyuWN6WbjARJ5F5CKw1H9AyON5MuT58utGUw0qHzfUQYXnYPVNXHYFLlmSrbBd3XadDcGHBelZxFrtzRZC3Wk4xZXM3DOMVaIkx892neVUzs5s+wIG0fan9glG/u+f643lt2molho7yQycVUM3uERiRE09M22SL5185ghYWTIlARhrIAmWqlXPJUWVHBoBzlUNRIKpKvN2GtYqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After the changes of the prior commits, page/folio->private != NULL is now
equivalent to checking PG_private.

Stop checking PG_private on pages and folios and use page/folio->private
instead, except swapcache and hugetlb folios, because the former uses a
field (swp_entry_t swap) overlapping with ->private and the latter sets its
flags in ->private. Exclude swapcache and hugetlb when the code is meant to
check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
as a whole, so excluding swapcache with folio_test_swapcache() is not
reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
stable when a folio is added to/removed from swapcache.

folio_expected_ref_count() can be called without folio lock, so annotate
folio_test_private() with data_race() to avoid triggering race condition
checks. While at it, annotate folio->mapping too. Add data_race()
annotation for other lockless callers too.

folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
PG_private is no longer checked at page free time.

Remove KPF_PRIVATE since PG_private is no longer used.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 fs/proc/page.c                    |  1 -
 include/linux/kernel-page-flags.h |  1 -
 include/linux/mm.h                | 22 +++++++++++++++-------
 include/linux/page-flags.h        | 26 +++++++++++++++++++++-----
 include/trace/events/pagemap.h    |  5 ++++-
 mm/huge_memory.c                  |  5 ++++-
 mm/migrate.c                      |  3 ++-
 mm/page-writeback.c               |  6 +++++-
 mm/vmscan.c                       |  3 ++-
 tools/mm/page-types.c             |  2 --
 10 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..f90e1030825e9 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -232,7 +232,6 @@ u64 stable_page_flags(const struct page *page)
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index 196778a087c4d..fe5ab6e50bd70 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -11,7 +11,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413b..5eb8a62fafb56 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3004,9 +3004,9 @@ static inline bool folio_maybe_mapped_shared(struct folio *folio)
  * @folio: the folio
  *
  * Calculate the expected folio refcount, taking references from the pagecache,
- * swapcache, PG_private and page table mappings into account. Useful in
- * combination with folio_ref_count() to detect unexpected references (e.g.,
- * GUP or other temporary references).
+ * swapcache, private data (folio->private != NULL) and page table mappings into
+ * account. Useful in combination with folio_ref_count() to detect unexpected
+ * references (e.g., GUP or other temporary references).
  *
  * Does currently not consider references from the LRU cache. If the folio
  * was isolated from the LRU (which is the case during migration or split),
@@ -3044,10 +3044,18 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 	ref_count += folio_test_swapcache(folio) << order;
 
 	if (!folio_test_anon(folio)) {
-		/* One reference per page from the pagecache. */
-		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/*
+		 * One reference per page from the pagecache.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += !!data_race(folio->mapping) << order;
+		/*
+		 * One reference from filesystem private data.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += data_race(folio_test_private(folio)) &&
+			     !folio_test_hugetlb(folio) &&
+			     !folio_test_swapbacked(folio);
 	}
 
 	/* One reference per page table mapping. */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 86dd0470da117..9cb4d64739798 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -578,7 +578,23 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  * for its own purposes.
  * - PG_private and PG_private_2 cause release_folio() and co to be invoked
  */
-PAGEFLAG(Private, private, PF_ANY)
+
+static __always_inline bool folio_test_private(const struct folio *folio)
+{
+	return folio->private;
+}
+
+static __always_inline int PagePrivate(const struct page *page)
+{
+	return !!page->private;
+}
+
+/* no-ops during transition */
+static __always_inline void folio_set_private(struct folio *folio) { }
+static __always_inline void folio_clear_private(struct folio *folio) { }
+static __always_inline void SetPagePrivate(struct page *page) { }
+static __always_inline void ClearPagePrivate(struct page *page) { }
+
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
@@ -1170,7 +1186,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
-	 1UL << PG_private	| 1UL << PG_private_2	|	\
+	 1UL << PG_private_2	|				\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
 	 1UL << PG_active 	|				\
 	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
@@ -1194,8 +1210,6 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
 	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
-#define PAGE_FLAGS_PRIVATE				\
-	(1UL << PG_private | 1UL << PG_private_2)
 /**
  * folio_has_private - Determine if folio has private stuff
  * @folio: The folio to be checked
@@ -1205,7 +1219,9 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
+	return (!!folio->private && !folio_test_swapbacked(folio) &&
+		!folio_test_hugetlb(folio)) ||
+		folio_test_private_2(folio);
 }
 
 #undef PF_ANY
diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 36c3a90f0acca..8193f91216822 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -22,7 +22,10 @@
 	(folio_test_swapcache(folio)	? PAGEMAP_SWAPCACHE  : 0) | \
 	(folio_test_swapbacked(folio)	? PAGEMAP_SWAPBACKED : 0) | \
 	(folio_test_mappedtodisk(folio)	? PAGEMAP_MAPPEDDISK : 0) | \
-	(folio_test_private(folio)	? PAGEMAP_BUFFERS    : 0) \
+	/* data_race() is used to read folio->private locklessly */ \
+	(data_race(folio_test_private(folio)) && \
+	 !folio_test_swapbacked(folio) && \
+	 !folio_test_hugetlb(folio)	? PAGEMAP_BUFFERS    : 0) \
 	)
 
 TRACE_EVENT(mm_lru_insertion,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d1ce061601bcd..9b2a9d0794a61 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4831,8 +4831,11 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * For folios with private, split_huge_page_to_list_to_order()
 		 * will try to drop it before split and then check if the folio
 		 * can be split or not. So skip the check here.
+		 * data_race() is used to read folio->private locklessly.
 		 */
-		if (!folio_test_private(folio) &&
+		if (!(data_race(folio_test_private(folio)) &&
+		      !folio_test_swapbacked(folio) &&
+		      !folio_test_hugetlb(folio)) &&
 		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index a369d0c95c386..f6befd3ff1c46 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1327,7 +1327,8 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!src->mapping) {
-		if (folio_test_private(src)) {
+		if (folio_test_private(src) && !folio_test_swapbacked(src) &&
+		    !folio_test_hugetlb(src)) {
 			try_to_free_buffers(src);
 			goto out;
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce364..02ad49b10be07 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2705,7 +2705,11 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	/* data_race() is used to read folio->private locklessly */
+	__folio_mark_dirty(folio, mapping,
+			   !(data_race(folio_test_private(folio)) &&
+			     !folio_test_swapbacked(folio) &&
+			     !folio_test_hugetlb(folio)));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 40d3f1b48a74c..9348ebf9de882 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -978,7 +978,8 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	*writeback = folio_test_writeback(folio);
 
 	/* Verify dirty/writeback state if the filesystem supports it */
-	if (!folio_test_private(folio))
+	if (!(folio_test_private(folio) && !folio_test_swapbacked(folio) &&
+	      !folio_test_hugetlb(folio)))
 		return;
 
 	mapping = folio_mapping(folio);
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 7fc5a8be5997f..47e4781c5fc38 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -73,7 +73,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
@@ -131,7 +130,6 @@ static const char * const page_flag_names[] = {
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
 	[KPF_OWNER_2]		= "d:owner_2",
-	[KPF_PRIVATE]		= "P:private",
 	[KPF_PRIVATE_2]		= "p:private_2",
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
 	[KPF_ARCH]		= "h:arch",

-- 
2.53.0


