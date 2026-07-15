Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0FB8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7ECC6B0096; Tue, 14 Jul 2026 21:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F686B0098; Tue, 14 Jul 2026 21:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8926B0099; Tue, 14 Jul 2026 21:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9945E6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:10:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38D5B8051F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:10:27 +0000 (UTC)
X-FDA: 84989230494.08.B7A4DE5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011015.outbound.protection.outlook.com [52.101.57.15])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F31614000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:10:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjIl36oY;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784077824;
	b=m9s2DTIZOLhF4zUzII5MQx6ffcB2guJs3qw4eAIK67/fR3+MIyXqP9Pzr7tsk3ZiGQ6+ce
	Jhv5h9va42LPVRmj/G+MR9Fu9keW78OwB9ORIEjFY5EUS8ubhBL2upY74SlwVAiNrAnQdU
	Rp8cY17pqTPNBA2Wtxe6bHB8NPBZn+8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjIl36oY;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784077824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irrhMPqVPwrh5x5VRg6r8rJ+6Opi6M71v8CmHv7AoHI=;
	b=A3VHmBZ+YKhH1Iiji3AvvLhpuYxHycIs/YHLFP7kDPGhDVCxVT9qAXhFAfIpNY+yF7rnLH
	i+jCMZzueLXZ32coZvAU6OaeE5O2Hv5hJ1N7lPt+eVqq+zoHfIAmZNwHC9aCo5hsORuYi0
	WdqZ6EZ15Rcz/8PTZI2NQHdPJRDnwgM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjFKlffGOmQ2IBaOfLxbUss0uLn2hK1JI9JlzStB/PPqHfWSX9p+QeyLKEgzCjfHNSoj9DXljUZboJr9yj+YMpzyjdzTCJRDSesjHMGTn7GcXZ5aB/T8vYuXMf3OWQyDrLcg3f/1wiiFSmH+xdaSW5EuGno6vv+cE9QoRaDZ2X7SJS+lCY1ukmhHtjzG3XeEFzkIyHt9lJ7yKDVvbG4JcsUuBKCAUA5oNnmI8KvT53d4UgUewCsnIo/frf3OkpkserTa2OxJ/J6nxcnbSO9HyzLm6IWNu4OgGqRUC/928ploJHXGBxdMy72wDCqBX66miy9e5NRPE96++XDyTHMG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irrhMPqVPwrh5x5VRg6r8rJ+6Opi6M71v8CmHv7AoHI=;
 b=jowT9Jn6M9tMPJO3tZA4rwveUkNGutvkPYpBl3KCVCqxlvzhCWBFYzWV9bs+fpM9rtJyBK0XWPLGYEEmVZNbMtVdnWm/VZZPkzjgvmoLpNeEHAqWQb7X1LN0kuW8LlkJko88OeCmYJzlfeoAvFvnW6iRWo1r7A1UqAW1aIozdMThjWnrSI1PbCLY7T82E67e3HQwS3ukcyYlnT8s+NrJdlm4RC0hK2Daw1Z0hgbOv5V5XkwBl4JPo5ZWtrSbQjYdA8iq6DaqYivCZG6ykPbzRIyeDNgHsmnZ8L1CilMNPnteel8vlo8FcpsfkA/VQ4GLkWlRG6HX+by+4TukodC1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irrhMPqVPwrh5x5VRg6r8rJ+6Opi6M71v8CmHv7AoHI=;
 b=VjIl36oYnmLW+lFtBZ+di+6CuCxLstetrYZzn55u4fMObaLJ/1JWcwxrd2Pq0DWqlA5hhLRhIkFxsA15SKo9XV90FRkE9pP7zeDHBPd/N9JJY2jfTzn24H+fz51TnmQssU4Wev6WKN5FhmrDLqsdGskH3qhjHd7oJCKr0EWPOoNrkbXPiRMYlFTG53XTomWTK+L7dwRcPyIspRQykeOdjaQcDetgiVQpPrxR2GQkI2LMwvhi8uIrWipv/PfXupK4/Aiic8eDMydauKEMZ/1LjPi7X4/3+dkLp0ijR1oG7dphc00BwZM+Qt27R2KjSBYkSFyD3WnPB4jj7CKO+obJYQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 01:10:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 01:10:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:10:15 -0400
