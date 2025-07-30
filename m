Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49BFC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7666B008A; Wed, 30 Jul 2025 07:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268086B0092; Wed, 30 Jul 2025 07:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108526B0095; Wed, 30 Jul 2025 07:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0D296B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:30:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C360B1403E6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:30:52 +0000 (UTC)
X-FDA: 83720713944.09.2BFF8B6
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id D45C14000B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:30:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lCIkCuHE;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753875050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTX8ZrI9gJT35XGQw7AiSm4eYSyfE8KTGzzod4SnmyM=;
	b=udebs0cg2JXa42CG7bSvdR91lBMQ5xfj5cxQrcFV3/FrbcWrCziVD12uxFATcbfHnPnFaa
	pKcBjxDGpy4tAnj4iuF4cJK1wR52+py7OSRT9S8Vroe8uXVkGzHSoAm1hdu98XHC9pzmTb
	RAa41bTssyGw3s6uCPMX92gu1uHMyJk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753875050; a=rsa-sha256;
	cv=pass;
	b=1Vy9S9wCiZ5Wz/MTFHpl4O9HW11ZD6Z4eXgfco/pyEGOd1Y9/Z0fSK6dDw77XJIeuVLaGT
	jSr3PScG46fLFiHrqcOCs6fumLbXJH0CI4GzQkLl+qNMC6+DhMZS0FbhChDmgIMZkecFwR
	J+vUT8ilB8KiGZ6sDU+FbYKaX5MjPIQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lCIkCuHE;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WBvBL6OIU4Zt39NfETR5AIqM0a2ZvEgYg4KyuUBYkP+1tOt9YxfY7ZUIyXXgh9Osl1I4tc46VZt+kt6ts/jj6XOMUIyjDMGCOfaqCpAvnS3Rpjol4rWCDqOtnZIetzNSBWTyl4lWFOxD64Q/CMWAu0nWez5ZsG2Ipxb1x6M59GBPxa/K23hj2phfWLFikSWYDbSdxbTXFp13b7jo+kKJ8az6XyTS8vSjqA4/6qd1pIZkNLlJcIk9oBF8U7q63nZxCyOLaL0QQt4r3xThizbQRjflyYtLH8z35CV7sbqPlCzHuScWV4kkyMbdGA+4wcBfQGjuNAsO3dul8BetOOONJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTX8ZrI9gJT35XGQw7AiSm4eYSyfE8KTGzzod4SnmyM=;
 b=f14Cve0U4OCVUTOxntPKlSAFhHTnYrDP1XgEDbNbfGguhN7V/G8DH4UMfeDPHKcv1Fbz+mFXQdSLgs/ZArsZhdkbRUCVZPheIwm9dG4/VFmmQ2vR1koLPYNVDmbNzeEetyeIWJYjOLvAcK2c8MD4Zix7q2T0IMC5roiqCUOmYdGnM4UQGjqgy7LtqHf0cKzt9f58ZRaESUZ0FdV74jiymYJ0Hi6Uh7mrombatR0AbLUDyb224wxGlTGPDud0q6vzMXQVQ92x6pHWW9Zjyq5up09g9ZXeLGTsiM4NkA1Bp85oBxft2oLKlXTf3We5lFz352f4cLpHK+PebDuA0m1bdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTX8ZrI9gJT35XGQw7AiSm4eYSyfE8KTGzzod4SnmyM=;
 b=lCIkCuHEvsq/GRg/RCJ+LA4c+KSgX7tNvvMC+oNw4fiv0N+LodJR1tnZvbXvjLaVeywJ9HjXWY6uoniFOC1VKDIbIspqiY4RC6YHPyWjbjtYDpOSxNIAa4rFBiRAvvOhQZ9YjmE08HMvmnvVY8yTZudrVUvIOIviGourFTn64HEEgPud2LLJuaTrMN6Wxh0JdVUZvCTvMYKKYvoFnAywPxYeBBPRJISl0VFYmlZZfdLYWVf4gNO/2y6dPSxjiouU9mcufMHvZtoohNlfp38ZrMXKMVrwWn7+CnCyJO1DROw3n3+2eJXkGElRWcQEUmivXkzKFMVcHeDMIoJwUfOvhg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 11:30:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 11:30:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Wed, 30 Jul 2025 07:30:40 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
