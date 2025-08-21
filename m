Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B292CCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073526B000E; Thu, 21 Aug 2025 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F3E6B0010; Thu, 21 Aug 2025 10:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9076B0011; Thu, 21 Aug 2025 10:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C64196B000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:09:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7324A1603EC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:09:23 +0000 (UTC)
X-FDA: 83800947006.24.BEABAA7
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC8241C0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:09:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iZBGhG7N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.101.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755785360; a=rsa-sha256;
	cv=pass;
	b=n4/3GDzHivtPgNWR98zchWMkuCS1l4ADvbBCQfINOtwfoBQFdOyskFgzpMwHdud66hNZ48
	3YspluviSTVF/AOvBEUa05XseE8RMYNKkbXnJ5QWuhZKQjQ+x3hn94BJEyUsrY/B3TlV/a
	fCjm/+Zxz9HDbNEym0mDXgDKuD2/fuw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iZBGhG7N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.101.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755785360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hasAr54uZs9NE+L3166euCaWwbiyzuItp1W/FLZiwII=;
	b=h7BVSJY06V3VcIWiyTtLSIaq8kr1NARD4u3CjHZ9tozRk/nvhyCWbwRzWpGPdME4sG80LX
	Pui8PdRK4h+yInic78xRPRYLKtRtKMptfUavOupmEdoOtK/asccwz9tR+VvZM8EjhoAGCu
	G1p7WpjotzmkQeIUF4SdRl66vTvW2rA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2J9j4odN06x3dtWvlkFJcKrh7jOVaukrxPnvHoc9ETRHxPuOL1YV/r5BTmrt/OGo4iBGUj2fJd+AQ3+P9DsL3L5PYZow1pw5J4ZIO3MaOXx7PkYGAJamsAM6G54VKFc06JcutOkI7h73S1IV5fUfVNr6SH6t++Nrc67yBXP3ylPLHQ1BAFOWml1g0uPlQfVbWIp63bWsr9nGP7b3AcQfacgIF5vcL6qRWKH4a5JMBOa6Lf2Ogpe613QB0OyuZ5yN7XnZVdHd+a83tQqlp6613CV6fpisM3IujGgloRZ5ZRHNJtJgE/mLCQZsKN0B7HdC4Uo4KVPxqGWUxa4ArRn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hasAr54uZs9NE+L3166euCaWwbiyzuItp1W/FLZiwII=;
 b=Y/veTc49Rx8IOQ9zzCt9yQd0DwJHn8nDCjxzPZR7ZkBBYrOh7CNU2KWv6bGB0p8mtiZCXLDcrw6+mDV/SVBAodn1F4mJdNYyf8B+WlBTsScOmJwc4C/h6KMewmzDPI4hEwRsOGwExk8TD4IkLO4yh0cXPcPIC/Qz6pIrvhe9cCyBqN1JD8i8arrQk2X1V5IiQLco8eNLOdHLJopMU0LLsenK/UrSk3LC5YosfB6ulb+PTn6yaggdsGhI0iKkl+pU+kwr3mhxwHr/zl0pgceJaw8277oid05aWhN02/B8epmrBBe4a1Jc+fJHDyHoxAHrpw+TGs2dE5vIr/tSHlD6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hasAr54uZs9NE+L3166euCaWwbiyzuItp1W/FLZiwII=;
 b=iZBGhG7N2wixdmpviJeWhzp9btIoC/YA+ihLa+PirpB9OORoI/IzaextUzo0bGN08k3vw2hKf58qBafbDqvmSy9Lz1KGDYWI+hG5ZKqRc8FhG3SBE+mkv5dQ2z+2iXlQ/5IltWoNF6PF+iUVYOY3ZUuzVtTwF9BCdNqsR6adwyre3qUfqEsb//mJ/YWUmO890pSqgHVHFIeu6Pt2b1h0n8fYyrTmCvFyrpCFAnQjPviLewmqbzuF40AGuyFJNoDG3ZlAH4j0k7Ix8+eQKP76etg3fDqBjhVkicf0g243tXsHoLZavy/0MdyqKtRBSjXDHv6QvCEHzLP7vNmcwydszQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 14:09:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 14:09:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
