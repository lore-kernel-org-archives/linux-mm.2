Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFD3EA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7A96B0005; Wed,  4 Feb 2026 15:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392686B0098; Wed,  4 Feb 2026 15:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A5E6B0099; Wed,  4 Feb 2026 15:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12C2A6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:02:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6AC15841E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:02:22 +0000 (UTC)
X-FDA: 84407846124.17.5B6D795
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B7FF51A0015
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:02:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ahYoYWrz;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770235340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hh+KIf+wa1+bA4syIh1sildb1OR45D7mQHEDD+Nh4J0=;
	b=S4Hl6IwUtbu496pbRS2j0MuSW/R4F+CMaW+nIRTpNdwg5PF2uK2n1BC1r/hkN7iW354Tmv
	DUYb/8tL+JHM0RfeQgyFWD1aKmBc92M6aTCRXNxNPBHa7xzLgIUpPaXvykXf7KrJj9I3vq
	eN0cHccj205TvLI7rr0iyDplxTdsVM8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ahYoYWrz;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770235340; a=rsa-sha256;
	cv=pass;
	b=r4jCB0E/VCijW9mH4KvMHCIPPzl4IsnVtClLNZIdzsum7801IxRkHT8SDVS2jfFp5JaxRX
	+994RVlPmQhtP+/+ocRDYyqQ3HjPSZ3J2ku6GB/Il5DmciMMs27neJdkfUxdtiCJHGwhXD
	BDSZvh3M1mEvFy1wjP+NpE6OHkh11+c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcMO0I2/bfXY9EcRwa03vuDuyf2k4aoLvHahhi3CCWE94Ib36OaYY1ljKB4SKOjAGO0YWkegl/YplhQ2EZtEetnf2sRBDRKoMFa45GKS8jweYtA/SB1ztbYVe9FjbacR2HrB5M2eC4bfBlcnHGnmkk59KxFfMK0uU8nBzTL2zpcumMgGzyKBAw5wk9ieYtNeFSDYESXuLvBA3F6ce1OSS1wBjDVvPwHOsJ1zSMniDhtmiy+QJNf7NJ5Ko3LTpJGU/s5DJXti0gl9jwRxhW+T01Okre7v+lemZD+Yurpgj88KEvvuGki9dC+N/9oxPKgMKpb5rzw5pJncZK1PBWCvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hh+KIf+wa1+bA4syIh1sildb1OR45D7mQHEDD+Nh4J0=;
 b=dIxUpgf11rFzlZMo2DhvYMPjlmvQ2xsTfOaS0PF1H5LLAH9a6/iHGRTi1B6GLPJQRC10D8OO2MIvB1CimyESS60pL0B7QsBMGz9TtLD8Co/lnswYX4KCCqDZt/J3d0GR7XUrrwknQOtvvDTGgbmUGDXwLws3EuTTc4mX2wOPVGM/YMJoyzWY1h42Rg0Sj9aI03l/qjWZ7DKKLb3n6fgK287sRSxbtMMrVfDCIrqmerqihgtH7zSdoUrOaILQ3ZQgxIT4xAF5zkIngfcJSJezDzLqmIhd+Wi7PjtaP5zf+aM2JPdyBm86pOt+8/zqBl/QP64xvlEaiNH77zVIEplarA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hh+KIf+wa1+bA4syIh1sildb1OR45D7mQHEDD+Nh4J0=;
 b=ahYoYWrzvUZvor+LH664SfwvwooBUu8oSUzzgD7RDwWSxGJgz4/7cQIy7oTtyQbgZF+mLxuLnJlvq91iFDbYAnDeInD9fp30QCk0OE7epFCytgBHFtgEx2Uox28bVe1CJfJgavPQcGh7iAA5e11/QCX5aq2jLswkjYTwb2LYpOzHwie/Ea9Q9bWrUsBsk0S7X3yJcqRuAPDyULZr/0SvweOHQj3k/f7i59D4AXMqS0vPdL+70xwRs/sIcFBrw2dVJK71E6P4UtuDZ9/fs5zIn2jSHVW0AWeU1o2NqHt/cudXE0wIZryMDOGyJvpgLXQCiz9vB410i5eFGYYP58Xrpw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB9033.namprd12.prod.outlook.com (2603:10b6:930:71::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Wed, 4 Feb 2026 20:02:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 20:02:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com, gavinguo@igalia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Date: Wed, 04 Feb 2026 15:02:08 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E4DA2E02-DE3B-4D26-A427-5D53FCA36A58@nvidia.com>
In-Reply-To: <d3f4456d-f2e1-4d8f-aa92-77ccd1606d59@kernel.org>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
 <d3f4456d-f2e1-4d8f-aa92-77ccd1606d59@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a03:505::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB9033:EE_
X-MS-Office365-Filtering-Correlation-Id: 25847913-61ce-4bf2-d14d-08de642849b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmxJWnRqZkx4SkZhdjZhZXZvSmhIV0pDWnBjM1F0R0M3SzhweFRIK05hQjIr?=
 =?utf-8?B?ejlSd25GbVNkVWxXUlVIbTBvWHlIcnJWOXhwd2VxSXVSN3JteDNaa1h5YUNl?=
 =?utf-8?B?UjlvSE9BNG9kNkZ1ZzgxWXhEcEtiekE2L0J2dUxiZHZrRlREdDFkOU53V01z?=
 =?utf-8?B?TVBUdHNoRlJoRjk2SUs0Y253S1BuL29LUUFESmZzQmNHUHhNSjVCQXNOYUt4?=
 =?utf-8?B?cWJhWFNld1kvRGUvU3VSL3BQdnpiOFlOeGdQRHd4a2NKWUFrWFZWY1FrdjlW?=
 =?utf-8?B?aUlsSmdRQXUxUDhKMWttY0NwanhoaGZOd0JQbkJWTjRMaVRSdmRJdWcyZVFD?=
 =?utf-8?B?Rlk1ekZlWU43Wi9ybFpaV1Q3NUQrdlM4S2VXL1d3bktxMHh0cWh3N2NibUZE?=
 =?utf-8?B?SUVlWTVtaDZmM3R0SjFjNCs0RUU2d3hXZXAzNWxlV2V4Q01qL1BwdnhYcVVO?=
 =?utf-8?B?Zy8rVW9lV0J1ZHBOb2tPeVRkNGVJR3Y1L3JxNXV6ZmJ2bzdDcFBlQWVJcm81?=
 =?utf-8?B?R1doNVUvK1pxUFFXdDdtWGtwS1dNYnE3RVBZL2tLOCtlY2M0RnkyWml6N2dj?=
 =?utf-8?B?djUxWUlMcTR5NGNybFRjZnQxRHhJSDZQaXNhMWpsQ1MxQ3lldmM3UzhrNjR6?=
 =?utf-8?B?WGJZbnRRcm8wem9BWFM5MEFvcG9TQkNyeDNKRUpuWDlFcTdITkptYjdsQWpK?=
 =?utf-8?B?MFF4K2NsL3dKRlpzOXQ1dGRwaElvNVdyN2FhVUl3d25YWkY4bGQ5UWdZR24y?=
 =?utf-8?B?RnpTdDZFRkorYTJMTk1DZFJQREF5UGVncmhhQUNIT0xiZWZ6Y1JNSWVSRWpR?=
 =?utf-8?B?K0ErYkFEK1ZsY1FnRlVqbVAxUDJhOFc2Wk9oRDJjbWw5WEYxVUR4Y1F3ZmFZ?=
 =?utf-8?B?dkJlNzVWSlhuTXFBRHJadGpGMUtGanA1bVc0MGlaSGNRSmsrLzh6QXJ4Mzk2?=
 =?utf-8?B?SnFkV2xHTUFOdUI5bzEzNXorNElTTTFhc0Z5cnk2MlZqeC9lR1dCcjJ2NkZu?=
 =?utf-8?B?b0JBbGZGd2NFT3dUdkorRGMrU01VbmQzZHBxbDRmZUpHdVBiVmRTYXYzZmpM?=
 =?utf-8?B?c0RDS1VKWldpdVdiZkZQUXFMa0dhNGdZVnZySVU1MUpia0d4UlNBbCtVd2RG?=
 =?utf-8?B?RytrNHVra3h6dVd4U0tndWZqeEVLTXNYYVZFalE4QWR5TmFsbXo4dUYyUHlN?=
 =?utf-8?B?WkltMHorRXhNak9mK2pqVHZjZDJkalpuQktBWlBpMDhYQnNPM1ZLZndDa0Vy?=
 =?utf-8?B?QUNpSlZVUGZhR2ZGNjRoMzB4OXNJUXZHN3dxaTYwaGp6RlNBT1pQVWhPOGVW?=
 =?utf-8?B?NStIeVRBMWNnY0hEekRmbVEzcDdORDNTTUpzZC85czRoVDZNQU1LY0ZSa1d3?=
 =?utf-8?B?WVJQY2FhRDF2VTNlUUZ4dkE0Q09idm9Xb0JSb2tlaEVtZHJYWmJaT0ZyZHla?=
 =?utf-8?B?WXM3ZmRjYlFyVEVMbWZjWEtyWndHTEFSeVRqRU5JUkZOZW1RcEkwbmRzT1Bn?=
 =?utf-8?B?amYrUnJseFc3cHBpd2c3SjhydGhiV3Z2YWlPcThGR3NzRmMwVWVCYnlPaml4?=
 =?utf-8?B?V1I0UFJaREtHT1YyY204S2V2WGlxdXpoOGZIZ21jTGtXVDFoSTI0SndmdG1h?=
 =?utf-8?B?VzhhV2hXR1p0WENmejg3OU1aczRZaDBTaXEveGhCNXgxU3RydXFiYVczVERK?=
 =?utf-8?B?d0pia1VwbE54VVFYQVM1cFV0RGNuL2NZSHV4Y3p6b2xXMCttbEZjbTMvdE1W?=
 =?utf-8?B?UUI4WEtMRTU2QyszOXV2dXd6WnRUemtjMWZ3cDVHdlhQL2xvYlphaDRDT2NR?=
 =?utf-8?B?ckZ6N2lGZ1B2ZkVYeGVGMVZzRERKQ0dqTERNRWZmUS91L3dJZlNnSzA1VStt?=
 =?utf-8?B?T2oxYzIxcngva3hKR0NLZEpaOGxhU3NPaTZnSVZjeUNJQUVSZGZvQlJkNnNu?=
 =?utf-8?B?WDQvbXEyNGpKU1RXVC9XTXB0cm1ieUdWQWtQVS9FS0ZUalc3NkpSU1gzR1Fm?=
 =?utf-8?B?eGcySWp4eDd5bUV5NEJnUExVQjg4bi9BQUtSMUM3NU0zcmU5SXBOcDhYT3B3?=
 =?utf-8?B?VG5wVW1NaVNtdGdOdzkzNGZJajI4NzFOZE0xQnprNXhPTkNSQStEaW81R25L?=
 =?utf-8?Q?dYxM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVdJQThHV3QwZUwvWEY5ZGpoYjFaNjhxQjdaMDhEajJTV1AvUmY2dmhjUkk4?=
 =?utf-8?B?WVV6V09vYlFKY3hvSVJaRWxjR3RYb213V2lBaEd4Ti9BbElOMUNpSmMzZHNs?=
 =?utf-8?B?OGx5aDBGUEF3eno1NGNIcTJyZFdxU1NBbWNhQmY2bC9BdEt5N1NXQ2FtK1FT?=
 =?utf-8?B?NmdOVHFhbzlyaEdPVXU3aWxLQmFIK2tEN2VYR2hRZTZZdFAvUUtDdFY5NzlV?=
 =?utf-8?B?STBaQlFSNjBOZ0VmMkZmTGUrZTVSNUtoVTdKcHZBMGpBTWxDeDNpdDJvaEFw?=
 =?utf-8?B?RWNXU3kwdmVEZ1NWNFpjNzlTVjl1ZEVvQit4eXhBbHptSzcybDlqbktjMHpC?=
 =?utf-8?B?ZnIvSllDYU9WcFZtWVNackkwTjFOY0o3Y1B5b3U2VTMzM1JtRVRkVFhQT1RW?=
 =?utf-8?B?UVRNSk11Y3l3RnZ3OW9OeVNsQjFySjNBYkRNZlR1M0FzUzBYdlM2OGowemNj?=
 =?utf-8?B?YS84Z2ZEd2pwOFBSRHQ1UEpsdHJlMEk5OTRTRnIrejh0SWV5RnZxdEZxcXM2?=
 =?utf-8?B?VWhVcGcrTktaeVRTNU9OOW5sNDZwRzhVSGJZVXZobitLMnMyVWc3K1RxN0hL?=
 =?utf-8?B?Szl2NFVyMlA3Nk1DNTZQM2lCU1kxRWZ0UGxoa2xMU2tHckpNem9tOWs2Z3Js?=
 =?utf-8?B?NTE5T2xVbFZDbGRKRWdQV2JIQjg3QVRvUW55ZTBOVmFKajFhaXp4Mkpsc2Ix?=
 =?utf-8?B?dmNEbTVmeVg2UVZnUmNhMHU5QVgxSndabGFjV2VTTE1iRVZsYlZaQnhpS1Y3?=
 =?utf-8?B?OWx1bHpSa1BhU2U3dUxrTXJKQVFlZlJBa0FrUmVJRm1tNXZGYXQvc0wvamxI?=
 =?utf-8?B?dFJiOEN6S3VQV0hkVGV6ZW43aW1SUWZLL1lpQVJTelA2RXkwdkxlaUNpWHJ3?=
 =?utf-8?B?UE53ZkM0ajFoQzBydEY0c3BLb3JCMW93ZlBBdSsvT3U3eSsreFhld3gybXUr?=
 =?utf-8?B?WWh2U1gzaVArYjMyZXZjdTZJKzY4WElIalNoOGFNY0JDYTdMS0tKSFYvay9m?=
 =?utf-8?B?OG53cU9QTm8xQ1lJUlcrbmVoZW44SGZSUElHZi95WC9oQjlteWZYTU1ta05Q?=
 =?utf-8?B?THFwUHZlcDkydjMrYWtyNWlLZ3pNeEVhZ2k1WE5DOHVJQ0dwY0h3RGkxdTh6?=
 =?utf-8?B?WGxSem84QzcwdGUrK3l4SkdJZWVDTGVMYmJoNWpJc2tZSW9JWlB0eEhDVEZU?=
 =?utf-8?B?ZXhYR2lOUis4cGhDNFZITG13K04vVzNBQW5ObklnalJiNXdqSGsvMkZrZlk1?=
 =?utf-8?B?bWJYUnltVldDZUM2Y3ExcWFEb1lJTE5oaWtUWldsV21oTTR4WGVsUmk1M1F3?=
 =?utf-8?B?Ym5rQmFHenZ5QTkrL05IU0cxNFNOVjljUXZCVG5aOGxEOVh0c0VNRk42eVFh?=
 =?utf-8?B?bGRDZlkvYUdNdXlXOHcyZkxqUkFOVE9tVFJMMFl2SXFJMzJNSXp1c0dhL094?=
 =?utf-8?B?NnNIcVFUNkxYek8wNWZKT3JVa256Yk5udkRic0lPcjVXTm4zcXRDb3Boa2Vr?=
 =?utf-8?B?ay93eGdXTjU0NzhRcHo4MGczOUp2b21GK3VlWnQzU1gyM1V5VTdLWkJCWjAy?=
 =?utf-8?B?VnViblRKUGNTZFI5MHB4MC9BakpGZ3dieUdRSm9TYXI4ZDZiM3dweFhBcGtR?=
 =?utf-8?B?Nzc3cm02Q2t6Z2YxRWRJRVJCcGxCTzJMVU1oWnJ3TGFNUmdpOEgvWHRGZ1RM?=
 =?utf-8?B?V0k2eFJoK1pJMzRqMlpqQnRsYTViaEhhUlljK0dCTTFMc25HWlVNaTkzWXJm?=
 =?utf-8?B?QjJmektuRm5KeEFpa1k1c25WTjNpOU1UMit4bHVQQmhISFNYMGhpT0tWOTRa?=
 =?utf-8?B?aXFRUzlXTUgxSngxN0YvSUp5cjJJK0dVOEd2UFVqb3MxdURMeEdydVJoTGx1?=
 =?utf-8?B?SHE4TFNaSnFSenN4dE5MSzFRaFRnUTB6VGV2R0ZrWGhINWczei96KzdxQ3o4?=
 =?utf-8?B?aGhWRDVkbXJ4Zm5ETFVuRHJqbXB3NzhlN1Q0QWtDNzJ2N3NYNUhNT1lxbUhV?=
 =?utf-8?B?TDBGdTcvcE5HUEthckd0K01lekN4NXlna2VtM3kzSUpzN2hPV2RFelNmVmlM?=
 =?utf-8?B?MTFmMzZsTXR6Q00xUmhVeXlyUUV5cExRT3FKbVJxbjZOc1F0cUZHb21Mc1Vv?=
 =?utf-8?B?NGtpMHFyb1FSaVA2WXZ2anBMbEN1Z2NweUlmMmJKaDdlcVhUUDMvYUNqQkE5?=
 =?utf-8?B?RjdYeEJ3dGw1NjJjdmo3d3lYdmVVVVc3UkNNTnZCcm5FVDZRTVNDY0QrUDZD?=
 =?utf-8?B?QVN6emRvQWdoZFhiZXBHanlBM2RCb2lVeThtVHFMOW95UCtmUkR3Vms5Rll1?=
 =?utf-8?Q?tzNduCIVkd/t9/l4/l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25847913-61ce-4bf2-d14d-08de642849b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:02:13.3021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lm+JwNdYRQp/yhyarqU202BJ8T0M6shpFK+1VI0df7TffJo0FuXIotSetq2gtsV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB9033
X-Stat-Signature: 86krdyia6ye3gnbb7o3fmo1i75idtofu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7FF51A0015
X-HE-Tag: 1770235339-607185
X-HE-Meta: U2FsdGVkX1/Mg+9/NINnH1u4BVSGnCB+VbhaVRCHtH+T3lB1bMem6enI7VdybSYc2vr2g5QhI++Wq8UOmCG/gwjnv98NHEMk3oh/mJ08AY23Q2CHYk0E8NNIcwa4zOhR8AyqGGGyAOLGeeOk4jBOc063m9hTon1DvtCtkxMyD14Fyuv9wghsEtQbdvpX6kyzMLT71iwgwZXVLk2WVH1wDw456S/ErM4/CCSvikcvjzs0aLZUCTe0yFc5uoHVr3JCbmTReT4zjEJrw/OuifSnDExysA+vN8G0yEzkl06nN4ux01BCq1NHPjWkT4lgnhmAb8dwS1tLFxK9i+jvI4QJktGiVHqShAKz/BZSpKFg3ctt8zads7pCzI1Nx68V8yfQXyqQbhHKbyEOSegj5PmK5B1YVf8hdcuqOeWjti5d8ybQPHwF71Q9b6y/yviwQAh/nMcN1OOONk8VJTeEAYd7syQc3vKK40QlEl58+1YE0VXRP73rFsdK7W0Nq8TRMrU6ERz6/PdeMf7lw0t9zfWn6Tv3pZh95BWXb+fWJv4McUvFCV37vMtzy1Xa877xlxIraqoqwMcUMmVgNdnId5uIezz/Z+6yj/xQFn5DkeUCosY4WpY4f3z2bZMki5kt6bQLmZCJ531DTvLIr5vzsciCAjG2OFyZ4eQZWdPpyR1bf0kwhGk/AQeewZl4bsri5dsKAw3B72Q5s0Vq6+x1NpLWpeaBBjzaJMmjIc6A0GP6rIkhiDBLtbURnYGQjFSf+DguaHEyPlmY+3fLhns8zpsLkCHsY2evmFE+73Fd1jIfilC4OR9vhMVZsB2NLhx05vsfb87Z1rnivcNUocwlAL75ZP8Q37s2hJYcrMDv5vJa7vfaANhJ2z58vQG38K7Zm4z9Q4chiQBi65eO7ACmZgLt2zeRL08ruu79Ag2Q0J/H3H18ABTV3Zvby9oAAN7dU0IOlyFD5AqNCRZYar9TX7J
 PY6FFVd0
 QdnD8ikwL3hFibFROUBeeA9+tirt/gv79qwzMLO7145x4JmlQoQI17GnrNR3jHqBqDr+4sZ97QcH/TfQ9xIp3ehEcN0SL0z2JkeTtJvkMnYtFK3NoyleIasGdM9F0+eTJfY0p2ocWZYRl3yrT/BQoWqp8gfWqqbwwyRMm/MTXGN7gybAZia7fWxmaixLfE/3FhrikZwnMPUwnOsEw9KBmKwJWx7Vb2t+8eZqchhPy0U8BzmZ92dqYvECL+gEGVCnxTzWCZc0+pxuKGwt9maFD5RLDOyALel48K8LAG4pS8bZvCGN9VxLkV0LZwOJxB0NOvsk2IkFIpShRe4eTT5G5kuq3k6ytIEqXAnF2v3gcwG3NWv4sWVz54afK63B4HJ7s97SDvQ2OJ78xyH4jp4GCtXTjPfC+QbG60sAOf9ZIVBuBD1OCCmdoX15gA9MW9OHvN3qP241OfzetmaQVgbZ0OCCzWCivMa/X3O6RdsR/msYbh4ot/mPwY09+JScXRoErQTPaqX8wb4b5hRXuoY50MvUWTJaLGlb1oiiKnR70adg8xaCoPXW3TM/sP7J8zvjQgWUQlmLVsJpGiZ2H11a96yr2zl782I5FjggjPJtrjOegxmg1XyH0HnP1gotV9b8AvOWTdgufr0eRuYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 14:36, David Hildenbrand (arm) wrote:

> Sorry for the late reply. I saw that I was CCed in v1 but I am only now c=
atching up with mails ... slowly but steadily.
>
>> Without the above commit, we can successfully split to order 0.
>> With the above commit, the folio is still a large folio.
>>
>> The reason is the above commit return false after split pmd
>> unconditionally in the first process and break try_to_migrate().
>>
>> The tricky thing in above reproduce method is current debugfs interface
>> leverage function split_huge_pages_pid(), which will iterate the whole
>> pmd range and do folio split on each base page address. This means it
>> will try 512 times, and each time split one pmd from pmd mapped to pte
>> mapped thp. If there are less than 512 shared mapped process,
>> the folio is still split successfully at last. But in real world, we
>> usually try it for once.
>
> Ah, that explains magic number 513.
>
>>
>> This patch fixes this by restart page_vma_mapped_walk() after
>> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back t=
o
>> (freeze =3D false) if folio_try_share_anon_rmap_pmd() fails and the PMD =
is
>> just split instead of split to migration entry.
>
> Right, but folio_try_share_anon_rmap_pmd() should never fail on the folio=
s that have already been shared? (above you write that it is shared with 51=
2 children)
>
> The only case where  folio_try_share_anon_rmap_pmd() could fail would be =
if the folio would not be shared, and there would only be a single PMD then=
, so there is nothing you can do -> abort.
>
> Returning "false" from try_to_migrate_one() is the real issue, as it make=
s rmap_walk_anon() to just stop -> abort the walk.
>
>
> So I suspect v1 was actually sufficient, or what am I missing where the r=
estart would actually be required?

The explanation is not for the shared case mentioned above. It is for unsha=
red
folio. If an unshared folio=E2=80=99s PAE cannot be cleared, try_to_migrate=
_one() return
true, indicating a success. Yeah, since it is an unshared folio, the return
value of try_to_migrate_one() does not matter. This fix makes try_to_migrat=
e_one()
return false.

>
>
> (maybe we should get rid of the usage of booleans here at some point, an =
enum like abort/continue would have been much clearer)
>
>> Restart
>> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
>> again and fail try_to_migrate() early if it fails.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and sp=
lit_huge_pmd_locked()")
>> Cc: Gavin Guo <gavinguo@igalia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: <stable@vger.kernel.org>
>>
>> ---
>> v2:
>>    * restart page_vma_mapped_walk() after split_huge_pmd_locked()
>> ---
>>   mm/rmap.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 618df3385c8b..5b853ec8901d 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *fol=
io, struct vm_area_struct *vma,
>>   			__maybe_unused pmd_t pmdval;
>>    			if (flags & TTU_SPLIT_HUGE_PMD) {
>> +				/*
>> +				 * After split_huge_pmd_locked(), restart the
>> +				 * walk to detect PageAnonExclusive handling
>> +				 * failure in __split_huge_pmd_locked().
>> +				 */
>>   				split_huge_pmd_locked(vma, pvmw.address,
>>   						      pvmw.pmd, true);
>> -				ret =3D false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> +				flags &=3D ~TTU_SPLIT_HUGE_PMD;
>> +				page_vma_mapped_walk_restart(&pvmw);
>> +				continue;
>>   			}
>
> The change looks more consistent to what we have in try_to_unmap().
>
> But the explanation above is not quite right I think. And consequently th=
e comment above as well.
>
> PAE being set implies "single PMD" -> unshared.

The commit message might be improved with some additional context. The comm=
ent
above pairs with the comment in __split_huge_pmd_locked()
=E2=80=9CIn case we cannot clear PageAnonExclusive(), split the PMD
only and let try_to_migrate_one() fail later=E2=80=9D. What is problem with=
 it?

Best Regards,
Yan, Zi

