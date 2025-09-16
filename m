Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61900CAC59E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13678E001F; Tue, 16 Sep 2025 08:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA9E8E0001; Tue, 16 Sep 2025 08:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3C68E001F; Tue, 16 Sep 2025 08:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB278E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:25:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5909FC016B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:25 +0000 (UTC)
X-FDA: 83895033810.11.F12D036
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012007.outbound.protection.outlook.com [52.101.53.7])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62A6620010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y1I3YanZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.7 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AL5+HBTPmD3/BshzkpGfYIJ6J5/ADcYuwBSQYWymD38=;
	b=QeoclnkPTOKryzAtf70Nvc643F++iGNDduEQYSw8oaxsGGLqPAqEBOTamR39WKTg+d5LcG
	a506vyNSLwJ/fwPXTHDBaL1ehg74HEC3P+qN8X0HHGAc9nutlgQu4R23v5vQtKgn8Zm3dd
	R82jWKTB+9ih83tzZQivgSziuyP6G2Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025522; a=rsa-sha256;
	cv=pass;
	b=NTz4Q2PNxFVTN+xG5smfBDbQ6Pt+mbrH9xI3AV4MSwFxFlj7v+7c7qWtqI3DSAseQ6JdSe
	YLSb/UF5GcakRw15LO/bZPx+cbPj+GG9g24KXZFRhL/LUOZ6MUGW18/FjwinsvbUaO1dgO
	uP6JIBY3jmkLM8LwZWtIaWzqg2nVXqs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y1I3YanZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.7 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3Sdqlv5VWM3j1TnSPJ1k+qo1Yr80hOsIHMJyOPNiL8guuKUIPwbftASZ5xIZj4Q3UM5f6Q3iSs9mp2A5gOa1LZy8t4JPIBxwYMklfhwcjWVeEEifnDDaFimVQNIfluNSqs7nQ+tK+tnEYnXCiU9pWCGhj2wjRZ54FF9IlAMq6WjOnKZ6hvrwH8/qeGSdH0qO3QMACX7E3aY70qFHoKLRyj1xBpAi59uOAWhqtnQxrSQNFLoruzVnZtY+2H1/pvxZ1MEb4QpfK/je6DmSEPKAIryjXuQmpRF7K+F0uj8BdsO+EErLfN8u5J+Iw65UiI6Lwd+3VIOohGorcFB7xyKlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AL5+HBTPmD3/BshzkpGfYIJ6J5/ADcYuwBSQYWymD38=;
 b=cVW4ja1aJlZB3Qar+5WbOaYlT1UHej6Hur9Sruuqbu/BwaL0MRVy5Zoip3azqXodIposKPE+lmdvNhNO0yTnPGy6p4APLL9CJgJKg/7tV3Yk/EQwVEuzyKTZtz2foXJ0X2iIO2cnzu24EpespPc9b2K7QPPLCSfHgwEOk+UbeofWOxNPU2uDuCRdN9Exp0cnjylLMIs+W+nKyTn8comA0KRVSZSND/Ofn/Uxl2kyjc/S6w5djscoWYiml1VEXquNIUy+V007v8+QsraHt8DDohc+ynv+t2hCGJthYdbeNp963t9jFNIm5IUpAIPJ1G6RX5Fp8lAFH0xFOJ3A9DCjiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL5+HBTPmD3/BshzkpGfYIJ6J5/ADcYuwBSQYWymD38=;
 b=Y1I3YanZ5VVbVda6Nlk/N9QuxZcW50kEYUSeIXq8lCoLmYsooseYT/HSEtj/ZOPLFTHlMXOecZdd28SOO3dNlrGuPyncvMcWY8qO/21vNVoRr90zFOobyLkP7U34Sl08ivsGLaFDp9B6zmgofFQcYqawbb86nbIt9jr3FLAipy4Ca3Q5naiuuylr9xo515QLjG4qHEX3C+Z1i6msvEN3BpuvLrLl+fQNPjp4ebGWYSrgbghkF8TUfFUTrft2EYh4WGBp36mw7wCzZXjJwrH27UY/8cenEjcSK7P6YCLHYo9uurAH425TYeiDZqYdrqK4GSk94utKVHEzx8Wspf0SLw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:22:12 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:22:11 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v6 10/15] mm/migrate_device: add THP splitting during migration
