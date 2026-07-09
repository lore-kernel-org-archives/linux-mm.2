Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F55C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 05:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FCC6B0088; Thu,  9 Jul 2026 01:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C94E6B008A; Thu,  9 Jul 2026 01:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7432D6B008C; Thu,  9 Jul 2026 01:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7176B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:56:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EF68403FF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:56:44 +0000 (UTC)
X-FDA: 84968179128.21.7D300EA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id C4E6840006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:56:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ejsdvqXx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rj1AVvSm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783576601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTKp7jbezMNzsYrDeswqYsKmgZLEtdQYaeC39e/LVuY=;
	b=c5cyvKMP37NVi8eHeE3e7ORf3NI93xTqIe+SdQd7g4rIxkrLKwCuTXo1mwoJLmDzCA2bJH
	0R+1a+vU4NQU/iIObt/3bxAlpVXg2y4wMZR4irBXZwuVu7ah0b7+G8foneOuU54IY0rPho
	Ln8ve+zYkX2WjIej2E+dGVk2wuLC0dw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ejsdvqXx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rj1AVvSm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783576601;
	b=eVwXWPTtiJBZXKLdI9R7RsXqU8bnBxw0vhVmEm5c3588JfdEwMpsz4Vekt1N+sIfBmDG8W
	vY/zv5dOMDt6v6conEKSeoiR4Aesi+Z1xMR62O4CUCe2GhGxhMKTUNux3gA36CkJj/HklB
	fuTZ1r89Myfg/44zYr55CJ/PjCmCfbs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668LZ1pc3292577;
	Thu, 9 Jul 2026 05:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JTKp7jbezMNzsYrDeswqYsKmgZLEtdQYaeC39e/LVuY=; b=
	ejsdvqXxJZU1VyJlUFqRvUwp5p9wP/xlHE9Avu89SWJAD6R2PyfYuS3PLQA+Fhht
	FyHUDM7d7Gdm/3npX3XzoL7N2Oct/78wUT8SfS5bBS1pe9fPxB1qQAtKluCKidCp
	jR3FEJJYkuYxwIkW86KcigSyd8IZIxqiKQwqjHr5j56z+/CdcbTCt0Hm0IaW1/0S
	kOnSubBH8Id7XRQY8iH+LxGphQHdPXBc/7Tld069PLA+SvlHhJVa2r4NiGhtomKd
	7E742XLrDp2FGEotDGzxyJVQbqFd1UxIImz6O8DMlxq+8/Dz1UXTFNDMTKUffBhC
	6H5n9wZ9nkzBSjxuf/GOng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t2a8ssc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 05:56:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6695rstN010646;
	Thu, 9 Jul 2026 05:56:25 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twm6g5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 05:56:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRHjLgBWGxDJFIh/5dFs4qchhh0yBFE4fa7LcQNDgF51jXQUMxoQIQ3BHkX7EW1KlmM3yDudcuZa8K+FDG6aea0vwdXwu6gd7NkjinT0rNjJynZE9NuW5fJ3u06O0C06YQT+1VbN/Pm4SzlukYlu0oncVHvrd+5tomV4D/TDFMB3RySswnLv154nbeZ/Uaz3cloIGWSpZUSCugCFkCQJKO+GHeK9NMHWW4oBp+bYH7M0csAXd2GZkOHLd5yhhVkLVsy2WnE4vuamTDX5ioEAw3LcgCXI5jgoXgnOFPc0moxWsjIy7ztH6tAyLJ1c0NB91p9hrz+v4itGhlmkjHAZgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTKp7jbezMNzsYrDeswqYsKmgZLEtdQYaeC39e/LVuY=;
 b=VBFsz0fwA+8Sw2anpOb17bzcQhh/ry5tyE7uaxD3QlcOhMoCnh+D0mkTTiUMsBIQOy0fnOTwIZDfOPcLZ8ZAw4NfNqqy7fTc98egwIgqfRuKxCfrW5rrUoFzv/AyOhJTIW+twZa8T3EJbCPMy5g7enJmP8lPUjsXd8w5Jt50f+UKmwdbTv53kMcq+S/Ipy327CWsq07SQRxpijpJPX8u/jCkOH5iqsQjrrO67p1KAZmSb6moNvP6NoHiqqdmqLzyhL75yGqK1QWUUt0nxcaMONH+VEB2mZBAZLWaNOcixjAQb9axKW4D1t1IsUs0I7+JKqoB0n/M9EbdqZQeBC/BnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTKp7jbezMNzsYrDeswqYsKmgZLEtdQYaeC39e/LVuY=;
 b=rj1AVvSmGzT05nhVsBcwSb9b9JGFDyve8jHsbt4F1n4ywgVaVO8P0VjT0xmOhBkoRzhd5CJPqTwH31oqnXE9tAcfm8J7x8Fq1IJ7KMPH37Yf0dzaujIKCzrTTMoR+Hdt221lSJeEmcvYAlF1wO7uTsW3UOI+Q8XDuzZoG0L94Hc=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 MW5PR10MB5714.namprd10.prod.outlook.com (2603:10b6:303:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Thu, 9 Jul
 2026 05:56:21 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 05:56:20 +0000
Message-ID: <7ced4919-fd8b-475c-9b65-1f578ec37ae8@oracle.com>
Date: Wed, 8 Jul 2026 22:56:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Use generic_file_read_iter() in hugetlbfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>
References: <20260707181713.208282-1-willy@infradead.org>
 <f879bb87-0267-451b-bfed-a3e4b475b9ea@oracle.com>
 <ak8QiCxpNzHDKj9q@casper.infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ak8QiCxpNzHDKj9q@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:454::17) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|MW5PR10MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: b64f0224-70da-47b0-0790-08dedd7ecccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	RO6zEnYvQF28L6ay1O3ir5AcuS7vqSNt6PIcK7JlXZyuiJLArbTa1SVrPlzLLPGxcNpUGDVJc2JzBCC8UdDKN+p5KZHHqUIEhzDtR0/pZzjhnDTbmyA6YVxHMg7o6ffX7etlE4AV0kwszEgFJIUZtrfHKX3s4HYz2a4la6ha6XME+Dd86/fIZ9iKbXsjHmbEXJggXF4zrDj1GdWi1Qkxj927ihTeyh5/ayEimUx4rtq7HDMC8g+hAnCWPt7qnv4nTTA/ISEvRCC3BUZsv9DP4TXEsATFV+NTURSZ+PqrICopYUWxxHBRqqf3iBLh8ACMERR4NDIhsqXJ0pv31axqeQNcvNPj3fAlHjDR4O2HT4zUl8NytHIU6KD5Y2wurZq2g/Y6PfgB8FUhxsBZJu4l/rlv1lTv1/TUhh6GncE9B214xqcAwOAICRXlRXWfmS0gf0SWg3d0xTBNX4PIBcj1uyATFoUWpcuoVJ6zMt98pQmtDawxkiEB/Ma7/A/CuQ+bF6zTsjyNwWDTFqYmZ7ivaOP4mdaj+zUFdAjjt+5zQxfRAas3OIZ4klEHUNYxc8G4hD9ez+D3/3/IgMQ2CFY8OIFLMTbckU20UrqiI0ESCnrsr9Vvye85LVrgoLr8sjdu1xR1dk+SN2SUod8CSRIab2LXKmcdtjJrym6FepUTyH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTdiT0hpemx4UVhzSjAreXp5WExqY3NucUVHMUV3c2VrWDAvNW5FT1Y3dEJq?=
 =?utf-8?B?MmMvZm93Qkg1U0pVZXl0OUlJb1hEYVp4Rm9KRVA3anJ3V1YwTEx2U1QraEpq?=
 =?utf-8?B?eS91RE1DMWYvc1JaTWU4UWpiRmtjeWplaWpSNVVFNkV1Ymd5NTBiV1ZkaCs2?=
 =?utf-8?B?VnlWOURmTHhmS2pVZmFCMEo5OHYyK3RsTlNaY0RGT0pkcm5IN042WDc4WUFD?=
 =?utf-8?B?Sm9QaHhHTzJ4bUFBcy9pWFhhL05veHdTNkRHODYvUS8zaUdSVitVRnZJc1Z5?=
 =?utf-8?B?NVVFRmlNVXpueVRGcmtuUnpyM1lUWGpPVjQzUm84MVJTYnBxVEhwbCtoOEdZ?=
 =?utf-8?B?NHR2L3VzeVBOemE2ZmZGTXJvbmdCY09abW9EYXpYUHdKSDQwNkY5bjJjQmx5?=
 =?utf-8?B?Y05NR0RkL3VxSDFVVVJkV0pVTVUrbGNrV1JNVnZzSmE3eEdDbUl2Ry9LNjIz?=
 =?utf-8?B?UFBDVVhZZlNvR3ZUSFJrb3l3RVhydXQvVXl4a3hSMHBMcHdtYUg4UXdveTZX?=
 =?utf-8?B?YkF4Z1JrRlk5R0RWMm9nTjFFSDFQUFRsUWNqQzlvOWQycDhaZXYwcVFYMU0r?=
 =?utf-8?B?MzZzQy8vMUNNT3Z0cmtiUlVFQlhwTHA3RHBSTjZRQnNTeEhGd1ZaSXNiSDRU?=
 =?utf-8?B?RG9HL3U3aGYyNUZ2OVBnZE9ZOFBjV1V4aUZhRndrV0RWbHJMMDJMWFkyQ2tk?=
 =?utf-8?B?d0hKMmkvWVBPa0ljME82MFJvVStCd2NpcGovQVZuZTRSUEszVUZkOTNscnlB?=
 =?utf-8?B?ckpzRlRxMzB5OTBUbk5OanNJblJ3cUxldDlPVCtidHZlY0U2K3pUR1ZKMXc2?=
 =?utf-8?B?VTNTK0hOOEkwUkFwUWh4REd1VjBNSnBqa3NTYWZ6a3hGVG5QUnIrQm1UN2Nl?=
 =?utf-8?B?REZjNytmclFuS1hldTNKdDlkcnpwS1g5SDVPV0czblRtb1BORGU0WCt4STVK?=
 =?utf-8?B?LzJZSHUyNFJDcmVKa2w5Y1RGUHk0akxBNzdGTTJ6RFYvZHRQa0ZBd2MvOVQv?=
 =?utf-8?B?ME1jdzJMR3RnOXJaeU11TVJEUFc1Rk5kQWJjMmJEZ3ZQSE1jUnptOVFTd052?=
 =?utf-8?B?NGRsaVRvUmYraHRwdTdIQnFqdWYwWmloZVZkc0pwM2V1aExXSnlINlRaSStS?=
 =?utf-8?B?OFd4NFB2NzlXekZ3WlJvMWJTNXRiVlA3bHdoMGJZUUwya0tMdEZYN21BL0lk?=
 =?utf-8?B?Q2M4Y3Nadjh2OGFWRTVEdGhicDRKZkJQNTd3Ny9XQzVoKzZLZW5hK0lIbUVi?=
 =?utf-8?B?eW9Rdi9BUG5xUXhuRldtRWd4MTNQbXpvbFNIcUxWa05ZUS84RGZUZlhxN01a?=
 =?utf-8?B?UUFveG1yZVpZZTJSTllrMzIzdDhYN1hpV0ordjd3QkxScE1QRUhhakU4TmRv?=
 =?utf-8?B?N3J6Z1RIYzBsRlEydnhUaXB3UDRlSEdnWmpubmU3SUd4L3RLeXBrbFFJTzJh?=
 =?utf-8?B?ZXNyaHhVWHZjeVJCandiek9qM054ZUJDMjFaMExjZnROMlpOSEpWVzdCTVVU?=
 =?utf-8?B?enY2S3kxRmpLU20wNk5mSHVEb3QyblE3OUowVW91MlZJelJkMWswU3R3VGM0?=
 =?utf-8?B?ZkR0b3BjYlRUbk5EYk9keWo0SGdhUzRHZTM0em1OTHpzS1hWempvUk9DZ2lP?=
 =?utf-8?B?TTlXdWRXSENLNjJjYThvOVpuakJxUm1lZDJQcnlTSE9tcS8vT0xkcTdhU3lq?=
 =?utf-8?B?YXIrOUhJbm4za3V0U0E3dU1HeGRxclVUN0lrTSthOFI0NzkwQ20yWXVXVEZ1?=
 =?utf-8?B?bFJLU1U4VkZHZTRFdi9kYnIzdFFObGl2Qk1TSUY2Mk1UQ21HWlcrQkFtWTBs?=
 =?utf-8?B?OVYyM0pKanVZcVRBb3NBS1lUUGROc2dUSVViUkYvaGdiVHFIWlhyeEhiUFo3?=
 =?utf-8?B?NmxBY0E4L3RwaDRQMURBOStvZkhlZzdhTS9CTGd5NC83K0pJSjVicnBpRXVp?=
 =?utf-8?B?QmhCVllyTkVVNVVxb0lCaTgvdlNTTkpTWVJxa0ZmZkgrRy9Qd0JGR3ZiY1lh?=
 =?utf-8?B?MDdOalZuSjY1NWJOT1REd3NXTHFkV25vZFJ2UjdqNmMxeEd0TGFWTkJML2hJ?=
 =?utf-8?B?ckVYbGU0QzZFSlJHRlpBTVJadEt6QzQ3RnJna3k0LzJpbHdwbUxIdEVsQ0Qw?=
 =?utf-8?B?VGJmckJULyt1RStVUXRLam9FbFlnK3VOaS82U0FpV29uV2hja3p2aFc1aVJm?=
 =?utf-8?B?RXljajlvbzVQS3c4OG9BNG5HTUxrRkFubzZObDN2Tmg0cHR6Qzh3N1lscFEw?=
 =?utf-8?B?MzFxbGExRUNFU0t0SGtoanZlajF2bHdtMlE3NjRSdWpmWjllcEt2TTJiM3l4?=
 =?utf-8?B?cFhWSkkrUGlpaTdDM1RsRS9tK2xlY2JWOGFHdnU3L2RkME0rSktIdz09?=