In-Reply-To: <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR01CA0028.prod.exchangelabs.com (2603:10b6:a02:80::41)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 94e83c93-37c2-446b-5990-08ddcf5c86f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXpZN21rWTl1eERtN2lEWWpmSG1xMkNVWm5ibXF0VXBjOVpYQmwzQU16OERW?=
 =?utf-8?B?R2s3emNLbFE3M0NZZHlmVEluUVJsUEozWUZFNGl1bytqTTZVWk4vR2s3cFl4?=
 =?utf-8?B?clpLRVRmaVZvdnExNU42dTJBQ2dsWlpMUHhtT2NwQWRpU0VJOUE4RlYyWG1j?=
 =?utf-8?B?Q1VJejFoSzZwdVNRSG9vY2k1enZtWVNCNXRON2NPbDNIVDJqbXFWWmM3NC9l?=
 =?utf-8?B?akJ6SnAzUThHaGllbExjU2l5RlhFUU5SMDB3VDJqQk1LNHlxdExxOS84VUla?=
 =?utf-8?B?WDk0eWR4RWgxWXhYa0pzNGRGZGVGdGY2bkhzbVdhREw1VllXTm5IRFRDdWtX?=
 =?utf-8?B?V2x1ODk1YXFoWmxidThtbTZnM2hMMmI0OTUyYS95bVZISEJpYVNzQytBNHlX?=
 =?utf-8?B?ZzBIZUV3VzRDdTd0OXhGWk1tOERnQ3FleUJQMldMeDVOUFN3ZThvZ3lsZFpl?=
 =?utf-8?B?MENvNU1zem4vejJ3dzAxMG9PR0pPdWw2bWcrYkNSSWtlSDV2azdFNytqL2JC?=
 =?utf-8?B?cXVTOGZYNFNheVZCYy9tL2VVVERiandZeHlhNGNTMVBPRzB6aHNpM2xOc1hW?=
 =?utf-8?B?TCtFWW1aOHlaR291UHBaZ1gvL2UzNUFkVk9PVTgrNmZNbGhOV0N5SXVJYVNK?=
 =?utf-8?B?WFFuOFg1YXNHK2N5eTdicXR2dWJ5aUtEY1IvMkRpN05WZUhkZERZUTRJUTFz?=
 =?utf-8?B?RldUekwwbVVvZVVaMHZYaGJXWFY2aWdpWUJKb2VqNW15QVV1Y1NQSzd1Y3Iy?=
 =?utf-8?B?Z3F0aS8vbGoxWWJINFljOHNIM09UK2psRmRUREdiL2hsWU94RmswaFZkNGw4?=
 =?utf-8?B?WnZ1MjNTQURGZDlCWHNWNzJhV05jZlZwK3JpRmZHMjRMdU1jN1NNT3VMbGhy?=
 =?utf-8?B?ckFqMnVQQUdrdjdaOXRuakplaVlpTkcrNkR1djZnWURZRVo2T2JqSzBmeVRS?=
 =?utf-8?B?b0huNFJTbktqTTN3RjJUdjVhenp5WmdoWGFoTEpCalFNTGJtRnJ0OGY1Mk0y?=
 =?utf-8?B?ZmdvQ20xWDMyeWNWazBIRlNTU3lZN3lPK1dWZkRIYWJNUWoxM3d3a1FCSW5N?=
 =?utf-8?B?dVZzVHIxaTJxWVFpWU1ZYjBKSjZNVlhZYzArcEF4TjQ0SVZ2bmtkUFp6T2Mr?=
 =?utf-8?B?ZXNMdEtyQXdZcW5nSTk3Ti9mdWYzMDFLYTZoTjBBM2c1UVdUczRQaDZibWNy?=
 =?utf-8?B?SjdiUnlrZkFRQ0pXaHk3T09vT0s5RTNseHZOQk5oRU9qQjBKd3YycXBlWklM?=
 =?utf-8?B?eWhlR05KL3NCQnFYcHdLbitKcEtwNzRtTkExYlJrcGpPem9PYWtrekxKQ3kr?=
 =?utf-8?B?WTdIaWhGZE5ZQVZjV2Iza3hNM1JoQnJPMzNwVmhNTjFjRkJITGRmRlRoZjRO?=
 =?utf-8?B?d1RMdm1pZUh6RmZwdjRqWUN6ZXVnZFpzQXRPaFlqU0hCVWZqdW1yajcwRUQ5?=
 =?utf-8?B?dG1ldUV2TkZERnRNNHZyQnJMNngwT3RhczNRajNjOU8zUnc1aGFlSXFwalRI?=
 =?utf-8?B?eGRrZEhid3BoZytsS1lPbk9BY1pZL09FZkJHUDFmL0FTSDh5eTB6cTlKTFpY?=
 =?utf-8?B?cXBBYU1CcDljM0RpR0JJbE9Xb2EzbWhwd3hldlhadVVyWjFHQmptaUdEQ05L?=
 =?utf-8?B?ckM0MFFVTllNKzVzWjNoaDBPR21IQmQrVnUxNlBpdndkUFBJVVpWMndPN1M3?=
 =?utf-8?B?Z2p2cDNKeUdlQkxzNmJWd2dONCtCY2RiRDRnWmNUOCt3TXlxWlhpRGMvTVRk?=
 =?utf-8?B?Z2tuOHZvZlQ1UFBMS0tocXVJbS9zcEtBQWlUbXp4K3lnZ2tmdFZja1JacnVE?=
 =?utf-8?B?RmliblAxSVRXWXBZL3FaRDJ5SFhIM3pYZE9GMTUzNm9QcnNFZFpaaUhJdWhu?=
 =?utf-8?B?OUp6VXdCNFlxUGNoenNNZ1ZqMnVQK3JQR1pEaHhMS1lsWFB2alZlVkxFdW45?=
 =?utf-8?Q?aU4EeOvaf+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3kybUZmMXM1UEhHSERqT1hqYzIranJ3Y2xlbHZaNXpyc2tubW4wTUo4Qkpa?=
 =?utf-8?B?N3FsTTQ5QzRyTWRDdlZFYUNvOWtOYjE0bjQrN3c2ME9pS2EyUUd0cDl0Z2NF?=
 =?utf-8?B?RDNBaWxMMlpidWViNWRoN2U0aHdVQm1PMEMzVkt2QWU4V2xSTmJyVE1Sc09Q?=
 =?utf-8?B?blYyU2FaUmdyNVorQjBSZU13K0NjUW9MZWhsT0pTUVhQbjRYSVE5ekNsME5J?=
 =?utf-8?B?Mlp2NERtd1RKODRDZU9zUWdJelFEVUFVMTEzRGRINWtPMnc3MUNOMUNqWHg2?=
 =?utf-8?B?NFF6ZGVpNHFvdURRWDNhSHU2UGEwVlNQcGdWQVQ2TWRzOGZSL3RhbnhKUlMx?=
 =?utf-8?B?TUJnYTFqTnJYdW9LcUxndWViNkNSZDdwczF4Y0FMR1JURU1YQXlzN3BDcmIz?=
 =?utf-8?B?QW5GZVlIdm82SUJYaVQvRnlBMDBONlhpeEdnQUpwY2xBOElPOStSaXFORWx2?=
 =?utf-8?B?bDhHRjlCZkVHakFweDQvY2x1c1o1aCtZc0U2NHNTbmFIVkVmNkpOdmsva0RG?=
 =?utf-8?B?R2MvQXJoUUZKSG5BUVZNQmhMUWo2L2dNenZlWnJDOGRwTEdUZE5yV0VGL29m?=
 =?utf-8?B?QWxsWExUU095TnhLbTFvZlIyZlE0UTNIbFUrdmZvK2cvaERIS1BRZnBDcWFl?=
 =?utf-8?B?c2VCT2xLMjU3V1lsd0tIdUM0UHFJM1dLV0NBZUxSU0QzaHJub2lROVBoS1I3?=
 =?utf-8?B?eFlrVUFReG5TN2hMMW41SjUzSlJTaHRkTjF1OWc2Z2R2RW5ycWhpYWxVc1Uy?=
 =?utf-8?B?dDdQQjI4OVBKcUx1SW93Yi85OG04aHVkeTNtQTRrRHh1YXkra1cyV2xTZFRs?=
 =?utf-8?B?eW9RWnhERGJ4VFNkZFUrUHBpalhkYmdiOUFiUWU3RUJpUk1RbUl3U1pWL3lJ?=
 =?utf-8?B?Z3V5dFgvTzRFNjN6emFidzRCZXFDT2Z2ams2ZWFUc3FqQTFVc3NWSC84TWVo?=
 =?utf-8?B?Y3ZRQzAwRFoyaUplTlVSTGIyWEdmdUsyUTNZQmxkdVorVWJXTWxjVklSUkpE?=
 =?utf-8?B?QnRXb3pLRU9VMlRXMFRjZ3RqRCtnanNjZmF1SHd0T05md0xFaG9ndVgzZ2NW?=
 =?utf-8?B?a1hQdVhNNG5XQTU1d1FHRWxUalRwelVkV3dNdDFuTG5uYm1pRGNVZ2pyM2Fn?=
 =?utf-8?B?YTFwbThDNll2MGZ4UGdMQ1NzeEVIcUZEaFlWeDlVZXp4NTI4RDBGMkRnaGlq?=
 =?utf-8?B?SE1OQ2tOUVBNMUNZKzZkWVc5dmNOanBYOHYrRVA1aFRvZWlkMGdNQnoya21s?=
 =?utf-8?B?TjhqQnZFcStkaWZJMTFFb0dBaVowTEw4aEk0VzRLczl1cTNzNG8xYXZBWmsx?=
 =?utf-8?B?T2toNDVaT3diaGE5WXIwOUVTb25zVGJnKyt4RlUrdVQwUlNWWXF4SkVoa0Ji?=
 =?utf-8?B?L0VrZ2UzTGRHOHQ1bkZYNm5XaytOaGlXNnBRdk40RWluWjBoWTFKMW9lQ3pP?=
 =?utf-8?B?RUMraFNwbWJwV2xOcDZVdHpGZCtaRzVVSzdFWVpjUFNROTlMbGZXMEVyMlFj?=
 =?utf-8?B?TzJPcFZEVDJzYkV6NnBrRjl3a0FSRHR1RllWS3FWOTRaL3BqNExxdW1sRlJj?=
 =?utf-8?B?dGZpdWRFMm9YcWI4TEV0Q3RWbTBoSDNjbmxEYlNXWHV1MmovZWRBSXByRFor?=
 =?utf-8?B?VGFXK2ErdW4yc3V5NVg2ZW02dEpLZ2ROeTJPTEJVYUcrWVlocElld091aGNP?=
 =?utf-8?B?dDlMRG9seE42R202Wm1iVXdzZk96NjdOSGNyWjBML25JZVJIcmdsK3UzUTFr?=
 =?utf-8?B?TW8rZDhpV3FGV08zemdFTmRCNnQwRExlUUU2Y3VLWUhFeGJUcTAvWGtScmtr?=
 =?utf-8?B?dEUzRVlYRDlZeDJmdzhNL1pmOHRwUkVNVDk2aWt0b2lzVVl1WXBzZ293NFF2?=
 =?utf-8?B?alA5QnlrNjZKNEtUWllodlB2ZU5YbXppV3ltRnpWYXU5Z080bjRzRW5ma1FM?=
 =?utf-8?B?SzlpTEtkUXY3QXJmOW4renR6RzQrMnVsQmxKTS9hdjFhclM1UHpvMzJNVkJ0?=
 =?utf-8?B?WkVwdlFHS0lwbCtsZUFCZ3p0YlZ4ZmxBdytDa3JGcnFlclVFek9WSjEybEtL?=
 =?utf-8?B?L3k5QlB4Zk45S3VBRjZLS00xcmtCZ3RnNTdMVTdJeFFFUzhiNWVUV2trSVRl?=
 =?utf-8?Q?ggG+WypH0qkai73ue3On4/PNV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e83c93-37c2-446b-5990-08ddcf5c86f5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 11:30:46.5781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qa8YBEgas5nalnFq11lFC2MeogHv71fzfBtNT1T29vTQLxhl0Cw33gQZTd5zyJjp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793
