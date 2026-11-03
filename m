Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EC2606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=L69GN3Dj
Received: by kanga.kvack.org (Postfix)
	id 5554E6B05B7; Mon,  2 Nov 2026 22:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CDB6B05B8; Mon,  2 Nov 2026 22:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F716B05B9; Mon,  2 Nov 2026 22:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E006B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:44:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75A9480286
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:44:58 +0000 (UTC)
X-FDA: 85392416676.08.EA0F0A5
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010018.outbound.protection.outlook.com [52.101.201.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75B35140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:44:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L69GN3Dj;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677495;
	b=sG6RhVO4e2DwNcnsSkToYwf2xUwRpFLF+huESUwv/e4Iz/LH2kLNxMVpSJl6rwTP4u44i5
	GV0rfLtCMDO7cdmIAFQzN/TXN596o9lZkUU2iBzHHs0o+qDWvR1XmLORp89MOkxO2/xTlk
	LRPWQZ4d2qYOmtHQRfWBdsJEh8wg/ZQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L69GN3Dj;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYiLWDQqWBIeJt74rCt1ZoHlrBNw9kmuRtqwIBxpr0o=;
	b=rY8lIsYSyLzfUgA3ZLZQJwlt8zIrof5fFgZ6D7LC+pgH/Gi7iikOuG2um2L2w2T/ahKpHw
	7kLrloriFkUH0hSZ5RgoGMCaCK72XMdckuqwWMBRdQENAa7jCYdg634mN7d4640yYV3qF0
	a4HGozQt19Qt5pk9JP497bOtIyAsBbw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbR9NGJguvgjvHsp/HAqujqlgOtlA75cFs4EUCp0s1Bwx48Io+T1HH5J0K45BJ5KAoffjFygneIQnqGxh5BMiNFDdUrqFIsk6Td+TgLKrBS1rfWqfndsf58EgdHj7ajhSnf0qzxCDKpg5hV2qWDRfPPiiVD0WG2rYjEX4acgH98V/U9fteY+x302F0DbyWuMr1UI4ZHhAbHxZ16gssGUgkn/Q6WIRVKantC197jDQLb7Af0bAngutGp7Rq8Nb/c6GOavTxvrEx4R3sRpVpcuiL6oI5oeRsfhZtoHrDPrZYu/Ec+4TAXgKIWRxDXilyvps0mX0dKt07xK935fhtvTig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYiLWDQqWBIeJt74rCt1ZoHlrBNw9kmuRtqwIBxpr0o=;
 b=AVP7AVpjmtSDo0oFtkCQlrz+peb3xhGujkty46IhVmdbwCZ2FDeCHTqOqIWwwtE7YMXFSLhe/16tlS1b4q9RXfRVnchIaFn4t2iHWBxo8NpDajMUNjcZW+h/NhHkAgOZ7MPMD3aU2otExnWLsvyBL/1BP45oP16s4Q42JNVDKMhw4eVPmFyiXmJOPULvcorWceTFj2HmWHJqMLE+1D2WnlRs4p1cVUu45hfH7RGfF+04jCWbxlgE8JHh8A8jb2+PTBPcd+/JwbRnNW8NaxcMmY46rYdMdbYNQFSHyjybJTFU2SXPzSe9e8ywWbJIkhyiEVdXQNCtSwzS0elqOdQYOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYiLWDQqWBIeJt74rCt1ZoHlrBNw9kmuRtqwIBxpr0o=;
 b=L69GN3DjZvOijPJHx+kU4LG09zeYoYTmr0v9cEVx9mIg5lWDWuMY1UoIPrTdiI2zj9YawIMy2RQAZDvcyOsSXxnJ/9gxLf0l598MG6SL8q5lv2TbRS+20RqAmdzqPZMUDJoT+wWMDSnBXEURRcHkUWjboCn6lOBTun4Hm2eMppo9/zFJ5wqvMZ6W/UAtTZtTsScXzaBmJOziUXC0l647MsJsE5EID24kUXGMXmn2RKEYdj2SCqUkuN30M6OXgBuHnn8zafqIcRoy8I/oJHV0Z+iMSXhCpsiUPCoyD9COg70hYfGPWHoYEKnPB5f4G4XVB+mBJ13HIOaKDJ+KNsP/Zw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:44:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:44:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:44:47 -0500
Message-Id: <DML9LQ35B7ZO.4GGNV42WNFPW@nvidia.com>
Subject: Re: [PATCH 4/8] mm: remove attach_page_private() and
 detach_page_private()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: CH2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:610:52::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aebf8b1-8cc8-4e3a-014f-08df395ccfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|921020|10067099003|4143699003|11063799006|261021123027099003|261022075727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	C642E0Pov6kEBEFR9VeClRF4VXLPf9fLCsc2yAa7FEOanSwN+puGT2P/FWEpsUOCrjdpdmwska5HfIvxAWBh3NSspVOyQ/OzTLyjjDBGH08h17iaO+vfVf6L+3N3mIanNZCskcO9NKUV3L6zhHzUvACOsY0Tq7RcHTHutYZQgCnvnfkM9Gr1yTTjxUxfaaHKo/LLcSf6gG7oIj8ZNTqydHkwDAMo0rn0Y8fjr2N/Tg4VeclsBv28p7cQOqx8nd9i/IVLzI6R5duHOX4YdGx5KHUM/W1ZgGD/CNw63sjuYCExkW2hwh1srIIcn7HbXMWtaxq5Zf91a4+QreYE/2gG1RfCdzuXMMA5MXuhMrrhzwZnLnpK1b7LVvMyBoCE0/C1ckJMmHMQ4qUq15orkByLROPSqfNoj61drx6YlfTcD0NLsXWT/7WwzhA5L9HhplPVw3FZ99YMBHZLocyHvKLQ9Lu6XIOvSyAUe+evvVZtRR9EBzVjFW2Md5ZWvfNBXpyM6Res9BAr6RsDxsqiwFzOS9pQryZkVuT28fwv2Ro/jkVI+ByB04xurPe25qcbmMCGVKwG9UzL3MpXXG68an2Yna6CfusjtbttWi+8/ZBilNLQr+t8g9p55ZicNMydqVZX6sNULVgOnipz8XLj/NKYDbrV2XnHK3ssVV6h2aTa4LnzQ7MjqZ7Z32w6jNaTATZZGS/61Ogolj/Eqln3pHllnw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(921020)(10067099003)(4143699003)(11063799006)(261021123027099003)(261022075727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVowUy9zemVTbXBoc2oxbTJGSG45SHFQdkw5SjFucEpWZldsbUtjRHN4bDBy?=
 =?utf-8?B?emxqWEtyZ1dCRkNGS1FJVlJ4cTZibXBMYUd0Zk9LZFZmd0tuZ2c0cW9wbFlN?=
 =?utf-8?B?azRrK0E2MjB1VHNIOWhGbFRIWm5IeWNXNHg4WFlBTEdHdXIrK2ZMUjkzK1Ux?=
 =?utf-8?B?aVVGWlpEbVFaY1Nscml4aXowSkJESkdtSDBJVGkwNE85V2tvaG5yRTczSVlI?=
 =?utf-8?B?eWtnUVRUeVROYVVLa1ZHNVNyVjArRi81aU5aeEtPQWlpZkJGT050bFlEckFG?=
 =?utf-8?B?M1p0enlJcE43M1dHWmEreHY4cExpZUc3YnA3UE5iT212Z1psNTVGSXY0QlI5?=
 =?utf-8?B?RDdqemFkRW5rL0JNR3FGd1c4S2RJMkJiYTNmTm9YN1lXaXNTbHd0QzV4SU9Q?=
 =?utf-8?B?RzU1bkptNXNTbmxhY3gxUEdCbCtXUGYzT3BDUDhuN2RCSVpFbGs1QXVWSFBV?=
 =?utf-8?B?L1A3L0djaFBDZHdmUVZJR2ZaRjY0Y2lnTCszYjd3dEZzSHAxUkpjZXJjekVH?=
 =?utf-8?B?dGxvM1dFZVpqdVBzRFRBWVh0RGFDc0NBNEpDWHJkL1N4akZ2d0haaEtMMm92?=
 =?utf-8?B?VkF2eDZZR1kyNWpjMDV0U0xRMEo1OHUrbG51UWlMU0k3NUNqeGg5VFpVNWRj?=
 =?utf-8?B?bEZ1ZmNiTWJBbXp2TXd3UDRhc29LOGU4YUpOakJUV0JFbndNY1Z2WlMwUWp6?=
 =?utf-8?B?NEVCdUVHcWZmRzhraHRvNmkyMFdsRWZrVUN0ZU1kWHg5cVhIMTV4a2pQQUNp?=
 =?utf-8?B?ZjhhdDFJNjNmcXduT0xnSnRmWU1WdUd0WTAyNVZaQTF4aVlQZnpZcWM4Yy8x?=
 =?utf-8?B?cWdFajZ1bWVOV2x2WU5aMDJvOVpvUzBvcnUvV1dXTnJNYVQvaWdYVUtOVFpS?=
 =?utf-8?B?UVhSQlhlK1FXTnEwOEJrVkxUUjJocDFtSENTT1NmU1FPMGdvQXJmWmVENW5C?=
 =?utf-8?B?eTM2Sk1Tb1lOenBudGhTVVo4YlVMcGtQcFdnTEUvaCswa0pkSVAyK3Azc05p?=
 =?utf-8?B?T3BoVm1JZHFGakZmbHR1ZzlTNCtIMnpFMk9nWGhSY1NsTTJ3ZS9VY0M4ZUcx?=
 =?utf-8?B?alBCS3lEMnY2ak1ib3E1N2oxVGx2OWcxaTZHQysweDVHOGRkMEdEKzVCUzFX?=
 =?utf-8?B?ejNDOUhtc1VKbWJ5cmtER1ZmQmtFaHlYbjdkSC9iSHVxTlhLTHcwRGZyZmhC?=
 =?utf-8?B?dW5ZVWpybnpRTGZyczlPZHlwOXVQNGZzOTVvR3Bkb1kwSEs4eGNiL1g4K1pW?=
 =?utf-8?B?OUpRR2NtcVU2d01wQ0F3ZEJaTkx3V2x4a2VkS3hHcWhQRTNVK3huZnR2ajRv?=
 =?utf-8?B?c2JiclU1c0l0RVU0akJ1SEY5RHo3VmphSTVnb09ZL1RnWFJoaVMyT2oySm5j?=
 =?utf-8?B?M3h3MCtvWXRXc0VTbWhEM3NSY01XVVJybXdQdEZaRk5xZ1dzdTNlaUkxTTJF?=
 =?utf-8?B?WFRQZWZlOVNCNVlCbnlkdHJPU2lGc2p3aEM3ckovaGNOVDBkczlON3A0WWk2?=
 =?utf-8?B?U1NTOWxTdHNYZG5hWFZwN00vT0xmY1NHcm01V28wcGNJNW5aajBCOVhweG5z?=
 =?utf-8?B?c0VDNE9XSkhlSkgweFcyVW1SYVhsWFRySmxRU0tnaGZYVDdNMy9SLzRGVjVX?=
 =?utf-8?B?dmM3TXpRTEFhMWJodGMyS2dFZ1NyQlpVZEliN2ppRVRTUWI3M2QwbVY3SG9y?=
 =?utf-8?B?VC9QVm03YlNkd21rakdiQ3NZNDQ0bURxQ25aQjNsczNxMzQ3OEVQalIzV04z?=
 =?utf-8?B?U1Z4N05jNWZlUDZqWi9YMzB6Qi8xY0o0bUtmMFVseXVlQmg4NDV5bHpReklj?=
 =?utf-8?B?T21sOUp4SCtOOUNGNytwYndjWnlZQ29hNEpwV1lKeXBpV0V5N2krN0dwRURR?=
 =?utf-8?B?YnFzS2VJTnJHNEJodjhzaWUrQitSdGFQOTBFeDZxZ05KbWFwVDFMaEx2UjZt?=
 =?utf-8?B?eVp4ZDlhQStDUEZzNGlseHFteDIwRXFyOHpEMzYxcVZ5VEpNK24rUU5VeGIr?=
 =?utf-8?B?YWdYV094NGRXTlo5WFRLT1UyWXhXR0d5VkhRS2wxV3AwZEVGY1d1azB3UVk4?=
 =?utf-8?B?Ry8vem05eHdIUXRNQjVpUWRPOE4yamFKby9TVFZIUVh1dXhweXl2ODMzdDZJ?=
 =?utf-8?B?UW10UG01ZlVrUmoreVFkVGlRbmVkSnp3QjBiSUszQ2prajg0LzV3ODBQclZp?=
 =?utf-8?B?bzU5aEVzUnl0elNqWHh0MGs0SmdzdjZNZEVZdUJCNE1oK1N4MGlxSUVHYk5I?=
 =?utf-8?B?dlpWSmc3TE5kVmJqOHpNMTFtS012aHN3Ti9FbXJMaGlhNExVUTZTcmtpeHY3?=
 =?utf-8?Q?Lda7pab0K8u4akwC9f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aebf8b1-8cc8-4e3a-014f-08df395ccfcc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:44:49.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bCNg6KDHMXI80cDR6A1SxmBs/FQb9s4336Y2sDfAPMen4bo5UQFeLWKubiTOtbHo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75B35140002
X-Stat-Signature: 3smy79r7mrqht1psk7mrk9trjf91qmno
X-Rspam-User: 
X-HE-Tag: 1793677495-643038
X-HE-Meta: U2FsdGVkX1/kATP9A2GpJsuFKKO08M/coXLZg0OXXr0b5oqr1uTVUOiXo64FKdulvT0ITHNePyNEMsCtjX+fyuNeYi896U2aVx49Ivy/WkBS9viNK8cHvIRAbJ7lkCOqHYkhcf/nqxnn2SLfmTjsAvJQLHPRU5X1B7K99oJTyc8rl2SfAbHXd9wbkFrRmhx0x3IJ8pFlafyr1aV5KPEuWHdBlDTxnjOITaNz6SOyu3huYnwHxKWLP4EYp6DpDi1rC4C82XTFkTpWoGWm80K3pIMsvC/Wj3XTgDTxYsW+7tGXJqVjYzNj6SGgVAwClLaraXuiSMQ7YomzQqyXla0oDW0DoooHSqA8Dn+vwdfa1/nGzLq6jMHWobB1vOLMNVXp8QX2hJI2/seQOvGzijJbe3nmr8FNba0sZQsNmlngU+DlW1D2GhN9fynAzEiUo35tXyOdBUFKJ5sg2db5JLDlps00ShReh5oReW2HCNEw3M94X3ETzOJrv1eHJzKgj4eymyLGj+RhSxPj1e8zZk++X8OZZi3oSXn35TTCN9TgUCk9AX+e1kygLqiVbwGyQ3MAfTfNB3QCne4u9fFUXTAztNYOJ0gOyQgLOndB2wF4ID9slPa3g7zKU+8DWMKoh8vFGId47mUF5sqVO5e+JexYjGOjsQF71vGHqruH90Fk9SlgzKFxttyyHW6RT5Tg5YKpCl2xwvzwa9Pm8wXKS+unaJ7T5YV+81EmQtKrh0OjTzkjTPymniZBLSOwNoxJmcciM333p1Ty31WZ6eGzLemiG2RnXPNYc8TO7Oaq3MbHbORwaeEEL1cUJV8DvUnjHK9pCNB6ZxEXG6tEWXIyp/tEGo6V2wSRH79HLb7uKYa2+dvV4lOQzsVmSHNTUP7GATKoWe+guruWJUpxY6cwkF+XR1byYa3MhMZA33JQb1Ozl3WRVltv/3krfsJkyHf7P+nskyhqHTpcDRGr3l2GpaI
 PUEmJS7S
 xfq7wA3zFmo3s18T63z0k10sQ9SKdScmF0kt5tNiEDckrtfrFmvqdsIqv7CCzVBfDyCbRVqjovG4LxtJosC53ywLHz5MIlYLz9pix0xJVyY0dTXR2YVbBzObgBo3tkJ9plUV44aNHLcBBbSqyPF9rCMAxaCtnTLHh3qMJTc0YeMytaOIhjqzEZgy5Btra7pOkzkJCeF3Ryp3mWbIYbI7OAZSdl2oWokHTF1JzDEyyKqpPVlWnZH/jMg4de4An/+5OFi2ILjbtQIiYgeqWEUbsUFJh0eWdXCGC2f2twAjwcd/jk19pSYCbtTcJK6NQYd+86Rt+oOl4nhUptSB9kfG1RItrU4n9NLSyM4UzISGo4mD9Hp3otYEBWRlO/1tSp4dR1DLCkRxLf2XJK9Nk9lfDmCDzqfTzQ1/mMfbhM3AqjF0PXHBXaj9IxBXcir+2+pJ1Ru3h2ZncZpLT2QUn8DXFic5do4aPkmSXZfIue+MrVPZe5vA/+n+QC/AJe/xyPLI7mm1r5afbQrls9XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> There are no callers left of either wrapper. Remove them.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/pagemap.h | 10 ----------
>  1 file changed, 10 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


