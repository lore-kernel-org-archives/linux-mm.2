Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB701E7E0CD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 17:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101DC6B0088; Mon,  9 Feb 2026 12:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085976B0089; Mon,  9 Feb 2026 12:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71096B008A; Mon,  9 Feb 2026 12:44:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D51F06B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:44:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74E101B29E8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:44:39 +0000 (UTC)
X-FDA: 84425643078.06.17BF468
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012037.outbound.protection.outlook.com [52.101.48.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DE66C0006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:44:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xh0vw81o;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770659076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+StWSfo3q8LT48k/si2IwWvgHy0Yk23+v4Kls3pjmTM=;
	b=UkjD+9sPpJMNaAdOL8u3qCQ0l9O5riiUvFEuYR5IFIkW7hxtp64xjrsSAoQcvgs4BCEp+N
	OnEtN2JJH+2mw9sA6hON/rQLjrg8goJKXe2S32299UCkLa4mreHRjpP7qkARBinCLZBsau
	Ffg3F5ymLYin7wPZRNUgiOpZ6ppXOEI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xh0vw81o;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770659076; a=rsa-sha256;
	cv=pass;
	b=5tePGavsRq8o113G91OKuJCnnWuMnyIrlm4w/D3YHhHR0X1xFI0qS2ewDcQ6NBfV1dhrg5
	9c28/bJWnKbQHc5jIlr4oPk7zCfEKyLAaTekRU9iZmixtajoaQlL9U1Xq8wh06fRhhmza/
	ofFpVIo0Z6eOIMozYGnSVTRRAfMAb5E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFfHfF41v5wlAlVikI+vWDJH11CLhYnpjstvI91/iyb5CQUH6QX5+vpChL4DM4NQCiS+KY7F0Je+Fb3q/ANv1hnPCghyMnWhlUDf3JOrNj7YJr/dS+BbI3RZdVRWRJrSaRoa5HFS44iVIto8mlMS0o9H0Uyf76B9VEK7Zxe8vBojwq0KT6ospgDApzuaXpSPsMcN5qq9eSc8WUB3VjkMfNXaPpwgCfRqauGeaw1Sdf3aAfTwiBMla7t17jBbDiWBD4qPPeUth+9yUQiki9eVZrXh7HkgzEo3fM4+KSSRELRjp7OO+51As8Ox3FgcmzIc3FhovCY4FCT3vztTQkh9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+StWSfo3q8LT48k/si2IwWvgHy0Yk23+v4Kls3pjmTM=;
 b=lW0gD9NcRhryfw+Cmcrr7AUcnCrUIznshuJA86DX0+NnG/BuM4vdZ5FrMcHutm819+6oCveSLt/YSFkJzWRzPZONXNSIdE1ArDvg3m2VScwnPAJEK47wDkWLamP4z1v0N1lfK/ClaK/K+Y2tplQs5ElQ+AQmOR47tM3JNuP4WqwPKmKNUnQoGRg5hGff6n7BfvuXLCSdykJqC4XDVjCr8JEPEfdRfChjcl8dVCNw4hyVi549qQuAbrXbor1ShC9qk/kiTZIflxeiVdqnO6TxGczRcF7fDwKL3zeRj0x5BoBjvP3ugGYghpiNlj6XOr5SJGFnKUHjtsV15UlNyzJ/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+StWSfo3q8LT48k/si2IwWvgHy0Yk23+v4Kls3pjmTM=;
 b=Xh0vw81od7w3W9VZvR3s7s8ivsvTtjXmHYP/Vj3yNYn2CL6hDq3pzwOyZDJUYXrika97tUKj+OtH+puhBn6C9Eet0JdgyvWP0yh4BCngSU3fhznYQUCYjGtamLqZcttau7KVO0R+o2CuGJSdGRiJKLIc6shMMo/Jr5tmpEU8vM9VDx/rOFQJLjnjlPr0Egj4vOuiZkIohQ7tdRCz6VkokaLcWV6OhJM5LMu2vRNObczRrDI/DhFCxtOOkfptya6Vq7IXEqzQca5bPWEYRgEImpNtRUdYfeLvEnD+lezWvAmvM3vON5XvlxcLOM56S0dZJYo674aJfGpCvbuoGNTDJg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7589.namprd12.prod.outlook.com (2603:10b6:208:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 17:44:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 17:44:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Mon, 09 Feb 2026 12:44:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
In-Reply-To: <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: 3249f04f-825d-44fe-d54f-08de6802e132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elhWRDR1Z1FPR1hNWllFeHdIOHBVbDVTcjNNR3R0L01RQU95OWhlbkdWMS9v?=
 =?utf-8?B?TlRBeTlsZURFUDBaYjB4dzFJSWdDY0ZkbTF1ejB6WTV6aFI0d0liUWQ5UVFW?=
 =?utf-8?B?YzZad01hRXdKYzBZR056YW40a1RQSjUrTTh6dDVIaW1OZVI2VmpjSXdIMms3?=
 =?utf-8?B?VnZKanA4TVJNU2RUdkgrMk10TWhwUEloUnNSWE55bmlSTy9mME9IM082WDN3?=
 =?utf-8?B?eFRYbFNQMDJJOFVyVlBuL25ZTVZJNTlOeitGOERCZUVQRTgrQUZYTjdnNE12?=
 =?utf-8?B?eHEyNFcwRCtRSFlTbUlycWJhR0EvOXIyTmlvU09KWU9KYVFUQ0N4N0kvUkt6?=
 =?utf-8?B?K2dvMmxqam5pNmNrOVFDUzFRb1pScW5ZSG5MaEZNU0hheWQwL0k2eUQxMjBV?=
 =?utf-8?B?eDhEcFdMVEJ4MmJoY25FQ2E2cVluRDYrWHJXcThCSUYxQVUrQnJCeVordkRB?=
 =?utf-8?B?WTVxcUZMVjdnWUM3L1RKQTA1NXE2VkF3ZHNmTHJBYzRRN08wQk0wajI5dWds?=
 =?utf-8?B?R2orWEhFZnpScGFBcm1rNXpzNXoxaHAwcGl3SkMrM0ZRR1g3alpGK1Q1RGN1?=
 =?utf-8?B?RXV2QktDazQvS2tMUCt0aWNjem44TVlORW8zaEc0SFRtZVdhWktDQ3FVK1A4?=
 =?utf-8?B?ODJLdTZaUHpnenFZUFk2dDd2eWNlSkhPb3VZbFZMWi9GUVZEVkRDSDY3ZDk5?=
 =?utf-8?B?WFBxb3dyWDZjc3RTNlRRellFUldEam0vK0hsbXBjdFJuWjQ5WUJOR2dpZFRW?=
 =?utf-8?B?NmpCRXVrZlQrTFh2ZmJHSkxLRFZQOVc2dHVFVm90cS9aN3AyblFIQ2pJcGhj?=
 =?utf-8?B?cDJKMWZKRkJCdEFvRmJsdm41Z2ZydTRqSmUwZzVNT2gydHpqUnplZkhOekVZ?=
 =?utf-8?B?NUdkeGlQT3h1SnVKSHdSanp4cUNZYmsvWTVHaE56cEwzSjBFTjlXdHRVMWNp?=
 =?utf-8?B?TkhqeC8wRTdweWg0ZFJuZ2ZwdjlnMmpEbjNhNDdFYzZ3QmYrZW5UMFJLZm5Y?=
 =?utf-8?B?eVNsbGt4eFpwZDFlSXFONlgva2lTM2dTWVhGOFQ3d09DL3ZVUFZ1YVFZWitV?=
 =?utf-8?B?SnNzS3VDTW1SSmhsemwzUzFkQWcxKzF4UFBKV1N3WlkwS0FPd0xnVFdwb0ZU?=
 =?utf-8?B?SmRENURzUkRhY1phY2ZHekVuVWVwQ0RUUkZiSUE0aXdlTmkxTUFQODcrWHk3?=
 =?utf-8?B?U1V2TVc3ekIycW5qU3Q2dzlOOEhmV2lWalNJeThWVEpUTGszN1cvSUdaVXdq?=
 =?utf-8?B?YWZpRG03OWJBREJlVmZzUXhGbm9GWGV5VHI2eXYzZy9uYlRLZHNrWXVxZGcy?=
 =?utf-8?B?ajNzMm1nTWtIeitZcGl0NUNkOHJudVRhTlovSWNkOGNENTNvWjNwU1hrMUtW?=
 =?utf-8?B?OGlRUXJ0RnZMS2NFVEhRd2tlTkhaMzFlTEtaK3FkaE9rUDFBTGR3alRVdE9h?=
 =?utf-8?B?cjJMc0hNMHlzdHVZNENYL2tVWXNKRXd3ZktBMXlFZitsblUzMmdXOUdVaEo1?=
 =?utf-8?B?Q3FvMjI5eTNIaFpvUFdDNWo3Qm9jS2MwUFpWQjA4c28wTlJvVkVIbjdmUUhl?=
 =?utf-8?B?MUNqcTVGcjQvTUV4dkFDM0d4VndPVEx6bkFBR0JpQXI1NGVUMjh0V2NaSi8v?=
 =?utf-8?B?UUZjRGh1M2F4dnI2M0NSZWNSdzhZRHkzTmRlQ2p2STdlbjRvc2RVWjBOUFV5?=
 =?utf-8?B?SlpkcHFGRmZwYzZuRk5rcFNvVFBBUC9DV2cxYVpoclVLd0hrRHkvS0lwSE94?=
 =?utf-8?B?cEd2MG1IV3kra3JuWldPSStzaFBkQXB1TnkvYmY1cUtnQ1pVNGxoeVFzcjZa?=
 =?utf-8?B?S2RqNTRDK2lIQzZyVU90dXplVWFnQlJsZ2RTQzM1TlBjd2tWZVdwRitVTWJp?=
 =?utf-8?B?UHhsQi9QbEhpbzJkc2hmOXFaVkNKZDFPbUNqZWoyT2loWFFrZGMweTdXbFVr?=
 =?utf-8?B?UjFyeGUrR0Qrank0MG1IK2pobjA3Ykdiei9NOGJRMGREYkxBZXZxQWRxTTRv?=
 =?utf-8?B?ME9SY3NGZTJsWHB5dVZBMHQwaTZ2R3FmUjhwaDhFYzZoRTNHcnpSMnFib0t6?=
 =?utf-8?B?NnB5VUk1NG0va3pIdElqbmJKd09UL0dFTkpoM2NrejV4Wm5HbjZMTlpCTVdw?=
 =?utf-8?Q?AU/w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWJJVjc4Y0FBdUVkaURFQjdEc1lzYkpOd0pCd1FxV2NFV1Mvb04vMlRXL0Jw?=
 =?utf-8?B?S1RINmpreFFaTXc1dXo1UjdQa0QwUzYwdVFxUFNiSjJDV2F2dlZ6elpLYzdn?=
 =?utf-8?B?R1BDUVNBNno1SThsZHRZeDdlZ2J6b0hpaVJzWTNtSklta1BsWkpLeXgvMWVU?=
 =?utf-8?B?ckFoSjdlUE1pWGt2T2FzNytwV0YwN0czMHRxRXlzUnNDOUU2TUt5RWVSTllt?=
 =?utf-8?B?SUxQM3lDN0xLQno0NWVjZDhkUXhteFA1NEZEb0U5MG01UldGQkhzZUJGeHI5?=
 =?utf-8?B?R3puckg2V0xCZG1FNnZNdm5Cdy9CQ2tvYnROc0pUcHhLVUZrYUVOV01OalRS?=
 =?utf-8?B?bnd0d0p6U1dGejNGeHU3T0huR3pHV21ESDRhTGI4SDNLcTlwYnFBUHNLaXpG?=
 =?utf-8?B?RHhpK1NPa1ZXWE5La0dUeWhrSmVRRHFOdUtBTkVFbjM4L0VTT1dhNGsxL2wv?=
 =?utf-8?B?WnZJRkI5QTcrZ1FqMFdxNUVJeGNNZ0NEZEhCWTFtNmxhcDlVTDFDbEJSOGhL?=
 =?utf-8?B?cDMySjFxa015dHhnUVh2cHlVUm11Wjd0dXRlcURmeTJoY1k1aFV1bldZUXBU?=
 =?utf-8?B?VWdrS3czMW8xa25lbFVVcWhzemJxNDdmeEFsRXlOYnpIenZwZTU5MjRDTVVm?=
 =?utf-8?B?V0ZrQW9STUJ3N2djd1dLMWVSMFFORmh3V2UwZTAyZW1NanpEVGpOZ3loUWFE?=
 =?utf-8?B?bzZrSzM4Z0lqWXdZQm5xYnRFZytBS1R5ZUtqTGszdHFBbmdIZXpmd2R4eVZO?=
 =?utf-8?B?SnlmRzQxd3Ztei9TQ3gvU2hhdzNhVUJIZ3lmbVQ0ZmVucVlEcTA1TktXYVU1?=
 =?utf-8?B?Y0NxWGVjYUJPWjh4VlViaCtrRElCZFZBWGExTXNPRlJ6RnhSTTlNYjFvNzMv?=
 =?utf-8?B?N0t5U3VHbXVUTEd6ZEZsRFh0N3M0cVRmZmlYeU54U3FxNWpHQ1dVdVVzS0Jo?=
 =?utf-8?B?Y0pXYjZIMVk0aUJqWkpNTnZGS3pYazN1Mm4zMEIvbEZaVnYxZ2lzUkdtR1d6?=
 =?utf-8?B?WG1QVi9tL2NyNk13WTllU0VDdTYxZTJPYWFhYmU3TlplNDZjZWVzOWxQNTFI?=
 =?utf-8?B?RzdJQTJxajFpQUxELytPQzlWb3duSTRCQTB5by9SeHBKNjdMUjdqSUZMVW5D?=
 =?utf-8?B?ZlEyWDdmR2R5aTFQb1l4UDRWWXZiNCtjc0tkUFg3MjIxYmlJK01BKzk0MXJJ?=
 =?utf-8?B?U3h6MEVPY2tHL0pMMmUyYUdRRnNIYzlTZTU1eTZqdG1La25QN013Ry9udXFz?=
 =?utf-8?B?OU1vbms1U3NxVzRwNFcyZGdacVhXMWxuNlZNbU9DM0VFVFJJYXh6ekRHZmd1?=
 =?utf-8?B?clZSTjV1VWEyRExKTnRKR2xKa0xiSWJlNDU5MWJBeVBtZnRnaUdNcVVFQitp?=
 =?utf-8?B?WjRBejJES2tQSHI1cU9aem4rSGFyaEtpNTcweTNUVzNla1U4UWxtcmxLVjEw?=
 =?utf-8?B?c29BejF6UlFWOE9CbldhQnNEMEFxeXZEdjVkekJ1N1RxNjAwUXJhcGU0ejFL?=
 =?utf-8?B?SGtDa2pKWE5meVJmTmg1cFJiVHlVb091SVhVbVFyZ3lGZnQ5U202c045MG5n?=
 =?utf-8?B?SzFFNU8ySGlXVEs4MjQ4VGU4aHR0K3ZZQlF1YksrUmlWbVpoUE1BTU1CL3Uv?=
 =?utf-8?B?SXBOcmQxckhWektIVUNBMmVXQnA5cjNMeDVXTnVQbG1keGZYbnFrbmhnbzJs?=
 =?utf-8?B?THhvS21aZy9RWmVHTWczV29KNm9UUUJ1NjBNUXU4RmNvMHliRDhhWUdwUlFQ?=
 =?utf-8?B?aUt4M3JpZ1l3T0RKSmVINDl5b2ZrWFVRb3hBWUo2Z1FjN1NNNy94Q29Td0hG?=
 =?utf-8?B?QllsNEFPNWloOEZKRFV0NUM2L2RuQzlRQVVnc0VGVXZWVlF3aUh6cVFjQXlE?=
 =?utf-8?B?ZWhGeE1qUlkrcnlBL1Ayc3Qwa2hlZ0hFemVDU1JrM3FvT2haWmh6Q3hZUGI2?=
 =?utf-8?B?Mnp3SHBtcnNPVnEzazZPOTY4YVhic1RTZFdmalowMUxJYVh4K1pnZTBnaGxL?=
 =?utf-8?B?dEwzbk1FZW1YSWo5TWdkMnQ1Zm1zTzQ2VWtmN0J3V0c5Yzk5Um5NSGhXdW9h?=
 =?utf-8?B?dTZnNEFIZEYrb3A4cm9rbU9kdy9nZWIzSXM3SjZhSlRJOFVNYXJzQlBBcjFT?=
 =?utf-8?B?aFAxYWVSTE1USGNuZ1FkYks4Zy9lanFLR3E4UktiNWhlNXVMcXlZUFhVWkNu?=
 =?utf-8?B?azl4QlJ1VG9WYVgxNFJNQ3hVSlZmbHBkSnltZGNvYVZYdWcyd001T0NSM2JC?=
 =?utf-8?B?SDAwWXpGNDh0VHFYcCtjQm5LY2lYTnltaWtHYkZLbzlkWnV0VlUxQjJhU2lw?=
 =?utf-8?Q?HtrbOxjCm25tJbwLyu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3249f04f-825d-44fe-d54f-08de6802e132
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 17:44:31.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XnK4O+H/ipfVTu+/VHBR+ptcHv7XDIwI2Tp+GqD8hk2DzNQUmVlEsV6owNXiftci
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7589
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DE66C0006
X-Stat-Signature: dr7sqazsn3ymhoyh961hs5oit8txe8bb
X-Rspam-User: 
X-HE-Tag: 1770659076-694199
X-HE-Meta: U2FsdGVkX1/fsbHZMzPEJunCzfUzysPUyKPWDYjLFL6owSiEtuvPTMH08HWO0rTKL4GNTyxNu7Xl2ZqL8ONRkUoeEVsyQ9m1JgHT0OetWd7N9TaI3jEZXt8IFXPt3dfTq2/boBiDjzMkFuV9+J+CYbpugHr6b7ZB1nLMCUYgV1I7nTDy2rOxQJ3EEJO3scy5mfD3S7nZ39fC9l7w4CFf1gIo79myXBPXqIRc31+33SX2Hg1ZGNqDnv9UweCR+54I82GKV8+Ypftb9aru7EPqOPTU/iiOR5RDOvbRJ78ffECtkXn7FHB2QWmgYFTh9ghERwFUbWts338lls4pl5kneeOh91ucS1yMUmYR8jj5eHVDRuiaSLIbCSxCBTYeuavOZEas7eb2KVK7/lWpSaDGuyvcVYoUbfGwZbPH1mdXCj8PodhqYu/4BgkML21KFVWpVqqAvNYyy64Um730NnwYrGxiEwTlMEcJcWT1SfYlpq/VmerF8Cq9fN1FvAi37KhLixqZ+Gdd7gpjh5Mg/tuBHVAEwHqJ1ow1BYeNHH9iKVGD5lXTpWWXC8k4VhYQ4aZsLHySIhIExBe7RtmyIF8K2KVUMGHu7+4eEST2EfsqJ8G79xT/BFW5b0yUe3S7R9ZqQDpQQIG/tppSMtk17/gSIRl8H2m5M57u0PehnmPGsf/6RyO5FvQ1zrDg61o9XM9JcY9L23vSEH0sNfCt4Flp4qG9RON9Od/mT2dRhepwo7+Jn8FCueVIJwsUhlbO0tBZY+wLuPJZLaG+OprFXq/UsMFbleYphx+X15x2fMy+GjiABWlqocTDHwig1cnt6hID8pAzDpl4LrUiOYXtA2hw2ZFFtI+h/DJHzRKFjuyzcylkmUUKhbZonPAZv4IPM9eIpkNqIuKsvavKuUscSDJ1sSrxhs0hgTlSMuA3HMdE54bhajHjEt4Lnpqxa8EwW7OYqQOuAPYFYiIIB1fAu2P
 Y63Qle3d
 8LfS3skshJy6GaNr21UcLeZqZTT6Uv2/gGlPNvvkWT0f3ZZQnxNyWXmz4tYU6qAx01aGYah2DroYplDh605Awps77Manfus17ux3KHdpmuHSeg3qAfoKVOTnpk29tcq8XNkcffvHQDs8BZ2lSy3BP0iXg1pUPpngu5rzLabPa+c0+kDzeB2C0xEjkyA7EqbbX2AwJxroztU/x2t+y/nE2X7wriLcZbQpHweQTq57n/pcBX2Wp+BhdbWaTbL6o/RZ8/m3Excwt/bb/k3pHAJftwRYgePNWVYU9tc0TwmOUeFBKT55BsozOQxsRA9kpnlgYvWdlIeeu3OLz9W4X1/531w+tuxUGJDkk2nN6vi4mevn4w4FgvsH7b/nRu+KygH4g1/usiHrG3fqnbGzZDfgPwRHr3KRamynf7r/OOhoyrk4eHCz8tE/tYSXzit89Bn1yz0tauSWNefpKppI2s7R4i3NMV/sVLs+Ne7NufAuwbCBC4r43V78SW3yDbbc2v+bs6IgQjEYDklMtZVCfl5GxynRx9R7Am8POuSeB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:

> On 2/9/26 17:33, Zi Yan wrote:
>> On 9 Feb 2026, at 11:20, David Hildenbrand (Arm) wrote:
>>
>>> On 2/9/26 17:16, David Hildenbrand (Arm) wrote:
>>>>
>>>> Right. Or someone could use page->private on tail pages and free non- =
zero ->private that way.
>>>>
>>>> [...]
>>>>
>>>>
>>>> Thanks.
>>>>
>>>>
>>>> Right.
>>>>
>>>>
>>>> Right. And whether it is okay to have any tail->private be non-zero.
>>>>
>>>>
>>>> Ideally, I guess, we would minimize the clearing of the ->private fiel=
ds.
>>>>
>>>> If we could guarantee that *any* pages in the buddy have ->private cle=
ar, maybe
>>>> prep_compound_tail() could stop clearing it (and check instead).
>>>>
>>>> So similar to what Vlasta said, maybe we want to (not check but actual=
ly clear):
>>>>
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index e4104973e22f..4960a36145fe 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -1410,6 +1410,7 @@ __always_inline bool free_pages_prepare(struct p=
age *page,
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (p=
age + i)->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_pr=
ivate(page + i, 0);
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> Thinking again, maybe it is indeed better to rework the code to not all=
ow freeing pages with ->private on any page. Then, we only have to zero it =
out where we actually used it and could check here that all
>>> ->private is 0.
>>>
>>> I guess that's a bit more work, and any temporary fix would likely just=
 do.
>>
>> I agree. Silently fixing non zero ->private just moves the work/responsi=
bility
>> from users to core mm. They could do better. :)
>>
>> We can have a patch or multiple patches to fix users do not zero ->priva=
te
>> when freeing a page and add the patch below.
>
> Do we know roughly which ones don't zero it out?

So far based on [1], I found:

1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overlapping
with private);
2. __free_slab() in mm/slub.c does not zero ->inuse, ->objects, ->frozen
(overlapping with private).

Mikhail found ttm_pool_unmap_and_free() in drivers/gpu/drm/ttm/ttm_pool.c
does not zero ->private, which stores page order.


[1] https://lore.kernel.org/all/CABXGCsNyt6DB=3DSX9JWD=3D-WK_BiHhbXaCPNV-GO=
M8GskKJVAn_A@mail.gmail.com/

>
>> The hassle would be that
>> catching all, especially non mm users might not be easy, but we could me=
rge
>> the patch below (and obviously fixes) after next merge window is closed =
and
>> let rc tests tell us the remaining one. WDYT?
>
> LGTM, then we can look into stopping to zero for compound pages.
>
>>
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 24ac34199f95..0c5d117a251e 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1411,6 +1411,7 @@ __always_inline bool free_pages_prepare(struct pag=
e *page,
>>   				}
>>   			}
>>   			(page + i)->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +			VM_WARN_ON_ONCE((page + i)->private);
>>   		}
>>   	}
>>   	if (folio_test_anon(folio)) {
>> @@ -1430,6 +1431,7 @@ __always_inline bool free_pages_prepare(struct pag=
e *page,
>>
>>   	page_cpupid_reset_last(page);
>>   	page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +	VM_WARN_ON_ONCE(page->private);
>>   	page->private =3D 0;
>>   	reset_page_owner(page, order);
>>   	page_table_check_free(page, order);
>>
>>
>> Best Regards,
>> Yan, Zi
>
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi

