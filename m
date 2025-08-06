Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF165C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C078E000B; Wed,  6 Aug 2025 12:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD238E0003; Wed,  6 Aug 2025 12:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5953E8E000B; Wed,  6 Aug 2025 12:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4722B8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:26:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E505BB9BDA
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:26:28 +0000 (UTC)
X-FDA: 83746860456.16.8ECCE96
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C59B100005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:26:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ursc7H1b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w8YyMCrK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754497585; a=rsa-sha256;
	cv=pass;
	b=KzP00MI+GwFaKNbm8Ngy2YCOtG8ExnX07xaqFXAxG2ap3Yy9/lQmeSVMUHyNkWPumwRVnw
	lMY7Om+mARa90exNfafNcMSKzEzLDC9xHtlXDKixCRcWHUPcG3BKt4NeV9Swlso90DI/I6
	dlAqoDzHEHpJNWukVGN4AcD/QZPl3BA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ursc7H1b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w8YyMCrK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB3DRRvq0WYZw6RJtnoaMTnJWrzV8Qu4Aq0zOTZ6kOQ=;
	b=599wHfJP+DOj6Y4YSBPx5FXDJ71Jtt1d+bHRSUc+2AK8IhizFmFtaEOMZL2Vs6ajWmio6n
	/MSPahe6qf8KHdm4iKsPVQSbe2Z6lk8NVDkgh0Rvlt0sAJQxaOd4qi6jJIrZarAEU40m5p
	bN6UsB/8RjNCIHeQu+UYEZi8m8QreeY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576CRSrZ011407;
	Wed, 6 Aug 2025 16:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CB3DRRvq0WYZw6RJtn
	oaMTnJWrzV8Qu4Aq0zOTZ6kOQ=; b=Ursc7H1byGH+6UYGqJriN532vkdX0cs6vE
	h1RokeWATIB7YYD0sf/oE6FK8iP5kTkn8WpfmXA8f71NVqVTCZzdI10eB9uBCcTu
	yORC5P4lyTKuFZxoN68i+rn2zl0pC9YBAIrqfQc3tSp1eHRP4L1ADuqznRLln+Qr
	agypTUHpbMK952Vt0ZiBS0mj8DtRBUwFjR26m6iUwqmAr5WOooRljiQqAp9RoC4C
	bXBo9J3xEJ2cROSHb/yD76lFUBuhjKQLGG5iGPhPdp8/MZqJ1L2B5n21RiEitQOG
	VXxj8r+/VTtaO43Ub8ddgNnYKd00zG6m7XtVAxb9gP/ZwLiL59rg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd25ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:26:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576Fme2k032091;
	Wed, 6 Aug 2025 16:26:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqrvv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:26:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jm3yXXI8pRkW02GF1I1PHhSCkWtYit9iRPAKGNek8/25ETd5ECtvQlq2dWjLWTE6DJuWZkXMtSc6qTgEh//tv0ffs9vhRkjYYgJQDAZEk173Jhm9y544wekWc4SnfZ4aQ+D1MObOxid4biC423RfEiA9kKJceRnwpa0S5ffBWUlTE220WRZdAFwvKdTBhnwMJ+gb6d7VH5HYAaF6ORC2KVYw9ASh1jddNfoC3TvpGMIh7Y7HNuTG3qDZzDc+RD/BcQLlpusVF26MhziNqso9shB2LLBjcdHB0zsc+IsK3o41wELaDDcH9CLs8wKu26pfqrIrI4LEPhod2tOX0EHmWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CB3DRRvq0WYZw6RJtnoaMTnJWrzV8Qu4Aq0zOTZ6kOQ=;
 b=DsZYocZEqTTj5Qmu8WV6+smRFmRAMIvJ5+hMDLKkv5vVPXMi4N7qFKWryVDEbEf1w/xdNluvVv1iAEz7G7vNV1guvG3t3ZiPi7pQtLXMuJqNMI4+bml2rD5cxSaGwJmxofDUUe/qSu4Amc3mK2cWanQErX97FmxbkeQ94I2S494h19WsHLEYMdzYxvVevPWNtzIf2LZav9toEvjeNKDZLiaVclb6IGrLqOpoVDQ26rkj7jMZhLlzs5wL8IyX5Y3Hp2z7hZpKVH2uLVXa3qPW3tsERotrFEXMYR9FRcv9whxVLAZQvAj1MBAAXjH2BGG4lSkL+Nv07taoaOS7KymErw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CB3DRRvq0WYZw6RJtnoaMTnJWrzV8Qu4Aq0zOTZ6kOQ=;
 b=w8YyMCrK2X4ZzDgHok7zCejACAPafyyl4DUTYOYV1N8MvFIeWqWsalw//hfjW3LVm/Tssy3jnhQIg5QYW0GRFXpEch5GVnmKJGTGbLpVBPiuaVt1Rrnchq1uGWLKm5gAbKpHs+jViHXvF+nbimPQ7ljflDfk3aPqZRw3rU1unDY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4624.namprd10.prod.outlook.com (2603:10b6:a03:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 16:26:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 16:26:14 +0000
