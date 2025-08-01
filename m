Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED81DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8086B007B; Fri,  1 Aug 2025 08:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758E86B0088; Fri,  1 Aug 2025 08:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9466B008A; Fri,  1 Aug 2025 08:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8156B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:28:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC8231407F5
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:28:15 +0000 (UTC)
X-FDA: 83728116150.28.970028B
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id B84BE1A0004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:28:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qc3ULY0P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754051293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seVszCZ3zaz36k3fSbHN3tim29JTMBroBe6oSJ7Hs2Q=;
	b=pUc67IHH0ESPQ9BNWUnJTGbRlZBvY6GBl6I/7dDzT7SBk7YgN/q3QeBQ42jEBcusnmT4I0
	fWpsleBZOzZRFU/f3LRu131Lf1VmQzwopSZib9aa+IlkWoR6v+MFuuTDdQqgNvYGYFFq7p
	z0QV0dP/seo+lbFwz8ar+Usbw36A7FY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754051293; a=rsa-sha256;
	cv=pass;
	b=ShuecrlG7BXjgoAgkbrCodzTpbHLd1gHMZPhcAcmlM6sq/jlJD43lieRv8DFPvtU8arfYF
	r859J7PiqyK+ILY0bjUJiP0xFRrXFbV8s9MT1qCyRYORkY7UVZZYAGRBXcJq/18QzXLo9V
	OIJXuli3d7jP7rUqCN3RoRr37OzKAyI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qc3ULY0P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I29iYZhOtUEEr0XNAaSB9XYsGGd3lDxUtWQkzIOLOjkQ9wL246Kd8DvPsAzjMYfD3TO5HMKiJFaP7EuANz/la6OrAUOxpvYT29/IoYUxpwh+WTEQ7J9d2Ld4rZJSPHwjpyeYFjVpWIGe3xNEgN69JyXJ9lvigyf0MlfrN5a64hosPbFGbAl+AsvX1xGLa+VciiWyPGpO8fwQLPRVca82jx0F5lEch4COH5LmW/Ny06qdTCQnHOTNFh4Er1gFrxAe/lNNB1d1D0qs72cd0QwJUmlm9iBiNHy0TQp2XrsRmrCPSrUXhQgTu7U4lx5b23Fs85uR19UnmtNIrhFl4EGPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seVszCZ3zaz36k3fSbHN3tim29JTMBroBe6oSJ7Hs2Q=;
 b=T0wfojC9ryKahH2/gAEz8JwMasu6mDxhnpx+kGVjLLvICKgn1kiXQDNG7oP/5lupUc7l5k5E2vN7CBtTtRo3srj2zxK03M+JYcWoirPBSXu1w+l8vE2uRAci4nj4ehu9a8dbGS8As2pWMJpEsfZBZdFZZxhr4gk6WQnHgxWAKiTpisho8QCblbehj0wd5LkOOJkz6v3Q372Jk1/Jef/hmHZSiE3kwGd3VudCGY9OuBSfSZ9iU0ur64mbI0ZQg55U2UAKL0VSC9lwwEVGAgsQCaPFi248xy4KNVo8Cz3PQN7jAwsoqHbX4YgYEjzmXlZu/dwaXlXL/yZYZSMm5icjhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seVszCZ3zaz36k3fSbHN3tim29JTMBroBe6oSJ7Hs2Q=;
 b=qc3ULY0PTQwBoxxm1QltXH3hsmotDqRjiTy3hzoeEbqkFtSFhKpVdYEwy7/VhfFC/UF8hwz5WFimew6YGFBhfHmPVyAiOJc073DxYtpxHsyVYP9eeLUIDQiyJvDD3PIp2WO72jYOvOsGHDKa2DI46qc5MxYhqmnERMuZdEMcehMFVyXBGMRU0qIlmOpZ6hn5lZrslgxiqI7DcILlmf5qsMM83eR8ShpFaDC8tFgB3ea8aKyBzs0fTQ/7pEAkUjN0fykDFSSf0Nxkz4j5qpiDh0ehW3O0seeaOsE5y88NaAGgX4qbFWVEfgpq6rUda5hMu/4M/rzvQ6H6VzOFSQ3Www==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4033.namprd12.prod.outlook.com (2603:10b6:a03:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Fri, 1 Aug
 2025 12:28:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.015; Fri, 1 Aug 2025
 12:28:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Fri, 01 Aug 2025 08:28:01 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
In-Reply-To: <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e62fc2c-8055-40bf-d9f6-08ddd0f6dec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnZrRWFKN1JqK1dPRjlnTU5vNDR4cnI3a3daVytvL0s4SWdCVWx1THN6S0Yw?=
 =?utf-8?B?OWZhUGpoU3BzdnlJcXhDTlV5ais3dkRQeS9KSENCOUZNZDFmS1hleTk0bThG?=
 =?utf-8?B?SkExdS9nUnlDY3h4NDM4SlB0c3BmU1dsRXFWa3BtQ3J0MlU4WTlWM0ZiYUc1?=
 =?utf-8?B?cFJqTXRaNENtaU1HdUJwSUw1M25Ucmp3Skk3dWg2cE9TdGlCL2NobTArZGl3?=
 =?utf-8?B?TUw1TkVJRFFJNUpidWtKNEg3THMxcHZjVUUrZFZEUU43RlQwak55SHBPRkMy?=
 =?utf-8?B?UlZIUUpOcVRmckdlQUdnUEtZenhlaHE2bjRPRVRHM0F5a1ZZWjJkbjdsd05J?=
 =?utf-8?B?OEN1Vnh4VGxCNUc4VzNEaFJUbngrSFhPeHNXQkJhRTQrYmV6NUF4NTNNY2x3?=
 =?utf-8?B?L2t3Z2I5NjBPOFQxOElTRmx0andla01ldTdGbHNuaUp6WDdYUWgweXdua05u?=
 =?utf-8?B?bE0yOUhRYjBmMDZwOHJMQklYakJDV01NVVk0RU5iT29PQUl0UUNUalZIZHpO?=
 =?utf-8?B?Q05nYlQvdG5KZDBIT01TNzZGdVZNcWxEOHJ2ckdzQ3JmUFFVanZQak55dml2?=
 =?utf-8?B?d1hBQ3pUaVdLVUNGa00vMXRQWlUxeU5YUzBHeXZEemJWWk1XTjhTTWVPcWRp?=
 =?utf-8?B?VnhSR0FWNGUvV2pqSHFORWpDK2NGdTRraVUrTkRNUDh6WElQMXgvRGV4djM0?=
 =?utf-8?B?S0thQ2hQcHFBTHlXRFlXeFRJTG1GTnkra1FzNy9RVEcxSGdlU3VVcEI4eDd5?=
 =?utf-8?B?c2lqenhKQ2FQdFA2UmpEcEFmZGVGUS9CV0Vjck5rWExPS1BqL2RzNGxVek1R?=
 =?utf-8?B?TjRsQ2VnSTJBV0kwWExpV0lmbjQrbGNiZFFpUitoU28rdkdRaHd1aHFDWktu?=
 =?utf-8?B?OFdEQmI3ZEU5R0pJQWd1MFRSRVIrUlNFQ3Bqd2dialZJQ1FEUUxqSnNjdHQz?=
 =?utf-8?B?M0NQLzllOWFqRmtYVit0WkU2NFJZcldyUHBrK1lieTdYYmVlbXhvZ0w1TG1T?=
 =?utf-8?B?aXNucThoTG54V2V5Y0ZIOWVwV0w4azlONC9nakx5ZmRrb25aVE9oc1NSak9H?=
 =?utf-8?B?dWkwYjQrT0NyYnZTWmFTZktMcThUUFlpUmtDWlhwbXJrU2s5UzdyNENWSlBO?=
 =?utf-8?B?SGNmcHA5ODhFYitJN2xYQTNWa3ZCWWo5Q3ZJREswdGNIWWVNV1ZOMVM4bi85?=
 =?utf-8?B?TlNTMzM1ZkZOQlZWTHdBQjBSWDlqNlFmeklZc2pXYjRVNnpUR0Z5R0d2S0ZG?=
 =?utf-8?B?Mk42aFk2TE85K0pISVhVVG45cVYyY0Eya3hMSjRPeGhWZzYydktIRmY5SVNW?=
 =?utf-8?B?V2hlZHJHMmhDNng0S1phU1JoY0F6aExpc29SYTAyZ2I2SGxIc3Z6WnZkQStq?=
 =?utf-8?B?dXVrdUpVa0VwQTJLNzZyVnpRaUxKaUdnejVqb2d1dXFJZ0ZOaWc1NXJpSG1i?=
 =?utf-8?B?Wmw1a3FpK3oxeXkyZ0FHcG5hTjdocTJ2SnE2VkFiMFFpNmJLSjFMY3VkZDJv?=
 =?utf-8?B?VzRndDJHNFVtdnY4TFF5R2RDUnBkWVpCNzFJaklTeFhlNFVEcmpMRzY3TmRQ?=
 =?utf-8?B?YkJrRlkwRXoyMlM1Z01JOGlDaExzdXBSSWVxUyswLzRSem1HbEtDaSt6bFNr?=
 =?utf-8?B?cVYzc2xUbW9oSGwxeTNvb0Zvczd1UEZhbkQ2NVBINER2UXA3MUNreUZRdWlu?=
 =?utf-8?B?dSt4ODJsNVhFNXhHMngxWmoyYml0Y2YwRHRhYnExTWZTMUVSWjVCN2hlVGxI?=
 =?utf-8?B?dTZaK2o5ZE5RMUdBcVFyYVJzOURBVWl2Wm80R3o2akpzWThzb1FEQ0p1OUJt?=
 =?utf-8?B?TWdQR0lIQ2xNL3JRTzc4OXh2dFNLZEJYcjVldmZPRHBtdDFGYTlaU3Q3d20v?=
 =?utf-8?B?WmtOaUpiNUZYOFF1aVRwQWMwWmh4ZWxYcDFPTGFXNmZpZVQxK3ZGR0JxVlZp?=
 =?utf-8?Q?ZfV164SBX2g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YktBblVTSndUQmdDbE5BemFicXRHT2FTNW4waU8yclBBeWRTUGdQNWNzOFI4?=
 =?utf-8?B?emhjcDFxTm1iUGF0aDc5TmR5TzJvRFNsaFZpWVJEUVQ5QXgwcFMwTERDa2li?=
 =?utf-8?B?OEtvOFF5aVJmd2owK2llWUhGR29NYi9jMjZwZ0pPUzkvRmUxYmdxK25JZzh4?=
 =?utf-8?B?RFBqcUZiWSsreTlCNkZGTVhVVEhicWlCUjdDMVdCcTJENzhoNUtOa2NBbHBk?=
 =?utf-8?B?a3hMT1JGZU0ra29oMTZMQ1hvTzlGUktlMVFRWll5VU92WWFSMDVjL002aHJ5?=
 =?utf-8?B?dmpjNVpyc2ZRNkh4MUZYTVpBL25DdmdPNkZWQWlrVTl4dCt3eTVybWpIWlp6?=
 =?utf-8?B?cFY1QkRzRDhDbkJUcHk4Y2RWbnVFUTNPdWIrZVUzNnFGbjFkNEJVR0EvR3N3?=
 =?utf-8?B?bCtTSDVJc2VQTzd0bklPVmpIT0d6N0cwNjRhbGxKR1ZQVU5US1lIYnE1VjZK?=
 =?utf-8?B?SDhuUS9EMlhsR2NkV0xNRWR3d0RMYmk1d1pvR0dIMlVYS2tXbldQTnh1SDY3?=
 =?utf-8?B?ZDgwREtHelAyeXkzUTFucERicDJuTVRZbUpOWm5VL3R1dkc0Zi91UUZodHF0?=
 =?utf-8?B?RUhDRkw1VWJzSUtVY3o5ZHpPQm5WNmt1QlVmN3JBcXl2VWpwNy9RTzRnTXg3?=
 =?utf-8?B?alArLzcyOVVuWTY0L3FQdnpxSUYzbXFTdFM0NFJMaHl2dWhpajBjK1FNYTZL?=
 =?utf-8?B?eDRMZWhJYmxUb2hDUytsREs3NkVlVlRXN0FzenlLbm01T0hFWEhuekpaekpO?=
 =?utf-8?B?UzNQSldrT1JsT3hWVWhiSTJGM21SVFNXRUZlaS9FWFRMTGtTOVo4M0FqN1Vo?=
 =?utf-8?B?UWs2SmQ2Q2RWdmd2UHFQRUlxalFLN1RPS3lPT0dOK0lnL1pZM2p4RGptRGhr?=
 =?utf-8?B?UGJOb24zRGhWbDhOZmhWbEF1UXRDeTAwUjBqQzBYQzltbmtYT3N4YjBNUkgw?=
 =?utf-8?B?WCtzaXpxTW56VHgrWndGcExoRnpzMk9LZHRkeGRrNXVmdEd3SHd3aHl6L1E2?=
 =?utf-8?B?NlB6ZFNKR2JmZktLOUxqUkNvKy9KN29USlh1Mld3L2U0S3EzbExNemticWQ0?=
 =?utf-8?B?ejBuZGpPSHpyRGtlRCtRK28yc1NhdUExczdqU0dCemFIdWdVUTJYSVQvWmw3?=
 =?utf-8?B?N2FGSWprNEVicHJSRVprbE1VVnlFS3lKWnF0Z1NLWkdPTFh2TnFEb2NtdkFX?=
 =?utf-8?B?OWVrSmcyK2V6dzJPMW9nQnZJNnhTQmhnemVhWXlmY2lsOW80dk9SS0I2SjZv?=
 =?utf-8?B?MDBYVjFLZnVucjlkS0dacGNKTU1BWDNaWjlKcGtPS1JSQlR0cVM0SU5xSnBU?=
 =?utf-8?B?MTQvWTBSMVEvMDMzSmxpMTA5dVlZdG15MjhtblNTdFcyd2Facm9kOS9rSFB3?=
 =?utf-8?B?Q2dRUzdNY3llVTVaTGxiMFl2VnpmQ1JQd0crWC9OdWtNblhFSmNNZ3VkekxD?=
 =?utf-8?B?N0k5cVRSWitubjFtelBZZmNQMkFNTTVJaU5ZckwwRzlaUGtPbTNSYkJmQWFt?=
 =?utf-8?B?NDQxbDFGaUNQOGYrYTVnZ2ZCWXR4dmJiekszT1RoYk1jTXU3SitYd3BMWUF1?=
 =?utf-8?B?S01CK0hKU01NZE1VaVJIeXZ5cXVwbkkvUUJjZncycnpCVjJlaFpnZFNBRHd4?=
 =?utf-8?B?UFp1c083bW9NbnRYR1dhblhib1VvQm9GSXVFRFd3Y2VMT1E5WEVtZE9iZVVV?=
 =?utf-8?B?Tk5wNDNSdkpVRENYOUZqL052K1pTekdmLzdobmJNVndjZjVBRGN6UkhCbFNG?=
 =?utf-8?B?WTlRODVkemQ0SEM4RFFMTjViZytuU3VxRnMySGE0RXd2eWlZa3Yrd3ZrdU10?=
 =?utf-8?B?V1BHL2RnKzJJMldzNkNCUUNKeHJ0K1BIclpydUIvZnRSQ2dnUUVnQTBza2k5?=
 =?utf-8?B?YXNjaGpjNW5TVENwaU5TaVBPUkF2QmhKMWZ6a0RzUER6RWo5SjJldGxCQTJu?=
 =?utf-8?B?VFpUNG95QWpGRElSRWM5MlRVdmlWTHR3bElpVXBTbVByRTRvdGxlbzZQWitI?=
 =?utf-8?B?bXUxYmczM3dlKzhZNlNPS2FWa2E1WE9nVGZqYyszUWI2SDdvNlZPSzNMMzZt?=
 =?utf-8?B?YmFQR1R3amxoSjYyendTaFZ2dGtDeHZTVTliQzZCa3pSTCtjeW4xWHBmdmZ5?=
 =?utf-8?Q?uQrg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e62fc2c-8055-40bf-d9f6-08ddd0f6dec4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 12:28:07.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjhQgH5WJDe3UKQE7m3LBZy/9gxANgJ2TliBxZezts1PpKBwOnSLaxxroMMxGHhC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033
X-Rspamd-Queue-Id: B84BE1A0004
X-Stat-Signature: 3qbg8sk3qcqnhc6d4atg37p4wu93qs6q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754051292-597760
X-HE-Meta: U2FsdGVkX18KIg1pjNSESmLMcWyTypD/d0et1kMeQvSBkEh89OV5m2BQEoxzE3LZlGtTafqkf47KPUB3/y4KXipvB7dsETCgYKlIHGjDquT3fSmfqtenGuB7Jl41bVi6iaSjIHPH6wULrojcjQV06B7kuIDbCD3H2L4KitmjvFAekPSOP76Iy2g9ozWJjEG7V6YraYHX3AAgaQ9NdOja0YqS+xHlfOz79SiedBG3W7ob5twwcHLI2vTGGspx3BL8ysuirWUEqvJJ/u/rSgR+LbqZ3mN3ZeoypLiNsgHf37axL73mQDa239ty0wwMa+8lRbze+JYuKkyOn2Ddd7AMjA6mDhmbd4Zk7Z+BpIuCTASviemdlniKRFxJHLF0J4rgot+axo1LQHYXtls5Wt8tNmDSFQVy5l/6d1fADacpExQRmOzVlDyvqUmrSJJpChA4nGuqs/XCII0PQEI5+dccF1uUnFpvndTMLiULvFZDXn5B3fPrc200dFcv5Jz9ckO3sDwJiNo9dy34d/8ESwvp4jsun7yYBLgkBZvKner7Um1L56yxSj9/Zs2SfGrtcWnH05vSKVfeOrDML9Zk4L4P7/m+aRYHNBnD29XzAiQd+sfDEMdww/jBhpB7aKtwxE51UxqARB9SCpj+HJyKrqKzO4a3cKlqPSGitJHvdYsqnChXRvPZthBrr5L4LwkUrujM2wPsUE+rNppy1JJaeN/7JuijVX3Hu0MVP0bNb/W3kRk33bJ91Jt+iXNrW/1UboJB7aflOTWh4cCTZxNs7yA89Zkles7LNNBGCZuw5iBaCRSo6bFfc125FD6ZoQb6nAqLl1dWC1YVYgBrS+RTPZcpvDaEMniIoNmKhao+U56Z8H2BKmzKREC5H5eOUEem5WHbg3c5sr0K87gg7OD6yDiMV4Cp7sAJmkI14xGSk70c6TTj/XPXfR6azEit6cviOqpDPnrRx0VgJ0boxAiKzDq
 wJSMKtCM
 cgVfa9WSs5oeuNJ9cTZk+6WJA7G7tcZRQwG5/ew8RvDGflU2x1UeJiKd469uFhCq6ivbeAHg4kLsV1sXs6gXRi8ZbhCf4tL874zyU1RKNH6KKxsMYMzF59S+c/LF7H4k5e68i7zhYDBvTIsxAtp2s0qe2yRV/MyHtkHKemTSWCws+Vq7WX64ZXwJydmTSDMmzqMdJDnBOE2LNE29r5PnFWZ/l8A87mbTTStR/biiKOPBK3hfcLhafYe5MpyTXYiTgt+AMxSBDdnd3QK4IpxPEKI0NJEa+oCpRW9V/sNy7XWPkuTLPigvqyeus19ePasjI8fwlwxSwo6KgMIDo1q33Lxh6hezcq4rwwQiXMVuPM4MjrLhosh48U/rUrODyx/RrHT1+IEgub25HRE0zJrxEZqVFeJrxHg8vRhnhEwOSsFb4VMBVzC5YJuPqLBdt0DUh1JrFkuYYAzbXgW203Fum/FhLg0RCSU1t/8RBXI4yJIO6CjzrG6hHJo+GBHmjuKON2YZixkGEN7QnU7jm22HHQHSSze67vn9A9usFYGkSUEFM9PRw0IjeV3/rW0aKHIONb/uTSPjJhWnMyhQqXsT8lZdxy7MrxZh5XlKec98DdncfZcfuZlepsrfOhLcz1qK9TgnCsgM0CjYm7Kj/1AlO90fYz8jMgls+ujUml+2Dtwop83gGQfwizlFpEHQx9Ild751VO57KSVQ8QAV3GsaLlBBQGhvK3wEHAWV3NInRu/yXdygIyfrAYcYvFoW2CFX9ablpILWIxf2xRJLKjtJBhfE3uRw3vI7wlDX5FltWEETBROIpSgqAKv92gD8OZVOFu/oSsS2pnjuPAIs63DJ8FxMi5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Aug 2025, at 8:20, Mika Penttil=C3=A4 wrote:

> On 8/1/25 14:10, Zi Yan wrote:
>> On 1 Aug 2025, at 4:46, David Hildenbrand wrote:
>>
>>> On 01.08.25 10:01, Balbir Singh wrote:
>>>> On 8/1/25 17:04, David Hildenbrand wrote:
>>>>> On 01.08.25 06:44, Balbir Singh wrote:
>>>>>> On 8/1/25 11:16, Mika Penttil=C3=A4 wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 8/1/25 03:49, Balbir Singh wrote:
>>>>>>>
>>>>>>>> On 7/31/25 21:26, Zi Yan wrote:
>>>>>>>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>>>>>>>
>>>>>>>>>> On 30.07.25 18:29, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>>>>>>>> On 30 Jul 2025, at 11:40, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP p=
ages aware of zone
>>>>>>>>>>>>>>>>>>>>>> device pages. Although the code is designed to be ge=
neric when it comes
>>>>>>>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed=
 to work for THP
>>>>>>>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a =
zone device huge
>>>>>>>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and othe=
r code migration
>>>>>>>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_m=
apped_walk() will
>>>>>>>>>>>>>>>>>>>>>> return true for zone device private large folios onl=
y when
>>>>>>>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to preven=
t locations that are
>>>>>>>>>>>>>>>>>>>>>> not zone device private pages from having to add awa=
reness. The key
>>>>>>>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(=
). The other
>>>>>>>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/=
dirty bits, which is
>>>>>>>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harve=
sting.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entrie=
s, use
>>>>>>>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison =
as for zone device
>>>>>>>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go=
 through pmd split,
>>>>>>>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split=
 does not work if a
>>>>>>>>>>>>>>>>>>>>>> fault is encountered because fault handling involves=
 migration entries
>>>>>>>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are =
expected to be the
>>>>>>>>>>>>>>>>>>>>>> same there. This introduces the need to split the fo=
lio while handling
>>>>>>>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, bu=
t calling
>>>>>>>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split=
_unmapped_folio()
>>>>>>>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks=
 around
>>>>>>>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through=
 unmap and remap
>>>>>>>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.co=
m>
>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/huge_mm.h |=C2=A0=C2=A0 =
1 +
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/rmap.h=C2=A0=C2=A0=C2=A0=
 |=C2=A0=C2=A0 2 +
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 include/linux/swapops.h |=C2=A0 17 +++
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/huge_memory.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/page_vma_mapped.c=C2=A0=C2=A0=C2=A0=
 |=C2=A0 13 +-
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/pgtable-generic.c=C2=A0=C2=A0=C2=A0=
 |=C2=A0=C2=A0 6 +
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 mm/rmap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22 +++-
>>>>>>>>>>>>>>>>>>>>>>  =C2=A0=C2=A0 7 files changed, 278 insertions(+), 51=
 deletions(-)
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge d=
evice private folio into
>>>>>>>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by mi=
grate_device logic to
>>>>>>>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a refe=
rence via folio_get
>>>>>>>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct folio *end_folio =3D foli=
o_next(folio);
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct folio *new_folio;
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Split the folio now. In =
the case of device
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * private pages, this path=
 is executed when
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * the pmd is split and sin=
ce freeze is not true
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * it is likely the folio w=
ill be deferred_split.
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * With device private page=
s, deferred splits of
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * folios should be handled=
 here to prevent partial
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * unmaps from causing issu=
es later on in migration
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * and fault handling flows=
.
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>>>>>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 folio_ref_freeze(folio, 1 + foli=
o_expected_ref_count(folio));
>>>>>>>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped=
 afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the fol=
io is unmapped in
>>>>>>>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze()=
 is not aware of
>>>>>>>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>>>>>>>> Maybe we should make it aware of device private mapping=
? So that the
>>>>>>>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device p=
rivate mapping,
>>>>>>>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio=
, 4) unfreeze,
>>>>>>>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>>>>>>>> Ah ok this was about device private page obviously here,=
 nevermind..
