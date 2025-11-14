Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13BECD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6DE8E0006; Thu, 13 Nov 2025 20:22:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EE48E0002; Thu, 13 Nov 2025 20:22:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D768E0006; Thu, 13 Nov 2025 20:22:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 256198E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:22:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C11D1139F7C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:08 +0000 (UTC)
X-FDA: 84107461536.09.A1A78D6
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010018.outbound.protection.outlook.com [52.101.46.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0BFC340010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tTgtr6+I;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G5owos5I+wACJ1YlVyjw+BLjd2AJqWIJKoU6yz3rCXE=;
	b=fbJG5R7cxdRARPwlJNiS2Pp+8wCGW6MRWGECseN2x3ogSHOEIjgobdXSnFZd6vmrJ2z6rL
	MnVjFvhfDoUH+1rkArzvpFC/rcqmU4+cFYPC2BfhBt/XD+/o9H1jJ5VnKLDRa788OCfLh0
	/caT6ESH97j0tE+hP+LYDNsJLKO5hnI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tTgtr6+I;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083326; a=rsa-sha256;
	cv=pass;
	b=m1r9CMRW6B2fSs3oT9ci1uH/co21Hu65+WiLm+3UfzbmQdJ2qGNXLKz53036Am0aRhk7OC
	sVrbeIO5Gop+m0uwV4Or1M0Svey0bkIApZPlELyO8zeyD1tTTPXy5AcZJjh3vYRvtd73Be
	3mkzFESFN3TncBdISG2OXz6J/gOSuMk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XObLvcJwzH0S6iDJzlrwENMSTvx+xegm548FQ94f8AyznWJbqewi9McYUZsicYw3IizrGJb+PHW++N6rTs6WSNgft4zuuODzjQ2WeLBeTaq8H4NoY4Res1keMjBXvmF/fOOOv1JLJkWCyn66IXx6wHp26QtcKzlf8pHCs6g1ci9Q3bTqxRdhq/oCaCbyVWwA145rMB84ZZuAxI380sBTKp57t8aqVsX0uNHYXduszWhkNJ9ItgYzNfu36S5V8zHUtyxLYCl0txLxq9K21QybrLiLq+pM90co5ZwRROev6k8mtpqCPcV/DFeA4j5GMpSI5YCtOBntTcNOUO7LoLxDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5owos5I+wACJ1YlVyjw+BLjd2AJqWIJKoU6yz3rCXE=;
 b=TD4KSTo35uDpV3ec784bmdYofFPioMOTdZ0eq1w44+qw6XSLsRLj0HtMzuUim0VdV4hmyTUG+89IZUkYHdkznBg+B95+6vLfKjYZeNRs5vNwhL+RVF0AoLBYoTGDh84T78sfTns/mUo9m4eU9CrohZRh88IzA4eDpjYa5E8U9eP5jsV/ezitvefAhcVRmrrOgKs38mP+xnJVsrDzPWV3Z9VEL42j2QjB9cPJ9uKO17mYSnTxFkUiCjk82ixLt1XjTrCuSE9Tsn51cdid1DDHOqZq1Fx316bN0b5CKEYvc0V80KCrgAhJfFbihQH1YmkaA/RtZQpuldMXv2pQUgm3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5owos5I+wACJ1YlVyjw+BLjd2AJqWIJKoU6yz3rCXE=;
 b=tTgtr6+IFkdlKYCi0Jgrjz8onhVFORO5uZTbA6fcWVOX8nOkqs9dDCfBG+kJZ/+uW5BlbBkZrRWi1Zi2w06YKegwoKKiPlm4m/+5guWvTLaPt8keartcAlarCOOshRzsDP3BTEHO/+SUm5Vi9sY5qouIX4bAmNBmN94VjIGzc5PVqscXgMIb4xMjQ2EcV7vq0T9UBgkXr+pmsqgpoJsTrxBGkOhibkfMFH7Ylx92wMEFTo7QTjBrU/Nk4yH70/xDKETSLo7NZkxwBzAK052z4OJH/j14IynSmTkqq3MZzQxj6pokdPPqRAn3P7pYzDkVN/Gx79fupE+JD/6Q+XOBnw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:22:00 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:22:00 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH] mm: fix up softleaf vs thp device-private in remove_migration_pmd()
