Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C71EE87821
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 12:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606136B00AE; Tue,  3 Feb 2026 07:32:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE0F6B00AF; Tue,  3 Feb 2026 07:32:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495E66B00B0; Tue,  3 Feb 2026 07:32:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 37A576B00AE
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:32:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A52DD4BEE
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:32:29 +0000 (UTC)
X-FDA: 84403083618.15.05F68BF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E4BB180011
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:32:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y1spzYQ3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=STtbmXh4;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770121946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjqFEDXdqzLwrSdbdCGDa7d89HLanfRIMbljB637Axc=;
	b=10Mnt3BDajMqN4CSJihXe5PKoGZHu/6cDTOx0fvdv7fi+96zOoiMsOBwX4GZojfW36GOt2
	xULFmnkQ7MjgQ6fRkAiZaXE4kLnpHLRH1Xcckf2vKwDEwQ9EWGaLInyp0Pn6FWsk6iqJHl
	XDBlMOGg8Jdd7fqBtx1aif/spXGVh1o=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y1spzYQ3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=STtbmXh4;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770121946; a=rsa-sha256;
	cv=pass;
	b=0uC/rxK2HcYDjhvRasUl8t4rPRig6tm6LnpuKpJ8Sx3FwigwELVnV/J7HXptmCh88/TQJz
	mj3rURHlk0yLAtB+VxHRGzdm7ra/iBeZdWdNLL3iMUqkplk3zjIFtamRWQ/Kb5Ctws/8wZ
	J+53haLvNrZPr5pGThkSkJqpWHTCrsc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vWCL3766261;
	Tue, 3 Feb 2026 12:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AjqFEDXdqzLwrSdbdC
	GDa7d89HLanfRIMbljB637Axc=; b=Y1spzYQ35PkhipeDWnL44xFwgwGpvIu7nF
	hujF5x6Jl5iSvnnzlanqQTG0/0N7nl83psGBgk9zaJXMv8vYkG9sChuuGQLU88fW
	yCVl8TXvdiuyq9fccTAkrRRkVi0qBp7xZK3CehkdGMES0es5Ep9jj2dRH216aZdS
	EpzUP5RiisR82uoSHYj8gzcd1d69FpTGnAeH42eTHEXOmakIXoNheLrWPwxzYCPU
	Jr7H1uzz6hoMBPs1S8kqEhuJxuJIydmRfr7k3BLlDehpA6gHwspZEdeiIx5irJ9x
	A5ALnhRXQULDlZ21j/xTmmrC8B1IK2aIUILK+fPt8FYjLzK9NutQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arhkx4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 12:32:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 613C3W0M002183;
	Tue, 3 Feb 2026 12:32:16 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186m9ra7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 12:32:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izAzTL2L8JkaMYK4mgoLNDdmUkgApC0QWzvPUl85fKMPMRBDDx1kG0EqkqZNYN+/K9GgIwe3BJc7JFjTUCr41WvUlak/P2wSd9Fxog84wVUJzaTqlCIlLaayXjq5t9DxWE7dN7XQBjvfPtLiFA1b16zWPHKifAjbg5OLBZ7tv/3uSJ2OnGWE1mcRyCvrQYE8n/4DKOzicAvxj+VXoFBCeewR6Ti8p/RAcCIoP6lPS0DlnHUHP+do0wgH3JoYalz8u6JIgcvRIa121bRQlBEMy3om3QVywylbiLc3o26oFXrNtkMjd+fQobGAONa7vrDVXlzcoCH8tbsX1t5Pa99zOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjqFEDXdqzLwrSdbdCGDa7d89HLanfRIMbljB637Axc=;
 b=KO+vG8YI/vO3SVgxtBMk0RSexRD7duruSL8vvyo1ple8wuD3CdCT5N1RgDSAvpk8Rg4yD1iGcThwcXJASPF1MScK913w9v4kW0UwhVdPLS6uvGDmn2Ou3BySJSOTojvhxEHIgDNYxhzd5MgRdWDVkw/h55saNB9hq6AQNoabrns8uaKjHErYFVhIxIPooHzkehM7D0saJqVdaythA8c59WaLxUZwEiBdtc3qxnkhHBTVVkcsJX8xTaKojywTueQBNatFpE1NBHSOaTxHolQieN1anhq5+2S5FpvqEVbhBZnsfTOUwCVUzRDpoRLrFR3AfX/r646Aq0GE3A8IjAFABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjqFEDXdqzLwrSdbdCGDa7d89HLanfRIMbljB637Axc=;
 b=STtbmXh4rj2oUUWG2LEjPSy0NbfbrcpybK/lwBiXyNCEkdVPnL6e1qOmCozomWjU9dVtzOQlV+Y7dYy7+E5Yo92KaAkgcx21Wy/5+Bx8y/zjbK0bEoryoq3cIENSUIqAWeW0Js4eFs7v8cMKffsVRciApvC7ZJDMymfMA0DIC60=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPFAA02B7A0B.namprd10.prod.outlook.com (2603:10b6:518:1::7bc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 12:32:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 12:32:12 +0000
Date: Tue, 3 Feb 2026 21:32:06 +0900
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
Message-ID: <aYHqxs2bkSEFOqZZ@hyeyoo>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-3-harry.yoo@oracle.com>
 <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
X-ClientProxiedBy: SE2P216CA0129.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPFAA02B7A0B:EE_
X-MS-Office365-Filtering-Correlation-Id: bc6863ad-3c24-45c4-cbd8-08de632041b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PY5MVm4s3O2Vf6ZP4InmslbvsfxGMacZ9y+fCzEvHaIWrvtVQtnQWjQIxp68?=
 =?us-ascii?Q?HixfahBBCxLhpwOYeepTZVLCLFqMQIFI0Awqd3oHjQpkfo6OKqjtWC7xMcO+?=
 =?us-ascii?Q?lG4sQX5eeE+3lh/s6oAeocZNMA0Y0rcLm3+m3bhpQP/1AUq0HGw7/0zL1JMP?=
 =?us-ascii?Q?Hjfn5Uhfv1wOT+NGYAfoh/AQGtdzqL8RafF3avuub7P2oykm9KRYk+i9RsLm?=
 =?us-ascii?Q?0bLR9S5vKotbh4oPDkX1ddv/DN8yEA3ydfITSoBJBt10bw3reeDM0R+Io9+9?=
 =?us-ascii?Q?eK/nziqTrnsSwmFCE3mMPaJH7JH3OCJpG2ckiuGw5RxKSP+5mkWya6kZQn6N?=
 =?us-ascii?Q?dE/CURqrMw+xHtoYHNkmWn85tiw+V8RabYrvDMlbKjXwg7L6CfYglFEMzqi/?=
 =?us-ascii?Q?f+kbf9/22jCBdzPpEkUgo1lIm71+FEeNWlCNGNyRDPjHbN54HBbApXxCaOLn?=
 =?us-ascii?Q?emA6KWez28I1NXSeD606EFlBuUKuA3xDK0Ahfd6CuiaYl9OH3wL5o2txX3DO?=
 =?us-ascii?Q?g0MELoPNNpbmz5M2emm1RNxV96n+6H4GdQc09LrKP5ykltWcIpox76MJsTWX?=
 =?us-ascii?Q?eJ+LHs/E25logwdQCjtYLyhAAd4HrPwJkiRibZM5uS62UCIjpd/25o7gPlwL?=
 =?us-ascii?Q?MK+aMoSPeWyYB3XhLRSg5DKeMk5zvUh5nPE7RXuK9jpynwECP5OQ7AbCyyj3?=
 =?us-ascii?Q?8mtmFRPx+v7eIbwWmyUqEgtSkj5bLloGZlZzXSqBIcZ0dNr0RGsl9eFuvPch?=
 =?us-ascii?Q?s5wRGrEUEFLFeXfBlLApuXePkVyVrqruGGFMGJPooVOr3ddtauqmYMYx2752?=
 =?us-ascii?Q?PUf+0sHzyYRf9v5cupEQeC/b9FEf6GqCctQUI8PrFNRTxkrUGUi32KaH0rKA?=
 =?us-ascii?Q?FgnM/UonZS4S6+4ngyeJjbnyEuPk7Ib1gdXrnwoJsoIgb3cyEf31NkdBk5O1?=
 =?us-ascii?Q?QN0hSz5jgvm3HC13Alr902oLAABR3d+tqSTec8bmZdcbPzUiSwYJxjJfc2G9?=
 =?us-ascii?Q?6RBuXaIVNhdvfkJwZekfZo1/GCyS6J3E12TilM0kN8Vc1zlAuEjXGrOSVyrJ?=
 =?us-ascii?Q?N8A6yMjln87ZZVSPQ7sFe5pwQ3B+iPZg8d8FyD4ZnA+QOPM2gsmhXkC8XxWk?=
 =?us-ascii?Q?jE3xwGQ8DD8das5T/YBKW69j0kEU8tzUWoNyUhZYReuO0O2oIuBHL/tMG5W9?=
 =?us-ascii?Q?yGXOqZbREdAUwCFK16iqQonWLKjoE+3xZ7Toj9uRO1XKGT/rm13Qb5gJ75vS?=
 =?us-ascii?Q?2sJksk2PSMchL3uRQV5wwPLsNrpxWxACMhqoL0muB/uWZFrk23tlPw/a+Oc7?=
 =?us-ascii?Q?mfRdUnBhgBpOrcUMuGYFCpr7t8MlYeqe31zoLZctL6Sq/WjRWdCb7y8DoGuy?=
 =?us-ascii?Q?GjTYl6rqvj+s/rCP/5Ik+sk82p7sHg//t8Abr8mn0Mp0tRrTOlXN73yU5QiM?=
 =?us-ascii?Q?M+oeiGxdPYUo/D3npg8MK/spM+UtRo4mqzbjiLzJRah5xJ98w0rUZB9iwdMi?=
 =?us-ascii?Q?slZK1wd8+ArCHE5aw8WTy4NVLknVCTc6Z1WQx+LACfJIsZvzi5s2sViqnsCv?=
 =?us-ascii?Q?6YV3IAt60ayxUpvM2dg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JvwpbE9x54ccCr5NQDCPfm+ZGjbqLYDzrMlFZH1UUS4H1MYVQso65YLpYJx6?=
 =?us-ascii?Q?5IER0e2fkNsd5GFIbITwJ22cTmv5czpH9OSGLcYii33ErpvhLJJdeHMIwwvU?=
 =?us-ascii?Q?bSIXVd8NFC94iIkS3OYzZNt2NGHkZMKxp8HUA+julCv38zvERX1XQapXcD58?=
 =?us-ascii?Q?wV/UuQqnWMp253hsRXMtqg67ixUGiJgq/aKEL+J4oZMpTVyN2o0L29zyxEjX?=
 =?us-ascii?Q?aVoz9kp6hRRhWgX0nXlgWu7/bwaUhzLIne4Z3WymkBWohlg5+OHm6lTw/MTv?=
 =?us-ascii?Q?+1ZH+x/XqcTyiSE3sHZDqWVS3+leEFmJqRaIKowaCREbyEDSG8ymujhgYQEd?=
 =?us-ascii?Q?ojR4vVvqKZZkkShog1zrlIPtIDkz7IvcQ6vKUMmybmF1F36QmowfaoFCNWZu?=
 =?us-ascii?Q?PmPheKW2AqDYAqLL44WYLevHmCtkg+oYaqpwZz40PCt/oCFDCmRNTL5Kv0hi?=
 =?us-ascii?Q?f0BFTlLiITWKj53JLOgmc5aC8dCCJqyhfeIda+eLJQezYxD7Dy+PDxF9+DWe?=
 =?us-ascii?Q?/slLVt5n6uUbMOxtWgx0+M4NdlOabS7UsFZ7vWT+C1QZ1NYxRQaWIL1y26QB?=
 =?us-ascii?Q?TcG904h8hW0XXvmqMjbwkWXJ2+zx6v9w8KFwoXMWxi0YrncMHetVkoDPrv6f?=
 =?us-ascii?Q?mmK7DZlKsn5m/S+Yhm/l4cR28NL1K0ukI4ISQz2GRMX2MOFRMffL1aIpZrqH?=
 =?us-ascii?Q?o5wdA7mAdEf13qmpl6XpH8WycNsuqZGn7bLHGkT5r1345DGK3msutlFQI4Ek?=
 =?us-ascii?Q?XpHI4zB/Uy0e8C9i3foaVi8+nLv4OfFQBDdKLDyYFC4hhsbqJeQ2jWnF2xeg?=
 =?us-ascii?Q?EuwOlxaXkZt1UEg/bNhfTkz/CxiBthpis7OEBIFxNzy+A6tdYrSLiM6CEqzb?=
 =?us-ascii?Q?GPNBTE37/uSmPNwjhADPoc00UDN45mi0XHwejO4WMGrqDCKwtfov77ose6IN?=
 =?us-ascii?Q?P3us+bydNKjPkDxuRQR1DI6F4HNN7G/I7EXCyNy92Q9/MppbguC1mPrRFwmX?=
 =?us-ascii?Q?jgap/b7lt6nYwdHORAfuZGX0HlrVkqYPhoG6vrQ9pubta/J2QqkNvAZPXJan?=
 =?us-ascii?Q?WV+Qs3VONjLbriaqujQ6ZlZhDaqPK4K0PZxulB7dLdUoQM0E+5z4gFOCw2Ui?=
 =?us-ascii?Q?uA2dwd9FFrqb4u6F425so4Ps6xo7zApgkg/QskmkbrBG+t3TGcZsKrmaUFS6?=
 =?us-ascii?Q?9q43dfk9FllkRS9RjYSW8oPPqratfhBQ4LCbKNX7w+e7cJNCLtNKqcHvtf4g?=
 =?us-ascii?Q?btBslzNhqAxpVzGjIzOgdYEd6x6LN8Lmx1pQBcAUVKh02NsXP2MnlH76TkbB?=
 =?us-ascii?Q?ejaoUVTlMUVgqUm07G3Y+Fy2LL8z/N81lyDNfhGh40cRXvTIGcpebBPNHIxD?=
 =?us-ascii?Q?YVxjDRzAM0WM+tp1gCdaZS3AP4WCH3sb65orjM0udOpGmCF6WMoYl7Ok1ERh?=
 =?us-ascii?Q?/lkupbM6FLJljFFPQOgiQJdh0KuFzZvUugOeBVNPERlu/zdatn0FqqlBUqto?=
 =?us-ascii?Q?mnzG49Vlwdtd7i5VY6YmoAdpQA2CcQAf4mk4Ggo1L4Bpr1dRZ/m5O8bqA+TU?=
 =?us-ascii?Q?3FZqh8ODVHx3rJRAmm3KbGlncXAxzo/B6hT5EUkKvQ1I71h+vhsmNwnTNZD4?=
 =?us-ascii?Q?u0xMQYrDaKlkGR4AoMSZ8bjALRXPdPPC7zzZTacfX+voJYvQdiGXC6mC9IJ9?=
 =?us-ascii?Q?EgtBhTxlHNXU6pvq2xo/ffGdnBw5GgsPNwx0wx99049+M+HwUu+A/3jULJeU?=
 =?us-ascii?Q?AVRNAUl50Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5oY+QARoe/Mk54zXEmh8FrqN60T5AjAseh/VLjNCIMPHlSb3gPi11MHCqsshvSQ9GtGProFV4cQM2oDs9ysS9efWmHxcj+IuPFlCObvlNm3G7MnunCOh1DKCLxKCqbgZaYtAH2QJ5FgcLtgsniDVly57jrQ9kY84NL5tRRgpKfalrG1Bzm1QifnxKC+gZoZg6Q7umTZW15lCwOEv6q9qUp9uhM9+HW2ANMxLmbFk4MonhLA9cR8PksyEYe4e8V5zuTFqIJNkHnDcfv5L1uVH3VYT1g/Ezs3idSbt4Um4tXhX010sb026TEQ7hjJuUo41v7O6uCFdVDGLnsbY/lC/FrLSkmbr/Hkx911Jk4rnSQ140O6RaO11pfDoLwPzr6X/u5jGpVAeTMBglqzVhRoxJzE1kTDOJY0ZB7nYPfBRJdCkeHG+FLkyWpaX6qnJ/uCwRAQj0VFg5JXN//crTwquID4HK5CbKbg6Hjy5uvOXen/HkVmsFI2O6sAY0hjUwpccl+hlcPT2ZpRwuH+qtu1vcduupWjrKoJWJbc4lU1OcCf7ydKETWfF2KND2z83oOd5TzeEaem2qLIlXS/q6/SgwxFujhxxGj0UKH0QCArbfSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6863ad-3c24-45c4-cbd8-08de632041b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 12:32:12.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PumQpLZZh6T2MmdmhOp82b4hRNiiPsf6YbUC3d9vnjbMLhqCB8y5AMDQEYiiRAUVjwaOncwYz4FFsEBnCLWSZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAA02B7A0B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602030099
X-Proofpoint-ORIG-GUID: pKOeez1a0_VAQAYltpkIPRWFZK_qad0z
X-Proofpoint-GUID: pKOeez1a0_VAQAYltpkIPRWFZK_qad0z
X-Authority-Analysis: v=2.4 cv=fdmgCkQF c=1 sm=1 tr=0 ts=6981ead1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=0FvuosERPnb-HPFoxRcA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEwMCBTYWx0ZWRfXweL6XYiyzzdI
 KYwEabA++vdAPTMrwl7g6GEjrZElcgVJNIYnt0kp6i8Q7peeb/ou/8SCbX00WobrOmytDDFj5Jj
 zDqp+CiBaKh339x4hSuTdCWZOE1EQJYBqYM45h67InkMN/2Sklf2WZP2Tz6nxwwikGlEVsgK/1X
 lwim7S9lT1SirRtjxtvpZTznK1WvuCTadfN4+cEkHEfLIhTNRQn4zFO3OeL6ah3GYFu4tXN9z9Y
 uEqL3x+hFQlFOKJ2RKAqWLlt27M/ByVrwzDo7JIBYxm5bN1GTP0e8yg96fQiK1ft2ig4pnyZt6b
 zNsIg9uau0G8EedaGCoWb1WW6ODe8a298oZdb2/j4cP8Co+3DSUumAohFaGYA8qLEF4ENtluHHU
 Jm6+s1/c0SAmcotPABMOzkG/DJzvyIVL/GPS32MFWeyklcVDFkYJvWjNkDGcSlLIK9Kf9Af10B5
 EyO1X8Qfp/2orW/JuSYce6CoTymTtd3XJRR8cu0o=
X-Rspamd-Server: rspam11
X-Stat-Signature: 7jzwaizfe6xgx7rj6i1unrx7saot8fsf
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E4BB180011
X-HE-Tag: 1770121946-672220
X-HE-Meta: U2FsdGVkX187LlhnDVqlvx0A18TLz49bYDNFNGnxLfbdfpCaWTfQlnER+eN4mtWXK0dQhDiGXaTOeu7ElyA/whkeBR6PPgs6gevAEqNhgmpo4fCCqqRUaXv0qWu2K1Be5PUrrTn1Tq3Av4TdAivcaGS+uvkKx7u/mgibyLi+gqEiOO9M84QTWmApj9BVeCmDnE5c2uuUg4dVcIH7EWX8VjyzYilOh7piSHQpg6yLxMqVQ2b1SHvDXlX+utwc14Nfevd8JQPpoqdu+xlKctzN1mutGpYWDBgPb+vf8wKlWqkbQ6N+NcGroXggaZPZLU19LOPfADEsHPmLi6ZxRi5YJ/lFQ2p+UBkkoLTe8kd78Uv4p8utiL+35ldcU1hUn0B3ZZ7aPlw0MaQj2BK/N676NSUqkFmlYXDeYMfjD9x+STPmN5nad2SR2bfQQpEchwA6/G4nyMr2MLgy4ssnT9103xqwZOWaPRYaCNgQEmtM+ZMxkrN5zUoFup0kvGxJlOcqC0FTqymuDep2eXBESLHp+cGR+tTl2LVpcM8hiqWhc4zxzO356nc5QGgwXoGVQJiVZUkfKuPhovl/sm5cmeDPRcdtnarKZ2Cn8SNiFY4aSLN/X1KZhvEJjmGD57ZOb5M50JzmiYnGyIfdY4SIK4nKPDoQFkvT/vGMfO1obBVcL6UVE40MRXae8pOayy9/KHX+5CWHmGa51kz+V1N9tPMtkThXtC1umLJUS26hxPadIyml2BL3xRJBmYcm1nlwRVoFI0aBsAXMTVmMpq48jccCo30NH8jFmfbofNNlBI2xoq2ZLsFZPK0u7LJ7oyw8o3/Stsx6CPik4pxYTr8bFqh70WkoO5CKY7qLauWcv104ji4nhpyOjs4lLYqScJckEuDxec+acXlx0d7qVCjrkGgDm500JfjlH2LVKwdN2KgNTNsJ+GiFKcDjah5p8oBupIB5GDmEOREvU+COITyT4rT
 4wLFw/T5
 t1ExZ1np13kbd0lrAe8qcF/YWTRdBxTurkz52p3wyTzxud9h6CVj1MSZJJwQ0wIgF1C0Ih7S/wmkmZaW+lpom99k2e1bfnzdFMnpQNWdd8NaEmGTK2j8j5j04h6epgYnLJX+/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 07:56:16PM +0800, Hao Li wrote:
> On Tue, Jan 27, 2026 at 07:31:51PM +0900, Harry Yoo wrote:
> > While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> > slab objects, it prevents slab merging because merging can change
> > the metadata layout.
> > 
> > As pointed out Vlastimil Babka, disabling merging solely for this memory
> > optimization may not be a net win, because disabling slab merging tends
> > to increase overall memory usage.
> > 
> > Restrict SLAB_OBJ_EXT_IN_OBJ to caches that are already unmergeable for
> > other reasons (e.g., those with constructors or SLAB_TYPESAFE_BY_RCU).
> > 
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/slab.h        | 1 +
> >  mm/slab_common.c | 3 +--
> >  mm/slub.c        | 3 ++-
> >  3 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 8593c506cbf1..a5c4f981ee8b 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -388,6 +388,7 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
> >  			unsigned int useroffset, unsigned int usersize);
> >  
> >  int slab_unmergeable(struct kmem_cache *s);
> > +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags);
> >  
> >  slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
> >  
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 904414c3ebb8..d5a70a831a2a 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -174,8 +174,7 @@ int slab_unmergeable(struct kmem_cache *s)
> >  	return 0;
> >  }
> >  
> > -static bool slab_args_unmergeable(struct kmem_cache_args *args,
> > -				  slab_flags_t flags)
> > +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
> >  {
> >  	if (slab_nomerge)
> >  		return true;
> > diff --git a/mm/slub.c b/mm/slub.c
> > index ae9af184a18b..0581847e7dac 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
> >  	 */
> >  	aligned_size = ALIGN(size, s->align);
> >  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> > -	if (aligned_size - size >= sizeof(struct slabobj_ext))
> > +	if (slab_args_unmergeable(args, s->flags) &&
> > +			(aligned_size - size >= sizeof(struct slabobj_ext)))
> >  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
> 
> Hi Harry,
> 
> This patch looks reasonable to me. I just noticed a minor point that I
> wanted to bring up:
> 
> It seems a bit self-referential that SLAB_NEVER_MERGE already includes
> SLAB_OBJ_EXT_IN_OBJ, but we're using SLAB_NEVER_MERGE to decide whether to set
> SLAB_OBJ_EXT_IN_OBJ.

Hi Hao, thanks for bringing it up!
 
> Do you think it might be helpful to add a comment here for better clarity?

Hmm but I'm not sure what should be clarified here.
(perhaps because I wrote it).

Checking SLAB_OBJ_EXT_IN_OBJ (as part of SLAB_NEVER_MERGE) before
setting SLAB_OBJ_EXT_IN_OBJ should be fine (because it's not set before
we set it), and once you set it, it should prevent merging.

-- 
Cheers,
Harry / Hyeonggon