>>>>>>>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths a=
nd folio is mapped to CPU page tables as a huge device page by one or more =
task?
>>>>>>>>>>>>>>>> The folio only has migration entries pointing to it. From =
CPU perspective,
>>>>>>>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split(=
) unmaps a to-be-split
>>>>>>>>>>>>>>>> folio by replacing existing page table entries with migrat=
ion entries
>>>>>>>>>>>>>>>> and after that the folio is regarded as =E2=80=9Cunmapped=
=E2=80=9D.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The migration entry is an invalid CPU page table entry, so=
 it is not a CPU
>>>>>>>>>>>>>>> split_device_private_folio() is called for device private e=
ntry, not migrate entry afaics.
>>>>>>>>>>>>>> Yes, but from CPU perspective, both device private entry and=
 migration entry
>>>>>>>>>>>>>> are invalid CPU page table entries, so the device private fo=
lio is =E2=80=9Cunmapped=E2=80=9D
>>>>>>>>>>>>>> at CPU side.
>>>>>>>>>>>>> Yes both are "swap entries" but there's difference, the devic=
e private ones contribute to mapcount and refcount.
>>>>>>>>>>>> Right. That confused me when I was talking to Balbir and looki=
ng at v1.
>>>>>>>>>>>> When a device private folio is processed in __folio_split(), B=
albir needed to
>>>>>>>>>>>> add code to skip CPU mapping handling code. Basically device p=
rivate folios are
>>>>>>>>>>>> CPU unmapped and device mapped.
>>>>>>>>>>>>
>>>>>>>>>>>> Here are my questions on device private folios:
>>>>>>>>>>>> 1. How is mapcount used for device private folios? Why is it n=
eeded from CPU
>>>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 perspective? Can it be stored in a d=
evice private specific data structure?
>>>>>>>>>>> Mostly like for normal folios, for instance rmap when doing mig=
rate. I think it would make
>>>>>>>>>>> common code more messy if not done that way but sure possible.
>>>>>>>>>>> And not consuming pfns (address space) at all would have benefi=
ts.
>>>>>>>>>>>
>>>>>>>>>>>> 2. When a device private folio is mapped on device, can someon=
e other than
>>>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 the device driver manipulate it assu=
ming core-mm just skips device private
>>>>>>>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 folios (barring the CPU access fault=
 handling)?
