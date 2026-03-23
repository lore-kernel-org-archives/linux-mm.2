Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD52D58CBD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 01:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7516B0005; Sun, 22 Mar 2026 21:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568556B0088; Sun, 22 Mar 2026 21:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456F46B0089; Sun, 22 Mar 2026 21:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 347226B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:12:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 438BFBB5C0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:12:45 +0000 (UTC)
X-FDA: 84575553090.25.9D445EA
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F95B1C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:12:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="YJC6/mca";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774228362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMIOFYr3Foy57LJ/PeV+s0eg739CgrOUq0+F8GOkBEw=;
	b=X/mKxrThNFac/X65JKNnzk4Jf/Q+lffDeld5bmn+gD0WBENvjvtKuIB8zaBcOpk4BmE7CB
	1mfjpnMgZYgFBFLHVOzuB4ogS/zNY6XpL8vcw5mvSvqZA6vDVagttyamBhNCu/J2MlkhZ9
	Zg7PmzWOzfyhiP9rIY50rixiKOfKnig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774228362; a=rsa-sha256;
	cv=pass;
	b=UPdJlfhdP+gtondoy5FbNoezo/iLfXn+phoWKtkXxs004eczKO/b0fHWSDmnYyvxyU7ayZ
	HKYhxfOqSUMQK87NNRy2X3dAzDCZQ6J28LDVAN5lLqWHXtWZArzfRoiPLPxAwU6gDGCxTl
	TNyrUG22xqN87qEy36RoeHyNanL7HRA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="YJC6/mca";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAdlCj4KOzzkge5Dvlnt6Sp2kGBb22LdLFOBbgIYzioWix53OMDzId3w1lHMoVIeG+8zDvrlxzUtKrmMtN5rUrHoae+VoWUw65XDnHk84QYrIXKgcDEVsXHtrdnhVxTDkTW28XxdoNkzu8bUAJO1iWFC1E/zB5R+5K2tYLClMMHZPUKO1NAIcO2Q/Gth/su1iur49z+2s6583wYQks2g4ISzNeIuUHblTBMfKd+HIaUpLdGqxhgzaVJ3C6KmAwRWvu3NxaryVLzJCvS6lHtZ9jRDZDR/exfFYqO/saNbvvNquFVdM4a9y1owpeRmZ9+4VaDHbtFCgpVYkb81sm/q0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMIOFYr3Foy57LJ/PeV+s0eg739CgrOUq0+F8GOkBEw=;
 b=RSbnGli0GhfN3xUsNCni29DgeCfTRMhQrWJczHRFD8b4G0+kYCUc+6/nVaewDs7/idCUoHg9HI7sZ/cD1+++czyClkI+3sHEGckNTWZcRnsDbT5kaeKUtocIyf5LEU6/wZnmGBkW866rqEdXYVGe1s6d0r5ip+jAYj2FRM0jB6EX7xg1fAYocbnohWswGSMMrZONrksfYnBeIRa+u3SygWWBArvhe2Hug2cILXMko6IjDk/Bcw2GXep9V4tBNwATjsgNecou1iOEJtUPsHcMynv8bsAVYkY96iKrT359ZKTQrgRUDz/64cZxFabHrZu5eIwvqxMQYNatc5BOWw4Q7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMIOFYr3Foy57LJ/PeV+s0eg739CgrOUq0+F8GOkBEw=;
 b=YJC6/mcaxgkwTRotDmgv25cRM7isx4zKgumpcCt+gWkyOowk3jdAWl39dfAome8x8QSmIA0/pwbv8nViAbI10gPsVtdgV/mhT5b7FLgmxpgZhMwslosT0a099wNeAyutKEl4C2ukq0xxxY0UDznaKgYohfhWB5DOwgFSyk58nAp+W4psCYtTZTOPexE8HlrX7ofPJTBbl2wiWOP1xuzZjBoS6MMkYH+PIHs1YCHLooQeAhput91tIZ/yQbgCfWd+sIwuQg3MeRDcCZ9/HjrLhb+qkUK9qV6u3k9TxnE32RxOFpWDq929UywuQPeVfQeqras+FB+6PF+D/QcOPU9TmA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 01:12:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 01:12:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Sun, 22 Mar 2026 21:12:36 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B0985749-939D-4256-B9B9-C54C0734CF72@nvidia.com>
