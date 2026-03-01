Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63ACFD0062
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 19:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359996B00BE; Sun,  1 Mar 2026 14:29:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2046B00BF; Sun,  1 Mar 2026 14:29:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169E66B00C0; Sun,  1 Mar 2026 14:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 022BF6B00BE
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 14:29:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 965171B88D5
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:29:36 +0000 (UTC)
X-FDA: 84498483552.13.927EB2A
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0D45140005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:29:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SJShKU4H;
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772393374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
	b=VDB4Fb4vs/UuEEhlUND8PTQAb5c/UowQgjM0sOkn6kLxFO4SEenoNz86b/9qvfSGYhrVVS
	HqM7/WdQwRPJbrpWTYyenb6YlfBrWFDsQ9a3NZgw+7GwOKEue8XNvOEUX+Cxahpvfascw9
	9v5hTplcigQe7o6Lzu76C6RujjP7+as=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772393374; a=rsa-sha256;
	cv=pass;
	b=q36CMMmZdQUt5mOcWCH3PdA+9ueH7dHYKN9uDyRGWuksI4G6EGQo4ecMkzA52yfZggZ05T
	fb9ZN9Jgk2W/UB08ACgNxxH2GYqy2E4R9VFd6a+1uwEN8NLzDd5cEl6/0Ti81bLN8jYZsL
	U1iIoQ22T+9ZSn+W3l5bUM1AeZo5Prg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SJShKU4H;
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g8DeFgY9VFqnccMTyprbrZr0bYlxVsSY5T+1f+zX3/hewlsop/K6Zdxcanb6rDmG4f/3+u1g2es5sEAfBK0m6dCA0RcWYUHcPcPI2FwMCpJ7xogfS/7/chB8UZYTRtMR+DQU5FAzu75gMz8NpFz1OGZzw0Zvkdr+rKWF0uj2F+ZAQiCsvhtmGygDCARQ+Z2hVfpD/Xw5REjGEgUP7q3ST77NhFZnuAhHFewgYzfQvaCBNMtLLBc/sxIKVdG69nu0MP/fsWFjAcZVI4ZBJdU7lMu2AaABfZNaFT7rEbSP93H4If7Nwh2sL2TJbW82esnCwCGAeqHYRffh6STemVvzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
 b=ZDU5qDayi9ec6GH6+Y60Jv4RtbiUmI0L9WrZIAeiTAOEm2zWWF5JE2A8Wi3m9iiYrMsGXr8v+Pgma134aHRKlJaLYVL84DgsBOWq4rTGHpOm7DL26z7VRvRNt5oisV7JGMWo516HG+3/UY6/3Rmc5y/e9DW9c+RR4c6vUWS5c6Z2hQ8cTPerBmZ+LS1m/Cj+5kJbivF9tp8si09o+IpCooSbRqq9pa2tjbpY1DWdp3VDiAxreX92nfXdUy0zBHg6SJap+FYefI+34SAMpOUzqhyZ+nMXInVSKeP9tmFAFUR9rfAyaoxBpqo97wT+cgmttZpaDvVhFkgdqR5x7DkxFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
 b=SJShKU4HXjh4jsRDGi3kXfBqZJPfneihYXwl8HIPyGh+Mro88TbRpwdChZWxBgxiThMr9HbrevVL4Bhi5qQCZ/gJlsl6N4cjmfQivQzFu3Tk/z5Ud4pVZuI1uVufubZvKdv1LgjADZaAlBFBldVD2L2ZFqjIjzK80FTpKagAQKT3dI0Xb8kX1A9HyAt6LAjlqhfF++GIdHaJD+jpshhdgw+Q+xK+aDJSYmGLTd6LebFpVSBm8zuTQdHIQBIwwIfovkMY4EDT3CsUyDXiou+7dAx8R6I1UZXjL3iR+wAGODGoZy7rUe3mXC7sKuFSsr0cfLrImzkexH1hx2hh9zAOwA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Sun, 1 Mar
 2026 19:29:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:29:25 +0000
