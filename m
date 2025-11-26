Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49300D10F5A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9706B6B0011; Wed, 26 Nov 2025 09:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948546B0012; Wed, 26 Nov 2025 09:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FFB6B0023; Wed, 26 Nov 2025 09:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD476B0011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:37:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E31D5023A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:37:39 +0000 (UTC)
X-FDA: 84153011838.30.DAB7D38
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE40112000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:37:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CQHKJNM7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UaMFLgaJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764167856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1B89XSXMYNHO2k1/v4PC7dNlxb50Aya9/hiUb8EtOR0=;
	b=L8pR2KXbz1tcvjSHPRxLVLi3nNx2MBmbPTM+VZaA2PF8qAi7lNJAVIiZUbTkxCtRY/gD4m
	yiS9oxY4ROE012SbWGwET2r+traLIppnHjsJ8sGkL2XBpsNXORQM9WRE/tgf3kPcY0C977
	b4XthNF61iw3lYh4uexj3MVcoInqmJY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CQHKJNM7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UaMFLgaJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764167856; a=rsa-sha256;
	cv=pass;
	b=eund/AEDogZn/Hba0BRWMHjV7kWE/bfOgdlNZuqTLhgIlCZb28XAzLvg5HbX7jbJH0eEzh
	mOTKfC43sbVoXEkHcs11ea3T2UiJyQA6edWkfF9xaRaEki40eez1NlIokdcu6fua6d5RRR
	UxWb6K7aAy7sLEchKtK+NbH1Uiz/B6c=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQDXrbc2334183;
	Wed, 26 Nov 2025 14:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1B89XSXMYNHO2k1/v4
	PC7dNlxb50Aya9/hiUb8EtOR0=; b=CQHKJNM7ZaJ5yvB3IB2+BkwmM55E1CyTri
	fAKtkstLwksyt3Kav6jIQvM62b7xcG5EjIK0S+7aHtfUmSfSQqWjFYLPHpJuV7sz
	ToVCJbOub601jstPX+Vd94rY9+O0Q2Z893XLsWwtIrcySD74jpAHpfVVL/7AfPDg
	Eh+yiSaBVBZK80GqRCo6j6Lsq0MV+IDFtG0XudJp+ns2PrtqE4stSt8CB3z6yL5j
	bEQGoC+9FXHbEToGkEoB2/PrbCzR9KyMBM3dOTGTBu9xrJgaY125sjm+fbcnzLip
	w5P62DfKeo2ib2qMxykWfCPNl64KadwPRCFZy/TID9AWrNc+KOlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811v64x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 14:37:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQDU0Cr032007;
	Wed, 26 Nov 2025 14:37:16 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mb2y1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 14:37:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fb1WdBX38oFlEu641h5YA7bm/KlTlZAVTfNpw9ChV9OZkCZPTQOhM1tP7N5hroXC4fnB991HpDlb74vXoDDSTc0rXBAEw2fnfeUCZwY0yioMGxMt4+8pRIOplgVbr22OQe+jQZ/iKzsiwb8cphUpI6WGKrptoui7SQPxIqEoC6y16c1ZjKTpVx7nNqlG5Koir9VfOmFft7zDai7z1+qSVJsz+Yf3V58bmb//RSstWfSjw37wKAaXyrc/QCwp2V178q4AiWQgT1dlxS77OFTYiNqJd7NiPJkA1Xo8J5Ktf1idxH4y2E5QVKcd6IDouOq6Jatq4+yHkEWshmqh5yKgsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1B89XSXMYNHO2k1/v4PC7dNlxb50Aya9/hiUb8EtOR0=;
 b=zSC2uIkjd0iQ1gPgc926BJZdG88F8tor2rVeZBtwvRsCQnbPOGz4D2NOngmmIyCmxPyMStGaNMwWXd7KNEdK0Chbo3sBdvvhYGm1yfi/PTlgSnKGCgFELKft3o94PoUMaxjXWLFDgT98HNfe3FnUni3Y3qs3yJVGJiBBBRYIhnfS2SPf78X074XL7B+MGz5sMcJeaoYfpAiKUELllpu6vHN3F17PVG0ai4n79LqclNsdA1+JklgJbEXElsVvVBPYPND5cslzfxvNwCdq6+yhIjxJX04gvEz84W5ncze0KBy4COer8WsWXpLaOBDFrzcs+C1oodkmWwIlCUWtcnqyZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1B89XSXMYNHO2k1/v4PC7dNlxb50Aya9/hiUb8EtOR0=;
 b=UaMFLgaJ5QSPKVLclAWYUaJSwsUS55k+W7jntyq7KP4uJPKc/15Ku/y9wCqM6/0wvkHylqT7tuMeKOJ61dxxfFXyD+UxGBW/eC4wuF0jDaJTX/qpOM95S/EMmLby0WSgYExSjJTVbwnpkSs1Swgk5PZE7ijMvCgMcNhOk0iw+4g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7717.namprd10.prod.outlook.com (2603:10b6:510:308::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 14:37:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 14:37:12 +0000
Date: Wed, 26 Nov 2025 14:37:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Samuel Holland <samuel.holland@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        linux-riscv@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Message-ID: <dce86811-e085-48f9-a0b3-977238877f7a@lucifer.local>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
X-ClientProxiedBy: LO4P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e4a7616-a3ec-4a47-fd99-08de2cf94975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q9ZhhgL7b3R0kbSQJ1AAn1v6QV5glajd5oRlZF0VLRP9iWD7taBxnb2meZ+1?=
 =?us-ascii?Q?BFanBrSDEkef+ZSDbW/SJ3NSWCEOxnIutdx4P4s+c+ZTpoyjLLCoH40VZslf?=
 =?us-ascii?Q?Q9TGXAy+W4DZ8arO7iSzJBlIsDv/gyvNm7VDK34wMy+jTNVs2ZKQjCQANizo?=
 =?us-ascii?Q?A0xtsQbYjqrKD2FbIH8vN4bJD8in/QvAI1dNjFtoZMtO55PvD6cHLqFUK9HV?=
 =?us-ascii?Q?peP/TqTR8BL7xPkBfGAOaBEIiE8wUKL7nOdZU+IRa1IysRQqeglc78kSq93z?=
 =?us-ascii?Q?Xx+QrlIzJHoz43uGbHFyj90CGK/8n2NKwrxs0F3Sn3GNXW5y20xC8oyjrKZQ?=
 =?us-ascii?Q?3OkHaNviJ95jPr1NSkrmms6U41aN8EK6uJtRck+mArckFkAGALz7aO+Tf+gh?=
 =?us-ascii?Q?DtTCd+Lw0hcJlSnhbjRQUOcQg2RqTtjDNuOeDcv6u0DqCc0pLg09mtDcJUyR?=
 =?us-ascii?Q?uTDDm/Fo5cBnAE0IOV3szZd6AunBAUsMzkTiKgY+Iw6d+ldAKjUrSeKjSsyJ?=
 =?us-ascii?Q?J+QgUuApW2/E14wyD8SUvZi6IVdroIdrfEyg5FY53q6s+1F6ilFA5fmrIju7?=
 =?us-ascii?Q?r4PjaGpG/DF4Uu4eYj9ouKowHq86wSjBKn/GgfAoIi+eGzikHP8LCryMpW9P?=
 =?us-ascii?Q?UQ1EwRmFInKB5Dy7FbfAO+B62DQFWagMdEY7pg0Iv5tHV0+p+OWPIH10wlA7?=
 =?us-ascii?Q?yY+l59OtV0fJ+I4to50CurGc8mrKAyH/LSgh7UXuqo7QmWsC9++hijElt04P?=
 =?us-ascii?Q?gXC4KNeN3+j6lHvBavq/8FEwTymu45rUsvnArwWD51f9Ff0Xe91asLlHL5ww?=
 =?us-ascii?Q?Rktw0c9aRf6PrBU35TJCAGfbsU8CfQGKhp3WHWYtnB7PwEZWPTmPR8+sKj53?=
 =?us-ascii?Q?BgrbrfFgR8RrBOKFxdtZJmbFwVDpf5nSSCbgx4323Ii/2T4KhSo1JAZ6yyLS?=
 =?us-ascii?Q?AfrlSpNzpm/cbQERT3uG09Vt+hUspX9DZxCt9sqisCWjyMK14tlPy+9Wx4OB?=
 =?us-ascii?Q?XEtbOKrLUPPzR32gQsm0FEXkBThwwUPFUedeL+zces51UetVuq5CT9Hqepv7?=
 =?us-ascii?Q?9yTgVWnr0GZ+5SrPNb0tJrZMt/8VRm1441fSqt2giNysj4SA7J6Rs2F1nCr1?=
 =?us-ascii?Q?niDrn/py07R7MxTZGipOKY06dWGLxtbf8+lCAUpZ1CG9Np6lkmaki8sgu+qf?=
 =?us-ascii?Q?/GiZo//SI8G3gZeJKrx8uWjFy9zJuwTIyEZmoOSFzEhCuAXjt1fWD+TZGQWM?=
 =?us-ascii?Q?j9PxCssN62rv6waCLT38/s0XZOYpJPPcPPofxZffpkxPQMlXyn7nibkGEAm9?=
 =?us-ascii?Q?IjT+7wZDORI9B0EL2hCeHNfzeYCzXn5yALgHbAkBMIjvBtBSIM5KLrm5YVNt?=
 =?us-ascii?Q?dfqPcHNEPI/6PZClYAlb69caBdEQVOf4dRHRjbWdIUvwowIx6A05qXUN6fj2?=
 =?us-ascii?Q?vK7drIBi9ObET7MvFnnHfpysK340QAi3ePkYukgNDVJ1HVL72/8YqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h293udklmf2SllUA7/rj87PEwtDpDN8EVK9cyFp8hqhSVNE7vl092SDGJxIc?=
 =?us-ascii?Q?ZObbTBlToVEx3Nj26t05lZJ6bSr2TcExRTanycKndOWiBFyX8EEPljSaoeGT?=
 =?us-ascii?Q?Iy3JO4minyjKTsm0pmYsPMRgMAmtKisMaoT9p5gxk1Rgg/Wd9L0VPswMLdee?=
 =?us-ascii?Q?ioKNQ7UqFE8Cq61TJJm3du5t5rNNLAxIgM0jTunYi+umW4Dt0gu7xJ3H2Yhe?=
 =?us-ascii?Q?Pp/vvRPn4Ixf++yPqePpE1//OvRrYaPBViel7IENi11oORTpGrvk9tT5lHgU?=
 =?us-ascii?Q?PBuugLgRwkZjXs5cqDP3zWfOnV79J8fBeMaxoYg1wKY73nDKYEPcLKRB006c?=
 =?us-ascii?Q?6ipVpBw4I/hZbkkDWzKk4jKwXDUIfoLSbn4NehEOgry0+PCU3v1C2yJ4C2Ph?=
 =?us-ascii?Q?46dea6dOanr94k8Nz/suxUe7cbKSas/mLye1IckdQsoyIa4iqqgE02s18YHy?=
 =?us-ascii?Q?CPpdImC8sjoDIElAC3Tq+2iyKKh+nvibGYYFx/Hp4n3G6YRD6E19EoUecDNo?=
 =?us-ascii?Q?d32M6LnvRh6/iaT9kYPnpyUaxnXuBXs3slH03Rqbce017BncfdbWirMtDVKO?=
 =?us-ascii?Q?IzEVVFvb71vOAIudmvfdx8fg/GXWwArXA+dAYLhILceEU+r67FWp2pMGtbI8?=
 =?us-ascii?Q?Sy49nRAI7D9Qes8/opSHZQjMNvu/jMWlAwJDQMAfq36udSMRCU6+5ypeuG3o?=
 =?us-ascii?Q?WYKaxg7NlXXZtm4S2PbjSFYXSMa2zjPPeMJNurSqpSpTz7oAk8BEqtLLWVKm?=
 =?us-ascii?Q?PBl8ZNQp5k+UDNrTWCQKNjDSe6wK1VFisDwiLm3xZ4sU865pK/iH1h9u9pdY?=
 =?us-ascii?Q?7EhjWlp6HVH4sYa0kKhoJJ9qukMJ4FC7usIVyZGRy1MhUtLrFew4pekH84Dz?=
 =?us-ascii?Q?4Zbp1asZldgYKU05j26wlb2LM0How8+EG15x3TjIMu93Wrwy+m+1W5UvKOFR?=
 =?us-ascii?Q?THR9AUhzF0yVh/UQcXCfHpxn9gyw3ZI6pTuLTYPc7Ik5wjeWxSW3D7JDEnhP?=
 =?us-ascii?Q?k4GdB9vpgdE7ASoTNCsJDHh9Dp7ww57f4qwBFYdFm0t8LAH2gAf3CzDRnDPg?=
 =?us-ascii?Q?9Cboi+p66ANHcisL5z9KJf7oVJNPnNO+0ffxZf1pYrDzIJuS9rAQ6NSSyNqY?=
 =?us-ascii?Q?MMs6TTir9V6gh8+ERITeX9Kl0SD+k0BBCSXuyEQgLZn0mRe/qIM6pExB+hXk?=
 =?us-ascii?Q?87M2HOHUrusJZsntzox7vu3K7T9955VbP2z0rxkdYS3xKBVMmmDojssl7rGm?=
 =?us-ascii?Q?d8CDBe12jErCx1lByu1ee4b11S1fX+Y3S53Et10PA8ZB3O8bs51L9M4xTWpo?=
 =?us-ascii?Q?6LZlNbAlYOpSTfN4nkJcM97Iy5dIdUnhANX0uFeA/CGTJL3VknZhydQES4P4?=
 =?us-ascii?Q?RxYkz/l82xHEGf8Nj7iSHrRMBZZvPr8cYHQ6yO4lG/Vcn2oqI9orn1UO/21R?=
 =?us-ascii?Q?Sg80+sqOVe6tnMkBFctdZp2V7es88UBYTnoRYBKZW0W/i1pSMdjSG42UnERB?=
 =?us-ascii?Q?u0Y5w8MZFagD/kupSUJJyYfnzPooZAlcdukT6HcXN4GcaTYPo/8qssFfl671?=
 =?us-ascii?Q?/eWadOQI20GBllGC59gWezZwKWDrRNzFSyOZ1RDJK9YjxyNTV51LP3Wlkeri?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M/1WOXBDjscwqOVr6srOHZTIVeu8UnO721sOTYDbLrXZRICnmQU6hc0aGPTwDMns/ILbH4SQhj8Yd3exsviwGcIMY9KPLubMkXwQe7E4oVA14iFtMI5SAwaWW+HOxSxx3ZsQe5gr5zmR3awi1aSVmeCkUYcz5VWHf4ogogLq5jvWvKeCAlcZ7VO86ZEmSPQEeDhA12GIW9EQyooUHJVMjBggwk4dYBNNe2voYVoVB0nbVEwtHCE4iMfeEQGsuiZOYTuFxIgXxAB/Ft1YCN/3j3oUICKoZtyM0b+SRFX3rmjjvL7wHsMsMLUx7OEPMEVZ0nKLg9rglp+Ud3JaCYWs6rhdjILIlmEwkcU9ciasL8MCJcSnC3UmQ7HRMWMSr6sqZLOgytoqr1shnUXPH5MTCqKWRsu3IruUDfUZ10J3iWWxlYSEd3DhR4pa9KjsirmKYuEy7QVNXa15dziTWdzYtiPxxKlT7T9g6c0APxsjy3MberwOJy9KtIyYGX2wIDNq0tNayrhHGdN2GOGBX9Dv6frVhkR05wgu/Qv2ZOXwQ6t6JmyaRG+Jeqa+0AXu3ioZrG155i8lBgx2vlPY1ORmJrA3r6MvHcA6TySRLIg/+WU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4a7616-a3ec-4a47-fd99-08de2cf94975
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 14:37:12.4948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OoI/9IdYDfc5qUCo5KOKkfwUMEpYYer53fDl9eSeaEIcKm2nv4gNKHcXpf4mg21VAEd3kBVpMk5Ma0uOqPkYpuAOQYXDVVoJJuIqwKfSnTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511260120
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEyMCBTYWx0ZWRfX7qeMfVGDX7b+
 Y5SllEsDMUULMeHVMTZehDTSoUfp75VNPdlJMeITWv5D2kOvs9E4Q3sKJeHgdQcN6BU+jwccyu2
 D1sgI5vitYy2RpsvIEDBZmhE6F+XDIRRVBpz59ZWF+dwXkglpZNLp16lxwN+xvQ5k38si8ovCmj
 cN7WwkkY4zAp5G6YKi6NWn6OE1UgpHdfwp2w8i76DzYfkbxOGW2BJpaH+3qF61NPQk1f0hOpbSV
 t34Yt4wGNz6BMPnt1IIgD6RAucbPiOx6wctEsyj1+4+Uqv+BCoANq6PDSVGLY5YM4iUivlfoppm
 LiK7UgQBYI0R50EZIs1aqO3nkgPq90pCiUv7nmz8rx8nvi71BJO6YbwB5InGcEAXQD+2dzNKlQT
 V7HsaZGGFDi0t3nCUi3WxtTxKMNmGQ==
X-Proofpoint-GUID: ULPuvVw5Yn4Vnr6hqTI-kL5UCW8r_5Pk
X-Proofpoint-ORIG-GUID: ULPuvVw5Yn4Vnr6hqTI-kL5UCW8r_5Pk
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=6927109d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=gwa3BHeIwaEix7MB3NMA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: CE40112000E
X-Rspamd-Server: rspam11
X-Stat-Signature: wsfckwug5ywi7sp5tuj85yc4kczjtc79
X-HE-Tag: 1764167855-885918
X-HE-Meta: U2FsdGVkX1+e1xPnxy3eQ0u4vssMEmPuvwaw9xlnZnTgxRaBpWpzuJCV5RWJRpLOgRqkdqEbmEpb5C8exgh3/rSqy0C53/byv0Hdk3w5ip4KkTF9QZLt/u6Is9OzV2Yq/LIRM9ARdKJ3L9uG3ocQqsD3ZWOTdVLgVdmUA2GITEvaN7XPBo3NbY2xzPihGrTCAxqLoFF3TnKV5T9V6h+4VpEPDr3O2C7LKqM+bBeAfvPtVrdHz3oIrtGBTAI7qDdjK48TIFqo5W4YaSfjxr7xYBby3VG38t/q4vpC5Q8V8mf6ihnq+TUv9fHXeaSUJZ2BeJC/5eBC6vor50lnZb3eocEek+Srt1S5MaeZ7By72+eNNCUxUCmyKw3jnhTtH9+T9ZOpxrHGEvhxkzuUgNTdvlqwLOFpvL/Uy3It/aDnXvwxlZbrp7thvkvgjl/JfNxQ8fd3j443v5/Kkmg2YIbxN2A8PNYF9D3oP6xUUW1CRdgpFpwcEdEJPS9kRmmQzr3gc4EPOKMNkMTt8eLpXCChdF71lEG74bNRczMwy5xnit7oFKEHVe6c93p1ffhezAUmUITchaXZdFRngDBCXYdt8cafIUPaG4Ws2nzHS7ymAnmoJlww/ct+UB6zsOx/w04aFrv7SCqHg5tXWcrBWAENyLEHXTOjyNW/Vj2jp/4zxkBU1KBxBAyW0wR1w9OdM4zkP6C+SW4xNFfZZpMQZVD/VteTSUB8xllcUeIJm4slRVMX2/xdAZwekRtVZRMiRyuHENQLtXoq1xU8ud56Vqbr2Y8AkLz57agf7pRTs1Yd46/67fC3RVr0zMqbrTZa8BQP9u1OB7Dhy9wKrZTQpzkDFqtc8uA+eVS3308aJrdTM8eyUk1f8N3IUBFsjBcCCQYmW6ciaNwZXJsfTwbIV9r66f3Uc+hQyQCqjsqdyPQUVSM9Jh5L79s8LcTt88HrIZObiI+zI1ydY+cWWv8UInk
 6WBmRHFj
 gFow8Kj8d7s9RNFYo4tYBcmwhDwrCn5G/q5qhHbo2Dlwr2HuEl2r7/04Cjde2oBrBN2yznr71pucWdJ358mro7/TMNSm7jbDmkvMCY4Qu/syLIrywqvKCBpG0AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 02:22:13PM +0000, Ryan Roberts wrote:
> On 26/11/2025 13:47, Wei Yang wrote:
> > On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
> >> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
> > [...]
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> I've just come across this patch and wanted to mention that we could also
> >>>>>>> benefit from this improved absraction for some features we are looking at for
> >>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
> >>>>>>>
> >>>>>>> The main issue is that the compiler was unable to optimize away the
> >>>>>>> READ_ONCE()s
> >>>>>>> for the case where certain levels of the pgtable are folded. But it can
> >>>>>>> optimize
> >>>>>>> the plain C dereferences. There were complaints the the generated code for arm
> >>>>>>> (32) and powerpc was significantly impacted due to having many more
> >>>>>>> (redundant)
> >>>>>>> loads.
> >>>>>>>
> >>>>>>
> >>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
> >>>>>> this out internally?
> >>>>>>
> >>>>>
> >>>>> Just stumbled over the reply from Christope:
> >>>>>
> >>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
> >>>>>
> >>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
> >>
> >> I certainly don't like the suggestion of doing the is_folded() test outside the
> >> helper, but if we can push that logic down into pXdp_get() that would be pretty
> >> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
> >> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
> >> helper. Although we never proved it to be correct. I struggle with the model for
> >> folding. Do you want to optimize out all-but-the-highest level's access or
> >> all-but-the-lowest level's access? Makes my head hurt...
> >>
> >>
> >
> > You mean sth like:
> >
> > static inline pmd_t pmdp_get(pmd_t *pmdp)
> > {
> > #ifdef __PAGETABLE_PMD_FOLDED
> > 	return *pmdp;
> > #else
> > 	return READ_ONCE(*pmdp);
> > #endif
> > }
>
> Yes. But I'm not convinced it's correct.
>
> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
> P4D must also be folded, and you effectively have a 2 level pgtable consisting
> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
> was already called and used READ_ONCE(), you might hope the compiler will just
> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
> there is any guarantee of that and you might be in a situation where pgdp_get()
> never even got called (perhaps you already have the pmd pointer).

Yeah, it kinda sucks to bake that assumption in too even if we can prove it
currently _is_ correct, and it becomes tricky because to somebody observing this
they might well think 'oh so we don't need to think about tearing here' but in
reality we are just assuming somebody already thought about it for us :)

>
> So I don't think it works.
>
> Probably we either have to live with the extra loads or have 2 types of helper.

RoI on arches where we fold PMD maybe make it not such a big problem?

If not then 2 function solution seems the right way.

>
> >
> >>>>
> >>>> I find that kind of gross to be honest. Isn't the whole point of folding that we
> >>>> don't have to think about it...
> >>
> >> Agreed, but if we can put it inside the default helper implementation, that
> >> solves it, I think? An arch has to be careful if they are overriding the
> >> defaults, but it's still well contained.
> >>
> >>>
> >>> If we could adjust generic pgdp_get() and friends to not do a READ_ONCE() once
> >>> folded we might not have to think about that in the callers.
> >>>
> >>> Just an idea, though, not sure if that would fly the way I envision it.
> >>
> >>
> >
>

Yup obviously if we _could_ find a way to bury this down then sure. But having
actual page table walkers have to think about this is a no-go IMO.

Cheers, Lorenzo

