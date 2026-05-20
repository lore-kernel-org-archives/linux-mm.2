Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F2FCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4A46B00E1; Wed, 20 May 2026 11:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BFC6B00E2; Wed, 20 May 2026 11:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B0F6B00E5; Wed, 20 May 2026 11:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E747A6B00E1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:35:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 905FC120392
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:35:55 +0000 (UTC)
X-FDA: 84788198670.27.53990B3
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94D13C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:35:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ayUSyR4M;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iz7cMLYj/bz4dNKlYbrzQvDzgkveZyC7wsugglzQcSk=;
	b=E6MmYAqXU/nTaslkYiDAY/YeuqOrN6QqUFkqD1ZmTTnccOldv9TI8ZjX2lm233W2l4Iwuy
	RG2uF7//K4LreLVVKyPoBLmYK+eVmjfHDUSgAr01Bu5iyuFG7wkC8luII/rRJKTl3qwm4k
	+6U9/qIW0pnV6kGM8tQz82Dfhtb5n30=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ayUSyR4M;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779291352; a=rsa-sha256;
	cv=fail;
	b=OM6bNpcPsT/2/k04Z041XgKGfng+yqb3C4qNgIDfsgh1s6S3eyE19U7Bj5qsMUECyE88Gx
	1LYMptfhxZQt7ykKsSJ43YcLDEQRfS9Vx5ORt298o/aMEjIts2ZK1VjTofzo5eqkJ3u29M
	tkAZ6vQJTRjBtn4l5YMQ5hicuU/T1z0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmrFm5evpgHBimV9wZkhrCHjU3DZjNfBk1PRqBSmR1KnwhpvkQb49JfHeBfR/Ssfo97htC+kG/LsL66EghDMF8GOzFePJdsHku/2217rXR+iwL0gzy8sHGbC6wgIZIM+v67tWYdsplolZ08plOgUhfGnFAIf/Py8+oMGKN2Y2J13L+PgCXpivp9UwuufTA3ctBDsixZ50queCOMIRufSNT3uNvdvScKKNzQZsIeJa/b/1EqgkEPZXTZNcQB1FjWcPdMVyqQA7wkcsJf87yeleqzerhH96sN1f+ZnumK1I5QQG0uRaZkBltT+DUcwX9Rya4OAcQcKXIqJ23LGw9rdNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iz7cMLYj/bz4dNKlYbrzQvDzgkveZyC7wsugglzQcSk=;
 b=OGxOIrLDY8fwTKik8c0x0o18T9NkDsw6Sv4jdIaSQ9jgO3pc7aUfbi0HjeGLjO4SyoCRi1Qoaom2qJVaW97QfnqSwgnKnVlDc0sXUZGG2znQWF8uGW0zEhluHhTQ5ihTqAy7jyt4PZR7RbXsUzGu8gF/K84StYJ+GJFBVFpBCq/14jtqKUYzfBc+Ov+OsmNhdat0ya4TNV+KSSUiqyKYZb0ViOXPjPyZG6nvC+vs9jlYIBCl4mqRyss67X5NbPZvilfU8oqU1oFX9XAOUFTYkl8zxMxalAAMF1Ubw5rWYQBF9IuuojjOO4tA16rxrHywIZDQJS5VEt1aX3zWAccAKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz7cMLYj/bz4dNKlYbrzQvDzgkveZyC7wsugglzQcSk=;
 b=ayUSyR4MDA5/2EquoBiszWfm7d4IAMjdMZfEyAMRIP4REYvxAx5KeBeRHswl6etFbNXySISD0tk6lPV+1g5FVhgLHnHjzVrmYxTXXn0lyfFboVqc5HwjcgMGsPTg7sGXFL6rja6IgYQk34uUja4GnftY8yKLQgb/dh9p5NfB9Js=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Wed, 20 May
 2026 15:35:44 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:35:43 +0000
Message-ID: <f113eaf6-8fc6-4a8c-bc14-7364d99ad697@amd.com>
Date: Wed, 20 May 2026 21:05:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25e::14) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|MN2PR12MB4045:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9e2128-6fe2-4530-8cc9-08deb68574a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	EKdeffAOI1/Ea5bjYlph66DKX8SXQaAc5P1KNNf8mwPJbDVQVd1xrEAZQULvd85wXiVSBqzhEVuVolkCsy2BLOCsGI5+nb0q+motHNVoJkemCSXnAJwdMOctlETD6tNUmJAkLfE3f42YiIPAsiRWp8/3vjuqVKrIuT1RIROyqMv8uSqRcsujJ1ptGdRy4CT0bjFEe1ISyUOtSdPpl22Pth0fWo6FM4fKQXa2j3odJGyg313ocwKbRWjLDy7xPL9ls01wFzF4mDteeUjfTHCk19JLSjdR0OfdnO4uW1oP+mLzIpBhUR1DFxEMGIJXnXJ+57Qnl3VlYgD/SopfQRa+yPNUo1VpsfliBP8JMB/oDgmsJs1T1Rvil3G4Z7i9MJF7n1HC3c/JSpcg9slEJtn6OGVfUv7W3gMc/zkvjeElfQZWADd8t19k27G7XGJX5SyP5378hSJ5MMRcj5DRYlFbYUB+CPzyC7lJOuqrgxa4wuMixXedevkyiOLhWGczjaHod7PJQVaeOhffb+2V6jIkjqNYyxNiWmaQDB+Fu5abThuVAWgHrcVonfpB4mSxTDCauQQTfN8jYjWeBBD0Iw735du+kdaXPH0MxUrUX/PnG60JKTlCB1JCMIf9Z37bp2N0QPBryqQtDSsYdW5CC5RQRLsKhk5oYoKbvK0heWRdb4L8A1w6W2sNRY3cydyXz+i3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEhWZXpQNnlsZmxFRDR6SnJaZnI1cjRqYjVGZ1pvYS9qc0p2M3lCa2xZZWdL?=
 =?utf-8?B?ajVueldWRHZRblNvVndZeDJRLzNWK0NCSzZaRVdIM0JpdUhXVmRJTzdkemRB?=
 =?utf-8?B?UWl1MlozMUk0WGVlZ3ZyTFMzUVlzYWRHTkNwR1IwbmtQZDNQUHhTWlpiamgv?=
 =?utf-8?B?dDI1dkdEaW4vSWZDS3ZTM05WZnZRU0xJMFlId3YzREgvQUxGYzlNVlozTHBN?=
 =?utf-8?B?YkZ2T0tPWHQyVmJKbGJWYTFUeXVHQ2d0RVFmMnRxS3pPaUZKWWNVZDV0Z1Zm?=
 =?utf-8?B?R05JcWwydVEyVHBHSmRGak9jU0xycEdBTnJuUENXWjJiZlFOM2lHZkl5NlhD?=
 =?utf-8?B?VW01TWJhYkRBL3lsZjlvSmNPZDRFUHV3Ly9kbGw2aFJlb3hnUUJ5aU0zcTJF?=
 =?utf-8?B?Q3YwZXJGTVdTdmpxckxBOStmVEt1ekpMWS9TemxDajdjWUJNU0kxZTNMaDRm?=
 =?utf-8?B?VGhxUzYwc2x6RDRTNy83SWVvUGQvb0Z4aElTcVptN0xaRmhQRTZ6RnMxU2hY?=
 =?utf-8?B?RGgwWEZNRGxwaVVyVjJYYm41RThtSnV0UldaSGNLRzAwSE1oZFN6NlZ0dCtu?=
 =?utf-8?B?a2cydFR4Wm4zeFBqdC9oQnlsRUVsbzZFYnNzSXN0UDhVcW5pUTdRMnNHbmNC?=
 =?utf-8?B?ZXFxc2xIOXl3U2xZTkViUjFTWS8zT3lpTTlJVlUvclJZNGFEcllmTVlFSjhp?=
 =?utf-8?B?TWJ2OHpycXhvNWxjeGw5akJOTGl0SlJtS3h6ZHVrelVJSmdJK3A3c1o2M1lk?=
 =?utf-8?B?TCtOQTcvdFlPSzlTT3ZmZXF1eEtiZEM3ZEJwWEdqL0h6ODNOMC9EdEZ0NTN0?=
 =?utf-8?B?YWVVOVBDcmhKaWszdVUwTDRNWElMQlpOamdlL3lIT0NTblRCRURKWm1xcFVZ?=
 =?utf-8?B?N1JTM2o5Y0U5Y1hzc3ZYZmh6dDRrbDcyOEJtampIVmhtVUdGc0NXbDdJQi90?=
 =?utf-8?B?cURwZzlFL2dMWUdIUko4Nk9NYyt5QnEvMHFmYTlsL01XL0FGTmZydkF5eGY3?=
 =?utf-8?B?dFQ4NTgxZk9TZVZ5ZWhmV2hpZG1IbEh0dmNpVXRtQkpCOGtCSTJnZzcxWk5z?=
 =?utf-8?B?alRzOElKaFBhM0dvSnBpSGp3WVprM2pacldMRkdlVWZ5K3BiaWR6MEsrZm1u?=
 =?utf-8?B?QzE0czhXeXE1VEJGdmZXUXY2ZFBpaldvQnFyYTJWOXRDUU5ESVZ1U1M0SWZH?=
 =?utf-8?B?eCs5djNjSHFOSzVvUThQbXh5eiswOGJ1Qm84bDZqcGxhcTM3bFpWTWRJbVJh?=
 =?utf-8?B?TW91YXZHcERudHVJZkltVmVGRGpzMFhYcTg3S2ZtRys0QXNVL0MwOFVhSERL?=
 =?utf-8?B?NTI0bHI5MWFkZEV4c1RBUXh5WllsWnRXNXEzQzRFenVoWkpQYTVtT3dIU0Ix?=
 =?utf-8?B?NnpiUHliUkVPQUxGc3ZCeXhzU0R1a3FwVXNjOHZtSEpDTFpaaXB5L2JsNkNW?=
 =?utf-8?B?V3Y3a2o3OU52bUt2UW1nMkNNZng1Yll6R1hkenlaYWgwanBmdVlZeU1rbVVo?=
 =?utf-8?B?YW9Kd1pZVkdlS2EyL2N3Sjd4SDI3bzdQTURkN2hCZUs1R0dxWnBXTmhxcTdX?=
 =?utf-8?B?WmtGTEV6ZkJDTUVIRnJ3cTNiWGtNbnIrZDBuRmZOR1BNYW5YK2NLOUdUOVpV?=
 =?utf-8?B?T1ZvWVJ2cFB3VzdZZ2hrb3RlVXBHNlFXMU0xbVNrNmw3VjZhaldWRjBqNURR?=
 =?utf-8?B?SkpUWTBOdkFpSlpWTFBDS25KQW1VNVFlK0RmQWZxTHlUZXJqMEdidFZHb1FO?=
 =?utf-8?B?c205aWZaUXpoWkZaMHAxd0ErVGRIdVlMOStET2JuMlVNVm5lWlljdUNnRE1k?=
 =?utf-8?B?Tjd0cVlKKzVEQVRmSXBpWEw2aWpYVFBLMFI1Uk1SN0I2b3NrWno3TU1wb09o?=
 =?utf-8?B?b0dxQ0hVWld6NjVhRXN2SitPY1hYaUNGZ3Y1YXowZ1BpSVZzOGltUVdYeXNP?=
 =?utf-8?B?TUM1Zi9EWVV2NTVjK2h4Z1h0cHVUNCtLWDc1NFhnRGs4Z01iRDJwcXo0LzhX?=
 =?utf-8?B?cEVzTkI4SE9oZnhSU0QyUlpOY0N2bFVZZGgxWG1WRmFnR2hKWGlKaXdJbTcv?=
 =?utf-8?B?OHdTSkdwbDVvNTdVL21nZThzcXRNUWpPL2wzUDFTV01YcEdzR2FtbisvaWhM?=
 =?utf-8?B?V2JDYjJwZ2pCVTNSamEwQVNvWXhZaFA2NlkrZ2dHTEFHT0Y2cG55OXdFVVkw?=
 =?utf-8?B?aXVnelg0ZCtyeHZ6cStleTduNWs5NkNHelBkSUNFTXhxaVlXVDFBelVyQXl1?=
 =?utf-8?B?cytCMVpVd2Q2Q3hvb0YzWFpqVFdld09ZbVhkbW5pZ1BwbC9La2xydFExR0V4?=
 =?utf-8?B?N1ZjRVdrR01lbEdaZWRzQlAxQlp4UWRDSkY2enlnYUlqdGpRS3hVZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9e2128-6fe2-4530-8cc9-08deb68574a8
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:35:43.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XguafSFfUWiFpUqUvR9TaAajbljNHpeGu2SbwWYCXaa4XFfsm7z6pPAqsg4KgD1iQvpKOgk2bHtEpeYq4w6cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4045
X-Rspam-User: 
X-Rspamd-Queue-Id: 94D13C000A
X-Rspamd-Server: rspam06
X-Stat-Signature: m4u4k9kiq81cwt5ytbmmkned1x6ztxu1
X-HE-Tag: 1779291352-308827
X-HE-Meta: U2FsdGVkX1/GXGjBn/JyZoLhTT3a3JgVhBm6jKsJ5tEyjaOmIPCXGyB9nUeG+ONWAM30EVkvPd7XF6r/Xw2fJcki7abRaL0Bpjc0T1QNxK6G3hxGO3mVrhpIrQFtjV1cLG/w8+C3Fb7SYBYQUc7WgBXOpkZzhnPxR3UN2UW88vjPOL0SPyp/Pwu84Xmr3xJl2FN15xkIHz9k6bByqiyVRln+4pA7+dirf1z2saxfnyHFVJ8U2fNK41WPkkFE1Mu7MPozLhVQl1MxYFx/X1RPJMkMtVN75h52VuvYAIA9c5qc96GsFkmzKzVLBWoKbCqHpjWNC4DasbAxWwTawCRzwJUEKkAvooX6Q30q+NgKJA+uylrKFVlxW0f5v+dCTrBs4hFHIxVPrLa5j3T/QTNy23dyXJd8TxUth6fRCE4peg6YwVSi6FDaBRuhfEx+emI14/jGT2hao6fTFNh1bSXGgp9MiuC+Cz2562sUF7TGNMww47OOV7wNKHG2BeP/pcWPbTVzSth7de4x4N5ltIRgLgy5txkGXsPgi0yheg5/M6DtXwXwWBCSV9CQVHjljNV5ByAKlGV0I5dPRlZPXnH0vGtaJw79td/LXnciTeOssHADL/xsuJS5SXgFpoX7MZRCeC6wf/0RSXeH5NwcpfQQ8G+Xjpp9sVDi/An6LEFKtGgalpEUFnHj+vYLYhgip9JkZdqFa0ntMeSCYh1qSTu+V76OqYwF2BYz5vFnwiOXsNoMWMAKP3A/vhf1Y3K7Ddug3rcgEO6xMba1JflRr2MsQeyf4yFpVkpj/qEKP9yvbq6Osl3wTOHY7Z3h3Rk0Jk8aeVrHQX5BGIpVtXQHpS1zAVQ5E5f89F5vQ/z7swPCYsipD5dXl8LUdjkOGTtoZS5WTKpbkZhcoMX0vnoPx5Kfp76eRmV7BaW+BQ4LlcFRrHNuEov0Zy8GMSy8LGlg+6EHUI1CXI2uAvZ3UjKiA82
 upjwFnwC
 o7bmJdiYvb2pyfdGLazqtNlWgmB+Wu2R3aTWiD4UckXnUSQYIGI58l184drdCPm2nTJ6Z2IIJXzlc3WGP30wrYUp0p5KIv7NDOd31eaOgFQvS0fMZ2D5ODxOvYnYK/r3rp9OhnlMt3ORF5jRE+Uxq77XAlWdc+NeJfRFLX9CGY6+SSL9fW/n5s6alwFuC9getf9QLmu5gDGD0kh2Y5hqX4JF+wty3qjRrs87HIhcbAttbdeS+vumLd9cCkf6BvFWi4ia0GmvUTwL6RafIJEvbVxjpqXCQJJE3JQPn/xCSfMg9+F0PpTE5vP5JR9KcgbzzPsazpfYySe0nI8r5WDEOi0yd9GlWpevrYKGauN+DgpkFcwPWrt/u7h4wDR8Dvcu2mxaGZHADVD/jNqQL3dQ9uv4jjlDDqpuyxHI5n7M+aHwlDDiGL2bevjhPN1nAL7hE2kF5XMQgpJWhjrWKxKQmxAgiUZgP/wMpGe+epNLdf8uHNKI+OQuOF5nagXT8ScGba/1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 9:23 PM, David Hildenbrand (Arm) wrote:
> On 4/28/26 17:50, Shivank Garg wrote:
>> This is the fifth RFC of the patchset to enhance page migration by
> 
> Ah, this is an RFC ...
> 
> ... I suggest b4 for patch series management :P
> 
> That also explains why patch #7 is still in there.
> 

yes, started using it :)

Patch 7 is for testing only but I need to think on optimum batch-size for
offload which depends on HW, or have a callback as per Huang Ying's suggestion.


>> batching folio-copy operations and enabling acceleration via DMA offload.
>>
>> Single-threaded, folio-by-folio copying bottlenecks page migration in
>> modern systems with deep memory hierarchies, especially for large folios
>> where copy overhead dominates, leaving significant hardware potential
>> untapped.
>>
>> By batching the copy phase, we create an opportunity for hardware
>> acceleration. This series builds the framework and provides a DMA
>> offload driver (dcbm) as a reference implementation, targeting bulk
>> migration workloads where offloading the copy improves throughput
>> and latency while freeing the CPU cycles.
>>
>> See the RFC V3 cover letter [2] for motivation.
>>
>> Changelog since V4:
>> -------------------
>>
>> 1. Renamed PAGE_* migration state flags to FOLIO_*. (David)
>> 2. Use the new folio->migrate_info field instead of folio->private
>>    for migration state. (David)
>> 3. Fold folios_mc_copy patch in batch-copy implementation patch. (David)
>> 3. Renamed migrate_offload_start()/stop() to register()/unregister().
>>    (Huang, Ying)
>> 4. Dropped should_batch() callback from struct migrator. Reason-based
>>    policy now lives in migrate_pages_batch(). Migrators can still skip
>>    a batch they don't want (size based policy). (Huang, Ying)
>> 5. CONFIG_MIGRATION_COPY_OFFLOAD is now hidden and selected by the
>>    migrator driver. CONFIG_DCBM_DMA is tristate. (Huang Ying, Gregory Price). 
>> 6. Wrapped the SRCU + static_call dispatch in a small helper. (Huang, Ying)
>> 7. Requir m->owner in migrate_offload_register(), SRCU sync at
>>    unregister relies on it. Counters are atomic_long_t to avoid lock-order
>>    issue.
>> 9. Moved DCBM sysfs from /sys/kernel/dcbm to /sys/module/dcbm (Huang, Ying) 
>> 10. Rebased on v7.1-rc1.
>>
> 
> [...]
> 
>>
>> OPEN QUESTIONS:
>> ---------------
>>
>> 1. Should the batch path run without a registered migrator? Patches 1-4
>>    are self-contained and use folios_mc_copy() (CPU). I have several
>>    options like making batch path always-on for eligible folios, or
>>    giving admin an option to flip the static branch, or keep the gate.
>>    I'm leaning toward always-on.
> 
> Hiding that detail from migrate.c sounds interesting.
> 

