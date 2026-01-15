Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED5CD4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C2A6B0093; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FC86B0095; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4D76B0098; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14A2C6B0093
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF8571ACFF4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:55 +0000 (UTC)
X-FDA: 84335032110.20.852E2AC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BFF7140019
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bbs6VGGQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eydL5oYJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501672; a=rsa-sha256;
	cv=pass;
	b=hi3a2+8pxdHU6bU3XAOytDY3Yh8kw88UAZcNWsvCN0nUkv5EQRNBdBRnJCZM4Mmm86uuMo
	y+Zl3wqW4XNnxQzHmBiCr04xYJA+0q9Lqz9RVXMRG0uWYWCh2ELY+tgD77mPENBDFef9Lw
	HIN2hYthTAxb80qyuSZvGUazP4WT++0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bbs6VGGQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eydL5oYJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
	b=dwr2jt30/nEPjLyWF3AA/Qsv7bFFUq3WnUtQp0DS6N+m895lXO7IIJjJ14tgtYS24c5JDY
	CBLuF3rKCE1D9ae1fjkQiAFTB/EOx6a5VJzQP2ZKzbsIV2hVQIprnLN+P1nOXTGBIGgULh
	xqGQIkHxPC/P4Iql2eG/iVPSEpMQJ7E=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGpWdp2755030;
	Thu, 15 Jan 2026 18:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=; b=
	bbs6VGGQf9q8RwhgekNzTIN5wcQrfNwZuoQ+YXBkf7tBGEqCUeX0eRT8a1bfSnDn
	lXBQonBMwLXSbuv5zKyreOiMgXRrPi+0BRcx3UUe3GO4Zzc3GlpwzWf9C+6h5jaH
	E5y4IDwTAw1OlhgkTs8JBxCA+94zHjkgp9Pqz1ewZnAplyhN+w3ItndL8chLCpaO
	dQGMOFlfMWLq/7d4PU0GRPSk81Km4DRPh3/e2zzzamb2sY6Vp5ABusQW8TJLORsn
	hWZrvoZ37nfVzcbogDmMZ6SU+uZZUU16oMUe9svTHwzlRJ3wMPENTEUHEzqITfmm
	y/pag/BHV1lGvDwYiQJIjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrc9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FGpNoY032668;
	Thu, 15 Jan 2026 18:27:34 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6J615+oP0HSCr4L7e7Q1cTK+qZjELHw/8N04HxxpXlFQ2gHFdv/mY0vI1d6TmN5vuG+75jpZ5AHK+gwPIEaxrFeRHLv2WLfP9Mb9KyTiC0SoUJRrX4815jWrOM92TUHlx0FEFFmbq7isC/v25wgohwbv3KTCDlp+f3gpWc4qVRxE/6ImFh1XWNrSOdAFdLb7GBuHixkD156z14+/5x4YndRothANCIdEnJGtynMM9l56xJheOUMO3Oc+qjDyF2qkvMe0uRrejisbb0G3PuG2h5/Idhc7X4aAwtj3GVM++p0mm0ooT04N0B3PDbGkg7JV71Yrea6mSTdIyn/ZzKtBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
 b=JFuobq96PbhPF1LWWNiBiFVsBQHEKlZcHtydpFBqstgU0MSg9DrJ8Qrdh4XWQTq3VTIYUeOxe/Z7igAgkSkQCp9tr01uLfq4K3XcHSeQ9NrMAHGYl55Tb3l0AfuHl8+v8FwbIADaNY56GBCTDmJYngcJze8QvubQ9tsr4ASGzbrNZHjtLZnHA1lC1rLteApe5y4h8B1xp0pklUPeeZhVGbwz3l6/a/b9ODiNyPRU4o5sLVGf6IsgH3ZDuwSm4T/HFYyYwW+z+zNgSdzvdoc5UyVO0fGUfLxmfK7KPzz0chQIN3INbTk9cfVf3zaj3HT8Ga/p83rVGhpcTHjCLe1HsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
 b=eydL5oYJpBL1P0UPPxnL981TfaFJvPGsSwhcM+oLS33MS146rovCbXsEktfT11AFjWzJgty8oWFT2Ls7XtYjhO0bAFuLwquM0DxA7vq9djLIRe759VZhYoFfnpRoyhLa+J8yk7lenqOUORSSjevDGxbXA57DihZKMx7ncqxQhFA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:29 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 02/10] mm/mmap: Abstract vma clean up from exit_mmap()
