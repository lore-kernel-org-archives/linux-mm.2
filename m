Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F688CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06F76B002A; Mon, 24 Nov 2025 01:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE496B002B; Mon, 24 Nov 2025 01:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6526B002C; Mon, 24 Nov 2025 01:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A75E56B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:00:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7638712A8B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:00:09 +0000 (UTC)
X-FDA: 84144450138.06.9296425
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3721620013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:00:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ViufxsUw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JfgmmkaV;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763964006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRxe0/0/B1rrakACxyNb8wgijwPvpdRr5Xn5514TGAY=;
	b=yAQ1VzfKt+CU13f3gM5t7fn91Ip7WAnte1svsPAOBntfKOpe8Pu4wHJtk2ukwoaH5dLBxu
	RhhQi4gNGD1jurnkAMxSddXzcp+cZ3bXwFsA+4k3vMhhvrhmge/G12NUKe2wInRHUAlthO
	/+t+DV4YeKIrTXNti9Kl5zWxZiLkCvU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ViufxsUw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JfgmmkaV;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763964006; a=rsa-sha256;
	cv=pass;
	b=KrEa3vWu/jEekiFFylOigAxgCphljKNzDUcuq+GLOzN4trPGhjvmBwcbWE2PizON21oNJ9
	SfFjg+kZaNTmbGwRKK+6V3ECHcdE4s99Dg4quiZUopfuxvmUX5ecHzc9rrnWLkZ4GmWsR4
	bWftCPmQZ9HNNac041a/W6AvtUiSbHY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO1skTG038813;
	Mon, 24 Nov 2025 05:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CRxe0/0/B1rrakACxy
	Nb8wgijwPvpdRr5Xn5514TGAY=; b=ViufxsUwt/zGW6877Ul1E8MPxPse3YLT25
	gE3cvdGMEW/EEGqfQRBg9ekTRwgVfHySYxX12wGMAHoE1fVifOdP8SOGAyZloJMv
	UFrfnHvubMFfPN4RvpYUNvEfQsg+/fNEJ2vjVCQ+8cFbEpywwOZqQnoZW0ytAXml
	Zoi7pZ8qjqRB1eHskKgT/aZukD/RG5AXRo+6vEfl3lPDHLbLD9Sot1BJplcHuRti
	NJ1I/IERjPro7un7aoelWyzacwMkIh6I753E2sj/r/vLzuP8G0VUR4hHrbVbXOXN
	fch2Z0mnDUcpFo0NzSpxWIAQz4aXBSUWTUka9eL2ArTB8uDPwMhQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811hdar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:59:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO5SpWc022632;
	Mon, 24 Nov 2025 05:59:58 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mhqh3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LShXbuiJfQV0INJfFK7yiT3VandQTvt+4NVfG+B2U+5GaPtB4qyMF0CZgi0G3l5zidRph2knU2i604thfUMO6RhFkhoWjORiH5/BVVQugHBQlpGDJo2A441J76yx2FeLGgdqRoKKG83dW6neSB7qHVMokLtGpVgK+cKSsftWIaqFqDEIXOUNJZVQXWgaztNeEO7+g8DzcbhHlcBCswlKGJEY8Pe/5/Hn+Io5YrDVvO02dacOwhH12OuMF+X6nh4CWdKEavp0fXHFSNR10z94KJuXiP+z5biTeNA/QcgDrljynL48IjgNVVpwgE6T2Mlt1I2aqkC6PB1/R9Do5xhykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRxe0/0/B1rrakACxyNb8wgijwPvpdRr5Xn5514TGAY=;
 b=warBFoTEDcjqw+Ar3OGCGQ5CGuzRcp/YjHN4HTGg2wuSrW6nArBtjyGMEYmXS2v0S3XiGIpOl9bicw7vrTypbc4SdnY249l7PsgrBY8bW1wogbYZJcYhto3FR8Q4Djkjbk7bQTY+5sijVdhhedsOvPISmZHVAQx6Uaom0rKDl5Sdyel0YAkIVLAGFRRquoVdKcjeeiMU+LrpkAWwKsOIzSfUxnmuQsw8p0AIT1KOXQMW+LDrSkjQJ+3bad0i3sE88nO3WLAqNEkl6Qhcs2GCvKjyFIr0KTISY4lfwaP3SclSFhKHwf6IT36Unbroa4EsAtmP/bzR5lwEVm3A0YO0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRxe0/0/B1rrakACxyNb8wgijwPvpdRr5Xn5514TGAY=;
 b=JfgmmkaV5DVBprgrL1aNHG6mNCu9Zm243+2vLhIphJ8qXycAqI1Hu2kgEVyaOAI2VvYB1BpKAThhXRtMtkl24iozWfs9KcPLTqgY79Y47ugjxTTc9u0CI/kUKLL2yVBJ5XBQuTgiFMtkIAjcdBOp9sWmuscwzsAHb8clw/5ImXQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997557.namprd10.prod.outlook.com (2603:10b6:806:4b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:59:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:59:57 +0000
Date: Mon, 24 Nov 2025 14:59:51 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 12/16] slab: Remove folio references from
 kfree_nolock()
