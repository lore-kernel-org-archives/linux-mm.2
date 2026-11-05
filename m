Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A481A606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bzlAZnwF
Received: by kanga.kvack.org (Postfix)
	id A92616B05B4; Thu,  5 Nov 2026 15:09:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A441F6B05B5; Thu,  5 Nov 2026 15:09:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B176B05B8; Thu,  5 Nov 2026 15:09:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 644C96B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:09:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4EA81A0C85
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:09:35 +0000 (UTC)
X-FDA: 85402155510.15.4D0520D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27085A000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:09:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bzlAZnwF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793909373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSmiUJjfkxp5i3LHpgZEys/x3tUo3HasUAh0nOprpyM=;
	b=ZTGp67ASleAMCvcSpIvwxj9ocuVIWMpwuo4e4onQ+LQY8ALHsS+gG2/J0jUwSWVSdc6gif
	k/ij6+GrB4WQN5v97y1gw+YCs3c4/Z+y1WOqJkm/VVF3R4rKztLKb5DUTTgLxK+uo9u/CU
	yYzMe1gbut4/6FUmrLCVvT/GRyb6nVs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793909373;
	b=V5y3YYEvJSruEvcIrX8bFK0SuXnViZswHO8mP7TL3TMCfjE3H7ieTKjOA15FK/RB/MgRSN
	vHn9ZCYGk1kSHOdi6ATHKexYaA/3pjrnAowZexwx1rakJk29VPdqwaDTegypNel65vpdlX
	Sh2jtmtQtRbvH4PRXmiE6zzhwMrKhhs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bzlAZnwF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apQTTN1Ej/87MKxBDfeCCx/1Lj5hRBKBzzf5dHpPRSqHLczP8qWrmRIsWQpzaV7nHnCQI0/yqTWMjqi05aR+NN1i/dZTDIaCwl/sFBq9Ui6cDnDBAE7/WqinKlriUxZ+IQIM/mUskQjARTSnblBxTexYF/q5w4VLLBBIl1UlctaACyxFa/at/c7YpMTUbLmxWUUXEkx49lym2/0cwJ723SMPnrjPhjEA2OYirD7izvBYhOdX5scWC5QWUxrXv7GOI9yYH0SUai82gplg6vtk8Dl3opCG7eN/IJt+8weuLGdogMZeKodtXPrjIR+R/Ul4F5DqWslfgPkb3ZYYI/e0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSmiUJjfkxp5i3LHpgZEys/x3tUo3HasUAh0nOprpyM=;
 b=Q79N2HPzefQkfrwDyn2MYjIplMfOjJWc8KdsW5izPd7USCFMdCYrV4BVwe/3RRyFrtoItVw0yqgFOONjTGF/GTknvGMOruii/rrDFVgwBwDxrw7j8nJoAjP0iedNSyzjp3CI+2lRAYdRkLYHjfftw0B0bAI9lFiWjuIodMD1T243O0zTbR50WbsVCUikPXDEWH+hxmz3Cp7w0C2OP3ot2uSe688Ob/GYOqt5cssJsgEllx1NhN63QVUX0ll1ZyT37yJab3SZs7f321OtFNgizNpgCpV4oV2i8v+dc60glB5omebV6K/L96bVYIglMK+CWZklJPVHQpw7cePHjWLy6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSmiUJjfkxp5i3LHpgZEys/x3tUo3HasUAh0nOprpyM=;
 b=bzlAZnwFkDca1XesgF0qSs/1jJBQyT3SKTfrVti/8tBA3NyRegYqLfqCwGGBQmLK9T3d869bjKHdaShteWCZJTS2j+IEFPCHcQMNL1nGLtYPI61+dM0ppoZp4uD8fIpBcFYft7ybLPLRQTeBUou55wn+0dUAoUzuIcHbP8Yf+unZxsdXAIzF4WijAxMMGfpp5myuREJF/7koYkRBeqsPSIpCZH68QMbxifAS5Tzu/4aKMtnxjU4gcwoW7p4yYXipUZcK42rNSfi9p7DSlSaF1Kl6rRQi01kQISrf2jxYXyXOz6IZzRMUj5qsAhFLjCJpSMHeVXEwebzf+K1f4mqk1g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB8288.namprd12.prod.outlook.com (2603:10b6:208:3fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 20:09:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 20:09:29 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Nov 2026 15:09:27 -0500
Message-Id: <DMNJSQDUACRI.HXKF5B6GSQOX@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Chris Mason"
 <mason@kernel.org>, <stable@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Hugh Dickins" <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Zach O'Keefe" <zokeefe@google.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate
 in MADV_COLLAPSE
X-Mailer: aerc 0.22.0
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB8288:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c3e382c-a775-42c1-9208-08df3b78b2a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|22082099003|18002099003|10067099003|921020|11063799006|261026121527099003|261102123227099003|56012099006|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	TNTwzf4a9/B2UAHoUKZM+/+E1MiO2o4RPYNogeLCvcjvTIlJeYGVKrzDFmPiW75pxgUssV3gW9XwOyCnAV/L1zSHZpMhrLJXmb6QsiGHWuZeOJKMxCnXbNKnq3QfFbFVEO9QTOHC/DK4ZZduCFQqvyJmLsRVy11brxxE0KZjHBGlf8XKLYTIl/BCFzF7QeL7KpELyInMhp1k+9liEGaEOdzsV0mpHKaOMdYYkw/hwNgchFvQqdbRRnManODCNNM9uTozXMGGPfCqaHAM6DwE22VY98dESEyxaSGvWPJiaaVNkZDIYZjS/zOCckpdR0aX4B4t0OCSq3ge+L8jsjMMIAjzlfK8fUcKSgIg2tqcpmfKreTev2WlJbLLyg3sLMSjcGOXiqKb1c1joE9iOW/Iv+JOgi2x4+ZU2bL9JPbOs/VHe6Cps7YAHV+M7kdMsWT4dbF6FjbaNjMzedIc4RrNzUQSKvj7soO5w6ERkDw2MA3UD6jrtVaJDNGb+AhE3Eo2HrR6Uq9vMffK1An0QOHRaM6AO2J8TO2laMjGIin5LA9Ij9M+b7/4rZoyjOvKKg07nm7BBtxn6YkRidwEPBDComF4MVILg+1+iGSrkHtib83CqoXJG2LJuEr0IxJ9vLDKPhS8FqNOh3VN3uB2JrfHaJZ4i9eAgIdFxIMclC+MNHsAy5jo2Rth3109EbU/JDOCyuYlHi9A4zuJvpRa+vnU1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(921020)(11063799006)(261026121527099003)(261102123227099003)(56012099006)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkprVnBzMHpDbDhPMFNxQnN1ZDBHb1ovNmRlTXJvalFjbTE2eHZEcHduOHRr?=
 =?utf-8?B?NWY1MWdpVVB6SzA3LzRQdjlHd1I2L3lKSXlyT2hZcVFzdkducUlZTXBqYlpp?=
 =?utf-8?B?K2cwWG92U3JHajZ1ZUUrTGRnK3c0SjdHK3l4YUxPVGlvYW9BTmhNTXJwTEUw?=
 =?utf-8?B?VmtqL21iZVFRRWhwR1J0bFE3K3RoZHhKYllzdDhoZ0tGTFlSY1hxZ1hVM1lr?=
 =?utf-8?B?dzRrNFgvb3kvOHpCcjhSaFg1MHNCWDArOVNqSTdwdEErSHowb3RnS2NYRXRI?=
 =?utf-8?B?dEJFbmNqT3FraHN1dE0rdHc1WW4rSWlydWpyVzFaSHUrYlJyUVk0U05tOHA4?=
 =?utf-8?B?TDIvWWZpN1dySDlzcG14L0N0TytmbHJhZnRRTE1tQnZ3ZkZpdmNCeVJBYng4?=
 =?utf-8?B?bzllWTl4Zm5sWVQrZktHTDVxbUIweCthOVRmUnJxdVI3Ryt5ZkNnVFF0N20y?=
 =?utf-8?B?SGlkVTlTdzR2UHV1dDZmcklpSEdpZHN2blY0Wi84eWsrNFozTEtjbFV5MTZG?=
 =?utf-8?B?SEp6TERqS3pXcU9HOW5jeldGNk1PVkFkMDNlbmQ2N0lGWlVWKzFTU0xIRkZt?=
 =?utf-8?B?OTRtNUl2Zk5Va2g0Z1BwNEp6dW82UTB4bFlhdTZiVnpvQmhiT1IrWi9CTkFk?=
 =?utf-8?B?MVRmUjhLNkU4YTdDeGkrMHNtUm9HWE5ORXd3cStrcGpPQXI4RGhaMW9KdWIx?=
 =?utf-8?B?V0xGZ3QxK2tYdUY0Q0M0bXFXNUlKV3ZFd0tIZXZYZVhqSVB1Rmt2MU9aMW54?=
 =?utf-8?B?S2xEZjQyNlZOZ09EanN1NGNaMHhoVFUxSjFJc0JyRERyWkpTalhJZnd1aXBI?=
 =?utf-8?B?R3NoVnZGSmRpY0F0eG5pZlBoVVI2blpuMldNcmYyZWYyTzhmNmdtTE9FblpC?=
 =?utf-8?B?UDhGWk1CQkdWNkEyNmJhWk5JNUk2ZWRncGdJMmd6UHZ2amN2WXhreU1WeFhv?=
 =?utf-8?B?QlEyaWxjQ3Q5ZUxrRk9XS1BXRVczKzBsOXVraUdvVEZPRURnckRWNVFrSHdV?=
 =?utf-8?B?OWh2SERWWEpjSzN4elBqZlpuSE9JdG1FdG0xS2Q0NFhhWHNUZHgzMHl6V1k3?=
 =?utf-8?B?ZndiYi9OcHJEV1B3bjRqaFVreWxMY0h0REZNdWMzc3VxSUZKWUk1alhTVGUy?=
 =?utf-8?B?V3lDVGpwbVVWb1doVGE4aFpZQzZWWWY5MnVDT3JYZGQza0lUKzQxbTJIR1k5?=
 =?utf-8?B?Z3RNdFdkdXMyYlJtK25FQ2pid1NidFdKZm5oM29rUjI4eUJVMU5BRDY4UTVu?=
 =?utf-8?B?SjVRVHF0YnFTREpsUE12dE1hbmRtMnlEdEQyV2daYU91QVl1dTY0R2hBOGVl?=
 =?utf-8?B?bkREeXdzVkk4ampIQzVZUzBMOEtTQ0Q2WTNWa1RFN1UxSHcxcjZTZ1hyMnNV?=
 =?utf-8?B?azBNRmJZbnVHTUtkeGR4aEJTREgxL2QxbCt3QnVpQStqVU5QOWt3TXFhR0l1?=
 =?utf-8?B?NGhuVVprK2xuNTdtOUFDb1dsaTdnaWZEeW5RZGV1QXR0VkI1RXpFT0ZsZTY2?=
 =?utf-8?B?Tld5bXdQZkFuMFlNbTdTQTdSdVZUU3dLbkJ1a2M0Q0Fkb29lZ3ducitpalVR?=
 =?utf-8?B?MmRnSHE5VjBsRStKb2pGTms3MDRLd0NmSEdQMlJ0V3Q2MUxBaW1YaW5GTCtt?=
 =?utf-8?B?NUd4SWRtTXRReG5lRGJENCttd2Zad1hLVzA3U3dLTkRQQ0tnSzFPdVlES0FT?=
 =?utf-8?B?UGhjaUl5TklqOWxuMS9VR0NLaVQ1L1RFN3FuRGpESld5N2s3RWt2MWR6ZXJl?=
 =?utf-8?B?WlpTeFJ0MkRLT01rdUdhRkhaWlc3RG1LakdzZGhUb1lzTU9DdU9PZVpqTlFJ?=
 =?utf-8?B?WUtJNllmL0MzZ2RZOXRGQTUzdEdVQk1wVkNPeGVWV3FCZURLSVNnZDE1V2Za?=
 =?utf-8?B?K2hRTGU5UDh5Q09TTHBEWEsydE5sR2JJRXdFdkVBVWE2c0hjS0FRczA0V3p6?=
 =?utf-8?B?V1NtNFlIZ09WWjF6T0Ywd0hpSCtpdXJMdnAwVk52dzNSVTNxZWtWWGVCazdS?=
 =?utf-8?B?SmNaeHlVSExRaGVMNTUwYURxRzNBMnJiTVkrUUhaY0paYW1rQlJuc3hXZ1h1?=
 =?utf-8?B?Y0JxM0VhUjBJQ1RTUlJraWJ1OVU5SHlUUTNlMzVSS2d3WlBwNDZVWCtUR2ZX?=
 =?utf-8?B?UmFsVDFWajAvNE5SUlRWL3RzZXRwY3dRbWxqYnBWQWVmT3N6MEJwTTZhY1Ru?=
 =?utf-8?B?UGZVYU1VdGVKYzF1WGo3dnBqblVVby9Ka2RIYWhZcnhWaDlwZm54aXpxNVlj?=
 =?utf-8?B?ZzhYajY0ZjRzSGxpbVQwakF0V0FTT0JyT0FtRDhkVkR6a2xBSVJ2SjY5VVIy?=
 =?utf-8?Q?4q0+VtyhPrNmxDxpDN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3e382c-a775-42c1-9208-08df3b78b2a5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 20:09:29.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVdett1kognU0A7r/58PqI2KVvPGROOUZ1Tb7hiUZhrjyKV8BS2CfwnCWuUNeWYW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8288
X-Stat-Signature: eaefamo55mg3rwx6z8amztt118i6aw1u
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27085A000F
X-HE-Tag: 1793909373-190883
X-HE-Meta: U2FsdGVkX1+0rs+7eJxYxyir0rM/5mivtdoGHmTFj9RdLPr0V7NIDH7oNfAMNJhG6y/cf4esKBcZc/Su448GDYNdgr1gFh2UZKFX01cwGL/mVjb02MZcyYNMUJ7xcRgPX8+PuLz6PElXpJM/QFyj3OQhGLQwKX24S6MAE6eyF5M+FPIkoHd4SI0qxhfnNU3CCe9OSqWKFhNO/E5OPPh804fTJDQbGWFLNiGxII2clHfDF/YF9GCNTVgX1gpSj4oFUa4x6ajnWH90tWAmpI+l6EXR4V+5LaTHc/wJF+H4Iixzij5dvUcd7KtG1R30+0uG7FQQ/4zT0+jgPs5VSwq2RanYpJKg031HhU8JuYErfBqJAtJwP/70BlHxj0bmOvAwaNlZYOAu/EvQnHXc1BB7Yl03hcxFaidVVKIweFfscNBOFplSjoSXUDTW/GLDxuqj4kaKz1atv3Kvv9d5fCON0NPZB43yjxhAn+HakKcNKhKYyk2HwFGbsWs/RtMEIxYbpjXwRtDxd7ctTmHAtss7Ofjzn9J4rcxIw/wqItNFH7buByTSj+I7turBLsAH40/CDRZ21AfBHKgCHvjvBCrI4FFifAIXeXlT37Uq67slnf8fB6+w0xxpSFREp5VqvtwlYLVp1TimbF8a/ptRFy2wJRz9eQBruLh55LjDmnu0jjUhllATduzT0tuUopsgwn8w512UzJyQeXprl3Y2AWHre6j5kaojF6A4gvo8PER/u3o8DKl4Sfm4pm3takFoBMkl/b6FTJDCUYmwJZ1Q/7hRRmqbN49Z60pTPtn3+/QEijUI+6UdYdaFacsc1nv6ykXx05PFr/Rs4ydsd/pw/mdsio4Wj2sJBxpo1j/CEfNPfGkK21Sv/ClNPwYvX/JTLUabcKbIVgJEHuWnOiwemMZdNIB3vbvzYIeMfjz9QYBBRmzt/+97fDkcE8rdwwXZ/EMSsO9KaSA1gg7Y3HZ0j0u
 LLnM9i05
 xyGwneOgnyEwrIc1k7BwKmtsaD2cQCkPxtWegMo7VLNjcF6JKQMBxdU/ZD25OXbGE5ob8WBonKcG/nF6EEBWMspq2SdlTh9LAsECz+qDtQg9DHrliDBKtgSgTVSA8je/4KKBP8SfyufY774vz2q0KlLGuGBOJlU3dP0H2hGMnjh6kjcxmYNIKP2oo67b27BYEUoGXdcVK/iX+L0Iss73x344QXernfXp9RCYycs04f0pGsdKAXjyI101AAqV2nCo4lO7MWz883PgyGHEdh0vU45ToZw/wgvS4PP4K0w7ltxyf0Bc7sKRUZlfZqay9aYi7nFZDEn5atZmHHfYIzmIpBEhZZCsN8u2DZzk4iYW3PrP6MGcYIIy4uWFm38x9fKL7rnRo7KwU8QhdxLHpXSETi///aS4hrGgusmpD6oKkq1eL+9/8R2+EvCHNu78BwjmGXC6pSTjNed3Dmk6KKVRmxX521Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 5, 2026 at 1:16 PM EST, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
>
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and ski=
p
> such folios, leaving handling to the page faults.
>
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
>
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLL=
APSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Once reviewed, I will pick this up in a timely manner.
> ---
>  mm/khugepaged.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


