Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB58CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 13:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C00C8E0007; Thu, 11 Sep 2025 09:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870248E0001; Thu, 11 Sep 2025 09:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738998E0007; Thu, 11 Sep 2025 09:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A77A8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:48:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0087A1DE023
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:48:31 +0000 (UTC)
X-FDA: 83877099222.03.A17F1C2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 56EC240004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:48:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A+mUHSYt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ihGd3EpS;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757598508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WG/e2rMBWkyZexWxD5D+SyEk71uXhAoD20xrliCMsQ=;
	b=Qo/qR20RuGxzLlvaheIjp5E4C+G28jkwsLiwT6CkCln/s5L17pviwOWqHfL1bPWGKAV1zI
	JRFNkuvtVWtZb+ZQemzoeIt3cmvG3nxXRIHMQu3JUOqrWHeRP6IGsC1c1O35ZcOGabrKHz
	oxf0QTSxyxnnonVgZETf96ML3kV4psU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757598508; a=rsa-sha256;
	cv=pass;
	b=kHnoe1GJRBybNubA8+v4Kctp+9M2dvlkCd0R7rx8CphVseJRGVcqfLOqppUlUwUcE22Xw0
	G0eGFtEHw7gG5uh/C+czDArD7X/GM3rFynj4Rzx6BtHQioSRquT9PBWO+fKNuySUSkN5Rd
	mXfFX3RdAVc6q2aI2vOFAt39KWmd34k=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A+mUHSYt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ihGd3EpS;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDdXiJ031938;
	Thu, 11 Sep 2025 13:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5WG/e2rMBWkyZexWxD
	5D+SyEk71uXhAoD20xrliCMsQ=; b=A+mUHSYtryuP97HDOEVl7pbfkctBKRdI9l
	OPGZvQxTfeaBe+GAb4J6Zg/AW7iswImvlHEvgfWAaR/ax9Y60O0HylNJhjZwy7zJ
	rtck8lctypP47we4O89FyaK2OHqJZ39QTcO//4ZSedqbsqC2VGcAqdDqmkOf4htY
	zN4HNhDmJkAiv4wcvmHpX2xDBI+tx/fhe9IhYamDLXGPno3FXtF1u6mjqIQ/wTJY
	7y0fobAVOrdbC1y8lmkZDyv7H126d5JtBh3dcnRH/Ka25SqvOWiTvroFBKPYp9Ih
	VbZRvoM2/jpFSXiPUIfYDIncyYgJD5QFvmbNLIyOHJnbGGgKHbHw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x968e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:47:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDHDXL002779;
	Thu, 11 Sep 2025 13:47:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdk0jqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:47:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkv78dzCs3PGGkuggR4b3nhfvg+t3uMzka68b7WWbdzPA+7XpNHIansZ75kGkVDIMNJ4ON2SLhWEDcCk/spTHaKrJEWbfMzUA9hW/60c9bTMJv6216Rm/5La8C7fTk1GniE9cvPt9g6zMBxMDF3bgMJTAY98tDrI49NOuEOKGvTnhS1S1QlAFI3iJhUkgd86Nhhisk1BA5xpEtQirtZxsTMAtbb6cqao0ljZ0zq85LXDQToZQrB+N3uzlIZ1Eif1/eslUvkg0OnhbKgu2ALIEqXkaoftJ+D73uPASD+ktx9izrDRJjj/RL7sSk64uRNU/0cZi89gkcV6dUClFQ03FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WG/e2rMBWkyZexWxD5D+SyEk71uXhAoD20xrliCMsQ=;
 b=U+tbCF1YREDSsFKhU2q198Yet3eEzf5/BJW31CLyN0wbjVrtr3kdpGSuNmUaVbalFfRdbfNGuPTfIT4+JgacjblAZtCkUNZCjuJM2cQg53hN5/GhGfnLoDJi1qaZF8NYZ3ySNNg2IBVXOg+cd1+JajSdGCPHPfwahtfJcgX0/RyhG2P+cfJSjOv8WVJ1OCRgdIcfQ9+uTjiQaC6G93NHFrtyD9LKyIApIL+NkSrLIZL4j8TN3E0U8ZKIAoKPUmH1THz2VUUUw2cPQ9/IRQNNlzbd/n11zhXLLZJt0wmnpe3uFdFE1rqklGUcqVbD00rOIH1MfvmTs832YkhXp+eRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WG/e2rMBWkyZexWxD5D+SyEk71uXhAoD20xrliCMsQ=;
 b=ihGd3EpSiEkC0IHoI4tL5Pv7AQZ8aY6YTTBHYp3mIuPKjhEsPZxsGPeTdDsddIBrLC8mQZ/JV+dyhgXQV02L2IsvThk19eE58/sAOz7T6RITJSprHEkA8VhMLtT8ct2+2rhr0NBWl6hbwTFVmHz7FvSghIiYLLS3Z0otKzEabPg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 13:47:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 13:47:51 +0000
