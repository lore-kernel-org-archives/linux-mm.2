Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806AFD148A5
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46346B0005; Thu,  8 Jan 2026 01:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F046B0088; Thu,  8 Jan 2026 01:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF63E6B0092; Thu,  8 Jan 2026 01:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAFCD6B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:22:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3859FC22D1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:22:24 +0000 (UTC)
X-FDA: 84307802208.04.7D2BAC9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF9B720003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:22:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DUM8TSr7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="I3Rpsw/R";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767853341; a=rsa-sha256;
	cv=pass;
	b=NB5/iGYFSP+7UauZKveB0+Gi3b2UbpCQtfQaIfwqOQlF5aBTxDdXs+7J9/BmEC4oy/zplH
	ZwX7Uj2ybwhqf0IuJdu+RZiaD/YNdL2cY3H2yjlZLZYPpV77e07diOwmOeaSktXr4hu76v
	N0SCOuVTE2RHvfN4corlnvDS2A7TonI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DUM8TSr7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="I3Rpsw/R";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767853341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Za3PxFACHVDhwbCgaDdHJfu7L+wrWICoI47RvHX60l4=;
	b=TxcXOk1Q455eRHM7hEGJjc2GZSeYPwWi+9hrnIhBUPZ4ODYz+9/Yd3fmb2Dk7Ek/xWN/Mf
	6JMPGRFtWB+Am/auAPSaJ3bujUYtsEodao5e7fw6KlgHMtZNqTAYps5FyWYnMKLb9mM2Iq
	GuwlT99AbjpeOPWCUpgUqu8mQlRSx6c=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6085ZB1k3613024;
	Thu, 8 Jan 2026 06:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Za3PxFACHVDhwbCgaD
	dHJfu7L+wrWICoI47RvHX60l4=; b=DUM8TSr7948ttq4vKTdytKdOqDNDFij7+P
	K244oQahVBGkBufoZjPLt//fWEqJVojXv7vyfs8dEBHu8GZBSB2fyN9jZpX1tcS5
	5t58rLnwM8unbDY5eKqwtPu9iYgknHQO4rHzvfWodIY5g2m1Cg9+4rngHR2LZraq
	5pEKG/5jPXiiIBcITIZRGwEJltu4ruO9JE7k1MqkcsYG8PUAlDm3xZbduTIBh9Vu
	qoSZU0a4Ok86i6beRt055IFgJ9V97nkBErOEP7tjyKQ2m/+d9mzE0+D46ID27y9m
	bmkz6eWIhYY+a+Uuxxl+N0o2SNA7eUC7x6cSoZP8M6XTXpULm5ig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj6jj815u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:21:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6085XwIo030886;
	Thu, 8 Jan 2026 06:21:46 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjerbh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:21:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZMPsIuFzASoumX+FCKVXM/XUBI7hy2nMKEKQcNW5yCvBBvpi5NRPEV6uT7mtYYjWO0J6W9hV8hUr2hqApcuqmypBEUdEZdb4Uni615K7gG/XDkw9rMEFC/N+cWvEpUUvV/CemATi+zHVy/9+zoC6lD04nn/NljkYiemRbTXNKIksSDdUS3QGXevDfdYO2zY4YHkBnchah+Q1sPrF5Bm4xBYxK79KhKlqAuPBK/B10VaQUpWGZOkdjJNsTtWwVTjeGko0pdqThkK4sPiasneDM0iNr20WmQkdIrXKTXiLgqo6Cz08JeAipgLXMMbleV9szlT2MgQ/1ip4PIEfbxGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za3PxFACHVDhwbCgaDdHJfu7L+wrWICoI47RvHX60l4=;
 b=hgJdxOWp2u6Tv/ATNBsaKoNYGppUNUw2FimrmLyuknUHVzPATry93iN98rfGHqbxbITgNTD6RpX3cYBPlAqG36JQIHfgAmHeMPcS55R22YiF0T3xjPCRHCQngP4j7HvUn5TH9N0fze7lYEr87wXjbCzXRUAIMdladQNLXRCvRapNc5oUQc4CGG6Ds0jMmefT+8jF38+dynFwYkyk1N1ziaE8JkZAku15cgsoD7aBH6p0XamQwF/L0+bzEuERhCJSlrO8qY/RVntiRrntttsqCGj7iNejd2mnAIPJLbVUQJ7Dxz7U3N4O2K7vs5OHLgfRu529MIQzF6ik20wI1j27OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za3PxFACHVDhwbCgaDdHJfu7L+wrWICoI47RvHX60l4=;
 b=I3Rpsw/RE7JwTUbZ5vXM3ShkqK1p5HvK4vRTlglKXQQBDpyMeQ4JTIr+eT2D6QCz2LSDhdcg9GOBL2+lXxkA+gSMGdKbC4Ew5aon36JLpky1nTRB+4U8+TRIB+UnIuvgVnR4ooxBIsl0fZNhzLkkfhEpHQNUk0JV0O6YbePa/9k=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH7PR10MB6356.namprd10.prod.outlook.com (2603:10b6:510:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 06:21:42 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 06:21:42 +0000
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107100948.a059084c9f8dd8cbaf864c57@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v11 0/8] mm: folio_zero_user: clear page ranges
In-reply-to: <20260107100948.a059084c9f8dd8cbaf864c57@linux-foundation.org>
Date: Wed, 07 Jan 2026 22:21:41 -0800
Message-ID: <878qe8r5e2.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:303:b4::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH7PR10MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: fa44a0cf-74d7-4c78-19c7-08de4e7e309e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GOY20k4dFuaZil28XE5X1rI/lNeOSAQnFZEdOlJ/HJ5rcoiOgZ2PIv8Uv2q7?=
 =?us-ascii?Q?hhv+7mc7ex8/gMlz9UJs/i79x71rpuvwm3E1NNcWurYp50zhi0sNrRlL6tdl?=
 =?us-ascii?Q?xAnOo+V5ajIgubxAsWyNOau0jvZy1kpb4ay+jZCR8FZRf9aoJC8p93N+lpMM?=
 =?us-ascii?Q?3Ag6MVdmkWGPUVOt9mhDRNjDNgteo6kCc4X9cXO96XylyOwfPD/pypzQ4uKu?=
 =?us-ascii?Q?ukRg3iFJDg2DqXnQ4YcQ+v9Lmm4bAcKO76NCN1bRiZGGCf0M48HnIwK1cDuA?=
 =?us-ascii?Q?lpmBjZSmz1kjbui700k2g7nd2dcEj957RBRXYx391gyFjoHO1PyOMbwFy+CQ?=
 =?us-ascii?Q?30LuogIOKJJD+x1BYQY/OW6ek+M7TILOf8CHMmLS90oa57hLJMDNS5cNTLOw?=
 =?us-ascii?Q?45NatZfdKn845C75+t8Cxv7v6HGMd/XOMBYQ464vbWV2z2lTvbJmH9HFWlD8?=
 =?us-ascii?Q?0GMm0Pg9bJvyljt/ddBqaB8k1cTyto2IEd+wlxHbv7yDwWTl0JvraCv2pTlj?=
 =?us-ascii?Q?mqaTxIhmujgDvdfLBYBdwJ1yJxdl1xm+T1eg72cCoAJwZySZwkFBwtZ6aaUv?=
 =?us-ascii?Q?9CX+j1sdppCeHivTRqAai8oak3dUQ/TgeR3kSCItBjmla9QZfYO0BC0HBP0m?=
 =?us-ascii?Q?FV6x3XfpWT6Pq0PivNeFX/8APHIMEWdjJbPawai21HhSMw940Ve6WVX7D+92?=
 =?us-ascii?Q?6HUjR77yrDLTZ6f3oXqoRfktkxn4vi1ZjSo8aKD60/3xKyTFoDFc3388sDxK?=
 =?us-ascii?Q?aK/Qrw9jyP8NN62BR3LTpVUj6Pmhy2hd++3JsTapEYVDknYoIxl2pxh+5jDF?=
 =?us-ascii?Q?7iruS4paewKh30rIBzP6WornNZ80TWd9jfiZFviWL2j1oGvAFm7nFPM4jP0S?=
 =?us-ascii?Q?pZA3UvFGg0pDjnyuNzxOJItrKo+NfAdwL9KJ6eBHoFh4MAtbk1L3QQd/Utbj?=
 =?us-ascii?Q?sVw6HOGRayzywCkJimMFvrLZdsp4gUaLkJKtt4EZY7S3E6OC8MQcPS2MzePC?=
 =?us-ascii?Q?uQjOqPAT7gYbTBY4WfTvd4XeOtCuVg7lModUWT9RHdFopbLD72uVfO34qfA0?=
 =?us-ascii?Q?tmwEDAgueEvUoQcKSi2IiHIC3YSAyQPr6IZHwk90BuBuP+39t+L+UpWwObch?=
 =?us-ascii?Q?cFzexd24k5P99P25urKlXy9zTnNJ1ZIKzOp4iD1VTf9aR59hZkd5IwZariRq?=
 =?us-ascii?Q?XCjd8ckICK0QmC6NwxBe0DYZLxNPXgjT3ILYdFUw6Vf7Po7VKCXZc+8cd4VE?=
 =?us-ascii?Q?5KesCI4Vd6LygSn/BYePp9yjxJO5FAKOFRCowbLHm2KwbsPQc6bRdQovYe9r?=
 =?us-ascii?Q?cIOziexgk0sl5LBTpEiytWhqPwpasJzZAH6JrUpyadYUHpHD8c1aX48sKFiv?=
 =?us-ascii?Q?FYelJvpxZX1FCqT/lAZ5ks/bHBrI5NYlbrDPJfFEyPBymyusXfhUi1uUD63s?=
 =?us-ascii?Q?1XCab1ms+hLyaROD3o76sSrmOPKnxCYM60FVzq53lv+8P1ajKFmkDw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AJgsaiKjAxGR+SiayxprB8/JTFQpb60sofUqW8qeNdy5OTnrmgc6UJi7oh3h?=
 =?us-ascii?Q?KgRG02yR81te3WJSGPO52iIt4agj535nAavXdul+DfQCdapJHPBWgS1MS82D?=
 =?us-ascii?Q?1ZIYlaim7SBruYk2ifd6vobS4hZkn+OZwnH3VjGg0KFTEUBV+n7FdFOqIixk?=
 =?us-ascii?Q?Fv/sQq6W7TQ/U2yDexmGuvrRjk+NmWJzAXEV4PCndT+wxVkSLiJJI6j29JO0?=
 =?us-ascii?Q?ufyuGPLBf0io7J3hFXPB1ORKgP7zwl4dUoZf19IxF9xsG8DkudCFO5z2Oxrv?=
 =?us-ascii?Q?3G5/oN7tcSLKYVjL5TuDvO+XvrHQ1hx8Eu1lnIvs0K6o1+YWMjICUfqvRBYI?=
 =?us-ascii?Q?DSPcpdQsn5pIkkNRtXCt2kF/cotlMMCkduIV1c7sACHB+eAcYiaVMKK+GGE4?=
 =?us-ascii?Q?asZhYbdwc7gQNIcWf7Evw1tgABG97QSl39ji15cfLQC1qPkVXPJCnleRPRcv?=
 =?us-ascii?Q?0hfNuC2YF9zCpQNe1jyjpaeOYbbdIFdBs4cHLmt/tJXMlurkeF5FuSZH+xCs?=
 =?us-ascii?Q?0zR6Ctohlcg3lBz71cscGzfmhEiAW0CO/VEY0WIv84NG9QW1nJOGQCpZkY+4?=
 =?us-ascii?Q?qWDfsPCY0KWe3bn8ap24rSOTOcDnrb+ZEPuxwH/HX5s7/wO7/TrWBfsjUnIy?=
 =?us-ascii?Q?nuN2aq0mDW7GuPbRuWgvZQZx0jL48RYEN8KdEy/8WraW53EnMljrIqL3Qn0c?=
 =?us-ascii?Q?BcCFErGPGHV3uZvnhDV+xJ7ic+rJhlDSGCIekpd90rklIMOupEYDHaCCDfdq?=
 =?us-ascii?Q?waK84yiBhdc8ignOg3wumRBhUfymZbsBBrSeWNyzgewUqeJ7zGk7+bcB1kBP?=
 =?us-ascii?Q?fXhKNduPqHLoHRNZ4Ba4Gmr7OFvbwoIWLKpW7x9hScIExJmlsdk97AKVKq0V?=
 =?us-ascii?Q?fZPMn7/ynOx9pKYn9ikHYALQU5PCYA+Dztwb2P6MQnPcsq5PE3jFRRRuZgf8?=
 =?us-ascii?Q?10GZTiZVvzivqY1MwNZqlWNG+OGXMJfwOfHaJWCWqb6Au7/VfGs3vVgdKQNX?=
 =?us-ascii?Q?jPq8dwVRDo4C13AbBgv9gAe3YRhKBbk2qWQ1TDIO5X3UguPpVFLUvQP3RqCy?=
 =?us-ascii?Q?nVsDir4U5orKtduWuj6pJRVQM74Auu0zJCxN3Wog3r8KZjGWBk/g/xuVHKZQ?=
 =?us-ascii?Q?gu3glxis2vq6OpLYL9iBdHhaC8sxiVkFDh4hZ0HEMpMDCeARR3ISsgvUe0eX?=
 =?us-ascii?Q?V8rehixRlpsD/KwVudttvfWU+i+x2/X5jeZLnm6QqBM07F7n/2YmnCIHkdgm?=
 =?us-ascii?Q?pBxA7hMfstENAjoJ1xKe+tHox8zRN4/1WkpW9w4Sm8nmQTALGsac5l9b0Fq6?=
 =?us-ascii?Q?i+fYBGjOlwLS5n9/HizqAPikccg7ZeSj6wbqTuzTqosjvfQX+OCn0oNsj7Be?=
 =?us-ascii?Q?dSA2LCRJmHfD6VmzHL520iN08LJDoprrOixLhY4sv13MCYjKCdTPlaHuhEqi?=
 =?us-ascii?Q?i9is3hgvxjNnjd7xqmQyJMP5Wyl0xctL5ExjDFuc1Ry1/irHSXUssy0TL8EL?=
 =?us-ascii?Q?tNIUCEqI90A1gVg9sNAXC9Lz8ei6duuibl7oyNhsC/vei9LViUBlu2R/qcyg?=
 =?us-ascii?Q?he2u79BS4iQ8rOHm4XVgYOJxi28ubQ3YsyHFkn50RceIY1LalgbzZBCJnGpW?=
 =?us-ascii?Q?xcxUpddT1DVmOjdJJWXJFGE7tl6cOQ61vM/dkPmJ/WO0fK1dgVfF2Nms9l+a?=
 =?us-ascii?Q?ogWTQa7OillUKp1a4uVe4BQ2ZVb358+mmbfhecM7Iv975x0VgLzZ1OfYZlmD?=
 =?us-ascii?Q?rbG6LPbqNXk4nYwBfUfiI7JuQcFsPRM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Veh5GiDmsbQXF2zPwhivgjl7vvLAEV19cQ9R42gV/g8zaCLyFiEFjZfabc/BgXp0AoBlbuUS6q1QJFNqjvdDo68PNw3tgBMcfB1xSYcA1RTda4581CCvhSdObAfyCWgmUUAP7ved4uCw8BIVxiTXKh6uCZHEbHt8uBSetY/+jaARNLBu4ioz7jvatqAz6Oe892DTlxs/EYPdzrwaCwbE330XvknIaI+GXQw2nYL6EZoAPJ0bKEsHFAF6r2GCF1rrRQbome5IpLB2ncYaZCkwpTm7Q1kGV1IGzuY1lBbjXg5Lo3Lj5Q5tf3beZ084RKsf80m0A9bQDKBZaPNu8lbOWif8B90fjZT/AUi9sm1yVg74PNY1fEJ/jwqFeTM08qXXSsyrDwZxUa+W8ZXCjdiNRsWNm17tzJfHpoIRQg8g/5pNdKndfYrg3+E6gU97JqZOTCInTd7jGprzgY35bHXN8snj1LZTY6MFoEN1fq+P9oWH2HN/tgAo+L3ywIb87HowiL3vsrJG59xKi9TwwyFyL2qq5Do77pt2D4zsywyxJMjAPQJaBn8SbvhoR2Xte3yZYbWLNXdtusbg7Zh59R3P6Ik8qDmVA3YJkF+SeqM9/fE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa44a0cf-74d7-4c78-19c7-08de4e7e309e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 06:21:42.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kIRxr2DRuGzh639Vxux4x4ilCoShcLU8qUIqCloVQeb41buKEXOb5DdFxNfXH/i45jmAsdCMoqvlC1Z/pYpW1IZYA31vHe4MpxxvLLXx9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAzOSBTYWx0ZWRfX6DSwiKzrmdFI
 h/SxQIYzSoOyvWpzzBEwO276r4eY8pwHIQARbiuc6mO6h6zLZWG8NcvcG1MYuX8/kU5ARRR5Ft0
 eOkC8U33JfLXrMW6d/aVqBJgyTJc4MoU9Fw42l5rAadpzktT+A0K4WS+R8or0vKMacB2xnf4Bmb
 /aNRX4b1eztHPP1yFJqA6Geoai2/N4YxjLD2LDz/M6o7MOiNl8X6qBl5bzuSCFapzQXwpcAGL3F
 aRwYMHOFMLauE7VxECnG6IPhRrP24lo74EdAbcjhbyeAKT6hf/CIkO/9wti7V+OyzzKhxv5JBoS
 qqrDY+zYH4r/UWP1rZ+6lX9hKOOeLyxeyudf0xSKI2c0O+D0LIV3BE9phw3SGIYwEeBa2vEWXe1
 nwBQGGd0rGevavlw1ztfHgEs+WAHHexQYpS4IpFmUN5YIZodpcwRcciXq4UafHzJy1ZMhegBn9J
 DORMeW5eLpqxFfMrGfzO9zVl50+rIrBSe2UIEi1c=
