Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFCDC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4FA8E000B; Wed,  6 Aug 2025 12:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CD48E0003; Wed,  6 Aug 2025 12:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44658E000B; Wed,  6 Aug 2025 12:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF77F8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:40:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1CB1A059A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:40:58 +0000 (UTC)
X-FDA: 83746896996.25.705534B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5853FC0008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:40:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LLm8fqWY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yEBahx22;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mdo7Po7g82blixnHIWt93445HcumDLHsfdO/giBrtsQ=;
	b=XEwRbkS53Ev5Ht4WmeOmVs3uKwbX200FCaFvQgLXaHJrZJUjsST+hnaodx0Nfj2xamadIW
	YxWiO3pDRxYBd7VNEYPaNtvM5kR6oSewWFdaV/YKVfNHnqc9brhSrHXafSzZ49GpwmLco6
	rpVBetAOE713K51o18fmMvjsfkUY27w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754498453; a=rsa-sha256;
	cv=pass;
	b=vLrOH1P8WtzTIOQ9Bch8xe/wAYs9gRUJcSQ+qzesr8p8fiUNkFdWP5X2/aWUFBIFutRoOo
	gPc0ge20ZueqCrN35zBTIyLuDUk+ZJ6uNqd2I2VTwlrcT/EcSxSiuLxRlXcXpS2jHwMlR5
	orjsXTDyBpD7oMcYJGHDdW8wTHe8ppc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LLm8fqWY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yEBahx22;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GROC6025015;
	Wed, 6 Aug 2025 16:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Mdo7Po7g82blixnHIW
	t93445HcumDLHsfdO/giBrtsQ=; b=LLm8fqWYeQjBt4o9g96boFEfPHJmMC4y5u
	wkwT6xMNOm653tRe1vwGpTOeLp+Or9GJEN+EIrVL952vHfTDaXNEGnyhetB0qKBV
	FHSgLYca0WbxUmjO6oEJSN6Zj1nayGsc9SE9n/O8uGZeXRFlQkuQLSBNgO7TbTEH
	uZ1WXpwmA/Vm+pihH3yWSjiSLsX3EDSpud00/33AaiBYUqo1zvFCLY/s3pWVbomU
	Dxp3vudi3uE4H0cS5b4DGeAmx9A5DiTT8O8XG9TqNZcjGevkGQFVF0hLl6rMOPyW
	HLu9k3h6O2S/4O8D9W/VGtsS4aPWlrUkiA/3HpeTYa2q06xRpb+Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve26c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:40:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576FGopM028197;
	Wed, 6 Aug 2025 16:40:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmgpxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjZmZkWy33ViOh4OmE+Hg6ju6ip60Yyvv3HGNqFrVMRNO8XS1HHZo76ozMPcGrS2T3I1JoLxOejMLasSiZ6ylUaeNuu1N1I4Z5hmTxCNpPGkOcGAu/kutPPW6m8NIjN4K9y3uNSRwzyGC+toP/IIqGQ52Jakg5wwzXhr8VBnTWN27YChkt5dMsNDslDX2ykQqwRxnZmdN1/Gj++oCjyS6kSB++ZAdJZjxYt23QpHcGY9yXijeL2AjF8aLW6WynfUINcJ1Jlo8uQ8aUfO4/vptduBEi7Gs6/NnfdgKLhvNJ2y6RZFJROOfr8Ir+Whro/X/C0QgwB3BjhtsSJWxtYVYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mdo7Po7g82blixnHIWt93445HcumDLHsfdO/giBrtsQ=;
 b=cBF08UzRJJgC1FC6LRJ53WTlTHacFY7YregoNpBTW3TeRfb2+ki09pMb7TZl7PfueG6MO4gAVm950vd5Ffm2JTDChAjij3xGLD1bIDFS0PZdI77sm5yapsD/pNX8XNkhiX0bMBlqGem/gNItJRpeI5pNXuXCf0VOHUDToZJrAbenlQ0nWIa71eMx3ACzuREggbPuIJlzE2XgZEitW7CN4TojmVRFbC9H7I7ACo1hG8QAZLNbkY47L9AlM4NgaO0PYASzZHe3dr6K1VcuLuPlJ26d891soBkYiiKOxGsDLggY+kvJEGvQoiCPW/ZIhm86QTzmRdVOXXNc/IOZx6F58Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mdo7Po7g82blixnHIWt93445HcumDLHsfdO/giBrtsQ=;
 b=yEBahx22RTb89FdHlxm6imCfSzA6Tia+ottm7cZpSZJY8KeFR9SAGk2+EvTLQjpNRUmzYS+wMAikBbMfxyd/VQ95KyK05TK7dlw/uv3v4vHpuP2Ow5ZBtWR64MQdlc2wxTaJQ5shRwWAhMjRh+JPseZNzP9ibWAc+8NKe5QgHck=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4239.namprd10.prod.outlook.com (2603:10b6:208:1d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 16:40:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 16:40:31 +0000
Date: Wed, 6 Aug 2025 17:40:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, david@redhat.com,
        willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, jannh@google.com, anshuman.khandual@arm.com,
        peterx@redhat.com, joey.gouly@arm.com, ioworker0@gmail.com,
        baohua@kernel.org, kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
        christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
        linux-arm-kernel@lists.infradead.org, hughd@google.com,
        yang@os.amperecomputing.com, ziy@nvidia.com,
        syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes-unstable] mm: Pass page directly instead of
 using folio_page