>>>>>>>>>>>>
>>>>>>>>>>>> Where I am going is that can device private folios be treated =
as unmapped folios
>>>>>>>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>>>>>>>
>>>>>>>>>>> Yes not present by CPU but mm has bookkeeping on them. The priv=
ate page has no content
>>>>>>>>>>> someone could change while in device, it's just pfn.
>>>>>>>>>> Just to clarify: a device-private entry, like a device-exclusive=
 entry, is a *page table mapping* tracked through the rmap -- even though t=
hey are not present page table entries.
>>>>>>>>>>
>>>>>>>>>> It would be better if they would be present page table entries t=
hat are PROT_NONE, but it's tricky to mark them as being "special" device-p=
rivate, device-exclusive etc. Maybe there are ways to do that in the future=
.
>>>>>>>>>>
>>>>>>>>>> Maybe device-private could just be PROT_NONE, because we can ide=
ntify the entry type based on the folio. device-exclusive is harder ...
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> So consider device-private entries just like PROT_NONE present p=
age table entries. Refcount and mapcount is adjusted accordingly by rmap fu=
nctions.
>>>>>>>>> Thanks for the clarification.
>>>>>>>>>
>>>>>>>>> So folio_mapcount() for device private folios should be treated t=
he same
>>>>>>>>> as normal folios, even if the corresponding PTEs are not accessib=
le from CPUs.
>>>>>>>>> Then I wonder if the device private large folio split should go t=
hrough
>>>>>>>>> __folio_split(), the same as normal folios: unmap, freeze, split,=
 unfreeze,
