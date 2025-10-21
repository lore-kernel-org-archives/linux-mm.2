Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08614CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDB98E0016; Tue, 21 Oct 2025 11:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B53E8E0002; Tue, 21 Oct 2025 11:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4208E0016; Tue, 21 Oct 2025 11:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35ACE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:36:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D465C11A799
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:36:35 +0000 (UTC)
X-FDA: 84022523550.03.1A8A330
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	by imf29.hostedemail.com (Postfix) with ESMTP id 24DE2120005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:36:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EHAST1JH;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761060993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miZSO1pq9rnbqFoPyGAxm37vRNEaI5tWT9057Kzk4UQ=;
	b=DHWIcorJz6l9HxQRPpLg4oUCvco1h3JIdJClJHC22LWpyIVVfs4aVxJJe7O08Sx8AtPqnY
	j1Pr+ENwi7/jyK2Ohbnn/5DCHT+yn7a4SV0L0lMZjX9zNrX2BuxyigeILyUns2fTxRqp9E
	gW50O2rnXOCXkxEKoca8zmbmE8mnSJY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EHAST1JH;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761060993; a=rsa-sha256;
	cv=pass;
	b=m3R8sL3YIeWZ+9aUSb+jGYEyfkPk6OldLvs4g0YtKFnMmIsUXrdK8cJl0lY4cM308Ter+p
	BrdWE6YFddoEsXdN8/yYhd8/3dtV9S19F/lqRFuOedJlmK0x/Wq95QAiyKc/NMepw8bohA
	Ebf3ADJUiwwXZQAgEIVsSaKod1Uceso=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqujqZ6ZO+RSFdr04cBtKioznspqvt5cnbu6aYETj688HJPI+/URworWdt4+/TVfHjiXlZ8S9Z6wAxpo2npTuFqWiLTNDb3qKZ+TfqwiceNS9omJHQH8DK9XLF3ynrevRReelANVL0aWDejOhcQSGCXV1KW0DkA6lxHyCLh/4e1oS2HCMh25nz7OuFgHLcj3L1Mx3LtHWfjHmWTVLUqOMNq2AjuQqTWuzPMezYmZYEjTvE1hAKV84OZupqfxfbzvu/KcSPEoXu/N7rWAl7FSHudCjYNs13FmIH4D/tv1UJPGjo8ZjHsX8TPXPdLK1oZNR2kzYEjeSzRXxK2oWurCcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miZSO1pq9rnbqFoPyGAxm37vRNEaI5tWT9057Kzk4UQ=;
 b=buS1mXZwX1RkzObIisEYBeKq3v9O0TN4zgdUWhlzk8rW4Jgd45WvRan45ghz43OPVTbML0NpPPYxZl0hAcX2qauNb5t39xleaOhFATupMbTqYF69PNByN5QFkCrFzqW6iEb+CKEoW36SunyJ+w1WafzPfUqY6WMvZp80U2jStKvqEiV3JebKOrTsVhcP5FUtskEHKDcYgevdfLCplSHPezSIhq3vswqvYqXh8vn7ChKWWxCl2eM2gTvyb8WOHMUuJjRPpNf5f0LrOXIYVVXXxiHQUDWSUKVA87S2WrpotrChVBHqZa0+dVCGp8hZpDFlgs9TJGXI/g2QMTHrRwqG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miZSO1pq9rnbqFoPyGAxm37vRNEaI5tWT9057Kzk4UQ=;
 b=EHAST1JHTvfO5dhO/KmQuVRXZZyTzw6CBZLxK1oLv6r4vMrSHsiNERCYKiRVc/Xc3WjB07IDfFP5VWhgkuBjzDRbtUeP7/VbFWUQcGCX/LM7vR/sGrxTWa0ZewyY5JnXWew6OUyIgFY7MbmRK+Fsarc4KqRb93sYCE4q5AbEmafu21UXiTUy8NVSu8IxYlqRrbm8NfGhurFF1bzh2aTug2X0dl4hiaSZdxHIYo3HlkbhzzRBZ5eTI69LwApgrIxJPxUuMCTUP08r3GtJMCqD4I921y//hZgNZ75ifFhe8zlWKZhfEn3YRPLkKJjohsR1OBUyuQhK5Pgyn81bnblxQA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.20; Tue, 21 Oct 2025 15:36:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 15:36:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Subject: Re: [PATCH v1 14/23] mm/balloon_compaction: move internal helpers to
 memory_compaction.c
