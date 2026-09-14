Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBF3C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAAC6B00A3; Sun, 13 Sep 2026 22:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410BB6B00A4; Sun, 13 Sep 2026 22:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B11E6B00A5; Sun, 13 Sep 2026 22:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECBB86B00A3
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23D691C3571
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:43 +0000 (UTC)
X-FDA: 85210774446.06.9D433F9
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F7A8180007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=p0DQslNu;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
	b=vAzHvduNJYN+U2VjAe2d0NZtfOTyS/sjPUCF5FSMLeRNhb790Pv/60ePMLkPk9LRJPgxP7
	3/LgWNJOkMOqlZLTSGG1k2iNPvE33Y9gYK8lSsAiXBPS2AJR/i5f4w8L+k3enkS59jvr1b
	CYcN4z/3/SKrowJBJexnkqG1gcXZVUo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352680;
	b=j055ii6OyS1xaYKn6WNFfNaWXbZnjY1t8GdqAzfxPSNsV+IXGOShznD6M30HoMVK4x1X2w
	gEEKNgqimnSfFzjO9/tbtdg09ntP9wmCRl524HfoCUV9hwVKVMlauUOi9LVGIpxSem5OZc
	GsHDMwKpFJXReuQILFu4zehhDK/ZKlM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=p0DQslNu;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LM9M2Qdhm3GMwseAMMjt+SNQGVsvp52i3pQtaE5QTCnEXRzTa8GroZAgYgKAaMBqj+39q6Uxkv4vPq9LwSji55DosdtS84CcVxWLNNM20CENfwF3COkofeOoUwxnPIEWWfZB591xhoYWfJWz8wFct9rfe/kpCvo98YTOI4r1plEIxWusikpN3OXIy0ECSr0RiGCKhomUR5tv3TqY594afPlfc51fsnP/6PK2N26n93H2rXE+LcWmBGSrlhCKbfyo5E5Es+YHObdKcNhGYky1dqQaunR+Nv5wPKXPgYZyml5xxbqqkrY13SLxJtD4h6/5kWv5fb84gXK188AIKahobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
 b=LMAoMAyLz8M0UiVKlZHeUt+wVzUEv5GOA0XSGEplhVk3+j6yG71jeDjClr7U8uBsFeTwTKz2DgvIE6muMSCu1/W+Yh8+WlvgC/EOKy1fsApvAkxnegvgGS081oUjnz6j/LBSkLXMvkk27Qaq8W9KrYqaMNRGCcv8DoujFW7hNoLEGU9hixvRdupLnBT/xSuqfN7dsHfE9ybB9QhBuJnLvBM8tI7hxyOzb6A2RB8ptDYZx3Ri01AAZYvIPZ2C0JMEmLsDsBcutlCdptDbbj5+rn7gEMoBsexZixXskr9jJEKiKppQQkNxECkZZLH/n+xilzS5Wl/XUwdmofxe7aX3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
 b=p0DQslNu6b2Rasu6b42A1pguk18eeW5x4AJ3ewZzlc05GsX62B+sodBgUzWh81Ixo65NArzhngmO/d2p2zQmLUErO7+In2XVYY3kKQ2DLYjXzD668zyVV7hhR2UHnLQlrYFJbqNCUY5xK85AbRnqP10II/DMeYbADfL/LPAm8ITY3eF3S1Rp4e3/SM+Qi3hMqfs04MnQFqSqasJZ6IyHdP8FsAhjnTTEqKeiGwZ1S8Qliyx6UapemT7laMKCAURTYgwVDGke0A1HRaDq93XZ+Fb+xGLlTP06vdJTqAAWEALouDRnhJYkH/RElgmpRr4sd0D8Cl06Jaq74REkFAwYpQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:24 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:09 -0400
