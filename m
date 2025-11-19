Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAB9CF3182
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B3E6B009E; Wed, 19 Nov 2025 04:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402F56B00A8; Wed, 19 Nov 2025 04:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0856B00AB; Wed, 19 Nov 2025 04:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F34D6B009E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:22:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD3DF1DEB61
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:22:33 +0000 (UTC)
X-FDA: 84126816186.17.D9D7D11
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 582898001E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:22:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FAIDJ1+T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="A1/DyAUx";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763544150; a=rsa-sha256;
	cv=pass;
	b=hTkDK0RuoGUOjvYeYmWQdNpPASIOtnGBKlFDJquBAbSpKIN/9dz3wG8dcSz1BO2iuD4QLb
	ykl43IA68MSC7RUekZ2ipA+9k7CcqnxQb3CRYrgsQpvgGJPmRpy2btugpNWYbLA3DM4Qzk
	rL3gzfrDoo6sDquTVcTV9WNtw19wXaU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FAIDJ1+T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="A1/DyAUx";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763544150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2OI+6894m31Al2d6wDsX7g1YhEV0tRzVqY7yLG4OEs=;
	b=pBXa/5aLqMsELqBiQ68je3eB9oB9AVYFcmhlvSVdCE6KWCLETMpKZdser7Vw6+M160DNge
	6lEIJwwOU2arekby4d+wlZNURi4prF+3PXEbM0i20I/V1Ukpn2ffesWv2VaAdufTotb20Y
	TQr+XHy13epUK8EwuF9KhnqlxDOoAGA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ9BfQH023358;
	Wed, 19 Nov 2025 09:22:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J2OI+6894m31Al2d6w
	DsX7g1YhEV0tRzVqY7yLG4OEs=; b=FAIDJ1+T29DGq6ZWMSJEczCHQGTipqlrOC
	308k7mbs20s4N2xRgPlSDG6KS+N83+EK8kNv4XQI/gVEdw2XfvnT2SNL8D1ebsyK
	xkeRDZLzVpDi4PbzykQs9sOGYABisRqiKSbpB5GOo0aa292c2WUTY1zZYKRmcPXG
	P4KBjRvuSepsjiN39R2MUp5uzBEWzI739r7w9t9uwXYX9ALyFJB7yiV+8BzrCxnB
	7ZKrhY0Si4EgqnB0TRVL3amkbGutBY3AYsXO9s7yPFQ/8RbJ1z7Y0DyMeoPTrPAO
	JjnEzeoo7TC4zrOV3j8I68U4G9N9/ocVGPKTPRrT9JS6kdF4pnNA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuphu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 09:22:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ8PrDG009444;
	Wed, 19 Nov 2025 09:22:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011004.outbound.protection.outlook.com [52.101.52.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyech8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 09:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQWnH8Pgs0bBoNI12hq0eaAjgWLARUTGRr7lbjYunTsQ+WMeiz+aJ5yc+E8WsrlT8BQ8USt4YiFP7mvoQhYY4DzkA8Z5N6FWtlKODafXEHbtrZU/Me44du8tJwK35uTBilk5Vxf54w9wyk9HYWHSJ+aBFWEqiZNSaxKfs7kyDrzn7u+yWpT1EifURLgMeSkGpinGeFTi538rtlq48WJTOpp6Z7DxSzJTDO6wO4aXn1gq7aUU7hR/STmp1UegWI89owD2ppBuGAt6RPprg0cd2Gq8FgiActp7xr/Glf/VbayieD1sTy9RWN/WMQ8BNi55eUUx8mtdpKO8v8/JoOPqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2OI+6894m31Al2d6wDsX7g1YhEV0tRzVqY7yLG4OEs=;
 b=ZxYFTReKLlaq0p2WCKgrh+bnGmtdKNGS1Au/QezNlxti1cph4OdJJIJZVTE4G6c21eOY1Re5WbELu8Ibo4038LrIdW+W4pA1yumOxSVVf4M3WdHMTU9ZpAIzMaklNIr0n/iE5+HzpCk0Vjwu9xGkNGycJPI6mHaRLS7/2rKuSKsGiskMNbHcR57byIw6rxanFkRVDMU409bxqqluuwaj3RiAsa1/D2EKgddPps4c/pZ59fH0eLh0x7m1GlUfW0oj4kZ22sxPecgYlXTmn3jFN+jft5rEZbZkawIjN8yz51Ke7b1b5mSDqHCo0TDFRgLALl/6gFJP8QEVaphOCvRaEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2OI+6894m31Al2d6wDsX7g1YhEV0tRzVqY7yLG4OEs=;
 b=A1/DyAUx8Iv1mnnKfSve1jWVp4bFq5zU5eDIYJW80zVhdBZsMqi9T/GSW8jG+9rU9GPSuXVhnGc02OTqLADoLz8R3057VjXVXtc5nzvmx/EB8xCjUaIfivqTJLiPbAjKGaphaLyOWAOZdxogwxGtY8pzrIfu/otLa9cbwtC4qpY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5179.namprd10.prod.outlook.com (2603:10b6:610:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 09:22:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 09:22:06 +0000
Date: Wed, 19 Nov 2025 18:21:57 +0900
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
Subject: Re: [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release
 in count_memcg_folio_events()
Message-ID: <aR2MNSVoj8uXLZBS@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <eddcfb8a49c915dd897a91ca5560553b2bed9623.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eddcfb8a49c915dd897a91ca5560553b2bed9623.1761658310.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0043.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dfed95f-1c7c-4ca0-1c23-08de274d1b30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pLq1mlQznbjJznMqIluxPNyPIEhblgbqi517VNajKtim/mbLp0TCfqIuBa0V?=
 =?us-ascii?Q?902THAUSyz8EoNmuO/EIjqj0RPvK71+X+ztlYHgJ+R2s6umaN0OKZhYLu/Bn?=
 =?us-ascii?Q?KBtvYvuDUwF0uzyDJ50QrNZAnAw0VPLcuNAxGmBJz/QyBpfHnnzWfDJbOKqq?=
 =?us-ascii?Q?3i75QkqCb4PMK8m6wlF4LEuMeZn3g6fVt6yhCSOGQGcuVrQA/dBP7W/WUi9d?=
 =?us-ascii?Q?jERQK2CA08ZEifEV+wrCsaTSH3Q5SBGOXzQ43tL8iS4Tc957nHC4llR6sEuw?=
 =?us-ascii?Q?ywJo4YnF44WF99IHgPDMkVU/ycJ+eH5Mn1rdHXOqMV30FUekiyW5O7uIy9FE?=
 =?us-ascii?Q?UBpG+Dh7Myb5vifXg2kUqb2n+87VDkr2IAGQQ+17Xp2hOUmevXm8OMpMl4tq?=
 =?us-ascii?Q?wW+ptwi8ozPPqXMd8tJQIzijoEmxxhzJVaqPrad/dG2MPIyyfI8eV4cuF8OU?=
 =?us-ascii?Q?D1hhh6hrJdvdAe4Sd2vKxQe4y/iRvLPl/AhSkhjYl9/UYnimMV93cKpUBMZV?=
 =?us-ascii?Q?WHno278XwmdCmxY4GzhHMZ9Tz3r4wjMPIjOWMPamuhxT4tVuseZGKUBZloRG?=
 =?us-ascii?Q?omAvbdW1+mhnLMkzj1M7VSN4DMRYi2H0pB+DIHXavIxKNytoTb0pfTqY0EvW?=
 =?us-ascii?Q?dBSA5/8EowNIDCdCvnu030ZJZl9lxZAHFSuiuDaipueOcrtesM5E6tmK7T1y?=
 =?us-ascii?Q?0nN9ii+Vc5axeFaUmgMMVnV3cJs7q4qj9CelAR5VE13IALRXLbhcnnPFByuQ?=
 =?us-ascii?Q?0heDhbuVoNR4p0zwv5hIHbZUnrkkUsfE2V3TwgmN6rPkcMTjnQevbd36XEnC?=
 =?us-ascii?Q?zxt5actvW9+WCtTWXiKF+GHeYw9XoyuDUaegGe62w7sPSaXM0GDyuuTAh1ak?=
 =?us-ascii?Q?x92VXac78Sx3+IiS6qVQUD7JDtTU1cQodgv0+AAFFZs7+cv7IJaety3vomRf?=
 =?us-ascii?Q?bjpV+qkavqeWek3OTCOpT9/jng1i62tmi3fpkKPJE0sEeDX0yaYj3w4ISC9H?=
 =?us-ascii?Q?Mjc7/VKpiimGlsYDUJHflU5J7CQ2g7Dwo7A/MePyyPsb3IDhMXpXwjcfDUBZ?=
 =?us-ascii?Q?8QUqOS6tRQTF/eiKGyNZN5bMx7fPRbL8ezbj4ZOmSGrcXumTEE/EEBXblVYA?=
 =?us-ascii?Q?W+y1KzgPw4gcV+0N8S+aYps71HSuZg1dwaCCU4CvKyt5mOeugf41oo2s26LD?=
 =?us-ascii?Q?Eei9xtk8HM0UCUWatFRYAZ76H1ET7t19x4WC06XAOBVOFnmZL22iYfhfy3bs?=
 =?us-ascii?Q?l0LVFvQdL1agaClKcrJhNBJ9wHh7DJxgxCucrXLjze+CORSKq2nyGd+tTlPu?=
 =?us-ascii?Q?0uadYq02Zaar5BF8jyR3CH8K26L/5E4WGC+HuQUJWXSLsn96jYiik6JB5n18?=
 =?us-ascii?Q?JHQfku54etqjZOtcQFFnMmUCF3TwrcP4TFapksrCbU6DDEejo5rt6BSe681w?=
 =?us-ascii?Q?U9s1O4otgDXrorhtpnwzm0EDSlj2Enn5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cIzlBibpF4TogEoikXjXU/2F/dfeatxUnItQkCGn4UK50T+2pJN2kcOOkzMA?=
 =?us-ascii?Q?Sr57LXWXc/7IyB01RsA9FAF8C5fR0DVTjoZ/HTcJkD+SikT8kqVydQCL7LJW?=
 =?us-ascii?Q?a/zF7PUGw2Rw9bHy0BmQLPrUg4EA0+nMUvpdLBvbx0lp0xAWkL+a8rKhIhuM?=
 =?us-ascii?Q?Sun1Qf8EDhMI6hPoITfXMb7KEAjcj6UR+3Iq/fgaPHTtnnlICH/sJmcGEBzT?=
 =?us-ascii?Q?a6ajWDQUj93UmENoBsFc/Nj6//pzZ1Ul+pTgwHeFengZjfhkwZJVGa8ab7I+?=
 =?us-ascii?Q?UBAPetL5rlVQBqy30gQeT00ypYvYYC1hvvHBfyPuCRvLfBZqoFBS+7WkYMG/?=
 =?us-ascii?Q?n0jCebhINJSYG75k46QvM+ltMNiJmv4iehiRwCxJ1EmQtHL1Qi4Z2ArGnMOB?=
 =?us-ascii?Q?ml+9Fe34Er2nYrJs1+w/+xfalasQl2Q+Lj6xmFqTlU8fscDunwF1LNsfTrE2?=
 =?us-ascii?Q?NPKkqia7kMHGO3+9LF/1IscEjmnVYcl6j6oalQZUgn+FZIh8VtGz1IXO7qwr?=
 =?us-ascii?Q?MCnc5fBE+nbzENBU43p/gpThqoVHwX/IWRSzS6f5iYP/yqvib19ZV8DMg4CI?=
 =?us-ascii?Q?ekQjLfsIBpGpqe35C8knfQM+hk692tlfoUTH1fdn0MqFSSPFah89PVYzAM5Z?=
 =?us-ascii?Q?2qpDrthij2va2BgDgZTny82YAA5MsrH23nSv3w/0QwA19Cm+Cl1xvgD7eBn6?=
 =?us-ascii?Q?slCER/n7sNb7GduywvhEYs4Kcy8Zlb3MZpmJi20BQ7mH7EEuShSF4zQZu/R2?=
 =?us-ascii?Q?0dynQKrdLS8w3RYavb8uBgKMnSnD5hN+8uj50VS4saIpYZ65TIjb7nb1LvBQ?=
 =?us-ascii?Q?wW2/F0o2Jsj14uLNWTUKK8k0sk0zwJoPXfb5iG7mZFyjf+R8SPwAYpfm6V7/?=
 =?us-ascii?Q?uE2eey0zi5hOFJfCsbBQ5ZnsNKczyPRG00vFLIrkSGnnGl165NDPqsqUN/kZ?=
 =?us-ascii?Q?C7IQW6UteReq+6wYl7HjpSb1vwKwKy1DFdDt1gMX67gdgk3KqEZxlJCwi0Fy?=
 =?us-ascii?Q?2tF6dBTt4E4ISKByq9Lc6jeYemkyqjtopqFYdMIjn/m76M51IqNTuHlRbyOC?=
 =?us-ascii?Q?Te5TGb787B5g1Or2dS6sfeKxyIp+vXrqYbC646lSPLqslEEupeWPSeJ3XasM?=
 =?us-ascii?Q?uK7jc46k8oCxUNZeSmz3aPViQ9530t3GN0m/xDSD3ow7L1P6zxfLftd45HvP?=
 =?us-ascii?Q?Cswg4QgkQno/MxtR00LllNTDQiO8KiHkWHlbwMYA780NAPYb8ah7BJCgtX/k?=
 =?us-ascii?Q?zAMrSzHj9mDnmPtD9nXhkacp3VMdISvvRmwNdNDea6rJ+2nPaV34yCdzdYki?=
 =?us-ascii?Q?AV7ZtoxJQazJC2R0P56d/CeY9pcpHLj5uV5dyzzKQaLbLT6ofSFFCvsWpbbO?=
 =?us-ascii?Q?nDCqFbY3bhGDteB7c7Ha21RvBWtt8KK0ohS2+p4m/wmx6BGr+c3IxcBT7tgX?=
 =?us-ascii?Q?Xc4pRMkGUd+vc87aUsffgv659Wuyf7cT87YbBur+WCGaDikj6/qBAN7XihGK?=
 =?us-ascii?Q?opFvFrtQudJQWbUW50AXm6n/RGSO9HlMy+3mNnI82FeKc19cWrHVdwQ5Ttci?=
 =?us-ascii?Q?Dvl4teURy0QLWV0lRx7FxViOiZCNsOhmRipFVfQt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GZo43SFhqlLQdjKsB8tz6yaYYIpAPi+6B+yowmEPSE2IaYaNmQPhu2btHR0sg/Q72hZrXNxdEitk6e1lTCIbhp9ODb4GhUvbIlnICats7ERzDbVDRvju7vBp9qko2oN1UTQ2RYsMkZsmsNF1Tzzo4VaMy2IOe4qoW6R7Ya6bsQw/tyFoJxwdpBJlX90lentelLNR4a2isXUwNyTiLATg7N5Q6a+GOKT/8Lckm/Wac5pw63yl7RDd4Jj7fAC+XvibWumOxoJY1OlACFNiklf2cuKdAn+GwK0bC7+g2vXuqBwcJPWcb73T+FviLGVnJ9l8qHPifaR/JJDKNuT24hjjyZqJV27NNZH6kW139Q9d2c8mrx4F86YVrAJjKOQMGR6bPBZna9mX2NapMKPeaOngCc059qRIdvRAR01hNLm4ZEZHujPTfCLSpLGBj8AWDONyaACfWZDiilswSKEllszg0pR8ZwXthjNpCQUm85x1hglM6WoicIQ/MbnCEwUvS5RBt3aX2DEOVh/eOvhvltrOwHhDnMStZdw4FBaBzoiFMOsFHS+FmxAKLfWhIHSxsj12idKDvKMrPdaP57Rq/PgmvlcQcHkbUp8v2xgHocQ/d30=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfed95f-1c7c-4ca0-1c23-08de274d1b30
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 09:22:05.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7P1skBCgnO/oYGK0FtTAk/B2x505A9NPMrJDhC4fNuNbqO6hwbBRzHrw28iMScyIelLGwjbrLmGvVGfDTDR1xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2PbCMCa1If0O
 g+jLX4oqJ54jOxbtzmXZaqIBwcAd2O/WNMHxIMfcB+6HNqMKgt1Fq4ICZKUiGd6XAUq5fZmJdIg
 /MyxcQfzSzf97sRWpUQTMw6zq9VPdT3vL6Pf48LCu0P7e+7abzmu3J52TyXmKYQT0ggbziCVbyI
 eoU2SJ8/JDX+C1W09NIs8Pc+Y9/j/E6OshJwt/9y2XSme1ps3ezXNn6sGwEYB0gRGkPxoRKZNR6
 eYcDeAuzMHlcSHjXKmBKvy9zGIQzPN4O5scPVDT30V6B5AXXyWi4IC4wEEe7vYBbPOYzLDcGlnS
 VXaXtaoaQpbNr3O3R4SMdI7JKx7JhUXP+nGpY+NidVWl52QIsxi7Vuik6L67luHoOpmyrkWhdmW
 BE2y/sjmSwvdu3JFBpefcCqZFz8nJoxtUKqE6uyGCgjT5TC7Skw=
X-Proofpoint-GUID: mOnhD6MR4wJnweAN6XMD36zqoUUab4W_
X-Proofpoint-ORIG-GUID: mOnhD6MR4wJnweAN6XMD36zqoUUab4W_
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691d8c42 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=XoEdJELPLrNRloKZQIUA:9 a=CjuIK1q_8ugA:10
 a=ZXulRonScM0A:10 cc=ntf awl=host:13643
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 582898001E
X-Stat-Signature: h7a16rj6516mr4a9dokwzejq3y398p7k
X-Rspam-User: 
X-HE-Tag: 1763544150-938076
X-HE-Meta: U2FsdGVkX1+SdJC1PfYRfgLvskDbNeBAccDHyqa4lLgk80tKkBYliQtDeXUf3S4Ag3CZyp8Q8y1ZT0temXA+cxjrWpXAgTXFbNFErCTnNEMaZmWotYvrOP0tOS2cUDxxtpeD+/9ew0iht71OUkUPLv+v8v7/XvHxmemZX05XmjNc7s4s9NVyG0+/1bf6xHupYtik9Kt5avT632rufFBLnhmnCfs5fMaLZsJbP+5Ky8c4Y59G/IaRDcP7mNY5o4Zimm0mJpRId8mkfBKmDvyA/aDqjNBxcLe7y3FMpL1fyoWUXH2kkUgmZ9lUJcdJNlSPptM9w6UB9mhrOHJm3VMY7sy5cIs+BqKylovbxgYcSQmk1dubNTXraunIuoKIvPx7PPBB3bBCO4LIC+bNP+C9Nmmk7KRlkWAS7zw2oYMXneZsthInLHu/XlHsXa88OYJyWa4Y11IdyPGpuXBUFrSM+zoYmpuAIW7TzX9bIZMO4xsEcTBWk+XU1oDewLZY7CRKS5UQP8wIvUQXdSTI5J/JokXkTeXxQYoqwXbdHzDuWbvVw2cEjAXUbr88EJqlVLbZHH844PKb6r+9jVvjq4PAu9KnGutrhyuqK4s8PKqRPUoAX4zCdw8+C85jpIaaxpchdiGtxxY+PsPl5t2pEDhUsNmG2y+Igr3/kJHlOa1l83aAHcq43DAdDUGI8atNfTdkEC5THKtHkr9LSF9yGKRiI15O5bhugbtHKnZaGmvK+Oa2tRzecpY4ac+0XAOl8YCOZMSf50bMwdKDvNl1EddcEvVSE/p3ANw5MOFTQYql9nGXe4kkODO2BrfjTq4Y1r5xkvtc3XFBM+12DaW3+MKk0ofbWxhYcWA5/8ppzvw/yyPeDb9X3PhA16mcLjW+1FRU0nyRn5Kwsjos1gE85koJicpzI373KQLnPfh2Mjq225YjxUgl8vGtFo4Ljkwu8Sw5FmmgQJ0C1GMtbMDtSto
 GOIZ2b40
 5YG4M2pNU7VUERamK1rxqM63CeTVs1J5wqqOSEtHsZz8IO7z/+FE40XepYHEmizTx7wMtJl/l0Duxcw39xtdmNcmnGe1qXFnNQ6xwjf/r5zTv/kHy8HDcCOfGH/dvDorNBZGeMheoNUlR4+dweycaaYbPt7ydKGTn3PtdbLlo9Q8rVm+SPKt4ThfkcleB9p5xlNChemozzc49Zlj5SgtZzkWx+6YI3M56jKSQr/P2Ysx80eQfL3j8rnKSj6VQFb+Y9hGgeIMXOgiJMqGQe01CGJEHu+RqOEOohn1izYaxnPouFMSR6kqOLiwUWN7VxqgOGboMTDeScLOdKRpotxXRD0pdHBzBM+hGg9gamjlFbqeBSj1mSNv+kFNnNJIcKXa0GNyuYcgThf2Mo4QaUv6Bh34Y8pJJUEcvkUUAWTwjHS5Qe4QcjOBxDWDCT2QMJYoJNFUJ6YwpKv8y20aReCOjLCmJd37Jfz3etcjBSzpNTLMeq97scsj5hfDDX98t0xe2Fy0i/kYjWJCXXU2fMozbEsk7IrxI9tFez8RAYY+0jIhCEehrZdrk51V+PwUdCCcEh5CCzEwExyNXtoRupeGGxZe7PmewaWc53n6z9HCccpucMKi88Tcjhm/qVkUoGKos+NGPRBrDMLCOP6GrQOOC1SgkjoiImjCe/TWg20X0RPZLXhQj6VSYyyOsYMojbP+K0Xeum5HBjvRSNr1h+0NHWI/hgpHUn8i/zjxrZQ8+sMFrDYCDsHrm26WltC0KWZEQkMD4hCrd+tzVZWFsn/ViGuV0bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:23PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in count_memcg_folio_events().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

