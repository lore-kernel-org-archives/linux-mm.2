Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EC2606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sno91Hqx
Received: by kanga.kvack.org (Postfix)
	id 23AA36B00EF; Thu, 12 Nov 2026 10:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAB16B05B0; Thu, 12 Nov 2026 10:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B65D6B05B1; Thu, 12 Nov 2026 10:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D33E96B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E8661C2B4B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:44:43 +0000 (UTC)
X-FDA: 85426889646.20.EA93AA8
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77D661C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:44:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sno91Hqx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794498280;
	b=8qCvwiNJkT6904kuJkRrHPHpzvVoO0H5FjTLa2ik9Hw8nC65TDoDwKMuJLBVSaCsLCIN6C
	hnXaoUQxRB2UpjWxv7q+PZiDLnNFqvnpRSXjXuO04pruVyZQbkD+2HF1j39LlHcHxw5Lja
	PElU6tQCEKe+RJTMEmye/ZOuxyvoXF0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sno91Hqx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MdypvYs0G9YJTI/gCtpPun29r6JDPp0RHSkU63+kD4=;
	b=zN3wXhay2ObaSXFk7XuCyF+ygc+nR38KwXdfDNpk6IMNNiqSUH21ynK/DMGP0Wbfv5Q039
	ZhaQtScSFm0s8wGfOEKpdguM9Bs1ofwoJ2gAQQ7svZIcpFq7FP4hFRaV7KY1suJ9n2bj/h
	YF7tSkKnseYsZ3tsHghqH+w/ACPV5LI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXBiP7hooN7jKd7OYX4vTn+XDB9rY3r0vvWrsDghLW85FiA/vw/XPA0NbESUJcGLZfT0Wc+ovmMNGXV/zKpRly52vKo3lllX7U6DRrH8QB533sCIQfu0YhUgQVQKNeOXgkb4wfO8P1oX5J7BPi9tNa46S+I6IgCi167BfnDORYSlptK7+hZJZC+XZnB2V9UxppiLSIOtXzFNo50J3uD8WI2Ru7ct4sKG+45qjdAK8fMgugKG0VdcgycjyNo8fxm09+xP5F/F7EPSJjbWie78iGPH2YpOJxx8/dk40Do/deTv9gNqSHRvozUy8OrMAV3PMqg46VjwptLiWO2g9isJ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MdypvYs0G9YJTI/gCtpPun29r6JDPp0RHSkU63+kD4=;
 b=XnhXyCyxx61zwwIhvnjwbTUcTbjepHYWn7lUOWf5g5vd1h+Lype95Vaptb2C2dBe9yP2eCmYy0kQblZoXo68DUkgC27fA8FTX8X80kmoLMU4KnQ1zdF9ogWzR8istFwLQfiN1uXav92Wnz3k+liIX0RqWkTvvkCbPntUUwyD2vUECPt9SO6nGDEzcWeZLUw/X2EK4n9rwLRmUe1LWgcLhjfZYb2aekdEEFoQuRtGBqsERXc+dTENQeMNL4NqwoP+9Hbs/1J+h/N8j52alwszVp1Iwi4E7YXXRU0VZlRAOu+4bmE5Zg8O93uRdV8quTRHT+AqZYxJJejpw+f7fHuvSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MdypvYs0G9YJTI/gCtpPun29r6JDPp0RHSkU63+kD4=;
 b=sno91HqxJITEqWcHz5MNMj4E2SpVdGP1CdxIyVZsd/TQ1yY4Rqb6j+CVxdMQo6Ly1lgSX+UWB074B/xnSUxbnj2qe281d1Pl7El0iN0LrpbCp5/Ko/Hkh7VUzFPQdTA/IGsYA39laxJMOjVRguEEH37xEjEdKEZ9hFBW1MNcKYuYPPsl5VqUQHMgNH2RRIBpr54hBbjiaFunCcCugNXzbTjbGgQspB74Dwtt1mSOgOHrD23Y21FDRmNYCE+eG2EAMJ81E9zIQyR+Oc3/WHE9ruiW80PaxOzZvqz2IIemoziakWvyOqYZxJLmjGw3uoy8aCUw2uLX74Hfv1AknN0GHg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7470.namprd12.prod.outlook.com (2603:10b6:510:1e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 15:44:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 15:44:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: don't read young/dirty from a
 non-present PMD in smaps
Date: Thu, 12 Nov 2026 10:44:31 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <7A78EF9B-1D4A-407A-9948-7AF4DBDDB732@nvidia.com>
In-Reply-To: <20261111113904.650722-3-usama.arif@linux.dev>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-3-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: YT4P288CA0085.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 6452bca4-f030-4926-ff1f-08df40d3da03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|261102123227099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	tWi3LyxLqhfc7Aqw93inKz9d7u7WmvgqtT8M7+tT5CKl1+1vUlQjDbGuy7XHhfrjHRm46NZC8keLG9hvJMslzQ7GvG95Us7V+hXDMI+vys4Wvc1WcK0USEu5JNPD/Jx2L/y7rmLW/qhiRWrr/RyuhSkMTJ1g9jhGUy8lQY8jgX9+6pC9hRtq4qGIiudrQEyjAyT+D0axpd3l4POxsUFo/4GHZt+2q2N/wX+9HBv1qac08Bi5ulAswLYfBET97EZcOKav7rMT8JJyiFE5QZoe3T8kqH4gAkQh4d5nsoxYDluKHJ9ssSyGYYtpYv5gCZHYOi2LVXCMlfFx83sZWj+aL1bkXmaaHMiwcPr92zU13Kxip9bQDfIR52iw9wyaxEb1pqas0KUZDDVNsw4NZdLNSHvrvZT8Jda45uliG2ZvXg+RogunTTyuh/AOAjh7LWxAhiK2AnC6pUUx5dzH09BVLHFgZJCyEg9FpB8DflQo2qI2dPrFnIGk1VMvdc4MXwrSbNC2jODQ55eahjzMIZVeqBRH6wnSNb5FZ8hYw+GBw0vP7mkUnQUZ5zPuh1e7A3v/xKUEoUuOjf+Y9HlDdQUXPpTSc/PCYpqrYwu387mUM5jpJS+a9EGKW5zEgc76ENSdYjEZQuFVwxDKLNy9ZJk4QXRMawkOFtaqYhf+J7/xCsk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(261102123227099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hIuE31khTkbCLWouxHi9o5PvDnESdvlhbfpfjH5fj95dGDCquSIARrWBsnnF?=
 =?us-ascii?Q?VX/DZ/KKVKtDxed9y28CKdWVE8+sBU/txIBxusgGYoHLy0op9DP8npqLILWk?=
 =?us-ascii?Q?6YnvuoQ3uAeSEcNnJwHYgy+bXD8bZOxRA6PIjxi8lIFptBvFptevVsFBPYxc?=
 =?us-ascii?Q?Rf1+Ph9S2eiD7RQpVn4eoCTEwYblw1MrwVTs7L9JTjQF+PP3jKtL/KSQzQXI?=
 =?us-ascii?Q?kKgM+a23GJUuWTX2BEvc9ri4lF8BP1CpwnEkpiuQShBIGK6VD7TPoVOTSUBV?=
 =?us-ascii?Q?uEBB3KNWr8mOFFdvVuXw1WXqqZ4TUDUSxaARb4dEuxfh8ruyHFE/CwwZDVEx?=
 =?us-ascii?Q?wrRUWE+PANi6zvqRHTJJNf2FnLczxscHFXGXg+4rC2dEiR+yEihur5lBrzvw?=
 =?us-ascii?Q?/+MV1RVD8co+RsBi7kfUoegJAjuMfuCue90Ws65un/1ul3ZUlgrAVJgzqNXZ?=
 =?us-ascii?Q?qnsaZ68bEq1o9+3pJbrexxGq405hjD/bSqQsrtAakuuRGBsdt2NVyh0UZlR3?=
 =?us-ascii?Q?8PqUX2rrp+j9lzsSxfeQbUrP+aIi4LyQQjLVFL7c5+FzqlI8VCK/tB7jJW+o?=
 =?us-ascii?Q?Cd+dIYhTt/FtDiRxqyHbyIF25zMF7G8wRjIE2C/dubZfFxspcb00zN5dP63m?=
 =?us-ascii?Q?bHdIFJj9tYO/sIgATg+qe+U+As/e/jwMKzdBkBeaHV24/XRFnug3DRw4JORs?=
 =?us-ascii?Q?urO0yXFhn3iG1D3ONnB84s8+dP0urwQxhtVi3zax7t535PwMDO+3kXMUKQpv?=
 =?us-ascii?Q?XWL+2qQSz+k0fpuzsLe0TcKR11YU5EJXHzGlPGE/Kf5zP1aXWS353CyKiDeB?=
 =?us-ascii?Q?JhvXsad6Em57AQLxsVrI79lqZWISYSTghb0Yei8QZWt+oHT2evIvVXn2DePA?=
 =?us-ascii?Q?J85+en5DVvrNchN8uikavLugJfUz54kUhUTdE/w0Brwy7W+CubkV08D9fk+i?=
 =?us-ascii?Q?ZzhwlGO8HZd9NNdggAgwgBzPyjwmCiWAwHffVyvGcEpQWugcPll0uhjACIXF?=
 =?us-ascii?Q?61Q07uM2XYt/h6zxhayUq9ZfTEvpauDtPkjXOxd8rp1mQ3bJy26VIaRa5hMf?=
 =?us-ascii?Q?R9uc0V5Jc5Ww9mDkYKc0oNzmXdY3fviqjOG4cv8O1hGXC28leL2Pjr/ICkle?=
 =?us-ascii?Q?7DUxXBizbohnodVe1icMl/ngQAIudVezGhdFhv4GV3XDSS9Htjy/ZsOeTzZF?=
 =?us-ascii?Q?phFRO9W/qPKYjjtdz08B/LOQpFnTBtfJg3Q8s8GsowzyUGWOc+1xQE0rps+9?=
 =?us-ascii?Q?bZAS1+Xtohmxb7LUc8mLkA42v6lb176KmIfaa7A0r3b86PRoOkynP3/3O2+d?=
 =?us-ascii?Q?HUZ7MMbbgGcm0uRP9WvF/RMpqfoFb6wYAL1qJWQD9yJ4zkgMWXvKEDI7kX76?=
 =?us-ascii?Q?LOUT0CmNE8685de7Bi6ujBAvJ6rfVX/tQkF+UftO6iA5ei80EHeA9e5xjsWF?=
 =?us-ascii?Q?IJSXdgVJP8+/A//Tl9tSQdPvkxmq3fPaLTHAohNT1jgvO5fvcSDpNnT4XaNg?=
 =?us-ascii?Q?tRJEnntCBGosQvaYw+Xl8SMnJcB/4TdkIVsljhIgYZfl33mMmxi09cDAM7Ye?=
 =?us-ascii?Q?rxYZSFj7XdJYZNDChgfoUm4mweu3c1ISyr2VbpsWVqb7wpBX7szt5Ajv3bi0?=
 =?us-ascii?Q?0CcfbQV+vO4+949SxuOpFmJBHUOkLB5gmuxflKC4CTaR9mmGjppcsxCYT4l4?=
 =?us-ascii?Q?6jHBOXbVv4srLq4WKIa//WSa6gyfgr7iUkGp4hITnJMHfAGh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6452bca4-f030-4926-ff1f-08df40d3da03
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 15:44:35.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEiO96KhMn3dJ6JefROsDGws07brrwvWZ9g5p/vOjqselb25nR0dhrRhZ2pX4iMu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7470
X-Stat-Signature: 6ncz8d7twsattm55rg96wg6pbmgcttrw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77D661C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794498280-144852
X-HE-Meta: U2FsdGVkX1/r+WxkKR6B4JhukCAg0KAa+SMIVKxZIwXTd9IRdTF3ZEBBI1ro2OjJuyIF7k/C7P/0nSgKw/88tFVUpLMcHCsVSc28xmrs7mHXXjnp/hp2T60/xrVNdubnfHI3RNeEsdmwo743qLY4dsvezPU3YNtMWlYk1w5ghzOXRBog2Erdn425PsQgEw4+Id9tWEHGYj9nH+QVYL3YHD8yynLtB8g0NCgsyPHOgpOcCo8LtLIvSfc1Ek/VpZnEHz5TNxLyn3FKbiznPJ4gFN9pz+UkAGko00/jyhexlHvfb7Mg27uJFRRXFABHrTDVyHLtGbzQ7lED5RlQYXGuCQNT4oh5G+o8VlfYig0sBV41Q2hulZZ/uNmGodNmu8wRVmeqGR4RDZlO6RcO7u+kfP7OWK9hOq/pWeVn0GR8w5qo19ICF+SDZC8MAR0feJisUYS4SKleiSaS7awNqVG7lbXqCZVx2lXP5JURx0RQecEUL3OQkLPtNpJsLLn/d+BFVICYyHVzTGaYCCYLn7jhmgecUVFDGnXp96AVyw+u7bC5VUpa3JvpTe80d/IcI1ZGk2xFYZ/XMvq3NCDRDRmcSa7eytdOSj5UysGZQ/6hJ9mg4VaBMAGnsSzIA9Cn7j05qksU7PQl6OWkioQVB5Jw3xV5c/NVHR54ZPFCdpri+rmiUdOpI0FhgDa4lBCgdphg23iViTHNtUSrrz7xXzcsOtOVYPUIpLMlPE0I2Pb7yOjJoe/xTY8/ZUPRGtXEcHZaarpntbMNBLJj9wE6Fad1onWIHZlaukDc72XPObx8B09mG0aZZUEkLLvceAXW3+ImVyh18I5PxCKyrF6z4aS/D56GT6mfhQhs001MUpoCUc6Txb7llrRE4fO0YbSJ6MMiJxWZ3sUvmStCBsnm3gFgncf4Em6oAfKudLUWDsqALzs/t5WRGoZQ+5kSl4dEP/Tu171nWe4h3FH2+WHFh25
 UKJ2T3++
 xRvPWKkSJB7SXLStA9CPetNbJHwq343iTil3TuEHwvxAn1X6ArbnCeNdAJTO80Kz2LM2R+v5QTp7Qn6V9e+jG3FsWi96WOZFJbLiDUHZ33cEvFsvGParaOIudAn8xAXP72ErnbZWZT4/Yce2oVAhZlhXhYsqRax4wp3NfPhzcQ6f1c0Xea8rmWT7/CbnNz3LTNqh5ejo2wE/kbjI6IsC5agGR76nt/Cy5AmSQL2+fWHITk7jlJkj/NtNj9lv7LDxuyp9hELSykbRHM7jtWqYHocgn0OUrQMKoT+qu96fq2UqI+fOkcD8szjlD6YkJs1RL+7ZrWxUtAo6KcFwWPJXAzOpcxguuFQRSd5dkyqKKMnexDrAYhRZgpzugkHeqsZFkJSGQEkdel6KY0Wb9gIx7xM7VoKs7NxDEOHeMBHup3JiFjOLQoxEhOUzOOAvhYqTfeRCqEUgC7yATBQ1Rij0o7o2IJfNqXYH0/YuOKfuIb5zPx+rJlnkdBP1eIhs6ymdjdMXOBftZyJB1BMl5qFEPZgHxbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11 Nov 2026, at 6:38, Usama Arif wrote:

> smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
> smaps_account() for every PMD, including migration and device-private
> entries, where those bits hold part of the swap offset rather than
> accessed/dirty state. smaps_pte_entry() only reads them when the entry
> is present.
>
> On x86_64 the offset is stored inverted across bits 9-58, which overlap
> _PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
> device-private mapping is accounted as 2048 kB dirty, and lazyfree
> accounting is suppressed. pgtable_64.h also warns that the hardware can
> set the accessed and dirty bits on non-present entries by mistake.
>
> Only read the bits when the PMD is present.
>
> Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  fs/proc/task_mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

