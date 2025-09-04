Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0469CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E9F8E0005; Thu,  4 Sep 2025 09:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F168E0001; Thu,  4 Sep 2025 09:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087EF8E0005; Thu,  4 Sep 2025 09:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E62158E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:43:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 983FA119202
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:43:11 +0000 (UTC)
X-FDA: 83851684182.27.051A630
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DB30A0019
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:43:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SJc/3VVR";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i6pundF/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756993388; a=rsa-sha256;
	cv=pass;
	b=dxEkIhgQSho0Py8Skypfg+HJIkvXw5vX97BFfDz3lkjKZTuegMFta6G+iiD+gApW6rs9ME
	YPLCllp88MtYz2HgVia7q+xylFEKkyLbTRKnd5Z1IA4p/MYHHHEm4B3hs1fcRlIVSuJ3Da
	2Y7oIxilVp/31zaiqekt/p+R38bOL6c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SJc/3VVR";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i6pundF/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756993388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2eL19uvqkyeRfnQTgnMmPTeTUUuVMJB+MV/u9voi9s=;
	b=LkW2MHoQ66YFn6dYIQaspccIjr50nzuAZ3I0sr3UB+6V0pybQsLWHFb9Bbi1BrigGmtWmb
	9QKKD3zpKgwmJqC9Rc0tV1cPkHZt3MmX1drHp6nOdRKlfwVF/bp6gbaBf6GAQ5Gk3g8x+C
	NkeaXKKDUtT4pZ1A1dFl1dGXA8NZ27A=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584CndKI015177;
	Thu, 4 Sep 2025 13:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=O2eL19uvqkyeRfnQTg
	nMmPTeTUUuVMJB+MV/u9voi9s=; b=SJc/3VVRFW59S1AlJ8QlwM2kbju9ZY38tU
	Mfq5ISV2XDR1olqOgKaiBPWiRoJnEYzE9PlFq37V/+bC7LjOLxE0+fqU3Vq7iUuE
	FAIPyXwQeiREMjSdqTffcF9XXrnDdq1AJNa6JOB/t1wLH3zrqw95YtUxSri1+g2H
	ZD12EzlTmbGnQ9mBTh/uScL1xHbC9HRNkY9mzt/8c47o1BM7/4Nj9qxV7Eo+icAr
	xPcplpQEFJ2J3Ae1m7qq/0pZjKt+4kQxP3l/H96cKbOTaO21f6VH0KKlRL0hhmBS
	nEjW79+HQT0XC8E4DR5kB+nMdXPrE8bx8GvoVXL8osh+7kVrdvow==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yb43045m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:43:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584D2HuQ036253;
	Thu, 4 Sep 2025 13:43:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbjv6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:43:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfEZVY+0qrW5Z8iHaT4HCfl9UC20OOBjS7pgEYCabtT2lIeQIQu+Ea+a6+tUh69Jsu8zF3j/Mw3458973FlCG8MS/bL/whIiXoUfr//HsiBFVasDl8Ht59g90AYREkTVxKLTW5VLk4Qf5hlt9t+zL8uycFWM/JpHnkofJ8BDYrlA7b8v6Jg2F31gZQWwFAqr/TWtJwOl3phfwQhNV/mH3MrxP8FShlTr+fZgFfty/mTV354I0axkCJmnZSXvOAWlY6FtJujYAM0exol+bXxBmCeXf9e9cJFR8Ao36azseMB7gloPmQZAqJfwPLyTOPMX+s1kZlF4cxhcpqelGsPwCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2eL19uvqkyeRfnQTgnMmPTeTUUuVMJB+MV/u9voi9s=;
 b=vX5wCh8pz6+0cCPYkayotq+e1YWf8rH0KJ3Zo9NBXCvNIFcpeKYck3YrPDW7EQJ1AHBISKc88L3plt8oYmpE7hb+XZHRQq7saP48nLU7t8tophLN9WhSLqO1IfQWCIlD4p7LJCh6PSB/eb2oP/Q2N2R/DfknmW/2W1VLzmxy4GoYC6fxiJj3iWu0EFNJAeVi7OPl/VBR71GNz/ZHosbJXNSoJ7GmyzmBkwV5Yb4HfedmCGQdFhaolagd6aXwJm+8mWcWzdIG/xfLlJ0QGiIuqqMqGkMExm+BeMWFM6a1bR3lWoJebtMhH6u1/kRYDLwFe4UVCZCSb3Xh6zS5CXBc1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2eL19uvqkyeRfnQTgnMmPTeTUUuVMJB+MV/u9voi9s=;
 b=i6pundF/93JAcLH4ZQv+Wby3XnuVY2TjmOWEVsWYIn/wlkxADDexoKCsVHd6FeBqw6q2ZiC0JRgyXf6Rkmfw6UAuZ1yDkhKkF2Hd+poix7hb9ktWFigrdEUzsb3LIKMSPUomw90/cdWwXe/6sBpbkzOdaZPnn2ptherI9I4wG+w=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7066.namprd10.prod.outlook.com (2603:10b6:8:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 13:42:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 13:42:57 +0000
Date: Thu, 4 Sep 2025 09:42:53 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Message-ID: <2ts445ufkl7mhtdd3ucs2c6lsp7fxbx6b5tqmu2tdecxprok55@fdr2dwppnoks>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>
References: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
 <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
 <aLmWF3V8ILOkL8W2@smile.fi.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmWF3V8ILOkL8W2@smile.fi.intel.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: edc01025-ac03-4ed4-37e9-08ddebb8f4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zKi9Jt+w9yrNzNvPu2Bik3QMLn4Bif2MNmSgbxZmDyc0nE4tu+1Vyn2IBCwu?=
 =?us-ascii?Q?BEiP8tTBuJ4YETbsM5eIsCQ1jSi4jtLLi3feUJ38C0Vb4ltuihYrSY5Q94k4?=
 =?us-ascii?Q?oMdTcD3o8QujCPy/l6ZPJ2KXo75fILBihTYm8l4FbhpIqqbQ3ofFrt+oQdBX?=
 =?us-ascii?Q?0H3g3QWLlxQt998bXt5X182xQh7aN24FDkcvwE4bB+YuZXiFNuedpgWPxb6F?=
 =?us-ascii?Q?8hKskP3VqOdc0rXGUZ86AMJgJOHPIGaEr9zjRcEWa+vhBd2Lyf6rddElkphw?=
 =?us-ascii?Q?+weiMYK3q78/85wtT7aqhEEfm/EL1vQKjs3xuCiqIJXmLupOIDETMGwj6DJP?=
 =?us-ascii?Q?4kDRXa9n/21GiOAzqxpnGRJGXXLLAGF7nZXIP5sZ4a6fYIPS8oxKDj4TTa2e?=
 =?us-ascii?Q?lOHhWMkSjj8KUKTCeE6l09p5q8a0CYeMAwt/AxNlPp6xI8YoJn0rU3LPAZjb?=
 =?us-ascii?Q?bPAlvwqciqEJXBCfkHyaUxNe/7/h18OxSSWSCV0/8Z12qFt3i0lZCiD58GH1?=
 =?us-ascii?Q?cItniqzBQ0UCC0/qo5vCSt2Wq4F+CQ5ofXnRBXqxn3m2q2VPFzV/8MMKT/NB?=
 =?us-ascii?Q?tg/OFVfHBJify28jCvksmWFaDfETWMRgswaUEM8QWYvvq4yPetHapLJhnRga?=
 =?us-ascii?Q?hC+nkYRrg049dNHaHG4k1WBdjcPxTSWT7ilrSIKYg5uvGWjVkshHl1FD6PUq?=
 =?us-ascii?Q?2Ok9dEGlKeoi5W7VbElyNio7J8xKoOJcP2kd/c/Z8YuTtsldGgHIEmGyduyC?=
 =?us-ascii?Q?5oB3SRMMeRVqxv3DtlTw11lkaVDIhAjIGnyvyqLlMjoapeJfyjclR6qWF7PM?=
 =?us-ascii?Q?pxF/06Q8KFEJDzn1emIQeauMd0FeJOza6/Gn7CKKm6DZ6NO0FchQK/r4G2t+?=
 =?us-ascii?Q?BJWWMlGtFYgV3grAHWdvl3KfSClkpz2drPVZgB1Ue4gv116sBOt/FC8VJtWQ?=
 =?us-ascii?Q?JPi8kPgiywzK6cFhvAhKKciyR6+b4HkHCoHs4Q1Id5TRiBvSGE5cSzHmrGIs?=
 =?us-ascii?Q?MiK+4J5ErzoLm0kN6BBzGSpdy4rca1mw2peOJt8nchVlHzvl5+1bldBb8kVP?=
 =?us-ascii?Q?upbb/n7iFH9WLmWbWTiM9d+QNiBagB0mcg5tXhJUfg9Ng9GzQutYxIXTVrUG?=
 =?us-ascii?Q?ZAUPe8C0/dhBsQcxUmCotyX5lZmsEbWySIuC1B24/ayfM4YOx3xCI/ByXIl2?=
 =?us-ascii?Q?TPKAo0yKMgaXBbBqvXr3oZhAAGZvLMniwQVa3cIQh31P8b3/ephJgtPwfmii?=
 =?us-ascii?Q?xt5Bguj5Xe0I6u4PNmpc9fJ1vqylBE5dfFwGdvjIg8KLrDRsHjeHrYNZJ9Iv?=
 =?us-ascii?Q?isNt31aPt7TYo/C/7jDknunTORo+pdV91Ak4VIW1h328VzS8r11d53ujYP50?=
 =?us-ascii?Q?XrhT1ocOkhKNP4BEHNPkkABhGc/5ZyJ9bZBtNtul8k6oWP7Z+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v93R8nWus4Drnm9debuWoynb9Lh3l7gkz47SDW49nBPOoFoSa6ZZ5ReENOgi?=
 =?us-ascii?Q?P+gAFG2ii/WdmR0rNxoH1ybtvegrb4w9Lq3M5j4oj1IJfw/30PZFYZKdt/T7?=
 =?us-ascii?Q?WtnhQgzoLMHSXDu5847AgiEWfVflXQkEwEuw08Jw0VHqbbtvgfqlqXob4Jg9?=
 =?us-ascii?Q?RU1Gi23/Q1CzAkzNnne13ivxHddQaQLWWbKH1W7zJq37EOpRURLLRfKXY0Eq?=
 =?us-ascii?Q?GAXb7ekQhJnn9Pa04wkSWwCL6PX03nFJ87rKT8AA9oDApzaCPSETJNmGtZyd?=
 =?us-ascii?Q?zTb/rjfEWCXpVs4y8oOlQYCAdUSHr3EWKUUgmXPpm27J472ZYsNBf81TQ0I1?=
 =?us-ascii?Q?xjA1qNRXjhNiFCRlBGy5UJap/D499w5nmMDn04ol33e45vkreNjOZycn+Vnd?=
 =?us-ascii?Q?RVF21tVosXHDsUbdbshBgANhN6dg1naoUddwKOeRfWhSkn6Ii7bMkUzCEIV3?=
 =?us-ascii?Q?v7UaAVJnly607ZpRoJO1TC9GUKzqoxTHYtOQgISohinquFPC0UU/aQ4kXBqE?=
 =?us-ascii?Q?Dq8JQ0YHaFfgK247rg+XR3UyYirfO+JBVBqjpHHtVccbDE05TwG+bbdar2Qn?=
 =?us-ascii?Q?DtujCqFGhbqrZ5fLckzXcMtIn33BKDQ+jp/QIi/TA+O4Yg7FEkIItK5UjfGm?=
 =?us-ascii?Q?a9sEn2OuUA1e/WWTvSwYJ9wLAUfWqZhIQvwH7LVRl6gPBp23tgD/FY/TV+9m?=
 =?us-ascii?Q?/sUpuzWSQlUE9ZVDKLYGeDsji3IWwvsx2sHy8hJhzQJqjiaIU7v6Cv0jw8A4?=
 =?us-ascii?Q?w2B3msVAeUFk7Tjov4QXZIlyhYEN9xYntV6vYwa3TvCjYiiaMU5zsmyb8WSv?=
 =?us-ascii?Q?lLPbJe/rHxqS/IbFHoyWkz8mbct9U0HVI51zgHISucJM3IKumrAopH1UdBzs?=
 =?us-ascii?Q?P2eiIAtxZVNB6KFSBI3Bo8MjPW96HHMdIXd9gcKUZhMB2W47ZpwGmlb0VX7D?=
 =?us-ascii?Q?dNYbf3haGbsxME+3LfkHVHsN0AKT8fIBq+ysb71ZbKjbCz/8gh4NEQn2EVPm?=
 =?us-ascii?Q?3v7/WZ3GcHliSwMxmcLguTsdy6MgxcE/nvfJpBctTyDq6G0/Xkkb+nYwBGM9?=
 =?us-ascii?Q?0H2RJu4IynOeKANXyfE98k0Nv8X8uU1cUQb6w+1qG2pw8PV3l+dSE+pNg653?=
 =?us-ascii?Q?NZOG8vf7zIoTk5gYrugWR3utsx3YFTq+qBGTXGsfFTXKWvtyYociX11mdzKI?=
 =?us-ascii?Q?kzNwlVhuOR6jBqrGY8kROukZE6qiLWninv94YQHBp4IQke/JzVVcZGVbVpB1?=
 =?us-ascii?Q?+mnjX33LFY4OFefufih2MgDLh1d3G6jryYxkVGeIN9JBvEJbgVSCsnMId3I/?=
 =?us-ascii?Q?khqTaAC3ZTp4U1W58L0r/u1DlSUXuvmCV+do6Ds5h9FZgRuqNGENrO1d0W/f?=
 =?us-ascii?Q?g4eRSWZr5iGcHabgEekjktogGBc1/0u2bwFTRQMPqihDEPDJz2aW0/0ZZxRt?=
 =?us-ascii?Q?6wNhspfoVTxoOTCfT/R1EhotSGrXluA/y+LCVDWTpeeZIyBfdGLZXe/OGOx9?=
 =?us-ascii?Q?pa5DO2/L5S9W3LSSoumGU7dZeL1V+cBsl7nDbcF9kFC6i47pYyAP/N+yzvat?=
 =?us-ascii?Q?qSXlCk/8t7mlJYJoUFyTL02/jg/F8CuEqyV5U44T?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CQxrJCsFiXeVX3n5dIYK/He4YMkwC1+AwFgv7roZcBKgT+LFJwhWctUa7ezzkhwhLkmAXNwttUXqzEQ7how/nPHeeeTwuxKCyQw4txU00uhEQgjkUoFZ+mBPx5YYrQY6mdYW47BZX9V+cYS/uf1S8+b4M9N9kYOYP7VM4FDDimoIlGEbuSnxMevsmqrU0EO43PK9d5+NRtEJQAu0cflh7Fqf/4xFgzaceivwvAvQoSs4vbvpx8E5FViKUH1E3SKjHLQb+7yxLbJ+6LLSolHpcLH02FO5uSHkiqCXdsniUsOTXoTHytTRVSq9JDYPwg52J4YA15ozOWskhhZmNPELaqjGoOc/8NONGo0ynAHHqnXgojnri6/3IeK+cJLKXjeoaF+wwIm0ICKvru/3ghLfRLS337gKP+81h3RNzBLFq9R6O/O6exbYXOiBfumXh5SKRD+mLqfg7xPawoppUrzmNhnBM8SqmoNw5eFX9+yirtM5N1mGDPIoPGwqXiF08IBeTWS4pF6A0k18/2lhpZBGW7IRBngkiC6RppXt3yhGSUdXUq89GHtDELvZy3SbxTVYB1viO9rhJQDnFe9/ws/9TkILLTylcWsZTNRQ1grN3+o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc01025-ac03-4ed4-37e9-08ddebb8f4d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:42:57.2048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efmceHbGa/jpZPFp2iIKzMRaGUuAnO4JCtf+gHdpt9my5YLEu8LcsOnbbyTPm4g6BAUd8o4dDmP1xzRuHelr4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=830 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEyNyBTYWx0ZWRfX6ZrVB340covK
 MkS6wm++h713QyRsaEtWKkDVZEXpR+7KYb/8rq7YS1spQdZ2bl9GZU2n9bDYregfFt6wrJHmRRd
 oJcSrGy9uLisMp+qkaYUj/PkE+7ma+toBwN0IEfo/Nx4jN74egj9jLZzURBTYIwZe8JNl7TY7EE
 F7ToTY6JoFk9DVYBXnjbDOx8+uFlIJCyF3ZXhfEe6vQdVJbGuoF7qdL/0fVCM5/lfI8HuDglKUI
 OwCdL/GC2NgGHMMZD7A06VzuBepB/mQyjSES+k+JAdaYfoHXApqFjAmyP9w63INIEASVIHso+PI
 4AuVSbF7isUAGF+hBWzPaNpoxKbYzxBlArumK+fNid4L73dQLmSO7fGEbozKj7anhyuK1NFGOPS
 nGQaAaf/
X-Authority-Analysis: v=2.4 cv=FM8bx/os c=1 sm=1 tr=0 ts=68b99766 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=Wm5M4ToSKWjrba0siNAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: asNFU2Sxy4uVBmkMotmN9k5r9LbnlU2u
X-Proofpoint-GUID: asNFU2Sxy4uVBmkMotmN9k5r9LbnlU2u
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DB30A0019
X-Stat-Signature: bxrznwfo3hcijbjq3b4zh46b56iebk1e
X-HE-Tag: 1756993387-475311
X-HE-Meta: U2FsdGVkX1/fJnCj1DwHIyENzHQFkvfjKXSZiY5SW7CCz8bk+r4C73k8RfPViqf24m54RUBenuxgX5ya2xwqK+5O5zlHCvNT8W5QQO0hJbaGp2Znk5fYqJ11SVf7I/Xw2wuJ3tbmztbmJMVLGz0FZZZPa3DuU3HbmL9Mc+32N6whSseknleHLQelm7ae+gvC4hJNRIzVkbXkIVopgok5kDWnDlJFesTEiguelK8zH1fRMGM/We899zYGh9lNgPYlOZLl7bcA5I9BsO9ZdkyTBkI0NYphUtEvzcAmLM39/AT2p+V+2oYIz/HXgSVX1twssRzGVM2QR7cBqqfIcusBUmULHdBw47eR7LVvjNtd+Uwn7VjR61mlG0EaWXRD8THq76Sihft8I7xSpDpVrCLlRNAkEYKr5+iDcmFhacMcYukQIG7c2iuEKsHdo5dVnMxieA2sdcADa8FzOct6UfJ2jV2JP6LggCyTgGQnUl8QS4Xq50N0WTPxcPW44xZEnZdWUO7HDzTk5yqe32sZQwWEuM7xKoF81HnOUwqUgg5sEzvVJDfc5tRhcNG7pbdM2vNdkB+IXHd1Uf3R0pDLPV3ADlczpDnv6Ac6tOMLK5eDCuJrfZLx7wpwCJ2MWJzgPjGgvVTgYyT/+VWK1Fmr9cvUxZT02f1OE5+hfxnh5WoZgG0sCF2Fz56FhXVeqQY+wORH6dZZbxO0czMufrtBMvWRtDnRksfm34ZiNM+ueFsDip2yFneLApL1tef2Pa9o6clygGo/XlIkX4QMs/PcFQItsMjHfRGoUd8aY6zvtZvc8yvHP3lsmfB2pQLUaJDMQHMBmftenzseu+0fZGNh9V6tX7oUXbnLJVaQFc7/ofed9qmdrMGRXMF6yftwL40PE5LQA6+OEp5ztwiGhVlqsgvu927IaVq/2adXXY+CD9aPZzOLmO+F6SxX9iVwhDtGCz6JKrHnEogQGEfsXD87DgX
 4RAM8T4O
 Ewt8XoMiJ9RR25tORnQvPp9HrsuWkm4P1VuCCxqZFsxKb6+MF8V367NYGZnWxxJaQFoNVruGKGhc2UFKvEj4dn/k+yTfCnMTlniYTwGRcl1G91BvqUX+GPkhJbbwJnEF1qRh4kysnwD/gFw96pUZgroKTACNTV4UsueRb1qGw4m5Ukk3LhKMdrU7MphtTdVfpQTsG7cjEXkHcZ8MIUE3UCKKfcUU22TbR75f6NpSaGE3wJ9cvxbh8C/pzIb63QYmqdsYOVzFxN6aS8IwhvmpBQNl2v+sJDbdIZSZx8NapziD/AqEbqJ5rEAN0QXR/qFbLEgxsdMwhLQIJ+m1pHGqC6VAxn9q9JPrvfS6aHQ/1xkk5O5ZCPMuZdf3gAZ1Sj6FlUoYVgvVpsG4jW2Pk1DP2lbBexPnvooA1a0iR2VamDkfmGAwLv1ZoHB9G82cDO6ShqjTMd5i+y3lpHen/k6sNgL8dPyDsXkuq00FNM83PySanmFhU1klLsBOynm7QnFZRtPUgqcRsMQlELTJ2p6sGoLYvUFJnlelfAIYFP2C32g2xEeV54dLcH0mXV2TrmSCCgAPgXIsOWEWSU3Y46onqkR1H/c2YT8RRrdcGXlamqlQm8y8xHrgm9NGnR7i3yes64RvDkpMTSIYFZo0exBFSyOu59uCOVrcXZdlwEkSiTo6rjvbvVI1F4RAT7pimexj7ic4k3mc0jyptoBJMCT0qxxJejUnm+RHWII76WLC6m+RcJvAe7XBn4LRo+eJGX7svHzG/xU9KtGlXp9DQK3L2eTk8CxzrbJsyqkBY6/fyOrAzGMrRt/kFjiUDBKGd/mwShPGqnPJU+tAbKkrxGr7vJ9AilNYwf/0RuYNbUHxi+fouhL2YcA64y07RWGtuMWb7ErdK/t5vKZqxagZ4LcqfQ/P9Vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 09:37]:
> On Thu, Sep 04, 2025 at 09:32:52AM -0400, Liam R. Howlett wrote:
> > * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 05:04]:
> > > clang complains about unused function:
> > > 
> > > lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]
> > > 
> > > Fix this by removing unused code.
> > > 
> > > Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > Thanks.  This should be squashed into the patch listed in the fixes tag
> > since it's not a stable commit yet.
> 
> I fine with any solution, I just want this to be fixes rather sooner. So, please go ahead!

Sounds good.  I've added Vlastimil to the email as it went through his
branch.

Can you please Cc the SoB people next time?

Thanks,
Liam

