Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC8ECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B4C8E001B; Wed, 17 Sep 2025 09:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBF38E0013; Wed, 17 Sep 2025 09:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C0E8E001B; Wed, 17 Sep 2025 09:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26C758E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:00:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAD6E119EC7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:00:01 +0000 (UTC)
X-FDA: 83898749802.23.2A4C84F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011015.outbound.protection.outlook.com [52.101.52.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id 001E580002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:59:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sPUPIOj5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXqiokgyAALlNMoiJJ0FZ1Sxcgo0g5pTLkiqnY5Xo4M=;
	b=7tZDi1jmD29rqwoS5yoQ7m8i9IXE3eUgIIMZOfoKf20oBFdnGlVWrUOR5VA2TfsL4rbrgu
	TmpDIwcQouis+ghMxFtdFHkeKasLSnVjPvosQxjlbzp3MgBTLioPZWTWzh8COyDPALPXDn
	giZbrRDV6SZ5s9UGNSD2mlYQfCK2Z9A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758113999; a=rsa-sha256;
	cv=pass;
	b=skqsAlbeF36k83Sj0Vw1jsO+i7UGEMtGmMHVpgnZmZYJ0XkMkFeb/MEaINOk4NyLgJB5f0
	gilMr4I3Bf+kmNvLL47bE/6pk5CDjoVVyhXXYcbMWqQ9RjrP/PP5FZJzFYLA3sgc3JzrW4
	MvXxwaCE0sUxu25ggm0lPvBDsCfyDKs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sPUPIOj5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OS25hzKPVDlR8ZXSC1Bozpb+OA1kVCnGfV7L/nQWzHtAq7pmOOebgpMYMvXq/VAiQJHddAbhsWO1HrbtCmh9nNMEHdcxGk/XrWnvBQs/BHKp0rKRH/kZroLKr4lKyVh0N3JicqQBQ7en+nPYH0+H2BPnrK3awbgupGFJohYZZyyHMt9aP/8btDRFTPeTcvc9hH2U08zPxoIcV7y5W1fJbaHW/bIA9QlMJ82ly3jRmUwDHd6HNvLtAOmP1yqHgSki7imtXy09lO8lgCLY3wnu8s1YqiyzSsmw9o+tMffS/uFF2GSZ0Q6BHZQ7vb/MqO/f8QZMfS8TncRS5bxt5TMEqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXqiokgyAALlNMoiJJ0FZ1Sxcgo0g5pTLkiqnY5Xo4M=;
 b=oTAsoKxB/kTGDebPCJ+VFjP6lch4ruwyvZ6QwmpxF0+E7ZumWbsHwldNshCBCDOfOS22An+N8J5kukoWY5s5RsfiOO0Cp4E2sViTeCNv7slq6X+wb4jbGPiq2KdIeVOi0IOV+yiGUhQw+RvigsGBEr7UqDcP/Pt/dA1al1ZSQB3aFnC6UR45ZpkyyGxeo702kJAdCSK5Xwu7XHwcRYN2Gz4yYJ0TE8mVUut3kRroSgpZ8oxXLOk7Hev+9mhJt6pDc6oGa3tWvvQgNoOSqB/Bcp27ZRGBipVxQfyVHAbPgu7DNSgUZ9pOYCbuk9N4LfTesGSRGjcWK9LA06V5Xa/g4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXqiokgyAALlNMoiJJ0FZ1Sxcgo0g5pTLkiqnY5Xo4M=;
 b=sPUPIOj5Di8hhgNMYh4zkRem0JxUywmWwbzhsIWFQCcDQYdYt+AjDMJogCZBO9b/e+x9Iu7U3JCewAJwOWFLmPV7ZaeoM5vUxPVQJJ5nDFwZrgT6uYNnABhmrm9KHr7GQR3fzHeHcKhEXRd2gC3LppPWaczON5cspX5727NyLQPiOv+5+fetYPVjWemf4QTcmCuQv3MtB9f2DXejJs+GMl+9C/Jcmkmbn1x05EK6ZMvPtfX8BDdxUoGaOrlxCAU68eYCWPtuSlftR10Cd/4XcTGGNKnmnnHNCIyii3mKv4S9G5LeL9kbun4YsJO6Ua0fNgJ447ymcloW60FhGegxbQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SJ2PR12MB8831.namprd12.prod.outlook.com (2603:10b6:a03:4d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 12:59:54 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 12:59:53 +0000
Date: Wed, 17 Sep 2025 09:59:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <20250917125951.GA1390993@nvidia.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
X-ClientProxiedBy: SA9PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:806:24::20) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SJ2PR12MB8831:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7700a8-e5ef-4d0a-79f4-08ddf5ea184e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J2ir5W5eq3eMIdFc6Pq0/Q92Jwr0Qho/hue3ea8a7L62/Jg5wRJtZhlE/5gs?=
 =?us-ascii?Q?gAw6v7KHgsj5w3Q7gtDy8KpiRt1z1BAQ6NFc3bXYA2L8pYo5F+TNKMJyPYaW?=
 =?us-ascii?Q?yodkpbKxVVJ0fNu6zWojaMv+7bpmFXhDMLHTgb96iIeYd68y1VH9EW9wtNlW?=
 =?us-ascii?Q?ALQqLKRACLbikjFbtNxMuXuXXA0zafsB6gekD1Rol+l4rT4qVlejPJfab8GB?=
 =?us-ascii?Q?HuvpbW3jdJXiGBvnzfLuG93DhdVJGAJc1902vTur6eoW4d7KlYAtXZuMqWfv?=
 =?us-ascii?Q?PqrsjpnGTy+UdrKyhF9P5dAgysjrt2cFtLIOu49t0awJWvwl4D0TvYbwL646?=
 =?us-ascii?Q?dhNKkuJ5p5gkCPVIs19v8Q7ZdYgZr+046bcaRXdsg4fkCBQoFXb7+r63agP3?=
 =?us-ascii?Q?RqVEuiQOprpFepwFF34HnQuquj4KOFEdI8vn876KhKkXXhU2O/p2FpNLIKpz?=
 =?us-ascii?Q?RtmOzKivbKXvoCAlTYESThjjlL0XZGXQYGMqpC9MhUblzGZOexeMS9wyJdBH?=
 =?us-ascii?Q?yHj70J5gzFcngxKd5dhh5qaDx2SqY5fF/XG/t8V+XFVQmjdGSioM8LGK84VA?=
 =?us-ascii?Q?WE02sEM08Lwk/zHZSpVmdZCZf8BVQUhGYiLoLvPT/g/KIgDQVCR8R0twVAMZ?=
 =?us-ascii?Q?hMDH3ypERuVQmPzTbd1eCUqkjhI9nKNTh7KkDI0nyXtpNHR9tRsGeYFyUO0F?=
 =?us-ascii?Q?QcJVRIwoFz0zmwTd5oOHsSldvuOC90frYj+bkC1yFxGiwV+zBl+YrvuS4DwC?=
 =?us-ascii?Q?DdNspcdE8ypby1DBvjsFAZ3ux7BYU7S6Tsqmt5W6ALiTG7SZ5t42JipEZVc0?=
 =?us-ascii?Q?VoqLVrIuCrOMCMRs+OrCJFZn+QgHdyNa7+IN9KabRQn2KZovR0sQm3F2XIF6?=
 =?us-ascii?Q?GOk7skdI3GZ1Fe/PN9Ol79gIIuTuq4hmSxGqBXyieT5PA6ZcHcgFy+BxpEzr?=
 =?us-ascii?Q?Y/YtOlI0iyzOcx1jOfsnE0bYBVXoaEQpmHgTANTmmLQfz6MxhiKwnIg7fmE0?=
 =?us-ascii?Q?fVyheQ/kBPnKsk9R3bju/Sv5UKbiqnpdHyQZXIItfS3pCt+4ubrUNFZIHNjZ?=
 =?us-ascii?Q?NN5reggxLZ86uXyqj/vU9igGneY+TdZY2kW0f1X/dvEOGsUe+f74Kmb6sh0w?=
 =?us-ascii?Q?tVlilscPfN09V4fCidP7c9E/DDhwRpH5Nmo1SYVreDWnWRHoOpEquEToFViH?=
 =?us-ascii?Q?L9sw/kw0kJy26WLXdbMVO8g3xhVrs6ZK8UkAuPbxMD05r5aztL2w7VGSBm5i?=
 =?us-ascii?Q?lHPNe6Pnxb/MSjW+HiDuhdWr3rZ8tEDO4PlU5VC2eWoq5tvnQXgfO8C633P8?=
 =?us-ascii?Q?dPosj/z8caqJHQlJutnnN3xVfycoOv1Su+Bws2h7hhW1+iy89ai8JoFgU/OP?=
 =?us-ascii?Q?jRpySfxQiFmuDn7hQ5B/PHbZgbP4EyNLF0f3yVTne6ghnZqSDtFCCPjdsEvt?=
 =?us-ascii?Q?AxAYZalZwoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JJmPgck2gMSqLcTSpoZSq2XAKiH51Y+khe1q0hFP1wfY1h/09RvkYBejbwBn?=
 =?us-ascii?Q?VFr7fu76JtdmSsFsws70wDhP6npIsKmfGR4fk2EX8JeKB+Zi5+A9nCPrvcNu?=
 =?us-ascii?Q?wNVYWQeJPsPnkUFLQeZkhpfDGezP8wCFa0cvrG4mj5X+FE08Jz3uiSy3Lwuj?=
 =?us-ascii?Q?iUBoi/LZkCnVHVKIKQISJTMJwnT4IwHtkPGigWMtAlnai0eA1BB1DXQUcNwL?=
 =?us-ascii?Q?4ztdJMBSyvepA5PtaU2f7Iue4G5FGZL0Pquso4MTo5CsQKGASfToFF11zXfI?=
 =?us-ascii?Q?LVaIWS83aaKcOS6xYXoVYoRGXm2IKnRdmTPZheSUOeUhDSl0glH/m8ppcLym?=
 =?us-ascii?Q?o/dMqfitUVUlHD2oAioh898i4xRJcvZK82Rfo85dgPl8FQySv/RTzC41y8Zj?=
 =?us-ascii?Q?Qbpi39ZXQw32zG2mDVZXcRcecajVtkKu7t9Fx1BeDjcji/PWcfR29yHa6oDa?=
 =?us-ascii?Q?vDhLKYEN8jSsP8ixtJlf5iIA6X+2GgKoD33rtuTUAuz8sgVFYb6xFu3AYtRZ?=
 =?us-ascii?Q?imS1HWt/ssSlzjBqWfcD9ylEZBa92NKVdCr/EtZCPnu73IhwW1Tl824JcXN1?=
 =?us-ascii?Q?LK4CCJy59GxLzeEQS30dxcTxAKtQEcljdhP8ZIbdNQaCxnPCaNWOXEeSTU0L?=
 =?us-ascii?Q?HG7qI5tktGNzpPE2w0NUELuFRIi0LgFH5nZe9of3Xe1llPADepMiJCSBvT37?=
 =?us-ascii?Q?37wVsxXqrSlxy4wKPiveMSZ92eOZ/9iQAAf2LILqcvNjtgf+ZIejmT+pQfop?=
 =?us-ascii?Q?z/QYmVRzT7oI9Pq7q7m84svzMq/hKQVk1islNHqFyyZOVePkWTWN7jDHEd+R?=
 =?us-ascii?Q?eNLLisa1S6oqTqO+luXLacHvhoIqC3lTsfSQ25dK7GzMTDvHpmJ1nyTlhy2H?=
 =?us-ascii?Q?V+Vk7fFWCOU6096IDcFiy2mec46RHU8IlFD162mevam9INBd2OI80d0kWNA7?=
 =?us-ascii?Q?sUv2P/sxmS0cE8f9Y21hx9B+fyE38UNKtv3ZVNM7THBuHCe2XMybERMiWxEu?=
 =?us-ascii?Q?wsS8kYq17iKtxZcNKwf/+j8cCU9wor/+zMq0Zlj1T75eLZbWIeAPnrAS1K3W?=
 =?us-ascii?Q?/Anbd3lW9k12oqcYomtp0ImSk8gj9LZCUtB96RyYm4c+QhLkM4sSGheQbpoV?=
 =?us-ascii?Q?TMKCc06ncbDco54szGeF0EBbTOMvhBeHAhOkgiJojG+qyZ2ey4dno6V8ksmG?=
 =?us-ascii?Q?pZv6rSo9Ln/ADTCzWZchLH2YMWMJcmg6FZqG2JUq6spt1/kxQBfhO/GCuWlH?=
 =?us-ascii?Q?r9ini5sndhbXtkIbcfVmOIrOC/E4D23a87K2sev8ExZrL2R6ch+iZGgQ7KvR?=
 =?us-ascii?Q?DkS1KOj8OccJ/pEf8u04oSEcM+VxzqLZ3y3GAAS726GEeJXGdqoYU4zuUWxz?=
 =?us-ascii?Q?FKwFznw3+PEph/BTh4c3jB/qxIaaX0cR+/UpSiyTFOBnOP9b7vZaYz4AmHtZ?=
 =?us-ascii?Q?Lu+JM1d7o8IEyxyJJB90euG+Sxe3IMoWmleQNMCfuGmr8bkItoAWe6W9s+1L?=
 =?us-ascii?Q?dDCONo+9U0LjnimYyEh07eMQN8o7QqQVhgON3HpYlROviJ2fFr98QNhaBDjc?=
 =?us-ascii?Q?l/84qijeJJzC/Eojk99UaNotlOQ3hRXifKshyST0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7700a8-e5ef-4d0a-79f4-08ddf5ea184e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 12:59:53.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2mI7nuHIPcH/lFYeI3aX4F9iLvSKh9cO5PfYkgmIq6PGrE4bwQrdjaQrV3tvbyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8831
X-Stat-Signature: zrno1aaqznexeys5wts8crq9jpkaeybd
X-Rspamd-Queue-Id: 001E580002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758113998-732129
X-HE-Meta: U2FsdGVkX19F5clOUuwrGJ0PnMsG2skIfS4rkiU3KUn1J/uJ04tEkYAZmI5DOTr9ugAAhghkusVobVaIFmLn+fRxqGy/F2irT2llX2ty+KqJXl7TAPcwOzMhsqafq9PSvJaIUWuoztJqzMnvTAED5Bl2/QrnWe/8PB5jr59Z9W726poHudEzrCLyTb30npTmwIbIKuY+xLzgTMDk/SoDfme/ZtsWbgAsO/016+WUDdrt+r1s50tMHzVHMYr6DkklEze5+/YvNyplIEcygaYOgFrLxT0wxssTJWrWCwvzGgBSTf5Lt5/wkSLtAxRK/uEkf+zsV1TvpL+1JMa29ABUtpXUEUoOWHe4I/M3ujcdVuDyHdX94qfAkZ5j8VNsuohRTjVAeFr0+tEDqUJzDiYFBG9yceV+IDItUNmftCTyIcah/v0RX1ESf0hr6fquyMNt2eryHbCrwmTrmR4XAjt7EAUSFUqdmdTMiStbVXx59fUvbZOXhYGFfv6RUXSTS9+ctFvJuS/8+blfl2mjB82WBG/K6tvWe0Ef6mM0PelBf1Xlhus+2GhUTl0JcCwFIsx6UO1jVRtxWrSy0FzS/tMEEJbQN8CBOa6IDGaHplCOy1eIBPTeaiHiT/Hfs8TzAvm585yEAg7CGWw3H0vPJMbKcljXHKMzPz1rg+Zb99Do7K7MfmEU8PABDda2UzZ17Kjyb7lnOqoy6e/rtbL8wL1td7fB9RDnUB/1XWQJc1/BY0KadFun6Qx0mEZKyl/XP+t9cETonCuXSapCv70EU8QhZi1H/YLt9/MGRhU9AY2Hkzh1kntYxleyiAnJxNjpQldYvkXkqwuJO5DX4sPIbFzbKVaaSyPAFGyiCZgNfhs8auVFSwbirex7jfglTK2na9XlollzqKqdeFtYbvwkg5Os+vwQbYlIL4cA/MiYS64K+WBQp9Fjg0pVQUdTcHI2wNuWPUXwDlSZWR2tUljS6tC
 Az1Zgw+O
 WTEit2V85Afdg3ubAzPMsVa+bgZnlXxSlUUCk5wNm7OU8Gl188JmFwSFLHcuKO40JGy/uhGRn63GxhxmF/UwmTto3qGojB6+d2v0V0IL6/XEmfL352mBll6zu4NtSTVj053+MEqwlilB85z8c/15HiE7dYsSsn/s1lAa729d27kY/mhrklumyJalpX22ywjgyUuw9qgtE6gNlQIrw/f16xpx5LJbfTODSQf/F2w6CVIDnOq47umEW3ozTqHsu0T7YAXpk7PwNSLat20UHsWkjvaA5H36Mg6hhBY0Er2OXEuieeid8yoSkHuLp8N7vq6efiaNA13ylRQkPhxNtI7gx2lt1WKfHCgpO1BFdtOuHLd+4oSXHfBwbW8cC3HJFqbHs1m4L1TRfLDyoclyiRgoszCMrBgJ7rvSo8eWzVKO0ATKP43G0QsaO/yFZlRLTb2+6+GpI7Eu5SbTrTHkc4AZLL7y8/ONt7NIBuuICtw20Q0inT7HKHoRZnGHNsqrfXk5hhNO4iG2VK7HxvrTBPfx3UJ6Nzup0Fh8Y1g/95lt67xrz4jqlPvWLNTwNY3YG6pEQaTdCMEmU/FY0qukRTxpI6CVLoduV3VtQ/JqMRCGTEk8JURXqZODl3LwLqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:

> I'm still collecting information about which of the remaining highmem
> users plan to keep updating their kernels and for what reason. 

On this topic of removing some parts of highmem, can we say goodbye to
kmap_high_get()? Only ARM uses it and only for
!cache_is_vipt_nonaliasing() systems.

Maybe if so then HASHED_PAGE_VIRTUAL can go too?

Jason