In-Reply-To: <20260320142219.375118-1-ziy@nvidia.com>
References: <20260320142219.375118-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:c0::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: cf59a138-7d7a-4357-1d7a-08de887945fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	G4LtzbmQ98EId68EtALcr94ju19e954XWx7PaVKTFiICtQsHjazCP5TX+bU+xGsK1QYQKYMaKBWOURzG/VF5fBEbtgpfFc13fVSL5zeByyU4b9ysRVEUr/tQLlTaR+tH81Rm1PlfRuk/ebb7lHPZzxI4ckPi0+++CjMRdk9VZPEBo5DWH1+kMZb+Kfh/yJKyYEN0iMW4iafj39AGQtokEtTwL/uCRy+u+LujUO+kvKcXWmVNFbIJFQdqjJ2hCa2sNHaKWBfmV/9Aa4O0uPTM6DfIvHiRMKJW3QvgyCER9dxeeTQSFc+Zy1g+j6UehocCOj4tWIQrfXVRFmoq1M7iA9ybtfdyV4Lt+KE6kbSUpcxpFmCB3+47X/9puLoPR8RNywtMB7ooY8Wy3T/KhWb5Pe/xbO0tPmmY2iGSQ89ZZR82HSrZKY7gKoY6ZOJ8wTgACg4hV53LqjiOTf4EMcz46EhhMZzhV5O50gWovShEjA2J3sX9h5ij26DJCPWm81Qf/gFdC87vNRG1fFIk42DAVNUutdzAs2n9HBPHmeaVvs/XOvaKM2E44QMFmELzW7FW4GC2UrN3e9wer7xLi6tZ65fcfPnO1DeAkPL+xIy1O6q/VwRY013r533ac6MScAyPCiRJkiueMsAXhwWzYjifkHDkCNwrH3Rc/Ay1L3UzAEDtrxVCq4dbjHU+nJHgumDukXUKYuDyT5n3DPRa62qi6TjdBQZ6F4Ax2FZzHSOk92I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2zh9TCI/2R+zhJBXS7g2P1ZcIZSTC4c3O0XWIr2bYb4cu+R9stH9SJF59qLb?=
 =?us-ascii?Q?A2jGpRWnbJyE/qXM8R/5Edc0Ntv0CoAqtBxkhdl0vPqy7xrBanVjjviyYdOp?=
 =?us-ascii?Q?DQgpwk2d0HBNQKs2IomeXTXvJJ32VnVNdjI26KLfCzE1nZeR5/DwZUa3O9n4?=
 =?us-ascii?Q?5oC6xYsO315RlhH2qb0OUSReoP3dldaZgpdRsxx1W46+oo3l1omwMZtLmijJ?=
 =?us-ascii?Q?tDQyw7aw2a4U1Wk9hTOXJNfzbRAS5y5Fba714YC4DoJFJPT/tRBSxDonjud3?=
 =?us-ascii?Q?37sekYugDTW7aFiDeBsgml9Vvzun/srVPI9TaN7OoUkZCNdlrHnJUQVr0mot?=
 =?us-ascii?Q?TYvQu+fv8ZX9OcOlH3ijBRfEp2a71qZIHgbnVtoRXLzKVZ3PxI9no2NXCc1J?=
 =?us-ascii?Q?1qkTiZmIhCd/ma2e9TFfqp9PWYG3/OK2/0D0497e9NL8TkJ/h3LGlm9gTEKY?=
 =?us-ascii?Q?bYxqWFEE+zdc4qbXXu3TrqD6YPvNxwouwQlrCu7Ob7vNv/G6MATPKdAaCCCL?=
 =?us-ascii?Q?C/TeoFejWDr1ZAzWZevvsTpWUSR5ETKZz3J03gsWhGPNxmM8hDJ0eJxbSI3V?=
 =?us-ascii?Q?svd/9yPJqzu65IWblaLClBi1iyXdhsVfKZXrfmuQ45YVUNXZUcrczPA9P4D3?=
 =?us-ascii?Q?b3zuzsGhA93iS//los2m8egBqiOpYhqvNCJNIpi+PxLXjISAaWPYFCQTplxp?=
 =?us-ascii?Q?gMyOhG68oMWJv8yc2ZM6IAIJc0dN5ampIfFsbrkDWybeMhWmyGu5uxv8nlZ/?=
 =?us-ascii?Q?xocEugW3UbR5OZ0iYvAbsGj+JLkgEMhbq+QtiZEKWdfnj6MGP5CMhBXVzp/j?=
 =?us-ascii?Q?KvTloYBxKeZLuytBeBTniV/HmJ13D4+0xwDqbVpUgzKDBdWYuKL5TAu1fFE4?=
 =?us-ascii?Q?/rsLz6IM2QR4GP8lApdfZlu00kRtlIDJzHvoNE52Ut5ETni2luiuxdKuxLPB?=
 =?us-ascii?Q?EgtjNGJutXEe8iW9B4oKjvG3kvvdG8vJKnHKv3U6jU1/foBQEZZe7MHoUhnE?=
 =?us-ascii?Q?j2AWJGaifSUhV6qAkuJlhr5bQpKbPNE+VlquaOyoVzzo94ND+l2PXro1XrZV?=
 =?us-ascii?Q?saI1/VGckntElmmDjzZBoZbYxKeWrnT/h0GytsPW7EUstBxyCJ8/hqgIzQK7?=
 =?us-ascii?Q?R0Fm07TuJdb9pVN6Td/zonkVbus/4HvfG2DGpRA4+6/zNkYNs3800xauoR5+?=
 =?us-ascii?Q?cK1qqWJW57n/ORIRd/gcRdARA7m//s8tAUYrSxG4aFCitrk8dHGSAeNdCYMk?=
 =?us-ascii?Q?iv8ybNF0YVA/9nMmVh5DMg9DTLm2hnRXAbMJmvhl3au/togq83MtC6bsfia5?=
 =?us-ascii?Q?QWQTzAuJxFfFdp2BkArIpv2AlXGAA3yHOcAyGlEkReXLcgAAeQxolHz7vtk0?=
 =?us-ascii?Q?zs3UMfqF+0QS4loqsMMXHIyffquZEvor2aOYKqmtPeqn0S2lsGceNLPSqSqX?=
 =?us-ascii?Q?kQb5orKMjBtU89OaLdHfZoHVhYGVWJLK3LI8UQIbrIPR7q7rQoSmzMzy7phP?=
 =?us-ascii?Q?MXUKh26uUGnEWvoch0tlySnuAw6WhqhlS1QTBwipRD48Ol6HldtjsQD4LEFc?=
 =?us-ascii?Q?dbX5F3yQPBuSZjC4/Lha2CNlYCPv+kW53yAyM6sMGHH6WTcFODhGCNBSNJUH?=
 =?us-ascii?Q?W+FIVw2e/SBeLwr74PIqaU72fQ1ZH2UU7tkEWv1qgv7hjAeyBixZwoggCb4z?=
 =?us-ascii?Q?7Vv3x7sDq5A37TvG2mLDop3uDdZb4DHkjy3RjCn5f8n/cbjN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf59a138-7d7a-4357-1d7a-08de887945fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 01:12:38.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdJmmO0l06W35JMp8lqKFy8tZhv2rtFfWwYaJUhCkt9ITTw/SHMA88lkfInkpjLw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075
