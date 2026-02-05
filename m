Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96AADEA796A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1566B0092; Thu,  5 Feb 2026 00:13:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AC26B0093; Thu,  5 Feb 2026 00:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16436B0096; Thu,  5 Feb 2026 00:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5EC6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:13:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 967321B23B1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:13:49 +0000 (UTC)
X-FDA: 84409235778.11.F247044
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EB7D4000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:13:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gV7uoWJt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=apSAsLcS;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770268426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iUEblnnpbRHyC+mQLSTZtGvCCiQb7uZ/gj1v1W1H4I=;
	b=65ij5M1Nzl8LNoDGxNQOGZmxk8q0JAmt1EoTiDyr53Wa219xU/WaVCHWz2h9Di1/1AeuPm
	m+XboL0GWsXmt9xPWKu6/tKB5r3q3FSvN22WBQU+jpOe33qlhoomZTTSGi8/Gid0i03yyh
	8g6/ZQbHs0Kyr+NPxleuGH2T5nT0LMs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gV7uoWJt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=apSAsLcS;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770268426; a=rsa-sha256;
	cv=pass;
	b=lHYmnwK22s5ipLGy9HMG/U125v0/yECSB3kHK233fNTZO+6FPLu8TYYoxEHZP+HQZf2LRp
	X8pId7B/3I6oJJjgKRMDw09t5WL3dPgvjqvLPMlzI8CNYmtn0DguGSQeul89MzlOAyhqD/
	25/d+6JeJzEY9snLC0n6U+MHYJFZDPY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Ka21s2731276;
	Thu, 5 Feb 2026 05:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6iUEblnnpbRHyC+mQL
	STZtGvCCiQb7uZ/gj1v1W1H4I=; b=gV7uoWJtXh8n1QUUjMIK7XgnHo4rxxqhQT
	KMWytYjovDffHVaUmxN3a8ej9Nr0Su6nsv8tCuSS0mNA9Np5irLBgttG4MXwRTgq
	abdMvrlTNAxO0VBwHF2aQTBjAXFutupMp8gUSyy7jyODNTNQ0XO2uX4NuZa314Zk
	3vxK2BLLLgSHVS7p302IWSpcX0AwD+qNIb3OpaIToHR5LzO4cJAi8fgZ1RPonolX
	XyQcvfwfB6K2dUA+fI9yBTj0fjC6MGwyhZDrKZVE976P6FowEH16rOTgRBFvitpT
	fVhMkxH665sSWXQvF83x1iv40WhJXF16yPD/pj52sWLKrVa4KKwA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4d9v0evu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:13:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6154pk56026046;
	Thu, 5 Feb 2026 05:13:35 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012038.outbound.protection.outlook.com [52.101.43.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257b5dp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:13:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRkDN24p8zw5nteDwAYIKP9cwZmTC/K06jzZdPUIvvWMr+OI+9CjOiUK6zzNOFriSZNfjrkIunkGSkWGPPs+bXdVisaFAoEfEznjEtUNdgrVAcKEe0OQKq4ruK/u5Gy97AyFuTBHL473xtTS4uE22NTQMF5hpzyp/eh9rJSerpKbXYDuf3b2Hq9aOi20bpeZ7wmP00sT70T6pmRZ8mzMjgWd81uqVFz63JUkvwvf467uol0J23Dxlk8BfqHYdqEBT4e9acLDyaHAWCgbgPTaz0p/Wtf+fpDlrGOytms5l6OCEgpgghBAdDFT0XnVWbH3oZ2TPTEgVmRqNRaGHw6oRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iUEblnnpbRHyC+mQLSTZtGvCCiQb7uZ/gj1v1W1H4I=;
 b=OKAnqaDCEFnwG2z9NYlCDbHJXjEqWpHPdAPgv2NF8XldFyLpAV+A6OZrRY1gGkj/Yq35ikOfPYrcCptWxYANwQwQAWXnZ4zGYKWqXQ3VtlwINOGzeueyEbTtN8pl2ldDmH1afC7GSQqYLFGHtn5JVyOGEYxK9C81nRBkf4MrufAdGFSRwVAhcBKpKyyGQhym6A9j12zbGXWWXPNHdF8lGqgG2/GvgFJQgAlVEREk8jbC1NQxLbCX1Hg6osHfN7KOTITohx3FG1M4kE1czXN6VnH344q8zVWGc3OJgFcF0b0l+NppORkXlV2/W9NiuvkkmxEC7sPRxVqMlhw+UEZ0OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iUEblnnpbRHyC+mQLSTZtGvCCiQb7uZ/gj1v1W1H4I=;
 b=apSAsLcSEZzUBiosu7luhY6cYVXUJVKnr8F2icnfliW2q2YdIQu+nm0GTT+RcvCsuqhbpU4A290BQ1C8DNgwlPYr2XcWp/1i8OSTWeuCaZVx/LFewTetV8XRugujsAkoG2+wvBVMbKsbpCOFH9cAoFSdxCIl+BX/Co8S0pVqMxI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4179.namprd10.prod.outlook.com (2603:10b6:a03:206::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 05:13:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 05:13:30 +0000
Date: Thu, 5 Feb 2026 14:13:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for
 unmergeable caches
Message-ID: <aYQm8_hnN9JYD0xM@hyeyoo>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-3-harry.yoo@oracle.com>
 <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
 <aYHqxs2bkSEFOqZZ@hyeyoo>
 <ed7hyqa62mp3mqc67eezfccw4bk6hrxzfulz7pwr4inzyikveb@2hlvbjvvi2ax>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed7hyqa62mp3mqc67eezfccw4bk6hrxzfulz7pwr4inzyikveb@2hlvbjvvi2ax>
X-ClientProxiedBy: SL2P216CA0149.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: fd420396-46f8-4c0c-13e4-08de64754d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IKlxSGX9vfL5AOX6nAN991eImfi5/otPXi61k9TE9VpuJR+vYrWei+IAtLru?=
 =?us-ascii?Q?ughLvF9ZJX203uMf2XEqZQWUM51eSfEazZFm1BK1n6LTa9D1fBKYl0KFX+GT?=
 =?us-ascii?Q?B09+H5Ep6+YWrEM9TgA/P6eXWfQGpqDzIJ2Ns6J9LHp43qcyFYRISY7l8udp?=
 =?us-ascii?Q?oV+a0BvPEyhmNV1R41M58g2BapcmLE4kSA3GlLbKbX7w9Trq0tuYdtD7bqpE?=
 =?us-ascii?Q?yfO+mQdSFIiltmHne7Nq3syT0MBGGxkC0G8XVjvoDdaaiBq2f+3kHp0LHwHT?=
 =?us-ascii?Q?o+ACluvbgD/u2IFaxXLyUSBNhbjMLcl8AoJYRC9zHYxRPTGMYsguKzPcZvv2?=
 =?us-ascii?Q?5RwxE2TBRDvev7I10/RfVacwAtzrIPRnEPipvierCoy3BDqY7V/dh1itcWtM?=
 =?us-ascii?Q?p0eYaS7J7ygnkQ1JEX0CHnrb9Sr1+2uXm3Rmvxoz2tHiiEEbe0d7pDTyi8mC?=
 =?us-ascii?Q?YTn7pjHT/uBK69HtpayW01b3flpgcjB+6pMY31Nvg1iw4KSWwHjmXj+S7B3A?=
 =?us-ascii?Q?DsFJRiqDoxRCUde1vFqTpY2D8CIeAgAVBeUsr8YrGhuxI/ohmceIHHY+vtdr?=
 =?us-ascii?Q?2KuQJkdZ3wClcHyAdF69bGHTdevH9jbNNkifj9X4GSGhb9yn2pMwPHHqNdlU?=
 =?us-ascii?Q?iBfucf4efYQFifkAt48d/J0N/MlaVYOpAsfXMcDrSM5cLE7MllqNQMKNNZGJ?=
 =?us-ascii?Q?GmJtfBaNsSwgRS4jzO/qKHrnuRP0muNqKwXos8gZQLU2/F6r1r6soYAU3ZOI?=
 =?us-ascii?Q?k5ovnr+OVeojCUWrxTYoln6xRGER+R0raSwx4GnC+73fL/S0u5v9yJKd68rz?=
 =?us-ascii?Q?pcfSlgbElUlm3FRQ19q+WjilEdKmXk1/GVF46wEh8v8S/nr22KyAO6TXyMNu?=
 =?us-ascii?Q?kJ3+S0I/n5S7VSRqU2ACH9fNg8d8e8XAKw2LvPqrtF1xuaxDvReCwwODCZB+?=
 =?us-ascii?Q?sHno/yvUd+5ar8osbdYxx0DGUzDJIbZnwn5Jwo0F9QgAiR8hVqEIYozs/7i5?=
 =?us-ascii?Q?TosnMf9OFBQGOxwZpAUBenEEEDWzYOnRUu6x6a5WdOHA4Suw2l4ZdVI5C5sQ?=
 =?us-ascii?Q?iz/b8WpRa7FXN2xJR5IaS4MivuIDLPsZoS5ZIiICLJ2n77W2hQ5UH4GhDayM?=
 =?us-ascii?Q?9bUEYpYkp84X7Gd/cmGhTiEX/1fqv1EY2Q2vhO1bEDRR1vwZC85bnF5rcj7w?=
 =?us-ascii?Q?6DDQg+69kk+IkVHsnAM6IFi+R+r8jCf9VfVa94y8/HvnQ847cAyBHNoF8zoq?=
 =?us-ascii?Q?VDO+gpUvgOOyPOOP/8HM/b29MLi3Khh7/Sh2XUOCPK3GFazVWEqr67/hca1R?=
 =?us-ascii?Q?2HZEi307npLkIMERJ+KpA+55M1020nkkjPwts3iSZlfWuHAXDJ/B/spbhc5w?=
 =?us-ascii?Q?K3ZMEPh8n0uiqm5VhDagn5CJZmA4GGoEDE3QwLdk+XJA/GY57WmWRYZ5HqMp?=
 =?us-ascii?Q?MgW/2QG1gqwjZdY6QQcMgSN9YOxXbBYLth3Lv7AN7nj9pxaZufTJrw2B4iBF?=
 =?us-ascii?Q?VRURTFGka2bwCcRtLiR51vkerhOrLOkbfHmaNX0D8pjEmikZElPSQMJn9tW/?=
 =?us-ascii?Q?YZRlOC7HcKzd64XqM10=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eacawGPbsFwvxnDNYP+9wUfXH3Mb9puMWUOU+8oi2jPAxqerzBH+xo7zaZv6?=
 =?us-ascii?Q?sLIKTizeJDjQdXjDH2lGkHS8FPsswTi5pDJAu20xr6oKt7PK6VCu1cO4UZMU?=
 =?us-ascii?Q?hR/cCVilJ/SQj+jV9iYEM7GowRX3mMk70RDrRjz3wBLJqkTyECIMCVh+cyhD?=
 =?us-ascii?Q?maPLhl4c3Jr75o6g44b1SMyfc60RqEoxQM289UKwkSQemK4QNoFkYt5RDUIi?=
 =?us-ascii?Q?s6vSK96tWusC+1mvbVcYinNW29/CH3r8MR/g9zGDsadu29ywEIPDvN1XAhwj?=
 =?us-ascii?Q?7lOls97bC7vxnegcOd1Nfj/wOTNXYFvbOqcXsTVPWZq/rejsI1SUfn4nqzz0?=
 =?us-ascii?Q?+iJ/+TbljF7moP2Ro2KTz+nU90+z6z3xSfz1gfIthuCtOZT+nRnpMd1rnObK?=
 =?us-ascii?Q?/e1vH5syjwPqc2WEl7Suag1bXnYVcg3uvAsy1xtIy9VC4HMVPRczV8jDYFz3?=
 =?us-ascii?Q?zynlofZgy/P4b8GX71lmp+m7Ujbf/915OJjGYjYHOGQuVEUkF+WqWS55fXFZ?=
 =?us-ascii?Q?PMmOf6rHDb1s7RV33v0wD3mG21VCzF8nbCJlO5K6iQhkumAVOatWLulfz2Rm?=
 =?us-ascii?Q?ejbocQp+Uw90NePWQ9cU+GUiAQ2tyAS6zjCdWRwsvuIOqMCKKf0lGyhDCYzI?=
 =?us-ascii?Q?IBCuC+WGd0whL4kqst7SpUUWGphJzYCAAQih1db5zVc72P4EkUfljA1l86AR?=
 =?us-ascii?Q?Ta4tmjwke61FjqVXBKNLwAFsnVvjraefKEnPyE+AW/G1IxycP9B1KhP2XAOK?=
 =?us-ascii?Q?ApJPTLyb4OuUrp7VWAn3ZNEkezfvwURwq8zntxljiE/ZyNfsfgX8zJnJ0Gg+?=
 =?us-ascii?Q?KS7JYtYpkbexelH6EeUpcKPWD6b88/OmAOYWOzoXa71OOEWNPxpr8JmC+Ba7?=
 =?us-ascii?Q?b53W22av+S/Cz9KT5nCARCjEO0ktVvPC9Ei2bG9m35RSsmlqZewZFxmP/vtW?=
 =?us-ascii?Q?PhM0IqsN53J5KpdtToH9u2/Q84QrXy8d5tYjVD4MtwdSh+SHY7dYzh41nrHb?=
 =?us-ascii?Q?s4kQQ6/lftit8ARGdYojWVOvuMyWU7gc4I4Jcjwe7x6w9y+XzU4wqILnJ8Bl?=
 =?us-ascii?Q?RMVlcFKoz0cKgqne6nQQEsab1c3+7x+NoSa2sCN7fmDkQERBDR8iK/J82n5X?=
 =?us-ascii?Q?BRhjH0RznbL575RnN/A/bZD+/gzofr3i/N9dmpdg6kKdouw0oe+crtzkT1sn?=
 =?us-ascii?Q?H4NbV7z7JJZjey5jxQssYwULUxNef8d+ESllBKJRmE02exwWd8DgIUk9T3mt?=
 =?us-ascii?Q?fAOejXhSW3a2cmuxyla+Le0m1bZgvn40Ekz9k+dUbQAe1puYc+3FocGztuQX?=
 =?us-ascii?Q?16TcJmYb50tbxW5HT4uOsz9h4qXvG42Vwhd/Vo3P3XbEGQrsUoSx2okICVhx?=
 =?us-ascii?Q?6MMGaIrmSuBfO1lRiW1srDL85Oh62rttxzPdA9u80O5s0Q2QZZPDuO5NxBlA?=
 =?us-ascii?Q?ll6jdPhNVpBIoCosuxbBa/lAoTw71jCqgLaaU0Fxs+9cBQIKra8n3GoaabMP?=
 =?us-ascii?Q?711R1nFf/kCH4TcYHWM5O6XDBj50EAVlbNsNixMXdCI9o+GdE8V7iEDh1Sm0?=
 =?us-ascii?Q?nDWkR+5iJ5DR+WzA/+23wLtXxlkdI/afTwixr5R1XaKhKKjcEOqIR3CjEzyU?=
 =?us-ascii?Q?mGt8H9VToILJjSTabtoLpPRDE1dFaVNN0b6hjTXPeRXeC5WOjzLJeKi6Ce2M?=
 =?us-ascii?Q?IZ0d1nz7gy6Vw+NXf0eYTrpCpomkzV68VRkiFJUSyCF7NDSkM+0xZGF3R7Sp?=
 =?us-ascii?Q?lbSqc5NgUw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8y86z2R/1TIWmGaURm6KPcj39QxDJUcHyy7xTcqq97BD4ApelBqzFIlZFqeq526xDAA91WAAx164O9fWvyVrhf+6HgtJVSI3xpex//Rqdnsh0p7qLRa/zSPIEPevG8iHmbGmBpA+5kAuAIn8m1kJ20e9QOgR44/Qtmb4KjBxxm/gsRuk2RetxXMmg2vqVmDLWGTsk0wIisrmMK9CLG3iBP7A+Xu+1Bw2z6HVNZkBO6UeyE1bplB7rg5jJuX+++j3OFohLIDyqUCsAtIwZbiL7QDWAezZoeZRgJ77Q+rlxTapPrceOKkzfvlxVzv4dxRQTKxyx2p8SBTr+lQAiSsfUqE13dvBzltZ/umIOYijzfg6m4D01pXtK+h3BFvQsw4YvEs5t6YGwkjr3xsDwaBlyTFR/iupVnPSsIAnv11G5wH3Rnn9tf0UJ/2X95TcnDza+/ovLae4WeyGsfFc8tKz16lxMWEZfRU/EGLuZ4d7D/M8+w967+ZJJDyJZyvNV3py5JnHqZ36ee8Shyrm3Ii8RGz2+V/1R9vgbOdEA3/OMPG0wKzdVaxvB1GozAzHkvDB+pkPe1Snu83/BYonJWAFeGnxO6mmIKYzmnOXytRiPm0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd420396-46f8-4c0c-13e4-08de64754d48
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 05:13:30.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HooeAjBQwZaLPKqgxGjKpqNNeBXpnGECt6eOzEiwoJWe8yvxdqElOTWUstf+VR4OBi82XOtO2vjf1muBr/CuVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602050034
X-Proofpoint-ORIG-GUID: uWBXSscyfTbrKAL7Q8sLN8LnB6AIqd7L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAzNCBTYWx0ZWRfX2ZSJUaUcYl3O
 O3JqMGZXQHhWoil0+UKrhIRAf9WKgFN1K7cwH/h1kN2EyiJVyZQN6rUcMzu2GXUWyr8mSNG231s
 qCLIO6Bq7DpvPMCyxfDKsRx6xpzvjqTtShNfuIdCSx9/kdnZEa5ixu5i2xqdUMOS0N6oUbIZVke
 C4zqkMucYpSHXwvbL18eQwYnqJLEY9SvQ5l0M/55bX0b3M6V5U/FBiCxqbm7tzrGi/EM+2n2kVC
 W+y7Js9a5rEr4YTcHuYZ94VjM8fRWw7RU1YccYJLU/Of8S/42IIYu7DAZmYPJJ9Xiw1qqKmv3Rr
 wKQ0pDyfMIILrYPzWxePX5Qe+TdVZgMHvDnT76dl8Sd08fD7j1s6R5kTqGZ2sgXFYU6QeqN9ydR
 49skroercijmAd5G5IptEEWeN6wPKM52PgJu2a19iyOAy84gs1O6o8jR+orSBk0mUS8YHUzIp9d
 o3cRwBk7OnKnSyRi1IjofzDWKoeAnNTBm1tyCEgI=
X-Proofpoint-GUID: uWBXSscyfTbrKAL7Q8sLN8LnB6AIqd7L
X-Authority-Analysis: v=2.4 cv=NprcssdJ c=1 sm=1 tr=0 ts=69842700 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=oRBa4WDIj_CjnUTUiKMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13644
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4EB7D4000B
X-Stat-Signature: s43xx9zdi8fc9xo1nxhbsuyyqmbia6qa
X-Rspam-User: 
X-HE-Tag: 1770268426-714306
X-HE-Meta: U2FsdGVkX1+eWfY2Sz14o/zHryVIzpsiaxyu3sA6l4B+zAiVAVd7Xmazzr0+eopR5b1bcNJZLnVNiWOHC2L6ArfdVTPbRqrMVwJyzqnJVlhtp7JyvbdQCWIA2w0eb/lVOOVEASbEt6cdjD8mMsjVnNt2b0eROiKjUDoaJFDy0sjOz1WQAIrEYrh7yHkqFZNiOQMyIX2elARs3zS1si2sSFosTj6guUIYI6kllT29p0LykcO/Jk9l9GltIIOdkwCuHNol8o0Ymw/Do1IMlSl6vOqKcRGtVwgx1s5oi5A3Xz1EuVzKGGmfF3AsZJVOpwAE5cxew7P4BI/wQlv/qwx9hGyaZSmkWll/JU4XigSfVZRzAMlz568nkzROmLxwPMr004RXaLZkNNlKizRY3DsnSTRPZCzGl7T3usYsLhu6f2t2KbDwURJdOg5LBSi7N4Y0mc6oivVMvM/y+SiGeeAFGkBip5Ngqo4W3XkLA03294f4kYu/olnbngNMqzd7HJ20nXlbcwvkm9xS7TSqSgia2Vxm9UzfxkM2EKt/7KUnboXi8HvQTkjT9rtYjtjC0D9TXYJBv56dCLovK3CoonhKroUCvbTyUaMzBIGQHRT/x8HLA1IKzg+WgnN5bPZj3+UxbFOUwCAAt0pNbLbojOtgQCQQbnoWeT2Fvc24u6VgFp4O6OBvkKvCgntBfDPUcxYmGWZB2ybgOAbt2/ISxNGu+egmXGPdrbq8+r6Ni66NMnArjrFr9VCM37nMflQLxfkCUBG6yq5KwGK1LxQ6e11G19rYe1HqY/rt+MxAjJ1NsU3x5jNPrisgIGr/1WYrQ73Girj2x+b2sgrTPXwlhzG4G2xyH2sAN+z2o5aBQAPH8OapkyMoDcteaYA96Vjh21BpMysX/mu/t1PtiMCgb2GIlYfOIIoNmMrNhXIxd2H3O3ISo4QKxQiumTcKgtEoATgolrH4/14otgWkY/lbzy3
 IrhZicDR
 2zZh8ZYx7jaztt6lvWL7OnA7BeAMDOlxbXa6ThHjEuF5IjdneIhGK6bgZXzXmVprSlJKK1U6+1MwX+ok6IPJM1mY/hlil2OBZj7qdQbPTxH3iiKmMl4TxJ2gdfVcwnAT+NpsY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 08:45:19AM +0800, Hao Li wrote:
> On Tue, Feb 03, 2026 at 09:32:06PM +0900, Harry Yoo wrote:
> > On Tue, Feb 03, 2026 at 07:56:16PM +0800, Hao Li wrote:
> > > On Tue, Jan 27, 2026 at 07:31:51PM +0900, Harry Yoo wrote:
> > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > index ae9af184a18b..0581847e7dac 100644
> > > > --- a/mm/slub.c
> > > > +++ b/mm/slub.c
> > > > @@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
> > > >  	 */
> > > >  	aligned_size = ALIGN(size, s->align);
> > > >  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> > > > -	if (aligned_size - size >= sizeof(struct slabobj_ext))
> > > > +	if (slab_args_unmergeable(args, s->flags) &&
> > > > +			(aligned_size - size >= sizeof(struct slabobj_ext)))
> > > >  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
> > > 
> > > Hi Harry,
> > > 
> > > This patch looks reasonable to me. I just noticed a minor point that I
> > > wanted to bring up:
> > > 
> > > It seems a bit self-referential that SLAB_NEVER_MERGE already includes
> > > SLAB_OBJ_EXT_IN_OBJ, but we're using SLAB_NEVER_MERGE to decide whether to set
> > > SLAB_OBJ_EXT_IN_OBJ.
> > 
> > Hi Hao, thanks for bringing it up!
> >  
> > > Do you think it might be helpful to add a comment here for better clarity?
> > 
> > Hmm but I'm not sure what should be clarified here.
> > (perhaps because I wrote it).
> > 
> > Checking SLAB_OBJ_EXT_IN_OBJ (as part of SLAB_NEVER_MERGE) before
> > setting SLAB_OBJ_EXT_IN_OBJ should be fine (because it's not set before
> > we set it), and once you set it, it should prevent merging.
> 
> Yeah, s->flags currently doesn't have SLAB_OBJ_EXT_IN_OBJ, and the functionality
> here is totally fine. I just happened to notice this while reading through the
> code, and from a semantic perspective, it made me pause for a moment. It looks
> like we're checking if s->flags contains SLAB_OBJ_EXT_IN_OBJ (among other flags)
> to decide whether we can set SLAB_OBJ_EXT_IN_OBJ. Maybe we could add a small
> comment like: "SLAB_OBJ_EXT_IN_OBJ hasn't been set yet here; this is just
> checking for other unmergeable reasons."
> 
> Of course, this is just a small thought, it's perfectly fine to leave it as is-I
> just thought it might help slightly.

I think it's probably okay to leave it as-is for now.
But thanks for bringing this up!

-- 
Cheers,
Harry / Hyeonggon

