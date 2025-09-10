Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C275FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 10:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FAB8E0008; Wed, 10 Sep 2025 06:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40148E0003; Wed, 10 Sep 2025 06:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B079D8E0008; Wed, 10 Sep 2025 06:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99FC88E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:54:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EE27BBAAE
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:54:16 +0000 (UTC)
X-FDA: 83873031312.26.6832DCF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D91A280002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:54:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BwgC4gZA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tRO3WTQo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757501653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgctiF8xxsiLikYxr3TYyAe6RGXbb+jz5a0tR7J2gP8=;
	b=rog+5e7eHlh6hS1fJI9HYDgFciyuDvBFSLjKIU9JfXgp7FdUdxEnAaKX75qtGO1GaQ7IGE
	/UkiG82zaKN1pgsTwCnXl9psfomcsqoy4KBmrf58v7Y/uE37tbzT8wel2yjiCTNQuqU5Av
	/ReegaPkCtk6tGiUgFw75XPiPqpMDTs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757501653; a=rsa-sha256;
	cv=pass;
	b=KtC0RqtIdqrujCBgVReUQLfe0jCXgUotVsngvaZ7fjQTxi+veaQIdUjhwRUBejcPT+MGqR
	LFCVjiLRQH49nlTOg1lkLoY4O7VO8gzKMQ0htm9MEwWJqVCcjuDXlAZkulgz8MpcFUen2Z
	xoQfAwIm/LxkSsmmupLV2cfyTcp+Gzw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BwgC4gZA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tRO3WTQo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9NB9g011217;
	Wed, 10 Sep 2025 10:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DgctiF8xxsiLikYxr3
	TYyAe6RGXbb+jz5a0tR7J2gP8=; b=BwgC4gZA+o4cA7gwB8C1qvq11WfD/jCvbh
	xiEIiwB0hhvhvwyTkOboAN4P0+DAujNDmHlrbYjO9L3+yQ+g6TjslFv4nyErLURg
	nfxE72Z8Sv5m+J7ATjUNeQ+d3WIfXMh6oPHxRk8Ekunou4mgy+qRk5/s3nR2lmSy
	hl9SuQ1ydvq8T7WhVz2TyGXoCEoGwrdEqqUCC9wKc+bNaqb28WGSGle46eu+TdCM
	JbxfhDaz/oJk8VDuoaJb0Km9pdlWwG2EniJdEKLE3EOm/DrtAA6R0AEoc35clvji
	voAcUEq0N6ccsVhXcin+bJuMoILEarglhvs7jJfblWs4FcDvvjQA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226suvcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:54:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9xOFl032834;
	Wed, 10 Sep 2025 10:54:03 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbucx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkZT2lHs0rDXqejLCE8o2R/6FB7mRceheAxcBvH7OZblBxKiR5sAopmoaMVC3czIx4EVFWVPeReZ3/ohC6IiqDe/rcIHrAiVB9nz13dh0Yk8qhDRQm9d6YQi/CcRz1EH4Buk86MhtgHOTokw/MoEeiYqJPKWDTA4YrbBqPiDwHbUYolKxL6V+1fCIBUjr3ZZPb6eweAO6e4hyhqBINvLuIQSafCCJmgX9IVCmUFiLO7HqQXUMsWT/JGVT4eMQI5oc6kW5zEvgfDtt7KNKWi6267tmDvifV0VJ4FeZTmPPsUBJmpGDmmv1yJZnXx33KSUo/VQ0f4oNs1Bx20VfrnMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgctiF8xxsiLikYxr3TYyAe6RGXbb+jz5a0tR7J2gP8=;
 b=y/FarTr2CkvDu1JWc0ZWASF1XwRE687fbPs3I6xrWPcihLN1gNBV6xfx0fZggss+0UFfhue6ogSClDHIIfgELfr8+69t1zJJAxT3E+CTqRIKCw+Uc+MHIICimHNMzR1SnqHD+zY46WI86spGRWTy0xzwIGmyUgENT2ijgcKnaEqk6HimizYFAcmjqWuBgzI4b/TptQ/+fpXjoi0nBE+q9i516IvmhTnWKTtMrcNg8JagfQ4hWclR5SFBtXoTQcnggJe5rVT+RWQFJF410wGrxDJYCf8BkkuHGAYJV/8380w6iSpRESjBW4TTRoWisUu/PIG76zaAk3uu7MJKJpLjXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgctiF8xxsiLikYxr3TYyAe6RGXbb+jz5a0tR7J2gP8=;
 b=tRO3WTQo6hU5kp2zsa/UsQeVGAeRpPet+LzfmsTShnzM5773ZsTqnTP9rL7OeygeMjatpAFt3LKerspMKPWEFlVkw1WCPEVJn9KBOvLEdTV4ukjRov9kJ+xYWllk0Kucd1HajDh5h7Szl3CJcoUZdRgaulSbesd8+aSjxV89yIw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 10:54:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 10:54:00 +0000