Date: Thu, 11 Sep 2025 14:47:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, Yafang Shao <laoar.shao@gmail.com>,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        Lance Yang <ioworker0@gmail.com>, akpm@linux-foundation.org,
        gutierrez.asier@huawei-partners.com, rientjes@google.com,
        andrii@kernel.org, david@redhat.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ameryhung@gmail.com, ryan.roberts@arm.com,
        usamaarif642@gmail.com, willy@infradead.org, corbet@lwn.net,
        npache@redhat.com, dev.jain@arm.com, 21cnbao@gmail.com,
        shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Message-ID: <7d4548ce-e381-47fe-8bb3-5ea38a172527@lucifer.local>
References: <20250910024447.64788-2-laoar.shao@gmail.com>
 <202509110109.PSgSHb31-lkp@intel.com>
 <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev>
 <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
X-ClientProxiedBy: LO2P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: 75df47c7-cddb-44aa-f2b9-08ddf139ccf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?trQ0TWp6qEB386xD9jWx6V3rQV6YpcGgK21EUULSEVRR7N5TkJRKoSy/iDqn?=
 =?us-ascii?Q?5cHOp7qfgdPHBaLf0tOFGULCkZnth4F+QjR6cJWeA8Ic17/oCLwIbIuZiLu3?=
 =?us-ascii?Q?/c1sOfWoURXhEAWo1BGqOg0JPOSPdJhN0XFXGpWRdrzxAiq2dvaHNH0qAcbc?=
 =?us-ascii?Q?abY/vRZKQ3eRyHVgodEO6D/JX0x4zOGNWoi/DuJWrIb8ZEZMgJPvq6KPO11s?=
 =?us-ascii?Q?LkI8/Gp8Xk1X7tY2AIO0OIV2hmn+nhtUmGy3hc9s6Zvtw54gKU6hVCyYCWo0?=
 =?us-ascii?Q?UhROF1dVpGeKZEYjxpmWJaVFAMVfCsVczqs7b2qT5NonhDOrT69FypvbK8kd?=
 =?us-ascii?Q?OQ1qefOgWEWw5NxZ8P2IAcYyQ6+KGYv3E1uR3NClNnc8U0AgA4ycyUBAioAq?=
 =?us-ascii?Q?4b8S8eOeA0E9aBjEWZKpGA948B58fVex2+pfcokITQZcpRMG8Kl3wAQp9/DP?=
 =?us-ascii?Q?vpatSgzbsXD8Hr57hcFOOdkjvkcCFBIasbwov7GzlhaWweIK2jHorUzNLYUa?=
 =?us-ascii?Q?foGWwE1EYx4BhhLDls5ARpePMtFy0ezdS6lcVVdkpSQ5aGFzR6uDBp50chPO?=
 =?us-ascii?Q?Pu/D0VOb0PMkXdLaLh6zIKilbIE6Covyo8xXjD0QmAzOTlYHln3bU4qilrbp?=
 =?us-ascii?Q?Tx4sFcwcuhrWw5OCRxeAT43QNVaabYTzQXfwt7riHii97n890OOwIVwMXxMy?=
 =?us-ascii?Q?mVl5b9zxbMmFsPXZJc+36jv+o1rFoIdXKBXGepilCxRPEdlHM31ifEC5V0k1?=
 =?us-ascii?Q?qK984qRAPR0pX38o/g7LHfgHsO6+rfWOVpjnVubBBFJ5F9Z2q3Hvcar4uXLG?=
 =?us-ascii?Q?hdCoI1g7hqgQDU+k/YDSP1JraOmYJ/HAtJ0/QzsKrM7RfaF4eZ9g0J1PIpky?=
 =?us-ascii?Q?E29rquaWhD7lWACNuj7HdQiV2jjDNl186s1j3Lpo2Pu4KVsLmSLu7fVmWCKR?=
 =?us-ascii?Q?cWOsHoNAjffCyE+2opt6eL1+zKGAnfjB/+gFmxfflMV+XMwYhXj9lP+EbMmI?=
 =?us-ascii?Q?pk/+JnIkxE/XOZpENhYXxSCLMa4uP2cfngYaX6g/Wlo3YSQYZGWlwtMpc2wm?=
 =?us-ascii?Q?EylABn/h1oyS4hku4YfP8l9Ys0l9iwp5DZjx8Qi65f848HwcXSQPFGR9uGsZ?=
 =?us-ascii?Q?0c5rFZueSHakkTIw1CsoSlesGrCs1JtR/nHrJnxNmgCODr7+GEjZHP04Fu3Z?=
 =?us-ascii?Q?gwNodLtRIKHj71ktlcluEBjjdjw8wsPzf4+noicPQzqTKQIP/AHpu3S828Pj?=
 =?us-ascii?Q?fV8vgf6NjPoS5Al3pAKccXbNucWJyLUgczu1r45VHOzN6WsU5Ev+Fu+LR31W?=
 =?us-ascii?Q?Q0GXlNHuOfL3Yp+mPz5h587LF8YXPzUdqolTyRgJC/oK9TQFEgcMr5Munw+J?=
 =?us-ascii?Q?bM96V4K/DjcpXnhzZHEQX6iUb+sv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pns78xNJmC5XItV8P2/7cmSgNZfBz10QsoJVoFPZ0Ah9Yx+xQlAQr7CJLKOS?=
 =?us-ascii?Q?iYfUcCKJs6NBaqtzDh0IYtpbBt+0t1SxkeSLkMsriIdKGdUiuHATCPveaHEc?=
 =?us-ascii?Q?ne5/AzPt++Ty1WBtibmXXZ8y7JbTYgD+LmfDarDe1fhO/NCCACFFrvi+3QM8?=
 =?us-ascii?Q?uzwG86T/wLoCzcci4Q73LcQxGvuQPzmCmqF/TFhAKVcfZyzyziy5TEURDfCv?=
 =?us-ascii?Q?y6kTdj9zQ7/HLIVS6y7TSElPP2sI0dqyqz/yhFSURXpFUeeoN+FoOVVZAdzA?=
 =?us-ascii?Q?yujxAJ4c4ZPDEYinpip+YrUUdRPC036vNM8fC8RKn1hvEXPs7RF5rIyagikf?=
 =?us-ascii?Q?65TP4xnbkYBxujw2tXFMYbopHd39JgLHiDIMdiVUTaFuwakI3yri5Yhm+0Ip?=
 =?us-ascii?Q?qeKdap2tx/TQ33hPp5jtjIfcamrgH8DJuD8Mvl0BdPKTSXd2tMBdnTYH+j2O?=
 =?us-ascii?Q?/FM3ePJTjQbLG9i0Ba9p6OiEgfb/AtGqlttX2+qNzdSN8xXXA64ff4x6gmqN?=
 =?us-ascii?Q?dqb+jD7pN/HLi6CN2Lswcbtyx1IVAtZC1QzbT6IQoF3YrL+kPka8j8/MjdFH?=
 =?us-ascii?Q?sO+T0PYMrqCkwzvRHTMZdAcmNetiMvblkzDFnGHjAxNgl11ZaGngOLtDALRd?=
 =?us-ascii?Q?Hs/N5tJkullulw5JtfRDM6SSTPiu+oKAf0Zv/e/pgVm9mexKXJkZaEJx8ts8?=
 =?us-ascii?Q?F7QkAGdZ4wTZGWqfaXc07LG37oJ07GxZJIMB6yaNIMarMHDNgA+/v36VVnNc?=
 =?us-ascii?Q?5oswAOyFwxyfSdGqtImlxIFx6aSvVua6Nvw5SizxH01ZhKmuwOj+b+KrB8ti?=
 =?us-ascii?Q?qIljIuzGFsp3tKmDXqxhBBrd8vS8JPUlm7/9hwWYWh4cVZ4ggJTdlMJou6B0?=
 =?us-ascii?Q?k5+bdGXVnQWUVU/3+PHvj5YuFOIG2JL+bjDiu1nzEFgsVdoviqj+R+XHPcB1?=
 =?us-ascii?Q?H06vYCA9jGCCoh/wgtnNZdal98MeqM6FVoAiQWvo2IDW/uC0/SCvXPCu1OC3?=
 =?us-ascii?Q?q1N5vajOwnCGih8vcOtxp/HhtOBZTK0MtZXhZdM+TNdvfaELWXSURZ6I1FVM?=
 =?us-ascii?Q?3Rc5jihBAspl4I+I7+3TFH/RSMsU958TDy/ODajCmXwC5srTIdd+qS7NfOZC?=
 =?us-ascii?Q?9Tr64+AXvx0go4s8dQ+l/mAassWHJgIOMG9JIHOEoUwikvycMFv5uOT/0Z2V?=
 =?us-ascii?Q?nEU28n2zOADNlHO5iNNeBZ/GTtUAXgM5yuz516Pfm1VrgUnPwoCmF/r275hi?=
 =?us-ascii?Q?q/O4F9qmhjYrkElSfQXbrs3eBWDgcrar3WMuFfqxEU7G4sHB3BaCJ8jhkJWA?=
 =?us-ascii?Q?syCBDwIXlFsKp/sin6tuX2lLmyiRbWaw6l2UxDccchXxuPNJ48Ay1VKgWUBL?=
 =?us-ascii?Q?ckRU0ucY5WTztKbzLJDaCYbg3MhK2nV7F+Xv+dYvHgM1gD/wiz7ISPppgq9p?=
 =?us-ascii?Q?/rjPCYB7gimdx2d58RN7aZkIudv8ghCI0fF3SlR3xL8D9zmRUGNQU5aHsqiy?=
 =?us-ascii?Q?KdPIYfN5V8J1/8xjAMhwxKIAVwKPuUvTvFf1t5ipuCxRVs/PKPZdApFAOlKB?=
 =?us-ascii?Q?2HrE7EuriBRS4jlOEUFrGZZ16PTJCD3sRWL496su6bKDGYg9Z6jugtsvNk98?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2XE4vN5nBBB/tx3+O1yjWjCZbAEG5v66a9Os0RJWY52US1BvE3x1GpwpsNp+V4CdtlD/OjfKobvPm7OnpoEWQNSaMcCzb3QaAz4Sbh6B5dM1MRL78Ote0PCGrcTd9Yfq+w8kTc853CgJ1f9og6n4rerg3okKTz0v+KfYatCa0PsxPILyhbHnEYbMbXDzzO/KNrK8rDyGaYgl/dp/twU4oa+9aX08YDyDc4JV4QfK738AXi3epAPEIPiIwNDDDMueYDXuhjXTfZCcPDOKysSORvWQ8qsW8KUzTpZMJ/MA7YPRydrn5/8mqLFJbfR+bLDMNpngiCy0tJgtHffbkUlsRpJtlDV06ttgFUBkqKz4aR/2OBxZwtue0Yt3OEEvGJJK7HGRgAtan5iSbf0SCSaOr6EVUngOut0UfY2HV+PywAdiJAa+75fkzL4MVDiVrQCI4QR5Pi+tgBcUu4acFMUP7tvmIEQagugyuEnUs+yfDndv/Bm4cat0ZHUJ+R2eURPJU1aeug/K4yBgCQknnnpiSnY+ZdzH6gPZ8tzYDoBx/9RO4i4gKqYfnu+uqoq7I037TMzdAEgox20SrSNaFA9d2DOJNT+bmXkyPXCyF2JyRFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75df47c7-cddb-44aa-f2b9-08ddf139ccf8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 13:47:51.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckivZiaSt6FrC2GyyAyB2JFowNiU7KxsRIJW74uZSSRpg4VG9uxrI36HCrfLdofAsmuIuyEnll0qMPAaznTlBwU85vxL/xMnYA3sd0KSQG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX7VAg+d8G/9SW
 kG0Txcda6WazdwAialerlFPOW4oL3LvU7MsLDcpsGK+nT2mDC8VMBAuAJ80IbjaByMKW+uJpbaj
 4cKmiAgSq7MCOUWGMvPxy3ZT6J8Xnb/bNxV8mT6wN+P5man5Sek2YNmb/272/eyF+KadM0kk/b+
 oEmYEwzC6t1I8bUL6qgBpfAqyTyRuIEyK8dvUn+4GW2fCKbd6lTxAYokJg6HKMs6lAf+abWlktK
 5VvMYyd6e/zsz6rNqIPGn0iivIWA69nMQ4dHHgx5FdPLGDvsib6zASTU8cPWppxllrsMHCMZEW3
 +qSvk1LELp2csuxOsGNGE6uLErRYEGyxFUVrexNNQBrWxz6YFPqNmKqUecOnY9mdj86OM3o7Ywd
 awLOhqkYpBRkvvYEwOcT2cKvt0wQfQ==
