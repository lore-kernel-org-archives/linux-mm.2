Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF8C606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qpJk1/5l
Received: by kanga.kvack.org (Postfix)
	id 4B7C16B05B0; Wed, 25 Nov 2026 22:08:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4685E6B05B1; Wed, 25 Nov 2026 22:08:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330306B05B2; Wed, 25 Nov 2026 22:08:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E156E6B05B0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:08:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ADB5120296
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:08:12 +0000 (UTC)
X-FDA: 85475786424.19.9CF00F5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F922100002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:08:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="qpJk1/5l";
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795662489;
	b=XpUZ6+FZgUQqL9JzwIoY9w73HL3ZN8Vfrw4Cu65+jcvwQkr/I3ap1a+yFJA45ho9mjgnJj
	b2LoHNbvFzbMMpaxDAchEn7nRsH7IrdcxLnDV7GTGIXjyAnuzyCRCzFbgGsw9kJ8kWIMVo
	eByi3VyWcDp611e2YBRiEThtgTbqDwQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795662489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=o69evBy0XQTEb+8/KBKgO6ZnECgHprI3gjdYs14yNJI=;
	b=sT09OOfso6TYqBZxCR8jK3YY3FprJgSHRTzRMd4b+Kj8hsTXJqv0V+iDjuDsXb3zsZ1rmD
	6ndMBB85C5VyAqWgxwcpgDYddRn/MFx72nAFr25oAocH704XKx1/UUMpR9uqDT8c88zj1+
	+lCaUOJOdNWGC4v0QOcSZx8iKdYHCec=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="qpJk1/5l";
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlWVsaOVG6BYZq0ABCOPLZjv77xAIb/zJz6A9WiSggpXj1oZuDowCaZ24ZsUB5gOtmsKb9F2r0HcObemndTToYoj+sh2rbzyiCsrvsxQpdLtmzMICN/07ofsZGsW2hW0PZp7uN1XBLaFlyPRJtQh6jDVkKfw14N0ZnNqNBiYknwgBhxxR8/nirHjPkh/z+j58kv3mOSq1MYQtYTFpLx8pfHAqP5/CkUkd6BoeoQsd5rfihH8f7Gka+K1hfMh7/oHNJjQ/qG91Q2UAFWIJBwYSZAwb/8naHkUNIvSzaK3tzZ5wgIwqhabOBqACLE3GbGStN+MadtEe1BrL97gyJHvCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o69evBy0XQTEb+8/KBKgO6ZnECgHprI3gjdYs14yNJI=;
 b=S24z86rHoKeMiiwpSMCnRL+fOInF1Vop2FVxDfSuefd8b8D3A0bvhcI0fncQRfrxusAv3AE8rSiNGDlxpE9y/mv9D2ifAN0JUhxC6E7smQrAfgaByy9I2BgyOQhenDnLQVTt4KLvCahJ7911QlsdxdiNyymLX4/ZIkIUK0DjuxCeWZ75CIOIZO56SWPInyEKoNr7i3dQoblIs0HqAh5/v7eTZ0dOtW4x7npUc6myyl9TvFA6vLDVWg4CfMy2WrQl5sFWg37Da7T6SnXZplbtQwgV8nSLnEpV4LJ+ViggBBP4PEAurTXpZyvVoSBSkqWILf+/sa6TC6jN5vF+d/yPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o69evBy0XQTEb+8/KBKgO6ZnECgHprI3gjdYs14yNJI=;
 b=qpJk1/5lK9636SMNnRBIm900RFOF5voaZ+l3ofWRj7/Kx8dAm6wkTMvqtYMvJXloVHRtauT7Blh1OGECkQlDuJrZgBdaQ9axDzy2JHr/VUbz/iaWNfKNlxL2kKNisnG6gaxpd+kO4C8vapDMn3lkeU6vnRK7rsjpnAKmqY1bCEyCCk1BrJwnJ8wVOGuG5/RbnZfn5s+q89LwmSlaJVdJHYkNelKhVwOep9ICLjTFyFTa81qoyzuAWr179lMMtl8QzRNULlJOGRZYBTlclaiez9xfiVLxKMbH4dyEbmqXIRzdwKUK2y27dcLTWgNugTRg1TqcmxnUAe5s6neOZ9b6LA==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by SJ2PR12MB8036.namprd12.prod.outlook.com (2603:10b6:a03:4c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:06:01 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:06:01 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH] selftests/mm: move the HMM migration benchmark out of selftests