Date: Tue, 21 Oct 2025 11:36:25 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C2893E27-CA03-4416-9444-62929A740691@nvidia.com>
In-Reply-To: <20251021125929.377194-15-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-15-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0306.namprd03.prod.outlook.com
 (2603:10b6:408:112::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 84650a8d-4328-4c38-b392-08de10b79a94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GXtj1r2DlTSD8reiRnkjCLz6c0DN7CHYiBtd3XWbcVixAjvWZkEwZ2OJz8og?=
 =?us-ascii?Q?VB2GcUHXhNG62IpdkFc9P4sCm9BVR4+erdZHC8kOD73dlUp/RWDUyRC08aJw?=
 =?us-ascii?Q?I43+ebRBH7goJxtScTv62d9N6Z2wcmY0V1owup8BgDgtpiwGJSXJJIwXEEqH?=
 =?us-ascii?Q?gV0awOYoLW9/pIDq3Or16t6oMoLO/wwbNzS3/Chp6YuLZeaTe4/qrno7BDkf?=
 =?us-ascii?Q?pKmv60YzSLHy/FQnkPWDHBAMO26aXcvzYS1e/74EupTBmTQGKzqRD3iPlViE?=
 =?us-ascii?Q?PGUakkMJuevDukAHVISJn0j+14N5T3xw7mwti4ZOY7C13c/KMMz7m59FeXgM?=
 =?us-ascii?Q?exufDjcmOVdneTgSNfmfzzyix+kpiqTYCZNYIOPcEx0Rr1asU7yoXA7JI1wT?=
 =?us-ascii?Q?2ojKoDinEyd62SYMJqHQrZUV/pfXEQO7a8zV3Cl75rO+ZUc4eerfB2ZLDS+Y?=
 =?us-ascii?Q?63o972QIbdqfClaqqF23qUHLBzhio9R8zuYnTbzFvqwnh9ZB+NnF2cGNdYUN?=
 =?us-ascii?Q?rEdAhoJaSP5mRPi9heCz9bpGlONuzPdoVno9Ew1xmwmFoImgCLrMso1MsjZ0?=
 =?us-ascii?Q?+17hC5koH1G0/mWmb7VcGAT7DWTuwyPFvuJmefiRH9xo0vta7V3g78dGvFae?=
 =?us-ascii?Q?alPpON1fDliZtEmq+cxdw9k0w2LbX+5Flx4sCfY22dTrQEDthHxORphfMp19?=
 =?us-ascii?Q?kbhdLiosozh1otxZOFxp+gI5tMrHoEp1ZOfUPyWVlVWahgShd3Tb4/hH4FRM?=
 =?us-ascii?Q?PuA7AUFZPqPwZvCm3TC1QdepiqUiSA+gfFnTgU061I3Zvoc+c4lQAoKhSbL0?=
 =?us-ascii?Q?jIj51lFoAqSIUazePK0NLawfyRkzn/kD5/HOs0qpfQ38UVG0DozKjR7cBWUo?=
 =?us-ascii?Q?3f1rNdNrnGg0D5vyo8xl8Tt74+ZiANrxcr9AFXOhuM3tqeLLdPVLK6/bZiyT?=
 =?us-ascii?Q?VjbXm+bze7WX1y1QadxqY/glyyIr1VOeTNztDkfhzt8tSPGi/gh891vtVV7x?=
 =?us-ascii?Q?o3WzGI6WkaY1fY13kFVDIP29svUnCEpqLrj9YqC//heG0TH1dJqMe1WtQU+n?=
 =?us-ascii?Q?8k9XDXs+mDa6NXKSpYuux7F8ncjZivWoCUWa+VZz+5nSND+g7DFZ3VEIdrpl?=
 =?us-ascii?Q?z3N8RcvjLG16KkBOuAt4Svlbrtle+PCx17Me7VbWdlwdU1Z3dWtJ8RwGt6GQ?=
 =?us-ascii?Q?48sZEOSh6oZqRWp05uesxw3K3bLRJkWqarHxR8pWUkMx1zE4WujFPcp1rLeM?=
 =?us-ascii?Q?TGwZPEVOl+z8l9E73Ydr9jEyYLiHEmfH0TE8ORiEOYvjlqH1IsBiHZqXh8XO?=
 =?us-ascii?Q?wBRRTLeORogxuM2nTqZ6oOUc4eoXS3lNkk5yPYNe+x3Rn6flAXm8Fnvei444?=
 =?us-ascii?Q?EKZaEbJ6XY9815imO622kubXF8i4YwhChG6kzogYcUQ6D5VMp2xcc0IraLsv?=
 =?us-ascii?Q?6lZjVbx4tFMD8Icd/PoF/kaBcped4j8J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9NKWvsVuXyerwB2upz0/iqw1784oLGiXc/czxEqu27Kt//+fUEq6H6gVer5a?=
 =?us-ascii?Q?UT6Efq050oSaxZxICrH0Cin6GzxgBqjy9uR0yyvfs5NED2LOvctlPOPi1crk?=
 =?us-ascii?Q?VBg/9MOgjrnm6VsWjW/yrCYyuScKDtAtH4N56v3u4VJX3envqhH2WGUauJlB?=
 =?us-ascii?Q?ZvVj+Q0HM6Ne3pE5JkEsNQcGKaSC8dJdxnU4kwEnLFiy2iMJEWH+nfZKWoTM?=
 =?us-ascii?Q?ZFOtjOVlgcjGS5eCw9mBci1bwE0MCR3FXlMx7jNB4H8GXiZAH2ygsr55h+2j?=
 =?us-ascii?Q?r3c2aYFHtw6URE7HJpBdmrz8/V+HCksv7gOZflkZMiUQA9oRwArOY04XbqzA?=
 =?us-ascii?Q?jAMa+F9xxqi7eyX+SVgi60DfdyE8OR3TUYgHkJ1yTtIQFVj1QJBD2NTzrWIh?=
 =?us-ascii?Q?1ZUtzY2cG5NL4V3ZZnOmvfxxJTdUtjkEr9LuLJd2PtB9Ma6uEv1VD0ixjAL6?=
 =?us-ascii?Q?xhR6yRDQXxA/G+wJdBlXb/jrWHQqROdmzc4TlX76YQagTPIA4OSVFP4BWzYp?=
 =?us-ascii?Q?YKP63SyNEYwvl+mc7JzoBq4zesFTTPTT+XA5+aCNftuvJghs7zQPRJJHz6B+?=
 =?us-ascii?Q?Hn/sjSuF1yCVpiM78ED0bURXmutlRyNfJdbYN2xK75+hLwPL8h+S5FrDG6vV?=
 =?us-ascii?Q?xhyr1b43KIxP8jadgc//yt76ClhqNeua+sKVLVEqpmvV0BKqHQnh+v9esbFd?=
 =?us-ascii?Q?izg2bgOaiH7eFqO/EnNhbrpFdSLQ6gz0PKEiZ2biVjTpsTTviMKkmY9G8ZAy?=
 =?us-ascii?Q?ojP4bsBiNhdyvgzkdZlqt5gPDb2d7fhZYuWzLAq4k9qE5iLimukoXyUCDV00?=
 =?us-ascii?Q?8keu/WD/HlgqyBbv3EBB4xQaGWYtgC6b+JAcxsafazYHQc3yJXe4Pjxi1iJi?=
 =?us-ascii?Q?sBjFzv8GIYYCiwAfMZXH7zFZ4yJ4BH0KOCOuQNeCRrQSRS9sSfCzCAwZ5iQs?=
 =?us-ascii?Q?J6C/GNti4yUPGE7ZIZsTKGGsslJA3NUxHorSFRLUG0oWgv8SkIFxsktY6D4l?=
 =?us-ascii?Q?CQgkpEUpg0d7EkHdIT0gWWNIIsNQaS40/YhnyLXUIpqNiEG1wGp1N5AHmFVS?=
 =?us-ascii?Q?e10Cf6Z1FMtL/iMtiselx4OdMr+zCzhm2hCC9AlAwOj42+dTbLX+/48v8Pl4?=
 =?us-ascii?Q?fmofuzrZhdgAduh68D1pgdwgXMQWCL0hfj7WbRhOKI8+LxYz5fXmpCHYlyO0?=
 =?us-ascii?Q?E9XGQXPxer8g45DA1H4SIKm5wo+t5cj4hrvBOeby8QYnRuHvDY9kplwuP381?=
 =?us-ascii?Q?S5wA1+APzygfBxidl1BBtTCb4vHyftIzhFuTbKz27gLuTKe60qtsIyR4iXyJ?=
 =?us-ascii?Q?/WO+FXkulOuZbnlGOZYTFq0u4vxjwfv/cwRhwSOfQzAJuRSSzj4rO5WYvYVZ?=
 =?us-ascii?Q?LUkDDPL7jYtW7gwlOXmUhpY+VYK3mBshR0OQbkd6Kme2KHnksKi5jwj+NFaR?=
 =?us-ascii?Q?iJGHxafMacKHpb8M/tp0Jp7lLnvlKjOP6GdJkXVvndfUH1ruVRBGGEUNjBLI?=
 =?us-ascii?Q?2jMEAt/I91swi3Gf0USILepRxTntloWjFrKoiZtaHrX3NUrwzZ55RuwenNAq?=
 =?us-ascii?Q?lGrXEFMPAfCuk69PVfUSfyEnBAEgfn8iXEYziOCw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84650a8d-4328-4c38-b392-08de10b79a94
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 15:36:29.3557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lw3V2k0ClQNlhw4iBFFzpTx4MDC3sF8AvxPavJOd1DZqLFOWPhzxNMyP7h0SxFxK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422
X-Stat-Signature: h1aphxbsg3zakuatsspwgd4g6necnpjf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24DE2120005
X-HE-Tag: 1761060992-978039
X-HE-Meta: U2FsdGVkX1+U0Moq28Jtw3K3iF6eZiI8kCZwP1Nas3Nm+PtYrJuzCtrY9vFDF/MfIXIERvZIBd2rIfibw+5j9OLxXGKA9oB7PvCYV141G/ndSIS7j/GEW1wGDJ2p1LHwyovfF6o3YhWNNCMnQnHhzZM2pBZFim9ik7v96s6JqXQBNOzeFjIhoz6BULKyVLSWc7jGRlbvAJaQnyhvasKAOkCtsj1bzBPPC2dmIeUUM8LVep4RoIq3OVbY8+Lmad7WdIW8uEFr9yt6MpN0bgCFwJ993AYnbkyv7pzWMBlOvmTVaNUzHVg7qIbdBYNgErh7fKeSvZof2EOM+UDru/V6pxidE0jGH92UiO7GrifsF9gEmch4gFnAKLXH4yEvkHX/Foxf+mfq0/QowXHkWvSQKsyFl5dMwK06jb294yyZufZTMla9BqOd8kVoqwS53CWJ5OhgvtjEn1r3/XQFM+M7w53Ho7VBdjZmvOJJg3z5xG2Wj++GSzj26KRchKKh+BNsnJOrAhXC07cJ5yzDFC2AycHbDJ5saN7SN3hCziPx7uYjfCilwzIhvO8ld6LCzDp5Ib/z00EHy+sWWuqO2llbe1zpQSzqqMB++WON5fWkNB7B7tMAeKCbNZmoh1oNy3C5IjQG1IKNhu9TyLuzooS1vbRjGvwakFC2py7Dg4qtxIjP/GlO2nSp3aa2CkCua95TiLuK5w8vMKc3MAfkHTuuHgt6TVW4pQZUuFPQW3oowIJlZl1dqEU2aeE0u88vF2QX8k1J+Jj44wBPWPudTVWMkdWZLsFn8H93OpEqqkjPb3M1qHt3cArprACm9+qYflPGCCqut0tWvtPlwNBgTpqF/MeIBF8RuHrp1btyV50QYMD6HLoQ6ox6mo9CWmI3CUdCe4nj/RiguJq3O02otkHuMGwwWgKZ9+S9nIFzJMGCRQ56WU9AGkgiB++lFN6Tr69PPtXf/8szlLlqqVhYe4A
 0wZtod+R
 UqN8EvDmL7dN9m/1PlRfjaIzO8SA2yBniZ3FGjehALH+lPr7JOb0GT3jXtESb8rokkc8hd42Mkgve74k3TShPGwaTrMbmDyFV/y1gJYsJ/H9Szp5ZNsR1ViLD0Kel6vbY0ykOQ+Im9D8TL1d5JFfs+s6PVRcxAjUnVZZPysc7712UT1AroVzjC35YQDnNwH0yZP8aSoQO2VaOcL53T2zcx5drCZFtSbha02IPgleU7yRTyRFcZYama/jNW8kMlIC4jltkPVLr7qLOloJeFI2Trm2D6dGVH+LbICWG0JSjV95ajUXUoNdOMZLvv5vMOpkNPm2QYqTZGnl+5V4RemFOKAKw/p1XR19wayaJ9pxSxNLCc6zQF9+AZxjJ9WLTzPJc2lHgCL47JsEn2MI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Oct 2025, at 8:59, David Hildenbrand wrote:

> Let's move the helpers that are not required by drivers anymore.
>
> While at it, drop the doc of balloon_page_device() as it is trivial.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/balloon_compaction.h | 44 ------------------------------
>  mm/balloon_compaction.c            | 38 ++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 44 deletions(-)
>

In the email subject, s/memory_compaction/balloon_compaction/

--
Best Regards,
Yan, Zi

