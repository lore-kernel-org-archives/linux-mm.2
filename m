Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781BBCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4306B008A; Fri, 28 Nov 2025 03:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A650C6B008C; Fri, 28 Nov 2025 03:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905606B0092; Fri, 28 Nov 2025 03:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC6E6B008A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:41:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D79B13AB70
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:41:08 +0000 (UTC)
X-FDA: 84159371016.05.93F0E6F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id EEB5140012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:41:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nXh2Hl2k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gex1EZn3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764319265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7K+MmusZ4o93/WMmd7lTnGZc3T2Kx4YRqrO2ZqT4R0=;
	b=wNTtiYgpHiPIIGnaW4I7Ekq+KcR7cdcY7Ellmn4D84lj+FwDhwTHR7+D4bJSyqEI/j7rCq
	r9Cq+nC9RVcs1AVxEFCg137UnUmANzflW76vMThPWcklLH3wz6KexfaDeJFz/MkwLQZapR
	tSdafx1tBWRxalyw3y5HhUqIZup6ls0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nXh2Hl2k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gex1EZn3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764319265; a=rsa-sha256;
	cv=pass;
	b=1oVgRuAClFFtxJzdHEwOMloQDqmKTYf1sv8ceAj0pUOvxDVJySJMAFjg7rZ1TAbQguPuop
	0zfJtn44TyinDUWIJaCPRpk1aQKDDH2mN5MJocMcFX/XtIs0l9yJ2knjqBIqA8aLeAQtTt
	bblXsJVXvP5gkIRC0UFLEbceeIMEci0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS7u7PZ2925358;
	Fri, 28 Nov 2025 08:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=r7K+MmusZ4o93/WMmd
	7lTnGZc3T2Kx4YRqrO2ZqT4R0=; b=nXh2Hl2kcr8b1HjhKHl1BSs2togWXzey0f
	stDWGrSNeV78CXf6bf/hvc/Biu1G44FkTLq50ITM3VD5Q/Ci/vaxJlD442lVyg2J
	uasAagD68h9YNrmjAnmjqex4FnCUE0t0MXGsNDsYme7wqFGrlm382LswyhDyiA2y
	7oZE+qVU4qud54Bqx+y0DUQc9NkwifQ2zoBaAof2m/WiT3DUHXgU4XzBJwA5/Go1
	0hoRC99cEx7g3mOwOJPMZnL+OBBWXpJy7EDIenklayAWWBdTngQinMBwNOZsYYW2
	PwnkmP3mKAs2byGEUc6KOeJcWjYQ6gMa3iXvumQ028iBwGeiah7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aq3s289sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 08:40:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AS8YpNh032948;
	Fri, 28 Nov 2025 08:40:58 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013030.outbound.protection.outlook.com [40.93.201.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3md1v9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 08:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhDBkGhbASqu1MIxcNBt/xpNax5XElzpzTomPaCoJSH2PPQ+WxRubJK+hQljzOpAnUHwTHYa90mq7KXIq2elCWvYwP7kV8A8pLRDbm07YVK8JqUwQ2CkHAifRspoAztaraCAvRAmCv1qdhP7kN87wdCIwUxu4ceo3XmYGaHyzupNeLaDLt2yTSXqgx0RNZtvHKFAg43gRLXBZL7hgsh4oOaRsFQ2moQDPfqxroTVM7winHvARsbALwKIdu/JDe90dA3ApWDj/OUSxsAbpePUm+vaf0ZVBNQdspi+UORKrBFHdZlWh25rqfD7wrJ5Dka4abjQmdIMMzS1x+mVAkI5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7K+MmusZ4o93/WMmd7lTnGZc3T2Kx4YRqrO2ZqT4R0=;
 b=JgiCpmOp8PqmBUuPGPbMpdw5zWNMJTlGkXLaABxv1Ln89zKOBRz8kfEh3jSNzWVVyk0slpVXWiC881nuQXwA+fQJIAXjDt/wazb/Mtk8Na1K0LFpaSa9C5I9AIWYFA4VYttO117xKWE2a1ud2AszVcc1RwPLggH2DBtSCEj5JoOKk1Ny9Z04ojHlG12bmeMFNoghfvYP7qyT7jCCkGCQYjubDL+aWFEOAYJrr0j1EYhkhnwCuF+eEr26ZEklnuzi5CpfYJoYKZfmKbBaMcFqLYZbxV1gQA4jK7syWI5G5YUkfH0Witb0m0m3A/t1fHUXx/atn4cgo47IuUzNa5DqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7K+MmusZ4o93/WMmd7lTnGZc3T2Kx4YRqrO2ZqT4R0=;
 b=gex1EZn3jm/BLSkT/aRA9YU6ya80mzGc0fSNOrC/cil/R1vhcJFcngpTVf88Mj1dl0ytNSj/Gyr9NSEdOXtWFxteDhJjyTHAW8lh3TTnr8qwdqPJMfaUMZBjno9Ra3nAUfiTrsC5wZ3QGBrcgiJOJEyDQO8NhBYk3Sx8+beho2g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7819.namprd10.prod.outlook.com (2603:10b6:408:1b0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 08:40:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 08:40:55 +0000
Date: Fri, 28 Nov 2025 08:40:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org,
        jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@suse.cz,
        weixugc@google.com, yuanchu@google.com, zhanghongru@xiaomi.com,
        ziy@nvidia.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator
 and optimize pagetypeinfo access
Message-ID: <021addbf-69bd-47d1-a745-312efa3374ae@lucifer.local>
References: <f3dc34f1-0579-412e-89a6-20e36ec67a7f@lucifer.local>
 <20251128083437.1106507-1-zhanghongru@xiaomi.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128083437.1106507-1-zhanghongru@xiaomi.com>
X-ClientProxiedBy: LO4P123CA0412.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce78846-2c29-4543-b71e-08de2e59d870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d94RHm9kGRoxr+YPivRnU9Py5DOxytwd7q0W9jHb9pvY1DsfCQu/LQXmrI/w?=
 =?us-ascii?Q?14WhWDgZLdgbd+XQa+qZRMIY1Rg99rdwvhhmgI1CUHM0volVGgMqQ4bMyhv2?=
 =?us-ascii?Q?UoWSJ1gun+Z5NYESeNRYT6q44zSOOMLcwvOJPdzYdin/FGcwjUeZ7VDNZ9mA?=
 =?us-ascii?Q?xedHuZOeFiRNmj+90QLsKWSG8fkSbTczekcklu7CzbdVTV++Em6BfgGVqigU?=
 =?us-ascii?Q?1k13GIlKk/FjQLsE6J1zWnqNwqyd2yrF8lnWnPq1m0AYVznQ/HKpjr/QA0uF?=
 =?us-ascii?Q?HaLCMSzta4/8qldrloYwfg48a+8YRqTT7UskA/mSM+RcgMT2ESb+SWL8eDLo?=
 =?us-ascii?Q?D8LmVr/P08dwo4VgWDgVdaCq/Zypj3vEHqux2XowNCJwFiThXGcPJoozj+rP?=
 =?us-ascii?Q?ZPEI9vG/TRaqeU3VBl1eBCT9ClfKxGD2p2uXjyi/CpMZzGL3KLN2TyyVRG9w?=
 =?us-ascii?Q?NUQn5aRRb29NxpwSomODFJEhmWcRERhR4YWQYi7tlyvQCKbuvg5ZnuTPb4gL?=
 =?us-ascii?Q?FBKLUkYIAp+nlrZTuuLYTSN5a24tL1jcC/zNiy+YmnQM5zTvGTAHK8V0tMb2?=
 =?us-ascii?Q?+ETjF81moe8uvICA1fohGKFH73b6jvondVTN8jLfszi+tpkJWxHO0G8fU43m?=
 =?us-ascii?Q?WukXwH4ld5hUdnqCPdMNOolCL/f28LqZ2/bgd9iRHxhhcUYYbQCWjroDavEX?=
 =?us-ascii?Q?/bu/3TZb6IQDRs0frilFUeXuITo6t+9VHoSPQyKmNEmJFNnTm8/ehFMKajeM?=
 =?us-ascii?Q?jgdWWk9G4OuWa7G3w6CIF0tzh+MCoIlF+2nkSD3g+Jom6yTOXWivqL+/iAu6?=
 =?us-ascii?Q?XrPVlzGu9PlIskyEBxl0K4IgjxK2mEnxeZn4871Pv+eOOwuiJSplSHbsdA+J?=
 =?us-ascii?Q?V5gE8BuZ+30O0xhic/Gwt9+/aNfHiLzZEVOnEOTAJASQYYSBUFag3T9/pJGs?=
 =?us-ascii?Q?HKZT58n/i7vWOqGNYT7e3TMuIJ9qaCybtCTmiaTXRD9QHH+RFpR8/wfAJeCw?=
 =?us-ascii?Q?z4E7bUfAHpmAvRypEla6q/6Mty4zfqVgrKGIop2/D97xXThCrZEC0ROt//R/?=
 =?us-ascii?Q?dobWsmQdnPZWYnwEeQ/FR8m+BJEKwCcTFl63X7CFGGDAz57D1de74G84V+46?=
 =?us-ascii?Q?ztYeLbYznsxqgo5iRF9HVQ1dRM8ameca6xHOF3Sx59REjBK6uJpDxNw51HEc?=
 =?us-ascii?Q?x/Q3ShoVxpNL/RydjOz+0BGYyrgjr5Y3aBkuJ4Fg7N9kHU92shbejsmuQ2uR?=
 =?us-ascii?Q?m/NkVxK9Io9sn8ch4FX4LB4ZM3AkATqgFLSSabodmC4egatkAdYvAi/FdmbI?=
 =?us-ascii?Q?c2c89LlwShV5h/STb5E2qytfxr72cjfD5GsWO00fvFM1aC7dAjDSm1i9xsb7?=
 =?us-ascii?Q?dii8/kjBWOPcDYKINo7ZNhvxNNwbD0it7C6N+VrPkhKuZxhiRWrP2a+GKLxa?=
 =?us-ascii?Q?3DkMm98BuqR5WvWh+hJ6EDmTvh4aDMnu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xnXQwABtCZdfJ1oCNLw/IzWhHby6+OtP7vGvx+f+NNnqqW+hyrHfLEWNicZ3?=
 =?us-ascii?Q?XVml5OrQaRTuKwkC2HFgKD5ONdcgj948jPEnX9gmePKFR3xsxezbqS90jm13?=
 =?us-ascii?Q?zbVZEud0zictio0k+zbtR9IbRFQkaOnJPPyuAiNuMdwVXq1TpBadS5eD3wAt?=
 =?us-ascii?Q?e18U3jnIxLyA4cKdUjp7pv0/fgLzSp7+PLY5uL9cEfjwWEtIqSwmt4kVmMeZ?=
 =?us-ascii?Q?/+Pu2by7Vj0gJlMnc0OZWELwXjuFyeF5haq+IhKB4J2yu0V9AnTVpYgqorRg?=
 =?us-ascii?Q?D9pAky7y3QxM9Nrpa4MqoaMfHk02TXgHInZwFGukbUm87cWkpovwoeuZOhf9?=
 =?us-ascii?Q?oeuCHgnGJ65IetMaDSmtZz/Rc3nlz8LYhaZUzKAgM1n8RqGISepWQqZw9lFY?=
 =?us-ascii?Q?Q4u2wWv7Ir2N3cm5rntPRHOZgonjNEooYcW6N2x37NJLqP+N968tER7Ylj+U?=
 =?us-ascii?Q?s6IK0fuEmhC66OsSiiGs6QsjisSOhGH7GLDgIr2LhclDMqCDd/iuYia9Ve8x?=
 =?us-ascii?Q?pfa7+0ut/kLPgHqU7+qj6cJVVJo2B2Iid2bXq+eDTZDRYZ2z+SKh1ULGqMs6?=
 =?us-ascii?Q?jwqRCLO44dxByHW81cJJye7+P0hVLPYIAy+aqTifMm7jEOWCFRAjJ+5fWFfl?=
 =?us-ascii?Q?XYDviDQ95pYBa7Q2s8TumXr8zEPj/Kmah5uT9TMQN78F8UqGoKPzvSSt/nzI?=
 =?us-ascii?Q?PGuClSfbP82Nil8Q9Q4en0WoP++4eoFQugFb9SypfsWywGAPZzYXQ+excF8S?=
 =?us-ascii?Q?8IwEwtLJhlpulYEERGz3j8K3Ahr1EucQ9OBedF6pq/tPgvhw5eOSCP7HviGI?=
 =?us-ascii?Q?AaZItlhsPREeCYT00phPiNyJjnZmWcclW0IL9FtxGxih0JdnaojYdA6XyLHh?=
 =?us-ascii?Q?ei2oPytFsMQp4zNHSCy435h4zwUVooyFkNFOgUdFgwCU0WhD9541NtMg8BMj?=
 =?us-ascii?Q?j5IoVCPrsMSvx6IbmdRNYeOOOobFM7Hsa3ObBTUEnqLE81fcjGexY4+AudMm?=
 =?us-ascii?Q?HVonvGpdw+R5YTPxC9bzddGYGUSHJUAKulkdLgsyK/vQURnFiKhgnjabtAcM?=
 =?us-ascii?Q?37Wz71s4RiJlBDyzzZT5nm+7Yxqtm+Pws+QFzwWLU7+nY1fi4zUHWJzZgovn?=
 =?us-ascii?Q?i9xea2MV9XLjHTzP+ILKgt16mwWbQXH1nLAyuRvzHKYjWt7RVm5fEShIgcnX?=
 =?us-ascii?Q?dDQDpA9p2xinaTiRJQsJJDUMlWP4nkIN30GcLQgvtOvZ2/P9idaMuDaG80c7?=
 =?us-ascii?Q?DxOHusQ0wWExmsPYe+m73vAhSQCwMhZvH0IWAyna+L7fOiIl9fYdAGqEWgGq?=
 =?us-ascii?Q?nlLqXPswvt+ZXwXKsis541NefkqcOv0PE7G1gM8Pdsj7Bb0BzImP5ps0W4yr?=
 =?us-ascii?Q?Pvlwmlk43+0JeCrj2lRwEsfS23Kivh4rzg3cVFvBhyraCCJZiZm9yy+vTeuw?=
 =?us-ascii?Q?hEE6aa5Csigswr4GggVhWiEzYHDiW+8ivH+31Vsvbm8/yuGUAg+QlMT8oxNN?=
 =?us-ascii?Q?R3L/EGK1vkvL144Fu2R2nNfFEWc9Q9a4v+r/R5h0tBXl56gicUs1d6XygjF+?=
 =?us-ascii?Q?f+DKqtSGL5mlHb/yunNLcv1r5wWjHbH5eAeNSbMnNwDMMTGuaBbKCCdO3qZH?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TD31PRVBuQlCpkTQebSu/yvBZi8kZt2//CdQZ109fIEB8PwmikdVXiFl7se3LfSwqV5IVAPRy6OgHjw9OV8Ok3Aourn0tidRiPHqPmw1QzbNmKEk1+HPGHvypxteLYskKys6oihBPwoitZP/QSZxaJzKbQASm9xOeyv+i8Hg3OkmLRo8ZNk0SEdvwPNrL9usQ2c3hAwR0Y9H6iyQFuwsQ2rfce9U4H0urmofjtBtClKV5Qo8JdYpV0MUD8sCiNCx9zjX7zR2cNxKtIve+GxXEH+nT1gSl/Vai1o7coKtq5duHEKnGnUd05MUbKE9rgTq81ynuJ1/gqpLEfc1Xd72EimFtQZlMDQCzehmuh9LDL5Jn9BadJRU8v4iPSK27Qk3FnbBU8qsgM45DxiAaW6c24XsC0jxVgl8GgpMfUGwCKMx4c2F+V43BB4MoPkxMTHmTS32QI1GgYPzd6ZysXcZlvqTZGis2/roxEP9/eVMwx2YEOs8jV9q4rkw+vzzUh7RpLUgHlO+xqXvSWHdHxSVkwuiEUiAawkJNKnSAoZvbzw5FLqZDK8Tdn7/2xJ7Wq4EkFx6gwmqgZWlHaRogquPYhWyou+pWVFLJijQj3LvsbQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce78846-2c29-4543-b71e-08de2e59d870
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 08:40:55.2065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+v1sHwGEg8+uiJhHFH5/Kpl5cyd1x/BLckyw3SPG3yc2SXi9e/CFiLrOs/LwUH4XFfaqE13uSBNVLP5/ZynLi/fFyhMm8vrFwCNjV+UQ3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7819
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=969
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280062
X-Proofpoint-ORIG-GUID: 5HiqmAGpBwYkVOPwRoSpqluumPE8PLBe
X-Proofpoint-GUID: 5HiqmAGpBwYkVOPwRoSpqluumPE8PLBe
X-Authority-Analysis: v=2.4 cv=SLJPlevH c=1 sm=1 tr=0 ts=6929601b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=dKzH0OMtsvbIfJnRCEwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA2MiBTYWx0ZWRfX4gg+W96OplIp
 IUaVSoZ783tGkCiX9PhcFw3T3O/qAr8VWVhKvBoE9/5yrAnNI+jCLTiuwxG3Cz8O3hZoBxt7geh
 icEtw0yBltQ/Vz/vRoKtFu2n82UHhQ25sNS6VfuKpHnPfqGX8thkheZ0k2eY5NHYXJtFMDigews
 9i+ldG9CWf8lIDtUk7IdZnBIa7h1xOCJFSnF7+3hyoyr8XO1BqlGV7wiDktBjQd82iBLybMujkm
 L1GzmxYwMrAHx3hKVJs9pUbMsIUJCYOkiViQGnJiyQdRVcu4LRuZqrVLap263NY/yawQLOOZ3cG
 DFMTzR0pKdOw51sdsT5kBC5MipCKLFsGZrNGhxlL5J34grSZ+S+LCuH8SOcdWMgE8eSyRb6lYUG
 JyVj4Qh/WFlbnYvcj8moYt51lzh3oQ==
X-Rspamd-Queue-Id: EEB5140012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: inci1333hajsjahaj31s9if1g5z1akjz
X-HE-Tag: 1764319264-595090
X-HE-Meta: U2FsdGVkX1/q+EmBvEdJC5EqoWWFki0eUxtRvmM5ysCTshsJ7Wghsz0BAhvIVC3CJ5+ZihooJsb2G8ZW8I+lPRLDKb2HSl7ZJTAKxY9jDsUSlnCKgFAUbnudQHe9FxgpjZjaRKrF6783PV4I8KhIlMX93YTrXEt1/i8Oc+XyX/SWfB/itFxDsbKkeDCFqaJ1EDCFiXmh1Db3RwG6ABHx292U2G+QsfugHBuzk5+LZOtgcqGJJ3mfIJrIsaejPYT4d4E0UrPrLJkzSAHLgxh0ap42zfY/7szBm791P3QnwByc1Cycet9a6hsOpCkJa8X3pHECUbCeYFtioy+SWV7tOR1WZG0tMSxfZQS/eOSjYijkw6jSgxZYs55qC4LnOzXA+clHxRvdkpGmlsR50LDg7oc7JNq4btYGnUFGDIt1eTpW3Y38s95f+wyBAOr0pLc1ND4Uswx+VJPwQl0/yLs2+2JlCe/sBx/sh38gA+6JHxT6iFcIHzzR5nRBTcGUMFZBszjlQnZZjCsA3KlxLZoWVSbNl2pihEmpsOirOpiPBL3Mo55Y7d2dJ23bwP61ZWOtzvySCTY8N+HS/cXkxOdU2wr7bi0U3caoHGxHnm5fja24lNQVA64AY1ymMWQ/0EprWh8d/a1mp/+w97xIG62NzYN4w2PBnqMighlEPnQIOqUimpjuFYXCDO24JrP1OgJ7oB9eqw/IeTtkjdlWXn3hESE94qWTVF3NUFYvPDHIv9FFK3EWIXicPY/d5vD2CH8K6sAZGNIVEI3nVwucJ217l5TM0XxzWzl0GXCzcGAUzStK9pfvhQprKND0Z7W31a2rSz6F0brnW6gwOWlaB8WjCt1sFCsnIcYHO89QJImEBs676sAmHe0t/JY44nxxRym96bkZYNX7PXvsVfkvU0dIMj6sHW0yo9jlO9uwmQ+l8eD5nncysCg7UBriHYCJ2WbmVY13QQjLukr9DzODxNI
 BTRutxFP
 F8qfC5Z9GnprAVfCw7g8cbl5oJ2YX9Rqn77qqAl9IHjTKeSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 04:34:37PM +0800, Hongru Zhang wrote:
> > Just a general plea :) could we please try not to send larger series like
> > this so late.
> >
> > We're at the last day before the merge window, this is better sent during
> > 6.19-rc1 or if now as an RFC.
> >
> > Thanks, Lorenzo
>
> Hi Lorenzo,
>
> Thank you for your feedback and sorry for the late submission. You're
> right - this series should have been sent earlier. Apologize for not
> following the proper submission timing guidelines. I'll make sure to
> follow the community norms and submit similar work well in advance in
> the future.
>
> Thanks again for your patience and guidance.

Hi Hongru,

Sorry I don't mean to be critical here and you weren't to know :) rather just in
general - a plea for how we do things in mm.

Your series is very much appreciated, you didn't do anything wrong at all - this
is just essentially an admin thing :P

We will absolutely review your series it's just about timing. And of course I'm
just sort of making a point here, reviewers can choose to review as and when
they want! :)

Cheers, Lorenzo