Date: Thu, 26 Nov 2026 13:56:53 +1100
Message-ID: <20261126025653.1344932-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MEVPR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::14) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|SJ2PR12MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: e66a2dd1-4d9d-465e-8d56-08df4b6a335b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|23010399003|1800799024|261026140227099003|261022105027099003|11063799006|10067099003|56012099006|260925022911599003|260925021311599003|260925021911599003|261028144727099003|261022075727099003|261021121427099003|261021123027099003|261026121527099003|261102123227099003|261102130727099003|261009223027099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	NDBjd1DSJ+cE9DLO9iAqqg0LSZcZV4yqqvMX2Bz+0arbTdhfXadDRnf81NA+KPy88RIK3aOBl0h3/+vUuJGmSLO1kYBjrHGo56Uu+ScsIL47BSXvBXzJgkIL16eL0/3uDJZK1vO2TAZdqY9cRef+YAZ2ZLMBKGSrYXLxKiyVpxumYkNWU2f8zD4sT5R9uU6B+2cdAFdFuCKydyl2LjPpo8Ir7LxvvTfBonXXlwJiiBb3soj27o6g2Y2dKSvlroS5KVh44TxY+d9LD4iDWY70+bPoi3vdCte6sHlM89mB8ra6dBRoaY+joUb+pl8+RETwBDcFR6jLo+PVleTEwNxKQeiHk5w8+tyfQGudS6uKig+rvj3Uk5O6B/YriDVOdZ3OJ3xL+pB/mszzlrNePrdhm7JPG09fWPFVBTWWgqYjrTyG2pCKC4eahQsCOHWnQXnY88UfDpX61N81DitE7pWdkUxZTLM+EkvI8vwhhsivwsrgZfssgsnEV+oTdNyQYzP+3o9vELHtFle9gJgeNeH7LifydRTiMUQtuFLvUZsD7iBLG+DApwmlmvlu4xKl/dtCix/gZOO3ol4k4kxi2jyqCxNRy+TL6PSl2LUKXR7c4Cl3KEf6vUAw9pUzCHUjPcn+02nWX/IF+GmNFd5aNVHrQt0IAcxucG3CES7b9SBT0dI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(23010399003)(1800799024)(261026140227099003)(261022105027099003)(11063799006)(10067099003)(56012099006)(260925022911599003)(260925021311599003)(260925021911599003)(261028144727099003)(261022075727099003)(261021121427099003)(261021123027099003)(261026121527099003)(261102123227099003)(261102130727099003)(261009223027099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kV+fWVcZNAfPwCUipGPvx1rfoE0d/7m5ROMjFAerMwL2IUXfb+1vhxWvhJZO?=
 =?us-ascii?Q?EbktJYMe7la1eH7E2YlupxqEaFX6z8FISb7rKRgM8bmvSStcUSbKfYDIB1V2?=
 =?us-ascii?Q?eqSKSc6jPAVL5VtM4TJVAjDOCMVySd56DLfh/dWVeK1u9E/Z04rLuiCtG8LP?=
 =?us-ascii?Q?2WwQ0k7nXMVWJfzdItsUR9eCC0QQ/KJa0JbosYWwrUnCcOwfqtI7wdjaiv+o?=
 =?us-ascii?Q?RNYfY2TZZT2+Qa7A9NaLh5WFPQ7fcIVJ/Phm5AyfNfdHLSur7jIqogzFJJOD?=
 =?us-ascii?Q?n5IMlHyruZOReGHmRv+d/toAPfLLhsoMAhSmQiyFrCWW+QNn9IV1SAbqnoyG?=
 =?us-ascii?Q?NM51+FxajSzrhUZZtVJMQU+TD4NS0tTDjN/xgmAF1EiU5mwD/+V69PGjt8FE?=
 =?us-ascii?Q?zP1t3/yh+nqGINrx9dhgNzD1ISRO+PuvWrP6ePMBRSrb8uN2fLw48K+dAWuS?=
 =?us-ascii?Q?dBaQS0HfVkysurt4oK8aOjfBfUo1ZHkS0jQzbaEWJPBBNfSy1klGLFr4Q5gl?=
 =?us-ascii?Q?Jfmt1oFXOOM/s6qmYLm55F3MMzmtyl6I+Q2tL9qrfU/3YLGzb3uHdfA277xx?=
 =?us-ascii?Q?A2Nh5IKnn4rayu4g/Q/sbq5+y8sjN2YuPPv4Urelo69AMLvgE3yyshfV8mAt?=
 =?us-ascii?Q?B0Jkau9vupSbSvtdK6VE8jKl9KhEvpGpOyzWBoongOukIEEziTqyqRfUoWkf?=
 =?us-ascii?Q?me479LKw5WKRp0p4LYhJXRQiu7ld3s4DHbDc/f1Jf6NuPA5mdF34aING5IMZ?=
 =?us-ascii?Q?2OvoUn1om2MNS4DJKFkzLq4nyNehgyVMswuYdOdzw9afMN37bx6GkIKmRhcd?=
 =?us-ascii?Q?e66PjiST18CkzU3qjlYWujpf6+f5p9AHbR9EReXK5Lmwi97Xq4bH2Xye9lwi?=
 =?us-ascii?Q?NsqinGJurCkykjwugQyint1hpz9PtbKcEB5X1gU7sKwgyjOdaFqr5e3yEXvD?=
 =?us-ascii?Q?sMczRpZnoIOzdG97vhFqQLj8ggMipFI+YMfIQcNskgH1SAVoe+3yLPzkFkQb?=
 =?us-ascii?Q?CYFFPsaR1O0TXtxYia2R3wG03k8oDd1OJPVFAcMpF9sISRMXfxPbYJ6ac9d8?=
 =?us-ascii?Q?02YZ2I7kh8cWbOfrP+jkjPkiI12cAbXYWx17ImEMtJ0paPFdAk75BixzoJtU?=
 =?us-ascii?Q?ug+PSwz9+7gcZ0JXRX1GZ1fFOm47NHvUzgvv/WpdRQGtGvCZv3F6vdwz6lKh?=
 =?us-ascii?Q?V1OB2lcbcXx3l8x9h988PLjFBybj21+8retW5kiApYnrR+26GIwEEYw1rej2?=
 =?us-ascii?Q?NoHPgulI2eN8iadjgDR87VlQv2/Qd88y0R+bGi/EexvIGAtbHI3pdSB30Nh9?=
 =?us-ascii?Q?KK42uAeLCkKLp3fnWWf8F0peqfmd0qulFOR+r8+tTdi0AryC+6lSOT9zUxDS?=
 =?us-ascii?Q?sODrWZ10cJlHacJIru/ZQFY6Od9jxeyiA9HDwDFM+5uBMjJ2fLvcRK5aasVD?=
 =?us-ascii?Q?g0+ECFjxcCzw5PDSOeAoiUZ2hPbZ+DyM0JIbbPXMLXIntPiqRiwyoWF7RXtF?=
 =?us-ascii?Q?nCsxopt3HI3bKYnv9/bafQH7TmzNU7r1CXNwGCVJjcWOfw7s8cHwo7scWDQv?=
 =?us-ascii?Q?XL0nHqfq/d+oq1j30WUGGLqrUFenV2P0OoiwDperMMl4blmEkfHdHSnMBfng?=
 =?us-ascii?Q?dTIzljwBk9wsHqGWf2BM6piokmIR33e3K3yjiPf8MSnpBHCC1tgLHmUKqAzt?=
 =?us-ascii?Q?60QvZIf2wfNxlf4YRTXuLAOMwMoo9W/aTTYpW65JkcW+o6tH7GklFGJ6V1N/?=
 =?us-ascii?Q?C3P6G3xlfQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66a2dd1-4d9d-465e-8d56-08df4b6a335b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:06:01.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYEMpj5LApWl0CZXG5TxPEr8QSotphDiFTvKnh6WjlZnNBKPn3zpHhdFNE5h+OFVO3yszdXB9anpnF15kLfx/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8036
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F922100002
X-Rspam-User:
X-Stat-Signature: uzpwni17bc4bsqx8wfra976h8rzyj9ci
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795662489-678117
X-HE-Meta: U2FsdGVkX1+XklV0M8zCHgvoOempnfxvwA2yrpIoU4jviZeOsbJBiFCt51XXLlsfizHXIYL12CtNTuTO3fR1p0umNYEZkaE9TupjpS0Jpy2RmBe4o9SBTpe+wz/HaWpRdi5O9j1ZOpc0tN/Cu7vWZdFAL1LiKsUM2rkvO7cgV5jf0duGeX0xqDkBZvaZ3c41Ksb75bfx+jYLrNuPqM5v7Yd/84qyEVvyZU9a9sZi5BuZBMTuLdKqpE6f1VonAqnsSW7ux3c4pvcWYNmahSWuhmqZbwMMcy67d1lbqzyZWqMFhuuf8OVASx6jfrVBzoChRMreX1CkV4v67NTdDS/uBJ5IJgjdv1pgd1ZtRh4R5Tp8EgnD6OX7k3AaucC4EEVvAM6ujBnaawNGj5v7Feg7s3RmqliKnNa4II7tc7J4rVQ3Xa3hJ3i80e3QjtcXJ59flpFgO/MJXP/73n9V/E6LNtzcHbdlgBRcJqETlLzRqvtwcYrZoQePuP14vFaT+9vHw0jlHXvTyGo4NbYPBVyeFkKPNRiJI2uXkLIYxzM6SygNiVceV5SJHrWEHXuwv7WIGe1VJn8vLk0yUKS8epEQyH1vMRuiXgDyCq4SmwwM/z2HuKPpJmsa3wrY0o0Fex3qDMO55Y2tS9ZuA7X6l7VqXLeKBLo4VKUCE2rkhh4tyX/zfpve5AdgBcbQ5/0vEwvTNO2OtwoBnK0JECVJdq6azaMzz3Vwk+9a1sUghL+IaSoRIC6nd7Axx4e/pE+0+G/Gif1SKgKbE7GBH2cBascr4BsdTuOHXMoVG7DfvIwNxowufnlE0q33817zafpk5Ij1BmtfJujtnQc01+6H8MIK8W+GpTST1qWsf2HZSztCh7zZwhpbWa+0y+Ji9gLcqoUJDb582N744FEku8BOw2ul0pOTsmdLs3BjL3rqtQL92men2RP2hcqbxQ5kYc4AiWnUIt832iNzcL6r6YCtLOT
 ShmTM5HP
 sWeXepJH5rFv5Qmp/3sm1xgWUGJzS+N2mkmMTia8UCUyiNyS3G0rfPDgS+Dzd+0vUGqFVxQSp2YKl2HtjMs0WW4XwZUj8X8qInwFunilCG1ApZN1YXOqQtkPQ5X8MbcEAnlqPOhhnLDP4NJxY8yQTY1qvFvFec/KaLlIIzRN5qqe3dXBjWhJ7a2jWfhxmW7DhdzyTxJIj+utjumNe8G6DDIlqJY6foO0YyoGPONahYSU8bS/7o51Tu0EjIB9RqzVZaBkyBEDXp92NVYA1LZ5Rta28LDI7bIPimWKcu5CPyBswevEWqfMdHMhYkpyNqQjpJt4PsYnIWkoVzA8yH0wztHCvkKpLEbimlkpV3vSs02qXnCwkNzCuU/N6UhU6JnKZPGL4Pc1+/a/DV5y/Oz8TDqUPinPDYw0Kme+lJspm992aLCa2IdJ8QYg/g6Hg5hwWTDbPVbuvEO/YvYdzi5PvcMwDPMPSMPkpfisRSZ9llzSOA1vn3Pq8zmus3bcG5NjTmUiXiTMV9jz7+jIPHjJ4dNg94usyrndC95Z+Q3ka0OYGl7cGflNBHm+7IA/la2+JrHM6Bj0DecOo4XPwcizDRkXbFbyHHaA6gxMDh3R/GdiTu8/ISz+4mkP7ZHHF6LV9vwt79TpH7xMPJcLFd1UCSJJSxdcjQao6aO2KqtMZsRBd/22QFHEKYqrz1Pt9honGrRZAadi7LeoLKFe0VOWHjzze9SjtHzKOTh7tvirO2L3XwlKj5qT6OvOxaGlWSWkhdLBJXRPkFDIa6VCsKUkg7xbOmUPIix7oEmMnCBKT1rc3b6AgDnzGNqHUkqNRxuzM8WrRSzDBgObioL/nIgls3T7nrhVGrtP7I59OMN2IY5nEd3PllHwVuJP72PqF1F+/BfR+jj0FzA+9RheR0ql77hw+TurivOnGexhJX7FJ7xckfMRs5iV10aYL+MBGlxEAbxeUGC4SbWR1FUWhgF0Jk6NDJ7jt
 /zQOYP71
 7DQD9H5jxJUBxHOfdzbGRpbXUbWIi678/xjylWywgXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The HMM selftest runs benchmark_thp_migration on every invocation.
The benchmark repeatedly migrates buffers in both directions to measure
latency and throughput with and without THP. Run it on demand so the
regular suite spends its time checking correctness.

Move the benchmark into its own hmm-bench binary and share the device
fixture, buffer helpers and migration ioctls with hmm-tests. To run it:

  make -C tools/testing/performance-tests/mm
  sudo modprobe test_hmm
  sudo tools/testing/performance-tests/mm/hmm-bench

Drop the 128-PMD buffer to bound the amount of memory migrated in one
measurement. With 2 MiB PMDs, the largest buffer falls from 256 MiB to
16 MiB. The remaining sizes still cover buffers smaller than a PMD, a
single PMD and multiple PMDs, with and without MADV_HUGEPAGE.

Call fflush(stdout) after printing the results for each buffer size.
The kselftest harness ends the test child with _exit(0), so timing
results still buffered in stdout can be lost when output is redirected
to a file or pipe.

Link: https://lore.kernel.org/r/20261124215730.0f6adc9ad36c7abc623a1dde@linux-foundation.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
On mm-everything-2026-11-24-10-33, hmm.hmm_device_private.migrate_fault
fails with -ENOENT on the second migration to the device. I reproduced
this in QEMU with the selftest binaries built before and after this
patch. In the same guest, both binaries pass with test_hmm built from
the parent of 5cbbd205947d ("lib/test_hmm: invalidate all mirrors on
device-private migration") and both fail with test_hmm from that commit.

 MAINTAINERS                                   |   1 +
 tools/testing/performance-tests/mm/.gitignore |   1 +
 tools/testing/performance-tests/mm/Makefile   |  13 +
 .../testing/performance-tests/mm/hmm-bench.c  | 191 +++++++++
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/hmm-common.h       | 202 +++++++++
 tools/testing/selftests/mm/hmm-tests.c        | 384 +-----------------
 7 files changed, 410 insertions(+), 383 deletions(-)
 create mode 100644 tools/testing/performance-tests/mm/.gitignore
 create mode 100644 tools/testing/performance-tests/mm/Makefile
 create mode 100644 tools/testing/performance-tests/mm/hmm-bench.c
 create mode 100644 tools/testing/selftests/mm/hmm-common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a3548854767..e97699c6f90b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12218,6 +12218,7 @@ F:	Documentation/mm/hmm.rst
 F:	include/linux/hmm*
 F:	lib/test_hmm*
 F:	mm/hmm*
+F:	tools/testing/performance-tests/mm/*hmm*
 F:	tools/testing/selftests/mm/*hmm*
 
 HONEYWELL ABP2030PA PRESSURE SENSOR SERIES IIO DRIVER
diff --git a/tools/testing/performance-tests/mm/.gitignore b/tools/testing/performance-tests/mm/.gitignore
new file mode 100644
index 000000000000..d4cc8960680c
--- /dev/null
+++ b/tools/testing/performance-tests/mm/.gitignore
@@ -0,0 +1 @@
+/hmm-bench
diff --git a/tools/testing/performance-tests/mm/Makefile b/tools/testing/performance-tests/mm/Makefile
new file mode 100644
index 000000000000..03a133f4bd28
--- /dev/null
+++ b/tools/testing/performance-tests/mm/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS := hmm-bench
+
+CFLAGS += -Wall -O2 -I$(top_srcdir) -I$(top_srcdir)/tools/lib
+CFLAGS += $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+LOCAL_HDRS += $(selfdir)/mm/hmm-common.h $(selfdir)/mm/vm_util.h
+LOCAL_HDRS += $(top_srcdir)/lib/test_hmm_uapi.h
+
+include ../../selftests/lib.mk
+
+$(OUTPUT)/hmm-bench: $(selfdir)/mm/vm_util.c \
+		     $(top_srcdir)/tools/lib/mm/hugepage_settings.c \
+		     $(top_srcdir)/tools/lib/mm/file_utils.c
diff --git a/tools/testing/performance-tests/mm/hmm-bench.c b/tools/testing/performance-tests/mm/hmm-bench.c
new file mode 100644
index 000000000000..a80f5268fb75
--- /dev/null
+++ b/tools/testing/performance-tests/mm/hmm-bench.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <limits.h>
+#include <sys/time.h>
+#include <mm/hmm-common.h>
+
+struct benchmark_results {
+	double sys_to_dev_time;
+	double dev_to_sys_time;
+	double throughput_s2d;
+	double throughput_d2s;
+};
+
+static double get_time_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000.0) + (tv.tv_usec / 1000.0);
+}
+
+static void print_benchmark_results(const char *test_name, size_t buffer_size,
+				     struct benchmark_results *thp,
+				     struct benchmark_results *regular)
+{
+	double s2d_improvement = ((regular->sys_to_dev_time - thp->sys_to_dev_time) /
+				 regular->sys_to_dev_time) * 100.0;
+	double d2s_improvement = ((regular->dev_to_sys_time - thp->dev_to_sys_time) /
+				 regular->dev_to_sys_time) * 100.0;
+	double throughput_s2d_improvement = ((thp->throughput_s2d - regular->throughput_s2d) /
+					    regular->throughput_s2d) * 100.0;
+	double throughput_d2s_improvement = ((thp->throughput_d2s - regular->throughput_d2s) /
+					    regular->throughput_d2s) * 100.0;
+
+	printf("\n=== %s (%.1f MB) ===\n", test_name, buffer_size / (1024.0 * 1024.0));
+	printf("                     | With THP        | Without THP     | Improvement\n");
+	printf("---------------------------------------------------------------------\n");
+	printf("Sys->Dev Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
+	       thp->sys_to_dev_time, regular->sys_to_dev_time, s2d_improvement);
+	printf("Dev->Sys Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
+	       thp->dev_to_sys_time, regular->dev_to_sys_time, d2s_improvement);
+	printf("S->D Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
+	       thp->throughput_s2d, regular->throughput_s2d, throughput_s2d_improvement);
+	printf("D->S Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
+	       thp->throughput_d2s, regular->throughput_d2s, throughput_d2s_improvement);
+	fflush(stdout);
+}
+
+/*
+ * Run a single migration benchmark
+ * fd: file descriptor for hmm device
+ * use_thp: whether to use THP
+ * buffer_size: size of buffer to allocate
+ * iterations: number of iterations
+ * results: where to store results
+ */
+static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_size,
+					   int iterations, struct benchmark_results *results)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages = buffer_size / sysconf(_SC_PAGESIZE);
+	double start, end;
+	double s2d_total = 0, d2s_total = 0;
+	int ret, i;
+	int *ptr;
+
+	buffer = hmm_buffer_alloc(buffer_size, buffer_size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	if (!buffer) {
+		ret = -1;
+		goto cleanup;
+	}
+	memset(buffer->mirror, 0xFF, buffer_size);
+
+	/* Apply THP hint if requested */
+	if (use_thp)
+		ret = madvise(buffer->ptr, buffer_size, MADV_HUGEPAGE);
+	else
+		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
+
+	if (ret)
+		goto cleanup;
+
+	/* Initialize memory to make sure pages are allocated */
+	ptr = (int *)buffer->ptr;
+	for (i = 0; i < buffer_size / sizeof(int); i++)
+		ptr[i] = i & 0xFF;
+
+	/* Warmup iteration */
+	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
+	if (ret)
+		goto cleanup;
+
+	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
+	if (ret)
+		goto cleanup;
+
+	/* Benchmark iterations */
+	for (i = 0; i < iterations; i++) {
+		/* System to device migration */
+		start = get_time_ms();
+
+		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
+		if (ret)
+			goto cleanup;
+
+		end = get_time_ms();
+		s2d_total += (end - start);
+
+		/* Device to system migration */
+		start = get_time_ms();
+
+		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
+		if (ret)
+			goto cleanup;
+
+		end = get_time_ms();
+		d2s_total += (end - start);
+	}
+
+	/* Calculate average times and throughput */
+	results->sys_to_dev_time = s2d_total / iterations;
+	results->dev_to_sys_time = d2s_total / iterations;
+	results->throughput_s2d = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
+				 (results->sys_to_dev_time / 1000.0);
+	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
+				 (results->dev_to_sys_time / 1000.0);
+
+cleanup:
+	hmm_buffer_free(buffer);
+	return ret;
+}
+
+/*
+ * Benchmark THP migration with different buffer sizes
+ */
+TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
+{
+	struct benchmark_results thp_results, regular_results;
+	size_t thp_size = pmd_psize();
+	int iterations = 5;
+
+	if (!thp_size)
+		thp_size = TWOMEG;
+
+	printf("\nHMM THP Migration Benchmark\n");
+	printf("---------------------------\n");
+	printf("System page size: %ld bytes\n", sysconf(_SC_PAGESIZE));
+
+	/* Test different buffer sizes */
+	size_t test_sizes[] = {
+		thp_size / 4,      /* quarter THP */
+		thp_size / 2,      /* half THP */
+		thp_size,          /* single THP */
+		thp_size * 2,      /* two THPs */
+		thp_size * 4,      /* four THPs */
+		thp_size * 8,      /* eight THPs */
+	};
+
+	static const char *const test_names[] = {
+		"Small Buffer",
+		"Half THP Size",
+		"Single THP Size",
+		"Two THP Size",
+		"Four THP Size",
+		"Eight THP Size",
+	};
+
+	int num_tests = ARRAY_SIZE(test_sizes);
+
+	/* Run all tests */
+	for (int i = 0; i < num_tests; i++) {
+		/* Skip test sizes exceeding INT_MAX to avoid overflow */
+		if (test_sizes[i] > INT_MAX)
+			break;
+
+		/* Test with THP */
+		ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
+					iterations, &thp_results), 0);
+
+		/* Test without THP */
+		ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes[i],
+					iterations, &regular_results), 0);
+
+		/* Print results */
+		print_benchmark_results(test_names[i], test_sizes[i],
+					&thp_results, &regular_results);
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 675ec57d47de..c129ac2c635a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -6,6 +6,7 @@
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
 LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/hmm-common.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
diff --git a/tools/testing/selftests/mm/hmm-common.h b/tools/testing/selftests/mm/hmm-common.h
new file mode 100644
index 000000000000..838d496b35fb
--- /dev/null
+++ b/tools/testing/selftests/mm/hmm-common.h
@@ -0,0 +1,202 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef HMM_COMMON_H
+#define HMM_COMMON_H
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <strings.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include "kselftest_harness.h"
+#include <mm/vm_util.h>
+
+/*
+ * This is a private UAPI to the kernel test module so it isn't exported
+ * in the usual include/uapi/... directory.
+ */
+#include <lib/test_hmm_uapi.h>
+
+struct hmm_buffer {
+	void		*ptr;
+	void		*mirror;
+	unsigned long	size;
+	int		fd;
+	uint64_t	cpages;
+	uint64_t	faults;
+};
+
+enum {
+	HMM_PRIVATE_DEVICE_ONE,
+	HMM_PRIVATE_DEVICE_TWO,
+	HMM_COHERENCE_DEVICE_ONE,
+	HMM_COHERENCE_DEVICE_TWO,
+};
+
+#define TWOMEG		(1 << 21)
+#define HMM_PATH_MAX    64
+
+FIXTURE(hmm)
+{
+	int		fd;
+	unsigned int	page_size;
+	unsigned int	page_shift;
+};
+
+FIXTURE_VARIANT(hmm)
+{
+	int     device_number;
+};
+
+FIXTURE_VARIANT_ADD(hmm, hmm_device_private)
+{
+	.device_number = HMM_PRIVATE_DEVICE_ONE,
+};
+
+FIXTURE_VARIANT_ADD(hmm, hmm_device_coherent)
+{
+	.device_number = HMM_COHERENCE_DEVICE_ONE,
+};
+
+static int hmm_open(int unit)
+{
+	char pathname[HMM_PATH_MAX];
+	int fd;
+
+	snprintf(pathname, sizeof(pathname), "/dev/hmm_dmirror%d", unit);
+	fd = open(pathname, O_RDWR, 0);
+	if (fd < 0)
+		fprintf(stderr, "could not open hmm dmirror driver (%s)\n",
+			pathname);
+	return fd;
+}
+
+static bool hmm_is_coherent_type(int dev_num)
+{
+	return (dev_num >= HMM_COHERENCE_DEVICE_ONE);
+}
+
+FIXTURE_SETUP(hmm)
+{
+	self->page_size = sysconf(_SC_PAGE_SIZE);
+	self->page_shift = ffs(self->page_size) - 1;
+
+	self->fd = hmm_open(variant->device_number);
+	if (self->fd < 0 && hmm_is_coherent_type(variant->device_number))
+		SKIP(return, "DEVICE_COHERENT not available");
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(hmm)
+{
+	int ret = close(self->fd);
+
+	ASSERT_EQ(ret, 0);
+	self->fd = -1;
+}
+
+static int hmm_dmirror_cmd(int fd,
+			   unsigned long request,
+			   struct hmm_buffer *buffer,
+			   unsigned long npages)
+{
+	struct hmm_dmirror_cmd cmd;
+	int ret;
+
+	/* Simulate a device reading system memory. */
+	cmd.addr = ptr_to_u64(buffer->ptr);
+	cmd.ptr = ptr_to_u64(buffer->mirror);
+	cmd.npages = npages;
+
+	for (;;) {
+		ret = ioctl(fd, request, &cmd);
+		if (ret == 0)
+			break;
+		if (errno == EINTR)
+			continue;
+		return -errno;
+	}
+	buffer->cpages = cmd.cpages;
+	buffer->faults = cmd.faults;
+
+	return 0;
+}
+
+static void hmm_buffer_free(struct hmm_buffer *buffer)
+{
+	if (buffer == NULL)
+		return;
+
+	if (buffer->ptr) {
+		munmap(buffer->ptr, buffer->size);
+		buffer->ptr = NULL;
+	}
+	free(buffer->mirror);
+	free(buffer);
+}
+
+/*
+ * Allocate a buffer structure with memory mapping and mirror.
+ *
+ * @mmap_size:   total size of the mmap region (may differ from @mirror_size
+ *               for alignment padding in THP tests).
+ * @mirror_size: size of the mirror data buffer (the actual working set).
+ * @prot:        protection flags for the mmap (e.g. PROT_READ | PROT_WRITE).
+ * @flags:       flags for the mmap (e.g. MAP_PRIVATE, MAP_SHARED,
+ *               MAP_ANONYMOUS, MAP_HUGETLB).
+ * @fd:          file descriptor for the mmap; pass -1 for MAP_ANONYMOUS.
+ *
+ * All internal allocations are checked; returns NULL and cleans up on any
+ * failure. Caller must ASSERT_NE or otherwise check the return value.
+ */
+static struct hmm_buffer *hmm_buffer_alloc(unsigned long mmap_size,
+						unsigned long mirror_size,
+						int prot, int flags,
+						int fd)
+{
+	struct hmm_buffer *buffer;
+
+	buffer = malloc(sizeof(*buffer));
+	if (!buffer) {
+		perror("malloc buffer");
+		return NULL;
+	}
+
+	buffer->fd = fd;
+	buffer->size = mmap_size;
+	buffer->mirror = malloc(mirror_size);
+	if (!buffer->mirror) {
+		perror("malloc mirror");
+		free(buffer);
+		return NULL;
+	}
+
+	buffer->ptr = mmap(NULL, mmap_size, prot, flags, fd, 0);
+	if (buffer->ptr == MAP_FAILED) {
+		perror("mmap");
+		free(buffer->mirror);
+		free(buffer);
+		return NULL;
+	}
+
+	return buffer;
+}
+
+static int hmm_migrate_sys_to_dev(int fd,
+				   struct hmm_buffer *buffer,
+				   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
+}
+
+static int hmm_migrate_dev_to_sys(int fd,
+				   struct hmm_buffer *buffer,
+				   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_SYS, buffer, npages);
+}
+
+#endif /* HMM_COMMON_H */
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 066207ae8e3b..3969f52e7525 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -10,59 +10,22 @@
  * bugs.
  */
 
-#include <errno.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <unistd.h>
-#include <strings.h>
 #include <time.h>
 #include <pthread.h>
-#include <limits.h>
 #include <linux/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/ioctl.h>
-#include <sys/time.h>
 #include <sys/syscall.h>
 #include <sys/eventfd.h>
 #include <linux/userfaultfd.h>
 #include <poll.h>
 #include <mm/hugepage_settings.h>
-
-#include "kselftest_harness.h"
-
-/*
- * This is a private UAPI to the kernel test module so it isn't exported
- * in the usual include/uapi/... directory.
- */
-#include <lib/test_hmm_uapi.h>
 #include <mm/gup_test.h>
-#include <mm/vm_util.h>
-
-struct hmm_buffer {
-	void		*ptr;
-	void		*mirror;
-	unsigned long	size;
-	int		fd;
-	uint64_t	cpages;
-	uint64_t	faults;
-};
-
-enum {
-	HMM_PRIVATE_DEVICE_ONE,
-	HMM_PRIVATE_DEVICE_TWO,
-	HMM_COHERENCE_DEVICE_ONE,
-	HMM_COHERENCE_DEVICE_TWO,
-};
+#include "hmm-common.h"
 
 #define ONEKB		(1 << 10)
 #define ONEMEG		(1 << 20)
