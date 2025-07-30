Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE86C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 15:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593D26B0088; Wed, 30 Jul 2025 11:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B3A6B0089; Wed, 30 Jul 2025 11:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459DE6B0092; Wed, 30 Jul 2025 11:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352F66B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:58:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9EB059244
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:58:57 +0000 (UTC)
X-FDA: 83721389514.29.30398F0
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA4794000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:58:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lAd60vux;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753891135; a=rsa-sha256;
	cv=pass;
	b=gABxALey2aJpgk+C9bM+UgBERBsnXiYgzUFiURYvnI8uwdJOgyL1TRcO+9O5/AZ+k9nzNd
	FuDeQKMPCi90oXY339a0J5Nca553VSWEegriENyPfx6sWu1YBif3LPJh1IFlp8WUTSEcvN
	Iz7mafEXKf8S2RA1DW4f9aMLNjULWpw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lAd60vux;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753891135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pR08pOLASgr9UHvIE/Zt0YMRlJfrU9/0eu41D+npicM=;
	b=lMiM732CNeELRvDEy6aezNGuROfBtd53q4CLfcFUjdODjzYUVDuSeyh2RF5gfrdvPro+H8
	ZpiEbGVMAtp8tsmkxM+YTyMk24nnXqEaz3Oejw3V7H05ojacnWYUASJMiQnK1BhiAFXG5n
	/IZmwcY/h5PM4dtMsyLKAHMF0uAAHy0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZ0q8Ca6rc1ON61934hiLTS9mSoI/MyoN8d12keFJVeibn+x1E+2PZUu6yg46odTJ5yYmySPYAANGr6lRMvN9Fi0kVNvqyQGer7OclOpxGECUAQ5SqP/OSiCImSEudWKEJYGrbj61kp45dBK2YOOxfueOokQmp58hJ3NDqrOYbUaBx4Yfq3GvqFaY4i4lSQjohid0Q6L1RnMri6oflx6u0EZ3xnwjqModrD2u9R/b4Y2aCjfO9hq/K8xfOg57H8FiESbs5G7zyM4rogb65DqSpYakgEXns2I1AkQAb5tomlJI/x0PvuC7ExZPDoK6IPoLl5pvliWepbHKW6y5nHdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pR08pOLASgr9UHvIE/Zt0YMRlJfrU9/0eu41D+npicM=;
 b=w5yGNBVh7u9xgNKgHGZFZAbCw7mg1opp4uxxDPWQeckd60t3ON3WXHWhxVXhCucpHvAeG8WPYGna8bqC+oLm1UWdNjVZvDWCh4T1uGgiTps8/spi1lRKK8on6otZVh7CPkT1wCezZVssSkPmlW4lmQLybJVc7dhpO3eb+cS7OOQ+NvFbDouxgmAfmJ7AKAd7xxBRyE6jR0PMd1c3ZOzO3vbBYkjfqiaiP4UHzbYvZDTgSqFjbhCJnGxD2x6sHHE2y5lzHPV7G1FlVhRzhN64j8c9TIgzks8W2zpchhoyHqwMOcwXTwOWgncaBwsU6PbR2tBEx8dTl90NDXJOSwU8HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR08pOLASgr9UHvIE/Zt0YMRlJfrU9/0eu41D+npicM=;
 b=lAd60vux8cWp4nQVPBVPh3NGjHwPsjfFkMpeOHpRjFqem7Wx+eyTZQP0oJv9zCJAy1MmzCJ9azDcx0678z4h5C2kWvvmbfHmdklZoSRwi8/hxwxySCjrMOGkqp5xJplJ0wTK89UdfKCBFd46ieu3Lk0zT4f/Spo2286zGSnamCy/S7HRfOnTlNopgp37VtL70pXX56IWlLNTnS+VLZ6CTEyjdp50yIqJh9WdOR+st7vOuCJDTxN5FmgFbZjvyN3Ang3piCMTgNktbKonR/Qz4ZLNzZdZzkAb1a4yIEGoLCIx+ITBHC9epkI9rfJUUCwSIZ1CFVTHEGv11nCOnUSBTA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB8023.namprd12.prod.outlook.com (2603:10b6:806:320::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.23; Wed, 30 Jul 2025 15:58:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 15:58:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Wed, 30 Jul 2025 11:58:43 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
In-Reply-To: <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0216.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: ecadc19c-af52-4823-248f-08ddcf81f96e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1phemduTmcwVktSRVFHcjc5VU1QYVJMQUE4TmlIYlV4TzcySkVJSU4rWUhI?=
 =?utf-8?B?ODRabG1Ub09UN2pucnhSR2orWnlhTmNhaXBWOHZOOU9tRGRlSFkxaFRlV1E5?=
 =?utf-8?B?V3g1WXp0TzUvT2FoOEFxYXVHWUlWRTBreVVFOEdpMnJ0UHowMUlDMGZ4eisr?=
 =?utf-8?B?dkZlSDU5V3hUeHJBOXgvTXBialovMUJrcThoY0V0MUVPNmQrUzR6a2lVaXdi?=
 =?utf-8?B?MDErWVlYdUtvYm9LTFY2K2NGY2RKa080N2ZWSTZJWDlTUjhvVnZSUnYvYTgz?=
 =?utf-8?B?ekZRcmNZRzVhRVZ2aGsyWkd0M0Y4RmpmaXNCQnNVVlJ6ZnpmQyt1dXVOMVJS?=
 =?utf-8?B?empiajJGQTIvOXlTNm02UFA1c3hHQnZmdG4rQjdFZzczV29teDEvT212TmxG?=
 =?utf-8?B?TGZGU2NjczFEbklrcW9pVHJyQnVBZVRaemlKYjdhSm4zNTVPTlp0SE5nb0Nx?=
 =?utf-8?B?UDJTajR4WnI1ZFlFYlgyd05TV3Z0Z0F5QXovc01uZmUydXlaK1hBWUQvMDFM?=
 =?utf-8?B?NjFGMGpDZGtHd0psQmI3eU13ODlET2puWkhXQWcyM2p2eEhnTisybWJ0cGI0?=
 =?utf-8?B?ZWh0UXl2N056eFZHa1MrcGwxNDFhdkFBV1VxUTQvN2l2akRlMXpKTWsrQjln?=
 =?utf-8?B?YkErZkpPQ21WMmpLeHlZNmhFV2wxb2xuZ01uSjROcjBGMmdQVlYyZWJDOHRG?=
 =?utf-8?B?STkvS2ZwRERrM0l1dWJrbk14WXBYOHRhajMxSDRpQ1JxaVhXc2RIT2Z4bVJl?=
 =?utf-8?B?dUxNb2E4WnEyY0xwS2R4TEVsSXJTWGZwU3habmp5V0MvVXZTS1hxRUs5bUdz?=
 =?utf-8?B?VkpiU01ZaENpRTN1aEtNTi9NNFk3ZGF4N3VINUNOSHZkb1ZpM3M3SVJjZG5K?=
 =?utf-8?B?VnBUcTJjeUdVTmtweWtsNHFydTE5bzZIWkZkeDlMYVdNREx1SWZ0a3c2aE05?=
 =?utf-8?B?YXF6REp1dUUydytPNHlZQ2dSTHpKRERXZTZ2YllhbW80aTVGUmVwY2ZIWHJE?=
 =?utf-8?B?M0kwdWovdXZZMUZLVW9IWDMrOTBZMGQ5T2d3b1RWdWJjQ1pQM3J4cFI4cW5q?=
 =?utf-8?B?Qm1WZjdFZHdtUFo4WkJCR0g2ZFVSOUFuRjNNVFU5K1J6Sno1RFFSb2xwUDY5?=
 =?utf-8?B?Q29wQnVEeWIrSHkxVUw4TWt4TG1EbGVCTDNURDU0bndFM2RYMlkxSHNpVnpl?=
 =?utf-8?B?bXdFSXM3QTYrcklLNGxnOWNEUk1WY3dLUDFuZFBaMENrWDBCdCtPUHZNUUp5?=
 =?utf-8?B?alZSSjU5ZzJvMHUyb29SQllMRUlJWUJ4WllPM1hnUDBTS0hRWXlUMjQyb2Qx?=
 =?utf-8?B?aVNtZXdvM0ZVdThFNEZSVEtETU85bGc0VXRVb1RXTkdUWEVlVVhoeTc3STJy?=
 =?utf-8?B?RmtvMnE1bUgvYW9TOCs0c1lFVHAvcVBPY1c4bWVibnQ1VC9kSWt6ajg0ZWkr?=
 =?utf-8?B?RTZLa0NacHJJK1ovNGhiSTVRNjFlYTBXb2JlVTBpaDVNNkxZOVNXUytSalYx?=
 =?utf-8?B?aHp2VWs5cmovcEtPbGpqalV6bDFKYlJjbVA3cVFrT2dua0k2Zmdxb1U3OEpp?=
 =?utf-8?B?R3dRR0lWSlY1eU44dHVwMjhUMlI3RThMWGJWS2djTnFuNVgwTUxvMVJxV2FQ?=
 =?utf-8?B?TUVTckczWFJQeHZ5QTVyQlZlV1pJbHRiakRUZW9xSHVhQk9GRW1TQUdGMHV5?=
 =?utf-8?B?ME1GczRDN0dSTDBReGVVWUExaXFBZUNJVVFTam0ySHpRUmhCazg3VjVHSEV3?=
 =?utf-8?B?REdwYU1ZZmtqbEFQWnp2bU1NWDNGMU5NRmp5WC9iazBEa3hKWHFtV2tHQWo2?=
 =?utf-8?B?R0lhNm9MaERWMUdHcWhuZW9TVHM5QVlpanBQNXFTNk1Zekdnb25KUlZLVHdB?=
 =?utf-8?B?R01sWXB3YmdVY1NoMG5yUlVPeWhTZlVRajJVTENCN2F2OVpJc09nNGZBN0lQ?=
 =?utf-8?Q?6QxqKN/mhUo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEE0K2JsbXhJSjUxM2lkbEJZcnFPcjF5Mmw2NVlKUkRQd2dYbmJFU0pDaVk1?=
 =?utf-8?B?NHUzelA2OUI4a3pUTDFxR1ZYQUJKeXEza09SUTJwTldta1dOb3NzaFN0eDZi?=
 =?utf-8?B?NWhncHN6a3k1VUZ2Q2ZxZFRnUUxCS2sxZFdIQ1JROEsyNWl0a0IydDAwZVBi?=
 =?utf-8?B?UjRyVlVyVjdCYWVuN3l2S0oyb0NpVStlbHBWbGNiVFZEazUvYkkzUytaWnZ3?=
 =?utf-8?B?YUkwMUFDZFNwL0pIbTliSnQ1Slc3am9zMWNyRkNVWTJ0VTR6UDhjVjdyVmJn?=
 =?utf-8?B?YVZ5eHQzMVZDN1QwUmJSZ21SSVFpY21YUHhNSVVhcUNwL011bStmUWIzZ1Vx?=
 =?utf-8?B?eVNac1N6UmMyQkk0dWd5Vmo5U3VpWURYQVpGamFwblJTOUttVGFzaHNlNVNM?=
 =?utf-8?B?VzZuZTVQZkZjaGl4Um5pd0Q5ZkRVZEdVeEIzZjZ6Wm50T2J1ZUZLTjdBczJZ?=
 =?utf-8?B?K1hGbDRlT2pOMlJieXprVzI4S0xRT3RxLzlLcjcvUFBiSG1Ha1B4Z1RVNjI2?=
 =?utf-8?B?R3ZSSVcvSTgyclJ0MkYzM3pEQzEwa0k1MzFyWTJxeFNGb0pOd0grcXpJbEM0?=
 =?utf-8?B?U1BKbWxqZk9JVjUxdjJDTXdKdVFEQUlBRFB2N3I3SWNIdnZqRXgyRkNaSUd2?=
 =?utf-8?B?ZDRRZlpscThiZmxMbVVoRUo5cGhsQ0ZnNktZSEdWejh0bXF0Rzd6ZENZai82?=
 =?utf-8?B?cVRHMURDelhCSzd5UjBwT2NxU0luSWNHNlRBckJ0dWloZ3Y0b21FN0xLekk2?=
 =?utf-8?B?YTNhalFqeGk2ZDRQRGVZbzVaRlhDdElzeHgycU1WUFhqV2RPaTF1UU1nOTBT?=
 =?utf-8?B?QWhpN29yem1lRFVrWlFHZko3MXhaTXFBMjQvVlVxOCt5MlNOL3hmbFV0RlBF?=
 =?utf-8?B?bFUzZGI4RE5IeGNwdVlabnlaeitCRzlSZjh3SGhVSTZQZG0rejlhMFN2R1JM?=
 =?utf-8?B?d3RxTndMSWpiQW9iWVhVSDRIbDFUanhSWjE5NTdjaEpFeGtXWkduZDFjT0Vs?=
 =?utf-8?B?SS9MK0M2RDZQa1plWHFjT21FVE0zb1E3K1lQdkgrKzFua211azVMK2I1RzZq?=
 =?utf-8?B?eVlab3hLdEhOVEd0NTYvMVFXQ1RaY2VlaVR2UFY2SlNpdUl6djU4YjBlVzIr?=
 =?utf-8?B?ZGlJclZTWis0UDBZd0VDYkp3UzhWZ0lTWVk1b0dFNnBBdDRXek13NUJXS0JQ?=
 =?utf-8?B?dlZicnZjc3h5V1hVbjRLWitTcTE0QjVzNU1EM3l1WW9DZVBReXcrRlMwR2xk?=
 =?utf-8?B?Q3EwOUgxVU15VzNuU25MME95dHBzM0VPTGQxb1MzcXF4bnlBYWRGL05xTGZ3?=
 =?utf-8?B?YUlzcnNicWlzeUJ2ZTM4bjlCOHozd2pwK1VSYVdyT3pxZFM1MFVhMmozbFpO?=
 =?utf-8?B?cC9TZWl4UlJ2WnlRUUZFL3phRU1JdmJVSkxoRWVHcldYMC93dlcrUEIxY1Bs?=
 =?utf-8?B?b2lzUGdqWGlOdzRaYzFrbmFVazhiT1BoS2IrL0dja2Y2dXpSbm14YXNTL09T?=
 =?utf-8?B?V3lhUDB1VnRGL2JSODJoUkJLeVo1UDFjMXZHTTFMUGlOeTFUWFlqNzRYY2Ir?=
 =?utf-8?B?NzQzbGw5NmpuVnA0N0ZvbWt6YWJORTJjUkhWUGwyZlJNMzdJenhTWG93SHl6?=
 =?utf-8?B?cm5pNExpbmpEVGxtaGoyenVaVDJjbzFRNHVmemc3cmEwYUg5ZVZ4NTJtRXJL?=
 =?utf-8?B?V29kWGF5TVRhUW5IL0VNdER6VlpjNVJ3TlE4SHhGQTRqUWJVMDQvdFVmZ1lp?=
 =?utf-8?B?SW0rZElpUG8zQ1dXWm1ucVozWVBUZUhnR2pmN1Y5SWNUUmRuRG9IR3YyK00x?=
 =?utf-8?B?aVVnc2RiN2hMdmlVSVdyWTQvNUxsZVVaVWRmNU9QV1RkNzJXWFpFR0J2SHhp?=
 =?utf-8?B?a1VHb29xUmtBL2cwVTMyR1UrL1p1SUZmL3NzVFRnTWhMSGh2N09yem5Ca3Qz?=
 =?utf-8?B?TmFTTndodHJqSG5Ncy93cFdmV1AxOWVyV3lac3orR1BaeHhYWmYxZTFNc2Fy?=
 =?utf-8?B?L0txVFc5YkhqNXptaU13YUxkNm9QU3BDUGl5ZEx0YjFVM3JWc2FReGRVYVEz?=
 =?utf-8?B?TExuL3dZQ3lxNXgvSHc4Zm5nenBZL0hyUHJBQlNNTXJYWlpsZUR2SDFXTzNB?=
 =?utf-8?Q?nuAc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecadc19c-af52-4823-248f-08ddcf81f96e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 15:58:50.7996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xKBKBSemlFsraEIHXTIZozirO80AEvN7/110+V6P/XmokuuzblUh1Q5NvWyTyGc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8023
X-Rspamd-Queue-Id: EA4794000D
X-Stat-Signature: o4qmd5xzgh8n76j3qkheshg84baru7wd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753891134-678554
X-HE-Meta: U2FsdGVkX1/R171QyxpgtLYt37oHvG8CxyQ7Dzycw8ez6ionGU27WporHvXXW3EjlQzs2QNZzhv2JLk6tWJ7xFTK1C27LknCASj3WFNQW3wx3XsQbMVsRaebBiM/fIlzYp6gXQzVckZYsK5xc7tumU/3Dkg3SVeFmoHw7DxmTkFfrbg2BSAvB45yxKZp+OruOrj9KwdO2JQ+ZXVfg28JSyn1LPninnEdr41pkfPJOyf2WHlVloomeA00GyEMrN+COYpuWv/XH2UwoZrCMhYXp1jU9PXQdJwsV/e8mrPwhU4WaH6ReJyqP0URXP5JBizv3B2IzHMrJIQQwIIn7j5W52YPEKefimFCj8TVKwQ9UOA4p9+Yz5Ew08gk+jU/yo/MW9YWDZGjmYOcRvyR4qgnrqun552zC7pD4RcQWLd4FOpJjJnyPQM6LQo+2ERttSOTyJjRQHfVf6Ut82ilvx6dq0tb5e2wCUr+YDpXxT48xkMdwj3EkeOmDtxae7dJ2tzTFdWlCvBJBZdh4NhBbdy8dlY3L7zQI5xwv6oi27dWuE4HSfad2bIjMUPNsY3WrQBTy/PfMiEStfYrQsU0q4lkR2kPfshwfEy60LQ2EISCjpN2tl2gP9bjh45ioHbLZha2okX6zoqTu2ZIZQNBxyWspfVJ6CzA5gkFa+5Qjhj0AHAfGv3F6ySVr6hylv6Da6WM3Y6J4P0yPZxYlw9Xf+5zUjJEmxxGlT90XSkpfReeRBK7M5ZK6Pc55P+731L9yOrFYtm6O4unh3ekSHsCX+zRtnQ8h3YTbk6erzFq+ZP46towkNU4Lj4QHtu5ShMjdX6+/5WM+EWjAQWzhlQnarJ1FMOp+SfOuXkS5AKTg4Ttuy0/x3aLQVsGpkuYwFFBf1zljd8s+fOvHQuPCA/oILHGmp42nh7eI50GEhNfxnlwl7EY15O8lCdYaS4GHFpRkYFmetdIX9P+OWDPFBVHgAC
 jZvUfff+
 DrAU393YWcJDinRftppxDimthdSuQPx7zNG0sHDPYrBFxWQyweOhCKfxtZcIFY0Oca3QM4LZ2iiKtVm/LSaScE0qUajmPy73aKJyk8wW3Y3EJhmo8VUZedPmKSrIADfeLvd0NMe3M6+r0D/jR6UF8ekyubaz+nJ88aGz5PjK20/WqbZ9I/FuOBZLOBJH+GC6PyxEI+LstHUIhDrEP6YN0xyX1kxSdJLK7CtSRuF7BLTMdP7LeBV+qFrN8AVuJUmA9xBxfKVM/SMmVkTdWOLSEtSJtfd4S6RmlFX2YlIehhKwltRSliZkeKLgk1TP1z5vpwwkMRqTTc7lkffAOTP7st0kRK8kozbHHa3Vhf9zxpQlv+U5pGBp5/gsVhP3ZR+jualjf+oKUsJrKK72jHrK+DeGer8be0AIinDMgTx24c0uTDsPrBfDtPy6SbGtqb+jYCgV/2Jfyxk8f/+T6FCQRrDAPI6wSDTxDDzklnfRA04m3qmTML1uipiDZUi3kcuA/JcEBuP9JoHeMhRFPZo2adIY2rDLdmBwytia+FM5AJ78fg9IGa2sCALCMvvpiIyPI689R15ZzvORmixPuLXG0tmJqThnsJKWQFoS1bJC7eDIlGNX/wKNUN3tMtf5dQT1iS3kIIspv62lmp6VQTPR4e0kzdzV29rl3lUyQiJl6frjqYUYAzvR98jB19pJZgCrgW7KtjNATZ9gDjkKGAtgKacfy4jVDuSMOGyxJncDWmxTo5E/FTBIzisCuXnZzzgDgoUHyu55KpfCoxpRM+Pa6dj3/IuZgc8m5nUvReHN/o4UoHdMyquwbNQrSKs0OjLrN1JjW4yugXrndFwKcVbFdhWQ7Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 2025, at 11:40, Mika Penttil=C3=A4 wrote:

> On 7/30/25 18:10, Zi Yan wrote:
>> On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:
>>
>>> On 7/30/25 15:25, Zi Yan wrote:
>>>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>>>
>>>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>
>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware o=
f zone
>>>>>>>>>> device pages. Although the code is designed to be generic when i=
t comes
>>>>>>>>>> to handling splitting of pages, the code is designed to work for=
 THP
>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>
>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device =
huge
>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migra=
tion
>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk()=
 will
>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations =
that are
>>>>>>>>>> not zone device private pages from having to add awareness. The =
key
>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, =
which is
>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>
>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone =
device
>>>>>>>>>> entries.
>>>>>>>>>>
>>>>>>>>>> Zone device private entries when split via munmap go through pmd=
 split,
>>>>>>>>>> but need to go through a folio split, deferred split does not wo=
rk if a
>>>>>>>>>> fault is encountered because fault handling involves migration e=
ntries
>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to =
be the
>>>>>>>>>> same there. This introduces the need to split the folio while ha=
ndling
>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_fo=
lio()
>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and r=
emap
>>>>>>>>>> folio.
>>>>>>>>>>
>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>> ---
>>>>>>>>>>  include/linux/huge_mm.h |   1 +
>>>>>>>>>>  include/linux/rmap.h    |   2 +
>>>>>>>>>>  include/linux/swapops.h |  17 +++
>>>>>>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++=
-------
>>>>>>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>>>>>>  mm/rmap.c               |  22 +++-
>>>>>>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>
>>>>>>>> <snip>
>>>>>>>>
>>>>>>>>>> +/**
>>>>>>>>>> + * split_huge_device_private_folio - split a huge device privat=
e folio into
>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device=
 logic to
>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>> + *
>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>> + *
>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via fo=
lio_get
>>>>>>>>>> + */
>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>> +{
>>>>>>>>>> +	struct folio *end_folio =3D folio_next(folio);
>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>> +	int ret =3D 0;
>>>>>>>>>> +
>>>>>>>>>> +	/*
>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>> +	 *
>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>> +	 */
>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why=
 can't there be other references in addition to the caller?
>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapp=
ed in
>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not awar=
e of
>>>>>>>> device side mapping.
>>>>>>> Maybe we should make it aware of device private mapping? So that th=
e
>>>>>>> process mirrors CPU side folio split: 1) unmap device private mappi=
ng,
>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreez=
e,
>>>>>>> 5) remap device private mapping.
>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is =
mapped to CPU page tables as a huge device page by one or more task?
>>>> The folio only has migration entries pointing to it. From CPU perspect=
ive,
>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a t=
o-be-split
>>>> folio by replacing existing page table entries with migration entries
>>>> and after that the folio is regarded as =E2=80=9Cunmapped=E2=80=9D.
>>>>
>>>> The migration entry is an invalid CPU page table entry, so it is not a=
 CPU
