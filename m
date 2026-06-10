Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63E2CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AED6B008C; Wed, 10 Jun 2026 14:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032206B0092; Wed, 10 Jun 2026 14:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A5B6B0093; Wed, 10 Jun 2026 14:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8FB96B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:44:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880411A0260
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:44:58 +0000 (UTC)
X-FDA: 84864879876.24.F7D7F8D
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013069.outbound.protection.outlook.com [40.107.201.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A79A10000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:44:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GH3krc89;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781117095;
	b=To2PuCrghNTJiZuWyMXKo05KMsdNoef+jimWtrbFMwcuF9MhuBnGwvFK9CsKYFLWWu57Eb
	llNbthNXmN+r30obOQR6zGQb4VJP26kQ8ANNxGksGbcV9An90NBvmBrLDUJJOQmXdaCABk
	LKr1ues5Re25TTNG442uGQAJrWiaqhk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GH3krc89;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781117095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/C04mdNhNRnsXyx20Zz2tQlm6GqKy980AfdbARX/QE=;
	b=YwM9e4uS5UmWKSQO9rkAvJvp3UflCJ8OecKm0SR4Efqf7xC4WLnl0butwKVRhIm6JJf1SE
	7CoVrwZBKqs/j8B//+CczlwDqMQu/2wqsYw3zxFswKQ7g3CPQdyEF5X1g72uVmXRcGR92V
	oXsnU5NNkRz2qDS8i3Uq9Me3F94hFAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7kPPJel5nWQmjRVPZdzOeZVi+/zIfjRF0LmSOFhmEAibLMrZzCRsOv4j/0lR/uY2lvw8JSAu6lg6npix+tOekTOmlwJwXT7xRKZVmhfVtNluAi+G/EUMrwvngf/BZsm8JuxypuVowcspffVhaVYUZntWR0mX5YvUq/l4TkTrujO+uyJWPXD89hYrKv0ZamLFFCeYA86+WfMa64ekSsaBuPjE8QLDPNOGPWdOL7pzgc1aQGMv3a7jakibjbgN9zqtKcYKBho+d7JhSHGlGutVw/IMEbwWb+eKSzh9xdgHx7HqLsHq7MpY662xDzQ3eMQXAnHXUOFXMeertJW97zR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/C04mdNhNRnsXyx20Zz2tQlm6GqKy980AfdbARX/QE=;
 b=efpivYIhQp4WGciaik7I4emUISsQhjP/ZfCapnOY3nYPtpgLZMBXc7v7Fb/NN4ng5rWFwHHmTV/vcGToZxyuBZ88xAvl90zzlOzhDuFmMD7g3XaxWuCoRSNV9fzVoGME6CsLwYmSA24Las0zFyLHEQQhd+utc7fx7PWqLaSQkHS/jPFQVGymVhyppvJl/gNI2MxuMVtYd+vTkwO7lklm0Br86upMERM2zmyDseRTIzpxKhFiVFLaaHx5nCKRcU3BIxm78zbiqRb6Q6h0fK9k7gHV7QWLxoRuvkGls7qgYx08KsTUuG8TBsPomgycHxjXz/E9eDqVPUc6f6bNdg1NoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/C04mdNhNRnsXyx20Zz2tQlm6GqKy980AfdbARX/QE=;
 b=GH3krc899nNhtoRvirmnmuSU9CqyaVcaXcNj0JWNqQ2vIU5OKN3KZ2ueBInrQy5HolrjXNeK899opO/hMe4ceP79Bv8C2kO2ChRhGbAuKvo5AgiDW4gHmt3kVi4m99z1BBWDRka02Kr8pY9Tg4LgPvJZrsIBWEIhECrmDtqxqcZG8n1BNK+v6ZZ1UX6qbJxfJKAya7eCayd5YYtiGksyj0nSFZ8ynf5J3rVb+/jAGIXI3R+YAd75BmosrA/3AbFTmKWkTGiDtsqkriWY00hJUU0+nti/z7dr/ESxRImhmveosWolQopADmObM5OF8uczMD7AD0DQx+c3Wx/AH59puQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 18:44:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 18:44:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 14:44:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F21E44A9-0FB7-47F8-86CC-6D38FD2CD24B@nvidia.com>
In-Reply-To: <12FE92F3-B8C3-4D4E-B86A-CC2034734466@nvidia.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <12FE92F3-B8C3-4D4E-B86A-CC2034734466@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:208:2be::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 357f5591-9fbd-4abd-e103-08dec7205a27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|6133799003|5023799004|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	MTZbk2DxbgMFGvO6HJjENl8o5baRSMjvR9J7JkIwzbWaIjMtREmUTViEQHUZ07BgkMqMlnwil49zmrAZ6+CtzN1Qv7Zhk6EsNdg3OCllfuB6CHpSrbtGJ8lsp1BdjBkFufW4AHQ9yt4U5QFCD1LF3GI9ccJx2o1b8PnaIBJa/OdhBrasJ6msiysc5vAJ//p6RzdtRT2SUJ+DA+kzrFcoOqrReNa61OVV1fzeZnGSRaGtj3+wri9Jh6idqQmk1RhROEqmS1FDxL1j/kQ2M7LPVA5f4M7cH2GTFdsvuBspUyZ1mrqhtrLgHjjdlY4uz6ehkKHwVrSN7v7+d6ydilQTreTgnJ+YAKv4RY8Rert9VRCySKgWATA6Ir4QLJp+g2jXPRfle4WIGTszclDFuoqEYWBrSQDZIEUBHvW/lfs5wzTw359IKUyG+S8woD4Ph0OdDl1ivQyNVf8neAHVkvGbNvJNofahFAj3iXhga8vEkhIe9zkTpE6k6HV7+HF6stN7ykD3vLsYufmhUe1tyVVaPy+48vc6uwb2jYJsd30dd0iQuKDk7W9/aTE9lJLbZwNY+n9nP5Xa+jwY/vqDsYVSrOgA+SP8suV6Cmt+ej+heoV99jiuA/htp7d5mMpqUii6X2TB4ItgnQl9e5rvvmvrI8JRqUrBUH+dnjE5GO/IF0275DMePSEBYjZm/jHm7Q8M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(6133799003)(5023799004)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6T5CW+a4pFPzmgFkOqFyJ/oGRi8zg6tk74KsHq2LKfBKRiP3hkaHyibCEKAC?=
 =?us-ascii?Q?jn1HA9UsnzzQ0/4uf2fc+Sg/KSHAbAEU/4zNey7JMRSSzEwf2aoM/En1MXAY?=
 =?us-ascii?Q?reoZa2LkFViscefAtFhEilfCOVpNl58PElUScYUY0qLQ9GFGcfygc9BFT9s3?=
 =?us-ascii?Q?5dW813kIQgKfPPU4VTi/X09lBKDvv//6IWxTfPxuYRQL6jitFwKFxdT+LFCL?=
 =?us-ascii?Q?+6M2d7JBW482UEshYlAZ1D6RTpTDyjE13h+vGLcws96Z/IExbeu6oG6joORO?=
 =?us-ascii?Q?vxMJzJalAMP0cKlU6QWe1ri22CL7UCgdYvhzGlwUSmuAlFA1cjfJiAseMX3V?=
 =?us-ascii?Q?YeWvnjSQa3LTe0HBsvxpIsVw/NgP/Z/NPNUYA3FhkIGoGDyak8fBhSCFd0FW?=
 =?us-ascii?Q?bLmDV5nk+GULA1dgnCfI699RtrtIxviPibAfOSP0umMF5g9vJAAnEAWIagP4?=
 =?us-ascii?Q?wHI8AIj5Wb6NE3rXby6t/mWeQGVNrsdBTrBu5yPaq8dZRFddFxzwuAC9sDYQ?=
 =?us-ascii?Q?YIk1tuUggsTD9jiuAnOmrpeSSBIbYVkpUds2AY4eDBNHFR7HPCI0Coiy7OYh?=
 =?us-ascii?Q?waVpUtDThS8HLsCFlUtBo6MYC6xKekf5aZl59Wr8Kw6/Jp3BpZGXINbae2jE?=
 =?us-ascii?Q?ONDtFmVyRgf6Jd0XIWjTxF6O7spx3NtF6WAzJHAuzv/Xb/9rkqYt9Zz3Qyom?=
 =?us-ascii?Q?d4q/nuO2OqrKSPtTIdJBskYplW7Cg1HIYaIXWa30F4J+hoOu6kGfuDofEOM8?=
 =?us-ascii?Q?KnVG37dda+x4JgF1si3MSVSjIo+TzH095hFajNrhmtx88ig6LbYEqeYfsVnl?=
 =?us-ascii?Q?pnjk13Vb4hjrMI4bPSqYjAS0EsfpzaC3RDYCpB4R8/hI97dLViF3vdQ4jMq9?=
 =?us-ascii?Q?zaxIp9XguRNf/WVDhX+LxOp/WthqIvgt+wp/Vu373hIhIYcq4K1jJIJTNuLL?=
 =?us-ascii?Q?Di3vPF9QxNxR6qUdAO7pUOD7EJe6cM4u0jUB8KcUpSx0frahls3g3+QXIVgX?=
 =?us-ascii?Q?c9jkerS/dGCnSydgOqXjDqxOydrPl1PmlazCRhbGsWvSMBEDpzMvPB62srnc?=
 =?us-ascii?Q?P5tYmq1jixIJu5ujlXMmf22+b5C/C0GrIeRtLkn1j1avrnBUci0AQ1MNnMWt?=
 =?us-ascii?Q?2+bNIuLV8SGJR3qy3g6nOUDi0ux6+ZmDY6NXdTjYLvcANYswNDgvi/oRCBR8?=
 =?us-ascii?Q?7aTRh2PTv6wBGqIqi28C1m9ojvaou+i/eG0Kqp3z0JKbQ6Kpp55PTJb9v2Vv?=
 =?us-ascii?Q?K0iU7ASVPZ2VJkSexb0BzzEVi17mIiia9qdMfRKK75nWIay0/YEbvX4zyhlH?=
 =?us-ascii?Q?Oyu3twOLyeZqQuvLuzAO97/cEYK+XEHMpKJzyqDkGSFTGXs/NA7LreQYnAFs?=
 =?us-ascii?Q?nPPniY0pk2We1KYBeSduYotKAmxA7h/z3qQhEq4JODwfCeyrYuSOkZRvdU3o?=
 =?us-ascii?Q?cq4Gl/QMVQj9AWF+19FIWt6c3B7Fd44kfB/cP2UOFzN5IK8TZYSdmnDP8mun?=
 =?us-ascii?Q?+2BXK14nm68wzPCerpi0ffY+pPBQDFZ/EVKZcHRUgpKXUcSefoueiIDMa6cr?=
 =?us-ascii?Q?VMqGBRB9MilVXgUYC/Tgsc8E3wjN+hLgGE8K0i0rPuXscLEu6Y0TJeLwgH0p?=
 =?us-ascii?Q?eHv8WyqpcDyMnH0qqmNS5dWCdNjvLbdhJYSufzizqAf3MbjoLSjBnmWHVgGH?=
 =?us-ascii?Q?W6JosT1YK1evZhk2oHtsB7QZAB8HjZUFL5+cbywqegibgz4O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357f5591-9fbd-4abd-e103-08dec7205a27
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 18:44:50.1404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMfdCEw2ZuX2ykIt0agHAQsz3CSwQMESR0tip9qawJih/WNR2oGNklk4BX92zbig
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A79A10000C
X-Rspam-User: 
X-Stat-Signature: z37b3bk9mtarzfp3kyf95qbi54n938n3
X-HE-Tag: 1781117095-415291
X-HE-Meta: U2FsdGVkX19fVLAFfp8+oblOXoNqqC844pk9kIViU6mIlG4u00gkMvgS0KCXS2UC9jtTkoStsbg5pEhatA5NClD4gCwo+1OrnZ6NNa7BsVC6vGZvCgKftyB7R3sm+j/kmqRhk+AERQqzMoadoTLnVI6KRbJ5B6Xgs/aAwT4EKFs7SYvf7Yl/km6WjYkRT1Voz6q7HdrQgGnTWR4IfFVCJzmrNRGQas8KJuhbKjuW/hF8BDGa6CsfbhjuCc9PYeV7w5rI272nReAXsl/wIoLEh54tWLzVmw8U27U5TdkFvm6LHdzMYrUhXZz/aUASChoCSYcMUKGyGzISi3HBYf99LMiCXsMdrbixr+kbDywiCFwwsKf8rNAv4XkUBKVbwziwYOq1zjeI8zGy90ZyDd60Uuz5Nkt657mphR60MCcCBTrpNro3OgM+8TBDwClPCpTLH0EegNsU86DEiv/jTh91B1mLp4boL/ZJUtPw4Y2P+T6IgYSp0TwzVbXJ8EttSVg3jXphgq5L76DdA8rShgQMA8wLHHpmZVN0oLKLCWGWv1G8C4nzm2L2EDm1sMoT/4ETASX3Dxy9rAegWNI/XvAVQulASaUU72O12bA8tCO8vg1dgGSDUeRrIAhvLuZC9G8hHfCeilFMHb6v1ZhjxqSAvbjWAUNwKkIlxMo4W16Sm/YxZhBIYqWvXgFd3V5Cl9u+fnr/ufseIslXYyF+1m499GzzUIjAz2AFsIntUKQO5RR9Iw0D5LFh0mPY10yNIkVLZFP0hmnz0aIRW3+Ge+1D4VXEwK4x4xGDgTRQx4S8OIRMM7skAS6a4ufW0jjOzU80E2vQLsn2KyPJNSxo6viKnVu6+sQIAcJGL2PCkr9qwZzsBZXh13fs6VOutVccznsuyceq1S+bSuhvPrrleGnyF0wBwSCfHrJg68oHPsFlj9V5IZBpcZokFMFCv2DK/vnrHLFXUFFr6dNfWWeINgy
 j/X3cBu/
 xeguTPGU5Nv4DDfjscsQ5pxUHUwK/m/aOcSRhaDGp76cHZlsYh3eQlUj+g16FYTelyDfVs7QZExVfptmoKKu/2q25DeFku+YMmz2QZ0UsSKiEvGOZ1L64C1vjsrlIpua/si9VilbaDcESmgG99Wlod53pEoFlUTQxeirTSBCFYQI+Ei1jS/eCPbYOUWLUNjNRbE/63U2sDTgLEHG+9xL29iOeG30F9nZ/ZI+rlcjYO6nMfkwubcpgfE2W1/7NTD8aMcJRSs8dhMAZCTYeld52nfmPgeWIAdcyke7G8oX32WYi8uVOXNwAkoo/j4aARSQQ2xe4JPEuMTn35HPTeNtLVM3FY0/8FZ3hXHNbmEDswvvBPEl/a7jHtwtrm1hKF3jKWs01Zo9N/nwN6r3sNV6DJRfNFH/tMAGRWBDnk7sjk3lTPdobHZz04W5uE0WYp3yWAfwGmGtFwfjm+/Q0VYt8JlxrVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 13:25, Zi Yan wrote:

> On 10 Jun 2026, at 10:38, Zi Yan wrote:
>
>> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>>
>>> On 6/10/26 14:05, zhaoyang.huang wrote:
>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>
>>>> The kernel panics are keeping to be reported especially when the f2f=
s
>>>> partition get almost full. By investigation, we find that the reason=
 is
>>>> one f2fs page got freed to buddy without being deleted from LRU and =
the
>>>> root cause is the race happened in [2] which is enrolled by this com=
mit.
>>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: =
remove
>>>> non-uptodate folio from the page cache in move_data_block").
>>>
>>> But I assume, that other FSes can trigger this as well? Any insights?=

>>>
>>>>
>>>> There are 3 race processes in this scenario, please find below for t=
heir
>>>> main activities. However, by further investigation over the code, I
>>>> think there is a common race window for the truncated folios between=

>>>> split_folio_to_order and folio_isolate_lru, where the folios lost th=
e
>>>> refcount on page cache and remains the transient one of the split
>>>> caller, under which the folio could enter free path and compete with=
 the
>>>> isolation process. This commit would like to suggest to have the fol=
ios
>>>> beyond EOF stay out of LRU.
>>>>
>>>> Truncate:
>>>> The changed code in move_data_block() lets the GC path evict the tai=
l-end
>>>> folio from the page cache through folio_end_dropbehind().  Once
>>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, th=
e
>>>> page-cache references for all pages in the folio are dropped.  The f=
olio
>>>> is then kept alive only by temporary external references, which allo=
ws a
>>>> later split to operate on a folio whose subpages are no longer prote=
cted
>>>> by page-cache references.
>>>>
>>>> Split:
>>>> After the page-cache references are gone, split_folio_to_order() can=

>>>> split the big folio into individual pages and put the resulting subp=
ages
>>>> back on the LRU.  For tail pages beyond EOF, split removes them from=
 the
>>>> page cache and drops their page-cache references.  A tail page can t=
hen
>>>> remain on the LRU with PG_lru set while holding only the split calle=
r's
>>>> temporary reference.  When free_folio_and_swap_cache() drops that fi=
nal
>>>> reference, the page enters the final folio_put() release path.
>>>>
>>>> Isolate:
>>>> In parallel, folio_isolate_lru() can observe the same tail page with=
 a
>>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking it=
s own
>>>> reference.  If this races with the final folio_put() from the split =
path,
>>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio=
().
>>>> The page is then freed back to the allocator while its lru links are=

>>>> still present in the LRU list.  A later LRU operation on a neighbori=
ng
>>>> page detects the stale link and reports list corruption.

Something is wrong here with the caller of folio_isolate_lru(), since
folio_isolate_lru() requires the caller to take an elevated refcount.
This means when entering folio_isolate_lru(), the EOF folio should have
at least refcount =3D=3D 2, 1 from folio_split(), 1 from the caller of
folio_isolate_lru(). This should prevent the EOF folio being freed
by the parallel __folio_put().

Hi Zhaoyang, can you elaborate on the folio_isolate_lru() caller?

In addition (with the help of Claude), the race trace[2] below
looks invalid. It says split happens after folio_end_dropbehind(),
which sets folio->mapping to NULL, but __folio_split() returns -EBUSY
when folio->mapping is NULL in filemap_release_folio() check.
So the split cannot happen.

Now I am not sure if the bug report is valid or not. At least for
folio_split() and folio_isolate_lru(), the race should not exist.
But let me know if I miss anything.

>>>
>>> Complicated mess :(
>>>
>>> So, folio_isolate_lru() really only requires the caller to hold a fol=
io
>>> reference, which can happen given that we did the folio_ref_unfreeze(=
). It can,
>>> for example, be triggered by memory offlining or page migration.
>>>
>>> So we really want to not allow folio_isolate_lru() while we are still=
 processing
>>> the folio.
>>
>> Or we should defer adding split folios to LRU after unfreeze.
>>
>>>
>>> What your patch does is, simply not add folios that we will drop from=
 the page
>>> cache to the LRU?
>>>
>>>
>>> You should describe here how you are fixing it: "Let's fix it by..."
>>>
>>>>
>>>> [1]
>>>> [   22.486082] list_del corruption. next->prev should be fffffffec10=
e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>>> [   22.486130] ------------[ cut here ]------------
>>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SM=
P
>>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
>>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>>> [   22.488539] sp : ffffffc08006b830
>>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000=
000000000000
>>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffff=
fffec10e0ac0
>>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead=
000000000122
>>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffff=
ffc080061060
>>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000=
000000000058
>>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000=
000000000003
>>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8=
5721f0e25f00
>>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65=
645f7473696c
>>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000=
000000000010
>>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000=
00000000006d
>>>> [   22.488647] Call trace:
>>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>>> [   22.488661]  __folio_put+0x2bc/0x434
>>>> [   22.488670]  folio_put+0x28/0x58
>>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>>> [   22.488739]  el0_svc+0x3c/0x98
>>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>>
>>>> [2]
>>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU=
2 (folio_isolate_lru)
>>>>
>>>> F: pagecache refs =3D n
>>>> F: extra refs =3D GC + split
>>>> F: PG_lru set
>>>> move_data_block()
>>>> folio =3D f2fs_grab_cache_folio(F)
>>>> ...
>>>> __folio_set_dropbehind(F)
>>>> folio_unlock(F)
>>>> folio_end_dropbehind(F)
>>>>   folio_unmap_invalidate(F)
>>>>     __filemap_remove_folio(F)
>>>>     folio_put_refs(F, n)
>>>> folio_put(F)
>>>>                             split_folio_to_order(F)
>>>>                               folio_ref_freeze(F, 1)
>>>>                               ...
>>>>                               lru_add_split_folio(T)
>>>>                                 list_add_tail(&T->lru, &F->lru)
>>>>                                 folio_set_lru(T)
>>>>                               __filemap_remove_folio(T)
>>>>                               folio_put_refs(T, 1)
>>>>                               /* T refcount =3D=3D 1, PageLRU set */=

>>>>                             free_folio_and_swap_cache(T)
>>>>                               folio_put(T)
>>>>                                 /* refcount: 1 -> 0 */
>>>>                                                                   fo=
lio_isolate_lru(T)
>>
>> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio=
), folio) in
>> folio_isolate_lru() would be triggered. Maybe we could just return fal=
se in that case.
>>
>>>>                                                                     =
folio_test_clear_lru(T)
>>>>                                 __folio_put(T)
>>>>                                   __page_cache_release(T)
>>>>                                     folio_test_lru(T) =3D=3D false
>>>>                                     /* skip lruvec_del_folio(T) */
>>>>                                   free_frozen_pages(T)
>>>>                                                                   fo=
lio_get(T)
>>>>                                                                   lr=
uvec_del_folio(T)
>>
>> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T f=
rom LRU list.
>>
>>>> later:
>>>>   list_del(adjacent->lru)
>>>>     next =3D=3D &T->lru
>>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>>     BUG
>>>>
>>
>> Why does CPU0 still see the stale link from adjacent?
>>
>>>> Assisted-by: Cursor:claude-opus-4-8
>>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>
>>> I'm wondering if this has been broken the whole time, or if some rewo=
rk allowed
>>> this to trigger.
>>>
>>> I assume the issue can be triggered for other FSes, and we want Fixes=
: + CC: stable?
>>>
>>> Looking into the history, I think we always unconditionally did the
>>> lru_add_split_folio()/lru_add_page_tail().
>>>
>>>> ---
>>>>  mm/huge_memory.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 970e077019b7..7465525a94a8 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(s=
truct folio *folio, unsigned int n
>>>>  			folio_ref_unfreeze(new_folio,
>>>>  					   folio_cache_ref_count(new_folio) + 1);
>>>>
>>>> -			if (do_lru)
>>>> +			if (do_lru && !(mapping && new_folio->index >=3D end))
>>>
>>> It might be clearer to write this as
>>>
>>> 	do_lru && (!mapping || new_folio->index < end)
>>>
>>> To match the page-cache check further below
>>>
>>> 	if (!mapping)
>>> 		continue
>>>
>>> 	...
>>> 	if (new_folio->index < end)
>>> 		...
>>>
>>>>  				lru_add_split_folio(folio, new_folio, lruvec, list);
>
> Talked to Claude and find an accounting issue with this. Without puttin=
g
> EOF after-split folios back to LRU, they are not going through lruvec_d=
el_folio(),
> which decreases NR_*_LRU counter along with removing the folio from LRU=

> and it causes NR_*_LRU accounting errors. Note that the original folio
> is on LRU all the time and LRU counters are not modified and after the =
split
> the original folio size is decreased and the after-split folios need to=

> be added back to LRU to keep the LRU counters right. We will need to ad=
just
> LRU accounting for (!mapping || new_folio->index < end) if we decide to=

> not add them back to LRU.
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

