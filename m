Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126CCC87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 10:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C246B007B; Sat,  2 Aug 2025 06:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9446F6B0089; Sat,  2 Aug 2025 06:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BFF6B008A; Sat,  2 Aug 2025 06:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4EA6B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 06:37:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E38BE80E5B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:37:58 +0000 (UTC)
X-FDA: 83731467036.16.21F277E
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF066A0008
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:37:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N4VvsISj;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754131076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtdMjt8DfLswmrapX3hflqxcaT6JR4lAozZvrT7ZCac=;
	b=6Ej1d4AZX76J8K8JSaeHCeONFbOUBuimfYGOAvRU+ODNgdc1WYmc2Xj2caHo6x07+KaErC
	mcbmrlbu5/X9FXIrNlugQ6aajHGPOa91TP+pbSG/ROmqNYpWMe5YsTuHBda1TODM+2SNT8
	Xmuoza0IBaYawQ4wn1w4QL016AjJjDU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N4VvsISj;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754131076; a=rsa-sha256;
	cv=pass;
	b=aNxBw2qTEtxknwwKM0Cng32Zn9T3WzGj7tLxb0C2kJEyVKbgsLZh9PdazJXtuQHdsNX7sV
	X8mLxxuR6apf4deiRsZqhM+jFr+YJEJV1XDzU+YdGfMvqngjCQcESbVgMNjUT9yaEPjiBY
	Ioi2QX+r+RFMeXAKfo2giIrGzdelhpg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIoiAeuMjwXnbMl6hl6aD4SlxobBjankgciz4YO0bEDzUqmFkKZ4bIIZtzeI4yRNuwO8vR4XS74ezvHzBkrKHLkTQXjaS3LU+JCSHJDHL4HooaVwVKpRmWfxhp6kflGX00dZ+KCAGxMMRn8l7crjWqU1bi/dSGjkbyBccRD0K+swlxiUvtUwf54e3xsIggewT1vhpU1EGNMd2dtZYJPMuYdlqFFQf6Z6R26YPqaTpdb2PdFUDZE2qAmjFUiLDJzb0s3gHcWS8J2nlE0+ZDTSHiYQjS1eOM1bPlrNoG6ZZxHU0Ie8Tsl1JoDHCv7v63lnengyUPxrp19IcDaLm3Qm7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TtdMjt8DfLswmrapX3hflqxcaT6JR4lAozZvrT7ZCac=;
 b=xa0Cd9Qi7BRePOpGlu2zLIrD6hntY2Bb/jMLxhZ0ZrIcORqh1VJ2CmAf333b8VYkW/zndMC+nV97bxyDgq0pRaPfn4LHbg+n+StkdYAAAQOMevUIhuP0artfdKgavk8m7T7qZAvCaJZ0Xt28vSNEh3/Gtxoel4Sk7wns9BC0jOBB0MTXFMwmH22nVuVt17hpk8hvFgNaSdbQ+btBRpgmlYg6kGMr1ZKxk2bgk9EbBhAcwkKu54DIfEn2JbBV5nKFLaXw1e6IlaqiT7on35DYwPPp7hKDbagC7zIv0eFw+GJ5r9k/2lxeR+eSjSdPQPbZ6By4afIyL5+W5x1gGKMETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtdMjt8DfLswmrapX3hflqxcaT6JR4lAozZvrT7ZCac=;
 b=N4VvsISjGEsONFvLrJPb2HY2wPOmY/nXjlC+VMk9h/BmGLj0nHHWD6BBT2BTXZLIixS617s75ov8KYcjCsGK+xuOUlETNOS+McA3CTgdg0k/97naBU3iXNSH0ZttX5qNLHSQwuJDCMjdT2PUtoXUMkrnJ8WBM4O5F1QLbQnQuPLXNNVf/naeP5FDvi0t7+GbTEofnP8pbKmgHRkmI5XuWHo37sqpCSiZRA6YY7YhpD7fEe+Syf67FMBoWNHgebVbjiqjzoYcfBzGf07wYo93hM4E2ZxBCLK9y9ldkY7GaLQstgsE6D030kPfFAcRprXzIOcdDE45Mx3XQc2azFlwaw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA0PR12MB8745.namprd12.prod.outlook.com (2603:10b6:208:48d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Sat, 2 Aug
 2025 10:37:51 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.017; Sat, 2 Aug 2025
 10:37:51 +0000
Message-ID: <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
Date: Sat, 2 Aug 2025 20:37:44 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
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
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::29) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA0PR12MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f8ecd2-2eb1-4715-cfe7-08ddd1b0a182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OG8zSEtJdzBObi9FTnZISlZzOXkrcDdieThCejhGb24yR2t3ZEQ5a25ua1Ew?=
 =?utf-8?B?Y2xXazYwaEc3SnAyelJiSmNNb1hrakg1b1hTYmticUFUNDN2UkgzL2hTdEkr?=
 =?utf-8?B?NXBiU2RhaWc3QWdhK204M1A5dStzK043U2MzRC9PVkJFNGI2enoxc25xUVpp?=
 =?utf-8?B?Qngrc215c2VuYkVEK21HZEFiTlBrcVlWQmNLR0hVa3hrTUtsbjFiMmp4cEVi?=
 =?utf-8?B?Z0plUm9lTTZwQmNlRks2cFhUSTh4RXJhL08wam5RSzlBOGU3R2NCL2QwV2dH?=
 =?utf-8?B?emVlWWpOc05KRmkyeGo2ZkV3VWpZemtJdlJhNDlTYXBJaVJTUEVKc0dadFU0?=
 =?utf-8?B?SHZaK3FXSDBIMDFBOFNSWmtaTVJ2VWd5OVMvc0dDYzh1WG00KzVkYWtLL05K?=
 =?utf-8?B?eFBwN2NtL1Z6b29YdWU0bXhMdFlOcUR2aXY5d1hJbmxBWFJKbXR4dkQ5SGd3?=
 =?utf-8?B?SUFFajFJYzd2ZmNHbnQ0MUU0MUs4RkJpM0ViWDlQdDN3eUhNc25Rd2dEQVBa?=
 =?utf-8?B?ZElPTklLaU5lb3pJMGJLV3Y0bGxJWGVwY3VFOGlVS1hqNEluNGg3YUtUS05F?=
 =?utf-8?B?aEtDa0ZxWk5CQjRUTVdFaFVJSVU1TTRSNE80dlNtYzZ6NnEwWkZXdXZPeURF?=
 =?utf-8?B?MnZuTWtjNW8zc0U1akxob2lyZ056clE4aXNaZW9neFRYSG41dDg0KzBLRnhR?=
 =?utf-8?B?MzR1Z0lxeGRZSXE5b3J5R1pPUTlVSTkvM3VpMTV6TGlqdmp1ZllyZTNPaXV3?=
 =?utf-8?B?bng3dkFWaFEvLzZQMFp2Qyt5SGxIc2dLRHg2RFNOTWNZeDkwOEgxUGxpNFQ5?=
 =?utf-8?B?MHQ2ZWRqRkFvd28xTTNoL1BsSHdmTVBHUkpRemtRNytFSXJxN0ZKNS90ZXlV?=
 =?utf-8?B?bWhmK2tabTkrZSsrYWRXbFdYbzIwTmk2UnRzNzBzYmZYcGR2VFFhdTBpL0dq?=
 =?utf-8?B?cHJ1bkdlb3pNT0hjVUZ0dy91OXlXZ0JOVTU0eUJQNGtjSTRIVFJIank4N1N2?=
 =?utf-8?B?Y3lBdlBtV1MxcmxPRUZueHBqNFZIcm12bm9nSUJyNkxCT0UwT2hBYkxGL3RF?=
 =?utf-8?B?RmNZSXZmTTF3cTM3V21FcWlRWTd6VjFkRWx1NnB4ellYc3N5S3VxSGVMeEFq?=
 =?utf-8?B?VWZwUzVYMFB3dzRuU3MzYlBMYk5JOTUyN0EwK0tIUjljTkFieU56MHVRQi90?=
 =?utf-8?B?RGxHdEJvUFRjMmRCZGU4SUkyQytnWHoxc3ZJbFlxWFREalU2MjFuNklUbUhW?=
 =?utf-8?B?M3VhRTlTckJYeXpUdnhBSnFYNVkxamZ4Y2JQU0M0Zlo0UmRLYm5tME1kbzRm?=
 =?utf-8?B?dlpQQnFZL1YreC9BazhLQVJtRlNBYU1VS0RzQzQ4MG1Md0J1RzhRMitCL1ZO?=
 =?utf-8?B?TCtHc2JyaExRZE1KcmZVNU13dWFTODJtZk1WKzVDYzR4TTA4bEM3cktLMWhz?=
 =?utf-8?B?VC91ZzN3LzUrQm1SYlZUVjYzSjNtenpJcDRRQnc2OGh1UytGUFphMm5WbGYz?=
 =?utf-8?B?RjBoelBUNENla21UeTBzeTd3YjZqWWw1dCtiMUthODJuM01GR1lOTCtLQ3FN?=
 =?utf-8?B?dGRUWk1VS3BWY0VtV2VOYXhxM05KOXRHU29DZ2dGb0ZyZGdzNEF6Kzc2VS9E?=
 =?utf-8?B?Tk5paEc0R09wNjM1WlpRNzJ3bGphSzZZUnVhWDBKSFNRSGJkMC9IY3VINWNh?=
 =?utf-8?B?bXBxNi9JMmk4L1JWZnI3TGdEZkQrd3NOcHVZeU9wZHR2MS9CZTdJVnRBK05r?=
 =?utf-8?B?MUdvL0ZrQmJsaWMxWTZRbTBJOVp1K3RDWlZIYlI3d3pSbXBUWGloUW1SbWN3?=
 =?utf-8?B?VU1ZdVlBb0E5MlpFV3lscU5tVzN6RnJnOUxMallxNW1lQ2hadDFqYkppZmgz?=
 =?utf-8?B?cmZKTzIrMldZNjhPZC9rSzErZWlGeUE1UldUaTBnMk1DQ1UwUVU5RGJTT0lN?=
 =?utf-8?Q?y/o9681MUrE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0JtS0kzTFc0U3k3djlSNmIvY1AxQTJkblp5NnBMQzdzRzAvUGQrWmVRRU1o?=
 =?utf-8?B?bVNEOGY2L3pBSEd2YzVOb3hpSzFxSEJlQVFUeGNpbmMwb1Qvc3FEYmRHK1BY?=
 =?utf-8?B?emxIZ2trbitPYU91WFN5QUd0bHB3bWlzV3h2VERGNTZkTFord1BrT3A3cGRx?=
 =?utf-8?B?NURDTDFwZi9TOEhpSmpES3h6WU5UbGhtT2grN2k2emt1QWIrcldrQkxuNVBN?=
 =?utf-8?B?TFJENVduV3E1Z1ZFRXA1V0RnQ0YrSWZFU05XTTNOZUhGQXF2bURLOEFsNzVu?=
 =?utf-8?B?blpYYW9IMFpQL0IydUtxcmwvaE1nS3VoTnhPRGM3dm5pKzBQeGltTE1xS3ha?=
 =?utf-8?B?NDlNekY3WW1GWVEzTUZDRi92TFFyN3dNWGlTYnpDYkx2Z0R2M1JHV1cxcHh3?=
 =?utf-8?B?V3B4dkxnbkVmMEF0dThvTDBYckVVWUVkUkJTajJSaHdJai94WUFzZ1Mycko2?=
 =?utf-8?B?N0VuS1ZUd0tQd3k4U1ZqRFEvcm9seXV6R2VHdnltS2xxLzB4SWRlQ0tjMlIx?=
 =?utf-8?B?MExVbHQ4ZjlHMXpScmExTEI1QVpWeWFQSjZsL0MvZVBFYWFMZy9iNzVzYW9O?=
 =?utf-8?B?N2J3TUVrWlA3RHpUSWttODJIbm1TZm56SWtvRW1mYThFcDZmZm9JNjlKQ0NW?=
 =?utf-8?B?UnkzRWszMFE0dXFLSW9JclpQOUw4WTRUNHZtRVdUNFNJUVN1YzdXVDA2QmlM?=
 =?utf-8?B?bW1JRU9Uc2VqbXpKVUI3VEY1V0k5UEZCblhVV2xkVHFBN082UGZjLzFSMXdr?=
 =?utf-8?B?VnV0N0JHS0lvZEZnWU5WRVRnL01McFhDcmQ5SGRHeUF1UEl0V0Z6K0FyRGM4?=
 =?utf-8?B?bTJBbmFEYzZMcUNNbzE3WW1rNisrVG9Cc00wNWZpZDhJU3RRZHJNVXQ4Q3lR?=
 =?utf-8?B?eXM1aldBS2dBckJHdkhYRTNUdHVjVjlUZmNOSEtBeWxmOXBDWWdtdjBDREEx?=
 =?utf-8?B?QjJIKy9GRURUd3Q1TlFPTW5hNnBMYkU0ZzhEU3RLcmhqamwzb25mMm1zUDRo?=
 =?utf-8?B?NlI1NHRrSEdHcngzbDVtYXZCMFlERFB6dCtBcDFBWWkzajYyQjVkVnZGUC9i?=
 =?utf-8?B?cmx5VXlmMjY1UFg3dGN6YVdLWmlsR21haFFUNmRkMFd2ZTU0MTlyTzNCWkVR?=
 =?utf-8?B?bzIyUTR0MTVsQWYzNklKS1lFSXB3bDZ0SkhBWUtNbWlTa3graEg5d2dnaDZG?=
 =?utf-8?B?Tktid1RncEZsWnZlbGxRdjliZmYzbFVuVHNkcFMyYjhVYUYxdGo2elZHZm9x?=
 =?utf-8?B?UldHMFJuMFMxaFNEWkFaSXRXVEVGa0NGdUJMYSs2VklkeE5mMXFuN3dxMUQ5?=
 =?utf-8?B?aFY1V2Y4Z2RwTi9FdWVYd3NSaHJxbGZuMXMyd295dm9tbDBwVkR4NXR2Ykc5?=
 =?utf-8?B?d1BmN2xKNS9BcE5RRC95aFh3dnIwUVJXNUM5TkdTanRyS2pxRXpTWFA5SFBz?=
 =?utf-8?B?dXppeVA0ZU8vUWt0MnM2cEE4V1NJcDYvMTRLUXlTL2dBVzV2OTdmVFVkZEM2?=
 =?utf-8?B?L1FvTWVRcEtLcU16d2UzSk9wdDZKeGxJVFJTMm9qOTY3a1UxbVJYQ0N0c1pJ?=
 =?utf-8?B?cHo5aXMrSGtFTXQvalVwMDFBa1lWbGVXelJLYjdLeTJIcE5ySTBLK0xCZWd2?=
 =?utf-8?B?VEFWNzEyUkcweVlmUWJyOWIwMzJHWDNXek5UU05yeFhLNnVRdHo3aTJhNUZS?=
 =?utf-8?B?U01rVHRnZjJvYW9Pc2dvMndqRTJ3d0VwQU5OTDc4RmxPQTVlN0VMTFlHUFZj?=
 =?utf-8?B?aHp5aFNkSU85cFR1cHFwd1FmUkhZeHlzSUJRWjkwUjN4Y0Zha0pXNXVKcm15?=
 =?utf-8?B?MjhWZ0VIUFRMcWlSSUNGTDJIWVIyL2dMSFh0N3VtdjZTZmZFdGZwNXJUSEpT?=
 =?utf-8?B?Vm5LNHcrQUdjNno4UUllbk9ZUTVjcFhHd0dDR2hIWGpzMFp3amNmRExNS09I?=
 =?utf-8?B?eUttZTArc1RGYnBFYk5OVTJ2NGN5K05SS2VDaGRuV1loNU5BcWk3MkZXbkRP?=
 =?utf-8?B?MDZCcTBlVFdidDUxNExIcW4rN3crRlowY1JZcm0wZ2VPQldPZWFBU3huVTVH?=
 =?utf-8?B?YTB2NlA0Vnp2YmlxWWRRa0ZwcTlsRGEzRVg0anVkQVhMRjY0OVhxcXFpWFd6?=
 =?utf-8?Q?qQRn/XnzrHU8fRxVLQUN4SknS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f8ecd2-2eb1-4715-cfe7-08ddd1b0a182
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 10:37:51.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4r3jwDXl8HEpgbP19ONAm4EEExDoKiuuJ/M3v2f5CNgQ7t+JGX7Gq3EmDLeKJanW0BmrgvuACYOep9PIdh7W6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8745
X-Stat-Signature: kjosyc7r8pxni791u7s7ttq3tjs6w9sr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF066A0008
X-Rspam-User: 
X-HE-Tag: 1754131075-140109
X-HE-Meta: U2FsdGVkX1+lc9aOUyva45vM5ZJ+JXFTqGXBqCQtb3NELVWUF3yTt+Am8JDe0y5c7E+3TZodJwylygkr2d+yxNsOO+67qFCzZcxDVz0Wxxv/A5fEKFM9yi/9gx8XDu/X9bsoPF8u5G13ZguJIpqFkrS1saVR0PRcZByQkJR6m/wFpuN71eY7QD+gAeyYc8YMJG+qVUoSmLg8BQs3I3+iOVQ5PztfEZP2Tojymry16t4fY6AbY8o4LA/qK5Ex88MeLmtZ7jtMRWLvLc4zSDe/nXtg6OgPqfDDLmTkX7eEY0Ltv+SO0xPYma3s2iElnfrFVR15K0n6a6JAzlynPVMiTBsnJdhphw2upfkv6GH0x6MOqKEjkChvM1pMZOBq3ZBPOtNezQ52Gm1Yo7f17xfoabISquJL2e1FZ8SRlRJi5Sodj9MM9W+wm5eJu07syUPOugHcKspVwmMDAGHnBlTynyVDYB9mY+PAXe4NZn8Yz7Jq0V+n3KB2hJk8v6OEr6vyv92noKQKum7MxqzTu/ql7cv2pf1E9fLlCR9pBcssWVOpKGo0x24xVR/T2aNOrmjJRksjUrf61vG8Kv9fNSRjHohbOmM7plCSVByVp0jiwl6f0I04B4GWRLaodUrFPeEOnomaiDqH0AXUDTfcvR9J9OhG/Uv5ophpxOwQJ2QhIKt6pJDvDsagIMOhyjVcW8puihkc9v3ZteCCBzUZ3RFg/UYPS38kmIdDZ3IK9nbhlhRqHUs4rQ/u1+X9dCNE5HYMfPmwT0nZ45P++DuQSBO8rhi9USpj5qFatbnbOIY64X8bSkHOVbEOkpYgecRqf0eFHhW1Du/YivsZZ/tdX+75wKbbcRKTaxkb/Cm+WFhyko5IW2CIju29tjqp31UnAQ2z8i1UnulCisaVEQIZmko2qR2Wlgt5xzssYhndWJEztVAR5HMNHTOFrt+m+1UIh5ehcGYOU/hBaEYqJqaGpZs
 bmTI0AOF
 bKy5AT2JOn5WW99/Kas4Bkkj7MhASRXdtCioc9oD4DRrS+zqrm01E1NuyFU+C9gYCXIIe5QmZWx4PWguB2GAdVbYhb3DYlA+bPbirIIVDqNVm5S5rMXDGY/mU9lNIYso/HwRLXc1588eytRVpOjbC3MpWkSpr+ErgViMGhIid/L5g1VJw+NmzLg0GAbgw//3XsaNQMZBGeNq8IfYQU1Lz7FQ47GDV/Xg8u6nQfeneKrcZaY2lgjVCd6dsy6/+ky2otNFrioWOYEmDXqh2GugBZT2IbLw4nkBk6R2IjqdSP8bjUZAUhMygEjXsK6n3C7HXid+puJSeRPuhsrvoM1nLr/XCPiLEpEbV4ovpgyTeWyOgwW+ULAlOcoDe9vEscc8ZxcWfj1EAacOclvRDYGNDbkj3xN/J3qNW4+c8BPCtF/pr/fFOLnkwL+LGae7buY/5DVPT5vi7QlOZBFtJDwMeHI254HjT/g4bd3KaRjS9DoQFeQQ8fb8WmtfW+uwDiVVhYEO0VZhGvhLjV6j0h2IWKeTRG4TKUZekpelbcCSsNGz684uTa6j/QO33FyjpV//1PqoeSXDjxicsxIiJa+ivZUp7qRNsn7lOw186azh0Q6P1hZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI:

