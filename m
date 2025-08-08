Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F54C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7970B8E0003; Fri,  8 Aug 2025 11:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E8A8E0001; Fri,  8 Aug 2025 11:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D4E8E0003; Fri,  8 Aug 2025 11:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 554928E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:57:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D8881A032F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:57:04 +0000 (UTC)
X-FDA: 83754043968.11.258A70E
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48C0214000A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:57:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OZHesZYj;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754668621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oJqHtPFbIyX2onlmlpgEGiQEa7V8bxtg+E3GbD2ob4=;
	b=HSnnSMVyKq/umkLf1vBXpusYfqa9CcL7AwQvEH6p+kxqDDhhYVvwyMc6vpheKzgGTenDQ2
	KbcjeDNOgXfmk/s/Y/CqW9UQVVcfxP3fOKwHkmEoRZbYciOplBtNxSQ2upxiL/gkdGjylE
	7fdgc9WdBVbna/oNJzfcle7aLFXwERc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OZHesZYj;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754668621; a=rsa-sha256;
	cv=pass;
	b=1Qr+EVaBnDLv3MdOD91r1/IqUMep8ssCaQ0VT20HqwGywdJz+iOQbMaNH0HoRbxjlnhuKz
	N7WLfc0wKfjqivqxR5/EwOlKTHupas6tqfrX8bTLVKMsLFKXgIx7FAZOyorlURDuOt3Rx0
	DnhalnfDmc1OR1ynKSEFanMZ2urJZDg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LakIxGXHiv0qK71pEHQgWeiiMArdG7VEYPKbQs17TS4WNU9hpcQ5RPTTAlC0WZs3YbMLNRT2VIO/xwMNSX6TWnT1b1UPgvuR6bH5V0hnjgiaklTktEqewLS+Re/Q5isxkX4fiBx9UToZEUm2WGDB5mgH+cZD2noTrUSSbPfIPzb4OjbfaHhZRKws6c8HnkCHzoazsjrRr83EVd+r2Iusn/g42MNXGNOTz7bWVpfH4NpRRBna9OOSgrZ6Y6S6JonPqV27etp4knDZRp39dKSmcIexkdNWgzk0zEJyYpbUK0IrYofxcgbDmd19f0xIadGeLviDqc4nBYAUB7GyKXwjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oJqHtPFbIyX2onlmlpgEGiQEa7V8bxtg+E3GbD2ob4=;
 b=tzOVp968ifmQMTb/ltc4NueYf+x+VRtqfMINGHxZacFlsx/MhCHUOxE7bU1k7dOhgTN6e2D7+wFzlpcfkLUOTBrkHBdjzRVJQfzoTkC3mI819phGVoL12DsjjPTWooK5xPnzOKvr1PvaEr9iqkygNOv6psCv7CLWbBoI3gqjXZrSxUfkhuizCiiRLAi1EytW7z3yLPb6yCyVR9JFcrXRq0i+OkvywMVmR0ryiOjiRFMmy9fSOohg7CNohbDxrknDe4H7SLNdeOGnjMaSWLkSDNMJ00JE9HE5lPpW2x8XNuJiYBxEMiVgOKk65hXGMPrC8XDKE2ihKTvyxL63cz6J6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oJqHtPFbIyX2onlmlpgEGiQEa7V8bxtg+E3GbD2ob4=;
 b=OZHesZYjrhAa/Btfm1vpi17xPXr9gob3cDeaFJJsQp2rhFzqjvfD5SVoLmXZowbrtaXXPuYsxpcjSR+uVUH8a7LivjoT84RS22uc8Gq1xuq9V6XRWybI1C9JNzv3Kr81WOK7uq3oHo88tkR8ecT2AVD5yhxv/qD7CStM7Cuv1yyx6corWPBT9ICsnKgkloa05PH8XwiQsgViPmzNg/FUQjD7f5VDw8Kpfy2zCT+TgMN85mZgLN2H/iFgrBboHyTbXKTuLk3cYEqVSNrE37SDnSWXVAuLWqtSIszEbvNprJYUu/SOKTer6dhPYZ0dvdETk+kEgiFqFrf24w4fg0L91Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7541.namprd12.prod.outlook.com (2603:10b6:208:42f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 15:56:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 15:56:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, dev.jain@arm.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Date: Fri, 08 Aug 2025 11:56:55 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
In-Reply-To: <20250807082707.30647-1-richard.weiyang@gmail.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7541:EE_
X-MS-Office365-Filtering-Correlation-Id: 79da1092-86db-4232-5e3b-08ddd6943402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FRyS0/duYXVcCXbn4VvNd6NMyVqNDik61imiejOjrEHvUVd1Ugvfvzllvdt7?=
 =?us-ascii?Q?7E9T7N3ff3+xl+MT+stNG3lKAtcQweaJt4hhfnWLQWB1/ulLBiFA0TEI56cQ?=
 =?us-ascii?Q?6zEl2UE6GixH7j3l8Nk/MKiP+cqNxLjvYlc6gxzXWi+y1BP+3nKZBoXKDHzy?=
 =?us-ascii?Q?pDNP+NNk81Yz1wHy5TMaA3++KxCWmDWjoXvjiU7/UArjcPS8WxEUKwNker0h?=
 =?us-ascii?Q?dKdODg3hejnuEIj0cKm81etkGF2+Rz8cwD1RXITWfh7BaBQlJd4vocTwEZGI?=
 =?us-ascii?Q?6IpatCz/EcGaHaY0o5R27vCGCuNaMwRUpLTlbyagx+0v35sJIST8NsE47jc4?=
 =?us-ascii?Q?K2vCNazRP97mmio7umiHE8zaZYwgPa48oTqmBhUJs7dWi8pl+5JSsqi8FGbY?=
 =?us-ascii?Q?nk+W6PbH3XYg/NiLE+kip3NBevdq9mh2JRRzXnY0eecPLuk6KbBf9VSk0Hie?=
 =?us-ascii?Q?IKuH2Fsue7+dm+qPada2wwEM+2uKfgmh6B1bPuvi5l8QpoRCU+JCyBIJBDmX?=
 =?us-ascii?Q?BDX7R9zAyi+9I4EwBFodmm0iFUT6r/uM3r6wIFrdXDF/OGEjdtRWhwZx13M5?=
 =?us-ascii?Q?M9tiQncSE/mQMpUcnUHkLNEz1eN9fNHdbbnEcQOA17OUFGoP6Qa51wbXNOb8?=
 =?us-ascii?Q?+LUJ4CWwXmZ1qNwLNf2Nk5PFGMMuADdha9KiS0707xh9Sz2w7MsJBcz+wWpQ?=
 =?us-ascii?Q?224GANLxBRKMAJqN7PDZSYZ/a4vPVycxhBFHywXp/91jyfY1jIV5ftZUH7Xw?=
 =?us-ascii?Q?kXWNsrVuglRsD1wrFSpgvt/57KAy0ZrhZJqH5xghJIANP9IpUzDRAbFldThf?=
 =?us-ascii?Q?eaND66XhekVMWj4NDKI09cT+43CQFa0rdHhz/qUR2E7rPUhktHFXvGD7j0AU?=
 =?us-ascii?Q?Sf5OPLvsAqqRo5luxRpR5Yg0QypD8M1bGlzMQnfjVLk+6q1InAQkTUhrk7jd?=
 =?us-ascii?Q?mGQJh1VgoP/PCgKzrikQgPRIgnglT3B9zj+l3iqKMcny4/a1fuapxEESXKCh?=
 =?us-ascii?Q?pDcLT8g2tJcQV1hAEIdmcPsdsNGETyLaDwLusAaB+Nfp1y5mv7v0VQhcD4L2?=
 =?us-ascii?Q?Q/7iVo9aWzqArx7I9Oandss1jd15GpWXgqmh9Q3wy+hYLRNHQEVWNupzAxc1?=
 =?us-ascii?Q?U+4824GPcHWVWLSxuqCDCD04dRis/3P7nxN4EXdqirrFMGsot22kLOEEXpqL?=
 =?us-ascii?Q?Cuqnbljlh+VbsaqKu8voBFhPvaxDTMn04Tu7KgD3ruCy1lUieTNCWxxyAHSV?=
 =?us-ascii?Q?MSBRUAgFtbmR6STAmX3SbshRP4VcOfmyHzL7g5ngC0vGKsZVq6EdPpuP3oWE?=
 =?us-ascii?Q?ZttefQlOU4/y/RYjDFageRFrkGS5/pbUmDtiqQ6aZmnbuee5hTTCCfO+xeEH?=
 =?us-ascii?Q?9WS4JjRv/UyWIgMoXENM5L5PaFOyHNu0i9LzsCwVovaVgpSrQsmaD47vFE0E?=
 =?us-ascii?Q?WmaPegdVFTE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PhlN5sJdpNUSXSWvZsX03lFJ/lonsvOUngZKYqGebH0c46DzD09/b1GH44kB?=
 =?us-ascii?Q?n6VHJh3/5vWDdJjxviLA9XWK5nGvfdmFE7Zpz3am69h8m5VY9mktF/dm7/xp?=
 =?us-ascii?Q?JleaYlLRQj0otxJS6l2YZ2XqOZt0sIjh8tIXYvKoL1rKTtZ8RzCJARpvnKGr?=
 =?us-ascii?Q?4MsBOEgIUUEOpqNZnPKAHo4bDwIR8Aj98wePnkC+1lOrNrXvKS29IabALUr3?=
 =?us-ascii?Q?69WRBrQGG1dLZWGX/mQTVZBM1jJ4R0PSjVfqhBi04/mqtgClrHeeNzU5kxVM?=
 =?us-ascii?Q?uxjICkH6IEQ1mweUn8wQQvRKEISC2swrCJzoMyxs9rSzIedPyYvI6k+8ZRhm?=
 =?us-ascii?Q?lSp5unZqmQBC4BSI/mZkd0M58RHeqfmP4W9OxKYQVFMfd9G1QKckDRbOljmV?=
 =?us-ascii?Q?OHxkMB2rEST62pLB5clJ1Mk+vboODCndI+/QsE41X7IbS+qd0q6zphbPApT/?=
 =?us-ascii?Q?sGhq2tGqIiBic1VxxezqKQFKoVBt1IfhpWV6TIMYN1hI1ef8b0AQAPPEJhte?=
 =?us-ascii?Q?vGX6CM7lKp/1SY/iiJfAbDIwCZhPm5wnk8zOtr48hSEesXhAijDLVslT6M88?=
 =?us-ascii?Q?17TCiG5BACfeyF+XPph0gZCBSmcux5HB4+5pXkVKmbb4MRaPY3jJa0G0JXc0?=
 =?us-ascii?Q?WWUteLGIUwviUop06+U+UpEOR3cQzEgpA34QBZPP6pWKYUo8vKHIhtT+yDGU?=
 =?us-ascii?Q?rdZGwYPYohppdYBCslWpmGrHq+v4GcpPF/V98dBeCw81o4OWd55xzQFCZUD1?=
 =?us-ascii?Q?PDflkYMt0e4ZdY4rXP86/uhTuc5C3ZrzhqRzl8hCsweVnFTJ/KO8uJhc0rUr?=
 =?us-ascii?Q?LD7eYW/X63AM32s7/5Dm0gxcbSONFtwUfbYysXZhaSeWillFZBZMrExXImYn?=
 =?us-ascii?Q?lk7qxXvtu+9QLK7qbQ5SdVoURvjNjIEQIGSnBrWYvQmtBxubHKG58PS5OFgj?=
 =?us-ascii?Q?EQT4bXM2mXEwDuAP+fuhVh0dWUlfamde0AJNdS+3zqbcBRs67Ig8DyWoB0pB?=
 =?us-ascii?Q?pdcdCV6rTXJfbt1dNye3//AOXwK+u2MGNnWttnS0bbHfBivf2tCJMvwRpK9s?=
 =?us-ascii?Q?GKgn9hRG7nQWi++Tf9UL9V5nwgGlzslVMbI4J3xsdYgiaERVosgppvoFQz+P?=
 =?us-ascii?Q?0kanKI8RI0bAM0ss8fXDnTNwkJvjk5wTF939AwAkIZk2DUyoLDbUCTe5FrW8?=
 =?us-ascii?Q?8Gz2rf0+4kyuaCWT+QfJFZULR/l989yD5H8F18Pdcx7FJpaD31c9HVwEVOB3?=
 =?us-ascii?Q?/+jhdmzj1EVVm2IZtdK3doVhfv1cyb1gfmglv96LZbT3To/RmwYdm1wr0HkI?=
 =?us-ascii?Q?6R/ahnjO9VLockncVvCw1qZIpek+xpk3fYbEq5ML2LK7MtbnX1mkdt7kTwI8?=
 =?us-ascii?Q?hyR6jgIX//ZX4vE2wkCDMpuHoV1MuIvhSnENZ+zoC+IsrmTgCL9R3vBbc9ap?=
 =?us-ascii?Q?nDYv0CWBjfKvaIqfjPuND4FI1Ikt9vUzT30X3wsvcMCZySwGsKsFKe90MOZ0?=
 =?us-ascii?Q?Ncdvbqyn4U4Jzajsv7lgWstDv+GV4hBSaxrugAFqonuIQNUTBRuoxB5g+DOL?=
 =?us-ascii?Q?j+WMuAx3GXjBuxChBBRgMgaEZ8MVafEFo18mnuPD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79da1092-86db-4232-5e3b-08ddd6943402
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 15:56:57.3674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ruXbhz7YSprqFl9z4FeZUbGOzSym2ez0V2LmQuAcjcgeasQSpVkaZp0g2lMh7kf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7541
X-Stat-Signature: 6o11py5qgw38y5mb1j8caj1ii6gf1bnx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48C0214000A
X-Rspam-User: 
X-HE-Tag: 1754668621-671332
X-HE-Meta: U2FsdGVkX1/cxY0PNVVwpWp/iCv66wkGOAID5klcFu+Qdx3owdSeMs2d7FJDlsR7sYKVpVAknBLQ3cNfEVZB0/48ZJwWLQcte6RjOhIlxyQdaoIAAZEde0nk0Y70xAoiur1ow3JlE/ot20h6LW5iAwoc6vllFbIxRni939GWnaehsJUnkuDkFqch7uW28yjYl3I08gXetw3n0ZDdFw+o9EwcO+I+aYuDEZyjptR8my3L94pvprG/B/uw08dSjOXCYbXdb9+7qPIZy/ksgkuARHDEDWxJ/s8NpPHl/UtTiAQsDkR9pIcH0mCfITD2gadncsvHUKRy2ZCe10+9El/59ltpO7qqSt1KlCXBtYgQyGjyhyQL68bcmW1sp7cxk+TrSuR5tUg/aDvf8U5T+tM4nl6I6CaZfYmgUMqND+6YLv/8dD0AmG5j9xds+A2uJcVquaPlAmV1wTguy4UKfRWd43FNlpDvFiRoqlv5fWmLbgwzAMueFd69Ti3HHiW0mbszGuzarlyW+SeIbejtKfSkuI64OkWEXsTupGF42tXwN8yM6+F+piMHVI9GYPvPHdBH3GyNWMQvumG1KAXVrBPbNdn0mPJn2ZHfc91HiiPPiDBz8o/JyPmdPSOOw1aIhonL6nE9BQCQFibPVme5EUrxm0Q1NhomwB0W0Z11QEfY4LWHBCCqPqwXrXF3SUDiLHm5+8oNXK/GsrWa9v20IAi6Vz+2e2eGUZRfX/xPN0HkTpfaLDCk7/nx285QMxB353acOhIt+jorw4uaGExJBG6gFeMYpXKvWBLAj9h4NvCSLYqRjcvC2Xa6Zf+YLFFfLXKrm095XgLAdzqLNt5OrfizWSobci6wOUV8R8Vczu+kUopyLd8C4AZr1m6ZmJIiMgXWypyV5itwyl5eTLQ8+6WhAqFjjZ3Wuy3gAvsoO5Y8Zzm5Jeu30/NZtb/3VulwA8BX7PAO8Ry4siAZsfRrgEs
 Eoyb2aaJ
 Swzwsl9arlRtr7sFHi7RjPFpFl8or59OEY2U1d1Mur9YOlC3m5PeSaoxMwZKkqzy2xFNp8M5udP8WmjFbBIaR5bpiUT72YB4SHN1SXCzRULga6fUMMjjYd8wCqLjPwg0CDd+xjIkoat22UIelbcymwY0/LIdIk/0HAj1NHzp1Gv4SIOF3IJc/sWezh1BgSxNlwHWhhLOWl9bmw3Q1Mw+wLOIIX4qJKPXpkBfytowNxdDmIc25nOyv35PrM3J20RcMV9mYx8ItKsqy5H/8hi5C0PVV/GdNr6XQvZVdEArr7yM0iVzzDH+88Fk/ZpdLQBUI6/h4xRiDW/W87joHtgFKdXNLmXWRVEZ01OyT1V20i7QgPg8Cj3fD85+c4JLgc5dj+0uPgUd5lp6hYEMrUtSkXIn4NbEUcKkY2pdGqnCpwEy873ZMm9j5IGzwwRai9rH+L0QcLhR0SL1GldjEsMY9gmL/5yCorcPoh3RUoXMRe0GgS1f7SEjDC3ds08Z5BvaWFPfZSJqGkUN4/SmNaS1adyVnPIsHVBmqCLtxsyGA/ken422linSAkdzBw+G1DFPCPNsng8ni+4CP2Oo1j8pVEMHmzIau+ghJN3wDgjp8ey2ZX/bgP8oz4AT4Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Aug 2025, at 4:27, Wei Yang wrote:

> Currently it hard coded the number of hugepage to check for
> check_huge_anon(), but we already have the number passed in.
>
> Do the check based on the number of hugepage passed in is more
> reasonable.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/=
testing/selftests/mm/split_huge_page_test.c
> index 44a3f8a58806..bf40e6b121ab 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zer=
oes(char *one_page, int nr_hp
>  	unsigned long rss_anon_before, rss_anon_after;
>  	size_t i;
>
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>
>  	rss_anon_before =3D rss_anon();

Which commit is this patch based on?

In mm-new[1], verify_rss_anon_split_huge_page_all_zeroes() accepts
char *one_page and size_t len but no nr_hpages. This breaks
split_huge_page_test.c compilation.

Are you forgetting some cleanup patches before this one?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/tool=
s/testing/selftests/mm/split_huge_page_test.c?h=3Dmm-new#n110


Hi Andrew,

Can you drop this one for now? Thanks.


--
Best Regards,
Yan, Zi