X-Rspam-User: 
X-Stat-Signature: ygj7duigb7eqyjn1gys44a19zw39mkmg
X-Rspamd-Queue-Id: 5F95B1C000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1774228362-883898
X-HE-Meta: U2FsdGVkX192n5ydHs3ebP19bruAh5JHVJkeltgNnTyy+jRoOUQBDMHI0ZVx+0LA68LVYSamNP+MexTtErshjyXfHFkvjHrq+Pc/2VrYuHxopJoe6y4BW7lek1Ei2heQzN0ILg64p6fNUoEB1AnGpIqrFeHhh0WnreAPTfN1Ruw7YlvDBqm/vfENdPYRleJs901jYwpnfIe8wSSz7E5UUaGgC26ZijumfmVeT+Mq/KL7//WiWtVoS5+FP6FYM2w1IkpL4OyxhEYub5cW+TRsMFgF1Amj3giZ5vorRCppiPafLC0R2TtbKjxRG9Rz1fGthyVR65TlYaBibMUiW6mWow3/UKz1Fjlp1MVyaq79lvBawDIgfLSvPDFZVaXaql11PzZNJIMaP7OdqWAXdmPgYW9DsrKdSH4JhiFizqrhdEk//tIULsL4HQeD+e02VtyqyPYHnfJ9mzqPO3R4PvKXSMZ7dj4JvzmmJgQQI/L723H/hZ2IJEli6P7zn7NfGctDsORkUy+AM4Kyial7UPIoToVGCIHeNHBWyJH022QA4r6kVZdGv20WbzeQsaSnVS6uodpnkmBsgM7Ns3AvPVLnHtocCqRqX8fEshlqTZ1lfEtGyIJNJZFY6+lZeYoQ/Unx5/BqLtHP/KmwNx3n8RfJ3AomI7Ku/+J+ayuQfxEhLq8Plxf3cX5O0Dt9UKz4t5Kduv8bATKqD02ep0OWuWt6B45jBk+XD3TC2iqGQPSclN6GlFu3M8Jqi1RRXNIGvX/ZXJTztYzQdzzkXL1Yw7Jhv/NeUIXCN/EnhjEXRyEgH4P0oCIrWkO71ZB8pVR2QMfH/LhaDjn2KMDROpKWZ+PLcsQEQZOg+xEi/rBN0m3x+6QWzHgcjsFGVFC58HR6LSJ4F661ZmTRsqhiwgeDbmZtYDr5rfMaR2ZhHfRd0nkoXZVQqkC7c38mCFfNfut5RRT7JsRhxEqjiDP7/HelCPD
 lucvnepw
 Hp+ha5/GWzJN0iUVVxd1UQhO1Zymrt6Q2a1vmnYJ9e0qeMCAcfJKLRxlLm6cE+tIRbq9vB/GaxKpNPrHpIo0+qBw3oYSXauq874S2ooDU3aOuVAUxRitb1nwSA4YiiVyRTzVTy/ddl1hb4iJa6X1HdWgIp2HcsR/vKzN7fETxegrZZAUnUg0TPFq68qlM5/5wriKffJfvj2majt0D4WXuYAUpp1nmH6VAI7fpONUauYV5H5pK0nS8qfpoUe3wd2bNDpi3QjPrnG/SP9/mnFrsOefgnbp/3AxjTOPXdtx0HpGQCH2Almj/AL2QmWgaztk0nsnsZiJIh8zPeR/i0pPJevsBf/GF+pHTvYg450eDUVzYWSPdHy9dW+ojOXljGa2qmYj+r+bg/YukgTSUwFO+PdjKvp1lA3zLfrXDZlnljj0aF7CakRPA7uowLWv7xc1r+M04lZr/m+cA3prpEHJ7kezAsNrETWT3dg+pyN1L7IPPlWPWvbLaQ0OBvFmUrUwf7WEXDDvYZZhp4im93kREyIacOsN7OcnyA2x93Trsd6peyPhrHEqrZyAk7o0s8dDFy4OtsXO7A0BdsiIi5eCTgcuA/4NiPHt9v6l/fXlxd90WgWi40G2TUTW07g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 10:22, Zi Yan wrote:

