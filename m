Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A574BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23C18E010B; Tue, 12 Aug 2025 05:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9F88E00E5; Tue, 12 Aug 2025 05:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1F88E010B; Tue, 12 Aug 2025 05:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97DD98E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:35:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E4E21DB368
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:35:00 +0000 (UTC)
X-FDA: 83767596360.17.DE68B76
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC3721C0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:34:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ev5uRS/J";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pXhmdKxL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754991297; a=rsa-sha256;
	cv=pass;
	b=cIsRa3wxEN2SMOt2tn/QjaKreG78xpgE/GGD2hjGjTJWsyuyw2vcP3DZqxE1Z0DSYzdPlG
	7ZKsiFEUghf/NxS2C2RM/3eAO/SOTJexuXtT6oRZ8QbkGb/etG/JXhWdtfwMvfkEICmAHt
	ezjCp3XsR18pj7pvCklOTs7igCyL30w=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ev5uRS/J";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pXhmdKxL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754991297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5apAQa+Sdoa18UK51Cl/q/J1fPYifsKB6saVohdY24=;
	b=YC9VnQJt94V9DhUo7Cpb5ZghbbEYKmB520hVr/TfC/Cb8et4fp84T8xQWceEJ95X1ZT+Hr
	kKNl/EUKFQACkn8kSYm+Uf+3/1BDd6Bt5TtaYY+41eBKt8wkcd3PPqr4X+ytSjHQHrvk+H
	vD7iJ2bfOdglMNsdnY28nnMPJ2u8CsA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57C7bgYl006631;
	Tue, 12 Aug 2025 09:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q5apAQa+Sdoa18UK51
	Cl/q/J1fPYifsKB6saVohdY24=; b=Ev5uRS/JHZlg/1v4cJrofHxiVLK89n5EBp
	T4LpTxThljxjy5e5Qu1ssUZ/6c8xTr/TOS5c0nDua/rm1roppwvClomOzncB5X8E
	h/oKkQcpcJ7DFFtSQhMRUHCCNiI2xZmAXpyjtc9bY1nmS2ackw+yk8HVzRBkMBco
	hIGgQTR4jNFmokXda1OJh1Rb1ZSz1exwEup+ehDOBGRY3lTmOZ7Mu6WkyORBKbjC
	9o7iAbTFJ3SUO0KdH161M1VRg/LzLb0vtj5O7YgM3TtqmcRUsEiOKvxPir6xTPBE
	K2XnXKR08TmTh0HuqRcH11yDH+AewrGJNXWW36xHHE+KVvOfNxeg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv49f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 09:34:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57C8xkvO030150;
	Tue, 12 Aug 2025 09:34:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs9r5tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 09:34:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWrAfxWJucAZx5XbpCaJxU3F757R5wS0mDQXqQBbv/eKQVS0OTimMP/LG+y2CQi7ZJCogzz/56ATsCh/LF0s0f8d3AhZIqJSE68pMTLlELhiyliyR4CjuS+yudM8vWhbY7rvBki6Cg0cR0kE2rv+WfDiQXlXD2JqcOPFwVSR6qFbzbdli8LG3nuTK1ODPG5ibcvv3IGKboOMztfN+Cr5Rsb1oC4njNPrb/gw+NZGmM+qIVURdmjPNqpM4t1byuLCnnqMGyzoI9/96j1xvOKcMN0uVmWO5Qw0r2+FpuzxvPbO/fXfU2pfYhq+qj4IQauAtCwAmhKNMIpkZAr1rGmL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5apAQa+Sdoa18UK51Cl/q/J1fPYifsKB6saVohdY24=;
 b=HH0oM5Uyd9gGTwRgSnG1fLybrK0SoR+lWcBvh8EToK28qi5Sgpfo4QAvzSlB5l97MhjTEMBTkm13t27HDDhbwjRc2Czrt81PNjOvSml5N+bCmki8A4ftctHVu9uiRgHpwpQUwDF8KsPszUCAUOkjeLqrjg4q4qDchij+PB00zevbuxVuGFHxJwUN4Qh1etSHeBAiaIgYaMPdI1jBHPysvtpYt0UUJJjFIV0iy0n2LmNE+r6HYPLBeo9kQpR8atc1UoWg0Qkgy01oi6pNyJ3qNs81RaKXNwXoaF4l6G7v6gPgiiudBEriNL1Ws0Bau5E3NO+RB/AUPvtNuwCNvA8N2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5apAQa+Sdoa18UK51Cl/q/J1fPYifsKB6saVohdY24=;
 b=pXhmdKxLOOYcHrOixHlxO7NZgwkKIJ5lS2OI+y4WPvgzfMEgXUQ8H6Rf0Z3WjOoRW05Ms03cu8zKv87/lfMYvJ3dgVGo+2UfemAw31pMRdtNIFecciKcQV9iUmtpf3aWxYNUkBrKO2eEtSJYjGLGxyXnIzzRPR0g9T7MkpCFTtE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB8221.namprd10.prod.outlook.com (2603:10b6:8:1ce::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 09:34:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.021; Tue, 12 Aug 2025
 09:34:39 +0000
Date: Tue, 12 Aug 2025 18:34:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempool: rename struct mempool_s to struct mempool
Message-ID: <aJsKp9_j-GyPOfwy@hyeyoo>
References: <20250812083105.371295-1-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812083105.371295-1-hch@lst.de>
X-ClientProxiedBy: SEWP216CA0136.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB8221:EE_
X-MS-Office365-Filtering-Correlation-Id: 79e3b719-3165-4c85-af5b-08ddd983756b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LTclZZPCTrudaLr91wUmBYHlbMq6E5CRWY1VY62w4usAD11CReghc4+NFcZw?=
 =?us-ascii?Q?XZPn/Jj4ceh30MgAQFM8x3SpPu4PR1cC39+UVYP4vZW8VinJsjZI+LOCP8+T?=
 =?us-ascii?Q?oP7HvnhieHY8+Idf9S4rx8kwjIhqUIsXLKi1TOXBBllTCDIzG34kGdYmnoeh?=
 =?us-ascii?Q?H0Q9Cm+RbCtYp9HmTbpf/3iH7GhFzMrtdqYFCOTYgvEaIAOcpWSEEVs29Sbs?=
 =?us-ascii?Q?f4fG3pilo1FnIT3WxWKQyKXn7K7v1u8qGf1dTtrAIUIcCxSvDAQXArL/UyRm?=
 =?us-ascii?Q?0acviSh/elrJuT8G2LqK2Wn3IcEI1Ap0xx2Vb2DkJSe8NohSVtrgOz8nv2O7?=
 =?us-ascii?Q?dq5SE9BaRkK6v4SjQdEJ98k2BjuuBI99sd5Qd+x7PRO047lU+GT+4J0855qw?=
 =?us-ascii?Q?O/uGcokAC17a1FVTs0nOLVD0a6CImRtbitsIGaXZaT1OTG96IAKavEqP98Vt?=
 =?us-ascii?Q?0ZZR0RmQ5q5q34VZ/PuqTcrvxwrBdAmlkBwJGfH9WZF7MC6CyvBKlOz97M9S?=
 =?us-ascii?Q?DatR359nCxJyNNv2enWHUgZnDIiseaKqQxFaZ4OpUrk6aYvz9XrNrAwxJM1Y?=
 =?us-ascii?Q?Zokc2ee4E/CEziR17osC0zZIdi38lW/XphNCyMS0nmX15OPUydtcneUZJNlx?=
 =?us-ascii?Q?4CfhdqSMS13lSPyjcBt5Q+GCBKBG8IiLKm+K07PwgkXvKmz7hLNaADR2Sg/g?=
 =?us-ascii?Q?ws2zes+t9F1fV5LoBqSZDeaCZDThdVZjnocAquSAH1DVUPwWVX9kjaT2oLZg?=
 =?us-ascii?Q?eV0D2p+6Orw6oRkKibWTloQOUFIonEetHyEsxVfqG3tBTMVdqWq/FG07bR0i?=
 =?us-ascii?Q?0ojz3u2Z5+2KEEKdTj1uoX0mXwyMKX1xSvWOGbzFmcA3WSWrZmc6af+SVsYE?=
 =?us-ascii?Q?sd7m5vBKW+aIsKg5geMMCPOTs9qCpkTN7408te1nDxccUCg0KzSojR0pdYCF?=
 =?us-ascii?Q?RasHPfGNzUtYr4WGWSIuhgZ9qnaECW2OzEUWYUODG8ZDZddC7+UtRKk2Z1MH?=
 =?us-ascii?Q?UmNfH+rKZdnXNP7kDWzDawhPdW8wJDsqtUTxfHytSSOoVSor97gI0QrZVRDW?=
 =?us-ascii?Q?nktkP9LDr/kAgwAZ6i0pNRfgZIelN2Vk0vSte4D3J1FyMeKG7UxRXY8JrHmH?=
 =?us-ascii?Q?60i3xErVyHMbWzBBpqIeJNn2lxAT5WQ/oempjAEcL52aWI8pg+RBIFLK3anI?=
 =?us-ascii?Q?TckJ3WV7rcdTRqBkzyJzoMK4SnnOEiIdNU6bDnzQZSj+txdAwpOov9f/qA/D?=
 =?us-ascii?Q?Oh5Ka2o+CCylPmcqey9+xfYbMcCvQ4H85hFMTokAzzNdd0YUYrDRi5gzfiCf?=
 =?us-ascii?Q?jOsIyVkT1V88QAdycJDKS6jgupTaCr2xi8pC04JP1mkfSHO+SEEFqsCXDdnK?=
 =?us-ascii?Q?VTCT+9EiGs4o+p/Ne+C3BbkSX7DzHXPX2VMGu2BBPWJ0V99obeV6dpT2NNR+?=
 =?us-ascii?Q?N7UJQORo1XA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8llg8eCee6A7q6cbKgtlj6TvtXQnida2AsPsz7ojQCGJxKDojwnMQ0s4vzpz?=
 =?us-ascii?Q?aPIhLzruAu3RggdAi9SrI0YOlgVPFNXSUJfwVxZVJkmITOwtM2TueI2CBjxx?=
 =?us-ascii?Q?UEZ3hpSRx1jM6a7lOB+Ilr9s9SV8qPEyo71CmN0W82Uf6flONWsvG6M+AQMo?=
 =?us-ascii?Q?xNzHlNmRpkyd9lhv1QjoZZ+T65F9P49Mu1hfqIwjgkGxiLU1Xwfk+RNlOAdC?=
 =?us-ascii?Q?yGN1Lx3FNfCd1PqD6E8mE/W+HGvkfhRo8YQrSjG++z3xFIFKWmTGQdfb8Vp/?=
 =?us-ascii?Q?ZN451LrPdF7OkTgWt0BFKccpXHwbn8TdWXUbqeJinS9BBv2fnrDTPcMC/JUV?=
 =?us-ascii?Q?5qyDB3wNCzjrFMfWL9cr3T8ImPOA7eNNs4W2IfJiRpqLp5g5tk8foeIONva/?=
 =?us-ascii?Q?OIAxMAinYOaf2yhnKt5BbqwfyZqli/4bLEkkYrFDzXuBpCTvWfNyZ1fZJvSw?=
 =?us-ascii?Q?NWceV1IWTfaaHSTjgkW0oi/NsnkeATqgFrmIO6sj/Lyw1hcU9y7zqNFl4QD2?=
 =?us-ascii?Q?IbS1qqj2Jf7I8d7eIa7Up5m0y7f/DbavCDdylKpvX7TJwv+WCZ0Uotq+wWto?=
 =?us-ascii?Q?/2RU9vP5pGQEtDu/MzUJDLZkjvnh8918yUv7iyj+373JDlf0HsZWS5Ok+1aK?=
 =?us-ascii?Q?Yly57/i4BuAYZmB1j1kWGsN27ruQsNLKFNbmbLBeixY3RLyb6WLGX9G3HtHM?=
 =?us-ascii?Q?a7UTPZGXd/N6lj3Q2PwABfDU5TvDZZhV2Dy3zq6fwHOMlSlLaxRgKFT435ZJ?=
 =?us-ascii?Q?HXRDNeLqB9H7KqwRDCSjblCfJxz+c8EMvowlbh+31p1Uzom7DDEzEGEk+huz?=
 =?us-ascii?Q?ueotvGfl/T4vYme8I/PBWMBnxKKTSre4DDWNliSrpiNBQ3z8VCE9K97EiB6K?=
 =?us-ascii?Q?2rvdUj3bzpUD+oZt5LYK0lecMOkKOlDTmT9c8/au3xfUsgxEktD+aI0NeHZn?=
 =?us-ascii?Q?XcQknNIY6g65aeTryx84SuN5iHNp8tVBJ/aiCBjHozLXDFMHSqIptGHBXofB?=
 =?us-ascii?Q?qKTQVlwB97oDeAE/xuh8RSWVa5FLO7YR7ubw0pvPjev0yunAYV68wdRNrcE+?=
 =?us-ascii?Q?GqGFkjRpsNCQ7LS3G9NhYPZGS/2SoFToj9Hm9P8cqZwR+0rqiUuVaFhzoysY?=
 =?us-ascii?Q?9q3CJS3FfX5TBdjNAQUs1Masa0zjElgmiBpmz1jUCQVmlRKDspEblH3W9dLS?=
 =?us-ascii?Q?BBANVl4eLczFhRGi6k6YQjykY40lHP28HT2mV2aDZeZfAsKJ3qvoTTX1lGJ0?=
 =?us-ascii?Q?Ec5JuZESD1MDHFsxWT1eSNONjIDgZgTc3o8MlyHohT5AuFHIDS/QPyOkscjH?=
 =?us-ascii?Q?+mMn6CuQ9vmCSPvsU01xZi6gZe6G1xkQO8VRQ5gDkO8DRgG3sjvKYRozHZCU?=
 =?us-ascii?Q?Q83P0eXePVk+f7qR1FEOdaZECZ2qTtekbnhPzxWwcXz1aiAak1eZ2xdHZquz?=
 =?us-ascii?Q?t+Jlyb6B8eSDT2JwnQR1Sq8Jv2wLhoSC6dp9mdeP6Whw6YsObl6b8zlSQn9h?=
 =?us-ascii?Q?4YC6nT54qIoftGvGTYO4XsmWjWwKojpHoVXMv5lM0McLJnfYrDW1Cfc7x9fH?=
 =?us-ascii?Q?HsOzsPL66W7ORywe2Au9BRCQreRg3yy9fhg7ujhb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vup9vZ9zVXm5TZVENbOxH/stBdgy67nommSr6fDsKcD1gI9Exz5foPCRo7Ts1K6Ql0ttgV1CMnNoSpg6zzB0LVgvUz8T7UaY6Q+kBe1AblOO2bOVKok3ZDUm+S2AiPD+8LdXgdUXMJCZOx6xHCy4NBnXR7Vw/kJrelAjjPLyDa7ifNoTjm/QZy2rct7ImkWqytkfzyX28UTed1M8p+qHFK8cc7PUi777CqqFmw7k/no865mCNalknxG2qNnBCsnbew5sMTyKRqdSTxO4A/7KJP+GPr++OFuNDU8pJ/h70nWpmRsbR32jaATMExbg/ukiJ8eOdH5FGcF6HnUOpC+lLPkY6hIix2AVFkdz/76rAJ+jYR85WJRKz8KgiNvVVG5sT5zyN/dIf+y8XxijBuwdrIitxD+CGu5gKwSXnkodIuaahA/0V/oaCUSUwd7JdgbFAoyeazcrUBDwpPStuFh0uXYn7fbwy2AtbmYl9jj5T9ZP8+H5bh8NUVehTkpoMbjiPvfW02C3ZFk7lGGsV0NXfmXRjfcwzyBRZkrNA5oA2TBUXMqKTVzC5OGp/TfzfrO2q7VcdSa/mXhKkCthKH6NeQM1bqvWDPHl8Bf/cAhR8rI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e3b719-3165-4c85-af5b-08ddd983756b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 09:34:39.3018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVzR/ezPc78aM7Rv091nzLRTWfaaU0q1DQsNUBcymnEeiFs84Jsmlduwtnqbz/D2SYilm2R9XmJ7G3/p08eTkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8221
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_04,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508120091
X-Proofpoint-GUID: Wdxt3yB7id9LKBInlZ4MD_AhsQzHCV-2
X-Proofpoint-ORIG-GUID: Wdxt3yB7id9LKBInlZ4MD_AhsQzHCV-2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDA5MSBTYWx0ZWRfX8XbBEo3AwM95
 hEMNVTAa+vIpHwD2BUICik/rDSSZ1o5GXVX21efmNHdGRFULWh+lHYpRltW0BQNtQ0oxLfStt8v
 pQIegheMLK9lhIHut3KD7D+Od75szi4T8/1q3iCRg9O0LAbpJqLwtv46wArCW2nBAesE0UqmQOf
 0wziI79QmzhoPqQHHnF5CN378UKGq+cu3kRYS+DEDfgAXU+5AQ0lplD++JwFKNnAsJeA7gKCR8c
 p2ZzrCaJMaq0uQEIBAQ0yXHDtHqTxyLZAsblo+/x9sFm1hpQ06zEqy0YXyUc3pLqKS7P3ANGppX
 8Y05QRvmUg2RWrobboz5pi2KjqjXKAYxremtkxuL/vKHxSL8Z/bVP+ni03WkvpW+NTIhJ8RfO+H
 I1FgJpvHbKqYFvtxJCw0pGhS2CLYAQloBQTpJJJMEAEGQumwGzVqytbc1jIci7KdKuEJ3V3b
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689b0abd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=LuNiFPBW9M8ngUgbAAcA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: zfdjqrc4b5n1uz6ie3y5rbgupcbb77ts
X-Rspam-User: 
X-Rspamd-Queue-Id: DC3721C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754991296-390162
X-HE-Meta: U2FsdGVkX1+P3CCOwPLo782VjWONXQdQLbfzG1t42h9ccW3Lz0ILl+1NchycH38WACDr5g4mJ9A5zEXmlsfa6gY9xmS0YzDEsZlCa9h1vtrvI1jz6Vy1xW87cxRdo/F5iUFTlSNPIJQYkUxVimycpewZl/OUj5m6+swjlmfDDnsNZYHwVslQoA51G3mHU2a2cQe3jrlmxOgxRkzCj8Kw/gKedRw6GOQlam86Np9lmg0gUznUaVALg0Ym1x1Q4hEX32hyCHrpwUbmoYWyIB+iG26wkfY8Sog/3ZSfzZXLXZZ+J60FV+hU4xDM36K1E1Tz5K0EyhWJHrr5nmFPUioRxPr3U8TGhpMpj988GPZKnTF7mpGabMyurDJGbT1DVcfEEW8w1x0mXG/ngEilrx6riIncVs19NBq4+K7qCfyHxuLFQxqcSOCTdwns9JlWHDylMVdbLt6dnOuDJYjg9KJqQuTNLSbSysv/Z9wbX/6ImgvmcJNhnhRGQRh7KDcFaLZK5FE5x1FF92CrO5wBPNPz2zK9RHzBn4abdgn64lJKoJF/lr0FHkorIoKoxWODA83pT5ABs3I7Y0M6pV2OhJdx46SGDQz8eDTzangQg6AADzLoxcQ7KIf1bLa6B0M+jaEv6Vyd041VYqwalh7n/OvnG3Du/KBvjV2tpFdeV5GQj7UFiqwEZEa4GJQv360+TMUsNXwHXDQyBiZILbNHs/mtdzPzie4eIkjkzRITeXBjoSmPLvuSIo+r4hogFWywWvuHD2r51jt8HGl1oZmYPTlcXt/1FfLcUGFY9pY0+MySScmj+9oNOqmPF1BFpgcuqQemWZW71V7xtdefTHJ9xD7NMXU+pBhCJFUtdl2T7CCt4LXaLSwMDBQMJiBrA7W7K7XTOK0ND43kR31unf2/gtVse554RO8Au2GWFW0z/w/5VHKgHQp8L45D4NBexICSFFuVnF3YbGUXNj8XV5Rpqk3
 OggEXoMG
 +6Yttftc6kWzJi2ZXktjTFyztrjKPSp4baizKLQIvC5ASgyQTyT6PvMDdZImlurkF6WJMP4HZbhfpJgEuev+xavejqm7KpEG+mnEC5dU8wSg/KuZfgBP++0kAy3XVUFOOYjVW3bJbGdY9DdeAncUOVYgM8GjcwjtPWdNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 10:30:08AM +0200, Christoph Hellwig wrote:
> Drop the pointless _s prefix and align to the usual struct naming to
> prepare for actually using the struct instead of the typedef so that
> random headers don't need to include mempool.h for just having a
> pointer to the mempool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

>  include/linux/blkdev.h  | 2 +-
>  include/linux/mempool.h | 2 +-
>  include/linux/netfs.h   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 95886b404b16..c3f3ec5bb864 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -199,7 +199,7 @@ struct gendisk {
>  	unsigned int		zone_wplugs_hash_bits;
>  	atomic_t		nr_zone_wplugs;
>  	spinlock_t		zone_wplugs_lock;
> -	struct mempool_s	*zone_wplugs_pool;
> +	struct mempool		*zone_wplugs_pool;
>  	struct hlist_head	*zone_wplugs_hash;
>  	struct workqueue_struct *zone_wplugs_wq;
>  #endif /* CONFIG_BLK_DEV_ZONED */
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 7b151441341b..34941a4b9026 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -15,7 +15,7 @@ struct kmem_cache;
>  typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);
>  typedef void (mempool_free_t)(void *element, void *pool_data);
>  
> -typedef struct mempool_s {
> +typedef struct mempool {
>  	spinlock_t lock;
>  	int min_nr;		/* nr of elements at *elements */
>  	int curr_nr;		/* Current nr of elements at *elements */
> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
> index 185bd8196503..270ed0822efa 100644
> --- a/include/linux/netfs.h
> +++ b/include/linux/netfs.h
> @@ -21,7 +21,7 @@
>  #include <linux/rolling_buffer.h>
>  
>  enum netfs_sreq_ref_trace;
> -typedef struct mempool_s mempool_t;
> +typedef struct mempool mempool_t;
>  struct folio_queue;
>  
>  /**
> -- 
> 2.47.2
> 

