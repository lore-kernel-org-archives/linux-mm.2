Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFF3D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6F06B00CB; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC78D6B00D0; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98906B00CE; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A34D6B00CD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 506B11A0476
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:30 +0000 (UTC)
X-FDA: 84335207460.12.B45CCF2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC567C000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="G3a0X4/3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qy2iGWjH;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbyHDDbB3ULX2A7iTXjZIe1zkOroVOrpUZzmi13DPio=;
	b=Xg1AHxCbhZ8+gOWME/8KuZGNKdicz86uOxyGfUiLNFBULUmIAJzOBEhW2gjhsrNW29ZLGG
	dsDTuZX5HWp4J2KiRCG9ZudXvvU8kgkl/fTshtMlzSCtR0oKqXgORulljWHkHepsWev+4z
	L18wlV9S0N0ztjCorDM9/6+0yrhEC40=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="G3a0X4/3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qy2iGWjH;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505847; a=rsa-sha256;
	cv=pass;
	b=MfgPBx//oCIAAuugsRmcVU9HyHfFRaB4+iVZUPJrebL/LDEc9hAmyiWlhejne/mW5Aaz8o
	PGbquKv1j/wPpPv5eKxDu1wU8zvuJgZHkfaCWn8d6G1qz1TpAq0kia04ZwDk+vEUv0yxi3
	0KI1TsXzzWQiAHStMdGCZNylgQyNUQw=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FE7VOI1295689;
	Thu, 15 Jan 2026 19:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nbyHDDbB3ULX2A7iTXjZIe1zkOroVOrpUZzmi13DPio=; b=
	G3a0X4/39soOWX58kFeOt1pVfr70pq7u3cTtiYcJ1rEdLLbJlK9PU3Y6uNrh6gyX
	UrAacZ1W7UTWZRYjjNND5i/HUzZSVInC4PbQTwjYd59ZPI65NsiFa+yqVrpeJ6Sg
	l+dBimrgZ11B+NKjhOGQxfgKr7nk8bk/7GYfdgAJBVmrng7BQ7roG/GuufaofOzh
	Ufr8fdc27NSf+mJSbzG6ki82SpY6MvUMuKBm3UMxvULMftuLEXmwyEE9Hj8J7JBA
	0P6hgPlI2PB2YCzl+/I+vPhdnRmrFWVGfd6qHdUnuBwmTEtg19Ug1F/nYkSztahL
	Fbki+gA5439Rc00/KcnG5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJP3hn001847;
	Thu, 15 Jan 2026 19:37:14 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bpuc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2rAq/cK+EQP5Iqh/BsIZ5fOg2nmBP6sgxMhlvzpLB/c0d7PLKBBHMMESUs4HC4xMSe6TtNcFiRluQW2Zu3NWjaKtas3HVnh3xaGXckdl/Ryok2AlnX6Hwx12dBXw1/TDzCjZ5E90FnYFHSqD1SSoMdKumH6TIYASXfzBaQmNiYh/1xdo2oyQoRJmLxfmRndYuEC6yvUjAQEWYnWu+8a+mrVrN1NTdYt4ZpUq2z5z/IzIMPdCgtVFGlRkMDSYitFLYwt8PDoMsDvs0UgORdqd3mBp+I+yadcyOi4FI0g8LBa+eBphAaQHOCiG51lXEaysw9Uuqu602y4ogW3FCZajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbyHDDbB3ULX2A7iTXjZIe1zkOroVOrpUZzmi13DPio=;
 b=LdYWhJqOG/Cl69VeAoOBKcIV8q74TO2I2G6kq7uWo4t3CvhVMrw/n+4Htb32lurFd/5VDcpdoHLm+59MBRWmmkDcx6+64S/b7pb5mb6ulKD61gKzOoQB6wVA+7mQWPXxCelJ/kKzp6Iq4JANEE0JSsMxm4Z7yUtsK85IkuL1drT9saYYh/S6E4L7w+WVF122kyO64mbH7lUoMr7Dfp5YkDGjFlh6za9lnIYpqHLDXcEhh6qSQuYSV7kCF/PzHvMFzMjZyV5ex6No0PbLXMhbzpZmIRZj2l7aQnKUTMAxnEqbQZN9mrIIvSg3l6CECFkc4I5ZMJC5W2diaNFhwFOgww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbyHDDbB3ULX2A7iTXjZIe1zkOroVOrpUZzmi13DPio=;
 b=qy2iGWjHpGTJBYQPHGvWyzR/CIZk7+AmNA1MsP3+3YCZ1FJ1AEtZXM3E2XJuedJR/yuZ9iOrivXRC6kxuIfmkeB5BVdPqpfbZzRP6O0Vqnu1wDJtlz0xEO+fbMMgB2xlQCWCOYAzyP5Wuoawjl7W6+h1fq6KlxqzEG6LxSscYbw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:37:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:10 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 06/28] maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
Date: Thu, 15 Jan 2026 14:36:25 -0500
Message-ID: <20260115193647.1695937-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::33) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: c7720962-5786-48ae-6d47-08de546d79bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E2ZydJ15wodrA5Ldst6c61WyImj7BdBQPeC5TlTcMbjizS1ACooH3iv1h+rF?=
 =?us-ascii?Q?Mh3ebFZHwhIjYKCJdTbrLYpA6PoqSBc+/sHmQLWDZCVxoZ3cFKshzGcutfrL?=
 =?us-ascii?Q?KwBRgslfg6sbeiKnpl6lZqfEAtuna7dRg1OS5OhNEPKYvIdAvVKd/tMKrwAt?=
 =?us-ascii?Q?SZoBMIPzsvCqu6ndov+vQgUFI610IkfZz1Roh+rHe/5FySsJTMJLsfCZltL0?=
 =?us-ascii?Q?+tUL+7IYQEwZJvb/0aHg2XYT5j62an2tESGarid5QBfOyvJIVAEa/Qpu7Wz2?=
 =?us-ascii?Q?nR8GpPPLJlbjQ+SVneVEYuoixjctzdTCwzgz+avM68q7BNNn9Qsj5rMoPDJw?=
 =?us-ascii?Q?piPlLSl3uMtSV+Jt/TWcKQH93y+JyP4wk48BKt4MqE/YIYRVtXjYHeXKzi3F?=
 =?us-ascii?Q?bSxec5WoNUKtKYUh5Gs+Ued2JMrQoJlgNT3p1BzpjqXN2zzbUD/34bOoGYaM?=
 =?us-ascii?Q?26d9whIe4+piuvUYnEolDD0omU3K8Q7+I/bhEXGNJhLNRcjt+i4I3U7pJ9p5?=
 =?us-ascii?Q?URWYTuffWVFAJ97yt+LkD0LhUcbkp+yOwc8RRqAX98u6gcfRM22HcePgldBy?=
 =?us-ascii?Q?V0wxIorc6oAmUUwAzvhI6G6r+7UdSnykXoULlX111+Kd2xQm8g7nfY+SH/Uh?=
 =?us-ascii?Q?kvsIFgBxRFlNZFrLai2QSt6iqnv3MjErOwsD6e4W3R6OkZSDoopQQ1hvyIaE?=
 =?us-ascii?Q?hBsVNCLpIeTdlssny+Y4aZLqGAh+qCtlWM3yh0806ICyMlIZUB0WueK+NPVb?=
 =?us-ascii?Q?gjgCoI6WohOZY4v5B3XaHDSNAlQE1vo0E+2/9bO2RFojZ7frh+xI2zlK3Rqt?=
 =?us-ascii?Q?FqJCMg/j7NbtBYTuB/10I5yoye9Y5OEjqfW9ImBfmVL8bYPkU4Ogp2/FyoN3?=
 =?us-ascii?Q?MbNB6Zufdh5Fv0j4CBWjTPllvKbknukMzFaP1Vp4ISBMn7gj7gUxto+PCxJg?=
 =?us-ascii?Q?dI4h9rECKlWkAs7VnuGCt43JcJPMCjerr3BP3k9ax4HyRvt31aboek//xew7?=
 =?us-ascii?Q?CNwGvgrayWYB3pfCmNM7TfZxO69WJrUMEsgi8SP0q4m7h99zFMNFz/6vv0nr?=
 =?us-ascii?Q?U+57JeJiU1JNxrXiKH3yLFYHuk+8eSkBt6t6cw71eJV3BJhqUMMvRuFOZOl2?=
 =?us-ascii?Q?KXckHxvB4gJYM85FicaEUI8s1OWdDH4Hd28i5Hnt1gU5UdUHTgCf+q9R60fF?=
 =?us-ascii?Q?zPzMPqwad7/gHV2cSNp/CZy72yOoQf0vhG1ftNxpyBaru9bbKIbgMQMj3ewt?=
 =?us-ascii?Q?G/9UunduKcAKmOuZdnUw/6fKu20EPm8i4FRS3NjSKlewdMDgf2B9VwLeWxDs?=
 =?us-ascii?Q?nX3bId8ymmfcLd9+nZj50qHBcHjDh9hEYSfcwhODiKID997IWqsIc32x1kQm?=
 =?us-ascii?Q?lnToM6KWmhpazlvH/n1P4ZMsTovbHg8zw5HDW36nuZiEYTzwGBoENmIYUAFp?=
 =?us-ascii?Q?xzdvjyxgJWMSYXbE+JiMWtZIHS4l5J0h1isXLTLt1ObJo6bQmFI3ZgQfoQmH?=
 =?us-ascii?Q?prpBNMNbnBjZhvAnEte+YbJnjMADpRU24kg3SbNvGcWk6xUydgSvg1KAeELL?=
 =?us-ascii?Q?wCjGKXfgvvgOxGbXV3Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ia16MaMoeLXmBxpEL+NaPj4qYauC/oD5V0oVIrsq4rvgcMxr+ONiUpJqRz/3?=
 =?us-ascii?Q?hwxkR+kQMg1wSbh8le378fAL6R4Yu4itV6viijE83xMslMJ7F47dJaDV2oJl?=
 =?us-ascii?Q?Y+nCHIo7ifnQ5jbvwQpuL/CvWTr7M0Fht/mncOmHgpgrOivtEUxxL350ceaw?=
 =?us-ascii?Q?XMSBJgSp3lDEZmfqBh1SogAsgb97q0ZZ0ylVLbA8J/OJ2PH6YtphEcTlm2yk?=
 =?us-ascii?Q?cHHerCj9p8K9+4N0XOxxgrJQbRtKsgBmvOiJiZcDQOc3vsAPlRFjcA0Z1cUu?=
 =?us-ascii?Q?q5eE1viTch/KIlyFDv0UcFKkRdLD10UqrpKSPUzqqtdL409xO6gjweNohvoE?=
 =?us-ascii?Q?vmnxfrMISvEY5qQ5WfrIBdZuteu9qlFknPc5ZYIQw/FC9kSHP1NcFRbBr7dR?=
 =?us-ascii?Q?x7d3YFzvrCWZKXWT2kkP+4GIty3McJxjY0oBPMJAraLv8nhprdZVIL9ILbZG?=
 =?us-ascii?Q?VlkOwj+izQfO0y84c7DUXyGdk1A3Oa3uYmFbvkhr0xcAe//nnGHMRbnGma1f?=
 =?us-ascii?Q?cB2EndgLNKXpKLXJ8necXBQ6ZOWTkYDzsXzWrwcKvyVCsY1gj1VKOPaNDEH1?=
 =?us-ascii?Q?OP1q1RsN5Pnar/Hn7v2pOs1nEpXLwrfqr1gZ1CIHpO5iwIlZLpYmu+fvA4Pi?=
 =?us-ascii?Q?7p1hsMGFzXzpXpzkH4KmjI5faWfQlwjKFWDi4uLWmM4uqW9uiabycFJ8Tn0t?=
 =?us-ascii?Q?qsMOjEMK/EplLEHoLACY2aeNRTOusDdjxVLD1jnlFW9GPXxuCFzd5CnV6WYA?=
 =?us-ascii?Q?GBu2RZ0SOgQ43j1XH6O4Fp/Mm6quBIgvg+4cGbnKumcwQhL2hfS9tJpdYoUl?=
 =?us-ascii?Q?LBsRNPU6dR+s+8n0zqXywcoocUN4eI83P/CmtMrfgaFvmUMI6i839JFNQRxM?=
 =?us-ascii?Q?2afanc6jk7t5cyK1i/fxnjCU/Azy/rCkvmK2V3Up8GbH8CIe4pX63jHrxM2v?=
 =?us-ascii?Q?BKHVk1za6KBYJskZGBTX+gtiA0BufdbHIBQSbEh9iMjquTTTFSfjdhjrAQQN?=
 =?us-ascii?Q?U+pGv+f9zgPY6wcK5wb43BlRnNRq3C5j81eh7/ZzWmGjW895zMM6rpjpnVMi?=
 =?us-ascii?Q?Fximkno8PTy9x7RDwzkkdGPmXSrQhooa4nlpxXfoPUvLENGpIALcV3zBRAoL?=
 =?us-ascii?Q?YP/0TgJIYEt2z666YmBYUTbJL4RIDbOHSWwvRJkTQ+MQIOXpa1xUrre/AUnn?=
 =?us-ascii?Q?KeiatRhXyx+n8XbFIiUSr3VoY39DD0Jg64vyO82uO9jgbHV1xDRifU1a8OxX?=
 =?us-ascii?Q?7mftoy3bAj8JTkm3E9YEJTtZkD4GWeURz4JMtnZFIGQztln9UGDCgM5S+Tv3?=
 =?us-ascii?Q?dJYvw+BWAz5uHECNohxkJnjJgEUIH+ZSL96yPsII9ljtSI4eiyjLgWGVWbKb?=
 =?us-ascii?Q?osPV0UoPlI++/FvJt6XOrvvf/+HtGw9SC9/P2EFO2/Bwlg9oW6u14pp0fV9J?=
 =?us-ascii?Q?OfEYns6rTP2AkvBXiPvHCc8Bn9BTLYGEM2flEC3UGiy2GLL9L9ErEqVJHxKw?=
 =?us-ascii?Q?jwOcnFUDqoP72uPRYm/DZxGEf+U7zQ2TZrXMKz3B05vq90JSshjaRGfjCuq4?=
 =?us-ascii?Q?WpHPogUipyRbgUHYwarfjDJLziQAJhBwGgkvx+dXhvMTquR/+BqTauooiXiK?=
 =?us-ascii?Q?dJGrqAloEUofu5TY3S5HB9+r57ZSX4qOymDj9+HQfh+GIhbBx2W4doC56PIm?=
 =?us-ascii?Q?3MN16lpGJlV0x53jni8fc4MhgUiiXMMa1N+fXT6BoYVxohg0bfdU6/gBdRvT?=
 =?us-ascii?Q?z6PJyGl5mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nbixrUm5gjYYp2YSEF7LfuYMUrLj2SUQSpehMKSvlvzhz4ZShu/ro/qPy43FTJuAgIaiCjYu2+GQ0+NGIpbcja2L8PtxAC8ll0rQaa46C/2H70164sgEUvmGNofWTUrlFGRkU3V5zndwxg6D6+7NMkMVPysLSbB/+cFOwS9hYRqLsO2mRUXOZk02fGVWy9N851ok63WsfXCCiqmEBGOJxwhseCuXYQbzD9c2UphH3GEyPprRK3JdcYM5AlWNjVFjRJIdjIdEryR2qxSFsW/x2W4tfWUHQGbpGzAKQaw8xEjQNQA1/dJty+RmSNRbh66gyUQUOdcVm3dpE5R1axfApGa5xj2FLs9Na4kKSMWBIhpwAwLil6yZLcJbcp2+WXSxFRcI23DPBsGFGdV8FF5tL7SCP0yKadS9RAsNxxP8ahGJksO3tfgAVc/hMi5UtjU7ivlOwvtbZWgkPt/RG+WGwJpzsZzOnctef2QN3IVJAjs8rL3jFtD3/oKh14Kv5xfJnGFJqm13bzdl4qnZUbYvMBEmhcfkZNvRyVKVW2XF6NY81nhFCQCiqC4bjxjq3W01YpYTHxcbt6xSMTk9KvSCTVZmtK94jkXAe+fR32TxLSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7720962-5786-48ae-6d47-08de546d79bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:10.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpvUEtXpkHPukpVLW37NvWKpV01lEvHH106dJN75Lo8ocmwFddteidRcFcCk90GoKoWtz1HbBtdLKsgzYIsbng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696941eb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=3hMZsP_xGy9I1FFZ5EkA:9
X-Proofpoint-GUID: s2oF8_NWYQJcyykYZ6WguruXDlZwSMhA
X-Proofpoint-ORIG-GUID: s2oF8_NWYQJcyykYZ6WguruXDlZwSMhA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX3ZhxwTlM0kfo
 1F48neZcZn+pXmM4I4O2CQmP5SBJ+NEib/weBwPwmaoD4C49jfm/z+LUU6OpyVJcpWkN9Ss9uKI
 BCMAjGnizmvryfvACwOCs3vyoyX8xwF4zuEywBqEYBN7NZujFQKYF71GzvZfnliIY97AtQi5nX+
 eNNUiShgDbDYe8Lpxk0VWEKuNaMflUGhkJ9/OkTN3GH8SMItTRL0zzRVyJgxQufhD2mTV6YOPbd
 LHrWYaWnTw/OvLdDsNpNjrjkrI5uKz4haxEokNq0CjhhgqoE1kMVNllLtXmrhpbyclw84Q1LRsB
 kssudXn4k8NUFv5UzOy322J4cP87XX23/z90PAWhr9k5padq/be0k1nIAFGhiRH4c+bX8QjavcX
 qTeuB/O2kLmIyxMF7wd2VPshqbMobmJRFNy6GCiYQx7Xqc+i1I4Mq8VskFw8d1o+bth2ts6Hr3z
 8BmaEmORGHKkmzyAZEg==
X-Stat-Signature: rad17ne7owffezfngfqa9abucdu6r87h
X-Rspam-User: 
X-Rspamd-Queue-Id: CC567C000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1768505846-303171
X-HE-Meta: U2FsdGVkX19PPFMmJ8zt1i9wJldtwYI0itejssq2NUHeFlOCiagxxHDUhOyxLMEkuxGSjucwERDNnrNETN3XLmfAd7k+q11sPCRB4ltddnTGYMvs0tstGF23tkBXffkGsAev4SX8MNDNkE4Y6V8qJzCxJKU2kFsvqMimxLDZrVSdb0MhT0PbYNEY64/JVAuXR3mSsAFwKBffA2Hb7hI7i6P8kHUTA+eeXv0EvN0YDmq7RHwqGzQWadHTkKGmaTpgO81xLuH/E0UIU9qc3r4+O1YNdGIASUJf+O/Q1Dg7ICei/3XcU9CuyvS4HNSFjyzUO7wc8r4iOszwEU51cAGjQoWlCbZXjbngd9R6gsUjcbW2DGflYBNs6k9GX8sGCrLcZyPAIh7l/ZOXwZ7SRswZ0e4QFMlGNwHFJ2wzMwtiShmbuknBf9whPkdAcXeksXKEO3YxTm/j4mo31rrt0rb3ihHdiqptbsTroBPTxQ6/5d/KU9V9zIRad3oapOhrbXgQ6tFO4SQaw0dwSWQofBpsEHnM/stRDcoS2e0QAy456bMmp5UQD+fH/giDF4P4snT1G2xf2xrjcrgnG0wSQNv8iTT5UeqzXccQLiDM2jCsfNQafBCaoHu0vCaRTgVcAmYhTv3yHnEephZ3BdvoIky+x74DKWXdk/XE/0sL0Yo8YWZ1z1ZoaaIjqKUc/hHu+lbYIS22DCdoSuQJQaWhxJ7Ming/mvuItzjCE9XH17lgDBJh6NbbvN7HBb1fWDn/KKuWccI4Lu3vGH4J1MQgXd5Yju/Wmki3ivObEt6CFU7yr2pfLpwHueMT5ZqvPCtECv3gk216XQSrku3Ksp2YsU42WFo22RW8/iQJnGnId2QmlHyOfRSors8i9WBg572/7wz0xLAObUE9ZHCuX4zoGe/kF5zjzy6IwChX/oxoAIYoHdEBueTSHaDyfTE0cmHZKqn0vvZRxSH+UUdHefc6wf/
 MFiXTSA3
 FemSr1k92owftsvOssgpaMXcsZvz/XY5YcB82n/OEicKuGAfOx68nsGvQ1JS86hoCzMTNbYLDS/HK1g5IBNWh40gAUxyRelnQ2kHkzpWFPo+xUH6oaotqPo2sAJK7Gyq5hO6UQJk56AnFaXFjMIqnea8SxoCrDP6frydBWzmkgkXGmTl1uIqEKSD1oUm5yZP9L959SY/3+0I3Zbn4Dlrn/lV83U7D1dSg6vnA5y6aXQD+UCL9iSpjPHKhTB+47FkC9DQf1nHxOiwL3Jw7RiMeST3BkMgGItwmNv3yhaCcAA9X6VruXqDC0vNW5McSbnRM8DS7R1uukv470FJEQNlFZLOA+SVMGiKBmcgV1BdyFTG7HQeveg/HjhYuEwwraotz3NnqmdZw/S6RrIYSLN/YI03HUuzY9nGZSvltBJNHtzIEQxrm42XWIUe9SwAFvdrx0hL36WLj/10Cj3W0x771rQ2wEuklu4jLlQTbOM/882h7eD19+7w3ulera5014Io5YLtwvaV9tDoIC0TkuB1Hv4l9YpntDIvtnegstp1l9kfqe4QAIHA9edqLubKnR5PasjpJMlW7nhhV5qT917rf8BMRWLhejXvIj+ziuy0Z76c0yxDp9y20ltZMaC3pEO7sAPz5KeAuToRt9fjut4K5f85SOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the wr_mas instead of creating another variable on the stack.  Take
the opportunity to remove l_mas from being used anywhere but in the
maple_subtree_state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index be855f204bcf7..e17f0b6723a85 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2751,7 +2751,7 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *l_wr_mas)
+		struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
@@ -2760,7 +2760,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
 	if (mast->orig_r->max > mast->orig_r->last)
 		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
@@ -3454,7 +3454,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
-	MA_WR_STATE(l_wr_mas, &l_mas, wr_mas->entry);
 
 	/*
 	 * A store operation that spans multiple nodes is called a spanning
@@ -3494,25 +3493,23 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.last = r_mas.index = mas->last;
 
 	/* Set up left side. */
-	l_mas = *mas;
-	mas_wr_walk_index(&l_wr_mas);
+	mas_wr_walk_index(wr_mas);
 
 	if (!wr_mas->entry) {
-		mas_extend_spanning_null(&l_wr_mas, &r_wr_mas);
-		mas->offset = l_mas.offset;
-		mas->index = l_mas.index;
-		mas->last = l_mas.last = r_mas.last;
+		mas_extend_spanning_null(wr_mas, &r_wr_mas);
+		mas->last = r_mas.last;
 	}
 
 	/* expanding NULLs may make this cover the entire range */
-	if (!l_mas.index && r_mas.last == ULONG_MAX) {
+	if (!mas->index && r_mas.last == ULONG_MAX) {
 		mas_set_range(mas, 0, ULONG_MAX);
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
+	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
 }
 
 /*
-- 
2.47.3


