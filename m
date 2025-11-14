Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA4A4CE8D70
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D6E8E000F; Fri, 14 Nov 2025 12:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E7B8E000A; Fri, 14 Nov 2025 12:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11248E000F; Fri, 14 Nov 2025 12:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA6628E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:53:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B37D88FB0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:35 +0000 (UTC)
X-FDA: 84109959990.21.39781BF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 665B21C0009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qhnNtcFj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wF18jaBA;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V3q81xpGkNyPFUgc3TLINlccpwZAkRI/bfGAwf0Ibtc=;
	b=xGGB1y1LBnyzfkolzsfXXwk6Ouh8tTW+vMQJ7HEFtyhpFDkFJCWhDrdbIQPQuh3oaSOvwN
	DWnojrQscbrpruxsE2cFXpuzbOx22I0tBlSQ1ZYlZ4NEeWYs5PPW4UnKc33Owu8F97SuR3
	3Gnh6GUYqklY99yTOxYVbBviy1Aqvpo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qhnNtcFj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wF18jaBA;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763142812; a=rsa-sha256;
	cv=pass;
	b=XPVEJYbim33I3lakgPZpf89muG6g5WJu0S/js/oXot3ExXAA5fFpJf90U7EhAIFO3MD9EK
	IkJT/I91ranIsTBGIukF0vWhKf6Bfr80CA94zzYTfVaixUqFfKjw4UuTnNy64Nwq24LZCu
	z3fuwRE5q28tafLQrse0bnzPRnYEKCo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEGuTv7029060;
	Fri, 14 Nov 2025 17:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=V3q81xpGkNyPFUgc
	3TLINlccpwZAkRI/bfGAwf0Ibtc=; b=qhnNtcFj7Km0JMDxNcXssJwB2PXchdE3
	a99l74H8eusZ0hA9nInFvS1pX3UEoc5lhdRgpfntnn5KC9DK4AH7qQa3PKM5qHoQ
	yRYnQQrgddRkafdwJ/5Ss0NoQU6fgxDLllInMH/8iaJdskDcDbQYO+pi39gTvs+O
	gMtih8hqZ+OZQ7SELbpHWEJT6JDpwS6Z87uz0MPrAV0zzp5qbtsS1JxUWRIw7ZGb
	OCPUaVAFfYpgi7KpE6p7ahnwXt6sBmQXOio1PhOIAAbneomJrL+xl9d2rP1MazDB
	Y40h2VxeTPrRFUeg2IorbONj4GEIa+rM3tRnWOReahA0ssBZIzPN1g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8v1q49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEHcGCu027896;
	Fri, 14 Nov 2025 17:53:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010020.outbound.protection.outlook.com [52.101.46.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vahwxre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShcrpztaiKtPBlgqG9ImR8E7ZAyugqrKf2B+6kuWY8NqgtPPPRXvNyB+cp/61irIOlBGSNO/PsE9LKJgVGMaxkS5bb61RqhquDnwy0/pr8+x849UjB3fqaCvvLF7e4+0qST0bB+55PKCfiL6zXBDVTd5nVHnx/2TbnLLly+Wi8n9IA9Po4ozSsWPe+F1wd9WykQY6Z5CBt+wG2MUpI6h0VAMTXSfNqOeANObMtMg9kZYOb3UoS5+Zi5cIiriD0O9ZuPOmPV6Q9WAomU6gBvZrILtNkAhmh+8iIKa/d4Dw5JYpE7rE49bIzA3NApwg2hvr+NUnmP7cquJhoDc2Ly6gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3q81xpGkNyPFUgc3TLINlccpwZAkRI/bfGAwf0Ibtc=;
 b=hWPq7dmm/bizvpVyLlYOigpr/ZCJt+TIgl8BmxUrEAVjRe2LFN2+DwUzrGcfos8eo4uLKmjY7+/J6327DuGBqRz0c4/9i2ctVsWl53pRxpJZllgT9KV5VdPsBoW9MxmD3AKGExApIxuE/x/CZl5PSkpgUv48VW8/MZPr1CbU+nAjoitARHOnXVrkxMlL1YqqvYMmxo/rJJLPpUZBo+6H4sNg26a2NrTobsfhHvo1jFoVZ3QNVpCExchtWa6/pOx4HVKqOwUi7t6EKKSdD6fp/lbYaZWHQy4XEbmJLlRcRhCUypqtVZhUOp90ZskBSi/qzto05prWxd6euvKsT4asMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3q81xpGkNyPFUgc3TLINlccpwZAkRI/bfGAwf0Ibtc=;
 b=wF18jaBA9x1L33LPQk6r5fRrXabglobjqkfVB6OZRXtvY5f1oSOYMKAlwSMvbOJQ1FQtdER68kZJJNPUjmNFolQvkEdNdEkHepRTlf8HfvYa3m7739fnkLRFJ3ydTaXRKMoapYpbORku2gL4HGA1orqmNkMwEwAa/x6L1wA+s6w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6756.namprd10.prod.outlook.com (2603:10b6:930:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 17:53:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 17:53:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Date: Fri, 14 Nov 2025 17:53:17 +0000
Message-ID: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3d86ad-8dd1-4095-3e59-08de23a6b51b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ncgjLQjxGXWU2UfhL6AnY1PkBTemA/DCxixPK3MgPRhm8NKLvniETWZR1U59?=
 =?us-ascii?Q?sBm3GNpb13+n6tzEqgHZ8zquz0hHAoVDGQ1/HZrcowWKBfSn4p918RI1KR10?=
 =?us-ascii?Q?JOrxv5WRh3FzLOvH/CD4DaAFBc4ePstwQeZ4/0+OkNMz95u4khXYB2bBc0xx?=
 =?us-ascii?Q?Yo8llit0EpgCW8m77ovgPdqPCMNqfSgWUEhi5+lWMD9wNhtm0rdROITJx6pL?=
 =?us-ascii?Q?VTWxwvnPGY6IOGMS3CQ2/wovFJYLHIsFkql+hEm6DuWKJ5sZGJUpFjh8xs0c?=
 =?us-ascii?Q?cR9+OwTAbl2tLLMlJCcZFIRXnRAwdSnpqxrs++uv7m2AoT+LmZkkMzRrWAQs?=
 =?us-ascii?Q?ZxB82E3uTCBN5zSrUAwtQCitgQzbKMQJsI/9wtg0nOPbiVaTC5XE/43Oh7yy?=
 =?us-ascii?Q?qlwkgPppygFf2dQiIHJMya+TAVF2AucN3HDmlpNv8KqaqtdRBGIhw0e0gnyl?=
 =?us-ascii?Q?nE4h407bddeNQ72wOUgubxKYVEL0cnMx+iI8+XgvTdnJn8cEHQHJaKsWLxjP?=
 =?us-ascii?Q?NjiUM+vjDfGQXMwa5v6saThceaMhMKfHqg73bbY5YdV6zjuyTDTBGCmeAh/f?=
 =?us-ascii?Q?l3mZ7plIu7Zl6i3YStG5liiBfHHLnsKVCHN32EL8Ak1NniULfd8ptz0OR2nd?=
 =?us-ascii?Q?v3J+GMVJ+nvEk0a2sQHriE7k+1lTxbsp+VqZl9J8MGq0TWR3hzMdUgAOciH6?=
 =?us-ascii?Q?4SumLCh7dRV+VawBPI6HrGCyi9L94vbpL5CHGCbroLPj9oeB/R7+OJtOor7C?=
 =?us-ascii?Q?UjOd21Ct7KuZD4Qln+1PdIwp1VXgOJ0RtlzcBXVsnjs/03SlWA9MmW80Yv0I?=
 =?us-ascii?Q?wOJOqttvaUOW4SlEvsOmqaYiHXvedSvOL/kD/kkHwptxwdnn7gs54E9nh3we?=
 =?us-ascii?Q?eBU+zLatqmgBt+bKUj+qcnlnbz5DN3krvqfANGSg54mLorHwekiEBffEvQU7?=
 =?us-ascii?Q?o+P63eYuMXTbwLLjA1xpWBy2mztXoNCxOsZ9e0OukU4uySPweJQIjqGgAHj9?=
 =?us-ascii?Q?LyI4HkB7xZNp5rt2Ce/vxukhRwstq2Hf+voIr8D3kw0RDRRNkwyZBeCYmuZv?=
 =?us-ascii?Q?XomOZDuMzNGBZ6VKPuHHhfmE6Ctx7MAJhRfpPnTPotDC1bbBNBvwfxBUdoXV?=
 =?us-ascii?Q?HG5P3h6kyPUUXtzv4j9922kPZkxeT/jrTfMopuim+3hoz4Ph6tGVrKMH21zE?=
 =?us-ascii?Q?lRRmbaC4Q4iR/BFdMveAdyKsRqIe5O9qxTOU57AnNx1GPQLLcCse2sji99Hg?=
 =?us-ascii?Q?T2/Ft7BnOq6CAEWN3blyfzjZe3PHdHv2w4Tj/fJ1ohJ8AAhSOk1CgVwwh2SM?=
 =?us-ascii?Q?SrpwDfW9Q/5VeSrWfMatOsMBwPqPTUzy6r8ABNOVqjEV1jKA6EvKPKcPVQEx?=
 =?us-ascii?Q?ncY3Q/jRB0MHtv3gWxDZP3kPLYhbtXZZzv0uYYshk7cveiceZIQgQLmU1Kah?=
 =?us-ascii?Q?5I5DMOqQRnUQV3hPUqZUwwiP0jjREeAK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w23lkSja8MZqSjsAVngy0PUQCMH4Ot48oz3vmTjdaLqp6AEtw+u5ZkJ1bg7U?=
 =?us-ascii?Q?THvLJ7MkA7yuy1txF/fqPkRHAYIVbviCU6KPB7gjv+ugyYXIPXW1IF+PbrjA?=
 =?us-ascii?Q?shobdim+jA5do6IqJ7/eJ0rr4IHfVdfQo1vOiFX030lvOl5cuQYwax00qwvY?=
 =?us-ascii?Q?QmvMqYKAjmoJxnKT9KSf1Sgnt7tn5ciqPkbaLcK7zX0slTeLmesJempbHSc1?=
 =?us-ascii?Q?fX4wYXnv+fXXNV9/dYWfoLWtew5SLeFsdpz1fqDRwyil/ZRrTK8+0kYcJ9c2?=
 =?us-ascii?Q?NHgGPtAX+i6LeicFgEMxYSLS+Ryfx0V3wEv2IFQi+6p0+QZqpmewqW+3U2fp?=
 =?us-ascii?Q?EzUZHuMkWSZLv3KoKc57/ZRT8lTaQ7CH32vpIxeHEm47Iy5O63nsdZPVEFPJ?=
 =?us-ascii?Q?k6kSnFCTcXxyulOOYjC8R6zFlXeZPaLsuqj5MMlxZK0DnGE/BRrv9/LdsoNC?=
 =?us-ascii?Q?PykXM6nuvwDOiB6XS5KH9KAB7W49lBK/4KXihFJwCd2WSZ9Nd+qgD336ji1B?=
 =?us-ascii?Q?aDpgb8jG/DbyMmqoOJP4N2W/Jv49SrlMcd2hcj2goXwKBQb9ZY8y8gzZEO6Q?=
 =?us-ascii?Q?HsWapoCKROs6mRHm5IKpQbaTEGsun1FeD6YXVARfFRH6L3QK5jFsCgTe4Iyj?=
 =?us-ascii?Q?a6yyhSnlXpzZcyfWWUO5jyVM8pZwEJEaZXrOVINysCwRS7HTI/v6C6EgAhVs?=
 =?us-ascii?Q?B4KZYwta02myX/wBrSba8V6hAdjS6K602+Jf3xvzhwkfCWHJQFaQQemMXafs?=
 =?us-ascii?Q?0fJqDy0D6AoBHzC8UgiCF/fPdWMOxfmaJYRCwYI3D0WPD6abBBiyeYmGBlLu?=
 =?us-ascii?Q?4XIpzM9phzUe/S1ack/Aub5uneSD4Ozad4Xu+p9xuK2siiQ2/RO7tacawCjE?=
 =?us-ascii?Q?A1i9oi7FFUlCOilsiL0M9KOtq3aW93ut7E0tocdvS+fcMGVKGDwghxMaX2AL?=
 =?us-ascii?Q?z1y3oJc+zB5PmTb3Mb6QB5NbG2kwX/bV0Gzy9bHSXY4m6jg30jmX2iDMPfTQ?=
 =?us-ascii?Q?4/PDWlEYBb0lCyCfWLenNqfIWn73iVm80+Bn0gXqV2QV3UcjsN0wCRMDtqAt?=
 =?us-ascii?Q?vakdWDly6PXOxdUfrpolEib9NtGg9Pjr9p2v0auem6Oedd776hU9+7YWPYCA?=
 =?us-ascii?Q?eicCpFmh2tPNpHEAzj29djmuI7V4vZ4qdxF9CvClAKCHOxkYj/HNmgwdxhd5?=
 =?us-ascii?Q?HnE75i1O1ZaePIzC8FtukE/wyzimogK/XoUZHvjxmkenthLnuLcPtuyNNwAe?=
 =?us-ascii?Q?CSB6YMVuXQfsks0kdJjMQASiRN+sEwdk3cQfq3+fFU+X8YakdxbZx+CJ3Knh?=
 =?us-ascii?Q?3WuSKNThFhxu7PKK6zT2koojI9ir4MF8NQNEMRGUsZTEiftfblucFukOwN/d?=
 =?us-ascii?Q?qZFUgLbL3s4u3SRRX985e4fcrcDGYfMZHOzwdIxKaagmU+VL+K5XPmaXg5Pr?=
 =?us-ascii?Q?IapT9gHhMTBzumfklMRzd/SdJSGOvDQgkvw1PXBpwcUgTXwBPjsn6hnME17y?=
 =?us-ascii?Q?m6M5W+B3kLDsOw7lZd4/yvbp1eZitaYzlBC1Yx6VvpELTg7lm7xZrAPRskYK?=
 =?us-ascii?Q?jP9B8SX/CFFS8wJdPgXeFyTtGu+bUBJ7p+iyzx7I0ctTZOAD3gDUngpMFc/T?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JFX1kycDAWuf2WJV1BWG79YMhpH9BEF3aLTmtVQw+msG4ObsKwNcPzfLJlvD9XSv6MXsQaWPErrKPFcG0VBP579Y+dusT9ri2wBh9D4orXn5AegJECzDdfSrK3Dor+CkgR9654pUPrPQnDEp9i4xc5vYFIuzPqeZ3gapYJ0g7FaP0FVt2wg9Af026yY9ga7z2KizzfoJwi2rG/+I7ppyMV6s8hbqLKRpwFnSbSRYpT+kcY81mP1lQO2djZ08w+HTFQQVCGhNjK5GBvP062d5Ob11aahWpw3GoBOj4W3kadxpi67cwmsWPdUsfcxMg+DnKHwSJdQuUYTcSQM0juTnehMwJT6osvTcG97k0tBOYRgmg+EZMMKFZTcMEq92xPU2sR47PbuBUBesEKClwnEWhC0xbJD4P8SsX2ov1YK0euBrrSyVzPnVHw5tTGhCaiLmhhruGqtTggiAUbGLa2WmZoWxnVjVyMZWec8uX/OjSK1+ngmu8S+VSM4pOCk1sBYXNVIelL3xYLqDXp0qzVloeNQaAwmD4bA4e4Ku/XeJUm3xE7aGVSNEcCc2R3x0Bw4k7PnnZ85F64oS5tiou77t7tdM4ICqKtJ/kyQNdDtiB+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3d86ad-8dd1-4095-3e59-08de23a6b51b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 17:53:24.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cs5SLYGm/Pfd1iDPPUAH274AIZPbd9SROoK9y78ygcQOY86F7d2GpiDZBhL4eKtU89G1aA7ovg+j9+EuQsnT2UO8FrQDMBirkP8G4dmwDVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_05,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=363 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511140144
X-Authority-Analysis: v=2.4 cv=YP6SCBGx c=1 sm=1 tr=0 ts=69176c97 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=0Sp8-nZc1P4IwX213mUA:9 cc=ntf
 awl=host:13643
X-Proofpoint-ORIG-GUID: jcAhIZKw2peUPF1ivPnTOo_LSIJmL7EL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfXzoRY5B8suL4z
 1eqGodDuV5XqBzodY4CCoUlME9407I378BjduGUTTvCPQFEDfh5WgBgmLj9dd+uCz89Pbp5Uhry
 DgE1rpVnnD2hjSfLKijFvLgOaxBLv98UtOguZKd6TRMaioWz5N3CWPEKLwr8VVi6hDFc2FVlKoH
 7Bc9MxM2mUFFVOZiLIficIxRDRlFKEmqdEasjNhxW7SGP0FPewnVtVlvnnwaz2jzCcvmXmvy/X2
 4thcXEk/fs4+SdY4dA4FnspVasxepeOxmZ/WkerkPP6y+AROmzAe8aS0l4dWhHaCs1FJP+4WdK1
 cQdsbZdE2oQnLIs/5qY519ErRW3qPKm/5IvFjLb0obgYTED7ZQOcf2XMro5/X4f3bm0w4UtQtIo
 vlvHFY52uaiBGF463EwHTOtV0gGL4h6I8Ck42XaM3YOn0Pg75hw=
X-Proofpoint-GUID: jcAhIZKw2peUPF1ivPnTOo_LSIJmL7EL
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 665B21C0009
X-Stat-Signature: ar4do6np8xippzhu7y36o175tpcs1a3e
X-Rspam-User: 
X-HE-Tag: 1763142812-455859
X-HE-Meta: U2FsdGVkX18KPaIKQxis9vEl0sJoXB59I8bmmkt2Mi7pf1DTFraGviJuS9CLo+J5eMPlSs7cCJtM00bKiLCC9yxd1P1FmAIiyXEj8cQuLHSJ1Sf6rpKBZCzxKMc6Fa7xqIAqqaoIQW7YQJTlGw2fsZTEhHXJypgp5yeKwHPNg7Lzn+Rb3c8RjncgQNc1pBxObWuRVZ1cTKGpPn38nVEkd+rm74hNtOlPlDLwVSR1k+2lUYoMNzc+dI5kfhxhWjkQWWzFLKrdsAqrVchd1/fUUlWBRKkGgyE8ra4Kvadw155E+byl+aApzZc/Uo3YDr59LGZ8WZxDXWyTxTUzZ+10iqXv8SvH7NIdi7rwH0jICXMf/VVey3w5xmEkrQsaAycNHz7cMS71Z9HwHScNVn9e60Y4NfGJYY59FdHhCAlAU79IYFrhBIbX0WcIsqTNrydamc4TsQ249/ljn5RUAXImLs0oJC9mGDXpzT0wA0mnrdLMFWRFbCtkiBJH/FbWTlVlaf+wEynbrAVKvNAQBrHKKlPInBF6FK9H8JYqzuHbr4YtLv7XQl4+bVuhCrNnXhVJ++6gUSpognhQ/TCZKYYuHGIwNS7a5JQVIHiaWz4vVHlubv2mmDuLqxsllaSpz6cJB098cXtZUFN8bxVLcoaVUnDAmB8NIssdFepK9iX6AxgIH6iiH+CF5wqjK0gAcMFniT6TVs6ATvbeD6BlxPCGcBK6RNkCf7Ri+zEpx5ezzHoUflPkAMZs7rKoCb3Is5YoxquNoi6Er7juJs1ux8CXOyEyRfWPS3fABFvPIvljpSGLiCjnlsiPZ34eUKlPVonL4vz/tfnJjAfDhD1os0hgg1B7AAaUlwKJmm+Dl0sQ69vp71P0KbMCwC4PuAahBy1IRht4fYKG37ehBPvDBCZXwwkcHeC7N7yfEigKIgeL1ceQgEEjIfYcDfSqv6VjWi7t7TP6B2YXK6ep04pCuFo
 NJWCIWmh
 p6dDiCrirO0SRqMlivzb2nrop8/DHUbMMqk2P3zwCnLyIAXyXAFxotWvM2Y3mSYiOtGi8w6pzJ4CC5hR5XU9PEQtATUfXbW3F3RVamX1ZoDUTEYCM4qLWIxhp2HuF7m9CeCy5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.


Lorenzo Stoakes (2):
  mm: propagate VM_SOFTDIRTY on merge
  testing/selftests/mm: add soft-dirty merge self-test

 include/linux/mm.h                      | 23 ++++++-----
 tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
 tools/testing/vma/vma_internal.h        | 23 ++++++-----
 3 files changed, 72 insertions(+), 25 deletions(-)

--
2.51.0