X-Proofpoint-GUID: z-XUSDEq26vbEyTz9WyNohQqTFuIfxst
X-Proofpoint-ORIG-GUID: z-XUSDEq26vbEyTz9WyNohQqTFuIfxst
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68c2d30b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=Bw992Em18476OfrFuUoA:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12084
X-Stat-Signature: bke3nzde57wnr8nzrn3b86mpwiio3hh4
X-Rspam-User: 
X-Rspamd-Queue-Id: 56EC240004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757598508-509306
X-HE-Meta: U2FsdGVkX18agRf4a1w/3rNO+Xixk2y4JbM0dexkKN+KTBaAcrzH2ByaMvZ5uZXMkejPsZHb/fxkQP4PVjglQeOE7m9vtckpmcNgY7oTX6vUABn4YEXw7QaBrXESA5C+mWlWbQEQmo3M34xAISEOtEqhhY2Zt7cV9lRwrxTZuuc5+IZ25VVLmsP+LXzTYpszvN7k3XgqoCykzVjYJcaaxYXyJ6zyGk0oOZZ9678y6YxqebLafsCTfZSHm9VpjXEZrkgOcdLu+YXrCnJS9X0PNK9wh+PDqhl6c6oBaOL/uhrfHgjpLwtQXIbqBWaqic82lZZNlDKFqvj5lv3eCglHyWqg2jECd3l6AxXs9J8I5/EwjwaALaRznkgSnC8AczJtW1Z1qZ+xKWD4VE+YQjF6C8Hs5tqkyuJx3T4nbOiFr8ediS9DbQ/m1Elup0bTMb/4l+dJhjxTE75Hw+k9m2QdhQmkDg1/MStIs2gQfqdbLS/krM3iwHmnI9C59JqzcEzhQqgya2bTp7OG8vjl6NOJLq+Vp/r42RU2rYagHkGIixxu1OhgqWJxhJx4qO0a04Pmwn6kaDOfDG45SM3UR1lAWbAwJz6cEFIfgF0ejCOosNHY8fhcNvoGLJ/PtiF0hX93siuS3+re+O9NKjxGld5V8KnF8CXOxbL9EBp34+4flCSM7gUHMtcxor2zd/brQUzngB607i5QeN0mhyB7J0vSFAlMFpBEspjv/M33pbvUQX7x/HtuYE78tlEWyr5bUb4ogXP3u3hePuL0YOtxZL+krnLR1Z2NldwM5SgI49DHe3Jpk4Mxh422k59ExSADaKvXs2K9esGw7os3RISCUsMG6O8+53D+ROcOjCbVkA089cLPP5C1LLmWz2PkRSmH3Pi2rbT3n5JOjwAYWzlr9KmMUblH9TQroznuVUhLz57A2mrv9f9P7eHKtGBEI44vz99E+eWlfPugMH8bF5pxteX
 6HorsDqZ
 WqyY1ieNR7HkOsRuCfZUpdmQJgNChx9BeGlKClTBxpPTxfzsFYMrRnM50GYu3Lel1peqqMdZiD2MLGpdY5m6C7o1Cs0nLGky4ZADyRfQVaEvFRTEkCGUsCT9y0ocgC+L7gfh3SkgC0lK2XqhovF8Ta/9H5BWLa1wp2Sd03gydgYE6BccRB3R4VOEtMZ7sjC8i9drC48eHVVp9WsWMC6TP53adXWAfh0t4EYBFfqC1x9Mg2FFoDdbmOrc2p3c1Ihju9TP0IJ/hJROX3XKcthozaSqlFju8KaOK3cuA3A+Fjvyp6Z9ZRLyo/77r0z5X6qwrD4YcQbZe9hESots4TUXby0mBZWsoYHAVnIxCYwKblZ3Bhw5OMF6LqkBWxKVywf+nty/NmxDfZ5ljzLlEBNnTYVburqTahILzzFtKLZrHsU5pvUbkzOs73g0uLlAwyPERIox/JEkF53dG5Ts+gXFpA2ugBH27GeAERGuwBHxSTWP0ZkPc5iNgZeocArqvR2UdhPbJJtdXNDUXy+XJkKDddY1u/owiVZoqLcjJxmr7pfYudJqcx3sbDbi1wqyQBHRcF6bIOcaPyxqSLaBcIq0tFKcj9BkYmqxDySR1N5/Nzyujx8daCgzuzo2Ldyr3tgevSqD1g46uPTYFfBUYAZ+N+qvCluyKnErgputmFnQdHsmH9IQWiKe78Tk3b8xXv3YEiMO3JxRRGafy5zimNnQYO+mcgZiJcddz9iHpaWf6GeG0GGtMd7TuUzMoM8cbxlLKiYeUMrnco0Xbg0+VOvDJh32ey/dQ09GWGGUhPcTYIeVvTVr/wvATx/iPnbQgNE8dHXgzFtcljsRfzp3bHZ6r2pIc+xFyVgPMb7sGDOMSplbUNQFxt8183GxKV12UD+Ld5t8InD/34z6WBmi98Mj89mk0XKtC2L3qX7lngLf3vsolXS6Zxy1rAQpwLJnECoX9K9OtuzkVgTkSTGwqwRaqVggf4UXE
 UzmoH4nd
 5AEfGwFwJxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:28:30PM -0400, Zi Yan wrote:
> On 10 Sep 2025, at 22:12, Lance Yang wrote:
>
> > Hi Yafang,
> >
> > On 2025/9/11 01:27, kernel test robot wrote:
> >> Hi Yafang,
> >>
> >> kernel test robot noticed the following build errors:
> >>
> >> [auto build test ERROR on akpm-mm/mm-everything]
> >>
> >> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
> >> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> >> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.shao%40gmail.com
> >> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
> >> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/config)
> >> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> >> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
> >>
> >> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> >> the same patch/commit), kindly add following tags
> >> | Reported-by: kernel test robot <lkp@intel.com>
> >> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-lkp@intel.com/
> >>
> >> All errors (new ones prefixed by >>):
> >>
> >>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pmd_enabled'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >>      2500 |             hugepage_pmd_enabled())
> >>           |             ^
> >>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepaged_enter'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >>      2501 |                 __khugepaged_enter(mm);
> >>           |                 ^
> >>     2 errors generated.
> >
> > Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are only
> > available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)
> >
> >>
> >>
> >> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
> >>
> >>    2471
> >>    2472	static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
> >>    2473					 unsigned long arg4, unsigned long arg5)
> >>    2474	{
> >>    2475		struct mm_struct *mm = current->mm;
> >>    2476
> >>    2477		if (arg4 || arg5)
> >>    2478			return -EINVAL;
> >>    2479
> >>    2480		/* Flags are only allowed when disabling. */
> >>    2481		if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
> >>    2482			return -EINVAL;
> >>    2483		if (mmap_write_lock_killable(current->mm))
> >>    2484			return -EINTR;
> >>    2485		if (thp_disable) {
> >>    2486			if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
> >>    2487				mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
> >>    2488				mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >>    2489			} else {
> >>    2490				mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
> >>    2491				mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >>    2492			}
> >>    2493		} else {
> >>    2494			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
> >>    2495			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >>    2496		}
> >>    2497
> >>    2498		if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> >>    2499		    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> >>> 2500		    hugepage_pmd_enabled())
> >>> 2501			__khugepaged_enter(mm);
> >>    2502		mmap_write_unlock(current->mm);
> >>    2503		return 0;
> >>    2504	}
> >>    2505
> >
> > So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE block.
> >
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index a1c1e8007f2d..c8600e017933 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
> >                 mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >         }
> >
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >         if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> >             !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> >             hugepage_pmd_enabled())
> >                 __khugepaged_enter(mm);
> > +#endif
> > +
> >         mmap_write_unlock(current->mm);
> >         return 0;
> >  }
>
> Or in the header file,
>
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> ...
> #else
> bool hugepage_pmd_enabled()
> {
> 	return false;
> }
>
> int __khugepaged_enter(struct mm_struct *mm)
> {
> 	return 0;
> }

It seems we have a convention of just not implementing things here if they're
necessarily used in core code paths (and _with my suggested change_) it's _just_
khugepaged that's invoking them).

Anyway with my suggestion we can fix this entirely with:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE

void khugepaged_enter_mm(struct mm_struct *mm);

#else

void khugepaged_enter_mm(struct mm_struct *mm)
{
}

#endif


Cheers, Lorenzo

> #endif
>
> Best Regards,
> Yan, Zi

