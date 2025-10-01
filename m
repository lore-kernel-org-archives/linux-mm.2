Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95301CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5C28E001A; Wed,  1 Oct 2025 03:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9DF68E0002; Wed,  1 Oct 2025 03:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D654D8E001A; Wed,  1 Oct 2025 03:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C32C48E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:01:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FBB31A0927
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:01:44 +0000 (UTC)
X-FDA: 83948650128.28.1EA11E2
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011055.outbound.protection.outlook.com [40.93.194.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9798180010
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:01:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gofndjs0;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.55 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759302101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1jyZzKTaL2pML2tH1RnxMC3UEPPRCkesBbj7bE3tsU=;
	b=UoQn/W9nF6gbggQW8EQ8pX2tJpQCZuyJXCuWWHNKz7cQkcXM1+KJY89Xp54PH3t00LQINg
	wDgSULtSNuZRTirp+tDDIb8R6fLsztO7IX5JFjj7iNozhg0Xi3CZX6VoQ4Iq8Po726MwP+
	WC1qqDfl7CY1H4INLAH85bHbiI4cZR4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gofndjs0;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.55 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759302101; a=rsa-sha256;
	cv=pass;
	b=H355JUbNF1gikXm7iV/WgWnC9qjTIWfp3G3pzauW2OJ0BExprTXU4It4p+CwuFsEVinIZZ
	jZx//hrC7SMuk3OIX15I9Rc0B5GR+LsG6EOQc8zZ8W/9JTix133NdbLeghZytoMMOLENZR
	Xs4fBvf7cliuIcykpUW/sKeZ5JKoOjA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3No7u+hWw2B0ymAqRAKOr1i1r1ncBTmAMOvEAkZqqVsvYKm73pamtu8JMEPJrJLYbjwCAFGsxbo5Qs2qmU3VoHHwWvpmVP2hprGNsD0cCplO9j04Ki0AOTtUtTtcdC5NWrZT0Da8nolTMwPB1iR+ViicJbc61IKGtkOdWY+6HB2mUDbaGkupKrU0e5+hLJPWQJ24m8VuKpriOIkyQWyFJRwMmWTfWLMOj0lwrjIU8qnIWyi7DKI0iW2x7ZeZik12fT2pzrIbjeZutVaE8q95Vib6AWia2f+b6BYdwYjOuINTCgHs32gLIPXYt0idCxFK2zsA6+t7MHjnKTuwYO15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1jyZzKTaL2pML2tH1RnxMC3UEPPRCkesBbj7bE3tsU=;
 b=P/y7XULe8hWAxFDIRTzz/H1B2vtMLWFpW91VBRqfsHSGM6/k23wkhc4aLbaEFZBA4WPDIrp6v6gUxSIuP5rNAf5qLrmhg+1g0t98F7rZ3epeulWe3QSwlGd88AKP1MmzCP8xwIHUAmYgUrlMk7ky8QzwVrXV3IqySCRI3SgI5itThCncwZFWBXCHCI/axC/LeXKW/JAzg5PtettRMrvSkGZMp8DAN0Jc1Za/fJUPOD0gGz1hw0r4coREgTfp6tHVrJvhmoP6IZHdXFMcP1zktGsrra4+ntck/iFWI1SMISpujoSq1wsI/AovCK89HReNzaPZ9wDZ15xxF2J1Sv9IYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1jyZzKTaL2pML2tH1RnxMC3UEPPRCkesBbj7bE3tsU=;
 b=Gofndjs0E4qpEcQnmNQGy/hPtrdSP1gdmcSiUuuud51u+34URHO6trYZ62DLwZtXkVz2leby6VAMa66pusRYDP0/uTf1Gb8EwCu5HokMoBW4niVm/8Pjg+tua4kZgxTyvGAik99+Nx1I3G0SsrKd2JNVbYlgjhgMsER/bq3LVRmo5OOs27pIRCtgVLIhBKyGyEYkiPtyKpytb8l0p2bDi9Pr5Chhp9a4DQOqGrpDTqj12dAev4rf4RrKt5T8fBoUE8+HsuMsTCR9hlOwU5iEZL6MYxyVcQL/tgv5j5jj0Y5TMV+ghUaf4igcUHJqheDRRSFW7oBrMkKCv6pP++MNIw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:56 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:56 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Matthew Brost <matthew.brost@intel.com>,
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
	Francois Dugast <francois.dugast@intel.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [v7 14/16] selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests
Date: Wed,  1 Oct 2025 16:57:05 +1000
Message-ID: <20251001065707.920170-15-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:806:a7::21) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 85742e99-db2e-42e5-86ab-08de00b7fd54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGFsMXhWRi8ydEEwZUJ1UVZ3czdjYlVuZ2Q4bUlCUFB3MWYwaFNuZVllWGZh?=
 =?utf-8?B?dE5qeHdmQnpBZHZLbVd0QnBrYnQzTFNYQXQxb1lhaVEzbFJmRU1meTJSSzJV?=
 =?utf-8?B?OUJtM1AzZWZ5VU5tanY3akpVMUJxMEdCeHlZNDRLb0E2RlZqZzNKbFNUeGpQ?=
 =?utf-8?B?dGErRElpNVFYUkl3RWNVa0pzMEVoWTd2bWxNMllOOFpIVkJTcXc5TTdOcWwr?=
 =?utf-8?B?dk8wZmEzVkdaRW13QlNuazRZUGNJdGNxTEdGcTRNaXk4Y0FPdTV4RXFlWFNl?=
 =?utf-8?B?bW1yY0tjRVVpMjBBREpzb3c0cWJVWWRsR1I2TFBDaHB1dC9UQy9TQ2ZLTVlQ?=
 =?utf-8?B?TGU3TjUvT0U5ZWgvQU5KaHNrbmZQNWFLS0dCYWZZeFY3aGY5S1dtNFFWZHZY?=
 =?utf-8?B?UWZhc28zMmRienNnQ21ycjFGRHY3SjZjNUdnUExWc0V2ek5taHJOTlp3a3p0?=
 =?utf-8?B?aW81YktRSzNNRlRVeGhleFZxVXR0TVJFZWlrVEYyQjh6S0xjR0ZqYXFZaE9W?=
 =?utf-8?B?TVJVQXAzSnJJZ0ZDalhLZXpTblkrS1BqYXd0bk1BRy9wcHRWWTh6azJ1dlV2?=
 =?utf-8?B?eDBvMDVjK29pVFNWVzU0ZzRSSkFOMmdJNU1WWUowODB2RGNKdVNEanZYeXBB?=
 =?utf-8?B?aWpLTW4rcllWK0llcUJmZGJpaEhkNXNoS0tlYVhPZUgyTVZINmNCb2lhRFpm?=
 =?utf-8?B?OU1IcHMvU1ZMRGZtREYzazY2dmpsd0tpUnFrVmZiZTUyM09XVTkyaVV0eDAr?=
 =?utf-8?B?UG5wYVBYY054MFFiNjFDQTZYRTZ2cFB6NUVqMEtuYVEyZDdhdTNrdUR6M3dt?=
 =?utf-8?B?WjdQYk9pQ1pjVDloaEp2Qm1ocDdQR2xLSWhBNlR2KzB3YzlBaStiSFlGd1hT?=
 =?utf-8?B?OVRmU2poYjN0TEFUbk96MFVDYU42QUlPTTVIaENZd25zc0Z1SmxEMGc3bTBI?=
 =?utf-8?B?bzlvSWlUT0JWNzNWWFByR3I2c2xtdWwzcGdhSDZ1TDk0MnQrZVJMb0paWmhH?=
 =?utf-8?B?VWFNQmhMVEJlWlArUWxzeUtTVE4wbTlZcHUxVm0zMTdaVytNQTdpWDJaK2lq?=
 =?utf-8?B?MWVCaHdBY3d2YWJwVWpHdGVSRUV5UnZnVTBMTmFMM3FXallzdmt2STlOeEw3?=
 =?utf-8?B?dldaRzFid2JNVWNZWmtMTWc0T0RLbUtKYkpYUFJRbmtETEQveE1QMFJJNjBq?=
 =?utf-8?B?a0JnaVl2MkFuWG9XNXhpYXE3c09hZ3ZmaXhHRm9Kcm5HakZ0QlphRDVESjRt?=
 =?utf-8?B?UTJkYnA4WUt4SW1rVUZ2M1gwcm1YWVN0NHpVRUlRTFZMZm5PVTNOS2tCcFAr?=
 =?utf-8?B?NW1GK2V5b0NXZHJUWWEvL3R4L0M1WEkvZGtMMEFXU01WY0xiVmVvWjlBSUh0?=
 =?utf-8?B?YXM0V0RLMHdaYUZpYm41YVFWWUkrSjlnVytaM0RoNlhsNk03Tjd4MTZVRjNU?=
 =?utf-8?B?SGovemF5dzhlWkxvSkgvZFlnVDFOWnVBR2poTi9JY3paNFJtam5vaHFqTkw4?=
 =?utf-8?B?dzhuUmR2MGRrOEVIQ0lPTWozaHptSDd5a0NIQWtqZE5GMk5oVWt2d2c1TXJ3?=
 =?utf-8?B?UENBa3JUcXYvd09Qb0xnTVNiVGR0SEZGOHRYZURXcjlxQjFVaDU1WXZqdXpr?=
 =?utf-8?B?Mm1hdXNSamR0TWk4UEdmLzhjUDBURWRYRzRHTThrNERHamNRVUszTEV5NzVM?=
 =?utf-8?B?VVZ4TXU4cmVWSWRxVkQwR2xXOXlTWlJ6ajJkYXlBVitBNnNqTEFvTGxDQjYw?=
 =?utf-8?B?Y044aGFKSlRYR1o1UTdHRkw1M2xqS3M5MkRjTGloL1Y3bFZ0eUp3TVpXZkpt?=
 =?utf-8?B?R3RzRmdpbGNXaGpOTEs4dFljeXJUZUF5QlFSUE1nMmJnbzBFMVdtTW9VTVJF?=
 =?utf-8?B?eEtkWWdyS2IxSytDbHJNOTQzWHBvL1FmdkNUOGNJL1RWei81eS8xRUY0ZktU?=
 =?utf-8?Q?Xb1i65iRVy53B5spSis78FCTm/P6Nbu2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU5sUkc4WTJ3YXZoTnBzKzVGcStSNUR3bEI3TXgveU45aFVnUDliSU11Znl5?=
 =?utf-8?B?VjJ0U3JQQWNna1VwMVl3WFJkR2hJcDl5QTdzOG9XTDQ4Q2xSVnkxYm02VVU5?=
 =?utf-8?B?MFc5T3pKZ1VGaUtBeEVUZm4vejlGRVlBNDd6eUxMcUM3R0k3TklyYW5Dc1Zr?=
 =?utf-8?B?L0RXWUFUaUd2ZmU3b0xENWE4TUZUQ01kc3hvaEVIakVOV0VVaWdyY0JWTVhM?=
 =?utf-8?B?ODZIa1lyMG54ZnlYcG5GSytpbVYvRVhzVGZ1UEFkUHpCYUJqS1ozRTl4aE90?=
 =?utf-8?B?NU1mZk1BY1ZXdk9vVmZyeEU3ZG5mK3o5SEp6QkdDWXZGT0s0d05JZCtzYzZp?=
 =?utf-8?B?bk9aUHlzRk1LYUF0cUZKeGg1SERMcU5TZ0ZkcEtPcCtIVS9rNStIdHFWREF2?=
 =?utf-8?B?SDg0anhaMThvL0JVTTFRMGVBbVRnS0tRWHc4S3UyKzNGY1E5N3ZvckViWExV?=
 =?utf-8?B?SmVBVFRsVERpK3ArMkw1WENMYnB0cXZ3eVpPekxZQ3BDaVp4eHdXRys5cUF3?=
 =?utf-8?B?RHM4NEEzUzdRaWkvZ0Vnc2xvTXp2QktGTU1kUDlmM0h4TFFmOVk1N1AxdE1u?=
 =?utf-8?B?aUFUK0FXbld4TkI5VU9QWHVDK2N6dTRtYmhnd1h5aGpuY2xhb3R3OVpyU3Nj?=
 =?utf-8?B?YkYxYU1lYno5ejlMM0paaG11SkcwOVpuMHBlTzVwY051V0NXV2VoaVJNNFJ2?=
 =?utf-8?B?RGdZYUozbU1SclpJQ1VQM3lPd01YWURnY1ZyTmljR3VRZXpJbG4yUXZFT1BU?=
 =?utf-8?B?Y1k5QTJKU1FTenRsYWtEK0d1cU9HMEN2eC9rNUFrOW9uYjM0bnZaSnFaWllp?=
 =?utf-8?B?cTNWUktCUEg0K0xjQ00wWCtZN1NkeFhBQWxEU1dNVnI1ME02YWErcHZEbldm?=
 =?utf-8?B?Q3dNRHJTOHpJR1JIellBdG11NGw3THB2bzA2SGxkZWs3QnZBL3oyNDBTdUs4?=
 =?utf-8?B?S2xTWVIyVE9yTS81d2dPdU9rQUNqYWVSMlYzeWlBUnliTXVxTEJ6V25ma2lQ?=
 =?utf-8?B?dmUwV2o1OWp3ajNmS1N1eWhkZlVVdTljL3RtWVo0ZFF2dGpEVWpCTWl3cDhP?=
 =?utf-8?B?cVZSZWlvRndORmdENW9saTR6Mm81dk92VEZNekwxRlJwU3R1N2Z6M2N0bWxQ?=
 =?utf-8?B?bkJCMGEzUFhTVVo1ZjZ3ZWtSVk9yNU8yN2YyYnBwR1Y4Z1hucVNmcTZySkpk?=
 =?utf-8?B?NzlZMUNTdnVORmVPK0N4M0RvaUx3bTFVcjV5eHpETVpiTWZrN3dYY3Nndzlo?=
 =?utf-8?B?amVBVThJMlZnNDBIcFBjR2xubGdRTEhURTFXNGtvZjJNWVdSMFd6c1pCSE5W?=
 =?utf-8?B?U3NtOWZFL2pibEVXNjJ5YUQvb3hvWWJFTUVQOFlBU2I4UVlxRjV3MFhDOWVa?=
 =?utf-8?B?V2RRTDZUSHZVVDdpYmtHWTN4cXRLZzRXS3kwRWxlSGlrcmpRZWQxNkpPVEg5?=
 =?utf-8?B?UzZCYWpvbE5aR0RzREd5MXRyZDIxaWtmSkJtZVRtRXROWjlOK1NjODZoZWdy?=
 =?utf-8?B?VmpJMXNjUXRPS3E5YnZNdG8rSEZmUFR5aC91dVV6NlQvdGNuaHBXWXV6SWNG?=
 =?utf-8?B?bjNCOEtrR0ZjVWJZdk5hOFhpUHkzZHRha0FoNnQ3WllZNmNOUklQNE41Ymxo?=
 =?utf-8?B?QTduZThXVUZnSVYvL0ZwSDRVNXIxNWVSSENFWWV4dzBQdk0vejZHZHhxRTli?=
 =?utf-8?B?WlFTcStBamdVSFdsc0xuUGUySThRakJxWlRzVDJ5OUJKQ01BdWlPWDdoWW0v?=
 =?utf-8?B?L0JrVXB6MW5UY0V3amRQc05GSG5YWVVoRXNmdERYZXJnM1VRZzd4NWFWTmZT?=
 =?utf-8?B?NUZYSDk4bFZqd0dxZ1AzU3ZRV0g1Zmd4NlYxRm1mMzhiTDFGOHp6Z1Q4QTBB?=
 =?utf-8?B?bzJoTDkzOURqOG9VNjYyTC95RkNtK3I2RWpTMXhKL0U5RGRWV0VudVVvMEJj?=
 =?utf-8?B?Y3MydENPRTdyVzZFa05CQ2tNZmhjdmlYZ2dOaVozbHg5VG93YzN0eURwaDQ4?=
 =?utf-8?B?OUQ4ZWpqTjdHc29MNXlscmcxQitFUCthWlkzTEVoNDJhM1QvblRNMHVoamxw?=
 =?utf-8?B?ZFMvL2VveDhPY1dFSzBrYVFWYlVBVDJod0tSL0lEcW9La0pxNVIxQkFOSmtU?=
 =?utf-8?B?V1NneTh1WEpqTGt2cUczRFBISFZ1NTY2ZlZpTVRaVmlHRzYyamN6dExCb0Ns?=
 =?utf-8?B?bWc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85742e99-db2e-42e5-86ab-08de00b7fd54
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:56.6004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rceUeM4j9M5V72v5SqzlZDJJ/p2nBShisQS4ukKZ3Xq7wk/3Xe8XCxPwsQW19yxL7cw1mrORD1ZpNXCSpcYfrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9798180010
X-Stat-Signature: bskgopcu1ycksyk7yqmy9s5nu8cxxjsj
X-HE-Tag: 1759302101-707164
X-HE-Meta: U2FsdGVkX195iqPrC4+mSjYcxXByBKdly3+iOZ1dU/GviWxhaVnCkv4V5aIzK5uLjj19SuKAgonbgMLRVivfEPU6LIhs8vRaAkgqwbhh8BM2MY4B7Usv3chXJujx5F/cKiTtqrgE04707eERW6PnT/U0s81RGtAsVXlafX22snaNEX4nbt1m08e704FLACw6PcAMdnpKlsd7qXnEO9l8YEPcnGx3eLGROOdlo38GSoppX/BCLklXgLgqUkg2Ay2Nv6+TF2Yxz0ADJfJr9W8/xlU5OWgwoSWxLB+B6PnmYLSpzAcZyvdZPk+lArsoJd6Yn48D9Hzgag7ByDxUW/TrIcC0YbTxFvmGxaDqcrmTQNTnHyU1AAAxC3o1xTaoZ442sFNpXOxiZbByU4M532OgInWZ1/I+xyeaYcewHU+Iyi93oSP5tPsnTwHuq9KiLzUxY0ytaBQYfnnKOz5GaIr5bdETmFyeK1tQMen4vACxf9ez4JotnYIVjIg+qX9iMf9mEPtLI50ZsHPqAp6503T45dzgmKzEpMA92Md5muXtNAB1ThnXfI5vNx9k3+XJiCFrZG2W92osXPNv5lyTBiX5I/6cLm3Z9MT5NXzyT8SDpXGgeNha2DMqSjAsHgK7vTycBtq5Burr93mzowIyC7pPghWcuKCahJwWSAZpXK+CPldNFtZ5TRKHGiGae7a6rpJglmEirFzvlr1AA7pNGDiycQNrVY0Ok8vXxUdfUrCN4BtwfVSOQBJ8/f1qvd4xZfcibvir1Z1OgPWjsbb/IhD3nx6I4LXJVTz/b6fwvwHULYHHCFdw23TIc2Lpk9JBMCTYqacKfXnv1l+71ZvABFMucgmQWCxy3cVYmsPFNG9mTwxY06mwCsNDEssFi2fH6tmxwQ8TZeShFWPPV9/HfnnrmLZJiQuBhhe5O3awhGG6Lj/bO1Tycm1vOhHakhmyWMUSFMyL9P01CGbj12DXB17
 T9gY+NjA
 X0Xm3QEe1Gf4IQH5b7wMxqYAq2wfjmBNPKGQowDmg//ofnOg6zzIBjVlV4BMF1JhZGssrd4tcZT5JzWfJ4TH2+ub6n3OOk0c4Ckwk208RSXbcM85jABlqe8YPmPtZ/bxLVLA5zKB8MKnoDcngICAhjyL4LRgr7euNKSGvpzCtTudI/ba7TUXdDcCmwuYE+vfSs3sZOcd8HMjue/ko6ycMA5kvU4sw3FsIy//QQVzH8A+9YAonXlrNX8dvLRjJhiywOjRF26vJVv24q/55f7HvQcN2w0U0+kQ3V/jEeUhAGaYbZdzA3WWQnd+I0Mn/VpnkLFACjCZMK9jgzRapAAY6yZub6GGQZ5RQ1fVE7F0vtEZxj8HS9TtZCgndCD8ZnaPTIT/V2nSyroPAPRqxaZ2AfaqxjlgiuvzQ1XANskLq3vdbjRKqWbT+DeMI7irD5BtLb1ghfKuX3cgehhnc9fKEXlF+B85v/JOyB6dLftgTM2s/f9oeIQ/fKGAzm5A2JN5MIBP24S49pSRbbDQ8qrAdAsTdodP438EQ+DvwvX1iSnlu+P2sSvtKV+mQ4DFlH/w5GLJ6HG4URZIX827ms8Hj8+s/FhcZY3PIgOX8v0tYrms8uVxNB3DrcqiLJJ2a2e3fzqjnCsWMes+kIL7+I4UAZVNgTmcIHHI5YxjcAgV5MAVvnJV7aZTDpPJQv3Y5/lhcKIcvk8OG+YAzJOei9kCmK91BB3XAxqs/6luhKt7ZPXiHusjTyqU8O2m3cBPZx1AoBpMn1IMw/0I/wr7L+J7LHY1kPQUOvrm7+PB0aNlnfQTrmvQjIAcVfS/LIjxLpZm44THi039PCZbYibr0iboRPPM7Bi/01QaCCxd29d3i6KVU5N9usTxkom2EClw+BW8uAfjVhj9YaV7G0V+IwS/ASuSRH/jfC45Zm/TS3UK0d9Norpn/DL5+ZQH/X5UvH4sPbHFnoGw0bM0/YgtZkECHN1Fp4NL1
 ScX9K0mu
 wNXUlkQz/qTIuv4QFAMgC4tzelYwk07SRbi7cLs4N2BPzWgzkXo7SU968LdHc2yG2+2mR1w9Wcrw8IwDhItkDbJIeOpI6MsgwYLKJdecm7mIBj8CcmiX0wn1nVCMGtt7Ba+9/0XCtDpfsO8020b0zvmMrz7HFJE8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Add partial unmap test case which munmaps memory while in the device.

