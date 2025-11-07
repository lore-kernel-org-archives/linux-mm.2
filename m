Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC95CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B56C8E000A; Thu,  6 Nov 2025 21:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965538E0002; Thu,  6 Nov 2025 21:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805738E000A; Thu,  6 Nov 2025 21:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 684558E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:04:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1771E1402F4
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:04:43 +0000 (UTC)
X-FDA: 84082167246.06.40C8497
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id A47C84000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:04:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ItF3qdkz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XRlrIisw;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762481079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBNCYgGQAr40hS1/fFf7Oy2DNO9KQrXENCtKPSlGdHs=;
	b=Fc8zHrCJlaLwcmKD333XyvDp00mymIvlePQvXJ7WxdlbpUI5cYA0Wciu3UMp0rGyruec7x
	O6JbCDc9SU+U6yLaPcOwZDs7Oc6cY/jliYSbYQUAbtKCCT5OvRctPDiGnX+cB/MiUxQAS2
	cwAYlZgIP+Q76WJZMBW1F6uG75t7UxE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ItF3qdkz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XRlrIisw;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762481079; a=rsa-sha256;
	cv=pass;
	b=JtJjvw522YXLdPvkyzGM9k7FB4cT3bJtvmnPggWbqS75ZKGHVexpN4rctjZAP9/6r4A0vY
	PX5wbUiJ8v1DzB7rn9vIRvgJvbbatQ/5QE4tgoh10Ve7+oOVO0bBnkcXk3bxGq8/7OTPGS
	pSi+e+MdVYmxV+duIwMXrNSraM4Puio=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6LNOZZ023378;
	Fri, 7 Nov 2025 02:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bBNCYgGQAr40hS1/fF
	f7Oy2DNO9KQrXENCtKPSlGdHs=; b=ItF3qdkz2lJihF6FZq7vPTiYoZaxBwbB1h
	V1ARDr0PuIFT5BWnX+ID6nAAOY1UWMXD0e20AYj/5H/zrmy9W5bdjK7+bPOhL9K7
	pd4YQw0zBuPTbPPx2Se4RTeDBVx5CJMVcDHMC8Y4yuJPEIabbGMi1U0p4EXlxKqv
	IlutkvNJZWgSXUz/zBb7rQSdwBwY8C8NlyPJ2n0q+C0Lbiz1ykNoA8TrXsv8w0s2
	gr2xtp82wH7FXVATOGpr0cwm39+sAvCPHOVoIAIgvKEeTJGO/ALKTzzNSIDs4gxh
	DLO4EYPu9/Qc8hdfhnHIo4S3EDjijDXIgBBylpnmkbNCM8j+t4lQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yw9rv25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 02:04:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6NbDex023206;
	Fri, 7 Nov 2025 02:04:09 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ngr07n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 02:04:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsgkx9xnfWrTbCVbol4Xg3UtoE9SXUKzfyaRADH+lLbHV7yLU9CG2WQVjGEnly/3RAlR+Pcjqo4owPj4v8uGBcvwq0okPVfXMqB3IIEMMhm7NXeC9B0rlmH2i2vskTbF2i3UoJvxkLHwo2eI/A4tTrL6elpD6YscfyHhXtVFdYkBUkk7aWDoWThu5wORO1H1W6prSHTFscKh6Nl69auFhy3cDoGqMno4RLYOug9nMyYz99Ze7XDtQFBVnX4QF3ie8pjCPj53B5JC9RQggQV/6/txu94L0JGEtLLb+oQmK0akE7PPm7HgUEz3kG9anLvtqbO4l4SJNm+2D4rMOcQoYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBNCYgGQAr40hS1/fFf7Oy2DNO9KQrXENCtKPSlGdHs=;
 b=SXhewUpvG7tCvczB4a/0VCusCRhj8PgXlfW5hn1eFSfj4souqGL5BxZqx3T7mkS9QCY77aemuOoGK7b2f0s7Vcx7oZc2/ZChFa6lm7eKEtiiK6ep2IlwaVt/FP4qLwQ0+a/GRncmytJ+T36dw/Wmofra2/NvzGB90hmIyBGtHLKAr6i+K9eTtLj3JJZssHvYg4Kx8q7dpaif2XXaHQTNPskaYvEsmguXTyWK16M5bZPL1tFKDCflB+BouuMoOrSfh0dK3YqVBVzs/gCnh3LqwYO+ddFkLi9w93FiuwDSR9Q38Zm3LmwWYZmpEwxiCyn3dMwP2DXqSMuXMc/Q9w0o+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBNCYgGQAr40hS1/fFf7Oy2DNO9KQrXENCtKPSlGdHs=;
 b=XRlrIiswony0OmofLhkD7vozIOHEC96V7twP6VF0AFZ1mfnDZsHyUkCLcMjdnmUHhYGrwQq4Fopz9fZjUBFpJhrtmh2jIsJ0d/0JcreVAxAbdhhKNgJd252W2IOeJvf2NEUWDkp1g6SKXKslQHxB3sBm7Qwn6j60RPgLEMLGrds=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8352.namprd10.prod.outlook.com (2603:10b6:208:568::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 02:04:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.007; Fri, 7 Nov 2025
 02:04:06 +0000
Date: Fri, 7 Nov 2025 11:03:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its
 variants
Message-ID: <aQ1TiuTL5ZQ_4JIX@harry>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <f68f1ae435edbbc6cfe15448c2df5c4112a4a61c.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68f1ae435edbbc6cfe15448c2df5c4112a4a61c.1761658310.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0013.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: da9902e1-020d-4809-832b-08de1da1ee84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C1RDoS1HvSW7R3zrt8IOw0mtlt1g1TWCazB2EuM/be9/PzNioO0qpgW/tHUP?=
 =?us-ascii?Q?Iv5TcLLuzchVMXfLnlGwBFUa4zBS1zUEoIaMzxAx23DrNRuLx5Kzu2nOBV0c?=
 =?us-ascii?Q?D8afLh/EW3V2KBZGBdbxusOZtvMggjTjm9wycatNO6uihnbhRUulmZfGOCOF?=
 =?us-ascii?Q?Z5Vgkg8Dacw2DGyfpgZlZb3nkWdqm8y2DNofSBijPRk4XJZUtfOK0qaVGQ6X?=
 =?us-ascii?Q?FUvnIHSiPwuk9SWtrWnW1t2pH2mym5DBR5ilS5A42oUHWvRxCBH4XefCe61g?=
 =?us-ascii?Q?uYuqQey4NXxDAjwPhMa6WhHgBWQP+xdOu1ev6CGIUaSjbobLcmBZvpoA1qAz?=
 =?us-ascii?Q?F/0Qu56wWrKkp9SV+3wT15usYEPkR+s0tpK3NUqhRxIY8OENs78bKk4KFGEE?=
 =?us-ascii?Q?TAS1MKahcclByxKp0Q0Jfna+MWf4rRQpiuMR3+mXQPB07wuMFuJY3XlGE+PI?=
 =?us-ascii?Q?5obxDgv/YlSSKboxBCn+00eK1InXYdnpx4UxjhktS4cFEwLqIoxITz42Bc4l?=
 =?us-ascii?Q?vEETXDNT/Bivs1x9a34nFuHLQJfedKhayi6riCfles7Qg3W7mzzk2Z0NNsOD?=
 =?us-ascii?Q?gYIWHRIMqq/wCx9/jZ0fx/zmwyXGcguhYCSLOwgr035vVv9EAF8fL9KgqiEy?=
 =?us-ascii?Q?aeioKpOQHFrBtqPWTqXRBEmJi8HHnQLgY46wCWln3URgY4pm8SPkhSv2j64o?=
 =?us-ascii?Q?2vKiqcJEHHmVhQKsqURrGC4CaPzefo5NPuPMRrxyRtNHQLwgCrnKK5OCz76r?=
 =?us-ascii?Q?roB8ns3JgRmU6Q8ZbEFVla7UFPAnYvkBxxxHCxyzdb73jbB92JGTQ8l+v54l?=
 =?us-ascii?Q?J/PVhEHModKUxJ2rULtV4XsIa+4UKBSGTYNjEcbroxzVl4Zv4MI/6tvbXM06?=
 =?us-ascii?Q?VZdakT+61W2yJYnec44KL8uXvY5su2LEoOMhjUs9UTrbB5r4Wn7vfkn+Gk0p?=
 =?us-ascii?Q?G3Fbbd7kWAj8U/DEo50mJ7vLLsN8b5mAeIRxU9i4frT0jgvB8p5wR3MeONza?=
 =?us-ascii?Q?I3b+Wm77Biyb0MeptGdC/0spAmvY2qk1FDi57uawlxx1Tz01H06VCPv/t2Jf?=
 =?us-ascii?Q?G+STU8FByHiaj2KZjtDUeTF3gztKQgfaFYm90Hxkzq2kTwvS0YwFlQLC7WFt?=
 =?us-ascii?Q?mRZREVgL7AsXzQq7eY6mDbz0Y0nmO8BnwYbIVtwsaVn425TtLO5Kb9y1m3Ru?=
 =?us-ascii?Q?z2O3NHXTFquI+pPf3KFq8fC9KkMPAYuk34kHm00AK91khhgQf/DjxExy6YjT?=
 =?us-ascii?Q?82v4//s8LtuwDO6xSSIQqhysp3LcjgL1nFR3wnbcx8YuUk5Ov1GYEIQn6d6K?=
 =?us-ascii?Q?dWZexao271EaOlM6gHCPR4jxi2ItzTuqaq1z0s5+EFSIfMRUAvBkicEMvWQb?=
 =?us-ascii?Q?9c9gclOrna+T+0oA7f/pre+APkCNEvKnt65q3YlFq7B/NSE+PDM71nmUPBDE?=
 =?us-ascii?Q?R3DN8gsO8fvl1b/6qjFPLHsI9wVS6/oq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Ssp1aJzIoxLMVDa823ME3ZR5NIqXL69E/uv7hksMTnDjN3j0ScsEn7+lixj?=
 =?us-ascii?Q?j2rjCAHKmcpnFvjJeh6ZI67S/SD3lZzZxUlyvzfqHksp3h7o1rq8rV8qx6uK?=
 =?us-ascii?Q?m0KEQkUJdd2ELmXhKlbpaBMVEnWYg4XZhs/qXR2T4q1+9lAy8earPPQ58HD4?=
 =?us-ascii?Q?QGD/mjpnapAaFayuAvhUc2L5WhTU27buN2CR9N/s8M90rPvpkpcMh8OMS8vN?=
 =?us-ascii?Q?0Xd2tdk6cZ9wso9+Ya2t0seSncrhrMKkfFHglQApnXXcSJ98prgdujFyPrHg?=
 =?us-ascii?Q?r9hufDgn6QjMMXD+sjjLH8oA7I5naprn/yUZWRClNWUFZqjNxXObQ0lGx2OG?=
 =?us-ascii?Q?GbfLKZobkY91V9sgByqK4V4voA9npAg0MWKFJuz01UE2QEAsV2fSkIi0Iqbc?=
 =?us-ascii?Q?nMVdL+TU0K3Li5dIZZG/DNoJRIkqvmoKuylqw2YCW1ABJPFzqexiiSaViIOr?=
 =?us-ascii?Q?ATXveNxMQyPqJmvuOT8JGk81PKRogLWkVPRJDqbWV3G0MEEQB4ohJbrh9sE1?=
 =?us-ascii?Q?nZU5HEMlHfGk7kkYPXkg2+1p+NZeH882n/3liq7ZDpuwiz8WNZbjeX/R/FJ5?=
 =?us-ascii?Q?1xF7H3dLhzA1WSmbsREH/oZh1QJsDJ0EoXBo8BgGEzRUoxGxY8gv/3xb3d/S?=
 =?us-ascii?Q?M8R69OjsrYcWY5jLMtNbb/A6W15VGbXFje4lTV0uy2aSl646DUmzofwQwE4o?=
 =?us-ascii?Q?Sl0edsdXmf/VU4mtldKwkn7fWzELU8wJx39/Thc+lZhtik1jOSaLE238AEmq?=
 =?us-ascii?Q?U0Zqrv28Vwye72/DyakMCLVfWK67y/q+5cE7cgaVMSrpuwYfUD3zJ9qXx8Ba?=
 =?us-ascii?Q?JpQT5ZuATGTeOf5fMktbiRWR1fthqhP05Rcodo8W0AiyMhXm/H9hF0mnLu/N?=
 =?us-ascii?Q?ZnJiFG2cHhPaMVcGLVoEOWjagSmtYnsCR/7jBGxGMM4a6t2oMqQghZFSweEI?=
 =?us-ascii?Q?ISHU7w1sGxsxbeIXZJ0wIsvvHhkz3hP7C7N2XZg80QT9XOQreIvMoz92/Yfv?=
 =?us-ascii?Q?Q2Qir0tiMwSqM+nQfSs2GQysVfymyabbHmnhUIkEE9fSPA/ZTUCNUxrMajXW?=
 =?us-ascii?Q?syYOCyKHjiFkmQjpnbUvaUMPeFHuCdONNfmBLsSQXjnHIAsgHKMynx6voFM9?=
 =?us-ascii?Q?CN9KPhZnypMJZpBTN4O2VpAoSjdzcfRmB+zSUktemE29gs+MygnGSjp27pum?=
 =?us-ascii?Q?ayzQHnMiQH/V98oEP6prwDuklL43iYwrfBp2NlV5JqAIwkjKsc37crAKH2a3?=
 =?us-ascii?Q?iy+IHrCN0vayWHfXwq4lW+TJCiajJI4sJUHhZQKe4qah/PYUcASpIBrFqkOl?=
 =?us-ascii?Q?QonkdcRZit28SXrGkFus81B/9HpxsJQFEJWi0+ZzaRTNCr808M6VHhJehXpk?=
 =?us-ascii?Q?MOdVqgzqvIdiw1FCbKNV36EG72VOvH4GqHj1QLizCEE4+IOtiq+aSKHbwXFU?=
 =?us-ascii?Q?nbGY+yx/A5UJT3NyLL7qqP34V41/Lu5iYKwHRURk2yLcuwJwYoDS4RFz4cnD?=
 =?us-ascii?Q?Scn3BseNN4LVUzQiDcJmleM4zIj5XkHXNGia/WBsEjKE0XREiTAzMfp4pjBC?=
 =?us-ascii?Q?I5WhmwwxHKdnfzbylei52r7NtW3O8b9aUyXXILFJzNJXMoHfKLeEhXk/2P15?=
 =?us-ascii?Q?PAvubCWuOSqGtDOlxdqw/wvb1i7kSuyq/GQFN8LcJkot?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aLJec0kmxDKyWBczBuMHZlkDbcRZAuhwYz+5qWF9WRlqU9PgBQjHfrLcDnbmr8FEpGcZq9+XhGrWJf2V3CoAwMauOr+cYYHIpJThHe3/XpAN2ziGEx0msTr/LCZcQqOcUSCYvyi7hdDbWu1c11IaiRZSyI5NisemTnrfZBoIxYRCz0O49qR2Gl8SDsjyG04TlczCoAN6kySRafrFPhuHCav8Htyu0u4A1nNvNl+8giaAT+N8RfVHI7/bcac595x7pFD/3HXjPsb7ABcKvaJz5a71BNxSZDT+Oa9ZIUlbtYa+k7LlcRyrJKm2eVDwets2LT3W7OKX7VOw+HlR1cbt5udD2t3mCJZt52h3Ss8YHn63MS1z9ryx7LF4LglmRXDQCGb1F6fthJvkqLFDGW64mIE+2vw5gZ2tSjY4HPbuNt5NCAfMwjiLavQxJas2ZRUanhaC/qVRQnyOp2kqgzfDU+nOW/Z615iq6Pbb5J+fOneitjrrKCGOM1AJ2jKHKcFdzRziog2P8X8VFBlXG7uivNPN90G1L7YMOR3mHZsyT/GQDmRQc7DcMgIatpr72sXxUM6QQ08ND2dOgt+iwB+1+lel0REY/U1cO84h5Vo/iwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9902e1-020d-4809-832b-08de1da1ee84
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 02:04:06.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIM6pzdWM1zj8SqTn2JPeD9mzYvSGtRRJ0DThygLF06bkn12AI4IQ8kPqqO92UB9LYLxJmpddcvYaPwO1tv6Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=964 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511070014
X-Authority-Analysis: v=2.4 cv=GJ0F0+NK c=1 sm=1 tr=0 ts=690d539a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=ufHFDILaAAAA:8 a=yPCof4ZbAAAA:8 a=T_itOBEgcG11qK_9x1gA:9
 a=CjuIK1q_8ugA:10 a=ZmIg1sZ3JBWsdXgziEIF:22 cc=ntf awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzOCBTYWx0ZWRfX6GAj1duHDxRn
 88iZ9JgW2rDZcJEuVSunnzCYaTUFs4LPNXL76PgNsIahOvYq4CBihRl1QDLTHmNeLOFNoVftAGG
 KsmHjWdlklQfKicDzLtrr+1zo7Yr5veAbh0Is3LfGQQ/gXW2zl2snwcgTgYzvadXCY55LxguwzI
 IdONBLps0symwtbgh8mZiSeMpthAe1Kb8m9nQe0uxkaUfrpyTyEnu7uL1l0cHB8f4YABRg60JR5
 cyTYcrdSVOD7YV+Io+MtR1flz0+4ysQpwqxZiziBxg9bRgBLAJrmmz6W11xIsTTlv3GoCO00PI9
 V+4KUBYuFsRakr7gSOPJS6xYNXf0n3DXGV6Hvn0/Y4+TmpKch0+stkdBe613JTTqhZeX3YpYow9
 lTXPNGNZTmuFl9dDqM7IezYLaLAAohp8XsOUaRAF9SjxU1qnLb8=
X-Proofpoint-ORIG-GUID: ScWmDnMTWMHT61apM5ccHnihR3uonbbM
X-Proofpoint-GUID: ScWmDnMTWMHT61apM5ccHnihR3uonbbM
X-Rspamd-Queue-Id: A47C84000E
X-Stat-Signature: iwywng7ittx9aujn56fboepo6ekghfo1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762481079-303404
X-HE-Meta: U2FsdGVkX1+xrkZVpTY8hT8ODS/BV9vJPjgBKdiowFpcu3DfdxMbs5w6Mc0Gkcsjr4Uvanj+3DyihN2RyEVsMbOKd5w09tYvjQykph3C11bbDeKyWWgUsS5j76VkIRi9iWsNyyVgs8IRrIGJb9LIwvcIu7t+WWk2WALvUHy6cCBD/T3gpIBwH1LXxJEnyswY+gaYfxBDSQjoqjVjfVjYHwvm35APc3vRcueR+8rb0QSYmFoDaHK53WaGfwjtA10ogXO3jpTLuKh3nLL/UYoYMMbbc41eHNaQl+7xBx9tsYGSu0LKb35tpKhWn6eGbXWJIpLYbH6UwVJHhSd7lbRlWm1DTXVdVX0ddzHbZPO7ETurUJ6GI3Bja0rYMxoxPoZC+uaznaM+sbuBqghqkl0UyfrGoFC6PW4gn1ERgE9XUM6rv5teYd+SlTvuTDmTS+vzX9zYKW2DarmKKE/b8TnKJ1dzgr1JYxlOkqrfH9Ubnn9flUCdeVrNG2WGbiWcBMozrD9rhxmtaOlaPnhubIlAWuMh1hxgPGuuNMpycdT1tQfBtD8jdxGd6n092T7TMIU5QatPbdwr/aoNzI4OMJN/Ma+3y0TJ2BJFPQqqUazN59M5xPn30YQoQfFDKD5A1GiCqVdwjPo53NGTrTkv6bO3HRL0g0tcZrg8+dTkwR++WpdErPoCaYAjB3v6A9Qk+ba5I2+MfoXzgcm6oKcx0OBOzI2VJSNY8GEy9tKvunLwa8xSXkjns/16VoJEetdWuf1r0OIvVI6guG79X+h0dCyhHGVhvc+BxxpY/ANRDLNOZT+Eaqr7bzYYTuY7X5ZUbJE77RfEJF2ZjFin6Fzed8XapJxU3Ea4X/3RmEldN3ypRVNPwZ9nxqF98J5EW0FbKlINcXLePGw0PPuSqdVPJbaTFuU7LmzfswbCk+VjGVRuA6EOMsZQ+sJAVgIl4W6o3Kh3HroQTq0b7FlFcY+Mdw/
 Hf7DTLvs
 qBayKp8AOVlo5gcuAuf6127KKnuN9+DAeSDmusoW5wBo99syb6OJC14Dr7pxcCOOuvu/yQOyGwwM3KuRzwXqs6D7/q30YQVOdEeQeCPvoSFmbv4qeVN2lKsxzoy4GrEWu2EonGiEi2HCO0GtHe+5lvIyjD+PKeC9cxxipqxIosFYKoOgJPLwa2Y+wyuPlCsDwydjuueikbt7Kz9Xp4uxedWP7VpJLt4jnFj99t66Ji/ysM9cMhv9+q/Ux4HWkv1eWGq0eM+BJ5oTX5XPbDxvOuzxZAbjJDyp4+FbDAeqU91NQSiujwGI0/HB4ehEX9y4BPjcLJR5mS0oFKjxpkv4AG1v89WdxWSfZlpSFVRZmEB2LP7ruYhkuOYOX5dSlnTC0SsWguaPpXhiZAssBaRT6PcnN888TS20hzMPm78hosTknFCGqWozq9skoSedInDlUkuWpNtYEh90fZjtHl7U/wD9NCq2j/vsQEMUUKETw0gU0Cz3fMpDtkTw5NQ5KVpjgWT2xeR/FiLl1vPiQraAaFiVvoKb+0SuLwyBksXfxIw8HvA//VeGTwOElr+/LVUi8FqDTkWTbgFX9s9P2jp/CKiNkyIeb7yRaX6pGOJIV1KcODafiencFEKWgqt1tB++UDe1kk2J/qhCGHI7OcxLjCzkOlxjkrbyZBYejNyWR7px5w5X9si9qCh4nZhnyrcEtjQ2CgmM/Ulh8qQV8UmVDoYlK0xV05AYIsrDcbkS/ssj8uI4EfiWykgKyqPfq2lSMcaxn42NEsXEinPRWoqXrQ1kgPdmZZQZUPa0UJwx0sm3qSPgwYW0X4baoRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:16PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> It is inappropriate to use folio_lruvec_lock() variants in conjunction
> with unlock_page_lruvec() variants, as this involves the inconsistent
> operation of locking a folio while unlocking a page. To rectify this, the
> functions unlock_page_lruvec{_irq, _irqrestore} are renamed to
> lruvec_unlock{_irq,_irqrestore}.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