Message-ID: <aSP0V4Y7EMu1MzsU@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-13-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-13-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0049.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bd::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997557:EE_
X-MS-Office365-Filtering-Correlation-Id: f84bdd41-648b-40be-8778-08de2b1eb1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GDrLq1r6J/OGQ8ZIjEeOqFeUTxntGGcWBLJO2KGtkowG/R9dSlT/Z8zLP6IZ?=
 =?us-ascii?Q?3nKQ6UPG/G6KYoFKE66kgnSsXLYLgMFouUtvkjqm4DoYJPuhP7DV3yRKDgJl?=
 =?us-ascii?Q?NE7guldP8T3bZdV+vimbnMdmUKv3yPJRDcpllqHxuucbztbv7NWSggWAFPHT?=
 =?us-ascii?Q?G2ml3WLY2noIYrAuMQzAiqKj6aXe2gtZYNxGzgkrcz12MHeUmicSZztbuAMW?=
 =?us-ascii?Q?/xCyOEbDrb5Ts5FkstYdKLUssEZy7yGnmBbbvRbcIYjUH5a9ralQ8YgZtulV?=
 =?us-ascii?Q?A3Jr/PdxO2jadji6yqaKJotKirUF68EZA8/cy38YAWDmVcJV5Bm7EJQhEpef?=
 =?us-ascii?Q?B2NcL9JnGMikvDKa2cLAaB9MvLlLlOwNwu0NjtJGAiUCL5vh5UYR98emC7nV?=
 =?us-ascii?Q?wFtikA2cLasJSuKOy2v1VgydtiAmUPYOadqkng1XDorCUmmG5L97iSb1WbKb?=
 =?us-ascii?Q?Vgj+Siju91pt+clj8bkMHnVQiyZGJa7zYviwK3Pi7I08gTqT3uIRwy2ICCvs?=
 =?us-ascii?Q?gxhQUTI28+InfRT4vq0Y91cCXuvwquWN+Y02eCajVpkRB25wpDpnJOz/HOI5?=
 =?us-ascii?Q?FXXdWLKq5atar+9uHanCSKW1PdN3mfTFYei4D7d414LzLA2gv4B7cuWaILxs?=
 =?us-ascii?Q?o8Bd8am/wrpn6E2bAdh4ngVhBETjuw4pRX1GFwuGNJSZ+v1HsNlk9mKMbkDK?=
 =?us-ascii?Q?VSM1iuWP6uLyrIMMGwjyGu7GYpRdGBdrclEdGHQcKuSwdcFfx/N03r3FlvRk?=
 =?us-ascii?Q?ELT+omV5B/cKWlcH/P1JZYfkLSJe0t5LszkvVvuBBBqHz+qHvfcm47rDaUVm?=
 =?us-ascii?Q?3YfXFUgjsnHlwC+KsrT1ZrAdbYMZYeZ33rlqUjEN0fvI0Aozv/xyRV1JG88b?=
 =?us-ascii?Q?rRANOfQjEvJZH9tJ6b1AT88fiXweyn0g4hlum3TBfsVrzQhB9z8UTbzNuzeS?=
 =?us-ascii?Q?p1gixjLDD1d7l0qaLpTagqes7ie34XTQ7tb+wiBCBlcO4KDi8hKgR9PFoN0K?=
 =?us-ascii?Q?K8OUDxuNOsnVgCcrcp2XF2ZXpDRv3V3FBMWD7m9SRrfGsLFwrKljGBjqAHDN?=
 =?us-ascii?Q?1Z8JwETezLxJDaPwL52+7C71hIqbbmQxzsS+ajFnGdW0riSVLVYxbWm9GAi5?=
 =?us-ascii?Q?kCxq0usI1nkFrJTVJkeFkleOMyVL4Nqzbr+ZMiQ2R9RN4Pap69rZ0riH6eT0?=
 =?us-ascii?Q?rxeXyHqAjibOccY1c1ckJGG2ixdsQ7KfKTOpDZmBY5wBOLjbs5C10482u1bd?=
 =?us-ascii?Q?M2L9eEITBKlIIqLyLslPO8W/k4Ke+sKmTPWvFLAC6PN2iGCeMpyoiCuHLamz?=
 =?us-ascii?Q?2yl7P/J0rFYkgRgTX9sri2p5t5hez4HCSyqrusLHN/CD8Ig4Mz3F9m5uhvrP?=
 =?us-ascii?Q?6k3jgBGPMQp8VfGBTRrbPP0X4ej60qQQho5LsuweujaaxhR5R4AugsDksfc0?=
 =?us-ascii?Q?yZ7xIjf2b3XAT8NetESbq76kJYLcDWZq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3jv0PC4wUZFnPi4N2Z4fefOloioruuFec7LkqWbmI4pqaOIZ7nMrcFT54pgN?=
 =?us-ascii?Q?Sj8qNRrB7T+4GipLvhvtMAkprCmqtiXjFRCyB318C+OdC0t8mUzYv/s+hjFs?=
 =?us-ascii?Q?6FBT8cUZJs0JO8alJ9ChIbrobxs/tCQ0q0MgBstyH67wa7a4lgukNNEYhSsD?=
 =?us-ascii?Q?7/m1dfdf+kl4apeyZDuD29U6/dHrPd1ToyrTiuhz9qMNvVe5i1bhvzwzTYd7?=
 =?us-ascii?Q?clWtghQRzqjMyAQcFe0r+CIYTStuujoA+zYbBZqLpkvp1cmATy+EkjAPYYf1?=
 =?us-ascii?Q?zKTx+G4xI5GCDYecIJ5tPyLVUsoNn77UANjNIhrXXqZxPCiDCkkxRnzHaMpo?=
 =?us-ascii?Q?WRAksjCabDb4QpKTq3E6CFtKB2dQ/R2g8kicYqjqKApYDo42fNauWJ9BOACE?=
 =?us-ascii?Q?MyZtaeSXGoPvsDeJYzDM87H42FHkoiCej6kMulT9UTM3lTnAxY6evpSQTnFB?=
 =?us-ascii?Q?hWQCng42bv9juzsxySQK7qLERlLxpM+94M4THc8vJzI+FBRmeBN8ihJROoSj?=
 =?us-ascii?Q?Ht8THXs1sU/LD9iY2EvmsFvYZZ1vok27WLrDpLT0wlm9s62OtpOZwHtAnfUM?=
 =?us-ascii?Q?0YelQLkPy/UPGNSUP4xcJhCcVQpBJJpXc9wyyTckk0Wo617mM75K9uysfwoq?=
 =?us-ascii?Q?g8brdgIHtysuOdnZHLMJxpCEv+1jsxa9GVP6ZdGQ4JiCRrfBKMUksDZa+PnF?=
 =?us-ascii?Q?Kz605N/HmdEosqYu3dcUsvM87aY4BoOE7tZPxY4kR5CQf5WP/4tSIrJ1ttKX?=
 =?us-ascii?Q?vIbvtd1V5oE0AN3BFXJm47nxLPaAMrROIx9CoSYbPnR/FWeufylpPdTBYpLg?=
 =?us-ascii?Q?HvJOHqoSQltmQ0HCUH2SVIG2ireKzRtjlvxM1moC53AE3l51DhsSItkJeMBu?=
 =?us-ascii?Q?mNBwJ8k5MBUMq75jcvRRG7HOx0UasR5hoPoZ/w8bF7ZqHksvIo8LT9IbZcpM?=
 =?us-ascii?Q?i0MmKOMe+Z6HYUUZr4gdh+zhxrWSw4o0yzYc7AjfZwAM8+hMyP7dBZ7LTlt9?=
 =?us-ascii?Q?QNqEbyok++BsKd9D/nSVtENm+NLI4CTG2zB+FVxz88qRAPag3C6+NHg8eH/i?=
 =?us-ascii?Q?i4TklDOVruZCf3+bl8TNlwxSJHtj1f4t5AYo485vme+s6DTJgHuWN5nG8DDW?=
 =?us-ascii?Q?N9oBp/Nf9y8w6J1RgOvccFs9V8mvA6MJhP0B8JrpcPG1h8ni+U1bLFES34V0?=
 =?us-ascii?Q?zO1xtnTpFvSIr3sa8X+0PNJkRxxJ0SToz1WFSrMKJV+s+6nKY/xtMMKIzwve?=
 =?us-ascii?Q?tG26lJ0Zb/KBYOoHWWXxDTtS63l5NE6NJcNLmSKEl3pdP2VH3yxXo1fYbyAH?=
 =?us-ascii?Q?Jf7twB00WrkGyZYPZbCir+EcTD4yA8sOB7wpbvjTDr7MKa3jeVQ06MwOJaXD?=
 =?us-ascii?Q?MPuPAVWAARCVHn6hLrOoE+MOOiScvCBCfyj8sAoCpdaMUY88eONCn84T0nOa?=
 =?us-ascii?Q?VcAh1/Z9cSfTJOC7LefOmAecv5J3DOACWL65c/2nOYqJt+zq/3HbzWdczMn0?=
 =?us-ascii?Q?m1Cf4wyq1BplBfvYUG7f3dcvn5eYXJIlmRwu7rRSxKQWpeF0zyuSAD4RjvVN?=
 =?us-ascii?Q?ejKJ+7mTStGgzxb5rV6NmcAsntGWIEQDSxojHDke?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qS9Gv4HB4q4Ho8I4EwGnBX12QvkW6s+SFbHlB4UBueL2KzX2hY6UP34LxaHN4HthTb1LaMB5lRl/YThTimDldwoQJAQlbEUn/4XBWKLwCOgACuXaHFycTjxPf4JmjnqauuAqvQuDZnrAZWWSzx2IwXKjKW2rJCPA5QFhUURBkrRSS42BmfZwKg0RI4xKtkunPj2gpJQw6XclG4CFKUNNLQwftj3Q6i9M4JP1x3wDwMI0g5TbfltrWKmVJP6MHrraxNZMSfouIdaBHBEMp6ngK3kkScgt3I242mZvfckA/H16cco9rKTTV2zrSZKwuEXPqUyNHgymVR//cUyI1BZKFJa89ATezfJaHZn8sSGA/2NjzHD/CgwFfEwSQUTQRtRJnpJ+tNO1R9LsR6Nn2H2llYo1zXpJ2qeTkNBWtwPTB4YGu654eYO979mFvxHPpuUw5CYMXRZ2sqOWzKTIr6DImnkLEi/QjWlRkyfPr1Z/LAnogkY0FVeERYxRjkJgixjKSimMdHB5kEb3Fldy3Wx2cBLMZjjScdax74XolkMtpxX8qvZzbvrAh95jkNoNO4zyfuiOlzbPN0wWoD8nnpjZHNk6HUNqX6erA14jB38vzf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84bdd41-648b-40be-8778-08de2b1eb1e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:59:56.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgB4YbYCDDh6hGG5HirsgpHNft+C8FUUOqmgAd63b71kpHIsDcE0QJLjEIR2fpa3z1RkyCXi7l/f08Cyn3ODyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240051
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1MSBTYWx0ZWRfX2eFgX1aEd6q3
 bzW3xRdFPsg7aS8jjqAjKGoadnxJc6YxTz9gaXaWHhucsfFw/ct6/9rLxQ2a/LwC8QyhIgkIrLE
 u9/Cb2go+zE+cvhdMkORj+CxF5JCOSiS3aD3drKpwbJjRZIP/GYiN5yUf7Uuwi0TpbxU5ApBT39
 kNzgyZq5usYAzgGNSyxEi24xxu6ZQ4d+JlA4LD9OfIZXdQFLy18FD0QKd/O/zzxhWDuyZSKYeh8
 VKcNEhS4EkYSqtPJ3u/9vZKPx+u2VzGRxsrVgOH4wLngrVtw/IX4XVRXmuVtgm/dZVUFEisue/X
 wDfyYb7eHTQ/py0/oQZ1/bD1KjltviQH/ha4bKS7YSQGNHE6CK3Xas8RKH6pokX2YCPIE49jc97
 uyY8rXtRmIOKN49TvqXrUotF+phHihXzuBA+CdUkKuv2lEZTvqQ=
