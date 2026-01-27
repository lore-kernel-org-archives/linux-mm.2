Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E199D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5699B6B0005; Tue, 27 Jan 2026 15:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541476B0089; Tue, 27 Jan 2026 15:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEA66B008A; Tue, 27 Jan 2026 15:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3F26B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:05:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5E70D3564
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:05:49 +0000 (UTC)
X-FDA: 84378824418.07.2F84E0C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 41BAE20009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:05:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D5OmxzB4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bpQvs8uB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769544346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdbsrMr6c4SGTTGbvhWTgVss7wdFi00vGi0NHnC7X/E=;
	b=IE2csmIUVKAEwqVm4qENBvIpR6UGkqKMJlzyEPuMZMZL/LPB74oN5wq/BFH06AufITjuV3
	nwIEcZAyiH0SanHSIIbnJf9F1V4YA7uGOuGX7VRAekZ40EvhAcSAYnbSXPkfvNeUQGVk+v
	WDzcuIisTSd4/blTFYKKLnesWoqPfpg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769544346; a=rsa-sha256;
	cv=pass;
	b=xwYi81nHJkF2VmsPQ/N4AAVSIOPDFiSeA/98AiSbmWzmbi1fFTWAqCNEsIPXE12WnrI9Ju
	kQpB95eXQuswiAGoeNv0XBPE8ddojY45mQMl7Tgc4PIOqZ9PWtuALqAGaqXC9MfrFaWSkk
	hv46/Q658OSzil/INi1wuUmCifSem4g=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D5OmxzB4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bpQvs8uB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RJwEH51348709;
	Tue, 27 Jan 2026 20:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PdbsrMr6c4SGTTGbvh
	WTgVss7wdFi00vGi0NHnC7X/E=; b=D5OmxzB4TvH+uL5Dd9hLs8jA88q2HvE2iE
	u5Xg4hRhxWoyMTxxmHG4EdNIwJKH9sbgRcI7q5S/5CplBH1g1WF89LsNpa1zYIYx
	MfgPy3kn+LikxybY/nrhaaA1024B80bRqdK+4vfELpDMTJeulaA/nQ5ipv874IX3
	YaxuqxJh8IWS7K5dx7ObVsqSVeBUmvWsu+jdBkvkizcX0Q46uYSOTiqOOqzItKB4
	9U7nZdq3gXcHvp2iSvuTuFQ+oS5fn7688vjenv2IGAQ2/o3lz10WCHhv850zU6KB
	xk1IdLTr7+040Y2R4Ez6co5S6o+UO0ocaMGny+sCcmLvFyaWSPXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2xqr6s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 20:05:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RK1eA0033462;
	Tue, 27 Jan 2026 20:05:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh9wsgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 20:05:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgITk+gMWOpYIerYyETGCdsBGnY5oVoYcA0zbV7em4QTB0ydsYO8XiDD2NIV6Q0Cuc/6rCLxevpBaCNLrM+fFy7Z0KjaN55PW5dXE006ybTWQKOm/fhUpOC+ygJbzEw65YqxWpZD7mHvvqFrtNqpX15Ee/mea4xZSVl2pzU1vXJrYSGQ11CFIpobykxhhqtxhGb//70GFnfSQN5l6R00Zcu/A2A2BFHoyjapjsipckfOhtJsu7Q/0pyoPy240Bq5+dWcV6C081XRA3D1PINfKKlPpf/hxNTeCEQqhoziylCSTsPq3Y0SDfxxT5OVeXoYJDLyjqMPgqhc9GaZknBrBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdbsrMr6c4SGTTGbvhWTgVss7wdFi00vGi0NHnC7X/E=;
 b=Qiophg9skeh7pVfh1N2b7a/dWrO+chBPlfKKNY7LZ9oQtJxhDzH81KFn/fSdxg4B8wp3SYo1D86/ZasXwuvoAXkgU7gg62yMGinBWHVaUVkCPsIMrFEIUTDvNqD194OFKI2ZO77Ya6tBlHGat5bH7lZd/wv2C7IgdAywn9LnJ33eXBLaJFNPL95Fz0blBdqVHbLkSRev5m7Gp0fD4anaXTAF/xeKW4Vb1wgsG/NjUQCF0DA4EqPqS1kKw3dni+QubHXMm+1CVHdno89eMtmBuxWj+sGWYClHb+OeN5vmsXiNft1X3iPjVH0Z6tuEKKL8S38wVMTNQ/Vhp4rW1zSsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdbsrMr6c4SGTTGbvhWTgVss7wdFi00vGi0NHnC7X/E=;
 b=bpQvs8uBvBAqhrhkQY5XHMX/uj3Db/yhihq1vSbiFDc9/WiZpDWiISHLSDc3kiBS9mSD8Xzlfgp4MGOEQaXGejBmb7TPnAjb2pyeBuTGEeKq3BSkky1Lk4jxGp4OdRs+WER6akXvgkMknwngIwTPEJFgv7yqOwKqGHKCBLJEmAY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 20:05:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 20:05:34 +0000
