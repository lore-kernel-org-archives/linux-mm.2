Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE33CAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FFEA8E0002; Wed, 24 Sep 2025 13:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B03C8E0001; Wed, 24 Sep 2025 13:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651188E0002; Wed, 24 Sep 2025 13:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB318E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:49:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E502D11A51B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:49:52 +0000 (UTC)
X-FDA: 83924881824.04.B8FBE43
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012068.outbound.protection.outlook.com [52.101.43.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 009778000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:49:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V31wj4dv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758736190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTEoIJ53MSgMs2wbO9MpzzwWOs88vgTi1IFkpu9Mv+k=;
	b=G9mvvAQhiSXxL7dbCurpxqIIvVBm0cwSDhkLPIPWpsTvUY/I7K3i587VYZgWfokPOr02Hw
	AWTPKVoNmEybqf6d0m6wHu4TOR8QnsGka4Kp/xntHHtUrsEU/apY6JLB6L3bm/XKO/T4Mu
	yfYvKRRdyJiba+e44Z9ll5VRtg4wxs8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758736190; a=rsa-sha256;
	cv=pass;
	b=d97r3OzlFtD6BojFmka+MBXI2MNk0Jly5QOt+Ky3+EAS1qIIxiA9OJin9yzVEvWR/OYLCq
	nFM6GU8QV+dduc7JxOn7lNXYZboSxXxRT8v+WjEr8uCEyOZ8hXmbINaXy7+6eAu0iowPA/
	uesV7YFRhoVmbTu2cl+LOQiO9XPbNNY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V31wj4dv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+NwMhORfhbnPc8KKEfZSK29crefxt5TEi0NI/EET98z5cegnod7/BP9bm2iCsQmXhg9uZoE4owUV+10xdTbklJCUwVWnt96YolKNVvHyws+3UU6sRR8Os61jiJVYAuTFEUVvr8uxbiywndtAQTh4TBmVAOKFZYdMwVp8WQbzvaZ8srUno13pmoBqs5WLjX/d4D6R9go2R+MR1AXNzmqBGqs/gJGt8Bke3kWHzG7cA6a5w6sAzo1waFqLeu69pstKKQ11Y4r9cANEzkMTc0ZcojQ2UfVzmsacMVNhLQFPvUKsLUjhMvi91X6Q6SHj4xR4zMZAlw0/mGvgu+O6P9N8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTEoIJ53MSgMs2wbO9MpzzwWOs88vgTi1IFkpu9Mv+k=;
 b=PD+jneHYKR+QhrR72N3cVVRK5LjNT1DUQW1Qsvj5O6uDJZVgLU3EaqKklut23SvWdxKcAXDKu66fHVxuuhC8EI9aWX2IhVn9JX5kbZnkR+vjZP7YDmaHIWz02NowTplxNVTdRhhkOWIW21/T8HhZTwtSl8595kNy8robEerw5gjayoX3+uhymaFZT1sM6OwU/NUulwbvM4UcYnw0lpwZeepLH2J3b5XqBfqP6nFbd4Jn9OzIaI/0rqgll6ocLgjsRGIoE3upuWo7GD9mpAUvTvoXuaKBWRZia5oOrsU/4BTXR2BXSPQTSs+or4BdcqTHAq6ywg28t6WghslSaQnmlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTEoIJ53MSgMs2wbO9MpzzwWOs88vgTi1IFkpu9Mv+k=;
 b=V31wj4dvheaErquEwGDJBpNpTJNSmsERc/wBaTRen2vWwfg7X7ZAfNc+RmZYN8YMLBjida1GWkObqkOk/joYoGyS9CCluU0EtgU7YQvgMqkiFzTB2g8tR2y7wsOJpFPbpIBDNh71mSvS/gG32aJaMm+4pNCOMXKvMgVuVhk0A3BhEE9wMqrnkqZyLYPyJbNHK6dawi+a7s7JfPQ2UXq1jrLlopmsi2ixeNakXsprgyxH37opHR4nnDeOiCa1Qn8bpbwBuYIn1q2b9RPpu1ZUoq6nHDUcVZLcC3PVm0mVbIt76g6vy+hSwBpbnnOdlYDuxlVy1l0hY4Y+aZq98/+KjA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Wed, 24 Sep 2025 17:49:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 17:49:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v6 01/15] mm/zone_device: support large zone device private
 folios