I have the following patch on top of my series that seems to make it work
without requiring the helper to split device private folios


Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |  1 -
 lib/test_hmm.c          | 11 +++++-
 mm/huge_memory.c        | 76 ++++-------------------------------------
 mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 72 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 19e7e3b7c2b7..52d8b435950b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_device_private_folio(struct folio *folio);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 341ae2af44ec..444477785882 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	 * the mirror but here we use it to hold the page for the simulated
 	 * device memory and that page holds the pointer to the mirror.
 	 */
-	rpage = vmf->page->zone_device_data;
+	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
 	dmirror = rpage->zone_device_data;
 
 	/* FIXME demonstrate how we can adjust migrate range */
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
index 1fc1efa219c8..863393dec1f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
-static int __split_unmapped_folio(struct folio *folio, int new_order,
-		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, bool uniform_split);
-
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
@@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pmd_populate(mm, pmd, pgtable);
 }
 
-/**
- * split_huge_device_private_folio - split a huge device private folio into
- * smaller pages (of order 0), currently used by migrate_device logic to
- * split folios for pages that are partially mapped
- *
- * @folio: the folio to split
- *
- * The caller has to hold the folio_lock and a reference via folio_get
- */
-int split_device_private_folio(struct folio *folio)
-{
-	struct folio *end_folio = folio_next(folio);
-	struct folio *new_folio;
-	int ret = 0;
-
-	/*
-	 * Split the folio now. In the case of device
-	 * private pages, this path is executed when
-	 * the pmd is split and since freeze is not true
-	 * it is likely the folio will be deferred_split.
-	 *
-	 * With device private pages, deferred splits of
-	 * folios should be handled here to prevent partial
-	 * unmaps from causing issues later on in migration
-	 * and fault handling flows.
-	 */
-	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
-	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
-	VM_WARN_ON(ret);
-	for (new_folio = folio_next(folio); new_folio != end_folio;
-					new_folio = folio_next(new_folio)) {
-		zone_device_private_split_cb(folio, new_folio);
-		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
-								new_folio));
-	}
-
-	/*
-	 * Mark the end of the folio split for device private THP
-	 * split
-	 */
-	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
-	return ret;
-}
-
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 				freeze = false;
 			if (!freeze) {
 				rmap_t rmap_flags = RMAP_NONE;
-				unsigned long addr = haddr;
-				struct folio *new_folio;
-				struct folio *end_folio = folio_next(folio);
 
 				if (anon_exclusive)
 					rmap_flags |= RMAP_EXCLUSIVE;
 
-				folio_lock(folio);
-				folio_get(folio);
-
-				split_device_private_folio(folio);
-
-				for (new_folio = folio_next(folio);
-					new_folio != end_folio;
-					new_folio = folio_next(new_folio)) {
-					addr += PAGE_SIZE;
-					folio_unlock(new_folio);
-					folio_add_anon_rmap_ptes(new_folio,
-						&new_folio->page, 1,
-						vma, addr, rmap_flags);
-				}
-				folio_unlock(folio);
-				folio_add_anon_rmap_ptes(folio, &folio->page,
-						1, vma, haddr, rmap_flags);
+				folio_ref_add(folio, HPAGE_PMD_NR - 1);
+				if (anon_exclusive)
+					rmap_flags |= RMAP_EXCLUSIVE;
+				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
 			}
 		}
 
