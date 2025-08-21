Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B378DCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527D28E0010; Thu, 21 Aug 2025 06:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8628E0003; Thu, 21 Aug 2025 06:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379188E0010; Thu, 21 Aug 2025 06:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9E88E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:24:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91EC0B8005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:24:17 +0000 (UTC)
X-FDA: 83800379754.14.85626AF
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADDEB4000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:24:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hEoGC+b6;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.67 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIf7CbBbltScwi+P54axotgCldu+ulOSNxURut1tfzQ=;
	b=orpuuVgmcjJqUsJOLdFR+BV1t1v5H7eDZV9ckKmBT1I6j0dQYH13OT++72yLlA9V0gKAL2
	Rjp2VWgo2p8DydWQdV9hB2g8db5gkdeqprKeRyMudwbLpOARsi2x4vAQKxvqUIVdAz27nE
	G8tYZ5+SPN4+CVZP1PZPJLWO56eEU0g=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hEoGC+b6;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.67 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755771854; a=rsa-sha256;
	cv=pass;
	b=fNc6oYGu+xSEHZb4++xjH6snJEI+jk9YL4Slp8LQtgsROp+2qLi+99lzo6tsE7Km8NckQJ
	jk8uMUXPSoa/RmKAlMKUBiRiXizO6q57vvnOTivKXxaGTmzIgBKXtjdFD0gADIDnV2XHBp
	UyVegGBLaj98qvkO/a8v6Mnna2mi/sg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyT5t3yfDOEJD6fofq10FnEuui/V7G22qyTbPVjCjVYkrOzym17hl/2WMRAmStNA6pEIPnVl6jbHyoJlSGKVwi/ZxliqAq04PxwSUFjjj8dDuKm8D6xbvb0xO0kDm74xgtORfl/smxl+KKrQm3uwDCkl5rvYssa4yXjDWum9c1rwt9rk6KwewfOZ9B941wRVZ+1IERPwTqBd8lyEx2VLJ/NwLPctYkTRz1Yx9Wcs8+5wlfw0xO7cI2g4k0kcpKSymv/RsW6nf4g9Tn8nbiIIGDdSp6uhKgrsPQTjnqATX9yvglFrCeU2z2G8YXvJIbqSvZcla3xza0gev74tXxAICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIf7CbBbltScwi+P54axotgCldu+ulOSNxURut1tfzQ=;
 b=JOl03gEnt1PVGn3vNXG7W9AAe+JZjSyYFwlXM8bkVPH/t/O2uiNiubjfF8ZC3elI4+fDC0FmYPTbc2HxsQyVDNqywbu5p+wbnJQiTca9wihg9r1u7MwxsPFKrQr0HQoTX6/x7P8zYCJOX++qYV5ieFBViCSqT8KM3YMZ94Igt0VjapXYev6S4uffJg3/Pnc9f/mfRKTgZJikSlnud2pf15mde+BI5qXLzxTIYleTBLtCSJXfhgxEmWmHFjlfNyEJv1965J4JZEuqZcO1XXEEivqpZKRCw0kcT0xnvaUy79uSwG+bjdTOgBpfiBnluQyUIYWsBLG/2mXQCB05hqCvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIf7CbBbltScwi+P54axotgCldu+ulOSNxURut1tfzQ=;
 b=hEoGC+b6oWfo+DzjxeLFmkafGKUotm+pT5Mzqaztz2BMXB8Tnzs0aofkInP3u8ZcQnMPoVOOZPMufRQJPj7zpXjxtPeAyzsD6N4uuK2YkrVoLkpiup5nD7y+8bVtvrN1SP2ZXkUdNZvRcJ3+pqo1/jQradveGBQRltIr8pXl+0asfuUeViNAd3YYskAwatyY+vziwLaZtdHqqUTQeUQv32nR0EdClHmTWs4LDp0ul8WFxC1WXyatFn8oPcXwnrR/ymwWp4dYc1lYvVlf8Py3EoU0jF6zjAgdQm1nzaENKDIDNhQXHHOdNsm91s8YJaRH4IsNT8X3KxhbED/Gzc3W7A==