Message-ID: <acee52bf-4f19-4e85-8d69-15d6cda54e95@lucifer.local>
References: <20250806145611.3962-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806145611.3962-1-dev.jain@arm.com>
X-ClientProxiedBy: AM0PR04CA0129.eurprd04.prod.outlook.com
 (2603:10a6:208:55::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: d23f2a94-373c-49a4-770d-08ddd507f57e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rey5kvDowH9+zWw7XxihOjIvzHlUpcLJHyJ76v6Ux1eU6vCjYX4EiEhC/QMV?=
 =?us-ascii?Q?vdSamBx/mQ5eQ6eDQ9ff8Neua38J8rvq+6X5QKHaING++79c2+zbtUh5/pca?=
 =?us-ascii?Q?itg9mova/lj2kPAG0YQrcstgofnJnPdqXylRzuIUlgKcvzjY3qH7x3siFQ52?=
 =?us-ascii?Q?21YqJlrDLolOq48FAHFR+5OyU1S81hbolQyuo90FrBYnzD4uFUKQlTaB43sZ?=
 =?us-ascii?Q?5rtuvO7jeYbgy1FKu5hGWqJgcBIUaFhi1K5rDnG6n2vJj/O08Pze9FqKNbU6?=
 =?us-ascii?Q?IgPFO6e7y6l5clxezHAHaQ/uru7eLyN7YDYMHk+HDPuFR3l30Py4JfWerGbb?=
 =?us-ascii?Q?62q523j/mmI6tyMyE3Fye8Fnze3UPBqSUvsbTJbarGSzJHQ/1JEla+ndWJie?=
 =?us-ascii?Q?eN9S5NIs3ch72OHDNZ+VVW4+Ge2v1OSQj0Bj/PTkyijGupup3DNjTpEwdcTL?=
 =?us-ascii?Q?kimyhxZmYZOayoaDru3+Ubs3N6XgZ6fq83tvjGRx4nA32qGnfY57FZHr6bxA?=
 =?us-ascii?Q?TNXvHCc2iyaRQ1sp4k8jG5kkZmbeK8+4bQKhDApE/Y/IYympo4bw5AgvV8nn?=
 =?us-ascii?Q?KQL1msvrVQV2D0VGDnO2ZKsaXp9CR0tZC+FiGE/R3CI/20aH/EzGjZmYhaOB?=
 =?us-ascii?Q?3/CcgqqvLOYRqDzUY2w2FxFugL0rFN2tz3ox373TZlmvVkg855HmTGpJzCqq?=
 =?us-ascii?Q?H9xtaxNqv52UGry9Lkij3SgL4f/Ry1uvvpKw6jShUERNfo+RPB4ZaR2FwoOD?=
 =?us-ascii?Q?8a5owGhso1VDXfJHycQQt2OJVGFQz0lENObR6hI8/i9EA1uTJzZfMCGt3mWR?=
 =?us-ascii?Q?ifGECdKqw8kU29461cinR3bN8GXU1nqdVQ/BWwnPRn0mfRDUBm2yDyQqwI1L?=
 =?us-ascii?Q?ec0kkBTgwJ5ssp4fiaysa4o5WcHfmGPmrEJitTHVKd9jnrmxxffKFQIz3dyv?=
 =?us-ascii?Q?XDooG1IQE97tLr/87rtZmXmjDuZPIh0bGbVB9Gph3lorbQJotB4A5TWRGsG5?=
 =?us-ascii?Q?xrSUgGXvlDo3lI1YIUvdAhSDjNIXqNv/nwpjAktnBL+18R0ciI+58Jt6dGDl?=
 =?us-ascii?Q?DT+k/R0evhkN/fUyymxdPZkX8QKBVkQQIU4L4YsKt6QkWvoGGj+ak7I5Vudb?=
 =?us-ascii?Q?9PWLh+7MpRLj2DC9z5al1/JxypzG5hDfhhl6GYnD6GonGsO9QFcY+QVhTv3E?=
 =?us-ascii?Q?P7yz6NGyImLdV1A7vWLrdwgDgCQMUhlQ8JIaE8VcSygSb+Nam0vMtj09bBWy?=
 =?us-ascii?Q?m5wLR07eV2DoqajoAsytO2sBe5yIQaoJkTj47VejzMCEqFgzDnkQeNoDm3ns?=
 =?us-ascii?Q?5dloxM/Gqkjuzzn55N3bIzQhZTDwpnMuconM2SnalOk5oGEg+4w2PZnxARZ/?=
 =?us-ascii?Q?hGGKhdHBHNZIKff4fxsCBLn+bVJL5zb7hKfmszly78xdo6TOiw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k2/tVypdLTSYws07xx5MDcAqcWgxwKw1EogJFUKESFY2KF05SG1Hk3w5nD70?=
 =?us-ascii?Q?nCAQNIY5k5ybJ0tqakDBKxO48lgsfcm+NXTGl/Ijxb/mn3J576SWR9NZbQ1U?=
 =?us-ascii?Q?hKJdFO4e+vRKVGXRIAwprlIcLTxEWfJp+M/5yYFvRBCMXhT9eLXpYm2TNMm7?=
 =?us-ascii?Q?wmJgiNG+XX+75PB5iKt1v6WBYAFVd/MrRzqnHW813ni6Qrt5/382pCGEFjEM?=
 =?us-ascii?Q?9mCA+RhzHwGemfJdxpoz24SpF09J4v4BYTVNHHp1FDLFFYffHCV8oQ14Rn8+?=
 =?us-ascii?Q?pag+84Cs8+WiQvobu/c9Oz7KagtWECCYv6h4/zFJ5OL1wPNHIIFRG7dj/0ma?=
 =?us-ascii?Q?OHtHPZtxpfpNfHpIAhz+TMXiryiZM7dcRZlbUxso7hyUUHdNDfi41KSHHsD2?=
 =?us-ascii?Q?GpyqzSOP1TpRIdHMcJiu28Flmp5eJv79wsPYr/4wb/bPfgJTuAKukZ6Wk7V6?=
 =?us-ascii?Q?VgSJlXcxiX7MVfvuJsgBWPC2cF/SBmWIfmjQZ2e9x8rJmlDAWdS7eQLEgdE9?=
 =?us-ascii?Q?4R8rnSjDZ62J6WfR0KziWTbW1OkgvrRlnffOYn8alLlkPefECZ5UCzS0eATG?=
 =?us-ascii?Q?DKcRc8wsJNKZXSTMd18UO8VSyBIJ3tM3MRqjuJU6EPmyR/pdp4dEhO4LLD+N?=
 =?us-ascii?Q?wfIvv1Lx2Js2FFRNVpN+q0c8TzR9NuTwtIPBiR43F+hRsabBhcxz7f4cWwqo?=
 =?us-ascii?Q?kUizWC2E4pzUa4rf0+MyYI5mRxa7Mqj54t+kbSrR3w1G7nYYWvF8gLoxjtlm?=
 =?us-ascii?Q?xBg9esHGFuxQwpcg10nrbQJVhAt3XIYpyZ3k3Tz3eq40ujRdoSZT+NGcipMJ?=
 =?us-ascii?Q?7Uo7EK6QHHrWsuaOLNajgod2KjQrPfdMxJLr9IlGl6O4hf9GwIVHmg69qZsO?=
 =?us-ascii?Q?cWPmyi4cAFPIe7ZLxPBXOhIgLUBiXD+dDpn2oKxYQg/28Y9XVh08Z/gA5xai?=
 =?us-ascii?Q?xKhZjB4Ny37kABolNhFo0giNZDMU+S1fp8E+CK7w6kMX9lIuCSoaNR5OqaMZ?=
 =?us-ascii?Q?Eg5OwpikrfWFatzJo+qDRrOr/6X+98Xh9IhGyQjU62IMf10g+xjjk0EcGURI?=
 =?us-ascii?Q?ymUe3NPd2NHqoh+Vj5XuCBxOARQHl4e2yrYrpYN5wqL1L3sLdQ1Acf9HWckO?=
 =?us-ascii?Q?t8RIkxjIeTxZWFJ2ynBPM+M6+OM+RraLO1MDj32uXcnijNTOLJ0Elw91rTii?=
 =?us-ascii?Q?4UXAsw0O4IqH7dBrLArtNOEHTwBg6uQvyof75hSYtXXVzcs5Agnk+jc+4ea3?=
 =?us-ascii?Q?KF+WcR0pMJATm45gj1Hwd4x0zqZ5mNGheI7A19saV9QV1j+suwqsEfEP64NB?=
 =?us-ascii?Q?cvXWcxSaRZqiNk+Hc1zsod9qLeUTb3kzvuXJDmlBC0W2wXZWuvBDvH1/XzQk?=
 =?us-ascii?Q?cnzEG7NrKQ8XmtGs1X2C1jrPqEYhto5jU03DtlWJ3uSa7f8bmNzmizpDYgCJ?=
 =?us-ascii?Q?4iISMajhpCsrlnOEHAuZhxmbHnHCVQosCPOHbmkSPnmi1R7HinmIUsaWwbkN?=
 =?us-ascii?Q?pqmayZ1ZCDDIS8VGrJBFJs91FeUK4H7u2nxbdmsx6nUU0ZL0GYsgQ8h337Vv?=
 =?us-ascii?Q?ru+RgZRFHOPKeGHaiTew/JDBZBHWaEf9VCfkFlfJ/Os8rI4aRDqpw+bfqTxK?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NBwy3POidFm1s3diUDeZbpX2FUect0o/oIMjWzeNtqSWD9ayV75rhFStspsTsaldj5L4+05YUxrUPabBmP2m2df4+WkRfyvlS0LbC8686wGq75/86jXMTY9JnfvOuPWq6GbpIy1SnRweMyr0kR5RaAWUB6RZJ1xRtg6LFWJf0FUb0rg9sH1cf5e+R/tvWv1Q2xxUUI3TO1xNbqQnEcDnMtvEI3RKhSvuaOLN0Gzy/CllMi1CMQ9uDRd5PlAzQaIb7nsqJZqkWq0tRb9Ht2LJVLkfakDM4a1f7F6hYDP1/tl27/AwNsvVUYs3BT+wmM6jr+BPpJ2m2xzHb2ZzPeizJt43cUp8trFXwDb3ql3otJ7vHgVinVcjSpCxwvcQtI5M477fzjBpot32DoAM7h4AVGUdbuI0gd0yiPWRRS6pkinJt0mS5cmsKDiM/PqgE557nWozkVzTYUdof+weWDb+4gAq+oOff//dkJ0d/VxRY3TGDALA7FHWbdav9mccwRKETrmfWwXqr2hBjlspb7eS63Jwp9wi7EsKC+vmTA0Vq0nfFhPKSezV2q039tf+eEaCVbotw27caykNfV+7IedRX35Qz29FrhERT9qChZ8G3vM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d23f2a94-373c-49a4-770d-08ddd507f57e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 16:40:31.7374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXPSKzTQdye1NJHAbrLXjwOsLL7R/AbbT2kgv9kR39L0ZxaKG7VcFFyREkxP2PNoBufDK3t4F8StirF50kEvuYBbeCedZwYbSdZXhl5+sJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4239
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEwNiBTYWx0ZWRfXyjE6oxiJ254D
 6Z8zVGiCwQ7GXLQIE1/zkI/w0jwejKNV3g4kEgRPCwyu1ldAkXUwqscjLNd2H1eEiFAKlPUSAXD
 HGWWYtQK0yf6nSxhqjWvRQ0LQqVeYTVC/4NeJ2U+Rrw2FATdOtnIosT2wG1zABIvqc7G8YX1qLQ
 PBnFPSQ40YQ/tcioSQnrjTT4j5mGqNl21awtf7M39w6bDeY7D569avhg6spIzwivCcdTtXLDPcm
 0pzVf94bQtl/W5og+rIZJ/qVAZsy4bn++v3d3RqOyqqzF0vBrjn6f/dHJJDNkU5lLnEkvfHkD8L
 FJo0/PTcM1297ROFoFMWn78TdoBs+KvHyNrx/eh2sfnQaq17xTMztHS5/WrHgBWOQymmFkgxIHg
 D6N91my/rC2zdb0DbgcSwPfuFw9qq86qXxH/P6L+nCom0UaaJysXCI6KgxQab3iW246HA2xn
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=68938584 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=hSkVLCK3AAAA:8 a=7CQSdrXTAAAA:8
 a=yPCof4ZbAAAA:8 a=zQGhVfqZdAqpKRLXF9YA:9 a=CjuIK1q_8ugA:10
 a=cQPPKAXgyycSBL8etih5:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: C2wyhOZKp6VbR8t2mo8p7fNNBLdl0zun
X-Proofpoint-GUID: C2wyhOZKp6VbR8t2mo8p7fNNBLdl0zun
X-Stat-Signature: ydsaggoonu3hfg35ji58udkdghm7sj4b
X-Rspamd-Queue-Id: 5853FC0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754498453-806447
X-HE-Meta: U2FsdGVkX1/UXh1pGOOx5wqiglykQeICVyuD0GFwtqJo3YFyh+ZEO2DO8Lr8Y/W1N/0xdpZyZLmO3hWQ47vhY5lxCUGiysp13gCiLpvviwNUyvMKbQw/R46jPzFy5r6jtydR5+tNJK3sEkYXchT6772fpCaaYjhbpDWKTtjvahdBpkq9g6iHXjmR/D3qpdTmC3en1R/DClgOhGotAWBxfACAdwWWfi2X+GeAk8xHHFBtojyci7cGEwHI/R7KrSgwtBErtfAd7/Tx4Ysn8vWYdIvg6Y+zlXYZWpeyY7hMiXBrLnNEVUjtfM6/pKXNjDs4jPE/4hA4z4tLTDlNRsb2LkvI1M/ZcPlJwPY+jbtBS/yHcN9n1PFYfFCCig9l37eHwzv+LBPd0dKG0mazUkuaLcj6iQYAkKWixrutY7C+P6Gazpdtok99O1fU9Q5T/ipJiCAc6mu4Hmi6GriuSW8dhabO8Jj8NuQPYKE4Iv54JLaeKkynU0Z6zJj4owvrbM/sHK3dkYrZlCv5WfV/LCR2CExxqG94mYsinHfGfycSYvvsnMp74oczaSf6xJpnIIqxwM79HfzRGzdo7xJHy1Dd2BnNtepcYJJjV0dDYK6p+TIlEU3wpJlPeGdfLMqFq+T7Vu6abwMvXer2LKlev0MshRYWMIJPucorj5g672820/GPR4kSt7MvRrUM5hIphuw+Sp89bqFhL/qfLgyViq1Q6i+LkaQhMWi49oG3wDnYDK3yndlKoCefF1PejmFtiYzDl9jqUeB65o7aqkNMWszPQXFW/axY0kZyvoutlbYiAerH1RU7hYl8dj55ORzCeRNUXiRR6XSHuhWyeVgTGyN7EMTXrO9SnvIBHsRAgava36qe0GF1FCY/DMEe1QQINocnI3Z5MyGtWc9bVWthwnb+aUREovFNi4lcfvJZf/YfB0wwrGkugsHrLUfyZ905TTktu7/BxpFToRH6IOPThBN
 vMg947Ns
 YiSvzU3iBVyufBDZOncUm4+f2lPkXsJ0oMev455kOVSJVM1Wf9A7qKO+4mw0BYb5CAS1KC5mCI1rW/YTIYD+Xq5GcUW+OKnRLASPFHoCcpZNZp66ipeb4RTQOMKx0M7uthM7HzGOWSDfPeBWEIsUkVQXG3hjsV4Ewgw5+d50lldLbdVpeLfeMdlrDiH2OI2nRt+lKAic5kvaGqplEwXW1tEcStbBkrGc6fMsHb3TX2YveapClQr3j9SDqFopLO6MnrTT0xihVlD/1UNj9z+Ndmq31TQIP3xplj/X1Ug/jFOkKLyHQkGpF9HWFhuURt5jP9/R4wIywsnKrITdmFqUjY0P+MDuPSSfBPZoosb+0qYKdcUue4bgFrDQ7S/OSsq2Xy/hO0u3hECAxFjd6cuzGo+Rf2501cRaumPO/32KH6zTrAPFiHYi/S0avQRWawqRF/LavfvLc3N20hmC55797ZAOnWQm0yEdSmUP54FGjv6avh0LupQK4LMYP4ixmL0B1awVFlbH8p8dWgp6IGAeo87OX85CNwSf2eSDi88PSbhvYw0zr016BB31oaxD0EbY53FrLgSpC7TTjgqBRwTKOFgtt/Y9FguUh2DmNyjziP0XKF6GjactZwml7njyU49YSppfPlELUEOu+1+nwR/QN01VZjuTMWJCuc2cTXxUFxpH1F1/CUsDpLl71eXbszMLachv7yLaLdX6fJL6e3ynpoyH1lAiYtWq0vx+qlxwML5K6242zuwDWwQCBI+4PkQv1YWyCLxgnCtnL1vntYBWIUtHDMkrXpx70nTTO/brXaCNGkFMBQ93EPTgWDCVo0HeIn1ntGBEEbei0maDtnELeYqMaJcoa3Lq9Tdt4l7/WIqBHYuNPZGPeIGreRnspxWYRTJ1vXNptr3oxqbkIZeBSMp4ZdupW2R6jv5IbljiwZOeRKDC9jLX6oa+v5Xe9zziBeEKz/iaH4CLoWdQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 08:26:11PM +0530, Dev Jain wrote:
> In commit_anon_folio_batch(), we iterate over all pages pointed to by the
> PTE batch. Therefore we need to know the first page of the batch;
> currently we derive that via folio_page(folio, 0), but, that takes us
> to the first (head) page of the folio instead - our PTE batch may lie
> in the middle of the folio, leading to incorrectness.
>
> Bite the bullet and throw away the micro-optimization of reusing the
> folio in favour of code simplicity. Derive the page and the folio in
> change_pte_range, and pass the page too to commit_anon_folio_batch to
> fix the aforementioned issue.
>
> Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
> Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
> Signed-off-by: Dev Jain <dev.jain@arm.com>

This looks reasonable, fixes the problem and compiles/works on my machine so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

This badly needs refactoring as 13 parameters being passed to a function is
ridiculous, but we can do that later.

Let's get this in as a hotfix asap.

> ---
>  mm/mprotect.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 78bded7acf79..113b48985834 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -120,9 +120,8 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>
>  static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio **foliop)
> +			   struct folio *folio)
>  {
> -	struct folio *folio = NULL;
>  	bool ret = true;
>  	bool toptier;
>  	int nid;
> @@ -131,7 +130,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	if (pte_protnone(oldpte))
>  		goto skip;
>
> -	folio = vm_normal_folio(vma, addr, oldpte);
>  	if (!folio)
>  		goto skip;
>
> @@ -173,7 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>
>  skip:
> -	*foliop = folio;
>  	return ret;
>  }
>
> @@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>   * retrieve sub-batches.
>   */
>  static void commit_anon_folio_batch(struct vm_area_struct *vma,
> -		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> -	struct page *first_page = folio_page(folio, 0);
>  	bool expected_anon_exclusive;
>  	int sub_batch_idx = 0;
>  	int len;
> @@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
>  }
>
>  static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> -		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
>  	bool set_write;
> @@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>  				       /* idx = */ 0, set_write, tlb);
>  		return;
>  	}
> -	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
> +	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
>
>  static long change_pte_range(struct mmu_gather *tlb,
> @@ -305,15 +301,19 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
>  			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>  			struct folio *folio = NULL;
> +			struct page *page;
>  			pte_t ptent;
>
> +			page = vm_normal_page(vma, addr, oldpte);
> +			if (page)
> +				folio = page_folio(page);
>  			/*
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
>  			if (prot_numa) {
>  				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, &folio);
> +							 target_node, folio);
>  				if (ret) {
>
>  					/* determine batch to skip */
> @@ -323,9 +323,6 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				}
>  			}
>
> -			if (!folio)
> -				folio = vm_normal_folio(vma, addr, oldpte);
> -
>  			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
>
>  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> @@ -351,7 +348,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 */
>  			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
>  			     !pte_write(ptent))
> -				set_write_prot_commit_flush_ptes(vma, folio,
> +				set_write_prot_commit_flush_ptes(vma, folio, page,
>  				addr, pte, oldpte, ptent, nr_ptes, tlb);
>  			else
>  				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
> --
> 2.30.2
>