Yes, will do that.


>> 2. Carrying already_copied via folio->migrate_info vs changing the
>>    migrate_folio() callback signature (Huang, Ying). I went with the
>>    field for now to avoid touching every fs callback before the design
>>    settles. Happy to revisit.
>>
>> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>>    only. Some are latency-tolerant, others may be not. Is reason the
>>    right granularity, or do we want a per-caller hint?
> 
> Isn't it sufficient to just do it based on the #folios or sth like that?
> 
> If someone migrates a handful of folios, latency is likely more important (and
> batching less beneficial).
> 
> I'd assume when migrating many folios, batching could just always be done. Or
> what's the concern?
> 

It could be a requirement for some users who want only specific use cases to go
through DMA offload.

I agree with your point, and will discuss more on it.

>>
>> 4. Cgroup integration: How should per-cgroup be accounted for different
>>    migrators (e.g.: any accounting for DMA-busy time)?
> 
> Oh. Do we even have to mess with that?

Probably not for the intial series.
Will drop this question.

>>
>> 5. Tuning migrate_pages callers for offloading. For instance, in
>>    compaction COMPACT_CLUSTER_MAX = 32 caps DMA's payoff for compaction
>>    (V4 experiment).
> 
> Is that HW dependent?
> 
>>
>> 6. Where do batch-size thresholds live, and how are they tuned? Per
>>    Huang Ying's split, that policy lives in the migrator. DCBM has no
>>    threshold today. Open whether it should later be a per-migrator
>>    sysfs knob or hard-coded; probably clearer once a second migrator
>>    (SDXI, mtcopy) shows the trade-off.
> 
> Again, sounds like being HW dependent, no?

Yes, both are HW dependent.
Batch-size gating fits naturally in the migrator.
For something like COMPACT_CLUSTER_MAX, would a callback from compaction
to registered migrator is right thought? or do you have something else in mind?
For initial series, I think I need not mess with it.

Thanks,
Shivank


