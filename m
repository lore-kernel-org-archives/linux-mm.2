Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7EBCFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89426B002A; Mon, 24 Nov 2025 16:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60B86B002B; Mon, 24 Nov 2025 16:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FA46B0062; Mon, 24 Nov 2025 16:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF8886B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:08:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCF6A1405A3
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:08:46 +0000 (UTC)
X-FDA: 84146739852.04.6901C92
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F8A54000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:08:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VWpiJ5gY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764018523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rs1DHbAlKHUd0i+lv20zTUzM3TtTZupZc4o49JksMCQ=;
	b=GQTHQVKDlbmCdyJfwlPrZp1nV7SVAgitlx4tu+Pp8VB62rL5gSVuMrNdHMTCir8H0o4O6o
	KM8W2oz/el4j/gBVzpROnCkKDfYoA3x6X79SXfoq8FidliNMgY5l5LPJjinHG/AWRYH2M4
	a4eqWWcG14FCvxOSCpSHO3D5DDPCej4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VWpiJ5gY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764018523; a=rsa-sha256;
	cv=pass;
	b=hvaOY/kLVOZzd3vBjNTAm3mTM5PNbP0TzooBGxcrTIlsjpQvMKFdeZR2pHqidsmlZFsGP3
	dd1JHnRdt7VM8CkL2+hQr+8C+lWFOoPM65yOkKjNKZlD9EMuzX/piz2inI66GLTsjYhfUo
	P3buwPrHsF+iuVCxrZ3yYXqkBdRsbWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rASL0HAX7Uy30JBJ7bvnaeFfUCfEPq8IvUCATzKlBqcwdQsQsjcMjE9RufaQ8MOrG0gsQTmOTWet4IL/wtWne90DNp6mTa1heJGj3UiRlbYGLrZyS7b8a865UFYarK8v2+Ueyl1bq5uYPn0DKe5tPBr6keD8uJ09lVokbNrI6Ok3Hp+3/tluTeaap/62jwV3mb7nO5l9H2GLjeJMNl12SeyES8sIW4c2B1wGWZmQ6+0abkdp96qKSlMtK9ufHv52/wWpXGUyEDvfld3PqVNbF9Vw8583Vii5lVTsm/MtcQ4BrQl+I8p2YgXOlXRWskN3vgZVD5t/FO5crYSOyDc4yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rs1DHbAlKHUd0i+lv20zTUzM3TtTZupZc4o49JksMCQ=;
 b=y3AVxu1PW1uvjJ1fsohjMW/YtuZtUkDKNv+7ZccYg8CXhfGFzRRrAJI5aAxZK5dBqw8kbPtdDnE0q5XgBzsN1HInDQhEr88x5SqGU/9eIcjEo8ZR0QJU8NV7YKZZiwbBabPLVqZuOmZRMEnMUcVQJZzIRGIF7eT/uZaO71bRrp9M9ggfz9TLX+Mq+Zsr4ST37MkGywjhqnPN8cCHiYLE3hvl4eWOgI9w1zJJAAg5rBD1Y/uejDm2pPyad3uEq2jOurhbdCs1AkmuX+uEgdubUpuXPmobbkRKuuoHK0twx9g68GEj/JIQ961N4e9IrwyBwVrOMSJhm1furSwaQ1Q3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs1DHbAlKHUd0i+lv20zTUzM3TtTZupZc4o49JksMCQ=;
 b=VWpiJ5gYkwMwFSe13+WBgx25u+ve0Gx0Ku1yqrK90TBI8A+fuwDTewd7v/xmgP0A2St++1Mn8oo9pLMagBq6UmVfTlhjQ4HLQZuP8nMSarA81QtnLfhfomFctC/IhMUqcSLOBUDVpTwDu+o31gvaFj4tZCv24/LGFNtAGmChEnAwRopuxNQ/o+ayDE26Geezy+Ce1F/MbsDWvbxS9Mv4VF0TzDBPQkM1GVuV4/cPLdMoWfbmb/ry9hZl2IC3vFnv9Z7SjDea9RAN7FebpXnN0bD3b8atIzmdiO54xUUkmrcLxV3UUBaTvXSfN/CcKZA595+0PnZSnVpKLqHQo3dnjg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Mon, 24 Nov 2025 21:08:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 21:08:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Date: Mon, 24 Nov 2025 16:08:34 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
