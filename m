Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59703D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9906B0316; Thu, 22 Jan 2026 14:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A06B6B0318; Thu, 22 Jan 2026 14:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841EC6B0319; Thu, 22 Jan 2026 14:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CEFD6B0316
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:13:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D8375A78C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:13:25 +0000 (UTC)
X-FDA: 84360548370.17.33D8465
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AFE610000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:13:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hh7SLXVc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fgtDBYDC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769109201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpTZy6afWjpWo4zdjNe4e4YBPZ85I9N/ARpBieN9jno=;
	b=JkvZ7HzjTwBqhNLBwXkCPPSOTFvgkZehIb/Xhd4YUrf15K2qowasieiiE6OeQ1AHkzmvYj
	oyg1tWL5z+gXX4OHA7PM9DduPX0nZW07vSaxUX+9lW4dR52rrvU+IYFzw6WLjaGvxxaF5h
	IoxQ1b77AcTnXdCz3PGdphotdmQeCo0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769109201; a=rsa-sha256;
	cv=pass;
	b=BmHW200bT8hmYvstXEcrIl5x2DHQTIPu/95k7RGo09nATlML4tqC80rwwL36TtTakizTRQ
	21igTI8FLtkpznbOy6dfv8ocfqRBMNzaio4LAFje9UJPniAoEJ6dZj8P59vASniKtXsMRJ
	NJJkX5Acoehckw4G0CmRQ8oD63KG4AM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hh7SLXVc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fgtDBYDC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgTM5197894;
	Thu, 22 Jan 2026 19:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CpTZy6afWjpWo4zdjN
	e4e4YBPZ85I9N/ARpBieN9jno=; b=Hh7SLXVcR1KWv9/YDcoXgTP5JYa6t5ViyN
	tD4sN3CT0X5V9dlQpWyYtnDwiK++FTuqeloYNdXYUmniivLjhhD8qByM4RFAIrX+
	vjqvHIm7/3Uyoz75NlVE4gObeyqCZKwlGcCgNastL3TUuUp7cspfmLvTh6GNylki
	q2i8LQro22q3GbbIGSuzBESuUlm0J6MwDpvM6hMUMK3lFrEXWPifdyqK4YYj70Oy
	OH8DS6nm0YillGTgnV2NAHKxkH64uyXHHmH91TLswl7sVQta563r4YC6G8aB458P
	UUL3SrybesMr3kHePvxMEQRu655ltvHkPTQaEOr3iE74AvdfV4kw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq07t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 19:13:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MIiH1n024954;
	Thu, 22 Jan 2026 19:13:10 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd0dptw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 19:13:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+Rp9/HxHKnw6Dk1Fri5M6/3jHGxcOPHAvCZ4v50VIK4lp6IqPtH/XxHk1rjypufJDX1mb/6xaa7IBxru2DEKI74Iyh1o6r0AHN0xzUXHGBZgI5+EV6c1UTdRHGEBE2bdajVSUyXWZY+u+HL8XZE0yIlWL7b5L+FYl/cn2Df/FMRu/6CdO4BWFRIGM0JUqXs8sq6/g3hm52LPno64Wkj9QPllMls8AnuCm4EAqYJFgYb550ST/HDEGCi2bbqfu04F8bhOLTMemAf5WbcADYAwPSGk8HvucO+ZWujBprlzSHS/ZX/ZOST9vG6mmu7USYr0fZ6KewjfNSXxCORs+xY9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpTZy6afWjpWo4zdjNe4e4YBPZ85I9N/ARpBieN9jno=;
 b=oPimbLh7yg9Eks6FOATjIGJdGckJky2WHIA5ezTiX1LSAwutNkupKYdxSBoSly1pgzIkuzn7WYQsWSSS0YlfbLK1l/L8nbGMWVTVcgPQNp9WK2xvARqObDzz9BKyoyLYGjIlNatl27zmsUOfWxmMejoZ3dkKemNRdzofH3xqdRJjTWdnia3O0qrcUl46RpHPtwcsKBU/w5S1dnvbjphcrrc7+3/Zz1iMSZge35loe4/f+xZOwKorCPCe6iPsaYJSJBgQ4oSX8Fqnzp0I9fo8BZxiOhiiuVxlm2cuNBSKfvbSThpnHGiRH2Lpg4FEeOamzuKk7JDleEt9SrFdPDLywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpTZy6afWjpWo4zdjNe4e4YBPZ85I9N/ARpBieN9jno=;
 b=fgtDBYDCHnGFfm1hW7U2FRR0pT4JwsgFWlNvfAQdP6emKV1vxk1RwdxE3NTIT5Co2lopmkFbGYPkU3UBu5b55p/ZciquukYMvGgqql/1s/n6NNmWUICWN4aclx0+81vtZd6RY2KZcUFRKOwkQNE5WXUI/ZDlo8CPz36DJ3cF+NE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ5PPFC802EB2B9.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 19:13:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 19:13:08 +0000
