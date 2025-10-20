Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C80ACCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0168E0008; Mon, 20 Oct 2025 09:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651268E0002; Mon, 20 Oct 2025 09:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518CC8E0008; Mon, 20 Oct 2025 09:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D23F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:51:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02D18140164
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:51:46 +0000 (UTC)
X-FDA: 84018630654.15.0A04145
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 96EF280017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:51:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U6mqzuJB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="XU4v5k/Z";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760968303; a=rsa-sha256;
	cv=pass;
	b=WA3lzbCUzsX+Uihjz4EE0tUv/sC2z9EuI123kGeaDiva+Rmy2NmividRIfgXVlrcX0RNUw
	sML0K9SDlAeqoysEMQC18BI9Bbvbr+c8PXk6RcUvWFBbbcxFWkr9VGc6f9eqaSicx76Cjh
	7pN0grGP91sTb+JVvi/nmkYC/nH/yrE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U6mqzuJB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="XU4v5k/Z";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+Gx9bLBa8BMRhXWtgj7Zpn1QSkyV2WiSpffAbOwUnE=;
	b=hh/be+7y9y/MSlTO5J/ojZLqBtS5BJOuJT2Ohlr0oJyaOaa3Fod+aorbcDr2noqZ5RGWNe
	zWYSvzyJFmPTd+ygf+Ao76Likf5SahdN5UJkEzokdvRAHCemQ90+MkaCwPP/+4B6WCGsRL
	b31LRgiSu2bYygwFoeyOasLAxJvBbvA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8RqTs013815;
	Mon, 20 Oct 2025 13:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=c+Gx9bLBa8BMRhXWtg
	j7Zpn1QSkyV2WiSpffAbOwUnE=; b=U6mqzuJBZIi2x4LpVrbjyX8ZvS9femG5c3
	CDPLjTfYXmXniMyJYy1vDNvdyAZ5X5Hs5RUCeLZ31EJHwYEi26o8UVH5EoH88x2k
	kAVD7Q/U+dBNTchXXfjYlTODTShpfPoNHiCRM1kqtKjSo62LPeaIBiwtElY6ljKL
	ebfsz0fOpTPXmz137AiVkee8Bmnw4ICljyj//N37EjIRYDTMX6aLmQ73Iyj7f7ov
	zdKFwfh9E4/8T9Sxwh8soLZtfu6uohSdkiyd4HNgYG1aMG2rgmhvwAJPk23rIYnR
	c0SXOpeDuERQ5mZ+IivCdOHdxLtMvW+xieTGORIEFwD6QEoUMg/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdh86g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:51:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KB5Ppj013705;
	Mon, 20 Oct 2025 13:51:39 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bapu9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:51:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xF/3CU5MZOdLFpYfkeNO+MeeXqLxUJcsxuAfEuezLGu4Yaiqm6RhJ5KEMzsavs6KD2SyljxPa8Jmn95DxTt5xW3MKu0zS6XOmXcj9TJhgDZF6FUS5b68/4VVRGDh83s5IkbRyXj6ICn8Qd6kNXFalBpZOaNj6XYUMF85IeGtALGcNZoWMj7iNbj7sA1ONGLZFqZm0IvPD9802cKk51kp1q4uN3vlxidgEY2+IW6uQTirHgp54rk2tFexrs+JDL+YGQXxWdLHumQJEnHM0uUleZJdzaDVEissdHRv3/5BTW3kt+Rz5KkNsR0FHEoAtMWEbIhJt/y8g/YAwZ/iyUXROg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+Gx9bLBa8BMRhXWtgj7Zpn1QSkyV2WiSpffAbOwUnE=;
 b=jLhbtPXWf9BCBh2KUaDfNG0h4xsEZaQ37liiq2mLXh2ft1q79JnU2jDv6LJ3/dRGJnMWoJfLYchBe6vieg2S6BCg/khRtt4WR5owJmCeT1JZYasI4PklkNpKSjT6MMLjQIu6x/J5Dnentr4sX9uHPfbgSxo8MaDPPc6MRszXhEmnVyWNywn7wQFKNTjfRums9lo5YJg7BngP9oXzL1eVpboC4g8VuK+6BpoHHYL5noJMz8jBEXg04gl0TrRAA/HziJIOqRdUvtgBtQLAXFZyeDC7p3FwJiAPV1g7D0wEVz5j4FwlzcMCrqjTqXUxKu8wAHPZRr2bcZ12zlces6jD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+Gx9bLBa8BMRhXWtgj7Zpn1QSkyV2WiSpffAbOwUnE=;
 b=XU4v5k/ZaPY0cTgp5MluDzPKp3Jrw25sgXFMh3Q4qtNjS0y2Mk8lhYmQsDTJZ1Us4Un61w8+Gko7fA8JJrgByn7Kg8oCnnVdPnAQBUiMdG+NRhVnOGOPibLu6O63sOsU62+chSmRZRrp3yYNi+DBmleb1qBhYmSTyULvN0hJGe4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB7066.namprd10.prod.outlook.com (2603:10b6:8:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.15; Mon, 20 Oct
 2025 13:51:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 13:51:35 +0000
Date: Mon, 20 Oct 2025 22:51:28 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
Message-ID: <aPY-YE2Y9W1YHu6Q@hyeyoo>
References: <20251019072509.9488-2-harry.yoo@oracle.com>
 <20251019220737.1431-1-sj@kernel.org>
 <aPXoJWM8oC-P1a0q@hyeyoo>
 <8d25f625-2588-4b56-bd7c-355a2df09442@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d25f625-2588-4b56-bd7c-355a2df09442@redhat.com>
X-ClientProxiedBy: SEWP216CA0049.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bd::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: b379631d-0c43-475d-ddbe-08de0fdfc894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VWJ1qKfXQabDyilTeG3pTauSeiNl2RBwQ99QC7fK71XZisF1bI5IR5vWLsoo?=
 =?us-ascii?Q?vm9kPk3fgJY3ZLmOKl0ysU8/ynnzrIhElL6GEPgceB1V6+tdWiRZYmmjRTra?=
 =?us-ascii?Q?vodMhhwjz/A3pxyncOftypHHrepygJDS242reQhmWlWI3q2gYDbe/8ZuwJUF?=
 =?us-ascii?Q?aVVBEI4OCr1vLU+xoCGUmxKnZEWQ2QIN7e9cr6sB/H7WH3vL+XzJTxTDU4NY?=
 =?us-ascii?Q?n8oJToGwDyaf/pI3HWBdqWQRAeL1crn3mC/H10bBYDkGB04zmXfyY2BNYGML?=
 =?us-ascii?Q?MnDJmpz/ljhrsCBWy1VbAgv0tGEYjwznNAsKup1fY3Ksyze6AE1NoTYVFt7Y?=
 =?us-ascii?Q?pOdsdUCcG3tQtJ0KWgtVSNd0c2jBVhk0L1WzvHk9jnTS0339jcw5QaLhJtkI?=
 =?us-ascii?Q?A2lBHsd8uH+4EsFPTK4MZrGwzbAAsopzql9yImLRiej303vACtvOx4whhhfs?=
 =?us-ascii?Q?cd9uaKcxZ5BmUwimBRi5LgpXzoudWKhmhlYat3iuyC8soWkEVWFvM5VZkuu+?=
 =?us-ascii?Q?S5nBJtfD+GukTq6xPbbbjV0tV6b7eXfj7wWKVOpEyEF3BpuQ6PseCpPjfsgf?=
 =?us-ascii?Q?121T+9z6KjrkAHVHhFrxrzLxkYKthOLfyi5a1EIR4bxRg6U8GBbqMAruVlVp?=
 =?us-ascii?Q?69XDqcwS7ABTB/Wm3acN41zJk1G5oNavNKFHUdw73hTUHh7giJY3fn3OdFaO?=
 =?us-ascii?Q?/UZN+9kTU4TVZrCayM4VjbkiR8bzbUs97e6+Sh4P1OHHaBwbB945vuj3JSir?=
 =?us-ascii?Q?xf4cnO/mrVNgdY8iQ+O81IrKyBb4SWSSBdPMGPvhL1du2+2fZd9ojkl2M1gJ?=
 =?us-ascii?Q?oBu6YPB06KS7RLL9NZ6300N/iqVQkRPXhRoukRX2euZT006rWP/AuxnlKMIp?=
 =?us-ascii?Q?ORQ9QgVc5hxqoCFpnr6GbiQiCUcYJxH75VgOGzzYR4jtgpswaigKzCzSBeAC?=
 =?us-ascii?Q?3deNTTSTMTKPvmIQDzKT7ag5FjN5ZcPmMwXozqb9HbKowy0oWYAV+hbu2/Tz?=
 =?us-ascii?Q?SeroZchQgZk1+dSYzFcYXRVu36DfvPZDpAsYL4jkiSOnDD9Ec8J4nXqoR+km?=
 =?us-ascii?Q?Yg9puF8gQLbVz2GWzcVCg+jjQR/1cymkVgH/PKbpIB1V6PRwCiMfTY342Fo9?=
 =?us-ascii?Q?DYSALAQEnPyDCDf+TXX6Xx4+NqR8NSgg7e7WhkKzS7u7oyTzZUIGNbji0CLI?=
 =?us-ascii?Q?x6CuSL18FBSg60/daWLpqKC1Jd5jaxDr4w18CnfloKgJ8YL5SqU1yZPrifdE?=
 =?us-ascii?Q?tMVevmip0/MuEgZnL5IOfT1Fe31IcOZTvQ1iBdzAl5UhBbRKEY8GLUoRAYM9?=
 =?us-ascii?Q?HnjhqmGOBs2N2KKBUsQvh0o6IxNBZ3zay9uQbYK3XzhievNBI7YJVYNA6N/N?=
 =?us-ascii?Q?OTsJWlDzXGngRsSD8+MnwtHCt12TG4cQdM+SMm7UftJ1ChUWtAPTKtkURIyG?=
 =?us-ascii?Q?dDDexacL8lhfLuXkRCuI8zfo573/DjEU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WSYtG3sxFWr0Fs+nsOZvpBL1BpAwkaz9TLCHri1XbZHIB6oJ9pD9fz8ST5g4?=
 =?us-ascii?Q?Mhw+WYegobOrbBKvgcHnbGmbkojzFoOexA+W34i484nKp8glQBk8DQ7MEnwQ?=
 =?us-ascii?Q?PGl2qmIn8rhBTp5eNBT6hcEEfoSnBTHP2YzlI0rPwcqDFuihR1kbyYaGIRf9?=
 =?us-ascii?Q?oohBSDbRZ/G0cyK1DFFoo89hvuQTjquQ5IoKSzxhG5a00UNOdTSqSfhPUxiC?=
 =?us-ascii?Q?/COjUkBtuemYD2vm1jrgBTPWk+EsooxZAt8acviXGqCvwVMtV0Viz613NX/2?=
 =?us-ascii?Q?n7xeXCKWMq4W64bUSGwiR7j+1eiWSXp4XPoKe01+P5Oh+kPTFc4Rh+oiW0KR?=
 =?us-ascii?Q?Rr3qr/G29magskLD7ndZ3ioU6V1HnLyjGtbUHhyYM14Au9ollU53jS0f3d1e?=
 =?us-ascii?Q?ghvxhBPtRPmfyGB/W5ZPxpzOGYrk2befq/yw5Ny5V/VtfZCa2/pZ0/jmZToP?=
 =?us-ascii?Q?NQYH2HKwrVCRE0T4xze9EIFHTGQqf/AXvDlE5j9ZUNZPi0tV16qy5dYX5fLP?=
 =?us-ascii?Q?AGgFCjnVmp7n6+/fln12ZUANkg5ogciuLNN6fQAtnC9FqdG64SKVy0Outtxc?=
 =?us-ascii?Q?eucoriy0+YQeApBRVS8d2jGxoRP0rnx1/ycG9DVNBQ3/P1Hw43YJRR++tnh8?=
 =?us-ascii?Q?LGqcYnVCvt9r4HVVyAlP1pqqSXpClZxgiybP3oOzTumVTEXVX0leqNvSuDCg?=
 =?us-ascii?Q?4er2fJdxf7fjuMLzxQ02RbmQWycNYjCkjx274NbazTelL4nBW+BnBE//kKpI?=
 =?us-ascii?Q?0TnLk0cOVj1N5N6UpNgPcL0pyImm0oHT79T91v2XRUD/379UZ/J/crAquJ38?=
 =?us-ascii?Q?RXIy6gvWJPYmXnCgW1gJyqGoGE26HI+ed8dDvlxlUCELQE7Af2ygi4fyCNyV?=
 =?us-ascii?Q?uO3oTWgMQ4dLbjIp4YIx4dWd5myWxoJqqr287wIQPep8Ld1csvko1e3YlbsV?=
 =?us-ascii?Q?9k42jKzh9GsL4KMClH6ud6MUcknPmsZTYf3Wx4rdVr79u2D5RIFFsM9qWkZ0?=
 =?us-ascii?Q?8wcy7R4BFlI4ARnQxSXp0z/VL/qPt/0gslZ2QMJUCmKXj27xqVv5qp/zvwOr?=
 =?us-ascii?Q?H+caB5RbK+TTvBanyvcW8qvQD+5S6+qExkanKW5OMi36eDRp1vguQqF865FT?=
 =?us-ascii?Q?sUqYOjtiBCXv2rSlx/GjYdz5xWTghiGiVXtNDJ+8/ADTsDYMF0pdJY3VxZLG?=
 =?us-ascii?Q?Z68n8PGFhXmDDseMYS/ZC1Ztkxu8DxUBD0IDrZN1tPXfD7Cq4WMp+oWpUWbH?=
 =?us-ascii?Q?MVN5b6g1G14i7TS9e6Y0jOKcAZ34SunBOLqRnDC72pA84B0fG12IwWdpoRNb?=
 =?us-ascii?Q?uCpwxjdsgOUhGGSlcjg0jb08oHinVkfDMrwQGwt0HMg60GSdjSuGcApHigmr?=
 =?us-ascii?Q?NQCjaLhDxaPrS2/kfnSQjcVzXr/O8X1O8QswBNT0d+jEo9v9BvcLYu4HdtAP?=
 =?us-ascii?Q?H3s6l476gK/rqB0BWG8qrld3xBQpsJss2Lx8O/wZagc9oNwX4UGHL6JTxz9D?=
 =?us-ascii?Q?bVwDYknK4ZVdLkDFPxYYKqVYIi8sbZ6mQ01VU96Xhottui5sjyMbQPYFFr2y?=
 =?us-ascii?Q?7GxSExc6UCRMB3IsGvt0reBOHQMAlv5iQtcFaXNz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E4tRhBHrEh+5ox8J9INdLiRVmBFeFm+LOaC0MUKY2jNJVoNfow4ZSFwNalN4WeoYqvef+/PsMl5pBfhkI7Gak0I2wGLGFKWkCG5Pfx/T/3u8omNhZWdSuMidGurzpieNiCmrd6ZUq/rsuKcb8yhgQNMwhrj6P5buGvTOdHH5s4w6LCrJOyOU7iFoLG/jlysWCuQJl+XT+eNOckxCpCdkO03AKqDzDN8FROVbK9aNkNgx1wWHSUvBkZ5L134wa/JKFNX+geEA3rOi1S0IBV61x3HFl7PsJ5TZNSCXDdfpneLnzZ4oApMKr/fvcACS34gjCa1ATwC+joggyfLNYneUAinQgLA8XzU7FW8gVqf1pO0s1Nw6Z6FXIakA56julCVjllwy+u7gZdQCQyLZLAtZWyNoJr7paAOJ16IGKZ8bDDSUCkms0Y2GKEvbdUtTIqy3jE1BIHF8V3zSNt5OsM2ANAtbbFRM/ygRgsA1v6HMmCChwyYCTvZc5HZgOHhRpUN0B+hyBIUNkFAL7xvvAZI+m0A3W8zAVMFuynbrzMbY4SnaFruCETXTAeeZkYI/9xk0wpska0zVlyPt9aP6yZLdDXFN4xtzlUNtlBAUKnwzA/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b379631d-0c43-475d-ddbe-08de0fdfc894
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:51:35.5748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAEOvWcKVr+04YtG6XCXCfaifkmPd3iGNpPY6sL/7/hs9kI3tNmhwfmNX6yZ/B4tm0+dDdo47JhcisHcHSWXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200115
X-Proofpoint-GUID: wBtiUpjZOt_GE8u92qRAq4QpLX3vavmG
X-Proofpoint-ORIG-GUID: wBtiUpjZOt_GE8u92qRAq4QpLX3vavmG
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f63e6b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=bFmzGDjBMXGrHXvLDWkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX16rCv8yx0dkr
 IEtIBVyE+a3HGUkalCADTa7R5PN4F9/qXEcedANQWBP8GSsfLMp2J8rp8jQAk8BkraMp54Mx3GN
 PS0xymJzdc0Be9eMkPBga0BqpJ55zhjMPYEKQE1d5TOLdO8yBdp/ip2s8hXyII65qcnPsMpXXz8
 6aH0RrJuP22j1EQKs0mtNPirJXwXjLkfbvEsAelrGnro5FscIzZ/Pp2Eo7V2GU02bln7py7FNXa
 Dg5AAuuKNxF4e57+rCJaf/5kbqpHVFRnQjqQnnFInp+XOBgJA4rssQ3pt/XTETEu8OZH8iVBFPv
 Qvz2+U6HudOhlxMMhPyIDJtdbovhHa4GAf+UoaEBsM0xI9sIykQqcmcZDemCI1yTRlhMWCOZN8x
 sdnQ7XaWcm44YafYOOiw8r9TVhPzlA==
X-Rspam-User: 
X-Stat-Signature: c1dq96bmet1z8pd1ehoncrpkkprah6z5
X-Rspamd-Queue-Id: 96EF280017
X-Rspamd-Server: rspam09
X-HE-Tag: 1760968303-865825
X-HE-Meta: U2FsdGVkX19LDs4KKHnJy+2dVkVu7H0md+QzP07Kmj0iZborUOICDKAuOaGNgFZX/qDB8HITWLYeDzVEThPh7rS3GeH59+nBnXlptziUYHl2wZQ3556ZYy+ON+zp1VBttNtFCSEgN7colUC4tB25s9NJj0XIPJdRy+ga+tZCjpOWI1BW+V1RXQw/H7XaeA0UjLyVDYrSBPmWNksHRLwTLWLUxOq52Rcor2Qq/XeJkdu/d/Ftaac8KMfJbNA5EdrPKUziGarch2MoW1J0Pb51ZA8r+ok2Q8LmQw9qmpHuYK6i2CyfXyIswucTmFQqz65v5oUWzPtJfr0yOyfck9cZHdpQ+PVhzis22oGYQhQQ6iiGVpJlb6Jh8+jN1DEFvWGQaVwtc58CZO0ix0Ty8gsiV/3Q+ZgksvfzWif/MwrE+3WxBSwWl+EPRPzzr6UFeALxOM7JS93OwpyaWK3LZ1rEYZye5n+KZt5f//P4O1lqJRN0zM5N6Def6J39QiM8YcqJM5BOD4TYIkylC49HuS/dvxaMQfyL4xqHLY718POqZLAILmF5CQ/iDrN4PS6JnYx6Ex48rXahEdYMChqHJN4IdHRKHWUbVosG4ttMaFS/4oxuDHw/yKm3fJhwWGkPavIoM/K1yS7rlkccS2GK9QR4UFC5ehwTtnTKPBd3sjDPZ77xwCHTt48rCMoBuumHjYUMH6mPZe+UtzJNQd7FmPVCLCqOzExEt249Iq6xplSbA7RDuMCBz0XXgIfIWzz6wLu0lJqyuJ4tKS8SlsSxuNastO8X13XrgSLTnxFjac6WNDVf0q7sOIjPBbFq2t9ED1Mo0dvSggOQvtTLgt3KzqTv6T3FX+rLzziJ3ywo5PMSotuO/t5RoiJqBI5lCJmOjnYenwMpLOG16PuTDHeXKo7TD69k0EVCbpk2zZSJxS+6IUYDUQyvhHmj0jgLpC44QbQSYbGaYllzIoIiF2QtlVH
 pdcziBIT
 Bm3YjMEqx8h0u3/69HPbKvsVBd9BSvZ5CedFkfQaKkerAh+YOehidjJAidKvBp35nmqm34BRXnNRc7u+1oxL3Ews8LEOVwTKAn6za3O9l8382uUIWMnerW51AZxDd8VKvbTAytisCGefPEkUg3o0i2Tsd34WDhxMljWMo3E2F5V20OyJC7QfaHuBOhP+ah6aaMI6FH3zL+QDV448JgpHxzc2vM6/FBUvHswOezKVH9twS09q9Fmcc06kWUUxtgNtt/g1QG7ui9kqgW021O5A2+L21tINdsBe0LFPZU5G7jfnxk89KMHJ72qqyMqL8ChysuKS+gnrt1Ue42pXvkXhOCelwotlYHGzUmb29SOykWh6i/znHbHBsv/rVh+mOeQJWhCE9B4EnE3oV18YioJ2CHxXbSys5vfnZLt/OGAH006ryFVjgyd6+Xk66EeJLvm/Gbe7vTg1yP6JspV4gVrlAsieAA+tuCJKeq8yzUvpoBfpeOF/9DnjP+7KK9ojp0tXGyOIeDDTWhXJvwNYxhx9Nbk4A8tjW44qaCUVpX36FDjct/+lcZbjCuLlDlaXRdZMUiW1UIvl1imebiHSh2xbdrVaMCGVhFyefkKHMkHb+FHuGd7EswCru/4aLs49SCLdEfMGKipeM7iLURFo4cMakL8IFIlsVAXT0Q1fNEt9tzHQSMstsM6qVJqAN9jfRbZL//5E8irVCC6J8Npo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:38:50PM +0200, David Hildenbrand wrote:
> On 20.10.25 09:43, Harry Yoo wrote:
> > On Sun, Oct 19, 2025 at 03:07:36PM -0700, SeongJae Park wrote:
> > > On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
> > > 
> > > > Since include/linux/pgtable.h is already listed in the MM CORE section,
> > > > add it to the section as well to keep it maintained by the appropriate
> > > > maintainers.
> > > > 
> > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > 
> > > Acked-by: SeongJae Park <sj@kernel.org>
> > 
> > Thanks!
> > 
> > > > ---
> > > >   MAINTAINERS | 1 +
> > > >   1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 46126ce2f968..dedb9525c2bc 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
> > > >   F:	include/linux/mmu_notifier.h
> > > >   F:	include/linux/pagewalk.h
> > > >   F:	include/linux/pgtable.h
> > > > +F:	include/linux/pgalloc.h
> > > 
> > > Nit.  Should we alphabetically sort?
> > 
> > TBH I have no idea.
> > 
> > I thought only subsystem names should be alphabetically sorted?
> 
> I think we usually try to sort alphabetically here.

Thank you SJ and David, I'll sort it and resend in few days
(unless Andrew prefers to adjust it)

> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Cheers,
Harry / Hyeonggon

