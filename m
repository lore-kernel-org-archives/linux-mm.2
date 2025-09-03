Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41DACA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E578E0011; Tue,  2 Sep 2025 21:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F768E0010; Tue,  2 Sep 2025 21:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306F18E0011; Tue,  2 Sep 2025 21:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5318E0010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:21:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D305013AEA5
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:21:20 +0000 (UTC)
X-FDA: 83846185920.21.BABB98A
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB2601C0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:21:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mXMHONSw;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756862478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
	b=LLxigoJnhwQaJ9faoUKrXoJeur/1reuBkq6peusrC7x7cIteRoxrVrB1BRUa9cVQZJpxZg
	Iqrv1hY8xaaGRxSqnGq5y4iLjavL3lT84tfiluVu2WZeJlSMmr1lpwgIRyV6BcaoI3GlSP
	L1e844HJVIt4Sj1+pMEJaehVVHsBo7g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mXMHONSw;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756862478; a=rsa-sha256;
	cv=pass;
	b=LwmY+1HVSlw4yyl34sP+RI6wQC2BbfVlF9BPgHwxu3Sh3wMSzJ4/Q+Mp9bFrkPnVrYCwAg
	1Srg0wHAKUEdfLLg3g64i8cYBqWb3knefQ/GdgstxIv0wwe7X4E0DEOtpB8a/oI9hnv0s3
	Xokdyv8JrAXMh6ecT262F5oRFWkcIqY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwBevzj6ZCWtCAIsm2hIo/79aa5w+T7KuJ7aatTn8T4jkybnNWEmIVBtRvRis0jJChqYpoN9My6hpBva0hHwmqzmA3OjDQ5nZKzh9BGuo/I+Q7TvkHg/dI/Syy89k2MoQtlINspbQ9vQ2OjzmzWJy73FE/xFakGxCqmTg56l4GifwnIQWeq7eMp1/J/4gSjWpGn5rOtcKNAu1EkMwLuxV0NPCWEGui2M4GdJTvBTn0A7ADW4kYpu51POH52Y8wEHPiOLzmfQyzTLyD2b05vAUyxHWmw23JjQE3mcAEm8KTNY0b41PModRwuVnSc5ipgeIQFvyIlKgymzi8n+MEy4Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
 b=vyfyLypV55oT9ZRepbeoQJPKZamiecoRfQ2MTQ2nZ+7sOSrTpp2fzgOJCcVUHFMxEYXz/d38u8vaP5mxAQmcvc37yPge8SUJoDIExZ/xDhiHIJvYoors16tZwmt6GyE5j6ZN+vXxtQNcDadpH+4ZauWcBeljRs60z1bE2LqVpSK6JDkflHAcwcLKMWe4QZHL1HzQkPHA0ngjxq9UeQwCjOwiR/Nr7Puuvwf+HdiT4Itywr0whYGem5WTw+1DADAvhdsRl2JzLWqDxq01ZqccdxWWBtOwy9AFSj/gbn2ZiOGs+xDCRVQftOyXH1rZ6grdc8Hq+jqRZkuQv0nhdkJdtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLRnZ3g14MH+A0H5eZGV2PREorZoUiRXRp7IIDGKm18=;
 b=mXMHONSwlUuyuyKBitK6fcIPYlIEJcYYQWcPJK6eiCTOBqTT75bOKA/zai7gu63qgBu1HmgnYs9Us/QUsPDw6o+240FlbQrOHYWBH+Vc2/TgkU+9dQciabGrCA+4SukfGcbDk3TRuMLJokvY/laE7I3jnClUuadPrxa6oIBwNJsI2lJenTnUAQN6s6CaFC7h+YrRlHAo1VNJjJUlI3nSjdCnw/k2pbvIBlIhduKtZ3VArRfDgvBWxI65pN3KZJXkNrD4v2g3qwrdJn3fPNuHa7P/ikMFf1CD8bCKy4HIfwSqGmr/Vc8Uoxgfu2fY4PAvNE5eI2BR+NS82ky52xpWMQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 01:19:36 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 01:19:36 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v4 01/15] mm/zone_device: support large zone device private folios
