Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC69CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D31D8E011C; Wed, 29 Oct 2025 20:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA548E0106; Wed, 29 Oct 2025 20:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172B48E011C; Wed, 29 Oct 2025 20:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 056748E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:12:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973411A0960
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:11:59 +0000 (UTC)
X-FDA: 84052852758.30.96B4F18
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 561C2C000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:11:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W2OPMs+r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JENtYznY;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWujrSbK+qE/62mSvUXPpUtLa6fvNP5eUMLJm7HZMZM=;
	b=IcM7UZtOcntgruqRPAhr3dUcr+d2FX1wsQJnWje1ixFZudCsLs8GQk+B90OXLNDKMBDMK8
	ZLP7afVBNocB8NhVXRf0r4v8+UwuDC3bCaOBD2cKM2M4eYTmhyxsjVqC3QPCQbi41YBZCP
	DIpYGZXrtR8phLOR0p825JdGIZnMuhk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W2OPMs+r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JENtYznY;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761783116; a=rsa-sha256;
	cv=pass;
	b=dZyCUgcW+3FmfEUVJbQ5UJbZlhsA/WxZKO0Cdts0LlZvLuxrSeD8VUKkyDLoqHk2P5fxuc
	naFnnVWJ7FFaaCOHWtViOkks7CZB1SsoSLWpeDjDS0ZVG1TZwDyecj8VX69pSMZYSx394o
	jEMzWE4+dm8wPo8/0MUKpO8SYnKFnvs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKKIPq009170;
	Thu, 30 Oct 2025 00:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nWujrSbK+qE/62mSvU
	XPpUtLa6fvNP5eUMLJm7HZMZM=; b=W2OPMs+rFOglneQtOiJDK+HgKNr1n5Sazq
	khgwEkdlz2yeUtVdMM8kJv4FG3Pp73TCsRZcvcK78h6n6moBdF8pOa+uFrHpXeBT
	s32M4yntoWx10it6j47HjOsPiCnTqpBLUqWMjiER9+oilRq6/U/E9uEPt9B5r2f/
	oXurYYGayiLaSgZqKROoU+tWgn/8nqVV8TqxVFP3f33ozuDJTCL0GKIGJ56wVxzt
	vgNqP+ORegUDeyPij5vld7/glJq9+0RMr8dWBLZMAK4+fCzEStLy0bwAI9VXhZlt
	eguvr6c7JQMx5hhUMbvvzBVCuRLAdxNwSaQOyM/s5TNr9hZtMT+g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3cv9afxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 00:11:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TL4BjW024351;
	Thu, 30 Oct 2025 00:11:49 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33xywm99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 00:11:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oOKB7AHholcoHGjqIGglnxKFdL2futcn0Q2aNjXM+6g/jTkn2toqktYfZ0DJbKEqUu6e/cxKnW4/1Gpp26GGE2tDIU08QyWf/8nL2y8YqA/7puDwBII/mZhpUqsN55HDqlfMZWl0a9n42iMI3vPmrfLBIcZsBWsWhRnLEUhdGk4Gem8Aw0ZSAVTXCz2lkdJqWk+DqkNxVSBGidQQk0y1b2OuuPJiu526+AcBZ2Gz37fUMm+YchzEvOE0OteBeUfjGhlaYkxTDdjDn5wQ1b4vQeDxHGiQPYTbJu5Fv4Au0KxE8S7qFw3k8ExxYmdShnftzF/iqvtJoGe3Q+m+koDGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWujrSbK+qE/62mSvUXPpUtLa6fvNP5eUMLJm7HZMZM=;
 b=OdnCK+3EtYvRtjiv+orMFLZbhr96aw4lFSjSlIVtpjPTYHhdXiII4a5jt36dpOVQ+UqEigGXuubCeV3ldpH0a6fL+E9m95k8nuVt4Vrwfue3UAULZVf+B5mbh14i1AReia4+qzCLG45t2ea4Ni1JoDDzdqD2fsVNpt7M4AO7hCTN2LpClCe4A45Z7fWg64chZNDGR7WdmzroZV3BFTtJkobN+ow5VWD6dT58FGL2UCMPpJqlvonz0rsD1mp2ZA+pnQM2ZI2chUUIDTWg6ZXaqoOYAgaNwFqLBSMI1xqaSzuD6HdkE2wbjzPLpeHe5ZbthcVRPyl/IUhKbf/+tzw57Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWujrSbK+qE/62mSvUXPpUtLa6fvNP5eUMLJm7HZMZM=;
 b=JENtYznYH6Sj3w+mfd4LB53nzdEQT7MVq1YGik/hY6iH+kUix0VwkuuNEKRkVUfJHt0qoZHanZA4Qi33BsFq1PoXroMU5vhSXjvYrD91zKp752NDiS/P3Fb7iP/nX53SQMR6iX3oycT9FfrUHE5Hv4IhsQG4h95TNxmrjPVky50=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB6354.namprd10.prod.outlook.com (2603:10b6:510:1b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 00:11:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 00:11:46 +0000
Date: Thu, 30 Oct 2025 09:11:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC 08/19] slab: handle kmalloc sheaves bootstrap
Message-ID: <aQKtOw82R5ONMWvM@hyeyoo>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-8-6ffa2c9941c0@suse.cz>
 <aP8NMX48FLn8FPZD@hyeyoo>
 <982967fc-5636-46dc-83a1-ed3f4d98c8ae@suse.cz>
 <3b6178b4-ee0b-46b1-b83e-15a0dadda97c@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b6178b4-ee0b-46b1-b83e-15a0dadda97c@suse.cz>