Date: Sun, 1 Mar 2026 15:29:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260301192924.GR5933@nvidia.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com>
 <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227112501.465e2a86@shazbot.org>
X-ClientProxiedBy: BL1P223CA0034.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d723bb-316c-49d9-0b0c-08de77c8d93f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	5bFEiRkDkqiJ6IwnEZJuhEuWjuCHm12MZ19LH7aM7bKNEru+HTQArfq7q7KMj/MIio4oRQyI/y7Sq5e4AcGsG61pWdPVrnKx70SpThRazmyN7iWZSPRD79ed8PxbOS9UwhhNvEemPuTnFPOsrqp/lUFjqmD9Ow/uhQYcxZO6uI4TaNR2+j9Un3B4UTr+FcNzwn/jJYU84UWGvzbub+X9mhYLEWKi7f8+uwE5kRAl/QxCcK3LGhI6D30goSheut01l2qqG1ebTHyW1RPNQgWF6E+Smu+jKpQZUCsQ1BjWnRvma8RZNQhevRFYnz68gMXSVXzs9S4kiUmEuwiBpaDnp9r6yHXQ8MKIBONAW7dSt15RwlygJu93AJ22QFDBWENLNNXuA8oQ6KoizH5Q54nqSFqnxKAUMwtkcN2gHdwCqwpzEuza+AY7OQ1f0Hi3jWyI4NCvSYSXyAnCraX6RPUjAiHKsL8dLf80OH6ZbY9ckhdrMJ+u2ikgxciuR1DWd5wWlM1faDFaVgrNcYqzNe86JewtrRmfKsJsTYG59bn8NZ5oO9uxsk7CfQiqIK19c/kLGgZQSOSFq9/EnXvpQJVcN4EU/8uqCx+PIyUbjasqA6w181PFFFKwuwGqY+dZwlVpqNZlUZLQ4QkiMlfu2lG8i+d/Gcs4pg4DNZNAYT/htPMuO7olRL11iL0K3lGx/iAqCUtKfWj9zRnuRsJmUkYzZ0CbPlMoUDvE7wQ2hQATGU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TNPJx7wggLy4ocH9Yj526ndA2xiuMcYpbDiyVtcJVloJN2MNyVX0dky8G6o3?=
 =?us-ascii?Q?Z8cv6MUa9OAlM0/aXv+CHgPmMXXhXjipvH9ZgdY56XMT+T4700912B8S2rPz?=
 =?us-ascii?Q?iHaKK7P3lzvi01k/vliBrh1Tbe1B5L93wiI3AXTnwFa5hilpYw2bSTXx7JQa?=
 =?us-ascii?Q?GZCvItojrZTUnCkJL4AAGtITOsGhqdA4Fl4VjRWA8Uws9Fqlx0YGuyujCiJM?=
 =?us-ascii?Q?vWzv2yNprubnoulbUPnWxW4t8kffxEevikL/eyytlcE4rO4bcjmOo886xddM?=
 =?us-ascii?Q?WyfiFBJBoWgEb/t9uplOIoWYcRpD/qs8fpnwWE7sPJuHyfcO/VbwyMWv963L?=
 =?us-ascii?Q?hCsT/ko+n2vuS6HlGlRFrQvERM6OFsgAC4DDBh7Tucf6jiSnIR8jCcSMz2Ma?=
 =?us-ascii?Q?mDAm0QLUv5m6hTYtpn6trZ+HZyULme8ePNSFPcyI9QQ88C812zFdWY1Q1syv?=
 =?us-ascii?Q?hc4uGgMucDGtMwOSWyjxWkdfuI4MaAkUa15Nvh0uOpUwadWDWQMxblVAYkyO?=
 =?us-ascii?Q?Kezzz+gmzhQjYCz4gqe1UW7nQ27AwWKxTAyJVnBr+edzEKjzQVWxP49Eubpj?=
 =?us-ascii?Q?NvPhO88soTJb6O5iUktO6X0oq7Hcb/6evS1fOdzY/GCJZPd19BybSgdfpWUw?=
 =?us-ascii?Q?mnkp9VERuyiUt1fNPFvsv4YOVBtSSBop10GZt+RYLrR6d9qcZpI8fjstVwao?=
 =?us-ascii?Q?de8tsFIyIRSOjTDxlIyG16p5xnPju5D9Trdq/AXfrlAx8rXzMcDH+MgrQsP9?=
 =?us-ascii?Q?OwTM4JQV5wExpGMa36BHFJkbaNqjrrOCnqw+10eAiVV+SFu0eXvt/mCGvUcs?=
 =?us-ascii?Q?9IlgLPyAmX3sjF37sYMIEY860zB1vZMHw2zw/K2Ty+AY06aohfpZobiAsYEK?=
 =?us-ascii?Q?G5eeXj7HIdDExou4HbzHIUz8yjyRjHbX2S3uNyZoDMVtg+Ub7w17VeoZrUwu?=
 =?us-ascii?Q?eUsCUDciOcg0Rh7E0a0jQcgZQAIDHWVHc+1Vslp7F7xbRX03F8FbjS836umr?=
 =?us-ascii?Q?kRmF0wSYO6HCJk/X9i/O4eh9wz7/28u+3Bhzd1vdzAxnuZpT3mUwD8aXk8sI?=
 =?us-ascii?Q?4ysHAQPjxjNVqBFJhIlXd9LGvJHTHuaCoa0rexi7xlfsEM20c/KdVs1q3hkO?=
 =?us-ascii?Q?tmyGYQ7ved2ERw3guEsRQHbsBij83RAkzOTFGcHwadAUg2m63yO1VaKIUBx4?=
 =?us-ascii?Q?NiOWZnSGUmethPQLBdv80tiQTUNcStG5FrY53fkCBDg1P9dEwEFK3e335V+P?=
 =?us-ascii?Q?l1RDrKDOpThpcIqrGRp++5EiDwmzAUs0rVe0tEGHxmHPF4gIgNNLb7QR9rB7?=
 =?us-ascii?Q?VAP1VmArGbqiuzDzOa+KFMqBjYFVeOth+79glViDG1SWuI3B292NaEJg7uTl?=
 =?us-ascii?Q?eFYbPrMN21Yv7c1ZCBFj4KslBIzMIKkRQ8uFpiOTiTWV14/IWO4ktrLuZyhW?=
 =?us-ascii?Q?opRZTyoJVj0X91dareYv74udyq749QFJOPQXB3iAs3agU009xCXO5YqpNlQl?=
 =?us-ascii?Q?k6QuF/hORqZIwM1UTi07c9V2l1BhVbOhfokwL8g5QYL99fZSMhuUS8dcKgNV?=
 =?us-ascii?Q?3hRMnKRMcbE/lIAzyAw9KWkDBVWXivJ7VjbFgkRFcgdP1tnZwIhPj1+7vhgx?=
 =?us-ascii?Q?T7P13E+PSbbEOmAVO9vmmaQV61HhwBWgYR6EjCtPPK6dWTXNRCLM7ev/IZgj?=
 =?us-ascii?Q?7Ldo1ARlIt/zqIzSQ+Z+lrOFEbWqGb46ZS7gIPna0V0hXANnpg49BDCr+D/S?=
 =?us-ascii?Q?cGg1zuDQ0Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d723bb-316c-49d9-0b0c-08de77c8d93f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:29:25.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpLA7FfUJaPCXb0GSlpgepU3bVCHItRLhSTrLmdhlr/muqZmEJogeXj8Bv0ZuMA4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0D45140005