In-Reply-To: <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
 <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:408:e2::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: aea841e9-9f27-4f33-deee-08de2b9da2f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkZjVVkwL3FhMWRqSHRNckdMSlcvMlRWT3g0RDdRNWwwelU4aEdoVHQ1Yy93?=
 =?utf-8?B?cFNMSFJndkw1a1dpM1Q1ODVQQTZrQnZmRGNzdWRBQVFqWjZUUTJBYThrMHhW?=
 =?utf-8?B?YnVnYUtzUjJjdDR0RmZiSXYzT0FhYjR6cWJmZzB4Ky9EU3lJUStrTU94UjRD?=
 =?utf-8?B?bFU2RUdPL3RQT01BbUoveFQraUlYQ0N0N2g0dkt2dzdJNG5yUzNacEM4aUJI?=
 =?utf-8?B?UkJjWGIxYTg0KzZsUGxNVllqYUpBaXJaYnk1WFRGaWdDQTdRbXFaSm44VHpH?=
 =?utf-8?B?bFUwZ3JLc1I3NWRscUpMdFgxNzFTQXpzaG5PcGxWSU90cVF4NlJNc2o3eDJC?=
 =?utf-8?B?MldEbm5DaVRNaXlpa0NOMWorc1J6M0tGSzFJOHpRT2pubm9DQy9TYjkzWDE0?=
 =?utf-8?B?TjFrRnpxaTI2L1V6RWQ4aHIxeUt2M29qK0Q1RFYyai9EWmhTZm52Skl0aHFy?=
 =?utf-8?B?NUR6eWh3YisvTEdsZ1hSZnAxZGszZDdZYVNDYXdSTGJLQ2tLSUt1bmgvN1NT?=
 =?utf-8?B?Z3ZoQ3I5cmFGODFVOXpORDZVUm1pRjBhSjB6WGtrMG1GZGhudk93L0k4b1pX?=
 =?utf-8?B?dkV4a2QyUUF4S0NxdWJkcVc0YThuQnFRcy9hZUlBUTNpYk1kOHJ0b3BXeHZP?=
 =?utf-8?B?cGw3YTVrUi9ZdGg1UE5YVmo0L1dhdFpTdTVIZ0JNekE5a2pYc2twMzRNWW9w?=
 =?utf-8?B?MzBXVnA0dWt5K1JiSndENXcvSy9qOE4yMUw0TVZpanowaXNkdlJtOHJ6aXJh?=
 =?utf-8?B?eDdxaC91V3ptZlp4Mklab011cmRUSnVJQVhMd3dUaThobWhDUHFBRk9DSGNV?=
 =?utf-8?B?YTU0UVkza25LWDRHWnpGV1dNZWRVcDc0aE1tL1RERHBUb1AwaHczMFVYOTVE?=
 =?utf-8?B?dktKSWJWQjhheStJQ24yRGFKTlZiNHh1UHliMDlLR1hqZE5XVFZtR1YxOE9T?=
 =?utf-8?B?dURxSUVVVHZ0K2F2eWRIUnVuU0ZUTnN1M2hmZGJ1RDlidTJoRmZNRFA0bmNE?=
 =?utf-8?B?UXdtVGRycUNubGJVY1lQbDYrcENRREJwYTVVbGllaHc1VnEwVGwwM2xmRkVD?=
 =?utf-8?B?LzhMaGRzcWYvTmFYVkRDOFRRcWJhMjBramtVNVNhMjdYOEl1OWpXaVFjQVVT?=
 =?utf-8?B?U0tkWmxPUy9HTzBiYmcra1ZyUVJOcEhzZFZIV0RlaFRib1hjOHFIN0tCb3p5?=
 =?utf-8?B?VVlLSWZ5aUNwZXhKTE1wWUhlQ0JzYTBSeVFWWTlHNEd6TXdWL0hmWXBmMmw1?=
 =?utf-8?B?czZJOEg4UERqS09HNXZmbWZnTEF1UC9NQXlzMlZaR3R4OHdLRmQ3T0hJVU1l?=
 =?utf-8?B?OUVVQ2lBQWNUbUxpR1o4SnRnV2l6WmNTaDZmZ1hqdmRkWnVscWZnUmcrT0lQ?=
 =?utf-8?B?VE5pMFpxRlVFdTNRZmxRUlFRa0Nlb0ZZT3dIRkc1cFN6SHB6YkZkMVIzdzY4?=
 =?utf-8?B?NTQ4TDRZSHFUMkhVNUdIbXFNQUh5N3paV1FHOHBjbSsxOXNDZ3g1bEFVajla?=
 =?utf-8?B?TDJ2YncyOEtaZDFud2dKRC82MDlrTHFaTE5WeEtHZnhURDNDTDN6TTFYNnVE?=
 =?utf-8?B?ZlhCd0psRzVadXJzRVlSd0hSdFM1dnlwSjJFWmVNbTIydGlNNkI4ZndLc2Vp?=
 =?utf-8?B?OGNRcUZCRHNFc3BmeGR5OUVIZVErSEdyQ2x4NmJKdWxlZi9qYVE0RnRNZFJt?=
 =?utf-8?B?a2dnQ2Y5UDRiQ3lvU092RFJPNG4xSDljUC91TXJMZDRvdUZCNFFFRDFtUTRv?=
 =?utf-8?B?MlBnQTdNNUZ2Q2dVZ3FwSUd4UEx2ZTU3RWhuVWxuOWc1MzF0NzhJSVVESjFQ?=
 =?utf-8?B?dHA4Qy85bkFxandISHk1c0EwT29IWXBzR2NlMDJMMlQ4RHlWU2JzSnpSeERJ?=
 =?utf-8?B?NVlLR3l5UTlZTmoxYUZFSkdHRlNpSEFjckljVExDNWZObWtYQnlEMmt3dGdW?=
 =?utf-8?Q?BImYgBWjALOiy5GB/lKWnIzeLOJkLG7W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU9JbXVCZ3k2cGExUkUwUzVMU0gxTDhUdmNrS2RJOXhYWlhKTkJtUnpiTDE0?=
 =?utf-8?B?d3N4Znh3K2xvQk51bkZ0UU9Qek1xTVFtRis5N1djRUY3NEJzWHY0bHF1cytY?=
 =?utf-8?B?RExsWjI0SERjOGFsQTQzWktTR3lsOW1mbjFHR0pvdnBVYzJHcGV6YnJnNnBU?=
 =?utf-8?B?S0lBM0VBQ0pvbjFYNDltZnppOVBFUVFtVTY1emVmMG1HNWhDWFUrU3d2Qitt?=
 =?utf-8?B?R0dTK3MvSFhHcjBsdW5udWhqd1NCMk1rQUNGTEdkbkoxYmt2eFdRRHlSK0h1?=
 =?utf-8?B?OFBkaFlMb0FBbTJvTkFMclRCRCtLKytsdEl5b0czUlBIWnFKSXVzTVY1bms5?=
 =?utf-8?B?UUtPZEpLUjBlb2NkSy92aytRR1ZTMnZUMXhicFREclVTcmpsUE1PUEdkZTFL?=
 =?utf-8?B?Z3FrOGFsSjBsdEswdU9DdGdJVHN4WjZrS29XK0VxR3ZYZEljaW9WbGt3eith?=
 =?utf-8?B?cXUvcG54QkY0QjBmMDV4VUZQemFKdTY4OURPMjlyT2VHZVE2cElTekZsdnlv?=
 =?utf-8?B?UmJ1b3g0NnoxQk45cHl6ak1OdDlWS0hSS24zUTZ4MSttYm5BNy8xNWVidUh4?=
 =?utf-8?B?TmVYMEdMUEt0WEN6WEt5cWt4ZStkdmNTaWE4SkFvRE1PRm8xd3lYcHB6T1hm?=
 =?utf-8?B?YldtNjZzeEhsRnJudm52VzNQZDdHN2k1MnZNUGhzclFuK2xOS1p1c3BGbUw5?=
 =?utf-8?B?NVZ2eTVqVko5VmNHM3REZjBKWVFpTUM3ZHVQMFpFajVSeDVVU3RxQzhSaU9E?=
 =?utf-8?B?ZnYremhMMTZpWUkvZnBHMWVyQkdpM2hONzlod3ZvRWlKdUJ4V1JLSUdsZFR3?=
 =?utf-8?B?anF6ODB1R3lCWjlxbmJ4WG9wOC9qejV0QjBGMFdHcGpvQ24wV1NMSmY0aHZw?=
 =?utf-8?B?YkV4U0s0M0o4SmEvYjV5dVUzY3dLalBQSGh0V2JDYzVSSUFMYkNpQXM0RDdC?=
 =?utf-8?B?d1ozeUt1ckhMelhlWjVhREt3aGhrZ29vbmhSREUybWZ5Yk84OXlEU01xekJ3?=
 =?utf-8?B?K0J2cGZZK1JUeFhKRUREU24yb2gza2tGeEM5b2pKempmeEFKcFluU3hvMFhz?=
 =?utf-8?B?QmgyQlkvM0RkYVNKWVpPWlNTSXBvSFFrNFBabkZscHAvQ3I5OGdtcjQ4TGFO?=
 =?utf-8?B?TklHWjNpNEdBeG5sY01Ed1AvMWlKZ1JUcmZpMFlKVmZZYXR6VW1ZT1VML0FW?=
 =?utf-8?B?OWxpZERlOFEyZVBXK2kvNG1OWis4cHJiaFhXbGpOQ3JaQnZESTlYbmwyUHlB?=
 =?utf-8?B?SkVWZm1ybS9rRmp2L1NIL1ZmaTlGcGFmQncweTg3T0dLdTRWTEVFdjRaUHV2?=
 =?utf-8?B?VDU2MlVhR0VUaEJHV1hMbHZUSG84ajFJY1hMcXJnK2hHaHhyZkZ0VVVvTTIz?=
 =?utf-8?B?NzJMSnB4WHlMTzFnVjJZV29IVFp0V3VvSTFEaW5IVCtyOHB0MWRzQ3dCM2Z5?=
 =?utf-8?B?bzR0OUhXaVREdkRic3NZMWhEQ0pBR2lVTzZtVFNqODNEZUFBanZ4bVFmZmRC?=
 =?utf-8?B?UWVPUjlkM1RNb2J2aEovbHJiYTk2TkZiaXZ3YmlmOUVjVWE1OWo0ZVBUUzAz?=
 =?utf-8?B?ekVmTzJDTXpUdlJTYlVYekZGc0sydjExeWJNTm1ZWUthQisybElJU1hTbUFH?=
 =?utf-8?B?WHNCRFVnU2tIcWJSYXpuSlc4MHNHdFh2OUdvdjlzTGdrTzZoOWhRWFBvemN3?=
 =?utf-8?B?Z0xLQW52RHZ0a2UySXI2MU8xWllhcmJRS2V1d3V2a05jaWM0YktCZGxBeUNI?=
 =?utf-8?B?RTEraU5lUlpXa3dNc0I0Umo2NFZBUnN1dm10VklKd1VUcXp2bUJlUnYva1pO?=
 =?utf-8?B?M2pQYVVXS3V6MnBETkZzV3V4SWJ2aSs4S3kzMWEzRUV5d0JNajU2MkExcTZP?=
 =?utf-8?B?LzViQ20xODhCZStxbFBPM3h4NkNCVTJIVW9YMHdDMEMrMHBTMXZkb0d6Rmhn?=
 =?utf-8?B?bnUvVU5QQUp1SFdCbGVMRjlzaGdSSFE1STcrQkVTeTE5eU1jVndITmFwUno0?=
 =?utf-8?B?RXZ5N3BJUjZkeC91bk54QlJjSFF4M21zZXlBUm5ycDRqRjFuSDNEb0c5NEw0?=
 =?utf-8?B?K3FZbDI0c3dFNy94Nk9sYkJSN2kyMGNGZ2JPNWhoY1FqR2lCdGFNa1VFdFpr?=
 =?utf-8?Q?HV2hT2kIwp0DNNaYoR8XCWTGY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea841e9-9f27-4f33-deee-08de2b9da2f1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 21:08:37.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUI1QmrmFg35eymFY/BtDhf9h77HTkLVTfK7yN45HNyA7v1mA47V5hIUfUOHgZo0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F8A54000F
