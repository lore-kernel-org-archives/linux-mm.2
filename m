Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D37ECD993
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC06D6B0088; Thu,  5 Feb 2026 13:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B439F6B008A; Thu,  5 Feb 2026 13:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDFF6B0092; Thu,  5 Feb 2026 13:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8718A6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:07:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AF631A05F0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:07:52 +0000 (UTC)
X-FDA: 84411186384.16.3181A3E
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 42CAA8000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:07:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CTvmF13z;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770314869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJ8C2TPeHXAx/PEygJMzbEOpKCR3DM8YJiLEdIftz7M=;
	b=BniA1g/zJ5Jx80zn+ZdtTD8sCa2W2bRO4tDDtIrzucotcjDmpwHj8b/mUwuIoFDnepfYq3
	ouyx39eZtymUXa79IwuBEHFl+jnDtI/M6z7KzartV1XsYS5YPcSR6a/1zBZroMJowEkwcS
	DjwxrfD5M0VP3nuL09Zl1oIpS9FWCBk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CTvmF13z;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770314869; a=rsa-sha256;
	cv=pass;
	b=qM3fn9vaxAIiWZoHtBjKLdNpsHVp6u+OCeAxDcKdv1xXZQCHyh3Uf7fUFvM2X/0bCBhvn+
	j0/4gTHWcj7IKfwN3zIfzha8J5v6CI8gjnYvTRRF4vfdsVTB5T4vXepCYIosAEpWj0jgFn
	tH+H82gQvq10W1B7THWl/+TOsWz5Ytk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=giGiA95zvovOVViwRrzYPjMA2rnuBn3CcRwA9+Ed4T2OvNxwyojxxgVTTwHIFtn7OoU4cUz7mKaG+LdNCJL4qtvL5Ofg745MG/lnImYPykqpRUDTR13rMn7RezRQTvKRM/LoxeNu4Wtzrgh1CBOzVkOFlQ/TbScIa2GDUD8rxyZ3xljobdTyEXscoipK/6PGRuDqUYIxSpuAjmTI8uTX39nwaNHZpUiMy78DoyNrjTH+AMKCKM/XRHf3lZrUasKs5m2zLg7Lgxhx6eAUDyNR1ewpHU61c2AtB9mLGM8QseWH7RlYv7rHMG9KSP64sN2ikkCNxWOYFYdMAR6gPJ/JAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ8C2TPeHXAx/PEygJMzbEOpKCR3DM8YJiLEdIftz7M=;
 b=yOwm9p39oveCsPlZGuuoWn4jyiFxlQScnIOuwKmla8gzOpRCV4S5VHoXdvUifMRy9o1e2MKcxQVKHu/5XI5X5pxui6BOw+VKCB/Q+wkNUpLn9dQJXvqdcTeo5BGdgKZIC0I6IratTuUeQIXv8ZCzB74MrYistEBVUyymVyKaAs2i49e2J2EEk2YWICVl0i6giI/Cew4InrZU9ohjVlQvwRTXkO2SqHkkQAtSQJ24wK2auD0kAeL+64t2xG0uyz0MIQYfxnlEL2jgcWGl+mMQfEqEIyV3D2Tl9hLxI+6mxWf2OEcQwz5HWghG9xDvowMhGIOBp9JGLW/rLAOwaLNhZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ8C2TPeHXAx/PEygJMzbEOpKCR3DM8YJiLEdIftz7M=;
 b=CTvmF13zHnP7rKY6fc6vR1j5Wb1NdjBOeKxJnD58NBUu8w8QABFzFu6O3DXKYwj5hiGj4bTYFb6RfXyIZEikhaMWS2Yg0M/tVXsrdj5wL6s9EbZhBD0R4NJbCynj3nxabJm4rwXtuxvk0pZe/rM8XxPWI1CWdr2Ias+NVXhUGEq+qealPqVKHrI4yWkZ62d0LqyjdloOa6Yj87FQaF2+uFSTahZ8UCIDJmBogGV+C5rtgty5QASnZnWQVlPbXxGIP7Kgj8XpNdgM7i+o+Igu0b3XE/9NuxUrklZvp+HrmXeC4iXuXxNQneghaWrwI6tUTZ/xY05KrG/SRGXitn+H0Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.14; Thu, 5 Feb 2026 18:07:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 18:07:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Date: Thu, 05 Feb 2026 13:07:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FADAC452-20B9-49CB-B1AF-E1B7203B66D7@nvidia.com>