X-Proofpoint-GUID: EBV8IpIFf8FaDbvLDXUtPmxxKQm0EAc9
X-Authority-Analysis: v=2.4 cv=WtMm8Nfv c=1 sm=1 tr=0 ts=695f4cfb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=XMEzelggnThSdzEmqvMA:9 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf
 awl=host:13654
X-Proofpoint-ORIG-GUID: EBV8IpIFf8FaDbvLDXUtPmxxKQm0EAc9
X-Rspamd-Queue-Id: DF9B720003
X-Rspamd-Server: rspam03
X-Stat-Signature: 7qsfe43mhejxxuudedzfprgn87odyfqf
X-Rspam-User: 
X-HE-Tag: 1767853340-884113
X-HE-Meta: U2FsdGVkX187xtIjAPUR2sjwEIrspenMi5jI4I65YkJnJH2QC0ZDq97ZQqBONJuph5a0V5CNnQvw99+7iv66eQ2dNXU1lsmyBGTw9PdBMQujlTIh3DvB0P8125HbNxW7T0SQw0UiXvWD3bevi8LJCNIA85QoiPEiwue3v5dutfo/60KqpYULUbu/NAfhyfL/yRD6Vwt0ojLtDhsebEhMSi5nQiD5xqd+YrkfqX+pva/TW8cnaYvtjv60PCkfWSK3/W7yllYUwpYpqkrYYVm2KKo4Vt1sVTLga86tv7yFzi+HoqcvsWeL4AT7kW8VHW1J5EzLqvNyzrE6IlMhSAJfutfpigE+YrqND1yQEPNh2QLE5hMXYCb6gZoIGozIhX16CBEBFGyVENuqtxxWmAs9Y5LtPAJuQQbfIgWUHVUej4JCu3mu5IABnh7wx6cbPBL/u7+nojnwXrfLwd3ag4dZgQvyJfP+fJzie+Mmo/CgHJ8M+HEB6fV1/ChWHDmqEj9NyTiKwclW1Kygkiv36n1cCdUmxn0bS8Z23kRcV49B/XvNuRDLHOc1NdZPTNU3XaqYvQKpOKXoKJWhRWO/X7/LyGV1I9irJJdNec1+EX6eDJQf3v1Fyko5iSOdo3jSQhhbFnP47bdncBvvnRrVHd/FGNCBe5+kGumBXPaYToOCicYoughxm2hU3bTri58ScxjwPOvMvN7itlg6hAC3LXrIhTuNOrZtKv4YqQ24h+GW6ym4ekVYucJEwi4bSEAngK4PSYkDJhLoo6biTMhcErSaUS4AYtnPMt48nLN2UxrABYMkiS3zP3YPdTeiOIEcxmhftV6sNCkxV5u111t2CAHtkEqeHUTGzhBHsMXb3z/9NDJs4pbWuTTQZsPOC19jarcf1VRD+fdsmKLove4HKQWuajapVqdiTp+Hu8YTkIwTWPk3GmZvCpH8TW4zTqnaN4WuFZjDTnHrmJz3uhemwDT
 dCdCucis
 YsA5C6xxolnt9OUOIDEgbhnvniLW2ANTvTNDL5fjHOugneLvH1jHp4DRkYBgmflqMk92rdKA2K9OR0ew2vCIKwS2uK06H2IoDQf/3bIaJM20l/Ry8JOlQp7kDRvKuOO4IWxuz4vGxe1E3hMhYcHmjfEWgkVsFRpiwQXOJ73h6Rgn5KYVx976O4iIIx0zEbiK7gaaJWbajCaPlfZ8vS/qDoUnYZhT9LICIFNBnrCCoGzS0Fx1w254DH1X5gW1Mw71etbXjsDHA1deEGrIA7PGJZpb7chDuNY2YvK91KK3aMPdPfocFUPawfih/QiK+MJy3txNWfTsmwIpuKPzMjaXW+vTX/EwUn09O/99l83aFcLQMg7EQZl6RYoqvsO2nZoHC//x/8HqtEUyykhOBmQu1jI7L9BLBgDA2vRspY3aXndyVdwcvfEGU7gcT7L/WqJDuUPhaHrLUNwAAcvCIkPrj6unv47rD4PkGeldZhoYT7x3ATlggm26bnBdozuyipK9oL0V/5WmyYhHuunJO3jm8N95UEX5BfAEkERBmxtRYQCs61071256XcZ29OJ8nDC6wofWaPyk+EQs0vBe7xlXiT3xm8SGyfYgmSLz8DG0cBIfaafhkJCoP5bcGJ8cKXcPqT4ezPSxjmyMlKFzZUjZV9QMGPCpVPlWw6RQdFL1FNNThUcutJvWi12bbH571l4AJ8LwZ3BQ0KZvDLjMqgFD0o+LeevbZSl5qiYDOvk5IHTSJYJfqoNFbi+BqWJ7WNAY0ubQlxDK5eKVma6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue,  6 Jan 2026 23:20:01 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> Hi,
