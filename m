Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D85C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F21F6B00B9; Tue, 14 Jul 2026 13:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C95F6B00CF; Tue, 14 Jul 2026 13:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9026B00D0; Tue, 14 Jul 2026 13:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 565BF6B00B9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:32:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E81A91A045D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:32:10 +0000 (UTC)
X-FDA: 84988075620.17.4A1E5BC
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C34A80004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:32:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Re6Y8bYz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOV+lRx0enSGYVz3GobWR2AqeORiEPUU/U3DFaQndpI=;
	b=lW9Uhsu0qo5OdOnVyPEMV1t7GR7iWdGa5rLvwF39KVbmdCbeHxv64tQfpKlOzAoff7m/Gt
	GXcuS06tjZIOMMkANDz0qY5KIgQ1Q3gjzQOYkj7bL+ivtB3DtOwIbkZuKiC0ivUR2TClH6
	IqKt9OSLxewEQvgOVvvoVIto/C+t8gk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Re6Y8bYz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784050328;
	b=E8S9TpahjVMhvIIVOu1vnL/Bl+hzMItRHhJlCg4sIhE/MiCqtrSY+AaEezF7OV5J5DSWn+
	ttHrR28a6I4fMdw52Lmwbs9dgd78QYqmFTdi2ESiw1aY1ihMJwQMwLPrUrMb+I6NtJMUSn
	k89nKSL8PcB47U8ZKn2pAliTVng2ymw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vo4AM2gZUDWbqd8jq/zxLz2QxgogPoUC1oCjTSbCAejxPJxGHjKOBVgiJmOKgisoY3nO2xqh9jPwgb6bThEJ8C7qAnO0LilO+wzEuH/CRjJPlAQUf+tfxeU8NGUGqTPbYMBN20lAnhCwSMRFB2pJtxXXI73FBWRYcLowihuGxGaby9PlfOhgSum3RFfHc9im4Uj2uWBoKJWNK6OUchNkB7SF5jT1HNnoQsKrtd2IN35UeVrrOkLI2jW7zxBhrzMI8fJLB7fsALnpwF0X6BwC6hnqjVmiOtMgZJ5J1kK9+XszuJT+oX7vgX7AdfGNUPdI6mGwiQ1bUiEd0DLs4vXGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOV+lRx0enSGYVz3GobWR2AqeORiEPUU/U3DFaQndpI=;
 b=MyuZPqYAyqdgEoM34ezzl/WDlBDL6b5gcNoCfQaLaUX8GTBvIqEoteLllQhSGjU9urfUoj7wGmzTDDH3ctzFd38RaKcK1PAsloTZryoQkL6DK4ZsVy2P/u4REnF1c1X8KZRu0+O26RiHCTtessD+JzhIVNRxNmdBhxyO6LcnxaDD0r0WskAuMYqdBjm5L2uzP2a1TaVlQjLsqPD5psmqLgTQmgyu52A/tqZZ/EyJDY9OLaDKkJExgpmwkYXO+mVaAJPhg6WlaqH7L9zIBZnlTjDbaUVVqeOUEUPmJxnAh0JWKcx1bJ/mX1rGPM716ot3PfoGP20d4+IFulhyZKKw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOV+lRx0enSGYVz3GobWR2AqeORiEPUU/U3DFaQndpI=;
 b=Re6Y8bYzStrP60y4LomnG7YKf3y7M/AaKxS95sApF//8TghY+hzOQjPijgpZt5MY2f0jBq0gTlxXGUWuV+woFpRbwP4jrHRTtOxNmhLz/N8GwTDSjCeYbv0VJDVi3Q9PV9Mzxzeard+Kh5F1bWk3gHmYvgG9W/aT6QZPhLQWLS2D8FFx8sMPav3HAO/1NjIeRGpLY2aYlqT9bxJ5Tf72tUouzwLP/IvsLcRkuNNxSyJr10ehUG/bxADr61Tr6I5BnV48BFhJ6FBHLHSsI5cMbIUELrGjEezYa3sxrAROpYPupGl4tNEsGp7rlKdKVTX+WJefOuepLNgzi3jOuYTgVw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Tue, 14 Jul
 2026 17:31:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 17:31:57 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 13:31:54 -0400
Message-Id: <DJYH202OLKZF.432DAJWF2MGA@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/memory-failure: keep the folio, not the
 poisoned subpage, locked across split
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <npache@redhat.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Hao Zhang" <zhanghao1@kylinos.cn>, "Hao Zhang"
 <hao_zhang_kdev@163.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260714122344.351895-1-kirill@shutemov.name>
 <20260714122344.351895-2-kirill@shutemov.name>
 <c4aa63df-30ab-464d-bd0b-48dc37c8e6ba@kernel.org>
 <alZNYYsybKZA0eJb@thinkstation>
 <18fe5529-2ad5-4330-a362-708a152bacee@kernel.org>
 <66A57599-EDA0-4E99-B073-F2AE0B2ED708@nvidia.com>
 <alZljHr4Nk3FOpCP@thinkstation>
In-Reply-To: <alZljHr4Nk3FOpCP@thinkstation>
X-ClientProxiedBy: DS7P221CA0038.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25e::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a37c7aa-f0e6-46a8-e75c-08dee1cdcdf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ioq2zAkQUG3m39yVNJ0I8IBXelZt776uisPS8kR3krAKklAo/2GNfHFdRLHEGT9tTadzZmfJ47ppTO3BCMhY8MWuJvBTic3MwL25hOg262n8FKu96l2wtLdV/QKjffyu0br5QwKHe8a58QUk5+dHTGYFYi/40IklY68hWeG3PtYqEUnCn/YUzLAwCRP0XnUF74YSL64gnWOnP7TYuB4IVvXOvZAbVgoM79ARWzGPV58CxjUsz2q06k/hAmr8Vcmv8lUohJ9bbRnkba1oxv0S7ZOKBgJBbJkb9CtkXdhcd1MRwHKrOls4xIms4qB3W7OHani+GfZLdD/NaFv6DlFXLtI49rjrZv1R5hXfrhfGX1MwuKAhQ9MVFyTdCrLOTAjFY98hRJkyIVv3G9ch3s5Fv6/b5+AH+Tfot4+9hzgPGCbBOC0f1fMQjRder+JTjP5aEJ3oybbevx84jwnXbutr9b1MrkZEFZfXHxILKxSVPCBpypiNrCUCUBKMCPyd8593ggWFQU7uG1V2G8/W0btpgEqCoK6NYHLlYBDeIU7Z6g8+h+t3zscxp8hASFBgR49NNfYI6fZkJAPYX31ot2m9L41huCg9AwPZgRD3phh8u9LGu8fo4evspswJqISrJzVGkoPvjgzhk3gVBOCFJeydAozp6iEwDL4n5hmEUA9S3JY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUlSbVlRdHh2eWxsby9mVDFuZ3pNcnUxaUVRTU03b2xvK2l0blZBUXJ4OHM5?=
 =?utf-8?B?cEo4eWt1OEZNMVoxbFhrTnFZejUyNWJtVXFZeW9PVWRFcnVMenV5ellWdDZ2?=
 =?utf-8?B?VXQvRXJORGVpTG9kcXJPVUo3eVRsR2h0TkhpWHJ2cWJkRzF1bExxb2xhMW41?=
 =?utf-8?B?NFJ5SG9GbnJ5emk1NUZZbU95L3ZXK005WDRzU011Y3RVS0R0UXVhd09Nb2VV?=
 =?utf-8?B?aTlTbHBaZ2ViVnE4TzFVVjJNeVphajUzbjBHSFoycktWQ2lCc251MW5mVkFu?=
 =?utf-8?B?bnJ3K1o1aURHVFBmdWtHcTh4MFQ5N2RTa2xNTGI1bU9lbU4rNjR3a2tkS09q?=
 =?utf-8?B?WUpiQmYwaXhZVEVadUNybnBRQ3RBMm9TWmwycUNZZ3NZRlpIbG5saXdyS0lj?=
 =?utf-8?B?akhqQnFCY1VMZFNCZzU3bVk4SUxnRENiQUdFanBjRFRnVUtuL2F6bTQ0RmtF?=
 =?utf-8?B?RTRsVkVBN2FFVnpyelNodUlySkdLTUMvbWpsTHVhaFdMMm9aRWZGODBPSE1R?=
 =?utf-8?B?QkdNTFh4UFhwdUtQdXYwM0owazVycmxKcGp2RWMvNW9YaG9VTTdCaXZKL3BD?=
 =?utf-8?B?L1l3MGJUZEltNFFSaDZmYWxwemthN1pwRDIxbHdES2cwS0ZIWVJJbkxLV0Jm?=
 =?utf-8?B?cXZIbUF1MlBsYnN1RTBBd0hhYWhINS9yNkhWblF4VTF6MC9IR211akVDR0x0?=
 =?utf-8?B?MzZ4RVRjODVaaVI2M1Q1L0RFNjhBYkc1TmhQcUx1S1R0VDZXbmd1aWx5bTZk?=
 =?utf-8?B?UjlXOHBvTkh4Yk82RGNWZHhGOFVkc2xucFNHMi9YZXEvWVg2ajlIWTlMTHFo?=
 =?utf-8?B?UWt0cmRoWUJrVEJFR1RzVS9sWGlmRmVXWU9BcWJhTkVQTDc1ekxoREd3N3ZB?=
 =?utf-8?B?alRSNWQ1Uk1SWEo1bTkvKzJaSGM2dkRGZlYzM2w0MlM2dkxWTmFBb0FzbndL?=
 =?utf-8?B?QURMYksyRnhCNk1ud0haOHNxWG9idkZDZmUzWGlJYVc4TWFVdzEwSFRmby9S?=
 =?utf-8?B?UlZJMTdzVm03RjUyeHdqSzdVT2FlM29RTXcycWliSjZRUDYydVM0UWw2Q3c4?=
 =?utf-8?B?TS9Nb3Z0NGtZTnJTZWczSlZDaXN6QXlmVjB5dENTdVowMndDU3A2dTU4YStN?=
 =?utf-8?B?amtUSnVzQ1NLMk5RclFLQ0RibXV6Rkp2VDNwSFlJZGhUVHUyZFVNWEpZZWh0?=
 =?utf-8?B?ZGJaNlBITTkrR0hURm1DbGcyVjFSYmdQTWN4eEN0OEtHUVNZdGJqWUF5K0JS?=
 =?utf-8?B?bldNclEyWHRkcmJsdzlvYmdLVkI5SGZJbjJweklZblc5ZnJuTzlMY2VtKzdu?=
 =?utf-8?B?SDVwaDFwVHlKaUZxdXl6NXFmR1cyMlBCOE9tVHlBb3lIQ3B3YjBYVTZzUDhZ?=
 =?utf-8?B?Y0FuZkhvKzJrdnE4WkZsRGZ1OSswTlpkNW1XQm5tcjNjSmtqOWxCNXFnWFBJ?=
 =?utf-8?B?LzN2YXBMdGdQUk1reTVLdWZndTlFaE1DT0JQZHpIZ3ZsUGR6VFFwdnRiMFM0?=
 =?utf-8?B?TXB5QlFXZXlmNUJtSCs0VVBXaVROcVA0N1pGSWIwdHQxeDR5RlRPK2tHL0ov?=
 =?utf-8?B?V0lkRUd5NGc4djdCbGZCcksyQmZPdm1FdW03Q3FDeGdSOHVCRm14RXZoVkFw?=
 =?utf-8?B?WjhOanZ3VGE2cEdSQnZYSFVUb2I3SWtHbUtSMW1MVURUSHVabkdvUDl1VS9M?=
 =?utf-8?B?cC9Sa2xFb3VseFl4WjlWUkpRSTV6SDFXQjhIbkc4WlAvdTJod0ZDTm5NSGIr?=
 =?utf-8?B?STZiR2RGaFpaSExyN3JRTDdPVW5QeFBXRlJKT0FQK2Nudy9wT0E0R1NGa3ZF?=
 =?utf-8?B?THpyME9DK3lsL081Zk1IRmtPTXpGVXZRTzRiN0l5eVVXcnZpYllDWnQxdGpv?=
 =?utf-8?B?TnNCaXJsQ0YwZCtBdlc5djdTcSt2KzVYYmpXTDNQYk5IZmVVMjUvNmJ2RlVF?=
 =?utf-8?B?blVPeEQvbG5mNTJmK3RTNVBHL09BQ2tVM3o4UE82SklBR0c2M2RPU08yK2R5?=
 =?utf-8?B?S2JiNENJUmtqTi9WVlk0UlpMcUdNbjRvS3JGZVI3WjdnQUNaVk1EVUhTS3B4?=
 =?utf-8?B?K0ZTV3lILy8yYUczeU03VmcrUlpxQTJFd1dCV256bDZDV0UydVVCMm91a3gv?=
 =?utf-8?B?eW1jSTFpZ1ZVN21rNjE5aTFwdzJzSGw2dnBENVo3azRaN3l6QVJRUEdWYUE0?=
 =?utf-8?B?Ym1YS2RSc21sdFkzbHZSbW9Xc1pQb0VUaGhwcVVFZXdSN3lsZ0FPZWN2VjJH?=
 =?utf-8?B?U3dBVncrOFlIQWVUdVRxRUxQM09OTTZZNDd6NUs5RGpFSTF6bDNQRW1SM3RV?=
 =?utf-8?Q?0vaSsAwwpg+LPTfGJS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a37c7aa-f0e6-46a8-e75c-08dee1cdcdf0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 17:31:57.3725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwcoYN+WEooBrnKi9MDJte7MyfRj1v25N/9TYg1ztbTuyxGlKwJPEJ8p6n/X11Hw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695