In-Reply-To: <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com>
 <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b17cb3c-850a-4d4d-efe0-08de64e17408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cngxRHhyWjBxYXVJV3NpZjVPNXJuanVucXV0RzFVYlZiYkhHWWhqOXUvelVl?=
 =?utf-8?B?NitJaUVGcTkybDQyejYrUVcxT0pBMS9iLzA0UkIvUFFMcno5WGgwN3dQY3Z2?=
 =?utf-8?B?Q1RtUDF5R3NnazlOaE5NSDl5ZXMvU1I4NWpJS1FJSHhnSm5LQnhsZkpzc21J?=
 =?utf-8?B?RjMwZGZGb2dDa0Z4RUphdzQvb3lvTlM0WUJRT09DS2oyL2g4ckJPWjlwZWVS?=
 =?utf-8?B?ZUd3NXpidm5aOGRUdlZoS1VYTGdJNmFNaVpWME1OMGxnanNtYkdnL2d4K3dH?=
 =?utf-8?B?ZDZ1eVF1eTcvWmgyNGZ0cG1HWjI5SFc4eXlsQzQxU05HOENxMGJSVktsYUFu?=
 =?utf-8?B?N3U2OXF5UmVaUW1wRjVyT0NFd2lVcFJqVmxoQzVzZVo3TUgrNmx3SlFrL3RC?=
 =?utf-8?B?RURySkoxMFlMa0VWUXJjMVlZRWxkL2d5aVh6aFhaa2tESHhSZjhVbHNwWndM?=
 =?utf-8?B?MkZIQTRPTlhHYmpnMWRXaHNSUUZobGsrT2NHRityZStMVGt2emNIbmxUbDEr?=
 =?utf-8?B?WjMyWnllVFNKaXhkRThuVGdXVG51dTlYQjFqTmdqdXNhVUYybktHcVdtbnpP?=
 =?utf-8?B?T3c4ZE1odDJRQkJlY0xKRGl3dkZRSUZGSjlNUHBacmNGZHpUZFJ3YlFaNVFD?=
 =?utf-8?B?SExOT2p4ZndpM2s3YUZad0Nad3RIbVI2WldPZXRnN3NkWHVxUFpveU5IVWJI?=
 =?utf-8?B?REpyWUJKbUx6QVZibG9TalRDdkJseW1pNlBKdmV3dmIyUkVTS1FVdVpEWlVJ?=
 =?utf-8?B?alJheHhDeUJvQ3JWbEt0NjBUaUhkV2ZGWXdCYlJNTTQyS2JwdGlpZHdyQ0NF?=
 =?utf-8?B?YjlPS0pQNy93NjlKbHNxeUxvR24yRlhFTWVQRy82MnhWTWxZVWdKVEhNN0hF?=
 =?utf-8?B?S1ZsdzBWTCs0dUJzaGJoc3U0ZTNOMDNCcWkwcUxRS3cvTHlES256Z3NYVHRY?=
 =?utf-8?B?dkhveHNnYVlPMlRnTFpvY0k1Ykc5a0lUUjhub3ljWEd6SzRrUU9jMjkyQUR0?=
 =?utf-8?B?L0VzTG4yUjFxLzJwLzJ3dmFYKzJuZ2VjMmhlRGFLWDVZWEY2OHJaaUpKS05z?=
 =?utf-8?B?QnJ4WjV1RmZNZXYrLzFPYi93dWZLQzIzOXordUNESEJScWFkZ0swMnUxK0J5?=
 =?utf-8?B?d1lqaHl4Ym9ERDRod2w1b01CT0I0Z0NKRTZ6NXVMaUk4V0VFa0QrZk4yZ0tK?=
 =?utf-8?B?d0dtaFFZMVVrd3JxSEhWZWlZam1yZnJzS2VZV3dad0Q0bStEdnNjYVNFcngv?=
 =?utf-8?B?RWRPZmJmRG45NXVaMWNXdkhRdllzbk8wMU1TenBzSGhOazdmWE8vcHJCaFFu?=
 =?utf-8?B?ZitPbnJ5b1E1YVZCSmNybmNuQkErTHM2QWJJaEFYck5scmMvUXRwTnBEckt3?=
 =?utf-8?B?ZHkzYXVoa1pYYkhNbVJBdnBGNDM3MG5LSDVSUEsvVmRWV21WSjZZVDJuSyts?=
 =?utf-8?B?WE1ySHNURTVHcHZKeVlOUXNkd0pUcEZnQWlNUjN0M2ZEZnJtWDN6ZzVQMGsr?=
 =?utf-8?B?UlZXc1NpWVlYUUU4R0hSSVVZdHZna0U5Si8veS9DTWVEb0xUZXpRVmhRM0ta?=
 =?utf-8?B?SnZVVzdYaFhTZEgreG9tV29VNTNaMW1FY1JCUEhYWDVVMTZXTHViVTNYNWMw?=
 =?utf-8?B?VlVUUjlFNWRxekQrWU5PUkhoK2R4WVFnVzNFVklpUFFRNzQ4RXhza1lBVmxQ?=
 =?utf-8?B?Uk9mZTZycVdJUVN0Um5rVnBJVUhVSU1qcWdDZllJdTFvcVJ3VWd3YWEySmxx?=
 =?utf-8?B?SW40VUpPNkREVTB1T3RORWJCR25CQ2k5eTVwb0FQRU1POWJMc0dvUGJFSnZB?=
 =?utf-8?B?WU5pRjVmdHVyVnB4cWlVTzYybWozczF5dGtZYlkzdjd2c3Q1dFlBTGFJcStF?=
 =?utf-8?B?cTZRSGNrUWljYWFMSGhkWnhnZlhQRk10aE4vakZ0RlBVR1NzVEJPV2hnOFRL?=
 =?utf-8?B?ZGg1b0k3K2RGenZWUmdjSTFBMnhYYlZqRlhtQjk0ZWR4ZXUvZUFmQkhoWThD?=
 =?utf-8?B?RVd2R3VuSlZNRHN3V2VJY0NKRmtMNlRyUGxYS01kNGJSaDYzTlN1SHNCdm9T?=
 =?utf-8?B?OWdxakUwcDJydFZ1WGZJVXRnYTlYVmphbnhhdlpKeEN6YzZPT1YrdlVsVWw1?=
 =?utf-8?Q?8gLs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmxWKytSVmRsa21oMXZFWmxLcS9DQ3A0MWlXblkxWE9OR1NmMVpLVkp1bWdX?=
 =?utf-8?B?eW9XRExHbkVqUGtwblZQR0VhNlZ3aVRGek05eE9vV3pMTEpiYk5nVS9weGk2?=
 =?utf-8?B?KzRKMk9mWDg1aVRpYmRiWW1PZkQvVGFENGtuRTFOVC93TW9HNWpacnBvbDJa?=
 =?utf-8?B?LzNMNC9Cc3RDemJyNHR5US9zRTMxbjFrcjV0b3JWOHVsLzVLM2JqczZCSmlq?=
 =?utf-8?B?Zm8xVHZlS1RZMDk4a3JmVzM3SzhmVkNKN3U1d0U4L29uZ0xPd2pGOG9LcEtH?=
 =?utf-8?B?akc0N1R3SEI3WXh2Wk9VSktOMTgyUHBMMHVWYndQaGxGZCtmbEF4R3lhWXNB?=
 =?utf-8?B?TmpXM1RlNHBEcytqTC8wUGJ0a2VhNHVtSG1mcFlmWldlTXdQdU9JRktBeS81?=
 =?utf-8?B?OGZiaDJ4WXRDeW9aczNHZXE2UzgxQXhvWG9xTUMzb1ltZitZWWFxZDIzVnE5?=
 =?utf-8?B?VmlpbEtCdXRUTUFTYmFzWmdaanpqWFJDMGc4Y1EwZGs1SEVCcEdOTW5sY3B0?=
 =?utf-8?B?M1RvcTJjd2JKSDRxZmJuSmhuSStBaW9wYk1jQnNnZS9oV3JxMEYvWlpTOWJN?=
 =?utf-8?B?bGhONGp0SXBqZzhObTNxRHRQYklaWVR2R01TZTVpQkpiK0svMlJjaE9LL2sw?=
 =?utf-8?B?NG1vNEZlbWFyWjB6MXNyVTFzRmdjRVFMQTdkQkRPS21KRlhRNVhqMjEyYUJM?=
 =?utf-8?B?NXpHb0JCV2Z1T3ZiVDZnaDFYM1grYlpnM1lZMHpKTHFuYVcyZDdUZ204cnll?=
 =?utf-8?B?dUwvcm1Da1RtYU9Velh2T1F1VU5NaFF5RnBlNU02SmxDMGhCOFNYTU1NSmJ2?=
 =?utf-8?B?dXlzcE9BVzNLYmxEQjhiYVlDQUJTUW9OL0JyQW5xbEplQUU0ZlBnYXBuNTNz?=
 =?utf-8?B?bk8yK29OOGRGVnFDb3g4dS9rYkx1TGNyLzdtYUF0cHVnVjJhSitSc09oVElZ?=
 =?utf-8?B?aWtFd3F0ZERSK21wci9XU25rVGJQVWhsdWNFQm92bjc5OWpZQUR3bTRIZ0hu?=
 =?utf-8?B?Y3JzVWVtOVZTdEZycnFmMEpNSWFLZWpJaGV5UHkzTFg4WlJRc1h2TXJZa2lr?=
 =?utf-8?B?VDlCM3lRZnE1SlFtQlpnY01neXk1cWMrYW5vRGVlZnpKejJwYXFUL2VVRjdh?=
 =?utf-8?B?Yk1TczhVR2Z2aVpFWWlDek81Mk0rVmM2d2lyQmQ2QXdBRW9hcjNvZjdvd1Zi?=
 =?utf-8?B?NlE0Y3crRnZkZFF5aTBiME1adGJWdkRtRjZKZVBEM3k0amhWWEdZenV1SExH?=
 =?utf-8?B?bHZ5U2x6My82TXFhN3N3VWk1emRsNUcwb3V3VlR1cDVjNFpMSGNoeEFTTUk5?=
 =?utf-8?B?a0gxK0J1SWFna1hGMDVjQnEwaStDeWhINXZsaVY2MFVCZEcvOVhESHJpZmZi?=
 =?utf-8?B?YmZXVTVRMjUrSHE1VzFjTS9VdXd2UThqZ01ROHpjckc1VXl4VnY2Y2I2NjQ3?=
 =?utf-8?B?b2gxVUJITXJnaHpnTlRnZmNUWnFMSTE0OHhkcGViOE1GNGdmWWJiOU10Ujl3?=
 =?utf-8?B?aVJDSTUzNWNqZmx3V0ZPRzMzeHFKQThwZmpXaU8rTDJhVURuRnlRdEtLVVhl?=
 =?utf-8?B?dCtTNkw3OS85QisvMDFGbDhrMXZBM3Z1dU9JMGRIMTRIVFhYRE5hSXdZSTRm?=
 =?utf-8?B?WkV5Wk1ZVWJ0QWRuQzg1MEVFVERsbkFOTEZ2cEtQWmQwa0UrRDE3cDYrN1hx?=
 =?utf-8?B?U1hPTzNzTE5ZOXNGc2NhOWk0c0xRM2NyUXdveUU1OE04ekMwR24xb3k0L3cr?=
 =?utf-8?B?VStPYkI0VTVPOHdWSVVyeUxucVBTb3dwUVlncmZUUjBVUjZRNVNTQld4czN3?=
 =?utf-8?B?NWUrbjVaNXZ0ZWJiQ2VNS2lqQTVIY2toU0RZeXFSM25lZmU2MldwUnU2UWsw?=
 =?utf-8?B?OHRYSTU0dFhwTE95NnVhVkVpaDgxams5b0lHbnR2N0N5ZmFQVXRxYnFIajVp?=
 =?utf-8?B?dUduTDlhMnRIN0FUSHoxbjF2ZXRGL2x0VmRvSkw3V2V0Z2pTVnJEOHNNZko1?=
 =?utf-8?B?ZUFxSzNKNTdnWlp6SlVSUXpsREc1ZG9rZ2luNzZxWG1DRXVIV2E0QS84ckpx?=
 =?utf-8?B?Nm1hQmV2YkQxVHhJa2s2TXl1NTZyeC9icjlnOEtUbFUvUE90UGRaZm00QjV6?=
 =?utf-8?B?bHdJN2FuZFhkQ0cxQ0x4R1VpbFJwNkhWSkJLWnYzcGF6N1N3NUloQXh1QWVE?=
 =?utf-8?B?bUdrY0RBRHJ1NnZqdGVoZXR1c2ZwSnl4d2VkTCtqNm9aVXo4ZEEvUlpSQ0dI?=
 =?utf-8?B?Q0FHdUZqb0dqMDZLYURzYkg3TFZRcGx5TW82aDhPQVdvaGtoRFQ1L3prUzNG?=
 =?utf-8?B?Rm14TVRjbDBtREtza09WQWVLeGNXNWl5U2tQK3k0VlF0SW5TM0xGdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b17cb3c-850a-4d4d-efe0-08de64e17408
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 18:07:41.1669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6SUGYOo7hHqe7N6kquc2ngwDrTFhOBUlc513/yYNTJpUfVNS3zFkq9Nu3ljv14g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958
X-Stat-Signature: i5bnd5s6m6r5atnwemzmgfiimokr8yb4
X-Rspamd-Queue-Id: 42CAA8000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770314869-79915
X-HE-Meta: U2FsdGVkX18TfIjoOzGpRgjV1usK/RKS6SoKdJDDclV95D4wmRfuVf0IHI4K0C0TKNQeG80KRjFE+vrDNIspQDAeq0EKFkhu6Ydsz92YfCy6nOoezXvK71Fo0YmpYhOqSO+zR+S04zs0AdJfFI8oO8bNccG++QdRRgc24QlXEtywo+JCXN1nL6bSUYJxm1Ri36iQs6+cvYrKxoJl1y7X34iFN4l0W/n8DuNBJk5adNyF94ijFNgArlny9/zPx8xddKuwfMQGzngSKqlLDycIhJ6iX4tiWiehP39LU4DVzN5iG5CqAc604yK063UJgDWyEnqOzxmN0mGI0S4WrEnBnJRhiEss4byXUbvZE7o64NZjuk8DEFwPCIVPNymShVRZdeanXNF5Lcb/vwT+8x9BuPJvm6D224WJpN+S5KP9oz3iLdQPSmFJWx38jeqXEgBMb1EfsiH8SrI5vYgtBkuxijtlC1FeZ1hMet1Zgn9kgkBj2BLIgYBAtgVRvwnWFW6aEcoPmsrxbzzS17lYVTG3rsFVbIU1LcQfptm7AvKlXXRysa9o41Yeqa1arDgmG9G7gPh0Ff+7WsYAqZG/vwSTmjDWhjf1Q+E0JW/JletrBW034+qPG6wd/ChPmIZ0mw8zbFE5aYhKB/Wzw8CA2hPdbUhdaomRcGW/tk9M36gtXDj/Me93IMr9hgu7mxJ7T6vfGlno2E+nMrJRU9dpyUsjw5nVF3zfuW5VSjHkZ/Or8YFtCeYl6zCsTmMuNo6pxCvlQfycZXR293rzDAXB7xoM61bprGCU59KJJlpG+sfCYYmFLrBivJVcB2fvtp3ed0UtOKZE85kcWKazuSOprGnfJev/825M59df3/m1ozjM2H5zRnTcZa2OvtFoVL+7a1fnJYJyxNsIy705vJ+k9jPuHHMEFFUYyYQ4zK9jd9JhIrZdFIKtiPoLssu06NJQzS1/aI3xo74U9EFb/3Zhh8W
 Nnv9iPcY
 YtSWfZ7IabY+2EEuw1ZfbZ/jWefzjMwmlfyeH+0eOW9MB9nSp+gNCAETvdgFHDIqx6vVPDfkGADCFVwd6epSf2TgrEgEiAS6cAfL9s2xm/bsT3vOLhK9YuNixvmFVAm5JKac7KZL8PxUobAZZp/0nLYM2o80UwlaC92QcIrI+/Zx/z84CbXM0aJ08uhOTWecEu4bkk+xhE42AGMKHfpcqliXuCzQ968W8Lz5T06yXV4OOuDi+/EXe4UVNuT9rAMrYVxWPIk7DT+km5+hNNvIpX3Mowpk7/kDLHh5A2PCqDxUC/zhunMjb8sjwAxqHaCf8QrUwxgVHSnECKeE2lOKX1g1UsaIFaoKEaRqHhsuxKs07gTj33/uJnlfLhuc4800h4Cw4SGn/mZc98Pq3U1iTeyo/gHgZZQ+bIKA/cufPkW0Oe1mGSRzOHVWF2pZXXwQFMpJ+8oF4jG+ucNBww16BYn3AHy3nq+OfoRTnPXSesNDsFk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Feb 2026, at 18:29, Usama Arif wrote:

> On 02/02/2026 08:24, Zi Yan wrote:
>> On 1 Feb 2026, at 19:50, Usama Arif wrote:
>>
>>> This is an RFC series to implement 1GB PUD-level THPs, allowing
>>> applications to benefit from reduced TLB pressure without requiring
>>> hugetlbfs. The patches are based on top of
>>> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
>>
>> It is nice to see you are working on 1GB THP.
>>
>>>
>>> Motivation: Why 1GB THP over hugetlbfs?
>>> =======================================
>>>
>>> While hugetlbfs provides 1GB huge pages today, it has significant limitations
>>> that make it unsuitable for many workloads:
>>>
>>> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
>>>    or runtime, taking memory away. This requires capacity planning,
>>>    administrative overhead, and makes workload orchastration much much more
>>>    complex, especially colocating with workloads that don't use hugetlbfs.
>>
>> But you are using CMA, the same allocation mechanism as hugetlb_cma. What
>> is the difference?
>>
>
> So we dont really need to use CMA. CMA can help a lot ofcourse, but we dont *need* it.
> For e.g. I can run the very simple case [1] of trying to get 1G pages in the upstream
> kernel without CMA on my server and it works. The server has been up for more than a week
> (so pretty fragmented), is running a bunch of stuff in the background, uses 0 CMA memory,
> and I tried to get 20x1G pages on it and it worked.
> It uses folio_alloc_gigantic, which is exactly what this series uses:
>
> $ uptime -p
> up 1 week, 3 days, 5 hours, 7 minutes
> $ cat /proc/meminfo | grep -i cma
> CmaTotal:              0 kB
> CmaFree:               0 kB
> $ echo 20 | sudo tee /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 20
> $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 20
> $ free -h
>                total        used        free      shared  buff/cache   available
> Mem:           1.0Ti       142Gi       292Gi       143Mi       583Gi       868Gi
> Swap:          129Gi       3.5Gi       126Gi
> $ ./map_1g_hugepages
> Mapping 20 x 1GB huge pages (20 GB total)
> Mapped at 0x7f43c0000000
> Touched page 0 at 0x7f43c0000000
> Touched page 1 at 0x7f4400000000
> Touched page 2 at 0x7f4440000000
> Touched page 3 at 0x7f4480000000
> Touched page 4 at 0x7f44c0000000
> Touched page 5 at 0x7f4500000000
> Touched page 6 at 0x7f4540000000
> Touched page 7 at 0x7f4580000000
> Touched page 8 at 0x7f45c0000000
> Touched page 9 at 0x7f4600000000
> Touched page 10 at 0x7f4640000000
> Touched page 11 at 0x7f4680000000
> Touched page 12 at 0x7f46c0000000
> Touched page 13 at 0x7f4700000000
> Touched page 14 at 0x7f4740000000
> Touched page 15 at 0x7f4780000000
> Touched page 16 at 0x7f47c0000000
> Touched page 17 at 0x7f4800000000
> Touched page 18 at 0x7f4840000000
> Touched page 19 at 0x7f4880000000
> Unmapped successfully
>