> The added folio_split_race_test is a modified C port of the race condit=
ion
> test from [1]. The test creates shmem huge pages, where the main thread=

> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the=

> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and u=
ses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
>
> Note: the initial rust to C conversion is done by Cursor.
>
> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumW=
JdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> Signed-off-by: Bas van Dijk <bas@dfinity.org>
> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> From V3:
> 1. fixed for loop stepping issue
> 2. used PRIu64 instead of %zu for uint64_t.
>
> From V2:
> 1. simplied the program by removing fork.
>
> From V1:
> 1. added prctl(PR_SET_PDEATHSIG, SIGTERM) to avoid child looping
>    forever.
> 2. removed page_idx % PUNCH_INTERVAL >=3D 0, since it is a nop. Added a=

>    comment.
> 3. added a child process status check to prevent parent looping forever=

>    and record that as a failure.
> 4. used ksft_exit_skip() instead of ksft_finished() when the program is=

>    not running as root.
> 5. restored THP settings properly when the program exits abnormally.
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../selftests/mm/folio_split_race_test.c      | 293 ++++++++++++++++++=

>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  3 files changed, 296 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c
>

Hi Andrew,

The fixup below addressed the new issues (first and third) raised by sash=
iko[1].

The second issue is that the test only verifies first 8 bytes. Because
the test is intended to verify the race condition causing a wrong page in=
dex
is used.