Subject: [PATCH v4 11/16] treewide: remove folio_set/clear_private() usage
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-11-848550f7574e@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Trond Myklebust <trondmy@kernel.org>, 
 Anna Schumaker <anna@kernel.org>, Jan Kara <jack@suse.cz>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, linux-nfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:52c::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d7e7703-464d-48d7-f4cd-08df12074ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	q+gLqFu8heqleHJV/1a1J7FOrMr8ZveeBoOa6QVH+Q79ZGOBHdbE0D5D0uiHNFhX1C2ySmbLqgQAGKAynzNXL/ypjxzIBZeIS9Zy7UP87WmxIasiEZhI+FBiCXWu/SaykkCtlWEHm8QqT5uJQZ7RMC8muWTO4AYegp6ySkfoSN2lFiSZZQwEdYQaA8c1y/D521YXzyPeIu+obXv/Ed7lV/ySZjanFpCuuP6HBm/FQ63+V85NSm4sh8T7lNsBBuoLTM0mStvR6hshUcQgXCQuVeD+4cthZybRGL/Qq116tlGBjcRsDFc5PZ1IDFrnp3SqvpdPG3V38TL30UTi53Wv3NBokXHpBaFgFX7qOhNq+i/kSlJBH7SaiYc9qtCUzPyn6jS4N7AZwkdYe75lRIN4n6RiFhk2lGL2qXIK8Ymu6ysu+BPTJFI08dDjnVfgqebAvk5EodxnMyvJvYJFUW4/wQxYsZf7eP8kOS7T5jK2VkcoxxVkAsaNr9GFxQxr052gEwJOzjMzm/49fRsyI4/en0l12eYgHs+jRQ2v2LlSkONJKeaLUwThW7/cNeJsja1P6ZtJwV6H9eM4dBpboAE+7wKbv7kadRmc4bZq8kZAJKIJTMuWK7n+c7snNyDK1qXr6fP+SxpFWJwZq6dep3KDufPq+CONEYnQ9gPoy4NJgYhCWjSXBZFZjCDQ9evJlChaOftG73Z0LiMcqqY13CtF4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajFvMkZvNGNqaWRDS0FiTmJtNFVONlJlbWZ4NjlreTNoVWF1d2xZbXlEckVU?=
 =?utf-8?B?TEU4em1wRmdQckl2amIvOTh0VUlGL0JKVkVVSWVPYlhrendFdnNsVEN1bUlx?=
 =?utf-8?B?YkRtUEtpNnRIc0JRUSt5Rmp3SDBDYjByK3ZYeU0yYzQzMVRYZUdWSmZpZU83?=
 =?utf-8?B?aEVNcEVCa1JKVXA0ckRqc3ZhZDVoUlQxYnAzWkNvZ3JueEM0NzJZdXA4RUV4?=
 =?utf-8?B?K0FGN1p3TjZKKzdCaFh2LzdrajFMVTFXM0Q1dmFIeUZ0VFZKTE9yVkNiL291?=
 =?utf-8?B?Y3pPS3NBdU5PYllKZXRSZmlBeEUrQWpnVG1UT3kyN09OU2Jsby9PU203eDFZ?=
 =?utf-8?B?RXF4cHJHdHZRdC9taTZnWXZaZ3pyd1dta2N5TUdGbzZ2MldhNlZHbmFZTzd4?=
 =?utf-8?B?RWlKVmJHRHN1MjlMcTk5Z3I5a1BkeGVHcGhSUWJHckc2Ui83c1MyaFZPSlV1?=
 =?utf-8?B?LzdJZnErUmlGVUo4UkdUeWZ3Y0VmMThpRlcwMzgzY1c0U2pvQUJJeVBXRVY0?=
 =?utf-8?B?dVRLMSswWEZsSzVMYitrVWdMN2R2SGU3dGhobTFUaWFBYWZlYjgyRGlCdTBC?=
 =?utf-8?B?eDdMRlozbzBaZzFNUEdJbk9UWXBPYkFiR2JRUE9XSURSSnJMcGlrLzl3dmdi?=
 =?utf-8?B?RU9tUlYxb04rK0Y5N3BrejFZWDZpeWoySlZGZnFtMDVHZ3p1ZERCbEQ2cG9s?=
 =?utf-8?B?TVpxczdvZDVXK1lSc3hwN0lOS0V5bk00UEpkWHI5V25aM2IyWEgyaTAwWmpi?=
 =?utf-8?B?WUVCdHR4MCtVbDQ1SDQ3MlhJanBFVVVDaVVpd3RsNE9yaERGaFg2dlFTdWgw?=
 =?utf-8?B?WlozT2t6NGJPV0tsSDRVQytaTGV0S1pFMGZ6V2g0dWJIOXIvd2srRVVmSmVD?=
 =?utf-8?B?a3VLR2wyNzVVUXVBbkx6dStXV1ZnTnhXMFY4VktFcmhtUlRZcUl2bys0ZUtG?=
 =?utf-8?B?Tmg2ZVBlRkR5VEM3ZEQ1bTdQTEpaZEcrUnlFbXJ4S09PRzdZQkR0NjQ1bmha?=
 =?utf-8?B?eTQwSWxiS0dyc1lMQUVCb2I2c0JQOUhEMlZYcXBsL2pZNldOeHltSXM2ZWk4?=
 =?utf-8?B?NTZ1UEU2TGVqMlJlYjI4NHhhbU9COXVCQjFiTTZ6ZFRxcUx1YkozcTBVYWlu?=
 =?utf-8?B?VWkwVGZ2by9sM3NkL0ZJM0NXcG9KQjE5KzBQaTJJYjh6NVBCemhham1ieVN3?=
 =?utf-8?B?ZGlvU3dpQ2tpMlRHZkovTlRNTFFXOG1HMDFCQmxlN1VWU05rdDQ1eDdrblRw?=
 =?utf-8?B?bTFtQ1dLQ0swWXhQN21WbmZER25sVWF0TEp5bWROYXlNcGgxTTJOVEI3SEJ1?=
 =?utf-8?B?M2pGbWVkOTVHdlhnMlhJMGxGanc1emVzakEwR1A5OVFHaUNWK3l4V1l4N0Vl?=
 =?utf-8?B?RysrVHBScHNEc2xRZHNSd3pXWEEvOHdnTFp4bkZCc0ZTYWFrUk83d0U5QnZ3?=
 =?utf-8?B?Qm0xQmJYd21uS1RQL3BJM0VQV1lRblllbWVDanVUWC9YWXJzZDFPbEVYNU01?=
 =?utf-8?B?RGs3YVhsYmhtSTR4VGNaZzl1WXk5ZmRBcWRXKytYVFVnek1PSlEzOE84cHho?=
 =?utf-8?B?UjRBNDdGaVI4RlpZMkt3WnduWWNVUWR2SS9memNmVWdjbmNZNWN5NU1SMXZB?=
 =?utf-8?B?ekt2OEJncW90Z21wWDNpd0FqNkxLTmd2cW9zZzZSTXhQT2xGNStGUDNiYjM4?=
 =?utf-8?B?TTA5OVdYYlJzSklXdGVqeUpjVnJkNzBsRE9DVFJlalVDaG9VL0ZrNGd3T2tF?=
 =?utf-8?B?K0QzclVWTFVSQ2U2QzhwY1V5dDRGc0VMdVJkRHRIcXJIZEtpa0dsQVVRa2Mw?=
 =?utf-8?B?eFNEYXcxY2E4MTRTblhsSnBGb3FnQTFDVWFFYXUyc0FlTjVTNGVac2pVUmdj?=
 =?utf-8?B?V3JVVElpeEpSWjlsRGRZZ2pKdnVWVmVzQy9ObHNoTWVVaU5kRnVpamlhNkxw?=
 =?utf-8?B?ZlJQdXI2RHllQ0cyU0xQSWlHZ05VWWhaMmRYUlIwYUVGSm9iUy9jc2E4aFRx?=
 =?utf-8?B?UlB6N1FGKzJIc2UyV2hWZjhMaHVxckd0Y1BYMVI4YVIwY0hLZTlQVTFDU1gz?=
 =?utf-8?B?ZisvbDBFblMxQkdWY2pMd0Yva2F4dmIzcis2UTNQNUZTQXkyOTFjbUxraW5Q?=
 =?utf-8?B?WU1IY1lTNUxNcVBURnE3akVYT1J5Mzk4R0YrQXprTEtYMWo0Q1d1aU1XeElT?=
 =?utf-8?B?SGpjSjRNdC85VmJmSGQ2WWF3RExSMzJzQlBjU0V0V1lGa3MyWEtmNlI3NGl3?=
 =?utf-8?B?MVlueVBPNzdvRWlyWjB2Tm1IWm1kSW5vRTlqOVFDUmgxdXM3cXlUYXJTMFM3?=
 =?utf-8?Q?1QBu428U+UxwQK14U1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7e7703-464d-48d7-f4cd-08df12074ace
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:23.9942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQEinLwrvbyOXbZW5X63oJizCJcxy8SNDUBLwikmM8TDk7IPgbCIidbAU8KxxU8+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F7A8180007
X-Stat-Signature: 4ji6igwmawsn6wtyr5ki8i1jotn91frs
X-Rspam-User: 
X-HE-Tag: 1789352680-518967
X-HE-Meta: U2FsdGVkX1/rbRy+1fDGR/U9mkBJZVxlIeMLDzyFa7FEae9wdedi6fkLYTmyNn+gcHpdle2CSo7C5NVpW4SSrYMbLoaXStXBGXjRm9a1o7aG9IU7fG43YjL+kPpDRjJCnvhz2Ygo5azQrIpULvdiCCVG11vxYFk/w0ipU4VeVodrv5phJexjin0BYZkZoe3kMwRUScy3MNyCVWh3opMUnrSZW6DmkDmtfz/SpNgIyFlOURQtJie2XtSVFNAlqxJbxq2Zl+8ROk0ADcgfaI5FJRLkvcBjTyhhkM329pvO9HWdUdGxtXXrkS1WoEEkZX5AFP+EvTwySJDDXTkNhvcSn4afshmC8ZESf+uu0ClNJnDJfafPMoHG1CnKqzlLd2VHwiQUJLrzdjIcBQfUyve30oH0KHEiB88SoAbR4COHojA3gRq0u8+ySxVu8pYQOhvpgi+VuJhIyMs1Vq3BcgKIFNn2Lfy1BOQrTArkQFN16EADkQAXNLtEspHA1V2t5zckWW0fwn7JFYpaXNUOb3kaKl+nypYMAqZ2eB3dDXMu1A+8OuZ2sc+5x0kxgJUMa8u9Ty3Q0rJ7sL+7pPqPlkLeNz2SP8XtF0I/Md026FBx2Mf7+G80MdioFDz1a3zZsybsIKaYB4YJ3hVbL6oKbSKgBpO/bHhUDs0eot7CtF7rXZXcohX/U9hGWkMgq7VcOxQe1aYSb8Igsj9rVrd9/BorhTp8q7IflOTKO0EcRc9+Jh6PdIqgZbI/LEFk0qZPEPHdekQ2YVZOT5pcQroWT2vbf7gqxDt7lTUxKg5qoE8eFFjwbV54xy/Gg0HcIGeJ66waXZP4v1qkx01WB1etb4kjOTKb/SiDg1sl8Uy9h9zmRuYkzwqJUwEq21BYYRpC1VJ5kFqBGGIqCXwWi+VPHWWdsibxpcn6TjAwvGH4NuxgRJBRiG5CX931eA/zwCKfXt7Ag3MZ5laLiOaiSU1e7cB
 FODMwjJ8
 vnW+/J4rtf+2p7LyyRQdXbihgpGdvIHRBY/ep9wiePXEvIhBa54weLCE3D7n3MWGAz2s2/cuKbYQN4qNUXrRUO7VUO36WxlX/h8GMmFAEUB3kCzuV0t3J3Zzdd/t1q1KRE4bxgCh5WR2R/LUQxlXSX5Bmd2YGxzmzMh9+3nJAflqw2jt9oVEKqjJ/RRaS59x+UvDOwf6UxJIxRzKoWCVLYfxkqX+4AOI3eUt98vTy8qHHXQZFaEi+oZzBBIzFrtii4IxjsSh5kiYMF+ACFI3ChxuD9bXqXRsm5NXGJeq0/6Q2dUg3nLha4GaQzD9TEbWicSSQRgSDDKKKuO/WF4ugT41M+ZVoI28jv3rtU+0KRP1g+saZBPugaNc/HzUd/ClaQA5BugqVlIherEp/V5TZlndTCVQ9UGpW8HxzjclTT/bOWVTkVLKiYTZo9hQ38vaidTDj/QAY7OBVUZp+u9UmJX3YEUtuPzlY9SiwOVBV2/v+t3iYuIu57fDcQ0A71N2cI2n6u6qrZMQj/F7SNiMGm4hNhm/0S4Phvz0dZ257qHr5zGNCPIqaw46KO94fiujLjbK5viI/rh4+jYosis6dLyYAhJamjm41ofi+SA4Ak5LNaWSHFSa/LjZZgs1NEFhUlPwGQwgRq1V71W4U9kZbPOF5J5I9Dg1cB4qmTKu2YS3ep99sLK/2D2lDj0ZaRSF9HGf/xc5eN31ELOFq9z8PrHEHEoxyL3oc73KRArAWTsRyOB9JzU7m/jtWGCj1zob8rr0G1RVKXDnn05J7RJuxybkwHquavFD+lGhqvgzVCWd14RMLcQqBv+059fl01gTiVZVbtG5r2nqI8QshMwZVOwZnGNy7e5Rf1FxaCWRJ4IuRRYRd26whHYbFMwKKwK6O7v6U+yaDZTh+PNpran8+bbU3kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are no-ops now. Remove them.