Date: Thu, 22 Jan 2026 19:13:06 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
X-ClientProxiedBy: LO4P123CA0149.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ5PPFC802EB2B9:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e1ef3f-032e-47af-6a88-08de59ea46e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lDtqyLDCorVXxQPCiEdMLVgDBekbApf4C7LDDTUDf1ZvmjpZ4DRE93TtbRou?=
 =?us-ascii?Q?1t0yYF4itududLcfd78+tKdB4WX1awXZY2Fxc7GimwLUmR7LQC8/G4Rvd6MO?=
 =?us-ascii?Q?/srFMxIliN34eaX/Hx5TyLo9/JVIATD9VuFKZU3uGDGajWzm5BD3sq7tiIcd?=
 =?us-ascii?Q?srbzu7s0Q+Stvdaqu5KHyIGDUQ+poC/RO4h24VicVN45mSzrj+KRswY6Wn+R?=
 =?us-ascii?Q?oIQm6eEgxxY3a/s2fJ7wVdshXfpZpSnVLMwsNf35nz3+wNstA7Y7apjlE1cf?=
 =?us-ascii?Q?tM13k5kx0OjJUptUC55k7bzfkRJ8DsbWXRcAHNHcr++4eg4IVLhvqC6Ed8ae?=
 =?us-ascii?Q?2HEpSslC+SypK9L/6ljjZe/h8GaL18BP++441RjZjLOjXO+8ytPfNebfmA/r?=
 =?us-ascii?Q?5oahKc8PvVK0OeMcRIQtaij4oeSFmbXqiW3IQFxbXlPefxTzbN6X1S8PU/c/?=
 =?us-ascii?Q?17BrrXD7kwFE4kyYM2EG1MrgZbra2tRRZONI/x2SNHweTvt8K9n1Cd03cevR?=
 =?us-ascii?Q?lug/wSaF696run20SHeq8UuTjdqseXGt9yUHyEnRKa5Sn9gAG4eDDjNWqNI0?=
 =?us-ascii?Q?2389DBZ4ppiqXPOcaihIw2c9fIuBru7Nq+ZOzG5EN9xE4d06cYbN/k+rTIxH?=
 =?us-ascii?Q?KDpOUg8E9D2xWBKTaPochLTjLn++fwXhrSrOMyM8us15Jx+tEe9aI36LVSFL?=
 =?us-ascii?Q?YWDA67uBRt2D06mC4/wCZkbwaBbVBfYhUFZpk9EK6VqfQScfIgpf+eJhdFDu?=
 =?us-ascii?Q?/DHfkLMW2sboBD7QWAcx0w8bTt4nUcHcSpRuNoxk29eoGOkALP4kvUu/gpxs?=
 =?us-ascii?Q?woqLC2PYSUusy4jZor2bEGDftRMNQ07n5xXeBmOmtBZgFQueDGccU26WZKgF?=
 =?us-ascii?Q?o9WXoF23K5Ho2BrlKZDvyMtS1KwTwbq3AzOXx3pb6dZJQyIWttxusNgW5D1F?=
 =?us-ascii?Q?NhTLvPj0UwYexsZocoFZHPgwqMr//J99/ej/jXL8IiAmdTE1t4AGXv1HWlyD?=
 =?us-ascii?Q?sbSAEVBKmodjVJYaLt15IyxrQgpZUOl5csvqzKzyRb5YhvRwNGUGwC/H0UIU?=
 =?us-ascii?Q?qQF9iE7xFZt5dFSSB5oFpgZMd5fhYayWS74NxPIyVMDqUXw0gddwolRh+80b?=
 =?us-ascii?Q?U9sgBAeIGjWD52UAZRYoPM1POFpHz3WK3nc6gxl07LYOMw9hC0G/unNm2gkq?=
 =?us-ascii?Q?7SlgN5Clguhi6aMlkRRaMfTEz7LyipixdCRcbeqo96qvQo0glScr0hvvi/pI?=
 =?us-ascii?Q?jjiCvHsyUrB6TGNSRCdGd4Qd31bbUqgRFbfT2DR5c78lc4jGb1WIIuhKwbif?=
 =?us-ascii?Q?542qsvxrz5JEafGJL5Aeml66DALFrmhT9snLK9vnJwJLUNBFtrJ1GIz3kN5+?=
 =?us-ascii?Q?l0tloXybZPVhkVXlSnQOWtIWMaTT/8k+n12G1HSdTJ0WtM1fj8ZO7KPm6EtN?=
 =?us-ascii?Q?ffMFsmuAm64iZMRIb4OtkOk3uU4o04WNV6TXwmfoemHqJfNs6vnSpsk7Rj/g?=
 =?us-ascii?Q?5okb54ZBP1+Y0PVOm6H8FXqsuP4CFRT0uNBYyl24bGZ4LQRcxbWNlm6pB8eN?=
 =?us-ascii?Q?JxXDCOf/8OljDwy8Ta0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gRALfZT3dPa/2stRwoQR3l/5o+HVUuVkZtHCS27yk5bPY7wa14enRVkaU3Kf?=
 =?us-ascii?Q?+BU1mmoVDuoHUH7c8KNvLJQyEhW7MSv2tcbKBWs6RNF5S8A9VKqGA0TrENJr?=
 =?us-ascii?Q?UeoDXN5ICYR8uYUoBO8okgxQlzRp/cEt/bYoxiDeqDDtujVHr8I7lYR8wswM?=
 =?us-ascii?Q?Q4P+V0IrZjNqM6/MnM2BiRL2u9U2/2fiJ5VEHTou8bjV5XGpfRf3jKyNm+KL?=
 =?us-ascii?Q?spELCsQsr3bkDVtpg4W+szdLpTpDqljiU8ijBlMGrO2j0wcEOitfUs9v8r40?=
 =?us-ascii?Q?eNVKL6mbIC3cRDukLgJFP+NV3xc7IqVotFkWS32uUB+sdlg5lda90+Bhzfs3?=
 =?us-ascii?Q?z3OEKBT+zB3PmWHuS6gprol4vIDAdqOIkn1ZKdqcw7HwrRqIfPQJYZuwAear?=
 =?us-ascii?Q?c2H6pAC0N08w0Qrzxwrdwky7+ckjQbtxyQr2BCd+n5Y+dxGv5E4xiUFqGykn?=
 =?us-ascii?Q?RUGnca4Wf7RjGcuo9RQbxCExkoSHWZ+0x0d9zdblKueCW3ddsdwjA1Zg99h4?=
 =?us-ascii?Q?qEICqBqh8e3RS+OtNcpOQW8wTL5/6QvFmGT9kxpPjdBz2ezCqUZ1kSG3KZhX?=
 =?us-ascii?Q?nZSXoJ0xGrwW0uK7agtuOubPDazNsOrYwpWfQxPv2Fx6ZGguDytaVNqTuLaI?=
 =?us-ascii?Q?SWkUWb6Qes08zLIi0f45fgBJ4sFAfNpWq/x3Ley+O9hoPGjTlUN3ECfIPpy4?=
 =?us-ascii?Q?JHPOPK9764oWUE25oTDVltdONPpifjTMla0Bpq9ExJ9sX11fyBqRa72T4asK?=
 =?us-ascii?Q?Pz0P8Z0axMuBj72yBYMgDoC7ENZTFFvpO2PB/7Kfx2fYcsSJt5x0TE0oQKB1?=
 =?us-ascii?Q?aJZAGPluFPMqvGrsz4YAkRdUV7sRAxsbQi342ZGdIIV0sOtLn5NTa4rhwj0H?=
 =?us-ascii?Q?eSmw2cv7/nNnoEArC9ypfl6Cq6XWwqNsi612Y/JEtsj69dwAQ0g0JoFiaEgS?=
 =?us-ascii?Q?MmCGVyRRg5iDaj7qRlh3QF2DZeapkdvaj+Zzqg+LxSHD2O9bHn9podHzJhA2?=
 =?us-ascii?Q?yZof5FIVydocTfZA9wPm+3JSTH9x0kSv3q9s+nviZtV7yuoxtRTBFF0ug10W?=
 =?us-ascii?Q?S30OYoQs2imfD2pftr36R1A0upM5JLaoL+iVVW5U3uXJSSHRXBtbYDKsf1G5?=
 =?us-ascii?Q?yAZNNw2to1bu/Cw/6eIQXbqbk2r0er+6heaoDY6geT+Zlc87ERUMjz6j8XNT?=
 =?us-ascii?Q?aEsUJePm4W7ueVE5i2IxuEV16IkuHEdOUKbaGsng1tkQoZwb2ODJV2lSFZDI?=
 =?us-ascii?Q?Bs9RD13UWAWuYtHTxvxQcL6segsRazQy3Haew0B0KRFMmJXqesCxGK+i3tNL?=
 =?us-ascii?Q?CLJlXGZuQByep0sNPRQuESXkiKVzwWz7To23w7TKN0FuMf33iyph6MHY278d?=
 =?us-ascii?Q?oVGvkzlIz3B/3nw9nG7m+ZDAPsL9pQgOAwGxbypz/uzuEHeY3VIj3YRE1jBt?=
 =?us-ascii?Q?vEiqh2nswwWg5frV+5qlSMQdrSKy3AN15bXi0/5u7SC3REdBRqJqHliej/Sb?=
 =?us-ascii?Q?HDbbMCOHrzkFEgT8JV2PgkJSKD1JeVd185vIyvylACeQyGOOJAVP3+QzfGHr?=
 =?us-ascii?Q?IWDh+01Ao4MEmy2ZTX8nMMVJD6RLKX/NEM55rL2Q0QCXh8VJprvAWLzPPWyE?=
 =?us-ascii?Q?9v1nY78RJ4PwNIehRcYLgFMgC7WyeaJuzcIfcyVWQPwU4Dsp6hvadN2mnqWW?=
 =?us-ascii?Q?FN1z0D7m7Xh7jvtbzQX1uVW6hBDLNMlnaH/L/wdMGSue0fzvnwianIRtahAv?=
 =?us-ascii?Q?mCXkfh3Yx5/g6t2mmIzDm1X1IpmoPPw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WGmhuls+8OnKP7ngwHD6TmzinMOAxd/kWQElWVX7QbkESJpe4FkyEriCZBqsrfez95RoquMrPvZGtUgOlTLFLR6x65Voo9vRBHTSZe6tIG5UePUhr4uM1rdX9RIy9CI6zdj0chJkbSXmv7tGRXptMiKsEB1j4NLVJ3sYtuMzfP2Gq8L4rYzlD1D6aQ3R7cr/VlsS8l8tDb6PvdX8QlzUlqxEE2KMk1IE8OJa3/dYQwzZURe4fYKdgjsrAffwxkFvUXeAYqwObYGOgT1wcOhs/E5RSvbpSHDR54fTKJEcyXYSk2D9vAIz9Y6uRUToGzTRGR45LVdesVrv0KjJ7T2YWO+lpcBNybBs1l/+mMYl+7P5a3Sjc8xqciBkU2omiK1grVyIJe7aNXweoQp6A93Gr9uuokabdGVDSxtpeBBc+k5AWlZtruR1I55FfCiX8Sf89mkha6KMHWBg93/Yo9baPrZP8d+M77RwNZwfHmzP1o5WZSzo/OHHAkCZZAcPtDjcp6+4Z0w29ofhJgWSv2GLMfcluWfEAv9DUbgiUPoPqZjTN4zavW3Xyua6GZlghTeaflZjv4IO/+u0euHp6Z9m6Igh4wpSrSrJfyFlxq1cRbI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e1ef3f-032e-47af-6a88-08de59ea46e4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 19:13:08.1409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9PgTDlB6vkoftZ9hXb4R9EkdUC93LzfU3+ZFbwgCRJOCVCSeqDbDDguSuQaCOKxAVgUmxTFc7pRa2JJ5BNQL66WIpMaeDq+L+AlPS6QWmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC802EB2B9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDE0NyBTYWx0ZWRfXxaHnodJvZU0t
 v0XFV6iHIbZRL3vwiRdfwygq8VQzTTo62KFxmdOVZfJ8JGOUC+2wieFVVK/9N+naMMWagibL4aE
 s76Gv6dfJ6IV0SRPXvr6P01+BDiBGabUWIbx9IpA0OyFqq2ccYPXLLd2CEcZ1645xDt/rI5Y3g6
 dtiskuNW+CO6QLMPJ4qUiQv3YUTefxOu4YRkpVZ4uyK16FhL4iX2mkiW3OQb/W/v8vEEI/N+lm+
 VHVnCOYmpVZ4mc/QQKcwIQQKkKqYlIMwMZQ9Riv7VWto10tSc+AVl8CKAoh2z+E0CUWLISNgzBv
 GuiFJ3vmDFTU+Sh12sFFQFHlLgjJP5Tud82Qqjg5CznwNZt+tOet32dtu1TPp9XECmVGGpzTu+v
 X2/Auyg1ujaNvlo4XUJLXQTaznCzuEA9iwMRQezQyZhinvoX1im2jPpiCAK5cs82QZv49DI+0wx
 1ZiJCOwoh8MldeLAERd4xTePapba3OC+RLiyLuTM=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=697276c8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=FiW2aNYY9emxgyLVICsA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-ORIG-GUID: QjPdE2xGsN03Ghy0yaw0Th3Y1lj1QsDm
