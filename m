Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F22E78D74
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5AD6B0088; Mon,  9 Feb 2026 11:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62A16B008C; Mon,  9 Feb 2026 11:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3AB06B0092; Mon,  9 Feb 2026 11:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD3B6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:05:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 567E689AC1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:05:22 +0000 (UTC)
X-FDA: 84425392884.27.2E502F4
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6DDE5100019
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:05:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jfqCWTqG;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770653119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goknZNa9e331RFxOZKR+9E3nZroBfElXv2tp4peZXxw=;
	b=mvpJ/kEGBYQUbOcI/nCTK1NUo8Z5Pn0M6f8HCagWCSicB3WNtPER7MtXpn3yLnZ75DDhaS
	fzYiB1hmRiCELkh5QOVZZZ+Ym+t54+U9QNinbmX+j2etxztgBnKCZoGVoGGGyhhAeE24/e
	RV1eElje8U91lZhSfpHK3i+dbClELag=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jfqCWTqG;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770653119; a=rsa-sha256;
	cv=pass;
	b=Uxo3Rh507BHC74kdKD7CCVsmh7j/jJ1tkIyuDkPLqlu1/byYHXHF9JfdI2gxl1Nff4Hmla
	rl9P8OOQIQHzuYutPHhVKtTo8deWc68+dCKJBF/fg2u2/Oq7Atu3DBxAtpzaF69V6A2RoG
	26efQY2VYzfCD/szxOtos8mxRj/Fz8A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGwXvk9Jj94Wyn69xPprHdM4hj+rtT1qd0W490KtOXPUKK5amyiRv9Lo0Oaxd4g4khFh3qaxzB7zYGfa+96wU8SubKqCDPQuSWDB1GD6L4UP4AX3OnH9AabHp/gXtzhyxIfNclZdy5J1dSkibf1YZ6W0GX443KPeiPDETbGxdQoRtWCMr0R7kIXVHuzX/466tNg5Q2WQGxWDtznJXW0yu7WyImecfdPbbM3GSz3nsRJXR2/uYBy0HZ27+LqZZNwiqBv0u2ENpJqmEgq6NqFIbT6omzzPupJXF2kAsYlHYbjkt9Dm7cjJ4LUKsA+dR9Z8iD4eJcpGNwKq5JXO8r50jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goknZNa9e331RFxOZKR+9E3nZroBfElXv2tp4peZXxw=;
 b=julJzzuYmJ1ldAXZRY1blO62NGuqU2cIt7OuyMGoTiDgf+7Zxwdozt5MwWgrm5XHUvOnyTpJWaeK2KP4VBKna5pKBWauKa9JiIn5AyeDQ8MRFMiJMUhP4prg7ZZxD14rKYerlouOcC4BiOy9jlwq1/gTIcWzD9xSZ1GMjGPxiTieOZB/zhzfnQgcfTsf+DF011FXiJyXgJsI0hVEaugDt2aXNSFLl610ml47zlA8/x5Wp2RGb416zZFQmTYXwgskgryU+NgzSTLt3pzP9vKgdcRORWqTS8KgbvJ10V2wOLAgMQKhJQ16r1IFmwcYJEzBxm0tUhlzIXIh+T9FsFgzPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goknZNa9e331RFxOZKR+9E3nZroBfElXv2tp4peZXxw=;
 b=jfqCWTqGAieT6J//BANyRCVJ895QuU2uvjkx4G/z76cMhkO83H9PJQNZ2w8+zCqVwDLYRyiNToEATTLNEVKZFGPpXZeD4GIkB/H6blSdWRAfU/Uez11xH3fLXDzwG/tKbN39p0Jtbpaui4eQQly/fJLiX5d60bBYYHpjYOai3h7iJqyLqgzLIoaHh020pNcD6emdvR3/PH8QYyum/C36IM1Uoriv/EI/L/qTps/+hUAlo/TwquwWYtEgRcL4USIlWjQDrTGsZq0GrXtejoCWEueZRTjSq0iBGtzAHAGtsl4J1lz6rD7mSw184OG4G46mKzePkXeITWPFvFlcnTCasw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB8101.namprd12.prod.outlook.com (2603:10b6:806:321::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.18; Mon, 9 Feb 2026 16:05:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 16:05:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Mon, 09 Feb 2026 11:05:09 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <CD2D5EFD-53FC-4E0B-B7B8-023495867C65@nvidia.com>