X-ClientProxiedBy: SEWP216CA0012.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a12f45b-9ac1-48f1-5714-08de1748e9d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ml3xS+FR9mInBC9keZpXOzjGkNjneqxI4Kx7CGSL5cYTVshBCtNSbLOnh6Yr?=
 =?us-ascii?Q?C7e7lRn5V3lKMFV2HLA65fzlVjpYi0HQB9pQVeksYCiKdxJY/waPnXth5JJU?=
 =?us-ascii?Q?DIq01gbmoJWJGadYa53GYYTUoIVl6hYzviJ3c9ty9ePz1HTy/rpD8jzJAuWD?=
 =?us-ascii?Q?YEJe0NTMBEIzLInlo9P7un8DMU4qr7H/oU+YvYyDzZchJbPD4X31AUPq3e/Z?=
 =?us-ascii?Q?d5924yYFZ5AkTAW5V0aZvRVp1SAL5TZd5LdtjePLFOF/wHQIYw+z2Ly9fSiV?=
 =?us-ascii?Q?ig2CuAcB7+8VxI9EL9AUK9t/1cjNSCjYLh13uvQ3ewXeJp2O08WFstQV4xB8?=
 =?us-ascii?Q?2zuWJgyq6rNe6qvRH4YJP42uAp5ZHUL+iD+y8e2E7GNizvYTFVAB42K0T0DU?=
 =?us-ascii?Q?p3TAqTjZ9Xs1GV8k2J6/+Q0hIj0FYl07UrYlccPcoXUsDt/aa8l1rD5hxmlU?=
 =?us-ascii?Q?pB5AIUmGNRkBoR4NRjhdGCXX16N8GRDZAHp/dYH4MG/7cr8kYR3ZTUm9rnqw?=
 =?us-ascii?Q?7zvDZeZ41zLxWvYj08Yrhsetf7DoL7HJ35sYUzFUYRG4hEkiZUkGCLEfX41Q?=
 =?us-ascii?Q?DqdEUwfS0M6nKaArm0DP63MFXtmgs1G2cqOR+jVQHrkl24LRmMx/k4pk5gNq?=
 =?us-ascii?Q?9jv0tesggrdSMkdKkq9fFB4PzfvAsB6jGvY2+1P4pQ5OSAvaUhMjRb6Pw5cz?=
 =?us-ascii?Q?8VcpGJEl+dysZXryFLSPkSV3bCuKM0hDrn1SL+ysth/v34r1cmDjeIbAiRiv?=
 =?us-ascii?Q?o68y6tNPQ+tqktjJ6uXMEFXxGdM7a75csnylK+jgHQnHyJoU0+WwnWX7StWp?=
 =?us-ascii?Q?CRSOtHCbQid3IKAuys3ZAHDKLzR/Y+zlASfjDKRgg6HxZbttGaoC4P8Q2ONZ?=
 =?us-ascii?Q?CI4PmTQO5JICix+FNapob7wmyvA2AuhnA+2rGBDzUr4IA7RZM7sdp+LX/5il?=
 =?us-ascii?Q?gYF7vlPZpEPQS464iVsNCzJDVZgNAq9WSyjF1l5OWmRP5+sLUThiXxb+vuVy?=
 =?us-ascii?Q?2ge5gLVbprEyEq8REdBXhIczrb64VvU7egTknrnf6ZLHhcJLWZ/uSlSe/ou6?=
 =?us-ascii?Q?UkK6hAg+vHuC8Ok29ptUfEMWo1zkYcOMjXvITeGF4Te1WxgUPt9iCfkW0NGe?=
 =?us-ascii?Q?ZBXI3n0BhQzL8s5mXio9WWc4AxLvMGFCs4lX0A3JAf5dn4CMCa5uOeIGCDcB?=
 =?us-ascii?Q?oj9lWLET7xruBgXrA/gk559Yv42f034NGs9l+Kx9LML6tle7B9yj0vXn19jt?=
 =?us-ascii?Q?gr61u9y2OygMsZp5sPZoVXdcfIbm6W/auAevB9+DLU2+1uR2998KmTTrfbeL?=
 =?us-ascii?Q?ja/JNkddZLpWzQfv7vUxiQV1IhTG0PF9bSgKbMUZHbpnbcFQkO/uITewZgxW?=
 =?us-ascii?Q?68Le+eczzHbSH1gjbtnkq9diTTjdvyGV2R2wT0VSHOLYB5fkniULsUgqFc8a?=
 =?us-ascii?Q?6phXgzMIN/GS2GnOqOpvXfabs8a8sXRQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uY8PPttl5SAui++OzHAj3WNxC05fGq13sgOLtsFCLPqBsMqM4m/0DxklLLVK?=
 =?us-ascii?Q?M1FV4s6yoWELBt+nQB/26R4xBMbRlmABuEIUVFTQYfoolkCPujrQaanSQ+Fv?=
 =?us-ascii?Q?8gaebyTnTH6NHybUGmw2AVgTFRK2KmjWFq0aKHRyx6IhBS+ntaZqFW9taWaD?=
 =?us-ascii?Q?S7CcJPIY5Z3eXmtf2aRT617OUf3uhLxOQ5c3HUMV9lvjRB//B4vzB6i9dl1A?=
 =?us-ascii?Q?tJ+6xcwFUnOg/AJaOvDnnjBEOe4moRvehcFFpUrW23mKIm35JIocbtg2UWxM?=
 =?us-ascii?Q?0wMFZrnkGFQ83mEAAKn9KML2SocIJYmH++YNE6S+cF9mQtqNyD6BR3txuTIZ?=
 =?us-ascii?Q?jwS0f6I5K30fJt+x/PQlSjahI1qBZjSzbyUp0XN8S+rX/CMRT0nZfGgEJSsH?=
 =?us-ascii?Q?CSzlfpbxFlSK/u866nLJig9udrm5hUdTcn4E8BYve3pDRoqsaGaci51K7pAK?=
 =?us-ascii?Q?Kif7/vwRpJhEiA/AGhUcQR4g3ntNkSYlh0+79J5wiWxF5hxPqeg+F5LGiloI?=
 =?us-ascii?Q?rTO5fsfiUTqYJHwAARi1OnXasi6IjM0b40QXpfgVUjB71gPByTzXy4XlpJea?=
 =?us-ascii?Q?TP/mvjDXUBxQL7Q47rkXkceqKKsXvYm/pKooB/Luta4pfT0vGbV5qKwV12SQ?=
 =?us-ascii?Q?Jz7SWQRC+vN+rENQBIhtgfA/t4z+CG1Jl5vLKXpsNX3Hlt1Mu6/gItEEbKPm?=
 =?us-ascii?Q?cfyBQ3awVyXJuBK5gxJRYS+esbRtH3bmCZ0vhKk4mSOiWJsrFgo7wsFUE+g7?=
 =?us-ascii?Q?IPii+8m9ktrjeeY8+wpG0yooOIPQdCwUFoKRBz0SZZ9c224aMB4X9wYZP3D2?=
 =?us-ascii?Q?KBev2izJBZtMdxpkfue8YpcE2xYiu11alYDAlooydehj+/esTMwaeFshWPDz?=
 =?us-ascii?Q?hm3ZJ6ZE23n7x07LrwB2Ib+imuox5duK9epHzKdDKIveR+/wdDY93y9B3uS8?=
 =?us-ascii?Q?3Rwhc2uf6pv9l0ZjuMcuzunvFoMX1BTId47L+Ea2xLIsoOon5+qn4AplXoEj?=
 =?us-ascii?Q?EPLiGv7r0qjM0qF6fkpAvBGF8IvWNiC9vaGlO2FvbDD9uPHVCzyjsYFBUlyr?=
 =?us-ascii?Q?WJ3l3g8U2LegAmsQARuuFde74FqWLfaodsf0QQLvNuQ3W5hdVo5JelqyIh0J?=
 =?us-ascii?Q?IO7PEHiQ73DJ6pD5h1nMFFVv3Q4oINInPA7zampF5sHaEHYHZ1jztM6ErO0W?=
 =?us-ascii?Q?X5ZZx7ymWOy0XHhotpJ8DkqHFstuLGdb79mdY8xoC6Wxa6kBneYlTnFCfEZN?=
 =?us-ascii?Q?W5SaWszcKZr32sIXyEAiQc4exjZ305F0BTp1h1hU2FPFz9Zj08NlsoMGEqH/?=
 =?us-ascii?Q?TYOsirUTi5hfDue8F7TnLiYYaUa2hTOf2eRO1XKSSUHMxW4UBbTL78pAILG7?=
 =?us-ascii?Q?v4JLxaD4h1cHZKX3/31z+yuXTVa5OYPTROO//n9iiJ7tyV0XX2+0VZl3GPYv?=
 =?us-ascii?Q?/ApiAXcBin6xOqstzy9fJS1tsED+Luy9AK1bZ0pc3d/ZLYnCwXVCm831jU7c?=
 =?us-ascii?Q?V2JL16iy/6ecs8W5YNzTuZbfua7PCgV3fIsPk3a7905f4MfKckozMwsYt7Xt?=
 =?us-ascii?Q?bP2PoBdi4pvlAlfkjIJMlI/pmtbIV5tVzBc7gx7V?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dlKaLxMPlHEE3vTN4uq4pfnOow3prsgHNH8jMuLzcz6fKrB2nGaU9hsZ/DpU2CQ2KWrJryyLCEbcLg9Li+hyWMuhMnWWsAN624hoOV1wpmsgzldctYDeCCSH3PVEgNjtYcDqm9/+gDTTyLmqluufV6xD/FzdL3VOA3YJWbnxiv3LH7kw1dIn4HRmyjo5A7WJotutk6QfcakLKnLhClLZNNcDUBDlWzLWghw2t3KPpPYEUMFiI1ZmyekhfhkDXRTUTg5/ITPwLptNcj1VI9n1RKvR0V5hC/gT/uC9F7GdJvQuZRJshpOgmabqVLfx0KHaJlv6nORkUnbBsyWiJXZq/UXuzlNj2FElq2+ury75ikWX5/P5R+5zYF5D3lwrhSmV7U6smaWeo/UNWqPwX6vnJWj7grMkD95zHfZqUzzVzYgiPBQ24adMyG/+7ZqC5e6wxB7ZAlQUg0207mAOUprQ2Dls0BFRIZGOjgAgRhXz04OErdwCXU/cM6TnpYZZw6jsBgVeWGWqkN7WnBPjYCNjs5n+29Kt1h8N4Ljx2Xg743Okts+ShyW781FNOCmtuMTtyInvrBVIf7KxqV8WT78d2BHZupi+yHnGSqY6QTr0Nog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a12f45b-9ac1-48f1-5714-08de1748e9d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 00:11:46.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1FEythPwyDWxuW9l/4qzyOL0FBlF3SyFnMka3eRs65lW6KC9SdRrSu2AXnAzUc6C5DFAstyif5jideUS+CIsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_08,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290195
