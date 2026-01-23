Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EB7D778AE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 19:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2443D6B0549; Fri, 23 Jan 2026 14:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B426B054A; Fri, 23 Jan 2026 14:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3F46B054B; Fri, 23 Jan 2026 14:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECF226B0549
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:45:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84FA41405D6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:45:38 +0000 (UTC)
X-FDA: 84364258356.08.C43EB89
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id E6FE44000C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:45:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EdUBNQEe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XgDMOgxJ;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769197535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UBYL2RA04FWWa+5apZdCtXljJb0wxl5LBFLky6dWyc=;
	b=QpMeZqljbXEoLTfE3PaK8GlVEmBt3Fnj0BJqst6DXwLwXtba2YQcLTnb5f8eRf0VdN/R+o
	fD6DGE+jos9a/3z61nSssC1TNaWQqp/fdlcK+0hpWMGB+a8FdjdkwgkMk4xSL7MxEWeK5l
	9wiV4ELq0YvhH9f734T4ffXIajQ4a8M=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EdUBNQEe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XgDMOgxJ;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769197535; a=rsa-sha256;
	cv=pass;
	b=NAzS/GBKN1t1cIytNQ9UcBrHhihI6SLIdLxF4GxHj/Jm1R9hgHy+VD0v4dMjZkofA0JSFi
	JsP+zsfwSWfqptX2wiviZkNyZL/A1wh4qehEhIpJ+RADxBYk9kderSO/cBjZer1OBRdjsw
	ZSTqMAddf/YFjeANwh/OlsEbIEG0B34=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NER00j1675654;
	Fri, 23 Jan 2026 19:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6UBYL2RA04FWWa+5ap
	ZdCtXljJb0wxl5LBFLky6dWyc=; b=EdUBNQEeyndIxWcxHJRPayqVCNUSbRjzCy
	viorJuVGCzNZx8WeIltyW6x+8QnK7rAgYt5jjQYOsKWn6V5aewLPqk3vsHrxapNd
	GCLSTTbH/EfInCbQJen5m6MpV5Q5IbwqiBQnopVcSq0Y1pZLmwphLmCFX1dyaA68
	zN2+xs6URHGv3Totsw769kOZzhY+Gl4apBsOMvdOZLvCBJ3Hhd/VAul6LW0vDL/X
	VpdteXGRYfkpY6royrDY05dpHFacOmjLOD6xbcVDa1woodPqKojp8cwPFTJq5FEk
	+69nPQXZ3WZSF2EVrapH3WSymhrTB88f/5LL1U4jynNbq2rzAJXg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10w314j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 19:45:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NIFBBx037975;
	Fri, 23 Jan 2026 19:45:15 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4buswcfsnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 19:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HLLt3iqxuWdDW6b+AaepUoaGsf/JnDgDfrf4tYwhpbeTt5nPOenPRVfHLBFLcpVh2FkfRnMPFx2gAZL1CMhyX4sgoHJoDcawbca54j8xXOPE59K+x3TtQme+la9XB/wHC/prs8IfY+oSsODy2YaH7cZsZ/obP0aMI+Kly7PJy832IbVYbv67JMmTtIoGvzE56wvMc9mZmuiJ6oAJtx+0y7UuVhMvsg73abSv2x24MSKBLGCKWAQ4fL0TKjeOGbTm4eRhXOYHEL3HvlBk0brk1vsVFHUr6HK9cP6l5mxJR9+3JUqqDFBbG+YDRIJ3tdc05p4WDNtI9Mex87s5LTwpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UBYL2RA04FWWa+5apZdCtXljJb0wxl5LBFLky6dWyc=;
 b=EZtPRYhP0PUxwMFdDIYZG0t4Q9D/t0S1+HZap+xgYhsWlPJGWJ3f3tWYXxBaKONMuzlBYDozi0qfYyq2+RLL/PRdUwNmdJiDn5LTmxze4EArrcuL0e0a/an/DQQIpN57VQdfyeFg644kZ4NVKVH0nQFQUaNA60yhynEFLNRsahjDNBiTYWI0nf956C5P6yyv4aJHJXe/ahS0yqEUPz89CiMnTeZLvNQlpqp/Abo01ptRov2PtdBO60yVDBsRKJQY7csjy0yMJ7WdHkfUk1fcCSl+zG8RiQbK4wy+76w9xOaZuHETmoqrzVf/wJqJph3gKNo2OUlqGrfSl8gqYV5MLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UBYL2RA04FWWa+5apZdCtXljJb0wxl5LBFLky6dWyc=;
 b=XgDMOgxJ1BcL3YFTvpKCZSMRyt4bqbwGCUgRaE0/nJ1d2X7axHpV6NxrJ+m3NGYzamaCaTAh6gV3CtPBZcmXPbBV7bPyQn+axGUGaMqkcyvDoXUOTnV8qbSFeBsVJi7Xw5rN+bRVR7dtcd2Hu3svihP2WZ4ROdXEHX9V1o4500g=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM3PR10MB7971.namprd10.prod.outlook.com (2603:10b6:0:b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 19:45:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.009; Fri, 23 Jan 2026
 19:45:10 +0000
Date: Fri, 23 Jan 2026 14:45:06 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v2 17/29] maple_tree: Start using maple copy node for
 destination