Date: Thu, 21 Aug 2025 10:09:10 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <1D4FF375-08FF-41E0-9B59-CDFCA6293438@nvidia.com>
In-Reply-To: <20250821034153.uyxjy5yvxx5no5sf@master>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-4-npache@redhat.com>
 <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
 <CAA1CXcDORXqm4JoHn4ZSEhT3ajsuY2MAPwefMXk3+YMXcpvqkw@mail.gmail.com>
 <20250821034153.uyxjy5yvxx5no5sf@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN8PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:408:ac::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9c570a-e1d1-4f3e-3ad9-08dde0bc4f66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fx7YdiJ5KQYtnfRH/Qu7X1BkhKFE12lPF/+AaWi+dddzyamcRLfbqOX0lI05?=
 =?us-ascii?Q?BvkMNBKpUVpXIWN+0LFtyJYQfm7f5ZMKW3tyEQ9RxNYEO+8uVB1TKPKXhgZt?=
 =?us-ascii?Q?TrFvq6YmEW1vQrpikvc+gQlk7CGLIkRUm+5FyUk2Ci4APoJDI5KpH06oGUnM?=
 =?us-ascii?Q?3T1A5SIWEOCqGB6Jp/XQRsAYWGuTNUpVaDl8zt66R1aGKJdwtz5u3KozwmQH?=
 =?us-ascii?Q?h2UgbkpHEHVJUOKUORgNYC0gV5e3IbJLPprNbPhK3ASNJW+aEyqQlpnkBT7G?=
 =?us-ascii?Q?/5FhtTOl4JC1tLewHk/hvPxMacFLrL0xavd2QaVBjH1RHXgWU5gtUp6c47rg?=
 =?us-ascii?Q?M/faGP8347oXKaN5VPnCiIAQUHzv2SjKFsSjL2bnGSNh3siAFS23HFlx2OwZ?=
 =?us-ascii?Q?XpoJx4Ki4XdK7v0WK9ylp5s6PtDEhWz2HnLNQTIgYqIhs7y9idpN7EIX3WUQ?=
 =?us-ascii?Q?VOnWy+vv+iDSJoUziaiSHWkZvE8QakNoT5IUbmiWPSAKJkjIPQ8Aw3TW4hfO?=
 =?us-ascii?Q?c4k+aZIvBdpigTN5HpvKEZyVSKU4uQQvZzDLYepwczwGOYf9luTKS/KSfl3K?=
 =?us-ascii?Q?4DbA8Ot5tBZ1o6Wj4eopLDtm6vUwpraQt4jMy2FLU4Wb3YAsAn80pN4RjS43?=
 =?us-ascii?Q?xSWlZQYTGubtwpq2driej0E0AD9mT7vayDcv/xb57saJKpi4VDbftfE6rnzq?=
 =?us-ascii?Q?FvaR01tgO0K0u4hr7L4pHyugxTEpFPbxM6l21IM5t38renXFEl6W00epAI9E?=
 =?us-ascii?Q?QFdrCx2t5lwbygmFcYXi91SjcYEMToP3beP4ohPVwnklKWyWrwAeRfPYWIVY?=
 =?us-ascii?Q?eQt0FuPsG9LZPlHDKyi3j8028csYCdivljQYDS+KcJ2IbbLxPg2GvbfisWig?=
 =?us-ascii?Q?qevL2HcX4oRwYJpxQMqT5yvYyvOzQJPzCDsfzjeDkAr7UbP5aJcmjYd3mzFc?=
 =?us-ascii?Q?XihDTPMvSQVSFeEUTErlubEIUPpiBJ9SwNU4ZUtHEhU5hlp28JoJIpT9MAaI?=
 =?us-ascii?Q?TYF+zeJXgVjfYjntaIJPW8SdBvrHULZhUmUTYVhmptr6EpbBvdkTgF6Uwnff?=
 =?us-ascii?Q?4GDQ6IzXDN6YCGuBO3CNvK6b8WAXby4qkOKKR4ffAqzIC+i6iAUNqtVZFATS?=
 =?us-ascii?Q?92/r5KERpEwNoNo8g/VX7d9dlQpow8rEqYYcq1lI5xIfZWqwoRL6OlYUZ82/?=
 =?us-ascii?Q?MgRfGnkYECuDBUm2tFsx55J7+f28JbQkg4i8MYriNwuR9/Vwt13X1ebtmIU9?=
 =?us-ascii?Q?zXZxe5Z3XmWemYpwnvsZA2x6m4gOMrsIBaujJ4kcKflrlKAqKhaJPW3uJ5+o?=
 =?us-ascii?Q?GEiR5PO9TXYxJkgbk4Zalgbn4j6EassupmKW3Loa/+HJ2yo6vHtZ1Ku2HZhG?=
 =?us-ascii?Q?dP/c6IQi+drvrXzy/LQz58+VuioBZvoPYbRPPXYef5GcsIg0okby66Tsq2D1?=
 =?us-ascii?Q?WHR+OVKtNqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nI0PBEWlvm3Zrj77AM9zIu1HpS3w1pVGt4CpchvhWFMPzg+BoH/N1WJlWmgL?=
 =?us-ascii?Q?BuH5U9iBlQCQeFw7jVMz5fqlRblCOclp70UAWCuwUCit/ylHPtBQQmLmXSzP?=
 =?us-ascii?Q?yU9RYxFHh975+7YtQSCwST1v8AdAiTJlMz2QkMrbqu5SoTpNPme2shuyjlOW?=
 =?us-ascii?Q?Tn8lTiz2UpHJtQovXcwITYI9qCheldE/IqNE+aTheJHWkKotbSHgDLz+wVYs?=
 =?us-ascii?Q?MAR9Thgk2Iqz3R9ZtRThwyOg+sfZPUNQZ/8g+50J+k0iyUMSKck7zfDJQE8b?=
 =?us-ascii?Q?F34pvBH3qCbDL0gvE3RYjPQAEWgXf9o7jSz2sWfvmcXtavCGZI9ancdLu+ru?=
 =?us-ascii?Q?MKU19WezHmqELtqSuWgPergQXq8Q0YQviBsjiW9Pi4ToVXlly8IE4fxczp2q?=
 =?us-ascii?Q?Ewx7jePddxlZuQn4c0Co6Jw8K1EYH6jhf2GdpDDVPj07oNIKZe9DLGfyuBy4?=
 =?us-ascii?Q?Ok9tg/RgAsfCqyCq1ChDd8DffAqmd6EKHABB0ffRBeXK4SW3CNnCiI/MYNmR?=
 =?us-ascii?Q?CQ9D+6cXKzHg69csZN/vWqjb3wWL0hjxMRgzbA5VUTU9cRwiN0GfQwJz1bFI?=
 =?us-ascii?Q?zIT3xsqlAJwGrF5gSZXc2Qld5Knkva9C7AoppeVICpFPBBFq42gr93D9Iki9?=
 =?us-ascii?Q?BA3qR8A+KjdAg8936kqwv8gTGadPauhi3uMlcmoh8YxZDBTapBPwZGE2wCoM?=
 =?us-ascii?Q?Szs8ROoXhmy2CEMOu6dr/qgKgro5SdjDPjYPixFVFsWXvRtARwHIPqdnpnOF?=
 =?us-ascii?Q?uS9hVOs2+Q+gtFU6vOZ03kJVDYHPM39d7rbvk8Pq0Rbh6e/kLagtKUsRnsEg?=
 =?us-ascii?Q?g2H02wOtRiylmEty6QYfvmWu4rvOHlAzVq+gGaCMaaTWi4Zy9nzapTr47Aa8?=
 =?us-ascii?Q?7rJ4st3iFiDdX9DijBsdDLpPItydv8WC8tePoT8QzoJYsCDnOu1M8P4nSfkb?=
 =?us-ascii?Q?bIfQQdr4lBOt10bMtCXvc6E+irPfs92lkSiRevPfomwR0hgFRUn/eawS85P2?=
 =?us-ascii?Q?0LiDYtoOWr95jD8cwl3HS62PYgeIw6xYvubBx1o9HKP7POfL5MSw+zQwFmOa?=
 =?us-ascii?Q?R9N3itzjGINRY3uDAthPv2xzeEHHYr35kEHwbOUPm3KNhwn+XypfsK0dNHGt?=
 =?us-ascii?Q?SI8tO7VBPwsLc5UF4Cr8+QCKdBnSbY81B/w/4Jv3StlOX4JWL9fD5sGfqcPx?=
 =?us-ascii?Q?BlE9Aihl72e7lEFirWrUAKzmH5+IW6XXwzL1QiiGb7tVRjqWA2Ll5JIZX0v8?=
 =?us-ascii?Q?X+jlkFxCg2qtbe42m+lOb/NgqKqSvVWWrDSrc8ppyjOZYWxk3oYiIteIKX5n?=
 =?us-ascii?Q?SR7V2dUS2F8yU6ejpjAM9Zru8QvTenxVtJKP8Qvhd+j59zGZwaKYGEU/3XNA?=
 =?us-ascii?Q?1aP1oDUe6UPXxP494DvcGGAspJ2fKnnHa5+LQrgZYKsT+rCUpdXiVGjw1xig?=
 =?us-ascii?Q?Vm5uMY0hrD5OFWijIoXKF1hMgAkDkD4XT+5t5DWJnK8xGD4HsKXjseW4t61v?=
 =?us-ascii?Q?I1Ou9sdqNz67RO7H7LR1u1x80y8MUO4dfnZJAiYRX2h0EWev8xcm+Yl1SjOL?=
 =?us-ascii?Q?Fz6fHx8x+aWKG3Fkt8hOV/PrHpK1RsDiT7hSEcYX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9c570a-e1d1-4f3e-3ad9-08dde0bc4f66
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:09:14.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0JNwGKTXvTVUtiPQLVmCZv+O2qEJ28w9qQg7mT9KwskNSQMNqL3qrz3dEcQp9PpK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AC8241C0003
X-Stat-Signature: yced35cg6upmh6hfbgoj5isssjz6fd9x
X-HE-Tag: 1755785360-602332
X-HE-Meta: U2FsdGVkX1+tzXUT7r+EaVqI72H4aEvlhIva/wTfrl1BzZN47vRKvzVE3omXPSJZXpVXbLC+duT4t5VGBUQxV/9i/MXaksX0xRqA+V19jrnU/mHE/WYf3GDg22K2uhSe0cUeWdAXh1VSEw7DyoH7l4RBcpg1IMuR0hDQ+uDhy4eT/ksxLCd4Xpm4Wy1/1a0DudNr2kLMLY27DBhkgfQrxhMHuXG/kgqI9C7xmBVpli4E9L8mBtBVQY0c9EsvihhfPnxWe4H5x7NdxKIZAI+1WwuhBT9Po5/bl8KfnOxgw3BxKVcRpFCk6Q9rUd5EnSmXfMxsvkeywOQMgR27j2LTgRxW0h41Tyo/+f+16qwtutFfZ2J8rtZrpC0MPcTgXTnropFN8bKTnnbvyQziaZaZ/dv6wH0h/0vfm3ZxUsmz+NHlSpfC8o5reZ3rsB82zO2LBWmhlTot1fokxhE1rUQuFmxZJO3Oclepwxin/CqMQDAmnHAqos5ECa6YZ7DSmehtwEcboxMvRNTXEBnoyXvw3W6+N3UVbBQEdXeneV5dQTEHCJcT+9O7OL5DVpZtAjqd40/IfxD4CM4vkFn7dztOMIUdSUV2/dVqDQYx6ofc2VNXs7PJlwJD9QW9fGPBlYLkJSBD4Qa0eAJ51L9y17o8PhhDZWMuqjDEVa5gbnjbaiwf2iOJfFxEhgmjbFK+qrbdfqV1DLMUEhPEC07URId760oenpoPT+8kbqWJS9k/YnxRqyHgergVXuMfhjAHJFThTBtCSnD7khXa0/9gnqBNA555QDNhXdxIjxMG4Ru/hFhju24K9NWEDYOY1LwTySXkpFXRxCYd/uDnkrzb1uNQvaWhEzQ1VC8xCo3vcok294alfBWDSOey39UjFA7SAeKngVRsu2Wk+NQznBLdGq/dNohYcthXtQyt/1UJwyRbnkZS4sLkD0QtZMC5iNxDuxtcsPQlAbvL4RwWHN+jgtf
 9izcCThF
 yrwwS4H3fDrrg36WePJJkm7Og+SPlduZpQVoKX+TETYm5672bmJ2tFdIlhcvYo5kRgmX107iKFkwObcojImKdjn1vPLCqSz9qJLAoitaJk+oUHuP1dMU3XXaLMbBd09Ax3TKqGdW/Fm6/J7rfGQF7sE6y5VAq5AeRU8B+Pq7vFrvgtS9XU8qXn7WZYfvSWfiaalrZN8hi5D+X7VcMAftLR/NMTX/UwYNKJ5WiDyEBp/IaiY/nsOap0VDF6kgdAX4nCz/Oqz8CIfb8rosYU78s2vmA2VntrUx9k8ZeSvAtSjh1msnsWVNr1Au7b53siFnLqpfSm59HTkHzWEDLg758/PQWJLHKfr3KiTQh71/WjN44tC3IYzgHKQ638X/vu7o/+Ta4xbaQJ1vfj1PwILalek1N6kgpMBaJfH6ydgAl1hFDk+zcWhrOlZJ+T04Ca7xy+bQ4l6bwr03vtbPP5Nv7ApJuhtoJayZQB00JuaYsCz1dDrfu1BDacGLTT3gY9Sf0IxaJETW42GS2mPS3SFHuaY9/quXgh16lknAGZKTHkJwNhXvxs1LbbrdT1K6O0ypAIzfX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Aug 2025, at 23:41, Wei Yang wrote:

> On Wed, Aug 20, 2025 at 09:40:40AM -0600, Nico Pache wrote:
> [...]
>>>
>>>>       if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>>>>               return SCAN_ADDRESS_RANGE;
>>>> -     if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORD=
ER))
>>>> +     if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders=
))
>>>>               return SCAN_VMA_CHECK;
>>>>       /*
>>>>        * Anon VMA expected, the address may be unmapped then
>>>> @@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct=
 *mm, unsigned long address,
>>>>               goto out_nolock;
>>>>
>>>>       mmap_read_lock(mm);
>>>> -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc=
);
>>>> +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc=
,
>>>> +                                      BIT(HPAGE_PMD_ORDER));
>>>
>>> Shouldn't this be PMD order? Seems equivalent.
>> Yeah i'm actually not sure why we have both... they seem to be the
>> same thing, but perhaps there is some reason for having two...
>
> I am confused with these two, PMD_ORDER above and HPAGE_PMD_ORDER from =
here.
>
> Do we have a guide on when to use which?

Looking at the definition of HPAGE_PMD_SHIFT in huge_mm.h, it will cause =
a
build bug when PMD level huge page is not supported. So I think
HPAGE_PMD_ORDER should be used for all huge pages (both THP and hugetlb).=


>
>>>
>>>>       if (result !=3D SCAN_SUCCEED) {
>>>>               mmap_read_unlock(mm);
>>>>               goto out_nolock;
>>>> @@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct=
 *mm, unsigned long address,
>>>>        * mmap_lock.
>>>>        */
>>>>       mmap_write_lock(mm);
>>>> -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc=
);
>>>> +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc=
,
>>>> +                                      BIT(HPAGE_PMD_ORDER));
>>>>       if (result !=3D SCAN_SUCCEED)
>>>>               goto out_up_write;
>>>>       /* check if the pmd is still valid */
>>>> @@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vm=
a, unsigned long start,
>>>>                       mmap_read_lock(mm);
>>>>                       mmap_locked =3D true;
>>>>                       result =3D hugepage_vma_revalidate(mm, addr, f=
alse, &vma,
>>>> -                                                      cc);
>>>> +                                                      cc, BIT(HPAGE=
_PMD_ORDER));
>>>>                       if (result  !=3D SCAN_SUCCEED) {
>>>>                               last_fail =3D result;
>>>>                               goto out_nolock;
>>>> --
>>>> 2.50.1
>>>>
>>>
>>
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

