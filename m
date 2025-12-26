Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA848E8FDA7
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 10:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060BF6B0088; Fri, 26 Dec 2025 05:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EC06B0089; Fri, 26 Dec 2025 05:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDD66B008A; Fri, 26 Dec 2025 05:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C67836B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 05:02:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E6A6140EEC
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:02:02 +0000 (UTC)
X-FDA: 84261181284.22.2D9499D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id E002E40010
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:01:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W+pZXj39;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jpjs6DBa;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766743319; a=rsa-sha256;
	cv=pass;
	b=dfjOQZZazLmqmnHStAlB1JhA1GipaEO5Dr/nQZN2zmpGX6EwLZuhq9wkjxO/yd30HOG2dg
	5XWyiIOxPdqkGpmHN/4FY/zU1C8okCjgdfmksodbpslbaxSKG/AzpWuO2WFTeJU558MCMa
	NhxxoWE8W7kFUleAEXtknycCvQ4gSe0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W+pZXj39;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jpjs6DBa;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766743319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubeQu+7tNaH18x1sBqYsF11BrNV/N1HZWBNsMk8Zz68=;
	b=b1nQ8EDiClzl40XaOK1bj/luGECshmPCfMWkf9gNgVs4hPaMD+I8e7cnY35wzlSxAhYRZg
	Dhf/BOSPB2LCD7a9GVEI63l73RXxCur9ko4pWsXoW0YsiiO9/vPRPHMM/3y98hO+BUj7s4
	Ph8ssD6mIOBSdvVru4EDwWcsiDJGEEM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BQ6QDaH2782077;
	Fri, 26 Dec 2025 10:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ubeQu+7tNaH18x1sBq
	YsF11BrNV/N1HZWBNsMk8Zz68=; b=W+pZXj39JxGd9onOQIOwHpmA+psg0JxIIS
	OGeivG1Iu8hOJV8PpWYBIV7gutS2AQRfvgHkzfgy25wCnyKQtaIgYIxvikfUwHzg
	gu47Gl1Z/G/NUjnB6MrGypZsCPACEjDv56/iCVbdAB+7h6mZSViBZNC1bAaIT1+7
	2Qg9H8YRRiM2RgunxLkJTvDiRuonek+lE+XYL5B/ykET6hvcH3XKZ+dM1GWupcaS
	5Nho8lwLRRoZFLpYS6PfBg8xydPnDHwBcPVGlA2Yp6d9anZ3IMbrk9O7PcGyr7py
	PZ2uimXOgw0UvnlvYQu8Erllf/IsypHVByO3E4tOo355Wo1MtLVQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b8tdk0v88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Dec 2025 10:01:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BQ779oU002591;
	Fri, 26 Dec 2025 10:01:51 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012006.outbound.protection.outlook.com [40.107.200.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8amg9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Dec 2025 10:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOrh0mKmz8Kzrdzd0n167Yt36pdgadHd7xrkxLKPYZ87cp2QNfzQzAQl529bpmYLXluCuJzpPrnP6Tctmy90RrlUu8fGURVGcBuJO/Cl08a0RG+UTA94HV4VKIQZ4WJp1QdgEOxYnJFDTitdWcdfsZ/div+x8nrrJANd1/PwSjsFjw2sRKHt7GCWN0awGM1D1+oxtqDmt68bIYb4Ch7M6nEtaq31lBe5eJNZDrRXWL5xxKh0nqVxP+r9+cxNChYjnr0L9xizTgaiNWL9U4jz76BCzR9eQ97uM65cTBkdMZ/BDsAtjdyJFRlsV2KpipgYxL8Rga4bivHd/230v87gbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubeQu+7tNaH18x1sBqYsF11BrNV/N1HZWBNsMk8Zz68=;
 b=wkvCyLCZnLmHPuOo8n9VsyNRvHArDTH7DYTzwjVox9h/B004pNgvfY/ox75GZh2KJNnNvl7LK0K5bdkhyk+pYP7k0AKzHtvAEeUWtZiRRGRhO0iHkbwdasZw43N2X6FfDTLotLj2eP2GYt0ezq0PeRdCfWq/1hDpGqerK0pk6SvM/iu9zCMEsgPuhJT+Y1cTAXaONJaqFpdig1tD2ajf+e8+DarIIIkHQfX8g6aWwltpgS183tDIjZMSVcpJTarcNIeY6H9d9dwvmZAk3jTaCUQ930XmrkDAO3zNOjq/XoDrxQyErCIU25Wbn+w+HtQe6bpdC6IpMnINXpIt5ejz6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubeQu+7tNaH18x1sBqYsF11BrNV/N1HZWBNsMk8Zz68=;
 b=jpjs6DBafojPwaRmpmmIF+q5PTcBakt5qHUpC5pNkplPSOiY3WHEgR9TJDWcd7bqb/PlCWjFt0v6lr1DWW+uW76IdC/iA7baoMhHALIc/Oj0fShFYYfnqJH08l/v7DnNHh/W2vr4yL18C6NX3/pnyCj48VR4LGbEdNlA2TFiDdQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4198.namprd10.prod.outlook.com (2603:10b6:610:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.12; Fri, 26 Dec
 2025 10:01:49 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 10:01:48 +0000
Date: Fri, 26 Dec 2025 19:01:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 folio_remove_rmap_ptes
Message-ID: <aU5dA6qq-h-0XszI@hyeyoo>
References: <694e3dc6.050a0220.35954c.0066.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <694e3dc6.050a0220.35954c.0066.GAE@google.com>
X-ClientProxiedBy: SE2P216CA0140.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f44a0f4-3b07-4d9c-17f9-08de4465c886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m8DwjTIB1T8YmJHeMmIeclE8O8vQiP0lQMxbMT6UmTJac3rRJuIc7Dka17ud?=
 =?us-ascii?Q?Oc3KLJESgMVmHvOloh3NeQgAAAbfn6ONqU3rtvcy64X3UaO1UiYvLg4LdtuQ?=
 =?us-ascii?Q?ZdntJ6nJUrTXzCGqufj+I5fdch4VEMQHugACBtNEz6s+2HINYcZ3NnQ1nrrb?=
 =?us-ascii?Q?JPilGZdqeCuCuwoSw6bMUJeQrUKpeiKP6dsrXm7E5/Plwqr6PEDWwpuWtDqM?=
 =?us-ascii?Q?dUervIEKO17aQO6QYAey9S6IWoWcy8zPjbv9FGj2pnDDTQBqyeb5gpsNkdJK?=
 =?us-ascii?Q?PcWya2+aL6BWjwv7/oC7NUozAnDO5XiyNdGtdXRd6Bx7Xemu8jKE/gjKMnEm?=
 =?us-ascii?Q?EVxPBOJyAoHP/9OgUadNuEL3anAKD/EJGYKPSfEzSUUXLxvdxVl8uzBLbS7P?=
 =?us-ascii?Q?deSP5YRmDabQj8Bi+lmfV38lXsjcR6Kq2F3/qRFwu9N/q2KJK83gFhOctSff?=
 =?us-ascii?Q?rn3G1NQV5f/B75Ue9Wduxlc1KaTaLMuh+1HgRWl0I0QZ3k5ihW4vJfMaJLvW?=
 =?us-ascii?Q?u1bWmny+/5FVgDa+jXTW2oO7aBQSNSLW37U3th5ekyQWUC6KPh89kAqloWgF?=
 =?us-ascii?Q?ai+SQIVijn6QjpHnpPjo7JSGJhspCu/rbXMwP/oo7eyhkMo9UEpGec3vhcyn?=
 =?us-ascii?Q?KRqMicSwK35JuM5E+fNkXlVh2dTTRVinr1TaQAp0Dup+n/B0zqbtjHW3c6z0?=
 =?us-ascii?Q?Pkz8tx19bkpDEgUAjZ524mghMpxBhJwvkZUl/ZrWIUDBnHBG/X7KJ2RgIuEk?=
 =?us-ascii?Q?b7Sre1l3ptXkjR0NvgJH9PykmvXrNWvtIo/MY78BGAuDpLVnzZSYnsMmHy+1?=
 =?us-ascii?Q?aZ0MMdl5UypCQzudE3I01NpItpwH+dJswFoQwPhzSHKVb4geXQ466+rHOmL/?=
 =?us-ascii?Q?kWF9LjRvgd8LYXqfl0vF9Mk/4d1RLo9FIDmw8jobO6byLfAU35SEiJ1rDpdr?=
 =?us-ascii?Q?S2IaPCbWnupEIDKdC6/BgO3bBsYQv8e3ZEb/f6JTW6KFvPAdM+Np0j0HgciD?=
 =?us-ascii?Q?VeH1qYTm4cGwHhEyEkYTMFAW9191ElwrPM1uu94N6133YabRbEK4wHNS/ekg?=
 =?us-ascii?Q?pKihURPlR0emQH/ilUpbswpWdYJ5tjjablEO377BFUT6yeoGAEVQBC6tCDAd?=
 =?us-ascii?Q?BC/h7b5t9QUsAJMRbca68/JRAMDwAWLgrfEf1YIdsvDcxNP8/8Efzv0mNNZd?=
 =?us-ascii?Q?QyJ5UNBr03EZOEHy1v0QLkYkxNXtCozV6dvgDfT7oLKEJ4ChMkJ09qTH0fnS?=
 =?us-ascii?Q?DaKBrqcX5k0hYqudU+buxqsrXr4vW6VAhXoxxHaocf0lb+vc0xV6UI3v/Syp?=
 =?us-ascii?Q?Lfb7CTa8E7dMXkli6ZMBC5VpZBrNS5d/ML43/eqZbjFn6xfllNZ/ZZS5HA5L?=
 =?us-ascii?Q?3QgVRW+sLLSbbxiw76h4746CQeRL1Nl0xeI7p1Rl5FlsnO26dA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ToNVL03CdmmRdS34l0qhB1EoRbOlq5MJzwe7uf/89bIwCucuru5oPlwtq8Oc?=
 =?us-ascii?Q?cEafZvv66kUXI4Y7qoaJAvuQpB8onWa7Y/2pKKakBSIg7n1j7OALrGIPPvS8?=
 =?us-ascii?Q?GK4jI66THlJNZOlE4/0rrRzOaKeb5dyK5RJS10KQbsBTxSvshsrgFBg1HLs+?=
 =?us-ascii?Q?7c5JArvyJHylucT2jlrQYyAny9qPsOlxHbpYh5l2zqh6Lcub8UXgGgPXriQI?=
 =?us-ascii?Q?7GEadWZWsBzpVNSL1Gh5JWpZjwHR1jtbqNgKNHtZ9AwdER4lyA5Bl2v3OAHq?=
 =?us-ascii?Q?xmb92GDSiV0VH7y5AFTxhh/x8qjeq8l/THFsNZWuqatn4n6u7QvVak3XEFzs?=
 =?us-ascii?Q?66/9482Oj+FEz75wonbXm9rjb9kBlg3GQnHfgvkqo80iWCRkiyqlKovddHCs?=
 =?us-ascii?Q?dr+V8Bdpv4T+3TQrFWEsMv7+Fqyz+hr/wM135ZBrOvX11NkK6tNu/U4Ea+jd?=
 =?us-ascii?Q?Y7UiN98n1rWWmLehRWqMd+gurKkxbut1PxYCy7zgCu0JJZnUxMtzx0+yRBLB?=
 =?us-ascii?Q?+a5LpTSOCgp9K7hIIiLbkdumSSFgSWrDzcFpqQUh5fy2NYKSd6czMxS5CXiR?=
 =?us-ascii?Q?iHfcnTdY7/fY89fYNrjrDN+ZmDet3bsUEY7EQ5noYGT7HxYXks+FlOkGcWY0?=
 =?us-ascii?Q?d5YF3jYS2EmCrijEMza8bmCyG0ua9hepEJr9eJcgroyfXNiIpHlx0XEsRKWo?=
 =?us-ascii?Q?NtQ2atvqNmmMaisTOMmnF93MgehOkSIQSZSEz4vbQDy3iUKmUy1J3ZxHJoJ9?=
 =?us-ascii?Q?l99tmpOExiCuws1j7HeLABxIkeqtZ1tJMEz7jwHbWDCt2GOVXDsJxnjczYNB?=
 =?us-ascii?Q?DNWVOHDh3Q1UNm1Y+DI1AAYgbAbH5ztlFXN/supFDE5vt2+xTwsnxloD/Td8?=
 =?us-ascii?Q?U3sZ+se1oQMzc4uIDSo57npPqgTy/GSZGT95p02vcxgg2hKN0dva2o1tEPjv?=
 =?us-ascii?Q?X737ubb7en7ZbaP3u3B8MjaiSI9PnWC5jgqWw8ohQGoSbJI5qIipKUbDwOBH?=
 =?us-ascii?Q?INvpw7FdiCUAyGo4pJ8muzGeJZgPhCfQp0e9wnOsdZWOkseSmdY3fMmoL6ig?=
 =?us-ascii?Q?8sR2Dg0gqtEvTwqAzNkDsFm1reEvvyj1N90iwHwFxI6+n2rN1WnVZ12RIiK7?=
 =?us-ascii?Q?K0xv/5uuVPOXq5Dl99XwjK+ldlcjG+XZOsNz3JaG8T3qRA+zmu0Zr2PH+V1N?=
 =?us-ascii?Q?ORcnxP15dFu4ZcOLjMszhQPbTWeTcdfKAmRh2kkRd7PoK2HGuyr+aickDGHf?=
 =?us-ascii?Q?D0pbYvzLnBkUsDsS/5lcU/fixQzEMxazPiskjcad2rskrKZR3A5/p4O+sj50?=
 =?us-ascii?Q?dpLGnSs5t5Q4Ljm+v7M1qDxHfn7ULiLSOua9ZF9GEU+FqwU9HEIILqJRmKIF?=
 =?us-ascii?Q?t7ladtWiQpcs1hjFuEjndMCDxDiNkDAavKncDXNL46OxahJ666n2na422XWR?=
 =?us-ascii?Q?k/i3p5B/fBHwtBFDzCLEQzDJFIV5JCeACMqQRlLcbWkbngVL1Wk7pBTjOV9l?=
 =?us-ascii?Q?mF6vrCV2AJ37GeS5+olyFl7X0PU1zsNhBxaBFXY+e1kjk/zsvJvOuOCyfzMe?=
 =?us-ascii?Q?VrwaEsK3I/hYxyNZTEZlPYc+SFxVvGLKs9IeLHNO65xORXbkll37us/jcAHh?=
 =?us-ascii?Q?0mAoLXOnbsL5pRbXK+PwzWB30jtfE5S2KYinWX+qj3PCGC1hquEk3TvTsYWw?=
 =?us-ascii?Q?sL5Zdw5tWZIhdhPIRC5kRn9DZHgD0M85EIkcSwBSIXIUBOVqMWNGuPvSEuxb?=
 =?us-ascii?Q?z3n0LkgHHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WArn6cEMKDZejmUfxaCWFvC+4zSxLZPndWrN248ETOb21JVvVvaotaKgcieHqmLBPd4cD5t3SH1u8rRzDQD+1WeaN3zZEektFg+xx0PMeENNyBg5YN8GU3YO2yXBirzoAQmz9H6DXh34aZrhRjEwxiU4Y9cmnX1T43pBAHfipTiUjZ91XNNy/1zZoIKxj5N01/5SRcZr+EmegV8RhtAqetU48wBmbDCGif/j58oKHnjcyTg/WvgF9CnFSA97dQQ99AYKVKcVFjL0Z54QZM8ifg57Q54tV+HSUIqoe0yTgGjyqzWBBAc2WVaaZlq50zjEIek0O7TeBSMvwk9ZhDDXWikquW/MvQ1lBB4y6fmtz3IMgTjpMMQbfiR+vn/Xqzwa9N9zccSylORvea4Zjm0Bp5v4p1aIr9sYc8JBhPBTvTfJ97CMLn38p1fb4W1oWHPJwz0kM54KoWB4ZHa8yHzVyHP0YrDjbQOAo8fBagUyz5KU62QLzkkRP+b+Zk7uFON4UYff8Qnq1u1/DsjRyyVtcrIYMM5yBh2qZr2DdCTN2W0gKK+NLcvQO0T61j3t1NzxlSse3mxdK9DmgppXK7148XqVAJwhnbxKl/pUVPerj8Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f44a0f4-3b07-4d9c-17f9-08de4465c886
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 10:01:48.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbOQdBG5mev85BJdsH7ODcB8UOjRXVZqS+5OOxbcCqXoMg/b9e54MFiCpEyQfBjMXhGx9ALfn79lduQW88Ltkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-26_03,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512260092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI2MDA5MyBTYWx0ZWRfX9WmGl4JLFzna
 wqYwAF8EAlbUTbPZZApvjm/EpXpiJnx+OZsOzFUysgzeeFUwOOh8sEerDsoP7kRCQ1XBgwJ9uOw
 FdzE1BTCa6XBhPs1TPmtZS+jozmyBvzOFQzBUXr5CiJuu4b9TeXUjGrKSA1fhoS/ID2KIlg+c8p
 pG3XOCdESbgxRPt77QC5z0JPgpCGzZzfph6UYI8MMhsD1L7QUBUD0oYN7vOGjFKR5pNnm+mCLtm
 55kZ9/i0pc+wg91VkPhReji8xxjS67+jhS7+jxQgupsrCvFJXbULiHoTUBODaxXtZHEW10v6fHg
 kERVLlG9/X/oL/zvnR7wxf9yJPUXGqHblgKOxgBtDaUFdG9HEYZ95sFgKidjj+QcQghoUBQgtdQ
 mGBTxbCLcjH7yV60g32GeCkLTmq4zOgXDdB9sNqRwMYtUkAILBjanq40WWz6nxom62zx8V++6WN
 xMXmPD9n8GLHeRCsV7g==
X-Authority-Analysis: v=2.4 cv=Xrz3+FF9 c=1 sm=1 tr=0 ts=694e5d10 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8
 a=4RBUngkUAAAA:8 a=96rygUKGx1jIH-QAPjYA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19
 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-ORIG-GUID: yuS0cHLX2k653OdXI-6nZwfaEgAT7j6F
X-Proofpoint-GUID: yuS0cHLX2k653OdXI-6nZwfaEgAT7j6F
X-Rspam-User: 
X-Rspamd-Queue-Id: E002E40010
X-Rspamd-Server: rspam04
X-Stat-Signature: aae3spg1rj9wmg9gxnpzd93i46kjuz6d
X-HE-Tag: 1766743318-780810
X-HE-Meta: U2FsdGVkX18NCOnxm0WU3AP97rHaU9TW49JY0wpZZIJPiHHVechNamLUKampQooQzwlSllKJoOSWbIJ1Yq3ip2tZPynZkQhaHR1CY0T8Aap6pPP1SZtu+DFl4stNoRs9PGO9PTNKWboJE5KxHco58wYVUn+lSomdrOrhXJo6cr5RPm7XmiMIkgqGVlJxmX4YlupVfxFDwo4hj0/2bn5VpyNMyJqz4PB+2hVXgKpzl21yHHMMWvQm+/pSbchGObBa3w0tW23CNIZGkd4qXFZheGkFVJVU8re85oAMb8uydunloSbF3y5WkpqWJ/HRB27LGNTjYKOMb5Rv2OqLWv1yJm3lcWkiAvUlY8mrYMZwQog+xefPiq2Nx2d7w8qjtvpCzncKquyIh4uech6tXV79//x/dDVq3ZQw5VhBy8bFbT0j4Xz6O8C1fg02myQYidYb4QUps/bvfRW7CUzdVYgDrdnhKVeUu4GyHGqe3eFT0cu5RDg2M52zq3MVZqYO9G4fzlyztxVBJWal8uL+D+C4E/sE0cuifMRtqHBjvdYMrlE8JPNx9jt3GtzljbwQyFUQBwASL2efglShk2S8pS1ajhDTxZEWQtkI91GnKyeqDzPjc4Hv5jRyrglUIHbZu/iX3xjYVD6eY1fbBGW9h88qOfL88bUN3OME0vLnjVGySJROh7yy2pPya00BoA/CpU1dHNWXzNEpt2LO+Pjdnr/yd0TM71ZaKZQoDy4n9kKNjNq7ETEIyDD/qNp54TiN/kOPjoMSqVvo63DCXw81I3H05bn/M6QqzCYVJeXhvSVgQ1usmdR49Zrdav9NErfCi88+q1+gtbftRrlbayzxzWyyUnUdI497RkykIAACzLU0py2dCjvspA5befWMKqLzoXwSGQy6XxQNfD19jdCeRAkA6VKGpcmpPexnDPXbgPshtB+mAyN01+UiHrkvViyyuN1tYUa4NUoeXDvtMQTG4Io
 SCDcwRrX
 3oQ4zDXoTJfEI8Nx4NAld73cuMHeLB3eiTDyVohej5He9TvBM3IsRqgxkchUTVGqMwwTRH7MXk1ZPDutgvknwyzSFhVdKEmhjqnydqNlQjbUDtQthVobwZPVInBGgSQIkrEDO0UjCFn84MvFAbBx60R4/fm7OZAqyXCMh+yD0/QH/qVw3vg6tXsgshit9uwyS7SciO28Kktbw1pmZ9vu/is6/aarFXEuGd1U7/byU5NRGHuztMh/2PLOGFQsMCrsD43p75Z6CCywADlKjSkEsEGnjrdr2Ye4P3gnuF3m2XiLxUlDGHzvRRn0E5wEL2M/FCqqjF/oNvpr+zkhAYH6aGfgMNzE0M24BsTl6LDwfFqLhChodZtnDmU+ZZDkMS3Iovqorw2MOhpETh2ncQu7hLvKsEZv1oXZZIBwgT2YD1aPjgnBQWBArp5GrC7Gdf8itDV3pnIb4xqH9X8iwkhejhNhnCWOP7jq00RCiNsv3h15XeAeUhypGo8GjBVGshj/YqVgnFI+iUDXvLkuLFGHeWtpNMPlXRzD87ova9iT9aVb8OfNSp+f2gJZ95W2vXllXwJJprWuGFWejZBEr5GpY6bdLGAIiYLgjbnY8/KwZ7Pkf7iDvAhSsZcI5Q7I323YY0DoS0XDU/BbkadalP334sjLAb+5xFsBV6pDdNjnwl4Iu3IVufUwe7XH0muQ4gLzrDIeWT6qKL1kSe153q6GyRyFFQ30jnt5l/6eW+bPJIwupYXF0POdhHbesbxZrwtckgj/d6iAy4gFB8dtTiuny20qniPZVhf2kfNZk3US9v2AcO2nfPcCWk0+3AsmDeAZX1FbGsY5CapFPg+edCztYY+Q0NR0d1m/fSsRxJ9D31/OnFcmaXLZRz8E0Lz/SVcljjpqMgz8qqv4UGh8NKULyCPG7uVA0l/GkpTm+6VHJJx40UxETSPiccpBDs8EL6JuGTcW+VPAEdTxFd5k5M95xvJcRJW2R
 i0n7zDYo
 46SN3urNWhc7Yw7zbC34q5JwgztWtFjo96RO2K2qjR/S4pIcMedd4dEKH2PCgKtfz5/qucVSm6ifrN8V3P2rapi5nRRzDo6pMpuKFyo0lct4+MVTu3ysu7c0osNFjACuSi2iWpCuoEDF3KBacj4CvnJCxgokOih74h9JrgGPy8KP5PHgRW/e48mVTtRdoGEEe/rX5bLlrGk1T9Heu/gA1TmdyDPjSTGTk7hk4h7O+fVsWEKTqVzgfMTwMMqIPZl6Ix7YtKX/VM/vVMsUUa11lyFVx/HZA4QSthbR5WC7kXH8uiKkdMH/vxh+4LYJJ+VIsau9MyTp/HypogE1ToEwZSHZ/ysiMgiqsQx0gU0zRY6wdMqlgq7OR0W4JUbiEZSGTUl6sqwVA7s5SBJ6Tp1czoxBWOltwsNF97emdp+LwSZdpKNCdf8mhLK+ZT9AsC0rYgrpdIUgsK2d0A0KfJ0vlLUglKaMWxiWfK8hB6cgZUTUBpY9/CnaSVPwCd+4wtc4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 11:48:22PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c4db1a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
> dashboard link: https://syzkaller.appspot.com/bug?extid=5272541ccbbb14e2ec30
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com
> 
> uprobe: syz.3.982:12970 failed to unregister, leaking uprobe
> ==================================================================
> BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: slab-use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> BUG: KASAN: slab-use-after-free in __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
> BUG: KASAN: slab-use-after-free in __folio_remove_rmap mm/rmap.c:1663 [inline]
> BUG: KASAN: slab-use-after-free in folio_remove_rmap_ptes+0x245/0xfb0 mm/rmap.c:1779
> Read of size 4 at addr ffff88802407b1a0 by task syz.3.982/12970
> 
> CPU: 2 UID: 0 PID: 12970 Comm: syz.3.982 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xcd/0x630 mm/kasan/report.c:482
>  kasan_report+0xe0/0x110 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:194 [inline]
>  kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
>  __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]

Hmm again, anon_vma with refcount == 0 was observed while unmapping a
VMA. But this time it's reported by KASAN because it's UAF. 

>  __folio_remove_rmap mm/rmap.c:1663 [inline]
>  folio_remove_rmap_ptes+0x245/0xfb0 mm/rmap.c:1779
>  zap_present_folio_ptes mm/memory.c:1650 [inline]
>  zap_present_ptes mm/memory.c:1708 [inline]
>  do_zap_pte_range mm/memory.c:1810 [inline]
>  zap_pte_range mm/memory.c:1854 [inline]
>  zap_pmd_range mm/memory.c:1946 [inline]
>  zap_pud_range mm/memory.c:1975 [inline]
>  zap_p4d_range mm/memory.c:1996 [inline]
>  unmap_page_range+0x1b7d/0x43c0 mm/memory.c:2017
>  unmap_single_vma+0x153/0x240 mm/memory.c:2059
>  unmap_vmas+0x218/0x470 mm/memory.c:2101
>  exit_mmap+0x1b0/0xb60 mm/mmap.c:1277
>  __mmput+0x12a/0x410 kernel/fork.c:1173
>  mmput+0x62/0x70 kernel/fork.c:1196
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7d7/0x2bd0 kernel/exit.c:959
>  do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
>  get_signal+0x2671/0x26d0 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2c0938f7c9
> Code: Unable to access opcode bytes at 0x7f2c0938f79f.
> RSP: 002b:00007f2c0a231038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: fffffffffffffffc RBX: 00007f2c095e6090 RCX: 00007f2c0938f7c9
> RDX: 0000000000000040 RSI: 00002000000003c0 RDI: 000000000000001c
> RBP: 00007f2c09413f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2c095e6128 R14: 00007f2c095e6090 R15: 00007ffd86729c78
>  </TASK>
> 
> Allocated by task 12971:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:339 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:365
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x25e/0x770 mm/slub.c:5270
>  anon_vma_alloc mm/rmap.c:93 [inline]
>  __anon_vma_prepare+0x344/0x5e0 mm/rmap.c:201
>  __vmf_anon_prepare+0x11c/0x240 mm/memory.c:3673
>  vmf_anon_prepare mm/internal.h:432 [inline]
>  do_cow_fault mm/memory.c:5775 [inline]

The anon_vma was allocated during CoW fault on a private file mapping

>  do_fault+0x18b/0x1ad0 mm/memory.c:5891
>  do_pte_missing mm/memory.c:4401 [inline]
>  handle_pte_fault mm/memory.c:6273 [inline]
>  __handle_mm_fault+0x1919/0x2bb0 mm/memory.c:6411
>  handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
>  faultin_page mm/gup.c:1126 [inline]
>  __get_user_pages+0x54e/0x3590 mm/gup.c:1428
>  __get_user_pages_locked mm/gup.c:1692 [inline]
>  get_user_pages_remote+0x243/0xab0 mm/gup.c:2614
>  uprobe_write+0x22b/0x24f0 kernel/events/uprobes.c:529
>  uprobe_write_opcode+0x99/0x1a0 kernel/events/uprobes.c:493
>  set_swbp+0x112/0x200 arch/x86/kernel/uprobes.c:1090
>  install_breakpoint+0x6a4/0xa20 kernel/events/uprobes.c:1170
>  uprobe_mmap+0x512/0x10e0 kernel/events/uprobes.c:1629
>  vma_complete+0xa09/0xe80 mm/vma.c:397
>  __split_vma+0xac3/0x1050 mm/vma.c:561
>  vms_gather_munmap_vmas+0x1cb/0x1340 mm/vma.c:1362
>  __mmap_setup mm/vma.c:2366 [inline]
>  __mmap_region+0x47c/0x2a00 mm/vma.c:2690
>  mmap_region+0x1ab/0x3f0 mm/vma.c:2786
>  do_mmap+0xa3e/0x1210 mm/mmap.c:558
>  vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
>  ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:604
>  __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
>  __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
>  __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Freed by task 0:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free_after_rcu_debug+0x10c/0x300 mm/slub.c:6729
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0x79c/0x15f0 kernel/rcu/tree.c:2857
>  handle_softirqs+0x219/0x950 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
>  sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1056
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> 
> Last potentially related work creation:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
>  slab_free_hook mm/slub.c:2501 [inline]
>  slab_free mm/slub.c:6670 [inline]
>  kmem_cache_free+0x15e/0x770 mm/slub.c:6781
>  anon_vma_free mm/rmap.c:136 [inline]
>  __put_anon_vma+0x114/0x3a0 mm/rmap.c:2780
>  put_anon_vma include/linux/rmap.h:117 [inline]
>  unlink_anon_vmas+0x58a/0x820 mm/rmap.c:443
>  dontunmap_complete mm/mremap.c:1265 [inline]

And then (potentially) it was freed due to MREMAP_DONTUNMAP.
If it's correct, now we know when the refcount has been dropped to zero!

In dontunmap_complete():
> if (new_vma != vrm_vma && start == old_start && end == old_end)
>        unlink_anon_vmas(vrm->vma)

It calls unlink_anon_vmas() on the old VMA if the new range is not
merged into the old VMA.

Hmm I'm having difficult time understanding how the commit 1583aa278f5
("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
is supposed to work when the new range is merged into an existing
VMA (that is not the old VMA itself).

The merge will succeed only if the other VMA doesn't have anon_vma
or it has the same anon_vma... which means we're reusing anon_vma
of the old vma, but we're calling put_anon_vma() on it?

-- 
Cheers,
Harry / Hyeonggon

>  move_vma+0x14de/0x1790 mm/mremap.c:1314
>  mremap_to+0x1b7/0x450 mm/mremap.c:1416
>  remap_move mm/mremap.c:1890 [inline]
>  do_mremap+0x13a8/0x2020 mm/mremap.c:1933
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1997
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> The buggy address belongs to the object at ffff88802407b100
>  which belongs to the cache anon_vma of size 208
> The buggy address is located 160 bytes inside of
>  freed 208-byte region [ffff88802407b100, ffff88802407b1d0)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2407a
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff888021c50001
> flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88801b44dcc0 ffffea0000f7d080 dead000000000002
> raw: 0000000000000000 00000000801e001e 00000000f5000000 ffff888021c50001
> head: 00fff00000000040 ffff88801b44dcc0 ffffea0000f7d080 dead000000000002
> head: 0000000000000000 00000000801e001e 00000000f5000000 ffff888021c50001
> head: 00fff00000000001 ffffea0000901e81 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (init), ts 24478689872, free_ts 23304373426
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1846
>  prep_new_page mm/page_alloc.c:1854 [inline]
>  get_page_from_freelist+0xd0b/0x31a0 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x25f/0x2430 mm/page_alloc.c:5210
>  alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab mm/slub.c:3248 [inline]
>  new_slab+0x2c3/0x430 mm/slub.c:3302
>  ___slab_alloc+0xe18/0x1c90 mm/slub.c:4656
>  __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  kmem_cache_alloc_noprof+0x44d/0x770 mm/slub.c:5270
>  anon_vma_alloc mm/rmap.c:93 [inline]
>  __anon_vma_prepare+0x344/0x5e0 mm/rmap.c:201
>  __vmf_anon_prepare+0x11c/0x240 mm/memory.c:3673
>  vmf_anon_prepare mm/internal.h:432 [inline]
>  do_cow_fault mm/memory.c:5775 [inline]
>  do_fault+0x18b/0x1ad0 mm/memory.c:5891
>  do_pte_missing mm/memory.c:4401 [inline]
>  handle_pte_fault mm/memory.c:6273 [inline]
>  __handle_mm_fault+0x1919/0x2bb0 mm/memory.c:6411
>  handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
>  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 1 tgid 1 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0x7df/0x1170 mm/page_alloc.c:2943
>  discard_slab mm/slub.c:3346 [inline]
>  __put_partials+0x130/0x170 mm/slub.c:3886
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x4c/0xf0 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:349
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  __do_kmalloc_node mm/slub.c:5656 [inline]
>  __kmalloc_node_track_caller_noprof+0x30b/0x930 mm/slub.c:5764
>  __do_krealloc mm/slub.c:7014 [inline]
>  krealloc_node_align_noprof+0xfb/0x3d0 mm/slub.c:7073
>  krealloc_array_noprof include/linux/slab.h:1034 [inline]
>  add_sysfs_param+0x19c/0xa10 kernel/params.c:663
>  kernel_add_sysfs_param kernel/params.c:812 [inline]
>  param_sysfs_builtin kernel/params.c:851 [inline]
>  param_sysfs_builtin_init+0x307/0x4c0 kernel/params.c:987
>  do_one_initcall+0x123/0x680 init/main.c:1378
>  do_initcall_level init/main.c:1440 [inline]
>  do_initcalls init/main.c:1456 [inline]
>  do_basic_setup init/main.c:1475 [inline]
>  kernel_init_freeable+0x5c8/0x920 init/main.c:1688
>  kernel_init+0x1c/0x2b0 init/main.c:1578
>  ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> 
> Memory state around the buggy address:
>  ffff88802407b080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88802407b100: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88802407b180: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
>                                ^
>  ffff88802407b200: fc fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802407b280: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ*status
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

