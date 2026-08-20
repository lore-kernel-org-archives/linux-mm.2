Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688A5C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1866B009F; Thu, 20 Aug 2026 09:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3798E6B00A0; Thu, 20 Aug 2026 09:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2679C6B00A1; Thu, 20 Aug 2026 09:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E797A6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:59:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D6EB1C03A8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:59:40 +0000 (UTC)
X-FDA: 85121805720.17.EFF8DC3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010016.outbound.protection.outlook.com [52.101.201.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id A0018C000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:59:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UF2TBcGx;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787234377;
	b=qUVjAuZkQHVS+xTHtYW9tNBhfOldbAwi68NG04kV8APrpHLOm5Oc0/qXD4msMGG6H3zA8d
	k9tbmud9IYboXg+BuwfvH/LemIovlDlPzjnwk4jtf3j+QS4P2AeU4KJNQqFUbKVGWkmBWL
	Jm6ShZ0xryd9GXtjKkJglBL2VCATtno=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UF2TBcGx;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787234377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tweadVH5zkUnsez37sjZtlZpjyOPXjpwZTdkrXV789Q=;
	b=VVO+2QErUPSwPauM+z2n/IBW3mvEFxK6ZC4LOpQANyjUR0FFgoYtf98FzxjC2z+NPtN6Zf
	o6w6vSEStKRZ1FajcVeIa/eJW54nwYQY3ZF+O6rdFpr+Jiup7miqMfEdzYelF6C2B5fVGb
	PkmZrtA0KQf3fSj4VJB1V5dHUVFRgTk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YG7Y47Q4neq89UJLJS+K8CAQjnuxdabVdegQLVp2Y8CvEwN7yEUyLn8M/zpvshENd9cRL8uy4hFOOqN5ppPIo0BJT0LCNcidLh7BZCasc0pTlC+mXpFon8SxYSvrwp1tPX63+zGEJH7IpcWCuJDdropxKSNhYU11R248U4SDbptae4Ew8SDsUjWUj91UtTORzfs3B0rh02mwwpXKP/l0NSsiSBMJnqQ2rQBWkZfEmJrxTFZUnFtL6lLe5RG9Je1OXCoIjyQoPNyGeFWhOGulITN2cI2MarOPBA0QyC4qbaoxqthbeAvGv1NFmzX2eB142bweAu1uArJPuTXSfRMr7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tweadVH5zkUnsez37sjZtlZpjyOPXjpwZTdkrXV789Q=;
 b=s50kuOqdi1K9IZ43qM3Yqw2AWyBnZIQx+1RzZ/MXnePE8mKThIluzOeQNJUUIYkLArD3VMWgnK8IlDa8e/v9eXB8wwIhWCB8eTCXrpOCNRSmmgCjoF3gDF9I66WjVCyyMBU/6aheyEKuVTdKfL/m5M2jCsL16esVbGMaH8Jcx4tdgnzztlWA5+GXwhD3lcc/yuQTZzMGFgUuPHT9f0Xujee5sLJKl4zZ1PrKdrWQEgNvvM5cpYLUyBmsx2KlBsyanHgFIUL2rrwaoK26NMRimLt/B9V2MoOKeyZKOm42vZnPu4RY6zl6UZgleKf3lrtkEQx4b9XbWznjlh6d3RYNFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tweadVH5zkUnsez37sjZtlZpjyOPXjpwZTdkrXV789Q=;
 b=UF2TBcGxO+M1kMdC2fJV6VGEkSfLGZe2a1a/9tmF23kTGHryAqo0ZuhRIvS00dMtBQJ4aEcDLN1Cu5JkQihOD2S9b5To8viEHpiTOGPgNNVRcA/yoR72DbPgAeZ8vFGxDUEMUiJX1Z4Op5NqHccB+6K7ZdawkqpppF7K+FFv41mmYhMLyAez7KsU0SVvjhE2/o8woy7RSx490N5/ViRw3bEjRTIy2jWYNqqO1ua9Ut1o6RneOpFV8dX6oOsbYgpli3Uq5Yz1b9B9EP9+1HUcBzXIkqpO8aNdEfZcNO4G5g6zySlD7nN7VL7PWt8TEztLF7T8VIhGVsmywlfg4Vd9GA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8645.namprd12.prod.outlook.com (2603:10b6:208:48f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 13:59:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 13:59:29 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 09:59:27 -0400
Message-Id: <DKTTPHY9SMDO.3R1VBEGOKR95N@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Cc: <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>, "Alan Stern"
 <stern@rowland.harvard.edu>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com>
In-Reply-To: <DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com>
X-ClientProxiedBy: BN1PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:408:e1::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8645:EE_
X-MS-Office365-Filtering-Correlation-Id: 019f184a-b10b-4462-5145-08defec340ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|6133799003|11063799006|10067099003|4143699003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Qug9JI17satdL994xvdyTLuGPf3Vi4/k7CKfRbN0NBGDvZGe2W4c1ButMLC/S71zgdUlyl4lXlyc27tIj9CNaFPv1yR078ymMVjvgaw49nJbAZs40vfUfV32F1vd39h9K6Zb4NFG9c8gFA0/qBS4BiEqOGMWaXDqiq7l1DUD0Tktajqhr7IUKv+aI0N72T7qnshslIQvCKSH1L7OKL84Qv0Ud/W5UJYK6Y45gSxLpWyF1JT2kgrBSb4A+7cgLCifb0hBJMcdOfFmQ5RbMH7jWEQlQCttLP5ocoDxMV8dH2bpzEB7MBaMFeFkZMLABwlV6xNlv5fmDrqfEGi5bTRvep/TiMJ0Nmrez/J16bjJCiUfIRjwDPpjWMvQT1/RyIKBd3xKdMyfVmcFV00HCbs5iBJ9mnIL560KoO8vSvv+BSzXt4SYZlLH3XtQCyG/5JaaJcwJBrkAhyicX/Et+oOpftr3FOylGfJIZ7LROUH8+d11+p7PkWCMPMAULByAED2yt2FD9vZ796MSK39ByNPYSnGQHsNpB9cG9UBcmxClf7Cnh0RbmlxHvG45r0Psk4bEt8ZwG3DiiCPBksQyGTWUBoTIyKYgVR4eJwDifSoiEvdtYSbat5LTz/KCfyR6Op+IUdvbudIBiErU/i4DIXdvf+CzQe9N5P1avhttwL8GsrA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(6133799003)(11063799006)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a245U2pMK21WT0pJbDlwVmg4Z2pQWXB5LzRmMnVhOFhpMzdkRnA5ZDEvMWMz?=
 =?utf-8?B?eE1EejlpVi9yRUFvQzg3Uy8xaFV0dmNBeDlpQUwxcUNjRWtQeHgwWlZkaWRq?=
 =?utf-8?B?OWJDWDBiVTl3QTdmSVM5TWlKRUZyMmdkOWl2NFhRT0lWMEdQclJ1ZVUxNnVk?=
 =?utf-8?B?TGduVVFvZFdCOE11akpRNm9Ta2tTQklSVTdVUkVCZmlZckRyaEgwRzJDd29W?=
 =?utf-8?B?ZURXQXJ0K0k0WlFPK3VrRXU1VXcrbXRSa0lEdGt1RnFLdUlRM2xNZ1dURGk4?=
 =?utf-8?B?QWJ2aGJneXljcjhUaWtqV1luUzNpUGc4YUdRdGZOYnhCNEM2a3QrWG4wZ00r?=
 =?utf-8?B?YmlWMlhRbjNhR3ZHZ0NnSXRtTzdCc0crakh5UHJaNHZoOEs1eWx4eDNSQWRx?=
 =?utf-8?B?K2RjODYxb1JjQjE4K0l4UlVUd3E5SEMwU0J5MG5MS1lJOVByWXhXQldkejRk?=
 =?utf-8?B?U2NLQXpRUzFBQ1MwcGMxSEpHUDlwcHN4OFFlS2kvMlVxNXAzNEUrOTVrZnRS?=
 =?utf-8?B?M2oweWw2aHhqbHpGOWRFYjIzbmxRdWFaZ1kyOE16ZHZSRXZiekZEUFNWMlhU?=
 =?utf-8?B?UjFQcGFKYWxDVmgweVdtZzB4Sk9DclpuN0ZiKzk3cVozd21Yb3MwRDRLOEk0?=
 =?utf-8?B?UzNSVERsTDFWVCtIdUtuNkEwUkpTaEl3OUN2anNpUXNtQmF3TE12NVpZcXA0?=
 =?utf-8?B?UFd4Y2UzT2hnN1hWWUxkYXlBdytPUm4zNTNubjRURTE4Z0NNNlkxbTc3ZUpE?=
 =?utf-8?B?aENOdU41TlF5WDF6M0Z2c0tYcWNJR1VNTGQwZTRBdGdSSExzMW5STkR1TWZy?=
 =?utf-8?B?eVpTaDE4WHZDNkZiZXNRSmhSRHJFeXloVDNrSTNRUjZnS1pKdWhhSmhhTksr?=
 =?utf-8?B?Rm50OWk3WGthNWszRk8wckxzNE95Nk95c3RuT3dyN2pHLzFOcjBROTFUa2I0?=
 =?utf-8?B?aXUyUSttUDlJTm8zVnpUb1gwWWFIcDhIcXBXUFlrUUlYS0VDY0U5UWkybzZK?=
 =?utf-8?B?eS9pSldqRTVoTVFrbGs4anRWM0JMd29uenE5R2VCRnJmdWdrV05hV0J1QTBn?=
 =?utf-8?B?cDVXUit4V3AvQzZXNW1hRWd2ZVVXRWZaUFAxY0RDSktzRHc5eU0xT0NzMVgr?=
 =?utf-8?B?cFJEN01FTlFWZlFmY0M4SUFpMDY5YU1jc3J4TFc4UkxpQzYzdGdvaG5IYnp0?=
 =?utf-8?B?NDhzRkhCUU5TYjJJZ1FsZWxKSU9YbUdjNHJ4RlFBdnNQcDRBaTI1VE9aQmVG?=
 =?utf-8?B?aTJJRXdqNjBVaFYwZ25qT2pIYjQ2alppbHpLL2RTcUxNQlI0N0tNejd4WVRh?=
 =?utf-8?B?RVFFNGU5T1EyTlJPdTBoL0pIQkV4NVpXZk1IaitmVWVvRStBQ09tbDdYZEFz?=
 =?utf-8?B?MVJyT0tRUm1JNHdiTVhyaUhURlJoano2M1FmWDUvLzdpaXZrNUZMUk40WFVW?=
 =?utf-8?B?RzdWZUxPQ1Z1cGRGakVmVUNETzg0TzZKZVZhaGd0dkhHQVFuZFRVSTFaMDFa?=
 =?utf-8?B?NW05NHNzRnVJZDczM21PUUg2Zk5iZTJmSWIwRGdVcXMreFI1RmFxNHdvMjNv?=
 =?utf-8?B?SzNVN3cwZTdnUjlBSHFjU2xBYjB5RUl1eXdDT0NnYTRhVlQ4YXpxRm1Lb3dF?=
 =?utf-8?B?WFBwcXlZSUoyQ2J5bjQzcEduMWJKZW5GaXZraVNheGN3VUlkSkJWakF2Qytw?=
 =?utf-8?B?M01acTZDdFI5Z0ZlcWVITHFsL0NUTHhFNUE0dkpoZkFkcXlHMGtxYXZ0Q1dX?=
 =?utf-8?B?Uk1mNCtvOHB2anZ0aE10b1BIcG1LSVRXZjR6YlNtY2ZxMXZwK1dQL2llMTFD?=
 =?utf-8?B?NzVocmM0ZHZzQlh5bFEranFaSVhnOFdMZ3NiS2ZsV1RQUkpOS0lOM2xWcDBP?=
 =?utf-8?B?VzdoVE1keFpkZUgvMGxCU1gxeFdySy9SK0FSWVBoMzduSjRLcVZVc0FESFZs?=
 =?utf-8?B?WjY1bEFpNi80cEVmeEQ5eldFYkVRYXUzenJ6TG54ZFd6OHFtNHMxRUpJbm5N?=
 =?utf-8?B?RFhJYWtTQUlmYkxzWE9zNUkvcUFaZmswQmJnVGlJKzQydVlSbm51OGRwL01U?=
 =?utf-8?B?NXlSVVNYL2lLcU5aSW9oNXc3V3ZaZzRxYURTcVhzOTJ3UEt4NFhaRGZ6Rm84?=
 =?utf-8?B?Zm0xdyszTEdHQ1JMR25HZEVnY2l5M2R5akZ3NUxUZFRjZFlRVHJ3QnlaWUY1?=
 =?utf-8?B?NDk5bU9Vck4vTWt6dDdtMG1VZnpyNTVURjJZQXJPRXowRjhiekVkYnlkS3d1?=
 =?utf-8?B?UUFYa3BLVi93TGt6dU5mQTN2U3BwWGdnSy9EZlROaVpwRHlLRXl1MXZGcmlQ?=
 =?utf-8?Q?5aS+zS2r3ACCtjQ1+n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019f184a-b10b-4462-5145-08defec340ec
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 13:59:29.6027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyBrU7pGcTm9gz1Gwa/zuaozWAXN1vFzVcM6ZNi1pCQ9pQq8gZY/aF0atnnpswBc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8645
X-Rspamd-Queue-Id: A0018C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9f7eniers7gzy9zoqyswzkz3j1fdqby3
X-HE-Tag: 1787234377-200555
X-HE-Meta: U2FsdGVkX19AO44aXI1HFCqrkLtyV5bXiIWSE2UnDODxBzMXbxRJbY/mZRI9dGQR8oI6GHIAMcCXmk4EXem/2i/FQ477qqAjpBv1O/9L+KW/Oob542xLGrnP7CYQCYAhRfNUWx3UwCrp/W/KkqZw5FA3chQJRgcXTqDjz1USMbUwvdb3znQv9vSt4SAX4wBlKZK5ufWn6fABJOCfShKwczj0ubi9lR0OqBgS8UrpDhBg2tD4/Y/STDW+d9ItMDKbA4vFLcoqz9I9Se4ASkSYYswOA4t0UczbkTXhxsEsTJNnAmhQUwTQM7Oay24doS0fMlEBYx2a9ge930B1wCTfadGcPoR2c7ChqSbhdvWLhQbvtfoHsSgGSAOvMFQkNfhRNnTe+aV4HGdHZDqCS7/dy6txWNGdN4qp+HtNbqlLCvVtCer/1aU1XscR5Zf2pPJ4513vnJiG9XxUKcwOdQTq0wZWvyexRjv2kAXqQM/aKsT5jp1SWmlBp/clog3JTy/F6anCjruIxWWm+xbW3Q8dy6bX5D3oSdOyvaCnUEZi0/gZPdRSavnfG6Q9rPglvb/6hne5LoO/3079+B/XrzOVsBLmsITZH7g5O0T2jQOP+llXaxq9aoIfyc5jdts4ZbvBYPmpbC0XDcvbpQMB9zZECo1Z1hrjmTJJhz4MKBs0VUsg0APVrz2e3FXMXUICW4n9mxFlT4FxOOrp3AjnsvnXO39ujgBp1wrHihregPzxFpQLe8ZO8xjPkw3t/khtXSx59IWbSVYZVeKMdlBRRWRrqdrkbqZVoiGdAtnm+KqYivb/4mh/syeY2B/bBmCP3OfOovU/KmZ49dOaIgntgjWS4o07LpUfrN6s4PIMFAUsGogdn5UuMkzRz+6YLsXaDa9g6+Ugpq556n58h6OobRP8y8w+1L3PPIDw3GaKYjEfvtObuCRj0/IDWfqzTUIUWQRJpl47qGU66hq/5dvnBcg
 FNCt2Akd
 YCa5E0EYMI6XHWXQ4RHtaH25SqAfLHFlx1YI1L2M6c81vOi0lhURe/6Ji7TLUtzNMidkDhNZvgzQ1EC0VEoTjFtFwwpPY1Uqw1nkpWmqeVx9cO/HnceZO+6QyLLpWrI7YvQ/FjPkqD+oi755HuvjGP+XmvHrhKy+Si+yK9uDTJmHglAqXbMAuHMuwXGaLB+aOgBxp5JFuVZq/XHIqnShNRDru0HTqGSejR3VIeqK2U1BrUbenp6p6IfE6E8Q02lRfmkLQIZ7V5+ASt2NuQ/rs/rmYx7GWipG708vUnJxg5/6HVsEQHK0c1l5LtihPBOzA55OVNpYk2K2JFckKoumwkR0E+418s6iwGX0KnZK2r36TLst22y7U5k4TtOCx9yx9iI18xdgU4gg8RtgBZu08yVcB9FVHHd+sc/2/NPN381ofbKFnOkrNS12uba903fZ0yY5Cs6UJ7l8VT7X0IeK6hxAmCaI57leCXIRh1y1WL44ejfmW+dUS+UYakyWF11EFG9LcUywwWFi3kEYza76sT8YGLPdhSKxBVhdwFq3zzj5F3S4oGLsmQHQnI7Hk/cwaCWSGo/OnJsAlOC57bFoY1aCsrRYF2mBLsW+wJAgOvVP8de0JLKsdhWFwuP6KIX14Z4UZgfiWhnXixe9yy3va4kKMDCILSZmynHrlrZpeJchiOCRcQ8tvGsfy5MbxdlPc+bX3s58gry+3gSKgq7dKw6ArZHfZVKVLP8DkwPURqZDLB4sR8hy8Yp15ZqwRbX9ZzY5KBos6uHO2lopUcXWt6QnKK07dOP0L0vfAkLtJV7Eqt5fiR7hWKouBt4gasHKfG3ESwr2m6/0oG5wJjlSy0i++8A/X0TuqqsrlbH7esgRUHIjsg/TQzgJdgh6o9x2LWb4utC68tLo6rirpP3u+OR7IUN7UIA+wkobGwyyNS1ioKD7uUpdh+pZoCCfaxjidnD85JXsmTLC57m0Ah/4TUGO5aiEw
 ku4qckyj
 TUS4zXx/OuQrjneceNaLW0ZymFYOBI0OLgprLgxh9kXX9VWH2hCKCQH2zO0/Ad50s/gPNfXmg3vZa3U6XPm9aWnyKAtuZt59iNuF/cqlDEs7VsiQvLxWOTH1cXQsDc6LJtxQyPfEwoYU87QZLW4LcN6yRwC66n01tj+EoBJVLPcy64hwKvEH7eDrpFg54/wZoHa5q1S/dso41tE+MF5igYHjj0djOHH5P5afLjUOPHnJLvMVdOA5FkiurdEcGUtk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Vlastimil

On Thu Aug 20, 2026 at 9:55 AM EDT, Zi Yan wrote:
> On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
>> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@s=
yzkaller.appspotmail.com> wrote:
>>
>>> Hello,
>>>=20
>>> syzbot found the following issue on:
>>>=20
>>> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel=
.or..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15927479580=
000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da59830cba91=
a1981
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D805630f1453e4=
90427fa
>>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e=
255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>>=20
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>=20
>>> Downloadable assets:
>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmli=
nux-3d6d8176.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4=
/bzImage-3d6d8176.xz
>>>=20
>>> IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
>>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>=20
>>> gadgetfs: bound to dummy_udc driver
>>> ------------[ cut here ]------------
>>> 1
>>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x38=
0 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
>>
>> Thanks.  drivers/usb/gadget is the offender.
>>
>> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
>> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>>
>> I expect an easy fix would be
>>
>> --- a/drivers/usb/gadget/legacy/inode.c~a
>> +++ a/drivers/usb/gadget/legacy/inode.c
>> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>>  		return -EBADMSG;
>>  	}
>> =20
>> -	buf =3D kmalloc(len, GFP_KERNEL);
>> +	buf =3D kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>>  	if (unlikely(!buf)) {
>>  		mutex_unlock(&epdata->lock);
>>  		return -ENOMEM;
>>
>> or do what Gemini said.  Me, I'll add some cc's and run away.
>
> Let=E2=80=99s do this instead of suppressing kmalloc WARNs. Since a simil=
ar WARN[1]
> showed up yesterday and that WARN is better handled by a bound check,
> I do not think we want to lose the WARN from kmalloc/the page allocator.
>
> [1] https://lore.kernel.org/all/6a863306.ae6ddae5.3da009.0013.GAE@google.=
com/
>
> Like the patch below:
>
> From 732ea7074854ac3495bbceb274cdd01966118e57 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Thu, 20 Aug 2026 09:19:12 -0400
> Subject: [PATCH] USB: gadgetfs: do not WARN about excessively large memor=
y
>  allocations
>
> GadgetFS passes an excessively large user input len to kmalloc and kmallo=
c
> gives a WARN (see below for details). Suppress it by passing __GFP_NOWARN
> to kmalloc used by both ep_write_iter() and ep_read_iter(). Follow the sa=
me
> method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively
> large memory allocations").
>
> kmalloc is used to allocate physically contiguous memory for kernel
> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc use=
s
> the page allocator and can only support up to KMALLOC_MAX_SIZE. For reque=
st
> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> because kmalloc allocates an order greater than MAX_PAGE_ORDER.
>
> Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fa=
st path")
> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@goo=
gle.com/
> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/gadget/legacy/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legac=
y/inode.c
> index d87a8ab515107..278a0a2b39f4c 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -604,7 +604,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		return -EBADMSG;
>  	}
> =20
> -	buf =3D kmalloc(len, GFP_KERNEL);
> +	buf =3D kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *fr=
om)
>  		return -EBADMSG;
>  	}
> =20
> -	buf =3D kmalloc(len, GFP_KERNEL);
> +	buf =3D kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;




--=20
Best Regards,
Yan, Zi