Date: Tue, 27 Jan 2026 15:05:30 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 10/22] slab: add optimized sheaf refill from partial
 list
Message-ID: <sbeakzrtv5iw7645ft5hsg5d4mhdw4xuhiynz5x7xnupk7fzly@goci4kj3xm3w>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-10-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-10-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: b7dbf790-4331-4dcd-32e8-08de5ddf6e18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oI4LQ2qRGM1mT+Qm+YKRMhVVsfDbL3SM/nNN/PMH8BriOkN5AF/yhDs6CbVe?=
 =?us-ascii?Q?rqv/yCBdPvkGeJLrcG/afCGat+makKW3DttvbLHZxcx6QCNexCk8AZXu3efl?=
 =?us-ascii?Q?R1XIPiqjLLApy9amadnR+hvKVU9f0Bpm8VLxKP/ad5xAnbNmS7K4pIGtzMVD?=
 =?us-ascii?Q?DEtqeP4NPJZKl6wNnW0lET0++iFnhy/j7EqT/P38mGt+JsioWarWkQnGKPj3?=
 =?us-ascii?Q?GsDUgIo6nOZ/K4QY0dHtukHde91BU/GlaJFCm6eTSFUyj16PDMsHWlaqJ3XH?=
 =?us-ascii?Q?E8YChJ2S7GR0DwzEPdgdKgVqg0VPpmbs0xeSzZtA/3o7qTQ8PhOZf1Eg/xSB?=
 =?us-ascii?Q?HIsg0IGpGal+bM84ADCEfbaiFfKKnettNZIsXibLNJL9ZJiekxevY0WIqKV5?=
 =?us-ascii?Q?cxRkfKlIUs+o9xlBXix9nu4DTnkEcA5ZS4fsLSd68FmZc4giKuOpOO83tZGv?=
 =?us-ascii?Q?HLR2a2lhhFGXVeAtLgyWy6B7utKblnLotemOFbirGFzjo5QGfptG5MMu8ssq?=
 =?us-ascii?Q?OjxsBnyCgwH2cgHwu2s9gl4MMVJZgw4oLMt/kV7r52WXemH7EEGZeBk/YPdb?=
 =?us-ascii?Q?1R+18cRQWpYJUEm9plL49Jl/VL98jBxgp2AWZTn0YibqpdTuZQbUulscCl9U?=
 =?us-ascii?Q?s273GxldrYVDKb//HZfhZfXBWxKv30Rge/ghdrqR96lCOXqWgChchY6hzXAK?=
 =?us-ascii?Q?+kjIGt3XoHFvPLMwNJN7oF7WjrPBsQ9S9XSCyJ5jZf06aoFBbkvVirKoodv5?=
 =?us-ascii?Q?pPql3jBubfkf0eQdm8GOnc3Ci1XZZjsNZSitY4rb/gCvlsivfzFqgOfElg67?=
 =?us-ascii?Q?tfhz9Ar5dtDpVvv4l4nbYdeFhvNlD3YyjGc1ZF885IbU2NS81CdeEzj++Va3?=
 =?us-ascii?Q?BLDOU+Ft86UA0ziZer/s3F+oLiVFEiewz4EjC6n1bA62Hl83MjgGQV62ntzB?=
 =?us-ascii?Q?WV3r8xUabPgC8my9WB9oWFKqaHWzKM1llRK9AT9FzvFDQ4BwGJcqIQW56gDK?=
 =?us-ascii?Q?sa6pMlI1kj8s62xD4X8K2TwMn75SdHpZSUfczMpGaargdpKhuMJmc3z5h0KN?=
 =?us-ascii?Q?SERuTIQYiGxbXGmsp1yOyTi1XIZvID47i/fqWWChc9+G2Yb0FZIa5PFbsRUh?=
 =?us-ascii?Q?8Yvk6B1RupaChymjs3VegjyUnSX4VelAEUEZfmlqaHkBA4qdC2MVa7l93fzB?=
 =?us-ascii?Q?oJP6JoRgA1ae0+HNEx1rL1KmNbvAlg3EwZmKnhpBotzdUBIHFyltKjgngeJV?=
 =?us-ascii?Q?Hg7jVOrkB1o8SbDwPzFUhP5kaXLCCuHYvL0CB1q2Oy1+ZL5LvPr07fK0C//a?=
 =?us-ascii?Q?rBbPQjXJWhp9wUCnK3UFcnZC7vGByP+PP0QiNvJ06vwb1RpuKJsqr4lpqW4b?=
 =?us-ascii?Q?jyax9HFN30xVFo3zkBlsqK8i7w20RdZzoAnl8zxfztepJlFMZkKkG/EdX6Jt?=
 =?us-ascii?Q?23Xqaz/oVvBtHmBiczQ0bFG4iQ0UC5DMDBVY8I11j0NdwNKvVK7Rexx7K5jh?=
 =?us-ascii?Q?5T7pAfoDyqcehaB0ScDNu/RALnEh19m8BeNFeDLYfmeWCa0Iy32G3LnP6w13?=
 =?us-ascii?Q?9rgfXxYuRXmsNAuFQ8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ch5X7WhnEDSyJqG7A2ftd+Dovk+TPKz8zqaC3khtxeMO4HWI5k4Qny8aI+js?=
 =?us-ascii?Q?LKHZEN6HGLv7GOhBSl4EWeMwC7xD7U14AMS01kuw2aV/8265kQt2TwX6SSZN?=
 =?us-ascii?Q?tnV/F+DvEGF4yyw6AXqlWJ1nlSUMNkQXPVlALI5y/syk/nxc4UhBfpFWFy/P?=
 =?us-ascii?Q?1hE92iGczghxmfscKdvVBCghAo0IwjHAiAY8s55oRJ5tbf7RLxWcoilbOn+a?=
 =?us-ascii?Q?IpE+E9dZ96bCJDeeXUTmGjR6okCXOU/rWiylivouiQzrJ7IGttJcOSSE6vui?=
 =?us-ascii?Q?hvrjMPUAN9KwVvpCoe7GONxrX7dvHRsXlsQ5cPkKn3hPz5JPqpRr+7t1BQ11?=
 =?us-ascii?Q?YsnkIaFk0ydpFl84BmlrQV4uAAPo68tZdWGjsJrXczmlL0GERX19qOQGStZ6?=
 =?us-ascii?Q?1AOXvTi/kVHe6+o7QyR+8Up2bB31jC5ZH9hHBSbH0qKLgty2f/QVFN0P8r4g?=
 =?us-ascii?Q?ZCsI+w1D3W2haVLoLKGS2s7Xwu8/jHU1fKBGMkZFHObtMRRpC9ZbvIs5DzZc?=
 =?us-ascii?Q?4fW/BzBQNu95dp2mkSvXvnMHxN/4g5uC24Tcb32pU75XtbIF1lAVHRyrxW77?=
 =?us-ascii?Q?gbyH+dgG/XzHi+W1azZSPoCWrFutaxjxKv8xSQ6haXVlD3nnQIDy4TOVJ9V2?=
 =?us-ascii?Q?mtNoDDVQs/7ZNpo2MhWHu6ucEjxEDSkAdO1brix8sX2uNFK7rIwhl8QZ4eWC?=
 =?us-ascii?Q?YGqnv0uuuZmQaO6UXMnkKhre+pTA/4tkdfzanubIekeg9LZgFYYJTKadbls+?=
 =?us-ascii?Q?u/cQhlvk7qfz6vrYZEtgUIuq06OPnBOfylmJoNaEi2+UibF0PmPVCku45ef6?=
 =?us-ascii?Q?CniuDcVY1iQ1V7gzNKbS+RsRqW4/kP5yONB1aETiALG4NMYTccl5Hk6x/7mI?=
 =?us-ascii?Q?1purk07kk/8hDjhS3anlq18k5tky9n2kakoMgFzYtaOKAGAuSURATaZUe9wX?=
 =?us-ascii?Q?gIC+K+uAfxjOzAj3xx0b3ZS/k2hR3dFGyVk6iy3RkoYYcKRrg3CQRfXpNt7C?=
 =?us-ascii?Q?ITXw9Uke15k5SKkmX0DJeWbGtbtZpJyG5j9wzs2Ax7wu+9H2aNfmJIXQloIc?=
 =?us-ascii?Q?JA2TtQInWqnmWzeg0ixpTrXuzutJ7ISMIXL41f8a742tuNUiHwdHiZaj+igq?=
 =?us-ascii?Q?o1vglPzrw8H5237lW8ds/7SEgm/AJ3av2Ytiy3sATviz/jvQrDbnjreJBFQ4?=
 =?us-ascii?Q?xDPqn7WSpUwOrqOXhJGJtaV22OUCXQ5Sqx7NZdH6OgcvqXOJpJf4ihWzVFAq?=
 =?us-ascii?Q?LKD9XeJSWEVVveVcHuj9S10bMMS+cbmmr/6U/tyJL0T2ihv+6MiyMkI+7QD+?=
 =?us-ascii?Q?R4tb3GeHulCVj+nfbLmT7DeREKGomylf5s2L87RlURDsLRUMTS1JxRvvQlvA?=
 =?us-ascii?Q?XBeVAsaQZkZXJDHEANpEnpsb/iVpDXkTfWyxJfaV4Rd/C0WvFpKG7QIuNez5?=
 =?us-ascii?Q?W4tljBU7pVC+dr5hU1pFphaebFa4kdFLJuQpCDFh0U4ZvQLksd7cQa8iEh0x?=
 =?us-ascii?Q?V22dBKUdSS0ScF1Ai81tWQ35oecMMGulq7d4M1jJDhNCkNBbBN2HyJp3vth+?=
 =?us-ascii?Q?r2GgLOI3BIqLOxHYal37F79ciY6TxtRFW8Upa9B+WovgfV4tYXboV2ZbvPT7?=
 =?us-ascii?Q?e7URWxjHj5A3CSynSfqzjXQ7wibifgO/yBXhBQt7lnS9409rp3MT2mXrkGJ4?=
 =?us-ascii?Q?fw/pDmynd0mHA2DSvcB6zQCszoG+TnAU9V7G6KqYqcU1RqXKs0ihD1P/lamQ?=
 =?us-ascii?Q?al/qjnrElA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	skVxBhbg6HGucApYn3kqUsNaawXyEKcNogm3cEwPMQWBe8njC3FSaykz/uFXvTYEw3yZ3BY70CEWjLMkJjHRNPiTRfWCvO8lqb6/oB1uB7BM4ny5c8nLSMjurpHJmIWw7dAsZM83jbpJ7oIfK/eNe4FD9fS9AZQL5qWnPInc38hch5s6S2IG/RAzf/CgBxatixux1r84WqGdS2JoQEgEFVKk6Euq3E/0b6RFaKEt6dUdIjhPSLnindOzo9HyNfevfIrDOVW+gxBvPLzrYIqQweZoq7k7SCcNwgXUuW3OF5NCLpED3rZkZolznR6Py3nsjXSZlyHNp9t4MO0Zxc9RTWNEr2YT9319ZF+vAHMGWATdLZBCFyhG0CqYB9C22NiaSGuyfPfoORkj9r3z4iIbn9HGRh6FnF9E/DcZMdkQd/XfrN7u+C+35DTln098MhCnkHbpa5w1s8CUYKYbTZ6PNaA6pSl/ypYJ0LaBr/ek+OBJ09AGfilXsa2RQvE79mbcm3UfQoj9LB0Fc7H9S04x9Q+tINCHDrCQeoXCNhXuoQOobP36PmHzsY7r05WpQ1DZd/Y1cHXdhdK0JvuJGj3QSOxsoCLVD5oSi8jm1Z9PQVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7dbf790-4331-4dcd-32e8-08de5ddf6e18
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 20:05:34.0523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGGDm5XxHkTcKEwXIUsbmvzS8Uyn1uu/y6LVoowaJOQFbE2gDKknTFK90O8HsHxFxEk+vyO6GFfoRXFYLUEbXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_04,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270163
X-Proofpoint-GUID: XKrwJW2DuBAG_mIDi6QGXICT01L9iceV
X-Proofpoint-ORIG-GUID: XKrwJW2DuBAG_mIDi6QGXICT01L9iceV
X-Authority-Analysis: v=2.4 cv=UepciaSN c=1 sm=1 tr=0 ts=69791a93 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=QW509W96TUkqSkKUyPUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDE2NCBTYWx0ZWRfX+1O3hofCOi1l
 l9M1QffMNrxOXxA4t2LvTlAFjAs6vtmOkjuZdoSp3zkdgIctIb7iG2I/stYTbh92nXVFObYf+3m
 4YNEozK2T1gNrgso6l4zZ9gC80EXdqCOgTeivDiAX0/jln6RHoKgVYscd5JgY51kks0qu03vZVY
 pueMq390PmS0xtX2yUNXcIoE2VmnHdY/HVXbwlLUpMAMi0yttbRXZec8SiikLmD49iKDCd9z2nk
 +XweXHEwyqDa2o3pf6RUPyMDKOX+G8zOEZnGu0XDQwGTyR2/Wvy+He8oInOTnU3xveBRhD/lYyE
 YRBqSEFFP5s3ydF9gjiPasOTpimI251vu0Y0HEDEeMDZxO3ZqmKaf57jAm+ZLXq5eJSXtGJfBoi
 On8ulovQ4n+jo1YAgi862zbI7L+279TFz+CCTUYYol+J9BNMClEz4ert3VaVlGaBBs2L0rSpagg
 BQEFX2L33oiknLhuBoA==
X-Rspamd-Queue-Id: 41BAE20009
X-Stat-Signature: eree6qeqj9wbimopjjiytwjy8t9h79yq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769544346-994654
X-HE-Meta: U2FsdGVkX18Lq9l5W1pi7Gr7+92Jh9aso8rOmdoe+nPv1LleJYBfz+BFYtWC4FmnLsW1cVPIY17a9OiBvjw+wgtiG/ekhq8Vy57EDgcyb17qGNUVCLnEInF5bJAC80d19WmxeBaTpzOIO3gg6OCSz7+V4vlmugS8RaWfutLsnZrDA0vhwlYLvom6hymrp8JUOYb/aOTLVWPqMovScYrBlBapJznVNaZOr7S3edhm98V73mnAsyvpMF5YwSVHal2ijZnveeETbsh8f7fSiglgGWicbGmrxUAxdujszh7SYU+hbsxk2oQzxnftfC8z6S5KiLhYq5wFpWTU9aoqMNRsPNsRfcNKcaARoUqjp8kgvn79/fiFg+g3KJjIDSXAOy65Qkwg/YjPvKSPDd20N8OX5huI9gHD4T3yYpm0nF//5ZuoUBEvbZi6oBWr/VTR7qCRVWhGBmwnWXrXuHlceZ1gctOpbQQrEdP5EzllO6pv2LhAKUnyBLe8Xar6I4bCjeapSnMpbJw13O4RHAw2C9098906rxXXOgIWMMoc6Q4Tl/jvuw5nPX9zAnsEwSBUy+IQN1I+HaX2+hPbnL9HvI2COJ1woCv3GuKlZp32rPHGS9ZDfRJmsyCjli9Wh7QiCGIYCUoOVNu+sRCWLRAgPsRqA8Q8QkdR1GhVX1Grs09zNTrCzROwcr44cRJKdaouuXWhFGKLM4ZlFyBnuRcl/y3ZQNnvjcTJnBZKP56CowqB3Rmb/hWefnXbrEVl5aI/DbfPCm1rwtO9I7bzujPU8hk8kA6DQqdjDf2oH9EO8nkgG6NzQqPxNyW570Iqr38ugSDDlhTfVMi2fKnoZrjEkvwmNVdQgYEgDNB1/DU5PKqs6JbHNt3W0jXhiWL3VfOtW5BzOPgySebc1aiUP5avhQ++SSHfxQ7WpWDmL1Xhiv2CMzk6u22yc/Gl7tIBS9jM1kna8AHNJLYIOQdYtbHXfxo
 E46rwShI
 8a/4YpWwNMCDU5mMIQbTFpQNeIblUrTqLVxvBwCXcqbWfpJelSSBn1NziUaTLKQuUehwk6G6k5xDaCg8A13C4uOlBgsOVx1fCi8/9Wvq2gwbuf4epj2pHR1EOaVYun7nj76cMc43CbBZWGASbR6D+L1RdCfXRaz/XPALC1NaCjnELG8xiJR6osH7hfD1n02R4faY3LARSNRifujxNxnRiLEOz9KRjkZtD2QCDDrFg0rnKlYE2P8CEbs6URJcYDvddIlkr7g0xQrAHAFTcv+KRQTfo1XludILm8OCpOByAKJ1lARFBSjiJH+5TTjCyNM74OJGb6I9Uptmuggbd5ShwgT3aqxzBRHIPJrB8KuUprboSvwTyeg8x2cP2xFImqgTVsyzgKE8+IjXsePxIxMWVMioYoDXONXjiG8Q3WJqI23Dv1M/cz9MPE9PuMKE05jg01hnIjIMULf0oSJqmlQZLGitJ6GzJhHqDIv1smrS55v19isypcfM094phbzFeIdHVk/K5W60oKbsXsArgAjAlJxTq25bEnZiS9hkFqxhusBh7FtYPp8IN4hANZ6cdE/K0FfXOzJYkwzCFVGWqw/+nkdCZJY2Ywspk8FDOeN5QuUCfuUqRtTIJcxI4d5JsAOczZn6zhgYc4pU3O7Kw8QjjuNxpPmsvbnd1l8nXqRnsImCOo6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Introduce struct partial_bulk_context, a variant of struct