Date: Wed, 6 Aug 2025 17:26:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, ryabinin.a.a@gmail.com,
        glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806052231.619715-1-sj@kernel.org>
X-ClientProxiedBy: AM0PR06CA0141.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::46) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4624:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f3a36c4-782c-4c91-a0f5-08ddd505f6a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tBge5PpSW92p11d25Yb4+Imhp4LA3PtVxoaFNpEuubKaHv0hY+zKC1HphCJs?=
 =?us-ascii?Q?4i1cN1oCoPpS2NTe5ie7dzVSB2zNia+IxjmM9xWAWFuefbpPYJmIhGnZrkO/?=
 =?us-ascii?Q?V78VzH3NmlkJhaGJtXHlnlKZiTKrXk2/SF4Qpf1cIIusSrfd4kle8n1BEnJa?=
 =?us-ascii?Q?+5j7nDp7EbLF0kMt84o3VkyuubCVAEZbcJLOoEimpRhCLPkz5im0A6+BhslR?=
 =?us-ascii?Q?tMLjUmfxo9P86KG5zBdW1roLe+DO8Xkg5f5YjGQo70pW0e7Sk57HNU4or54L?=
 =?us-ascii?Q?FHJGwCwI1SdabTtjsjpNAK7mZjQLOR+oAyrcutYsLJhwPL6YhBrvCIgRldIv?=
 =?us-ascii?Q?l4kv3eyJEuzGQOrmee/F3ZZn56mQNc9bwCUo3GCEqpUrCt69va+rFdVoaSDs?=
 =?us-ascii?Q?52MFFuBepyP83vTZNJvZbiu5CghbZ7JIMmlmju0Inct+CRw9QH/SOgU0DzyS?=
 =?us-ascii?Q?Fwg7GtfUV/i4UlN2iusftzp5ADIHLTpia1lb64hTgHk1tT10hbt486hW9+td?=
 =?us-ascii?Q?/VIiTbDof/2whAICjVcvY6JQg6yLl+fMYoPDKP3WkIfszeiOzc39/uqv2ZG4?=
 =?us-ascii?Q?5waqM9ertUxnTI1Q+MflsLQRokptWucpbicWNMLTZ6+PSZJdmfcqllndigQb?=
 =?us-ascii?Q?gSbTqlPQ8VK9hbNfqvYmltBgW5vavnotuQo57S/SVKk/y2aGUJmHrP6x84EW?=
 =?us-ascii?Q?gKP0Eh2Olvi6jMvybbGCSwzaYNCsDGiPsxc/FV7+PJZYMm30IZE+ReGmhaPl?=
 =?us-ascii?Q?32syR79oJwTrqJaDmNOQihs7ciWMJj+KhrxnEzBdg9hTvzC8IJPuaC9XdmPl?=
 =?us-ascii?Q?Xb+55cpYPdMVovnTiMDnLbBLYKFloBanFF8rEnBGfFcDvzWruMrDqI7XLW9P?=
 =?us-ascii?Q?mkGsMD65J8pSHjlw7WA75VtOrg0L2vZ1bDFrUbrbM/BwkZR4z73SKGL0wtY4?=
 =?us-ascii?Q?KBUfX0UaNtRyOsnr7IPdSlVvwBuaExH9Tm99lECMgB9mPoVc8biz+fn2Jy5W?=
 =?us-ascii?Q?/w2T2tsLupq26vFl+MIu5+0Wtmk023vANW3bCE0VDPZjqR/2aG0V63K0ybgp?=
 =?us-ascii?Q?D0A3fKyBREBLV47kaALlcTkNWIhWq3ZbgEf6veUZcysge4HMvo00/+pllokm?=
 =?us-ascii?Q?x0LOgDfB3+dJK3G6XhNgS+drcpgYdrap/lWkwSnv1xqMX2UbZcVtcS+HKV/+?=
 =?us-ascii?Q?HpzJYBkeURs4KJnYtkeKAOnyOxEtmBELry4oAs9FRUdLqsaw0gz8wd+YJPh1?=
 =?us-ascii?Q?ac35pByUXRDGTBt3HsyeXiyIBNznYQ9MsKIkSKlFzRUmvEubCUKq2bAxhujv?=
 =?us-ascii?Q?s20J3jC6HOKMcEu8FgGFyVVo3GNSgCUS6uWpDpwedKFyuqW9tyx69p5WxCiI?=
 =?us-ascii?Q?yI/+pwI0P2UwZ7femN8Hbmo6I+L/qVX4k2QLm5Dwg3bKXtKq/ruT4YDXPK8M?=
 =?us-ascii?Q?o0GTChYREWQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Id95/rEslsCdoAIYt3yuSGpnAV0MgVNzERhIJnorfUnfzfDztalU+nREsRr6?=
 =?us-ascii?Q?djibZl3+OhIK6qUuBpgoGN9yT0CHymjcwLeagdOjwbLpLWNkEKrmf1dXKhVX?=
 =?us-ascii?Q?WyiSXmrEtXXGgjkerEtCiZNdostzQAJdAbH2H18yE27YtdUflCM1yA1CmOSV?=
 =?us-ascii?Q?21xWtmnhW63hrL1FDmgsgBfnBJshYz1Jk8FdEcKw0jUqrhhecPUzbMkevqN3?=
 =?us-ascii?Q?lFVTyWa2HcX4RG3sRNWoIFPtwqrDwt5Vb5dUnsLM0BM61tklC6zvPpf6mA7l?=
 =?us-ascii?Q?8urHAiAoSIzssTDVIn2zdP8LVg0oszwXsYTLTg4XOqW7CTRWUgUSzBNWF35G?=
 =?us-ascii?Q?Lbz28KLYKCsqEvzZocZUl0ZP+bf5E7ICWuVMk2/XJYM8dsJAbZ+kfFqjgH8D?=
 =?us-ascii?Q?AsoGWKmTlJJjk/aEp4xJSFUu/cSbsacKvtTSpxGxM8nzvDcPMuDx3LAHRkP6?=
 =?us-ascii?Q?UGf0rW+tSKBKUzPIu6qVJIpM1GMAJQ8vDh/PQH2yZWKl6nuXh1zl/Z/Tbq4s?=
 =?us-ascii?Q?gXfD7/lqZE3oPXBY8fygcxj5LEMm67Ry8Hz9cjcPhguJiN/w++j0vMskyUZG?=
 =?us-ascii?Q?+0RcqmiOv0iAXBptweKZVx2zidUwzx8h/2w4uswpI5signiLTiQLSme1UtIx?=
 =?us-ascii?Q?jV9QlBwf+CuTwwEm+8IseK53OG0/ib5YFOGgi7BPIRyTRk8dL0SEY2Ou9Umd?=
 =?us-ascii?Q?T9G9l49q4VkaJtUWz42EnqqsOpRqtFEa0m9tsQj3p0dWL8og8A8SHEqpYuae?=
 =?us-ascii?Q?rmueXoliq0MRbLKx5282tJEUvprcPGyy77o3/Q49R1YLe5GcuRfa9Emk3TUo?=
 =?us-ascii?Q?nMqoBLv2sXfl7HkNRot1Gy7fWrpxxk5R7i5AbPx/yslql0MzLIl4fE0BsDMO?=
 =?us-ascii?Q?YEgWj4BMA71FcqtTSjBPOykbeMAvj9cm4jSOYO+N97Aar3aTjmXry/5rfq/6?=
 =?us-ascii?Q?HIRbExg3faW4IYWC+XDH8s4oTjlB7pxM9xdnZeZosTgysDYfQ7fMnqwXF9Ar?=
 =?us-ascii?Q?R0cWdRwAX9q2htfk91dL7AuhsjszqdX8waxvAdSz2Cnkyovf2IZwrmZ8V1cK?=
 =?us-ascii?Q?iXbkF1OFoHZRpzzKbLq9knrquwk+Mdc+XPqU1EBsncK7pFw+6KPQYKQsertA?=
 =?us-ascii?Q?xg0hONx5NhW7adJ1lXE0mq3wYAOSfEDppJdgO+eB6H+MK3rW5vhVQS3mkGtF?=
 =?us-ascii?Q?F5A0gqPH6x4e0aT8tX7A35N/XoURSa4E1z2gnMGeaM0ag2PSaYCoNoQEK8mN?=
 =?us-ascii?Q?JXUk7ZjpCcwm3tePDx6Bd7k2YIcN52VpeJjsvSiXBN4fwJpv7MFvwCHqdiN3?=
 =?us-ascii?Q?MUlljqCo+xJ7sKFiCQRL+fzqu5RT/8VogT8ZyNRsw1H+QIUTrWK5dVAR9BUr?=
 =?us-ascii?Q?/khcBTL+FEZZyTBLGIJTJrMnjg5zb7z5YfeHIrPNgAy9x3NGjXnUCtSqLNYK?=
 =?us-ascii?Q?XsoZGXDhSwl812zJSz5xO9gTSlD96sgrOHGTVjWk14fuMrz294LT5/UyJu+G?=
 =?us-ascii?Q?YlUgrs4B7YKlb7SVLL/D3UOJSFDtFjBYvD+8y0JPtkUzIjNq1zy3lMx4A/CS?=
 =?us-ascii?Q?CPqxaKqZ11um/FqJ9ngEfxeGco+oIJZSpmHOv9LWbNnTChZhJoayuB0erIHI?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h76Pn4S9xXgO6n2P9YuCqLpeOizllFSCwtE5mZ4dvoMF+kPGyC72GyYg2yTW0VgaE4QTsdPdMh0WRBwoQQFz96BVCU2R/bWyJZEHH4XW50bNf8b2x5nf3kw4DgENfft70+FQkao8Fsp43HZOFZ1CCGCPchwhY3Aq/Ih9bfwZIvu4vGArMUvPtkY2yKie/vbx4ZMntKGVC9E94L8Mpkd+9reCvXD+18EjhxsVnqnDKFz+ECom3ctjcqS+oMsvQ52jbr8GqGSRKy+qCeMdOsv9IBjrMZuFYW+1lLxWyl6X3+5j/aO3FI7ZPDitELaVy3qQg0KiednJxAhARRcGE+xqRUD5wQx2HX1APvF5hpEOWrTm+UhYK9Fu6yJjnbgWZ8mzUgyaXaRd48ECfb0WkVtTr9ulO3PG4YAEaKyH1TexS4+fFLTBeV/1v1Kx2aDO945zkelr/2oWT6PilTvrVV0szVHGFp6hnVnXVIcJWH+gmsRuEpalA7akfb0W35sttUblbySDjZ399KcfWUCtx6NfGjb4cASWokgIhSE6g4eJuaQ9eZ4pYWIklp8YkWSEZA0yp01aPNYhHwb9N1yicknfNkYQ7i/Z+sG7KGKf1uJWsZc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3a36c4-782c-4c91-a0f5-08ddd505f6a9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 16:26:14.8019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aovKUaDiyUfn8VXF6zFOG00PpNOsyPaANvTThDHxl6IaqUCyfE1z1KeyJlHpuxBYytJkVIXT296y4GMYOAezlBWwv5o/BptL0OAHFfuJqZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060104
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=68938229 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=drpxK5Sr0r6PeNfVfTEA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: K4i3LfeUPhF_YeTrkIEVoGyc6RjZNKGk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEwNCBTYWx0ZWRfX1AQWM+IHoKGb
 ramUCgExUGIELWydClJC+UNG06WmWAUFFHcwiPXGXKS7+8t1WQ4LutP6S6DW8PCrGaKhtJDFOlG
 9cb1T8pQ95hAb/ecLfk31rcgWtsmsgVebPBRslAGBdVdg4Hrq1XgAtluctnnuUvcWRYtZXG0hzU
 CHxC6CoWLGihu73S2UOqda9qfmoNSrXYrKZW0cAS+m28KkTUm4vyVci30xbohZ8sdr+4UBTsIK7
 FOJLU3MLqijZkKcapejsUfQoprFcdCEktnh4DgsTTj36YxlSjJsiUQpDyOeidHFVNT7M1oTOQyT
 IDBmP0TIGEC1X03xMVZY4F2PXQ2k0SANETZRLe+5+qx9JswVBfyT7TQA6kDVSaYf8GNoSx1KNH5
 XwewumQLjKu06Rdq7NyUhxVXY/z9Jxm6cj4tnafk0VeIBPRBjs/mCvaGShLgKHX70BHzZ4la
