Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942D4C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549D56B00A0; Sun, 13 Sep 2026 22:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D42F6B00A1; Sun, 13 Sep 2026 22:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DE96B00A2; Sun, 13 Sep 2026 22:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8F3A6B00A0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A784120E92
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:40 +0000 (UTC)
X-FDA: 85210774320.11.4B8F7A3
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90E1D18000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RgvAuRWW;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
	b=a6ilSNxytnF2G87r6wfMDuljd2Mdr/9WZAFTeTKPF/4bwpX9TFquL7zFDe0xNBl8vYX9qx
	9emcrz8rMRMjHinws+dxZpBNw0WxlTOECKZ6ZolYMScdzEGEoyB9WKlgAv3efbkTTuh/x0
	tJj/F8xEYNrlGIaC7e7vFCsASpi5td8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352677;
	b=dDZ+xK9ujqowqVQn6k60Xz1cu9SYZ+bZ6n7K1PjP7bulONwzui/NI7YP0inFp1K5CapPCq
	07JpBwJ04+QWT+eD5Joh1TT7eer/Ln+yBEWNcsCf9MgRKba/kxZzkTb0xU9K9gZV7i9L3m
	eyLpMo9ia29ykDuYQjCyBUdOBWyQGNw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RgvAuRWW;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4kNAGv4P3i+CApyTQFH7HQYZ/0S5yKKDL7+7LHgyTc2ImMHs+hXb/DdRacxnfUzr6+3SvPCDAjStWCD1IxO5GSgUr6guKG0PWScrt6AwuiVhQUx32E3bs6GY38G2W2vUUH0I6DmbKw8j8KdMaNG4eUrBneusFlj/uPLvBK73RHE2xe+lPk8DJhGAlcRRMuznerXY/ceq5ukJqd334rlMVZF3ZC3l8PUe1AgECIbUGp/XqIDU4dJdUbHvGPG3lcI5F9xYA2A9tXreQYCl3UL39dTy2QeUVyRVRnimOLS1dIOQGkWTqxRNwdXuwQodLf9nTWepKE45havsTQNlSNgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=NGaWiExv13SDw2gFL80ipk6P7zhnllXvouDvJnK5nZ9b6ThRITZIamFPdTssIuwV9jvZMrnzDWWgHjLgCI8v75MVenI3RbMA+KoVsxF1b/aifaGTR8dOBMA2aHF6s4K0/e0LutIK7bjmnY7jtnfYqaPrZJQjSNqVszStZcJRvhihe4O1L13fVDk7O/jH8DYudqaYPApebxKI/N6Z6Vsr5DA0QBZWjpypOf4XePRbKlL6y/GOsq3vFrPFmg2jECmwf5hFIA6mnhVgTz5vVOrBRt1tQjAmMi69zo68Z7rv8QgMA2xN3yhIo9Swk/GLOluFf1tQdWKAmP+EkPj1TCd+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=RgvAuRWWtK+Iul9CpKWeIbk4iCO/+jzOcVeVD35wiMJC6x4aqkDtDG2CqtJvmIqVG+zpby6vdVLpL2yJH7Xt4Il9/jC1Odp1h4BCEh4BK0eA5yyQ0J8+nF9nZBssYF3qDY6DcqdYmutwrJvCViXhPFGo8s7ubErvs2WZfMgZj2yl383Bo99twu1vhcWoaUMqiYCj7Hp5rNSIA22pH7H3/4/lh23w0insMwD8NtfaP98O56054X0W7SsZ2iniDBxMScEUwW9JOFBEg/nVYSUF63sqhD161N8tYIir3/eKqUzUuUstQKYL2QxcizTdaCMV5eV7yVnW0caR7e5FRfIGwg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:21 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:06 -0400
