Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDABC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACBBB6B00EF; Wed, 21 Jan 2026 11:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F116B00F2; Wed, 21 Jan 2026 11:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826786B00EF; Wed, 21 Jan 2026 11:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0D56B00EF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:58:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C0588C661
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:05 +0000 (UTC)
X-FDA: 84356578530.28.0DF040F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA69620003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AwCN5Ee6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=thmU4hhZ;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMKFW8ALB0+EPw2Oj12MrfWXrqNQZgvwla5SbDkOP74=;
	b=XfI1txd653/TbADDhHaVJc6itSCPjZA3TyWx5LGUU04ZzQh4Tc/BDMFvnc1so8DU7oatkc
	rMHKz1pWbthTx3pciHZvSJkvXOJNaVJvPoIiCGBi3DgqITjhLJl81H7nb4bBitteFGgFJ/
	c9BmdVfmpP966gvxKg0rBSjTT52WqRg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AwCN5Ee6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=thmU4hhZ;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014681; a=rsa-sha256;
	cv=pass;
	b=lb70So3fdJKXhIb137cBdKAynXmLNhLRyul4/0arkRssfg/QCk2MbVemqT6Wjc9lChBntT
	Fn2dlx58dFU9MW+3YvWXsSHZBxmff0lg5g/rHm8uunvtAoVynncxkO75Y6j5C1iBNCB9nD
	NhAbw/+4F4yJ19Sole7LFLyVWxPrvDc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCiLR43523936;
	Wed, 21 Jan 2026 16:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nMKFW8ALB0+EPw2Oj12MrfWXrqNQZgvwla5SbDkOP74=; b=
	AwCN5Ee6qz+ae/FydfSc24AEBMQ51G4y8MUeVpSzeGyRscuW821vlj7zuKG0qg6l
	WWoe6zHLqL34zP7oW6FDxw0dTX+RTfSyvnpOpsWzuKWcYEsunHcCxTP7yCap5Sv/
	zL+ZRZsLLhAHbixZdigFs5e0MMoc6skdippJLU83rKLkweDcaP6pAUw7HCmAwbHM
	iiEzpoMgb8KytckGhe1kIefJ0Yyg3uBZp5Fq4pw7TQFSiaMn3fNWGofzr5Bv8foZ
	6Ksi4jSYH2pK95JUghpirZBF8dr0fNmhD54t9HWgsjgLcAwt9ahLxTvwoOuaAruk
	tym5UlnDsVTM/VoboGOFIQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qee7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFnKR8019040;
	Wed, 21 Jan 2026 16:57:53 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbwsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvPOHdhgjMO3/CTaMFhb9Y0raunPD37PhcFnqLk1KrAmol5jnB+yeqmCDti/uxl++xxNdO/b4I7gsrziLiOeO2zk/FI0ZMDsowHDKwH5oNOqqefN1rO2esNvR7t+y/FG7GHp0unWwatpFpPjqZiN2oHNfYFZRqDBJrGuu7KnICkjujpX9e0q7S68viDPT+UmDeJ74CjZvLQM4P90PLYTj8u6Ek9ewRI+Gu3Cf8rdsjHIRN86le/AXiyTamn28yOY7y3wnZFh0ao8daJiNuLSX//M3ksTehuM2zW3f2oJxhorK7oyrBZg7pmHKiDHJarJL83uFJIkR19gNs5yMAlLlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMKFW8ALB0+EPw2Oj12MrfWXrqNQZgvwla5SbDkOP74=;
 b=PnPCIHCXh9wYvDu/t68jlZ74Pndveokb/R7gO83gJ8Bj+PtyPia7mt72r+lkuU0CIcsovAika80VMSEO5eaGmmBraDk2C98yzebNAuJ5pipl89a4SMYhBPi/7Iz1cHOgjndoQnZ4+uEeVJo37ott79BAj/GxbNZDycR4CnG/uBRDe5bPF+EX2AQsF8/MR7pGWISKO/m/HVtKv/7vTacTEKcZC7fNA/fqlxa5C5gCiX0mOyJG452mgcrenaoRRvi6iCSLupUDQcW0K2ZZqUS7sLACP930UPnjPr77hB+r4VoseXsPXsSqPKVXCaUNO2ZNFBOR2mlQ4fE54ALHxpN+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMKFW8ALB0+EPw2Oj12MrfWXrqNQZgvwla5SbDkOP74=;
 b=thmU4hhZZQc2XH+IMQ4XW4u2u7AtlYpNK6llWkfDTIRTKHUCbPuXNBmvLBKbrzyq4jk5E3TE2FS9ruRCg0GIXsFDDRC7Q0oVLnl3i5McDv0BYKrd75t9gco688RgCJCwz4/6NXvDl0OcpL5fL7G6mkjJsZK4rQ5JGJg9aG0Qy8E=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:50 +0000
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
Subject: [PATCH v2 29/29] maple_tree: Clean up mas_wr_node_store()
Date: Wed, 21 Jan 2026 11:45:26 -0500
Message-ID: <20260121164526.2093265-30-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0013.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: e32b1695-824b-46fe-a959-08de590e35ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RSJ2gmbvtmfJn9wblSPBRXjKIGWUEuv2vmqdPu1N2if5NFb3Q9biiHt3MvMr?=
 =?us-ascii?Q?Wz+1QSMNHwvaGGahru0XAmnyeFKYs9pxkbUh0OfRY04QYFNKJ+vV23sOPKfu?=
 =?us-ascii?Q?KGxa/uz6mavLsOMJspamEKMY0LOn6NbQghoH7zSAGWic4omZM8X/QXYBD+0z?=
 =?us-ascii?Q?Sa/RBHCb0ACmPaiXc7imrRtumi32SBmwbGWEnC/RLPbxeKjJeySQHBxowNBp?=
 =?us-ascii?Q?ldW8J+dcMcvAu15K+dU1BM5xnDSCQH7baA3KKcHxNCjVqncpnslx/ot1KVfw?=
 =?us-ascii?Q?605WvQbwyoxnQtbyQcgO3R7Ojk5sPB1zVm8kOJB4nIcz9lEE1UcUtRXqpROM?=
 =?us-ascii?Q?clmUJFkUzccDrwfqJEHkfLvf/voBtCdDFeR4Uiu/C7oLz23hXuwrzOIq/htq?=
 =?us-ascii?Q?mfqycIPLvRAnDggH+DlzDcPwtNbpUZ9xPTmH0Y9A3LKU8sVkI33S+5V+Kf97?=
 =?us-ascii?Q?eXtrRlJOQDo2xal4urYnHZhxDG99Nx5gABF3wW+Bd0EMiYgPa8UQmSsq7pVX?=
 =?us-ascii?Q?IrcFk8VKTSf3wZEhD8m+dQwO8gfZ5o/XBeuADhmVJW/TuJkhmdpAz+MdLR/X?=
 =?us-ascii?Q?/Yp9Ofhbgev9ZPNnRCscp6b5aCb0zLK4e7Qe26hUtsL/okn3q5eG+fow2Ia3?=
 =?us-ascii?Q?rxz16B5dD7u/4Nrp9lXggYNQc7Hw4ZgzpyEhYkjEGAq/AAk/g0jmF9ND2TBG?=
 =?us-ascii?Q?to5BwKadzPqhyGfkYS7MC2DhDAZbx8clHxEksQhyH7ciOpeoLqPZCTQ+/9Pv?=
 =?us-ascii?Q?UwdtoAZrM3yGrPFIO0sDcIknCp9Xq4TydUOW1Nlu6au7PLrhGqztSgndgnaV?=
 =?us-ascii?Q?MvWJdISIHHfiYqdjTAFZQa7K0xCdF6k15x2FttPLcwavFz1c4bYT/PUXSdd+?=
 =?us-ascii?Q?TdXUchUYvGUk2QLJ/3xRCFLDXWcAv1OTPWS2vXp/UBujeA+dzCzmAY3vJTac?=
 =?us-ascii?Q?EGRvq4OK47084VSIrBoOuaCecy7AjsFja9mA2WgAZlPWklIYTXlF8oaeDk08?=
 =?us-ascii?Q?N5tUj53tw/DL8kPNdaXYY8sG2YmBt4L3OtnXznDU4uaNY8ikZur3i/sVVSoE?=
 =?us-ascii?Q?gexox/8oJVclRnCkOknU5nQ9J+6szgccRdEbBxH5zOZQ97+ho9cpswKIaMOk?=
 =?us-ascii?Q?Do+YTxydKd4ZNnbgCuEQLk3GuyQil1gn9v4s1CYlnUxg3IZDJu2V5XV6tIL3?=
 =?us-ascii?Q?Cy/xU6smpKuVGhMoFJDRt4Mhtxu9IkjwaV6gwG9FH/TXPc6zMaEI/VOhx+FQ?=
 =?us-ascii?Q?mlECFAHm+0WbQrzsgo84xfNqGirqPFJFh/qpGug24TZaFLOTK4CD91+sHSC6?=
 =?us-ascii?Q?WXsoY5KTI0e8xyXPkxy0Xff4zcwA6h58khig6fASq6xk1hdlacJe7iRGe0G3?=
 =?us-ascii?Q?QEk4/0weKh85CCXz9lq9As35q7jBD8GgnfBSusKec03bzQJVVJ8VqbdctIOH?=
 =?us-ascii?Q?332VZQEJbRHs437U2NmDJxfo+nl90qhwIkpspMDviwX+rcDE+JjvRrhQHlUq?=
 =?us-ascii?Q?7ssJw9PvaP+11v0+1VfEXwXDbp/pcN4pGTwn3dXqsNrdBH/KE3qBu0iL2141?=
 =?us-ascii?Q?2x+GaPuIDcdxW7idhSs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jIRDwLYFznFV2hJhJZb+1DjA8Q4ZwGNLLUpgtfV2rueU/bJRnZgqo5KSpr1G?=
 =?us-ascii?Q?vLKEsyf3qg1ol8GijEvo7y2DE64F8VRXEXlveMBiEjS6jBZsMQM7GmG8V1o5?=
 =?us-ascii?Q?9xJv0ZjvaY2rAtlwRrvGS06WB/N+giSQ2iwvL/m1OY3V8JZruLgKoLYyE4lW?=
 =?us-ascii?Q?jWCkwVmlYLCW+UZwKR2DWwwvZMI37nzOwuVz9pTquOAPXgClOZanJETtSOwM?=
 =?us-ascii?Q?5UxLrShc/Ca3iOeCO0WDHttnXl0Y43w6Vojzsm5dfAF4H3V1DWl64FA+KTWB?=
 =?us-ascii?Q?/h4lB4e81HYIOvINterEP0C5T2NMs1vOPylil4TaYWLMTErOMzrK70CoDQbQ?=
 =?us-ascii?Q?PjE3NV45rvSreyLtWuXLBYDop8xaHUnLgOwW8qXhi0FcTz8xygtZIW0PWEuq?=
 =?us-ascii?Q?ZVgbSuQYwkexDZ86y7nMGwfG6IhfNudvwfWzVibklp42pmsBncjNVNOlYuJP?=
 =?us-ascii?Q?PCG0NPwVPm/lnqmzW5AVDc79NaOlja7tb9RpjMYlZYXJU9lEQ1dopPnVkX0u?=
 =?us-ascii?Q?qWSX5TpJaH9cnMLGrg5NtTg+I64QOuI4uoymbH7BheZdJ4SFSakk5XJGBBud?=
 =?us-ascii?Q?0Wf/27adHjyGiJ5Amgg+XlmUpqbAz9iywyPj4phMwNQMiiNz5ktlZ3mwlyfc?=
 =?us-ascii?Q?oMLKDMrOTKa2GtmczjKHhh4doHBOpaLZOuyJabMLIHl+Z3xhTB4jLfeg9gec?=
 =?us-ascii?Q?EK2ZIwoVKzTcTT9jQ1daemf5mswtDEIwKksrRbdq9rUQrO9JYIEHO+ge3n/n?=
 =?us-ascii?Q?A0MlWHdVVMguO+n5Z8AUDKNGzPSgMMLwkM7wMJV1bR45D9iUQKb4nJzEUcfZ?=
 =?us-ascii?Q?KT+gAwFiU5cFcNCepsylx7aKgYMWqbcsN6dBauA5hjWa7M0eByAJODwaCdmF?=
 =?us-ascii?Q?HTCxuUdFp5MAXYU0RLmmL4+aHaODFYpfnH75gkZRIojmPdZC38SVEflHXNis?=
 =?us-ascii?Q?O/X7gvr3A7IZ37zlL1R0SmpsZDE4lFanNqVNZVPuMcBxwXvqiG7udzdFZYUc?=
 =?us-ascii?Q?DTjwVS1WZN4uwIn8JEcmbOC/k5KEByOER2hzwvVt6q+Ff+lPW0ODxLaldHjL?=
 =?us-ascii?Q?9RglRfwDMznY6+2zBEjxx70ETFD+y5jm0F5qNFUu+Qy5cUpC7xZrwk6X7wa1?=
 =?us-ascii?Q?SWnI9lX3zShfdDigd8voByQfH/H8qs3Jz9LI30Fu+7UajHDbibHUjytLEAJA?=
 =?us-ascii?Q?y5ku/eHKKIsAWTexiLeNcGyxM+c3bG2NxR10dnrTEL5iOumm2oaS2K8jw4XA?=
 =?us-ascii?Q?GelhYw/OJkgfOc6H7lON3ApcCYjmrbSjBvvENkeTjo6FqidWAYKHE9EsxPp8?=
 =?us-ascii?Q?prNuJRkijhjHwYu5j+bmruGLBzyHA5fqT2Lc9Ptaxh+N81xEdr2cZFkyHota?=
 =?us-ascii?Q?Y8axiswaxXLPne39/aeSq/oYDmX6Qkk097/NIS7oGRqWyFWE3mZyk0h4cUiP?=
 =?us-ascii?Q?HC5u4uEFK7ZjPyhKolsw8auRw9muXP7QC2H6T8Ci3yQtlfJ1Udkm5DQ3lZX4?=
 =?us-ascii?Q?uRPPzNnFsV6lJHXd6Rely7VPJR1lJ3iJM4W6ES3yd/mHNmiYcnccJeXNurMn?=
 =?us-ascii?Q?HMBB3KIP6hRIwBTBZ25Hj/iIXBrNWrfI/asxhewvV6c6Bv6fA/7NmQBCYbyb?=
 =?us-ascii?Q?e0VAUDcG0ZSJbbSeX30Q8Y5BAKpKBwoiO+wqjHfJRZrwN5IsevRPkVFnoUFU?=
 =?us-ascii?Q?5JN4tHo5+5Fc8JnKdEDDGd2IoHlRAi2CSFwdYzcrMs9s6bZBoVG64SUWRrqQ?=
 =?us-ascii?Q?ff+GUbSeKQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9EMbKC6/AyubRkp1Xtz+XjW9YmPTtuersQsuYI7t6WY6DKNxAx3rDeP0Ev5B7ZwVl9LhvwLWpO447iEb8FbrsuZJFMqJk/joawM0h/dBcGxL18WXKQtoF5ogPJIee+w4AE9T98b/fiwvmYcaADFUtC2LCnRb29zCRjpRZG5AubTKvi5t+SEBLtpc8pgqEomMlIv8S1nOuiundeD6An8YgVluGhDr9ZlCoMkOuRmcH9rrUeFzmnAt9qvOT2j3hztpYhUXOULu+QQQUQ7zZux7vd2YUebhaC4ugLZA3rrPTPhfnJNJgmJiOVGE88W0tVRs/8fMcJg3XIlIwkgKRQEDpgb6F1jyq92Pry6siSUhr2C14XPmXDYWRh4xgr4Q4AIDTZA7+zBaxOWgHGqFGgM4cEMbDYJltTceUTttLWwhGp5h0PVn5GyeoiWwTqnzYamzWQFT41Wvr0VtgjU1L1ODbGvxj8qaFFudEzkRoiHVO51drUfjDWzxD6Ni9XOJJH5EB3g9tYs0vgL7MlG2US/gU/B9HSvCwKLTfuBim2WSC5HlbOVWFJ6d4t+Z/dCZyOl9AH1zIlvSmcqgzC6jv1xh5stnc2BpMxMvBDbWgSiqnjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32b1695-824b-46fe-a959-08de590e35ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:50.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyiBU3YbRyY7hd6aPNK43mTAdhI0kxbH15862tJrIkrZfYynVh5UF5dmlcXSEUsAS3Raf0+6DJKMrIrjFibAAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Proofpoint-GUID: 2UiAM2JPzJMG3EzYl3KoHbYJcORoQyVO
