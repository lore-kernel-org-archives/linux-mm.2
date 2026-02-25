Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8D7F5544D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 03:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6629A6B0005; Tue, 24 Feb 2026 22:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6107B6B0088; Tue, 24 Feb 2026 22:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D346B008A; Tue, 24 Feb 2026 22:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 366D46B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:04:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5D19C1C65
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:04:25 +0000 (UTC)
X-FDA: 84481485690.22.A877AA1
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1AA640007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:04:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pte5sz46;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771988663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OasMk62sqyRNdg9CDR0jNBPwkj29/lkZbdMFtrm7dY=;
	b=1F59I6LmPpUnIxwnYR4gXpVz/xQrPf7aeFWnKd0hptw3MentrgEDNb07LR6h+loGN9FxYC
	iQ13wD/h5DSwM305mHJvQL+EVrKBlAC7mMuT7+zMZW+fFwMfobDocjWTe8Tp3BfECNVrYi
	a8Kd2+tRXImU+2LuZyDhxDcUbPd+NXM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pte5sz46;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771988663; a=rsa-sha256;
	cv=pass;
	b=Xd3Yydfrmdj8MGoHR78+6aK0kIFhzyQWXE5Pmlfgbq3LlnD017/23dPhEJLdIu21veyz1c
	PnWa+smj9MZ/k22fo65Vg1o6vHxxJZNB+QdkyKnkWqG8CStZqb8dkjRqsYeoKgJXujtpgu
	XULnliO9Bp5BklaoQTWNEtEuqCV8/3o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDORxmeH9t6teBFI98UU5/N05vfmRXfLH4uHT0KSfw4s/SxVOed6zcqayqhdPxDWRzUupvhDPi3dIRKxMuJ74j7hTF5C2XaiH6Vzx86+CNiERBJ+Y0d9epTlVZWjAQLblln34nm8YsAnn8a+SsMQG9nyOvHj1q2JGZQbxEZvIVQyBe4s8wKWF+8q6V+8fRfpQmdCEkpu5Y2cbkhUfg/FdzEHdmxHnyPIXD8TPalFt88KA8yJ15bD1ZDg8+WJxj8x5YV8+13nbMSsg5mkeZAKES0YwpJg6x9tbh8o5m9sw/6plvtLJhegjOdycAmzqxXbnKyeUfYo1LhBb++crMVHyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OasMk62sqyRNdg9CDR0jNBPwkj29/lkZbdMFtrm7dY=;
 b=ccxqrPni0yBlBgNQ01af0roDeil3rS0M2itA/yaVZyv2YbqgT/VxLeL4aqEjwcKp4s4mKw0goe0hwuxawjWwVYcmdObc4dnBbckbePUR4Qq+A5nNRplWgkk101B4rfxMd9Ih9x6Jtst0HjWES8dir2/I5MzIAQ5GIWaUTpD9c90NfxK9NEuUVAjkDQB2t698pXqHcyjFNzJUQSGrRCmK8GE9JaTNXBYG7nG83ApD46+zhsF9LJzKeMV1/uhWZnIQ0dRSc5Vhu6jmE2y/jTPXbqKQaqRxkBjZqEXCJbDA2pVwsoHJVg2iZTbcAP8yQLXZRBh+K+4lqF6AbQ9XBAMAig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OasMk62sqyRNdg9CDR0jNBPwkj29/lkZbdMFtrm7dY=;
 b=Pte5sz46uPTbxlSbgZcgvRRCX697BV+8JgWamK1r0KGhQpj/ZGiYnuD16MhpJA+ny5okATJVrL0qC+O0/t9sp0iOYa8Z1KXUlfiST2entRcNsKKjEWk+BlIF8PQvtMrL7zk9GJ8Zh+jSaP8fMIkRxMJB1RcQdRQRBq/9tTp7R4jfSey6eqid61RRstKawwmmOutzxpyx2v7TmGJE+b22JvB7t5HnBmxCEKvD0Pk0ujoDf5aUvCEqkhGaJJdDnoY/mO5+jp0CqMyvVQ1JZUsWCB3fh8L6KqTnf/hpk9cI811GH0fLJvILgNVkEBJ+W17Uoac+MtdRqSBzK7MANpqoww==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 EAYPR12MB999155.namprd12.prod.outlook.com (2603:10b6:303:2be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 03:04:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 03:04:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ron Economos <re@w6rz.net>
Subject: Re: [PATCH v2] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
Date: Tue, 24 Feb 2026 22:04:15 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7AAE3B00-627F-4F40-A383-7F5FDCBAC8F5@nvidia.com>
In-Reply-To: <20260225025440.63897-1-sj@kernel.org>
References: <20260225025440.63897-1-sj@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR22CA0007.namprd22.prod.outlook.com
 (2603:10b6:208:238::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|EAYPR12MB999155:EE_
X-MS-Office365-Filtering-Correlation-Id: dab899ac-2b5b-4295-48e6-08de741a90ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UMVCzlktYhF7juMbvaVj+JyHJkIbmgbkzMUOQx1LkGy3ZUHbMxXmMKr8UAzZ?=
 =?us-ascii?Q?jvVTu46PYFQp+GeUjnA91sRBMClMc1NNHqHXE1VolGjMshBl/yjWH7Zbg27W?=
 =?us-ascii?Q?nSnFlJaNTEXCe1I/gyZa1piOBOZKwoCmBJ5oH7gTeraNwi+t01UcN2rG7KPC?=
 =?us-ascii?Q?a6hFRA3wTmbjot0wPgFXuTDhgJOPi6MGDJNlA61Y+q9T6q98AVjeCj3EX+6E?=
 =?us-ascii?Q?r7ws3wfaU8z3GM+1VuHodIAkiqYuN2FAB5NTglrWd/IKkTP8M1MsOkE7ioRg?=
 =?us-ascii?Q?ctu0GENOo0mneKD3LA1gskbC25+JVdhmcOpureheofrh33HvU3SM+cUNzCfl?=
 =?us-ascii?Q?/luELS6Xhk1W3AJu1+vsJpPgdkdQrr069smVKvRlJfZc2JLynWr7U8ohulZ9?=
 =?us-ascii?Q?IHeXZ7v6/dfTI3qOBlJpTJCUBbnRaOcRruV3aGUAvBlRvcs9YoSWMdGWzAXu?=
 =?us-ascii?Q?VnOXBVJzfGNs/4FJHA68oj/wiq0AOtYuOHlNupVy8D6bAAB6N9MrdaboJrSN?=
 =?us-ascii?Q?9IJq9KRzTGj6DyRqmvJFV+1i678QszfV7SFjTVV2fELtqZUYPU6DXETB5kQf?=
 =?us-ascii?Q?P342hzIaiJ9urUgVvpx05+Wj9yxWeef0pQbsgwRMM7ghEBfY6kdl7LgTfv/k?=
 =?us-ascii?Q?9DrqpWFX+kBquP5Qv5YWV3JHDXoBQ4E3U1eBubrNTGfHelGtDxyTA7x24SRp?=
 =?us-ascii?Q?AWvIhtg9qqXwb/E1uOTYq/VqrD7TwsDKLYUT8dsdD2ouo12tD3YalV24Y/rW?=
 =?us-ascii?Q?Y57Dk+y/igC5dhcssNO89vXSfql3gA6sMaOKwEn4GzQOlRAzqoWRUxcvHmqA?=
 =?us-ascii?Q?01WINyT66HiQ4pnDKAt4etnH4kH50uP7JWiTdYpjDxbd2Y5a3VlYHXyBOpMr?=
 =?us-ascii?Q?VInartkc+5xUjZoIbpqEhO3wES8RV6LWLUndcBxFyGTxjpfL9ogBEIKLqV/p?=
 =?us-ascii?Q?ncY0oz/E41lhJWup6gdycWDj7SOqe4D4e+kDfLpfWl4hYRhRBPRLvBeveQGF?=
 =?us-ascii?Q?qCBZRMBl6lSxYj0LNby9w0zSdaFgl+bfXZPfJSlTlwSge/cu4+44x80wcYsb?=
 =?us-ascii?Q?sxx5lTuDfN0trGJKMbv3qizvftekxQSePgRoN0opksB3ZoOHXoyISQhcFxdk?=
 =?us-ascii?Q?vE+xRsOIHpJBqRbhbzkRLEai/Q8Du2nhbR++D88wz7UnILs6hBsKmkV7hK/j?=
 =?us-ascii?Q?rW8fCRGrOFRT118lWNBMTIO4pF/LnGEff1ChqbPZWGAKsnvsK3fGlUQ6gkOm?=
 =?us-ascii?Q?WMw1V7eMrWFErqONvM8O8hAOUoOa3Gu9QX3K1XF/W8i5EDXc4l5D2tJgIuNI?=
 =?us-ascii?Q?EbuASYomWL6IGYAGDnq3snupABpjlsgcmreESWzyCv/uifVktmI8RkPS630c?=
 =?us-ascii?Q?Ilobbcy+LrDFvB0/ePNQXlKaTcTMqrr731zbTgIrkd2/yt1j6Euf33aAEzVm?=
 =?us-ascii?Q?gTlkIUGgew+cG+FBdubnkJJia06fuwxFVgZfkQ91Wat0p1AjOXjzgN90+619?=
 =?us-ascii?Q?xyUSHP2XcT7O74a4Tvb+IqCTI3OVmRN78cinaY/GHMulsPDAi3Eh0BAOYeQU?=
 =?us-ascii?Q?aL6NkFECfNcVlKGwQ/A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jLUvPlg6uj6KTthpOTqwHPsNbOM6rFdTBhdmtipSdh6LToOhhv2lsklbwnoK?=
 =?us-ascii?Q?uJBNfpCv7EPQ8OCmgf1+3JzBusARqrhcEsZa3R3D9dohjuC/swJFuxCqT8Bs?=
 =?us-ascii?Q?mUwYm2S7cAHn391Aw7Bb8y51azliZFmZ9HLaC//zK4QKbEyRLhPOjyfYU2PJ?=
 =?us-ascii?Q?Fy8E47SQCRVChphiAjpUGbUWkybktVxu19jQyTFpMCsyeMhRidggaWWUWl0V?=
 =?us-ascii?Q?sgttMAaeXMq4e49GjGUyDAKtLYBdMMj0r2E+qBipBZC7cAEcWxH5oI24+q5f?=
 =?us-ascii?Q?vAuzhTj+rCTXMB/c+3Cb4oQ+8REDYyROXXUIuMlPkDBSyvpFhThVjjJxO7Ga?=
 =?us-ascii?Q?SVXGAXzQWJE8UOzSWb2xQioC3aJim/0UBHxr02Eym7lXptokHRWyo/SzFvbw?=
 =?us-ascii?Q?XTPwdllovTWZgq5DSGr8bMA0KxG5q921mP3ktHJ2ejL0dw0uSjBbFF7othE1?=
 =?us-ascii?Q?i6Uvs1xqEwpe7laBJQsqrEKqAPFpSk7S8jUoOdd+H6jfiBJdOZGC06aTXXqr?=
 =?us-ascii?Q?wvCKwS53zbC1rJjE7aeeGkm6vWbr7z4vbPfCC+rPJ3rlliMIbE1SIQu13DU0?=
 =?us-ascii?Q?17gt4eYnUhj21Gk9trLuD5tQ/pRndMPX7NvUj9U9YQEtcUItnWPqpLsQg57M?=
 =?us-ascii?Q?kw39INF897WQzI3VHy/Ju5Z5wsB5pELkOBTTYwkDiCJAQTSRhJSPoIXQyQjd?=
 =?us-ascii?Q?UBmyMlhajhsyGVxmQotNWcRfkTsRFtxNMbLCbqucODKfQ87TnY5NusIu4Edg?=
 =?us-ascii?Q?d/3ZS2vCsZM51Xg/5haF6F8pwuBcsAMUDQA/cwB2/xW7rDuZZijKWPRkAhUD?=
 =?us-ascii?Q?JB0A/dQdsGG3lExIFoE+RX94zzZnNVvmg49Yu+kgxHcknNOYU20iwHqTR0oN?=
 =?us-ascii?Q?pXtGkspp4I1MMlbvjaw9G7o1dpWqvzi8PwB1S7ylwlIw57WRVgiWXMwrF+n0?=
 =?us-ascii?Q?xKwxioBxT6KG4JWlol5zBEJT1ES4eP1j70Ry+k8nOWJkh9oV9H5OvQ7p8o/2?=
 =?us-ascii?Q?LgT/k/G2wiFkPTrOS+tEEvzlKQ0XtnLxV07tD/cPnExqznEeBHwoqzZDzMBE?=
 =?us-ascii?Q?Tj3aP4HQfsxGZmFl8v2Ii0oHzB6q0OupOOIa/VLFJTzZaR8+SLMYdXybi+bE?=
 =?us-ascii?Q?WUiMpxBwuJDcLekMAKinyg6wEwehfs3pNmpsdNTlvN2yrdazw3pTH33kPraz?=
 =?us-ascii?Q?OAESEhLXiEexhldap9OIr/uLLNTHNnKeuyQOMH7Y6EqevLsCab2SWHpOexCD?=
 =?us-ascii?Q?n2y+naBKr7gB4QT0QzwKcem4N/BBTULJvUw2mlijUIvJ2dx3QgM20O0VNAYC?=
 =?us-ascii?Q?HqLfDAGk4wVlQTwN+iJ2tqOyhX5LNdjhBXbUxqQbXTc4hccOIRVqb90lx+9O?=
 =?us-ascii?Q?ew+TCJaTXhZwY1mOiKNOFVvY4mmTe5pGW70fSSopRJhfQDe0hy2tRu8dScNa?=
 =?us-ascii?Q?/My5NQ1EscIZAFOtVva69b7UVFJAd59UrqDDESXf4ycWLPM2goh0Qh2TiGwg?=
 =?us-ascii?Q?rT01zdX0nwrP4w5Brh2EjpgKvP2Jy8t+cNMGwqtEkIQkXdozpOBJoKlo4VWQ?=
 =?us-ascii?Q?jsGjhK6tZpnFTWkTgQnvqztkMVfErapxBKexXkFoPElgJGCtxMNpCdOfKyzR?=
 =?us-ascii?Q?pGIl2h/3zGoh47nhCla58ucyEVlAQDodCiecfCHkx5Rl576ryMK+HSJcPvFz?=
 =?us-ascii?Q?LjDK+nA44MzxlThhJjIKHrn6YCx58XbTPS3fur4MKVFJ55B6ooHqGpVmq1tj?=
 =?us-ascii?Q?qv/6USCAng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab899ac-2b5b-4295-48e6-08de741a90ea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 03:04:18.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orNL6EXAlfCn2K9asFZTim8OL5VrY8BZ0ytCBbS/e+GmiZiVZkb+9bjK30TX0wma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999155
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1AA640007
X-Stat-Signature: ewc91ab9eo1asyc1eubxyh689yfbcm8o
X-Rspam-User: 
X-HE-Tag: 1771988662-916762
X-HE-Meta: U2FsdGVkX1/4UbjMLTwFtUvhJH25L1TRxaphleWs36HfMDRMVfB3ztx5JmZah6tnnYdQ+B+Hrbub1MPPrGgR248rQ7IuzaQk4Yn2yPJmGpIZAcFRwhd4Wr5DemrQUj7nieTmnYFKEXPlQNDh5XdCHKcJNNM2Mf4kaII/PlAFY5nF7d/N80khK++H8VDvtgvr9m0xLU4jkXJOEWT49Co3THDjXI5D6lb4pSukOQ3ZP409TwtVD5TNpyUHJ6D9YpDcVeumHWXQQ90E+K9eaktA5QyrZwGWAKt8ZJMH3Wsvf5EePYGRfL883TEAHhD7T/RsV5FtAwKmtv+z30Z9mgxUah9uD6YkLmaGXGX4J0kNv708eoltg0Qeqxo8FAQT0nbzI2ZMG5wTgMATqt376ZKNZ90NSoo/MgEnBE3ouYcwieahx0FpiRE7mlAg8jSt4rlpkf5edUvakru070fljL9VWZHXxwWacdbs7J1G9YsQ6J+wAsEjsCdv8CWEd9IKN/+pu8r3Ldj/aVIWNm5G+Qd/53Ure/5/eNx3mevr8KoYOqRj2vfKjmWzwWHe4EQt87pP2Mq0/cIhg8GEUpqSwfHc2OjHf7oHvSq7lHIU5s+oQtAtiGYbA7pumh+CnQpSlnMqAggpHfuPcWxRWjB/+O4dLS23RGlToPCpOkCiv8oqpwAFTaGvqNLy9m8Lz9fgH0rOHPYbh+ezzb7/Mqyx0fOpZ4t7GGn1RZwWYf6ZPSuQgyj0HQVuzOInYgQYjFU1o1WPpb2gzv1LhACznCif0byFORILQqhiyV2rq3D390/FO0dMAttWOSomgn5g457A/v/mfTUxB6IsVmNF9HAB0ZCu7NCZsNgxZI2CJ/4jUKUIxznyQGGtSagqt2eljZXz110gQH+Qv2BNsXQYlvbpP6I2hJL5IOdXi0+3kFMAqhLdT06mWmIpc4KsorP9xpGmpwSUJrbWfp/de8bmSRme2mo
 htLd6Mam
 QR6ijEDExJ/D2sCVhV2kpcJisneGbXrTU0GRvz7zLxcg6BIBrwS1vXchJ8KW4gRITG/QmbV6LTghm371RqYzi8Sji+qm+Ih7vYDWc1MOnIG7lRhzq+SrhRGmC9CyXbyoUrHCGN04XX1OEdJCVDjk9vsirt7RPbgEK8AR+ylMtyVD5/wIyjBYjQTXsRXAbWqHZC3KAyyOvFr/G0UiU5v7aQCnbPlODYGt8cvezBs/c8du13YoBneYhZzNHdGju+RpuaL1kkQf3g6WXzlVvgA0qD9x1q8tkfJu0myBR8xFHllvZDvVWgg36AvVT2k6pGnAimXBfoX0Pjd3s5uFi/dWlFFAbkGqG7BY2T0aFkBXvysNPPoI+SclURa8BgjvFMD//gdIKEzZ9nNgszUN5jLosEnmgZSF6pIppKsStwTwuC1+r5ttRPCY8aALo8S7hgstVSDW12pm67p/nls2l9kAZjt3QGrzE5R9sMK8UGgMKYL4SKq6V80zSBDTHatrJkCtDpmS3/+B7K8STLgXo41DV1M05zxcHALwSLQu8vM/gAxCdkDbZsXFJ8pSQ+SwdgclHmlpO0Sr9v02Li5jpRIQVntIqN5Qxi8+JT8XW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 21:54, SeongJae Park wrote:

> On Tue, 24 Feb 2026 21:28:52 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any stat=
ement
>> with side effect inside it is incorrect. Collect all put_page_testzero=
()
>> results and check the sum using WARN instead after the loop.
>>
>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>> Reported-by: Ron Economos <re@w6rz.net>
>> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada8=
85@w6rz.net/
>> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>> From V1:
>> - Collect all put_page_testzero() results and do a single WARN after t=
he
>>   loop.
>>
>>  mm/cma.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 94b5da468a7d..ea540d3f473c 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct p=
age *pages,
>>  		 unsigned long count)
>>  {
>>  	struct cma_memrange *cmr;
>> +	unsigned long ret =3D 0;
>>  	unsigned long i, pfn;
>>
>>  	cmr =3D find_cma_memrange(cma, pages, count);
>> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct p=
age *pages,
>>
>>  	pfn =3D page_to_pfn(pages);
>>  	for (i =3D 0; i < count; i++, pfn++)
>> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>> +		ret +=3D put_page_testzero(pfn_to_page(pfn));
>
> So, 'ret' will be incremented when put_page_testzero() returns 'true', =
right?
> Shouldn't 'ret' be inceremented only when put_page_testzero() returns '=
false'?

Good catch. Let me fix it. Thanks.

>
>> +
>> +	WARN(ret, "%lu pages are still in use!\n", ret);
>
> This will trigger the warning even if CONFIG_DEBUG_VM is unset.  I'm fi=
ne with
> the changed behavior, but I'm curious if that is the real intention of =
this
> revision.

It was in free_contig_range()[1], which was called by cma_release() befor=
e.

[1] https://elixir.bootlin.com/linux/v6.19/source/mm/page_alloc.c#L7238


--
Best Regards,
Yan, Zi

