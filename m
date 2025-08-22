Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D59C1CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A22A44015B; Fri, 22 Aug 2025 13:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251EA8E009D; Fri, 22 Aug 2025 13:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140ED44015B; Fri, 22 Aug 2025 13:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F345E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2778C0297
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:11:28 +0000 (UTC)
X-FDA: 83805034656.08.0C56C28
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8D21A0007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:11:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F55aswAC;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6rO5k2d7iqus8xx5LfiYGkwO0tj+CarENOjjj4ZxHg=;
	b=ahSspCQFDrXVSikjnEiPyhTI18pfqk+O6WsNXYAJHiTCJGyiK0T0EwZNsg11Nx/yumkTXF
	r+1jeQ86zzpAPocpPDvlemUJapW4KCBFVaaIw/heCGPTawbSeCvl4f7zvKXWgFgkOrjR5T
	z7wvlRpckvmtofjQhdjiy7VSaMzogKc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F55aswAC;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755882686; a=rsa-sha256;
	cv=pass;
	b=MZwr+dVa8cBENVOgh64J+cHBkV+3dkKZMGyhILq/RNZ9zpjrd55KYTWjV+N6eGyTcvYY7f
	On5fTtm+IoWd2gkateuJmaA3cckCjZU5uApoJJDQCXlhbjCCehU+DF+CQdmyB6qzCQxE+/
	ujLiieYHcaFEvXQFrkNO0SBNmezuKSw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mu/FbQ3Qhv2wyepYot/MmE0corw4/QSx4SYq2tyScSriKghnL1CPpP+HEpMCbqil10T2T7oDNAtGx8+51+MJsdMf7vVDP4ONlyIYo6WweuqD/uuL7X7zIBQiJPCgfMIR7uBlvIr3g465yYvGi0nDLEGZ+nL/D5fEKMsv6ZIneBGYRVTJdhFVMTD6fahYxrx+BWrXJpeGrPi0kpRlmQT5agzXi42dZM6fh67UUDKwCVNkS9+vE1Hqv+RkmHRF3A3NxJ0iUIXKUHo5pvMB3Dnke28cnjrrK4wVT/Onuj+gFmrN8Valv5HX4kWsDnhcJbV0bE7KknjEc21itWoa1LbraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6rO5k2d7iqus8xx5LfiYGkwO0tj+CarENOjjj4ZxHg=;
 b=eUpNK6nvHH+d4+b/r1Tslm96BRXnnZXHbS8dO8kQf7HIPsMa2alYsX2fBOEgjzjioLXk9LmgMWewyfpb0+A8+Udw/z59wmPRgOHBG6slhWEgWrIobeJmFncjJdsl93a0Hq2OnIVKZCIUTvMv7t90tEj4nArU+knaYay6pBkTE3wtnPfX260tTMQBHUF7yE6lDYTYM6D18UtqomBytXt48uaod1MpV6EhS04kzrIOY/t5oF46CSeHmPbv/XAS+wKFomddWxeCyZk3U09ZGuj4EmdRBgjrivX2tziPTZGXzfD3DLVhy+WFEc3RSqKbVfneHzGIHEL1v+ICBo3AuqAnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6rO5k2d7iqus8xx5LfiYGkwO0tj+CarENOjjj4ZxHg=;
 b=F55aswACn+OLERP7wm4IKRBhfOTJMdAWEwO4V2G543ACBlmZXpvwNApgvUNCyxNdJL38eBnFyvDaqMToWIMksS6ifFsvUzxhaiWCsxS2iQH4dbblPBaBSVNifSuEVJjNt9DOLsaRhqSKfsek30cS4+5l8D9z8RDEkAryAWVnaUzCov1zF9dLRkAJts/KCL8CfjX17jtN9h0woAZipTvqMPNeujLG1H4HQHruG3wFZeJvL87pM6LmsUYqi2qS3nhCv88hxk3gTWUNWHtKnXBD4ZBomVanvhIcLupqf0Gcl6mvuUjaYyfY7ZuNnwBsc8Pkhsi4dEzl+x1R84cpZNzdHA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6845.namprd12.prod.outlook.com (2603:10b6:806:25c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 22 Aug
 2025 17:11:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 17:11:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com, kernel@collabora.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 2/8] selftests/mm: protection_keys: Fix dead code