Date: Fri, 14 Nov 2025 12:21:52 +1100
Message-ID: <20251114012153.2634497-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY8PR01CA0016.ausprd01.prod.outlook.com
 (2603:10c6:10:29c::8) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 8644846e-fc6b-4601-4450-08de231c35a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VklpWFowcC9ycVc3ZWZNbitRZ1Z4RHBtc091dndBYWFjSStCU3NDZHVHdnp1?=
 =?utf-8?B?OFV1ZlZSYXh4VDAxRENFUHBOWHM2RlcwamI5eUJHdGNTZDNaVmJCY3QrU3l2?=
 =?utf-8?B?NTk1a05wQytBa25TeDF5TXpnd3hzaEUzNjloRXVvVWJjdDQrQlZwUitsT1Z2?=
 =?utf-8?B?K0pMbEh5TGIyVmxlc0FSbUVCVFhpS3pCUnZ3SHRvZElFRW41VVFJakVsR1BP?=
 =?utf-8?B?TzhtNkpXbW10VVNqWTRmR2hneEUwK2RZZG94TE5nakpQUmZiemhqV2Rha3h2?=
 =?utf-8?B?WWpsZEluTzBzVHRXaVg0KzQvSmo3VzZCL2MrQjJGRkdHVmJaNS9hNjY5L2xO?=
 =?utf-8?B?dEljajdST2FPUjZZU1JXV1hYekdkNDk3SGY1b1NmaHJhZ0RDc25qRXpJVE9E?=
 =?utf-8?B?Ly9TQ2JqMWtzUCtJSUVqWXozclk4RHlZUFplZnRzZFJteHJSeE5LMWJjZm9u?=
 =?utf-8?B?c3dpNHhSOTBpZldFa1ZSZERsV01lTXk3Wld2M2NsVzZVdGRsclAyNXJ4cnRr?=
 =?utf-8?B?a2NLdnFUdUdPZmVBYmc0eDJhUUR6SDRIZ24zREtYaEFaY0cvYytUVnVaQ1hu?=
 =?utf-8?B?TVA4Z05WYm95NDBLZytXRmQxUjk5R0xNQkpKZ1BwUy92MGQ1bThkclhwZmVF?=
 =?utf-8?B?ZnlDM1U4NCtiQ29qeWJzNFpZTFMxc3lmQlBTdDJVdG1SUXFHV09HdGYyZnhn?=
 =?utf-8?B?RUJORFordjdZWjgzQVBIaVlSak1HMzlJcXM0R0Q2Y1RyMkhXdVVEUDlhOFRt?=
 =?utf-8?B?TWZFa3dLbVJ6ZU1pUUpTejhzZlZhS2RRbUxyREpJTjRJTW41THpCZUpvSURk?=
 =?utf-8?B?dHE3bklIUW5JR2I3SDVPb0xURjdjK3hRZHYzYUcvZllJOEI5ZVQ3Rk1ZTm5v?=
 =?utf-8?B?bURMaEVMM2MxNWV3bVdYSkI5QzIweWt0bU1CbjFza2E4YWpSVjU5US9qb1JQ?=
 =?utf-8?B?SFVqR3ZKZHJNS1hkUFBib20yQTMvN0QwVmNFYUJhRGl0bWd0eGVCYUxGR1dF?=
 =?utf-8?B?N3ZsRDhKc1F3RnpDUlVJc05MZHJZSFpMK0txMkMyeFdTR0lqMGZUczZYTzNI?=
 =?utf-8?B?OVRybkFRQjVOMVhueHg4cGxDVXl1N0tpeFVGNmdqdkp2SEdNcitqSzZiaEk1?=
 =?utf-8?B?K3BzODFMaGlhQmg5TklWYXFSc2RQcDZqOEN1d3RQRU9NSlVsYVVNNmpPK2Rq?=
 =?utf-8?B?NUhJZm5PMlo0emhydTVQS3p5MHNOY1VnbjZnei9YYks1aDRJN0oxZllkbWxC?=
 =?utf-8?B?aFJzNDR2akFHWWVyM3VjWWRwRkxlRHJ3VFFNRTZwNU9pR254VzRjeGJxckY4?=
 =?utf-8?B?MFpYdmNaMnpjaFBrZ3Fkd25PTm1MazEwK1U2d3JWOVlYSFR3UjlEYUI4Ni96?=
 =?utf-8?B?UzUvVnhqUGxKbm5XZFdHd0JWL2JTZ1dFRkxjMXI1VVVqZkRxTG92S3QvaFFR?=
 =?utf-8?B?ZE9hS0lwUGVNZkFTalRhKzBBditjeGd5dGFmcWxVaFh0blpMdzRVVEFjTlRj?=
 =?utf-8?B?cGluUHRMeDM0bTJibVJNQXpORy95OUxlQzhyS3pjRDRhem5QM3BzbHJoQysx?=
 =?utf-8?B?OUZ1ZGVJbklram1xZzZOZ2I3NS9mNVNudnJVMkxMZGl2ekpOdUhDMVdNaC9y?=
 =?utf-8?B?SjhrVDNTUHY0YUdSVklTeDJzVkVzU1BpdllHOUE5MDJPdEpmdFNoMFFwMG9l?=
 =?utf-8?B?WVFPL1lUTjhmeURKL2Q0MWZzeklmUEtRMXNNckIvRTZ3cHdVVXBRdjVHSnYv?=
 =?utf-8?B?N3JweHJqdEh6a3gzclljOUxSdW84WkZiR2grUnFZcmV0emdZcGRuRVJyc0hL?=
 =?utf-8?B?VFZvOHZZMHFqdDlIU1pTNkxDOE5qRTVFZDU2TG41SjcvOGdlL3gycXUyTG5o?=
 =?utf-8?B?bEVpSDVzcTNYUk9EaXY5cWRmdS8zT0RLNmU3SWYwZENyajQ1S0tyd0MrV3dE?=
 =?utf-8?Q?+1p2kKEIB2K4Mnhn0TpIFO0cYz6pf+g/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXQvVVZMdE9EbDBwOHY3blhvK21DNVdWcjUvb1hXTHFzUDN2YzFCREcvNU8x?=
 =?utf-8?B?alJoaDNuSmJROFI4M2pyK1lHWjJidTAwOUoyQUpUaVk2RXBtdnQ1MHlxSGdz?=
 =?utf-8?B?a0pzN2VIa3dWSzJsY2NMaGthcmQvaU1Qd3ArSlNUY1ducmJqZmpZMWNvV3JV?=
 =?utf-8?B?MTNocVhNY3JMUGF6czZLVk5BdFNBYTFwbDBUczlaRVIrVmlPVzBQdWRSekdX?=
 =?utf-8?B?NWw3T3FxSzdKcXRYY210TDc2cE4ydUVSTk9GcVczTk81N0hMNXdaekcyRkY2?=
 =?utf-8?B?dG9UcVBHaEliTW1jRElHc3FRN0xORFhpYVB4SHRuVzJCN05ObG85MUtVcUNS?=
 =?utf-8?B?VkFGVGhmbmJtcWgzRUNJZWhkblJ2SGtsNEJ1RUJIdXJuZWNrdlJsTExlTWw3?=
 =?utf-8?B?Q0FRUEk3N1JSajV2TkR3cUhNeUt2dEdFTE1pdC9OQSttZkhKWXJDemJaSjF6?=
 =?utf-8?B?cDhpNTRmOGpYUTVmZzczTDJrNHNrMlcxQUowdE53ZWJFWHhyRWtNaVBkcUVG?=
 =?utf-8?B?Q3FWUDhiU1hyc2pZWGFoTmU2cE01cm93M0lLZUxnQ2c4NDBZaUExY1UxMmd5?=
 =?utf-8?B?K21adkY3MWE5UmFLU0RPMjZnY1VMK0dmSnNZWC9iNU8xU2hUZjhnaEc1S3p0?=
 =?utf-8?B?MXZMUldPQ25ZRnozZmEzUFdNQjBEV0JTMUVQdGhCcTcrY0F1REtVbnlGODcx?=
 =?utf-8?B?d08rTUNBQ3FiMHFNMXZlMysxelFGRHFQTGVzQThOUXhDSzJ1Tzg4S3ozR0lZ?=
 =?utf-8?B?ZFl2Qm5TNWN5M1NvOHFmNjYzRkNXTTl3NUlvTzFHdjcvd2RsUmZKak9LcExx?=
 =?utf-8?B?ZU1LZnZWT1FoMDFFZEg4WVZFeUwxd0x1ekFiQVNvV1QzRVRnU3F6MWExZHRs?=
 =?utf-8?B?c29rSmQzZzFqNmdDeXhWSUc0K0JxSTVFbVVES3Y0MHhBeDNjcWN5YkZxekRw?=
 =?utf-8?B?SWp5UnJvT1lSL2JKY0dHYmdMN1FqN0tWY0hKTERsL050d3hRVXowVnJCSVFG?=
 =?utf-8?B?cXMxQUtXWnI5TjZjbUtScmdXSVgzaTQ3TjBqSExEcWVjUUcrQXpnYVppMVNJ?=
 =?utf-8?B?aGJSeVc2MFpUazlCaUNQTjFYQ3ltV3Z2dmtmZ09nczdVYnBCMElwTDIwdjFH?=
 =?utf-8?B?SXhnNU1WZXJtMGZTN0pRb0NWZGNaQ2l0MVBIUXRzdGxyS2JkbHNocDVzTlVr?=
 =?utf-8?B?WEZzRG5reXE2MVhTdlF3bWNIaFRnVHRRWE1jRklRWERwZTVvM0FxSzdObnpi?=
 =?utf-8?B?aUlkdzEwa3BCY2JkbTA2OFFGZW5wWld6bklCQkQybHdsRTFMTXp6aks4cUlT?=
 =?utf-8?B?TXRSZXZSUUJqZ3d5b080SEdtVllGYUZ5U1dYUEZlRHJtM1B0dlRuYUdQb25p?=
 =?utf-8?B?bnIwOFNrcUFlMmJKSGZ2WSs3MVdNZURSVGdrOXlma3dRcGpWNXB0NENFOUI2?=
 =?utf-8?B?WnAzMkRNVDdDK0pEejU3RzdUUmhsbStOTG94eGUwTHExYXhjQU1weWF1Uy9w?=
 =?utf-8?B?V3lDMHY2c3lUUTA4SGhaa05NVGx6Q3MrLzVoMWY1VUZvaitMNThBdlA2M1hp?=
 =?utf-8?B?ZTdUeE5tc090VDJlVWsyUGRPSFc5ZmhTSjNpUUg1TTZGQ3RMcVliNTVRaURa?=
 =?utf-8?B?cDZPeWRWbGtRNlE4RDBYMG12cnF3TzYwSlBjZld5a2V3Y01qYkFvd2pMZC9U?=
 =?utf-8?B?cnZ6Tlc5amhuYlpmOEpDNjJTeFdwbjZNZTFLTVhCZFplcldkeGhudDNjN2RP?=
 =?utf-8?B?WnNWRTBpRDBENGFoQjdyZXpLSnpaUlRJTFo5TXVEeDc2TUc4V2dFUDJhTVdt?=
 =?utf-8?B?SWx4N29ZOWduSzVXOHhoSFRJdUpoU0pLeUMydWF1Y0Z2RTVoTkNpR1MrNWkv?=
 =?utf-8?B?NkNiWnliSTJHeHMzS1ZGM3c5QXBoYXAxVGtra0pSeE5ZS2lxeUowRjAwVkhC?=
 =?utf-8?B?N2JoV2lSMzZocDFKbnpFR0FUWDlIb3pncTJrTzhPcWtqQmwrZ1YzTXNrU0F2?=
 =?utf-8?B?Y2lxYW56VGx6czdRenJReGFOSGltVDdWVmFpcXdGQlhSUFFkOWpOeGlXMlc5?=
 =?utf-8?B?S2F1c2FLOGFPSjBMVVhzb0JpemNxZE5YdHNhOFQzaXFDSjdhL04xa0ZTc3Z4?=
 =?utf-8?B?WTZGVkZNOGFFcFlxa1V0bnRMdnFEc2R0SWplNUIxWlY1dmZidjFNTlgrQ1RY?=
 =?utf-8?B?Wmc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8644846e-fc6b-4601-4450-08de231c35a4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:22:00.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MiWuPRhul9sBx1eJS0KitvDPoIiNOM4OWHFc+fMz67cqaJUIQeMlMOvkryws7fxUBfAHSnVvI2pNq6BYOjQ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BFC340010