X-Proofpoint-ORIG-GUID: 2UiAM2JPzJMG3EzYl3KoHbYJcORoQyVO
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69710591 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=I3VoEf0meaw97abzItIA:9 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXwepikilABb+B
 dOOSJ0cBlGp+YyAwkEYlnwunQk0W5G9zXu7XnJSMevy2MWyjPhGr8PnfnOFSdv39WJtJ4QKH4gZ
 +c8ceH/F4EmVK541DOqp5pAFb2pCyjpdFVeFcaI89qqoFauvFKWcpoeo5v/Hplj7Y36ier9fXCD
 /wI9MKUoTy2RbQFnKLRyY+6e0YUcqa60nPmpBDNBjmfa3tNbjTW7GRMJffCkny/CF4NPf2rY31g
 CcZnKtfuTsdhHP6zDEILMVuMGR4Pg3JoELmCnHmQVIV4mQuO2mdIskdPgbgRiWRpInmmKtRIF/T
 vdXGga0DeSpsqTcyT/pmHIYiS5JFRac5xatoctHD+Zsw9gtRza6m5g6TZMpLXpffBqpFBZtpqmr
 PsQphD5MysFnjePtibZSFA6zQPndFPsDdBUYPxy8x4R3pzbsr5NYaefj2+WQ/oAKIelz9W94vqU
 C+TAQX5OGh7fKqFnL9yYzeRy3sMvT3/9Y90o6TYc=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA69620003