>>>>>>>>> remap. Otherwise, how can we prevent rmap changes during the spli=
t?
>>>>>>>>>
>>>>>>>> That is true in general, the special cases I mentioned are:
>>>>>>>>
>>>>>>>> 1. split during migration (where we the sizes on source/destinatio=
n do not
>>>>>>>>  =C2=A0=C2=A0=C2=A0 match) and so we need to split in the middle o=
f migration. The entries
>>>>>>>>  =C2=A0=C2=A0=C2=A0 there are already unmapped and hence the speci=
al handling
>>>>>>>> 2. Partial unmap case, where we need to split in the context of th=
e unmap
>>>>>>>>  =C2=A0=C2=A0=C2=A0 due to the isses mentioned in the patch. I exp=
anded the folio split code
>>>>>>>>  =C2=A0=C2=A0=C2=A0 for device private can be expanded into its ow=
n helper, which does not
>>>>>>>>  =C2=A0=C2=A0=C2=A0 need to do the xas/mapped/lru folio handling. =
During partial unmap the
>>>>>>>>  =C2=A0=C2=A0=C2=A0 original folio does get replaced by new anon r=
map ptes (split_huge_pmd_locked)
>>>>>>>>
>>>>>>>> For (2), I spent some time examining the implications of not unmap=
ping the
>>>>>>>> folios prior to split and in the partial unmap path, once we split=
 the PMD
