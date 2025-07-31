Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EFAC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B076B009C; Thu, 31 Jul 2025 09:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03416B009F; Thu, 31 Jul 2025 09:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4326B00A1; Thu, 31 Jul 2025 09:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8CA26B009C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:34:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F30616077A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:34:29 +0000 (UTC)
X-FDA: 83724654258.01.3630CAF
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86010180004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:34:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UMihazib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753968866; a=rsa-sha256;
	cv=pass;
	b=UD1EP9PbTf2SftSgyRqyRUtNaZ2XbM00tv5tMMzAhOs7m8i00FjLc0IqFy0PkmG/PvhDQ9
	VWUyuBgCykH/BffkC6FKmNTGQKSWtcyFYanuRU172KbDJCbYO//ENMBbffA8iWhtBqdjoE
	wCQF07E3oJY4BM+tDJKb2XXHuqPZR3A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UMihazib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753968866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kr3rQm8HjV3okzFUGq4kZr50yFcAdIDfwePDU17SskE=;
	b=DMgB10Gxvr8EHhCcWEWc9GDq7Lb+BBcDXFZ/+hBBt0YcutvY+Ht3cUpf47jIESctzgMYRv
	UcwRlMns5UyL6Kjcjm68yKfSRHrUZwcDKz7v0R92qrbkUt3sTUqWddFVzIPqrYp7Pjg/4y
	CPTnhWTktvKjlkRbU8TOpQ6jLJYaC8A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JaVtxY5Rkl0o7TeYGaXmZLpC9sl8wUxc0VN+0q19n+kUG/DUSyxZyIhrPk/Dho0TKaqlwYi6SAzpXs9mbzLVzE86/uqHqV0C0vqbIY099U3o9oq2Y82vcofxfsF4F5LVqXXUBuGJjfWkClXmOLlnmzjBHwhuj4T5A9dmK2LtsTS15vqSlnYa7WQBcS9Xc5pg4HREPmB59DXoKu3/Vyd+oza0tkzSgwwkE2MHcmFboMy8Zn9g2MCEXCwPPtVYHtpbQkCItki3pjnYdNXys7OKuy0yzfEs73O7iLPAuDQ0whEL1FPJ8iTTntDZX+F1JoWolXk6RfM0OzIBnRbUJEKrHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kr3rQm8HjV3okzFUGq4kZr50yFcAdIDfwePDU17SskE=;
 b=qOxzmmJvXwP/ZrXHutoPdf3Jc5lA5SpK5Mu6gA13YP5zUHLUrVQwubpdfD6/F+DBK2ePBVITgcYCwzSm7kLfExQ3LLOb9LAu82t91ePJI0nz07HvtIobCnAASUSMeXRZT65x3WE4nmOu6gFOHadv0k7Qez3oCwbpOsjYRTE2xCLdbdANyY6lRRnvC3L9nDyM7lbHs03jGr37cGd/pFIE7GnvWY7YpBG7eB3dIURGMHY4QhSolw6veABLNQAhXb66ZDpmTJiNkKy6tkbVudtdTNhpttV3OyspJKtee7lvNWfSOgWFaekHcLnackU9+DnEBPXfXDXZu0J087s4MtjyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr3rQm8HjV3okzFUGq4kZr50yFcAdIDfwePDU17SskE=;
 b=UMihazibAT5UStg4zWwa76c13XmRTw/HF92gw5tmgi1hfHdjXVe43bIaDwIW9wd6mhwiUoD+tfVs1sByWf/LjfFpf5WzegzPY3Z6qV1hFyNgLuQpJkJ1c5KUP1RChBBu9ETbsLb2p9NC/VtaCr1Iydgub2ZVQ4I6KcfdC3QP6DhL7pK508I8Sm3a4khWEJ+a17wZmEdrLNfGnD4qydKqP/OFjpJzDzK9R5IngNg8MkqPUcu6V7MZ0wKkVM1WwqUKMkKOCf1DJQ4TPYmRWcUFlunRSsNOGbuWBhdrTHS4ncOrAELBAhE3z5lHM69/KeDZydGAW+aEKxY9bKiOe5QZxw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB9529.namprd12.prod.outlook.com (2603:10b6:208:592::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 13:34:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 13:34:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
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
Date: Thu, 31 Jul 2025 09:34:14 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <182044F2-657E-4FFA-AED8-225304AAD2FB@nvidia.com>
In-Reply-To: <ce3e6955-4a4c-4cb6-8dca-9f15807b6165@redhat.com>
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
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <ce3e6955-4a4c-4cb6-8dca-9f15807b6165@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0155.namprd05.prod.outlook.com
 (2603:10b6:a03:339::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB9529:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f174d7-47fe-4cb5-2ba2-08ddd036f4ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2ZnTld5L2lLY1BPOHY5WTFmbGpVcktEVTdUY2g5OXJ3dUJtUmdGTDkyRnR0?=
 =?utf-8?B?T3NCdC9DRUVpRXlUSnRZNmNxMEw3VmcwUFY3eDB2RGp0U0pDNU51eGxrQ3Jv?=
 =?utf-8?B?VzQ0cks5Q0kyeHFaeFdnaWRyTG1JaHVBRnN1eE45R0dSTVh0UVhzMHVEeGZR?=
 =?utf-8?B?cnJsTEFieHNOalVQUVlNcDdHMnIxK1NsaEtXVWQ5aWxxN3gxakk1V1RiU0cr?=
 =?utf-8?B?WktxaDdRckJ4MUk1OGxCTjdFNHhCbXJvWWJISDJTdi9SdzdjRy92aXhaamF4?=
 =?utf-8?B?MVEzbTZMYVhxVHVVVUtKeWw5L2FKQ3h4b0NLMWlkMkxkQXNKYzIwbWs3WFQ0?=
 =?utf-8?B?RTZienhlejhZVndwdmp1TFlMQlFSdWpMbnBTRkwzQ2N5emk4WEk3dVR2ek9S?=
 =?utf-8?B?aE5jZVdDNWxFdGdnRERhSzFjMnlZOGZEMUFBekE0SXcxbGNlNmJiWkFveVh3?=
 =?utf-8?B?ZXVpTzJ2SVZxODF1OU1GQnZTY2Z4V1dJYi92SllONHVDZVRrWXVUWTdNeXV4?=
 =?utf-8?B?MkZpQmdZZHpHV3QrZ3c2WHJSdU8rUUlGNEdKcFZvR2ZoVmxSbHV2eHZLc056?=
 =?utf-8?B?aHpIT1MzMHJtNFNmQW1xU3YwK1B1Q0tZcGRtaUhBUnZCT3hqcUNXV1ZPencz?=
 =?utf-8?B?N2Y3d0FUWHNyc2wyTzE0NWh5RkdsdjFlYUhTbW9ZT3k3MUNDWjN5azBLVHhk?=
 =?utf-8?B?K1R1bGdZOVRZWk91WHo4QUFXQm9xR2FKeThYcHU1a1BLbWlCWmdobWpybVpT?=
 =?utf-8?B?d1RKV2tlc29RMVhxcnhQbUhOV1JMMTNheHM4cFZHVDhNYnBvUXk3VHFwbFhW?=
 =?utf-8?B?eEVKU1prZThDdXE3UUFqS251c1Zsb3RUTGM1d1ZYWUhZTVFXMXVXZitHSEFV?=
 =?utf-8?B?MVJMNTVVTGtUVkpldGRvTW01MG94SDZKaEV2K29JRGprR2xhUkFNbE1HcEox?=
 =?utf-8?B?VHM5WGx5KzBOYTNsZlY4WDdIUVplMFVrTVRUdCtUbmJJMTJzWnRpUXhuMkxS?=
 =?utf-8?B?S2o0THFqaEdsckVRTjIwaDQ0OWxkTTJiVU0xdmNCZStlRis5b0Z6VDN5QzZu?=
 =?utf-8?B?QmlKdHo2ODBLSTYvNXlTK0ZzMUZWb0NKcEE0WVNYY3RDMG5PSytxUkVVQXpI?=
 =?utf-8?B?cEVNTGg2SG5vMnFzWThtZWpMVEZsVFZySWpiSFR6aTVzZXRGeFdOTHcrSERv?=
 =?utf-8?B?ZURmSlh1Y1NOc1pnL09CWlhmeDNUOTFJNW51TlNEejV0M3dBNjV3d3UwMFdv?=
 =?utf-8?B?U1dtSHNOZGRrMUhXUW5yN2VKb0xSRWwrUkFodjFOQWplVjFqMjBWYjljY1o1?=
 =?utf-8?B?c1FvN2M0U29hZ1RsSW5ZL0VGaHJQck1jODB3MDZ2RWRGQWJ3dXNxQ1paZnFm?=
 =?utf-8?B?T3NURlo5ZVZGcnM1NndEVVhINStFcTEyOVp1OVFLRlRwVmwralBpMXAxN29O?=
 =?utf-8?B?ZzYxQUFjZ0UzOUg1U2JiRUpsTWJsS2JCQ05QODFWSzRtemdFVlRQdnU4Nyt3?=
 =?utf-8?B?cFBLeWlNWTdzOXR6SWpZbTFRd2Q1Q244WTFKRGxtWkhlQTczNytlUWc2M0Yr?=
 =?utf-8?B?S0RJK1dXcVc4OXVMYUc1bzBTUFdaR29tcFZBUDZZMUJ3TDExQ0RvbUtrbW5Z?=
 =?utf-8?B?ZFpLVGlrRlkrb2sxZVdFa2V5R2pBVVVuNG10d3lFKytGYllkRDlrVzlYOVBj?=
 =?utf-8?B?WFlaNFVEbEh1d3ZDcW9EY1BubFpQZ1AyNlJRWjdXcll0dTdtVytkdFNJVVlm?=
 =?utf-8?B?UEJuQXplQU1TNkZjY2JOSFdjS3hwRjFLZEpqeitRSXdiNkJqOFlnWnpxMXJS?=
 =?utf-8?B?RTc2WTZxWDk3ajg2REpMRlZpT0QvRFN0aDlTU3ptbW14T0ZtTjBSTVlweWZ0?=
 =?utf-8?B?RVBGWEdDMTJrb3R6K2dmeG9hZmswVjdIeFIzR25mZGE4V0RvUkJQQTVjQ1NP?=
 =?utf-8?Q?3YnfdzEkW1A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFRHZllrN3Y1L1NMRUlCYS96RzlpWC9ranNZSUlRMks2YjhrS2tndGdyd1py?=
 =?utf-8?B?dHM4S25MOGxuS3pLRkZuYUZnbElDb1hURDV1OGJ4WWRlZEdIMXFzOEF2cXE3?=
 =?utf-8?B?dTlGTGJUVm1kYW43OC9pbWNLdDArS3JqVVFzcXE0ellieW8vVGZNSWpSY0JZ?=
 =?utf-8?B?aXc0b3ZpTW1vOG5lcDUxMDBUQlVVaTZmZ1BaK2Rmb2RXWmorQzFpTDhmZkpP?=
 =?utf-8?B?ODAySlAyVmZ6VEMvVU1qZHEvcEE5RUR6eHBreFRwWkhUUGRPall3cmk2TTJL?=
 =?utf-8?B?RlhCMlJ0dGlveFpLdWpxaDUyU0dscm5NU2NvVGdUSkRxRXVWRHRLVlBJdmNG?=
 =?utf-8?B?V3VSOWVrRkwwY2xON3ROam96NTlHMU5ERFlxaExHb0doRjRnNTFOL2RIMWVH?=
 =?utf-8?B?MDBsd3ZwM3N5VlFTV0Q2VzhxWUdxZDFlTmU1c2xKOEtPTzlWblRvaVBYQkVX?=
 =?utf-8?B?VEYyOFRCblRuakd5WEhTczBNZDhJSnZRVmk3VHBaR2I4TkgzcTQ3Z3ZQR3JQ?=
 =?utf-8?B?WFhQNmRyUENxZURCWHR1TlRqMFVZTVVlRFA5TlJ4RlY3VEdLUi95bkpsaG9C?=
 =?utf-8?B?dkZCNlkyajR6WitqaldDTjcwMWZMOWZEQWw4NTZRenBxQXZ3RWtKelBKZXFk?=
 =?utf-8?B?ZEp2Z3BHQldKWmJrSU4wWGQ1Tm5SRjhyMVo1dnhUOHkrZ25KK3dxbzlmaGxi?=
 =?utf-8?B?RC84SFhsY25BZ1Q5USt1U2VsQkdlT3diK0R4VDRONmVac1lqK21Lb2VxaXF5?=
 =?utf-8?B?REZjU3Y1S3FrdFlnN1VCNlQyZ01mR0JlckluRHFBN3NDRjlKR2JOWWw5cStO?=
 =?utf-8?B?RkVUYkYrWTl1QVFlaThZdVUrWEJOMGY5cE5tWUxBblBRUkVkRXpvdk92ajVy?=
 =?utf-8?B?WFM5NVIxTmZSK0Y4MlFjd3ZPeXcvUTZoS0RBUllpT1ZwRkZOemFaa3dGeExj?=
 =?utf-8?B?SzArclZDYlJSeWs0clZUU3dlbDFPM0lDOWdUVzlXd05jVzN2Umh6eE5QdXdq?=
 =?utf-8?B?aDArN3hpWEtnZHVmVXRSUU5TTEVCZ2ZDN2lTT2VLUVo3ajhBOWh6WE5lU0RQ?=
 =?utf-8?B?SXlZUC9tOW83aFVqYTk2YmhNbVN5NHhMamE1YWRXZ2lFQ2NVdWQ5S0NUK1NI?=
 =?utf-8?B?eVhieTZHYjJwaTlKaS9ZMGdzL0hSbVNESHpibmk3dDFtWjhvY1dTT2JMbUdu?=
 =?utf-8?B?RXh6T2pGTWZxbktralJpL1R5bnNENmZwN2MwNXU4Q1Exa01jbjNCUW5LU3NU?=
 =?utf-8?B?cEY3RyswdjlxNGVpQ2YrTDNMY0xZTG1yeXlHdDJhQ2tFZHdIL3pqQk55d0Zo?=
 =?utf-8?B?Q2s4RnJiUXExTTdJa0pKV3dkaFlVREkrZHEzalZjdFdDL1FOY05FMG9JeGN2?=
 =?utf-8?B?cTZzOXhLM0d5QmR1bkg1Wm1lOS92dENFV3lsYnFoNk5sdWdyT01JMFo2NjVM?=
 =?utf-8?B?Yk5KeFgxMjB1OUdzMSt0MDhzeWczWXNsZVBsU3BwM3RJMWFkL1JqSk1yaHlM?=
 =?utf-8?B?TnNvYnVHZ2pyR21OVis0MzFVaXRRRDRMbFQ3M3UwU2tOYU9Fc05aZlBIRVVH?=
 =?utf-8?B?aHJZemM5NkpwOGR2cjdyTURRVmg2bUpXUXByeWJHSlhwTC9MM3NmTElpMGdj?=
 =?utf-8?B?cWZpUW15Z0V4YjhER0NheUo1RVI2azYyVEJKUmhFQnI4dk9QTnJzMXpjZUE2?=
 =?utf-8?B?ZURJNy9ZMk1kdE1DaUtPSjQxaDdmRXI5akc1blBxTDZVREE0SUZzTllJS0x4?=
 =?utf-8?B?REVxdzY0UXhIcUwzKzlzWkd0cm5qVWxiTkNaNFBhdkpvWTJJYVZpbUlWWWc1?=
 =?utf-8?B?U0VvV1JRSEVMcEF2QUEyN3NoZXAxYVl1UGxjZHlIWWJhOEZZNG1ZYndtUVJt?=
 =?utf-8?B?bXJTb3JmUTdaQ1ZXQ3ZZNnVkN05pVlhONUNxUGhCRHNqc2RaNVZPWjdvQWpS?=
 =?utf-8?B?VjRKbCtZU0NSQk8wKzY0U0hFdFcxdzFCS09TUjhJeHBKYVFSekM5aVFsa29N?=
 =?utf-8?B?aDYrTytHYmFYNkxjcm1sbXhQL1Q1NEVRaTNKbFJhMUZRUUxURHZlSDg2UW9W?=
 =?utf-8?B?SXdHTXpBSlE4Umc5cUIza1ZERzllcHYydG9nTFB6WVZzNTVkdGR5ZFZIMHU5?=
 =?utf-8?Q?dWNo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f174d7-47fe-4cb5-2ba2-08ddd036f4ff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 13:34:21.5930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHLZ9TmaDAgtXgZLNofv42+gR2/ieQf35GHERf+JEXK/LQ8mUI4NmKQ6GwUsA2eX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9529
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86010180004
X-Stat-Signature: 3acuectnfutq84zhxyn86zi3sxmhxuib
X-Rspam-User: 
X-HE-Tag: 1753968866-467624
X-HE-Meta: U2FsdGVkX1+QYbhRU9IczyIPRUcD2YTzvNa7yWF8wlY5+RTkbmzNcHDYV7HPO8TrSzBSPoRzQ9Oa4zU5tbEx3tsE5QoD6Gie7tCmJxxhNtKtFZNo31HB3b3a8m44xH/Hx+Rdt5u34Enr/f+lD00kDWiJ6MBPf1dGUecuZI119digtLG9Tl3TUgWlY2lVIg2BiHLBIl2CTN8enNBfX5z14ncEcH63XgUhg7ntkkEoHXbOKHt+CSNbEfvVgEo18DLyOuC9GWucSZVNzwbSmoDINvb/Fm7NYOYXUysXKiSVBCuwS5eaubLq6V54auV1Yom8wXQjsn7jue4WhqYDmF6zhgA+EaRbpdC0owTt9T6q+jVRH1egXeTxgGcqECrHcgEmUjKY5rVHrhhhFXz9Dbf0KyLx5NULGIfOhYZeGSQY6EEX/+4tngeTNdFYaSKisnr7Ba2V3iKTjPwNG5HH+QdapYwuZDEGRNjxG7eEZn3gkpakgNl1wGtpRBE01iiWaGKcJIoNa3EWp+sbpHrYdI1Ac4NaxgTK0tQcTHrnbG4HH9uABulnWxOhG0YLWJSUjVuhQAQsFfzeputzgc2K2tGad3XYmQV/v0YWllNgwlVyJeJQQ2PMk0ZvxgNLin2xhPXOGKClAjUcXIgYgQT/y3lN4SWtBa67Z4p9TcAqxup6aLV0ZUNEnPw6gWZaXG6Wj6uWu4AdvKO0pDMlL7wpUmq3DdmybdKG97POONG0yNO8tHlB/CHnUbPvL8Ki7JwZ3JKENvRUPCKzDAVknrbdF2tUbOBMISJY50pIAPmL2ihvhGS7sqmGPTiKLV1oN8AzaxVu9Sr7eZYkEgITaviypLEyURm5ER8pHcvcDb6CIEWkPjQbVawFOjwgq5zXTUWo7c9+zVVP21GC4fdzl/E6gCPyY+QTgOaciWnITDe4SfebjmP3cTNIoC7HzwBpzr30Lj1RJb53iVwnDmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Jul 2025, at 8:32, David Hildenbrand wrote:

> On 31.07.25 13:26, Zi Yan wrote:
>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>
>>> On 30.07.25 18:29, Mika Penttil=C3=A4 wrote:
>>>>
>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 11:40, Mika Penttil=C3=A4 wrote:
>>>>>
>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:
>>>>>>>
>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>>>>>>>>
>>>>>>>>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aw=
are of zone
>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic w=
hen it comes
>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to wor=
k for THP
>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone de=
vice huge
>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code =
migration
>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_w=
alk() will
>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locat=
ions that are
>>>>>>>>>>>>>>> not zone device private pages from having to add awareness.=
 The key
>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The =
other
>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty b=
its, which is
>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for =
zone device
>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Zone device private entries when split via munmap go throug=
h pmd split,
>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does n=
ot work if a
>>>>>>>>>>>>>>> fault is encountered because fault handling involves migrat=
ion entries
>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expecte=
d to be the
>>>>>>>>>>>>>>> same there. This introduces the need to split the folio whi=
le handling
>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calli=
ng
>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapp=
ed_folio()
>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap =
and remap
>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>    include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>    include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>    include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>    mm/huge_memory.c        | 268 ++++++++++++++++++++++++++=
+++++++-------
>>>>>>>>>>>>>>>    mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>    mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>    mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>    7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device p=
rivate folio into
>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_d=
evice logic to
>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference v=
ia folio_get
>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>> +	struct folio *end_folio =3D folio_next(folio);
>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>> +	int ret =3D 0;
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(foli=
o));
>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics=
, why can't there be other references in addition to the caller?
>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is u=
nmapped in
>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not=
 aware of
>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So th=
at the
>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private =
mapping,
>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) un=
freeze,
>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>> Ah ok this was about device private page obviously here, neverm=
ind..
>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and foli=
o is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>> The folio only has migration entries pointing to it. From CPU per=
spective,
>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmap=
s a to-be-split
>>>>>>>>> folio by replacing existing page table entries with migration ent=
ries
>>>>>>>>> and after that the folio is regarded as =E2=80=9Cunmapped=E2=80=
=9D.
>>>>>>>>>
>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is =
not a CPU
>>>>>>>> split_device_private_folio() is called for device private entry, n=
ot migrate entry afaics.
>>>>>>> Yes, but from CPU perspective, both device private entry and migrat=
ion entry
>>>>>>> are invalid CPU page table entries, so the device private folio is =
=E2=80=9Cunmapped=E2=80=9D
>>>>>>> at CPU side.
>>>>>> Yes both are "swap entries" but there's difference, the device priva=
te ones contribute to mapcount and refcount.
>>>>> Right. That confused me when I was talking to Balbir and looking at v=
1.
>>>>> When a device private folio is processed in __folio_split(), Balbir n=
eeded to
>>>>> add code to skip CPU mapping handling code. Basically device private =
folios are
>>>>> CPU unmapped and device mapped.
>>>>>
>>>>> Here are my questions on device private folios:
>>>>> 1. How is mapcount used for device private folios? Why is it needed f=
rom CPU
>>>>>      perspective? Can it be stored in a device private specific data =
structure?
>>>>
>>>> Mostly like for normal folios, for instance rmap when doing migrate. I=
 think it would make