X-Stat-Signature: feihp4rz38ctnr3ub5gfghtuhpexqbds
X-Rspam-User: 
X-HE-Tag: 1769014681-263293
X-HE-Meta: U2FsdGVkX18u3PiFpWkM3rqAIvXnTqBw49FJCYECoOEUdjEs/nAbk8SVABs/baVtzWhHzogR3uetgLNLwTMFsTPkCTICPd48qKI+PlFh1hj2eTFOnK9NWCxyGqsXZfX7nr4QJS8wtoz8Cru7pfqRMyDuYOco3Hdtu3pY9pNXWr7zNRuBzcUlnrTiudOCa6sdpawXiDREqMH9tNJq1MAGxVxaeTDQSVUTYn+KcKoAh0JHPL3qfTxSROgpFPTwSfFsTLwSrhjJPkfbg8D2crVKGdebGKNZmy03IcYZ/Gan7BK1URK1yiVb+aNNqxs1NqrBDXO4tMSUYqGPHCFQwWWrr5/68EnZNz4iXPt5uW8Jx9a/OyyjfLNckqOoRNsUyhunzFUam/Cnf2xuDnhNU9JZlWOEZ237mHRMxRDCOobEO2Muv5SdzsdT8n3Bruix6/g7aLtLcCIv44rMSN3YcXlLwDc9xCF6hBOnIxv5WXvRAGnvaANROGimb5uVPazC/i6MtDm6p94TPTCuQepv64r0ASyV0NvULYVE+N30nEudmMDtnG1d7Zdhwt9lDioeMShn4T/pxRmG+O3KbEe7cXfopo4Ir6wVm0eUyFuDLDTCWwVxq6nr0eJS+Mv8IWtHiTSm+IO7Y7aHpXkrXSQTXrG/mlp2WJrYffICHAg85ahyd3Nrt3JS2ssJjNRAxOYYbayzFqEgDJItSS8dVdlfsPlgGF6mjrL+rgloyNPiAafhNytLtiLljodxF63S78qb3dFqh9LGunvROYYlEk22NIWELyHXt+o1Jo5fnC7C7hcpNyeq0nMgwrM1HrUez8wCVdIZD0GSvWO4utT7hs9R1Xtrsiww4QBRrycB0hGsCwjRia5zdAip21I9WfRqtEg7eRghdHDSYXAdMeUh3orChwFpiEKx3GFFPnR2cTGHTEqTxEbkigyC9sEfHdMOq8aeNbe+JCEc2lDz0/fK6iwgJC5
 +byTy09j
 +2muJ+Na4tCK9AJp75/kr+FI2RlVQLvbU2xt4rGu7SMBv8TpQ6ig4H59JLi9UfQUWCsSolNVpr/f0KdnQd5CEnh3zCJ50JB5ysVbggmUKPswIY6HpD7eIqMAYk/eSwpqjddWu8dicHd9+zg5/FJA2n+Mvp42NvriaA8QBD/ryoYRhpOj5jkqryNbVV4d9QeQUalQ/WI9eShgfcW75N2dsSmXDrb1Uddh1fT2iQRVAXQHsgXj5/KgARtBeim1v2jDpYStY3L0C0R2hoJgeyocGgLfzUT6sFtzHSgzKKaxs5Fki1+gKSd4ecjmYCkTUVX4BWlLFXzD7XQjnb4PeYlsTApbyTrzTrjJjBnCc3usCjwL+mBJsBy4or6+uDbIRlqWg6M+1YSvzjFsI3Hw+Vu5qDxFtET0g6GRTZUhAN5+HRjgBA+DSkvniSwlkBvAj6Srx61/gKdzx9kyRU8+aqtIiedLect39DFvSFZmnQ9BTjWZTaUrHkLiFMThplC3vVPz7Hlf3OzTbK/eLB88+P8aV4OuEzve31lL36bNb5yXYbZm7W6Dw3Y1wrwsBeYWPuc04vIejylfjbfDEDpJErLFQH+vbOEZwmXtUiK1hQwha0CFRW5T4ufzHAu1XjRuRk0VWgyBrfs77paJj1IYGO0hX6lXUvq0XL/KjYIsFgv4/IWdFJfqIyWYw+4pIZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new_end does not need to be passed in as the data is already being
