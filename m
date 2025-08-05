Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF2CC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 04:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAC06B0098; Tue,  5 Aug 2025 00:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1F66B009E; Tue,  5 Aug 2025 00:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589BC6B0099; Tue,  5 Aug 2025 00:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 42DC66B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 00:10:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7FFD1DDD0E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:10:55 +0000 (UTC)
X-FDA: 83741378070.04.CC28538
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD24D8000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:10:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BOMRuCXQ;
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.45 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754367053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1IJJ1No5lI7XgEMagid3gd20C4VIW9zlf0RTUIK8aI=;
	b=tIGSvAIt9UKTptkSzh6BbjkK7WsHqyFFL6XWSh6y2ZfkbXssvlVRTNnHuh3Wh4PhpFXaD3
	T296YXoY8sPUZWPXK/z7m8d/Uj6J9rvjELi13oiNsFmmyBnHT6dveAHvuhF4LhuEVvnz2K
	uLD5zIvIaofULcw6mUb8B6nLrQyRNik=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754367053; a=rsa-sha256;
	cv=pass;
	b=xkaJ1T82F9iT7g1zVga/v9zGS9+1VuPFOrfOLtRDAd/r5500Q+fsQU13V/6e+c95nDO3sy
	EOHFDtwoZAcZTPYDwnSIFNkSWpMJephlrSxwxuGB5Kq51UeoZgHyjZ3wqNOLSc1aIyzpgy
	pkKHMj2A5vIqqrELkdLumDEkN6xCdL8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BOMRuCXQ;
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.45 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZX368t6Vugk43H4DN/3m9loVlJ3Wqve/O8SraMcw6xLY1xkliHYNRjFtdl6KCHso+iKsql9uzLRacqQyND+9+kj8N6EEcoRKEzb4c5RfogbVSsi4D8kMurVWZkC9ou3Q1kq1yz2U6v6BRUy7iPnfK/KH6p9qxRPMxaO7sJlE1aAk6E6zbKxaQN36/SAUuQ4M2SHtYmof2DhTMZ71IraruVnBBIFQGqd9upgFAR4CgfyWbxrLVYe+az8e0s1GhAcRyvxb+K54990bpJx23RQPOil6gGy1nkppZ6+vDhQVViQnV/Kzie4A79Y/bioMWyPpRdHZIeV6JU5Ot47XhDVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1IJJ1No5lI7XgEMagid3gd20C4VIW9zlf0RTUIK8aI=;
 b=GpCfvC+4/j7bqukjmipZYqO30Sq0sRI/1xVpb+tsd50DmXVOpMXqOq7Vn4wF6d5aAfW90mp3YccqCAMtSvTS0YidKDPXe3wNfOIQgARx4Fepmz4lg8c3czjVz+dUmpardHnyVz7LJZZsHWu2iArfbDE4fE6+rQQdvP958tZz8w5qi71N/b6oWCSiVdC2XOXhpDyog2KoKtuQWGzyYpV3D38lbh7iXoNAPxmHjZ6UXiAlQmtiHcxcC88fWIWR+J7fwlYqMw7IwWRklQOUccix94Kzea7TVW4TbDRBbidODBDYR21vAcSW5ELznmjNAhDkGzCrKYIfMUKNGnDSr9sZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1IJJ1No5lI7XgEMagid3gd20C4VIW9zlf0RTUIK8aI=;
 b=BOMRuCXQa4rbxsudkHN5LNrht8oIXbm7aiEHedod6LNTB74omBJ+xfqF1Ir+kNOi2/F6RLQpt7vZXGQVbcRhNwK7WumMsdvatXm8UCKE6+l3hujpVDZlXFF3tJbMGrDLZdNrGww2fvwGz2giFSLc30DogQC7V2p3QOOf5W78XgdH0sl3ALLXB+og9DeAW07A0CawWph06k1HsnorD5sM/h/pblELJZsv2o2re5SBVjH3nIPDU2kRG/EoifNad2Fj1cxnDxz3GJaXv7hA00bbRyV3505iUwAii2DbAmyCa5P5PbIV/dbNLNSYEU+2ePFQRzooT+0EUCnjF0DnaTEaWg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CYYPR12MB8991.namprd12.prod.outlook.com (2603:10b6:930:b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.19; Tue, 5 Aug
 2025 04:10:49 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 04:10:49 +0000
Message-ID: <ede98867-bc17-4894-a375-d17d8f83dd55@nvidia.com>
Date: Tue, 5 Aug 2025 14:10:42 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
 <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
 <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
 <196f11f8-1661-40d2-b6b7-64958efd8b3b@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <196f11f8-1661-40d2-b6b7-64958efd8b3b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CYYPR12MB8991:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e55f23-ab9b-4cde-423f-08ddd3d60f29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1prdHpYNWRCbXFYaGl0eWRCMFRvOWsvS1NmWDNXbVIxS05HUlpaY1pESTdk?=
 =?utf-8?B?MWZlZGNQeXhHU3ZBQ2RCSEFnaVFwaTA2dmRSUU5uTjYwc3Rpb3VIZXEwSCtD?=
 =?utf-8?B?NmtUYmJtKytTcHZQVWYvY05FOW5VTnJvZXRSdjdtbCtJRW1PcVVjSWM3UEtt?=
 =?utf-8?B?akh6QTJDYVI1Q1VOMlpGdE83djBQMXRremVCejFNSjNldWhSTk5MNTl2Mkg3?=
 =?utf-8?B?OFBCSmh2Y3JMaTFQb0IwRVNza1hrQjh6enNwa2Zzd1JGOG9qZFBlVktrdkZT?=
 =?utf-8?B?VGtUTklCYzFkSnc4T0pLYmpiZ05RSXNwWFQwbXl5Q3VDYmJBbXlVMHlkd05V?=
 =?utf-8?B?NWxCNE5uVHdoMk44RFpiTS8vVmNBV0d6S0VZeFNKYVlyY2N6N0JZODcxSUJQ?=
 =?utf-8?B?VHFONFdRR1dhWWRJaXd6SFBYc3RPOWlqaEt0dW5wSFdkYVZqemNrZEtSWVhN?=
 =?utf-8?B?cHh5UXNIdm5EL2loZlk0M1ZLZWhRL2hTU2I3MkIrOCtKNEFySFBjazNYWVhB?=
 =?utf-8?B?OHc5amVla001ZXFkbSs3U0V3N08vMWhocHUwU1YvRHFrZDUyWFR0Mjc0N1hW?=
 =?utf-8?B?SkpaTlpEV2d4YnJVWHYzN1ZMSUhicHdkWEwxYjVEVy9HeU9qejA0ZmxsTEc4?=
 =?utf-8?B?OUxReW41TGJZaktobURYWmFJZUk4ODRQNWthbDZJNG0zSUNEYXpUWWR1QVpD?=
 =?utf-8?B?RGVwYVlLTUFnYjhUa2MvOFJtK0lyS3I2QjkraFp5QVViTUQ1RmVBNXl2L1RQ?=
 =?utf-8?B?S2k0Q24yOUxlTkFaSGQ4YlloUVV3K283UXRrTHlWeDhHcDV2VzNoYVlZVC9I?=
 =?utf-8?B?RTgxRnVhclFsdlVubVJFckxuYjZkZUxRR2ZEc1NZaWhVYVZPRHcxVmFVdzRP?=
 =?utf-8?B?aXI3MmxXb0lMUGtmUW9yZmFXaXBXVThtTUtwZCtmektBQnFOMkRyUUtDQnE4?=
 =?utf-8?B?dnFLMnZvaC9uSWR6NVN3QitLVDNvZTdmTmc2Q0xyTDRUTjljeTdXRG82WGNq?=
 =?utf-8?B?dnlBYlBaaStQTXg2OTZlcVpxWUFZUE1nSnV3OFE3eC8veDNvRTVVNW5maUFs?=
 =?utf-8?B?cUM0dVJCUFVsakQ5SDY0T1pUT1p1bWVZb004ZGMrdGc1Nk5zSHVOdERIMU9M?=
 =?utf-8?B?ODZlVjQ2dC82SnVOYjVtNTJSWjhUanRPMGVVWC9CRkFHNHlIVmVINDl1ZDBL?=
 =?utf-8?B?SytWSjE1NnpLcDVIUm42MUl5UFN2WDFTd2RuNFpHbUZtdGVDRVpHcFd0bm1X?=
 =?utf-8?B?bkw5MnBYM1ZjTW80MUp0ck16YVZhV3pmN1RSOFk4eUxOeGN4V2tScHBqMHp4?=
 =?utf-8?B?K3ZDWFJ2SndPT0x1anlqVUVyMG45QUdQSFUveE5SZ0dBVUtIMkIzWThBYkxM?=
 =?utf-8?B?Q0lPZk0zU2I0a0xGUXREcUlnTWZPVnJ1UHZsZDZPby9ScSs0S3RKMzZyYXVq?=
 =?utf-8?B?NUpPYXFEMG5yNFBCdU1qNFB4QU1vWmRmb1J0bXRqYXFyeDcxVjZCekJvU2c1?=
 =?utf-8?B?QjlrMkJFaExWeHlxdXMwY3RMMzE1eHlkSHc2OU9mOFhyaXNWSHk1S3kyMFI1?=
 =?utf-8?B?c3FwTytvdTh0cnpqRXdkdVZyZERlempLeGVlbVVmT1JtVTdaRytYbFk2Wmdq?=
 =?utf-8?B?VjEzblhQMTA3cXNXZDBqeWpqWTRJeWdDcFIxKyt0TWUyV2kxcENXcmFTVXlp?=
 =?utf-8?B?cmdwZFZGS3RsNitWT3FmSi9BNW1NNVdRT1hZRkRQc2d1TFE4UFZzcFM3SmlZ?=
 =?utf-8?B?b0crUzloc2lOVkRGcUNSZHJybnowUkMxVW0rVlBJajFWaG1OMlQwY1BPWHJt?=
 =?utf-8?B?dkdpcitDcFJqTEdYM2RFMUpKOHNyZ2Z6Z0c5WWZVVDhjdk1tQlBiK3g1T0RS?=
 =?utf-8?B?K3M4dzhWQVpxcklpYXlnVWx1eWRIN1Q2dzljMlNFWitsNW1GQ0MwS3FMQUtT?=
 =?utf-8?Q?NtYLVpH5mqE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3B2YkxrbWRUSUtESVdZNXlhcHBaTGdLYnlWR0VFaUZ1b1c4N01kaTJjWHBw?=
 =?utf-8?B?b3BMZE1HdkhFQ1BsOXJHVzNQek1Hbm5acFpMcWtoaTFVUklBWGJ5SkIzN1pi?=
 =?utf-8?B?ZThud2pSazRySEl0K1IwOFJRSWVQOWczbC9yRitrWXgyek9vaitISVhtaFBT?=
 =?utf-8?B?Qk50Z3NNVG0rK3E0UGRLN2tVYkVBWHk2MEU2VHM5MDZsSzQ0VzJOZndUNXZ3?=
 =?utf-8?B?VStOWTduOEN2NGRIaC9rc0QxaGNMeHN1Qm5qM1Z6NmtyNUdSeG56Qms5NEVm?=
 =?utf-8?B?a0tMVmNVeVFadDh6R0wyNVREOHNGcHNzNGVWbjdVY21FK2dLRVBvUXMyMGRD?=
 =?utf-8?B?eUNKT0RMY3owRjVVTXd4YWRBTjFBbEFvRXEzN1lKZklSdmFZWERzOEN4N2hZ?=
 =?utf-8?B?eVRpVW5jL1piT01ic3hQSHE1dW05TTJweGVyK0cyeHpLTGs5bXlvYm9wZzMz?=
 =?utf-8?B?K293ZjMxNnJJOW5JME1IUC9QVUdIa3dIUThuYnl0azFoZGxxS0xDT0JtZ3FE?=
 =?utf-8?B?VzhyYUxoSFRrKzZ4aFpzOVVPcTVtNHlSKzIzL0FTR3ZsM2EvSVdVM3lrSmRR?=
 =?utf-8?B?Mm4rTWdLOVhDNDcwYTRWTFJjdlRDc1Z2WE11MGlmcHp5RkpOZXJKMDd1MTcw?=
 =?utf-8?B?bUlFQzQzcmJnZGltSFBoQThpL1p6WFkrU0ozSlc1RzRpSklNR0ZMeW9zVFVi?=
 =?utf-8?B?d25mcjh5SUh1RjIzM1ZJM29Nb29GSTZLRWNRTlQ3enJiaEtKQlY4aEhYMjAv?=
 =?utf-8?B?OG02Y3lIVHZURWh3TTFSb0pxYlhKRURmMDZmTVlTY1N3Z2YxcVN6MWk0MlNp?=
 =?utf-8?B?akx3Mm1HM1hZblo4MGtZSGdQd1NnSWpwSFNrZVBUSHB1Tk1JSWhtMU1jOFNv?=
 =?utf-8?B?U2xFQXU3Sm1qUEp4eXkyQWxEUVVtNG16K2RCd29qOTFINmNReWRxZzBOcURt?=
 =?utf-8?B?cWdBK2FDTjRPRVovS1VlbUpPVFgzNjRWd0hldHNNWm1Ma1I0MWhpc0hIRFgr?=
 =?utf-8?B?RW1VT2huQVh3R0M4NjJOS3BSYk5DVkdNNjFzeVQwOHNFeDc0Y1E5YmNPZUZq?=
 =?utf-8?B?UHJRbzQwM2ZKdXFBcU50WUoyemVscnBxSFkwc0JwaStlampHdDRSeDdhNmpz?=
 =?utf-8?B?dEh6WmF1Z013UExXdk9NdS9hR2owRWx2WWIxU3BIMmVlbkhFTmhYVlBNSFI4?=
 =?utf-8?B?Mkx5ZjhYVnNzTUdwSzJjcHV2NHRuR09GbExyZk96VWlYQXQvclE1Q05wMVcr?=
 =?utf-8?B?R1VqNnVUQ0EzaGkycVVxbkdJSENHVFZUd0dYeDV1d2Q5ejZET2prZGdIcjkz?=
 =?utf-8?B?ZmlWd2pDRjJ6Ry9BWHJQTXhjRXJhUDUrZUxNVDloTW1mWStjZ0JzOTRQZ0xs?=
 =?utf-8?B?blRNYUNPOXlYRFZSeWtaQllXSEJXd1JXU3hMY3IrZGhNNDhhbHNGK2docm1x?=
 =?utf-8?B?RWQzaEhxbk5NRzU3QWgvdThXaEhMRm9nQ3BnRzNDb0c5UnV1T0RvcEJzRzdN?=
 =?utf-8?B?M2Q1eW8wNUxEUDFETzh3Z2VNK2pDL01mL1ZCbVNhQ1FkV1JWRUJJSVUwTlpr?=
 =?utf-8?B?QWthTG5zMEo2VWZQZU4yNzZSOG0vNnZGNlFHZ3VwWEdWQzRwU3pOeWxpQlhh?=
 =?utf-8?B?MUNJVzNYVkJQa3dNc0xvdmRBTmZSWGN4cHhHNXc5VFdXR2N3U3FNZXpYTlJB?=
 =?utf-8?B?ZytFb0ZobTdzNHI4b09LZUVZR0ZyZEVZNldPa1NQdGZ0ZnVWTFdaUTFKVTVH?=
 =?utf-8?B?UVZ0WXFmZDd0TEtjOVRZcUNkSjRFcTZMZnRTaWZ0cWpaaXpXUktQRERQU3pu?=
 =?utf-8?B?N09PcjJzUmE2Mi9rV0RVblhIM0RrZlFDQ3kzYkVLcXg3dndibmZISGpnK0lS?=
 =?utf-8?B?emRPbkVDTi8wYTQxcHh4K29zVUUzTG0ySDRJNE1EZ1B6dWUzYjFqYThtOFRQ?=
 =?utf-8?B?M1QxenlGQStZaXNmR3V2a2tyeVo3MGY5R0RTa2hodHZGdG9nc3FlR0htdXcr?=
 =?utf-8?B?UXo1OW5neUtLdVBFeEpDbVdkZXJQSnFtcWZKZFdGMWt4Z25zYzFuZllsb3Ur?=
 =?utf-8?B?b1UzVVExV1RmUmZsYytTV2xLcENNQjlqazNicWUrOE9rRG93aGlpRWQ1Tm9W?=
 =?utf-8?Q?KycQhOHPZAT2uQEzQeE9CrFJ0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e55f23-ab9b-4cde-423f-08ddd3d60f29
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 04:10:49.0163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/dnVTY3cwtzZA8G6J2JbTajdUZ5kk6IEEzXPLyu1p0aMQeuHaYXezQ/7wdhaYRt0G1gtReOVY8Nw0OOC3Iz0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8991
X-Rspamd-Queue-Id: BD24D8000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1c81w1tfmntdmkinzfa8oeex9hyrqjyo
X-HE-Tag: 1754367052-193148
X-HE-Meta: U2FsdGVkX1/H9Gf87M/JpeUw7gb/NyZSgOdOFYnTwRvSD4LtPn/HmUDvICdMIUEMuufmsDqLA6dkMZKv3PvlM5RxvpeyHB+x6defpedezq+Iw3zbZYYyTGmJWPoV7qEVDa+BSgJT7bmM5/kTylROFIiz56CepTv8tzvQMpcqit+OxFjYSXyBNKeckTI+pxuJsGkglnNSx96xzIGKTRhlxiti0JXjVzueQbFcwznmkKS3tKAFSGNVTZh8Fp48jfQzwlQfNRZ7h3V5YWmS9oRxXQhbdxPbBz+DN+PiXtHAe58cDYfBBLzNU+VgNzTT/joW7JlokZdcqsFti9/YM8vUHPpKN/PqWceU63GFtP9Sq8d40UeF0vUBHufNea5DQsWIXjrC4E0VhkFCY65ELptDq8nQ/So821H4cHdtbl1jEMmd4WrUP+vhbLprBA6hGiLFXXyUW4Sm1ngrugr4/7G0HLO+LfKSu0DLY2fEHpa8AD3MsOEvIPVdJnYCttw+9QhjzTC0MX3eziH071poAQcPC9XfdAtLVTFdQAeU4bORgXK8pq01mn4hOZ9W18wR86AUKakwZsIn6cLWpCdmK3WiiU9vBTtAyBG5sYhsBr9Cmw+wrfrY8ZBnCEqFjkmm39IL4CuyucbAsFtO5DCg/ioxNk/XY75Cf++cbbfRbzQOeoISZvPNm3TjBY4dCX25pXNSHSFJ/ebJa6S02dvjV9zw15SBT6RtzWDLGDK/CsXn9WZAC6fVGVZG7Q9uYaBs3zpZ0jLPlAhJHi0rScHxthwNMzvWNiLCJ8Xqc+zYEY79kJrSFgm+YTtPY1RKYjj4mrpoAnbQXib3+q28YrcoJM460KRGrdCfGRxXjW7lx5pVBFsBMA2fFAtTmg9Sp16G9npKTHBl2Nu/vFtAAtWlCFH7nS+TPef/+3bJjj9LLi3lWurKJz8K+deU7XGom11lascwfNtORjrtlO6ZC5tWOkv
 24iYcQCp
 NLvNwYeQY1w+CTObWsZ3Q1KwP79TSZIvHxPL70OMMySxXmYjE1j8oFt+q/aXep/Fnd0U2si9405sc/Kxi87DlKQDYFmqHirs9dbsaHngG/K/O2d4X16MG3paZ8t5sS32Fg3PcOE3Sd0GTxopxFBaIDJA+ePGGSB98UYXgR8qizlwxTajamsd3vkrMIcgwLP5E/41juFrBwYkQ1SphyvLx28ZobMqfu3O/hgNxYbK6qz5nAMTBRUTJo/yq2yr3UZTVXU0Ou2tQXoF5jAluZ9y+mn0pZ/en4k/mqldcHLI9xHPOsA5a88qKMLAiIFodbA2o3AwzTNDsCe1dr36BfTkDOwZokQiScRjaAlMLLOz6GipMaBV3ldw6NoS8kOVEyhNxMNi93PO6EZ0bVIMWdrdCSf+wmGpU7MIz0rzsqblJedcipR7Nh0S4+DdwEPml5gMRMTlnGhvARi9q369rtoNCLNapKt7OUxOkBPMY+Wfsm99MmGMriiIPkJsH/dQ4xDSPBXjC6ll07SoMPnE+RyN2HSogB9pJ/By6TuFFba4u5JSyZs+WoAY6jVYBaYJxDINK8hmNzMmHLUxMcgcHAWhNtQ17+yfzwTQXRG5OI1ctA0qQxCw+BRi8jUac716bjGJvE4P3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 09:26, Mika Penttilä wrote:
> Hi,
> 
> On 8/5/25 01:46, Balbir Singh wrote:
>> On 8/2/25 22:13, Mika Penttilä wrote:
>>> Hi,
>>>
>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>> FYI:
>>>>
>>>> I have the following patch on top of my series that seems to make it work
>>>> without requiring the helper to split device private folios
>>>>
>>> I think this looks much better!
>>>
>> Thanks!
>>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>  include/linux/huge_mm.h |  1 -
>>>>  lib/test_hmm.c          | 11 +++++-
>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>  		vm_flags_t vm_flags);
>>>>  
>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>> -int split_device_private_folio(struct folio *folio);
>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>  		unsigned int new_order, bool unmapped);
>>>>  int min_order_for_split(struct folio *folio);
>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>> index 341ae2af44ec..444477785882 100644
>>>> --- a/lib/test_hmm.c
>>>> +++ b/lib/test_hmm.c
>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>  	 */
>>>> -	rpage = vmf->page->zone_device_data;
>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>  	dmirror = rpage->zone_device_data;
>>>>  
>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>  	order = folio_order(page_folio(vmf->page));
>>>>  	nr = 1 << order;
>>>>  
>>>> +	/*
>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>> +	 */
>>>> +	if (vmf->pte) {
>>>> +		order = 0;
>>>> +		nr = 1;
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>  	 * large number of cpus that might not scale well.
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>  					  struct shrink_control *sc);
>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>  					 struct shrink_control *sc);
>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>> -		struct page *split_at, struct xa_state *xas,
>>>> -		struct address_space *mapping, bool uniform_split);
>>>> -
>>>>  static bool split_underused_thp = true;
>>>>  
>>>>  static atomic_t huge_zero_refcount;
>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>  }
>>>>  
>>>> -/**
>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>> - * split folios for pages that are partially mapped
>>>> - *
>>>> - * @folio: the folio to split
>>>> - *
>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>> - */
>>>> -int split_device_private_folio(struct folio *folio)
>>>> -{
>>>> -	struct folio *end_folio = folio_next(folio);
>>>> -	struct folio *new_folio;
>>>> -	int ret = 0;
>>>> -
>>>> -	/*
>>>> -	 * Split the folio now. In the case of device
>>>> -	 * private pages, this path is executed when
>>>> -	 * the pmd is split and since freeze is not true
>>>> -	 * it is likely the folio will be deferred_split.
>>>> -	 *
>>>> -	 * With device private pages, deferred splits of
>>>> -	 * folios should be handled here to prevent partial
>>>> -	 * unmaps from causing issues later on in migration
>>>> -	 * and fault handling flows.
>>>> -	 */
>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>> -	VM_WARN_ON(ret);
>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>> -					new_folio = folio_next(new_folio)) {
>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>> -								new_folio));
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * Mark the end of the folio split for device private THP
>>>> -	 * split
>>>> -	 */
>>>> -	zone_device_private_split_cb(folio, NULL);
>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>> -	return ret;
>>>> -}
>>>> -
>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  		unsigned long haddr, bool freeze)
>>>>  {
>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  				freeze = false;
>>>>  			if (!freeze) {
>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>> -				unsigned long addr = haddr;
>>>> -				struct folio *new_folio;
>>>> -				struct folio *end_folio = folio_next(folio);
>>>>  
>>>>  				if (anon_exclusive)
>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>  
>>>> -				folio_lock(folio);
>>>> -				folio_get(folio);
>>>> -
>>>> -				split_device_private_folio(folio);
>>>> -
>>>> -				for (new_folio = folio_next(folio);
>>>> -					new_folio != end_folio;
>>>> -					new_folio = folio_next(new_folio)) {
>>>> -					addr += PAGE_SIZE;
>>>> -					folio_unlock(new_folio);
>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>> -						&new_folio->page, 1,
>>>> -						vma, addr, rmap_flags);
>>>> -				}
>>>> -				folio_unlock(folio);
>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>> -						1, vma, haddr, rmap_flags);
>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>> +				if (anon_exclusive)
>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>> +						 vma, haddr, rmap_flags);
>>>>  			}
>>>>  		}
>>>>  
>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  	if (nr_shmem_dropped)
>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>  
>>>> -	if (!ret && is_anon)
>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>  
>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 49962ea19109..4264c0290d08 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  			 * page table entry. Other special swap entries are not
>>>>  			 * migratable, and we ignore regular swapped page.
>>>>  			 */
>>>> +			struct folio *folio;
>>>> +
>>>>  			entry = pte_to_swp_entry(pte);
>>>>  			if (!is_device_private_entry(entry))
>>>>  				goto next;
>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>  				goto next;
>>>>  
>>>> +			folio = page_folio(page);
>>>> +			if (folio_test_large(folio)) {
>>>> +				struct folio *new_folio;
>>>> +				struct folio *new_fault_folio;
>>>> +
>>>> +				/*
>>>> +				 * The reason for finding pmd present with a
>>>> +				 * device private pte and a large folio for the
>>>> +				 * pte is partial unmaps. Split the folio now
>>>> +				 * for the migration to be handled correctly
>>>> +				 */
>>>> +				pte_unmap_unlock(ptep, ptl);
>>>> +
>>>> +				folio_get(folio);
>>>> +				if (folio != fault_folio)
>>>> +					folio_lock(folio);
>>>> +				if (split_folio(folio)) {
>>>> +					if (folio != fault_folio)
>>>> +						folio_unlock(folio);
>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>> +					goto next;
>>>> +				}
>>>> +
>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>
>> test_hmm needs adjustment because of the way the backup folios are setup.
> 
> nouveau should check the folio order after the possible split happens.
> 

You mean the folio_split callback?

>>
>>>> +				/*
>>>> +				 * After the split, get back the extra reference
>>>> +				 * on the fault_page, this reference is checked during
>>>> +				 * folio_migrate_mapping()
>>>> +				 */
>>>> +				if (migrate->fault_page) {
>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>> +					folio_get(new_fault_folio);
>>>> +				}
>>>> +
>>>> +				new_folio = page_folio(page);
>>>> +				pfn = page_to_pfn(page);
>>>> +
>>>> +				/*
>>>> +				 * Ensure the lock is held on the correct
>>>> +				 * folio after the split
>>>> +				 */
>>>> +				if (folio != new_folio) {
>>>> +					folio_unlock(folio);
>>>> +					folio_lock(new_folio);
>>>> +				}
>>> Maybe careful not to unlock fault_page ?
>>>
>> split_page will unlock everything but the original folio, the code takes the lock
>> on the folio corresponding to the new folio
> 
> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
> 

Not sure I follow what you're trying to elaborate on here

Balbir


