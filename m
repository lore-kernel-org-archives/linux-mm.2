Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BCECF6C15
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5034A6B0005; Thu,  8 Jan 2026 05:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7696B0092; Thu,  8 Jan 2026 05:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B656B0093; Thu,  8 Jan 2026 05:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25C166B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:28:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4ABD1AB709
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:28:42 +0000 (UTC)
X-FDA: 84308422884.25.30D753E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8993140002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:28:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i+uHJNcO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SULDni5J;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767868119; a=rsa-sha256;
	cv=pass;
	b=l904/4sZ2o3bA2Zf0dp12WO9ozkWKcjbcDIDdqhUmBZYsDkc14zI/nLeysfRxXzXVi9Y0n
	9h84ZeRjSAHs7WILMoM1L7/h3XUzGrHle9wkoTxwBqYdbDKsFQrf0n8+p5c75UbmzR3BmD
	Z8jidFUo5N1HAd157upOrfGKL5zbMe4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i+uHJNcO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SULDni5J;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767868119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIGdu8V6eUJUaDb0jO82NBUdECnepRNKpyJFkqKLb4A=;
	b=xrVsV0tMHrzdAhDf1VPNvUWA7JbwEV0gDhx9qTgVdCHGDSXveadqHyo5kxajV4mIBkjdjq
	oa0upsbPwNW2vo7CkuCNco9o4ylfcN+XP9brsGdNi1QlCPEYkcV2j2VtP00GQeUvrspk5e
	4YfglorKnjIA/+I8RcVtpq+LNEuao2U=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6089t7Ni4062617;
	Thu, 8 Jan 2026 10:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NIGdu8V6eUJUaDb0jO
	82NBUdECnepRNKpyJFkqKLb4A=; b=i+uHJNcOeo2iAuXgZT8DxaJbczdXXHdrBf
	MlUcDKraZFOQA7qpOTtiE8m08usgAnFnl8l7OHZJgpyVmvTx6aIn/6iMRozNZq+f
	3LomjF33CSm7Gswo9qDpcJzusMBZS4jZvFC9Vi0KGFnVWk8MCGN/Y1MfbtAeQNTv
	2urjrjHSRxLHNH2Zu7Wfk4gL7iTWiPTuBuS97KZlgQ01v0ItUQbmdq5oD9iH/lFp
	AwBf00uSBkaRbVuMes76bVFubKmPv86H1wuJ1pMOiDy1vx1IC42OeRZ4TRoSvYrP
	7zndyoiCA/7RC+jYOOfngwD/Pklevw2KhwMQ+BT5j6QImVtKbZcA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjacb819g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 10:28:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6088unP3020476;
	Thu, 8 Jan 2026 10:28:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjmxu7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 10:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DyAhNDxIQpDlqmm2kR3zyrCF/l+oZbSWmWjFu4uOwCFtZ7PXxbJiCoFaq5rhzfbl4zbW+V/Q/ciudzccLDygMUpQk2jEDF7BYJJDi44nYicIRKqW8rtsvaXhTBfdxtbbXVB5ZwfE2FhRJXEK5zOKqoKH4btgyUYJOgTGB/rv6c80+CmfAu5hPz/e5eEU1Yx5f1hjl8UESbElNdOp+na1slM6MMzGH//jpEB73NrtJQZQ//EB6QStgOrf+GonvbGQCjOJKEc1bhbq1GV91D+qog7cKs34O8AeFBmqa4AK7gsdFvbsGI/hEvpkT6gcwOsA8U3f/mSYegL0iNjoem47JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIGdu8V6eUJUaDb0jO82NBUdECnepRNKpyJFkqKLb4A=;
 b=iVVRdgQj5TX+BVA3avHCjICZTHEupNBqMRkwnLwwzu7aN/SqFNmSCdtzCoErLqBKzpL3YwuifKTuuxavGb9OkXjr7n/LldlsjkOP8Epu8TN1MEsA7zdWv5javhzHR8Mph/hM8PSIjrbkeb50up6s3dxRRjk0uRaKL9hE5j0uZnHsE6mKa4MDrMs2qWaKc5W/0xQyIHwUNj3k3jM486GRqKkaGGIvEUOXHFoxdyunlls+SUiSI34FfKIhsV0xQkjMsodZR6ybOz7y36pPI83MFPIHDWu4jFZnPBxfhDVH0eCM+pK4XZbDZCQEVGAkP3sZIxEXEG94pXAs5hu0bn/JLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIGdu8V6eUJUaDb0jO82NBUdECnepRNKpyJFkqKLb4A=;
 b=SULDni5J7Tr6Dx0IEaikj8q6J9nrJTXTwpB/Q7Wa93KoEZ3AIdw9pEwMmfdC2IeHZFodhk4TrZu/s9s5hQmBGBInli6z5acPIsDmiQ8Zs0rCYsTtQVj5xVtKO2kaWLKSmOWT9tm6+OCnkaEehxLwGrzuAZRwopuoo39BxoP2hEc=
