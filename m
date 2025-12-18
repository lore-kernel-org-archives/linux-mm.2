Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673E8D6E2DC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916BE6B0088; Thu, 18 Dec 2025 14:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3CA6B0089; Thu, 18 Dec 2025 14:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764956B008A; Thu, 18 Dec 2025 14:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 655656B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:32:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1984789A4A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:32:17 +0000 (UTC)
X-FDA: 84233587914.13.D386CCA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC53418000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:32:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NasQNftJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QU7L4Mye;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766086334; a=rsa-sha256;
	cv=pass;
	b=FNR/zp+1ylpzK+NatUJQ1BJyadFT10f42OnPT4lsdmCTE1uVlZ7wonT+B+lNIpPIi/CNIR
	ZwWMZnL9sHsxjbc0S3vwXPl4OZt8wjPAvND0qeA3aazXPmXPCoi2UeIC2YAJ1kYpbKn1Cw
	28mA8MWOZU4FsOZDqcAf5GA/76k86VQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NasQNftJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QU7L4Mye;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766086334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRv9vLUGKQ6bCSutFZ0cCtB2QQgW5mVjcfjKBKfPN+U=;
	b=lZRAUCcK0Ke1MFJ43L80ca3KZCjCFWvDoHmsmnBTN4EyN/QSQf7xvQ9BvK/1Q+iL3BluLS
	AVj9TPpB9fefFGFF4WOmwsD1tJGT3XNex/PMtDrb1QcOAXUwy9Zpu+vKuO9rmKYkI6vF3j
	HHNTvLlGoI46qm3FOvROP1l2jhUAQAo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJNGJf2161579;
	Thu, 18 Dec 2025 19:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oRv9vLUGKQ6bCSutFZ
	0cCtB2QQgW5mVjcfjKBKfPN+U=; b=NasQNftJdXxLBBEQz2EklYzdu32mybEzx/
	8ZycJRdh+gxaP+ttf1chKPj1DQLIKh7Djpp3/ufiWsuiM+NaMc9qkdksiC3X9IUH
	0lwn2j/LPtchNE5WfWVptPsEADAyGkkIUPARISZ41X0WtrZ6lNRIZwmka89Kz9r6
	Yo+OkNrdoCLQm/ahBggcOZrkzjbSqCi0IJwl/Kj/xe1q1eGkrZqC3QQpyeTOtv6c
	jzL+5qMf/woTmaUyKlTE0iVkAQZi6DUiErTzW8WmJ6ky2e19Fq6vE1U6cp6aUini
	AcrcPRCi/QNjKwul+hBFjn26bmf1JrAxoTrpq0JsnCIT13mzmtOw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10160cgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 19:31:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJTnGd036939;
	Thu, 18 Dec 2025 19:31:51 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtkg2y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 19:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3zXl6JD/EQAUmaDjin4ysC+a9Q6FXiso0l/IpHt/9qzT2DbdyWzPBiy0kbvqKjhdqVBPs3IAH62lwaCGLt/GWhESmKhTlepe90xeCWIf0rU+Cg3qvNsGcjy4wElVxxA+g0PfG5q3JMaUFGn5vvXxGcKF5c56UctRpC1Ry8i9EbcmDBjmfqMVJfhztCH/2CQx73cMHkKuGuYgwWtXO/7eFZYp8YHqi58gZBnIpyuRp2y7RLXKE1NlJvrtHirUT9u1xfBm2f9YXBvju1lk8o0VoXKDbUyXiJFoXGAroZZEqqCqZD+Sn1fnSOp0wGZiwR9aXhwJK+0gPYDCeOU/AkWug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRv9vLUGKQ6bCSutFZ0cCtB2QQgW5mVjcfjKBKfPN+U=;
 b=xWpN80/qwQgHjvGfdZ1aNLyJj1z5kEH/zaIIU+UmUXNaWEfgcgkNydHOimkgjn5EQeMLT5Q5xVuOgGL2K3E4jwa+bsNo4Fd7nmZj7nvveass5pO/oy/Tw1VNd+Fx/bGbMJ8QU11H5YQN9nIzo56EeacljIDOX2XWLrgrWxzd0m9ZVuQkhoY2TOJknzcDLqYqS67++CehcjQLs1BQU8u0apRzdJZyVwyEEU1LTn6PI1vA9bNukKcDs80rRYIGEBU0xpGl3CiSrTovUnzEexa9NaAG3mT8zJ6bB87A+oN7NUfS0fKmNJZ6CJIdaTzC5XQid8KKOXL+MfG/W4gCrOxeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRv9vLUGKQ6bCSutFZ0cCtB2QQgW5mVjcfjKBKfPN+U=;
 b=QU7L4MyeRfCRrxwWMBqJPX4YP555KF6cm8FGvIIuEJ2Kf1OGKo3vigcgOaMYmrfEkYgsjbqZ8sZOsYLHVTKLJCcPOL3w4tcgtDNEIvwcIh8zifI/yqwIOfkPnJo0uOVf1U4/RHhYIktQ2PD/qilP2KJnNIkY8TQO7ui6dwQuC3k=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA2PR10MB4444.namprd10.prod.outlook.com (2603:10b6:806:11f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 19:31:43 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 19:31:43 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-2-ankur.a.arora@oracle.com>
 <6559e53d-e940-4989-8bd2-de9a6cf9f62e@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 1/8] treewide: provide a generic clear_user_page()
 variant
