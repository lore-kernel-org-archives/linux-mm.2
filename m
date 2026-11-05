Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3488606EE95
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h6nLtHmV
Received: by kanga.kvack.org (Postfix)
	id DAA1E6B05B4; Thu,  5 Nov 2026 10:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59C86B05B5; Thu,  5 Nov 2026 10:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20E56B05B6; Thu,  5 Nov 2026 10:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1976B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:19:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C84C4140A48
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:19:54 +0000 (UTC)
X-FDA: 85401425508.06.758CD59
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012020.outbound.protection.outlook.com [52.101.53.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AE54A000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:19:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h6nLtHmV;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su5MhqTGKgTrL6fTV2UJPNNex9wVkIWEa9Ke3XPLe0w=;
	b=ua73h8G0ELKyfdDxR4P5fZoAxEdfpyByp2HOcIeBadmLYlP/iUcFE9UFRNl82V6vmGgC06
	PzF2K3NufY/sHLzWoIEkeSWMkXRHQb/LztIpmy+rly5j5D5qYhWs9gN910zYfJgshNngmg
	e9JRx/6QzahrKP6el8QV8+XSKLEqeaA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h6nLtHmV;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793891992;
	b=S6v9nm8j5SmOn4uUuRtQL1wAJB4NjIF6J4BfRJD1tPAWOsukuqJsBnYMOGArzJl00tr2Wp
	xJ6w0sgB4N3q9wy70GK18pXT4rXPXpAWIcDYdKoQqJ4iYfbEsnbdYy0WDcn88pLAa8FOHL
	VXLp3b1r1OHaNGf1IskiiZtHcVGoXPU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uidAdbDxyNWxavNKiFEKDcT7lkN4JSZYBaNs0/5TDguJl3jWzP5ey936K7svLD+0zjTgHfJjpZB9LCdh8xRH/9GWD4u8ALCvKApAyPcJ2L2pGnE6fHvF/8xcHzTTGf3BwuVyzRRRPSTE0p81SyoQYdlAkuP8sSsaCOh+Bz+huXO8IwOj1pXfwqArBBiTg3Y4p3TxEWs5nhxjpNGHC5WlxW6Bx9xQn3Jhk66cAbCj3ghU5qAt3xS7WI/FlwwSnHql9PLolwbtcfDGIf3OvxIQwXpoi8z1U8ZAfVATtXKYTs2X2hVsDKsYfbTzP/kLCWXV7YV2T4FnBaWnJFv/OCxfIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=su5MhqTGKgTrL6fTV2UJPNNex9wVkIWEa9Ke3XPLe0w=;
 b=mTdXwgQ2L7A92V2an6fzcTbQa0vbit12FzdDaTXCmh+UjJ5+6QAD3cleddvqZh32tC6g2X0GeEauqyrKlza6Y5EpXqNTpnpx6sBS8QhWUsULMg5Y94ddKC6SZRBFImz8X8GAA7ckpIj8zMzvkXlVs+MJhDrZKHAR8q9vjbM1qMhYI4XioWjquYsl4WpTOd9zFrmVKLJvqv4asO/u7iNdUEwxOUotiw117x66aazjmiWfyKyWE5ag6B/OpUsgeXaW/sSQBigt/U4NR4B4a57qYJH28Bbin/FKCJiy+KREjDtNdr8vdvbuB0XkGw8iuk/TvQJgZo0G5SCMUiGkUct7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=su5MhqTGKgTrL6fTV2UJPNNex9wVkIWEa9Ke3XPLe0w=;
 b=h6nLtHmVIvN/MlgVQ7vjXsQfynLCIYyuWKvZl9MJlbsUNzitwBIMhhlhII+BgqHeowEgu4IVpRaSuTISN17NpccY5qeW7HS1ZdBi+QnCYt8Tpyh7yOFWWUtjmUB1PzUnGp8KL7+rkTcgBh9a/oMKe5nwee37dZsEecMT4VCvItEsWbLNKrz/fSbKG3SJkPwNBb0yR7RgCIqttaU/R/3Wpha+XUOcUsEgWBr22L01eA2j8A0Yvf0LC6mJg5G6dc5fq2TSh0pakCckoQVjRgaePr50D5uMpq03j0WYrdw/Fd9NJWf/255a4SNBi2iqW+tz4yk7H9qaAzhDoeM0iE4o+Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB910612.namprd12.prod.outlook.com (2603:10b6:8:506::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 15:19:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 15:19:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip split_huge_page_test without the
 split_huge_pages file
Date: Thu, 05 Nov 2026 10:19:43 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
In-Reply-To: <20261105030242.1241448-1-sashal@kernel.org>
References: <20261105030242.1241448-1-sashal@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:408:f9::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB910612:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ea4333-6395-484b-9688-08df3b503939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|17002099007|6133799003|10067099003|22082099003|18002099003|11063799006|261022105027099003|56012099006|261102123227099003|261026140227099003|261028144727099003|261026121527099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	447M4zxk0XPxAHbG9TSdtDi6Fkk4UCXeVvj9NxrHqIE2/lPdi1swjcJOZHiV01RlUwKgJlxhCB6xe52BVK/dB7V2hL1PS3AL1IZIpQSaDRhFiG0XZFIVPU8GEBdqC9VJVvufKPgAjaTakX84rE7oPHXtEShF2+e2NOKrkE7njMiF8oy9/z5s/U6NouOl2/IGk9voCplDb+WdQ4qfqfKz5fan5rtpxAEEuYfXrEvUBrjFrGFzPzszIYYtbxO7Xs99wSxBPNculkscs6qVVBP/Mc0cztOHk5xPbnJERsl0gjr96CzXJ+8+xqcMCqSgB7KPgIZnJo2qo8tXnaZZHyXiBX8K50EfIrnC9+CNWFeVRQJAsnpIXMY/IDO879DH0rw/Z9cKiS1V/fwR9CzQdsVPQTBvkkgs65NCdIfR1g1EqcMGAnQy6sXKjEslnhViq4E58qXTNzGZB/kbZeONKVqVMadeRHlUixk6V2+wM65HOs0MCf0PbeOQ3SUQia6TmikomeDIkPG5PhooxYHM31WzUKP4/xVrBELLkvaDpwH/yWHB4DiPNAfAZNvQJkMBE/5lMP4WwV8qbiWHs9qlmCwg9GwABhsAxXIQ7aAvyVMx1hWyvoaYFKaG/U9g04BtZflTTO9mLYWJtX8ZwYbLL38lHCKYCTS2IWIFn8/qsfiyW3o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(17002099007)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(261022105027099003)(56012099006)(261102123227099003)(261026140227099003)(261028144727099003)(261026121527099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?psTpbcLvPUXoViMLwrHgYAWtLedHivP00NQNW0u2mV1arNdaNKCTiBVtEv+G?=
 =?us-ascii?Q?nEzfVoIossY4b8x/FPhndAIj3BLgozKii/jv/ThscfF9TNzMoPmMHBIiiIVH?=
 =?us-ascii?Q?d8dHvQA/+dkZejX/5YmKxcYCTFJP6Omvmo5nNxkTU93/ZXEJ23HR/8bp0W7+?=
 =?us-ascii?Q?8i628l+GTc29rJvLuvqi5jMudKdP2NVCGXlredsUy3RUASbw74wvc4JXlIz1?=
 =?us-ascii?Q?nUqqL1vtmhKFj8TchVD4GKU2gi0jSVyOc9K7273wx8lyrU8lSPWtud8F72sD?=
 =?us-ascii?Q?+PdvCzX4+xmc6gepDQDNqLOUVF48K1HfB2YH/7XySadd7SJwTqFsnzMyelgY?=
 =?us-ascii?Q?uopRa94Z7yQ67CiMqkP3p/9c0t8pt5TWraQFbVkYgzNSroX25tpCAWvuO76h?=
 =?us-ascii?Q?0JhRrKLLO6k5PbfPMK4l7RJpFXhB8tjB3+nzSVdo4NUcD1JFpDVn/9glUJXi?=
 =?us-ascii?Q?FSW5eNZEUn6FkVuD/zPKPr/eXC9FteN4B6kn5osefA/gLJBXquDUZVhO074h?=
 =?us-ascii?Q?4v4UrMA18YVj4cW5YUcVnNx+XkjMg1598cVtN34RdRluK4sdcqKXgqVl/GpB?=
 =?us-ascii?Q?NKh34MlPRfEQokPmOb6HgewFJs6hyQO6GXiCXxolD97osqQUNAC0Lpz9zW+h?=
 =?us-ascii?Q?be77MbVLaSfQkoWsD4kbyVeDOA3CweeA+EL112pQ4EIgO2m8N+1a1m5IIXze?=
 =?us-ascii?Q?i7Lt+YHJpJyTj8kk+SeVnn60fuPFNhmATBVY/3xRqSQIqLRwATrD3uQmWAJ8?=
 =?us-ascii?Q?5Lnfc0MsYhtrHuLF8VLVEmeTq6Ncf5nct9s3C8K94Vx5T15KjIAW48v6LDBn?=
 =?us-ascii?Q?Znk5idwv5OINheOivcBStHeosxblfNA+8RkH3tZfAv3pNd+eGRIV3UIuLANM?=
 =?us-ascii?Q?0TmVj2sPNjRhFWOb8AE3VrN5Jd7ZVeaaHMDCHxBiYgiHVPkmd9LjfM++Hka0?=
 =?us-ascii?Q?iVnGWCy7erYiX62I/zQGwwJSJHn640JlA846NmPASotDLz4eyVrKFHV5qbPz?=
 =?us-ascii?Q?CoTHISNRm0hbsIdxY6mFXbG4ZrgDzPf/VwlLblNmZaso0LqlPlAmTCTTy/k+?=
 =?us-ascii?Q?t8PizXT8qFTGRWH8IA7Dm1l78zCLjqRpXAm8UgGF+kWk8w2IsqH3DVcgGGKc?=
 =?us-ascii?Q?4ZxbZIWVl+jEhNU+Vvev+zSWcvT3FiPtLvEMAxQ/aO4mTg4JLfyzeWnd0d2D?=
 =?us-ascii?Q?MH7CD4gygYeUuyfXNhCFnlX/Rw8zoDl7WMjWZG0TWwK+5rqKbJYMeqiLtYRr?=
 =?us-ascii?Q?tD04j4eN4H2hXKdx3rCHcD6/dPwoRs4/Ki9kW81fGWhQcmGfSdv9q57Kky/H?=
 =?us-ascii?Q?eWCunlEK+oiotPl6+Evt6Ux/Wm5lyhGkOeONeD/qce+6py2KvWFT3VzVHEdh?=
 =?us-ascii?Q?t+SrIQsl+clxSCtTQGCNe1EZV4iNlH2uEoYNHpG84cV3SwrUpbS5q9MjRgGe?=
 =?us-ascii?Q?BYzqwt0Wa3fHRezkRboyZ2l3BtDLMLchMjQVwOIVtN5wyR9oxgr5IOeJyfDs?=
 =?us-ascii?Q?KMm0sgzxE0giR2Hk/0JCcW4tOQo3i/VCBrUQ4aHZlGs2ec9l6FD9x71nQouO?=
 =?us-ascii?Q?cAvVldTQKBDE+iSDjXvbz5mRixb1FWABLNGzPG75lH0mmP4IMgpi0aORZ1ey?=
 =?us-ascii?Q?iE6OUrBFzfphpMnmKrSTWVIZ37YdbBak5wp9pliPJ3EKHRZaYKXOpZBfJ6Mc?=
 =?us-ascii?Q?1GRVEdiNj1aocR5vC9jRE6QZRtP3ngerZWLuSe9L+h9VJhOD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ea4333-6395-484b-9688-08df3b503939
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 15:19:45.9657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+jIEMrJQ4QwuiUO+TX/MMzE3ZIA4cE2eMvJYdPpQWYw7XCJYtiSVfBNxcPbTigV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB910612
X-Stat-Signature: umo6sgu8rj3buxqqcxm8wfwjbdzkdyat
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9AE54A000C
X-HE-Tag: 1793891991-676601
X-HE-Meta: U2FsdGVkX19kvzH2iwLbt0lvwPbp5mC2Znmzzxmfkg3MyFKucUPNG/F8QoFnEEO066rFc6zdxqk5h37DzPkLsMZj92igyhwsOmswolYd3QGtTIiMlmgups0vLJytOj5Ck/4V9RE9+kC40gqqtFhYGJunzuLBeN3tSPRhAshfHc91uWlyKnn8dsN712TNVvBwBz+DZNyvUs81Cgdn1UQSa8qR8q75+YwV0xMdLRHzdOkx072KXY+Sgba35L8YPx1S2Vthpl6FrnwxG+IPoSsG7SXelhf+LKc/wTkv38SfHwbOkBsAF0gSGsvw8EG/H0A2PBdIRQVLzN3digil077VsqLGgkivOqhftRaZ04nYPvxld3t1/y4sFdlnGSFmkKFD390dpNqrBt/dSqa7ATbyikKMOwci+8jSuOWYqASsOVW/EGfLG696LgDTSjNjE+Wd/fcBga0OHMpyZ9WmxSUTMtXts/UmUhVWbmEXyMAlLAHWBaApyrLILdSpoTW/AFh/Ro4D1a2rLKUINquBnxDM5SqlRSiPIipmDoZITlLq4Eyo+1Fojl0SrR7qKSG5D2O/vcm8yOFe6bnK0MkjqOZDoT2VI7u2oGzrj4mOaXlfRf2Qqg+Ro+TC5lUEVvbBMaNoGGOmifF0n5+HN28qIaelR6zCTT3c4a+XS2ywURpxkDHA4KSzKfwPsUbdRDgJs7Hs3HvxFCkUyqT6jHPCYjgMpgB9Ar2KAU1BHV7sc7abQwC1w96AY1tzjZ9Xn1PcwczpoPnXVtIUWAxvIkhewuCntNXy8O+0YuXDhKonYFR5MI1ZqUvxuU7+yglo5/C9UGnGnldzfX8fG0aFp4yB9fxA3+THHsVpIo7ixgU/8O3EYOKcrCZotTR1DCbtN+b1QfJr34i1l8K7pBD4wu+AObR3zksRM3rhMhr6kjFqNUx8ZgEq4yPZ3V0S/pOAmv42YnhRIqge6pzqZLTRgyenDXP
 6ADlSN9V
 BjXsbs1j5eS/fn8r2t4My0027u0wNhk87TNfvm38N3EoPaSIWfULZ87jaFmNUVkNmGB3JYNF8tC6RKqp2MU8jqR+JwAvV11DwFKUrsUBGNq/SdHgEo/eP1VcT1jEkqrN9V/oAoD3innAxMtV04DHbNWO0clKVf4fLmQizp4eucX/rvXYihnLgD4/IUrSfp4WZMGBDOPRDw8Tg6j46uaxqVlxuLnA16kiJdpeobHWMptVdY0wgd6HwiLxJbUzcG772CSSDMFoIAnXWXOzPnDfjJaYFy70D8BmlileHYHDkEPaZ4dfbE8EMmndx0fEVDyCoBJrhk05AQajZ00D6yG07pL74YhyJRdxsVfEQBS0v8ubmUotuxtHrIiXtB/+2uU4qPiStPZMeXg6jq0SG3Y4cbxQ1RF7xkdhZhYj9S3IieBocN+ZNNNIleAUoEIr7/pDwUTxjcudf/6aO4eea+Cqm9wopOErBiXl5bIfxUbaqZC410lOiO9s9bkRa91gPHTRXzmKC5CTY0YZm3IU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 4 Nov 2026, at 22:02, Sasha Levin wrote:

> Every case in split_huge_page_test goes through
> /sys/kernel/debug/split_huge_pages. When that file does not exist,
> because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, th=
e
> first write bails out of the whole test and it is reported as a failure=
:
>
>   Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such fil=
e or directory
>
> Skip the test in that case.
>
> Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for spli=
tting THP tests")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> Found with KernelCI's NVIDIA lab, which runs the tests in a chroot
> without debugfs. Tested on an AMD EPYC 9655P with KernelCI's x86_64
> build of next-20261104: without debugfs the test now skips, and with
> debugfs mounted it still passes all 62 cases.
>
>  tools/testing/selftests/mm/split_huge_page_test.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Thanks. But I do think we need a way of specifying the necessary
Kconfig options for selftests. Oh, we do have one:
https://elixir.bootlin.com/linux/v7.3.1/source/tools/testing/selftests/mm=
/config. Can you add CONFIG_DEBUG_FS=3Dy to it while at it?

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

