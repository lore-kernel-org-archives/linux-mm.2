Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77495EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9456B0089; Fri,  6 Feb 2026 18:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467356B0092; Fri,  6 Feb 2026 18:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315136B0093; Fri,  6 Feb 2026 18:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4E36B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:06:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD41B8B4CC
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:06:38 +0000 (UTC)
X-FDA: 84415568076.12.E8D300F
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by imf29.hostedemail.com (Postfix) with ESMTP id E192D120002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:06:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mRMDRq0T;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770419196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd9Y6YSNN3VM33mFIzJEOqv9WSs1Gg4hZsHpMtPdK5M=;
	b=0+HFrOI1W7ijrDQn7TljRl5UjdyA3Gt72pehdR9R6plCTqbRuiYlpvtWMZKqMH+VzCnivn
	vdfv5tk5/1k504Zir/XiT2Xy1KurDSaASQYjKtdE/or6uqoaCgqSc4UZ3rf7X944ozawet
	Zg0B80eztnoIWk1LoyswmvCeRAdcyI0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mRMDRq0T;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770419196; a=rsa-sha256;
	cv=pass;
	b=2GVF0hQJZ9KSC1ITZ7piVxbU9wphpI20b2CJntcmTDAYQMGAh+PmYHFhrER3xHPxC1FpIK
	Cro19tPaop4tRrN44fYUIh/Uiz3a/DqCSIRoNTbQNtVVMlE5JKdCDQcAfUhiUc1iDGdZiB
	iMkOeVPEF9bEPowzUYVPH7EotP7QgcE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFmPX24q4eIsG/YHQETI2WomXH/2XBy/NHu1n6JvmVHB2okDeiCvJ7Jztd2YbL3Oejp2ACgzAHNgI10furKExmQu5bEKrKkdyvCwhouQYNU3nUcooRtmCVDkULr50iEiy3CBHqSuNf7bZmgbQjTrCtSZHtC8NSK77PxkNkxVK98oL2D+y/pIIqXFO2FCeZFmGBzibzLLZvghtuZMGlopS03gTSqJIHoAawP/iYgMVA7oH99+qvs5psqY7sTG4hZl7Oo6TXz24FxoOydBNYWfaGWgIgzceyjtovCoo8aoNFBZxInmcL8bk1mGX4r4b0wiR1vJyQ6m31Jen2T2GZggxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bd9Y6YSNN3VM33mFIzJEOqv9WSs1Gg4hZsHpMtPdK5M=;
 b=p33eetTI91fxWpRqtKdoHEARqUMYakl6mhy68/yggK7zZTfCLNhdE3bgHPzrfwJR8sVRtkjZzxSUTbbCJlKzK5Zw8vHSRc3b1/nIv8IrvZyss2lSiOkAiHtRLI76oVgdGZx6LpU8J5X6qdRG+QnkauxydpO8L8BjjubRj71n//6K6FG9QBt72T0ZKJ0wtqKoGlY50Jy9J/XIwqCnoi+iREklkNFbKSC8o1K5uDUdAuegqTDrRf6LVi44pn4JP35XdQVU+ET25s2Tslie74HB7auabdVI0oU5KCa6Jur3iL+rjdbiPkiUPIUWi2mZlt9pPz3P7V+CKHXF0yVHqeGNaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd9Y6YSNN3VM33mFIzJEOqv9WSs1Gg4hZsHpMtPdK5M=;
 b=mRMDRq0TzJCcxBi0IYe8WET7tHrLy/zjaPALuPzM8MrQgU3WKLUxR2bBMNrmhmLHWgq1Tcro+25aduguAUZy/Rb6dWwai2XlB8nWuMBLORcyikSbi7rioVgALp1ptniaUaaERiLM2T78wtW+8+2zA1rK3+JAZGSky/MbnmnTtVo7oyWbGfuO8n+Rn5D0rrfgk8sep9XomBTHtWGwm+aUiPkeoRIfj/FFVs/MvbNQjhszgmRTzegOcFDCtFe15ArBOR2k9yjYQ3K6zHHA38lq4kpFndoblBoUh/xi6AmWGfTQNHSj0vbz2AqzdcwPISgleEjeQp8aVP96Cr3MF3H83A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.15; Fri, 6 Feb 2026 23:06:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 23:06:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 stable@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 surenb@google.com, Matthew Wilcox <willy@infradead.org>, mhocko@suse.com,
 hannes@cmpxchg.org, jackmanb@google.com, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