Date: Tue, 16 Sep 2025 22:21:23 +1000
Message-ID: <20250916122128.2098535-11-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY0PR01CA0004.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::11) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f80512-37f0-4df0-f512-08ddf51ba9a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUxpN21uL3hmRnBzSk5UQ01ETUd5ZEF6QkVQbDlQYkFQR3h0bm1xRkIyeTZh?=
 =?utf-8?B?ZWJCZXgzMHhnR1FrQXJKY3R1aFU3ekZ2K3hXQTU0T3ZveFhIVUJlNmFjL1ly?=
 =?utf-8?B?WUswMHdiQVlHTmc5WUp0U1c0VkJPVEl4UDUrcU83bmFzNHI3WnQxN0M3MGx2?=
 =?utf-8?B?a2dQM0FaazUzVWNoMG1CeDFBZ0JaTG1ZZEd3REJ5WGtxL3hGRVBUUk8rSTlk?=
 =?utf-8?B?aDU5YVcrRDhiQmlna09MY1k3ZS9qSXlTS00rektmb25ySlpyaitGSTBzT3Y2?=
 =?utf-8?B?RGppbkhBS3R1cXZXdlUyYzczMG1zS3VKUHFzMi9rNjBxckk3M1hmbHByQU8r?=
 =?utf-8?B?QmdLNGFsMFFjYXV2eUVrZnIwbDJyNlBiNWlvSjFTb2VBU21UWWFQVkowclhh?=
 =?utf-8?B?QWVpYWRDRWlTeGI1c1FlSENoYWgzblNFSjNiNmJvSURHbjF2YmM3WVVWRFFy?=
 =?utf-8?B?bmdYcXdFRmJJcFVsc3A0M0M2eEZNNG1WSDNQZXpqT3hzMFlNZkhtbjBNZUJG?=
 =?utf-8?B?dEkyNWQ0U3NOaXM3bG8yUEdlemUvQ3BCcURaOVVKV3ZHYTY3WWtLUDA2WXJ0?=
 =?utf-8?B?TklCdStIcnVDNnFzbXV1U0FLQUNCVUdyS1hMRlFjWjA2SHk1SmpBWEVPS2VJ?=
 =?utf-8?B?Zy8weXJSSW5lRDBYN2tXdFk4dWhiY1NFTEgrQ0pDMkZsMUEvcmJ1dzVEOUJy?=
 =?utf-8?B?RUQ1RzRuT1lLTGYxRWRFYW9wZkNvSGRTUThwc296MFlDUXF1ZmlmbG9LMkhk?=
 =?utf-8?B?cDlqS3NEa2hQSitFbWMwZ2FnTEpvOEVNOGYxOTNWOCtMUnlETlVNWGllUEt1?=
 =?utf-8?B?NnNaYS96c2tzVG1VNHQ0WURsS1FXc3I5eXRsMFI1Y1IzaFcwazJ2cUVYazZy?=
 =?utf-8?B?VFQvZGV2RHVwR2oxN2lYekF1dktIOTdjMDZWOHVtOHpyWVByQ0J0S1hqdmdK?=
 =?utf-8?B?cHF5U0VZT0M3Q2tpa1hJekY5Nm95S0VsM2dmZmdyS0hPejE0RS9EWm9wOFRj?=
 =?utf-8?B?NG0vMkNZSUJPQVkwK0EvWm9pTXZod0QyVi9hVTJhOFJOenc0TzdqODRzK0pS?=
 =?utf-8?B?bU9tckhCaXo3d3lNYk9QbXdOb1RFYzFrYUx2R2duQ1MrSTRmZUoxUktRMmlD?=
 =?utf-8?B?YTJ6S0FwcDdyc1l4emJHMy80SFpBZGY4anpXN2FobEtqeTZLMTlEWlMvcFl4?=
 =?utf-8?B?UFl5blY1eW5aWlB1dUVIMFVBN1BIWlg1dytWNDBrS1QwYlRUeVhIendrK3Jk?=
 =?utf-8?B?VlZheVJwRVRoYWp5eXJOTmRSMnBOV3IzRm4zUGVTcXZvd2w0OHIwdk83N3RT?=
 =?utf-8?B?SjJYNzZiU25vNk1GNGJTckllV0ZpL2hGbE1IaC9XZ1NBZG1ySkxBSXg3dVZS?=
 =?utf-8?B?RGhISk1OaWhzUWYzVWZPMGNESmNWMks2S2JKQXdhKytjQ1FEenBpcE9vV2g0?=
 =?utf-8?B?OUQ3MjJ6SSsyWkkxVXlTZXBVZXoyUFF0d2JWQll2SlVPSkJMQVhVcktaV3Rw?=
 =?utf-8?B?U3RhRGVock1Hb0VpMi85UWdTMVRmd0plM1pGVk5OalJrbVN5OGUveHpJZjBw?=
 =?utf-8?B?bXpRcndTNXBIbzd1Ujl3ZE5KdmMwOU1IL3RrTU00M2pVdzZmOTdLbW91dHZx?=
 =?utf-8?B?TkRZTkdzdnlnZ2VCU1dNZXJ4Yyt0RUloVXNlWEhJSTBkWG5VeEpHK0Z1eVJl?=
 =?utf-8?B?cCtsYmsycElTTEdhY3BCRExWTUFXZ1daWXdxbktBUkpUUzM5dUpiOFB2S2NV?=
 =?utf-8?B?R29WYmFSL0JGVUhacVdCWDRDcndWT0VZcVdjakUwaWdjbXYyazU4T3ZjZWg2?=
 =?utf-8?B?bDFBUTI3WFpHcDFjQTkwMlFTd2NtY2pIaUFZSy9KT2tsNW9IekpQZW5uUitE?=
 =?utf-8?B?YUhSNEtUOW5FQit1KzNlc05MbzkrOXg4dmJDOXFKRU5iK2dNdUxlZlpVT2VT?=
 =?utf-8?Q?7jDqY0fCz4w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnpiN1hZWFFIRVkvN2tSMmpmT0pUQ0xLdFVGM0NRWHlhMm1QMkVScXJhUW5K?=
 =?utf-8?B?blVRMi9ZdnRhVlRERGhVWVl5b2Z3WjArZVJkMWo2ckV6TElPRGtKY3lQdWF1?=
 =?utf-8?B?bStNUm9mc3Nrdis5ZHA2SlhqZUJlcm9DdWZsL21xQTZUTGNCZzg4RG9SOGdi?=
 =?utf-8?B?eFczZVZJTnhxSGxjVEhwUVFNZjhmMFJLNk1CT3FTQStQMmRSYjFhN1llM1gw?=
 =?utf-8?B?WjVWMjBTQ1JIRjRXbU1lTW1yV2F0cjl5T25qS04rNVBkRys0eHU2NXV3RjRm?=
 =?utf-8?B?N3lQbFJCUXVjakxibnNFTHRLOUdqdkZrd0VReUNzOTd3RUlubjB6dU5KRzZJ?=
 =?utf-8?B?c01qTFFMdlFZbHNRdGRuNnNvMXBidFd2K05jL3ExNGI4TEhWdldQSlR3QmRX?=
 =?utf-8?B?R2Z5ZlFrYUdlbXZNbHFqeW1vUzl4Qy8xYkpLT05yUDQxQ3dHT25Ua3VEV29a?=
 =?utf-8?B?UGRsZXFpTkltMFlNeDNPb2REbEswdERsQlFiUTNXUC94VkpOdlloQWRKRG44?=
 =?utf-8?B?VW5mTmxJanhZcFVNRHNBUWN3N3JvaVJoR0o0dmpKeTYvZEx1UGNpRmExTTJL?=
 =?utf-8?B?UDN0UWs1eVM3dE12enZvbjBFMExkNXZiVTQ1dmhsRmM4WGp3NU13cFhhbGlo?=
 =?utf-8?B?VCt3ekVSckQxV3kyUjVtaGY3cHhSa3FYdzdHbTFFWXFNTTNxUTVhTTg3Tlgx?=
 =?utf-8?B?eUxWdXBkZ2VyRXBnSGdPSjZBdTAwazkrSXZyaUc3dUc3aHRGd2ZzMlNJNGpW?=
 =?utf-8?B?Z2pnNndzYUxNMFFDU3hqRkZaVG1SUFlabURJUGs3MzVRRTkrV2RkSHJsQ2J2?=
 =?utf-8?B?OXZrT3pzdmJaQlkwRnBqalVFQlRlVmxtTk1ZNTJZVEJjSVE1TDhkOExuNmdm?=
 =?utf-8?B?ZDYrZ3JiUzZBeFNXWDBKUHhvQ29QSEJhN2NGODJXVHVQd2gva0tTL1dMV0Y0?=
 =?utf-8?B?ZmtPaE1LWmtUOXY0RmNWTzZGSS8xZzA5WjE1U2lEbFZQQk42alVyUkxtSjNG?=
 =?utf-8?B?aUtwVXArdDBGRjAyNHk5SVVrS0J6bThNNlZqaUIwTlFwWXFyaFRTcGxBcVVw?=
 =?utf-8?B?aS80dEZQanJVQmR1emc3T2paQUYwOWFRNXhJaXdqS2ZkcEJJMVpTRE1BbkU1?=
 =?utf-8?B?cS90UDFoMnU1NXdJL1lBQUd2TXM4NXJidkNaUEFWa0pGVGJjQ0srd1dHOFd1?=
 =?utf-8?B?SytSM2Y4VGRHOUtYWldoODYrZU9wMUs2TU1GKzVWMlJmeDV1NDZCZ2FydzlR?=
 =?utf-8?B?Qk1hQnluaGgwZUdTUk1kcXcyOE1zUUZvZVZFNkdzclo2WVcvU3dIc3lKWlhF?=
 =?utf-8?B?dHJTQ0ZzTERMdlQ2ckhGbTlMS0JZM3ErSEVBejlzSWs3aFJVTHYvNmdobW9W?=
 =?utf-8?B?dXNmYkh3MHR3QUdtMFY5VWdhZHF4Z2ZaeXNITVNjZWE5aVhrdXFSYm1wN213?=
 =?utf-8?B?Nk1TS0NJQTQ0SkJUQVFVRXpoWkNITk9RS3gxN2toVFpEZmtJRS9xUzZvZDYw?=
 =?utf-8?B?RFlPcUVZT0pCelVxcC9Wd3hUUE9UWitnRU9xNFFvY01aUVNFNXRxTEJhWVl0?=
 =?utf-8?B?R1hkOFU5cFJiZExMOXYwL0hzT1NDOVhjUjlZcFFNZmFweGJpV1RrRkUrZ3ls?=
 =?utf-8?B?bXU0SGVUZ3lHVjlMTVNYUEhMemp5enFoU3V6U21GbC9TUEUxSnJaNmhTRHhW?=
 =?utf-8?B?K284M0FDWlZLaTJnYS9QUmpYMHFHRitLdE10dU1vVkxRbzk1QlM0T0tNSUhh?=
 =?utf-8?B?NzNFV2R0QnJOY1hWTUtXNjRMbVRmeGtocVFMS2Roc3ZzOHI5blE0eFdtS3N3?=
 =?utf-8?B?eWpnaUtvNGhvVzhSQjBYU0drOG1BQjdrTVNCUUk5MVNIK2VtTGZwZlJJWmph?=
 =?utf-8?B?WUcvSTZ0aTIxbXpEa3pJTk5lQWxoYlZFeThFeU9RWGRzenVjQUxBWitMbHZv?=
 =?utf-8?B?MVRpS2N6VUptMml5Tmtnb0pYN2xDWUl1c2xjem5rOUkxSTVVY2gvTjRDdGZy?=
 =?utf-8?B?aGRxV1FRYThGOTVPNFNUNzNrVFdpSmpKNkR1QjVkZXJRSWZSb3BLUnhCL1JZ?=
 =?utf-8?B?OTVERFNCQ0ZhOUtBeTFHZTFmdzRyTXZCS3pmM2c5ak1xN0NVNVNURmg0VWNm?=
 =?utf-8?B?WVdyeUZZM2NDamFkNmJDemdGWW1ZMGVDanhpSi9QRE53RThPYStDRlFHRjk3?=
 =?utf-8?B?YUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f80512-37f0-4df0-f512-08ddf51ba9a6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:22:11.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FG1E+OTBZmbwppc2kgg8AtWTPZKvgF/8EQcqiWcAR0zdAh3Lz9AThOf9fHQ6rUte4EcbMWxMfy4rrqcF99dt9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62A6620010