X-Authority-Analysis: v=2.4 cv=NfrrFmD4 c=1 sm=1 tr=0 ts=6902ad46 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pJD_9mKSOZQm4ju_ODEA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 4yIH-ZvDEJklu381jQoOvI8a5ZthlHHB
X-Proofpoint-ORIG-GUID: 4yIH-ZvDEJklu381jQoOvI8a5ZthlHHB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzOSBTYWx0ZWRfX34aPXk6zGUY1
 eaG8v7pmHycuEJZAKOUC8dDkOkUp6d70ITDhkDY7Nt9996Tuh7lvrsgDb3bXiAMPICFW/AngDmD
 bVrfSG39HrXOWhre1zt14XY3lhgvJ2L1r0qJRuQpNG9SagQPEg39Fnf/xLLZBEkR8J2sm1WIn2S
 IzFC3Ls2IBVLFHciqOSV93v91Pqj9IGPPHe7j8cO2wHnyAZ+lCW4Raai+nYIBG8WEgA6/TgJBie
 JxWVQOhSzPyf5gqCB1S/sQK9qbAwTEH8f+BtROZcplHPftFuF7Xg+qMYWHeuO1VvxpIMA+qQSbg
 gend/qlttTUTSEjg6jdsaDSkhJVC54zOXtMgO9hypeZnubgQfjoMm+EwfuczbKIqve1qMtg8oIe
 8hthiauwbEZN+uBVKebjHf1qkkHTPA==