X-Stat-Signature: tt59tsfz48h1cejufam3g3fmihwz8gz8
X-Rspamd-Queue-Id: 0C34A80004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784050327-249269
X-HE-Meta: U2FsdGVkX194qnpRSMO2WbWM5nIIC3bhcjziJrOudu2dzk+IaoU98kao0CEGuDDJbZPPKM5VYfICS8ferH3Q13YBPq6TOoutq5rMh63d96S6oMxWUhYayylro+2I3LkpLY4iZLR6jkJOWj497sWNv89pF3t0hxteOdp5zSYMfSsyJStus2ucGXCVhNV9GqYpTEMgWWEM+3fnHMWFcRz9lsyRtHbpG2yM4b6beD0cWc54Qp0i2MP4itu0DeFqO+LEJ4JrxHz5EWsX20vbxsHfaMA0E/KoZM/yL4H1eEvcLQVHiNp1NylQLiVWI/us2htMO1s20z7i2625CX7DalRtpgRbsPNAk7basl2v8QrvT/NjQ0DqSuQm+hQEut2DX9nEQOTaPdgkB2mJ8hYBXtlSL+Ns3K4TbKLjvlXEBfdd90aHUMc//b+kg5y3jm3uR8MGRMAHekLC3Nn+AhPGb8p7fpd2G0LfsjbOccUpg4C2up1dPMkKvqSFQ+GBQ7+qzqgZf9PhE8zIyRGbVHvZ6i+GTU4qSzw74I9Y24RbOEg16rSp9hEZPzOMe9SvGxbaBdDO5il+hX/CKnj4xuPPYcSAUJ9qxCT2l0rvXaihsF4HGaILlnoD01mx2iNvDsw77ZpRmEut/GJTI/A7vJiuaf1tLI2Ps4xW7NLzkRkigkPjl6LyBUwwbgmjYY7z97XZasYoR7MwgvDnKd+xCXtr6aCzH+kqdJeMmiiJR2VivGuJgHA7NXyE76QVhMb232UWE4Sgff3MesR3k1VszSsGKz+QHTO24MPCbio8WnrTLpbH0CPAHesmP0CuLR0xfbOtcwfOB13OIY+CIxgSVrZYgS0PNcRfS/4Xn20z7LBw4Y1mZ4af5SEfizbNKehddbAvYyonV9OIdrPaT+F3jTB3Xbrl6NOFTGitddKq7iaqFAlJneGSk2pMbwrogLOLJs+M5bLjof9vQ2+0Now4hzFnmyr
 uk5VyNYH
 mzOKAgrukherSp2hb2Uw84+qVGMBTFtI7RaV2sLB1as+d/21xll4Xx40cEKM8lWcI2tifhrBs+t/h3Pcg8bXroq9yXMEwGezJAnwx5XpGQ7KUruaPw6AnrIxWiMdriDgY9mKoL/cv9wlbpCq7otrLOGB55HLg8dkQU2YbNVClPd7fgF2Y4gdEjth+xV8DMqlQA7wcUAx/TjD9djzEzimNsZc27UhqLYVlB67Y8Bzg5bigbXvBiUAy/wcfGZKZEiaQ6SbAYvvpP3kOHrNBJmf4Y7pjeyvQPfWaNH+j5nAIqYBJKGlbtiu+fAIlkge9aT8jyuc/apwI1eC3gnVAwer/czDi4b28/ztwj10bhUSvUR+Y7vSNliog7GBt1m1C43umpVfFAFfVV8B2NZPJmb4Cwt2iAc5lFpjetHDZSA8mke9bjRIRZYvwUc0lQesJ3FtXDksC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 12:40 PM EDT, Kiryl Shutsemau wrote:
> On Tue, Jul 14, 2026 at 11:44:39AM -0400, Zi Yan wrote:
>> There is an alternative, only igrab() when @lock_at is at or beyond the =
EOF,
>> as I was bouncing ideas with Codex.
>
> I saw this option too, but I wound rather not go this path.
>
> iput() still can lead to inode eviction an bunch of random filesystem
> complexity under us. I don't think we want to think about other
> fs-related locking issues in split context.

Your reasoning makes sense to me. Let's ignore this option.

For your patch 2, we might want something like below to avoid over
rejecting splits. WDYT?

offset =3D folio_page_idx(folio, lock_at);

if (split_type =3D=3D SPLIT_TYPE_UNIFORM)
	lock_at_index =3D folio->index + round_down(offset, 1UL << new_order);
else
	/* @lock_at in non uniform split is always @folio */
	lock_at_index =3D folio->index;

if (lock_at_index >=3D end) {
	ret =3D -EBUSY;
	goto out_unlock;
}


Also to keep a record in case we want to have @lock_at pointing to any
tail page for non uniform split in the future, something like below is
going to be useful (assisted by Codex).

static pgoff_t split_lock_at_index(struct folio *folio,
		unsigned int new_order, struct page *split_at,
		struct page *lock_at, enum split_type split_type)
{
	unsigned long lock =3D folio_page_idx(folio, lock_at);
	unsigned long split =3D folio_page_idx(folio, split_at);
	int order;

	if (split_type =3D=3D SPLIT_TYPE_UNIFORM)
		return folio->index + round_down(lock, 1UL << new_order);

	for (order =3D folio_order(folio) - 1; order >=3D new_order; order--) {
		unsigned long size =3D 1UL << order;
		unsigned long lock_base =3D round_down(lock, size);
		unsigned long split_base =3D round_down(split, size);

		/* folio containing @lock_at will not be split any more */
		if (lock_base !=3D split_base)
			return folio->index + lock_base;
	}
=09
	return folio->index + round_down(lock, 1UL << new_order);
}

if (split_lock_at_index(folio, new_order, split_at, lock_at, split_type) >=
=3D end) {
	ret =3D -EBUSY;
	goto out_unlock;
}

--=20
Best Regards,
Yan, Zi