Message-ID: <dwhxxuil4zkesmyj6xviyyyfedrcd65h6qd4bplmcrsg36purj@f523i7t6nxag>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	SeongJae Park <sj@kernel.org>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <202601220811.ac3t5OuP-lkp@intel.com>
 <20260122055516.69335-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122055516.69335-1-sj@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0286.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM3PR10MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d99278-98bc-42a2-1e9b-08de5ab7eafa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F5v93Kj/xY/wF0L0sPVf5wKXGDrWGaTDCZfgUa2R9UGQyM4gciDVdVkaGfmC?=
 =?us-ascii?Q?cnCRJm+BS5yOjGTeVG3WfsftXFBp/mZhCIzcxXJzamZloAPVPnkliyK2MV+J?=
 =?us-ascii?Q?iJGj6fHAl0vEinfLxjgzTz4rfHmWdWLCifm9gSug0pIjKnscI5sdD6yqNeOV?=
 =?us-ascii?Q?9hkUfoHVb+jvYoyKZGdJFjDRh4USbKEe39mWUoGef9IkIyc8/D3vxMXK1lri?=
 =?us-ascii?Q?2ggIMWO9uoUbYNV+cKiK7+S7gw+sk76ATaP+yJIdx9RVCc3KTyvWg9fCtk5R?=
 =?us-ascii?Q?lk70abmpeP45+ivY/0uPp+yAJQSUZFkVO2ri98YlQHOjPqEXooTc2K4iwtT+?=
 =?us-ascii?Q?0ZEpPsLXMCBCUu2yryPRXLHJlpZz9DaYMAWpQVHQgojpDKWRc10Y91E4DFE+?=
 =?us-ascii?Q?Jsn+vWd25q13RxSJ8mzsXB1MuzZE3mOelPEVgCxSdSbkNiD+V9UxM9gIfCUJ?=
 =?us-ascii?Q?1PvdGVtzwLm9suocGOv6mglgn3bY9NHr3bmcBPrx3PYAgMBiyUTGyUX94Vec?=
 =?us-ascii?Q?W7iv53DkBl60s0vcDHz85VSRpzPsMGLzoA133QownFa+p38Fxh6d2ifB2kVk?=
 =?us-ascii?Q?pq06EaWdliaL8Ec7UzBCggu2Fldy6YybVdoY5q0UX7nF40Y6yTm9s9pzBENt?=
 =?us-ascii?Q?QKb2zD6rCDRBtmDO/bSdljsH9GeQSzAUEhJu3Knq8bZwTUWTSbcCP9Bs2ixu?=
 =?us-ascii?Q?mADjNhrOpxHxFJc84C8JfDWWuozvMCBSk1FwlLw1jzRnVb/dIyIKO9dxn+tH?=
 =?us-ascii?Q?eo5CUKq/QgFT0uyHsqSSD1JizkA5nXuouDIcL0g2SCBpOEbqE+PdG6HPiLxW?=
 =?us-ascii?Q?JQGsYB1iUScgFlCWiwXqVySJBIDCMbMuVkMPfHlTigw0aMlgmjKU2+TvvOpu?=
 =?us-ascii?Q?5A4rPjlDX3J4O4Z8ElSfkV9GtD0s797HkvMOpsStBfDWYyNywIAj/qa8Hk/X?=
 =?us-ascii?Q?+dsvaSIskdhwr5ydE8AEISAvkc5ineqQkKMvIhRs5EnSZXOgG1WSY2pDY61w?=
 =?us-ascii?Q?tuA+d27tm0n+jtf7vedLlQp9vjDtcLmun6LuAiGxyTxzY+vGFmEFY8htuqSe?=
 =?us-ascii?Q?dqFv6tc5ye0Wvx5zMMaWgwZ0E3qwzUyyOt2I0SF3jWPnfjozUBSEuNk+eBsg?=
 =?us-ascii?Q?I25xEIyBvq6jSeAii8wvP2djD5L+pXXsRpPn4mSnRNXVFJuwUkNEa3OGHO6G?=
 =?us-ascii?Q?tdxSPNrCoHR3es+RXSM9TbJM8nL/egHLCvJEw1gOxS8et22bXfepZtkP6kY/?=
 =?us-ascii?Q?4jjH2/5kpKW/fD94E3anmLImjKaHW7T+6fPva0KwAujfgosrvnHb9IjhKFKo?=
 =?us-ascii?Q?R1PZUqfZYDpjTT2WqrzDalILAfVD02ISRBwzd1SnO1zqzktjIzc0zYFakAdL?=
 =?us-ascii?Q?yy/sCGqOlYagYFr/hmPnaEnk0FM+ANu7oe2vZI183cB/RAcHth6nevE5oqIr?=
 =?us-ascii?Q?tl3qGmfmkmEd0ZHim3fysPhvWZDu0D70QRLn7q0kb9EVELW/EyAry1hKRoRi?=
 =?us-ascii?Q?X+sd+HK4r9cB7byZg4pg3uncFmTRyIDtaGGtuHiD6eCWnMhaSPlCZkOTwJCY?=
 =?us-ascii?Q?V32f0IaD8+NPPl571CssWcJBC4XW+JVpsy5CT6A6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lp835OzwnhepoOMpGRNabE7yRIAZll9ra4TlN3CQAgWJ1x39Mh+q5pD22LKq?=
 =?us-ascii?Q?bohy6RJlL1+PYv4wPVWQxPGBCFoYT19h5cKOPbqcw4COuFK9VP8O5/KPS9r4?=
 =?us-ascii?Q?uLNShljSTVHSxM9Dk15IW1XfLf4iOrmUAkPN1R+OiRWB7UhKz5ZTlHtiTBUO?=
 =?us-ascii?Q?DLUWCgWmCEjphUT/H0gGtIyBIvgc9HHZ8Aekfj12FfJLuJ7j+H4P4F8g33qa?=
 =?us-ascii?Q?wmUcP1ABilx+w/1s9OyhtbzGGq3WysOkCQ9ezjWiYiPkfXZNAMVmOoBpNurz?=
 =?us-ascii?Q?qbQv/uGEhwVRxuQ+Ni4MZ7m84B26D7mKJcKcf+sJS5IYGjWYFUijwVOv91mS?=
 =?us-ascii?Q?Kt0TPZHQF+qnNhBQinp+ekFGYfW9qWWi/ObBUUHZzqVt4fmc8KOjObkqtypl?=
 =?us-ascii?Q?jkHkTgEtqthNsevmMFlHQ30hh4y7hZoiQTLuV5csBbyRzJJXDOxkKo/Dm4j+?=
 =?us-ascii?Q?GJKigvWBkt1+45Fi7bD2pJvqtL1qc+vbwuH5UBWpAbAHAyvFytKU5v3QlMDC?=
 =?us-ascii?Q?4XEN2LTAviuF6AvW5hFvtL+USpzXCe/ob0+2xU8o+EDtify9zLBN0+HwYcYL?=
 =?us-ascii?Q?Lq18v4v7R69Scr3gPM5uwwy2jmdP2aocrQrZR9MT1mJbmh1PqHrU7VUw1Kxx?=
 =?us-ascii?Q?u6Inixi7+8/X5U0mnYNewHQ598P1ZyuhUPiXi5R6OZ0C8wOmTyK+qPT/qjhG?=
 =?us-ascii?Q?iHnyrGJhbsDypHwPoN4V2kMlslFjcu+/STYX0+hP86EluYySURBN4XHCPK9v?=
 =?us-ascii?Q?XvuSaWYWxiYV5uw7o2Tjh5XYltIgWUpHf1tBN4rLdQQiAPrEYu/Yda61l7M1?=
 =?us-ascii?Q?nqcKX8RmbOTy/WLpJCnqo6gbPF0tMJwAR+LPOLCf3U6yKxeImmVVL1AWr1g0?=
 =?us-ascii?Q?craozK9e3zoZ0qw30avaTmXWQiZR377O2ag3oMhTJKG2YUUsXH5oRvg80ClH?=
 =?us-ascii?Q?gwEfFkdhP1aPEx9V2pcrclSuxmnGmsiqjhUrjkB6eVlXR+Ws7ueIvakTYyYW?=
 =?us-ascii?Q?c2ZSfQbBU/EH7lOnmV+vTG4JuXItXIOIlk+4b7QhNTWaEZARTSeXU32xsrqO?=
 =?us-ascii?Q?YRvUi17eI3HxDhBFuwkbPfJqM2ZBu8ESw/1V6nXIJiTo0Xzi5qExl4csmFIT?=
 =?us-ascii?Q?yNUIaFdPwbL1nhkJ9o59PZ2uh6GRz4VHhj+PEWaB2W6VIjw2/fMXeNlPdNIC?=
 =?us-ascii?Q?k6hM/ce8HwhfZbYMlWwve4ZaeaHLdAep19hVO9d5jyjZsuMjfbDjPCUBLN+Z?=
 =?us-ascii?Q?NNOOwRdpKZyrAC76JdRAKb8bJsK64cXSMpMp+aaSFGy5XqobXSZ+U4YauQPf?=
 =?us-ascii?Q?o6VJg5YLZKSBL2xx0D75gu2HebrJaMoDj37d8SY0iLIGM9KfHQMXDR/sAOGV?=
 =?us-ascii?Q?vjmYfzhCuLUJTJ7Y1Ji3IzCOdtxMVjc9IlUP3KUxo+3jfECYW1ZA4TIQ0buw?=
 =?us-ascii?Q?zoUd79LucvK84MtQiROYPmfW1FN5ecXFCq9j78/ZuWSdjeuDyIzC8eWLdV0r?=
 =?us-ascii?Q?qV5s3AuN/JBk7DZr3NjU+uK1CxYKdltZFVYW+ynDFq4n8xZEAJMpyQwD7Qbe?=
 =?us-ascii?Q?VbaVWQ8cI2rdDdADAa3NTwiyRrLswGguvwn6wpmlCimJymMIcYNBeoG32xkr?=
 =?us-ascii?Q?zBjQQSCBapfhhIDEunMDTls1REGa+AjJNlc/llag+WtiIji/WGYe/2WApbHI?=
 =?us-ascii?Q?wqK9qLcCxJWeGSBKWNg2MuZBIfZE6TKdkXihLMcXRA1fgZ06v2zk//NSR6EJ?=
 =?us-ascii?Q?pYJAY4SYew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GInsDkqo5j5KbBHqY7Bul+UnvrBICueuW8zvNt14rn91mb6tGjDxvQMxHj2bj6KFCOm0vQNgWQAqi9zVNfOZ11O2SMcriKBYPblFx6ujJLDf78edpBjI0lSBU8UFFepSXoBbzw8N1dx9escUInzr5CSgtYoClG+CArD6KFxXEopKL5Bav1SCvOMaosGieOiGgzZC62Y9MWO7pxX2uhVfP7/BDGuYlBdIn9yg0s2owWNtObhusN4fEDdp7lYMK4JOVU/mypAOXAtdbC54s4ng71MOnBpBqNYWWySccwf032Ew/DQ792XNRJHp3pHetcBddtY3tXmgg3HJFKAyj9OxUQfzr5YU1wPcL55LsYUk/Igv2iMGHQx+1kKQ/WXJpO/l83xa7ogBKkIhOz5c0gTDDky2lE5yHlobggwMQWSl/S54xOXFm5ZUGG4m0tVf0evS1qHX+4jN4ZU4XHVUz9ZCGt4jiHI95F+espQu4MlcZBKfBzQzJf966mzz4O5Tj7IbUqjg38E6CkEVjxl78wael1/KHy9qeWnufER3UpGQJpnx+jgTqCFvRyaydF5w+WDKq+uRAjwNL2NS8depo5Od6infmI9yPyqJXx3YoBu0lpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d99278-98bc-42a2-1e9b-08de5ab7eafa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 19:45:10.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XigxQt1gpiuPYdtY8vevslPvl7r+t27TFTLPsVsM1GDJGRR8iAS2vDtGq0dWbNK+tYtVP2CSWnHN38sMXiHEZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230151
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=6973cfcd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=9CzlFusleoelM5dj5wMA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:13644
X-Proofpoint-GUID: pYGnf79V_bnin-yuSWAoEmbVdlL_ZmAi
X-Proofpoint-ORIG-GUID: pYGnf79V_bnin-yuSWAoEmbVdlL_ZmAi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1MSBTYWx0ZWRfXwbOEygBIlQ9O
 sC5OKWKZ3+s9AlgoU9ni4Tdsx+EY+bCzWi93grydjXKRaxYzUXZnQ5Qlhh949twGUnQaOM8Ukjm
 F5CEwVjI1AWz/vuyV5T8KoK5haJIqwCRFReMHeaVjwtlCGH3yQId68LpSpwHGW1ogng1Fxcu5z7
 9SK4wwCWG1iMCon+f2ebAgNJSomE0qb+MYaFtWU9dJhjN8kJF2bwfn4Vw2jJU573hS9tyDSibRE
 NZlHCyVd+LLLvyuVQqJzVqPGfY5PYqgOVwm+Qw3GtVHBbzlVSIgswAXt/FGMykNpimr7F1/bMxk
 novxmciRtVWvH4geAS/jE4I23bgnAhlME486yh50m7x06DTmp7r8OpAkiDzSm81s1z4A1UbMjAa
 yMZJ4nlJT962hm7iOc4wGzfy3vO3hH4A2roH20hTrDQsGAIfouZ8p9Jz+UfJW1iHoCUgoCw6t0w
 CX2pDySS4S+jsA6tt5kbT7UaU++nf2BYxmbqXQCQ=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6FE44000C
