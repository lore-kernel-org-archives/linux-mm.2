Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF463C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 04:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BAFE8E0002; Tue,  5 Aug 2025 00:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492998E0001; Tue,  5 Aug 2025 00:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381848E0002; Tue,  5 Aug 2025 00:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28D918E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 00:22:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4851821EF
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:22:54 +0000 (UTC)
X-FDA: 83741408268.24.4FFF874
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE844160005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:22:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MWDJ5vma;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754367772; a=rsa-sha256;
	cv=pass;
	b=QqIxvFQtsAhrKTjvN3vMGE8mpwfbFg+2698MeUh28Z/WvvQhRepoRwO8v4dWDCNws39HLP
	phIWj+qO+SeGRS1g1lhrCSPW0jlMqJu3sxzISC0AjOp3dvIdclVjz0CmwWyBrhPj0h7i85
	I5EJmUUDOncJ7aekfe0HLluId5Tdzys=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MWDJ5vma;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754367772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0RYhOidno+U5THQXjL+f3ctjwMhQFlziRMjpdjV0m8=;
	b=76b6qxU8KQzJnKeYinnOZuuFDL7G26TdAAo5v3jEWheYh8kEHmw/Bj/sQbWktID1juQmf+
	sccpNOCAcJdoU3gaZmeRlsaERnbLaOu6VMwKbRXkqqZxxcl8mtbrFVZYgn+4arLSnWPyP+
	0pMVLkmDZlSSm0xNuOay13ONlU48+dQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjD00zhRQZWsh+kF7+7JIQNeVJBeL3BT34MbJQ8906ZQHDbDrG7KA8ESP02zmaSc4Ryyb2J+NSBhGKAR4pL+zbnF8rQtIX6qd1JkwzuklpXJwNnHw70Q4OqEIwmtU+4z2rxI1T5bNsgZ+q6+Sz4g6b2T2MNNDbd8lwSSqNgQSv6nvNgz3/Xib0Rb/Fr6HvnU8uB3rscbuarnQbvnj3BGZv+k3jNc6uvUVknmnOSJDitnb4aHA+ywQRF7k1c1p8akSZvusv2gIsGcocYGTsTiUfSPWyh4JdoR3DZ8wLq6WAttaPbSl3encDVg76NOXR+3SnbsGLzlHF1cAOhSq/rvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0RYhOidno+U5THQXjL+f3ctjwMhQFlziRMjpdjV0m8=;
 b=zNRxa5CAIn4j1gEIyTPcYPay2gTU0yHeVrDCDGujJcsf7lgBprpklK88dujsVOM9gRJg6F4KXpSXDKDV+H3o+8a864LYYpPbXvsXNY4UrZfme3hQsPvab73NAxGFRr+ci9FpPvKiOsRtGv4ipaVJ/A0oTPUAJ8kYceOwtFmJFEKm81cgl/A8H5CH16JDu+CVOpaLukI0i09acetTaQi8cs+BJ2cXhwxDxTXSOmAty5+HOTjX3pobHsVlVZXOKVdDaZr423NrTogO30sZFLmTa9s2w+WsDdqN1RNHLrCOfBKfzTZ9RNfgzao+Db0Ugx90U/dKOUc0DOYf1pAwiVRV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0RYhOidno+U5THQXjL+f3ctjwMhQFlziRMjpdjV0m8=;
 b=MWDJ5vmakmgfgnPsVseclkcd70dAhIeHjIzFUrN/FKL+le4jkLT/b1OEBvAjQRiSoVM5lMjDYbzmjTAD1SeFj4VpceM6ii+55wVnQIR3kAYkcZXk88onc+s1wsriT2un6lA/862mLZ3LPfwGZcSt7zLwt88kk37xLmlzIKTFYfmlm6aCBjvDajgjvfK4H24wkYiO3v8//zoKGX/mMZBZRmm37RYDsSwgXeI+w3gEUkHoNm1ECVYQ3SkUqLkDPu/f5tTZJef6N31LKUDr/J1NqRyHrKEgXZK0X52LnNp/I2kOQR1ojC3YugLfK2/fjAgOku3rAm0frbm4XwQzA8L2OQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH8PR12MB9791.namprd12.prod.outlook.com (2603:10b6:610:254::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Tue, 5 Aug
 2025 04:22:47 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 04:22:47 +0000
