Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA547D4661D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB23D6B00DB; Thu, 15 Jan 2026 14:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54276B00DD; Thu, 15 Jan 2026 14:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAEB46B00DE; Thu, 15 Jan 2026 14:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93FBB6B00DB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6674313B00E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:47 +0000 (UTC)
X-FDA: 84335208174.06.0CBDBC5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D88E0140007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="K/UDY1S+";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="U/Ogvh31";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505864; a=rsa-sha256;
	cv=pass;
	b=uQYZgRfgq0PpfbCacUEaKV1fvrKTBZVJQMw4P4g+OtpBEiq4kCgagyQnm0zh+xburDTbIZ
	iP6CiOVJm7+tVz8rZT/J+PcYJgcC9eWNcS+pK0+ICTqSw3E35kFrp6CvyFsOeADK2UoEQ9
	8qfOwJ3rj8aXDRq1hauNGtlvVQVg0W8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="K/UDY1S+";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="U/Ogvh31";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqrzJO1V8LqFDJIP6UrYCZfgqmwYLROgIq4mr6GOn7k=;
	b=NHJqX8cwdgTzoME7rIBCedIegivt/diNi0Szw3eTy8LTw0h77Fs9BH/3JAmjf17IlTWqW8
	ARUsdWczOR+t+7PQX318xepkapT1+7+JNwYoswltKi2VexoYhUFGk9sdPdhsmls9heUjac
	Zr2wQMy3eaxJaiVxfO8E3ucz3bJ8PmM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFgMeB2419471;
	Thu, 15 Jan 2026 19:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NqrzJO1V8LqFDJIP6UrYCZfgqmwYLROgIq4mr6GOn7k=; b=
	K/UDY1S+BzrkmUy4krlQovk68CB0qqDaD7Lr05xFj/me0MntOFaC59ZEvTRS7TM5
	Tr5CvtFGebd2Jq0CTUKO/SIPjW78yaOL1YapwS2lIsKPvFZSWmo4RmQ+Egke2c22
	VOcYwvIwC59tKGCN1KhsK3IDmjLNlnbTVXQoq5OXDunZATzA9438o6pHlDwyB0Ea
	+v45OdyEFhrztkV8xnTdulIk9RnE7bKmYxLYhRTLa1XdUrf2ImxDeIH0jhhxDcr5
	XZFtSGAl53mzC6UEgzrRr1CIp8xgVh49K1XGGF7gfDz8AepFTupy9ACn8cj7bxgp
	2aeNrX0MycwtIv0V9ux5Ug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre40j1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIbfU6000463;
	Thu, 15 Jan 2026 19:37:32 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgkrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHd75wh66IImYEdY7PSFEcczf10jOa8OqcwNswFys4bhzIt0gDeD06QNEnI6fzIldSX+aSApFJUz0+n5TSaf2QLi7crlukDsJ+0lbF79PtCQ+iLrkAkXbRBycxA2Plsyh5cR7zlwEm7rgzux3rjbJtU5JsMBKn1aa2CYi1+9WtIO+dlT9VeoeZek9zlF+pW4qb/PmU36LDYr606wANHMY/PAZBWehXEjU8339yMLuodAI2YkVqvTOu1TbTEzkzsaC9q+v7w7d7Gr7LgBFrn5TiE5fpO6GCHbt6VIkcc8CJSOQToK2/FTtNrd0f4nfjGepFgcT4JN69GMLz634Y9/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqrzJO1V8LqFDJIP6UrYCZfgqmwYLROgIq4mr6GOn7k=;
 b=aE1h73HCq8MkKe5GBHPyWhmzp9Cdt+e/sh4fsHwZjxZj+Ccx88+bw74cr7T23foFwZ1+W5g4stUvh+4ZMJJY/TjWPrbOw1M/ikWXP713FDSflj+p1nZaI6BGiU28U0FjdSkwI1itW0dillJG/kD6LSvc5eDn+yqAui18udQbsMruNGHHS7Mj88IWWqPkIJrKqsG1agMN6vxJasq9rh87l5NJBY+36WrpJoCsCdgADUpzDAaNB1MOJiK7nZHrDGOeT7fTqhWHCzfOeZd5anw68gRtPUeygzqYvq9MOXBHCOO13iKQD5C6bQKwIOFyk1CRHYpufq/+TcRsgyy5Fl/arQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqrzJO1V8LqFDJIP6UrYCZfgqmwYLROgIq4mr6GOn7k=;
 b=U/Ogvh31Ah+TTBGj+BCtMjfOUiQcu6E25JFQoRHt2LIEiDzNvuLTcUwit694Ma9F4gEIPCcDWmAwBFLb4cNkvmXuCY8oVsPnkh3YS0uV7AaWOmRNMSwE79OiyQiRicfb2TfzzBLEHV/jheFhV/8scRblmjDvp1x70Tk5mRPnKHg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:29 +0000
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
Subject: [PATCH 14/28] maple_tree: Introduce ma_leaf_max_gap()
Date: Thu, 15 Jan 2026 14:36:33 -0500
Message-ID: <20260115193647.1695937-15-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0347.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3d62b9-f7dc-49d7-fc20-08de546d84bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FS+CQOAKe7USjb4aVnJunYyd8YjNLQq691AsrucEUakI4aFDenb2OWi51lrg?=
 =?us-ascii?Q?en2iQiKjx2wPwyE3fhlOsosYcdvRoDphncKQNDUBLNO177/AMxhCvozxC5h8?=
 =?us-ascii?Q?WlPFzr0lrpXcJdyHtdszKCWAmfGab94zpQ09DqIEEAq4X3i/DQYfjkLY/YkZ?=
 =?us-ascii?Q?oiF89Kqu8WQy6p/2GRgF8FXeM/iBAvWzTPj8ohp3bklFYm1YY82Uo828+M4h?=
 =?us-ascii?Q?OqM1alBmbpszgqRQPcaPIpq6RUIVV4F7Sl3/PEYzcRerz/B1Zo4FgYhOt3Z1?=
 =?us-ascii?Q?NKzr0aigAPa4Wfw6zEgt7LTfPKrTmCloo+p1oCIdFsja3HwVclNWomPBsFjr?=
 =?us-ascii?Q?t1eT1whtCcxRqvIkZc7ATosnDK0ooXWHQ+hCxhdxFzbNeYNpl0em1dAy30n2?=
 =?us-ascii?Q?zJj7bhwimiDbfRDqzQBUb0nY/q/SKwJzZg8sV4G0lS/3GUafhl0TAkotiLiU?=
 =?us-ascii?Q?GCtjEnO02RGE5ECQul3CUiShWL0lv3HkWcj6qcRtjsMMFxVUhNmxVE7VxvPs?=
 =?us-ascii?Q?0Y6XjSPV69UXU3mn5t5SRo2W8H6obbfCt+RWnembhvr2hTPYSzR2W9H75ONL?=
 =?us-ascii?Q?CX7ByBZYWNXrTvMLr4msJyUUAkMMemFyNdt63kEcn9LRPt8wrSlQpjM95jxt?=
 =?us-ascii?Q?D7jwbmVywNr7ZS4rIrHDLz3jtDtswKdHa5FeAVcoA4NPB/MHQ7Nd6cIGNAW8?=
 =?us-ascii?Q?cby6DBWiCC4L+3SbrdKxnFf9C5yh4LJTE4XC7AgtXJzMTKgJ/azOGmOWm94c?=
 =?us-ascii?Q?N6Sf19TjGWSu8RKOTFyUO0hztLfYLfihUfQX0xKNUtu8ceXrdY/5SCs15GSw?=
 =?us-ascii?Q?JLRnuCC5i/Y84nNMdbQcoBQHbalnB4a9nXphbiK9LxhK61JKfdpqrxvmAUOg?=
 =?us-ascii?Q?zlMdyKOB3R/O4/vZa11mak3aLg9sZEkyyB2zTSTsrjNFO9kUYe3AgG1PG1//?=
 =?us-ascii?Q?0T3XbTdSTJN18hzogu94jo435t0O7JDkEb7nByQ8rNipHKgn3g5nmrwTlgu6?=
 =?us-ascii?Q?S5IPpXtHUR1MNIhQqigOaRHbzPNX4tj3nN9VdLUM+tWMG72Dij6xD90MVUQb?=
 =?us-ascii?Q?j0r8O+JCgoiXZbauGn1Yj1CxLjvDKN/jMq+JObFqDlA1exAXIHdiHUgy2PaX?=
 =?us-ascii?Q?U8GdQvBMupCIW4Ab3LhWQ03iC6OKFH6Tlq03OCkBwujXTPeEQR6DwgrIUP9T?=
 =?us-ascii?Q?4R+s3XBJ9/JNbEQ+gJqVcjQL8KPbCci+sF4TNbhdAAhNzx12N6j+jj3Va0+9?=
 =?us-ascii?Q?UtPF99x03MbFSTQ4QNGt6XnLjzFhLTTrKmRvyyWbrN11wlo7Kkqprk94vbA6?=
 =?us-ascii?Q?JIQBUEXujFb7TAj3GLRwbzhB33pRgFcYekKDfLdJr84aLTCcC1A8oFdIVEyU?=
 =?us-ascii?Q?IcgZA8s1P5cBTfp6/Rh5wwYOsF6MZcK8iTsRxq/o17YaC3oBpVCWmqAUDh/4?=
 =?us-ascii?Q?/QvlIPBJ8Ej4/2x9h5i9dwJD+rROkMKhkPVDEyGcZecRKxQO+HFZM7ikvnJb?=
 =?us-ascii?Q?9a77lhSZ6ssGPauQxexnvG1c+ReCfet/uqZWscq02VSVMrjbx2Y/w/lRWngO?=
 =?us-ascii?Q?lJdFFyZiqoCezS0BYg4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z1MSv8Ze4WL1tTfJv5kVssXaRr3wu+ToSfn62qLQLgSKMql8JODlWSOa3Ssq?=
 =?us-ascii?Q?L71UYYioWPQ4/EhooG9eJ4n0IIZiCbWRo8eJd3WY/zRSgC4C3YjbQlzjS2Y/?=
 =?us-ascii?Q?KpFuBdqOoFZanbITaPVXi4MHeoNG13O/UJ1oJ1h/TNhDwkUENx0EokJbCV88?=
 =?us-ascii?Q?umUTfnW8YItj9Jgs/TopA26fU32XK4DDZY6w+0rsUJt3odqS3lfiwYEIcNIj?=
 =?us-ascii?Q?wnQFMdGxP8PGfPugZQmDaaNmAASY9DkPKFDYuqlJMXgGSBv0SZxiRUe3s5MB?=
 =?us-ascii?Q?ulNZs27XSD6YdR3pm6EXXqs22dcp5+Tx3IDgB4xkLeZb9GYOO2Yr/iBdnLOX?=
 =?us-ascii?Q?JpW5+q7KtmagXYgBVTKheUMSBPAZqkpaMsQnRh9T8H4AWC0RUtJ6VRUmKn31?=
 =?us-ascii?Q?3XYHFmmVTyFefdzqM4gcLPPGlFa+6XUiequDCdemLtwD/CZngtoArZM9Rw3v?=
 =?us-ascii?Q?zJUYL5C6A8pSsvgkEmyBEQzXhov5RY2YePAHUZ2+MggBzLc30S3tZZZgWObZ?=
 =?us-ascii?Q?ZlMQ770WPh7NtPL1E3I06aSLKYOOYjhHTxV+jhmym7UOKp3O//PQWmDIGM/l?=
 =?us-ascii?Q?okfAd5i/nGQfDTE1PnV3O5TdC3NhVzebMn4CQnWfwjcePBHC97+KA/+duCyQ?=
 =?us-ascii?Q?oKQeyINgQJxqHED0jkgdxyVeUr1Y/fGlGwc7rrswu8dkEEL0lQ6Ge/q4Hplt?=
 =?us-ascii?Q?sDMFeXS/aNZBS33lXHn3Ufo+3FL03Bxn/jmuIErHAdB/mqvq9UXRbnJbq8jL?=
 =?us-ascii?Q?LLhpYCMG+h5Xd9Dne1Y7iKkxFaP+uNDqc9zDWzZ81zHCCJymYwpG4s/fO/x0?=
 =?us-ascii?Q?FM11DZiUVHuFbnyQWqesxhI5JkD+BNOL54Y2U8zQ5xbza4PO3IBksKUzO74p?=
 =?us-ascii?Q?n28pGWjYS21GgjtyxbSFfEQUg6O7yWav+bztXASm3blIuN66X2tTcl0XaLtN?=
 =?us-ascii?Q?ulzogWftWBBypGv5bbiyESMOHi7wATuGoDRMLG9hdiqfeNu/mjYyW7eUylhm?=
 =?us-ascii?Q?ZO2g4KzAi2WRZBtBMQFRECeI4vwH7wsqWjHUaQ1VABHs86NzMteO4UaB5xRB?=
 =?us-ascii?Q?EodapRLRKq9Cf1CRNHPftIoopAhHqwarXKp2pUR3ukNjaajmUs/kRu6CG1fl?=
 =?us-ascii?Q?Pv4/AyICpCliXd7RNVRE4vguqtjMYZOFJKWlKdPxhox0HMmz1RVdIJaZ1Iyx?=
 =?us-ascii?Q?FamKKr2zEtdwcaXyFgwuetkflgQnIFtZW2wM7f7fQJGObpRywt5RofpiqKM6?=
 =?us-ascii?Q?HaGj/19kE8K2iAk8OdH6wVCigVIdRqCbZ/plU5in3E8bMXxElBuMRO0vEEJI?=
 =?us-ascii?Q?Hv90WSLGvy9uepLzooMkw6kUtQrAvhllGD7shjH2aRLutWME4D67CKeti8BP?=
 =?us-ascii?Q?2KKWcGdTE47dHH8PHXWT8VQneogf6NHn+SyI7VajU8NtyzD/SIcLSHYcqKXN?=
 =?us-ascii?Q?CK3nGO/4VPPhCaPfXnT2Sbaed7/oCIYCH4cMnjWOrGsHcLM5CPGCHcdoAXex?=
 =?us-ascii?Q?gGUUPhddZvkrA7wrNFq7qPnsXyrvH3ghnNbHm511E4jcXUabmzcsKNGNj9iz?=
 =?us-ascii?Q?Gar2oNSN9tDnpYq9BU+NALaxrzAWF8xnTs4qi3uMym/rwydqphHiDDZOhTPM?=
 =?us-ascii?Q?mp1kCZNQJb3ZusWJ933I/wqOPD0ScRQt0HEt3gJt+vYmTsG1A1Bp5J7QC7NQ?=
 =?us-ascii?Q?/olpTXslPKY5lf1Wcs42yccGOy659ff9eo0JVCUmrGze1bXBa///ZxxdLHpa?=
 =?us-ascii?Q?uSK54H2qSg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3WiGOkCUv3TK1ANgRTsEUN5hUuGxy2hYyPEVq51BjDsBX4a1kGt8wVks3ttcqjsxs4xOi9aIHuvsn6IIdHs+lVVAE2DNcPwg1N7R21c5KF9iXLc/E+xrfy6z4FA8tMXO5AeGi+Jwc5hSEhrIaRpVCGwpUT6CsH7zjNFZORWlcC5I1ZR5W79qUu1QhmeMpvK9KmaF6mm4+i3wz0Z3FapD2ytFEqjqeqP55Yj3nYk5HMkdwtON+obs/6bHw5LXozak9GJXP9h1suq+RyjvOT8FEFds9OCA1Rl6ZJSIKLrOMf1xaV7TYlLZL5qMWmp4GaGY/ohGAwJRgtRtmq9pDV2CXB4wxTzil6zWQ/Yh7neZT3nehDRzMJLkqABkdWid7uUAM7l9VxpaK6YFDuURX69znDEDRomrmzKez0IvdsxZZFa1j1hGszkZPkLekzBwZs+tuPXu9C84Tf1rG62joPorci/zecz4m9NLAe46s9sWAV9RT/VDSZybhsYgahfHzeU03c71QA9FmB5wUboKQDiXDXTGCxVT20YITFuqCl9BjWsvL5xElk077SGKFEiFBWnaezNiGfCNt+LGum3uVVP2Q4YuMeRc9t755e+qJoD5hSE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3d62b9-f7dc-49d7-fc20-08de546d84bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:28.9217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ItZbDxtQm9EOCsefKBMEef6enO/ZfACc54WR06ruX3UnU5tzd6jafgBmqRxWzjEyuKldHxCMlRj8DUHZhCarQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-ORIG-GUID: Hn3L7TFFDqBgyXU635Q92PAwfbyQ9rMI
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696941fd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-3J-9aNdBi9tGdEVLXQA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX4XFHH3JVYY5n
 2zxowJoBkWQg1GKuBdAXUqCpgkbVvdrZdVYVlrcP5uQvYwMMeS1Zt2xkyOROI/dzM+6mLa90WHh
 tvEMzjJ7O7lORSaKbIm+nL3kCayW7ruvkhdmUxUZ538C/Gzg9e6kkNna0Wg8RKT1v7Bq3NFy4ml
 9+ksEfzAswmOouAFockwivpSpS9IBswet9eHGb/SoW1LpSnnWoP3lOGXQnscqbfL/RV9tpenBnq
 9EBQt82OVn1S+4nSg2NaQBSiPh7fLjsZSh4zL0eyMrhKrfhgp9n8632LcpTyb0lzNvB7aUvQ5uC
 frG20BB07OJ24Jucy7s/kPrqdApAVFFSqid0ZuqmPV5ZFDboMfaGSJrxMBC/Jv0/6jSFpSLjfwy
 LjCmclxGJeXwD5fCAsYOF10LvYpjonAmF5slBtCDAKZpCpZCHzh2aeW14zk77V78ISYLfPSj3pz
 iomJP63aS0PIiCiz7/ZX/7ZptVlNdrJ/QsHG2xsw=