>>>> common code more messy if not done that way but sure possible.
>>>> And not consuming pfns (address space) at all would have benefits.
>>>>
>>>>> 2. When a device private folio is mapped on device, can someone other=
 than
>>>>>      the device driver manipulate it assuming core-mm just skips devi=
ce private
>>>>>      folios (barring the CPU access fault handling)?
>>>>>
>>>>> Where I am going is that can device private folios be treated as unma=
pped folios
>>>>> by CPU and only device driver manipulates their mappings?
>>>>>
>>>> Yes not present by CPU but mm has bookkeeping on them. The private pag=
e has no content
>>>> someone could change while in device, it's just pfn.
>>>
>>> Just to clarify: a device-private entry, like a device-exclusive entry,=
 is a *page table mapping* tracked through the rmap -- even though they are=
 not present page table entries.
>>>
>>> It would be better if they would be present page table entries that are=
 PROT_NONE, but it's tricky to mark them as being "special" device-private,=
 device-exclusive etc. Maybe there are ways to do that in the future.
>>>
>>> Maybe device-private could just be PROT_NONE, because we can identify t=
he entry type based on the folio. device-exclusive is harder ...
>>>
>>>
>>> So consider device-private entries just like PROT_NONE present page tab=
le entries. Refcount and mapcount is adjusted accordingly by rmap functions=
.
>>
>> Thanks for the clarification.
>>
>> So folio_mapcount() for device private folios should be treated the same
>> as normal folios, even if the corresponding PTEs are not accessible from=
 CPUs.
>> Then I wonder if the device private large folio split should go through
>> __folio_split(), the same as normal folios: unmap, freeze, split, unfree=
ze,
>> remap. Otherwise, how can we prevent rmap changes during the split?
>
> That is what I would expect: Replace device-private by migration entries,=
 perform the migration/split/whatever, restore migration entries to device-=
private entries.
>
> That will drive the mapcount to 0.

Great. That matches my expectations as well. One potential optimization cou=
ld
be since device private entry is already CPU inaccessible TLB flush can be
avoided.


Best Regards,
Yan, Zi