Date: Fri, 22 Aug 2025 13:11:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <946BF413-2C8A-4EDF-8C8F-915997339BED@nvidia.com>
In-Reply-To: <20250822082145.4145617-3-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822082145.4145617-3-usama.anjum@collabora.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:208:a8::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6845:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c543e15-34e3-4576-6fba-08dde19eea85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SCIFdSYVIn/BqJMH5CSSw/o5i3jVMJjJMfZVP80jnNeFeyYq+8Tif/j5GOEY?=
 =?us-ascii?Q?xEkoMgRDpcK3I5RPfQJ2XdWyDhp1E7fvwHm+W/Sh1z+9N0buKKfBaW3P+1yw?=
 =?us-ascii?Q?A21SZXwUyyS1XD6io3eQKvjYa0unUZ6PLn1MBZez94VmMaHG+l8YBcz3hUTf?=
 =?us-ascii?Q?hefwStgvGOvK0L2kEO5zOzGkTA2BzHwrefZs6gqZxcWCFHHryDcI1CK2+u3X?=
 =?us-ascii?Q?SvaC6rlSz6jhp9sRs2TyqNrJuht1BdkE1fDBKxZ2xeS4KgtKWKA9rcLPzyNp?=
 =?us-ascii?Q?4LH62Bp2DoAZBHNuxPVwPU0BnDMAVe9xwVvbnby0KeFNl3rNorj/lODLNif/?=
 =?us-ascii?Q?egxDPCZOgO8NNqUE2XFAjXCTZk0DHtANWSTtf9+pqKDbl5YK0IrO5+Wek/K6?=
 =?us-ascii?Q?IgBeUblEPBnCnkKJ/LkXqIag1A60x+ztm2Fl8dXeWoYnRonP1H5uXjlEwVyb?=
 =?us-ascii?Q?u/hkpYq/FpSr9pFsdN/qjXLii/fsHHcl8fnFBam2aD/AS9U1NhX0NKOvaltC?=
 =?us-ascii?Q?rD62wRxFHIj+48ghlN7iTnSSwewi2WSMqSaNlO8Y5JiRvUZu4HGvyzbdoTGZ?=
 =?us-ascii?Q?Y/mQ5nJbfqb/ufseTg9DP+6HKOSEwvOQ/iZB+ahjy6lJoSSVw0f6XDV/idKL?=
 =?us-ascii?Q?f9MiRH8uo+q8Pfku5eaW6U+wf8bUVy2JWXcsj7NkP5H6jlzYMj38xojwsCDQ?=
 =?us-ascii?Q?O4xkxVcWVGunU0FcyRya5xS/dohN9ytC/ShOCqGYcRxRtn+3C2dPxzfyg16M?=
 =?us-ascii?Q?EizkJ3AlzRy6hAQUYQ2YB51UQSP+hS43LbvwHDdGqgxbdseHvk/njsPBPcLc?=
 =?us-ascii?Q?U7xAy5D8JBniI4wstPiHdVi8BmlEqzGXivYsNZrcSLlVvCN3D5wWqsbXyLpX?=
 =?us-ascii?Q?ExyDfi/IcGdfGSJXPjqtI9kVRRk0Z3n6hRsjassD5GOJ5EtjanfcpjemiSdL?=
 =?us-ascii?Q?eaeksKIs3tXCI6R9FNeVjSckxFbOPPUkds+ecmA1EQLzldZliofhT5pm986q?=
 =?us-ascii?Q?iXIpVw9EctnXMlkcpit0KDit5BIqi/2JK3b5l4/861QFEMrgdYL1CfvEvvFw?=
 =?us-ascii?Q?z0NjfI11HKI4VWoLMLD6s0YLg1Z3ucBTD5Jsao15mSc/fIyqLWq7DtxFVC82?=
 =?us-ascii?Q?z3tYagfXJaxgeWaNfSoMuesaptdzkQv0ZivvXRO6fsnfLGxGDi6wgEkmuNUb?=
 =?us-ascii?Q?HCiMO//vyquY3ACdWwWdk5flLyg4dU0bUfFpIAWT3FoZHLfcjr4TqXaREamL?=
 =?us-ascii?Q?RXk4su6yJNQ4vIcNP9IxTFOoLJnTNvqbYumEJu6WF2grzo6xy2sPEulJ8Pvu?=
 =?us-ascii?Q?36eMJ5FQ7L9bFTaigYAYNTkZ3L6VUmTENwq4AkF1U74BCAcocZ9JnZqTXIlv?=
 =?us-ascii?Q?l4reUWcsEkmJ2XECC8EHH9lDCFW6HXeDBrAkuwr7N1Fmy6C7WeOiBhsUckVX?=
 =?us-ascii?Q?McgbNhP1Ekw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UAdoG4n7AAhH2v+teq/4Z7UfqYhqnhoIuW/z0rQphzUCDTxxSS9TmP46ZptY?=
 =?us-ascii?Q?8iQstKg5Cs1UFYbz/gVZpmuoc85xolNh6WqSG71AVi+XkQRxEq4HvzLadtZH?=
 =?us-ascii?Q?LLkoYRmQ6WraXsq2WV3Iwng6k08JnuBIxMPLBKq1wP81p2n0cuRt510oN18g?=
 =?us-ascii?Q?EJpBuWzRWeWxKmJpMmjj4+Y6obeuh3YWZyx2/CZN0dU3/YrR5AFeFn/tPCMm?=
 =?us-ascii?Q?01O1C0ArifzI+zZfY/y7omnaVyQVoUGkt+n4fji+i/2IqVdmmjTg4HtWJlf5?=
 =?us-ascii?Q?it0DW9AaJJ6g1YQKbSzYZJrSrEpWcmoLTQQtqDWWn92PQH+H2WLfNF8fS+m1?=
 =?us-ascii?Q?BB1gqCr1bc3wEU1KkyI0dUaYzJ0Jon7EAvjL2oyXQZjCYyzKvDghsFlBOWm1?=
 =?us-ascii?Q?Pyz6dWLyLXef2oR75zG1bscJrbtVwkwVXYEm0YF+CCahJe3AfY0rD7sqG6kM?=
 =?us-ascii?Q?uE/cmNjVUcF6EoprlTpiXPQGYQmYyOAHaCFHnocpB+qIHT3oWozAJYA9R+5S?=
 =?us-ascii?Q?q0tB+B9U4dcvNw+DCjrdb9hGQoy/z41Jo12N3V9cfdbRp3ZTYLm7me248GYr?=
 =?us-ascii?Q?IbVjzbd/wUHWehPctk/8Hkj/jy8ffxRox/is9ZbKp7ftRJAtFRasdSg3dzic?=
 =?us-ascii?Q?LIa2gpJDGwcLiqw4DJuE4Aj6fHITU20N2Ius/HpCE91IMZIeZAxffujToHI3?=
 =?us-ascii?Q?CzYzxrT8DgPrQR1Rzip/Ddo03kfk35KxLDgmAMHRJISu9R+454cpcVuSoxgk?=
 =?us-ascii?Q?KTfkkxkx9K1+60P5UMy44o62JXO6iiOyTtDuyi3pkBsThntgsXGepl4E+Vh6?=
 =?us-ascii?Q?sNgoFmMbEFbkacl2NORMf35vzYBdLKMJYsat6d6rXGDOpiJudy6+Uymi2EkF?=
 =?us-ascii?Q?nwpjNI3ZEFyUqZQtlPdyNkbEg7gj6uOY+YptEKkcLI02/0Vf1bFs5ufTvJxo?=
 =?us-ascii?Q?W47MNGei1MB5bE1BEF5tmUCHnpL09BXRtsXMZxA/OkH4xpnq1I67niOgaBYE?=
 =?us-ascii?Q?Gt8CQu/VkHGfKRVbx2Q7lT/Tjoh+fruMV3NZfIDDCyDGZkbXEza7zSOR44hJ?=
 =?us-ascii?Q?LrGW7hP7WV2Yk/Hi2mJt2Wqwp2+NZe0H+oXj1L8ra3wvJDE4e+10tvD1Ih5R?=
 =?us-ascii?Q?gWkpvvd97mO8dlSHJ1GQ3P9tG0xYWTjmV9aVjVe86uXIg6sywWpVRg2agg8J?=
 =?us-ascii?Q?ULWdxuN7ipJWhcR0nsp71GtxmOHU9/GhivnyFhoitBi7nNOmIu9as0zVtJGk?=
 =?us-ascii?Q?eIn5zM6pzhn/8N6uJZ+fsMoBNnG07Z2o0yOXSTxQz3XJ1dw4waGoZfD5F+MA?=
 =?us-ascii?Q?7cyiiYKnV1vUcmDi1E2Hrkj0MXRNTjnPoDr6U9abJYUx1GaX4TRLPA/l2XLE?=
 =?us-ascii?Q?8sxdY131TMOLuGq6H+MqGfk19/XVzKS03ziL3aLFgf1++eSEauB0ocJaf+5c?=
 =?us-ascii?Q?y5Ai24HQNSBrfYnFJedp5nAUm9haTR5hRVzsk86wi7w1WOeoBw2w2W1aE0ho?=
 =?us-ascii?Q?CV9Bx6UH1VAuzk9q1h6SUQ1v0l2Uggv6iCS78IFfxsH6Jl1HnNwavtvYEhCJ?=
 =?us-ascii?Q?uHfNOzWkUUdlov3IlosF1/X0NmblX/waFamORsER?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c543e15-34e3-4576-6fba-08dde19eea85
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 17:11:21.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqakDFVdA65xW1Q63ka6Rt2cZFK/9urEuupVdLKWDeHmKU6Ylg032Jq96K6ps92n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6845
X-Stat-Signature: 78q6zy5jbuzf8faypo3rwx4hf68b9bcd
X-Rspam-User: 
X-Rspamd-Queue-Id: E8D21A0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755882685-838435
X-HE-Meta: U2FsdGVkX1938z4CVcUL5aFIUH9WCJb/3zHA1EDiorAss4HsUjC5xkbO/qulbIMMide11OH5xaNHM+s7uXf9KuoKibim0GYfDgTe0N+R+dztFgQKIFCakN1Uz/j82dDJUeEbmMp45i2jFGpPrIQ8xpo2l7I9fyipKI6/kgh5ngpVOFev5/bjVfmlPK91nGGbYkOdYw1iouQhL1Ac0cHDzNEHgZ2OYnmPdgcMDmE5tYupR3w2mua/CklQ/2i3dpdZINK6zocq5fDI4NHZmlHG4FrHMMI8aeswEl5/8uq7ZGuTXqPqoRK6/D0Sn1vypYEW9H+mHXTGEpxT+4fmEZt/VU6zcr4GoBtkwG7yWt5ilqe8FyMVbYkKv+wJyj2iGRtjVVMkqyXnul1q0hA+JEJpXZ4nymHNxZJW+h0T5QXq8NqwooEAZgeCqU0gKR36bJ6GH/9IePCO14/4FgTQA4BkX0zy9OT4DK+0qVdBCwLL2mbAMahVNHMgP7jLhGaim95EcYa2MyOuk7h22Kcta4hLGDXGcw9MNmchHRv5GnilMbG8ANkDCc8KmRqeXbSEtJ05skpsVRmljnmGfBwcdPF72fd9IkfMgweXD9HPkkWC0vBit4C7EWHSUqkMpwn9oqwRt6KGj0eS2ky+Prhs3P3J4NLU9YuzfFG0lDgb9JTFBKEpz0+SXpENa/Eg8kZiM93H4fTnzx6sVhDwjevKYfP0ZROMlR2dTeZC8zLf6vo3ywdNZJBzqYqwsKhik94sPwktya0b5UJwFVH7MnT+aed9b9BJcIWeo/MiaFVt7bwPX2XGHIaOSfZ5+RpUlLbvnj9E1yCcXChtt86Mb1lhTgeIruW6Z8iBn+RNOB4dHQ4rWtRhpVbDVnxmOoM9xBH0rjOZ/yR1JRao28rV8EBIJuCCo+WuNpv7cSwNBPW/7UiJdmkDtpQaxiqjJDwv81C6WP47u0J25HNgmiNGTtwCEsY
 5Mn0kztL
 kQ3wsYELYnwKtJE5e/DCweNwe2H3l87nYmCA+vHZX3kHz5ADrfVJlkM97vCWe2q5PYQokiuyiqWyDDNYT02attUOv14yLPGp43vk2O9lPQXYZ25P7TSJZq8ZgZsU1olDfEfOllNryEZ556mE/0Y1kE2FyH4jd0zBM4OHH5GnJECEL7FmPHvqeXBo8qL+aTkSf6/qJchR5oO9lR0zGs+kewNM1esUwKYhBvUYsurbCkKDKJg1T0uYjAwNDXezZmqBlqLv4ifUb0mkUIsUKathf2pwvSBdyNNmBaj6lXDikcoj+ckeT3R2+ajK0pVk5cgE3R3azTcuSXGniZ547DDt5060aATrCmaTmCxVXjFGZkaIk28r2qMtEqv13KPGZL4kpb3+GanuQkW89J3hzdexIrcpQM3IPTgO1SQhxESI8VaK7AnlOVLDMpvaDzVM33i8ypFS3l7HjzU3LLwWw2HXo8HrWzsQYYblo+7y6moNZGdrdv3FTStLYe5YuI7DJ+RLVWH8krBhVdrfkscL0G3ktA3+WefpixsW8qVuDc6GQUbQN3JoWmr/XE3nEgbyBSSaJ8U4j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Aug 2025, at 4:20, Muhammad Usama Anjum wrote:

> The while loop doesn't execute and following warning gets generated:
>
> protection_keys.c:561:15: warning: code will never be executed
> [-Wunreachable-code]
>                 int rpkey = alloc_random_pkey();
>
> Let's enable the while loop such that it gets executed nr_iterations
> times. Simplify the code a bit as well.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/mm/protection_keys.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>

LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