In-reply-to: <6559e53d-e940-4989-8bd2-de9a6cf9f62e@kernel.org>
Date: Thu, 18 Dec 2025 11:31:41 -0800
Message-ID: <873457ziw2.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0230.namprd04.prod.outlook.com
 (2603:10b6:303:87::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA2PR10MB4444:EE_
X-MS-Office365-Filtering-Correlation-Id: b66d60f0-babf-468e-9016-08de3e6c1310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DqbK65V9aPcSQNvrakzoQb3RkS/fFp6+mPVexOLK/88JREjQoXcJV3mB67uJ?=
 =?us-ascii?Q?xcPRT2848fUsF4Tk74XMYCn1TDblyqZUNlgdZLUQsHfdg8//gea0GknIHMZm?=
 =?us-ascii?Q?udBgB2fxjFB8OqKkTmFqQABY6bNr0CEFLgZFKNMWGNixF/Wc7NkUVX4nFP7j?=
 =?us-ascii?Q?zomzSU+0gBuly6g3oGiJfyltkE2KToBJ8ng7hqUM/0HGzDeFWzGfskql89/N?=
 =?us-ascii?Q?l6KIhaGVieVyBQGVCx1U4n/pncSmAdx+CvYXdZgUGC7/jp0G/GxU/9dqkGfd?=
 =?us-ascii?Q?syWgcPoFikQK22oiZlcVasraIY1b6+6EbuWc59zd4oQN28qXlFe3DM61Xk4i?=
 =?us-ascii?Q?INQc2K1i4onhvXVPlAyhgQrSRm5MIlZxrvKPzXx4XEsDcnFZxRSuXuSKu2N3?=
 =?us-ascii?Q?UYUvJrHhIIJoj3V+XKImWBLVWRn1/T+uAOxd1eSePWJ9vfNvs5iq/iXoYXdJ?=
 =?us-ascii?Q?AYEb96fFadhoo1U5T+1AEHyf1Z3s3JLnFZXVbyKY7hb1U/mw4dzgngWfWJR+?=
 =?us-ascii?Q?ScxR2O9rUetvKZtCk8MbiG4aR4iqvcfABCRd5aIU49yWYw6UQqwu/Q8gkoet?=
 =?us-ascii?Q?38h31sJZuxkukcBSGFAhWvw9LlWMj2CSCWQa9ei/p1DZ1gcuIw4/MxT7n3+W?=
 =?us-ascii?Q?mKrZhVeQ6rMd0phwHJqkskEdPJKUL/gwK0vEmmLQGVlMBfM9gemOSzV7K+31?=
 =?us-ascii?Q?9lARbmZztIOBxXSQ5T3kaP7WaOtJyZ3hKxPpFJ5WFrZBUMnZRtNjHePXcRV8?=
 =?us-ascii?Q?E4dRtp9BGPwkhmHTSWJgusk4h+8a6nhmEG2foL9vhAly7h1+ul6n3AWAs4zM?=
 =?us-ascii?Q?lb7TiuEz9+5QZR6IhYyfMGjEvA/aosZxb0dF9xiZxCVOFGhZYdyYIroJRfoh?=
 =?us-ascii?Q?oP98bh2V8j3dl+cwp6+BRmX7/Y79ieVA3REjq7lHRYfwMKACWPBZE/n/m/Y1?=
 =?us-ascii?Q?cLkNZQoA33DQiGPFg6Arxh6Ak99+ShtJvVB0Oini3yUgTb1TVgH7tovtedvq?=
 =?us-ascii?Q?lQ5S88XUbX38X97/fahr9KqB1ZO3PLmZIil6nPkYQzXI/IA6Q0xf/h8GeMMs?=
 =?us-ascii?Q?ZIe37doYhlMYp5EIUsZ9iga8LfYG0MVSeQiCkvhyAm1ULFZZNW/exEv5KfZr?=
 =?us-ascii?Q?c1FfAlMsn/k+qlF4OJK8HsF1InKTmT77n+6GSG8q0ZY/T3PswrGTljIVkNNz?=
 =?us-ascii?Q?tCiYW5El9QC2U0tffZoFMQH57id4ruTh0VoHroab3SX/5EYiZ8GvsJhOQQxf?=
 =?us-ascii?Q?sboHZ29YmNCdqKwHIs9NhAUOneX9QVUAPz07xzEPjF5LOBGNa7Yd/8h4sr1H?=
 =?us-ascii?Q?+oGtbFRCAWe/8/soxneA9Qb/bgIMkCbBfYUgtrW4g/YDvsG5o9uOoLv/iD1o?=
 =?us-ascii?Q?VNFem+Irm+cL1wjpCRrRNifs1bjTQNXi3V3E7Y2lk8HpfEDMEWYJuTzo70Mu?=
 =?us-ascii?Q?gyFoWCURWoA4IjbIa7OVnWvJ7jWve3qY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ZtoztRyDvKlk34YEKum9TyrAnDZSg/YumrLOBqnc1W2PfTYSGK2jyBwawPV?=
 =?us-ascii?Q?GlGipRBoyQEmjfsD+qDAahcgZ07fYqFFoLQXMkxcX8zizmYaVURyijEoupgS?=
 =?us-ascii?Q?ZQW8UOkbETZi6JimJ0Wuy/5SL66p0c28Hq19mkMXaXtPAu/84i/O4TLCgIJQ?=
 =?us-ascii?Q?5iW1uU2jc9klorrVIqbIzVRUUxTo3shM8tPzEPyqakwnSwHgUVF33OAfoRpM?=
 =?us-ascii?Q?otHMK2zvoMQrSs/3wZtKyDrBCs4HkEl9wkyEi3dhibAa/9ciS9XpViSGa1Ot?=
 =?us-ascii?Q?4Gb1zokdIgmDzxnJ3gYvhNTkSiAC4Eyz2lbYvu6+wh6WQTe1h0ALcbUhlrT6?=
 =?us-ascii?Q?a9PN6Z6qtih9L+qfcoQM4JxGhLuqneXIPAOQ2qee+nuXwyBteilPbi5zgA35?=
 =?us-ascii?Q?tDap80Amf4WeMbLxF+bxRSipxBE8PEFXym90HyIoCDuqTJXbvHdyVTFFr8PS?=
 =?us-ascii?Q?B6r+NrBX8wvcsw+VaiAhEUJ/S0hYYRAgezf/NGmYLO5s4i9YXCFXS/F+Lwet?=
 =?us-ascii?Q?rqWpPRTrlK4AFGyBQ6hQ0lh3zLedXjQIGhB2PYdcYTyB2d5PZT4de+8rQizO?=
 =?us-ascii?Q?gvJbKvNnYZ8GZP6D8zrF0PHLXFyHiLdnH0TOIeiMhqBp283p02FqLUXER7+n?=
 =?us-ascii?Q?ly5zeBthzCGRR6Ykx0ZRqOuhE20urru/mefQov7ne2iIToqzOK63byrRM8/P?=
 =?us-ascii?Q?wExNQk7qH+an34uVKPq3Z8C2ebF4AhE2+JGk9j5kDe89BEdegZnq8W8T4Erw?=
 =?us-ascii?Q?GZOOFjhPYyexSk8c3Q/2/VoeMVlKWGkc0fODGhU7fL6V1usMOO6qfXqCDs0s?=
 =?us-ascii?Q?h0W5nAcXxsFZHSkg77nHKxIcu/2c9/oAhN8hBMZceeLuv1L7ayQeDmh8UNYm?=
 =?us-ascii?Q?KPz8Gzxd9YxQH/eM7D2lDAPUYt15cyIgSPQKXYsSeURtq9MmLSZLjZsXBoB9?=
 =?us-ascii?Q?+FhVE0czQmazvYaGjYe3A1QjkS304ktHItd2AaNEOovfmQ2k28amWO2ZI1ZX?=
 =?us-ascii?Q?lWY6vww6OlBvM4KBBOwc7Ko5j1RaLpsFzaFFzLYCcsWLETwWa//C/zvX+HUm?=
 =?us-ascii?Q?B55S8jMe42lvlCLeOs4qy0aMby23/C1phUQAOxqYLv2nRCRgOtyk46PfIiqk?=
 =?us-ascii?Q?ir2oSjfcE40+LWQOxXBqRL/XdkGYLxvHU8St+NlDhYI6cbKC0aKvXKh3MCZ6?=
 =?us-ascii?Q?UGGRM8V32VNVBKO8/jqFsUwttXeJ7QBqrOxefbZVtFFd3M6KfRUwgpJgQ6a9?=
 =?us-ascii?Q?ixprfxCiM5ct0UBUOs+iiiL98IlM7zhkiGzYGARQ/bb+/cfxU9YTyp4UjJF5?=
 =?us-ascii?Q?lHoYryzA3bbZgyxzyTQxedZ/d4BjilJS8MwjWafYts00G+QN/YSohq7lhArG?=
 =?us-ascii?Q?VeCfIUrVKGWKPTLSXfbYLgsLN2IEBZIsfXX3VGCTXcO6VvFMK/qlaC/SjRnZ?=
 =?us-ascii?Q?IC0xtsiD83dEbq1k3HKLWXp1xfGHHmS1p93wNK/R3d8HvTdNTxJoWygwVR7a?=
 =?us-ascii?Q?NHMOqYepAwpeineIV1TAsrBIgT1vwKA3P35C7cv5Pp6poz8vLKhEfRizpkcz?=
 =?us-ascii?Q?xZPcegWTwzjnh/uKs4fdS7uKSlLFqe1d1Y1EzeLqdZxNowtDaYZtzk011dEe?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ur6IzUYp/ikho1RiGz9eXpYJmdBNiyGdqSA9iVelaaFvBdvGg6PCyzQf2jefkD2jLExHZsjW3elfalRoQq7Nm4A9XqU6WiibbN09edNCyrnOqtly85GxBqc8O9rpbBSaKSk5keXMaFHeuyPEGMd/oSGtbnpe7CJq4P3kRbgzV2Y86Z28AHqgShwnN9IOD/lXu0TejPMneIGItpTVBPLExztKfN6xWI5k8AqZBk4c5nE5Zt/SmYi3R7tmVUIWW/zx3DKqUosOxFrKseIdMXyxeXb/3e1ktfHcugAazstZ0xSCJX4Y4yWTPIxTubcUaUgRrBWt2ZHr56YTdxUF5BEHj7ELk5qnaMQ3InxIz3Sjwl2W4snMHBk4NDq7pngNp4FKYPvF5ePqtUoiQX/yynwsxRDjUFHoCSB81kDu4rRp7lRLTEQNBKLXbFzON8mMn7DWallI2KXKps4L+Lrg5D8nNRr2H9HhiW7ctQmHyp1Sq8aXjiUXfHPqsBftbDKmymUuPeK/4W9ldbBx1evbiN+fWTuM0Q2kn8Ymjby4PQMWWoc+pdZDebnBqkphZ/kKn+oFh9eQ7muY4iTGwRCUDJgPHeCSHRZjn0zMHv8zJZcgEBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66d60f0-babf-468e-9016-08de3e6c1310
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 19:31:43.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BM/Va/0dxYC5oGyxNmnsAcVUKF14yQoj4APpsIqoRlyEFxzsIsNhsPlr5cuetdBoJ5hUWX7zqCmoAMoZd7y+/F91uGhFb4TRFJL3eo8983k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4444
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=968 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512180161
X-Proofpoint-GUID: Z5XGfA4eqmdoAsyOS-IslysBuVS4nBHI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE2MiBTYWx0ZWRfX+BnLFXDtV1TT
 F5svFtCJ/Ca56Dg8E04e+TNkS2qeCbZfq+gQtkD5Vi1MWALNNl6fsx2ZjqOqJN5ipCeKED/wcnr
 eys1O4CyLB4DyMXrkF1eM//Y3drq9N9qsCaIWJYOFBgdLgrqsIxe6CzcAQKYvXiOLi/VseiZ+Dw
 YCBVbiZh9KIbwJl2Fn9sb6SON1H2qEKZAI9LKvvTmsgVLBz1RZiRHEPk6AW4om6sbPm1zYF+us8
 gu7M6oQPO+5cF0m6kfpQO44OdI6rfAIp0qCmkxQ4KHC8XofsymqdNp1FdC+Lffr9G/nkYDWAO5n
 yYRNPGiiAnNJ4LqDEyWDEqrl4zTytEq+qVlswwzAIAwUXQjzzDP3t9hF0Ypnrztsr28rRhU6qjL
 78m0G0j+tIepM1yVMzED1CQ5UR4i/xaTs8bZoOK8VFWPGz+JFZs=
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=694456a9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=Ne6k_MxX64h0uefHuLMA:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: Z5XGfA4eqmdoAsyOS-IslysBuVS4nBHI
X-Rspamd-Queue-Id: BC53418000A
X-Stat-Signature: rwna8nke3furwhpx1u1usi389jsfa3po
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766086333-826884
X-HE-Meta: U2FsdGVkX19I8Z9nI3ia6xP0r1joCo7acOzcyow6I+TpY5AjjWt6Js5w0cFBe8vb2C+4d7TPkgaU3TpaYPimGo7+FRnwNscWz5DSxC7B4Qx+X1d7d68MevKozoWgK/B92IRMQpNkWf4ysvNap8gt9kR+4uWOqmmMd7VVa8R3L0GEkLz2kntUlauLnMi+/DeV1bod8WM5s/4RS6l8IJ50oiQF0gDTrfWwWig1nU3isw6CRNrQb/2ORctIij10FVk9do0CiBEBhCnRCFNf0GVzHKRPx5/hnO0gAkX7Pue0wZFI58BrUJekINoslaRlyWwAv4PbjqpKkog1mci4yffRtuKN+x7Ydta+/awMZ1tFy/aqvSrccJbInu78lfgadAw1i125SIjzmqTHy2Nvsh7RCSjPEkat18I6fnC0o1z+zm0pO3I/bjHS6ZMPGFMakzAyLHYiVrVmcpRV1NOdSV9919YHzPUuTHO7QqsaOqAqikVflhvtvkhHaOz6gVMVxulZYvBlcxT/prptVTz9R8pu9RDB3mIEo+3aFgpOwiE18uQRSkKyDVRAF/807XCywL0USe1culC1ipdN7Pkpbi2tGhss5+IqFN9nETOBm57U/jBJulNPL0uMvs4ka1qOY6WeTrLR6un0PNeelySDhXiqXICdU8Sbz/5k7VbG2y/GuS9vqe6WUnC4mU35n0j3P3LObEUKMZhPBVhwvKtvnHm0acerR/9w3H7KRhyK/T5qYOtnTEZTSci0DOi/LU/Ly2/mnozxZzYPMztCRUd75KGr+/qA3IyGlrnSBSwTfv5JG+zjHfU70in7+8azrazgoDYTaLfGGf8+E5I31sEe0qYbjUvDBoeYu0jXtUIXXjrTvXP4hldOrw7xJWqNWykWZS0oEtCamSFL87Or2BEbO/lo9A8xe2Sy1ne/Wzzu18T7MCquii56SjXY574Nj8RzFqwXhpUXVPkqEW0Ta11PB+o
 rcExsY7I
 Ttjv3oPD5Pnii7FBMvSdxN9J+V5djHsy+VNXtmS9n68RMHkfeuvYtOqgbCXv6cw6JHFRpz/V+RoWGWTvfYNfKBCOOAPsD4PDO0FIB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 12/15/25 21:49, Ankur Arora wrote:
>> From: David Hildenbrand <david@redhat.com>
>> Let's drop all variants that effectively map to clear_page() and
>> provide it in a generic variant instead.
>> We'll use the macro clear_user_page to indicate whether an architecture
>> provides it's own variant. Maybe at some point these should be CONFIG_
>> options.
>
> Can we drop the second sentence?

Ack.

>> Also, clear_user_page() is only called from the generic variant of
>> clear_user_highpage(), so define it only if the architecture does
>> not provide a clear_user_highpage(). And, for simplicity define it
>> in linux/highmem.h.
>> Note that for parisc, clear_page() and clear_user_page() map to
>> clear_page_asm(), so we can just get rid of the custom clear_user_page()
>> implementation. There is a clear_user_page_asm() function on parisc,
>> that seems to be unused. Not sure what's up with that.
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>
> You should likely now add
>
> Co-developed-by: Ankur Arora <ankur.a.arora@oracle.com>
>
> above your SB :)

:).

>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>
> Skimmed over it and nothing jumped at me.

Great!

--
ankur

