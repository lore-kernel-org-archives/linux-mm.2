Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91FCF94CC1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADAC6B008C; Tue, 21 Apr 2026 23:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D656B0092; Tue, 21 Apr 2026 23:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173B76B0093; Tue, 21 Apr 2026 23:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 058B96B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:27:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A445D8D7AB
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:27:21 +0000 (UTC)
X-FDA: 84684756282.06.9801320
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 790011A000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:27:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bx4s9f5z;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776828438; a=rsa-sha256;
	cv=pass;
	b=zJv1mXHNrq73hz6LKQiQMz3E2OQlIz/JtFwrTow/6+KI8jYLvYOYSdNrTZOne9yGUqZqK3
	01uJ18Z3OvoaiuWqjVXvfn3Fp8Aj9qkMV/fuC1vCAKw30jIU44gEudFh0lO4sXRdnpJcoI
	XZ4qg35tl0sc0GJ7R1KiavLBuC7kQhA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bx4s9f5z;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776828438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGuw0qKrR6NId16vPHAs4eDAPBIuuGDuK4dVXJGJvYg=;
	b=iX/E4hsKQjkBGCWxyYc9CRW+Ie9bwSZRAa3G1gm2XE6TECzgm1EG55LrKqN8/wE+lLtmME
	5uGoKo7qOBFTDznNzdoYAFZ2EvwqRmnDSeh03nsWHrnZzWuCK3vDtKlJizxew/x0VMvGfe
	ATwxL+3bMjiXRWoxNhWCwCKMfNalfSU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLYI06uSZmTviDILwj/LI7d4W6gY2GG0NN1UwlXZD+j4GJpXdn2Arr+1FVNzf8esL+mwMifP9J0fG9I+bfXYvvPNejnWCPjMOGUExE+6CGqu6ZnOJm2PdfcU0ipxJ02N3YSoMMdwxV7MS44qB/eljRuug13l4fPCpq4cEUSLlECZxFlCE48FEp1MmcVhj1gpZtQuk9RGgoGMcG5umdo4OEexeq4nFAmPk4b/0DiBiC1jUGyadxIaxvsX4+TNHLbDaqqwnQHJcWxvsvcAe6YYhglpGXJJ33oBVW17bV1i2RFgGwbalNbfe0r2wrlU+/EwYoBplDBRHQOsxkSiV6hQww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGuw0qKrR6NId16vPHAs4eDAPBIuuGDuK4dVXJGJvYg=;
 b=LNTVIi/0Il6zmgGZNoxeyYBSb3wBaIF65vWbKyBQa45hd2VkqzK129gcEh4tWuSpTkxbkWiDjtiLTVTqGIwF2aaMhpweqzi4OzB7ig7KQtwQvm+3tkRvdF5grGS7BZd0ZQdAFPfB27Y1NQEG3VfAGBUZG/Nuh6b6ULC8+rOKDE4wNsHOWDznCJbbVMi8KCqA4xs1vK5dPZZ6vV/+UQn6RmSMn+gdLMGgLmRyti/fqNZ7hSoH/dLunHMaTunzQXWTkm09gQzrAIIuyCU/CuVA7aYSPXgIeelmjmsNmBILj960nt+Zi8sGHEpt40RXU0gz9z8rH7LnXXZA0cZGj2ITRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGuw0qKrR6NId16vPHAs4eDAPBIuuGDuK4dVXJGJvYg=;
 b=bx4s9f5zbC2RvaG1qzd4A2bvGTBQmq3pX2VtKyUK51wcRjndwGopNZZ1YrmEePFiI0BmOMlVgNnxcZkAWaG0Whvhs/PM/E9darTKIThLLv5Dx7ZPJPIkU2dniNeF6HhFRfWeRdsKn1zf5gzoKMd3n/nuiDlDjV3c7PlpxhD2Rq0=
Received: from CH2PR11CA0022.namprd11.prod.outlook.com (2603:10b6:610:54::32)
 by DM6PR12MB4073.namprd12.prod.outlook.com (2603:10b6:5:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.12; Wed, 22 Apr
 2026 03:27:12 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::5c) by CH2PR11CA0022.outlook.office365.com
 (2603:10b6:610:54::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 03:27:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Wed, 22 Apr 2026 03:27:12 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 21 Apr
 2026 22:27:07 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Apr
 2026 22:27:07 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Apr 2026 22:27:00 -0500
Message-ID: <bed91b49-4053-4d9a-a6cf-6d3a4654fbc3@amd.com>
Date: Wed, 22 Apr 2026 08:56:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
To: Gregory Price <gourry@gourry.net>, Donet Tom <donettom@linux.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
 <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
 <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB03.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|DM6PR12MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b26db1f-89f2-4445-86e5-08dea01f0af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+UezyyWpQpS35qRIlpli0zeahKh2dLfV62lpZeM1UhcEyCnL4KdYs9yBRIKb499ukkUMbbHs7CbfYNkFiU34NDhgs4I9hvPSREqL5AziwCF0aZOgIIfGnFGEYoEPhbj2JTjQ3DezMqbbg9nM65xy3eNFQqtyazyPM/EwykDMDjTBoNInguCWoZgGFOFJj9D5FWrkE4Rm62gotBNe9gEp1Dp94U0Gnkv7eodr8cuso3iMRWM6wO+PnLnXtV0MmdmVsnT2UsAOvMVCN6KzQpeYTfb4R2E3BUKtskyWU6/yQnrFXw9lyOjGUY7ZxigFLEH72OuTtbCSFb1FOfpNI4ukbik0pJuFbB5m9wwBA136Ki8H/7PWJmwgdoEWGEpMUTGG3wf/27Evxg54yKCUTEQoRATdctiF5zO3aq5VG3Kgkh182c8v/zYZQhn+0hTgIBpDRdO6CIKRhxyEYrGhbpFRlqwNo9qushxWEUwJA6j1tJHED5bySRNUOpCZFSeqlUKmFBHmRED7Z4N7dxqzLH+4w63ZIQm6R8il2mc8Tjge/pcAf/5uS2mA65VhA/8Agzu/3ZZxtlsmECxDfc9EIpfBtbMwMhR+pGG7Yyomg1YoSARFLB+wnZxMcMWQDK9jW5ySZ2Q+NlPf3oPQBKZHxY876xS5Fu2jJSBLLWHXTQtxww5fj4tfOkqUbag+2jll+AyeMN4nqHfubb+n146nEKVthN5t495Xcj+kvf41Kpa0B6S/OmFHdJ1gdLn1/p9PIQ30A95Myw1bTtGjCKyVP0Coqw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2j4o7E8RvJZLhr5nx11w3SEzSc9UQye6VhuUOy9XRedeML3QvLFYuXaxEpX7M5Hs4gfPNWVCi5anUpd4KFKxh1eIMpLWuY+LdLqKcQPlNXMA7O8S7Ki3T0m+J5sOgW717NXeTSTh4tQKC8R/7NMf6uMz8pxp5tFUZ4XBVPAHyrkphdN1/WtWh1ygmWgkzUGoWeFOBWuoHnotBuxcbCAF/gfnp5OQ+sXPOQGj24N01viTcMkFDwJmszg27cRTsiqi9Nr36Tb31O4Sg61tAeG6oniRQBOw3aCHZtuRorZVAekCVVQkWWj27pGvzNXRupTwkHIuoq9MArXcD4LQva1zWd0N/r06vWf2a0SykgNedIdK015G3NoWFNJPuvN2gXjjD/xcXApWRoJALYzh93o71FvI6Vfpz5zHu1WIDDp+UpyNj9B3J7QULIEgdGsII1b9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 03:27:12.0816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b26db1f-89f2-4445-86e5-08dea01f0af4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4073
X-Rspamd-Queue-Id: 790011A000D
X-Rspamd-Server: rspam12
X-Stat-Signature: yhnm4iio5b3rdf5m6phg8m3mhymyd6ug
X-Rspam-User: 
X-HE-Tag: 1776828438-45153
X-HE-Meta: U2FsdGVkX18AjV4t5n0V7w2fWH81Fb9HkcIuaYmu23JDamk/joS08qO7EXki4q5WQAqZmTbvxDRi36eP3JI/OtL6H2bBOdB/HC74obPg85/ZlzjI+XUs/Osiw7IM8TO9X8gRzEPpmloaSYF6KmvyHGXvlnYvrpOXpTNlgzIpC/sLOoBkDY41I05+1fTrZ4dGZbGSs7DwxRfg9BIaxlchd4uvCbu2mdRyIgacY3dyex/exDfhiV8z3Q4CzVQc0WHwXyNrQfjNz6q8Z3nEtaT4SdOV9GB4q+XA+N0Am6u5+fNZnVeIHpG/ZTPlrqgHg/Mxt3A/J/9ir2yZlVvAj9hH0pjUNQx6pnL0+Uno2TRGjXGgx65uEMTlYDj8xyKwQE0dJ/p2Gv6b7n6Tw9drjhFiuGcS6z2pDvnPexwjK6dpv6rPgqowiK6AEMO1o/XIgYgZyqXeg6w3e8QVTmv53Nst/AMDaA1ldkDN8POer5hFtNu0b466He0KYmQECYuXTrywIUZUXZJhoNf1dIBhysKBQfrgoBaRHtjbTED/tLzPj4oQjvxzhtOAZxmUjbwMc02rWoHYS5TKdHy+Rq6pCw9o4BcJArP+cJA8GpBWdrynI26o6JxibfaGH/EXynHebFZq8g9KNnqTVCViaPAiO6/OLR1dJUaamx4lHn3w9IW2fW4KQcnxAwPGgvg9kRua+TMKurjC+zxy6vwcmz5ObTbpLbeSWxqgyOQjpgKzclIOOy1oNYc2GQ04rgx6FqzwdKFmgsl+57NKOdMIeCwdXEnK0mVXnFOyCcC3qREWm9jPn8IWa1JGrOqJthJwY6CGffhVG8/4vn92JG22bafH/BFJAuxtsce88/TYCL7aXjChttx+Zn6QK7g7zKgDmFhomDnxKY/m191evLWGQFx7ZXJ/tNt7vQey6n5G6frkx1l3DNU8lvQjFyxTfsRCz6Y+O3HSCJ4eDZ+09hJov5eao1w
 UbLPC6EE
 LsljeOdmJudh6/4CNwuzlTNKgiKmigtT/rqEh1PuTZL1muZpclCeKOiLVWg5DTJpMh2G7a3ar9Wmv3kOlz4mIsO+VEMLoiPKNiJuD2v4mpB6W8K5fGIDOMBRocO0USxtreaz0FtdmCQta4JP9nIDHJ8TPXyQ+VwiPP1SHFKufQsNVw50gjxTmsGp6Bd/6UpSGMagheGDs4jrdTh9vV6a2MSQBaA9zaIu/Am9oSl/4fiHE4GzPYza7GxYLPygppEtVjlAS+I3pggk+bgbAl/lsneocBGdzx1sHEzc1bAcQuISVUHttEtuoNbuutQRU9Ui51mniZ36GeMMl4JX9FmMQNMxuQXd0PxiRcRmgFPuNkIIo0f1Tp6V7YabhOR97JC1ghIdGqLA985vsqLvP8Q8zvo3hLj9x7b+KbgTCqu04CLcNIOh3w4yL5DSBfs6dgd7IgCdxpmUrN1bW/ltsXnWHIRqUMT8oeK1rQ+Lglh6CK2BukJINhwBSLZsxwog/CdiNeWCzEQzPLBoC+n07GAwITKu4CqmQuWrhhDRiscl1Rg2XuQirK2am3yUhPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21-Apr-26 9:35 PM, Gregory Price wrote:
> On Tue, Apr 21, 2026 at 08:55:02PM +0530, Donet Tom wrote:
>>> +/**
>>> + * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
>>> + * Attempts to migrate a folio list to the specified destination.
>>> + * @folio_list: Isolated list of folios to be batch-migrated.
>>> + * @node: The NUMA node ID to where the folios should be migrated.
>>> + *
>>> + * Caller is expected to have isolated the folios by calling
>>> + * migrate_misplaced_folio_prepare(), which will result in an
>>> + * elevated reference count on the folio. All the isolated folios
>>> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
>>> + * stat can be attributed correctly to the memcg.

^ This is the expectation from the caller. pghot caller ensures this.
I could add a debug check in this routine to verify if that is indeed so.

>>> + *
>>> + * This function will un-isolate the folios, drop the elevated reference
>>> + * and remove them from the list before returning. This is called
>>> + * only for batched promotion of hot pages from lower tier nodes.
>>> + *
>>> + * Return: 0 on success and -EAGAIN on failure or partial migration.
>>> + *         On return, @folio_list will be empty regardless of success/failure.
>>> + */
>>> +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
>>> +{
>>> +	pg_data_t *pgdat = NODE_DATA(node);
>>> +	struct mem_cgroup *memcg = NULL;
>>> +	unsigned int nr_succeeded = 0;
>>> +	int nr_remaining;
>>> +
>>> +	if (!list_empty(folio_list)) {
>>>
>> We seem to proceed even when the list is empty. Should we instead return
>> early in that case?
>>
> 
> Well that seems utterly reasonable, yes you are right.

Right. Earlier migrate_pages() may have handled empty source list, but
with memcg-awareness in this routine, it is better to return right away.

> 
>>> +		struct folio *first = list_first_entry(folio_list, struct folio, lru);
>>> +		memcg = get_mem_cgroup_from_folio(first);
>>
>>
>> I had a small question—are we ensuring that a single list contains folios
>> from the same memcg?
>>
> 
> It has been a long while since i originally wrote this commit.
> 
> I believe I originally wrote this I used it in the context of
> folio_mark_accessed() driven promotions - trying to get some semblance
> of NUMA balancing for unmapped page cache pages.
> 
> These folios got put into a task workqueue that then got processed on
> the way out of the kernel.
> 
> I think I made the assumption at the time that the folios would all
> belong to the same memcg - I have since learned that this almost
> certainly is not the case.
> 
> That means a bulk migration may have to first process the folios into
> lists by memcg before migrating them.
> 
> So this commit likely needs to be redone.

See above.

Regards,
Bharata.