>>
>> This series adds clearing of contiguous page ranges for hugepages.
>
> Thanks, I updated mm.git to this version.

Great. Thanks Andrew!

> I have a new toy.  For every file which was altered in a patch series,
> look up (in MAINTAINERS) all the people who have declared an interest
> in that file.  Add all those people to cc for every patch.  Also add
> all the people who the sender cc'ed.  For this series I ended up with
> 70+ cc's, which seems excessive, so I trimmed it to just your chosen
> cc's.  I'm not sure what to do about this at present.

I remember having that particular difficulty as well :).


Ankur

>> v11:
>>   - folio_zero_user(): unified the special casing of the gigantic page
>>     with the hugetlb handling. Plus cleanups.
>>   - highmem: unify clear_user_highpages() changes.
>>
>>    (Both suggested by David Hildenbrand).
>>
>>   - split patch "mm, folio_zero_user: support clearing page ranges"
>>     from v10 into two separate patches:
>>
>>       - patch-6 "mm: folio_zero_user: clear pages sequentially", which
>>         switches to doing sequential clearing from process_huge_pages().
>>
>>       - patch-7: "mm: folio_zero_user: clear page ranges", which
>>         switches to clearing in batches.
>>
>>   - PROCESS_PAGES_NON_PREEMPT_BATCH: define it as 32MB instead of the
>>     earlier 8MB.
>>
>>     (Both of these came out of a discussion with Andrew Morton.)
>>
>>   (https://lore.kernel.org/lkml/20251215204922.475324-1-ankur.a.arora@oracle.com/)
>>
>
> For those who invested time in v10, here's the overall v10->v11 diff:
>
>
>  include/linux/highmem.h |   11 +++---
>  include/linux/mm.h      |   13 +++----
>  mm/memory.c             |   65 ++++++++++++++++----------------------
>  3 files changed, 41 insertions(+), 48 deletions(-)
>
> --- a/include/linux/highmem.h~b
> +++ a/include/linux/highmem.h
> @@ -205,11 +205,12 @@ static inline void invalidate_kernel_vma
>   * @vaddr: the address of the user mapping
>   * @page: the page
>   *
> - * We condition the definition of clear_user_page() on the architecture not
> - * having a custom clear_user_highpage(). That's because if there is some
> - * special flushing needed for clear_user_highpage() then it is likely that
> - * clear_user_page() also needs some magic. And, since our only caller
> - * is the generic clear_user_highpage(), not defining is not much of a loss.
> + * We condition the definition of clear_user_page() on the architecture
> + * not having a custom clear_user_highpage(). That's because if there
> + * is some special flushing needed for clear_user_highpage() then it
> + * is likely that clear_user_page() also needs some magic. And, since
> + * our only caller is the generic clear_user_highpage(), not defining
> + * is not much of a loss.
>   */
>  static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
>  {
> --- a/include/linux/mm.h~b
> +++ a/include/linux/mm.h
> @@ -4194,6 +4194,7 @@ static inline void clear_page_guard(stru
>  				unsigned int order) {}
>  #endif	/* CONFIG_DEBUG_PAGEALLOC */
>
> +#ifndef clear_pages
>  /**
>   * clear_pages() - clear a page range for kernel-internal use.
>   * @addr: start address
> @@ -4209,12 +4210,10 @@ static inline void clear_page_guard(stru
>   * instructions, might not be able to) call cond_resched() to check if
>   * rescheduling is required.
>   *
> - * When running under preemptible models this is fine, since clear_pages(),
> - * even when reduced to long-running instructions, is preemptible.
> - * Under cooperatively scheduled models, however, the caller is expected to
> + * When running under preemptible models this is not a problem. Under
> + * cooperatively scheduled models, however, the caller is expected to
>   * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>   */
> -#ifndef clear_pages
>  static inline void clear_pages(void *addr, unsigned int npages)
>  {
>  	do {
> @@ -4233,13 +4232,13 @@ static inline void clear_pages(void *add
>   * reasonable preemption latency for when this optimization is not possible
>   * (ex. slow microarchitectures, memory bandwidth saturation.)
>   *
> - * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
> - * result in worst case preemption latency of around 1ms when clearing pages.
> + * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
> + * result in worst case preemption latency of around 3ms when clearing pages.
>   *
>   * (See comment above clear_pages() for why preemption latency is a concern
>   * here.)
>   */
> -#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
>  #else /* !clear_pages */
>  /*
>   * The architecture does not provide a clear_pages() implementation. Assume
> --- a/mm/memory.c~b
> +++ a/mm/memory.c
> @@ -7238,10 +7238,11 @@ static inline int process_huge_page(
>  }
>
>  static void clear_contig_highpages(struct page *page, unsigned long addr,
> -				   unsigned int npages)
> +				   unsigned int nr_pages)
>  {
> -	unsigned int i, count, unit;
> +	unsigned int i, unit, count;
>
> +	might_sleep();
>  	/*
>  	 * When clearing we want to operate on the largest extent possible since
>  	 * that allows for extent based architecture specific optimizations.
> @@ -7251,69 +7252,61 @@ static void clear_contig_highpages(struc
>  	 * limit the batch size when running under non-preemptible scheduling
>  	 * models.
>  	 */
> -	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>
> -	for (i = 0; i < npages; i += count) {
> +	for (i = 0; i < nr_pages; i += count) {
>  		cond_resched();
>
> -		count = min(unit, npages - i);
> -		clear_user_highpages(page + i,
> -				     addr + i * PAGE_SIZE, count);
> +		count = min(unit, nr_pages - i);
> +		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
>  	}
>  }
>
> +/*
> + * When zeroing a folio, we want to differentiate between pages in the
> + * vicinity of the faulting address where we have spatial and temporal
> + * locality, and those far away where we don't.
> + *
> + * Use a radius of 2 for determining the local neighbourhood.
> + */
> +#define FOLIO_ZERO_LOCALITY_RADIUS	2
> +
>  /**
>   * folio_zero_user - Zero a folio which will be mapped to userspace.
>   * @folio: The folio to zero.
>   * @addr_hint: The address accessed by the user or the base address.
> - *
> - * Uses architectural support to clear page ranges.
> - *
> - * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
> - * pages in the immediate locality of the faulting page, and its left, right
> - * regions; the local neighbourhood is cleared last in order to keep cache
> - * lines of the faulting region hot.
> - *
> - * For larger folios we assume that there is no expectation of cache locality
> - * and just do a straight zero.
>   */
>  void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>  {
> -	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> +	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>  	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>  	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> -	const int width = 2; /* number of pages cleared last on either side */
> +	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
>  	struct range r[3];
>  	int i;
>
> -	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
> -		clear_contig_highpages(folio_page(folio, 0),
> -				       base_addr, folio_nr_pages(folio));
> -		return;
> -	}
> -
>  	/*
> -	 * Faulting page and its immediate neighbourhood. Cleared at the end to
> -	 * ensure it sticks around in the cache.
> +	 * Faulting page and its immediate neighbourhood. Will be cleared at the
> +	 * end to keep its cachelines hot.
>  	 */
> -	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
> -			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
> +	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
> +			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>
>  	/* Region to the left of the fault */
>  	r[1] = DEFINE_RANGE(pg.start,
> -			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
> +			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
>
>  	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
> -	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
> +	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
>  			    pg.end);
>
> -	for (i = 0; i <= 2; i++) {
> -		unsigned int npages = range_len(&r[i]);
> +	for (i = 0; i < ARRAY_SIZE(r); i++) {
> +		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> +		const unsigned int nr_pages = range_len(&r[i]);
>  		struct page *page = folio_page(folio, r[i].start);
> -		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
>
> -		if (npages > 0)
> -			clear_contig_highpages(page, addr, npages);
> +		if (nr_pages > 0)
> +			clear_contig_highpages(page, addr, nr_pages);
>  	}
>  }