OK, I see the subtle difference among CMA, hugetlb_cma, alloc_contig_pages(),
although CMA and hugetlb_cma use alloc_contig_pages() behind the scenes:

1. CMA and hugetlb_cma reserves some amount of memory at boot as MIGRATE_CMA
and only CMA allocations are allowed. It is a carveout.

2. alloc_contig_pages() without CMA needs to look for a contiguous physical
range without any unmovable page or pinned movable pages, so that the allocation
can succeeds.

Your example is quite optimistic, since the free memory is much bigger than
the requested 1GB pages, 292GB vs 20GB. Unless the worst scenario, where
each 1GB of the free memory has 1 unmovable pages, happens, alloc_contig_pages()
will succeed. But does it represent the product environment, where free memory
is scarce? And in that case, how long does alloc_contig_pages() take to get
1GB memory? Is that delay tolerable?

This discussion all comes back to
“should we have a dedicated source for 1GB folio?” Yu Zhao’s TAO[1] was
interesting, since it has a dedicated zone for large folios and split is
replaced by migrating after-split folios to a different zone. But how to
adjust that dedicated zone size is still not determined. Lots of ideas,
but no conclusion yet.

[1] https://lwn.net/Articles/964097/

>
>
>
>>>
>>> 4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
>>>    rather than falling back to smaller pages. This makes it fragile under
>>>    memory pressure.
>>
>> True.
>>
>>>
>>> 4. No Splitting: hugetlbfs pages cannot be split when only partial access
>>>    is needed, leading to memory waste and preventing partial reclaim.
>>
>> Since you have PUD THP implementation, have you run any workload on it?
>> How often you see a PUD THP split?
>>
>
> Ah so running non upstream kernels in production is a bit more difficult
> (and also risky). I was trying to use the 512M experiment on arm as a comparison,
> although I know its not the same thing with PAGE_SIZE and pageblock order.
>
> I can try some other upstream benchmarks if it helps? Although will need to find
> ones that create VMA > 1G.

