Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128C9C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 08:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8956B007B; Mon, 27 Jul 2026 04:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0236B0088; Mon, 27 Jul 2026 04:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EDB6B008A; Mon, 27 Jul 2026 04:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A629C6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:00:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 383B780662
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:00:49 +0000 (UTC)
X-FDA: 85033810218.24.5BB80D1
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38EBC4000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:00:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PQin+MpC;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785139246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fhyf7h3q+YyACg92qbLG34u9pAoyZ3salYD5Ytxvrpo=;
	b=gsRsaH5QMefpDr8winHDV7PEQft22+DJV1EM5gXpZhym4hzzas5G8v/9cPyDWy+UHGc93w
	cwJAWtlI45mn05a9KojWK9srr2Uw/AIagEQ7yMnAPcSee4BAHqseuHRX+3JmWeK0kAM5fT
	T/oxbjCVdUQ/5C9JmIBONbCNq/AESpA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785139246;
	b=Yz1hu3T44DVrULmqgVWF5jcOrd1FYF07r6jNuJa7fRmxPYWlOH0mYJdCKAvHv0APh7wAgY
	lY+uEMVhk+zOPS0fAtKedNIoqEKLclg7ZhzyofVCo/1/+NGboIg08H/aV7ftq6uRBO3Pav
	6iysIDVLdiOsugW6geI9DGhocHkYIUw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PQin+MpC;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XU0kFlIFC8z4hhKfWne+9BsEAuRf1OF7rBYVXeYOaohtHDlnJHEOuEPVFd4TwTD8ro7yuTmE+g1UUiHgF66lOhJAm0X0AnWpJf02EDKloIKwRmWiS7eCvM1cY0sSWPoaHcl+D9tU+W6JXO365RhMiDFx/+S05Vj3XY4HkEScpj20pq0iGDzsQefQ5dDaQk5egOV3CvGj9HF5ox94UiqEpPlnfC3ChIFkjaQWCJXf67Ja/3kxC/8TObfhwDe29D+QvqybxP9qIT4VkAeEnpvp8swjSL+NgHxZeARKIBoorUyyxIVwyc3YEnwkfPlkY/D0YF8lFrSG2xaF2W39BGJxXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fhyf7h3q+YyACg92qbLG34u9pAoyZ3salYD5Ytxvrpo=;
 b=Lpo1fE4EPGrcDsOVZF6mIHm+3bJEM3UH/EiATGYYun0RjgYU6z5nEkyD0UefsCYJ7P7dupmmNCfKHzekRa5iXF6HOuPM55hqjaIjbX15THgynluRwMGs1GoyYxRvli3h8bglVv/xwtGaSaz2RrSGK0r4wJYpF7E4Yls45/+HQ+sPWE1nxabC+VVEgAr398SxpNAIlo4P5fuT/uSxrZ19PBPDPhBwf8WMt9ZU13/w12ecSENE9P5FJSSXYkJDp+7lM32FN55N+D0fHRyRCZWbd1p4u6hdyqRfLXqL/zSd7FV822bvFZNeTv55oxCcqECWZXnrXU+nUgSgGUJYdj9deg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fhyf7h3q+YyACg92qbLG34u9pAoyZ3salYD5Ytxvrpo=;
 b=PQin+MpC6d72UQ06oQqbGq01q+GL/8tllaKf20fiWUF7cQY5S5VMM+blkwOFWuFMOJVvrlGRg6bBU382Kdb3RAinwCaOeXgU1RhDe7XfEugLFVnHrU2f9abUN7jQs0emBCxDrE5Zh83vGoLynSw29t3UK2fY5yZjEOiA5u+YKpZLmZo6k0lKOX5n7i8X1KSRBql9v1yem4LAq61SilTq8zQvI1hxphkjKqhH5Moaw7p4hv7qQPdeME4pToLiT5/2ycbZcmFOd14xrsJdOqy6rnr8gmLfY3okdHknBXnCLzOIxni3lclQajKkcM0phgGRGXS765oKsWc1372zoPLVyg==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SA1PR12MB7101.namprd12.prod.outlook.com (2603:10b6:806:29d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Mon, 27 Jul
 2026 08:00:42 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 08:00:42 +0000
Message-ID: <0ea36640-36bc-47a9-8d57-edc886e13aeb@nvidia.com>
Date: Mon, 27 Jul 2026 18:00:34 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Arvind Yadav <arvind.yadav@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, ziy@nvidia.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260727053920.3494211-1-arvind.yadav@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260727053920.3494211-1-arvind.yadav@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0154.ausprd01.prod.outlook.com
 (2603:10c6:220:1d9::16) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SA1PR12MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 36973ce1-c001-46ed-67f0-08deebb527cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QhvRYfzcgKUR/viFyDJtUMKBuXjRJf1Dio1/Y8Ss5dxmQyAUOi/4q3/59S40iI6ydXTSrJ5O5f0U44fSxp6JgDbScSeEPGH8dXiMM4cox1oVySVjfklRF2VE8ogVOSQfTVEdoRpMdmCtBL6lfaNMHUjfgTTt2MHsJNVCaaC+A1aPvzcFLjzVXBzwGK7NBA8Ktw/6+AJq5TdXvPzbpckVmafyccWSZzdrfrfGV9vbIaVxjyacJxFT1ADfhlgXEeqk9dESyacQksmthErKQCJbAYE07p+3qr3fzz6PQEaWkOS92MALHqKoNOFfw4ltByDWbJq6SIFC+ZiSYa7G3g4wcPtyNf5LvUODWfsWDVGsGycZyUiBuC+2LsdkgbED9sbA421ai9D3LuFZ2wHOxsuyddVDhW/dQd1CkNT/lTnK4Gh3ZYhYSGXZ6YGdvDb14ds91uyGQvDsRDgLNuvo/120hZjaHXB0PmJJOjwVuPng0ZTwk2f2iF0V+f8cmf1ZW5N7s0l5y3by4BpPcrSRytlAuK7H4azo79FgJtXDWlqsgu4GmBMqXuMiXoLxv/y0OlXAZvBLnGPIED1tg6qePWve7nfioOY2XSPgErBlGtnpJpSXqGQ6e04M2VVPqEb0dyu05GPtbTJZZAVb0hEJHZ8BqB2TsZKo11SpuREOj/WwcE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NS9JaUVLTGVTNnRVSVhzQzRUanJJZGhzc2RCYk1USXdvTlZWSWpLalBlWW4v?=
 =?utf-8?B?L0tjaWw5VDJTeXVuUXloTVdGYyt4Um9CeTBCdmlCcU9STitUNmZCbFpWMnNv?=
 =?utf-8?B?eFM0WUVNOUhWMy9qQ3NUdUczalBNOUt3ZVBteHlJSmFtUmZ1OTN3K2dISi9x?=
 =?utf-8?B?MHM0TnRsT280UytjSWdjUWZPTHZlOHhiSGV4R3U1SklCN1BIb0YzbWxpa2ZG?=
 =?utf-8?B?VkVzMlg3aEo4UHVRTS9GVkk1M29GTFBHR3I2L20zNkJuWmhMU0QyMm0vU2cw?=
 =?utf-8?B?UnlEbHpLSzk4WTNWNnNmVzdUWWVwSFRWSDk4OGpGY2Y3ckhyRG01THNVcXNx?=
 =?utf-8?B?NlRIWDlXME8xbTBhOXRPd2RxcUVjaU5vZ2lVYzRlRUpCQWcyYmNiYnZuc2hK?=
 =?utf-8?B?OU12UHA0eE5aZHJ3OVVINVFQOUlLeUZkL1ZyMGg0RG5wMjRkblI5STVyeGJa?=
 =?utf-8?B?cXpaRm9DK0tjSGpibmF5SDdMckRERnNiQzlBaW1Sdy9GS21rMHNCaG5LLzl3?=
 =?utf-8?B?YmtKaXdXblJORlZ5cUlhb0pIYndvK2pMbDBNSGQ0WitCOXF5WElqZE1keEIy?=
 =?utf-8?B?NDdUS3J4SmJlNnBucVJucjhZdlVVNW9hSUR0SDByblpjS0xRVmcvanAwMXBP?=
 =?utf-8?B?SEpGTm84RUFXNm4xeUx1T3o5cXBiclM3VTJzTzZhS3BJME5sQ0E3ZWlib1B5?=
 =?utf-8?B?Q0E5ZlVLOHBsc0hmMUJqeDNyT2c2dGg0QTBvajFGUmxlV2tPajI2d0dCNjVo?=
 =?utf-8?B?ZnVqVkFiRk5aUFMvNW1FbzFJeHhtNWFXQXFJMS8xYlAvMXZlejUzcWZWemE1?=
 =?utf-8?B?dGRtU1hPSkNOVExtNFNlTm5IUzBtYjRtVnc5Qjk2ODNKTHBNSlJVZGl3Slc1?=
 =?utf-8?B?ZFBNUWcxZDE0TlVORVBYWXMzSTJjOEJDeVd6Z1FNWmt3NklVOXM0YVdlbjZp?=
 =?utf-8?B?VzhsYVRxRmk2L2F0S1BNeEhrMEtHR2JlSUdQSjc2QnQ4WUROdzBJL2xYdjI2?=
 =?utf-8?B?NWYvZkJncTF2RzU5UnR3ZTluRHoxYjE3Zkg4bHJiNnR6djhNT3YxTFNyQkUy?=
 =?utf-8?B?aFF3cXE4UEFKWkxJbERQb1lkVXR1dnJqVjNnZ3laSWR6TUg5QVBoQjFtTC9I?=
 =?utf-8?B?WFlsSE9yMlB4YXdWUDkyRHVlU1hvM2RpY2ZIMXpxRHcwS2p0UjcrVGQvaXgy?=
 =?utf-8?B?aUZJSklPTGE0M2kxN3g5NXc3N1dETWJlZU5BclczN0JUeVRRWjhFMWtoRWNU?=
 =?utf-8?B?YlVYSlNIUmxmRkJsSlNrTVBvTFRzdm0rMU5SZ2VFRkR4WkdFSUQrdlVGN25U?=
 =?utf-8?B?ald3R1gzZkwyQUsyaFhlc28vS3F0RlpNM2JrWmgzNjRIRWNBYkNNZit2S24y?=
 =?utf-8?B?KytwRnpiZFUrbm9HV0t6NU5hcTJINm94dXI4RVBKYVIrMlQrYnNuVlJKWU1R?=
 =?utf-8?B?SWhyY3I0ejNxQks4b3dwbWJKajBaZXZTbllvZUdpM3lWWWFlblZ4NnYwWmZN?=
 =?utf-8?B?ZFo3c0haWStIZm1URXJueW5nRWRRUWNVenN0NHJIaUZ4aVhWaEo3RlI2c2FX?=
 =?utf-8?B?K0duRHVYOUMvTGh0UW5OUUZYQzgxckZ5R24wRHE5TXNXVm9oeThDZ2ZiN09x?=
 =?utf-8?B?WUZTOEtjZDMwM28rbjdjWmxyOFk2ZDdLbjF3UWFmNU9ySWdMUVdWUFdRak9T?=
 =?utf-8?B?UXB6eGdtdFovOGNqU3RJYmp5bVkrU1RHOFgwa1RMVTZDb25qOWZsa1I1bmI5?=
 =?utf-8?B?OGpSaFpVdWdnVndOYndzRCs1RllkVi9ZMFN2bnBFL0xPd2tSUmc5NDZNNHFB?=
 =?utf-8?B?Z3czV2dxZlN4TUVYRzEwL21zbHlnRW15MVlWWjhXMjhQSzhOTGhLcjNzajVx?=
 =?utf-8?B?TW16THh0WjJucENzTXdReFd2VVd0ZGFpZEQ0bTBRMnd1bkJYRUNzTVRZcW5r?=
 =?utf-8?B?dFFQaXlQSEo0dndqVEYxQlRmYzc1Z0dybmNNdVk1dlBwYVVvM1R3K1JKK0F2?=
 =?utf-8?B?NnByWCs2V1dxSjdWaS82YTVTMWRuQ1g1UUthdk5ROHBpMHdtSWtGV0V1L1Jq?=
 =?utf-8?B?TElsaTRZYytoSFdIZjl1VE1LVWhYYjVqdXhVMGFLRlJkQ1J6elpJQVU3NEdJ?=
 =?utf-8?B?eldBNFc0cHNQOW10MENUQzdlVWtzTzJ5ZVhMLzlxRWJmTTVQaG5MZUM0MTdk?=
 =?utf-8?B?ZmhYNkErLzdZcEFzQ2NKUnkwd0loM20rd01mZDliUndsMG5IZHcxWkRSNCt6?=
 =?utf-8?B?VG15UjgybXMyeFh5OXhKVE83RXpOWVlPakxxa3Zsb285QndUa1JDV1VxYnI1?=
 =?utf-8?B?NWx3SkprQWJGWDArZVZENkE2d0ZKeWo0aWJFcVV3bk9yeGhWaytQdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36973ce1-c001-46ed-67f0-08deebb527cc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 08:00:42.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ho9muDElvhnxCkJHaN1sUIm5W6BEOcHcQM8UC6Lsufxt6YbF8R5LSKxsYIPW3Uy5VHpPS0oqrbNre/295QMEEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7101
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38EBC4000A
X-Stat-Signature: yuhchxdguuh8xmsp519m75urrpeam5dc
X-Rspam-User: 
X-HE-Tag: 1785139246-769394
X-HE-Meta: U2FsdGVkX19RYedD4GAx/ArQv1l9XX48mLjyWuhhnPLodizDLBHOs7OPzwGq1iTKyVXCQsuqBWymKCcl4oHQvRg4rhiDamNAffyHebeoA1Gb2XZT06uvnvm9yJ9AhJbtDi+JKLutT3TQ89sOgcIoct1xPdlp4EpxQB2IfWDg/htc4nzwXtW8Tmn4S8b1zvBEfp7OCM8qcIQSGf2tXUeckFRzO4APMwoI56LdFBakmqP5tRmFZ7+wCl2CcMrQYYmISFDZgrry3ogB/DpgRwEgemLOEpXXcdDvWsqxSDBq5j1Hfw5GirzyElheeuVQIkbF5vJK9TFYNvEWO2UWG0arXTvImStgQ0mtiU30WYyTZjMlYOyFBDgKE+4/PTNcVbM1vR8XHP9cM1xndnmLMtbemtACCQORiOvGagr8I8VRv1/s8p3myUIqlaZS+ZYhmZro+tUZn59ehNG49AZxNFbmKUbVgFCRvRqaTaaGvCqI8BiCitT1c1ABInBXPshoPRIjmcknoAuiTBG1WCTJ/FsyD4Cb6/gBrfxweda1VOul69e7PGCYHFjei//zdSAMVlTcrEDDlRxF/JVohEIHwyQVf5xLD0ca7DJ15JSkbLqnAiId+5j6icPR7CogQnLSlKAQSs4Rgre3mkPZ0/TmlEy8YfaulCBUVgfsM1n8OzVTo3Ysv2l0eEkc/3KvZTgAJdHu875PqyfS3nI1XTgZdTsj+rveuOpqYw35b4jQlJfaD4YpWiXtWlvrSlcf+t+zYD8ZZWAPusWYtYegDp+IeHRuyW8EfBRKp8f7IQHo9aUwSJk5NhQuc/cVLowgRBodxOn4RTM9ZWmWpLoyMiePZTQ3eE5QjuMBEuiQDKEo06HsehATGNfQdZc1NqyMCQvwfa91AZgebBXxlQwZJpovEh33hZn8WJq2dOEv7n/zS5Z/PyVan93UjnLzrbCS5/pYOiowL7ymnnQUVXWmZkK7woU
 9rlBsqNw
 uIpaCKsX5IN7uKrd8RJOtcWWMbF6ugL8IImn9JKgYwQKBPgotctB7Ds/PE/VcXyIKCS7ROdPnet0I2Ij3S3WiNM8Vw5MkoVbRdnQ3BjNoNkLhsP325cZ/55Hci/DyiaHM9pGYX+0G0m0lULOvk2u1U0FTsuKSZzbBOarP7mJaNcB8OFAuVZY52JmcwsXUZq8xETO51DeOytU2u4SKwjT0d2cIlilxckF9z5NH6t8YuJtW/PbkAOnp0o6kfyqUX5NyHmbKjv5jjGuHKv4QWMmrJV1+1LlzJAYQ3S0rsRDgo0AWfeEr2RkM2NaMY8UgZqWsFRwSMx1MaAj+T8si2zwIqbUZiRugZOODWyz9UELCWnYwmdsCh5GGYgCPCZP/TdETmbsZtdi/h29nhEm530rcQ75JkKvjIcpyT3qrtcxEQyWuap6tekKSilmxQjjhDa1q8UcTAhfyDG42eU5hKDI5+bziZGEBLbKnR3o4mQkW96OdEGRfRxiiohoZT6ZCqpD+o6uwu2qTeVJE0ciCUqhpFgNlptTWjlmp1NUU0sG6L9F6R7+kOgSrG41uPyKRmWLJYaifawJdUEBXFu5nTNs+mjuf8g+yjq66MXsMkSO+eWE9QXF6uxJvf/AkS+qzOHldgkxMekCqLRiNNm0v+7EVayaOQfdBe+fsdBIS4hZr0bkJeJy0RiqOjoyuAMCuvqpAqqM4UTuTTb4roV+u1Mr2w544V6b6HpNk2ugJc6avautxWWEotT3jTdeG2qc5EXu1kGbAG4WyEhZpCuxKCwZkkG2bKZFClKnrl3aSLcIX2aFO+AapcvKyGrVqXJmgG9q2kXfuM2zxMXWFlfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 3:39 PM, Arvind Yadav wrote:
> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
> 
> Passing the stale mapping to folio_migrate_mapping() makes it take the
> mapped-folio path after the swapcache reference has been dropped. This can
> cause an invalid swap_space lock access followed by a folio reference
> count BUG.
> 
> After a successful split, nr still contains the number of pages in the
> original large folio, although each resulting page is now a separate
> order-0 folio. Reset nr to 1 so each split folio is processed separately,
> including its own swapcache removal and mapping lookup.
> 
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
> 
> v2:
> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
> 
> v3:
> - Reset nr to 1 after a successful split so each resulting folio is
>   processed independently, as suggested by Zi Yan.
> 
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..74ac6651d4b3 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1182,6 +1182,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  							 MIGRATE_PFN_COMPOUND);
>  					goto next;
>  				}
> +				/*
> +				 * reset nr so that only first after-split folio
> +				 * is processed below
> +				 */
> +				nr = 1;

We should also add a VM_WARN_ON_ONCE(folio_test_swapcache(folio))

>  			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>  				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>  				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
> @@ -1204,6 +1209,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>  					goto next;
>  				}
> +
> +				/*
> +				 * folio_free_swap() removed the folio from the swap
> +				 * cache. Refresh the saved mapping before migration.
> +				 */
> +				mapping = folio_mapping(folio);
>  			}

I wonder if we should change this instead to (sorry for the wrap around, I'll
need to fix my mailer)

@@ -1242,6 +1232,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
                for (j = 0; j < nr && i + j < npages; j++) {
                        folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
                        newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+                       /*
+                        * folio_free_swap() removed the folio from the swap
+                        * cache. Refresh the saved mapping before migration.
+                        */
+                       mapping = folio_mapping(folio);



>  		} else if (folio_is_zone_device(newfolio)) {
>  			/*

Thanks,
Balbir