X-Stat-Signature: 4esbyzb3oibwcmupukh1qx7ast5pnt58
X-Rspamd-Queue-Id: 561C2C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761783116-410030
X-HE-Meta: U2FsdGVkX18vLH9EQ4Q4FOs1CrS8oFoP29rwKzCFCqQuFxEuTAkr3p1PlUDSXa6bVWkPieaUDgQI7J8upIOzoxILWbHTEAaxQB0RqcsIRAh1zGC0B7JwoGXuQcF13SMueLE2PaiBRV6yq8yCdTner/aZt6DSvEqwwZ3F3X38J2mfeDN4jazrK65MLm3MSPCIcQPkYkKErye4VOgE9D1IUz+ql1SIga5CZd4vy9nH1+QLLR1KOKX0uOF/y4eC8eCBfAjmPwIwtHwLYxPdxwkQWKUWABKwI2YP++SOGXimPlRVOHA+AddPlMuacH9RM+yhbSky7KGt+OsBzxnc2S8NaW7ao9PkvO1xQ0t3UMMh7KjOvQ41gLOxzsBy9Kp/RUs6Icdzw0Anzm6Oszu2YTCWst3KcH+ikKLAYMN6HK2fiDIvzqlwd4lnbYmUeXhnctdOFwkDVWJS/3P86zsP8EC2Da5he5d+PVW2/cIXzSqTGaCyoa69EJq4d3UVFFL+BEBFSRdZM/qDgEGgImkEMpyF3+NI2/qHQbPLtzbtyMSps1Pf0uV4HN7dgSgQ2v9UykX1g2wjjuqw/4RF0eKtMKqgHwf+q3HgwlBgjrayiqqDWQ6FVfV4NA6NqPiOyhpvDjIxfg1viJSWst20G0by9xB1vhJC7MTX3FcOPeX7uzdPRkCPKIs3TiCP9U9qIPJyQfh1K1ecdVOJt72YxiKjNCTlJP6E0PGzkS+a50JLL+wcbMY0eo2wuiGBc7OoZ41y0pPq3xfQs9MYr/KGgXViuT0p9gznabdipFIqpp4wiCxkFFPnccTTWxUd2wJarVq+4UZAXNCKDx5ZVQBudA7aAUalGxqjxy7o2G/jgUgxDmgTvVFFl3+dgXdQCcYxAXnAlameOpel7L8+ZgfkFSnAo/NLb3S/vR8EFqK+BfonXTtBrtaiMD/wKHyxj7cAWRIDkL2sTrun4kNY/xtDTdUUSyj
 btSCZSQa
 q4GmWzdUECsY/I7Gtr1pYWmOaZ40TtSsrB2v4h6Ks74XG1veLb7GaRuNIuWuJVbRyoSqvRTg4Sqn6s7xodRHfS5DZSkYpUN019ii+aB7tlsrTZoMZJQbeE54N4J+XC25ddMlO/CtqVtUOlPTSSvQoc++69lZi5by5U5PTaTaccM6RXzjzfP/wEMT1VH+NKO71zI7lMcsBPMlsboC3bj1r8ygCJ5mbnv5tGQy+fcIMsuEFd3msjQIU/X9sDx8Q+Jj86loypwL4I68K7xRcS6IvbKMtG5JdQauUdEMkgrfmpwZp2LfS9XYNROlV1PB8JRaeR1CTXsw23eY0b1W86PwwTQdlV8dH/nzTkqYEX9bUhQ7EXAKLwqw/FplLidW1HTTkg61tftPMd7MCLKDqqAuKCKxmFpDVrKsycYZr4JnIpgBBvZVdCnMOglizlibS6SmOG0HqAXDvdIo4F+VA7V2kHuKykY5/JCzHmWbiwIlZg9sSJwySVm7Cxc4BaOd30K98/Tet1i82l2uxrLyOPuacw1iOghKV1fZ0HRlKzOEUnL6nTQOdf5QupNEluaUr0gw9rkXC8QMvSkaLrwTcLDZmdDnNT9nlXnc5qtoPkf88v6R4yilp8lgqVHUNuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:06:45PM +0100, Vlastimil Babka wrote:
> On 10/29/25 21:06, Vlastimil Babka wrote:
> > On 10/27/25 07:12, Harry Yoo wrote:
> >>> @@ -8549,6 +8559,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
> >>>  	return s;
> >>>  }
> >>>  
> >>> +/*
> >>> + * Finish the sheaves initialization done normally by init_percpu_sheaves() and
> >>> + * init_kmem_cache_nodes(). For normal kmalloc caches we have to bootstrap it
> >>> + * since sheaves and barns are allocated by kmalloc.
> >>> + */
> >>> +static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
> >>> +{
> >>> +	struct kmem_cache_args empty_args = {};
> >>> +	unsigned int capacity;
> >>> +	bool failed = false;
> >>> +	int node, cpu;
> >>> +
> >>> +	capacity = calculate_sheaf_capacity(s, &empty_args);
> >>> +
> >>> +	/* capacity can be 0 due to debugging or SLUB_TINY */
> >>> +	if (!capacity)
> >>> +		return;
> >> 
> >> I think pcs->main should still be !NULL in this case?
> > 
> > It will remain to be set to bootstrap_sheaf, and with s->sheaf_capacity
> 
> ... s->sheaf_capacity remaining 0
> 
> > things will continue to work.

Oh right. it's set to bootstrap_sheaf in init_percpu_sheaves() before
bootstrap_cache_sheaves() is called. Looks good then!

-- 
Cheers,
Harry / Hyeonggon

