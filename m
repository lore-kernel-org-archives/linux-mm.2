Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCBDE7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2168A6B0092; Fri,  3 Apr 2026 07:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C72C6B0093; Fri,  3 Apr 2026 07:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5E96B0095; Fri,  3 Apr 2026 07:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFA036B0092
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:09:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5EA4140570
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:09:52 +0000 (UTC)
X-FDA: 84616974624.20.80CED8F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by imf29.hostedemail.com (Postfix) with ESMTP id EDEAE12000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:09:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sVc5PDsA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.33 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775214590; a=rsa-sha256;
	cv=pass;
	b=mwaqxAMao9QFxHx06D4MkuPJPhwmrw0Bmo/LOhhY4nf340Vyvt6uzfBVkN51YdVJf8O64y
	7FxzJ+jXf9sVXLXHXUg8fVKQQGta/4Pz+hgYX+mpK/b2k+ACicD0UaBVVtptGNxDco1yx1
	m9D8eveM2MUcw2z6S4rP63RRODk6NcI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775214590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNaS8npvw7ENfPjDCyEVdj4gBIvhIefHCcezZfM6olk=;
	b=Fdu2MFFMeXXprGHZb2f3VjJKfEnsNYtCFEfPl5e4JutNPyBz76lfDjaLIW+0xH7R07QW+w
	9u0+z0IFgpkelM00hCSFffyZ6gxCGvElbeK6mTjyOxhlqlDvKdm5+D53zCn4M80ieGFimK
	jNqli6JXXyi1gZmY6vt54yiImZ3VWkI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sVc5PDsA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.33 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SEW3AAhp8Ds/UdZK5U33EQTiZlKQPmtfr6iIkdrJtCWwkN2BvO8dr3hRKiKQVyWKr3yI0gbDWpBcYzUKT1CenDQrtZ0TSvGVoKlmGr1it9uBDQBNa5QdIgT64LTzFMB7AMt6Th+uej9Sl6yhhAViyAouAY2VGx8OKqUuXp2iLkaJG097w1BBhhhW5B2NnTg1+/Z6+EJ8KSVG+jlebIT36kL8dA1HGWjbGT7wjy4qT0IYRYDRMj+nfV/n37UlhN7s6JTEMcaaVMKm4jh5TtpggaflAxNRZNQpfc0WYICIV2hFAefTayjdtBjp5I0k01zJBetMXGuDhESqvKIcQyTitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNaS8npvw7ENfPjDCyEVdj4gBIvhIefHCcezZfM6olk=;
 b=cftM8e5QkLwX8aZlP9hUBNjr/sQW+GpB4zCPn19AEzIgtUcDEggIzihHpoyHm7gPXAI7HpGi6B4Uld8WINAJQ3ADiUMD0paYhu0VL6u7DzjSMQV3qWsjtijVA2PIM7qVf5g1HaCPBtfhlLgC4D2UN7hoZm3vp+a5sFskVH8DC/G1KMtOo1xnxIB4HTLmf4BRbEve+TYsUU63EGxpnuuH6mhuHhoOXMyuKp+KMJ/msMTc/7HwT/WDFXZrTNC0V+H3QtpP//gIRfhBB/kugLed5y96vgi0B6bgzH05nG+nwYG3onmRSZ7QTZkK/UIEwuG2gPGC5UqEcXRQ91xfOo6qTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNaS8npvw7ENfPjDCyEVdj4gBIvhIefHCcezZfM6olk=;
 b=sVc5PDsA2XE+eysoSEtzMSefG+VoKDgPp2xz4YZUTn7tVL+IZhbfIEPH+SowCAlNoz+zmZjn+DRsBx6H/CiQFRVbzOgo0Dqq6ep8VOmAMf1T7OxSPsb8qn4J5N9dWoJtM0SMI03WXbMt2jVC7bufxvE/rV4BNZnbwbnSs4kWVzg=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Fri, 3 Apr
 2026 11:09:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 11:09:45 +0000