Date: Wed, 24 Sep 2025 13:49:41 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4534DB6E-FF66-4412-B843-FB9BC5E52618@nvidia.com>
In-Reply-To: <c7a2ad6e-68cb-4689-b72e-6e7ebfcf5e64@redhat.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-2-balbirs@nvidia.com>
 <882D81FA-DA40-4FF9-8192-166DBE1709AF@nvidia.com>
 <f026c5a1-ec51-4fa5-bc58-c2d690f9248c@nvidia.com>
 <87F52459-85DC-49C3-9720-819FAA0D1602@nvidia.com>
 <891b7840-3cde-49d0-bdde-8945e9767627@nvidia.com>
 <c7a2ad6e-68cb-4689-b72e-6e7ebfcf5e64@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:207:3d::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 52878960-03ab-4d4c-aa2d-08ddfb92bf24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjdiNEsrUlBGdHlybjFJQWZIYUZjR0FDWWNsOEVGdllMK0ZIM2kxZ1dTWGpB?=
 =?utf-8?B?OXNrRmJDelF6M1A2dmczOVZQUEtiNlE2Q2RHcy9JSXBQR2I2b0k3OWU2TDA5?=
 =?utf-8?B?YnJzR3FUZjJEdkJTUHBENW1OUENSdTdxcGJrMGE2T000RVJ1aEhBOWVwYTA0?=
 =?utf-8?B?SnlRd3FObERsazBHZlpsT1dSbmR3WDFCZ3IvN0Q4SlREUkNpK1hXUnB6NDZK?=
 =?utf-8?B?ODhWT2VYcVVQOExSNzdkRUZ2QzIraUdqQzRYTUc4TmhxS2VjTHRITlJzK3Zo?=
 =?utf-8?B?YkM3bjFVOWRWUHMxdXB6M1Z3aGRtWVlwaFd4c2xMd3hhb0VidGxpQkZpWHo4?=
 =?utf-8?B?b2x1NHpmakN0Rmp2VWtFNE01c1FMbmxwZVA4a2Yzb0dRbkRXcEtGZ0RhMm1O?=
 =?utf-8?B?c2s2R2pJeTdWVExaaEU2UE5mcDVvOC85ZGw2dFN6VDhrRW9HZTZLRE9iczJo?=
 =?utf-8?B?T0VXOTlhNVJiTWt2cU51bEhkN2pYdm14amY2UzJ5MWJMWHRENUZOZThSeHY4?=
 =?utf-8?B?d1lBRVYwUWR2MHBlRjRWZSs3Q3FBaXYyRmlJUzB4ZW9DNmNpVXBkUWt3cEJ3?=
 =?utf-8?B?N3FaN0hWZ0Fhb1pJMkhQU2M5WVVnMXE2MHU3MkRvSXBKaWtTdmJldGxCZ013?=
 =?utf-8?B?VHBQc3QzWnBYSk03eGZlNUdXVGFFbE9tQ0JMK1VVdkIxQndyeHpDb0JaZEJi?=
 =?utf-8?B?dkUxcm4rNllEWHVONzNKWlRmQ3MrTXNNeEJ0bjlCQUhoUTlOVlRHT002UWth?=
 =?utf-8?B?K1lZZUpoemlkWUpMc1p6QnVlcFZHTG4yZG81QWdJMDNiWDJEa0lNWGVlTExP?=
 =?utf-8?B?NmZ4dVBoYlNidXd4cFUvNXFxNE5rcCtTS3pPMC9QWUdPbDhJUGxkaVJvalpC?=
 =?utf-8?B?bkpMeTNXVkRFYjFodVBlTzJZOTVlU0sreU5FNmRsTS9XaEFWN21JZGt1Skox?=
 =?utf-8?B?dTgzNVVZVEZwS2t4UHViSWxYMDJqRzhxeFRRbGlidlJLRjZsRk9KRjk1VjN2?=
 =?utf-8?B?WGhyR2JBL0s2TUx0OENFZjFzN0JIZTgweURoTURKQzljRUI4bjF0cVVHeHZ3?=
 =?utf-8?B?OUVvTVFnbk5jcWx4WlRaUytNZHVGTWlEUUtkQTI1eUhSb2JhVzR0Y3loQzdi?=
 =?utf-8?B?VUlJSmxFNFJQelVzTk15SkFZV3NheWpGR3lDZ3dsdXVMcU1HSGNLdVZtMjJt?=
 =?utf-8?B?Q1BxeUtNVkhkcDhnVzF0cDVDcDAyRUQ3MXdBUkhTM3ZRblowZ0JrVUpjUnFr?=
 =?utf-8?B?eVdiaG81Z1doakFJT1laSFdRKzV5b2ZDZmMwUmdldHc4bUlKNG1vMVNvN0Fk?=
 =?utf-8?B?dGxpZXhvUWl5cFRqeDJqS3NQSjRXNU5TZGoxZkZKTFkveGYwaVJrcE5UZENL?=
 =?utf-8?B?UFRudEJmNTJUZXRJTUNBbjMrTjIzS0EwWm1wTGNRWFR1UHRKQ1hVVGVRT202?=
 =?utf-8?B?YTU4WUgrYTZadjhnSFR5K1R5Y2JuZlhTL3FZRlMxRDVDMmtZQU1wSmNRTTAy?=
 =?utf-8?B?T3NSU2ZVdEx2ZXpwaFhWZk1uR3phVy9nU3NlUk1Ha0M3TFI3dEw5WXNJVFl3?=
 =?utf-8?B?ZTEvekFHcysrSTRTaUN3dnhqMHV4YmpWeWxvcEJGRmZSd05vbWJDQ2NKR3VR?=
 =?utf-8?B?ZytaWHNJN01nRkpLYmhRaFRudFRnaVVBaG9NMkZISGJmM1ppNmpnQk5GanRQ?=
 =?utf-8?B?RUpUZ3Q4ZHA5Sk5hTHNSd3AwbVRzYkVtTTlmaDNRSElHK3h2cE5vQUlDMnht?=
 =?utf-8?B?VVYwOGdEaHdMNlNXb2JTZFlUcWQvY2lLbnJnbzdRemFqdHA5TnV5aDlLV0Js?=
 =?utf-8?B?aGFOWDhRekNhQ0ZsOGpOVWhwSkxTMmRydkR5SmlnSUdzZCtXUjNINmR5Mk1B?=
 =?utf-8?B?NldZb0tyYmtrYVJCS1JhWFNvV1l2aWNsRmhVVEpPUVhlRURJTElobnY0OCtF?=
 =?utf-8?Q?dCxEIqkC42w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlByOGlFclV2VWdVVDdsWHAwckN3eGRaTkRRVDU0RGExalJDbzNsd3cvc3NM?=
 =?utf-8?B?bEVZOHIvUEI4VTBqNFNIMHZJOS9XWm40aGNFeWY0aloxRDBHcU9NVVBCNitD?=
 =?utf-8?B?Tkg5UHN0ZVRBNmZEcHYxdWlxVGwzRVpLUHVnZkNtYU5abUk5ZWNuWnpmSzFw?=
 =?utf-8?B?b3NpYW42Umd5Mm5iOEpoVkx1V053ZWozd1V4dFpSa0ZBbFEyajJFbDF3SzYw?=
 =?utf-8?B?WUV0cGliVzBuekoycVh0aXVUS0xtSDFkOStYOFRQTTdCQWJmT29VYWJWMTJX?=
 =?utf-8?B?aWZmOFdjL2ZQLzhia1l2SEI5VmVuTG1WaHd0bExvSE9iV2lhV0pCYjA5WDJZ?=
 =?utf-8?B?MC90UytrOVJ1cHhOWEg1OW1uQXdIdHRTYmVKYXExSkJNQ3h2R01mMmtZd0Nn?=
 =?utf-8?B?SDZyZGNPYlpJdFdFT3FXUi9YcVVNUUYxWWZBZkQ0eGk3aG5YZUZLNitXNTJy?=
 =?utf-8?B?R2ZJMGdDTGNQVU1kd1JMckVwWGVjNy9KeXpxK3RNNDl2b1JBb3I0cTN6SU8z?=
 =?utf-8?B?b0M2d3ZNRzlXSkFqSnV2YzBNN3lJN2JNQmNyR1dSMWZRT2Z3R0dZaWd4S1FP?=
 =?utf-8?B?UHc2OGp6cE5EVy9OaGc4WlhRTkx2dUdaWDIxbFF6bXFEQWFON0RhR0ZiTzV0?=
 =?utf-8?B?VCt3eWFBT1ZUSGVVTjdSWW1MTlpZVHpFZnNyQ1VramlHMWsyVlRoeDhDcDNv?=
 =?utf-8?B?QVZwL3NybXNXeVU5Ync1QStPb2R1dWt4MFpGbUUycG1IVHMyd05RUDU0MkJM?=
 =?utf-8?B?NnF0Z2dpVVkzNHhXbmxPd1JRSkU2VDNlS240M1NTbkZNRWJpSUpZeFVmRjRX?=
 =?utf-8?B?R25LMDFDMXJ2SGRhSmhLZ1JpSWdXY1RldmNUTU1lY3RzeXBlclpoUGhXWi8r?=
 =?utf-8?B?em8wU1hMbUdYazBsQm15dGZYWm45WFhQcDVuL0NrUWNtVk9sdUkvV2wya2FE?=
 =?utf-8?B?ZnBPZWd2SmF2QmYwZHppclpnNVUxall6RnM0SEovcTd4Y1Jlem5taVVIc25z?=
 =?utf-8?B?NFhzK2o3M0hHblJiRGpYTXdoYVhRbThkS3E5UTBsak1ObWk2cjFpMkYvTndh?=
 =?utf-8?B?dzJyUW1XbGNjTXNSUnpEWUZ2RnF0SlZmVzVvWTZaQkl5b1hPbmtwSUZzZENK?=
 =?utf-8?B?M2NNR3g5dVRQRC9lZHNGWFVMQmh6eEQyZ2wvMkdoYzVtVFR3bjg2NWdDSDda?=
 =?utf-8?B?MnBBZUpPKzhUQ1NFaCtLQ0swalBRNmk5YkVycHMvVndKTEtWbGg4bWhrdFNI?=
 =?utf-8?B?RGtCcS9GVGI4ZjRrRUdoeFp6Sm5RKzl1cEhaSXdyMmVBZXVMblQyM1Z5RHVw?=
 =?utf-8?B?NXh5QU13RVBjdHd4djVKMnNtaUJlc3h3TU1GclkrNG9nRGVxT2tjYnQ0QkpL?=
 =?utf-8?B?NkRGUnlNNzRpNjdnQ2dQU3BOMWg5UHlOV1ZSM1RsbWtaWXFlM1hBUzhqaHg1?=
 =?utf-8?B?aEd5UCt1TDZCS0ZaVGlwMi9IVVhYMitYcFI4U1JKbGRkSFN4Q3FlRXBKZHlO?=
 =?utf-8?B?TDU2SWtXU3lleU9TOTllUDBseXdWa3BhY3hwVkxsWGlsSnpGQmdzalBQTUxL?=
 =?utf-8?B?dGxMbE5NV2ZoQjJMS2NsMVI3L09Ra0RDSWdJWHdSNGFrbEMrVHdhVHhWbXVZ?=
 =?utf-8?B?WFozUVVLbSsrM1ZlZ0FoWHBFVDBWUCtyQU1WLzdHZWFWUTFKOUFKblFOVmtF?=
 =?utf-8?B?WFFEMXVjUU9Xd25iVDh3cmU4OUxuVC9FL1lBOVd4cVAyT0E0bHlvVkVPQ3U5?=
 =?utf-8?B?Uys5OEtMTGtzdGZYd09ac0lWUHJNZU56K1RzN2czS0w0bW5lQ29ZRGhaOHgx?=
 =?utf-8?B?K2tFREk0YVVadDRkTmhmRGdjVFNod2ZqKzFDRTZUTHVKWU43bzQrclVlb1d1?=
 =?utf-8?B?NlBCRFR0Ym1DNUsxWFI5K2VFd0FWT0ttWlhMZWVQa3FNWkhkdG1wM3RUdlRz?=
 =?utf-8?B?ZWZVY2ZRcnFBV1Q4L1pEQmJOazU2ZEhIN1hKZFFqZ1V1OGNXVkNyTUJDSXdh?=
 =?utf-8?B?WHFOdk5HKzRQNWVPcy9qWXBVaGVCQ3JQbHZGUkpONGdVLzRIaWhaWEpOcVJr?=
 =?utf-8?B?V3FieXBWN1hlaklMU0h2RzVnRnh6bU1ZVHhKQitzUDdKTDhjRUlQeUd4Z2NG?=
 =?utf-8?Q?O+UHTIphiTd1G2ZAR+6NQlsj9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52878960-03ab-4d4c-aa2d-08ddfb92bf24
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 17:49:44.8525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jt/Y+iLWqSIiFSSNemkv0dElDGaSmw613/nObogitUnDf1OiTuld6++3pY42BKYA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 009778000D
X-Stat-Signature: ptgxceutrs99qohjqs3bsd86hxrrjubr
X-Rspam-User: 
X-HE-Tag: 1758736189-594382
X-HE-Meta: U2FsdGVkX19D5G4N5Sf6Q+kXjNQ5XPHozwc9eqXU09fs1VDK8bNMj0OWyOSB3lW1T5O27hdTQ1Np0i9gjkDbLQ4iTZa3CTF5OFgmaBSBzJ1FTU/1U7ULHNGhSYs1ZHNnLudbrzG2nwEdpjujR9XhupDRqBg+93dala+uhUovlzeaPe67GjfXHV8vlg2XDOfZ1wd3nk7BDc7sFSSZKRRD2EY5IX7TOTZy97JWzA+e+TwXptFxjAvPwlKeJLxYHCMDe9yighIaNLZD9gtU1efD7ZAa6GnSH5h7b7xBDc0r4ucwzL4iyahJXDY3KhKqR20ltsE4ipiFJx5QtvWlRdCv53KTapa31bOlEkJlDryysU+yBh66KGg6fpVdEx3bQiEXv9TmSD9HHD8/kjrRWuOa/YtWVPxtLNgXSpaIOWpYD2mIblQ2A5wG+t/ZmxhnEpW/G53ocuCQBV+9x4z/VEPkuKM/HdQ3dr8SpPTsF4qCbFwN0NlIR4AejlKweXj48Z5yW49TwYpxJrFblhJtt8vYUTtEHzdz9WceGt136n5wlyz1d0A8cZfLywRZP/fzV4/ybR4fc+QNHi3qn9crVdsWge7gItyfrggCsnBpE24B9Ekb4oythhlDKFXLhz6JLd1b9fXSU4LWuH4sVG5IL1KbE0BOvyeKy1RUPJUnes5IbeYtEZt92Fum0ralfVedGdeLFaejLInomN2HYZrqp3tofk0P48fDiRUTbU7pvZz/wCtvOXGD9/+QDREhEkaNlgf0A9QFJqkoaNI18np94tQUTjwoOfzwdNH5/UiKtkxXNutZDRqNZNZVtLb+MjdskNX8lwHsKrGZQsHN542hlXvFpU5iMTiJHfN+WSmjlwCcMn5mgXXGGl8r760X7AXC+xgErKSo1WS/IyHGVRHBSTakTbsXt8aeX34bs7wiFjtOkw5D6E8N/V9K8q7h0Pm6pUzgegNF6ZACYgcfMljm/o5
 v8T8cZWD
 0BwdPnNSlJfZnxqnr2NhLEr59gvyVKL5pD60Vu//uHZHb3iaTSAkhHiqAdOe4DxhJ3eufOWPcOYaSwkfecaUFsedxMZGFs7w5tZPCkuHGJ0D7NvH7xriKyPqCLieVGQzDAwv8BW3yJ1xvFP2aRMc7Ijqe014Pu/FHyM6xiaBOgZySyPbDIFon/KiZQ8BUM0xYJKDyFiC5byy/BY3rEIRUXsqpB3QCfGYY5sXYFH56fSspPANH3bPOuyHb0AQZ2UddlQcAv9idIAZMioM9nFUv8GDNCszX0x576fz8fU1gcNQNJs0qsiLCSUli9DiBWGWtCzAegagOXy2DttCPC9QHWk3bByAQrywqeU4J3sH++NmoCbKfrvcaiQObhFd6RatcwWIAX4bA9wf0/hSppeHLiv5U5mvpkNqv4T58WWCjaUzfIMtXAStlwUg9K0jMGl4S16bwnL3NKn3QpGBvj8m4QPQ8EmucyVArdKYdOfMnPyEPPNqlUzwERPKqgN6F2EMUiA0mycsSXZvzPXQuSce5YWcwY3DFV10MpoSkl86vBPPMSYyInD/j4/2xCJpA/yqvrDNvuMFOj2C9yV/NkWAnX02NoX+uiWhSUvQuKc3XlvW2Wa0JL32nr5cpKXXujMkfIm5cAs4ieAcS1bCsxCEARmLoY2R3GDrA6/GNbew4TcBkFv4X5p6KlvufkFDeXtOhN2aM6onA5hIFFWR6Nb7+OueRuK4oIEiU2d44ZnGTOFdIOmTAUhCDwj+NOK3sWStzrpog1FDq5I9tU0pLMYv1VondOjUZ/ExZmc8MO0AJpPKJhRK55rwOWKTg0h+r0Bxt3nAP/5sICO8n53FFobrEInsGubL55JAvS06B+9CEJVeIpjCjwji4pukQirtDWldoaIlWADVGZjd9mJ9+tdXNViAXPfM0np66fDMuGocT2b+Vw8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Sep 2025, at 7:04, David Hildenbrand wrote:

> On 23.09.25 05:47, Balbir Singh wrote:
>> On 9/19/25 23:26, Zi Yan wrote:
>>> On 19 Sep 2025, at 1:01, Balbir Singh wrote:
>>>
>>>> On 9/18/25 12:49, Zi Yan wrote:
>>>>> On 16 Sep 2025, at 8:21, Balbir Singh wrote:
>>>>>
>>>>>> Add routines to support allocation of large order zone device folios
>>>>>> and helper functions for zone device folios, to check if a folio is
>>>>>> device private and helpers for setting zone device data.
>>>>>>
>>>>>> When large folios are used, the existing page_free() callback in
>>>>>> pgmap is called when the folio is freed, this is true for both
>>>>>> PAGE_SIZE and higher order pages.
>>>>>>
>>>>>> Zone device private large folios do not support deferred split and
>>>>>> scan like normal THP folios.
>>>>>>
>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>> ---
>>>>>>   include/linux/memremap.h | 10 +++++++++-
>>>>>>   mm/memremap.c            | 34 +++++++++++++++++++++-------------
>>>>>>   mm/rmap.c                |  6 +++++-
>>>>>>   3 files changed, 35 insertions(+), 15 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>>> index e5951ba12a28..9c20327c2be5 100644
>>>>>> --- a/include/linux/memremap.h
>>>>>> +++ b/include/linux/memremap.h
>>>>>> @@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct pa=
ge *page)
>>>>>>   }
>>>>>>
>>>>>>   #ifdef CONFIG_ZONE_DEVICE
>>>>>> -void zone_device_page_init(struct page *page);
>>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order=
);
>>>>>>   void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>>>>>>   void memunmap_pages(struct dev_pagemap *pgmap);
>>>>>>   void *devm_memremap_pages(struct device *dev, struct dev_pagemap *=
pgmap);
>>>>>> @@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned lo=
ng pfn);
>>>>>>   bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)=
;
>>>>>>
>>>>>>   unsigned long memremap_compat_align(void);
>>>>>> +
>>>>>> +static inline void zone_device_page_init(struct page *page)
>>>>>> +{
>>>>>> +	struct folio *folio =3D page_folio(page);
>>>>>> +
>>>>>> +	zone_device_folio_init(folio, 0);
>>>>>
>>>>> I assume it is for legacy code, where only non-compound page exists?
>>>>>
>>>>> It seems that you assume @page is always order-0, but there is no che=
ck
>>>>> for it. Adding VM_WARN_ON_ONCE_FOLIO(folio_order(folio) !=3D 0, folio=
)
>>>>> above it would be useful to detect misuse.
>>>>>
>>>>>> +}
>>>>>> +
>>>>>>   #else
>>>>>>   static inline void *devm_memremap_pages(struct device *dev,
>>>>>>   		struct dev_pagemap *pgmap)
>>>>>> diff --git a/mm/memremap.c b/mm/memremap.c
>>>>>> index 46cb1b0b6f72..a8481ebf94cc 100644
>>>>>> --- a/mm/memremap.c
>>>>>> +++ b/mm/memremap.c
>>>>>> @@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>>>>>>   void free_zone_device_folio(struct folio *folio)
>>>>>>   {
>>>>>>   	struct dev_pagemap *pgmap =3D folio->pgmap;
>>>>>> +	unsigned long nr =3D folio_nr_pages(folio);
>>>>>> +	int i;
>>>>>>
>>>>>>   	if (WARN_ON_ONCE(!pgmap))
>>>>>>   		return;
>>>>>>
>>>>>>   	mem_cgroup_uncharge(folio);
>>>>>>
>>>>>> -	/*
>>>>>> -	 * Note: we don't expect anonymous compound pages yet. Once suppor=
ted
>>>>>> -	 * and we could PTE-map them similar to THP, we'd have to clear
>>>>>> -	 * PG_anon_exclusive on all tail pages.
>>>>>> -	 */
>>>>>>   	if (folio_test_anon(folio)) {
>>>>>> -		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
>>>>>> -		__ClearPageAnonExclusive(folio_page(folio, 0));
>>>>>> +		for (i =3D 0; i < nr; i++)
>>>>>> +			__ClearPageAnonExclusive(folio_page(folio, i));
>>>>>> +	} else {
>>>>>> +		VM_WARN_ON_ONCE(folio_test_large(folio));
>>>>>>   	}
>>>>>>
>>>>>>   	/*
>>>>>> @@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
>>>>>>   	case MEMORY_DEVICE_COHERENT:
>>>>>>   		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>>>>>>   			break;
>>>>>> -		pgmap->ops->page_free(folio_page(folio, 0));
>>>>>> -		put_dev_pagemap(pgmap);
>>>>>> +		pgmap->ops->page_free(&folio->page);
>>>>>> +		percpu_ref_put_many(&folio->pgmap->ref, nr);
>>>>>>   		break;
>>>>>>
>>>>>>   	case MEMORY_DEVICE_GENERIC:
>>>>>> @@ -480,14 +479,23 @@ void free_zone_device_folio(struct folio *foli=
o)
>>>>>>   	}
>>>>>>   }
>>>>>>
>>>>>> -void zone_device_page_init(struct page *page)
>>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order=
)
>>>>>>   {
>>>>>> +	struct page *page =3D folio_page(folio, 0);
>>>>>
>>>>> It is strange to see a folio is converted back to page in
>>>>> a function called zone_device_folio_init().
>>>>>
>>>>>> +
>>>>>> +	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>>> +
>>>>>>   	/*
>>>>>>   	 * Drivers shouldn't be allocating pages after calling
>>>>>>   	 * memunmap_pages().
>>>>>>   	 */
>>>>>> -	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
>>>>>> -	set_page_count(page, 1);
>>>>>> +	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << =
order));
>>>>>> +	folio_set_count(folio, 1);
>>>>>>   	lock_page(page);
>>>>>> +
>>>>>> +	if (order > 1) {
>>>>>> +		prep_compound_page(page, order);
>>>>>> +		folio_set_large_rmappable(folio);
>>>>>> +	}
>>>>>
>>>>> OK, so basically, @folio is not a compound page yet when zone_device_=
folio_init()
>>>>> is called.
>>>>>
>>>>> I feel that your zone_device_page_init() and zone_device_folio_init()
>>>>> implementations are inverse. They should follow the same pattern
>>>>> as __alloc_pages_noprof() and __folio_alloc_noprof(), where
>>>>> zone_device_page_init() does the actual initialization and
>>>>> zone_device_folio_init() just convert a page to folio.
>>>>>
>>>>> Something like:
>>>>>
>>>>> void zone_device_page_init(struct page *page, unsigned int order)
>>>>> {
>>>>> 	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>>
>>>>> 	/*
>>>>> 	 * Drivers shouldn't be allocating pages after calling
>>>>> 	 * memunmap_pages().
>>>>> 	 */
>>>>>
>>>>>      WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 <=
< order));
>>>>> =09
>>>>> 	/*
>>>>> 	 * anonymous folio does not support order-1, high order file-backed =
folio
>>>>> 	 * is not supported at all.
>>>>> 	 */
>>>>> 	VM_WARN_ON_ONCE(order =3D=3D 1);
>>>>>
>>>>> 	if (order > 1)
>>>>> 		prep_compound_page(page, order);
>>>>>
>>>>> 	/* page has to be compound head here */
>>>>> 	set_page_count(page, 1);
>>>>> 	lock_page(page);
>>>>> }
>>>>>
>>>>> void zone_device_folio_init(struct folio *folio, unsigned int order)
>>>>> {
>>>>> 	struct page *page =3D folio_page(folio, 0);
>>>>>
>>>>> 	zone_device_page_init(page, order);
>>>>> 	page_rmappable_folio(page);
>>>>> }
>>>>>
>>>>> Or
>>>>>
>>>>> struct folio *zone_device_folio_init(struct page *page, unsigned int =
order)
>>>>> {
>>>>> 	zone_device_page_init(page, order);
>>>>> 	return page_rmappable_folio(page);
>>>>> }
>>>>>
>>>>>
>>>>> Then, it comes to free_zone_device_folio() above,
>>>>> I feel that pgmap->ops->page_free() should take an additional order
>>>>> parameter to free a compound page like free_frozen_pages().
>>>>>
>>>>>
>>>>> This is my impression after reading the patch and zone device page co=
de.
>>>>>
>>>>> Alistair and David can correct me if this is wrong, since I am new to
>>>>> zone device page code.
>>>>> =09
>>>>
>>>> Thanks, I did not want to change zone_device_page_init() for several
>>>> drivers (outside my test scope) that already assume it has an order si=
ze of 0.
>>>
>>> But my proposed zone_device_page_init() should still work for order-0
>>> pages. You just need to change call site to add 0 as a new parameter.
>>>
>>
>> I did not want to change existing callers (increases testing impact)
>> without a strong reason.
>>
>>>
>>> One strange thing I found in the original zone_device_page_init() is
>>> the use of page_pgmap() in
>>> WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order=
)).
>>> page_pgmap() calls page_folio() on the given page to access pgmap field=
.
>>> And pgmap field is only available in struct folio. The code initializes
>>> struct page, but in middle it suddenly finds the page is actually a fol=
io,
>>> then treat it as a page afterwards. I wonder if it can be done better.
>>>
>>> This might be a question to Alistair, since he made the change.
>>>
>>
>> I'll let him answer it :)
>
> Not him, but I think this goes back to my question raised in my other rep=
ly: When would we allocate "struct folio" in the future.
>
> If it's "always" then actually most of the zone-device code would only ev=
er operate on folios and never on pages in the future.
>
> I recall during a discussion at LSF/MM I raised that, and the answer was =
(IIRC) that we will allocate "struct folio" as we will initialize the memma=
p for dax.
>
> So essentially, we'd always have folios and would never really have to op=
erate on pages.

Hmm, then what is the point of having =E2=80=9Cstruct folio=E2=80=9D, which=
 originally is
added to save compound_head() calls, where everything is a folio in device
private world? We might need DAX people to explain the rationale of
=E2=80=9Calways struct folio=E2=80=9D.

Best Regards,
Yan, Zi