Date: Thu, 15 Jan 2026 13:27:12 -0500
Message-ID: <20260115182720.1691130-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0440.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: ac3ca141-90c2-4af2-b3c6-08de5463bd70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JDqmENn4JZMz659uqZ0bhILYrHGyqBva1ui4aq4zZ+FUqT6Yckbbi1UO1EbL?=
 =?us-ascii?Q?6MKh6I5YoNLRMeH4cErq/5u/izvCh5VQjO9hKRgLuxpBEzjo4jvFmOK7XkPi?=
 =?us-ascii?Q?F5pVbwQuB1Sw2Nc9MycDEaBvtRHTPbUw79iXaRuctM1iLWTn+9V2p87b47Bp?=
 =?us-ascii?Q?ewiwO39WONgT7W9+eh8rgLuJuEeYDrNi8ucPjuoDcgPR1TboKKKwST5pEDPI?=
 =?us-ascii?Q?APZjKv3a+mw0SUNl2RZfiSbRN4aXqm95biCzmShJH5SsKQVgxNIaT41cB8v6?=
 =?us-ascii?Q?5jBQLkwL0FAyxVtgYZ3fK0lfLFQTgcvNoeaTqgzJpersF+M4KV4SV2S7c7rY?=
 =?us-ascii?Q?ANbpZmFi9sm6di3MLZ7NuJZdggwNM83YQ3T36UtSvsxgq5Kk2UYrIbb2Gx5p?=
 =?us-ascii?Q?gujSg05VP/AFbQQ52n6ujHwfSJ+ugDkwMBqoTyDY6VmE1RqGkeG+lF88U8V6?=
 =?us-ascii?Q?ST3DzuJTsni8x7DMrRx8W+0ZpdpHUJB8+DULIMJzKG5UIrP37pi/gkXB1MC1?=
 =?us-ascii?Q?ASMXjyJ3hgR5ayzILk8tbPn+cTUMhurVPsyNUvumqkMP3hx8OO9LDwydFUNR?=
 =?us-ascii?Q?JC2JxA21Q1gNhIiwgSIgw5e0x8TsNoikymZLrKIrgfR66UqrvdCZ7nytldP4?=
 =?us-ascii?Q?DzisXtSwWi93qS7Z8F6lzrtoKX8Pk5CE3p5OYepIJWczk+da5t1zEohzUXXb?=
 =?us-ascii?Q?ajE2bGN2+3pKjswswOUOxwaMQ/zSN6MdDlAi0wbyVCu+kQ7IHKo6xW3KkfIX?=
 =?us-ascii?Q?fismori5CacDMwNpYOhbtyLZpOGUdfhxr5nPaYIg8DURxXQBHg5KbY1eIw9l?=
 =?us-ascii?Q?JfdtoYX4THPBdD1AlgTOVcb/XfyH2iYW1SqzilZkVryZfOR0a2/UegMlBgjp?=
 =?us-ascii?Q?+1W1OfhW917gg7Qh4L4s0CJfw5bmBfEG6OVjHXyc1tDVEhOi+Xo5zYE8ux8k?=
 =?us-ascii?Q?mHACWEsjFckMrq5wmL0ooG1YC1wVP4EGoA8PPb+AYViCFnEAAWODXYUsMgal?=
 =?us-ascii?Q?8gbseDCsF3iC3hLJ3ufkxuwBNVX9gZsNXuUTE0ccmHiEPF5aI5ZTaactpL0f?=
 =?us-ascii?Q?qg4RfEh24ARyZfzSgDb688mUX9/Xj3hemdzijBNC9ZJg4ek95HZrBMtJm7pU?=
 =?us-ascii?Q?3eL3lisWG5TgmZi5tDh4QhDw+sF//ysBO6uqasgxHq/Gqb45PxazFRNoS6YA?=
 =?us-ascii?Q?Gu1ynnkVQmiPgSoIEtxz1S6IiKPPts65wuYQ1V/LtTcL3vQB+Hpji/PQdPdb?=
 =?us-ascii?Q?as6CFzfbfolnn/cfA4PBBPu2nTwAw+pijoOkfrCIWjq0G021HAy1GIfBh1kz?=
 =?us-ascii?Q?HW4eRyOaYHlPET22LptGuMHQi29KiEqFXBfSMzfllGx7C6pCLEw7rpXCsEnF?=
 =?us-ascii?Q?F7icSHFGov1vR7GYMYWq2UCgm+mzMFEI+vCUkvlGjuO/nmJDOwB/1wOPKrdz?=
 =?us-ascii?Q?QQ4V3DA2dcAMpdF38r7SEvaMUYak9UcEpZdeL4VU1zRXKT43CzrCGPyTV0ai?=
 =?us-ascii?Q?WSnUcgamC+/Vlio7FaU6YiMOZcHJ8UCP74ZgGmEhDh8FCIU/6KX+k3RYH/ji?=
 =?us-ascii?Q?0GUiXrXj6SQyYy+vcO0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?obLE1IqYjcLu8/uBqwZHQEbVJlvYMFk7+ATHipTM+LBv7R4heM6HWgOqyNsX?=
 =?us-ascii?Q?l5h2lBVwxzfTeFayZNdofUik0/vmKMkZ1uz1jus1t6Yho6LRaRlCtCMg6JVe?=
 =?us-ascii?Q?gCxdS6NHP2/VA8+ivgAL7GXpLekgchqx2HU0UHmesJIUSQLjRPkCxtKVA1Bu?=
 =?us-ascii?Q?3FxGDWf8MP/Gnirtorg1y41jSu4Z+hm44mV04pY/TeMH3TNnsf0EhWljptFn?=
 =?us-ascii?Q?FOuf+I+K+hwNW1JFgpKz/w/0glFsUOC3nAa9TLiKlebEn+r5j0X/4VrPtGHs?=
 =?us-ascii?Q?nexkgWduoTcWVJTxhvLDP3atd9SoHudkHkZjlBleu+fv28kU0UpIjf5Ks0D/?=
 =?us-ascii?Q?HmOuGZvmrS2mgPtmKsR8zuDnzrEmmuXcPfKk07M1y8YunaQHk/Nx3HZ/Ic8G?=
 =?us-ascii?Q?IscrBzvKnG5i0KiMUVKMBr7fXbjaEjSqw1O11kNN5cTxl7oOZJQjYEGWJgml?=
 =?us-ascii?Q?+03+ugnmoU481Tjx+sye2sUzy4lpaklRL/YhXfYv5opTfMGip5zRGoEryD1z?=
 =?us-ascii?Q?ySnEIkMZjttrM7hTFXYBzVj8AxAanG8pwPpoRVwmrN+yh6h/oj6pWMMFshH+?=
 =?us-ascii?Q?PAYv2Dn2jvlkvXRD4OFiAYF0IGtBC5wOPuSw2xKKgE8axSUhKwL8ZvPhWhrf?=
 =?us-ascii?Q?l5digPmz8SyOs9AZ76MSjfYeEf4qYRd7+3hDslxdwGTYYGkOvNN98Yg2C0pw?=
 =?us-ascii?Q?Qa532p65Vs8/Huhy/BEd8aVisY9zJGN40Hq6D3DCXA9157jykmbWwfTixOnq?=
 =?us-ascii?Q?qhYfym3tsNd/P9L4yUgjIxwhfT2dB868lFpFb6WjygSx3MszPgOKyS479Z2d?=
 =?us-ascii?Q?BwtMxskMKFDkppnHuIiuQVzvoZYE2WxPES2R7zTUs+GvSwWHg1AbM8sU1B+B?=
 =?us-ascii?Q?vtrxPfZckK8CWX9B5BtpR56LHOAEDh4WpEIorsoZf3Goz6QjT2XdoAI7F1r+?=
 =?us-ascii?Q?NOyUQG2a00t7QLALRRWCQ+CdlhxUQQwjTxoylKjZlpFwWcFobGwjeu+PGTda?=
 =?us-ascii?Q?K2sUgC9weOJMUYFVNx6YGQi89xsbO4Zn+tPM4Yavm6X4iY8dM+ZWqfIdaQXv?=
 =?us-ascii?Q?kj9ebtzG7R3XSIAXuwHeKKEws24HQy6vvmYIoibWDV2lcAd0a6OWINm2LA8R?=
 =?us-ascii?Q?wYZmaLl2jLXEEioNuzVmVLcgZ0nMWEa0tY+MgjmNoi3gNMusUXGzsKa7D1nH?=
 =?us-ascii?Q?NRi7VfP0rak8EohkvopCYgnlzsTx0502XRa0dEMU3l3bClZFgPP92/obfxRt?=
 =?us-ascii?Q?eRzxn3/SCu/R0lfELfvMFZWEqJPFacee78LpgYDUrh4OE+0XecrfK/AZwE0n?=
 =?us-ascii?Q?yQ363tIWrHCX7GvY5JbJDcDtnPejMJr1ooI9O9vuER3V1HqreS7fNXZHtM4a?=
 =?us-ascii?Q?cOREbbMs3+r3FCj8wHG14+bafPhL0mMdncezkZalFFRQ8g1fVT6dg2rm8fLe?=
 =?us-ascii?Q?4yEX02WUju8Ey6+SGcaJdbJn9zO7ZyiI42HjWEUqOhfFRTw6RHt7RMbCWfSs?=
 =?us-ascii?Q?PnFkIC6vLSKyj6x2OO7WJ6iVqT+ede0VkQ3SkMgDOJ4BgPiSS+gOR1maq1Kt?=
 =?us-ascii?Q?hLfdoUVAKwUk9t4RC2g+uAveSmXEZxqAj7y73gEQRr28HFNBAdz988KNG7SU?=
 =?us-ascii?Q?WpIdutaoJr0D6rpdEZ+T5/mdRc3SzFd1lpCpio0ybw8Czmmo6ha/a5oB30Sb?=
 =?us-ascii?Q?G9hwFwH4+1kKD6QdBPIHQmFn4pwoD2M2MmlESGbfhS0WZjOKFLSUhwXwSIiS?=
 =?us-ascii?Q?nuE3F4tWgg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/VJ46+R0egEXogxCeC8rBjN1Wmoo2/4J26qJuPB4MLa0VlVbNaq6AAmWs/pTKodZREK+GLuBTX82c0GdL4hrRrRfYHWBnH/RtyFhLbVkoxAPxCMYofl0J4QTkTLqyYCmSHkL//HqZd6+Anyp4zjWhiGppaOjAVUF73ChrUabe781MwOM7kTd0QwBS8H+AJsMOWW34GwIXFn1GrqESnRyI98CDu8BS+PveBS4AWNxssVKjBs4QKo23Sq6wgxTe49HAfRdCiewCZLmEemOp7hexjMb3AnxXoujYB8pMfOmappoDKc1WL+4suuPVp7VD8m6XacbJQHRu4wU6bGDPMzSv5GbQluqfuyVRyvFUXknTtpqlyRQhc2VrzJ53j/iiHLUDiLomtM/SHT2rahczDkYKj44hcjT1LerXXcKG9utedto8nNBdktpGfmtPXWDCb8kt4bFlh9DMj8rF3iqTDXZcjMZG/N6Ojp+zdVmAebUx30J8IHiraNjIqiYe5N2/vE14dSRS0p/v4CqvnVhhg0eaWBaWqMOdt8Sy4ds/8r0G8jcCcbjhlvy1m8/mddvoRs7Ov4V5iPw1dvQgKFdfl1KmnrjVO2Gdt78XbnYvf1Jn+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3ca141-90c2-4af2-b3c6-08de5463bd70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:29.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/O8hlFpz4At6aJW5H+1/fTHupNgjPSafGBBrnfGciAwkyEQnErJqWh3dCzMeWWOwaE8B73Bh+gcsaPPmP0sfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-GUID: _GXKIAA6CcggdJmjbQ4MCg12eowKkdvg
