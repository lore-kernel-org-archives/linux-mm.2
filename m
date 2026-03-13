Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAA7105F781
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334CF6B0088; Fri, 13 Mar 2026 05:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7526B0089; Fri, 13 Mar 2026 05:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F466B008A; Fri, 13 Mar 2026 05:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 023256B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:27:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D72E8C704
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:27:26 +0000 (UTC)
X-FDA: 84540511692.28.0933B14
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id A754520011
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:27:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CRjsATZo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=csudPi2f;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773394042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Se/9iM15FxD9P+Ptgb/4maqmPqKkCJJTdUFu9UMEMA=;
	b=U823QOldz5CwXryUq0pCf060zLWcGLL3v5fSEO2MAGlt+2vOJDZ7NI8lEr5osYNE5kGmDa
	wIsj7qWW9qtuCm8AMcyJn0u6o0wMoabQ95xrf2DOqNaF7BPkn/KujQ954TZx0/Bz1jfba5
	fFa76QNEY20gsu6JyzsaXWPtFRLV3Sk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773394042; a=rsa-sha256;
	cv=pass;
	b=HIyMRKm53KDBLCtovqVuEGrnuwxkXSvAsZWjn0gAtWuJUM3tTFqTYD0HSCALBFqPCEkMc2
	CpDDgEkoyJhlx1vylnuaEwCvW3j9ZRwPtm7XXQOk3bon+9qFhB9v18XOddgBFW8HEcUZcy
	aHL4LQvTbZi8/u3ySq1dDoDEoz7QsvA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CRjsATZo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=csudPi2f;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D9GdY01044579;
	Fri, 13 Mar 2026 09:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/Se/9iM15FxD9P+Ptg
	b/4maqmPqKkCJJTdUFu9UMEMA=; b=CRjsATZocWt5esp1I30sqAp3sSn79W+Rf4
	Zf+rTIexVesaZ4he17ugT5oFYGO5ECq6Ds/eGB//NMjCn5L2cMdCqiR45ruYg7/L
	CWUUXcvRNaZgGwCCTms0Lv/yZ/Jvgz8phmkamMwWRSDmcAXFMYRSOFrdavVb9zgw
	1IGIG2ZG0EVZyev0IqhG0CJWrLhdVmtjuhPnK4DZDlid22jwS/mx3SgprVB/SS6W
	T1KjopW4ruvRQiCc/gzqkgTpv9iEDMQ8g6fjecsRX58Uz1XOKvXAsR6H/QXxvKbh
	J+QYiRaOKd9LJw0hCi+id4VOpMXXxLsejHar+6f4y7arX1+C6tCg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4rjhxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 09:27:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62D7kEdi002051;
	Fri, 13 Mar 2026 09:27:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5uq7qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 09:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpY6/TiCpr7SCkU4bLZr/7AKZZs9lgN7O3wZHOkj3bWZuniGxzNbF4JhyUILHYQBH3DSCqpW+3kEF2SNsugrosO7XtWDe+cugX1Rhdr4fynbF0nStXS1iXELuKQ9a//BG+mzIUsO82pauUvThef+4dF9supVIxPf4qEegaeruS1vzOSJ31lp5PSsB+P7JTrJ9W35DIfPS2wnkRvJuFkNvyJuCP3iDr+8kHOde3z+bGLwb2CTm2QNaIponn48ySm6lKSM5YcQK6v/mx/WJ13g7byEQPNSxarma7qlEWfNZGmg5J+Riij8QiWUsMeeGZeBkgr8sX5V2tMQkyUILw/zCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Se/9iM15FxD9P+Ptgb/4maqmPqKkCJJTdUFu9UMEMA=;
 b=FDNWifW0UoDxnhsBj/h4StvOsfD4Ca8SQ83PwMA8j3AY6coE8FhNAw+kGn6PnUtXrDT8QrN6Qb5p6mE4mIF7cTnMLNz6X8hGRUH+FNtELPBbbnXBmMNvRjcDay3nin+bbldWegVuQCvsLoo5rfsT7G+K10WXetZDLOo1Oo3Nv2olUxHKu3gOkYbwTzEX5+gZSXJL1DqpZmP4q+uDvMhpYuzzzZFWtu5vruiqcvoP2OnhHdJAtzNhmu/tbYw1zH7vT3aS/T0HS/g398yja5G7wy4qSrItgPmAz9X2nPJGRSFux6fl3PV6gzuPk8Uq20viL8/DK7bitdXI8wd7+gFqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Se/9iM15FxD9P+Ptgb/4maqmPqKkCJJTdUFu9UMEMA=;
 b=csudPi2fzIpzLpiYexQXs9Po06Wi4rSSLxA2hKKX1mQf6QwL8qDTxvEp/XaAugdkWIejogE97oMIJ7z12oKFiCvUC48Z+hWa1Jo6sCRYVtmanApe/m8gLVjiRveaExS4YrjfmZS5bVVckB9y3WV6CQ6HaJSpOlV5dMAEW2sDVeM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS3PR10MB997726.namprd10.prod.outlook.com (2603:10b6:8:345::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Fri, 13 Mar
 2026 09:27:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.017; Fri, 13 Mar 2026
 09:27:14 +0000
Date: Fri, 13 Mar 2026 18:27:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
Message-ID: <abPYaocgFylosUCf@hyeyoo>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
X-ClientProxiedBy: SEWP216CA0148.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS3PR10MB997726:EE_
X-MS-Office365-Filtering-Correlation-Id: 31089aa0-450d-4181-fa0e-08de80e2b660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l9s1fws9UhAHo6w7wTgCLdFY0K2PS/3PH7aQx3uu2R/0+wExKY1jnSxuNv5KLnmTlBqxFcdFanjEPpQQmSLgEfIbRvOrJ1wdIbM8cjWNjGgzeRvOE7ucnHDJeXkhEc1yDATnRDTVoohhi7kOwIyYy1zda+kGLl+nLT9NbTuPI5iR0ZEwsb9EPqmEeVZMJWHMVCAc812jszvAroOxJTQ03blh1VAVYg+1ZI5xJxWi4mVGTvn0OTsi3Qx64r+DoeB6bWyBv9wiFQc/Jg/kBSNYTAVtA54t9T7yopwUJWJ8Si8/zngJyTTsul2xOaGONhSmeS3X4B9nwr7IKt+S9wvVPvT4c45VjPudJwy+dS/w4u8S3MCfPfrTRV0uLnUnVArDqNoV0AcmO09TgXGaahJmkHNlsdOnq/kIOTmeEHfoZxvSJSFRnZwCQk4CNTNSycIgJc/YxwODeVC0zofYciFwaDlKMKvnOnMfx7WMRVjXNpImXU8KHmWq5XIRqFXWqV+OxHKOjASkaCy93gkIyimCCwRXfhUuE2/djiWLzKi9AgJNQSNfrk4ZOGXK67TIkkUBW7kNAcA9SJwIv6S4oOvZN8K23eU/MeLmvyvLqaVuFKFLvDstV1imAT95gWjQndlwUDVcSMm99TWSRR4NLsgw2gacIUyItpjflUEIHSPp6c0umGx8KV1igcvAxE7LJQb7MJ6aTr5FCE9MsfBw6ZILkCLUGVRvmqlMrOWVGQLQ73M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UQttDBJFFM58SMXOqHsySx49SyzxALqORWMA1YJbzHb36NCOmAs9A3nqOxj3?=
 =?us-ascii?Q?a7j2jznes+4+n2drXVC1qi1fJFRxCUBvmbqUB5aJeqCeU7BfLD5Mbq7v8TKh?=
 =?us-ascii?Q?qUKkFEKtyCcCcrNd9M9eWLudx/26h2sEHc5II0FRoc8SONOAdt9rsGPsu5kB?=
 =?us-ascii?Q?etXff4HZ7qKZ2GNy+Oy6i5Ss929VUzh3wtcC9ZtV2ZjJUK3wnbvojZIaMHpz?=
 =?us-ascii?Q?PKP+f/p0BVbmoySC3VK396uKDWyjn4c07egDDbtJ6ae3bi87o0qmInwTXn3c?=
 =?us-ascii?Q?VafpHIarWiC70JOBxTk1Luk815zBR1fv3b1rDO91cZ607BvKQyISYZ7CfqOG?=
 =?us-ascii?Q?YbShIrGF4XVLN92afV6zkLDihZxs/WlMnHWRd1rC2VejR6neOjWRGtxVCKPt?=
 =?us-ascii?Q?NRRVzjEMeN3MCfe7Al1gc6jWvvL09F+g14cR+JFKy1gP9OG7nWlPehyb6gx3?=
 =?us-ascii?Q?xc0AlIFfbn+m6CjcjF5eD2Inf8450f8zPkYlVarFJqm0tVNuHZFC7obH+XGs?=
 =?us-ascii?Q?TUNdYANaGmLoj/NrgN22n4yoxxDYqDfQoYD2odUoA5yZQhrFzJ335oS5bqrd?=
 =?us-ascii?Q?TTpOSZmx9k5Z3ShGXshbT6tRZDf6UjtL9JTqR3cei6+dxdxLj4UnjB09WK+I?=
 =?us-ascii?Q?m2jqaNUqM3EAd5KvGUV1FwqXSeFEAkcxMlJFnHbgL9Wp7wU9Aw0EFQOn9UJy?=
 =?us-ascii?Q?2WjiwPr0VmH1mJCwi/12kAofFFei+BM3NSynTHdFXTWtdiQBwwy0zanXRpKe?=
 =?us-ascii?Q?w4WeQyEMBQUdBt6qqraE3j9i9V6hUKuLVe0KZ7TRPZUYT5PS9A0WAsuGBOQk?=
 =?us-ascii?Q?Vd7tT0Cn81Qkmk3PvhWSODxkK75RcpNMksNRsijlJSnCDfavJdAHmBWoKo0M?=
 =?us-ascii?Q?d6xgBaqacsIFbdj5ZUZexSmZe0sH0YKHqRjXBJHHjKraziiP6zGobzcMZ314?=
 =?us-ascii?Q?szY8UbmOk2VnlCLBOlp5/JBdIXtFx+EJZX4zl50k7sJs+nClLGFWPXNoKJKf?=
 =?us-ascii?Q?BaUWOgSTNS7BG7r9xIFMNG80fjwHXoRq2InTwS3tKed5Kapll3AHK6NG5qDn?=
 =?us-ascii?Q?OcEUPcZ/FMr3hRhr3xAubp/e2481W5yKt2SeFl+DBgWZaE0ia6WzVhGIDm4S?=
 =?us-ascii?Q?L8e1xD2R9UKmeRXxoj/chO8G8mHNnnWTxbx2hFoDSebVBDv4PznX0Gk6t4Vx?=
 =?us-ascii?Q?7J26r7yGkZuHmJxTaoWG237lF+P7Rouq56ak36HHO2+i8Cpar1ZK4H9t9goe?=
 =?us-ascii?Q?5PWEBThZLbDqX7V8i8lvM6K3JLrm96gWaZBrlCrIVt8RtatYeP1mlxPVaOL0?=
 =?us-ascii?Q?zed3yyFjFBJcIm23FAUd4cJ38/Uv1FnJUXA6jIJi+EYpwpn62y2Y/zvSwlcX?=
 =?us-ascii?Q?2OhlNUzT/1qRjqGkNMeIIFnCc5wSb2Q/aZTH9TTBLS4I91YO45WMbUCA442B?=
 =?us-ascii?Q?0oLDas+4C840NoMuPhmEj2YW7YxAkX63Q5I9jE3Q3ArWflh+UszT1Dso+sPY?=
 =?us-ascii?Q?Rud0sxwLJ+K3nVwzh+TPZHteo6ah+2QfHAdyPwi6qHLfJxwSQJih/mQEI2+n?=
 =?us-ascii?Q?v77/7RH0b2OEDWH9LQQjoxp1RTiab5G8dZ6I2lpfJcT72Me06+45QLdENk0r?=
 =?us-ascii?Q?qUZovztExBgDsrPi7dWvt2SFp1JAownvllxji0cs+PPiYgjSXKVHHbLnAEqG?=
 =?us-ascii?Q?W44LWqSplXzHL/mLtQrAN6pk3ggHw+o+rG0iEq/oM5TK4e0m62PuQXTeG3O9?=
 =?us-ascii?Q?fU0LQ37iTg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	aEWro7gexEqL3cVPWR44vRDwf7gyAn6/6xUzyiRJDwaJDYjaqmsk2BRMfLPLzI6iLkdeIw9pPlb2lNhEGtudmjQf2tm0xtid9+RAbQ4Wtrpo+pi4Z51WlDBynCzH40l6XrwDU/nQd6Ej9Yr9zjHTLIHuEtE4E7/oGuZEZ6hOlF2a9kMTc1bpAgE5E7l3nW6CL4rcmZG2TyECJHOmHqCbavdADs5B9Yej45TefOCNtP6pGSMQ162uLch8UIGGQJpeZSmWS7+feooMRfaLobmpF4fVJnsHBVdTQr/CL8rUicU/nYksW1cgnsc9/qQCROT1UwNahqShF1OOo3DBYkD6DA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lp39MnajU4/5ymFKULGSP+U21KiZiH7nMdWCkQFrtKXcjdXkpKGnDWegwExnvNswNixz1ytZe3tfn2Hg3HSYVJD5Di30ADfTN6hdpL+m4MwNL6hNNnvjpveBbyXzQ0C8kE3MNu6whDmFXDC1JPkA6RbhAvtHt/pjhwnyrb6paD7htZmpn/REx2KJ6cePXKW8FXvILQr0DeJ7H2GJByPOLdbhtfenWrPpehU0FP37AZmrfKL9xY8517poGVd8ToimxL9QbvfhXJ3BulCgj9oGAISXuYuuj+avF8kfFoN03d3JFkEHWA7fp2G96fmD5r/OUCy8n+uCfHYHym/DS+oiVi9fc9cualKXlmiCHY/T5LDVVXDjWumYcSpwyX00num4WCGkLOMcfCv9Y6e8X4z583sVRbiIgIofCmOt8VX+NQFSTWNjXi5nYAsmtqI5t2vRHCfzyn4xvrLSmnsa2CSpfJ3kcZ+22nFktFpuY9MP9j6u2l2KjJX2UBwidzZP/nL8JrOzHD5tNRLbmdNd0SG/rQPO6qGliwE7SVjW+4pjvJoTRkRJonUnvSHZVKl5T8TE4UyINo/XNlPN1tAqDPontUpuPAhtVSdp/2igAI0UcsY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31089aa0-450d-4181-fa0e-08de80e2b660
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 09:27:14.5540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6pxezOvBcTqTPaFQaWOUi7zOyJ/B/kUIqAxFxDx5rAYwabSV7wJVw9atJSNYB2l+jNNO2ci9gUX7LuLsetqLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_01,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603130072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA3MyBTYWx0ZWRfX0BR0cYgiAYL9
 PIjVriEplH3YbLhznYh8JVHj4tYL6d06EVaJBpiYg02muyUmI+NDhBG8mWE2t1THNXHBAF2sNbK
 096cEEFSdpLUjjovF9dAlobbCvwk6ScZERm9pMrOj5ka5zaFmBlxlm4zPz8Sh3HhMsb9hkxtiRD
 Vd0odeEE/kjlKIdqSGLK15CDVN9mCANGAkgJaohqIYputJdchaneul6aMtVZn0VgOMmkdH7n74T
 8RSXH3BMkO7pS2iCvQedG+djuTeRLAZMUDnbGAm3EZvyF4wcERCNH0Knr7Dv+t2TsXIZ6reEr8D
 ucccVXMCiBcCUa6fOw+YGqtt+2SGdoXekXAIs6m0z6zyB+0TO31C6JPnc1HkyzvlzBpd2Y4BTuM
 jZdSoltZqQSd4gz8zb+FKryrw1f6ASduqZORD2D5qdN3tfJDelPrN/YByGFZv/xr0NbtaWGFWHg
 RVRjZkVLrf8PfpahKP90vuu6IJnZhiCGFHINgufI=
X-Authority-Analysis: v=2.4 cv=FL0WBuos c=1 sm=1 tr=0 ts=69b3d876 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=MP4kGYUGz2_B068sqIMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12271
X-Proofpoint-ORIG-GUID: -wpp7xYTpcfiEpHEz7-oSoVZzRZk22o6
X-Proofpoint-GUID: -wpp7xYTpcfiEpHEz7-oSoVZzRZk22o6
X-Rspam-User: 
X-Stat-Signature: f8o6adbkk3q97jpku7z4noxrmkjihrup
X-Rspamd-Queue-Id: A754520011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773394042-676442
X-HE-Meta: U2FsdGVkX18TEO5bExVpB2jvxMI9uu/CUYBftmgL0MutXDpj9KTlk6KrHc2GwJGMEnBgDxjELUzZ1S3vsHQ3vb2hTUQZHfbwwsM7eGlzoI+w6A77GiGMgeqT7wApkv3b3P6hyTCGLtijfFAHmboU1cB/MgTfLZjJZQW+IBQot88M65vShcqVS/V+HF5HkR0Fzz41DqT5l6fdwV2n1xTZJ09+gkGChPde6sfLt+VK308aWbI3DMEr0gDKA27xLexCWCPorfXivo80WiTWjJVtYIs+ebfrdbiTIlJT8b+8aODMY36AXvUZKMXsjBnBez44MpTyV+95TxwNSBKUFlszZhJOSl9SY5Yucc43UiFVv4lRgqgTZC+VziiAIAU1LqnO0mYBscFf1VIJNHn1qIuL1WhNfjZUmkmvrcK50GeGi2ALLFUXf4Yfjy2+OJEj+JCrF9l/mUjNMZCTQB25fQsTuJ4lIB9Fc17UtOfdLYPCeJm9xq8CITwvxSYu33t0F3U3Q7HpId2FE9jtxT7Zxg8QxN8sDqqp28FkTXJHOjh6pkp4hVUsEHf11UmntD0VXg9Nra/hUZm+07t4r1IE420ZHjbBzh7Y5URCfqW/SByUJZZ2RuRcxgviUJUkqjNLit88iCiiZybPP1DoqEaJz3oivPV/1JTlEE5OE5zChXHLatZ4nT0Lb4Wg9EEzvjM3s+9eowFSLZj9RpOKwMop+u2aE/7WbdWxx4jT5KiWHWsz3dKxX8RdPiN8WcxuWnlFJJiHQb+ElJkO+VFrMVdhbiPbOwyTvBGWkGOQM9oCvI/OS+XHMYeNRQNs+9nIQLP385mAZrLNgJPgz2KGrQ9KvSG6dzhTleF3U02Jqx5YOd18khLNcaW8qIRl5iv1veyDBs2xbCvIbRfP3MYS5ew3GGDzpfDVyMQkBW73AA/hMcImNYvdfstUCpQ0QTIDzTZZq9qszvaehokXwGMeRgc4k+s
 1Gx0AYxn
 SpsuKk+aQQUExqqN8xRhaXEFqS7dD3VVlRqn8VNn28QCeKQPGsrlNvkIM25T+y+lpLoWTJmYq9GyOs0ZIwh/o0nFrGDcucW0u+winVEEYMfDG6nZeA2d+rpQ5zwgJrdPcFvIl5qPBRPJx3fo+n5ms1CynKgq/UlimE+3mHyq/7QsUvXk6+hcvK27Clr16msVvoBj6IxQ6ZFrMXQvDZxQ1kzpVEiKYCxjAKVUEbnzEN4xZAPSx4+CtBy9Ops/y83O+crW/Rd7s/V47ZIItpCo7F4pYOTdHAa/+l4yZ3SNemuMcGMqnKO/CVghubWszhQr+ZrueJsIUc8RgUkKJM/vFSjmy1E2yNjB92tRtT6BxKjqY6/GwS3LnBCJFiHOV5iujJWsvkwixMvaFrW0+eJmsl6fPiIxtpn+4dm6KIKCi0l/sXa/+GKepZAwZqn4E04dVEW+nzxpDlIcHydUSDoDvy+OoOn7l7FLBiJwVeAJ3+pjtr6u0/p/5jeS1y5kzuKOm4TZzKE1TQ21yuO6pzK9sfhTc/x01ridEMq/YyKG7CwON/f/EkBHS9PnjF3RNjkat89shwP0VKX/nkY01MN3HUpRWvEEa58ZTB6hpUcPevtL96cgcxwLOC3Xm4fDJfiXQRYbBF4xCtjDCtQhQ6vzwtWFipD6T3fqcrjV0HRs4o2ODD1n8F/kQaBtjt1q8uP/lJFU4+imQdx1WpPbOf3RBvpnDFsqSMKaskggV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:25:55AM +0100, Vlastimil Babka (SUSE) wrote:
> The pointer to barn currently exists in struct kmem_cache_node. That
> struct is instantiated for every NUMA node with memory, but we want to
> have a barn for every online node (including memoryless).
> 
> Thus decouple the two structures. In struct kmem_cache we have an array
> for kmem_cache_node pointers that appears to be sized MAX_NUMNODES but
> the actual size calculation in kmem_cache_init() uses nr_node_ids.
> Therefore we can't just add another array of barn pointers. Instead
> change the array to newly introduced struct kmem_cache_per_node_ptrs
> holding both kmem_cache_node and barn pointer.
> 
> Adjust barn accessor and allocation/initialization code accordingly. For
> now no functional change intended, barns are created 1:1 together with
> kmem_cache_nodes.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slab.h |   7 +++-
>  mm/slub.c | 128 +++++++++++++++++++++++++++++++++++---------------------------
>  2 files changed, 78 insertions(+), 57 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index e9ab292acd22..c735e6b4dddb 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -247,7 +252,7 @@ struct kmem_cache {
>  	struct kmem_cache_stats __percpu *cpu_stats;
>  #endif
>  
> -	struct kmem_cache_node *node[MAX_NUMNODES];
> +	struct kmem_cache_per_node_ptrs per_node[MAX_NUMNODES];
>  };

We should probably turn this into a true flexible array at some point,
but that's out of scope for this patchset.

> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..609a183f8533 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -436,26 +436,24 @@ struct kmem_cache_node {
>  /*
> - * Get the barn of the current cpu's closest memory node. It may not exist on
> - * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
> + * Get the barn of the current cpu's memory node. It may be a memoryless node.
>   */
>  static inline struct node_barn *get_barn(struct kmem_cache *s)
>  {
> -	struct kmem_cache_node *n = get_node(s, numa_mem_id());
> -
> -	if (!n)
> -		return NULL;
> -
> -	return n->barn;
> +	return get_barn_node(s, numa_node_id());
>  }

Previously, memoryless nodes on architectures w/ CONFIG_HAVE_MEMORYLESS_NODES
shared the barn of the nearest NUMA node with memory.

But now memoryless nodes will have their own barns (after patch 2)
regardless of CONFIG_HAVE_MEMORYLESS_NODES, and that's intentional, right?

Otherwise LGTM!

-- 
Cheers,
Harry / Hyeonggon

