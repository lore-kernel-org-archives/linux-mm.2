Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF19CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAF96B0010; Fri,  5 Sep 2025 13:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABD66B0011; Fri,  5 Sep 2025 13:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C4A6B0012; Fri,  5 Sep 2025 13:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D00F6B0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:56:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E471D8D97
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:56:04 +0000 (UTC)
X-FDA: 83855950248.24.4C0BA2A
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55578140006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:56:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XMZVH6gN;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sAT1MkQhxmaWoh5XM3aNqdHqkTWbLM+p3hq6AJi0Tc=;
	b=sk7B1WwWb/nT1FveNOWtCOyXywX+k+DsiU2Z4Hrjy4lJ/0G57JIKj62DtDrk+0Ql23aU9t
	StEiJ0QSW12OVYVDJUdzPDgr1kVRlBnxKElrNZld7c7cDbcWOIE9kS/mZg5QXdCq8rzcaa
	t9O5GQVCjF1BQMMAC1JNfNZ4aBY4n28=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XMZVH6gN;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757094961; a=rsa-sha256;
	cv=pass;
	b=UdAM+mB/vfYkdJyUmemKzZpo8CQ848+BIIs2NBu5lfVip+WXlI9FyVAM2T7FNZTm8U3xXh
	6pkE89gjy7QCf0Dnv/l0CBze9GngRMjahcubljXXBaLEG3ynfDpq4NynY3xabCFa4hUM6S
	XOrX1nPFetVQtKVFjGSbF+3YABk6egw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vg+GTX3dgqSIB/8JieDxvlbeQCgL8b3sJFKlCSQ79sMEwu7ixidku6nc/MhFT/byYQyYT612dX+kWrg8qpKd3s6mq/vjrDuNAICkwBLSivT4YucfiVUGTzBF47TUnQ8KYxgLwui9pHBXbyISI69b47/EAiyK6Sc0MlcwNfn1ek3o5mJc0CaYCDkr67Z9VBvUZYKkL0Vi8Crrcxu/Jpb7vDBrqz14GLDZc/R2qkWh7czhNF6YEFq4PQCok0y2kGSe2TfmtvhlItaP+0BLZm54Z1O5dSftR9LLlqmVmSSvlOmYG5neuDSnTWZl+OvG3MNIgev5+Kdg5EkbbN29lrYy9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sAT1MkQhxmaWoh5XM3aNqdHqkTWbLM+p3hq6AJi0Tc=;
 b=gdekvFS10RxH3QTxT59c/JWQC25VLtw1NoYEHDT8TDeeGWuf74D7eNRIH+RPOIu9x0LF2/2BeJc3uVQnyzDuwei5NUZ8EX5VHMg4uuwdD8QxdxQ/a2MCblSfajriTiIqDr1NUBNcFJgxpBZdK87co6mkTI7zjFwWnyiTDEp6CUIEKUuGIkDSzv4tqAkBlkXZZ+4eNNVnIoo1ln+wXxDKZPjWKFKebAb76D7cy78hrLk6jTjVaGGBjoNZA2rNfbFwwgsqASLvJOwi5yepE6noVVI2J7n2xn46wJ8/gvztiRcKmd2uVbn6F0b5ayXSMM/VJ812jRE8yfe7iL4xqclZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sAT1MkQhxmaWoh5XM3aNqdHqkTWbLM+p3hq6AJi0Tc=;
 b=XMZVH6gNQdBsJgD6KlnrOdP7KgyNH75pj8wF6pJIGOOEfpdOTkPT7w8N4GCXGrCGYDosHh91zS59WIWckQCdhrdJxBfCMNAyqB2WPtHNXWmMbnPhMtk/SDTU1FpzusveJGFgClcMMjUbrsj3X2DMwo2y8oVJ+uu95Vpnif6oFG/N9Xom++pJ6skGdZ+gACDnTHUjoi8eawHi5qsbBraKd1GS6B+l9FtQAv7vFEbQ/v0L15bTk4OtWL47KCS+J3tKanqDowoBPxshQQ2p6GCnabsoU9yGTOcrxOk/bE8u57i+2FIdklpsW9LV1MfDS1QeX9P3JLopvGHhR8E8z5QRDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB9067.namprd12.prod.outlook.com (2603:10b6:510:1f5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.18; Fri, 5 Sep 2025 17:55:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 17:55:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mark Brown <broonie@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Date: Fri, 05 Sep 2025 13:55:53 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
In-Reply-To: <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0568.namprd03.prod.outlook.com
 (2603:10b6:408:138::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB9067:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d9efb9-96ec-450b-9914-08ddeca576e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWV1V1Z3VVlGVW9yOVdOVEdPd2NSaWFyMCtIODI0WFlwcm5Lc3BaUmVNdGM2?=
 =?utf-8?B?RTA5VjN0cTdTK1p3TlVKVmVXaWRld1A5cnE0aDV2N011ZW1wMStWdDhCeW5M?=
 =?utf-8?B?MlhnZEtnWk1VRlpXdzcyeitvQkRFQlNUcGlxOHRJb1VFbU1hdVdWUTAwRTBn?=
 =?utf-8?B?ckpYWjN4cDU2b2VocGJhZ1BFcVhTWFBWZWY3VDNCdWlGaTRvSERlZ0dreGZy?=
 =?utf-8?B?OHBqQVl5dUhNTWcrK2h1M3VyMGJTeno1RFdvVVNjVTljQzRaeFJ6OU1RaDdt?=
 =?utf-8?B?SitSdWkzVDJYWHJVaWJmTGhQSHM3MURzNU45dEdJZFlkUXg5UzcvK0JUZXNB?=
 =?utf-8?B?L0x6NlU3dGFPSHpHQWxrcjBxbFQrT2pNa0JTMy9yTk1UdWljT1NMOTJMdmt5?=
 =?utf-8?B?b2xubk9veE93SmF6Zmc2YXVMWUNTQXpQTGN5Vm5paXl2RjJVaGJxUWVvQWt6?=
 =?utf-8?B?N2lSaG9wOXk0cWVVWTNkVkNsVkFLNXJ1VHM4dGlQaHkvOGU2TkhFYTdZWnI5?=
 =?utf-8?B?a3BWcng1VDdCS1JQaXV3NHZ4OXJDM3hGMlpQT1dyTDVQZGRaeUZmVVkzNXFn?=
 =?utf-8?B?ZzdxOXNXYSsxaXM2YUtsRitZYlpMMTliMEszWFF6TDlMcUtqc1RMQ3dxd0VH?=
 =?utf-8?B?WjVlWUZzOHdkQTA0eFRPNmhIS2dkd2VDM29oSnpBMkcxblNkaHFIM3dKaXcr?=
 =?utf-8?B?S00xT0FKMytmK0dkeWVKcXJ1N3VLZjE2Z3hFYnVJYXBnWWh5Y0FPeFpINXB0?=
 =?utf-8?B?NE1PMkx3cktqdnZJdE1jV0thdFlSbW9rMnNuTnBYN0ZqRVRCSm1lS0ZxcitC?=
 =?utf-8?B?blBjeHgwR3FRYXhPZXFZRXlyZi9FN2VvdDYxYUUwZWRKMzRVeE1pVVVtMUds?=
 =?utf-8?B?OVc5T2hTQUtSa2kzRno5VmdGTXlybk1KNjBoeWUrOUY3YWprQ0NnMkZqRUNp?=
 =?utf-8?B?MWE4RTVURkluU3gxVzk0UW83U0ZCeTZJY2lkUUVjNXpSaFVnNmpiNmUxOE9t?=
 =?utf-8?B?ZUdJN1Y1d3JaK1N0TlAvbFlkYTVFVGlrYWhYaXFhTmFBQjVtaEkwSHhEWFJz?=
 =?utf-8?B?OFpOdGp1ajNYaGk2QXFTcU8yTnBrQXZBUWxTQzZYcWVQV2NTcWNlQ3NnSW1r?=
 =?utf-8?B?Z2VuSDFhSlVvSktCbE9zZkJYbFJ2dmdZRktBd0drdW01MWtWbmVyU2VzVVFB?=
 =?utf-8?B?c1ZGbHRBWWpOUUVEdUFLQnhES0ZUOGVxL0JZeHlvbWJwNE81aEFJZFZGU2hQ?=
 =?utf-8?B?eVhwdkFVdG5vUDdEZkJhZmdqbVlSU3craTkrMjIrZ1J0VDE0MzNPK2xwbHdj?=
 =?utf-8?B?U1BaNTErbkpXSGRuMmVtSFpPeU1NT0E4L0ZSbE1NSHR4ZmhFRGFGdCtvMldS?=
 =?utf-8?B?NnlveTlZelVuQ3UrTUFtWm5OZWcrTnAyRURVcTVPZnI5WUxsRktGb3F6WHF5?=
 =?utf-8?B?N2NRS2RFb2poV1pZUUFBSENBZGxNNXkxa0pzY05xNnFsdFJiTUc2VnloamZ4?=
 =?utf-8?B?MUdoMTRpZUxORzBtYXczL3ZubFRvQXBBSkduTGRPVzMvU3ZPT0NrNC9iQWph?=
 =?utf-8?B?QkpSRVVySEV6Tm90bkhPNnhFVXdGaXhVYUgxeWdKWmNReWZGNHc4ZmpFbTJo?=
 =?utf-8?B?S1A4bzE1SUl6SGMzbGRWcDc5Zit2VWdVYnV5K2JpeEpRMnZaa0lCTmRzNVlm?=
 =?utf-8?B?SndjOEZnc2N4MmJ2VUFyTVZYZVVjSVRkOHdyYy96b3hSTkR5bmNCYktXdnMz?=
 =?utf-8?B?eFdmY2VxZ0JNUEFqQTd5YUs5TVJwUWJmd1A2VlFkai9KTXVkVVR2U21IU1RF?=
 =?utf-8?B?YzlyT1d4cnJFb1B3bHRzUnEzS1hFVFA1M2NnT0dXT1ZZR0NaOEJMZ2I0SE9Y?=
 =?utf-8?B?cHFscnplaFV1cGpsOEdjYzBZQXc0azZIUmtnOTlaNXI1cVhPS1h3b0R2bjVz?=
 =?utf-8?Q?j7Wz5p+bgzw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnRsd0dYeFdDd3Q5eXFzQS81WU1XMmZBc3huK01ZSVVvTGNSMzk4eG9DaFky?=
 =?utf-8?B?Q3ZHeFh4SXJ1UG1CZEUxakJjYUQ0RmRCUXd0UzFOSG9KQUxIQ3ZwL2FvWmR2?=
 =?utf-8?B?UlptK3NKYTdvV1Y4REpCRXdMY1NFQ0lobFRBVEovRWxBWWFmVEJXOXN0emZL?=
 =?utf-8?B?U3RrZ3BMaEY1eGNLOVpobkQwaTV4dE9BL2E0YmJsMHZaYjFtcmk3M1RrMTZz?=
 =?utf-8?B?Yi9sT0JIVi90cE1mWW14WVpUSnZ5NWFZbm5zZGt2S08yd1RPVWlJWXpTM0Mr?=
 =?utf-8?B?eXBGSEptL2phOGI2NGwwb3N1WVdPZVJDdVZmRVZ0bmZ4QUNmK1JDZ3U2N2t6?=
 =?utf-8?B?TCtkREpWdDBOY0k3T0o5WXR1c0djdEpEMHNhZUpMRW0vd2hWNHN1RGVzbmIy?=
 =?utf-8?B?bSt6L0tCVWNLbFFsWTdNbndWVitlemMzdVJSdWhES1Z5N3hHZWxySVBENHBW?=
 =?utf-8?B?YloxZyt5Tmd5ZEJkVTFaY2JVUG9ZeWdRc0hHTjhYVlpRaGhOdW0vK0Z4NSt5?=
 =?utf-8?B?dDhaZ2hYakNPeklzdU5aZ0JSVzVUb3BZN2JaL2VxMTB6RXo5UjNyVGNaZHFk?=
 =?utf-8?B?MzBQZU9oQVRsc29DbGNaQ0h4czJDQXV2M3RnL3ZxdDA1Q1gvNlAySEhXMHVv?=
 =?utf-8?B?d2VITmtuY2Y5Mk03RjNGK3VYS25LY29OT1MxN2RVUk9YNnVJdDN0bWFrZm90?=
 =?utf-8?B?cE9XQzcreVFBeGZUcWx6RmVXQ0VLbzkrQjV2RXp6ditqN2dvdi9BQWVXVVdX?=
 =?utf-8?B?QjB0RHJRNUFhWlhIMzM5cmlSNHR3dzVsczZlbDIwUWtrOTd3eDl3dDdMS2NP?=
 =?utf-8?B?SmZjN2RnM0plUi9tc1I1cjk1Z2I2d1dPaUl4QjFGL1Q5SnJQWXUwanlEZXpi?=
 =?utf-8?B?MGprTjN5SXd6bjdXWnptM1FQM2xWMnFsbW1BZElUQzMxMHBzVTByNlA0alNy?=
 =?utf-8?B?Q04yUklnd2RzNWZLMm0wVEh0cTZNeERFaXZMVWVVWklRK3B2dlI4RStRdHor?=
 =?utf-8?B?aHBlNEVhc1pNU0NvbE5iSGR4NXFZVm9iUnRvRTEwaHU3SklaSEJGT1lzUXNP?=
 =?utf-8?B?aW1udDl0Yk9rNXlQM0dEQXBRRjBlVVlUOTBCN0hNd3FFN2E1RUZ3VkwxcnYv?=
 =?utf-8?B?V3Juekw4WTJIRkxsdE9sOElEMXZGNXJpRWRSUEdKZ2ZhYWp1TEFRb1I4U2k1?=
 =?utf-8?B?T3lsKzhPcExqU0ZzTmxDNlRPenlxN0JSck16VjFnZUtZdXJNeEZBUjBuQWNs?=
 =?utf-8?B?QmFVb2xNaUtFMllxcXAzUFdUdnJnVGhoUlpsRE9nSWg5dHhTc3hzOGZWcmRV?=
 =?utf-8?B?cXZmRGNpeUEyK3ZaQmMwYlhWTWNQV09zTUJOaDlWaW84U2w3azJBQTVhZXNr?=
 =?utf-8?B?K2Uvd2dOaVhmb29UL3dOUEtvZHBrVXFWZktvVXNWUUU1R1FDRk4rSEZQR1Nn?=
 =?utf-8?B?b2REa2RXMWlnWjJPNWVjQnpRMDBkbG85TGxBb1JUWDZJendWL3pmaVdtMEtK?=
 =?utf-8?B?Q1JGd3JLRG5EV3R0RFRJdnE0Z25hMCtIWFdOYmtaWDdlUEFNa3J0SGlKa2FI?=
 =?utf-8?B?UVZPb0dhOGpmbUVtN3V3di90RW40eEI2QlViQWpkVEh1dit5ejRHR2hZa2tx?=
 =?utf-8?B?cjlQYWZqZXZiWGIyTno5OUJtYnZvN2pzYzJUQ2ZUdzRuSGh5bmpsS21PVDZI?=
 =?utf-8?B?Zk9wY2ZMcFhzaElvMzNhY2ZqdHhBNWhCUm8rNTUzYXM2TlIzbWxWWXlsbFpT?=
 =?utf-8?B?NVN0ZnQzVjJnN25xZjFVN2piVXJZT3RYS3dNQnJyaUorT01rMmVlMTE5cVho?=
 =?utf-8?B?RWw1TWUwYmpnNGlySEc4TlFYaFBtNWtCZDc1d0cxUFA2WC81dEk2SENCcHZh?=
 =?utf-8?B?VTB1cld2N1J4aWlDVWNVbEtGNTUrd3dJRVRlZ1AyQVJFbnpJWlJkU1VZZi9J?=
 =?utf-8?B?TU5OV2E1OHd3T29JS3ZyazhmR0Z3TlZtbjFPeDdZazNKOWxVelBIa0dZRWxC?=
 =?utf-8?B?U0I1N0g0R1V3cTcwTlp4cEJxZW5TZ2ZuNEFVUnNHcTdVdUNTc01NUVdjc2dN?=
 =?utf-8?B?Q3p0OCtzZzA0L0oybDZtM09TbkhXYnI5ODlTYlQxLzJLbm5XZlZEbDRSTXZt?=
 =?utf-8?Q?jduq45Retm2M8SZsGoSh9ZrCQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d9efb9-96ec-450b-9914-08ddeca576e9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 17:55:56.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5ruhRABC+nd6KzphcVO7/Gp3Uik9MsaBdLvxitfzcKb/9KkT481PyuV2W55KO8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9067
X-Rspamd-Queue-Id: 55578140006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: h3f78576nsj7nxhg51op8k3aufysdwad
X-HE-Tag: 1757094961-312084
X-HE-Meta: U2FsdGVkX18Fj+Cx4JMWo1GoZm/2tjEBQ8zOfZtPI8add02wyH7I4ZR6zT+OgclbLgz6r/BQXxwT4yD8Gu9ZTTs6OMkxAMM4j/9Om1phP+/tLkZ8yZx5Ig1+sz4t/c9/1AgxZ2ZRbNyoDC6dZY+mwyU1VRJasHi7u2jJl3b3MBiSmXk8ZG4LHauQG/9C8bCj+zWfyh8W0gsf00QUrzA/ttT0R5d/cC7Pa8deO41FDFo+LUBxwAUbtx7r9YmO23us57IpT1yOyyV5yrS4UJVZBgHHvY5rGemqjSnyUs4HZGfbEFQK2+ncNntshtFThabvBXEdglxmXDZlT15Go3UVgWnQVX7EQtXOmndahh6LwrZNTCnma81pQ2Yrot49KvhVr7DwYn30kUVuX8iQ+fXH1sPqJQuMUIjdQZFgA8L8QYxIXn1OKPjRyK4j3sxWCYGYhCTBTspqrDndAlsvyTs6eoGGR00G6StVwBOXOnNKKL+if9389wV6904SBWdY2wfigLfvK6Amr84cbuGUSyoyS8MetzlXs0LDT0PI7JwkMpSjw0ctA8WWbd0pKAFAvGAXXRvAJSG2vZ7ftSgJkU/0lUsAUYCDDIwFB01XRmqD6wedfxR9nBEPIeR16KClf2KYrdc+/XxSStMz8ZH0oxkvM0uL19slgIxp9EV7qkOcVpriTR73+/sd/912NT9yOjTWw53ODmNDNNWHSRECOc9Y9yNDpx16Sl0bf2vpwYzvicmERShH5BsKSxtGeWwBi4GL8hG1iktGmFTMZRYP1Cq4WocWy93kuen42A+9ulPBvu/bBrv4CR9fle7oQKdB5xEy7g8xY9QSAuNKNL5DSjM6x59gHT+iQX2ATGCcLnxUACSds+T95HTYoovaq7C7G/9Cek66Z2KZqgSXJ67HZv0nm+AJyZB4gchZuvGSQjQPaSeBBvmImaaIJp1i+g2IcdFMgCRRB9+YkQLxQHbFzoS
 bfRmljcp
 XrC0qOJHps4lbnDYBvBkm3wE8hVN9ojKvl3cUCwdu/023X1OBFdOVtkj1txDxn4lvfPaKlDB7bVV3VIEI7h7ym4EqpDRGiB7IiWdJYsETK7L3O2PEYREGmKsvyLVFcsu0i/0KUAt+Lgv4ex9YlBYlUo3Ao4Jncl/eZb/NI9+8xpCRn7HPds0/VPpBnyng4rW20mCNzRZGRoeDfcvNSaptkC3bPJDdl+Jusn4TRpJCDoOIT9Z+uuMhWtd7oWeDmdtzKxXeY4js5lbHiDjY8qU4ItI1d9eAkE2tW258/Z+mg4uUeqfYJ5Y02a9du/0okNpxhJaZRvIIFQ5EkfJmKOZhouvTPkVyhBIQkdbFwcmTfM5h4yKZ7pGkTyfCrM8Dr+yeGAuUnwNJMepYeoYVDO38AgpR7ZOJMMRS0LAkUMjEy96xSgz1LhFQ38L58U+E57SpUoZGgQmvL3VJ8md3pJMNWOphKzf6W5JemL8wizESyiX7hty7eG3hnh9ZBi0Kt22LPXCoAoICSDVs4cYzPEg+fWDjiY4W4NFGMmhe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Sep 2025, at 13:43, Mark Brown wrote:

> On Fri, Aug 15, 2025 at 02:54:58PM +0100, Usama Arif wrote:
>> The test will set the global system THP setting to never, madvise
>> or always depending on the fixture variant and the 2M setting to
>> inherit before it starts (and reset to original at teardown).
>> The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
>> be made to disable all THPs and skip if it fails.
>
> I don't think this is an issue in this patch but with it we're seeing
> build failures in -next on arm64 with:
>
>   make KBUILD_BUILD_USER=3DKernelCI FORMAT=3D.xz ARCH=3Darm64 HOSTCC=3Dgc=
c CROSS_COMPILE=3Daarch64-linux-gnu- CROSS_COMPILE_COMPAT=3Darm-linux-gnuea=
bihf- CC=3D"ccache aarch64-linux-gnu-gcc" O=3D/tmp/kci/linux/build -C/tmp/k=
ci/linux -j98 kselftest-gen_tar
>
>   ...
>
>     CC       prctl_thp_disable
>   prctl_thp_disable.c: In function =E2=80=98test_mmap_thp=E2=80=99:
>   prctl_thp_disable.c:64:39: error: =E2=80=98MADV_COLLAPSE=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98MADV_COLD=E2=80=
=99?
>      64 |                 madvise(mem, pmdsize, MADV_COLLAPSE);
>         |                                       ^~~~~~~~~~~~~
>         |                                       MADV_COLD
>
> since the headers_install copy of asm-generic/mman-common.h doesn't
> appear to being picked up with the above build invocation (most others
> are fine).  I'm not clear why, it looks like an appropriate -isystem
> ends up getting passed to the compiler:
>
>   aarch64-linux-gnu-gcc -Wall -O2 -I /linux/tools/testing/selftests/../..=
/..  -isystem /tmp/kci/linux/build/usr/include -isystem /linux/tools/testin=
g/selftests/../../../tools/include/uapi -U_FORTIFY_SOURCE -D_GNU_SOURCE=3D =
    prctl_thp_disable.c vm_util.c thp_settings.c -lrt -lpthread -lm -o /tmp=
/kci/linux/build/kselftest/mm/prctl_thp_disable
>
> but the header there is getting ignored AFAICT.  Probably the problem is
> fairly obvious and I'm just being slow - I'm not quite 100% at the
> minute.

prctl_thp_disable.c uses =E2=80=9C#include <sys/mman.h>=E2=80=9D but asm-ge=
neric/mman-common.h
is included in asm/mman.h. And sys/mman.h gets MADV_COLLAPSE from
bits/mman-linux.h. Maybe that is why?

>
> Thanks to Aishwarya for confirming which patch triggered the issue.


Best Regards,
Yan, Zi