The fourth issue is addressed in Q3 from V3[2]


[1] https://sashiko.dev/#/patchset/20260320142219.375118-1-ziy%40nvidia.c=
om
[2] https://lore.kernel.org/all/8B720FB8-DE4D-487A-9AEF-AC204E9F5755@nvid=
ia.com/


=46rom a66945de00f33c163cf814ac7c2d9620a725bfed Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 22 Mar 2026 19:53:54 -0400
Subject: [PATCH] selftests/mm: fix sashiko complains on folio_split_race_=
test

1. used PRIu64 for uint64_t
2. added pthread_barrier_t to ensure main thread starts to punch holes wh=
en
   all reader threads are spawned.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 .../selftests/mm/folio_split_race_test.c        | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/t=
esting/selftests/mm/folio_split_race_test.c
index c264cc625a7cb..ab6868e7e2efe 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -46,6 +46,7 @@ struct shared_ctl {
 	atomic_uint_fast32_t stop;
 	atomic_size_t reader_failures;
 	atomic_size_t reader_verified;
+	pthread_barrier_t barrier;
 };

 static void fill_page(unsigned char *base, size_t page_idx)
@@ -78,14 +79,14 @@ static bool check_page(unsigned char *base, size_t pa=
ge_idx)
 		}
 		if (all_zero) {
 			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %zu) is ALL ZEROS\n",
+				"CORRUPTED: page %zu (huge page %" PRIu64 ") is ALL ZEROS\n",
 				page_idx,
 				(page_idx * page_size) / pmd_pagesize);
 		} else {
 			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %zu): expected idx %zu, got %lu\n",
+				"CORRUPTED: page %zu (huge page %" PRIu64 "): expected idx %zu, got =
%" PRIu64 "\n",
 				page_idx, (page_idx * page_size) / pmd_pagesize,
-				page_idx, (unsigned long)got_idx);
+				page_idx, got_idx);
 		}
 		return false;
 	}
@@ -110,6 +111,8 @@ static void *reader_thread(void *arg)
 	atomic_size_t *verified =3D ra->verified;
 	size_t page_idx;

+	pthread_barrier_wait(&ctl->barrier);
+
 	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) =3D=3D 0)=
 {
 		for (page_idx =3D (size_t)tid; page_idx < TOTAL_PAGES;
 		     page_idx +=3D NUM_READER_THREADS) {
@@ -178,8 +181,14 @@ static size_t run_iteration(void)
 	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");

+	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) !=3D=
 0)
+		ksft_exit_fail_msg("pthread_barrier_init failed\n");
+
 	create_readers(threads, args, mmap_base, &ctl);

+	/* Wait for all reader threads to be ready before punching holes. */
+	pthread_barrier_wait(&ctl.barrier);
+
 	for (i =3D 0; i < TOTAL_PAGES; i++) {
 		if (i % PUNCH_INTERVAL !=3D 0)
 			continue;
@@ -198,6 +207,8 @@ static size_t run_iteration(void)
 	for (i =3D 0; i < NUM_READER_THREADS; i++)
 		pthread_join(threads[i], NULL);

+	pthread_barrier_destroy(&ctl.barrier);
+
 	reader_failures =3D atomic_load_explicit(&ctl.reader_failures,
 					       memory_order_acquire);
 	reader_verified =3D atomic_load_explicit(&ctl.reader_verified,
-- =

2.53.0



--
Best Regards,
Yan, Zi