> partial_context that can return a list of slabs from the partial list
> with the sum of free objects in them within the requested min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list. There is a racy read of slab->counters
> so make sure the non-atomic write in __update_freelist_slow() is not
> tearing.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions. It supports
> the allow_spin parameter, which we always set true here, but the
> followup change will reuse the function in a context where it may be
> false.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> 
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slub.c | 293 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 272 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 22acc249f9c0..142a1099bbc1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -248,6 +248,14 @@ struct partial_context {
>  	void *object;
>  };
>  
> +/* Structure holding parameters for get_partial_node_bulk() */
> +struct partial_bulk_context {
> +	gfp_t flags;
> +	unsigned int min_objects;
> +	unsigned int max_objects;
> +	struct list_head slabs;
> +};
> +
>  static inline bool kmem_cache_debug(struct kmem_cache *s)
>  {
>  	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
> @@ -778,7 +786,8 @@ __update_freelist_slow(struct slab *slab, struct freelist_counters *old,
>  	slab_lock(slab);
>  	if (slab->freelist == old->freelist &&
>  	    slab->counters == old->counters) {
> -		slab->freelist = new->freelist;
> +		/* prevent tearing for the read in get_partial_node_bulk() */
> +		WRITE_ONCE(slab->freelist, new->freelist);
>  		slab->counters = new->counters;
>  		ret = true;
>  	}
> @@ -2638,9 +2647,9 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  	stat(s, SHEAF_FREE);
>  }
>  
> -static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> -				   size_t size, void **p);
> -
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max);
>  
>  static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  			 gfp_t gfp)
> @@ -2651,8 +2660,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  	if (!to_fill)
>  		return 0;
>  
> -	filled = __kmem_cache_alloc_bulk(s, gfp, to_fill,
> -					 &sheaf->objects[sheaf->size]);
> +	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
> +			to_fill, to_fill);
>  
>  	sheaf->size += filled;
>  
> @@ -3518,6 +3527,57 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
>  #endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>  
> +static bool get_partial_node_bulk(struct kmem_cache *s,
> +				  struct kmem_cache_node *n,
> +				  struct partial_bulk_context *pc)
> +{
> +	struct slab *slab, *slab2;
> +	unsigned int total_free = 0;
> +	unsigned long flags;
> +
> +	/* Racy check to avoid taking the lock unnecessarily. */
> +	if (!n || data_race(!n->nr_partial))
> +		return false;
> +
> +	INIT_LIST_HEAD(&pc->slabs);
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +
> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +		struct freelist_counters flc;
> +		unsigned int slab_free;
> +
> +		if (!pfmemalloc_match(slab, pc->flags))
> +			continue;
> +
> +		/*
> +		 * determine the number of free objects in the slab racily
> +		 *
> +		 * slab_free is a lower bound due to possible subsequent
> +		 * concurrent freeing, so the caller may get more objects than
> +		 * requested and must handle that
> +		 */
> +		flc.counters = data_race(READ_ONCE(slab->counters));
> +		slab_free = flc.objects - flc.inuse;
> +
> +		/* we have already min and this would get us over the max */
> +		if (total_free >= pc->min_objects
> +		    && total_free + slab_free > pc->max_objects)
> +			break;
> +
> +		remove_partial(n, slab);
> +
> +		list_add(&slab->slab_list, &pc->slabs);
> +
> +		total_free += slab_free;
> +		if (total_free >= pc->max_objects)
> +			break;
> +	}
> +
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return total_free > 0;
> +}
> +
>  /*
>   * Try to allocate a partial slab from a specific node.
>   */
> @@ -4444,6 +4504,33 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
>  	return old.freelist;
>  }
>  
> +/*
> + * Get the slab's freelist and do not freeze it.
> + *
> + * Assumes the slab is isolated from node partial list and not frozen.
> + *
> + * Assumes this is performed only for caches without debugging so we
> + * don't need to worry about adding the slab to the full list.
> + */
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +{
> +	struct freelist_counters old, new;
> +
> +	do {
> +		old.freelist = slab->freelist;
> +		old.counters = slab->counters;
> +
> +		new.freelist = NULL;
> +		new.counters = old.counters;
> +		VM_WARN_ON_ONCE(new.frozen);
> +
> +		new.inuse = old.objects;
> +
> +	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
> +
> +	return old.freelist;
> +}
> +
>  /*
>   * Freeze the partial slab and return the pointer to the freelist.
>   */
> @@ -4467,6 +4554,72 @@ static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
>  	return old.freelist;
>  }
>  
> +/*
> + * If the object has been wiped upon free, make sure it's fully initialized by
> + * zeroing out freelist pointer.
> + *
> + * Note that we also wipe custom freelist pointers.
> + */
> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> +						   void *obj)
> +{
> +	if (unlikely(slab_want_init_on_free(s)) && obj &&
> +	    !freeptr_outside_object(s))
> +		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
> +			0, sizeof(void *));
> +}
> +
> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> +		void **p, unsigned int count, bool allow_spin)
> +{
> +	unsigned int allocated = 0;
> +	struct kmem_cache_node *n;
> +	bool needs_add_partial;
> +	unsigned long flags;
> +	void *object;
> +
> +	/*
> +	 * Are we going to put the slab on the partial list?
> +	 * Note slab->inuse is 0 on a new slab.
> +	 */
> +	needs_add_partial = (slab->objects > count);
> +
> +	if (!allow_spin && needs_add_partial) {
> +
> +		n = get_node(s, slab_nid(slab));
> +
> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/* Unlucky, discard newly allocated slab */
> +			defer_deactivate_slab(slab, NULL);
> +			return 0;
> +		}
> +	}
> +
> +	object = slab->freelist;
> +	while (object && allocated < count) {
> +		p[allocated] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +		slab->inuse++;
> +		allocated++;
> +	}
> +	slab->freelist = object;
> +
> +	if (needs_add_partial) {
> +
> +		if (allow_spin) {
> +			n = get_node(s, slab_nid(slab));
> +			spin_lock_irqsave(&n->list_lock, flags);
> +		}
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +	}
> +
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> +	return allocated;
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -4909,21 +5062,6 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
>  	return object;
>  }
>  
> -/*
> - * If the object has been wiped upon free, make sure it's fully initialized by
> - * zeroing out freelist pointer.
> - *
> - * Note that we also wipe custom freelist pointers.
> - */
> -static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> -						   void *obj)
> -{
> -	if (unlikely(slab_want_init_on_free(s)) && obj &&
> -	    !freeptr_outside_object(s))
> -		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
> -			0, sizeof(void *));
> -}
> -
>  static __fastpath_inline
>  struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>  {
> @@ -5384,6 +5522,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>  	return ret;
>  }
>  
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +				   size_t size, void **p);
> +
>  /*
>   * returns a sheaf that has at least the requested size
>   * when prefilling is needed, do so with given gfp flags
> @@ -7484,6 +7625,116 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  }
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max)
> +{
> +	struct partial_bulk_context pc;
> +	struct slab *slab, *slab2;
> +	unsigned int refilled = 0;
> +	unsigned long flags;
> +	void *object;
> +	int node;
> +
> +	pc.flags = gfp;
> +	pc.min_objects = min;
> +	pc.max_objects = max;
> +
> +	node = numa_mem_id();
> +
> +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +		return 0;
> +
> +	/* TODO: consider also other nodes? */
> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +		goto new_slab;
> +
> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +		list_del(&slab->slab_list);
> +
> +		object = get_freelist_nofreeze(s, slab);
> +
> +		while (object && refilled < max) {
> +			p[refilled] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +			refilled++;
> +		}
> +
> +		/*
> +		 * Freelist had more objects than we can accommodate, we need to
> +		 * free them back. We can treat it like a detached freelist, just
> +		 * need to find the tail object.
> +		 */
> +		if (unlikely(object)) {
> +			void *head = object;
> +			void *tail;
> +			int cnt = 0;
> +
> +			do {
> +				tail = object;
> +				cnt++;
> +				object = get_freepointer(s, object);
> +			} while (object);
> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		}
> +
> +		if (refilled >= max)
> +			break;
> +	}
> +
> +	if (unlikely(!list_empty(&pc.slabs))) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +
> +		spin_lock_irqsave(&n->list_lock, flags);
> +
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> +				continue;
> +
> +			list_del(&slab->slab_list);
> +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		}
> +
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +		/* any slabs left are completely free and for discard */
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			list_del(&slab->slab_list);
> +			discard_slab(s, slab);
> +		}
> +	}
> +
> +
> +	if (likely(refilled >= min))
> +		goto out;
> +
> +new_slab:
> +
> +	slab = new_slab(s, pc.flags, node);
> +	if (!slab)
> +		goto out;
> +
> +	stat(s, ALLOC_SLAB);
> +
> +	/*
> +	 * TODO: possible optimization - if we know we will consume the whole
> +	 * slab we might skip creating the freelist?
> +	 */
> +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> +					/* allow_spin = */ true);
> +
> +	if (refilled < min)
> +		goto new_slab;
> +out:
> +
> +	return refilled;
> +}
> +
>  static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  			    void **p)
> 
> -- 
> 2.52.0
> 

