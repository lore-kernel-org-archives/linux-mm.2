Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C493ECFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35336B0012; Thu, 27 Nov 2025 07:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C3D6B0023; Thu, 27 Nov 2025 07:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4486B002A; Thu, 27 Nov 2025 07:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C94AF6B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:34:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 862D8160122
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:34:24 +0000 (UTC)
X-FDA: 84156330048.03.FE0FC40
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09BB5180013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:34:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qLmbk1SZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PsOg9QqX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764246861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYACKn/urmbDhyxbsePtBjDptkd8CkidORoMDM0MHkQ=;
	b=L3zXGUowzIucHUMRoMEwNUYQcQ/ayhnxX6WDQ1/PVX2Nhc6b5i3/xxXjpCMlJ+wesmQJve
	3h91OZlFXtuZXk0V1KIFhBHBdkorkhIyq2XroY8lt7vrT6v9JqGs879/k1In8RFNFA4v8j
	jIC1stbwlvN3XeZbHUWqbAUn5USHZzA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764246861; a=rsa-sha256;
	cv=pass;
	b=vV1qKB59quxfPM47I4HvKH4S+2P0cbwoveXUrwd3WuFteoJAPN7fQ87PoiYy6XJbindFph
	SEn43kMSMlGsVrasvpFYtUUgiI1K+agf80Wyz8VPFf/Z9ZXowJAEiuHCWJWBTtOi6Oc3Kp
	2iTYeepb2iPPTKqDIAAvmP5/xJ5sQ+I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qLmbk1SZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PsOg9QqX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR7KEwS4135233;
	Thu, 27 Nov 2025 12:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SYACKn/urmbDhyxbse
	PtBjDptkd8CkidORoMDM0MHkQ=; b=qLmbk1SZdDXpWXrwuBnT+105FUr4IXekZv
	Vut84AMyZcQNGAq9iwCs19VjI4LX2Ksj48Iu49q2b8mz32yqNSgyjqN8kvX+v2+0
	h5//uHJhVkgl3mMO7rg5KYGZGrjs2YwX4XvlSlvelJKhXjTZ7vD0Bm+fKiwroXUZ
	4e/ZbVpA7xjh33H+WjZHWa3AGcj5h4db9OdvgtLJKVzn8rVH9jJ2Q+dt/IEQXG/Z
	KArGZSfUBU6OTlkITH5qw62BLHX6dSJc8IeZLrxw1DHpsGLsRgnY+oVDliy4PXqj
	vZbWAccEv0C/uRrtq/WfNfTnoexAA/R5/Kr6/qajaWOHoZherVqw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7ycqxr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:34:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARC0Er6032786;
	Thu, 27 Nov 2025 12:34:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mc823e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:34:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HA48V/375Wco7XiXtXcVMliqRd6XSfS6GVYFa8FaqTjFLFscU6wx5yTWaBHgCmO/yNTvFg24iD3xvA8NlSayvPUoaNM3aVQYnW76Ggr6tYu+S3UWHx+WRMsFPlMF+SYVzHbyKZQx2NRpPv2x28HoEsraXrapcwl8zZ3m2k9G9UQyjct0p90koStnMTy7AuvyXiyQUQT6dSLWOgzcajVgnqFVy4Lp8QC65EvvZYUeWokBcl7N9ggQZ8cD83+1HpP32ZaJxTqgvQqB1HOj5qZFP6wiENTa00wvNyN+EdGpi7cHqcY6RIgC2455BimYcR8RrtqC47/8urg2zLz/gcHIsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYACKn/urmbDhyxbsePtBjDptkd8CkidORoMDM0MHkQ=;
 b=B/YsbWdN2pOd+ICA4RbTer7z2z1Fu+9FjBOKdJhHDcmxPJCxu9PwLQHseWtyr5wr9ttQr8Kj853Uk2rScSMBoAU3NBDMmoY8eYl9rfESMtlj/K6lYyePc3/I53uo6KjNvBzcYPhGZXMwXIZbR/ypMDDlEwObFsQzfaNaSqbhIhcSRdQMqTZ3qHf73aycs92vVnFXx+xQbFtjSGKFCJsXsxU8Sxr09fEjerepBVpODE097/oVCulRy7clFtIRwlZ0m+cl+wQyDjxztwLkmfr9mZnDnUs6bVIYEV3X/sge6/8FHOHwmTmie1seOe+jjPxnlxCn6A4sPbSU/0dTQ1CCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYACKn/urmbDhyxbsePtBjDptkd8CkidORoMDM0MHkQ=;
 b=PsOg9QqXrodJRIewiabrUGwc+G9qI87CuXqmhpj32KtW9lPg9whBL34wdsDssgZ7misRmj8cNxOZiPzeHlG+wI26IDv2NwnOftVXRynwhm1gX82sZrPeT0ScOXqC+VNSJsTtds9kaMccq+Az8WTDVNk3Huzc3mwrAexRM2kQfeA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997607.namprd10.prod.outlook.com (2603:10b6:806:4b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Thu, 27 Nov
 2025 12:34:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Thu, 27 Nov 2025
 12:34:00 +0000
Date: Thu, 27 Nov 2025 21:33:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Aaron Tomlin <atomlin@atomlin.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aShFKpqPTgqshx3s@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
X-ClientProxiedBy: SE2P216CA0183.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997607:EE_
X-MS-Office365-Filtering-Correlation-Id: e0ca090d-7eb3-460f-c4d4-08de2db13dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0DlIi5Wupwlyhd81qda8yL2cL12M6tuYUt8jHh2ToJNOZCI6EBFsZwCvJY1T?=
 =?us-ascii?Q?/G8dTU3VH0J+lLP9CcWyMhdps4HlaL2Pz6i4PPAB8Ga0sOM8mJJa4ait10VD?=
 =?us-ascii?Q?TB6QYatVI6/7fd/fc4dzcAjbTpB0mgeaHNffr4YcC3lCjONcuJjQJ8j6Az9A?=
 =?us-ascii?Q?bsBFmJyt+WVIkW9+2YjT2Q5mTQiQFGKMBTEciOdndEUC94SKK02CGyzD3L8F?=
 =?us-ascii?Q?xGuL0VGWj75hU83Q/wcKHFsOouBcJlXDfHSai0mbt2U/PR6NSyJ5xJ7+h5Uq?=
 =?us-ascii?Q?uKwaLBMs/KzzO1S3NJyNhg+ELoKO8HfzPh6d/wTMtATqna+RilDc7XbFSR9g?=
 =?us-ascii?Q?wpRxu4IXOuD6+Pnk+Rl5pKLhlCD/EpEgJbA60A/xfML3tMjPm7i/5iJwpPad?=
 =?us-ascii?Q?OFGfag9V7RDjqpxqo7nVIP/rcPcCAoxKbVre0+QiKkN1R4VT+tHW9DNy/v++?=
 =?us-ascii?Q?s7AIfNB9wBt1DoSyStx+wKwlx45T16b+fdKljt683nxvKQJg8p6RgQTCzV8N?=
 =?us-ascii?Q?mHfaMwO82u9+gsx5/zx4anQnr2vuKDFXRg646je+G/4y1vHNbdwc71H7WuHy?=
 =?us-ascii?Q?Cp7wZAukyGH8G/XuMaLDYIwtytMsvB1k8OB6RItgZkCG9Dny+r+IbFp30YQi?=
 =?us-ascii?Q?MLxl3/OhfxRcplfdYqAI7KYFPh7zperUNDC1QP0oh1G1ir/DZ5HMmHwNlZxC?=
 =?us-ascii?Q?LXetj1DpyajcQUnVIpp7Qehh3kmbaKzsZZPM2iOtjMn07AxFR+bIGAyelB+O?=
 =?us-ascii?Q?bnWyryUItdLoWmCV4g3nvcS5sYr3p81eg1BLMMuAVOb29DgVhvulqQeCFA5J?=
 =?us-ascii?Q?FEJyGULB1J9FfXYcctTCfwmjPxtfcvgbmXQ9+iBMuv3Ps40ylRN/upGmvBjl?=
 =?us-ascii?Q?NFktS5c/jCwcIXDR2d1jwOEYNVBaQVtC5O1KSN8KMRwWEIxVhlSrloOBaFK/?=
 =?us-ascii?Q?R2lCXOgWlIjo5lbLznpZWgzP6N9foJzeHYJmxIptbA5I8bb5SLxZvhqCdc55?=
 =?us-ascii?Q?+H2f8I9vfE2hjgtVKMak5LTn2gbCfdMT0dJzBDgNb/7cVG4zYfs1b3g/G44p?=
 =?us-ascii?Q?sVj5E8dzPguh737jEgAsVEw635q5pBkNACxnxrtTE0u7fqocvqCl55Wshga3?=
 =?us-ascii?Q?wta9+HzLHcXOSuyaoaMNBLgTQGegbZeXT+K3T/cx9nUVBYQJZfzh8KEfYRFd?=
 =?us-ascii?Q?jWPoR54xpTPckW3zft24mzgbefc8xNGPMEPCj9vwRFwDxewEvKiL09RtW8lZ?=
 =?us-ascii?Q?JRJotmbxcuCBgAYbP0U/I11+cubpL76NCM4E7F9ocWh1sJ8E0bYebiMg0xb3?=
 =?us-ascii?Q?daLMXX6vVzEPKKeLFqd4/DjSj3N+pYFc6hnixeSATlWE1WW6Xu8dsBCKwctg?=
 =?us-ascii?Q?wOjuTG+XY6BKtj5/3QZ34maAJUYietfHLq9znzibDMHN5qpeybH1gAmzm1a1?=
 =?us-ascii?Q?iOIS0cVSd+hFH1tBzlBx0ZQYDh2hFJmo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pWhhSyVd0m1AbIuBEXal76HBiue8kKfK7oYi4PzTBJiAgiNYP/LVtUY9VzpA?=
 =?us-ascii?Q?61c7JCqdG6zz8Y4WvzlVeYghE4Pgp55FKzK9W6Mt7OKyhDyZh0zcDgHJFw09?=
 =?us-ascii?Q?FM4lNMruKxuCuz703J8MIlBe5cmm4puL1mBH+mE1FEqvKwY0r5ztgAHNBm6i?=
 =?us-ascii?Q?bH6GWa2C51sda1LHY98b7+IbCSEINwIEsb14vhq/iEbfplQGTZQ14q+dm3CB?=
 =?us-ascii?Q?vlt9lZ10z+rQdP0DMaAEihp3eBHqDOL6eXQ1rfpyNKaOA6eLN/nYNHbv6e1u?=
 =?us-ascii?Q?Bcx2RMvcqfuTxKq7/74ZZjs0xM+zhNggut4Cv7DWrW2WpTyWySszVzHovDfH?=
 =?us-ascii?Q?H2GIKIYFu/hJvxBxejZIxIgwt9YxbT/2TUspvLVydFldDv12GsqpoMk9L8JF?=
 =?us-ascii?Q?fCjeYTPQgk5Sm3XJX3z67W3uUXtplBoOeCdD3etO0H8uQPwKGC9ygXYBiE7b?=
 =?us-ascii?Q?njjdrgS6k5enM2Rv2ZEaGeydFsVEmUtd7qgMpH0U3zLRjwIMfmzmXg9vXT5w?=
 =?us-ascii?Q?WyKCv18dYvQmyU9ZVAymAwWoeod4rD9MHnD0z/cBUe2lAEXhssvS8g/OypXJ?=
 =?us-ascii?Q?IcvQx61Th53kTnAwGkpw71GfY6fFQUCpfCi73f/pqlbBuHrg99SsQB8Wng2h?=
 =?us-ascii?Q?Jf5bKpL/flBMQYFObu9vdhRBxQHiEyAArhFzadA9Bv+pBIYQVWLW1rs/Ka7z?=
 =?us-ascii?Q?GOlidja3e7Xcdryl4dIdeMiJVYLGLKVBHMqSaJiJ6ivjoPod94OS6KdCd7O4?=
 =?us-ascii?Q?awD7/vCNpO3Fm8GM8PbIx9pSwxBvsb/uzUTsTBizZrxRuSALuxJI8jnkRkSB?=
 =?us-ascii?Q?fwCL2RQVgwhwl4Mh9SfleMyaQ1F9VAze2mTA+/s1S6YUKDtUY2jqwouSMvT8?=
 =?us-ascii?Q?rwG1Reirv3z9uGwkLzgw/XfwOcigvzlcMcVNdlALBl25LOoxmKrCDKKBdOKF?=
 =?us-ascii?Q?bKsL/OWrwTp4GmALCkP6Ht69n9+qsGyU7OSKtrO1j0hHSJ6HAQSqukkYQhWr?=
 =?us-ascii?Q?TMwwzSLyo8K8lvKR2GV9vs/Ba0mvUXKlzfBOuEWdUHSqf31Dlep564EeJ1G+?=
 =?us-ascii?Q?6Y67JWe/9h7yIPqj2AQyLDl7jms4naMTiDoJhdjb03GhnifLBGTXgUEduZiD?=
 =?us-ascii?Q?Qjch2b0bVwgySQ8GG5z01t3Az4SOMj6XIM/YRnTMv7eDyOLtMYt3Uui27cMC?=
 =?us-ascii?Q?N7bvi9dMsxyWr3CQd9SWysScau2W0WO14MBsxwYxbmIfTc7J+NZDSfidGo1Z?=
 =?us-ascii?Q?1xUs1hPh1xRYM/AhwlWuXOLiUNHGpj/4CT4fOaNSHAxBwdoM72cvmSTA/Y+E?=
 =?us-ascii?Q?uG5ZOeXG+ZnUSr+x4nO1zOEh4hD0bcQZq407cWEWGbubeedTVdmBvrkfveyI?=
 =?us-ascii?Q?My0PhuxMNfOI9xyqgDDndLK0ldAd6DKaBz4d4kxDpryFVmn6WwV93Mhxi0I4?=
 =?us-ascii?Q?AdUfKqpJe2SwARskYVIvBYv83YlvplTNHuW3wjoPQvkroV96+5E9kW2MooEm?=
 =?us-ascii?Q?Elqkl/sv211rPAokI5evFcNwQG5M+1QDed6VnTMwov2/Z8Us7fzEH0du2WNx?=
 =?us-ascii?Q?k0uReJhhFHVV5J273+llIaYIBefLryub4Ad6hd3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VpN9gHqgXKH3uoRKb9gmEl14N643KVWl2+9+I6e3qLVPeWHVfDmtGCvEf/EQmlpYpsgZiJHdmnilChWqplVA+ixbXJqyhKuBG46HqFoU8be2IiUeohipc4PjKkUCWDW5Doz3i6zjYdA5QHRKFzemFBAdxU8MTKJyc5zolXmc7X9MNmHMT+fDOJ8va6VX6TKKySV16YdECa6aXAGaTU9QjqK3Dt7+RQeD4w9CyguwUSMKiCgOyiirSxHuIdpWF4dDkRneX7G9pd50uYbfnkn2auuEI1iIZU61JuGP1pSWLmLEmwF2FjRAl3kqjh7jedov9qzzfB8kLdhC4hqka+6yTQka6JvcIvz/x7I8wcNicY4A8pnZnN2p9NYOj1jhBECMMoZVlH130R2sp1WQ0xULYD8magqkN8mGUHPf5xxRa677jp5oQHDb/EqKZZMnkiYc6tXTGWQXU/sGlTX1VTqtKoG3DkKjb70gnYRNTp0YwkQxPmlN6QGcp2O2aaM+ZZICTEI94rq6c8WRTmpTHk/PCwGbvA2QruCm+ZxY8jZMne78mGpUzYvRpPyHr6kA8OSR9ArRHvHpG6BX07ErBk7ImiK/X4olK31jNV6bV60S718=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ca090d-7eb3-460f-c4d4-08de2db13dd4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 12:34:00.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlfOHXz2LI1AHkBVY//BamhDGaq1cruo8Ffg64wY9dE3bqny55IFruW7PudiR15NvQsCYqd0E6v/bxVXK1aPew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270092
X-Proofpoint-GUID: n28RyRcT6lle2cQatzEaDKys88wnBmyl
X-Proofpoint-ORIG-GUID: n28RyRcT6lle2cQatzEaDKys88wnBmyl
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6928453c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5gfIzq4PylLIwemXUsUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA5MiBTYWx0ZWRfX4zal35P1Xke+
 jSQZuQrCCtwsdIDkhM7ixNhnodlyJ0P87+nv/XnuOsn87SXxh1GXc8EfzKuIscCMDee51XWYxVd
 vY6qMv2eveAT7Ssc5nUt40aOK8GjfuCGYwLF8BOHm5I1Le9CMJS108NdBwnjsyUm4urkb/vv12x
 5JniQPk6u8BPYGrC4t3UwvftgdgghTs0jpdGWgnLRU88wbXCNzHN5AIPVFR+B7mwp+H+2iY+Q8r
 t+c/qZV1SgkbNFPJAmLAInu0bDvB1JLZmtkPI5ZPbLsw5EhfJQNxd1SekQqE0z4JqJDtkKox5P/
 AgGQvm2UohP6LECYPwTi+TUKZnkbXllx9iuAt0rH8bVr5th637t25My1E1aRUwIJQagYamDnbOB
 thKIdeOFBADCFfIjG+eKIMLvli6zGQ==
X-Rspamd-Queue-Id: 09BB5180013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 9p8bwzrnb414acjq7ndyt7gsf4zxp5nt
X-HE-Tag: 1764246860-490668
X-HE-Meta: U2FsdGVkX19nrFYKbjU6wz8xHCZ8g3vOMxyxNDrmvFdeSSsIV7hRXsvEfKrZssd7W+yGTjDQHw6bIx5H6SH9Arnfcnax5hyUSlsLezVzwwfMVV1F2fFyhweWECHCwKz9WOzORy/oBt6RpnGox3dQ5LqpE4ToDf+DZlbxRutrRFsqJTvNQaWSU+6323eHbsL4O7+QoWgiNAMczpdq8c3KoWZn6oyrZqy1qDy8EQE+x8nJ/CeIpyIgQA0xVHj3cwxW97k7o9S6NQBXWTrplF8P7moSIDzvDwdMA0BT3MYe8JnlBVe+K19I3fTlnRqI2dwLidQ1zkN2Q5cstwA7YidxeJ/LjNX2MstxM8ird6f5yFuKvDpIv2mKUHc3KHfYxdoKD2e2ISxoLaV6D9eVv/mriqB1K2+5RRb0pNmtb09WSRvGE+xCXjmkHUwgY7uk+uv10a/lZxKS17d/mni+dDyZIEugjfgq7DUavxyPZZG3iLZotkk0TrcJKyj9KWhNMrPIL76FX4USurtiQI5ZflncqSqyNVI2iWQA/XTShjPmDxBRUyExK2RI3wFEy84nEOf4G5Y/23GXBuXZ6x2fYxxg7i2WN8VIJj5bbjkg3VCqJ3CXnVxiO+y2Fy2rmIgswN5WkQteKAJeMEe25c9q3Wcf+DTtRoCMup84SvCLCwKXQHuYRrK5vKudgbtoA5g85mBcC7Xk8ctgq0KC/SkU13g+tubfNKcMKabAUiEyB5hqwjuxgSyU+KOe/n1J63JGjUwBM3z049U5bM1m8N/1uxSMSVBd6zjscylY1eem0BQjCJDhynMVejfrdknEwcrmEiLWebmhHcrdT4Dq7P/Q+fs/hHSbzEqw4LykBzOMX93tvoDl2cv1MbO+Y/+p9nNbYNHsUIRmap6VBRsnSNRnOycEBmT6HL0KcATHGjcv+wIVZIvYfnCKMJE9dxgLd+Bn+cZWWhcGlZWLPtSqzpBpoaP
 cehkrHrL
 SvZFifTKX0LChmckq3C82+bKo9U1oWlEQEUdDLArJ/vipF/ANQUYhWiijT1zSgYx+IPafy8tI/bDpsVX+f9sE1FqplNQI4KxNnzauUYgU9LzlF/zBWOKDVmjFf3ZF8tKndm1/QvPixRQ6hLPds5lEQdx+ebXa+avki8NkFPxyVa+pSQM/LU08aQTw0loS+h73l8BwkMHmL7W6N64rMnCIPouZynq5AfPG2GV6gyC4wblpNZYTId4MRyWy3KCFwrpbJpmZeN5VABn8xyESy+kRBUkvBes1/USPDeJw7zcWjBwxKFgPbgdXWpZPK4rb8XjAQqD/3WkxXohqb9XcI+QIBepXM9uO8nsVRJwsLi5+aV5qatan0Vo7dTK0GyjYtcTI0RxhhrLOhK5xJjSsSeST+DcNPhD7NVfNxm0v2GHigOueT8zwIJsjrrJHiqz6aPlGGUZ9jnh2plLIOQmwjDBJvtDvljvqDr2FWJYp58Rv5Uy7NNZHqj9aPjF/wSgK9mH4bG9ibYWbl0JzDfPqvd+bQ47V2ZfKx/NbCYP7H0eHlOlFe3ufLzgC8I3XCreo8rZuoHiLgKgQ/E86T8XQTFeHRUXXotn9sI+oPJF3NIJN65q9saDIFlXE55sGL/s9eoC0X9Ywr6ML9Z9l3xSRrfjVyPwkkatbPzqIGzQsp3MqqhX25OOBwkDkm3sjCxqkD2fi+eiKtFC3uXHbP+n/o4601O/8cQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 11:38:49AM +0000, Jon Hunter wrote:
> 
> 
> On 31/10/2025 21:32, Daniel Gomez wrote:
> > 
> > 
> > On 10/09/2025 10.01, Vlastimil Babka wrote:
> > > Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> > > For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> > > addition to main and spare sheaves.
> > > 
> > > kfree_rcu() operations will try to put objects on this sheaf. Once full,
> > > the sheaf is detached and submitted to call_rcu() with a handler that
> > > will try to put it in the barn, or flush to slab pages using bulk free,
> > > when the barn is full. Then a new empty sheaf must be obtained to put
> > > more objects there.
> > > 
> > > It's possible that no free sheaves are available to use for a new
> > > rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> > > GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> > > kfree_rcu() implementation.
> > > 
> > > Expected advantages:
> > > - batching the kfree_rcu() operations, that could eventually replace the
> > >    existing batching
> > > - sheaves can be reused for allocations via barn instead of being
> > >    flushed to slabs, which is more efficient
> > >    - this includes cases where only some cpus are allowed to process rcu
> > >      callbacks (Android)
> > > 
> > > Possible disadvantage:
> > > - objects might be waiting for more than their grace period (it is
> > >    determined by the last object freed into the sheaf), increasing memory
> > >    usage - but the existing batching does that too.
> > > 
> > > Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> > > implementation favors smaller memory footprint over performance.
> > > 
> > > Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> > > contexts where kfree_rcu() is called might not be compatible with taking
> > > a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> > > spinlock - the current kfree_rcu() implementation avoids doing that.
> > > 
> > > Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> > > that have them. This is not a cheap operation, but the barrier usage is
> > > rare - currently kmem_cache_destroy() or on module unload.
> > > 
> > > Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> > > count how many kfree_rcu() used the rcu_free sheaf successfully and how
> > > many had to fall back to the existing implementation.
> > > 
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > 
> > Hi Vlastimil,
> > 
> > This patch increases kmod selftest (stress module loader) runtime by about
> > ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
> > CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
> > causing this, or how to address it?
> > 
> 
> I have been looking into a regression for Linux v6.18-rc where time taken to
> run some internal graphics tests on our Tegra234 device has increased from
> around 35% causing the tests to timeout. Bisect is pointing to this commit
> and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.

Thanks for reporting! Uh, this has been put aside while I was busy working
on other stuff... but now that we have two people complaining about this,
I'll allocate some time to investigate and improve it.

It'll take some time though :)

> I have not tried disabling CONFIG_KVFREE_RCU_BATCHED=y but I can. I am not
> sure if there are any downsides to disabling this?

I would not recommend doing that, unless you want to sacrifice overall
performance just for the test. Disabling it could create too many RCU
grace periods in the system.

> 
> Thanks
> Jon
> 
> -- 
> nvpublic

-- 
Cheers,
Harry / Hyeonggon