X-Proofpoint-ORIG-GUID: _GXKIAA6CcggdJmjbQ4MCg12eowKkdvg
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69693196 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=DO5yfXpT9pfNaLUI-vsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfXw8vjdOy+GNxj
 WjLEmk736jQUzh3w3SkFiRiI8PQf10ONLD+9UP3W4VeyMhM25GermM1EsZRio7Jdpn2lK3Do2RV
 xws92y+cc6E7MeATSLis7YOVbvgmUnjvNjiNMTMyVnMGkaz5Y/dZDxkJ/NQSWmYXs9v/+BfIncy
 nWRJFXHun2Z1wN8KoGgipooq7hsUve9dcxbKtsEHefLfdsfobtfTpzT+0FQiYqg5Df3L/Ugs7nc
 3MT366Eypn9DOliCULvWNNosLZ6cnWE+feJhFQe111oJNmUuY8eDR6uVEmQWUOTtG9g4vfRpiT0
 EQNq+IWH6HXFVz3zikfcgHQ6DSu/YgcPX+iBE+bcZNPd9RJiw9pl3NlrY9+Zz2ayjGDDIj8I9Sv
 7cV7Nqkw0lQ3EdoYGSCsNt4THP+36u1HDCQwWA9EmxVa/XKj1QZBXx+VsP7G83OtnVRyCXvI66/
 yBf8fFmIbbak+jJIweg==
