Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38458CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6908A8E0010; Fri,  5 Sep 2025 05:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6406A8E0006; Fri,  5 Sep 2025 05:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA458E0010; Fri,  5 Sep 2025 05:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35F058E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:50:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA582160594
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:50:42 +0000 (UTC)
X-FDA: 83854727124.18.AD9AEDC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5AE4214000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:50:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fPctjnz6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ami1PHN0;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRu01T1rjrbQSRy2tQJ0aEXpivySHd66wsRzecgc+VE=;
	b=d0RtVKzsBz7Z6tAl3exAHeD0hXv6HxTKmBqrdBMEduM3/DJCVeOAyT5xUPq5Q/GDuKJOIY
	u9jp02SWiT7u97hmK9ppkJUyKwVouM5lihuRPImnvZemj9VP80GDZ4G74DjC2evpnhCuMr
	JhbSCwb6z1njO18QYcXJgkWt4ZXI5uQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fPctjnz6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ami1PHN0;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757065839; a=rsa-sha256;
	cv=pass;
	b=26CffCpWgEMzTjmsCDqZ6nlaO+fVfahoZZb7x74gYUnKKk7NlK5+/B2EO/B0kpAYoS4T66
	wYtZxPFfOY+ZgqWjxiO1ZC4DUF+DYuTE24hRitgcg9LW/ptpjkO58bbiBYdN0zu2jZRud/
	yf3eScMD9XbmnO3bCcBa82g+iBpsCaE=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5858Ysck011084;
	Fri, 5 Sep 2025 09:50:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SRu01T1rjrbQSRy2tQ
	J0aEXpivySHd66wsRzecgc+VE=; b=fPctjnz6sX16RaeWwak0TGX5XsE75CugTs
	Y4WLYVlaSti/GRqOhlvfElcYbAprKjgOH6gs5n2em38oZdbBztwh9p7TBKWBDTB7
	btVvTS+o6CInVa9lYoyGQ9uQRPjRPO0691LJ6HyHnSGytVqtBI+muAYwjkA46682
	XYvRDz4A8fVGcfbdNNTnDdkeLM7R3MJoMxJODX1l809p1RFP5OxI/a/kfsRgPgu/
	6RmapYjDkvWU3wFWEhzY0eM6Zi+kpB4W3TfWgPLb9men2FA4QvZ6lTNh6MWUtkXi
	yPAf193kOcWEBfb6cXu09ProhkLO4Wa8UCsliYIb6Hb2E0C/B0xw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yvfj858d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 09:50:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859JeR5026324;
	Fri, 5 Sep 2025 09:50:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrct25x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 09:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DaV0OKbO9fI41WKWmRYPQ2y7lEQj6FkQX7steFJ5MA5ZjOv2W0M2WZqTHKQbkWT5sy7v5JbJi4qSzYnig6KYQIF0Kmy022yFnBHM10wjdtTlDEnP114O+7EfdHv+gBIfp5n4eEmQ1y0QsB6XmDk2Mz+Gyw4kPD4Mot7bTN3+68q3K2yatiVYIQHfgaf/hX9Qr83+IW2SR6FmbP5nVGerVLfufjZZ8ZLzlfAITweyY3EO1eoIDLjUEkCjErfmBv8MCsBYRc6VvxWp0LfFSgDiuQDrei51A81vXCKXYLHRtcps5noRf8mes++5mcxou7DNvm7Ne/r1lKZ2P+e9fW+Gxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRu01T1rjrbQSRy2tQJ0aEXpivySHd66wsRzecgc+VE=;
 b=tDOeF/Ww1Bo12FPGZRnNjewRRw+Lz8xfBgNIc3RVkUilYP92gnhyPD/e3lRBenAA67fqqIjXVEQkIC5lXvsn7mYYLlAKU0jgraQ4Vehu2GSSufpRkgk8+yP3pC17p+mtSr7TUzsMsSKADobuU7qg8QacePf5Tmy+Ayj91WRB+JBWcq8op843LjPR62ngywwMAuc+nB/5gvnLz/09hnicwM9Y0Nuv01TKIjwIG5SEcE2sMUXAqLgtCEkARojmILjJ4UuQNT8NB++LG13z61qPYPe5XvLgZiqhktOEQAIExqWjG9nGX8MJW1SEYCJlVPi9iZAa+rd5le7N5aMvKDS4ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRu01T1rjrbQSRy2tQJ0aEXpivySHd66wsRzecgc+VE=;
 b=ami1PHN0Ss0ppVTIx4dG0I4S58m16CqUxSDHV3ug1dE91+y4By53XZSpweXy1cihOLOY1tiHmUiaUfcACFMNDiRyn+KKNl1jE3rSudP93c7on+JSUpibiM89ojMQFLuS2A3Y2c+ZFf66GbrE74Wl4YzyqdRQE84jpCT1cu3J8gc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFA0EC85B6E.namprd10.prod.outlook.com (2603:10b6:f:fc00::d3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 09:50:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 09:50:30 +0000
Date: Fri, 5 Sep 2025 10:50:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add tree entry to numa memblocks and
 emulation block
Message-ID: <c90bee78-caf6-4ef5-bebc-5a2888b54004@lucifer.local>
References: <20250905091557.3529937-1-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905091557.3529937-1-rppt@kernel.org>
X-ClientProxiedBy: LNXP265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFA0EC85B6E:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ef1b78-7554-4684-eced-08ddec61a651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d4F5oQ2BkVSt+J8x0hF6e7932MkDIBqvLQUxxejsnnDYdI/eMHdxELQ9AsOF?=
 =?us-ascii?Q?5+nRWJjvun+fskmZJs6ZJIygem5KvZsQdlI0ouyS/FhayceEqgx6FfcxtOL/?=
 =?us-ascii?Q?+zRG0grw4BhlP1bu6eS+Gzjzr9Eo5vlOGRWcZ4Jd2fxGjDiPkUyq9eG/14f5?=
 =?us-ascii?Q?uf/BdPWF7IS8xZdaP4IudkbEuyqy6aXZnrFACQoC9XqmQiGrMH3yM/VUOiXJ?=
 =?us-ascii?Q?l0rzHyGzZaO9gNvK2+7cs1Zo7pX5uoNoqsF1lgqpQXXWXO19MsJXDI+5tyAF?=
 =?us-ascii?Q?+jVBnmPRE8PVVkeKeqYQZwhWUsgcLz10eEhtRjrH6QY69nvTmuLcCShBtGrA?=
 =?us-ascii?Q?o+OLqeBDfWKtDG0ygfKi0C5nYYSMBMfWBbQeQSNf04HO4qp5T1WPpA2EmKj+?=
 =?us-ascii?Q?jWWHdxMmPr4eoecT3H+8AT4moy6qu9z+WAVv9z40geeH7Rg0o0UJIj3tIT3j?=
 =?us-ascii?Q?9iqjd0D4NStnGDSKuH/iQt7Fzex75fLz7HnsYmKsHL5lWd+6SvqXL7Fttno0?=
 =?us-ascii?Q?YgTdhIc8MoWzBTLyUB7C69lgZsVHYUZwiVPIxYTs1rM8WNNioTm6+rxR6I5i?=
 =?us-ascii?Q?GAa9pSNX0Y40FM5b1hi1uBI+y5P1iC+eV4Z+ItNbv0/VCymYYsdwFSG9q/z/?=
 =?us-ascii?Q?+eApWhfmmg1SCp4rJ91iAeICdwXlD20Vkar3oXQmP0ACfGGnMAS8JkDMXvtn?=
 =?us-ascii?Q?9+MuksVn4/EwmMtavxMdryajQGkGEBAmmWT/uHgwi2zWLQCDvlbPbHr6QiEg?=
 =?us-ascii?Q?JCPESkyXfXVs5SFGohEvh1fgt+Q/s+VrPAysA9arw/Qhg6jD9998i9puaMxy?=
 =?us-ascii?Q?QsrJepiFva4qLVthCSkme3NQDMion2zPrm5jfXUEIFWCds/ZLu3qxjVVeHDX?=
 =?us-ascii?Q?b2IpZ1Gx+px110AanQovgL2x7lPyG8A8d++uDcArz9s1IWOL14fdTWeHx7wm?=
 =?us-ascii?Q?bAC78s9+ns4717+HQnZmsnZ4Xb0CvI32TpIhNjig2E57x8f6O8K/3by3ePlE?=
 =?us-ascii?Q?qK7XRV1Rc7RC2Ni0c/c6W/KKh4utE85NmRftOKRwFsydZLBYwaqolD/DlRLR?=
 =?us-ascii?Q?hlFWYgVmN+eQ1u8eaR0APuZoKUeURdh/Ct8QZHdfuRouh0foMMtgah3H7wJa?=
 =?us-ascii?Q?9HnOu57wN94Yb5qP1Vb2fFttFQEawroqvErMJA997+5Su9guZ3dr/PVXVsVD?=
 =?us-ascii?Q?wvqcfyqR9RzYHjuwrXlEJ5To9SBJokc3nmyNpN+yteFl/k/CHPcgYjIZmasS?=
 =?us-ascii?Q?TdMFGRmaB5G+lj/cCuH9rVMdGxM8HB9v+KP731ASlzo5CW4m2bWS24dcIgAu?=
 =?us-ascii?Q?ZNdnOMVa2dSMaPGtmpXWxfzac+OwFKXYQ2M6GCWbx0RaOCIFhQwAx10REay4?=
 =?us-ascii?Q?KOU5AxbeulDaHscwcEaJMs0lbfRk7+zvjndWWfdJaIoJG0SZ+kfVuLrETLpd?=
 =?us-ascii?Q?olhKgZ+CT2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sLUMmX4yp+R0AdlEUowAKVCNWJowDWEAraCR0J64yxCFCk6MAuu1yapqO6aK?=
 =?us-ascii?Q?nvkUU/kFu8KbEkejz8g6xgg3Fj9hSQ9KXsx415DNf8cUH9IkSNAhn8w6O8+e?=
 =?us-ascii?Q?4XC/2sRqUGUfc+7v+KoLONjgU9WQH1aC1k+NTvmGsHCqwSlqRO308W/tmToy?=
 =?us-ascii?Q?smlI1yyg53e/VabrDXqvzomk96LigUgCVsxmTdyd04BTop1IL+dgFH1KP1z8?=
 =?us-ascii?Q?HJsQYYzgxUUV4UbjFhKXq+AgrIgiM1lR0egKSeOou2qlkCrhCfX6/44p7LgI?=
 =?us-ascii?Q?Di70fHaNgRqGQgbyxUWurzaD5pW67itzYW2ZYc9CEMmynwMA5beg9fF3yFQo?=
 =?us-ascii?Q?NyNIvmvsjirlPeCM9uTimC+hbmikZQCJBWO1K2p9FLjpERvBfImcruHccJai?=
 =?us-ascii?Q?JwCs6iqJX8TognPh17Ear2hu6kllZdYY+7rpSlVpteEg1uk1Tx9i3wJ6M/lg?=
 =?us-ascii?Q?tpoiEY+NEq/JOOaNZfgPvK/OPjc6MW1EGGakPXV92LgBjHrND0k0wqUq2t3A?=
 =?us-ascii?Q?H0AhP7VrYQcDwzRGrIHHmLABoll/H62IDOSOUvVGmSBgI8HJ3Y3ZqH225iIV?=
 =?us-ascii?Q?zIASSepCoVZzDqlVq3ye+fTvmEvzg/iE9NM95geOoXR4vj3fYFPsMHKzRTdm?=
 =?us-ascii?Q?scvWhG0SajlMbtz523o/FMghTczSf2FuoRIRCIf9lw4QfH2Po2vPPR2Xlu39?=
 =?us-ascii?Q?P2GuUQb1i3kNhHTIoB8NX2O2+/dTkmwLzlzqOqXWbfqlgcH6KlrAi24EUHjc?=
 =?us-ascii?Q?PhQaLBpgdvW0jXETjNBYVhBSvYmDALbjL9tydE/n56I8v3s41DlJwweobN/N?=
 =?us-ascii?Q?D2i122U9dGpibGnKzUHUqcormKgmoakHQb6hzRIy/P3JmcDFe3FkSAEhG5MA?=
 =?us-ascii?Q?EWf4W6u0fcqlcuYrts5H8JCogmTaSaxoalU19wLY1OuA9HPPkis0T3wL0GNg?=
 =?us-ascii?Q?adNB6a3yKLUWzoxbf8fVFv6ZC9p3F0Z/bgM7wNjpMoNbeNnYd7q4jD/tYe9q?=
 =?us-ascii?Q?q1eiPtg1xp2ezacWQ82PPGzSMF4xE+4x/F8mRNJG66F8dbfTPvqefqM1T+Ot?=
 =?us-ascii?Q?NbdzrnLG6o6kiAqzFYpviNlt/3WeaLKkMRVgRVCacDIhUBIVA/3QTDiyjmrM?=
 =?us-ascii?Q?7IUkouv0ouCURi8ePJIAScy7NtCbyeq+B0nyjYeiOTTA4qQlufl6PLIkj1ta?=
 =?us-ascii?Q?1/ufsv2z5FPg4Io0bo8H0SDkCnmUqb/rIoT2/NysboZIg/RZr675dY7dSjqJ?=
 =?us-ascii?Q?58ss5n8sXp3NTddSFTaB0saOD/8ImPkKwZ4zufyj8q3iUFz4lYBLDEVWlfAM?=
 =?us-ascii?Q?3wtxN9jKD3LJYsoVM4H8mM02zDBsyllx5oWpEnXudub9cojSVvbgzNbSTu98?=
 =?us-ascii?Q?+8XyCLGpBEbXmzVE9NN6IUDYeLa9Iq8m4FJk3CLaryj2uIFRn/r312Fiqs08?=
 =?us-ascii?Q?+xmwezU5AufIP8JOqgKfOiuJrJByZdmdYeq+6hcUWpCcYmuEh7iVsuyWuszb?=
 =?us-ascii?Q?pewP0CDVoYDljKHO0vFqjPXqGz/FqW6dhE69U07OoYWE/2Brzpfy5qUtY6k7?=
 =?us-ascii?Q?FfD9obseJQao7w9m5ck2j2gc2mB21HNpqIFSFELd13H0q+EffrhwDFAcxc1k?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M4peBtloQgIhArEYGBLA0dK5yCILTsuGrknw9zmRCWptCErwG5/ya6RvuDTZEhNyWKOXAcp52QvT9PBu+LS9T4mcOMbAc/yUrr1ExN8keeiWZBXx80sRtUJSEqDtGag45sdvbqsSTwaCeqvyJkqGotyjz34lz7BlrwIo5bdsIV1NZjHmFGvKc2SP5QT5mBrWA/aV4H+R7l9luv/W7KPhv+u03lTveOFGpyaBVlS4Kc8+08JrCCKhcN926h9fJHD4e0cngtVm94wVP5k0zoSWPJL+Ll+5hKP/Fji1mTVHei0RHyqlLGY6XZp3GfIKQVrEafZEQJCMOdDBTgDpad3jL747B/dVk68jsmG5nXQLfEShWLsHqh7CM1kYHnZGwSHIlLw/kvbAls//9Zox1LUsL0BsFqlpnXEzvMCbYucNb4kwiQLofJUuvNJq2tERGec0/+Y5I/2JOZSmogV6yjBJa3wJuNPDoUks6acjqFLtEH6MHuOQgLZZJ16kbcTCVly1gBvFoEpCL+XRAlgkD73zmbPvugPPgmeb/1gv8WKGTGoXKgEwLaDesq0sSZYx7FvrpiTspCwnpCr8JtTmfiurivH9yF91yZweUMEkZM5gWZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ef1b78-7554-4684-eced-08ddec61a651
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 09:50:30.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdgcB2VTqRHqqz+CMvT5T3RalOMrLKKxywHz3dd1ZRMjZwS8r68UqlVCCTVG5Ic4pDz39oCjK5vk85a4XBpggnI9GXD9nIFl7RNmfi8ERgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA0EC85B6E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDA4MyBTYWx0ZWRfX5acTlZbFfZ7Q
 QbP6fCFvFpXpJjO9jHFSDPswGrQ5yNefJeVyJzvtfNg2j7NySLYga1Bok5PJdav6SIcfOR9sqZv
 nMD+//9EQY7Iiz+zGLjmrIsl7Cww53mtc+JBEKz+jrvy5PQJ3Dj5HGrKUe0aUnZ5ywZFLtCEjLE
 Vup9XQWYksEGZpmZfRhcxF5wNqQoc0vI7QCElgE1Bp60pu/jUn1EeT+Gdm1W4Lak8/BzXBdbFqb
 Kg0ayLZblLzFYsqikuagyl1+x2kBv8ANGXUDuWMRM2shPqkmm23K0TVLAuwMqEvvOrzQUptUfJm
 1WXzoZBXmcVc+yqbOqmhQnV8z5m5jeZgE0/B6kRXQUkHVx3r2diBPSPVXkY7cx/FPudGgL+ydIh
 DkFK0yyrtyCs3cvsvARy7bll3YfcDg==
X-Authority-Analysis: v=2.4 cv=YLCfyQGx c=1 sm=1 tr=0 ts=68bab26a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=YIHSu9woa4VAQ-aN_-kA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: Gb5b_k_PHu_VVVmdwS06o3w6hf1yfhrU
X-Proofpoint-GUID: Gb5b_k_PHu_VVVmdwS06o3w6hf1yfhrU
X-Stat-Signature: 88nho4uhdjhgji8bkcby9yprhsbexxue
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AE4214000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1757065839-828663
X-HE-Meta: U2FsdGVkX19D6HVTYrEeFaQYkuN1i36VlHoTiqoXJbAnHjbA2+FDdlR9DgaUQK/Pr9gnvJuHtDCprZygAr8ZS6ElRYdjblwHLVVI5DgeNDRlqj0MWnPqQ0X5AcT2o6PiLwAjRV0eOdcBFcZr723G9+HdtNeSYY9r9P0r2D1sav/SDw5A0EklBEwf6vY2XtoKufCmGV67q+yWCJVj7heRTfkit5BO2ybuDDNOrUFFaQ+otG1JOh9iIvWn080NsG1Ce6NomzQQz8xqiy0dJnZwa0dU0tHw2McQM5DKahCJ6t0xKuL2ydm04AhBAKZnYvRgNEDLyOtPFCZr/u3ZKlDv35Ywz3co2ivzGKZVy7cIFNqNEiS6XltfIxPxAWa6iHgcO/xIlACFV516IhyHZm9uH+7iI1KjMGg9g/ioyOo7TjJpBBIwRaHhXK5Mv4C8o6Ey1tc+8Pbe/MYH6Km9LNGomEhkt7trA4lG0w6DKv4veoy5iz6kWS+1u1ofTi3KF1sj+3coxtcjSMZ/2D3YP9G/TSBfgSVhHmgWo4xWZf5iHgPrdzE24vDHU/vLjpDOIxP7e7Bslp7q0d+KDb/BCO4PlueVUI7pMSw/ujrgNB+NecbwqwMSY/r0bb92wCkRHOpvMdkjYmBuwQDAKC4/PEnDV8PhxJcFtQ3K4P6NUAm+Cr6WvvEJHKXi1jqJJ11D9JRky8Oh56asAUc8fMIYZdDtg9n71RAX7limxZVJZMbUxaRT19st7RQamo9gjfsXqutBSZgB4t7K3X4Sa3uEI5/7Clp9YC9bLFP/eoln9dQUvGHk/wJzwWADZlxh5zTm95Kp2NYHYkvzEc55bIIWP1XE0jEF1V1IEhZC9TypaCR19hb4ovHdWjQUq/KU3Cqf8VjnyTR7aTkNQd/7ufjdCNMlu38lEppFdcQnVI3CfgDEUd34LzULr8hn05ZQWcWpff7tzfWqTbSH09rQzbdNCEL
 iP1xqS5K
 HJOlZ5nXAc2JC7BgX6D6jtuAd4KThnGBOH67kZSoG9BrJ9tPhq7M0mNzb91yTz3dz6a4L3u03w2MJGT2ndGpyIyHGPlFZYQbUNsCOWKs2x3Gn9Oh+XCHVEEblQjQrz4Gdrl1VuUqWK/LA2tTNEh4t0r98j7Q8b2tUWew7yeO55AY56sYLHtXWRmA/99aL7V7XTQ1wLI7rFtAbEuhUT3Mru3iNM+xbgPxwlYP+p/B6tF1/NY1c4MI1MKvH7nwnoJmUm5Fp3X7tcDBbutJ2XvufG2Av0LsZ1rkNfyBSK7etV3SeBIiRUT4HoHr5IzjzJZsJarEpv3bG2ba1rSN+DleZWLZD6D4rm5sUh/ProXlUq2wigvB8qMkfXbIcUtksgP7yMwfjCxFKry1wW+vHUbpf1IA1O5iw0QqZT6hvFaUMSo1rtSak8ul9XQZL8V1e7mdMoBc+CLCRcLuBMWeuPfmGBbvSh41x/k6N+EGmF2t0uCcKRXCAXPKrAwpnhQhbSHnrNjUZx4O9u0/I8NraYlYZkj5n2O3wToLXkDE/qG9L6JcEGSf2QProiSgOrrTFmQfK/uDs1SUeDWAg1/4uoU29YgeDv8Pk2ml+FAM/llcSCfh9+LwDBPvKahY/5/qP17OJ8FEsNR7CjtbdMO1j3M6olpY+JiWDBh809JCI6bVOER4JPSJfwhAsHK1/5aaWZ0GyC79AeyTdXM/fhf67plRqo8yN56MJl9NsH+b4UJCkUHpxPGXbIvhdVQsW9zYfZ8XXhSSDzLyiBS238Ypkwaz7HgwnczwcEyuloIQwmE9vWpZp6SGAZikpcyeDTp7hD5B/LUNSEKrepBNDAvLwn9OCn1e5DqwPCbYLgIR1GR0w/2FMZK6osZSUNbcB36MZFy6gkZVX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 12:15:57PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM, so:

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..fbdbf7c012a0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16127,6 +16127,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Mike Rapoport <rppt@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
>  F:	include/linux/numa_memblks.h
>  F:	mm/numa.c
>  F:	mm/numa_emulation.c
> --
> 2.50.1
>

