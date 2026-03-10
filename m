Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92409FCC9D9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A836B0088; Tue, 10 Mar 2026 04:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D247C6B0089; Tue, 10 Mar 2026 04:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCDB6B008A; Tue, 10 Mar 2026 04:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B01D06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:11:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6602E14021C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:11:01 +0000 (UTC)
X-FDA: 84529432722.29.3930287
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6759180003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:10:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZUkpQh7p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Js59GL1N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773130258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g11566VaswpDr4JsqWz5uzRFuAGl5kuwe+Vm/tL4ceQ=;
	b=t02G1r7ipgApJ0yvoa5HTAMC1jHCLtTkjoStX/wBFPQ1YjddRgJCDTtrFrZnE32ksJT5XQ
	dXCVmb5XqOU9mcRJjM7lOqbJaHwSkgSx4DYwozaa33St8Np507XhYDmBeGQQqH2ENcXRTv
	thWdbfzBw73alwFAJHUtPkvq7/KlRGQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773130258; a=rsa-sha256;
	cv=pass;
	b=yxKkkXGvYo6UHbE8LigGBrLYKWp4bw7lGHXg8bIPgAa9K2rqkB87kLQ3BJET0Jk/MivwqK
	Juy+Cl4/dHiF56kJpY6vwAMS66XnQltfIvyRvNAd5zwkvsDrY7NJtXZhjc9zwI70M7iyyE
	DeLiOBTGHj0CQnMGu7rSM7l5VpEW8+0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZUkpQh7p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Js59GL1N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629IMrcl1627924;
	Tue, 10 Mar 2026 08:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g11566VaswpDr4JsqW
	z5uzRFuAGl5kuwe+Vm/tL4ceQ=; b=ZUkpQh7pOUWtK2llM0UlzhX+XJhW8rQxEc
	BGQokn+gWFFzF5uL0oC+1ZveIYRTxUbsRhuTHbLxH18Rcrj7TiRhW82QrogUuQIU
	xx254stgQpcnk3XDYUfTtneb8/lY5RYfAS3O41MpymaWOgXIrPi3omPCJzElwg6R
	Y11mTyCmXPbqushXQRUQErnFtUz/OWnL+cbZhcAyAX5y/fBO/MAclXjq/oxRiqyT
	+MKVfiKAf6L/uCmWTlsd7/3F3uph8QFoqIcbd1+7MymKJgobRH1r+NbSvlLXfPB6
	QyO860zEN+h2GdEB0JwbyDKUUQWK+IxgbOLwLNNcmCPzPjcfcHQQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmps2d98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 08:10:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A7hcKu012954;
	Tue, 10 Mar 2026 08:10:46 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafeajxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 08:10:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnSFtTNNYQg/5mJbhTX0EOyZO/yxaad4Uaq1aIOmQLQJ1b75Djos1D/PK+8S/pFv6hHjEUUNFlopuTBcGAzpAdJVpHce/EbOBrsg5ywN+XQjD904QbweZy7RU254HMgYFwccbclbQrIRVOB+Pvuq4g7ExM9+TkgSN8xTJvflKmWRj2yFfRSfneav7AYxM4F9m3RUz7ytj7FltiZVLYf5K+dsU/N06AygoGTjw0xJPmmaoU5zEmD4KitUphveTB0oMQxxVUAP0DwkQrQINOEvg3t3UvvEMvzJgNCpnGnNcl1c0hIKjhg4NDoZfkINpy42OjaLys2gIsZXJDxvwLNeJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g11566VaswpDr4JsqWz5uzRFuAGl5kuwe+Vm/tL4ceQ=;
 b=tZK+L4KuVimV7aMVVjRDoTXjgd4m2e6lSwoImBXdzZV3A3V+NmrmfDXnbMHVGFMGplkGszn5AZVKeLZgbukLUt+oBCHDKEem4mb0WOPqOAFjXXmUs2cu4EwVPQALooGJhoYW8Gz8LfpF3IJBHeGl8gXX1g8LMsGYlmVlctMHO0+UtujZXcXhePuWH5uoP1am3sZuyQY35focrqo99Ho4EkNEFF3csR+3Imh8QYcibJcIBcEQY/8HBl/eQ2jlPfbHXHfTeZIwHM5eWXWGsEs/2cZmwXG2amLnV4faPEoi8wN63aGz5+sSUfb08S/5bBJN7skhpS6LuOTsSyR9aAMYYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g11566VaswpDr4JsqWz5uzRFuAGl5kuwe+Vm/tL4ceQ=;
 b=Js59GL1Nz7sZ1ouuIxmEP767rLuFuqk6VNeZFT732+tng+S8wakFfFT1Ht2WKunjRlEzZgh1e0gZkt7K4gp3vcqszOn1v2Pe0RoukP6yo/ol9EKxK5fU4Q6JVQp503D+R7/M8fPPkPqqj5ffH8CGoQqsRxoHSbdfDIOFNeZEd2M=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV2PR10MB997779.namprd10.prod.outlook.com (2603:10b6:408:378::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 08:10:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 08:10:43 +0000
Date: Tue, 10 Mar 2026 17:10:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org,
        hao.li@linux.dev, jaegeuk@kernel.org, jannh@google.com,
        liam.howlett@oracle.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@kernel.org, vbabka@suse.cz,
        wangqing7171@gmail.com
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa_R-6SdHYBBkQX-@hyeyoo>
References: <aa-1-Y3v3D1hzPvL@hyeyoo>
 <69afba32.a00a0220.d013.0002.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69afba32.a00a0220.d013.0002.GAE@google.com>
X-ClientProxiedBy: SL2P216CA0204.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV2PR10MB997779:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cee7ffd-cfe5-4dd7-edb2-08de7e7c8648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	l6F7fLkQG1XI9aM5m0WgQjx+3fA7d5BOi8bSZYUKAK+CkhgwObbeTCtxNnt9wXgsTU612k6b+M6Ju4e4pkeavEn6HJQ3RDWpg/y3z4qFg1AAbj7dsn1baJ/mBrFkdnNC8dFOCL7YvhyM+4jBO6xxstOB930lNiuaC/Eqi40aBDcsW8mE0VLzNNmgUwXW2em9/jd5aTnzrV5ma6F7p3vvWoYcWDO/4Np5ifOEtRr7PCSkSg77iEqOf56oE2HDqyjCGsUEPMQOfqC3Tohgm30eFUIz6/kM6a6k8FPicktCaFkdtbl/ZGt1bSaXLYHL7BfMEpcMyFqKCwL5hHJfQ6DSnAZRjJ8g/CN+KGhNEaw9xH3sHYb8tG4A2DM5QVHdCKaqRdTgDsKPoSsI1tkxEXmn3wx4Ppj8Gg8JlXZaaNQjU4mixunab35VHNWMLZrJ0zcxNgW0fKqgirs8aodP5cmBEVtUxmRWS0WRN2znA3l3Hta8MH2hpb4N8VCzrWnFztYlKRsJUym0abXWBXpN9+LQeMjnWA57/q001XBSgyrnSvVnKsTvrMUrDfPelB6JQKlfPQYtdoczCRg8K0LIMeTPuxX1zZH8pGFV6Tfy+5DAV2KvXJDP0G5s4XDVLXy84HdzyoBymkFHHc88CZWQpvByBanlnw7IceGVOcHaeqnjdbabgq5AWHK+3rfJ1BiPUvm7MQ8dwHoVROWV1pHlvzUmrc8zyNwqmuTmal0VSuVcmK4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/B33ju8DJr0lORoxopQhordtf5ehNGFVFHQf5OeTAhZZop9bNddTch+0rlBI?=
 =?us-ascii?Q?FKJPZVQUWQm2WLsBtAayvw53da19qMaebx7MThTIwI/e2gasH0Z/06aFSo1n?=
 =?us-ascii?Q?0kVRCojGZlAxth9PiRz5Qoyu9pzmF39aOMsbOgw/lUayfyWZQStzFpGdf9ag?=
 =?us-ascii?Q?R5h8ih5M3PLbYT7Ts9PH4sDx/pavaJbAJJBtPAc/ddYgDh4zgPj+gOBytH69?=
 =?us-ascii?Q?/tU0vey7m3sIUaPAKt5TGcLchhVKB5z+pNtqaJIAdrfc9Vbf0pzFB1AQtsPD?=
 =?us-ascii?Q?sts0nsKIDz6kZCt9ZlyqXm9YbTaAooBKRKy5vTNhmFuX9xvj5pb5FX/XRdcw?=
 =?us-ascii?Q?Vl976GfEGgSCSF48QIWt98gw8l1svY89tg83McUURhOJ4dH4LHqk3Md4zVIn?=
 =?us-ascii?Q?MKJKFIuUyqmAPeDSQql2tJLjM2EkyRhSl4Cao2hRoD+uVgdF5ZYJrqVQfjaQ?=
 =?us-ascii?Q?5HNQczXiaEAAT8JtI4dAn6BMNMYRAkNCjKpnQV/ceQ7naZpHz2MnpvsMnFCW?=
 =?us-ascii?Q?pQoOJcPmQDpESZ5dIUZRFkToXnuapeFcXm5otB+lsuZx5whGPix3ajjnO8y1?=
 =?us-ascii?Q?Hc7p+xZmynZh1nWlnonJKP8b5D9EjlNfeSe+DJ9V5hiO5KgQyxcgRGk8oFT/?=
 =?us-ascii?Q?0+iMX8M88zcRsx4KGWqHqoicamdHJHOXB3dkV/USfL9G4XbRS3Jb8B0sbwKY?=
 =?us-ascii?Q?oMNbJEmbcULYFMhqX0tuJ3oxWGTt5EtJQqq0Z+mtcokD6xjEeN8YlRxVbeXZ?=
 =?us-ascii?Q?e+F/MXUTK1kLjhkLffi5TRl0/w1xL7lZyB+0EbfHmtfDZlj80uBhXCWYWHT/?=
 =?us-ascii?Q?ojwz6t+T01ziwnb+/pgtEFelIBwRmOeABHe8qfjTh7+VHpbzD4Rl840m9+QC?=
 =?us-ascii?Q?VfWyuAcccoMPGRO9txx4RBlCTpwg8Pgwd+iyhU6HIHXT/db67RXrD8NpmNSG?=
 =?us-ascii?Q?4hTZhXUG5EsJhvgvgXbgL6yE+TV2d/fMjA5pV7Bq/qXHEjsSESZV1N93IaeU?=
 =?us-ascii?Q?w7b3ZlkmnuDFSuz7z/I5JCS6nBsqAMWDLHnqOz85rV35JtGOE/Bfl12mke9I?=
 =?us-ascii?Q?g0JtCqs+pPuTySYzRdCt31yBZGCrt0a9NGb/NqwKSZlJ9KTV7yP64gSrt1Lq?=
 =?us-ascii?Q?4zd0cY8EG24RNF50IDYMXVma7kBQ7IDjgvacNbFTk4TkuWUJsd5B1W4NJNNV?=
 =?us-ascii?Q?UC7E5SZfqqwaHezuP8HnQbyqlNJ0aSrEOkB0xsSDc0u7sL7KmodPDmvBKIJb?=
 =?us-ascii?Q?5B0QZPPXqL7NuPRpqsGyQnrd4Dw10W/5y6GF6mPDMxI4dOsA+VW1LpendvPv?=
 =?us-ascii?Q?dJgpZ44Ll9Va9AZuryQR3w1oPDqvte/PgmlLGmKoB+pOiH3zcz7tjHk7EAwR?=
 =?us-ascii?Q?UH4o51xu7cIOllHGvuejmLnr8voB0/0OMjybQjjydUQteCMOMCf1ttK+N90/?=
 =?us-ascii?Q?BbXoBztGitsT8V3JVtMe3AxLAcrk3Ck7Y8X/SQ0F9nSJbPA+pr7BvhtWsk6Z?=
 =?us-ascii?Q?hIcO9fypnWIM0h0hZeT+CSvE0aaVbjR1Io7oCr5uuzVV3GBiqiiNjpPX54+5?=
 =?us-ascii?Q?bkS7lN47MHzt8w/kDbrLWOq6qSkd0NgM7xsKyMlx18ggYRn056H73NtQyexa?=
 =?us-ascii?Q?gB3S/qpiFILUbOiMKuXWpY4UB0jrRK1WNSTOHk18L+uIbC0MTWCvVogIYcAS?=
 =?us-ascii?Q?kVcs9iVc1uN0R1Uf2Y5qP7NQx59BMliSNBhtTIhtzS0lYcL57F8h+rTkm2sg?=
 =?us-ascii?Q?UJ0p8ACreA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	cZI92rFG/c4yF4IsWmB+raoy6KY1vc1WVyFDeYg3vTdmAVYJf+18P4PIQnKc4AcPOEF/nYg6m8SvJaH6kixQrfhT/Y/TmGXYWh3/1QQSmlfG1xbgs45on9MiKRiYARYVSCQF0SsTnO8nfHFtaVifgIUvBimTHdrZd3npCHcV+a4P5NqemOYTaE2EjoJtTFiPhQibHCfEDUeic84O2G7p3JoQmXyEkQhjlHZR+GpeOaQrzA2CKZems5a33tTXEfowQJFiZvXyYlyaU24SjqscTMPmEJliVowlJkDi7q94u0RCQqTMYWcwV9O7sftpwaKjbLHqyDh7hTpaD5oduqfP3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bYvqEvxg5srxtamWLXP2uTrLU2/w+2/koBA7/7TqY4nRvOfCafQZdtoc4K3nZGLzgiYnMQsupetZnVFME/RF8Pw58/7WCZYl5ho4DuYHt6pBnQWrrCoDUI2cqP9zNELSMHM5gAmCAyOpy0vQWkAmcOYtPpvYpNRsenylZPUx6zjcKmIb8YqNh5ZPgO2IzoKMmXJuI+IqTJUnTgS3UjIIYgwqY1Tcvh9j3Rk/Enc1Wy69yVF0Gr9EjyCHk4X17W6qh0qm9iEo/JYi9tQJ5//vncAn/p6Cp9O5BgkM6SgenvWXMnLCuHL7nI5qQ48XEGBrkiyUCYrDf1pAUdiEanbf4YqF/HR6C1aPZKDbKLe9FRRS8vK4xlb2wT2zLVAsRyWNH4tl8Wo9fofQk1l9rxrcSecwtomrxHm051UyoX8Ts8RhP9kPIkpjf3IsFQpPSCMONP7NhAeYPgRXg/JffslB2yzLgUyUFh0rbyrMH5hNi28hJ4CSyUNGMJWTKZYkdRsFoE+CSaF/dsN0EId3RbLLLGbpSNJZUyNG17f1vJnL0xcAoZVtBB4SxA6HOt+3hK6CqTvd4Yizf3wwmpPUVRNrAAZl0QgVmAObgaz48+G8UWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cee7ffd-cfe5-4dd7-edb2-08de7e7c8648
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 08:10:43.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/iLM0wZr9DPfSocDVy4qUgZOrst/XhmF5ziw1U1mnE91NLCoHI5uaQETQ7U23GpwxGemI2rq03x5LL6VQPeHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR10MB997779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100068
X-Authority-Analysis: v=2.4 cv=IJQPywvG c=1 sm=1 tr=0 ts=69afd207 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=OWf7uXLi2fQ9eYRmFwwA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX25+gNP4cOc/5
 cLD+kyTkc0l8OgFAHizwsViAmoSKcznrG0aSQUoiAvd/ivAwjx6ZvDzULo4J8y+lNefMnerx6gJ
 JSaCF/YJMDTAsot3MEnImeret2VYryxkgm46/pf+GG+e3JlF5d2YjmKSUBn5ACTN8iDnFOUMwwC
 HuVKL6rlVIYkWQYF5XTbcfZ5A0GLBCIxpUcbQB/C99OWxe5345+Ublu68Gw1b/E4A1ZobPsbe3r
 JgFGO1S70xh+mjOQV1K+4wulrKKvsuAk0Uc6VXLuCAa8pqX/GGObp9YTLwkBJn6NKj8VsaeKIyA
 h1c0ureG6j3SYEGI1sy9e0Cx+k5oLyB6eW8m85CXpfIroRsscAz8nafRoOshYXQunR5ZHbeywbg
 ba8X0qYGfToReEd9gZEvN4E1wir5VSO3k0ZrzuWX7+zWDZ2UUdivHLHEw9jLNw8LOIkCgCcgE2C
 ONsHpVQOIQndtoUgYSUjbFriErYMeE/lQ3v096gI=
X-Proofpoint-GUID: zq2DEVDx-bJFScWkyXlXBp_Vdl5TWt7U
X-Proofpoint-ORIG-GUID: zq2DEVDx-bJFScWkyXlXBp_Vdl5TWt7U
X-Rspam-User: 
X-Stat-Signature: 1t9yo7bqc5iyq3bg8txe6kxmfrpkbsnj
X-Rspamd-Queue-Id: E6759180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773130257-95358
X-HE-Meta: U2FsdGVkX19Uz7Hc5/d1VI/GXClGNMGJNs/5V+XgPG4ttIqWEgq3KQyllzMqq1ONA3chyQFvIVObXS0ID897o3hKHbGr4E66Ukwiw1qNUMMVaKOUrrKGa5svpc59J19yxp5IiutfDF4dj7MoheBZ9p2p+av+XxJz5rkdDKXKfYd9NiPAoQkwqE/98T+JaOgi7AtTmVMxnBncAkesn40h+vsN1DkDXlAKGa5zpe+buX2p62Q1hJedTPDEUnk1MiRM9uwxKSNXoebH00v4JmxXFuAwaS3DQZHH+i9mvqslCbr7EkZOVoxYX7ff7w6+gvFAqmsMOp/QlFslwXiSX1v08iVM6/wlyluIDzBYYK9csVop6kJcBtHoguqtrdlP87WqoBtvSb5dE6jAgGM6vtrwrR0Zy8T4YtvfCrieaDWdl9auJPAhJPuhlW5UfO/oo/ISULdw8Tu5BquHhlYCk+bCpSIiVWqCDzTly6YzPixqyb+HHmo1pCV2tcV9GynmAV2X6o/Oj/2X+nFaIB9//s5FYrekcDBR/SQiA+dOsGogIv20KgQAWKJYNZPry0kuSFHqMUt1URlTOuPmfRQwGre7X7Coq+Sv2zRp9rWlu8svVRML4Y9Ri6dOPv45iJoIbhD2MXcBvQNvZilZmUQSzo/mp2dqMnmAocnQi0cepoECCmRG42xgRVsnxvQwpF8YqfxHnsR+n7UVP0PqqQZ6mUdhGO6lwwwNmynEDONy07zvCAYdstMyhTnzPQh1lDyAJ4ASz14p9HQwSeJTX1T4qLyrwlgfzu9R1uNhK2v1+oSVO4iq5vxhqw3SjFI6qMcdg2AJZMxDc9dIOxJdCmgKPrMhYZKekOFnIqyeY+dhraZJo33cVmp7rPhEL/4+xx2gIefpr632tMMIdU5V6Z3tBYQvN3xn3TyULG9v9rG2cBKiuEYTMonjA87X0+qoj1a/K3k2WKGniOZcY+rLaCFo82s
 uCj59rmM
 hfSa71jEry1TBqNd3YORlKHwnFQX6dFmVJ1CqAU4jeZ3PyBkeSCAWVkS7wQkdG32hn05Inr22yW7AqfqcpZrjJHKf3Qg24fH1XcNVUIghTy6f+I3erpSfXSboFSvXhQJPrs6a8Q66CeQO+cRFL3FkRLajwKXXMWusYtsR8xgZW9nD7jMBWWdH9XXDdxukdAOoL+YwLttPmKCobrc4iLIO0rvFIp/4EMRjZpopP4C2CLZKGiHvyy0HKaBm1Zdf5AgvoC+Cx3cc78V6RnT9erX6SBFeOn6JzZIabLPQ+cNWSq4wPC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();

-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}

 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..2f2228d3e8b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2776,6 +2776,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	sheaf->cache = s;

 	stat(s, SHEAF_ALLOC);
+	kmemleak_ignore(sheaf);

 	return sheaf;
 }
@@ -7538,6 +7539,7 @@ static void early_kmem_cache_node_alloc(int node)
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->node[node] = n;
+	kmemleak_alloc(n, kmem_cache_node->object_size, 1, GFP_NOWAIT);
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);


base-commit: c23719abc3308df7ed3ad35650ad211fb2d2003d
--
2.43.0



