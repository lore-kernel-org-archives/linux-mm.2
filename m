Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D2CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4D76B0088; Fri,  4 Sep 2026 15:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4855B6B008A; Fri,  4 Sep 2026 15:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3480A6B008C; Fri,  4 Sep 2026 15:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE7B16B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:31:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A4531C1197
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:31:21 +0000 (UTC)
X-FDA: 85177073562.08.0E05719
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97B514000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:31:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BURWUD7e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788550278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQfK1t3ARS5yaVkHM6he29FqcbJMCK4QOYVuKC9lxac=;
	b=8QzNHHEUyEGpL47FRZz1xDCEGe19ynlHJumzpLYBUvHaB/wVh6dFYTmsfPVmXzdDLFh/4X
	78dhNUFqdKiVIOWP4PUr5T42uSS1bhF82DG5IDIBJEBeffbrrQhxo+Nm4laRvu61/W2XGj
	q+KBaypqyTcGJE+OQURCMycGGvoVTZk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BURWUD7e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788550278;
	b=8NmUsP7T07+6Q3G59TUlIQOvXHrLT4J19RIOklQSlLxk42AqiI81kSgURLkOFZC7TQRMda
	9QSPJVuw4Ibm+21hqEXxAXoaINyEzgNIzgg43ibAeFQ/AcxWxu+zS2yW3oGunQt6whq8kl
	VusMj1Hn87wBqgPOicnxuzzjaLmgQYw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojx3efZwh9PubgWnz0/+dD1RHvpugiTBZZ6mEvm0V3Vz4AbFoO9/mAUEKHLbsc1ixulzlyykLGHPo3bdEHzSWJYsaGKIiI2dkpFuzNT9zvc25nT7Rq8eJbs/Wg9MpiS7kBmkxS7zK6rEB38NbQYJq2gvOr8kLK7qW3/IwsM1L+Miy45Jx4KXl+rV53l59MYErk/ck/49xmMu41+rhlqjQoLfL0xXvxmaUZkO7w0FzLNbrJ2l76BDv29LF/bKFXBYwVwEW2xPdfbLtATSS3/y1hy28JvMBjBPjEotx3w9oDF9CyZrq0dZC+ADb/NAF9dOkOT715/KAp0ujNHiknacLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQfK1t3ARS5yaVkHM6he29FqcbJMCK4QOYVuKC9lxac=;
 b=s+TD0E5UfugiFs7IAsyxIIup7Gab0b8GLX9yLGF2EU575mKJKMhKwYbZwwLPm9OF7LCneGjjtkvBSZ/97wA5tJyAqMm+t/rxj9pASTbb70Szq2ZkJLJ/f+NYhELhuPrTYE3H+0AfcbfsTNbJzrQhSbkjXw3m6iu7xOSr1Eu4Iscqj6KyyZ9XCv3C5toBCnhINph4vpkozcKxPw20ozFgjmcqezKPgZN3TO1YNf0LkTjEdNz8Szk727KJ7qm9GgciZMMMxL2ypldihibQzJYj/gwT2eLuaT5DSU6HMGmwBJp6LadnIaeiYdDyiT1tTCBxMV/a/s+T+0nM3+KtKzXk4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQfK1t3ARS5yaVkHM6he29FqcbJMCK4QOYVuKC9lxac=;
 b=BURWUD7eR4uvPA/v9h841CS41Y/4CF6eZzUD+WUcIMwPPx2QnK/yLl6drNF5SU+/dYNHH6+rrmp4q5l1M8zYAhjpfbwOV/rxkQYGnfLddNfyftusKMzY+d8tTINY1sUwAR59werToL0uNMu/ZhdxC4CiC7uOk4a7smffRc3JTssNwuYyvLA3CJ6xvXWc4RCAzmevDTwwrY3zMvokOWyOL8JEbqfxWfY6J+XbNtBDTm1/QfkryoRK/3Y0ayPLQQnmU2lMjCFQuVqY1w/zmWhgWDBac10AVAvEBg3MHog5amobHR/ON9gAKzlSORw85MFNI7SC8OhJlwOEdAd9d52WzA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7545.namprd12.prod.outlook.com (2603:10b6:610:146::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 19:31:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 19:31:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 15:31:02 -0400
Message-Id: <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <djwong@kernel.org>, <yi.zhang@huawei.com>, <yizhang089@gmail.com>,
 <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>, "Joanne Koong"
 <joannelkoong@gmail.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: BL1PR13CA0353.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 59af2a5b-3404-4096-c47c-08df0abb0eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|3023799007|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	+bsJZ4wUvkbyV9vcij+UKqa7RWskR6ScWEoKrXqmXUzNsQVuHcCKp9tjhCghBIYQet7Y6tzNWLwFwKwC68deY7XLb6nrZKj1Q2WGW2Z8sOFrj7UR2gKQSVhmATVwVFbt8lqH7I+zmTMw8H++A8evkpClbQeAMNba56jr8QK4xbvTL/VrGio5ZZhf51NaclXTsUghmlJgGGymVX3TFgDAbtoxz5f6UEAmoydMAhc/ElKAxPnqiFMPKYV+Z1QMsEfQnkGRTGAK1hqkxkEBQIjII1P3dYZt7bY8NSOavtLRTIGZzQzuiOwx2w7VaS1nbBuETej0uRo6/5nxuqxXcUvjDJxbGsGce1vxH3oP3VEgAvF5ivRC7dp3b1ZVt6VFRRYq8e/YVoPogmI9wrgbCShdegfKt1e5C2tZbrEDpipp8Oxws0CAXb2TT2LrJwaysqv89vCidbKCbUcs2458ENtKvLo9bHbOn0F16VT4PmyH7E/DlldqRDzjbBKGfZo709mR14aGh4wfkERasNsCHgMjetnqx9nsgZ7TodTQrBPgqp8fK6U8HNl0Tf5siMNnjcKgcQqY60R2DGnRS7rv0xmdrS6XwgBxqJbJeJh62AmiUssnLmveP8WKLtit3WlVqR/yXny40/Dzvih+PhzP1aAtThjNUujJgCNdK9KM3m+C1o0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVVUQUFDcGxyU2JsWjZKMGdTSVl5RVkzNkFBY1E2YkFBMzZPL3lScS9vZjVq?=
 =?utf-8?B?dlY0Tm1wRWJZdHlKVDNRZjFHNHlNaVNkdDJ2UTNnRGNhN2diZFRBaGlubHR1?=
 =?utf-8?B?SkZNSjhUYTdvLzZHRU1ta1RHTmVSZzBRcCtncWFUQjZVVldsVWRtTTNxbEQ2?=
 =?utf-8?B?V3JxbUFPbVpOdXphdU1WeVJ6SnBoWG1RdGZhQ0todUo4Z25tZEZua0hKaTA0?=
 =?utf-8?B?d3NIM3NQejBXZ2NQTlJCcDVoU1hhTWM4U2FTdEVVcjFQNGRoQ1k3YjRWUi9I?=
 =?utf-8?B?REJmOU9qb3RkWDF1Qko2MkJRN1hGMlRrNkNVTFFOaGlSL2JhQmljazlXMXlE?=
 =?utf-8?B?eFgyUGZKeExHTzRpL1RyanpSdU8yTEZzQ00xT0dRQnArUUpYRTJzVlBPVVQ1?=
 =?utf-8?B?ZjZrejhKQWZPamRmRVlkWmRNcVJlSnR1Zlc5QjdRUXBLUUlSNkJWcWpEUHJS?=
 =?utf-8?B?SXdZTkRVaDQzTUdPaC9RL1ZsUWwrWHRqcWJ3UUY0S1BvZ2M3SkxEbXBCZDFM?=
 =?utf-8?B?LzhzNVRaYy9XWFV2L2tIZWV2OVNJclZvRVk3ZGlkSE9kdnVsV3htODVIM1lC?=
 =?utf-8?B?aHlWZFAxdTh6a1dtcGZ6VHVsL2dxM2J0SGx3bDJzcERVV1pacXpKN3YzTERm?=
 =?utf-8?B?TWl3WE1ZVXZNZTZQYkE3NkV1bi9RUkdWSGUxa2ZRZ29BYmNnUlhsYlA3eVJh?=
 =?utf-8?B?ZTNoV3Y2VStQQ2E5VjYwZExreHZJMVkwMDQvampSMDdGMHZ3MTFvYXdTejNJ?=
 =?utf-8?B?TFh3ZDREck9ON1hDQWdiQVZXeXVLbDI5VXhmZUs4azNmRWRpNTVIaXFxZ2x4?=
 =?utf-8?B?alM0WmdnblY4SSsvd0lDaXEyUVp3c2kwa3paQStXRHJFRGs5eVEvMjhMaW91?=
 =?utf-8?B?UEdHOTAvSWxqQVNuQWZ5Q0djT21sS1VXR0dKR2wwaytLOU5NYTRTUllUQzRB?=
 =?utf-8?B?V0NMWXJQTk02U05OOUNXUGZvQURzaExlRFZ1dUE4eEx2b2VhZ0xZN1FaSkky?=
 =?utf-8?B?Y2ZjUWxyL2hrOEZXL2w2MzdaclBXSUl2dTk2L1E2TU15S1M5SVB0SVpobitZ?=
 =?utf-8?B?WEd3MktaUWZtZnJSOXZNQ3JzTWtTbzJtSUp6ZUtyR0owbWx2b0dYVWV0OTdr?=
 =?utf-8?B?OEN1THpUaXBFWWU2QmtQd3ZDMUhuNlhXdmJBWmpJdm1jZC9pU0xwK0c0TDRD?=
 =?utf-8?B?V1BKcGxRaVFoa1FaN0tFNGhtWEJVN2xscjlYcGRucXoyT0pMemJJRTFUY0pQ?=
 =?utf-8?B?WEFlWTczR2ZuNEFKN2xLWmFmSFlZSkxoci84UnhyRU5wVmFmRTg2QWhoWFcx?=
 =?utf-8?B?dHpacWhabWZ0VFFIL1dHa043ZklwQzVrbVppdU1HcURDUE5HampCS3p2aE9P?=
 =?utf-8?B?VGdEejdnMC9CZXJmWFBOTWRoTGFTNU15SmoxM1NUQjZOUFp1VTdsb2s0aml5?=
 =?utf-8?B?WnRQOVNwMThlZUx1a1Z4ZWcvaUQ0ZTlvei91d1NaMTVMdXhxcDBZRis1Ukk5?=
 =?utf-8?B?U1h3SUd6SDRDS1hhY3ZlYldZUUQ3SkFuMjRhSWdrZjFTc0EvZXJ3OWNKbHlp?=
 =?utf-8?B?L2pGeWJ3bHQ5OG41NE10bzZmNXZvRXlaaWV6blNzZjRDNGVWRXplazVhTnYy?=
 =?utf-8?B?azI1bXgySUo0RllZU2wwQlFHSEY4aTJjYWhHTVQvcWxUNzZNc05HcWE3YU8w?=
 =?utf-8?B?b1ZCN3BsclpKdk5CLzRCOVpDOFZPc3lsZll5a2JNNGFIckg1NnNmOXVCQUdu?=
 =?utf-8?B?UXJaK0NZRkpPR3pqUVBadk5NMEVUWWlibjExQXp3anpIdEozZ2F6Q3JTNHV4?=
 =?utf-8?B?SXErS2orSUNyaWhMclV5OWNjWGtmVHo5bmFpREpXK3E3ZkgrSlZQNUd5VWxi?=
 =?utf-8?B?L25FbVV4R2g0NU43ZVIrQjFhYlk4a1ZKNmxVS0IxRFFDS0VIc1MwM2MyRS96?=
 =?utf-8?B?VkFDQ2M1TSt2cTFGdU02WlU1RFBhd1VNSXZMckljUS9LZ3FVSjZDZUN4QXpk?=
 =?utf-8?B?VGRPRkd1cEFPM1ROV0pLV3FGTE14a3NhbUJUNDZ6WGFEdXVuVm8zdUcwTXJw?=
 =?utf-8?B?ci83Wm9SMHN0dlFwZDMxWGxvWVFsY2lxZkhLSWJOVlUrWlJHZm4zYlRCaTA5?=
 =?utf-8?B?TWhEVjRrdGFjTnVqQklqZVVkL21pRFViRDQ1Qi9UejJKNnNNOWtqejRXcGRm?=
 =?utf-8?B?OFQrd1o1ZWhMSFF3TnpmeFk3dFlGdEpFbjQwVEZEMUFTWU5SVHRUU1RUNlVF?=
 =?utf-8?B?L24zNnFIY2JyVmVHVW1LNGwwSWlTZ3dFL1ROS2VHSS9Dc1RyR0MwZTM1VXY0?=
 =?utf-8?Q?1pc/zkDLbbKSUhRbH+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59af2a5b-3404-4096-c47c-08df0abb0eb5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 19:31:03.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoZPOtgJQvvJJx8R0oezm5NgHU3EkQMMNq0DmiVGXsFcVFCz/0cxFOngT4VOo11q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7545
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97B514000A
X-Stat-Signature: qhwx3mia6tmcea1xodsgykhnumchafsi
X-Rspam-User: 
X-HE-Tag: 1788550278-571913
X-HE-Meta: U2FsdGVkX19xgwt2mAn7o4UPxWAgZD6NWaZ7GcL99JtJMRg8p2oExwj7UQ2pmlNG172DLnw9EC/4SyauZvlTl9lRKoCXst742cqJytpVwMaTvft454lz3R6CVuZe3tN3lEcNfe9s4Zbr8Ok+3/NB2x0MoEjsVGPRiV+LMgI2a/Mkfv2lfN7t5mw2Z38VV1/P6BxgBIvnevKzTslF6dTX0YVldRaEyM1Nkxb+z+DehbF725pXO8WSzCNhnVO0zIp52jX9GYNTFog+C2lewnPD8vMvJplioKiX1Mff2TM6ALHtifoNH5tLtGSw3+vDAcS0XYCJBzj+tO3ih6QF9rt8Sq47Z2CrIRWHYTitCeeyk7p057w9++h9V/Tyneb6PCpDkhpoMW7pNqxCriNwLRpSEuD3/krWwMY8VeeqnxenvHY9A6aIfBzG1AUGpvB0sk3AKvjXt4LC90bEVTdxPAbIlYhmL4GsvR/vYGNYCN2PAuwTT4E2LvE39m9JFVokKrr2PQ2BOsGvA/6ZeH/loOElFCiORJKxILtYdd7uoiOBUeR9UZjXYA2Rlzxer521RZ2hmUFpBVE/MFtexAk7c5JENgLsoA6FoXA5Z8v6yyY4qHOrJW2qZNF9DAKCiHXcZk4s3aaqDVlVxJXtVVcRs3BJNlGXa2DdBPj4dgp9bw/TMF1mNQuOgqFG0bzHc08uMWPsem2tSZwkr/+ZTtLrJsb+ijhmUAjhcjk0EQ9pnS39WQ4zUBD9zBQ1t6kO4DDC7IUGTJzJwnid6X8p/1hP1/xro2AhTG+FMbuFoDHE6Q+uT8CcnPnZmzeYVJY+LJKUcHJE+p39iclVLMuvtT7bDCQpxZCi71rcIbX3PnXUYjyfjoxQolssiDTM4zDdhQSdxh1Yx1EHZd2rr7/jW6r//ms1OhMnQuE4KlY3y5RJgxxrGm0bT8vTU70Xx/ph5eF7GnwUF2i+E3XWPZkYq1w/U3t
 +cEiY2Aj
 aUS7CpqoDgtEx9f/k3P10J6AeX/miL8WgEkZe/ilOftXMX/mFHeVbN51bT3QzeCinhFYE0hYjYCgkzt0E0SDIvQYsAp1sJHKCl7kDFpLpyOg7b2Pxf+kSiqtiUuhJcFKKenE3sY8vAgQEvoVxDgshZgGNLYi4hPIdZNCgUdnj9YZ1AyAt/fmaq9TPfH6ixb0D3psv+7Y31BCAdysdKTc/2Ri1PwqkBElD3eXINxWb4GZrtzhlu6xutlY3946SUbB0GfGYhjmdWf+zt8PmiANLnR4qcIzY7iRwi5b3HYnGii8onQb2xl7E1G84MFZ4OWAe57vJcKLx+emNdB4W2ii4St/8c07qSd5YWORNcR5FEDgVzW3XQK2ny/2A+si+EkIez5ORXkUznmw5QFiPeAdTBl80BB616FCd5iVmj0B+je4bCVpzRBkY10LUiH4pcYcCnNIHbRxgrDxn/2rANstB0gCIlb/asjEgaSz2APNmLgv8sL/ZDLqG68Guq1FPbLENFop1ZIVHkGMpwOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
>
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end =3D 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.

Thank you for the analysis.

>
> Rework the contract so the caller is told where to stop instead of
> silently truncating the straddler:
>
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.

Should we do "return false" for not split case as a minmal fix first?

Something like below. A second patch can optimize on top of it. Let me
know if I miss anything.

BTW, Claude also mentioned that if min_order > 0 and end is not aligned
to 1UL << min_order, there could be some issue. So

ret =3D !folio_split_or_unmap(folio2, split_at2, min_order);

should be

unsigned long idx2 =3D PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;

ret =3D !folio_split_or_unmap(folio2, split_at2, min_order) &&
IS_ALIGNED(idx2, 1UL << min_order);

?

From 564fd753071be9d59d9e45e4609a812bb81f778a Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 4 Sep 2026 15:25:06 -0400
Subject: [PATCH] fix unsuccessful folio2 split

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/truncate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be474..2c575f5e61889 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -259,6 +259,7 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		bool ret =3D true;
=20
 		if (offset + length =3D=3D size)
 			goto no_split;
@@ -273,19 +274,23 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
 		if (!folio_test_large(folio2))
 			goto out;
=20
-		if (!folio_trylock(folio2))
+		if (!folio_trylock(folio2)) {
+			ret =3D false;
 			goto out;
+		}
=20
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping =3D=3D folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
+			ret =3D !folio_split_or_unmap(folio2, split_at2, min_order);
+		else
+			ret =3D false;
=20
 		folio_unlock(folio2);
 out:
 		folio_put(folio2);
 no_split:
-		return true;
+		return ret;
 	}
 	if (folio_test_dirty(folio))
 		return false;
--=20
2.53.0


>
>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>     folio that contains @lend and must be kept by the caller's loop. It
>     is only written when the folio actually straddles @lend. On the
>     success path it defaults to the page index of the end edge and is
>     refined to folio2->index when the second split fails to isolate the
>     tail.
>
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new @end output and to separate byte offsets from
>     folio indices.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
> only when the folio straddles lend. After all, no caller discards a
> straddling folio anymore, the in-range cleanly-split sub-folios below it
> are still dropped.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/shmem.c    | 12 +++++------
>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 41 insertions(+), 32 deletions(-)
>


--=20
Best Regards,
Yan, Zi