X-Stat-Signature: ent6wqipo13idd1x4byg77hmwqkawf9t
X-Rspam-User: 
X-HE-Tag: 1772393373-340692
X-HE-Meta: U2FsdGVkX1/VMhajpPZQLUgcQqJtdpKKrLo6PMk8c8EEYmxm3Kil8HyLylvl99A489cjz7KwkOUNGlzWAIAUzg42cUHC6yZR/7JZZw4zY9sHmKYpQ/vN3/QD01eu0rYu/n6YWIy+l368+DMI7asGY7qM2KCF6xVEOFHVWJgv0A1RT9O847ZFyphM0g02ac8+TvWKtZgzctcuhEB9FDtj/AvxUODBDbVZbdTHbwPSw5g46X0Mg3/JfLQUaSBlNipBB6zVA9MKJ44/8wi+8T2bJbyRX5EFTyTGDTDlHJce50aI2TsGC7sBl+3lO1LYCcm4/EcQoh0a9utZzG0eRYQkfeLsBIk5bUT9QwWqqOl03eapM7/xwz3ksHFUN4r6tLmgaM3ZOEtllXOEytsgCXXjtu+hC+CpI0oqrH5g55hZ2YXhRRfADT2pSLiKARffjqkzzR1ofiU9TjTVyBjLSTg12q6Ftve6zKOGh+tRMXk7ikEUP02AWfgrfr7aYAT30CLyCTaG38V+Qr/W7FPLlH/MhxKS5PMJGSFSKG4nzRJDE3LD7W57uaj0QeNNoE81cDKGsyZY6n4N7ilBPsVlCxr7c5lTXQ4biXBcQtEuAbMQpEIHfQ3jUTuqGua7Kiba7KqPKb77wWbrRBCfezPPPOWq5U8jg50+T6kteisdlmlyHNNwgwzN7A5thvHyIw2nDJ6FSqxg0o9SwWPPJZnD9EtLICFCLCIjnBKA90us/clx3cwoU1hZOJggPgCD3CEH6lwshXJydheyehft4CmSzRJIlObKqtVCO0ZyxbWgdK5FR6jRRC6jLBTI/VGFBG/PwYEqcfwGgvnYjD8iGCiuwoGZXkf7j9xwNBMH0owEOV3vOaBL1p04I6LgXyC60DT2sbrkh5+acX0pUHYWzORU6Xyr5eDB1dxZKDOLigabocMKtq5qT2XtyM8/U2HUtY+OqHps71xFDV3vu4mJkKz7G1Z
 /CirRDe4
 TkPYAuUF3LbkCTo9c8db6A2WvXEBFWOluoAWoc2UWn/fLYHt9gp/irFpmhw0eJtyEIFXtTe4+858wbPVqGm/qruV5WISc6NMIrJvQkeg26oeiZRjWOA4dQOm1bE9KL+VC3GYZJHRqCX5cfMjGp5ePgaww2CRFuUGsOWFY23LZ/cgMz2fUmWTTvLbW/kXNVyYCbYx+CzTu1CLGdJRjuUSG1wiio9mObD8PZWT4CyylsqJfrERaXTiqIJ5YfDyRMsIMSjnj3DSkTLxtNMQIpSa/wetKEXZ2xQHlJhumiEDPeCrH+qbMlW8SEP5ohfb3stAyr9YQDTR4LJdSh9MSssk8kwUkMIHZ+fC8PZjckFcZLfo3bCZcd+5750BCe/QD6icDeoDDowqLkha9kg1qBdIaGhmxPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 11:25:01AM -0700, Alex Williamson wrote:

> There's obviously a knee jerk reaction that moving PF drivers into
> userspace is a means to circumvent the GPL that was evident at LPC,
> even if the real reason is "in-kernel is hard".

Given we already have GPL licensed kernel drivers for the PFs it
doesn't seem like a reasonable worry to me to fret about some cut down
version of a kernel driver running in userspace.

Further, let's be honest here, the people most interested in all of
this are doing it to support their proprietary VMMs. I'm pushing that
we must have at least a reference implementation in qemu before the
kernel parts should be merged..

Jason