Date: Wed,  3 Sep 2025 11:18:46 +1000
Message-ID: <20250903011900.3657435-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903011900.3657435-1-balbirs@nvidia.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0195.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::11) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9953587e-3244-46da-db71-08ddea87f20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmhlY3F5ZTdjMm5sVEswcEtOQ3JDVHpMa2xxakx4NmlOZ0R0S3lnSDFxc2NE?=
 =?utf-8?B?a0xEVDJMbUt5WWFnMnRFTFlIbzc2RWdCQkZPYVprTmxHSXpJMlRnbiswTWhH?=
 =?utf-8?B?cngzdHV2bEJOSEh1NHhFckJuN3pPMVhveHVYTlBIT29adHRSeEkxSENjUUJD?=
 =?utf-8?B?bXV0bE1jWEs4aHZWd2V6ZFl1RnRVZ2pUbzhHSXJjemZoc3BqZXNPQWIwMHV4?=
 =?utf-8?B?TktaNUtUdlBjZWgxaEZRSTN3blFmaW5BTmd1MkFsQzZzbmxua0pvM040SUhu?=
 =?utf-8?B?V1ZIcldERm1USlBmVmh1Q2hrTWc2ZFdlMnhjcFRYdVZqc0ZBZ29jZzBmeVpR?=
 =?utf-8?B?cnkzb3pWa2VHNHo5Y0VXV00zNTFkMjFvRVVSRkptM04wbHNwS0t4bStLRkx1?=
 =?utf-8?B?RGNJNUlLYjdRVWtDYWRjdnpteDBPL0k5cW9YbVlBK08vbysrU24vKzNYNjFs?=
 =?utf-8?B?ZmtkMzdMSUd5dUtaRGw1V3dSK2Zzam53ZWVVNmQ1OXgvVXdMMGxMUG1qdFpr?=
 =?utf-8?B?T0lwWlZjc2pEOHNlelU3cUt1TFUvS3NPWExCWG83VE11OHlJOGl4TUNZYVc2?=
 =?utf-8?B?YVR0Ymk3MHB2MzF0dGNNdTlFTTRDYk52ai9kZFdmUURsNzZFMzBKVWxlcTdZ?=
 =?utf-8?B?WWk5aWVXNk5zQ05lMVdhejFpamo5ZnRrU3BhTVA2V2pTV2tSYkJSaW9rM3Nh?=
 =?utf-8?B?YjUxTCt4cmN3MHlkb3NZcG9oY045WU81RlRwSk9BSmxrT2kzaWF6R1ZIK3Rv?=
 =?utf-8?B?VTdMK1diYTNqZ1N4TWtZTVl0MjR0eU44R0FVZUJDZjUvRllvU0h6dklLVWNL?=
 =?utf-8?B?UVpRcGVYZ21RYWUwYWtLZ05ya3N2S3YzWTVVNHNyb0VjQld1cFM4SmZnMkw3?=
 =?utf-8?B?a3h2VmUwOHFFeHRveHNKYjNjeTlVOEJCd1J2VHlGeEJnU2k3d29OdmttdFR1?=
 =?utf-8?B?eFZHc21LUkJVT0JkUjFndGllZFJGWEs0d0Y5OTUxYnk2RHpEWll2RlpxYTFa?=
 =?utf-8?B?YTFqSklZekJSWXc0NGhzRVV2b2MyS3V2d2xlcnhQRndNeWlVMGg1Y2Ftb3do?=
 =?utf-8?B?ZjNldTVLb3lPS3A5dElSQythRGVQb0c1M3loRytXYWd2NFRkMUhNcmJXa3NV?=
 =?utf-8?B?ajU1OUVkcFQ0eXB1dEtseTJEUENnVU0vUlNic1lCQmdEQTByUlRkaW12Ui84?=
 =?utf-8?B?SVNkRG5BRHYwaHQvMDVrNE55Vzc3SlU4Vnl5OVVCZjJlejRKOHJDd0ttL2U2?=
 =?utf-8?B?MTdkeG56dm9QSHVCNkQ2S1lpRGNoM1lWK3JkYktwWDJwMHVQRXBSVU5yRGJ2?=
 =?utf-8?B?MmRpRzlLZGN1dHdra3lUR2l6K0NybEZ2UXd6c0d5TzVQdkVURmhkbXVWdXBy?=
 =?utf-8?B?amx2U3hYSHFMbHI4cXFUWFFCK2NrYlFrZE1ibmNmNjZIWG1EbDE2MWFxUksv?=
 =?utf-8?B?VGczUFFzOE5DRElWeGo3b2t3dXpDRGlDaDZLU2YrZDlybXF0MjllVzZMOXVK?=
 =?utf-8?B?SElLMVBiME9KMDhKWGVwcjBoQXlwOElJR2RSWXZ4amVyTUF3VjNGaG9WQ3VM?=
 =?utf-8?B?UHpxT1R5c3ozTTdxQjlGRDdmZ09uNFJwR1R2ZzNVa0o2UlJ0NkJmQmorZENC?=
 =?utf-8?B?bzZoTytYSGZicXovT3B4ZTNnbHg4ZUlGWUNjbkVoS1NWdHBhNFgvZnl6YTVK?=
 =?utf-8?B?S0FqeE5nUWhia0xmRnF5Tk1sTThGQ1UxVzU3Ly9VcVVneDQ0ak1pdkxFcllD?=
 =?utf-8?B?WlpjcFNOSDN0S2dVem56ZnRBNllReWRZTlVkSEpwdWxCckViZTRGOUFsUTB4?=
 =?utf-8?B?Q2NEa0dlODYycWZ0bUdQZi9kSGVObGMxci81YVJyRW0wNjNoNzRVRlYzZ1Uv?=
 =?utf-8?B?V1oxWEdjdlprWHlEUkZZbFVFOTZOQTdzak1xZHJOTTRyeXFNWlVMSDVLYTVk?=
 =?utf-8?Q?7T/AtaY9+jc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEJabHpJb1lIZXZodEE3WWlOcmVKWFAyc0FMaVJkQzFtS2FiN0plVWFvVTh1?=
 =?utf-8?B?VTlTUEgzbFBFSmZvdm1XMVRmZ0FaWStwd3NSNVkxWDlYSWcveTJWNDN4Y2ZF?=
 =?utf-8?B?aEtEOHBlMkxOc1pZbFpZem5FSnk5VmUzRnpRQlRpZ1JxWXFnSXBxTlovdEFw?=
 =?utf-8?B?YzE4NW1XOWNDL253cnM4LzZjdWltelVHOHNET3pONjdYaU10SmRESUZrOU9I?=
 =?utf-8?B?WUV6WWtycUxad3poZnVPcmthL0VkcFZhZTc4ZE14eFdudGpaaUVrSU1FYnp1?=
 =?utf-8?B?VkdJeDhGbXUvcEo5eUc2OWZPamUwSWNTT0MvT2RzU3M3QjFRTTNpUkhaZjdY?=
 =?utf-8?B?M000WWZtUWRLTDZueFJkc04ydlVIWmR6akR4bEI3SERYczNRa1MzcXZBL0Va?=
 =?utf-8?B?aVBZYmo4eFl1NkV1dEd4dWkzV2JNdHQ4Q2hqcXBxTE5Rci8wN2xtV1hXMlJK?=
 =?utf-8?B?ZFhZSCs3NkE1TFZ5eis3MU83THVDVTZmWk1GKzFqbkhJV3o3RlNoWjZqcVU4?=
 =?utf-8?B?NlB3SWsvMzJnclMxT1gzYmFIVVBvcTdiWHBjb0YxWkd0Q3k5eFNMSDhYUzN3?=
 =?utf-8?B?d2dVckFxQTZHMWlkU3pQeFhzVkd2QURWM3hCQkQ3ak13Z3ArWjFhbTFNWFds?=
 =?utf-8?B?N2xvU01lOStvQjkvWWtoVjltcDFYeFdXYWVWSDF5RldzQ1hlNVQ0cjlsTlE5?=
 =?utf-8?B?ZVRJZEVibGE1dHY5dGdwSlFxSXhTZHBnVFhYbHk5d0FZNXFMSFkyc3hkcFVO?=
 =?utf-8?B?cXZ3OVVYQ2RCQjJ1bFRRK1pmdVRGQlA0L0pqQzY5SWZTWElVeXhBbUIrU011?=
 =?utf-8?B?cnMwK0ptUWY1TzZYcDRVT1pyN1dTaWFzdmRMV3Q3d2dIRGNwNmlhbmh6Ymsw?=
 =?utf-8?B?U09kMmpVd0puTkVZQmhuYWVwMzJtK3c3eGZTbDh2M2E4aWx4eUZGTmxMVlNu?=
 =?utf-8?B?WnJYUXdXSzhDdHpYbzhZeUhNdjJVR01aNzZreVpjS1hkeS95d3N4b2RtbklI?=
 =?utf-8?B?VWRFVVAyR1JvVDZqVmpoT2tVRXJvMmRxZ1hLTGptN2h6VHZwRENNS2wyVTRJ?=
 =?utf-8?B?WW1oTlVUV2p0TVJNcUxHYTdoRXZTcFUrVTFZTk9rK1J5S2RVUXpsbnN4cVV2?=
 =?utf-8?B?bmpMcTNiSDdhR0hhTEtTMDN4c1dCUUVvNU9sTzFDMUVEaHNObmVJME9lM0Zo?=
 =?utf-8?B?SkdWY1RWVko2MjNGQ0d5V3BtQ3lVZ2I4VkFwOFFWUC9jazJTVVdBM1lWOE02?=
 =?utf-8?B?Ty95Z1NlMVZ6SmNCQlQ2S1BocERUTkJUZVVJbmd2NWdERW5UaTVoYzhmZzE0?=
 =?utf-8?B?V0dKcUNKa2hKRUZJcDRUWGFWWkNmZ09uVTJqS0x4VGU0Z2FvTEJ6SXU0THlu?=
 =?utf-8?B?Slc5OGVuNUNCeEVzT0ZoaHI5MC9SRWdUTm1GbHpPdE9lMmhjMTRvdGp1L0t0?=
 =?utf-8?B?bTI4ZTBWNzZmTGZCTEUzL292enUxM1gvbnZ5MkNoNWlxcnFNWmtSdWM2NHdR?=
 =?utf-8?B?TXFhZzFla0VzZ29OVkFWM3lZTTNPT20rYlFSRnVUK0NuZ0hUR0k2d0U0bFhH?=
 =?utf-8?B?Y1UwK28wck4zYXdOb1hHZVpUSXZGUzBXZXRhSU5nS3c0bEJOVS9sdDRkRSt2?=
 =?utf-8?B?YzdRenRSMWkxc202d1NaTWJNRXN5S3dlaHg1QmRUME1iLzZqSkdZZHVtak1n?=
 =?utf-8?B?N2FJWGg4UzY5MDM1ZTBBbDg2U0RIeEFNbGh4Zk5NNno5SVhnMGtVQk1jTjJi?=
 =?utf-8?B?c1NhaWp5M2xTTFZvOHgrRXVweW51WGxjN216UEw2TnFxNjM2dVlxWUxOcXZt?=
 =?utf-8?B?NzFOWEt5SDRnKzJtdlVpTkFqdHFCQS9YUEF3S2l4Rm1RRmtVTjNtRnprZnkr?=
 =?utf-8?B?UXUrWXdudFBKcGxNYzl5SmZ6SmcrUEpHMGdkQWIwczU4TDB4WW9wRWJBMGd0?=
 =?utf-8?B?a1R3VlJnM1VpRWJidlhidGZ0d0tyMGszZ1NEbEg4QmVIS3lsZ1M5NjRKUU5p?=
 =?utf-8?B?cXpvRTRwMXQ0ZG9ncnVNT2p5dnNVdS9Kb1RrQUxLeVBEbWhRODBnSU1jTm1V?=
 =?utf-8?B?OUVzR1g2TTdrVnhwOVdGb3VKQmh4N3lIMzVSQ1dSSEVGTU81VnBOZlROalVJ?=
 =?utf-8?Q?0+W/MZEvQD6jXoJnal2cyYaCP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9953587e-3244-46da-db71-08ddea87f20b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 01:19:36.0415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQbLa6wjfTR8Ot/95Cy5gBIumyqh2tF0bRj6Jnnbja+w7F0yRO9hKw2KwBmRKOuuGLQ2MAhaEfc/jwUkGgR7vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
