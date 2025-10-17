Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72268CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BED18E0032; Fri, 17 Oct 2025 02:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796518E0002; Fri, 17 Oct 2025 02:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636578E0032; Fri, 17 Oct 2025 02:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5978E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:05:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5864598A2
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:05:44 +0000 (UTC)
X-FDA: 84006569808.29.EEC4022
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 727F41C0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:05:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XDDJKP5i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b1nc6+6b;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760681141; a=rsa-sha256;
	cv=pass;
	b=3gDOl/LjbLd5Mi0tkAvBNYpL4zA0vKQZ7PMkiV2SuZJCRCmvodrT6aY78mb6Thr8CfN7fe
	8a3ShswyNga3uWvsmQRcSPvzmYcSNVL1L2+olD39uMu0FQkH02fduo0TfBmLjBGTVQ8r8f
	C8YMmbiMv9fEYdQ+GayRlaG0dKrLeOk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XDDJKP5i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b1nc6+6b;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760681141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hreYkVBQgh666LxgpOuvvfl3hxDb3d8XET+csoBL8ig=;
	b=u6tRr4eItJ9NgnnQV8PaxRSwgQVnE5Ly/2g02WT/mpjWW0POcK4PS8YL8cB4CCgBhT7mpm
	YrntCSqZ2kCIC0CrsFwa3RKzGnvXaPeTiq+efSwzUR3ta0Vl2ZSlCA0uL2cIeu7qMXYZ9F
	sXlT8P//i50OTV4ZXF+WUbTketetjW0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GLu754008207;
	Fri, 17 Oct 2025 06:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hreYkVBQgh666LxgpO
	uvvfl3hxDb3d8XET+csoBL8ig=; b=XDDJKP5imWZCwtlwRnE0zEQt4XrCiNvOiB
	NHifVsdbs/br1NuORqmGSYUxc8KZ/WPUQxTuq9pcA1OvWObOjnQeyiZWrm/el8QQ
	AImCuDqfLRVO52BDsPrwP9yW0Zdi/0eIdsFV5frSQebAgGFDBuhSYt8YfJzmxxQc
	zg0V84hkZDZnM/TKs6pjxdjsFRWS+BzKqSbZpHfmiJYxaJwnAYaZ+UaCSOfTPmO3
	VgnUbdiNWEZpnMVG/v8C/fxjsHUBSKvGrt82ppGEdIN+oPyooxketlmJG87Th1G7
	WFmREpOpMoB3nJj+5Rcbe2+RkFbvKXHatwReR/DEqZyOOZ1OX1Gg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnca8vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 06:05:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H4WNRB018414;
	Fri, 17 Oct 2025 06:05:37 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpcdydr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 06:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S1YdhBQYSrBkQRs06uPTelbdPk3EtuCIJCl+yg96vKSQGMlNwIfyZrBd5IYOQ2hVqqGVQu/fuzRpgZYusJkpXA+UvjlLTsuBA0Lx9Q1H/Y/cWoFPeb+H82/KEdWFelt2V+JWz1jrBhZ9zuUFKsH8YKvpwP6b5OvVib+MYlA8b3KmyakX6mgykwveRbj1tCpyUbynCo8np74dGh2iZqfHdMWEN5DpdxyzVHFZ68OlnJ1BdioIhU0xtDKkd+i1fCt2IkaoDnUC6wjmOZJB8+Py0S+h71OPcClVmaDgH/zFzzpHh/Owuke2ob0Uvde8/H7N7IKFF+8Bawu6XYtz4Hw4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hreYkVBQgh666LxgpOuvvfl3hxDb3d8XET+csoBL8ig=;
 b=Dx/FHfJl7J1aTSFl1EE5GyyHS84vw8gmpPnzCH41tSGI0ae30e5e73eqp8kWgfebf/coXdlm7mJrE8M5eO5PALvAr2aYBFbq7lDIy+sw8kjrqdbvAsVONVRwrIAAehmaN+vCJJKnPHJAnIqg1GcJySWM0j84REmw4exjaQFQeMjdTDMEdMTMp47rjve+PO4qIxgWT5zW4I5YgCDzTZachIUv8YHAPn6eQ3CDu7zRRYkBh4p1sv6578LnflSv76LnBXlwcwhRFv3e0yjvhi7S8EA6zSrA+VXDCXxHIPnnRBjjjXk57kwigplV2oOe/9QPuNHQ+zNuD8JkczAsx0cj5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hreYkVBQgh666LxgpOuvvfl3hxDb3d8XET+csoBL8ig=;
 b=b1nc6+6beMM+XzaPch4A/nPnpSlqfJzUqncAXxLbheUPMgOLU53of8Uqo7Fs3FTvkaqC3IDCZdBQrM9Kc+xjTo9uKQA1RdP7Vr9TkPp28VfIMJh6XR4MVyMRRjTq6HMWUgCj+u4lhH3QPh92gMomKfVy2lTUplWP6dHRdCrKUpw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8753.namprd10.prod.outlook.com (2603:10b6:208:55c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 17 Oct
 2025 06:05:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9228.009; Fri, 17 Oct 2025
 06:05:35 +0000
Date: Fri, 17 Oct 2025 15:05:29 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Message-ID: <aPHcqbQkPV--NCt8@hyeyoo>
References: <20251017045749.3060696-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017045749.3060696-1-hao.ge@linux.dev>
X-ClientProxiedBy: SE2P216CA0007.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c0c32a2-ad00-403d-c25c-08de0d432fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p29Bqui0RZ3O/vbBuw/90xb6DRLFr1Nb2oAOgGeG6ULYA9yVs18ntmytGL4J?=
 =?us-ascii?Q?imsuzDqVahKkMms8OEQ5CSgWS1ltJUXfnrFnh++S5FZPxrEBTbfBiud3fAUC?=
 =?us-ascii?Q?8k8a7ldXf4yJRQRIcTCS26d3dCq9kblOWvUXoEx0YbZQ8bOKM7NxAUAEL9Vg?=
 =?us-ascii?Q?9rtKZkde1LcETO7Ak7p2nxYWKqbaNC8NfBHbmcf+aMmRse9Fvo984mvqQGDQ?=
 =?us-ascii?Q?vzEO02s27NhppoEXQ3V/9wdxoBjAxSGFv0F/HA0fAEpAe006Uw+mzjLgn0ko?=
 =?us-ascii?Q?oZCUhWn/nVAThpx3FNlyixfuTwtD/h7LRz4w+2WTd8xlVfxH8QodgsJmf7cy?=
 =?us-ascii?Q?RSqqSrjfaUoXav0+wf9RLvvxgFiFyd4R66RQeKJVu4xlxpA5D3tB3DhU3ckP?=
 =?us-ascii?Q?+zRfZMHqUsZdDXVpy3Mn79fVp4gow55OG8NZyvTAStU12WKFguhgG4a1YW9w?=
 =?us-ascii?Q?YO/BQSOagPtIuTHGwcrHMbosgS3w7bsOBRfHRhYVkJUaSBvekStTYPo7EIEz?=
 =?us-ascii?Q?1WJF9GY3VuAeJczhJwXDFB7u1BUVXWAw8rD9wHmZvzNT7Pw21Yg7t/0RszaY?=
 =?us-ascii?Q?JhI/XjBtbHIOda4Jc4skQUlYjDBbLzEWAzRyx5AZuHbFQis0wCJaSuLi7RNL?=
 =?us-ascii?Q?U0U+mga3NAXlm7jAY//3iPLM+fc1JLOc9laZgSxwlePaXwTjlbOUk3edEpn2?=
 =?us-ascii?Q?9BUI/C+FPlgBDHWxDN3W9cKbVnxoxOwFzwnQgXgN4Ia5v0141cLhzhFPrbS3?=
 =?us-ascii?Q?yr4yiNcdjuoxiVnYWJrhIDh6Sy+zotHtSStVfJv4FDHyrdzsG16H14jF/NQ/?=
 =?us-ascii?Q?xuX4yHEQsArEsczBdSc/tohdDEgSoYJUitdhb1r6qa6+ckLfbVkJNvyH+3Gu?=
 =?us-ascii?Q?Ko6zERbSchXd6dsOSP1kcdEHv8SPp+BaYBkfFa2Rv4NomL9/HaUjEc3iPFvY?=
 =?us-ascii?Q?EI4qpQDgLr0jLYIHTFzwAX6LHDCx4f9uV5yYiCQDvJVq2xEZ1sv6c2JGYdNf?=
 =?us-ascii?Q?cu3NKaEbwcB48K25AYYlt+Imw34UGWp8jeb6UxI/kEGPQ27eNrKNwilknYm3?=
 =?us-ascii?Q?iEbd7Q5dBgn9ScLODvR1nO+MEiDu4eR3xjWfe8Nym5lM9uDRKek1uTVadefS?=
 =?us-ascii?Q?P7U2qrER1gAM2GTV5IJAMlfPajjKCW2yiUI5onNlEqP8WZnEOa2c0Ti7BHtz?=
 =?us-ascii?Q?GEsa09i5Wk+e79awuAxnCPWIeXNX3sAMsx3jLXfKh5VI06d03unwUgw2KBSI?=
 =?us-ascii?Q?fzcb6k9a/GWhezPGXtV4BvsP9o96PDrkIItUNmJDRB+2yLBULgPR8A1XYwpB?=
 =?us-ascii?Q?erClIj+jTNAP45JjkTN/FNNFa2H20QVZa6hmNpsmOJ9RktB8k0GIk02wKhom?=
 =?us-ascii?Q?FfEbezTVQ5pzgp8N7gYsawfH9iRhVFWw2at4BlJx4ckp8bIRhcBwATQxhfkd?=
 =?us-ascii?Q?lUiyhiCC9rUqE1u1JpGIAaypkeUOlP8o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3QnACU118RhSxX0EtZd0XeivLoP7HcS/+FucTK/rsr8URnWDrgaLil/04cM8?=
 =?us-ascii?Q?MoX1uh2NLINL3WY6eja5BnBm8Nfp5xlqr+2MdNf4YqZTGNu+nBE4CnjkKDWf?=
 =?us-ascii?Q?2i/QQZQ9ZznUGancWZbxPv/efH2ZGqxkQY/E6xgh7WtOPW1l3HlXAyfyOuTv?=
 =?us-ascii?Q?kOq1wlufJudf40SgoFIeOsoitjCItIdYV0OBRVZPEN9fjnRLBkH+/BbN2U6o?=
 =?us-ascii?Q?ekP3xbb1sV5v0UzKHoa+NAOxdtWQzktAU1D0XwJJbP72e7fv6ZX2FYSRlkOc?=
 =?us-ascii?Q?T7XOO96KunkHVjV6WR+plJh1rFoZffGjNtb47jZeg4su+zSFoWlOSqnItyt+?=
 =?us-ascii?Q?gv3fvlPR5pYsOW+lB9agtyxsxpALkUyS3/UPvnZ2o1bYVgDtul63y8MBCAZK?=
 =?us-ascii?Q?Rvork4kwWzSnTGHrc2QZ/eKO0Ia7qdTE7xBArI29oWR2pjbJUxboDhj6zzyb?=
 =?us-ascii?Q?/ZOnADN/JlMzmBrN/gIYGwiD9569d/sY4xq/tE8Vw4J+92O4jZ6qS2/EzOi7?=
 =?us-ascii?Q?5hilMvZuNPW9RMhRuqV2JRmZM5R1UMlWOFGkmH9gLHYaxz8+lMR5WuzaBnLI?=
 =?us-ascii?Q?71bGZl5HlpSZNI3/dbvkC6LnaPwL5u+YsVq7HbTbJCtcSYNkUaU7vqkgE4az?=
 =?us-ascii?Q?ktT/0dN0Ub9IVtEJEUqQz+42jliIZAdciR7P6R2Krupg848P0qAUDLPmWN5/?=
 =?us-ascii?Q?z1OZBYMcvN54TT+rAh4MoXGPZ/8sT79Pn/W9GOK2Er2FOctFjqeFHJh0pMtq?=
 =?us-ascii?Q?/CF3iiiFJX1LeAqpG8lcTSY1nuaiWEkEjzkUmEoipsrFALC349C2ZBdHr0zq?=
 =?us-ascii?Q?4t4Bzu7vbbsI57htiWAnHh+5c30xiJM09EalgrMcCeQ//VmT5rtjYaSlXKzM?=
 =?us-ascii?Q?oaWTWTTe8aXHM6W3gd0NmTs9o57kJsAglK1/06HJJTrUrejFBzAKaWfsxcif?=
 =?us-ascii?Q?nHixxw2/DKCtZxyoJ5msRFD+s9nIX8YbRMACinUC0pfmKz2M3kjv7oYdPSYa?=
 =?us-ascii?Q?VkORpB1Q2QHDk2Zh4pTYr2shpqj/ta36tll1EiqXfg2S6gTm5IBljreWDiYH?=
 =?us-ascii?Q?ab7cMKs+miqK8QUH/9rh0J15gt/bTvKrTO6T8gl6YUbsjLiJykrNS92uyfkk?=
 =?us-ascii?Q?H4j4joSiFLv3KUutvzgJKXTpK0JiwGo30O7WzLU9gDfiKEtTEiyF139kqCcO?=
 =?us-ascii?Q?C7vssbzQ70Pqg+I70QDDo06TEwWqSoy48xv3Zf8c2PSm1FBmQN/BiTY9DTmV?=
 =?us-ascii?Q?2mdFuqt2JOwLNkFmz0n63zeJ+bKudJJJX4aIKUuYodU6V2SD3r1kF1Fqgpcd?=
 =?us-ascii?Q?b/eZ1nlgJeCotBvB539lEb3cpQgGtgoM3fXweKBtAtjN8gbvORe1VOYD08si?=
 =?us-ascii?Q?WBXHmmnJxUenWxrzfWn3zb2I4yI12rhFPL/Z7eDLzzsw2REDw1ESsObmIva2?=
 =?us-ascii?Q?q9pchEjKxEqTeENsCCrgcMxurgEFOeTbggNanc2UIGTjjnloLUqoGetKeief?=
 =?us-ascii?Q?81b6lL02PTtdKLERU82C+E4xdwN8+J94OJhBUZNckVlXIDKj++9mv+OOFTc2?=
 =?us-ascii?Q?hqPqtpCfvPTmhA6OQzVsloiQYGR/tK/SJB+hO4EH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zjAwt+ERLEXhL2IFvSsrwjB8aDk1APrCDIyo4AInvoTygAOM4uX6sDXOmQWh99JOHXNlyFG141KX0UU985wd699kKBHRcqsZQqx2lBnhnMNnQXaH9eYzB5HWDxASuOoPLWQr4+oBZDME6Ulej+GnmhgtJawhf6yFbgcrEoEgfzcqUGX0agSMz4ts6qaVFmVJmPpg7sPA1560ib5JGjmX96D6Lda1xFgNXna7Tra++LmHHJk4E6WaiHropkiVhyZo0U+6CfY0BjOCogIQZ8B/IhUARlRLYEls536mNtpRzlKBU+ZDmBb6S3d120uW/hAm7z754vXFhYMWisGKE6gKVMIXW8ZFVRy9FH0Uj3Zz4SxaF1gIQ8JldsY4FKy6HjWAgEJfbBKIYVtc/2WGzSqU+AhMAujISdJwAkyG4CWIlo0bKYe0h/E5G1mZnbhJXxHPZgoOvDdDgFthMrV8S3wlQAnRXaQIpGKqWRVKmeQfVbde7s9wFocpULW+s1gT8RIRz3Dl1AvlLo816VdfFIaTKxMXvWADn6S7mamJLdLNqCGwgkJRxqf+5eK5+dQyUwxMwb8LPrMGaSUJ8X/VI6WUNhdXV843juYtfP+oEMk+3S8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0c32a2-ad00-403d-c25c-08de0d432fcf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 06:05:35.1077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ki0pMvbX2+xEGn86b5jjuUIjzM9IUJgBulB8zINvy6nuzP9CglZc3sqtwMxMHoifdWD1J4LVukSFDMWok5H1Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170044
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX1Paa6dBm0SDc
 5ZrBvudPKp2+f9b/t6vTTCljBGC4Fq+3pJHuvd0Zsw2KMZhkuHEC0nIi3Zg1tfsZ0ml0rSNs6M6
 AnjhDHOZ0rMko7JA6zWh2X6X4rDBN1HhkNldd5PfphS9okoVgAENrvL7jupxzaL9Y5jWzoY5TPb
 4JY+Jwy2I/4a7HI416p/ouQCLJFdUQu7v75limTM8NojZduCBNm06xZrSm9CpOuKoTKxlqTBuz4
 qZkmrDuGzyynxF4wcfJcsqY2OQTcdyTyKB/T5SJLaIHtgTtSibg/EoUHT1zfPpH9bA6989clu+1
 CTitIRl9TUr9/viNrT5hJs2aocyRlLSvCa+wCsCyBX9+jtAtSxai8aa3PDEtgjWHi3W8XSnKKiu
 8dNPUs3ehUouDF8mf9V5qI20TSHL0w==
X-Proofpoint-GUID: l1Jk0GunDZiTme-nRifiEh_lS3_ViCyV
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f1dcb2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yvBCQdCIYV1uIXlusC0A:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: l1Jk0GunDZiTme-nRifiEh_lS3_ViCyV
X-Stat-Signature: 6eapz6gqwpbj8u1wiy7f9fbu7pta5kuk
X-Rspamd-Queue-Id: 727F41C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760681141-553023
X-HE-Meta: U2FsdGVkX18MHMo02kOZyHIve6AZelZiUgBUqmYLe56LdCwhMx9yfSFGvhY/lW00RF2hNYc7tysR1HICNId8y6Vx89t4bwjtbwLk4cVIzcaRWaiXoc/qg6ZVaFwFRn5rbZukwyHo+BAQMc+KymxOk45bYctPwef7UvBKtcmUTT8WEX0/WsqViS/cNuxnCP3hzY9R7PxZMkwI6KqX9xIpBp/AK/rdGCZnvu2hEptUO5B203OBkEDKeQubynfTDOJfuW2c+p9hilNaTdM+RTliqyZpThcIboVoYscPlzlXavPMmBGCG6hjeCNNoXTBUxpKzJtZi/mjWj9sOD83Q4quqLeDHVTFdDIr+++Pb9HEH3VBgGECNGvvGjfBz7UoQAncQ0jZo5//DcI8p+t/ZTJLZvLxNS5cAuDI/wKZHnBbBYCAhB6e2MP1cDvS53dt+0GjJLisyfRv/7cvbf4/Ftq6quo8ZonESEe09T9M7+rbj62GSyeNk7ydL2uRRU6RSIfII139uJq+wvCChtFcDkGObdbFRxvkN59f16CsH4sxZj44WyZ52t0Ig1q6eS1RF9l5l7xnwAAxpvjnRnc4a2y8XkpH6si7V26y9OSjthvmNjx52dpBJ5W0Mo8DcscYLR++g8v4c3dZ03diC37SX4yishCcfIt8yU0pWWYHAQjwVQoPeV0tlTstwcic1eBYwLgcWSBKU9AHxekXXYP2lGok6UjsQxUiKa9kVxBzBe0cRSYdt09WFeWrPu1ZZWm8BWd9+EJGln/QKgAJoZcl2NNz7OGFWz1Wq0ObEPdakSI05RcsVfT0FNHvbuq6G7qAsOac25Ie+tzRxmqH/GCd1srKmY9cBgULcl5nEIca2LaC4WfgE3ukz8CwyqZiBYhGnxa6STVxD9AIsvWP+7ioNZuu8d3IhyVXOyUSk+4USK6dKAearE8+rs/8IAKk94EXQNxklmQt/ZYoVLSdN8j9NI4
 QIvt2uyI
 KRXI0wc84MkuDRHAb63w2UtOE2vhkV89Ho44EB1aaedwHVoh1kNn81GtEXTmgiUirNlIb0gRUgXKUTHc4sgQteeWDscLnTDkPdfGi3V45uL2RJgA4N4mrKu0we0/SAwcHuApox2581dL0Vj7x+A26PPMAb27KjbqdhgttnN/xi2+C9+Q6p2XYAjal7e/CmGRh+Qw65JOMX/0LYYljx7fneIInrmuCzUyl0hkaI8+IfyLf1Nt663FroIttOOBlWk24iA59YBDwV5W6dohJ8V2EueqEujpGkvpn5xS6b1ZtXp99Qy8kxWhzVI6y2Tk3rI9GXbD+bXwLwLJN0ZbJsPFABQS55BK2d4ZPvx1t73I1pVWHD8yECZlh+/wy+5ulEK9bewk0yVQKTbUoaEOmwnVcKE7PqwUrlMVh4NETLK5K82bMJMbq7fGPWIooRV5mnxu9tQvZ8sLKvW7XyaSA0lbWPANHmIVadzs1mgO+jVSEArymcNAP5bacfhA+tD16cEfSwzaZTY2PD4iJ11JhUockSRcZLgX9+CFrh30RK7/1dI1neapoWPDOFR5yoDYhOX3QFjQU7iUtDcMTwgw1WFP2jeS6PDWcAyEYHVVLfHgkSgdyUuhu3KV2fMLGX0AMGfdaaKhCvVNdwOX6hfKecc42q7mJygQhSZvcPW22yJQ3/L6s17E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> In the alloc_slab_obj_exts function, there is a race condition
> between the successful allocation of slab->obj_exts and its
> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
> 
> When two threads are both allocating objects from the same slab,
> they both end up entering the alloc_slab_obj_exts function because
> the slab has no obj_exts (allocated yet).
> 
> And One call succeeds in allocation, but the racing one overwrites
> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
> allocated will have prepare_slab_obj_exts_hook() return
> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
> on the zero address.
> 
> And then it will call alloc_tag_add, where the member codetag_ref *ref
> of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
> leading to a panic.
> 
> In order to avoid that, for the case of allocation failure where
> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.
> 
> Thanks for Vlastimil and Suren's help with debugging.
> 
> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")

I think we should add Cc: stable as well?
We need an explicit Cc: stable to backport mm patches to -stable.

> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2e4340c75be2..9e6361796e34 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>  
>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>  {
> -	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
> +	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>  }

A silly question:

If mark_failed_objexts_alloc() succeeds and a concurrent
alloc_slab_obj_exts() loses, should we retry cmpxchg() in
alloc_slab_obj_exts()?

> -- 
> 2.25.1

-- 
Cheers,
Harry / Hyeonggon