Add tests exercising mremap on faulted-in memory (CPU and GPU) at
various offsets and verify correctness.

Update anon_write_child to read device memory after fork verifying
this flow works in the kernel.

Both THP and non-THP cases are updated.
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
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 312 ++++++++++++++++++++-----
 1 file changed, 252 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 339a90183930..dedc1049bd4d 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -50,6 +50,8 @@ enum {
 	HMM_COHERENCE_DEVICE_TWO,
 };
 
+#define ONEKB		(1 << 10)
+#define ONEMEG		(1 << 20)
 #define TWOMEG		(1 << 21)
 #define HMM_BUFFER_SIZE (1024 << 12)
 #define HMM_PATH_MAX    64
@@ -525,6 +527,8 @@ TEST_F(hmm, anon_write_prot)
 /*
  * Check that a device writing an anonymous private mapping
  * will copy-on-write if a child process inherits the mapping.
+ *
+ * Also verifies after fork() memory the device can be read by child.
  */
 TEST_F(hmm, anon_write_child)
 {
@@ -532,72 +536,101 @@ TEST_F(hmm, anon_write_child)
 	unsigned long npages;
 	unsigned long size;
 	unsigned long i;
+	void *old_ptr;
+	void *map;
 	int *ptr;
 	pid_t pid;
 	int child_fd;
-	int ret;
-
-	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
-	ASSERT_NE(npages, 0);
-	size = npages << self->page_shift;
-
-	buffer = malloc(sizeof(*buffer));
-	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
-	/* Initialize buffer->ptr so we can tell if it is written. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ptr[i] = i;
+	int ret, use_thp, migrate;
+
+	for (migrate = 0; migrate < 2; ++migrate) {
+		for (use_thp = 0; use_thp < 2; ++use_thp) {
+			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
+				       self->page_size) >> self->page_shift;
+			ASSERT_NE(npages, 0);
+			size = npages << self->page_shift;
+
+			buffer = malloc(sizeof(*buffer));
+			ASSERT_NE(buffer, NULL);
+
+			buffer->fd = -1;
+			buffer->size = size * 2;
+			buffer->mirror = malloc(size);
+			ASSERT_NE(buffer->mirror, NULL);
+
+			buffer->ptr = mmap(NULL, size * 2,
+					   PROT_READ | PROT_WRITE,
+					   MAP_PRIVATE | MAP_ANONYMOUS,
+					   buffer->fd, 0);
+			ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+			old_ptr = buffer->ptr;
+			if (use_thp) {
+				map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+				ret = madvise(map, size, MADV_HUGEPAGE);
+				ASSERT_EQ(ret, 0);
+				buffer->ptr = map;
+			}
+
+			/* Initialize buffer->ptr so we can tell if it is written. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ptr[i] = i;
+
+			/* Initialize data that the device will write to buffer->ptr. */
+			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+				ptr[i] = -i;
+
+			if (migrate) {
+				ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+				ASSERT_EQ(ret, 0);
+				ASSERT_EQ(buffer->cpages, npages);
+
+			}
+
+			pid = fork();
+			if (pid == -1)
+				ASSERT_EQ(pid, 0);
+			if (pid != 0) {
+				waitpid(pid, &ret, 0);
+				ASSERT_EQ(WIFEXITED(ret), 1);
+
+				/* Check that the parent's buffer did not change. */
+				for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], i);
+
+				buffer->ptr = old_ptr;
+				hmm_buffer_free(buffer);
+				continue;
+			}
+
+			/* Check that we see the parent's values. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ASSERT_EQ(ptr[i], i);
+			if (!migrate) {
+				for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], -i);
+			}
+
+			/* The child process needs its own mirror to its own mm. */
+			child_fd = hmm_open(0);
+			ASSERT_GE(child_fd, 0);
+
+			/* Simulate a device writing system memory. */
+			ret = hmm_dmirror_cmd(child_fd, HMM_DMIRROR_WRITE, buffer, npages);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(buffer->cpages, npages);
+			ASSERT_EQ(buffer->faults, 1);
 