X-Stat-Signature: sc1xcn78fwzbzjwcoekkaia6qfh7asdf
X-Rspam-User: 
X-HE-Tag: 1764018523-880396
X-HE-Meta: U2FsdGVkX1/vR+mlyndMXEAjGNd4qc/hBdlAiintVQG1W2sRhbboVUb6/91vaNjt+dvotWaj1UVMvSDT3jEpJDhF9Xkb7NCK6U3wJDUJJ27pCzYQ73uGxRSgx+FbyrXSnqNxbxLpcV+RfJOW/RMdHTLR40VoTrb/YMO3wGVZFLZ+eUe8+7+T+TcOJFr1cwVoKGq3beyuENav1lNuHJ85Qd580eiBVj46v6S62urxRMvlKu0szTXFZoD5Vs/uZu1MG+V1rFYFfIx52vwZ2RuAnWCADrsrxD8b63kAvdZPlKUkZ+m3QXbwRDZX4624tel13KtcCvofMJwuHJjN4DQIxASw5xSJ+dYKlXFOk+DyAedTPTvcA6uya0saQTA/Ym1bj22fTmNfFStKLzJ+ziTJnAMG8u+37xGpTsjhfsBZxogC7mSpCxAFFgO+OQVdvFvyuz54G9J3CFnPMN0VGjXYIdWHVB+8A2PsTA/kXg+P0L71Lwo/AV45QhyZE0FX1s85MIzS27xZrwVPzdKaNPVHbFVDvuVxN/oCu7zcYqBRnw4Bqd31rXoU/0occMri1BNXMuDeoCv34lW/yg4ZjEFgi5P1Vo1vkC9LURIKh21ozdfU9zczeRDSfBpxXNyFNhfFd0WWy+z0kmV1M09Vkwt1iy5HmRYpWgaQA76kflg+BLiGEfKQc08L1MLzm2uLMkFTCtz4Zbuyj62fpxPn48VU5gbL5jeOBxTCpdvPfg2urYT95V1Mx8i3v4Y+fnl+tyYeUhHIsqfhw0LNuA038sqPzAMlpRh//PF9fK3gwfsymQR34leilJ6nRPovz1FSx+ORjWJtQdtIAX1A645B7VgG3aSMo23bmUrzF7gCNJc9XcBMx+fB1fGwNlS5vRgp4kJjyLKALbvsNHur8OAsLUGSViHgC/RCYacRZthlfAplxPopyLblHB/dCEKMFIFXaRN6d7BX2t1PxdsEKuHGXcx
 Q1GUC0OM
 uUm3GcaoLK8F9pfK6sDodYSowtXyNAjGGvHGIAX1BhFwZMy2/rDhcAxE6lNNZttKr1Euqbslj+mQaZJ/VjqxP015h4pfoPPa5ZSl56Fpj44u5SS/Z8hgZPoGdWolH4JzITjqXpBPx5iPAL94cKHPCiQdPhx49naq7LZSmPWyOVaO8/wkthYS7bAhQwIjT4DeGS/4Ky/Aibm7V/3QgI0O8AipBk2E/RQAF1YW5ly1hBrgfBAXNJU8NGA5Z0ujhmyKS5naa7YmZKpkhLa/bY6nImrS58Bgkbkl02iFNk9SgvZE/ZPMi0+fNb6kGif35L0zzTPDs9g2ZdiAwGSvOBMjE70QOba3NyAre2F7pnJQlSjyuEMiNeykZnpaE7j2SBfvgbltG7zjLl3DgEURJZHA+mws1/H1V8i2JGTcqDEulB9sPapDEq45GUJ98UIyenpN7C7GaaCRlqxaPRaQvyIJhRBnn0g5wA5mgoQAnrann8sIaXiruHc5XTxetbN6N6lvYgV+aOcYEBIiRNiA3LxbK4aKkGS8NBs+DuOTc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 14:22, David Hildenbrand (Red Hat) wrote:

> On 11/24/25 18:05, Zi Yan wrote:
>> On 24 Nov 2025, at 5:41, David Hildenbrand (Red Hat) wrote:
>>
>>> On 11/22/25 03:55, Zi Yan wrote:
>>>> can_split_folio() is just a refcount comparison, making sure only the
>>>> split caller holds an extra pin. Open code it with
>>>> folio_expected_ref_count() !=3D folio_ref_count() - 1. For the extra_p=
ins
>>>> used by folio_ref_freeze(), add folio_cache_references() to calculate =
it.
>>>>
>>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>    include/linux/huge_mm.h |  1 -
>>>>    mm/huge_memory.c        | 43 ++++++++++++++++----------------------=
---
>>>>    mm/vmscan.c             |  3 ++-
>>>>    3 files changed, 19 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 97686fb46e30..1ecaeccf39c9 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -369,7 +369,6 @@ enum split_type {
>>>>    	SPLIT_TYPE_NON_UNIFORM,
>>>>    };
>>>>   -bool can_split_folio(struct folio *folio, int caller_pins, int *pex=
tra_pins);
>>>>    int __split_huge_page_to_list_to_order(struct page *page, struct li=
st_head *list,
>>>>    		unsigned int new_order);
>>>>    int folio_split_unmapped(struct folio *folio, unsigned int new_orde=
r);
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index c1f1055165dd..6c821c1c0ac3 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *f=
olio, struct folio *new_folio,
>>>>    	}
>>>>    }
>>>>   -/* Racy check whether the huge page can be split */
>>>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextr=
a_pins)
>>>> -{
>>>> -	int extra_pins;
>>>> -
>>>> -	/* Additional pins from page cache */
>>>> -	if (folio_test_anon(folio))
>>>> -		extra_pins =3D folio_test_swapcache(folio) ?
>>>> -				folio_nr_pages(folio) : 0;
>>>> -	else
>>>> -		extra_pins =3D folio_nr_pages(folio);
>>>> -	if (pextra_pins)
>>>> -		*pextra_pins =3D extra_pins;
>>>> -	return folio_mapcount(folio) =3D=3D folio_ref_count(folio) - extra_p=
ins -
>>>> -					caller_pins;
>>>> -}
>>>> -
>>>>    static bool page_range_has_hwpoisoned(struct page *page, long nr_pa=
ges)
>>>>    {
>>>>    	for (; nr_pages; page++, nr_pages--)
>>>> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio=
, unsigned int new_order,
>>>>    	return 0;
>>>>    }
>>>>   +/* Number of folio references from the pagecache or the swapcache. =
*/
>>>> +static unsigned int folio_cache_references(const struct folio *folio)
>>>> +{
>>>> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>>>> +		return 0;
>>>> +	return folio_nr_pages(folio);
>>>> +}
>>>> +
>>>>    static int __folio_freeze_and_split_unmapped(struct folio *folio, u=
nsigned int new_order,
>>>>    					     struct page *split_at, struct xa_state *xas,
>>>>    					     struct address_space *mapping, bool do_lru,
>>>>    					     struct list_head *list, enum split_type split_type,
>>>> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
>>>> +					     pgoff_t end, int *nr_shmem_dropped)
>>>>    {
>>>>    	struct folio *end_folio =3D folio_next(folio);
>>>>    	struct folio *new_folio, *next;
>>>>    	int old_order =3D folio_order(folio);
>>>>    	int ret =3D 0;
>>>>    	struct deferred_split *ds_queue;
>>>> +	int extra_pins =3D folio_cache_references(folio);
>>>
>>> Can we just inline the call do folio_cache_references() and get rid of =
extra_pins.
>>> (which is a bad name either way)
>>>
>>>
>>> if (folio_ref_freeze(folio, folio_cache_references(folio) + 1) {
>>>
>>>
>>> BTW, now that we have this helper, I wonder if we should then also do f=
or
>>> clarification on the unfreeze path:
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 0acdc2f26ee0c..7cbcf61b7971d 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3824,8 +3824,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>                           zone_device_private_split_cb(folio, new_folio=
);
>>>   -                       expected_refs =3D folio_expected_ref_count(ne=
w_folio) + 1;
>>> -                       folio_ref_unfreeze(new_folio, expected_refs);
>>> +                       folio_ref_unfreeze(new_folio, folio_cache_refer=
ences(new_folio) + 1);
>>>                           if (do_lru)
>>>                                  lru_add_split_folio(folio, new_folio, =
lruvec, list);
>>> @@ -3868,8 +3867,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>                   * Otherwise, a parallel folio_try_get() can grab @fol=
io
>>>                   * and its caller can see stale page cache entries.
>>>                   */
>>> -               expected_refs =3D folio_expected_ref_count(folio) + 1;
>>> -               folio_ref_unfreeze(folio, expected_refs);
>>> +               folio_ref_unfreeze(folio, folio_cache_references(folio)=
 + 1);
>>>                   if (do_lru)
>>>                          unlock_page_lruvec(lruvec);
>>>
>>>
>>
>> Both make sense to me. Will make the change.
>>
>> By comparing folio_cache_references() with folio_expected_ref_count(),
>> one difference is that folio_expected_ref_count() does not give right
>> refcount for shmem in swapcache.
>
> Good point. Likely nobody runs into that right now because nobody can rea=
lly does anything with these folios before they were re-added to the pageca=
che or mapped into page tables.
>
>>
>> This is the folio_expected_ref_count() code:
>>
>>          if (folio_test_anon(folio)) {
>>                  /* One reference per page from the swapcache. */
>>                  ref_count +=3D folio_test_swapcache(folio) << order;
>>          } else {
>>                  /* One reference per page from the pagecache. */
>>                  ref_count +=3D !!folio->mapping << order;
>>                  /* One reference from PG_private. */
>>                  ref_count +=3D folio_test_private(folio);
>>          }
>>
>> shmem in swapcache mean !folio_test_anon(folio) && folio_test_swapcache(=
folio).
>
> See below, it's actually
>
> folio_test_anon(folio) && folio_test_swapbacked(folio)&& folio_test_swapc=
ache(folio)

!folio_test_anon(folio) && folio_test_swapbacked(folio)&&
folio_test_swapcache(folio)

Right?

>
> I think ...
>
>> The above code gives 0, but folio_cache_references() gives folio_nr_page=
s(folio).
>> It should not cause any issue, since IIUC shmem in swapcache happens
>> when the folio has an additional ref,
>> folio_expected_ref_count() !=3D folio_ref_count() anyway. For split, it =
is
>> not supported yet,
>
> Right.
>
>> so folio_expected_ref_count() in split code does not
>> affect shmem in swapcache. But folio_expected_ref_count() should be
>> fixed, right?
>
> We should better handle it, agreed.
>
> Staring at the history of folio_expected_ref_count() once again, back whe=
n we had folio_expected_refs() in migration code we didn't seem to handle i=
t I think.
>
> -static int folio_expected_refs(struct address_space *mapping,
> -               struct folio *folio)
> -{
> -       int refs =3D 1;
> -       if (!mapping)
> -               return refs;
> -
> -       refs +=3D folio_nr_pages(folio);
> -       if (folio_test_private(folio))
> -               refs++;
> -
> -       return refs;
> -}
>
>
> gup.c doesn't care, because the pages are still mapped.
>
> khugepaged.c similarly.
>
> memfd.c doesn't care because the pages are still in the pagecache.
>
> So I suspect nothing is broken, but the migration case needs a second loo=
k.

For migration, shmem in swapcache happens in shmem_writeout(), where an
additional ref is placed on the folio. And migration caller places
a ref on the folio to before a migration. The folio has 2 refs and it is
not equal to folio_expected_ref_count()(returning 0) + 1 ,
or folio_expected_refs()(returning 1).

So it is safe.

>
>>
>> Like:
>>
>>          if (folio_test_anon(folio)) {
>>                  /* One reference per page from the swapcache. */
>>                  ref_count +=3D folio_test_swapcache(folio) << order;
>>          } else {
>> 				/* One reference per page from shmem in the swapcache. */
>>                  ref_count +=3D folio_test_swapcache(folio) << order;
>>                  /* One reference per page from the pagecache. */
>>                  ref_count +=3D !!folio->mapping << order;
>>                  /* One reference from PG_private. */
>>                  ref_count +=3D folio_test_private(folio);
>>          }
>>
>> or simplified into
>>
>>     		if (!folio_test_anon(folio)) {
>>                  /* One reference per page from the pagecache. */
>>                  ref_count +=3D !!folio->mapping << order;
>>                  /* One reference from PG_private. */
>>                  ref_count +=3D folio_test_private(folio);
>>          }
>> 		/* One reference per page from the swapcache (anon or shmem). */
>>          ref_count +=3D folio_test_swapcache(folio) << order;
>> ?
>
> That is incorrect I think due to swapcache being able to give false posit=
ives (PG_owner_priv_1).

Got it. So it should be:

          if (folio_test_anon(folio)) {
                  /* One reference per page from the swapcache. */
                  ref_count +=3D folio_test_swapcache(folio) << order;
          } else {
 				/* One reference per page from shmem in the swapcache. */
                  ref_count +=3D (folio_test_swapbacked (folio) &&
								folio_test_swapcache(folio)) << order;
                  /* One reference per page from the pagecache. */
                  ref_count +=3D !!folio->mapping << order;
                  /* One reference from PG_private. */
                  ref_count +=3D folio_test_private(folio);
          }

I wonder if we should have folio_test_shmem_in_swapcache() instead.

BTW, this page flag reuse is really confusing. I see PG_checked is
PG_owner_priv_1 too and __folio_migrate_mapping() uses folio_test_swapcache=
()
to decide the number of i_pages entries. Wouldn=E2=80=99t that cause any is=
sue?
ext4 does not release_folio() for migration when PG_checked is set,
ubifs clears PG_checked in release_folio(). I have not checked all other FS
yet. Maybe later.


Best Regards,
Yan, Zi