Date: Wed, 10 Sep 2025 19:53:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 01/22] slab: Remove unnecessary test from
 alloc_debug_processing()
Message-ID: <aMFYwLnFPkQj7NmS@hyeyoo>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-2-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-2-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: ed6b9e32-8b51-4697-4a98-08ddf0585955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sT/WgoYaMrzCuVmGCS5cjaQz+R9migg05+6kCm6ExMcSH414j2OyKA+Facjl?=
 =?us-ascii?Q?zQqJ/CUSdqdg0agCT2VZsjgCHCaF0NakqgisjtBeIBiHNoKUXyY+OGJCZCIE?=
 =?us-ascii?Q?9oxr+QOi/XaWjcnY/IEZzWMSrfo4t3KVELl80A7mD8LZGWN1kspibg9RPKOT?=
 =?us-ascii?Q?JiJoCSYbW63Teol+4+yqnlVfPAlH1Wno7vx7sFk1AjIbaTDKyRQCv1RnWNU+?=
 =?us-ascii?Q?aMjsJR0QJGzAcJIStdAYgd3Y2yvnS7cU7OzBElC41//KJ2FSEd5gbiKYtVaa?=
 =?us-ascii?Q?ckdId1Qc1cLjbftzJANx+UlgddYI4D7ZXcpyxnrUrmXCWu1UQcDCIjO8qB05?=
 =?us-ascii?Q?s7sFBp+tQrqS33b5VXajhqbQZja0w2NTbjCD3OLdcKSPyMvXKMq9kbc+48lQ?=
 =?us-ascii?Q?yViB+LNkyOrQo8mUXm9UD7bxaS8eZ/shzDUU/oBMVvUCYikdIqpwz8jZ0w4/?=
 =?us-ascii?Q?gEA/7XVsumk3Z5+2KXn2giCklAwAkFtBAJDfTFWkjWR8dFyy7h+Ma/qGzWiA?=
 =?us-ascii?Q?bf4dqrkJ81QAjA7KON1MXbXYe99tg7ReI/FF0ZRpVgh1UaD6X02zz9jR+ZxD?=
 =?us-ascii?Q?FTdYzzuomUY11O1HiNgUE9u1FbmdiPJt+osP9FWOBg/PvsJBrOriyQq8oWvP?=
 =?us-ascii?Q?zln3ye4cHsEgeIsaLbnWN+BYXJ6J+DF2ZB/hh6R2k9UZItv8QQE2V9BytnLc?=
 =?us-ascii?Q?/JtH9yhc2qZOynFAcmlB2h+LxGWFf/FmmBwCk0wLh1/tJ29uTHsalHkigeil?=
 =?us-ascii?Q?JKECZwMjhHt/lETTUyGfEkQkzmVcJptpF1XrBLlz4fp1MuD6sOx7Rt0v4GIS?=
 =?us-ascii?Q?CAUI+z96OGnLtxFaC/j4DMvnm6146/tbLTveH4aLxYCDL9WcGkW2Ujys4R+N?=
 =?us-ascii?Q?7HnyDx6mfrkeUFwc792Vx0dkoaXmqfG18ZVq1t2pYUxa9SPKAkb77qB7KTzD?=
 =?us-ascii?Q?OYoTiL/WIcsymb8FidEpjoPBLx0XltlUbj8MoWI43NyFuxvOnFlMy+uqhwzu?=
 =?us-ascii?Q?ULppjj9S0/JTZEDye3hQVagL6Y13A7ec7pZGfRP57hjGv416+0pCqlN18KDy?=
 =?us-ascii?Q?wWoscUoyq085t9IMqnc9ubyjRFNloVqlX2BK54jMpPmnJTGHD7uZ1b3+/M+W?=
 =?us-ascii?Q?9oqN2XgP1UO0f7l2FbUUoY7afPZHz1R3cRrBPpW4dvEByN0XiNkzfBr8lKbD?=
 =?us-ascii?Q?QknlG6k98xCDeFvCnFMkoQVAd8VJZwzLtxIVn2V5CkEN/OZrUiMA6XV91iy+?=
 =?us-ascii?Q?uEMjwxG1LAeBCCQUz7pXkYaAplJhoHdmSaYiUfkZUvzbAFpMig8IsuSG/FvI?=
 =?us-ascii?Q?i5jk9hfenMOOPDBGbD4KigiXalv9oQdmGJHSOOJJn7IL7KVthXghbe1YtT+d?=
 =?us-ascii?Q?li6Xm9T7LLnIFbF096PwTq+thMQWTzy4YcKTGwr2bN3XU4cXMpKTdhCI6ujb?=
 =?us-ascii?Q?PlyT4cbFKzQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0cpQftFUXm4EVp0MQThlFKl9jrG44+TLjDNdCssvlIbOk9+ku5z5n6GN0NjW?=
 =?us-ascii?Q?S8HLon/bTpARc1WP9jcVJIsPb+zHbhM5yr6McfDp8FMxYXzZ9AJ4wlMJOGs6?=
 =?us-ascii?Q?M8lc2DBwjnc2xqLWixXktdEuegndYisdlh/PQTsG7UzDLF/FR4TrTqNWeXQt?=
 =?us-ascii?Q?PKTQDrvhh+9+1GiVK+lwg660xiDKC2kdcNvrls6Uz8yMbgJ4Bq0rHxCuSEuZ?=
 =?us-ascii?Q?/tb/hoPxXdQCVPDYzW3wr1YTWPZPSmkx3wgEZYfAzuaPR26n53xBFUpWWHXS?=
 =?us-ascii?Q?ngVcXwKIkpFGFDDGSkbfjkixbmPvsp6B0fFdk/cw0rUw4pER7UMNFTQKlAUL?=
 =?us-ascii?Q?wQB6k2k+bJc3/TepLT4Tt/O0Vrv5tMnKHGiVyQX/IIjG5MXWXjNQKoRdAeFL?=
 =?us-ascii?Q?Q6WWk6oFbs5x2sGgaM4BMGSr99Gkap4vjZJusoi4OzMTJDJd5u07Q3GY1MyM?=
 =?us-ascii?Q?OifmC6YJfbvF3CwAWwsUkyO89jGoeCd7u6kI2gAwOvLwN4lkhxJhpTH22QLw?=
 =?us-ascii?Q?k6+oH0jzkodKekeSC2f6pT4mBvFqyeZDa4+Zc/VHVb064NbjuEJdCIbQQGfT?=
 =?us-ascii?Q?k7UqpddiA7/KJpRQqtWciW1hLcq+3VyPA2T5hHRsRHjLm8viTJ8bO1HDm0RF?=
 =?us-ascii?Q?yxAeIQ14Sv0sWdUcOvBS6WIoDbdU5PC9Sv6aVhfaG3s/RwRNb2HGGG2THk8r?=
 =?us-ascii?Q?r2CETDSHBvq6pp86E6E8HjQiCZn77a8okkbx0J7ZnYBDWFIKFi5ycKOjR+FX?=
 =?us-ascii?Q?fQDeKJXFZYMF3YUFnImEVauJbR6sSE/ctUPyB+Fsq65fWYqUq0Yjspmt/Qzl?=
 =?us-ascii?Q?clUjZxV1HPdd7ypa3G18DXmpPdSLbkHW526sZELPMz4nLKSQJGZlyuKI5Jy5?=
 =?us-ascii?Q?cURDQ6R/R+iGIQ4oBEE28OpvEish1axUCkN0MXbcQ6Mq0Ygn2GwDGE6tN/Ai?=
 =?us-ascii?Q?a7UJV6XVzUVIMaHLvMpNGF2ufQiq0vRFGhWzcLLvIsVrsc4miNQy/xyyLcg5?=
 =?us-ascii?Q?c9xG4KHFa2LTtzrNXASXjI3B+0r3zVv7E2P01OM8rRbjvCvqTmrqBmVHhEE1?=
 =?us-ascii?Q?dfvrMunnIHbWAanevK+Z7PW8MVukLI1xtsLTu3TOkMjvWgrhVCbKSCU8XPwl?=
 =?us-ascii?Q?lAaPq5N1WzDvj1YYauXRjIBcpJ05RAjNn72verFTlqO12WqaAbuWAxmPkUuE?=
 =?us-ascii?Q?RUCosMzx9KmjKYQq1sPpMU7gB5QSrKvKR3gSMExX+QOxCISlAh3N5CKMWgvj?=
 =?us-ascii?Q?CLiU2MPS4PUvwQoGHlydovD87LPYOdfJ6uivxG7aa+HpD8rx/U5cdZ5CW/+K?=
 =?us-ascii?Q?CaXYMoOheAbxr9B5nDjbX0EGm1p4IWwaKMhXUG9jc1PWZ4IvA1nx7w8o/3lf?=
 =?us-ascii?Q?zwzsX3BtFomCiHIOVhGvvtAXuvrmqWmunD64PPuNa1c/ZWD5Vcfma8uSkTmb?=
 =?us-ascii?Q?xdpFtCZgS3DB/l2vR9h52vHjJoa3XGrSqfWp/fkkB1RmKZ/HQ8buXZd/4S5k?=
 =?us-ascii?Q?T/UPGM4NpMRuygFBN49+n8v+SqGFO4t8og3nMqtfMNrlNspKIGrBxF0izIRq?=
 =?us-ascii?Q?DNKor93wrc8/m4yqiwGJu96R4v089LkHQQ5UJY+4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZMtR2KsaLRBcYir6kPn9Y6l0xE76q79eJe3f5gIJlenwIJET7hdEtnQscdAuIg3P4yaIlN/tRsKbEkWh1Hr1jTvHhvPlpgfprvd+QgKbPz5s2kH6iMGSyFRkWdg7jghovTOHkyyOdH5GiZ57BN6v7kNjXNH2lyJdphxiMQHVFqZ/pVuNhslW5RXrGLGEV/0fGpSRebzLUZglcwh0lO/eir6+Cs/t6GDLStyjS4QdL60ZhYIkqN0LsrGMs98bdhqFJfbD+ZLsQWSJXZh3W6giWx2mW2AMoQlxNHM8vSzUzYJrdiCJ3ffRxvdOuXbIAntkHffRrmorzKSuI2yUF6888CEbmlKAz9ESSQBSWsdrg0yvkXKJETmVP8y/qzSMX4a2xXFPvLZ7pLQK6YZN5kkJy5j9GgCO3jmMOEEsbE+QQu3erPVpjJ6tfbPk94YbG5pt8tt3op+QMGMiG5AUKdL4/PikWQpUe29/8LccqkO9avMPnynx2tzFZF0ylqqcdM8YuGJtoEROoHPC4cwVC++H1IeSboBp56nXTjk0LzPV7CCTHUpKOcEW25L/C4b+NVuEcqCB87fqaz5C0J0BL3aPnrPB7uup2T4kLpJQLTBtHvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6b9e32-8b51-4697-4a98-08ddf0585955
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 10:54:00.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMsYFYATZt4pRNoJsC3BuvZBf52rXYWxrLHTneK5FuahoK+IQup60QVwhr060YyaaB30eCUNo047fBuwzvaPdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=969 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100099
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c158cc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=iDfbWsJnVMTRaQooJNIA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: O8rLczishtkxiBN6m2pkqGru9TDu_a1B
X-Proofpoint-GUID: O8rLczishtkxiBN6m2pkqGru9TDu_a1B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX8XtWf7C8kNaP
 6VvoN3KihA4vMblFS216BW8uccrRtXlTYVTzEBGsd0i1/AzQo6uM/zKQvynXtXMgAm7/b5ab+Bf
 Cf6vAOEVVebz69/FCY8Xbd6Wj/Amn+3j/lD53r+FY6w2O9+wU0ren0JM4KQL2TbIFncC+lriBl9
 996rMcdIdW/Z7yeAmBkY7lT0lnjXA+Y+lR4DnLrER2Vs1hQ17S0LoRTntCS1/U2CdSlR40vbt0w
 63lHZkAAb6yGjT6C+eB5lzkUcYcYMhYrqKf1TkkeoNP5yezLnX4D7MIMp78uWCc/n67cWzTYcXL
 A6xqOnsxzzJc/cjvxsZl1ejtBbwVq0O2VO4NIXUwaciHTbVTeziS2Rmsu9Z/kQoK+TYJB97SviK
 amXbOJ7B
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D91A280002
X-Stat-Signature: nu7tgdhcdszodgisu99jk7m57rnn69ug
X-Rspam-User: 
X-HE-Tag: 1757501652-455857
X-HE-Meta: U2FsdGVkX1+wTD9lK4XS8JbkBNSPUq3ym8EGnRr6RR58eS7c2X1l7tIHAWBBWuYsfl1d2lNO04bEOpsK6W1O2G2DLjQOEfNCJvGHXjDSFmEy3WPLkrwePvFFIolEFJklKpv7vydwq6r43lj2T6hCnMjp2IFudGoSAxMPI5VAE4KTuC2NFVB2W5bpYiA7vEu2T7uqxBYP24Fv8GGRpP49ceco6/itc0tgD4rHKb13hIVgGHrk1KJYgJ1EP+tO6i6/msO6b+HyAG8liS/vNLhT3XorusRQDDB9AfwK+Rnxh51veKSStSP9kY+L8audTArrwumxHwacp+3XovMcih2/LsoAzCe6gr7HUM6Qb9C86ldv8QZHJzOMNPuOt0VUuEkdBqlYJBMaur6glE0bUnMPVpa1BldbaEwfuAMZlyzxV30uaZunuho17TeecDdvgvbS9d2GBeMzRBqz2ZWj70zt5BT2ouLJwqybKzgoG3bBxRc8PwkRV05WtbqiZUMzlUcFoT/2pih2FZDtvV9GmA4wgigWkiXYK5pdstj37ewuCtPZ6/PPvuCbSZTjXV32NdpSbeUFhrbcnjbXid2wDmkGtwe8md3rOWiznasn3j+V5EdAHihlpRNqTxvI9B2NhKhJbajdBkTziQcUdMgeP/b+i1ySYeHkgN847QS/josYpXDEuaUGGngVFZybVe6EgSZtKIWGnbGnduJBDPrTYs5em3sMGhMnZbWJ6xu0ULwGBP/OoZ4cFbUW0OF1Db0tsdAICw89RGIoudcFkit0+IWwwYNJcppU1a5VrseNix9diirPDZEK0HH6whjDmbvk4VXKFeJgfwgaBBXNG2ZJiWz5xhC4QRGw+gyQ6W0ShmIDbpEmWyZlyvImxBOmhHfcW1HgKzNGcsK2Tt0aMPrTd+PsnRMdagCeaU1o0cxzgXImaOAgcpE39oo7WkEKy7Gvbx/UBnBDMkj4Ow6EOjv1+E+
 1gALgvgH
 RcOuXkQ5fHGbm1XB2q7QEVeKW7HFSc9/8b+z8skmDlsm2Zqyl3kJ5bV0nM46qEV0Kus3+AAt6nR6s2qWvymP+tWaE0fFzY1sDEzz1HMnsMxZXm2jm3jCkVdPxcetRJBamASp91q3WZzBE/gvPxB263S61fWAyi50qePiWWIDD9tPcG6+umTdlBVdEXrvs7S45C6akj5/PKinkslciJjX59TORWOJiM1IvjooSrhwsdRtkkdYOld7s9dt+jp1Yea2uu+k9vjaOB+8gtbfqdwhLJ0wOt/6lPz8HRKVq1wOE9ZZGkrq4ze4Qbkf2EWti9MUw45MkWKbK2OCXTnbqg6xVAvH47R5+sb9hItRaE0qsKnlHL19rfcSRyulMDaOsh2/M86IA7iWzdIGjTFqiSdmr1RMz2A+TtM+wqsTCP8EJ1VX8szwHtbo3iTOTMcBvYwuruF3lOSOt6Sx4+5ESvDfpaSwCB7gibXuPa35XJYuIWeUTyTzeaaYbav/8EazOYOW1/77B3+CUuy+VDgEQsTYn/XXLt8R1AGClY9Y5OcWQH5XpGJfO8IkN4W+lFH7x0Mhjimgdu87X4xXXQWFkBxdBtm5Hc4iYUQRDZ6NKjH1v6tUFdm7Nup2Yh2Jjs7LSdiaMEfufLClZAeaGiRJRH7w+JSvxoh4LHM5bSykHhNsyoLNSsEzHGyf7e8FwLltwq1svVLuWBOq3CkwiSCmo11jYzcjTlW9V8jWl24ywPLiME5OfiGtCxNMANdIs/t3QZmcmXqvF3hvstxCpM8kBdx4s08w5OBf/ep9zJJj4uXnmYP7FA8sV93sZdyg4/bOjOlxWhlLfz8B83dkoBzZvOUsvjakPrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:05PM +0100, Matthew Wilcox (Oracle) wrote:
> In alloc_debug_processing() we know that the slab pointer passed in
> really is a pointer to a slab.  Both callers modify members of the slab
> data structure.  So we can remove this check.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

