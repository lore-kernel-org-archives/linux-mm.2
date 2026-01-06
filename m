Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF85CE9D70
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF866B0095; Tue,  6 Jan 2026 11:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0406B0096; Tue,  6 Jan 2026 11:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57D26B0098; Tue,  6 Jan 2026 11:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE5A36B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:02:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 709321B548
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:02:01 +0000 (UTC)
X-FDA: 84302005242.06.7EB2699
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id A314618000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:01:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hqPB0EYa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qRHHW9E+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767715317; a=rsa-sha256;
	cv=pass;
	b=b9jPWjGbj/8mQTEtYtCSgmHCKuRMQwaSh1ySQxzjXubbTYq7+hxKrbxvCH8Jq0ng+qjGrk
	qbXxwywJm9kk0CE+gC9fbR0zW05amzk0QEBKFzhPxohuwC2hGbyZe5GaZ0YaruVQpNnUkg
	dCvnMu0NUww2G2UuHt6vt0OhicD+XGU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hqPB0EYa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qRHHW9E+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767715317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFfCRbaKZ3DKsn0APa97CJUgWiPRon8xM7Fkf1ococY=;
	b=nY8BTGdZWtN2w54L588E0S7fS8brmVwX3qR0t+qJwbLN9i1bEXYTyhSid9+fYV1kkbJ+v6
	pQ4QFkrEAprTk2NAKq+Ep3mDMTA2mSIbsn117/9eax4KotQAqDT9i6Ea3WsHw25gINCdC0
	8cDCcD8y36dhvpGkm4XOv6O1lKVTi5g=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606EpScr4005229;
	Tue, 6 Jan 2026 16:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rFfCRbaKZ3DKsn0APa
	97CJUgWiPRon8xM7Fkf1ococY=; b=hqPB0EYawsomuMLtdpnB0Q7r9Mt1ofg+6e
	gK6XVKQFBjVylX6+ZVgayeyBPn2/N7Le2rw3dAB+DfJ4aDdK0bxGLwpqHHbh3FOd
	T0nflCV/XbJEbEmOi1NxotU03vjnEUdph2WNFRwqX+hh1PYgEX/N4mXMgRI+A7P4
	qJqzJA3wv3lk/8KCjwbd4YpxEyEEljgrRf9QPdOMttj8JQqHgZuxxI0FlMCOtTBu
	+Ge9MD4O/gbntGdrxWNBJGPnT4ZEB01XgcNpgWI5qSXSML4R94QQWiyDjHctwZqL
	RYtNlMSaeYs7U12+sY8AH1080vhmyri+lHSRnh4Gxmbu2BdFjVHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh4hag3uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 16:01:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606ESttx030837;
	Tue, 6 Jan 2026 16:01:39 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010007.outbound.protection.outlook.com [52.101.56.7])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcs5wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 16:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsPXPQ93GLyTBvaeiltzwCp/qS4oo8bwtC3SnX9c6o4UHnwzwCUwtF1jvAO4gbYPRp+J9juslJC7cVmctCuiNsgWgviIxpFAQ2ifPLxH43m8UDveqnXeR8C6XrIDvKVu5TOgR4Foi/UYCPW2j0AlE6OrNkA1xSxxVSZrESmgigdGZ3Z3uYnwIanGuMIN5oM2NKPzy2y+irt9p+wkrzmm2Va2t2tFjCID2CgqviG6CRTqiVys8EP8RtJ//R+7HbO0GFXnT5xH/ZOvrmtbpVnKzvLolPS71ntifNk9sWtGK29DT1+rDTazlR4O8qngKkONtTCxbMohPYVtBdpS/yeZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFfCRbaKZ3DKsn0APa97CJUgWiPRon8xM7Fkf1ococY=;
 b=nbITqHueawr7yUa7PcyKFxfrk8GMtIWuOGpYhWfXGbWNZjLlGBmW9ncWiudvuZFm5FkqpUpbJlC1p+OC+MCtGElWo1Ko6VfldjIFU11/5tFQtXnXoQJ7rj/0Ik6JCPDneUbXyHUEAJsx493/6ESvaKRZq+FGmajFeXJLTT8hwuigsWClS1Ja1Fupcebk2d/mzc8CIz5hX/fp9s/5GL2iKTjSa6pWFlLDLdZKFHmeNkChwfCBZMM11f7dYlHwu8qV3jbvUc/M0RGhBZmggqw2fMp+I9jr2UgyEA+Mkr/4YbCR8qcKRUxQ2HPwduBQ2B72FXHRJY0zYkm8Q1X7PZ0SEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFfCRbaKZ3DKsn0APa97CJUgWiPRon8xM7Fkf1ococY=;
 b=qRHHW9E+gYBW7m1/LjOSuGTKyHPu9qr/G+59C7w+VuOXCjQznf72fJuzyMO6PqGuZiraA8U+wDAvjFmLF2rKfK/ei2bq+7BvFutN8gl8RXUGYUpUjjhHmaylSplRAsL+HZzxtwwqNcBqJ1smvW+8mVFxLY4yRfe2D+DOuSfn8oo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SN4PR10MB5656.namprd10.prod.outlook.com (2603:10b6:806:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 16:01:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 16:01:30 +0000
Date: Tue, 6 Jan 2026 11:01:27 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, aliceryhl@google.com,
        andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-ID: <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Boudewijn van der Heide <boudewijn@delta-utec.com>, willy@infradead.org, akpm@linux-foundation.org, 
	aliceryhl@google.com, andrewjballance@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, maple-tree@lists.infradead.org
References: <aVx4PjdhG31LfjuA@casper.infradead.org>
 <20260106132418.57408-1-boudewijn@delta-utec.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106132418.57408-1-boudewijn@delta-utec.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SN4PR10MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a3af95-983e-4795-5260-08de4d3cdb2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M9HfIDDayzgiFoMhV8vyxaEc683X2/sN4P6+W0SJEtKCa/2JfKScro/HerPN?=
 =?us-ascii?Q?kFNFztdO+eNzNRsBweA4rkZpeuz63XsSOBMASuMfdjKbcWzlIIwQp9vmkuCE?=
 =?us-ascii?Q?H2KqpAfaOVFye+VD7DNq60zs08S/CEaY1zJtQJUyTnuCE7VHegUVKSBip3VV?=
 =?us-ascii?Q?jVZTWggwPQAZ+UEp9e+f2Y0GZBAv+4eh/paojuGMZyA5undHE0OWA/F6jAdt?=
 =?us-ascii?Q?3xj0DFqcqghfNqFWMcKvitO2z1mT6W18sfQu00/n7/mzBMdxiVVQ/h+bD3Ez?=
 =?us-ascii?Q?Szbrahft4klLU+fwB+g2E1xL7GBKFxXsfzbGWaIBtHUwc8+VLAVosIcDhrYj?=
 =?us-ascii?Q?sJ8//b3pHexhauq9DC7cAgmMUo4XE3R1/kSA8G5+UiCnXvbPFaYRTFs0Zyl5?=
 =?us-ascii?Q?+CkTbQD6CUkZ7HaAYGs9ZjsnLr9G8N9hgC9THZLuh7eS7WIvx4qZesp4k599?=
 =?us-ascii?Q?TREy49GRLCH9+jHmvJ1E8nI0wEzZbFxz5d77dgtbkVhtkOtOW8vU2jaW8+cy?=
 =?us-ascii?Q?JmDa7AQ7+Dy9xvvZ7O5ZOKgQdXTfGjIbYuYaAfxAuvDN5QbnvrOET1IBTibp?=
 =?us-ascii?Q?ZPW3f0ND1OkyEGcc45HGhjPHFnn58/ucLODlwomffkrEN67rZ9RE666gY3jL?=
 =?us-ascii?Q?8CkJ6GMwpR6qJCcMM2i+Xza8m0qEI2jwTmCiFzVQMiEP84Zi55VsnYvUTuIO?=
 =?us-ascii?Q?jscCOHcpBFWQxKt1KxnnT8zYElqUFHE01G8cQU8IhDANsv/V4fZRZ+CrXHLl?=
 =?us-ascii?Q?cGy0jT1T0EXLjwbASIGC7KjLJ7Zcs58qfPYILKWHCCNq7PTc9FAJ8pKFBKzW?=
 =?us-ascii?Q?eY6R6YyWr0iZC3QM2FwOhr0fCXKqJj6JvyqiFNiyBQT31Cce9p1S3cCTPhcT?=
 =?us-ascii?Q?wGK2xNRrqr6eKTdLB4qPpIA8A8pxIoblL1w8I03+RQk0dfltSIULj4F+xPGe?=
 =?us-ascii?Q?FoOZKSlHfiynu0MZVbcs8M/Hz5PFmXgRgjco1dJzXzq/Max2acTPF7qENfAy?=
 =?us-ascii?Q?H4uH0pEQW+94bbGITEMe1xcNKjrBOHK2PJOza8NFPlPzpgqTMOXb3mlSgXtV?=
 =?us-ascii?Q?vbkwAdT8ldqReY9zVTkngxKqHB3SkptE/5f9LOKcBIoOcsCfNw9FbJucjxnY?=
 =?us-ascii?Q?HFRbBZYK35YJze1JQbItsA5ShD45GDhfLi40Gzz3cbacSQx3zGpY4NKXGV1S?=
 =?us-ascii?Q?/2urKb59PLcqZqT4EIGNbNPvUCgSakK+5sMy6ilTP5zNiTmshCDQVYRHp+5/?=
 =?us-ascii?Q?TP5nbTHgYYQ5fbzG976FPzNw//NVHkHaVx0b9LHHM5kop9d6Sp3CaDw2biwB?=
 =?us-ascii?Q?bMsTx0g4P2wES5vPJP9DJE/UV5HfpgxtXHxuvmT3JlDlO3cYvhqLDMPjg3D/?=
 =?us-ascii?Q?NZ1MZW0G5pcsOlM2fSpdasXa8A/iFG09DarhyTz+BUqaJPjkcvN8idP1Mlng?=
 =?us-ascii?Q?FprEUeMxspvcmWHvCp9M5WJtus4SjgdF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QxLrEOTHWSNLZe0iz5AR/AqX7DhfO033FDuQo1kcvC1ER9gXYNKS2ibK7nZw?=
 =?us-ascii?Q?02OCQKSdzG3oAy3rIfxpBdAGqZMFD+pLtSSFzs3xTEZu3T3yasGrWVBYG40U?=
 =?us-ascii?Q?xtVJpmkLvbJc+grc8i3t9J4Wy8wGWdRW2NQWBttj67JPvd2Ig4pQ3uIuZqOm?=
 =?us-ascii?Q?QF1vO2CQBlKTyE2cN0Ah4UnNqCrSHjr/aWf+4h2+iXJHoBxEAkCYXDbOf1VS?=
 =?us-ascii?Q?HB0s1gwEQjYaNNpmLPn73tkp8WLES2gUI0Y9mufxKTGGX/66eu4cu+CGW2JL?=
 =?us-ascii?Q?69BK2q2nsVJ77dP+ASWDboZTCUSNQLwJ1BYtxe/EJ9BNCaOv7jRTaIx3kihr?=
 =?us-ascii?Q?3GBVSJlaP7vnou9D/DFrmWi6lW3a+ybR/wPQBpM4wIk/9g9wblk5Qc+Npc8q?=
 =?us-ascii?Q?o+tg0R3NCR1Q6iJmrayI/QvM7Xhm1QiZf01glvOg+8lqyZ2ZsqwrZTNwpDGO?=
 =?us-ascii?Q?RImi9N35X3zhaOTx4jTdMuj94DNTv9p/hQ5fs5HLItD7kREI6CNFs6IKmpr/?=
 =?us-ascii?Q?BcF2sPyB1FJFN1mv2FaNYKjJlTn23pTpDOwpfzcGSgBb1euXg7wgrCWMbqcs?=
 =?us-ascii?Q?1zUDiJUOrqEe1BjpXhufCgGoOZv9m4cI+u8ECX7hbRJRjUXGWMPS44HKbPy9?=
 =?us-ascii?Q?Euf+b7dWRyq4SNPR1mKNk2RSp/N3QapjoASFVra4GR7Zk/ZiICHuWArCHRVd?=
 =?us-ascii?Q?ggYvMrQh+f0A2a0bAjs+NkQuHWiNl2Zv8GrFkELpaBicQggl7NSfReSOb6P+?=
 =?us-ascii?Q?J35vfezzKekaXazrJcllVQi0FTXpRmdR/dDdYw8pGQujlyw/kvIJVhcGIz7l?=
 =?us-ascii?Q?c6egLs7/pSiZQ7B+ScmpDFTcU4gXecaT1RlCr39TY3P+BXXkV9G4X4T3efoF?=
 =?us-ascii?Q?ZkK2qVjTpqNtBdBZkbFIBnCKMESUVyZW52VwIMUdjEc/Xj89sn2XhLfIaAF8?=
 =?us-ascii?Q?Y9Z8MdMI6i2yYHZfX6nv+w2RXJvxCIukGUdE/dxx6mhW/ttggnvf1gEOQzjv?=
 =?us-ascii?Q?cBDGfH84I69gd+BuvD0QR17xjYXKD3iyWUs6ONQX5lP3+rkUHmBvbIBW33xM?=
 =?us-ascii?Q?GmSt5GmYiy1TWwfzc1Ka1OZU+pM1unfB40Vq7k4ssPUE2QBDNdPPcaJ0sYAr?=
 =?us-ascii?Q?PKUAHPjFnHm2HrDKACyYyn4/Q/+zv44EKGUkT7dZ9x+U3VS+bZNDNN1Miw0l?=
 =?us-ascii?Q?Dhhfct2uV4IXdzBP2JMcF/lkkbya/ies4ktOytMTg2mSC3fXoeur17wgKmNt?=
 =?us-ascii?Q?qLCLUKu27RWk9Osg3Tanaz3kmCDUx5Rh64+ss4xOVsWQZWXoNPar+2fv50Or?=
 =?us-ascii?Q?EWB2wpAOXeuCTOAcx8nSj6rm/36RtWvvGb5nL2hzOZwlmEpjPmIesMlG5Qz7?=
 =?us-ascii?Q?ZfETaWAi7yoUMYfvBS1DOx9asOhiiELs7U1bI30Sz6QgRvMVQ8VjXLMtN76D?=
 =?us-ascii?Q?Nj07lCIvvWlb3fB6d8tvKBGIcCe0m0LzE0FIjttT1tokwiYxksxgc8uDuHkg?=
 =?us-ascii?Q?f8S2KPPcfM4kJRxkeUYJP4UnHjY/SDYa/17+9s+PQYSIHcC+rnoyK0Ji4pee?=
 =?us-ascii?Q?GoFKx+9oYjz10/jF2VI/NFPZVteiycPVpv8eWATzrudT06amU1VcwcjSgCdZ?=
 =?us-ascii?Q?MN0LdnE+8pQy9a/Mb+s8+BGgL7Gew+8j0DHy+cNyYAAXhBKvhKfNMXbUnSSm?=
 =?us-ascii?Q?GVXeI72/priAvATJylckCf3nKRcYTObETD8REFwIw4SZZqORdIVjkCcS3LH6?=
 =?us-ascii?Q?5XdQEg3aTQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b7xLzjTBs4GN/6AvNU1R8UR3orUDlo2nkYXZmpsW2RbSNIV0gqyrYNE91boXNKfcyNiw/GJjNCmdk0918/skbGvxGipmSkTnNcfZklimh7vTTzyKQWhAWBLRdZ6mmtdLbbjnsJEtCG4ZGwnYnSUMDCvtnofXHUEwYadCuQvjoG+CqgBOzosmZ2IjSxdqA0JL69xZ/rdZykcKzGyvJBhnVaNGdet1J21aQSiKE2VnpLkQeuE6NyvQQl66f1fjubRLw9XsWc5jXYmxB+wzgOwVnsqA438Xl79TD2KxZckxIAND3PNfR+TUXgHtVBw1YvO/8Lr+vq0Udr5mcAZBKjP3Z6Q1ILPUMZf72hZ7WoGxhHd8THnw4oe7QnNaTkwfQz1I5LPjowun7Q2LLQHnmOe24o8pAqfwlwh1CCQUdsBav6ixnFmFF2fM4DP6xAMsMBGVssHc4bMzxsnOl+rb5hwDQUMVEqKj5H6InfP+AVbzi0nWqE22JFlD46Bi8Y5/3zPVBm72JWvruZ8VZ6u9pAzUwYaJr/Re8c6AbX4tcgBqOjAhPIB4ibcibAzPICXrHMqt/dZuCrrcmnXEiNAve0ijkicU4Dn9fug6ZPqFhBf/UiE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a3af95-983e-4795-5260-08de4d3cdb2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 16:01:30.5034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4NsmZ//DxL7GMndhylpGmdK4YcQX89cp91zyCIiyEplcjAf3qEz8+Ok4qcHV83i6fotTP3bMGO4MnkHXcVl9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5656
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=786
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060139
X-Proofpoint-GUID: VXH4Hd8-20tk7WeRI9tpRjIKkH6bA2Vh
X-Authority-Analysis: v=2.4 cv=M7JA6iws c=1 sm=1 tr=0 ts=695d31e5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vZsEGXKXAAAA:8 a=3jUtD1GJ3pgedRY084oA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=DNVdo1jukY1CbBonMcdR:22 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzOSBTYWx0ZWRfX4hcVisjVF0Hd
 lEPuhKC9jxSy+BtJS6aRFTndQi9LWN2VyzI6OVY9SSZjlQ95j8SL3ecQDyY6ZESnglXqte7AUQv
 jOPXhEutlkMXYevIRuLq5COhz1UXUBz8skZvFyS8yrTpkYRvaOTAnORJQ+wMpzuwT75pVIgv4PA
 eXHTtsNVvy/F0ys9uYFMmrGDKBq0bYwuJu+m0fm0ncAPs2UKlusBuPXEqqeeaPcOFWqWmzEqjOQ
 IAtg2XfKdCy/Z6oL2o4vPfuyBf4+mue1ZbuCZuIAsgql2IqErtBkfovuxrJ4xmOS5+8CZHt2xAZ
 lPEucwsMf5INdSwuGfdniLXw0noX8+ZEwnrRccdPAobGjdoTWeCiYcnmllFvZwxJdheRCS6hjKw
 3Xf5MupGCKWQlp2up2hiMcsg0R65iCZZkBPQPDZGVGKyWuplGXojEmcaA+UL/GInReT/GutaAHt
 beEACJqVr6Rnh4o/mvttzbRNYhsETZOqr37HMOZs=
X-Proofpoint-ORIG-GUID: VXH4Hd8-20tk7WeRI9tpRjIKkH6bA2Vh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A314618000E
X-Stat-Signature: yokbwsgxjydasmqg78ukhkuurdzhfqoj
X-Rspam-User: 
X-HE-Tag: 1767715317-857876
X-HE-Meta: U2FsdGVkX19wOLZfRxR0mPdMVxUbIraU/6R97hzCkOsFfK6Nr2zXnwBQfpU7+tqNyHJ+ggbQlAHGuuze+Z7DXmNDCT6TNRjxWUPxZb6zT3uh275ExDhMdc8D2WDE+3PB1qcsh+haAtz5dZ28fEk2D6K8O5QrxQQhy4SVh+4IWM1UIsVPes7MmO+1xfkLlssyuuxdsP6PGeuA0FKDi5ZN05dqdp0VKu5Ty8tec8lLCGy8YX4X1tRlw5gSJ9Q/KhCk7qAOvLY6odfrxU+9juhsA/zGhkKL92SNLsI0IBAv58gmXPS3qJfLVq9FllBpaFeQtmFaSA12ZcZCnyI9eba146EYrJ5aEOgBFAqXw1JHjqosKM1qNuPxT6y1OTahhmvRJeMz1AWRfNZBy+RQ27dZSsmddOMCFnKyIaL9YmaNYRwH7Bzm75fJujOHFiex+bK8oiyvRazKzK6VsVcxb0ILECzxPR83m+cMbSicaKCS/VZ0iEr6LpNuG/ot76RUQKn9nmbnz2DdsswRek4KRKhfEuh156tPq3mYJkf+X226vpLnSxOSnAOd3I0BrqJFHV0+qJQL1qamXTpYbpOlrN+jARoZvGDN/QP6Z0pj5m/4zfN5wCV1VPQpk3VnLA9Fbmxl5yuRW44P/gDOsTYpQAjUeXfKGM2VRVGncaWko+wQ9a19MVon3/E0n868PAn8t8+AvoPhjQlIONP9/p1wVL9Zl1iJs1V1RerBk2m1FvYlO3yMX2v4/cEUskXcaVqaUw476lTlWs/4SW1b1tK51S2KADkCSXS1XI3zJNJjlFemD9xIV57LJPmY1MIP+coSC2nb2wZuPV4THhBzj6JzumY2eL/yHDfd+5aP8SxCHn92sHkFkYVL65Q+w7GPDxtM1C7Q8JXPMMtInaOXbW9QBr9tvacStode+qlPHh/udyTh2HbidhEFldOtrLx2GtLLmdavS2DozHsEb217HLiPhYH
 mV+iNfMd
 s5fHzKicxoGFgr+q6S3G2GMVFxng7clAL1dysFH1/65EYcBsxACyQwbdin97gDU25jU0DNRzKTLRxLv6kLqktvE81wLSQ/hKwcjzH8Am4ZMP5ztQYQsq4hks2uXONCyIQ55/MAyvwO/tYtzVRXDlZRM8RMEwOIgnrTOaPnwDB+TpBttTjH6HUpWF9jbumM88KCfz7fmyI25hLeiNUq/VMTuKTxwJWRfjEe/7IxTdGzwHjnVUhH0op3eb7UOEuqBYOGjKcAUVGnwrK/om1q6C7Nc6OlS9bTLhuk+p8SI19dvIWIyVfqf3NjOI800fJinb0MsIFWn41fUoAAo78xRNc4ugbWOHaomaCe6gGzCvt6h9BHH+JeBJ3yCGRb/xnIM68XtGDYMWMRVDREMSoDC5OaRA8Ydj+QRIaYRIkjzhRG7kxyDWgtqtCgKWVB9nqs+lLPZ7SmOSss35LW6G3nCFqFrh/1PEMCO/mKMSufkYE+F2HU3Bu0NQqGSYhlf6z6rC1s8XipPrVtRp9ATuKviWdygThgqaemMcELrPUXBabB0pbv2QOYRYcbmUtFmS5eq8caq60gXwBiA415hv8kKCEjCRFY3/1SWBQpSp8zIJ2OalHvciIvU5OXNNzSC2n+zVQDOSi6HCXBeM95tWnocvGl8UAqGJcsaAtA1Z3XLO9DCTRvSL9R8GEJrbHzX6Gb78Dby/RWJUhMTg0FIZvDAj8ihq8FRFm1e/13mDbFO5MXX9bglK/UTyxhTe4+MzgiGMHWF3SjSWYRTEPDNifUAColSyW2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Boudewijn van der Heide <boudewijn@delta-utec.com> [260106 08:24]:
> > Surely this should just be a lockdep assertion that the appropriate
> > locks are held?
> 
> Just to confirm: do you want me to remove the original runtime check entirely
> and replace it with a lockdep_assert(), or do you want both?
> If it's only the assertion,

Please do not include any runtime checks in this change - Just the
lockdep_assert().

> that would mean that production builds won't enforce the check, right?
> 
> For v2, should I add a Fixes: line and Cc: stable,
> or should i leave it out?

This does not need to be backported and does not fix anything.  It's an
attempt to protect the user from shooting their own foot off by using
the interface incorrectly.

The fact that no one in the tree uses it incorrectly means that any
backport would be for the benefit of out-of-tree drivers, which we do
not support.

Thanks,
Liam