I think getting split stats from ARM 512MB PMD THP can give some clue about
1GB THP, since the THP sizes are similar (yeah, base page to THP size ratios
are 32x different but the gap between base page size and THP size is still
much bigger than 4KB vs 2MB).

>
>> Oh, you actually ran 512MB THP on ARM64 (I saw it below), do you have
>> any split stats to show the necessity of THP split?
>>
>>>
>>> 5. Memory Accounting: hugetlbfs memory is accounted separately and cannot
>>>    be easily shared with regular memory pools.
>>
>> True.
>>
>>>
>>> PUD THP solves these limitations by integrating 1GB pages into the existing
>>> THP infrastructure.
>>
>> The main advantage of PUD THP over hugetlb is that it can be split and mapped
>> at sub-folio level. Do you have any data to support the necessity of them?
>> I wonder if it would be easier to just support 1GB folio in core-mm first
>> and we can add 1GB THP split and sub-folio mapping later. With that, we
>> can move hugetlb users to 1GB folio.
>>
>
> I would say its not the main advantage? But its definitely one of them.
> The 2 main areas where split would be helpful is munmap partial
> range and reclaim (MADV_PAGEOUT). For e.g. jemalloc/tcmalloc can now start
> taking advantge of 1G pages. My knowledge is not that great when it comes
> to memory allocators, but I believe they track for how long certain areas
> have been cold and can trigger reclaim as an example. Then split will be useful.
> Having memory allocators use hugetlb is probably going to be a no?

To take advantage of 1GB pages, memory allocators would want to keep that
whole GB mapped by PUD, otherwise TLB wise there is no difference from
using 2MB pages, right? I guess memory allocators would want to promote
a set of stable memory objects to 1GB and demote them from 1GB if any
is gone (promote by migrating them into a 1GB folio, demote by migrating
them out of a 1GB folio) and this can avoid split.

>
>
>> BTW, without split support, you can apply HVO to 1GB folio to save memory.
>> That is a disadvantage of PUD THP. Have you taken that into consideration?
>> Basically, switching from hugetlb to PUD THP, you will lose memory due
>> to vmemmap usage.
>>
>
> Yeah so HVO saves 16M per 1G, and the page depost mechanism adds ~2M as per 1G.
> We have HVO enabled in the meta fleet. I think we should not only think of PUD THP
> as a replacement for hugetlb, but to also enable further usescases where hugetlb
> would not be feasible.
>
> Ater the basic infrastructure for 1G is there, we can work on optimizing, I think
> there would be a a lot of interesting work we can do. HVO for 1G THP would be one
> of them?

HVO would prevent folio split, right? Since most of struct pages are mapped
to the same memory area. You will need to allocate more memory, 16MB, to split
1GB. That further decreases the motivation of splitting 1GB.