>>>>>>>> the folios diverge. I did not run into any particular race either =
with the
>>>>>>>> tests.
>>>>>>> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_=
folio()
>>>>>>>
>>>>>>> 2) is a problem because folio is mapped. split_huge_pmd() can be re=
ached also from other than unmap path.
>>>>>>> It is vulnerable to races by rmap. And for instance this does not l=
ook right without checking:
>>>>>>>
>>>>>>>  =C2=A0=C2=A0=C2=A0 folio_ref_freeze(folio, 1 + folio_expected_ref_=
count(folio));
>>>>>>>
>>>>>> I can add checks to make sure that the call does succeed.
>>>>>>
>>>>>>> You mention 2) is needed because of some later problems in fault pa=
th after pmd split. Would it be
>>>>>>> possible to split the folio at fault time then?
>>>>>> So after the partial unmap, the folio ends up in a little strange si=
tuation, the folio is large,
>>>>>> but not mapped (since large_mapcount can be 0, after all the folio_r=
map_remove_ptes). Calling folio_split()
>>>>>> on partially unmapped fails because folio_get_anon_vma() fails due t=
o the folio_mapped() failures
>>>>>> related to folio_large_mapcount. There is also additional complexity=
 with ref counts and mapping.
>>>>> I think you mean "Calling folio_split() on a *fully* unmapped folio f=
ails ..."
>>>>>
>>>>> A partially mapped folio still has folio_mapcount() > 0 -> folio_mapp=
ed() =3D=3D true.
>>>>>
>>>> Looking into this again at my end
>>>>
>>>>>>
>>>>>>> Also, didn't quite follow what kind of lock recursion did you encou=
nter doing proper split_folio()
>>>>>>> instead?
>>>>>>>
>>>>>>>
>>>>>> Splitting during partial unmap causes recursive locking issues with =
anon_vma when invoked from
>>>>>> split_huge_pmd_locked() path.
>>>>> Yes, that's very complicated.
>>>>>
>>>> Yes and I want to avoid going down that path.
>>>>
>>>>>> Deferred splits do not work for device private pages, due to the
>>>>>> migration requirements for fault handling.
>>>>> Can you elaborate on that?
>>>>>
>>>> If a folio is under deferred_split() and is still pending a split. Whe=
n a fault is handled on a partially
>>>> mapped folio, the expectation is that as a part of fault handling duri=
ng migration, the code in migrate_folio_mapping()
>>>> assumes that the folio sizes are the same (via check for reference and=
 mapcount)
>>> If you hit a partially-mapped folio, instead of migrating, you would ac=
tually want to split and then migrate I assume.
>> Yes, that is exactly what migrate_pages() does. And if split fails, the =
migration
>> fails too. Device private folio probably should do the same thing, assum=
ing
>> splitting device private folio would always succeed.
>
> hmm afaics the normal folio_split wants to use RMP_USE_SHARED_ZEROPAGE wh=
en splitting and remapping
> device private pages, that can't work..

It is fine to exclude device private folio to use RMP_USE_SHARED_ZEROPAGE l=
ike:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..b97dfd3521a9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3858,7 +3858,7 @@ static int __folio_split(struct folio *folio, unsigne=
d int new_order,
        if (nr_shmem_dropped)
                shmem_uncharge(mapping->host, nr_shmem_dropped);

-       if (!ret && is_anon)
+       if (!ret && is_anon && !folio_is_device_private(folio))
                remap_flags =3D RMP_USE_SHARED_ZEROPAGE;
        remap_page(folio, 1 << order, remap_flags);

Or it can be done in remove_migration_pte().

Best Regards,
Yan, Zi