@@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
 	remap_page(folio, 1 << order, remap_flags);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 49962ea19109..4264c0290d08 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			 * page table entry. Other special swap entries are not
 			 * migratable, and we ignore regular swapped page.
 			 */
+			struct folio *folio;
+
 			entry = pte_to_swp_entry(pte);
 			if (!is_device_private_entry(entry))
 				goto next;
@@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			    pgmap->owner != migrate->pgmap_owner)
 				goto next;
 
+			folio = page_folio(page);
+			if (folio_test_large(folio)) {
+				struct folio *new_folio;
+				struct folio *new_fault_folio;
+
+				/*
+				 * The reason for finding pmd present with a
+				 * device private pte and a large folio for the
+				 * pte is partial unmaps. Split the folio now
+				 * for the migration to be handled correctly
+				 */
+				pte_unmap_unlock(ptep, ptl);
+
+				folio_get(folio);
+				if (folio != fault_folio)
+					folio_lock(folio);
+				if (split_folio(folio)) {
+					if (folio != fault_folio)
+						folio_unlock(folio);
+					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+					goto next;
+				}
+
+				/*
+				 * After the split, get back the extra reference
+				 * on the fault_page, this reference is checked during
+				 * folio_migrate_mapping()
+				 */
+				if (migrate->fault_page) {
+					new_fault_folio = page_folio(migrate->fault_page);
+					folio_get(new_fault_folio);
+				}
+
+				new_folio = page_folio(page);
+				pfn = page_to_pfn(page);
+
+				/*
+				 * Ensure the lock is held on the correct
+				 * folio after the split
+				 */
+				if (folio != new_folio) {
+					folio_unlock(folio);
+					folio_lock(new_folio);
+				}
+				folio_put(folio);
+				addr = start;
+				goto again;
+			}
+
 			mpfn = migrate_pfn(page_to_pfn(page)) |
 					MIGRATE_PFN_MIGRATE;
 			if (is_writable_device_private_entry(entry))
-- 
2.50.1