X-Rspamd-Queue-Id: EB2601C0005
X-Rspam-User: 
X-Stat-Signature: njk4zg3mub69ui8nq89y6naq4euzaomu
X-Rspamd-Server: rspam09
X-HE-Tag: 1756862477-714047
X-HE-Meta: U2FsdGVkX1+pCP5tXkRykZ3acVmuYfRocZfpucnI8JQFrYKrbGL8M1F56OlUqYJIjGpwKctHoOmvb9OIGuG/slknVeiYBkVrJ6VEyJKnMqqfMl6Gv7C0DuLJSpXEi59hkByiGc6gUcLIjMhce/WkNSO87q2mp6AdTGWF/9Oth1UAPIUBSIZ0F3M7+6a0E238LNquYGDFpUoEb24PQHN5ZPXjcEJp4s/GniGLdQjB+kQp+E3DIYvj3B3tU7kDNfdA6IMc41sN0mJlpudyL4O5ElixijKRn02nVwBgUtxBFwBRBWwb9gNXJh7DuzQXcB4fvyyqlD2mkwi8HMh+JqsCC8NwfgjKyZi6803WRIZPXhoh5eKt8JFQsoTou5GNaB7LLamnB+0We18nENlgfkS5tMCh/JQD++Y0a5paWbFIyCnbl3y2f8ZoOhRcTZR9RPKwUl0hRv31U9kRawFNEfN7TcGQsXrLklg0scl0WjpGSUhcqEURc6ZAjilV7KEzlTBDsIknJFlcYreoTY5PDuEzZqr5aKdPqzJhSoDn8I3u/1C6aeVX1si9I0//97VRhAxwcCm60fukSi56P1fO/gLZ91iCqN8ilZS7FXt7J2B29+f2hZtKOxY5WLapsrOjii8hTAgtVucKk82T37+So/razvuRR+NA0wiIt+UDLVusy6Dg5s72K7CdSoRgwpfvtDwhEMdpXCZMZ21D3H3BvPH9+2RooSFYYXq8VsYKF8l479189zojHqyLiEOQnwqvzmvXSzAQJCd/lqFEVQfw42jSk3Fs5KVzZemDLeSIPxptcCSQYcxkUnQi5cI2TEdUFoY+q734EbL4GqcXmJSNk3QhpGE1mkjFEcDlARA8JH5tEUyE2xnHOcz6b/P1uErel1mUPjYYQUuZNbdQgWrpG/k9qebiT7BPNaXOYSufhR5TSse++Zj28JlDsiIg0roHwW8R09FiyTqrGgUXyiu/clg
 nGOsNU/h
 EF2UcmKxHlFMEPfe0Fj5QYJj0PZByaW45GaWwffoVxrRPhNCsisN9dYgAGmm8shj3ETIoErqLUyci0WcQITwCl51C25qHO4sMLmC6vIy+XlZ0a9Im0HNBS3DPJlQx5T1huAdTSQta1wrkLPCfpNZcjsnopWkKXfBOotY8zGy26WrK9ixsHljDMg75nD53ehZ2bPfFgKWUqeXpLJHdhkrNFbWvKI/tVi4ns4f5Qlv9YBFWSzkxRiFGriljxHy6TkGr84xDwcbZnLoyU/2XyI2mCOJd4HNH3rBSfr+UVjqlkdGjZLSRwtyeybT7CBix8ClVpkEa9TgNaQPoBl95Oo2Nx8Htmh6mu5U92Hg4Nu810aHtZoTsHNQQUQ+0LUJM3M/vgrRHOTSqslnMNT8Jnmh1ky0BRNWS8O3yNPEP/oqlmBZ/8NBo54gfPmAPRofqpOQNM5ZLI6+WEofXTPpgco+4s73z9RWI4z0twTegNinDrQoG1Jlrb34pIoMOD2jPQ+wW1oBbQ3erpBc9RLe47dlaLC5nXhZVn/DRCokQ8dEV3KuNFc6m3oEk9MUhkn7X1rThx/cCYatoi/ZKQKG6wfn5Xzwr0T54WQte4ffzAOKYsGuXrM3Gm0ana9U66nTaMXVUpIVzCYcFbdwAmlbOTQU9/5Jl8LsaYwT+zVZj3LjNUD2AvsWTu64dDOadTPthg5YcvqKLezGb44022Zzhu/anpiKtwZT9U1YOjJJemAWkfsiqDNtjomQCM4dMTXApyA3+uI7wPAdn8kaIL6emWslPyAhk1vlZm2nj3zHsqz1eLZX5ktcUo9JP6qXPUih+3nwlTRpvdtJcnAA+5xIodSII3DIEvjk3bAZyaY3nyCLLO8ZKzIfSBS3kX08mnj679YEaVlak9MgeQHB9HNJ0PVlG3zcN3un+1nzIwPJEhhuB6MvjSODC2mvVXryPdCyy5Ew8otXTL7nTtTTAspRDmYU7m651w4n6
 LH0kC6ti
 MWa/ElAko2ZpKUT2GMeDJds3lqxCdvwCI0ImoKdrGqgeWeqzajC0jlvPKnQT8q9aafxCyYE8Ctq4ZCuvCxVSo4FnmqkppLtCXxtHSF8TApwgfB/dnXdf7QTygzAyDdhuwa5C/DHScyhCS7oTIpEGHqDrYmsYaQZ3ZsMdUtWnwvWmKEwsrLHNK4oNY8GnkfAY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add routines to support allocation of large order zone device folios
