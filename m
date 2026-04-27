Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6E5FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53186B008A; Mon, 27 Apr 2026 11:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B486B008C; Mon, 27 Apr 2026 11:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940B26B0092; Mon, 27 Apr 2026 11:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 837766B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:51:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0C8E8D516
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:44:04 +0000 (UTC)
X-FDA: 84704756808.12.8BA91C5
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	by imf08.hostedemail.com (Postfix) with ESMTP id D617E160012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:44:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EePpFfwv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nYhz48P2LJUTkitq0LfgPhIztRbsbD70wRHyVIj6tk=;
	b=Ue8UX2t6k2EmmgJ7t9JZrlceSw7nknGXka8GUf5C6xAv/tmjI7vfNj2WCdqij3MnRxAi1B
	zMqPCBQ5FZN7ivw4pNHSwIz1MCleDvWQKlEnCuKMvl5eBO+6J4yXwWMlX7sKUfUfum0jwN
	3zkr/kzcD8oP0hiQhG/GSP0kdEQpqpY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777304642; a=rsa-sha256;
	cv=pass;
	b=CGm6CFMUpeWg8ZfkusUpURwo6q8q21iWZQ89VUWtN5KQNUBm95o8xtBeN21PKBpzJGccNA
	bY80JodxoPl5uMe75zGw3bQHBlWSltmtLptAKwK9MC4nt+13ZoRVUOGea9LSwByGiODHlO
	bzhiSBOeRKH4/GIJmbagd6kaosuE4BQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EePpFfwv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cLqJyA6h3zSBLBYD9kjPaYV8W4CJAN8h8WC0ehiNBD18Q2zjC/BXutmfQtPz9aXBtbcGgN70MsoDe5bpCDwjnPWYPD/wD4XDI1kr48efaKNwxPCKbXju97d5zSCudN8XGgdhudv7wSjAl9kvFTqivx68nELk1RqwEm11uobmy09viXsLLE7RQW7S0sj8ksaI6UAuKt1iDfljLiBEsAwipOgPr22LIBev+DP5cGGt2h6odS9btSCyKhzqW3Gdc0eUyZRbRDAbtTWHQFd3ShpbCTATiiGUtXT8tuXgZrgCfucL8R7clJiY2DK1uvRlRfy2hRh3dEapB9WBtp9yeFChqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nYhz48P2LJUTkitq0LfgPhIztRbsbD70wRHyVIj6tk=;
 b=VBCGwxSFCYRRVAFU85mzg3H52LMbUylaRfsUoUNCVjTSrwyORhMlGhkhm+R5DPUpIzNKjhs8u+5yhzM3Yc+5qlL14CHj4O08FN5IykQ3YyiM1cYbcDy/52mL94Y6oiOFHojGRPCLIADyy+UTufXmGl9BTR1RCr5NE4ck9Vms3Uu1GBCzCAJoFeHmdYR/9t6yLP3ifXi8Fn+CDJi+KaRxHCxCYAY5NalRqu4g55UP5JKjUtfcsMGRRTmiap+4Q+oNtdiTF/xja5WyP4aiD+wSLSi2bBT+FjgtSWW/cO1nwE+k6X0btjUCGk77cuywG/olCSNOaAWWc7TtXygX/PafbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nYhz48P2LJUTkitq0LfgPhIztRbsbD70wRHyVIj6tk=;
 b=EePpFfwvrQUOXmOws/vtLWx+gv4bMhYOPXYYKetxzw1QxgGfkeQLqmIF4Bq5ASgb5MVkWeVj0FBRiXUpSaa6ubRRhVdmqq4632W1bYon6x/7Db5S8FumWpj8WtDmI2tadRc9fEPqysUm4MMFpAYWglVdY2sGMrRLI/DV+teO20kAnhikKgiIzBpyTgeFxWTCkfJXBfUMPNQCOKiKfryDrDNuTz301a/Qi5W2dl/7RDituyzUwC1+tHPqVkDK7WtQR9ijTuzxKVyhyoc3EHLr+yDMpmLmMj3uienWvctBvtSkl4n7gIJTfF3uvZJZetdcbd9sA6IByaGgOWNt3Sx2fQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8783.namprd12.prod.outlook.com (2603:10b6:a03:4d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 15:43:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 15:43:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/page_owner: add print_mode filter
Date: Mon, 27 Apr 2026 11:43:49 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <41EDDEC1-9BAB-447D-AAB0-B8B22289F19C@nvidia.com>
In-Reply-To: <20260419155540.376847-3-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-3-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SN7PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:806:122::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 103eb267-1f19-44ff-1bfc-08dea473c8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18096099003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LKEt9PW3UOZbtdZm2HyChL5rX4rEZcEE9hErkV/zknjNNqfGjileVUJPaej9kUG6iGrx8ehswMmV6IvNqLDGKenq6cW/gfACcYEOFRUmdV3uoh9AwCau7IbQquBYO6vm5ighAoXHSVjdPX3Jd90Eerih+PEPmq/8k5qWoXpQFqkkcaVrVeLMrZpXoS3PgP2HxuNuvEMLUBdpWa09UM2B1cRmDiIhUqEp3fmpjVtehrS80G4wW0ptgBNOVXORyEN3LSSYLHTGSKTFUxuyXsFSJZkMT5mPetA5Q9sqIqeG8OWGpM2wA8oS5MxbuWvP0Uu67POYVy5AJUaRRt6zIDT4SYyOiNxVg0Y71x+6cHm1InY5uCOqx29Yi4eRVacqDoe4mwgX5bOfLxVibu20mgNBoOOzc1DCQULaxObStQ1iRrZl0B9W6H5U/uPjbD2C9iLgH3zUVJhv9wXSpyvcNLfqbJVrL87TjXnZ7lrwb8xbsoIK1XE7R30zP75Fx3h/4Ta3xb2LWZ5G6NbGEDwF+plAWVd4JuwiRU8F0JhE4zC87Up8tiIDUfAnZihVoBDrJpRXYus4h5Q/AMhZqw2DNCOHaiIVurb2IMDEOg2hxECZ5RtZ3LtyP5na+8RulE06WKdKsBZEpmsXgbmcu45VXfieECpgj3pIKHvzjQ+5yPvaYEll5w9ioAECi1yaeJEzU9R9VO6QKBPbIXRwJDedO9TVaM1rtaURg7k7H8nXN0bLbVeEN2lqvToZa2aJ9elrlvvs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18096099003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTRueW5EQlZIT2wxWnNUcDNFTGFvY3RLdi9JNUN5TFgrckJrRlZuUVRqSEk0?=
 =?utf-8?B?ZjMwb0tyS3pJYmZpQzNpQk5OVHBnT1hiR0docURQQ092NDlZOHc4aVZwd0J5?=
 =?utf-8?B?VnVNbHFtQzFFYzZudnpmMGZOa04xUGpyc1RoUm43ZHZCb3NsL2Y3NU56K0Rp?=
 =?utf-8?B?MmZ2OWRBSTZXVGIybkZNTE9YN0hJTEdRdjFkbDJMRUEwNHlYU2J2TnJSOEZU?=
 =?utf-8?B?alFEYzBKUWdSSWxJa2ZlcjlOMEkzajkwRmMvUlFuSHRDVlpTb0tqS0ZEbm5V?=
 =?utf-8?B?eEFjWnZ0QnR6bkNIQUEvb1VWOTd6b01XaXNRRGx4UTdlZXY5TkZQeUNoZUpZ?=
 =?utf-8?B?N0NIK2lyZ25mOWRGQWI0OWNjUkhpRnlqZStZR3R5V2taMHFxUjMrWW5XMVBl?=
 =?utf-8?B?bEpqOWhhMkx5R2VwMlg5NGVvcDRDWm9YMnhDOHB2NWxISTZTak1STFdiZWh4?=
 =?utf-8?B?N3BQUzcxdmJGSENrc1F6SmR5QndDbUkwOXRmNi82azdjNituVTJ0WGdaYm1V?=
 =?utf-8?B?QVNnNStNU3hwUERaZWFEMkJrNnlRUVllUmlUMmNrV2NxZW1BK2o2TDRkSDFW?=
 =?utf-8?B?cDE0TVQ4YWJhQ3J6SnZyRGRUdFlCbEZTV3lJY0lGcVZ3dkMwZkg5cEhiekVZ?=
 =?utf-8?B?NFowSzA2bnhEQjhHaisyT3F1TjR2NW9CWCt0MVNCUlRudVMyQkNHSkxlMlI5?=
 =?utf-8?B?eG5UTmVadmFoREtqUVRrSlJPbVBjTE5LYzMzQmNCNUJOWHFDMWl0dFdsc2JZ?=
 =?utf-8?B?czJOc3VNU0RHNFlhdXBPQnQ0TlJIKy9qTGJod2tJMXhqbHVBVVdhU1pDbVNQ?=
 =?utf-8?B?NTBpOWpTcno3SzRRWEw1NXZodXZnMHdFUHlGY04zL01YLzVyeXhWOWJmdmVH?=
 =?utf-8?B?dTA1aGgyQTloZ3BPeFpTdnEvWUswdW1LdHRKRG5FOThyNHYwMWpEWGtzQlhQ?=
 =?utf-8?B?M2NTT2o3MmdGZmVVbVlqQXFDcTVHYWZxVDN5dkdJclNLRkhpc0h1ZlliQm56?=
 =?utf-8?B?TmlKVjlnODFGRGhrUE1sV2xpR0FaVGRhSy9uRVk5cjY4MkxtMW51WkVKVi81?=
 =?utf-8?B?UFQ4TEh6NmcxR0Ezci85bUs1Q3dMclV6YTB0UVBoaG5vWDFOS3FmeVYrUGhX?=
 =?utf-8?B?QlV6L2hHaEdoWlM3dUs1a0Uwd0hSME9BKzVIS2VaS2RVUEZ6SCtlSnJBd1RT?=
 =?utf-8?B?ZHppdHRLRzZ2TmN0OWtnRjRwTks2aDdYbjNMVzF3ckVRSXliV1czN0NHTm9p?=
 =?utf-8?B?c1FlZWNKN1ByNnFTdTAvWlZIMVl6NWVoNVJnTlJOdUgzZWdSTndWcUVVeEVF?=
 =?utf-8?B?dTRDR0Freks1MU0vclFsQXY3ekNFakVocG1Pdm51eDQ3RGZUOUduOU5wVWNi?=
 =?utf-8?B?SUY1RXhIYzBmMytJWllwWDdCaENjcGZ5Vll1dWNuVVNCWkhQQno5QVFrNXY4?=
 =?utf-8?B?NGJhbkVVdndqQ1JxdGhwNjBUK2c3WHlubGRqeldaaGMwNnhTdHFiVVUzUmZt?=
 =?utf-8?B?Y2s0alBNZHRmWmJwQ2xzYWswaE1nT2pkREZ1dmJyYUcyYkl6NXU5TWtkNkRo?=
 =?utf-8?B?TVZRRkFNSjJWdHZkUUl0SzRaTUdJdUw2akNyUUI2QSs2b1BXbDlZdTFpN0FD?=
 =?utf-8?B?d2crSFBkYWZaMWNUZmVVQkZpNUR5Ym1vYnh4djRkV2lOalExalplMFdzQVJw?=
 =?utf-8?B?a1lwcjBqRzgvbUdnWFNyNVhRTzFjMFlXUERxTTZ0c2ZScGtXZCt1QjV4WDdO?=
 =?utf-8?B?MjgzT2ZJdHFORkpjY0tUK2N1OHVaNCtJZ2xYclFzcUJNV2tiNUtiRFdaWWZa?=
 =?utf-8?B?OEIwQytWMG5YeFhVUDVEWGVYNDY2ZHhxdzFOekRUcHFWNFBiWWxJbFFpTlpV?=
 =?utf-8?B?dThrSm5ES0d3czN2eWdjdnVMODEzY2xncXh3VFdLcmhvWmYzcFNYbFBUM2g3?=
 =?utf-8?B?b0lITlFxbDBqb0dxMGdmNTQyN3BzcFFHUHJKRlJncE9SUlFZNW01ejhZa0V3?=
 =?utf-8?B?TnpCU2tlUld5SVJTbFZWbVIrc1hGSkU5em9GWUpjMWpLd3VIM0srQko2OVhX?=
 =?utf-8?B?MithWWgxUGZDcU9lZTBSVGZCZ1M5c0cxOWRrNVk4WDdhdzkvcHhNZHZSR3Fw?=
 =?utf-8?B?Z0srV3pHVEZsUlJKK2FPUXlrelRGcTVqOUthNG1mTTFCREtYT3V5dU9PWUJE?=
 =?utf-8?B?S0dIYUNtblBUTm5mSGNBL3I1U2pJWTVoZXhyR2x5bHZvYkt0RnpTVmd2anJQ?=
 =?utf-8?B?YzRCaHpiWFAvdndKRWx5UkN4bGtnZ2E4eUkzdjAxTEgyVzNhcXVoQk5WV2lD?=
 =?utf-8?Q?AWIVPLaJ91M+8ufFw1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103eb267-1f19-44ff-1bfc-08dea473c8d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 15:43:53.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKcqx0pqChBrr7SEXWK74HQAfLtuYRBeMGZ+z6UV+QstFSJRP/8yBnrlcRIACB7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8783
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D617E160012
X-Stat-Signature: hfkmaxq6knpisnnzgtfn5dmhyz8thust
X-Rspam-User: 
X-HE-Tag: 1777304641-561329
X-HE-Meta: U2FsdGVkX19O3/QTVauJzvj6+vO4Qh1dpxH5zIC+rhe0DfWNk2LHb2YRF+84z+MT8imxmJnhGQcg3QdDNwXJOug0tGRI1gtXu0MyGrRBbbRzfKPLh5etvH1XF4uT5JsMeeRcJUsF0rFl/f86ki+2vZlelUGZY29xEsTyF0z7ywn9lZ+ZS72cTdUlthIFz6pRHABXKLtOFKQ1soYmknFDF4lUpb5SmPbROFpWOFMMqY22TkW8wYIOu3IY3fcvBMXWzoWSxMWehrGPwXURxH45lZmMWbD2x1u8WVRl6JOU0pyHhrPYMqzwubnBwl/rQuRWQspgRE+b5eloCpoDJlcrm46EO4L47qYkvWW79Lx30DSl34C/g7kILQO1kVXmrxx8XjXGFEXo8y7ueM7iV0isHW7ZjdIZ4xj1gY68Rj1pSXWPJJzTu+akZS+oiM4oFhDNe4AI4R9I7iHX0gL0JoAX/DDkUHPaIBoOk9KM8VvU/BIPDhnq2YsJfMInYN22RNh9exUu7dIiM5g+Jxd5W9xOSoMA55UNnQwWlb7Od3R19Ksgj1s1eF/AaKBrAOnyuG/ePPBRLpARnyx0VsUwvbBuDo/2GXpHDZaVa/x9zChW81dO1/HvEooc4Easplj+DyAy8tnUxYqGa46BrvN48z07DjZ0dc80yILTDYuqDDrOHVF/pgqB+m9NF0iNOKKNtQkz76SwVfplFLt7LIJz4bqtnS9lGg1NqgWEtVP6fFnrlQ+kO3m9FLnaUtGBVUIIkUY/uiIdRsvAfKGfU4A8+1XkDN000Ya34ltlqRabFbYRGM/KT4Jdot4zG6pWItMjqUDeCfr4etdLFU7dr+171N5GWFs0L8NMr5kP+QyxUglKc51/qmDRb+v0Evh9ulTmzluidNf98CzswwaU8gFidfIn30d5UerkPVR36MDH8S93ihALeN2X7FQRS++ojmkF0Xp5uuxf/cerUM3aFCo23Mh
 L2d/Zxbk
 c8zMabEocN/hqnTeOF74Oi3sq5VehShJ6owJqHKNPEIRGPjweetz/HvjBUKt9eQafA+bRMmZIGI91r4YY2KSrUUTMbw/hNLNeRwFOb5BVGuaAczzRxAjYlybPPdM6xXRHAKz71d5QvPHJi1wB+aT/aPocLGTkGFHk6Kr6bGlhXCMBno6PlgCjy2rlp/5GTIp1SCV/4xiJQjxg4JQNshtpXYFBxUH8h1/P5aPA8jjheD0rIHaqbMMiw8As4iTFyHTacnVIYkBe9Wl+KjLnOu+HKM1Jn4fjVDZd3K+ug9HYTa9w2q8Z2hQq+6UGca4r2XhoKsSmaa5gI97plfNT347+3xD7Kq6WqT6re74p/yQrtlmhLqseVhpRQ2YLy2nRr6ze7ZkduCmo/z/ZdXMrn9Xqlim94sOQ2Qwzqi4rw8mlaUKW/34DPpw9LW60CaTRb+nXuV+WBNDZTz7tDr6WyTNrJDsV6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Apr 2026, at 11:55, Zhen Ni wrote:

> Add print_mode functionality to reduce page_owner output size by
> printing only the stack handle instead of the full stack trace.
>
> Example output with print_mode enabled:
>   Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>   pid 1, tgid 1 (systemd), ts 349667370 ns
>   PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>   Flags 0x33fffe0000004124(referenced|lru|active|private|node=3D3|zone=3D=
0|
> lastcpupid=3D0x1ffff)
>   handle: 17432583
>   Charged to memcg /
>
> Print mode significantly reduces output size while preserving all
> other page allocation information. The correspondence between handles
> and stack traces can be obtained through the show_stacks_handles interfac=
e.
>
> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@eas=
ystack.cn/
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>
> Changes in v2:
> - Renamed from 'compact mode' to 'print_mode' for better clarity
> - Use enum values (0=3Dfull_stack, 1=3Dstack_handle) instead of boolean
> - Update debugfs filename from 'compact' to 'print_mode'
> ---
>  mm/page_owner.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 5884d883837e..6d87b6948cfa 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, uns=
igned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>
> -	ret +=3D stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	/* Print mode: full stack or stack handle */
> +	if (READ_ONCE(owner_filter.print_mode) =3D=3D PAGE_OWNER_PRINT_STACK_HA=
NDLE) {
> +		ret +=3D scnprintf(kbuf + ret, count - ret,
> +				"handle: %d\n", handle);
> +	} else {
> +		ret +=3D stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	}
>  	if (ret >=3D count)
>  		goto err;
>
> @@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 =
val)
>  DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold=
_get,
>  			&page_owner_threshold_set, "%llu");
>
> +static int page_owner_print_mode_get(void *data, u64 *val)
> +{
> +	*val =3D READ_ONCE(owner_filter.print_mode);
> +	return 0;
> +}
> +
> +static int page_owner_print_mode_set(void *data, u64 val)
> +{
> +	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
> +		return -EINVAL;
> +	WRITE_ONCE(owner_filter.print_mode, val);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
> +			&page_owner_print_mode_get,
> +			&page_owner_print_mode_set, "%lld");
> +
>
>  static int __init pageowner_init(void)
>  {
> @@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
>  	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>
>  	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
> +	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
> +			    &page_owner_print_mode_fops);
>
>  	dir =3D debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
> --=20
> 2.20.1

I think it is more user-friendly to use =E2=80=9Cfull_stack=E2=80=9D and =
=E2=80=9Cstack_handle=E2=80=9D
instead of 0 and 1. You can refer to [1] to sysfs_match_string() to
do that. I was testing the interface, but needed to look at your code
to know which print_mode I am using. ;)


[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/hug=
e_memory.c?h=3Dmm-everything#n380


Best Regards,
Yan, Zi

