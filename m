Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD03BE87850
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4135B6B00B3; Tue,  3 Feb 2026 12:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EAA16B00B5; Tue,  3 Feb 2026 12:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295036B00B6; Tue,  3 Feb 2026 12:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 076166B00B3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:27:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 921051AF4A5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:27:09 +0000 (UTC)
X-FDA: 84403826178.21.491DBCC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 14E6C40005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:27:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MN985b6U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OROpejCK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770139626; a=rsa-sha256;
	cv=pass;
	b=p93iuW0Q7cH7683VaGKB4Ldr7t435sXyqtYWUXziVV2U0vumTFlnfKwDquckET5brULjEg
	nNNozpoHfv0qUJeoFfWUzvCoG9K+T80OM6MC3Z3H/OJWDmb4+jlbS3PJ1yPDHEflmBu5qS
	lRICj0pBBXRIqehf3uLSI01PiN4yTEw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MN985b6U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OROpejCK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpOcedbtSi7Ozv+fKuKBMd4owsVBGfTbtlBSkVDK12w=;
	b=dx84+24jRqzUpJ/FfL/81IMA8g5VfiJMXfiV2mqP0SGBZw1/cuUHCHFGlSs/Gei4HL84Yh
	XqQuvoU0CuF2eCV2YHs+MgPQ56cpjF/gZHilwjTSCz0saZk1b/OOVzjunJJTCz/pWFaWFs
	nTUSwThSCyOUoqdtZVNAQtK9X4lcSjs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613EQfZV956678;
	Tue, 3 Feb 2026 17:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GpOcedbtSi7Ozv+fKu
	KBMd4owsVBGfTbtlBSkVDK12w=; b=MN985b6UvYTBIbhepNl6ocvGxu4Q+WwuR4
	sALZ5sT9XuruHi9Y9shWCcav/9jcWW5gEqoBcGDMXz8/V+DXzF9fyGpzK0UfvNVX
	vKT5NG9GUvAc9UzrX5D0eLQh0tWrkYLHCWStKLhTU8YWJgTDYIopu90gpTSztGyG
	ak6F2Rj6DkpCzaG5YmUHJz8casHJ64JP/hhU3NC+/Kw3SA9NAqh0xrWWOsaxVDsn
	f4vKgEZ7tUKgl5GFHA5wecT7VtCKB21nlSlQvkAVTWS8loY4sIEZyg+WhczyS6ZW
	IfFthGU0A4fDw+Av3uRRlkRg7eKIUWvDXb88FlBeueaoJAqV5x+A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqgbyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 17:26:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 613HPH8x025910;
	Tue, 3 Feb 2026 17:26:51 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012003.outbound.protection.outlook.com [40.93.195.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2578rc54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 17:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zz6Lx2WSY+4hotEapBKjukC7pNKSkGUxGrd355YX1b+17GfGDIaQqguxxB26d1sGv3XqGsYNeLVOinVAGKezv4ibch1osor3Zf9uj3QTXHy097IkM/vmqpWF5P29C1fXdCrq9g5RROZXKFn2Ds2tISFBXpnBo+vwHCe2vXeR7/sp6c3v7V24/YyhYm7dk+G0j/jw48Hx8KJr+nsDgAQ3vXvmk5wQzYGJnd6Mhz67DbVTSTJ/IogfZriJhoMzZOJuCb7aOs9S9EEP4h8ldO79U3Qdn/+ovUfmSH8ILslXTlx8MH3gVaqp/GSWUdONj7o4p4tZ83r3Mv8oQR3EyWLROw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpOcedbtSi7Ozv+fKuKBMd4owsVBGfTbtlBSkVDK12w=;
 b=X6O5o/+9pslLiHItKZUFIy7ewW8OKiXZs7RtZN5ZeBEJ/7MW32Is4w9pOVsXz1M90k7A9l0LP46DsdvsdmnxLbrmJOpmC0i9dDIFpey8mLJw0TKgzoWuot2eiWKEynG5D6UVUoTpAdiP6oj+hD+6/bILuczsBVKXPtF+wnOjxWYx5wVrRtYKJKCFyLgzgbTM9WYpKgmKo+DBMk8Fa0VInJwrxIgHJb4wdiQpv63ydK2eNaAWtN4dg007ne2QYqu9uklx4f7lUiNBCZZ4x5VlxDzIlNtyIRL6/U65zPlbAOX4GiwDrcHTk9GeVmSJGTrOBIMwRxP5DS3MjiwXXGDGLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpOcedbtSi7Ozv+fKuKBMd4owsVBGfTbtlBSkVDK12w=;
 b=OROpejCKYIGuxshx2cdupWEJQKKnfoYyzITy9dcJdikE4vIa8TeObYmWvIJfIVifL9OOePDTj6I3Shf/g3i1ZdvzINwdepSvSXMi8MlSqtOxly1vlUgIvzrx7ce7+jFde1Sfui2Vfts24xhZUEeR5iPPYEgPtYJBJXxR8zKD+jY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF871418173.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 17:26:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 17:26:48 +0000
Date: Tue, 3 Feb 2026 12:26:44 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Message-ID: <malwmirqnpuxqkqrobcmzfkmmxipoyzwfs2nwc5fbpxlt2r2ej@wchmjtaljvw3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>, 
	SeongJae Park <sj@kernel.org>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260130205935.2559335-22-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130205935.2559335-22-Liam.Howlett@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0241.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF871418173:EE_
X-MS-Office365-Filtering-Correlation-Id: b26b5226-1d66-4955-00be-08de634968d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HI5wQx2QavqaiadzVEXE0J4icrYIfaYHOjIXxIk2vTWpRgbNQ0cpq4NT4f9+?=
 =?us-ascii?Q?YNPCmJHhYPAIh70X01GJTv2h3Z6XWyj3qbuhh07Z/89XAsOjfNQmwesbY3D0?=
 =?us-ascii?Q?WCR3HW78jiHAE8C70NKb6LU+a+DU/LWo2ugRZePJqt8lJLamnlyBrKOta5iN?=
 =?us-ascii?Q?IFMyHwQ3fdKGWSiIKPbSgNWW14iQW+3VqWTqYGAny+tZ5vCqA0o3Bd2crd8+?=
 =?us-ascii?Q?z//MOSIJ7VQscif2w43oArz6ntMm4qZIZgfjItJ3+FQ4HI0Wsby2a69TE/sU?=
 =?us-ascii?Q?2m+V1zbZ2gWM6q/wjcwsyu/ZQYOpuD9SIla4CsUDpdx78h4ya6EJkbGsrOi/?=
 =?us-ascii?Q?nbzbH8bQJ+kCSmKGJ7S9xLc92T5stX41gL+vL4+yUEgUS5NZTuHqUTeD9V8d?=
 =?us-ascii?Q?rhcMZkPar6+qyCVf/pjXbKtG7pKj22UFiy4ffM7CRV6PbxbHTYA1UXMSzZbE?=
 =?us-ascii?Q?CiZ23LBwi7xZrtW2a8dvfh1xr30np2nZXGD+9QYqZd0bRKGP1pNk+hVNx6ZD?=
 =?us-ascii?Q?xqAxDgJyvFeWMQ6SrQ74S+dz3JE9fOq+E2g6xCPeWeIuWxlr8iEMNBOrkzj+?=
 =?us-ascii?Q?/Up2lMm3zeaik9+f/Kjb7q5I7Qfi9CIyO82l92/tWi9YqlMYvy58bkP0nQdt?=
 =?us-ascii?Q?WklEQNVL/YfzK2TDitGxlT1HwNp708hwI0xWfA0SUXIyCndpbEu9MpIhsYu9?=
 =?us-ascii?Q?VpE3XaIjOAdfnCK9+UC/LT6XfbT454/Oyo6f7nVxiqe1ZV4vN1tjulcBwOYF?=
 =?us-ascii?Q?U7/R2e/QdH9M1rAW5P1Iv8jqYsTw6DWmxRHIN2K73MMZ4QIwPV0mtgOTdamE?=
 =?us-ascii?Q?BnRMo3Gg+lX6z2hC6W7ELC/37icHKSGmzfpmqtmXQZwa23Wdzv8+38qSN+ip?=
 =?us-ascii?Q?auwWEf7Yux/V8U301ja03oeIyJSwUbAodJUup7H0/P53N1bVTEnyLE5/U29q?=
 =?us-ascii?Q?PsB6uQx8GXQUsi09L8Mr6hZnU9yOkoF4P9fHp4vBtXqEH48XeFRqHIMP459B?=
 =?us-ascii?Q?fJTXvMOiKyWsnxkyzkD4MBqBO5zGnjWNj2d8a/fNJIw3HsZbN1jjQJN4UqWB?=
 =?us-ascii?Q?e/n1iqHF6uRjHJfNdI8AEOiOuFrVFNVUlVg8G5WlC9RzHcoZysU4mCLXTpAG?=
 =?us-ascii?Q?T5OSgYqUqUFGKpE19cftG4j2UlgJ6NS7Kk0JICnynpo6V+WwNcFjGJYYcbmj?=
 =?us-ascii?Q?gPTWEhjw32l7urtt21fVhGG89Zk/GmQ7hBFUd6fAgJB7nlR8oVZ/Hr4tpHuU?=
 =?us-ascii?Q?SbFV6gYqWsR7c7MC9chQVhoXJA/os1pB3V3OU+M4x+fDyTpdMM9SYr8SWGQb?=
 =?us-ascii?Q?Zhn4fJl11W6gIqaOp8duH75qfcsCSUrNbBZGvg7j6yDXx293lI+OHo5l6CMB?=
 =?us-ascii?Q?23AX0qSYf9tLLnQjqllwQSw7IldVItVsvaWtmL2zx5i75ChOdhNXnvFabd7Z?=
 =?us-ascii?Q?2EYhA2z8AYVkRJwxD5eCK+4g1DoVs/CfSSlI5x1cPnCPZOT8kZfEfZM+1ZoG?=
 =?us-ascii?Q?HnaWJ+5w5zJmfI7EoiuTgAo8K/UwpofVma/nS7lnM3PN2G+1uwmWDP4kc7W3?=
 =?us-ascii?Q?sPGD7sDM5FH665w80wU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hs7U6ArG9+yLTfNdz8OQ+XysN2qc/yBnhw8Aqy3WOWRDjqzWCS4I56PcTlLW?=
 =?us-ascii?Q?rXnydaKuw3TKwzsW/jX8ySStUcc5CEl43UM8kVlD8KtNDAYl8u7aCuC8EJKR?=
 =?us-ascii?Q?tVTBx1IvAMPmc7lbM4vmQBjtHcPxGazjcuGYs5E9ZUrAjL3yc0jQK0ggoYy8?=
 =?us-ascii?Q?OEUwOxbj/lC6WE/3/7iNjEAIgctJtgPduzhfk3t2Pcgds/Xzo6XSr1dqXqqP?=
 =?us-ascii?Q?7cpgrUiVwXpfVzLAnxZKbs64k7mr6mrdaFxvBZYjG0sTaE53M0TVytG2cFyc?=
 =?us-ascii?Q?XB8+ZC45jQ1FAaGh835kXsXvlI3IArQ808HMBZ24+kuM67gN2m9HZuPnn6d1?=
 =?us-ascii?Q?1NaBw+jxBr+DjIGtADnI7J4jASIuis6NWx53frz2z+sMuBLyDBDpbgfqOkW8?=
 =?us-ascii?Q?zcB2mx8aMVxlqQUE78pXQYsGj+0iwNpbLit6A5PUT+XiqrRhr9SWeAybmpRe?=
 =?us-ascii?Q?vJTy8ut1k3IOmjeay41x/aWZyBqpvZX+KjhyZr/GYk6A0fL4cS8gtV9M3Hp1?=
 =?us-ascii?Q?9ZPN/HAFQABNHAiBmG/fshxyO9Af3BXaV3YEVHGLdj6CBwBtLx0odvmcpBLA?=
 =?us-ascii?Q?Vut3e9zqHQHjOSV3lhKj8QKVbZyxioKnLE/i/SSa22sPF16MWTOvQVLhrYOt?=
 =?us-ascii?Q?SsHAHga97rhnbFSpABSw/h8rll3aN6NECDVQtcqdKpF589+sVjBfyou4I2sw?=
 =?us-ascii?Q?7a9J9YHT/g47xLH+2BhXupt2wf9HHxYe5S0KWFZ361nxswliRU3TDWIZZF3/?=
 =?us-ascii?Q?zrowYX3lTk9hnUWuVWBJJ8BVIZwi7OuormE/rmzjEk2icDfLTJkMbxR9nrDC?=
 =?us-ascii?Q?IlwIoOkvgtwA2Ripz6yXf1lIj2us6UDnI18gHNGP7IM6XqzzcgzcopCafC6K?=
 =?us-ascii?Q?I0ugyRvdMEf5vkK5n8Kx0bYy+ZGmP5yLeN9WYWJiAvuRUgalbMiHS9F4rngi?=
 =?us-ascii?Q?Tb+dSwnIGA1nKGE0G4T8fyy644tQcVU8KTDqD1SfiuGZOh+z/fsM0uOb6pdK?=
 =?us-ascii?Q?P+cZZTQT8DSIz6LyfEAo9jxlSCvgVTt/Bf/4yb2B2hbOwmJOPsFJGYFRELOo?=
 =?us-ascii?Q?gfLGs++BmrcX5hd6MNxjqvklO13vH+HiJWk8Ih0VcCjPpou2Mut1AAb3CaTZ?=
 =?us-ascii?Q?29aDeUSTGPRYgyw+vAh4zLhK+2EIiADvrRXkYSNyA+/0A7t8eJqRmecwHDLk?=
 =?us-ascii?Q?j7nIQvzNvApiBlEx6Vn/V5Oy+z/Mzh/KrmPsWFLpXRpsRzOUtFHbdQe7Ymvr?=
 =?us-ascii?Q?9NVaELywTzSCFJyoTbPK+Kp9+sZJ+ZdhJl3CJ6VAOnQ3hg+qdJD2iGRGPRTP?=
 =?us-ascii?Q?eWmQjHgQueZpD1a0/dytbQe+rdTnO+AcoWuShvRHCJzjw76lgmAvSbpvo3jP?=
 =?us-ascii?Q?g6n89wZ8ahP2b2/MHRiSywOqA5ZCe484rH2+zOHfzQUoMOIm1BoRY+MN+iYX?=
 =?us-ascii?Q?9Tq+I5F223aRTXaEbi77xl2MU01T3/SPrziHm3IfSaIqW9rcwpAzvxQY2zap?=
 =?us-ascii?Q?8ftjwypK1PXnnvHZoty4xBiwefaMIVaUqEpxMFLOk2kmfhj8ThzgEqziftmc?=
 =?us-ascii?Q?7j479RKT0OM2iKHtBSqkZrWlDF0u/W4xLVFCK48Hzrzj301i6zpHSlzlgNvn?=
 =?us-ascii?Q?zvg+tH5P+vcsZ3wLPSj3X08IPz/EC8qifcm4vXRoEJO5ewgaJ1vpb/pFYTVR?=
 =?us-ascii?Q?W2stIoFXETuHlrH2riujVqoU7YanxSfdZFd4UCps9k2B602BYdfy3ersaHNL?=
 =?us-ascii?Q?uelgkg2sLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yPyiQzw/vH7YYuhF/Ezzg77O3mw3l0Lc8Teo1qYs9x0Bb3Lqk0Jb+9JBsj07hz940sGb4oeObn7ciFgWbcDto+A+XlslQMbiCXJZkplfjD9mu/w9i9Kt0NSmT8NeGAWm7b3cLvyk3meON0NzbwELPXFr308mdXW6G3+64W0QS0t2mD7/wOFR2St1XQDBaiwbXF3kXnqzbnacHlw1NCOxQjCe/201/gi3qC8cZeVkF/1d//Y3+/FPiWjKjq//puvKAk24Cv7VjLAKiV+3PCEqkskj1sDHbThT/8L5uYWh4TkYema9IfmRjHG3k5n+R7e6S4+GN8dYGEHjbLtm3SB4tVJlXODc5PKC7YB8gU7Az3sIJZwCTYJIO8P3ehdgBq7XhfmQqY8prKhOxVkCyoJIEP9UbdLVsGhdsWOvcOfeFdeGuRIOPvR6iL1ZQyxtLkpi81zEK8zvuh6dBP2cB8zuOfGOZehMmx5pWEedNzrSVdJba76Fvi85+n//vVNcEWCpzUvSE3hjoZ0Cszk7YwBZ+FRIL1tIMyXSEHmAwJX7/76n02k/DkhaAMOa++fRZGzUwN7LFgvdCAm2ebQxQj41Gpr7JvHbwUrqMwqbIm93yN4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26b5226-1d66-4955-00be-08de634968d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 17:26:48.0081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CTK0tM6W1tH80CiijjDcPXgSrmpNtz4ooM2jCGQJ+B8C6hLOJpkbXOkN3ipUIcjb/A7B6ndxqr5+VeLwW+FTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF871418173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602030139
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=69822fdb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=E0voLFq64HJKEfXjlJUA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-ORIG-GUID: 95hmPxPsVQFl6utm6D9eJWktpBiUxDcX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzOSBTYWx0ZWRfX5EP2qEfTah4Y
 cpmcN+8IAkQWj1L8eZu1rYb6iwQVkW+NuaNwe4mYgRBFPcOlZDL0z+CYx+vq3OfoiT8qG4l6yI8
 Ag/QBe/458iEcDpJbtV2wDdhH2N026qLC8H7LhpDPXMEHtM9pWZ4t0N9eVrInbAMVJA6VY0s6lu
 Sb5QiAhwIlI18GzO8yV4j0btRAly4tbiHfFmpa1oEqU+xO6nD2A+jBy4noP6WAtM+/GkPzOshdb
 pWt6B141ISQpXLuXaGdmaEk/VyjsoxhJsJ3ElhLM6UkN5MRzUGj+PiabDOZy8w9xO7DWp/4B4cT
 sKtbiavxD8DNtDRf3mN0JjNg3yPnWXoVVriH9k+pXMv2Hz40GdxpWSD25/DNOJbtgh/Jq7z7Zrr
 5X++Db2U7nrCmVKSBoNdLDmob8qv9uJG7kgROurejxl31ElM17WlxuKhr5jIeQBA8QrCLogjCRr
 gXruiwsWG0eichj1G8MhRA4C8h+Rg3fX/Bo0gM08=
X-Proofpoint-GUID: 95hmPxPsVQFl6utm6D9eJWktpBiUxDcX
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 14E6C40005
X-Stat-Signature: dan7q43wd1c13pueqgb836ecsjbpapfy
X-HE-Tag: 1770139625-108494
X-HE-Meta: U2FsdGVkX1/0SfcGtRw0yIPwTGsV0yYPCD8C2D5F/XyOZ4EJyIVgqqhPF6MeGWkaBcD4SBjOcykwa2Gyk8QjczOLShCM6E2m/PWXcVJKRIr3v/yv+hq4umN4NFTXmcnctDmTKUkuY3G0AKscAlWtmupW8WXWc40BkWbBclXG7tqSClBFoIX1s0k78zGJtBAaoMsb6e6fdSmi+DIPzA7UBKh7LYVPGhIb0Nqp5bhQCBZzbOz6eRe3Tex+r6xCBJuOXixZcHy5cHymai20IVJPwlXJa4PR0fK4jz46+NAinUtFnzUikN7AKRIFnnRg4J6G38dSRnB/GLqTg2LGuhMJYlE62Q9SUc+dOKkGCERmbHXRT8SqoL6x7vHoRoB/NLJ9DqLwi1CHzh1kUf6UxQS42qUdDOpmhKqCRcIZe++L73DRQuQ6i953aK//45JUZk9p0Q8GEz48669/FhEhWOhbLgdYTiik/2VPs1PD6iaUY8+FEO3TLk39yvUeWb+hNFSht2r8NefWYU7Z4+Nd67amVFIIppbnCxwvRBlwiqKvzC59DMi6b4BiMhwyHOpJ430+wcA2b0vUF7ogc80RNrHNzPNQdvvzJ981A1II7Pz2to0g8Xor9DiqcaMEgbDGV9g1IMTrCEQ+ntKd2cxwkkD/LwOLkquGlLOsKILlXs1OYTCj7fJfPONZQ56D55eHnly13Ly7oPtTntauHQr5asKhLgyVKVi9CBQYz75VXwgCdBaGGPyD4fryAu1uI5MRaKtwQT7odYdgJtoqi3EpqeCnPt9uXj2mgzm3WPuxbwDLV9LXp6qfZHTsL4OHCkNqUjuMn/f/XjcCld/HoUTqGkHLnKZ9+nMUf6wR+cNnX8vnFLunkwJIIULxhXsFsAK4G9tV8fwzaDnXT0/mFfN8TxJP8QKPLWP/56699EBAqCXXCK3THU4OdNaqkGG2us7wAZepEkyv6I2pkFu+F3twRZx
 sqwJHanR
 HvtVY8eCUPc4tNs3qio1KQj1CTiyBTu3JWSvhcuAaR/M1shMy1YztLE4k8Iqjgfn6wWzAtyxWrGUVa1ikU9a6kCV+WkM+bgu02hMkmRsBHJ2Lew3wQDiRaf6dSfRzDoI+fVFRU+jIUq5j60ZyUU86jD/gEPTMdTqJhh/SOzxbZthCcJaItAwjABeMQS2Qw/2Wz1Wf3cf2sWz80epoZ/30hFoyH3vlLCUN694BUA8NTE4iOg7IL25/1ANFVgUGxWoanEfM0EcxkH72RCc35ZooQRGGgkoJjrcblMTltoBGRFbwGbRsxbcWwav0TlgnNra3AxKIyB0MFIUjPX6IXsvMrdnfvsNVuLrBEE6Kmmqg61FFreHZhHbyrYDP1kbMv19unkpWzlvmv+hZ/67kPltBJQwN78A8LT+DXzj7kOz/Gg0mjFw6ZwioRr4fM+mwA5ejuX3AcqH6u+yIfHrxPulEt+WOiSR1PAAb8w5ppzZetv+ree7ViNMfQ3eV7QdrvQnND4rHMGe9gFb2jndr5v+zlQNZ7pTsyF1BDqEQbPbI9xEt5IhGO+tfqZ0SqO0CyF9oPq0QN5fj0Covwa9SNufTtDgwNzwyN9aV8+K7XB8/FzhhEBpdKjDRaVDauTtAu+uGOSsp2iYDeIbFt8TjBsDX6OTte9PkhS9U1IwLWIUYh7JL79JEJNqS6XYR0U7CMhD8G5dU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew,

Please apply this fix to remove warnings on older compilers.  I've compiled the
lot against gcc 8.1 and 9.3 with only this fix needed.

Thanks again, SJ, for looking at these patches!

Regards,
Liam

-------------------------------------------------------------------------------
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 42038e42a4c7e..22cbaba72931f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3361,7 +3361,7 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
                 * read-side operations that can view it until it is insert into
                 * the tree after an rcu_assign_pointer() call.
                 */
-               RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
+               ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
                cp->height++;
        }
        WARN_ON_ONCE(cp->dst[0].node != mte_to_node(

-------------------------------------------------------------------------------

* Liam R. Howlett <Liam.Howlett@oracle.com> [260130 16:00]:
> Add a helper to do what is needed when the maple copy node contains a
> new root node.  This is useful for future commits and is
> self-documenting code.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 5280fa6d2d6ec..42038e42a4c7e 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
>  	mas_spanning_rebalance_loop(mas, mast, count);
>  }
>  
> +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> +{
> +	if (cp->min || cp->max != ULONG_MAX)
> +		return false;
> +
> +	if (cp->d_count != 1) {
> +		enum maple_type mt = maple_arange_64;
> +
> +		if (!mt_is_alloc(mas->tree))
> +			mt = maple_range_64;
> +
> +		cp->data = cp->d_count;
> +		cp->s_count = 0;
> +		dst_setup(cp, mas, mt);
> +		init_cp_src(cp);
> +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> +			  cp->dst[0].node, 0, mt);
> +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> +		/*
> +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> +		 * documentation.  Since this is a new root, there are no
> +		 * read-side operations that can view it until it is insert into
> +		 * the tree after an rcu_assign_pointer() call.
> +		 */
> +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> +		cp->height++;
> +	}
> +	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
> +				mt_slot_locked(mas->tree, cp->slot, 0)));
> +	cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
> +	mas->min = 0;
> +	mas->max = ULONG_MAX;
> +	mas->depth = 0;
> +	mas->node = mas_root_locked(mas);
> +	return true;
> +}
> +
>  /*
>   * spanning_ascend() - See if a spanning store operation has to keep walking up
>   * the tree
> @@ -3359,39 +3396,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
>  	}
>  
>  	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
> -	if (!cp->min && cp->max == ULONG_MAX) {
> -		/* New root */
> -		if (cp->d_count != 1) {
> -			enum maple_type mt = maple_arange_64;
> -
> -			if (!mt_is_alloc(mas->tree))
> -				mt = maple_range_64;
> -
> -			cp->data = cp->d_count;
> -			cp->s_count = 0;
> -			dst_setup(cp, mas, mt);
> -			init_cp_src(cp);
> -			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> -				  cp->dst[0].node, 0, mt);
> -			node_finalise(cp->dst[0].node, mt, cp->end + 1);
> -			/*
> -			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> -			 * documentation.  Since this is a new root, there are no
> -			 * read-side operations that can view it until it is insert into
> -			 * the tree after an rcu_assign_pointer() call.
> -			 */
> -			ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
> -			cp->height++;
> -		}
> -		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
> -				mt_slot_locked(mas->tree, cp->slot, 0)));
> -		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
> -		mas->min = 0;
> -		mas->max = ULONG_MAX;
> -		mas->depth = 0;
> -		mas->node = mas_root_locked(mas);
> +	if (cp_is_new_root(cp, mas))
>  		return false;
> -	}
>  
>  	/* Converged and has a single destination */
>  	if ((cp->d_count == 1) &&
> -- 
> 2.47.3
> 