X-Proofpoint-GUID: QjPdE2xGsN03Ghy0yaw0Th3Y1lj1QsDm
X-Rspamd-Queue-Id: 9AFE610000D
X-Stat-Signature: 38nwy5wdm6uejibm9sqaymfzsm75uqrw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769109201-564246
X-HE-Meta: U2FsdGVkX1+67sTl1MNFu6ngtKxcwNtiOAmipY5/jWIyYxQPrnT7oLnMgzqMO+EDBAPXrwbAwxa4PRRqKguXgtwRQmo8p0b1rJErsIluSGF9qpdJBvp9w3sVr+x6rCeDSUUbKWgZESoGgHI1OCkK9gOTQobFv/AWfdp+Rd78lZMINgWgq9pDq8ehMu10iEoqyngJBpjga5L+Mp8q+39OgWywltyMZkqCQbFa9vnAYn4zeDjzXDNCHsYtmi+C2/p6pvOHAFx2enSGy9Pf+J/4fjuRkZ0CbNz4xqw8YTGcAe3Ft9ks6sCc5ARqwjvumBGgWRcbqAdfMAVHck4KgM+Q+KVBlm8w5YgKO+ti9TwMfjisNA3fsB7A3g7L3UJQ9IPsBOOJfXSPbhRmZjyGvZajHsW71m87a+4+j8ADzvleVlRN5GYpwVm1PcO8WKw4lYIZ/vBM/UZJQhFRur1tSNWRmqx7LEtYccMPIcwSD3Ny/xGhyk4IzHhRDma8nv9izt/p7xaFcyoXOSW45cxPI1B+iAzn9rRn952wHLLUk5D8xW1TFZL9i0KPXLjLnR5xxkXRk+TgOWc53CdivKI6lgeQ17uc1QKzwwt34b51yNCSGDma1/s5PEBBBVaoOD4Gu+0w67tQaJCfglELp7p21omDPSC5D7QuKGMa+rmhXVJDLKqnGdeSEx40bJ6F7TdYC80TOzFi1rZ88NDFjlkU+A89Fj+eKcbNVTi0hkiXiJfpLvK243uEd1DQv6pypnTZ8qwTve3CkRraDANHU5zntINhCmfs+ws1nF6vc5dOeL4Z6XEyeFf/mQjz6KzsR8PNx3MIugfBeA5DkOQBfySsTm58rPQvQgpKwmLp5Je2aAjL9R0I2XulXEUcQm9ldk6JVFS8tE/E3mUf/NXVKeC2T1zzYrI02rSCUK0kwB6PV8jaoKElcAxr6pnA3AvCXdUQcDZ4vI5dci1n5/NsuaWO33k
 dQCC1cCU
 dsO6PH8g3Vbbnusf1ji4Txxy6WSmmEr9TMQEdEE5ImK6FiWJm0VxwXGG/Njw0ch8XU+O4m/bbjOK5JgWgjKC9AcgIqhqepKucRmVxitmSPuuUhrcP26E/Gq6YDfDvyGUCtl4xv2X2iAVzPxYUTJOcITFSP8kP/VFL9mnlrXajwXLk7VXoz6GhxD7Hh94csX+vFuXvmueZYHKLUQQ1vtdYLfeBAgQmHqn30hMzvC9+ZHGJxwc1OrCjbav7EMEhxqIGcSiYqSTiSBwkWCTlFJJ/2j6vx4LUOspwx3oaFJJmtvsEoFSYXIr4wIqoPAbohMdNypa799Vo1e86WcT+Djlsqz0maZucKmBDkPrx/33LWIrpGs5qH8QXRwKZVrN8fhFJtwY5c6R3Jjb0aUgIlfKZxTu4MMMusTIRzAjez2vlkSdSkrHyI8QdWprm3GnTU0xYH/wVhuR8hNk/mMorByhOWrt2xvUfYLJvh+D+bazvz9chKNqbAnHYIn1UUguPGZjEvehSJ7JehH71QH24IlAEnqTBRo2OfUrWihvF1KdO7PybwzA37ZenV19vfuwgr00yGLmdxXF4ZOmLUXi30VVC/DGHd7FmvXGFxZHnJId1+EdzctShqv7/rrFLTLj1w/jYLipoB438B4itELM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 01:25:32PM +0000, Mark Brown wrote:
> At present the mm selftests are integrated into the kselftest harness by
> having it run run_vmtest.sh and letting it pick it's default set of
> tests to invoke, rather than by telling the kselftest framework about
> each test program individually as is more standard.   This has some
> unfortunate interactions with the kselftest harness:
>
>  - If any of the tests hangs the harness will kill the entire mm
>    selftests run rather than just the individual test, meaning no
>    further tests get run.
>  - The timeout applied by the harness is applied to the whole run rather
>    than an individual test which frequently leads to the suite not being
>    completed in production testing.
>
> Deploy a crude but effective mitigation for these issues by telling the
> kselftest framework to run each of the test categories that run_vmtests.sh
> has separately.  Since kselftest really wants to run test programs this
> is done by providing a trivial wrapper script for each categorty that
> invokes run_vmtest.sh, this is not a thing of great elegence but it is
> clear and simple.  Since run_vmtests.sh is doing runtime support
> detection, scenario enumeration and setup for many of the tests we can't
> consistently tell the framework about the individual test programs.
>
> This has the side effect of reordering the tests, hopefully the testing
> is not overly sensitive to this.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Thanks so much for looking at this! I'm keen to get this sorted ASAP as I'm
concerned we're missing test failures a fair bit here.

Will help out with review on this.

So yeah obviously this is kinda crude, but if this is really the only
possibility at least for now, let's run with it because the present
situation is _SO_ broken we have to do something here.

