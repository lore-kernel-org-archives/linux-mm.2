Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA25CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014716B0005; Tue, 12 May 2026 22:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F079F6B008A; Tue, 12 May 2026 22:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6226B008C; Tue, 12 May 2026 22:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDED66B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:56:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7818A12065B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:56:53 +0000 (UTC)
X-FDA: 84760884306.10.216EB82
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 545C720005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:56:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qL7/c+sq";
	spf=pass (imf03.hostedemail.com: domain of bharata@amd.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P34angjjGWaJd4r0SmY0BxTaEav+44UAQbeq8l/Xvqg=;
	b=cNuYc01wFXM1Yv5VUUYwfW9SOGxJmXy2WXSl9xvPpVToFFKcru1YtbbhYt2bdyYo7SEn6P
	p+eNa1qiU8Ly5JGUaoFIlcEglDn4UvC6ZnNG/0o8qwYyGZv3KKxDCpAAVvH4L4+mdOpKpw
	DRY6ik6+dcPG1delYcgKr1YudhxkN9c=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qL7/c+sq";
	spf=pass (imf03.hostedemail.com: domain of bharata@amd.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778641010; a=rsa-sha256;
	cv=pass;
	b=SQynYflRGRK0DG/aFKOJwV84WSpAbjoLr4bVN6pgWmw5h0CcRfFPeFgDPR0wrIHFLTOEEv
	S1r4F+eTAaG1wEbsAGtJ6TWbmq2pfdT+Wl/yQGa1KonAqWSOkHn6HjQaMCsAozHnNn99it
	xltDyCHzfGEflTud0eSGScKae8gHWOA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6G6qoo18a1fqSNbqpi4n30+MPKu4XaED7629y+d8R21CnrR+UfAhXhDHqGKnxjdCPj8U4pzH315GzdmdxTUfhWac24KrbOlsQVI5KJz8+zPPmihIfWPLQRVsOWQGVIaJIc2dLoOwnxGfloIsBOTNK27PmNqKy997hj956pjVAwlq2m0Tu8zIvtYZRoyJJ0uYR/gXUnJ6s56mJZcMU5hq9Voo1puFXw+5opszj+yF5BvEevfDoK8ROC2Jxd3kWyJPe2zsD3H0VjwrNP+cU6ZWKxRk61Ha5tMELxKYlSThMS8QUgMkWIMoC/LkCPibkQMjEdUzRYjK0JCenKp+juKfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P34angjjGWaJd4r0SmY0BxTaEav+44UAQbeq8l/Xvqg=;
 b=sNb4tzfS871Ipmyx27casaRh1a6wZetVN78aa/acgCHojpOIbVVqBVNtsv6cxaHf9lkSGu0IU++DCc1MuEIWM1/NSMB1raBXnYPbbVbeZIWObeQ2l6Sveaaflv1RtVR+6Pad4n4yq6KxW760cDc5CbQ8uimNV7H5NtnjVyzh9iQH+YHZUDt6e/rG0JlUh3uP2pJp9w3Sj3qEqyayujZifk2n0xCXnfMlEPf9BP4B5KngxAyTsH9jmOnT2LpWKSGULvVWZMxhk2QHopcvmDV99RKJE1BQmqSxKxSEz/7NvtrkS4BQcqVbGEycYyipQUcKK8tjxi5JbPN5xgo2H0zbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P34angjjGWaJd4r0SmY0BxTaEav+44UAQbeq8l/Xvqg=;
 b=qL7/c+sqyZv0PB3+kLpIKyqAeA9YeADlxr97uQ+sTdnPg17CzZgnS7wNlx2Cw2TNxLbM080zya1Pdg0NA5/+vkm9nTxgSA4HRwS42VB6snsGimmM59nHH5et4/CPMiguQ9TuR0DZF6jGJbflUhzzO7Y7ST5ajgTNNZ3ZzwIziVI=
Received: from SJ0PR03CA0148.namprd03.prod.outlook.com (2603:10b6:a03:33c::33)
 by LV8PR12MB9406.namprd12.prod.outlook.com (2603:10b6:408:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 02:56:39 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::6c) by SJ0PR03CA0148.outlook.office365.com
 (2603:10b6:a03:33c::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.11 via Frontend Transport; Wed,
 13 May 2026 02:56:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Wed, 13 May 2026 02:56:38 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 12 May
 2026 21:56:38 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 12 May
 2026 21:56:38 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 12 May 2026 21:56:31 -0500
Message-ID: <e4ea9218-87c1-4b9f-a241-6a2e15e1072a@amd.com>
Date: Wed, 13 May 2026 08:26:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Gregory Price <gourry@gourry.net>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
 <20260508181812.d2ab17b08529f17b330e157c@linux-foundation.org>
 <893081eb-d747-458d-b6c6-86fb04bdd5b9@amd.com>
 <agHp3ltvUba92LZr@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <agHp3ltvUba92LZr@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|LV8PR12MB9406:EE_
X-MS-Office365-Filtering-Correlation-Id: b81ae7f5-16bd-4327-9255-08deb09b410f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|1800799024|11063799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6nXaon9gQFKti3IyOEhYmDC/NVGL1sMHOphMT4uxH1wAO1fj0N5RvvytMWdKi7ofuK+fG0Rm0Kqsm7X2FmKuGlrY3NG7IVLiOLcV6qlOQQd6I6FX0dEFcypUUG4RAOjBCrQf6sPkNGAOFRqxGAS+BPFZKOOVHCBYaycsSHfZpbK+W2/rbDjSn7gdCRXsOkbyuluGoQGdeS7Ts6swFNPOY11I1YdFkt7VdPQ5/BwmG7TDxWUcSJcodyXaFvjIS1SxctyRrTW55hoRRqrwV+FJIPNgMdLAAQg4H5cDb5NDfs+0IBtaKRTt35zhsyB+q9gKc2r3hIKM7z70juw9DB0XNBjpjma6LeHPYRcvjC31S3Gw9t9qqAn9mnLpP6jV9gOj7cZFKesBwcNH/++zFBUb9gp2OhtpZUSqrrC+3Y28eLVr15RZp4FkqWiI476CtvV5OTeKJmYnu8PisxjIpDOgKW8pCVVvhXlehEkxXFg5QjelMnHXW2m3QJtoBg9b5WMqa0F6mB8AzHVVvIpLbQCNipnDH9brdm61T7WPNuhnstJDFiWI6tZRpMbXD6iO/dMDH29wuVqZzU0vi2bjCzlvyETg2o2xzSLlqbfr3FDCMW+Qmrmayqss7oKy1A0AcU2YM78Q0bNlMnLSuZOUfMoyarO2l1RUfonN4zecVx5CcUUubrAlj0ZykdCw85Vq/Ds7lu0HGg+E978IdxFsrp1MZ3PBusoLfgl643doZ/ArnfI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(1800799024)(11063799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4zqD5LKXVnKJ7PBOhg4Wdwl3QnJJ+44NWspzFwvoNgTtl+tJH/sOzvTuUbjv4sWjgwGaP1rDCxrTyMIe5ie50IcdImboEb7D/sSbE+M/XGZ8ylPOasbRvZvljSFJIV0Kb9OJVzxXN2AmZPVDibTpWagpe+5CzmQrMOCDco/jDjK0M3jp6Uwe6M4rK3nWE8zxM26nBqv4LxFK1QBtp80v4U+2qL054fDVGSgksZqkCRiGmQmw/+ozMAvZIbbswTChnRD1Gda9kQRu6yUaBiUTgGzXEbOw1/23loz8SOwKwzSelWP7e+MzvdEAG73+rqD5fgQJyuEYNjKns2MhyEy47ZUrWDSsU79L5FKByW5+/ekF6aMIdUKBT6mouoam5ZpTK3NCFk5YdG/Dehk3ynxM58zwheEP52HhjyjyNdodLOeL2K1TN42EEgd7ffX8+SXS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 02:56:38.9800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b81ae7f5-16bd-4327-9255-08deb09b410f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9406
X-Stat-Signature: ikm8auschti6reyia678yh71o4d56ttj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 545C720005
X-Rspam-User: 
X-HE-Tag: 1778641010-207229
X-HE-Meta: U2FsdGVkX18HK2jQZF5kYLdLyEQkZ3n5xbsFJ4XSVqcYXkYwmVetusZlAqENR13aFFBb6RzQ2SRXlljZ+EWnHKtrQGvAZk/o4q4K1Un2CZ5N/HS2cEDfX2NDPdu9WhRTqPNWpwzNKM3vsIF3K71wqeldRd9Ucjobou9Gms1/ZM38fiPjtWbP3Gmliu/dQiSIR6uWt09W52/JeJtWuRX+VL3mwLyx9ZszLn6YjjRVC3uQCEfgewn95K6J6KFjTGQi07o7ep7yyeux0o30NfAf/U3/rR0MBJeAmVSanUyWdIzJHmGvS8bE2uyl5AgjdLf8JBnes4Q8Ye+gQSeQ14UI2HS3TpzQap0SYHHlzlKMKKGTt/KYSNPsRyOy2LqVWkvdqdXXp33If89tNlCRI1WyApYNkOvqkE9ZCwbUpwV9Uf6ktX55KCq7OWzXEUEYTBh2bmXIV694BFORvSpFhmuRqMk6QMakz6leNfARlV5mM3vckWtdSKRy/OAX7EGC3NsBZLmiWzYObMVjouLz7NqnoyVZak+G5JQg8htzdObkYTaYK7YXXjOKE9eP4G3qw+h5qjJNHtdy/gKGdu9WTS9p2dpGNIRTcjyGAqBdBze3FWTTfj+4XyMpXUoJhf+NCwXKL0S3sKS6dKFhApL0+ARMd/+jrGL5EQZHwE6Bkju+2auGolh84kqFPImN/DG8w+AOyNRI1PCC1Orva4V/NIQgwGFieFduBYBi9vln9vYPerLtLnH5Ct+8URqQmz6YbRB0jlzstFmGyH1j93UzpNUoWL2L+RsDqfasB8p7RuluyQWf+fevSj2+VKYejDP5RJs4lhTnIRfR9sQ+F3JiQtDXp46UJi2SVdUFzrpFTV9GlgEfAFmu0wbdUXbZ60ym4qTQ3561XDvBCY0C3HqPfpfLxxOMqEh46lS2bHULc3dXnTuJAHyuFSDkXleVAGJrbDPDAO5YKbkqPalwXGqX6Oe
 N1NYAOwy
 9FXPKcDPgA/itCifGbdrfCg5Oo84U4KyVDkSEbIoMwKQMaaINdgoMHncttlZk+5y6qQcuz0hKzgq6/FLWq9YJdbXGHg9lESUilfmvgGxlj2FJp81LAqblFmQs68Sc7ibWMn+PqBbvxiqdu9boK4gwL0/XexWnC/0DHX+pbGRufgdbzPJSxfR+dbyOJdk/RzxW2/Je6pETxnXyWOY1znZkheyqnEFKI45aMFIquUmDAi1lcoVaqObYaYsunn27/tSRbdA1D8v/2eET8wQMZ8wOf4dhWZoX3JfLxp8nav7t6KPu0inURYAnfmChywk6HsoHrpX0SzKh2nUrvdKkSD67D8dxH1NyITMZQ/T/UtkNwlOBIFB9r1dvKo7oitCoA0JT2JmdlsHQwoJm5wirmFDWVcHHNp44Sy5WS7vHFv36OAKA8Wom9+Vd0wDQlKjKrPbcR/YwzahBJ/t9Ac932gfSwmBKzFMUl57HxqEFSj0xN1/2XME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11-May-26 8:08 PM, Gregory Price wrote:
> On Mon, May 11, 2026 at 04:07:16PM +0530, Bharata B Rao wrote:
>>
>> The entire point of this patchset is not just about improving the performance.
>> It is mainly about adding a new dedicated infrastructure for detecting and
>> promoting hot pages. It is about having a subsystem that can act as a single
>> source of truth page hotness in the kernel. Though we aren't there yet, we have
>> started by having a minimal infrastructure that centralizes the hot page
>> promotion and associated heuristics that currently sits in scheduler so that the
>> same can be used with other page hotness sources as well.
>>
> 
> The goal of hotness tracking in general is to improve performance.

Agreed. As I have mentioned elsewhere in the thread, right now we have just
moved the existing promotion mechanism to pghot, hence the initial concern has
been to ensure the earlier performance levels are still met with centralized
promotion engine that does batched promotions from non-process context.

> 
> The goal of PGHot should be a reasonable baseline for the kernel to
> course-correct LRU inversions across tiers over time, because LRU
> threads only scan invidiual nodes and don't compare across nodes.

Right.

> 
> I would hazard against trying to wholesale state it "Shall be the single
> source of truth", as we will inevitably discover some condition which is
> not covered / cannot be captured / we will simply get it wrong.

Yeah. The ideal goal of single source of truth may be a bit far fetched but
pghot is definitely a subsystem that can work with multiple page hotness
sources, aggregate hot signals from them and provide a single unified promotion
mechanism.

Regards,
Bharata.