X-Exchange-RoutingPolicyChecked:
	AKxJatNVv6mZ3Rtr8cIjpfJ6YE1sgpQ4Fxc6KD3UjNqLxzLSDDMhPTKg99M7TQxWaZ8DIqtMIl7IEKuu363FFOvmweBF9tFCw7jKX/qql2DGqFTQPTSp1zfnQJPg6kD1n5VuUn8IcOepmJci4uHPhpp5fE8DLQd1IHW2FbEdraYlg/3l18wqj1escbgJPcdJXSIIXbS3qBpB+LHDGuiOaRjMvkE81xWkNGISmdLBYvrIhBGCx3u3iYJrhUnfV7OROYSxFEC8ABsjToytsZUWzF7FM0kpmwOu5iWfXQJHksYnqh7WLiXK5e6L88f8xSzJa4NlTH80lyWCeY6BehzNhw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hfqImX4qzqYrdIxO7rjiE347bEh0FMsS9/0OEz1PsKjDOJKlMeKMDZGSt8fnr+DyJ9fN7UVA0b2PZr/DT+fUoGuSe25n58OefARTaJ/fNRoG9VpD5CH8zMUSq+YendgLajuWrjOnqt6MoF+Gxei27anp2mn7p1l3AD72h9AJpO9bL8ET+DrVzyI3HoOoaZ5fxmsz5fHmo7skCib6uwb8iEKKkHaOiDnhWtfM0RygcytQPR+BvMy9PE979F1TvOKkgY1f37aKfJ3FhwAT/lV0Jz4sWfTz2Qk+e5tcRKBTfotPv8U5EkGjm9RENI50VHxQh295VWRszemnkJ8B3xVNMc4lhyMw3urgABmCDuMHZuriKns+iKAcWV+cSn+uMj/8hBNE3u4X2H8XTvH20lOO8pzaKW74wEGowuNzBcHEz9AcluDFTl24SX7yqu8HQkFn3zt3wRfaDnEofBrh3TZamAcPekgFQeyUgPb2u3zvAPl0nBqrMnXq3P+MvMSItHaH+GWlad6p+o0c1zJbvwH/rQDlSyivGGT/3mWEY6mdnDRET2J1KwK8aDM3J/pOMAhenTSzVk8gizj7WpZKTv61eFBLdKUAujvNcDrCA+9LdGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64f0224-70da-47b0-0790-08dedd7ecccf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 05:56:20.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6dNG60w+R+Z2tb86g9ZDUO8XD4DffRYNzFlkFLbCZraK4St+mE8ECAPmXsMar/QGxarqLuJ9vTbcDGPyOLWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_05,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607090053
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDA1MyBTYWx0ZWRfXwlLbYYMKYLc1
 R2pJ04wxPL3l2Pq0Kew/d8ZH1iL7ES0ljM6MY792FaKbgmMXpFFSbCX/M1qgi2f6RE2RttSmpiZ
 HaljAcwG1hgBGWyAqfoIVWoiFhV33Vf0Gwhksi2G9S5WpIxASuT9wGQhtL1eiIVi9EsG9uJyEl1
 6YfX4HouOyqPJ4IxmGwbxoY6ZK3e/uASg9dzSGwJHxLJSY8xE1wp8XPGUHrFuaxq/Ho0sv7m3xN
 VJfnQtZqEHGEEmkRPnT8hgveCL+5HTPuIoLEvZX4V1NchCuBQFRWpD77S2TJsmDw6pP2x8yD8CH
 Wf119gyUeEHRmzvNtOlCe9aYcPNtehLCA8BMyeye3itfHHDTPdDs0Qm6yuaUqRy5V08LjcdxV9/
 QhdJs/3m6xHgm/bE+D8sXshrItLHg1a9m7uSndgIAJf7hM8NkedvkITJeEWVc42/qyhPlO3ubd8
 Tceod4aqsfe1aRPix+A==