-#define TWOMEG		(1 << 21)
 #define HMM_BUFFER_SIZE (1024 << 12)
-#define HMM_PATH_MAX    64
 #define NTIMES		10
 
 /* Just the flags we need, copied from mm.h: */
@@ -77,28 +40,6 @@ enum {
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
 
-FIXTURE(hmm)
-{
-	int		fd;
-	unsigned int	page_size;
-	unsigned int	page_shift;
-};
-
-FIXTURE_VARIANT(hmm)
-{
-	int     device_number;
-};
-
-FIXTURE_VARIANT_ADD(hmm, hmm_device_private)
-{
-	.device_number = HMM_PRIVATE_DEVICE_ONE,
-};
-
-FIXTURE_VARIANT_ADD(hmm, hmm_device_coherent)
-{
-	.device_number = HMM_COHERENCE_DEVICE_ONE,
-};
-
 FIXTURE(hmm2)
 {
 	int		fd0;
@@ -125,35 +66,6 @@ FIXTURE_VARIANT_ADD(hmm2, hmm2_device_coherent)
 	.device_number1 = HMM_COHERENCE_DEVICE_TWO,
 };
 
-static int hmm_open(int unit)
-{
-	char pathname[HMM_PATH_MAX];
-	int fd;
-
-	snprintf(pathname, sizeof(pathname), "/dev/hmm_dmirror%d", unit);
-	fd = open(pathname, O_RDWR, 0);
-	if (fd < 0)
-		fprintf(stderr, "could not open hmm dmirror driver (%s)\n",
-			pathname);
-	return fd;
-}
-
-static bool hmm_is_coherent_type(int dev_num)
-{
-	return (dev_num >= HMM_COHERENCE_DEVICE_ONE);
-}
-
-FIXTURE_SETUP(hmm)
-{
-	self->page_size = sysconf(_SC_PAGE_SIZE);
-	self->page_shift = ffs(self->page_size) - 1;
-
-	self->fd = hmm_open(variant->device_number);
-	if (self->fd < 0 && hmm_is_coherent_type(variant->device_number))
-		SKIP(return, "DEVICE_COHERENT not available");
-	ASSERT_GE(self->fd, 0);
-}
-
 FIXTURE_SETUP(hmm2)
 {
 	self->page_size = sysconf(_SC_PAGE_SIZE);
@@ -167,14 +79,6 @@ FIXTURE_SETUP(hmm2)
 	ASSERT_GE(self->fd1, 0);
 }
 
-FIXTURE_TEARDOWN(hmm)
-{
-	int ret = close(self->fd);
-
-	ASSERT_EQ(ret, 0);
-	self->fd = -1;
-}
-
 FIXTURE_TEARDOWN(hmm2)
 {
 	int ret = close(self->fd0);
@@ -187,93 +91,6 @@ FIXTURE_TEARDOWN(hmm2)
 	self->fd1 = -1;
 }
 
-static int hmm_dmirror_cmd(int fd,
-			   unsigned long request,
-			   struct hmm_buffer *buffer,
-			   unsigned long npages)
-{
-	struct hmm_dmirror_cmd cmd;
-	int ret;
-
-	/* Simulate a device reading system memory. */
-	cmd.addr = ptr_to_u64(buffer->ptr);
-	cmd.ptr = ptr_to_u64(buffer->mirror);
-	cmd.npages = npages;
-
-	for (;;) {
-		ret = ioctl(fd, request, &cmd);
-		if (ret == 0)
-			break;
-		if (errno == EINTR)
-			continue;
-		return -errno;
-	}
-	buffer->cpages = cmd.cpages;
-	buffer->faults = cmd.faults;
-
-	return 0;
-}
-
-static void hmm_buffer_free(struct hmm_buffer *buffer)
-{
-	if (buffer == NULL)
-		return;
-
-	if (buffer->ptr) {
-		munmap(buffer->ptr, buffer->size);
-		buffer->ptr = NULL;
-	}
-	free(buffer->mirror);
-	free(buffer);
-}
-
-/*
- * Allocate a buffer structure with memory mapping and mirror.
- *
- * @mmap_size:   total size of the mmap region (may differ from @mirror_size
- *               for alignment padding in THP tests).
- * @mirror_size: size of the mirror data buffer (the actual working set).
- * @prot:        protection flags for the mmap (e.g. PROT_READ | PROT_WRITE).
- * @flags:       flags for the mmap (e.g. MAP_PRIVATE, MAP_SHARED,
- *               MAP_ANONYMOUS, MAP_HUGETLB).
- * @fd:          file descriptor for the mmap; pass -1 for MAP_ANONYMOUS.
- *
- * All internal allocations are checked; returns NULL and cleans up on any
- * failure. Caller must ASSERT_NE or otherwise check the return value.
- */
-static struct hmm_buffer *hmm_buffer_alloc(unsigned long mmap_size,
-						unsigned long mirror_size,
-						int prot, int flags,
-						int fd)
-{
-	struct hmm_buffer *buffer;
-
-	buffer = malloc(sizeof(*buffer));
-	if (!buffer) {
-		perror("malloc buffer");
-		return NULL;
-	}
-
-	buffer->fd = fd;
-	buffer->size = mmap_size;
-	buffer->mirror = malloc(mirror_size);
-	if (!buffer->mirror) {
-		perror("malloc mirror");
-		free(buffer);
-		return NULL;
-	}
-
-	buffer->ptr = mmap(NULL, mmap_size, prot, flags, fd, 0);
-	if (buffer->ptr == MAP_FAILED) {
-		perror("mmap");
-		free(buffer->mirror);
-		free(buffer);
-		return NULL;
-	}
-
-	return buffer;
-}
-
 /*
  * Create a temporary file that will be deleted on close.
  */
@@ -326,20 +143,6 @@ static void hmm_nanosleep(unsigned int n)
 	nanosleep(&t, NULL);
 }
 