Received: from IA1PR10MB7333.namprd10.prod.outlook.com (2603:10b6:208:3fa::10)
 by CH3PR10MB6835.namprd10.prod.outlook.com (2603:10b6:610:152::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 10:28:24 +0000
Received: from IA1PR10MB7333.namprd10.prod.outlook.com
 ([fe80::e8e9:f35e:8361:ec06]) by IA1PR10MB7333.namprd10.prod.outlook.com
 ([fe80::e8e9:f35e:8361:ec06%7]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 10:28:24 +0000
Date: Thu, 8 Jan 2026 19:28:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <aV-GvYV0Zp6arOpL@hyeyoo>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
 <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
X-ClientProxiedBy: SL2P216CA0097.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::12) To IA1PR10MB7333.namprd10.prod.outlook.com
 (2603:10b6:208:3fa::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB7333:EE_|CH3PR10MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ce8b6c-3d3d-4928-8c09-08de4ea0a708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HyEkWx9FTPVkQm7X/qdQ7kVfhrNq5xhcRv7oooFOD0eCKciTWXOu6uYkLmpl?=
 =?us-ascii?Q?EHx4xPVYPm9qE1hxy0hAE7dTaEPqs0otYqrkf1Lq3Z7SyxUansWUDauC/OaA?=
 =?us-ascii?Q?VUqRAVdzvnTG3NrQ9Ar0QQpj4IhAqeS6DELV3zV0NlmeCr4uKlyOWcE8468D?=
 =?us-ascii?Q?sIvAUKvMVdT+En10BR0OYFdnQsDjBVKgvYM0yw9dkRiA28YAiyfERca/L400?=
 =?us-ascii?Q?DxHtFHQTBXEGGd4HqFctDDlvWTR7sDaVdvG+hmbSmedmEKTR8PK+XvpXYMhI?=
 =?us-ascii?Q?veGHvyvCwPW/B354oQlu7rf2QsNM5QuvPtW9JmGq6eSklXLqvfDni+wWtU8x?=
 =?us-ascii?Q?be+IBzIBH43xMoc+GWvQaYbNjQtWN7FoTxRADSoRb0rW1gHwPn4gywbMQL4t?=
 =?us-ascii?Q?LKtweGVdRVmTkjiGVaw/muwLUKnUo02635zJbrhFJaeWbMf30lfPWahv0zvJ?=
 =?us-ascii?Q?PPMdz7IJ92bL2wOKacvT39SLK9f4b3MaaR1JQBzu07VqSAK4qfYVgYTjCLpR?=
 =?us-ascii?Q?AyQruBb/BUsksYhy3yck1dCPNk6g2pR7/0bwSaEPq6PrKYNushUQMdDxf0Ye?=
 =?us-ascii?Q?Ej38/UlUQE2voXDKNvQXjsws3uvCSdJ4I0c/5ukuS1ZOG05sjY+QjP3g7qsh?=
 =?us-ascii?Q?eN5/ck4W+B7LIrneMui4LN9GukX/V1Cs3c+UUnXlZQ9VFtHDGmiAgZjJcgIZ?=
 =?us-ascii?Q?T1vyJyatprflXd3mRxBqJ3+rB0hc4GJCgkTlUXqGA+o18bLNUbZQv63Zi1Hu?=
 =?us-ascii?Q?dJGh28eKLJ/Ixtgf2NZYiKwmiaAzcq/cNQJpZc8t2LjVo/4VhMlL6DSqa1NO?=
 =?us-ascii?Q?5uTQIYTPKbr8yJzbBLp1nyUK/nlKiSLnJuAa5LGCFnmq0FtoTB6iD8pFPsQ6?=
 =?us-ascii?Q?/Oz9L7m8zXSnBNhXJYK3uxRTYdTrVv4RaS9BT5ZK28jGKAVuYimtYkiRFCTZ?=
 =?us-ascii?Q?9bYawnPu2tRA/t1KVt5zcdGqWBGcPLxUVSJPynlPs+khistvYFzYIcGROaNd?=
 =?us-ascii?Q?mSLnNRME6o3X25Uv69WRkys5+ULzRTY6dQ1CoW6iR5DFcoKw+wBqug9ct3dC?=
 =?us-ascii?Q?4NgpW9jeXAk3pBiGnP3i0mvH2r1iYjdZTIFh84aAVmFz1ZKGu7I+mzZu+Ma9?=
 =?us-ascii?Q?ZpCj/J5TyFSZ6OCewdl7uCW4F0xUEPDMhBW954SuNKbBmRbwyIELmI7yyYk9?=
 =?us-ascii?Q?gN9Frar3Cxs5YyeZXt+cfWDDYl7xL05s2kppfIzq69T2rnF6nZfyig6tWtgq?=
 =?us-ascii?Q?uZWcbNUG90SSm6xAjx/vkC97P7K9cnHAdi4C/0jAEswxOnl8mQGJO3/xWQj4?=
 =?us-ascii?Q?5d1znVEv46EcL3U5K3dc2SEAqI4WAXMoE7ZWySjQcUX2Op1kbDi7dKN8G5Aw?=
 =?us-ascii?Q?u1e6L6fouoWTgZFXdv02WyhS6T2yujx0CPPwwFmsVZgckSfUHu/KBS2sy5W2?=
 =?us-ascii?Q?8qZ7Mu2Aik8Pm3WqJ+KoMLg/8Qu96xbY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7333.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YPT29H4fXVypjwHAOETuSMaL4G9RD6p2WWHfC6mM7/X8HiO6u7riqfrnlsu5?=
 =?us-ascii?Q?lYjhk75v1gShzKDD3OfTLnDn+KZZteSTd8Jb9CsKd1H2Q3oPRXvOqJkdn7F7?=
 =?us-ascii?Q?NQGnFt+rYS7JOKN17m8zniiKVsO/jhBdLsF5b1LcuhjJSq96yPc1+RsGIN1g?=
 =?us-ascii?Q?MbL+vm7BWPt3ha/sRZJ0e3qdm99ertI3Spbzi6MdoEZglepYoN6jM89bJpHn?=
 =?us-ascii?Q?rkQsaO2sLZYXVyg/BNq8CDl7Nh3fQnp+Mm00mRO8RyclqCtURJ44i+4KUqpu?=
 =?us-ascii?Q?cxe97EZKt15wEF0EM8CEig47Mm44/AY6w9hyNQSZ1bRNPFDsFfDzqeJ4sTtS?=
 =?us-ascii?Q?C9F/PJqUFGRtz+92zOMpHiztO9sADQ8W/BCqpO19iddyXmHFn4i+OJl6MJnn?=
 =?us-ascii?Q?RADR5/8+/IzZ8MNILiMvsOTzSNxYRCPqyJdv7tZH0JU6L8vgSBmboRqiia7A?=
 =?us-ascii?Q?HWcMZoj6A8GH9SMAGwlD0PVsfMt25gOPtGHqJOD4+O4nFfK6RgUZmkXPhGb2?=
 =?us-ascii?Q?UIbMVwbn1OOcoQib+GkDqaa1bRERAknrD/rAGipjLg6vxKGAgG8KfevQ0t66?=
 =?us-ascii?Q?kl25XRTb3N3oyAEpql+uhOOhphpYJeBRdnyKLN4Mpqldgp5flRslBHejA1U8?=
 =?us-ascii?Q?vfhN8QimeWiG/a/Y/90Xmw6Ike0OMJi/dA1Tb4gTdMiSTzOCIsuYy0blSZK3?=
 =?us-ascii?Q?RRwYPh4Xy6YCjhbr44WLGPD7SbDk+0qTYPBRSZ6joLR3TMjKr4qQDqbqfIfM?=
 =?us-ascii?Q?j7yZwC7SbCTX+POAJw3F6vQDMHr5gwBd4fWjiG+976zHOQDo9llY1n1n8Kj0?=
 =?us-ascii?Q?5XrOq3S5jEIw2F22u3peuylfw2HUtiZtmkBSjwt743ZJGz6/mjAirmNxDKqt?=
 =?us-ascii?Q?qXmqT1ZHCH3tIKkZPNcMPRWlZoQ5uhrwA1aj2WKXwfoL3zgMtf9mgkegSUps?=
 =?us-ascii?Q?VLaCYvGaEDbnl5k6MoclRXhiLDKUWXR9SWecRRG8V4GdwQqLiAAp4etCjAZu?=
 =?us-ascii?Q?EeUvtiom7OAsU3ntQ/X+GVYubDmv4aaRtztUT1j/tt2yI0nJb8zohgwV2FeQ?=
 =?us-ascii?Q?MV9+hGe5/3pWEMQd1xuNrteRpFrypHMBp1Tccz6Zu5QCS7Ynpa1FVBV2IPqV?=
 =?us-ascii?Q?uwWSPPJUuq0FvSeYUbllkp7qP1vSJBRlJvRuk5Jjij4O2Z9FELWmPYb37OxW?=
 =?us-ascii?Q?n8p1oMgsLCZTqIvmxpaLwgk/i3hN4mZtPlYDPeKS3zODWiW7xXoAJJze0D1g?=
 =?us-ascii?Q?72FSFPZvRPAni6eV0WaJ+XLDvHLgQlVOXxzumEsPvcEG3V3emPd799pfcpCb?=
 =?us-ascii?Q?F8+O2ooGld4a4HIVulXV2izBhZqtzBEDbl7o+TJyaQr0m0+c7ORlLEiCcAG/?=
 =?us-ascii?Q?BR7VqWAE09DkEzxHvqJCTFhRPdvwi5bktWxnn1Kso5RVUF5l2CmNZt9I7uHw?=
 =?us-ascii?Q?GIGYRYW07aNObttTr/p70yS3M5nxZRb1C3Xc6LUERQcjO/qy9AYLawLTFSSV?=
 =?us-ascii?Q?cCdFQGstWNuJFVdzmTGImRcl6ybEy3pbyyMRTXoBnNFFjRVI4aDIhdFIkMxA?=
 =?us-ascii?Q?BEuYFcb80+psmaje4xDlP/IJNpU5jaKt3F5QKPz7V/ChrCjpv7V2mmiZAlt0?=
 =?us-ascii?Q?axeoijrCaO3+vKG3yVF7HqATmtpCUJ9mghtt2rGhqRheZEIfArtNgSvqQTTX?=
 =?us-ascii?Q?RzikcS/r2yyXcfJDGo5HFkrHL4/SngIN+EKB7eZ3nFoz2A6oXAgb7XHh3BXV?=
 =?us-ascii?Q?ae8vhr4Hxw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A+XO7bYZLtcMgvaYl7p6ZpUBl2keNAScKlfNjKu2WQ0tArICL2Rev2Q+smK94frzyg0Ag9YN/8vibxgtaG6lADgRkRpioYLJWXL4I9hWc2t6k65DHZ7+tWFte5xfk0b6VKFM1QHV7jM9lJo3WPRWjisrEJR0+/KC81hIBCJTHxQh+ppQ8HVAIxIVqiFxSek9AYXdxeSqsmDlo4PY56Dk3gafXCw5qK5HjfhsfJPyP8Ay4p7LeBMbwT2qdooITfpJPUEoQmH1E/gi1Mdp1r0rhRoUdJZ0ymYrnnUqLlO1qa9vLcxUO06yTWuntthHi6H+pFEOcb9ixUhk9mSGmwj9W3bPZyYhQCs17K8Uie7esxkQKuPqjesIpjxaSnk9ZmSLpfkSBizYxXGH/5ndbxmZElXQGPAhlQHHYKW8UJ4omZwBngw5mNcdqE/0Ox59dDhW91jYhFMEgMrQYaaKA67+hCz4j9AGRpxuc2pUgElHnljJ8bRPxpwkixv0hGoFtTmluxZapWuOcYd/D8cxWrbaMQxB/3lZGRdvXtOZWhEDRfbuzN8tVv4VkWgSa2koctxDzUDp1grHMNYDdRAgvmNPioqtLXjLfAbdThGKfu4TAkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ce8b6c-3d3d-4928-8c09-08de4ea0a708
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7333.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 10:28:24.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RoTgImkI4McaXr1DbqYUUAKskyrPknbacLkxoOI9PiS8eBuxx9xHsSwKVXVl7DcMEI7l6XA8fKs6GHQC/mzSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_02,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080070
X-Proofpoint-GUID: Dt17ORmz0vEVPQfGY_zCDNIdOd-I_edB
X-Authority-Analysis: v=2.4 cv=Wf8BqkhX c=1 sm=1 tr=0 ts=695f86cc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Uf9Hg8gT9vsuyMyUGiQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: Dt17ORmz0vEVPQfGY_zCDNIdOd-I_edB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA3MCBTYWx0ZWRfX8GTaHF4JRU8o
 QIAGSCCCWvRJ85oJCjEp62wi+bBym/IzSLUxIgNZCDZ6AR82PSDHsj+aW6hrDDIccMrhkuFoBnJ
 th0J54wHAdO1RlQvFbWqUbqn35y3Gv5h2XSHZ6rbjaznNTwup7TYmxXz+a11S8ZLdSIx5rOr1Kh
 ifzDH2k0qWPFID6zBeoUaVB+NBJuZoVXapgcvQsDJdeI0S2mpKuAQsTVctBvD7x9y6y2sLFf4+S
 b9OhsOopFp59gn49bYi2pHd42F8G4s+nJSaatWuwgek1nW6RpP/Xn3Vmw9ihHaJdvrprq8/DBZE
 gF6TV8dlW8UMkI1JNsFDtqce38rL3tFER1XG284KmqNV7b4Ru9E5P8ES3oyO7E2T2eg7z60ttDY
 jvdAHFpPy3B0+ozP8bFuAHcv+UzvJU/EjwaQ2wDb5go2Yxvw1qkorb5BL3vzUQtqGMneKMeRTVt
 tUHEe7tlVlYFollif+CL/3gSr6QfF691WdrTnx28=
X-Rspam-User: 
X-Rspamd-Queue-Id: D8993140002
X-Rspamd-Server: rspam10
X-Stat-Signature: wobz1j1k9e4k44wrhuej78y35ijhbgaq
X-HE-Tag: 1767868118-177793
X-HE-Meta: U2FsdGVkX18LiO0RjM9CANxqdtgoOvTRgmVqZrMmag9UIrGYwiy55S5kvMBsnPONfr8rfwApkq3OO3ajN+rUnbEpmOqi6A9ZMyPWqzgKHQ5bTIMbpa0gCUjm9Y/A4+Cih+J1Zqot38avOtm1f9nYbwvKgq3h4lk1GpEFrNG4iRBfsF2spJRelS3WbePa22MF1asgq/pe1kColGS0zIzKCxg8nbHV2sChmJi88zG/QpUajc//+cbkck6rTH+VEzQdxISoEvmjZGbk7GTvlBGj0mEv69WLXnLE4LaZuOxAq1V/j/niQzdEoliT+ekmrc34+r/9BcykBL93809+VGK6f6drB8B/CnX9/UuqYrQMshxjKAZEgbtH2djMFWJ2kfolCbuE1wBg0InJdGVCXmBd33tBqYOPoGjQ/wvuDMIsTct2ET4QSf0VN59d+HK38jQwsIfvyAHgorl787Sv7W8STzy910kNICKzvethbabkEChQmnZbpZdiLIcBncioM7S77bB4WEp8DOLHITkh+mrUG6+B1GCxJQK2RnR7L8mVDfs+tQl9Pb7efB9f9LtGHXFGVVHSL8TR7zUuoafNDJ9JTBl6jHQ7X+oSNI1e00C2BcufAhr1CLIIL+xqPZe5F2oaNpj+QQGChX3wFPfR7jKTtd7f6ZGw5CUtjmr/DZXYl6vUnlLmBNc2rfUS76nA0o9Jp2dbNFFBwPNYa8gGu2wrv0sRZ8FtrPx0fLMnWo8fm8secq6ZcFoGdr43In47gFs0SGkOJX5cKOtxcPlb5E9u5c66D+TfdiVSM+Khah66Tev8tC+07dAW6NrI1smEQMDiwSSUR6uBFVuNHZbGwyCdnIwtt7RxjLYCItyN05T8jXT/sBJFZ5P3kYTLZsv43Y9ZdMOgvuJNq1B4IL3UGN2qNnJld32ruyOYd20op+ASzksTaMhr37QKCco+o8P3Gmn17g2RLSar1qhji12vdbR
 gUcljeuU
 bfSBQx5cBpBXNXe6m0R0bl2kUzV7lncav7tPBUcsHIg4hNWCwYbYevbyqInF3j8dSPz8MCGe6e45Dp4kyZMIT2WD4QxG8ySCT+dsTvzH1biS+KlDaLPmViZ+Ow07uSe7RbVWVasqXBv/Fx/p6dDkBBmxm27ZZTn9xhi3tYcXt7ytIqpcn5p8NaNkLLOjoWdEkVxx1lWUePboDPlHtmZX54k6wtYixUHu8wxQ/17gdu/msHbDPyapiJMioLa/mfJ2OTFcbCYmFHsWJRcat5D097/I24ZBgUqITp0MSHSDMBJfGCSv945rtlxOo730imLsE8jZx9mxbZCT2rBnD+oM3d9mwWoy4i3oaoJvFFk8qblFAuvxsPYV18LyyviGSGq1GGoPxLyDg33R+XEdx2f8+PT1V8k/cZR9VqJOUBpus1t8tabA0BWbf9gVJd4j1SRII3qrTleifk73GlmM2uMiK94JzRdzV4eQ1p1vfvQEF9OSUKLIHqYozTBsxv0dCYGSU1NGzR74bngbC68ysGzxlNZfUxIv05WxZ/aHkOqJpu25aMz/4t/qDAEOlenxDUiluXnisQLqIswyFSuTOZYBUkOGvHa+HcVzSS+5Ffj2ccQdymtUDMP5RxhF70IASkDuAmr8MsNinTeNGICpC+9zFWs8TUIBXk8zS1/Yv3v3D6Fcu2dPcchMloI4LYmKCEQlIVBgA1aEEjmloYov+gOkLO8Aqw3jidK0KXo2GA52v1CWrqSeiMRW/u4zVUdIrLfO9dX3TGpx0HczTq9Yi86nrQSHG3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 05:52:27PM +0800, Hao Li wrote:
> On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
> > On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
> > > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> > > > When a cache has high s->align value and s->object_size is not aligned
> > > > to it, each object ends up with some unused space because of alignment.
> > > > If this wasted space is big enough, we can use it to store the
> > > > slabobj_ext metadata instead of wasting it.
> > > 
> > > Hi, Harry,
> > 
> > Hi Hao,
> > 
> > > When we save obj_ext in s->size space, it seems that slab_ksize() might
> > > be missing the corresponding handling.
> > 
> > Oops.
> > 
> > > It still returns s->size, which could cause callers of slab_ksize()
> > > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
> > 
> > Yes indeed.
> > Great point, thanks!
> > 
> > I'll fix it by checking if the slab has obj_exts within the object
> > layout and returning s->object_size if so.
> 
> Makes sense - I think there's one more nuance worth capturing.
> slab_ksize() seems to compute the maximum safe size by applying layout
> constraints from most-restrictive to least-restrictive:
> redzones/poison/KASAN clamp it to object_size, tail metadata
> (SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
> when nothing metadata lives does it return s->size.

Hmm, you're right.
s->object_size is more restrictive than it should be.

> With that ordering in mind, SLAB_OBJ_EXT_IN_OBJ should behave like
> another "tail metadata" cap: put the check right before `return s->size`,
> and if it's set, return s->inuse instead. Curious what you think.

Good point, and that will work. Will do.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

