Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8193CCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3508E00AA; Mon,  3 Nov 2025 11:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A628E0057; Mon,  3 Nov 2025 11:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88B18E00AA; Mon,  3 Nov 2025 11:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0DBF8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:34:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52A071A027F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:34:59 +0000 (UTC)
X-FDA: 84069845118.19.AFDDF54
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4AF7D20011
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:34:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mtoXNbRp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762187696; a=rsa-sha256;
	cv=pass;
	b=NMCrZTR/8rsLytPdh8OsWOGJovznJGEW1PN8cBvd0yoHF1NGAhp6bk5Fkljfx99hwH5Mww
	FArNQyOJj+WV6Kn9dGiPHMlMWowCiEWaY438AzAkvg71NG6IhlmpI5fXJkfl9CI9hSt9X8
	tLU/3KbLOF/O1I0dUoBOW4rifLv8H9E=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mtoXNbRp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/dAprNYarKOl2zXWWD+BfSsfBuZVfyCBQUNp9/BrdE=;
	b=2LQTzl8+h42xkhyLj8F/5lgCJ6n8cd1kRkHBUEhM7N1o2z8DaXA/5upHB8rBi2gOfaSHd/
	JIyGpUFNATaXcHo1Jlp0gY5DXOIHgWAvX5HE4hu8ii/CGVB3+eK7LFcbT9lloe96XKPAl3
	VBLjS5IAfprMji/2Z052Xak1vsLOOsU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOFxbY0gd2pts6CW5worBQECehFm9Ebk8vRSjsqiqSDctLfGdM0egGYkgDf/E3Eu79LnGiV+TDt2Za/VYSu36pCmTkDKbAalgzr4FV1ZAdNu60Pwz2x3k0uAmUWmVvR0tTVFl4NFBFTR/olcnWwdtcBAnSMuMMvHeja2bg7U60XDdcAmwbaLlUwKOjvYRbn4bnDHcGGMNjZNujjdyqW/qQbM8V3YEWKVdM1NqkoaqpiIRd9WC7KkO5rn+I0rLhGWQ//HrLPk4RU6AApDaOUwLcjgglrozPhbfppdrhzym+/i7XllJssXqHRDk7SQVmASlKLkEBt1zAW/EjbSE8qdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/dAprNYarKOl2zXWWD+BfSsfBuZVfyCBQUNp9/BrdE=;
 b=vpxGHcmPeFjyhhvRN3Mcbe8tA79m3w4lOLcY0LZa4vkzewLxt1yj95Hjdh3XPxVEv91JDQKG5Ng/9q4i/yJOaoiEo/wJnLWAatL5Cw3hi6INRhLPrGq0dbsXOSGgC3QSvoTWPbqXAlDo2uhSlO1FBX/msHMu0phBRJn/5Jkqa6ffzNgvN2CW5qdySBrJQnGYSIJ5tVM4tQjXmkNm1/1aA1Lksz6Zg5bb8QsPTmXNylAf5AFzMcXp61vtXLkmWgU+03XuiDgCo4qzwy70CQqJmWwcWt5F5cL1ZwrJVGBdchT3WK+yTXTKARztf+s/AvnvwElpcqHobM85MxC3/3Hegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/dAprNYarKOl2zXWWD+BfSsfBuZVfyCBQUNp9/BrdE=;
 b=mtoXNbRpeInOaO56TOSMZmUyk1ElQc+Lw1TWops+YZT3pCWp8zoGeo0vT2qRqS9AhLuBjSA5xUe5s3aAbjVBEvO8YWaug2ZJ/DGKtzAZeCkRr+42fkbqo2IA5zoNQkzzOffeXSZLvL29Uk56uCAl/7k2LmBxYxX2vVqUPDc3WuJAf5fTwsPoTBZ88QO0WxgXFGG52fMHt0EzNg4oidfEqqnV6YQmTyYiSuKUFgFVBMguwxqbiaGcYEKOYjt1LRAeH+kWT5TZ0CNQXJuwWjoL1L6112+4m8i3QofLiqE1Pi+/gCErAhxmpK527u0mjb2HLES930uCGOWlMYrnujyycQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9587.namprd12.prod.outlook.com (2603:10b6:8:282::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.15; Mon, 3 Nov 2025 16:34:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 16:34:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Mon, 03 Nov 2025 11:34:47 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
In-Reply-To: <20251101021145.3676-1-richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9587:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb481c5-3ec7-4740-b783-08de1af6e8c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlVxRWlzU21UV0JvQUgrSERLZlVtelBUSlVzVm56NExUTFVSSkhGUGcwaERO?=
 =?utf-8?B?MUE5bzlIMk1MWk95U0VraThqUnRXQjRrRWxabU5adjJ1N0p2N2Z2QkhHYjVH?=
 =?utf-8?B?Z3pHSHN0MW50L1lUZUQ3eWNZQXZhU3UrNVJrUUxBamc2NzJpMTVuUGFSaHRE?=
 =?utf-8?B?dExuSng0eUNqQXBFRk43WjZRVnJGMDdMd0tjeElaRnIrTUhTcml6Q3BFQXVO?=
 =?utf-8?B?NHVUaFJaT2U5a2Y3Nnp1S1N5b1BQdy83S3ZwTHZ4ZnV0M3BXMUFoNENKMzBo?=
 =?utf-8?B?OGcyeVYxTkF6dW4vNTN3OVEyTDlBN01TYVVNZHdJNW5uQXlCbWFxYzUrT3dl?=
 =?utf-8?B?WVN2U3NVaEY4aEJJR3MwdVlXZjNoT29ReUowSlNqc0ZDaVoxWldlczFwY0dt?=
 =?utf-8?B?eUVxVG9pdlJNc3Rod1VjSXlNUGQ4RWUvVnJycnJKdGlkL09kOXdSVDBqaXJQ?=
 =?utf-8?B?cTVwbmRkVGg4RWMyd2xTemg5T1lRVkRRRXRBWUw5c3R3aEVraDlJa05mWlBq?=
 =?utf-8?B?UVIzUm1PZ3RsNytMU0t4N0ZxVmVJK2tCS1FwbDFocnp3VGwwZTlGWTg5L0Fh?=
 =?utf-8?B?OWF2VXFOc0hwN3lKYVM0YW10dDNwTW9OaEY5dTcxa2Z2c2N1aDV3bkZYeHJS?=
 =?utf-8?B?TUpPTG1pSWZ4azkyZUQ2eVZna09DditlcUsvY0l4WXhNNHpWcHJ3NHR0OW1m?=
 =?utf-8?B?Wm1OdUliV3Bqb3FUbW9wWjc2Nk9HM0N0QW1FMkJESWxWdEhMbFNIYm9GOFR4?=
 =?utf-8?B?clVjSTV2WXN1ZlEzaldEM25ya1VuYTFvL0ZuQUhoMjM4R3RGTGdmQzBZaHdS?=
 =?utf-8?B?dDNKSmpKdWc1K1JJSFcyYm5zYnFaQ2VtUTJsUVZjWVYwZG15NE9xbnU4ZExl?=
 =?utf-8?B?U3l2dG5qNkZRQnl4K2ZBQm1MS3FmYkl3cVllaDl4d251SUtuTFhFZmo4UVBq?=
 =?utf-8?B?ZERwMFcwMjBjODh3YVNPTkpzMFdUaGt2QzB4RnZKRzNHSm41UkpxM0JmQkM3?=
 =?utf-8?B?MWZITC9WSWJiNVhsdG9OeUJiZ2tFSURFZ1UwTCttdmJYTkZJWHNod1dyeEJP?=
 =?utf-8?B?eFVOVkJPNjNPSFd1ZitiVGNzWE9ZTVpMd1pqamdmdjVLUWp0dGF5bW9jaTR4?=
 =?utf-8?B?UkdGVFBJODc3L3ZPaXFNWVZXbHJqNEh1NW9rczg2TDVMeE1UTlVBam5ud2h0?=
 =?utf-8?B?WUhIRk1IdnJMMEVockY3VTVxRERvQkh3eWlnRXR1MWtKdlBIanZEM1ZWMWgv?=
 =?utf-8?B?dGpRSVo2NVQyNjdTUVViZ1ZHNmtJSDBCTE0waWJBQy9mbWo4ZlRwWVQvaUFp?=
 =?utf-8?B?MDNzT25VeHZ6bDQxelRMck5MUmJtRkd6NzhaRnlRWDUwSkZ5dkZUT3V4WVhn?=
 =?utf-8?B?VldZZFA4TlAwNGlYMVgrSm9vT0NMRHJWeStEK0UvN2tndkpOelhUOGRWT25H?=
 =?utf-8?B?c25wVzFMSnFxTHV5amVaYVlvVWx6Zmg4aXNJaTJxMUlWb3RISnNuR0ExRDdq?=
 =?utf-8?B?RTc0aEZCbDRzZW9rcUptMGtRblQ0WHE4Yzd5a1krUlhSMDFESm5NQ1RuK2pk?=
 =?utf-8?B?VXhEaU0zUjJyN1R3R0dhelZvRWJ4cDQ2M01GNy9Oa1NMa3lYZlhnQkw1YW16?=
 =?utf-8?B?S2t0R2MvWGVEWG13NGduUm1OWXpoeXFLMDk5TUVLQUlzbExSWG1qaWkrb1Ra?=
 =?utf-8?B?d2k4Ly92dElLdlBQYmtXMVZHMmhqNk1UQTFxT0tPRHlheTdoZ0o4dlR5TTl6?=
 =?utf-8?B?ditCcTMxVnIrdWpvN3FiRVVUSy9lekRTMHk5ek10VU9yTXBDQit2OUQ5SVJU?=
 =?utf-8?B?djNVc2tQR2pmdURtRWlzWHArcUpMTEd2SUJFV0oxSWg4NzgyaitUUmRoRVBS?=
 =?utf-8?B?em8wMHpjZ0xsKzZtTjlqSzZKQWViUHp0OXNlbnhpYWtmNVY5S1lpSFhxeEFD?=
 =?utf-8?Q?BqXlOSk9EL671SlBj/Oa7ZJkUBnA33rl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFN4UTJNUWN2d2M0ak5nbmZ5YkdhZ2NRU3VMVHd0cGNKdG5yU2pLN2wwWXBR?=
 =?utf-8?B?dDVtSUdGc29pYTEzUlptQ0szRWpLN21aUm56aDZLbkFNbjh5RDlnUmtkTmow?=
 =?utf-8?B?KzIvc0xVeGRUcTl2Q3N5bnZUU0M1b1RhekI3QmM1M0dLZUUvMUVad202Mytz?=
 =?utf-8?B?amFTbldMYXNBUk9rVVJGZGttMFJTWlRnNWI5Um52Tmo4UUNHMUxpRUlSRjhu?=
 =?utf-8?B?Rm80RXZQR2xUMU1TRmp0VGFNZFJCMGRqcEQ3R1p3QUJEVzRXcEViZTU4UGlj?=
 =?utf-8?B?THlCTElxOHpoNTkxRW1NNkN6UVJ4dEZxRDA4OWpnUGZIREh5OGlFL2lNNDdN?=
 =?utf-8?B?ZTIrM2JIc0owKzVCdmRpNXlDNnBYTUpYOUVlOTJlZHZEeWYySFdMd2Ezanlv?=
 =?utf-8?B?eXNjNXl2WXg1bWx5YythT3d2MnVVVnRySUNUUnBrK3pOSnE1WjYzMzJ0bU1M?=
 =?utf-8?B?M3NHVWdycCtkZkhkdTh3bGFyYURBUU1xUk9LdDU0dzJWM0tRcFN2L2NweG9D?=
 =?utf-8?B?dFlGOElSVVNkTlM1bmNiM3JUQ0JoL0NicTlnbHN3bTV0cW9PbkIrN1NtYmY5?=
 =?utf-8?B?cnVvSUt5aHZHeitTVEs5YlNHVzR0WFN2eGpyRCtkVElPL2ltdm54VXdsYVhi?=
 =?utf-8?B?akMzekh2d29YK2FzVE9CRFEyZ2U2MVVZVGhsRThpSkZzUVpwRlpvYUNFeWpm?=
 =?utf-8?B?dTR0TTV5dkJYY1MzejZuQzBVdXZoUGdVVFZCaWlTeGszRVdyN1lSb1MvUXh4?=
 =?utf-8?B?eDVEZnZpSHpiNWVoNjRaZWs2RUJLN3pHZHd3MGtvRnhiS1BYdWJLU0Y2YmRY?=
 =?utf-8?B?RjlQajVGSjZudFMyS2Q1RTlMWUZoMHJ3SnZTM0xCYWYxbnZaSEZlUWNJb29y?=
 =?utf-8?B?czdzcExqNXhYSE9aNVZEdXNJS3MyYmxVdTVxUnlZSVhpWUduayt5Ukk4bE1q?=
 =?utf-8?B?ZEpreG5RQmZLUy9YVFMwYjc2ZXp2V3ArV09QVnhGVlFVNG9Dc2dmdURPdlJC?=
 =?utf-8?B?YWlMSkVvREFkWFhqd3FHcGowcER6RkZzTk5qNkJsa2ZFRDdYSHdwektFaHRE?=
 =?utf-8?B?aCsyeHZpMmcxS0RudWlpQWlZMkl1VmhNc08rUFQ5ankyU1c4VnNpc2hGQm4x?=
 =?utf-8?B?MXhqV2pGU1dDTlpsRFlQN0JQQTJUSjNjY1QrSVZzWXZNc2ljdHVJcWk0NUtm?=
 =?utf-8?B?MXZ2NS93bElZK1pKQm9yTUE4STRKUThxV3RHNitiZURSU2ZFdVR0WnJjOHNq?=
 =?utf-8?B?ZVFHNHo4TytmUWdjdXh1WklMaVFiOEJhL2NqbG5YYVN0dGh5VGpvZzVHUy9K?=
 =?utf-8?B?bWxNdmJyTS9uc25DNTRBMnRSVEQ0dkZ2OXRQZTFOL0hOcldXMUNxZC9QT1VX?=
 =?utf-8?B?Y1RmU01xS282T2RHb3p2U3U3bk1CUHhLY1ZsUURGWkQxaTNja0pEMVdIcHY5?=
 =?utf-8?B?OENnamxRWW1LejVUYjQ3Uld4VkdTOHF2ak4yZmRPM2xtRGhEQ1dnM0RLU2lw?=
 =?utf-8?B?MHZWQUdUVWs4Y3VnZmRscDRoZlhrMG5MSlFwUVNhTWNnVDRtWEUxRDRRVVA3?=
 =?utf-8?B?cGJDVUdjT0FuM05aTm01d1hNNVh4NkRlT1ZPNTFCY0RIbFZGcnB2L1g3TkJX?=
 =?utf-8?B?S1BSU3hMQmRIZjE5VDFjNlo0U0E4VUVvTDU2ZjlhTWlVWGdPaUxxMUM1andN?=
 =?utf-8?B?TGxLZWIyVEJvNkd2anp6TE42L3EzRk5NU1hXSm02bjZIa1pjc21nc3Q4RG5D?=
 =?utf-8?B?WmlnUE9XdEcwOVluWDNpaEpkSW03TzRPSGVuUzZKb2hBNXpkM0NCMWlHWHgr?=
 =?utf-8?B?V1Flb25tcmttcDM0TXpsN2hZT1lpU3FHWDRQV3ozYmtXTG5SNVRGcXh1c1Zv?=
 =?utf-8?B?WGNURHR0SHMwNTNpNG10ZEtuL2U5U2I3K1VVOFUvQ2MrVisyNzZVU2k5cHBo?=
 =?utf-8?B?M1NHN3Jld2kzU1dzNHZBeEUrM2tndEtmemxqd3NvS0d0empzYitjbExlV2Vj?=
 =?utf-8?B?WFI2WENGdzE0akpOTnUwcXZNSDNZUzdUR0ZLeFNnTTdwNUREYjVkdUhpaDlF?=
 =?utf-8?B?YVNiSEJ0LzFkazd0a1Blam5CRWhQWDlMTjFQTHlEejNIWVp4eld3bE9JakRu?=
 =?utf-8?Q?TViK0hF0avjtoELAjj6UgSOUj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb481c5-3ec7-4740-b783-08de1af6e8c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 16:34:50.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPzO5+oKFzTUQfs5zj7RuwDxOBPu4mfaPOD541RU4ZAJhIayGgHjgAJGfoQ3GxPw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9587
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4AF7D20011
X-Stat-Signature: q3dth8fn6han1s94foy4oykxh79ncuma
X-HE-Tag: 1762187695-331526
X-HE-Meta: U2FsdGVkX1/fV++EynK4bcWDjqgGq/FgiWrktb6gLYV1Ym2tYmBasB/UPWblj4r13VBNeKzBsSqBl5jih0anEorm7Jdln8kipVTAwPjJn6eS+8tyFq7wNhkCWUjQ3NcJe6GAWaK5j+VDazJ2XemZTRo1ECfLb2RSiZjJ/0Q5NbHDNuTiLbvve82NpGIYKCo9DeKs4PG1l+z7fa9dOc7/d9Oy9ApkPCjZitiial+gVyub4fceaIfryvp2UENcFzd0i1KpHb1ZfL+/SqAte8E+u/SzUcSMsTyDJiEYvFBDyiK4CnZjfwZZJJ3tBEzqfy3eI2HdPM6axn3wolOiO0Q2s5WJFYscZROgc10vx8Tz0oXTthBLrFZWgaEdDpDBsiRtF/IDeaQBNhjHw+iYfNSbavaOC46B93UjhIEHLkSyiFVD8o5OvaKLmRgpde7PjA1SqtEV6jrchxdtfFvx3HM6WjFlNwh+BNBNnq3OIS5xjG+16Nsa4bM0R1W213W3IDTekuKnZF2MvcLz7Ievv6k9f+498Ma8n+R/giisIBDDNkknEwzVoBBvOjptQm4MofM/HpVZQfYFSos0s8hlys+9bcrYxfnGFLw1lHQAWkD9MvfDoP9PR2js7IOHc3hUb18wAwqvbRa8Jf2ZRMX7QXamKBDYIITauDakdzCnwJEFYQHKZfgrrxQClthgehKU2PnWIaOwfJW3K6GteB51r6yBiyHDiG4Crbrwn8mIbfq5EB9yHvyUORctQbRMBmjIQKeHGn56DUgQl423c/Z4gI1HSGm7iVx8GYOdX2+GBryDI6EnMX1K1VDHWGwdFUOT3S0q93z7+4o+KGNuBx69ScW2fu8YKg19BbfN1URJMPMttE2DAgu793GwP7glRSPVAhbJMtrTj0p7e1c0u5lxEGaPFAFQzg6wb7gGRPuekDCtTgwKewug+VS8cAE4Mx66vpxvqmSOUrnSwBMyGXJMASq
 5U9nETJX
 NjaBTNxq4n4Z8OdSkc3ndvhRoB7steYTTb0GE50gG5ICcd2GibvAZKfLM6A0EPUO8rl+IVup89h8Vd9lPvf4kBPuPRLe0ONZ9gVBPjsEX7zhz+eP04Frb1h4PsAR48ndHGwz19buC6JSjmahooJLldydEDRbBD0xtQfaL1MoPJwHtFMEdSjsMMfu2Hck66JSylMLI9Y8izeKDH5GmRMXIK2ImEKIQr0rtIN80RQu72Iak+cERoTWRhCrET7hhXOUFI59SqiF/5zPfYbP3BviofIJJ1Q5eS5KEK4XE01X6tFXeE+v5E5H2waq3IKgJfExXGKX/74XUyMdPShdh4HaFCO0dsiLLWmkrPsH8ylT2Hdyohv172HMpR8+2oziuhQeJh36CYhlccS6Dcl7dViBu/nACQ6h0HgKyvkrf31l4ObQk1thAxvRnmtTplmBNBgQz5zbyErZ2pmed4bT9t8CIMRt7BK3L103Znu3yki8ZWeoIypZd137g33rssTOUg3gXtDCX7j1DxPWXJLv7h9b6rwU0sYBum1bJ8MGU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Oct 2025, at 22:11, Wei Yang wrote:

> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
>
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order before

Please elaborate on what the check is for.

> proceeding with further validation.
>
> This commit unifies the logic by introducing a new variable,
> @need_check, which is conditionally set based on whether a uniform
> split is requested. This allows us to merge the two functions into
> a single, combined helper, removing redundant code and simplifying
> the split support checking mechanism.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h |  8 +++---
>  mm/huge_memory.c        | 55 +++++++++++------------------------------
>  2 files changed, 18 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index cbb2243f8e56..79343809a7be 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *=
page, struct list_head *list
>  		unsigned int new_order, bool unmapped);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool uniform_split_supported(struct folio *folio, unsigned int new_order=
,
> -		bool warns);
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_o=
rder,
> -		bool warns);
> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
> +		bool uniform_split, bool warns);
>  int folio_split(struct folio *folio, unsigned int new_order, struct page=
 *page,
>  		struct list_head *list);
>
> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct pag=
e *page, unsigned int new_o
>  static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
>  {
> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ false=
))
> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D */ fa=
lse, /* warns=3D */ false))
>  		return split_huge_page_to_order(&folio->page, new_order);
>  	return folio_split(folio, new_order, page, NULL);
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
>  	return 0;
>  }
>
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_o=
rder,
> -		bool warns)
> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
> +		bool uniform_split, bool warns)
>  {
> -	if (folio_test_anon(folio)) {
> -		/* order-1 is not supported for anonymous THP. */
> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
> -				"Cannot split to order-1 folio");
> -		return new_order !=3D 1;
> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    !mapping_large_folio_support(folio->mapping)) {
> -		/*
> -		 * No split if the file system does not support large folio.
> -		 * Note that we might still have THPs in such mappings due to
> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
> -		 * does not actually support large folios properly.
> -		 */
> -		VM_WARN_ONCE(warns,
> -			"Cannot split file folio to non-0 order");
> -		return false;
> -	}
> -
> -	/* Only swapping a whole PMD-mapped folio is supported */
> -	if (folio_test_swapcache(folio)) {
> -		VM_WARN_ONCE(warns,
> -			"Cannot split swapcache folio to non-0 order");
> -		return false;
> -	}
> +	bool need_check =3D uniform_split ? new_order : true;
>
> -	return true;
> -}
> -
> -/* See comments in non_uniform_split_supported() */
> -bool uniform_split_supported(struct folio *folio, unsigned int new_order=
,
> -		bool warns)
> -{
>  	if (folio_test_anon(folio)) {
> +		/* order-1 is not supported for anonymous THP. */
>  		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>  				"Cannot split to order-1 folio");
>  		return new_order !=3D 1;
> -	} else  if (new_order) {
> +	} else if (need_check) {
>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>  		    !mapping_large_folio_support(folio->mapping)) {
> +			/*
> +			 * No split if the file system does not support large
> +			 * folio.  Note that we might still have THPs in such
> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
> +			 * that case, the mapping does not actually support
> +			 * large folios properly.
> +			 */

Blindly copying the comment here causes fusion. The checks for
uniform and non uniform look similar but this comment is specific
for non uniform split. The =E2=80=9CNo split=E2=80=9D only applies to non u=
niform
split, but for uniform split as long as order is 0, the folio
can be split.

Please rewrite this comment to clarify both uniform and non uniform
cases.

>  			VM_WARN_ONCE(warns,
>  				"Cannot split file folio to non-0 order");
>  			return false;
>  		}
>  	}
>
> -	if (new_order && folio_test_swapcache(folio)) {
> +	/* Only swapping a whole PMD-mapped folio is supported */

The same issue like the above one. Please rewrite this comment as well.

> +	if (need_check && folio_test_swapcache(folio)) {
>  		VM_WARN_ONCE(warns,
>  			"Cannot split swapcache folio to non-0 order");
>  		return false;
> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  	if (new_order >=3D old_order)
>  		return -EINVAL;
>
> -	if (uniform_split && !uniform_split_supported(folio, new_order, true))
> -		return -EINVAL;
> -
> -	if (!uniform_split &&
> -	    !non_uniform_split_supported(folio, new_order, true))
> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn =3D=
 */ true))
>  		return -EINVAL;
>
>  	is_hzp =3D is_huge_zero_folio(folio);
> --=20
> 2.34.1


Best Regards,
Yan, Zi