checked.  This allows for other areas to skip getting the node new_end
in the calling function.

The type was incorrectly void * instead of void __rcu *, which isn't an
issue but is technically incorrect.

Move the variable assignment to after the declarations to clean up the
initial setup.

Ensure there is something to copy before calling memcpy().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index bc58c10d3a300..e5cf947f1a576 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3114,20 +3114,28 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
  *
  * Attempts to reuse the node, but may allocate.
  */
-static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
-				     unsigned char new_end)
+static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
-	struct ma_state *mas = wr_mas->mas;
-	void __rcu **dst_slots;
-	unsigned long *dst_pivots;
-	unsigned char dst_offset, offset_end = wr_mas->offset_end;
+	unsigned char dst_offset, offset_end;
+	unsigned char copy_size, node_pivots;
 	struct maple_node reuse, *newnode;
-	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
-	bool in_rcu = mt_in_rcu(mas->tree);
-	unsigned char height = mas_mt_height(mas);
+	unsigned long *dst_pivots;
+	void __rcu **dst_slots;
+	unsigned char new_end;
+	struct ma_state *mas;
+	bool in_rcu;
 
-	if (mas->last == wr_mas->end_piv)
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	offset_end = wr_mas->offset_end;
+	node_pivots = mt_pivots[wr_mas->type];
+	/* Assume last adds an entry */
+	new_end = mas->end + 1 - offset_end + mas->offset;
+	if (mas->last == wr_mas->end_piv) {
 		offset_end++; /* don't copy this offset */
+		new_end--;
+	}
 
 	/* set up node. */
 	if (in_rcu) {
@@ -3141,13 +3149,16 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
 	/* Copy from start to insert point */
-	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
-	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * mas->offset);
+	if (mas->offset) {
+		memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
+		memcpy(dst_slots, wr_mas->slots, sizeof(void __rcu *) * mas->offset);
+	}
 
 	/* Handle insert of new range starting after old range */
 	if (wr_mas->r_min < mas->index) {
 		rcu_assign_pointer(dst_slots[mas->offset], wr_mas->content);
 		dst_pivots[mas->offset++] = mas->index - 1;
+		new_end++;
 	}
 
 	/* Store the new entry and range end. */
@@ -3166,7 +3177,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	/* Copy to the end of node if necessary. */
 	copy_size = mas->end - offset_end + 1;
 	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
-	       sizeof(void *) * copy_size);
+	       sizeof(void __rcu *) * copy_size);
 	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
 	       sizeof(unsigned long) * (copy_size - 1));
 
@@ -3179,7 +3190,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 		struct maple_enode *old_enode = mas->node;
 
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace_node(mas, old_enode, height);
+		mas_replace_node(mas, old_enode, mas_mt_height(mas));
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
@@ -3495,7 +3506,6 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
 	case wr_exact_fit:
@@ -3510,7 +3520,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_slot_store(wr_mas);
 		break;
 	case wr_node_store:
-		mas_wr_node_store(wr_mas, new_end);
+		mas_wr_node_store(wr_mas);
 		break;
 	case wr_spanning_store:
 		mas_wr_spanning_store(wr_mas);
-- 
2.47.3


