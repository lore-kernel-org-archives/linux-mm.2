Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304EC606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mO3ad0Hn
Received: by kanga.kvack.org (Postfix)
	id 6641E6B05B1; Tue, 17 Nov 2026 12:04:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614D16B05B2; Tue, 17 Nov 2026 12:04:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC766B05B3; Tue, 17 Nov 2026 12:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9A56B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:04:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A40FFA0448
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:04:35 +0000 (UTC)
X-FDA: 85445234910.26.6E9A15E
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9FDA814000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:04:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mO3ad0Hn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794935072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSQU/IfvZuPkCOuDgesblC0rp2bBakNpx9Tm0CSrWgk=;
	b=TR5xDvaiYNmeTmrp+Z/HwiprlTPaQrZ/n70OemFHW2N3WLX84QRCgH7nj7HEVV4dFfAIX/
	g9PHY8GwQ5a8Q1zqH9m3xOqqB19RpFtmcSdzgTB+rtC9MlhF+Kmet0sAGl2Cahj9YwktrF
	hOq6AZQw1wC5g+F+94KqRAaktpJGlwM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794935072;
	b=4TOnLNFoyYJ0rCVV/M9+n7O0PM20xMSEp9SZ7ta1gU56mxq+Qzud6luPKv74ntIyewOan8
	Oj3XvMwfUAxJUi3cBMhidxpP9+9zr9yEHbCxHnF7VA0QnfpnHl2ZBXCW14yAbJa6WqZCev
	wWpL7NT4Qy32TGZrLh40iif1fb+j20k=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mO3ad0Hn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lN1RZZMmrvml7zGgWJGUL53/AQWGuf7DamzAvVxQny0+7p0vvpKsvDufrPQgZOlwxck+UadcVgrB1+bsIeaLQTm//02QreNex71k5KtASwGs2SkBDpxJpGHeQjJWQcbAWz7EorGgrmjzusTFtXXMaSNhF38y4fZI9t35IVLP6ZHT9fSuw8jYLHJSuKmcZ0/UNymOow0SwdZMcKonEXAgxRtaNRbkOMfAXKxB2rr6BO/5BVYb+b4fTWjTsCuIKJtL4J3vFSzAT6BXC7EtBcLm8gcqYZ0K3iI0iP3VTETfXKM5TyWFLJsnfOvDtFrSueTxaAr+bSbcvbsv1cszDd22Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSQU/IfvZuPkCOuDgesblC0rp2bBakNpx9Tm0CSrWgk=;
 b=xy9zI/j6QfvyfcvrUeVp73Rvq2DbVKzPZ1ijrliBzmdO3ESa0214rbbOYw5NZmG3Eb5JJK/5ZMwwNXymgNqnVSw1mW2NFxZcFGipHVXz2MwI1MuI5d6Doh88Fa+Y6k3ffhlHfn9DfnAwY0yl/jA9m/7VhzvP9CrF5XK7Drdpqxrx61Vc3H+jVAyqdxeBaqlo+vP7CoVDkj9NSDPBd2d589TbjUmRvOtdiIhq9srDWyF93n/dCWMBf/jrXyCtsubfPtgP2Ky55U5kpaXiS9PDFNRGrYzxRJXVfzyV9eDYUzv73ufeIPAZHexaGNvd51TY8lB8Rdu0Mu2/OvfwQ7RI3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSQU/IfvZuPkCOuDgesblC0rp2bBakNpx9Tm0CSrWgk=;
 b=mO3ad0HnWY6NnEe1707rEfmVZ/g2j/zmGacta41KjIjXi2ZoSlYNQQItHv67hMsuLZRVPWjzN0WHF3htIGTMrq18Bj0qppuAIf2oNpvNodZHNGAZRnVkkQxupNUu4AhH1ITFqLdAxr2UQ/VrFDUUAHo7aoFHgfB+eGAhbzzIRqwF4LTrd/3Qer+o+Wx2K/RxkQBGP0DtqYSj1Zur5DhiuplzDCtG4T+dQECQNncPD+VgIWDh267vJEqrezE3P3EJ0HPO8uvXDciEx4f9GlWjlncfKYEzm5t+ubG6Qt57K3R6srcBiUkwgWO3mM4dFDu4g/FqltdalO4L2svaoL+ffw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB338606.namprd12.prod.outlook.com (2603:10b6:207:128::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:04:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 17:04:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Luiz Capitulino <luizcap@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
Date: Tue, 17 Nov 2026 12:04:27 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <F0AE0B3B-8E52-453E-A068-0BD77DD5B404@nvidia.com>
In-Reply-To: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:208:23c::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB338606:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee9128a-96ab-4c09-cd8b-08df44ccd76e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102124527099003|261028144727099003|261026140227099003|261022075727099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	2U6Dt+wnhFFGq2xnjlA2WufXC4kHIe6Le2vPOlxlr4/K96FGGod3iA1gcVj+kK6PbtPxxnpRj4weXJBhY2AWSzSmVkyLrpocDiT6zBGK6zNx2vRy9qxoueUHBcAVtJLEJxScUPLw2AmVlRtIa0vfN8Oqy3nI9AuFX9//I/3sB+rgNVni5GrkcHhA46P1SHgvfsUjY9SO3uOj8CWui5PH5UXls88QdktRMib+l69da5i0u428GnC5L3nR6Rn4a6EVkjgimjjA23UswPs1V7LacFew5R1+N440SKVA2M6ec9ruw1DORF1jXoNwxaYweEa0S6N6TNBjZb0bSvoidclo/5QhDgso21QQcSxwRZ7NRAMJrxIf/owb2LC3pMKiAMz7AmZCywdIY6wIQrXYLsmKVfPDbne7KVoqVpAZlF76o1Bh0qM9CixIxPuSqeg80Y9hVVHamVT54rNYdLxI16Dyz0VGjWMxklDhDJtQM0TyvsHh2jb/OnM/LqCKjg1DeNHCNE1H57AT3nABPeN68hZCSfnRHPY5kV+0KzJldisGIMKaQSmZ6+9uXKucRWQUxqzcE7hqyfqKsyxs1VIobyAN7cHvGO6s3emru1gzfqwZoYspFFJDOU/z3GlnZQqOlU7Rc6WZ3fbPJAz1OyiLnKcLpoXF7KC4pNqvHaz4c4Fn76Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102124527099003)(261028144727099003)(261026140227099003)(261022075727099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CPIXF78koTOEZnIfXxfjPyawNq5ZFiTImykWVp8J8kIHdxq5hEWGr5pCtLmu?=
 =?us-ascii?Q?A1boSqc6NrEi3CJnKXZV/L7IioxZsPA7Oi6L7dpK4m03Og1bMNLgaQHqEKl4?=
 =?us-ascii?Q?afNk5PsBHnglCsjwoPgJ+k+wpasQD7SgC0P86ABfqx5/wjifMrrZOno1SMmx?=
 =?us-ascii?Q?GM2c+UlT3slbzFBo2lU/o6iKglRHl1VaUOwQDftND6asn0yGaXuBzH1gf8ap?=
 =?us-ascii?Q?UNXHB6Q9tGgyafyK1C9OybXxT9sGSo9HbbFUp9Oh/3BaVkfnV33tkda68Sua?=
 =?us-ascii?Q?zh4wV3qBoPjsOtO0GKxgdbVhY8HFqChDIn/zyYcj8MaMNuc9vG3n+pOPWBc4?=
 =?us-ascii?Q?fqtngasnFyGTyReYlM1j47Qf3cH6arDe/M1HPbup0Q4oL/chOW0rVjCrC80S?=
 =?us-ascii?Q?zzB1wavfrOkfqGDr9A1zhS5V5lm/fcKOzaHP8Xdw+na20QgslmVtQcDotGYD?=
 =?us-ascii?Q?6c/zX7csouHFQQnuRHTe1ueAI+RbLNMoxJeMajWZfabrEkAKoo/BiE2d5T42?=
 =?us-ascii?Q?i3ehmkWWqeJXUvKKXRyPM7twOWj9pHm4/p4GDleqdOxX/9+cJrYz8FbLInd1?=
 =?us-ascii?Q?dm/ZnsGMFZzcFyg3DKmDMEw70lpIgaUORScA+jd4bkS0PaIzz6f7opzJs4Ee?=
 =?us-ascii?Q?d2BokeuiQHNhyVuwVommznSy0dJLqeV7zIuNR6+Oy3oWuTA1Tx70MA2Y5Qht?=
 =?us-ascii?Q?WIIrL0CgDFolHLGKhcEQvgiSCO8ZbbcIHZnWs0wFAHux680dkoAyyRpWtHrC?=
 =?us-ascii?Q?6mGqPxAnllaBMtjCUOPnASiPoSe4sdyCncBa8W7FbkzSWAL7DInIkXKptw6t?=
 =?us-ascii?Q?oGALAhLUAzIvU1ZsVKtDUQ8puVKhpDaQA8wnm/hOV0P92yBVu/izDQd5yCd7?=
 =?us-ascii?Q?j1IiB83drHL+FB2gaLHH1CupQN/GQiZKmnRIpjSfGEIi+hJeLNJ4vWY/CT+U?=
 =?us-ascii?Q?dakULyOk+dfghpBF2+HDnR3IXy9Yg4DMmysAk9N8mlNeDJBP9JMOBGjlZWuR?=
 =?us-ascii?Q?1WJcV+BXeHHs7wdQ/YtV9IpzzN2pyryeECeT7sYHmkxCViOvNXx1iiySJ+No?=
 =?us-ascii?Q?d7NuZUIUO++nb/+CYFiVk3547MRFHCKGu3ccYhYESnglLVc2guBUltdz3zMC?=
 =?us-ascii?Q?yUSBpfpt9TzFqtk7gw99imbdE5Jr/SHlKBsehX4D10yZ2K01uEj3Qgj3P0N0?=
 =?us-ascii?Q?wCAiTj/k/6aYcZLjgg77wUUThnhwIUrAhsIiPin6CHpcVOkprxNx8hpPRfbQ?=
 =?us-ascii?Q?3+lSXkoFQevWR/WE6aUCQu1RY6OWT3fwcZOTXK8TN91lky/KpyONZP4+eprf?=
 =?us-ascii?Q?dTZzEI379lqIS2chMULJqqSxA/EnkTtpQ2U5YbY4qgMRrIMJf11iQwwlyvV2?=
 =?us-ascii?Q?WxHACOsy+psMpVIs7QDb/szQeJIzP8UjZjW41iZ4rP2sGuqh6o5T0ICMW+J1?=
 =?us-ascii?Q?3J/oz+4L5l6SRhY8QB4JXoDxPOwD6BBjfvZAPz85KNYCMx9dOtX1fT/Ctwvg?=
 =?us-ascii?Q?QpZLqQw5t58EpUHG7QX2+tj2NqyT3fQ/isFoJiMejYYn09GoeUsR9DbuVv8A?=
 =?us-ascii?Q?Wo4qrPbN3CJ1OwJ9a/tPGqweiO8j37SCp8TmZJMttE+qqVbqJfdk3Ey06DxN?=
 =?us-ascii?Q?Yd5JKxA8/rD2oqikecOKLz19EBrqVeWx786Robm27VBJvd2oX5PZvostM/pq?=
 =?us-ascii?Q?v9Eo6C41YhLAJOuuI0Yfag0w6CVctco1mr9qKKdKbCHw0ir9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee9128a-96ab-4c09-cd8b-08df44ccd76e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:04:28.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRiWZGEEqJYQkc2N1eOM4HKR3aI5KQZHB51nMY5X3NgfqkLioWo3bG9wwWlIcdZ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB338606
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FDA814000D
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jmwg6fjcozxf9a7cwcwmrpwsygx4wb7d
X-Rspam-User: 
X-HE-Tag: 1794935072-457365
X-HE-Meta: U2FsdGVkX19/62YfU+NrTDjkF/KVE5pN3CNwpZk+iMkq3dHU1x3ttZSugpcFZ2j1XbzNuTd4bzcjAIaZVH5vQYeienG5zZKp6ueq3J4TOeRQMzbPL4k0C0lZhMMHKZLOZVurDaUWQMC8HxyXlRuxcWSb72nrVXDWHfB4JPRB1zonxXZVjW7YN47BS4sXlBFJpSPYMxK/PIG5GYPe08JIYzQp3eQ2VCZBy2wyEIVOOP/JZffmf9N9XzHWD4c3R4YBfWLliBX+7NE1LKT7aE5hUuQGbS5wO04OtH4t2K61799zBwH7URNQPzd/PGyr9gTnKZM0DYSDKkOZoHkZc+0aj8/RbTVmbiCJkuFDamqlLoAJtnoW+8/fpNdeGv9sbOhyFTcXrDCG7Lk+xFIE2UyBk9GwZhOZWiaY+LN9OW4I1eQ0hqaLJrW5SROW1PeaLlKpAhRtdU+ddugG+otJCJOclpa0fes/8FLMNZI/LG+pS8R0XgsmQbfZalEwszpJKr36Ri3SJ48bbE6IuC63uvOPIuf8c85m6algUHq1SlSEu7jEzOIZg32sd6pD5L8LEEiU686zrryETSC4OhT4r8q8sL7KRYDYvH0sf1JhVOfTS2DbBSL0kQw87UpPvHNbqE3yxDkc+QyjcL3t8jkP/NSUzdbriJHQiQjycfBMXIFPJWckHXyW28Y/Ja+6WrhyBpAhw/9SMq30ElNbytbwd7SlEGij2xvLC7wPpZL8OS96TfxaNMntti7GH3HcoLRiHoxXdzjDYF392L7ng6eVS+KSWWDzWyJ216n5U80nOeaaV5D0V3H9eY9pLqwyPVS0/7YxOE3vl9sdmnF52vSbzWf77su6KQpMaymzslJ6uUxUKoR6+uT6f7Z240pAlh+kz1eggfFNkqVrpY0QIUyyx2NzwUUtPGhgYhc8rj7GNIQhBOp04in88+PFzh86Uo6fDViWWKIw3NqTZl3mRslAzBJ
 M7eOoxBm
 1h3D0814OVXhGGhLmwd+qaBkZHITvOLXGXCzK8le6NT4yiSVt6LVfKvcYeYbfk/9wWmYMyx9oaju/qYRai8UpNwZC57RW++DaXz4DMYitwQpHOaObTWsBYbBTYdnzLLfy0oYng4W7zXA2JQm5DYjv3w1hQpbBfvjBlil+o5knauNQpfRiiYqcCdNdo05L9ppCOHo9nhXHXs/MxyfwiRw4Rdpr89bG6Hk4Vfg3msXVW4Fv12r12BEDGYLVKZRYCvUBKweyP7mu+JpwzFdLsqtvEnBux8+XKlLM/owCtyDhzuJ+njQyYj4VMWJUDvxTdsdLtBWxUC03ZKJzKBc5gedNvYpSwyrsV+k8pqZGx1puwfDxU2wGMuw30AnOjIjKDE0aHC1dtSC+CJNC3py0fR6deW48pWMVdpK47F0wE9BDKxo7uUPeSakBk60EYpg5zPiC6JIoUCd2ujjjZdYj8eFjIUCMmGS+YqHXrqONBb5hZz9q5e+3SaFpVs9If/jnFDWNTODX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 17 Nov 2026, at 11:26, Shivank Garg wrote:

> It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration AP=
I
> for page extensions") but has never had a caller.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> I found this with the kunused scripts [1], which I wrote with LLM's
> help. The v1 cover letter [2] has more details on the scripts and
> how LLM was used.
>
> Changes in v2:
> - Split out of v1 [1], as David suggested, and based on
>   page_alloc/for-next. No changes to the patch itself.
>
> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd=
=2Ecom
> ---
>  include/linux/page_ext.h | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 79c53ec45dfa..52a8b70c525a 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -167,17 +167,6 @@ static inline struct page_ext *page_ext_iter_next(=
struct page_ext_iter *iter,
>  	return iter->page_ext;
>  }
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