Message-Id: <DJYQSXOEB5VS.2R7Z78M84K1L2@nvidia.com>
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for
 mm_slot_lookup/insert
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <wang.yaxin@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
 <lance.yang@linux.dev>, <usama.arif@linux.dev>, <chengming.zhou@linux.dev>,
 <qi.zheng@linux.dev>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn>
 <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
X-ClientProxiedBy: MN0P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: ac5baf75-4b13-4cca-5b50-08dee20dd46e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|56012099006|11063799006|6133799003|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	/1VYjAwaD4hYOzyIXEm8CG0aOpEqdvyZy2wZ/lSbOLHw05DEyou4GfRz1lQbD8SBwKJ9yXyvmXVGzyM0DAmnQaTwu1WKyFmmbifX10F5OErgCxneEAACT+CELOIOA98DkORw9k/ElVTZ1OLJ3Zma+NR1aY9/yJFrL3CqHt7xNAetF4iWNZFvWYMg38TsuFFJeCA1y9qpH1VoVpGyexK1lG0nCI1NPm+DJd3dzS1kJb7HvTCO4cxZUb9LfbE6WlBUdJkJvSgxJncQSX2xGgR9fzJx73qEc1UbAQjpHF74alZD16XdHkks1jTba/LQ6rfoBILhJevoQwfIe3t6U+Xp1XJrpBc7uW0nSJCAvqZzxGPEQQL3dgj5lHFlN8f9Jxb3+2nzym9mnqku73I5BS4vSwJlrnqcyARTCxR2JrLO21nkdBw/7l0LF5QgQMD+F+Em+sT7zKYniC6bzx3O529dQ1NBCwlrUvmtuOW8dmn1K9LrdXlOk1GG58tMVXCi1wv/0lrGyIwvBpOl+Hz5OhKC+wchh5582NOHIY8H/Et/UUkUMfEoDjDJYE1pU+AWE6AIVKzFNb+AStfiYXkY3LVxz7WwkLjNZgx3m8P0Ob5T/fWuSFlDEXIROVv+NM5IjGR6ySLPVIDnmbm44DpPvM5OU+ZT0ERL2Gzu7XurlthAGKYVErJp+p9ByKBDDNsmxD61zmfBn6MMVxQ6KX00i9C/dw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHNXTVV6N09ZRnNvUjNLNjlVM2ZsYnhoRjJCOEJFVlU0V210Nk9CL3N1UGln?=
 =?utf-8?B?RDhTVXhia1V6b2lFMVB0bkozditnY1pPZXpsNWs0a2lLWHZTUmFXeDVab01u?=
 =?utf-8?B?SGNiams0Uy96SHlmTERHdm5iMG1ZWFZJSGxndkRINDIrVFlqcnhkYmRMd3kz?=
 =?utf-8?B?QmhVNGloNEprNENWenA3YVV0M1ZGdTNYNDJWTFVudm1nUDZvNnRQNXFjUmlh?=
 =?utf-8?B?VVpMalB5VGxGeHJCdDQxdktRR3g0L3J5aTVVR3NydHplQmxVZ2hYZ1NnWlg2?=
 =?utf-8?B?bmFkY095WEE2a0wvTHYwa2tWSjFaZGgwWnc0SWsyNHVsREJ3STRSVHlZRGtG?=
 =?utf-8?B?WU5EcDZUUW9YaVpjOHBpUzc3ZS9meW4rdjBhcXhvYmdtUzc2NTRmQjRPUUZy?=
 =?utf-8?B?Q0VvU0xqY3pIU3Y2ejdydEtCb3lQckdTY2lmZzhMeDU5YTd0WVlHMlN0Y0xY?=
 =?utf-8?B?SExrVEdUdmpWWmhOdWdOY3A3WmhWN3JGMVhsRUZKRVgyNHBXN01RKzZoWG1Z?=
 =?utf-8?B?RXlZZVhXNjJsNGpjQnBQMmN1UlZCcWY4YjdGbTRUWHozZ1BmcWUrbFdnUDBq?=
 =?utf-8?B?NSthWHE4T0RvSEMvOC9VSFZqRWZMaENPWlcxdkNuZFhrU1lDcEtpY0dmYTFt?=
 =?utf-8?B?QWEvWlFEQ2xZcDZDRllVb3J6aEZYcStUdjVTWnJrdTcrMUNpUEZFa0dQa2Zp?=
 =?utf-8?B?MVRnWk05emVWVFN3Y2d6MHUrRGZuZHRrT1diQldKcVR5aElCTEpTNVhoTnlU?=
 =?utf-8?B?c3lOb2tmdGt5SjJXdXFWVXZyN3hJTjBDaEdpTEwyZkpDUk5vL2Fac1huQ1ZB?=
 =?utf-8?B?bnFQMmdHUWxMWEZYZlU5S2lGVG53bXdLbUxOUSszWHFzcE10YzlQUUJtYUhL?=
 =?utf-8?B?MFRHY1dsbW5TQVI2NHFGNXJ6QjA2UU13ektZWVoxbWIrb2JseXcvZUdDdnNV?=
 =?utf-8?B?V2J3ZDhMZXF3SVFLUE51WEloeWlpM0RzLzJQaXJxQVdyMll2dSt2Mk12WWph?=
 =?utf-8?B?Z011ajcrUWNIMDFyWDJrUjBleHNxUUMybkVwU1pBbjVkL1B1eCtOaW1aa2Zr?=
 =?utf-8?B?ZmJLamh0Q1BBVmp0L3ZuQlJGeGtSMHFZYUlxYUtXMk55bEZMbWJMaHRNYSsz?=
 =?utf-8?B?bXVVV0xCR3ZyT2RTMC81Sm53T0ovVFpVQWtHemRFTlFiMzlJY2NNRkV4Nzht?=
 =?utf-8?B?ekZCY2UrVEF5bkJFTklhQ3U3VjRWV21hd0pVVXo1eTA5UDJYWHh2T09GcW9L?=
 =?utf-8?B?dDBSbHRRNnJjdmhhdjViZUxmamhvRkFURFNCTjVSd2VhQzgrRHBqYkNGTnJH?=
 =?utf-8?B?VHB0VTJhQmQwQjZxbUtrNGVBejBpSlRxUzRtUkxkRGhUSDh3M2NibzFWVGpr?=
 =?utf-8?B?R0FsZENVaFhhd3NlcFdiZ1dRQkx6NlAreHRSV09Uc0VXQVBaK2c2NFBMTWxk?=
 =?utf-8?B?VXpBejRXMjUrS0JuVnpLc2c3MzBUbVR3US9TQXdHZW5HekhHeVB1dzcvU1B0?=
 =?utf-8?B?cUszNGxFZkZ5MlFDWlVMWlpJT1BzOHhmaG5hbWZpdC9lYXpwdzdDMUZSVzIx?=
 =?utf-8?B?SUVSZjY0bDAwaVY0ZXFSRXJQaFZ2N2p4V2NNY3p4Z0hraHFiUG1YZVVOS0Qy?=
 =?utf-8?B?dE03cndUcXhpSkYrVUR6L3JMUGEyQ2VpMmMwNnE3QXRCL3hjeHRCTStldkxr?=
 =?utf-8?B?WG5qbmtVS1VxY3ZkY3A3bW0vU0N0R1lsUDAvMnBUYmIwQ1VXb0xLUUNTVURh?=
 =?utf-8?B?K1Jud1VDVHZqRlh5T0pvdEFsKzliQ1c2eHlKSEM0ckw5Q2t1NVkzeVRnbHhy?=
 =?utf-8?B?ZGM3WHdVY3BZSHVUY0FJbUU5NXMrY0I2TjhYTGdndTBhSE5HY1M1c2lPTmZm?=
 =?utf-8?B?TnlpbVRwWGp4VWdXTW9GcEVlVnpSN0dSQU9qQVRoMTJTZHJYY2VlalNVbUE4?=
 =?utf-8?B?K2IvdjBmM3RZcEVhcE1YOUtWcU54enhYSGhrTVpNREZuRkMwWFlyU0dwOXEw?=
 =?utf-8?B?MkVwa3lzdzNMemlUUjJubkJNemFDQmNOSHNsRHcrSmpkblNBQ3RGQ213VW1R?=
 =?utf-8?B?NDlFNjlPWlNhSHp2aGZwN1lqWDF0YmtBL1hIczhpYUE2R050aXl2MXFiQS9R?=
 =?utf-8?B?STlrRENITHpYa2NDNlFKdUFsR3A5QlVlajQwU0FFRnVnalU2eERoL3B4RW0v?=
 =?utf-8?B?VUVZV1hGSmlvNnlrSXpFWFlLUGVRQXJPRkFNdHFnQTFVeTVoVitYNTVPdzF1?=
 =?utf-8?B?MG9kOGsvNTRZeUlnQjVTNmRQOVZTOE5IRnVCemJNVmpKRHV3WjNxaHFFZGtX?=
 =?utf-8?Q?m/7LxF18QEhe59QmHv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5baf75-4b13-4cca-5b50-08dee20dd46e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:10:16.0648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZZ8GFV1Y9KSZPYGcUkbtQGTjml64D6KEzgU1lJ4yQe0j4FV+44gGmy7U6D/wVAa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F31614000A