X-Stat-Signature: gkmuwddazegsftnjd7rd6ecjn3rzctr7
X-Rspam-User: 
X-HE-Tag: 1769197534-464260
X-HE-Meta: U2FsdGVkX1+oeFettBCmBnZu1/gHJWnW++IRUnG9Gh2iaAF2wthXE3Y7n5TylKdoQdhB2DyQge/Ov17eiS429fcrAsFIacWVjLfaNhYNvmWY86nqITeUkaapxYiGkHl4tlNQDyZFR1m+EU7JcE2J3dSb6jVVd1Ur9+lZa0BcdG/gao50hg/XvmEO4sbipel3B1WPnN7UwRZctEVoifP+qQK2jSbo9HLiwVDMuz+oC7TRJ8nj5LUG/7SI1Ry93rDQU8qI/v7KwT6gLvxerFLZolG7Z7BCZHedquIh2dmvUZZ2GjVjmK9hYGmyI/tWWpkukiGCWuCp8ch8KwQZr+3oZcKx/q7Q3Ax80fvN2V491KPZf4s9Z4LhjQeI6Li5NRoFTYZzdtso8/b6Q+pV5pfrMzVMKGqiuPZtUjTfir77DbLLJ+vfjrEnXzPbIdBIoLgOMY+ydVto5fmEDrdlUSaD+O+FZmbJFf5ek0dgodIfXyhAbgcWAT1WyaVpFcR3Av/L9gbyCPgtNherkJWxbHYsdM4p5/VfW6zSUSn+uKnmTpabAr7RHj72MN+b2wVGNDx+kxoE0C53PHlc8nmXZSJJanuML3ZJwwLOmFkP+SmThqZjZLefML9wmwTdYD2SGuaqTDT5290+sojHvnZTDcVhUSWf0nMwp3WF3xQSy+ENwMp1tmPjvHVeugCSlFhXk01WEumZ3xI7EjUHOA6PgcSDL093TkwcAbSjg0ThN4B/0QoFXKJwUf9Grsxcv6qGmaaN6zG33VohGJ2kdL8T/EjQUiqcrImtwchJw9N6kDBAYzRb/6meoJ1gSKvlHDTFiHEDwRTniS4Dhv3vshesECyqMbhAddUbk2l+l15IqvIeHWOMW7fuGcYzkABhvPx0CqZE2BhP4OQgX9nt8w/1RzaNI2mbR/TLtxEhO6CrQWGhQiViZJeCHNHioZkS0wNVU9mF4j34qW/qcNeK6dfnTs9
 FQsrSDM6
 Hx0Mc2Ui5XsixNft9qomtRsKVodlYCk3zp1LphH4jCGwZkhRwONWJSL3e68Y0FeknA508xl6jLKnqKlJ9sDSQrYUI/vX2p9RdM3NZ8NW3qqyi0l8/gKMFMqvR9GirLiDxS8LvSazD+TDpXKQOnnNWfxjO/cUzcdqYmn1QiZaqkjyrK2NMmnpep05ecFeSanPQzl8t6HyR6a+ZZW9UJz9GkSJQMqWr5vccp7dl3D1ceBy4OQX4whB/HKqxfvqUJLrZmuLsYgpuzyAH7WWacOFayiCbD/YaVm2X2XYsaooRJqpUc8cHjpGdRZmFQWgtMa+G9298n34Bz0J0LttxX6xUTtsBVskNfWQ9pUkYxvYnjn+4szieyIOrNx/GPG88OQGbDvspAZfHP87QSpuXpOIBHCcxua4r6nzd/cxXUU3Q7zUQOYCRBuu838Xv5JvJ6JoP3AYW/OBV4RWxLKsvVYOTxQ5zEDDlmO0QFcB8Gi1+PhZ66oMNGzoDeupPScRxEZCsK2n0RV1Eonb5g4pj/DI/Jnqade2tVHl2iu1xpqu7LpRudQVZdicwMwU7Ddtaw0fXyApE4bUDO/y5T8R85mrO7B4SEn622e8WMM8Zm/QvtdcusRYWYMU2MO5L10XC06CxwolkwpsmWdtIVbLJWV2hq0H/amfbJxMl/kzzAWF0GZRCDSBbQQU6eR0/MrMeAr6VMEDK8RUa28II2TqBhagpqlNTvzdl4TbOuuNpbcYfxoeRxdXCAIj8Ovj6QlNB3MKl1wa2mzXcqt/5mBLUs2hXq8kiJzHdLXITB0V6QDrrDJ1KZi4quAlPtrAsUWiwW2U6ksKr6b8GiLg4PGBbtFwwL2zgMnkIWFDUdnYH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* SeongJae Park <sj@kernel.org> [260122 00:55]:
> On Thu, 22 Jan 2026 09:44:37 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Liam,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on akpm-mm/mm-everything]
> > [also build test ERROR on next-20260121]
> > [cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc6]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Fix-mas_dup_alloc-sparse-warning/20260122-023746
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20260121164526.2093265-18-Liam.Howlett%40oracle.com
> > patch subject: [PATCH v2 17/29] maple_tree: Start using maple copy node for destination
> > config: sparc-randconfig-002-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601220811.ac3t5OuP-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from ./arch/sparc/include/generated/asm/rwonce.h:1,
> >                     from include/linux/compiler.h:380,
> >                     from include/linux/array_size.h:5,
> >                     from include/linux/kernel.h:16,
> >                     from include/linux/maple_tree.h:11,
> >                     from lib/maple_tree.c:56:
> >    lib/maple_tree.c: In function 'cp_dst_to_slots':
> > >> include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
> >     #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
> >                                        ^~~~
> >    include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
> >      *(volatile typeof(x) *)&(x) = (val);    \
> >                                     ^~~
> >    include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
> >       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
> >       ^~~~~~~~~~
> >    include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
> >       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
> >                     ^~~~~~~~~~~~~~~
> >    lib/maple_tree.c:3155:3: note: in expansion of macro 'RCU_INIT_POINTER'
> >       RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
> >       ^~~~~~~~~~~~~~~~
> 
> Seems this issue depends on compiler version.  I got similar error on my build
> test, which uses gcc 8.1.0.  After increasing the version to 14.2.0, I don't
> get the build error.
> 
> I also confirmed below simple change fixes the build error on my setup, and
> added to my tree as a temporal fix.  I'm not familiar with maple tree code or
> clearly understanding exactly what gcc change caused the issue, so I'm unsure
> if my fix is a right one.  I'm sharing that only for a reference, as anyway I
> have to make it and add to my tree as a temporal fix.