X-Proofpoint-GUID: K4i3LfeUPhF_YeTrkIEVoGyc6RjZNKGk
X-Stat-Signature: 5x11fmu1ijzu9mt13isu6denjtkb1sb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C59B100005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754497585-918446
X-HE-Meta: U2FsdGVkX1/TO6FuuxL93d2JzLqebMmFl1eyjlO3bu8fdH9sE9eAJPFfaNtyHaSG2ti9rhmQkpfJp67igUeVG98roxNLoPt/xizEeaEmepD57PFNmqElYkdq2g44LkmGMd2zkPLhb+PYZzK3lAD6NHsNrt4L39SSTngka11JjiIzoUnPYBl+M/oXC2uyzn7ZfiFPoA6NZXg6/bLzDAkymHOCie3XSV2Da9KaGu23GpAJRuvvDbCeEJupJBtkfIV61p4iSBn//ZJa98K9jzgPMFj0UOlwZc65UhC4vDgQ4DkJogc/Zd1J9phBss6M8og8Z79On+UBoyxBqWEcqgYWxa9EIUmsRPKDoM3SFteiyxQd+h0TJ8sCz0SrFsDZ9ec83bKPMxb0QTimtwq0nuCQnCyEjCxu0/NI0myTpKr30E0CydBIKtPS9hZFg3/DecB1ghKwem/l3BSTRAjs+mr4XdKECzs5/nrESLl0aOp7PEHivYlzYAk2SJ1vu1jEzSF1gLh8pP9RMwnru6zMGQWrBXZ8YCNYd3/bOEbgf97rHKeQ6N0w7mXS4uvlFq7+KL91JPRA7/zJiXtjGoX2PN5JoM+gs6oJxBOrBCS+cEg+cTGcOvV38byA1Zz/vLcYLFao2DTbzo4NCDTHBNEk1B44+iBQojODNXilVh50BI8sJYBB8r7N7N2sioNi7IT7FxKBQrAzpCEXoXWMFADYTEexZlqz0pMeWKfzhAN3c4EJlBJw6KmF+HM6P2rndFOKauD23r3sT3o5pFrAf4Le3uxXci+TEQRkT9DM2TDiL9MeC7eKJ74C9jumSqhzkTLs+Al9nBwgmMoEnPAVhYerwzLq7eQwq7oeZGJ/+N5M6bvvVgdtLDvSPcCxSQqdic8kxajHufLG9SwsKsa7ob4BYmjADG6i4OuKzbQzZMQzNylVNIfQCBnFdbVvTd7uIK1YwX0X2EEksJW9iBc6rdVbtT0
 0KpPlHOr
 VZhX/38rHinA96mL2AbheUPDaihrY2/GITvwGyo/37DjvkqhJfOYrJnt7NBQoBLIkxr4m8TltPPHCZtWrJ7Yt/wNE9xW9pWvw6uF9gD6iNNIpJtXNBDI1W2zCJX4qs5o6pasDI4S28aSs4Pscp0JOHRajx3Ol2ZG13r8Q58o4LgyB4GayTCfbiPsfoYpRa2b9KIvnqvzIAZCuh6SCl3+tFhUz8Vhnd2QFwdCKdg/7mpQ61/+s94AlWCJO7HnzI88ngah8repjIqeNT2cGWTSbe1U5dX9Wkn2I2Tn0pUYpnkvLA0rakFOf1ZP4WI8+VqVXLzsQl9FHzGHoutPGAfa5yvrdJr1H0wEVqWdmyG+xWmqFi2Xtzuf66v1xEsF4nh6Zv1brHF2cLO9Qk03WwVuRc6r6XUhQIDpT/SzbJ/Y4j1KXYpHE4TVPM66FRK8Xs2Ivci514YQKYjEk1je07SO0dkNo4ZNQMvKkKRuMmSeAof5zkbWaUsRxJHFNcmo5K4FlZmlLndIXmBHJzkIIktbc6Oj9dyBy+cjKRM4513I79v0aQGtJvkAlMUldnEyHo0Gj+VZV7p+cUQ507U2cuucTffaKkVHTeBfBvNhYm5J/4Tn+dy2C+s37BYJFDRGbUgxgADjskepWCY9kYbY5xbWdwiqQ71UHPl7ToWpzw/rAE9hAzInbWVjZlEBuCUWrOMXHFXHkwtH/04GIH6AOiBC/X7DPYWAjveARvpStvEeUi5Cez0qcpfHdRKI1mMfstkjpqd1e0HkIsGy+mLw2BSxyH+sbi3ivNCuWzNu423HOi7vSO2oemXKjycy76I+jVoDwXk0CvCbvR2V8NFoyuq36k1IA4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 10:22:31PM -0700, SeongJae Park wrote:
> Hello Baoqua,
>
> On Tue,  5 Aug 2025 14:23:33 +0800 Baoquan He <bhe@redhat.com> wrote:
>
> > Now everything is ready, set kasan=off can disable kasan for all
> > three modes.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/kasan-enabled.h | 11 +----------
> >  1 file changed, 1 insertion(+), 10 deletions(-)
> >
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index 32f2d19f599f..b5857e15ef14 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
> >
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >
> > -#ifdef CONFIG_KASAN_HW_TAGS
> > -
> >  static __always_inline bool kasan_enabled(void)
> >  {
> >  	return static_branch_likely(&kasan_flag_enabled);
> >  }
>
> I found mm-new build fails when CONFIG_KASAN is unset as below, and 'git
> bisect' points this patch.

Yup just hit this + bisected here.

>
>       LD      .tmp_vmlinux1
>     ld: lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'
>
> Since kasna_flag_enabled is defined in mm/kasan/common.c, I confirmed diff like
> below fixes this.  I think it may not be a correct fix though, since I didn't
> read this patchset thoroughly.
>
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index b5857e15ef14..a53d112b1020 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
>
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>
> +#ifdef CONFIG_KASAN
> +

Shouldn't we put this above the static key declaration?

Feels like the whole header should be included really.

>  static __always_inline bool kasan_enabled(void)
>  {
>  	return static_branch_likely(&kasan_flag_enabled);
>  }
>
> +#else /* CONFIG_KASAN */
> +
> +static inline bool kasan_enabled(void)
> +{
> +	return false;
> +}
> +
> +#endif
> +
>  #ifdef CONFIG_KASAN_HW_TAGS
>  static inline bool kasan_hw_tags_enabled(void)
>  {
>
>
> [...]
>
> Thanks,
> SJ
>

Cheers, Lorenzo