Subject: [PATCH v4 08/16] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-8-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BLAP220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b0577a3-d1f6-4fec-74dd-08df1207493d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	LXmdquqRakWVVHTOu2q8VGwFGarhn7aOPvcmKTPzfQvdT6LHGfpqTjDAhKu8hDyUMVCLw7ccnH5iHZOCbSeWr5mccNZsYQl8jFwrbHIp47FRTIJN2W0kGM+SuitZTp3dpWVQZ6m0fqD9CW9kwZooH9lJUNU9SIu3s9kpmIjt6+cSrqm9v5B2aDZMViFfK2KrT6PQJQhpg6B6A6RFIUKiD6LSISyfAG/cKJ2kGXzvF5RhWbwZTjQjr07glltdDaDSwf0vHzfImAHODImyLnqOy+JRfAi8FtfdySN+7UD6Hau08xAFc0wmP+pjsvzKDFG0o79N3XOiyLuHc7HLN3Hqip+C2cZGFumihKswebONkGb/u0lbY7GhkSGLWaz7k2bUUDHqiPijt8bdoy8lVNtMJzzAVXD24bHM/aDAyJ17PEwnfz2+vR5FBP/LxyxjBNUCr+J1EMXWiXHkHPw9wVAO21TFofCE11w2Nzlwbex6G+jjybU097UIoUO4ZdeCSbDswGVuHS9TOYUvPEXfLV3tMIfI7t/GslP48mDMvBgxNjxgCminpR0swe520zA5aKb87DBqB6YQ8UweLDrokz3cDD7mIjMzYO2n6/7+ziLalArSNt1jHx1yOzNphI5MWQkIFvnVNg7q2tqFbNUiKzMijwuZEN1+FJxteD80sDHfYwju5TuKN42SU+sM6/ZGALPJ2xs0g6mbWNNtlbnZiZvGVw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3AvWVV3bU1kVDZXQUFtRHR6YzBodEw3WkRpb011M3hySk0wNVFpZXpGdllS?=
 =?utf-8?B?eXNTbHkyRUdja0hDVGJFMmpQMFBiNWxmdU92b1g4aDA1VGZxRXE3ejlhSy9C?=
 =?utf-8?B?R3JxNHJJbzZNdHVUK2FnVURpUjhvZUZjcklhcUFPYXQ1ZCtRTlpDdGNna29y?=
 =?utf-8?B?em9zbkZKbTd0eWpHZjZMR1UvVjgreS9HeUJQbEFsQUFsK0ZjWGpCWU13UnBa?=
 =?utf-8?B?ci9sdVVVdzBhSHViUkZkaWEzdUJ0dVdZWEVaM3NBZUVDMjN6SWhlekVFMmpI?=
 =?utf-8?B?VVlJSy9GNmptdGRJRUNRYjZuUW9ZKzBBZVRONzFYUFIxaEU3dGxCZU1TT29s?=
 =?utf-8?B?eU1kSkl2SEpCc0dNVDh2WndwK1JwYmNpUU9jVkkwanVjL3hyR3QvUE12QzJv?=
 =?utf-8?B?Uk9zdjExaTJFWVo1TlFlbzlqL0JIajQyRWU2V0EzejBCZWZtQ2J0bEFVWVJq?=
 =?utf-8?B?MnR0cWxuYVphOG4wUmNLMzNNaXBWeEszZ0NnSXFXcUNhUFByVkp0eGdxclhH?=
 =?utf-8?B?SzBTUHNDdmIwaEd5ZmllMzBiYVdxdjlFNG5TUnpyYUE1Y1lQdlhlbWtqeVFU?=
 =?utf-8?B?UUFvWWQxN1VFNW9hOVF0S3dqZ3J4SGZuUlNQVUlYbVFVS1JMWm4zeVF1NGRI?=
 =?utf-8?B?dms1VVFGd3pGekdROGd5dS9lU1pJS0Qrek84clhNZFZzVUNRbmR6Ulg1Nnh5?=
 =?utf-8?B?ZHJWZUMzY2lHZ2xMSzVIRFgwMksxODVZLzlCaGZWWW1xejRlb3VDbTNYbTJY?=
 =?utf-8?B?WU5rVlQxZU9nZEVZSjB6NXNIbmxmSUYrV2pXOC9KbEsxVXh2UDg2MmZROHJY?=
 =?utf-8?B?bjIySlR5Tk5UNVFXcU9qQmRBME9nZCtMQVJGVVNUYmdhNVJ2MWFmSERLM3dM?=
 =?utf-8?B?akEvME1vTU5laUZIWXVPWFljYmZCTG53cTVEMHZ4SFdtQWFuOTJCaldsZlR2?=
 =?utf-8?B?V2FhclpzVDcrVkhYeXFMMmV0WGZTaHJTZjcwU0xId2xIbnppNFp3SU9PLzk2?=
 =?utf-8?B?K1p2TkxmbEFSOVg3L0ZlOElNYW45cXVXZUp6ZU8zcmE0dWlPUUtyTlU3ZVRF?=
 =?utf-8?B?eklzRlFBa3dHQzFWNUQ4ZkVRKzh0L2U5Tno1VkJmU2NrT3dBejFHNm55clIv?=
 =?utf-8?B?L25ZYmJsSlZ1OVU3UjV4dFgvM1l5VkNDcnJxUjNUc2VCSFFVVGFTSzZnNjBp?=
 =?utf-8?B?RnBtQVRBTFl4R3l2Q0VEczRQR2M0ckdMakx4UjFmVHNRUXJZTStQUjBZSSs3?=
 =?utf-8?B?UkVxKy80N1NJR2R0cWNSZmczWUg1NUsvbE9zc0U3ZGRSVFpYUUVpTzRXb2x1?=
 =?utf-8?B?NmZvanl3U3pjZHRIYS9DcEZsTXN2TXhEV3NHSGhtbEN2NHY4Y0kvWnIzK09a?=
 =?utf-8?B?SWxGTEFVc2xKazI3TjdnLzBDazEyODdTK2VIM3VjZFNLbXVUN2crY2l5bURS?=
 =?utf-8?B?emdzakhWZUdvMGthTUF2NkVsVC9LUTltSjA1a280ZFJIMnBxKzlhWDZXT3RX?=
 =?utf-8?B?VElBUEgwUFg4RVN3SHJFVnFkbE4yOTkwbXhpSEFnUnZiOVRqclB6MFR1Ylh6?=
 =?utf-8?B?SzNSZjhYTUcwMUdoUFBZc28vblZtaEpSZ2VjRU1yanljRG9pWTFsQnd6Zjgr?=
 =?utf-8?B?d2RhbFJNUW1vRHIxZFQzTzFmNDJxUzY5QUl0b1g0eUF6QWc3d0RVcUpLZlNV?=
 =?utf-8?B?TXFCMXUzZG1RUGV1dHdBSzI1NHhybzJYODYvaWZwUnpwTExyRUhkZFZBRHUr?=
 =?utf-8?B?TzlTb2cycmMzbndHWENVbzdPeXozcTdoZ09WVzYzVkVBWGJkUmtqbTRReXpT?=
 =?utf-8?B?N2ptY1cwc01DeGNyazUrTDd6Q1J6OHpnNW5hakZlOHBoSVQzWE9xcTYxS3pl?=
 =?utf-8?B?UzRjeUVveUw3RmhVSjRyM0JzOWFySHFoU2R6dmYyUGMwT1NOUElHOFV4a1dW?=
 =?utf-8?B?bXc5RXppbjFyaExhWjVTQ0Z2emVUc2Voa2xMN0lzVHR3L0dIOHBFY056Q2gv?=
 =?utf-8?B?d1h3VlJvZXAxQVUrNXVIeWloV3NET0NyUlFhbGZ5OHdRVmNJUU5RSS9MTnRV?=
 =?utf-8?B?aWlFcGl6OEhmM3pPTldtdWw3TVlCUlpFRTlDYlpZUHJHekM4ZE0xenpHMm03?=
 =?utf-8?B?amJGMUp0ZjhBRnNLUXNQSVZBN3B3TGZYQnVybDFQNXBUODV2S1MwM3RFZXl3?=
 =?utf-8?B?NkowbVVQSkc3RUdPcmUrem43TkRJVDNUK2czakl3M1djNkg5ajRPSm1mRGdq?=
 =?utf-8?B?TzJXSUVMNHE3YlM3RVFIVjQ5VE1rVGhNZjI2QXlpYXVkZXFzRHlnM2xmeVda?=
 =?utf-8?Q?5yMth6Dn8KZg4D5Oj0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0577a3-d1f6-4fec-74dd-08df1207493d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:21.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLclKViQFBsmsz6LxOhuc56yLjJcbwjEednZGh54FN2MeVoXdjx9VioF0SS84/WJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90E1D18000D