>>> split_device_private_folio() is called for device private entry, not mi=
grate entry afaics.
>> Yes, but from CPU perspective, both device private entry and migration e=
ntry
>> are invalid CPU page table entries, so the device private folio is =E2=
=80=9Cunmapped=E2=80=9D
>> at CPU side.
>
> Yes both are "swap entries" but there's difference, the device private on=
es contribute to mapcount and refcount.

Right. That confused me when I was talking to Balbir and looking at v1.
When a device private folio is processed in __folio_split(), Balbir needed =
to
add code to skip CPU mapping handling code. Basically device private folios=
 are
CPU unmapped and device mapped.

Here are my questions on device private folios:
1. How is mapcount used for device private folios? Why is it needed from CP=
U
   perspective? Can it be stored in a device private specific data structur=
e?
2. When a device private folio is mapped on device, can someone other than
   the device driver manipulate it assuming core-mm just skips device priva=
te
   folios (barring the CPU access fault handling)?

Where I am going is that can device private folios be treated as unmapped f=
olios
by CPU and only device driver manipulates their mappings?


>
> Also which might confuse is that v1 of the series had only
>   migrate_vma_split_pages()
> which operated only on truly unmapped (mapcount wise) folios. Which was a=
 motivation for split_unmapped_folio()..
> Now,
>   split_device_private_folio()
> operates on mapcount !=3D 0 folios.
>
>>
>>
>>> And it is called from split_huge_pmd() with freeze =3D=3D false, not fr=
om folio split but pmd split.
>> I am not sure that is the right timing of splitting a folio. The device =
private
>> folio can be kept without splitting at split_huge_pmd() time.
>
> Yes this doesn't look quite right, and also
> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));

I wonder if we need to freeze a device private folio. Can anyone other than
device driver change its refcount? Since CPU just sees it as an unmapped fo=
lio.

>
> looks suspicious
>
> Maybe split_device_private_folio() tries to solve some corner case but ma=
ybe good to elaborate
> more the exact conditions, there might be a better fix.
>
>>
>> But from CPU perspective, a device private folio has no CPU mapping, no =
other
>> CPU can access or manipulate the folio. It should be OK to split it.
>>
>>>> mapping, IIUC.
>>>>
>>>>>>>>>> +	ret =3D __split_unmapped_folio(folio, 0, &folio->page, NULL, N=
ULL, true);
>>>>>>>>> Confusing to=C2=A0 __split_unmapped_folio() if folio is mapped...
>>>>>>>> From driver point of view, __split_unmapped_folio() probably shoul=
d be renamed
>>>>>>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU=
 side
>>>>>>>> folio meta data for split.



Best Regards,
Yan, Zi

