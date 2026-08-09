Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45203C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 01:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95336B00EC; Sat,  8 Aug 2026 21:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46426B00ED; Sat,  8 Aug 2026 21:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6EA6B00EE; Sat,  8 Aug 2026 21:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C8B6B00EC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:54:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67E2F140496
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:54:25 +0000 (UTC)
X-FDA: 85080061290.25.0F3E2E0
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011057.outbound.protection.outlook.com [40.93.194.57])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B69F100007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:54:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KL0mW8sN;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786240462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YhXyBqDxDWrvB310ht7S0OViRq/08T8CCwqs6b+pUU=;
	b=JdXfTwttxkRRyb8gCzUQLORKRP0m0fmRQCKxn7Kb5wBcDz4XfnG1xUfbmomwnw/rlMvgUp
	q4QnoSUCLsPGo79XUljRHcb+FQcQQwKjqEAafdhzwREaWE5Pbm2pNbOA4um1oE33CAnNUx
	9SbUH5H5LmT+wX0uqoiAauiM2MPnFa8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786240462;
	b=RO2pki67q25EjjBPp8TtaG3via1ajZmeY39RoLprjTpJeZvo19PNVSpVNkTYY4CM8ZrOPa
	EUxCa0d5u5ZyYad+f0QHDkt6Kh7kRjEVqXDBc77fy7eFn2iJe3WouarTkXvS/JbrSvjHsu
	TeywkJgzKEHvMXZaYOcr5YZN8tlOpR4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KL0mW8sN;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPaSmdsrFRGeOgVh1vll9tVmsVLUGsmbZuDhxM+d34xf9dWgLe+XJmVZp6I57r9ylSVOoFW8elJItLXGnkvgBoSdJ1sCo0t9tDt+/xK+TIDkz4J+q7TsMAPE6Q/Ank3Gu1BsYDKaQwdt3oq3uIvSdajBd7xfjbXBKR0Vun8L0kN7HeXPwPrJJ+xopCvNXeHcOu31+W53Mmv0EFn/3e+WTS81gb2MDBhKeUmSaPz0QcSjSrxuve43wEZbAoXoHtzwg9GRmIfdIj054knJ8IoDhboFUTZZsprRQQ7E67aF59CPY4QROtoQz5PTjkzwHEe5RmHh3Or/m4rytoX0O8rQAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YhXyBqDxDWrvB310ht7S0OViRq/08T8CCwqs6b+pUU=;
 b=alvDVesjzXsfW6H26ePAVBshk6VKI6KJKnzdSxp0Bf4TRb74rqv5GrjeFAoAayKSK+ek+GG/APZpAOMiThQV+FAOg6PCWz1tyxcJFcMPY0Eg2FeuIeA5wtgSvBlAu/4txQO1mk5c04cyOQWwf9HEwAkXPcGyOjLz+GnG3yMyt7p5TqnGtpHy//ZBMIdZMpx8KQfuBajo0Iiis7rROASONjUHuIcvNovnF12HRMJYp4HAR2zruV4tieB5PGMgvAPrHvIBg4KV9WjVFnaOsNvs+8iYzQSKYjstLkbiT7fEHx64yah9QmB7yHv7KuVioEQYQU+3HVZWQ2PLpPX8S9SddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YhXyBqDxDWrvB310ht7S0OViRq/08T8CCwqs6b+pUU=;
 b=KL0mW8sNS5HHvAK87f2QictU9iSxmPtc4k2DNJu+sJMSSWcUFvx+p78XRQyphHbcKvErQhwv+4pM8Vx3Oycfa5BaVxfJ67AQvRT2ljNz/g4ovHJ3FkXOq8Zq6w6CSEqvEMyfFkRzvKYqUDNgV99LmrsX674/arlRg85INXV6iltSO2UrfOcDwH4M4JSfbqHSg+fFyJ23hJdc5BexHiKgKjuK6HU/f53SsLTfEsjydPrKn5CDv3Ck7Mew2kgWNfzxW8jYKX1s248N2qVZiikhZXUhuqm+ycOBy/Gbht8aQ1ENpgB4ZJn+9b3yoBZ5je1y7OgraJYn/UKEkJZWeZ4diw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB8315.namprd12.prod.outlook.com (2603:10b6:930:7e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 9 Aug
 2026 01:54:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 01:54:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 21:54:14 -0400
Message-Id: <DKK1E8OEGPDZ.3NO34RHQEGIRJ@nvidia.com>
Subject: Re: [PATCH RFC 05/13] mm/huge_memory: consolidate irq and locking
 for folio split
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-5-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-5-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BL1P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB8315:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c580d1-c24c-4105-8970-08def5b91e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	8s+CmetS1ghj8/O/2ztvUQU5ARFz1HfvjXcZ5Or8zUHR0rSwl+xAjLOQg9+ZWJUO/IvBmbbCeOsdBmHLbMk1Cs551aPVAqoYLdQg1Da1od2XAS+O/BIbaXm74bmbVyG0VzRmkDKQEYL/1RwW9szrHoyU71b6jVuX4Jo/tJrWVZSWqAqeSK8wq5Sgz6FtXu+mMTmdIZ95UVtKZS61OFXx7bGrpiBCMqWY76lEbGr17XTzPZOnAf679etKnZpSGrpJoWNQUGHMF6Z90jWGUoM0/rE5jip+lRLcy48hdGglcUwryjZatRezXVuLbhTwB91K+jOAT3dgeqOsxX5zrFy/BdbpKWTTAN5uLhMTSta2VEUQ4a/CWGkXYx1JyVexocubByUyZz33jeSEHOLaQIFT2Wpj3aTvDv9zsJgJaipbO/vK7a4tevk4s6VoiQRIQ736Wlm1YLhvM0VHLQ7OwrWFEQ58Q+2nuqDv5XVWgCeYM8A8LnNS4hAShUYDpdxQEs612gctSlz9+t52iWD5fNK+SMYQfaUDYzLxSDCW97FCa0jnKcxKAvu704FSAajCeSA8EQyWhhf4M+smM36fqOrIWSM9CO0Ar33OdQtuwKJM9bO6kRnO77hGXvg9jK8DtQEO5BWucFmWZho8taB3/NQKHABy6mS0uzHs27jx0rfDu30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHpwMUxoUGRmU2dPdHovRjJVRGwxdmRaMnlEWlRpQ1FYTE51eThGV0xDTkdI?=
 =?utf-8?B?WktuRXA2bE5JWk5KRzI5VVNCK01OaUlTb2FrdVlBT3BCS1ZHUUs3dlA4OTZt?=
 =?utf-8?B?cFRWcHcyb1hZQi9rSW15UEpJMStHaGI3V2Z4cnRRcFEwTVd6YytyOXg2SnF0?=
 =?utf-8?B?a2tUZ1M5SWdibFRjRGNzOG9ORnMydmpFZzh2TFl2MUdDNXhKaFluN3ZBcHJz?=
 =?utf-8?B?TmZlb01MQ3BJbXVTV25CdCtKd2c1dnRFSjZ5MU1CdEg1cFpzRlA3cjV5cy9u?=
 =?utf-8?B?VG5jMzdBbEpSU3JmRVpHUVdjanlwbnFBZmNEWkIvdjBlNVE4eEczbm5INmxm?=
 =?utf-8?B?WlhlbkNKUFlNMFhzejJONWYxVkpYeFRQZ1hSVDM1amxqRkZ6Zmg3R3JNaDdR?=
 =?utf-8?B?TEVPUUxidC9DOTEvc29NQ2NrTFpicGtXblFCWlQ0Z0h5RWEzTXZsNWlubGZZ?=
 =?utf-8?B?ZGhnb1pabW9yU21COVJvSGc4bmVnaldmci91Y0VyQnpBdmN4MjNRZ1FEWnUx?=
 =?utf-8?B?RzFBekt1eXhrb3dIdjFFb0I0aUtjOGJlekRDWDN3S2NDZzBhS2JyTUxTTzEr?=
 =?utf-8?B?M3pTZUNuK1c1RUtzM2hsOEJpS0RLb3I5Vk9OSHc2ZUloTE1pTU9XMDRtTE1L?=
 =?utf-8?B?dFNXOGxnNUNXQ1BUNmswS0htT1IxYi9seHVFdUlVZVhEczB1cllQWjJoZ3dM?=
 =?utf-8?B?eDZJTllOS3Zua21HLy8yZnpBbnpobUhCVmFOeVFQYzU1WFo2NjV6NURiYkxO?=
 =?utf-8?B?b054SmJENFN4TDYwc1JkMm4wbTF5dncrc3ZuK2JqYUpERkkwVVVMazFjRkM0?=
 =?utf-8?B?VGxYOWM3c1EwSEJoTTltbnVSdmVFTkNnT1pBOUdQNnVZZkg1RDVhbG94b0dm?=
 =?utf-8?B?NVNtc203bjlvblVNT256SzhJTXNWaVU4MU9WUDJXUjVlcThIUENLQlFEZCtG?=
 =?utf-8?B?NWdHVS9sTTVtbkFPYUxTTC9pM2J1QzlCL1AyV1hVZUNIQWV5bXh2NzZaNVll?=
 =?utf-8?B?R0tkYysrL2hNYWRYaUZjcUdOTWcxc0NKT3B5eHprQ2Jta1VJWlg3MEpUYnJM?=
 =?utf-8?B?UVN2am9BaUo1Y1FvaDZ0eG1FaUNtbzZzZy9EcGNBYzFROVJhUVJDUXpjWUp2?=
 =?utf-8?B?bDd0cVIzTGNGVVdtSHhDMlFkSEZVUkRrMzl5anpWZHdNV01VY1ZwWWhTY2xB?=
 =?utf-8?B?SHpQRnVicnh2Ymh6VTdPK0dYLzcybjU1NGlyZE1xMFNic01VRUF0SHQ4MmpY?=
 =?utf-8?B?TmZVb3pzRWdYeDBIRHM5Q3NTbU5JZHB1aWxuS3dQdmpGNW1xd2hRUGgxdkhu?=
 =?utf-8?B?RDVMY3drcmt0YmcvTFVYRjBxUEZDcDg4cjJGZVdKbmNSNkNna3BQa3ArYW5Y?=
 =?utf-8?B?dkxCYzdDbHFyb000OGxrdVpoZFN4NmloWG8rNGpDSG5hYUtKTFZLZWNGTVdS?=
 =?utf-8?B?KzBWS2o0QUdXN3I0a2E3RXNsa1hYUWlUUU1DaVM0b3hYWmFUUVVaSW9aVFZ3?=
 =?utf-8?B?VGlMN1dTZ0Z1YUNlWms3aFRJOUZZVEF5Y0IyMFpGbHpoWXRpN0xZUERCaW4z?=
 =?utf-8?B?ODNXTjZ4Z2dSVEVyUGFNU2RwaElXUGgyVGlCMzBpNWVwbWphRGdLQmt3VGZU?=
 =?utf-8?B?UjJqRWRGWHVZSlNqeGZRL2RQREpFeTBPNzgvNnJ2WXB0QXZ0SGFsdXVIM1lV?=
 =?utf-8?B?Q3ljdnRPcFJ0cFBiL1c4NzI2dW1LU1dKdGhtckdESFdBSytvRmt6MUlzL0lY?=
 =?utf-8?B?MVBsekdzcTZVbTEyZnllaWhWcEk3eCs2cHBueXpvNm4xMjhBUUJBeFNiWGtt?=
 =?utf-8?B?MzlUajU4M1NJZVhod2hMdGNQNjgwVTc4Szh0VWwzS28xdm5EMC9nZllFcTBN?=
 =?utf-8?B?Y3BJd0J0L0dCN1p5ODJXVnVseGRUblA0b1BvU3NxbVpnQjBDdWp6T2tTU1ZO?=
 =?utf-8?B?MnlBOFNzM0J0Rld5ak0wMXl3U2xCMjFSS3FFL0lSSVNqRkpxdjlzMnRTV2pX?=
 =?utf-8?B?VHdlekRWcnBIdVdNNmU3TnRGRktIcEhieDViOWc0bllVOG13MWlub2NkRFNy?=
 =?utf-8?B?WGJhSWNkclVHUjdGNlZkNWJObTlQQU5FY0NjcUUxRTM4ZG5KS29XNUNuRUU3?=
 =?utf-8?B?YXRhUEt2Q1hMdmFLelJPU2dKMm5hTW5TUVlObjEwb0QyVkVEVWxjVGx3OVpa?=
 =?utf-8?B?TXhsYVlKSU1PSk1VWFcvWURrOTR3KzJIT1l6K1ZicmtLT3RqS1R0YnZqQS93?=
 =?utf-8?B?Qm9LYmFIMUpYQi92SHdidkxoUjNnQUFtR2NMZi9tTXdRdkdsc0tMcTZNZXVO?=
 =?utf-8?Q?BUTpTNZ3MMv+EEGu7d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c580d1-c24c-4105-8970-08def5b91e63
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 01:54:16.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bpdtl1t+bctgJLkUBPgW1MaguxIusQQHo0pMjQJryNEQ7MhPh/AITyHw9NWusEj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8315
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B69F100007
X-Rspam-User: 
X-Stat-Signature: jzc78msedtb69mgoe5qshcn9tessm3jp
X-HE-Tag: 1786240462-974936
X-HE-Meta: U2FsdGVkX1+MFMPP6ftnnYeY6iPoMQAoRrfaKSRnx84O58EuWolO9HLoqaAS3hK7qSBXC8jcZHNZxY1HzgRn9hHzUfm84xcPf36NQQWzxpk8WYXJ4KQHswHUPh1vslv2k5YRNzR1vRdnZycjXlbjdANd3k5t6lApMcEe2Mw5lxoIWcmI2BXmvqbNx7YgI7cSOZoC919of5p3dkCK1rU6UcFwk6JX3rxOr6b27On6RGl81L6oCAa9nqfqONiRUwkauv4yu1JH+qFWipBk8Y7kK7nRlE9cF7YbVQmREpAuX9KOtLn7n9C6xNS7wBeDc/MieNNkdiW1YVMYkMpEcIylVnjZV4NDe0genwU73LJKiZQmXH+EE8SFOwAHfASlMpm3oYqpEs1rlsCcd08lVuw8W0tEZtL4LM6sir7hI1V0ZMZTeU5IE0fkg8t4sEaZ7uP3bLzrdSDEBcYINfX0lkW42cbnMH6jDC5FqNlx8IyXWwicQG+CIpdYtdSl2D+W8xtzpGw1f4nMV4dFXnPFkLL377HNpHf7xucvSXKyJjp3OdUEsrcrq1ElXLf2XVDRCVvVM/oTYTWz4nPeNtHRyv6tM4KAMU+w8Dkl5cXSpuU/6/dZvVCInmtAXtDxsp9MjsJhEvfanH25DcQ3dBhj5SAPZ0swU6Sm6Kkig7xbFfkXvGw5Vw6PMAmF/5zOVURZUrX5UjWtdeNXDcIzlSJC9qsP32907dmdWRrlLDfcJRivNIDrRk/MfKISBYD4pM2TqgeS0fvjwxMD6rX+9W14pvISUvsKgI4BO/mhAnNGHPDfShN5xaCK5WFJ+Ot7s466sP6cDoJFVaT8zSWYFs3egBUVzx21y14uNRkiSvGNKKYmeGx7FxhsLGz+HSj98soYQbPj+C3PdPad3DeOn/M0CLyhuhiGOfwRY2SzsPMo2tGuu9AUacQNpAgpVIgegZ4FLOlQINh779oD4Eox0eUgs4n
 HuUvMqsm
 kEtA9iPvG3AXfId4du73DKtIyh4NkPDFtDtyXtTRWWG6GQMsY3jImRX8UmoWqf2OcOWSqAcgG/9hIY9yfqy9pzwCrHGRf+u9PrrCZCjIQuM6PeNXWs4AtlxjsgqhjD0pbieabViBxdiaaiDbFumGn9p8yQ0nw/X5k2+43omfgkzy+C3fbrJi3qfy6gT3ASQddAmN6YM++PppFrB3QeSrnkrnShfd45UxNeLOWa3pwbd6IuAp5oaHvvqtHDxvJ5Aocn6eBTiGYc6kdp6JqlFNmzalYgiJd1hzrz1UDrKWBAqaS1wB8HWntr/E/lOmDHNdy5ZqP87Ef/DeOrS6XB3yYxZDaxKDHvu/klGs8faMxcpTtspWSsmupzw8YypbH4seR2bjXgjZ40hbYxAJWj5Xg0PRTtWmF4mJYKnGDzkvNRLCQn8/mIF7ZtUJvhGVC8cN5iofp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Let each split helper handle its own locking instead of relying on
> the caller, so both paths follow the same convention and __folio_split()
> can drop its local irq handling and fail label, preparing for further
> cleanup.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 52 ++++++++++++++++++++++++--------------------------=
--
>  1 file changed, 24 insertions(+), 28 deletions(-)
>

<snip>

anon part is not changed.

> @@ -4035,8 +4039,21 @@ static int __folio_freeze_split_unmapped_file(stru=
ct folio *folio, unsigned int
>  	struct lruvec *lruvec;
>  	int ret;
> =20
> -	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
> -		return -EAGAIN;
> +	xas_lock_irq(xas);

local_irq_disable() + xas_lock() is replaced by xas_lock_irq(). Are they
equivalent? Codex told me that the latter no longer prevents preemption
on RT kernel and can lengthen folio split process if it is preempted. It
is worth spell out in the commit message after you verify it.

> +
> +	/*
> +	 * Check if the folio is present in page cache.
> +	 * We assume all tail are present too, if folio is there.
> +	 */

xas_reset() is gone here. It seems to be a no-op, since xas is not
walked yet. But it is better to mention it in the commit message.

> +	if (xas_load(xas) !=3D folio) {
> +		ret =3D -EAGAIN;
> +		goto fail;
> +	}
> +
> +	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
> +		ret =3D -EAGAIN;
> +		goto fail;
> +	}
> =20
>  	if (folio_test_pmd_mappable(folio) &&
>  	    new_order < HPAGE_PMD_ORDER) {
> @@ -4107,6 +4124,8 @@ static int __folio_freeze_split_unmapped_file(struc=
t folio *folio, unsigned int
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
> =20
> +fail:
> +	xas_unlock_irq(xas);
>  	return ret;
>  }
> =20
> @@ -4246,19 +4265,7 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
> =20
>  	unmap_folio(folio);
> =20
> -	/* block interrupt reentry in xa_lock and spinlock */
> -	local_irq_disable();
> -	if (mapping) {
> -		/*
> -		 * Check if the folio is present in page cache.
> -		 * We assume all tail are present too, if folio is there.
> -		 */
> -		xas_lock(&xas);
> -		xas_reset(&xas);
> -		if (xas_load(&xas) !=3D folio) {
> -			ret =3D -EAGAIN;
> -			goto fail;
> -		}
> +	if (!is_anon) {
>  		ret =3D __folio_freeze_split_unmapped_file(folio, new_order, split_at,=
 &xas, mapping,
>  							 true, list, split_type, end,
>  							 &nr_shmem_dropped);
> @@ -4267,12 +4274,6 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  							 list, split_type);
>  	}
> =20
> -fail:
> -	if (mapping)
> -		xas_unlock(&xas);
> -
> -	local_irq_enable();
> -
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
> =20
> @@ -4355,8 +4356,6 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>   */
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  {
> -	int ret =3D 0;
> -
>  	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> @@ -4365,11 +4364,8 @@ int folio_split_unmapped(struct folio *folio, unsi=
gned int new_order)
>  	if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1)
>  		return -EAGAIN;
> =20
> -	local_irq_disable();
> -	ret =3D __folio_freeze_split_unmapped_anon(folio, new_order, &folio->pa=
ge,
> -						 false, NULL, SPLIT_TYPE_UNIFORM);
> -	local_irq_enable();
> -	return ret;
> +	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->pag=
e,
> +						  false, NULL, SPLIT_TYPE_UNIFORM);
>  }
> =20
>  /*

It is nice to see caller no longer needs to care about
local_irq_disable/enable().



--=20
Best Regards,
Yan, Zi