Message-ID: <1e307223-897c-4db0-9564-95d76bc3d260@nvidia.com>
Date: Tue, 5 Aug 2025 14:22:40 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 01/11] mm/zone_device: support large zone device private
 folios
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-2-balbirs@nvidia.com>
 <dbebbba0-3c59-4ee1-b32c-4b9f6ed90d92@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <dbebbba0-3c59-4ee1-b32c-4b9f6ed90d92@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:a03:54::24) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH8PR12MB9791:EE_
X-MS-Office365-Filtering-Correlation-Id: e3f2e198-3e8b-4d6e-7ab3-08ddd3d7bb34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0ZCeVpYTWpPS3dFYVZsVTcya3JPWGoxaTRjMHdQNXFkMFQ4NnJrY1phN0dR?=
 =?utf-8?B?K0pMeWl5RUFhU29EaExLOEJZTEhROEVwUmxjTTNudElKaUN5MnN5cncrc3By?=
 =?utf-8?B?R1B2Um9PNEdEOURCQW9SN0xCck1UWk5HNUtVbnJoUm1OaTZkN3Ric3o0TW0w?=
 =?utf-8?B?aWtZb2FsN2FObS9xd2x6ZkVhMXo5NEp1ZjhGdlgvdEFaR1RKaFgrQXdiRjlG?=
 =?utf-8?B?YlZEWjREcWpMQkVOREVKUlhuWjk5TzVOc1dtR2VseDRnelYrTkJnZ01GUjF2?=
 =?utf-8?B?UTNKOXE0RStmdlkrSjN1S1dKbmk0TzVzT2VaeUIrWGtVQVJQMGovWUZCeFcx?=
 =?utf-8?B?SVhWWjBwVWVTck5MbUF5cTNBRjE3NHBySGJaZXFicHlpYSsyMzJKLzBGWUNr?=
 =?utf-8?B?M2xZMnR4MnNDZHJJb1Z3aThRTmg2QjRyQ25lYytMTVpoV0w1L29oOE5yZldp?=
 =?utf-8?B?MDdiZlNwanlMZ2FLdVFQSGkzUDRFN2pYQVdJTGZCdndlOXptZTB3OVk1RU8r?=
 =?utf-8?B?cHpmcXdHT3Ara1NDbWpLcjVCKzlHWVRUVlYySEFuVlNCRlZrUWQ1dlZQd25s?=
 =?utf-8?B?a0RCcVRpY1N0K0pKSlA4bEJzZTBwazJITWlXZHV3UEQzb2RyU1Z0L3U1empS?=
 =?utf-8?B?V2dSbDY1TWQrM1YxM2UvV01QbGxwWUNkQy9qd2h1MjU2VkV0VE9sRFZmbGVQ?=
 =?utf-8?B?Smk2N21jblFzQnZzcVJMR2s3S0w5NStSNG8xSk4yd2NTZHNFQVkwWG14ZzFh?=
 =?utf-8?B?WlVDZ2FjeVljZVhkMW5pOWFoR0prak1lc2x5K3p0M1orRzUvTG0yVGVUVVhv?=
 =?utf-8?B?c2tOalFJVW1nZE1NVVJmR1dndlc3MEx0eGFUYXdqTjJGa2RDV3BGeGJFWXZy?=
 =?utf-8?B?Tjh2S0dLM0tadkZQRHBRKzVqVjF0OUdzS0xzb1VPTUhuNWJWR3ZCKzI3Y1B0?=
 =?utf-8?B?MnZNanRhdFRBN3BKNnFlcUlqYTJUQ2N5TXBkUU1HbkI2dTVDMWtGcEl2N0Nx?=
 =?utf-8?B?c3JJNjR1aGx3WXU5VGs2WGZsM2FNWUcxb2xGK0lhdit1b1Z1bjdPQlNreEFV?=
 =?utf-8?B?bDRFajZBUEs2ZGIxdmk3cmZuRlZmbm5pdEZMTnRtOXQwTWdFYWhiZU8xWFpa?=
 =?utf-8?B?cFhKaEU1WHl3ZVZ1aDhiTXJYbWNhQ0I3czBxMVRpMjQ2Z0oxdU1LRldrdk9C?=
 =?utf-8?B?MUN5SGhVOXRBMlBGWlNScGwyY0N5K0JNWURNZWl1cG1Db01OWWxNaURhdGtr?=
 =?utf-8?B?TU5rZDlWbE9sT3FKdGcwK1NaRTkrZEFUcU1LZ1ZuYU04ei9YQTh0dklRZjQ3?=
 =?utf-8?B?UjFia3puZVZjV2tWRFNJYnNNY0lmZ24zM0tVT1VFbUU5ZGRrSDA1ME45SzZ5?=
 =?utf-8?B?WTN6SHhaSkt6RktxSE5wOEpJNkFaeEY2cFovYVNoL2NSNWw3RlhiVjZmZ0VV?=
 =?utf-8?B?b2ZEdUhHRGxZL3hrMHdwaEMwTC8zRDBsVWMrSzlCWkZQRUJqUzYrRU9sWG90?=
 =?utf-8?B?b1pVelIxUkVTWTc0Q1F2SExyaEd3TU5NMVBSajEvbEw5Vno3YVdCd25rUkVn?=
 =?utf-8?B?UFVQZ3pQYzhzakx0eEs3WnNqaDI2bGNnekNNSFhzcUJtSUI2ODVwTWs4M0JN?=
 =?utf-8?B?V012MHFWY1V6Sk4vckFhY21BbU5zaEJQeTFlTWFNVE92QVBzZEh6bHBEUlVH?=
 =?utf-8?B?L2NRZ09abGlIaWYyYkRBUkY4dlpUMHoyNC90aWZQWVRDekViUkJHOHZleGto?=
 =?utf-8?B?VStNNkhqamM4TFZwbnd5UGVmbDhFUFlKU241YURMaFRQZVlNMWNWbFJRMEdu?=
 =?utf-8?B?RXFXSW5wTWZQV3k3SnNJU0J2TU1yS1BWN25Sb1ROdmN1K01ndXZVN25sR3FS?=
 =?utf-8?B?eS8vaUhPOVVETURDOGlRYmRsU3JxODBSNUZzdDE1elk1WUNuTHFBczRjUDFm?=
 =?utf-8?Q?zChYtLZUWck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHhBNDM1c2JsRFM3RjNMckxscTVHQ1RWaVJGdWRSNlg0Q1JidUNkaDRYcDhD?=
 =?utf-8?B?cm03REhPS212RHJzc2czVjhtM2hFY2wyZVFEdEYxbEdaNWpUeXhiYkliMXZz?=
 =?utf-8?B?UTdsUkU4WHdabmlBdnNobVgwUDdrSTZrKzl5WEU3R0ZsUGRCRHVzZDhOM0hU?=
 =?utf-8?B?RDg2ZDc0WXgwbkwyQ0tlWFVUTkY1NS9CeDJjRklIV29OWVNUTUJERjV6d3Yw?=
 =?utf-8?B?d3lPb0srUXpKZmxjd0p2S1VQT0tLZjNUcjFtUlZhd1lQQm9PUDFMZTZRd3Fx?=
 =?utf-8?B?WUNTMHN2UDAxRmpYc01JNUxkOGhDT3VuU2hNdzc0TXpXMVJweWpyU25kWEJG?=
 =?utf-8?B?aUx5VkhER3RxUWVBUnJhckxsVGRBNWNWVVVjU3FaNENtZTc1VEhRMnpVdzZH?=
 =?utf-8?B?akJrOEM3dWFWSjVSeGpmK2xCS0R4YXhXZXN3WlZxdlNLWWRvekVMSU14d215?=
 =?utf-8?B?YldLLzlWRnhseWNMM0ZYbVZDYkdZcDZoTGZYVmg0c1JNZE42dUFFS0g1ZW5p?=
 =?utf-8?B?ZnhuZ0ZlY2Y3TmJ1aG92K2JJU0tLaTZQeDRGdEpqU3M3YzRvQmV1K3hqYTcx?=
 =?utf-8?B?eHVXeUhrbWdnK1Bqc2JMc081VlNSZ0tQdXVUNjJBNkIvZ042czJ1VlJQWjFx?=
 =?utf-8?B?bTRpbXV0cUNSN3VwWFZqTUFzYXJWNXNXRGNuZExTTWcvZ0VKcTlNV2NGN3Fr?=
 =?utf-8?B?Q2YzYzhGVHZaVVhGNHZHdk1KRlBaUHM1QXo3VC90NWozaVh1WThLNW4vT2Jx?=
 =?utf-8?B?cHp4UDNjVmtQSGhFS2psQ3lXSU0zeWowWVR5M1FhZm4vVTNXb3NrMlRZU0Nk?=
 =?utf-8?B?MENDbmd0OUJPM1d3YzhwZ0tsRExSQVZ6WFJleWpnYXkzcGd2KzJaR2ZKcHdm?=
 =?utf-8?B?RHZYWEM5SDYyWmZXbEo4NGx6cnViMDhDL2tSazJxUE9iUEdCNjRxZXlOa0hw?=
 =?utf-8?B?YmY1ODJnR2hKdWpGQWJYYzlNcm42UmtkTWl2Nlp2VWN2QXV5aWRMeXFRZHY5?=
 =?utf-8?B?ckI1emhudUlSOFFsaGRtU1ZzUWg3NmlzODhSbTZhMjM3cXNSQ1pqWmJOMnZY?=
 =?utf-8?B?clcvTVROT2dKSzhDaGlXVWl0RlY3N2NkUDNBUkFHOWNLT2JYRno2bWQ4dUhD?=
 =?utf-8?B?Q1lMSGFiSWNyVnk0UXBzMUVQMTd0Y0MrRi9PMVJUMWVlQVZxWUVDcWpJdzRJ?=
 =?utf-8?B?cnZ1OTR3VlpGeWVVSk9BZENzRFRna1Z4VDZGbmxIeStQS3lCdG5JSEwybHly?=
 =?utf-8?B?VGNOcUY2L2k3YkJYN2RsVms3QmlmNjhQcjlHRkE0UHFKUFV4bnU1TW1EM200?=
 =?utf-8?B?eTE1WDAzc3QyQWMrYlhWL3V6NGFDK2FGREdrMElXMnJGUTdPWFlCdUgzV1Na?=
 =?utf-8?B?b2haNXNrbk12QVlobDVweUc3L1hRVDhGNG5zdkhmZVFaK2s0YnJ3dGduUjlx?=
 =?utf-8?B?QUNTZStYa0IrcXV5bVM5R1ZPMmJoRjZyOVlLODhwczVnMm1aeHB0R3d1Vmtp?=
 =?utf-8?B?dHYyWjloRWdTd3h3ZTNJN2tjV21HelFEaWlPWU5nZU1GcUJPQ3VMQ2RGUHlh?=
 =?utf-8?B?akJlSk90MkRwN01qbUVXTUlGdjU0clZSM05ucXo3MThSTmI0OHlaeWRYNmhT?=
 =?utf-8?B?b1RRWVlrRFB1MS9WTnoycXNaRFVxZVRLTGhGRHFTcStSNzNtSjlSUVdwSTFl?=
 =?utf-8?B?dUE4bzhoMHoreXk1UXVoVHkyQmU2Tm5LT2ZhMmVFWlVtQ0d2VFdwOElGdEZ0?=
 =?utf-8?B?cGluQjh5VEdEL0Nldk90WXZvWlZGMDNhcDgySXN5M2lVQ3NYYVFGc2V6WjJw?=
 =?utf-8?B?Vzk2MXVFdGt0WGpPbnhBQStJcXJ1dml1ZWU0MHhVUlpFVUFEdy9VVCtOdGNv?=
 =?utf-8?B?Uk1HaUVHbms5U2R4Z2JZc1BNZkx5RHNxMjBjaUR6bW5VcnJWV210MzdxaDhV?=
 =?utf-8?B?alVzRVYzbm1pelZVcnBFNDgvS1RjVUtXaUp6NVdpaC9qQTNyeStCY2kyd0tY?=
 =?utf-8?B?bGh2cGphb0x5ckhXYXFNMStIblZmOCs1WE5xRngzbmpYc2lhRzJLeVE4REdJ?=
 =?utf-8?B?YW50aG01aDNRQ1hnZDBUMlBxam9xY3Z2UFNzeDYvQ0RaTU9sS2l5R3hKaVZs?=
 =?utf-8?Q?P/8fLpVLap70kQn9aHK0ypjO0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f2e198-3e8b-4d6e-7ab3-08ddd3d7bb34
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 04:22:47.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvTdv2vyy3SiPPTHJzDTRWGwumR4+04AWDilPOp4xWNBSvdFlfXLap+Gb3K7LsYwvt5mEHi1wjumcURi/0La2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9791
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE844160005
X-Stat-Signature: i8ukt4tb888r1ot9n4cipo7bpfanr54o
X-HE-Tag: 1754367771-787655
X-HE-Meta: U2FsdGVkX19Kw6WfMhVkTb/s9Kp/OBy/JrtxmL0AAcu9ocQoI/MiVMs6Z4WlIULprPdnumzT9duZizeqYDQiFn3Z661EulNxePPnqhk/TT0As5OVfQ2BDWQ05zE7AxVuhykkjcNMnLKlvS0V+mHGtmFcQ1BxsFhATEyfJ7gr6tpPIhbVIbzFs8JD6WZz0/toEZQa9n/WT8FgwGefE+OsVbImn1g7wj/7skRd7B+XVXwJgBeR3pN2xZV5DmxMRO9QmMKvjIA2vhBkRHT2fzG+DXsFLOsCt1ZQ1B7JUVBXvfjWN+zfJdq/POlCK4Te2TcuYcf5BfZTRSNBvM4onpNFvp+J5/08vR/3qRne8O8oETshOfZTo6szK/vjg0cbdb2TiUN2hiSCOZmH/S+anv+E8whkOlFRFZFVSSDe5bksuvPigFmvPjCc0rNfSRf4pgR3Qn4Oyh/XuEJ3DtJnAf/M232njLGUnUUlh+dWiZHNenOskAn6qyYjck3Xpo/j7mNbntRBxhHYz0QfBqhxUYCNod+VQexWwjbQhWyJm6JQpgLuEHaHGFDwBEPsY9sP6qsr3CGA5L2o6JnjcRqJzOfcWvLkK23OEi7K+qMf8oXY2t2XbH4c35Tb5hjWjW5Ciy5mV4JdjQARpAp58WMm+Uc7iiMlWVf11iS5jZ7aD7KioakbJCNXTRY7oLP41ocGQEWdEGkymeaslRasObYSDv6vSop55uKx05ADc/ao2xfp+m9SfHUXInCdgCL9rxgWfIC6lECv6INexmFYGwTzaFJ9L+as5B+0tNuLhJ5lMgdO3GACOytDwYBCi2HHHWrECE0Fs2G7DSfMA3liTxItN0knKS9ykzEi+wgXi2x67JW/k/Lo3CrQnmzQDu9q+Uf1wqv1k0+WKisstpanwzMJe7aUb7uyOMU20oPFE0SG5nPn0BTGNmxDiDelknUGHbDBEfa/2EoTCSgCp+XhKJYbjM/
 Z/KAQPbv
 /iI4zdVzhSXrmmM1pJEP6B86c3pR0OYwHB1dL4lZpvVUtzNmb+BHkxfpsQRkLtAI4S3ZM1HkLec/Gk4KB6zk74ng6mitrydVgLQK15IZjMWiG3xkrYN8oRwX2hV8qA+mO4X9wtbai3sHGzR1DehPvgsNrjNq1bEnVrhceAlGRR9MRPJ48UZxAcFPwervNRRrQkyuUxsVF29bHOI1C6pn4yw0RU6esD1NZLayHE9YauENq9ojfuKbAqi5Jg6t48InHjPXBM/05nGPoH6nYbgUXJAUd8WNjF9tjgMJlDdoADEQlOkNUodda9yjs1sUs2OlB1HLIFTWEZ6TeQw2mpvN5/dvm3SyyAT49VQoaXX3L4mlcLeeZwJOvlW77Cztvl549WYdjkgsV/j4v5aoThrzM5dSWgP+FUy13yHD+wEAMukk4wuQLgHNYnakn5mJksbNLhulWjrOR41Nd3NcX8UJKqtPk0B3OluWmFD4+QHt2ia3V1+K0io8y3ZHIv4rInTKMt1kzVl5uK2zAQZLyOYTFuy8ObkYtkVq6/RWdA4auuLv5GzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 19:50, David Hildenbrand wrote:

> I think I asked that already but maybe missed the reply: Should these folios ever be added to the deferred split queue and is there any value in splitting them under memory pressure in the shrinker?
> 
> My gut feeling is "No", because the buddy cannot make use of these folios, but maybe there is an interesting case where we want that behavior?
> 

I realized I did not answer this

deferred_split() is the default action when partial unmaps take place. Anything that does
folio_rmap_remove_ptes can cause the folio to be deferred split if it gets partially
unmapped.

We can optimize for this later if needed

Balbir Singh