X-Stat-Signature: qzoe9gyyfimh58sui3ztwkkgtdwce37i
X-Rspam-User: 
X-HE-Tag: 1789352677-896073
X-HE-Meta: U2FsdGVkX1+D7rNtVuyi7xxfFVfimIpb1ahKe1FhlCmI0jtImeAfPghZB+tzjTbByFdb4akerFiIAUpdLdr9sljOXAq6zKqvy1vPQXtMxPgTOpPUYQvVjuB1VTqvsoPHZf5/I1KrTxC2/Zmz/M8yhIA1XBq5O5TfLzHCYVxpHDlIUlO/Ex/+zT3t+8n8WjmyBts2dUCjasfELE9rvEJRLPXDbcrVZhQ6Nf2olMtIRwuzNQPiBE28+KpYQ1BRynNlderrEOGAM2s1uFfU4+nXU13S+6mnfN0kzQ5jfdJZ6bmXDoEqJH32Y+v7tOsM3G0FX+W+vkFSF7IgI9ikUHtefYopnVC4HcTibzHxNkkhKerS/CgvCh1V75q+n4/hVhiOpImIRm4pHe+mxGlVbvI2QQ9eR1WfCKLVjZMr1oB7wKp0o8n+JnX9CAIPEGda34Plv/NKGmuJuGdrmBnSZWfMkA2k2fahejR+WkYc7BFwOAh8rPsGSISAxUvjpA/okbzsuQQuxYqHUrB5iYjVvaD4Tmmq6E5JMWoPLZV1Z6Q50ukQfPzcl8xuquHe1mAZ1vB4FeRA8vbMSdshXEA0nNg1OxQXlyBS3Xd2Mlbmys5NwbGXYt/g0iqqoljA87ixUp8pOSlYluc6GM5LuVbQq07VALFImlYS46JH02HDYkXkHgyQPvSoteQZnouSQZmtunmwdThHEWe+dIpWYd8ScPwxIFJ3cGxx35LbUupvTVk1OzCXfoCiif3/3nFckbIuGfviDAqT+0AtHkSHesLtBAsW/gFPxOESWMzsYfgBfESElMMBWoHICwMWHyfFpHQMt56IeekYI2fYLphC+kmJkqEPv2ALG4IibB+fjDpf8bSodDOTkdUY/p/DWSYFj3CrqzVnqQ5UBUlpgB94+K+0fEIC0IQDeA+rP8uNyOyulva6dNEA9L3OR2Ap5YjjYBOMBUnwpoQvQSCRAla8Ltg+ySt
 QLSjWqS1
 BfczCs4d9ggXTohS5ZJeSq3pMM5H0DijY4Fgq3KnyURoCkBxpQB6dcYSmMQFu2adLmlFGp/LqOc+BnoD/OUch7fJ6HkCLxs+XvskfsnS71Kl5cquqz3dezzYp6N9FE7suqGt1A3vfdTg3dpaEQYB2UUi6Laj+d5kYyhQvjGKuONSNGEViH3vkIaKiIyG9M0s4fyKL+20xxWKmpWjRJiDXwo1Xc899jyCiKdgaudlLuxAqlQi76k4HXJWfevP/9famE28IMONUDW9XwyZKGUkwInbdzjyeGwa6qYgc71JNmHarIdoD5helAS30ERtJ/kQPlq0Qz7Y4FssR18m8RAIlg0W9r7cNvxX0cd+qOz1ukVoi4QAYIIrm/EuBF7D623Y6SSmd+MO/v22UBt8TklDHM/2aKgeKZwdq7D5q+wA0WIio4ET2dZ7I19dseaEe/JeFOBQSORjuuHG8+Ib80iJ/clIiozoynN2G70V3unRN7caaPvsl8DsPX+xQXxK2h7b880EMRZagDWC2xAq3JE0cZbf7OwRKAKIno1FYxWza5Il+ZkFQ+qOAjmjVWPrAFfSy+vIn/7Bw25w5AR87j0wflmQW+wY8nN+A93QMs33reVfUiPjrq3OCb9U7z9emlZfL32+z3MP72ocpwBby2dbff1Q+GdAiqlmSBVp9D2KVmzHyn2FjyfFnFF+hv3smQG+tvsbwDfkNyW/S7JBi4YCl6/7yMaPdsDa54eVlFkFEp7pM00Q8VJElhwW9DT1ozoC0jcio
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_last() to achieve the same function without using
folio->private. __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: LLM
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/zdata.c        | 13 +++--------
 include/linux/pagemap.h | 60 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d1904..78fd7d980e957 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f6..1e3462357aaa4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1415,6 +1415,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1479,18 +1480,29 @@ void page_cache_async_readahead(struct address_space *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+/*
+ * Adjust readahead_control to ensure next folio comes from
+ * [_index, _index + _nr_pages) afterwards and reset _batch_count.
+ */
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1516,6 +1528,39 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1524,9 +1569,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();

-- 
2.53.0