X-Rspamd-Queue-Id: 5BFF7140019
X-Rspamd-Server: rspam06
X-Stat-Signature: 8p1cr6i9tqyniegrn6b711ohg5jc1kzb
X-Rspam-User: 
X-HE-Tag: 1768501672-472349
X-HE-Meta: U2FsdGVkX1+QnbZsPZBA7AZ4a+zQGX2HutYku7E8c1xKjvjnCIHKOLqXvCrKWHfZIAwa+u8+/LWjWVR5/sX5nAfmxA4sNGjm5beHDy2HTSKXwhC7x3t7/gZ6AVY332sjEu3zkHaCqyXF1Yv63BoUsuZlxhVek31auOvIBo8l4HW1c8zm0fb7AECyn3UAnkfjj9msb9dn39kFukGE0LCsU6dw4OyAVsDMqqWsvPRK9vnBZ7Fz1WOXGHnbD5PPNsnuujlWJL2ms/lgsz5Z77laf2wBCvEj/DIcavdAv+nTAYhk3KPydHOpQya8dFpmXKS1x1Mw0PtgtWeVdvWfN4BECHozr706ZbAHWJPpS8a1Z3D7LZTHsIc+hwm1Y5lu0it7tH5Vm+rXUA9ZDlNqJHQEmTb5x3uf7seHG3KwIH9LReyo7r3gLqjNArnNMJiFNOr8hhcmWOvh22H/vGPLV6HZsKo3seYZQ0t03fEUUq5VlyfEU93RuBj52EeekYKj4A9AuOtzS3gKGCgN71KC2q4v8t/Z5JiJk/6YrSjh/e7sHWkz3ogZNu92Xv5DkAsv1IexcnpTltsoAsFALoTV8lyvERfIJdirnpADv9TQRPr/yVFgMq5yoTZ+XTZtWChVGuUv5QIjmQUeaoIbUvGJVSixkjsLYWvZS+b9yRxZIfXIqmVYhqY1jL6uUv4PNrXDgqW36jJuQ6hwGaTbScRAtFFFnvv9s4/BjrxTfhg8Nv1f9dOn1wfVM++0YxxhLRpA7kcl+tYcSOHq/+vII0sGl/QU0bphu1HY7idumwxsv/wiQywCv9i3hbiWDiKGdTQJb29txmBjb/M4bf+NBvqE3e+4C1XQ8+3LucW7458VSYWSFXFsry7I8Cnr47rcAwDTGMHhbGb8kTHXvBBhWR4EJ0F3EfatZH0mPoD2C2DstBNf8OP/fNmiId2n7cDBK7eE4IIleXpRyuwRPDz1NspI1ON
 tXzvN/9P
 LwjxzmHUbKSWR3x6P8hQJwAV010gtnQFmItq4gUQWAxEYQkFoL0Wbr3q0jTLv9S99bj+w1LMAxk5drjjlISHoQBtN1R+PiKb+bI2rrXuvbCUfs39P+ZP2QlCTJSbbPypOXmy6RvmCGHgNzdJjD4KnapU4O5/z0PnqTSe64ZZbP+laWe57yRZVpEfqqQsVI1hnJVaFRAoTnsdEb8W8AJpt/sosHUE4H8fnxgTo8It3vmMqqBPmRiw9ZNRJLvNlMQdoBsmNVomqpTL+IjCY057JL2ei9cUgl+pAZcKEIrsg51HwOipUFn3lLooBzf+DPx2SuY1uCQtoy6BOGdG/n/e33hKqVEKOy8To9TDmuIewSdFztiZ6bnTcN50OfeMLQaB+OX6zeMyBVE2B/Dk3jECbJJR/dSBNs1CWSQBcAIY6vawFdLFq50DCsoOYLy2oV9mSanBfwcxC5NNwUEciwNQR0JeEZhdoY1S9byUK/LnNuuq7XoGPppmkpsnILPY8rL7Pazlki+1xG1LySSDNsw7uklvcn8Dyuft2h/teL5abOIctSTY/1ZsB1SuUGOa6DaBHqQzy5yPeFQqsQTPyv4tErDUcFx+acVmJ785KkmPXigp3sSE41Mv347ebblAdoC5aTe4/ECL68TR0jjUJUeaMOgMYZuisy2f7ODYaqA+5WgUrih75aLDZXDj4AVEaxArXXdZZmPSKmIgY4wmHzpDwxqV7I9NGBQG+6mM42nJHexQ5JiY/jlFlFotXxdOHoIUROrTafxdAmftnDLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create the new function tear_down_vmas() to remove a range of vmas.