X-Proofpoint-GUID: kZovN5jNfK-u9Xzy56uvH4Y58cBJfz33
X-Proofpoint-ORIG-GUID: kZovN5jNfK-u9Xzy56uvH4Y58cBJfz33
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=6923f45f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=ucx0ysRx4h0l-kb3NR0A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:13642
X-Rspamd-Queue-Id: 3721620013
X-Stat-Signature: 5kpwaiku44rr4xx3gzafg6eeh36e5c6c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763964006-140416
X-HE-Meta: U2FsdGVkX18xoBha50CjV8yplY8vThu8FTBp8v+WnEO3R/hBd7npg0SAaJ5R7tY194VqG6WRmn8UDbMKFeUnSBH2z6wAFcmU9zveBFxwCQhW0y5S0tVyTvi3FZMJk256PAcPdviwgf25OEoK4ZeAyORSGICHwiyEY3iK/Hz49fTPp5S5MKOaSMS1rKN6BIP+m0MAnSOkfwD/bcWdbKX4iuzF9NeoDq/pWbjIFRfQKwomsAjMGqF1kmjlB3c+hsGcwwmTcHIQKNKiYR0gL+Qtuns1zoifekN3uSAmg7XJ8MTxFKOH/VbW/rd3r0MiYrwQgs7mrnehznFEGIQXwL+sgbwEbpOJlNwjiyfpL8QwmdTBThq5e3P4bTZ61wEmoYY5Xy6YafSV+cDK22EPC5wIScZwGcJAvja1FROV0n9NL821vBCoGkT0azb88bLN7wysxU6j86VSpvwa/yNFHipmCjE5SUAcuPIQoR8DjotBFo83OQ5ENDOu0UvfUKetynVy9H71GcOVohDAiGIHQ3gzNDfT6XL2dsvOJ3Woxc51P5s5Hn0Osa8EXEkuLS5FEdXJfCqN508IHk0buTee3WwD/6fPAx5gjBrJkR7/4nxY+6StT1ADda8uDOs8wFT6Bh/kKZOrPFxGrjIJhegJt/69wCpazyhfa+zkMEJyWNtFiJVQUYKliaIlJ6KfUHzURX4kGgVc1kQ2DF2UH8ISyMctFK8ksFfafEz0khDBncmucg6cbvNJoWO+zN5+POfO3tPIxfn4gQ8f0YokQGATlNP20OEOt+XN3HIBKLX3/ubZNrLfxV6w6XA5ILQh1TJC1zFR42LjR1DLn+TsVHyQFnShZOyF3Oeh97jnKDbsLVKILJbwPkrvaWKy42C4VnnJhSMdffd3dBSP8dKyPB2El16WvrIOZeT18EV+u4dEa5lGdEzI02bKPFauQ2uZG+9N7pgnQgMajpHo/ReyeErrt3K
 5d67Yc/Z
 SB5a2vCtG/ixS05pIQyqikcZz0rYM80Nlx+//agWwapfNOrhJkLAL8BGqAUPha8SMwi+thMMsUeR7HSgR7E64OqJyYmy4siE+VozbAIHrTOPqsBZXqRy9EzwdZR176eqnC/NDuVTh/xu6Z9asT8QG8+1eZAfZQbOW/Khf3Iv65OZXpHCaTTai1GxaufvrfdqEWdkS95eYTD9ObyILVSwqjuDOD6P7kAocy3VwsrUMUu7YiqDW5I+8lZo5vosooWmaXZeWsyjWvDR4uekwpibV0hodjzqA/6UYD3DJ15d/G49qqXRhsHVLuh5PefuVZbWevEKmEoBlDENEyV9tWvS6vmUvRI/QuF77sAMespzOYXZZqLrI1d+UChYE/pjiOEtzDJMQQHH8ddf/iWWtNGP//UUm0LMUeXGV7B4C3quf/3ZNjbdGg8oPqSKRp/K7Xq1cJ9RcJE/0W1KAekeNGRnsc/2MBobPhMTul5dqbbTnOrngiA6xEXZD8Z71sklEl+GDPk/6Clf3l9uhmlKPzlw17AAEj8ilLunIXkAY3S1YRJUNRKVFI3ggC0gf+pwoOvpHWCbQtmfIMIn/tk3dsnUciDB0WVTX/QmjLKUkx8APtnDyS9V4kQJz6nuXyZOBxtP8En/ishgJZcjzFFdKT/TmxuPkko8kK2rX9m3txady/YbcD8kOJb0rY5QY+cas0YFButEM7DYZY61jIt29ldWsdEtSuiLcsQ+lt+tZ13m+WUI/XLbgDfD5JvDPhITN6QDEmEAykOnsgFM/4EhX0i1k/MswoQHMYGudbOXV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:26AM +0000, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, remove mentions of struct folio from this function.  Since large
> kmalloc objects are not supported here, we can just use virt_to_slab().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