Message-ID: <91cc6c3d-b9f2-4004-87c0-a416bc7c1b10@amd.com>
Date: Fri, 3 Apr 2026 16:39:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/6] mm/migrate: add batch-copy path in
 migrate_pages_batch
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-10-shivankg@amd.com> <87se9pzkiv.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87se9pzkiv.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:265::17) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: ec1ceebd-91f0-4f84-8631-08de91718300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	K9kkI3Y9C7oZ1quY8NqB39ZIPHdUSdT2pxPwxKvDUDWDyiopKdS7oaZvUp1JX+VtvH7q3uBDOf7EWezbSXuBrD16U9mlwWKV+H2wp3yVJPjLK/X1zDZVe925Fw4Zh2LFdgyl721RTD4VUJqGeLZkuhoHpTVZ21DQq64vbEdv4ZntfdrRsR8Xld6YOlYDa6XR0hbx4Hx+GruM2b38pXXwFTRFmmKzzYfshWGHxpH5tvBy6BdGpo6d/D81rwSPfFR1Q1QGGnBchZ2h4IWe32x56aobrZbTOTCWCTMbNw7S2Dj5y2xXVlxtkC7GDFHRbrk2iSHt6bdtghyFNxQLbpr/te9ilznjvB5aE2OEpMscO2HUgieV/CTxDFK/uCcqx52T0CjgQ+0nQ1BHzQva5yarPSHkkmHoVq+BrTrOz/LX8Tov0icAftrevYB5D+cVafcmq2KxRD52rb5/VWYXQ655hHl5cdWWfkL25dj0p+eiWgDeS6PKD55nXJm81fS6wTBd2QsCAjhovteEtwRf5duRxJ/cq1wQSe+P1/dEIu6fCZ6FhOqJLgdYzhLk+7xGkYd/mWADBNDtl2/vf3LPzz+BglrHkCUPsRJAp40dvqPREDu5W1Vrida5WkpUyem0uVmPUJkPrDCNkWl7zKG4bVg7pn8jyTBTHakw4tHt6Xd4pIH2Tb6cU+v2APyXM6vR5Z0L9w4GHtIIFc9SviesX6L+q3AyZ5HiBtDqHzifY618lBw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTRLdUxyYzR1NERRSUFuM0JabUI2bU1LeXE0UENRTDRZNDIweVNzWEZFNXFs?=
 =?utf-8?B?WlZ6RVE5ZkdyYUNTQ3ovWGx4aXAxMUlyYjJXa0hWNHB3MVI5V0VDcWlGSjNO?=
 =?utf-8?B?OW5NZTVNMGt6YmdmVXVndm9MK0VqRlpVaGdXWkZzeTNIM3BFVjRrNUM0bHl2?=
 =?utf-8?B?V3hGeWhGWTNTdFplUmVpM0J4VnQrWGhpMm90d293US8xa0VVSXVKd2FadEpI?=
 =?utf-8?B?dzBpM3VMQ1B4MGVpYlRER3RSVXo2UzBzbEtMVjhVZWFMRWJXeFVHVUIxVUJp?=
 =?utf-8?B?R3hOVW1XM2doU0NUanladDBQdFV2L2lyYkpqV2Nia1hwazFvczEzUm1qbzd4?=
 =?utf-8?B?TjF4ZStoZk55SzUzcmlsbW5YV3ozWHRzRHI0TTFXdGFJeGxwNmJxN3lpbkY2?=
 =?utf-8?B?bkJVTEpxdDJzbnNmZGMvNlhUOGgzdnlvNlV6eE9WQVY5NE1qMGdtaHo3YTl2?=
 =?utf-8?B?RDBRdEIxc043QldUUGM3YkRVUXhoUitiVnJjdFJpVVhQbk1NUFZyZ2VzZUVh?=
 =?utf-8?B?Y3BIaXFBa2x0dnluUUpSV2cwUHA2d2R2UnBwSEhuVlVyOFRGbmFlMmpCcWFh?=
 =?utf-8?B?dnVaSHlVL3kzVVBlakcyclJJUjVLOWJ5SGRIVC9xNkRUODVVWWNWMTJFR2dv?=
 =?utf-8?B?a0ltbGJKNytmaHQvNVJkS09rbHMzYnR1ZE83bncxVUluR0tMM0xTVlVMdVBk?=
 =?utf-8?B?MDFRZ0V2Q0V1L2FMMFlONzFtRjMvcnlBZkw1V3FCR2d1bDVaNDJDY05Fek5X?=
 =?utf-8?B?UEg3VWFQSGpkUlRtYTBlR3ZQL3l0a1I0cGF1T3JkRS9rbnFjTlFLeDZoVEY2?=
 =?utf-8?B?eEczSWxIMmh6Y1V0TEtFbS8zdXlJZWU3dDNVdlhFSldTTEJGUzFaWUR6dklC?=
 =?utf-8?B?Q2IxTEpiVytOOThCZ3Z6QkMxNzNQWDYzZURGeG8ycDFacmlNUTZFMDlsTHBq?=
 =?utf-8?B?WXFLOE9ieGlIMS9ndkIyejhkTXVZaTRxWDI4bU9rckhiN0RiNTdkclM3cnZI?=
 =?utf-8?B?K2lJc3JWSm5SV08wMGlBK0IzaGZhVGNVdFI3WDFNTGZDRDBFcy9FRmRYWmpx?=
 =?utf-8?B?KytBRHRSWUZWTGgyTS96MWJDN1dPVTMrWWM5bTBYTEdpZ3UzU2dSYXNNL01q?=
 =?utf-8?B?OGNCYmVGRHE2Ui96OXNBeE9qQmI5aXFzcTgrbU14d3MycWh4VURTSEIzTUF0?=
 =?utf-8?B?NG1HRFIrbFNQalEzV2JmdHRUditQRGl4TUdpaFZ6dGlOUnZkbWlnZTVzcW0x?=
 =?utf-8?B?OGFUQldlZEhhMENYcnlXMjA1STR0VDBHVE9mTFhqNit0WXIrazFoY0U0TVUw?=
 =?utf-8?B?STkrZmpkeDNPWThUOWJXcHJIWTcvQkxrRitKbVd0cXI1Y0ZLUkVVYk1uQ1hy?=
 =?utf-8?B?c0hOUG5qR2puNVZzV2RXbU1MMDFXSVZzc2REbEhXN2Vwb3NtVXJVN21YNldI?=
 =?utf-8?B?WEJwaDNFKythNUVtZnM5b0c0dkRQYzZYSGV6YmRubEdIY0FFK2FTUGlwNXMv?=
 =?utf-8?B?YUNSeksxRCtDS0lHRURra3NTbHg4M0xNMVowQmxRcU81VldTam1DZnZMMGFl?=
 =?utf-8?B?ZlNQY05YY1M1RUkwMWdXbmY5TjMzTWNBbHkzNHR0QWdLb3VZdlRSbkZpclM2?=
 =?utf-8?B?T2xZQVFMUEV1djZCU0RpeDhQVlVyWHBrczl6b21JaU53UVU0QldoKzczU2Z5?=
 =?utf-8?B?RVhzeWxtVzRaMjRVQ2xpaVhHbGZMNmFZUVliVG1QZzlYamQxY1hiUE9NMUlR?=
 =?utf-8?B?ZUMrRWdqbW1QMHZMclRMeS94QkFDcVBwcHU3RmkzTFZzdXhOdGNZalNnNDZG?=
 =?utf-8?B?SWxaVjQ5L0c4S1Y1aUhqQ2NhWis3K05KZnRTOGVYZ1RlSVU3amQ0MjA5dExv?=
 =?utf-8?B?VnRzVVUyRXZPZkx6WFVMTzRYQnJBUWhJL1pqT3ZoOWgxZlNwZERGc2pURVJo?=
 =?utf-8?B?VVRLL2t0cTA1OUdWTXVwTjZqMmtERS8yYWJhVFpkL05pcHB3MjVHRGxZYS9U?=
 =?utf-8?B?OGpaa3cvcnBLMGgxNCtic0U1RGZqSXNXOGt1b2RBOHNOWkNNM1kwRUlSNFBG?=
 =?utf-8?B?UHZ1amxoNi9ZZVk2MFNmQnkvNy9EdWl2d1ZkR1FhSGdCek91WUpWWlVySmtX?=
 =?utf-8?B?ZEp1dSt3czJYVjVRNjhBMUZVRmdzdVZYNEZZWFcvMFZPeEdYMU9VZG9HREFm?=
 =?utf-8?B?N2lCTFEvdWdUZWZOQys5djJ3ZnZ4NSs4SVY1Z1hJT1F5K2drMVcvWk9xdlBz?=
 =?utf-8?B?Wm93VnZ2eENKOCtQZmdoVFFGNk02T1ZXNFJFV3daR3RvRi9QVXkzN1NRSnk1?=
 =?utf-8?B?MW80WmJkMkowS2dtb0l6YnRuTFF0M1JNRU9BQWxxSmZscENBTmlNdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1ceebd-91f0-4f84-8631-08de91718300
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 11:09:45.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXFxkkpEYZQvZfGSCqmPL2k2LKmHbaVjggyku+1U0ezZYxA5p1OhyVbNnQq52UQJ+AGLnUwllPBSxd1fc4BuCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDEAE12000A
X-Stat-Signature: t4h9mkj3ry1cdt431ukm1qefuf7ripmt
X-HE-Tag: 1775214589-471647
X-HE-Meta: U2FsdGVkX19IennGEYdbQ3OJK0c8lG8Vf3+7eWCw0t9BOq4GGbErDnlaogrKyc2TsgsV+7ccuW+2iU8cp6P4kqX1w7jtAISCm1T9SofEKUKphUZ0sGrKjbA5Wxz/9aHRgYt7PFIvs3Mtequl3T6MDrliqwIqz/llxHY+iVWq5iFDz/nFkGyXs2cmMBFY1FUBB3+ByYXher1T7KXB5XgC0GVfSEA/lIokGscwYgl52NuKRNR+ShIZW4dDAKwQDvYoT+Zv/3hg8Lc1+Trx5HgkJqICwBVmueGsvT6xXzOgzxQAd1spLu6ijK4W//um89vkOaMh2IrUmQ7uUma9iXbbqU49XS0gycDdP/Dpb1h1AtDRp3o5CV2IgRfaZS6XM14pTJ/SdgOSDS71vM+WJKY6+y5cuOQ57cBgVWGPC2ZdU+TqA50P1KTtR1zDRhQABPdzuyca9bA/i0Uq0u9Zy7k5p07wets35tjnFGaxbjS8dt5nlKjIF6kpWHjV30qqgWdjZwtxbxsPxQaLeKQsZGX4o+OMxvBw/q8x++uwtlFaPgNH/iyForgMmX/Jfve4EHktw9NRlR6scXx9xLbUvXjbnEVpuzjtrQ7fFN8XCYW3VkKLhrPLQxAPbJ9Y/5RhxTP+6jcEoKwtRUaopuBJABA7gg1re9/YilQhDu+PvEcv/ha3J7cgZz+ymksBsowLXOB6Z+hO2/+Seh1mo8B1oIpAS/nzYh2maouFjMjeDtVRgqoofsYD+pb4LLCak+kS206KyNTr2zmq47qfOrJzRxZP20ac32J+X0VeLUhbMmfTsGvV8fmJW2dtiZqOXPix63uTjzM4kVZBPi50h+vmCxSODt7ieQV1AQfVHys/HfGHEvAXYRi4Kh8mxpz3zQEoIgjlf0L8yzkj+lodvDZGijFXT0mHdAMfAMimmS/xr9C54nbCyM5ADFUQ0kBFaQSKRRSJkmOYJLOwVR3nMcL9lut
 A/NnFKD0
 8Md0/PNtL9cOFWyqW0KKgsYUsjv7r7dVMqpgM3s7rjMixPQmtxzhiIkmssgeohREjGhDh7o7bBpVoBBZY7ZHGhPBYZptQsdzqqX8uP/G2JnVHFtdHA+YjL0rO+EXOrJEPoloSBQTM0TtSMe0XUfjRJHbEODg2azR2s/0WpvwUVqULAzA1AgAkHU7mJ6KyJvsggaF5DZG14yGZSNJIGt8WETR2QYKi1Hl9uUJRvU0WjotnUeRUtriJDI89GvfKeMkySJMXv5wXAn30s7NTRL3UuBL/RnKOfm1is5O+cH5RUy2KU+qakZ+my6QC/ba+I/Ra4CtBX0jlM5xWHYHb8pq3w6BybS7nk0Pj/u551Z8aBWfB5yTemtoAU6bLKU1C6o6LMbAFMy4dGUbz1d4NRiIZ/SYY0uG8Uv7D3gMIFs/8atU5lplBb5ivPNGnW6E+bvakOgOCG4Eti4y3lLgsj13Rjmp5EYR9Cn9lo73rjBl0AA/rYcvvjbR4YAfwNIYzKtOLr/GArUfBUJczjeqCnb9S3DdoFQNYEFbfCw95uawe2fYIZOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 2:12 PM, Huang, Ying wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 

>> -	LIST_HEAD(unmap_folios);
>> -	LIST_HEAD(dst_folios);
>> +	unsigned int nr_batch = 0;
>> +	bool batch_copied = false;
>> +	LIST_HEAD(src_batch);
>> +	LIST_HEAD(dst_batch);
>> +	LIST_HEAD(src_std);
>> +	LIST_HEAD(dst_std);
> 
> IMHO, the naming appears too copy centric, how about unmap_batch and
> unmap_single?  "unmap" is one step of migration.
> 
Makes sense, I'll rename them to unmap_batch/unmap_single/dst_single.

>>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
>>  
>>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
>> @@ -1943,7 +1956,7 @@ static int migrate_pages_batch(struct list_head *from,
> 
> unmap/dst_folios  in comments need to be changed too.
> 
> 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
> 					private, folio, &dst, mode, ret_folios);
> 			/*
> 			 * The rules are:
> 			 *	0: folio will be put on unmap_folios list,
> 			 *	   dst folio put on dst_folios list
> 			 *	-EAGAIN: stay on the from list
> 			 *	-ENOMEM: stay on the from list
> 			 *	Other errno: put on ret_folios list
> 			 */
> 
> 

yes, will update these comments.

Best regards,
Shivank