X-Stat-Signature: yhzoj4ay7d9s6k5e1u7cadqf6xogx8ma
X-Rspam-User: 
X-HE-Tag: 1758025522-230452
X-HE-Meta: U2FsdGVkX1+zj2+iC3CTCuUQaZozlWwiloZIhal0lj51mMT3CYdXAwhu4KnQcJIUm9Ug4tqoEv3Z+uetO3kRHxsp9tGc7FHtzrqHd45jeJ3eQjZ4kYMtiSBtFL4DRub2BGpmEHrHRD/e/fB4s6NogXuFqidRqnh7wadEC0jwONz4kQ61E+rrd48JLUzC0KiIbwteot5AMRSrapj3f9iUQAxiWAl7l0o746+rwngGd7z/7s0S8Wg+NWm2FqcLs8qlzSD6G9LKoVTnfpq83gtv0DJtDAAcMfRediYVfiYksstlRhEfUossBiEqapFyTAGQRIiKRpceYeY5L7bLu1BGnD+QFaS3dEQxlbFy7RB6M3CiRGUgchLnL9A9n/Ziv8Z4muOPDIlcRTD76c/4Sa1t0sKEZsROX3aKUMttqq6IWYZH3JKbZT5KkvjE++Qj6J4cHGD4yju1vp6yj82FN3oLMXR6fKMSb38G2qPEK4/NAy+1NGthK+FSKNyFVsJvm3vdcwh2AN7CzQ8552HdSsQxfhIlx4w+BwdmY9kbTtEqzgAzlCl6SYUlq4UFTav2uc8N0xcrJNA4Ws0vk3wiVZZ/3YRNkqpkIaQAE/IuSLsqz/X5dJGCTyzQJyKxDv9lirrP61rBWQ9HZ7tDSGn0QBFhp9GJVvwu15ohKKMlDxDvLOYOkfT23ykSMnPPgS/UdXq7vEF3vg9OZ3S/21pWae5o7ljFyH1upgMF6/JC/1cWWfey3/dA6YnVrsXekgSQprkleQvIsKIFRmcKhXsVnAlE3JVOtkm2pF3GsQOXHstld0r1qq5thx++fQjva/CXur89Lnb9MShWIoX1A63oEBFqEKhE/nJV/zbsNkRDwJo6uJurmAOwxtdTtm2+IMiBhApUzZbs3l1PF+Zxahhwnzwhn688iafE5we3vdV2gAd7T+5SCUs0tURbmVso0wuTUijxKUKbhXvfRdvHgOg8cTr
 neQsdjBn
 jZ42qxjg9KPkToKDmmJZdUQw5SlfGIG7Qqs3Jg10Bu37VEd4HFgScVzXCe/A8K7ZtBrE9mGyLyw6Ck9NMHwmARHL/Z92KZ0m5WlqNQpitkwlyDphMKuw888TmgIKz309gZvz2sDkrO/JLau/SAFUtLed4QFwt1++0O+gvkW4NceCNf/TEw0UhhelPYuLSBnb24xAOVOKN9FMb3udOavg4cKcd3PfE+B05WFt/WzltxfJ3/eLmlfG5IAiyOlVPw1lKhRgb8Po4fwdXvDlgb3GYKGQ8qhWypCIlKHusYVOGOneiAFiQ5nuzcRv1RiB25QB2/BeRElItFhIud8Kw/AvJW66Q8uU26nDKWvusGGdo8X1DdijYoxrNfHMA/0E7jXjO2YqvAjvTnjqa4623TIcUJEWUt3Ka6XWuxq+vVwF6XHsEOXdCkJFjrY5GEt/ep6QFCiLFDGvg9kV+wVKbn4XP1lH54AVnkkvygJJxQnnd0TJZRVp9TzqV98Tyudmxp0/6xs/+Mneg+BCJL0jYZpU+Ui30HZm3mvTFstPsMstH7RmuX9xnZyu9QUphTNX5fAcfyJczUfweHv7m8HLxux/Pbtq5DQIkswQhYa9Hl2fCR7s3P73U/ISJMyFkzfdY6rdKxbDoPZQOqNTwOpvwWaqcOMviTjk0C/5jbVQ0d2knFCANuNidSR7MZYcDsYMeMHZhDHRsmF9pYgvyK4gq+CxQfAkBiOogt68Pm+TU3/2uGD8UmBXZbTIixu2Imbj+XBLVul+ErREBgJ3Zq2bete6GuVIsfub/m04gL3ywKGWTH0cajF5h3omankYzW3vggrEvzqpke2Dw1WHFDXdvwH0omz5IL1MFY632KytgFgSrFY5pDQ7XCtuxFNIfThcrbPb4B43AqGCAicXa2s+RgRUlK8FchzUdA5MPpWEro5u1fQHUPAIBB8TArWTYreNzz2bJaLrrEvw+HKR4tFxz0SKzfgwhDsHa
 /sXls2Mw
 OGO6D+aWu+5rhDtnkmR6TMxMRSFKDwFlYo0e0gaTndheg4r1MCnjwijIxhAlNh8JYUgNOBia5SSI10nYrym+C1kgXEESOYYq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement migrate_vma_split_pages() to handle THP splitting during the