X-Proofpoint-ORIG-GUID: egakQI0Q4rbs5B83WebmA94atP2uXWMV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDA1MyBTYWx0ZWRfX8kuHxdrIUwuR
 vJ8AXgJOS5WB687NEKMu2XsZiwK5p1iSpxucgjn12urj97n//hOrvWD1pOSQ55tdyxIHtIcBzdI
 7P3bFac5sh4RIbd2gByfCMf/ARXJOCwuwkocg+VHllVy/+tkOD9P
X-Authority-Analysis: v=2.4 cv=fdmdDUQF c=1 sm=1 tr=0 ts=6a4f380a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=wYE3uFyoDcgUo5Vo0x0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: egakQI0Q4rbs5B83WebmA94atP2uXWMV
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4E6840006
X-Stat-Signature: h4muzd5an5wrnbwgj1oft4sfopb8rew6
X-HE-Tag: 1783576600-79487
X-HE-Meta: U2FsdGVkX1+X04DEDoFP/3b/z96AyOBfYP4wh5pfMzRLjm+INtSe5gT3VpqwvpkD0yDbuNOsFDyUFloSBvOS/WCqSRfho0WMMRfJ7KnLn9cFZka0hgWSNXGaa9iMGy70Q9CfNfnnVxWkogJz4fvnrk0lOGudOPi9EVabZjbZIXzSHPlT3gzFnhVU1U1zByJkmmmnq0qFCYUCZLXyrdGkT3M6Q+rpulzDD58V7YYtMJzpBsDKwQUhrSDzwrkN5M16+VdwCyPjCTujBkftll5GeccTOPzFGPles/ZKOk/3dYVkZ1hriy1N87K5m1J/VlD7SD5BZxnwuTFQVWMnDaghk/5M6cxXjpA/ullrO6xdGjy39o58cq2CGkVZVQ+HbNjfvnWjUcq43oMfuA7RqjVJX2ZwSG8hEN/ghHxZq6SCrsZc5EzLxxfcp3zwp0nhXtWxR37niCtxPWR8Gi6oMIhXsY3HC6nRvnFyfE70cN1Xo06JIvbU40gLac0PDpbzi5Buvon3QueiSCKnoKCvkfh1rSJ/eMfHNrWpXMuYSThlYJUQmZHhvuptXJkCtxnW19K2ve8pxdZkgfEZYiO6XJToCFAHIm3Z+iOTuccqFSJDgX/5yJ4v+Uu34SjyxlxfZJae2cuJv5gZKy/kTDhop4MBiVcA6i4Xg7Duw1h0TpGjCyGc8Sjob6vzxkhk9iJCHkdux0sq/SM6AUz0L1eSE5QG0ZfDZx6A6YOKO7Oh0QCchm5PPOb9ib1Hmr2uOVx2Aftc8wkw+BQ3oljcfr5akH5Yqfs1joekrh70x+G5V0wpBrzpdQzz6GYNXw8DV4KXWaMZxnzh4eMCey+PouvF3i8dlGHtAWkvLw/96N/azzvFpGxdFc0aFFw780+xkNRpW9HnUY1HUzVCTVaMjj7ZNiQe0p4ZPXSl5FwA+Fq9n4iEl4UDWXTGm2yyisoyEOWKXJzfuXxYc9t3hl6V8/1dw6K
 FpR8CrzD
 bD+CqdX4VNG6ShEMUGCSDKE0e/njY1vI7JYHSqWc4shj92EWxaCa07LQu5V786zzg5nn9WpqFd1zhL21dz+4IMfURkMXuZgGZBS0P81EE1TuLc/INS5z7lr0pBttyLF6KH5zGZxYa2yKJ/oYjGwZi3HO3UT8ckzd3L7TW8TT97Aqbi5QYmsNanu1iVigPpixCTpECBRe77kbjp+YKmbKTXmMcq6gR1kK3cbkaVOnupuFBjRARVsClB5SpvM8m9j42zIxYxcCweFPx0PcGp+Re8Te/zHCJRMTAno8CVu/C8gDVs96gxnd2fMzRTzCGRjQGUQEKjydKlPmYIKKfrEk9s1L21bf1AQ0HWLZaC/lHQqhfJKWNc1DWdGl1c2yQauSHFk7mxzcjZVnNksXG/+JDPWMyyzUViaB5zzWZngR89K5Ay/ePI9vBnur/tqLsd3TS4SrcV0SzPvrL0e0PZv0bv5c/ShMsxQ+sGIWN18OSmA+LwQfxpS3UHSnbMMHnVo03VVLNcN5D9rvOOs6fzRPhZPpFC2x90qeqXLSkpocx6+CK6fr2Skz772sTzsfhRZcuc1deeBm2306dkEiwojar+WNjSDK8ljVIOb5ragmLDTkyPVNE+HLNsQZis1U3bd9h5KxYNXjV2HfaLW1mzNqBxEGsyIKLGIWc4rILzN913PMTfleOzH49ixpR7hu/6zKyA1Pc3bcsaajeWHS0AjgnvcmWbrb7o+g9VQ9QhX7qCiad67L20V/TZ4BJvwi+VOt8hPhusX7AgbSXhbJBdCJnQfZLZSeaOovGhgR9J88/5yvqZzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/8/2026 8:07 PM, Matthew Wilcox wrote:
> On Wed, Jul 08, 2026 at 04:31:48PM -0700, jane.chu@oracle.com wrote:
>> On 7/7/2026 11:17 AM, Matthew Wilcox (Oracle) wrote:
>>> This set of patches are separated out from Jane's earlier series.
>>> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
>>> I feel that they represent a reasonable amount of change to send
>>> separately, although I'm going to keep looking at the rest of the sseries
>>> because I actually need it to do a further improvement that I'm working on.
>>>
>>> I'm not 100% confident in all of this, so I'd appreciate feedback.
>>> I've run the libhugetlbfs test suite against it and observe no new
>>> failures, but I'm not sure it's thoroughly exercising the read() path,
>>> and I'm absolutely certain it's not exercising the memory-failure paths.
>>
>> I can help testing memory-failure once I finish the stuff at hand.
> 
> Thanks!  Sashiko had a lot to say, so I'm working on a v2 with a lot
> of changes.  I'd hold off on testing for now.  One last big one to go,
> which is that we need to support holes in hugetlb files reading as zeroes
> rather than allocating folios.  I have some ideas, but nothing I like
> yet.
> 

Okay, looking forward to v2.

thanks,
-jane