X-Proofpoint-GUID: Hn3L7TFFDqBgyXU635Q92PAwfbyQ9rMI
X-Stat-Signature: h8qpbb1yutggphee37t17nc3pejukby8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D88E0140007
X-Rspam-User: 
X-HE-Tag: 1768505863-309251
X-HE-Meta: U2FsdGVkX18Peg8RWfxokoKq90gbhMXqnaJmZvLXsP+k3O31yXpywhVffzA8LSbsGQ+r0arxoiP5K4xa6wXBmcph8qIp9nRv8zwiLZKQ7+9QJ5eousEM2AFkdGENQGGw2pnoGCIZF/0SFiP2e9jXocIQrJ83LvEbF+3N9da2kDnH1UlKq5+n7/hL35ChNtwTNNK8dMCjeAfs4aHL3vpXLg5Zr/nuWIeinAq9UkrJhAc7rMmT6nRoSgHr9yPhDHaSoyF0j6mQMStDGVmMZPAG3uoggQWScvfVEU2pMoVVdoNzd8hH9F0mfNQNnCcepTU2Juofl3NiyqoFSt3XBeN6xqToYG10P1fFa2vacgRIXw3oExMO9sx/OM+YSSScrfJTBKD1GmcpjA2bKpZKNSudgOSlJYUWywg7VP8ZO04WGFXVLeEsfu4T8agwU0aSL/nbHZX447BF2yxPxseWEKW3MeERbwhjvAwe5bx3vKELozDuepMEc9L6SCxOgmy+b2pqvSzkLVyKk992QXtMUxjPJXk1y/JPH0/5MZZow1WwQBKyCV6nJrkEltSQhpdXobndRDsP9lq27RPP0h30htcxcJ1OFxb7ru1dHnJLbQZZhkhTPVpVZSVQxDujLbk1X03qla/VJ1kYBwV2osEdveSP+bN8wpNHKLxODXPET4k92tRgrxSREkQ3KJkMfjLOAuUn5OwD8BzYhIDKbtFaBB9w3uHozpd6Iqy4LZY4y5EuSqn/ukhot8tzv6GrZoN2rx9G/ZC3M6xtu7pL7Yww2ThGTFWJL1V3uBCbEvPP5hyDp+mWRJvR1YVHObYyeCiY16x6KuBSj9VYqZwX11iwdclkx+aItbcne8x1LbcGKDuhcqGBA6udZoQ4Qr3s+elvjZIOcOjLNyTVLl5Mvg6UMQBL1ZfYAF4Xr9SRglBeqaGj8zy0JWhTRutlRKLoPfmns444bvcd3Oh6TQR/NkkCAet
 TMnLNjj8
 joX4WtYt363ASZ208TRhAqIB3q7hJt/muNhXIhEDpGoQ80DSak3TbBzyjhgxeC0+XU+daEqRVHFe99+XuVLQTcjTW4Pdc2X6yCi8A2BxnKk8yphUFhxO/ZrTOORqSNtvwqb901rgq5eiXZi6xmS853sUexWC6189IwtmiR+iwqgw4SXI93FZJ0l/5VaS1NJpqeKnRmuQL/PevGqxhF0WS8sF9+qyYjAZMZkrkA6cnct60HLEx57+C5MPhemT+wJYxRkc+IiXNcqMaCcKsn3jBwKuqOcE8MCVkrJUVqpU2Ni1JIdUdym68QUBqVziQsBKZa7A0PqMj3e50462ziuwioAGG0CSnqibrIM+ED6Wm6kr7wYeNhR+yzYj60nxbh6PyNIaGF/eW7sk0ufSI9dvn/WD92RoJBOH1Q7NnpFC90Pmszrw+S3UT2lpvqi1FoTbt23pwLdturoqmuWkyKMwJRnBDxQwil0BNxJw5gxNZ1x8yFF1pmAokjQ5pAqcg8CwrAXXmbMt6HVpbtf7reR9nd5PnSnYFU2RDFy0KYfRKc4dS98QHoAjA2FBZAELLcjQKSePosHm0Ag81yJYVpJkEAz4hNBxLM/eZrmcMPqiyIsMKu+fOHkthwn6+iSBreRFjYiSax2UFDj4VKcWXjD6t2elUalACwuqbFAxHLFlIVothBybb+2uvRiBIWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the same as mas_leaf_max_gap(), but the information necessary is