migration process when destination cannot allocate compound pages.

This addresses the common scenario where migrate_vma_setup() succeeds with
MIGRATE_PFN_COMPOUND pages, but the destination device cannot allocate
large pages during the migration phase.

Key changes:
- migrate_vma_split_pages(): Split already-isolated pages during migration
- Enhanced folio_split() and __split_unmapped_folio() with isolated
  parameter to avoid redundant unmap/remap operations

This provides a fallback mechansim to ensure migration succeeds even when
large page allocation fails at the destination.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
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
---
 include/linux/huge_mm.h | 11 +++++--
 lib/test_hmm.c          |  9 ++++++
 mm/huge_memory.c        | 46 ++++++++++++++-------------
 mm/migrate_device.c     | 69 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 101 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2d669be7f1c8..a166be872628 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -365,8 +365,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -375,6 +375,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 41092c065c2d..6455707df902 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1611,6 +1611,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	order = folio_order(page_folio(vmf->page));
 	nr = 1 << order;
 
+	/*
+	 * When folios are partially mapped, we can't rely on the folio
+	 * order of vmf->page as the folio might not be fully split yet
+	 */
+	if (vmf->pte) {
+		order = 0;
+		nr = 1;
+	}
+
 	/*
 	 * Consider a per-cpu cache of src and dst pfns, but with
 	 * large number of cpus that might not scale well.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 90a1939455dd..5a587149e34a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3456,15 +3456,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3693,6 +3684,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3708,7 +3700,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3758,13 +3750,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3831,7 +3825,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3918,10 +3913,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -3952,6 +3950,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			__filemap_remove_folio(new_folio, NULL);
 			folio_put_refs(new_folio, nr_pages);
 		}
+
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -3975,6 +3975,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4065,12 +4068,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4099,7 +4103,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 1663ce553184..9f6a18269ff6 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -898,6 +898,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -907,6 +930,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	return 0;
+}
 #endif
 
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
@@ -1068,8 +1098,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1111,12 +1142,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = migrate_vma_nr_pages(&src_pfns[i]);
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1138,7 +1173,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_pages(migrate, i, addr,
+								folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1174,11 +1216,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
 		if (migrate && migrate->fault_page == page)
 			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.50.1


