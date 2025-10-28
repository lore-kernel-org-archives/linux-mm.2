Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC577CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2849A80122; Tue, 28 Oct 2025 02:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E6A800E4; Tue, 28 Oct 2025 02:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD3F80122; Tue, 28 Oct 2025 02:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F362B800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:29:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDD5813A091
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:29:50 +0000 (UTC)
X-FDA: 84046547340.14.590CFF4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 317BA4000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:29:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Um+kEVGj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=o8wvzUxk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761632987; a=rsa-sha256;
	cv=pass;
	b=LpuoPbCakAP667lsxurnbAvs492tPVU84GNqXGc97f9ps4iwyUxJK18Va/cYtrrdCbtnfL
	7UqZpOFnpdFOXRy6fdQclVW1pG4L/UZEHe7DHszrIkW1QJBSTBpYR/b6QZmEITa8k4QtO2
	NgAThJfk1Cq8zCQ3J4hxc1OJw8tHpuU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Um+kEVGj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=o8wvzUxk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761632987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
	b=HEtCADDvpJyvDb+S2HX0ptiKZ4YyaeNzNycZ3sqyorhNzXpJWLeVuO+UvHK2DlBr2AbKhY
	TweyzHWmv7CT2roRtdq10tPyRxMBQpaIoyz1bs5ssTfLzDqW/sxwuilC4E+WU7It035vHn
	JvHh8X7k9MnOVqowr5Bsef3YEyibYh4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NRWc029241;
	Tue, 28 Oct 2025 06:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1UMxuFIIDXgtlZtk+K
	SD8E1KBqM1w3deXZv0I6TY+e8=; b=Um+kEVGjcWnf/i2AYhOLuawgETXyNgx24e
	awA1XN+RB2bFbTe+vPHuRGfwTzgyXY15nDcBtcePvYiaBk8kML2FSYSut+nJNx9J
	0yIKUruHRnmwVnX++1mQc/ugqOOVBAkwTZUDYkgzsip3/lOkehPh0j6idKC8+2ZR
	cohSq11lEt7MTy13anXoscL/tlzpZxoSz8w4CBj5Nr8nEx1QFe4dm+PLY9+gUeuo
	tMZ7rpIOF1ZJ1QtuaaigVn2Ntq3426au5zMxC4Md4JO5HqCUwAl1QKJJWCCacias
	bdraf/i1S8KjOX8M5Zwoxdx7uVAbFvw4R4cC7MlyAior6UWum6Gg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwjnw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:29:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5APTS014941;
	Tue, 28 Oct 2025 06:29:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012018.outbound.protection.outlook.com [40.107.209.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07sbrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:29:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wvo6LUGEVrskdAq5SxI6qNwrQ8K1JFFmeFNUR4K6E0dXOlo4DxZdWR1rFt0H+SP3be3IOqJKjmL2kC7EOnj5Zhe369uuFNlwqFvdZ1y/E71IaoAZ78mXCkeOKC411l6J7G01IaDIgXUkaPup9xosINDDZl2Qr/sn05br5V4PT4h1nkabuS/MU417cqmeKsxnxeVE+iI4YAB16TSOS3598Ef2vuYlCQpoy6f7ZFuXnGI+vjI7C+w1hzkj3yB52+epd/7TTx1AD8gcPrQZG90rGyeUH7PSAI9y1TwBGld0pVcSiZ56iCJR1M6VFLiC4ZBQ0c+uaJWxdwOXUnkBHVUNZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
 b=IrVsrvvPerDIkGpMaL9o3+7zY/2JV6yPkBKHneKhlR7WbTnEHF5mirqSw04FD371ezv6+MqQMEMGlWqjNGH5X8Cj15C5KohIImiXsoakjp0lO/qLcKay+GeIGF2lg83dO9LNEdGRohaZGXd/vqEv1SrDJmxXBvQLPRY8d1/0hxh00DTs1Jv1KLQCnuIIG8eZAgxGjhbR5I8PHh6yNUC+SsK9xUgUpiJDH6Uf2/Q4C1S2wrNYtn1CmFnrcBPtwy0P9hdSuWzdzzkcVKfR2QKYWiuR1t70VFudUYnVFCAejCrb54SUCX1KhI3+KJIQRA1i9S2O7b4cEU++OFxFFUBiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
 b=o8wvzUxkodVDDM+d9raeQT++MhSdQpYv35yx7cYy8oXbKza+uhC7f3YgT/4VnG/e4MkFxCRr9Gk2sGIHTK1yUc3xu7Oze9PIUvMZGcG5AXLRZNjojDqf/Wm/Gc1yx5lupm8zIryUg3xU1hjfrlZ0Efa6j/b7QXLvjl13cFmQEcQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4579.namprd10.prod.outlook.com (2603:10b6:303:96::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 06:29:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:29:39 +0000
Date: Tue, 28 Oct 2025 15:29:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v3 06/17] slab: Remove folio references from
 free_large_kmalloc()
Message-ID: <aQBizKojmHw_uxGc@hyeyoo>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-7-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024204434.2461319-7-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0010.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4579:EE_
X-MS-Office365-Filtering-Correlation-Id: 453f91d8-7674-4d4a-5a48-08de15eb5f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z9ufhOFDSqOov3w0Fx/4ZGthPEfhXVj0dLnGp3WhDJaGIJsRx8AToIBN6M5t?=
 =?us-ascii?Q?kVPlTZLYqLhXoRcJWUvwEzdBVUwhFD8tSZmooghHIWrYMuKxLPwRTU0c42fD?=
 =?us-ascii?Q?3QuUdgKnxILUrKsJotAObgIYwUPwOetNdpF1pBO/j6U1o5gFEVZcCO8mtWxj?=
 =?us-ascii?Q?9d6wzzKW27LnQO3MJQ20+n62SwJZkmt3b8n78TWsl19m/BVA1PaUOJjyZBRY?=
 =?us-ascii?Q?KwD2bcB752KNTCX5OovUeskdQrUIXV2103AWdS6zWkb2J1JR1EESsixIa9Pv?=
 =?us-ascii?Q?lo5c5Ka8QGCvQt+QGnH+WuI101tq9XvsZ5yMraSqITYfI588WKBWNIfhPhGU?=
 =?us-ascii?Q?CZl1prDVnpmYj/bIDvkh1k9lAFM35I1Ehbf1GnINvIjGQwd7RgtqYZQfrReU?=
 =?us-ascii?Q?NZbNsjdLz3s0nffsd7wAUYSYJJrRGIEF5be/5U3bcZRWN1kh0xCCHl85rQjD?=
 =?us-ascii?Q?lvpb6v8B0cNHZwxNbfvf28mhhYPDMTJ+AblhsnCbuleg6A1StMm3WGXdIeor?=
 =?us-ascii?Q?2QiGKt0EUiMw9CU8IYpGXbu4yWg8BgxIN9DhtWM2ppjSK+c2kgaI6narOdnb?=
 =?us-ascii?Q?48iL6/h4/lzBTFg+SauSuNv7tBa8GWNoluQk1eqstjm+U9PCWOQeVLPrtSp7?=
 =?us-ascii?Q?HNHQ7u9PuTiIf1P5YNFN6jygBxslUTDwZMF26IRMMV/bs4p4HrGxBd2Xl7t6?=
 =?us-ascii?Q?cNxcA9CI0xw+9A2Pg9Jtnli8aNq73K4iUy1Ee+HCZwm5zUxQvkwDtSCZUyuW?=
 =?us-ascii?Q?E34nojyJ5rzJoiB9OH3vWK/b8EP2/CFAHJLa9YMl/z6D4hUyaW7NqK0rj3DQ?=
 =?us-ascii?Q?CXOLTFNIhXHvRlzXF5VTkkvPuHTWJHmUILvlJa3utzQ+WfcW70qwJRJ1N6hl?=
 =?us-ascii?Q?TzqOT34gcffDp1St52ma9q/MVtRN9JYmY8PZYKce5uu27Sc4SKvS3QjiEZVv?=
 =?us-ascii?Q?RJw8CS7clwsZL02m5KYHgGxFrfykLgMq9nwa/HZPh48lNAczIwME45tL5uAT?=
 =?us-ascii?Q?10L7U35i25DIIB3DZ0DXkhUBoB17kOECxYK6BU2u/N71hPMwhtSxekU/Ky8f?=
 =?us-ascii?Q?BpvvLWMOBchlTlDlxJi5+8XzzysAbEyT1qQCjB1Dg8PAW8uf8chwFu6XJ4Z7?=
 =?us-ascii?Q?aH8t+yauZKCNdbSwvkT3fh3X1Y/mj5gapTZIo4OCzt6euQ8zlKJiX/fFLc/x?=
 =?us-ascii?Q?mM9S6gxaVu5ruGGQhmtfgmF6cFHXLeRAKnvWCPfdG5qzOtU90l7u4lyIaf/9?=
 =?us-ascii?Q?EQFAeDKzATTi+tcD75/GpdIsCKAE875KCBCbJEo9U+b8BG1Jjkk96poYvOV8?=
 =?us-ascii?Q?dK4XEeniNRxTxFjRsvUc4gtmNZ9SKjChYOBJiNa4EWnLjukhIhBPAFWeRjhX?=
 =?us-ascii?Q?zhgSqBhBsXNcadwNqfhyZ0XSGxibFAG8C4PlrpDLgw0OPL9LU4k2ZR/Nbjtf?=
 =?us-ascii?Q?rIELmTVm0bTtGw0i2sD9+MkS3LpgYhIu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JHbf8SDd9h2BEALtt+tFLodIY1gQWrE5zE6tPjezaQ+YFwyH+XQWm6VojPT7?=
 =?us-ascii?Q?mhgw+H5QlRz5z/4pwr+bY36N0oTQC63ccPQksn6EyOEURfTyqqWjI5EWXvbo?=
 =?us-ascii?Q?NUBBgQzAF54RfTAZOeZ6VW2QIrR8EFPGgtjaYtLB/mR2Tcsp+iRvZdfDRfGY?=
 =?us-ascii?Q?rLnlIH05Bu4EyhDRiW5tpb0xnFZwCDeG4bOGOaG90ck9+RlNgf0VrVf9kUib?=
 =?us-ascii?Q?jTdfm2BvWxwvUOfutvc9xwBd+Fii1XVdbipHo0t8iVrHJtdnyNUmyf5EjVeS?=
 =?us-ascii?Q?dxLmQyIm2+RnUCQQokO0Jgrlja0o+XMHZG0Du6IpTE7BpnpRt3vXda/U/xdI?=
 =?us-ascii?Q?s6gLXUCtATdoQcAnWPPzffEFwtpGLJKXImTA4mQE7jjqoDAkkDkem/bRlPlK?=
 =?us-ascii?Q?6ycpLrKUNEPKbUL5067LTUkaM9ts9D0JU/1y3P5bEswCF5W4crjeqpxSzqe9?=
 =?us-ascii?Q?zNsnNqC10XINe3AiDPj6UudStn0dlEneVeZFOXD9RtUwZZuledHGgdtKXyFU?=
 =?us-ascii?Q?2pBQkZNYPIdIQLnALCsRIbIXN3cpCcWse2BWln+vONrl4z2BK9YcAsNOEcM0?=
 =?us-ascii?Q?UuxAwhzCaBpzfK4OO0fSvuaFFTJFEJH8N4Y4Xqrf3+qejQVzWxFDCrzJps+r?=
 =?us-ascii?Q?/F8W/WhOlWExfwPyZQEFIoq3eLO75WAVNoE+yB4Cz1Ae2M9FyfuphZAjs5TJ?=
 =?us-ascii?Q?MIRVXMtwqoie2hdnTSsDNDGfPcp6RcSdweyfP+NgdG+yDfAfcotRA44S2Tvw?=
 =?us-ascii?Q?VJxnCnyKrA29JsOnZLGUUkoarETG6f4vUHDJ38lsVJoJjYOG6F8AzfrZCzzP?=
 =?us-ascii?Q?N1AM3aoExJemUPJQE9b71FXip3doWulSDyX9bvjIhm4/xVpNfVPsSRxNYnuO?=
 =?us-ascii?Q?0gDdbXjjqDyuBk/Qjm4CeCnQxz+N5ahWIxQpf2OQxQjRrrzAyjdmSR5GHhrW?=
 =?us-ascii?Q?2yFrDI3t+i1ObMiwHh3qe3eSPRrbH90ErmJvJGfMEOTUY3BbE0UWb739JjM2?=
 =?us-ascii?Q?vjvDdpwMj7fp+ryj9k4iDVQ1Txk5SpJ7IOCYp79/JphizxoiZBKVOVkffRe4?=
 =?us-ascii?Q?v9DHLOmizEzELJIQB/B9APdtQFVddLV/E+rGvsizyiZx/30VjZon84c50/EC?=
 =?us-ascii?Q?Z6KpoBMVeK0wlsAJhg46AXH4iMVuVHqyWxFbxsryaFl9iQoX2LVhJtyB3mD1?=
 =?us-ascii?Q?ruRb966aoMRsoZWumXVHXlFUL4KCWNaR0m2Yr6c6wXGhyTi9muYVIQVcxMIF?=
 =?us-ascii?Q?+QS7zWl4yo07dCsBnQ7uoAb4qP8xM5DJt7TktSDinLGDmxxbW5Ix7E5PV7Dd?=
 =?us-ascii?Q?Na+9H4LqvvGZmp6ywry7XdSw/RJ8YRvaMBlK2TJlQv1poCe9IwUGvK06nrVs?=
 =?us-ascii?Q?DAffEWViNjQfiwhEQ0wkhoRVFiQTyDFZ0y9xnATS2ny/mQPP0xBQzNb71qpK?=
 =?us-ascii?Q?XpzQ+LKm7SrMA/W9Ln9ISeIaMHbajRd4ThsC/pADT3/FK8q/6WbYMXga8H0k?=
 =?us-ascii?Q?yNKzGFPAh5Z76J4YNz16rf+BrHFYtOUyF2sdbIj8iqZ5brxoVjAfQVk1e/hL?=
 =?us-ascii?Q?FscugRMdP3AOStrfgVOoPL7XFCYBEMVdoTmBbeMd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/4ZcYtpYq6CgE4i8MCbAGXhIlTw6tiagzrgcOT0+VdswM0rGcIlRER4bcbjHLB73ffmogn/JbMxhhJvLSrXwy+DYLeOoLDnlSa8XfcQwnn6n6n7QCW6PkpNk4b/vJhGIagOAvNhM4rCPC8jpRXcP/qzMxq2tror2Mn+mbBlFLDflnduMF2b+oXE1aPNU4Mhjjbq1gsGtVVRcQxb7QZRvymEf7XBG/JUVZ9qQiZEYpaeejFmswJhd3TIjovu8+nZwvxod4JNVQuB7k3q/V1wZo5DtHeGRv1hXUK8noljO53Dh97QutwhtJaLslJSm7YGA2+lDafGw2XKTAvxBMpdqPlnMrkqIPNrWq4z0/qxHZXZdEfAluMO+rsiM+j7xB++gfPpeQiV0nP3iaW0hVE1+e8fRthO8awoHYLGgwIDpn9K6YuVtzQReC/tMA+I9EdXb6Ae69ePouXGsYNgBGUTLj1y93eMK7hC41w0BihepL/bcedPNbrVxahuuNgHdjJYuKjDVs8EAw20oZj6Bqkqf6XqPiXdQqhssg6TcAsgV9u6mUbqwjNkIt7J6yu45sIlT/3UB7QusCGLlFmBCPQkstbZKABNgG07zMo7OYwWQzGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453f91d8-7674-4d4a-5a48-08de15eb5f08
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:29:39.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adqh1cGFPH6wR2fztbDlcI5QRnkt+JdEVPIWUR+ZN9OZMJCjVx9kz+EHi1kGHZwYYZXG/F3HNo9VHfLuhnHVBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280054
X-Proofpoint-GUID: ha5LaQtKrfyc-KdDqx05msP-weQO_N3I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX0FVLRa9sjsjX
 KTy3wAFNaPqlgu8cNJKLRmP1L0kz1irL0CmWJQyjlfvzXWDpO9nSZ1wt8IjM1H9qOWVaXJWMD87
 CQ31x5TeUFoQNCnTeykE+E9lQjN6W5nInvwZUcQfaZwKLTpwzcS7BdeGeFYM9N0KRd4uSJHvLut
 C553Ww4cp2Ijg1acMHMSRri4CfesIyp+KMjPdh338eX+BKMXvQi8+vBNEHx8QU6AbxHHF1AdSQB
 rwn6NJXEHoIJ134IerQfihDwks4tNzAbj/nEqVqlHGYC+fHHfdqWPGQZI0dl1+7EzcYy97Va8XV
 ptSHVHuNG3qILXvR59Yd4QK6hFJ8i9y7FgieaJtkfErsfMbNaDPO09Syaabj9UcIO2FfJQ3RFgo
 WiKgwcM+c9PRKrUzkWUyu3CzfNFbga2qcl6MCUGVKXHf80HGfVE=
X-Proofpoint-ORIG-GUID: ha5LaQtKrfyc-KdDqx05msP-weQO_N3I
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=690062d6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=lnYYQb19Fs_rjGwmAtYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:13657
X-Rspam-User: 
X-Stat-Signature: ekipg3z99xesz8ei6x3eftfifpz9di5h
X-Rspamd-Queue-Id: 317BA4000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761632986-726916
X-HE-Meta: U2FsdGVkX1+wXhRvbYlRRmnDyHBv4tao1iyxsFyewRfdib1+icPMkzVgnSZnFBH4bkciJ1t50Uy3l2dmvDN4Xh9a9j0xR06AL+9uV8zh+GrSaMU/j+ofvQ3xg8LEYMMQMjzOKARh/j6n2d0eCoEc4398QlPmczDOHnfzRO6TyYoEMe9jKyrnqmWX6HEG6yB3rW4hmIx1Ko7+YnBN4L6NYMVePrADALr9lxmv77gjdhqxyGfv6ivTj+ga4kveEG3Nqcg0n/trYaD9P9dNTXS/jAc8vFjiL1F8iCGY1i0S93kE5BKlvl2V4kF3kD3w0HYjx9bpQ/FDdR9OOXyxrMkkKRmKIeBJiRbO4I/Or6ivOff3cnzvGNsc/+p46wy6KvrgqRrK/5erXMXPqU9nEv6e1NzsyfwcKLunDxD0H1m1X9N1JYG8emXVeW801+vLDK3O0KQdcmGXKTHb8G5aOsuhHsInXR3kWk6jBi7I/p2+qBeYHyb/SGMZQLvuusUOEjfeCWIjqLG1V7Lzy4eqTo+90Fdcqt++lUU5R27DDDI0B2w5ntXC8r7QkPbekXE5Va4+vDjmuWToIFy1YBFO8YoU5KQyfD0kwPWANn8QkGwYFcufHWxNZJBHEuub7GpApD8/nAw1MplQaqCu6kgiFYSbYzkrhL6MYwleBCJZ6oS7gnV2enynRT1I6VHhdVD5xSMd1pqnu4sX03ErZYOqF0hUK9+15/v0FNZTbkbADK1sk1ypoh8eH4piez05luzB72+VH7f22jl9wIAdY/saq7OpkKGekoCWZY6OJT174Gb+Dvx2m5f3e1W75maEOKLeRLD3k5cwuwoC3DrnmjzQ7ehYfvtbWxSA4Cqy+6PnYZQ1WdlAtOUem3x8RBsmFxJp1teILeIObVEfhbslcQAj45w6JBogQuTnDpUedwK1tUfbz5MJHHlUH0LO1CJVeCcREGMenz4aRFiVNYI1YSbvHgz
 6yPqQZ3g
 cfsf9WfurIdVpkyoNa7k3x/XIPKxmQj7GJgykg25KEbI7P4EMNfWzjgNLLsRSjtD4EdZ9uxCR6FeV3lqifMiwi+NAaPzSCm1JBSuvy0SPd5wVzsBYetBOX9Jr4gDlIoH1Y0A77idweFJHQOWzys0EvcQIQq3iA1HXo9SXPWNavaUAvFSixDCsi73ZlkC795hbgcrZgiOvJLOdo23BX4mpEhlDE4vDADi2StjrwROhaT22zW6cox1MDmeTDrezipCP8YIR0v7M0KTJt5jkY4uc08UdjewIzkwrOCc5xJwx7TsXWIMnyBiLLtKJuvNrluD5hADScuBj4UhEfRGz8MYOZaH1N5bii+E585656vTbVm4feAALMuOTDn3nPpv8+pW26OZSyIMPp6iywRHx4iVDDNefgURZ7GcpeHXvmtV4ytbySv8LGwlzCE3D9xdedUJcoDk+xAvAoWFTApu0uzLHvhrdc6k5PXx71TzljHBLssugRHjqEAPmIVnlgEt7PAbG1kUBvn0VFvm7bGNTdi0FkyN1NJwFIc8TgF6A2nQjOxWuYBsztPoYI1x0gi9qJLDTrj1hkDCBVPL9FRo5m2dGvc1loj4BOwTv+y/B9kNWcRHxezuogUkhKtqgcsENuJ4D9tvJU3cRaUu50N7oQJHry/PLtsJdIh7j3FdWwFSgjO3TtzvhtwN34kpH3xUTSQ1Gtb24E9lFXZaRk7ILX9rIhHfi4en4Dy0UTx8xswbe7QNuRoT6sk12xfh+jxChUDfZYOTW9LuQ0j8+SQ5JnARtpotzyQVQ3WtzSXeowQi/BPXlybLk//cAx74Fmu9RuIHfIR8Ep+rThzi1n0n7m6wJJDBxGfNWMX2QNILG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:44:21PM +0100, Matthew Wilcox (Oracle) wrote:
> There's no need to use folio APIs here; just use a page directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

