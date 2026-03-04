Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DF1EF8FFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2F36B0089; Wed,  4 Mar 2026 11:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A126B0092; Wed,  4 Mar 2026 11:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D166B0096; Wed,  4 Mar 2026 11:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 282A26B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:04:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFB3A1A0629
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:04:48 +0000 (UTC)
X-FDA: 84508853856.08.6F630BF
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3EE9740018
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:04:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hWewGYZi;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772640286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BereyiT9j5+vbs3lDBWyI6g8D7TU967T+gbGfPmC/hA=;
	b=v2uOULXL3QITaH96uWWsUQE+6B0f0eNlrcW6ofHhyEPPN7ij0Hj/1eB4fKNT7jZahgSYtR
	7+t6EuBxgSCA+wql+eQM4I+KiergfeTk2vWURQCkloz0QDoxFcYNEjm4glLEw565Z85OJH
	PHZkDJFAE22EMrgVWQzdF3YqG8B/IBc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hWewGYZi;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772640286; a=rsa-sha256;
	cv=pass;
	b=LmptNaWFZLETYqYprEkHaqG0JgYhHildaMxhi1+uYVzuf7pLQA+/8QgwneZDBULKtDBxhs
	WuwLtShxpaIaMIfbH5jzqtREnbXRJgEHtW6j/X2o/xYFdvkdE0niRubswhfuIDxh1uYBS9
	khSyjDADa3L6ADH9a70ADTp6cwnqLoQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cVy70QdKfKCulalwVW/OynGakw+xW/kcSAFpIrsKzPs1FM3O2qsWJ3AGk3c/Ofbpf7N0/unDR1M7rL4qJdHMSxUutfLqcaRXALnR7A2E4VQG3Aem6+iRN7MUPNC0E1EMJ2Gb9rbMYF0OT3HYT6MvM2JG2v2mYt+Mt4h0gSPjNJtV8uyOT3DAJH8s5ihDPTfcXN4WQD6eAFXFqrAH9PWJoLQodw0XRNRkbzgS/oPb9TWDU//xKUUB42r8My9ZAMA9/nuwYZVwNymsXRlQrpSbNxFuOxbZoRkNqvitNIo3Jee/BePLnqdBujsP/3zpywGJTGyOnDxz+1uxN01VpDE8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BereyiT9j5+vbs3lDBWyI6g8D7TU967T+gbGfPmC/hA=;
 b=rRj472tBHKlDSvIW1LtLv5Ciy7ztwS+v3bkDuWLcC/Wha/RPspvHVwIpL44JYJMAXLn0Tl6hWBlZrfJ1EbhHeV1OpImWBFaJX5jqugqdJwdTdgp/HMtkP9QaIq5gK7NIHnTCknb0Lrtle++m9S6NApR0IYGOGDejeFk3dC+pTdKjZuDtMaNL5N5TWGtydofeXVi/ji2QJdhrp8PAYc7bVqRBDXLyGSzLc+JKaF+nGhTVnqX8MvLVAP5bK1zcTIBFVTEWpDDLScAKl78CVsUOWsslQZWqCFE82eEJ4aFCuTX26hN5/9lkI+v1+f5lqG5W4pAsh6PUi+DvXQQ4a+M0+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BereyiT9j5+vbs3lDBWyI6g8D7TU967T+gbGfPmC/hA=;
 b=hWewGYZi5hdMvxhHfWAnfTqqiMOMRUKNoIXEkEK9PC3iQuWuzs0QCbSLGYg271JST1LPOTGCeNQ1mb5HaMwOfsYOUuPg+8SKhK17GloMX9unlOcXsRypkbTXnuTDnXNiu0g6bSgGuLES5m6UWYeG6zxufVfEypsIvaGAhUJa1c8Gn78p3/piFXCcrOzyu6H8/WFVON6DuhWiaWdwK0Z1irpwqXCM+hLcDrgS/shOKqHe3it8LZ4F+Pz0N10RkPcbDKPbzL5C0yPucRb+HZYzFDAFinrhngheokT2m6iAt8Cus6ws0kC8Ii/SQaZfwgjsamnz2EAD+BjS0IXqmbCPAg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF482CFEB7D.namprd12.prod.outlook.com (2603:10b6:f:fc00::64a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 16:04:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Wed, 4 Mar 2026
 16:04:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Usama Arif <usamaarif642@gmail.com>,
 Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Date: Wed, 04 Mar 2026 11:04:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <6DDF4B32-4AC3-42E6-8791-B063FCC9C9C4@nvidia.com>
In-Reply-To: <20260304155636.77433-1-david@kernel.org>
References: <20260304155636.77433-1-david@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:a03:100::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF482CFEB7D:EE_
X-MS-Office365-Filtering-Correlation-Id: a55ee953-046e-4fa7-48c9-08de7a07bdd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	KFvq6+TQnGbR5j85lfDwyQUDT2OWX2grj/1eZ2ttVnrf/yGh4sAoybMCNrsZcDg1LKcLHqQzl39gRAVQ6sgxeRJiRjT9FYcuZM6qcFtLFELDyaqhQJ3Wmok7PJHtybJVI1QlsYRWMqsVKu4gdx0WGhlp5Y7r/R+AA+X/MOcuV7tUk1wCwA/72rlvTDdJcNqlzzBciRTXCu71uFJt8pdQdZIfrbE1dRy9//l5oGguVphfSlkNPv1XyIhliY5A/Ufx1pCCw2nzmxGeQzspkoumq23Z/6L0AoojasTpgghk33YnNk/KbQI5aTJZO5F9wxTMj8CVrnIP7M+DYuOR+HNujt3EbFUlvOPElwz9600dZfnH1eYaYQGt5GKhg4LOMZCTvDuonKRslnN9Hf2c/ql4qMfS5zDml0gtjtz+NDkcAvG6ao3DSeYyiW1uBtrfZDD3NLmrXT+/ZVp0mTZdICh3CntvVadoyc68ZfOx/ehPU+x42+xHgtYrGsnLi1VKMoSyv31ZMCe3VBYpgUQqETUU+FxqtE8uZMjde1ExD3pkYKHlfc6wuWOxX7CEoUDKtbPHNTYTmXCsQhemZiSG7fwDpIGPg1Yn3CT1escMRTStYBXb7UsTAgrP1u6q+vT8PukIWn3Q7a1XnT5ErSpiO5naSyEXXDUl3H9QUHcYzcBgKNFVPhD8/SsBEFWgJBDIfzkClN6EPPG2yLYIDJP6FjJ3WryyiA3cIzUQmDFNPQsBRKM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1zDxu+T4Na1jusY77ugohL/CN71LlyEKm37K3ieBV6Ir+yiwtQbzleH98Wed?=
 =?us-ascii?Q?ZhnGU2gHn+usA+sFYQ+MbyH4QTI+yeKl4up1AqHSlpA2/qhlgZWyIhk6ws8/?=
 =?us-ascii?Q?isHj7faNVJUabADa+ywnb9nv5XiBV6yrH7CRmRMiLB2Y9MBGW2N5wKZI5Ckr?=
 =?us-ascii?Q?KfCu6BFxFcoIWQwLWxVAHg0d675SQPn3uDE3ye5KIP9yvpY/5XP8gIh8iSWv?=
 =?us-ascii?Q?lQIGic/Wn3/VQwf69KHJDs9wQweaiiTMQRZcV6ZBsmWx9SnX9QuYQplOWoL1?=
 =?us-ascii?Q?Iv9B1z8MGI36rxQDFBmTi43IS/yNi7WWd0RV8bVujdG0mt1b1rjZFyYFTG00?=
 =?us-ascii?Q?FKlE8QSS0Kb9QIEa+MrhKa+cw7bmTpXayebgKWMnuiVgRCRkH94jGBqBY+rr?=
 =?us-ascii?Q?IXOVhXC1+galX7sKi8e7yIsT6zuBvq5IbTBwjNTMx06zRVQaNqgDYq7Tyta7?=
 =?us-ascii?Q?cP/ekJrXACvwbKY/xI1vpGJEAaEvMm0ofEyvAn2aWgkq04cVb22jvs57M8Vf?=
 =?us-ascii?Q?86fRznIx5G4zQuxThln1g0Ov/FnMsxJLZPu6rpm91SLeWuS0JRGXxP9FH0bu?=
 =?us-ascii?Q?JD1Ls8GtBHmP7m33WOx2mnpVZ11aqnM9Gm2ByqWfDLcrEOjw0Ux7xnk4vhNy?=
 =?us-ascii?Q?PcAnmBwws6X7+Vpr+WswDnFNDGlnlBj8z6aUUCHr/PaWSB65z/h3ERy7/oPO?=
 =?us-ascii?Q?GS3wpZYRPpHSTd6ORgY/TKJVcvn3ElECGYLvsOEQ/ChE6re+58SuBcThGP2a?=
 =?us-ascii?Q?D478FyuaE/w+2pAo74VUXAjZAAUHPCWFp827ElfnEicbKJiaaHIMKe2GadkP?=
 =?us-ascii?Q?d8cdtHGa0MCVql8+63GB/A3qlbdJZHn3gYp3FEUdqPQEjtCEinEllKuH5d1t?=
 =?us-ascii?Q?6zWuGaDA28EnNFpKyirBs7nWwn9aiB5O6voD0IbWVWtqu/5+E4qVrdhtaisf?=
 =?us-ascii?Q?Hr1/FG5vSIL9YfzsKUYC5clJoS5lGaZuVrDKCyPddgXwyH38jiDLcPGYovbq?=
 =?us-ascii?Q?M7T3hsg5GmnDfNLVA3j4Duj4iMIGLiFKfB83XkLzdwVEKi+wSb+r8gnvtLIu?=
 =?us-ascii?Q?PMXGeLl8c0v6WWtNBUNaOdEwesxooeoGazEPHKwjmOGMLEKcoAkfS9JEND85?=
 =?us-ascii?Q?UjS7eMeN+BCSMudXUybTmHBsuUW5N1ZAGVOz8PrChspJabeTCyncjSK5vt8g?=
 =?us-ascii?Q?a4tNkM5lzy6BmIeqSu9B2zd/Xx6Z5zOQfWKmYPEHZmqxowlNPrjshceurMoD?=
 =?us-ascii?Q?yPgCcbnH1wKX+RceAl+VDcypiHCwuwvwakLTnqg11Agv8H+Q5KnBjOiYa+3/?=
 =?us-ascii?Q?YXYiyw7Qf5PwRrpqWjTwOgrh/02SZPPdWPyRuZ+xroiJHvVvFwyzqUq50OOm?=
 =?us-ascii?Q?rLboFSLsIgWskLuyrvgJ6VXV4nFoS5klfDEjyrro6Ufl6SS5pHAfYfk87cg2?=
 =?us-ascii?Q?0ZNnws1IP7U0k+g+LFs4skgqx4x8FD1ZxZ7nkaY3XaFbzWon5H9AeT0u25wy?=
 =?us-ascii?Q?m0wYAOu2cNEk4bL17LpZSutihkF5YgcJa/42Gm+10eoosIkvofrlGViy1zZP?=
 =?us-ascii?Q?gqpB4hamX5obz66EzRaVwexQFIC0sK/+XBWEqn1+o1S/KVsIYa4LtJFuB/cB?=
 =?us-ascii?Q?UYdxErG7K/SMc9T3TYMvjTCnA+0Oi+UXL/f2dZojA3heAXQhEjExod18HZ1S?=
 =?us-ascii?Q?1VjChZzvcnfae4MNsVGqrb+8tQSe1tKwFWy/J8jzFQz/ns519vubWad25U7J?=
 =?us-ascii?Q?sg5yob1NHw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55ee953-046e-4fa7-48c9-08de7a07bdd4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 16:04:40.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQNaLOu0gy7ehH7WSzyuP/u6uP62gRRGWI3YjIuSzXEycy2u0hF1f88LpQIxL8E9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF482CFEB7D
X-Stat-Signature: bs66jq4wzq8pw93ihk8gwh1mbcb4tt4h
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE9740018
X-HE-Tag: 1772640286-199102
X-HE-Meta: U2FsdGVkX197cTP6NR2XRjYY4g/sYsyEjcNsoGbMRL1bKDfv+h1Y/AurgE9T8H1km271oeslszQ/LgaMScu/8RXeeCutZatzTeMrDKXblUlfoCezDWhbeWqh8DmBTC3sz90FLTMLexkOI/0Hsl1/3uG2G7hLDExXRaUxmZN/DJES+HvzDujxFbI6bQEsFaF4KTZSyJfNB702t6jEY1GZiE8f0tiIdfcsY0/NqIHKIkQRVqdhP00pYMksh7f2KZGFXRvnF7x9cVFa/UbOmaeWdnG+tcoe888BLmT8rUavOleWB+SoG3hSwuty1MN5OVGmctP6DTrmPreQI6ckn3qSb8B27ZIqJGfmsMzeB8QGRzEWYpot/kMZJBCS46KrXl5e2skpQNCEerNAexz1SvrUm8dh8iFuyDECKzOmrhAiJk1oK1jbulh7ckXvc3QajWR2bhKZ86xC+cS5dYhRslIe6y8AEC191q2aG48nGFsNUfTb/EusMynFeSm/H+t0GTCEbGI3vDa0A8lNS6/gtFpPjKoiyUkWPzJZZJbmRyDNBJevw3xgj2sOPtJKbSRdhYVloyZmGPbzHjVHY4vB5uU4pfLODcO69XKWdUW1XOVdAsaKaNrNgPi2Fm3JdzG+d9OAfZVWPIXtE5NFMLvFMEhjODG47VMRTWB7E8S7cVPXFmXlc8qcDEQcPPUrk4eN6FHayfjLi7J7RsAjSaKF3XB8eJBJilvooJDFPDZzAg8hcJjPHZQDBfLu4DTng966wFF1L7kvP2pF5fJns1bs4lhIJ7VTkXGXldvVYFpIN5V4Jfl7aMAiYWgN6g5bzKRS9ZLMkhdDJzQU3rG871c4TNYVgwXVNq4jSnmr250H3smPJuzulf/vge9pRLR7Qk0Sgk8sjt3n2FyXvIDZW6an8sFN5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Mar 2026, at 10:56, David Hildenbrand (Arm) wrote:

> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.
>
> Ever since we added THP support many, many years ago, these entries
> would keep reporting the smallest (fallback) granularity in a VMA.
>
> For this reason, they default to PAGE_SIZE for all VMAs except for
> VMAs where we have the guarantee that the system and the MMU will
> always use larger page sizes. hugetlb, for example, exposes a custom
> vm_ops->pagesize callback to handle that. Similarly, dax/device
> exposes a custom vm_ops->pagesize callback and provides similar
> guarantees.
>
> Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
> and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
> regarding PMD entries.
>
> While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
> and "ShmemPmdMapped" entries really mean, and make it clear that there
> are no other entries for other THP/folio sizes or mappings.
>
> Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/filesystems/proc.rst | 37 ++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 10 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