exit_mmap() will be removing all the vmas.

This is necessary for future patches.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 1f025edf8d7d0..9c8adc505d3de 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1247,6 +1247,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
 }
 EXPORT_SYMBOL(vm_brk_flags);
 
+static
+unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
+		struct vm_area_struct *vma, unsigned long end)
+{
+	unsigned long nr_accounted = 0;
+	int count = 0;
+
+	mmap_assert_write_locked(mm);
+	vma_iter_set(vmi, vma->vm_end);
+	do {
+		if (vma->vm_flags & VM_ACCOUNT)
+			nr_accounted += vma_pages(vma);
+		vma_mark_detached(vma);
+		remove_vma(vma);
+		count++;
+		cond_resched();
+		vma = vma_next(vmi);
+	} while (vma && vma->vm_end <= end);
+
+	VM_WARN_ON_ONCE(count != mm->map_count);
+	return nr_accounted;
+}
+
 /* Release all mmaps. */
 void exit_mmap(struct mm_struct *mm)
 {
@@ -1254,7 +1277,6 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
-	int count = 0;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -1294,18 +1316,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
-	vma_iter_set(&vmi, vma->vm_end);
-	do {
-		if (vma->vm_flags & VM_ACCOUNT)
-			nr_accounted += vma_pages(vma);
-		vma_mark_detached(vma);
-		remove_vma(vma);
-		count++;
-		cond_resched();
-		vma = vma_next(&vmi);
-	} while (vma && likely(!xa_is_zero(vma)));
-
-	BUG_ON(count != mm->map_count);
+	nr_accounted = tear_down_vmas(mm, &vmi, vma, ULONG_MAX);
 
 destroy:
 	__mt_destroy(&mm->mm_mt);
-- 
2.47.3