Thanks SJ.

I have translations in the code for void * to other types, but haven't
hit an issue the other way until now.  These types are not fully defined
specifically to catch type errors, so it's ironic this breaks on old
compilers.

This fix looks good to me.

Thanks,
Liam


> 
> 
> Thanks,
> SJ
> 
> [...]
> === >8 ===
> From 6b0051e419cc5129133f8eb94db7f44afd8170fa Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Wed, 21 Jan 2026 21:24:08 -0800
> Subject: [PATCH] temporal build fix
> 
> Link: https://lore.kernel.org/202601220811.ac3t5OuP-lkp@intel.com
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  lib/maple_tree.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 2d840b9a360f8..7aafcec45c6f2 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3152,7 +3152,7 @@ static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
>  		 * read-side operations that can view them until they are
>  		 * inserted into the tree after an rcu_assign_pointer() call.
>  		 */
> -		RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
> +		RCU_INIT_POINTER(cp->slot[d], (void *)mt_mk_node(mn, mt));
>  		cp->pivot[d] = slot_max;
>  		if (mt_is_alloc(mas->tree)) {
>  			if (ma_is_leaf(mt)) {
> @@ -3375,7 +3375,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
>  			 * the tree after an rcu_assign_pointer() call.
>  			 */
>  			RCU_INIT_POINTER(cp->slot[0],
> -					 mt_mk_node(cp->dst[0].node, mt));
> +					 (void *)mt_mk_node(
> +						 cp->dst[0].node, mt));
>  			cp->height++;
>  		}
>  		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
> -- 
> 2.47.3
> 

