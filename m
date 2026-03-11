Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B82106286C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57EF6B0005; Wed, 11 Mar 2026 07:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C062B6B0089; Wed, 11 Mar 2026 07:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93276B008A; Wed, 11 Mar 2026 07:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 891376B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:49:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B366B5ABD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:49:01 +0000 (UTC)
X-FDA: 84533610882.23.EA701EC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B3EF5160003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:48:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SvjdnmTJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HB0ASJsq;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773229737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5V6Gl80u9Fl660ngnOT6P0yQuQqruwwikG5KMqGNUuI=;
	b=HHQmfjPtpbfrEc+kT/5/qfo+eOl7b87l1kfcZEP5hT0X9zIDWpZ1S9VvYOqXV4iWlLvjqO
	L8ggfTZutEwSZh+RDsjv0UrxSCjgo/OcLccWctDzwIE9tLlOSy4FvcpY9g7DIQzUYPRNLh
	rGGHylEv9GZGrfV+oxA8rxYoKh4dWj4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SvjdnmTJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HB0ASJsq;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773229737; a=rsa-sha256;
	cv=pass;
	b=n0wgM4vmrPygubOiUy7s6xurjrPK4TKT7jfW0NPJRPcX3BWX/luKBuBGEMPEu7fCPk6P1O
	ncT6KCQsEvTOqVgSXqEyfAIUJWsOM+ZsYi9bbPm23WwK5jnche3S3Wsz69KKj/PYs4HkXB
	E2d03DQTx0U7gr3H5hHQRF8DKbpnjc4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B4MqYP2345132;
	Wed, 11 Mar 2026 11:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5V6Gl80u9Fl660ngnO
	T6P0yQuQqruwwikG5KMqGNUuI=; b=SvjdnmTJbYIFaKjEh3C8sjuAd3FWajkwxe
	JWjTZnR8O1AGTWPqwwsoYA/l4eSLbxObVREzVKFjlv7/NPaifsEOrrcG3SJrKLcz
	UA9winRMoyBY8nYKKz1XS/ZXHtZLWCwxomGh0bDIRwy/MqnqAkPirJZgB2UPr26j
	7DJFJcO0AAeli9TNSLz6/aM67QnHPlGaJiH2/CVYyZg4uzuR/aZVqoY31yZlSuQj
	TgIn4kvjX4dmx3C4Svpft+sm05x29FeoZF9zWwGmCFhKzL4RwbAyr8DVh1mdu/MS
	aB63lmTlwVLNM3T5YDG1OG/sib2QsuzGPCmUNl13B3l0SX7xcgiw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csks2mvy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:48:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B9uS1I039609;
	Wed, 11 Mar 2026 11:48:50 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbfvmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBjci+UnQPmTy5r/k+p7qCuZp3NGk4YevLJHVYYFe4fZq3DV1xiu6TKJlJWtsVNVkDnCcJaqDP92ONlN1C95I+NbHnCr4QnRhTUikwp5iJJ/uMz48B7+rk/nSMJzchQ95CmcSf3TMQfp1SdEe+TPjro4pU2S9oUzKZzNHkDu64vtUGz5TnpvUX7ln9rYNJY13psGY2iqpeGtdIVquSWeFLD8qp5xSyrqCuzjOxaIuz9rYb1V/TTT9lP6FZA4y8UAu6tAGHEVvwt9aXnXzmFGGc/kUlOTB4qMUdUWqq3AEXXUXL6l6Dgbk2GHPSM6zSzik0vnTsVT8xydo6ROWdKMRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5V6Gl80u9Fl660ngnOT6P0yQuQqruwwikG5KMqGNUuI=;
 b=EuZl9PkTZv6GJd7tGoJ0kNVLbI82YDIrk+GacuHGLBR1orTvJ94+Jq5B+fEqXqPyfN/3s/PJ5zGzs0r1a2kN9BHczw3/bc3N3+QDHTueaGiebhbEQ0yZs9OQc4RM3I6Ty9oGxKXsWnDoGjaNIKT9JQ8t3aK0QXm7PI7FdkTGtGpspGuHUL7Rfwc/W/7H2mX+YaoNrct/M/pdpl+F5AOqOaNKxKBMO3eS1IO7AFlwfSvPfwVL4koum4a+RV2wxX+c/VuBb9czDznbZqMX9F3ULUKNY/nQOjD199xwA9S0Wd3Zj3cDYLLuNQWPD14sLh4EaqiLV5TuKtpx3Mnl/z+uHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5V6Gl80u9Fl660ngnOT6P0yQuQqruwwikG5KMqGNUuI=;
 b=HB0ASJsqKPYTEqz6UNX1i5kub0ZVzrce35vIGUhW1jhnYfVOj3UtZs2Hzjs4g/vceUwSdJfFSNZuF+yCQOp2UD5TBXN6/Syz/lWXSUSReKqtf0kRozeSLC5MsnDet08GKzzP/qy1OnR3JPWjftxWkhovyq3hac7lUg4XVQYrQBI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB997552.namprd10.prod.outlook.com (2603:10b6:8:316::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 11:48:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 11:48:47 +0000
Date: Wed, 11 Mar 2026 20:48:41 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qing Wang <wangqing7171@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <abFWmVU6hgqiNn25@hyeyoo>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <abFPHpBDe5DsPL2u@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFPHpBDe5DsPL2u@hyeyoo>
X-ClientProxiedBy: SEWP216CA0118.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB997552:EE_
X-MS-Office365-Filtering-Correlation-Id: 830aed80-239b-4a74-d572-08de7f6427b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	uj0lBpq1WKlqgJR3CCYEYPr8hWKu+amDouOOyDuKaIakrkPAZLj4UGKQkq4XHju9fWH/k1s6ov8wO+PBMhGhUatOqzhqeTN6QYxhTA+Y4CtLXts9FPppJpdidI6oKz7wmtRfaGQPPyznw4TCXagp7tzQ+R21RUcBE5TLU/CwfRY6s4yxIkgVzqa7UHNop1thxSnGe4t/qpfzRwqTzwU3+6hYQQmHMydyYQ/KRbqI7quqshSBrrClSFA4I3R/oeHUWrcEkw5Vr/NKDHzkuQ9zeVq+jE+BdR6r2Oa1YWFzk9WIeMbezs8PWgEv1r3rEWPopOh7b6Tb0NJoM27bW8V/kMRnTVNgES2tejOhKDHda8yLrl1nxIlBQ/5tdr7ojYCCekeNmXfW3HxV8O0CotI/Z4gOUtxmsU1YAzAXEZabLrHR1FIR2aZwqAG5AWWmtGgIRyV9psc+eMLcHUoIMLHqTJ1nf22HAAj7bx65iwpvDPnPzmfW6C/OT5m8jceqw10k3i40EW2HyDrAuJ0EoOIWdNGT26aD9Kb8nvPBY6uHYUisCjNwAH9Rhg324pCSHG6cVq6hp/l80h8nmxum2Fjgq9Cv2BuwU4BRHlbodOhmkL+1HhljHTCTSPy4aVQgm/iEkpRtyOgOkb4Oz+kygNFmNv3NB6wfhrsvy1ZBjyVFlVPS2DbM+vKSg5bf4JjgtQUsqckhGG+QVMD5ZzX+VgGOuF2xVNDmNWLaV/HjxyEucdM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MCziGuL/BX2uRcSK1DVJcpUWiNueAUNOlT+a58tOV9ae9XSdGgm2e4K/U1ps?=
 =?us-ascii?Q?2T5tkguiGV5txsA/El3iquze4jNQQ3duGJAo/2UGfC1aQzBdU+pm/ncvSSE4?=
 =?us-ascii?Q?fQJPXGwa2ZjKC9qVfpQvBvSKk61Enx+frbiEl7V7weqNC+Ino5W80HHXas5r?=
 =?us-ascii?Q?ga0rjsWS1q2KCN9At7QymuaU5FLm9UJiBewgXo81/MeEmABqaJb4xntr2l6t?=
 =?us-ascii?Q?M1Ax+ghAFQp5kx3JPR9u2O6YnKegwkQVB/ME8S7D8K29szI4mfq+Lq/WsKRr?=
 =?us-ascii?Q?y3MaHCNjSbQ/jO8aGm5vVpzuFDHEMXIi1pRQgILyuESyLN/izVopw0R7CUY7?=
 =?us-ascii?Q?mVugGuGAWTtv8PEA/CRUsqtKN7srqWXFpxKOjsAljra/qa308Zjm0G5yEaqh?=
 =?us-ascii?Q?Cvx2fyPwI9w7wjl4SPuVsqoRVMXslHdQ7kiQIHCQs104GCP87BBE8qPHn5C+?=
 =?us-ascii?Q?h1w5iAzSj3ObGBsDTfnJu/YTg73BZCUGD7mDgnlDDaCSqd/O7Lgu3DW1Y5K4?=
 =?us-ascii?Q?raqZgHlKnnOtRYnpjmegbPofedqaljmyWfYwAeMaLj+2ujdDibV1/pzvjzx8?=
 =?us-ascii?Q?YtmSzZx6LqRy6hU8U4Cv6p3XXQf159sdKlGU6iJQZ8bwcgAS8BwmTkZZu/hP?=
 =?us-ascii?Q?WTj5P0/Gqgcg08PGqAysnJ0K3MaeAL5PzE5ZCEwYz+usJ348HH9lQfnltIFD?=
 =?us-ascii?Q?83Snu59vCJv78a221yFEHTtXDKBpwkX3lnkSi2X9Kod1mZAX1bg72Qfwi63C?=
 =?us-ascii?Q?1FtH7QaAlpiVnkJnnq0bRMThcI8E9YY+J2vDp75o3JsiKw3N4fsFNxoHnyJg?=
 =?us-ascii?Q?13hUHO7RdB/9YMo0bTAknWc4HNXnvBeX9mal0gmHGuCtUe8wPYrhX2Gz8DX/?=
 =?us-ascii?Q?W0+GBgUHy9yUeCAgPf5qLncdEFbAeOChj12sKt7WifeRhcKIH9/5TETcoDJ7?=
 =?us-ascii?Q?e0o2IXm3L1auER8uvkykTmzwxS5MfmzFd1Rl0I9VzsuLU+d4MKcuLbqUCeLg?=
 =?us-ascii?Q?gz7RSfYbAlEMjNAeM+0Ou9Ey7g2IfWTBSX6RwBFEkUZqGwSBWAEVGQPEwDjn?=
 =?us-ascii?Q?jDjbAHnyr5Y6iPlVFJBtNUa2LHKBocY2Ospp5r3T1NBUdYepBh8r0kQkQcxI?=
 =?us-ascii?Q?cvTGyy8g1Xke1Nwbfc8yWnT0be2QUBZPh5O+l80SrGF8shFmwtsCsVkuhdAF?=
 =?us-ascii?Q?+caXkY0yJCXLJgTZsfMKMi+bvfq3kJdvWscRnBymhj7+KUWfpDo36z6+kdqM?=
 =?us-ascii?Q?b3RWTIDWgtdd/fesUJvEq2TwGA40iOQ4qBbJVfWd9tbOQkeDprAfS/trTmtJ?=
 =?us-ascii?Q?anVCm85aBVHwnBeOb1AnjaEevTiCH7KNVOJlMY38rEJOMOu4in21N56+bO8z?=
 =?us-ascii?Q?lXiKkvGPy+a3q3sdSi7MFhd9If56/yzUFWRRJUXx4FqRRnxoWtBwmf1ugJf5?=
 =?us-ascii?Q?NoH8ulkqnV0sE64QlAzadTe3NFeG/gKVM3IhFo2Vt7c9bAj5mRtwY8yz8TiX?=
 =?us-ascii?Q?Ooe6X/PIlTrsl2w9DnDTsSGPhPot04grbPamTxeyJJOAJDK55dFg9uG0ijQl?=
 =?us-ascii?Q?9yH/Xdtqig3NNDKnfKqdGoKjqWhsSUFskqR3tiqBkI1PTQQvhwVt4+f0vJE6?=
 =?us-ascii?Q?9W+7I5SiBul0WGeOop9PIvP/d711crA65hc1iHztXIsVeNCcMJMqx0Lqf+ia?=
 =?us-ascii?Q?RmPKP8VzxKDaZPs1lJ7G1gxULQMcjTwN6ExS2GDSh1GloRE1nvHMC/Hx48Su?=
 =?us-ascii?Q?ME4XAXirTw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Afavns2Bj+7jTZaQ22soinCBP94CvQGNr/j+Bwj3riER97ZvHWV8t2OV+pSVJ+0f7fdw2vUTlHoVkYxVmCqsGbuz7Kjo+eIrN5Zi8V7jWYh7veP4CjNideisps95Hz2HiJNt45bsVm2BR6PvjsaY3ZHJWTUO/foKAQtgaipA8CNTCyL2sps2KOo+ZUJJSMYuCtgQ2RHqY6erNpfcbFU9HN60I96OYtc0xKxE0bD1yb59Fft70PHbGnKsqMaPxiugiZEKmmRHK/c0blC8sCWQ5uh7wW8a6Z2gemn06vu7d75TsrT992G01yfh/pCC3hI/UQQY07QxKwOyRHGrEHM/2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vyPhQzJvjb1EbanCN5ud2mS8Ch08WsuQLgecEtN6R3mIKiPH/9WfbI701urOEOjLqOZiNB8CD7Rmkl12oM/11OK2gcEFiyJUnpjO6ycsIoV1akjqLJlNOzaZKppqKlFx4cWxErF7hfKoVgQI8nxV4Z8pkYmO9NSSrFyU+6CuyVFgalnqpOhKXkf8tuKQOv9FUnsWShX64PLq2zorlUiaEbUWIkoM/GCkTrRg74c5ZN2inSa5Y2Db70ltz5cIL/R5Dclv8krXJEEcUf6QakaO8HkelynNjcFHrXoeEOupAR9MT1BPRaSGdJqvbAM4SBd2gOqb3AmOR6d0ZFIMr40Vs5WUUnlJItl85oIkf6Ko9x/l6Ak1fR9KSsTT8Au+NALfYAoPP0OYXRIS1lRRW6bO6q+6IQ1lHX2FX4lTBjq/1Y75YWkGGsI/EQuoW7/WQODS/wxS00cSK5SzETz+WwEuoLfOn5LnGtyLel2mWS6q6VADSaxaNQOgbcto4mAJdNi2L9cil2mTyEGnZz/ulNmg4TvtrFiy0Oiy21WKeD19h5UZEgfXI2lty79dueQ8U5UrM2dqg/2l5kY1k297oaB2qCjLK2o6CCM3AYvmDcBeFLs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830aed80-239b-4a74-d572-08de7f6427b5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 11:48:47.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SVTCC+HPim0hpkhxJNwzztVsIgRjpH7F91NcKWF6z3mlgjU5KMndildgtP0vMPI7wIw3vb8UXXvgAdn+TNtuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=541
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110100
X-Proofpoint-ORIG-GUID: cJuWxPjYCrs97BaxVbBW-GBnAiqMYPg1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA5OSBTYWx0ZWRfX0glKbpub40uv
 JGHAENjKQEvGaTGJVidCs4HcEkE9+o3mRHlKaNhgU2uEJy5Z/4Ruc1g20VRwZL4grMBGCbXpVsE
 3ptGMmJN1Vgon7+pyPeC0/Gks/s1CBpTrkOcRrb/hW8ZpU6+QyvVArdkbb0pRQpTDRb0nxmIGjN
 CUpz4bzOpTqDmtAwDYy/5v1kBlxc2Ir/ArZJvmDEs3y3UmbeOPDIEXlpFv3+HxfxGTra+RGgyPb
 clmS52e0pr4h3iLsDsv8s4AGDm/mdlPZnjHAmUU5vWKxfbXTOJkQEXRer21qn9GmVA5Cxsu5XSJ
 qffTubfpTYcNsCRK0yfx7G87rjgHPKnetxnVI3jxEFBJ8eGZk55ACH6aVnAuEXjqpFSwmIIwnO0
 xrNd9E6LVr5iqq8hjNmMnuC1MENN8ehii8GKco5mpJigz6O50vD4U2Vw8MdmsCh2f2j50Q779Lx
 JBLPXuefixxMhidfECQ==
X-Authority-Analysis: v=2.4 cv=S4vUAYsP c=1 sm=1 tr=0 ts=69b156a2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=z1cl05XMLQwBOLBTmjMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: cJuWxPjYCrs97BaxVbBW-GBnAiqMYPg1
X-Rspamd-Queue-Id: B3EF5160003
X-Rspamd-Server: rspam07
X-Stat-Signature: 3abakhdikqw7jdw8f1fdyatnofwzcmad
X-Rspam-User: 
X-HE-Tag: 1773229737-435942
X-HE-Meta: U2FsdGVkX18928gGwMyLU/zoRa4vgljvA9xkeZOHQ6oXszRGF+KmifXrx2g9RoVQ2A1spMo9bFrHYxNB8yaOL1UMLCEhViA+feFA+lQbU0MnHZiW9TsuNAJ6s7xZmUBkTBhFipH0UDs+fByg4k906bk/t24ZiMmURr9uX9lETRJj+LoOM7J+vaieA3XKEjjQpO+CK1vXQ6fsXu+935mFkhZ+IrRVx12eT5R/Yqegl32WGutDruONMLwsFVkBBNgMa1DGrl9HhX1skFMvpStteaQhkD3nrJ2iKKiGT5wfY9v3kJwaLcW+e9sl7rA81y+iVaLIrsxY7tzcTNKXdQXGAwzCg/FPBrGs+MPwFqHfXWBrizUX2H1g7Xc4+zzrv+h/KSDLzPhL4gEhVCDFC4C4Y3iB1cQsTMFI7ilToRheB7BpNoGBJcOGXoU4WeDkxFEGskdK1OlYNtqXjUpBE2Wks/Cz2JowypLFLDu+RDlz+voHCFyNHBjQYEqu2/CbchKoJS9Y4oNlatEc2io5ULK0/VDLeAa4SAQBSeIUmI299E7+i41QgZJbzG7MbblFdc4pn8rAD7jnXiAf2bzWbnb6hho42zaUBurxNIdpxPZXIbFtROWEehlXoeYMT65nVbBpsz+B0Z+bmvxaJKrU9bCK81XUbkT/khqdHx2jt8T0SgR1SYaRnRonkypvwxh0o+eMuHI0l20A2w2SM6NZiAukIPX+rplZdWFFFb3Yx9d2RV9tu3Qo32TYZq1WJWGvhm7/0y+SbR6oBBOQj6G4GnTwiAfKza7OsBacy45i8uE/PsLJrxm22pCYiKVPn56QklQBW1WeEaxu+iX+GFW9LWKnZM9rHKZU7HNGl24xvBuqWD0wFE0e/Di/7DADo13dizyA7P84FpfVzTT/oAzZxZq/4OxgOhPmlSlOmFSBpg3orjBvr/n6xf4YS8vMvZEaw9V/iRrOEFoiSWEgnVatEuv
 FLcTmDAr
 IvMc6UycS7KwuEyBknAynzrBc2HG5apCdRfRDzZWICYKHxVNPPzkxEMH87jTYv77T7TEBf6KnxkAnDOB0UDuRDNbGphBvRLJOGR3xvZkW78H0JYN9JAY5fd7sEulmAS6UZWeLlO2XYN6HQmRW+eS6LsQCLN5U8OI6WIhKb8AuaeMRy+fIqLV4nGGkjXLRhhaGec4qSX3Z1s0oWxGT0SIZls/GVUu8zT7zSIMG1eDQRKUW1GYzWOymeg1/czhwSdQDpYMFOQtTSO90ZHyLte5x5mtHQm0a21NqLdDg8wPXO4cH7MlDmzy1XpdI4NgLU5vn5od4Eprnsy79lExUaxMFh5gU6zF6Tw/qqZmoQg+vY/QGo0SJL0A05TFOjN/X5iFDG/QmtcvcTrkcPOCFBR8ZOOdEvfMp7LPNxjfeRFkAtTl5uszDHrTBFo1a5H7DjHXGNhOEwW9FLPPcb1SPryQgsDjNY/SDC7cgoCi2OnF/x9evzhfWpsymZM29WI9IIbuTFZk4HQ31MGD4OFRPM8bkxjfFTHmfL6W1701vlEo8MCNInE5W1550BjddfhgmqJKo4WKBc0gYVkyicaDuHfzqHDdKT4COfZGZHUAcTgA5hlE9OzqtyLWdokBkCQxt9qAB/Nrb5/ixfYSox1ht8HXQUSBVUxzzmrBv+BZnXg1cTCviNxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 08:16:46PM +0900, Harry Yoo wrote:
> On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
> > When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
> > but need to fill 10), it will update sheaf->size and return -ENOMEM.
> > However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
> > directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
> > causing the partially allocated objects memory in sheaf->objects[] leaked.
> 
> Nice catch, thanks!
> Probably the need to fail new_slab() made it quite hard to trigger and notice.

Just out of curiosity, could you please tell us how you discovered
this and confirmed that it's fixed, given that kmemleak won't detect it?

> > Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
> > free objects of sheaf->objects[]. And also add a WARN_ON() in
> > free_empty_sheaf() to catch any future cases where a non-empty sheaf is
> > being freed.

-- 
Cheers,
Harry / Hyeonggon

