Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76430CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA1D6B0024; Mon, 24 Nov 2025 12:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A716B0026; Mon, 24 Nov 2025 12:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61516B0027; Mon, 24 Nov 2025 12:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A073D6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:23:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48C9812E78C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:23:41 +0000 (UTC)
X-FDA: 84146172642.27.2BE9326
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	by imf07.hostedemail.com (Postfix) with ESMTP id 691C940003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:23:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NxZoGJwc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764005018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Lcmh8AzxyNlmScs02qXOmzFTG/Q11p+rMKK2Z0sgc0=;
	b=SsBbjySAPPa6vMJcmessWtYt+n1lVMHuSrXMlmX8OZGLpNYqTZfw0LKj6WxHeZJh8T1CYB
	DubQ3+ymewTEvv6lTOGLt7Qc7PIpXuFBgH+HEF5eIOLSk+pO8TTdA2vjDU80KkaeDoHUgF
	/wnxfatdPWnTi6NETgK1GTG2H/jntYU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NxZoGJwc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764005018; a=rsa-sha256;
	cv=pass;
	b=fQp4ABTLw/djYeugME99w0+3jL8FObH2EKFPf4ebARLPbN54M81iHRrKO6JrWyQ6LQ2/mY
	zQKjsAen58AVQa6hf2WOjn+refGH8MqZ/7TSS1HLtWSDwIZZqi5ml5BjLf1fBhWTnfK5m6
	3OskJ/cAzr3QLsb5DE7ldky5JKME14s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLAYxHdProjbRN9F0xW3XQon+3O1TTV5/WYX0rRMXkRCI09ZEM28PtZ2QxANaXgjIkQ8Ll1nOMEUSZhvqPLu2ohRE8ntDJa0myCUnbyHu7CjaZhnFRhEHBYZ2S+deeYeSeOSnSeXljwD7kJ+A8N5MLl+NJYoFKUUaej585kBxqImx91unbfNdZ5lxH0JHB8iho7a0cj93phJPuDZKulBH4oGRiIF2U2odwqOorGSc0ZtLvUrZ8A488E3Zg9nk4qE62F5HK52o16aE52eLdvfVhT5lVofw9MIA3l62iiz4n6Rk5IBLQ9XTCXViiotBlAjXsdaSMxBHF5JpoPlw8PVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Lcmh8AzxyNlmScs02qXOmzFTG/Q11p+rMKK2Z0sgc0=;
 b=qemwIh15yrqAt+sx0/qEOJv/a0kkp71Ic+qYcNPW2x8jGB1Woxx0EBhsT1SMa/FjBPy+0+T+CDaViZn5t00JZLVzZaKalyS01JGLZvBUarQELujb4udblcthn2ZiVeV5Oj9nWOsuDMaCHOQaY10S5lsTgh5o2qb/gff4iJ0qJy7B/Ct3kltdSOcx0kdcr0UU8864xriM9K0//deU8ComiUEwLXfkYZ1ibKf0E57kd7bI2RgdXDTzsgE3r/LnWG3qKp72wn1bhld5CCSgMS+8r7WRAzYaoHTqsH1nFEZWV1DpRqZ0rF0FU647nrba/CG5uUnw1WCakAeBsOzxUY5mHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lcmh8AzxyNlmScs02qXOmzFTG/Q11p+rMKK2Z0sgc0=;
 b=NxZoGJwcAnzMJN4hGjn1LMWO3P6MtZbtHBej3iunGEJvW+IZFz42XE4U4ktg5QPNtwaOSzrQdPlVMMrFoyQDSa8ojolSo5STWVeDms4BLTBPuIChngiwiBG5jH6DquMh7bt22L9rs4Z0hyQPd5Nw0lYLdrbsSItdMDuYVJq3bt8TW0E0zCt6XM1eT4CRNCQB+rHV1MgqTDQTvL0i9MdALEpPVeFszrJGnaIIpfjovvSRstIvwwpAEqmqd3Ex/cG0ZT3WWniUikLvtxS6c5dhMI5Tyw0+nmfoZDgPSr599X9NEWuzRN84LqYC11AhoOKhEjxKj+NhlTInCRch+mdnYQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6711.namprd12.prod.outlook.com (2603:10b6:a03:44d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:23:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:23:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
Date: Mon, 24 Nov 2025 12:23:31 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <539E2FBF-C5B4-4B2C-9AE0-A1F3A9203A1D@nvidia.com>
In-Reply-To: <a4bdd286-ebbf-49a2-9b98-fa5197e1a6f3@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-5-ziy@nvidia.com>
 <a4bdd286-ebbf-49a2-9b98-fa5197e1a6f3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0370.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 142debf3-d144-47d8-9ddd-08de2b7e3203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjNTK3dIT0k0ZHVjWDJJN1pvVzdzYlZ0Ri9nbzM2anJlVDhSNjdYMUY4WlVL?=
 =?utf-8?B?SVlLNktEZkFGWEUraHhMS29ZVG1kckx4TGRjM1R4YUc5SG8wSmpUUjhiSGlo?=
 =?utf-8?B?WW5YbUs4TnZ5cVFwMjV0SXRIdlBTcktaUi9uUWo0UHBEd3NCZmMwbWpyQmxG?=
 =?utf-8?B?MGZZT0JLWUVKbE5nZ2hZcWdzcFpTU05PeTcva3J2d0hzK3NML2pmeXliNHRR?=
 =?utf-8?B?eVlwKzBqamhremVQNGtaY3dvQnRnOTJ1VENTVnVHTWZhWGt4RTBicnpON0I3?=
 =?utf-8?B?Z2R4WUdxeHdEM091M2V4b2ZQa1gxeGUraTdMTzExekM4NkVPTGlUWjgxTkZ0?=
 =?utf-8?B?SkFLejZpdlo3VndMUmp5SHpsRnVrbW9NSzN1N0pJdU5JazR5NjA1MGVPMW5I?=
 =?utf-8?B?UnBnUm5QVzVzS0hRdVpBL1dFZWJoUERyaDk5MnVENjAza0xVenB5VGoxMDJZ?=
 =?utf-8?B?Q0drV0RYSjVYNkhqdkRMZEhqdS9ZYitkekJjZGNkU3FVMFVLdERaZlRXWlFp?=
 =?utf-8?B?ZFZVMlRqYnJlRW1qaXMvdFJSTWpuaW4wUndYOWtvSld0RUh4d1hkeVZtM1JH?=
 =?utf-8?B?NWlMV1d6MThDblpMem9Gb2JmRFpoODU4Nm4vU0VlaEsvWGVMRFdGTlplQjFH?=
 =?utf-8?B?bmh6bHQyeTVtVUg4Y3BIMStCSzdiK2RSY0xYWmxZUFJyQTZRWVJzZWU5RlNE?=
 =?utf-8?B?UW5OTDJnWExVaUh3cHNua1V2dXNWMU1GdGdvRmVWNmNVSXYyY3U5SzNJazAw?=
 =?utf-8?B?bExVVjQ2QnoyM25WZFFlNUNUNGg5STUxR3pNQjcxUVQ2UUszOUpDNE5nTmtM?=
 =?utf-8?B?S2FZSTROajlhL3VrL2llNCtqdk1pUVI3YVVmUDgvYjdWT21TUjZlY1VJNS9q?=
 =?utf-8?B?SmZEQXZkTTFoVnNMWjA2TjlyZnVzY2ZITWNXcktoMVYzNXBvYVliaEhkVElw?=
 =?utf-8?B?TDd1bjMxcEMzTWpqdkhrYVVzc3NtdHRPMjVCVU5iRGFOeHJOWmQxcjRHdXRW?=
 =?utf-8?B?WVc2SXFnSkNzbkJRVXRNZzZyYTBIaWZIUGEwMVgzay9nQ0YzWFhLYm4vSm5Y?=
 =?utf-8?B?UXBhUW5ndDI0c2tzRHYvMU45L3NhSEcvaitJR3FtZFRDR3RDWm93S3crUkJW?=
 =?utf-8?B?amQ4bFpQU0tVNnRwUnAvS0luRjQ4Q2p5VVhyVTR6eHZyamF6MzJQdFZhTUJV?=
 =?utf-8?B?WE5SYStEeURLY2Y1MmRiTGI0UFhycHdQaVN3RmhGSjVlL1Vzb0xUSTg1b0Fo?=
 =?utf-8?B?UUc1RnMrZzd6UkUvOFlud09BdDQrK0dXSE5KNi9JcWl0RnlQcHJjSFFSNk5N?=
 =?utf-8?B?RFdxNWtXSytYc05MMGtOc1ZCaGFKWnJTRERWVjB4TUhMc2czZzB4TzZ4TUR0?=
 =?utf-8?B?M1daN1VhdHpRN05aTEtPZVg1S1VKbzlJczY1WG1hczNVKzdNeXE0QlREVkU1?=
 =?utf-8?B?NitvUnF3dTErTW0ySkRQYnVkNmtjUWVnN2FTWmM0TTVlcVR3SHJxUzBvV3Ru?=
 =?utf-8?B?cmxDWHA2ZXFiK2F2SE1ESTNGZ1VTQkU0NFRMVHcwUWRDTVZJQzdVQXI0ZFQv?=
 =?utf-8?B?K2lOQXlCbHMranVuL1B3SnkyQ1pwMmp6Q1NPdGg3S0tmTmczSWt6MmtoSlVl?=
 =?utf-8?B?QlAxT1NKYXhEbzRvUlN3NzBVamhHUlVkUTRhS3d2NzBrc3NTRHpEbkR5MnVl?=
 =?utf-8?B?Q1lTbDV6Nm9Ea3J3dUh6TlBYcDFHRlduYTNQQlpvMTdqbFY5YVlzd1ZubmRD?=
 =?utf-8?B?R3BNcEJqajZLZmZhSkVpZFIvVlEwdm9oMkdDb290S2ZySWUrbmZKRmJEV3d3?=
 =?utf-8?B?b1ZwWThBU0FmeW5EU0VEbTYyc1d5ajVGU1JGbUVwZHZNeFd5SGVId3VFUnR4?=
 =?utf-8?B?aDAvQUM1ZGxxclZUQUx4S0t4NzJRSEcwTlI0QmJEYUFZMlVvNjluRmh1TUgx?=
 =?utf-8?Q?dN2bNIAn+nspwKVS9HXJZ7ezJBbCWIdU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0RLd0xzNno5eG83MDlWU2FGbXVuRlRiZEpXakJYUmZKU0g0OG5vWk52dWFa?=
 =?utf-8?B?Wis2dDRoUzU4Y1lLVTRwMWc2YWxYeU9BWlZJZ1l5eXJWbmNCNi9yb0k3NlNN?=
 =?utf-8?B?Szk2ZkN4NW95NGp1ZEJMRk55dk1jT2VZUTdIZkJ6eEhQMXo4blFtQzBqR2VT?=
 =?utf-8?B?dFI0NlJOTEdrRFJ6TFgwWHRnWlJBb0ptMHR5QVJLMmZtUUptdm9GQlJQemFI?=
 =?utf-8?B?ZkxhSXR0c051MDJNUTNaaHRSZ0hsdTlIMHc5Uk9GTnZGbTk5TysxWW9tOVVK?=
 =?utf-8?B?aEd6Ung5dTl0SmJpY0NYblF0SzhPUDFjL2pKN0NManp2b21RYmNTVFBKRk9T?=
 =?utf-8?B?aGJJa1U5a0k5K0hielZkaklNWUhHYlZ0ZzUzdjVLNGRmSXZ5djI4NmZYOSty?=
 =?utf-8?B?VFFkdzBTVmdlK2VPa2dYZ3B6UmI1N0c1MzZCcnZCcG4rNWdVbVBrUXpOQ2Jv?=
 =?utf-8?B?ZWYvNUxKS0tIYm5kK0NSZTZHZnN5Y2dmVFU5S2tTTHFJRCt2cTZLV2w0Wlpy?=
 =?utf-8?B?aWJVcDhycHUzZXYxd1lLU0xSWm1OcmdsTDRUdkpmNmVIejdObmlpSXI5eXJ2?=
 =?utf-8?B?NkpwT2ZmUEVSZjR6QlVYZGkvYzdkdFdKSzFQRFNqV1Iza2NKVTh5YzArMGZY?=
 =?utf-8?B?R3hITHJaa1kyRUxkb3ZaTTU5VWozczd5THVYR3RrdmpSVDNJTzBWMTdMQ29v?=
 =?utf-8?B?U0lQa1BsWHdJdWtERWhoWVFoV0o3K2VvUDZ6MWN0KzdXbGQzQUF2MWorclQy?=
 =?utf-8?B?Um1iK3pnVC92WnpuMGtkR2poZjg1VitMN0hxajl4OTg4M3cvaUJlbHFCYVhO?=
 =?utf-8?B?dXNtNEZSblU2aEpIekIwbXhaTkZGbTlSM0svM01PYnBHNnpQUFhUQ3lQWUpz?=
 =?utf-8?B?bFM3TjFCalhtUThVYnZ1UXlpTlZDSXhIbWZLaXQ1OHB5dEZyRHJCWDVibzRG?=
 =?utf-8?B?dWQvZElTUHF4SHZaa3JIRXRiK3V5TERSWjN1cHpBV0FlR1pZeDlva2Q2eHhh?=
 =?utf-8?B?aXVmRmZEZ2MvdW40RUhuS2FMMlJMQWgzV3U1QnpOTWFETktBQ2xyOHh0YUpo?=
 =?utf-8?B?VVQvSlNmbXVBcWdJb0NxcWpiQVNBK3NxVVcweEM0Yzg4aHAzNFFzb2VObWRs?=
 =?utf-8?B?Y2FTTkZjNTB1a1VNcmVPQUVwZWtWaURGOGlVL3pTNVVSMGtid1JwN05EdDEr?=
 =?utf-8?B?c1dLdDlSWG5zakN2Ym5QUWcwNEh1RkF6WTRsM2N0OUZ5Y1dXcEx5cG1VZkx1?=
 =?utf-8?B?ZURsL29XQW1qcDE4diswVEJ3a2VGVFZ1eFBSS2VwUDFJSlQrYlRKbEQ0TkFz?=
 =?utf-8?B?MU9pMlppdGVMRXl0M0pPMys3VGJ0WGpTUld0b2JLazhBaVNPZ0dxbHo5K2xw?=
 =?utf-8?B?a1pFYWtDdHlId2NOYWhhS3pBS3praUhvejRzd09VMFVRVmhpZDN2cUxob244?=
 =?utf-8?B?azdpK2dLV1JwWlhyeHAzbFMxOEZjYUZINU5qR1VYL1JlMzVFdzFvczQyT2xX?=
 =?utf-8?B?MnRhb0FJeEU0cURzUDQwTGlPY01wKzZ6Y3hLMFJsWERKdklkVnZwY3VxcHZz?=
 =?utf-8?B?QjVzbnppTmQ3SVdUSEFyQlYvcXBxeXlFQThDVzlscVV1L0RUMWNwZExJMWln?=
 =?utf-8?B?VEM1THp4WlUyRHZhVlAvaitVMWtGVXhoMVhjZEsrSjJKbUZmWVNXRXRJTHJN?=
 =?utf-8?B?eUZVYXpVQlg1cTNwRkYxUWpidTBhMzJNK01JS1NUSVZ4cFhRdndMYVRtVFR0?=
 =?utf-8?B?akdFeEVPamJZb3dLMVZUOTJNb3hGUW1DUWdOem1PcmN3MFVEZkIyMGVxWTlj?=
 =?utf-8?B?V1doaTdDMWhIT2hPUElDeExrdXlmY1ErZTJPTlNYRzdWZkVzb3pSWkg3cVdi?=
 =?utf-8?B?SCtYSm9CYkNxem0wczFRM1FEWExqM1Q2ZVNsRmg1cmJCeEJTM2lQbnBaOTNr?=
 =?utf-8?B?UGlweE5xOWlkRmFpdzdkNXRlbjlTS3VldTZ5ZDRZV2tIaVhBLy9sNzZlZ2Nk?=
 =?utf-8?B?ZGowM1RPQlg4MG1peVN3dGNRUnBuazExM2l3RlBodDJWVjBBK0J6NzVJWkJN?=
 =?utf-8?B?c1hOZi9LdXV5bTUvdE0xclBXZE9ZN2g0VU9NNnh5cWh4N0ZpNVU3STNpYWox?=
 =?utf-8?Q?2Ew6y0xjL2wPdkI2S+iIbHrTG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142debf3-d144-47d8-9ddd-08de2b7e3203
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 17:23:33.9192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lc+g4sRPHAHg5ho80KemRXJXxDkTY9iqK1r5j6gV4ru72ZqI0m3mcUGm4q16bbvs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6711
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 691C940003
X-Stat-Signature: 59mhyxbf9nszf5fafjpieug7z78x54qu
X-Rspam-User: 
X-HE-Tag: 1764005018-652401
X-HE-Meta: U2FsdGVkX18zUk9V9Ru9K6zngTLc+c6Z8KZ7mY0AiuzQkjUuj9TwXCr7/rWUGu2u7FqzXtS1F09sKAp4sqBgvh29agTSn/UxBCRIKKc9arIxG20IIG9OBL++dC9E0JnkOUorJJSfsPOp2fOJR3HRoMvDoqYBXygg+7sa2m93xGaybrxi5DdmOwJ7hd0zubFGS+BKkiNwYUUO6UxJRFhgSVurJmyUD6I8ST55b/LD/tBtGj/WE8oDk06sP+un77P/xwAPy0f5lZDJvkNIJBxXRuTo0wGuyHEE+2EeUB55hLi7sZnyf6Tervd6pOCkQOzY4uCrBHTuA2eoZ3/UwVp/lLBxk+hJw+UvSEhoI4wK7Nlmx48JcG4wXcl+Edhk5Y1k9dIFU4kBgFj69orqh5FrVqr1yCs7DeBkv0cZiVpIehMpjSNhl1b7eCLsBhXdOK2+zp/5BKbBE1MMuiBfIxXyzwJCWwmAqORorUVep+nCMifBppA9fnDbJ5+6R/GacV+D6483vDZ5frYCI+dg6MRkNc9OL9tPhiYNjOMqcTzTBidq8RgVtarYZtuk9WK0mC3OWbVd+GBJIiFUAkI5j09lVsvZW2T9aGb9NAGnUFOZC8SF7COnvkWmfDqMCWhUPcaWqtpLLEiUBAfH9bqfiyZKpHAidEdq3BFAFQ/l+wfaHfdo41yQBSgkuBlWEyQUNznGxJCLDXgfuYAynOXHZPlLUg1uMX9Zu9mn1DofjPCbYlRLbj/Qjpr9jL8bHA3c6aYHDfpJd7nSKi2dWeUdN6HyywjqDgGTiqxbt2V2fXGzOLvykWZyjRwuQG1+phXxfnOrHDlUVReMn0+0EL3luxoFiyYUQARaRDoo4alrmzE0d1l2gihWLDEwycxr/eq1RljyffiUacWEmHY/Z6vVUEW63KDmvtvxMQsxp7Yfhp0qonnQibn6QSWWKXdg4ebfEFDM3dBw8fj8MzhhBjJcI0q
 GjwzQ73V
 5SHIYN3hWN/D1kQj8Xdc1PHf8aZ+fhqVUH+/5IhN2SEAq9XMulXwk9HXX53mE+2a9/oTqZUSkfBCS0/Noy/7x4roR84gV2q5gibDVWWd8q78uFT/rQM6UrYhaSEDsoRp3SW6Qj0fKRW+ksNehyP4kVk0E9DxU6m9qPEe6kn97H7vgOoIX2k7BUYedScPj6PZYoOGqjJBfBfjub8psE40AIKizaF8s5Kawl1T2qQdkfgaPIQNRDJCczxu5Mv+VLDfzROi6AvkMP1jLeYD+0jzdLBXYSVogN+Its2ZeiLoA6aRS5Httf5iMVUkvQsqyIQZIF1qOemIGRJ0e6w7JUUMotA2rOUVjNPT9brgEdreMRdJ7iUJ4OcEsEM2fwYYcHuE11es17yXkrQ1M5D259ARol0s7BnkfDXSMTTpbN3xah9W0vf2rVgM95rJasfcIDcH3/mnQ+zfFMzWo5KdCfdxXVhzx2UiXKVZ3/U2LrLvQdL5vL2KmUjzr5r2MisNpclhaG+lX9XuFRE/08hf+Gf0oD5xow8RSOfNo4w6H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 5:45, David Hildenbrand (Red Hat) wrote:

> On 11/22/25 03:55, Zi Yan wrote:
>> The "return <error code>" statements for error checks at the beginning o=
f
>> __folio_split() skip necessary count_vm_event() and count_mthp_stat() at
>> the end of the function. Fix these by replacing them with
>> "ret =3D <error code>; goto out;".
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/huge_memory.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ebc3ba0907fd..a42c4f29ce4f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>  -	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at)=
)
>> -		return -EINVAL;
>> +	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at))=
 {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>>  -	if (new_order >=3D old_order)
>> -		return -EINVAL;
>> +	if (new_order >=3D old_order) {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>>    	ret =3D folio_check_splittable(folio, new_order, split_type,
>>   				     /* warn =3D */ true);
>>   	if (ret)
>> -		return ret;
>> +		goto out;
>>    	if (is_anon) {
>>   		/*
>
> I guess this is not Fixes:/stable material. Wonder if such early (mostly =
-EINVAL etc) checks were at some point not intended to be counted.

I do not think it is worth Fixes/stable, since most checks should be caught
during development and not be triggered, except folio_test_writeback(folio)
one. And no one complained so far.

The inconsistency starts from commit 59807685a7e7 ("mm, THP, swap: support
splitting THP for THP swap out=E2=80=9D), where if (PageWriteback(page)) re=
turn -EBUSY;
was added. Then commit 478d134e9506 ("mm/huge_memory: do not overkill when
splitting huge_zero_page") followed and so on.

This patch is intended to make code consistent.

>
> In any case
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks.

Best Regards,
Yan, Zi