Date: Fri, 06 Feb 2026 18:06:25 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FF3C3042-8265-40E8-8786-333A6F627405@nvidia.com>
In-Reply-To: <CABXGCsNM8Oex-V3vFSUy3ftMw1fAweHZHQYzRHWU9M6gm7r-rw@mail.gmail.com>
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
 <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com>
 <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
 <7C7CDFE7-914C-46CE-A127-B7D34304C166@nvidia.com>
 <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
 <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
 <CABXGCsNM8Oex-V3vFSUy3ftMw1fAweHZHQYzRHWU9M6gm7r-rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB8297:EE_
X-MS-Office365-Filtering-Correlation-Id: f0fa11d3-a225-41ef-e3c5-08de65d45dac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnZwWU8vVTUzdlFiUjZIci9YditiVWVjZmYvbXpvN1VORmg3Q2lua2xNVkRm?=
 =?utf-8?B?dUg4YUw1ODhxa1ptNll0RHg5cy9mcjJjV3BpMEFEZm94N1hHekFGb2hoS3cw?=
 =?utf-8?B?MnNWL2xwRmdKdVhMdFk2L0JyUzRWTWgrVURaQ1hkakNwRmwxWkZLWUxzTzFM?=
 =?utf-8?B?eEVGTDFvSk5US1MySnRkdUZZOGl0bkFiSk5EbTdqK1NSdmpJdUJXSG5xU2JX?=
 =?utf-8?B?MkRFTWdCVGhPSHpqZzBCRVNZelRsdjJGZXNUQWxMVHM1Z1dEVldMTHlKNjli?=
 =?utf-8?B?TW02c3dDRzBRUlJ6L0RaZXF5OVo4cVlka1ZrNEdqSUhyejRoT2dSVzVXckRy?=
 =?utf-8?B?dmwzd3Q1VkJ6OGFZNm8wakt0TTVjZ2g1Q1crUHUxdWFmR3JGdWdDOU42WW9s?=
 =?utf-8?B?Zk55UTYzVGxyaG1EQlJXTFAyZVQ1d1dBYXY2M1BmR3U5ZlZjSUpWSENCTWtk?=
 =?utf-8?B?Rkd6MnFmZitROGRBNUNxWC8xNzh3K3M0VjRuR1ViVDhOa1YrQVhGUmtTM2x6?=
 =?utf-8?B?Zjc5ZzZ5R0w4eUNITVNMU29KcElGOUUrZHNCdjhzN05MZmNlcGVQM1FHODR5?=
 =?utf-8?B?Y0gzM2FRWlpCSXBwbjVhZm5RUHVTcnY0eUI3dEJqaWRlQXNlWjRlMnRBSisr?=
 =?utf-8?B?YVdkQTBrVjhCdEdBMkR2Q2w3clZua0xEbDNjSGttL2lJbm5HOVRmampaYytl?=
 =?utf-8?B?TVQvRVJpRzJwZlhYK3FUUXRZeGhNNER3dUo1MytDRVJJdGNCenRpUmJLS3lQ?=
 =?utf-8?B?THdmUWNxWXRwa0R1dk1oTzNrMk82U05CamdjcWxGdFhUNDJ0QWF2QmRDSlRE?=
 =?utf-8?B?eUpjRGhqbUFySGU0ZXRBME1MWFVzKzRLdG8vVEU4YjFYaHhFNzQ4aHJlUHkz?=
 =?utf-8?B?WjNiYzVYMUVBczFPU1IzVEJCUjkzRVJhcERHcld3V0w3RDlYbHJVeG82aGE2?=
 =?utf-8?B?d0wwYThPNk9LZFJMRzBxOUlRSkFaQ0diWmpiZ1JaRFhCWVJ1Zm54dEZJOUU1?=
 =?utf-8?B?bGhSdGoyQ1QweU9lR1ZjeksxRlBrcjZ1NDBRZ01PVVRpeTBNcGRuN3FBVWQy?=
 =?utf-8?B?VCt2M1h0cjh6R2pZQ256cUV1WExoeWxWVE5SWS9vMmMzSmpJWVhONVYxVFBM?=
 =?utf-8?B?djM1c3E3SnlRODY4QlJGNzJoS1lDYlZtWGhKQ2VMQ1d4RTFiQXVDalQ5Nmtz?=
 =?utf-8?B?RTl5NjZPTUNweDZjYWN4RHU0SnJsUUgrTEkyK1VpUHIyN2o5a1dsY1dTaDFW?=
 =?utf-8?B?Nkxnc2xoZHpBa1JmMWVGaDExTTlIZ0xzd1RqV0VQNTcxdUIra21HaGQrYWFT?=
 =?utf-8?B?R1hNUGN4ZDExS3JVNXZISllteHB0MURHSzMrRWZTZGVyc3VEM2RhOXUzY0tz?=
 =?utf-8?B?NjNhOEFRcmxxaVR2SzJXQUdTMGNHd1p4anl3UUo4OERVT3djRlNqQjlid2Ir?=
 =?utf-8?B?cVhNZUhCZ0FxbzVpTHk5SGY3SkdBS3U3K1kxTzJQRFhoQ1ZWeExlK0d6amt2?=
 =?utf-8?B?Sm1JQnlmRzZjbG90ODlBckJWZXlZY290V2FoOWx4RDZXdlpOUDNRZmx3alhC?=
 =?utf-8?B?eU1ZWld1MjJlSFRIODFRWFAvT3B0TTlZeWpIdnpFMTF4MVZTMllwNTBvbWEx?=
 =?utf-8?B?VmJUbTNXNTZ0Vk9FbytDVGpaRVk0T2UzVzhMTUFWOGg3R3ZKdkhZeTdjQmUz?=
 =?utf-8?B?Z1JkOE5UTXlsQ0pFTEFyL2ZYcGlDSHhDUmhieXRWK0FOUGxwZE9ET1lON2tr?=
 =?utf-8?B?ODdrenNkYlVDYTNqZnkxRmhDbGJDNGo1WmZjdmdZczViMGwvZzY0VVI2MnA4?=
 =?utf-8?B?VEtyMTNpOXNIeFd3RTZEMHhoRlJ4S1o2RmN0QlVET0JxRytmK0lQMlZNb3A1?=
 =?utf-8?B?NGFnMkNJSEJmVHpBbTJjMU1JUDdubmJkNWRDWUo2QzVFWHFMOUIvczY3NUVT?=
 =?utf-8?B?dlZRME5RUUd6VkZBaDV4NU9zeFlCRFFkVDNUZWJDcUp4cWphVVNEakRSUksr?=
 =?utf-8?B?dmlLblptWTYvZzZ3NzJZOWkwbGY5SkVOcTBHN1RjRFdISTBFcFdKVzhBcGUy?=
 =?utf-8?B?NFYwUlRIWUtncjUyWTczSzUyc1U2cXR3d2EwYUUzSXlEU3BPSittcTR1VFJu?=
 =?utf-8?Q?i2Vs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3lBK2xqN3MzZmswWHBqT1ZyeVRiRnlvTGhteEVPZXV2M1lidWhpU0hncDNh?=
 =?utf-8?B?ZzdqMzRFeEpMUHlqUmtJYVhwT2xLUmY5am5pTm9DWDJLNUphUi80dUdHWVhl?=
 =?utf-8?B?NE02a1hoZ3NDSjYyaklxTGVjQktqZzlGWXlkTHVLdUgxcXZTWkQ1ZTRIbjVL?=
 =?utf-8?B?YkFCczI4WkREUDV6ZlRNUEZXWnlDTmpma09pY3NNd2NmQWRaYThFcDMxNEVz?=
 =?utf-8?B?UTBZcHNRYmJFWlRHM1NLaVBRUXBIeVBwSCtKUlkwSWpYZ3V1azVmSzROcDg1?=
 =?utf-8?B?Y040MGRoLzl3WEZON3h6L2doSXpUNlh2R1BETC9OR29hbXViK2xqTHpuRWM3?=
 =?utf-8?B?ZVorM0xleTlQRGpTZFowVmMrVGFLT2toQWRwd2J4RWhjWnV4cVFoeFJxRXZi?=
 =?utf-8?B?STlEYVpRYURyRDJNQUg0R09nbWFrQVdib0JkZmFNTitTR24vNzVXdVYyMmRZ?=
 =?utf-8?B?VUxqdlJ6ZHg4czIzTWMydHpXb2xpWWlUaS9Fd2VVdlpyRWk0dnpCM09pMmVC?=
 =?utf-8?B?YjgyRG5IUG90dnNrenE2UnkxUCtTVWwramx6UWlIVUFjVXhzOUs5VXpzM3RR?=
 =?utf-8?B?aUwrUkZGa3VMci9neVR3U09JOFhJeXFVOXltNFp6K1R4WEZWQVp3ZnNGdENH?=
 =?utf-8?B?REhBTklFVW5EbFNOWXdIbkRneVB2eW5NdDI4MVNRQVQrdkEwZTJUVE03M1FL?=
 =?utf-8?B?MjF2M1VrcUdVcEt4YzBPclhrOFFvbXU0bVpqNkJvVHVNd0l4ak5IM0JlcTE4?=
 =?utf-8?B?ekYwa3BBSXdLQ0cwaUQwdUhVVGJjMjJqaXJmYXV6T1ArTjltYmVTc0VUOEpp?=
 =?utf-8?B?Q3d3ODFwOUwyZEFIZUxBOHAvZTJYM1I4VzRhbDZjaG5hb1VOWXExWmRzSjBx?=
 =?utf-8?B?UnhCQTBwM3g2YzNMZG9oSGE2cFFXSWV5YXo4bVRBYUVaeENoVS9reDhJeTNC?=
 =?utf-8?B?MUpOSkFBd0creWI4alZvcjhpV1BuUXhaMXRWbjVPZGdqeHdGZmJKWjJudDZX?=
 =?utf-8?B?by90STA0b1VvODlWL2hld1RrMERsVkM4QU5hZU1sN1BjOG1ZVkZuUm9XbWNO?=
 =?utf-8?B?TTkrVC81WjdYaVdmMWRkcFpyYytHWEFCb1IrRHY2M2ZsQ2JtbE9VcjFHYzRP?=
 =?utf-8?B?bS9USW45Ni9RM3c0akJGb1pEcklOMnkvUmlNZU9rTGxDQnpiZ2NQK3Exc3BC?=
 =?utf-8?B?Q0V2eGhrMFVmWC9SVWpXSkY1NkJWSW5UTEoxS2dXMFdyV0NvMEFDTm9YcmFz?=
 =?utf-8?B?bndJQnNTU2dTMGlhbjJFTG9EaGxiWTd4c3ljUi9pczJScTM5aGQzMUp6SmFv?=
 =?utf-8?B?dWRFb3E1QmZ2OGM3cDZwWlJCdEwvMDA5UjRqOVZNeVVaUVVDRlUyQjRZR3Ez?=
 =?utf-8?B?Qko3ZDdGVDZEbVIvTjlrR3A5d3poMjZ1VjNmS1Ayb0NGRlVGVThhd24wMStM?=
 =?utf-8?B?SmU2N1BJLzdmQk9RWTkrZ0JZQm9uRTBJcHhBajNhVnpvTXkwVVk2VTlXdnBt?=
 =?utf-8?B?SDRvcHJkQjB0WUpNMTl3ZGJNaU1xVkl2SllwdXl0Z0RIOHh4ekt4eWZTMGpM?=
 =?utf-8?B?ckwzYk5BVitBaXprNEVBaC93endnU0dhdmdGY1l3MEo1Y0JwWXUwbDc4VVoz?=
 =?utf-8?B?YzRhRDhlTXJEMXk2Z3NTOW9lQ2kxeUtnQnhuMFY4Y0NJS1lZWVVkcjZsTE9o?=
 =?utf-8?B?Mi9nMHBlRnF4bUJjSVExQW55RnIrZEZuUGdEWjVtenNtVWROVERWRklKaDlr?=
 =?utf-8?B?bHhEelFlSC9MSEZlalZ0Y2QwdVBEWkIzTzVzaVM2Q1BQRnFOSnhGZ215TXM4?=
 =?utf-8?B?N08wL0pIM3N5MFV1Tlp1NnVkZVE1ZFRncXNrNFFzQXp3Y2JsMXBYNjBvTjc2?=
 =?utf-8?B?WlFuQURWemdIdC9OVXVaS3JrZ2pyK2U1dGxlWXd1Q2FrcysyVzBCekpkNUsw?=
 =?utf-8?B?aFl3aHhLbGo0NzRDK3BWTGFCOVdGTUExQ21FdGJkeThMb2FPc1VDQ0x2a0l3?=
 =?utf-8?B?S29TTUJFMHExaHZUN1k4MytuNXIyaTRFc254enlVeGxYbnNlQ3RxNlc5QWNL?=
 =?utf-8?B?eVJ5TFpZY0ZlTlVzMUUxc3F6b0xuYS9NMXg2TS93am5wMmhpdDdodDVoejdS?=
 =?utf-8?B?WXJOUG9VZ3o5c1ZMOFlIZGlHa1V6VENBSk80dXZmT0VGb29CK1c3VmZLQ2hN?=
 =?utf-8?B?aUh1T3MwaTU5bDBYaURNZTIrVnB1cjBHWGw3T3J2QlFxTmNmU3VidHFvSTEx?=
 =?utf-8?B?dW1MK2k5OCttdDF4cmdzQjZDS1IzNFBseTlkN1lGZE1EdlJkL25xQk5MUVV2?=
 =?utf-8?Q?WpppL2YNUFSKud4YP1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0fa11d3-a225-41ef-e3c5-08de65d45dac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 23:06:31.3674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwQo2DdOEAEA+ga7KWX0isEUksUmmAHqI18SxXt3KhdOKZtEmLEEKEP0l/1zZJRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8297
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E192D120002
X-Stat-Signature: jprbpkttwfnpftcpksxiuime7dj6uy4a
X-Rspam-User: 
X-HE-Tag: 1770419195-852367
X-HE-Meta: U2FsdGVkX1+xBIPSn9MZB2aUoJjerxirAZHAv5t6K5Bmfb2ktN/MsgTYmVDMm5vQXcpSlY0zQijzXCxRVb3NzzjCf4dkKyRcyU/7TcbvzH7FaPpBwgMWEz1VD8gbw/Hsp1OYyRJu1DJj4eWHcuBnkcNVokTUEAgLWZ7/8ggpm1sJ3QY/I4Kug6gYAqZ8A/Ep6VnPinWRNBK5AZbi87MS7M1FqwDwXdyQoKpKW85yJt+g8rgt0EEAe2zERCoeXRix7tmEGHO1ejT1vu5J8hkgzWa+tOhFhm4q3AgJkOz/2E9jwdsB0rMX+eiSWddLUTL5JsFLHRWd6qp12hQtvHsK75mXYHod66i9GeK6Sd7WJ+eI1DeT/IIkK/Yf/PaGe2pRCRagIxf5ulD98GacRaZ562ngJNJeTs5y/WFmv4i1JeyP08tHWelxkF295+Mhd/KDaLgDQfiJ+wRuERSxcM/+JtMqBUsVCuKdSnukdwDo/jb9glDJjqzxdQesMNOsGscG3QbalwN1QqSP+eb92pRX5Yhw8Iz9MnUvoBpSMxPDcY7225XgNzmABZ2ae6crRlgTypjD/60li8Ad8zTeArY2C3BQaJFTohv1CpZopUhgmpZ/e9GkKLLz8KgQ4MwkYS178tf34eGQgj3dkUV1vYoVLNWKu6NqydYHmp+0u+NabB8lvqDjzAZaK0fQG0uPxWQh7Somu+Qb02YUTv1Kyacp/FQG0g2C8QzzJV8fQh5AcR5Ub7Y9k4hm/xUiFJP/qozjLEKRjxfR21yMaIEbWrMk4ZSXdIinqKZf7e6xZtnC74he8lvvmDG7eLUhgvmOj1FoKSioljAT1HVm3kJEcWb2Ni/T2SUKj90MVuhnIHSP12KhskH9bjZID1uSVH5/vPZKiAQQNtF/rg/oeMOXjFR8UKhGVZV9kp0tyI+LZArtpVYKnPTr3ALto7q9ajlPkqixQKUNEXxJW94IJ+6/goe
 B75cVBkm
 fI7JQiTJZJLe8KIXbeQGJMHrVcuEHpHAlI35UZEJlzLJs8Cyuga0sk9zlwY7wpYokotyDWnvO7xbPEH0oUNKl2oCZTsEbM1EJecpJ3zhSbjbqzWAuIiTGBbozoh6b86ZrKsKSoZSXThgtBGa+JI0N3F85xaNad+Oi4MetksvlVxEnEAMx3w10FglyXuyAZKixeAjUar0KeWEGhc9pfJbaXUOH2qn+p+hC4jd1fISUMUJ7OLM3wACNVrQxhXvNMzIZ4fyw4Cwvl0q2bLWCMNirLkSm3Jie8T24YkS7Df0dwtTsuHsdDEnMF5IlwDoOD0Klbz09EKCVrvuCkpEwgsUejWnVsyrC1KINAhK7GklZStyBKKPGBjPAn8ru/W0qy5b73cvCcQBZYTFTo2rVhqWTNU/N3A7veRaf7Yj1PU9Dr5w4NRnY5k+5NZ1FkZMaYLlyKECb+L54/d/AXg8DlqHM1FyafY69mncohSybBr1IDhlAfZHHma1KcZtyNl16RNEh8fwZayHbgOjKKdd3MkqILkI+VX0Jys2oN2OY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Feb 2026, at 17:37, Mikhail Gavrilov wrote:

> On Sat, Feb 7, 2026 at 3:16 AM Mikhail Gavrilov
> <mikhail.v.gavrilov@gmail.com> wrote:
>>
>> Hi Zi,
>> Thanks for the deep investigation!
>> So the actual culprit is KASAN's kasan_save_stack() leaving non-zero
>> page->private.
>> That explains why it only reproduces with KASAN enabled.
>> Looking at the code, kasan_save_stack() doesn't seem to use
>> page->private directly - it goes through stack_depot. Is stack_depot
>> the actual culprit?
>> Happy to help investigate further if needed.
>> Regarding the fix location - even if we fix KASAN/stack_depot,
>> split_page() clearing page->private still seems like the right
>> defensive fix.
>> The contract for split_page() is that it produces independent usable
>> pages, and page->private being clean is part of that.
>> Other code could potentially leave stale values too.
>> I can share my .config if still needed, but it sounds like you've
>> already reproduced it.
>>
>
> I think I found it. Looking at mm/internal.h:811, prep_compound_tail()
> clears page->private for tail pages,
> but it's only called for compound pages (__GFP_COMP).
> Before commit 3b8000ae185c, vmalloc used __GFP_COMP, so tail pages got
> their page->private cleared via prep_compound_tail().
> After that commit dropped __GFP_COMP, tail pages keep stale values
> from buddy allocator (which uses page->private for order).
> So the stale value comes from buddy allocator's set_buddy_order() at
> mm/page_alloc.c:755,
> and __del_page_from_free_list() at line 898 only clears the head page's private.

set_buddy_order() also only set head page’s private. And at each buddy
page merge, any buddy found in free list gets its head page’s private
cleared in __del_page_from_free_list(). The final merged free page
gets its private set by set_buddy_order() at done_merging. There should
not be any stale values in any page’s private, if I read the code correctly.

If it is the problem of buddy allocator leaving stale private values,
the problem would be reproducible with and without KASAN.

> This confirms the split_page() fix is the right place - it ensures
> tail pages are properly initialized for independent use after
> splitting.
>
> -- 
> Best Regards,
> Mike Gavrilov.


Best Regards,
Yan, Zi

