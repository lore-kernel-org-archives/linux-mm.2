Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A3EC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 01:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAB88E0009; Thu, 31 Jul 2025 21:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3843D8E0003; Thu, 31 Jul 2025 21:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2730D8E0009; Thu, 31 Jul 2025 21:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7558E0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:09:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45C4E1A0C93
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:09:46 +0000 (UTC)
X-FDA: 83726406372.08.A305A81
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FF861C000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:09:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y5hZZ7aP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754010583; a=rsa-sha256;
	cv=pass;
	b=nTcQGbgzgst/cRcw1LJBcEoZCzEIl3MNtvaj+uw3LmJ3YOTteQznJa32NkGzd7QL7DKEw/
	NmlutdSfwcXiFns4UC8I90UAA8cpAFoOo8XBwLOw7vjIrrJP6Xq3MFw/8GPg7QGTxeXrCB
	OokFi3yR5vagXFoEn9JDVCMH1GXXouM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y5hZZ7aP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754010583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKqXc+kjjkGqNsSZX7mxrZ3aF697e6aCnavdeAn4UpM=;
	b=32JkNk4dugh6aJw/ACWWrlM7J1Aa4wKzN8m6bjSogqs4Tz7cK+XG6E+g8hT1zuKrszgMhX
	P5vQhm+nnTPKLORSrB/R0QOPadcYfQZi5wQd0RUikXxs1RGPdHmxA1h5dvRprTK2DDIC4o
	BCHNNb9xzxIyrwZ7h9jU7TOHDl6FYak=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pG3TTu7YGvVBvpT/OznnjhWyWVGOGYk/Bo41ZSeX7e96czoRzKadWKIVY/Md8Y3gTCIaorD0R2HAPk/yYPzeAVkrSZkQcJHNl9OISDDI3agIjy1iV2UCfhvP0UMAFru+N0RFXj4TzUs9270KQOKL43ktj89bxq1sQlwyfrNe/qZ2Yqq0lr1MnlAhx059h3YltHo82tqlkzgzp+j1fbhQbor0yJM5qGza/w/GJ3H3pHcvbe7r0eGXw3/MZiBkM9PomS36txCTTUBky8oTd9f9ec4NkWjwI1XGDN4jF2ddTbhQUBD4UfTBitsaKMI3epd7idMhrAMRZXl2YY9shDHjxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKqXc+kjjkGqNsSZX7mxrZ3aF697e6aCnavdeAn4UpM=;
 b=M/04a9SXFkupd1l50RIWOl2IDck6xzzWNIQkC99mPrUSwRtr9EzERFetGv8ww9zSECFn1KNTY241rBIdZtxdCSl8hnuojvahRWk0sJBgL/auW3rUhqYN35LzkVteh+10qohTwcWLJqbQX33/2VMYYK9dxgJFCynuKmmOCAvE52lsmOLhI4IGeCT0P81zrBUbZrYTBB1ZYwA8/siqJvoS5jRua2jImTOCVEHF8klSUB25JXrEdMcoR+qbnRHstZuI0S345CYXpt0DwRYd55a2t+On+kHz/jMbhdwvy8KbHdzDFwMpNCcOKOzL+Ffi/0b+dtcolz6yr8ZSbyverbC7ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKqXc+kjjkGqNsSZX7mxrZ3aF697e6aCnavdeAn4UpM=;
 b=Y5hZZ7aPLoBIF8XPMqh6nfA1yl4OmJrs3kw0C1C5bandpoJXdzy7eE9J4ciDEbHwbM+H9nsYS6PJDn0oDZZpY390ESd49fvUd5UujICWg5+QppxV2yrPqDX1IqjL8jGOGbc0sJL4cB88Hlv8nsPRATOOHX6TIGOpP/6/rYr7aSSfcfVWm9aANRzKqwFRoRO83agxE0JAvLOCeO9JGgwg8Dro8iXLoiQSUhAWadqxKZlAu+pX7aRYzzbLNREjGKbrtCWb7GmO3GOE2c2Upefh7o1esynHseLqHAV4dr0vq8mqa/xaOoD86VXUinQ/cYk2lc24+ykRBOj+Eczzu8dNiQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8568.namprd12.prod.outlook.com (2603:10b6:208:471::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 01:09:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Fri, 1 Aug 2025
 01:09:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org,
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
Date: Thu, 31 Jul 2025 21:09:24 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D6489A94-4045-40C8-BF56-A378A5F52F12@nvidia.com>
In-Reply-To: <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
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
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 577c8d29-7cc3-4e08-a0f9-08ddd0981252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWt6OG0vRHJ2RkV3Ymx4c2J1VTYxcThrbjY4N25aSnpTVWNYYW1GWk9mN05U?=
 =?utf-8?B?bWNrTTBGTGRGQU84ckVpWFBLRyt1TmlCTWhEZnNrQWdQN0dpczNWbjMvQlFw?=
 =?utf-8?B?MGVkNlRVMXI5Rkx3Vk04cVlmd1NnWXlPeUhvMzR2WjNORU5SakhjVFl4R3lB?=
 =?utf-8?B?KzAveVpxcmlyb2IvaHU4b2ltaDJDL2tkWXdBZVZwWTFmcGgrMkJrWWwrOFpJ?=
 =?utf-8?B?NHhtQTlMTHpRd0xSOWQzZm02VHdjL0Z6VHJHUzNkNGhOY0hNRnRGZWlMTWdI?=
 =?utf-8?B?Nmt0UG9CclRTVWJBcTloWXp0NGlSejc1TUxUUjgvQlZheGx3ZnFOYy9qS3dz?=
 =?utf-8?B?NEYwSjh1RFBPZEMrMms1cGFnTnBGUXMzTFVsckpJdHN6REQ5VEZKZi9tc0JH?=
 =?utf-8?B?VEhQU1pyb0xreE83M0t4MElZQTBaKzFFalljU3FjWVZEckhUNFZldHdsYlln?=
 =?utf-8?B?b2FGVVpoVldidGwzQmF0MWJLbkhhVXdCYkVON2FJT0VBNjFKRTlSNkVFdXFy?=
 =?utf-8?B?bTB3WjBYUmtTaWpSNnNOU1FFSE0zazRyTGxOWHdmZm9qL1poZ0xvdStsMjFG?=
 =?utf-8?B?ZitKTEhiU2dGRStqOHFFdU93d0pMQ0RreXdUdDZsdnJPTHVvRGFRcUh3RitQ?=
 =?utf-8?B?Rnk2MkZWNHY2bWlRTjNOeXp5b3ZpQnFnNHE2bjljN1kxVS9jY2N2cE5ickRh?=
 =?utf-8?B?WVMwZ3hnZzJrcHFPcm1KMXArY1A4UTlBUzR3a0dLOGU1YmMxRkw2ZzVlM2FX?=
 =?utf-8?B?eGdSNnRwSUJiMlo5THVnOWtqdVZrQWgzVFowVExVcTloTGk5K0ROeUNFZGhl?=
 =?utf-8?B?Z01lZGk5SC9yeFRmRTI1eHI0REthUGFQRUhIWm9PKytqNlMzWjdLYnRqK290?=
 =?utf-8?B?YVZzTFNzV0FTU3NIaGxlT2c0b2xMQ2JXQkZvWnNtQWFvbGFPV0tqWStVQ0hh?=
 =?utf-8?B?OUwwQ3MrWWhIVHdaUGVYczFkYXJma1Yyd1diak9veXNQSWg2aC8vbGRHQkVS?=
 =?utf-8?B?TTB2a2RKeldrdTRzeXg4V0hyd0x3YXc0MzdlNkVnRDlSTGZkdnlnc0ExVDBS?=
 =?utf-8?B?UXBzTmRaVTFVQkEwazdnR1NOdXBpaXlLUCt5VC9kU2w1MTAvSzVxaXV5T1JD?=
 =?utf-8?B?OEtNSTRQQi9FZ0FSVkZHeHpvdEg4T1RFUlFqWjBzME1hMWhxSDBRSFVtMlZa?=
 =?utf-8?B?cWtVdm1RaTJvSUp1UWtDMW8zeU5jTGJDVVJQQzI5UHp1blFZcnhoV24yVURL?=
 =?utf-8?B?VkE1Q3NsVUlMTEU3VVF5dVFYWEx4elM0SjZObU1FNXVOaEh1RDFlOVVwd05j?=
 =?utf-8?B?Nno2dGRVUEV4S3c4MERDUlhVZGpnNVdtQmhzNEN1NmVhZ2Z4bEtsNVExczhM?=
 =?utf-8?B?TWlMS2F3K2dSbTZpd3FtdUJpMWJXQXhGWnhLNEpkRDVLeGZ0VVkxQllYS05F?=
 =?utf-8?B?S0xMV2ZYVjRWOER2QWNGYkZHSWpmSUxsaHdFcmRoQzRQR1RjblR3NnNmQXo1?=
 =?utf-8?B?ZWtsZ3JYVmhJbFlKSEpLNEdwT3NPdjh6VVpSdU9LLzZnRHd0U2ovQnVVSnNU?=
 =?utf-8?B?ZzRzRmJoa1E4MkNHWEJWWHRsMFZFVGE0d3MzeXBQZWJ2T1pvMnp6VFhvUUtm?=
 =?utf-8?B?NU1sanBQOWIvWFNnalNqSUgzTXpURG56Z3Y4RXdOeXVDUGhDcjJVKzdCSk5u?=
 =?utf-8?B?SDdDRVcvNkdvdGpzUWs3L21HaUNVa2oxUm5LRnhRZ0ZRNnhNV3hhSWVFMkhL?=
 =?utf-8?B?MFZqNjhUSTB3MFdBTUpFd1I4UFJ1aUo3UmJzZ2pHQXJTOFB2WHlMZ2FsZnZq?=
 =?utf-8?B?ckl6MTkrVkt2cVBCTjNMdXlIMGloanBSMFhKNlhlcFIwTnFaakEwTnZtSEV1?=
 =?utf-8?B?Y3ZqTTBNRTlWWGFud1JPS01hRkdPMVloM3ptNm5zZkRtTys4QUZVWnlKT3NN?=
 =?utf-8?Q?WYgOIlIVgZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3RvbERaS2cxZFpLTVVNTVhPUWhja1NWL3g1Zzc5djB2VThFdGc2bzlWUy9P?=
 =?utf-8?B?ZExGdUJhZW5jYmlJM0MzWkRHVnQ3ZVNJandUNFBOTDZOTHF2bzVlR256NXNw?=
 =?utf-8?B?MzFuOEdGa1ozWm8yWXExZnBrWDExcE1TU3NLQzZzOXFzelg2Z1M1TGRsNFZz?=
 =?utf-8?B?bTBnTWRrRS9iSEIvZURHUG4yNk1Kbm54d01tWkRGcGpwN0Q5ODNzNFZ4K0I5?=
 =?utf-8?B?aXM1eVVVdFhwakNoeDI2UDU4MGMxdHFQN3JnZTFHbGoxdnQvZEluTW1XeUpu?=
 =?utf-8?B?NmVKZVA1Y3duSXQxaHpBMHloYzJkbFptdkRvbXVzREJnb1ZJbmxOSHZGYjRs?=
 =?utf-8?B?Zi96Um9kV3VnU3pLSHZ0N0I1V3F5V05HL3ZrVlVWd2I0STRJaEVGRG90K0NY?=
 =?utf-8?B?Q3U4NGdLeHBEUWt2bjVXTmR3V0x0TnNqOVFsb3ZIMERFQnFOdjZyaENTWUpN?=
 =?utf-8?B?QlUxTEtheXljdUN6bDZmNnQvK0k4cFYrVE5iZ1dQY2V6TnpYQURxRE0yQkMv?=
 =?utf-8?B?M210RnQ2c0JCYUlYVUNQd25tVWhVSjJhOWpjQ3pCRW5PSDdzSHF2aVlSM2Fv?=
 =?utf-8?B?SlkyR0wvRWFtSlNvdXB2enh4RFRRakRlQnVxWkVTazBEWkFNMGpOdnhHK0dK?=
 =?utf-8?B?Vm50YjlEWkNmeTNQY2pFanpPbWI5dUhEODY3OW5ycFQrbWY2SzhpdmE2TEhz?=
 =?utf-8?B?YTdBQkZ2Y0Nub2FZcDhCZnF6d0Z1eHd0OG45dEFOK2FWdkxCRWVvTmh2QUhM?=
 =?utf-8?B?ai9wckRnYnhQek9wYVhiQk5RaW5YbnNDVjlUU1VmYWNxNjd1Q3dKNzdNTDZI?=
 =?utf-8?B?bkFvZFQrcUhBZkhGcnhiZlQxcmVSN3k0ODA5VXJleWtMdUU4L2lISWl2U3BY?=
 =?utf-8?B?Wm1RNnIzZTFYM2xDY1FSQnhzaWl4VUpVTVF4RVRwcVFDdmlKdW1YT0xoV2N1?=
 =?utf-8?B?NHpPc1BQWFJRenZCMWVQM3QvSVdLSzVNbjBoT0lYQUpaYzRJUG5xM3NwYTVO?=
 =?utf-8?B?Q3Z2TzlXUWlLdnBFbUQrTktxRGhSR2VzSGtqL3lSUWtjd25US2xyMEN5K3d3?=
 =?utf-8?B?YnN5cjJuazNCZU5sMHBIeVFpQnBlYk1Vdmk4aWd3TTJGaDNHbCt6cElXWVhm?=
 =?utf-8?B?VmNFZjR2UWR4V0RuS1A2dE5RS0ZnbmdRR25aV25Hd2gxMGFiM0xNZXJldG9n?=
 =?utf-8?B?bUFsbkVUQ0E5SXR3K25UN1JVRFBUTkp2SkdXSmM4cTN4cm5tRHRoR1lMbFZx?=
 =?utf-8?B?ci84dFpMUDhFaE9NbytzRE9SbktHcW93SDJ5NUV0cWN4Y3NhRjlrblR5eTUv?=
 =?utf-8?B?WEtOcmlwMkRHRlBIZ1VCdzhCOFFvRFZ5NHNWdnFCQTNOMGNqczBJdTRyWXQ3?=
 =?utf-8?B?QVRxK3psVTgxckR5a1RqVFE1T1QrRGRZWWZUQW5lV2lXU21pVkdIYjhiWU92?=
 =?utf-8?B?ZHNaTHZ3T0l3UUhNanBjbXc5cWRIeWR3V05uSWRrNXdLelRJS2NhWDNBK1Zu?=
 =?utf-8?B?K2ZPdnhqY1BaOENCa1h1b0JmV1FSc3R3Mjl5dnZHK215c0l1b2loU0wrTzEr?=
 =?utf-8?B?cnpFVy9MaFV3dGY0K3RJbVQvWUx0WVhUNFlFcDA3L3VXQmNnQ3F3anZGenRQ?=
 =?utf-8?B?NUIydTVsRGNtaFhIL1BETWE0U0MwZFRIdTY4M2lDQkhZUXVFaXFZdDJTTUtS?=
 =?utf-8?B?Y3NBR1lzVWpiOHZwVGVvMHVneElCMVJlMUxRZ2wwRWlFYUZlblVLejdIays1?=
 =?utf-8?B?RWpmQlR1a1lpMUxYdGc0bXQ1TXgzZ0ZtcUtDM1hHcGQzaDROYkgrL0txcjJt?=
 =?utf-8?B?RURFUkxIMVVZMHVKSHRVSXY2bGNYbkFVRzMyQTdWWnhKOGMwMVEvTFEwV20r?=
 =?utf-8?B?TUZsSGhjTFcrbk5GU09OWUhtdHgzRWJTd2NVWVMxcjJGL3QyQ1hyL1dWYjZy?=
 =?utf-8?B?NlVvMVBqcFV4TGQ1c1VWa1RNZDVRMWY5NGs5aUVMd29rRStqUksyQmM1d3Fz?=
 =?utf-8?B?djVacVhxN2h4MGdrcmxlOEJKWTJjbXZNNUdXYzdjdUl0UDdXUXJUNFlNb2hm?=
 =?utf-8?B?WjNwamJtMkpZdi95ZnhvZFR5RVR5RTV6dFdReW0xbnpJcmZxNktWL1FUSTEv?=
 =?utf-8?Q?MUx8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577c8d29-7cc3-4e08-a0f9-08ddd0981252
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 01:09:31.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3qRf2mFKLK8Q94gsu2TzUtJ4orfc9T/OPoOsYPjlpoEem80IyUHk/P1Vxcj4pYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8568
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7FF861C000E
X-Stat-Signature: 13nxkjcj5bcdbt44fkz68xamgkw9kxd3
X-Rspam-User: 
X-HE-Tag: 1754010583-496077
X-HE-Meta: U2FsdGVkX19PCyEFXIrycBZasWLmhMDPsPtkYYiPNQvyHMJTp3yUWVek9oQKN/6DbgbG0oLc++5YYwEhpaKp3ZIPcb7c5X/LwyR++XN+XrVsCPrnzqxJILPBtrfXwAWFu9xZa4wXmaSeHlLLS4uMXtiX/CZqlXitdLoKIZgANYJsONJFHpxaMBIOXuuQ1ELuxSCHkBywGVIGP4y2fODBYqLnRdItPrFnYZTUojZwiTzw3GQp8sPAHU7knLGIMvQWg1HiF8NGjU3B0YUGP2cR0IkVaTx+ygiwSbYOMFfi2yyuo06vHFQfH6z2MBXRAhAmlVvdsArHdaUGhiT4xJi3MILSjwj6MceEt3pCSDROaMdYpvoJTp5JjT1mNgVlzCx4ll2d2ATqD6cGulqe5Xurcb7OXbueqnqlBB7dNUQxwxtVIc5cbWZFAKARp8pr9deeWpf2tHljJwHdsuxgXSy3AkPNNTMf8spNeob53BExtuM4fcb7tiSBttTPq09sbncRW1y8Wax1hWXm4p7TEvJ85zCleGtBrwHktSli3KJ4iPEwvPCpWX9T4vvm/FHqng2EdiWb2JBcI379oTLtyuEX6DT7Ox3agoYxqVTXXxq6Nu0CqHxkFBWnllB98mta0UDamKK0whZX0E21YleIs0Ja0EIUkfh7peDstzmEGx8lWNO0UyJs3NKmlAeXFs5ZEqHYbgeJsZZ47wUIW/iSYDGlDysTbIzpBKJO0VSz2IEZy31t3T1SDF4BKiXiFg8kcuFhF69+GUQue+RVR0DjAw5kqrIDBrOL5WVo8pSdDhWIAF9XY3/AUCM6GFu4H1rSaAceqDSsgOZ9sVFakANyMY+anikl5UN7VJMb2Mpr9VFsR8I8ihjxJXy8lG8eFeEKeyfzWd2BryNgaQAOhRfvLTCybhyXzxEmuQD4uOSq9J+gMskILvH25+lnTJJGm4DTXz7BDTZTBHln+eWxpYEsmcc
 6QWyZclR
 KV0yfEn2NGGzd1aHnQkn86PuW1MulZSkEcMb09fIArXWusVf7T+r4KHMT9e1v0hZ3iIayfARgF9iYOat0D+xm5G6GFT4P8QZYHlElbuotvC1+w87MOu/GapoYQ8g6UxBgNeaPm2k7N1XPiPt68g5piEjSUHgdg2+DDSjgPl+8APik8P6JgurDZulVhvLQIVyGJs4VRQSxU+kiqx/QTS9wVxjtBO2jOA7/Ddj+X/SLY8K4JNoHgCVIU0UOAHuMBCSwbdbwWWQ7JSSfks6dcyPP2+DPknbuCVV/3v/JLR23IRVu228Y562ocAqxonrP6kdEuq2r/jqs3rgIjMZqXdYNleUJLBjqsOnOsmAKhy/O9kN+vl34ZidoIG1SH0Dgblg7OQMo6cz0Ox/kdlq6me/fe0PnC3OVT4Qv38+APBJQIY82bCKx6smd+OJL1EnWYpLjrX3p+hzLZYYpJ+wbGcI9wSrjJW8uP/ulJUUg8c0v4sjYtz+bhWhs3yK6fJDaoS2qwt+UUoA3MAuzExYyBDx/ivFNi+7A7sVX1G2KUStzEk+pvM9nifGjkLdhfll4q4aHLdiLSxhnco7XA0M65Hnicmvqr6FT3+6tsbqAwFbaaILXE3PHME6GTuJBeB3Kt0VoahGQZjPRmcgqEVsl3wUMCSdL2SrHj4DyiEwyypaWosG7NicrVD2rBGCR/S0wPrbkDMCfZkt62eiht2jN1WvOch5AQRWgEkGp9CPYYkR3Pm07knGa3dsIyeNxRtiRcWeYSYdvBxBlz8nWkTZ9bayMjM9tO6qCwPL3VuKewFiX/vrIkV5Rne6MMeqG/IvzPhmYNwBwmT5lVpp5EgxIk/Qa53TYtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Jul 2025, at 20:49, Balbir Singh wrote:

> On 7/31/25 21:26, Zi Yan wrote:
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
>>>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++=
++++++-------
>>>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
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
>>>>>     perspective? Can it be stored in a device private specific data s=
tructure?
>>>>
>>>> Mostly like for normal folios, for instance rmap when doing migrate. I=
 think it would make
>>>> common code more messy if not done that way but sure possible.
>>>> And not consuming pfns (address space) at all would have benefits.
>>>>
>>>>> 2. When a device private folio is mapped on device, can someone other=
 than
>>>>>     the device driver manipulate it assuming core-mm just skips devic=
e private
>>>>>     folios (barring the CPU access fault handling)?
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
>>
>
> That is true in general, the special cases I mentioned are:
>
> 1. split during migration (where we the sizes on source/destination do no=
t
>    match) and so we need to split in the middle of migration. The entries
>    there are already unmapped and hence the special handling

In this case, all device private entries pointing to this device private
folio should be turned into migration entries and folio_mapcount() should
be 0. The split_device_private_folio() is handling this situation, although
the function name is not very descriptive. You might want to add a comment
to this function about its use and add a check to make sure folio_mapcount(=
)
is 0.

> 2. Partial unmap case, where we need to split in the context of the unmap
>    due to the isses mentioned in the patch. I expanded the folio split co=
de
>    for device private can be expanded into its own helper, which does not
>    need to do the xas/mapped/lru folio handling. During partial unmap the
>    original folio does get replaced by new anon rmap ptes (split_huge_pmd=
_locked)
>
> For (2), I spent some time examining the implications of not unmapping th=
e
> folios prior to split and in the partial unmap path, once we split the PM=
D
> the folios diverge. I did not run into any particular race either with th=
e
> tests.

For partial unmap case, you should be able to handle it in the same way
as normal PTE-mapped large folio. Since like David said, each device privat=
e
entry can be seen as a PROTNONE entry. At PMD split, PMD page table page
should be filled with device private PTEs. Each of them points to the
corresponding subpage. When device unmaps some of the PTEs, rmap code
should take care of the folio_mapcount().


Best Regards,
Yan, Zi

