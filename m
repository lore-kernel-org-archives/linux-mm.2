Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B9FF5543C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30746B0088; Tue, 24 Feb 2026 21:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0AD6B0089; Tue, 24 Feb 2026 21:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A4B6B0092; Tue, 24 Feb 2026 21:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 935A06B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:26:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 484591C438
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:26:37 +0000 (UTC)
X-FDA: 84481390434.20.28A6D6B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDA991A000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:26:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lwHKlOHJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kg1w7vOC;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771986394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtNqfAGFQbPDgyMSU+4xTiPP1RCOvZTuX/fADsIvA6M=;
	b=3eEoY43Tercw/flPHwQVOYbndfOMXmtVz0mXtdfM2t1mXtnVfrRHNLc0AxoF2SnTSU8PFY
	Y/zHsEVrki/Vj9zSxpslptOG1cqZpPTETjAxYlhzyYerQPmCcEOlvgICZF7YL8SKIUOOs6
	7Fk3TK6HeZ/fIdbDXA98AXUHHnW7UCs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lwHKlOHJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kg1w7vOC;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771986394; a=rsa-sha256;
	cv=pass;
	b=FJRhXxLXj4ftidYC6YmGuYLKPiBPGn908GH65kpDuVr29/RoL5TY7Ecz1bopvLx+a8g+4L
	5cQyTVfEUt/INiOqwkW7rd7Uf+k0DKPsPG/DuC8q7PwhNPYJ1DVoqFtLroIyDW3a67tuzd
	69pVPfK1uVhxe7GpgrhUHXHmWUkKF/o=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIuGZm553451;
	Wed, 25 Feb 2026 02:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZtNqfAGFQbPDgyMSU+
	4xTiPP1RCOvZTuX/fADsIvA6M=; b=lwHKlOHJAm9sSNvwUT/vRwuSKu913+qcv/
	Gjis4q8pnrBjLh5X8WvFLB2OPdn/xrM7IKpqOOoRmspHhi7Oty2cq7RxxyV9XtAJ
	bXLxiNVHuuJxBZ1Z6+trgvP3e5c89oifndJtx7fbX2MKLqhNnKejSHiV+CtxsSGX
	Mqbwzt4u3JW5L1t8AqqrC7ivbwBwkjjRIWN8BSVy2zC5k3U4wSX0Mr6lGBKg3dl/
	XFiHrtoNAdiTn0d+76cI7d/GEfrmdSOd6XjiVf2vk2vTO2ts9/qecDaSd9ncL/8j
	MruzgjgvNGLwQiANJDBfboBpCh9qoemRL4pBM5M7vRLAm263o9XA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3newr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:26:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P2FDnh027846;
	Wed, 25 Feb 2026 02:26:25 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fhbh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:26:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVsoWKWSQufuJg/FF0mM8uD76DIeZw0YPFZdxe5rBRMFoRgvKSunroye9F63oMbkALRguEubs+8mVMloxX8BixBNWWxf0nFY0PiYOyzhepv4nJ+hVemFJG/12I3GuIbVrby70Mt8Vy9hJLLv8qetGiGcbanGV5Bo4HmmQm+3Vo/ZA7ikIbsjkSlhxP5MuaDfq9efB9uqfiL0ZNbwUzG/2wANQqH9C1wgcgNKlutdWQLO2JPJ9hWTdNYiRjT4poJq1+/IB3uJFWWRa3p0DdR2fNLhWX9jvHB9G7Igr+77D9ISW0zHq584ZBTx4iZ5kfqb0uY+f0JG5HteZ0f7XbeMEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtNqfAGFQbPDgyMSU+4xTiPP1RCOvZTuX/fADsIvA6M=;
 b=Zb4Frd2lL9ixWfuFwYJhmr9NeNkF9hykDTRNc718XtNa999Ya0+OSuKggxrZHho+A7Z3Rou/o6fuV+jnig3O2gBxBS94VgqhEJT8Ny4b8mM1xaAAFbCknQ5FdaPazUQmmhLA6kb++Lyjl7DYdfAg47FkkSY0rskhXkdEixIuTZq74Mek79v8xzVXX3HR82AMM7LAEgQGdCMdmTbML+td0BQgaMRxaRrJE8sR604Ufh0kfqIAuur14O26Dw9RkorXH08drV7pQQDJN77yOMOSHBI1VVPJkp9ULdv+4QHG43K6pVhN9++Dp2DkumDncoSmghx/NSYJmei8TR8EFb7k2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtNqfAGFQbPDgyMSU+4xTiPP1RCOvZTuX/fADsIvA6M=;
 b=Kg1w7vOCn1B2HGvth33vJrAx+GM4wcg9qy6r7trcBf+Setu4f8ax+K3SWrS1LhYIwSgA3GClemH5PAgnqwv9fHwcSiEoWB2FvTLBpE2Ize5v1T02t5Hi6VlN+4/zcjDtdvG7Fv2tylxh0T36zdbzQL7n2it+4ij97iCi8gATMWQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5756.namprd10.prod.outlook.com (2603:10b6:510:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 02:26:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 02:26:21 +0000
Date: Wed, 25 Feb 2026 11:26:15 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, 00107082@163.com, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs
 allocated with __GFP_NO_OBJ_EXT
Message-ID: <aZ5dxxgIb7MfuRVW@hyeyoo>
References: <20260224221132.1702713-1-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224221132.1702713-1-surenb@google.com>
X-ClientProxiedBy: SE2P216CA0092.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: 5832a7cc-b042-4601-3546-08de7415437a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GEjMDhOEsFiNPf5WRTUncrIEzJHmoLAbcrxiXOglLbZl1hUhwYyINBBbOd+D?=
 =?us-ascii?Q?4X3PYaZe/BihoMWNk/ZUZmOHIKqHMYBLjaIWM7JvVZ/TxIYlKY777C9uWrYo?=
 =?us-ascii?Q?vHt73gaMORM88muP1pv0u7pRZC+2dbMhRBYeNU1VsuC88hqPCcdcOjalVa6s?=
 =?us-ascii?Q?evhUKnCns8iLsq4U80CQ8aU4HK5q2/xGKjib9ofEZgtxlRvAlG9KiXtgc/DH?=
 =?us-ascii?Q?jKJCg+8H8UbhJunBqcRsMY/aRDxxDbuRclfh2uypELcPPsCc+BRUWyMloM+5?=
 =?us-ascii?Q?/qrBnBVSD/mGg+/RscRIt74pjmNJ36bge85G37BflZi7PDykvBGFKcbmvqmg?=
 =?us-ascii?Q?dfsug50r6rR8K6fM2SDs8VQ6Nobklz6jusk+1U488Kn//ikSCGgGIlZCeMYL?=
 =?us-ascii?Q?GGvF2bMzrDzBjDnAdQgei4LBY9q1DK+pEF81GwnNANl2wogKRv4ToUYpNfrU?=
 =?us-ascii?Q?EunyGPLkw+qVaeLnk4TnawU+qLUKNF12Z/zcmBHrjeCeyBGWOLjxPFUfwLzh?=
 =?us-ascii?Q?GPpJ3BaE4xhR9EiYbZqQkoN74EUp2DwN58B58ZZT98ThEHHHaSPWLWKDZ+5O?=
 =?us-ascii?Q?g80Lj92BUfTc5bIMGC40DrvBLIePh5pW35hvztVkCp2cVt3ZmNnu8EsDFYEc?=
 =?us-ascii?Q?fUAn1KKy6fvWS+m01GYXZzgIzgMmHWzj5FM3gkznpErxoXLJqSpCU50sJYAG?=
 =?us-ascii?Q?1usVh/WXwxmo4av4AepH8dcDLDKbChq5782YjsHvFU54hNcsJ9Zx+uMzNBrH?=
 =?us-ascii?Q?vA43QvVE5IqDIgmtn+1vYyyDqOUmlmNSN8dLSnIUJbEoJjTWfM09mnCAw2yY?=
 =?us-ascii?Q?eeCn2grQtywFEkGT+tQznHDReW4EZQm3/oI1JN0HA8zxOAvxSc8Ug4NCC0ne?=
 =?us-ascii?Q?Lwa+WMd3VpBpIvkwQiuObZ0Edxr6Q7QmNhZTO1sJ6lBUVJi6XYVThLxMyYwz?=
 =?us-ascii?Q?HsMdR0bKrbIUjDrbpZ8gNiHpWKfg9NF9LK6/Gy8xDgX0TDhvJma07CMBg0xE?=
 =?us-ascii?Q?oWI0lZfLxCFf1T1k9sKW4kfvIHVtb7Gcw3cC/+Zs0FWLB3EicorBxQ9Ss6zE?=
 =?us-ascii?Q?mfDUTENuLluHqLwYhMQy+3V1sMQSwBIq4CytNZGgL6yNuh0orOl2COsuWphW?=
 =?us-ascii?Q?oiF0SkHaBwZ7gQmHZR15eex6eaHYMAGhItXM+/81xuySWUI/hHZQPPIjR1pH?=
 =?us-ascii?Q?Xcoen8pUd/85DCBNondDHbuYF7xa+5PWV7yhjsLzW8hNe3lCn66eA9+aK6G9?=
 =?us-ascii?Q?YnqD4gbrR38EcIYRSWnPM2mjQ30w+dxtVNRzbul1Bj0uzQFpW5uDy+pq5qZm?=
 =?us-ascii?Q?FVcYjLmIpBoc4essq6U0cqNO9bcTKOkpBrj54Wuj8+7Z0mUpXIV5sPjGZMHT?=
 =?us-ascii?Q?Ugq5AWdkB/2dqoR58fcS+R+1dGMzdxcb+wsJ6M5BiYouGDDynircUoRvts24?=
 =?us-ascii?Q?OXZyKBdcZ0vraLGfKaZsExqkFsvTRjNGi6jDe5K5yIUIkiQNLH3CaoFhv9nu?=
 =?us-ascii?Q?fzT8DEV2m1cS6ZqxPzA5jiWe+HPlR8kt6EeKLKk8n16hC7T4DCqm8WUlHrks?=
 =?us-ascii?Q?6KF644iCFucKOEbLR1c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iFOPloL96CnTemZ9S9frt5y+DUx6vdbkZY1/gm9DsfxttnsFMkW6PRtxqwAI?=
 =?us-ascii?Q?qUaUpew1LH9Yc2wgPjgV/ufQF8wOWMJF/A6tIIMnaFIo46xrQmNXQA+ucWD7?=
 =?us-ascii?Q?9pprxk8PSp4YExqoVqF29Pt4U8kGpNMZ3tO2WZKIVYOEkXndXRoiAFdYEgO9?=
 =?us-ascii?Q?462VQRugLyvrkEcQ3MfrzRARlEyIsTC3u3zxdvPEMBoj34Mi9rrcsuvUJIbV?=
 =?us-ascii?Q?DfEnPw4yV6+KUOYTkc0iKEkj7trBSt1Z8dYRavyzMCiMnmVH2CO7p/eNMWeL?=
 =?us-ascii?Q?CVO/ZRyfRxRUVjZ7tCAKU0Q4wrRpHsdpy3Wty+pMEvFR+uIYa2T9ABDa02ji?=
 =?us-ascii?Q?1kvC3e8zj4Row9mWyf+vMuCUOU7oy4vb+0BFjvGuJ8rqUy/hWre6NZ1jmlrJ?=
 =?us-ascii?Q?iak3Dk09gGzdIDvQjEIRPu2edTBelEr3kszPUpP8b55V2eBdtoiOxMj+k6hx?=
 =?us-ascii?Q?QHdgDyFQwT7G7/yXpw/uNF3G+VDjV+jNoR146X+jXAbOMPro8d3i3YcbmHSZ?=
 =?us-ascii?Q?4EW9GrtPqxxLfhDnszgd0bdVGBkzssTqWpXqP/jPkG4mp1ZfbZE9hsKELxPR?=
 =?us-ascii?Q?xZYXTGme7J4AU5iZOgeIR7zKD3IIRfdEcmqOhllOYUJS9BYrYGGYwnoruOKL?=
 =?us-ascii?Q?wIpISdf2DA8r3AuQltBffdD7GMne8fOFL5SwAeF9Uh4ttmajzis6BKk26Kio?=
 =?us-ascii?Q?3bRSaFxsDCmlaR3nNk/jeiUAjvIVbJOwy7IQCGAXL86v9Oynt5OkTm2tDCf4?=
 =?us-ascii?Q?4y7mOSJ77vEBue9+AmBpg3nvrm0HQCositCVpaBNE/yOsZ9yGAWsty2fmgsO?=
 =?us-ascii?Q?drMXOo48qRSMYyyOIlA8CLtxW03P4wCruqdNFniAP/vse/ColScFarGfNHfK?=
 =?us-ascii?Q?slfLYcckHsHhtHCzA07QuXTNUnMMAfmQbOkJp5fDR3bCFCX14eX3SQuwypwa?=
 =?us-ascii?Q?yyWd4RklpoxhK+RLq45G3HnlguifsEFIQtuQTpFmxGA1y27PkP4nIjjydwyt?=
 =?us-ascii?Q?3klEGLG1bwY32M68KErYK9sh1uDOp+dq8nAgH9ojxonBAPnxXqAsk4kOZnkM?=
 =?us-ascii?Q?EZ3tt2heH+ws6IbnyYXRZf+OmBJetTqIY4+GLbcYEYynflOCB7cF+rkfkEVX?=
 =?us-ascii?Q?JvAxsUNY/MGhsVvH/IxvOmy0LaD22Y52vf9tMTx+CnHWCSrdu/vpXdoxVfii?=
 =?us-ascii?Q?9X+mqVWLlcm8DhpeartWoTQIStcRSO0VIgV3PLNkVjqzEyR6ii3n5su1L8hK?=
 =?us-ascii?Q?AsJk54oXNyaMtF33KnKQvL42fvD/Odj18kbntPmHyAWbCD1sAJaAlpXjw4C3?=
 =?us-ascii?Q?jW8wTxXSZvjek7krVcOoDLFk3Iyu0wP+ghXtbE/VYKSXznu3CtHuXXf9jJSB?=
 =?us-ascii?Q?Cs2l+SX4wUcJSIlnLJmCxhKKgk89N58Fodp93rVykQDz2phGlwxflE2PiF2S?=
 =?us-ascii?Q?lFSwgJ3k5y7fVyQjRXOC1Q75jLXAZoErZOi+ScfXQGh9ADlvCHNjrtZWPtRA?=
 =?us-ascii?Q?Xv/qIuTkUES0jyxyjEa/xFH2kA5bWDXJwiVVFTpU4X3qv4pPTsBjclx9YUtt?=
 =?us-ascii?Q?vP7vQdVyjXHmPvqzekUUk2OP79MevSxMpqryXvmS6i0c5qK+KOmGNWTRBqn9?=
 =?us-ascii?Q?0hl4pjnePC/LjP8nQXFNFYBcTahnBWZ2JyKTau9iEt+92ErxU0BMuv9kdqmr?=
 =?us-ascii?Q?YVCWiM0/EWpqRWyH9a0cPq2dyMiGgWoHomylqfNPy4xFyOOlfuhL0DI+t5KP?=
 =?us-ascii?Q?V2c6HbhIdw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K76s1Rzi/HsTyY17EbMHo9cKVdq3UcuNeoWIgDOZPgqVemrPaB61INWr3bMVh2KMkGM/EP1eP4QYcMDd07jibv8ubV8JyDIfarvoNT+jwTk2BfciadtRyKPy8p+ALz6QjLH/u4av26GYAeM6K8nf8AkIoPezPhUQwCxO+fJoHke7/mqQvq2Dy43ThJPFB51wjMrx/RsODxpdUnzVWVVWaJO91+/XtTZxgZAr3UsoYEBGdqcgmi0QMR2RKG9BjjyATaFrYJI3X5f+8/NL/HoyvcBKaH/Oq8/Jd7gK0NlFlm+wslPaD6bfiZR3CTfYuqDnu3r+KYJ5KUsm+bJVtW+ZnZmus1cso7n6wHD2beWLxHxjo/BtQEiLGAaZBRPH2CttBtAwd4z2ob6Krvhs8MRMjsjG4iumlmIvmSiTXcDdiaW/syYIx2AR94L8mLkP6ApUPloLMlWizL+j+EACQk6UK46rPj2W979fyAgpZeHyJIGLMbpC2TxCTEmP+YzrdIN3HlDvTeWmthImOWOiIxQPOK/wJgPhzoSWW8lFS73fBfZSjV55ipvYDxaY6puRo4DYBMCuCAe2OcYQuPbFtLJyW9RrOCEs3QjpFUqlgoedQls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5832a7cc-b042-4601-3546-08de7415437a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 02:26:21.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeuQB/twzw8n3wWkg/yeM2eTD07Yrutqy8Y1ELIi2pKsstguIRv29p60sbCyLHfztYqcPfpL1TSyg8LIdYtjGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250020
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699e5dd2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=Byx-y9mGAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=1J3BH7y2GN_DUvGRlwQA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: JtVggWrxVBRtGkIN3axGMUgOgpmkZlyI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAyMCBTYWx0ZWRfX/UtWuRwp6ydG
 TrNe7KSwqbJ1tuf59H0xnpRqiN28N88YH99QF2sQhqjzImIDpu5K1jGHkIQ507H4iGhTRS1yjIL
 6Y9QD2mh7mj3wjE3LIXN8pOiavZ2eGyyPeL7FwAaU9itlOfWVYKjFLIUivOjzQ5Geo0oAr18m75
 M7VbzTGNzVTBX4NEAxjvhH9An5W4S51KUtX7LSIoid2/f+XJPVufj9noDPVHjKldQLIKIfzavLu
 LcxZxcxF14NmlVW9HEyblNCaUdld73inybZqFKAZQBMly111BNaRU57pQTGGbSSqo6uFFYqYpVo
 0Y7fWpPJmuIQhs3maL3h9AoBLFRxWnCgwiKiF8w8hAEhyuVx64Sr2+IM8YLdeRlVjQwsfNw5tYl
 Szdfcvg6uAHIn+Xj0lb+oVEWp088nQ3+b39AhZvt1Ti9tUoJu0+XqACxU/KKLfbKk+Na3oBjwYk
 84jJq35hDVjqP6Ju2Ih+ZDi4jkbk0XJF8P07zBGg=
X-Proofpoint-GUID: JtVggWrxVBRtGkIN3axGMUgOgpmkZlyI
X-Stat-Signature: cit1i4hraizg646f6pcyyy9xkofqdydw
X-Rspam-User: 
X-Rspamd-Queue-Id: EDA991A000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771986393-142827
X-HE-Meta: U2FsdGVkX1+OWntes8OmxLRc8Ks2CXuIi3uirbt/UxJj/25leMG1hPDipOPDUQi1K9GdbhbVjwhgRtmsq9lk8JDBgrzM4UwgAW82jQ7rmE1y1m2Mt4IEFd74WKO74EmkTn6vf76aFzzrvLUQWpy0kVqpo9Vy2lpRctPvycP2dsrSBSMndwYmFVs1byzxUJQrFhv8efYs7O98aShWBxsq05Igcy10tOc1O2mE2Yp/TBLdSzJY6fGFQt8J1bE5B8qMNYphBtOynSf9YWUoqVCZxEhzK9eEemvihVVGGA5qbAe6qALpuDKjETsX/6g1EpWQzb5OvNJix4xgpf2aH7VMseTE2t+Zee8dJVSpz5K2/RSXrBIrt/TyIV3NjShzTP1ztUQP4+E8Mm50WfSFXnwShe6QFab+XihFg/f3i4aYsGg0vQoj2UaWKRh+Ke9MGyyrk6afANAa0syl5jPaPRLzV4BwFPUQhZRwSaKIB/X0wfrvUClxFRIMl7noThlsBRhryH7VWWMGh2rhQUCZc4gxvjjCJPgtOfO+bQOScDK5bRda5H1MvB0NYf1BCrBCWlP6dO/Zf6C/qk5QGanW724Vz1zpxUXpkyqTmVm1vLDldNuN5tNZH1YL++14i8xI53Z/bpyBt0A7o31/GVYuujwdmC+lM2mxxTgaQgTQZTPopeRi0kRXQ4v0cBtHtfcxZ/aG0ynIYVJsq/PBO357PI240TNczqOe5w3ZxiTVxDHtSiXb9JvDrFq+YqxeeoDwviRWAsqFlGi7HrYWDt5YE8S/N8JgsXtIkj6sHtW9TPiJO/S1bQy4L/rMJxdWmx0Ekyz3EZQEr+rfg8AI93byP7QMW171DQ+Fy59yu4wmrfoIl1o5qo08IFKRBB6Axr54LsiUsQdXrVtx6Uh5TRQildq/anGMHfHJgQrly0JOrLEhnWPsRd1yj8HfLPt6Aao7lfjJlZRTJ2JoQWBSvyJQSCs
 0ADeHFeW
 QKRLYTGbHDDS17om9MWYPh0XyMgrNV4SwdbyVg3J+4Z/S4MmFVPZ9wxC+wVxGVjhRuqtmJMp/OXSttw4fgUoqObyYS1uHF+sFPzX7zMxmWm+E1oLwWUO0SE/fyYB1wGXLx683ZhGxywaEosWHB1UJfbcuHroLYwjMci71/0F//5aY8bftZSRIH7OWeOtyCKPVqZdBvCZUh7DgYpp7oSaClFoBEgklbH5VcydYPf9v5SDksuwrRP+Y1XrAY+PGh/Y1VDj4AB2FIQ2Zjv1usHV/xChMvor9aKut6lEeJt00qQlPqbNz3kwExOhV9+FmLUMCrGzIdqm0yLH1GBulFqgW6AevzKJTqgtqFzNl9++8QW8BGXJQwep6sfMTZBW05MPVEx575TuSjWkr4pq4p+XZDs9WJdwicZsfJKwpo6+AjuP6T4vtcbumcbRlCrG6FZmkoS+fQAlIGM3A2t6oPWZSXtX7FeWQlJMLaOP2lNrQutTuRvKf7d/z7+1bzfwwtXgcYvIeZyq9XZwPY5EwKTnZKSrDmc3HmF8Y4OV+Tl0I9NhKQzeGOG+hvxi8Prj/+rqs6726TzqSk79C/MmblCLugFNfacpMPVK+SE3+BfMKoISfs5oYWKBb3N8PWY/x8roKIdFV25oq8cGvFuXL9GkrGway4mzhi/lAiI1Cdlg+/StCZcQYk/nibBLCJkafFmXxh2pIYvS3xVRUUtiKPvuwpPm/WOwA4sk4O8pH4NVsDz0GoljyxbDk+BqgysaVMomkuhZjSz3RCGRpfdJ17RXVUm2CYmn09yeRAVucwFb2Fi+fL8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:11:32PM -0800, Suren Baghdasaryan wrote:
> alloc_empty_sheaf() allocates sheafs from SLAB_KMALLOC caches using

nit: the plural form of sheaf is "sheaves" ;)

> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> allocation tags empty before freeing, which results in a warning when
> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
> tags for such allocations as empty.
> 
> Reported-by: David Wang <00107082@163.com>
> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.com/
> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

This resolves the issue on my machine.
and the fix looks good to me, so:

Tested-by: Harry Yoo <harry.yoo@oracle.com>

and

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

By the way, perhaps it's worth adding a comment on __GFP_NO_OBJ_EXT
saying "you need to call mark_objexts_empty() before freeing the
object".

-- 
Cheers,
Harry / Hyeonggon