I feel it's fairly urgent so :)

Just a couple small comments below!

Cheers, Lorenzo

> ---
>  tools/testing/selftests/mm/Makefile                | 29 +++++++++++++++++++++-
>  tools/testing/selftests/mm/ksft_compaction.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_cow.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_gup_test.sh        |  4 +++
>  tools/testing/selftests/mm/ksft_hmm.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_hugetlb.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_hugevm.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_ksm.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_ksm_numa.sh        |  4 +++
>  tools/testing/selftests/mm/ksft_madv_guard.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_madv_populate.sh   |  4 +++
>  tools/testing/selftests/mm/ksft_mdwe.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_memfd_secret.sh    |  4 +++
>  tools/testing/selftests/mm/ksft_migration.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_mkdirty.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_mlock.sh           |  4 +++
>  tools/testing/selftests/mm/ksft_mmap.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_mremap.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_page_frag.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_pagemap.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_pfnmap.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_pkey.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_process_madv.sh    |  4 +++
>  .../testing/selftests/mm/ksft_process_mrelease.sh  |  4 +++
>  tools/testing/selftests/mm/ksft_rmap.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_soft_dirty.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_thp.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_userfaultfd.sh     |  4 +++
>  tools/testing/selftests/mm/ksft_vma_merge.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_vmalloc.sh         |  4 +++
>  30 files changed, 144 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index eaf9312097f7..69f10947735a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -146,7 +146,33 @@ endif
>  TEST_GEN_FILES += write_to_hugetlbfs
>  endif
>