X-Stat-Signature: dpe3m5ieugszqphu45rza7m7mog1h383
X-HE-Tag: 1784077824-881611
X-HE-Meta: U2FsdGVkX1+/wrkL8zy/jt5irmc7q+INP1iD7aRcZU3ZxeOsJYO0qNbaHDMkEs5TZCIz+8asbPxP6ftEvWfZw+UYmfnP0+A0Dw92aBpW6RRqrEtK/GZylNLOBtNdYw+G8vqfcVI1rInECMTEKFIsGN4tuemkamCRTYZA1N2j8Hng4aGuJ8FOkfs3YNxQC4FojzGJRosbscLV6zL7qJAg+zl1Lqh/47nGmw7xJFlEYo/tYVyOU4I4it/iIoCDJaswzxQpzSB+RcdZzHgzG2/VlvOzkBXhmTj90FLvV2V/iosijpOMEyE71W+hNYr7760ubK2I8mk+8esf6yZUgjeqDmDnlXARv64CteA+in4r024QouGacVFoH+JKIBwfRzSfdspoGrnfblp1MS/ZGIl/y7qEB4NpU5ExRX6NvpvQA2e6Yui7Qm3lYrEcCR9RZ5hBsFKj+Dtu1hs3DRwrjzR1HmdNzOgSVfGiepo+ViGyDCtcLVbBoX6Vz84Ft0+SFqm954sQHLRdeiH9iANvtgijq2gxA3IZbndkgHQmzJ6VC4I89+gATjXdoEEzeBsen5sRrJ39Lo4orQiy5lAsxY4CHpmhfkEdfGrD2VBppTQXVydiCkx9cPr2cWAAHope2j1QBbqfh5j8jSkGh5/6PBfV9UYIRDAToL3jVr7eT93AB/p4hlCmt9QE51weYzseduBGJSNJbr1enBGAjquTFAGru8S5QWkd+QkeaowF4sLfZcB+fZ9nPBKKreIxRu5DBCeislh6Cn6WBl3hWj/WjbFjnJ+d/Z3LUHb5v9EMaZVbXN4DV9AWRyFe98LyIAcIocq8xWfi44fGF6/RYHWZRy4hGK0XAcLv+wJ1jI/i6O2PIoctihbA2O79MrsQhgK5H/wIAcVbqW5AyAfaXT26BRDul63pnh44qPAYZBVMW8AOEHYC0NjCBLj5BdZ+zcS0kOiUZ6sBiW8Jwjx5Uu3gG+b
 ucG7I/Kk
 yoPlB+S/jESN2gzrL/CCQJK4kcekeIU1u3uya1Y1pLyHtNJ2OcCzQNKDEcBpBc4pEZ9Xuprloh0aLwiEA6XdRJtThiD18PbYKB1hqh0zU2/fX3jMPfXgkIUF1BY4eAXAPgxDlAPdXd5qOle4e9Xg/MDyDQ/6UHh/PBl13fTOSYkiNWeP2+oYVLQakGIhVMDGLHktBgRoQjT5HTkQmS/lpzFyAanKscE16pxwZvZRpw4UiH44u/TdA1011Dbf7U4zry8EhQ5YSGUUyGQuf+2Ipr+25cLBSAOabwdW+uqnONKSkyFTAn3jEwbSwSrOk1A/RwJvmHy4Q0Ss+DMhbSc/lPaRjnWF3n+IpDyPcCcCDlJNZBPtYRemYr1KhvWEzBlyqno/VdN0hF31QHRI1xrUpUsmdn0HZzU9LZ23OuRPqQOXtkl/VeihhSv52jtD72XlfFD163sdrqZPg1LDtLc+XsAR2aAjdYRDztixQg20LYKCiohbdRqZUxh/JDzo6TTNKuqSt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 9:28 PM EDT,  wrote:
> From: xu xin <xu.xin16@zte.com.cn>
>
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
>
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/mm_slot.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