Received: from SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Thu, 21 Aug
 2025 10:24:10 +0000
Received: from SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::a970:b87e:819a:1868]) by SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::a970:b87e:819a:1868%2]) with mapi id 15.20.9031.014; Thu, 21 Aug 2025
 10:24:10 +0000
Message-ID: <e43b3eff-6d9e-4e6e-a0a2-9537e669aa82@nvidia.com>
Date: Thu, 21 Aug 2025 20:24:00 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
To: Matthew Brost <matthew.brost@intel.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
 <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
 <9207451b-ebd1-46d5-b277-2adf3028f361@nvidia.com>
 <23a3e9b9-ad35-4469-884d-279aac0868de@redhat.com>
 <a8732499-161b-47f3-a936-580a43c6f323@nvidia.com>
 <aJ55c8yrcAN6upp9@lstrano-desk.jf.intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aJ55c8yrcAN6upp9@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:a03:338::14) To SA1PR12MB7272.namprd12.prod.outlook.com
 (2603:10b6:806:2b6::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB7272:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d7276a3-5176-4827-9375-08dde09cddfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEtkd3lnUXcrend6Zm83UzJDZmRTY0w4RURNZmVmQy9uNkI3RlJrMDlGUC9V?=
 =?utf-8?B?angraTcwRTNvQWUrRFd3RjRjeC9zQzVCR1RLUGZKL3UzeVJUQjRFNDVaZ0di?=
 =?utf-8?B?VCtlREpKMWFsNUxYSSs2NHlzZFEvd0k2Q0dXTmVZRThSd2NJQ2RxVWp5Q0NK?=
 =?utf-8?B?R1ZUQlFDT2s2YWQ1czVvL1ovd3dBWUlnQ1N0bmhEVW9LUGRGRmNacStnWWFU?=
 =?utf-8?B?QXp4YVlrY2VvZUhTOCt1TlcxYVM1QVhEQnBCeHN0ZnNRQzdoVERkN2h6TmVo?=
 =?utf-8?B?TDVMRk8rL0s2WlZaY3psUnZtL09NK09DdmkxVjlOZmUyMER0ZjBHRHdEMEFi?=
 =?utf-8?B?MjB6MjZPOHlvTlVxanl4MFVCblcvRjJjRVFNbUpwRHBaV1FlSGFmTzBEaEp5?=
 =?utf-8?B?b1ZTK1RhaHNhYVpZb0RtTzBkUlE2QzdZWXlORWpXY1lCOW15bFFXOTVYeEY0?=
 =?utf-8?B?cDVncll2Z2lObU81N3hmaWEvemtMSjgxTEVCM1ZOVnc2ZDFRYi92S1FhMHkz?=
 =?utf-8?B?VytaQ1JGNnVxRlhEWmJaYVlIWDNaWEorWkRvK0NlQWlLVHN3U2Ftem5yN1Ux?=
 =?utf-8?B?QVZKME93cFBXdy9WZFBKck9nalpTRDgyRXhTMDNQT1AyeWpFK05jQjRaU3Ux?=
 =?utf-8?B?WDlneFROQW9GVmhkY3ZRV0F5SGFtcVE1dXVWWjErQmdOUVVBbFZ4NHRoZWxv?=
 =?utf-8?B?ZE5TUjNFL05TN3o2OVN5WW1aMmZGd2VWV2VCUVZYb3NUTWpaQzAzNmROVThF?=
 =?utf-8?B?TTRLWGdDLzNBZjlUT2RTSnc2bTJ4ZUNPSFp1anljd2ZkTGsrcFlad3FhWFpM?=
 =?utf-8?B?em91TGYwd1ZVUEs5UnhzZ1hORmNOZVRzUjlBejBud0RGZlVvS3MzVHFnTys0?=
 =?utf-8?B?dGlxSVltSmhKRG5WaDAxL3AveXlXNTdFOUZVeUJqUi9TcXcvUlQ2dmFSQlBR?=
 =?utf-8?B?QVBsRHZBb01oY0o3UkJnQzlaTFJjNEtCWFcrL3hYSVN5Y3JmTnlVSS81WXUv?=
 =?utf-8?B?MXg4elBSK3RFQkdBaFlFY1dkWHR6VDFVR3k0N21kYThISzk1Z0xtVGFBU0NS?=
 =?utf-8?B?bXQ0YWNhVnhodUtZSllEK3NPYk9sOVczZmNiL3lGRWkxWmtqaHpUb2NEVUo0?=
 =?utf-8?B?TUJVRXNyKzk2WENDV2JEUGdaeXRTcTRUekpvTGpMZDZwa1RMMFk4aWpLbWtT?=
 =?utf-8?B?NE1hQkRDakQ5TDNZdUNZY1RsNHRTdGRta3hBYzlhSUtQMXdUYUlEVlkxMkEw?=
 =?utf-8?B?azk2bTM5TVVjcm1LMGRvbzN0YW9uRFljTzRPdVpXb21RL0ZHUDJOalJCTjRU?=
 =?utf-8?B?RHptN3pCOFlVN0RIM2t5V3JWVGlsV0YyUGlQWTBkWmx0TDhSc08wdE5VZ2tF?=
 =?utf-8?B?Q0phZFdIRjEwZ1JhUktzaGQrRmVUN3VvTWdMd2xMQVMzTStWdVcvVmh6MFFQ?=
 =?utf-8?B?TnRUaUtNZmN6RERqcmVMdVUrY2lDQ0p3VGdUM2RKVFVDaXlsMkZWZVZoaDJ2?=
 =?utf-8?B?RS84eHlRajdmZHZiSXZXOEdEVEU4ZVpJdTV3MlFJWER6UWZGS0FHTTB6cDNJ?=
 =?utf-8?B?SEFUSk1UV0tlRWd5MDA0M05GeWlVM2lSaXUzajd5TkpucG5SclJHQmNNNzZy?=
 =?utf-8?B?NTdpS3N1T2dwN2xwWFJNT2dnNW0rTWJYb0VqcCtQTnZwczVUWTFpRzdGMk5j?=
 =?utf-8?B?ODRpSXkxcnRLTGtxQmEvckZ5bWFrOVVoY2ZqM1hXUFBpZ25VV2gvMjcwWHFq?=
 =?utf-8?B?clFsMzBVQ0xwSTVVMDV4VXUwVzdBdHhnMjhMSG5PUFp5RHZ1Ump2ZVJLdGZx?=
 =?utf-8?B?UlZUUlJoeDEzSEZ5cTlDVHA2QXcybzBETVN1WlBmWmVraDRWY1hUcnNQbEJC?=
 =?utf-8?B?WVcvbXRZWnRuZEtaR3AyeGJJN0w1cDNaL0Jzdi9JeXkwRTQycGJqZ0JrN1N4?=
 =?utf-8?Q?WIwZIYhauyE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7272.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTBjbzNmWEZOTkJITVRlWGcvNTdzSnFQS2lIUERiYUNmZ21pMEVvemZOamZt?=
 =?utf-8?B?U3N2YVRnWVN4SnQyeVZ1ZzZKWlFCb2FiSE9SQ1FUOGRVR0kvWDJNMmp2Rm81?=
 =?utf-8?B?Wmc3cHlONTBoN1pVR3FwWHo2R0dSbGhTZmNmY1BmdDU0aGtpSUxWVkJnc2Vt?=
 =?utf-8?B?RzhmUUlYcFdxcERubm5aN1p0WlJtUnliQ0hnL1BMRnVLRmJiUVU0bXpscUky?=
 =?utf-8?B?R3V5TjNINHlXWTNHN0JmS2Q2K0toRmYzVEljdC80bm1VVjRYeDFzdHdpVFJa?=
 =?utf-8?B?UmtjVWxjSGNDL1ZkdFdPc0lCSGF2ZDFlM2hRbVVzL1pIU1NzaDdNZHBSZGdC?=
 =?utf-8?B?cHJmTVlGbGFqVThxL3IzOUcwRDVRM3ptVzVsTElGSy9LRzBOWjNiOFdlYjA2?=
 =?utf-8?B?WERUL21ubWxiNkZGQTNTajFMY3BPSEJ5MWR3S0kxMDlGY1dWaWVOK0RicVBq?=
 =?utf-8?B?dzViRU5aOFUrVDJkN1gveTNkak9ySktJVjRhUW9tcVNmTXEyVDUxRFFDNUI0?=
 =?utf-8?B?MDVUcmVHQm9NYnlDbGpIM3JsK2dKbFRxWUJmMjNJa0VTNTBIUHZvcms1cHhS?=
 =?utf-8?B?SW1BeDRvelB1Y1hEendtUHV4S3E3b3kvSkJLSXRvS3pTekpWVGl0bEx1N3RT?=
 =?utf-8?B?a0ZRd09VK3FvQmxNUXlpTFdXeC9BcXFSRmprQThxWkRHNlN6L0xFbzUzVmlM?=
 =?utf-8?B?VTVWV0dEaExVenlZcU1GUkRRLzFyTU9mSUc0STJpelhmRDA3K3h4NTZ4UlpH?=
 =?utf-8?B?M0dYcXVJc0RqRnpEMER5cS9xbVRyRXlHcE5WUFVHUDdvb0Q5V0dZUTBoK2ZI?=
 =?utf-8?B?OFQ4V2hOamh0QldFdENUT3dkVm5ENmR6bmVXa1FLUXRWbFUxelE5UUliYmFh?=
 =?utf-8?B?YzZVSHFPVDFoQ0Q4VjJVM3VoRFN2N1VSZU1FWk0yY0o1NHBLVjhzU3FZTnV0?=
 =?utf-8?B?cW9YVHNqZkNUUVFORzFabkVWaVUvNWFHdkJNUS9DU3A5TnRUV2dqNk1vZmJI?=
 =?utf-8?B?N3lIZjEzd3d3MzR0cEg4U0JNYU5qcFBXMWNOazcrSW5xUFFydWxacGtmTVIy?=
 =?utf-8?B?RElnT3JrWjVRM0ZhRG91d0xpV1VSMVVlYlNuZEtHYi94NFB2bWNLQS8xVGh4?=
 =?utf-8?B?M1pudzkxQk1FQ2xkZ3ZmemRKYnVzYytDRnNhc2xCRXR3WVRsUzdENFluSWRi?=
 =?utf-8?B?WVVVOUhneTZENjlacExpeGJUcWxrRGVIYkhWWTRDcCtNalNZb1hRaEFXcmRY?=
 =?utf-8?B?bU03MXN4bGREd3lkVHFLUTFwZ3AxdkpyYThaWU9CQ2VhYVRXV3Q2cGkyUENP?=
 =?utf-8?B?RVd3SzlBSk5KeGVuNlRuZXNvK0lLZ0sxZHl1M0xIYSsyekJnK2hqRnJKQlpC?=
 =?utf-8?B?UUE0VUkvM1h2YTN5TFl0L21ncHhPdXBLRWFkaTMzb0RqL1BQbGVNSk1BNERN?=
 =?utf-8?B?cVg1TmlaSkRtb25TQml4d1Fhb09pZ2VZcjQ5MGZZNlpmSXNCcVBsMTJJWmpC?=
 =?utf-8?B?bHdVUkp5eGxScVdXdzFNYlg2djdTaE42SWV4WVE3VUlTZERYYUlGbHBVbFJP?=
 =?utf-8?B?ZUlTa096SzNMUklwcUhEUC9Fa254RFNjTWZWVHppc1lWWU9aSzlTUTJHWXN3?=
 =?utf-8?B?R0l1Q1A1ek5VOUpqSHc2a3g1NzI2NDJ1S3ZsMFNsbVRZeVdLVnhaOUNLUTZE?=
 =?utf-8?B?bjBsUFhNMFBOM3pMc05ncmNLUmcwR0c2azltNVNrekdtV25tWUxWRzA4NjVz?=
 =?utf-8?B?N01ZWmhYNkdNLzBlbGQ1azlTaDVNQWFmRWR3VXhtRkdZU2Q3bldGN0hVR1J2?=
 =?utf-8?B?dC9kRW0zdG90VExzaWFYNTFnV0xadzNxeURGMEQ1UTNkVENkTUhGdzdlNWpy?=
 =?utf-8?B?dFBKMWNJZTNLY2ErdWtCaHAvbkJMTFN2dncxWENBVi96M1d3RXdnMCsvT0VT?=
 =?utf-8?B?Vk1oSVdWSktSNU8wZXZUSUl2NUx1K2VUNWFUQTYvMDF4TFQxNFN2V3EyM3dR?=
 =?utf-8?B?aEN5Z21mc0YyN2lZenU3ZUdXUkdwNHhFVEtVb2MraTFqbjZRN1lZRmU2alJJ?=
 =?utf-8?B?TEhxcW5KQ3R6M2VGNE94cXBveERMUkZWMnBOcHlPNFBIZnZsaHoyQTBuWjls?=
 =?utf-8?Q?PCQix/ImvrUZKlRPQ88CBxgjU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7276a3-5176-4827-9375-08dde09cddfb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7272.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 10:24:10.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGJ5Bi02u9tq7XXVwhYpkygnTW08nGUQZu5E4PJykhey4YxR7aV5xFx7vGkFgR5zqZQjSWawL2doc/vvTNqhHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Stat-Signature: jqsijtm7n1fmcg5xbwa8o9krn11t3qq3
X-Rspam-User: 
X-Rspamd-Queue-Id: ADDEB4000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755771854-45025
X-HE-Meta: U2FsdGVkX1+flXltd0hlcZ+dghE+fbWx99WDZDTs0X2G0LomAztV3dt4xxahCDYSYZmwVgxVQkFB2R+i4FaJvhQYDu1Chyap7kpKT6tlt6dZoUcBgU+bern+uoRs8oDHkX53J6X3EDpwsBJn185pB/He6mM3Xhp2ao0jLG7PADV2Y+HqP5WlBkVv4XyS2WaY77CUh8zadClpHBieBHNOhsNgFAALe+ZzmCoJjP+7AMe3GLt17u2Vxd/ojdiR4MxDSbcqGH91qr84m0afZ4epIvWCSyBmdHHRE70FyjYmy4RZ+a7j14RsjXc/DM+18zEiT+xe2rEUIaQ8s7GRTaUA5TAWdaZhymbly+rq4FhwEJHcJIUpO9pe3i4R+vs9K8hCpzz+ukjvVPitU/z9fHBwGB05uEGEtm0DyjP+SB0FTMSeNUYyKPdbu/4tZzrcXruQjxa0xItcYTy7MD4lF843Fr3LFEYHKFj0Y/NYpuvgAs/1V1AYtju8/LPbLE0153NQqRPSflh361LopmmF1JvqfnaYaXlMtWeEbRb55Gs9Jw7B1r+FRFxWEANNY/B1j21xPiJJp2NOObfqa/DRnFUrFL8+yT0YCbvZkfyi823WMWeXaZg8oDOMxnk5Qnthhlp6RORx3Av76hvdwJ/b/5+x7jRp/4tDVAQRC7MHBk+3tg/wTIuGTbPGIlblB7Ff62x/tvUScbyXPPMi2E9Nxd7aCrloplnip5c7R/Mc8RwXD9Tp9MWL8cozIs8EQDMMCylhU3+a5xCHBhr0pdTmukNFuSu4xYabgx9UUcHLOhXmS5HgfffZIa4BHTRGseuikNhbzeHXT7rwDmhzHhIL/pFqlDlEEOJJw2MERsjUQYIY0fSfrUHuw+x5CL3Vc4YAVP+UyRAX71cv4jJpDrCiHj+POGi2NQtiYOZuS2GEVTPHE5DJRYr8dJiqHJN0rQBpphRZ7k1+zSEqsbdi0XkQEih
 h8YgFlm2
 Ok1RT9roLu6oKaAVYSEc10KTbezyMma8EfyZ4yeqrY/EXY+HpIYuls7SsIne9vrwt2aQ5ZJyNxCEfZ4ez2pYHubuq+H7UBsV78Q1ZbhmN6kb0bKReaef16wNeg1Z+qBjMlmmHNaSP+a1ExEspGFZeC3BQJrf4tzwacbParQgBGAbDEHcZfJnRphBqUUJY1aT9pC6AhdsrKz52v7lgaNIZxCC5nU97jSaWLuhRSwx6BUy7h0OUU0CanD7m1Q0TAAqE3Q8ABn/5tIfvBY47DhWZJ0iF1/Xe3WJw17n/5YASLQY603kJWmlZRJKD5Qifr6+R4qu+oz4MjVCagWHGQCgaa6due9K5Z1+2tR+jNWvXC34b8fpxIKd63XNIPPOvt3WFzRnW8VOE7mULoch62+tb/4Z5KsvdFkCWvGEbEt0g9XtxmoDP4oBgCAzh1D64lOBimft8DilSTXq0B5lueh0hbxHUnjJoR1AMUTY+QniZXeHatco7S2OzYKbdoJRtBDT6O2wgF95U8tWiiYg4izBSz8ccRKtz+W4Iv8NBQXF0sZUhmTvGVoyPB1d8BPS7DHBNWEflxOBoXoq/KXctsUXtHqYTweT7PwwGKPa3pNyGVnlT/LWRLV5a/XZBqYClW3ueWlV1G13y06yujCnMF5UFBkp15w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/15/25 10:04, Matthew Brost wrote:
> On Fri, Aug 15, 2025 at 08:51:21AM +1000, Balbir Singh wrote:
>> On 8/13/25 10:07, Mika Penttilä wrote:
>>>
>>> On 8/13/25 02:36, Balbir Singh wrote:
>>>
>>>> On 8/12/25 15:35, Mika Penttilä wrote:
>>>>> Hi,
>>>>>
>>>>> On 8/12/25 05:40, Balbir Singh wrote:
...

>> I've not run into this with my testing, let me try with more mTHP sizes enabled. I'll wait on Matthew
>> to post his test case or any results, issues seen
>>
> 
> I’ve hit this. In the code I shared privately, I split THPs in the
> page-collection path. You omitted that in v2 and v3; I believe you’ll
> need those changes. The code I'm referring to had the below comment.
> 
>  416         /*
>  417          * XXX: No clean way to support higher-order folios that don't match PMD
>  418          * boundaries for now — split them instead. Once mTHP support lands, add
>  419          * proper support for this case.
>  420          *
>  421          * The test, which exposed this as problematic, remapped (memremap) a
>  422          * large folio to an unaligned address, resulting in the folio being
>  423          * found in the middle of the PTEs. The requested number of pages was
>  424          * less than the folio size. Likely to be handled gracefully by upper
>  425          * layers eventually, but not yet.
>  426          */
> 
> I triggered it by doing some odd mremap operations, which caused the CPU
> page-fault handler to spin indefinitely iirc. In that case, a large device
> folio had been moved into the middle of a PMD.
> 
> Upstream could see the same problem if the device fault handler enforces
> a must-migrate-to-device policy and mremap moves a large CPU folio into
> the middle of a PMD.
> 
> I’m in the middle of other work; when I circle back, I’ll try to create
> a selftest to reproduce this. My current test is a fairly convoluted IGT
> with a bunch of threads doing remap nonsense, but I’ll try to distill it
> into a concise selftest.
> 

I ran into this while doing some testing as well, I fixed it in a manner similar
to split_folio() for partial unmaps. I will consolidate the folio splits into
a single helper and post it with v4.


Balbir Singh