and helper functions for zone device folios, to check if a folio is
device private and helpers for setting zone device data.

When large folios are used, the existing page_free() callback in
pgmap is called when the folio is freed, this is true for both
PAGE_SIZE and higher order pages.

Zone device private large folios do not support deferred split and
scan like normal THP folios.

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
 include/linux/memremap.h | 10 +++++++++-
 mm/memremap.c            | 38 +++++++++++++++++++++++++-------------
 mm/rmap.c                |  6 +++++-
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4aa151914eab..a0723b35eeaa 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -199,7 +199,7 @@ static inline bool folio_is_fsdax(const struct folio *folio)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
+void zone_device_folio_init(struct folio *folio, unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -209,6 +209,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
+
+static inline void zone_device_page_init(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	zone_device_folio_init(folio, 0);
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd..13e87dd743ad 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -427,20 +427,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
+	unsigned long nr = folio_nr_pages(folio);
+	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
 
-	/*
-	 * Note: we don't expect anonymous compound pages yet. Once supported
-	 * and we could PTE-map them similar to THP, we'd have to clear
-	 * PG_anon_exclusive on all tail pages.
-	 */
 	if (folio_test_anon(folio)) {
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		__ClearPageAnonExclusive(folio_page(folio, 0));
+		for (i = 0; i < nr; i++)
+			__ClearPageAnonExclusive(folio_page(folio, i));
+	} else {
+		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
@@ -464,11 +463,15 @@ void free_zone_device_folio(struct folio *folio)
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
+		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		pgmap->ops->page_free(&folio->page);
+		folio->page.mapping = NULL;
+		break;
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
-		put_dev_pagemap(pgmap);
+		pgmap->ops->page_free(&folio->page);
+		percpu_ref_put(&folio->pgmap->ref);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -491,14 +494,23 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page)
+void zone_device_folio_init(struct folio *folio, unsigned int order)
 {
+	struct page *page = folio_page(folio, 0);
+
+	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
-	set_page_count(page, 1);
+	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
+	folio_set_count(folio, 1);
 	lock_page(page);
+
+	if (order > 1) {
+		prep_compound_page(page, order);
+		folio_set_large_rmappable(folio);
+	}
 }
-EXPORT_SYMBOL_GPL(zone_device_page_init);
+EXPORT_SYMBOL_GPL(zone_device_folio_init);
diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..b5837075b6e0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1769,9 +1769,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 * the folio is unmapped and at least one page is still mapped.
 	 *
 	 * Check partially_mapped first to ensure it is a large folio.
+	 *
+	 * Device private folios do not support deferred splitting and
+	 * shrinker based scanning of the folios to free.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio))
+	    !folio_test_partially_mapped(folio) &&
+		!folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
-- 
2.50.1