Assisted-by: LLM
To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/nfs/write.c          | 2 --
 include/linux/pagemap.h | 4 +---
 mm/migrate.c            | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 623e7ef1f73d5..b6967b5286691 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -717,7 +717,6 @@ static void nfs_inode_add_request(struct nfs_page *req)
 	nfs_lock_request(req);
 	spin_lock(&mapping->i_private_lock);
 	set_bit(PG_MAPPED, &req->wb_flags);
-	folio_set_private(folio);
 	folio->private = req;
 	spin_unlock(&mapping->i_private_lock);
 	atomic_long_inc(&nfsi->nrequests);
@@ -745,7 +744,6 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 
 			spin_lock(&mapping->i_private_lock);
 			folio->private = NULL;
-			folio_clear_private(folio);
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 			spin_unlock(&mapping->i_private_lock);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1e3462357aaa4..bcbb0afe1a681 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -594,7 +594,6 @@ static inline void folio_attach_private(struct folio *folio, void *data)
 {
 	folio_get(folio);
 	folio->private = data;
-	folio_set_private(folio);
 }
 
 /**
@@ -629,9 +628,8 @@ static inline void *folio_detach_private(struct folio *folio)
 {
 	void *data = folio_get_private(folio);
 
-	if (!folio_test_private(folio))
+	if (!data)
 		return NULL;
-	folio_clear_private(folio);
 	folio->private = NULL;
 	folio_put(folio);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index b7b92925a28c3..7e3a81f069744 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -835,7 +835,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
-	folio_clear_private(folio);
 
 	/* page->private contains hugetlb specific flags */
 	if (!folio_test_hugetlb(folio))

-- 
2.53.0


