Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1647BCAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9D28E0013; Tue, 16 Sep 2025 08:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1348D8E0001; Tue, 16 Sep 2025 08:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BE28E0013; Tue, 16 Sep 2025 08:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D270E8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:22:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94F0D832CC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:25 +0000 (UTC)
X-FDA: 83895026250.08.EE4705F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9212180011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mV80d2tc;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJSFdPl0wgp4h8sN5D7p4Hfx5Dv4sHLnsIiWVtKBxa8=;
	b=3thCCOgxZuRIfrnwx0z4KFwE2o8OHWnXSa65v8kHHcmkh8XcygBbJbPVUx/Knsy7/Yg5W0
	mutmJ9PuFp53euTqWz7E0oQ/5awE129OnVlTFqYYJHv7JsmVnYlgrNgsEWJxWRvcZe1Kv3
	M92yvqQLZmWemIhJIaa9V8LZDccNgGc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025342; a=rsa-sha256;
	cv=pass;
	b=3l+ALU/Cte6TmPx+2xIsjZY7vl7RXE6Sfe9lgo+j3uBHCDj7BYff61PVDIHKzQ54iZEFpt
	5MkKI4uvINfwgUGjVafe7+TLpfm88JbVIkYAsOZ4dSaXHEyU7lwO7uen0XbP6cA6tiSO0B
	4hbLkmF/7J2yEmc5xUSoxSgOSCIP98g=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mV80d2tc;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBz5/YH/MoKLZcAftoxYXjhXWMlHj/ebSFHmrdwc3p8aJwh8M9PDctMypPY6MqrB6W2JfYkzO9gItgeDhxhd70XmQrorv5YrQGmsklpDMSfMkIp66CId0xAijGstTkOBa6AFvf8LEgpnyN7V0Z1Q41FJbGL4BGPWTFh56zeqPZFxbknKnl5QQKxvWFhrLSfn4P3TC3lE9mDc39n/yZPi4YYJOiHZw4e2QqyEEShITgnTmVzAtuNyrFwIJEkV/vs+AJlTZoPtRgnaylw1zpaNEX1SsZ7oSLXM02IASeNcvxW2RSZrNha6EGsYGwOkYoxul/GQlkg4NWGNiK79kcjZQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJSFdPl0wgp4h8sN5D7p4Hfx5Dv4sHLnsIiWVtKBxa8=;
 b=FaKfGDfTi5GkB+dtHyn7EjBXwUx6VOzOcVPUdamdUwH/Z333NX9z7X7QCGDaoln+6WvjUeQTcAVBi7GAdA+hIyLqEjKHpDR7OaUB8uXxBnuo8XRznvoB7cphNydkn5GMqlAb2WjbG8Fu5sIyrnCHU4Vr/5stvKMnY+rUf4bW0iOxJDqE+KIEyTFwjsI4tQtXflBm4etDTHulbjlR2dJHr57ilw+GKo63KQXpeToKK2l90MXpGFGLJP9VAjNAkjTtev+DxQM1TKbqWunzB83o2l+teXMvVcb8v03SzuZO1NVXeZMDZLNasmgZOzSsgGLFj4PZfbdkYgslC/+Q3dg4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJSFdPl0wgp4h8sN5D7p4Hfx5Dv4sHLnsIiWVtKBxa8=;
 b=mV80d2tcM2Rf9tRXiayghGDQEsxZlvvTvTnyjwNn2xggud8GoIRwYmgWxI6FgodDlmmcJ3a7lXIjNiZJawFi9fKhe6cOMIFdr5l9UXJeeX8d8esHbacCIQec+H6pplmaoc/aO0pdGuUrDn+RbInrIoYv02L9EWuCq7Qr100q7VZkciMmlnGaYObJxEQx0XErZeYQmyelGIoFA9vCQNnl1DCdxaYw1wgHpMM/hNgj8wYFr0lWAqtoy8G+QClQuOwu10/Hk7QIve4KDp3/2Vr8AnfitiSR7BUqWt4P90cbh7gHa9zx0dCS77SDjGPOdicIP4c4O1OpPvMgBWR3XRkD7Q==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS4PR12MB9684.namprd12.prod.outlook.com (2603:10b6:8:281::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 12:22:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:22:16 +0000
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
Subject: [v6 11/15] lib/test_hmm: add large page allocation failure testing
Date: Tue, 16 Sep 2025 22:21:24 +1000
Message-ID: <20250916122128.2098535-12-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYCP282CA0007.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:80::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS4PR12MB9684:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f83e8cf-d414-4bfd-f36d-08ddf51bac8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2NrRC9FRnhBa3hMN3lVWXUzMHRsdTFyQm92eXhPaTRQeHZQY09KSzFOODJY?=
 =?utf-8?B?R2k4c2JRdzRWWUxjTFRHWFNlSTlob3dNMVJpVmV5VlpJVVRISFUxU3N3c2I3?=
 =?utf-8?B?TnFIdEVJTE95TERjRXYya0ZlVzkwZ012MmtqdmFRSU11bXovcjQ4SWdpMkZD?=
 =?utf-8?B?OXF5OG1GNDd5R2h4eUxicXJMR0EwRHY3VUw4QmJXam1rbmVsZ01aWXRkb0ov?=
 =?utf-8?B?dDJ0a0d3dFlybW1VbHZYaFlhSlNWUkIxZlhwa2U3blBwU0dXV2dMcjI0anVq?=
 =?utf-8?B?Ujh1dnRiaFhwRjFQRE5QYU9wRGtESUFlSk9ESnVRL2toVHdrNENtK01teVZ0?=
 =?utf-8?B?MWoySkI3eXY0VlF2dkp1cW9oSGRIbkhXb2czZU1oWksvcXYzN1I3dC9IM25w?=
 =?utf-8?B?d3BySk5sS0Rub1ZLSFZJeVJGNHNSOTV0MEt1ZnYrcXlCN0R6RTl4Q3p2emty?=
 =?utf-8?B?cGJtbXdUZUVqZVAxNENMTnRDTUFEQ3Z2dDUwbENHUnF6Q3p2cHVJNWRBWUhD?=
 =?utf-8?B?YmNmK0tnV25URzBqeEk3eGhkQ3JFcGRGQW4zWXJ1Y29EK2ZBeXJjOGlpMkxp?=
 =?utf-8?B?N3VDekNRWXdpdTZiMVVPVUlSMVhSVkcrT1kvZmUvQ0tZTEZjdWFnTWF4VlJZ?=
 =?utf-8?B?Z1hjdnVrWXFGTTM4T1FCenNJbXAwNmQzZEtGcnJVU0dFcEh2a2pTNUtMK3FY?=
 =?utf-8?B?QjZHK2hwWWxrRm1rT3lDeHpBM2tpL3pORDd6N0d4OThONlZIQlBJZ3g0WTcx?=
 =?utf-8?B?b0QzK2t0amltdy8wckVUU0VFeEdQb0Q2cGFvcEhlVnFmOXRHbURvNGs2NUl4?=
 =?utf-8?B?VHA5MkN1YlRjc0xuVWlDNWRrUktxSm5uMy9SQXpnM3Q0S09GTUhXdVQ3K2dx?=
 =?utf-8?B?OFZOWGhCVHlCaWtMY29IQ0RRajNsanVOSnJpTWQ4RDkvdHM3RUlJYnErLzZ6?=
 =?utf-8?B?WGVkV1RVVm4xcUc2U0dRTVBoNWQ4aFlObzltVHFlRDF3Q3lONDFxNjlZdHJ4?=
 =?utf-8?B?RlhqekVDT1J2K3IrelhZeHA5ZjBoQWJ6RXEvcjJEanJxSEJ0M0lRRVRGZHFZ?=
 =?utf-8?B?cm91bG9GMytkTVFIUHZzS0Vob2puaGRIY1l4OEhnMFhXbkZqMlVUdllIYU54?=
 =?utf-8?B?MDN2cVM2Z2g5bThmN3lqem51Qy9hSFdJM0R3bHhRendocjJOcFUzRThONWl0?=
 =?utf-8?B?ODdSSHI0RlJHUkNqVER5ZFc0aGdKZGVtclVxdVZHMngyWG8zc0F3OERpeXBF?=
 =?utf-8?B?VGZXNVZiYnM4WVdMYWN6NTNNTFg2OVNFdnZQdkxsRmlZWDl3RFM2eld5dEdS?=
 =?utf-8?B?Q0RTczBSRW1KTDdIOEJMaVAxZHBXbVRwaFJpbTZOeisxd3RwaVJHdVRFakhU?=
 =?utf-8?B?MjJueVE2WksxQUFOT2ozQ0hDYmpIRnhrOXJLbjdaNFl4dkpxZXZURHQydTBF?=
 =?utf-8?B?WjVRck5LMSt6SDJmWmduRlhwdUJ0dHpWVExGTVM0WWE5TzdyVytzclp2MUJY?=
 =?utf-8?B?WHNQazZnYlZjcjR6eDB0bjNzTWVJc21mVzFyYzRSeHVrbXpLcEJUSUlCRDBK?=
 =?utf-8?B?Q2JsTldEQUU4Wis5WFR1bnM2RVBFNFd3QmpkcGd0cUJPNC9KV0EycDRTYU5p?=
 =?utf-8?B?Z3ZpSWRXNGlMeHpNK1pQZjlKN3huSGFzZy9WalJYUE9iWk1jd0F3citNcmdF?=
 =?utf-8?B?VnVtc1dLRVAxNzZFV2NIbVU4WGpZaEgzeVFTamsxUWMxUWNGMFRrUnAyUE5z?=
 =?utf-8?B?ZXo1aURjTGYxbkN1TTBySnV0OFErWGhIbGdaUjQrUXI1eXNSS3pMKzNIUWND?=
 =?utf-8?B?cjBDOWw3SWtNMEZkMlhrVGxNRUxEbVZWNStvTWNIVGgyZCtOeTRla2FCckhQ?=
 =?utf-8?B?WllJcWUrZDVHckxWeDJOL1NVaGVmOEJMZS9WQlNxb2lPVFplY0hSU2ErbjFr?=
 =?utf-8?Q?kxf5ygiBYxU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFZGeTMrWFp4eE1DY3ZDNnRpTkhtZ0RUWFZHZGNsd1pxQzdpY2NrZmQ0MmVT?=
 =?utf-8?B?ZWR2V2NYMzJ4elN0Ni9PSXVrcFd6U1lnZDFBbnRXYXZ4aFAwQ2t1OGRHRUVL?=
 =?utf-8?B?WHlPbWxsdlovTXJySkpoMnpMRXZrMkg5TUlJZHV1M0ZEZzJzT1A4VXZUU1ds?=
 =?utf-8?B?OHRTU1hQL1NLYWp1MVJZVVZaWkpscTNHb01mY24yak16djFYMTViUWdWQ241?=
 =?utf-8?B?OGNabnBvZW5yQnBKUVhoRkcrQXRaTHRiUm1LdENndTFMaW5CZGVVbEpBUjFt?=
 =?utf-8?B?M0FvZXlleUFKVDVZWUlHR29oaEFSVzdwQ3phT1QrUDZjbXZPaTZieTduVS9W?=
 =?utf-8?B?ZVROckp1NEtsYjJkbldBbmpNWXVqSDFQcXZVdDZkNTByRzlMclQzb0VRVnJD?=
 =?utf-8?B?cW1ZTEJQSWJVaSttKzR2SGRhbHlTSmVWUEQwRUsxZllzTWNnbUFZWXQyZzBF?=
 =?utf-8?B?S1ZhVE14NGdZUDdDWkRlRG4wR0dXckZ4RllnR2pFUVNkL1dtcWlDU29HdFNZ?=
 =?utf-8?B?QSs5L3dvTmNBTmNINzV3MkZSdExNWnRqNjdMUzVOem5vN2RtdDFjK21zVldR?=
 =?utf-8?B?NHJoT3NMTkYxVkdwUEhFQWhBQzBlQmhnRU8zVzFCekllNVh3V2Z4UEVMMGI2?=
 =?utf-8?B?K3o0NEdHQnRzTU8rTWtDdjlRN0ExamR1dko0MkQ4cGN3K1gwT0tyMmtqb0JW?=
 =?utf-8?B?bnpHcTNQY0t0UmNPUVRQenZaZERIenJqN2t5ckJCS0hSRDBDWnphTk1MbWtV?=
 =?utf-8?B?eGFSVGJzZ2dSemNZblhCNEtuL0cwekRPVldscGc4aXBSZTVRQmZMYUp3UG1i?=
 =?utf-8?B?YmJjbklKSWdUeFhUdERLSzhORHY3WVJTTkY3YnVMZVgxYWY3SHFwQU91WnZv?=
 =?utf-8?B?QkZHbjJNNlROZG91WDFvUmZna1ZncjM5TWR1RnM3WkI4TzlSdzR2QnlhQ3Q2?=
 =?utf-8?B?RlJhTTZSR2ZScWM0dXJsczRQMHY3aFM3VkxDeUpEQVA5M2t5N1REQ3NYdTYy?=
 =?utf-8?B?S0d5cDd1QUM1ZEVUMWhmRDRFUUdsRm05Ujl3YkpKMFZLMUsrTHhvSWVQZ002?=
 =?utf-8?B?NlZDVVk3d1BraWVYS3VNZTVuNUNCZE1XeXlDSzkwRDR1TTVIcWtpV3JZZDZR?=
 =?utf-8?B?NHVkU0VGbzdhWVVzQkpwSkdRNXQzS0dueGJ5dVlhUmpGcWtDRWhKbmhUcXN1?=
 =?utf-8?B?S3hrczRXWWI5V3NrQTlJd3laemFmdk4vUVZ0Vys4U2pkK0pEZkk5VWJmeUp4?=
 =?utf-8?B?dUlNVUVVQ05meDJYTzBac3pCN3ZkcndBZ2lOTC9yWHc1clRYRlhnbGozT1dI?=
 =?utf-8?B?YkdLYlM3SVZNOTcvYnJzaUJrQlViblhRTU0yVUE0QWpqV0JuWEg5WVpMdDEx?=
 =?utf-8?B?THRsZ3BnRHNxNDVGcUw2K1ZrUWEyZTQ0T0h2MzI4OXp2SU5qRnRoSEpORWg3?=
 =?utf-8?B?WkREN1lwN0lndThSYk55Mlg1dDdmMmROcG1FMlFseGRJSHZLNlNqaWxiTUox?=
 =?utf-8?B?TG5senNWQWg5Y2phZ3c0YWllK3R2cVFtdVpqcFFGY3lodG9Rckc4emJvWFJ2?=
 =?utf-8?B?UzBoOTE0b29WTEV2dHZlRWhQSTZYSXcxaVFwanh4aUFxMG1JSTduZW5hZC9D?=
 =?utf-8?B?Vm1lVDRNaGZVQTcrZHJTeFJGWWhmaVIyR2NxYm9oMzMrUXVtdDVZR05leW4x?=
 =?utf-8?B?U2ViVFo0RkZXWmJWTG9RbmdBMEtjdGRUci9LdUErT0lqZWpyS05qWDRSMUdk?=
 =?utf-8?B?aVpWM0RidU5QMk5KU1F4QjAveks1WUJiT0Z0TkxZUmg2elJMMDhxVFNUbTd4?=
 =?utf-8?B?eTU4ckJDTVh1NTJlWlVWOGFVQmVMTm5PY2JodWZIRkxiOVN3MkhwSGp3d3A5?=
 =?utf-8?B?bU5LMy9sb3pZREIrR0o5Q2xya0VuN0RhQlFFYlBxR1lwTWZxUU9UbU95YTRT?=
 =?utf-8?B?VW5KUjR3MkRvK21yVms2MzFkeW44UnFld1lnTHZqSzA3MUtwU294RG9GcXE5?=
 =?utf-8?B?emdhczJjck5LNk9yWmwybEpGUVp5R1NXMkRKTGhqLy9jdjR2SElVcWN5WFcr?=
 =?utf-8?B?QzBvb28rc2tVNGNzeTE3RHIxVTJYTCtSY2FXeThjOEx3S1EyMFFFVndZRDlz?=
 =?utf-8?B?dmR1QXZFckhONjc5YjA0cGh1REVhTmNCVXAvVUorVVBMQWFrdlp6S0taVnZX?=
 =?utf-8?B?RGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f83e8cf-d414-4bfd-f36d-08ddf51bac8b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:22:16.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ht6nyxlIxMBIJV5UvTyf1rHCcg/VJOF+1bJJeYqjr7l84rDqb1etkcJXaBIps3BM85iIEOKWl4bwWQ22jCQXMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9684
X-Stat-Signature: kjp6c1u7j7i1a8cmmswmi38o7np47mo9
X-Rspam-User: 
X-Rspamd-Queue-Id: A9212180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758025342-645155
X-HE-Meta: U2FsdGVkX1/rh37BLs0LA90+DjXM0ComKiSAAyVUxO2SCWueZqvBDvi/H6Bj6LU9QRnF2eCVBykk0y4Xi4SdHNyD5aQtfEpVtWK4BThMOUtuNwzgsLHMJJBYlAueB2AQSuMiSFeTrwAFHpAcXvQJO/MEDlj7st0Tvja+05nDzMMXrPYoIQO0+3qGhLnMv7aQvbBaDMKslQ4D+K80v8OZCAD6FDMWvILzSaytflp7yNdnAppZG6oP5bZzGeFLUjmPhIQr71c1Q0kT/gRO9/oMsVyUETel4GOMzPOpoB8OhwTFoR2SFNdx4BYVR5DQUvJsYAS9cDUp6BKO7fY8X6JTqEgm9meSwG681X0ry+ul82a3XtgUpvPIBUIOsD2DO0XG9hWqcfLjjx6Y2mUPF/aW1EbxLMdZCxuTyI4xcCdo9hnQ+d2n8KtRq51KFec5JFC78BeeDaz8PnyV+xOF/g2JUzCkWs5hZezf3YoEIH7g6BBnChklPEJg5LXuK5zGdve/FLfDIUQHaxLms68kynmK+vP+2XwmiUxBSGGrGMKQfa1xAwIziyCF3XXjV+3y0xbho7Ac4csrJJk0Yjwvq3z/lvAG9wj+PrXyKJaHBM7FQAEQlJxl69gwm3t3eTdVNwJeQMhQUWzwc9gRPw1vTcnJ4zIq01AHuISjt0lYNEEgk+Q2W3WANYJr94kc/nBDQ4uo0/OqNCUgstj/36Jo0Yhe44i0TMgzjy8wnxMqreXk6DBVmkceusZH48HsiYGTYrLJdEafsd8eD1/6FzE6c4cbXEBCOs1zpwVFxhT9ghTe0KIOsMjwrRyz3+FsvIR6OMiVshSm9f6ASjl3LHLKFE/Za/t/hacqo5Mnd2OczgGBEdaazKKfmkBr3EnqDJ+7VjDRpSjMTcxxajcIgy0zKEtimSyrLQSKTdfbTceeNzur230dyqGK5cHgxvu/2pPTVd4NEYeFOMIrAKKczQNEQf5
 nFvQc/io
 eYJTEiUjW7/hOabt70WxmwKbsM/GRG8ATHsgk9VJ3A6fJR9+NEtLkGOHh38785DGFiwaV13wXwLdmnQ+8sbYOOIcblv8TGKo73GbLF6tRtBRWcJwbIg5Vu10dMs4jUX5X5FxFiBZIHl6QaNiu2ZXfybJnjzQ+Cioy4p0TiqoIKicmIZZMJfY/LU9Ko541J8OJgrOFJCnvaBAltu9n2UCThd7urpRzGo5wPofWfPIC5U+9BJMHxd1n3kMijoj9KzbbcaCMLp/QVPtsuiueo7utShudRkzu80IuunUgOiS7cIv3Ts773i+WZnj/S+a1+efrXSYWhvyQU87XhhKdU1iCSVZXN3gYIJ3SHR3MPxxqueaG9QyO9LHWg0snQL+U0ikemJPKFbpuoHrJC4XA1agtCHGpfZZbTeVA/61ty3ig2puVe/BaykexDreQwnLisgNsJ6SdoxFQ6mlvvTIr/S+K0110mq9WkzXVQd7Vl2KZmymZDE+pe5XaGA7snobAGkkiLpzVjyR9xjeREdkldgcl+FnOvYts7S4YmEFEkplDjD8PKlL6T37ufIplcq7kU4HgeQYBXObHYWdztn7FWOA1FDm2CjOXxwQjD9t3WbJZE/3Rxz/3DzREYCmdlTH+9dmYysDWGCeLM19q69zYlwSyAE8cznHw3dat8xwX9L+H8K5t3WaHr2pQuNlDY5s5hrj21HgdvXARtSrSiTgYSQevVQM7DK7GuKIfdgXs1vr21YmEX8z+0d2+2G7SW+HbDfmLQLBfzr/KgQipdQMYpstS1eWiyPFWBPSTaanxnEEJRmyFwgS0EC4Tp8mzrNeD7W3lSM9REgbu6B4Cx4tglMBgB96Qk3Fa3AQRxovacZChO3hbSA6zFFTAInfer1HuDew3F6SKWIhIpSh45Dxj/jJEbnX2u9vq3TQW1WQHc5vX0fpo0i1PJmDW+ffXRjJLujTNk6Cn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add HMM_DMIRROR_FLAG_FAIL_ALLOC flag to simulate large page allocation
failures, enabling testing of split migration code paths.

This test flag allows validation of the fallback behavior when destination
device cannot allocate compound pages.  This is useful for testing the
split migration functionality.

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
 lib/test_hmm.c      | 61 ++++++++++++++++++++++++++++++---------------
 lib/test_hmm_uapi.h |  3 +++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6455707df902..bb9324b9b04c 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -92,6 +92,7 @@ struct dmirror {
 	struct xarray			pt;
 	struct mmu_interval_notifier	notifier;
 	struct mutex			mutex;
+	__u64			flags;
 };
 
 /*
@@ -699,7 +700,12 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 		     page_to_pfn(spage)))
 			goto next;
 
-		dpage = dmirror_devmem_alloc_page(dmirror, is_large);
+		if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
+			dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
+			dpage = NULL;
+		} else
+			dpage = dmirror_devmem_alloc_page(dmirror, is_large);
+
 		if (!dpage) {
 			struct folio *folio;
 			unsigned long i;
@@ -959,44 +965,55 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 
 		spage = BACKING_PAGE(spage);
 		order = folio_order(page_folio(spage));
-
 		if (order)
+			*dst = MIGRATE_PFN_COMPOUND;
+		if (*src & MIGRATE_PFN_WRITE)
+			*dst |= MIGRATE_PFN_WRITE;
+
+		if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
+			dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
+			*dst &= ~MIGRATE_PFN_COMPOUND;
+			dpage = NULL;
+		} else if (order) {
 			dpage = folio_page(vma_alloc_folio(GFP_HIGHUSER_MOVABLE,
 						order, args->vma, addr), 0);
-		else
-			dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
-
-		/* Try with smaller pages if large allocation fails */
-		if (!dpage && order) {
+		} else {
 			dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
-			if (!dpage)
-				return VM_FAULT_OOM;
-			order = 0;
 		}
 
+		if (!dpage && !order)
+			return VM_FAULT_OOM;
+
 		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
 				page_to_pfn(spage), page_to_pfn(dpage));
-		lock_page(dpage);
-		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
-		copy_highpage(dpage, spage);
-		*dst = migrate_pfn(page_to_pfn(dpage));
-		if (*src & MIGRATE_PFN_WRITE)
-			*dst |= MIGRATE_PFN_WRITE;
-		if (order)
-			*dst |= MIGRATE_PFN_COMPOUND;
+
+		if (dpage) {
+			lock_page(dpage);
+			*dst |= migrate_pfn(page_to_pfn(dpage));
+		}
 
 		for (i = 0; i < (1 << order); i++) {
 			struct page *src_page;
 			struct page *dst_page;
 
+			/* Try with smaller pages if large allocation fails */
+			if (!dpage && order) {
+				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				lock_page(dpage);
+				dst[i] = migrate_pfn(page_to_pfn(dpage));
+				dst_page = pfn_to_page(page_to_pfn(dpage));
+				dpage = NULL; /* For the next iteration */
+			} else {
+				dst_page = pfn_to_page(page_to_pfn(dpage) + i);
+			}
+
 			src_page = pfn_to_page(page_to_pfn(spage) + i);
-			dst_page = pfn_to_page(page_to_pfn(dpage) + i);
 
 			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
+			addr += PAGE_SIZE;
 			copy_highpage(dst_page, src_page);
 		}
 next:
-		addr += PAGE_SIZE << order;
 		src += 1 << order;
 		dst += 1 << order;
 	}
@@ -1514,6 +1531,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror_device_remove_chunks(dmirror->mdevice);
 		ret = 0;
 		break;
+	case HMM_DMIRROR_FLAGS:
+		dmirror->flags = cmd.npages;
+		ret = 0;
+		break;
 
 	default:
 		return -EINVAL;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index 8c818a2cf4f6..f94c6d457338 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -37,6 +37,9 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+
+#define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
-- 
2.50.1


