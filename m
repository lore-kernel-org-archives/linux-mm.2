Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFECD6100C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 12:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A4C6B0088; Thu, 29 Jan 2026 07:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2896B008A; Thu, 29 Jan 2026 07:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C886B008C; Thu, 29 Jan 2026 07:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 428A96B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:29:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06DC61A06CA
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:29:41 +0000 (UTC)
X-FDA: 84384932562.10.2429FD7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92BE44000F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:29:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MyE8uf/A";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZSyY0awz;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769689777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wU89ZE4XkEBkCZQvdkQ8q6SWK+GlveO+IQpMLbOhm2c=;
	b=nOzHOYFj4Y2wsAdfAmRKN9QWBoJJl5FnN8/DPWuduxl6GY1719NJUcMahChh7OnnsBLtab
	PYrwBDc1foGCRp1ZMluEcwL0NTtgUudbotCQS9JBKjw+0flwWsGwoNh0pttFtapvX20gRP
	AAQm8pNfiomD/lMeulYnkwQJumW4QQE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MyE8uf/A";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZSyY0awz;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769689777; a=rsa-sha256;
	cv=pass;
	b=TfsQ2yZAp+q3KZRXsUdJmI2S7gqpSpFdisOdFa4zhHco7sAr/G0uYTG/7TyFtpcPd8S9rG
	mwZgEStbi36HTS/y2oWRRCLTDBZQ3X+Optm/EKs/gHtbWnLiPLBUqYo5erYU6SXpsPqWs9
	4QQKY0sMuLxz+2pNkj2y+uTU7pYXSqE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T67SjT1231153;
	Thu, 29 Jan 2026 12:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wU89ZE4XkEBkCZQvdk
	Q8q6SWK+GlveO+IQpMLbOhm2c=; b=MyE8uf/AXZ1iV5zBZha5dUkrWydx4TjSj8
	YWPb2ie1dESqSQIqV/MBMNliQyMEOEL14yCvoGhUG7uV2KKn/lOBDY7e7++9/0K5
	/V07o79HIUIJPl5NR/nDNenTOoL76xO8knA7jD2chyQyEkbio0Hu4ASqGLkCVnyk
	NupIDPzsyVWtdYJY1trW2S+P4HMYmC2U8iJD1U+sK87jWIPFUHpLq8QqE58uRY27
	+2bJ4BIr8ief+gpTm+rahQTGRxyIcRLXZ7acF0ymqPpvtSRPVPMs9ZrTMrPqLZEN
	iMuZiWhs5BbgxB6wQ4i+2HDJVbtibl7Rmumd43vnUdpGBddm0OPg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5t6at6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 12:24:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60TAkDct010467;
	Thu, 29 Jan 2026 12:24:11 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011016.outbound.protection.outlook.com [40.107.208.16])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhc9g71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 12:24:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5ACBpgOAsiVqvbqg2i6ypOOIVZYsrDDKbjiSK1ABDUjpI2JcAkT0YOflyqMptbGxketA3JR9VerujnACEKD1YitnunG9PO96CYwz2uzhrDmJexthIzxvGQfLBaDK/hXhCakYyDvOc/+M7LFdNiECi2l91yigZfed+BtGuooYiH94SoJlWXkA3Z2Zk78GLaYYIdX8t8Rm3CieGepzy6BuVvlHN2dIBayNozBDWJ8jqE42zATFZPYJRlday79lhw8d/4gL7a8FOFG3VVQfSF4UxlGEbHv2lorvl37O33wvcnvOHcjlLigCLnJz282qMkAVvx0RAhfO78+gb59TwTfuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wU89ZE4XkEBkCZQvdkQ8q6SWK+GlveO+IQpMLbOhm2c=;
 b=eEFfwLN7EWPyGSAm91zgQTK1cGLwiNvkBvpJUMo5DNpkXDnFe331q/9/9rvLAMrWR2H1HRd1zpXx9aWYn6nxeVmnDPBREdinqceDORFHBUkwIAd23o2FUNYvn5dPV8z41AsfJhuZWRoe7QIk+N9mBgy9WOwGvAIKc02HJ6LLlPQIoAxpLIWk/2DWy2V2MzxUIzkb5IbGBUaCvjx/5ix/aoL3IekUHtAnsh6FWYIThhyDeTc4OAVCzOBrzkOU+EcVgM89OrZ5EIs4UH2Uo58536w2MSVbJJ4ucazYTJQBPClcWz4r8SSTdRmgMjY6AqZB8+14q8/td+rDdVByj4+IOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU89ZE4XkEBkCZQvdkQ8q6SWK+GlveO+IQpMLbOhm2c=;
 b=ZSyY0awzpjeLKYlK3/NVNMiTw9rNfyuI1rqnWTBZIAXuypddMz0EDC/2PuqScEiyK2YdCprW7/E6AKSvhnEjeMaO5v/IU3fV21qmOhpFSMDmNv7wggBRFCSWcW0E/IKFYzfQvLqSrCt7As737ftcQaMBoqhG/w9IKn9qfztW05U=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6103.namprd10.prod.outlook.com (2603:10b6:8:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Thu, 29 Jan 2026 12:24:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 12:24:05 +0000
Date: Thu, 29 Jan 2026 21:23:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting
 state_local
Message-ID: <aXtRWdwwmi7G-Hlg@hyeyoo>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
 <9b9057f8-4c4c-4067-b6ba-0791888c25e8@linux.dev>
 <aXrBiPlpEOOC3cMZ@hyeyoo>
 <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev>
X-ClientProxiedBy: SL2P216CA0220.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: 565992a4-ccd3-4c19-db33-08de5f314b18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7xIW611MqGIlF8zkYHQaIrvJxfFOF1HPDw1qpqcWT6VuG6PuYdFk0caIQ+a3?=
 =?us-ascii?Q?lhzThrZ5yBVvP6EG78M3gHKoG0SQ/O53dz3bgOVPw1ACgAChFk0z4k39yA6W?=
 =?us-ascii?Q?QqjZy7RplQSOLHXgk0338puhueTNenqEuA9WfHghMYkcfZEBww0jJjXRGNwk?=
 =?us-ascii?Q?X4cRMo22CAeALHxl1UnfRjzvZ5mh5ry9GUtH//WlkT78sXOymjPMcsjFv1WU?=
 =?us-ascii?Q?KhCVDx6LK/3MizZjdQr2b345iDeejfk1JsS3FHXtG0PFxf1Ba/pph2jki5M8?=
 =?us-ascii?Q?5m65KnNMODbXFDlShENgpWa4+mlgFfsv7/YWOQV5mT/5U+maUxoth8EDbVDI?=
 =?us-ascii?Q?4B2WhLBGNo7NOT5MZBCOXadhRQjDAo2b4SuLGEGGIeECKUwlM2u1WmHjMtJV?=
 =?us-ascii?Q?SGJz3EnOz9bkwWIgNmNVCHrFU0KGi8v8W1Y5JfZYXtTqsCETH6QgxAMG+soA?=
 =?us-ascii?Q?AfkzlbAgxrIMFCmjP6CRLG06XKZlwEX6J/EAG5MHKWHYaE5o9SvtiDC/5Vep?=
 =?us-ascii?Q?ScdWQBXdTpegXpdzdiygAS8S9tbTuOuJzwIDosE4RDvAosco2T9NRyXqyHlx?=
 =?us-ascii?Q?LVDg9p7vFA9ZVEV4o/8SxCvKsTFGs0KjEJFqVvvZArCMEppqHWihev/xljzX?=
 =?us-ascii?Q?1JZOVeCPKcln34uOE/ua5iFwXnhDKcxKfcrNSXMUjvFmOu2PhoovnoXThc0E?=
 =?us-ascii?Q?s6XZjFlEy13yAz91/cStzxH4YpMSqHVZACEWhKr3pzCStiy1cA4rapfYVkh1?=
 =?us-ascii?Q?QaA/TerPeCPU6HL/WFzjZI6T14JmLx8MLte9ETsKqGtIK++u3rl4HlC8IAug?=
 =?us-ascii?Q?QElFM8DAYz1D29wG07NAS9notM4H+IACEtSRTwvH2lW5iw54JWDGs185Nr69?=
 =?us-ascii?Q?9LrnSROIRsxitsX9USC88pvrXt36/WHs+ki2nbGlr1pp1ibwjOtO4RFLQvBw?=
 =?us-ascii?Q?fS6NN3b+RCJatI7fjakLrXK104QW8Upx5pXjyCz+U5va93GjlQkTZgD/Pw2M?=
 =?us-ascii?Q?40BttRM01eGKxZt6KtCeeNlYxxfySVQykhV4ngiP2VAdp1FgsWotfUxJf+ma?=
 =?us-ascii?Q?m0tgpD2p5Cs+sqcR1NHlra1B5ZzfGzZSagGL3A7HrOB/9xV3tW9LpTVCAHBT?=
 =?us-ascii?Q?cCKMtnZn1ZV4b7sm+oLrOcjdZ2bDR2hh6DTyxe7ZcvXFCb8V4sXrRQfzKjPf?=
 =?us-ascii?Q?39HuIZOg6vlz1WeJm8uLCJ5nfs0dmcakwPP7I699ZpnnNq+e44CCYfMh6/3v?=
 =?us-ascii?Q?8FkslRCubrFwdtDv/OKQd051How4oq4mKY1yEWfZTQ/JPcW+tTmkTT34mAmV?=
 =?us-ascii?Q?nZOvoHRbNUdUxhoJrMs9XW65+0c+twH16+P9J9jM+0/rVAoCfDTuCoBf8cKj?=
 =?us-ascii?Q?wkWHj1X0C54sGP3RyN6yVbo+ZvNw+CHT6JozCN/PmhG5uPI9oivbcjCVB0Wr?=
 =?us-ascii?Q?SyiR6x9FDLTGlNmHeg8aDWyy6P7R0PtUQn8Pte3+k88Vi+CEfrqYJSiWw9Yz?=
 =?us-ascii?Q?VhHNUBm2d8oDcgo7g3WJFARZLeCvxOzkDzW4VUnPkLB94MlvlHRLKmUMbbYf?=
 =?us-ascii?Q?3+p22YwWVVwZrUJ0DvnYxNWJ7tK+Yj82K/9N4nNd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yC7wiStcVC0COgLNgoXKfWKxj0InGvGjT2b6ZyN9d4zvvWorF5OVuBdbwUrt?=
 =?us-ascii?Q?vhtE2w4HzWIl2UZBL++J2kQDtHmoC9TTlzEnOnIx8+y2EmJV7TTR/Wyl2brx?=
 =?us-ascii?Q?JBgveh+3OUwvrTpWwhm0qTi71bqA+VlCKV/nX7Py1p+qaTLA5JU/OZQIbSDo?=
 =?us-ascii?Q?/NZVagzs7gy0L6kRMyT7mqbR4QhuM09TDhX7yMJm0IeFGu56hsgUWH4StSV3?=
 =?us-ascii?Q?MyXye9jnVltfV8bLcsgdke2g6T56l0cwqoWVVf9h2yvAtP4gz1T0cuZnWPFS?=
 =?us-ascii?Q?vjqdsDnYExf/BLdikQCFqQcPSDt705Ap2FNFpJAxy5VeQbyc92e9v2MNYEql?=
 =?us-ascii?Q?tlz/lt3qkqXMgarRz8XS9MCEkGDHxAviiK62juFoVgHj8zGTnyl5mNEWuNeo?=
 =?us-ascii?Q?u9NuwZGKn7WncgEDgnYifZbto/JBxlejKOk+A7ift2pyt/x3RAjjGlmbeMVA?=
 =?us-ascii?Q?J2sScWoOkeDpiAhcNK7lh9bUGfQDL2lA44cq99Z8nAu9O6e/2LPo/J2Gqhp8?=
 =?us-ascii?Q?+RjGNbBs8fLOUzo2s54hc+iZvXAMkJVwtfSC1YR5nWL/cl0DOpxqSUrQCTfx?=
 =?us-ascii?Q?tTS1HT1ZN86IhceoomnchqaDNAK9DuiDbkIHo2/Pxzdw1BCflOE7UhnXva7r?=
 =?us-ascii?Q?eMTxOLJqZAHGCM1Fy1ytWAzKCZQsR0fTjggViS7pyFeTdVowtor/VP9+ChBi?=
 =?us-ascii?Q?9M3XS+pZw5aYCTvVGu+lKegfXxbtsPS5iwApqTjMclkGvoSgKY9rh0+4uB1s?=
 =?us-ascii?Q?LbDOzqncWVrOV4yO8UafGTzQJ98B9HwW3UIlUxQ/MRh2o4dEzfh+mkl9OcM5?=
 =?us-ascii?Q?1rp79d6rO+KaXYUaCMZkvyIL/Vy756gVqQpUYVhbHoc6RbIzL5tMBZWtY2lw?=
 =?us-ascii?Q?FJwpHhXZ8xn3VKyVHJgn70LWsbS0iDo5aL8pq2ZMg2rg6f83mz6fWar40Wlu?=
 =?us-ascii?Q?zH0zyAEFCeqmR2sksJSG5xOu74Cz3F4JXgb5xqd1vciv3o2RyIi1++Ygp9SH?=
 =?us-ascii?Q?n/NLjtguKMJbcCkL0ZK/gPVsK1G+NvxKQzPPJoy4h+3O57xuPSR+DRRSRpqg?=
 =?us-ascii?Q?AMuTGmDk4Wi56Om+Wi/eQzw5z4P/T3jPxuzFOViNyeQ458utUkgqa8OLMwq8?=
 =?us-ascii?Q?NSnLitlrpovd/VBX7xdw8tw447RjoqFYBc5924ltC1Mey+qAf2+mNNOLcbGn?=
 =?us-ascii?Q?zQLZ5phrvM5PLyKRHexojCycvrar1BEy8SPQkyYJdt1U9VpVnhYpOsdHp1/a?=
 =?us-ascii?Q?mz6/Hyne9Fjn+OxXbsqKWMFGbcTV0ZrbdxUmjUlIo+uXXN41MRcqmeDPv+ql?=
 =?us-ascii?Q?1HNbCk3n58GEKA0UgGG5ZlekIh3kETnSS3/7AGHYdE6I2bLi0rsj2Ig+iko5?=
 =?us-ascii?Q?shccq99Mbi7haix8vrSOi3TjxMxv/NLHpXY3vu4+N39PLwzGX8KMLToCdAXb?=
 =?us-ascii?Q?8Urj9SkOfmfA+ZsNgoW3VfmZAP+zgMwek32rP4RStUAhwsERjADd2ofgRC1V?=
 =?us-ascii?Q?Q3N9PsKTq/gizvdFlIAV7l3c/XwCWctFIfqRzA3FAMAlrSkLJaNqQaQbM6aq?=
 =?us-ascii?Q?dLnwL1fbXd8NFfrIqdobMhC7ibzbTU5+NG7kR8EEfUtbGUzS5tqI2pVZard5?=
 =?us-ascii?Q?WVQ02NRe7EM5n76pSJB5RgsiJQhHG9lVZXAMshI1CsZYfAYtUOANsoWqNIap?=
 =?us-ascii?Q?Ce9I935T55TRtVxOGaKeb1RlHr2x+sSp0AMZmPjWd2hhlCaZG+WPXPy9uad0?=
 =?us-ascii?Q?IGUQZJmaJQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B3X7D8rBI4ASwPHpnH7sbPFiShU2nt95cemqh/UWdJ3OdSEJjwkEqnjmZOQrk0VBLKGaJ73mAUMbPUGJa5/3quZGyyxWgjIevkZy1ri1mT7hFzrI2Jyp0wxJ9SJdS4mJFbiZ3BlVUcxjEsGK2YIx79pCMNFmT0TkUH9vtgf/xkHZYB6sA4wxeB+64Mg7QNr3TBodkaSyaZmgtCYEiX11mDAL+lYQtMQfEYiWAxL2SMVIJ4z6goX68JlWAb6aMnBROus/Wygod9uxtM2btAixt25YqRkS84KxXKSsb9Ak3Vqx6o379n25QR279uzQa6uJtW15uFaDJ+ns6LTqFMuw8lG2AoEPSPJwhu3AhcjOEgD3nVED0PWN+zsrDSIBjqQAYBxMAcY1O0X4hO+gkvj36VceiV8poBSEsNcYcjvW3ZtoBfB7IcMIfX5Qyzub0RFIbIGdBjObi6A4zzNwnjNTMD6/EBmSExp5h15NVIBjj4AzWR28gfFxnKzxJdFUZ3AOsaaIINeyy36KpkTvwGDAhaPzmqtkfbpWA0hMgdYYe5UVQ26CtVGkSapGok2y8XsyVv7R4dPV9jf6SASWC/YZzFDBRZ0mod5mLcxr63x5Nd8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565992a4-ccd3-4c19-db33-08de5f314b18
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 12:24:05.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7eVxcpPylVA7wJiF9Mo/TXUNGW2r1//7rRkaneHT9NuBFVnttcxrs6it1ubtgHSaLcxw3Ud+cgwlZrLimd/JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=826 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601290084
X-Proofpoint-ORIG-GUID: KbQVIdkUWfzgeQTYL_3OtahgSUJ7H1ra
X-Proofpoint-GUID: KbQVIdkUWfzgeQTYL_3OtahgSUJ7H1ra
X-Authority-Analysis: v=2.4 cv=IIcPywvG c=1 sm=1 tr=0 ts=697b516b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=ThPzX6-zeF6mnqZVBBYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA4MyBTYWx0ZWRfX0+83pRsCXPSh
 0EtoTOVrPZJguUHbj/X+y7HgPJCyZmVlGmQ495h2SW+PkE1QT3Qb3XZSmy3yCx7KicJDcQHiXuC
 wffYgkLTNMg8w7J0dSaeKbTPKaucltwbtWcVD5QWREDQKLf3JV4oC00PaHosmm/lxhQgKBbr1ok
 HUtRuNCFKfvvGlurG31c7kfv7iClavdjFdEeb2MZP3wK/pVjYtvgOtYQI/RO4mHT/fInadvNszX
 FMztawtEgzyI/g+Dwck0cY8K1oD244RWaSt+3w0RgJR+70AEBlM0IKturih9TxKY3gYoYrHW0Gt
 jjmpiZyZKrzv176VAexYjBqguNnTETxTos8UUfSc0eB4niqZwhVIyBthZuShKlPSm09MaEbraUQ
 dDso2LT2hSFY4Okt8buTaqAs0wHxJaGKduMAoZw3zE3drUQYAEhTD4w4QT0U+yMxcIx7VkmhldA
 BQ+9zhovEtgl8oGUDMw==
X-Rspamd-Server: rspam12
X-Stat-Signature: mexspkqk3p8wibwbsiitr5j9sn767utj
X-Rspamd-Queue-Id: 92BE44000F
X-Rspam-User: 
X-HE-Tag: 1769689777-557144
X-HE-Meta: U2FsdGVkX18lYAnFpJdTiW8dSovX5+DSKX3w9eq3BxdYtRMjHp+RIZ8WpVvFCS5/eS6rd13xX7iFJOfcMQwegXDwhsOZOY8pPh+P88XnZa4rMMSZm2mZlDnvQrLcVOtdn2AE3m/sQkjPWKHeT0gC9sYofTedl2wJUasngtkOmildMCiRxk2yC257JcWQ2HTvS6NJS8yYAi0IjFki3QolPyFU3sQEdk6mF4XddSGqUg9N+3SiVbqrGFAt7mFiIZ1MwXczwTMxBfmTmM1fykZxrWmmG16cPj1ZQSe2q3yFTgrun9pTuk8eRGGIjUn/3viZfQ85xYpmO3jEIViR6FTflZ5KWyYKe9cFTQ5Bbe2aE6+efImIFjqB7t519Rq5q0E6Ki5ahxEn743hi10aTrwsUd3kfGK9CxXh1q2sOgGe9lJadHxPKodOF26RnK/nh1+w5tRtjHu+uzziRBszSGoQ46evcyWEIR3DfPUdDUpILjs4wuL6fp5BzGEbBpPFSMswrTZ7znrPI5kjY5WAhwuU6seEuBOqJTnPFkb8cVTJqkNmcMxOApwvQGqJbQgOQiYdQESeq5zJze/kQ8i4JlnyzgPdzJr+BjLa4KWBXJXgJdJbQyOkj0jd7wYQk/kctAknnuiR8YYx04OfrtMRbCXlTQJtpTqdx2Vwjr4xJuUcPFjHgm/fdBB+4y3tbnSFfgRoV6/GU62LZjG0+ZyaUzTFbMGomCwIMJyEKOYixZm+N33mbn3Qd2n7D/HsverUXOu4N7R4ffGBqJqkswIJ0jpTiknXZc2T0tUu0M+wV0jOzrx/zMRxckHkm14aK4JhEHvC/P00DSg+AlWntqqCFtUf+xaLju2QVdYel6k3kQpHekJrvhw7cpB9UqrjeoDm8UEZ6hpYjKQsHuG01RLh7l2CuD3Ym+Wu2LYgmZdxfQpuFVfAyJOjZ33t0gVbiBcwBy9pcrYJMBlfUCb8YJNVLn4
 LejQtdUi
 DvZtpEIUAzHuYFz4AEAAP80u1NS9cN/h1E08DGG5qQKo7qcRkwKfbamXx6j8UTa1w3NHD36DK+kh95t0q9N1Qv5LFjRq/QRo0HkR9J+MSfA/GTq8rkusoQ7rKVPNpagVrIdhjZmpCha9nY/sXP0IZL875puv67Wws1k/ggeJMO/oGvdcL6wvlYOc3xOWc5xNlilIrMNXZjiBlYPaEQbQzXUp/zQ2U32L+ok+Av5FVe4uuZ2nxvIOvSBuGtpA8+Eu7gMirHe6IPnhQ0cVtNG7zHhHMOn9fFC7Dz9g49Aw/sg9bbiUt337JCKbUPwUBheojMGTPIDcbPTktP0p641nj14iMk8gX1sBsAcPdL1Gbf3mPwOpcGuq2wSEkIDYCMYK43aoEUK+lP+BL7lOHCKRuQDtvYbkHcdgjrTU8zh0g+AEoYWhBJmsC6nScUUrv/Xwq2wYszt7LyzjlPNa4sx1Spo3NzmHfQRT74VjtOR1cVbow+Lo0EZbWNtTb3ipAo3ND55/4PMLVZdSVG8NbbKI85JLB+ZVlyq2fBnOQjCBvSuojaBiT6Y45DGxA2t9uwiM1nx0PWwq4+jKp0UVPULwJAuRhNxijkDjPASdnhHlvejD4UTppBqcfSFcWLK2YSr6cMCphpQnBjZnacnHdLhn/rM6vrDhU5mfNdjz8cCQBr+RLLfEQ1sPrK7O1XYgYibimmNTE9jP56v5QFw/48XPpMOCPUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:50:39PM +0800, Qi Zheng wrote:
> 
> 
> On 1/29/26 10:10 AM, Harry Yoo wrote:
> > On Mon, Jan 19, 2026 at 11:34:53AM +0800, Qi Zheng wrote:
> > > 
> > > 
> > > On 1/18/26 11:20 AM, Shakeel Butt wrote:
> > > > On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
> > > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > > > 
> > > > > To resolve the dying memcg issue, we need to reparent LRU folios of child
> > > > > memcg to its parent memcg. The following counts are all non-hierarchical
> > > > > and need to be reparented to prevent the counts of parent memcg overflow.
> > > > > 
> > > > > 1. memcg->vmstats->state_local[i]
> > > > > 2. pn->lruvec_stats->state_local[i]
> > > > > 
> > > > > This commit implements the specific function, which will be used during
> > > > > the reparenting process.
> > > > 
> > > > Please add more explanation which was discussed in the email chain at
> > > > https://lore.kernel.org/all/5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5/
> > > 
> > > OK, will do.
> > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 70583394f421f..7aa32b97c9f17 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
> > > > >    	return objcg;
> > > > >    }
> > > > > +#ifdef CONFIG_MEMCG_V1
> > > > > +static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
> > > > > +
> > > > > +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> > > > > +{
> > > > > +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > > > +		return;
> > > > > +
> > > > > +	synchronize_rcu();
> > > > 
> > > > Hmm synchrinuze_rcu() is a heavy hammer here. Also you would need rcu
> > > > read lock in mod_memcg_state() & mod_memcg_lruvec_state() for this
> > > > synchronize_rcu().
> > > 
> > > Since these two functions require memcg or lruvec, they are already
> > > within the critical section of the RCU lock.
> > 
> > What happens if someone grabbed a refcount and then release the rcu read
> > lock before percpu refkill and then call mod_memcg[_lruvec]_state()?
> > 
> > In this case, can we end up reparenting in the middle of non-hierarchical
> > stat update because they don't have RCU grace period?
> > 
> > Something like
> > 
> > T1				T2
> > 
> > 				- rcu_read_lock()
> > 				- get memcg refcnt
> > 				- rcu_read_unlock()
> > 
> > 				- call mod_memcg_state()
> > 				- CSS_IS_DYING is not set
> > - Set CSS_IS_DYING
> > - Trigger percpu refkill
> > 				
> > - Trigger offline_css()
> >    -> reparent non-hierarchical	- update non-hierarchical stats
> >       stats
> > 				- put memcg refcount
> 
> Good catch, I think you are right.
> 
> The rcu lock should be added to mod_memcg_state() and
> mod_memcg_lruvec_state().

Thanks for confirming!

Because it's quite confusing, let me ask few more questions...

Q1. Yosry mentioned [1] [2] that stat updates should be done in the same
RCU section that is used to grab a refcount of the cgroup.

But I don't think your work is relying on that. Instead, I guess, it's
relying on the CSS_DYING check from reader side to determine whether it
should update stats of the child or parent memcg, right?

-> That being said, when rcu_read_lock() is called _after_ stats are
   reparented, the reader must observe that the CSS_DYING flag is set.

[1] https://lore.kernel.org/all/utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz 
[2] https://lore.kernel.org/all/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn

Q2. When a reader checks CSS_DYING flag, how is the flag change
guaranteed to be visible to the reader without any lock, memory barrier,
or atomic ops involved?

As Shakeel mentioned elsewhere, I hope some explanations for correctness
to be included in the commit message :)

> I will update to v4 as soon as possible.

Thanks a lot!

I'll wait for that and will review carefully to make sure it's correct ;)

> Thanks,
> Qi
> 
> > > > Hmm instead of synchronize_rcu() here, we can use queue_rcu_work() in
> > > > css_killed_ref_fn(). It would be as simple as the following:
> > > 
> > > It does look much simpler, will do.
> > > 
> > > Thanks,
> > > Qi

-- 
Cheers,
Harry / Hyeonggon