known without a maple state in future code.  Adding this function now
simplifies the review for a subsequent patch.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4dd1cc73cd27c..366202dc22343 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1315,26 +1315,14 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
-
-/*
- * mas_leaf_max_gap() - Returns the largest gap in a leaf node
- * @mas: the maple state
- *
- * Return: The maximum gap in the leaf.
- */
-static unsigned long mas_leaf_max_gap(struct ma_state *mas)
+static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
+		enum maple_type mt, unsigned long min, unsigned long max,
+		unsigned long *pivots, void __rcu **slots)
 {
-	enum maple_type mt;
 	unsigned long pstart, gap, max_gap;
-	struct maple_node *mn;
-	unsigned long *pivots;
-	void __rcu **slots;
 	unsigned char i;
 	unsigned char max_piv;
 
-	mt = mte_node_type(mas->node);
-	mn = mas_mn(mas);
-	slots = ma_slots(mn, mt);
 	max_gap = 0;
 	if (unlikely(ma_is_dense(mt))) {
 		gap = 0;
@@ -1356,26 +1344,25 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	 * Check the first implied pivot optimizes the loop below and slot 1 may
 	 * be skipped if there is a gap in slot 0.
 	 */
-	pivots = ma_pivots(mn, mt);
 	if (likely(!slots[0])) {
-		max_gap = pivots[0] - mas->min + 1;
+		max_gap = pivots[0] - min + 1;
 		i = 2;
 	} else {
 		i = 1;
 	}
 
 	/* reduce max_piv as the special case is checked before the loop */
-	max_piv = ma_data_end(mn, mt, pivots, mas->max) - 1;
+	max_piv = ma_data_end(mn, mt, pivots, max) - 1;
 	/*
 	 * Check end implied pivot which can only be a gap on the right most
 	 * node.
 	 */
-	if (unlikely(mas->max == ULONG_MAX) && !slots[max_piv + 1]) {
+	if (unlikely(max == ULONG_MAX) && !slots[max_piv + 1]) {
 		gap = ULONG_MAX - pivots[max_piv];
 		if (gap > max_gap)
 			max_gap = gap;
 
-		if (max_gap > pivots[max_piv] - mas->min)
+		if (max_gap > pivots[max_piv] - min)
 			return max_gap;
 	}
 
@@ -1395,6 +1382,27 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	return max_gap;
 }
 
+/*
+ * mas_leaf_max_gap() - Returns the largest gap in a leaf node
+ * @mas: the maple state
+ *
+ * Return: The maximum gap in the leaf.
+ */
+static inline unsigned long mas_leaf_max_gap(struct ma_state *mas)
+{
+	enum maple_type mt;
+	struct maple_node *mn;
+	unsigned long *pivots;
+	void __rcu **slots;
+
+	mn = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	slots = ma_slots(mn, mt);
+	pivots = ma_pivots(mn, mt);
+
+	return ma_leaf_max_gap(mn, mt, mas->min, mas->max, pivots, slots);
+}
+
 /*
  * ma_max_gap() - Get the maximum gap in a maple node (non-leaf)
  * @node: The maple node
-- 
2.47.3


