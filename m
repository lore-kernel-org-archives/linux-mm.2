Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD8DD74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343EA6B04F0; Fri, 23 Jan 2026 10:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2166B04F2; Fri, 23 Jan 2026 10:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17EF16B04F3; Fri, 23 Jan 2026 10:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 007C16B04F0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:07:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0C268B4F7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:07:57 +0000 (UTC)
X-FDA: 84363558594.10.9329684
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2596040017
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:07:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YDDfQxT0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="w/XSRPHw";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3a3DiDotEu4WzvIKNr5YZ8T1nv6JtNpm0Hg4ZauDk0=;
	b=DUva4S6UsVKwWGvHuKIX3FDdYzwMej+Qut8M/2ASlyAWeNDwty7zrFY7FWPFsPTBEr4ciZ
	N5r3GXG4ZyhO8WfH0IMM3uycUJmXRSR2EqlmcOruXO7o420fX0CVC/sWDKJlWJjKZ1e7v6
	7pxOi8OrKdhhwo4nBQo8OPmG0PtEllU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YDDfQxT0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="w/XSRPHw";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769180874; a=rsa-sha256;
	cv=pass;
	b=HDHtQaImq3CBzDErdMl5ieJASxW9OIhzEXyQqNyMNoB/373cPURmcYJkWpUcMX5BMcbsDc
	Nbb0YWVNt12rJ9rpHYSJzt4Hpetjr4xWLJNci3R7e76Z180rBKxJZA6x2kDlvSq3UAJyeF
	fZ4JB3YkWFR9YP073zA9ilvydNXFy+I=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N9pm6j2401523;
	Fri, 23 Jan 2026 15:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j3a3DiDotEu4WzvIKN
	r5YZ8T1nv6JtNpm0Hg4ZauDk0=; b=YDDfQxT0bMt9QOs9lK/cyLCCP7tI9xXUx9
	uphACsvK5Rjx0kCc3wBy3LeT7RBEUzYvb0hjjYm5p9LBxeAKjQ1ZneejRRDsXBDt
	KWIN7w66mY84mD2S1R1sSx4mSsDfX//pksKJup7loKgKLzzbfYvAjJJlZvhwvNuh
	qXiqsUDrX8MhlPnmazEtJUz5xN6zZtTKYw3erQspY/2r/OwwOzH+kwyNYMysEIsi
	3bAN2xep+uSh91ihp5rGqYOBdQEhx22uicIaf8+qAPgBHVffhe+zTVWNVUPExGlR
	A/S1iPEf2dL0WyTHJ8lHod4REJpH4VzHpYxDFz3jyrsP/dmpugkQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qjpaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:07:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NEL2hS032874;
	Fri, 23 Jan 2026 15:07:43 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011048.outbound.protection.outlook.com [52.101.62.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4buyvexu0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:07:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpFFUFLMpoh7QZ/qMjZHml5szlszovN+yU7OmwotmIoxoowRo03CK2v0PasSBp4UVtNbl/kpJ774+EBhuBb/nMJhepglAqmsoSqoxrb+hbcSFHaDQ9CfFSz/VaTrTrE75UpBCAfbHZPkSrjyur9p+YXh8m8vougB+vmmYVXW8IaaEe5SZHtrxaNEpxcqmySO/wBAYCdRHKhtkuvNugQ2+E0xgcFZKnU2X4td0CHgIkx/y1I79uCFePMBuNtkKc1qWpXuMvzn7Q506Gp96Mbpl9975WRWbCefR2yAB8+cf4cElJdH4kAbKCfD0iElfmUwx3ntS4SXlaQhar+qWjnA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3a3DiDotEu4WzvIKNr5YZ8T1nv6JtNpm0Hg4ZauDk0=;
 b=MKH1uTo4TtDjcX4EuGa7XZFGh65kHzezfu+7PBl3rYKHFlaT7CXA3kzbiyoOelFXspRzCXd6Aq45d6jcls1LvZAsNkWyXv/Eg+v2mXkyFAkSSe62q084rUz38OW0V98h4hWXv9zcW1ILRyZXURmViw+Y4g2XzMOHki5VsLfolal8ZUsH8F3r178zBqYO7qCkfMXuarWZSmyT9H7d1W9GnJAZ7sGMOi3ntUKcrGPPQ1LUhpfv3WN2NeSysQ9CJVZAbwLV8+D7ZlhseCvVhTA9VggGjCCJ/vVbD5/7+zVUhIg9eLjBBs9UftNyD08wADkcE1AAATnYP6yH4MDnRFvmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3a3DiDotEu4WzvIKNr5YZ8T1nv6JtNpm0Hg4ZauDk0=;
 b=w/XSRPHw4tAeXCl8fxcSb8Fbwc8kR4++hJrvHyimVOYVKFQmI2aDVFIPtCMin9QptkuC8RUpo6GxcgFD49eUkpnwSmQCeQQnHeqKRh3ohEHM+eaESBBVys9Wi/rT+2iLGjUdfELD1/nwW53/DHrovW/1XjxMxmhjsfggLkmSJAc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 15:07:38 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 15:07:38 +0000
Date: Fri, 23 Jan 2026 15:07:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Message-ID: <6f88c8ba-d925-4ce7-8536-d2fcbefdf97a@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
 <168cbc6c-5f7b-4324-8d45-d9033613a67e@suse.cz>
 <825b311b-c4ea-4abc-be10-1301d4f5da88@lucifer.local>
 <8d0b797d-6cdd-4ba7-a6f2-313f51500884@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d0b797d-6cdd-4ba7-a6f2-313f51500884@suse.cz>
X-ClientProxiedBy: LO4P123CA0290.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e22b384-58d7-423d-3b0d-08de5a9125a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v86r+PA5C9TUnsmhcgV6aMp1R4K4Yxah7W5Pnp4I5NniXAeGe9AxtnJCWEfQ?=
 =?us-ascii?Q?5FUJyublhJHdStNHN1iDyqIJ7qKDt6p0LzEUxHzk+UMK3yfAD8UsoAOKSYep?=
 =?us-ascii?Q?+McEeIUSJZ7GTiZoHXCKW4xqGpZ38Hia+pvWqmnVCxBvUtQNDZ6dpdOGHJvY?=
 =?us-ascii?Q?UVnHRoa23aXoXZgVKABLNxlNc+atxQFiud3RgXoSQ35YSna3V4NUsJCKvGz3?=
 =?us-ascii?Q?6qDng8keVpul3UBrOiXLWYYoKWa0/Hpe0cYyfWP8KdMoyBO+iE5KK7SSODVr?=
 =?us-ascii?Q?po2gLKVCZyit0VDUhmukRJPrc7cbttx+nciqljVi3bi7NRHCB4EW3FxRLgwS?=
 =?us-ascii?Q?a0Wg5xgMb1eqh0rLcFojQ2ZYqWm4FUHg5KYf9530csNf7DsfYdw9AAEoTZst?=
 =?us-ascii?Q?RJYc0ciQPGlvIhT4zwYlpTvELiSsSMPXZU2KdssRNrOaOz0dJVxjVxumHsy8?=
 =?us-ascii?Q?6Vojlzw8B4f7MZppCx6rg/u1TBkkSeWaaQYKQG/xOa6e34PErkb+dLh9asAP?=
 =?us-ascii?Q?PaSqSWQSr6hw45NwcnBi2EXYdanyQ8ARax9WyyF6z3+HbpdsUSL8i+RNMa34?=
 =?us-ascii?Q?Wq3QGSlO7OMHsLlrnlmu8lElmJQ4+hN9QmoAtzoAIkYxwKhonHsoEpg2yYns?=
 =?us-ascii?Q?tvKF9cGH1MdUeTLBqeRUlN25J4d0WH8gYHDMOngBEXsJaG7NWO0pWDu3EPVC?=
 =?us-ascii?Q?ZDw9kFi+Wenyxd1w2G9Gzo2cLaX9aXOsPJujHri8cbkOVZKT0CtYnCbXzo9b?=
 =?us-ascii?Q?SsRiPy5Ju/AaZg6XhoQ4L921T5rViW74z9cAUpaNjbtPK/7vOOIB3wIaRfKN?=
 =?us-ascii?Q?qaP5ZsJVeAWzI7hd9zit4wenJlUoei/lDWqX+09Xn8Q07eYGiJ2Jsn2Syv8I?=
 =?us-ascii?Q?S4kLYj5kEmbBQ8VV6kFDjCJ8PQ2UQip503k3ndAlZCHQ3RZ/fQof0RJrcvEJ?=
 =?us-ascii?Q?p6oumIj2+30hVIwul2LgXeUQzBdjWdU+p8RCMA5IRfqQFXrldEEn0WQZrVK+?=
 =?us-ascii?Q?d9S7iht0BMaXd7DMsNuD4IcNsFuY3twz/m+I06EdDiqTxD4h9Ndf4A6j1RXU?=
 =?us-ascii?Q?BtIJeTxkLPwSVq7Rp9Lub0I2w2df6ZIN9pj0ytPyg5DFCICcXSMk7YwuxESG?=
 =?us-ascii?Q?D7k8rovkbchLFW3JpTVrxRxC6M8i1ud1Oj/9+Dub3yKqzn8i0db03J6CihAC?=
 =?us-ascii?Q?mab9U7xt9thnsDBMAWnI2k3z1edIv/VU2s+PBYI9W+hjoOszVCxqVLMbIRk2?=
 =?us-ascii?Q?ojwhJv6hDCI3Z/XBOjq95APCP2FcXrs/i7PoQv9AvgaAhzNM5TJrpCRz5k/0?=
 =?us-ascii?Q?ho379GZIDKltvZ3Db2+TyVP1hyFReb1vmY3Y0tq5jshxMGt8u4PLEtbQc1u7?=
 =?us-ascii?Q?6Ol67sqqkFcqX3ohe7OjhBqzm16E7vRHiqa3JUQdoG2/tXhH5r++bZ3SkXDc?=
 =?us-ascii?Q?dVsqZ+of7h6vGafEC2q4kzAFMhgoR/QJH8JoLWu6TJXuCZI4vw+8cpnGnI3K?=
 =?us-ascii?Q?naz52yF2+Qaqop96MuEYCvW9NhWCURWkKuw/ULPaxN86kDlA+Lydtv6DNurk?=
 =?us-ascii?Q?3d+82hFrHal/evqHsxk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ax154WRq3ZWrU4UCFxbc2Id4cO9E8eYSCtLvf4xCtlI2j1bPQjzC9d3wtVLl?=
 =?us-ascii?Q?a0C16E6b6NF0ohUoNKtUOqCWTsq4vkyAgFnSjh1D6UUIPsMDtOhT1Wj9zikS?=
 =?us-ascii?Q?eoY/iPS3lPHokpN5QIoG10+B1diKtlhVarkBDY8bCCfEafh6+IAYUmquXyOm?=
 =?us-ascii?Q?/Iq2sXE0abKwViahogmBQtxumVpm7L3+rBvdMS1f89RhD/QQiHlEdgpFTSA/?=
 =?us-ascii?Q?y6TA1j2V92ybezJVnht9st51Js3N8+RC/mz3oxWBSSVkT6rJiMTqDwUVSIjO?=
 =?us-ascii?Q?MOg/Z/+1/zv7QCtSKfwfOi5pBY2ilSqJli6hcoE+79TNxBqxgiZAuvGG5jjI?=
 =?us-ascii?Q?WwC/mZnFsx/vNLHG+s7y7z7FwjAl/ozyq4R6QP9E+9bVu3dJpf+oalry1FP1?=
 =?us-ascii?Q?oUYtVVPDI+RGg+f+qXLIeSmw9djrw3AWtYD19DQVit/E7pMLCdyKgoC4640R?=
 =?us-ascii?Q?F4sX2qmUNISrKI6/LJpxeRgCBn1CoYopGxhQck+7uCr/V1506evc7wVP9Xrw?=
 =?us-ascii?Q?jX7JtAoV2nSBGfuO8TdmmJ0VudWvuF60ocBTpUXEIAToYvISgxPNWo7R5rCw?=
 =?us-ascii?Q?fO4lkK+IIz++h3xSQNN3DQZIflW73hdJVlwpEveYYaVvpmSEsR3IajiDijKO?=
 =?us-ascii?Q?RHZLZS2v6ifacgV3IwtvI3YFkbI25490y/qNNAo3JdF+8ChvlJjiQ8yvIFbr?=
 =?us-ascii?Q?o9OGab3DRfLQe6vLSEuux+/Z/de5JwU8+u/j+M9PX1/PrHnVFLxW3tzMd9S0?=
 =?us-ascii?Q?0H/i28sLU0ry/GO2NYvYR9EL3OvvnQLn5dxEU0S4wNts5dHJVJKRRwLQlht9?=
 =?us-ascii?Q?vsRytv9ZnfIeiBO3dkXrJz/ffY4w6/9Z3/pJKa/M9NRDHSYyLsgcQQv2ur8K?=
 =?us-ascii?Q?JSHwQhP2QT14ApSB1iBiUbdIIw5EnJ6AurCRBQdbdO6GYCCOYSymhXQVQPRz?=
 =?us-ascii?Q?FjqoqnoU/iqfyFDqBkWpxckzPyZWH9eb0zrPebK5MDva3t1XC61hAiR0xlRJ?=
 =?us-ascii?Q?QYClPaVXfj4FN6ate+OewAhfHN8U4b87JcD9VLpUARpgz3f3TFWvN1awJCOu?=
 =?us-ascii?Q?RUVrfVN8QpNvHSETdg6Xx3Rg0lzIOLkvIA2tmGswrSdhNbNNtQIYBDQdSCQw?=
 =?us-ascii?Q?G5+ILydhduCCyMEaY69gwxK0+C/bPlWp//BY+3pBWw8jztxxmpE/uTAMMGxu?=
 =?us-ascii?Q?n00rLLkZToQyuxHCzEjX0sBHw/0vC6SoSF52DX5D/d+DVRCUZ80dQav3mwYX?=
 =?us-ascii?Q?W5J/pO5S1Z+JwQossPvH+mbeMkAKpgXMXCh7PMIXjhfXvXO2PBwn2zxUJ7cx?=
 =?us-ascii?Q?cWiImOMtOAsCxP9hR+noKV5FjkrFUIqTlF/84dNUpPZ7Od/M2o2DboXO8UAe?=
 =?us-ascii?Q?reoonzja7CAEHYRnqWiNgy/snMQuCu6s7D21HkglrHlFJTahmOdUb1GQD8t9?=
 =?us-ascii?Q?xM+8kcP3letukKU4crXDxXZqrnOl73myHXjtH5duyyNC5/8c0IdV4RNSqpMc?=
 =?us-ascii?Q?pToOQror710tsxqKG2nhghjFYKB9Srduc2Ul07r9oJJyhTEqE+O7EXe2RW+F?=
 =?us-ascii?Q?YI3XFvl9gQpZ71XtGa7HTJ/TD1kyszTnT+p1qTxrjKW8kr2BHqHVMsYMHT/o?=
 =?us-ascii?Q?9q15eDcImVFLZYIlF+jkBOPr8YBDvezvfmrXQ73lElvPOVknSdDB7p1iwuOS?=
 =?us-ascii?Q?WYUO8Mbh8MnfC6dQct1tN5JLKgGJ7epV7wUE3Pe57G/xKM00WaH2QK+5LM3i?=
 =?us-ascii?Q?36jn4gVtiwwGhyJEP0Ht4jhPkaOwnds=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	26rqFMUV54W1sKBsQSguvQRJ0+7XC3OWP6lOeO0CFp54sNCBbpfMmWZrAUWhvjFoZn7g0f4Qch5TWew/PYMS0SdvOtHHBVmjc7pT/3Co7cGbJUCsQ5Z8XDGhPVLXxnuzsNjjxcBksDKV0FP8xIGG8emPm1Zfb0mpwQQJIXykWF7rSUgtVh4WE2OFfk+00LGstUtusDzxY54Vyu9X6nyaOBy4J4OUWawuElw/kdw0/gaOlnqSEeKyP95fMfL0VB3b5yY24ZHQDRhkiJWkUwLr4HwTDHLY79lPwDVby+81JaST/G6MgHPWjFFbQq6SBF1Qx5fJGDrXF/YmyrddiRcZoEGS9He9WExczlPK5B7JUwTPvKOA47+31LsIDd1R9kFNaC9/OJ9/6AKFrGSmWXkSF8kcSIethE0Rva/eFTPx9PLo3ZQwhSmIctJa1hsfem8+HD9COUCeTHMCuDR7VhzaKlxjJjkiww1tF7tWJMry6ZIdcnDc+Era+UPZbFP9DTDkSuAq0QqBN+42vk6cXERPZpsV5Bi3I1WI8y6TR/UovZkoi5+rqOU50PnyTDuH66jDLASS/VBtdD4+kqyuNamF7NsL6x4ThcAqs5IO3D3n7IM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e22b384-58d7-423d-3b0d-08de5a9125a3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 15:07:38.2220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaQv/ebX2w6AZ74lBrr81zF07UH3jQTLfPTBIs1yIaDdk4HTx9xwa00QLlZQsXNgUjp+wTB2VtHZV61UurhL1JMbifYT42bH0RrWCG5qv9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=800 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230118
X-Proofpoint-GUID: uHvnCZ0bRgQynkjR6kx7D1NL8YJhKEBY
X-Proofpoint-ORIG-GUID: uHvnCZ0bRgQynkjR6kx7D1NL8YJhKEBY
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69738ec0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QidweNiL5Ye1OHjlh34A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExOCBTYWx0ZWRfX90QgXe+IxmCs
 8ITZbtdLq2EN4Mq16h9sZ9dZLqdHOpsVO4siegC1HBoMcJV4EhBw5c245OfmXbC10YNgnL9sAFX
 /aNMG2eslGEhJ4aJ0HSd05/t2/X9sscdIKe0Y3EHxkjrKHCM8ElRgj5BEXlpO0+GAj2t4uJfobC
 EKoKw/KESlezPSVQ+91f8WZwRc0m94YRyvLbcjDRYfVhFACDqRfxQFsf/ajlKmJCwWumL4w4vCp
 7S9Bn/ZucCC5miJVQtJZrqVWwt4GYAdR4/n4FExo28GhndiV+y+cAJ88j+qvG1zoNTz2hCfer8W
 BvF+rj9IQfDQo53KQvyYpEBlNRz1o9qbICqOC23JiQXkfsTemWozUTldrjws1ueyDsw8p1Jzvx+
 LQTE85epsGBuaxd4jIqNhCfClTg2P+kh1l7s/FDTc1XS2yFY+53YCnOmMbks1XyIufhtI0gUf6n
 zNgfxvVj040grMrf3HQ==
X-Stat-Signature: 1sksfrpziok7z1ioja5om8ekmqde4fb1
X-Rspamd-Queue-Id: 2596040017
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769180873-540757
X-HE-Meta: U2FsdGVkX19YCHB21X40OAOhepwx4cjYkYgdUwIdaw9/rXEoqJIWXU68GGcMpx9CYPuIX5DvXqVUe6de02TjtTIQM+rWZ8cisvoHr6jwpUy6+I1Eoi29aO5pSp0xk7h0MlR+smousH5r5hY817sIFPCDpuJcn9r3R064dVsD8FNL0nF4JM+pNuDvpEw9IHH4LE4aTqNsCCXN80VHXL+7zj85uZeeIRWDr3MA+gFS6VWFPbtHgLzD0xfuyCCKCXS9lXgFjEVTn6V2QPOzhGcE8AFeYA1iLvyIuB1G9cMYZYkk7XmmLoldNxKbn4X2CQNSCvuUkZK1NMJyfwrLbw6/fy6wv0fYIrOA9W7UcibGM91Nhu3yoBztfnTvLokoZ2UungwwU2f8DqXu/lWKzQjHg7K28BPQAe4q5KexDGpoExWpYMga4yFdFLaJWhAPtcoTE3ipU1Y4xpsdspOnkAejsvQlwy+q2DHwGc0XuRr5SmIdMWPZBrCnRpUeYwMnPt3G4+u5GxPEzgmvQvL9gw0JhJ32iiCaCuE/qfw7EDl+XL1CxGdK4nS6xQWP1FKsBBE0+jVwTnvLZTviEv402FeGCoX5toXjYPgFr3jg9GS/kgAP+mT0Q5a3Ea/D+o/llnMWEYl/+pL+0ySRTkvV7e+5KevBSCr0oflF6D8mFQsM7CbDYFCWTPs7TXQqWwBjkkU7Us09zzYhg8abrWlgjRpXoLuZ5gUp3wlGTetqsFYVnnQ86NIsimnNlV9UoRUq5Hha7tA9LMMn4jSZxFTXNQtkLPbXXGBWFlw9kI1f52+v79xwQePSSXZZOJSlETcw40CpAUHnGLfcLb2Vn7rv/Jw5XOoNl0wkzhmXiawfnT4V4W8rBv3FhKAEKoUm16b624IC+G5WjTBokBST0RD+dzOLB4/MMEyCnfnkmXqXf5yjQE6xPKMYKgySLCAG9G/rBUJMoVIIrA8H97ENryVosnQ
 7gzJ8UX9
 onimtKyCoak3h2zsqFeBhlSf8ftgMO6wnEet3mrZLcfRrwtoreP0wqEV7r/fRGuHBqHEPiKOtioHbxJ+vo/YzOr+kQ35Y6ThMHTAUWFlevyS4pr8idxF2T7Cmn6wqYg6fhT9uHpu47Nkq4vcUqVjiQkC7L/MUM5UOhfnD77qQdFp59aWERQ90j9J3JS1zi3POIGAekI3KWjNUwfAhCAmi39GDpgWfKMK43hA7uOwOuhVpGK24HIxeL/RBUN9LqVca5ttUsiJ3F4PintL1+hR6kSZKWLrT2fRFK9tu/xk+FRzWWqNt74xiotzfh0bRLBCibFdsLEPBeX0UNOsT30YxTJ+iHahfqj0Zl5uZsZchsVllVyZYsu2+fqMZC0/hlsR/z7bdaUIhyG+Z8VtpUu4J0f/rAS/0E6fDG9s/GWha1M4UJ9WWfgLhIYiOWMYbyk4PZwS/2nTx/zMm6XhzAyAIne+mUr10HBWEjZP1AqNrdHh4wb8wJw93IHcukbc6RJEwrtAPHLEMJ2wyeRVuRot8AN8BUINWuemrfMpjTxugKDxEW5Ngn+rEyStFmgPzg4LfBVMFgDNViw0RDj0o1oc1HtH0p48ZEFY3tACf5bhdQgzPYNSDFWMzZL48Qx/uNAAImDnFk4pta4IKFY18yw0yNvm4ZEAu2OQcYBKrGeE80MXKPPA4g0rMTwNhJa4UC62VV7+KIBU69Oew2Qc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:05:39PM +0100, Vlastimil Babka wrote:
> On 1/23/26 15:52, Lorenzo Stoakes wrote:
> > On Fri, Jan 23, 2026 at 09:24:54AM +0100, Vlastimil Babka wrote:
> >
> > That's kind of horrible?
> >
> > The lockref_put_return() seems to encode even more in it:
> >
> > /**
> >  * lockref_put_return - Decrement reference count if possible
> >  * @lockref: pointer to lockref structure
> >  *
> >  * Decrement the reference count and return the new value.
> >  * If the lockref was dead or locked, return -1.
> >  */
> >
> > But I guess it's still returning, it's just a weird convention, and not one
> > refcount uses, but perhaps because that uses output parameters.
>
> Oops I missed that -1 detail in that one, didn't mean to copy that part.
>
> > I'll rename it I guess on the atomic basis but I just find the idea of
> > suffixing 'return' on a function that returns a value really... horrible.
>
> It's because I though it's common that things called _put() either return
> nothing, or if they return 1/true it means "that was the last ref, we
> removed" and this is returning something else.
>
> But I admit it's just my feeling, there's e.g. kref_put() like this but I
> haven't done a full research.
>
> > Thanks, Lorenzo
>

Yup, on balance I thought probably best to add so did so.