In-Reply-To: <42b977d1-4873-4b3e-9107-7055836cde11@kernel.org>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
 <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
 <c0b93b3f-bc4f-42f6-8287-72d015a0a79b@kernel.org>
 <FD637A2F-909C-4039-BEE2-B60F85FEC7E8@nvidia.com>
 <42b977d1-4873-4b3e-9107-7055836cde11@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 12621295-f05c-4aee-37c7-08de67f50273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUsvUVRneG52SVhSekFpODQ1SGdwajlYM0phTjJkcEVLMWdFaVowN3pFVEt2?=
 =?utf-8?B?Sml0L1JRa2dDN2RESXdmV2Uwa0Z1NjN4S2g5QmdrV0Urd2Z0UlZEUWxaOU1v?=
 =?utf-8?B?TVdjd3k4SVhubWtZSDl4QThoRmNUOEdtSVNEeXozTTljZithL0l6dHltdkRB?=
 =?utf-8?B?SlNpeEM1cEdCd0RYL2Y1c3F6aUs4VEFhM2puRCsvbjRYSGszZlh0dDZ6T3RZ?=
 =?utf-8?B?YnJIc20weFdDZFVqTEk3c2M3THFWUVRWU3RIT0RNSlRYbVJRRExsMVh2Nnd3?=
 =?utf-8?B?SVNXV0ZqVjFvZjh0Um1yS0dPcmVsRFE4emlvb1JqR1VOVVd2cEkzdmUxYTlh?=
 =?utf-8?B?ME1CWVMwRmlEZVhmQnI3S1FIamlFR2pheW5lL0pmVmtldjBUTnBLM0tsWDd2?=
 =?utf-8?B?WVpHMTNzSDBOdTJ0TG5DeXAvNnVOVVpNZjd6SXJ2VDlZQlprUEZmZ3ZCblNq?=
 =?utf-8?B?OUZIOExVbFcwRlhJaHpjNmdOb1FhUkpXS3ZnUU5IdktwcGo3eUNkMXlmTWor?=
 =?utf-8?B?V2VVdVJuMkkyRkxHT3Z3bWF6WVViNHhFSk42amplajFvQmh2NGtTc2xWdStC?=
 =?utf-8?B?WXZRbjJVVFZwV2p5QkpvMk5ZU3FIZDROSGpIYjFCY3gzMkZlK0NuSGdvV28y?=
 =?utf-8?B?ZjZnR2tXbnA4RFp2dklIKzhRbXdscnl3QmVhTzRkTlJkR1Q2RFZOVzNsRGZ4?=
 =?utf-8?B?a29vQk1kNm5UenBFRnVFTnRBOHpTNlV6TVdkajJ6VUZ6ZFMyK3ZYQW5LK1VI?=
 =?utf-8?B?eDJCVjFHajJXUEhZNGg3TmpjUFhOejBiTW1TKyt4R2h2cHFMcmt6TnpyNng1?=
 =?utf-8?B?YmRhdkVmYmpEcXZHajQvRiswbGtMM3B5d3A1OXJLZmE1Q1hWVG5ld29xQXZx?=
 =?utf-8?B?dENwTUY1d04xMEE1L0hEcDNvUnA4Q2d5VzRjNXM1SFZFV0hzSUd4YVdHdjZv?=
 =?utf-8?B?U2NCbVJQUE83d1FVdElMNytROFY4MmR3dmY5ZFBMOXNvS2thTFk0dk1yU1Mr?=
 =?utf-8?B?Sk5hZ1FxblIwd0ZiaWZVMjRVNUFTS1Q5b1EwRnhad0JIUEMvYTA3TmpaVlhJ?=
 =?utf-8?B?NWl2aThaVWJkVE5UajkyRURpanNSRGxQZTY4ZTIvSlZFRDZMaU1YckxHWDI4?=
 =?utf-8?B?U2hTY1J3V1k1WXBBSGQ4MzlUVTNaKzRlVCtMUWZPbVh6N2F3L2l3dS9XNm1U?=
 =?utf-8?B?YWlGR0JVcjRpNzVpUndLM3YzbEJFajlQZ0djTWNNV0VqMG12UU1MSkpXK1hQ?=
 =?utf-8?B?K1RHdE9VR08xZ2M3dmxVaUt0ZG1maW9UWE5KcnhvR0t4Z1MwV29NMy9BZzd2?=
 =?utf-8?B?QWVnNkNlM2U3Z01lYkFCTE1WVi9naTBwOFJER0U5dGVuRkJ2aDhDR2VsSldo?=
 =?utf-8?B?WDAxOHZ1S0JQL0sydk9nK3NDMDFsV2NjTmxpdnlXMjNsbjRTVzBnQ0dsTXpp?=
 =?utf-8?B?eWdrTkFtcjgwbk9iM21aTDYxVlYrSUNNYk1UWEJGc0hKMXJJajNZZ1d2bUNE?=
 =?utf-8?B?M1RuRU9uZEFGZHVhVDhWazJhZWF3L3dsd1A1TVVDOEZJOUR1Rk5pQjlnZ0tW?=
 =?utf-8?B?djdWdWIvOFp2eEtrREs2Wk5DUDlLdzA3eTdRRmZtd1ZOMVBJYjFQRkVhMGFv?=
 =?utf-8?B?eDBIS3dmWUY5dEJxVEZoM3BSRElEbDA1WkpMK0dxUTV5eWFqb3Vwb25UeHhQ?=
 =?utf-8?B?b1dDK0tXNFpuNktkZTFYT1liZFQ0Ylp3MUVvTTZIclZCR0tUT0FRMGZreHdw?=
 =?utf-8?B?VEJ4YnpXUFRSSzFEalpIU1JsTjk4S2I1bms0QktxV2J1VjdwbE1MQmhCOGYw?=
 =?utf-8?B?bWFtajYwUzA5enR5SW9RKzBqK2pBWjBWTFp0dklwYTkwZlh4K3ZmMVRaVG9X?=
 =?utf-8?B?dWMvRGVubW9QOEZYaUZmUStTUzNMTnorOWxWN1RXdm5XenJJdHE4clpjU2Rj?=
 =?utf-8?B?bm1xK2p5OFpjZkFldUcycFhySGJWNTVhZXljcC9OZXY5NGJteGxpeUtlbXpC?=
 =?utf-8?B?cnVoZ3J2SEFpYTMzMlNHcENFQ09SWG5xYjg2SmJmUit6cm9TS1JMTlJjZXpr?=
 =?utf-8?B?L1RNbDNHUFBaZ1YvcHVLM0xOdituU25GQzRuYWxIdHdjRW1KZmNpQzE2Rmds?=
 =?utf-8?Q?crNM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVo5SjZaZndBVVU1N2xsd2s0ckRDbWRlUU5yMFBSZUdlV01qVkpkcmFsZ210?=
 =?utf-8?B?V2YzY3hVR1lHM2wxNVh3QXVMaXVaTmpPZVo0L2pIcUhWVm00VkZiOFFqL0ZM?=
 =?utf-8?B?dkxGd2pwUjRTQkc1a3lvQ0haT3llN0d2M1V1elJHNDRjWWQ1LzNHUllXTTlK?=
 =?utf-8?B?bmJJWmZ0Y3h2YnptNDc4MmNmcHcvZDBPb3BtejhKTXpBai9tYlZYNHJSMThl?=
 =?utf-8?B?S3lNL0hXQ3Bzdm9aQ25NSHhjNVd1elpUYm5JVmIxWHMwNGZYUDhIVm9GUnIw?=
 =?utf-8?B?UnBwRkZ1d0VtQmV2dFU5bFRwWW1ZZ3NubU01cEFtdVprYUxBNkFRVVNTbnNh?=
 =?utf-8?B?dkZMdXNGWExUc1RZMGY0cm1Tc3RhSlJ1RzArWVJ5blNHU1drRlhTOVhOWXlz?=
 =?utf-8?B?ejVCSmU2Tml1cUZKOVVJMnBqeUR0T3pXdFhwbk40bUdZczdiTXFxcVF0YTlp?=
 =?utf-8?B?WlVwMUx0MmJPWW5KWmdyWDJkVHJ3M0ZzWU5Ld2NxYi9ZTGY2NFNIWUlHUTI5?=
 =?utf-8?B?Q1ZIbHAxczNXazZSU0xnY3NMbEloS210YjkyYm9QOHRxRXlQQW1Sc00vREs4?=
 =?utf-8?B?QmwvRllIdmUxbTh0WFM2cEdQK0pyTUVocnY3OHZGaGpNa01Tck1wV2FaWkJ1?=
 =?utf-8?B?VCtUdVVsaHpkNTVJeG44c3pMR0VlYk9TQUNQanp4TytqY3VSLzl4cDZrNktH?=
 =?utf-8?B?L3M4azNLM2VYNUs1MVUydGlOb2xxMzJOQmt6dWhvMGp3T1k0VnFPeDcwK3ZF?=
 =?utf-8?B?TVIwek5QbzdBZExMVHZIWmtxRE54ZmI5VXZ5Vy8zTGkzdEczeFFFaGFibXBE?=
 =?utf-8?B?YzlnM01FaHYrRXRNakluc3Bqc0NDYXBCVWpwb3NERHA2Z2hzdmpuOTRRNXd2?=
 =?utf-8?B?cFdjcm5COGJ3dFdMeVFVZDBWVVlKQnowVTQ4ak4ycjNDV0RyR1lZdVFLUE10?=
 =?utf-8?B?Tkdtb01mNlFrRUNPY3Y3V3JpalM4U20rQXQyTDUyU3N2Ri9iYXlVVFRBU0l6?=
 =?utf-8?B?L0RJL1p6T21CUHROZWhob0grSm5NbHF4TFd5MTMyWXZ3SE1BckNxcE5YS3Nj?=
 =?utf-8?B?RHBxWENIeHZHVlNtUlBrdEVSUzJ1UHpQUzRwNHhrVkFZZGR0VjBqNHJLbUpl?=
 =?utf-8?B?UTdxU3VOcEl1OEhCTUpueldOeW96TGt6UFcvbHVOWXBIdFhESDlvNlFpR1FL?=
 =?utf-8?B?bnZJejkyWnYwdWMwZ2lMaW1sRjZTWUJzV2NnOUFaUTVUeU9PUGt3ZUZ1REh0?=
 =?utf-8?B?bHJwUytHUEIrbzJkQkZjc3I0OFY2QmIyQnpBWHJwWmUzZy9YV1U0MFRROWpG?=
 =?utf-8?B?V3VhVnhpMVhvSDVjMU5oZXlLYkVDQnN1WlJoZkxxN25NYnRCYitsQTRUdWRk?=
 =?utf-8?B?NEkrdzlqVlU4WE9YVWI2TmVzMEU2aERRdnBLUkNxNkY3eS9TMklYN3ZNemxy?=
 =?utf-8?B?eEJzVUF3aFhZbm41OStxTDBvUHNORVZkbHA4K2kxR0JFdlpPcDZoQU0xT3VS?=
 =?utf-8?B?SnMxVWFxRXRhc3F5QTFCMW5hZ0FYaFlmSmU5Uk4wMW0reTFNR3FGaHQ4TTls?=
 =?utf-8?B?OUR5OUx6UzZJRlNJS1dnT3BwaDNMVmhGTmtYdDBtaG15dE1hOFgrMTB1Nkxr?=
 =?utf-8?B?SkpDWUtNc3lzdVRLUWhqTzFuaUJCblB2OXRLdllQaHhNa2NrNkY3T29MQXI0?=
 =?utf-8?B?WExBako2WC8wUFZFalhOeCttMHBRR2NXOStwSE5nQytIUWFNRXVySG95VzZI?=
 =?utf-8?B?ZkpKZXRZcTJvb3dDVjE4cG1zY1Z6NWIzd0Y2Rko3Zlk3T2VPblF5NU5jc1Za?=
 =?utf-8?B?TnhmbDVVdUg3dmF2TUhMOEoxTStHeGU2R2UyV1ZXYVJBbEZiUDRKY0tvM1VQ?=
 =?utf-8?B?NW1tN09SVTF4RFBtcU1qMForb3FIb2NRellKRlk2cE9mQzd6ZFRSeGVEYWdH?=
 =?utf-8?B?VVRlYXlmNjQwd0E1emk4NWZpUVZ4VU1GazFndDRsbGFXZ2pWTmpNZXUwU0dM?=
 =?utf-8?B?L2doNWV5RTUrOUllQkU5RU5ZUFZHVnBramtwcnRaa0VMQUFuUWEvRXJBdFYw?=
 =?utf-8?B?SmtjWjk1djVoQmJSODZVeGMvd3FkWlA2UDVLYUFsdzI3WUZiYTNHeElDQzV6?=
 =?utf-8?B?QlFYM3ZDUWJONUx1L0VYTHJLVHp4Q2JEQVpHd3QxQTdQL1pMTFhjMFNPNXJh?=
 =?utf-8?B?SGZ5Y05UZkwrSEt2Z2o5a0IwZUd6WmpLVWdrazZaNmRaeGFyZDFpMnZYKzd0?=
 =?utf-8?B?SjRGbHB6VGhWMXYwR3VxSkg4eVdXd3pZM3F0dVBmczhtOFdrd2JqenY4cjR0?=
 =?utf-8?B?ekhEZklXaG45NFJtank4Q0picVorSXplWnN1c3JOWURXZldOekZjZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12621295-f05c-4aee-37c7-08de67f50273
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 16:05:14.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoJ8CaJhJTvrnV4LdcHFcWZcMKlhsgpBJ5SIHV5QeUiW8pU9ERxZh0lvYxGlYVlW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8101
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DDE5100019
X-Rspamd-Server: rspam07
X-Stat-Signature: udkwm8gyf9ewwjczmpz3q4ozekrgbzzh
X-HE-Tag: 1770653119-789538
X-HE-Meta: U2FsdGVkX1+Yl24k+JGm0Ckp/yXBAjVbG8nJXwBjQapkFrL8bv/1UTKawUENfTD/iWIP+TRWJm1gPslesWn2ZjEM15llAM3PUseNB79MXhhgMmWyAVZ9b9oocQPYJ6XxOYjEnYM6p1YkHSJCL354FK427dw673KQWS73OK6vvg5I01bNyBeTwrUw5gIPTHOY2MzuE5JO4uxBxLZr7cPqzEfhcmNZsk25ujaswoMnI0OjFHoBRQmkx8hb039rqTPBicDn8gcywVX4T9zqgIHX3QjGxs3oLjI4jH4Du5eIY5jfXRFBXKyPbBnqn3acU0b0G6VfJJnEdlMDMw+QUmEwq7CAHm9XpUiV1RTBsJQOkeJBHCMCX/2u7Ep72fyKMHkOF4kpWXNs99eWjxQC7FPwORZ1HyDkUlrjCfN0aLaNbs1VrRGduEZHQonuKbEGx/wz8WkLseBEduMjg2ETZJx+X5vFvrb9wj17lINVJphlIVYnLpTu6nxL95jCNmWhPrZpwmMI8Az67hg0zUr1l9le4IJbMU10oITHYISMrFR6l+RZrmWX7vIbcqqzsu+3HnmghllEmssNtv8ukJY/O58+mpgkbFcsI5ha2t43ky8YkOeh8dlLJRKFQPLiQRLt3N19c6v19y5mYQ77hP9k6PdMaCig5+HYmAaTDsq4Vlr6S6+AwOlgTiqlSYAT/mqUW2CQgpeFZXmYODR2rTNt5qdZKDPckZIbmv6cn60Yec45ElIqJeF1dTj4rcCvR6GM7Wv85vb3iHmDh0DQ1sbsJfUA0XmIHb5pdujQn7vTTeh0ZoXwf+zBhnrHEOaisTKFQ50UjpGJ/fq9MDk9kfh/kyjedLw870xjuN8FmfJ2n7SCGNAyR/K6mZy1Ys4KTmmCHjoJkBBzz5K9redmr3mBqvr1PHFs5UToDPwQVv7yRoM2KwpgUX+9Cxv/FmTs6t1Ci+nh+pwhCSkf0ct3pwxOt36
 vvihPG+j
 H5x8h01LVi7wIvqfPlDzjstETW81wupGXtAzLsZeaebhoRsdECIrCGdrOC7ga7qcPXAj690G+SqJ/IRK57QZGeoFmpNft0ABaVgO3ONxvl9sXVgNcXGC1WuoxzSs1+PQlkThH2ONaU+fkUDaEpkJsl5dp1oUj3N4oZ4beAjFS8dXYMiXLBglYDVqs9DeKpr/1yidgwABZm47DC2AJ3YYAlT19EUh8QKXZv+Bql6q2vqV4qpwytQll+jTZDezrSNxGY/dfbQYWIop24hIcYsSWEZMK+iWmZ2ICsYYw0eEvinnY4DFnm6eVyWSwwY2HFKOETBdrnkS0dxaCWMpn/fjZ2hH9dqU+b1kiamwcyvlvyDVMZZyyuch7K5Rvi948jkw1gnHxVIREI/L4imRfIce5tzcCoWMiUkAmDKOEgokkUvjNKK+6SDkuZlVUmny9RVzUtOmn/DzamuB0/GXfIgHaWht/BBHyJuPpm3ZpO4iCYlCCbIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 11:03, David Hildenbrand (Arm) wrote:

> On 2/9/26 17:00, Zi Yan wrote:
>> On 9 Feb 2026, at 10:46, David Hildenbrand (Arm) wrote:
>>
>>> On 2/9/26 12:17, Vlastimil Babka wrote:
>>>>
>>>> If the rule is now that when upon freeing in free_pages_prepare() we c=
lear
>>>> private in the head page and not tail pages (where we expect the owner=
 of
>>>> the page to do it), maybe that check for tail pages should be done in =
the
>>>> is_check_pages_enabled() part of free_pages_prepare().
>>>>
>>>> Or should the check be also in the split path because somebody can set=
 a
>>>> tail private between allocation and split? (and not just inherit it fr=
om a
>>>> previous allocation that didn't clear it?).
>>>
>>> We ran into that check in the past, when folio->X overlayed page->priva=
te in a tail, and would actually have to be zeroed out.
>>
>> Currently, _mm_id (_mm_ids) overlaps with page->private. At split time,
>> it should be MM_ID_DUMMY (0), so page->private should be 0 all time.
>
> Yes, it's designed like that; because that check here caught it during de=
velopment :)
>
>>
>>>
>>> So it should be part of this splitting code I think.
>>
>> It is still better to have the check and fix in place. Why do we want to
>> skip device private folio?
>
> I don't understand the question, can you elaborate?

You said,
=E2=80=9CBTW, I wonder whether we should bring that check back for non-devi=
ce folios.=E2=80=9D

I thought you know why device folio needs to keep ->private not cleared dur=
ing
split.


> I asked Balbir why the check was dropped in the first place.


Best Regards,
Yan, Zi