-static int hmm_migrate_sys_to_dev(int fd,
-				   struct hmm_buffer *buffer,
-				   unsigned long npages)
-{
-	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
-}
-
-static int hmm_migrate_dev_to_sys(int fd,
-				   struct hmm_buffer *buffer,
-				   unsigned long npages)
-{
-	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_SYS, buffer, npages);
-}
-
 /*
  * Simple NULL test of device open/close.
  */
@@ -2506,191 +2309,6 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	hmm_buffer_free(buffer);
 }
 
-struct benchmark_results {
-	double sys_to_dev_time;
-	double dev_to_sys_time;
-	double throughput_s2d;
-	double throughput_d2s;
-};
-
-static double get_time_ms(void)
-{
-	struct timeval tv;
-
-	gettimeofday(&tv, NULL);
-	return (tv.tv_sec * 1000.0) + (tv.tv_usec / 1000.0);
-}
-
-static void print_benchmark_results(const char *test_name, size_t buffer_size,
-				     struct benchmark_results *thp,
-				     struct benchmark_results *regular)
-{
-	double s2d_improvement = ((regular->sys_to_dev_time - thp->sys_to_dev_time) /
-				 regular->sys_to_dev_time) * 100.0;
-	double d2s_improvement = ((regular->dev_to_sys_time - thp->dev_to_sys_time) /
-				 regular->dev_to_sys_time) * 100.0;
-	double throughput_s2d_improvement = ((thp->throughput_s2d - regular->throughput_s2d) /
-					    regular->throughput_s2d) * 100.0;
-	double throughput_d2s_improvement = ((thp->throughput_d2s - regular->throughput_d2s) /
-					    regular->throughput_d2s) * 100.0;
-
-	printf("\n=== %s (%.1f MB) ===\n", test_name, buffer_size / (1024.0 * 1024.0));
-	printf("                     | With THP        | Without THP     | Improvement\n");
-	printf("---------------------------------------------------------------------\n");
-	printf("Sys->Dev Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
-	       thp->sys_to_dev_time, regular->sys_to_dev_time, s2d_improvement);
-	printf("Dev->Sys Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
-	       thp->dev_to_sys_time, regular->dev_to_sys_time, d2s_improvement);
-	printf("S->D Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
-	       thp->throughput_s2d, regular->throughput_s2d, throughput_s2d_improvement);
-	printf("D->S Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
-	       thp->throughput_d2s, regular->throughput_d2s, throughput_d2s_improvement);
-}
-
-/*
- * Run a single migration benchmark
- * fd: file descriptor for hmm device
- * use_thp: whether to use THP
- * buffer_size: size of buffer to allocate
- * iterations: number of iterations
- * results: where to store results
- */
-static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_size,
-					   int iterations, struct benchmark_results *results)
-{
-	struct hmm_buffer *buffer;
-	unsigned long npages = buffer_size / sysconf(_SC_PAGESIZE);
-	double start, end;
-	double s2d_total = 0, d2s_total = 0;
-	int ret, i;
-	int *ptr;
-
-	buffer = hmm_buffer_alloc(buffer_size, buffer_size,
-				  PROT_READ | PROT_WRITE,
-				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
-	if (!buffer) {
-		ret = -1;
-		goto cleanup;
-	}
-	memset(buffer->mirror, 0xFF, buffer_size);
-
-	/* Apply THP hint if requested */
-	if (use_thp)
-		ret = madvise(buffer->ptr, buffer_size, MADV_HUGEPAGE);
-	else
-		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
-
-	if (ret)
-		goto cleanup;
-
-	/* Initialize memory to make sure pages are allocated */
-	ptr = (int *)buffer->ptr;
-	for (i = 0; i < buffer_size / sizeof(int); i++)
-		ptr[i] = i & 0xFF;
-
-	/* Warmup iteration */
-	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
-	if (ret)
-		goto cleanup;
-
-	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
-	if (ret)
-		goto cleanup;
-
-	/* Benchmark iterations */
-	for (i = 0; i < iterations; i++) {
-		/* System to device migration */
-		start = get_time_ms();
-
-		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
-		if (ret)
-			goto cleanup;
-
-		end = get_time_ms();
-		s2d_total += (end - start);
-
-		/* Device to system migration */
-		start = get_time_ms();
-
-		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
-		if (ret)
-			goto cleanup;
-
-		end = get_time_ms();
-		d2s_total += (end - start);
-	}
-
-	/* Calculate average times and throughput */
-	results->sys_to_dev_time = s2d_total / iterations;
-	results->dev_to_sys_time = d2s_total / iterations;
-	results->throughput_s2d = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
-				 (results->sys_to_dev_time / 1000.0);
-	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
-				 (results->dev_to_sys_time / 1000.0);
-
-cleanup:
-	hmm_buffer_free(buffer);
-	return ret;
-}
-
-/*
- * Benchmark THP migration with different buffer sizes
- */
-TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
-{
-	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = pmd_psize();
-	int iterations = 5;
-
-	if (!thp_size)
-		thp_size = TWOMEG;
-
-	printf("\nHMM THP Migration Benchmark\n");
-	printf("---------------------------\n");
-	printf("System page size: %ld bytes\n", sysconf(_SC_PAGESIZE));
-
-	/* Test different buffer sizes */
-	size_t test_sizes[] = {
-		thp_size / 4,      /* quarter THP */
-		thp_size / 2,      /* half THP */
-		thp_size,          /* single THP */
-		thp_size * 2,      /* two THPs */
-		thp_size * 4,      /* four THPs */
-		thp_size * 8,      /* eight THPs */
-		thp_size * 128,    /* one twenty eight THPs */
-	};
-
-	static const char *const test_names[] = {
-		"Small Buffer",
-		"Half THP Size",
-		"Single THP Size",
-		"Two THP Size",
-		"Four THP Size",
-		"Eight THP Size",
-		"One twenty eight THP Size"
-	};
-
-	int num_tests = ARRAY_SIZE(test_sizes);
-
-	/* Run all tests */
-	for (int i = 0; i < num_tests; i++) {
-		/* Skip test sizes exceeding INT_MAX to avoid overflow */
-		if (test_sizes[i] > INT_MAX)
-			break;
-
-		/* Test with THP */
-		ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
-					iterations, &thp_results), 0);
-
-		/* Test without THP */
-		ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes[i],
-					iterations, &regular_results), 0);
-
-		/* Print results */
-		print_benchmark_results(test_names[i], test_sizes[i],
-					&thp_results, &regular_results);
-	}
-}
 /*
  * Test that HMM can fault in pages backed by userfaultfd using the
  * hmm_range_fault_unlocked_timeout() path with no timeout. This exercises
-- 
2.56.0


