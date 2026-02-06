Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B9FEB28C7
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 05:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBE06B0089; Fri,  6 Feb 2026 00:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368DA6B0092; Fri,  6 Feb 2026 00:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213166B0093; Fri,  6 Feb 2026 00:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD096B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:43:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82247140747
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:43:33 +0000 (UTC)
X-FDA: 84412939506.21.D3B3A8B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 32B1F1A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:43:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DYdgU0eK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaM7m+9L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770356610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3L/H+FxZaXgLvUoxtiKf1Rg9WemezMR0aYRnt1JpyM=;
	b=ZLUEdL5dOOL3+H0mpzdMaPYRlS2j2XoDIeYPYhuzSy88rvzv0dfUT/X0/BwSTb/GuWCunj
	Q07ExMspdlx1yYOPAn3Dew/2R2aF9+3gTBlhcczKyX3FkMGwSzwDLAf3KIGiAacrSDhdVU
	pmtn82+PVQg/j7+B6W+y7DmMyZ2zRc8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770356610; a=rsa-sha256;
	cv=pass;
	b=Yyb16+DmC2DbBHvTVxIGigaHPC4h2nKTkwdbuy3upPdwNwgbmMitf/QoXgZM1o0zGO+2xO
	z2nxmF4D62jiojDVwVqLcKPoW70YvbWrbGm+epGVf+EzvFDiVr4HKm8y1gaaE5Mn60uATN
	Bdc+wxyVeTC1Bn3YjILWecSw8b1OAdk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DYdgU0eK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaM7m+9L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6164PuoC1718792;
	Fri, 6 Feb 2026 05:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K3L/H+FxZaXgLvUoxt
	iKf1Rg9WemezMR0aYRnt1JpyM=; b=DYdgU0eKrxP/9fONEnjspm9I2beKURJFjn
	rxY61vSf7acaqSAeS7SFekBbyFCItkLlqWyESDoCUNdSudvJyykNzAX4ghhnVP6M
	OD7lIVojXmgc9eqQuzOTEoxLwA3I5m9nu74CDTp5Sm1qWMHtsa1vsc/yRKLhzWa1
	n2vEbVaCITbOw1/F0VcTe4zGuMt75VjU5JAYzVFM6uXCkOMWWCHmn1cxo9kpInsW
	4owl0eNTfsj3ebH4JfHyPz7yd1Ga9mt9DIgM4ut1/1kSHQpelouRZnnDYr/zf9ry
	3SqY/M0hBzoSfqmjaG90vtsTOs0LjRzXilc4qrMTH/ei5Y1io4Ag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqmy3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 05:43:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6164EUk5040178;
	Fri, 6 Feb 2026 05:42:59 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012016.outbound.protection.outlook.com [40.93.195.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbqb96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 05:42:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANF7dTQKLht2J++vQ70ny7sOVTdU7B1auhzrERcHV3cOf23jWs/pYTNaWu/3FVwkdovCouALTnFNqMdhS/TC+R7KD0x5tMtC8oTk1dgjGOQz/8lbxRD1jLCetKHJdfZPXfyNrlZaxVuxfp4VjnAF4LFtNNLYmO8FfON3s9z69OMWJXA63gm3HKCoDvXSMB8deNrEO8nJG6pb4Z6ABtuZ1oSKQ/7hp8CzQzr0lma023TyV4stuURZuBbWNoQm9tCYufGzhDlh2G5DsrNpywT/X/ev2Z+1GkXDHlzSkCUekGW4i76kTDq2ZYJY7NgzNI73YNqe1FtY3O31ZYgjaYY6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3L/H+FxZaXgLvUoxtiKf1Rg9WemezMR0aYRnt1JpyM=;
 b=B5rUBWqTZAfaUzhlI1u1AAsBxPJSbGAulK0vfJey51OdGVsLIML63B6CCDvvH4gcSFs5dydoP3nGxrc0NCzEfV4hGfVRUKW4hYg0BcNjjOz7N6/0GNLVwbnrS+XJbZ3FZOIT0MqgDSknc7eaCcDWqvmsxcsuFidU3CtLX2uZGTK/oMTFsg2kg7lJhocYxZVJ3o8QuJX7NF4IarD/MsWRF2pxxO/4kpVWF+acVB8iuJYiOZqzh1bWs5BliwXRXNR3+HjCchTlCr1RsvJTSZb3dOLLeiutj4Om9TgrBEdVnyPs4w0q+k3jm3AS9Y40vRx7+Zpwb+PepOMft3K1LHGsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3L/H+FxZaXgLvUoxtiKf1Rg9WemezMR0aYRnt1JpyM=;
 b=aaM7m+9LsscZwiMzTW0zCPSP69Au+TgMI5NNaWbHhK1B1BuS0YDy+aBik8mAsu2EzbeWHZO1aLlaL2+9UYgx4GCUzv0Nc0sBZQdpCvYrLn6hTLK7g6JQUkGv5FIb3xLkH53xjoZbzj+iz5yvJyTBam6Dc5vAgf2puBbbBYImGIQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA3PR10MB8186.namprd10.prod.outlook.com (2603:10b6:208:511::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 05:42:55 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 05:42:55 +0000
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260128185943.2397128-1-ankur.a.arora@oracle.com>
 <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
 <20260204143116.968730e769500aea281809bb@linux-foundation.org>
 <87a4xneo5u.fsf@oracle.com>
 <a9bbf82b-bed5-436b-814b-cd9fa3f976d0@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, kernel test robot
 <lkp@intel.com>
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
In-reply-to: <a9bbf82b-bed5-436b-814b-cd9fa3f976d0@kernel.org>
Date: Thu, 05 Feb 2026 21:42:53 -0800
Message-ID: <87a4xmctr6.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA3PR10MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f18719-9e97-475b-45aa-08de65429380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/lDa+ZJ2LQhGWrFYApps+KNiJmRYG+p4H44s2MMygUb1MkSdW5+h4oqzZUJc?=
 =?us-ascii?Q?uMMjnJZDY6a8YZRREKFJIDDma6BOJ4/xysBhCYz2UTzehERhxiIlZ1ZwD6mj?=
 =?us-ascii?Q?6JdhAMjLuL3r62N+4o9BuABzywBisdIwZ18CU4BO8gnBGJsMNCyHj5DUYG0P?=
 =?us-ascii?Q?GJM4EHZV88MnEmV8X8Xl6jBxmh/oWbg8KYH5kyBh9RL3l0LbWvAK/yJRV5NX?=
 =?us-ascii?Q?aQLPJtRZJP/MAPNZNUgt8sTueOTArDyk78GNjFfjb4WSIPnM3IMxMPz4cGd3?=
 =?us-ascii?Q?EDngnuE5eZrU+0+X8P21xcZzcgQ4ewt+jnDG2BxMQAVAAALaV166t7TxCk0b?=
 =?us-ascii?Q?hOsc50hnAL/JJ4qbxURExl6syzmTjQsPZDwGTtYEnyhkL1+QEQwoJzgfRSue?=
 =?us-ascii?Q?+t2INlcGmkxYr83DNns1tKZw5dWQ13hX4WOvsKq9QG4/i0C8bht4QWvsYrIn?=
 =?us-ascii?Q?ZLC8Zh/hEdemJqza62jlLs0ySudTZf19MGZltL+5DHG81OiaVcw2zB+NlZCD?=
 =?us-ascii?Q?J4SX1vowtH7PKVKX2KwIHm3TJcurZCZrXZoBe6piL4Jvk6H8qhBmFKlAFA4J?=
 =?us-ascii?Q?V+57mC25nzBDay62IluU+Z3wl7Zca6Jk5cGDvhTP5kvzhrIRo2SjtDDr2H1J?=
 =?us-ascii?Q?eZub1vv4oxnQw2bgcF/KmBd2ppnQkA7B+cK6cl0+hpRf7UmFJxITCT8XJrC/?=
 =?us-ascii?Q?guoWqMLzhMxRUwkC9IQItAafS+3krouB+1ogaeAQnHWCOLRtLWZ+esxv9g2a?=
 =?us-ascii?Q?pUG5HG0Nyj8QlIGyp+YZIWNn6L6XGazLVgeE2ZdYh43Y05CrMgegjFYZXd1m?=
 =?us-ascii?Q?74g9BKNCZ9Vyn0tC//7ySA0PAy1U4RnWG9pr3Q/oKbG5DlH0BP4Trs/jpjNW?=
 =?us-ascii?Q?1vgYMmnkK1+0InluHYeA2F8oQ0CzrBoA5qm1ry79aaYyGGleR4XPZzNIfiNq?=
 =?us-ascii?Q?tJxxYE7LkjlfUVQ3+YPdTgeFwTSRMZMlOWrXkCArCE+uICK9oypwj1lpDFCa?=
 =?us-ascii?Q?5yBwbX9ui8LkQfZpauMKbxlGo/3+3JbxpI1XRZK3LgL8A+Ta5jtwlH5d7eXO?=
 =?us-ascii?Q?5BkShsgZC/D3GWxHV2nlOXdxWtJtU8UNaAbg+ZBuhbxxQORRtCWXCNjVTPZU?=
 =?us-ascii?Q?hE/MpL8dxgQrUOx49DNj4/XEOZK+BUVkf7m2BaXTclmv3aPS5indVGYryOLc?=
 =?us-ascii?Q?uqc80JURXXT9CNgYBC4hWQIIyI4Iq2QebP0y1koJOe4JNYGqNYEScOh3Hkwk?=
 =?us-ascii?Q?XbBKtYe/5TCEUAtJTzasOFMfeFBhnUZwNNRkSfhup8OX2vpnZ+md5+INqATX?=
 =?us-ascii?Q?AVX91QWBBWGGPK5JLrv3Toaw3by6xevXs0xWBaC5JnVHuw39B+nvuZAW5dmt?=
 =?us-ascii?Q?DD7Rvyf6M3MY+xlT3+/jdJgSN7x+65tUlDwKKV07jKsN2TmrmeJV2j/w+LyE?=
 =?us-ascii?Q?vBjvBzunhYAdosB/YsmvOadAKlMnva1PnFZL6GorCT7gkXvwtmxVFu7yFlle?=
 =?us-ascii?Q?2mzeD0etvv81QSeRjIvnXbi1Zg8UhM7YWSuBnAg54894gJyMAyrE+k9qe6JX?=
 =?us-ascii?Q?deD/p2GWwDOPdqv9nz8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cNxWe2H6ufzS/wQgtLLEBq//q4eR4f3/07asHPktelBEw+/DT2Ep0Y8GEjKs?=
 =?us-ascii?Q?74BLH2zd3nBTtB6EMitT/71DBwBuVFC4eI/MvYz5VquJZIy2GwWggvy2YcBd?=
 =?us-ascii?Q?L/HjugLDPZx8lf2xG2gI2hVLUZ7Ryh3WW6rN1Pa4egF18Co8Ej774Pwpo/XT?=
 =?us-ascii?Q?VloEFMyBxVnwW0SyWRffy+EMLhz6ZNXDQZdo+4S347qQT+ezMxka8r6JaNXA?=
 =?us-ascii?Q?tb1eqLyLKs5NJzZBPYo1TUn60PzTbRbbCbWu+Fp5c/y1cg+SC5+M0dA66sm4?=
 =?us-ascii?Q?GLqLfopizoPUpetwvwVa2kRU+qhTY1D104L4J+78f/DgTktnOLaFsNnBoDJd?=
 =?us-ascii?Q?N8LgmFNeUsZP+H+l4+yWOEE4hQAoeLb7314sbI1PAxSU9PaxvipYrHfNSqya?=
 =?us-ascii?Q?PehgQshGX8eMOKWJr6lKDiJMeb9QOAXpuCEv1n3NwQAJBFyl1pJNok4k/Vmk?=
 =?us-ascii?Q?UljdA6RDa0kCDYopjw6QXdhBvfdHMCkLWwhiVY5E+roAqm+kjX0hv16cQeD/?=
 =?us-ascii?Q?U0RyivL/ZABL/zIbabrIHU72UKvQXh8qojzrIoEd8rsfj32S3mHOR/pfNUT7?=
 =?us-ascii?Q?7kOpFmpl6CjTZeA8y3mWOkMz0caKugG7x6GRkWz0e5SBOlMDF3hfg1YPmd66?=
 =?us-ascii?Q?nbXNH5oakqCRxaWgERH18jIwxJlSethiKqnHccjfV7EK9dr0gAJbERkglWck?=
 =?us-ascii?Q?fToEAQ4FaZO0W272bYAXrPpTfKwaYhXEkiZs7EZ3hPDvewgeoTr11DwXlj8o?=
 =?us-ascii?Q?gdGRyE5rWMf5IE5wXog4Lwi6448t1iGz/N1mc72fxtEi1eFM9F+ISBPbwzIO?=
 =?us-ascii?Q?1N0Nb43hcHHHq5mjYmQbun0nrhUmju2rL5fRSMd1aATJ9K52bL9F8Xr6lBN0?=
 =?us-ascii?Q?uf8f4Ip/7nqbsev2/Ud8BIEPpHXxDAYyxaa9V2AcPPemZP56ZAQyDFpBGEHZ?=
 =?us-ascii?Q?GtlSMIaNXZ+92Au6KHJbIBfdGH28eTJ/Egu9nkvyHd42LGOML9xevqhWE12g?=
 =?us-ascii?Q?GS5TcDjbDejtVp6xpdHtCu81l+ehiNlxQ4iK1xYVN/w2TXp2vnHC7kqfR3Vp?=
 =?us-ascii?Q?N2rC0H9/gPT+seKpZ2wm8JcdierV6feML5LpLQrls1PcD7Sl1XDSIxvAdGxq?=
 =?us-ascii?Q?RXkZzF8z4CgoFk6+/Uzn2Gd7bacwELmP1BkNJ5JW0R2xxOkowiRdzY30CTlV?=
 =?us-ascii?Q?ZG/3VIDdIJFtEYlOFP9eV/8iDZvcZSp/3bstRuH7KOEA93BPveIbByCDo1Ce?=
 =?us-ascii?Q?xjKbI5HH6dtA48hf+UkE0ffBNCjbtUp30EG0yS4dhFrCZUjE0D2O1D98vSzi?=
 =?us-ascii?Q?c7kqi8BmKPCl39rMjDB9NnR0WVhUj9jBOSNEowgSO0jDPKt8uLH0u+cnT6G7?=
 =?us-ascii?Q?08RgW/oluBrHJMrXXQA5jjuhPlKsPVF1IzE4oHSOtPB/5T/D9V9Pn42Nct6f?=
 =?us-ascii?Q?P9iUK6lqQPq4e+5dFI0WVkSiKecuY3A03a9Lmf7nVmlO1N39H41NgoFeY3EV?=
 =?us-ascii?Q?5uq8Xy0V4e5Jreu19Rytx2YZ6zND7WP2gbZVLcc23gAzx7nrg/Lw3X8NBWDT?=
 =?us-ascii?Q?McDj9STSdEBddsoVdASZhJSQflk6dbuh90GrmqoiyaNwH0XKpITL0y0iDLQO?=
 =?us-ascii?Q?wjPlyHhsKyqtPRKH6VHdvYD+AJ+vwcTS6f6G4lUiDSDuKH8CyXl08yPiKkQ8?=
 =?us-ascii?Q?7TNuqY28+GHYeDc+z7iGkTz1oXFx4e3E9ujppSftWKj5Fb2cCbUTKP1OHwcm?=
 =?us-ascii?Q?r4aCCuxKzKeO0NbfFUUGot4afjO6VN8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NqBCsBZotuNk+MtYfAT6MBf+A8pwFM0LIkTdU1gqlNVAOOwnsN//YSYvXOhr+A04arkv4b5IlemezHCYz1NeBvCtfvdsJnIWjZUobjGeoYQj5SYuKIEnEWr5whK+y7Z/p1hi9yuztMtGxuMwu/3sgXHkpQlHHCkONN7Xr7ACEM94L+C+zn+YJgKin88zzFqGZwYj7OFNVODvBn1QGXgstRn2GaAB68px0fKe5CmIW9CbMKOvmRhyyQBqcfZELxkpI7dqg9DCh9dJR50KY1TqvL2Jifu6hPqt28gcALohI4NeKzPpdTLEey8mz31ZlTeu9/49WvzDlAh9Kf/RD0r9n9hjhZSWDotkYHHZlX1XH8LFxMHyXQZ5R1BlawQaIFACkzw5619HF91rN7rkAoZioUbwTj6CW/JbSv7wjOzb4uuUFeToCqORqy6wqdfjDRjYzR4k8MuCoKklprQhmCATTPk5Vvggx2IaMNgrwdzB2QJpi2vH0FspMTtoyCIbYW0ThQyznFJlA/U6Ljqb7g1DV65J/I4K9wRF3AXxQ9HIuuFH4ReWyDMSd3TllA+0/aHSGHBqdPN36nNdmid4UNejrIDyPCyR6rgWcltov/CAvE4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f18719-9e97-475b-45aa-08de65429380
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 05:42:55.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVzofuVCHTid/hNqh2+148M+XaZUPMKo2lFrmLDBoSgKd4KnSByueZYXnnsNaFHqc+KKlkdkc7VCucS+Q5QRedpwWg6IGCbLusibZ9AchKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060032
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=69857f64 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8
 a=58K3aHU1H13ipafu-bAA:9 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: ntbhYBid_y1rrQ_vqgBq39mwRnV6JXM0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDAzMiBTYWx0ZWRfX8ioOnC2/Uo+o
 //XRtWFIRoy+oMoaLZpWXfE4bPtGejD5bUhBjT8G3jOx/EtnwwJedwv3rpFMN1zo7Pwq2SnnMwa
 59pDm90mUYSt3CLl/RlDwdtkciSMyHp92inDXtnme0R/msK7ZakIxuLVJArrzTBVug9Myz+BGzb
 PSqOUC6Uyy2tHmVif4ehjFKHE735af7UnMbuIeAACRp06iRLVUEW3sX3kcdzj4kxmanQ2GlBXCH
 kiAc33zfQ3V4OtiZDaZ7RcqELMnPkW7K2X29NJefjlIr9NKrTmhQIaROStsIYxm1r/ZODvRgs3e
 PmwCvKTGKlCiRR15UdS1dw2SgL7b1KYa7mJ/KFZ8twn7VZy1qKNVh6Ej94mDBUO2LcIXe6UT8JF
 XXk+GCp8lqMu/2WgOCkOiCP6kO8MMaeaa1mrGXOwVlNOF/XEN72TkEdGvZYZ52UU12uw3S+0Xo5
 shjIRz9xq50F/xIKNHA==
X-Proofpoint-GUID: ntbhYBid_y1rrQ_vqgBq39mwRnV6JXM0
X-Rspamd-Queue-Id: 32B1F1A0008
X-Stat-Signature: pdsub58gsaermnxzetztnhoc4wppjnqr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770356610-96032
X-HE-Meta: U2FsdGVkX18Q3HWtfhgTYM20hxRkh1GpqVc6t4eiojS/J5g8fDADyXmB1kWXJx2iGXxgEtrpci93am9u81Fozn03FeRaONEFYdz1v1k40FpNJZ5RtpggIKtYLGnjOxg2J+PbFT0DSFaN5kagTMVl0WDjwfVU/P0Qse7pLmq8WH0T3SXEI4PU3jetcXmV2QqLZRVEN59qjy8KQu6mHbrxnaG5W9UkCPJntRgdAler81EuDn5vyqioUe4ZleCrf6q2sCDmIomu1sgqxHfkuU96arGkt9wB0u1hTYg9CkU+Ou+GQCPTYRIee3mbKvurL/EyTBaXHBsx5t4DjQJSYkF+pl6qu6ea157xQWLl9ux/Ab0+rAmwEnMpDNrbjqyDnG7Lu8Ox19icWBjo+4FG8dMaKYs/Tbq7uQsPocd95YdpknQGf9GEoDzRxjbxSxmxbBFP5drJ1SPuMOx+0QHxv9lde1bmcrv4UzhczLgVCkPTi2CJuhwgmRTKAtDe6+A7ewVw2fhrPd4GMvFMC2cMujE/1P4m3Pt/9dVicyW7QS12xHYRK4VqVrpl9WcsmA+KLvpXuwNLN6mX3Ykn0G1yOmNsc/uBuqA1HfYrPqpnNrzuodU45ERmekkTTyP4yKVGXEEiqajxciYjP97+r5Ts0deFsZddxUVBPidp86utKLMM6cUExZdG4bhkcXO6LVUFp5SLIOi/5GSKFAVQdOFGephjOPiwOJJLphW8Z5hV+y1F0QAwxPaEhFrSl37gQPRmD+SMw4MX+l6cCfP6R1YVzA+e5xUJV7aFv9x60Zw8wIq62pcotHlVLrxLtsxs45eFCmF6gcXFfRoRwJYqLt1rOsZMjZeX2av1NotXVQZVIIxxy+FY4tEyROJMcWjyuQRvonN7VL21fC3cGeK+t8xhhWBSQuCy6OXPVKcUiAnogfFn5mK7RSZPrP+9lm5sfeM/9qiHhzgtpgn5Xos0J1XB6rL
 VhT5u/p4
 jNkEoVpiENtQ8+uJ4XvzkpxE8INC0cQtOmRDbelUeNCL9z9LTDRXyvIyk4vq/Zuqn40NUMQcBxLtRTdK0T6ONxX/+K81NqknqfLBYpO9DrIgwGwY/CJ9tlVIpdOdAEdgk9+s38SGB9eDBJjLISSEcOLsVnWdeW2sxgYrVBgjrAth9PX8Z+sRrY6yADT1y3i009hsQrH/2jTKjDKMdUUMWkhwIOa+b95euVVY2dUCDura8eKj7znkiW3XJJyVO48NlAONhO7Mi6STV8M3Qmjdzrzd56DeiO6xwq0o10tNldzmPkG7oq1axkJLQ0wzTuvyU0EoYM0OweMur88u8RjcRYFyk0/31EbIoorSjvW9PPUhYbta5plsefIKWeb2pnZ0gOW1D/T9BKF+3BbIG9lqaKsSD6ZJ1fGNzGnr22r6JZa2bYie29Ac1+TOFIAtGkcq0UIF3HKVudRqdhvgSb2huskbq6B0A9dhU3F8uZPzvdts3IYTjOPGV9kP/Pj+hJXDUvXr/XCOEVYAHzSGnGQDwfTPeNMsZSKPFBf0H2M3RHPqUbceiOAD6nYJFA3+bRfynTofdA2+BemIkKiNuvunhXD2j65Kp9ehm9msVUK/hpExPbIq0+Yeh0mOr3QTxY3MA4vVAIB9JG0mKF8POAtygkLcRmI3+DwIolpoKrAeMXLUdxSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Arm) <david@kernel.org> writes:

> On 2/5/26 06:48, Ankur Arora wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>
>>> On Wed, 4 Feb 2026 22:01:42 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:
>>>
>>>>
>>>> I'm late, maybe this is already upstream.
>>>
>>> It's in mm-unstable.  The second round of MM upstreaming is two weeks hence.
>>>
>>>>
>>>> TBH, without the clamp that looks much more readable here.
>>>
>>> me too.
>>>
>>>>
>>>> Is that cast really required?
>>>
>>> Seems not.  The types for nr_pages are a bit chaotic - u64->long->uint.
>> Yes agreed.
>> The first u64 is because currently struct range only supports that.
>> Then the cast to signed long is because the range can be negative
>> and the clear_contig_highpages() is only done if nr_pages > 0.
>
> That makes sense to me.
>
>> And, the third one is almost certainly unnecessary for any realistic
>> hugepage size but since nr_pages is being truncating, I wanted that
>> to be explicit.
>
> But the non-silent truncation is no better? IOW, it doesn't matter.

I never seem to get them but I thought we had some kconfig option that
makes gcc give a warning to that effect.

I can update this patch to just implicitly truncate.

> You could just make clear_contig_highpages() consume an unsigned long ...

Unfortunately that'll be an even bigger mess. The clear_contig_highpages()
version in mm-stable uses the unsigned intness of nr_pages all over:

  static void clear_contig_highpages(struct page *page, unsigned long addr,
				   unsigned int nr_pages)
  {
	unsigned int i, count;
	/*
	 * When clearing we want to operate on the largest extent possible to
	 * allow for architecture specific extent based optimizations.
	 *
	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
	 * clear_pages()), do not call cond_resched(), limit the unit size when
	 * running under non-preemptible scheduling models.
	 */
	const unsigned int unit = preempt_model_preemptible() ?
				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;

	might_sleep();

	for (i = 0; i < nr_pages; i += count) {
		cond_resched();

		count = min(unit, nr_pages - i);
		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
	}
  }

Thanks
--
ankur