I think while we're being crude here, a comment inserted at the top of the
Makefile is sensible?

People have to edit this file to add a new test anyway so should see
it. Something like:

# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
# script so kunit knows to run it, and add it to the list below.
# If you do not YOUR TESTS WILL NOT RUN IN THE CI.

> -TEST_PROGS := run_vmtests.sh
> +TEST_PROGS += ksft_compaction.sh
> +TEST_PROGS += ksft_cow.sh
> +TEST_PROGS += ksft_gup_test.sh
> +TEST_PROGS += ksft_hmm.sh
> +TEST_PROGS += ksft_hugetlb.sh
> +TEST_PROGS += ksft_hugevm.sh
> +TEST_PROGS += ksft_ksm.sh
> +TEST_PROGS += ksft_ksm_numa.sh
> +TEST_PROGS += ksft_madv_guard.sh
> +TEST_PROGS += ksft_madv_populate.sh
> +TEST_PROGS += ksft_memfd_secret.sh
> +TEST_PROGS += ksft_migration.sh
> +TEST_PROGS += ksft_mkdirty.sh
> +TEST_PROGS += ksft_mlock.sh
> +TEST_PROGS += ksft_mmap.sh
> +TEST_PROGS += ksft_mremap.sh
> +TEST_PROGS += ksft_pagemap.sh
> +TEST_PROGS += ksft_pfnmap.sh
> +TEST_PROGS += ksft_pkey.sh
> +TEST_PROGS += ksft_process_madv.sh
> +TEST_PROGS += ksft_process_mrelease.sh
> +TEST_PROGS += ksft_rmap.sh
> +TEST_PROGS += ksft_soft_dirty.sh
> +TEST_PROGS += ksft_thp.sh
> +TEST_PROGS += ksft_userfaultfd.sh
> +TEST_PROGS += ksft_vma_merge.sh
> +TEST_PROGS += ksft_vmalloc.sh