-	/* Initialize data that the device will write to buffer->ptr. */
-	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
-		ptr[i] = -i;
+			/* Check what the device wrote. */
+			if (!migrate) {
+				for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], -i);
+			}
 
-	pid = fork();
-	if (pid == -1)
-		ASSERT_EQ(pid, 0);
-	if (pid != 0) {
-		waitpid(pid, &ret, 0);
-		ASSERT_EQ(WIFEXITED(ret), 1);
-
-		/* Check that the parent's buffer did not change. */
-		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-			ASSERT_EQ(ptr[i], i);
-		return;
+			close(child_fd);
+			exit(0);
+		}
 	}
-
-	/* Check that we see the parent's values. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], i);
-	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], -i);
-
-	/* The child process needs its own mirror to its own mm. */
-	child_fd = hmm_open(0);
-	ASSERT_GE(child_fd, 0);
-
-	/* Simulate a device writing system memory. */
-	ret = hmm_dmirror_cmd(child_fd, HMM_DMIRROR_WRITE, buffer, npages);
-	ASSERT_EQ(ret, 0);
-	ASSERT_EQ(buffer->cpages, npages);
-	ASSERT_EQ(buffer->faults, 1);
-
-	/* Check what the device wrote. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], -i);
-
-	close(child_fd);
-	exit(0);
 }
 
 /*
@@ -2289,6 +2322,165 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	hmm_buffer_free(buffer);
 }
 
+/*
+ * Migrate memory and fault back to sysmem after partially unmapping.
+ */
+TEST_F(hmm, migrate_partial_unmap_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size = TWOMEG;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret, j, use_thp;
+	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	for (use_thp = 0; use_thp < 2; ++use_thp) {
+		for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
+			buffer = malloc(sizeof(*buffer));
+			ASSERT_NE(buffer, NULL);
+
+			buffer->fd = -1;
+			buffer->size = 2 * size;
+			buffer->mirror = malloc(size);
+			ASSERT_NE(buffer->mirror, NULL);
+			memset(buffer->mirror, 0xFF, size);
+
+			buffer->ptr = mmap(NULL, 2 * size,
+					   PROT_READ | PROT_WRITE,
+					   MAP_PRIVATE | MAP_ANONYMOUS,
+					   buffer->fd, 0);
+			ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+			npages = size >> self->page_shift;
+			map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+			if (use_thp)
+				ret = madvise(map, size, MADV_HUGEPAGE);
+			else
+				ret = madvise(map, size, MADV_NOHUGEPAGE);
+			ASSERT_EQ(ret, 0);
+			old_ptr = buffer->ptr;
+			buffer->ptr = map;
+
+			/* Initialize buffer in system memory. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ptr[i] = i;
+
+			/* Migrate memory to device. */
+			ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(buffer->cpages, npages);
+
+			/* Check what the device read. */
+			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+				ASSERT_EQ(ptr[i], i);
+
+			munmap(buffer->ptr + offsets[j], ONEMEG);
+
+			/* Fault pages back to system memory and check them. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				if (i * sizeof(int) < offsets[j] ||
+				    i * sizeof(int) >= offsets[j] + ONEMEG)
+					ASSERT_EQ(ptr[i], i);
+
+			buffer->ptr = old_ptr;
+			hmm_buffer_free(buffer);
+		}
+	}
+}
+
+TEST_F(hmm, migrate_remap_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size = TWOMEG;
+	unsigned long i;
+	void *old_ptr, *new_ptr = NULL;
+	void *map;
+	int *ptr;
+	int ret, j, use_thp, dont_unmap, before;
+	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	for (before = 0; before < 2; ++before) {
+		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
+			for (use_thp = 0; use_thp < 2; ++use_thp) {
+				for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
+					int flags = MREMAP_MAYMOVE | MREMAP_FIXED;
+
+					if (dont_unmap)
+						flags |= MREMAP_DONTUNMAP;
+
+					buffer = malloc(sizeof(*buffer));
+					ASSERT_NE(buffer, NULL);
+
+					buffer->fd = -1;
+					buffer->size = 8 * size;
+					buffer->mirror = malloc(size);
+					ASSERT_NE(buffer->mirror, NULL);
+					memset(buffer->mirror, 0xFF, size);
+
+					buffer->ptr = mmap(NULL, buffer->size,
+							   PROT_READ | PROT_WRITE,
+							   MAP_PRIVATE | MAP_ANONYMOUS,
+							   buffer->fd, 0);
+					ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+					npages = size >> self->page_shift;
+					map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+					if (use_thp)
+						ret = madvise(map, size, MADV_HUGEPAGE);
+					else
+						ret = madvise(map, size, MADV_NOHUGEPAGE);
+					ASSERT_EQ(ret, 0);
+					old_ptr = buffer->ptr;
+					munmap(map + size, size * 2);
+					buffer->ptr = map;
+
+					/* Initialize buffer in system memory. */
+					for (i = 0, ptr = buffer->ptr;
+					     i < size / sizeof(*ptr); ++i)
+						ptr[i] = i;
+
+					if (before) {
+						new_ptr = mremap((void *)map, size, size, flags,
+								 map + size + offsets[j]);
+						ASSERT_NE(new_ptr, MAP_FAILED);
+						buffer->ptr = new_ptr;
+					}
+
+					/* Migrate memory to device. */
+					ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+					ASSERT_EQ(ret, 0);
+					ASSERT_EQ(buffer->cpages, npages);
+
+					/* Check what the device read. */
+					for (i = 0, ptr = buffer->mirror;
+					     i < size / sizeof(*ptr); ++i)
+						ASSERT_EQ(ptr[i], i);
+
+					if (!before) {
+						new_ptr = mremap((void *)map, size, size, flags,
+								 map + size + offsets[j]);
+						ASSERT_NE(new_ptr, MAP_FAILED);
+						buffer->ptr = new_ptr;
+					}
+
+					/* Fault pages back to system memory and check them. */
+					for (i = 0, ptr = buffer->ptr;
+					     i < size / sizeof(*ptr); ++i)
+						ASSERT_EQ(ptr[i], i);
+
+					munmap(new_ptr, size);
+					buffer->ptr = old_ptr;
+					hmm_buffer_free(buffer);
+				}
+			}
+		}
+	}
+}
+
 /*
  * Migrate private anonymous huge page with allocation errors.
  */
-- 
2.51.0