X-Rspamd-Queue-Id: D45C14000B
X-Stat-Signature: btakqsx41m1ym5nz9dpbcnrd5656naqs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753875049-428591
X-HE-Meta: U2FsdGVkX1912OEgxMM3qVziC6DjF0mR5f9v7wlblg5AkFrp7PejByeS93afRkhwzl5h+fWH8o07ZGvsHG2efaOPnff9Od9s+maJ2xAJW7pmksigGY/NPKOC0CezjsV41P15XpZzDIhP1GSl1b7bo3eDHQIcsKXG6QuvPPWE2xk3o67Gsh5cGzwoqjLIVIPxSv0pKyKO9rj3GEA/AE88lpAyEcFXr+7YOeX4QVO216gOIxVAVui2U2q361EJu/b+LjVU/oCBk+wsy7g5uHKj+abruIUvkHok6R/5dpCshysKTbZjbIVybN9GvXR5SCNFqfAhHGsWCjE6Bqar0wmVAxJdQoXir5Ju2f8TE8QjdRCHjldG/lN6Eud2Dbdj0Qs4C+vq2UxmtxMBoS2HS9l42EnzfeOTz+EhCsK+HT9/kWe3CtAFevnmd7RRpz3Bn1VR2fErejgJAhmeFjxDsWyrzLmKybSmP6EonH9t1KzOAex59FK0lfklk0m02QMjby0cp8URHivrFyc/+X+CcC1RZmkAQWpjh3k+iigq3NQlUsHreM/IoXCihyL9HrIN0y4IlU+na9jpKeAmfsxIazuNL705Np9YqA1f5sUV52B/DI67jcNu4wSQyr7Z/OgMAGLNFzkjqxsuophdy/RUHmuDJ9ohAJ208HBLDHmicxTB748ZSR3lkDG7bI6eTkXGdLjJdMymYIe7q/6eYlRRR/lF1g3EjwnA7DM9U2sv8AsgFebpc/CaRLElSfgdiBWORCPMevBjboR8Ssh/TDctuxtLoaTqtK6GkSO9U0sfT+aqwg0o9XzmK2KswAlKERK8pxVN56JqRzY7KEi/XRJBuxb1F9oH7Hy9ELB28wqXMTpdXK3+/Qv+ga5rcEPrFvnP6/LUY5fCtC7hO0f5UzC6OK/VIOR5X1ZzawWx8e/d9rka36/g7NlQqoRu5fazCXMFy7VXreqkAMP9V30vpYCUny5
 JiUog183
 PVCgPpwFfsRji/PqITSFU5ujOLjdoH426vLjyTEFB8w8ZmYk/VTNUAMxm52yjEm/4Maf8peFokL6RUFH7Lnb9bIoirhni4V8jcPDMyCnuKoQCXC1GKn92WX/Mp9tkDphAkmdA/+K94q/faCrsrfQLu9qf1mvx1sEQwya4f45SQOffiBYJ3p2jRIQY9RpViqOo1C6uzFT+BQq1mxzC9ySIz6xigV+UxTDW6ulLwVCNyhYB5cyxGVJWI0n3x9+kc1rAWHXKS2nZmkN1zwJb3UW1okrWa7oHkUN61qtA8369jUhC1iQB67gI/Y2SgP+1PuMGPZA1mASaLg0BomUn77auT9SfpyYaF+36f11Qu2hx2L5ToN8LvGPTAhhE32Y11WGeFeBYfovrVIP4oAkASYSmP62nF0lRvM09/N3XB1o+b6mKflC53XmBZQKiy+BLlXJFIHrNNkfzJbnLSREquixcq3Fsbl3F8aYOmf/LgG8zKV1il+TE95mIFp3VzkMy5oXfXOWv0RXD474Lp1bZkUe8j6RZf/BC5UDwiRb9AN849IAdThyzuGTNJl81xEjYWYOsudmn8SdN0BYPc5K7mprNbkeRk2RizYKGcsMZbjYAdwC9tVTCBX9IiC6CDnUxwZnSL/uL2NQvgiz7rkSH7u2cfFBpe7Dx5H3KrTxTA0XtlFJ/YQa40QhwafNQZeh4djn0M9tR3AtLwmaviPt1/sO7waiy7ehAdYQDndQL+nd91b6VX/a1+o5nG9DyOLUWc89PzgdF6QLXDyUOMwxJjX9jRePpu5WWMKq1517dbpIy7XnXBvH1/g91LrswYjxfmDNqZo9yXeWFvw7yGnyTw9RGaHWShg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 2025, at 7:27, Zi Yan wrote:

> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>
>> Hi,
>>
>> On 7/30/25 12:21, Balbir Singh wrote:
>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>> device pages. Although the code is designed to be generic when it comes
>>> to handling splitting of pages, the code is designed to work for THP
>>> page sizes corresponding to HPAGE_PMD_NR.
>>>
>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>> entry is present, enabling try_to_migrate() and other code migration
>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>> return true for zone device private large folios only when
>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that ar=
e
>>> not zone device private pages from having to add awareness. The key
>>> callback that needs this flag is try_to_migrate_one(). The other
>>> callbacks page idle, damon use it for setting young/dirty bits, which i=
s
>>> not significant when it comes to pmd level bit harvesting.
>>>
>>> pmd_pfn() does not work well with zone device entries, use
>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>> entries.
>>>
>>> Zone device private entries when split via munmap go through pmd split,
>>> but need to go through a folio split, deferred split does not work if a
>>> fault is encountered because fault handling involves migration entries
>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>> same there. This introduces the need to split the folio while handling
>>> the pmd split. Because the folio is still mapped, but calling
>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>> code is used with a new helper to wrap the code
>>> split_device_private_folio(), which skips the checks around
>>> folio->mapping, swapcache and the need to go through unmap and remap
>>> folio.
>>>
>>> Cc: Karol Herbst <kherbst@redhat.com>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>> Cc: Shuah Khan <shuah@kernel.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Cc: Jane Chu <jane.chu@oracle.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>
>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>  include/linux/huge_mm.h |   1 +
>>>  include/linux/rmap.h    |   2 +
>>>  include/linux/swapops.h |  17 +++
>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>  mm/page_vma_mapped.c    |  13 +-
>>>  mm/pgtable-generic.c    |   6 +
>>>  mm/rmap.c               |  22 +++-
>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>
>
> <snip>
>
>>> +/**
>>> + * split_huge_device_private_folio - split a huge device private folio=
 into
>>> + * smaller pages (of order 0), currently used by migrate_device logic =
to
>>> + * split folios for pages that are partially mapped
>>> + *
>>> + * @folio: the folio to split
>>> + *
>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>> + */
>>> +int split_device_private_folio(struct folio *folio)
>>> +{
>>> +	struct folio *end_folio =3D folio_next(folio);
>>> +	struct folio *new_folio;
>>> +	int ret =3D 0;
>>> +
>>> +	/*
>>> +	 * Split the folio now. In the case of device
>>> +	 * private pages, this path is executed when
>>> +	 * the pmd is split and since freeze is not true
>>> +	 * it is likely the folio will be deferred_split.
>>> +	 *
>>> +	 * With device private pages, deferred splits of
>>> +	 * folios should be handled here to prevent partial
>>> +	 * unmaps from causing issues later on in migration
>>> +	 * and fault handling flows.
>>> +	 */
>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>
>> Why can't this freeze fail? The folio is still mapped afaics, why can't =
there be other references in addition to the caller?
>
> Based on my off-list conversation with Balbir, the folio is unmapped in
> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
> device side mapping.

Maybe we should make it aware of device private mapping? So that the
process mirrors CPU side folio split: 1) unmap device private mapping,
2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
5) remap device private mapping.

>
>>
>>> +	ret =3D __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, tr=
ue);
>>
>> Confusing to=C2=A0 __split_unmapped_folio() if folio is mapped...
>
> From driver point of view, __split_unmapped_folio() probably should be re=
named
> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
> folio meta data for split.
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