Is this something that only kunit will interpret, or will it impact the
build in any other way?

I'm guessing the former.

>
>  TEST_FILES := test_vmalloc.sh
>  TEST_FILES += test_hmm.sh
> @@ -154,6 +180,7 @@ TEST_FILES += va_high_addr_switch.sh
>  TEST_FILES += charge_reserved_hugetlb.sh
>  TEST_FILES += hugetlb_reparenting_test.sh
>  TEST_FILES += test_page_frag.sh
> +TEST_FILES += run_vmtests.sh
>
>  # required by charge_reserved_hugetlb.sh
>  TEST_FILES += write_hugetlb_memory.sh
> diff --git a/tools/testing/selftests/mm/ksft_compaction.sh b/tools/testing/selftests/mm/ksft_compaction.sh
> new file mode 100755
> index 000000000000..1f38f4228a34
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_compaction.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t compaction
> diff --git a/tools/testing/selftests/mm/ksft_cow.sh b/tools/testing/selftests/mm/ksft_cow.sh
> new file mode 100755
> index 000000000000..1e03a95fd5f6
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_cow.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t cow
> diff --git a/tools/testing/selftests/mm/ksft_gup_test.sh b/tools/testing/selftests/mm/ksft_gup_test.sh
> new file mode 100755
> index 000000000000..09e586d2f446
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_gup_test.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t gup_test
> diff --git a/tools/testing/selftests/mm/ksft_hmm.sh b/tools/testing/selftests/mm/ksft_hmm.sh
> new file mode 100755
> index 000000000000..0a7b04f454d5
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hmm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hmm
> diff --git a/tools/testing/selftests/mm/ksft_hugetlb.sh b/tools/testing/selftests/mm/ksft_hugetlb.sh
> new file mode 100755
> index 000000000000..4f92974a4eb5
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hugetlb.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hugetlb
> diff --git a/tools/testing/selftests/mm/ksft_hugevm.sh b/tools/testing/selftests/mm/ksft_hugevm.sh
> new file mode 100755
> index 000000000000..377967fe9c91
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hugevm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hugevm
> diff --git a/tools/testing/selftests/mm/ksft_ksm.sh b/tools/testing/selftests/mm/ksft_ksm.sh
> new file mode 100755
> index 000000000000..f6a6fe13a3b0
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_ksm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t ksm
> diff --git a/tools/testing/selftests/mm/ksft_ksm_numa.sh b/tools/testing/selftests/mm/ksft_ksm_numa.sh
> new file mode 100755
> index 000000000000..144b41a5e3bb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_ksm_numa.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t ksm_numa
> diff --git a/tools/testing/selftests/mm/ksft_madv_guard.sh b/tools/testing/selftests/mm/ksft_madv_guard.sh
> new file mode 100755
> index 000000000000..2d810c049182
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_madv_guard.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t madv_guard
> diff --git a/tools/testing/selftests/mm/ksft_madv_populate.sh b/tools/testing/selftests/mm/ksft_madv_populate.sh
> new file mode 100755
> index 000000000000..127e22ed02c4
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_madv_populate.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t madv_populate
> diff --git a/tools/testing/selftests/mm/ksft_mdwe.sh b/tools/testing/selftests/mm/ksft_mdwe.sh
> new file mode 100755
> index 000000000000..3dcae95ddabc
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mdwe.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mdwe
> diff --git a/tools/testing/selftests/mm/ksft_memfd_secret.sh b/tools/testing/selftests/mm/ksft_memfd_secret.sh
> new file mode 100755
> index 000000000000..56e82dd648a7
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_memfd_secret.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t memfd_secret
> diff --git a/tools/testing/selftests/mm/ksft_migration.sh b/tools/testing/selftests/mm/ksft_migration.sh
> new file mode 100755
> index 000000000000..7cf37c72d26e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_migration.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t migration
> diff --git a/tools/testing/selftests/mm/ksft_mkdirty.sh b/tools/testing/selftests/mm/ksft_mkdirty.sh
> new file mode 100755
> index 000000000000..dd6332df3204
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mkdirty.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mkdirty
> diff --git a/tools/testing/selftests/mm/ksft_mlock.sh b/tools/testing/selftests/mm/ksft_mlock.sh
> new file mode 100755
> index 000000000000..1e25ab9fdc8b
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mlock.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mlock
> diff --git a/tools/testing/selftests/mm/ksft_mmap.sh b/tools/testing/selftests/mm/ksft_mmap.sh
> new file mode 100755
> index 000000000000..2c3137ae8bc8
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mmap
> diff --git a/tools/testing/selftests/mm/ksft_mremap.sh b/tools/testing/selftests/mm/ksft_mremap.sh
> new file mode 100755
> index 000000000000..4101670d0e19
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mremap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mremap
> diff --git a/tools/testing/selftests/mm/ksft_page_frag.sh b/tools/testing/selftests/mm/ksft_page_frag.sh
> new file mode 100755
> index 000000000000..216e20ffe390
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_page_frag.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t page_frag
> diff --git a/tools/testing/selftests/mm/ksft_pagemap.sh b/tools/testing/selftests/mm/ksft_pagemap.sh
> new file mode 100755
> index 000000000000..b8d270fdd43e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pagemap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pagemap
> diff --git a/tools/testing/selftests/mm/ksft_pfnmap.sh b/tools/testing/selftests/mm/ksft_pfnmap.sh
> new file mode 100755
> index 000000000000..75758de968bb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pfnmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pfnmap
> diff --git a/tools/testing/selftests/mm/ksft_pkey.sh b/tools/testing/selftests/mm/ksft_pkey.sh
> new file mode 100755
> index 000000000000..ac944233b7f7
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pkey.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pkey
> diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
> new file mode 100755
> index 000000000000..2c3137ae8bc8
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_process_madv.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mmap
> diff --git a/tools/testing/selftests/mm/ksft_process_mrelease.sh b/tools/testing/selftests/mm/ksft_process_mrelease.sh
> new file mode 100755
> index 000000000000..f560aa5e4218
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_process_mrelease.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t process_mrelease
> diff --git a/tools/testing/selftests/mm/ksft_rmap.sh b/tools/testing/selftests/mm/ksft_rmap.sh
> new file mode 100755
> index 000000000000..974742b9b02f
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_rmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t rmap
> diff --git a/tools/testing/selftests/mm/ksft_soft_dirty.sh b/tools/testing/selftests/mm/ksft_soft_dirty.sh
> new file mode 100755
> index 000000000000..d160d7fea0a9
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_soft_dirty.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t soft_dirty
> diff --git a/tools/testing/selftests/mm/ksft_thp.sh b/tools/testing/selftests/mm/ksft_thp.sh
> new file mode 100755
> index 000000000000..95321aecabdb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_thp.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t thp
> diff --git a/tools/testing/selftests/mm/ksft_userfaultfd.sh b/tools/testing/selftests/mm/ksft_userfaultfd.sh
> new file mode 100755
> index 000000000000..92667abde6c6
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_userfaultfd.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t userfaultfd
> diff --git a/tools/testing/selftests/mm/ksft_vma_merge.sh b/tools/testing/selftests/mm/ksft_vma_merge.sh
> new file mode 100755
> index 000000000000..68449d840680
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_vma_merge.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t vma_merge
> diff --git a/tools/testing/selftests/mm/ksft_vmalloc.sh b/tools/testing/selftests/mm/ksft_vmalloc.sh
> new file mode 100755
> index 000000000000..0b5019a76612
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_vmalloc.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t vmalloc
>
> ---
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> change-id: 20260119-selftests-mm-run-suites-separately-6a4dada136c4
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>