>
>>>
>>> Performance Results
>>> ===================
>>>
>>> Benchmark results of these patches on Intel Xeon Platinum 8321HC:
>>>
>>> Test: True Random Memory Access [1] test of 4GB memory region with pointer
>>> chasing workload (4M random pointer dereferences through memory):
>>>
>>> | Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
>>> |-------------------|---------------|---------------|--------------|
>>> | Memory access     | 88 ms         | 134 ms        | 34% faster   |
>>> | Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |
>>>
>>> Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :)).
>>> For long-running workloads this will be a one-off cost, and the 34%
>>> improvement in access latency provides significant benefit.
>>>
>>> ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
>>> bound workload running on a large number of ARM servers (256G). I enabled
>>> the 512M THP settings to always for a 100 servers in production (didn't
>>> really have high expectations :)). The average memory used for the workload
>>> increased from 217G to 233G. The amount of memory backed by 512M pages was
>>> 68G! The dTLB misses went down by 26% and the PID multiplier increased input
>>> by 5.9% (This is a very significant improvment in workload performance).
>>> A significant number of these THPs were faulted in at application start when
>>> were present across different VMAs. Ofcourse getting these 512M pages is
>>> easier on ARM due to bigger PAGE_SIZE and pageblock order.
>>>
>>> I am hoping that these patches for 1G THP can be used to provide similar
>>> benefits for x86. I expect workloads to fault them in at start time when there
>>> is plenty of free memory available.
>>>
>>>
>>> Previous attempt by Zi Yan
>>> ==========================
>>>
>>> Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
>>> significant changes in kernel since then, including folio conversion, mTHP
>>> framework, ptdesc, rmap changes, etc. I found it easier to use the current PMD
>>> code as reference for making 1G PUD THP work. I am hoping Zi can provide
>>> guidance on these patches!
>>
>> I am more than happy to help you. :)
>>
>
> Thanks!!!
>
>>>
>>> Major Design Decisions
>>> ======================
>>>
>>> 1. No shared 1G zero page: The memory cost would be quite significant!
>>>
>>> 2. Page Table Pre-deposit Strategy
>>>    PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
>>>    page tables (one for each potential PMD entry after split).
>>>    We allocate a PMD page table and use its pmd_huge_pte list to store
>>>    the deposited PTE tables. This ensures split operations don't fail due
>>>    to page table allocation failures (at the cost of 2M per PUD THP)
>>>
>>> 3. Split to Base Pages
>>>    When a PUD THP must be split (COW, partial unmap, mprotect), we split
>>>    directly to base pages (262,144 PTEs). The ideal thing would be to split
>>>    to 2M pages and then to 4K pages if needed. However, this would require
>>>    significant rmap and mapcount tracking changes.
>>>
>>> 4. COW and fork handling via split
>>>    Copy-on-write and fork for PUD THP triggers a split to base pages, then
>>>    uses existing PTE-level COW infrastructure. Getting another 1G region is
>>>    hard and could fail. If only a 4K is written, copying 1G is a waste.
>>>    Probably this should only be done on CoW and not fork?
>>>
>>> 5. Migration via split
>>>    Split PUD to PTEs and migrate individual pages. It is going to be difficult
>>>    to find a 1G continguous memory to migrate to. Maybe its better to not
>>>    allow migration of PUDs at all? I am more tempted to not allow migration,
>>>    but have kept splitting in this RFC.
>>
>> Without migration, PUD THP loses its flexibility and transparency. But with
>> its 1GB size, I also wonder what the purpose of PUD THP migration can be.
>> It does not create memory fragmentation, since it is the largest folio size
>> we have and contiguous. NUMA balancing 1GB THP seems too much work.
>
> Yeah this is exactly what I was thinking as well. It is going to be expensive
> and difficult to migrate 1G pages, and I am not sure if what we get out of it
> is worth it? I kept the splitting code in this RFC as I wanted to show that
> its possible to split and migrate and the rejecting migration code is a lot easier.

Got it. Maybe reframing this patchset as 1GB folio support without split or
migration is better?

>
>>
>> BTW, I posted many questions, but that does not mean I object the patchset.
>> I just want to understand your use case better, reduce unnecessary
>> code changes, and hopefully get it upstreamed this time. :)
>>
>> Thank you for the work.
>>
>
> Ah no this is awesome! Thanks for the questions! Its basically the discussion I
> wanted to start with the RFC.
>
>
> [1] https://gist.github.com/uarif1/35dcd63f9d76048b07eb5c16ace85991


Best Regards,
Yan, Zi