X-Stat-Signature: tjuznakqsm18gzxczdxnzfp3px9gai1u
X-Rspam-User: 
X-HE-Tag: 1763083325-61412
X-HE-Meta: U2FsdGVkX1+cfwELi2bqZWEQUwHLQRKlezhQ5l/m85E2kb5WJEUUG0oQ9L8E78qkjn65Kz6lSD97Gjh5Mqq9ux0JwBPi9SxsQODLqwspfgulgRVSq0D3R7YYXw4n2Nh4SEaQcG9p4MiwMotprMxCrrjkL8YHLaqNs1h2XjS1qaO9Xkz3kceEyNhyDmiRSAIHrcEMOxsXMJkY1J2uzUSYZkCUxwsDDbRJ/XG4mJDWO5iq8MRMqWRwAwf8ZDeqjSP9XwFZPlTEc6jU7bO3MFgj9uHzhmfspHAiTdKMU4DSZaePUwlOjKpboX6nJAUwWxeM0gefVbigqmsY6SdUKBCztI7MaoHCKUVMHj5cCeYxL56w/ZkjSrr1uonfmhKemPazFdHdTu8oxDDCKV/C9fz+krvo7LYdwHZSa6CafaJK4hs/CNMsN44S+hbtjKa4G5gGfa2D3ioFYxChlJUaeLstPzGtetKoQ1ShjX44HtdkEKiUoq6TXUMiQeqw97SJ5Wb6Xx/FSGdHUG5jfX0+wj1PqMtW+qP+sDNXLOFrLuyReXqzG/czfwU1IaPCws+MGOKNJEdWzrtLljEL9jW+4G5aR0pfkAGw+sI35fPAysyI70131c6slUScsHvFudfE2Twfj9A1AkKkMpSzkP1zgU4x0abP0SCwjcV8gmevzu+LBIrxTt7je4tJxKxlWznfNcx/u5aW+pJTItLEa2HefCHOYzAowVBFbMq8dwBtu0cZ/l47UAMWiLMbje7b4K5bCL+IzjEhIvNIyzQ8nBsza/U5Z6jRFIKsk7EPERDiWaalE25YG7GtOR9AqOrXGIu5Cu/mtgCx/asU+uLRYdYLsPKN5e8OUh6sYy4bCaJBDSYCh7sG479EgHPHf518n23taf0zZ2X557jB506UnTAG9C/DBOVZYSqB1wM38u3Wq5EgYnP91NA57hLjLVpaIKVkEaSooDuzUsjeynRKlurHHU4
 oIvIR6Vd
 Q+QrLJ9EZK99MpuypzfDWLFAKe8pKNOVUh2JC7GtIezeLrtGFXHB7vcxQAtCCP7EGDkiBrSng5Nlq6NdMgkLwkncVFXrAwFlx+9bUUeCBxm+zRxORMLxpyKgDtFMrv6CnIefTEdZw2SspzlXhR/aNMSSPQCZrtDmLEI3oI8R/Z35q9Vm4HlmN/meP+/AG5ebAUhXz4rl+av84yCiOOKoAqjrBxBtxacg0003gRjk5RwROwAvxAK9dgPdkKSPwlRtVbbHtbX62rSL13DVizoQMNYdTbCIic6uQUQCz2usalm3r5WfCY8usyY4M8kAa/fTtJ9EEb67bcv9hWK7nVfqeSA6KAbTmTBV95VFIbtvuW8JODrHWGHXW0WvIkza5KzRXFheFJaXZ2e8DwmVSTfODx3WA44g4fltwQYHSC/08ggVYlhqMCO5nNXAby6xIIGgWNlWRW4cg0zJn0hJOc1+X0IzEivoHkZNuz1KRbKB7/m2Kxqgj9m6zWRAcWvJMENK+DIuCFb7wtfvYZ64B7gbhev8Y7ZHWvtDleL1q0sStFUtkUeDs0MlZ3aPoHYEtaCeTpLy/CTeNvNen1DuIc2xigSM0WJ+PYv+Rlr1KJ/nu71iMqg4163AisjE7j55hjATz56uxtomQgkH2iQQnz/+3JEG2CMDRlkXueIj5IT3SVEsxYIfusWBQnezoaaRG2EF5OG+0oSmDPRQycluAf89cTytx0E/YA4CDaNLvwb6A3DDhihwHcCHaitG42iDFDye4XKDNIOar/36PzeCMBTIe4c1fMhh6xxRce7m6jhlIQeYYwadme3AXONK7xcW4QCkdm7fotkQ+nrHoFkbuObfREgdKpObyLD+BIFU6Hgt/O6UlmUXpHSouk8t1LU3QR1Sz2JAJM8DTPP8TTHHeblOQYnV9h8TRcpXpXBjK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fix-up in the thp device-private patch
mm/rmap: extend rmap and migration support device-private entries
introduces conflicts with the softleaf series, this is a fix up patch
to resolve the issue

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/huge_memory.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3a8f0c4143c5..4d65c51bc0fe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4760,7 +4760,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 
-	if (is_writable_migration_entry(entry))
+	if (softleaf_is_migration_write(entry))
 		pmde = pmd_mkwrite(pmde, vma);
 
 	if (folio_is_device_private(folio)) {
@@ -4777,8 +4777,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (softleaf_is_migration_write(entry))
-		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
 	if (!softleaf_is_migration_young(entry))
-- 
2.51.1


